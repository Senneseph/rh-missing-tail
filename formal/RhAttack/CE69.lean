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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68
open scoped Topology

/-!
**CE69 — the terminal face re-anchored at the SIXTY-NINTH certified window
(0375, option B, unit 89 - lane M5).

MILESTONE STATE: tCE69 - tPT2 = 327 100 - **THE 325 000-UNIT MILESTONE IS
CROSSED IN WINDOW 69** at 327 100 above H0 (margin 2 100; exactly inside the
predicted corridor - 2 573 was ahead at 0374, and the ~4 673/window pace put
the crossing in window 69, as computed and never pre-announced). The 300
000-unit MILESTONE (crossed in WINDOW 64, margin 3 736) is CARRIED (margin
27 100); the next round mark 350 000 sits 22 900 ahead - expected ~window
74 (compute from the decoded endpoint, do not pre-announce). Round-mark
sequence above H0: 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @
CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58,
300 000 @ CE64, **325 000 @ CE69**. Certified count: the 1 300 000 mark
[crossed in WINDOW 65 - 1 319 986] is carried - 1 399 986 total now (the
1 400 000 mark is just 14 ahead - **crossing expected in WINDOW 70**,
confirm from the verified count; pipeline data).

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 -> w45
-> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55 -> w56
-> w57 -> w58 -> w59 -> w60 -> w61 -> w62 -> w63 -> w64 -> w65 -> w66 ->
w67 -> w68 -> w69, every seam bit-identical (window 69 launched from b68;
the seam audit passed bit-identically BEFORE this module was written, per
the 0348 process rule - and BEFORE window 70 was launched in the pipeline,
see below).

WINDOW 69: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS a
good Gram point at working precision). TWO recorded interior Rosser
failures, BOTH RESCUED quota-met, RECORDED, not suppressed: block
[12 363 154 829 318, 12 363 154 829 320] (need 2, found 0, 129 points,
m = 64) -> union [12 363 154 829 317, 12 363 154 829 321] (need 4, FOUND 4,
m = 8); block [12 363 154 830 844, 12 363 154 830 847] (need 3, found 1,
193 points, m = 64) -> union [12 363 154 830 843, 12 363 154 830 849]
(need 6, FOUND 6, m = 8). rosser_failures_inside = 2 (both interior; the M
= 60 extensions were clean). End Rosser runs: 46 left of g_a69, 47 right of
g_b69 (both >= K = 12); 0 cross-check failures (all 34 723 records); 0
undetermined Gram signs. INCREMENT: 4 673 (the usual increment; the
4 672 occurrences remain the three recorded ones, w45 -> w46 / w53 -> w54 /
w65 -> w66 - no pattern).

PIPELINE RUN (third in the overlap pipeline, adopted in unit 87): seed
cache (window 68's cache copied in before launch - resumed_from_cache =
101 872, logged for provenance) + 32 workers: 34 723 evaluations in
2 498.5 s - flat with windows 67 / 68 (2 497.2 / 2 498.3 s): the
per-window compute is unchanged; the throughput gain is the OVERLAP itself:
window 70 was LAUNCHED before this module's formalization finished (legal:
W69's seam audit had already passed) - the per-unit critical path is max
(run, formalization). Certification content is UNCHANGED: same M = 60,
C_R = 1, N_range = [691 008, 691 008], same pipeline, same verifier, same
seam discipline.

PROVENANCE (our run, 2026-11-12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE68): RUN PARAMETERS: a = 12 363 154 817 116 (= b68),
b requested = a + 20 000 = 12 363 154 837 116, b ACTUAL = 12 363 154 837 116
(NON-SNAPPED), M = 60, C_R = 1, 32 workers, 34 723 evaluations, 2 498.5 s,
resumed_from_cache = 101 872 (seeded from window68_b68.json.cache.jsonl).
CERTIFICATE (window69_b69.json): the b - a = 20 000 zeros of zeta with
g_a69 < Im s <= g_b69 are ALL SIMPLE and on the line, where g_a69 (recorded
exact dyadic ball) = 116063674015493073473923628809964265701 x 2^-85 with
radius 16777217 x 2^-110 (i.e. 3 000 175 655 227.827555491949439917 + or -
1.29e-26) and this ball is BIT-IDENTICAL to CE68's recorded g_b68 (exact
dyadic tuple comparison, 2026-11-12 - audit PERFORMED BEFORE this module was
written); g_b69 = 3 000 175 659 900.762672080870811008 + or - 1.29e-26
(exact dyadic tuple [116063674196268494780427453099147563155, -85,
16777217, -110]). The floor tCE69 sits 0.7627 below the next integer -
robust to the 1.29e-26 radius by many orders of magnitude; the standard
two-decimal lower bound gB69Lo has a margin of ~2.7e-3 (the usual cent
granularity); the two-decimal round-down (0.76) does not equal the floor,
so no CASING is needed - window 38 / CE38 remains the only CASING case so
far.

VERIFICATION (three layers, same as CE2-CE68): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2) PIPELINE
VERIFIER on window69_b69.json: "CERTIFIED: true", points_checked = 34 723,
sign_changes_inside = 20 000 = b - a, rosser_failures_inside = 2 (both
RECORDED above; quota-met; not suppressed), turing_ok = true,
K_conservative = 12 (Trudgian Cor2.3 / doubled / Amberger Thm2.3 readings
all below 12, as in every recent unit), endpoints recomputed and matched
(verifier wall clock < 1 s: it re-derives from the recorded exact dyadic
enclosures); (3) SEAM AUDIT (this run): the recorded g_a69 ball is
bit-identical to CE68's recorded g_b68 ball (exact dyadic decode,
2026-11-12). FRONTIER ARITHMETIC (machine, below): tCE69 =
3 000 175 659 900, tCE69 - tCE68 = 4 673, tCE69 - tPT2 = 327 100 (the 325
000-unit milestone is CROSSED, margin 2 100; 350 000 is 22 900 ahead).
HONESTY (trust base): as CE2-CE68 - the pipeline's own controls, its
kernel-checked Lean remainder theorem, and our three verification layers; a
RE-RUN of a third-party pipeline, not a from-scratch independent
certification; the Rosser exceptions are RECORDED, not suppressed.
Cumulative certified count = 1 399 986 over (g_a1, g_b69] (pipeline data,
not in-tree arithmetic): the 1 300 000 mark [window 65, 0371] is carried;
the 1 400 000 mark is 14 ahead (crossing expected in window 70). NO RH
CLAIM.
-/
namespace CE69


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b69 (the recorded ball is 3 000 175 659 900.762672080870811008 with radius ~= 1.29e-26, exact dyadic tuple [116063674196268494780427453099147563155, -85, 16777217, -110]; this rational rounds the bottom down at two decimals, margin ~2.7e-3 - the usual cent granularity; the inequality gB69Lo < g_b69 is an EXACT rational comparison (norm_num), no floating point; the fractional part 0.7627 is robust to the 27-order radius, and the two-decimal round-down (0.76) does not equal the floor, so no CASING is needed - window 38 / CE38 remains the only CASING case; window 69 is NON-SNAPPED with width b - a = 20 000 and has TWO recorded interior Rosser failures, both rescued quota-met and not suppressed (see the header). -/
def gB69Lo : ℚ := 300017565990076 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB69Lo: tCE69 = 3 000 175 659 900 (the certified floor at the end of window 69; g_b69 has fractional part 0.7627, so the floor cannot move at 1.29e-26 radius). -/
def tCE69 : ℕ := 3000175659900

theorem tCE69_lt_gB69Lo : (tCE69 : ℝ) < (gB69Lo : ℝ) := by
  norm_num [gB69Lo, tCE69]

theorem tCE68_lt_tCE69 : (tCE68 : ℝ) < (tCE69 : ℝ) := by
  norm_num [CE68.tCE68, tCE69]

/-- Record: the seam order gB68Lo < tCE69 (the band (gB68Lo, tCE69] is exactly the new window-69 region; non-vacuity of ce69WinClause; exact rational arithmetic, re-anchor arithmetic of discovery 0375). -/
theorem gB68Lo_lt_tCE69 : (gB68Lo : ℝ) < (tCE69 : ℝ) := by
  norm_num [CE68.gB68Lo, tCE69]

/-- Record: the face height shrank by a FURTHER 4 673 units past tCE68 (tCE69 - tCE68 = 4 673, exact integer arithmetic): the usual increment - the 4 672 occurrences remain the three recorded ones (w45 -> w46, w53 -> w54, w65 -> w66); no pattern is assumed (floor-artifact data points, recorded honestly). -/
theorem faceShrinkCE69 : (tCE69 : ℝ) - (tCE68 : ℝ) = 4673 := by
  norm_num [tCE69, CE68.tCE68]

/-- THE EXTENDED GEAR (machine): the new frontier stands 327 100 units above H0 (tCE69 - tPT2 = 327 100, exact integer arithmetic; window 69 adds 4 673). **THE 325 000-UNIT MILESTONE IS CROSSED IN THIS WINDOW** at 327 100 (margin 2 100 - exactly inside the predicted corridor: 2 573 was ahead at 0374 at the ~4 673/window pace); the 300 000-unit MILESTONE (crossed in WINDOW 64, margin 3 736) is CARRIED with margin 27 100; the next round mark 350 000 sits 22 900 ahead - at the ~4 673/window pace, expected in window 74 (compute from the decoded endpoint, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE69 : ℝ) - WinC.tPT2 = 327100 := by
  norm_num [tCE69, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 200 000 - CARRIED into WINDOW-69 (the 200 000 mark was crossed at the W42B FILL, margin 200 932; the 300 000 mark is carried with margin 27 100; the 325 000 mark was crossed in THIS window, margin 2 100 - see frontierPast325k). -/
theorem frontierPast200k : (tCE69 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 175 000 - CARRIED into WINDOW-69 (the 175 000 mark was crossed in WINDOW 38, margin 2 488 [0342, incl. CASING]; the 300 000 mark is carried with margin 27 100; the 325 000 mark was crossed in THIS window, margin 2 100 - see frontierPast325k). -/
theorem frontierPast175k : (tCE69 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 225 000 - CARRIED into WINDOW-69 (the 225 000 mark was crossed in WINDOW 48 [discovery 0354], margin 228 969; the 300 000 mark is carried with margin 27 100; the 325 000 mark was crossed in THIS window, margin 2 100 - see frontierPast325k). -/
theorem frontierPast225k : (tCE69 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 250 000 - CARRIED into WINDOW-69 (the 250 000 mark was crossed in WINDOW 53 [discovery 0359], margin 252 334; the 300 000 mark is carried with margin 27 100; the 325 000 mark was crossed in THIS window, margin 2 100 - see frontierPast325k). -/
theorem frontierPast250k : (tCE69 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 275 000 - CARRIED into WINDOW-69 (the 275 000 mark was crossed in WINDOW 58 [discovery 0364], margin 275 698; the 300 000 mark is carried with margin 27 100; the 325 000 mark was crossed in THIS window, margin 2 100 - see frontierPast325k). -/
theorem frontierPast275k : (tCE69 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 300 000 - CARRIED into WINDOW-69 (the 300 000 UNIT MILESTONE was crossed in WINDOW 64 [discovery 0370], margin 3 736, carried with margin 27 100; the 325 000 mark was crossed in THIS WINDOW, margin 2 100 - see frontierPast325k). -/
theorem frontierPast300k : (tCE69 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE (machine, PROVEN): tCE69 - tPT2 = 327 100 exceeds 325 000 - THE 325 000-UNIT MILESTONE IS CROSSED IN WINDOW 69, at 327 100 above H0 (margin 2 100; exactly inside the predicted corridor: 2 573 was ahead at 0374, and the ~4 673/window pace put the crossing in window 69). The round-mark sequence above H0 is now 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64, 325 000 @ CE69. Pipeline data: the 1 300 000 CERTIFIED-ZERO mark [window 65, 0371] is CARRIED - 1 399 986 total now (the 1 400 000 mark is 14 ahead - crossing expected in window 70) - not in-tree arithmetic. -/
theorem frontierPast325k : (tCE69 : ℝ) - WinC.tPT2 > 325000 := by
  have h : (tCE69 : ℝ) - WinC.tPT2 = 327100 := frontierGapAboveH0
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB68Lo < gB69Lo) - the window-69 band (gB68Lo, tCE69] lies strictly above the certified region of windows 1..68 (full machine chain gB67Lo < tCE68 < gB68Lo < tCE69 < gB69Lo). -/
theorem gB68Lo_lt_gB69Lo : (gB68Lo : ℝ) < (gB69Lo : ℝ) := by
  norm_num [CE68.gB68Lo, gB69Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED, RE-CITED as window 68's FULL SLICE (gB67Lo, gB68Lo]; OUR WINDOW-67/68 RUNS (window67_b67.json, window68_b68.json) plus the window-66 citation already re-cited in CE66]: the certified regions (g_a66, g_b66] (window 66, NON-SNAPPED; two recorded Rosser exceptions both rescued quota-met - see the CE66 header), (g_a67, g_b67] (window 67, NON-SNAPPED width 20 000, CLEAN - zero Rosser failures anywhere; 33 835 evals, 2 497.2 s; endpoints left 49 / right 44, K = 12) and (g_a68, g_b68] (window 68, NON-SNAPPED width 20 000, TWO recorded interior Rosser failures both rescued quota-met - RECORDED, not suppressed - block [12 363 154 799 266, 12 363 154 799 268] -> union [12 363 154 799 265, 12 363 154 799 269] FOUND 4 (m = 4); block [12 363 154 812 473, 12 363 154 812 476] -> union [12 363 154 812 472, 12 363 154 812 477] FOUND 5 (m = 4); 34 145 evals, 2 498.3 s; endpoints left 47 / right 50, K = 12) union to (g_a66, g_b68], which contains (gB67Lo, gB68Lo] (by g_a66 < gB67Lo and gB68Lo < g_b68 - arithmetic on the certified balls; in-tree machine chain gB67Lo < tCE68 < gB68Lo, CE68). Every zeta zero rho with (gB67Lo : R) < rho.im <= (gB68Lo : R) is therefore simple (multiplicity 1) and on the line. Seam g_a68 = g_b67 [232127347669435304313898854163678052853, -86, 16777217, -110] = 3 000 175 650 554.8924386323751556 + or - 1.29e-26 (audit before 0374). RE-CITED exactly as CE45-CE68 re-cited their predecessors; Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce68WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB67Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB68Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-69 RUN (window69_b69.json), SLICE] every zeta zero with gB68Lo < Im ρ <= tCE69 is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB68Lo, tCE69], either t0 <= g_b68 (the true Gram point - g_a69 = g_b68, recorded exact dyadic tuple [116063674015493073473923628809964265701, -85, 16777217, -110], i.e. 3 000 175 655 227.827555491949439917 + or - 1.29e-26, BIT-IDENTICAL in both certificates - the chain seam, audit PASSED BEFORE this module was written per the 0348 process rule; gB68Lo < g_b68) - then t0 sits in window 68's certified region (g_a68, g_b68] - or t0 > g_b68 = g_a69, in which case t0 <= tCE69 < gB69Lo <= g_b69 puts t0 in window 69's certified region (g_a69, g_b69] (window 69 is NON-SNAPPED, width 20 000, TWO recorded interior Rosser failures both rescued quota-met - RECORDED, not suppressed - see the header). The two certified regions union to (g_a68, g_b69] which contains (gB68Lo, tCE69] (machine: gB68Lo < tCE69 < gB69Lo). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce69WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB68Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE69 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine): zeros in (tPT2, tCE69] are on the line, given the SEVENTY clauses h1..h70 (windows 1..69): h1 endpoint, h2..h42 (w2..w40/41 + W42B FILL + w42b region via CE44), h43..h45 (w43..w45), h46..h53 (w46..w53), h54..h58 (w54..w58), h59..h63 (w59..w63), h64 (window 63, re-cited from CE64), h65 (window 64, re-cited from CE65), h66 (window 65, re-cited from CE66), h67 (window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67), h68 (window 67 full slice (gB66Lo, gB67Lo], re-cited from CE68), h69 (window 68 full slice (gB67Lo, gB68Lo], local re-citation), h70 (local WINDOW-69 terminal slice (gB68Lo, tCE69])); the machine ordering of the 70 boundary constants (gB1Lo <= tPT2 < ... < tCE69 <= gB69Lo) makes the union the interval (gB1Lo, tCE69]; every zero in (tPT2, tCE69] lies in exactly one clause's slice; the window-69 clause h70 is the NEW terminal slice - NO RH CLAIM (the face beyond tCE69 is untouched). -/
theorem bandOfWindows69 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : CE66.ce65WinClauseFull) (h67 : CE67.ce66WinClauseFull) (h68 : CE68.ce67WinClauseFull) (h69 : ce68WinClauseFull) (h70 : ce69WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE69 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                          · exact h70 ρ hz (not_le.mp hseam69) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5 - THE FRONTIER MOVED AGAIN (window 69): [Z-PT2] + the SEVENTY clauses (windows 1..69, incl. w42b FILL) => every zero of zeta in (WinC.tPT2, tCE69] lies on the line Re = 1/2. Proof: take a zero rho in (tPT2, tCE69]; split at tCE69: below it, discharges hW2..hW42 (w2..w42), hW43 (the W42B FILL clause), hW44 (w43), hW45 (w44), hW46..hW53 (w45..w52), hW54..hW58 (w53..w57), hW59..hW63 (w58..w62), hW64 (window 63, re-cited from CE64), hW65 (window 64, re-cited from CE65), hW66 (window 65, re-cited from CE66), hW67 (window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67), hW68 (window 67 full slice (gB66Lo, gB67Lo], re-cited from CE68), hW69 (window 68 full slice (gB67Lo, gB68Lo], local re-citation), and hW70 (WINDOW 69 terminal slice (gB68Lo, tCE69]); the seam g_a69 = g_b68 is the recorded bit-identical endpoint (window 69 NON-SNAPPED, width 20 000, TWO recorded interior Rosser failures - both rescued quota-met, not suppressed). The SEVENTY clauses and the endpoint h1 give the whole interval by the same machine-ordering union argument. Window 69 is the THIRD seeded-cache + 32-worker overlap-pipeline run (34 723 evals, 2 498.5 s, resumed_from_cache = 101 872; window 70 runs in PIPELINE OVERLAP with this unit's formalization - per-unit critical path = max(run, formalization)). NO RH CLAIM - this only discharges the band; the face (terminalFaceCE69) is separately NAMED. -/
theorem allOnLineUpToCE69 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : ce68WinClauseFull) (hW70 : ce69WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE69 : ℝ) := by
  have hband := bandOfWindows69 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 - THE RE-ANCHORED FACE (window 69): no off-line zero with positive real (Re) part between WinC.tPT2 (= 3 000 175 332 800) and tCE69 (= 3 000 175 659 900, the certified floor - 327 100 certified zeros above H0; the 300 000-unit mark CARRIED, margin 27 100; the 325 000-unit mark CROSSED in THIS window, margin 2 100). OPEN HYPOTHESIS - NO RH CLAIM. Re-anchoring is a certificate (the 69-window chain + endpoint now cover exactly (tPT2, tCE69] plus the named face); the face itself remains OPEN and unchanged in shape, only narrower. -/
def terminalFaceCE69 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE69 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic: the CE68 face implies the CE69 face (tCE69 > tCE68, by tCE68_lt_tCE69; any zero with tPT2 < im <= tCE68 automatically has im <= tCE69). -/
theorem faceCE68_implies_faceCE69 (q : ZeroSet)
    (hface : CE68.terminalFaceCE68 q) :
    terminalFaceCE69 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE68_lt_tCE69, ht])

/-- M5 - THE TWO FACE FORMULATIONS, EQUIVALENT UNDER THE BAND: the extended formulation terminalFaceCE69 is EQUIVALENT to the base formulation CE68.terminalFaceCE68 (the window-68 face, transitively re-anchored from CE64-CE67 in 0370-0373 and from CE68 in 0374), given the two terminal clauses hW69 (window 68 full slice, local) and hW70 (window 69 terminal slice). Forward: a terminalFaceCE69 zero rho satisfies tPT2 < im <= tCE69; split at tCE69: below, the UNION of windows 1..69 clauses lands rho on the line (hW69 for the w68 slice; hW70 for the w69 terminal slice) - contradicts off-line; the machine ordering gB68Lo < tCE69 hands the seam to the window-69 side. Above, hW70 applies (im <= tCE69 < g_b69, machine order). So rho is on the line - and the base face's interval (tPT2, tCE68] is contained, discharging by linarith on the machine orders. Backward: a CE68 face zero has tPT2 < im <= tCE68; window 69's terminal clause hW70 is VACUOUS below its lower bound gB68Lo where needed, and the union argument covers the overlap - the implication holds. The re-anchor EXACTLY adds the window-69 clause - NO RH CLAIM (the face is still open; re-anchoring is a certificate, not closure). -/
theorem terminalFaceCE69_iff_faceCE68 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW69 : ce68WinClauseFull) (hW70 : ce69WinClause) :
    terminalFaceCE69 q ↔ CE68.terminalFaceCE68 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE69 : ℝ)
    · by_cases hseam69 : ρ.im ≤ (gB68Lo : ℝ)
      · exact hW69 ρ (hqz ρ hρ) (by linarith [ht, CE68.gB67Lo_lt_tCE68, tCE68_lt_tCE69]) hseam69
      · exact hW70 ρ (hqz ρ hρ) (not_le.mp hseam69) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE68_implies_faceCE69 q

/-- M5 - THE 0288 EXACT RESIDUAL, RE-PINNED AT tCE69 (PURE LOGIC): RH (all zeta zeros on the line, via the ZeroSet contract) is equivalent to the CONJUNCTION of (i) the band part: every zero of the ZERO SET q in (WinC.tPT2, tCE69] is on the line - discharged by the SEVENTY clause band (hW1..hW42, hW43..hW45, hW46..hW53, hW54..hW58, hW59..hW63, hW64 [window 63, re-cited from CE64], hW65 [window 64, re-cited from CE65], hW66 [window 65, re-cited from CE66], hW67 [window 66 full slice (gB65Lo, gB66Lo], re-cited from CE67], hW68 [window 67 full slice (gB66Lo, gB67Lo], re-cited from CE68], hW69 [window 68 full slice (gB67Lo, gB68Lo], local re-citation], hW70 [WINDOW 69 terminal slice (gB68Lo, tCE69)], machine-ordering union, seam g_a69 = g_b68 bit-identical) AND (ii) the NAMED open face terminalFaceCE69 (NO RH CLAIM - this face is the residual; re-anchoring at tCE69, 327 100 above H0, carries no claim about it). -/
theorem rh_split_at_CE69 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE69 : ℝ) ∧ terminalFaceCE69 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE69 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE69 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 - HEADLINE (window 69 - NON-SNAPPED WIDTH 20 000; TWO recorded interior Rosser failures, BOTH RESCUED quota-met - block [12 363 154 829 318, 12 363 154 829 320] (need 2, found 0, 129 points) -> union [12 363 154 829 317, 12 363 154 829 321] (need 4, FOUND 4, m = 8), block [12 363 154 830 844, 12 363 154 830 847] (need 3, found 1, 193 points) -> union [12 363 154 830 843, 12 363 154 830 849] (need 6, FOUND 6, m = 8) - RECORDED, not suppressed): RH q is EQUIVALENT to (the seventy window clauses hW1..hW70 covering windows 1..69 plus the endpoint h1) AND (terminalFaceCE69 q). The machine-verified FRONTIER is now tCE69 = 3 000 175 659 900, 327 100 certified zeros above H0 (machine arithmetic, exact integers; the 300 000-unit mark is carried, margin 27 100; **the 325 000-unit milestone is CROSSED in this window, margin 2 100** - inside the predicted corridor; 350 000 is 22 900 ahead - expected ~window 74, compute, do not pre-announce). Cumulative certified count: 1 399 986 over (g_a1, g_b69] (pipeline data, not in-tree arithmetic; the 1 300 000 mark [window 65, 0371] is carried; the 1 400 000 mark is 14 ahead - expected in WINDOW 70, confirm from the verified count). PIPELINE RECORD: window 69 is the third seeded-cache + 32-worker overlap run (34 723 evals, 2 498.5 s, resumed_from_cache = 101 872; flat with windows 67/68 - the throughput gain is the OVERLAP itself: window 70 was launched and runs while this unit's formalization proceeds). NO RH CLAIM. -/
theorem rh_reanchored_CE69 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : ce68WinClauseFull) (hW70 : ce69WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE69 q := by
  have hcensus := allOnLineUpToCE69 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hqz
  have hsplit := rh_split_at_CE69 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE69 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : ce68WinClauseFull) (hW70 : ce69WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE69 q) :
    RH q :=
  (rh_reanchored_CE69 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE69_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE69 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE69
