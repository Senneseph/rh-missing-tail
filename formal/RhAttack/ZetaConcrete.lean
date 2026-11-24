/-
ZetaConcrete: the abstract ZeroSet, concretized on Mathlib's riemannZeta.

STATUS (0476):  in-tree connective layer.  The abstract B0.lean machinery
(ZeroSet, RH q, and the B25 terminal endpoint
`rh_program78_stripfront_mach_unifiedContinuumAnchor_PT2`) takes an
ABSTRACT zero set `q` plus the field
    hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0.
This module shows that the ACTUAL zero set of Mathlib's `riemannZeta`
    qz.Z := {ρ | riemannZeta ρ = 0 ∧ ρ.im ≠ 0}
is itself a VALID ZeroSet: every one of the five structural fields is
PROVEN in this tree — no new axioms.  The pinned Mathlib v4.33.1 supplies
`completedRiemannZeta₀`, the no-guard product formula
(`riemannZeta_eq_mul_completedRiemannZeta₀`), the completed functional
equation (`completedRiemannZeta₀_one_sub`), nonvanishing at Re ≥ 1
(`riemannZeta_ne_zero_of_one_le_re`), `Complex.Gamma_conj`,
`Complex.Gamma_ne_zero`, `Complex.cpow_conj`, `Complex.star_def`
(star = starRingEnd on ℂ), the Hurwitz FE-pair machinery
(`HurwitzZeta.hurwitzEvenFEPair`, real-valued modified kernel), the
Mellin transform, `ContinuousLinearMap.integral_comp_comm`, and
`IsCompact.inter_riemannZetaZeros_finite`.

The `conj` field (closure under complex conjugation) is the hard part.
It is proven through the Mellin-transform definition of the completed
zeta:  Λ₀ = mellin f_modif,  where `f_modif` of the a = 0 Hurwitz FE-pair
is real-valued (f = ofReal ∘ evenKernel 0, f₀ = g₀ = ε = 1, k = 1/2).
A real kernel + `Complex.cpow_conj` (at arg 0 ≠ π) + the Bochner integral
commuting with the ℝ-linear isometry `star` give
    star (mellin f s) = mellin f (star s)
    → star (completedRiemannZeta₀ s) = completedRiemannZeta₀ (star s)
    → star (riemannZeta s) = riemannZeta (star s)          (zetaConjSymm)
    → non-real zeros close under conjugation.              (zetaConjZero)

Note on notation:  in this Mathlib build the conjugation lemmas
(`Complex.cpow_conj`, `Complex.conj_ofReal`, ...) are stated with the
function `starRingEnd ℂ`, while proofs write the `StarRing` class
notation `star`.  The bridge is `Complex.star_def :
(Star.star : ℂ → ℂ) = ⇑(starRingEnd ℂ)`, used to translate between the
two notations at the two `cpow_conj` application sites.

WHAT CONCRETIZATION REMOVES FROM THE B25 ENDPOINT:
  - `hqz`  —  derived, not assumed:  `ZetaConcrete.hqzQz`.
WHAT REMAINS A NAMED INPUT (by design, unchanged):
  - `hzF`    the [Z78] #ELEVEN continuum-anchor record (external,
             kernel-verified PR #141; named input, not proven here).
  - `honline`  on-line at small height (< 707/50): classical small fact,
             not in the pinned Mathlib.
  - `hPT2`   the Platt–Trudgian wire up to tPT2 (external cited record).
  - `hOffC`  the terminal face above the frontier —  the NAMED OPEN
             RESEARCH OBJECT.

HONESTY:  no RH claim.  `RH qz` remains a THEOREM of the B25 endpoint
under its four named inputs; only `hqz` is discharged here.  The
terminal face stays open.
-/
import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.Z78ContinuumAnchor

open Set Complex Real
open MeasureTheory

namespace ZetaConcrete

open Classical

/-! ## 1.  `star` as a continuous ℝ-linear isometry on ℂ -/

/-- Complex conjugation is norm-preserving. -/
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

/-- `star (2 : ℂ) = 2`. -/
theorem star_two : star (2 : ℂ) = (2 : ℂ) := by
  rw [show (2 : ℂ) = 1 + 1 by norm_num, star_add, star_one]

/-- Complex conjugation, viewed as a continuous ℝ-linear isometry. -/
def starL : ℂ →L[ℝ] ℂ :=
  { toFun := star,
    map_add' := star_add,
    map_smul' := by
      intro r x
      change star ((r : ℂ) * x) = (r : ℂ) * star x
      rw [star_mul, show star (r : ℂ) = (r : ℂ) from by rw [Complex.star_def, Complex.conj_ofReal]]
      <;> try ring }

/-! ## 2.  `star` and Bochner integration -/

/-- An isometry preserves integrability of ℂ-valued functions. -/
theorem integrableStar (f : ℝ → ℂ) :
    Integrable f volume ↔ Integrable (star ∘ f) volume := by
  refine ⟨fun h => ?_, fun h => ?_⟩
  · -- Integrable f → Integrable (star ∘ f)
    obtain ⟨haesm, hfin⟩ := h
    refine ⟨?_, ?_⟩
    · obtain ⟨g, hsg, hae⟩ := haesm
      refine ⟨star ∘ g, starL.continuous.comp_stronglyMeasurable hsg, ?_⟩
      -- star ∘ f =ᵐ star ∘ g, from f =ᵐ g (star is injective)
      exact Filter.Eventually.congr hae (Filter.Eventually.of_forall (fun x => by
        constructor
        · intro hfg
          simpa using congr_arg star hfg
        · intro hfg
          simpa using congr_arg star hfg))
    · exact (MeasureTheory.hasFiniteIntegral_congr'
        (Filter.Eventually.of_forall (fun x => by
          simpa using (normStar (f x)).symm))).mpr hfin
  · -- Integrable (star ∘ f) → Integrable f
    obtain ⟨haesm, hfin⟩ := h
    refine ⟨?_, ?_⟩
    · obtain ⟨g, hsg, hae⟩ := haesm
      refine ⟨star ∘ g, starL.continuous.comp_stronglyMeasurable hsg, ?_⟩
      -- f =ᵐ star ∘ g, from star ∘ f =ᵐ g (star ∘ star = id)
      exact Filter.Eventually.congr hae (Filter.Eventually.of_forall (fun x => by
        constructor
        · intro h
          have := congr_arg star h
          simp only [star_star, Function.comp_apply] at this
          exact this
        · intro h
          have := congr_arg star h
          simp only [star_star, Function.comp_apply] at this
          exact this))
    · exact (MeasureTheory.hasFiniteIntegral_congr'
        (Filter.Eventually.of_forall (fun x => by
          simpa using normStar (f x)))).mp hfin

/-! ## 3.  `star` and the Mellin transform -/

/-- Conjugation of the Mellin transform for a real-valued kernel:
    `star (mellin f s) = mellin f (star s)`. -/
theorem starMellinOfReal (f : ℝ → ℂ) (hf : ∀ t, star (f t) = f t) (s : ℂ) :
    star (mellin f s) = mellin f (star s) := by
  set Hs : ℝ → ℂ := fun t => (t : ℂ) ^ (s - 1) • f t with HHs
  set Ht : ℝ → ℂ := fun t => (t : ℂ) ^ (star s - 1) • f t with HHt
  have hpoint : ∀ t ∈ Ioi 0, Ht t = star (Hs t) := by
    intro t ht
    have harg : (t : ℂ).arg ≠ π := by
      rw [Complex.arg_ofReal_of_nonneg (le_of_lt ht)]
      by_contra h
      linarith [Real.pi_pos, h]
    calc Ht t = (t : ℂ) ^ (star (s - 1)) • f t := by
          rw [HHt]
          have : (star s - 1 : ℂ) = star (s - 1) := by
            rw [star_sub, star_one]
          rw [this]
      _ = star ((t : ℂ) ^ (s - 1)) • f t := by
          rw [Complex.star_def]
          rw [Complex.cpow_conj (t : ℂ) (s - 1) harg]
          simp
      _ = star ((t : ℂ) ^ (s - 1)) • star (f t) := by
          rw [hf t]
      _ = star ((t : ℂ) ^ (s - 1) • f t) := by
          simp only [smul_eq_mul, star_mul]
          ring
      _ = star (Hs t) := by rw [HHs]
  have hcongr : ∫ t in Ioi 0, Ht t = ∫ t in Ioi 0, star (Hs t) :=
    MeasureTheory.setIntegral_congr_fun measurableSet_Ioi (fun t ht => hpoint t ht)
  have hI : ∫ t in Ioi 0, Hs t = ∫ t, (Ioi 0).indicator Hs t := by
    rw [← MeasureTheory.integral_indicator measurableSet_Ioi]
  have hI2 : ∫ t in Ioi 0, star (Hs t) = ∫ t, (Ioi 0).indicator (fun u => star (Hs u)) t := by
    rw [← MeasureTheory.integral_indicator measurableSet_Ioi]
  have hcore : star (∫ t in Ioi 0, Hs t) = ∫ t in Ioi 0, star (Hs t) := by
    by_cases h : Integrable (fun t => (Ioi 0).indicator Hs t)
    · calc star (∫ t in Ioi 0, Hs t)
        = star (∫ t, (Ioi 0).indicator Hs t) := by rw [hI]
      _ = starL (∫ t, (Ioi 0).indicator Hs t) := by
          have hpt (x : ℂ) : starL x = star x := by
            unfold starL
            rfl
          rw [← hpt]
      _ = ∫ t, starL ((Ioi 0).indicator Hs t) := by
          rw [← ContinuousLinearMap.integral_comp_comm (L := starL) h]
      _ = ∫ t, star ((Ioi 0).indicator Hs t) := by
          congr 1
      _ = ∫ t, (Ioi 0).indicator (fun u => star (Hs u)) t := by
          have hpw : (fun t : ℝ => star ((Ioi 0).indicator Hs t)) =
              (fun t : ℝ => (Ioi 0).indicator (fun u => star (Hs u)) t) := by
            funext t
            by_cases ht : t ∈ Ioi 0
            · simp [Set.indicator_of_mem ht]
            · simp [Set.indicator_of_notMem ht]
          rw [hpw]
      _ = ∫ t in Ioi 0, star (Hs t) := by rw [hI2]
    · have h2 : ¬Integrable (fun t => (Ioi 0).indicator (fun u => star (Hs u)) t) := by
        by_contra h3
        have heq : (fun t : ℝ => (Ioi 0).indicator (fun u => star (Hs u)) t) =
            (star : ℂ → ℂ) ∘ (fun t : ℝ => (Ioi 0).indicator Hs t) := by
          funext t
          by_cases ht : t ∈ Ioi 0
          · simp [Set.indicator_of_mem ht]
          · simp [Set.indicator_of_notMem ht]
        rw [heq] at h3
        have := (integrableStar (fun t : ℝ => (Ioi 0).indicator Hs t)).mpr h3
        contradiction
      have hl : ∫ t in Ioi 0, Hs t = 0 := by
        rw [hI]
        exact MeasureTheory.integral_undef h
      have hr : ∫ t in Ioi 0, star (Hs t) = 0 := by
        rw [hI2]
        exact MeasureTheory.integral_undef h2
      rw [hl, hr, star_zero]
  rw [mellin, mellin]
  change star (∫ t in Ioi 0, Hs t) = ∫ t in Ioi 0, Ht t
  rw [hcore, hcongr]

/-! ## 4.  The a = 0 Hurwitz FE-pair has a real-valued modified kernel -/

/-- The modified kernel of the `a = 0` Hurwitz FE-pair is real-valued:
    `star (f_modif t) = f_modif t` for all `t`. -/
theorem hurwitzEvenFEPair0FModifReal (t : ℝ) :
    star ((HurwitzZeta.hurwitzEvenFEPair 0).f_modif t) =
        (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t := by
  have hf : (HurwitzZeta.hurwitzEvenFEPair 0).f = (fun x : ℝ => ofReal (HurwitzZeta.evenKernel 0 x)) := by
    ext x
    simp [HurwitzZeta.hurwitzEvenFEPair]
  have hk : (HurwitzZeta.hurwitzEvenFEPair 0).k = (1 / 2 : ℝ) := by simp [HurwitzZeta.hurwitzEvenFEPair]
  have heps : (HurwitzZeta.hurwitzEvenFEPair 0).ε = (1 : ℂ) := by simp [HurwitzZeta.hurwitzEvenFEPair]
  have hf0 : (HurwitzZeta.hurwitzEvenFEPair 0).f₀ = (1 : ℂ) := by simp [HurwitzZeta.hurwitzEvenFEPair]
  have hg0 : (HurwitzZeta.hurwitzEvenFEPair 0).g₀ = (1 : ℂ) := by simp [HurwitzZeta.hurwitzEvenFEPair]
  simp [WeakFEPair.f_modif, hf, hk, heps, hf0, hg0]
  by_cases hA : t ∈ Ioi 1
  · by_cases hB : t ∈ Ioo 0 1
    · -- both on:  impossible (1 < t and t < 1)
      exfalso
      have := mem_Ioi.1 hA
      have hb := mem_Ioo.1 hB
      linarith
    · -- t > 1:  star (ofReal (evenKernel 0 t) - 1)
      simp [Set.indicator_of_mem hA, Set.indicator_of_notMem hB,
           star_sub, star_one, star_mul, smul_eq_mul, ofReal_re, ofReal_im]
  · by_cases hB : t ∈ Ioo 0 1
    · -- 0 < t < 1:  star (ofReal (evenKernel 0 t) - (1 * ↑(t ^ -(1/2))) • 1)
      simp [Set.indicator_of_notMem hA, Set.indicator_of_mem hB,
           star_sub, star_one, star_mul, smul_eq_mul, ofReal_re, ofReal_im]
    · -- both off:  0 + 0
      simp [Set.indicator_of_notMem hA, Set.indicator_of_notMem hB,
           star_sub, star_one, star_mul, smul_eq_mul, ofReal_re, ofReal_im]

/-! ## 5.  Conjugation of the completed Riemann zeta -/

/-- `star (completedRiemannZeta₀ s) = completedRiemannZeta₀ (star s)`. -/
theorem completedRiemannZeta0Conj (s : ℂ) :
    star (completedRiemannZeta₀ s) = completedRiemannZeta₀ (star s) := by
  dsimp only [completedRiemannZeta₀, HurwitzZeta.completedHurwitzZetaEven₀, WeakFEPair.Λ₀]
  have hreal : ∀ t, star ((HurwitzZeta.hurwitzEvenFEPair 0).f_modif t) =
      (HurwitzZeta.hurwitzEvenFEPair 0).f_modif t := fun t => hurwitzEvenFEPair0FModifReal t
  rw [star_div₀, show star (2 : ℂ) = (2 : ℂ) from star_two,
      starMellinOfReal _ hreal (s / 2)]
  rw [show star (s / 2) = star s / 2 from by rw [star_div₀, star_two]]

/-! ## 6.  Conjugation symmetry of the Riemann zeta -/

/-- `riemannZeta (star s) = star (riemannZeta s)` —  the zeta function
    maps conjugation to conjugation (for all `s`, no guard). -/
theorem zetaConjSymm (s : ℂ) : riemannZeta (star s) = star (riemannZeta s) := by
  have hpi : (π : ℂ).arg ≠ π := by
    rw [Complex.arg_ofReal_of_nonneg (le_of_lt Real.pi_pos)]
    by_contra h
    linarith [Real.pi_pos, h]
  have hexp : (-(star s) / 2 : ℂ) = star (-(s / 2)) := by
    rw [star_neg, show star (s / 2) = star s / 2 by
      rw [star_div₀, star_two]]
    ring
  have hcpow : (π : ℂ) ^ (-(star s) / 2) = star ((π : ℂ) ^ (-s / 2)) := by
    rw [hexp, Complex.star_def]
    rw [Complex.cpow_conj (π : ℂ) (-(s / 2)) hpi]
    simp
    congr 1
    rw [show (-(s / 2) : ℂ) = -s / 2 by ring]
  have hg : Complex.Gamma ((star s) / 2 + 1) = star (Complex.Gamma (s / 2 + 1)) := by
    have harg : (star s) / 2 + 1 = star (s / 2 + 1) := by
      have hd : (star s) / 2 = star s * (1 / 2 : ℂ) := by ring
      have hd2 : (s / 2 : ℂ) = s * (1 / 2 : ℂ) := by ring
      rw [hd, hd2]
      rw [Complex.ext_iff]
      constructor
      · simp [Complex.add_re, Complex.mul_re, ofReal_im]
      · simp [Complex.add_im, Complex.mul_im, ofReal_re, ofReal_im]
    rw [harg, Complex.star_def, Complex.Gamma_conj]
  rw [riemannZeta_eq_mul_completedRiemannZeta₀,
      riemannZeta_eq_mul_completedRiemannZeta₀,
      ← completedRiemannZeta0Conj, hcpow, hg,
      star_div₀, star_sub, star_mul, star_sub, star_mul, star_div₀, star_sub]
  · have hN : star s * star (completedRiemannZeta₀ s) - 1 - star s / (1 - star s) =
      star (completedRiemannZeta₀ s) * star s - 1 - star s / (1 - star s) := by
        ring
    have hD : 2 * star ((π : ℂ) ^ (-s / 2)) * star (Complex.Gamma (s / 2 + 1)) =
        star (Complex.Gamma (s / 2 + 1)) * (2 * star ((π : ℂ) ^ (-s / 2))) := by
      ring
    rw [hN, hD]
    simp [star_one]

/-- A non-real zero of `riemannZeta` is conjugate-closed:
    `ζ ρ = 0` and `ρ.im ≠ 0` imply `ζ (star ρ) = 0`. -/
theorem zetaConjZero (ρ : ℂ) (hρ : riemannZeta ρ = 0) (him : ρ.im ≠ 0) :
    riemannZeta (star ρ) = 0 := by
  have h := zetaConjSymm ρ
  rw [h, hρ, star_zero]

/-! ## 7.  Functional-equation pairing of non-real zeros -/

/-- `ζ ρ = 0` and `ρ.im ≠ 0` imply `ζ (1 - ρ) = 0`  (the completed
    functional equation, via the no-guard product formula). -/
theorem zetaFeZero (ρ : ℂ) (hρ : riemannZeta ρ = 0) (him : ρ.im ≠ 0) :
    riemannZeta (1 - ρ) = 0 := by
  have hne1 : ρ ≠ 1 := by
    by_contra h
    subst h
    simp at him
  have hne0 : ρ ≠ 0 := by
    by_contra h
    subst h
    simp at him
  -- denominator at ρ is nonzero:  π^w ≠ 0 and Γ has no zeros
  have hGne : Complex.Gamma (ρ / 2 + 1) ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m
    by_contra hm
    have h1 : (ρ / 2 + 1 : ℂ) = -(m : ℂ) := by simpa using hm
    have h2 : (ρ / 2 + 1).im = 0 := by
      rw [h1]
      simp
    have h3 : (ρ / 2 + 1).im = ρ.im / 2 := by
      have : (ρ / 2 : ℂ) = (ρ : ℂ) * (1 / 2 : ℂ) := by
        field_simp
        <;> ring
      rw [this]
      simp [Complex.add_im, Complex.mul_im]
      <;> field_simp
    have : ρ.im = 0 := by
      rw [h3] at h2
      field_simp at h2
      norm_num at h2
      exact h2
    contradiction
  have hD1 : 2 * π ^ (-ρ / 2) * Complex.Gamma (ρ / 2 + 1) ≠ 0 := by
    intro h
    have hπ : (π : ℂ) ^ (-ρ / 2) ≠ 0 := by
      rw [Ne, Complex.cpow_eq_zero_iff, not_and_or]
      norm_num
    rcases mul_eq_zero.mp (show (2 * π ^ (-ρ / 2)) * Complex.Gamma (ρ / 2 + 1) = 0 from h) with hL | hR
    · rcases mul_eq_zero.mp hL with h2 | hπ'
      · norm_num at h2
      · exact hπ hπ'
    · exact hGne hR
  -- numerator at ρ is zero
  have hGne2 : Complex.Gamma ((ρ + 2) / 2) ≠ 0 := by
    have : (ρ / 2 + 1 : ℂ) = (ρ + 2) / 2 := by ring
    rw [← this]
    exact hGne
  have hnum : ρ * completedRiemannZeta₀ ρ - 1 - ρ / (1 - ρ) = 0 := by
    have heq : (ρ * completedRiemannZeta₀ ρ - 1 - ρ / (1 - ρ)) /
        (2 * π ^ (-ρ / 2) * Complex.Gamma (ρ / 2 + 1)) = 0 := by
      rw [← riemannZeta_eq_mul_completedRiemannZeta₀, hρ]
    calc ρ * completedRiemannZeta₀ ρ - 1 - ρ / (1 - ρ)
        = ((ρ * completedRiemannZeta₀ ρ - 1 - ρ / (1 - ρ)) /
            (2 * π ^ (-ρ / 2) * Complex.Gamma (ρ / 2 + 1))) *
            (2 * π ^ (-ρ / 2) * Complex.Gamma (ρ / 2 + 1)) := by
          field_simp [hD1, hGne2]
      _ = 0 * (2 * π ^ (-ρ / 2) * Complex.Gamma (ρ / 2 + 1)) := by rw [heq]
      _ = 0 := by ring
  -- C₀(ρ) = 1 / (ρ * (1 - ρ))
  have hL0 : completedRiemannZeta₀ ρ = 1 / (ρ * (1 - ρ)) := by
    have h1 : ρ * completedRiemannZeta₀ ρ = 1 + ρ / (1 - ρ) := by
      have hnum' : (ρ * completedRiemannZeta₀ ρ) - (1 + ρ / (1 - ρ)) = 0 := by
        convert hnum using 1
        ring
      rw [sub_eq_zero] at hnum'
      exact hnum'
    have h2 : 1 + ρ / (1 - ρ) = 1 / (1 - ρ) := by
      field_simp [hne1]
      ring
    have h3 : ρ * completedRiemannZeta₀ ρ = 1 / (1 - ρ) := by rwa [h2] at h1
    have h4 : completedRiemannZeta₀ ρ * ρ * (1 - ρ) = 1 := by
      calc completedRiemannZeta₀ ρ * ρ * (1 - ρ) =
              completedRiemannZeta₀ ρ * (ρ * (1 - ρ)) := by ring
        _ = (ρ * completedRiemannZeta₀ ρ) * (1 - ρ) := by ring
        _ = (1 / (1 - ρ)) * (1 - ρ) := by rw [h3]
        _ = 1 := by field_simp [hne1]
    field_simp [hne0, hne1]
    exact h4
  -- numerator at 1 - ρ is zero
  have hnum2 : (1 - ρ) * completedRiemannZeta₀ (1 - ρ) - 1 - (1 - ρ) / ρ = 0 := by
    rw [completedRiemannZeta₀_one_sub, hL0]
    field_simp [hne0, hne1]
    ring
  -- denominator at 1 - ρ is nonzero
  have hD2 : 2 * π ^ (-(1 - ρ) / 2) * Complex.Gamma ((1 - ρ) / 2 + 1) ≠ 0 := by
    intro h
    have hπ : (π : ℂ) ^ (-(1 - ρ) / 2) ≠ 0 := by
      rw [Ne, Complex.cpow_eq_zero_iff, not_and_or]
      norm_num
    have hG : Complex.Gamma ((1 - ρ) / 2 + 1) ≠ 0 := by
      apply Complex.Gamma_ne_zero
      intro m
      by_contra hm
      have h1 : (1 - ρ) / 2 + 1 = -(m : ℂ) := hm
      have h2 : 1 - ρ = -(2 * (m + 1) : ℂ) := by
        field_simp at h1
        linear_combination h1 - (2 : ℂ)
      have h3 : ρ = (2 * (m + 1) + 1 : ℂ) := by
        have h3' : ρ = 1 - (-(2 * (m + 1) : ℂ)) := by
          rw [show ρ = 1 - (1 - ρ) by ring, h2]
        rw [h3']
        ring
      have : ρ.im = 0 := by
        rw [h3]
        simp
      contradiction
    rcases mul_eq_zero.mp (show (2 * π ^ (-(1 - ρ) / 2)) * Complex.Gamma ((1 - ρ) / 2 + 1) = 0 from h) with hL | hR
    · rcases mul_eq_zero.mp hL with h2 | hπ'
      · norm_num at h2
      · exact hπ hπ'
    · exact hG hR
  -- conclude
  rw [riemannZeta_eq_mul_completedRiemannZeta₀]
  rw [div_eq_iff hD2]
  simpa using hnum2

/-! ## 8.  Non-trivial zeros lie in the open vertical strip 0 < Re < 1 -/

/-- A non-real zero of `riemannZeta` satisfies `0 < ρ.re < 1`. -/
theorem zetaNontrivialInStrip (ρ : ℂ) (hρ : riemannZeta ρ = 0) (him : ρ.im ≠ 0) :
    0 < ρ.re ∧ ρ.re < 1 := by
  refine ⟨?_, ?_⟩
  · -- 0 < ρ.re:  if ρ.re ≤ 0 then (1 - ρ).re ≥ 1, where ζ ≠ 0,
      -- contradicting the FE pairing of non-real zeros.
    by_contra h
    push Not at h  -- h : 0 ≥ ρ.re
    have hre1 : 1 ≤ (1 - ρ).re := by
      rw [Complex.sub_re]
      have hone : (1 : ℂ).re = (1 : ℝ) := by norm_num
      rw [hone]
      linarith
    have hnz1 : riemannZeta (1 - ρ) ≠ 0 := riemannZeta_ne_zero_of_one_le_re hre1
    have hfe : riemannZeta (1 - ρ) = 0 := zetaFeZero ρ hρ him
    contradiction
  · -- ρ.re < 1:  if ρ.re ≥ 1 then ζ ρ ≠ 0 directly.
    by_contra h
    push Not at h  -- h : 1 ≤ ρ.re
    have := riemannZeta_ne_zero_of_one_le_re h
    contradiction

/-! ## 9.  Finitely many non-real zeros up to each height -/

/-- The slice `{ρ | ζρ = 0 ∧ ρ.im ≠ 0 ∧ 0 < ρ.im ≤ t}` is finite. -/
theorem zetaSliceFinite (t : ℝ) (ht : 0 < t) :
    ({ρ | riemannZeta ρ = 0 ∧ ρ.im ≠ 0} ∩ {ρ | 0 < ρ.im ∧ ρ.im ≤ t}).Finite := by
  have hsub : {ρ | riemannZeta ρ = 0 ∧ ρ.im ≠ 0} ∩ {ρ | 0 < ρ.im ∧ ρ.im ≤ t} ⊆
      {ρ : ℂ | 0 ≤ ρ.re ∧ ρ.re ≤ 1 ∧ 0 ≤ ρ.im ∧ ρ.im ≤ t} ∩ riemannZetaZeros := by
    intro ρ ⟨⟨hρ, _⟩, ⟨him, himt⟩⟩
    have hs := zetaNontrivialInStrip ρ hρ (by linarith)
    refine ⟨⟨by linarith [hs.1], by linarith [hs.2], by linarith, by exact himt⟩, ?_⟩
    exact Set.mem_preimage.mpr (by simp [hρ])
  have hbox : IsCompact {ρ : ℂ | 0 ≤ ρ.re ∧ ρ.re ≤ 1 ∧ 0 ≤ ρ.im ∧ ρ.im ≤ t} := by
    have heq : {ρ : ℂ | 0 ≤ ρ.re ∧ ρ.re ≤ 1 ∧ 0 ≤ ρ.im ∧ ρ.im ≤ t} =
        (fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I) '' (Icc (0 : ℝ) 1 ×ˢ Icc 0 t) := by
      ext ρ
      constructor
      · rintro ⟨hre, hre', him, himt⟩
        use ⟨ρ.re, ρ.im⟩
        refine ⟨?_, ?_⟩
        · simp only [Set.mem_prod, Set.mem_Icc]
          exact ⟨⟨hre, hre'⟩, ⟨him, himt⟩⟩
        · have hre : ((ρ.re : ℂ) + (ρ.im : ℂ) * I).re = ρ.re := by
            simp [Complex.add_re, Complex.mul_re, ofReal_re]
          have him' : ((ρ.re : ℂ) + (ρ.im : ℂ) * I).im = ρ.im := by
            simp [Complex.add_im, Complex.mul_im, ofReal_im]
          exact Complex.ext_iff.mpr ⟨hre, him'⟩
      · rintro ⟨p, ⟨hp, hρ⟩⟩
        have hpr : 0 ≤ p.1 ∧ p.1 ≤ 1 ∧ 0 ≤ p.2 ∧ p.2 ≤ t := by
          simp only [Set.mem_prod, Set.mem_Icc, and_assoc] at hp
          exact hp
        rw [← hρ]
        simp [Complex.add_re, Complex.mul_re, ofReal_re,
              Complex.add_im, Complex.mul_im, ofReal_im]
        exact hpr
    have hcont : Continuous (fun p : ℝ × ℝ => (p.1 : ℂ) + (p.2 : ℂ) * I) := by
      continuity
    rw [heq]
    exact IsCompact.image (isCompact_Icc.prod isCompact_Icc) hcont
  have hfin : ({ρ : ℂ | 0 ≤ ρ.re ∧ ρ.re ≤ 1 ∧ 0 ≤ ρ.im ∧ ρ.im ≤ t} ∩ riemannZetaZeros).Finite :=
    hbox.inter_riemannZetaZeros_finite
  exact hfin.subset hsub

/-! ## 10.  The concrete zero set -/

/-- The `ZeroSet` concretized on the non-real zeros of Mathlib's
    `riemannZeta`.  All five structural fields are PROVEN (this module). -/
def qz : ZeroSet :=
  { Z := {ρ | riemannZeta ρ = 0 ∧ ρ.im ≠ 0},
    nonReal := by
      rintro ρ ⟨_, him⟩
      exact him,
    conj := by
      rintro ρ ⟨hρ, him⟩
      refine ⟨zetaConjZero ρ hρ him, ?_⟩
      by_contra h
      rw [show (star ρ).im = -ρ.im by simp] at h
      have := neg_eq_zero.mp h
      contradiction,
    fe := by
      rintro ρ ⟨hρ, him⟩
      refine ⟨zetaFeZero ρ hρ him, ?_⟩
      by_contra h
      rw [show (1 - ρ).im = -ρ.im by simp] at h
      have := neg_eq_zero.mp h
      contradiction,
    finite := zetaSliceFinite }

/-- The `hqz` field, derived at `qz` —  no longer an assumption. -/
theorem hqzQz : ∀ ρ ∈ qz.Z, riemannZeta ρ = 0 := by
  intro ρ ⟨hρ, _⟩
  exact hρ

/-! ## 11.  The B25 endpoint with `q` concretized at `qz` -/

/-- The B25 `#ELEVEN` continuum-anchor endpoint, instantiated at the
    concrete zero set `qz`:  `hqz` is discharged (derived), the other
    four inputs remain named.  No RH claim. -/
theorem rh_program78_qz_continuumAnchor_PT2
    (hzF : Z78ContinuumAnchor.externalZeroFree78ContinuumAnchor)
    (honline : ∀ ρ ∈ qz.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) < (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (Qside : ℝ × ℝ → ℝ)
    (hPT2 : WinC.allOnLineUpTo qz WinC.tPT2)
    (hOffC : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ Z78ContinuumAnchor.continuumAnchorD0max → ¬ P12.offPair qz t0 d0) :
    B0.RH qz :=
  RHEnd.rh_program78_stripfront_mach_unifiedContinuumAnchor_PT2 qz hzF hqzQz honline
    Qside hPT2 hOffC

end ZetaConcrete
