/-
Rh-missing-tail, D4 argument-principle line (ap2) -- the RVM window
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
import RhAttack.Ap1ArgumentPrinciple
import RhAttack.Ap2Statement
import RhAttack.Ap2Seam
import RhAttack.Ap2Reflect
set_option linter.style.header false

namespace Ap2


open Complex Set Topology Filter Real

noncomputable section

namespace Zeta23
namespace RvM

/-! ## Λ = completedRiemannZeta: analyticity, relation to ζ, zeros -/

lemma analyticAt_completedRiemannZeta {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) :
    AnalyticAt ℂ completedRiemannZeta s := by
  have hopen : IsOpen (({0, 1} : Set ℂ)ᶜ) := (Set.toFinite _).isClosed.isOpen_compl
  have hdiff : DifferentiableOn ℂ completedRiemannZeta (({0, 1} : Set ℂ)ᶜ) := by
    intro z hz
    simp only [mem_compl_iff, mem_insert_iff, mem_singleton_iff, not_or] at hz
    exact (differentiableAt_completedZeta hz.1 hz.2).differentiableWithinAt
  exact hdiff.analyticAt (hopen.mem_nhds (by simp [h0, h1]))

lemma completedRiemannZeta_eq_Gammaℝ_mul {s : ℂ} (hs : s ≠ 0) (hG : Gammaℝ s ≠ 0) :
    completedRiemannZeta s = Gammaℝ s * riemannZeta s := by
  rw [riemannZeta_def_of_ne_zero hs]
  field_simp

lemma completedRiemannZeta_eq_zero_iff_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    completedRiemannZeta s = 0 ↔ riemannZeta s = 0 := by
  have h0 : s ≠ 0 := fun h => by simp [h] at hs
  have hG := Gammaℝ_ne_zero_of_re_pos hs
  rw [completedRiemannZeta_eq_Gammaℝ_mul h0 hG, mul_eq_zero]
  simp [hG]

lemma completedRiemannZeta_ne_zero_of_one_le_re {s : ℂ} (hs : 1 ≤ s.re) :
    completedRiemannZeta s ≠ 0 := by
  rw [Ne, completedRiemannZeta_eq_zero_iff_of_re_pos (by linarith)]
  exact riemannZeta_ne_zero_of_one_le_re hs

lemma completedRiemannZeta_ne_zero_of_re_nonpos {s : ℂ} (hs : s.re ≤ 0) :
    completedRiemannZeta s ≠ 0 := by
  rw [← completedRiemannZeta_one_sub]
  exact completedRiemannZeta_ne_zero_of_one_le_re (by simp; linarith)

/-- The zeros of Λ are exactly the nontrivial zeros of ζ (everywhere: at the poles 0, 1 Mathlib's
junk values are nonzero too, since ζ(1) ≠ 0 in Mathlib and Λ(0) = Λ(1)). -/
lemma completedRiemannZeta_eq_zero_iff {s : ℂ} :
    completedRiemannZeta s = 0 ↔ IsNontrivialZero s := by
  constructor
  · intro h
    have h1 : 0 < s.re := by
      by_contra hle
      exact completedRiemannZeta_ne_zero_of_re_nonpos (not_lt.mp hle) h
    have h2 : s.re < 1 := by
      by_contra hle
      exact completedRiemannZeta_ne_zero_of_one_le_re (not_lt.mp hle) h
    exact ⟨(completedRiemannZeta_eq_zero_iff_of_re_pos h1).mp h, h1, h2⟩
  · rintro ⟨hz, h1, _⟩
    exact (completedRiemannZeta_eq_zero_iff_of_re_pos h1).mpr hz

/-- On the open right half-plane (away from 1) the analytic order of Λ equals zeroMult = the
analytic order of ζ. -/
lemma analyticOrderNatAt_completedRiemannZeta {ρ : ℂ} (h : 0 < ρ.re) (h1 : ρ ≠ 1) :
    analyticOrderNatAt completedRiemannZeta ρ = zeroMult ρ := by
  have h0 : ρ ≠ 0 := fun h' => by simp [h'] at h
  have hev : riemannZeta =ᶠ[𝓝 ρ] (completedRiemannZeta * fun s => (Gammaℝ s)⁻¹) := by
    filter_upwards [isOpen_compl_singleton.mem_nhds h0] with s hs
    rw [Pi.mul_apply, riemannZeta_def_of_ne_zero hs, div_eq_mul_inv]
  have hΛ := analyticAt_completedRiemannZeta h0 h1
  have hGinv : AnalyticAt ℂ (fun s => (Gammaℝ s)⁻¹) ρ := differentiable_Gammaℝ_inv.analyticAt ρ
  have hG0 : analyticOrderAt (fun s => (Gammaℝ s)⁻¹) ρ = 0 :=
    hGinv.analyticOrderAt_eq_zero.mpr (inv_ne_zero (Gammaℝ_ne_zero_of_re_pos h))
  unfold zeroMult analyticOrderNatAt
  rw [analyticOrderAt_congr hev, analyticOrderAt_mul hΛ hGinv, hG0, add_zero]

/-! ## The count -/

/-- **N(T₁,T₂) as a contour integral.** For 0 < T₁ ≤ T₂ with no nontrivial zero of ordinate T₁ or
T₂:  (1/2πi)∮_{∂([−1,2]×[T₁,T₂])} Λ'/Λ = Ncount T₁ T₂. -/
theorem rectangleIntegral'_logDeriv_completedZeta_eq_Ncount {T₁ T₂ : ℝ} (hT₁ : 0 < T₁)
    (hT : T₁ ≤ T₂) (hgood₁ : ∀ ρ, IsNontrivialZero ρ → ρ.im ≠ T₁)
    (hgood₂ : ∀ ρ, IsNontrivialZero ρ → ρ.im ≠ T₂) :
    RectangleIntegral' (logDeriv completedRiemannZeta) (-1 + T₁ * I) (2 + T₂ * I)
      = (Ncount T₁ T₂ : ℂ) := by
  classical
  set z : ℂ := -1 + T₁ * I with hzdef
  set w : ℂ := 2 + T₂ * I with hwdef
  have hzre : z.re = -1 := by simp [z]
  have hzim : z.im = T₁ := by simp [z]
  have hwre : w.re = 2 := by simp [w]
  have hwim : w.im = T₂ := by simp [w]
  have hre : z.re ≤ w.re := by rw [hzre, hwre]; norm_num
  have him : z.im ≤ w.im := by rw [hzim, hwim]; exact hT
  have hmem : ∀ s : ℂ, s ∈ Rectangle z w ↔
      (-1 ≤ s.re ∧ s.re ≤ 2) ∧ (T₁ ≤ s.im ∧ s.im ≤ T₂) := by
    intro s
    simp only [Rectangle, mem_reProdIm, hzre, hzim, hwre, hwim,
      uIcc_of_le (show (-1 : ℝ) ≤ 2 by norm_num), uIcc_of_le hT, mem_Icc]
  have hf : AnalyticOnNhd ℂ completedRiemannZeta (Rectangle z w) := by
    intro s hs
    have hi : 0 < s.im := by linarith [((hmem s).mp hs).2.1]
    exact analyticAt_completedRiemannZeta (fun h => by simp [h] at hi) (fun h => by simp [h] at hi)
  have hg : AnalyticOnNhd ℂ (fun _ : ℂ => (1 : ℂ)) (Rectangle z w) := fun _ _ => analyticAt_const
  have hfin := zetaSeam.finite_window T₁ T₂
  have hZ : ∀ s ∈ Rectangle z w, completedRiemannZeta s = 0 ↔ s ∈ hfin.toFinset := by
    intro s hs
    rw [Set.Finite.mem_toFinset]
    obtain ⟨⟨hr1, hr2⟩, ⟨hi1, hi2⟩⟩ := (hmem s).mp hs
    rw [completedRiemannZeta_eq_zero_iff]
    constructor
    · intro hnz
      exact ⟨hnz, lt_of_le_of_ne hi1 (fun h' => hgood₁ s hnz h'.symm), hi2⟩
    · rintro ⟨hnz, _⟩
      exact hnz
  have hZsub : ((hfin.toFinset : Finset ℂ) : Set ℂ) ⊆ Rectangle z w := by
    intro s hs
    rw [Finset.mem_coe, Set.Finite.mem_toFinset] at hs
    obtain ⟨⟨_, h1, h2⟩, hi1, hi2⟩ := hs
    exact (hmem s).mpr ⟨⟨by linarith, by linarith⟩, hi1.le, hi2⟩
  have hborder : ∀ s ∈ RectangleBorder z w, completedRiemannZeta s ≠ 0 := by
    intro s hs h0
    obtain ⟨⟨hr1, hr2⟩, ⟨hi1, hi2⟩⟩ := (hmem s).mp (rectangleBorder_subset_rectangle z w hs)
    have hnz := completedRiemannZeta_eq_zero_iff.mp h0
    simp only [RectangleBorder, mem_union, mem_reProdIm, mem_singleton_iff, hzre, hzim, hwre,
      hwim] at hs
    rcases hs with ((⟨_, h'⟩ | ⟨h', _⟩) | ⟨_, h'⟩) | ⟨h', _⟩
    · exact hgood₁ s hnz h'
    · linarith [hnz.2.1]
    · exact hgood₂ s hnz h'
    · linarith [hnz.2.2]
  have key := Ap1.rectangleIntegral'_mul_logDeriv hre him hf hg hborder
    hfin.toFinset hZ hZsub
  simp only [one_mul, mul_one] at key
  rw [show (fun s => logDeriv completedRiemannZeta s) = logDeriv completedRiemannZeta from rfl]
    at key
  rw [key]
  unfold Ncount
  have hset : zerosIn T₁ T₂ = {ρ | IsNontrivialZero ρ} ∩ {ρ | T₁ < ρ.im ∧ ρ.im ≤ T₂} := by
    ext ρ; simp [zerosIn]
  rw [hset, finsum_mem_eq_finite_toFinset_sum _ hfin, Nat.cast_sum]
  refine Finset.sum_congr rfl (fun ρ hρ => ?_)
  rw [Set.Finite.mem_toFinset] at hρ
  obtain ⟨⟨_, h1, h2⟩, _⟩ := hρ
  rw [analyticOrderNatAt_completedRiemannZeta h1 (fun h' => by simp [h'] at h2)]

end RvM
end Zeta23


/-- The zeta-seam, fully discharged from Mathlib (no paper inputs): finiteness
of the zero windows plus reflection symmetry of the nontrivial zeros. -/
theorem zetaSeam : ZetaSeam :=
    ZetaSeam.of_reflect zeta_reflect_zero zeta_mult_reflect

/-! ## Self-test (ap2) -- the ported window identity under RH -/

/-- Under Mathlib's RiemannHypothesis every nontrivial zero lies on the
critical line, so the contour integral of the completed zeta's log-derivative
around the RVM rectangle counts EXACTLY the on-line zeros of the window
(integral never computed by hand). -/
theorem ap2_selftest_RH_counts_on_line {T₁ T₂ : ℝ} (hT₁ : 0 < T₁) (hT : T₁ ≤ T₂)
    (hgood₁ : ∀ ρ, IsNontrivialZero ρ → ρ.im ≠ T₁)
    (hgood₂ : ∀ ρ, IsNontrivialZero ρ → ρ.im ≠ T₂)
    (hRH : RiemannHypothesis) :
    RectangleIntegral' (logDeriv completedRiemannZeta) (-1 + T₁ * I) (2 + T₂ * I)
        = (N0 T₁ T₂ : ℂ) := by
  have hin := rectangleIntegral'_logDeriv_completedZeta_eq_Ncount hT₁ hT hgood₁ hgood₂
  rw [hin]
  have hall := RH_implies_all_on_line hRH T₁ T₂
  have hN : (N0 T₁ T₂ : ℂ) = (Ncount T₁ T₂ : ℂ) := by
    norm_cast
    exact hall.1
  simpa using hN.symm

end Ap2
