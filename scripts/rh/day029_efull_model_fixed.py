#!/usr/bin/env python3
"""day029 -- model-level Efull, FIXED singular-region quadrature.

The hi-run's MODEL points (t > G_LAST) are BROKEN as launched: the
density quad over (G_LAST, 1e18] carries the log-singularity at g = t
IN THE INTERIOR of its 400-point geometric grid — quadrature error
O(1e6-1e7), observed junk: +6.57e6 / +6.16e6 / +1.65e6 / +1.47e7 /
-1.7e5 / -6.4e6 at 2.5e9..3e10.  (The straddle windows are unaffected:
there t < G_LAST and the singular region is inside the DISCRETE data.)

This script re-runs the six model heights with the singular region
handled properly: the (G_LAST, 1e18] quad is split at g = t and each
piece integrates with the log-singularity on an ENDPOINT (where
tanh-sinh converges fast).  Honest grade of the result: MODEL (H2) —
the true zeros in (G_LAST, t) are unknown (no data); the density
model's singular-region sum-vs-integral error (the unknown nearest-
zero distance entering as log|t - gamma_nearest|) is O(1) per point.
The SHAPE of Efull_model(t) over 2.5e9..3e10 is still the systematic
signal; individual points carry O(1) model uncertainty.
"""
import mpmath as mpm
mpm.mp.dps = 30
import numpy as np
import day023_p11c_1e7 as M
import day029_s1gap_hi as H   # safe: main guard in place


def quad_interval(t, lo, hi, npts, extra_breaks=()):
    def f(gg):
        smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
        r1 = mpm.mpc(0.5, gg)
        r2 = mpm.mpc(0.5, -gg)
        p = (mpm.log(1 - smp / r1) + mpm.log(1 - smp / r2)
             + smp / r1 + smp / r2)
        return mpm.re(p) * (mpm.log(gg / (2 * mpm.pi)) / (2 * mpm.pi))
    k = mpm.mpf(npts)
    lo = mpm.mpf(repr(lo))
    hi = mpm.mpf(repr(hi))
    pts = [lo * (hi / lo) ** (mpm.mpf(j) / k) for j in range(npts + 1)]
    for e in extra_breaks:
        ev = mpm.mpf(repr(e))
        if lo < ev < hi:
            pts.append(ev)
    pts.sort()
    uniq = [pts[0]]
    for v in pts[1:]:
        if v - uniq[-1] > 0:
            uniq.append(v)
    return mpm.quad(f, uniq)


def model_efull(T, t):
    """Efull(t; G_LAST-splice) with singular-region-correct quads.
    Returns (Efull, dict-of-parts)."""
    g = T.G_LAST
    # discrete (14.13..G_LAST] re-part (float64, same term as pairlog)
    t2 = t * t
    re = np.longdouble(0)
    CH = 200_000_000
    for arr in (T.cache_lo, T.old, T.new[T.new0:]):
        for i in range(0, arr.size, CH):
            c = arr[i:i + CH]
            gg = c * c
            A = gg + 0.25
            re += np.sum(np.log(np.abs(gg - t2)) - np.log(A) + 0.5 / A)
    # (G_LAST, 1e18] split at g = t (singularity on endpoints of both)
    q_lo = quad_interval(t, g, t, 800, extra_breaks=(t,))     # (G, t]
    q_hi = quad_interval(t, t, 1e18, 600, extra_breaks=(t,))  # [t, 1e18)
    # (1e18, 1e30] smooth (t < 1e18)
    qx = quad_interval(t, 1e18, 1e30, 600)
    E = float(mpm.log(mpm.re(mpm.zeta(mpm.mpc(0.5, mpm.mpf(repr(t))))
                        ) ** 2) / 2)
    ef = E - float(re) - float(q_lo) - float(q_hi) - float(qx)
    return ef, {"E": E, "disc": float(re),
                "q(G,t]": float(q_lo), "[t,1e18)": float(q_hi),
                "(1e18,1e30]": float(qx)}


def main():
    T = H.TailHi2()
    print(f"G_LAST (splice) = {T.G_LAST!r}", flush=True)
    print("t        Efull_model   E            disc_re     q(G,t]    "
          "[t,1e18)   (1e18,1e30]", flush=True)
    for t in [2.5e9, 4e9, 6e9, 1e10, 2e10, 3e10]:
        ef, parts = model_efull(T, t)
        print(f"{t:.3e}  {ef:+.5f}   {parts['E']:+.5f}   {parts['disc']:+.5f}"
              f"   {parts['q(G,t]']:+.5f}   {parts['[t,1e18)']:+.5f}"
              f"   {parts['(1e18,1e30]']:+.5f}", flush=True)


if __name__ == '__main__':
    main()
