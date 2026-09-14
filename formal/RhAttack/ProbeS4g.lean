import Mathlib

open Complex

example (a b : ℝ) : ‖(a : ℂ) + (b : ℂ) * I‖ = Real.sqrt (normSq ((a : ℂ) + (b : ℂ) * I)) := by
  rfl
