import Mathlib

noncomputable def ee : ℝ := 27182818283 / 10 ^ 10

example : (ee : ℝ) ^ 19 = (ee : ℝ) ^ (19 : ℝ) := by
  rw [Real.rpow_natCast]

example : (ee : ℝ) ^ 19 = (ee : ℝ) ^ (19 : ℝ) := by
  norm_num
