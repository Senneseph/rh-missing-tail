#!/usr/bin/env python
"""s33b:  PAST-THE-WALL  re-deconvolution (s33 far-deconvolution extended
with the C/quad-channel row M values past the mpmath wall -- 1e9G,
1e10G, 3e10G, rows s34f/s34j).  The question: does the g-side
position-amplitude degeneracy (window [1e10G, 1e12G] per s33)
BREAK at t ~ g0?  Same grid, same min-norm and parametric Part
A/B machinery as s33; only the row set is extended.  No novelty
beyond arithmetic deconvolution.  Run only after the s34f/s34j
B-merge rows have landed.  (The s33 header follows.)"""

# s33:  drift  deconvolution WITH THE EXTREME ROWS (1e8G/3e8G/5e8G).
# 
# Re-run of the s29 pin with the s30 far-extreme census rows (incl. the
# staggered 5e8G row, discovery 0096) added to the far set: the
# convex |M| curvature at the extreme rows (the t^2 kernel tail
# engaging) re-fits the g-side window/amplitude.  Same machinery,
# same grid, same part structure.  No wall involved (lstsq, local).
# No RH claim.
# 
# The s27 docstring follows -  --  where  in  (G,  1e30]  does  the
# measured  census  drift  come  from?
# 
# The  s25  census  found  that  the  smooth  ln-t  defect  law
# bends  above  ~2e6G  (drift  turns  on,  then  t^2-like  per
# doubling  ratios).  s27  asks  the  location  question  with
# the  engine's  OWN  exact  kernel  (same  analytic  anti-derivative
# machinery  as  s19/s19b,  copied  verbatim  from
# tmp/s19b_twoflank_pin.py):
# 
#   M(t)  =  A ln t  +  B  +  Int e(g) K(t,g) dg
# 
# Part  A  (min-norm  e  with  far  leverage):  the  s19b
#   min-norm  deconvolution  RE-RUN  WITH  the  census  rows  --
#   does  the  drift  localize  the  previously  unpinnable  bounded
#   Rho  departure?  (s19b  closed  at  the  smooth-data  limit:
#   the  location  was  grid-representative,  not  pinned.)
# 
# Part  B  (parametric  forward  fits  on  the  FAR  rows  only,
#   A/B  anchored  to  the  NEAR  face  by  lstsq):
#     P1  pole  at  h0        e  =  D  *  1-cell  delta
#     P2  power  tail  (g>=h0)  e  =  D  *  (g/G)^q
#     P3  lognormal  bump  at  h0
#     P4  density  fraction   e  =  C  *  (g/G)  (a  constant
#                               fraction  of  the  leading
#                               zero  density)
#   Forward  predictions  use  K @ e_vec  (exact  cell-integrated
#   kernel)  --  no  hand-derivations.
# 
# STATUS  at  writing:  contingent  on  the  in-flight  dps-80
# I_far  verification  of  the  census  rows  (s26).  If  that
# fails,  this  whole  run  is  void  and  the  rows  are  void.
# 
import json
import os

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = 30001045999.981975555
U_TOP = 1.0e30


# --- exact-kernel machinery  (verbatim  from  s19b)  ---------

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


def load_rows(s25=True, s21=True):
    rows = {}

    def add(t, M):
        t = float(t)
        if t > G:
            rows[round(t, 1)] = float(M)

    for fn in ("s10_deadzone_march", "s9_dk_above_g", "s16_M_far",
               "s20_M_farter", "s30_far_extreme",
               "s34_1e9G_row", "s34j_far_rows") \
            + (("s21_M_beyond",) if s21 else ()) \
            + (("s25_M_farcensus",) if s25 else ()):
        p = os.path.join(BASE, "tmp/%s.jsonl" % fn)
        if not os.path.exists(p):
            continue
        for line in open(p):
            r = json.loads(line)
            if "t" in r and "M" in r:
                add(r["t"], r["M"])
    ts = sorted(rows)
    return np.array(ts), np.array([rows[t] for t in ts])


def minnorm(ts, Ms, a, b, cen, lam=1e4):
    dg = b - a
    K = kernel_matrix(a, b, ts)
    # joint  (A,  B,  e)  solve
    J = np.hstack([np.log(ts)[:, None], np.ones((len(ts), 1)), K])
    n = len(a)
    L = np.zeros((n, n))
    for k in range(n - 1):
        w = 1.0 / (0.5 * (dg[k] + dg[k + 1]))
        L[k, k] = -w
        L[k + 1, k] = w
    A_aug = np.vstack([J, np.hstack([np.zeros((n, 2)), lam * L])])
    b_aug = np.concatenate([Ms, np.zeros(n)])
    x, *_ = np.linalg.lstsq(A_aug, b_aug, rcond=None)
    res = J @ x - Ms
    return float(np.abs(res).max()), x[0], x[1], x[2:]


def main():
    ts, Ms = load_rows()
    near = ts < 2.2 * G
    far = ts >= 2000 * G
    print("rows:  %d   (near <2.2G:  %d,  far >=2e3G:  %d,  "
          "max  t/G  =  %.3g)" % (len(ts), near.sum(), far.sum(),
                                 ts.max() / G))

    Lf, h, nl = 2000.0, 1.0, 160
    a, b, cen = make_grid(Lf, h, nl)
    dg = b - a
    Kf = kernel_matrix(a, b, ts[far])

    print()
    print("Part  A   min-norm  e  with  joint  (A,  B,  e)  solve  "
          "(grid  L2000/1/n160,  lam  1e4)")
    # baseline:  rows  without  s21/s25
    ts0, Ms0 = load_rows(s25=False, s21=False)
    m0, A0, B0, e0 = minnorm(ts0, Ms0, a, b, cen)
    m1, A1, B1, e1 = minnorm(ts, Ms, a, b, cen)
    print("  baseline (28 rows):    max|res|  =  %10.4f   "
          "A  =  %+.6e  B  =  %+.6e" % (m0, A0, B0))
    print("  +  census  (%d  rows):  max|res|  =  %10.4f   "
          "A  =  %+.6e  B  =  %+.6e" % (len(ts), m1, A1, B1))
    de = e1 - e0
    # cumulative  e  beyond  h0  (structure  above  h0)
    marks = [5e3, 2e4, 1e5, 3e5, 1e6, 5e6, 2e7, 1e8, 1e9, 3e9, 1e10,
             3e10, 1e11, 3e11, 1e12, 3e12, 1e13, 3e13, 1e14, 3e14,
             1e15, 3e15, 1e16, 3e16, 1e17, 3e17, 1e18]
    print()
    print("  h0 (g/G)     E_above(e0)    E_above(e1)    delta")
    for mk in marks:
        gm = G * mk
        c0 = float((e0[cen >= gm] * dg[cen >= gm]).sum())
        c1 = float((e1[cen >= gm] * dg[cen >= gm]).sum())
        flag = ""
        print("  %-9.3g   %+13.4e  %+13.4e   %+13.4e%s"
              % (mk, c0, c1, c1 - c0, flag))
    m = (np.abs(de) > 3e-3)
    if m.any():
        lo, hi = cen[m].min() / G, cen[m].max() / G
        print()
        print("  delta-e  support  (|de| > 3e-3):  g/G  in  "
              "[%.4g,  %.4g]   max|de|  =  %.3e  at  g/G  =  %.4g"
              % (lo, hi, np.abs(de).max(),
                 cen[np.argmax(np.abs(de))] / G))
    else:
        print("  delta-e  support:  none  above  3e-3  "
              "(drift  not  localized  at  this  grid)")

    print()
    print("Part  B   parametric  forward  fits  (FAR  rows  only,  "
          "A/B  from  the  NEAR  face)")
    lq = np.linalg.lstsq(np.column_stack([np.log(ts[near]),
                                          np.ones(near.sum())]),
                         Ms[near], rcond=None)[0]
    An, Bn = float(lq[0]), float(lq[1])
    Df = Ms[far] - (An * np.log(ts[far]) + Bn)
    print("  near-face  A  =  %+.6e  B  =  %+.6e   (max  near  "
          "res  %.2f)" % (An, Bn,
                          np.abs(Ms[near] - (An * np.log(ts[near]) + Bn)).max()))
    print("  FAR  drift  D(t)  =  M  -  (A ln t + B):")
    for t, d in zip(ts[far], Df):
        print("    t/G  =  %-12.6g   D  =  %+14.1f" % (t / G, d))

    def fit1(evec):
        pv = Kf @ evec
        if abs(pv).max() < 1e-300:
            return None
        c = float(np.dot(Df, pv) / np.dot(pv, pv))
        res = Df - c * pv
        return c, float(np.abs(res).max())

    # P4  density  fraction  first  (1  parameter)
    e4 = cen / G
    r4 = fit1(e4)
    print()
    print("  P4  e  =  C (g/G)   (count-deviation  density  as  a  "
          "fraction  of  the  leading  density  shape):")
    if r4:
        print("    C  =  %+.6e   max|res|  =  %10.1f"
              % (r4[0], r4[1]))
    # P1  pole  sweep
    print("  P1  pole  at  h0   (1-cell  delta):")
    best = None
    for mk in [2e5, 5e5, 1e6, 2e6, 5e6, 2e7, 5e7, 2e8, 5e8, 2e9, 5e9,
               2e10, 5e10, 2e11, 5e11, 2e12, 5e12, 2e13, 5e13, 2e14,
               5e14, 2e15, 5e15, 2e16, 5e16, 2e17, 5e17]:
        i = int(np.argmin(np.abs(cen - G * mk)))
        evec = np.zeros_like(cen)
        evec[i] = 1.0
        r = fit1(evec)
        if r is None:
            continue
        c, mr = r
        if best is None or mr < best[2]:
            best = (mk, c, mr)
        print("    h0  =  %-9.3gG   D  =  %+.6e   max|res|  =  "
              "%10.1f" % (mk, c, mr))
    # P2  power  tail  sweep
    print("  P2  power  tail  e  =  D (g/G)^q  on  g  >=  h0:")
    for q in (0.0, 0.5, 1.0, 1.5, 2.0):
        row = []
        for mk in (1e5, 1e6, 1e7, 1e8, 1e9, 1e10):
            evec = np.where(cen >= G * mk, (cen / G) ** q, 0.0)
            r = fit1(evec)
            row.append((mk, (r[1] if r else float("inf"))))
        print("    q  =  %-4.2f   max|res|  by  h0:  %s"
              % (q, "  ".join("%.0f@%gG" % (mr, mk)
                              for mk, mr in row)))
    # P3  lognormal  sweep
    print("  P3  lognormal  bump  at  h0:")
    for sg in (0.5, 1.0):
        row = []
        for mk in (1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 1e11):
            evec = np.exp(-((np.log(cen) - np.log(G * mk)) ** 2)
                          / (2 * sg * sg))
            r = fit1(evec)
            row.append((mk, (r[1] if r else float("inf"))))
        print("    sig  =  %-4.2f   max|res|  by  h0:  %s"
              % (sg, "  ".join("%.0f@%gG" % (mr, mk)
                               for mk, mr in row)))

    md = ["#  s29   drift  deconvolution  with  s28  transition  rows"
          "in-flight  dps-80  verification)", "",
          "see  stdout  run  output  committed  alongside"]
    open(os.path.join(BASE, "tmp/s33b_redec_pastwall.md"), "w").write(
        "\n".join(md) + "\n")
    print()
    print("wrote  tmp/s33b_redec_pastwall.md")


if __name__ == "__main__":
    main()
