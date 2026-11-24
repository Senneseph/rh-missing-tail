import Mathlib
import RhAttack.OnlineZetaFE

open Set Complex Real
open BigOperators

set_option maxHeartbeats 40000

namespace OnlineZetaGamma

/-
honline Phase 1c continued: the exact Gamma identity on the critical line.

The functional-equation transport in `OnlineZetaFE` (`zetaFEtransport` /
`zetaTailTransportLeft`) carries the explicit right-side Dirichlet-series
tail bound to the left of the critical line; its constants involve
`‖Γ(1 - s)‖`. On the critical line itself, Euler's reflection formula
`Γ s · Γ(1 - s) = π / sin(π s)` (Mathlib, unconditional) together with
`Γ(conj s) = conj(Γ s)` (Mathlib) pins the Gamma factor EXACTLY:

    ‖Γ(1/2 + it)‖ = sqrt(π / cosh(π t))

with the classical decay corollary

    ‖Γ(1/2 + it)‖ ≤ sqrt(2π) · e^{-π|t|/2}.

These are the constants the disk-count machinery (Phase 3) uses to control
the completed zeta on a circle about the first zero.

NO RH CLAIM: pure identity + estimate for the complex Gamma function.
NO NEW AXIOMS. Machine-checked against the pinned Mathlib v4.33.1.
-/

/-- `‖star z‖ = ‖z‖` for `z : ℂ` (via the normSq bridge). -/
theorem normStar (z : ℂ) : ‖star z‖ = ‖z‖ := by
  have hre : (star z).re = z.re := by simp
  have him : (star z).im = -z.im := by simp
  have hsq : ‖star z‖ * ‖star z‖ = ‖z‖ * ‖z‖ := by
    rw [Complex.norm_mul_self_eq_normSq, Complex.normSq_apply,
        Complex.norm_mul_self_eq_normSq, Complex.normSq_apply]
    rw [hre, him]
    ring
  have ha : 0 ≤ ‖star z‖ := norm_nonneg _
  have hb : 0 ≤ ‖z‖ := norm_nonneg _
  nlinarith

/-- `sin(π(1/2 + it)) = cosh(π t)` (real-valued). -/
theorem sinPiHalfAddImulI (t : ℝ) :
    Complex.sin (Real.pi * ((1 / 2 : ℂ) + t * I)) = (Real.cosh (Real.pi * t) : ℂ) := by
  have harg : Real.pi * ((1 / 2 : ℂ) + t * I) = (Real.pi / 2 : ℂ) + (Real.pi * t) * I := by ring
  have hnorm : (Real.pi / 2 : ℂ) = (Real.pi / 2 : ℝ) := (Complex.ofReal_div Real.pi 2).symm
  rw [harg, hnorm, Complex.sin_add_mul_I (Real.pi / 2 : ℝ) ((Real.pi : ℂ) * (t : ℂ))]
  rw [← Complex.ofReal_mul, ← Complex.ofReal_sin (Real.pi / 2),
      ← Complex.ofReal_cos (Real.pi / 2), ← Complex.ofReal_cosh (Real.pi * t),
      ← Complex.ofReal_sinh (Real.pi * t)]
  norm_num [Real.sin_pi_div_two, Real.cos_pi_div_two]

/-- The exact modulus of the Gamma function on the critical line:
`‖Γ(1/2 + it)‖ = sqrt(π / cosh(π t))`. -/
theorem gammaHalfItExact (t : ℝ) :
    ‖Complex.Gamma ((1 / 2 : ℂ) + t * I)‖ = Real.sqrt (Real.pi / Real.cosh (Real.pi * t)) := by
  set s : ℂ := (1 / 2 : ℂ) + t * I with hs
  have hpos : 0 < Real.cosh (Real.pi * t) := by
    rw [Real.cosh_eq]
    exact div_pos (add_pos (Real.exp_pos _) (Real.exp_pos _)) (by norm_num)
  have hhalf_re : (1 / 2 : ℂ).re = 1 / 2 := by
    rw [Complex.div_re (1 : ℂ) 2]
    norm_num
  have hhalf_im : (1 / 2 : ℂ).im = 0 := by
    rw [Complex.div_im (1 : ℂ) 2]
    norm_num
  have hIre : (t * I).re = 0 := by
    simp [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  have hIim : (t * I).im = t := by
    simp [Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im]
  have hz : (1 / 2 : ℂ) + t * I = Complex.mk (1 / 2 : ℝ) t := by
    apply Complex.ext
    · rw [Complex.add_re, hhalf_re, hIre, add_zero]
    · rw [Complex.add_im, hhalf_im, hIim, zero_add]
  have hstararg : (1 - s : ℂ) = star s := by
    dsimp only [s]
    rw [hz]
    apply Complex.ext
    <;> (simp [Complex.sub_re, Complex.sub_im] <;> try norm_num)
  have hstarG : Complex.Gamma (1 - s) = star (Complex.Gamma s) := by
    rw [hstararg]
    change Complex.Gamma ((starRingEnd ℂ) s) = (starRingEnd ℂ) (Complex.Gamma s)
    rw [Complex.Gamma_conj]
  have hsin : Complex.sin (Real.pi * s) = (Real.cosh (Real.pi * t) : ℂ) := by
    dsimp only [s]
    exact sinPiHalfAddImulI t
  have hmain : Complex.Gamma s * star (Complex.Gamma s) =
      ((Real.pi / Real.cosh (Real.pi * t) : ℝ) : ℂ) := by
    calc
      _ = Complex.Gamma s * Complex.Gamma (1 - s) := by rw [(hstarG).symm]
      _ = Real.pi / Complex.sin (Real.pi * s) := Complex.Gamma_mul_Gamma_one_sub s
      _ = ((Real.pi / Real.cosh (Real.pi * t) : ℝ) : ℂ) := by
        rw [hsin, ← Complex.ofReal_div]
  have hprod : Complex.Gamma s * star (Complex.Gamma s) = ((‖Complex.Gamma s‖ : ℂ) ^ 2) := by
    have h1 : Complex.Gamma s * star (Complex.Gamma s) =
        (Complex.normSq (Complex.Gamma s) : ℂ) := by
      apply Complex.ext
      <;> (simp [Complex.mul_re, Complex.mul_im, Complex.normSq_apply,
              Complex.ofReal_re, Complex.ofReal_im]
          <;> ring)
    have h2 : (Complex.normSq (Complex.Gamma s) : ℂ) =
        ((‖Complex.Gamma s‖ * ‖Complex.Gamma s‖) : ℝ) := by
      exact (Complex.ofReal_inj).mpr (Complex.norm_mul_self_eq_normSq _).symm
    have h3 : ((‖Complex.Gamma s‖ * ‖Complex.Gamma s‖) : ℝ) =
        ((‖Complex.Gamma s‖ : ℂ) * (‖Complex.Gamma s‖ : ℂ)) :=
      Complex.ofReal_mul _ _
    have h4 : ((‖Complex.Gamma s‖ : ℂ) * (‖Complex.Gamma s‖ : ℂ)) =
        ((‖Complex.Gamma s‖ : ℂ) ^ 2) := by
      rw [pow_two]
    exact h1.trans (h2.trans (h3.trans h4))
  have hsq : ‖Complex.Gamma s‖ ^ 2 = Real.pi / Real.cosh (Real.pi * t) := by
    have heq : ((‖Complex.Gamma s‖ : ℂ) ^ 2) =
        ((Real.pi / Real.cosh (Real.pi * t) : ℝ) : ℂ) :=
      (hprod.symm).trans hmain
    have heq2 : ((‖Complex.Gamma s‖ * ‖Complex.Gamma s‖) : ℝ) =
        ((Real.pi / Real.cosh (Real.pi * t) : ℝ) : ℂ) := by
      rw [pow_two, ← Complex.ofReal_mul] at heq
      exact heq
    rw [pow_two]
    exact Complex.ofReal_inj.1 heq2
  have hfinal : Real.sqrt (Real.pi / Real.cosh (Real.pi * t)) = ‖Complex.Gamma s‖ :=
    (Real.sqrt_eq_iff_eq_sq
        (div_nonneg Real.pi_pos.le (le_of_lt hpos)) (norm_nonneg _)).mpr hsq.symm
  exact hfinal.symm

/-- `cosh x ≥ e^|x| / 2`. -/
theorem cosh_ge_expabs_half (x : ℝ) : Real.cosh x ≥ Real.exp |x| / 2 := by
  cases le_total 0 x with
  | inl hx0 =>
    rw [abs_of_nonneg hx0, Real.cosh_eq]
    gcongr
    <;> linarith [Real.exp_pos (-x)]
  | inr hx0 =>
    have h1 : Real.cosh (-x) ≥ Real.exp (-x) / 2 := by
      rw [Real.cosh_eq]
      gcongr
    <;> linarith [Real.exp_pos (-(-x))]
    rw [← Real.cosh_neg, abs_of_nonpos hx0]
    exact h1

/-- Decay estimate: `‖Γ(1/2 + it)‖ ≤ sqrt(2π) · e^{-π|t|/2}`. -/
theorem gammaHalfItDecay (t : ℝ) :
    ‖Complex.Gamma ((1 / 2 : ℂ) + t * I)‖ ≤
      Real.sqrt (2 * Real.pi) * Real.exp (-(Real.pi * |t|) / 2) := by
  rw [gammaHalfItExact]
  set A : ℝ := Real.pi * |t| with hA
  apply (Real.sqrt_le_iff).2
  constructor
  · apply mul_nonneg
    · exact Real.sqrt_nonneg _
    · exact le_of_lt (Real.exp_pos _)
  · have hApos : 0 < Real.exp A := Real.exp_pos _
    have hx : 0 < Real.cosh (Real.pi * t) := by
      rw [Real.cosh_eq]
      exact div_pos (add_pos (Real.exp_pos _) (Real.exp_pos _)) (by norm_num)
    have hc : Real.cosh (Real.pi * t) ≥ Real.exp A / 2 := by
      have habs : |Real.pi * t| = Real.pi * |t| := by
        rw [abs_mul, abs_of_pos Real.pi_pos]
      simpa [habs] using (cosh_ge_expabs_half (Real.pi * t))
    have hhalf : 0 < Real.exp A / 2 := div_pos hApos (by norm_num)
    have hinv : 1 / Real.cosh (Real.pi * t) ≤ 2 * Real.exp (-A) := by
      have hstep : 1 / Real.cosh (Real.pi * t) ≤ 1 / (Real.exp A / 2) := by
        rw [one_div_le_one_div hx hhalf]
        exact hc
      have hstep2 : 1 / (Real.exp A / 2) = 2 * Real.exp (-A) := by
        calc
          1 / (Real.exp A / 2) = 2 / Real.exp A := by field_simp
          _ = 2 * (Real.exp A)⁻¹ := by field_simp
          _ = 2 * Real.exp (-A) := by rw [Real.exp_neg A]
      rw [hstep2] at hstep
      exact hstep
    calc
      Real.pi / Real.cosh (Real.pi * t) = Real.pi * (1 / Real.cosh (Real.pi * t)) := by
        field_simp
      _ ≤ Real.pi * (2 * Real.exp (-A)) :=
        mul_le_mul_of_nonneg_left hinv Real.pi_pos.le
      _ = 2 * Real.pi * Real.exp (-A) := by ring
      _ = 2 * Real.pi * Real.exp (-A / 2) ^ 2 := by
        rw [congrArg Real.exp (show -A = (-A / 2) + (-A / 2) by ring),
            Real.exp_add (-A / 2) (-A / 2), ← pow_two]
      _ = (Real.sqrt (2 * Real.pi) * Real.exp (-A / 2)) ^ 2 := by
        rw [mul_pow, Real.sq_sqrt (by linarith [Real.pi_pos])]
        try ring

end OnlineZetaGamma
