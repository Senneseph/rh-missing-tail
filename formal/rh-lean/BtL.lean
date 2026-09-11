/-
  BtL — HasDerivAt transport probe: `lift` (function-equality transport
  of a derivative fact: S = C and S hasDerivAt D at x ⇒ C hasDerivAt D
  at x) plus canonical-atom test goals. Ported into B3.lean §2 as the
  NHat_deriv / fT_deriv recipe surface.
-/
import Mathlib
noncomputable section
open Real
variable {x : ℝ}
def lift {S C : ℝ → ℝ} (hfe : S = C) {D : ℝ} (h : HasDerivAt S D x) : HasDerivAt C D x :=
  Eq.mp (congrArg (fun (g : ℝ → ℝ) => HasDerivAt g D x) hfe) h
#check lift
variable (y : ℝ) (hy : 0 < y)
example : HasDerivAt (fun z : ℝ => z / 2) (1 / 2) y := by
  have hS : HasDerivAt (fun z : ℝ => (fun w : ℝ => w) z * (1 / 2)) (1 * (1 / 2)) y :=
    hasDerivAt_id' (x := y).mul_const (1 / 2)
  have hFe : (fun z : ℝ => (fun w : ℝ => w) z * (1 / 2)) = (fun z : ℝ => z / 2) := by ext z; ring
  exact lift hFe hS
