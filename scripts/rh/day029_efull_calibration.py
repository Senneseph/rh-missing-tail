#!/usr/bin/env python3
"""day029 -- Efull G_LAST-calibration double-run (level-comparability test).

The Efull statistic of the sweep/hi-runs is
  Efull(t; G) = log|zeta(1/2+it)| - [Re disc(14.13..G] + Re quad(G, 1e18]
                + Re quad(1e18, 1e30]]
i.e. the difference between log|zeta| and a MODEL kernel spliced at G
(discrete zeros to G, density quad beyond).  The question this script
answers: are the LEVELS of Efull comparable across splice positions
G1 (end of old band, 1.0063e9) and G2 (end of new band, 2.0017e9)?
If Efull(t; G1) - Efull(t; G2) = D(t) is ~0 (up to small fluctuation),
the sweep series (t < G1) and the hi series (G1 < t < G2) are the same
object (the true log-residue R_true(t) = log|zeta/K_infinity|) and the
shape read across [3.9e7, 1.95e9] is one honest series.  If D(t) is
O(1) with a trend, the two series differ by a level offset and only
their within-run shapes are honest.

D(t) = Efull(t; G1) - Efull(t; G2)
     = Sigma_{gamma in (G1, G2]} f_t(gamma)  -  Int_{G1}^{G2} f_t rho dg
(the quads telescope) — the sum-vs-density-quad error over the band
(G1, G2], INCLUDING the log-singularity neighborhood of g = t when
t in (G1, G2] (the straddle heights).  D has log-dips at the actual
zeros (the kernel singularities), so we also report D'(t): D with the
singular neighborhood (t-DLDELTA, t+DLDELTA) removed from BOTH the sum
and the integral — smooth in t — plus the excluded sum/integral pair
itself (the singular-region model error at this t, the unknown nearest-
zero distance entering there).

No new data; ~3-4 min per height (float64 discrete passes carry the
cost; dps-30 mpmath quads are seconds each).  Self-check at t = 1.0e9:
Efull(G1) must reproduce the sweep's +2.5839 to < 5e-4.
"""
import mpmath as mpm
mpm.mp.dps = 30
import numpy as np
import day029_s1gap_hi as H   # safe: module now has a main guard

DLDELTA = 3.0   # singular-neighborhood half-width (t-units; ~10 mean gaps)


def re_kernel(t, arrs):
    """Re log K over the given zero arrays at height t (float64; same
    per-zero term as TailHi2.pairlog_sum re-part)."""
    t2 = t * t
    re = np.longdouble(0)
    CH = 200_000_000
    for arr in arrs:
        for i in range(0, arr.size, CH):
            c = arr[i:i + CH]
            g2 = c * c
            A = g2 + 0.25
            re += np.sum(np.log(np.abs(g2 - t2)) - np.log(A) + 0.5 / A)
    return float(re)


def quad_interval(t, lo, hi, npts, extra_breaks=()):
    """dps-30 quad over (lo, hi), log-spaced breakpoints (600), CLIPPED
    extras (the g = t log-singularity lands on an endpoint of a
    subinterval, where tanh-sinh converges fast)."""
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


def main():
    T = H.TailHi2()
    G1 = float(T.old[-1])
    G2 = T.G_LAST
    band = T.new[T.new0:]          # (G1, G2] zeros
    print(f"G1 = {G1!r}   G2 = {G2!r}   DLDELTA = {DLDELTA}", flush=True)
    ts = [1.00e9, 1.05e9, 1.10e9, 1.20e9, 1.30e9, 1.40e9,
          1.50e9, 1.60e9, 1.70e9, 1.80e9, 1.90e9, 1.95e9]
    print("t        Efull(G1)   Efull(G2)   D         D'        "
          "sum_excl  int_excl  (1e9 row = self-check vs sweep +2.5839)",
          flush=True)
    for t in ts:
        disc1 = re_kernel(t, [T.cache_lo, T.old])
        disc2 = re_kernel(t, [T.cache_lo, T.old, band])
        q1a = quad_interval(t, G1, 1e18, 600, extra_breaks=(t,))
        q1b = quad_interval(t, G2, 1e18, 600, extra_breaks=(t,))
        qx = quad_interval(t, 1e18, 1e30, 600)
        E = float(mpm.log(mpm.re(mpm.zeta(mpm.mpc(0.5, mpm.mpf(repr(t)))
                                    )) ** 2) / 2)
        ef1 = E - disc1 - float(q1a) - float(qx)
        ef2 = E - disc2 - float(q1b) - float(qx)
        D = ef1 - ef2
        # singular-neighborhood exclusion (only overlaps (G1, G2] for
        # straddle heights; no-op for t <= G1)
        lo = max(G1, t - DLDELTA)
        hi = min(G2, t + DLDELTA)
        if t > G1 and hi > lo:
            i0 = int(np.searchsorted(band, lo, side="left"))
            i1 = int(np.searchsorted(band, hi, side="right"))
            if i1 > i0:
                sum_excl = re_kernel(t, [band[i0:i1]])
                int_excl = float(  # integral over exactly (lo, hi)
                    quad_interval(t, lo, hi, 200, extra_breaks=(t,)))
            else:
                sum_excl, int_excl = 0.0, 0.0
        else:
            sum_excl, int_excl = None, None
        Dp = D - sum_excl + int_excl if sum_excl is not None else None
        se = f"{sum_excl:+.5f}" if sum_excl is not None else "  n/a  "
        ie = f"{int_excl:+.5f}" if int_excl is not None else "  n/a  "
        dp = f"{Dp:+.5f}" if Dp is not None else "  n/a  "
        print(f"{t:.3e}  {ef1:+.5f}  {ef2:+.5f}  {D:+.5f}  {dp}  {se}  {ie}",
              flush=True)


if __name__ == '__main__':
    main()
