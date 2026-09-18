import Mathlib
open Real
def c4sq : ℝ := 62000000 * 62000000
noncomputable def G4 (t : ℝ) : ℝ := 62000000 * t ^ 4
example (t : ℝ) (ht : 1000 ≤ t) : 0 < 2 * (G4 t * G4 t + 1 / 4) := by positivity
example (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ c4sq * t ^ 6 := by positivity
example (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ c4sq * t ^ 6 := by nlinarith [show 0 < c4sq from by norm_num [c4sq], show 0 ≤ t ^ 6 by positivity]
