import Mathlib
theorem probeA : (2 : ℝ) * Real.pi < 2e9 := by norm_num [Real.pi_lt_3551]
theorem probeB : 1 < 2e9 / (2 * Real.pi) := by
  have hpi : (2 : ℝ) * Real.pi < 2e9 := by norm_num [Real.pi_lt_3551]
  have hpos : 0 < 2 * Real.pi := by linarith [Real.pi_pos]
  rw [show (1 : ℝ) < 2e9 / (2 * Real.pi) ↔ (1 * 2 * Real.pi < 2e9 * 1) from by
    ring_nf
    exact (mul_lt_mul_iff_of_pos_of_pos (show (0 : ℝ) < 2 * Real.pi from hpos)
        (show (0 : ℝ) < 2e9 from by norm_num)).symm??]
