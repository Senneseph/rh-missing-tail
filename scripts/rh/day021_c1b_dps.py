#!/usr/bin/env python3
"""day021 C1b — dps verification of the Step-0 worst-point measurements.

Host numpy-only python produced out_day021_c1b_worst.txt (float64).
This script re-evaluates the KEY numbers at dps=50 inside the pinned
container (kainos-dev:dev, mpmath) — pin-never-recall, and the
gamma->inf limit question that the float sweep only sampled.
"""
from mpmath import mp, mpf, nstr

def run(dps):
    mp.dps = dps
    def N(x, p=15):
        return nstr(x, p)

    one4 = mp.mpf(1) / 4

    def pref(g, d, t):
        g, d, t = mp.mpf(g), mp.mpf(d), mp.mpf(t)
        num = (one4 + g*g) * ((g - t)**2 + d*d) * ((g + t)**2 + d*d)
        den = (g*g - t*t) * (one4 + d + d*d + g*g) * (one4 - d + d*d + g*g)
        return num / den

    def omegad(g, d):
        g, d = mp.mpf(g), mp.mpf(d)
        return ((1 + 2*d) / (one4 + g*g + d + d*d)
                + (1 - 2*d) / (one4 + g*g - d + d*d)
                - 1 / (one4 + g*g))

    def rmag(g, d, t):
        return abs(pref(g, d, t)) * mp.exp(omegad(g, d) / 2)

    def detector(g, d, t):
        g, d, t = mp.mpf(g), mp.mpf(d), mp.mpf(t)
        om = omegad(g, d)
        ph = (mpf(1) / 2 + t) * om
        return abs(pref(g, d, t) * (mp.cos(ph) + 1j * mp.sin(ph)) - 1)

    out = []
    p = out.append
    p(f"day021 C1b dps verification (dps = {dps})")
    p("=" * 74)
    g0 = mp.mpf("14.134725142")   # smallest certified zero height (day-010 record)
    g1 = mp.mpf("999.791572")     # audit pair (day-010/020)

    p("\n[V1] worst point of the float sweep:")
    v = rmag(g0, mpf('0.5'), g0 + mpf('0.01'))
    p(f"  |R|(g0, d=0.5, u=0.01) = {N(v)}    (float64: 3.536696873e+00)")

    p("\n[V2] the W=12 edge at the audit pair (continuous-window floor there):")
    v = rmag(g1, mpf('0.5'), g1 + 12)
    p(f"  |R|(g1, d=0.5, u=12) = {N(v)}")
    p(f"  -> 1 - |R| = {N(1 - v)}    (float64: 2.4191e-02 -> 0.9758)")
    p("  (the day-010 discrete straddle grid had min |R-1| = 0.99750; the")
    p("   scope difference is exactly the window: 0.9975 is a pin on the")
    p("   audited discrete straddle set at g ~ 1e3, not a uniform floor on")
    p("   one continuous W-window)")

    p("\n[V3] the |R| = 1 crossing at g = 100, d = 0.5 (bisection on u):")
    f = lambda u: rmag(100, mpf('0.5'), 100 + u) - 1
    lo, hi = mpf('0.005'), mpf('0.02')
    for _ in range(80):
        mid = (lo + hi) / 2
        if f(lo) * f(mid) <= 0:
            hi = mid
        else:
            lo = mid
    uc = (lo + hi) / 2
    om = omegad(100, mpf('0.5'))
    th = (mpf(1) / 2 + 100 + uc) * om
    p(f"  u_c = {N(uc)}")
    p(f"  theta = (1/2+t)*omega = {N(th)} rad")
    p(f"  chord floor 2|sin(theta/2)| = {N(2*abs(mp.sin(th/2)))}   (float64: 0.010049)")

    p("\n[V4] omega bound  omega_d <= 2/(g^2 + 1) for 0 < d <= 1/2:")
    for g, d in [(g0, mpf('0.5')), (mpf(100), mpf('0.5')), (g1, mpf('0.5')),
                 (g0, mpf('0.005'))]:
        bound = 2 / (g*g + 1)
        p(f"  g = {N(g)}, d = {N(d)}: omega = {N(omegad(g,d), 8)}, "
          f"bound = {N(bound, 8)}, ok = {omegad(g,d) <= bound}")

    p("\n[V5] window theta constant 2 (g + 12.5)/(g^2 + 1) at g0")
    p("     (the family is decreasing for g >= 1):")
    p(f"  2 (g0 + 12.5)/(g0^2 + 1) = {N(2*(g0 + mpf('12.5'))/(g0*g0 + 1))} rad")
    p(f"  pi = {N(mp.pi)}   (constant is far below pi, hence below 2 pi too)")

    p("\n[V6] gamma -> infinity: infimum of the detector scale on W = 12")
    p("      (u in (0,12], both sides, d in 9 grid pts, dps grid):")
    ds = [mpf('0.005'), mpf('0.01'), mpf('0.02'), mpf('0.05'),
          mpf('0.1'), mpf('0.2'), mpf('0.3'), mpf('0.4'), mpf('0.5')]
    for g in [100, 1000, 10000, 100000]:
        worst = mp.inf
        for d in ds:
            for sgn in (1, -1):
                for i in range(1, 2401):
                    u = i * mpf('0.01')
                    t = g + sgn * u
                    if t <= 0:
                        break
                    dt = detector(g, d, t)
                    if dt < worst:
                        worst = dt
        p(f"  g = {g:>10}:  min ||R-1|| = {N(worst)}")
    p("  (the detector scale -> 0 as g -> inf along the |R| = 1 crossing:")
    p("   the near-regime floor is NOT a positive uniform constant on the")
    p("   whole window; the C1b statement is re-formulated, spec updated)")
    return "\n".join(out)

if __name__ == "__main__":
    txt = run(50)
    print(txt)
    with open("out_day021_c1b_dps.txt", "w") as fh:
        fh.write(txt + "\n")
