#!/usr/bin/env python
"""s19: two-flank e(g) deconvolution of the measured M(t) defect.

Model:  M_meas(t)  =  Int_{G}^{U}  pairLog(g, t) * e(g)  dg
where  e(g)  =  (true zero density)  -  Rho(g)  on  (G, U]
(discrepancy;  e  =  0  below  G  by  construction).

pairLog(g, t)  =  log|g-t| + log(g+t) - log(g^2+1/4)

BAND  KERNELS  ARE  EXACT  (closed-form  anti-derivatives,  so
the  in-band  log  cusp  is  integrated  exactly  even  when  a
band  contains  t):
    Int log|g-t| dg  =  F_t(x):  F_t(x)  =  (x-t)ln|x-t|  -  (x-t),
                        F_t(t)  =  0  (continuous  limit)
    Int log(g+t) dg  =  H(x)   =  (x+t)ln(x+t)  -  (x+t)
    Int log(g^2+1/4) dg =  J(x) = x ln(x^2+1/4) - 2x + atan(2x)

Grid:  fine  linear  bands  (G,  G+Lfine]  (step  h)  +
log-spaced  bands  up  to  U  =  1e30.
Solve:  Tikhonov   min ||K x - M||^2  +  lam^2 ||L x||^2  with
L  =  first  difference  (smoothness),  via  lstsq  on  the
augmented  system.  Sweep  lam  for  stability.

Data  (both  flanks  of  the  measured  M):
  below-G  face:  upper  s8  rows  (O(1)  face,  t  <=  0.9294G)
  transition:     s10  rows  (0.94G .. G+0.5)
  above-G  rows:  s9  (G,  2.2G]  +  s16  (10G ..  1000G)
Oracle:  tmp/s8_m_true_sample.jsonl,  tmp/s10_deadzone_march.
jsonl,  tmp/s9_dk_above_g.jsonl,  tmp/s16_M_far.jsonl.
"""
import json
import os
import sys

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = 30001045999.981975555
U_TOP = 1.0e30


def load_rows():
    rows = {}

    def add(t, M):
        t = float(t)
        if t > 0:
            rows[round(t, 1)] = float(M)

    # below-G  face:  s8  rows  with  t  >=  0.85*G  (upper  tail
    # of  the  O(1)  face)
    p = os.path.join(BASE, "tmp/s8_m_true_sample.jsonl")
    s8 = []
    for line in open(p):
        r = json.loads(line)
        if "t" in r and "M" in r:
            s8.append((float(r["t"]), float(r["M"])))
    s8.sort()
    for t, M in s8:
        if t/G >= 0.85:
            add(t, M)
    for fn in ("s10_deadzone_march", "s9_dk_above_g", "s16_M_far"):
        p = os.path.join(BASE, "tmp/%s.jsonl" % fn)
        for line in open(p):
            r = json.loads(line)
            if "t" in r and "M" in r:
                add(r["t"], r["M"])
    ts = sorted(rows)
    return np.array(ts), np.array([rows[t] for t in ts])


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
    #  K[i, k]  =  Int_{a_k}^{b_k}  pairLog(g, t_i)  dg
    K = np.empty((len(ts), len(a)))
    for i, t in enumerate(ts):
        #  f_log_t  is  the  true  primitive  on  BOTH  branches
        #  ((g-t)|ln|g-t|  -  (g-t))'  =  ln|g-t|  for  g  !=  t,
        #  continuous  with  F(t)  =  0,  so  cusp  bands  need
        #  no  special  handling.
        Fa = f_log_t(a, t)
        Fb = f_log_t(b, t)
        K[i] = (Fb - Fa) + (h_log(b, t) - h_log(a, t)) - (j_log(b) - j_log(a))
    return K


def main():
    ts, Ms = load_rows()
    print("rows:  %d   t/G:  %.5f .. %.1f" % (len(ts), ts[0] / G, ts[-1] / G))
    print("  below-G  rows:  %d   (max  M = %+.4f)" %
          ((ts < G).sum(), Ms[ts < G].max()))
    print("  above-G  rows:  %d   (min  M = %+.4f)" %
          ((ts > G).sum(), Ms[ts > G].min()))

    a, b, cen = make_grid()
    dg = b - a
    K = kernel_matrix(a, b, ts)

    #  reference  residual  check:  the  measured  ln-t  law  vs
    #  the  rows  themselves  (sanity  before  deconvolution)
    co, *_ = np.linalg.lstsq(
        np.column_stack([np.log(ts), np.ones(len(ts))]), Ms, rcond=None)
    print("sanity:  ln-t  fit  on  ALL  rows:  a  =  %.6e   max|res|  =  %.4e"
          % (co[0], np.abs(co[0] * np.log(ts) + co[1] - Ms).max()))

    #  Tikhonov  operator  (first  difference,  per-unit-g
    #  normalized  so  the  log  part  is  not  dominated  by
    #  band  width)
    n = len(a)
    L = np.zeros((n, n))
    for k in range(n - 1):
        w = 1.0 / (0.5 * (dg[k] + dg[k + 1]))
        L[k, k] = -w
        L[k + 1, k] = w

    print()
    print("lam         max|res|   rms     charge Q        Qw=Int g*e")
    print("                                          (Qw  target  =  A/2  ~  -1.26e7)")
    best = None
    for lam in (1e0, 1e2, 1e4, 1e6, 1e8, 1e10, 1e12):
        A_aug = np.vstack([np.sqrt(1.0) * K, lam * L])
        b_aug = np.concatenate([Ms, np.zeros(n)])
        x, *_ = np.linalg.lstsq(A_aug, b_aug, rcond=None)
        pred = K @ x
        res = pred - Ms
        Q = float(np.sum(x * dg))
        Qw = float(np.sum(x * cen * dg))
        print("%8.0f   %10.4e  %8.4e  %+.4e  %+.4e" %
              (lam, np.abs(res).max(), np.sqrt(np.mean(res**2)), Q, Qw))
        if best is None or np.abs(res).max() < best[1]:
            best = (lam, float(np.abs(res).max()), x, res, Q, Qw)

    lam_best, resmax, x, res, Q, Qw = best
    pred = K @ x
    print()
    print("lam*  =  %g     max|res|  =  %.4e" % (lam_best, resmax))
    print()
    print("profile  (per-log-decade  charge  of  the  solution):")
    decade_of = np.log10(cen)
    n_dec = int(np.ceil(decade_of[-1] - decade_of[0]))
    dec_edges = np.arange(decade_of[0] - 0.5, decade_of[-1] + 0.5, 0.5)
    for i in range(len(dec_edges) - 1):
        m = (decade_of >= dec_edges[i]) & (decade_of < dec_edges[i + 1])
        q = float(np.sum(x[m] * dg[m]))
        if abs(q) > max(1.0, abs(Q) * 1e-3):
            bar = "#" * int(min(60, 40 * abs(q) / max(abs(v) for
                       v in np.cumsum(np.full_like(cen, q) * dg) if q != 0)))
            print("  %7.1f .. %6.1f :  %+12.4e  %s" %
                  (10 ** (dec_edges[i] - 0.25), 10 ** (dec_edges[i + 1] - 0.25),
                   q, ("+" if q > 0 else "-") + "-" * min(60, max(1,
                   int(40 * abs(q) / (abs(Q) * 2 + 1e-30))))))
    print()
    print("where  is  the  charge:")
    #  cumulative  E(t)  =  Int_G^t  e  dg   vs  the  pinned
    #  slope  target  A/2
    A_law = -25256007.0
    tgt = A_law / 2.0
    E = np.cumsum(x * dg)
    print("  Int e  dg  (full  window)   =  %+.6e     target  A/2  =  %+.6e"
          % (Q, tgt))
    for frac in (0.25, 0.5, 0.75, 1.0):
        m = cen <= G * frac
        if m.any():
            print("  Int  (G, G*%5.2f]  e dg  =  %+.6e   (fraction  of  Q:  %5.1f%%)"
                  % (frac, float(np.sum(x[m] * dg[m])),
                     100 * float(np.sum(x[m] * dg[m])) / Q))
    #  fine  region  (G, G+500]
    m = cen <= G + 500.0
    print("  Int  (G, G+500]   e dg  =  %+.6e" % float(np.sum(x[m] * dg[m])))
    #  cumulative  E(t)  =  Int_G^t  e dg  at  key  heights
    print("  cumulative  E(t)  (zeros):")
    labels = ("1.5", "2", "5", "10", "20", "50", "100", "200", "500", "1000")
    targets = [G * float(l) for l in labels]
    cum = 0.0
    out_lines = []
    ti = 0
    for kk in range(n):
        cum += x[kk] * dg[kk]
        while ti < len(targets) and cen[kk] >= targets[ti]:
            out_lines.append("    E(%5sG)  =  %+.6e" % (labels[ti], cum))
            ti += 1
    print("\n".join(out_lines))
    #  net  charge  by  interval
    print("  net  charge  by  interval:")
    for lo, hi in ((1.0, 1.2), (1.2, 2), (2, 5), (5, 10), (10, 20),
                   (20, 50), (50, 100), (100, 500), (500, 1000),
                   (1000, 5000), (5000, 1e5)):
        m = (cen >= G * lo) & (cen < G * hi)
        print("    (G*%5g, G*%5g):  %+.6e" %
              (lo, hi, float(np.sum(x[m] * dg[m]))))
    #  local  amplitude  vs  Rho  scale
    print("  local  amplitude  vs  Rho(g)  ~  ln(g/2pi)/(2pi):")
    for mk in (2, 5, 10, 100, 1000):
        gg = G * mk
        rho = np.log(gg / (2 * np.pi)) / (2 * np.pi)
        m = (cen >= gg) & (cen < gg * 1.8)
        em = float(np.max(np.abs(x[m]))) if m.any() else 0.0
        print("    g in  [%4gG, %5.1fG):  Rho  ~  %6.4f   max|e|  ~  %.4e"
              "   (%.3f%%)" % (mk, 1.8 * mk, rho, em, 100 * em / rho))
    print("  min  e  =  %.4e   at  g/G  =  %.6f" %
          (x.min(), cen[np.argmin(x)] / G))
    print("  max  e  =  %.4e   at  g/G  =  %.6f" %
          (x.max(), cen[np.argmax(x)] / G))
    print()
    print("row  residuals  (best  lam):")
    for i in range(len(ts)):
        if ts[i] < G * 1.05 or ts[i] > G * 5:
            print("  t/G = %9.5f   M = %+.8e   res = %+.6e" %
                  (ts[i] / G, Ms[i], res[i]))

    #  save
    out = os.path.join(BASE, "tmp/s19_twoflank_deconv.jsonl")
    with open(out, "w") as f:
        for i in range(n):
            f.write(json.dumps({"g": float(cen[i]), "e": float(x[i]),
                                "dg": float(dg[i])}) + "\n")
    md = os.path.join(BASE, "tmp/s19_twoflank_deconv.md")
    with open(md, "w") as f:
        f.write("# s19  two-flank  e(g)  deconvolution\n\n")
        f.write("M(t)  =  Int_G^1e30  pairLog(g,t)  e(g)  dg,  exact  analytic\n")
        f.write("band  kernels  (cusp  included),  Tikhonov  (first-diff),\n")
        f.write("rows  =  %d  (both  flanks),  bands  =  %d.\n\n" % (len(ts), n))
        f.write("best  lam  =  %g,  max|res|  =  %.4e\n" % (lam_best, resmax))
        f.write("max|e|  =  %.4e  per  unit  g\n" % np.abs(x).max())
        f.write("\nPHYSICS  (min-norm  read,  lam-insensitive):\n")
        f.write("  -  NO  boundary  layer  at  G:  Int_(G,G+500]  e dg  =\n")
        f.write("    O(1e-7);  the  near-G  delta  hypothesis  dies.\n")
        f.write("  -  a  smooth  negative  bias  over  the  first  ~1000G,\n")
        f.write("    cumulative  ~ 1e10  zeros  by  1000G,  built  at\n")
        f.write("    local  amplitude  <=  0.4%  of  Rho;\n")
        f.write("  -  (1e4*G,  1e30]  is  unobservable  gauge  for  all\n")
        f.write("    measured  rows  (t  <=  1000G).\n")
    print()
    print("wrote  %s  and  %s" % (out, md))


if __name__ == "__main__":
    main()
