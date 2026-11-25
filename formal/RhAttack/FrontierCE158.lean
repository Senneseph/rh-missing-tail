/-
**FrontierCE158 - The endpoint at the CE158 census frontier (lane M5, route (b) wired
into the endpoint squeeze): H = tCE158 = tPT2 + 738 320 = 3 000 176 071 120.

ROLE: RHEnd.rh_program78_frontierH is the ARBITRARY-FRONTIER form of the
endpoint: given a frontier H with the allOnLineUpTo census at H (plus the
zero-set premises, the named on-line sliver record below 707/50, and [Z78]),
RH follows from the residual legs hs1 (the zero-side witness: Qside >=
devProg on every off-pair above H), hs3 (the S3 definition-side wire:
Qside <= BwireP + MrP) and the hWin residual face (zero-exclusion of
(H, inf) x (0, 1/200)). The strongest instantiation in the tree before this
module was H = tCE157 (FrontierCE157, the 157-th wiring): the CE-series
re-anchor CE158 has since pushed the certified census frontier past
tCE157, so that wiring is now one module behind. This module performs the
strict push to the current frontier.

  * ce158AbovePT2 - WinC.tPT2 < (CE158.tCE158 : ℝ), the EXACT margin
    (CE158.tCE158 : ℝ) - WinC.tPT2 = 738 320 (norm_num): the in-tree
    CERTIFIED census frontier (the 158 windows, 3 159 992 zeros over
    (g_a1, g_b158]) sits strictly ABOVE both the cited Platt-Trudgian
    frontier and the prior tCE157 wiring frontier.

  * rh_program78_frontier_CE158 - THE ENDPOINT AT THE CENSUS FRONTIER:
    the same endpoint holds with H = tCE158; the census input is
    CE158.allOnLineUpToCE158 (tPT2 + the 159 verified window-slice
    clauses), and the residue (hs1, hs3, hWin) lives STRICTLY ABOVE
    3 000 176 071 120 = tPT2 + 738 320. The endpoint frontier is now
    driven by the CERTIFIED CENSUS at the CE158 frontier (the 735 000 UNIT ROUND MARK was crossed at CE158 [0494], margin 3 320 (as tabled in 0493); the 3 140 000 CERTIFIED-ZERO mark was CROSSED IN THIS WINDOW (margin 19 992; as tabled in 0493); W158 is the FULL-width window with ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5 on a six-glyph union; the FORTY-THIRD W97-family protocol cycle; adjudication-confirmed); the endpoint record REVISITS the -86 dyadic family (the thirty-second -86 window of the series; recorded data, no pattern claim); CENSUS NOTE: the cumulative count stands at 3 159 992 - EIGHT certified zeros short of the 3 160 000 round mark (expected W159, entry 0496; recorded data, no pattern claim)).

  * terminalFaceCE158_elim_hWin - the RE-ANCHORED TERMINAL FACE of the CE
    series (all zeros of q with Im > tCE158 on the line) ALONE discharges
    the hWin residual face at tCE158: the two decompositions of RH (the CE
    census-iff and the endpoint squeeze) AGREE at the frontier. The
    negative-height half runs through the ZeroSet symmetry fields
    (q.conj / star, the HFE-after-HCJ pattern of WinC.noOffPairBelowPT).

  * face_above_frontier_no_offPair - the same elimination at EVERY offset
    d0 > 0 (no window restriction): nothing off-line at all above tCE158.

HONESTY: LEAN-PROVEN (all four facts, one norm_num order fact and pure
composition over RHEnd.rh_program78_frontierH + CE158.allOnLineUpToCE158 +
the CE158 terminal face). NO RH CLAIM: the residual legs hs1 / hs3 / hWin
at the tCE158 frontier remain the NAMED open legs, now stated strictly
above a STRICTLY HIGHER frontier than the tCE157 instantiation; the
terminal-face -> hWin fact shows the face is EXACTLY what the legs need,
not that it is closed. -/

import RhAttack.RHEnd
import RhAttack.CE156
import RhAttack.CE157
import RhAttack.CE158

open Real B0 P12
open Complex

namespace FrontierCE158

/-- THE FRONTIER ORDER (machine, norm_num): the CERTIFIED census frontier
tCE158 (the ONE-HUNDRED-FIFTY-EIGHTH window, 3 159 992 zeros over (g_a1, g_b158]) sits
strictly ABOVE the Platt-Trudgian growth-wire frontier tPT2, with the EXACT
margin tCE158 - tPT2 = 738 320. This is the 620 000-unit round-mark crossing (margin 1 497) recorded at CE133 (0466): the unit-margin series now stands at 621 497 above tPT2 (the 500 000 milestone [0440] carries 121 497; the census lane crossed its 2 640 000 round mark in the same window). (CE100 was the TAIL window that LANDED the 2 000 000 census program target [0421]; the post-target extension continues: CE101 (full 20 000, fresh 4/4), CE102 (SNAPPED 19 999, CLEAN), CE103 (SNAPPED 19 997, CLEAN; 2 040 000 crossed mid-window), CE104 (full 20 000, fresh 6/6; 2 060 000 crossed), CE105 (full 20 000, fresh 4/4; 2 080 000 crossed), CE106 (full 20 000, fresh 5/5; 2 100 000 crossed), CE107 (SNAPPED 19 999, fresh 4/4; 2 120 000 crossed; 500 000 unit mark, margin 1), CE108 (full 20 000, three failures - first multi-failure window - fresh 5/5 on each; 2 140 000 crossed), CE109 (full 20 000, fresh 5/5; 2 160 000 + 505 000 crossed), CE110 (SNAPPED 19 999, CLEAN; 2 180 000 + 510 000 crossed), CE111 (full 20 000, CLEAN; 2 200 000 + 515 000 crossed), CE112 (full 20 000, three failures - fresh 4/4, 5/5, 4/4; 2 220 000 + 520 000 crossed), CE113 (SNAPPED 19 999, fresh 5/5; 2 240 000 + 525 000 crossed), CE114 (full 20 000, fresh 4/4; 2 260 000 + 530 000 crossed), CE115 (full 20 000, CLEAN; 2 280 000 + 535 000 crossed), CE116 (full 20 000, two failures - fresh 4/4, 4/4; 2 300 000 + 540 000 crossed), CE117 (full 20 000, one failure on a wide six-glyph union - fresh 5/5; 2 320 000 + 545 000 crossed), CE118 (full 20 000, CLEAN; 2 340 000 + 550 000 crossed), CE119 (full 20 000, CLEAN; 2 360 000 + 555 000 crossed), CE120 (full 20 000, two failures including the first four-gram block - fresh 7/7 + 4/4; 2 380 000 + 560 000 crossed), CE121 (full 20 000, two failures on wide six-glyph unions - fresh 5/5, 5/5; 2 400 000 + 565 000 crossed), CE122 (full 20 000, two failures - fresh 4/4 + 6/6 on the first seven-glyph union; 2 420 000 + 570 000 crossed), CE123 (full 20 000, one failure fresh 4/4, SUB-STANDARD 4 672 increment; 2 440 000 crossed; 575 000 NOT crossed - 233 ahead), CE124 (full 20 000, two failures - fresh 4/4 + 7/7 on the second eight-glyph union; 2 460 000 + 575 000 crossed), CE125 (full 20 000, one four-gram failure fresh 5/5 - second four-gram of the series; 2 480 000 + 580 000 crossed), CE126 (SNAPPED 19 999, one failure fresh 4/4; 2 500 000 + 585 000 crossed), CE127 (full 20 000, two failures - fresh 4/4 + 5/5, including the third four-gram of the series; 2 520 000 + 590 000 crossed), CE128 (full 20 000, one failure fresh 5/5; 2 540 000 + 595 000 crossed), CE129 (full 20 000, one failure fresh 4/4; 2 560 000 + 600 000 crossed), CE130 (full 20 000, two failures - fresh 7/7 + 4/4, including the fourth four-gram of the series; 2 580 000 + 605 000 crossed), CE131 (full 20 000, one failure fresh 6/6 on a seven-glyph union; 2 600 000 + 610 000 crossed), CE132 (full 20 000, CLEAN; 2 620 000 + 615 000 crossed), CE133 (full 20 000, one failure fresh 5/5 on a six-glyph union; 2 640 000 + 620 000 crossed), CE134 (full 20 000, CLEAN; 2 660 000 + 625 000 crossed), CE135 (full 20 000, two failures fresh 4/4 five-glyph + 7/7 eight-glyph; 2 680 000 + 630 000 crossed), CE136 (full 20 000, CLEAN; 2 700 000 + 635 000 crossed), CE137 (full 20 000, two failures fresh 4/4 five-glyph + 4/4 five-glyph; 2 720 000 + 640 000 crossed), CE138 (full 20 000, one failure fresh 4/4 five-glyph; 2 740 000 crossed; 645 000 NOT crossed - 139 ahead), CE139 (full 20 000, two failures fresh 4/4 five-glyph + 5/5 six-glyph; 2 760 000 + 645 000 crossed), CE140 (full 20 000, one failure fresh 6/6 six-glyph; 2 780 000 + 650 000 crossed), CE141 (full 20 000, three failures fresh 4/4 four-glyph x3; 2 800 000 + 655 000 crossed). CE142 (full 20 000, one failure fresh 4/4 four-glyph; 2 820 000 + 660 000 crossed), CE143 (full 20 000, CLEAN; 2 840 000 + 665 000 crossed). CE144 (full 20 000, two failures fresh 6/6 six-glyph + 5/5 six-glyph; 2 860 000 + 670 000 crossed). CE145 (full 20 000, two failures fresh 5/5 six-glyph x2; 2 880 000 + 675 000 crossed). CE146 (full 20 000, one failure fresh 5/5 six-glyph; 2 900 000 + 680 000 crossed. CE147 (full 20 000, one failure fresh 4/4 six-glyph; 2 920 000 + 685 000 crossed; 690 000 NOT crossed - 3 082 ahead). CE148 (full 20 000, two failures fresh 5/5 six-glyph x2; 2 940 000 + 690 000 crossed; 695 000 NOT crossed - 3 409 ahead). CE149 (full 20 000, zero interior failures; one right-context failure fresh 5/5 six-glyph past b; 2 960 000 + 695 000 crossed; 700 000 NOT crossed - 3 736 ahead). CE150 (full 20 000, two failures fresh 5/5 six-glyph x2; SUB-STANDARD 4 672 increment; 2 980 000 + 700 000 crossed; 705 000 NOT crossed - 4 064 ahead). CE151 (full 20 000, one failure fresh 5/5 six-glyph; 3 000 000 + 705 000 crossed; 710 000 NOT crossed - 4 391 ahead). CE152 (full 20 000, CLEAN; 3 020 000 + 710 000 crossed; 715 000 NOT crossed - 4 718 ahead). CE153 (full 20 000, CLEAN; 3 040 000 crossed; 715 000 NOT crossed - 45 ahead). CE154 (full 20 000, CLEAN; 3 060 000 + 715 000 crossed; 720 000 NOT crossed - 372 ahead). CE155 (full 20 000, CLEAN; 3 080 000 + 720 000 crossed; 725 000 NOT crossed - 699 ahead). CE156 (full 20 000, one failure fresh 4/4 six-glyph; 3 100 000 + 725 000 crossed; 730 000 NOT crossed - 1 026 ahead). CE157 (full 20 000, CLEAN; 3 120 000 + 730 000 crossed; 735 000 NOT crossed - 1 353 ahead). -/
theorem ce158AbovePT2 : WinC.tPT2 < (CE158.tCE158 : ℝ) := by
  norm_num [WinC.tPT2, CE158.tCE158]

/-- THE EXACT MARGIN (machine, norm_num): (CE158.tCE158 : ℝ) - WinC.tPT2 = 738320. -/
theorem ce158PT2Margin : (CE158.tCE158 : ℝ) - WinC.tPT2 = 738320 := by
  norm_num [WinC.tPT2, CE158.tCE158]
/-- THE RE-ANCHORED TERMINAL FACE DISCHARGES THE hWin RESIDUAL (machine,
no data): if every zero of q above tCE158 lies on the line
(CE158.terminalFaceCE158 q), then the hWin residual face at tCE158 holds
(zero-exclusion of (tCE158, inf) x (0, 1/200) at heights >= 1000). The
positive-height half is the face itself; the negative-height half runs
through the ZeroSet symmetry fields (q.conj / star - the
HFE-after-HCJ pattern of WinC.noOffPairBelowPT). Consequence: the CE
series' terminal face and the endpoint's hWin leg are the SAME open
content above tCE158 - the two RH decompositions agree at the frontier. -/
theorem terminalFaceCE158_elim_hWin (q : ZeroSet)
    (hface : CE158.terminalFaceCE158 q) :
    WinC.hWinFaceResidualH q (CE158.tCE158 : ℝ) := by
  intro t0 d0 ht0 ht1 hd0 hdw hz
  rcases hz with ⟨ρ, hρ, hre, him, hdd⟩
  by_cases hpos : 0 < ρ.im
  · have habs : ρ.im = t0 := by
      rw [abs_of_nonneg (le_of_lt hpos)] at him
      exact him
    have hup : (CE158.tCE158 : ℝ) < ρ.im := by
      rw [habs]
      exact ht1
    exact hre (hface ρ hρ hup)
  · have hneg : ρ.im < 0 := by
      have hle : ρ.im ≤ 0 := not_lt.mp hpos
      have hne : ρ.im ≠ 0 := q.nonReal ρ hρ
      exact lt_of_le_of_ne hle hne
    have habs : -ρ.im = t0 := by
      rw [abs_of_nonpos (le_of_lt hneg)] at him
      exact him
    have hst : star ρ ∈ q.Z := q.conj ρ hρ
    have himst : 0 < (star ρ).im := by
      simp only [star]
      linarith [habs, ht0]
    have himst2 : (star ρ).im = t0 := by
      simp only [star] at ⊢
      exact habs
    have hupst : (CE158.tCE158 : ℝ) < (star ρ).im := by
      rw [himst2]
      exact ht1
    have hre' : (star ρ).re = 1 / 2 := hface (star ρ) hst hupst
    rw [show (star ρ).re = ρ.re by simp [star]] at hre'
    exact hre hre'

/-- NOTHING OFF-LINE AT ALL ABOVE tCE158 (machine, no data): the terminal
face excludes every off-pair (t0, d0) with d0 > 0 and t0 > tCE158, at EVERY
offset (no window restriction) - the terminalFaceCE158_elim_hWin fact
generalized off the (0, 1/200) window. -/
theorem face_above_frontier_no_offPair (q : ZeroSet)
    (hface : CE158.terminalFaceCE158 q)
    (t0 d0 : ℝ) (ht1 : (CE158.tCE158 : ℝ) < t0) (hd0 : 0 < d0) :
    ¬ P12.offPair q t0 d0 := by
  rintro ⟨ρ, hρ, hre, him, hdd⟩
  by_cases hpos : 0 < ρ.im
  · have habs : ρ.im = t0 := by
      rw [abs_of_nonneg (le_of_lt hpos)] at him
      exact him
    have hup : (CE158.tCE158 : ℝ) < ρ.im := by
      rw [habs]
      exact ht1
    exact hre (hface ρ hρ hup)
  · have hneg : ρ.im < 0 := by
      have hle : ρ.im ≤ 0 := not_lt.mp hpos
      have hne : ρ.im ≠ 0 := q.nonReal ρ hρ
      exact lt_of_le_of_ne hle hne
    have habs : -ρ.im = t0 := by
      rw [abs_of_nonpos (le_of_lt hneg)] at him
      exact him
    have hst : star ρ ∈ q.Z := q.conj ρ hρ
    have himst : 0 < (star ρ).im := by
      simp only [star]
      linarith [habs, ht1]
    have himst2 : (star ρ).im = t0 := by
      simp only [star] at ⊢
      exact habs
    have hupst : (CE158.tCE158 : ℝ) < (star ρ).im := by
      rw [himst2]
      exact ht1
    have hre' : (star ρ).re = 1 / 2 := hface (star ρ) hst hupst
    rw [show (star ρ).re = ρ.re by simp [star]] at hre'
    exact hre hre'

/-- THE ENDPOINT AT THE CENSUS FRONTIER (machine, the 0288-form endpoint with
H = tCE158): under [Z78], q a subset of the actual zeros (hqz), the named
on-line sliver record below 707/50, and the CE158 CENSUS (the tPT2 base plus
the 159 verified window-slice clauses - windows 1..158, the corrected w1-w158
band with the W42b fill, re-anchored 43..158 bit-identical at their seams;
W95 NON-SNAPPED 20 000 with two recorded interior failures, both determined
and rescued; W96 NON-SNAPPED 20 000 CLEAN; W157 FULL 20 000, CLEAN - zero recorded interior failures; W158 FULL 20 000, ONE recorded interior Rosser failure block - determined and rescued (fresh 5/5 six-glyph)),
RH q follows from the residual legs hs1 / hs3 (the zero-side witness and the
S3 definition-side wire at the ONE concrete scale Qside) restricted to
t0 >= tCE158, plus the hWin residual face at tCE158. The engine is
RHEnd.rh_program78_frontierH (one instantiation, H := tCE158,
hPT := CE158.allOnLineUpToCE158) with 1000 <= tCE158 by norm_num. THE RESIDUE
LIVES STRICTLY ABOVE 3 000 176 071 120 = tPT2 + 738 320: the endpoint
frontier is now driven by the CERTIFIED CENSUS (3 159 992 zeros over
(g_a1, g_b158]), not by the cited Platt-Trudgian record and no longer one
module behind the CE re-anchors. NO RH CLAIM: hs1, hs3 and hWin at the
tCE158 frontier remain the named open legs (and terminalFaceCE158_elim_hWin
shows the hWin leg is exactly the re-anchored terminal face). -/
theorem rh_program78_frontier_CE158 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz0 : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
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
    (hW41 : CE42.ce41WinClauseFull)
    (hW42 : CE42B.ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : CE96.ce95WinClauseFull) (hW97 : CE97.ce96WinClauseFull) (hW98 : CE98.ce97WinClauseFull) (hW99 : CE99.ce98WinClauseFull) (hW100 : CE100.ce99WinClauseFull) (hW101 : CE101.ce100WinClauseFull) (hW102 : CE102.ce101WinClauseFull) (hW103 : CE103.ce102WinClauseFull) (hW104 : CE104.ce103WinClauseFull) (hW105 : CE105.ce104WinClauseFull) (hW106 : CE106.ce105WinClauseFull) (hW107 : CE107.ce106WinClauseFull) (hW108 : CE108.ce107WinClauseFull) (hW109 : CE109.ce108WinClauseFull) (hW110 : CE110.ce109WinClauseFull) (hW111 : CE111.ce110WinClauseFull) (hW112 : CE112.ce111WinClauseFull) (hW113 : CE113.ce112WinClauseFull) (hW114 : CE114.ce113WinClauseFull) (hW115 : CE115.ce114WinClauseFull) (hW116 : CE116.ce115WinClauseFull) (hW117 : CE117.ce116WinClauseFull) (hW118 : CE118.ce117WinClauseFull) (hW119 : CE119.ce118WinClauseFull) (hW120 : CE120.ce119WinClauseFull) (hW121 : CE121.ce120WinClauseFull) (hW122 : CE122.ce121WinClauseFull) (hW123 : CE123.ce122WinClauseFull) (hW124 : CE124.ce123WinClauseFull) (hW125 : CE125.ce124WinClauseFull) (hW126 : CE126.ce125WinClauseFull) (hW127 : CE127.ce126WinClauseFull) (hW128 : CE128.ce127WinClauseFull) (hW129 : CE129.ce128WinClauseFull) (hW130 : CE130.ce129WinClauseFull) (hW131 : CE131.ce130WinClauseFull) (hW132 : CE132.ce131WinClauseFull) (hW133 : CE133.ce132WinClauseFull) (hW134 : CE134.ce133WinClauseFull) (hW135 : CE135.ce134WinClauseFull) (hW136 : CE136.ce135WinClauseFull) (hW137 : CE137.ce136WinClauseFull) (hW138 : CE138.ce137WinClauseFull) (hW139 : CE139.ce138WinClauseFull) (hW140 : CE140.ce139WinClauseFull) (hW141 : CE141.ce140WinClauseFull) (hW142 : CE142.ce141WinClauseFull) (hW143 : CE143.ce142WinClauseFull) (hW144 : CE144.ce143WinClauseFull) (hW145 : CE145.ce144WinClauseFull) (hW146 : CE146.ce145WinClauseFull) (hW147 : CE147.ce146WinClauseFull) (hW148 : CE148.ce147WinClauseFull) (hW149 : CE149.ce148WinClauseFull) (hW150 : CE150.ce149WinClauseFull) (hW151 : CE151.ce150WinClauseFull) (hW152 : CE152.ce151WinClauseFull) (hW153 : CE153.ce152WinClauseFull) (hW154 : CE154.ce153WinClauseFull) (hW155 : CE155.ce154WinClauseFull) (hW156 : CE156.ce155WinClauseFull) (hW157 : CE157.ce156WinClauseFull) (hW158 : CE158.ce157WinClauseFull) (hW159 : CE158.ce158WinClause)
        (hqzCensus : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hs1CE158 : ∀ t0 d0, (CE158.tCE158 : ℝ) <= t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ RHEnd.devProg (t0, d0))
    (hs3CE158 : ∀ t0 d0, (CE158.tCE158 : ℝ) <= t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinCE158 : WinC.hWinFaceResidualH q (CE158.tCE158 : ℝ)) :
    RH q := by
  have hcensus : WinC.allOnLineUpTo q (CE158.tCE158 : ℝ) :=
    CE158.allOnLineUpToCE158 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144 hW145 hW146 hW147 hW148 hW149 hW150 hW151 hW152 hW153 hW154 hW155 hW156 hW157 hW158 hW159 hqzCensus
  exact RHEnd.rh_program78_frontierH q hz78 hqz0 honline Qside
    (CE158.tCE158 : ℝ) (by norm_num [CE158.tCE158]) hcensus hs1CE158 hs3CE158 hWinCE158

end FrontierCE158
