section V1
variable (x : Nat) (hx : 0 ≤ x)
theorem v1_test : 0 ≤ x := by
  assumption
end

section V2
variable (y : Nat) hy : 0 ≤ y
theorem v2_test : 0 ≤ y := by
  assumption
end
