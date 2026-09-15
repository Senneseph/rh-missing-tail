#!/usr/bin/env python3
"""day-025 25aa — GAP-W investigation, phase 1: the wire-family map.

GAP-W (S4Asm.lean `gapW`): for t > T0 = 1.1e5,
    p8_B(t, floor(13t/8)) + M e^{X(t)} X(t) < 0.9975   (0 <= M <= Zbound t)
with X(t) = Bf(t,Gc)(Sbar Bc + Sbar Gc) + Cf(t,Gc) Kbar(Gc), Gc = 1e7,
Bc = 1e8 (the Xval wire; in domain only for t < Gc — 25j), and
Zbound(t) = 1.6 t^{1/4} ln t (CITED convexity constant).

Phase 1 establishes three things, all at the wire level:

[1] REGRESSION: the 25l pinned t* = 690349.0568 was bisected on the
    MEASURED-mass variant  B_best(t) + X(t) + |zeta(t)| X(t) = 0.9975
    (day023_s4_sweep.py f).  Reproduce it (validates this script).

[2] BOUND-LEVEL CROSSING: the codified gapW uses M <= Zbound(t).  Map
    D_Z(t) = p8_B(t, 13t/8) + X(t) + Zbound(t) e^{X(t)} X(t) - 0.9975
    on (T0, 1e7-) and locate its crossing t_Z (a NEW number: 25l
    reported the |zeta| variant only).

[3] THE GROWING FAMILY (the conjectured closure of GAP-W): n and the
    band endpoints are FREE closure witnesses (p8_B_floor holds for
    EVERY n; the B3 band theorem needs any B >= G > t).  Map
        D(t; q, r) = p8_B(t, floor(t^q)) + X_{t^r}(t)
                     + Zbound(t) e^{X} X - 0.9975,
    X_{t^r}(t) = Bf(t, G)(Sbar B' + Sbar G) + Cf(t, G) Kbar(G),
    G = t^r (the cap max(G, 1e7) is inert for t >= 1.1e5 when r >= 1),
    B' = 2 G, on (T0, 1e18), for a small family of (q, r).  If some
    family stays below the floor at EVERY t > T0, GAP-W closes at the
    bound level for all t > T0 by endpoint constants (the S4a
    argument style), and the residue is the Lean formalization.
"""
import mpmath as mp
import numpy as np
mp.mp.dps = 30

import day023_p11c_1e7 as p11   # p8_B, B_best, Zbound-free mirrors,
                                # Sbar, Bf, Cf, Kbar (B3Core def level)

T0 = mp.mpf("1.1e5")
Gc = mp.mpf("1e7")
Bc = mp.mpf("1e8")
PIN = mp.mpf("0.9975")
TSTAR_PINNED = mp.mpf("690349.0568")


def Zbound(t):
    return mp.mpf("1.6") * t ** (mp.mpf("1") / 4) * mp.log(t)


def Xval(t, G, B):
    return p11.Bf(t, G) * (p11.Sbar(B) + p11.Sbar(G)) + p11.Cf(t, G) * p11.Kbar(G)


def d_measured(t):
    """25l variant: B_best + X + |zeta| X (the pinned t* function)."""
    tt = t if isinstance(t, mp.mpf) else mp.mpf(str(t))
    X = Xval(tt, Gc, Bc)
    return p11.B_best(float(tt)) + X * (1 + abs(mp.zeta(mp.mpc(0.5, float(tt))))) - PIN


def bound_total(t, n_exp, g_exp):
    """D_Z(t) for the family n = floor(t^n_exp), G = t^g_exp, B = 2G.
    Returns (D, p8B, X, Mf) as mp.mpf/float."""
    tt = t if isinstance(t, mp.mpf) else mp.mpf(str(t))
    n = int(tt ** n_exp)
    if n < 1:
        n = 1
    pB = p11.p8_B(float(tt), n)
    G = tt ** g_exp
    B = 2 * G
    X = Xval(tt, G, B)
    Mf = Zbound(tt) * mp.e**X * X
    return pB + X + Mf - PIN, pB, X, Mf


def bisect(f, lo, hi, iters=90):
    a, b = mp.mpf(str(lo)), mp.mpf(str(hi))
    fa, fb = f(a), f(b)
    if fa * fb > 0:
        return None
    for _ in range(iters):
        m = (a + b) / 2
        fm = f(m)
        if fa * fm <= 0:
            b, fb = m, fm
        else:
            a, fa = m, fm
    return (a + b) / 2


out = []
p = out.append

p("25aa — GAP-W wire-family map (day-025)")
p("=" * 100)

p("")
p("[1] REGRESSION — 25l pinned t* (measured-mass variant):")
# coarse locate then bisect
vals = [d_measured(t) for t in (1e5, 2e5, 3e5, 4e5, 5e5, 6e5, 7e5, 8e5, 9e5)]
p("    " + "  ".join("%.3g: %+.4f" % (t, v) for t, v in zip(
    (1e5, 2e5, 3e5, 4e5, 5e5, 6e5, 7e5, 8e5, 9e5), vals)))
for (lo, hi) in ((1e5, 2e5), (2e5, 3e5), (3e5, 4e5), (4e5, 5e5),
                 (5e5, 6e5), (6e5, 7e5), (7e5, 8e5), (8e5, 9.9e6)):
    if d_measured(lo) * d_measured(hi) < 0:
        tstar = bisect(d_measured, lo, hi)
        break
else:
    tstar = None
if tstar is not None:
    p("    t*_measured (this run) = %s" % mp.nstr(tstar, 11))
    p("    PINNED (25l[3])        = %s" % mp.nstr(TSTAR_PINNED, 11))
    p("    |diff|                 = %.3e   (target: < 1e-2, same kernel)"
      % float(abs(tstar - TSTAR_PINNED)))
else:
    p("    NO CROSSING FOUND in (1e5, 9.9e6) — CHECK")

p("")
p("[2] BOUND-LEVEL CROSSING of the CODIFIED gapW (M <= Zbound), 13t/8 wire:")
def d_Z_codified(t):
    tt = t if isinstance(t, mp.mpf) else mp.mpf(str(t))
    n = int(tt * 13 / 8)
    pB = p11.p8_B(float(tt), n)
    X = Xval(tt, Gc, Bc)
    return pB + X + Zbound(tt) * mp.e**X * X - PIN

tv = [1.1e5, 1.5e5, 2e5, 2.5e5, 3e5, 3.5e5, 4e5, 5e5, 6e5, 7e5, 8e5, 9e5, 9.9e6]
p("    " + "  ".join("%.2g: %+.4f" % (t, d_Z_codified(t)) for t in tv))
for (lo, hi) in zip(tv[:-1], tv[1:]):
    if d_Z_codified(lo) < 0 < d_Z_codified(hi):
        tZ = bisect(d_Z_codified, lo, hi)
        break
else:
    tZ = None
if tZ is not None:
    p("    t_Z (bound level, M = Zbound, 13t/8 + Xval) = %s  NEW" % mp.nstr(tZ, 10))
    p("    (vs the measured-mass t* = %s: the codified wire is conservative,"
      % mp.nstr(TSTAR_PINNED, 8))
    p("     Zbound(t) >> |zeta(t)| by the convexity constant factor)")

p("")
p("[3] GROWING FAMILY  n = floor(t^q), G = t^r, B = 2 t^r   (t > T0):")
p("    (admissibility: G = t^r > t for r > 1; n <= N(G): N(x) >= x/2 for")
p("     x >= 1e4 is CITED-classical; N(t^r) >= t^r/2 >= floor(t^q) since")
p("     r >= q - and the far tail (B, inf) is under the A4.1b far floor 1)")
fams = [(2, 2), (1.5, 1.5), (2, 1.5), (3, 2), (2.5, 2), (1.5, 2)]
# dense log grid T0..1e18
ts = np.geomspace(1.05e5, 1e18, 4000)
for (q, r) in fams:
    worst = None
    for t in ts:
        D, pB, X, Mf = bound_total(mp.mpf(repr(float(t))), mp.mpf(repr(q)), mp.mpf(repr(r)))
        if worst is None or D > worst[0]:
            worst = (D, float(t), float(pB), float(X), float(Mf))
    D, tw, pB, X, Mf = worst
    verdict = "GAP-W CLOSABLE (D < 0 everywhere)" if D < 0 else "fails max D = %+.4g" % float(D)
    p("    q = %-4g r = %-4g   max D = %+.6f  @ t = %.4g    (p8B %.3g, X %.3g, Mf %.3g)   %s"
      % (q, r, float(D), tw, pB, X, Mf, verdict))

# profile of the best family: where is its max, and the left-edge values
q, r = 2, 2
p("")
p("    profile (q = 2, r = 2):")
for t in (1.1e5, 1.5e5, 2e5, 5e5, 1e6, 5e6, 1e7, 1e8, 1e10, 1e12, 1e18):
    D, pB, X, Mf = bound_total(mp.mpf(repr(float(t))), mp.mpf("2"), mp.mpf("2"))
    p("      t = %-8g  p8B = %-12.6g  X = %-12.6g  Mf = %-12.6g  D = %+.8f"
      % (t, pB, X, Mf, float(D)))

# admissibility check: n <= N(G), RVM LOWER bound N(x) >= (x/2pi)(log(x/2pi) - 1)
p("")
p("    admissibility (n = floor(t^2) <= N(G = t^2), RVM lower bound):")
for t in (1.1e5, 1e6, 1e9, 1e18):
    n = int(t ** 2)
    x = t ** 2
    Nlo = (x / (2 * mp.pi)) * (mp.log(x / (2 * mp.pi)) - 1)
    p("      t = %-6g  n = %-8.4g  G = t^2 = %-8.4g  RVM N(G) >= %-8.4g   n <= N(G): %s"
      % (t, n, x, float(Nlo), n <= float(Nlo)))

open("out_day025_gapw_wires.txt", "w").write("\n".join(out) + "\n")
print("\n".join(out))
