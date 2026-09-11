/-
  day-013: `not_le.mp`/`not_lt.mp` direction pins; rayEndFormEq Strategy A (split_ifs + ring + infeasible-closures). Ported: B3.lean rayEndFormEq.
-/ 
import Mathlib
import Mathlib.Tactic

set_option maxErrors 300

noncomputable section
open Real Set MeasureTheory intervalIntegral

variable {f : ℝ → ℝ} {a b : ℝ} (h'ab : a < b)

/-- confirm not_lt / not_le exist -/
example (x y : ℝ) (hxy : ¬x ≤ y) : y < x := not_le.mp hxy
example (x y : ℝ) (hxy : ¬x < y) : y ≤ x := not_lt.mp hxy

/-- rayEndFormEq — Strategy A: split_ifs + ring + (exfalso; tauto) -/
example (a b p : ℝ) (f : ℝ → ℝ) (h'ab : a < b) :
    f b * (if p ≤ b then (1 : ℝ) else 0) - f a * (if p ≤ a then (1 : ℝ) else 0)
      - (if a < p ∧ p ≤ b then f p else 0) =
      if p ≤ a then f b - f a else if p < b then f b - f p else 0 := by
  split_ifs with h1, h2, h3, h4, h5
  <;> (try ring)
  <;> (try { exfalso; tauto })

/-- continuity composition via refine -/
example (z c : ℝ) (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => log (w * c)) z := by
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log (ne_of_gt (mul_pos hz hc))
  refine ContinuousAt.comp ?_ h1
  exact h2

end
