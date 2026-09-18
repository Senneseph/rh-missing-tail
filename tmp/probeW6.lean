import Mathlib

#check (inferInstance : Norm ℂ)
#check Complex.instNormedField
example : ‖(3 : ℂ)‖ = 3 := by norm_num
example (z : ℂ) : ‖z‖ = Complex.abs z := by
  exact Complex.abs_eq_norm?
  exact le_rfl
