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
import RhAttack.CE80
import RhAttack.CE81
import RhAttack.CE82

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82
open scoped Topology

/-!
**CE83 — the terminal face re-anchored at the EIGHTY-THIRD certified window
(0394, option B, unit 108 - lane M5).

MILESTONE STATE: tCE83 - tPT2 = 392 521 - the 375 000 UNIT MILESTONE
(crossed in WINDOW 80 at 378 502, margin 3 502 [0389] - the second
prediction of the series, ACHIEVED) CARRIES with margin 17 521; the 350
000-unit mark (crossed WINDOW 74 [0380], first prediction, delivered
exactly) CARRIES with margin 42 521; the 325 000 and 300 000 marks carry
with margins 67 521 and 92 521. Next round mark 400 000: 7 479 ahead
(~1.6 windows at the ~4 673 pace - predicted at window 85 still; compute
from the decoded endpoint, do not pre-announce; the W83 frontier HIT THE
w83 PROJECTION 392 521 RECORDED in the CE82 header EXACTLY, and the w84
projection 397 194 remains below 400 000, so W85 remains the crossing
window absent snaps). Round-mark sequence above H0: 100 000 @ CE22, 125
000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @
CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69,
350 000 @ CE74, 375 000 @ CE80 (all CROSSEDS PROVEN IN TREE); 400 000 @
~CE85 (predicted). CERTIFIED-ZERO CENSUS: cumulative total 1 679 984 over
(g_a1, g_b83] - the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 80
[0389] at 1 619 985, margin 19 985 - the first census mark, and the
double-convergence partner of the 375 000 unit milestone) CARRIES with
margin 79 984; the 1 500 000 mark carries margin 179 984; the 1 700 000
mark is 20 016 ahead (one full non-snapped window lands 16 SHORT at
1 699 984 - predicted crossing window 85 absent snaps; compute, do not
pre-announce).

WINDOW 83: NON-SNAPPED (b requested = b actual = 12 363 155 117 114;
certified width 20 000). RESCUE WINDOW - THREE recorded Rosser failure
blocks, all ultimately DETERMINED (rescue quota-met on the unions,
determined in the certificate - RECORDED, not suppressed): block 1 naive
[12 363 155 097 880, 12 363 155 097 882] (need = 4, found = 4, m = 16),
union [12 363 155 097 879, 12 363 155 097 883]; block 2 naive [12 363
155 110 800, 12 363 155 110 802] (need = 6, found = 6, m = 4), union
[12 363 155 110 799, 12 363 155 110 805]; block 3 (PAST b - OUTSIDE the
[g_a83, g_b83] interior count, in the run's tail region) naive [12 363
155 117 156, 12 363 155 117 159] (need = 10, found = 10, m = 4), union
[12 363 155 117 153, 12 363 155 117 163]. roser_failures_inside = 2.
End Rosser runs: 48 left of g_a83, 36 right of g_b83 (both >= K = 12);
0 cross-check failures (all 34 168 records); 0 undetermined Gram signs.
INCREMENT: 4 673 (the usual step, non-snapped; the increment series
w76 -> w83 now reads 4 673, 4 672 [SNAP], 4 673, 4 673, 4 673, 4 673,
4 673 - the four 4 672 occurrences remain the four INCREMENT values
recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78); no pattern
claimed). Census: the full non-snapped width adds 20 000 zeros
(1 659 984 + 20 000 = 1 679 984).

PIPELINE RUN (eighteenth in the overlap pipeline): seed cache (window
82's cache copied in before launch - resumed_from_cache = 571 877,
logged for provenance) + 32 workers: 34 168 evaluations in 2 571.1 s
(series so far: ... / 2 593.6 / 2 639.7 / 2 571.1 - the count moved, the
certification content did not: same M = 60, C_R = 1, N_range = [691
008, 691 008], same pipeline, same verifier, same seam discipline).
Window 83 RAN WHILE the S1Point point-scale RvM unit reached machine-
checked green (point_rvM: |Ncount 4 T - f_pt T| <= C * log T at good
heights under C9 - the wire's analytic input) together with the
hidden-defect repair batch across the Ap* family and the BUsq
Borsuk-Ulam route-kill audit (0393, unit 107) landed - the per-unit
critical path is max(run, formalization); window 84 will be launched
with the W83 seam already audited.

PROVENANCE (our run, 2026-11-13; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE82): RUN PARAMETERS: a = 12 363 155 097 114 (= b82), b
requested = b actual = a + 20 000 = 12 363 155 117 114, M = 60, C_R = 1,
32 workers, 34 168 evaluations, 2 571.1 s, resumed_from_cache = 571 877
(seeded from window82_b82.json.cache.jsonl). CERTIFICATE
(window83_b83.json): the 20 000 (= b - a) zeros of zeta with g_a83
< Im s <= g_b83 are ALL SIMPLE and on the line, where g_a83 (recorded
exact dyadic ball) = 116063676546330893270056314737404147635 x 2^-85
with radius 16777217 x 2^-110 (i.e. 3 000 175 720 648.4518695961402317031720884521342180314461083566468513339486889890395104885101318359375, the W82 endpoint, + or - 1.29e-26) and this ball is
BIT-IDENTICAL to CE82's recorded g_b82 (exact dyadic tuple comparison,
2026-11-13 - audit PERFORMED BEFORE this module was written, per the
0348 process rule); g_b83 = 3 000 175 725 321.3869823959479319585248033499338895828268260028426350771724173682741820812225341796875 + or - 1.29e-26 (exact dyadic tuple
[116063676727106314429975903822503861247, -85, 16777217, -110]; the
endpoint ball stays NORMALIZED at exponent -85 - the normalization
sequence in the series so far: -86 (..g_b78), -85 (g_b79), -84 (g_b80),
-85 (g_b81), -85 (g_b82), -85 (g_b83); the exact dyadic tuple is
authoritative over the exponent representation). The floor tCE83 sits
0.3869823959479319585248033499338895828268260028426350771724173682741820812225341796875
below the endpoint g_b83 - robust to the 1.29e-26 radius by many orders
of magnitude; the standard two-decimal lower bound gB83Lo (3 000 175
725 321.38) has the exact margin 0.00698239594793195852480333700919174131379082808253304118807075... (integer-tuple
arithmetic, conservative center-minus-radius reading); the two-decimal
round-down (0.38) does not equal the floor, so no CASING is needed -
window 38 / CE38 remains the only CASING case so far. (The gB83Lo
margin is thin - 6.98e-3 - the fourth such case after W79 (1.76e-4),
W81 (4.03e-4) and W82 (1.87e-3); cent-granularity luck of the endpoint;
not by any precision danger: the certified radius is 1.29e-26, eight
orders of magnitude smaller; no pattern claimed on thin margins.)

VERIFICATION (three layers, same as CE2-CE82): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window83_b83.json: "CERTIFIED: true",
points_checked = 34 168, sign_changes_inside = 20 000 (= b - a, the
full width), roser_failures_inside = 2 (RESCUE - both interior blocks
ultimately determined, quota-met on the unions; RECORDED, not
suppressed; plus one further recorded block past b, outside the
interior count), turing_ok = true, K_conservative = 12, end Rosser runs
48 / 36, max_phase_contribution_4sqrtN_rad_theta = [4.10e-21, radius
2.61e-24], endpoints recomputed and matched; (3) SEAM AUDIT (this run):
the recorded g_a83 ball is bit-identical to CE82's recorded g_b82 ball
(exact dyadic decode, 2026-11-13). FRONTIER ARITHMETIC (machine,
below): tCE83 = 3 000 175 725 321, tCE83 - tCE82 = 4 673, tCE83 -
tPT2 = 392 521 (375 000 mark Carries with margin 17 521; 400 000 is
7 479 ahead). HONESTY (trust base): as CE2-CE82 - the pipeline's own
controls, its kernel-checked Lean remainder theorem, and our three
verification layers; a RE-RUN of a third-party pipeline, not a from-
scratch independent certification; the Rosser exceptions are RECORDED,
not suppressed (three blocks occurred in this window, all ultimately
determined - recorded above and in the certificate). Cumulative
certified count = 1 679 984 over (g_a1, g_b83] (pipeline data, not
in-tree arithmetic). NO RH CLAIM.
-/
namespace CE83


/-! ### 1.  The  certified  constants
-/
/-- STANDARD TWO-DECIMAL CERTIFIED LOWER BOUND ON THE CERTIFIED g_b83 (machine): gB83Lo = 3 000 175 725 321.38 = 300017572532138/100 - the two-decimal round-down of the certified lower bound (the endpoint g_b83 '3 000 175 725 321.3869823959479319585248033499338895828268260028426350771724173682741820812225341796875' minus the certified radius 1.29e-26). The margin is the exact 0.006982395948... - THIN by cent-granularity luck of the endpoint (fourth such case after W79 (1.76e-4), W81 (4.03e-4) and W82 (1.87e-3); not a precision danger - the certified radius is 1.29e-26, eight orders of magnitude smaller); no CASING is needed (the two-decimal round-down 0.38 does not equal the floor - window 38 / CE38 remains the only CASING case; no pattern claimed on thin margins). -/
def gB83Lo : ℚ := 300017572532138 / 100

/-- THE NEW LOWER BOUND (machine): 3 000 175 725 321 = floor(g_b83) = int(3 000 175 725 321.38698239...). The endpoint sits 0.38698239... above the integer boundary and the certified radius is 1.29e-26, so the floor is robust by many orders of magnitude. tCE83 - tCE82 = 4 673 (the usual step; W83 NON-SNAPPED - the increment series w76 -> w77 -> w78 -> w79 -> w80 -> w81 -> w82 -> w83 now reads 4 673, 4 672 [SNAP], 4 673, 4 673, 4 673, 4 673, 4 673 - the four 4 672 INCREMENT occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]) - no pattern claim). -/
def tCE83 : ℕ := 3000175725321

theorem tCE83_lt_gB83Lo : (tCE83 : ℝ) < (gB83Lo : ℝ) := by
  norm_num [gB83Lo, tCE83]

theorem tCE82_lt_tCE83 : (tCE82 : ℝ) < (tCE83 : ℝ) := by
  norm_num [CE82.tCE82, tCE83]

/-- ORDERING (machine, norm_num): (gB82Lo : R) < (tCE83 : R), with gB82Lo = 300017572064845/100 (the STANDARD lower bound introduced at CE82) and tCE83 = 3000175725321. So the window-83 terminal slice starts strictly below the new floor. -/
theorem gB82Lo_lt_tCE83 : (gB82Lo : ℝ) < (tCE83 : ℝ) := by
  norm_num [CE82.gB82Lo, tCE83]

/-- THE FACE SHRINK - THIS UNIT (machine, norm_num): tCE83 - tCE82 = 4 673. THE USUAL STEP, NON-SNAPPED: W83 ran at full width (b requested = b actual = 12 363 155 117 114, certified width 20 000) and the RESCUE status (three recorded Rosser failure blocks - two interior, one past b - all ultimately determined) does not change the endpoint. The increment series w76 -> w83 now reads 4 673, 4 672 [SNAP], 4 673, 4 673, 4 673, 4 673, 4 673; the four 4 672 INCREMENT occurrences remain the four recorded (w45 -> w46, w53 -> w54, w65 -> w66, w77 -> w78 [SNAP]); no pattern claimed (floor/snap artifact data points). -/
theorem faceShrinkCE83 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := by
  norm_num [tCE83, CE82.tCE82]

/-- FRONTIER STATE (machine): the terminal face now sits (tCE83 : R) - WinC.tPT2 = 3 000 175 725 321 - 3 000 175 332 800 = 392 521 above the H0 frontier WinC.tPT2 - the 375 000 UNIT MILESTONE (CROSSED in WINDOW 80 at 378 502, margin 3 502 - the SECOND PREDICTION of the series ACHIEVED [0389]) CARRIES with margin 17 521. The 350 000 mark (crossed WINDOW 74 [0380], first prediction, delivered exactly) CARRIES margin 42 521; the 325 000 / 300 000 marks carry 67 521 / 92 521. The W83 frontier HIT THE w83 PROJECTION 392 521 RECORDED in the CE82 header EXACTLY. The next round mark 400 000 is 7 479 ahead (~1.6 windows at the ~4 673 pace - predicted at window 85 still; the w84 projection 397 194 remains below 400 000). CERTIFIED-ZERO CENSUS: cumulative total 1 679 984 over (g_a1, g_b83] - the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 80 [0389] at 1 619 985, margin 19 985 - the first census mark; double-convergence partner of the 375 000 unit milestone) CARRIES margin 79 984; the 1 500 000 mark carries 179 984; the 1 700 000 mark is 20 016 ahead (one full non-snapped window lands 16 SHORT at 1 699 984 - predicted crossing window 85 absent snaps; compute from the decoded endpoint, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE83 : ℝ) - WinC.tPT2 = 392521 := by
  norm_num [tCE83, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 200 000-unit milestone (CROSSED in WINDOW 42B at 200 823, margin 823) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 200 000, margin 192 521. CARRIED INTO WINDOW-83: the face has since crossed 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast200k : (tCE83 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 175 000-unit milestone (CROSSED in WINDOW 38 at 175 404, margin 404) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 175 000. CARRIED INTO WINDOW-83: the face has since crossed every round mark up to 375 000 @ CE80 (margin 3 502 - the second prediction, ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast175k : (tCE83 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 225 000-unit milestone (CROSSED in WINDOW 48 at 225 364, margin 364) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 225 000, margin 167 521. CARRIED INTO WINDOW-83: the face has since crossed 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast225k : (tCE83 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 250 000-unit milestone (CROSSED in WINDOW 53 at 250 944, margin 944) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 250 000, margin 142 521. CARRIED INTO WINDOW-83: the face has since crossed 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast250k : (tCE83 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 275 000-unit milestone (CROSSED in WINDOW 58 at 275 088, margin 88) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 275 000, margin 117 521. CARRIED INTO WINDOW-83: the face has since crossed 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast275k : (tCE83 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 300 000-unit round mark (CROSSED in WINDOW 64 at 300 972, margin 972) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 300 000, margin 92 521. CARRIED INTO WINDOW-83: the face has since crossed 325 000 @ CE69, 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast300k : (tCE83 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN - norm_num + linarith): the 325 000-unit milestone (CROSSED in WINDOW 69 at 327 100, margin 2100 - predicted one window ahead and delivered exactly [0375]) is STILL strictly exceeded at the WINDOW-83 lower bound - (tCE83 : R) - WinC.tPT2 = 392 521 > 325 000, margin 67 521. CARRIED INTO WINDOW-83: the face has since crossed 350 000 @ CE74 (margin 465), 375 000 @ CE80 (margin 3 502 - ACHIEVED); the 400 000 round mark is 7 479 ahead. -/
theorem frontierPast325k : (tCE83 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-83 - tCE83 - tPT2 = 392 521 exceeds 350 000 with margin 42 521. This statement is proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, so the crossing record stays true at the new frontier. -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  have hshrink1 : (tCE83 : ℝ) - (tCE82 : ℝ) = 4673 := faceShrinkCE83
  have hshrink2 : (tCE82 : ℝ) - (tCE81 : ℝ) = 4673 := CE82.faceShrinkCE82
  have hshrink3 : (tCE81 : ℝ) - (tCE80 : ℝ) = 4673 := CE81.faceShrinkCE81
  have hshrink4 : (tCE80 : ℝ) - (tCE79 : ℝ) = 4673 := CE80.faceShrinkCE80
  have hshrink5 : (tCE79 : ℝ) - (tCE78 : ℝ) = 4673 := CE79.faceShrinkCE79
  have hshrink6 : (tCE78 : ℝ) - (tCE77 : ℝ) = 4672 := CE78.faceShrinkCE78
  have hshrink7 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := CE77.faceShrinkCE77
  have hshrink8 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink9 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3, hshrink4, hshrink5, hshrink6, hshrink7, hshrink8, hshrink9]
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN - norm_num + linarith): the 375 000 UNIT MILESTONE was CROSSED in WINDOW 80 (at 378 502, margin 3 502 - the SECOND PREDICTION of the series ACHIEVED: 0388 predicted required increment 1 172, margin ~3 500, frontier 378 502 - all hit exactly; the 1 600 000 CERTIFIED-ZERO MARK crossed in the same window, census 1 619 985, margin 19 985 - the DOUBLE CONVERGENCE [0389]); CARRIED into WINDOW-83 - tCE83 - tPT2 = 392 521 exceeds 375 000 with margin 17 521. The next round mark 400 000 is 7 479 ahead (~1.6 windows - predicted at window 85 absent snaps; compute from the decoded endpoint, do not pre-announce). -/
theorem frontierPast375k : (tCE83 : ℝ) - WinC.tPT2 > 375000 := by
  have h : (tCE83 : ℝ) - WinC.tPT2 = 392521 := frontierGapAboveH0
  linarith [h]

/-- ORDERING (machine, norm_num): (gB82Lo : R) < (gB83Lo : R) - the standard lower bounds rise strictly across the re-anchor, with gB82Lo = 300017572064845/100 (the STANDARD lower bound on the SNAPPED window-82 endpoint g_b82 = 3 000 175 720 648.4518695961402317031720884521342180314461083566468513339486889890395104885101318359375) and gB83Lo = 300017572532138/100 (the STANDARD lower bound on the NON-SNAPPED window-83 endpoint g_b83 = 3 000 175 725 321.3869823959479319585248033499338895828268260028426350771724173682741820812225341796875). -/
theorem gB82Lo_lt_gB83Lo : (gB82Lo : ℝ) < (gB83Lo : ℝ) := by
  norm_num [CE82.gB82Lo, gB83Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- WINDOW 82 FULL slice (re-cited in the W83 band - window 82 of 83, the full recorded window (gB81, g_b82], SNAPPED 19 999, RESCUE: TWO recorded interior Rosser failures, both ultimately DETERMINED [RECORDED, not suppressed]; end Rosser runs 48 / 50, K = 12; zero cross-check failures (34 249 records); zero undetermined Gram signs): the b - a = 19 999 zeros of zeta with gB81 ('3 000 175 720 648.4518695961402317031720884521342180314461083566468513339486889890395104885101318359375', the W81 endpoint, + or - 1.29e-26) < Im s <= gB82 ('3 000 175 720 648.4518695961402317031720884521342180314461083566468513339486889890395104885101318359375', the W82 endpoint, + or - 1.29e-26) are all simple and on the line. Provenance: window82_b82.json (Murphy pipeline; M = 60, C_R = 1, 32 workers, 34 249 evals in 2 639.7 s, 17th overlap run); verifier CERTIFIED (points 34 249, sign_changes_inside = 19 999, roser_failures_inside = 2, turing_ok, K_conservative = 12, end runs 48/50). SEAM: its g_a ball is the CE81 g_b ball EXACTLY (bit-identical tuple). Window-82 data per 0392 (unit 106); no RH CLAIM about window 82 or its rescue record. -/
def ce82WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB81Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB82Lo : ℝ) → ρ.re = 1 / 2

/-- WINDOW 83 TERMINAL slice (re-cited - window 83 of 83, the (gB82, g_b83] portion of the recorded window, up to floor(gB83) - NON-SNAPPED 20 000, RESCUE: THREE recorded Rosser failure blocks, ALL ultimately DETERMINED [RECORDED, not suppressed] - two interior (block 1 naive [12 363 155 097 880, 12 363 155 097 882]: need = 4, found = 4, m = 16, union [12 363 155 097 879, 12 363 155 097 883]; block 2 naive [12 363 155 110 800, 12 363 155 110 802]: need = 6, found = 6, m = 4, union [12 363 155 110 799, 12 363 155 110 805]) plus one PAST b (block 3 naive [12 363 155 117 156, 12 363 155 117 159]: need = 10, found = 10, m = 4, union [12 363 155 117 153, 12 363 155 117 163] - outside the [g_a83, g_b83] interior count)): the zeros of zeta with gB82 ('3 000 175 720 648.4518695961402317031720884521342180314461083566468513339486889890395104885101318359375', = window 82's endpoint, + or - 1.29e-26) < Im s <= int(gB83) = 3 000 175 725 321 (the FLOOR - the endpoint g_b83 = 3 000 175 725 321.3869823959479319585248033499338895828268260028426350771724173682741820812225341796875 sits 0.38698239... above it, robust to the 1.29e-26 radius) are all simple and on the line. Certificates: window83_b83.json (NON-SNAPPED 20 000; RESCUE - the three blocks above, quota-met, all determined; certified 2026-11-13) + the pipeline verifier (CERTIFIED, turing_ok, points 34 168, sign_changes_inside = 20 000, roser_failures_inside = 2, end Rosser runs 48 / 36, K_conservative = 12, 0 cross-check failures, 0 undetermined Gram signs) + the CE83 header (M = 60, C_R = 1, N_range = [691 008, 691 008], 32 workers, 34 168 evals in 2 571.1 s, eighteenth overlap run, resumed_from_cache = 571 877, and the bit-identical g_a83 == g_b82 SEAM AUDIT). Slice restriction (gB82, int(gB83)] is a SUBSET of the certified window, so its zeros inherit on-linedness; no RH CLAIM about the face above g_b83. -/
def ce83WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB82Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE83 : ℝ) → ρ.re = 1 / 2

/-- THE CORRECTED BAND (machine, data-dependent): with the cited slice clauses h1..h84 (window 83 contributes ONE clause for its (gB82, g_b83] portion - h84; W83 NON-SNAPPED 20 000, RESCUE - three recorded Rosser failure blocks, all ultimately determined), ALL zeros of zeta with Im s > WinC.tPT2 and Im s <= (tCE83 : R) lie on the line: h1-h2 cover window 1 (CE2, the Rosser-RESERVED slice + corrected full slice), h3-h44 cover windows 2..42, h44b fills the W1-W2 seam gap (tPT2, gB0], the re-anchored windows 43..83 enter as their certified (gB-prev, gB] slices (the slices are bit-identical at every seam; the re-cited full-slice clause carries the full recorded window) - windows 53..83 RE-CARRY the recorded Rosser-rescue records (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each, all ultimately determined; W78: SNAPPED 19 999 with one recorded failure; W82: SNAPPED 19 999 with two recorded failures, both determined; W83: NON-SNAPPED 20 000 with two recorded interior failures plus one recorded past-b failure, all determined) and windows 79..80 carry the W80 CLEAN record (zero failures, first since W74) - and h84 carries the window-83 (gB82, g_b83] slice. CUMULATIVE tally through window 83: 83 windows - 36 clean, 47 rescue; 70 total internal Rosser failures, ALL RECORDED. NO RH CLAIM about Im s > tCE83. -/
theorem bandOfWindows83 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : CE77.ce76WinClauseFull) (h78 : CE78.ce77WinClauseFull) (h79 : CE79.ce78WinClauseFull) (h80 : CE80.ce79WinClauseFull) (h81 : CE81.ce80WinClauseFull) (h82 : CE82.ce81WinClauseFull) (h83 : ce82WinClauseFull) (h84 : ce83WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE83 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                                · by_cases hseam81 : ρ.im ≤ (gB80Lo : ℝ)
                                                                                                                                                                  · exact h81 ρ hz (not_le.mp hseam80) hseam81
                                                                                                                                                                  · by_cases hseam82 : ρ.im ≤ (gB81Lo : ℝ)
                                                                                                                                                                    · exact h82 ρ hz (not_le.mp hseam81) hseam82
                                                                                                                                                                    · by_cases hseam83 : ρ.im ≤ (gB82Lo : ℝ)
                                                                                                                                                                      · exact h83 ρ hz (not_le.mp hseam82) hseam83
                                                                                                                                                                      · exact h84 ρ hz (not_le.mp hseam83) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE 83-WINDOW CENSUS (machine, from the band + WinC.allOnLineUpTo): all zeros of the (data-independent) zeta set q with Im s > WinC.tPT2 and Im s <= (tCE83 : R) lie on the line, given the zero-hypothesis (hZPT2 : zeros above tPT2; hqz : the set is a ZERO SET - every member is a zeta zero; hW1..hW84 : the 84 verified window-slice clauses - the cited slices + the RE-CITED full slices for the re-anchored windows 43..83 (bit-identical seams, recorded data) incl. the W53..W83 Rosser records + hW84 : the window-83 terminal slice (NON-SNAPPED 20 000, RESCUE, three recorded blocks, all determined)). This is the finite-height closure through the corrected w1-w83 band (W42b fill) re-anchored to all of the certified EIGHTY-THIRD window (NON-SNAPPED 20 000, RESCUE); census 1 679 984 over (g_a1, g_b83] - the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80 [0389]) carries margin 79 984; the 1 700 000 mark is 20 016 ahead. NO RH CLAIM about the face above tCE83. -/
theorem allOnLineUpToCE83 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : ce82WinClauseFull) (hW84 : ce83WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE83 : ℝ) := by
  have hband := bandOfWindows83 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE EIGHTY-THIRD RE-ANCHORED TERMINAL FACE (machine, the NAMED residual for the absolute clause, 0281 form - lane M5, the direct-attack reduction route (b)): what remains open at the EIGHTY-THIRD certified window (NON-SNAPPED 20 000, RESCUE - three recorded Rosser failure blocks, all determined; census 1 679 984 over (g_a1, g_b83]) is the assertion that every zeta zero of the (data-independent) zero set q with Im s > (tCE83 : R) = 3 000 175 725 321 lies on the line - i.e. the absolute clause [S1] / A1 (no data-dependent bound on the S-at-zeros / DN walk) above the new lower bound. Frontier 392 521 above H0: the 375 000 UNIT MILESTONE (CROSSED in W80, margin 3 502 - the second prediction, ACHIEVED at its predicted margin ~3 500) CARRIES with margin 17 521; the 350 000 mark carries 42 521; the next round mark 400 000 is 7 479 ahead (~1.6 windows - predicted at window 85 still; the w84 projection 397 194 remains below 400 000); the 1 600 000 CERTIFIED-ZERO MARK (CROSSED in W80, the double-convergence partner) carries margin 79 984; the 1 700 000 mark is 20 016 ahead (one full non-snapped window lands 16 short - around window 85). The increment series w76 -> w83 reads 4 673, 4 672 [SNAP], 4 673, 4 673, 4 673, 4 673, 4 673; the four 4 672 INCREMENT occurrences remain the four recorded; no pattern claim (floor/snap artifact data points). The face is RE-ANCHORED (the exact iff below proves no strength is lost). NO RH CLAIM: this is the open object, stated at the new frontier. -/
def terminalFaceCE83 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE83 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine, no data): shrinking the lower bound (tCE76 -> tCE77 -> ... -> tCE82 -> tCE83) leaves the face IMPLICATOR - anything true above tCE82 is true above tCE83. The re-anchor cannot help the face; only the band grows. (This is the 'no strength lost' direction, used by the iff below.) -/
theorem faceCE82_implies_faceCE83 (q : ZeroSet)
    (hface : CE82.terminalFaceCE82 q) :
    terminalFaceCE83 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE82_lt_tCE83, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW83, hW84): terminalFaceCE83 q <-> terminalFaceCE82 q. The re-anchor adds no strength and loses none - what was open at tCE82 is (exactly) what is open at tCE83, and the slice family (gB82Lo, tCE83] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE82 pattern). The forward direction splits on 'Im s <= tCE83': the band slice (gB82Lo, tCE83] is handled by the verified window slices hW83, hW84 (the W83 slice is NON-SNAPPED 20 000, RESCUE - three recorded blocks, all determined), the part above tCE83 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE83_iff_faceCE82 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW83 : ce82WinClauseFull) (hW84 : ce83WinClause) :
    terminalFaceCE83 q ↔ CE82.terminalFaceCE82 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE83 : ℝ)
    · by_cases hseam83 : ρ.im ≤ (gB82Lo : ℝ)
      · exact hW83 ρ (hqz ρ hρ) (by linarith [ht, CE82.gB81Lo_lt_tCE82, tCE82_lt_tCE83]) hseam83
      · exact hW84 ρ (hqz ρ hρ) (not_le.mp hseam83) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE82_implies_faceCE83 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q <-> (allOnLineUpTo q tCE83) x (terminalFaceCE83 q) - finite-height closure (now through the corrected w1-w83 band with the W42b fill, re-anchored windows 53..83 all bit-identical at their seams; window 83 certified NON-SNAPPED at 20 000, RESCUE - three recorded Rosser failure blocks, all ultimately determined) AND the absolute clause above tCE83. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE83 - tPT2 = 392 521 - the 375 000 UNIT MILESTONE carries margin 17 521 [crossed W80, second prediction ACHIEVED]; census 1 679 984 - the 1 600 000 CERTIFIED-ZERO MARK carries margin 79 984 [crossed W80]; the 1 700 000 mark is 20 016 ahead). -/
theorem rh_split_at_CE83 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE83 : ℝ) ∧ terminalFaceCE83 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE83 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE83 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED RH (machine, the 0288 form at tCE83): assuming the zero-hypothesis (hZPT2 : all zeros of the set above tPT2; hqz : the SET is a ZERO SET - every member is a zeta zero; hW1..hW84 : the 84 verified window-slice clauses - windows 1..83, incl. the re-anchored 53..83 with recorded Rosser-rescue data (W53, W54, W66, W69, W70, W73, W76, W77, W79, W81: one recorded failure each - all ultimately determined; W78: SNAPPED 19 999, one recorded failure; W82: SNAPPED 19 999, two recorded failures - both determined; W83: NON-SNAPPED 20 000, three recorded blocks - all determined) and the W83 terminal slice (NON-SNAPPED, three recorded blocks, all determined)), RH is equivalent to the NAMED terminal face above tCE83 - the finite-height part is DISCHARGED by the cited window data (the corrected w1-w83 band: window 1 [CE2, Rosser-RESERVED slice + corrected full slice], windows 2..42 [CE2-CE42], the W1-W2 seam gap (tPT2, gB0] by the W42b fill, and the re-anchored (gB-prev, gB] slices for windows 43..83, all of them bit-identical at their seams). This is the direct-attack reduction: RH is a finite verified census (machine-auditable) AND one named absolute clause. NO RH CLAIM. -/
theorem rh_reanchored_CE83 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : ce82WinClauseFull) (hW84 : ce83WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE83 q := by
  have hcensus := allOnLineUpToCE83 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hqz
  have hsplit := rh_split_at_CE83 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE83 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : ce82WinClauseFull) (hW84 : ce83WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE83 q) :
    RH q :=
  (rh_reanchored_CE83 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE83_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE83 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE83