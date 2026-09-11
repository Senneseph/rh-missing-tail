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
