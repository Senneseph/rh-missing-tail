/- ProbeN8 — day-016: power-continuity at a point in 4.33.1.
   RED PIN (all three fail — "Tactic `aesop` failed, failed to prove the
   goal after exhaustive search" — the `continuity` search does not
   close powers at a point in 4.33.1, even with `hx : 0 < x` in context):
     example (x : ℝ) (hx : 0 < x) : ContinuousAt (fun z : ℝ => z^3) x := by continuity
     example (c : ℝ) (x : ℝ) (hx : 0 < x) : ContinuousAt (fun z : ℝ => c / z^3) x := by continuity
     example (c : ℝ) (x : ℝ) (hx : 0 < x) : ContinuousAt (fun z : ℝ => c / (z * z * z)) x := by continuity
   WORKING (green): build it explicitly in the hFtpCont style —
   mul^3 for the product, ext/ring congr to z^3, ContinuousAt.div with
   ne_of_gt; for the ContinuousOn target wrap with .continuousWithinAt.
   (This is exactly RhAttack/B3Sbar.lean hInv3, the B-3 gate fix.) -/
import Mathlib

example (c : ℝ) (x : ℝ) (hx : 0 < x) :
    ContinuousWithinAt (fun z : ℝ => c / z^3) (Set.Ioo 0 100) x := by
  have hx3 : 0 < x^3 := by positivity
  have hC : ContinuousAt (fun _ : ℝ => (c : ℝ)) x := continuousAt_const
  have hId : ContinuousAt (fun z : ℝ => z) x := continuousAt_id' (x : ℝ)
  have hx3c : ContinuousAt (fun z : ℝ => z * z * z) x := hId.mul hId |>.mul hId
  have hPow : (fun z : ℝ => z * z * z) = (fun z : ℝ => z^3) := by ext z; ring
  have hX3 : ContinuousAt (fun z : ℝ => z^3) x := hx3c.congr hPow.eventuallyEq
  exact (hC.div hX3 (ne_of_gt hx3)).continuousWithinAt
