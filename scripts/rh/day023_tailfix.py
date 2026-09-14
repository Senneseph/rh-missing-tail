# Day-023 — clean tail quadrature + validation via the s=-2 PinCensus pin.
# The old tail_int used mp.quad over [G, inf]; A/B test: dps-25 and dps-30
# quad answers differ by 8.7e-3 (t = 5004.7, G = 1e7) — unconverged.  Clean
# replacement: [G, G*R] on a log grid (quadratic decay, well conditioned)
# + analytic remainder bound (pairlog = -t^2/g^2 + O(1/g^3, t^4/g^4)),
# double-refinement convergence assert.
import math
import numpy as np
from mpmath import mp

mp.dps = 30
PI = mp.pi
W = lambda g: mp.log(g/(2*PI))/(2*PI)


def pairlog(g, s):
    r1 = mp.mpc(0.5, g)
    r2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/r1) + mp.log(1 - s/r2) + s/r1 + s/r2)


def tail_clean(s, G, R=mp.mpf(100), N=60):
    G = mp.mpf(G)
    pts = [G * R**(mp.mpf(k)/N) for k in range(N+1)]
    f = lambda gg: pairlog(gg, s)*W(gg)
    v1 = mp.quad(f, pts)
    pts2 = [G * R**(mp.mpf(k)/(2*N)) for k in range(2*N+1)]
    v2 = mp.quad(f, pts2)
    assert abs(v1 - v2) < 1e-12, (v1, v2)
    t = abs(mp.im(s))
    rem = (t*t)*W(G*R)/(G*R)*(1 + mp.mpf(25)/(G*R))
    return v2, rem


if __name__ == "__main__":
    # magnitude check at the 5e3 witness tail
    s = mp.mpc(0.5, "5004.7343")
    G = mp.mpf("10000000")
    v, rem = tail_clean(s, G)
    ana = -(mp.mpf("5004.7343")**2)*W(G)/G
    print("tail_clean(5004.7343, 1e7) = %s   (analytic lead %.4f, rem bound %.1e)"
          % (mp.nstr(v, 12), float(ana), float(rem)))
    # Independent cross-check vs the PinCensus PIN at s0 = -2 (machine-verified
    # route, DISCOVERY_LOG 22): P_full(-2) = P_B(-2) * e^{tail(-2)} and
    # P_full(-2) = c_1 * (1 + R_1) by the pin.  => tail_clean(-2) must agree
    # with the pin-implied tail to ~R_1 (~1e-12).
    import day023_pincensus_1e7 as pc
    g = np.loadtxt("zeros_T10000000_lmfdb.txt", dtype=np.float64)
    gld = g.astype(np.longdouble)
    P_B = pc.P_pair_ld(-2, gld)
    c1 = pc.pin_cd(1)
    B = float(g[-1])
    R1 = P_B * (1.0 + pc.tail_model(1, B)) / c1 - 1.0
    tail_model = pc.tail_model(1, B)
    tail_pin = math.log((1.0 + R1) / (1.0 + tail_model))
    v_m2, rem_m2 = tail_clean(mp.mpc(-2, 0), G, R=mp.mpf(10))
    print("tail_clean(-2, 1e7)    = %.15e" % float(mp.re(v_m2)))
    print("pin-implied tail (-2)  = %.15e   (R_1 = %.2e, tail_model = %.3e)"
          % (tail_pin, R1, tail_model))
    print("agreement              = %.2e" % abs(float(mp.re(v_m2)) - tail_pin))
