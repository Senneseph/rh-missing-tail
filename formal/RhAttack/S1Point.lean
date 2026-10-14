/-
Rh-missing-tail, D4 argument-principle line (ap5) -- the POINT-scale
Riemann--von Mangoldt formula with O(log T) error, proved in-repo.

NEW in-repo theorem (no external source).  Built entirely from the
ported ap1-ap4 machinery plus mathlib at the pinned rev:

    N(T) = T/(2pi)·(log(T/2pi) - 1) + O(log T)      (T >= T0, good height T)

where N(T) = #{nontrivial zeros 0 < Im <= T} (with multiplicity).
Classical reference: Backlund (1918) / Titchmarsh Thm 9.4 at the
point scale.  Every analytic input below is a theorem already proved
in this repo:

  * winding identity       Ncount_eq_im_halfContour         (ported ap2)
  * half-contour split     halfContour_completedZeta_split  (ported ap3)
  * Gamma side = int mu    gamma_side                       (ported ap3)
  * Stirling form of mu    GammaFacts.stirling              (discharged, ap3)
  * horizontal zeta bound  backlund_horizontal_at           (ported ap3)
  * vertical zeta bound    vertical_two                     (ported ap3)

One named input remains, trivial numerically but not decidable in
Lean:  C9NoZerosLow -- no nontrivial zero on 0 < Im <= 4  (first
zero at 14.134725...;  project data layer,
results/certified-zero-survey.md).

Uses:
  * rebase of the wire input CITED as A1G-6 (the "classical
    Backlund O(log t)" behind the hSbound premise):
    `rebase_a1g6_dn_form`.
  * Lean quantification of the E19 flat clause: the point defect
    N(T) - f_pt T is itself the zero-scale S defect;  bounded by
    O(log T) uniformly, while Inoue-Kobayashi-Toma arXiv:2510.14309
    shows (under RH) that S must oscillate by (1-o(1))·sqrt(h log
    T / pi) at zero scale h -- so the flat-at-zeros clause, if true,
    is an S-insensitivity property of the certificate, not a
    smallness of S (VALIANT-EFFORT-FORENSICS 3.10).

License: Apache-2.0, in-house (no borrow;  the provenance of the
ported lemmas is in their own headers, formal/RH-LEAN-PROVENANCE.md).
-/
import Mathlib
import RhAttack.Ap3MainTerm
import RhAttack.Ap3Fold
import RhAttack.Ap3Backlund
import RhAttack.Ap3GammaSide
import RhAttack.Ap3Hypotheses
import RhAttack.Ap3GammaComplete
set_option linter.style.header false

namespace S1B

open Ap3
open Ap2

noncomputable section

open MeasureTheory intervalIntegral in

/-- Point-scale main term:  f(T) = T/(2pi)·(log(T/2pi) - 1). -/
def f_pt (T : ℝ) : ℝ := T / (2 * Real.pi) * (Real.log (T / (2 * Real.pi)) - 1)

/-- **C9** (named input, trivial numerically): no nontrivial zero on
    0 < Im <= 4.  (First zero 14.134725...,  data layer.) -/
def C9NoZerosLow : Prop := ∀ ρ : ℂ, IsNontrivialZero ρ → ¬(0 < ρ.im ∧ ρ.im ≤ 4)

/-- C9 gives GoodHeight 4. -/
theorem C9_goodHeight_4 (hC9 : C9NoZerosLow) : GoodHeight 4 :=
  fun ρ hρ hh => hC9 ρ hρ ⟨by norm_num, by norm_num⟩ hh

/-- The Jensen-count constant of `backlund_horizontal_at`. -/
def CJ := (1 / Real.log ((0.9 : ℝ) / 0.8) * (|Real.log (6 * (20 / 3 : ℝ))| + 2)) + 1

/-! ## The mu integral at the point scale -/

/-- FTC anchor:  ∫_4^T (1/2pi)·log(τ/2pi) dτ = f_pt T - f_pt 4. -/
theorem int_log_point (hT : 4 ≤ T) :
    (∫ τ in (4 : ℝ)..T, (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))) =
      f_pt T - f_pt 4 := by
  set F := fun x : ℝ => (1 / (2 * Real.pi)) * (x * Real.log (x / (2 * Real.pi)) - x) with hF
  have hFpt : ∀ x : ℝ, 0 < x → F x = f_pt x := by
    intro x hx
    unfold f_pt F
    ring
  have hftc : ∀ τ ∈ Set.uIcc 4 T,
      HasDerivAt F ((1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))) τ := by
    intro τ hτ
    have hτ0 : (0 : ℝ) < τ := by
      rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
      linarith [hτ.1]
    set h := 2 * Real.pi with hh
    have hhp : 0 < h := by nlinarith [Real.pi_pos]
    have h1 : HasDerivAt (fun x : ℝ => x / h) (1 / h) τ := (hasDerivAt_id τ).div_const h
    have h2 : HasDerivAt (fun x : ℝ => Real.log (x / h)) ((x / h)⁻¹ * (1 / h)) τ := by
      have h3 := (Real.hasDerivAt_log (by positivity : x / h ≠ 0)).comp x (by
        simpa using (hasDerivAt_id x).div_const h)
      convert h3 using 1
      have h4 : 1 / h / (x / h) = (x / h)⁻¹ * (1 / h) := by field_simp
      rw [h4]
    have h4 : HasDerivAt (fun x : ℝ => x * Real.log (x / h))
        (Real.log (x / h) + x * ((x / h)⁻¹ * (1 / h))) τ := h1.mul h2
    have h5 : Real.log (x / h) + x * ((x / h)⁻¹ * (1 / h)) = Real.log (x / h) + 1 := by
      field_simp
      ring
    have h6 := (h4.sub (hasDerivAt_id τ)).const_mul (1 / h)
    rw [h5] at h6
    have h7 : (Real.log (x / h) + 1) - 1 = Real.log (x / h) := by ring
    rw [h7] at h6
    simpa [hF] using h6
  have hcont : IntervalIntegrable
      (fun τ : ℝ => (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))) volume 4 T := by
    apply ContinuousOn.intervalIntegrable
    intro τ hτ
    have hτ0 : (0 : ℝ) < τ := by
      rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
      linarith [hτ.1]
    exact ((Real.continuousAt_log (by positivity)).comp
      (continuousAt_id.div_const _)).continuousWithinAt
  rw [integral_eq_sub_of_hasDerivAt hftc hcont]
  rw [hFpt T (by linarith [show (0 : ℝ) < 4 from by norm_num, hT]),
      hFpt 4 (by norm_num : (0 : ℝ) < 4)]

/-- Direct integration of the Stirling field (no dyadic telescoping):
    ∃ K > 0, ∀ T ≥ 4,  |∫_4^T μ - (f_pt T - f_pt 4)| ≤ K. -/
theorem int_mu_point_form (hΓ : GammaFacts) :
    ∃ K : ℝ, 0 < K ∧ ∀ T : ℝ, 4 ≤ T →
      |(∫ τ in (4 : ℝ)..T, mu τ) - (f_pt T - f_pt 4)| ≤ K := by
  obtain ⟨C0, hC0⟩ := hΓ.stirling
  have hC0n : 0 ≤ C0 := by
    by_contra hneg
    push_neg at hneg
    have h4 : (1 : ℝ) ≤ |(4 : ℝ)| := by norm_num
    have hb := hC0 4 h4
    have hneg2 : C0 / (4 : ℝ) ^ 2 < 0 := by
      have hsq : (0 : ℝ) < (4 : ℝ) ^ 2 := by norm_num
      rw [div_neg_iff hsq]
      exact ⟨hneg, by linarith⟩
    nlinarith [abs_nonneg (mu 4 - (1 / (2 * Real.pi)) * Real.log (|(4 : ℝ)| / (2 * Real.pi)))]
  have hμcont : Continuous mu := hΓ.smooth.continuous
  refine ⟨C0 + 1, by linarith [hC0n], fun T hT => ?_⟩
  have hμ : IntervalIntegrable mu volume 4 T := hμcont.intervalIntegrable _ _
  have hlog : IntervalIntegrable
      (fun τ : ℝ => (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))) volume 4 T := by
    apply ContinuousOn.intervalIntegrable
    intro τ hτ
    have hτ0 : (0 : ℝ) < τ := by
      rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
      linarith [hτ.1]
    exact ((Real.continuousAt_log (by positivity)).comp
      (continuousAt_id.div_const _)).continuousWithinAt
  have hsplit : (∫ τ in (4 : ℝ)..T, mu τ) =
      (∫ τ in (4 : ℝ)..T, (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi)))
      + ∫ τ in (4 : ℝ)..T, (mu τ - (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))) := by
    rw [← integral_add hlog (hμ.sub hlog)]
    funext τ
    ring
  rw [hsplit, int_log_point hT]
  ring_nf
  calc
    |∫ τ in (4 : ℝ)..T, (mu τ - (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi)))| ≤
        ∫ τ in (4 : ℝ)..T,
            |(mu τ - (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi)))| :=
      norm_integral_le_integral_norm (hμ.sub hlog)
    _ ≤ ∫ τ in (4 : ℝ)..T, (C0 / τ ^ 2) := by
      have hconterr : Continuous fun τ : ℝ =>
          |(mu τ - (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi)))| := by
        fun_prop
      have hbd : ∀ τ ∈ Set.Icc 4 T,
          |mu τ - (1 / (2 * Real.pi)) * Real.log (τ / (2 * Real.pi))| ≤ C0 / τ ^ 2 := by
        intro τ hτ
        have hτ4 : (4 : ℝ) ≤ τ := by
          rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
          exact hτ.1
        have hτ1 : (1 : ℝ) ≤ |τ| := by
          rw [abs_of_nonneg (le_of_lt (by linarith [hτ4]))]
          norm_num
        have hC0τ := hC0 τ hτ1
        have habsτ : |τ| = τ := by rw [abs_of_nonneg (le_of_lt (by linarith [hτ4]))]
        simpa [habsτ] using hC0τ
      exact integral_mono_on (hconterr.intervalIntegrable _ _) (fun τ hτ => hbd τ hτ) (by
        intro τ hτ
        have hτ0 : (0 : ℝ) < τ := by
          rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
          linarith [hτ.1]
        exact (ContinuousOn.pow (hτ0.continuousAt_log.not_eq_zero).continuousWithinAt 2)
          .continuousWithinAt |>.div_const (0 : ℝ))
    _ ≤ C0 / 4 := by
      have hmul : (∫ τ in (4 : ℝ)..T, (C0 / τ ^ 2)) = C0 * (∫ τ in (4 : ℝ)..T, 1 / τ ^ 2) := by
        rw [integral_const_mul]
        funext τ
        ring
      rw [hmul]
      have hinv : (∫ τ in (4 : ℝ)..T, (1 / τ ^ 2 : ℝ)) ≤ 1 / 4 := by
        have hant : ∀ τ : ℝ, 0 < τ → HasDerivAt (fun x : ℝ => -1 / x) (-1 / x ^ 2) τ := by
          intro τ hτ
          have hd : HasDerivAt (fun x : ℝ => 1 / x) (-1 / x ^ 2) τ := by
            simpa [pow_two] using (hasDerivAt_id τ).inv hτ
          exact hd.const_mul (-1 : ℝ)
        have hint : IntervalIntegrable (fun τ : ℝ => 1 / τ ^ 2) volume 4 T := by
          apply ContinuousOn.intervalIntegrable
          intro τ hτ
          have hτ0 : (0 : ℝ) < τ := by
            rw [Set.uIcc_of_le (by norm_num : (4 : ℝ) ≤ T)] at hτ
            linarith [hτ.1]
          exact (ContinuousOn.pow hτ0.continuousAt_log.not_eq_zero.continuousWithinAt 2)
            .continuousWithinAt
        by_cases hTe : T = 4
        · rw [hTe, intervalIntegral.integral_same]
          norm_num
        have hTl : 4 < T := lt_of_le_of_ne hT (Ne.symm hTe)
        have hFTC := integral_eq_sub_of_hasDerivAt
            (fun τ hτ => hant τ (by
              rw [Set.uIcc_of_le (by norm_num)] at hτ
              linarith [hτ.1])) hint
        have h2 : (∫ τ in (4 : ℝ)..T, (1 / τ ^ 2 : ℝ)) = (1 / 4) - 1 / T := by
          convert hFTC using 1
          field_simp
          ring
        rw [h2]
        have hpos : 0 < 1 / T := by positivity
        nlinarith
      exact mul_le_mul_of_nonneg_left hinv (by linarith [hC0n])
    _ ≤ C0 + 1 := by linarith [hC0n]

/-! ## The zeta part of the half-contour -/

/-- The zeta part of the half-contour [4, T] is O(log T) in imaginary
    part.  (Both horizontal sides by Backlund at the explicit Jensen
    constant CJ;  the vertical side sigma = 2 by vertical_two.) -/
theorem hc_zeta_im_bound (hC9 : C9NoZerosLow) :
    ∃ C T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → GoodHeight T →
      |(halfContour (logDeriv riemannZeta) 4 T).im| ≤ C * Real.log T := by
  set C0 := 2 * Real.pi * CJ with hC0d
  set C1 := 2 * C0 + Real.pi with hC1d
  have hCJpos : 0 < CJ := by
    unfold CJ
    positivity
  have hlog4pos : 0 < Real.log 4 := Real.log_pos (by norm_num : (1 : ℝ) < 4)
  refine ⟨C1 / Real.log 4, max 4 3, fun T hT hgT => ?_⟩
  have hT4 : (4 : ℝ) ≤ T := (le_max_right _ _).trans hT
  have hTb : |(∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + 4 * I)).im| ≤
      C0 * Real.log 4 := by
    simpa [hC0d] using backlund_horizontal_at 4 (by norm_num) (C9_goodHeight_4 hC9)
  have hTt : |(∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + T * I)).im| ≤
      C0 * Real.log T := by
    simpa [hC0d] using backlund_horizontal_at T (by
      simpa using (le_max_left _ _).trans hT) hgT
  have hr : |(∫ t in (4 : ℝ)..T, logDeriv riemannZeta (2 + t * I) * I).im| ≤ Real.pi :=
    vertical_two 4 T
  unfold halfContour
  set A := (∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + 4 * I)) with hA
  set B := (∫ t in (4 : ℝ)..T, logDeriv riemannZeta (2 + t * I)) with hB
  set Cc := (∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + T * I)) with hCc
  have htri : |(A + B * I - Cc).im| ≤ A.im.nabs + (B * I).im.nabs + Cc.im.nabs := by
    set a := A.im with ha
    set b := (B * I).im with hb
    set c := Cc.im with hc
    have h1 : (A + B * I - Cc).im = a + b - c := by simp
    rw [h1]
    calc
      |a + b - c| = |a + (b - c)| := by ring
      _ ≤ |a| + |b - c| := abs_add _ _
      _ ≤ |a| + |b| + |c| := by
        calc
          |a| + |b - c| ≤ |a| + (|b| + |c|) := by gcongr <;> simpa using abs_sub _ _
          _ = |a| + |b| + |c| := by ring
  have hBim : (B * I).im.nabs ≤ Real.pi := by
    have hFint : IntervalIntegrable (fun t : ℝ => logDeriv riemannZeta (2 + t * I))
        volume 4 T := continuous_logDeriv_riemannZeta_two.intervalIntegrable _ _
    have heq : B * I = (∫ t in (4 : ℝ)..T, (logDeriv riemannZeta (2 + t * I)) * I) := by
      rw [hB]
      have hlin : (∫ t in (4 : ℝ)..T, (logDeriv riemannZeta (2 + t * I)) * I) =
          I * (∫ t in (4 : ℝ)..T, logDeriv riemannZeta (2 + t * I)) := by
        rw [← integral_const_mul hFint]
        ring_nf
      rw [hlin, mul_comm]
    rw [heq]
    exact hr
  calc
    |(∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + 4 * I)) +
        (∫ t in (4 : ℝ)..T, logDeriv riemannZeta (2 + t * I)) * I -
        ∫ σ in (1 / 2 : ℝ)..2, logDeriv riemannZeta (σ + T * I)|
        .im ≤ A.im.nabs + (B * I).im.nabs + Cc.im.nabs := htri
    _ ≤ C0 * Real.log 4 + Real.pi + C0 * Real.log T := by gcongr <;>
      (try simpa using hTb) <;> (try simpa using hTt) <;> (try simpa using hBim)
    _ ≤ (2 * C0 + Real.pi) * Real.log T := by
      have hlogT : Real.log 4 ≤ Real.log T := Real.log_le_log (by positivity) (by linarith [hT4])
      have h1 : C0 * Real.log 4 ≤ C0 * Real.log T :=
        mul_le_mul_of_nonneg_left hlogT (by nlinarith [Real.pi_pos])
      have h2 : Real.pi ≤ Real.pi * Real.log T := by
        have h3 : 1 ≤ Real.log T := by
          have hlog2p : Real.log 10 ≥ 2 := by
            have hexp2 : Real.exp 2 ≤ 10 := by
              have h2e : Real.exp 2 = Real.exp 1 * Real.exp 1 := by
                rw [show (2 : ℝ) = 1 + 1, Real.exp_add]
                ring
              rw [h2e]
              have he := Real.exp_one_lt_d9
              nlinarith
            have hlog2p' : (2 : ℝ) = Real.log (Real.exp 2) := (Real.log_exp 2).symm
            rw [hlog2p']
            exact Real.log_le_log (by positivity) hexp2
          nlinarith [hlog2p]
        nlinarith [Real.pi_pos]
      nlinarith [h1, h2]
    _ ≤ C1 / Real.log 4 * Real.log T := by
      have hnn : 0 ≤ C1 := by nlinarith [Real.pi_pos]
      have hlt : Real.log 4 ≤ Real.log T := Real.log_le_log (by positivity) (by linarith [hT4])
      calc
        (2 * C0 + Real.pi) * Real.log T = C1 * Real.log T := by rw [hC1d]
        _ ≤ C1 / Real.log 4 * Real.log T := by
          calc
            C1 * Real.log T = C1 / Real.log 4 * Real.log 4 * Real.log T := by
              field_simp [hlog4pos.ne']
            _ ≤ C1 / Real.log 4 * Real.log T * Real.log T := by
              gcongr
              · exact by linarith [Real.pi_pos]
              · exact hlt
            _ = C1 / Real.log 4 * Real.log T := by
              have hsq : Real.log T = Real.log T := rfl
              ring
              ring_nf

/-! ## The point-scale formula -/

/-- |f_pt 4| ≤ 2  (the bottom-end constant,  explicit). -/
theorem f_pt_4_abs_le : |f_pt 4| ≤ 2 := by
  have hpi_lo : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hpi_hi : Real.pi < 10 / 3 := by
    have h := Real.pi_lt_d6
    norm_num at h ⊢
    linarith
  have h1 : 0 < 2 / Real.pi := by positivity
  have h2 : 2 / Real.pi < 1 := by
    rw [div_lt_one (by positivity)]
    nlinarith [show (2 : ℝ) < Real.pi from by
      have h := Real.pi_gt_d6
      norm_num at h ⊢
      linarith]
  have h3 : Real.log (2 / Real.pi) < 0 := Real.log_neg h1 h2
  have h4 : |f_pt 4| = (2 / Real.pi) * (1 - Real.log (2 / Real.pi)) := by
    unfold f_pt
    have h5 : |(4 : ℝ) / (2 * Real.pi) * (Real.log ((4 : ℝ) / (2 * Real.pi)) - 1)| =
        (4 : ℝ) / (2 * Real.pi) * (1 - Real.log ((4 : ℝ) / (2 * Real.pi))) := by
      have hw : 0 < (4 : ℝ) / (2 * Real.pi) := by positivity
      have h6 : Real.log ((4 : ℝ) / (2 * Real.pi)) - 1 < 0 := by
        have h7 : (4 : ℝ) / (2 * Real.pi) = 2 / Real.pi := by ring
        rw [h7]
        nlinarith [h3, show (2 / Real.pi < 1) from h2,
          Real.log_lt_sub_one_of_pos h1 (by
            rw [sub_eq_iff_eq_add]
            nlinarith [h2])]
      have h7 : (4 : ℝ) / (2 * Real.pi) = 2 / Real.pi := by ring
      rw [abs_of_neg h6]
      rw [h7]
      ring
    exact h5
  rw [h4]
  have h8 : 1 - Real.log (2 / Real.pi) ≤ 2 := by
    have hlog9 : Real.log (2 / Real.pi) ≥ -1 := by
      have h10 : (1 : ℝ) / Real.exp 1 ≤ 2 / Real.pi := by
        have hexp : Real.exp 1 > 0 := Real.exp_pos 1
        have h2e : 2 * Real.exp 1 ≥ Real.pi := by
          have hpi : Real.pi < 4 := by
            have h := hpi_hi
            nlinarith
          have he : (2 : ℝ) * Real.exp 1 ≥ 5.436 := by
            have h := Real.exp_one_gt_d9
            norm_num at h ⊢
            linarith
          linarith
        field_simp [hexp.ne']
        nlinarith [h2e]
      have h11 : Real.log (1 / Real.exp 1) < Real.log (2 / Real.pi) :=
        Real.log_lt_log h1 (by simpa [Real.div_exp_one, one_div] using h10)
      have h12 : Real.log (1 / Real.exp 1) = -1 := by
        rw [show (1 : ℝ) / Real.exp 1 = Real.exp (-1) from Real.exp_neg 1, Real.log_exp]
        simp
      linarith
    nlinarith [h3]
  calc
    (2 / Real.pi) * (1 - Real.log (2 / Real.pi)) ≤ (2 / Real.pi) * 2 := by gcongr
    _ ≤ 2 := by
      have h9 : 2 / Real.pi ≤ 1 := by
        rw [div_le_one (by positivity)]
        nlinarith [show (2 : ℝ) ≤ Real.pi from by
          have h := Real.pi_gt_d6
          norm_num at h ⊢
          linarith]
      nlinarith

/-! ## The point-scale formula -/

/-- **Point Riemann--von Mangoldt, in-repo.**  For T >= T0 at a good
    height T,  under C9 (no nontrivial zero on (0,4]):
    |N(T) - f_pt T| <= C·log T,  N(T) = Ncount 4 T counting all
    nontrivial zeros 0 < Im <= T. -/
theorem point_rvM (hΓ : GammaFacts) (hC9 : C9NoZerosLow) :
    ∃ C T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → GoodHeight T →
      |(Ncount 4 T : ℝ) - f_pt T| ≤ C * Real.log T := by
  obtain ⟨Cz, T₀z, hcz⟩ := hc_zeta_im_bound hC9
  obtain ⟨K, hK0, hm⟩ := int_mu_point_form hΓ
  have hf4 : |f_pt 4| ≤ 2 := f_pt_4_abs_le
  refine ⟨Cz / Real.pi + (K + 2) / Real.log 2, max (max T₀z 4) 10, fun T hT hgT => ?_⟩
  have hT10 : (10 : ℝ) ≤ T :=
    le_trans (le_max_right _ _) hT
  have hT41 : (4 : ℝ) < T := by nlinarith [show (4 : ℝ) < 10 from by norm_num, hT10]
  have hgh4 : GoodHeight 4 := C9_goodHeight_4 hC9
  have hN : (Ncount 4 T : ℝ) =
      (1 / Real.pi) * (halfContour (logDeriv completedRiemannZeta) 4 T).im :=
    Ncount_eq_im_halfContour (by norm_num) hT41 hgh4 hgT
  rw [hN]
  have hsplit := halfContour_completedZeta_split (by norm_num) hT41 hgh4 hgT
  rw [hsplit, Complex.add_im]
  have hgs : (1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im =
      ∫ τ in (4 : ℝ)..T, mu τ :=
    gamma_side (by norm_num) (by linarith)
  have hczT : |(halfContour (logDeriv riemannZeta) 4 T).im| ≤ Cz * Real.log T :=
    hcz T (by
      have hT4 : 4 ≤ T := by linarith
      have hm4 : max T₀z 4 ≤ T := le_trans (le_max_le (by
        have h := T₀z
        have h10b : max T₀z 4 ≤ T := le_trans (max_le_max (by
          nlinarith) (by nlinarith)) le_rfl
        -- we only need T0z ≤ T, which follows from T ≥ 10 ≥ ...;  T0z ≤ T:
        nlinarith) (by linarith)) le_rfl
      nlinarith) hgT
  have hmT : |(∫ τ in (4 : ℝ)..T, mu τ) - (f_pt T - f_pt 4)| ≤ K := hm T (by linarith)
  have hlogTpos : 0 < Real.log T := Real.log_pos (by nlinarith [show (1 : ℝ) < 10 from by norm_num, hT10])
  have hlog2pos : 0 < Real.log 2 := Real.log_pos (by norm_num)
  have hlog2le : Real.log 2 ≤ Real.log T :=
    Real.log_le_log (by positivity) (by nlinarith [show (2 : ℝ) ≤ 10 from by norm_num, hT10])
  have hstep :
      |(1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im +
          (1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T|
      ≤ (1 / Real.pi) * |(halfContour (logDeriv riemannZeta) 4 T).im|
        + |(1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T| := by
    have hrew : (1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im
        + (1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T
        = (1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im
          + ((1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T) := by ring
    rw [hrew]
    calc
      |(1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im
          + ((1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T)| ≤
        |(1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im|
          + |(1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T| :=
        abs_add _ _
      _ = (1 / Real.pi) * |(halfContour (logDeriv riemannZeta) 4 T).im|
          + |(1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T| := by
        rw [abs_mul, abs_of_pos (show (0 : ℝ) < 1 / Real.pi from by positivity)]
  calc
    |(1 / Real.pi) * (halfContour (logDeriv riemannZeta) 4 T).im +
        (1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T| ≤
      (1 / Real.pi) * |(halfContour (logDeriv riemannZeta) 4 T).im|
        + |(1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T| :=
      hstep
    _ ≤ (1 / Real.pi) * (Cz * Real.log T) + (K + 2) := by
      gcongr
      · exact hczT
      · calc
          |(1 / Real.pi) * (halfContour (logDeriv Complex.Gammaℝ) 4 T).im - f_pt T|
              = |(∫ τ in (4 : ℝ)..T, mu τ) - f_pt T| := by
                rw [hgs]
                ring
          _ ≤ K + |f_pt 4| := by
            have hclose : (∫ τ in (4 : ℝ)..T, mu τ) - f_pt T =
                ((∫ τ in (4 : ℝ)..T, mu τ) - (f_pt T - f_pt 4)) + f_pt 4 := by ring
            rw [hclose]
            calc
              |(∫ τ in (4 : ℝ)..T, mu τ) - (f_pt T - f_pt 4) + f_pt 4|
                  ≤ |(∫ τ in (4 : ℝ)..T, mu τ) - (f_pt T - f_pt 4)| + |f_pt 4| :=
                abs_add _ _
              _ ≤ K + |f_pt 4| := by gcongr <;> simpa using hmT
          _ ≤ K + 2 := by gcongr <;> simpa using hf4
      · norm_num
    _ ≤ Cz / Real.pi * Real.log T + (K + 2) / Real.log 2 * Real.log T := by
      have hnn : 0 ≤ K + 2 := by nlinarith [hK0]
      have hdiv : (K + 2) / Real.log 2 * Real.log T = (K + 2) * (Real.log T / Real.log 2) := by ring
      have hd : Real.log T / Real.log 2 ≥ 1 := (le_div_iff hlog2pos).mpr hlog2le
      have hK2 : K + 2 ≤ (K + 2) / Real.log 2 * Real.log T := by
        rw [hdiv]
        calc
          (K + 2) * (Real.log T / Real.log 2) ≥ (K + 2) * 1 := mul_le_mul_of_nonneg_left hd hnn
          _ = K + 2 := by ring
      have hmul : (1 / Real.pi) * (Cz * Real.log T) = Cz / Real.pi * Real.log T := by ring
      rw [hmul]
      nlinarith
    _ = (Cz / Real.pi + (K + 2) / Real.log 2) * Real.log T := by ring

/-! ## Uses -/

/-- **Rebase of the wire input A1G-6.**  The CITED "classical
    Backlund O(log t)" behind the wire's hSbound premise is satisfied
    by the in-repo proved point formula:  at every good height
    t >= T0 the per-straddle defect |N(t) - f_pt t| (the classical
    smooth-count deficit for Nas = main term) obeys the premise form
    C·log t + 1/t. -/
theorem rebase_a1g6_dn_form (hΓ : GammaFacts) (hC9 : C9NoZerosLow) :
    ∃ C T₀ : ℝ, ∀ t : ℝ, T₀ ≤ t → GoodHeight t →
      |(Ncount 4 t : ℝ) - f_pt t| ≤ C * Real.log t + 1 / t := by
  obtain ⟨C, T₀, hC⟩ := point_rvM hΓ hC9
  refine ⟨C, T₀, fun t ht hg => ?_⟩
  have ht0 : 0 < t := by
    have h10 : (10 : ℝ) ≤ T₀ := by
      have h := le_trans (le_trans (max_le_max (le_trans (le_max_right _ _) (le_max_left _ _))
        (le_max_right _ _)) le_rfl) ht
      norm_num at h ⊢
      linarith
    linarith
  calc
    |(Ncount 4 t : ℝ) - f_pt t| ≤ C * Real.log t := hC t ht hg
    _ ≤ C * Real.log t + 1 / t := le_add_of_nonneg_right (by positivity)

/-- Self-test (ap5):  the point formula with the discharged Gamma
    facts,  under the single named input C9. -/
theorem s1_selftest_point_rvM_discharged (hC9 : C9NoZerosLow) :
    ∃ C T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T → GoodHeight T →
      |(Ncount 4 T : ℝ) - f_pt T| ≤ C * Real.log T :=
  point_rvM gammaFacts hC9

end S1B
