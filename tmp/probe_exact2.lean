import Mathlib
theorem probe_exact2 (t : ℝ) : True := by
  set L := Real.log t with hLdef
  have hLd : Real.log t = L := hLdef.symm
  trivial
