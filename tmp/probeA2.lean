import Mathlib
open Polynomial

def P : ℝ[X] := C 13631488 * X ^ 17 + C (-71303168 : ℝ) * X ^ 16 + C 42 * X ^ 2

example (x : ℝ) : (P.derivative).eval x = 42 * 2 := by
  norm_num
