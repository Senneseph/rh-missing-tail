import Mathlib
open Set MeasureTheory
open intervalIntegral
open Real

#check IntegrableOn.union
#check abs_sub
#check abs_sub_le
#check integral_mono_on
#check intervalIntegral.integral_mul_const
#check intervalIntegral.integral_const_mul
#check intervalIntegral.integral_sub
#check sub_ne_zero
#check ne_of_gt
#check Real.log_pos
#check div_le_iff₀
#check IntervalIntegrable.add
#check IntervalIntegrable.sub
#check abs_integral_le_integral_abs
#check continuousWithinAt
#check ContinuousAt.continuousWithinAt
#check if_neg
#check abs_neg

variable {a b c x : ℝ}
variable (f : ℝ → ℝ)

-- integration over concatenation set
example (hL : IntegrableOn (fun x : ℝ => x) (uIoc a c) volume)
    (hR : IntegrableOn (fun x : ℝ => x) (uIoc c b) volume) :
    IntegrableOn (fun x : ℝ => x) (uIoc a c ∪ uIoc c b) volume :=
  hL.union hR

-- integral_mono_on signature usage
example (hI1 : IntervalIntegrable (fun x : ℝ => x) volume a b)
    (hI2 : IntervalIntegrable (fun x : ℝ => x + 1) volume a b)
    (h : ∀ x ∈ Icc a b, x ≤ x + 1) (hG : a ≤ b) :
    ∫ x in a..b, x ≤ ∫ x in a..b, x + 1 := by
  exact intervalIntegral.integral_mono_on hG hI1 hI2 h

-- abs_sub direct
example : |x - c| ≤ |x| + |c| := abs_sub x c

-- sq vs x*x
example : 0 ≤ c * c := by nlinarith
