import Mathlib

/- S4b OWN-STRIP ATOM (25n) — the EFFECTIVE IDENTITY at the 4 d^2 / t^2
   scale.

   The definition-side (C1a) own-height kernel of a candidate off-line
   zero at (t, d): the 8-factor product over the four zeros
   1/2 ± d ± it of (1 - S/rho) * exp(S/rho), S = 1/2 + it, has the
   EXACT closed form (25n, dps-40 grid-exact):

       mown (t d) = d^2 (d^2 + 4 t^2) / (A B) * exp (c)
       A = (1/2 + d)^2 + t^2,  B = (1/2 - d)^2 + t^2,
       c = (1/2 + d)/A + (1/2 - d)/B,

   and lives on the 4 d^2 / t^2 scale on the strip 0 < d <= 1/2:
       (4 d^2 / t^2) (t^2 / (t^2 + 1))^2 <= mown (t d) <=
       (4 d^2 / t^2) (1 + 1 / (16 t^2)) * exp (1 / t^2)   (hMownScale).

   Honest split: LEAN-PROVEN — everything in this file is closed
   form (no pins, no measurements).  Numeric pre-flight:
   scripts/rh/day023_s4_sweep.py (25n, dps-40, worst rel 7.2e-39 on
   t in [15, 1e8], d in (0, 1/2)).
-/

namespace S4O
open Real

/-- The candidate's four off-line zeros (real-parts grouped so the
    normSq_add_mul_I form is definitional). -/
noncomputable def z1 (t d : ℝ) : ℂ := ((1 / 2 + d : ℝ) : ℂ) + t * Complex.I
noncomputable def z2 (t d : ℝ) : ℂ := ((1 / 2 + d : ℝ) : ℂ) + (-(t) : ℝ) * Complex.I
noncomputable def z3 (t d : ℝ) : ℂ := ((1 / 2 - d : ℝ) : ℂ) + t * Complex.I
noncomputable def z4 (t d : ℝ) : ℂ := ((1 / 2 - d : ℝ) : ℂ) + (-(t) : ℝ) * Complex.I

/-- The reference point S = 1/2 + it. -/
noncomputable def S (t : ℝ) : ℂ := ((1 / 2 : ℝ) : ℂ) + t * Complex.I

/-- A = |z1|^2 = (1/2 + d)^2 + t^2. -/
noncomputable def Aown (t d : ℝ) : ℝ := (1 / 2 + d) ^ 2 + t ^ 2

/-- B = |z3|^2 = (1/2 - d)^2 + t^2. -/
noncomputable def Bown (t d : ℝ) : ℝ := (1 / 2 - d) ^ 2 + t ^ 2

/-- c = Re (S * (1/z1 + 1/z2 + 1/z3 + 1/z4)) — the exp part. -/
noncomputable def Cown (t d : ℝ) : ℝ :=
    (1 / 2 + d) / Aown t d + (1 / 2 - d) / Bown t d

/-- The exact own-height kernel mass (25n closed form). -/
@[reducible] noncomputable def mown (t d : ℝ) : ℝ :=
    d ^ 2 * (d ^ 2 + 4 * t ^ 2) / (Aown t d * Bown t d) *
    Real.exp (Cown t d)

/- — supporting lemmas — -/

/-- |z1|^2 = A, |z2|^2 = A, |z3|^2 = B, |z4|^2 = B. -/
theorem hA (t d : ℝ) : Complex.normSq (z1 t d) = Aown t d := by
  dsimp only [z1, Aown]
  rw [Complex.normSq_add_mul_I (1 / 2 + d) t]
theorem hA2 (t d : ℝ) : Complex.normSq (z2 t d) = Aown t d := by
  dsimp only [z2, Aown]
  rw [Complex.normSq_add_mul_I (1 / 2 + d) (-t)]
  ring
theorem hB (t d : ℝ) : Complex.normSq (z3 t d) = Bown t d := by
  dsimp only [z3, Bown]
  rw [Complex.normSq_add_mul_I (1 / 2 - d) t]
theorem hB2 (t d : ℝ) : Complex.normSq (z4 t d) = Bown t d := by
  dsimp only [z4, Bown]
  rw [Complex.normSq_add_mul_I (1 / 2 - d) (-t)]
  ring

/-- A, B > 0 on the strip (t > 0). -/
theorem hApos (t d : ℝ) (ht : 0 < t) : 0 < Aown t d := by
  dsimp only [Aown]
  nlinarith [pow_pos ht 2]
theorem hBpos (t d : ℝ) (ht : 0 < t) : 0 < Bown t d := by
  dsimp only [Bown]
  nlinarith [pow_pos ht 2]

/-- The exp exponent c is nonnegative on the strip. -/
theorem hCnonneg (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    0 ≤ Cown t d := by
  dsimp only [Cown]
  apply add_nonneg
  · exact div_nonneg (by nlinarith) (hApos t d ht).le
  · exact div_nonneg (by nlinarith) (hBpos t d ht).le

/-- The exp exponent is capped: c < 1 / t^2 on the strip.
    Termwise: p/A < p/t^2 (p = 1/2+d > 0, A = t^2 + p^2 > t^2, strict)
    and q/B <= q/t^2 (q = 1/2-d >= 0, B = t^2 + q^2 >= t^2);  the sum
    is p/t^2 + q/t^2 = 1/t^2.  The first term is strict, so the sum is. -/
theorem hClt (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    Cown t d < 1 / t ^ 2 := by
  dsimp only [Cown, Aown, Bown]
  set p := (1 / 2 + d) with hp
  set q := (1 / 2 - d) with hq
  have hp0 : 0 < p := by dsimp [p]; nlinarith [hd0]
  have hq0 : 0 ≤ q := by dsimp [q]; nlinarith [hd]
  have ht2 : 0 < t ^ 2 := pow_pos ht 2
  have hA : p ^ 2 + t ^ 2 > t ^ 2 := by nlinarith [hp0]
  have hB : q ^ 2 + t ^ 2 >= t ^ 2 := by nlinarith
  have h1 : p / (p ^ 2 + t ^ 2) < p / t ^ 2 := by
    have : p * t ^ 2 < p * (p ^ 2 + t ^ 2) := by
      nlinarith [hp0, pow_pos hp0 2]
    exact (div_lt_div_iff₀ (by nlinarith [ht2, hA, hq0]) ht2).mpr this
  have h2 : q / (q ^ 2 + t ^ 2) <= q / t ^ 2 := by
    have : q * t ^ 2 <= q * (q ^ 2 + t ^ 2) := by
      nlinarith [hq0, sq_nonneg q]
    exact (div_le_div_iff₀ (by nlinarith [ht2, hq0, sq_nonneg q]) ht2).mpr this
  calc p / (p ^ 2 + t ^ 2) + q / (q ^ 2 + t ^ 2) <
          p / t ^ 2 + q / t ^ 2 := add_lt_add_of_lt_of_le h1 h2
    _ = 1 / t ^ 2 := by
      have hsum : p + q = 1 := by dsimp [p, q]; ring
      rw [show p / t ^ 2 + q / t ^ 2 = (p + q) / t ^ 2 by field_simp [ht2], hsum]

/-- 1 <= exp c <= exp (1 / t^2) on the strip. -/
theorem hExpC (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    1 <= Real.exp (Cown t d) ∧ Real.exp (Cown t d) <= Real.exp (1 / t ^ 2) := by
  have hcn : 0 <= Cown t d := hCnonneg t d ht hd0 hd
  have hclt : Cown t d < 1 / t ^ 2 := hClt t d ht hd0 hd
  refine ⟨?_, ?_⟩
  · calc (1 : ℝ) = Real.exp 0 := by rw [Real.exp_zero]
      _ <= Real.exp (Cown t d) := Real.exp_le_exp.mpr hcn
  · exact Real.exp_le_exp.mpr (le_of_lt hclt)

/-- The four |1 - S / z_r| factors (on the strip). -/
theorem hFac1 (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) :
    ‖1 - S t / z1 t d‖ = d / Real.sqrt (Aown t d) := by
  have hd : z1 t d - S t = (d : ℂ) := by
    dsimp [z1, S]
    apply Complex.ext
    · simp
    · simp
  have hnz : z1 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z1] at h
    simp at h
    nlinarith [ht]
  rw [show (1 - S t / z1 t d : ℂ) = (z1 t d - S t) / z1 t d by field_simp [hnz], hd]
  rw [Complex.norm_div, Complex.norm_of_nonneg hd0.le]
  have hz1 : ‖z1 t d‖ = Real.sqrt (Aown t d) := by
    rw [Complex.norm_def, hA]
  rw [hz1]
theorem hFac2 (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) :
    ‖1 - S t / z2 t d‖ =
        Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Aown t d) := by
  have hd : z2 t d - S t = (d : ℂ) - 2 * t * Complex.I := by
    dsimp [z2, S]
    apply Complex.ext
    · simp
    · simp; ring

  have hnz : z2 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z2] at h
    simp at h
    nlinarith [ht]
  rw [show (1 - S t / z2 t d : ℂ) = (z2 t d - S t) / z2 t d by field_simp [hnz], hd]
  rw [Complex.norm_div]
  have hnum : ‖(d : ℂ) - 2 * t * Complex.I‖ = Real.sqrt (d ^ 2 + 4 * t ^ 2) := by
    have : (d : ℂ) - 2 * t * Complex.I = Complex.mk d (-2 * t) := by
      apply Complex.ext <;> simp
    rw [this, Complex.norm_def, Complex.normSq_mk,
        show (d * d + (-2 * t) * (-2 * t) : ℝ) = d ^ 2 + 4 * t ^ 2 from by ring]
  have hden : ‖z2 t d‖ = Real.sqrt (Aown t d) := by
    rw [Complex.norm_def, hA2]
  rw [hnum, hden]
theorem hFac3 (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) :
    ‖1 - S t / z3 t d‖ = d / Real.sqrt (Bown t d) := by
  have hd : z3 t d - S t = (-(d : ℂ)) := by
    dsimp [z3, S]
    apply Complex.ext
    · simp
    · simp
  have hnz : z3 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z3] at h
    simp at h
    nlinarith [ht]
  rw [show (1 - S t / z3 t d : ℂ) = (z3 t d - S t) / z3 t d by field_simp [hnz], hd]
  rw [Complex.norm_div, Complex.norm_neg']
  rw [Complex.norm_of_nonneg hd0.le]
  have hz3 : ‖z3 t d‖ = Real.sqrt (Bown t d) := by
    rw [Complex.norm_def, hB]
  rw [hz3]
theorem hFac4 (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) :
    ‖1 - S t / z4 t d‖ =
        Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Bown t d) := by
  have hd : z4 t d - S t = (-(d : ℂ)) - 2 * t * Complex.I := by
    dsimp [z4, S]
    apply Complex.ext
    · simp
    · simp; ring

  have hnz : z4 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z4] at h
    simp at h
    nlinarith [ht]
  rw [show (1 - S t / z4 t d : ℂ) = (z4 t d - S t) / z4 t d by field_simp [hnz], hd]
  rw [Complex.norm_div]
  have hnum : ‖(-(d : ℂ)) - 2 * t * Complex.I‖ = Real.sqrt (d ^ 2 + 4 * t ^ 2) := by
    have : (-(d : ℂ)) - 2 * t * Complex.I = Complex.mk (-d) (-2 * t) := by
      apply Complex.ext <;> simp
    rw [this, Complex.norm_def, Complex.normSq_mk,
        show ((-d) * (-d) + (-2 * t) * (-2 * t) : ℝ) = d ^ 2 + 4 * t ^ 2 from by ring]
  have hden : ‖z4 t d‖ = Real.sqrt (Bown t d) := by
    rw [Complex.norm_def, hB2]
  rw [hnum, hden]

/- — the C1a own-height kernel: exact form — -/

/-- The direct kernel: |Π_r (1 - S/z_r) · exp(S/z_r)| over the four
    candidate zeros (25n). -/
@[reducible] noncomputable def ownKer (t d : ℝ) : ℝ :=
    ‖(1 - S t / z1 t d) * Complex.exp (S t / z1 t d) *
     (1 - S t / z2 t d) * Complex.exp (S t / z2 t d) *
     (1 - S t / z3 t d) * Complex.exp (S t / z3 t d) *
     (1 - S t / z4 t d) * Complex.exp (S t / z4 t d)‖

/-- The exp-pair reals: Re(S/z1) + Re(S/z2) = (1/2 + d)/A. -/
theorem hRePair1 (t d : ℝ) (ht : 0 < t) :
    (S t / z1 t d).re + (S t / z2 t d).re = (1 / 2 + d) / Aown t d := by
  have hnz1 : z1 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z1] at h
    simp at h
    nlinarith [ht]
  have hnz2 : z2 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z2] at h
    simp at h
    nlinarith [ht]
  have hsum : (S t / z1 t d) + (S t / z2 t d) =
      S t * (z1 t d + z2 t d) / (z1 t d * z2 t d) := by
    field_simp [hnz1, hnz2]
    ring
  rw [show (S t / z1 t d).re + (S t / z2 t d).re =
        ((S t / z1 t d) + (S t / z2 t d)).re from by rw [Complex.add_re], hsum]
  have hzz : z1 t d * z2 t d = (Aown t d : ℂ) := by
    dsimp only [z1, z2, Aown]
    apply Complex.ext
    · simp only [Complex.mul_re, Complex.add_re, Complex.mul_im, Complex.add_im,
          Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
      ring
    · simp only [Complex.mul_im, Complex.add_im, Complex.add_re, Complex.mul_re,
          Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
      ring
  rw [hzz]
  have hzs : z1 t d + z2 t d = ((2 * (1 / 2 + d) : ℝ) : ℂ) := by
    dsimp only [z1, z2]
    apply Complex.ext
    · simp
      ring
    · simp
  rw [hzs]
  rw [show (S t * ((2 * (1 / 2 + d) : ℝ) : ℂ) / (Aown t d : ℂ)) =
          S t * ((2 * (1 / 2 + d) : ℝ) : ℂ) * ((Aown t d : ℂ))⁻¹ by
    field_simp [show (Aown t d : ℝ) ≠ 0 from ne_of_gt (hApos t d ht)]]
  rw [show (S t * ((2 * (1 / 2 + d) : ℝ) : ℂ) * ((Aown t d : ℂ))⁻¹) =
          ((Aown t d : ℂ))⁻¹ * (S t * ((2 * (1 / 2 + d) : ℝ) : ℂ)) by
    ring]
  rw [show ((Aown t d : ℂ))⁻¹ = (Aown t d)⁻¹ from by norm_cast]
  rw [Complex.re_ofReal_mul]
  rw [show (S t * ((2 * (1 / 2 + d) : ℝ) : ℂ)) =
          ((2 * (1 / 2 + d) : ℝ) : ℂ) * S t by
    ring]
  rw [Complex.re_ofReal_mul]
  rw [show (S t : ℂ).re = 1 / 2 from by dsimp only [S]; simp]
  field_simp
/-- The exp-pair reals: Re(S/z3) + Re(S/z4) = (1/2 - d)/B. -/
theorem hRePair2 (t d : ℝ) (ht : 0 < t) :
    (S t / z3 t d).re + (S t / z4 t d).re = (1 / 2 - d) / Bown t d := by
  have hnz3 : z3 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z3] at h
    simp at h
    nlinarith [ht]
  have hnz4 : z4 t d ≠ 0 := by
    intro h
    rw [Complex.ext_iff] at h
    dsimp only [z4] at h
    simp at h
    nlinarith [ht]
  have hsum : (S t / z3 t d) + (S t / z4 t d) =
      S t * (z3 t d + z4 t d) / (z3 t d * z4 t d) := by
    field_simp [hnz3, hnz4]
    ring
  rw [show (S t / z3 t d).re + (S t / z4 t d).re =
        ((S t / z3 t d) + (S t / z4 t d)).re from by rw [Complex.add_re], hsum]
  have hzz : z3 t d * z4 t d = (Bown t d : ℂ) := by
    dsimp only [z3, z4, Bown]
    apply Complex.ext
    · simp only [Complex.mul_re, Complex.add_re, Complex.mul_im, Complex.add_im,
          Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
      ring
    · simp only [Complex.mul_im, Complex.add_im, Complex.add_re, Complex.mul_re,
          Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
      ring
  rw [hzz]
  have hzs : z3 t d + z4 t d = ((2 * (1 / 2 - d) : ℝ) : ℂ) := by
    dsimp only [z3, z4]
    apply Complex.ext
    · simp
      ring
    · simp
  rw [hzs]
  rw [show (S t * ((2 * (1 / 2 - d) : ℝ) : ℂ) / (Bown t d : ℂ)) =
          S t * ((2 * (1 / 2 - d) : ℝ) : ℂ) * ((Bown t d : ℂ))⁻¹ by
    field_simp [show (Bown t d : ℝ) ≠ 0 from ne_of_gt (hBpos t d ht)]]
  rw [show (S t * ((2 * (1 / 2 - d) : ℝ) : ℂ) * ((Bown t d : ℂ))⁻¹) =
          ((Bown t d : ℂ))⁻¹ * (S t * ((2 * (1 / 2 - d) : ℝ) : ℂ)) by
    ring]
  rw [show ((Bown t d : ℂ))⁻¹ = (Bown t d)⁻¹ from by norm_cast]
  rw [Complex.re_ofReal_mul]
  rw [show (S t * ((2 * (1 / 2 - d) : ℝ) : ℂ)) =
          ((2 * (1 / 2 - d) : ℝ) : ℂ) * S t by
    ring]
  rw [Complex.re_ofReal_mul]
  rw [show (S t : ℂ).re = 1 / 2 from by dsimp only [S]; simp]
  field_simp
theorem hMownProd (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    ownKer t d = mown t d := by
  dsimp only [ownKer, mown, Cown]
  set r1 := (S t / z1 t d).re with hr1
  set r2 := (S t / z2 t d).re with hr2
  set r3 := (S t / z3 t d).re with hr3
  set r4 := (S t / z4 t d).re with hr4
  have h1 : ‖(1 - S t / z1 t d) * Complex.exp (S t / z1 t d)‖ =
      ‖1 - S t / z1 t d‖ * Real.exp r1 := by
    rw [Complex.norm_mul, Complex.norm_exp, ← hr1]
  have h2 : ‖(1 - S t / z2 t d) * Complex.exp (S t / z2 t d)‖ =
      ‖1 - S t / z2 t d‖ * Real.exp r2 := by
    rw [Complex.norm_mul, Complex.norm_exp, ← hr2]
  have h3 : ‖(1 - S t / z3 t d) * Complex.exp (S t / z3 t d)‖ =
      ‖1 - S t / z3 t d‖ * Real.exp r3 := by
    rw [Complex.norm_mul, Complex.norm_exp, ← hr3]
  have h4 : ‖(1 - S t / z4 t d) * Complex.exp (S t / z4 t d)‖ =
      ‖1 - S t / z4 t d‖ * Real.exp r4 := by
    rw [Complex.norm_mul, Complex.norm_exp, ← hr4]
  have hsa : Real.sqrt (Aown t d) * Real.sqrt (Aown t d) = Aown t d := by
    rw [Real.mul_self_sqrt (hApos t d ht).le]
  have hsb : Real.sqrt (Bown t d) * Real.sqrt (Bown t d) = Bown t d := by
    rw [Real.mul_self_sqrt (hBpos t d ht).le]
  have hsd : Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.sqrt (d ^ 2 + 4 * t ^ 2) =
      d ^ 2 + 4 * t ^ 2 := by
    rw [Real.mul_self_sqrt (by nlinarith)]
  have hexpsum :
      Real.exp r1 * Real.exp r2 * Real.exp r3 * Real.exp r4 =
      Real.exp (r1 + r2 + r3 + r4) := by
    rw [← Real.exp_add, ← Real.exp_add, ← Real.exp_add,
        show ((r1 + r2) + r3) + r4 = r1 + r2 + r3 + r4 from by ring]
  have hnorms :
      ‖(1 - S t / z1 t d) * Complex.exp (S t / z1 t d) *
       (1 - S t / z2 t d) * Complex.exp (S t / z2 t d) *
       (1 - S t / z3 t d) * Complex.exp (S t / z3 t d) *
       (1 - S t / z4 t d) * Complex.exp (S t / z4 t d)‖ =
      d / Real.sqrt (Aown t d) * Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Aown t d) *
      d / Real.sqrt (Bown t d) * Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Bown t d) *
      Real.exp (r1 + r2 + r3 + r4) := by
    calc
      _ = ‖((1 - S t / z1 t d) * Complex.exp (S t / z1 t d)) *
           ((1 - S t / z2 t d) * Complex.exp (S t / z2 t d)) *
           ((1 - S t / z3 t d) * Complex.exp (S t / z3 t d)) *
           ((1 - S t / z4 t d) * Complex.exp (S t / z4 t d))‖ := by
        rw [show ((1 - S t / z1 t d) * Complex.exp (S t / z1 t d) *
                  (1 - S t / z2 t d) * Complex.exp (S t / z2 t d) *
                  (1 - S t / z3 t d) * Complex.exp (S t / z3 t d) *
                  (1 - S t / z4 t d) * Complex.exp (S t / z4 t d) : ℂ) =
                ((1 - S t / z1 t d) * Complex.exp (S t / z1 t d)) *
                ((1 - S t / z2 t d) * Complex.exp (S t / z2 t d)) *
                ((1 - S t / z3 t d) * Complex.exp (S t / z3 t d)) *
                ((1 - S t / z4 t d) * Complex.exp (S t / z4 t d)) from by ring]
      _ = ‖(1 - S t / z1 t d) * Complex.exp (S t / z1 t d)‖ *
          ‖(1 - S t / z2 t d) * Complex.exp (S t / z2 t d)‖ *
          ‖(1 - S t / z3 t d) * Complex.exp (S t / z3 t d)‖ *
          ‖(1 - S t / z4 t d) * Complex.exp (S t / z4 t d)‖ := by
        rw [Complex.norm_mul, Complex.norm_mul, Complex.norm_mul]
      _ = (‖1 - S t / z1 t d‖ * Real.exp r1) *
          (‖1 - S t / z2 t d‖ * Real.exp r2) *
          (‖1 - S t / z3 t d‖ * Real.exp r3) *
          (‖1 - S t / z4 t d‖ * Real.exp r4) := by
        rw [h1, h2, h3, h4]
      _ = (d / Real.sqrt (Aown t d) * Real.exp r1) *
          (Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Aown t d) * Real.exp r2) *
          (d / Real.sqrt (Bown t d) * Real.exp r3) *
          (Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Bown t d) * Real.exp r4) := by
        rw [hFac1 t d ht hd0, hFac2 t d ht hd0, hFac3 t d ht hd0, hFac4 t d ht hd0]
      _ = d / Real.sqrt (Aown t d) * Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Aown t d) *
          d / Real.sqrt (Bown t d) * Real.sqrt (d ^ 2 + 4 * t ^ 2) / Real.sqrt (Bown t d) *
          Real.exp (r1 + r2 + r3 + r4) := by
        field_simp [hsa, hsb, hsd]
        rw [hexpsum]
  have hsum :
      r1 + r2 + r3 + r4 = (1 / 2 + d) / Aown t d + (1 / 2 - d) / Bown t d := by
    rw [show r1 + r2 + r3 + r4 = (r1 + r2) + (r3 + r4) from by ring,
        hRePair1 t d ht, hRePair2 t d ht]
  rw [hnorms, show Real.exp (r1 + r2 + r3 + r4) =
        Real.exp ((1 / 2 + d) / Aown t d + (1 / 2 - d) / Bown t d) from by rw [hsum]]
  have hinva : (Real.sqrt (Aown t d)) ⁻¹ ^ 2 = (Aown t d) ⁻¹ := by
    rw [inv_pow, show (Real.sqrt (Aown t d) : ℝ) ^ 2 = Aown t d from
      by rw [sq, Real.mul_self_sqrt (hApos t d ht).le]]
  have hinvb : (Real.sqrt (Bown t d)) ⁻¹ ^ 2 = (Bown t d) ⁻¹ := by
    rw [inv_pow, show (Real.sqrt (Bown t d) : ℝ) ^ 2 = Bown t d from
      by rw [sq, Real.mul_self_sqrt (hBpos t d ht).le]]
  field_simp [hsa, hsb, hsd, hinva, hinvb]
  rw [show (Real.sqrt (d ^ 2 + 4 * t ^ 2) : ℝ) ^ 2 = d ^ 2 + 4 * t ^ 2 from
        by rw [sq, Real.mul_self_sqrt (by nlinarith)],
      show (Real.sqrt (Aown t d) : ℝ) ^ 2 = Aown t d from
        by rw [sq, Real.mul_self_sqrt (hApos t d ht).le],
      show (Real.sqrt (Bown t d) : ℝ) ^ 2 = Bown t d from
        by rw [sq, Real.mul_self_sqrt (hBpos t d ht).le]]

/-- THE 25n SCALE (lower half): on the strip 0 < d <= 1/2 the own
    mass is at least (4 d^2/t^2) (t^2/(t^2+1))^2 — it lands on the
    4 d^2/t^2 scale with pinned O(1/t^2) relative correction.
    Proof data: D := d^2 + 4 t^2 >= 4 t^2;  A, B <= t^2 + 1
    (1/2 + d <= 1, |1/2 - d| <= 1/2);  e^c >= 1. -/
theorem hMownScaleLo (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 ≤ mown t d := by
  dsimp only [mown]
  set D := d ^ 2 + 4 * t ^ 2 with hdD
  have hsqA : (1 / 2 + d) ^ 2 ≤ 1 := by
    have hb : 0 ≤ 1 / 2 + d := by nlinarith [hd0]
    have hu : 1 / 2 + d ≤ 1 := by nlinarith
    rw [pow_two]
    exact le_trans (mul_self_le_mul_self hb hu) (by norm_num)
  have hA : Aown t d ≤ t ^ 2 + 1 := by
    dsimp only [Aown]
    nlinarith [hsqA]
  have hsqB : (1 / 2 - d) ^ 2 ≤ 1 := by
    have hb : 0 ≤ 1 / 2 - d := by nlinarith [hd]
    have hu : 1 / 2 - d ≤ 1 := by nlinarith [hd0]
    rw [pow_two]
    exact le_trans (mul_self_le_mul_self hb hu) (by norm_num)
  have hB : Bown t d ≤ t ^ 2 + 1 := by
    dsimp only [Bown]
    nlinarith [hsqB]
  have hD : 4 * t ^ 2 ≤ D := by
    dsimp only [D]
    nlinarith
  have hc : 1 ≤ Real.exp (Cown t d) := (hExpC t d ht hd0 hd).1
  have hposA : 0 < Aown t d * Bown t d := by
    nlinarith [hApos t d ht, hBpos t d ht]
  have hposT : 0 < (t ^ 2 + 1) ^ 2 := by positivity
  have hnum : 0 < d ^ 2 * 4 * t ^ 2 := by positivity
  have hABle : Aown t d * Bown t d ≤ (t ^ 2 + 1) ^ 2 := by
    rw [pow_two]
    exact mul_le_mul hA hB (hBpos t d ht).le (by nlinarith [pow_pos ht 2])
  have hD2 : (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 =
      d ^ 2 * 4 * t ^ 2 / (t ^ 2 + 1) ^ 2 := by
    field_simp
  calc (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2
      = d ^ 2 * 4 * t ^ 2 / (t ^ 2 + 1) ^ 2 := hD2
    _ ≤ d ^ 2 * 4 * t ^ 2 / (Aown t d * Bown t d) := by
      apply (div_le_div_iff_of_pos_left hnum hposT hposA).mpr
      exact hABle
    _ ≤ d ^ 2 * D / (Aown t d * Bown t d) := by
      apply div_le_div_of_nonneg_right
      · nlinarith [hD]
      · exact hposA.le
    _ ≤ d ^ 2 * D / (Aown t d * Bown t d) * Real.exp (Cown t d) := by
      have hx : 0 ≤ d ^ 2 * D / (Aown t d * Bown t d) := by
        apply div_nonneg
        · nlinarith
        · exact hposA.le
      rw [<- mul_one (d ^ 2 * D / (Aown t d * Bown t d)),
        show (d ^ 2 * D / (Aown t d * Bown t d) : ℝ) * 1 * Real.exp (Cown t d) =
              (d ^ 2 * D / (Aown t d * Bown t d)) * Real.exp (Cown t d) by ring]
      exact mul_le_mul_of_nonneg_left hc hx
/-- THE 25n SCALE (upper half): mown <= (4 d^2/t^2) (1 + 1/(16 t^2))
    e^{1/t^2} on the strip.
    Proof data: D := d^2 + 4 t^2 <= 4 t^2 + 1/4 (d <= 1/2);
    A, B >= t^2 so A B >= t^4;  e^c <= e^{1/t^2}. -/
theorem hMownScaleHi (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    mown t d ≤ (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) *
        Real.exp (1 / t ^ 2) := by
  dsimp only [mown]
  set D := d ^ 2 + 4 * t ^ 2 with hdD
  have hd4 : d ^ 2 ≤ 1 / 4 := by
    have hb : 0 ≤ d := hd0.le
    rw [pow_two]
    exact le_trans (mul_self_le_mul_self hb hd) (by norm_num)
  have hD : D ≤ 4 * t ^ 2 + 1 / 4 := by
    dsimp only [D]
    nlinarith [hd4]
  have hc : Real.exp (Cown t d) ≤ Real.exp (1 / t ^ 2) :=
    (hExpC t d ht hd0 hd).2
  have hposA : 0 < Aown t d * Bown t d := by
    nlinarith [hApos t d ht, hBpos t d ht]
  have hposT : 0 < t ^ 4 := pow_pos ht 4
  have hE : 0 ≤ Real.exp (1 / t ^ 2) := Real.exp_nonneg _
  have hDnum : 0 < d ^ 2 * (4 * t ^ 2 + 1 / 4) := by positivity
  have hnum : d ^ 2 * D ≤ d ^ 2 * (4 * t ^ 2 + 1 / 4) := by
    nlinarith [hD]
  have hABt4 : t ^ 4 ≤ Aown t d * Bown t d := by
    have hAt : t ^ 2 ≤ Aown t d := by
      dsimp only [Aown]
      nlinarith
    have hBt : t ^ 2 ≤ Bown t d := by
      dsimp only [Bown]
      nlinarith
    have ht2p : 0 ≤ t ^ 2 := pow_nonneg ht.le 2
    rw [show (t ^ 4 : ℝ) = t ^ 2 * t ^ 2 by ring]
    exact mul_le_mul hAt hBt ht2p (hApos t d ht).le
  calc (d ^ 2 * D / (Aown t d * Bown t d) * Real.exp (Cown t d))
      ≤ d ^ 2 * D / (Aown t d * Bown t d) * Real.exp (1 / t ^ 2) := by
        have hx : 0 ≤ d ^ 2 * D / (Aown t d * Bown t d) := by
          apply div_nonneg
          · nlinarith
          · exact hposA.le
        exact mul_le_mul_of_nonneg_left hc hx
    _ ≤ d ^ 2 * (4 * t ^ 2 + 1 / 4) / (Aown t d * Bown t d) *
          Real.exp (1 / t ^ 2) := by
        apply mul_le_mul_of_nonneg_right
        · apply div_le_div_of_nonneg_right hnum hposA.le
        · exact hE
    _ ≤ d ^ 2 * (4 * t ^ 2 + 1 / 4) / t ^ 4 * Real.exp (1 / t ^ 2) := by
        apply mul_le_mul_of_nonneg_right
        · apply (div_le_div_iff_of_pos_left hDnum hposA hposT).mpr
          exact hABt4
        · exact hE
    _ = (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := by
        field_simp
        ring
/-- The combined 25n scale window: the definition-side kernel at its
    own point lands on the 4 d^2/t^2 scale with pinned O(1/t^2)
    relative correction. -/
theorem hMownScale (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 ≤ mown t d ∧
    mown t d ≤ (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) *
        Real.exp (1 / t ^ 2) :=
  ⟨hMownScaleLo t d ht hd0 hd, hMownScaleHi t d ht hd0 hd⟩
/-- The 25n scale: (4 d^2 / t^2) (1/4)^2 * exp 0 <= mown <= (4 d^2 / t^2) (1) (1)
    at the extremes — the sharp bound is proven numerically in 25n; the
    Lean atom certifies the exact form and the exp window. -/
theorem hMownExpWindow (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    1 <= Real.exp (Cown t d) ∧ Real.exp (Cown t d) <= Real.exp (1 / t ^ 2) :=
  hExpC t d ht hd0 hd

end S4O
