/- ProbeN5 — day-016 pins for `-q ≤ 0`-shaped goals (Kbar_le hRn region):
   (1) `(...).neg_le` field: INVALID in 4.33.1 (no such projection).
   (2) `positivity` REFUSES goals of form `-e ≤ 0` ("not a positivity goal").
   (3) WORKING RECIPE (ported, green): div_le_iff₀ + norm_num. -/
import Mathlib

noncomputable section

open Real

example (B : ℝ) (hposB : 0 < B) : (-(2.290 / 2) / (B * B)) ≤ 0 := by
  rw [div_le_iff₀ (by nlinarith [hposB])]
  norm_num
