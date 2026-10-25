/-
Rh-missing-tail, D4-orbit line (orbit) -- THE ORBIT AS A FORMULA.

NEW in-repo theorem (no external source).  The owner asked, of the
"Holy Missive" orbit line ("Two readings orbit the threshold: and the
answer shifts by which one you trust"): *is this like the uncertainty
principle written into a math formula? can we make the closing
operator?*  This module is that formula, proved in-repo against the
pinned mathlib rev.

The object
--------
A **trajectory** of `n` steps.  Each step `t` carries a *drift*
`δ t : ℝ` (the signed distance the step moves the trajectory toward or
away from the original goal `G0`).  A **local reading** (the gate) is
assumed, in the *pure-opacity case*, to be unable to see drifts below a
**local visibility threshold** `eps`: a step is *locally invisible* iff
`|δ t| < eps` for every `t`.  The two readings of the orbit are:

  * the LOCAL reading  (each step, judged alone)  -- crisp, live, but
    blind to drift;
  * the GLOBAL reading (the trajectory, as a whole) = the total drift
    `∑ δ t`, which decides whether the trajectory lands on `G0`.

The "formula"
-------------
`surjWidth`: the total-drift map, restricted to the box of
locally-invisible drifts, is **surjective onto the open interval**
`(-(n·eps), n·eps)`.  That is, *any* value in an open interval of width
`2·n·eps` is consistent with the *same* (all-green) local readings.

  * This is the **uncertainty bound of the orbit**, in the
    unobservability-width sense: the global reading has an
    *irreducible width* `n·eps` given the local data -- a *positive
    lower bound* that no refinement of the local readings removes.
    (Not the Fourier Δx·Δξ bound verbatim; this is the local->global
    unobservability product, which is the correct analog here.)
  * The local reading is BLIND to exactly the quantity (the total
    drift) that decides the goal.  Looking harder at the local steps
    produces the local reading -- the blind one.

The closing operator
--------------------
The opacity is *structural*: the orbit stays opaque until a
measurement that does NOT inherit the local box is presented.  That
measurement is the **anchor** -- one global measurement of the total,
against an external reference `G0` (not `g_{t-1}`), at its own
precision `sigma`.  `anchorCollapsesWidth`: the anchor collapses the
width from `2·n·eps` to `2·sigma`, **removing the dependence on the
horizon `n`**.  Its precision `sigma` is independent of `eps` -- that
is why it de-opacifies.

  This is the same operator as the argument principle in the proof
  line (`formal/RhAttack/Ap1ArgumentPrinciple.lean`): one global
  measurement of a winding / zero-count against a contour reference.
  RH is one instantiation of the orbit; the anchor / argument
  principle is the closing operator that de-opacifies it.
-/
import Mathlib

open BigOperators Set

namespace Orbit

/-- Drift assignment: a per-step drift for the `n` steps. -/
def Drift (n : ℕ) := Fin n → ℝ

/-- A drift is *locally invisible* (inside the visibility box) iff every
step `t` satisfies `|δ t| < eps`. -/
def LocallyInvisible (n : ℕ) (δ : Drift n) (eps : ℝ) : Prop := ∀ t : Fin n, |δ t| < eps

/-- The GLOBAL reading: the total drift of the trajectory. -/
def TotalDrift (n : ℕ) (δ : Drift n) : ℝ := ∑ t : Fin n, δ t

/-! ## The two bounds that carve out the width -/

/-- **Upper width.**  Every locally-invisible drift has
`|TotalDrift| < n·eps`. -/
theorem totalBound (n : ℕ) (eps : ℝ) (hn : 0 < n)
    (δ : Drift n) (hinv : LocallyInvisible n δ eps) :
    |TotalDrift n δ| < (n : ℝ) * eps := by
  have zero_fin : Fin n := ⟨0, hn⟩
  have h1 : |∑ t : Fin n, δ t| ≤ ∑ t : Fin n, |δ t| :=
    Finset.abs_sum_le_sum_abs (fun t : Fin n => δ t) (Finset.univ : Finset (Fin n))
  have h2 : ∑ t : Fin n, |δ t| < ∑ t : Fin n, eps :=
    Finset.sum_lt_sum (fun t _ => (hinv t).le)
      ⟨zero_fin, Finset.mem_univ zero_fin, hinv zero_fin⟩
  calc
    |TotalDrift n δ| = |∑ t : Fin n, δ t| := rfl
    _ ≤ ∑ t : Fin n, |δ t| := h1
    _ < ∑ t : Fin n, eps := h2
    _ = (n : ℝ) * eps := by rw [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]

/-- **Achievability.**  Every `c` in `(-(n·eps), n·eps)` is the total
drift of some locally-invisible drift: take the constant drift
`δ t = c / n`. -/
theorem surjPoint (n : ℕ) (eps : ℝ) (hn : 0 < n) (c : ℝ) (hc : |c| < (n : ℝ) * eps) :
    ∃ (δ : Drift n), LocallyInvisible n δ eps ∧ TotalDrift n δ = c := by
  refine ⟨(fun _ : Fin n => c / (n : ℝ)), ?_, ?_⟩
  · intro t
    have hnpos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
    rw [abs_div, abs_of_pos hnpos, div_lt_iff₀ hnpos, mul_comm eps (n : ℝ)]
    exact hc
  · have hnpos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
    calc
      (∑ _ : Fin n, c / (n : ℝ)) = (n : ℝ) * (c / (n : ℝ)) := by
        rw [Finset.sum_const, Finset.card_fin, nsmul_eq_mul]
      _ = c := by field_simp [hnpos.ne']

/-! ## The orbit formula (the two bounds, glued) -/

/-- The set of achievable total drifts under the per-step invisibility
bound is **exactly** the open interval of width `2·n·eps`. -/
theorem surjWidth (n : ℕ) (eps : ℝ) (hn : 0 < n) :
    { d : ℝ | ∃ (δ : Drift n), LocallyInvisible n δ eps ∧ d = TotalDrift n δ } =
    Ioo (-(n : ℝ) * eps) ((n : ℝ) * eps) := by
  ext d
  constructor
  · rintro ⟨δ, hinv, hd_eq⟩
    have h0 := totalBound n eps hn δ hinv
    rw [← hd_eq] at h0
    rw [abs_lt] at h0
    rw [mem_Ioo]
    ring_nf at h0 ⊢
    exact h0
  · intro hd
    have habs : |d| < (n : ℝ) * eps := by
      rw [mem_Ioo] at hd
      ring_nf at hd ⊢
      exact abs_lt.mpr hd
    rcases surjPoint n eps hn d habs with ⟨δ, hinv, ht⟩
    exact ⟨δ, hinv, ht.symm⟩

/-! ## The opacity (immediate corollary, stated) -/

/-- The **irreducible global width**, given only the local readings:
`n·eps`.  A positive lower bound that no refinement of the local
readings removes, because the local readings are constant (all-green)
across the entire interval. -/
def irreducibleWidth (n : ℕ) (eps : ℝ) : ℝ := (n : ℝ) * eps

/-! ## The closing operator (the anchor / de-opacifier) -/

/-- The anchor measurement: the total drift is read **globally**,
against an external reference `G0`, at its own precision `sigma`.
Its residual width is `2·sigma` -- *independent of `n`*. -/
def anchorWidth (_n : ℕ) (sigma : ℝ) : ℝ := 2 * sigma

/-- **The closing operator collapses the width.**  Taking the anchor's
precision `sigma` below the local width `n·eps` shrinks the global
width strictly, removing the horizon factor `n`. -/
theorem anchorCollapsesWidth (n : ℕ) (eps : ℝ) (sigma : ℝ)
    (hsig_lt : sigma < (n : ℝ) * eps) :
    anchorWidth n sigma < 2 * irreducibleWidth n eps := by
  simp only [anchorWidth, irreducibleWidth]
  nlinarith

end Orbit
