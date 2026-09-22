import Mathlib

example : ContinuousOn (fun v : ℝ => 2 * v / (v^2 + 1/4)) (Set.Icc (-2) 2) := by
  continuity
