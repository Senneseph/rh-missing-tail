import Mathlib
open Real
def c4sq : ℝ := 62000000 * 62000000
lemma hc4 : 0 < c4sq := by norm_num [c4sq]
example (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ c4sq * t ^ 6 := by
  nlinarith [hc4, pow_nonneg (by linarith) 6]
