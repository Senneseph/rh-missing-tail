import Mathlib
theorem probe_exact (t : ℝ) : True := by
  set L := Real.log t with hLdef
  have hLd : Real.log t = L := by rw [← hLdef]
  trivial
