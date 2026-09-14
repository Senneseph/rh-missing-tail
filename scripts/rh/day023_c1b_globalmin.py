#!/usr/bin/env python3
"""day023 C1b Step 0 — GLOBAL minimizer of the detector scale
||R(g,d,t) - 1|| over the own-regime window
    gamma in [gamma0, gamma_max],  u = t - gamma in (-W, W],  d in (0, 1/2]
R = pref(g,d,t) * exp(s*w/2),  s = 1/2 + i t   (B5 closed form, mirrored
line-for-line from RhAttack/B5.lean and day021_c1b_worstpoint.py).

The closure's near-regime floor is min-over-window ||R-1||; the PINNED
0.9975 is the DISCRETE straddle pin at g ~ 1e3 (day-010).  Promotion =
a proven lower bound from the closed form (this map -> estimates ->
Lean).  This step LOCATES the global structure: where the minimum sits
in (gamma, u, d), its value, and the regime split (gamma0-neighborhood
vs gamma >= gamma*).

Float64 numpy scan (pref is rational + exp of a small omega — float64
is more than adequate for LOCATING minima); the candidates are
re-refined at dps-30 mpmath.
"""
import numpy as np
import mpmath as mp

G0 = 14.134725141734693790457147   # first zero (classical)
W = 12.0                           # |t - gamma| window (the audit window <= 10.2)
DMAX = 0.5


def rabs2(g, u, d):
    """||R(g,d,t=gamma+u) - 1||, float64, arrays u,d allowed."""
    t = g + u
    # pref, line for line from B5.pref
    num = (0.25 + g*g) * (u*u + d*d) * ((g + t)*(g + t) + d*d)
    den = (g*g - t*t) * (0.25 + d + d*d + g*g) * (0.25 - d + d*d + g*g)
    pref = num / den
    w = ((1.0 + 2.0*d) / (0.25 + d + d*d + g*g)
         + (1.0 - 2.0*d) / (0.25 - d + d*d + g*g)
         - 1.0 / (0.25 + g*g))
    s = 0.5 + 1j*t
    R = pref * np.exp(0.5 * s * w)
    return abs(R - 1.0), R


def main():
    out = []
    p = out.append
    p("day023 C1b Step 0: GLOBAL min of ||R-1|| on the own-regime window")
    p("  window: gamma in [%.4f, %.3e], |u| <= %.1f, d in (0, %.1f]"
      % (G0, 1e30, W, DMAX))
    p("=" * 74)

    # coarse stage: log-spaced gamma, fine u and d
    gs = np.geomspace(G0, 1e6, 1500)
    us = np.array([i * 0.01 for i in range(-1200, 1201)])[::2]
    us = us[us != 0.0]
    ds = np.array([i * 0.005 for i in range(1, 101)])
    worst = (np.inf, None)
    per_gamma = []
    for gi, g in enumerate(gs):
        uu, dd = np.meshgrid(us, ds, indexing="ij")
        v, R = rabs2(g, uu, dd)
        i = int(np.argmin(v))
        val = float(v.flat[i])
        u_star, d_star = float(uu.flat[i]), float(dd.flat[i])
        per_gamma.append((g, val, u_star, d_star))
        if val < worst[0]:
            worst = (val, (g, u_star, d_star))
        if (gi + 1) % 300 == 0:
            p("  gammas done: %d/1500  current worst %.6f at g=%.4g"
              % (gi + 1, worst[0], worst[1][0]))
    gw, vw, uw, dw = worst[1][0], worst[0], worst[1][1], worst[1][2]
    p("")
    p("[1] COARSE global minimum (float64, gamma in [14.13, 1e6]):")
    p("    ||R-1|| = %.9f   at gamma = %.9f, u = %.3f, d = %.3f"
      % (vw, gw, uw, dw))
    # neighborhood: the 20 best (g, u, d)
    per_gamma.sort(key=lambda r: r[1])
    p("")
    p("[2] 15 best coarse points:")
    for (gg, vv, uu, dd) in per_gamma[:15]:
        p("    g = %14.6f  ||R-1|| = %.9f  u = %8.3f  d = %6.3f"
          % (gg, vv, uu, dd))

    # refinement: fine local scan around the coarse minimizer (dps-30)
    mp.mp.dps = 30
    us_f = [mp.mpf(i) / 100 for i in range(-30, 31)]
    ds_f = [mp.mpf(i) / 500 for i in range(1, 251)]  # (0, 0.5], dd = 0.002
    g_lo = mp.mpf(repr(max(G0, gw * 0.55)))
    g_hi = mp.mpf(repr(gw * 1.8))
    gs_f = [g_lo * (g_hi/g_lo)**(mp.mpf(i)/150) for i in range(151)]
    best = (None, None)
    bestbox = (None, None)
    for gg in gs_f:
        for u in us_f:
            if u == 0:
                continue
            for d in ds_f:
                t = gg + u
                num = (mp.mpf("0.25") + gg*gg) * (u*u + d*d) * ((gg + t)**2 + d*d)
                den = (gg*gg - t*t) * (mp.mpf("0.25") + d + d*d + gg*gg) \
                      * (mp.mpf("0.25") - d + d*d + gg*gg)
                w = ((mp.mpf(1) + 2*d) / (mp.mpf("0.25") + d + d*d + gg*gg)
                     + (mp.mpf(1) - 2*d) / (mp.mpf("0.25") - d + d*d + gg*gg)
                     - mp.mpf(1) / (mp.mpf("0.25") + gg*gg))
                s = mp.mpc(mp.mpf("0.5"), t)
                R = num/den * mp.e**(s*w)
                v = abs(R - 1)
                if best[0] is None or v < best[0]:
                    best = (v, (gg, u, d, R))
    # local fine box around the box minimum
    v0, (gg0, u0, d0, R0) = best
    p("" if False else "")  # keep order
    best2 = (None, None)
    us_g = [u0 + mp.mpf(i)/500 for i in range(-25, 26) if u0 + mp.mpf(i)/500 != 0]
    ds_g = [max(mp.mpf("0.001"), d0 + mp.mpf(i)/2000) for i in range(-50, 51)
            if d0 + mp.mpf(i)/2000 <= mp.mpf(1)/2]
    gs_g = [gg0 * (1 + mp.mpf(i)/500) for i in range(-50, 51)]
    for gg in gs_g:
        for u in us_g:
            for d in ds_g:
                t = gg + u
                num = (mp.mpf("0.25") + gg*gg) * (u*u + d*d) * ((gg + t)**2 + d*d)
                den = (gg*gg - t*t) * (mp.mpf("0.25") + d + d*d + gg*gg) \
                      * (mp.mpf("0.25") - d + d*d + gg*gg)
                w = ((mp.mpf(1) + 2*d) / (mp.mpf("0.25") + d + d*d + gg*gg)
                     + (mp.mpf(1) - 2*d) / (mp.mpf("0.25") - d + d*d + gg*gg)
                     - mp.mpf(1) / (mp.mpf("0.25") + gg*gg))
                s = mp.mpc(mp.mpf("0.5"), t)
                R = num/den * mp.e**(s*w)
                v = abs(R - 1)
                if best2[0] is None or v < best2[0]:
                    best2 = (v, (gg, u, d, R))
    best = best2
    p("")
    p("[3] dps-30 REFINED minimum (box gamma x0.55..x1.8, then local fine box):")
    p("    ||R-1|| = %s   at gamma = %s, u = %s, d = %s"
      % (mp.nstr(best[0], 12), mp.nstr(best[1][0], 12),
         mp.nstr(best[1][1], 8), mp.nstr(best[1][2], 8)))
    p("    |R| there = %s, arg(R) = %s rad"
      % (mp.nstr(abs(best[1][3]), 10), mp.nstr(mp.arg(best[1][3]), 10)))

    # regime tables: the min over (u,d) on log-spaced gamma, dps-30
    p("")
    p("[4] per-regime window minimums (dps-30, du = 0.05, dd = 0.01, u = +/-):")
    def window_min(gf):
        g = mp.mpf(repr(float(gf)))
        best = (None, None)
        for u in [mp.mpf(k)/20 for k in range(-240, 241)]:
            if u == 0:
                continue
            for d in [mp.mpf(k)/100 for k in range(1, 51)]:
                t = g + u
                num = (mp.mpf("0.25") + g*g) * (u*u + d*d) * ((g + t)**2 + d*d)
                den = (g*g - t*t) * (mp.mpf("0.25") + d + d*d + g*g) \
                      * (mp.mpf("0.25") - d + d*d + g*g)
                w = ((mp.mpf(1) + 2*d) / (mp.mpf("0.25") + d + d*d + g*g)
                     + (mp.mpf(1) - 2*d) / (mp.mpf("0.25") - d + d*d + g*g)
                     - mp.mpf(1) / (mp.mpf("0.25") + g*g))
                s = mp.mpc(mp.mpf("0.5"), t)
                v = abs(num/den * mp.e**(s*w) - 1)
                if best[0] is None or v < best[0]:
                    best = (v, (u, d))
        return best[0], best[1]
    for gf in [G0, 15.0, 20.0, 25.084494961, 30.0, 50.0, 75.0, 100.0, 150.0,
               200.0, 500.0, 999.79157155741, 5000.0, 10000.0, 100000.0, 1e6]:
        v, (u, d) = window_min(gf)
        bound = max(mp.mpf("0.015"), 1 - mp.mpf("23")/mp.mpf(repr(gf)))
        ok = v >= bound
        p("    g = %14.4f  min ||R-1|| = %s   (u = %s, d = %s)   1-23/g = %.5f  [%s]"
          % (gf, mp.nstr(v, 10), mp.nstr(u, 6), mp.nstr(d, 5),
             float(1 - 23.0/gf), "OK" if ok else "VIOLATION"))
    open("out_day023_c1b_globalmin.txt", "w").write("\n".join(out) + "\n")
    print("\n".join(out))


if __name__ == "__main__":
    main()
