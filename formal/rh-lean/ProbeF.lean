import Mathlib
open Set
open intervalIntegral

variable {c x : ℝ}

#check ContinuousAt.withinAt
#check IntegrableOn.union
#check if_neg
#check if_pos
#check not_lt
#check Real.continuousAt_log
#check ContinuousAt.congr
#check Eq.eventuallyEq
#check mul_nonpos_of_nonneg_of_nonpos
#check log_le_log
#check Real.exp_lt_exp
#check HasDerivAt.mul
#check integral_add
#check sub_eq_of_eq_add

-- minimal withinAt usage
example (h : ContinuousAt (fun z : ℝ => z + 1) 0) (hx : 0 ∈ Set.Icc 0 1) :
    ContinuousOn (fun z : ℝ => z + 1) (Set.Icc 0 1) := by
  intro x hx
  exact h.withinAt hx

-- minimal integrable-on union usage
example (hL : IntegrableOn (fun x : ℝ => x) (Set.Ioc 0 1) volume)
    (hR : IntegrableOn (fun x : ℝ => x) (Set.Ioc 1 2) volume) :
    IntegrableOn (fun x : ℝ => x) (Set.Ioc 0 1 ∪ Set.Ioc 1 2) volume :=
  hL.union hR

-- le_of_not_lt vs not_lt
example (hc : ¬ c < x) (hc'' : c ≤ x) : c ≤ x := by
  have h1 := not_lt.mp hc
  have h2 := le_of_not_lt hc
  exact hc''
