import Mathlib

example (t : ℝ) (ht : 1000 ≤ t) : (31000000 : ℝ) * t ^ 4 ≤ (⌈(31000000 : ℝ) * t ^ 4⌉₊ : ℝ) := by
  exact Nat.le_ceil _
example (t : ℝ) (ht : 0 ≤ t) :
    ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (t * t + 1 / 4) := by
  rw [Complex.norm_def]
  simp [Complex.normSq_add_mul_I]
  ring_nf
example (x : ℝ) (hx : 0 < x) (y z : ℝ) : x ^ (y * z) = (x ^ y) ^ z := Real.rpow_mul (le_of_lt hx) y z
example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (h : a ^ 2 < b ^ 2) : a < b := by
  exact lt_of_sq_lt_sq ha h?
example (a b : ℝ) (ha : 0 ≤ a) (hb : 0 ≤ b) (h : a ^ 2 < b ^ 2) : a < b := by
  exact sq_lt_sq.mp h?
example : Real.exp (1 / 2) < 2 := by
  have h34 : Real.exp 1 < 4 := by
    linarith [Real.exp_one_lt_three]
  have hsq : Real.exp (1 / 2) ^ 2 < 4 := by
    calc Real.exp (1 / 2) ^ 2 = Real.exp (1 / 2 + 1 / 2) := by
      rw [Real.rpow_two, show (Real.exp (1 / 2 : ℝ)) ^ 2 = Real.exp (1 / 2) * Real.exp (1 / 2) by ring]
      rw [Real.exp_add 1/2 (1/2), add_halves]
    _ = Real.exp 1 := by ring
    _ < 4 := h34
  have hp : 0 ≤ Real.exp (1 / 2) := Real.exp_nonneg (1 / 2)
  exact lt_of_sq_lt_sq hp (by norm_num) hsq?
