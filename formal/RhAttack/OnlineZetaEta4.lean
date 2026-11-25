import Mathlib
import RhAttack.OnlineZetaEta
import RhAttack.OnlineZetaEta2
import RhAttack.OnlineZetaEta3

set_option maxHeartbeats 400000

open Set Complex Real Filter Topology unitInterval
open BigOperators

namespace OnlineZetaEta4

/-!
## Phase 2.2c — analyticity of `etaStrip` and the eta–zeta identity for `0 < Re s`

No RH claim. Pure analysis:

1. The eta partial sums are differentiable on the right half-plane
   `{s : 0 < s.re}`.
2. By local uniform convergence (Phase 2.2b) and the Weierstrass theorem
   (`TendstoLocallyUniformlyOn.differentiableOn`), `etaStrip` is
   differentiable, hence analytic, on the right half-plane.
3. The function `s ↦ (1 - 2^(1 - s)) * riemannZeta s` is analytic on
   `U = {s : 0 < s.re, s ≠ 1}`.
4. `U` is preconnected (a union of two path-connected pieces sharing a point).
5. The identity theorem (`AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq`)
   extends `OnlineZetaEta.etaIdentity` (proved for `1 < Re s`) to all of `U`.

The terminal identity:

```
etaStrip s = (1 - 2^(1 - s)) * riemannZeta s    for 0 < s.re, s ≠ 1
```
-/

/-! ### The domain `U` -/

def U : Set ℂ := {s : ℂ | 0 < s.re ∧ s ≠ 1}

/-- The right half-plane is open. -/
theorem isOpen_halfPlaneRePos : IsOpen {s : ℂ | 0 < s.re} := by
  apply IsOpen.preimage (by continuity : Continuous fun s : ℂ => s.re)
  exact isOpen_Ioi

/-- `U = {0 < Re s} \ {1}` is open. -/
theorem isOpen_U : IsOpen U := by
  rw [U]
  exact (isOpen_halfPlaneRePos).inter (isOpen_compl_singleton : IsOpen ({1}ᶜ : Set ℂ))

/-! ### Differentiability of the eta terms and partial sums -/

/-- Each eta term `s ↦ etaTerm s n` is differentiable on the right half-plane. -/
theorem etaTermDifferentiableOn (n : ℕ) :
    DifferentiableOn ℂ (fun s : ℂ => OnlineZetaEta2.etaTerm s n) {s : ℂ | 0 < s.re} := by
  intro s hs
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  by_cases hn : n = 0
  · subst n
    have heq : (fun x : ℂ => OnlineZetaEta2.etaTerm x 0) =ᶠ[𝓝 s] (fun _ : ℂ => (0 : ℂ)) := by
      have hz := zero_cpow_eq_nhds hs0
      filter_upwards [hz] with x hx
      have heta : OnlineZetaEta2.etaTerm x 0 = 0 := by
        simp only [OnlineZetaEta2.etaTerm]
        have hz0 : (↑(0 : ℕ) : ℂ) ^ x = (0 : ℂ) := by
          rw [Nat.cast_zero]
          simpa using hx
        rw [hz0]
        norm_num
      simpa using heta
    have hdiff : DifferentiableAt ℂ (fun x : ℂ => OnlineZetaEta2.etaTerm x 0) s :=
      (heq.differentiableAt_iff).mpr (differentiableAt_const (0 : ℂ))
    exact hdiff.differentiableWithinAt
  ·
    have hnz : (n : ℂ) ≠ 0 := by
      intro h
      push_cast at h
      simp_all
    have hterm : (fun s : ℂ => OnlineZetaEta2.etaTerm s n) =
        (fun s : ℂ => (-1 : ℂ) ^ (n - 1) * ((n : ℂ) ^ (-s))) := by
      funext s
      simp only [OnlineZetaEta2.etaTerm]
      have hinv : (1 / (n : ℂ) ^ s : ℂ) = (n : ℂ) ^ (-s) := by
        rw [one_div, ← Complex.cpow_neg (n : ℂ) s]
      rw [hinv]
    have hf : Differentiable ℂ (fun w : ℂ => (n : ℂ) ^ w) := by
      haveI : NeZero (n : ℂ) := ⟨hnz⟩
      exact differentiable_const_cpow_of_neZero (n : ℂ)
    have hcomp : Differentiable ℂ (fun s : ℂ => (n : ℂ) ^ (-s)) :=
      hf.comp differentiable_neg
    have htermD : DifferentiableOn ℂ
        (fun s : ℂ => (-1 : ℂ) ^ (n - 1) * ((n : ℂ) ^ (-s))) {s : ℂ | 0 < s.re} := by
      refine DifferentiableOn.const_mul ?_ ((-1 : ℂ) ^ (n - 1))
      exact hcomp.differentiableOn.mono (subset_univ _)
    rw [hterm]
    exact htermD s hs

/-- Each eta partial sum `s ↦ etaPartial s N` is differentiable on the right
half-plane. -/
theorem etaPartialDifferentiableOn (N : ℕ) :
    DifferentiableOn ℂ (fun s : ℂ => OnlineZetaEta2.etaPartial s N) {s : ℂ | 0 < s.re} := by
  have hsum : DifferentiableOn ℂ
      (fun s : ℂ => ∑ n ∈ Finset.range (N + 1), (fun s : ℂ => OnlineZetaEta2.etaTerm s n) s)
      {s : ℂ | 0 < s.re} :=
    DifferentiableOn.fun_sum fun n hn => etaTermDifferentiableOn n
  exact DifferentiableOn.congr hsum (by
    intro x hx
    dsimp only [OnlineZetaEta2.etaPartial])

/-! ### Local uniform convergence, then differentiability of `etaStrip` -/

/-- The eta partial sums converge locally uniformly to `etaStrip` on the right
half-plane. -/
theorem etaPartialTendstoLocallyUniformlyOn :
    TendstoLocallyUniformlyOn (fun (N : ℕ) (s : ℂ) => OnlineZetaEta2.etaPartial s N)
      OnlineZetaEta3.etaStrip atTop {s : ℂ | 0 < s.re} := by
  intro u hu s₀ hs₀
  have htfu := OnlineZetaEta3.etaPartialSumsUniformOn s₀ hs₀
  have hball : Metric.ball s₀ (s₀.re / 2) ∈ 𝓝[{s : ℂ | 0 < s.re}] s₀ := by
    rw [mem_nhdsWithin_iff_exists_mem_nhds_inter]
    use Metric.ball s₀ (s₀.re / 2)
    constructor
    · exact IsOpen.mem_nhds Metric.isOpen_ball (Metric.mem_ball_self (half_pos hs₀))
    · intro x hx
      exact hx.1
  exact ⟨Metric.ball s₀ (s₀.re / 2), hball, htfu u hu⟩

/-- `etaStrip` is differentiable on the right half-plane (Weierstrass theorem). -/
theorem etaStripDifferentiableOn :
    DifferentiableOn ℂ OnlineZetaEta3.etaStrip {s : ℂ | 0 < s.re} :=
  etaPartialTendstoLocallyUniformlyOn.differentiableOn
    (by
      apply eventually_atTop.2
      use 0
      intro N _
      exact etaPartialDifferentiableOn N)
    isOpen_halfPlaneRePos

/-- `etaStrip` is analytic on `U = {0 < Re s, s ≠ 1}`. -/
theorem etaStripAnalyticOnNhd : AnalyticOnNhd ℂ OnlineZetaEta3.etaStrip U := by
  rw [analyticOnNhd_iff_differentiableOn isOpen_U]
  exact (etaStripDifferentiableOn).mono (fun s hs => hs.1)

/-! ### The comparison function `g(s) = (1 - 2^(1-s)) · ζ(s)` -/

noncomputable def etaZetaFun (s : ℂ) : ℂ := (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s

/-- `s ↦ 2^(1 - s)` is entire. -/
theorem differentiable_twoPow : Differentiable ℂ (fun s : ℂ => (2 : ℂ) ^ (1 - s)) := by
  apply Differentiable.comp
  · exact differentiable_const_cpow_of_neZero (2 : ℂ)
  · exact (differentiable_const (1 : ℂ)).sub differentiable_id

/-- `etaZetaFun` is analytic on `U`. -/
theorem etaZetaFunAnalyticOnNhd : AnalyticOnNhd ℂ etaZetaFun U := by
  intro s hs
  have h1 : AnalyticAt ℂ (fun s : ℂ => 1 - (2 : ℂ) ^ (1 - s)) s := by
    have hd : DifferentiableOn ℂ (fun s : ℂ => 1 - (2 : ℂ) ^ (1 - s)) U := by
      intro x hx
      exact (Differentiable.const_sub differentiable_twoPow (1 : ℂ)).differentiableAt.differentiableWithinAt
    rw [analyticAt_iff_eventually_differentiableAt]
    filter_upwards [IsOpen.mem_nhds isOpen_U hs] with z hz
    exact (hd z hz).differentiableAt (IsOpen.mem_nhds isOpen_U hz)
  have h2 : AnalyticAt ℂ riemannZeta s :=
    analyticOn_riemannZeta s (by simpa using hs.2)
  exact (h1.mul h2).congr (by
    have hpi : ((fun x : ℂ => 1 - (2 : ℂ) ^ (1 - x)) * riemannZeta) =
        (fun x : ℂ => (1 - (2 : ℂ) ^ (1 - x)) * riemannZeta x) := by
      funext x
      simp only [Pi.mul_apply]
    have hpt : (fun x : ℂ => (1 - (2 : ℂ) ^ (1 - x)) * riemannZeta x) = etaZetaFun := by
      funext z
      dsimp only [etaZetaFun]
    rw [hpi, hpt])

/-! ### `U` is preconnected -/

/-- Every point of `{s : 1 ≤ Re s, s ≠ 1}` can be joined to `2` by the straight
segment, which stays in `1 ≤ Re s` and never hits `1`. -/
theorem isPathConnected_reGEOneSdiffOne :
    IsPathConnected {s : ℂ | 1 ≤ s.re ∧ s ≠ 1} := by
  refine ⟨(2 : ℂ), ⟨by norm_num, by norm_num⟩, fun y ⟨hyRe, hy1⟩ => ?_⟩
  have hleg (w : ℂ) (hwRe : 1 ≤ w.re) (hw1 : w ≠ 1) (u : ℝ) (hu : 0 ≤ u) (hu1 : u ≤ 1) :
      w + u • ((2 : ℂ) - w) ∈ {s : ℂ | 1 ≤ s.re ∧ s ≠ 1} := by
    have hre : (w + u • ((2 : ℂ) - w)).re = (1 - u) * w.re + u * 2 := by
      simp [add_re, smul_re, sub_re]
      norm_num
      ring
    have him : (w + u • ((2 : ℂ) - w)).im = w.im * (1 - u) := by
      simp [add_im, smul_im, sub_im]
      norm_num
      ring
    constructor
    · rw [hre]
      have h1u : 0 ≤ 1 - u := by linarith
      have hle : (1 - u) * 1 ≤ (1 - u) * w.re := by nlinarith
      nlinarith
    ·
      intro h
      have h1 : (w + u • ((2 : ℂ) - w)).re = 1 := by
        rw [h]
        norm_num
      have h2 : (w + u • ((2 : ℂ) - w)).im = 0 := by
        rw [h]
        norm_num
      rw [hre] at h1
      rw [him] at h2
      by_cases hu0 : u = 0
      ·
        have h1' : w.re = 1 := by
          rw [hu0] at h1
          norm_num at h1
          exact h1
        have h2' : w.im = 0 := by
          rw [hu0] at h2
          nlinarith
        have hw : w = 1 := by
          apply Complex.ext
          · exact h1'
          · exact h2'
        contradiction
      ·
        by_cases hu1' : u = 1
        ·
          rw [hu1'] at h1
          norm_num at h1
        ·
          have h0u : 0 < u := by
            by_contra h
            have h' : u ≤ 0 := by linarith
            have h0 : u = 0 := by linarith
            contradiction
          have h1u : u < 1 := by
            by_contra h
            have h' : u ≥ 1 := by linarith
            have h1' : u = 1 := by linarith
            contradiction
          have h1q : w.re = (1 - 2 * u) / (1 - u) := by
            have hne : (1 - u : ℝ) ≠ 0 := by linarith
            field_simp [hne]
            nlinarith
          have h1s : w.re < 1 := by
            rw [h1q]
            apply (div_lt_one (by linarith : 0 < 1 - u)).2
            linarith
          linarith
  let γ : I → ℂ := fun t => (2 : ℂ) + (t : ℝ) • (y - (2 : ℂ))
  have hγ : Continuous γ := by continuity
  have hγ0 : γ 0 = (2 : ℂ) := by
    dsimp only [γ]
    simp [smul_zero]
  have hγ1 : γ 1 = y := by
    dsimp only [γ]
    simp [one_smul]
  have hγt (t : I) : γ t = y + (1 - (t : ℝ)) • ((2 : ℂ) - y) := by
    dsimp only [γ]
    simp [Algebra.smul_def]
    ring
  exact ⟨⟨⟨γ, hγ⟩, hγ0, hγ1⟩, by
    intro t
    change (γ : I → ℂ) t ∈ {s : ℂ | 1 ≤ s.re ∧ s ≠ 1}
    rw [hγt t]
    exact hleg y hyRe hy1 (1 - (t : ℝ)) (by
      have h : (t : ℝ) ≤ 1 := t.2.2
      linarith) (by
      have h : 0 ≤ (t : ℝ) := t.2.1
      linarith)⟩


/-- Every point of `{s : 0 < Re s, Re s ≤ 1, s ≠ 1}` can be joined to `1/2`
by the straight segment, which stays in `0 < Re s ≤ 1` and never hits `1`. -/
theorem isPathConnected_reBandSdiffOne :
    IsPathConnected {s : ℂ | 0 < s.re ∧ s.re ≤ 1 ∧ s ≠ 1} := by
  refine ⟨(1 / 2 : ℂ), ⟨by norm_num, by norm_num⟩, fun y ⟨hyRe0, hyRe1, hy1⟩ => ?_⟩
  have hleg (w : ℂ) (hwRe0 : 0 < w.re) (hwRe1 : w.re ≤ 1) (hw1 : w ≠ 1) (u : ℝ) (hu : 0 ≤ u)
      (hu1 : u ≤ 1) :
      w + u • ((1 / 2 : ℂ) - w) ∈ {s : ℂ | 0 < s.re ∧ s.re ≤ 1 ∧ s ≠ 1} := by
    have hre : (w + u • ((1 / 2 : ℂ) - w)).re = (1 - u) * w.re + u * (1 / 2) := by
      simp [add_re, smul_re, sub_re]
      norm_num
      ring
    have him : (w + u • ((1 / 2 : ℂ) - w)).im = w.im * (1 - u) := by
      simp [add_im, smul_im, sub_im]
      norm_num
      ring
    refine ⟨?_, ?_, ?_⟩
    · rw [hre]
      by_cases hu1' : u = 1
      ·
        rw [hu1']
        norm_num
      ·
        by_cases hu0' : u = 0
        ·
          rw [hu0']
          nlinarith
        ·
          have hpos : 0 < 1 - u := by
            by_contra h
            have h' : 1 - u ≤ 0 := by linarith
            have h1' : u ≥ 1 := by linarith
            have h1'' : u = 1 := by linarith
            contradiction
          have hp : 0 < (1 - u) * w.re := by nlinarith
          linarith
    · rw [hre]
      have h1u : 0 ≤ 1 - u := by linarith
      have hle : (1 - u) * w.re ≤ 1 - u := by nlinarith
      nlinarith
    ·
      intro h
      have h1 : (w + u • ((1 / 2 : ℂ) - w)).re = 1 := by
        rw [h]
        norm_num
      have h2 : (w + u • ((1 / 2 : ℂ) - w)).im = 0 := by
        rw [h]
        norm_num
      rw [hre] at h1
      rw [him] at h2
      by_cases hu0 : u = 0
      ·
        have h1' : w.re = 1 := by
          rw [hu0] at h1
          norm_num at h1
          exact h1
        have h2' : w.im = 0 := by
          rw [hu0] at h2
          nlinarith
        have hw : w = 1 := by
          apply Complex.ext
          · exact h1'
          · exact h2'
        contradiction
      ·
        by_cases hu1' : u = 1
        ·
          rw [hu1'] at h1
          norm_num at h1
        ·
          have h0u : 0 < u := by
            by_contra h
            have h' : u ≤ 0 := by linarith
            have h0 : u = 0 := by linarith
            contradiction
          have h1u : u < 1 := by
            by_contra h
            have h' : u ≥ 1 := by linarith
            have h1' : u = 1 := by linarith
            contradiction
          have h1q : w.re = (1 - u / 2) / (1 - u) := by
            have hne : (1 - u : ℝ) ≠ 0 := by linarith
            field_simp [hne]
            nlinarith
          have h1s : 1 < w.re := by
            rw [h1q]
            apply (one_lt_div (by linarith : 0 < 1 - u)).2
            linarith
          linarith
  let γ : I → ℂ := fun t => (1 / 2 : ℂ) + (t : ℝ) • (y - (1 / 2 : ℂ))
  have hγ : Continuous γ := by continuity
  have hγ0 : γ 0 = (1 / 2 : ℂ) := by
    dsimp only [γ]
    simp [smul_zero]
  have hγ1 : γ 1 = y := by
    dsimp only [γ]
    simp [one_smul]
  have hγt (t : I) : γ t = y + (1 - (t : ℝ)) • ((1 / 2 : ℂ) - y) := by
    dsimp only [γ]
    simp [Algebra.smul_def]
    ring
  exact ⟨⟨⟨γ, hγ⟩, hγ0, hγ1⟩, by
    intro t
    change (γ : I → ℂ) t ∈ {s : ℂ | 0 < s.re ∧ s.re ≤ 1 ∧ s ≠ 1}
    rw [hγt t]
    exact hleg y hyRe0 hyRe1 hy1 (1 - (t : ℝ)) (by
      have h : (t : ℝ) ≤ 1 := t.2.2
      linarith) (by
      have h : 0 ≤ (t : ℝ) := t.2.1
      linarith)⟩


/-- A path-connected set is preconnected. -/
theorem isPathConnected_isPreconnected {s : Set ℂ} (h : IsPathConnected s) : IsPreconnected s := by
  intro u v hu hv hsub huN hvN
  obtain ⟨a, ha, hall⟩ := h
  obtain ⟨x, hx⟩ := huN
  obtain ⟨y, hy⟩ := hvN
  have hxy : JoinedIn s x y := (hall hx.1).symm.trans (hall hy.1)
  obtain ⟨γ, γin⟩ := hxy
  have hγc : Continuous (γ : I → ℂ) := γ.continuous_toFun
  have hPu : IsOpen ({t : I | γ t ∈ u}) := IsOpen.preimage hγc hu
  have hPv : IsOpen ({t : I | γ t ∈ v}) := IsOpen.preimage hγc hv
  have hsubI : (univ : Set I) ⊆ {t : I | γ t ∈ u} ∪ {t : I | γ t ∈ v} := by
    intro t _
    simpa [hsub, γin] using hsub (γin t)
  have hPuN : (univ ∩ {t : I | γ t ∈ u}).Nonempty := ⟨0, by simp [γ.source', hx.2]⟩
  have hPvN : (univ ∩ {t : I | γ t ∈ v}).Nonempty := ⟨1, by simp [γ.target', hy.2]⟩
  obtain ⟨t, ht⟩ :=
    isPreconnected_univ {t : I | γ t ∈ u} {t : I | γ t ∈ v} hPu hPv hsubI hPuN hPvN
  exact ⟨γ t, ⟨γin t, ht.2.1, ht.2.2⟩⟩

/-- `U = {0 < Re s, s ≠ 1}` is preconnected. -/
theorem isPreconnected_U : IsPreconnected U := by
  let A : Set ℂ := {s : ℂ | 1 ≤ s.re ∧ s ≠ 1}
  let B : Set ℂ := {s : ℂ | 0 < s.re ∧ s.re ≤ 1 ∧ s ≠ 1}
  have hA : IsPreconnected A := by
    dsimp only [A]
    exact isPathConnected_isPreconnected isPathConnected_reGEOneSdiffOne
  have hB : IsPreconnected B := by
    dsimp only [B]
    exact isPathConnected_isPreconnected isPathConnected_reBandSdiffOne
  have hsub : A ∪ B = U := by
    ext s
    simp only [U, A, B]
    constructor
    · intro h
      cases h with
      | inl hA =>
        have hA' : 1 ≤ s.re ∧ s ≠ 1 := hA
        exact ⟨by linarith [hA'.1], hA'.2⟩
      | inr hB =>
        have hB' : 0 < s.re ∧ s.re ≤ 1 ∧ s ≠ 1 := hB
        exact ⟨hB'.1, hB'.2.2⟩
    · intro hs
      by_cases h1 : 1 ≤ s.re
      · left
        exact ⟨h1, hs.2⟩
      · right
        exact ⟨hs.1, by linarith, hs.2⟩
  rw [← hsub]
  have h12 : (1 + Complex.I : ℂ) ∈ A ∩ B := by
    dsimp only [A, B]
    constructor <;> norm_num
  have hcom : (A ∩ B).Nonempty := ⟨1 + Complex.I, h12⟩
  exact IsPreconnected.union' hcom hA hB

/-! ### The identity theorem: the eta–zeta identity on `0 < Re s`, `s ≠ 1` -/

/-- On `{s : 1 < s.re}`, `etaStrip` agrees with `etaZetaFun`; this agreement
holds frequently at `2`. -/
theorem etaFreqEq : ∃ᶠ z in 𝓝[≠] (2 : ℂ), OnlineZetaEta3.etaStrip z = etaZetaFun z := by
  have heq1 : ∀ z, 1 < z.re → OnlineZetaEta3.etaStrip z = etaZetaFun z := by
    intro z h1
    rw [etaZetaFun, OnlineZetaEta3.etaStripAgreesEtaSeries z h1, OnlineZetaEta.etaIdentity z h1]
  have hopen : IsOpen {s : ℂ | 1 < s.re} := by
    apply IsOpen.preimage (by continuity : Continuous fun s : ℂ => s.re)
    exact isOpen_Ioi
  have h2 : {s : ℂ | 1 < s.re} ∈ 𝓝 (2 : ℂ) := hopen.mem_nhds (by norm_num)
  have hneBot2 : NeBot (𝓝[≠] (2 : ℂ) ⊓ 𝓟 {z : ℂ | OnlineZetaEta3.etaStrip z = etaZetaFun z}) := by
    by_contra h
    rw [neBot_iff] at h
    push_neg at h
    rw [inf_eq_bot_iff] at h
    obtain ⟨U, hU, V, hV, hUV⟩ := h
    obtain ⟨A, hA, B, hB, hUeq⟩ := mem_inf_iff.mp hU
    obtain ⟨r, hr, hAr⟩ := Metric.mem_nhds_iff.mp hA
    let z0 : ℂ := ((2 : ℝ) + r / 2 : ℝ)
    have hsub : z0 - (2 : ℂ) = ((r / 2 : ℝ) : ℂ) := by
      dsimp only [z0]
      have hreal : ((2 : ℝ) + r / 2 - 2 : ℝ) = r / 2 := by ring
      simpa [Complex.ofReal_sub] using hreal
    have hzb : z0 ∈ Metric.ball (2 : ℂ) r := by
      rw [Metric.mem_ball, dist_eq_norm]
      rw [hsub]
      have hnorm : ‖((r / 2 : ℝ) : ℂ)‖ = r / 2 := by
        rw [norm_real, Real.norm_eq_abs]
        exact abs_of_nonneg (by linarith)
      rw [hnorm]
      linarith [hr]
    have hzA : z0 ∈ A := hAr hzb
    have hz2 : z0 ≠ (2 : ℂ) := by
      intro heq
      have h0 : ((r / 2 : ℝ) : ℂ) = (0 : ℂ) := by
        calc ((r / 2 : ℝ) : ℂ) = z0 - (2 : ℂ) := hsub.symm
          _ = (2 : ℂ) - (2 : ℂ) := by rw [heq]
          _ = 0 := by norm_num
      have h0' : (r / 2 : ℝ) = 0 := Complex.ofReal_inj.mp h0
      have h0'' : 0 < r / 2 := by linarith [hr]
      linarith
    have hz2c : z0 ∈ ({2} : Set ℂ)ᶜ := by simpa using hz2
    have hBsub : ({2} : Set ℂ)ᶜ ⊆ B := by
      simpa [Filter.mem_principal] using hB
    have hzB : z0 ∈ B := hBsub hz2c
    have hzU : z0 ∈ U := by
      rw [hUeq]
      exact ⟨hzA, hzB⟩
    have hznotV : z0 ∉ V := by
      intro hv
      have h1 : z0 ∈ U ∩ V := ⟨hzU, hv⟩
      rw [hUV] at h1
      simp at h1
    have hre : z0.re = (2 : ℝ) + r / 2 := by
      dsimp only [z0]
      exact Complex.ofReal_re _
    have hzP : OnlineZetaEta3.etaStrip z0 = etaZetaFun z0 :=
      heq1 z0 (by rw [hre]; linarith [hr])
    have hVsub : {z : ℂ | OnlineZetaEta3.etaStrip z = etaZetaFun z} ⊆ V := by
      simpa [Filter.mem_principal] using hV
    have hzV : z0 ∈ V := hVsub hzP
    exact hznotV hzV
  exact (frequently_iff_neBot (l := 𝓝[≠] (2 : ℂ))
    (p := fun z : ℂ => OnlineZetaEta3.etaStrip z = etaZetaFun z)).2 hneBot2

/-- **The strip eta–zeta identity.** For `0 < Re s` and `s ≠ 1`,

```
etaStrip s = (1 - 2^(1 - s)) * riemannZeta s.
```

This is the extension of `OnlineZetaEta.etaIdentity` (proved for `1 < Re s`)
by the identity theorem: both sides are analytic on the preconnected set
`U = {0 < Re s, s ≠ 1}` and agree on the open set `{1 < Re s}`.

No RH claim. -/
theorem etaIdentityStrip (s : ℂ) (hs : 0 < s.re) (hs1 : s ≠ 1) :
    OnlineZetaEta3.etaStrip s = etaZetaFun s := by
  have hf : AnalyticOnNhd ℂ OnlineZetaEta3.etaStrip U := etaStripAnalyticOnNhd
  have hg : AnalyticOnNhd ℂ etaZetaFun U := etaZetaFunAnalyticOnNhd
  have hU : IsPreconnected U := isPreconnected_U
  have hz0 : (2 : ℂ) ∈ U := by
    rw [U]
    norm_num
  have heq : EqOn OnlineZetaEta3.etaStrip etaZetaFun U :=
    hf.eqOn_of_preconnected_of_frequently_eq hg hU hz0 etaFreqEq
  have heqs : s ∈ U := ⟨hs, hs1⟩
  exact heq heqs

end OnlineZetaEta4
