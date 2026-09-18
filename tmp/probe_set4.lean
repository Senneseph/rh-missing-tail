import Mathlib
theorem probe_setdir (t : ℝ) : True := by
  set L := Real.log t with hLdef
  exact (show L = Real.log t from hLdef).symm ▸ (show L = L by rfl)
  -- force a mismatch to reveal direction:
