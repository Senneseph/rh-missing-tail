/-
  day-013: 2-point abs fact via `abs_add_le A (-B)` + `abs_neg` (this version has no 2-arg `abs_sub` lemma) + the plain triangle pin. Ported: B3.lean bound region.
-/ 
import Mathlib
import Mathlib.Tactic

set_option maxErrors 300

noncomputable section
open Real Set MeasureTheory intervalIntegral

variable {f : ℝ → ℝ} {a b : ℝ} (h'ab : a < b)

/-- 2-point abs via abs_add_le + abs_neg (no `abs_sub` 2-arg) -/
example (A B : ℝ) : |A - B| ≤ |A| + |B| := by
  rw [sub_eq_add_neg]
  calc |A + -B| ≤ |A| + |-B| := abs_add_le A (-B)
    _ = |A| + |B| := by rw [abs_neg]

/-- triangle: |X + Y| ≤ |X| + |Y| directly -/
example (X Y : ℝ) : |X + Y| ≤ |X| + |Y| := abs_add_le X Y

/-- rayEndFormEq via split_ifs -/
example (a b p : ℝ) (f : ℝ → ℝ) (h'ab : a < b) :
    f b * (if p ≤ b then (1 : ℝ) else 0) - f a * (if p ≤ a then (1 : ℝ) else 0)
      - (if a < p ∧ p ≤ b then f p else 0) =
      if p ≤ a then f b - f a else if p < b then f b - f p else 0 := by
  split_ifs
  <;> (try ring)
  <;> (try { exfalso; linarith })

/-- continuity composition via the `continuity` tactic -/
example (z c : ℝ) (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => log (w * c)) z := by
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log (ne_of_gt (mul_pos hz hc))
  continuity

end
