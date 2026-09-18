import Mathlib
open Real
variable {c : ℝ} (hc : 0 < c)

-- B1: c^(-1/2) = 1/sqrt c
example : c ^ (-1/2 : ℝ) = 1 /.sqrt c := by
  have hexp : (-1/2 : ℝ) = -(1/2 : ℝ) := by ring
  rw [hexp, rpow_neg hc.le (1/2), show c^(1/2) = .sqrt c from by rw [sqrt_eq_rpow]]
  exact (one_div (.sqrt c)).symm

-- B2: (c^(-1/2))^2 = c^(-1)
example : (c ^ (-1/2 : ℝ)) ^ 2 = c ^ (-1 : ℝ) := by
  rw [show (-1/2 : ℝ) * 2 = (-1 : ℝ) from by ring, ← rpow_mul hc.le (-1/2) 2]
  ring_nf

-- B3: c^(-1) = 1/c
example : c ^ (-1 : ℝ) = 1/c := by
  rw [rpow_neg hc.le 1, show c ^ 1 = c from by simp, one_div]?
