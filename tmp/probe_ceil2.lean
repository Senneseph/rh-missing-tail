import Mathlib

noncomputable def n4 (t : ℝ) : ℕ := ⌈(31000000 : ℝ) * t ^ 4⌉₊

example (t : ℝ) : (31000000 : ℝ) * t ^ 4 ≤ (n4 t : ℝ) := by
  dsimp [n4]
  exact le_ceil ((31000000 : ℝ) * t ^ 4)
