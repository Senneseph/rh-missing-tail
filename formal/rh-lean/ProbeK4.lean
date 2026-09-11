import Mathlib
import Mathlib.Tactic

set_option maxErrors 50

noncomputable section
open Real Set MeasureTheory intervalIntegral

def twoPiInv : ℝ := ((2 : ℝ) * π)⁻¹

/-- P1: ContinuousWithinAt.abs dot-notation, B3-like context -/
example (t G B x : ℝ) (hf'cont : ContinuousOn (fun x0 : ℝ => deriv (fun x1 : ℝ => x1 * x1) x0) (Icc G B))
    (hx : x ∈ Icc G B) :
    ContinuousWithinAt (fun x0 : ℝ => |deriv (fun x1 : ℝ => x1 * x1) x0|) (Icc G B) x := by
  exact hf'cont (x := x) hx |>.abs

/-- P2: NHat-style single-expression composition (no named have with concrete type) -/
example (x : ℝ) (hpos : 0 < x * twoPiInv) :
    ContinuousAt (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1) + 7 / 8) x := by
  have hnz : x * twoPiInv ≠ 0 := by
    intro h0
    nlinarith [hpos, h0]
  have h1 : ContinuousAt (fun z : ℝ => z * twoPiInv) x :=
    (continuousAt_id' (x : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (x * twoPiInv) :=
    Real.continuousAt_log hnz
  exact (h1.mul ((h2.comp h1).sub continuousAt_const)).add continuousAt_const

/-- P3: htarget smul form -/
example (y : ℝ) (hy : 0 < y) (hy1 : y < 1) :
    ∫ z in (1 - y)..1, (1 / (1 - y)) = y / (1 - y) := by
  have hz : 0 < 1 - y := by linarith
  rw [intervalIntegral.integral_const]
  have h1 : (1 : ℝ) - (1 - y) = y := by ring
  rw [h1, smul_eq_mul, mul_one_div]

/-- P4: sub_div with ALL FOUR explicit args inside calc -/
example (a d : ℝ) (hPn : 1 - a ≠ 0) :
    (1 - (1 - a)) / (1 - a) = 1 / (1 - a) - 1 := by
  calc (1 - (1 - a)) / (1 - a)
      = (1 : ℝ) / (1 - a) - (1 - a) / (1 - a) :=
        by rw [sub_div (1 : ℝ) (1 - a) (1 - a) hPn]
    _ = 1 / (1 - a) - 1 := by rw [div_self hPn]

end
