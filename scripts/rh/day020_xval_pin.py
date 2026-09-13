#!/usr/bin/env python3
"""day-020 — Xval pin: the concrete M(G,t) constant at the measurement point.

Pins the hypothesis |x| <= Xval of P8Floor `p8_residual_wired` (A4.3)
at a concrete measurement point, COMPUTED (never recalled):

  x    := Tt - sum_{g in L, G < g <= B} fT(t, g)      (model - actual sum)
  Tt   := integral_G^B nHat(x) fT(t, x) dx            (quadrature, dps-30)
  Xval := Bf(t,G) (Sbar B + Sbar G) + Cf(t,G) Kbar G  (b3BoundExplicit RHS)

All model functions mirror formal/RhAttack/B3Core.lean line-for-line
(no-recall rule: copied TODAY from the Lean definitions, not from
memory). The hS premise of b3BoundExplicit is checked at x = G and
x = B against the certified zero list:
  |NList L x - NHat x| <= Sbar x.

Data: scripts/rh/zeros_T100000.txt (certified zero heights <= 1e5,
dps-30, day-014 record).
Measurement point: the day-010 d4d3 audit config, t = 1000.041572
(5th audit t, pair gamma* = 999.791572), band (G, B] = (2t, 1e5].
"""
import math
import bisect
import sys
import mpmath
from mpmath import mp

mp.dps = 30

# ---------- B3Core.lean mirrors (copied 2026-09-16) ----------
TWOPI_INV = 1 / (2 * mp.pi)

def nHat(x):      # log(x/(2 pi)) / (2 pi)
    return mp.log(x * TWOPI_INV) * TWOPI_INV

def NHat(x):      # x/(2 pi) (log(x/(2 pi)) - 1) + 7/8
    return x * TWOPI_INV * (mp.log(x * TWOPI_INV) - 1) + mp.mpf(7) / 8

def Sbar(x):      # 0.110 ln x + 0.290 ln ln x + 2.290
    return mp.mpf("0.110") * mp.log(x) + mp.mpf("0.290") * mp.log(mp.log(x)) + mp.mpf("2.290")

def u(x):         # x^2 + 1/4
    return x * x + mp.mpf(1) / 4

def w(t):         # t^2 + 1/4
    return t * t + mp.mpf(1) / 4

def fT(t, x):     # 1/2/u(x) + log(1 - w(t)/u(x)),  x > t
    return mp.mpf(1) / 2 / u(x) + mp.log(1 - w(t) / u(x))

def Bf(t, G):     # |fT| bound at x >= G > t
    uw = w(t) / (G * G + mp.mpf(1) / 4)
    return mp.mpf(1) / (2 * (G * G + mp.mpf(1) / 4)) + uw / (1 - uw) + t / (G * G + mp.mpf(1) / 4)

def Cf(t, G):     # |fT'| x^3 bound
    return 1 + 2 * w(t) * (G * G) / (G * G - t * t)

def Kbar(G):      # upper bound of integral_G^B Sbar x / x^3  (B >= G >= e)
    return (mp.mpf("0.110") * (mp.log(G) + mp.mpf(1) / 2)
            + mp.mpf("0.290") * (mp.log(mp.log(G)) + mp.mpf(1) / 2)
            + mp.mpf("2.290")) / (2 * G * G)

def NList(zeros, x):   # #{g in L : g <= x}
    return bisect.bisect_right(zeros, float(x))

# ---------- data ----------
ZFILE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_T100000.txt"
zeros = [float(l) for l in open(ZFILE) if l.strip()]
zeros.sort()
N_total = len(zeros)
top = zeros[-1]
print(f"list: {N_total} zeros, heights up to {top:.1f}")

def run(t, G, B, label):
    s = mp.mpf(t)
    Gm, Bm = mp.mpf(G), mp.mpf(B)
    # actual sum over (G, B]
    hi = bisect.bisect_right(zeros, float(B))
    lo = bisect.bisect_right(zeros, float(G))
    nband = hi - lo
    total = mp.mpf(0)
    for g in zeros[lo:hi]:
        total += fT(s, mp.mpf(g))
    # model Tt = integral_G^B nHat(x) fT(t,x) dx
    Tt = mp.quad(lambda x: nHat(x) * fT(s, x), [Gm, mp.inf, Bm]) if Bm == mp.inf else \
         mp.quad(lambda x: nHat(x) * fT(s, x), [Gm, Bm])
    xdefect = Tt - total
    # b3BoundExplicit RHS
    Xval = Bf(s, Gm) * (Sbar(Bm) + Sbar(Gm)) + Cf(s, Gm) * Kbar(Gm)
    # hS premise at G and B (B only if finite and in the list)
    hsG = abs(NList(zeros, Gm) - NHat(Gm))
    hsB = abs(NList(zeros, Bm) - NHat(Bm))
    okG = hsG <= Sbar(Gm)
    okB = hsB <= Sbar(Bm)
    margin = Xval / abs(xdefect)
    print(f"\n--- Xval pin: {label} ---")
    print(f"t = {t}   band (G, B] = ({G}, {B}]   n_band = {nband}")
    print(f"actual sum  = {mp.nstr(total, 14)}")
    print(f"Tt (model)  = {mp.nstr(Tt, 14)}")
    print(f"x = Tt - sum = {mp.nstr(xdefect, 14)}   |x| = {mp.nstr(abs(xdefect), 14)}")
    print(f"Sbar G = {mp.nstr(Sbar(Gm), 10)}   Sbar B = {mp.nstr(Sbar(Bm), 10)}")
    print(f"Bf = {mp.nstr(Bf(s, Gm), 10)}   Cf = {mp.nstr(Cf(s, Gm), 10)}   Kbar G = {mp.nstr(Kbar(Gm), 10)}")
    print(f"Xval (b3BoundExplicit RHS) = {mp.nstr(Xval, 14)}")
    print(f"hS at G: |NList - NHat| = {mp.nstr(hsG, 10)} <= Sbar G = {mp.nstr(Sbar(Gm), 10)}   {okG}")
    print(f"hS at B: |NList - NHat| = {mp.nstr(hsB, 10)} <= Sbar B = {mp.nstr(Sbar(Bm), 10)}   {okB}")
    print(f"MARGIN  = Xval / |x| = {mp.nstr(margin, 6)}")
    print(f"hS-premise + |x| <= Xval : {'PASS' if (okG and okB and abs(xdefect) <= Xval) else 'FAIL'}")
    return abs(xdefect) <= Xval, okG and okB, margin

allok = True
for (t, G, B, lab) in [
    (1000.041572, 2000.083144, 1e5, "audit point t=1000.041572, band (2t, 1e5]"),
]:
    ok1, ok2, _ = run(t, G, B, lab)
    allok = allok and ok1 and ok2

print("\n" + ("XVAL PIN PASS (hS premise verified + |x| <= Xval)" if allok else "XVAL PIN FAIL"))
sys.exit(0 if allok else 1)
