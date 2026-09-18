import Mathlib
open Real
example (t : ℝ) (ht : 1000 ≤ t) : 1000 ^ 6 ≤ t ^ 6 :=
  pow_le_pow_left₀ (by norm_num) ht 6
example (t : ℝ) (ht : 1000 ≤ t) : 62000000 * 1000 ^ 4 ≤ 62000000 * t ^ 4 :=
  mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (by norm_num) ht 4) (by norm_num)
