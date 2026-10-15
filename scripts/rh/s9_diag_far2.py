"""s9 diagnostic 2:  localize the  B/D-vs-A  error  by region.

Regions  (u-space,  t  =  G + 0.5):
  L  =  [ln G,  ln(t+5)]       (the  ~0.5-wide  (G, t)  zone  +  5 above)
  R  =  [ln(t+5),  ln 1e30]    (the  long  tail)
Each  region  3  ways:  mpmath  dps-50  adaptive,  B-grid
(2e6-pt  trapezoid  restricted  to  the  region),  D-grid
(D's  original  per-region  grids).
"""
import math
import sys

import mpmath as mp
import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

T = 30001046000.481976


def main():
    with S.workdps(50):
        s = mp.mpc(0.5, mp.mpf(repr(T)))

        def fu(u):
            g = mp.e ** u
            r1 = mp.mpc(0.5, g)
            r2 = mp.mpc(0.5, -g)
            p = mp.log(1 - s / r1) + mp.log(1 - s / r2)
            return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g

        lo = mp.log(mp.mpf(repr(S.G_LAST)))
        hi = mp.log(mp.mpf("1e30"))
        ut = mp.log(mp.mpf(repr(T)))
        mpmath_L1 = float(mp.re(mp.quad(fu, [lo, ut])))
        mpmath_L2 = float(mp.re(mp.quad(fu, [ut, mp.log(mp.mpf(repr(T + 5)))])))
        mpmath_R = float(mp.re(mp.quad(fu,
                                       [mp.log(mp.mpf(repr(T + 5))), hi])))

    def ker(t, g):
        out = np.empty_like(g)
        m = g < t
        gl, gr = g[m], g[~m]
        out[m] = np.log(t - gl) + np.log(t + gl) - np.log(gl * gl + 0.25)
        q = (t / gr) ** 2
        out[~m] = np.log1p(-q) - np.log1p(1.0 / (4.0 * gr * gr))
        return out

    def dens(g):
        return np.log(g / (2 * math.pi)) / (2 * math.pi) * g

    def trap(uu):
        g = np.exp(uu)
        return float(np.trapz(ker(T, g) * dens(g), uu))

    # B-style:  the  full  2e6  grid  of  i_far_trap,  restricted:
    uB = np.linspace(S.U0, S.U1, 2_000_001)
    gB = np.exp(uB)
    wB = ker(T, gB) * dens(gB)
    maskL = gB <= T + 5
    maskR = gB > T + 5
    B_L = float(np.trapz(wB[maskL], uB[maskL]))
    B_R = float(np.trapz(wB[maskR], uB[maskR]))

    # D-style  grids:
    u1 = np.linspace(math.log(S.G_LAST), math.log(T - 5), 200001)
    u2 = np.linspace(math.log(T - 5), math.log(T + 5), 2000001)
    u3 = np.linspace(math.log(T + 5), math.log(1e30), 400001)
    D_L = trap(u1) + trap(u2)
    D_R = trap(u3)

    print("left  region  [G, t+5]:")
    print("  mpmath  (lo..ut):  %+.12f" % mpmath_L1)
    print("  mpmath  (ut..t+5): %+.12f" % mpmath_L2)
    print("  mpmath  total:     %+.12f" % (mpmath_L1 + mpmath_L2))
    print("  B-grid:            %+.12f" % B_L)
    print("  D-grids:           %+.12f" % D_L)
    print("right region  (t+5, 1e30]:")
    print("  mpmath:            %+.12f" % mpmath_R)
    print("  B-grid:            %+.12f" % B_R)
    print("  D-grid:            %+.12f" % D_R)
    print("checks:")
    print("  mpmath total:      %+.12f" %
          (mpmath_L1 + mpmath_L2 + mpmath_R))
    print("  B total:           %+.12f" % (B_L + B_R))
    print("  D total:           %+.12f" % (D_L + D_R))


if __name__ == "__main__":
    main()
