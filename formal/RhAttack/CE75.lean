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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74
open scoped Topology

/-!
**CE75 — the terminal face re-anchored at the SEVENTY-FIFTH certified window
(0381, option B, unit 95 - lane M5).

MILESTONE STATE: tCE75 - tPT2 = 355 138 - two milestone entries. (1) The
350 000 UNIT MILESTONE CARRIES with margin 5 138 (crossed in WINDOW 74 at
350 465, margin 465 [0380] - the FIRST PREDICTION of the series, delivered
exactly); the 325 000-unit mark CARRIES (margin 30 138; crossed in WINDOW
69 [0375]); the 300 000-unit mark CARRIES (margin 55 138; crossed in WINDOW
64). The next round mark 375 000 sits 19 862 ahead (19 862 / 4 673 ~ 4.25:
w76 -> 359 811, w78 -> 369 157, w79 -> 373 830, w80 -> 378 503) - crossing
expected at window 80, margin ~3 503 (compute from the decoded endpoint, do
not pre-announce). Round-mark sequence above H0: 100 000 @ CE22, 125 000 @
CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48,
250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69, 350 000 @
CE74 (CARRIED), 375 000 @ ~CE80 (predicted). (2) CERTIFIED-ZERO CENSUS:
cumulative total 1 519 986 over (g_a1, g_b75] - THE 1 500 000
CERTIFIED-ZERO MILESTONE IS CROSSED IN THIS WINDOW (WINDOW 75), margin
19 986. The corridor set one window ahead (0380, after W74 closed; line of
sight from 0378/0377-correction) was exactly "w74 -> 1 499 986 [14 short],
w75 -> 1 519 986 [effectively certain]" - window 75 was NON-SNAPPED and
added exactly 20 000, so the delivered value is exactly 1 519 986: the
corridor landed on the nose (second prediction-delivery of the M5 stretch,
after the 350 000-unit mark). The 1 600 000 mark is 80 014 ahead (w79 ->
1 599 986 [14 short], w80 -> 1 619 986) - crossing expected at window 80
(compute, do not pre-announce).

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 ->
w45 -> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55
-> w56 -> w57 -> w58 -> w59 -> w60 -> w61 -> w62 -> w63 -> w64 -> w65 ->
w66 -> w67 -> w68 -> w69 -> w70 -> w71 -> w72 -> w73 -> w74 -> w75, every
seam bit-identical (window 75 launched from b74; the seam audit passed
bit-identically BEFORE this module was written, per the 0348 process rule
- and BEFORE window 76 will be launched in the pipeline, see below).

WINDOW 75: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS a
good Gram point at working precision). CLEAN WINDOW - zero Rosser failures
anywhere: rosser_failures_inside = 0, NONE even in the M = 60 extensions,
no rescues, nothing to suppress (third clean window of the stretch: W72,
W74, W75). End Rosser runs: 49 left of g_a75, 43 right of g_b75 (both >=
K = 12); 0 cross-check failures (all 33 302 records); 0 undetermined Gram
signs. INCREMENT: 4 673 (the usual increment; the 4 672 occurrences remain
the three recorded ones, w45 -> w46 / w53 -> w54 / w65 -> w66 - no
pattern).

PIPELINE RUN (ninth in the overlap pipeline): seed cache (window 74's
cache copied in before launch - resumed_from_cache = 303 685, logged for
provenance) + 32 workers: 33 302 evaluations in 2 387.5 s (series:
2 497.2 / 2 498.3 / 2 498.5 / 2 490.4 / 2 483.4 / 2 375.0 / 2 459.6 /
2 490.2 / 2 387.5 - the count moved, the certification content did not:
same M = 60, C_R = 1, N_range = [691 008, 691 008], same pipeline, same
verifier, same seam discipline). Window 75 RAN WHILE CE74's formalization
proceeded, and window 76 will be launched with the W75 seam already
audited - the per-unit critical path is max(run, formalization).

PROVENANCE (our run, 2026-11-12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE74): RUN PARAMETERS: a = 12 363 154 937 116 (= b74),
b requested = a + 20 000 = 12 363 154 957 116, b ACTUAL = 12 363 154 957 116
(NON-SNAPPED), M = 60, C_R = 1, 32 workers, 33 302 evaluations, 2 387.5 s,
resumed_from_cache = 303 685 (seeded from window74_b74.json.cache.jsonl).
CERTIFICATE (window75_b75.json): the b - a = 20 000 zeros of zeta with
g_a75 < Im s <= g_b75 are ALL SIMPLE and on the line, where g_a75 (recorded
exact dyadic ball) = 232127350200291202311781827190793855211 x 2^-86 with
radius 16777217 x 2^-110 (i.e. 3 000 175 683 265.43825096568398429701898503701855115185297378892215203194382411311380565166473388671875 + or -
1.29e-26) and this ball is BIT-IDENTICAL to CE74's recorded g_b74 (exact
dyadic tuple comparison, 2026-11-12 - audit PERFORMED BEFORE this module was
written); g_b75 = 3 000 175 687 938.37336593068788580197683149066750476081696778242469125785873984568752348423004150390625 + or - 1.29e-26 (exact
dyadic tuple [232127350561842044799144947263211551961, -86, 16777217,
-110]). The floor tCE75 sits 0.37336593068788580197683149066750476081696778242469125785873984568752348423004150390625 below the endpoint g_b75 -
robust to the 1.29e-26 radius by many orders of magnitude; the standard
two-decimal lower bound gB75Lo (3 000 175 687 938.37) has a margin of
0.0033659 (the usual cent granularity); the two-decimal round-down (0.37)
does not equal the floor, so no CASING is needed - window 38 / CE38 remains
the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE74): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2) PIPELINE
VERIFIER on window75_b75.json: "CERTIFIED: true", points_checked = 33 302,
sign_changes_inside = 20 000 = b - a, rosser_failures_inside = 0 (CLEAN -
nothing recorded because nothing failed), turing_ok = true,
K_conservative = 12, end Rosser runs 49 / 43, endpoints recomputed and
matched (verifier wall clock < 1 s: it re-derives from the recorded exact
dyadic enclosures); (3) SEAM AUDIT (this run): the recorded g_a75 ball is
bit-identical to CE74's recorded g_b74 ball (exact dyadic decode,
2026-11-12). FRONTIER ARITHMETIC (machine, below): tCE75 = 3 000 175
687 938, tCE75 - tCE74 = 4 673, tCE75 - tPT2 = 355 138 (350 000 mark
carries with margin 5 138). HONESTY (trust base): as CE2-CE74 - the
pipeline's own controls, its kernel-checked Lean remainder theorem, and our
three verification layers; a RE-RUN of a third-party pipeline, not a
from-scratch independent certification; the Rosser exceptions are RECORDED,
not suppressed (none occurred in this window). Cumulative certified count
= 1 519 986 over (g_a1, g_b75] (pipeline data, not in-tree arithmetic):
the 1 500 000 mark is CROSSED in this window (margin 19 986); the 1 600
000 mark is 80 014 ahead (window 80 expected). NO RH CLAIM.
-/
namespace CE75


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b75 (the recorded ball is 3 000 175 687 938.37353515625 with radius ~= 1.29e-26, exact dyadic tuple [232127350561842044799144947263211551961, -86, 16777217, -110]; this rational rounds the bottom down at two decimals, margin ~3.5e-3 - the usual cent granularity; the inequality gB75Lo < g_b75 is an EXACT rational comparison (norm_num), no floating point; the fractional part 0.37353515625 is robust to the 27-order radius, and the two-decimal round-down (0.37) does not equal the floor, so no CASING is needed - window 38 / CE38 remains the only CASING case; window 75 is NON-SNAPPED with width b - a = 20 000 and is a CLEAN WINDOW - zero Rosser failures anywhere, no rescues (see the header). -/
def gB75Lo : ℚ := 300017568793837 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB75Lo: tCE75 = 3 000 175 687 938 (the certified floor at the end of window 75; g_b75 has fractional part 0.37353515625, so the floor cannot move at 1.29e-26 radius). -/
def tCE75 : ℕ := 3000175687938

theorem tCE75_lt_gB75Lo : (tCE75 : ℝ) < (gB75Lo : ℝ) := by
  norm_num [gB75Lo, tCE75]

theorem tCE74_lt_tCE75 : (tCE74 : ℝ) < (tCE75 : ℝ) := by
  norm_num [CE74.tCE74, tCE75]

/-- Record: the seam order gB74Lo < tCE75 (the band (gB74Lo, tCE75] is exactly the new window-75 region; non-vacuity of ce75WinClause; exact rational arithmetic, re-anchor arithmetic of discovery 0381). -/
theorem gB74Lo_lt_tCE75 : (gB74Lo : ℝ) < (tCE75 : ℝ) := by
  norm_num [CE74.gB74Lo, tCE75]

/-- Record: the face height shrank by a FURTHER 4 673 units past tCE74 (tCE75 - tCE74 = 4 673, exact integer arithmetic): the usual increment - the 4 672 occurrences remain the three recorded ones (w45 -> w46, w53 -> w54, w65 -> w66); no pattern is assumed (floor-artifact data points, recorded honestly). -/
theorem faceShrinkCE75 : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := by
  norm_num [tCE75, CE74.tCE74]

/-- THE EXTENDED GEAR (machine): the new frontier stands 355 138 units above H0 (tCE75 - tPT2 = 355 138, exact integer arithmetic; window 75 adds 4 673). THE 350 000-UNIT MILESTONE CARRIES (margin 5 138; it was CROSSED in WINDOW 74 [0380] at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly). The 325 000-unit MILESTONE (crossed in WINDOW 69 [0375]) is CARRIED with margin 30 138; the 300 000-unit MILESTONE (crossed in WINDOW 64 [0370]) is CARRIED with margin 55 138; the next round mark 375 000 sits 19 862 ahead (w76 -> 359 811, w79 -> 373 830, w80 -> 378 503) - crossing expected at window 80, margin ~3 503 (compute from the decoded endpoint, do not pre-announce). CERTIFIED-ZERO CENSUS (pipeline data): cumulative total 1 519 986 - THE 1 500 000 CERTIFIED-ZERO MARK IS CROSSED IN THIS WINDOW (margin 19 986; the corridor predicted at 0380/0378/0377-correction - w74 -> 1 499 986 [14 short], w75 -> 1 519 986 - landed exactly); the 1 600 000 mark sits 80 014 ahead. -/
theorem frontierGapAboveH0 : (tCE75 : ℝ) - WinC.tPT2 = 355138 := by
  norm_num [tCE75, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 200 000 - CARRIED into WINDOW-75 (the 200 000 mark was crossed at the W42B FILL, margin 200 932; the 300 000 mark is carried with margin 55 138; the 325 000 mark is carried with margin 30 138; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 5 138). -/
theorem frontierPast200k : (tCE75 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 175 000 - CARRIED into WINDOW-75 (the 175 000 mark was crossed in WINDOW 38, margin 2 488 [0342, incl. CASING]; the 300 000 mark is carried with margin 55 138; the 325 000 mark is carried with margin 30 138; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 5 138). -/
theorem frontierPast175k : (tCE75 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 225 000 - CARRIED into WINDOW-75 (the 225 000 mark was crossed in WINDOW 48 [discovery 0354], margin 228 969; the 300 000 mark is carried with margin 55 138; the 325 000 mark is carried with margin 30 138; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 5 138). -/
theorem frontierPast225k : (tCE75 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 250 000 - CARRIED into WINDOW-75 (the 250 000 mark was crossed in WINDOW 53 [discovery 0359], margin 252 334; the 300 000 mark is carried with margin 55 138; the 325 000 mark is carried with margin 30 138; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 5 138). -/
theorem frontierPast250k : (tCE75 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 275 000 - CARRIED into WINDOW-75 (the 275 000 mark was crossed in WINDOW 58 [discovery 0364], margin 275 698; the 300 000 mark is carried with margin 55 138; the 325 000 mark is carried with margin 30 138; the 350 000 mark was CROSSED in WINDOW 74 at 350 465, margin 465, and carries with margin 5 138). -/
theorem frontierPast275k : (tCE75 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 300 000 - CARRIED into WINDOW-75 (the 300 000 UNIT MILESTONE was crossed in WINDOW 64 [discovery 0370], margin 3 736, carried with margin 55 138; the 325 000 UNIT MILESTONE was crossed in WINDOW 69 [discovery 0375] at 327 100, margin 2 100, carried with margin 30 138; the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 [discovery 0380] at 350 465, margin 465, carried with margin 5 138; the next round mark 375 000 is 19 862 ahead and NOT YET CROSSED - expected window 80 [w80 -> 378 503] at the ~4 673/window pace, compute from the decoded endpoint, do not pre-announce; CENSUS: the 1 500 000 CERTIFIED-ZERO MILESTONE is CROSSED in WINDOW 75 at census 1 519 986, margin 19 986 - a crossing mark recorded in the docs, and no frontierPast theorem is added for it (it is a census milestone, not a unit-frontier round mark). -/
theorem frontierPast300k : (tCE75 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE75 - tPT2 = 355 138 exceeds 325 000 - CARRIED into WINDOW-75 (the 325 000-UNIT MILESTONE was crossed in WINDOW 69 [discovery 0375] at 327 100, margin 2 100 - inside the predicted corridor; now carried with margin 30 138; the 350 000-UNIT MILESTONE was CROSSED in WINDOW 74 [discovery 0380] at 350 465, margin 465 - the FIRST PREDICTION delivered exactly - and carries with margin 5 138; 375 000 is 19 862 ahead - expected window 80 [w80 -> 378 503, margin 3 503]; CENSUS: the 1 500 000 CERTIFIED-ZERO MILESTONE is CROSSED in WINDOW 75 - census 1 519 986, margin 19 986 - the corridor delivered exactly; compute, do not pre-announce). -/
theorem frontierPast325k : (tCE75 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRIED (machine, PROVEN): the 350 000 UNIT MILESTONE was CROSSED in WINDOW 74 (at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly [predicted one window ahead at 0379: w74 -> 350 465, margin ~465]); CARRIED into WINDOW-75 - tCE75 - tPT2 = 355 138 exceeds 350 000 with margin 5 138. The 375 000 round mark is 19 862 ahead and NOT YET CROSSED - expected window 80 [w80 -> 378 503] at the ~4 673/window pace, compute from the decoded endpoint, do not pre-announce. This statement is proven at the WINDOW-74 frontier: (tCE74 : R) - WinC.tPT2 = 350 465, so the crossing record stays true at the new frontier. -/
theorem frontierPast350k : (tCE74 : ℝ) - WinC.tPT2 > 350000 := by
  have hgap : (tCE75 : ℝ) - WinC.tPT2 = 355138 := frontierGapAboveH0
  have hshrink : (tCE75 : ℝ) - (tCE74 : ℝ) = 4673 := faceShrinkCE75
  have h : (tCE74 : ℝ) - WinC.tPT2 = 350465 := by linarith [hgap, hshrink]
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB74Lo < gB75Lo) - the window-75 band (gB74Lo, tCE75] lies strictly above the certified region of windows 1..74 (full machine chain gB73Lo < tCE74 < gB74Lo < tCE75 < gB75Lo). -/
theorem gB74Lo_lt_gB75Lo : (gB74Lo : ℝ) < (gB75Lo : ℝ) := by
  norm_num [CE74.gB74Lo, gB75Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED, RE-CITED as window 74's FULL SLICE (gB73Lo, gB74Lo]; OUR WINDOW-73/74 RUNS (window73_b73.json, window74_b74.json) plus the window-72 citation already re-cited in CE73]: the certified regions (g_a73, g_b73] (window 73, NON-SNAPPED width 20 000, THREE recorded interior Rosser failures each rescued quota-met - RECORDED, not suppressed; 34 089 evals, 2 459.6 s; endpoints left 44 / right 48, K = 12) and (g_a74, g_b74] (window 74, NON-SNAPPED width 20 000, CLEAN - zero Rosser failures anywhere; 33 703 evals, 2 490.2 s; endpoints left 47 / right 46, K = 12) union to (g_a73, g_b74], which contains (gB73Lo, gB74Lo] (by g_a73 < gB73Lo and gB74Lo < g_b74 - arithmetic on the certified balls; in-tree machine chain gB73Lo < tCE74 < gB74Lo, CE74). Every zeta zero rho with (gB73Lo : R) < rho.im <= (gB74Lo : R) is therefore simple (multiplicity 1) and on the line. Seam g_a74 = g_b73 [232127349477189517274233323028641326643, -86, 16777217, -110] = 3 000 175 673 919.568020223717 + or - 1.29e-26 (audit before 0380). RE-CITED exactly as CE45-CE74 re-cited their predecessors; Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce74WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB73Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB74Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-75 RUN (window75_b75.json), SLICE] every zeta zero with gB74Lo < Im \u03c1 <= tCE75 is on the critical line. Derivation (recorded): for t0 = Im \u03c1 in (gB74Lo, tCE75], either t0 <= g_b74 (the true Gram point - g_a75 = g_b74, recorded exact dyadic tuple [232127350200291202311781827190793855211, -86, 16777217, -110], i.e. 3 000 175 683 265.4385 + or - 1.29e-26, BIT-IDENTICAL in both certificates - the chain seam, audit PASSED BEFORE this module was written per the 0348 process rule) - then t0 sits in window 74's certified region (g_a74, g_b74] (gB74Lo < g_b74) - or t0 > g_b74 = g_a75, in which case t0 <= tCE75 < gB75Lo <= g_b75 puts t0 in window 75's certified region (g_a75, g_b75] (window 75 is NON-SNAPPED, width 20 000, CLEAN - zero Rosser failures). The two certified regions union to (g_a74, g_b75] which contains (gB74Lo, tCE75] (machine: gB74Lo < tCE75 < gB75Lo). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce75WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB74Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE75 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine): zeros in (tPT2, tCE75] are on the line, given the SEVENTY-SIX clauses h1..h76 (windows 1..75): h1 endpoint, h2..h42 (w2..w40/41 + W42B FILL + w42b region via CE44), h43..h45 (w43..w45), h46..h53 (w46..w53), h54..h58 (w54..w58), h59..h63 (w59..w63), h64 (window 63, re-cited from CE64), h65 (window 64, re-cited from CE65), h66 (window 65, re-cited from CE66), h67 (window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67), h68 (window 67, re-cited from CE67/CE68), h69 (window 68 full slice (gB67Lo, gB68Lo], re-cited from CE69), h70 (window 69 full slice (gB68Lo, gB69Lo], re-cited from CE70), h71 (window 70 full slice (gB69Lo, gB70Lo], re-cited from CE71), h72 (window 71 full slice (gB70Lo, gB71Lo], re-cited from CE72), h73 (window 72 full slice (gB71Lo, gB72Lo], re-cited from CE73), h74 (window 73 full slice (gB72Lo, gB73Lo], re-cited from CE74), h75 (window 74 full slice (gB73Lo, gB74Lo], local re-citation), h76 (local WINDOW-75 terminal slice (gB74Lo, tCE75])); the machine ordering of the 76 boundary constants (gB1Lo <= tPT2 < ... < tCE75 <= gB75Lo) makes the union the interval (gB1Lo, tCE75]; every zero in (tPT2, tCE75] lies in exactly one clause's slice; the window-75 clause h76 is the NEW terminal slice - NO RH CLAIM (the face beyond tCE75 is untouched). -/
theorem bandOfWindows75 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : CE69.ce68WinClauseFull) (h70 : CE70.ce69WinClauseFull) (h71 : CE71.ce70WinClauseFull) (h72 : CE72.ce71WinClauseFull) (h73 : CE73.ce72WinClauseFull) (h74 : CE74.ce73WinClauseFull) (h75 : ce74WinClauseFull) (h76 : ce75WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE75 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                                      · exact h76 ρ hz (not_le.mp hseam75) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5 - THE FRONTIER MOVED AGAIN (window 75): [Z-PT2] + the SEVENTY-SIX clauses (windows 1..75, incl. w42b FILL) => every zero of zeta in (WinC.tPT2, tCE75] lies on the line Re = 1/2. Proof: take a zero rho in (tPT2, tCE75]; split at tCE75: below it, discharges hW2..hW42 (w2..w42), hW43 (the W42B FILL clause), hW44 (w43), hW45 (w44), hW46..hW53 (w45..w52), hW54..hW58 (w53..w57), hW59..hW63 (w58..w62), hW64 (window 63, re-cited from CE64), hW65 (window 64, re-cited from CE65), hW66 (window 65, re-cited from CE66), hW67 (window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67), hW68 (window 67, re-cited from CE67/CE68), hW69 (window 68 full slice (gB67Lo, gB68Lo], re-cited from CE69), hW70 (window 69 full slice (gB68Lo, gB69Lo], re-cited from CE70), hW71 (window 70 full slice (gB69Lo, gB70Lo], re-cited from CE71), hW72 (window 71 full slice (gB70Lo, gB71Lo], re-cited from CE72), hW73 (window 72 full slice (gB71Lo, gB72Lo], re-cited from CE73), hW74 (window 73 full slice (gB72Lo, gB73Lo], re-cited from CE74), hW75 (window 74 full slice (gB73Lo, gB74Lo], local re-citation), and hW76 (WINDOW 75 terminal slice (gB74Lo, tCE75]); the seam g_a75 = g_b74 is the recorded bit-identical endpoint (window 75 NON-SNAPPED, width 20 000, CLEAN - zero Rosser failures). The SEVENTY-SIX clauses and the endpoint h1 give the whole interval by the same machine-ordering union argument. Window 75 is the NINTH seeded-cache + 32-worker overlap-pipeline run (33 302 evals, 2 387.5 s; resumed_from_cache = 303 685; it RAN WHILE CE74's formalization proceeded - per-unit critical path = max(run, formalization); and in this window THE 1 500 000 CERTIFIED-ZERO MARK CROSSES - census 1 519 986, margin 19 986, the corridor from 0380/0378/0377-correction landed exactly; window 76 is launched in pipeline overlap after this module's seam audit, which has already PASSED). NO RH CLAIM - this only discharges the band; the face (terminalFaceCE75) is separately NAMED. -/
theorem allOnLineUpToCE75 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : ce74WinClauseFull) (hW76 : ce75WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE75 : ℝ) := by
  have hband := bandOfWindows75 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 - THE RE-ANCHORED FACE (window 75): no off-line zero with positive real (Re) part between WinC.tPT2 (= 3 000 175 332 800) and tCE75 (= 3 000 175 687 938, the certified floor - 355 138 certified zeros above H0; the 300 000-unit mark CARRIED, margin 55 138; the 325 000-unit mark CARRIED - crossed in window 69 [0375], margin 30 138; the 350 000-unit mark CARRIES - crossed in window 74 [0380] at 350 465, margin 465, the FIRST PREDICTION delivered exactly, now margin 5 138; 375 000 is 19 862 ahead, expected window 80; CENSUS: the 1 500 000 CERTIFIED-ZERO MARK CROSSES IN THIS WINDOW - 1 519 986, margin 19 986). OPEN HYPOTHESIS - NO RH CLAIM. Re-anchoring is a certificate (the 75-window chain + endpoint now cover exactly (tPT2, tCE75] plus the named face); the face itself remains OPEN and unchanged in shape, only narrower. -/
def terminalFaceCE75 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE75 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic: the CE74 face implies the CE75 face (tCE75 > tCE74, by tCE74_lt_tCE75; any zero with tPT2 < im <= tCE74 automatically has im <= tCE75). -/
theorem faceCE74_implies_faceCE75 (q : ZeroSet)
    (hface : CE74.terminalFaceCE74 q) :
    terminalFaceCE75 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE74_lt_tCE75, ht])

/-- M5 - THE TWO FACE FORMULATIONS, EQUIVALENT UNDER THE BAND: the extended formulation terminalFaceCE75 is EQUIVALENT to the base formulation CE74.terminalFaceCE74 (the window-74 face, transitively re-anchored from CE64-CE73 in 0370-0379 and from CE74 in 0380), given the two terminal clauses hW75 (window 74 full slice, local) and hW76 (window 75 terminal slice). Forward: a terminalFaceCE75 zero rho satisfies tPT2 < im <= tCE75; split at tCE75: below, the UNION of windows 1..75 clauses lands rho on the line (hW75 for the w74 slice; hW76 for the w75 terminal slice) - contradicts off-line; the machine ordering gB74Lo < tCE75 hands the seam to the window-75 side. So rho is on the line - and the base face's interval (tPT2, tCE74] is contained, discharging by linarith on the machine orders. Backward: a CE74 face zero has tPT2 < im <= tCE74; the union argument covers the overlap and window 75's terminal clause is vacuous below its lower bound where needed - the implication holds. The re-anchor EXACTLY adds the window-75 clause - NO RH CLAIM (the face is still open; re-anchoring is a certificate, not closure). -/
theorem terminalFaceCE75_iff_faceCE74 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW75 : ce74WinClauseFull) (hW76 : ce75WinClause) :
    terminalFaceCE75 q ↔ CE74.terminalFaceCE74 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE75 : ℝ)
    · by_cases hseam75 : ρ.im ≤ (gB74Lo : ℝ)
      · exact hW75 ρ (hqz ρ hρ) (by linarith [ht, CE74.gB73Lo_lt_tCE74, tCE74_lt_tCE75]) hseam75
      · exact hW76 ρ (hqz ρ hρ) (not_le.mp hseam75) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE74_implies_faceCE75 q

/-- M5 - THE 0288 EXACT RESIDUAL, RE-PINNED AT tCE75 (PURE LOGIC): RH (all zeta zeros on the line, via the ZeroSet contract) is equivalent to the CONJUNCTION of (i) the band part: every zero of the ZERO SET q in (WinC.tPT2, tCE75] is on the line - discharged by the SEVENTY-SIX clause band (hW1..hW42, hW43..hW45, hW46..hW53, hW54..hW58, hW59..hW63, hW64 [window 63, re-cited from CE64], hW65 [window 64, re-cited from CE65], hW66 [window 65, re-cited from CE66], hW67 [window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67], hW68 [window 67, re-cited from CE67/CE68], hW69 [window 68 full slice (gB67Lo, gB68Lo], re-cited from CE69], hW70 [window 69 full slice (gB68Lo, gB69Lo], re-cited from CE70], hW71 [window 70 full slice (gB69Lo, gB70Lo], re-cited from CE71], hW72 [window 71 full slice (gB70Lo, gB71Lo], re-cited from CE72], hW73 [window 72 full slice (gB71Lo, gB72Lo], re-cited from CE73], hW74 [window 73 full slice (gB72Lo, gB73Lo], re-cited from CE74], hW75 [window 74 full slice (gB73Lo, gB74Lo], local re-citation], hW76 [WINDOW 75 terminal slice (gB74Lo, tCE75)], machine-ordering union, seam g_a75 = g_b74 bit-identical) AND (ii) the NAMED open face terminalFaceCE75 (NO RH CLAIM - this face is the residual; re-anchoring at tCE75, 355 138 above H0 - including the 1 500 000 CERTIFIED-ZERO CENSUS CROSSING (census 1 519 986, margin 19 986) and the 350 000-unit carry (margin 5 138) - carries no claim about the face). -/
theorem rh_split_at_CE75 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE75 : ℝ) ∧ terminalFaceCE75 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE75 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE75 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 - HEADLINE (window 75 - NON-SNAPPED WIDTH 20 000, CLEAN WINDOW - zero Rosser failures anywhere: interior, M = 60 extensions, no rescues, nothing suppressed because nothing failed; end runs 49 / 43, K = 12): RH q is EQUIVALENT to (the seventy-six window clauses hW1..h76 covering windows 1..75 plus the endpoint h1) AND (terminalFaceCE75 q). MILESTONE EVENTS: tCE75 - tPT2 = 355 138 - the 350 000 UNIT MILESTONE CARRIES (margin 5 138; it was CROSSED in WINDOW 74 [0380] at 350 465, margin 465 - the FIRST PREDICTION of the series, delivered exactly); and THE 1 500 000 CERTIFIED-ZERO CENSUS MARK CROSSES IN THIS WINDOW (census 1 519 986, margin 19 986). The machine-verified FRONTIER is now tCE75 = 3 000 175 687 938 (355 138 certified zeros above H0; machine arithmetic, exact integers; 300 000 carried, margin 55 138; 325 000 carried, margin 30 138; 375 000 is 19 862 ahead - crossing expected at window 80 [w80 -> 378 503, margin ~3 503], compute, do not pre-announce; the 1 600 000 census mark is 80 014 ahead). Cumulative certified count: 1 519 986 over (g_a1, g_b75] (pipeline data, not in-tree arithmetic; the 1 400 000 mark carries from WINDOW 70 [0376]; the 1 500 000 mark CROSSES HERE; the corridor predicted at 0380/0378/0377-correction - w74 -> 1 499 986 [14 short], w75 -> 1 519 986 - landed exactly). PIPELINE RECORD: window 75 is the ninth seeded-cache + 32-worker overlap run (33 302 evals, 2 387.5 s; resumed_from_cache = 303 685; the count moved, the certification content did not - same M = 60, C_R = 1, N_range, pipeline, verifier, seam discipline; the throughput gain is the OVERLAP itself: window 75 ran while CE74's formalization proceeded, and window 76 is launched in pipeline overlap with the W75 seam already audited). NO RH CLAIM. -/
theorem rh_reanchored_CE75 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : ce74WinClauseFull) (hW76 : ce75WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE75 q := by
  have hcensus := allOnLineUpToCE75 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hqz
  have hsplit := rh_split_at_CE75 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE75 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : ce74WinClauseFull) (hW76 : ce75WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE75 q) :
    RH q :=
  (rh_reanchored_CE75 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE75_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE75 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE75
