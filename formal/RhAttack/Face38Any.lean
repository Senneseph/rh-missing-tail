/-
**Face38Any - the [Z78]-SHARP FACE IDENTITY at an ARBITRARY census frontier
(lane M5, route (b): the reusable engine behind Face38CE94 and its future
siblings).

ROLE: Face38CE94 (0408) proved, at the concrete CE94 frontier
H = tCE94 = 3 000 175 776 723, that the CE-series terminal face and the
[Z78]-sharp 3/8-strip no-off-pair statement are THE SAME open object.
This module lifts that identity to an ARBITRARY frontier H > 0, so that
every future re-anchor (CE95, CE96, ...) and the original 0289 growth
frontier (H = tPT2) all inherit the same identity by one-line
instantiation:

  * z78_plus_strip38_H (direction 1, NO census input): [Z78] + the
    zero-set premise + "no off-pair in (H, inf) x (0, 3/8]" implies
    "every zero of q with H < Im lies on the line". [Z78] closes the
    d0 > 3/8 part (Z78.offPairD0le forces every off-pair into
    0 < d0 <= 3/8). This subsumes RHEnd.faceIdentity_z78_plus_unified38
    (H := WinC.tPT2) and Face38CE94.z78_plus_strip38_gives_terminalFace
    CE94 (H := CE94.tCE94).

  * faceAboveH_gives_strip38 (direction 2, census up to H for the
    boundary height exactly at H): "every zero above H on the line" +
    WinC.allOnLineUpTo q H implies "no off-pair in (H, inf) x (0, 3/8]"
    - in fact at EVERY d0 (the 3/8 restriction is not used); the
    negative-height half runs through the ZeroSet symmetry fields
    (q.conj / star, the HFE-after-HCJ pattern).

  * faceAboveH_iff_strip38 (the combined iff, under [Z78] + the zero-set
    premise + the boundary census): the two languages of the face above
    H are the same open object.

The CONCRETE frontier instantiations are stated at the bottom
(tPT2 = the 0289 object; tCE94 = 0408) - both provably equal to the
already-committed concrete theorems, so this engine is a strict
generalization of the in-tree facts.

HONESTY: LEAN-PROVEN (three generic theorems + two one-line
instantiations - pure composition over Z78.offPairD0le,
WinC.allOnLineUpTo, the ZeroSet symmetry fields, and norm_num).
NO RH CLAIM: for every H the 3/8-strip face above H remains a NAMED
open object when H is above the certified census; the identity
reconciles languages, it does not close the face. -/

import RhAttack.RHEnd
import RhAttack.CE94

open Real B0 P12
open Complex

namespace Face38Any

/-- THE FACE ABOVE H (the 0288 terminal face with the growth frontier
replaced by an arbitrary H): no off-line zero with positive height above
H. RHEnd.terminalFace is H := WinC.tPT2; CE94.terminalFaceCE94 is
H := CE94.tCE94. -/
def faceAboveH (q : ZeroSet) (H : ℝ) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → H < ρ.im → ρ.re = 1/2

/-- DIRECTION 1 (generic, NO census input): under [Z78] (zero-free at
Re > 7/8) and the zero-set premise, the 3/8-strip no-off-pair statement
above H implies the face above H. The off-line zero ρ above H gives the
off-pair (ρ.im, |ρ.re - 1/2|) at positive height, and Z78.offPairD0le
forces its offset into 0 < d0 <= 3/8, where the strip face excludes it.
Subsumes RHEnd.faceIdentity_z78_plus_unified38 (H := tPT2) and
Face38CE94 direction 1 (H := tCE94). NO RH CLAIM. -/
theorem z78_plus_strip38_H (q : ZeroSet) (H : ℝ) (hH : 0 < H)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace38 : ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
      ¬ offPair q t0 d0) :
    faceAboveH q H := by
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
  have h38 : d0 ≤ 3/8 :=
    Z78.offPairD0le q hz78 hqz t0 d0 ht0pos hd0pos hp
  exact (hFace38 t0 d0 (le_of_lt ht) hd0pos h38) hp

/-- DIRECTION 2 (generic, census up to H for the boundary height exactly
at H): the face above H + the allOnLineUpTo census up to H imply the
3/8-strip no-off-pair statement above H - in fact at EVERY d0 (the 3/8
restriction is not used). A zero at the frontier height t0 = H exactly is
carried by the census; t0 > H by the face; the negative-height half runs
through the ZeroSet symmetry fields (q.conj / star - the HFE-after-HCJ
pattern). -/
theorem faceAboveH_gives_strip38 (q : ZeroSet) (H : ℝ)
    (hCensus : WinC.allOnLineUpTo q H)
    (hFace : faceAboveH q H) :
    ∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 3/8 → ¬ offPair q t0 d0 := by
  intro t0 d0 _ hd0 _ hpo
  obtain ⟨ρ, hρ, hre, him, hd⟩ := hpo
  by_cases hpos : 0 < ρ.im
  · -- ρ.im > 0: the census covers exactly H, the face above.
    by_cases hle : ρ.im ≤ H
    · exact hre (hCensus ρ hρ hpos hle)
    · exact hre (hFace ρ hρ (not_le.mp hle))
  · -- ρ.im < 0: the conjugate twin at the same positive height carries
      -- the same Re-part (0288 pattern).
    have hneg : ρ.im < 0 := by
      have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
      have hne : ρ.im ≠ 0 := q.nonReal ρ hρ
      exact lt_of_le_of_ne hle0 hne
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

/-- THE COMBINED IFF (generic, under [Z78] + the zero-set premise + the
boundary census): the face above H and the [Z78]-sharp 3/8-strip
no-off-pair statement above H are THE SAME open object. NO RH CLAIM: both
sides remain named open objects above an H beyond the certified census. -/
theorem faceAboveH_iff_strip38 (q : ZeroSet) (H : ℝ) (hH : 0 < H)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q H) :
    faceAboveH q H ↔
      (∀ (t0 d0 : ℝ), H ≤ t0 → 0 < d0 → d0 ≤ 3/8 → ¬ offPair q t0 d0) := by
  constructor
  · exact faceAboveH_gives_strip38 q H hCensus
  · intro hFace38
    exact z78_plus_strip38_H q H hH hz78 hqz hFace38

/-- THE 0289 GROWTH-FRONTIER INSTANCE (H := WinC.tPT2): the generic
identity recovers the in-tree 0289 pair - the 0288 terminal face and the
unified38 face at the Platt-Trudgian frontier are the same open object.
NO RH CLAIM. -/
theorem at_growth_frontier (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q WinC.tPT2) :
    faceAboveH q (WinC.tPT2 : ℝ) ↔
      (∀ (t0 d0 : ℝ), (WinC.tPT2 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
        ¬ offPair q t0 d0) := by
  have hH : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  exact faceAboveH_iff_strip38 q (WinC.tPT2 : ℝ) hH hz78 hqz hCensus

/-- THE CE94 CENSUS-FRONTIER INSTANCE (H := CE94.tCE94): the generic
identity recovers 0408 at the certified census frontier (margin 443 923
over tPT2, census 1 899 982 over (g_a1, g_b94]). NO RH CLAIM. -/
theorem at_ce94_frontier (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q (CE94.tCE94 : ℝ)) :
    faceAboveH q (CE94.tCE94 : ℝ) ↔
      (∀ (t0 d0 : ℝ), (CE94.tCE94 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
        ¬ offPair q t0 d0) := by
  have hH : 0 < (CE94.tCE94 : ℝ) := by norm_num [CE94.tCE94]
  exact faceAboveH_iff_strip38 q (CE94.tCE94 : ℝ) hH hz78 hqz hCensus

end Face38Any
