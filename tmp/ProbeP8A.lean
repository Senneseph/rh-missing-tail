import Mathlib
open Real
def probe1 (K z : ℂ) : ℝ := |z - (K - z)|
def probe2 (K z : ℂ) : Prop := |z - (K - z)| < 3
set_option trace.Meta.synthInstance true
#check probe1
