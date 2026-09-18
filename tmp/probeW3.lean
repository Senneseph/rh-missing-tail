import Mathlib

example : ‖(3 : ℂ)‖ = (3 : ℝ) := by norm_num
example : ‖(Complex.I : ℂ)‖ = (1 : ℝ) := by norm_num
example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  simp [Complex.normSq]? 
  exact le_rfl
example (a b : ℂ) : ‖a * b‖ ≤ ‖a‖ * ‖b‖ := norm_mul a b
example : ‖(1 / 2 : ℂ) + (2 : ℂ) * Complex.I‖ = Real.sqrt (1 / 4 + 4) := by
  have := by
    have h : ‖(1 / 2 : ℂ) + (2 : ℂ) * Complex.I‖ = Real.sqrt (Complex.normSq ((1 / 2 : ℂ) + (2 : ℂ) * Complex.I)) := by
      rw [?norm_eq_sqrt_normSq]
    exact h
  exact le_rfl
