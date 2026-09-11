/-
  day-014: Q1 NAMED-ARG comp `ContinuousAt.comp (g := log) (f := …) (x := z)` GREEN (the hmid fix); Q2a/Q2b `continuity` tactic DEAD for log∘mul in 4.33.1; Q3 single-expression comp FAILED; P4fix 3-arg `sub_div` GREEN; hnz ≠0 pattern GREEN.
-/ 
import Mathlib
import Mathlib.Tactic

set_option maxErrors 50

noncomputable section
open Real Set MeasureTheory intervalIntegral

variable {z c : ℝ}

/-- Q1: comp with ALL named args (f, g, x pinned) -/
example (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => log (w * c)) z := by
  have hnz : z * c ≠ 0 := by
    intro h0
    nlinarith [mul_pos hz hc, h0]
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log hnz
  exact ContinuousAt.comp (g := log) (f := fun w : ℝ => w * c) (x := z) h2 h1

/-- Q3: NHat full — single-expression comp in meta context -/
example (hz : 0 < z) (hc : 0 < c) :
    ContinuousAt (fun w : ℝ => (w * c) * (log (w * c) - 1) + 7 / 8) z := by
  have hnz : z * c ≠ 0 := by
    intro h0
    nlinarith [mul_pos hz hc, h0]
  have h1 : ContinuousAt (fun w : ℝ => w * c) z :=
    (continuousAt_id' (z : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (z * c) :=
    Real.continuousAt_log hnz
  exact ((h2.comp h1).sub continuousAt_const).mul h1 |>.add continuousAt_const

/-- P4fix: sub_div 3 args in calc -/
example (a : ℝ) (hPn : 1 - a ≠ 0) :
    (1 - (1 - a)) / (1 - a) = 1 / (1 - a) - 1 := by
  calc (1 - (1 - a)) / (1 - a)
      = (1 : ℝ) / (1 - a) - (1 - a) / (1 - a) :=
        by rw [sub_div (1 : ℝ) (1 - a) (1 - a)]
    _ = 1 / (1 - a) - 1 := by rw [div_self hPn]

end
