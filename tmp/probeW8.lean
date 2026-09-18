import Mathlib

example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  simp
  exact abs_of_nonneg ht
example (a b : ℂ) : ‖a + b‖ ≤ ‖a‖ + ‖b‖ := by
  exact norm_add_le a b?
  exact le_rfl
example (z : ℂ) : ‖z‖ = √(z.re * z.re + z.im * z.im) := by
  have hsq : ‖z‖ ^ 2 = z.re * z.re + z.im * z.im := by
    exact ?sq
  exact le_rfl
