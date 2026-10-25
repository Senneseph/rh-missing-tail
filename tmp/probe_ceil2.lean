import Mathlib
example (x : ℝ) (hx : 1 < x) : (⌈x⌉₊ : ℝ) < x + 1 := by
  gcongr
  -- fallback if gcongr fails
  fail "probe"
example (x : ℝ) : (⌈x⌉₊ : ℝ) ≤ x + 1 := by
  fail "probe2"
