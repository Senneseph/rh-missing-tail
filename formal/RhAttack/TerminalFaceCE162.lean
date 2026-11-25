/-
**TerminalFaceCE162 - RH FROM THE RE-ANCHORED TERMINAL FACE at tCE162 (the
endpoint form of the program, at the window-162 census frontier):

    terminalFaceCE162 q  +  census  +  [Z78]  -->  RH q

ROLE: FrontierCE162 showed the CE census-iff and the endpoint squeeze AGREE
at this frontier: the re-anchored terminal face (all zeros of q with
Im > tCE162 on the line) ALONE discharges the hWin residual leg
(terminalFaceCE162_elim_hWin), and NOTHING OFF-LINE exists at all above
tCE162 (face_above_frontier_no_offPair). This module records the full
consequence: under the terminal face the residual legs of the endpoint AT
THE FRONTIER are ALL discharged BY THE FACE ITSELF:

  * hWin  - FrontierCE162.terminalFaceCE162_elim_hWin (in tree);
  * hs1 / hs3 - VACUOUS, because no off-pair (t0, d0) exists at or above
    tCE162:
      - ABOVE  tCE162: face_above_frontier_no_offPair (the face itself,
        via the ZeroSet conj/star symmetry for the negative-height half);
      - AT     tCE162: the census clause WinC.allOnLineUpTo is
        BOUNDARY-INCLUSIVE (0 < rho.im, rho.im <= H -> on the line), and
        the negative half at -tCE162 runs through q.conj + star.

  Hence THE ENDPOINT FORM OF THE WHOLE PROGRAM at the certified census
  frontier tCE162: RH q follows from the re-anchored terminal face at this
  frontier, the in-tree census below it, [Z78], and the zero-set premises -
  the residual legs are empty. THE ONLY ANALYTIC RESIDUE LEFT FOR RH IS THE
  TERMINAL FACE ITSELF.

THEOREMS (all LEAN-PROVEN composition; NO RH CLAIM - terminalFaceCE162 q
is a NAMED INPUT, an unproven face; the theorems are implications FROM
it):
  * terminalFaceCE162_no_offPair_at_or_above - no off-pair at or above
    tCE162 under the face + the census boundary clause;
  * rh_from_terminalFaceCE162 - THE ENDPOINT AT THE WINDOW-162 FRONTIER:
    [Z78] + census + zero-set premises + terminalFaceCE162 q --> RH q,
    with hs1 / hs3 instantiated VACUOUSLY and hWin by the face. -/

import RhAttack.FrontierCE162
import RhAttack.CE162

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50 CE51 CE52 CE53 CE54 CE55 CE56 CE57 CE58 CE59 CE60 CE61 CE62 CE63 CE64 CE65 CE66 CE67 CE68 CE69 CE70 CE71 CE72 CE73 CE74 CE75 CE76 CE77 CE78 CE79 CE80 CE81 CE82 CE83 CE84 CE85 CE86 CE87 CE88 CE89 CE90 CE91 CE92 CE93 CE94 CE95 CE96 CE97 CE98 CE99 CE100 CE101 CE102 CE103 CE104 CE105 CE106 CE107 CE108 CE109 CE110 CE111 CE112 CE113 CE114 CE115 CE116 CE117 CE118 CE119 CE120 CE121 CE122 CE123 CE124 CE125 CE126 CE127 CE128 CE129 CE130 CE131 CE132 CE133 CE134 CE135 CE136 CE137 CE138 CE139 CE140 CE141 CE142 CE143 CE144 CE145 CE146 CE147 CE148 CE149 CE150 CE151 CE152 CE153 CE154 CE155 CE156 CE157 CE158 CE159 CE160 CE161
open Complex

namespace TerminalFaceCE162

/-- NO OFF-PAIR AT OR ABOVE tCE162 (machine, no data): under the re-anchored
terminal face (above) and the BOUNDARY-INCLUSIVE census clause (at), nothing
off-line exists at t0 >= tCE162 for ANY offset d0 > 0. This is what makes the
endpoint's hs1 / hs3 legs VACUOUS at the frontier. -/
theorem terminalFaceCE162_no_offPair_at_or_above (q : ZeroSet)
    (hface : CE162.terminalFaceCE162 q)
    (hcensus : WinC.allOnLineUpTo q (CE162.tCE162 : ℝ))
    (t0 d0 : ℝ) (ht : (CE162.tCE162 : ℝ) ≤ t0) (hd0 : 0 < d0) :
    ¬ P12.offPair q t0 d0 := by
  rintro ⟨ρ, hρ, hne, him, hdd⟩
  by_cases hstrict : (CE162.tCE162 : ℝ) < t0
  · exact (FrontierCE162.face_above_frontier_no_offPair q hface t0 d0 hstrict hd0)
      ⟨ρ, hρ, hne, him, hdd⟩
  · -- BOUNDARY: t0 = tCE162, covered by the census (boundary-inclusive <=)
    have heq : t0 = (CE162.tCE162 : ℝ) := by
      apply le_antisymm
      · linarith
      · exact ht
    by_cases hpos : 0 < ρ.im
    · have hre : ρ.re = 1 / 2 := by
        have hle : ρ.im ≤ (CE162.tCE162 : ℝ) := by
          rw [abs_of_nonneg (le_of_lt hpos)] at him
          linarith [heq, him]
        exact hcensus ρ hρ hpos hle
      exact hne hre
    · have hneg : ρ.im < 0 := by
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne (not_lt.mp hpos) hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have himst : 0 < (star ρ).im := by
        simp only [star]
        linarith [hpos, hneg]
      have hlest : (star ρ).im ≤ (CE162.tCE162 : ℝ) := by
        simp only [star] at ⊢
        have habs : ρ.im = -t0 := by
          rw [abs_of_nonpos (le_of_lt hneg)] at him
          linarith [heq, him]
        linarith [habs, heq]
      have hre' : (star ρ).re = 1 / 2 := hcensus (star ρ) hst himst hlest
      have hre : ρ.re = 1 / 2 := by
        rw [show (star ρ).re = ρ.re by simp [star]] at hre'
        exact hre'
      exact hne hre'

/-- THE ENDPOINT FROM THE TERMINAL FACE at H = tCE162: under [Z78], q a
subset of the actual zeros (hqz0), the named on-line sliver record below
707/50, and the CE162 CENSUS (the tPT2 base plus the 162 verified
window-slice clauses), the RE-ANCHORED TERMINAL FACE ALONE gives RH q. The
engine is FrontierCE162.rh_program78_frontier_CE162 with hs1 / hs3
instantiated VACUOUSLY via
terminalFaceCE162_no_offPair_at_or_above (no off-pair at or above tCE162)
and hWin via FrontierCE162.terminalFaceCE162_elim_hWin. NO RH CLAIM:
terminalFaceCE162 q is the named open face (all zeros of q with Im > tCE162
on the line); this theorem says that face IS the sole analytic residue of
RH at this certified census frontier. -/
theorem rh_from_terminalFaceCE162 (q : ZeroSet)
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
    (hW42 : CE42B.ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : CE162.ce95WinClauseFull) (hW97 : CE162.ce96WinClauseFull) (hW98 : CE162.ce97WinClauseFull) (hW99 : CE162.ce98WinClauseFull) (hW100 : CE162.ce99WinClauseFull) (hW101 : CE162.ce100WinClauseFull) (hW102 : CE162.ce101WinClauseFull) (hW103 : CE162.ce102WinClauseFull) (hW104 : CE162.ce103WinClauseFull) (hW105 : CE162.ce104WinClauseFull) (hW106 : CE162.ce105WinClauseFull) (hW107 : CE162.ce106WinClauseFull) (hW108 : CE162.ce107WinClauseFull) (hW109 : CE162.ce108WinClauseFull) (hW110 : CE162.ce109WinClauseFull) (hW111 : CE162.ce110WinClauseFull) (hW112 : CE162.ce111WinClauseFull) (hW113 : CE162.ce112WinClauseFull) (hW114 : CE162.ce113WinClauseFull) (hW115 : CE162.ce114WinClauseFull) (hW116 : CE162.ce115WinClauseFull) (hW117 : CE162.ce116WinClauseFull) (hW118 : CE162.ce117WinClauseFull) (hW119 : CE162.ce118WinClauseFull) (hW120 : CE162.ce119WinClauseFull) (hW121 : CE162.ce120WinClauseFull) (hW122 : CE162.ce121WinClauseFull) (hW123 : CE162.ce122WinClauseFull) (hW124 : CE162.ce123WinClauseFull) (hW125 : CE162.ce124WinClauseFull) (hW126 : CE162.ce125WinClauseFull) (hW127 : CE162.ce126WinClauseFull) (hW128 : CE162.ce127WinClauseFull) (hW129 : CE162.ce128WinClauseFull) (hW130 : CE162.ce129WinClauseFull) (hW131 : CE162.ce130WinClauseFull) (hW132 : CE162.ce131WinClauseFull) (hW133 : CE162.ce132WinClauseFull) (hW134 : CE162.ce133WinClauseFull) (hW135 : CE162.ce134WinClauseFull) (hW136 : CE162.ce135WinClauseFull) (hW137 : CE162.ce136WinClauseFull) (hW138 : CE162.ce137WinClauseFull) (hW139 : CE162.ce138WinClauseFull) (hW140 : CE162.ce139WinClauseFull) (hW141 : CE162.ce140WinClauseFull) (hW142 : CE162.ce141WinClauseFull) (hW143 : CE162.ce142WinClauseFull) (hW144 : CE162.ce143WinClauseFull) (hW145 : CE162.ce144WinClauseFull) (hW146 : CE162.ce145WinClauseFull) (hW147 : CE162.ce146WinClauseFull) (hW148 : CE162.ce147WinClauseFull) (hW149 : CE162.ce148WinClauseFull) (hW150 : CE162.ce149WinClauseFull) (hW151 : CE162.ce150WinClauseFull) (hW152 : CE162.ce151WinClauseFull) (hW153 : CE162.ce152WinClauseFull) (hW154 : CE162.ce153WinClauseFull) (hW155 : CE162.ce154WinClauseFull) (hW156 : CE162.ce155WinClauseFull) (hW157 : CE162.ce156WinClauseFull) (hW158 : CE162.ce157WinClauseFull) (hW159 : CE162.ce158WinClauseFull) (hW160 : CE162.ce159WinClauseFull) (hW161 : CE162.ce160WinClauseFull) (hW162 : CE162.ce161WinClauseFull) (hW163 : CE162.ce162WinClause)
    (hqzCensus : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hface : CE162.terminalFaceCE162 q) :
    RH q := by
  have hcensus : WinC.allOnLineUpTo q (CE162.tCE162 : ℝ) :=
    CE162.allOnLineUpToCE162 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144 hW145 hW146 hW147 hW148 hW149 hW150 hW151 hW152 hW153 hW154 hW155 hW156 hW157 hW158 hW159 hW160 hW161 hW162 hW163 hqzCensus
  have hno : ∀ (t0 d0 : ℝ), (CE162.tCE162 : ℝ) ≤ t0 → 0 < d0 → ¬ P12.offPair q t0 d0 :=
    fun t0 d0 ht hd0 => terminalFaceCE162_no_offPair_at_or_above q hface hcensus t0 d0 ht hd0
  exact FrontierCE162.rh_program78_frontier_CE162 q hz78 hqz0 honline Qside hZPT2
    hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hW118 hW119 hW120 hW121 hW122 hW123 hW124 hW125 hW126 hW127 hW128 hW129 hW130 hW131 hW132 hW133 hW134 hW135 hW136 hW137 hW138 hW139 hW140 hW141 hW142 hW143 hW144 hW145 hW146 hW147 hW148 hW149 hW150 hW151 hW152 hW153 hW154 hW155 hW156 hW157 hW158 hW159 hW160 hW161 hW162 hW163 hqzCensus
    (by { intro t0 d0 ht hd0 hoff; exact absurd hoff (hno t0 d0 ht hd0) })
    (by { intro t0 d0 ht hd0 hoff; exact absurd hoff (hno t0 d0 ht hd0) })
    (FrontierCE162.terminalFaceCE162_elim_hWin q hface)

end TerminalFaceCE162
