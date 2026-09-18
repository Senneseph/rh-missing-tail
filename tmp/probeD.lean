variable (x : Nat)
variable (hx : 0 < x)
lemma L : 0 ≤ x := by
  exact le_of_lt hx
