/-
  day-013: B3 §4.2 — rayInt_eval variants v1/v2 for the c < b branch. Ported: B3.lean.
-/ 
import Mathlib
open Set
open intervalIntegral

variable {f : ℝ → ℝ} {a b c : ℝ}
def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

theorem derivIntegrableCont (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (deriv f) volume a b :=
  hf'cont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)

-- v1: congr rw only; leave goal for the reader
theorem v1 (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b))
    (hc' : c ≤ a) :
    ∫ x in a..b, rayIntegrand f c x = f b - f a := by
  rw [integral_congr_uIoo
    (fun x (hx : x ∈ uIoo a b) => by
      rw [uIoo_of_lt h'ab] at hx
      have hcxe : c ≤ x := le_trans hc' (le_of_lt hx.1)
      dsimp only [rayIntegrand]
      simp [hcxe])]
  exact integral_eq_sub_of_hasDerivAt (fun x (hx : x ∈ uIcc a b) =>
    (deriv f) x ⊢ ⊥)  -- placeholder to see the goal state; will not typecheck

-- v2: what is the goal after congr? use `show`
theorem v2 (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b))
    (hc' : c ≤ a) :
    ∫ x in a..b, rayIntegrand f c x = f b - f a := by
  rw [integral_congr_uIoo
    (fun x (hx : x ∈ uIoo a b) => by
      rw [uIoo_of_lt h'ab] at hx
      have hcxe : c ≤ x := le_trans hc' (le_of_lt hx.1)
      dsimp only [rayIntegrand]
      simp [hcxe])]
  show ∫ x in a..b, deriv f x = f b - f a
  exact (by
    exact integral_eq_sub_of_hasDerivAt (by
      intro x hx
      exact HasDerivAt.deriv (by
        exact differentiableAt_deriv fun x : ℝ => f by
          intro _
          continuity)) (derivIntegrableCont h'ab hf'cont))
