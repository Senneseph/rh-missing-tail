import Mathlib
example (a b : ℝ) (h : 0 < b) : 1 / (2 * b) ≤ 2 / b := by
  calc 1 / (2 * b) = 1 / (2 * b) := by rfl
    _ ≤ 2 / b := by
      rw [div_le_iff₀ h]
      nlinarith
example (a b : ℝ) (h : 0 < b) : 1 / (2 * b) ≤ 2 / b := by
  have h2b : 0 < 2 * b := by nlinarith
  calc 1 / (2 * b) ≤ 1 / b := by
      rw [div_le_iff₀ h2b]
      nlinarith
    _ ≤ 2 / b := by rw [div_le_iff₀ h]; nlinarith
