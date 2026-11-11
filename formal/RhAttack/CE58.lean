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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57
open scoped Topology

/-!
**CE58 — the terminal face re-anchored at the FIFTY-EIGHTH certified window
(0364, option B, unit 77 - lane M5).

MILESTONE: tCE58 - tPT2 = 275 698 > 275 000 - THE 275 000-UNIT MILESTONE IS
CROSSED IN WINDOW 58 (margin 698; exactly where the ~4 673/window pace
predicted from 0363: 271 025 + 4 672 = 275 697, so even the slowest observed
increment would have crossed it). Proven in-tree as frontierPast275k. The
round-mark sequence above H0 is now: 100 000 @ CE22, 125 000 @ CE27,
150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @
CE53, 275 000 @ CE58. Next: 300 000 (24 302 ahead - at the ~4 673/window
pace, expected in window 63 or 64; compute from the decoded endpoint, do not
pre-announce).

CHAIN STATE: the corrected chain continues w42 -> w42b -> w43 -> w44 -> w45
-> w46 -> w47 -> w48 -> w49 -> w50 -> w51 -> w52 -> w53 -> w54 -> w55 -> w56
-> w57 -> w58, every seam bit-identical (window 58 launched from b57; the
seam audit passed bit-identically BEFORE this module was written, per the
0348 process rule).

WINDOW 58: NON-SNAPPED (width b - a = 20 000 - the requested endpoint WAS a
good Gram point at working precision). CLEAN WINDOW: zero internal Rosser
failures (the SECOND CONSECUTIVE clean window - w57 was the first since w50;
w51-w56 carried 1, 2, 3, 1, 1, 4 recorded rescues). End Rosser runs: 48 left
of g_a58, 46 right of g_b58 (both >= K = 12); 0 cross-check failures (all
33 532 records); 0 undetermined Gram signs.

INCREMENTS: 4 673 - the standing pace continues (the two isolated 4 672's at
w45 -> w46 and w53 -> w54 remain honest data points; no pattern assumed).

PROVENANCE (our run, 2026-11-11; pipeline = Murphy's Apache-2.0 deposit,
same as CE1-CE57): RUN PARAMETERS: a = 12 363 154 597 117 (= b57),
b requested = a + 20 000 = 12 363 154 617 117, b ACTUAL = 12 363 154 617 117
(NON-SNAPPED), M = 60, C_R = 1, 28 workers, 33 532 evaluations, 2617.8 s.
CERTIFICATE (window58_b58.json): the b - a = 20 000 zeros of zeta with
g_a58 < Im s <= g_b58 are ALL SIMPLE and on the line, where g_a58 (recorded
exact dyadic ball) = 116063672026972477182407992315941454601 x 2^-85 with
radius 16777217 x 2^-110 (i.e. 3 000 175 603 825.774902343750 + or -
1.29e-26) and this ball is BIT-IDENTICAL to CE57's recorded g_b57 (exact
dyadic tuple comparison, 2026-11-11 - audit PERFORMED BEFORE this module was
written); g_b58 = 3 000 175 608 498.709960937500 + or - 1.29e-26 (exact
dyadic tuple [29015918051936974651021361477904096537, -83, 16777217, -110]).
The floor tCE58 sits 0.7099 above the previous integer - robust to the
1.29e-26 radius by many orders of magnitude; the standard two-decimal lower
bound gB58Lo has a margin of ~9.96e-3; the two-decimal round-down (0.70)
does not equal the floor, so no CASING is needed - window 38 / CE38 remains
the only CASING case so far.

VERIFICATION (three layers, same as CE2-CE57): (1) ENVIRONMENT REPEAT
(Murphy's window-1 certificate re-verified - see CE2 header); (2) PIPELINE
VERIFIER on window58_b58.json: "CERTIFIED: true", points_checked = 33 532,
sign_changes_inside = 20 000 = b - a, roesser_failures_inside = 0 (CLEAN),
turing_ok = true, K_conservative = 12 (Trudgian Cor2.3 = [5.71899 + or -
1.23e-6], doubled = [11.4380 + or - 1.76e-5], Amberger Thm2.3 = [9.14967
+ or - 4.14e-6] - all below 12), endpoints recomputed and matched; (3) SEAM
AUDIT (this run): the recorded g_a58 ball is bit-identical to CE57's
recorded g_b57 ball (exact dyadic decode, 2026-11-11). FRONTIER ARITHMETIC
(machine, below): tCE58 = 3 000 175 608 498, tCE58 - tCE57 = 4 673,
tCE58 - tPT2 = 275 698 (THE 275 000-UNIT MILESTONE IS CROSSED). HONESTY
(trust base): as CE2-CE57 - the pipeline's own controls, its kernel-checked
Lean remainder theorem, and our three verification layers; a RE-RUN of a
third-party pipeline, not a from-scratch independent certification. NO
ROSSER EXCEPTIONS IN THIS WINDOW; NOTHING TO RECORD OR SUPPRESS. Cumulative
certified count = 1 179 987 over (g_a1, g_b58] (pipeline data, not in-tree
arithmetic): the 1 100 000 mark [window 55, 0361] is carried; the 1 200 000
mark is 20 013 ahead (running total at w59 should be 1 199 987 - 13 short
again - crossing expected in w60 at 20 000/window, pending snaps). NO RH
CLAIM.
-/
namespace CE58


/-! ### 1.  The  certified  constants
-/
/-- Certified LOWER bound for g_b58 (the recorded ball is 3 000 175 608 498.709960937500 with radius ~= 1.29e-26; this rational rounds the bottom down at two decimals, margin ~9.96e-3; window 58 is NON-SNAPPED and CLEAN - zero internal Rosser failures - see the header). -/
def gB58Lo : ℚ := 300017560849870 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER: an integer strictly below the certified lower bound gB58Lo: tCE58 = 3 000 175 608 498. -/
def tCE58 : ℕ := 3000175608498

theorem tCE58_lt_gB58Lo : (tCE58 : ℝ) < (gB58Lo : ℝ) := by
  norm_num [gB58Lo, tCE58]

theorem tCE57_lt_tCE58 : (tCE57 : ℝ) < (tCE58 : ℝ) := by
  norm_num [CE57.tCE57, tCE58]

/-- Record: the seam order gB57Lo < tCE58 (the band (gB57Lo, tCE58] is nonempty and lies above window 57's frontier tCE57). -/
theorem gB57Lo_lt_tCE58 : (gB57Lo : ℝ) < (tCE58 : ℝ) := by
  norm_num [CE57.gB57Lo, tCE58]

/-- Record: the face height shrank by a FURTHER 4 673 units past tCE57: the standing pace continues (the two 4 672's - w45->w46 and w53->w54 - remain isolated data points; no pattern assumed, recorded honestly). -/
theorem faceShrinkCE58 : (tCE58 : ℝ) - (tCE57 : ℝ) = 4673 := by
  norm_num [tCE58, CE57.tCE57]

/-- THE EXTENDED GEAR (machine): the new frontier stands 275 698 units above the Platt-Trudgian frontier H0 (window 58 is NON-SNAPPED, width 20 000 - CLEAN: zero internal Rosser failures, the second consecutive clean window; the 275 000-unit MILESTONE IS CROSSED in this window - proven as frontierPast275k; the round-mark sequence is 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58; the next round mark 300 000 sits 24 302 ahead - at the ~4 673/window pace, expected in window 63 or 64; compute the floor when it lands, do not pre-announce). -/
theorem frontierGapAboveH0 : (tCE58 : ℝ) - WinC.tPT2 = 275698 := by
  norm_num [tCE58, WinC.tPT2]

/-- MILESTONE CARRY (machine): tCE58 - tPT2 = 275 698 exceeds 200 000 (crossed at the fill CE42B). -/
theorem frontierPast200k : (tCE58 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE58 : ℝ) - WinC.tPT2 = 275698 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine): tCE58 - tPT2 = 275 698 exceeds 175 000 (the CE38 mark). -/
theorem frontierPast175k : (tCE58 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE58 : ℝ) - WinC.tPT2 = 275698 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE CARRY (machine, PROVEN): tCE58 - tPT2 = 275 698 exceeds 225 000 - the 225 000-unit mark (crossed in window 48, the CE48 MILESTONE unit) is carried at the new frontier; the 250 000-unit mark (crossed in window 53, the CE53 MILESTONE unit) and the 275 000-unit mark (crossed in WINDOW 58, this module, at 275 698) are likewise carried - see frontierPast250k / frontierPast275k; the 1 000 000-, 1 100 000-certified-zero marks (windows 50 / 55) are also carried - counts are pipeline data, not in-tree arithmetic. -/
theorem frontierPast225k : (tCE58 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE58 : ℝ) - WinC.tPT2 = 275698 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE CARRY (machine, PROVEN): tCE58 - tPT2 = 275 698 exceeds 250 000 - THE 250 000-UNIT MILESTONE (crossed in WINDOW 53, the CE53 MILESTONE unit, at 252 334) is CARRIED at the new frontier, re-proven here; the round-mark sequence above H0 is 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58; the next round mark, 300 000, sits 24 302 ahead - at the ~4 673/window pace, expected in window 63 or 64 (compute from the decoded endpoint, do not pre-announce). Pipeline data: the 1 100 000 CERTIFIED-ZERO mark [window 55, 0361] is carried - 1 179 987 total now - not in-tree arithmetic. -/
theorem frontierPast250k : (tCE58 : ℝ) - WinC.tPT2 > 250000 := by
  have h : (tCE58 : ℝ) - WinC.tPT2 = 275698 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE (machine, PROVEN): tCE58 - tPT2 = 275 698 exceeds 275 000 - THE 275 000-UNIT MILESTONE IS CROSSED IN WINDOW 58, at 275 698 above H0 (exactly where the ~4 673/window pace predicted from 0363 - even the slowest observed increment, 4 672, would have crossed it: 271 025 + 4 672 = 275 697). The round-mark sequence above H0 is now 100 000 @ CE22, 125 000 @ CE27, 150 000 @ CE33, 175 000 @ CE38, 200 000 @ CE42B, 225 000 @ CE48, 250 000 @ CE53, 275 000 @ CE58. Pipeline data: the 1 100 000 CERTIFIED-ZERO mark [window 55, 0361] is carried - 1 179 987 total now - not in-tree arithmetic. -/
theorem frontierPast275k : (tCE58 : ℝ) - WinC.tPT2 > 275000 := by
  have h : (tCE58 : ℝ) - WinC.tPT2 = 275698 := frontierGapAboveH0
  linarith [h]
/-- Record: the rationalized slice caps are well ordered (gB57Lo < gB58Lo) - the window-57 band (gB57Lo, gB58Lo] lies strictly above window 56's certified region (gB56Lo, gB57Lo]. -/
theorem gB57Lo_lt_gB58Lo : (gB57Lo : ℝ) < (gB58Lo : ℝ) := by
  norm_num [CE57.gB57Lo, gB58Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED, OUR WINDOW-57 RUN (window57_b57.json), FULL SLICE - re-cited at the CE58 level] every zeta zero with gB56Lo < Im ρ <= gB57Lo is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB56Lo, gB57Lo], either t0 <= g_b56 (g_a57 = g_b56 - the chain seam, recorded exact dyadic tuple [232127343692394111500520322163846277315, -86, 16777217, -110], audit PASSED BEFORE CE57 was written) - then t0 sits in window 56's certified region (g_a56, g_b56] (window 56 is NON-SNAPPED, width 20 000, FOUR recorded quota-met rescues - see the CE56 header) - or t0 > g_b56 = g_a57, in which case t0 <= gB57Lo <= g_b57 puts t0 in window 57's certified region (g_a57, g_b57] (window 57 is NON-SNAPPED, width 20 000, CLEAN - zero internal Rosser failures - see the CE57 header). The two certified regions union to (g_a56, g_b57] which contains (gB56Lo, gB57Lo] (machine: gB56Lo < tCE57 < gB57Lo, from CE57). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce57WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB56Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB57Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-58 RUN (window58_b58.json), SLICE] every zeta zero with gB57Lo < Im ρ <= tCE58 is on the critical line. Derivation (recorded): for t0 = Im ρ in (gB57Lo, tCE58], either t0 <= g_b57 (the true Gram point - g_a58 = g_b57, recorded exact dyadic tuple [116063672026972477182407992315941454601, -85, 16777217, -110], i.e. 3 000 175 603 825.774902343750 + or - 1.29e-26, BIT-IDENTICAL in both certificates - the chain seam, audit PASSED BEFORE this module was written per the 0348 process rule; gB57Lo < g_b57) - then t0 sits in window 57's certified region (g_a57, g_b57] - or t0 > g_b57 = g_a58, in which case t0 <= tCE58 < gB58Lo <= g_b58 puts t0 in window 58's certified region (g_a58, g_b58] (window 58 is NON-SNAPPED, width 20 000, CLEAN - zero internal Rosser failures - see the header). The two certified regions union to (g_a57, g_b58] which contains (gB57Lo, tCE58] (machine: gB57Lo < tCE58 < gB58Lo). Named Prop consumed as a hypothesis; not proven in-tree. -/
def ce58WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB57Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE58 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine): zeros in (tPT2, tCE58] are on the line, given the fifty-nine window clauses (windows 1 through 42, the fill, windows 43 through 57 [full slices], and window 58 [terminal slice]) - the splits at gA2Hi, gB2Lo, ..., gB42Lo, gB42BLo, gB43Lo, gB44Lo, gB45Lo, gB46Lo, gB47Lo, gB48Lo, gB49Lo, gB50Lo, gB51Lo, gB52Lo, gB53Lo, gB54Lo, gB55Lo, gB56Lo, gB57Lo are pure case splits. -/
theorem bandOfWindows58 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : CE51.ce50WinClauseFull) (h52 : CE52.ce51WinClauseFull) (h53 : CE53.ce52WinClauseFull) (h54 : CE54.ce53WinClauseFull) (h55 : CE55.ce54WinClauseFull) (h56 : CE56.ce55WinClauseFull) (h57 : CE57.ce56WinClauseFull) (h58 : ce57WinClauseFull) (h59 : ce58WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE58 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                                    · exact h59 ρ hz (not_le.mp hseam58) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5 - THE FRONTIER MOVED AGAIN (window 58): [Z-PT2] + the fifty-nine cited window clauses => the on-line census holds up to tCE58. -/
theorem allOnLineUpToCE58 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : ce57WinClauseFull) (hW59 : ce58WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE58 : ℝ) := by
  have hband := bandOfWindows58 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 - THE RE-ANCHORED FACE (window 58): no off-line zero with positive height above tCE58. -/
def terminalFaceCE58 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE58 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic: the CE57 face implies the CE58 face (tCE58 > tCE57). -/
theorem faceCE57_implies_faceCE58 (q : ZeroSet)
    (hface : CE57.terminalFaceCE57 q) :
    terminalFaceCE58 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE57_lt_tCE58, ht])

/-- M5 - THE TWO FACE FORMULATIONS, EQUIVALENT UNDER THE BAND: the extra band (tCE57, tCE58] is certified empty (window 57 full slice + window 58 together - both windows were NON-SNAPPED and CLEAN with zero internal Rosser failures; see the header) - re-anchoring is a CERTIFICATE, not a logical move (the face is the same open object, now certified 4 673 higher; the 250 000-unit mark [CE53], the 275 000-unit mark [CE58] and the 1 100 000-certified-zero mark [window 55] are carried - counts are pipeline data, not in-tree arithmetic). -/
theorem terminalFaceCE58_iff_faceCE57 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW58 : ce57WinClauseFull) (hW59 : ce58WinClause) :
    terminalFaceCE58 q ↔ CE57.terminalFaceCE57 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE58 : ℝ)
    · by_cases hseam58 : ρ.im ≤ (gB57Lo : ℝ)
      · exact hW58 ρ (hqz ρ hρ) (by linarith [ht, CE57.gB56Lo_lt_tCE57, tCE57_lt_tCE58]) hseam58
      · exact hW59 ρ (hqz ρ hρ) (not_le.mp hseam58) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE57_implies_faceCE58 q

/-- M5 - THE 0288 EXACT RESIDUAL, RE-PINNED AT tCE58 (pure logic). -/
theorem rh_split_at_CE58 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE58 : ℝ) ∧ terminalFaceCE58 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE58 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE58 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 - HEADLINE (window 58 - CLEAN, NON-SNAPPED WIDTH 20 000; THE 275 000-UNIT FRONTIER MARK IS CROSSED AT THIS FRONTIER - frontierPast275k - and the 250 000-unit mark [CE53] is carried): given [Z-PT2] + the fifty-nine cited window clauses ([CE1-WIN], [CE2-WIN-FULL], ... [CE55-WIN-FULL], [CE56-WIN-FULL], [CE57-WIN-FULL], [CE58-WIN]), all-heights RH <-> terminalFaceCE58. NO RH CLAIM. -/
theorem rh_reanchored_CE58 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : ce57WinClauseFull) (hW59 : ce58WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE58 q := by
  have hcensus := allOnLineUpToCE58 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hqz
  have hsplit := rh_split_at_CE58 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE58 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : ce57WinClauseFull) (hW59 : ce58WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE58 q) :
    RH q :=
  (rh_reanchored_CE58 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE58_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE58 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE58
