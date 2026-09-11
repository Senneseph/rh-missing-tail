/-
  day-014: Q1/Q2 `field_simp` + `ring_nf` closers for the fTp_bound region (inverse-atom behavior). Ported: B3.lean §6.
-/ 
import Mathlib
import Mathlib.Tactic

set_option maxErrors 20

noncomputable section

/-- Q1: field_simp; ring_nf -/
example (wt ux : ℝ) (hnz : 1 - wt / ux ≠ 0) :
    wt / ux / (1 - wt / ux) = 1 / (1 - wt / ux) - 1 := by
  field_simp [hnz]
  ring_nf

/-- Q2: field_simp; ring_nf; ring -/
example (wt ux : ℝ) (hnz : 1 - wt / ux ≠ 0) :
    wt / ux / (1 - wt / ux) = 1 / (1 - wt / ux) - 1 := by
  field_simp [hnz]
  ring_nf
  ring

/-- Q3: field_simp; linarith-free exact via field_simp alone -/
example (wt ux : ℝ) (hnz : 1 - wt / ux ≠ 0) :
    wt / ux / (1 - wt / ux) = 1 / (1 - wt / ux) - 1 := by
  field_simp [hnz]

end
