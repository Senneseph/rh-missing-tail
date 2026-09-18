import Mathlib
open Real
variable {c : ℝ} (hc : 0 < c)

-- B1: c^(-1/2) = 1/sqrt c
example : c ^ (-1/2 : ℝ) = 1 /.sqrt c := by
  have hexp : (-1/2 : ℝ) = -(1/2 : ℝ) := by ring
  rw [hexp, rpow_neg hc.le (1/2)]
  rw [show c ^ (1/2 : ℝ) = .sqrt c from (sqrt_eq_rpow c).symm]
  exact (one_div (.sqrt c)).symm

-- B2: (c^(-1/2))^2 = c^(-1)
example : (c ^ (-1/2 : ℝ)) ^ 2 = c ^ (-1 : ℝ) := by
  rw [show (c ^ (-1/2 : ℝ)) ^ 2 = (c ^ (-1/2 : ℝ)) ^ (2 : ℝ) from by simp]
  rw [show (c ^ (-1/2 : ℝ)) ^ (2 : ℝ) = c ^ ((-1/2 : ℝ) * 2) from (rpow_mul hc.le (-1/2) 2).symm? ]
