/-
**Face38CE94 - [Z78]-SHARP FACE IDENTITY at the CE94 census frontier
(lane M5, route (b): the two languages of the open face, reconciled at the
current frontier).

ROLE: RHEnd.lean (0289) already proves, at the GROWTH frontier tPT2, that
the named open object of all-heights RH can be stated in two equivalent
languages:
  (a) the 0288 terminal face: no off-line zero with positive height above
      the frontier (ANY offset d0);
  (b) the unified38 face: no off-pair (t0, d0) with 0 < d0 <= 3/8 above
      the frontier - the [Z78]-SHARP form, since Z78.offPairD0le forces
      every off-pair into 0 < d0 <= 3/8 (zero-free at Re > 7/8 plus the
      functional equation put the zero into the strip [1/8, 7/8]).
This module performs the SAME reconciliation at the CERTIFIED CENSUS
frontier H = tCE94 = 3 000 175 776 723 (the CE94 frontier, 0406; margin
443 923 over tPT2; census 1 899 982 over (g_a1, g_b94]):

  * z78_plus_strip38_gives_terminalFaceCE94 (direction 1, NO census
    needed): [Z78] + the zero-set premise + "no off-pair in
    (tCE94, inf) x (0, 3/8]" implies terminalFaceCE94 - the 3/8-strip
    form IS a closing of the re-anchored face; [Z78] closes the
    d0 > 3/8 part.

  * terminalFaceCE94_gives_strip38 (direction 2, boundary census at the
    exact frontier height): terminalFaceCE94 + the allOnLineUpTo census
    at tCE94 (= CE94.allOnLineUpToCE94 under the window clauses) implies
    the no-off-pair statement in (tCE94, inf) x (0, 3/8]; the d0 <= 3/8
    restriction is not needed (the clauses cover every d0); height < 0
    by conjugation.

  * terminalFaceCE94_iff_strip38 (the combined iff, under [Z78] + the
    zero-set premise + the boundary census): the two languages are THE
    SAME open object at the CE94 frontier - closing either closes all
    of RH together with the certified census.

  * strip38_discharges_hWin (corollary): since 1/200 < 3/8, the 3/8-strip
    face at tCE94 discharges the endpoint's hWin residual leg
    (WinC.hWinFaceResidualH q (tCE94 : ℝ), the (0, 1/200) window) - so
    the FrontierCE94 endpoint (0407) and the 0289 endpoint both reduce
    to the same named 3/8-strip object at the same frontier.

HONESTY: LEAN-PROVEN (two identity directions, one iff, one corollary -
pure composition over Z78.offPairD0le, WinC.allOnLineUpTo, the ZeroSet
symmetry fields (q.conj / star, the HFE-after-HCJ pattern of
WinC.noOffPairBelowPT) and CE94.terminalFaceCE94). NO RH CLAIM: the
3/8-strip face at tCE94 remains the NAMED open object; this unit
reconciles the languages of the face, it does NOT close it.
-/

import RhAttack.RHEnd
import RhAttack.CE94

open Real B0 P12
open Complex

namespace Face38CE94

/-- DIRECTION 1 ([Z78]-SHARP: the 3/8-strip form closes the face; NO
census input needed): under [Z78] (zero-free at Re > 7/8) and the zero-set
premise, if there is no off-pair (t0, d0) with t0 >= tCE94 and
0 < d0 <= 3/8, then every zero of q with positive height above tCE94 lies
on the line (CE94.terminalFaceCE94 q). The d0 > 3/8 part is closed by
Z78.offPairD0le (it forces every off-pair into 0 < d0 <= 3/8). This is
the 0289 faceIdentity_z78_plus_unified38 direction, at the CE94 census
frontier. NO RH CLAIM: the 3/8-strip face is the named open object. -/
theorem z78_plus_strip38_gives_terminalFaceCE94 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace38 : ∀ (t0 d0 : ℝ), (CE94.tCE94 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
      ¬ offPair q t0 d0) :
    CE94.terminalFaceCE94 q := by
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
  have htCE94pos : 0 < (CE94.tCE94 : ℝ) := by norm_num [CE94.tCE94]
  have ht0pos : 0 < t0 := by
    rw [ht0def]
    linarith [ht, htCE94pos]
  have hp : offPair q t0 d0 :=
    ⟨ρ, hρ,
      by intro hre; exact (show ¬ ρ.re = 1/2 from hnot) hre,
      by rw [ht0def, abs_of_nonneg (le_of_lt ht0pos)],
      by rw [hd0def]⟩
  have h38 : d0 ≤ 3/8 :=
    Z78.offPairD0le q hz78 hqz t0 d0 ht0pos hd0pos hp
  exact (hFace38 t0 d0 (le_of_lt ht) hd0pos h38) hp

/-- DIRECTION 2 (the face form implies the 3/8-strip form; the boundary
height exactly at tCE94 is carried by the allOnLineUpTo census at tCE94):
if every zero of q above tCE94 lies on the line (CE94.terminalFaceCE94 q)
and the census holds up to tCE94 (WinC.allOnLineUpTo q (tCE94 : ℝ) -
machine-realized by CE94.allOnLineUpToCE94 under the 95 window-slice
clauses), then there is no off-pair (t0, d0) with t0 >= tCE94 and
0 < d0 <= 3/8 - in fact at EVERY d0 (the 3/8 restriction is not used).
The d0 side: a zero at the frontier height t0 = tCE94 exactly is covered
by the census clause (|im| <= tCE94); the negative-height half runs
through the ZeroSet symmetry fields (q.conj / star - the HFE-after-HCJ
pattern). This is the 0289 faceIdentity_terminalFace_gives_unified38
direction, at the CE94 census frontier. NO RH CLAIM. -/
theorem terminalFaceCE94_gives_strip38 (q : ZeroSet)
    (hCensus : WinC.allOnLineUpTo q (CE94.tCE94 : ℝ))
    (hFace : CE94.terminalFaceCE94 q) :
    ∀ (t0 d0 : ℝ), (CE94.tCE94 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
      ¬ offPair q t0 d0 := by
  intro t0 d0 _ hd0 _ hpo
  obtain ⟨ρ, hρ, hre, him, hd⟩ := hpo
  by_cases hpos : 0 < ρ.im
  · -- ρ.im > 0: the census covers exactly tCE94, the face above.
    by_cases hle : ρ.im ≤ (CE94.tCE94 : ℝ)
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
      rw [himst2]
      have htCE94pos : 0 < (CE94.tCE94 : ℝ) := by norm_num [CE94.tCE94]
      linarith [htCE94pos]
    by_cases hstrict : (CE94.tCE94 : ℝ) < (star ρ).im
    · exact hre (hFace (star ρ) hst hstrict)
    · exact hre (hCensus (star ρ) hst himst0 (not_lt.mp hstrict))

/-- THE COMBINED IFF at the CE94 census frontier (under [Z78] + the
zero-set premise + the boundary census): the re-anchored terminal face
and the [Z78]-sharp 3/8-strip no-off-pair statement are THE SAME open
object at H = tCE94. Consequence: closing EITHER language closes all of
RH together with the certified census (FrontierCE94.rh_program78_
frontier_CE94 / CE94.rh_of_terminalFaceCE94). NO RH CLAIM: both sides
remain the named open object - this is a reconciliation, not a closing. -/
theorem terminalFaceCE94_iff_strip38 (q : ZeroSet)
    (hz78 : Z78.externalZeroFree78)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCensus : WinC.allOnLineUpTo q (CE94.tCE94 : ℝ)) :
    CE94.terminalFaceCE94 q ↔
      (∀ (t0 d0 : ℝ), (CE94.tCE94 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
        ¬ offPair q t0 d0) := by
  constructor
  · exact terminalFaceCE94_gives_strip38 q hCensus
  · intro hFace38
    exact z78_plus_strip38_gives_terminalFaceCE94 q hz78 hqz hFace38

/-- COROLLARY (the endpoint wiring follows the 3/8 face): since
1/200 < 3/8 and tCE94 >= 1000, the [Z78]-sharp 3/8-strip face at tCE94
discharges the endpoint's hWin residual leg (WinC.hWinFaceResidualH q
(tCE94 : ℝ) - the (0, 1/200) window at heights >= 1000). Together with
FrontierCE94 (0407): the endpoint at the CE94 census frontier AND the
0289 unified38 endpoint both reduce to this same named 3/8-strip object.
NO RH CLAIM: the 3/8-strip face remains the named open object. -/
theorem strip38_discharges_hWin (q : ZeroSet)
    (hFace38 : ∀ (t0 d0 : ℝ), (CE94.tCE94 : ℝ) ≤ t0 → 0 < d0 → d0 ≤ 3/8 →
      ¬ offPair q t0 d0) :
    WinC.hWinFaceResidualH q (CE94.tCE94 : ℝ) := by
  intro t0 d0 ht0 ht1 hd0 hdw
  have htCE94pos : (1000 : ℝ) ≤ (CE94.tCE94 : ℝ) := by norm_num [CE94.tCE94]
  have hd0u : d0 ≤ 3/8 := by linarith [hdw]
  exact hFace38 t0 d0 (le_of_lt ht1) hd0 hd0u

end Face38CE94
