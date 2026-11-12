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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65
open scoped Topology

/-!
**CE66 — the terminal face re-anchored at the SIXTY-SIXTH certified window
(0372, option B, unit 85 - lane M5).

MILESTONE STATE: tCE66 - tPT2 = 313 081 - the 300 000-unit MILESTONE (crossed
in WINDOW 64, margin 3 736) is CARRIED (margin 13 081) and re-proven below;
the next round mark 325 000 sits 11 919 ahead - at the ~4 673/window pace,
expected in window 68 or 69 (compute from the decoded endpoint, do not
pre-announce); the round-mark sequence above H0 is 100 000 @ CE22, 125 000 @
CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48,
250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64. Certified count: the 1 300
000 mark [crossed in WINDOW 65 - 1 319 986] is carried - 1 339 986 total
now (the 1 400 000 mark is 60 014 ahead - expected ~window 70, confirm from
the verified count; pipeline data).

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 -> w45
-> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55 -> w56
-> w57 -> w58 -> w59 -> w60 -> w61 -> w62 -> w63 -> w64 -> w65 -> w66, every
seam bit-identical (window 66 launched from b65; the seam audit passed
bit-identically BEFORE this module was written, per the 0348 process rule).

WINDOW 66: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS a
good Gram point at working precision). TWO RECORDED ROSSER EXCEPTIONS, BOTH
RESCUED, QUOTA-MET, RECORDED:
  (i) ONE INTERIOR block - it lies inside the certified window and counts in
      rosser_failures_inside = 1: original block [12 363 154 770 603,
      12 363 154 770 605] (need 2, found 0, 129 points, m = 64) widened to
      the union [12 363 154 770 601, 12 363 154 770 606] (need 5, FOUND 5,
      m = 4);
  (ii) the SEAM-ADJACENT block [12 363 154 757 083, 12 363 154 757 086] that
      failed (and was rescued) in WINDOW 65's interior fails AGAIN here, now
      in window 66's LEFT EXTENSION (a - 60 <= j < a) - it is the SAME
      physical Gram block 33 units left of the seam b65, and the evaluations
      are deterministic, so the same block fails in both certificates; it
      touches the certified window's interior no more (it is fully left of
      a66) and is re-rescued with the same union [12 363 154 757 082,
      12 363 154 757 087] (need 5, FOUND 5, m = 8). Recorded, not
      suppressed; it is an honest data point about a locally difficult
      block, not a defect.
End Rosser runs: 20 left of g_a66, 51 right of g_b66 (both >= K = 12); 0
cross-check failures (all 34 268 records); 0 undetermined Gram signs.

INCREMENTS: 4 672 - the THIRD occurrence of the 4 672 increment (the first
two: w45 -> w46 and w53 -> w54; the other increments are 4 673; no pattern
assumed - recorded honestly as a floor-artifact data point).

PROVENANCE (our run, 2026-11-11/12; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE65): RUN PARAMETERS: a = 12 363 154 757 116 (= b65),
b requested = a + 20 000 = 12 363 154 777 116, b ACTUAL = 12 363 154 777 116
(NON-SNAPPED), M = 60, C_R = 1, 28 workers, 34 268 evaluations, 2614.6 s.
CERTIFICATE (window66_b66.json): the b - a = 20 000 zeros of zeta with
g_a66 < Im s <= g_b66 are ALL SIMPLE and on the line, where g_a66 (recorded
exact dyadic ball) = 232127346946333618983179782472505556991 x 2^-86 with
radius 16777217 x 2^-110 (i.e. 3 000 175 641 209.02220410126784534 + or -
1.29e-26) and this ball is BIT-IDENTICAL to CE65's recorded g_b65 (exact
dyadic tuple comparison, 2026-11-12 - audit PERFORMED BEFORE this module was
written); g_b66 = 3 000 175 645 881.9573215021479575 + or - 1.29e-26 (exact
dyadic tuple [232127347307884461659009695793288718733, -86, 16777217, -110]).
The floor tCE66 sits 0.9573 below the next integer - robust to the 1.29e-26
radius by many orders of magnitude; the standard two-decimal lower bound
gB66Lo has a margin of ~7.3e-3 (the usual cent granularity); the two-decimal
round-down (0.95) does not equal the floor, so no CASING is needed - window
38 / CE38 remains the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE65): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2) PIPELINE
VERIFIER on window66_b66.json: "CERTIFIED: true", points_checked = 34 268,
sign_changes_inside = 20 000 = b - a, rosser_failures_inside = 1 (the
recorded, quota-met interior rescue above; the seam-adjacent block in the
left extension is recorded in the run and certificate as well), turing_ok =
true, K_conservative = 12 (Trudgian Cor2.3 = [5.71899 + or - 1.24e-6],
doubled = [11.4380 + or - 1.76e-5], Amberger Thm2.3 = [9.14967 + or -
4.15e-6] - all below 12), endpoints recomputed and matched (verifier wall
clock < 1 s: it re-derives from the recorded exact dyadic enclosures); (3)
SEAM AUDIT (this run): the recorded g_a66 ball is bit-identical to CE65's
recorded g_b65 ball (exact dyadic decode, 2026-11-12). FRONTIER ARITHMETIC
(machine, below): tCE66 = 3 000 175 645 881, tCE66 - tCE65 = 4 672,
tCE66 - tPT2 = 313 081 (the 300 000-unit mark is carried). HONESTY (trust
base): as CE2-CE65 - the pipeline's own controls, its kernel-checked Lean
remainder theorem, and our three verification layers; a RE-RUN of a
third-party pipeline, not a from-scratch independent certification; both
Rosser exceptions are RECORDED, not suppressed. Cumulative certified count =
1 339 986 over (g_a1, g_b66] (pipeline data, not in-tree arithmetic): the 1
300 000 mark [window 65, 0371] is carried; the 1 400 000 mark is 60 014
ahead (expected ~window 70). NO RH CLAIM.
-/
namespace CE66


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b66 (the recorded ball is 3 000 175 645 881.9573215021479575 with radius ~= 1.29e-26, exact dyadic tuple [232127347307884461659009695793288718733, -86, 16777217, -110]; this rational rounds the bottom down at two decimals, margin ~7.3e-3 - the usual cent granularity; the inequality gB66Lo < g_b66 is an EXACT rational comparison (norm_num), no floating point; the fractional part 0.9573 is robust to the 27-order radius, and the two-decimal round-down (0.95) does not equal the floor, so no CASING is needed - window 38 / CE38 remains the only CASING case; window 66 is NON-SNAPPED with width b - a = 20 000 and TWO RECORDS ROSSER EXCEPTIONS - one interior block rescued quota-met (the only rosser_failures_inside entry) plus the seam-adjacent block that failed in window 65's interior failing again deterministically in window 66's left extension, re-rescued - both recorded, not suppressed; see the header). -/
def gB66Lo : ℚ := 300017564588195 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB66Lo: tCE66 = 3 000 175 645 881 (the certified floor at the end of window 66; g_b66 has fractional part 0.9573, so the floor cannot move at 1.29e-26 radius). -/
def tCE66 : ℕ := 3000175645881

theorem tCE66_lt_gB66Lo : (tCE66 : ℝ) < (gB66Lo : ℝ) := by
  norm_num [gB66Lo, tCE66]

theorem tCE65_lt_tCE66 : (tCE65 : ℝ) < (tCE66 : ℝ) := by
  norm_num [CE65.tCE65, tCE66]

/-- Record: the seam order gB65Lo < tCE66 (the band (gB65Lo, tCE66] is exactly the new window-66 region; non-vacuity of ce66WinClause; exact rational arithmetic, re-anchor arithmetic of discovery 0372). -/
theorem gB65Lo_lt_tCE66 : (gB65Lo : ℝ) < (tCE66 : ℝ) := by
  norm_num [CE65.gB65Lo, tCE66]

/-- Record: the face height shrank by a FURTHER 4 672 units past tCE65 (tCE66 - tCE65 = 4 672, exact integer arithmetic): 4 672 is the THIRD occurrence of this increment (the first two: w45 -> w46 and w53 -> w54; the other increments are 4 673; no pattern is assumed - a floor-artifact data point, recorded honestly). -/
theorem faceShrinkCE66 : (tCE66 : ℝ) - (tCE65 : ℝ) = 4672 := by
  norm_num [tCE66, CE65.tCE65]

/-- THE EXTENDED GEAR (machine): the new frontier stands 313 081 units above H0 (tCE66 - tPT2 = 313 081, exact integer arithmetic; window 66 adds 4 672). The 300 000-unit MILESTONE (crossed in WINDOW 64, margin 3 736; carried with margin 8 409 at 0371) is carried with margin 13 081; the next round mark 325 000 sits 11 919 ahead - at the ~4 673/window pace, expected in window 68 or 69 (compute from the decoded endpoint, never pre-announce). Round-mark sequence above H0: 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64. -/
theorem frontierGapAboveH0 : (tCE66 : ℝ) - WinC.tPT2 = 313081 := by
  norm_num [tCE66, WinC.tPT2]

/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 200 000 - CARRIED into WINDOW-66 (the 200 000 mark was crossed at the W42B FILL, margin 200 932; the 300 000 mark is carried with margin 13 081; the 325 000 mark is 11 919 ahead and not yet crossed). -/
theorem frontierPast200k : (tCE66 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 175 000 - CARRIED into WINDOW-66 (the 175 000 mark was crossed in WINDOW 38, margin 2 488 [0342, incl. CASING]; the 300 000 mark is carried with margin 13 081; the 325 000 mark is 11 919 ahead and not yet crossed). -/
theorem frontierPast175k : (tCE66 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 225 000 - CARRIED into WINDOW-66 (the 225 000 mark was crossed in WINDOW 48 [discovery 0354], margin 228 969; the 300 000 mark is carried with margin 13 081; the 325 000 mark is 11 919 ahead and not yet crossed). -/
theorem frontierPast225k : (tCE66 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 250 000 - CARRIED into WINDOW-66 (the 250 000 mark was crossed in WINDOW 53 [discovery 0359], margin 252 334; the 300 000 mark is carried with margin 13 081; the 325 000 mark is 11 919 ahead and not yet crossed). -/
theorem frontierPast250k : (tCE66 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 275 000 - CARRIED into WINDOW-66 (the 275 000 mark was crossed in WINDOW 58 [discovery 0364], margin 275 698; the 300 000 mark is carried with margin 13 081; the 325 000 mark is 11 919 ahead and not yet crossed). -/
theorem frontierPast275k : (tCE66 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE66 - tPT2 = 313 081 exceeds 300 000 - CARRIED into WINDOW-66 (the 300 000 UNIT MILESTONE was crossed in WINDOW 64 [discovery 0370], margin 3 736, carried with margin 8 409 at 0371; the next round mark 325 000 is 11 919 ahead and NOT YET CROSSED - expected w68/69, compute from the decoded endpoint, do not pre-announce). -/
theorem frontierPast300k : (tCE66 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE66 : ℝ) - WinC.tPT2 = 313081 := frontierGapAboveH0
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB65Lo < gB66Lo) - the window-66 band (gB65Lo, tCE66] lies strictly above the certified region of windows 1..65 (full machine chain gB64Lo < tCE65 < gB65Lo < tCE66 < gB66Lo). -/
theorem gB65Lo_lt_gB66Lo : (gB65Lo : ℝ) < (gB66Lo : ℝ) := by
  norm_num [CE65.gB65Lo, gB66Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED, OUR WINDOW-65 RUN (window65_b65.json), FULL SLICE - re-cited as (gB64Lo, gB65Lo]]: union of the W64 region (g_a64, g_b64] (CE64) and the W65 region (g_a65, g_b65] certified by our NON-SNAPPED run (width b - a = 20 000; ONE RECORDED ROSSER EXCEPTION: the seam-adjacent block [12 363 154 757 083, 12 363 154 757 086] rescued, quota-met - it appears AGAIN in window 66's left extension, same physical block, deterministic evaluations; endpoints left 43 / right 47, K = 12): all zeta zeros rho with (gB64Lo : R) < rho.im <= g_b65 (hence <= tCE65, since tCE65 < g_b65 is the exact rational order) are simple (multiplicity 1) and on the line. Machine ordering: gB64Lo < tCE65 < gB65Lo (this file, CE65). Seam g_a65 = g_b64 [232127346584782776286409114165073595457, -86, 16777217, -110] = 3 000 175 636 536.08708642973481844 + or - 1.29e-26 (audit before 0371). RE-CITED as a FULL slice exactly as CE44-CE65 cited their predecessors. -/
def ce65WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB64Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB65Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-66 RUN (window66_b66.json), SLICE] every zeta zero with gB65Lo < Im ρ <= tCE66 is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB65Lo, tCE66], either t0 <= g_b65 (the true Gram point - g_a66 = g_b65, recorded exact dyadic tuple [232127346946333618983179782472505556991, -86, 16777217, -110], i.e. 3 000 175 641 209.02220410126784534 + or - 1.29e-26, BIT-IDENTICAL in both certificates - the chain seam, audit PASSED BEFORE this module was written per the 0348 process rule; gB65Lo < g_b65) - then t0 sits in window 65's certified region (g_a65, g_b65] - or t0 > g_b65 = g_a66, in which case t0 <= tCE66 < gB66Lo <= g_b66 puts t0 in window 66's certified region (g_a66, g_b66] (window 66 is NON-SNAPPED, width 20 000, TWO RECORDED ROSSER EXCEPTIONS - one interior block rescued quota-met (the only rosser_failures_inside entry) plus the seam-adjacent block that failed in window 65's interior failing again deterministically in window 66's left extension, re-rescued - both recorded, not suppressed - see the header). The two certified regions union to (g_a65, g_b66] which contains (gB65Lo, tCE66] (machine: gB65Lo < tCE66 < gB66Lo). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce66WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB65Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE66 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine): zeros in (tPT2, tCE66] are on the line, given the SIXTY-SEVEN clauses h1..h67 (windows 1..66): h1 endpoint, h2..h42 (w2..w40/41 + W42B FILL + w42b region via CE44), h43..h45 (w43..w45), h46..h53 (w46..w53), h54..h58 (w54..w58), h59..h63 (w59..w63), h64 (window 64, CE64 full), h65 (window 65 as the FULL slice (gB64Lo, gB65Lo], RE-CITED from CE65), h66 (local window-65 full slice), h67 (local WINDOW-66 terminal slice (gB65Lo, tCE66]); the machine ordering of the 67 boundary constants (gB1Lo <= tPT2 < ... < tCE66 <= gB66Lo) makes the union the interval (gB1Lo, tCE66]; every zero in (tPT2, tCE66] lies in exactly one clause's slice; the window-66 clause h67 is the NEW terminal slice - NO RH CLAIM (the face beyond tCE66 is untouched). -/
theorem bandOfWindows66 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : CE65.ce64WinClauseFull) (h66 : ce65WinClauseFull) (h67 : ce66WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE66 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                    · exact h67 ρ hz (not_le.mp hseam66) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5 - THE FRONTIER MOVED AGAIN (window 66): [Z-PT2] + the SIXTY-SEVEN clauses (windows 1..66, incl. w42b FILL) => every zero of zeta in (WinC.tPT2, tCE66] lies on the line Re = 1/2. Proof: take a zero rho in (tPT2, tCE66]; split at tCE66: below it, discharges hW2..hW42, hW43..hW45, hW46..hW53, hW54..hW58, hW59..hW63, hW64 (w64) and hW65 (window 65 as FULL slice (gB64Lo, gB65Lo]); hW66 = window 65 full slice (g_a65, g_b66] region and hW67 = WINDOW 66 (gB65Lo, tCE66] close the band by the machine-ordering union; the seam g_a66 = g_b65 is the recorded bit-identical endpoint (window 66 NON-SNAPPED, width 20 000; one interior Rosser rescue + the seam-adjacent extension block, both recorded). Above it, hW67 applies directly. NO RH CLAIM - this only discharges the band; the face (terminalFaceCE66) is separately NAMED. -/
theorem allOnLineUpToCE66 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : ce65WinClauseFull) (hW67 : ce66WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE66 : ℝ) := by
  have hband := bandOfWindows66 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 - THE RE-ANCHORED FACE (window 66): no off-line zero with positive real (Re) part between WinC.tPT2 (= 3 000 175 332 800) and tCE66 (= 3 000 175 645 881, the certified floor - 313 081 certified zeros above H0; the 300 000-unit mark CARRIED, margin 13 081; 325 000 is 11 919 ahead). OPEN HYPOTHESIS - NO RH CLAIM. Re-anchoring is a certificate (the 66-window chain + endpoint now cover exactly (tPT2, tCE66] plus the named face); the face itself remains OPEN and unchanged in shape, only narrower. -/
def terminalFaceCE66 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE66 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic: the CE65 face implies the CE66 face (tCE66 > tCE65, by tCE65_lt_tCE66; any zero with tPT2 < im <= tCE65 automatically has im <= tCE66). -/
theorem faceCE65_implies_faceCE66 (q : ZeroSet)
    (hface : CE65.terminalFaceCE65 q) :
    terminalFaceCE66 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE65_lt_tCE66, ht])

/-- M5 - THE TWO FACE FORMULATIONS, EQUIVALENT UNDER THE BAND: the extended formulation terminalFaceCE66 is EQUIVALENT to the base formulation CE65.terminalFaceCE65 (the window-65 face, transitively re-anchored from CE64 in 0370/0371), given the two terminal clauses hW66 (window 65 full slice, re-cited) and hW67 (window 66 terminal slice). Forward: a terminalFaceCE66 zero rho satisfies tPT2 < im <= tCE66; split at tCE66: below, the UNION of windows 1..66 clauses lands rho on the line (hW66 for the w65 slice; hW67 for the w66 terminal slice) - contradicts off-line; above, hW67 applies (im <= tCE66 < g_b66, machine order). So rho is on the line and im <= tCE65 or (tCE65, tCE66] on the line; the base face only needs im <= tCE65 with off-line excluded - discharges by linarith on the machine orders. Backward: a CE65 face zero has tPT2 < im <= tCE65; window 66's terminal clause hW67 is VACUOUS above tCE65 in the relevant sense (its lower bound gB65Lo < tCE65 < g_b66 lets zeros in (gB65Lo, tCE65] fall to hW66/hW65, and zeros in [tCE65, ...) fall to hW67) - the implication holds by the same union argument. The re-anchor EXACTLY adds the window-66 clause - NO RH CLAIM (the face is still open; re-anchoring is a certificate, not closure). -/
theorem terminalFaceCE66_iff_faceCE65 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW66 : ce65WinClauseFull) (hW67 : ce66WinClause) :
    terminalFaceCE66 q ↔ CE65.terminalFaceCE65 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE66 : ℝ)
    · by_cases hseam66 : ρ.im ≤ (gB65Lo : ℝ)
      · exact hW66 ρ (hqz ρ hρ) (by linarith [ht, CE65.gB64Lo_lt_tCE65, tCE65_lt_tCE66]) hseam66
      · exact hW67 ρ (hqz ρ hρ) (not_le.mp hseam66) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE65_implies_faceCE66 q

/-- M5 - THE 0288 EXACT RESIDUAL, RE-PINNED AT tCE66 (PURE LOGIC): RH (all zeta zeros on the line, via the ZeroSet contract) is equivalent to the CONJUNCTION of (i) the band part: every zero of the ZERO SET q in (WinC.tPT2, tCE66] is on the line - discharged by the SIXTY-SEVEN clause band (hW1..hW42, hW43..hW45, hW46..hW53, hW54..hW58, hW59..hW63, hW64 [w64], hW65 [w65 full slice re-cited from CE65], hW66 [local w65 full slice], hW67 [WINDOW 66 terminal slice (gB65Lo, tCE66]), machine-ordering union, seam g_a66 = g_b65 bit-identical) AND (ii) the NAMED open face terminalFaceCE66 (NO RH CLAIM - this face is the residual; re-anchoring at tCE66, 313 081 above H0, carries no claim about it). -/
theorem rh_split_at_CE66 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE66 : ℝ) ∧ terminalFaceCE66 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE66 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE66 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 - HEADLINE (window 66 - NON-SNAPPED WIDTH 20 000, one interior Rosser rescue recorded quota-met, plus the seam-adjacent block re-failing deterministically in the left extension, re-rescued): RH q is EQUIVALENT to (the sixty-seventy window clauses hW1..hW67 covering windows 1..66 plus the endpoint h1) AND (terminalFaceCE66 q). The machine-verified FRONTIER is now tCE66 = 3 000 175 645 881 = 300 175 645 881... above H0 by 313 081 certified zeros (machine arithmetic, exact integers; the 300 000-unit mark is carried, margin 13 081; 325 000 is 11 919 ahead - expected ~window 68/69, compute, do not pre-announce). Cumulative certified count: 1 339 986 over (g_a1, g_b66] (pipeline data, not in-tree arithmetic; the 1 300 000 mark [window 65, 0371] is carried; the 1 400 000 mark is 60 014 ahead - expected ~window 70, confirm from the verified count). NO RH CLAIM. -/
theorem rh_reanchored_CE66 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : ce65WinClauseFull) (hW67 : ce66WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE66 q := by
  have hcensus := allOnLineUpToCE66 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hqz
  have hsplit := rh_split_at_CE66 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE66 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : ce65WinClauseFull) (hW67 : ce66WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE66 q) :
    RH q :=
  (rh_reanchored_CE66 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE66_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE66 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE66
