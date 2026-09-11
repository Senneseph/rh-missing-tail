import Mathlib
#check continuousAt_const
example (x : ℝ) (h : ContinuousAt (fun z : ℝ => z + 1) x) (hy : x ∈ Set.Icc (x : ℝ) 1) :
    ContinuousOn (fun z : ℝ => z + 1) (Set.Icc (x : ℝ) 1) := by
  intro y hy
  exact h.continuousWithinAt
