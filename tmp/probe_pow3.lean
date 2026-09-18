import Mathlib

example (t : ℝ) : t ^ 3 = t ^ (3 : ℝ) := by
  rw [Real.rpow_natCast]

example (t : ℝ) (ht : 0 < t) : (t : ℝ) ^ (3 : ℝ) * t ^ (-10 : ℝ) = t ^ (-7 : ℝ) := by
  rw [Real.rpow_add ht 3 (-10 : ℝ)]
  ring_nf
