import Mathlib
open Real
example (t : ℝ) (ht : 1000 ≤ t) : 1000 ^ 4 ≤ t ^ 4 := by
  have h4 := pow_le_pow_left' ht 4
  exact h4
