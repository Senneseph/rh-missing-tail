import Mathlib
open Real
variable {c : ℝ} (hc : 0 < c)

-- B2b: bridge (c^(-1/2))² ≤ c^(-1) direction: prove c^(-1) = (c^(-1/2))^2 by ring on sqrt form
example : (c : ℝ) ^ (-1 : ℝ) = 1 / c := by
  rw [rpow_neg hc.le 1]
  simp [one_div]
