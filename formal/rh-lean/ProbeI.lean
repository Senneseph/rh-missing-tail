import Mathlib
open Set Real MeasureTheory
open intervalIntegral
#check eq_sub_of_add_eq
#check div_le_div_iff
#check integral_eq_sub_of_hasDerivAt
#check integral_add_adjacent_intervals
#check uIcc_of_le
#check uIoc_of_le
#check Set.EqOn.aeEq_restrict
var {a b c G B : ℝ}
example (h : a + b = c) : c - b = a := eq_sub_of_add_eq h
example (hx0 : 0 < a) (hb : 0 < b) : a / a ≤ b / a ↔ a * a ≤ b * a := by
  apply div_le_div_iff hx0 hb
  <;> rfl
