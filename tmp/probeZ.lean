import Mathlib
variable (t : ℝ)
variable (ht : (1000 : ℝ) ≤ t)
lemma x1 : 0 < t := by linarith [ht]
lemma x2 : 0 < t := by nlinarith
lemma x3 : 0 < t := exact lt_of_lt_of_le (by norm_num) ht
lemma x4 : 0 < t := by
  have h : 1000 ≤ t := ht
  linarith [h]
