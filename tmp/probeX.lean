import Mathlib

example (t : ℝ) (ht : 1000 ≤ t) : (31000000 : ℝ) * t ^ 4 ≤ (⌈(31000000 : ℝ) * t ^ 4⌉₊ : ℝ) := by
  exact le_ceil _?
example (t : ℝ) (ht : 1000 ≤ t) : (31000000 : ℝ) * t ^ 4 ≤ (⌈(31000000 : ℝ) * t ^ 4⌉₊ : ℝ) := by
  exact Nat.le_ceil _?
example (t : ℝ) (ht : 1000 ≤ t) : (31000000 : ℝ) * t ^ 4 ≤ (⌈(31000000 : ℝ) * t ^ 4⌉₊ : ℝ) := by
  simpa using Int.le_ceil ((31000000 : ℝ) * t ^ 4)?
example (t : ℝ) (ht : 0 ≤ t) :
    ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (t * t + 1 / 4) := by
  rw [Complex.norm_def]
  simp [Complex.normSq_add_mul_I]
  ring_nf?
  exact le_rfl
example (x : ℝ) (hx : 0 < x) (y z : ℝ) : x ^ (y * z) = (x ^ y) ^ z := by
  exact Real.rpow_mul hx y z
example : (1369 : ℝ) ^ 50 ≥ 2 * 1350 ^ 50 := by norm_num
example : (27182818283 : ℝ) ^ 19 ≥ 124000000 * (10 ^ 10 : ℝ) ^ 19 := by norm_num
