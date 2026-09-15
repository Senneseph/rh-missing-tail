#!/usr/bin/env python3
"""25ab+ — Bellotti-Fiori admissibility check (background job, item 3).

Owner directive (2026-09-16): "kick off 3 in the background" — verify the
Bellotti-Fiori two-sided RVM bound (arXiv:2412.15470 v2, accepted Math.
Comp.; owner online check 2026-09-15) as an ALTERNATIVE admissibility chain
for S4G.s4g_admissible, so the Lean tightening (s4g_admissible_bf) is
cert-backed before it is written:

  |N(T) - (T/2pi) * log(T/(2pi e))| <= 0.10076 log T + 0.24460 log log T
  + 8.08344          for T >= e

=> N_low_bf(x) >= x for x >= T0^2, with
  N_low_bf(x) := (x/2pi)(log(x/2pi) - 1)
                 - (10076/100000) log x
                 - (24460/100000) log log x
                 - (808344/100000)

Exact rationals per the project discipline (no decimal literals in the
Lean edit).  Cross-checks the same chain the Lean proof uses, with the
BF constants in place of Backlund's 0.137/0.443/4.4.
"""
import mpmath as mp
import numpy as np
mp.mp.dps = 50

T0 = mp.mpf("1.1e5")
X0 = T0 * T0
TWOPI = mp.mpf(2) * mp.pi

# BF constants as exact rationals:
C1 = mp.mpf(10076) / mp.mpf(100000)   # 0.10076
C2 = mp.mpf(24460) / mp.mpf(100000)   # 0.24460
C3 = mp.mpf(808344) / mp.mpf(100000)  # 8.08344

def N_low_bf(z):
    return (z / TWOPI) * (mp.log(z / TWOPI) - 1) \
        - C1 * mp.log(z) - C2 * mp.log(mp.log(z)) - C3

out = []
def p(*a):
    line = " ".join(str(x) for x in a)
    out.append(line)
    print(line)

p("=" * 72)
p("25ab+ BF admissibility verification (dps-50)")
p(f"T0 = {T0}, X0 = T0^2 = {X0}")
p(f"C1 = {C1}, C2 = {C2}, C3 = {C3} (exact rationals)")
p("")

p("[1] ratio at T0^2 (need >= 1):")
r0 = N_low_bf(X0) / X0
p(f"  N_low_bf(T0^2)/T0^2 = {mp.nstr(r0, 12)} : {r0 >= 1}")

p("")
p("[2] min ratio on [T0^2, 1e40] (geomspace scan):")
worst = None
for tf in np.geomspace(float(X0), 1e40, 600):
    z = mp.mpf(repr(float(tf)))
    r = N_low_bf(z) / z
    if worst is None or r < worst[0]:
        worst = (r, float(tf))
p(f"  min ratio = {mp.nstr(worst[0], 12)} @ {worst[1]:.6g} : {worst[0] >= 1}")

p("")
p("[3] structural chain (the Lean-proof shape, BF constants):")
p("  (a) main term: 18/(2pi) >= 63/22 (unchanged from the Backlund chain):")
a = mp.mpf(18) / TWOPI
b = mp.mpf(63) / mp.mpf(22)
p(f"      18/(2pi) = {mp.nstr(a, 12)} >= 63/22 = {mp.nstr(b, 12)} : {a >= b}")
p("  (b) log terms: C1 ln x + C2 ln ln x + C3 <= (C1/2) x + (C2/2)(ln x - 1) + C3")
p("      <= (C1 + C2)/2 * x + (C3 - C2)   [ln x <= x/2, ln ln x <= ln x - 1]")
coef = (C1 + C2) / 2
const = C3 - C2
p(f"      coef = (C1+C2)/2 = {mp.nstr(coef, 12)}; const = C3 - C2 = {mp.nstr(const, 12)}")
p("  (c) need (63/22) x - [coef*x + const] >= x  i.e.  (63/22 - coef - 1) x >= const")
cres = b - coef - mp.mpf(1)
xneed = const / cres
p(f"      residual coef = {mp.nstr(cres, 12)};  x >= {mp.nstr(xneed, 10)} suffices")
p(f"      T0^2 / xneed = {mp.nstr(X0 / xneed, 10)}  (margin on the x-floor)")

p("")
p("[4] exact-rational floor step at T0^2 (norm_num-able):")
# (63/22)*T0^2 - (coef*T0^2 + const) >= T0^2  in exact rationals (coef rational here)
lhs = b * X0 - (coef * X0 + const)
p(f"  (63/22)T0^2 - ((C1+C2)/2)T0^2 - (C3-C2) = {mp.nstr(lhs, 15)} >= T0^2 : {lhs >= X0}")

ok = (r0 >= 1) and (worst[0] >= 1) and (a >= b) and (cres > 0) and (lhs >= X0)
p("")
p("ALL PASS" if ok else "CHECK FAILURES")
open("out_day026_admissibility_bf.txt", "w").write("\n".join(out) + "\n")
