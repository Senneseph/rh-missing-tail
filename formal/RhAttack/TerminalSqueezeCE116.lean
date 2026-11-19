/-
**TerminalSqueezeCE116 - THE FINAL ASSEMBLY AT THE CENSUS FRONTIER:
RH from the two squeeze faces (low strip + mid band) and the census.

Under the strongest named zero-free input [Z78PosReserve] (Re strip
[1-u, u], u = 8733819666133/10^13 ~= 0.87338197, so every off-line
zero has 0 < d0 = |Re - 1/2| < 1/2 - EVERY off-line zero sits in the
squeeze territory, the far regions Re <= 0 / Re >= 1 excluded by the
named input itself), the re-anchored census frontier H = tCE116, the
boundary census, the S4-STRIP FACE (no off-pair in (H, inf) x
(0, 1/200) - the hWin residual, zero-excluded by the S4 squeeze strip
under its named S4 inputs), and the S3-BAND FACE (the S3 wire bound at
every off-pair in (H, inf) x [1/200, 1/2) - under which the in-body T4
squeeze (T4OffLF.squeeze_discharged_inbody with the in-body
T4OffLF.pin and the in-body a2c_sL_bridge) forces False), every zero
of q is on the line: RH q.

THE REDUCTION (all in-tree, composition only):
  * [Z78PR] strip (zetaZeroStripPosReserve): 0 < Re rho < 1 for
    every zero, hence 0 < d0 < 1/2 for every off-line zero;
  * the FE (q.fe) and conj (q.conj) fields normalize any off-line
    zero to the left half-plane at positive height (the
    HFE-after-HCJ pattern, four cases);
  * t0 <= tCE116: the BOUNDARY-INCLUSIVE census;
  * t0 > tCE116, d0 < 1/200: the hWin strip face;
  * t0 > tCE116, 1/200 <= d0 < 1/2: the off-pair witnesses the S3-band
    face at (t0, d0) (the S3 wire bound at sOff = 1/2 - d0 + i t0),
    and the T4 squeeze (in-body pin + in-body cited A2c bridge)
    gives False.

WITH TerminalFaceCE116 (0421) and Face38PosReserve (0417), the chain
is: RH at the certified census frontier <== census + ONE named band
face (the posReserve band) under [Z78PR] <== the TWO squeeze faces
of this module (low strip + mid band) under [Z78PR]. The named
analytic residue of the program at the frontier is exactly:
  (i)  the S4-STRIP FACE  (0 < d0 < 1/200,   t0 > tCE116)  [hWin],
  (ii) the S3-BAND FACE   (1/200 <= d0 < 1/2, t0 > tCE116)  [S3 wire],
together with the cited inputs ([Z78PR], the A2c bridge, Ismail
[IS-S] for the A1/S1 side) and the in-tree census.

THEOREMS (LEAN-PROVEN composition + exact rational order facts):
  * stripD0ltHalf  - 0 < rho.re < 1 < 1 and hence
                     |rho.re - 1/2| < 1/2 for every zero under
                     [Z78PR] (exact: 1 - u = 1266180333867/10^13);
  * rh_from_bandfaces - THE FINAL ASSEMBLY above.

NO RH CLAIM: the two squeeze faces are NAMED INPUTS (the S4-STRIP
face is the hWin residual of the S4/T4 squeeze ladder; the S3-BAND
face is the S3 definition-side wire at off-pairs); the census is
in-tree data (tPT2 + 97 verified window clauses). -/

import Mathlib
import RhAttack.WinCount
import RhAttack.CE116
import RhAttack.FrontierCE116
import RhAttack.Z78PosReserve
import RhAttack.T4OffL
import RhAttack.T4OffLE
import RhAttack.T4OffLF
import RhAttack.S4Asm
import RhAttack.P4Limit

open Real B0 P12
open Complex

namespace TerminalSqueezeCE116

variable (q : ZeroSet)

/-- EVERY OFF-LINE ZERO SITS IN THE SQUEEZE TERRITORY under [Z78PR]:
    the posReserve strip corollary bounds rho.re in
    [1 - u, u] with u = 8733819666133/10^13 < 1 and 1 - u > 0
    (exact: 1 - u = 1266180333867/10^13) - hence 0 < rho.re < 1
    and |rho.re - 1/2| < 1/2 (the far regions Re <= 0 and
    Re >= 1 are empty for any actual-set zero set under [Z78PR]). -/
theorem stripD0ltHalf (hz : Z78PosReserve.externalZeroFree78PosReserve)
    (hqz0 : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (ρ : ℂ) (hρ : ρ ∈ q.Z) :
    |ρ.re - 1 / 2| < 1 / 2 := by
  have hnr : ρ.im ≠ 0 := q.nonReal ρ hρ
  have hstrip := Z78PosReserve.zetaZeroStripPosReserve hz ρ (hqz0 ρ hρ) hnr
  have hlo : 1 - Z78PosReserve.posReserveUpper ≤ ρ.re := hstrip.1
  have hhi : ρ.re ≤ Z78PosReserve.posReserveUpper := hstrip.2
  have hu : Z78PosReserve.posReserveUpper < 1 := by
    norm_num [Z78PosReserve.posReserveUpper]
  have h1u : 0 < 1 - Z78PosReserve.posReserveUpper := by
    norm_num [Z78PosReserve.posReserveUpper]
  have hlo0 : 0 < ρ.re := by linarith [hlo, h1u]
  have hhi1 : ρ.re < 1 := by linarith [hhi, hu]
  rw [abs_lt]
  constructor <;> nlinarith [hlo0, hhi1]


/-- THE CANONICAL CLOSURE (private, the engine of the final assembly): a
    zero in the LEFT half-plane at POSITIVE height (off the line) above
    or at the census frontier is excluded - AT/BELOW by the
    boundary-inclusive census, and ABOVE by the two squeeze faces: the
    S4-STRIP face (hWin residual) for d0 < 1/200, and the S3-BAND face
    plus the in-body T4 squeeze (in-body pin + in-body A2c bridge) for
    1/200 <= d0 < 1/2. -/
private theorem leftPosClosed (q : ZeroSet)
    (hcensus : WinC.allOnLineUpTo q (CE116.tCE116 : ℝ))
    (hWinF : WinC.hWinFaceResidualH q (CE116.tCE116 : ℝ))
    (hs3band : ∀ (t0 d0 : ℝ), (CE116.tCE116 : ℝ) < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 < (1 / 2 : ℝ) → P12.offPair q t0 d0 →
        ‖riemannZeta (t4l_sOffL t0 d0) -
          (p4_P (T4OffLE.Noff t0 d0) (t4l_sOffL t0 d0) -
            p4_I (T4OffLE.Noff t0 d0) (t4l_sOffL t0 d0))‖ ≤
        S4A.BwireR t0 d0 + S4A.MrR t0 d0)
    (ρt : ℂ) (hρt : ρt ∈ q.Z) (hnot3 : ¬ (ρt.re = 1 / 2))
    (hre0 : 0 < ρt.re) (hreLt : ρt.re < 1 / 2) (hp0 : 0 < ρt.im) :
    False := by
  have hCE1000 : (1000 : ℝ) ≤ (CE116.tCE116 : ℝ) := by
    norm_num [CE116.tCE116]
  have hCEPT2 : WinC.tPT2 < (CE116.tCE116 : ℝ) := FrontierCE116.ce116AbovePT2
  by_cases hup : (CE116.tCE116 : ℝ) < ρt.im
  · -- ABOVE the frontier
    set d0 := 1 / 2 - ρt.re with hddef
    have hdpos : 0 < d0 := by rw [hddef]; exact sub_pos.mpr hreLt
    have hdl2 : d0 < 1 / 2 := by rw [hddef]; linarith [hre0]
    have hp : P12.offPair q ρt.im d0 :=
      ⟨ρt, hρt,
        fun hre => hnot3 (by linarith [hre]),
        abs_of_nonneg (le_of_lt hp0),
        by rw [hddef, abs_of_nonpos (by linarith [hreLt]), neg_sub]⟩
    by_cases hlow : d0 < (1 / 200 : ℝ)
    · -- the S4-STRIP face (hWin residual)
      exact (hWinF ρt.im d0 (by linarith [hup, hCE1000]) hup hdpos hlow) hp
    · -- the S3-BAND face + the in-body T4 squeeze
      have hd : (1 / 200 : ℝ) ≤ d0 := not_lt.mp hlow
      have hhs3 := hs3band ρt.im d0 hup hd hdl2 hp
      have hpt2 : WinC.tPT2 ≤ ρt.im := by linarith [hup, hCEPT2]
      exact T4OffLF.squeeze_discharged_inbody ρt.im d0 hpt2 hd hdl2 hhs3
  · -- AT/BELOW the frontier: the boundary-inclusive census
    exact hnot3 (hcensus ρt hρt hp0 (not_lt.mp hup))

/-- THE FINAL ASSEMBLY (at H = tCE116 = 3 000 175 786 069): under
    [Z78PosReserve] (the Re strip), the zero-set premise hqz0, the
    CE116 CENSUS (tPT2 base + the 117 verified window-slice clauses),
    the S4-STRIP FACE (hWin residual: no off-pair in (tCE116, inf) x
    (0, 1/200)) and the S3-BAND FACE (the S3 wire bound at every
    off-pair in (tCE116, inf) x [1/200, 1/2) - under which the in-body
    T4 squeeze with the in-body pin and the in-body A2c bridge
    forces False), every zero of q is on the line: RH q. -/
theorem rh_from_bandfaces
    (hz : Z78PosReserve.externalZeroFree78PosReserve)
    (hqz0 : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
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
    (hW42 : CE42B.ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : CE51.ce50WinClauseFull) (hW52 : CE52.ce51WinClauseFull) (hW53 : CE53.ce52WinClauseFull) (hW54 : CE54.ce53WinClauseFull) (hW55 : CE55.ce54WinClauseFull) (hW56 : CE56.ce55WinClauseFull) (hW57 : CE57.ce56WinClauseFull) (hW58 : CE58.ce57WinClauseFull) (hW59 : CE59.ce58WinClauseFull) (hW60 : CE60.ce59WinClauseFull) (hW61 : CE61.ce60WinClauseFull) (hW62 : CE62.ce61WinClauseFull) (hW63 : CE63.ce62WinClauseFull) (hW64 : CE64.ce63WinClauseFull) (hW65 : CE65.ce64WinClauseFull) (hW66 : CE66.ce65WinClauseFull) (hW67 : CE67.ce66WinClauseFull) (hW68 : CE68.ce67WinClauseFull) (hW69 : CE69.ce68WinClauseFull) (hW70 : CE70.ce69WinClauseFull) (hW71 : CE71.ce70WinClauseFull) (hW72 : CE72.ce71WinClauseFull) (hW73 : CE73.ce72WinClauseFull) (hW74 : CE74.ce73WinClauseFull) (hW75 : CE75.ce74WinClauseFull) (hW76 : CE76.ce75WinClauseFull) (hW77 : CE77.ce76WinClauseFull) (hW78 : CE78.ce77WinClauseFull) (hW79 : CE79.ce78WinClauseFull) (hW80 : CE80.ce79WinClauseFull) (hW81 : CE81.ce80WinClauseFull) (hW82 : CE82.ce81WinClauseFull) (hW83 : CE83.ce82WinClauseFull) (hW84 : CE84.ce83WinClauseFull) (hW85 : CE85.ce84WinClauseFull) (hW86 : CE86.ce85WinClauseFull) (hW87 : CE87.ce86WinClauseFull) (hW88 : CE88.ce87WinClauseFull) (hW89 : CE89.ce88WinClauseFull) (hW90 : CE90.ce89WinClauseFull) (hW91 : CE91.ce90WinClauseFull) (hW92 : CE92.ce91WinClauseFull) (hW93 : CE93.ce92WinClauseFull) (hW94 : CE94.ce93WinClauseFull) (hW95 : CE95.ce94WinClauseFull) (hW96 : CE116.ce95WinClauseFull) (hW97 : CE116.ce96WinClauseFull) (hW98 : CE116.ce97WinClauseFull) (hW99 : CE116.ce98WinClauseFull) (hW100 : CE116.ce99WinClauseFull) (hW101 : CE116.ce100WinClauseFull) (hW102 : CE116.ce101WinClauseFull) (hW103 : CE116.ce102WinClauseFull) (hW104 : CE116.ce103WinClauseFull) (hW105 : CE116.ce104WinClauseFull) (hW106 : CE116.ce105WinClauseFull) (hW107 : CE116.ce106WinClauseFull) (hW108 : CE116.ce107WinClauseFull) (hW109 : CE116.ce108WinClauseFull) (hW110 : CE116.ce109WinClauseFull) (hW111 : CE116.ce110WinClauseFull) (hW112 : CE116.ce111WinClauseFull) (hW113 : CE116.ce112WinClauseFull) (hW114 : CE116.ce113WinClauseFull) (hW115 : CE116.ce114WinClauseFull) (hW116 : CE116.ce115WinClauseFull) (hW117 : CE116.ce116WinClause)
    (hqzCensus : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hWinF : WinC.hWinFaceResidualH q (CE116.tCE116 : ℝ))
    (hs3band : ∀ (t0 d0 : ℝ), (CE116.tCE116 : ℝ) < t0 → (1 / 200 : ℝ) ≤ d0 →
      d0 < (1 / 2 : ℝ) → P12.offPair q t0 d0 →
        ‖riemannZeta (t4l_sOffL t0 d0) -
          (p4_P (T4OffLE.Noff t0 d0) (t4l_sOffL t0 d0) -
            p4_I (T4OffLE.Noff t0 d0) (t4l_sOffL t0 d0))‖ ≤
        S4A.BwireR t0 d0 + S4A.MrR t0 d0) :
    RH q := by
  have hcensus : WinC.allOnLineUpTo q (CE116.tCE116 : ℝ) :=
    CE116.allOnLineUpToCE116 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hW53 hW54 hW55 hW56 hW57 hW58 hW59 hW60 hW61 hW62 hW63 hW64 hW65 hW66 hW67 hW68 hW69 hW70 hW71 hW72 hW73 hW74 hW75 hW76 hW77 hW78 hW79 hW80 hW81 hW82 hW83 hW84 hW85 hW86 hW87 hW88 hW89 hW90 hW91 hW92 hW93 hW94 hW95 hW96 hW97 hW98 hW99 hW100 hW101 hW102 hW103 hW104 hW105 hW106 hW107 hW108 hW109 hW110 hW111 hW112 hW113 hW114 hW115 hW116 hW117 hqzCensus
  intro ρ hρ
  by_contra hnot
  have hstrip : |ρ.re - 1 / 2| < 1 / 2 := stripD0ltHalf q hz hqz0 ρ hρ
  have hre0 : 0 < ρ.re := by rw [abs_lt] at hstrip; linarith [hstrip.1]
  have hre1 : ρ.re < 1 := by rw [abs_lt] at hstrip; linarith [hstrip.2]
  -- Normalize any off-line zero to the LEFT half-plane at POSITIVE
  -- height (FE + conj, four cases), then closeLeftPos.
  by_cases hreL : ρ.re < 1 / 2
  · by_cases him : 0 < ρ.im
    · -- LEFT, +height: canonical
      exact leftPosClosed q hcensus hWinF hs3band ρ hρ hnot hre0 hreL him
    · -- LEFT, -height: conjugate
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstP : 0 < (star ρ).im := by
        simp only [star, conj_im]
        have hneg : ρ.im < 0 := lt_of_le_of_ne (not_lt.mp him) (q.nonReal ρ hρ)
        linarith [hneg]
      exact leftPosClosed q hcensus hWinF hs3band (star ρ) hst
        (fun hre => hnot (by
          rw [show (star ρ).re = ρ.re by simp only [star, conj_re]] at hre
          linarith [hre])) hre0
        (by simp only [star, conj_re]; exact hreL) hstP
  · -- RIGHT half-plane (Re > 1/2, since Re ≠ 1/2): the FE mirror
    have hfe : (1 : ℂ) - ρ ∈ q.Z := q.fe ρ hρ
    have hfeL : ((1 : ℂ) - ρ).re < 1 / 2 := by
      simp only [sub_re, one_re]
      have hl2 : 1 / 2 ≤ ρ.re := not_lt.mp hreL
      have hgt : 1 / 2 < ρ.re :=
        lt_of_le_of_ne hl2 (fun h => hnot (Eq.symm h))
      linarith [hgt]
    by_cases him : 0 < ((1 : ℂ) - ρ).im
    · -- 1 - rho: LEFT, +height
      have hfere0 : 0 < ((1 : ℂ) - ρ).re := by
        simp only [sub_re, one_re]
        linarith [hre1]
      exact leftPosClosed q hcensus hWinF hs3band ((1 : ℂ) - ρ) hfe
        (fun hre => hnot (by
          rw [show ((1 : ℂ) - ρ).re = 1 - ρ.re by simp only [sub_re, one_re]] at hre
          linarith [hre])) hfere0 hfeL him
    · -- 1 - rho at NEGATIVE height: conjugate
      have hst : star ((1 : ℂ) - ρ) ∈ q.Z := q.conj ((1 : ℂ) - ρ) hfe
      have hstP : 0 < (star ((1 : ℂ) - ρ)).im := by
        simp only [star, conj_im]
        have hle : ((1 : ℂ) - ρ).im ≤ 0 := not_lt.mp him
        have hne0 : ((1 : ℂ) - ρ).im ≠ 0 := by
          simpa [sub_im, one_im, neg_eq_zero] using (q.nonReal ρ hρ)
        linarith [lt_of_le_of_ne hle hne0]
      have hstL : (star ((1 : ℂ) - ρ)).re < 1 / 2 := by
        simp only [star, conj_re, sub_re, one_re]
        have hl2 : 1 / 2 ≤ ρ.re := not_lt.mp hreL
        have hgt : 1 / 2 < ρ.re := lt_of_le_of_ne hl2 (fun h => hnot (Eq.symm h))
        linarith [hgt]
      have hfere0 : 0 < (star ((1 : ℂ) - ρ)).re := by
        simp only [star, conj_re, sub_re, one_re]
        linarith [hre1]
      exact leftPosClosed q hcensus hWinF hs3band (star ((1 : ℂ) - ρ)) hst
        (fun hre => hnot (by
          rw [show (star ((1 : ℂ) - ρ)).re = 1 - ρ.re by
            simp only [star, conj_re, sub_re, one_re]] at hre
          linarith [hre])) hfere0 hstL hstP

end TerminalSqueezeCE116
