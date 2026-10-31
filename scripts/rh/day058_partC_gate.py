#!/usr/bin/env python3
# day058_partC_gate.py (REV2)
#
# PART C GATE SWEEP (day058) - the window zero-exclusion gap at face height.
#
# REV2 CORRECTION: the window floor S1LowT.floStripMin(t, d) =
#   min(‖B5.pown(t, d, t)‖, max(floWin(t), 0))
# evaluates the canonical 4-factor product at s = sLine(t) = 1/2 + i t
# (B4.sLine carries the halfR offset!) - not at s = i t as REV1 assumed.
# With s = 1/2 + i t the exp factors no longer cancel pairwise: an
# e^{+a/(a^2+t^2) + b/(b^2+t^2)} factor (a = 1/2+d, b = 1/2-d) survives,
# and one factor per flank carries the OFFSET distance (c - 1/2) - so the
# window floor scales like
#     floor(t, d) = d^2 (d^2 + 4 t^2) e^{C(t,d)} / ((a^2+t^2)(b^2+t^2))
#                ~ 4 d^2 e^{1/t^2} / t^2          (t -> inf)
# i.e. it VANISHES as d -> 0 (the detector degenerates on the line) - the
# "unified floor" is continuous with the band floor mown ~ 4 d^2/t^2 across
# d = 1/200, exactly as the FloorUnif architecture requires.  Consequences
# (REV1's conclusions are superseded; REV1 is kept in the git history):
#   * NO non-d-dependent wire can close the S4 window leg uniformly in
#     0 < d < 1/200 at face height - the floor -> 0 beats every fixed wire.
#     The near-line window slice (0, d*(t)) is bound-level OPEN by structure
#     (a data/pointwise territory, like the E1 clauses).
#   * The machine's n4 schedule (S4Strip.n4) DOES close the window S4 leg on
#     a d-substrip:  floor ~ 4 d^2 e^{1/t^2}/t^2  vs  wire ~ A1 t^-2
#     (A1 = 8981/10^8, 25af) - crossing at d*(t) ~= sqrt(A1/4) ~= 4.738e-3,
#     so the gate holds for d in (4.738e-3, 1/200] with pin-level margin
#     (the theorem 0243 states d >= 1/211 ~= 4.7393e-3, margin ~0.03-11%).
#   * The in-tree window wire (25ab nGrow = floor(t^2), ~ 1/2 t^-1) misses
#     the floor by ~ t/(8 d^2) (at tPT2, d = 1/200: ~1.5e16) - diverging.
#
# CONTEXT: the B22 terminal face is the single residual
#     hOffCPT2 : forall t0 >= tPT2, 0 < d0 <= posReserveD0max, ~ offPair q t0 d0
# (RHEnd.rh_program78_stripfront_mach_unifiedPosReserve_PT2; tPT2 =
# 3,000,175,332,800; posReserveD0max = 0.3733819666133, the EIGHTH record
# covers d0 > dmax).  The window slice (0, 1/200) of that face is the
# "Part C gate" of the RHEnd docstring (in-tree window wire pinned below the
# NEAR PIN 0.9975, unified S2 floor floStripMin; the gap is the hWin
# bound-level residue).
#
# METHODOLOGY: closed forms only (B5.fac, B3Core via the p11 mirror,
# P8Floor.p8_B, S4Strip/S4Growth), 60 dps; no zeta evaluation, no zero
# existence, no RH claim.
import sys

import mpmath as mp

sys.path.insert(0, "scripts/rh")
import day023_p11c_1e7 as p11   # B3Core EXACT mirror (Bf/Sbar/Cf/Kbar)
mp.mp.dps = 60                  # p11's import forces dps=25 - restore
mp.mpf.nstr = lambda self, n=17: mp.nstr(self, n)   # mpmath 1.4 compat

TPT2 = mp.mpf("3000175332800")            # WinC.tPT2
G_LAST = mp.mpf("30001045999.981975555")  # E1Clause.G_LAST
T_MEAS = 1000 * G_LAST                    # E1Clause.T_MEAS ~= 3.0001e13
A1 = mp.mpf("8981") / 10 ** 8             # S4Strip.A1 (25af wire pin)
C4 = mp.mpf("31000000")                   # n4 prefactor (S4Strip.n4)


# ---------------------------------------------------------------- floor
def pown_ex(t, d):
    # |pown(t,d,t)| at s = sLine(t) = 1/2 + i t, zeros (1/2 +/- d) +/- i t.
    # Pair at c +- i t:  |1 - s/(c+it)| = |c-1/2|/sqrt(c^2+t^2),
    #                    |1 - s/(c-it)| = sqrt((c-1/2)^2 + 4 t^2)/sqrt(c^2+t^2),
    #                    Re(s/(c+it)) + Re(s/(c-it)) = c/(c^2+t^2).
    a = mp.mpf("0.5") + d
    b = mp.mpf("0.5") - d
    C = a / (a * a + t * t) + b / (b * b + t * t)
    return d * d * (d * d + 4 * t * t) * mp.exp(C) / ((a * a + t * t) * (b * b + t * t))


def pown_complex(t, d):
    # direct complex check of pown_ex (B4.sLine, B5.fac).
    s = mp.mpc(mp.mpf("0.5"), mp.mpf(t))     # sLine t = 1/2 + i t
    prod = mp.mpc(1)
    for c, e in ((mp.mpf("0.5") + d, +1), (mp.mpf("0.5") + d, -1),
                 (mp.mpf("0.5") - d, +1), (mp.mpf("0.5") - d, -1)):
        rho = mp.mpc(c, e * mp.mpf(t))
        prod *= (1 - s / rho) * mp.exp(s / rho)
    return abs(prod)


def floWin(t):
    return min(mp.mpf("23") / 1000, 1 - mp.mpf(25) / t)


def floStripMin(t, d):
    return min(pown_ex(t, d), floWin(t))


# ---------------------------------------------------------------- wires
def p8_B(t, n):
    nr = mp.mpf(n)
    s = abs(mp.mpc(mp.mpf("0.5"), t))
    term1 = mp.mpf("0.5") * nr ** (-mp.mpf("0.5"))
    term2 = (s / 12) * nr ** (-mp.mpf("1.5"))
    prod3 = abs(mp.mpc(mp.mpf("0.5"), t) * (mp.mpc(mp.mpf("0.5"), t) + 1) *
                (mp.mpc(mp.mpf("0.5"), t) + 2))
    term3 = (mp.sqrt(3) / 540) * prod3 * nr ** (-mp.mpf("2.5"))
    return term1 + term2 + term3, term1, term2, term3


def Zbound(t):
    return mp.mpf("1.6") * t ** mp.mpf("0.25") * mp.log(t)


def Xband(t, G):
    return p11.Bf(t, G) * (p11.Sbar(2 * G) + p11.Sbar(G)) + p11.Cf(t, G) * p11.Kbar(G)


def wire_grow(t):
    # in-tree window wire above T0 = 110000 (S4Growth): n = floor(t^2).
    n = mp.floor(t * t)
    t1, t2, t3 = p8_B(t, n)[1:]
    X = Xband(t, t * t)
    M = Zbound(t) * mp.exp(X) * X
    return t1 + t2 + t3 + M


def wire_n4(t):
    # machine band schedule n = ceil(3.1e7 t^4), X at the (G4, B4] band.
    n = mp.ceil(C4 * t**4)
    t1, t2, t3 = p8_B(t, n)[1:]
    X = Xband(t, 2 * C4 * t**4)
    M = Zbound(t) * mp.exp(X) * X
    return t1 + t2 + t3 + M


out = []
p = out.append
p("PART C GATE SWEEP (day058 REV2, closed forms, 60 dps)")
p(f"  tPT2 = {TPT2}   T_MEAS = {T_MEAS.nstr(12)}   window = (0, 1/200)")
p(f"  A1 (S4Strip, 25af) = {A1.nstr(10)}")
p("")

# (0) floor factorization vs the direct complex B5 product -------------
p("(0) FLOOR VALIDATION (s = sLine t = 1/2 + i t):  pown_ex vs complex product")
for t, d in ((TPT2, mp.mpf("0.001")), (TPT2, 1 / mp.mpf(211)), (TPT2, 1 / mp.mpf(200)),
             (T_MEAS, mp.mpf("0.004")), (mp.mpf("1e18"), mp.mpf("0.003"))):
    a, b = pown_ex(t, d), pown_complex(t, d)
    p(f"    t={t.nstr(9)} d={d.nstr(9):>11}  ex={a.nstr(10)}  cx={b.nstr(10)}  rel={((a-b)/b).nstr(4)}")
p("")

# (1) floor shape over the window at face height -------------------------
p("(1) WINDOW FLOOR floor(t,d) ~ 4 d^2 e^{1/t^2} / t^2  at t = tPT2:")
p("      d           floor(tPT2,d)    4 d^2 e^{1/t^2} / t^2 (asymptote)")
for d in (mp.mpf(1e-5), mp.mpf("0.001"), 1 / mp.mpf(211), mp.mpf("0.004"), 1 / mp.mpf(200)):
    f = pown_ex(TPT2, d)
    asym = 4 * d * d * mp.e ** (1 / TPT2 ** 2) / TPT2 ** 2
    p(f"    {d.nstr(8):>11}   {f.nstr(10):>14}   {asym.nstr(10):>14}")
p("    -> the floor VANISHES as d -> 0 (detector degenerates on the line);")
p("       no non-d-dependent wire can close the window S4 leg uniformly in d.")
p("")

# (2) n4 wire vs floor over the window: crossing d*(t) -------------------
p("(2) n4 WIRE (S4Strip.n4, X at the (G4,B4] band) vs WINDOW FLOOR, t = tPT2:")
w = wire_n4(TPT2)
p(f"    WIRE_n4(tPT2) = {w.nstr(12)}   (term1 = (1/2)(3.1e7 t^4)^(-1/2) ~ {A1.nstr(8)} t^(-2)-class)")
p("      d           floor(tPT2,d)   floor/WIRE   gate?")
for d in (mp.mpf("0.0045"), 1 / mp.mpf(211), mp.mpf("0.0049"), 1 / mp.mpf(200)):
    f = pown_ex(TPT2, d)
    p(f"    {d.nstr(8):>11}   {f.nstr(12):>14}   {(f/w).nstr(8):>12}   {'CLEAR' if f > w else 'FAIL'}")
dstar = mp.sqrt(A1 / 4)
p(f"    crossing d*(tPT2) ~= sqrt(A1/4) = {dstar.nstr(10)}  "
  f"(1/211 = {(1/mp.mpf(211)).nstr(10)} is {((1/mp.mpf(211))/dstar - 1).nstr(6)} above it)")
p("")
p("    T-independence of the gate (both sides ~ t^-2):  margin floor/WIRE at d = 1/200:")
for e in ("3.0001753328e12", "1e13", "3.0001e13", "1e14", "1e16", "1e20"):
    t = mp.mpf(e)
    ww = wire_n4(t)
    ff = pown_ex(t, 1 / mp.mpf(200))
    p(f"      t={t.nstr(10)}  floor/WIRE = {(ff/ww).nstr(9)}")
p("")

# (3) the in-tree window wire (nGrow) vs the floor -----------------------
p("(3) IN-TREE WINDOW WIRE (25ab nGrow = floor(t^2)) vs the WINDOW FLOOR: gap = WIRE/floor")
p("      t          WIRE_grow        floor(d=1/200)    gap          t/(8 d^2) asymptote")
for e in ("3e12", "1e13", "3.0001e13", "1e14", "1e16", "1e20"):
    t = mp.mpf(e)
    wg = wire_grow(t)
    f = pown_ex(t, 1 / mp.mpf(200))
    p(f"    {t.nstr(9):>12}  {wg.nstr(10):>14}  {f.nstr(10):>14}  {(wg/f).nstr(10):>13}   { (t/8/(1/mp.mpf(200))**2).nstr(10):>15}")
p("    -> the current in-tree window closure misses the unified floor by ~ t/(8 d^2)")
p("       (at tPT2, d = 1/200: ~1.5e16), DIVERGING in t.")
p("")
p("HONESTY:  machine-wire/bound-level arithmetic on the closed forms of")
p("B5 (fac, sLine = 1/2 + it), B3Core, P8Floor, S4Strip/S4Growth, S1LowT.")
p("No zeta evaluation, no zero existence, no RH claim.")

txt = "\n".join(out)
open("scripts/rh/out_day058_partC_gate.txt", "w").write(txt + "\n")
print(txt)
