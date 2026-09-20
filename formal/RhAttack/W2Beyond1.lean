/-
# (W2Beyond1)  R2 step 2 Lean atoms:  the drift reduction.

The data-free RE-DUCTION of the W2-beyond R2 route to the per-gap
increment statistics —  named theorems, built on W2Beyond0 (step 1)
+ the W2K / W2I atoms:

  nas_inc_band     the per-gap model increment sits between
                   Rho(x)·gap and Rho(y)·gap (MVT point + Rho
                   monotone —  two-sided,  no gap data)
  driftTelescopes  DN(j) - DN(0) = sum of the per-step drifts
                   (definitional,  Finset.sum_range_succ)
  driftRegimeLe    if every per-gap increment is <= 1 (under-
                   density regime w.r.t. the model),  the walk
                   moves monotonically and |DN(j) - DN(0)| is
                   exactly the drift sum
  driftRegimeGe    the mirrored >= 1 regime (over-density)
  driftTwoSided    if every per-gap increment satisfies
                   |Δ - 1| <= ε_i,  then |DN(j) - DN(0)| <=
                   sum ε_i —  the uniform bound reduces to the
                   EXPLICIT SUM over the per-gap errors ε_i

The last one is the R2 payoff:  sup |DN| on a band (from a
pinned DN(0)) is bounded by the pinned start value plus the
Σ-ε sum —  and the ε_i are the per-gap quantities
(gap_i against the Rho-scale) the measured data +
nas_inc_band supply.  Computing / certifying those ε_i (the
gap statistics over 9e9+ zeros) is the next unit —  the open
content.  No data,  no RH claim.

Reused:  W2Beyond0 (driftStep),  W2K.Nas/Rho/nasHasDerivAt/
twoPiPos,  W2I.hNasCont,  W2T.DN,  mathlib
exists_hasDerivAt_eq_slope / Finset.sum_range_succ /
Finset.sum_nonneg / Finset.sum_le_sum / Finset.sum_neg_distrib /
abs_of_nonneg / abs_of_nonpos / abs_neg (all #check-verified
against the pinned mathlib v4.33.1 before use).

Lean 4.33.1 + mathlib v4.33.1.
-/
import Mathlib
import RhAttack.W2Kernel
import RhAttack.W2Integral
import RhAttack.W2Telescope
import RhAttack.W2Beyond0

namespace W2Beyond1

open W2K W2I W2Beyond0 Real

/-! ### 1.  The per-gap two-sided model increment -/

/-- (PROVEN, MVT + Rho monotone)  for 0 < x < y,  the RVM
    increment over the gap sits between the left-end and
    right-end slope bounds:
    Rho x · (y - x) ≤ Nas y - Nas x ≤ Rho y · (y - x). -/
theorem nas_inc_band (x y : ℝ) (hx : 0 < x) (hxy : x < y) :
    Rho x * (y - x) ≤ Nas y - Nas x ∧ Nas y - Nas x ≤ Rho y * (y - x) := by
  have hcont : ContinuousOn Nas (Set.Icc x y) :=
    hNasCont.mono (fun u hu => lt_of_lt_of_le hx hu.1)
  obtain ⟨c, hc, hcderiv⟩ :=
    exists_hasDerivAt_eq_slope Nas (fun u => Rho u) hxy hcont
      (fun u hu => nasHasDerivAt u (lt_trans hx hu.1))
  have hstep : Nas y - Nas x = Rho c * (y - x) := by
    rw [hcderiv]
    field_simp [ne_of_gt (sub_pos.mpr hxy)]
  have hgap : 0 < y - x := sub_pos.mpr hxy
  have hcl : x < c := hc.1
  have hcr : c < y := hc.2
  have hcx : 0 < c := lt_trans hx hcl
  have hleft : Rho x * (y - x) ≤ Rho c * (y - x) :=
    mul_le_mul_of_nonneg_right (rho_increasing x c hx (le_of_lt hcl)) hgap.le
  have hright : Rho c * (y - x) ≤ Rho y * (y - x) :=
    mul_le_mul_of_nonneg_right (rho_increasing c y hcx (le_of_lt hcr)) hgap.le
  constructor
  · rw [hstep]
    exact hleft
  · rw [hstep]
    exact hright

/-! ### 2.  The drift telescopes -/

/-- (PROVEN)  the walk displacement from the band start is
    exactly the sum of the per-step drifts:
    DN(j) - DN(0) = ∑ᵢ<ⱼ (1 - (Nas(i+1) - Nas(i))). -/
theorem driftTelescopes (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ) :
    W2T.DN N0 NasGrid j - W2T.DN N0 NasGrid 0 =
      (Finset.range j).sum (fun i => 1 - (NasGrid (i + 1) - NasGrid i)) := by
  induction j with
  | zero =>
    simp only [W2T.DN, Nat.cast_zero]
    ring
  | succ i ih =>
    have hstep := W2Beyond0.driftStep N0 NasGrid i
    calc
      W2T.DN N0 NasGrid (i + 1) - W2T.DN N0 NasGrid 0 =
          (W2T.DN N0 NasGrid (i + 1) - W2T.DN N0 NasGrid i) +
            (W2T.DN N0 NasGrid i - W2T.DN N0 NasGrid 0) := by ring
      _ = (1 - (NasGrid (i + 1) - NasGrid i)) +
            (W2T.DN N0 NasGrid i - W2T.DN N0 NasGrid 0) := by rw [hstep]
      _ = (1 - (NasGrid (i + 1) - NasGrid i)) +
            ((Finset.range i).sum (fun u => 1 - (NasGrid (u + 1) - NasGrid u))) :=
        by rw [ih]
      _ = (Finset.range (i + 1)).sum (fun u => 1 - (NasGrid (u + 1) - NasGrid u)) := by
        rw [Finset.sum_range_succ]
        ring

/-! ### 3.  The regime bounds (one-sided drift) -/

/-- (PROVEN)  UNDER-density regime:  if every per-gap model
    increment is at most 1 (each gap carries at least one unit of
    model count —  in the data this is the Rho-scale condition on
    the zero gaps),  the walk drifts one way and the displacement
    magnitude is exactly the drift sum. -/
theorem driftRegimeLe (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ)
    (hregime : ∀ i ∈ Finset.range j, NasGrid (i + 1) - NasGrid i ≤ 1) :
    |W2T.DN N0 NasGrid j - W2T.DN N0 NasGrid 0| =
      (Finset.range j).sum (fun i => 1 - (NasGrid (i + 1) - NasGrid i)) := by
  rw [driftTelescopes]
  apply abs_of_nonneg
  apply Finset.sum_nonneg
  intro i hi
  exact sub_nonneg.mpr (hregime i hi)

/-- (PROVEN)  OVER-density regime:  the mirror of driftRegimeLe —
    every per-gap increment at least 1,  and the displacement
    magnitude is the mirrored drift sum. -/
theorem driftRegimeGe (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ)
    (hregime : ∀ i ∈ Finset.range j, 1 ≤ NasGrid (i + 1) - NasGrid i) :
    |W2T.DN N0 NasGrid j - W2T.DN N0 NasGrid 0| =
      (Finset.range j).sum (fun i => (NasGrid (i + 1) - NasGrid i) - 1) := by
  rw [driftTelescopes]
  have hsum : (Finset.range j).sum (fun i => 1 - (NasGrid (i + 1) - NasGrid i)) =
      -((Finset.range j).sum (fun i => (NasGrid (i + 1) - NasGrid i) - 1)) := by
    have hfun : (fun i : ℕ => 1 - (NasGrid (i + 1) - NasGrid i)) =
        (fun i => -((NasGrid (i + 1) - NasGrid i) - 1)) := by
      funext i
      ring
    rw [hfun, Finset.sum_neg_distrib]
  rw [hsum, abs_neg]
  exact Finset.abs_sum_of_nonneg fun i hi => sub_nonneg.mpr (hregime i hi)

/-! ### 4.  The two-sided bound —  the R2 reduction -/

/-- (PROVEN — THE R2 REDUCTION)  if every per-gap increment
    satisfies  |Δ_i - 1| ≤ ε_i  (the ε_i explicit and
    summable over the band),  then the walk displacement from
    the band start is bounded by the pinned start value plus the
    Σ-ε sum:  |DN(j) - DN(0)| ≤ ∑ᵢ<ⱼ ε_i.  Composed with a
    pinned DN(0) (a data-adjacent constant,  the W2M5 pattern),
    this is a sup-|DN| BOUND on the band —  the uniform walk
    bound of the [S1] leg,  conditional on the per-gap ε
    statistics.  Producing those statistics (per-gap Rho-scale
    errors over the 9e9+ zero census) is the next unit. -/
theorem driftTwoSided (N0 : ℕ) (NasGrid : ℕ → ℝ) (j : ℕ)
    (eps : ℕ → ℝ)
    (h : ∀ i ∈ Finset.range j, |(NasGrid (i + 1) - NasGrid i) - 1| ≤ eps i) :
    |W2T.DN N0 NasGrid j - W2T.DN N0 NasGrid 0| ≤
      (Finset.range j).sum eps := by
  rw [driftTelescopes]
  have htri :
      |(Finset.range j).sum (fun i => 1 - (NasGrid (i + 1) - NasGrid i))| ≤
        (Finset.range j).sum (fun i =>
          |1 - (NasGrid (i + 1) - NasGrid i)|) :=
    Finset.abs_sum_le_sum_abs (fun i => 1 - (NasGrid (i + 1) - NasGrid i)) (Finset.range j)
  have hpoint :
      (Finset.range j).sum (fun i => |1 - (NasGrid (i + 1) - NasGrid i)|) ≤
        (Finset.range j).sum eps := by
    apply Finset.sum_le_sum
    intro i hi
    have hε := h i hi
    have hring : 1 - (NasGrid (i + 1) - NasGrid i) =
        -((NasGrid (i + 1) - NasGrid i) - 1) := by ring
    have habs : |1 - (NasGrid (i + 1) - NasGrid i)| =
        |(NasGrid (i + 1) - NasGrid i) - 1| := by
      rw [hring, abs_neg]
    rw [habs]
    exact hε
  exact le_trans htri hpoint

end W2Beyond1
