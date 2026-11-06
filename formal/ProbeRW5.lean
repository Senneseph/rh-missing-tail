import Mathlib

set_option linter.style.whitespace false

#print Continuous
example : Continuous (fun t : ℝ => (t : ℂ)) :=
  ⟨fun t => (continuous_ofReal : Continuous (fun _ : ℝ => (0 : ℂ) + t • (0 : ℂ))).continuousAt⟩
