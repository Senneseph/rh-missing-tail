/-
# (W2Beyond0)  R2 step-1 Lean atoms:  the per-step drift.

The first concrete Lean core of the W2-beyond attack route R2
(per-step drift summation —  docs/W2-BEYOND-ATTACK-PLAN.md):  the
tail walk DN changes by  `1 - (model increment)`  at each step,
and the MODEL increment of the RVM asymptote is slope-bounded by
Rho at the right end (MVT + Rho monotone —  both built from the
already-proven W2K/W2I atoms).

What this module IS:  the per-step shape of the drift,  as named
theorems (driftStep —  definitional;  rho_increasing —  monotone;
nas_incr_bound —  the MVT increment bound;  driftBand —  the
two-sided per-step band once the gap increment is bounded).

What this module is NOT:  the uniform bound on sup |DN| —  the
summation of the per-step terms over the whole band,  against the
measured gap statistics,  is the open research content of R2.
This module fixes its first step so the next unit has a named
base.  No data,  no RH claim.

Reused (already GREEN):  W2K.Nas / W2K.Rho / W2K.nasHasDerivAt /
W2K.twoPiPos (W2Kernel K3),  W2I.hNasCont (W2Integral),
W2T.DN (W2Telescope),  mathlib `exists_deriv_eq_slope`
(Analysis/Calculus/Deriv/MeanValue.lean,  Lagrange MVT).

Lean 4.33.1 + mathlib v4.33.1.
-/
import Mathlib
import RhAttack.W2Kernel
import RhAttack.W2Integral
import RhAttack.W2Telescope

namespace W2Beyond0

open W2K W2I Real

/-! ### 1.  The discrete drift (definitional) -/

/-- (PROVEN, definitional)  the tail walk changes by
    `1 - (model increment)`  at each step:
    DN(j+1) - DN(j) = 1 - (Nas(j+1) - Nas(j)). -/
theorem driftStep (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ) :
    W2T.DN N0 NasGrid (j + 1) - W2T.DN N0 NasGrid j =
      1 - (NasGrid (j + 1) - NasGrid j) := by
  simp only [W2T.DN, Nat.cast_add, Nat.cast_one]
  ring

/-! ### 2.  The model side (RVM asymptote,  slope Rho) -/

/-- (PROVEN)  Rho = d/dx Nas is increasing on (0, ∞):  the
    monotone-log chain (no calculus:  Rho x = log(x/2π)/2π). -/
theorem rho_increasing (x y : ℝ) (hx : 0 < x) (hxy : x ≤ y) :
    Rho x ≤ Rho y := by
  have hp : 0 < 2 * Real.pi := twoPiPos
  have hinvinv : 0 ≤ (2 * Real.pi)⁻¹ := (inv_pos.mpr hp).le
  have hxyd : x / (2 * Real.pi) ≤ y / (2 * Real.pi) := by
    simp only [div_eq_mul_inv]
    exact mul_le_mul_of_nonneg_right hxy hinvinv
  have hlog : log (x / (2 * Real.pi)) ≤ log (y / (2 * Real.pi)) :=
    Real.log_le_log (div_pos hx hp) hxyd
  rw [Rho, Rho]
  simp only [div_eq_mul_inv]
  exact mul_le_mul_of_nonneg_right hlog hinvinv

/-- (PROVEN, MVT)  the RVM increment over [a, b] ⊂ (0, ∞) is
    bounded by Rho(b)·(b - a):  Nas b - Nas a ≤ Rho b · (b - a).
    (Lagrange MVT with the K3 derivative +  the Rho monotonicity
    above.) -/
theorem nas_incr_bound (a b : ℝ) (ha : 0 < a) (hab : a ≤ b) :
    Nas b - Nas a ≤ Rho b * (b - a) := by
  by_cases heq : a = b
  · subst heq
    ring_nf
    norm_num
  · have hlt : a < b := lt_of_le_of_ne hab heq
    have hcont : ContinuousOn Nas (Set.Icc a b) :=
      hNasCont.mono (fun x hx => lt_of_lt_of_le ha hx.1)
    obtain ⟨c, hc, hcderiv⟩ :=
      exists_hasDerivAt_eq_slope Nas (fun x => Rho x) hlt hcont
        (fun x hx => nasHasDerivAt x (lt_trans ha hx.1))
    have hc' : Rho c * (b - a) = Nas b - Nas a := by
      rw [hcderiv]
      field_simp [ne_of_gt (sub_pos.mpr hlt)]
    rw [hc'.symm]
    exact mul_le_mul_of_nonneg_right
      (rho_increasing c b (lt_trans ha hc.1) (le_of_lt hc.2))
      (sub_nonneg.mpr hab)

/-! ### 3.  The per-step band (data-adjacent form) -/

/-- (PROVEN)  once the model increment over one zero gap is
    bounded (0 ≤ ΔNasGrid ≤ S —  the gap-increment statement rides
    on the measured gap +  nas_incr_bound at the right end of the
    gap,  by the data link documented in the module header),  the
    walk step sits in the band  [1 - S, 1]:
    1 - S ≤ DN(j+1) - DN(j) ≤ 1.  This is the per-step input of
    the R2 summation (the summation itself is the open content). -/
theorem driftBand (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ) (S : ℝ)
    (hincr : NasGrid (j + 1) - NasGrid j ≤ S)
    (hincr0 : 0 ≤ NasGrid (j + 1) - NasGrid j) :
    1 - S ≤ W2T.DN N0 NasGrid (j + 1) - W2T.DN N0 NasGrid j ∧
    W2T.DN N0 NasGrid (j + 1) - W2T.DN N0 NasGrid j ≤ 1 := by
  rw [driftStep]
  constructor <;> linarith

end W2Beyond0
