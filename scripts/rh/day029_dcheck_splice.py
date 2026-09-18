#!/usr/bin/env python3
"""day029/030 -- D(t) SPLICE COMPARABILITY (the calibration item).

Question: is Efull(t; G1) - Efull(t; G2) = O(1e-4) (the zero-position
FLUCTUATION: the splice levels are one honest series) or O(1) with a
trend (the splice levels carry a G-calibration offset)?

For t > G2 the difference is EXACTLY
    D(t) =  sum_{G1 < gam <= G2} p(gam)  -  int_{G1}^{G2} p(g) rho(g) dg
(main / primorial / ext / the (G2, 1e18] piece cancel identically),
with p the kernel's per-zero pair-log factor in the SAME principal
branch as T.pairlog_sum (verified by hand: re = log|g^2-t^2| -
log(g^2+1/4) + 1/(2A), im = t/A - pi for gam < t; t/A for gam > t).
For t in (G1, G2] it holds up to O(1e-6) grid-difference on the
(G2, 1e18] piece.

Both sides use the kernel's own constructions: the sum is the
pairlog formula fsum'd (exact rounding) over the deduped new band
(= (G1, G2] exactly); the integral is the mpmath complex quad of
p(g) rho(g) (the quad_rem integrand) on a 400-cell geometric grid,
v3 singularity-aware (shifted split + O(eps^3) annulus) when t lies
inside (G1, G2], + real-path cross-check on both sides.

Predictions under test:
  SUM-DENSITY (fluctuation) hypothesis: |D(t)| ~ O(1e-4)
  (sigma ~ sqrt(N) * |p'| * gap/2, p' ~ t/g^2, N ~ 3e9).
  CALIBRATION hypothesis: |D(t)| ~ O(1) with a trend in t.
"""
import mpmath as mpm
mpm.mp.dps = 30
import time
import math
import sys
import numpy as np
sys.path.insert(0, '.')
import day029_s1gap_hi as H

T = H.TailHi2()
G1 = float(T.old[-1])          # 1.0063459998e9 (old band end)
G2 = float(T.G_LAST)           # 2.0017459996e9 (new band end)
Z2 = T.new[T.new0:]            # deduped new band = (G1, G2], a memmap view
EPS = mpm.mpf("1e-8")
NPTS = 400


def f_int(smp, gg):
    r1 = mpm.mpc(0.5, gg)
    r2 = mpm.mpc(0.5, -gg)
    p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
         + smp/r1 + smp/r2)
    return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))


def geo(lo, hi, n):
    return [lo * (hi/lo)**(mpm.mpf(j)/mpm.mpf(n)) for j in range(n + 1)]


def sing_safe_int(smp, a, b, t):
    """mpmath quad of f_int over [a, b] (mpf endpoints), v3-aware:
    if t in (a, b): [a, t-EPS] + [t+EPS, b] (smooth) + exact annulus."""
    a = mpm.mpf(a); b = mpm.mpf(b)
    tc = mpm.mpf(t)
    if not (a + EPS < tc - EPS < b):
        pts = geo(a, b, NPTS)
        c = mpm.quad(lambda gg: f_int(smp, gg), pts)
        r = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), pts)
        return c, float(r)
    rho_t = mpm.log(tc/(2*mpm.pi))/(2*mpm.pi)
    r1t = mpm.mpc(0.5, tc)
    r2t = mpm.mpc(0.5, -tc)
    base = mpm.log(1 - smp/r2t) + smp/r1t + smp/r2t
    half = EPS * rho_t * (mpm.log(EPS) - 1)
    annL = half + EPS * rho_t * (mpm.log(-1j/r1t) + base)
    annR = half + EPS * rho_t * (mpm.log(1j/r1t) + base)
    gL = geo(a, tc - EPS, NPTS)
    gR = geo(tc + EPS, b, NPTS)
    cL = mpm.quad(lambda gg: f_int(smp, gg), gL)
    cR = mpm.quad(lambda gg: f_int(smp, gg), gR)
    rL = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gL)
    rR = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gR)
    c = cL + cR + annL + annR
    r = rL + rR + float(mpm.re(annL + annR))
    return c, float(r)


def pair_fsum(t):
    """fsum of the pairlog terms over (G1, G2]; the + n*pi branch
    term is exact arithmetic (n = count, all gam < t for t > G2)."""
    t2 = t * t
    re_parts = []
    im_parts = []
    CH = 33_000_000
    for i in range(0, Z2.size, CH):
        c = Z2[i:i+CH].astype(np.float64, copy=False)
        g2 = c * c
        A = g2 + 0.25
        re_parts.append(math.fsum(np.asarray(
            np.log(np.abs(g2 - t2)) - np.log(A) + 0.5/A,
            dtype=np.float64)))
        im_parts.append(math.fsum(np.asarray(t/A, dtype=np.float64)))
    re_tot = math.fsum(re_parts)
    im_tot = math.fsum(im_parts)
    n = int(Z2.size)
    if t > G2:
        im_tot = im_tot - n * math.pi
    else:
        # straddle heights: branch term only for gam < t
        nlt = int(np.searchsorted(Z2, t, side="left"))
        im_tot = im_tot - nlt * math.pi
    return re_tot, im_tot


def mpmath_sum_check(t, m=200_000):
    """m first zeros of (G1, G2], mpmath dps-30 direct pair terms."""
    smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
    re = mpm.mpf(0)
    im = mpm.mpf(0)
    for i in range(m):
        g = mpm.mpf(repr(float(Z2[i])))
        r1 = mpm.mpc(0.5, g)
        r2 = mpm.mpc(0.5, -g)
        p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        re += mpm.re(p)
        im += mpm.im(p)
    return float(re), float(im)


if __name__ == "__main__":
    t0 = time.time()
    print("D(t) splice-comparability check  (mpmath %s, dps-30)"
          % mpm.__version__, flush=True)
    print("G1 = %.13f   G2 = %.13f   N(G1, G2] = %d"
          % (G1, G2, int(Z2.size)), flush=True)

    print("\nSUM-SIDE precision check: fsum vs mpmath-dps-30 direct, "
          "first 200000 zeros, t = 2.5e9", flush=True)
    tm = mpmath_sum_check(2.5e9)
    # mpmath direct sums the FULLY PRINCIPAL p (im carries -pi for
    # gam < t); the fsum im side carries the same (all gam < t here):
    # fsum partial over the first 200000 (recompute cheaply):
    c0 = Z2[:200000].astype(np.float64, copy=False)
    A0 = c0 * c0 + 0.25
    re0 = math.fsum(np.asarray(
        np.log(np.abs(c0*c0 - 6.25e18)) - np.log(A0) + 0.5/A0,
        dtype=np.float64))
    im0 = math.fsum(np.asarray(2.5e9/A0, dtype=np.float64)) - 200000*math.pi
    print("  mpmath re/im : %.12f  %.12f" % tm, flush=True)
    print("  fsum   re/im : %.12f  %.12f" % (re0, im0), flush=True)
    print("  |d|          : %.2e  %.2e   (< 1e-6 required)"
          % (abs(tm[0] - re0), abs(tm[1] - im0)), flush=True)
    assert abs(tm[0] - re0) < 1e-6 and abs(tm[1] - im0) < 1e-6
    print("  PASS  (%.0fs)" % (time.time() - t0), flush=True)

    print("\nD(t) = sum_{(G1, G2]} p - int_{G1}^{G2} p rho   "
          "(|D| ~ 1e-4 => fluctuation; |D| ~ O(1) => G-calibration)",
          flush=True)
    print("t         N          D_re          D_im         |D|       "
          "quad d(re)", flush=True)
    for t in [1.5e9, 1.9e9, 2.5e9, 4e9, 1e10]:
        t1 = time.time()
        sre, sim = pair_fsum(t)
        smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
        ic, irr = sing_safe_int(smp, mpm.mpf(repr(G1)),
                                mpm.mpf(repr(G2)), t)
        D_re = sre - float(mpm.re(ic))
        D_im = sim - float(mpm.im(ic))
        dquad = abs(float(mpm.re(ic)) - irr)
        mode = "split" if G1 < t < G2 else "plain"
        print("%8.1g %11d %15.9f %15.9f %12.3e %10.2e   %s  (%.0fs)"
              % (t, int(Z2.size), D_re, D_im, math.hypot(D_re, D_im),
                 dquad, mode, time.time() - t1), flush=True)
    print("\nDONE (%.0fs total)" % (time.time() - t0), flush=True)
