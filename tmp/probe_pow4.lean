import Mathlib

example (t : ℝ) : t ^ 3 = t ^ (3 : ℝ) := by
  rfl

example (t : ℝ) : t ^ 3 = t ^ (3 : ℝ) := by
  simp [Real.rpow_natCast]
