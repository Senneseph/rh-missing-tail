/-
**Face38PosReserve - THE TERMINAL FACE AT THE SHARPEST IN-TREE BAND
(under the strongest named zero-free input [Z78PR]):

    faceAboveH q H  <-->  no off-pair (t0, d0) with 0 < d0 <=
                          posReserveD0max above H

ROLE: the Z78* family formalizes a ladder of cited zero-free results
as named inputs, each confining every off-line zero to a narrower
offset band: [Z78] (Re strip 3/8)  <-  [Z78Liu]  <-  [Z78Track]  <-
[Z78Gao]  <-  [Z78C/Collet]  <-  [Z78Arvi31]  <-  [Z78Arvi]  <-
[Z78PosReserve] (STRONGEST: zero-free on Re s > posReserveUpper =
8733819666133/10000000000000 ~= 0.87338197, hence
d0 <= posReserveD0max ~= 0.37338197, the smallest band in the ladder,
with extPosReserve_implies_extArvi strengthening the chain). This
module states the Face38Any identity at the SHARPEST band: the
re-anchored terminal face above a frontier H (the 0288 object at
H = tCE96, the re-anchor target of the CE series) is THE SAME open
object as no-off-pair in the posReserve band above H, under
[Z78PosReserve] + the zero-set premise + the boundary census.

  * faceAboveH_gives_stripD0   - direction 2, GENERIC in the band
    width D: face above H + boundary census --> no off-pair for
    0 < d0 <= D above H (the bound D is NOT used by the proof - the
    face excludes EVERY offset at or above H).
  * stripD0_implies_faceAboveH - direction 1, GENERIC: any named
    zero-free input confining off-pair offsets to d0 <= D, together
    with the D-band no-off-pair statement above H, gives the face.
  * faceAboveH_iff_posReserveStrip - the combined iff INSTANTIATED
    at the strongest input (offPairD0lePosReserve).
  * at_ce96_frontier_posReserve - the concrete frontier instance:
    CE96.terminalFaceCE96 q (definitionally faceAboveH q tCE96)
    <--> no off-pair in the posReserve band above tCE96.

CONSEQUENCE: the SOLE analytic residue of RH at the certified census
frontier (TerminalFaceCE96, 0416) is, under [Z78PR], the
posReserve-band no-off-pair statement above tCE96; within that band
the S4 squeeze strip covers d0 in (0, 1/200) (the hWin residual
leg, its own named inputs), and the MID BAND [1/200, posReserveD0max]
is the practical open attack region.

HONESTY: LEAN-PROVEN (four theorems - pure generalization of the
Face38Any pair plus composition over Z78PosReserve.offPairD0lePosReserve
+ norm_num). NO RH CLAIM: under ANY of the Z78* inputs the band
face above a frontier beyond the certified census remains a NAMED
open object; the identity reconciles languages at the sharpest
width, it does not close the face. -/

import RhAttack.Face38Any
import RhAttack.CE96
import RhAttack.Z78PosReserve

open Real B0 P12
open Complex

namespace Face38PosReserve

/-- DIRECTION 2 (GENERIC band width): the face above H + the boundary
    census exclude every off-pair (t0, d0) with H <= t0 and ANY offset
    bound 0 < d0 <= D the statement carries - the bound D is irrelevant
    to the proof (the face excludes all offsets at or above H). This is
    the Face38Any direction-2 proof generalized off the 3/8 width. -/
theorem faceAboveH_gives_stripD0 (q : ZeroSet) (H D : ℝ)
    (hCensus : WinC.allOnLineUpTo q H)
    (hFace : Face38Any.faceAboveH q H) :
    ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ D → ¬ offPair q t0 d0 := by
  intro t0 d0 _ hd0 _ hpo
  obtain ⟨ρ, hρ, hre, him, hd⟩ := hpo
  by_cases hpos : 0 < ρ.im
  · by_cases hle : ρ.im ≤ H
    · exact hre (hCensus ρ hρ hpos hle)
    · exact hre (hFace ρ hρ (not_le.mp hle))
  · have hneg : ρ.im < 0 := by
      have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
      have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
      exact lt_of_le_of_ne hle0 hne0
    have habs : -ρ.im = t0 := by
      rw [abs_of_nonpos (le_of_lt hneg)] at him
      exact him
    have hst : star ρ ∈ q.Z := q.conj ρ hρ
    have himst2 : (star ρ).im = t0 := by
      simp only [star] at ⊢
      exact habs
    have himst0 : 0 < (star ρ).im := by
      simp only [star]
      linarith [hneg]
    by_cases hstrict : H < (star ρ).im
    · exact hre (hFace (star ρ) hst hstrict)
    · exact hre (hCensus (star ρ) hst himst0 (not_lt.mp hstrict))

/-- DIRECTION 1 (GENERIC): under any named zero-free input whose
    offset consequence confines EVERY off-pair to 0 < d0 <= D, the
    D-band no-off-pair statement above H gives the face above H. This
    is the Face38Any direction-1 proof generalized off the concrete
    Z78.offPairD0le offset theorem. -/
theorem stripD0_implies_faceAboveH (q : ZeroSet) (H D : ℝ) (hH : 0 < H)
    (hOff : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → offPair q t0 d0 → d0 ≤ D)
    (hStrip : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ D → ¬ offPair q t0 d0) :
    Face38Any.faceAboveH q H := by
  intro ρ hρ ht
  by_contra hnot
  set t0 := ρ.im with ht0def
  set d0 := |ρ.re - 1/2| with hd0def
  have hd0pos : 0 < d0 := by
    rw [hd0def]
    exact abs_pos.mpr (by
      intro hz
      have hre : ρ.re = 1/2 := by linarith [hz]
      exact hnot hre)
  have ht0pos : 0 < t0 := by
    rw [ht0def]
    linarith [ht, hH]
  have hp : offPair q t0 d0 :=
    ⟨ρ, hρ,
      by intro hre; exact (show ¬ ρ.re = 1/2 from hnot) hre,
      by rw [ht0def, abs_of_nonneg (le_of_lt ht0pos)],
      by rw [hd0def]⟩
  have hD : d0 ≤ D := hOff t0 d0 ht0pos hd0pos hp
  exact (hStrip t0 d0 (le_of_lt ht) hd0pos hD) hp

/-- THE COMBINED IFF AT THE SHARPEST BAND (under [Z78PosReserve] + the
    zero-set premise + the boundary census): the face above H and the
    posReserve-band no-off-pair statement above H (0 < d0 <=
    posReserveD0max ~= 0.37338197 - the SMALLEST band in the Z78*
    ladder) are THE SAME open object. -/
theorem faceAboveH_iff_posReserveStrip (q : ZeroSet) (H : ℝ) (hH : 0 < H)
    (hz : Z78PosReserve.externalZeroFree78PosReserve)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q H) :
    Face38Any.faceAboveH q H ↔
      (∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 →
        d0 ≤ Z78PosReserve.posReserveD0max → ¬ offPair q t0 d0) := by
  constructor
  · intro hFace
    exact faceAboveH_gives_stripD0 q H Z78PosReserve.posReserveD0max hCensus hFace
  · intro hStrip
    exact stripD0_implies_faceAboveH q H Z78PosReserve.posReserveD0max hH
      (fun t0 d0 ht0 hd0 hp =>
        Z78PosReserve.offPairD0lePosReserve q hz hqz t0 d0 ht0 hd0 hp)
      hStrip

/-- THE CONCRETE FRONTIER INSTANCE (H = tCE96): the re-anchored terminal
    face of the CE series (definitionally faceAboveH at tCE96) is the
    same open object as no off-pair in the SHARPEST Z78* band above
    tCE96 = 3 000 175 786 069. With TerminalFaceCE96 (0416) this says:
    RH at the certified census frontier, under [Z78PR], reduces to ONE
    named band face - no off-pair with 0 < d0 <= posReserveD0max and
    t0 >= tCE96. NO RH CLAIM: that band face is the open analytic
    residue (its (0, 1/200) sub-strip is the S4/hWin squeeze object,
    the mid strip [1/200, posReserveD0max] the practical attack region). -/
theorem at_ce96_frontier_posReserve (q : ZeroSet)
    (hz : Z78PosReserve.externalZeroFree78PosReserve)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q (CE96.tCE96 : ℝ)) :
    CE96.terminalFaceCE96 q ↔
      (∀ (t0 d0 : ℝ), (CE96.tCE96 : ℝ) ≤ t0 → 0 < d0 →
        d0 ≤ Z78PosReserve.posReserveD0max → ¬ offPair q t0 d0) := by
  have hH : 0 < (CE96.tCE96 : ℝ) := by
    norm_num [CE96.tCE96]
  show Face38Any.faceAboveH q (CE96.tCE96 : ℝ) ↔ _
  exact faceAboveH_iff_posReserveStrip q (CE96.tCE96 : ℝ) hH hz hqz hCensus

end Face38PosReserve
