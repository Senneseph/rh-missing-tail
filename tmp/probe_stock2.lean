#set_option warn.deprecated false
section V1
variable (x : Nat) (hx : 0 ≤ x)
theorem v1_test : 0 ≤ x := by
  assumption
end
