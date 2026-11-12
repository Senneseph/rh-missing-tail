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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64
open scoped Topology

/-!
**CE65 — the terminal face re-anchored at the SIXTY-FIFTH certified window
(0371, option B, unit 84 - lane M5).

MILESTONE STATE: tCE65 - tPT2 = 308 409 - the 300 000-unit MILESTONE (crossed
in WINDOW 64, margin 3 736 - frontierPast300k) is CARRIED (margin 8 409) and
re-proven below; the next round mark 325 000 sits 16 591 ahead - at the
~4 673/window pace, expected in window 69 (compute from the decoded endpoint,
do not pre-announce); the round-mark sequence above H0 is 100 000 @ CE22,
125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @
CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64. Certified count: the
1 200 000 mark [crossed in WINDOW 60] is carried; **THE 1 300 000
CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65 - 1 319 986 total now** (as
predicted in 0370: 1 299 986 + 20 000; pipeline data).

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 -> w45
-> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55 -> w56
-> w57 -> w58 -> w59 -> w60 -> w61 -> w62 -> w63 -> w64 -> w65, every seam
bit-identical (window 65 launched from b64; the seam audit passed
bit-identically BEFORE this module was written, per the 0348 process rule).

WINDOW 65: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS a
good Gram point at working precision). ONE INTERNAL ROSSER EXCEPTION,
RESCUED, QUOTA-MET, RECORDED (an interior block - it touches neither end
Rosser run): original block [12 363 154 757 083, 12 363 154 757 086]
(need 3, found 1, 193 points, m = 64) widened to the union [12 363 154
757 082, 12 363 154 757 087] (need 5, FOUND 5, m = 8). End Rosser runs: 43
left of g_a65, 47 right of g_b65 (both >= K = 12); 0 cross-check failures
(all 33 892 records); 0 undetermined Gram signs.

INCREMENTS: 4 673 - the standing pace continues (the two isolated 4 672's at
w45 -> w46 and w53 -> w54 remain honest data points; no pattern assumed).

PROVENANCE (our run, 2026-11-11; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE64): RUN PARAMETERS: a = 12 363 154 737 116 (= b64),
b requested = a + 20 000 = 12 363 154 757 116, b ACTUAL = 12 363 154 757 116
(NON-SNAPPED), M = 60, C_R = 1, 28 workers, 33 892 evaluations, 2780.3 s.
CERTIFICATE (window65_b65.json): the b - a = 20 000 zeros of zeta with
g_a65 < Im s <= g_b65 are ALL SIMPLE and on the line, where g_a65 (recorded
exact dyadic ball) = 232127346584782776286409114165073595457 x 2^-86 with
radius 16777217 x 2^-110 (i.e. 3 000 175 636 536.08708642973481849 + or -
1.29e-26) and this ball is BIT-IDENTICAL to CE64's recorded g_b64 (exact
dyadic tuple comparison, 2026-11-11 - audit PERFORMED BEFORE this module was
written); g_b65 = 3 000 175 641 209.022204101267845344 + or - 1.29e-26 (exact
dyadic tuple [232127346946333618983179782472505556991, -86, 16777217, -110]).
The floor tCE65 sits 0.0222 above the previous integer - robust to the
1.29e-26 radius by many orders of magnitude; the standard two-decimal lower
bound gB65Lo has a margin of ~2.2e-3 - a thin margin (thinner than usual,
recorded honestly); the inequality gB65Lo < g_b65 is an EXACT rational
comparison proved by norm_num, no floating point involved, so the thin
margin has no effect on the formal content; the two-decimal round-down
(0.02) does not equal the floor, so no CASING is needed - window 38 / CE38
remains the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE64): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2) PIPELINE
VERIFIER on window65_b65.json: "CERTIFIED: true", points_checked = 33 892,
sign_changes_inside = 20 000 = b - a, roesser_failures_inside = 1 (the
recorded, quota-met interior rescue above), turing_ok = true,
K_conservative = 12 (Trudgian Cor2.3 = [5.71899 + or - 1.24e-6], doubled =
[11.4380 + or - 1.76e-5], Amberger Thm2.3 = [9.14967 + or - 4.15e-6] - all
below 12), endpoints recomputed and matched; (3) SEAM AUDIT (this run): the
recorded g_a65 ball is bit-identical to CE64's recorded g_b64 ball (exact
dyadic decode, 2026-11-11). FRONTIER ARITHMETIC (machine, below): tCE65 =
3 000 175 641 209, tCE65 - tCE64 = 4 673, tCE65 - tPT2 = 308 409 (the 300
000-unit mark is carried). HONESTY (trust base): as CE2-CE64 - the
pipeline's own controls, its kernel-checked Lean remainder theorem, and our
three verification layers; a RE-RUN of a third-party pipeline, not a
from-scratch independent certification; the one Rosser exception is
RECORDED, not suppressed. Cumulative certified count = 1 319 986 over
(g_a1, g_b65] (pipeline data, not in-tree arithmetic): **THE 1 300 000
CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65** (as predicted in 0370); the
1 200 000 mark [window 60, 0366] is carried. NO RH CLAIM.
-/
namespace CE65


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b65 (the recorded ball is 3 000 175 641 209.02220410126784534 with radius ~= 1.29e-26; this rational rounds the bottom down at two decimals, margin ~2.2e-3 - a thin margin, recorded honestly; the inequality gB65Lo < g_b65 is an EXACT rational comparison (norm_num), no floating point; window 65 is NON-SNAPPED with one recorded interior Rosser rescue - see the header). -/
def gB65Lo : ℚ := 300017564120902 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB65Lo: tCE65 = 3 000 175 641 209. -/
def tCE65 : ℕ := 3000175641209

theorem tCE65_lt_gB65Lo : (tCE65 : ℝ) < (gB65Lo : ℝ) := by
  norm_num [gB65Lo, tCE65]

theorem tCE64_lt_tCE65 : (tCE64 : ℝ) < (tCE65 : ℝ) := by
  norm_num [CE64.tCE64, tCE65]

/-- Record: the seam order gB64Lo < tCE65 (the band (gB64Lo, tCE65] is nonempty and lies above window 64's frontier tCE64). -/
theorem gB64Lo_lt_tCE65 : (gB64Lo : ℝ) < (tCE65 : ℝ) := by
  norm_num [CE64.gB64Lo, tCE65]

/-- Record: the face height shrank by a FURTHER 4 673 units past tCE64: the standing pace continues (the two 4 672's - w45->w46 and w53->w54 - remain isolated data points; no pattern assumed, recorded honestly). -/
theorem faceShrinkCE65 : (tCE65 : ℝ) - (tCE64 : ℝ) = 4673 := by
  norm_num [tCE65, CE64.tCE64]

/-- THE EXTENDED GEAR (machine): the new frontier stands 308 409 units above the Platt-Trudgian frontier H0 (window 65 is NON-SNAPPED, width 20 000, one interior Rosser exception rescued/quota-met/recorded; the 300 000-unit MILESTONE (crossed in WINDOW 64, 0370) is CARRIED (margin 8 409) - see frontierPast300k; the round-mark sequence is 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64; the next round mark 325 000 sits 16 591 ahead - at the ~4 673/window pace, expected in window 69; compute the floor when it lands, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE65 : ℝ) - WinC.tPT2 = 308409 := by
  norm_num [tCE65, WinC.tPT2]

/-- MILESTONE CARRY (machine): tCE65 - tPT2 = 308 409 exceeds 200 000 (crossed at the fill CE42B). -/
theorem frontierPast200k : (tCE65 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine): tCE65 - tPT2 = 308 409 exceeds 175 000 (the CE38 mark). -/
theorem frontierPast175k : (tCE65 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE65 - tPT2 = 308 409 exceeds 225 000 - the 225 000-unit mark (crossed in window 48, the CE48 MILESTONE unit) is carried at the new frontier; the 250 000-unit mark (window 53), the 275 000-unit mark (window 58) and the 300 000-unit mark (window 64) are likewise carried - see frontierPast250k / frontierPast275k / frontierPast300k; the 1 000 000-, 1 100 000-, 1 200 000- and 1 300 000-certified-zero marks (windows 50 / 55 / 60 / 65) are also carried - counts are pipeline data, not in-tree arithmetic. -/
theorem frontierPast225k : (tCE65 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE65 - tPT2 = 308 409 exceeds 250 000 - THE 250 000-UNIT MILESTONE (crossed in WINDOW 53, the CE53 MILESTONE unit, at 252 334) is CARRIED at the new frontier, re-proven here; the round-mark sequence above H0 is 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58, 300 000 @ CE64; the next round mark, 325 000, sits 16 591 ahead - at the ~4 673/window pace, expected in window 69 (compute from the decoded endpoint, do not pre-announce). Pipeline data: the 1 300 000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65 - 1 319 986 total now (as predicted in 0370: 1 299 986 + 20 000) - not in-tree arithmetic. -/
theorem frontierPast250k : (tCE65 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE65 - tPT2 = 308 409 exceeds 275 000 - THE 275 000-UNIT MILESTONE (crossed in WINDOW 58, the CE58 MILESTONE unit, at 275 698, margin 698) is CARRIED at the new frontier (margin 33 409), re-proven here. Pipeline data: THE 1 300 000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65 - 1 319 986 total now (as predicted in 0370) - not in-tree arithmetic. -/
theorem frontierPast275k : (tCE65 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE65 - tPT2 = 308 409 exceeds 300 000 - THE 300 000-UNIT MILESTONE (crossed in WINDOW 64, the CE64 MILESTONE unit, at 303 736, margin 3 736) is CARRIED at the new frontier (margin 8 409), re-proven here; the next round mark 325 000 sits 16 591 ahead (expected ~window 69 - compute, do not pre-announce). Pipeline data: THE 1 300 000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65 - 1 319 986 total now - not in-tree arithmetic. -/
theorem frontierPast300k : (tCE65 : ℝ) - WinC.tPT2 > 300000 := by
  have h : (tCE65 : ℝ) - WinC.tPT2 = 308409 := frontierGapAboveH0
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB64Lo < gB65Lo) - the window-64 band (gB64Lo, gB65Lo] lies strictly above window 63's certified region (gB63Lo, gB64Lo]. -/
theorem gB64Lo_lt_gB65Lo : (gB64Lo : ℝ) < (gB65Lo : ℝ) := by
  norm_num [CE64.gB64Lo, gB65Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED, OUR WINDOW-64 RUN (window64_b64.json), FULL SLICE - re-cited at the CE65 level] every zeta zero with gB63Lo < Im ρ <= gB64Lo is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB63Lo, gB64Lo], either t0 <= g_b63 (g_a64 = g_b63 - the chain seam, recorded exact dyadic tuple [232127346223231933568697690834737861837, -86, 16777217, -110], audit PASSED BEFORE CE64 was written) - then t0 sits in window 63's certified region (g_a63, g_b63] (window 63 is SNAPPED DOWN by 1, width 19 999, ONE interior Rosser exception rescued, quota-met, recorded - see the CE63 header) - or t0 > g_b63 = g_a64, in which case t0 <= gB64Lo <= g_b64 puts t0 in window 64's certified region (g_a64, g_b64] (window 64 is NON-SNAPPED, width 20 000, CLEAN - zero internal Rosser failures - see the CE64 header). The two certified regions union to (g_a63, g_b64] which contains (gB63Lo, gB64Lo] (machine: gB63Lo < tCE64 < gB64Lo, the window-64 ordering as proven within CE64). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce64WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB63Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB64Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-65 RUN (window65_b65.json), SLICE] every zeta zero with gB64Lo < Im ρ <= tCE65 is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB64Lo, tCE65], either t0 <= g_b64 (the true Gram point - g_a65 = g_b64, recorded exact dyadic tuple [232127346584782776286409114165073595457, -86, 16777217, -110], i.e. 3 000 175 636 536.08708642973481849 + or - 1.29e-26, BIT-IDENTICAL in both certificates - the chain seam, audit PASSED BEFORE this module was written per the 0348 process rule; gB64Lo < g_b64) - then t0 sits in window 64's certified region (g_a64, g_b64] - or t0 > g_b64 = g_a65, in which case t0 <= tCE65 < gB65Lo <= g_b65 puts t0 in window 65's certified region (g_a65, g_b65] (window 65 is NON-SNAPPED, width 20 000, ONE interior Rosser exception rescued, quota-met, recorded - see the header). The two certified regions union to (g_a64, g_b65] which contains (gB64Lo, tCE65] (machine: gB64Lo < tCE65 < gB65Lo). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce65WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB64Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE65 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine): zeros in (tPT2, tCE65] are on the line, given the sixty-six window clauses (windows 1 through 42, the fill, windows 43 through 64 [full slices], and window 65 [terminal slice]) - the splits at gA2Hi, gB2Lo, ..., gB42Lo, gB42BLo, gB43Lo, gB44Lo, gB45Lo, gB46Lo, gB47Lo, gB48Lo, gB49Lo, gB50Lo, gB51Lo, gB52Lo, gB53Lo, gB54Lo, gB55Lo, gB56Lo, gB57Lo, gB58Lo, gB59Lo, gB60Lo, gB61Lo, gB62Lo, gB63Lo, gB64Lo are pure case splits. -/
theorem bandOfWindows65 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : CE58.ce57WinClauseFull) (h59 : CE59.ce58WinClauseFull) (h60 : CE60.ce59WinClauseFull) (h61 : CE61.ce60WinClauseFull) (h62 : CE62.ce61WinClauseFull) (h63 : CE63.ce62WinClauseFull) (h64 : CE64.ce63WinClauseFull) (h65 : ce64WinClauseFull) (h66 : ce65WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE65 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                                  · exact h66 ρ hz (not_le.mp hseam65) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5 - THE FRONTIER MOVED AGAIN (window 65): [Z-PT2] + the sixty-six cited window clauses => the on-line census holds up to tCE65. -/
theorem allOnLineUpToCE65 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : ce64WinClauseFull) (hW66 : ce65WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE65 : ℝ) := by
  have hband := bandOfWindows65 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 - THE RE-ANCHORED FACE (window 65): no off-line zero with positive height above tCE65. -/
def terminalFaceCE65 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE65 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic: the CE64 face implies the CE65 face (tCE65 > tCE64). -/
theorem faceCE64_implies_faceCE65 (q : ZeroSet)
    (hface : CE64.terminalFaceCE64 q) :
    terminalFaceCE65 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE64_lt_tCE65, ht])

/-- M5 - THE TWO FACE FORMULATIONS, EQUIVALENT UNDER THE BAND: the extra band (tCE64, tCE65] is certified empty (window 64 full slice + window 65 together - window 64 was NON-SNAPPED and CLEAN; window 65 was NON-SNAPPED with ONE interior Rosser exception rescued, quota-met, recorded - see the header) - re-anchoring is a CERTIFICATE, not a logical move (the face is the same open object, now certified 4 673 higher; the 300 000-unit mark [window 64] is carried; pipeline data: THE 1 300 000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65 - not in-tree arithmetic). -/
theorem terminalFaceCE65_iff_faceCE64 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW65 : ce64WinClauseFull) (hW66 : ce65WinClause) :
    terminalFaceCE65 q ↔ CE64.terminalFaceCE64 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE65 : ℝ)
    · by_cases hseam65 : ρ.im ≤ (gB64Lo : ℝ)
      · exact hW65 ρ (hqz ρ hρ) (by linarith [ht, CE64.gB63Lo_lt_tCE64, tCE64_lt_tCE65]) hseam65
      · exact hW66 ρ (hqz ρ hρ) (not_le.mp hseam65) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE64_implies_faceCE65 q

/-- M5 - THE 0288 EXACT RESIDUAL, RE-PINNED AT tCE65 (pure logic). -/
theorem rh_split_at_CE65 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE65 : ℝ) ∧ terminalFaceCE65 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE65 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE65 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 - HEADLINE (window 65 - NON-SNAPPED WIDTH 20 000, ONE interior Rosser exception rescued/quota-met/recorded; the 300 000-unit MILESTONE [CE64] is carried, 308 409 above H0; **THE 1 300 000 CERTIFIED-ZERO MARK IS CROSSED IN WINDOW 65** - 1 319 986 total, exactly the 0370 prediction): given [Z-PT2] + the sixty-six cited window clauses ([CE1-WIN], [CE2-WIN-FULL], ... [CE62-WIN-FULL], [CE63-WIN-FULL], [CE64-WIN-FULL], [CE65-WIN]), all-heights RH <-> terminalFaceCE65. NO RH CLAIM. -/
theorem rh_reanchored_CE65 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : ce64WinClauseFull) (hW66 : ce65WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE65 q := by
  have hcensus := allOnLineUpToCE65 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hqz
  have hsplit := rh_split_at_CE65 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE65 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : ce64WinClauseFull) (hW66 : ce65WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE65 q) :
    RH q :=
  (rh_reanchored_CE65 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE65_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE65 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE65
