import Mathlib
example (a b : ℝ) (h : 0 < b) : 1 / (2 * b) ≤ 1 / b := by
  calc 1 / (2 * b) ≤ 1 / b := by
    rw [div_le_iff₀ h]
    norm_num
example (a b : ℝ) (h : 0 < b) : 1 / (2 * b) ≤ 1 / b := by
  calc 1 / (2 * b) ≤ 1 / b := by rw [div_le_iff₀ h]; norm_num
