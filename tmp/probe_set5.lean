import Mathlib
theorem probe_a (t : ℝ) : True := by
  set L := Real.log t with hLdef
  -- use rw to reveal: if hLdef : L = log t, rw [hLdef] on goal "L = 0" gives "log t = 0"
  have : L = (0 : ℝ) := by
    rw [hLdef]
  trivial
