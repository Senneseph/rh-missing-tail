import Mathlib

example (a b : ℂ) : ‖a * b‖ ≤ ‖a‖ * ‖b‖ := by
  apply norm_mul
example (a b : ℂ) : ‖a * b‖ ≤ ‖a‖ * ‖b‖ := norm_mul _ _
set_option trace.Meta.synth_instances true in
example : Show (‖(1 : ℂ)‖) := by exact _
example (t : ℝ) (ht : 0 ≤ t) : ‖(t : ℂ)‖ = t := by
  have := by norm_num : ‖(2 : ℂ)‖ = 2
  -- unfold the norm def
  unfold Norm at *?
  sorry
example : ‖(1 : ℂ)‖ = 1 := by norm_num
example (z : ℂ) : ‖z‖ = Real.sqrt (Complex.normSq z) := by
  rw [?z]?
  exact le_rfl
example : ‖⟨(1 : ℝ), 2⟩ : ℂ‖ = Real.sqrt 5 := by norm_num
