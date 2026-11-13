/-
Rh-missing-tail, D4 argument-principle line (ap4) -- the RvM main-term assembly
identity, in-house port.

Ported from https://github.com/anthropics/formal-math (the former
zeta-23-lean), commit e1a4e6508154, Apache License 2.0:
  * Copyright (c) 2026 Anthropic, PBC.
  * Copyright the PrimeNumberTheoremAnd contributors
    (https://github.com/AlexKontorovich/PrimeNumberTheoremAnd).
Provenance and license preserved per the project borrow rule; the port
is cited in formal/RH-LEAN-PROVENANCE.md.

Changes in this port (mechanical, per project convention):
  * `import Mathlib` (whole library) in place of per-file import
    lists;
  * content namespaced under `Ap2`;
  * intra-project imports redirected to RhAttack.Ap1*/Ap2*;
  * the Zeta23.Hypotheses import dropped where the part actually
    ported does not use the paper inputs (the definitions + the seam
    need no paper hypotheses).
-/
import Mathlib
import RhAttack.Ap3RvMDefs
import RhAttack.Ap3Hypotheses
-- H-Γ is the PROJECT's `Ap3.GammaFacts` (Ap3Hypotheses); the vendor Zeta23.Hypotheses
-- import was dropped 2026-11-04 to avoid two GammaFacts structures in one environment.
set_option linter.style.header false

namespace Ap3

open Ap2 Ap2.Zeta23 -- mu (Ap2Defs)


open Complex MeasureTheory Set
open scoped Interval

noncomputable section


/-- the open right half-plane -/
def rightHalfPlane : Set ℂ := {s : ℂ | 0 < s.re}

lemma isOpen_rightHalfPlane : IsOpen rightHalfPlane :=
  isOpen_lt continuous_const Complex.continuous_re

lemma Gamma_half_differentiableAt {s : ℂ} (hs : 0 < s.re) : DifferentiableAt ℂ Complex.Gamma (s / 2) := by
  apply Complex.differentiableAt_Gamma
  intro m h
  have := congrArg Complex.re h
  simp at this
  have : (0:ℝ) ≤ m := Nat.cast_nonneg m
  linarith

lemma Gammaℝ_differentiableOn : DifferentiableOn ℂ Complex.Gammaℝ rightHalfPlane := by
  intro s hs
  apply DifferentiableAt.differentiableWithinAt
  have h1 : DifferentiableAt ℂ (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) s := by
    apply DifferentiableAt.const_cpow (by fun_prop) (Or.inl (by exact_mod_cast Real.pi_ne_zero))
  have h2 : DifferentiableAt ℂ (fun s : ℂ => Complex.Gamma (s / 2)) s :=
    (Gamma_half_differentiableAt hs).comp s (by fun_prop)
  have : Complex.Gammaℝ = fun s => (Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2) := by
    funext s; rw [Complex.Gammaℝ_def]
  rw [this]
  exact h1.mul h2

lemma Gammaℝ_analyticOnNhd : AnalyticOnNhd ℂ Complex.Gammaℝ rightHalfPlane :=
  Gammaℝ_differentiableOn.analyticOnNhd isOpen_rightHalfPlane

/-- logDeriv Γℝ is holomorphic on Re s > 0. -/
lemma logDeriv_Gammaℝ_differentiableOn : DifferentiableOn ℂ (logDeriv Complex.Gammaℝ) rightHalfPlane := by
  have hA := Gammaℝ_analyticOnNhd
  have hd : DifferentiableOn ℂ (deriv Complex.Gammaℝ) rightHalfPlane := hA.deriv.differentiableOn
  have : logDeriv Complex.Gammaℝ = fun s => deriv Complex.Gammaℝ s / Complex.Gammaℝ s := by
    funext s; rfl
  rw [this]
  exact hd.div hA.differentiableOn fun s hs => Complex.Gammaℝ_ne_zero_of_re_pos hs

/-- logDeriv Γℝ(s) = −(log π)/2 + ½ ψ(s/2) on Re s > 0 (ψ = Complex.digamma = Γ'/Γ). -/
theorem logDeriv_Gammaℝ {s : ℂ} (hs : 0 < s.re) :
    logDeriv Complex.Gammaℝ s = -(Real.log Real.pi : ℂ) / 2 + (1/2 : ℂ) * Complex.digamma (s / 2) := by
  have hπ : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  have e : Complex.Gammaℝ = fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2) := by
    funext s; rw [Complex.Gammaℝ_def]
  have hf : (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) s ≠ 0 := by
    simp only [ne_eq, cpow_eq_zero_iff, hπ, false_and, not_false_eq_true]
  have hg : (fun s : ℂ => Complex.Gamma (s / 2)) s ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m h
    have := congrArg Complex.re h
    simp at this
    have : (0:ℝ) ≤ m := Nat.cast_nonneg m
    linarith
  have hdf : DifferentiableAt ℂ (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) s :=
    DifferentiableAt.const_cpow (by fun_prop) (Or.inl hπ)
  have hdg : DifferentiableAt ℂ (fun s : ℂ => Complex.Gamma (s / 2)) s :=
    (Gamma_half_differentiableAt hs).comp s (by fun_prop)
  rw [e, logDeriv_mul (f := fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) (g := fun s : ℂ => Complex.Gamma (s / 2)) s hf hg hdf hdg]
  -- first factor
  have h1 : logDeriv (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2)) s = -(Real.log Real.pi : ℂ) / 2 := by
    have hder : HasDerivAt (fun s : ℂ => (Real.pi : ℂ) ^ (-s / 2))
        ((Real.pi : ℂ) ^ (-s / 2) * Complex.log Real.pi * (-1 / 2)) s := by
      have : HasDerivAt (fun s : ℂ => -s / 2) (-1 / 2 : ℂ) s := by
        simpa using ((hasDerivAt_id s).neg.div_const (2:ℂ))
      exact this.const_cpow (Or.inl hπ)
    rw [logDeriv_apply, hder.deriv]
    have hne : (Real.pi : ℂ) ^ (-s / 2) ≠ 0 := hf
    rw [Complex.ofReal_log Real.pi_pos.le]
    field_simp
  -- second factor
  have h2 : logDeriv (fun s : ℂ => Complex.Gamma (s / 2)) s = (1/2 : ℂ) * Complex.digamma (s / 2) := by
    have := logDeriv_comp (f := Complex.Gamma) (g := fun s : ℂ => s / 2) (x := s)
      (Gamma_half_differentiableAt hs) (by fun_prop)
    rw [show (Complex.Gamma ∘ fun s : ℂ => s / 2) = fun s => Complex.Gamma (s / 2) from rfl] at this
    rw [this, Complex.digamma_def]
    have : deriv (fun s : ℂ => s / 2) s = 1 / 2 := by
      rw [deriv_div_const, deriv_id'']
    rw [this]; ring
  rw [h1, h2]

/-- on the critical line: Re(logDeriv Γℝ(½+it)) = π·μ(t). -/
theorem re_logDeriv_Gammaℝ_half (t : ℝ) :
    (logDeriv Complex.Gammaℝ (1/2 + t * I)).re = Real.pi * mu t := by
  rw [logDeriv_Gammaℝ (by simp)]
  have : ((1:ℂ)/2 + t * I) / 2 = 1 / 4 + Complex.I * t / 2 := by ring
  rw [this, mu]
  simp only [Complex.add_re, Complex.neg_re, Complex.div_ofNat_re, Complex.ofReal_re, Complex.mul_re,
    Complex.one_re]
  have hπ := Real.pi_ne_zero
  field_simp
  simp
  ring

/-- (M4) the Γ-side identity: for 0 < T₁ and any T₂,
(1/π)·Im(halfContour (logDeriv Γℝ) T₁ T₂) = ∫_{T₁}^{T₂} μ. -/
theorem gamma_side {T₁ T₂ : ℝ} (_h0 : 0 < T₁) (_h0' : 0 < T₂) :
    (1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) T₁ T₂).im = ∫ t in T₁..T₂, mu t := by
  set F := logDeriv Complex.Gammaℝ with hF
  -- Cauchy–Goursat on the rectangle [1/2, 2] × [T₁, T₂]
  have hrect : (Set.uIcc (1/2:ℝ) 2 ×ℂ Set.uIcc T₁ T₂) ⊆ rightHalfPlane := by
    rintro s ⟨hre, -⟩
    rw [Set.uIcc_of_le (by norm_num : (1/2:ℝ) ≤ 2)] at hre
    show 0 < s.re
    have := hre.1
    linarith [this]
  have hCG := Complex.integral_boundary_rect_eq_zero_of_differentiableOn F (1/2 + T₁ * I) (2 + T₂ * I)
    (logDeriv_Gammaℝ_differentiableOn.mono (by simpa using hrect))
  simp only [add_re, one_re, ofReal_re, mul_re, I_re, mul_zero, ofReal_im, I_im, mul_one, sub_self,
    add_zero, add_im, one_im, mul_im, zero_add, div_ofNat_re, div_ofNat_im, zero_div,
    re_ofNat, im_ofNat] at hCG
  have hhc : halfContour F T₁ T₂ = I * ∫ y : ℝ in T₁..T₂, F (1/2 + y * I) := by
    unfold halfContour
    have hthis := hCG
    simp only [smul_eq_mul] at hthis
    have hc : ((1/2 : ℝ) : ℂ) = (1/2 : ℂ) := by norm_num
    simp only [hc] at hthis
    -- bottom - top + I*right - I*left = 0
    linear_combination hthis
  rw [hhc, Complex.mul_im, Complex.I_re, Complex.I_im, zero_mul, one_mul, zero_add]
  -- Re ∫ = ∫ Re
  have hcont : Continuous fun y : ℝ => F (1/2 + y * I) := by
    have hd := logDeriv_Gammaℝ_differentiableOn
    have : Continuous fun y : ℝ => ((1:ℂ)/2 + y * I) := by fun_prop
    refine (hd.continuousOn.comp_continuous this fun y => ?_)
    show 0 < ((1:ℂ)/2 + y * I).re
    simp
  rw [show ((∫ y : ℝ in T₁..T₂, F (1/2 + y * I)).re) = ∫ y : ℝ in T₁..T₂, (F (1/2 + y * I)).re from
    (Complex.reCLM.intervalIntegral_comp_comm (hcont.intervalIntegrable _ _)).symm]
  simp_rw [hF, re_logDeriv_Gammaℝ_half]
  rw [intervalIntegral.integral_const_mul]
  field_simp

/-! ### helpers for the assembly -/

/-- μ is continuous (given H-Γ's smoothness field). -/
theorem mu_continuous (hΓ : GammaFacts) : Continuous mu :=
  hΓ.smooth.continuous

/-- |μ(τ)| ≪ log(τ+3) for τ ≥ 1, from H-Γ's Stirling field. -/
theorem mu_le_log (hΓ : GammaFacts) : ∃ C : ℝ, 0 < C ∧ ∀ τ : ℝ, 1 ≤ τ →
    |mu τ| ≤ C * Real.log (τ + 3) := by
  obtain ⟨C₀, hC₀⟩ := hΓ.stirling
  have hlog2π : 0 ≤ Real.log (2 * Real.pi) :=
    Real.log_nonneg (by nlinarith [Real.pi_gt_three])
  refine ⟨1 + |C₀| + Real.log (2 * Real.pi),
    by linarith [abs_nonneg C₀], fun τ hτ => ?_⟩
  have hτ0 : (0:ℝ) < τ := by linarith
  have h1 := hC₀ τ (by rw [abs_of_pos hτ0]; exact hτ)
  rw [abs_of_pos hτ0] at h1
  obtain ⟨hl, hr⟩ := abs_le.mp h1
  have hlog3 : 1 ≤ Real.log (τ + 3) := by
    rw [← Real.log_exp 1]
    apply Real.log_le_log (Real.exp_pos 1)
    have := Real.exp_one_lt_d9; linarith
  have hlogτ0 : 0 ≤ Real.log τ := Real.log_nonneg hτ
  have hlogτ : Real.log τ ≤ Real.log (τ + 3) := Real.log_le_log hτ0 (by linarith)
  have hdiv : Real.log (τ / (2 * Real.pi)) = Real.log τ - Real.log (2 * Real.pi) :=
    Real.log_div (by linarith) (by positivity)
  rw [hdiv] at hl hr
  have hC₀τ : |C₀ / τ ^ 2| ≤ |C₀| := by
    rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < τ ^ 2)]
    apply div_le_self (abs_nonneg _) (by nlinarith)
  obtain ⟨hCl, hCr⟩ := abs_le.mp hC₀τ
  have h2π : 1 / (2 * Real.pi) ≤ 1 := by
    rw [div_le_one (by positivity)]; nlinarith [Real.pi_gt_three]
  have h2π0 : 0 < 1 / (2 * Real.pi) := by positivity
  have hlog2πp : 0 < Real.log (2 * Real.pi) := Real.log_pos (by linarith [Real.pi_gt_three])
  set L := Real.log (2 * Real.pi) with hLdef
  have hC1 : 0 < 1 + |C₀| + L := by linarith [abs_nonneg C₀, hlog2π]
  have hbig : (1 + |C₀| + L) * Real.log (τ + 3) ≥ 1 + |C₀| + L := by
    simpa [mul_one] using mul_le_mul_of_nonneg_left hlog3 hC1.le
  rw [abs_le]
  constructor
  · -- lower bound: mu τ ≥ (1/2π)(log τ − log 2π) − C₀/τ² ≥ −(…)·log(τ+3)
    have e1 : -L ≤ 1 / (2 * Real.pi) * (Real.log τ - L) := by
      nlinarith [hlogτ0, hlog2πp, h2π0, Real.pi_gt_three]
    have hnegC : -(1 + |C₀| + L) * Real.log (τ + 3) ≤ -(1 + |C₀| + L) := by
      have hm : (-(1 + |C₀| + L)) * Real.log (τ + 3) ≤ (-(1 + |C₀| + L)) * 1 :=
        mul_le_mul_of_nonpos_left hlog3 (by linarith)
      simpa [mul_one] using hm
    have hmid : -(1 + |C₀| + L) ≤ -L - |C₀| := by linarith
    have hnegc : -|C₀| ≤ -(C₀ / τ ^ 2) := by linarith [hCr]
    have hlow : -L - |C₀| ≤ 1 / (2 * Real.pi) * (Real.log τ - L) - C₀ / τ ^ 2 := by
      nlinarith [e1, hnegc]
    have hhl : 1 / (2 * Real.pi) * (Real.log τ - L) - C₀ / τ ^ 2 ≤ Zeta23.mu τ := by
      linarith [hl]
    have hgoal : -((1 + |C₀| + L) * Real.log (τ + 3)) ≤
        1 / (2 * Real.pi) * (Real.log τ - L) - C₀ / τ ^ 2 := by
      rw [← neg_mul]
      exact le_trans hnegC (le_trans hmid hlow)
    exact le_trans hgoal hhl
  · have hstep : 1 / (2 * Real.pi) * (Real.log τ - L) ≤ Real.log τ := by
      have hnc : (1 : ℝ) / (2 * Real.pi) ≠ 0 := h2π0.ne'
      field_simp [hnc]
      nlinarith [hlogτ0, hlog2πp, Real.pi_gt_three]
    have hXle : 1 / (2 * Real.pi) * (Real.log τ - L) ≤ Real.log (τ + 3) := le_trans hstep hlogτ
    have hR1 : Zeta23.mu τ ≤ Real.log (τ + 3) + |C₀| := by
      have hhr : Zeta23.mu τ ≤ 1 / (2 * Real.pi) * (Real.log τ - L) + C₀ / τ ^ 2 := by
        linarith [hr]
      nlinarith [hXle, hCr]
    have hRC : |C₀| ≤ |C₀| * Real.log (τ + 3) := by
      simpa [mul_one] using mul_le_mul_of_nonneg_left hlog3 (abs_nonneg C₀)
    have hRL : L ≤ L * Real.log (τ + 3) := by
      simpa [mul_one] using mul_le_mul_of_nonneg_left hlog3 hlog2π
    have hA2nn : 0 ≤ L * Real.log (τ + 3) := mul_nonneg hlog2π (by linarith)
    have hR2 : Real.log (τ + 3) + |C₀| ≤ (1 + |C₀| + L) * Real.log (τ + 3) := by
      have hA : Real.log (τ + 3) + |C₀| ≤ Real.log (τ + 3) + |C₀| * Real.log (τ + 3) := by
        calc Real.log (τ + 3) + |C₀| = |C₀| + Real.log (τ + 3) := by ring
         _ ≤ |C₀| * Real.log (τ + 3) + Real.log (τ + 3) := add_le_add_left hRC (Real.log (τ + 3))
         _ = Real.log (τ + 3) + |C₀| * Real.log (τ + 3) := by ring
      have hB : Real.log (τ + 3) + |C₀| * Real.log (τ + 3) ≤
          Real.log (τ + 3) + |C₀| * Real.log (τ + 3) + L * Real.log (τ + 3) :=
        le_add_of_nonneg_right hA2nn
      have hC : (1 + |C₀| + L) * Real.log (τ + 3) =
          Real.log (τ + 3) + |C₀| * Real.log (τ + 3) + L * Real.log (τ + 3) := by ring
      simpa [hC] using le_trans hA hB
    exact le_trans hR1 hR2

end
end Ap3
