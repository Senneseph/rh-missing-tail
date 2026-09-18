import Mathlib
theorem probe_fwd (t : ℝ) : True := by
  set L := Real.log t with hLdef
  have h1 : L = (0 : ℝ) := by
    rw [hLdef]
  trivial

theorem probe_bwd (t : ℝ) : True := by
  set L := Real.log t with hLdef
  have h1 : Real.log t = (0 : ℝ) := by
    rw [← hLdef]
  trivial
