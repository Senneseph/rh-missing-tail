import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3
import RhAttack.CE4
import RhAttack.CE5
import RhAttack.CE6
import RhAttack.CE7
import RhAttack.CE8
import RhAttack.CE9
import RhAttack.CE10
import RhAttack.CE11
import RhAttack.CE12
import RhAttack.CE13
import RhAttack.CE14
import RhAttack.CE15
import RhAttack.CE16
import RhAttack.CE17
import RhAttack.CE18
import RhAttack.CE19
import RhAttack.CE20
import RhAttack.CE21
import RhAttack.CE22
import RhAttack.CE23
import RhAttack.CE24
import RhAttack.CE25
import RhAttack.CE26
import RhAttack.CE27
import RhAttack.CE28
import RhAttack.CE29
import RhAttack.CE30
import RhAttack.CE31
import RhAttack.CE32
import RhAttack.CE33
import RhAttack.CE34
import RhAttack.CE35
import RhAttack.CE36
import RhAttack.CE37
import RhAttack.CE38
import RhAttack.CE39
import RhAttack.CE40
import RhAttack.CE41
import RhAttack.CE42
import RhAttack.CE42B
import RhAttack.CE43
import RhAttack.CE44
import RhAttack.CE45
import RhAttack.CE46
import RhAttack.CE47
import RhAttack.CE48
import RhAttack.CE49
import RhAttack.CE50
import RhAttack.CE51
import RhAttack.CE52
import RhAttack.CE53
import RhAttack.CE54
import RhAttack.CE55
import RhAttack.CE56
import RhAttack.CE57
import RhAttack.CE58
import RhAttack.CE59
import RhAttack.CE60
import RhAttack.CE61
import RhAttack.CE62
import RhAttack.CE63
import RhAttack.CE64
import RhAttack.CE65
import RhAttack.CE66
import RhAttack.CE67
import RhAttack.CE68
import RhAttack.CE69
import RhAttack.CE70
import RhAttack.CE71
import RhAttack.CE72
import RhAttack.CE73
import RhAttack.CE74
import RhAttack.CE75
import RhAttack.CE76
import RhAttack.CE77
import RhAttack.CE78
import RhAttack.CE79

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79
open scoped Topology

/-!
**CE80 — the terminal face re-anchored at the EIGHTIETH certified window
(0389, option B, unit 103 - lane M5). THE DOUBLE CONVERGENCE WINDOW.

MILESTONE STATE: tCE80 - tPT2 = 378 502 - **THE 375 000 UNIT MILESTONE
CROSSES IN WINDOW 80, margin 3 502** (predicted at 0388 as "the required
increment is 1 172; expect margin ~3 500" - ACHIEVED: the actual increment
4 673 gave margin 3 502; the predicted frontier 378 502 [upper branch,
non-snapped +4 673] ACHIEVED exactly). The 350 000-unit mark (crossed in
WINDOW 74 at 350 465, margin 465 [0380] - the first prediction of the
series, delivered exactly) CARRIES with margin 28 502; the 325 000 and
300 000 marks carry with margins 53 502 and 78 502. The 375 000 mark
joins the proven round-mark sequence: 100 000 @ CE22, 125 000 @ CE27, 150
000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @
CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74,
375 000 @ CE80 (ALL CROSSEDS PROVEN IN TREE - this module adds the new
frontierPast375k theorem). The next round mark 400 000 sits 21 498 ahead
(~4.6 windows at the ~4 673 window pace - predicted around window 85,
compute from the decoded endpoint, do not pre-announce).

**THE 1 600 000 CERTIFIED-ZERO CENSUS MARK CROSSES IN WINDOW 80, margin
19 985** (cumulative total 1 619 985 over (g_a1, g_b80] - the 0388
prediction "any W80 width adds >= 19 999: 1 619 984 > 1 600 000, margin
~19 984..19 985" ACHIEVED at its upper branch: W80 non-snapped, +20 000
exactly). THE DOUBLE CONVERGENCE PREDICTED AT CE78/CE79 (375 000 unit +
1 600 000 census at window 80) IS ACHIEVED - both marks crossed in the
same window, at the exact predicted margins. (Census milestones are
documents, not frontierPast theorems - the W75 precedent for the 1 500
000 crossing; the 1 500 000 mark carries margin 119 985, the 1 700 000
mark is 80 015 ahead - ~17.1 windows, around window 97.)

WINDOW 80: NON-SNAPPED (width 20 000) AND CLEAN - ZERO interior Rosser
failures (the first clean window since W74; the Rosser-failure tally
STAYS at 65 over 80 windows). RESCUE-free: the end Rosser runs are 52
LEFT of g_a80 and 49 RIGHT of g_b79... of g_b80 (both >> K = 12); 0
cross-check failures (all 33 213 records); 0 undetermined Gram signs.
INCREMENT: 4 673 (the usual step; the increment series w77 -> w78 -> w79
-> w80 now reads 4 673, 4 672 [SNAP], 4 673, 4 673). The 4 672
occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66,
w77 -> w78 [SNAP]); no pattern claim.

PIPELINE RUN (fourteenth in the overlap pipeline): seed cache (window
79's cache copied in before launch - resumed_from_cache = 470 819, logged
for provenance) + 32 workers: 33 213 evaluations in 2 510.8 s (series:
2 497.2 / 2 498.3 / 2 498.5 / 2 490.4 / 2 483.4 / 2 375.0 / 2 459.6 / 2
490.2 / 2 387.5 / 2 437.1 / 2 478.0 / 2 408.7 / 2 493.2 / 2 510.8 - the
count moved, the certification content did not: same M = 60, C_R = 1,
N_range = [691 008, 691 008], same pipeline, same verifier, same seam
discipline). Window 80 RAN WHILE CE79's closeout + commit and the
discovery-ledger fix landed.

PROVENANCE (our run, 2026-11-12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE79): RUN PARAMETERS: a = 12 363 155 037 115 (= b79), b
requested = a + 20 000 = 12 363 155 057 115 = b ACTUAL (NON-SNAPPED), M =
60, C_R = 1, 32 workers, 33 213 evaluations, 2 510.8 s,
resumed_from_cache = 470 819 (seeded from window79_b79.json.cache.jsonl).
CERTIFICATE (window80_b80.json): the b - a = 20 000 zeros of zeta with
g_a80 < Im s <= g_b80 are ALL SIMPLE and on the line, where g_a80
(recorded exact dyadic ball) = 116063676004013668498535112581018935459 x
2^-85 with radius 16777217 x 2^-110 (i.e. 3 000 175 706 629.8801763284870433030491224869348413451796710703367576655864468193612992763519287109375, the W79 endpoint, + or - 1.29e-26) and this ball is BIT-IDENTICAL to CE79's
recorded g_b79 (exact dyadic tuple comparison, 2026-11-12 - audit
PERFORMED BEFORE this module was written, per the 0348 process rule);
g_b80 = 3 000 175 711 302.815289940239932351359670887076201354262531585670448208702509873546659946441650390625 + or - 1.29e-26 (exact dyadic tuple
[58031838092394544844932654878558226481, -84, 16777217, -110]; the
endpoint ball is NORMALIZED at exponent -84 this time - the third
normalization form in the series (-86, -85, -84); the exact dyadic tuple
is authoritative over the exponent representation). The floor tCE80 sits
0.815289940239932351359670887076201354262531585670448208702509873546659946441650390625 below the endpoint g_b80 - robust to the 1.29e-26 radius by many orders of magnitude;
the standard two-decimal lower bound gB80Lo (3 000 175 711 302.81) has the
exact margin 0.00528994023993235135967087415150351274949641091034617271816325260991 (integer-tuple arithmetic); the two-decimal
round-down (0.81) does not equal the floor, so no CASING is needed -
window 38 / CE38 remains the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE79): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window80_b80.json: "CERTIFIED: true",
points_checked = 33 213, sign_changes_inside = 20 000 (NON-SNAPPED
width), roser_failures_inside = 0 (CLEAN window - the first since W74),
turing_ok = true, K_conservative = 12, end Rosser runs 52 / 49, endpoints
recomputed and matched; (3) SEAM AUDIT (this run): the recorded g_a80
ball is bit-identical to CE79's recorded g_b79 ball (exact dyadic decode,
2026-11-12). FRONTIER ARITHMETIC (machine, below): tCE80 =
3 000 175 711 302, tCE80 - tCE79 = 4 673, tCE80 - tPT2 = 378 502 (375 000
mark CROSSES with margin 3 502; new theorem frontierPast375k). HONESTY
(trust base): as CE2-CE79 - the pipeline's own controls, its
kernel-checked Lean remainder theorem, and our three verification layers;
a RE-RUN of a third-party pipeline, not a from-scratch independent
certification; the clean-window status is the recorded certificate data
(rosser_failures_inside = 0). Cumulative certified count = 1 619 985
over (g_a1, g_b80] (pipeline data, not in-tree arithmetic) - the 1 600
000 CERTIFIED-ZERO MARK CROSSES IN THIS WINDOW (margin 19 985). NO RH
CLAIM.
-/
namespace CE80


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b80 (machine): gB80Lo = 3 000 175 711 302.81 = 300017571130281/100 - the two-decimal round-down of the certified lower bound, i.e. the endpoint g_b80 (' + GB80 + ') minus its certified radius 1.29e-26. The margin is the exact 0.00528994023993235135967087415150351274949641091034617271816325260991... (integer-tuple arithmetic) - the usual cent granularity; no CASING is needed (the two-decimal round-down does not equal the floor - window 38 / CE38 remains the only CASING case so far; W80, like W66-W79, did not trigger it). -/
def gB80Lo : ℚ := 300017571130281 / 100

/-- THE NEW LOWER BOUND (machine): 3 000 175 711 302 = floor(g_b80) = int(3 000 175 711 302.815289940239932351...). The endpoint sits 0.815289940239932... above the integer boundary and the certified radius is 1.29e-26, so the floor is robust by many orders of magnitude. tCE80 - tCE79 = 4 673 (the usual step; the increment series w77 -> w78 -> w79 -> w80 reads 4 673, 4 672 [SNAP], 4 673, 4 673). THE 375 000 UNIT MILESTONE CROSSES AT THIS WINDOW. -/
def tCE80 : ℕ := 3000175711302

theorem tCE80_lt_gB80Lo : (tCE80 : ℝ) < (gB80Lo : ℝ) := by
  norm_num [gB80Lo, tCE80]

theorem tCE79_lt_tCE80 : (tCE79 : ℝ) < (tCE80 : ℝ) := by
  norm_num [CE79.tCE79, tCE80]

/-- ORDERING (machine, norm_num): (gB79Lo : R) < (tCE80 : R), with gB79Lo = 300017570662988/100 (the STANDARD lower bound introduced at CE79) and tCE80 = 3000175711302. So the window-80 terminal slice starts strictly below the new floor. -/
theorem gB79Lo_lt_tCE80 : (gB79Lo : ℝ) < (tCE80 : ℝ) := by
  norm_num [CE79.gB79Lo, tCE80]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE80 - tCE79 = 4 673. The usual step: W80 was NON-SNAPPED and CLEAN (the requested width 20 000 was delivered in full, zero interior Rosser failures - the first clean window since W74). The increment series w77 -> w78 -> w79 -> w80 reads 4 673, 4 672 [SNAP], 4 673, 4 673; the four 4 672 occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]); no pattern claimed (floor/snap artifact data points). -/
theorem faceShrinkCE80 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := by
  norm_num [tCE80, CE79.tCE79]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE80 : R) - WinC.tPT2 = 3 000 175 711 302 - 3 000 175 332 800 = 378 502 above the H0 frontier WinC.tPT2 - **THE 375 000 UNIT MILESTONE CROSSES IN WINDOW 80, margin 3 502** (the SECOND PREDICTION of the series ACHIEVED: 0388 computed the required W80 increment as 1 172 and predicted margin ~3 500; W80 delivered increment 4 673 and the frontier landed at exactly the predicted 378 502). The 350 000 mark (crossed WINDOW 74 [0380], first prediction, delivered exactly) CARRIES with margin 28 502; the 325 000 and 300 000 marks carry with margins 53 502 and 78 502. The next round mark 400 000 sits 21 498 ahead (~4.6 windows; predicted around window 85 - compute from the decoded endpoint, do not pre-announce). CERTIFIED-ZERO CENSUS: cumulative total 1 619 985 over (g_a1, g_b80] - **THE 1 600 000 CERTIFIED-ZERO MARK CROSSES IN WINDOW 80, margin 19 985** (census milestones are documents, not theorems - the W75 precedent for 1 500 000); the 1 500 000 mark carries margin 119 985; the 1 700 000 mark is 80 015 ahead (~17 windows, around window 97). THE WINDOW-80 DOUBLE CONVERGENCE PREDICTED AT CE78/CE79 IS ACHIEVED - both marks crossed in the same window, at the exact predicted margins. -/
theorem frontierGapAboveH0 : (tCE80 : ℝ) - WinC.tPT2 = 378502 := by
  norm_num [tCE80, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 200 000-unit milestone (CROSSED in WINDOW 42B at 200 823, margin 823) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 200 000. CARRIED INTO WINDOW-80: the face has since crossed 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - CROSSES IN THIS WINDOW); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast200k : (tCE80 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 175 000-unit milestone (CROSSED in WINDOW 38 at 175 404, margin 404) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 175 000. CARRIED INTO WINDOW-80: the face has since crossed every round mark up to 375 000 @ CE80 (CROSSES IN THIS WINDOW, margin 3 502); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast175k : (tCE80 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 225 000-unit milestone (CROSSED in WINDOW 48 at 225 364, margin 364) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 225 000. CARRIED INTO WINDOW-80: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (CROSSES IN THIS WINDOW); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast225k : (tCE80 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 250 000-unit milestone (CROSSED in WINDOW 53 at 250 944, margin 944) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 250 000. CARRIED INTO WINDOW-80: the face has since crossed 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (CROSSES IN THIS WINDOW); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast250k : (tCE80 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 275 000-unit milestone (CROSSED in WINDOW 58 at 275 088, margin 88) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 275 000. CARRIED INTO WINDOW-80: the face has since crossed 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (CROSSES IN THIS WINDOW); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast275k : (tCE80 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 300 000-unit round mark (CROSSED in WINDOW 64 at 300 972, margin 972) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 300 000, margin 78 502. CARRIED INTO WINDOW-80: the face has since crossed 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (CROSSES IN THIS WINDOW, margin 3 502); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast300k : (tCE80 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 325 000-unit milestone (CROSSED in WINDOW 69 at 327 100, margin 2100 - predicted one window ahead and delivered exactly [0375]) is STILL strictly exceeded at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 325 000, margin 53 502. CARRIED INTO WINDOW-80: the face has since crossed 350 000 @ CE74 (margin 465), 375 000 @ CE80 (CROSSES IN THIS WINDOW, margin 3 502); the 400 000 round mark is 21 498 ahead. -/
theorem frontierPast325k : (tCE80 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-80 - tCE80 - tPT2 = 378 502 exceeds 350 000 with margin 28 502 (window 80 crossed the 375 000 mark instead - see frontierPast375k; the 0388 prediction ACHIEVED at margin 3 502). This statement is proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, so the crossing record stays true at the new frontier. -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  have hshrink1 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := faceShrinkCE80
  have hshrink2 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink3 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink4 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink5 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink6 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6]
  linarith [h]
/-- NEW MILESTONE (machine, PROVEN): the 375 000 UNIT MILESTONE is CROSSED at the WINDOW-80 lower bound - (tCE80 : R) - WinC.tPT2 = 378 502 > 375 000, margin 3 502. This is the SECOND PREDICTION of the series ACHIEVED: 0388 (at CE79) computed the required W80 increment as 1 172 and predicted the crossing "at margin ~3 500"; W80 delivered increment 4 673 (non-snapped) and margin 3 502, and the frontier landed at exactly the predicted 378 502. The DOUBLE CONVERGENCE window: the 1 600 000 CERTIFIED-ZERO CENSUS MARK crossed in the same window (census 1 619 985, margin 19 985 - see the header) at its predicted margin ~19 984..19 985. The next round mark 400 000 is 21 498 ahead (~4.6 windows; predicted around window 85 - compute from the decoded endpoint, do not pre-announce). -/
theorem frontierPast375k : (tCE80 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE80 : ℝ) - WinC.tPT2 = 378502 := frontierGapAboveH0
  linarith [h]

/-- ORDERING (machine, norm_num): (gB79Lo : R) < (gB80Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB79Lo = 300017570662988/100 (the STANDARD lower bound on the NON-SNAPPED window-79 endpoint g_b79) and gB80Lo = 300017571130281/100 (the STANDARD lower bound on the NON-SNAPPED CLEAN window-80 endpoint g_b80 = 3 000 175 711 302.815289940239932351359670887076201354262531585670448208702509873546659946441650390625). -/
theorem gB79Lo_lt_gB80Lo : (gB79Lo : ℝ) < (gB80Lo : ℝ) := by
  norm_num [CE79.gB79Lo, gB80Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 79 FULL slice (re-cited in the W80 band - window 79 of 81, full union (gB78, gB79] = the recorded window, width 20 000 [NON-SNAPPED - the W78 snap was a one-off endpoint condition], certified 2026-11-12, RECORDED rescue window - ONE recorded interior Rosser failure block, ultimately DETERMINED (rescue quota-met on the union, determined in the certificate - RECORDED, not suppressed): naive block [12 363 155 018 346, 12 363 155 018 348] (need = 2, changes = 0, points = 129, m = 64), union [12 363 155 018 345, 12 363 155 018 349], need = 4, found = 4, m = 4; end Rosser runs 46 / 48, K = 12; zero cross-check failures (33 991 records), zero undetermined Gram signs): the b - a = 20 000 zeros of zeta with gB78 (' + GB78 + ', the W78 endpoint - SNAPPED width 19 999, the second snap in the series) < Im s <= gB79 (' + GB79 + ', the W79 endpoint, + or - 1.29e-26) are all simple and on the line. Provenance: window79_b79.json (Murphy pipeline; M = 60, C_R = 1, N_range = [691 008, 691 008], 33 991 evals in 2 493.2 s, 32 workers, resumed_from_cache = 437 029); verifier CERTIFIED (points 33 991, sign_changes_inside = 20 000, roser_failures_inside = 1, turing_ok, K_conservative = 12, end runs 46/48). SEAM: its g_a ball is the CE78 g_b ball EXACTLY (bit-identical tuple). Window-79 data per 0388 (unit 102); no RH CLAIM about window 79 or its Rosser record. -/
def ce79WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB78Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB79Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 80 TERMINAL slice (re-cited - window 80 of 81, the (gB79, g_b80] portion of the recorded window, up to floor(gB80) - NON-SNAPPED 20 000 AND CLEAN: zero interior Rosser failures, the first clean window since W74): the zeros of zeta with gB79 (' + GB79 + ', = window 79's endpoint, + or - 1.29e-26) < Im s <= int(gB80) = 3 000 175 711 302 (the FLOOR - the endpoint g_b80 = 3 000 175 711 302.815289940239932351359670887076201354262531585670448208702509873546659946441650390625 sits 0.815289940239932... above it, robust to the 1.29e-26 radius) are all simple and on the line. Certificates: window80_b80.json (window 80's, NON-SNAPPED 20 000, CLEAN - roser_failures_inside = 0, certified 2026-11-12, pipeline data) + the pipeline verifier (CERTIFIED, turing_ok, points 33 213, sign_changes_inside = 20 000, end Rosser runs 52 / 49, K_conservative = 12, 0 cross-check failures, 0 undetermined Gram signs) + the CE80 header (M = 60, C_R = 1, N_range = [691 008, 691 008], 32 workers, 33 213 evals in 2 510.8 s, fourteenth overlap run, and the bit-identical g_a80 == g_b79 SEAM AUDIT). Slice restriction (gB79, int(gB80)] is a SUBSET of the certified window, so its zeros inherit on-linedness; no RH CLAIM about the face above g_b80. THE 375 000 UNIT MILESTONE AND THE 1 600 000 CERTIFIED-ZERO MARK CROSS IN THIS WINDOW. -/
def ce80WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB79Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE80 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h81 (window 80 contributes ONE clause for its (gB79, g_b80] portion - h81; W80 NON-SNAPPED 20 000 and CLEAN - zero interior Rosser failures, first clean since W74), ALL zeros of zeta with Im s > WinC.tPT2 and Im s <= (tCE80 : R) lie on the line: h1-h2 cover window 1 (CE2, the Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42 (CE2-CE42), h44b fills the W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..80 enter as their certified (gB-prev, gB] slices (clause per re-cited slice - the slices are bit-identical at every seam, so the re-cited clause is exactly the recorded window's data; the re-cited full-slice clause carries the full recorded window) - windows 53..79 carry the recorded Rosser-rescue records (W53, W54, W66, W69, W70, W73, W76, W77, W79: one recorded failure each; W78: SNAPPED 19 999 with one recorded failure; all ultimately determined) and window 80 is CLEAN (zero failures) - and h81 carries the window-80 (gB79, g_b80] slice (NON-SNAPPED 20 000, CLEAN). NO RH CLAIM about Im s > tCE80. -/
theorem bandOfWindows80 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : CE22.ce21WinClauseFull)
    (h22 : CE23.ce22WinClauseFull) (h23 : CE24.ce23WinClauseFull)
    (h24 : CE25.ce24WinClauseFull) (h25 : CE26.ce25WinClauseFull)
    (h26 : CE27.ce26WinClauseFull) (h27 : CE28.ce27WinClauseFull)
    (h28 : CE29.ce28WinClauseFull) (h29 : CE30.ce29WinClauseFull)
    (h30 : CE31.ce30WinClauseFull)
    (h31 : CE32.ce31WinClauseFull)
    (h32 : CE33.ce32WinClauseFull)
    (h33 : CE34.ce33WinClauseFull)
    (h34 : CE35.ce34WinClauseFull)
    (h35 : CE36.ce35WinClauseFull)
    (h36 : CE37.ce36WinClauseFull)
    (h37 : CE38.ce37WinClauseFull)
    (h38 : CE39.ce38WinClauseFull)
    (h39 : CE40.ce39WinClauseFull)
    (h40 : CE41.ce40WinClauseFull)
    (h41 : ce41WinClauseFull)
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : ce79WinClauseFull) (h81 : ce80WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE80 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
          · exact h5 ρ hz (not_le.mp hseam4) hseam5
          · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
            · exact h6 ρ hz (not_le.mp hseam5) hseam6
            · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
              · exact h7 ρ hz (not_le.mp hseam6) hseam7
              · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
                · exact h8 ρ hz (not_le.mp hseam7) hseam8
                · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
                  · exact h9 ρ hz (not_le.mp hseam8) hseam9
                  · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
                    · exact h10 ρ hz (not_le.mp hseam9) hseam10
                    · by_cases hseam11 : ρ.im ≤ (gB11Lo : ℝ)
                      · exact h11 ρ hz (not_le.mp hseam10) hseam11
                      · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
                        · exact h12 ρ hz (not_le.mp hseam11) hseam12
                        · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
                          · exact h13 ρ hz (not_le.mp hseam12) hseam13
                          · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
                            · exact h14 ρ hz (not_le.mp hseam13) hseam14
                            · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
                              · exact h15 ρ hz (not_le.mp hseam14) hseam15
                              · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
                                · exact h16 ρ hz (not_le.mp hseam15) hseam16
                                · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
                                  · exact h17 ρ hz (not_le.mp hseam16) hseam17
                                  · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
                                    · exact h18 ρ hz (not_le.mp hseam17) hseam18
                                    · by_cases hseam19 : ρ.im ≤ (gB19Lo : ℝ)
                                      · exact h19 ρ hz (not_le.mp hseam18) hseam19
                                      · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
                                        · exact h20 ρ hz (not_le.mp hseam19) hseam20
                                        · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
                                          · exact h21 ρ hz (not_le.mp hseam20) hseam21
                                          · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
                                            · exact h22 ρ hz (not_le.mp hseam21) hseam22
                                            · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
                                              · exact h23 ρ hz (not_le.mp hseam22) hseam23
                                              · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
                                                · exact h24 ρ hz (not_le.mp hseam23) hseam24
                                                · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
                                                  · exact h25 ρ hz (not_le.mp hseam24) hseam25
                                                  · by_cases hseam26 : ρ.im ≤ (gB26Lo : ℝ)
                                                    · exact h26 ρ hz (not_le.mp hseam25) hseam26
                                                    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
                                                      · exact h27 ρ hz (not_le.mp hseam26) hseam27
                                                      · by_cases hseam28 : ρ.im ≤ (gB28Lo : ℝ)
                                                        · exact h28 ρ hz (not_le.mp hseam27) hseam28
                                                        · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
                                                          · exact h29 ρ hz (not_le.mp hseam28) hseam29
                                                          · by_cases hseam30 : ρ.im ≤ (gB30Lo : ℝ)
                                                            · exact h30 ρ hz (not_le.mp hseam29) hseam30
                                                            · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
                                                              · exact h31 ρ hz (not_le.mp hseam30) hseam31
                                                              · by_cases hseam32 : ρ.im ≤ (gB32Lo : ℝ)
                                                                · exact h32 ρ hz (not_le.mp hseam31) hseam32
                                                                · by_cases hseam33 : ρ.im ≤ (gB33Lo : ℝ)
                                                                  · exact h33 ρ hz (not_le.mp hseam32) hseam33
                                                                  · by_cases hseam34 : ρ.im ≤ (gB34Lo : ℝ)
                                                                    · exact h34 ρ hz (not_le.mp hseam33) hseam34
                                                                    · by_cases hseam35 : ρ.im ≤ (gB35Lo : ℝ)
                                                                      · exact h35 ρ hz (not_le.mp hseam34) hseam35
                                                                      · by_cases hseam36 : ρ.im ≤ (gB36Lo : ℝ)
                                                                        · exact h36 ρ hz (not_le.mp hseam35) hseam36
                                                                        · by_cases hseam37 : ρ.im ≤ (gB37Lo : ℝ)
                                                                          · exact h37 ρ hz (not_le.mp hseam36) hseam37
                                                                          · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
                                                                            · exact h38 ρ hz (not_le.mp hseam37) hseam38
                                                                            · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
                                                                              · exact h39 ρ hz (not_le.mp hseam38) hseam39
                                                                              · by_cases hseam40 : ρ.im ≤ (gB40Lo : ℝ)
                                                                                · exact h40 ρ hz (not_le.mp hseam39) hseam40
                                                                                · by_cases hseam41 : ρ.im ≤ (gB41Lo : ℝ)
                                                                                  · exact h41 ρ hz (not_le.mp hseam40) hseam41
                                                                                  · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
                                                                                    · exact h42 ρ hz (not_le.mp hseam41) hseam42
                                                                                    · by_cases hseam43 : ρ.im ≤ (gB42BLo : ℝ)
                                                                                      · exact h43 ρ hz (not_le.mp hseam42) hseam43
                                                                                      · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
                                                                                        · exact h44 ρ hz (not_le.mp hseam43) hseam44
                                                                                        · by_cases hseam45 : ρ.im ≤ (gB44Lo : ℝ)
                                                                                          · exact h45 ρ hz (not_le.mp hseam44) hseam45
                                                                                          · by_cases hseam46 : ρ.im ≤ (gB45Lo : ℝ)
                                                                                            · exact h46 ρ hz (not_le.mp hseam45) hseam46
                                                                                            · by_cases hseam47 : ρ.im ≤ (gB46Lo : ℝ)
                                                                                              · exact h47 ρ hz (not_le.mp hseam46) hseam47
                                                                                              · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
                                                                                                · exact h48 ρ hz (not_le.mp hseam47) hseam48
                                                                                                · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
                                                                                                  · exact h49 ρ hz (not_le.mp hseam48) hseam49
                                                                                                  · by_cases hseam50 : ρ.im ≤ (gB49Lo : ℝ)
                                                                                                    · exact h50 ρ hz (not_le.mp hseam49) hseam50
                                                                                                    · by_cases hseam51 : ρ.im ≤ (gB50Lo : ℝ)
                                                                                                      · exact h51 ρ hz (not_le.mp hseam50) hseam51
                                                                                                      · by_cases hseam52 : ρ.im ≤ (gB51Lo : ℝ)
                                                                                                        · exact h52 ρ hz (not_le.mp hseam51) hseam52
                                                                                                        · by_cases hseam53 : ρ.im ≤ (gB52Lo : ℝ)
                                                                                                          · exact h53 ρ hz (not_le.mp hseam52) hseam53
                                                                                                          · by_cases hseam54 : ρ.im ≤ (gB53Lo : ℝ)
                                                                                                            · exact h54 ρ hz (not_le.mp hseam53) hseam54
                                                                                                            · by_cases hseam55 : ρ.im ≤ (gB54Lo : ℝ)
                                                                                                              · exact h55 ρ hz (not_le.mp hseam54) hseam55
                                                                                                              · by_cases hseam56 : ρ.im ≤ (gB55Lo : ℝ)
                                                                                                                · exact h56 ρ hz (not_le.mp hseam55) hseam56
                                                                                                                · by_cases hseam57 : ρ.im ≤ (gB56Lo : ℝ)
                                                                                                                  · exact h57 ρ hz (not_le.mp hseam56) hseam57
                                                                                                                  · by_cases hseam58 : ρ.im ≤ (gB57Lo : ℝ)
                                                                                                                    · exact h58 ρ hz (not_le.mp hseam57) hseam58
                                                                                                                    · by_cases hseam59 : ρ.im ≤ (gB58Lo : ℝ)
                                                                                                                      · exact h59 ρ hz (not_le.mp hseam58) hseam59
                                                                                                                      · by_cases hseam60 : ρ.im ≤ (gB59Lo : ℝ)
                                                                                                                        · exact h60 ρ hz (not_le.mp hseam59) hseam60
                                                                                                                        · by_cases hseam61 : ρ.im ≤ (gB60Lo : ℝ)
                                                                                                                          · exact h61 ρ hz (not_le.mp hseam60) hseam61
                                                                                                                          · by_cases hseam62 : ρ.im ≤ (gB61Lo : ℝ)
                                                                                                                            · exact h62 ρ hz (not_le.mp hseam61) hseam62
                                                                                                                            · by_cases hseam63 : ρ.im ≤ (gB62Lo : ℝ)
                                                                                                                              · exact h63 ρ hz (not_le.mp hseam62) hseam63
                                                                                                                              · by_cases hseam64 : ρ.im ≤ (gB63Lo : ℝ)
                                                                                                                                · exact h64 ρ hz (not_le.mp hseam63) hseam64
                                                                                                                                · by_cases hseam65 : ρ.im ≤ (gB64Lo : ℝ)
                                                                                                                                  · exact h65 ρ hz (not_le.mp hseam64) hseam65
                                                                                                                                  · by_cases hseam66 : ρ.im ≤ (gB65Lo : ℝ)
                                                                                                                                    · exact h66 ρ hz (not_le.mp hseam65) hseam66
                                                                                                                                    · by_cases hseam67 : ρ.im ≤ (gB66Lo : ℝ)
                                                                                                                                      · exact h67 ρ hz (not_le.mp hseam66) hseam67
                                                                                                                                      · by_cases hseam68 : ρ.im ≤ (gB67Lo : ℝ)
                                                                                                                                        · exact h68 ρ hz (not_le.mp hseam67) hseam68
                                                                                                                                        · by_cases hseam69 : ρ.im ≤ (gB68Lo : ℝ)
                                                                                                                                          · exact h69 ρ hz (not_le.mp hseam68) hseam69
                                                                                                                                          · by_cases hseam70 : ρ.im ≤ (gB69Lo : ℝ)
                                                                                                                                            · exact h70 ρ hz (not_le.mp hseam69) hseam70
                                                                                                                                            · by_cases hseam71 : ρ.im ≤ (gB70Lo : ℝ)
                                                                                                                                              · exact h71 ρ hz (not_le.mp hseam70) hseam71
                                                                                                                                              · by_cases hseam72 : ρ.im ≤ (gB71Lo : ℝ)
                                                                                                                                                · exact h72 ρ hz (not_le.mp hseam71) hseam72
                                                                                                                                                · by_cases hseam73 : ρ.im ≤ (gB72Lo : ℝ)
                                                                                                                                                  · exact h73 ρ hz (not_le.mp hseam72) hseam73
                                                                                                                                                  · by_cases hseam74 : ρ.im ≤ (gB73Lo : ℝ)
                                                                                                                                                    · exact h74 ρ hz (not_le.mp hseam73) hseam74
                                                                                                                                                    · by_cases hseam75 : ρ.im ≤ (gB74Lo : ℝ)
                                                                                                                                                      · exact h75 ρ hz (not_le.mp hseam74) hseam75
                                                                                                                                                      · by_cases hseam76 : ρ.im ≤ (gB75Lo : ℝ)
                                                                                                                                                        · exact h76 ρ hz (not_le.mp hseam75) hseam76
                                                                                                                                                        · by_cases hseam77 : ρ.im ≤ (gB76Lo : ℝ)
                                                                                                                                                          · exact h77 ρ hz (not_le.mp hseam76) hseam77
                                                                                                                                                          · by_cases hseam78 : ρ.im ≤ (gB77Lo : ℝ)
                                                                                                                                                            · exact h78 ρ hz (not_le.mp hseam77) hseam78
                                                                                                                                                            · by_cases hseam79 : ρ.im ≤ (gB78Lo : ℝ)
                                                                                                                                                              · exact h79 ρ hz (not_le.mp hseam78) hseam79
                                                                                                                                                              · by_cases hseam80 : ρ.im ≤ (gB79Lo : ℝ)
                                                                                                                                                                · exact h80 ρ hz (not_le.mp hseam79) hseam80
                                                                                                                                                                · exact h81 ρ hz (not_le.mp hseam80) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 100-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE80 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..hW81 : the 81 verified window-slice clauses - the cited W43-W44B..W53, W55-W65, W67-W68, W71-W72, W74-W75 slices + the RE-CITED full slices for the re-anchored windows 43..80 (bit-identical seams, recorded data) incl. the W77/W78/W79 Rosser records + hW81 : the window-80 terminal slice (CLEAN)). This is the finite-height closure through the corrected w1-w80 band (W42b fill) re-anchored to all of the certified EIGHTIETH window (NON-SNAPPED 20 000, CLEAN - zero interior Rosser failures); census 1 619 985 over (g_a1, g_b80] - the 1 600 000 CERTIFIED-ZERO MARK CROSSES IN THIS WINDOW (margin 19 985). NO RH CLAIM about the face above tCE80. -/
theorem allOnLineUpToCE80 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : ce79WinClauseFull) (hW81 : ce80WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE80 : ℝ) := by
  have hband := bandOfWindows80 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE EIGHTIETH RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the EIGHTIETH certified window (NON-SNAPPED 20 000, CLEAN - the first clean window since W74; census 1 619 985 over (g_a1, g_b80]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE80 : R) = 3 000 175 711 302 lies on the line - i.e. the absolute clause [S1] / A1 (no data-dependent bound on the S-at-zeros / DN walk) above the new lower bound. THE WINDOW-80 DOUBLE CONVERGENCE IS ACHIEVED: the 375 000 UNIT MILESTONE CROSSES here (margin 3 502 - the second prediction of the series, ACHIEVED at its predicted margin ~3 500, frontier exactly at the predicted 378 502) and the 1 600 000 CERTIFIED-ZERO MARK CROSSES in the same window (census 1 619 985, margin 19 985) - both marks, one window, as predicted at CE78/CE79. The 378 502-unit window over the H0 frontier is carried (350 000 carries margin 28 502; the 400 000 round mark is 21 498 ahead, predicted around window 85). The 1 700 000 census mark is 80 015 ahead (~17 windows, around window 97). The increment series w77 -> w80 reads 4 673, 4 672 [SNAP], 4 673, 4 673; the four 4 672 occurrences remain the four recorded; no pattern claim (floor/snap artifact data points). The face does not shrink by 20 000 - it is RE-ANCHORED (and the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE80 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE80 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE75 -> tCE76 -> ... -> tCE79 -> tCE80) leaves the face IMPLICATOR - anything true above tCE79 is true above tCE80. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE79_implies_faceCE80 (q : ZeroSet)
    (hface : CE79.terminalFaceCE79 q) :
    terminalFaceCE80 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE79_lt_tCE80, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW80, hW81): terminalFaceCE80 q <-> terminalFaceCE79 q. The re-anchor adds no strength and loses none - what was open at tCE79 is (exactly) what is open at tCE80, and the slice family (gB79Lo, tCE80] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE79 pattern). The forward direction splits on 'Im s <= tCE80': the band slice (gB79Lo, tCE80] is handled by the verified window slices hW80, hW81 (the W80 slice is NON-SNAPPED 20 000 and CLEAN - zero interior Rosser failures), the part above tCE80 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE80_iff_faceCE79 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW80 : ce79WinClauseFull) (hW81 : ce80WinClause) :
    terminalFaceCE80 q ↔ CE79.terminalFaceCE79 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE80 : ℝ)
    · by_cases hseam80 : ρ.im ≤ (gB79Lo : ℝ)
      · exact hW80 ρ (hqz ρ hρ) (by linarith [ht, CE79.gB78Lo_lt_tCE79, tCE79_lt_tCE80]) hseam80
      · exact hW81 ρ (hqz ρ hρ) (not_le.mp hseam80) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE79_implies_faceCE80 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE80) x (terminalFaceCE80 q) - finite-height closure (now through the corrected w1-w80 band with the W42b fill, re-anchored windows 53..80 all bit-identical at their seams; window 80 certified NON-SNAPPED at 20 000 and CLEAN - zero interior Rosser failures) AND the absolute clause above tCE80. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE80 - tPT2 = 378 502 - **THE 375 000 UNIT MILESTONE CROSSES IN WINDOW 80, margin 3 502**; census 1 619 985 - **the 1 600 000 CERTIFIED-ZERO MARK CROSSES IN THE SAME WINDOW, margin 19 985** - the double convergence ACHIEVED at the exact predicted margins). -/
theorem rh_split_at_CE80 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE80 : ℝ) ∧ terminalFaceCE80 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE80 : ℝ)
      · exact hCensus ρ hρ hpos hle
      · exact hFace ρ hρ (not_le.mp hle)
    · have hneg : ρ.im < 0 := by
        have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne hle0 hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstpos : 0 < (star ρ).im := by
        have h : (star ρ).im = -ρ.im := by rfl
        rw [h]
        exact neg_pos.mpr hneg
      have hstRe : (star ρ).re = 1 / 2 := by
        by_cases hle : (star ρ).im ≤ (tCE80 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE80): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW81 : the 81 verified window-slice clauses - windows 1..80, incl. the re-anchored 53..80 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79: one recorded failure each; W78: SNAPPED 19 999, one recorded failure - all ultimately determined) and the W80 terminal slice (CLEAN - zero failures)), RH is equivalent to the NAMED terminal face above tCE80 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w80 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..80, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE80 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : ce79WinClauseFull) (hW81 : ce80WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE80 q := by
  have hcensus := allOnLineUpToCE80 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hqz
  have hsplit := rh_split_at_CE80 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE80 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : ce79WinClauseFull) (hW81 : ce80WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE80 q) :
    RH q :=
  (rh_reanchored_CE80 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE80_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE80 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE80