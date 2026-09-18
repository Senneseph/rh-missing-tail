import Mathlib
set_option maxErrors 200
open Real

#check DifferentiableAt.comp

example {t : Real} (hp : 0 < t ^ 2) :
    DifferentiableAt Real (fun x : Real => Real.sqrt (x ^ 2)) t := by
  -- inner: x^2, outer: sqrt
  exact DifferentiableAt.comp (hasDerivAt_pow 2 t).differentiableAt
    (hasDerivAt_sqrt hp.ne').differentiableAt
