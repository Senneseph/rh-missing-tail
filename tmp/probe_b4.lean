import Mathlib

variable {c : ℝ} (hc : 0 < c)

-- B1: c^(-1/2) = 1/√c
example : c ^ (-1/2 : ℝ) = 1 / Real.sqrt c := by
  have hexp : (-1/2 : ℝ) = -(1/2 : ℝ) := by ring
  rw [hexp, Real.rpow_neg hc.le (1/2 : ℝ)]
  rw [show c ^ (1/2 : ℝ) = Real.sqrt c from (Real.sqrt_eq_rpow c).symm]
  exact (one_div (Real.sqrt c)).symm

-- B3: c^(-1) = 1/c
example : c ^ (-1 : ℝ) = 1 / c := by
  rw [Real.rpow_neg hc.le 1]
  exact (one_div c).symm

-- B2: c^(-3/2) = c^(-1/2) * c^(-1)
example : c ^ (-3/2 : ℝ) = c ^ (-1/2 : ℝ) * c ^ (-1 : ℝ) := by
  have hexp : (-3/2 : ℝ) = (-1/2 : ℝ) + (-1 : ℝ) := by ring
  rw [hexp, Real.rpow_add hc (-1/2 : ℝ) (-1 : ℝ)]
  ring_nf

-- B4: t^4 (nat) = t^(4:ℝ)
example (t : ℝ) : (t : ℝ) ^ 4 = t ^ (4 : ℝ) := by
  simp

-- B5: (c^(-1/2))^2 = c^(-1)
example : (c ^ (-1/2 : ℝ)) ^ 2 = c ^ (-1 : ℝ) := by
  rw [show (c ^ (-1/2 : ℝ)) ^ (2 : ℝ) = c ^ ((-1/2 : ℝ) * 2) from (Real.rpow_mul hc.le (-1/2 : ℝ) 2).symm]
  rw [show ((-1/2 : ℝ) * 2 : ℝ) = (-1 : ℝ) from by ring]
