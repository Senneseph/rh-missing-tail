# Day-024 — 25x TAIL GENERALIZATION: the discrete section of the 25b kernel
# extended from (1e7, 3e7] to (1e7, band_end] with ACTUAL zeros, where the
# band = (3.1946e7, 1006345999.847005] downloaded 2026-09-14 from the public
# LMFDB/Platt dataset (see DISCOVERY_LOG 24/24b/25w, supervisor log hi1e9).
#
#   tail(s) = DISCRETE sum of the exact per-pair log-factor
#             log[ ((g^2-t^2)/(g^2+1/4)) e^{s/(g^2+1/4)} ]
#             over ACTUAL zeros in (1e7, G_LAST]
#            + dps-30 density quad over (G_LAST, 1e18]
#            + analytic (1e18, inf) t^2 bound (reported, not in K)
#
# Kernel identity (25b, unchanged): for s = 1/2 + i t the per-pair factor is
#   (1 - s/r1)(1 - s/r2) e^{s/r1+s/r2} = ((g^2-t^2)/(g^2+1/4)) e^{s/(g^2+1/4)}
# with r1 = 1/2+ig, r2 = 1/2-ig.  Log kernel (float64, same convention as
# day023_taildiscrete._pairlog_complex):
#   re = log|(g^2-t^2)/(g^2+1/4)| + 1/(2(g^2+1/4))
#   im = t/(g^2+1/4)  (+ i*pi ONCE per zero with g < t, added to the SUM --
#       kernel bug #1 convention, DISCOVERY_LOG 25f).
#
# Differences vs the 25f screening run (documented):
#   1. discrete section (1e7, 3e7] -> (1e7, G_LAST]; the missing (3e7, 31946e6]
#      slice now comes from the on-disk shards (Nt-continuous with the band:
#      shard frontier Nt = 73426758 at 31946000.0, band start asserted equal).
#   2. quad section (3e7, 1e18] -> (G_LAST, 1e18].  For every scanned
#      t <= 1e9 < G_LAST there is NO interior singularity, so the 25f
#      split-at-t (kernel bug #3) is not triggered: log-spaced nodes only.
#   3. near-t structure (the thing the 25f density quad could not resolve:
#      zero spacing ~0.3 rad vs quad node spacing ~1e6-1e9 in g) is now
#      EXACT for all scanned windows -- this is what converts the 25f
#      NOMINAL rows into REAL rows.
#
# Screening-level precision: float64 discrete (longdouble accumulation) +
# dps-30 quad.  Float64 floor documented per 25c discipline.
import numpy as np
from mpmath import mp

import day023_taildiscrete as td

REM_HI = 1.0e18
NPTS_DEF = 200
BAND_F64 = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/" \
           "zeros_hi31946e6_to_1e9.f64"
HI_DISC = 31946000.0     # shard frontier (Nt = 73426758), exact per 25w


class Tail_hi1e9:
    """Discrete-over-actual-zeros tail, (1e7, G_LAST] + quad (G_LAST, 1e18]."""

    def __init__(self, band_path=BAND_F64, verbose=False):
        self._v = verbose
        self.cache_lo = td.load_g_range(1.0e7, HI_DISC)   # (1e7, 3.1946e7)
        b = np.fromfile(band_path, dtype="<f8")
        assert b.size > 2_700_000_000, "band file truncated: %d" % b.size
        lo_end, hi_start = self.cache_lo[-1], b[0]
        assert lo_end < hi_start, "discrete sections not ordered"
        # spot: no overlap and no gap larger than zero spacing
        assert hi_start - lo_end < 10.0, "gap %.3f between sections" % (hi_start - lo_end)
        self.g_all = self.cache_lo          # keep the small part separate:
        self.b = b                          # RAM math below is chunked anyway
        self.G_LAST = float(b[-1])
        # nlt needs ONE sorted view: (1e7, 3.1946e7) then band -- already sorted
        self._front_n = self.cache_lo.size
        if verbose:
            print("tail cache: (%.0f, %.0f] %d + band %d; G_LAST = %.6f"
                  % (1e7, HI_DISC, self.cache_lo.size, b.size, self.G_LAST))

    def _nlt(self, t):
        a = self.cache_lo
        n = int(np.searchsorted(a, t, side="left"))
        if t > a[-1]:
            n += int(np.searchsorted(self.b, t, side="left"))
        return n

    def pairlog_sum(self, t):
        """(re, im) of the discrete log-sum for s = 1/2 + i t, all actual
        zeros in (1e7, G_LAST].  Chunked; float64 chunk-sums (pairwise,
        per-chunk error ~1e-13) accumulated in longdouble across chunks."""
        t2 = t * t
        re = np.longdouble(0)
        im = np.longdouble(0)
        CH = 2_00_000_000
        for arr in (self.cache_lo, self.b):
            for i in range(0, arr.size, CH):
                c = arr[i:i+CH]
                g2 = c * c
                A = g2 + 0.25
                re += np.sum(np.log(np.abs(g2 - t2)) - np.log(A)
                             + 0.5 / A)
                im += np.sum(t / A)
        nlt = self._nlt(t)
        re = float(re)
        im = float(im) + nlt * np.pi
        return re, im

    def quad_rem(self, t, npts=NPTS_DEF):
        """dps-30 density quad over (G_LAST, REM_HI], log-spaced, s = 1/2+it."""
        mp.dps = 30
        smp = mp.mpc(0.5, mp.mpf(repr(float(t))))
        hi0 = mp.mpf(repr(self.G_LAST))
        hi1 = mp.mpf("1e18")

        def f(gg):
            r1 = mp.mpc(0.5, gg)
            r2 = mp.mpc(0.5, -gg)
            p = (mp.log(1 - smp/r1) + mp.log(1 - smp/r2)
                 + smp/r1 + smp/r2)
            return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

        k = mp.mpf(npts)
        pts = [hi0 * (hi1/hi0)**(mp.mpf(j)/k) for j in range(npts+1)]
        return mp.quad(f, pts)

    def bound_rem(self, t):
        """analytic (1e18, inf) t^2-part bound (25b form), reported only."""
        mp.dps = 30
        t = mp.mpf(repr(float(t)))
        B = mp.mpf("1e18")
        return t*t*(mp.log(B/(2*mp.pi)) + 1)/(2*mp.pi*B)


_T = None


def tail():
    global _T
    if _T is None:
        _T = Tail_hi1e9(verbose=True)
    return _T
