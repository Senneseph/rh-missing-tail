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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76
open scoped Topology

/-!
**CE77 — the terminal face re-anchored at the SEVENTY-SEVENTH certified window
(0385, option B, unit 99 - lane M5).

MILESTONE STATE: tCE77 - tPT2 = 364 484 - the 350 000 UNIT MILESTONE
CARRIES with margin 14 484 (crossed in WINDOW 74 at 350 465, margin 465
[0380] - the FIRST PREDICTION of the series, delivered exactly); the 325
000-unit mark CARRIES (margin 39 484; crossed in WINDOW 69 [0375]); the
300 000-unit mark CARRIES (margin 64 484; crossed in WINDOW 64 [0370]).
The next round mark 375 000 sits 10 516 ahead (10 516 / 4 673 ~ 2.25: w78
-> 369 157, w79 -> 373 830, w80 -> 378 503) - crossing expected at window
80, margin ~3 503 (compute from the decoded endpoint, do not pre-announce).
Round-mark sequence above H0: 100 000 @ CE22, 125 000 @ CE27, 150 000 @
CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53,
275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @ CE74 (CARRIED),
375 000 @ ~CE80 (predicted). CERTIFIED-ZERO CENSUS: cumulative total
1 559 986 over (g_a1, g_b77] - the 1 500 000 CERTIFIED-ZERO MARK (CROSSED
in WINDOW 75 [0381] at 1 519 986, margin 19 986) CARRIES with margin
59 986. The 1 600 000 mark is 40 014 ahead (w78 -> 1 579 986, w79 ->
1 599 986 [14 short], w80 -> 1 619 986) - crossing expected at window 80
(compute, do not pre-announce). WINDOW 80 IS THE CONVERGENCE POINT OF
BOTH NEXT MARKS (375 000 unit + 1 600 000 census), unchanged from the
W76 prediction.

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 ->
w45 -> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55
-> w56 -> w57 -> w58 -> w59 -> w60 -> w61 -> w62 -> w63 -> w64 -> w65 ->
w66 -> w67 -> w68 -> w69 -> w70 -> w71 -> w72 -> w73 -> w74 -> w75 ->
w76 -> w77, every seam bit-identical (window 77 launched from b76; the
seam audit passed bit-identically BEFORE this module was written, per the
0348 process rule - and BEFORE window 78 will be launched in the pipeline,
see below).

WINDOW 77: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS
a good Gram point at working precision). RESCUE WINDOW - one recorded
interior Rosser failure block, ultimately DETERMINED (rescue quota-met on
the union, determined in the certificate - RECORDED, not suppressed):
block [12 363 154 988 233, 12 363 154 988 235], union [12 363 154 988
231, 12 363 154 988 236] with need = 5, found = 5, m = 2;
rosser_failures_inside = 1. End Rosser runs: 45 left of g_a77, 51 right of
g_b77 (both >= K = 12); 0 cross-check failures (all 34 053 records); 0
undetermined Gram signs. INCREMENT: 4 673 (the usual increment; the 4 672
occurrences remain the three recorded ones, w45 -> w46 / w53 -> w54 /
w65 -> w66 - no pattern).

PIPELINE RUN (eleventh in the overlap pipeline): seed cache (window 76's
cache copied in before launch - resumed_from_cache = 370 213, logged for
provenance) + 32 workers: 34 053 evaluations in 2 478.0 s (series:
2 497.2 / 2 498.3 / 2 498.5 / 2 490.4 / 2 483.4 / 2 375.0 / 2 459.6 /
2 490.2 / 2 387.5 / 2 437.1 / 2 478.0 - the count moved, the certification
content did not: same M = 60, C_R = 1, N_range = [691 008, 691 008], same
pipeline, same verifier, same seam discipline). Window 77 RAN WHILE
CE76's formalization proceeded, and window 78 will be launched with the
W77 seam already audited - the per-unit critical path is max(run,
formalization).

PROVENANCE (our run, 2026-11-12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE76): RUN PARAMETERS: a = 12 363 154 977 116 (= b76),
b requested = a + 20 000 = 12 363 154 997 116, b ACTUAL = 12 363 154
997 116 (NON-SNAPPED), M = 60, C_R = 1, 32 workers, 34 053 evaluations,
2 478.0 s, resumed_from_cache = 370 213 (seeded from
window76_b76.json.cache.jsonl). CERTIFICATE (window77_b77.json): the
b - a = 20 000 zeros of zeta with g_a77 < Im s <= g_b77 are ALL SIMPLE
and on the line, where g_a77 (recorded exact dyadic ball) =
232127350923392887265567312711530165167 x 2^-86 with radius 16777217 x
2^-110 (i.e. 3 000 175 692 611.30848062503887734935769803207794206018399810718955134092311709537170827388763427734375, the W76 endpoint, + or - 1.29e-26) and this ball is BIT-IDENTICAL to CE76's recorded g_b76
(exact dyadic tuple comparison, 2026-11-12 - audit PERFORMED BEFORE this
module was written); g_b77 = 3 000 175 697 284.24359504873695940774610159056716558631552047888002565656506703817285597324371337890625 + or - 1.29e-26 (exact dyadic
tuple [232127351284943729711048923572004665785, -86, 16777217, -110]).
The floor tCE77 sits 0.24359504873695940774610159056716558631552047888002565656506703817285597324371337890625 below the endpoint g_b77 - robust to the 1.29e-26 radius by many orders of magnitude; the standard two-decimal lower bound gB77Lo (3 000 175 697 284.24) has a margin of 0.0035950 (exact margin 0.0035950487369594076, the usual cent granularity); the two-decimal round-down (0.24) does not equal the floor, so no CASING is needed - window 38 / CE38 remains the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE76): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2)
PIPELINE VERIFIER on window77_b77.json: "CERTIFIED: true",
points_checked = 34 053, sign_changes_inside = 20 000 = b - a,
rosser_failures_inside = 1 (RESCUE - the single block ultimately
determined, quota-met on the union; RECORDED, not suppressed),
turing_ok = true, K_conservative = 12, end Rosser runs 45 / 51, endpoints
recomputed and matched (verifier wall clock < 1 s: it re-derives from the
recorded exact dyadic enclosures); (3) SEAM AUDIT (this run): the recorded
g_a77 ball is bit-identical to CE76's recorded g_b76 ball (exact dyadic
decode, 2026-11-12). FRONTIER ARITHMETIC (machine, below): tCE77 =
3 000 175 697 284, tCE77 - tCE76 = 4 673, tCE77 - tPT2 = 364 484 (350 000
mark carries with margin 14 484). HONESTY (trust base): as CE2-CE76 - the
pipeline's own controls, its kernel-checked Lean remainder theorem, and
our three verification layers; a RE-RUN of a third-party pipeline, not a
from-scratch independent certification; the Rosser exceptions are
RECORDED, not suppressed (one occurred in this window, ultimately
determined - recorded above and in the certificate). Cumulative certified
count = 1 559 986 over (g_a1, g_b77] (pipeline data, not in-tree
arithmetic): the 1 500 000 mark CARRIES (margin 59 986, crossed in WINDOW
75); the 1 600 000 mark is 40 014 ahead (window 80 expected). NO RH
CLAIM.
-/
namespace CE77


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b77 (the recorded ball is 3 000 175 697 284.24359504873695940774610159056716558631552047888002565656506703817285597324371337890625 with radius ~= 1.29e-26, exact dyadic tuple [232127351284943729711048923572004665785, -86, 16777217, -110]; this rational rounds the bottom down at two decimals, margin ~3.6e-3 (exact margin 0.0035950487369594076) - the usual cent granularity; the inequality gB77Lo < g_b77 is an EXACT rational comparison (norm_num), no floating point; the fractional part 0.2435950487369594... is robust to the 27-order radius, and the two-decimal round-down (0.24) does not equal the floor, so no CASING is needed - window 38 / CE38 remains the only CASING case; window 77 is NON-SNAPPED with width b - a = 20 000 and is a RESCUE WINDOW - one recorded interior Rosser failure block, ultimately determined (rescue quota-met, RECORDED, not suppressed) (see the header). -/
def gB77Lo : ℚ := 300017569728424 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB77Lo: tCE77 = 3 000 175 697 284 (the certified floor at the end of window 77; g_b77 has fractional part 0.2435950487369594..., so the floor cannot move at 1.29e-26 radius). -/
def tCE77 : ℕ := 3000175697284

theorem tCE77_lt_gB77Lo : (tCE77 : ℝ) < (gB77Lo : ℝ) := by
  norm_num [gB77Lo, tCE77]

theorem tCE76_lt_tCE77 : (tCE76 : ℝ) < (tCE77 : ℝ) := by
  norm_num [CE76.tCE76, tCE77]

/-- Record: the seam order gB76Lo < tCE77 (the band (gB76Lo, tCE77] is exactly the new window-77 region; non-vacuity of ce77WinClause; exact rational arithmetic, re-anchor arithmetic of discovery 0385). -/
theorem gB76Lo_lt_tCE77 : (gB76Lo : ℝ) < (tCE77 : ℝ) := by
  norm_num [CE76.gB76Lo, tCE77]

/-- Record: the face height shrank by a FURTHER 4 673 units past tCE76 (tCE77 - tCE76 = 4 673, exact integer arithmetic): the usual increment - the 4 672 occurrences remain the three recorded ones (w45 -> w46, w53 -> w54, w65 -> w66); no pattern is assumed (floor-artifact data points, recorded honestly). -/
theorem faceShrinkCE77 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := by
  norm_num [tCE77, CE76.tCE76]

/-- THE EXTENDED GEAR (machine): the new frontier stands 364 484 units above H0 (tCE77 - tPT2 = 364 484, exact integer arithmetic; window 77 adds 4 673). THE 350 000-UNIT MILESTONE CARRIES (margin 14 484; it was CROSSED in WINDOW 74 [0380] at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly). The 325 000-unit MILESTONE (crossed in WINDOW 69 [0375]) is CARRIED with margin 39 484; the 300 000-unit MILESTONE (crossed in WINDOW 64 [0370]) is CARRIED with margin 64 484; the next round mark 375 000 sits 10 516 ahead (w78 -> 369 157, w79 -> 373 830, w80 -> 378 503) - crossing expected at window 80, margin ~3 503 (compute from the decoded endpoint, do not pre-announce). CERTIFIED-ZERO CENSUS (pipeline data): cumulative total 1 559 986 - the 1 500 000 CERTIFIED-ZERO MARK (CROSSED in WINDOW 75 [0381] at 1 519 986, margin 19 986) CARRIES with margin 59 986; the 1 600 000 mark sits 40 014 ahead (w79 -> 1 599 986 [14 short], w80 -> 1 619 986; window 80 expected). -/
theorem frontierGapAboveH0 : (tCE77 : ℝ) - WinC.tPT2 = 364484 := by
  norm_num [tCE77, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 200 000 - CARRIED into WINDOW-77 (the 200 000 mark was crossed at the W42B FILL, margin 200 932; the 300 000 mark is carried with margin 64 484; the 325 000 mark is carried with margin 39 484; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 14 484). -/
theorem frontierPast200k : (tCE77 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 175 000 - CARRIED into WINDOW-77 (the 175 000 mark was crossed in WINDOW 38, margin 2 488 [0342, incl. CASING]; the 300 000 mark is carried with margin 64 484; the 325 000 mark is carried with margin 39 484; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 14 484). -/
theorem frontierPast175k : (tCE77 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 225 000 - CARRIED into WINDOW-77 (the 225 000 mark was crossed in WINDOW 48 [discovery 0354], margin 228 969; the 300 000 mark is carried with margin 64 484; the 325 000 mark is carried with margin 39 484; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 14 484). -/
theorem frontierPast225k : (tCE77 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 250 000 - CARRIED into WINDOW-77 (the 250 000 mark was crossed in WINDOW 53 [discovery 0359], margin 252 334; the 300 000 mark is carried with margin 64 484; the 325 000 mark is carried with margin 39 484; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 14 484). -/
theorem frontierPast250k : (tCE77 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 275 000 - CARRIED into WINDOW-77 (the 275 000 mark was crossed in WINDOW 58 [discovery 0364], margin 275 698; the 300 000 mark is carried with margin 64 484; the 325 000 mark is carried with margin 39 484; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 14 484). -/
theorem frontierPast275k : (tCE77 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 300 000 - CARRIED into WINDOW-77 (the 300 000 UNIT MILESTONE was crossed in WINDOW 64 [discovery 0370], margin 3 736, carried with margin 64 484; the 325 000 UNIT MILESTONE was crossed in WINDOW 69 [discovery 0375] at 327 100, margin 2 100, carried with margin 39 484; the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 [discovery 0380] at 350 465, margin 465, carried with margin 14 484; the next round mark 375 000 is 10 516 ahead and NOT YET CROSSED - expected window 80 [w80 -> 378 503] at the ~4 673/window pace, compute from the decoded endpoint, do not pre-announce; CENSUS: the 1 500 000 CERTIFIED-ZERO MILESTONE (CROSSED in WINDOW 75 [discovery 0381], census 1 519 986, margin 19 986) CARRIES with margin 59 986 - a census milestone, not a unit-frontier round mark, so no frontierPast theorem is attached to it). -/
theorem frontierPast300k : (tCE77 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE77 - tPT2 = 364 484 exceeds 325 000 - CARRIED into WINDOW-77 (the 325 000-UNIT MILESTONE was crossed in WINDOW 69 [discovery 0375] at 327 100, margin 2 100 - inside the predicted corridor; now carried with margin 39 484; the 350 000-UNIT MILESTONE was CROSSED in WINDOW 74 [discovery 0380] at 350 465, margin 465 - the FIRST PREDICTION delivered exactly - and carries with margin 14 484; 375 000 is 10 516 ahead - expected window 80 [w80 -> 378 503, margin 3 503]; CENSUS: the 1 500 000 CERTIFIED-ZERO MILESTONE (CROSSED in WINDOW 75 [0381]) CARRIES - census 1 559 986, margin 59 986; the 1 600 000 mark is 40 014 ahead, expected window 80; compute, do not pre-announce). -/
theorem frontierPast325k : (tCE77 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-77 - tCE77 - tPT2 = 364 484 exceeds 350 000 with margin 14 484. The 375 000 round mark is 10 516 ahead and NOT YET CROSSED - expected window 80 [w78 -> 369 157, w79 -> 373 830, w80 -> 378 503] at the ~4 673/window pace, compute from the decoded endpoint, do not pre-announce. This statement is proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, so the crossing record stays true at the new frontier. -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE77 : ℝ) - WinC.tPT2 = 364484 := frontierGapAboveH0
  have hshrink1 : (tCE77 : ℝ) - (tCE76 : ℝ) = 4673 := faceShrinkCE77
  have hshrink2 : (tCE76 : ℝ) - (tCE75 : ℝ) = 4673 := CE76.faceShrinkCE76
  have hshrink3 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := CE75.faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink1, hshrink2, hshrink3]
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB76Lo < gB77Lo) - the window-77 band (gB76Lo, tCE77] lies strictly above the certified region of windows 1..76 (full machine chain gB75Lo < tCE76 < gB76Lo < tCE77 < gB77Lo). -/
theorem gB76Lo_lt_gB77Lo : (gB76Lo : ℝ) < (gB77Lo : ℝ) := by
  norm_num [CE76.gB76Lo, gB77Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- The FILL slice for WINDOW 76 (the full interior+terminal union (g75, g76], gB75Lo < Im s <= gB76Lo, on the line) - RE-CITED from the verified window 76 certificate data: the slice is EXACTLY covered by (window 75's full interior+terminal slice CE75.ce74WinClauseFull, already cited in this file as h76 of the band) PLUS (window 76's terminal slice CE76.ce76WinClause). RE-CITATION only - NO re-certification: the underlying windows were certified with the same pipeline, same M = 60, C_R = 1, N_range, K = 12, and their certificates are on record (window75_b75.json, window76_b76.json; window 76 was a rescue window with 2 recorded interior Rosser failures, ultimately determined, end runs 49 / 50 [0383]); window 77's pipeline cache was seeded from window 76's cache and its seam g_a77 == g_b76 was audited bit-identically BEFORE this module was written. Window 77 is a rescue window: 1 recorded interior Rosser failure block [12 363 154 988 233, 12 363 154 988 235], ultimately determined (quota-met on the union), RECORDED. -/
def ce76WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB75Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB76Lo : ℝ) → ρ.re = 1 / 2

/-- The TERMINAL slice of WINDOW 77 (g76, g77], gB76Lo < Im s <= tCE77, on the line): the verified certificate window77_b77.json certifies the b actual = b requested = 12 363 154 997 116 (NON-SNAPPED width 20 000) zeros of zeta with g_a77 < Im s <= g_b77 on the line (g_a77 = G_B76 bit-identical per the 0348 seam audit; g_b77 = 3 000 175 697 284.24359504873695940774610159056716558631552047888002565656506703817285597324371337890625, exact dyadic tuple [232127351284943729711048923572004665785, -86, 16777217, -110], radius 16777217 x 2^-110 ~ 1.29e-26), with 'CERTIFIED: true' and sign_changes_inside = 20 000 = b actual - a. W77 is a RESCUE window: rosser_failures_inside = 1 - the single block [12 363 154 988 233, 12 363 154 988 235] (union [12 363 154 988 231, 12 363 154 988 236], need = 5, found = 5, m = 2) was ultimately DETERMINED (quota-met on the union, recorded in the certificate) - recorded, not suppressed. End Rosser runs 45 left of g_a77 / 51 right of g_b77, both >= K = 12; cross-check failures 0; independent pipeline verifier ('turing_ok: true', wall clock < 1 s - re-derivation, same convention as CE2-CE76). The floor tCE77 = 3 000 175 697 284 = floor(g_b77), 0.243595048736959... below the endpoint - robust to the 1.29e-26 radius (margin 0.0035950487369594076 to the two-decimal lower bound gB77Lo; no CASING). -/
def ce77WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB76Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE77 : ℝ) → ρ.re = 1 / 2

/-- THE CERTIFIED BAND (machine): the union of the 77 verified window slices covers the full region (WinC.tPT2, tCE77] with every zero on the critical line. The slice family is the same corrected one as CE3-CE76: windows 1..41 (original slices), the W42B FILL slice CE42B, windows 43..52 original, then the RE-ANCHORED windows 53..77 (each a FRESH certificate window with its own verified slice, the corrected chain w42 -> w42b -> w43 -> ... -> w77, every seam bit-identical; the last re-anchored windows: w73 [0379], w74 [0380], w75 [0381], w76 [0383], w77 [0385]; window 77 was a certified RESCUE window - ONE recorded interior Rosser failure block, ultimately determined (quota-met on the union, in the certificate): block [12 363 154 988 233, 12 363 154 988 235], union [12 363 154 988 231, 12 363 154 988 236], need = 5, found = 5, m = 2 - recorded, not suppressed; end runs 45/51 with K = 12). Windows 53..76 contribute the FULL slices (interior+terminal, ceNNWinClauseFull) as in CE3-CE76; the current window 77 contributes its single terminal slice (ce77WinClause = (g76, g77]); the band's total height ends at tCE77 (frontierGapAboveH0: tCE77 - tPT2 = 364 484 - the 350 000-unit mark carried with margin 14 484; census 1 559 986; NO RH CLAIM). Increment: tCE77 - tCE76 = 4 673 (the usual 4 672/4 673 increment; W73-W77 all 4 673). -/
theorem bandOfWindows77 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : CE75.ce74WinClauseFull) (h76 : CE76.ce75WinClauseFull) (h77 : ce76WinClauseFull) (h78 : ce77WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE77 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                          · exact h78 ρ hz (not_le.mp hseam77) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- THE CENSUS AT THE NEW FRONTIER (machine): EVERY complex zero with WinC.tPT2 < Im s <= tCE77 (tCE77 = 3 000 175 697 284) lies on the critical line - the corrected window band w1-w77 with the W42b fill, all re-anchored windows 53..77 verified, every seam bit-identical (window 77 = a certified RESCUE window: ONE recorded interior Rosser failure block, ultimately determined quota-met, recorded not suppressed). This is the 'census' half of the main theorem below: RH on (0, tCE77] is now a machine-checked fact within the project's conventions; the open face is everything above tCE77 (frontierGapAboveH0: tCE77 - tPT2 = 364 484 - the 350 000-unit mark carried with margin 14 484 (crossed in WINDOW 74 [0380]); census 1 559 986; NO RH CLAIM). -/
theorem allOnLineUpToCE77 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : ce76WinClauseFull) (hW78 : ce77WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE77 : ℝ) := by
  have hband := bandOfWindows77 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- THE TERMINAL FACE (named, 0276; re-anchored at tCE77 = 3 000 175 697 284 [0385]): the uniform absolute clause for zero heights ABOVE the verified band - every zero with Im s > tCE77 is on the line. This is the 0288-named residual (the G-hs1 object) after the 0285 S-difference gate: finite-height closure is done through the band theorem above, so the open object is exactly the absolute clause above tCE77 (no window, no data, no floor arithmetic - it cannot be certified, only implied or excluded). RE-ANCHOR HISTORY: tPT2 -> ... -> tCE70 [0376] -> tCE71 [0377] -> tCE72 [0378] -> tCE73 [0379] -> tCE74 [0380] -> tCE75 [0381] -> tCE76 [0383] -> tCE77 [0385] (the face keeps its SAME object; each step only lowers the boundary by a verified window: tCE77 - tCE76 = 4 673, the usual increment; tCE77 - tPT2 = 364 484). The face at CE77 is IFF-equivalent to the face at CE76 below (terminalFaceCE77_iff_faceCE76), assuming the same cited window data (hW77, hW78 = the 76->77 slice family) - the face's content has not moved, only its boundary. The 4 672 increments were the three recorded occurrences (w45 -> w46, w53 -> w54, w65 -> w66) - no pattern claimed (floor artifact). NO RH CLAIM: terminalFaceCE77 is an OPEN HYPOTHESIS. -/
def terminalFaceCE77 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE77 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- MONOTONICITY (machine): the face at the new frontier tCE77 implies nothing stronger than the face at tCE76 - the face at tCE77 is a WEAKER statement (higher boundary, fewer constraints): faceCE76 q -> faceCE77 q. Re-anchoring is a boundary shift, not a content change (0288). -/
theorem faceCE76_implies_faceCE77 (q : ZeroSet)
    (hface : CE76.terminalFaceCE76 q) :
    terminalFaceCE77 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE76_lt_tCE77, ht])

/-- EXACT EQUIVALENCE (machine, no new assumptions beyond the cited window-data slices hW77, hW78): terminalFaceCE77 q ↔ terminalFaceCE76 q. The re-anchor adds no strength and loses none - what was open at tCE76 is (exactly) what is open at tCE77, and the slice family (gB76Lo, tCE77] covers the moved band. This is the 0288 iff re-cast at the new frontier (CE2-CE76 pattern). The forward direction splits on 'Im s <= tCE77': the band slice (gB76Lo, tCE77] is handled by the verified window slices hW77, hW78, the part above tCE77 is exactly the old face; the reverse is the monotonicity above. NO RH CLAIM: this theorem is an equivalence between two open hypotheses. -/
theorem terminalFaceCE77_iff_faceCE76 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW77 : ce76WinClauseFull) (hW78 : ce77WinClause) :
    terminalFaceCE77 q ↔ CE76.terminalFaceCE76 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE77 : ℝ)
    · by_cases hseam77 : ρ.im ≤ (gB76Lo : ℝ)
      · exact hW77 ρ (hqz ρ hρ) (by linarith [ht, CE76.gB75Lo_lt_tCE76, tCE76_lt_tCE77]) hseam77
      · exact hW78 ρ (hqz ρ hρ) (not_le.mp hseam77) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE76_implies_faceCE77 q

/-- THE MAIN SPLIT AT THE NEW FRONTIER (machine, the 0288 form): RH q ↔ (allOnLineUpTo q tCE77) × (terminalFaceCE77 q) - finite-height closure (now through the corrected w1-w77 band with the W42b fill, re-anchored windows 53..77 all bit-identical at their seams; window 77 certified with ONE recorded interior Rosser failure, ultimately determined quota-met) AND the absolute clause above tCE77. Both sides are named, both are tracked, only the face is open. NO RH CLAIM: the split is a tautological reformulation of the RH definition at the new frontier (tCE77 - tPT2 = 364 484 - the 350 000-unit mark carried with margin 14 484; census 1 559 986). -/
theorem rh_split_at_CE77 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE77 : ℝ) ∧ terminalFaceCE77 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE77 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE77 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- THE RE-ANCHORED MAIN THEOREM (machine, 77th window): RH ↔ the terminal face AT THE NEW FRONTIER tCE77 (the W77 endpoint floor, 3 000 175 697 284): the verified band w1-w77 with the W42b fill and all re-anchored windows 53..77 (all verified, all seams bit-identical; window 77 = certified RESCUE window, ONE recorded interior Rosser failure, ultimately determined quota-met, 1 559 986 zeros certified over (g_a1, g_b77]) does the finite part, so RH reduces to the face above tCE77. This is the project's named residual (G-hs1, 0285/0288): a uniform/absolute data-free bound on S-at-zeros / the DN walk above tCE77. Front status: 364 484 units above H0 (350 000-unit mark CARRIED, margin 14 484; 375 000 expected at window 80). NO RH CLAIM - the face is open. -/
theorem rh_reanchored_CE77 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : ce76WinClauseFull) (hW78 : ce77WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE77 q := by
  have hcensus := allOnLineUpToCE77 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hqz
  have hsplit := rh_split_at_CE77 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE77 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : ce76WinClauseFull) (hW78 : ce77WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE77 q) :
    RH q :=
  (rh_reanchored_CE77 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE77_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE77 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE77
