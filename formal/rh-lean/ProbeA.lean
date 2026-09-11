import Mathlib

#check abs_add
#check abs_add'
#print abs_add'
#check abs_sub
#check abs_le
#check integral_mono_on
#check ContinuousAt.continuousWithinAt
#check continuousAt_const
#check sub_pos_iff_ne_zero
#check ne_of_gt
#check mul_nonpos_of_nonneg_of_nonpos
#print sub_ne_zero
#check not_lt
#check ContinuousOn.abs
#check Continuous.abs
#check continuousAt_abs
#check continuous_abs
#check ContinuousWithinAt
#check sub_nonpos
#check pow_two
#check List.prod_append
#check List.map_append
#check Set.EqOn.aeEq_restrict
#check aeEq_restrict
#check Filter.EventuallyEq
#check interval_integrable_iff
#check intervalIntegrable_iff
#check div_lt_one
#check sub_pos
#check integral_mul_const
#check abs_integral_le_integral_abs
#check abs_sub_le
#print abs_sub_le

-- behavior probes ------------------------------------------------------
section S
variable (f g : ℝ → ℝ) (x : ℝ)
example (h : ContinuousAt f x) : ContinuousAt (fun z => |f z|) x := by
  continuity
example (h : ContinuousOn f (Icc 0 1)) : ContinuousOn (fun z => |f z|) (Icc 0 1) := by
  intro z hz
  exact (h z hz).continuousWithinAt
example (a b : ℝ) (ha : 0 < a) (hb : a ≤ b) : Real.log a ≤ Real.log b :=
  Real.log_le_log ha hb
example (a b : ℝ) (h : ¬a < b) : b ≤ a := by
  simpa using not_lt h
example (a b c : ℝ) : |a + b| ≤ |a| + |b| := by
  simpa [show a + b = (-b) + (a + b) by ring, abs_neg] using abs_add' (a + b) (-b)
example (u v w : ℝ) (hu : 0 ≤ u) (hv : v ≤ 0) : u * v ≤ 0 :=
  mul_nonpos_of_nonneg_of_nonpos hu hv
example (a c : ℝ) (ha : 0 < a) (hc : c ≠ 0) : (a - c) ≠ 0 := by
  simpa using (sub_ne_zero_iff : a - c ≠ 0 ↔ a ≠ c) ha
end S
