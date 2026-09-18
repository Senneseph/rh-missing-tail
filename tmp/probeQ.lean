import Mathlib
open Real
example (t : ℝ) (ht : 1000 ≤ t) : (62000000 : ℝ) * 1000 ^ 4 ≤ 62000000 * t ^ 4 := by
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left' ht 4) (by norm_num)
