import Mathlib.Algebra.GroupWithZero.Basic
open Real
example (x : ℝ) (h : x ≠ 0) : x⁻¹ = 1 / x := by
  field_simp
