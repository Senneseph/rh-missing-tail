import Mathlib

#check norm_mul
#check norm_mul'
example (a b : ℂ) : ‖a * b‖ = ‖a‖ * ‖b‖ := norm_mul' a b?
example : ‖(3 : ℂ)‖ = 3 := by norm_num
example (z : ℂ) : ‖z‖ ^ 2 = Complex.normSq z := by
  have := sq_nonneg ‖z‖?
  exact le_rfl
example (z : ℂ) : ‖z‖ = √(Complex.normSq z) := by
  simp [Complex]?
  exact le_rfl
