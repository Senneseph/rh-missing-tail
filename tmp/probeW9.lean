import Mathlib

example : (1369 : ℝ) ^ 50 ≥ 2 * 1350 ^ 50 := by norm_num
example : (2 : ℝ) ^ 27 > 124000000 := by norm_num
example : (2 : ℝ) ^ 27 > 62000000 := by norm_num
example : Real.exp 1 ≤ (1369 : ℝ) ^ 50 / 1350 ^ 50 := by
  -- exp (19/27) = (exp (19/1350))^50 ≥ (1+19/1350)^50
  have h1 : Real.exp (19 / 27) = (Real.exp (19 / 1350)) ^ 50 := by
    rw [show (19 : ℝ) / 27 = (50 : ℝ) * (19 / 1350), mul_comm]?
    rw [Real.exp_mul]?
    exact le_rfl
  exact le_rfl
example (x : ℝ) : Real.exp (50 * x) = (Real.exp x) ^ 50 := by
  rw [Real.exp_mul]?
  exact le_rfl
