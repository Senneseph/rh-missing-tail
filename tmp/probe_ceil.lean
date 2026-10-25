import Mathlib
example (x : ℝ) (hx : 0 ≤ x) : (Nat.ceil x : ℝ) ≤ x + 1 := by
  have h : (Int.ceil x : ℤ) ≤ ⌊x + 1⌋ := by
    rw [Int.floor_le_iff]
    linarith
  have h2 : (Int.ceil x : ℤ) ≥ 0 := by
    rw [Int.cast_nonneg]
    have := Int.ceil_nonneg.mpr hx
    simpa [Nat.cast_nonneg] using this
  simpa [Nat.ceil, Int.toNat_of_nonneg h2, Int.cast_add, Int.cast_one] using
    Int.cast_mono.mpr h
example (x : ℝ) (hx : 1 < x) (hyz : (3 / 4 : ℝ) < 5 / 6) : x ^ (3 / 4 : ℝ) < x ^ (5 / 6 : ℝ) := by
  exact Real.rpow_lt_rpow_of_exponent_lt hx hyz
example : (641 : ℝ) ^ 50 < 1000 * (575 : ℝ) ^ 50 := by
  norm_num
example : (641 / 575 : ℝ) < (1000 : ℝ) ^ (1 / 50 : ℝ) := by
  calc (641 / 575 : ℝ)
      _ < (1000 : ℝ) ^ (1 / 1 : ℝ) := by
          have h : (641 / 575 : ℝ) < 1000 := by norm_num
          have h11 : (1000 : ℝ) ^ (1 : ℝ) = 1000 := by simp
          simpa [h11] using h
      _ ≤ (1000 : ℝ) ^ (1 / 50 : ℝ) := by
          have hpos : (1000 : ℝ) > 1 := by norm_num
          have hexp : (1 : ℝ) > 1 / 50 := by norm_num
          -- 1000^1 > 1000^(1/50) - wrong direction! rewrite:
          exact (Real.rpow_lt_rpow_of_exponent_lt hpos (by norm_num : (1 / 50 : ℝ) < 1)).trans_le
            (by norm_num : 1 ≤ 1)
