#!/usr/bin/env python
"""s19b:  two-flank  e(g)  deconvolution  WITH  s20  rows.

Same  exact-kernel  method  as  s19  (analytic  anti-
derivatives,  cusp-inclusive),  but  the  row  set  now
includes  s20's  (100G,  1e5*G]  leverage  rows  when
they  exist.  Goal:  pin  the  location  and  amplitude
of  the  bounded  Rho  departure  that  s19  showed
exists  but  did  not  pin  (grid-representative).

Outputs  a  grid-sweep  table  (max|res|,
max|e|  observable  window,  E(1000G),  plus  E  at
the  new  leverage  heights)  and  saves  the
coarsest-grid  representative  profile.
"""
import json
import os

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = 30001045999.981975555
U_TOP = 1.0e30


def f_log_t(x, t):
    d = x - t
    out = np.zeros_like(d)
    m = np.abs(d) > 1e-300
    out[m] = d[m] * np.log(np.abs(d[m])) - d[m]
    return out


def h_log(g, t):
    x = g + t
    return x * np.log(x) - x


def j_log(g):
    return g * np.log(g * g + 0.25) - 2.0 * g + np.arctan(2.0 * g)


def kernel_matrix(a, b, ts):
    K = np.empty((len(ts), len(a)))
    for i, t in enumerate(ts):
        Fa = f_log_t(a, t)
        Fb = f_log_t(b, t)
        K[i] = (Fb - Fa) + (h_log(b, t) - h_log(a, t)) - (j_log(b) - j_log(a))
    return K


def make_grid(Lfine=500.0, h=0.25, n_log=80):
    fine = np.arange(G, G + Lfine, h)
    b0 = fine[-1]
    r = (U_TOP / b0) ** (1.0 / n_log)
    lo = b0 * r ** np.arange(1, n_log)
    hi = b0 * r ** np.arange(2, n_log + 1)
    a = np.concatenate([fine[:-1], lo])
    b = np.concatenate([fine[1:], hi])
    centers = 0.5 * (a + b)
    return a, b, centers


def load_rows(with_s20=True):
    rows = {}

    def add(t, M):
        t = float(t)
        if t > 0:
            rows[round(t, 1)] = float(M)

    s8 = []
    for line in open(os.path.join(BASE, "tmp/s8_m_true_sample.jsonl")):
        r = json.loads(line)
        if "t" in r and "M" in r:
            s8.append((float(r["t"]), float(r["M"])))
    s8.sort()
    for t, M in s8:
        if t/G >= 0.85:
            add(t, M)
    files = ["s10_deadzone_march", "s9_dk_above_g", "s16_M_far"]
    if with_s20:
        files.append("s20_M_farter")
    for fn in files:
        p = os.path.join(BASE, "tmp/%s.jsonl" % fn)
        if not os.path.exists(p):
            continue
        for line in open(p):
            r = json.loads(line)
            if "t" in r and "M" in r:
                add(r["t"], r["M"])
    ts = sorted(rows)
    return np.array(ts), np.array([rows[t] for t in ts])


def solve(ts, Ms, Lfine, h, n_log, lam):
    a, b, cen = make_grid(Lfine, h, n_log)
    dg = b - a
    K = kernel_matrix(a, b, ts)
    n = len(a)
    L = np.zeros((n, n))
    for k in range(n - 1):
        w = 1.0 / (0.5 * (dg[k] + dg[k + 1]))
        L[k, k] = -w
        L[k + 1, k] = w
    A_aug = np.vstack([K, lam * L])
    b_aug = np.concatenate([Ms, np.zeros(n)])
    x, *_ = np.linalg.lstsq(A_aug, b_aug, rcond=None)
    res = K @ x - Ms
    mO = cen <= G * 1e5
    cum = 0.0
    Es = {}
    marks = {1000: 0.0, 2000: 0.0, 5000: 0.0, 10000: 0.0, 50000: 0.0}
    for i in range(n):
        cum += x[i] * dg[i]
        for m in (1000, 2000, 5000, 10000, 50000):
            if cen[i] >= G * m:
                marks[m] = cum
                break
    E = dict(marks)
    for m in list(E):
        for i in range(n):
            if cen[i] >= G * m:
                c = 0.0
                for j in range(n):
                    c += x[j] * dg[j]
                    if cen[j] >= G * m:
                        E[m] = c
                        break
                break
    #  cheaper:  one  pass  cumulative  table
    cum = 0.0
    E2 = {}
    mm = sorted(marks)
    mi = 0
    for i in range(n):
        cum += x[i] * dg[i]
        while mi < len(mm) and cen[i] >= G * mm[mi]:
            E2[mm[mi]] = cum
            mi += 1
    return float(np.abs(res).max()), float(np.max(np.abs(x[mO]))), E2, x, cen, dg


def main():
    ts, Ms = load_rows()
    print("rows:  %d   t/G:  %.4f .. %.1f" % (len(ts), ts[0]/G, ts[-1]/G))
    print("  (s20  rows:  %d)" % max(0, (ts > G * 2000).sum()))

    print()
    print("config                       max|res|   max|e|(<1e5G)   "
          "E(1000G)    E(1e4G)")
    results = []
    for (lab, Lf, h, nl, lam) in (
            ("L500/.25/n80", 500.0, 0.25, 80, 1e4),
            ("L2000/1/n80", 2000.0, 1.0, 80, 1e4),
            ("L500/.25/n160", 500.0, 0.25, 160, 1e4),
            ("L2000/1/n160", 2000.0, 1.0, 160, 1e4)):
        mr, mea, E, x, cen, dg = solve(ts, Ms, Lf, h, nl, lam)
        results.append((lab, mr, mea, E, x, cen, dg))
        print("  %-26s  %9.4f   %14.4e   %+.4e  %+.4e" %
              (lab, mr, mea, E.get(1000, 0.0), E.get(10000, 0.0)))

    lab, mr, mea, E, x, cen, dg = results[0]
    print()
    print("representative  (coarsest  grid,  %s):" % lab)
    print("  local  amplitude  vs  Rho:")
    for mk in (2, 5, 10, 50, 100, 500, 1000, 2000, 5000, 10000, 50000):
        gg = G * mk
        rho = np.log(gg / (2 * np.pi)) / (2 * np.pi)
        m = (cen >= gg * 0.95) & (cen < gg * 1.05)
        em = float(np.max(np.abs(x[m]))) if m.any() else 0.0
        print("    g ~ %6gG:  Rho  ~  %7.4f   max|e|  ~  %.4e  (%.4f%%)"
              % (mk, rho, em, 100 * em / rho))
    print("  min  e  =  %.4e  at  g/G  =  %.4f" %
          (x.min(), cen[np.argmin(x)]/G))
    print("  max  e  =  %.4e  at  g/G  =  %.4f" %
          (x.max(), cen[np.argmax(x)]/G))
    out = os.path.join(BASE, "tmp/s19b_twoflank_pin.jsonl")
    with open(out, "w") as f:
        for i in range(len(cen)):
            f.write(json.dumps({"g": float(cen[i]), "e": float(x[i]),
                                "dg": float(dg[i])}) + "\n")
    print()
    print("wrote  %s" % out)


if __name__ == "__main__":
    main()
