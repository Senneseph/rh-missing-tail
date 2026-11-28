/-
Copyright (c) 2026 honline project. All rights reserved.
Released under Apache-2.0.

# Phase 0.5 — disk zero count for the honline program

The circular argument principle, built from the pinned Mathlib v4.33.1
circle-integral lemmas (exact statements audited in the Phase 0 ledger of
`docs/ONLINE-FORMALIZATION-SCOPE.md`):

- `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable`
  (the residue unit: `∮ (z-w)⁻¹ • f = 2πi · f w`),
- `circleIntegral_eq_zero_of_differentiable_on_off_countable`
  (kills the non-singular part of the logarithmic derivative),
- `MeromorphicOn.extract_zeros_poles`
  (factors `f = (∏ᶠ (·-u)^{divisor}) · g` with `g` analytic and nonzero).

Target (to be proved in this module):

```
countZerosDisk : for f analytic on a nbd of the closed disk closedBall c R,
  no zeros on the circle, and no infinite-order vanishing inside,
  ∮_{C(c,R)} f'/f = 2πi · (Σᶠ u, divisor f (closedBall c R) u)
```

For entire f (like ζ) the divisor is supported on the zeros with positive
multiplicity, so the sum is the zero count with multiplicity.

NO RH CLAIM. No `sorry`, no `admit`, no axioms. All constants are classical.
-/
import Mathlib

open Complex Set Function Filter MeromorphicOn Metric

set_option maxHeartbeats 400000

/-! ## Definitions -/

/-- The divisor sum of `f` on the closed disk `closedBall c |R|`: the count
    of zeros minus the count of poles, each with multiplicity. `finsum` is
    `0` when the support is infinite, but the support of the divisor of a
    meromorphic function is finite on a compact disk
    (`locallyFinsuppWithin.finiteSupport`). -/
noncomputable def zeroCount (c : ℂ) (R : ℝ) (f : ℂ → ℂ) : ℤ :=
  finsum (fun u : ℂ => divisor f (closedBall c |R|) u)

/-! ## Setup lemmas -/

variable {c : ℂ} {R : ℝ} {f : ℂ → ℂ} {u : ℂ}

/-- Analytic on a neighbourhood of the closed ball ⇒ meromorphic on it. -/
theorem analyticOnNhd_closedBall_meromorphicOn
    (hA : AnalyticOnNhd ℂ f (closedBall c R)) :
    MeromorphicOn f (closedBall c R) :=
  fun u hu => (hA u hu).meromorphicAt

/-- The divisor of a meromorphic function on a compact disk has finite
    support. -/
theorem divisor_closedBall_finiteSupport :
    (divisor f (closedBall c |R|)).support.Finite :=
  (divisor f (closedBall c |R|)).finiteSupport (isCompact_closedBall c |R|)

/-- Analytic on a neighbourhood of the closed ball ⇒ continuous on it. -/
theorem analyticOnNhd_closedBall_continuousOn
    (hA : AnalyticOnNhd ℂ f (closedBall c R)) :
    ContinuousOn f (closedBall c R) :=
  hA.continuousOn

/-- Analytic on a neighbourhood of the closed ball ⇒ complex-differentiable
    at every point of the open ball. -/
theorem analyticOnNhd_closedBall_differentiableAt_ball
    (hA : AnalyticOnNhd ℂ f (closedBall c R))
    (z : ℂ) (hz : z ∈ ball c R) : DifferentiableAt ℂ f z :=
  (hA z (ball_subset_closedBall hz)).differentiableAt

/-- Analytic on a neighbourhood of the closed ball ⇒ differentiable at every
    point of the closed ball (in particular on the circle). -/
theorem analyticOnNhd_closedBall_differentiableAt_closedBall
    (hA : AnalyticOnNhd ℂ f (closedBall c R))
    (z : ℂ) (hz : z ∈ closedBall c R) : DifferentiableAt ℂ f z :=
  (hA z hz).differentiableAt

/-- If `f` is analytic at `u`, the meromorphic divisor of `f` on `U` at `u`
    is a nonnegative integer (zero when `f` vanishes to infinite order at
    `u`, i.e. is locally zero). -/
theorem divisor_nonneg_of_analyticAt {U : Set ℂ}
    (hA : AnalyticAt ℂ f u) (hmer : MeromorphicOn f U) (hu : u ∈ U) :
    0 ≤ (divisor f U) u := by
  have hcond : MeromorphicOn f U ∧ u ∈ U := ⟨hmer, hu⟩
  have hd : (divisor f U) u = (meromorphicOrderAt f u).untop₀ := by
    dsimp only [divisor]
    exact if_pos hcond
  rw [hd]
  have hnn : 0 ≤ meromorphicOrderAt f u := hA.meromorphicOrderAt_nonneg
  by_cases htop : meromorphicOrderAt f u = ⊤
  · -- `f` vanishes to infinite order at `u`: the divisor entry is `0`.
    rw [htop]
    simp only [WithTop.untop₀_top]
    exact le_rfl
  · -- finite order: the untop₀ entry is the order itself, hence `≥ 0`.
    have hfin : (meromorphicOrderAt f u).untop₀ = meromorphicOrderAt f u :=
      WithTop.coe_untop₀_of_ne_top htop
    simpa [hfin] using hnn

