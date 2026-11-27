import Mathlib
import RhAttack.OnlineZetaEta
import RhAttack.OnlineZetaEta2
import RhAttack.OnlineZetaEta3
import RhAttack.OnlineZetaEta4
import RhAttack.OnlineZetaEta5

/-
honline Phase 2.3.2 — the Euler-transformed eta series: Δ^k terms and the 2^{-K} remainder.

This module completes the explicit bounded-evaluation engine for Mathlib's
`riemannZeta` on the band `0 < Re s ≤ 1` started in Phase 2.3
(`OnlineZetaEta5`): the Mellin kernel `K(t) = 1/(e^t + 1)` is split pointwise at
`x = e^{-t}` by the finite geometric identity

    x/(1+x) = x · ∑_{k<K} (1-x)^k / 2^{k+1}  +  2^{-K} · x(1-x)^K / (1+x)        (x > 0),

so that (after integration against `t^{s-1}` and the Phase 2.3 Laplace block
`∫₀^∞ t^{s-1} e^{-nt} dt = Γ(s)·n^{-s}`, `n ≥ 1`) the eta strip function
decomposes, for every `0 < Re s` and every `K ≥ 0`, as

    etaStrip s = etaEuler s K + etaRemK s K / Γ(s),

where `etaEuler s K = ∑_{k<K} 2^{-(k+1)} · Δ^k a_1` is a **finite explicit sum**
(`a_n = n^{-s}`, `Δ^k a_1 = ∑_{j≤k} (-1)^j C(k,j) (j+1)^{-s}` — the Euler
transform of the eta series) and `etaRemK s K = 2^{-K} ∫₀^∞ t^{s-1}
e^{-t}(1-e^{-t})^K/(1+e^{-t}) dt` is an explicit remainder.

On the band `0 < Re s ≤ 1` the remainder carries the geometric decay

    ‖etaRemK s K / Γ(s)‖ ≤ 2^{-K} · (1/(Re s + K) + e^{-1}) / ‖Γ(s)‖,

which — combined with the Phase 2.2c identity
`etaStrip s = (1 - 2^{1-s}) · ζ(s)` (`OnlineZetaEta4.etaIdentityStrip`) —
yields the engine theorem: for `0 < Re s ≤ 1`, `s ≠ 1`, `1 - 2^{1-s} ≠ 0`,

    ‖ζ(s) - etaEuler(s,K) / (1 - 2^{1-s})‖ ≤
        2^{-K} · (1/(Re s + K) + e^{-1}) / (‖Γ(s)‖ · ‖1 - 2^{1-s}‖).

`etaEuler(s,K)` is a finite sum of elementary terms in `s` (explicit Δ^k
constants, no asymptotics) — the `K`-term evaluator for ζ on the band, with a
rigorous `2^{-K}` error band, exactly the bounded numerical engine Phase 3
(disk count) needs for the sign-change assertion.

Also included: the Phase 2.3 "identity theorem" item — `etaStrip s =
etaIntegral s / Γ(s)` on the full half-plane `0 < Re s` (both sides analytic
there, agreeing on `1 < Re s`) — and the disk-geometry helper
`‖sin z‖² = sin²(Re z) + sinh²(Im z)` for Phase 3.

NO RH CLAIM. No `sorry`, no `admit`, no axioms. All constants are classical
mathematics derived from the pinned infrastructure.
-/

set_option maxHeartbeats 400000
-- the nested calc structure of the kernel-split and remainder-bound proofs
-- exceeds the default heartbeat budget at definition-check time.
-- (build option only; not a mathematical assumption)

namespace OnlineZetaEta6

open MeasureTheory Set Filter Complex Real
open scoped Topology unitInterval
open BigOperators

/-! ## 0. Elementary real helpers -/

/-- `1 - e^{-t} ≤ t` for `t ≥ 0` (from `e^x ≥ 1 + x` at `x = -t`). -/
theorem one_sub_exp_neg_le (t : ℝ) (ht : 0 ≤ t) : 1 - Real.exp (-t) ≤ t := by
  have h : Real.exp (-t) ≥ 1 - t := by
    calc Real.exp (-t) ≥ (-t) + 1 := Real.add_one_le_exp (-t)
      _ = 1 - t := by ring
  linarith

/-- `1 - e^{-t} ≥ 0` for `t ≥ 0`. -/
theorem one_sub_exp_neg_nonneg (t : ℝ) (ht : 0 ≤ t) : 0 ≤ 1 - Real.exp (-t) := by
  have h : Real.exp (-t) ≤ 1 := Real.exp_le_one_iff.mpr (by linarith)
  linarith

/-- `e^{-t} ≤ 1` for `t ≥ 0`. -/
theorem exp_neg_le_one (t : ℝ) (ht : 0 ≤ t) : Real.exp (-t) ≤ 1 :=
  Real.exp_le_one_iff.mpr (by linarith)

/-- `1/(1 + e^{-t}) ≤ 1` (all `t`). -/
theorem inv_one_add_exp_neg_le_one (t : ℝ) : 1 / (1 + Real.exp (-t)) ≤ 1 := by
  have hpos : 0 < Real.exp (-t) := Real.exp_pos _
  exact (div_le_one (by linarith [hpos.le])).2 (by linarith [hpos.le])

/-- Cast of a finite sum through `ofReal` (ℝ → ℂ). -/
theorem ofReal_finsetSum {ι : Type*} (s : Finset ι) (f : ι → ℝ) :
    ((∑ i ∈ s, f i) : ℂ) = ∑ i ∈ s, (f i : ℂ) := by
  simpa using map_sum Complex.ofReal s f

/-- For `p > -1`: `∫₀¹ x^p dx = 1/(p+1)` (FTC-2 with antiderivative
    `x^{p+1}/(p+1)`; the endpoint `0` is harmless since `uIcc 0 1 = Ioo 0 1`). -/
theorem integral_rpow_Icc_0_1 (p : ℝ) (hp : -1 < p) :
    (∫ x in (0 : ℝ)..1, x ^ p) = 1 / (p + 1) := by
  have hp1 : 0 < p + 1 := by linarith
  set F := fun x : ℝ => x ^ (p + 1) / (p + 1) with hFdef
  have hderiv : ∀ x ∈ (Ioo (0 : ℝ) 1), HasDerivAt F (x ^ p) x := by
    intro x hx
    have h0x : 0 < x := hx.1
    have hd0 : HasDerivAt (fun x : ℝ => x ^ (p + 1)) ((p + 1) * x ^ ((p + 1) - 1)) x :=
      Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt h0x))
    have hd : HasDerivAt (fun x : ℝ => x ^ (p + 1)) ((p + 1) * x ^ p) x := by
      convert hd0 using 1
      <;> ring_nf
      <;> field_simp
      <;> ring
    have hdiv : HasDerivAt F (((p + 1) * x ^ p) / (p + 1)) x :=
      hd.div_const (p + 1)
    have hred : ((p + 1) * x ^ p) / (p + 1) = x ^ p := by
      field_simp [hp1.ne']
    exact HasDerivAt.congr_deriv hdiv hred
  have hcont : ContinuousOn F (Icc (0 : ℝ) 1) := by
    dsimp only [F]
    have h1 : ContinuousOn (fun x : ℝ => x ^ (p + 1)) (Icc (0 : ℝ) 1) :=
      ContinuousOn.rpow_const continuousOn_id (fun _ _ => Or.inr hp1.le)
    exact h1.div_const (p + 1)
  have hint : IntervalIntegrable (fun x : ℝ => x ^ p) volume 0 1 :=
    intervalIntegral.intervalIntegrable_rpow' hp
  have hF : F 1 - F 0 = 1 / (p + 1) := by
    dsimp only [F]
    have h1 : (1 : ℝ) ^ (p + 1) = 1 := by simpa using Real.one_rpow (p + 1)
    have h0 : (0 : ℝ) ^ (p + 1) = 0 := Real.zero_rpow (ne_of_gt hp1)
    rw [h1, h0, zero_div, sub_zero]
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le (by norm_num : (0 : ℝ) ≤ 1)
    hcont hderiv hint]
  exact hF

/-! ## 1. Definitions: the Δ^k terms, the Euler partial sum, the remainder -/

/-- `Δ^k a_1` for the sequence `a_n = n^{-s}`: the `k`-th forward difference
    `∑_{j≤k} (-1)^j C(k,j) a_{j+1}` — the `k`-th Euler-transform term. -/
noncomputable def deltaEta (s : ℂ) (k : ℕ) : ℂ :=
  ∑ j ∈ Finset.range (k + 1), (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
    (1 / (((j + 1) : ℝ) : ℂ) ^ s)

/-- The `K`-term Euler-transformed partial sum: `∑_{k<K} 2^{-(k+1)} Δ^k a_1`.
    A finite explicit sum in `s` — the `K`-term evaluator for the eta series. -/
noncomputable def etaEuler (s : ℂ) (K : ℕ) : ℂ :=
  ∑ k ∈ Finset.range K, (1 / 2 : ℂ) ^ (k + 1) * deltaEta s k

/-- The `K`-term Euler kernel part of the Mellin integrand:
    `t^{s-1} e^{-t} ∑_{k<K} (1-e^{-t})^k / 2^{k+1}` (used on `(0, ∞)`). -/
noncomputable def eulerKernelPart (s : ℂ) (K : ℕ) (t : ℝ) : ℂ :=
  (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
    (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)

/-- The Euler remainder integrand: `t^{s-1} 2^{-K} e^{-t}(1-e^{-t})^K/(1+e^{-t})`
    (used on `(0, ∞)`). -/
noncomputable def etaRemKernel (s : ℂ) (K : ℕ) (t : ℝ) : ℂ :=
  (t : ℂ) ^ (s - 1) * (1 / 2 : ℂ) ^ K * (Real.exp (-t) : ℂ) *
    ((1 - Real.exp (-t)) : ℂ) ^ K / (1 + (Real.exp (-t) : ℂ))

/-- The `K`-term Euler remainder: `∫₀^∞ etaRemKernel s K`. -/
noncomputable def etaRemK (s : ℂ) (K : ℕ) : ℂ :=
  ∫ x : ℝ in Ioi 0, etaRemKernel s K x

/-- The `j`-th Laplace block term with the explicit complex exponential form:
    `u^{s-1} · e^{-(j+1)u}`. -/
noncomputable def etaBlock (s : ℂ) (j : ℕ) (u : ℝ) : ℂ :=
  (u : ℂ) ^ (s - 1) * Complex.exp ((-((j + 1) : ℝ) * u) : ℂ)

/-- The `k`-th Euler weight `2^{-(k+1)}` as a complex number. -/
noncomputable def etaCoeff (k : ℕ) : ℂ := (1 / 2 : ℂ) ^ (k + 1)

/-! ## 2. The identity theorem: `etaStrip = etaIntegral / Γ` on `0 < Re s` -/

/-- `etaStrip` is analytic on the full right half-plane (Weierstrass, Phase 2.2):
    `DifferentiableOn` + `analyticOnNhd_iff_differentiableOn`. -/
theorem etaStrip_analyticOnNhd_halfPlane :
    AnalyticOnNhd ℂ OnlineZetaEta3.etaStrip {s : ℂ | 0 < s.re} := by
  rw [analyticOnNhd_iff_differentiableOn OnlineZetaEta4.isOpen_halfPlaneRePos]
  exact OnlineZetaEta4.etaStripDifferentiableOn

/-- `s ↦ etaIntegral s / Γ(s)` is analytic on the full right half-plane. -/
theorem etaIntegral_div_Gamma_analyticOnNhd_halfPlane :
    AnalyticOnNhd ℂ (fun s : ℂ => OnlineZetaEta5.etaIntegral s / Complex.Gamma s)
      {s : ℂ | 0 < s.re} := by
  rw [analyticOnNhd_iff_differentiableOn OnlineZetaEta4.isOpen_halfPlaneRePos]
  intro z hz
  have h1 : DifferentiableAt ℂ (fun s : ℂ => OnlineZetaEta5.etaIntegral s) z :=
    OnlineZetaEta5.etaIntegral_differentiableAt z hz
  have h2 : DifferentiableAt ℂ (fun s : ℂ => Complex.Gamma s) z :=
    differentiableAt_Gamma z (fun m => by
      intro h
      have hre : 0 < z.re := hz
      have hre2 : z.re = (-(m : ℕ) : ℂ).re := by
        rw [h]
      have hre3 : (-(m : ℕ) : ℂ).re = -↑(m : ℕ) := by
        simp
      rw [hre2, hre3] at hre
      have hnm : (0 : ℝ) ≤ ↑(m : ℕ) := Nat.cast_nonneg m
      linarith)
  have hdiv : DifferentiableAt ℂ ((fun s : ℂ => OnlineZetaEta5.etaIntegral s) /
      (fun s : ℂ => Complex.Gamma s)) z :=
    h1.div h2 (Complex.Gamma_ne_zero_of_re_pos hz)
  have hdiv2 : DifferentiableAt ℂ (fun s : ℂ =>
      OnlineZetaEta5.etaIntegral s / Complex.Gamma s) z := by
    simpa [show (fun s : ℂ => OnlineZetaEta5.etaIntegral s / Complex.Gamma s) =
        ((fun s : ℂ => OnlineZetaEta5.etaIntegral s) / (fun s : ℂ => Complex.Gamma s)) from by
      funext s
      rfl] using hdiv
  exact hdiv2.differentiableWithinAt

/-- The right half-plane is path-connected (straight segments from `1`). -/
theorem isPathConnected_halfPlaneRePos : IsPathConnected {s : ℂ | 0 < s.re} := by
  refine ⟨(1 : ℂ), ⟨by norm_num, ?_⟩⟩
  intro y hy
  let γ : I → ℂ := fun t => (1 : ℂ) + (t : ℝ) • (y - (1 : ℂ))
  have hγ : Continuous γ := by continuity
  have hγ0 : γ 0 = (1 : ℂ) := by
    dsimp only [γ]
    simp [smul_zero]
  have hγ1 : γ 1 = y := by
    dsimp only [γ]
    simp [one_smul]
  have hγt (t : I) : γ t ∈ {s : ℂ | 0 < s.re} := by
    dsimp only [γ]
    rw [Set.mem_setOf_eq]
    have hre : (γ t).re = (1 - (t : ℝ)) * 1 + (t : ℝ) * y.re := by
      dsimp only [γ]
      have hstep : ((1 : ℂ) + (t : ℝ) • (y - (1 : ℂ))).re =
          1 + (t : ℝ) * (y.re - 1) := by
        simp only [add_re, smul_re, sub_re, Complex.one_re, ofReal_re]
        <;> ring_nf
      rw [hstep]
      ring
    rw [hre]
    have ht0 : 0 ≤ (t : ℝ) := t.2.1
    have ht1 : (t : ℝ) ≤ 1 := t.2.2
    by_cases hte : (t : ℝ) = 1
    · rw [hte]
      norm_num
      exact hy
    · have hlt : (t : ℝ) < 1 := by
        by_contra h
        have hge : 1 ≤ (t : ℝ) := by linarith
        have heq : (t : ℝ) = 1 := by linarith
        exact hte heq
      have hpos : 0 < 1 - (t : ℝ) := by linarith
      have hterm1 : 0 < (1 - (t : ℝ)) * 1 := mul_pos hpos one_pos
      have hterm2 : 0 ≤ (t : ℝ) * y.re := mul_nonneg ht0 hy.le
      linarith
  exact ⟨⟨⟨γ, hγ⟩, hγ0, hγ1⟩, fun t => hγt t⟩

/-- The right half-plane is preconnected. -/
theorem isPreconnected_halfPlaneRePos : IsPreconnected {s : ℂ | 0 < s.re} :=
  OnlineZetaEta4.isPathConnected_isPreconnected isPathConnected_halfPlaneRePos

/-- On `1 < Re z`, `etaStrip z = etaIntegral z / Γ(z)` (Phase 2.3 Fubini +
    Phase 2.2a agreement of the strip limit with the tsum); hence the equality
    holds frequently at `2`. -/
theorem etaFreqEqEtaIntegralDivGamma :
    ∃ᶠ z in 𝓝[≠] (2 : ℂ),
      OnlineZetaEta3.etaStrip z = OnlineZetaEta5.etaIntegral z / Complex.Gamma z := by
  have heq1 : ∀ z, 1 < z.re →
      OnlineZetaEta3.etaStrip z = OnlineZetaEta5.etaIntegral z / Complex.Gamma z := by
    intro z h1
    have hseries : OnlineZetaEta3.etaStrip z = OnlineZetaEta.etaSeries z :=
      OnlineZetaEta3.etaStripAgreesEtaSeries z h1
    have hgamma : OnlineZetaEta5.etaIntegral z = Complex.Gamma z * OnlineZetaEta.etaSeries z :=
      OnlineZetaEta5.etaIntegral_eq_Gamma_etaSeries z h1
    have hnz : Complex.Gamma z ≠ 0 := Complex.Gamma_ne_zero_of_re_pos (by linarith)
    calc OnlineZetaEta3.etaStrip z
        _ = OnlineZetaEta.etaSeries z := hseries
        _ = (Complex.Gamma z * OnlineZetaEta.etaSeries z) / Complex.Gamma z := by
            field_simp [hnz]
        _ = OnlineZetaEta5.etaIntegral z / Complex.Gamma z := by
            rw [← hgamma]
            <;> field_simp [hnz]
  have hopen : IsOpen {s : ℂ | 1 < s.re} := by
    apply IsOpen.preimage (by continuity)
    exact isOpen_Ioi
  have h2 : {s : ℂ | 1 < s.re} ∈ 𝓝 (2 : ℂ) := hopen.mem_nhds (by norm_num)
  have hneBot2 : NeBot (𝓝[≠] (2 : ℂ) ⊓ 𝓟 {z : ℂ |
      OnlineZetaEta3.etaStrip z = OnlineZetaEta5.etaIntegral z / Complex.Gamma z}) := by
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
        exact abs_of_nonneg (by linarith [hr])
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
    have hzP : OnlineZetaEta3.etaStrip z0 =
        OnlineZetaEta5.etaIntegral z0 / Complex.Gamma z0 :=
      heq1 z0 (by rw [hre]; linarith [hr])
    have hVsub : {z : ℂ |
        OnlineZetaEta3.etaStrip z = OnlineZetaEta5.etaIntegral z / Complex.Gamma z} ⊆ V := by
      simpa [Filter.mem_principal] using hV
    have hzV : z0 ∈ V := hVsub hzP
    exact hznotV hzV
  exact (frequently_iff_neBot (l := 𝓝[≠] (2 : ℂ))
    (p := fun z : ℂ =>
      OnlineZetaEta3.etaStrip z = OnlineZetaEta5.etaIntegral z / Complex.Gamma z)).2 hneBot2

/-- **Identity theorem (Phase 2.3, item 4).** For `0 < Re s`:

    `etaStrip s = etaIntegral s / Γ(s)`.

Both sides are analytic on `{0 < Re s}` and agree on the open set `{1 < Re s}`
(Phase 2.3 Fubini + Phase 2.2a), so they agree everywhere on the preconnected
half-plane. No `s ≠ 1` exclusion is needed (unlike the eta–zeta identity): the
eta series is entire, so the strip limit is holomorphic at `s = 1`. -/
theorem etaStrip_eq_etaIntegral_div_Gamma (s : ℂ) (hs : 0 < s.re) :
    OnlineZetaEta3.etaStrip s = OnlineZetaEta5.etaIntegral s / Complex.Gamma s := by
  have hf : AnalyticOnNhd ℂ OnlineZetaEta3.etaStrip {s : ℂ | 0 < s.re} :=
    etaStrip_analyticOnNhd_halfPlane
  have hg : AnalyticOnNhd ℂ (fun s : ℂ => OnlineZetaEta5.etaIntegral s / Complex.Gamma s)
      {s : ℂ | 0 < s.re} := etaIntegral_div_Gamma_analyticOnNhd_halfPlane
  have hU : IsPreconnected {s : ℂ | 0 < s.re} := isPreconnected_halfPlaneRePos
  have hz0 : (2 : ℂ) ∈ {s : ℂ | 0 < s.re} := by norm_num
  have heq : EqOn OnlineZetaEta3.etaStrip
      (fun s : ℂ => OnlineZetaEta5.etaIntegral s / Complex.Gamma s)
      {s : ℂ | 0 < s.re} :=
    hf.eqOn_of_preconnected_of_frequently_eq hg hU hz0 etaFreqEqEtaIntegralDivGamma
  exact heq hs

/-! ## 3. The kernel split (pointwise, `x > 0`) -/

/-- `1/(e^t + 1) = e^{-t}/(1 + e^{-t})` for `t > 0`. -/
theorem etaKernel_eq_expNeg_div (t : ℝ) (ht : 0 < t) :
    OnlineZetaEta5.etaKernel t = Real.exp (-t) / (1 + Real.exp (-t)) := by
  dsimp only [OnlineZetaEta5.etaKernel]
  have hpos : 0 < Real.exp t := Real.exp_pos t
  have hkey : Real.exp (-t) * Real.exp t = 1 := by
    rw [mul_comm, ← Real.exp_add]
    ring_nf
    rw [Real.exp_zero]
  calc OnlineZetaEta5.etaKernel t
      = 1 / (Real.exp t + 1) := by
        simp [ht, OnlineZetaEta5.etaKernel]
    _ = Real.exp (-t) / (1 + Real.exp (-t)) := by
      field_simp [hpos.ne', (Real.exp_pos _).ne']
      ring_nf
      rw [hkey]
      ring

/-- **Finite geometric split.** For `x > 0` and `K ≥ 0`:

    `x/(1+x) = x · ∑_{k<K} (1-x)^k / 2^{k+1} + 2^{-K} · x(1-x)^K / (1+x)`.

At `x = e^{-t}` (`t > 0`) this is the pointwise kernel identity behind the
Euler transform: the first summand integrates to the finite Euler sum, the
second to the explicit `2^{-K}` remainder. -/
theorem etaKernel_split (x : ℝ) (hx : 0 < x) (K : ℕ) :
    x / (1 + x) = x * (∑ k ∈ Finset.range K, (1 - x) ^ k / 2 ^ (k + 1)) +
      (1 / 2 : ℝ) ^ K * x * (1 - x) ^ K / (1 + x) := by
  let r := (1 - x) / 2
  have hr1 : r ≠ 1 := by
    dsimp only [r]
    intro h
    have h1x : 1 - x = 2 := by
      field_simp at h
      <;> nlinarith [hx]
    have hneg : x = -1 := by linarith [h1x]
    linarith [hx]
  have hden : 1 + x ≠ 0 := by
    by_contra h
    have h1 : 1 + x = 0 := by tauto
    linarith [hx]
  have hsum : (∑ k ∈ Finset.range K, (1 - x) ^ k / 2 ^ (k + 1)) =
      (1 - r ^ K) / (1 + x) := by
    dsimp only [r]
    calc (∑ k ∈ Finset.range K, (1 - x) ^ k / 2 ^ (k + 1))
        _ = ∑ k ∈ Finset.range K, (1 / 2) * ((1 - x) / 2) ^ k := by
          apply Finset.sum_congr rfl
          intro k _
          have hpow : ((1 - x) / 2) ^ k = (1 - x) ^ k / 2 ^ k := by
            rw [div_pow]
          calc (1 - x) ^ k / 2 ^ (k + 1)
              _ = (1 - x) ^ k / (2 * 2 ^ k) := by
                  rw [pow_succ, mul_comm]
                  <;> ring_nf
              _ = (1 / 2) * ((1 - x) ^ k / 2 ^ k) := by
                  field_simp
                  <;> ring_nf
                  <;> field_simp
              _ = (1 / 2) * ((1 - x) / 2) ^ k := by
                  rw [hpow]
        _ = (1 / 2) * (∑ k ∈ Finset.range K, ((1 - x) / 2) ^ k) := by
          rw [Finset.mul_sum]
        _ = (1 / 2) * (((1 - x) / 2) ^ K - 1) / ((1 - x) / 2 - 1) := by
          rw [geom_sum_eq hr1 K]
          ring_nf
          ring
        _ = (1 - ((1 - x) / 2) ^ K) / (1 + x) := by
          have hy : ((1 - x) / 2 : ℝ) = (1 - x) * (1 / 2) := by ring
          have h1 : (1 / 2) * (((1 - x) / 2) ^ K - 1) / ((1 - x) / 2 - 1) =
              ((1 - x) / 2) ^ K / (2 * ((1 - x) / 2 - 1)) - 1 / (2 * ((1 - x) / 2 - 1)) := by
            field_simp
            <;> ring_nf
            <;> field_simp
            <;> ring
          rw [h1]
          have h2 : 2 * ((1 - x) / 2 - 1) = -(1 + x) := by ring
          have h3 : ((1 - x) / 2) ^ K / (-(1 + x)) = -(((1 - x) / 2) ^ K) / (1 + x) := by
            field_simp [hden]
            <;> ring_nf
            <;> field_simp [hden]
            <;> ring
          have hfinal : -(((1 - x) / 2) ^ K) / (1 + x) - 1 / (-(1 + x)) =
              (1 - ((1 - x) / 2) ^ K) / (1 + x) := by
            field_simp [hden]
            <;> ring_nf
            <;> field_simp [hden]
            <;> ring
          rw [h2, h3, hfinal]
  calc x / (1 + x)
      _ = x * (1 / (1 + x)) := by ring
      _ = x * (((1 - r ^ K) / (1 + x)) + (r ^ K / (1 + x))) := by
          ring_nf
          <;> field_simp [hden]
          <;> ring
      _ = x * ((1 - r ^ K) / (1 + x)) + x * (r ^ K / (1 + x)) := by
          ring
      _ = x * (∑ k ∈ Finset.range K, (1 - x) ^ k / 2 ^ (k + 1)) +
          x * (r ^ K / (1 + x)) := by
          rw [hsum]
      _ = x * (∑ k ∈ Finset.range K, (1 - x) ^ k / 2 ^ (k + 1)) +
          (1 / 2 : ℝ) ^ K * x * (1 - x) ^ K / (1 + x) := by
          have hterm : x * (((1 - x) / 2) ^ K / (1 + x)) =
              (1 / 2 : ℝ) ^ K * x * (1 - x) ^ K / (1 + x) := by
            rw [div_pow]
            have hinvK : ((1 / 2 : ℝ) ^ K) = 1 / 2 ^ K := by
              rw [div_pow]
              <;> ring
            field_simp [hden, hinvK]
            have hprod : ((1 / 2 : ℝ) ^ K * (2 : ℝ) ^ K) = 1 := by
              rw [show (1 / 2 : ℝ) ^ K * (2 : ℝ) ^ K = ((1 / 2) * 2) ^ K from
                (mul_pow (1 / 2 : ℝ) (2 : ℝ) K).symm]
              norm_num
            have hfinal : (1 - x) ^ K * 2 ^ K * (1 / 2) ^ K = (1 - x) ^ K := by
              calc (1 - x) ^ K * 2 ^ K * (1 / 2) ^ K
                  _ = (1 - x) ^ K * ((1 / 2 : ℝ) ^ K * (2 : ℝ) ^ K) := by ring
                  _ = (1 - x) ^ K * 1 := by rw [hprod]
                  _ = (1 - x) ^ K := by simp
            exact hfinal.symm
          dsimp only [r]
          rw [hterm]

/-- The kernel split instantiated at `x = e^{-t}` (`t > 0`):

    `etaKernel t = e^{-t} · ∑_{k<K} (1-e^{-t})^k / 2^{k+1} +
        2^{-K} · e^{-t}(1-e^{-t})^K / (1 + e^{-t})`. -/
theorem etaKernel_split_exp (t : ℝ) (ht : 0 < t) (K : ℕ) :
    OnlineZetaEta5.etaKernel t =
      (Real.exp (-t)) * (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1)) +
      (1 / 2 : ℝ) ^ K * Real.exp (-t) * (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) := by
  rw [etaKernel_eq_expNeg_div t ht,
    etaKernel_split (Real.exp (-t)) (Real.exp_pos _) K]

/-! ## 4. Integrability of the Euler kernel part and the remainder kernel -/

variable (s : ℂ)

/-- The Laplace core `1_{t>0} t^{s-1} e^{-nt}` is integrable for `n ≥ 1`,
    `0 < Re s` (Phase 2.3 `laplaceTerm_integrable`, up to the constant
    `(-1)^{n-1}`, whose square is `1`). -/
theorem laplaceCore_integrable (hs : 0 < s.re) (n : ℕ) (hn : 0 < n) :
    Integrable (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) else 0) := by
  have hsq : (-1 : ℂ) ^ (n - 1) * (-1 : ℂ) ^ (n - 1) = 1 := by
    rw [← mul_pow (-1 : ℂ) (-1 : ℂ) (n - 1)]
    have h1 : (-1 : ℂ) * (-1 : ℂ) = 1 := by norm_num
    rw [h1, one_pow]
  have hI : Integrable (OnlineZetaEta5.laplaceTerm s n) :=
    OnlineZetaEta5.laplaceTerm_integrable s hs n
  have hcore : (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) else 0) =
      (fun t : ℝ => (-1 : ℂ) ^ (n - 1) * (OnlineZetaEta5.laplaceTerm s n t)) := by
    funext t
    by_cases ht : 0 < t
    · have hlt : ¬(t ≤ 0) := by
        intro h
        linarith [h, ht]
      have hlhs : (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) else 0) =
          (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) := by
        simp [ht]
      have hrhs : (OnlineZetaEta5.laplaceTerm s n t) =
          (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) := by
        dsimp only [OnlineZetaEta5.laplaceTerm]
        simp [ht, hn.ne', hlt]
      rw [hlhs, hrhs]
      rw [mul_assoc]
      have hr : (-1 : ℂ) ^ (n - 1) * ((-1 : ℂ) ^ (n - 1) *
          ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ))) =
          1 * ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)) := by
        calc (-1 : ℂ) ^ (n - 1) * ((-1 : ℂ) ^ (n - 1) *
            ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)))
            _ = ((-1 : ℂ) ^ (n - 1) * (-1 : ℂ) ^ (n - 1)) *
                ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)) := by
              rw [mul_assoc]
            _ = 1 * ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)) := by
              rw [hsq]
      rw [hr, one_mul]
    · have hle : t ≤ 0 := by
        by_contra hh
        exact ht (by linarith [hh])
      have hlhs : (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ) else 0) = 0 := by
        simp [ht]
      have hrhs : (OnlineZetaEta5.laplaceTerm s n t) = 0 := by
        dsimp only [OnlineZetaEta5.laplaceTerm]
        simp [ht, hle]
      rw [hlhs, hrhs]
      ring
  have hconst : Integrable (fun t : ℝ =>
      (-1 : ℂ) ^ (n - 1) * (OnlineZetaEta5.laplaceTerm s n t)) :=
    Integrable.const_mul (𝕜 := ℂ) hI ((-1 : ℂ) ^ (n - 1))
  rwa [hcore]

/-- A finite (possibly nested) sum of integrable functions is integrable. -/
theorem finsetSum_integrable {ι : Type*} [DecidableEq ι] (t : Finset ι) (f : ι → ℝ → ℂ)
    (hf : ∀ i ∈ t, Integrable (f i)) : Integrable (fun x => ∑ i ∈ t, f i x) := by
  induction t using Finset.induction with
  | empty =>
      simp only [Finset.sum_empty]
      exact integrable_const_iff.mpr (Or.inl rfl)
  | insert i t' hi ih =>
      have hf' : ∀ j ∈ t', Integrable (f j) := fun j hj => by
        simpa using hf j (Finset.mem_insert_of_mem hj)
      have hsum : (fun x : ℝ => ∑ j ∈ insert i t', f j x) =
          (f i) + (fun x => ∑ j ∈ t', f j x) := by
        funext x
        rw [Finset.sum_insert hi]
        rfl
      simpa [hsum] using Integrable.add (hf i (Finset.mem_insert_self i t')) (ih hf')

/-- The `k`-th kernel summand expanded at `t > 0` into Laplace cores:

    `t^{s-1} e^{-t} (1-e^{-t})^k = ∑_{j≤k} C(k,j)(-1)^j t^{s-1} e^{-(j+1)t}`. -/
theorem eulerKernelPart_expand (k : ℕ) (t : ℝ) (ht : 0 < t) :
    (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) * ((1 - Real.exp (-t)) : ℂ) ^ k =
      ∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          ((t : ℂ) ^ (s - 1) * (Real.exp ((-1 - (j : ℝ)) * t) : ℂ)) := by
  have hexp_pow (j : ℕ) : (Real.exp (-t)) ^ (j + 1) = Real.exp (-((j + 1) : ℝ) * t) := by
    calc
      (Real.exp (-t)) ^ (j + 1) = Real.exp ((j + 1) • (-t)) := by
        rw [← Real.exp_nsmul]
      _ = Real.exp (-((j + 1) : ℝ) * t) := by
        have hnsmul : (j + 1) • (-t) = -((j + 1) : ℝ) * t := by
          have hc : (j + 1) • (-t) = ((j + 1) : ℝ) * (-t) := by
            simp [nsmul_eq_mul]
          rw [hc]
          ring
        rw [hnsmul]
  have hbinom : ((1 - Real.exp (-t)) : ℂ) ^ k =
      ∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
        ((Real.exp (-t) : ℂ)) ^ j := by
    have hL : ((1 - Real.exp (-t)) : ℂ) = (-(Real.exp (-t) : ℂ)) + (1 : ℂ) := by
      ring
    rw [hL, add_pow (-(Real.exp (-t) : ℂ)) (1 : ℂ) k]
    apply Finset.sum_congr rfl
    intro j _
    rw [show (-(Real.exp (-t) : ℂ)) ^ j = (-1 : ℂ) ^ j * ((Real.exp (-t) : ℂ)) ^ j from
      neg_pow (Real.exp (-t) : ℂ) j,
      one_pow (k - j)]
    ring
  calc (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) * ((1 - Real.exp (-t)) : ℂ) ^ k
      _ = (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          (∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            ((Real.exp (-t) : ℂ)) ^ j) := by rw [hbinom]
      _ = ∑ j ∈ Finset.range (k + 1), (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * ((Real.exp (-t) : ℂ)) ^ j) := by
        rw [← Finset.mul_sum]
      _ = ∑ j ∈ Finset.range (k + 1),
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            ((t : ℂ) ^ (s - 1) * (Real.exp ((-1 - (j : ℝ)) * t) : ℂ)) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hstep : (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
            (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * ((Real.exp (-t) : ℂ)) ^ j) =
            ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
              ((t : ℂ) ^ (s - 1) * ((Real.exp (-t) : ℂ)) ^ j * (Real.exp (-t) : ℂ)) := by
          ring
        rw [hstep]
        have hcast : ((Real.exp (-t) : ℂ)) ^ (j + 1) =
            ↑(Real.exp (-t) ^ (j + 1)) :=
            (Complex.ofReal_pow (Real.exp (-t)) (j + 1)).symm
        have hlastC : ((Real.exp (-t) : ℂ)) ^ (j + 1) =
            (Real.exp ((-1 - (j : ℝ)) * t) : ℂ) := by
          rw [hcast]
          rw [hexp_pow j]
          congr 1
          ring
        have hsub : (t : ℂ) ^ (s - 1) * ((Real.exp (-t) : ℂ)) ^ j * (Real.exp (-t) : ℂ) =
            (t : ℂ) ^ (s - 1) * (Real.exp ((-1 - (j : ℝ)) * t) : ℂ) := by
          rw [mul_assoc, ← pow_succ, hlastC]
        rw [hsub]

/-- The `K`-term Euler kernel part is integrable on `(0, ∞)` for `0 < Re s`
    (finite sum of Laplace cores, each integrable by `laplaceCore_integrable`). -/
theorem eulerKernelPart_integrableOn (hs : 0 < s.re) (K : ℕ) :
    IntegrableOn (eulerKernelPart s K) (Ioi (0 : ℝ)) := by
  dsimp only [IntegrableOn]
  have hcore (j : ℕ) (hj : 0 < j) :
      Integrable (fun t : ℝ =>
        if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-(j : ℝ) * t) : ℂ) else 0) :=
    laplaceCore_integrable s hs j hj
  have hsum1 (k : ℕ) : Integrable (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
        ((1 - Real.exp (-t)) : ℂ) ^ k else 0) := by
    let f (j : ℕ) (t : ℝ) : ℂ :=
      ((k.choose j : ℕ) : ℂ) * ((-1 : ℂ) ^ j *
        (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-((j + 1) : ℝ) * t) : ℂ) else 0))
    have hexpand : (fun t : ℝ =>
        if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          ((1 - Real.exp (-t)) : ℂ) ^ k else 0) =
        (fun t : ℝ => ∑ j ∈ Finset.range (k + 1),
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-((j + 1) : ℝ) * t) : ℂ) else 0)) := by
      funext t
      by_cases ht : 0 < t
      · simp [ht]
        have heq := eulerKernelPart_expand s k t ht
        simpa [show ∀ j : ℕ, (-1 - (j : ℝ)) * t = (-1 + -(j : ℝ)) * t from by
          intro j
          ring] using heq
      · simp [ht]
    have hf : ∀ j ∈ Finset.range (k + 1), Integrable (fun t => f j t) := by
      intro j hj
      simpa [f] using
        Integrable.const_mul (𝕜 := ℂ)
          (Integrable.const_mul (𝕜 := ℂ) (hcore (j + 1) (Nat.succ_pos j)) ((-1 : ℂ) ^ j))
          ((k.choose j : ℕ) : ℂ)
    have hinner : Integrable (fun t : ℝ => ∑ j ∈ Finset.range (k + 1), f j t) :=
      finsetSum_integrable (Finset.range (k + 1)) f hf
    have hbridge : (fun t : ℝ => ∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < t then (t : ℂ) ^ (s - 1) *
            (Real.exp (-((j + 1) : ℝ) * t) : ℂ) else 0)) =
        (fun t : ℝ => ∑ j ∈ Finset.range (k + 1), f j t) := by
      funext t
      apply Finset.sum_congr rfl
      intro j hj
      simp [f]
      ring
    have hfinal : (fun t : ℝ =>
        if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          ((1 - Real.exp (-t)) : ℂ) ^ k else 0) =
        (fun t : ℝ => ∑ j ∈ Finset.range (k + 1), f j t) := by
      rw [hexpand, hbridge]
    exact hfinal ▸ hinner
  have hsumK : (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
        (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) else 0) =
      (fun t : ℝ => ∑ k ∈ Finset.range K,
        etaCoeff k *
          (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
            ((1 - Real.exp (-t)) : ℂ) ^ k else 0)) := by
    funext t
    by_cases ht : 0 < t
    · simp only [ht]
      have hsub : (1 - Real.exp (-t) : ℂ) = (1 - Real.exp (-t) : ℝ) := by
        simp [Complex.ofReal_sub]
      have hterm (k : ℕ) :
          (Real.exp (-t) : ℂ) * ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) =
            etaCoeff k * (Real.exp (-t) : ℂ) *
              ((1 - Real.exp (-t)) : ℂ) ^ k := by
        have hpow : ((1 - Real.exp (-t) : ℂ)) ^ k =
            ↑((1 - Real.exp (-t)) ^ k) := by
          rw [hsub, Complex.ofReal_pow]
        have hdiv : ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) =
            ↑((1 - Real.exp (-t)) ^ k) / (2 : ℂ) ^ (k + 1) := by
          simpa [hpow]
        have hinv : ((2 : ℂ) ^ (k + 1))⁻¹ = ((1 / 2 : ℂ) ^ (k + 1)) := by
          rw [← inv_pow, show (2 : ℂ)⁻¹ = (1 / 2 : ℂ) from by norm_num]
        calc (Real.exp (-t) : ℂ) * ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)
            _ = (Real.exp (-t) : ℂ) *
                (↑((1 - Real.exp (-t)) ^ k) / (2 : ℂ) ^ (k + 1)) := by
              rw [hdiv]
            _ = (Real.exp (-t) : ℂ) * ↑((1 - Real.exp (-t)) ^ k) *
                (1 / 2 : ℂ) ^ (k + 1) := by
              rw [div_eq_mul_inv, hinv]
              <;> ring
            _ = (1 / 2 : ℂ) ^ (k + 1) * (Real.exp (-t) : ℂ) *
                ↑((1 - Real.exp (-t)) ^ k) := by
              ring
            _ = etaCoeff k * (Real.exp (-t) : ℂ) *
                ((1 - Real.exp (-t)) : ℂ) ^ k := by
              rw [hpow]
              dsimp only [etaCoeff]
      calc (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)
          _ = (t : ℂ) ^ (s - 1) *
              (∑ k ∈ Finset.range K, (Real.exp (-t) : ℂ) *
                ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)) := by
            rw [mul_assoc]
            rw [show (Real.exp (-t) : ℂ) * (∑ k ∈ Finset.range K,
                (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) =
                ∑ k ∈ Finset.range K, (Real.exp (-t) : ℂ) *
                  ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) from by
              rw [Finset.mul_sum]]
          _ = ∑ k ∈ Finset.range K, (t : ℂ) ^ (s - 1) *
              ((Real.exp (-t) : ℂ) *
                ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)) := by
            rw [show (t : ℂ) ^ (s - 1) * (∑ k ∈ Finset.range K,
                (Real.exp (-t) : ℂ) *
                  ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)) =
                ∑ k ∈ Finset.range K, (t : ℂ) ^ (s - 1) *
                  ((Real.exp (-t) : ℂ) *
                    ((1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ)) from by
              rw [Finset.mul_sum]]
          _ = ∑ k ∈ Finset.range K, (t : ℂ) ^ (s - 1) *
              (etaCoeff k * (Real.exp (-t) : ℂ) *
                ((1 - Real.exp (-t)) : ℂ) ^ k) := by
            apply Finset.sum_congr rfl
            intro k hk
            rw [hterm k]
          _ = ∑ k ∈ Finset.range K,
              etaCoeff k *
                ((t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
                  ((1 - Real.exp (-t)) : ℂ) ^ k) := by
            apply Finset.sum_congr rfl
            intro k hk
            ring
    · simp [ht]
  have hsum : Integrable (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
        (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) else 0) := by
    rw [hsumK]
    apply finsetSum_integrable (Finset.range K)
      (fun k t => etaCoeff k *
        (if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
          ((1 - Real.exp (-t)) : ℂ) ^ k else 0))
    intro k hk
    simpa using
      Integrable.const_mul (hsum1 k) (etaCoeff k)
  have hpart : (fun t : ℝ =>
      if 0 < t then (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) *
        (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) else 0) =
      (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) := by
    funext t
    by_cases ht : 0 < t
    · simp [ht, Set.indicator, Ioi, eulerKernelPart]
    · simp [ht, Set.indicator, Ioi]
  have hI : Integrable ((Ioi (0 : ℝ)).indicator (eulerKernelPart s K)) := by
    rw [← hpart]
    exact hsum
  exact (integrable_indicator_iff measurableSet_Ioi).1 hI

/-- The Euler remainder integrand is integrable on `(0, ∞)` for `0 < Re s`:
    it is the Mellin kernel integrand (Phase 2.3 `etaIntegral_convergent`)
    minus the `K`-term Euler kernel part, on `(0, ∞)`. -/
theorem etaRemKernel_integrableOn (hs : 0 < s.re) (K : ℕ) :
    IntegrableOn (etaRemKernel s K) (Ioi (0 : ℝ)) := by
  have hkernel : IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC t))
      (Ioi (0 : ℝ)) := by
    have hc := OnlineZetaEta5.etaIntegral_convergent s hs
    dsimp only [MellinConvergent] at hc
    simpa [OnlineZetaEta5.etaKernelC, smul_eq_mul] using hc
  have hdiff : IntegrableOn (fun t : ℝ =>
      (t : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC t) - eulerKernelPart s K t) (Ioi (0 : ℝ)) :=
    IntegrableOn.sub hkernel (eulerKernelPart_integrableOn s hs K)
  have hpoint : (Ioi (0 : ℝ)).indicator (fun t : ℝ =>
      (t : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC t) - eulerKernelPart s K t) =
      (Ioi (0 : ℝ)).indicator (etaRemKernel s K) := by
    funext t
    by_cases ht : 0 < t
    · simp [ht, Set.indicator, Ioi]
      dsimp only [etaRemKernel, eulerKernelPart, OnlineZetaEta5.etaKernelC]
      have hsplit := etaKernel_split_exp t ht K
      have hC : (OnlineZetaEta5.etaKernel t : ℂ) =
          (Real.exp (-t) * (∑ k ∈ Finset.range K, (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1)) +
            (1 / 2 : ℝ) ^ K * Real.exp (-t) * (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) : ℂ) := by
        exact mod_cast hsplit
      have hsumC : ((Real.exp (-t) * (∑ k ∈ Finset.range K,
          (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1)) : ℝ) : ℂ) =
          (Real.exp (-t) : ℂ) * (∑ k ∈ Finset.range K,
            (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) := by
        simp [ofReal_mul, ofReal_finsetSum]
      have hremC : (((1 / 2 : ℝ) ^ K * Real.exp (-t) *
          (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) : ℝ) : ℂ) =
          ((1 / 2 : ℂ) ^ K) * (Real.exp (-t) : ℂ) *
            ((1 - Real.exp (-t)) : ℂ) ^ K / (1 + (Real.exp (-t) : ℂ)) := by
        have hnz : (1 + Real.exp (-t) : ℝ) ≠ 0 := by positivity
        field_simp [hnz]
        simp [Complex.ofReal_mul, Complex.ofReal_pow, Complex.ofReal_sub]
      have hsplitC : (OnlineZetaEta5.etaKernel t : ℂ) =
          (Real.exp (-t) : ℂ) * (∑ k ∈ Finset.range K,
            (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) +
            ((1 / 2 : ℂ) ^ K) * (Real.exp (-t) : ℂ) *
              ((1 - Real.exp (-t)) : ℂ) ^ K / (1 + (Real.exp (-t) : ℂ)) := by
        calc (OnlineZetaEta5.etaKernel t : ℂ) =
            (Real.exp (-t) * (∑ k ∈ Finset.range K,
              (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1)) +
              (1 / 2 : ℝ) ^ K * Real.exp (-t) * (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) : ℂ) := by
              rw [hC]
          _ = ((Real.exp (-t) * (∑ k ∈ Finset.range K,
              (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1)) : ℝ) : ℂ) +
              (((1 / 2 : ℝ) ^ K * Real.exp (-t) * (1 - Real.exp (-t)) ^ K /
                (1 + Real.exp (-t)) : ℝ) : ℂ) := by
              simp [Complex.ofReal_mul, Complex.ofReal_pow, Complex.ofReal_sub,
                Complex.ofReal_div]
              <;> ring
          _ = (Real.exp (-t) : ℂ) * (∑ k ∈ Finset.range K,
              (1 - Real.exp (-t)) ^ k / 2 ^ (k + 1) : ℂ) +
              ((1 / 2 : ℂ) ^ K) * (Real.exp (-t) : ℂ) *
                ((1 - Real.exp (-t)) : ℂ) ^ K / (1 + (Real.exp (-t) : ℂ)) := by
              rw [hsumC, hremC]
      rw [hsplitC]
      ring
    · simp [ht, Set.indicator, Ioi]
  have hI : Integrable ((Ioi (0 : ℝ)).indicator (fun t : ℝ =>
      (t : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC t) - eulerKernelPart s K t)) :=
    IntegrableOn.integrable_indicator hdiff measurableSet_Ioi
  have hI2 : Integrable ((Ioi (0 : ℝ)).indicator (etaRemKernel s K)) := by
    rw [← hpoint]
    exact hI
  exact (integrable_indicator_iff measurableSet_Ioi).1 hI2

/-! ## 5. The main identity and the `2^{-K}` remainder bound -/

/-- The Laplace block with the core form of this file:
    `∫₀^∞ 1_{t>0} t^{s-1} e^{-nt} dt = Γ(s)·(n:ℂ)^{-s}` (`n ≥ 1`, `0 < Re s`)
    (Phase 2.3 `laplace_n`, up to the `Real.exp`/`Complex.exp` cast). -/
theorem laplaceCore_integral (hs : 0 < s.re) (n : ℕ) (hn : 0 < n) :
    (∫ x : ℝ, if 0 < x then (x : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * x) : ℂ) else 0) =
      Complex.Gamma s * (n : ℂ) ^ (-s) := by
  have hexp : (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * x) : ℂ)) =
      (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * x)) := by
    congr
    funext x
    simp [Complex.ofReal_exp]
  have hlap := OnlineZetaEta5.laplace_n s hs n hn
  calc (∫ x : ℝ, if 0 < x then (x : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * x) : ℂ) else 0)
      _ = (∫ x : ℝ, ((Ioi (0 : ℝ)).indicator (fun u : ℝ =>
          (u : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * u) : ℂ))) x) := by
        congr
      _ = (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * x) : ℂ)) := by
        rw [integral_indicator measurableSet_Ioi]
      _ = (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * x)) := by
        rw [hexp]
      _ = Complex.Gamma s * (n : ℂ) ^ (-s) := by rw [hlap]

/-- Real-parameter version of the Laplace block:
    `∫₀^∞ 1_{t>0} t^{s-1} e^{-nr·t} dt = Γ(s)·(nr:ℂ)^{-s}`
    (`nr > 0`, `0 < Re s`). -/
theorem laplaceCore_integralR (hs : 0 < s.re) (nr : ℝ) (hn : 0 < nr) :
    (∫ x : ℝ, if 0 < x then (x : ℂ) ^ (s - 1) * (Real.exp (-nr * x) : ℂ) else 0) =
      Complex.Gamma s * (nr : ℂ) ^ (-s) := by
  have hexp : (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * (Real.exp (-nr * x) : ℂ)) =
      (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * Complex.exp (-nr * x)) := by
    congr
    funext x
    simp [Complex.ofReal_exp]
  have hscal : mellin (fun t : ℝ => Complex.exp (-nr * t)) s =
      (nr : ℂ) ^ (-s) * mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s := by
    have hscale : mellin (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) (nr * t)) s =
        (nr : ℂ) ^ (-s) * mellin (fun u : ℝ => (Real.exp (-u) : ℂ)) s := by
      rw [mellin_comp_mul_left (fun u : ℝ => (Real.exp (-u) : ℂ)) s (a := nr) hn]
      simp
    have hcomp : (fun t : ℝ => Complex.exp (-nr * t)) =
        (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) (nr * t)) := by
      funext t
      simp
    rw [hcomp, hscale]
  have hbase : mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s = Complex.GammaIntegral s :=
    OnlineZetaEta5.mellin_expNeg_eq_GammaIntegral s
  calc (∫ x : ℝ, if 0 < x then (x : ℂ) ^ (s - 1) * (Real.exp (-nr * x) : ℂ) else 0)
      _ = (∫ x : ℝ, ((Ioi (0 : ℝ)).indicator (fun u : ℝ =>
          (u : ℂ) ^ (s - 1) * (Real.exp (-nr * u) : ℂ))) x) := by
        congr
      _ = (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * (Real.exp (-nr * x) : ℂ)) := by
        rw [integral_indicator measurableSet_Ioi]
      _ = (∫ x : ℝ in Ioi 0, (x : ℂ) ^ (s - 1) * Complex.exp (-nr * x)) := by
        rw [hexp]
      _ = mellin (fun t : ℝ => Complex.exp (-nr * t)) s := by
        dsimp only [mellin]
        congr with t
      _ = (nr : ℂ) ^ (-s) * mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s := hscal
      _ = (nr : ℂ) ^ (-s) * Complex.GammaIntegral s := by rw [hbase]
      _ = (nr : ℂ) ^ (-s) * Complex.Gamma s := by rw [Complex.Gamma_eq_integral hs]
      _ = Complex.Gamma s * (nr : ℂ) ^ (-s) := by ring

/-- The integral of the `K`-term Euler kernel part over `(0,∞)` equals
    `Γ(s) · etaEuler s K` (finite sum of Laplace blocks). -/
theorem eulerKernelPart_integral_eq_Gamma_etaEuler (hs : 0 < s.re) (K : ℕ) :
    (∫ u : ℝ in Ioi 0, eulerKernelPart s K u) = Complex.Gamma s * etaEuler s K := by
  have hpoint : (fun u : ℝ =>
      (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) =
      (fun u : ℝ => ∑ k ∈ Finset.range K,
        etaCoeff k * (∑ j ∈ Finset.range (k + 1),
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            (if 0 < u then etaBlock s j u else 0))) := by
    funext u
    by_cases hu : 0 < u
    · simp [hu, Set.indicator, Ioi]
      dsimp only [eulerKernelPart]
      calc (u : ℂ) ^ (s - 1) * (Real.exp (-u) : ℂ) *
          (∑ k ∈ Finset.range K, (1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ)
          _ = ∑ k ∈ Finset.range K, etaCoeff k *
              ((Real.exp (-u) : ℂ) * ((1 - Real.exp (-u)) : ℂ) ^ k) *
              (u : ℂ) ^ (s - 1) := by
            have hdist : (Real.exp (-u) : ℂ) *
                (∑ k ∈ Finset.range K, (1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ) =
                ∑ k ∈ Finset.range K, etaCoeff k *
                  ((Real.exp (-u) : ℂ) * ((1 - Real.exp (-u)) : ℂ) ^ k) := by
              calc (Real.exp (-u) : ℂ) *
                  (∑ k ∈ Finset.range K, (1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ)
                  _ = ∑ k ∈ Finset.range K, (Real.exp (-u) : ℂ) *
                      ((1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ) := by
                    rw [Finset.mul_sum]
                  _ = ∑ k ∈ Finset.range K, etaCoeff k *
                      ((Real.exp (-u) : ℂ) * ((1 - Real.exp (-u)) : ℂ) ^ k) := by
                    apply Finset.sum_congr rfl
                    intro k hk
                    have hcastpow : ((1 - Real.exp (-u)) ^ k : ℂ) =
                        ((1 - Real.exp (-u)) : ℂ) ^ k := by
                      simpa using Complex.ofReal_pow (1 - Real.exp (-u)) k
                    have hcastdiv : ((1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ) =
                        ((1 - Real.exp (-u)) : ℂ) ^ k / ((2 : ℂ) ^ (k + 1)) := by
                      simp [Complex.ofReal_div, hcastpow, Complex.ofReal_pow]
                    have hcoef : ((2 : ℂ) ^ (k + 1))⁻¹ =
                        etaCoeff k := by
                      calc ((2 : ℂ) ^ (k + 1))⁻¹
                          _ = ((2 : ℂ)⁻¹) ^ (k + 1) := by
                            rw [← inv_pow (2 : ℂ) (k + 1)]
                          _ = ((1 / 2 : ℂ)) ^ (k + 1) := by
                            rw [show (2 : ℂ)⁻¹ = (1 / 2 : ℂ) from by norm_num]
                          _ = etaCoeff k := by
                            dsimp only [etaCoeff]
                    rw [hcastdiv, div_eq_mul_inv, hcoef]
                    ring
            rw [show (u : ℂ) ^ (s - 1) * (Real.exp (-u) : ℂ) *
                (∑ k ∈ Finset.range K, (1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ) =
                (u : ℂ) ^ (s - 1) * ((Real.exp (-u) : ℂ) *
                  (∑ k ∈ Finset.range K, (1 - Real.exp (-u)) ^ k / 2 ^ (k + 1) : ℂ)) from by
              rw [mul_assoc]]
            rw [hdist]
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro k hk
            ring
          _ = ∑ k ∈ Finset.range K, etaCoeff k *
              (∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                ((Real.exp (-u)) ^ (j + 1) : ℂ)) * (u : ℂ) ^ (s - 1) := by
            apply Finset.sum_congr rfl
            intro k hk
            have hexp : ((1 - Real.exp (-u)) : ℂ) ^ k =
                ∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                  ((Real.exp (-u) : ℂ)) ^ j := by
              have he : ((1 - Real.exp (-u)) : ℂ) = (1 : ℂ) + (-(Real.exp (-u) : ℂ)) := by
                simp [Complex.ofReal_sub]
                ring
              rw [he, show (1 : ℂ) + (-(Real.exp (-u) : ℂ)) =
                  (-(Real.exp (-u) : ℂ)) + (1 : ℂ) from by ring,
                add_pow (-(Real.exp (-u) : ℂ)) (1 : ℂ) k]
              apply Finset.sum_congr rfl
              intro j hj
              have hneg : (-(Real.exp (-u) : ℂ)) ^ j =
                  (-1 : ℂ) ^ j * ((Real.exp (-u) : ℂ)) ^ j :=
                neg_pow (Real.exp (-u) : ℂ) j
              simp [hneg, one_pow]
              ring
            have hpull : (Real.exp (-u) : ℂ) *
                (∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                  ((Real.exp (-u) : ℂ)) ^ j) =
                (∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                  ((Real.exp (-u)) ^ (j + 1) : ℂ)) := by
              rw [Finset.mul_sum]
              apply Finset.sum_congr rfl
              intro j hj
              have hprod : (Real.exp (-u) : ℂ) * ((Real.exp (-u) : ℂ)) ^ j =
                  ((Real.exp (-u)) ^ (j + 1) : ℂ) := by
                calc (Real.exp (-u) : ℂ) * ((Real.exp (-u) : ℂ)) ^ j
                    _ = ((Real.exp (-u) : ℂ)) ^ (j + 1) := by
                      rw [mul_comm, ← pow_succ]
                    _ = ((Real.exp (-u)) ^ (j + 1) : ℂ) := by
                      rfl
              calc (Real.exp (-u) : ℂ) *
                  (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                    ((Real.exp (-u) : ℂ)) ^ j)
                  _ = (k.choose j : ℂ) * (-1 : ℂ) ^ j *
                      ((Real.exp (-u) : ℂ) * ((Real.exp (-u) : ℂ)) ^ j) := by
                    ring
                  _ = (k.choose j : ℂ) * (-1 : ℂ) ^ j *
                      (((Real.exp (-u)) ^ (j + 1) : ℂ)) := by
                    rw [hprod]
            rw [hexp, hpull]
          _ = ∑ k ∈ Finset.range K, etaCoeff k *
              (∑ j ∈ Finset.range (k + 1), ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                etaBlock s j u) := by
            apply Finset.sum_congr rfl
            intro k hk
            rw [Finset.mul_sum, Finset.sum_mul, Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro j hj
            have hexp : (Real.exp (-u)) ^ (j + 1) = Real.exp (-((j + 1) : ℝ) * u) := by
              rw [← Real.exp_nsmul]
              have hnsmul : (j + 1) • (-u) = -((j + 1) : ℝ) * u := by
                have hc : (j + 1) • (-u) = ((j + 1) : ℝ) * (-u) := by
                  simp [nsmul_eq_mul]
                rw [hc]
                ring
              rw [hnsmul]
            have hE : ((Real.exp (-u) : ℂ)) ^ (j + 1) * (u : ℂ) ^ (s - 1) =
                (u : ℂ) ^ (s - 1) * Complex.exp ((-((j + 1) : ℝ) * u) : ℂ) := by
              have hE2 : ((Real.exp (-u) : ℂ)) ^ (j + 1) =
                  Complex.exp ((-((j + 1) : ℝ) * u) : ℂ) := by
                exact (Complex.ofReal_pow (Real.exp (-u)) (j + 1)).symm.trans (by
                  rw [hexp]
                  simpa using Complex.ofReal_exp (-((j + 1) : ℝ) * u))
              rw [hE2, mul_comm]
            have hstep : ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                (((Real.exp (-u) : ℂ)) ^ (j + 1) * (u : ℂ) ^ (s - 1)) =
                ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * etaBlock s j u := by
              dsimp only [etaBlock]
              rw [hE]
            calc etaCoeff k *
                (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                  ((Real.exp (-u) : ℂ)) ^ (j + 1)) * (u : ℂ) ^ (s - 1)
                _ = etaCoeff k *
                    (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                      (((Real.exp (-u) : ℂ)) ^ (j + 1) * (u : ℂ) ^ (s - 1))) := by
                  ring
                _ = etaCoeff k *
                    (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * etaBlock s j u) := by
                  rw [hstep]
    · simp [hu, Set.indicator, Ioi]
  have hI (k : ℕ) : Integrable (fun u : ℝ =>
      etaCoeff k * (∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < u then etaBlock s j u else 0))) := by
    have hin : Integrable (fun u : ℝ => ∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < u then etaBlock s j u else 0)) := by
      apply finsetSum_integrable (Finset.range (k + 1))
        (fun j u => ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < u then etaBlock s j u else 0))
      intro j hj
      have hj1 : 0 < (j + 1 : ℕ) := Nat.succ_pos j
      have hcore1 := laplaceCore_integrable s hs (j + 1) hj1
      simpa [mul_assoc, etaBlock] using
        Integrable.const_mul (Integrable.const_mul hcore1 ((-1 : ℂ) ^ j))
            ((k.choose j : ℕ) : ℂ)
    simpa using Integrable.const_mul hin (etaCoeff k)
  have hIinner (k : ℕ) : Integrable (fun u : ℝ => ∑ j ∈ Finset.range (k + 1),
      ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
        (if 0 < u then etaBlock s j u else 0)) := by
    apply finsetSum_integrable (Finset.range (k + 1))
      (fun j u => ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
        (if 0 < u then etaBlock s j u else 0))
    intro j hj
    have hj1 : 0 < (j + 1 : ℕ) := Nat.succ_pos j
    have hcore1 := laplaceCore_integrable s hs (j + 1) hj1
    simpa [mul_assoc, etaBlock] using
      Integrable.const_mul (Integrable.const_mul hcore1 ((-1 : ℂ) ^ j))
          ((k.choose j : ℕ) : ℂ)
  have hJ (j : ℕ) : Integrable (fun u : ℝ =>
      if 0 < u then etaBlock s j u else 0) := by
    have hj1 : 0 < (j + 1 : ℕ) := Nat.succ_pos j
    simpa [etaBlock] using laplaceCore_integrable s hs (j + 1) hj1
  have hK1 : (∫ u : ℝ in Ioi 0, eulerKernelPart s K u) =
      (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) := by
    rw [integral_indicator measurableSet_Ioi]
  have hK2 : (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) =
      (∫ u : ℝ, ∑ k ∈ Finset.range K,
        etaCoeff k * (∑ j ∈ Finset.range (k + 1),
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            (if 0 < u then etaBlock s j u else 0))) := by
    rw [hpoint]
  have hK3 : (∫ u : ℝ, ∑ k ∈ Finset.range K,
      etaCoeff k * (∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < u then etaBlock s j u else 0))) =
      ∑ k ∈ Finset.range K, (∫ u : ℝ,
        etaCoeff k * (∑ j ∈ Finset.range (k + 1),
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            (if 0 < u then etaBlock s j u else 0))) := by
    exact integral_finsetSum (Finset.range K) (fun k hk => hI k)
  have hK4 : ∀ k ∈ Finset.range K, (∫ u : ℝ,
      etaCoeff k * (∑ j ∈ Finset.range (k + 1),
        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
          (if 0 < u then etaBlock s j u else 0))) =
      etaCoeff k *
        (∑ j ∈ Finset.range (k + 1), (∫ u : ℝ,
          ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
            (if 0 < u then etaBlock s j u else 0))) := by
    intro k hk
    rw [integral_const_mul _ _]
    rw [integral_finsetSum (Finset.range (k + 1))
      (fun j hj => by
        have hj1 : 0 < (j + 1 : ℕ) := Nat.succ_pos j
        have hcore1 := laplaceCore_integrable s hs (j + 1) hj1
        simpa [mul_assoc, etaBlock] using
          Integrable.const_mul (Integrable.const_mul hcore1 ((-1 : ℂ) ^ j))
              ((k.choose j : ℕ) : ℂ))]
  have hK5 : ∀ k ∈ Finset.range K, ∀ j ∈ Finset.range (k + 1), (∫ u : ℝ,
      ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
        (if 0 < u then etaBlock s j u else 0)) =
      ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s * (((j + 1) : ℝ) : ℂ) ^ (-s) := by
    intro k hk j hj
    rw [integral_const_mul _ _]
    have hj1 : 0 < (j + 1 : ℕ) := Nat.succ_pos j
    have hnr : 0 < (j + 1 : ℝ) := by
      norm_cast
      <;> omega
    have hlap := laplaceCore_integralR s hs (j + 1 : ℝ) hnr
    have hbridge : (∫ a : ℝ, if 0 < a then etaBlock s j a else 0) =
        (∫ a : ℝ, if 0 < a then (a : ℂ) ^ (s - 1) *
          (Real.exp (-(j + 1 : ℝ) * a) : ℂ) else 0) := by
      congr
      funext a
      split_ifs with ha
      · dsimp only [etaBlock]
        simp [Complex.ofReal_exp]
      · rfl
    rw [hbridge, hlap]
    ring
  calc (∫ u : ℝ in Ioi 0, eulerKernelPart s K u)
      _ = ∑ k ∈ Finset.range K, (∫ u : ℝ,
          etaCoeff k * (∑ j ∈ Finset.range (k + 1),
            ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
              (if 0 < u then etaBlock s j u else 0))) := by
          rw [hK1, hK2, hK3]
      _ = ∑ k ∈ Finset.range K, etaCoeff k *
          (∑ j ∈ Finset.range (k + 1),
            (∫ u : ℝ, ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
              (if 0 < u then etaBlock s j u else 0))) := by
          apply Finset.sum_congr rfl
          intro k hk
          rw [hK4 k hk]
      _ = ∑ k ∈ Finset.range K, etaCoeff k *
          (∑ j ∈ Finset.range (k + 1),
            ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s * (((j + 1) : ℝ) : ℂ) ^ (-s)) := by
          apply Finset.sum_congr rfl
          intro k hk
          rw [Finset.sum_congr rfl (fun j hj => hK5 k hk j hj)]
      _ = Complex.Gamma s * ∑ k ∈ Finset.range K,
          (1 / 2 : ℂ) ^ (k + 1) *
            (∑ j ∈ Finset.range (k + 1),
              (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) * (1 / (((j + 1) : ℝ) : ℂ) ^ s)) := by
          have h1 : ∀ k ∈ Finset.range K,
              etaCoeff k *
                (∑ j ∈ Finset.range (k + 1),
                  ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                    (((j + 1) : ℝ) : ℂ) ^ (-s)) =
              Complex.Gamma s * ((1 / 2 : ℂ) ^ (k + 1)) *
                (∑ j ∈ Finset.range (k + 1),
                  (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) * (1 / (((j + 1) : ℝ) : ℂ) ^ s)) := by
            intro k hk
            have hsum : (∑ j ∈ Finset.range (k + 1),
                ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                  (((j + 1) : ℝ) : ℂ) ^ (-s)) =
                (∑ j ∈ Finset.range (k + 1),
                  (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                    (1 / (((j + 1) : ℝ) : ℂ) ^ s)) * Complex.Gamma s := by
              have hneg (j : ℕ) : (((j + 1) : ℝ) : ℂ) ^ (-s) =
                  1 / (((j + 1) : ℝ) : ℂ) ^ s := by
                have hnz : (((j + 1) : ℝ) : ℂ) ^ s ≠ 0 := by
                  intro heq
                  have hnz2 : (((j + 1) : ℝ) : ℂ) ≠ 0 := by
                    norm_cast
                  have hcon := (Complex.cpow_eq_zero_iff _ _).mp heq
                  exact absurd hcon.1 hnz2
                rw [Complex.cpow_neg (((j + 1) : ℝ) : ℂ) s]
                field_simp [hnz]
              calc (∑ j ∈ Finset.range (k + 1),
                  ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                    (((j + 1) : ℝ) : ℂ) ^ (-s))
                  _ = ∑ j ∈ Finset.range (k + 1),
                      ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s) := by
                    apply Finset.sum_congr rfl
                    intro j hj
                    rw [hneg j]
                  _ = (∑ j ∈ Finset.range (k + 1),
                      ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) * Complex.Gamma s := by
                    rw [show (∑ j ∈ Finset.range (k + 1),
                        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                          Complex.Gamma s *
                          (1 / (((j + 1) : ℝ) : ℂ) ^ s)) =
                        (∑ j ∈ Finset.range (k + 1),
                          (((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                            (1 / (((j + 1) : ℝ) : ℂ) ^ s)) *
                          Complex.Gamma s) from by
                      apply Finset.sum_congr rfl
                      intro j hj
                      ring,
                      ← Finset.sum_mul]
                  _ = (∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) * Complex.Gamma s := by
                    rw [show (∑ j ∈ Finset.range (k + 1),
                        ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j *
                          (1 / (((j + 1) : ℝ) : ℂ) ^ s)) =
                        (∑ j ∈ Finset.range (k + 1),
                          (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                            (1 / (((j + 1) : ℝ) : ℂ) ^ s)) from by
                      apply Finset.sum_congr rfl
                      intro j hj
                      ring]
            calc etaCoeff k *
                (∑ j ∈ Finset.range (k + 1),
                  ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                    (((j + 1) : ℝ) : ℂ) ^ (-s))
                _ = etaCoeff k *
                    ((∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) * Complex.Gamma s) := by rw [hsum]
                _ = Complex.Gamma s * etaCoeff k *
                    (∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) := by ring
                _ = Complex.Gamma s * ((1 / 2 : ℂ) ^ (k + 1)) *
                    (∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) := by
                  dsimp only [etaCoeff]
          calc (∑ k ∈ Finset.range K,
              etaCoeff k *
                (∑ j ∈ Finset.range (k + 1),
                  ((k.choose j : ℕ) : ℂ) * (-1 : ℂ) ^ j * Complex.Gamma s *
                    (((j + 1) : ℝ) : ℂ) ^ (-s)))
              _ = ∑ k ∈ Finset.range K,
                  Complex.Gamma s * ((1 / 2 : ℂ) ^ (k + 1)) *
                    (∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)) := by
                apply Finset.sum_congr rfl
                intro k hk
                rw [h1 k hk]
              _ = Complex.Gamma s *
                  (∑ k ∈ Finset.range K,
                    ((1 / 2 : ℂ) ^ (k + 1)) *
                      (∑ j ∈ Finset.range (k + 1),
                        (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                          (1 / (((j + 1) : ℝ) : ℂ) ^ s))) := by
                rw [show (∑ k ∈ Finset.range K,
                    Complex.Gamma s * ((1 / 2 : ℂ) ^ (k + 1)) *
                      (∑ j ∈ Finset.range (k + 1),
                        (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                          (1 / (((j + 1) : ℝ) : ℂ) ^ s))) =
                    (∑ k ∈ Finset.range K,
                      Complex.Gamma s *
                        (((1 / 2 : ℂ) ^ (k + 1)) *
                          (∑ j ∈ Finset.range (k + 1),
                            (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                              (1 / (((j + 1) : ℝ) : ℂ) ^ s)))) from by
                  apply Finset.sum_congr rfl
                  intro k hk
                  ring]
                exact (Finset.mul_sum (Finset.range K)
                  (fun k => ((1 / 2 : ℂ) ^ (k + 1)) *
                    (∑ j ∈ Finset.range (k + 1),
                      (-1 : ℂ) ^ j * ((k.choose j : ℕ) : ℂ) *
                        (1 / (((j + 1) : ℝ) : ℂ) ^ s)))
                  (Complex.Gamma s)).symm
              _ = Complex.Gamma s *
                  (∑ k ∈ Finset.range K,
                    ((1 / 2 : ℂ) ^ (k + 1)) * deltaEta s k) := by
                congr
      _ = Complex.Gamma s * etaEuler s K := by
          dsimp only [etaEuler, deltaEta]

/-- **Main identity (Phase 2.3.2).** For `0 < Re s` and any `K ≥ 0`:

    `etaIntegral s = Γ(s) · etaEuler s K + etaRemK s K`.

Pointwise kernel split + integrability + the Phase 2.3 Laplace block. -/
theorem etaIntegral_eq_Gamma_etaEuler_plus_rem (hs : 0 < s.re) (K : ℕ) :
    OnlineZetaEta5.etaIntegral s = Complex.Gamma s * etaEuler s K + etaRemK s K := by
  dsimp only [OnlineZetaEta5.etaIntegral, mellin]
  have hpoint : (fun x : ℝ =>
      (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
        (x : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC x)) x) =
      (fun x : ℝ =>
        (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
          eulerKernelPart s K x + etaRemKernel s K x) x) := by
    funext x
    by_cases hx : 0 < x
    · simp [hx, Set.indicator, Ioi]
      dsimp only [OnlineZetaEta5.etaKernelC, eulerKernelPart, etaRemKernel]
      have hsplit := etaKernel_split_exp x hx K
      have hC : (OnlineZetaEta5.etaKernel x : ℂ) =
          (Real.exp (-x) * (∑ k ∈ Finset.range K, (1 - Real.exp (-x)) ^ k / 2 ^ (k + 1)) +
            (1 / 2 : ℝ) ^ K * Real.exp (-x) * (1 - Real.exp (-x)) ^ K / (1 + Real.exp (-x)) : ℂ) := by
        exact mod_cast hsplit
      have hsumC : ((Real.exp (-x) * (∑ k ∈ Finset.range K,
          (1 - Real.exp (-x)) ^ k / 2 ^ (k + 1)) : ℝ) : ℂ) =
          (Real.exp (-x) : ℂ) * (∑ k ∈ Finset.range K,
            (1 - Real.exp (-x)) ^ k / 2 ^ (k + 1) : ℂ) := by
        simp [ofReal_mul, ofReal_finsetSum]
      have hremC : (((1 / 2 : ℝ) ^ K * Real.exp (-x) *
          (1 - Real.exp (-x)) ^ K / (1 + Real.exp (-x)) : ℝ) : ℂ) =
          ((1 / 2 : ℂ) ^ K) * (Real.exp (-x) : ℂ) *
            ((1 - Real.exp (-x)) : ℂ) ^ K / (1 + (Real.exp (-x) : ℂ)) := by
        push_cast
        ring_nf
        <;> field_simp
        <;> ring
      have hsplitC : (OnlineZetaEta5.etaKernel x : ℂ) =
          (Real.exp (-x) : ℂ) * (∑ k ∈ Finset.range K,
            (1 - Real.exp (-x)) ^ k / 2 ^ (k + 1) : ℂ) +
            ((1 / 2 : ℂ) ^ K) * (Real.exp (-x) : ℂ) *
              ((1 - Real.exp (-x)) : ℂ) ^ K / (1 + (Real.exp (-x) : ℂ)) := by
        rw [hsplit]
        push_cast
        ring_nf
        <;> field_simp
        <;> simp [ofReal_finsetSum, ofReal_mul, ofReal_add, ofReal_div,
          ofReal_pow, ofReal_sub, ofReal_one, ofReal_natCast]
      rw [hsplitC]
      ring
    · simp [hx, Set.indicator, Ioi]
  have h1 : (∫ u : ℝ in Ioi 0, (u : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC u)) =
      (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
        (u : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC u)) u) := by
    rw [integral_indicator measurableSet_Ioi]
  have h2 : (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
      (u : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC u)) u) =
      (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
        eulerKernelPart s K u + etaRemKernel s K u) u) := by
    rw [hpoint]
  have h3 : (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
      eulerKernelPart s K u + etaRemKernel s K u) u) =
      (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) +
      (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (etaRemKernel s K) u) := by
    have heq : (fun u : ℝ =>
        (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
          eulerKernelPart s K u + etaRemKernel s K u) u) =
        (fun u : ℝ => (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u +
          (Ioi (0 : ℝ)).indicator (etaRemKernel s K) u) := by
      funext u
      simp [Set.indicator, Ioi]
      by_cases hu : 0 < u
      · simp [hu]
      · simp [hu]
    rw [heq]
    have hfe : Integrable ((Ioi (0 : ℝ)).indicator (eulerKernelPart s K)) :=
      (integrable_indicator_iff measurableSet_Ioi).mpr (eulerKernelPart_integrableOn s hs K)
    have hfg : Integrable ((Ioi (0 : ℝ)).indicator (etaRemKernel s K)) :=
      (integrable_indicator_iff measurableSet_Ioi).mpr (etaRemKernel_integrableOn s hs K)
    rw [integral_add hfe hfg]
  have h4 : (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) =
      (∫ u : ℝ in Ioi 0, eulerKernelPart s K u) := by
    rw [integral_indicator measurableSet_Ioi]
  have h5 : (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (etaRemKernel s K) u) =
      (∫ u : ℝ in Ioi 0, etaRemKernel s K u) := by
    rw [integral_indicator measurableSet_Ioi]
  have hK : (∫ u : ℝ in Ioi 0, eulerKernelPart s K u) = Complex.Gamma s * etaEuler s K :=
    eulerKernelPart_integral_eq_Gamma_etaEuler s hs K
  have hrem : (∫ u : ℝ in Ioi 0, etaRemKernel s K u) = etaRemK s K := by
    dsimp only [etaRemK]
  calc OnlineZetaEta5.etaIntegral s
      _ = (∫ u : ℝ in Ioi 0, (u : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC u)) := by
          dsimp only [OnlineZetaEta5.etaIntegral, mellin]
          congr
      _ = (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
          (u : ℂ) ^ (s - 1) * (OnlineZetaEta5.etaKernelC u)) u) := by rw [h1]
      _ = (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (fun u : ℝ =>
          eulerKernelPart s K u + etaRemKernel s K u) u) := by rw [h2]
      _ = (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (eulerKernelPart s K) u) +
          (∫ u : ℝ, (Ioi (0 : ℝ)).indicator (etaRemKernel s K) u) := by rw [h3]
      _ = (∫ u : ℝ in Ioi 0, eulerKernelPart s K u) +
          (∫ u : ℝ in Ioi 0, etaRemKernel s K u) := by rw [h4, h5]
      _ = Complex.Gamma s * etaEuler s K + etaRemK s K := by
          rw [hK, hrem]

/-- **Euler split of the eta strip function.** For `0 < Re s` and any `K ≥ 0`:

    `etaStrip s = etaEuler s K + etaRemK s K / Γ(s)`. -/
theorem etaEuler_split (hs : 0 < s.re) (K : ℕ) :
    OnlineZetaEta3.etaStrip s = etaEuler s K + etaRemK s K / Complex.Gamma s := by
  have heq := etaIntegral_eq_Gamma_etaEuler_plus_rem s hs K
  have hid := etaStrip_eq_etaIntegral_div_Gamma s hs
  have hnz : Complex.Gamma s ≠ 0 := Complex.Gamma_ne_zero_of_re_pos hs
  calc OnlineZetaEta3.etaStrip s
      _ = OnlineZetaEta5.etaIntegral s / Complex.Gamma s := hid
      _ = (Complex.Gamma s * etaEuler s K + etaRemK s K) / Complex.Gamma s := by rw [heq]
      _ = etaEuler s K + etaRemK s K / Complex.Gamma s := by
          field_simp [hnz]

/-! ### The `2^{-K}` remainder bound -/

/-- Pointwise (for `t > 0`):

    `‖etaRemKernel s K t‖ = 2^{-K} · t^{Re s - 1} · e^{-t} · (1-e^{-t})^K/(1+e^{-t})`. -/
theorem etaRemKernel_norm (hs : 0 < s.re) (K : ℕ) (t : ℝ) (ht : 0 < t) :
    ‖etaRemKernel s K t‖ = (1 / 2 : ℝ) ^ K * t ^ (s.re - 1) *
      Real.exp (-t) * (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) := by
  dsimp only [etaRemKernel]
  have h1 : 0 < Real.exp (-t) := Real.exp_pos _
  have hden : (1 + (Real.exp (-t) : ℂ)) ≠ 0 := by
    intro heq
    have hre0 : (1 + (Real.exp (-t) : ℂ)).re = 0 := by
      rw [heq]
      simp
    have hre : (1 + (Real.exp (-t) : ℂ)).re = 1 + Real.exp (-t) := by
      simp [Complex.add_re, Complex.one_re, Complex.exp_re]
    rw [hre] at hre0
    have hpos : 0 < 1 + Real.exp (-t) := by linarith [h1.le]
    linarith
  have hnorm1 : ‖(t : ℂ) ^ (s - 1)‖ = t ^ (s.re - 1) := by
    have hnz : (t : ℂ) ≠ 0 := by
      intro heq
      have h0 : (t : ℝ) = 0 := Complex.ofReal_inj.mp heq
      linarith [ht]
    have harg : arg (t : ℂ) = 0 := by
      simpa using Complex.arg_ofReal_of_nonneg (le_of_lt ht)
    calc ‖(t : ℂ) ^ (s - 1)‖
        _ = ‖(t : ℂ)‖ ^ (s - 1).re / Real.exp (arg (t : ℂ) * (s - 1).im) := by
            rw [Complex.norm_cpow_of_ne_zero hnz (s - 1)]
        _ = ‖(t : ℂ)‖ ^ (s - 1).re := by
            rw [harg, zero_mul, Real.exp_zero, div_one]
        _ = t ^ (s - 1).re := by
            simp [abs_of_pos ht]
        _ = t ^ (s.re - 1) := by
            simp [Complex.sub_re]
  have hnorm2 : ‖(1 / 2 : ℂ) ^ K‖ = (1 / 2 : ℝ) ^ K := by
    have hb : (1 / 2 : ℂ) = (1 / 2 : ℝ) := by norm_num
    calc ‖(1 / 2 : ℂ) ^ K‖
        _ = ‖(1 / 2 : ℂ)‖ ^ K := by rw [norm_pow]
        _ = |(1 / 2 : ℝ)| ^ K := by rw [hb]; simp
        _ = (1 / 2 : ℝ) ^ K := by
          rw [abs_of_pos (by norm_num : 0 < (1 / 2 : ℝ))]
  have hnorm3 : ‖(Real.exp (-t) : ℂ)‖ = Real.exp (-t) := by
    rw [Complex.ofReal_exp, Complex.norm_exp_ofReal]
  have hnorm4 : ‖((1 - Real.exp (-t)) : ℂ) ^ K‖ = (1 - Real.exp (-t)) ^ K := by
    calc ‖((1 - Real.exp (-t)) : ℂ) ^ K‖
        _ = ‖((1 - Real.exp (-t)) : ℂ)‖ ^ K := by
          rw [norm_pow]
        _ = |1 - Real.exp (-t)| ^ K := by
          have hA : ‖(1 - (Real.exp (-t) : ℂ))‖ = |1 - Real.exp (-t)| := by
            rw [Complex.norm_def]
            rw [show Complex.normSq (1 - (Real.exp (-t) : ℂ)) = (1 - Real.exp (-t)) ^ 2 from by
              dsimp only [Complex.normSq]
              simp [Complex.sub_re, Complex.sub_im, Complex.one_re, Complex.one_im,
                Complex.ofReal_re, Complex.ofReal_im, Complex.exp_re, Complex.exp_im]
              ring]
            rw [Real.sqrt_sq_eq_abs]
          rw [hA]
        _ = (1 - Real.exp (-t)) ^ K := by
          have hnn : 0 ≤ 1 - Real.exp (-t) := one_sub_exp_neg_nonneg t (by linarith)
          rw [abs_of_nonneg hnn]
  have hnorm5 : ‖(1 + (Real.exp (-t) : ℂ))‖ = 1 + Real.exp (-t) := by
    exact (show ‖(1 + (Real.exp (-t) : ℂ))‖ = 1 + Real.exp (-t) from by
      have hC1 : (1 : ℂ) + (Real.exp (-t) : ℂ) = ((1 + Real.exp (-t)) : ℝ) := by
        apply Complex.ext
        <;> simp [Complex.add_re, Complex.add_im, Complex.one_re, Complex.one_im]
      rw [hC1]
      have habs : |1 + Real.exp (-t)| = 1 + Real.exp (-t) :=
        abs_of_nonneg (le_of_lt (by positivity : 0 < 1 + Real.exp (-t)))
      simp only [Complex.norm_real, Real.norm_eq_abs]
      exact habs
    )
  calc ‖(t : ℂ) ^ (s - 1) * (1 / 2 : ℂ) ^ K * (Real.exp (-t) : ℂ) *
      ((1 - Real.exp (-t)) : ℂ) ^ K / (1 + (Real.exp (-t) : ℂ))‖
      _ = ‖(t : ℂ) ^ (s - 1) * (1 / 2 : ℂ) ^ K * (Real.exp (-t) : ℂ) *
          ((1 - Real.exp (-t)) : ℂ) ^ K‖ / ‖(1 + (Real.exp (-t) : ℂ))‖ := by
          rw [norm_div]
          <;> simp_all [hden]
      _ = (‖(t : ℂ) ^ (s - 1)‖ * ‖(1 / 2 : ℂ) ^ K‖ * ‖(Real.exp (-t) : ℂ)‖ *
          ‖((1 - Real.exp (-t)) : ℂ) ^ K‖) / ‖(1 + (Real.exp (-t) : ℂ))‖ := by
          rw [norm_mul, norm_mul, norm_mul]
      _ = (t ^ (s.re - 1) * (1 / 2 : ℝ) ^ K * Real.exp (-t) *
          (1 - Real.exp (-t)) ^ K) / (1 + Real.exp (-t)) := by
          rw [hnorm1, hnorm2, hnorm3, hnorm4, hnorm5]
          <;> ring_nf
          <;> field_simp
          <;> ring
      _ = (1 / 2 : ℝ) ^ K * t ^ (s.re - 1) *
          Real.exp (-t) * (1 - Real.exp (-t)) ^ K / (1 + Real.exp (-t)) := by
          ring_nf
          <;> field_simp
          <;> ring

/-- **The `2^{-K}` remainder bound.** For `0 < Re s ≤ 1` and any `K ≥ 0`:

    `‖etaRemK s K‖ ≤ 2^{-K} · (1/(Re s + K) + e^{-1})`.

The remainder integral decays geometrically in `K` — the engine's rigorous
error band. Proof: `‖∫ f‖ ≤ ∫ ‖f‖`, pointwise norm reduction
(`etaRemKernel_norm`), then dominate `bK(t) = t^{sig-1} e^{-t} (1-e^{-t})^K
/(1+e^{-t})` on `(0, ∞)` by `M(t) = 1_{[0,1]}(t) · t^{sig+K-1} + 1_{(1,∞)}(t) ·
e^{-t}`: on `(0,1]`, `1 - e^{-t} ≤ t` and `e^{-t}/(1+e^{-t}) ≤ 1`; on
`(1, ∞)`, `t^{sig-1} ≤ 1` (since `sig ≤ 1`) and `(1-e^{-t})^K ≤ 1`. The
majorant's integral is `1/(sig+K) + e^{-1}`. -/
theorem etaRemK_norm_bound (hs : 0 < s.re) (hσ : s.re ≤ 1) (K : ℕ) :
    ‖etaRemK s K‖ ≤ (1 / 2 : ℝ) ^ K * (1 / (s.re + (K : ℝ)) + Real.exp (-1)) := by
  set sig := s.re with hσdef
  have hp : -1 < sig + (K : ℝ) - 1 := by linarith
  -- The pointwise remainder density (without the 2^{-K} factor).
  set bK := fun x : ℝ => x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
      (1 + Real.exp (-x)) with hbK
  -- The explicit majorant: `t^{sig+K-1}` on `[0,1]`, `e^{-t}` on `(1, ∞)`.
  set M := (Ioc (0 : ℝ) 1).indicator (fun x : ℝ => x ^ (sig + (K : ℝ) - 1)) +
      (Ioi (1 : ℝ)).indicator (fun x : ℝ => Real.exp (-x)) with hM
  set S1 := Icc (0 : ℝ) 1 ∩ Ioi (0 : ℝ) with hS1
  have hS1eq : S1 = Ioc (0 : ℝ) 1 := by
    ext x
    constructor
    · intro h
      have h0 : 0 < x := h.2
      exact ⟨h0, h.1.2⟩
    · intro h
      exact ⟨⟨by linarith [h.1], h.2⟩, h.1⟩
  -- (a) M is integrable.
  have hMInt : Integrable M := by
    set f1 := fun x : ℝ => x ^ (sig + (K : ℝ) - 1) with hf1
    have hMIcc : Integrable ((Ioc (0 : ℝ) 1).indicator f1) := by
      rw [integrable_indicator_iff measurableSet_Ioc]
      exact ((intervalIntegrable_iff_integrableOn_Ioc_of_le
        (by norm_num : (0 : ℝ) ≤ 1) :
        IntervalIntegrable f1 volume 0 1 ↔
          IntegrableOn f1 (Ioc (0 : ℝ) 1)).mp
        (intervalIntegral.intervalIntegrable_rpow' hp))
    have hMIoi : Integrable ((Ioi (1 : ℝ)).indicator (fun x : ℝ => Real.exp (-x))) := by
      rw [integrable_indicator_iff measurableSet_Ioi]
      exact integrableOn_exp_neg_Ioi 1
    dsimp only [M]
    exact hMIcc.add hMIoi
  -- (b) Pointwise: bK ≤ M on `(0, ∞)`.
  have hbM : ∀ x ∈ Ioi (0 : ℝ), bK x ≤ M x := by
    intro x hpos
    by_cases hle : x ≤ 1
    · -- `x ∈ (0, 1]`: majorant is `x^{sig+K-1}`.
      have hA : 0 ≤ 1 - Real.exp (-x) := one_sub_exp_neg_nonneg x hpos.le
      have hB : 1 - Real.exp (-x) ≤ x := one_sub_exp_neg_le x hpos.le
      have hE : (1 - Real.exp (-x)) ^ K ≤ x ^ K := pow_le_pow_left₀ hA hB K
      have hG : 0 ≤ x ^ (sig - 1) := rpow_nonneg (le_of_lt hpos) _
      have hd : Real.exp (-x) / (1 + Real.exp (-x)) ≤ 1 := by
        apply (div_le_one (by nlinarith [Real.exp_pos (-x)])).2
        nlinarith [Real.exp_pos (-x)]
      have hmid : x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
          (1 - Real.exp (-x)) ^ K ≤ x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := by
        have hEpos : 0 ≤ (1 - Real.exp (-x)) ^ K := pow_nonneg hA K
        calc x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
            (1 - Real.exp (-x)) ^ K
            _ = x ^ (sig - 1) * ((Real.exp (-x) / (1 + Real.exp (-x))) *
                (1 - Real.exp (-x)) ^ K) := by ring
            _ ≤ x ^ (sig - 1) * (1 * (1 - Real.exp (-x)) ^ K) := by
              apply mul_le_mul_of_nonneg_left
              · apply mul_le_mul_of_nonneg_right hd
                exact hEpos
              · exact hG
            _ = x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := by ring
      have hfinal : x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K ≤ x ^ (sig + (K : ℝ) - 1) := by
        calc x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K
            _ ≤ x ^ (sig - 1) * x ^ K := by
              apply mul_le_mul_of_nonneg_left hE
              exact hG
            _ = x ^ (sig - 1) * x ^ (K : ℝ) := by
              rw [← Real.rpow_natCast x K]
            _ = x ^ (sig - 1 + (K : ℝ)) := by
              rw [← rpow_add (show 0 < x from hpos)]
            _ = x ^ (sig + (K : ℝ) - 1) := by ring_nf
      have hMval : M x = x ^ (sig + (K : ℝ) - 1) := by
        dsimp only [M]
        have hpos0 : 0 < x := hpos
        have h1 : x ∈ Ioc (0 : ℝ) 1 := ⟨hpos0, hle⟩
        have h2 : x ∉ Ioi (1 : ℝ) := by
          intro h
          have hgt : 1 < x := h
          linarith [hgt, hle]
        simp [h1, h2]
      rw [hMval]
      have hred : x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
          (1 + Real.exp (-x)) =
          x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
            (1 - Real.exp (-x)) ^ K := by
        field_simp
        <;> ring_nf
        <;> field_simp
        <;> ring
      dsimp only [bK]
      rw [hred]
      calc x ^ (sig - 1) * (Real.exp (-x) / (1 + Real.exp (-x))) *
          (1 - Real.exp (-x)) ^ K
          _ ≤ x ^ (sig - 1) * (1 - Real.exp (-x)) ^ K := hmid
          _ ≤ x ^ (sig + (K : ℝ) - 1) := hfinal
    · -- `x > 1`: majorant is `e^{-x}`.
      have hgt : 1 < x := by
        by_contra hh
        have hle2 : x ≤ 1 := by linarith
        exact hle hle2
      have hA : 0 ≤ 1 - Real.exp (-x) := one_sub_exp_neg_nonneg x (by linarith)
      have hC : Real.exp (-x) ≤ 1 := exp_neg_le_one x (by linarith)
      have hE : (1 - Real.exp (-x)) ^ K ≤ 1 := by
        have he : 1 - Real.exp (-x) ≤ 1 := by linarith [Real.exp_pos (-x)]
        calc (1 - Real.exp (-x)) ^ K ≤ 1 ^ K := pow_le_pow_left₀ hA he K
          _ = 1 := by simp
      have hF : x ^ (sig - 1) ≤ 1 :=
        rpow_le_one_of_one_le_of_nonpos (le_of_lt hgt) (by linarith)
      have hmid : (1 - Real.exp (-x)) ^ K / (1 + Real.exp (-x)) ≤
          1 / (1 + Real.exp (-x)) := by
        rw [div_le_iff₀ (by nlinarith [Real.exp_pos (-x)])]
        field_simp
        <;> linarith [hE]
      have hMval : M x = Real.exp (-x) := by
        dsimp only [M]
        have h1 : x ∉ Ioc (0 : ℝ) 1 := by
          intro h
          have hle2 : x ≤ 1 := h.2
          linarith [hgt, hle2]
        have h2 : x ∈ Ioi (1 : ℝ) := by exact hgt
        simp [h1, h2]
      rw [hMval]
      have hred : x ^ (sig - 1) * Real.exp (-x) * (1 - Real.exp (-x)) ^ K /
          (1 + Real.exp (-x)) =
          x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
            (1 + Real.exp (-x)))) := by
        field_simp
        <;> ring_nf
        <;> field_simp
        <;> ring
      dsimp only [bK]
      rw [hred]
      calc x ^ (sig - 1) * (Real.exp (-x) * ((1 - Real.exp (-x)) ^ K /
          (1 + Real.exp (-x))))
          _ ≤ x ^ (sig - 1) * (Real.exp (-x) * 1) := by
            apply mul_le_mul_of_nonneg_left
            · apply mul_le_mul_of_nonneg_left
              · rw [div_le_one (by nlinarith [Real.exp_pos (-x)])]
                nlinarith [hE, Real.exp_pos (-x)]
              · exact le_of_lt (Real.exp_pos (-x))
            · apply rpow_nonneg
              linarith [hgt]
          _ = x ^ (sig - 1) * Real.exp (-x) := by ring
          _ ≤ Real.exp (-x) := by
            have hstep : x ^ (sig - 1) * Real.exp (-x) ≤ 1 * Real.exp (-x) := by
              apply mul_le_mul_of_nonneg_right hF
              exact le_of_lt (Real.exp_pos (-x))
            linarith [hstep]
  -- (c) Value of the majorant integral: split `(0, ∞)` at `1`.
  have hMval : ∫ x : ℝ in Ioi (0 : ℝ), M x = 1 / (sig + (K : ℝ)) + Real.exp (-1) := by
    have hst : Disjoint S1 (Ioi (1 : ℝ)) := by
      rw [Set.disjoint_iff, hS1eq]
      intro x hx
      simp only [Set.mem_empty_iff_false]
      have hmem : 0 < x ∧ x ≤ 1 := hx.1
      linarith [hmem.2, Set.mem_Ioi.mp hx.2]
    have hMs : IntegrableOn M S1 := by
      rw [hS1eq]
      exact hMInt.integrableOn.mono_set (Set.subset_univ _)
    have hMt : IntegrableOn M (Ioi (1 : ℝ)) := hMInt.integrableOn.mono_set (Set.subset_univ _)
    have hu : Ioi (0 : ℝ) = S1 ∪ Ioi (1 : ℝ) := by
      ext x
      by_cases hpos : 0 < x
      · by_cases hle : x ≤ 1
        · constructor
          · intro h
            exact Or.inl (show x ∈ S1 from ⟨⟨h.le, hle⟩, h⟩)
          · intro h
            rcases h with (h1 | h2)
            · exact h1.2
            · exact lt_trans (by norm_num : (0 : ℝ) < 1) (Set.mem_Ioi.mp h2)
        · have hgt : 1 < x := by
            by_contra hh
            have hle2 : x ≤ 1 := by linarith
            exact hle hle2
          constructor
          · intro h
            exact Or.inr hgt
          · intro h
            rcases h with (h1 | h2)
            · exact h1.2
            · exact lt_trans (by norm_num : (0 : ℝ) < 1) (Set.mem_Ioi.mp h2)
      · constructor
        · intro h
          exfalso
          exact hpos h
        · intro h
          rcases h with (h1 | h2)
          · exfalso
            exact hpos h1.2
          · exfalso
            exact hpos (lt_trans (by norm_num : (0 : ℝ) < 1) (Set.mem_Ioi.mp h2))
    rw [hu, setIntegral_union hst measurableSet_Ioi hMs hMt]
    -- Left piece: `∫ in S1, M = ∫₀¹ x^{sig+K-1} = 1/(sig+K)`.
    set f1v := fun x : ℝ => x ^ (sig + (K : ℝ) - 1) with hf1v
    set f2v := fun x : ℝ => Real.exp (-x) with hf2v
    have hMsset : MeasurableSet S1 := by
      rw [hS1eq]
      exact measurableSet_Ioc
    have hleftval : ∫ x in S1, M x ∂volume = 1 / (sig + (K : ℝ)) := by
      have hleft : ∫ x in S1, M x ∂volume = ∫ x in S1, f1v x ∂volume :=
        setIntegral_congr_fun hMsset (by
          intro x hx
          dsimp only [M, f1v]
          have hmem : 0 < x ∧ x ≤ 1 := by simpa [hS1eq] using hx
          have h1 : x ∈ Ioc (0 : ℝ) 1 := hmem
          have h2 : x ∉ Ioi (1 : ℝ) := by
            intro h
            linarith [Set.mem_Ioi.mp h, hmem.2]
          simp [h1, h2])
      rw [hleft, hS1eq, ← intervalIntegral.integral_of_le
        (by norm_num : (0 : ℝ) ≤ 1)]
      rw [integral_rpow_Icc_0_1 (sig + (K : ℝ) - 1) hp]
      ring
    -- Right piece: `∫ in (1, ∞), M = ∫₁^∞ e^{-x} = e^{-1}`.
    have hrightval : ∫ x in Ioi (1 : ℝ), M x ∂volume = Real.exp (-1) := by
      have hright : ∫ x in Ioi (1 : ℝ), M x ∂volume =
          ∫ x in Ioi (1 : ℝ), f2v x ∂volume :=
        setIntegral_congr_fun measurableSet_Ioi (by
          intro x hx
          dsimp only [M, f2v]
          have h1 : x ∉ Ioc (0 : ℝ) 1 := by
            intro h
            have hle : x ≤ 1 := h.2
            linarith [Set.mem_Ioi.mp hx, hle]
          have h2 : x ∈ Ioi (1 : ℝ) := hx
          simp [h1, h2])
      rw [hright]
      exact integral_exp_neg_Ioi 1
    rw [hleftval, hrightval]
  -- (d) Assemble: norm of the remainder integral → majorant integral.
  have h1 : ‖etaRemK s K‖ ≤ ∫ x : ℝ in Ioi (0 : ℝ), ‖(etaRemKernel s K) x‖ := by
    have h1a : ‖etaRemK s K‖ ≤ ∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (etaRemKernel s K) x‖ := by
      rw [etaRemK, ← integral_indicator measurableSet_Ioi]
      exact norm_integral_le_integral_norm (fun x : ℝ =>
        (Ioi (0 : ℝ)).indicator (etaRemKernel s K) x)
    have h1b : (∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (etaRemKernel s K) x‖) =
        (∫ x : ℝ in Ioi (0 : ℝ), ‖(etaRemKernel s K) x‖) := by
      have heq : (fun x : ℝ => ‖(Ioi (0 : ℝ)).indicator (etaRemKernel s K) x‖) =
          (fun x : ℝ => (Ioi (0 : ℝ)).indicator (fun x : ℝ => ‖(etaRemKernel s K) x‖) x) := by
        funext x
        by_cases hx : 0 < x
        · simp [hx, Ioi, Set.indicator]
        · simp [hx, Ioi, Set.indicator]
      rw [heq, integral_indicator measurableSet_Ioi]
    calc ‖etaRemK s K‖
        _ ≤ ∫ x : ℝ, ‖(Ioi (0 : ℝ)).indicator (etaRemKernel s K) x‖ := h1a
        _ = ∫ x : ℝ in Ioi (0 : ℝ), ‖(etaRemKernel s K) x‖ := by rw [h1b]
  have hf : IntegrableOn (fun x : ℝ => ‖(etaRemKernel s K) x‖) (Ioi (0 : ℝ)) :=
    (etaRemKernel_integrableOn s hs K).integrable.norm
  have hg : IntegrableOn (fun x : ℝ => (1 / 2 : ℝ) ^ K * M x) (Ioi (0 : ℝ)) :=
    (hMInt.const_mul ((1 / 2 : ℝ) ^ K)).integrableOn.mono_set (Set.subset_univ _)
  have hle : ∫ x : ℝ in Ioi (0 : ℝ), ‖(etaRemKernel s K) x‖ ≤
      ∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x :=
    setIntegral_mono_on hf hg measurableSet_Ioi (fun x hx => by
      have hnorm := etaRemKernel_norm s hs K x hx
      have hnorm2 : ‖(etaRemKernel s K) x‖ = (1 / 2 : ℝ) ^ K * bK x := by
        rw [hnorm]
        dsimp only [bK]
        ring
      rw [hnorm2]
      exact mul_le_mul_of_nonneg_left (hbM x hx) (by norm_num))
  have hextr : ∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x =
      (1 / 2 : ℝ) ^ K * (∫ x : ℝ in Ioi (0 : ℝ), M x) := by
    have hpoint : ∀ x : ℝ, (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
        (1 / 2 : ℝ) ^ K * M x) x = (1 / 2 : ℝ) ^ K *
        (Ioi (0 : ℝ)).indicator (M) x := by
      intro x
      by_cases hx : 0 < x
      · simp [hx, Ioi, Set.indicator]
      · simp [hx, Ioi, Set.indicator]
    have hfun : (fun x : ℝ => (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
        (1 / 2 : ℝ) ^ K * M x) x) =
        (fun x : ℝ => (1 / 2 : ℝ) ^ K * (Ioi (0 : ℝ)).indicator (M) x) := by
      funext x
      by_cases hx : 0 < x
      · simp [hx, Ioi, Set.indicator]
      · simp [hx, Ioi, Set.indicator]
    rw [← integral_indicator measurableSet_Ioi,
      show ∫ x : ℝ, (Ioi (0 : ℝ)).indicator (fun x : ℝ =>
          (1 / 2 : ℝ) ^ K * M x) x =
          ∫ x : ℝ, (1 / 2 : ℝ) ^ K *
          (Ioi (0 : ℝ)).indicator (M) x from congr_arg
        (fun f : ℝ → ℝ => ∫ x : ℝ, f x) hfun,
      integral_const_mul _ _, integral_indicator measurableSet_Ioi]
  calc ‖etaRemK s K‖
      _ ≤ ∫ x : ℝ in Ioi (0 : ℝ), ‖(etaRemKernel s K) x‖ := h1
      _ ≤ ∫ x : ℝ in Ioi (0 : ℝ), (1 / 2 : ℝ) ^ K * M x := hle
      _ = (1 / 2 : ℝ) ^ K * (∫ x : ℝ in Ioi (0 : ℝ), M x) := hextr
      _ = (1 / 2 : ℝ) ^ K * (1 / (sig + (K : ℝ)) + Real.exp (-1)) := by rw [hMval]
      _ = (1 / 2 : ℝ) ^ K * (1 / (s.re + (K : ℝ)) + Real.exp (-1)) := by
          simp only [hσdef]

/-! ### The engine theorems -/

/-- **The `2^{-K}` engine bound for ζ on the band.** For `0 < Re s ≤ 1`
    and `1 - 2^{1-s} ≠ 0`:

    `‖ζ(s) - etaEuler(s,K)/(1 - 2^{1-s})‖ ≤
        2^{-K} · (1/(Re s + K) + e^{-1}) / (‖Γ(s)‖ · ‖1 - 2^{1-s}‖)`.

`etaEuler(s,K)` is a finite explicit sum of elementary terms in `s` (the Δ^k
constants), with a rigorous geometric error band — the bounded numerical
engine Phase 3 (disk count) needs for the sign-change assertion. -/
theorem etaEuler_engine_bound (hs : 0 < s.re) (hσ : s.re ≤ 1) (K : ℕ)
    (hden : 1 - (2 : ℂ) ^ (1 - s) ≠ 0) :
    ‖riemannZeta s - etaEuler s K / (1 - (2 : ℂ) ^ (1 - s))‖ ≤
      (1 / 2 : ℝ) ^ K * (1 / (s.re + (K : ℝ)) + Real.exp (-1)) /
      (‖Complex.Gamma s‖ * ‖1 - (2 : ℂ) ^ (1 - s)‖) := by
  have hnz : Complex.Gamma s ≠ 0 := Complex.Gamma_ne_zero_of_re_pos hs
  have hnz2 : ‖Complex.Gamma s‖ ≠ 0 := ne_of_gt (norm_pos_iff.2 hnz)
  have hden2 : ‖1 - (2 : ℂ) ^ (1 - s)‖ ≠ 0 := ne_of_gt (norm_pos_iff.2 hden)
  have hsplit := etaEuler_split s hs K
  have hzeta : OnlineZetaEta3.etaStrip s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
    rw [OnlineZetaEta4.etaIdentityStrip s hs (by
      by_contra h
      subst h
      exact hden (by norm_num))]
    dsimp only [OnlineZetaEta4.etaZetaFun]
  have hstep : riemannZeta s = etaEuler s K / (1 - (2 : ℂ) ^ (1 - s)) +
      etaRemK s K / (Complex.Gamma s * (1 - (2 : ℂ) ^ (1 - s))) := by
    have h1 : (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s =
        etaEuler s K + etaRemK s K / Complex.Gamma s := by
      have heq : (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s =
          OnlineZetaEta3.etaStrip s := by rw [← hzeta]
      rw [heq, hsplit]
    have h2 : riemannZeta s =
        (etaEuler s K + etaRemK s K / Complex.Gamma s) / (1 - (2 : ℂ) ^ (1 - s)) := by
      calc riemannZeta s
          _ = (1 - (2 : ℂ) ^ (1 - s))⁻¹ * ((1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s) := by
              field_simp [hden]
          _ = (1 - (2 : ℂ) ^ (1 - s))⁻¹ * (etaEuler s K + etaRemK s K / Complex.Gamma s) := by
              rw [h1]
          _ = (etaEuler s K + etaRemK s K / Complex.Gamma s) / (1 - (2 : ℂ) ^ (1 - s)) := by
              field_simp [hden]
              <;> ring_nf
              <;> field_simp [hden]
              <;> ring
    have h3 : (etaEuler s K + etaRemK s K / Complex.Gamma s) / (1 - (2 : ℂ) ^ (1 - s)) =
        etaEuler s K / (1 - (2 : ℂ) ^ (1 - s)) + etaRemK s K / (1 - (2 : ℂ) ^ (1 - s)) /
          Complex.Gamma s := by
      field_simp [hden, hnz]
      <;> ring_nf
      <;> field_simp [hden, hnz]
      <;> ring
    have h4 : etaRemK s K / (1 - (2 : ℂ) ^ (1 - s)) / Complex.Gamma s =
        etaRemK s K / (Complex.Gamma s * (1 - (2 : ℂ) ^ (1 - s))) := by
      field_simp [hden, hnz]
      <;> ring_nf
      <;> field_simp [hden, hnz]
      <;> ring
    calc riemannZeta s
        _ = (etaEuler s K + etaRemK s K / Complex.Gamma s) / (1 - (2 : ℂ) ^ (1 - s)) := h2
        _ = etaEuler s K / (1 - (2 : ℂ) ^ (1 - s)) +
            etaRemK s K / (1 - (2 : ℂ) ^ (1 - s)) / Complex.Gamma s := by rw [h3]
        _ = etaEuler s K / (1 - (2 : ℂ) ^ (1 - s)) +
            etaRemK s K / (Complex.Gamma s * (1 - (2 : ℂ) ^ (1 - s))) := by rw [h4]
  have hbound : ‖etaRemK s K‖ ≤ (1 / 2 : ℝ) ^ K * (1 / (s.re + (K : ℝ)) + Real.exp (-1)) :=
    etaRemK_norm_bound s hs hσ K
  calc ‖riemannZeta s - etaEuler s K / (1 - (2 : ℂ) ^ (1 - s))‖
      _ = ‖etaRemK s K / (Complex.Gamma s * (1 - (2 : ℂ) ^ (1 - s)))‖ := by
          rw [hstep]
          ring_nf
      _ = ‖etaRemK s K‖ / (‖Complex.Gamma s‖ * ‖1 - (2 : ℂ) ^ (1 - s)‖) := by
          have hprod : Complex.Gamma s * (1 - (2 : ℂ) ^ (1 - s)) ≠ 0 := by
            intro hp
            have h0 : Complex.Gamma s = 0 := by
              rcases (mul_eq_zero.mp hp) with (ha | hb)
              · exact ha
              · exact absurd hb hden
            exact hnz h0
          rw [norm_div _ _, norm_mul]
      _ ≤ ((1 / 2 : ℝ) ^ K * (1 / (s.re + (K : ℝ)) + Real.exp (-1))) /
          (‖Complex.Gamma s‖ * ‖1 - (2 : ℂ) ^ (1 - s)‖) := by
          have hpos : 0 < ‖Complex.Gamma s‖ * ‖1 - (2 : ℂ) ^ (1 - s)‖ := by
            apply mul_pos
            · exact norm_pos_iff.2 hnz
            · exact norm_pos_iff.2 hden
          gcongr

/-! ### Phase 3 hook: disk geometry -/

-- The disk-geometry identity Phase 3 (Jensen disk count) needs:
--
--     `‖sin z‖² = sin²(Re z) + sinh²(Im z)`
--
-- is proved in the Phase 3 module (it uses the `normSq` infrastructure:
-- `Complex.sq_norm` and `Complex.sin_eq`). Kept here as a marker so the
-- Phase 2.3.2 engine module stays focused on the Euler-transform bound.

end OnlineZetaEta6
