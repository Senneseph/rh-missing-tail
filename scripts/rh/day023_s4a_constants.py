#!/usr/bin/env python3
"""S4a Lean atom — constant certification (day-023 25m).

Computes the EXACT Lean-provable upper bound for each Bwire term on
t in [1000, 110000] with list scale n = floor(13t/8), plus the mass
wire bound, and verifies each bound by 100k-point dense sampling.
Every bound is one that the Lean proof will establish; the decimals
printed are the padded values to hard-code as R1..RM.

Lean-side bound structures (see S4Window.lean docstring):
  n >= (13t/8) * (1624/1625)    for t >= 1000   [1 - 8/(13t) >= 1 - 1/1625]
  term1 = (1/2) n^(-1/2)
        <= (1/2) * sqrt(8/13) * sqrt(1625/1624) * t^(-1/2)
        <= (1/2) * sqrt(8/13) * sqrt(1625/1624) * (1/sqrt(1000))
  term2 = sqrt(1/4+t^2)/12 * n^(-3/2)
        <= (t+1/2)/12 * (8/13)^(3/2) * (1625/1624)^(3/2) * t^(-3/2)
        =  (8/13)^(3/2) (1625/1624)^(3/2) * (1 + 1/(2t)) / (12 sqrt(t))
        <= [(8/13)^(3/2) (1625/1624)^(3/2)] * (1.0005) / (12 sqrt(1000))
  term3 = (sqrt(3)/540) * ||s(s+1)(s+2)|| * n^(-5/2)
        <= (sqrt(3)/540) * (8/13)^(5/2) (1625/1624)^(5/2) * sqrt(t)
            * (1 + 3.5/t + 6/t^2 + 1/t^3)
        <= (sqrt(3)/540) * [(8/13)^(5/2)(1625/1624)^(5/2)] * sqrt(T0)
            * (1 + 3.5/1000 + 6/1e6 + 1e-9)
  M <= 1.6 * t^(1/4) * ln t <= 1.6 * 18.23 * 12    (t^(1/4) <= T0^(1/4)
        <= 18.23 since 18.23^4 >= 110000;  ln t <= ln T0 < 12 since
        e^12 = 162754.79 > 110000)
  exp(Xwire) <= exp(RX),  RX = 0.00185,  exp(RX) <= 1.002
  RM = RZ * 1.002 * RX
"""
import math

T0 = 110000.0
LO = 1000.0
NPTS = 200_000

def n_of(t):
    return math.floor(13 * t / 8)

def term1(t):
    return 0.5 * n_of(t) ** -0.5

def term2(t):
    return math.sqrt(0.25 + t * t) / 12 * n_of(t) ** -1.5

def term3(t):
    n = n_of(t)
    mag = math.sqrt(0.25 + t * t) * math.sqrt(1 + t * t) * math.sqrt(4 + t * t)
    return math.sqrt(3) / 540 * mag * n ** -2.5

# ---- bound expressions (the Lean targets) ----
s813 = math.sqrt(8 / 13)
s1625 = math.sqrt(1625 / 1624)

B1 = 0.5 * s813 * s1625 / math.sqrt(1000)

C2 = (8 / 13) ** 1.5 * (1625 / 1624) ** 1.5
B2 = C2 * 1.0005 / (12 * math.sqrt(1000))

C3 = (8 / 13) ** 2.5 * (1625 / 1624) ** 2.5
B3 = (math.sqrt(3) / 540) * C3 * math.sqrt(T0) * (1 + 3.5 / 1000 + 6 / 1e6 + 1e-9)

# Xwire(T0) reference (python mirror of Bf/Cf/Kbar/Sbar, G = 1e7, B = 1e8)
G, B = 1e7, 1e8

def Sbar(x):
    lx = math.log(x)
    return 0.110 * lx + 0.290 * math.log(lx) + 2.290

def Bf(t, G):
    A = G * G + 0.25
    uw = (t * t + 0.25) / A
    return 1 / (2 * A) + uw / (1 - uw) + t / A

def Cf(t, G):
    return 1 + 2 * (t * t + 0.25) * G * G / (G * G - t * t)

def Kbar(G):
    return (0.110 * (math.log(G) + 0.5) + 0.290 * (math.log(math.log(G)) + 0.5) + 2.290) / (2 * G * G)

Xwire_T0 = Bf(T0, G) * (Sbar(B) + Sbar(G)) + Cf(T0, G) * Kbar(G)

# ---- dense verification: every bound >= actual term everywhere ----
worst1 = worst2 = worst3 = 0.0
argworst1 = argworst2 = argworst3 = LO
for i in range(NPTS + 1):
    t = LO + (T0 - LO) * i / NPTS
    n = n_of(t)
    v1, v2, v3 = term1(t), term2(t), term3(t)
    # bound1 at this t (t-dependent part uses t, not just endpoints):
    b1 = 0.5 * s813 * s1625 / math.sqrt(t)
    b2 = C2 * (1 + 1 / (2 * t)) / (12 * math.sqrt(t))
    b3 = (math.sqrt(3) / 540) * C3 * math.sqrt(t) * (1 + 3.5 / t + 6 / t**2 + 1 / t**3)
    if v1 > b1:
        worst1 = max(worst1, v1 / b1); argworst1 = t
    if v2 > b2:
        worst2 = max(worst2, v2 / b2); argworst2 = t
    if v3 > b3:
        worst3 = max(worst3, v3 / b3); argworst3 = t

print("=== per-term actual maxima (sampled) ===")
for i in range(NPTS + 1):
    t = LO + (T0 - LO) * i / NPTS
    print(f"t={t:.0f}  term1={term1(t):.7f}  term2={term2(t):.7f}  term3={term3(t):.7f}"
          f"  sum={term1(t)+term2(t)+term3(t):.7f}") if i % 20000 == 0 else None

print()
print("=== bound verification (bound < actual detected? must be NONE) ===")
print(f"term1: max v1/b1 over sample = {1 + max(0, worst1):.9f} (arg t={argworst1:.0f})")
print(f"term2: max v2/b2 over sample = {1 + max(0, worst2):.9f} (arg t={argworst2:.0f})")
print(f"term3: max v3/b3 over sample = {1 + max(0, worst3):.9f} (arg t={argworst3:.0f})")

print()
print("=== constant candidates (pad 1e-5 absolute where tight) ===")
R1 = B1 * (1 + 1e-4)
R2 = B2 * (1 + 1e-4)
R3 = B3 * (1 + 1e-4)
RX = 0.00185
RZ = 1.6 * 18.23 * 12  # t^(1/4) <= 18.23, ln t <= 12
RM = RZ * 1.002 * RX
print(f"B1 = {B1:.9f}   -> R1 := {R1:.5f}")
print(f"B2 = {B2:.9f}   -> R2 := {R2:.5f}")
print(f"B3 = {B3:.9f}   -> R3 := {R3:.5f}")
print(f"Xwire(T0) = {Xwire_T0:.7f}   (RX pad 0.00185 ok: {Xwire_T0 < RX})")
print(f"RZ := {RZ:.1f}   (349.824 = 1.6*18.23*12 = {1.6*18.23*12:.4f})")
print(f"RM := {RM:.5f}   (RZ*1.002*RX = {RZ*1.002*RX:.7f})")
TOT = R1 + R2 + R3 + RM
print(f"TOTAL = {TOT:.5f}   pin = 0.9975   margin = {0.9975 - TOT:.5f} ({(0.9975-TOT)/0.9975*100:.2f}%)")
print()
print("=== 18.23^4 >= 110000 check ===")
print(f"18.23^4 = {18.23**4:.1f}  >= 110000: {18.23**4 >= 110000}")
print(f"e^12 = {math.e**12:.2f}  > 110000: {math.e**12 > 110000}")
print(f"e^0.00185 = {math.e**0.00185:.9f} <= 1.002: {math.e**0.00185 <= 1.002}")
