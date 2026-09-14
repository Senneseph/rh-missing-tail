#!/usr/bin/env python3
"""day023 C1b Step 0b — the DISCRETE-STRADDLE window floor.

Step 0 found the pole-ridge: as (u, d) -> (0-, 0.5-) with u = t - gamma,
R -> e^{i*theta_gamma} * 1 with theta_gamma ~= 1/gamma, so the
CONTINUOUS window has no positive uniform floor (ridge value ~= 1/gamma
-> 0).  The closure, however, is evaluated at the MEASURED straddle
heights: u in 0.5*Z \ {0} (plus the pole column u = 0, the C1a regime).
On that DISCRETE set the ridge point u* ~= 0.5/gamma falls BETWEEN
grid points (for gamma >= 1 the nearest grid point is u = 0 = pole, or
|u| >= 0.5) — the discrete floor is a different, much larger object.

This step maps  floor_disc(gamma) = min over u in 0.5Z, 0 < |u| <= 12,
0 < d <= 0.5  of  ||R(gamma, d, gamma+u) - 1||
on a log gamma grid, dps-30, and checks the candidate closed form
    floor_disc(gamma) >= min( m_corner, 1 - c/gamma )
(m_corner = the small-gamma u = -12 corner value, c to be fitted).
"""
import mpmath as mp

mp.mp.dps = 30
G0 = mp.mpf("14.134725141734693790457147")
W = mp.mpf("12")


def rabs(g, u, d):
    t = g + u
    num = (mp.mpf("0.25") + g*g) * (u*u + d*d) * ((g + t)*(g + t) + d*d)
    den = (g*g - t*t) * (mp.mpf("0.25") + d + d*d + g*g)
          * (mp.mpf("0.25") - d + d*d + g*g)
    w = ((mp.mpf(1) + 2*d) / (mp.mpf("0.25") + d + d*d + g*g)
         + (mp.mpf(1) - 2*d) / (mp.mpf("0.25") - d + d*d + g*g)
         - mp.mpf(1) / (mp.mpf("0.25") + g*g))
    s = mp.mpc(mp.mpf("0.5"), t)
    return abs(num/den * mp.e**(s*w) - 1)


def main():
    out = []
    p = out.append
    p("day023 C1b Step 0b: DISCRETE-STRADDLE window floor")
    p("  u = 0.5k, k = +-1..+-24 (|u| <= 12, u != 0);  d in (0, 0.5] (dd = 0.005)")
    p("=" * 74)
    us = [mp.mpf(k) * mp.mpf("0.5") for k in range(-24, 25) if k != 0]
    ds = [mp.mpf(i) / 100 for i in range(1, 101)]
    gammas = [G0]
    g = G0
    step = mp.mpf(10)**(mp.mpf(1)/6)   # 1.468x log steps
    while g < mp.mpf("1e7"):
        g = g * step
        gammas.append(g)
    gammas.append(mp.mpf("1e7"))
    rows = []
    for gi, gg in enumerate(gammas):
        best = (None, None, None)
        for u in us:
            for d in ds:
                v = rabs(gg, u, d)
                if best[0] is None or v < best[0]:
                    best = (v, u, d)
        rows.append((gg, best[0], best[1], best[2]))
        if (gi + 1) % 10 == 0:
            p("  gammas done: %d/%d" % (gi + 1, len(gammas)))
    p("")
    p("[1] floor_disc(gamma) table (dps-30):")
    p("    g               min||R-1||      (u, d at the min)")
    m_corner = None
    worst_corner = (None, None)
    for (gg, v, u, d) in rows:
        p("    %14.4f  %14.9f   (u = %8.2f, d = %6.3f)" %
          (float(gg), float(v), float(u), float(d)))
        if u == -mp.mpf("12"):
            if worst_corner[0] is None or v < worst_corner[0]:
                worst_corner = (v, gg)
    p("")
    p("    worst u = -12 corner value: %s at g = %s"
      % (mp.nstr(worst_corner[0], 10), mp.nstr(worst_corner[1], 8)))
    # fit c in 1 - c/g to the large-gamma rows (u-min not the corner)
    fit = [ (v, gg) for (gg, v, u, d) in rows
            if float(gg) >= 60 and u != -mp.mpf("12")]
    cmax = mp.mpf(0)
    for (v, gg) in fit:
        c = (1 - v) * gg
        cmax = max(cmax, c)
    p("")
    p("[2] fit: for g >= 60 (min not at the corner): need 1 - |R| >= 1 - c/g")
    p("    c = max_g (1 - floor_disc)(g) * g = %s" % mp.nstr(cmax, 10))
    mcorner = worst_corner[0]
    p("")
    p("[3] candidate theorem constant check:  floor_disc(g) >= min(%s, 1 - %s/g)"
      % (mp.nstr(mcorner, 8), mp.nstr(cmax, 8)))
    viol = 0
    for (gg, v, u, d) in rows:
        bound = min(mcorner, 1 - cmax/gg)
        if bound > 0 and v < bound:
            viol += 1
            p("    VIOLATION at g = %s: floor %s < bound %s"
              % (mp.nstr(gg, 8), mp.nstr(v, 8), mp.nstr(bound, 8)))
    p("")
    p("    violations: %d / %d" % (viol, len(rows)))
    open("out_day023_c1b_discrete.txt", "w").write("\n".join(out) + "\n")
    print("\n".join(out))


if __name__ == "__main__":
    main()
