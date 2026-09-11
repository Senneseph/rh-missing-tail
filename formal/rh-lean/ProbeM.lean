import Mathlib
import Mathlib.Tactic

set_option maxErrors 10

noncomputable section
open Set MeasureTheory intervalIntegral

variable {f : ℝ → ℝ} {a b : ℝ}

def NList (L : List ℝ) (x : ℝ) : ℝ :=
    (L.map (fun (g : ℝ) => if g ≤ x then (1 : ℝ) else 0)).sum

def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

variable (hf'cont : ContinuousOn (deriv f) (Icc a b)) (h'ab : a < b)

/-- V1: the original proof (reproduces the failure?) -/
example (g : ℝ) (tail : List ℝ) (x : ℝ) (hx : x ∈ Ioo a b)
    (hgpos : g ≤ x) :
    NList tail x * deriv f x + rayIntegrand f g x =
      NList (g :: tail) x * deriv f x := by
  dsimp only [NList, rayIntegrand]
  rw [dif_pos hgpos]
  ring

/-- V2: simp [hg] -/
example (g : ℝ) (tail : List ℝ) (x : ℝ) (hx : x ∈ Ioo a b)
    (hgpos : g ≤ x) :
    NList tail x * deriv f x + rayIntegrand f g x =
      NList (g :: tail) x * deriv f x := by
  dsimp only [NList, rayIntegrand]
  simp [hgpos]
  ring

/-- V3: map_cons + sum_cons + dif_pos + ring -/
example (g : ℝ) (tail : List ℝ) (x : ℝ) (hx : x ∈ Ioo a b)
    (hgpos : g ≤ x) :
    NList tail x * deriv f x + rayIntegrand f g x =
      NList (g :: tail) x * deriv f x := by
  dsimp only [NList, rayIntegrand]
  rw [List.map_cons, List.sum_cons, dif_pos hgpos]
  ring

end
