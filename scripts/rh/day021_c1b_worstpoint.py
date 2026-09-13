#!/usr/bin/env python3
"""day021 C1b Step 0 — the WORST POINT of the near-regime detector scale.

The branch-locus question (spec c1b-branch-locus-abstract.md):
on the own-regime window
    gamma >= gamma0,  0 < |t - gamma| <= W,  0 < delta <= delta_max,
the ratio magnitude
    |R(g,d,t)| = |pref(g,d,t)| * exp(omegaD(g,d)/2)
is small (pref ~ (t-g)/(gamma+t) -> 0 at the pole column t = gamma;
the B5 Lean theorems exclude t = gamma).  The reverse-triangle fact
(P8 A3.2a) then gives
    ||R - 1|| >= 1 - |R|        (|R| <= 1)
so the detector floor is 1 - max |R| on the window.

Mirrors RhAttack/B5.pref / RhAttack/B5.omegaD LINE-FOR-LINE
(Lean 4.33.1, machine-checked), plus the B5Float cross-check class.
Constants are COMPUTED here, never recalled.

Outputs:
  - the worst point (gamma*, u* = t-gamma, delta*) and Rmag there
  - the gamma-direction (monotonicity across decades)
  - the delta-edges (delta -> 0+ and delta = delta_max) as functions of u
  - the resulting floor f = 1 - Rmax and the margin comparison vs the
    audit's 0.9975 and the 1/112.6 decision threshold.
"""
import math

def pref(g, d, t):
    # B5.pref, line for line:
    # (1/4 + g^2) * ((g - t)^2 + d^2) * ((g + t)^2 + d^2)
    #   / ((g^2 - t^2) * (1/4 + d + d^2 + g^2) * (1/4 - d + d^2 + g^2))
    num = (0.25 + g*g) * ((g - t)*(g - t) + d*d) * ((g + t)*(g + t) + d*d)
    den = (g*g - t*t) * (0.25 + d + d*d + g*g) * (0.25 - d + d*d + g*g)
    return num / den

def omegaD(g, d):
    # B5.omegaD, line for line:
    # (1 + 2d)/(1/4 + d + d^2 + g^2) + (1 - 2d)/(1/4 - d + d^2 + g^2)
    #   - 1/(1/4 + g^2)
    return ((1.0 + 2.0*d) / (0.25 + g*g + d + d*d)
            + (1.0 - 2.0*d) / (0.25 + g*g - d + d*d)
            - 1.0 / (0.25 + g*g))

def rabs(g, d, t):
    return abs(pref(g, d, t)) * math.exp(0.5 * omegaD(g, d))

def main():
    out = []
    p = out.append
    p("day021 C1b Step 0: worst point of |R| = |pref| e^{omega/2}, t != g")
    p("=" * 74)

    # --- gamma direction: decades -------------------------------------
    p("\n[1] gamma-direction (u fixed at 0.5, 5, 10, 12; delta = 0.1):")
    gammas = [14.134725142, 50.0, 100.0, 999.791572, 1e4, 1e5, 3e5]
    for g in gammas:
        row = f"  g = {g:12.5f}:"
        for u in (0.5, 5.0, 10.0, 12.0):
            row += f"  u={u:5.1f}: {rabs(g, 0.1, g + u):.6e}"
        p(row)

    # --- worst point on the window (fine scan) ------------------------
    W, dmax = 12.0, 0.5
    g0 = 14.134725142   # smallest certified zero height (day logs)
    worst = (0.0, None, None, None)
    us = [i * 0.01 for i in range(1, int(W * 100) + 1)]
    us += [1.0, 2.0, 3.0, 5.0, 8.0, 10.0, 12.0]
    ds = [0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5]
    samples = []   # (Rmag, theta, g, u, sgn, d)
    for g in gammas:
        for sgn in (1.0, -1.0):
            for u in us:
                t = g + sgn * u
                for d in ds:
                    th = omegaD(g, d) * (0.5 + t)   # the phase (mod 2pi)
                    samples.append((rabs(g, d, t), th, g, u, sgn, d))
    mx = max(samples, key=lambda s: s[0])
    v, _th, g, u, sgn, d = mx
    mn = min(samples, key=lambda s: s[0])
    vmin, _thm, gmin, umin, sgnmin, dmin = mn
    p("\n[2] |R| extremes on the window (g0..3e5 x |u| <= 12 x d in grid):")
    p(f"  Rmag MAX = {v:.9e}   at g = {g}, u = {u}, sgn = {sgn}, d = {d}")
    p(f"  Rmag MIN = {vmin:.9e}  at g = {gmin}, u = {umin}, sgn = {sgnmin}, d = {dmin}")
    if v <= 1.0:
        p(f"  (all |R| <= 1: reverse-triangle floor = 1 - Rmax = {1.0 - v:.9f}")
    else:
        below = [x[0] for x in samples if x[0] <= 1.0]
        above = [x[0] for x in samples if x[0] >= 1.0]
        p(f"  |R| CROSSES 1 in the window (region-dependent floor):")
        if below:
            p(f"   |R| <= 1 region: 1 - max|R| = {1.0 - max(below):.9f}")
        if above:
            p(f"   |R| >= 1 region: min|R| - 1 = {min(above) - 1.0:.9f}")
    ths = [x[1] for x in samples]
    p(f"  phase theta = (1/2+t)*omega range: min {min(ths):.6f}, max {max(ths):.6f} rad")
    p(f"  unit-circle (R=1) candidate floor 2|sin(theta_min/2)| = {2*abs(math.sin(min(ths)/2)):.6f}")

    # --- which (u, d) actually matters: the d-0 edge -------------------
    p("\n[3] the d -> 0+ edge (pref(0) = (g^2 - t^2)/(1/4+g^2)):")
    for g in (g0, 100.0, 999.791572, 1e4):
        row = f"  g = {g:12.5f}:"
        for u in (0.5, 5.0, 10.0, 12.0):
            pv = abs((g*g - (g + u)*(g + u))) / (0.25 + g*g)
            p2 = abs(pref(g, 0.0, g + u))
            ok = "OK" if abs(pv - p2) < 1e-12 else "MISMATCH"
            row += f"  u={u:5.1f}: {p2:.4e} [{ok}]"
        p(row)
    p("  (the d=0 edge value is tiny ~ u/g * (1/(1/4+g^2)) * (t^2+g^2)...")
    p("   check the actual size per row above)")

    # --- d = dmax edge --------------------------------------------------
    p("\n[4] the d = 0.5 edge:")
    for g in (g0, 999.791572, 1e4):
        row = f"  g = {g:12.5f}:"
        for u in (0.5, 5.0, 10.0, 12.0):
            row += f"  u={u:5.1f}: {rabs(g, 0.5, g + u):.4e}"
        p(row)

    # --- decision comparison -------------------------------------------
    p("\n[5] decision comparison (day-020 audits):")
    p(f"  audit near floor (d4, pinned at g ~ 1e3) : 0.9975")
    if v <= 1.0:
        f_est = 1.0 - v
    else:
        below = [x[0] for x in samples if x[0] <= 1.0]
        above = [x[0] for x in samples if x[0] >= 1.0]
        cands = []
        if below:
            cands.append(1.0 - max(below))
        cands.append(min([abs(x[0] - 1.0) for x in samples if abs(x[0] - 1.0) > 1e-12] + [2 * abs(math.sin(min(ths) / 2))]))
        f_est = min(cands)
    p(f"  this run floor estimate              : {f_est:.6f}")
    thr = 1.0 / 112.6
    p(f"  decision threshold 1/112.6           : {thr:.6f}")
    p(f"  floor vs threshold ratio             : {f_est / thr:.1f}x")
    p("  (the margin audit verified resid/dev >= 1/112.6 on the windows;")
    p("   the floor only needs to beat the local resid/dev, ~2.1e-2..1e-2")
    p("   in the worstcase record — the 0.9975 near floor is conservative)")

    # --- the t < g vs t > g asymmetry at the worst g --------------------
    p("\n[6] t<g vs t>g at g = 999.791572, d = 0.1, u sweep:")
    for u in (0.05, 0.5, 5.0, 10.0, 12.0):
        p(f"  u = {u:6.2f}:  t>g: {rabs(999.791572, 0.1, 999.791572 + u):.6e}"
          f"   t<g: {rabs(999.791572, 0.1, 999.791572 - u):.6e}")

    # --- the |R| = 1 crossing: where, and the phase there ----------------
    p("\n[7] the |R| = 1 crossing (floor candidates at the crossing):")
    for g in (g0, 50.0, 100.0, 999.791572):
        rows = []
        for d in ds:
            prev = rabs(g, d, g + 0.001)
            uc = None
            for i in range(1, 2000):
                u = i * 0.006
                t = g + u
                cur = rabs(g, d, t)
                if (prev - 1.0) * (cur - 1.0) <= 0 and prev != 1.0:
                    uc = u
                    break
                prev = cur
            if uc is not None:
                th = omegaD(g, d) * (0.5 + g + uc)
                val = 2 * abs(math.sin(th / 2.0))
                rows.append(f"   d = {d:5.3f}: u_c = {uc:8.4f}, theta = {th:.6f}, floor_cand = {val:.6f}")
        if rows:
            p(f"  g = {g:12.5f} (t > g side)")
            p("\n".join(rows))
        else:
            p(f"  g = {g:12.5f}: no |R| = 1 crossing in u in (0, 12]")

    print("\n".join(out))
    with open("out_day021_c1b_worst.txt", "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
