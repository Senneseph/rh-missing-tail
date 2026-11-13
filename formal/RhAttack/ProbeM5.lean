import Mathlib

theorem probeA : (2 : ℝ) * Real.pi < 2e9 := by
  linarith [Real.pi_le_four]

theorem probeB : 1 < 2e9 / (2 * Real.pi) := by
  have hpos : 0 < 2 * Real.pi := by linarith [Real.pi_pos]
  rw [one_lt_div hpos]
  linarith [Real.pi_le_four]
