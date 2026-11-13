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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78
open scoped Topology

/-!
**CE79 — the terminal face re-anchored at the SEVENTY-NINTH certified window
(0388, option B, unit 102 - lane M5).

MILESTONE STATE: tCE79 - tPT2 = 373 829 - the 350 000 UNIT MILESTONE
CARRIES with margin 23 829 (crossed in WINDOW 74 at 350 465, margin 465
[0380] - the FIRST PREDICTION of the series, delivered exactly); the 325
000-unit mark CARRIES (margin 48 829; crossed in WINDOW 69 [0375]); the
300 000-unit mark CARRIES (margin 73 829; crossed in WINDOW 64 [0370]).
The next round mark 375 000 sits only 1 171 AHEAD - the W80 CROSSING IS
NOW ARITHMETICALLY FORCED: any plausible W80 increment (4 672 or 4 673
non-snapped; >= 4 671 even snapped) is far above the required 1 172, so
the crossing lands at margin ~3 500 (compute from the decoded endpoint,
do not pre-announce). Round-mark sequence above H0: 100 000 @ CE22, 125
000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @
CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350
000 @ CE74 (CARRIED), 375 000 @ CE80 (FORCED). CERTIFIED-ZERO CENSUS:
cumulative total 1 599 985 over (g_a1, g_b79] - 15 SHORT of the 1 600 000
certified-zero mark, EXACTLY AS 0387 PREDICTED (w79 -> at most 1 599 985,
[15 short]); the W80 CENSUS CROSSING IS ALSO ARITHMETICALLY FORCED (any W80
width, snapped or not, adds >= 19 999: 1 599 985 + 19 999 = 1 619 984 >
1 600 000, margin ~19 984..19 985). WINDOW 80 IS THE DOUBLE-CONVERGENCE
WINDOW - the W76-W78 prediction is now FORCED BY ARITHMETIC, not merely
expected. The 1 500 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 75 [0381]
at 1 519 986, margin 19 986) CARRIES with margin 99 985.

WINDOW 79: NON-SNAPPED (the requested width 20 000 delivered in full -
the W78 snap was a one-off endpoint condition, not a trend). RESCUE
WINDOW - one recorded interior Rosser failure block, ultimately DETERMINED
(rescue quota-met on the union, determined in the certificate - RECORDED,
not suppressed): naive block [12 363 155 018 346, 12 363 155 018 348]
(need = 2, changes = 0, points = 129, m = 64), union [12 363 155 018 345,
 12 363 155 018 349] with need = 4, found = 4, m = 4; roser_failures_inside
= 1. End Rosser runs: 46 left of g_a79, 48 right of g_b79 (both >= K =
12); 0 cross-check failures (all 33 991 records); 0 undetermined Gram
signs. INCREMENT: 4 673 (the usual step after the snapped W78; the
increment series w77 -> w78 -> w79 is 4 673, 4 672 [SNAP], 4 673).

PIPELINE RUN (thirteenth in the overlap pipeline): seed cache (window 78'
cache copied in before launch - resumed_from_cache = 437 029, logged for
provenance) + 32 workers: 33 991 evaluations in 2 493.2 s (series: 2 497.2
/ 2 498.3 / 2 498.5 / 2 490.4 / 2 483.4 / 2 375.0 / 2 459.6 / 2 490.2 / 2
387.5 / 2 437.1 / 2 478.0 / 2 408.7 / 2 493.2 - the count moved, the
certification content did not: same M = 60, C_R = 1, N_range = [691 008,
691 008], same pipeline, same verifier, same seam discipline). Window 79
RAN WHILE CE78's closeout + commit landed - the per-unit critical path is
max(run, formalization); WINDOW 80 - the DOUBLE CONVERGENCE window (375
000 + 1 600 000) - is launched with the W79 seam already audited.

PROVENANCE (our run, 2026-11-12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE78): RUN PARAMETERS: a = 12 363 155 017 115 (= b78 actual),
b requested = a + 20 000 = 12 363 155 037 115 = b ACTUAL (NON-SNAPPED), M
= 60, C_R = 1, 32 workers, 33 991 evaluations, 2 493.2 s,
resumed_from_cache = 437 029 (seeded from window78_b78.json.cache.jsonl).
CERTIFICATE (window79_b79.json): the b - a = 20 000 zeros of zeta with
g_a79 < Im s <= g_b79 are ALL SIMPLE and on the line, where g_a79
(recorded exact dyadic ball) = 232127351646476494593469076330761822715 x
2^-86 with radius 16777217 x 2^-110 (i.e. 3 000 175 701 956.94506244608124617147622325095369350055906384859560898092922798241488635540008544921875, the W78 endpoint, + or - 1.29e-26) and this ball is BIT-IDENTICAL to CE78's
recorded g_b78 (exact dyadic tuple comparison, 2026-11-12 - audit
PERFORMED BEFORE this module was written, per the 0348 process rule);
g_b79 = 3 000 175 706 629.8801763284870433030491224869348413451796710703367576655864468193612992763519287109375 + or - 1.29e-26 (exact dyadic tuple
[116063676004013668498535112581018935459, -85, 16777217, -110]; note the
endpoint ball is NORMALIZED at exponent -85, not the -86 used for g_a79 -
the exact dyadic tuple is authoritative over the exponent representation,
and the seam audit compares the recorded g_a79 tuple to CE78's recorded
g_b78 tuple, bit-identical as the pipeline records them). The floor tCE79
sits 0.8801763284870433030491224869348413451796710703367576655864468193612992763519287109375 below the endpoint g_b79 - robust to the 1.29e-26 radius by many orders of magnitude;
the standard two-decimal lower bound gB79Lo (3 000 175 706 629.88) has the
exact margin 0.00017632848704330304912247401014350366663589557665562960210019842455 (integer-tuple arithmetic); the two-decimal
round-down (0.88) does not equal the floor, so no CASING is needed -
window 38 / CE38 remains the only CASING case so far. (The gB79Lo margin
is thin - 1.76e-4 - by cent-granularity luck of the endpoint, not by any
precision danger: the certified radius is 1.29e-26, fifteen orders of
magnitude smaller.)

VERIFICATION (three layers, same as CE2-CE78): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window79_b79.json: "CERTIFIED: true",
points_checked = 33 991, sign_changes_inside = 20 000 (NON-SNAPPED
width), roser_failures_inside = 1 (RESCUE - the single block ultimately
determined, quota-met on the union; RECORDED, not suppressed),
turing_ok = true, K_conservative = 12, end Rosser runs 46 / 48, endpoints
recomputed and matched; (3) SEAM AUDIT (this run): the recorded g_a79
ball is bit-identical to CE78's recorded g_b78 ball (exact dyadic decode,
2026-11-12). FRONTIER ARITHMETIC (machine, below): tCE79 =
3 000 175 706 629, tCE79 - tCE78 = 4 673, tCE79 - tPT2 = 373 829 (350 000
mark Carries with margin 23 829; 375 000 FORCED at CE80). HONESTY (trust
base): as CE2-CE78 - the pipeline's own controls, its kernel-checked Lean
remainder theorem, and our three verification layers; a RE-RUN of a
third-party pipeline, not a from-scratch independent certification; the
Rosser exceptions are RECORDED, not suppressed (one occurred in this
window, ultimately determined - recorded above and in the certificate).
Cumulative certified count = 1 599 985 over (g_a1, g_b79] (pipeline data,
not in-tree arithmetic) - 15 short of the 1 600 000 mark, crossing FORCED
at window 80. NO RH CLAIM.
-/
namespace CE79


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b79 (machine): gB79Lo = 3 000 175 706 629.88 = 300017570662988/100 - the two-decimal round-down of the certified lower bound, i.e. the endpoint g_b79 (' + GB79 + ') minus its certified radius 1.29e-26. The margin is the exact 0.00017632848704330304912247401014350366663589557665562960210019842455... (integer-tuple arithmetic) - the margin is THIN (1.76e-4) by cent-granularity luck of the endpoint, not by any precision danger: the certified radius is 1.29e-26, fifteen orders of magnitude smaller. No CASING is needed (the two-decimal round-down does not equal the floor - window 38 / CE38 remains the only CASING case so far; W79, like W66-W78, did not trigger it). -/
def gB79Lo : ℚ := 300017570662988 / 100

/-- THE NEW LOWER BOUND (machine): 3 000 175 706 629 = floor(g_b79) = int(3 000 175 706 629.880176328487043303...). The endpoint sits 0.880176328487043... above the integer boundary and the certified radius is 1.29e-26, so the floor is robust by many orders of magnitude. tCE79 - tCE78 = 4 673 - the usual step after the snapped W78 window. -/
def tCE79 : ℕ := 3000175706629

theorem tCE79_lt_gB79Lo : (tCE79 : ℝ) < (gB79Lo : ℝ) := by
  norm_num [gB79Lo, tCE79]

theorem tCE78_lt_tCE79 : (tCE78 : ℝ) < (tCE79 : ℝ) := by
  norm_num [CE78.tCE78, tCE79]

/-- ORDERING (machine, norm_num): (gB78Lo : R) < (tCE79 : R), with gB78Lo = 300017570195694/100 (the STANDARD lower bound introduced at CE78 on the SNAPPED window-78 endpoint) and tCE79 = 3000175706629. So the window-79 terminal slice starts strictly below the new floor. -/
theorem gB78Lo_lt_tCE79 : (gB78Lo : ℝ) < (tCE79 : ℝ) := by
  norm_num [CE78.gB78Lo, tCE79]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE79 - tCE78 = 4 673. The usual step: W79 was NON-SNAPPED (the requested width 20 000 was delivered in full), so after the W78 snap-decrement (4 672) the increment series w77 -> w78 -> w79 reads 4 673, 4 672 [SNAP], 4 673. The four 4 672 occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]); no pattern is claimed (floor/snap artifact data points). -/
theorem faceShrinkCE79 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := by
  norm_num [tCE79, CE78.tCE78]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE79 : R) - WinC.tPT2 = 3 000 175 706 629 - 3 000 175 332 800 = 373 829 above the H0 frontier WinC.tPT2 - the 350 000 UNIT MILESTONE CARRIES with margin 23 829 (crossed WINDOW 74 at 350 465, margin 465 [0380] - first prediction, delivered exactly) as does the 325 000 mark (margin 48 829; crossed WINDOW 69 [0375]) and the 300 000 mark (margin 73 829; crossed WINDOW 64 [0370]). The 375 000 round mark is only 1 171 AHEAD and NOT YET CROSSED - the W80 crossing is now ARITHMETICALLY FORCED (any plausible W80 increment >= 4 671, snapped or not, is far above the required 1 172; margin ~3 500). CERTIFIED-ZERO CENSUS: cumulative total 1 599 985 over (g_a1, g_b79] - 15 SHORT of the 1 600 000 certified-zero mark, EXACTLY AS 0387 PREDICTED (w79 -> at most 1 599 985 [15 short]); the W80 census crossing is ALSO arithmetically forced (any W80 width adds >= 19 999: 1 619 984 > 1 600 000, margin ~19 984). THE 1 500 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 75 [0381] at 1 519 986, margin 19 986) CARRIES with margin 99 985. WINDOW 80 IS THE DOUBLE-CONVERGENCE WINDOW (375 000 unit + 1 600 000 census) - the W76-W78 prediction is now FORCED BY ARITHMETIC, not merely expected. -/
theorem frontierGapAboveH0 : (tCE79 : ℝ) - WinC.tPT2 = 373829 := by
  norm_num [tCE79, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 200 000-unit milestone (CROSSED in WINDOW 42B at 200 823, margin 823) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 200 000. CARRIED INTO WINDOW-79: the face has since crossed 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), and CARRIES 350 000 with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast200k : (tCE79 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 175 000-unit milestone (CROSSED in WINDOW 38 at 175 404, margin 404) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 175 000. CARRIED INTO WINDOW-79: the face has since crossed every round mark up to 350 000 @ CE74 and CARRIES it with margin 23 829 (window 79, this unit); 375 000 is FORCED at CE80. -/
theorem frontierPast175k : (tCE79 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 225 000-unit milestone (CROSSED in WINDOW 48 at 225 364, margin 364) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 225 000. CARRIED INTO WINDOW-79: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), and CARRIES 350 000 with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast225k : (tCE79 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 250 000-unit milestone (CROSSED in WINDOW 53 at 250 944, margin 944) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 250 000. CARRIED INTO WINDOW-79: the face has since crossed 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), and CARRIES 350 000 with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast250k : (tCE79 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 275 000-unit milestone (CROSSED in WINDOW 58 at 275 088, margin 88) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 275 000. CARRIED INTO WINDOW-79: the face has since crossed 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), and CARRIES 350 000 with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast275k : (tCE79 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 300 000-unit round mark (CROSSED in WINDOW 64 at 300 972, margin 972) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 300 000, margin 73 829. CARRIED INTO WINDOW-79: the face has since crossed 325 000 @ CE69, 350 000 @ CE74 (margin 465), and CARRIES 350 000 with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast300k : (tCE79 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 325 000-unit milestone (CROSSED in WINDOW 69 at 327 100, margin 2100 - predicted one window ahead and delivered exactly [0375]) is STILL strictly exceeded at the WINDOW-79 lower bound - (tCE79 : R) - WinC.tPT2 = 373 829 > 325 000, margin 48 829. CARRIED INTO WINDOW-79: the face has since crossed 350 000 @ CE74 (margin 465) and CARRIES it with margin 23 829; 375 000 is FORCED at CE80. -/
theorem frontierPast325k : (tCE79 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-79 - tCE79 - tPT2 = 373 829 exceeds 350 000 with margin 23 829. The 375 000 round mark is 1 171 ahead and NOT YET CROSSED - the W80 crossing is now ARITHMETICALLY FORCED (any plausible W80 increment >= 4 671, snapped or not, is far above the required 1 172; margin ~3 500), compute from the decoded endpoint, do not pre-announce. This statement is proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, so the crossing record stays true at the new frontier. -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE79 : ℝ) - WinC.tPT2 = 373829 := frontierGapAboveH0
  have hshrink1 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := faceShrinkCE79
  have hshrink2 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink3 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink4 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink5 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3, hshrink4, hshrink5]
  linarith [h]
/-- ORDERING (machine, norm_num): (gB78Lo : R) < (gB79Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB78Lo = 300017570195694/100 (the STANDARD lower bound on the SNAPPED window-78 endpoint g_b78) and gB79Lo = 300017570662988/100 (the STANDARD lower bound on the NON-SNAPPED window-79 endpoint g_b79 = 3 000 175 706 629.8801763284870433030491224869348413451796710703367576655864468193612992763519287109375). -/
theorem gB78Lo_lt_gB79Lo : (gB78Lo : ℝ) < (gB79Lo : ℝ) := by
  norm_num [CE78.gB78Lo, gB79Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 78 FULL slice (re-cited in the W79 band - window 78 of 80, full union (gB77, gB78] = the recorded window, width 19 999 [SNAPPED - the second snap in the series, after W1; the requested endpoint was NOT a good Gram point at working precision and b was snapped down by 1], certified 2026-11-12, RECORDED rescue window - ONE recorded interior Rosser failure block, ultimately DETERMINED (rescue quota-met on the union, determined in the certificate - RECORDED, not suppressed): naive block [12 363 155 005 877, 12 363 155 005 879] (need = 2, changes = 0, points = 129, m = 64), union [12 363 155 005 875, 12 363 155 005 880], need = 5, found = 5, m = 8; end Rosser runs 51 / 49, K = 12; zero cross-check failures (33 330 records), zero undetermined Gram signs): the b - a = 19 999 zeros of zeta with gB77 (' + GB77 + ', the W77 endpoint) < Im s <= gB78 (' + GB78 + ', the W78 endpoint, + or - 1.29e-26) are all simple and on the line. Provenance: window78_b78.json (Murphy pipeline; M = 60, C_R = 1, N_range = [691 008, 691 008], 33 330 evals in 2 408.7 s, 32 workers, resumed_from_cache = 404 095); verifier CERTIFIED (points 33 330, sign_changes_inside = 19 999, roser_failures_inside = 1, turing_ok, K_conservative = 12, end runs 51/49). SEAM: its g_a ball is the CE77 g_b ball EXACTLY (bit-identical tuple). Window-78 data per 0387 (unit 101); no RH CLAIM about window 78 or its Rosser/snap records. -/
def ce78WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB77Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB78Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 79 TERMINAL slice (re-cited - window 79 of 80, the (gB78, g_b79] portion of the recorded window, up to floor(gB79) - NON-SNAPPED: the requested width 20 000 was delivered in full): the zeros of zeta with gB78 (' + GB78 + ', = window 78's endpoint, + or - 1.29e-26) < Im s <= int(gB79) = 3 000 175 706 629 (the FLOOR - the endpoint g_b79 = ' + GB79 + ' sits 0.880176328487043... above it, robust to the 1.29e-26 radius) are all simple and on the line. Certificates: window79_b79.json (window 79's, NON-SNAPPED width 20 000, certified 2026-11-12, pipeline data) + the pipeline verifier (CERTIFIED, roser_failures_inside = 1 - W79's ONE recorded interior Rosser failure block [12 363 155 018 346, 12 363 155 018 348], ultimately DETERMINED: rescue quota-met on the union [12 363 155 018 345, 12 363 155 018 349], need = 4, found = 4, m = 4 - RECORDED, not suppressed; end Rosser runs 46 / 48, K_conservative = 12; 33 991 records, 0 cross-check failures, 0 undetermined Gram signs) + the CE79 header (M = 60, C_R = 1, N_range = [691 008, 691 008], 32 workers, 33 991 evals in 2 493.2 s, thirteenth overlap run, and the bit-identical g_a79 == g_b78 SEAM AUDIT). Slice restriction (gB78, int(gB79)] is a SUBSET of the certified window, so its zeros inherit on-linedness; no RH CLAIM about the face above g_b79. -/
def ce79WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB78Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE79 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h80 (window 79 contributes ONE clause for its (gB78, g_b79] portion - h80; W79 NON-SNAPPED, width 20 000; the W79 Rosser record: one recorded interior failure, ultimately determined quota-met - recorded, not suppressed), ALL zeros of zeta with Im s > WinC.tPT2 and Im s <= (tCE79 : R) lie on the line: h1-h2 cover window 1 (CE2, the Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42 (CE2-CE42), h44b fills the W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..79 enter as their certified (gB-prev, gB] slices (clause per re-cited slice - the slices are bit-identical at every seam, so the re-cited clause is exactly the recorded window's data; the re-cited full-slice clause carries the full recorded window) - windows 53..79 carry the recorded Rosser-rescue records (W53, W54, W66, W69, W70, W73, W76, W77: one recorded failure each; W78: SNAPPED 19 999 with one recorded failure; W79: one recorded failure - all ultimately determined) - and h80 carries the window-79 (gB78, g_b79] slice (NON-SNAPPED 20 000; the ONE recorded interior Rosser failure is ultimately determined quota-met - recorded, not suppressed). NO RH CLAIM about Im s > tCE79. -/
theorem bandOfWindows79 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : ce78WinClauseFull) (h80 : ce79WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE79 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                              · exact h80 ρ hz (not_le.mp hseam79) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 99-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE79 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..hW80 : the 80 verified window-slice clauses - the cited W43-W44B..W53, W55-W65, W67-W68, W71-W72, W74-W75 slices + the RE-CITED full slices for the re-anchored windows 43..79 (bit-identical seams, recorded data) incl. the W77/W78/W79 Rosser records + hW80 : the window-79 terminal slice). This is the finite-height closure through the corrected w1-w79 band (W42b fill) re-anchored to all of the certified SEVENTY-NINTH window (NON-SNAPPED 20 000; one recorded interior Rosser failure, ultimately determined quota-met); census 1 599 985 over (g_a1, g_b79] - 15 short of the 1 600 000 certified-zero mark (crossing FORCED at window 80). NO RH CLAIM about the face above tCE79. -/
theorem allOnLineUpToCE79 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : ce78WinClauseFull) (hW80 : ce79WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE79 : ℝ) := by
  have hband := bandOfWindows79 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE SEVENTY-NINTH RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the SEVENTY-NINTH certified window (NON-SNAPPED, width 20 000; census 1 599 985 over (g_a1, g_b79] - 15 short of the 1 600 000 certified-zero mark, EXACTLY as 0387 predicted; the W80 census crossing is arithmetically forced) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE79 : R) = 3 000 175 706 629 lies on the line - i.e. the absolute clause [S1] / A1 (no data-dependent bound on the S-at-zeros / DN walk) above the new lower bound. The 373 829-unit window over the H0 frontier is carried (the 350 000-unit mark carries with margin 23 829, CROSSED in WINDOW 74, first prediction delivered exactly; the 375 000 round mark is 1 171 ahead - the W80 crossing is ARITHMETICALLY FORCED, margin ~3 500). The increment series w77 -> w78 -> w79 reads 4 673, 4 672 [SNAP], 4 673; the four 4 672 occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]); no pattern claim (floor/snap artifact data points). WINDOW 80 IS THE DOUBLE-CONVERGENCE WINDOW (375 000 unit + 1 600 000 census) - the W76-W78 prediction now FORCED BY ARITHMETIC. The face does not shrink by 20 000 - it is RE-ANCHORED (and the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE79 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE79 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE75 -> tCE76 -> ... -> tCE78 -> tCE79) leaves the face IMPLICATOR - anything true above tCE78 is true above tCE79. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE78_implies_faceCE79 (q : ZeroSet)
    (hface : CE78.terminalFaceCE78 q) :
    terminalFaceCE79 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE78_lt_tCE79, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW79, hW80): terminalFaceCE79 q <-> terminalFaceCE78 q. The re-anchor adds no strength and loses none - what was open at tCE78 is (exactly) what is open at tCE79, and the slice family (gB78Lo, tCE79] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE78 pattern). The forward direction splits on 'Im s <= tCE79': the band slice (gB78Lo, tCE79] is handled by the verified window slices hW79, hW80 (the W79 slice is NON-SNAPPED 20 000; its one recorded interior Rosser failure is ultimately determined quota-met), the part above tCE79 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE79_iff_faceCE78 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW79 : ce78WinClauseFull) (hW80 : ce79WinClause) :
    terminalFaceCE79 q ↔ CE78.terminalFaceCE78 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE79 : ℝ)
    · by_cases hseam79 : ρ.im ≤ (gB78Lo : ℝ)
      · exact hW79 ρ (hqz ρ hρ) (by linarith [ht, CE78.gB77Lo_lt_tCE78, tCE78_lt_tCE79]) hseam79
      · exact hW80 ρ (hqz ρ hρ) (not_le.mp hseam79) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE78_implies_faceCE79 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE79) x (terminalFaceCE79 q) - finite-height closure (now through the corrected w1-w79 band with the W42b fill, re-anchored windows 53..79 all bit-identical at their seams; window 79 certified NON-SNAPPED at 20 000 with ONE recorded interior Rosser failure, ultimately determined quota-met) AND the absolute clause above tCE79. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE79 - tPT2 = 373 829 - the 350 000-unit mark carried with margin 23 829; census 1 599 985 - 15 short of 1 600 000; the 375 000 round mark and the 1 600 000 certified-zero mark cross TOGETHER at window 80 - arithmetically FORCED). -/
theorem rh_split_at_CE79 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE79 : ℝ) ∧ terminalFaceCE79 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE79 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE79 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE79): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW80 : the 80 verified window-slice clauses - windows 1..79, incl. the re-anchored 53..79 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77: one recorded failure each; W78: SNAPPED 19 999, one recorded failure; W79: one recorded failure - all ultimately determined) and the W79 terminal slice), RH is equivalent to the NAMED terminal face above tCE79 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w79 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..79, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE79 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : ce78WinClauseFull) (hW80 : ce79WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE79 q := by
  have hcensus := allOnLineUpToCE79 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hqz
  have hsplit := rh_split_at_CE79 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE79 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : ce78WinClauseFull) (hW80 : ce79WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE79 q) :
    RH q :=
  (rh_reanchored_CE79 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE79_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE79 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE79