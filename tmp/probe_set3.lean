import Mathlib
theorem probe_setdir (t : ℝ) : True := by
  set L := Real.log t with hLdef
  have h1 : Real.log t = L := hLdef
  trivial
