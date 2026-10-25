import Mathlib
#check Int.ceil_le
#check Int.lt_ceil
#check Int.ceil_lt_iff
#check Nat.le_ceil
#check Nat.ceil_le
example (x : ℝ) (hx1 : 1 < x) : ((Int.ceil x).toNat : ℝ) = (Int.ceil x : ℝ) := by
  have hce : 0 ≤ Int.ceil x := Int.ceil_nonneg (by linarith [hx1])
  change ((Int.ceil x).toNat : ℝ) = (Int.ceil x : ℝ)
  fail "still"
example (x : ℝ) (hx1 : 1 < x) : (Int.ceil x : ℝ) ≤ x + 1 := by
  have h := Int.sub_one_lt_floor (-x)
  fail "ceilub"
