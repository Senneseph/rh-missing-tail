import Mathlib
import RhAttack.OnlineZetaDisk

open Complex Real Set Metric

/-
honline Phase 1 (OUR SOLUTION): the concrete disk isolating the strip
slice.

The online program must discharge

    honline : ∀ ρ ∈ qz.Z, 0 < |ρ.im| → |ρ.im| < 707/50 → ρ.re = 1/2

(`ZetaConcrete.rh_program78_qz_continuumAnchor_PT2`). The plan
(`docs/ONLINE-FORMALIZATION-SCOPE.md`, "the count goes through a
DISK"): center a disk on the critical line halfway up the strip slice
`{0 < Im s < T0}` with `T0 := 707/50`:

    C := 1/2 + (T0/2)·I,   R := sqrt(1/4 + (T0/2)²) + Δ

with a small explicit slack `Δ := 1/100`. The disk then

  * contains the whole strip slice (the farthest points are the
    corners `0` and `1`, at distance `sqrt(1/4 + (T0/2)²)` — strictly
    inside thanks to `Δ`);
  * reaches at most `T0/2 + R < T0 + 3/100` in imaginary part, so the
    part of the disk outside the strip is the thin band
    `{T0 < Im s ≤ T0 + 3/100 ∧ 0 < Re s < 1}` handled by N3;
  * has real-part range `[1/2 - R, 1/2 + R] ⊂ (-6.6, 7.6)`, which the
    Phase 1 evaluation engine covers arc by arc (Dirichlet side
    `Re s > 1`, eta-Euler middle `0 < Re s ≤ 1`, FE transport side
    `Re s < 0`).

This module fixes the constants and proves the pure geometry (exact
rational + `norm_num` bounds; no zeta facts, no RH claim).

NO RH CLAIM: geometry of an explicit closed disk in ℂ.
-/

namespace OnlineZetaDiskGeom
noncomputable section

/-- The height of the strip slice (the `honline` bound `707/50`). -/
def T0 : ℝ := (707 : ℝ) / 50

/-- Half the slice height: the imaginary part of the disk center. -/
def T02 : ℝ := T0 / 2

/-- The explicit slack: makes the strip corners strictly interior. -/
def Δ : ℝ := (1 : ℝ) / 100

/-- The disk center: on the critical line, halfway up the slice. -/
def C : ℂ := (1 / 2 : ℂ) + (T02 : ℂ) * Complex.I

/-- The disk radius: strip-corner distance plus the slack. -/
def R : ℝ := Real.sqrt (1 / 4 + T02 ^ 2) + Δ

/-! ## Basic positivity and exact values -/

theorem T0_pos : 0 < T0 := by norm_num [T0]

theorem T02_pos : 0 < T02 := by norm_num [T02, T0]

theorem Δ_pos : 0 < Δ := by norm_num [Δ]

theorem R_pos : 0 < R := by
  dsimp [R]
  have h1 : 0 < Real.sqrt (1 / 4 + T02 ^ 2) := Real.sqrt_pos.mpr (by positivity)
  linarith [h1, Δ_pos]

theorem T0_eq : T0 = 14.14 := by norm_num [T0]

theorem T02_eq : T02 = 7.07 := by norm_num [T02, T0]

theorem T02_mul2 : 2 * T02 = T0 := by norm_num [T02, T0]

/-! ## The corner distance and disk containment of the strip slice -/

/-- The norm of a real-plus-imaginary complex number. -/
theorem normRealIm (a b : ℝ) : ‖(a : ℂ) + (b : ℂ) * Complex.I‖ = Real.sqrt (a ^ 2 + b ^ 2) := by
  rw [Complex.norm_def]
  simp [Complex.normSq_apply, Complex.add_re, Complex.ofReal_re, Complex.I_re,
    Complex.mul_re, Complex.add_im, Complex.ofReal_im, Complex.I_im,
    Complex.mul_im]
  ring_nf

/-- The distance from the center to the strip corners `0` and `1` is
    exactly `sqrt(1/4 + (T0/2)²)`. -/
theorem cornerDist : ‖(0 : ℂ) - C‖ = Real.sqrt (1 / 4 + T02 ^ 2) := by
  dsimp [C]
  let z := (0 : ℂ) - ((1 / 2 : ℂ) + (T02 : ℂ) * Complex.I)
  have h1 : z.re = -(1 / 2 : ℝ) := by
    dsimp [z]
    simp
  have h2 : z.im = -T02 := by
    dsimp [z]
    simp
  rw [Complex.norm_def, Complex.normSq_apply, h1, h2]
  ring_nf

theorem cornerDist_one : ‖(1 : ℂ) - C‖ = Real.sqrt (1 / 4 + T02 ^ 2) := by
  dsimp [C]
  let z := (1 : ℂ) - ((1 / 2 : ℂ) + (T02 : ℂ) * Complex.I)
  have h1 : z.re = 1 / 2 := by
    dsimp [z]
    simp
    norm_num
  have h2 : z.im = -T02 := by
    dsimp [z]
    simp
  rw [Complex.norm_def, Complex.normSq_apply, h1, h2]
  ring_nf

/-- Both strip corners `0` and `1` are strictly inside the disk. -/
theorem corners_inDisk : (0 : ℂ) ∈ ball C R ∧ (1 : ℂ) ∈ ball C R := by
  refine ⟨?_, ?_⟩
  · rw [Metric.mem_ball, Complex.dist_eq, cornerDist]
    dsimp [R, Δ]
    linarith [Δ_pos]
  · rw [Metric.mem_ball, Complex.dist_eq, cornerDist_one]
    dsimp [R, Δ]
    linarith [Δ_pos]

/-- The whole strip slice `{0 < Re s < 1 ∧ 0 < Im s < T0}` is strictly
    inside the disk. -/
theorem stripSlice_subset_disk {s : ℂ} (hrelo : 0 < s.re) (hrehi : s.re < 1)
    (himlo : 0 < s.im) (himhi : s.im < T0) : s ∈ ball C R := by
  rw [Metric.mem_ball]
  have hC : C = (1 / 2 : ℂ) + (T02 : ℂ) * Complex.I := rfl
  have hdist : ‖s - C‖ ^ 2 = (s.re - 1 / 2) ^ 2 + (s.im - T02) ^ 2 := by
    dsimp [C]
    rw [Complex.sq_norm, Complex.normSq_apply]
    simp [sub_re, sub_im]
    ring_nf
  have hre : (s.re - 1 / 2) ^ 2 < (1 / 2 : ℝ) ^ 2 := by
    have h1 : |s.re - 1 / 2| < 1 / 2 := abs_lt.mpr ⟨by linarith, by linarith⟩
    have h2 : |(1 / 2 : ℝ)| = 1 / 2 := abs_of_nonneg (by norm_num)
    rw [sq_lt_sq, h2]
    exact h1
  have _him : (s.im - T02) ^ 2 < T02 ^ 2 := by
    have h1 : |s.im - T02| < T02 :=
      abs_lt.mpr ⟨by linarith, by linarith [T02_mul2]⟩
    have h2 : |T02| = T02 := abs_of_nonneg (le_of_lt T02_pos)
    rw [sq_lt_sq, h2]
    exact h1
  have hsum : (s.re - 1 / 2) ^ 2 + (s.im - T02) ^ 2 < 1 / 4 + T02 ^ 2 := by
    linarith [hrehi, _him]
  have hsq : ‖s - C‖ ^ 2 < 1 / 4 + T02 ^ 2 := by simpa [hdist] using hsum
  have hsqrt : Real.sqrt (1 / 4 + T02 ^ 2) > 0 := Real.sqrt_pos.mpr (by positivity)
  have hlt : ‖s - C‖ < Real.sqrt (1 / 4 + T02 ^ 2) := by
    have h1 : ‖s - C‖ = Real.sqrt (‖s - C‖ ^ 2) :=
      (Real.sqrt_sq (by positivity)).symm
    rw [h1]
    exact Real.sqrt_lt_sqrt (by positivity) hsq
  rw [Complex.dist_eq]
  dsimp [R, Δ]
  linarith [hlt, Δ_pos]

/-! ## Real and imaginary part ranges on the disk -/

/-- On the disk, the real part lies in `(1/2 - R, 1/2 + R)`. -/
theorem Re_bounds {s : ℂ} (hs : s ∈ ball C R) :
    1 / 2 - R < s.re ∧ s.re < 1 / 2 + R := by
  have hC : C.re = 1 / 2 := by
    have h : C = (1 / 2 : ℂ) + (T02 : ℂ) * Complex.I := rfl
    rw [h]
    simp [Complex.add_re, Complex.ofReal_re, Complex.I_re, Complex.mul_re,
      Complex.ofReal_im, Complex.I_im]
  have hd : |s.re - C.re| < R := by
    have h1 : dist s C < R := by rwa [Metric.mem_ball] at hs
    have h2 : |s.re - C.re| ≤ dist s C := by
      rw [Complex.dist_eq, ← sub_re (z := s) (w := C)]
      exact Complex.abs_re_le_norm (s - C)
    linarith [h2, h1]
  have h3 : s.re - C.re < R := by linarith [abs_lt.mp hd]
  have h4 : -R < s.re - C.re := by linarith [abs_lt.mp hd]
  constructor <;> linarith [h3, h4, hC]

/-- On the disk, the imaginary part lies in `(T02 - R, T02 + R)`. -/
theorem Im_bounds {s : ℂ} (hs : s ∈ ball C R) :
    T02 - R < s.im ∧ s.im < T02 + R := by
  have hC : C.im = T02 := by
    have h : C = (1 / 2 : ℂ) + (T02 : ℂ) * Complex.I := rfl
    rw [h]
    simp [Complex.add_im, Complex.ofReal_im, Complex.I_im, Complex.mul_im,
      Complex.ofReal_re, Complex.I_re]
  have hd : |s.im - C.im| < R := by
    have h1 : dist s C < R := by rwa [Metric.mem_ball] at hs
    have h2 : |s.im - C.im| ≤ dist s C := by
      rw [Complex.dist_eq, ← sub_im (z := s) (w := C)]
      exact Complex.abs_im_le_norm (s - C)
    linarith [h2, h1]
  have h3 : s.im - C.im < R := by linarith [abs_lt.mp hd]
  have h4 : -R < s.im - C.im := by linarith [abs_lt.mp hd]
  constructor <;> linarith [h3, h4, hC]

/-! ## Explicit rational bounds (for the evaluation arcs) -/

/-- `R < 71/10` — the radius is strictly below `7.1`. -/
theorem R_lt_71 : R < 71 / 10 := by
  dsimp [R, Δ]
  have h1 : Real.sqrt (1 / 4 + T02 ^ 2) < 709 / 100 := by
    rw [Real.sqrt_lt' (by norm_num)]
    norm_num [T02, T0]
  linarith [h1]

/-- Real-part range on the disk, explicit: `-6.6 < s.re < 7.6`. -/
theorem Re_explicit {s : ℂ} (hs : s ∈ ball C R) : -33 / 5 < s.re ∧ s.re < 38 / 5 := by
  have h := Re_bounds hs
  constructor
  · linarith [h.1, R_lt_71]
  · linarith [h.2, R_lt_71]

/-- Imaginary-part range on the disk, explicit: the disk reaches at most
    `T0 + 3/100` in imaginary part (so the part of the disk above the
    strip slice is the band of width `3/100`). -/
theorem Im_upper {s : ℂ} (hs : s ∈ ball C R) : s.im < T0 + 3 / 100 := by
  have h := Im_bounds hs
  have hT : T02 + R < T0 + 3 / 100 := by
    have hR : R < 71 / 10 := R_lt_71
    have hT0 : T0 = 707 / 50 := by norm_num [T0]
    have hT02 : T02 = 707 / 100 := by norm_num [T02, T0]
    rw [hT0, hT02]
    linarith [hR]
  linarith [h.2, hT]

/-- The thin band: a point of the disk with `T0 < Im s` has
    `Im s < T0 + 3/100` (width `3/100`) — the N3 region. -/
theorem disk_bandWidth {s : ℂ} (hs : s ∈ ball C R) (_him : T0 < s.im) :
    s.im < T0 + 3 / 100 := Im_upper hs

/-- Lower imaginary bound, explicit: `s.im > 0` is NOT automatic on the
    whole disk (it dips to `T02 - R ≈ -0.028`); the evaluation engine
    splits accordingly. Here the explicit bound used: `-1 < s.im`. -/
theorem Im_lower {s : ℂ} (hs : s ∈ ball C R) : -1 < s.im := by
  have h := Im_bounds hs
  have h1 : T02 - R > -1 := by
    have hR : R < 71 / 10 := R_lt_71
    have hT02 : T02 = 707 / 100 := by norm_num [T02, T0]
    rw [hT02]
    linarith [hR]
  linarith [h.1, h1]

end
end OnlineZetaDiskGeom
