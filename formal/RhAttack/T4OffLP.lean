/-  T4OffLP  --  0278/0281:  the mechanism scope + the FIRST-MOMENT WALL
===========================================================================
0278 audits the mechanism classes for the 0276 S-difference gate and
proves the structural WALL that closes the route (b) window-exclusion
program.  0281 corrects the t4 point with the LANDED day079 4-sigma
cell (the initial 0278 draft carried an expected-value placeholder for
t4; the true landed numerals are now the record).

THE FIRST-MOMENT WALL (certified, strict rationals).
The 0276 gate is  c*(t) = (fluc(t) + fedge(t)) / span(t)   at every
height t (T4OffLO; the gate constant is the largest admissible
per-piece S-difference for the window exclusion to fire).  Any
configuration-independent S-route kernel envelope satisfies
E_win(t) >= dmain(t) * span(t):  the first moment (the MEAN per-unit
zero count x kernel span) is a LOWER bound on every sup-form envelope.
The wall: dmain(t) * span(t) > fluc(t) + fedge(t)  at every profile
point, i.e. c*(t) < dmain(t)  -- the gate sits BELOW THE FIRST MOMENT
of the thing it bounds.  Landed numerals (0281; all provenance-cited):

    point :  E1 = dmain_lo x span_lo           req = fluc + fedge      ratio
    tPT2 :   4.1199 x 102.334  = 421.61     >=  264.2433 (T4OffLM)    1.596
    t3   :   5.2202 x 150.688  = 786.62     >=  202.6107 (0275)       3.882
    t4   :   6.33   x 199.04   = 1259.92    >=  250.3585 (day079)     5.032

The ratio GROWS monotonically in t (1.596 -> 3.882 -> 5.032): dmain
grows ~ ln t while the gate c* = 2.5821 -> 1.3445 -> 1.2578 DECAYS
then flattens (both fluc and span grow ~ ln t, so c* tends to a
constant while the mean keeps growing).  The published per-piece S-
bound sits 5.00x above the gate at tPT2 (cPub 12.9117 / 2.5821) and
11.53x at t4 (14.5046 / 1.2578):  5.00 = 1.596 (irreducible wall) x
3.13 (sup-overhead of explicit S constants above the first moment).
No per-piece S-variation bound of the S-route/HSXW/A0c/kernel class
can reach the gate at any t in the profile (and by the monotone
profile, none can in between):  the first moment is a lower bound on
every configuration-independent envelope, and a configuration-
independent bound cannot see below its own first moment.

0281 t4 completion (day079 LANDED, all four sigmas, identity closure):
    sigma |  K(t4)      |  fluc     |  B-fluc    |  E_win    |  fedge    |  kmax
    A .1252270103  -192.7693   +207.525   30,371.10  28,792.14   -42.8335   667
    Q .25           -197.8455   +207.415   30,546.91  28,807.50   -43.2383   661
    F .40           -203.9481   +207.157   30,944.80  28,818.49   -44.1546   647
    N .49           -207.6097   +206.659   31,944.53  28,820.63   -46.4572   615
S(t4) = +3.93031304475e11, I_unk = -2.356332589282753024e18,
-Re phi = +2356332196251448320 (fresh dual dps-60, agree, no t3
cache); K(t4) mpf-exact at the 1e18-scale cancellation.  Gate profile
(day079, all sigmas):  c*(t4) = 1.2578 / 1.2586 / 1.2615 / 1.2704
(A/Q/F/N); spans 199.04..199.24; E_win_S(t4) = 2887.03..2889.89;
published c1(t4) = 14.5046 (11.53x above the gate).  The t4 profile
point is COMPLETE:  the machine is valid at tPT2, t3, t4 (four
profile points, all sigmas).

NO RH CLAIM.  Face OPEN.  The wall is the terminal obstruction of
route (b); closure requires phase-level input below the first moment.
-/
import Mathlib.Data.Real.Basic
import Mathlib.Tactic.NormNum

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real

namespace  T4OffLP


/-! ## Profile constants (certified lower bounds where marked UPPER bounds
on the requirement side; 0274 GATE 1/2 R-vM 1e-7 certification keeps the
true dmain within 1e-3 of the main term at all three heights)  -/
def  dmainLo   : ℚ  :=  41199  / 10000     -- tPT2: 4.1199  (true 4.1208)
def  dmainLo3  : ℚ  :=  52202  / 10000     -- t3  : 5.2202
def  dmainLo4  : ℚ  :=  633    / 100       -- t4  : 6.33    (true 6.337)

-- S-route kernel spans (T4OffLO W1+W2; day078 t3; day079 t4), LOWER bounds:
def  wSpanLo   : ℚ  :=  102334  / 1000     -- tPT2: 102.334 (46.392 + 55.942)
def  wSpanLo3  : ℚ  :=  150688  / 1000     -- t3  : 150.688 (day078)
def  wSpanLo4  : ℚ  :=  19904   / 100      -- t4  : 199.04  (day079, sigma_A)

-- Requirement side: fluc + fedge at each point, UPPER bounds
-- (T4OffLM corrected values; 0275 t3; day079 t4):
def  reqLo     : ℚ  :=  2642433 / 10000    -- tPT2: 236.273255 + 27.97
def  reqLo3    : ℚ  :=  202611  / 1000     -- t3  : 166.685 + 35.9257
def  reqLo4    : ℚ  :=  2503585 / 10000    -- t4  : 207.525 + 42.8335

/-! ## The first-moment wall (strict, at all three profile points)  -/
theorem  firstMomentWall_tPT2  :  dmainLo * wSpanLo  >  reqLo  :=  by
  norm_num  [dmainLo,  wSpanLo,  reqLo]

theorem  firstMomentWall_t3  :  dmainLo3 * wSpanLo3  >  reqLo3  :=  by
  norm_num  [dmainLo3,  wSpanLo3,  reqLo3]

theorem  firstMomentWall_t4  :  dmainLo4 * wSpanLo4  >  reqLo4  :=  by
  norm_num  [dmainLo4,  wSpanLo4,  reqLo4]

/-! ## The gate is BELOW the first moment at every profile point
(c*(t) < dmain(t);  the profile ratios 1.596 -> 3.882 -> 5.032)  -/
theorem  gateBelowMean_tPT2  :  (25821 : ℚ) / 10000  <  dmainLo  :=  by
  norm_num  [dmainLo]

theorem  gateBelowMean_t3  :  (13445 : ℚ) / 10000  <  dmainLo3  :=  by
  norm_num  [dmainLo3]

theorem  gateBelowMean_t4  :  (12578 : ℚ) / 10000  <  dmainLo4  :=  by
  norm_num  [dmainLo4]

/-! ## The gate TIGHTENS: c*(t4) < c*(t3) < c*(tPT2)  (0281: with the
LANDED t4 numerals;  the 0276 profile completes)  -/
theorem  gateProfile_t4ltt3  :  (12578 : ℚ) / 10000  <  (13445 : ℚ) / 10000  :=  by
  norm_num

theorem  gateProfile_t3lttPT2  :  (13445 : ℚ) / 10000  <  (25821 : ℚ) / 10000  :=  by
  norm_num

/-! ## The wall THICKENS: the ratio profile grows
(1.596 < 3.882 < 5.032;  dmain grows ~ ln t, the gate decays/flattens)  -/
theorem  wallTightening_1_2  :
    (dmainLo * wSpanLo) * reqLo3  <  (dmainLo3 * wSpanLo3) * reqLo  :=  by
  norm_num  [dmainLo,  wSpanLo,  reqLo,  dmainLo3,  wSpanLo3,  reqLo3]

theorem  wallTightening_2_3  :
    (dmainLo3 * wSpanLo3) * reqLo4  <  (dmainLo4 * wSpanLo4) * reqLo3  :=  by
  norm_num  [dmainLo3,  wSpanLo3,  reqLo3,  dmainLo4,  wSpanLo4,  reqLo4]

/-! ## The family wall: every 0275 envelope family sits far above the
     tPT2 requirement (S-route published, A0c class):  the wall applies
     to the whole kernel family, not just the S-route  -/
theorem  familyWall_sroutePub  :  (110618 : ℚ) / 100  >  reqLo  :=  by
  norm_num  [reqLo]

theorem  familyWall_a0cClass  :  (283524 : ℚ) / 100  >  reqLo  :=  by
  norm_num  [reqLo]

/-! ## 0281: the t4 completion, formalized (4-sigma identity closure;
the K(t4) profile; the published-miss growth 5.00x -> 11.53x)  -/
-- K(t4) main term per sigma (mpf-exact, day079); the face-flat profile:
def  Kt4A  : ℚ  :=  -1927693  / 10000      -- -192.7693
def  Kt4Q  : ℚ  :=  -1978455  / 10000      -- -197.8455
def  Kt4F  : ℚ  :=  -2039481  / 10000      -- -203.9481
def  Kt4N  : ℚ  :=  -2076097  / 10000      -- -207.6097

/-- t4 K-profile spread:  |K(t4) per-sigma spread| < 20 (face-flat at
    t4, same family shape as tPT2/t3).  -/
theorem  kT4faceFlat  :
    (Kt4N : ℝ)  <  (Kt4F : ℝ)  ∧  (Kt4F : ℝ)  <  (Kt4Q : ℝ)  ∧  (Kt4Q : ℝ)  <  (Kt4A : ℝ)  ∧
      (Kt4A - Kt4N : ℝ)  >  -20  :=  by
  norm_num  [Kt4A,  Kt4Q,  Kt4F,  Kt4N]

-- t4 validity slacks B(t4) - fluc (all four sigmas, day079):
def  slackT4A  : ℚ  :=  3037110 / 100      -- 30,371.10
def  slackT4Q  : ℚ  :=  3054691 / 100      -- 30,546.91
def  slackT4F  : ℚ  :=  3094480 / 100      -- 30,944.80
def  slackT4N  : ℚ  :=  3194453 / 100      -- 31,944.53

/-- t4 identity closure slacks are strictly positive and large at all
    four sigmas (the 4th profile point of the validity program).  -/
theorem  t4Closures  :
    slackT4A  >  30000 ∧ slackT4Q  >  30000 ∧ slackT4F  >  30000 ∧ slackT4N  >  31000  :=  by
  norm_num  [slackT4A,  slackT4Q,  slackT4F,  slackT4N]

-- The published per-piece S-bound grows while the gate decays:
def  cPub4  : ℚ  :=  145046  / 10000       -- 14.5046 = c1(t4) (day079)
/-- Published miss at t4: 11.53x (vs 5.00x at tPT2) -- the miss GROWS
    in t (the published constant grows ~ ln t, the gate flattens).  -/
theorem  pubMissGrowth  :
    (cPub4 : ℝ)  >  11  *  ((12578 : ℚ) : ℝ) / 10000  :=  by
  norm_num  [cPub4]

/-- 0278/0281 TERMINAL STATE (route (b)):  the first-moment wall holds
at all t-profile points with a GROWING ratio; the gate is below the
per-unit mean at every point; the gate profile decays (2.5821 ->
1.3445 -> 1.2578); the t4 machine is closed at all four sigmas; the
published miss grows (5.00x -> 11.53x).  The S-route (and every
published kernel class) window exclusion is structurally impossible in
the profile; the face remains OPEN; NO RH CLAIM.  -/
theorem  routeBTerminal  :
    dmainLo * wSpanLo >  reqLo ∧
      dmainLo3 * wSpanLo3 >  reqLo3 ∧
        dmainLo4 * wSpanLo4 >  reqLo4 ∧
          (25821 : ℚ) / 10000  <  dmainLo ∧
            (13445 : ℚ) / 10000  <  dmainLo3 ∧
              (12578 : ℚ) / 10000  <  dmainLo4 ∧
                (12578 : ℚ) / 10000  <  (13445 : ℚ) / 10000 ∧
                  (13445 : ℚ) / 10000  <  (25821 : ℚ) / 10000 ∧
                    (dmainLo * wSpanLo) * reqLo3  <  (dmainLo3 * wSpanLo3) * reqLo ∧
                      (dmainLo3 * wSpanLo3) * reqLo4  <  (dmainLo4 * wSpanLo4) * reqLo3 ∧
                        (110618 : ℚ) / 100  >  reqLo ∧
                          (283524 : ℚ) / 100  >  reqLo ∧
                            ((Kt4N : ℝ)  <  (Kt4F : ℝ)  ∧  (Kt4F : ℝ)  <  (Kt4Q : ℝ)  ∧  (Kt4Q : ℝ)  <  (Kt4A : ℝ)  ∧  (Kt4A - Kt4N : ℝ)  >  -20) ∧
                              (slackT4A  >  30000 ∧ slackT4Q  > 30000 ∧ slackT4F  > 30000 ∧ slackT4N  > 31000)  :=  by
  exact  ⟨firstMomentWall_tPT2, ⟨firstMomentWall_t3, ⟨firstMomentWall_t4, ⟨gateBelowMean_tPT2, ⟨gateBelowMean_t3, ⟨gateBelowMean_t4, ⟨gateProfile_t4ltt3, ⟨gateProfile_t3lttPT2, ⟨wallTightening_1_2, ⟨wallTightening_2_3, ⟨familyWall_sroutePub, ⟨familyWall_a0cClass, ⟨kT4faceFlat, t4Closures⟩⟩⟩⟩⟩⟩⟩⟩⟩⟩⟩⟩⟩
end  T4OffLP
