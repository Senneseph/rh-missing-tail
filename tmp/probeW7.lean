import Mathlib

example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  simp [Complex]? at ht
  exact le_rfl
example (t : ℝ) : ‖(t : ℂ)‖ = |t| := by
  exact ?x
example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  have h1 : ‖(t : ℂ)‖ = |t| := by
    exact ?y
  rw [h1]
  exact abs_of_nonneg ht
example (a b : ℂ) : ‖a + b‖ ≤ ‖a‖ + ‖b‖ := norm_add a b
example (z : ℂ) : ‖z‖ ^ 2 = z.re * z.re + z.im * z.im := by
  have := sq_nonneg (‖z‖ : ℝ)
  exact le_rfl
