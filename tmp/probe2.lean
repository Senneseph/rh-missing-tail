section A
variable (n : Nat) (hn : n = n)
theorem t1 : n = n := by
  exact hn
end

section B
variable {a b : Nat} (hab : a ≤ b)
theorem t2 : a ≤ b * 2 := by
  apply Nat.le_trans hab
  nlinarith
end
