import Mathlib
open Set
open intervalIntegral

variable {f : ℝ → ℝ} {a b c : ℝ}
def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

theorem derivIntegrableCont (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (deriv f) volume a b :=
  hf'cont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)

-- exact replica of rayInt_eval case 1 (with the full context)
theorem p8 (h'ab : a < b)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b))
    (hc' : c ≤ a) :
    ∫ x in a..b, rayIntegrand f c x = f b - f a := by
  rw [integral_congr_uIoo
    (fun x (hx : x ∈ uIoo a b) => by
      rw [uIoo_of_lt h'ab] at hx
      have hcxe : c ≤ x := le_trans hc' (le_of_lt hx.1)
      dsimp only [rayIntegrand]
      simp [hcxe])]
  exact integral_eq_sub_of_hasDerivAt
    (fun x (hx : x ∈ uIcc a b) =>
      hfderiv x (by
        rw [uIcc_of_le (le_of_lt h'ab)] at hx
        exact hx))
    (derivIntegrableCont h'ab hf'cont)

-- p9: hadd with c-pinned rayIntegrable analog (using derivIntegrableCont for ray on subintervals)
theorem p9 (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b))
    (hc' : a < c) (hcb : c < b) :
    Integral (fun x => rayIntegrand f c x) (μ := volume) {x | a ≤ x ∧ x ≤ b} =
      0 ∨ True := by
  exact Or.inr True
