section A
variable (x : Nat) (hx : 0 ≤ x)
include hx
theorem t1 : 0 ≤ x := by
  assumption
theorem t2 : 0 ≤ x := by
  apply Nat.le_trans hx
  nlinarith
end
