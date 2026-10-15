"""s9 diagnostic:  4-way far-zone integral cross-check at t = G + 0.5.

A =  s9 i_far_split  (mpmath dps-40,  split at u_t)
B =  s9 i_far_trap   (f64 2e6-pt u-grid,  peak missed)
C =  peak-isolated mpmath dps-50  (tanh-sinh inside,  adaptive outside)
D =  numpy 3-grid  (coarse + 2e6-pt fine peak zone + coarse)
"""
import math
import sys

import mpmath as mp
import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

T = 30001046000.481976  # s9 row 1  (t = G + 0.5)


def main():
    A = S.i_far_split(T, 40)
    B = S.i_far_trap(T)

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
        d = mp.mpf("3") / mp.mpf(repr(T))
        c1 = float(mp.re(mp.quad(fu, [lo, ut - d])))
        c2 = float(mp.re(mp.quad(fu, [ut - d, ut + d],
                                 method="tanh-sinh", maxsubdiv=200)))
        c3 = float(mp.re(mp.quad(fu, [ut + d, hi])))

    C = c1 + c2 + c3

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

    u1 = np.linspace(math.log(S.G_LAST), math.log(T - 5), 200001)
    u2 = np.linspace(math.log(T - 5), math.log(T + 5), 2000001)
    u3 = np.linspace(math.log(T + 5), math.log(1e30), 400001)
    D = 0.0
    for uu in (u1, u2, u3):
        g = np.exp(uu)
        D += float(np.trapz(ker(T, g) * dens(g), uu))

    print("t             = %r" % T)
    print("A i_far_split : %+.12f" % A)
    print("B trap 2e6pt  : %+.12f" % B)
    print("C peak-dps50  : %+.12f   (peak zone %.8e)" % (C, c2))
    print("D numpy grids : %+.12f" % D)
    print()
    for name, o in (("B-A", B - A), ("C-A", C - A),
                    ("D-A", D - A), ("D-C", D - C)):
        print("%s = %+.6e" % (name, o))


if __name__ == "__main__":
    main()
