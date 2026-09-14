#!/usr/bin/env python3
"""day-023 S4a pin — the closed-form window-regime wire crossing.

W(t) = Bwire(t) + (1 + Z(t)) * e^{X(t)} * X(t)  <  0.9975 (p8_f_near_pin)
  Bwire(t) = p8_B(t, floor(13t/8))     (P4 floor, m=40 onset branch)
  X(t)     = Bf(t,G)(Sbar B + Sbar G) + Cf(t,G) Kbar(G),  G = 1e7, B = 1e8
             (b3BoundExplicit RHS, mirrors verbatim)
  Z(t)     = 1.6 * t^{1/4} * ln t      (CITED convexity-type bound for
             |zeta(1/2 + i t)|, t >= 2; conservative classical constant)
Find t_c = the crossing (bisection), verify monotone increase of W on
[1e3, t_c] (finite differences), fix T0 = a clean endpoint with margin,
and print the rational upper bounds (13 significant digits) needed for
the Lean endpoint check at T0.
"""
import mpmath as mp
mp.mp.dps = 40
import day023_p11c_1e7 as p11

G = mp.mpf("1e7"); B = mp.mpf("1e8")

def Xwire(t):
    t = mp.mpf(t)
    Bf = p11.Bf(t, G); Cf = p11.Cf(t, G)
    return Bf * (p11.Sbar(B) + p11.Sbar(G)) + Cf * p11.Kbar(G)

def Bwire(t):
    t = float(t)
    import math
    n = max(1, int(math.floor(13.0 * t / 8.0)))
    return p11.B_best_raw(t, n)   # p8_B(t, n) verbatim

def Zbound(t):
    t = mp.mpf(t)
    return mp.mpf("1.6") * t**(mp.mpf(1)/4) * mp.log(t)

def W(t):
    t = mp.mpf(t)
    X = Xwire(t)
    return mp.mpf(Bwire(t)) + (1 + Zbound(t)) * mp.e**X * X

f = lambda t: W(t) - mp.mpf("0.9975")
a, b = mp.mpf(1000), mp.mpf(9e5)
fa, fb = f(a), f(b)
print("W(1e3) = %.12f  (f = %.6f)" % (float(W(a)), float(fa)))
print("W(9e5) = %.12f  (f = %.6f)" % (float(W(b)), float(fb)))
assert fa < 0 < fb
tc = mp.findroot(lambda x: W(x) - mp.mpf("0.9975"), [a, b]) \
     if False else None
# bisection (robust against float noise)
lo, hi = float(a), float(b)
for _ in range(200):
    m = 0.5 * (lo + hi)
    if f(m) < 0: lo = m
    else: hi = m
t_c = mp.mpf(str(0.5 * (lo + hi)))
print("t_c (closed-form crossing) = %s" % mp.nstr(t_c, 12))
# monotonicity check: finite differences, 400 log-spaced points
ok_mono = True
prev = None
for i in range(401):
    t = mp.mpf(1000) * (mp.mpf(hi)/mp.mpf(1000))**(mp.mpf(i)/400)
    w = float(W(t))
    if prev is not None and w < prev - 1e-9:
        ok_mono = False
        print("  NON-MONOTONE at t = %s: %f < %f" % (mp.nstr(t, 8), w, prev))
    prev = w
print("W monotone increasing on [1e3, t_c] (400-pt check): %s" % ok_mono)
# endpoint: largest multiple of 10^4 strictly below t_c
T0 = int(t_c // mp.mpf("1e4")) * 10000
print("T0 = %d" % T0)
print("W(T0) = %.12f   margin = %.6f" % (float(W(T0)), float(0.9975 - W(T0))))
# rational bounds at T0 for the Lean endpoint check (13 sig digits)
import math
nT0 = int(math.floor(13.0 * T0 / 8.0))
a3 = (math.sqrt(3) / 540.0)
c = complex(0.5, T0)
t3 = abs(c * (c + 1) * (c + 2))
s = math.hypot(0.5, T0)
b1 = 0.5 * nT0**-0.5
b2 = (s / 12.0) * nT0**-1.5
b3 = a3 * t3 * nT0**-2.5
X0 = float(Xwire(mp.mpf(T0)))
Z0 = float(Zbound(mp.mpf(T0)))
mterm = (1 + Z0) * math.exp(X0) * X0
print("")
print("Lean endpoint data at T0 = %d (n = floor(13 T0/8) = %d):" % (T0, nT0))
print("  Bwire term1 = %.12e  <= %d/10^k  -> use %.6e" % (b1, 0, b1 * 1.000001))
print("  Bwire term2 = %.6e" % b2)
print("  Bwire term3 = %.6e" % b3)
print("  Bwire total = %.12f" % (b1 + b2 + b3))
print("  X(T0)       = %.12f" % X0)
print("  Z(T0)       = %.12f" % Z0)
print("  (1+Z) e^X X = %.12f" % mterm)
print("  W(T0) total = %.12f  (< 0.9975 with margin %.6f)" % (b1+b2+b3+mterm, 0.9975-b1-b2-b3-mterm))
