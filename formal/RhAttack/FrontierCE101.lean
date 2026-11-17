/-
**FrontierCE101 - The endpoint at the CE101 census frontier (lane M5, route (b) wired
into the endpoint squeeze): H = tCE101 = tPT2 + 471 965 = 3 000 175 804 765.

ROLE: RHEnd.rh_program78_frontierH is the ARBITRARY-FRONTIER form of the
endpoint: given a frontier H with the allOnLineUpTo census at H (plus the
zero-set premises, the named on-line sliver record below 707/50, and [Z78]),
RH follows from the residual legs hs1 (the zero-side witness: Qside >=
devProg on every off-pair above H), hs3 (the S3 definition-side wire:
Qside <= BwireP + MrP) and the hWin residual face (zero-exclusion of
(H, inf) x (0, 1/200)). The strongest instantiation in the tree before this
module was H = tCE100 (FrontierCE100, the 100-th wiring): the CE-series
re-anchor CE101 has since pushed the certified census frontier past
tCE100, so that wiring is now one module behind. This module performs the
strict push to the current frontier.

  * ce101AbovePT2 - WinC.tPT2 < (CE101.tCE101 : ℝ), the EXACT margin
    (CE101.tCE101 : ℝ) - WinC.tPT2 = 471 965 (norm_num): the in-tree
    CERTIFIED census frontier (the 101 windows, 2 020 000 zeros over
    (g_a1, g_b101]) sits strictly ABOVE both the cited Platt-Trudgian
    frontier and the prior tCE100 wiring frontier.

  * rh_program78_frontier_CE101 - THE ENDPOINT AT THE CENSUS FRONTIER:
    the same endpoint holds with H = tCE101; the census input is
    CE101.allOnLineUpToCE101 (tPT2 + the 102 verified window-slice
    clauses), and the residue (hs1, hs3, hWin) lives STRICTLY ABOVE
    3 000 175 804 765 = tPT2 + 471 965. The endpoint frontier is now
    driven by the CERTIFIED CENSUS at the CE101 frontier (the 470 000 UNIT ROUND MARK was crossed at CE101 [0431], margin 1 965 - a regular round crossing; the 2 020 000 CERTIFIED-ZERO mark lands exactly at CE101 (the first 20 000-mark of the post-target extension); the 2 000 000 program target had landed at CE100 [0421] - W101 is the first post-target-extension window).

  * terminalFaceCE101_elim_hWin - the RE-ANCHORED TERMINAL FACE of the CE
    series (all zeros of q with Im > tCE101 on the line) ALONE discharges
    the hWin residual face at tCE101: the two decompositions of RH (the CE
    census-iff and the endpoint squeeze) AGREE at the frontier. The
    negative-height half runs through the ZeroSet symmetry fields
    (q.conj / star, the HFE-after-HCJ pattern of WinC.noOffPairBelowPT).

  * face_above_frontier_no_offPair - the same elimination at EVERY offset
    d0 > 0 (no window restriction): nothing off-line at all above tCE101.

HONESTY: LEAN-PROVEN (all four facts, one norm_num order fact and pure
composition over RHEnd.rh_program78_frontierH + CE101.allOnLineUpToCE101 +
the CE101 terminal face). NO RH CLAIM: the residual legs hs1 / hs3 / hWin
at the tCE101 frontier remain the NAMED open legs, now stated strictly
above a STRICTLY HIGHER frontier than the tCE100 instantiation; the
terminal-face -> hWin fact shows the face is EXACTLY what the legs need,
not that it is closed. -/

import RhAttack.RHEnd
import RhAttack.CE99
import RhAttack.CE100
import RhAttack.CE101

open Real B0 P12
open Complex

namespace FrontierCE101

/-- THE FRONTIER ORDER (machine, norm_num): the CERTIFIED census frontier
tCE101 (the ONE-HUNDRED-FIRST window, 2 020 000 zeros over (g_a1, g_b101]) sits
strictly ABOVE the Platt-Trudgian growth-wire frontier tPT2, with the EXACT
margin tCE101 - tPT2 = 471 965. This is the 470 000-unit round-mark crossing (margin 1 965 - a regular round crossing, not one of the series' PREDICTED milestones) recorded at CE101 (0431): the unit-milestone series (175 000 @ CE38, 200 000 @ CE42B, ... 455 000 @ CE97, 460 000 @ CE98, 465 000 @ CE99, 470 000 @ CE101) was tCE - tPT2 in units. (CE100 was the TAIL window that landed the 2 000 000 census program target [0421]; the crossing lands in the first post-target full window, CE101.) -/
theorem ce101AbovePT2 : WinC.tPT2 < (CE101.tCE101 : ℝ) := by
  norm_num [WinC.tPT2, CE101.tCE101]

/-- THE EXACT MARGIN (machine, norm_num): (CE101.tCE101 : ℝ) - WinC.tPT2 = 471965. -/
theorem ce101PT2Margin : (CE101.tCE101 : ℝ) - WinC.tPT2 = 471965 := by
  norm_num [WinC.tPT2, CE101.tCE101]
/-- THE RE-ANCHORED TERMINAL FACE DISCHARGES THE hWin RESIDUAL (machine,
no data): if every zero of q above tCE101 lies on the line
(CE101.terminalFaceCE101 q), then the hWin residual face at tCE101 holds
(zero-exclusion of (tCE101, inf) x (0, 1/200) at heights >= 1000). The
positive-height half is the face itself; the negative-height half runs
through the ZeroSet symmetry fields (q.conj / star - the
HFE-after-HCJ pattern of WinC.noOffPairBelowPT). Consequence: the CE
series' terminal face and the endpoint's hWin leg are the SAME open
content above tCE101 - the two RH decompositions agree at the frontier. -/
theorem terminalFaceCE101_elim_hWin (q : ZeroSet)
    (hface : CE101.terminalFaceCE101 q) :
    WinC.hWinFaceResidualH q (CE101.tCE101 : ℝ) := by
  intro t0 d0 ht0 ht1 hd0 hdw hz
  rcases hz with ⟨ρ, hρ, hre, him, hdd⟩
  by_cases hpos : 0 < ρ.im
  · have habs : ρ.im = t0 := by
      rw [abs_of_nonneg (le_of_lt hpos)] at him
      exact him
    have hup : (CE101.tCE101 : ℝ) < ρ.im := by
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
    have hupst : (CE101.tCE101 : ℝ) < (star ρ).im := by
      rw [himst2]
      exact ht1
    have hre' : (star ρ).re = 1 / 2 := hface (star ρ) hst hupst
    rw [show (star ρ).re = ρ.re by simp [star]] at hre'
    exact hre hre'

/-- NOTHING OFF-LINE AT ALL ABOVE tCE101 (machine, no data): the terminal
face excludes every off-pair (t0, d0) with d0 > 0 and t0 > tCE101, at EVERY
offset (no window restriction) - the terminalFaceCE101_elim_hWin fact
generalized off the (0, 1/200) window. -/
theorem face_above_frontier_no_offPair (q : ZeroSet)
    (hface : CE101.terminalFaceCE101 q)
    (t0 d0 : ℝ) (ht1 : (CE101.tCE101 : ℝ) < t0) (hd0 : 0 < d0) :
    ¬ P12.offPair q t0 d0 := by
  rintro ⟨ρ, hρ, hre, him, hdd⟩
  by_cases hpos : 0 < ρ.im
  · have habs : ρ.im = t0 := by
      rw [abs_of_nonneg (le_of_lt hpos)] at him
      exact him
    have hup : (CE101.tCE101 : ℝ) < ρ.im := by
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
    have hupst : (CE101.tCE101 : ℝ) < (star ρ).im := by
      rw [himst2]
      exact ht1
    have hre' : (star ρ).re = 1 / 2 := hface (star ρ) hst hupst
    rw [show (star ρ).re = ρ.re by simp [star]] at hre'
    exact hre hre'

/-- THE ENDPOINT AT THE CENSUS FRONTIER (machine, the 0288-form endpoint with
H = tCE101): under [Z78], q a subset of the actual zeros (hqz), the named
on-line sliver record below 707/50, and the CE101 CENSUS (the tPT2 base plus
the 102 verified window-slice clauses - windows 1..101, the corrected w1-w101
band with the W42b fill, re-anchored 43..101 bit-identical at their seams;
W95 NON-SNAPPED 20 000 with two recorded interior failures, both determined
and rescued; W96 NON-SNAPPED 20 000 CLEAN; W100 TAIL 21 (b - a = 21), CLEAN - the landed 2 000 000 census program target [0421]; W101 NON-SNAPPED 20 000, ONE recorded interior Rosser failure - determined and rescued, adjudication-confirmed (fresh 4 / 4 - 0431)),
RH q follows from the residual legs hs1 / hs3 (the zero-side witness and the
S3 definition-side wire at the ONE concrete scale Qside) restricted to
t0 >= tCE101, plus the hWin residual face at tCE101. The engine is
RHEnd.rh_program78_frontierH (one instantiation, H := tCE101,
hPT := CE101.allOnLineUpToCE101) with 1000 <= tCE101 by norm_num. THE RESIDUE
LIVES STRICTLY ABOVE 3 000 175 804 765 = tPT2 + 471 965: the endpoint
frontier is now driven by the CERTIFIED CENSUS (2 020 000 zeros over
(g_a1, g_b101]), not by the cited Platt-Trudgian record and no longer one
module behind the CE re-anchors. NO RH CLAIM: hs1, hs3 and hWin at the
tCE101 frontier remain the named open legs (and terminalFaceCE101_elim_hWin
shows the hWin leg is exactly the re-anchored terminal face). -/
theorem rh_program78_frontier_CE101 (q : ZeroSet)
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
    (hW42 : CE42B.ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : CE96.ce95WinClauseFull) (hW97 : CE97.ce96WinClauseFull) (hW98 : CE98.ce97WinClauseFull) (hW99 : CE99.ce98WinClauseFull) (hW100 : CE100.ce99WinClauseFull) (hW101 : CE101.ce100WinClauseFull) (hW102 : CE101.ce101WinClause)
        (hqzCensus : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hs1CE101 : ∀ t0 d0, (CE101.tCE101 : ℝ) <= t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ RHEnd.devProg (t0, d0))
    (hs3CE101 : ∀ t0 d0, (CE101.tCE101 : ℝ) <= t0 → 0 < d0 → P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0))
    (hWinCE101 : WinC.hWinFaceResidualH q (CE101.tCE101 : ℝ)) :
    RH q := by
  have hcensus : WinC.allOnLineUpTo q (CE101.tCE101 : ℝ) :=
    CE101.allOnLineUpToCE101 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hqzCensus
  exact RHEnd.rh_program78_frontierH q hz78 hqz0 honline Qside
    (CE101.tCE101 : ℝ) (by norm_num [CE101.tCE101]) hcensus hs1CE101 hs3CE101 hWinCE101

end FrontierCE101
