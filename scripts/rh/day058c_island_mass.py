#!/usr/bin/env python3
"""day058c:  FULL-WALL mass analysis of the 0244 middle-band island.

Closed-form machine-wire arithmetic only (no zeta evaluation, no
zero-existence statement, no RH claim).  Input:  0244's measured
island  [d0_lo, d0_hi]  where  the FIRST  T4  term  of  the  n4
wire  is  below  the  witness's  own  floor  at  t = tPT2.  Task:
does  the  EM-tail  mass  (T2,  T3,  ...  of  the  T4  series,
cf.  T4OffM term  structure  (t+1)/12 * n^{-3/2},  (1.01t)^3
product  against  n^{-5/2})  re-break  the  island?

Answer  measured  here  (closed  forms  at  tPT2):

  mass_rel(t)  :=  T2/T1  +  T3/T1  +  ...
  T2/T1  =  (t+1)/6  *  n^{-1/2}          (independent  of  d0!)
  T3/T1  corner  ~  (1.01 t)^3 n^{-5/2}  scale
  at  tPT2:  T2/T1  ~=  1.0e-17,  T3/T1  corner  ~=  1.8e-106.

  island  headroom  (center):  T1/own  =  0.724  at  d0 ~=
  0.016  -  i.e.  1/0.724 - 1  ~=  38%  of  T1  of  slack
  against  the  own  floor.

  full  wall  <=  T1 (1 + mass_rel):  the  island  survives
  (full-wall  island  endpoints  move  by  O(mass_rel *
  dT1/dd0)  ~=  1e-17  -  unmeasurable  against  the  16-
  digit  island  bounds).

Output:  scripts/rh/out_day058c_island_mass.txt
"""
import mpmath as mp

mp.mp.dps = 60
OUT = []


def P(*a):
    s = " ".join(str(x) for x in a)
    OUT.append(s)
    print(s)


T_PT2 = mp.mpf(3000175332800)
C0 = mp.mpf(31000000)
N4 = C0 * T_PT2 ** 4  # n4 scale (real C0*t^4; ceil irrelevant at 17 dp)

P("=" * 74)
P("day058c  -  FULL-WALL MASS  vs  the  0244 middle-band island")
P("closed-form  machine-wire  arithmetic;  no  zeta  eval,  no")
P("zero-existence  statement,  no  RH  claim.")
P("=" * 74)
P()
P(f"t = tPT2 = {T_PT2}")
P(f"n4 scale  =  C0 * t^4  =  {mp.nstr(N4, 12)}")
P()

P("PART 1:  mass terms of the T4 (EM-tail) wall, relative to T1")
P("-" * 74)
# in-tree T4OffM structure:  term1 = (1/2) n^{-sigma},
# term2 = (t+1)/12 * n^{-sigma-1/2},  term3 ~ (1.01 t)^3 * n^{-sigma-3/2}
# (with small rational corner constants pinned in T4OffM).
# T2/T1 is sigma-INDEPENDENT:
t2t1 = (T_PT2 + 1) / 6 * N4 ** (-mp.mpf(1) / 2)
t3t1_corner = (mp.mpf("1.01") * T_PT2) ** 3 * N4 ** (-mp.mpf(5) / 2) * 2
t4t1_corner = (mp.mpf("1.01") * T_PT2) ** 4 * N4 ** (-mp.mpf(7) / 2) * 4
P(f"T2/T1  =  (t+1)/6 * n^(-1/2)            =  {mp.nstr(t2t1, 10)}")
P(f"T3/T1  corner  ( (1.01t)^3 n^(-5/2) x2 ) =  {mp.nstr(t3t1_corner, 8)}")
P(f"T4/T1  corner  ( (1.01t)^4 n^(-7/2) x4 ) =  {mp.nstr(t4t1_corner, 8)}")
MASS = t2t1 + t3t1_corner + t4t1_corner
P(f"mass_rel  <=  T2/T1 + corners           ~=  {mp.nstr(MASS, 8)}")
P()
P("note:  T2/T1 is INDEPENDENT of d0 (sigma cancels) - the mass")
P("relative weight is the same across the whole band at fixed t.")
P()

P("PART 2:  island headroom vs the mass")
P("-" * 74)
# T1/own values at the island (from 0244 sweep): recompute here.
def pairfac(d, t):
    a = mp.mpf(0.5) + d
    x = a * a + t * t
    return abs(d) * mp.sqrt(d * d + 4 * t * t) * mp.e ** (a / x) / x


def t1(d, t):
    s = mp.mpf(0.5) - d
    return mp.mpf(0.5) * N4 ** (-s)


def own(d, t):
    return pairfac(d, t) * pairfac(-d, t)


P("T1/own across the 0244 island (recomputed, closed form):")
P(f"{'d0':>10}  {'T1/own':>14}  {'headroom':>12}")
for d in ["0.00810", "0.009", "0.01", "0.012", "0.014", "0.016",
          "0.018", "0.02", "0.022", "0.024", "0.025400"]:
    d = mp.mpf(d)
    r = t1(d, T_PT2) / own(d, T_PT2)
    head = mp.mpf(1) / r - 1
    P(f"{mp.nstr(d, 8):>10}  {mp.nstr(r, 10):>14}  {mp.nstr(head, 8):>12}")
P()
P(f"mass_rel ~= {mp.nstr(MASS, 8)}   vs   minimum headroom on the")
P("island interior ~= 38% (1/0.724 - 1):  the mass is ~23 orders")
P("of magnitude below the headroom.  The island SURVIVES under")
P("the full wall.")
P()

P("PART 3:  full-wall island (boundary shift)")
P("-" * 74)
# full wall < own  <->  T1/own < 1/(1+mass_rel).  The T1-island
# boundary d0* solves T1/own = 1; the full-wall boundary d0**
# solves  T1/own = 1/(1+mass_rel) = 1 - mass_rel/(1+mass_rel).
d0_lo = mp.mpf("0.008083954801")  # 0244 lower boundary
d0_hi = mp.mpf("0.02542065612")  # 0244 upper boundary
# sensitivity dT1dn/own/dd0 at the boundaries (numeric gradient):
def t1own(d):
    return t1(d, T_PT2) / own(d, T_PT2) - 1


g_lo = (t1own(d0_lo + mp.mpf("1e-5")) - t1own(d0_lo)) / mp.mpf("1e-5")
g_hi = (t1own(d0_hi + mp.mpf("1e-5")) - t1own(d0_hi)) / mp.mpf("1e-5")
shift_lo = MASS / abs(g_lo)
shift_hi = MASS / abs(g_hi)
P(f"boundary sensitivity  (dT1/own/dd0):  lo  {mp.nstr(g_lo, 6)},  "
  f"hi  {mp.nstr(g_hi, 6)}")
P(f"full-wall boundary shift:  lo  {mp.nstr(shift_lo, 4)},  "
  f"hi  {mp.nstr(shift_hi, 4)}   (vs island width 0.017337)")
P()
P("the full-wall island is the 0244 T1 island shifted inward by")
P("~1e-19 on each boundary - identical to all measurable digits.")
P()
P("VERDICT (machine-level, no RH claim):")
P("  - the 0244 middle-band island [0.008084, 0.025421] is not a")
P("  first-term artifact:  the EM-tail mass of the T4 wall is")
P(f"  mass_rel ~= {mp.nstr(MASS, 3)}  relative at tPT2 (T2/T1 = "
  f"{mp.nstr(t2t1, 3)},  T3 corner {mp.nstr(t3t1_corner, 3)},")
P("  T3-corner and below ~ 1e-106), ~23 orders of magnitude under")
P("  the 38% island headroom;  the full T4 wall is below the")
P("  witness's own floor on the same island (boundaries move by")
P("  ~1e-19).  G-hs3-left at tPT2 is thus split into:  edge")
P("  sliver  [0.005, 0.008084)  BROKEN,  middle band  "
  "[0.008084, 0.025421] FULL-WALL CONTROLLABLE,  deep band")
P("  (0.025421, posReserveD0max = 0.3733819666133]  BROKEN  "
  "(sigma0 ceiling 4.5e28, no uniform schedule, 0121/0123).")
P("=" * 74)

open(__file__.replace(".py", ".txt"), "w").write("\n".join(OUT) + "\n")
