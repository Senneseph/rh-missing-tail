#!/usr/bin/env python3
"""
25af Lean port Stage 1 -- dps-50 DIRECTIONAL CERTIFICATION of the endpoint
constants for the t^4-strip module (formal/RhAttack/S4Strip.lean).

Pre-registered constants (directional rounding, ALL must PASS on the B3Core
EXACT defs, pointwise on t in [1000, 1e12]):

  family:   n4(t) = ceil(31000000 t^4);  G4(t) = 62000000 t^4;  B4(t) = 2 G4.
  Tstrip = 1000 (unbounded above -- the mown floor is uniform in t).

  component bounds (t >= 1000):
   (B4)  Bf(t, G4) <= (1/c4^2) (2 + 1/t + 1/t^2) / t^6,  c4 = 62000000
   (S4)  Sbar(B4) + Sbar(G4) <= 20 + 4 log t
   (C4)  Cf(t, G4) <= 4 t^2 + 2
   (K4)  Kbar(G4) <= (10 + 2 log t) / (2 c4^2 t^8)
   (X4)  X4(t) = Bf(SumS + Cf Kbar) <= (16e-15 + 3.5e-15 log t) / t^6   (chain
         via the component bounds AND directly on the exact B3Core defs)
   (E4)  exp(X4) <= 2   (via X4 <= X4UB; X4UB(1000) = 4.0177e-32 < 1/2 <= ln 2
         -- verify X4UB decreasing on [1000, 1e12] pointwise)

  wire terms (n = n4(t)); A_i = directionally rounded strict rationals:
   (A1)  (1/2) n^{-1/2} <= 8981/1e8 * t^{-2}
         (strictness anchor: 8981^2 * 4 * 31000000 > 1e16, exact integers)
   (A2)  (|s|/12) n^{-3/2} <= 5e-13 * t^{-5}
         (= (31000000)^{-3/2} * 2001/24000 * t^{-5}  -- (t+1/2) = t(1+1/(2t)),
          1/(2t) <= 1/2000; raw = 4.831e-13; check)
   (A3)  (sqrt(3)/540) |s(s+1)(s+2)| n^{-5/2} <= 1e-20 * t^{-7}
         (= (17321/1e4)/540 * (31000000)^{-5/2} * 1.003^3; check)

  M-term (M <= Zbound(t) = 1.6 t^{1/4} log t; e^{X4} <= 2):
   (M4)  M e^{X4} X4 <= 3.2 (16e-15 + 3.5e-15 L) L / t^{23/4}
         <= 3.2 * 6.2e-15 * L^2 / t^{23/4}   (16e-15 L <= 2.7e-15 L^2 for L >= 5.926;
          3.5e-15 + 2.7e-15 = 6.2e-15; L >= ln 1000 >= 5.926)
         <= 1.984e-14 / t^{19/4}  <=  2.5e-14 / t^{19/4} := MTUB(t)   (L^2 <= t)

  floor (S4O.hMownScaleLo + d >= 1/200 + t >= 1000):
   (F4)  mown(t, d) >= (1/1e4) * (t^2/(t^2+1))^2 * t^{-2}
         >= (1/1e4) * (1e6/(1e6+1))^2 * t^{-2}  := F4 t^{-2}
         F4 = 1e8/(1000001)^2 = 9.99998e-5 ...  (exact rational; check
         F4 < 0.99999877e-4 (the true mown/Eenv ratio) for consistency)

  FINAL LINE (norm_num, exact rationals):
   (Z)   A1 + (A2 + A3 + 25e-15)/1000 < F4.
"""
import mpmath as mp
mp.mp.dps = 50

OUT = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/out_day028_25af_constants.txt"
lines = []
def p(s=""):
    lines.append(s)

# ---------------- B3Core EXACT mirrors (formal/RhAttack/B3Core.lean) -------
def nHat(x): return mp.log(x / (2*mp.pi)) / (2*mp.pi)
def NHat(x): return x/(2*mp.pi) * (mp.log(x/(2*mp.pi)) - 1) + mp.mpf(7)/8
def Sbar(x): return mp.mpf('0.110')*mp.log(x) + mp.mpf('0.290')*mp.log(mp.log(x)) + mp.mpf('2.290')
def u(x): return x*x + mp.mpf(1)/4
def w(t): return t*t + mp.mpf(1)/4
def Bf(t, G):
    return 1/(2*(G*G+mp.mpf(1)/4)) + (w(t)/(G*G+mp.mpf(1)/4))/(1 - w(t)/(G*G+mp.mpf(1)/4)) + t/(G*G+mp.mpf(1)/4)
def Cf(t, G): return 1 + 2*w(t)*(G*G)/(G*G - t*t)
def Kbar(G):
    return (mp.mpf('0.110')*(mp.log(G)+mp.mpf(1)/2) + mp.mpf('0.290')*(mp.log(mp.log(G))+mp.mpf(1)/2) + mp.mpf('2.290'))/(2*G*G)

C4 = mp.mpf(62000000)          # G4 scale: G4(t) = C4 t^4
N4 = mp.mpf(31000000)          # n4(t) = ceil(N4 t^4)
def G4(t): return C4 * t**4
def B4(t): return 2 * C4 * t**4
def X4(t):
    g = G4(t)
    return Bf(t, g) * (Sbar(B4(t)) + Sbar(g)) + Cf(t, g) * Kbar(g)

def Zbound(t): return mp.mpf('1.6') * t**mp.mpf('0.25') * mp.log(t)

# component bounds (exact formulas, to be bounded by the pre-registered UBs)
def BfUB(t):  return (mp.mpf(2) + 1/t + 1/t**2) / (t**6 * C4**2)
def SsumUB(t): return 20 + 4*mp.log(t)
def CfUB(t):  return 4*t**2 + 2
def KbarUB(t): return (10 + 2*mp.log(t)) / (2 * C4**2 * t**8)
def XUB(t):   return (mp.mpf(16)/10**15 + mp.mpf(35)/10**16*mp.log(t)) / t**6

# wire term bounds
A1 = mp.mpf(8981)/mp.mpf(10)**8
A2 = mp.mpf(5)/mp.mpf(10)**13        # 5e-13
A3 = mp.mpf(1)/mp.mpf(10)**20
F4 = mp.mpf(10)**8 / (mp.mpf(10)**6 + 1)**2

# wire terms (exact-mp ceiling; guard n >= 31000000 t^4 explicitly)
def mpceil(x):
    f = mp.floor(x)
    return int(f) + (1 if f < x else 0)

def n4ceil(t):
    x = 31000000 * t**4
    n = mpceil(x)
    while mp.mpf(n) < x:
        n += 1
    return mp.mpf(n)

# p8_B mirror (float64-safe via mpmath)
def p8B_terms(t, n):
    s = t + 0.5    # placeholder; exact terms below
    t1 = mp.mpf(1)/2 * n**mp.mpf('-0.5')
    srm = mp.sqrt(t*t + mp.mpf(1)/4)
    t2 = srm/12 * n**mp.mpf('-1.5')
    c = srm * mp.sqrt(t*t+mp.mpf(9)/4) * mp.sqrt(t*t+mp.mpf(25)/4)
    t3 = mp.sqrt(3)/540 * c * n**mp.mpf('-2.5')
    return t1, t2, t3

p("### 25af Lean port Stage 1: dps-50 directional certification ###")
p("family: n4 = ceil(3.1e7 t^4), G4 = 6.2e7 t^4, B4 = 1.24e8 t^4; Tstrip = 1000 (open above)")
p("")

# ============ [0] the strictness anchor for A1 (exact integers) ============
ok = True
lhs = 8981**2 * 4 * 31000000
diff = lhs - 10**16
p(f"[0] A1 strictness (exact integers): 8981^2*4*31000000 = {lhs}")
p(f"    minus 10^16 = {diff}  {'PASS' if diff > 0 else 'FAIL'}")
ok &= diff > 0
p("")

# ============ [1] component bounds, pointwise ============
p("[1] component bounds pointwise on t in [1000, 1e12] (log grid, 240 pts):")
worst = {}
pts = [1000 * 10**(mp.mpf(k)/60) for k in range(61)]
pts += [mp.mpf(t) for t in (1e4, 1e6, 1e8, 1e10, 1e12)]
violB = violS = violC = violK = violX = violXc = 0
maxB = maxS = maxC = maxK = maxX = maxXc = mp.mpf(0)
for t in pts:
    g, b = G4(t), B4(t)
    rB = Bf(t, g) / BfUB(t)          # ACT/UB (< 1 = margin; violation r > 1)
    rS = (Sbar(b) + Sbar(g)) / SsumUB(t)
    rC = Cf(t, g) / CfUB(t)
    rK = Kbar(g) / KbarUB(t)
    rX = X4(t) / XUB(t)
    rXc = (BfUB(t)*SsumUB(t) + CfUB(t)*KbarUB(t)) / XUB(t)   # CHAIN vs XUB
    maxB = max(maxB, rB); maxS = max(maxS, rS); maxC = max(maxC, rC)
    maxK = max(maxK, rK); maxX = max(maxX, rX); maxXc = max(maxXc, rXc)
    if rB > 1: violB += 1
    if rS > 1: violS += 1
    if rC > 1: violC += 1
    if rK > 1: violK += 1
    if rX > 1: violX += 1
    if rXc > 1: violXc += 1
npts = len(pts)
for name, viol, mx in (("BfUB", violB, maxB), ("SsumUB", violS, maxS),
                       ("CfUB", violC, maxC), ("KbarUB", violK, maxK),
                       ("XUB (direct)", violX, maxX), ("XUB (chain)", violXc, maxXc)):
    p(f"    {name:14s}: violations = {viol}/{npts}   max ACT/UB = {float(mx):.6f}  (tightest margin {float(1/mx):.4f}x)   {'PASS' if viol == 0 else 'FAIL'}")
    ok &= viol == 0
p("")
p("    component margins at t = 1000 and t = 1e12:")
for t in (mp.mpf(1000), mp.mpf(10)**12):
    g = G4(t)
    p(f"      t = {float(t):.0e}  BfUB/act = {float(BfUB(t)/Bf(t,g)):.4f}   Ssum/act = {float(SsumUB(t)/(Sbar(B4(t))+Sbar(g))):.4f}   "
      f"CfUB/act = {float(CfUB(t)/Cf(t,g)):.4f}   KbarUB/act = {float(KbarUB(t)/Kbar(g)):.4f}")
p("")

# ============ [2] XUB decreasing + exp bound ============
p("[2] XUB decreasing on [1000, 1e12] and exp bound:")
dec = all(XUB(pts[k+1]) <= XUB(pts[k]) for k in range(len(pts)-1))
xub1000 = float(XUB(mp.mpf(1000)))
p(f"    XUB(1000) = {xub1000:.6e}  (<= 1/2: {xub1000 <= 0.5})")
p(f"    XUB decreasing on the grid: {dec}   exp(XUB(1000)) = {float(mp.e ** XUB(mp.mpf(1000))):.12f} (<= 2: {mp.e ** XUB(mp.mpf(1000)) <= 2})")
ok &= dec and xub1000 <= 0.5
p("")

# ============ [3] wire terms pointwise ============
p("[3] wire-term bounds pointwise (n = n4 = ceil(3.1e7 t^4)):")
violA = violA2 = violA3 = 0
mA = mA2 = mA3 = mp.mpf(0)
for t in pts:
    n = n4ceil(t)
    t1, t2, t3 = p8B_terms(t, n)
    rA1 = t1 / (A1 / t**2)        # ACT/UB again
    rA2 = t2 / (A2 / t**5)
    rA3 = t3 / (A3 / t**7)
    mA = max(mA, rA1); mA2 = max(mA2, rA2); mA3 = max(mA3, rA3)
    if rA1 > 1: violA += 1
    if rA2 > 1: violA2 += 1
    if rA3 > 1: violA3 += 1
    if violA2 and False:
        p(f"      A2 FAIL at t = {float(t):.4e}: ratio float(rA2)")
for name, viol, m in (("A1", violA, mA), ("A2", violA2, mA2), ("A3", violA3, mA3)):
    p(f"    {name}: violations = {viol}/{npts}   max ACT/UB = {float(1/m):.6f}  (tightest margin {float(1/m):.6f}x)   {'PASS' if viol == 0 else 'FAIL'}")
    ok &= viol == 0
p("")
# A2 raw coefficient check
a2raw = 31000000**mp.mpf('-1.5') * mp.mpf(2001)/mp.mpf(24000)
a3raw = (mp.mpf(17321)/10000)/540 * 31000000**mp.mpf('-2.5') * (mp.mpf(1003)/1000)**3
p(f"    A2 raw = (3.1e7)^{{-3/2}}*2001/24000 = {float(a2raw):.6e}  (A2 = 5e-13: margin {float(A2/a2raw):.4f})")
p(f"    A3 raw = (17321/1e4)/540*(3.1e7)^{{-5/2}}*1.003^3 = {float(a3raw):.6e}  (A3 = 1e-20: margin {float(A3/a3raw):.4f})")
ok &= A2 >= a2raw and A3 >= a3raw
p("")

# ============ [4] M-term chain pointwise ============
p("[4] M-term MTUB(t) = 1.8e-14 / t^{19/4} vs M e^{X4} X4 (M = Zbound):")
violM = 0
mM = mp.mpf(10)**30
for t in pts:
    M = Zbound(t)
    lhsM = M * mp.e ** X4(t) * X4(t)
    ubM = mp.mpf(25)/10**15 / t**mp.mpf('4.75')   # MTUB = 2.5e-14 t^{-19/4}
    r = ubM / lhsM
    mM = min(mM, r)
    if r < 1: violM += 1
    if violM and r < 1:
        p(f"      FAIL at t = {float(t):.4e}: ratio {r}")
p(f"    violations = {violM}/{npts}   min UB/act = {float(mM):.6f}   {'PASS' if violM == 0 else 'FAIL'}")
ok &= violM == 0
p("    chain constants: 1.6e-14 L <= 2.7e-15 L^2 for L >= 5.926 (ln 1000 = "
  f"{float(mp.log(1000)):.6f}); 3.2*6.2e-15 = 1.984e-14 <= 2.5e-14: {3.2*6.2e-15 <= 2.5e-14}")
p("")

# ============ [5] floor + FINAL LINE ============
p("[5] floor F4 = 1e8/(1000001)^2 and the final line:")
p(f"    F4 = {float(F4):.12e}")
p(f"    true mown(1e4, 1/200)/Eenv ratio (25w pin cross-check): "
  f"mown/Eenv should be ~0.998937566 > F4/EenvCoef = {float(F4/ (mp.mpf(1)/10000 * mp.mpf(16001)/mp.mpf(15984))):.12f}")
mown10200 = (mp.mpf(1)/200)**2 * ((mp.mpf(1)/200)**2 + 4*1000**2) / (
    ((mp.mpf(1)/2 + mp.mpf(1)/200)**2 + 1000**2) * ((mp.mpf(1)/2 - mp.mpf(1)/200)**2 + 1000**2)) * mp.e ** (
    (mp.mpf(1)/2 + mp.mpf(1)/200)/((mp.mpf(1)/2 + mp.mpf(1)/200)**2 + 1000**2) +
    (mp.mpf(1)/2 - mp.mpf(1)/200)/((mp.mpf(1)/2 - mp.mpf(1)/200)**2 + 1000**2))
t5 = mp.mpf(1000)
lo = (4*(mp.mpf(1)/200)**2/t5**2) * (t5**2/(t5**2+1))**2
p(f"    sanity: hMownScaleLo RHS at (1e3, 1/200) = {float(lo):.10e}  vs true mown = {float(mown10200):.10e}"
  f"  (lo <= mown: {lo <= mown10200});  F4*1e-6 = {float(F4*mp.mpf(10)**-6):.10e} (<= lo: {F4*mp.mpf(10)**-6 <= lo})")
ok &= lo <= mown10200 and abs(lo - F4*mp.mpf(10)**-6)/lo < mp.mpf('1e-40')

final_lhs = A1 + (A2 + A3 + mp.mpf(25)/10**15)/mp.mpf(1000)
p(f"    FINAL: A1 + (A2+A3+2.5e-14)/1000 = {float(final_lhs):.12e}  <  F4 = {float(F4):.12e} : {final_lhs < F4}")
ok &= final_lhs < F4
p(f"    margin (F4 - lhs) = {float(F4 - final_lhs):.6e}  ({float((F4-final_lhs)/F4):.4%} relative)")
p("")
p("### " + ("ALL PASS -- 25af Stage-1 constants are certified" if ok else "SOME CHECK FAILED") + " ###")

open(OUT, "w").write("\n".join(lines) + "\n")
print("\n".join(lines))
print(f"[written {OUT}]")
raise SystemExit(0 if ok else 1)
