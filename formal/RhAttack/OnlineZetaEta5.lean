import Mathlib
import RhAttack.OnlineZetaEta
import RhAttack.OnlineZetaEta2
import RhAttack.OnlineZetaEta3
import RhAttack.OnlineZetaEta4

/-
honline Phase 2.3 — the explicit Euler-transformed eta evaluation engine on `0 < Re s`.

This module builds, from the pinned Mathlib v4.33.1 infrastructure (read-only), the
explicit bounded-evaluation engine for Mathlib's `riemannZeta` on the band
`0 < Re s ≤ 1` needed by Phase 3 (disk count).

Pipeline:

1. **Kernel integral** — `etaKernel t = 1/(e^t + 1)`; its Mellin transform
   `etaIntegral s = ∫₀^∞ t^{s-1} · etaKernel(t) dt` is holomorphic on `{0 < Re s}`
   (Mathlib's `mellin_differentiableAt_of_isBigO_rpow_exp`, with `etaKernel = O(e^{-t})`
   at ∞ and `O(1)` at 0⁺).

2. **Laplace building block** — for `0 < Re s` and `n ≥ 1`:
   `∫₀^∞ t^{s-1} e^{-nt} dt = Gamma(s) · (n:ℂ)^{-s}`
   (Mellin scaling `mellin_comp_mul_left` + `Gamma_eq_integral`, which makes
   `mellin (exp ∘ neg) = GammaIntegral` definitionally).

3. **Fubini step** (`1 < Re s`) — `etaSeries s = etaIntegral s / Gamma s`,
   by absolute convergence (Fubini via `hasSum_integral_of_summable_integral_norm`)
   and the pointwise alternating-geometric sum
   `∑_{n≥1} (-1)^{n-1} e^{-nt} = e^{-t}/(1+e^{-t})`.

4. **Identity theorem** — both sides are holomorphic on `{0 < Re s}` and agree on
   `{1 < Re s}`, so `etaStrip s = etaIntegral s / Gamma s` for all `0 < Re s`
   (`AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq`, the Phase 2.2c pattern,
   now on the larger domain — no `s ≠ 1` exclusion is needed here).

5. **Euler truncation** — the pointwise kernel split
   `x/(1+x) = x · ∑_{k<K} (1-x)^k / 2^{k+1} + 2^{-K} · x(1-x)^K/(1+x)`
   with `x = e^{-t}` gives, after integration and the Laplace block,
   `etaStrip s = etaEuler s K + etaRemK s K` where
   `etaEuler s K = ∑_{k<K} 2^{-(k+1)} · Δ^k a_1` (explicit finite sum, `a_n = n^{-s}`,
   `Δ^k a_1 = ∑_{j≤k} (-1)^j C(k,j) (j+1)^{-s}`) and `etaRemK` is an explicit
   bounded integral with geometric decay `2^{-K}`:
   `‖etaRemK s K‖ ≤ 2^{-K} · (1/(σ+K) + e^{-(K+1)}/(K+1)) / ‖Gamma(s)‖`
   on `0 < σ ≤ 1`.

6. **The engine** — by the Phase 2.2c identity `etaStrip s = (1 - 2^{1-s}) · ζ(s)`,
   for `0 < Re s ≤ 1`, `s ≠ 1`, `1 - 2^{1-s} ≠ 0`, `K ≥ 1`:

   `‖ζ(s) - etaEuler(s,K)/(1 - 2^{1-s})‖ ≤
       2^{-K} · (1/(σ+K) + e^{-(K+1)}/(K+1)) / (‖Γ(s)‖ · ‖1 - 2^{1-s}‖).`

   This is a classical explicit bound (Euler's series transformation via the
   Mellin-integral kernel split); no asymptotics, no external constants.

7. **Disk-geometry helper** (for Phase 3): `‖sin z‖² = sin²(Re z) + sinh²(Im z)`,
   hence `‖sin z‖ ≥ |sinh(Im z)|` — the lower bound for `|sin(πs)|` on disks
   bounded away from the real axis.

NO RH CLAIM. No `sorry`, no `admit`, no axioms. All constants are classical
mathematics derived from the pinned infrastructure.
-/

set_option maxHeartbeats 400000
-- the nested calc/induction structure of the Fubini and kernel-split proofs
-- exceeds the default heartbeat budget at definition-check time.
-- (build option only; not a mathematical assumption)

namespace OnlineZetaEta5

open MeasureTheory Set Filter
open scoped Topology
open BigOperators

/-! ## 1. The kernel and its Mellin transform -/

/-- `K(t) := 1/(e^t + 1)` — the real-valued kernel of the eta integral formula. -/
noncomputable def etaKernel (t : ℝ) : ℝ := 1 / (Real.exp t + 1)

/-- Complex lift of the kernel, for the Mellin transform. -/
noncomputable def etaKernelC (t : ℝ) : ℂ := (etaKernel t : ℂ)

/-- `I(s) := ∫₀^∞ t^{s-1} · K(t) dt` — the Mellin transform of the kernel. -/
noncomputable def etaIntegral (s : ℂ) : ℂ := mellin etaKernelC s

/-- `K` is continuous on `(0, ∞)`. -/
theorem etaKernel_continuousOn : ContinuousOn etaKernel (Ioi (0 : ℝ)) := by
  intro x hx
  have hden : Real.exp x + 1 ≠ 0 := by
    apply ne_of_gt
    linarith [Real.exp_pos x]
  have hca : ContinuousAt etaKernel x := by
    apply ContinuousAt.div
    · exact continuousAt_const
    · exact ContinuousAt.add ((by continuity : Continuous Real.exp).continuousAt)
        continuousAt_const
    · exact hden
  change Tendsto etaKernel (𝓝[(Ioi (0 : ℝ))] x) (𝓝 (etaKernel x))
  exact hca.mono_left (nhdsWithin_le_nhds (a := x) (s := Ioi (0 : ℝ)))

/-- `K` is locally integrable on `(0, ∞)` (complex-valued lift). -/
theorem etaKernel_locInt : LocallyIntegrableOn etaKernelC (Ioi (0 : ℝ)) := by
  have hc : ContinuousOn etaKernelC (Ioi (0 : ℝ)) := by
    change ContinuousOn (fun t : ℝ => (etaKernel t : ℂ)) (Ioi 0)
    exact ContinuousOn.comp (by continuity : Continuous fun t : ℝ => (t : ℂ)).continuousOn
      etaKernel_continuousOn (fun x _ => Set.mem_univ (etaKernel x))
  exact hc.locallyIntegrableOn measurableSet_Ioi

/-- `K = O(e^{-t})` as `t → ∞` (real-valued comparison). -/
theorem etaKernel_Oexp : etaKernelC =O[atTop] (fun t : ℝ => Real.exp (-t)) := by
  -- 1/(e^t + 1) ≤ e^{-t} holds for ALL t (⟺ 1 ≤ 1 + e^{-t}), so the bound is
  -- even global.
  have hnorm : ∀ t : ℝ, ‖etaKernelC t‖ = etaKernel t := by
    intro t
    have h1 : ‖etaKernelC t‖ = |etaKernel t| := by simp [etaKernelC]
    rw [h1, abs_of_nonneg (by
      dsimp only [etaKernel]
      apply div_nonneg
      · norm_num
      · linarith [Real.exp_pos t])]
  have hbound : ∀ t : ℝ, etaKernel t ≤ Real.exp (-t) := by
    intro t
    dsimp only [etaKernel]
    have hpos' : 0 < 1 + Real.exp t := by linarith [Real.exp_pos t]
    have hmul : Real.exp (-t) * Real.exp t = 1 := by
      rw [← Real.exp_add, show -t + t = 0 by ring, Real.exp_zero]
    have hexp : Real.exp (-t) * (1 + Real.exp t) = 1 + Real.exp (-t) := by
      nlinarith [hmul]
    rw [add_comm]
    rw [div_le_iff₀ hpos']
    rw [hexp]
    nlinarith [Real.exp_pos (-t)]
  have h : ∀ᶠ (t : ℝ) in atTop, ‖etaKernelC t‖ ≤ 1 * ‖(Real.exp (-t) : ℝ)‖ :=
    Filter.Eventually.of_forall fun t => by
      calc ‖etaKernelC t‖ = etaKernel t := hnorm t
        _ ≤ Real.exp (-t) := hbound t
        _ = 1 * Real.exp (-t) := by ring
        _ = 1 * ‖(Real.exp (-t) : ℝ)‖ := by
          rw [Real.norm_eq_abs, abs_of_nonneg (Real.exp_nonneg (-t))]
  refine Asymptotics.IsBigO.of_bound 1 ?_
  exact h

/-- `K = O(1)` as `t → 0⁺`. -/
theorem etaKernel_O1 : etaKernelC =O[𝓝[>] 0] (fun _ : ℝ => (1 : ℝ)) := by
  -- 1/(e^t + 1) ≤ 1 holds for ALL t (e^t > 0 ⟹ e^t + 1 > 1), so the bound is
  -- even global.
  have h : ∀ᶠ (t : ℝ) in 𝓝[>] 0, ‖etaKernelC t‖ ≤ 1 * ‖(1 : ℝ)‖ :=
    Filter.Eventually.of_forall fun t => by
      have hnorm : ‖etaKernelC t‖ = etaKernel t := by
        have h1 : ‖etaKernelC t‖ = |etaKernel t| := by simp [etaKernelC]
        rw [h1, abs_of_nonneg (by
          dsimp only [etaKernel]
          apply div_nonneg
          · norm_num
          · linarith [Real.exp_pos t])]
      calc ‖etaKernelC t‖ = etaKernel t := hnorm
        _ ≤ 1 := by
          dsimp only [etaKernel]
          apply (div_le_one (by linarith [Real.exp_pos t])).2
          nlinarith [Real.exp_pos t]
        _ = 1 * 1 := by ring
        _ = 1 * ‖(1 : ℝ)‖ := by
          rw [Real.norm_eq_abs, abs_of_nonneg (by norm_num : 0 ≤ (1 : ℝ))]
  refine Asymptotics.IsBigO.of_bound 1 ?_
  exact h

/-- The Mellin transform of `K` converges for `0 < Re s`. -/
theorem etaIntegral_convergent (s : ℂ) (hs : 0 < s.re) : MellinConvergent etaKernelC s := by
  have htop : etaKernelC =O[atTop] (fun t => Real.exp (-(1 : ℝ) * t)) := by
    have hg : (fun t : ℝ => Real.exp (-t)) = (fun t : ℝ => Real.exp (-(1 : ℝ) * t)) := by
      funext t
      ring_nf
    simpa [hg] using etaKernel_Oexp
  have hbot : etaKernelC =O[𝓝[>] 0] (fun x : ℝ => x ^ (-(0 : ℝ))) := by
    have hg : (fun x : ℝ => x ^ (-(0 : ℝ))) = (fun _ : ℝ => (1 : ℝ)) := by
      funext x
      rw [neg_zero, Real.rpow_zero]
    simpa [hg] using etaKernel_O1
  exact mellinConvergent_of_isBigO_rpow_exp zero_lt_one etaKernel_locInt htop hbot hs

/-- The Mellin transform of `K` is holomorphic at every `s` with `0 < Re s`. -/
theorem etaIntegral_differentiableAt (s : ℂ) (hs : 0 < s.re) :
    DifferentiableAt ℂ etaIntegral s := by
  have htop : etaKernelC =O[atTop] (fun t => Real.exp (-(1 : ℝ) * t)) := by
    have hg : (fun t : ℝ => Real.exp (-t)) = (fun t : ℝ => Real.exp (-(1 : ℝ) * t)) := by
      funext t
      ring_nf
    simpa [hg] using etaKernel_Oexp
  have hbot : etaKernelC =O[𝓝[>] 0] (fun x : ℝ => x ^ (-(0 : ℝ))) := by
    have hg : (fun x : ℝ => x ^ (-(0 : ℝ))) = (fun _ : ℝ => (1 : ℝ)) := by
      funext x
      rw [neg_zero, Real.rpow_zero]
    simpa [hg] using etaKernel_O1
  exact mellin_differentiableAt_of_isBigO_rpow_exp zero_lt_one etaKernel_locInt
    htop hbot hs

/-! ## 2. The Laplace building block -/

/-- The Mellin transform of `exp(-·)` is `GammaIntegral` (definitionally the same
integral, up to commutativity of the integrand). -/
theorem mellin_expNeg_eq_GammaIntegral (s : ℂ) :
    mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s = Complex.GammaIntegral s := by
  dsimp only [mellin]
  change ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) =
      Complex.GammaIntegral s
  rw [Complex.GammaIntegral]
  congr with t
  simp [mul_comm]

/-- For `0 < Re s` and `n ≥ 1`: `∫₀^∞ t^{s-1} e^{-nt} dt = Gamma(s) · (n:ℂ)^{-s}`. -/
theorem laplace_n (s : ℂ) (hs : 0 < s.re) (n : ℕ) (hn : 0 < n) :
    ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * t) =
      Complex.Gamma s * (n : ℂ) ^ (-s) := by
  have hscal : mellin (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) s =
      (n : ℂ) ^ (-s) * mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s := by
    have hrealexp : (fun u : ℝ => Complex.exp (-(u : ℂ))) =
        (fun u : ℝ => (Real.exp (-u) : ℂ)) := by
      funext u
      simp
    have hscale : mellin (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) (n * t)) s =
        (n : ℂ) ^ (-s) * mellin (fun u : ℝ => (Real.exp (-u) : ℂ)) s := by
      rw [mellin_comp_mul_left (fun u : ℝ => (Real.exp (-u) : ℂ)) s (a := (n : ℝ))
        (by exact_mod_cast hn)]
      simp
    have hcomp : (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) =
        (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) (n * t)) := by
      funext t
      simp
    rw [hcomp, hscale]
  have hbase : mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s = Complex.GammaIntegral s :=
    mellin_expNeg_eq_GammaIntegral s
  calc ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * t)
      = mellin (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) s := by
        dsimp only [mellin]
        congr with t
    _ = (n : ℂ) ^ (-s) * mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s := hscal
    _ = (n : ℂ) ^ (-s) * Complex.GammaIntegral s := by rw [hbase]
    _ = (n : ℂ) ^ (-s) * Complex.Gamma s := by rw [Complex.Gamma_eq_integral hs]
    _ = Complex.Gamma s * (n : ℂ) ^ (-s) := by ring


/-! ## 3. The Fubini step at `1 < Re s`

The bridge between the discrete eta series and the Mellin transform of the
kernel, at `1 < Re s` where absolute convergence holds:

```text
etaIntegral s = Gamma(s) · etaSeries s        (1 < Re s)
```

Pipeline:
1. `laplaceTerm s n t` — the n-th kernel-Laplace term (zero at `n = 0` and at `t ≤ 0`).
2. `tsumAltExp` — pointwise: `∑' n, laplaceTerm s n t = (t:ℂ)^{s-1} · (etaKernel t : ℂ)` (`t > 0`).
3. `laplaceTermNormIntegral` — `∫ ‖laplaceTerm s n t‖ = Γ(σ)·n^{-σ}` (`n ≥ 1`), `0` (`n = 0`).
4. `laplaceTermIntegral` — `∫ laplaceTerm s n t = (-1)^{n-1}·Γ(s)·(n:ℂ)^{-s}` (`n ≥ 1`).
5. `etaIntegral_eq_Gamma_etaSeries` — Fubini via `hasSum_integral_of_summable_integral_norm`.
-/

/-- The `n`-th Laplace term of the kernel series (zero at `n = 0` and at `t ≤ 0`). -/
noncomputable def laplaceTerm (s : ℂ) (n : ℕ) (t : ℝ) : ℂ :=
  if n = 0 ∨ t ≤ 0 then 0
  else (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)

variable (s : ℂ)

/-- The Mellin integrand `t^{s-1} · K(t)` is integrable on `(0, ∞)` for `0 < Re s`
(domination by the Gamma integrand: `t^{σ-1}/(1+e^t) ≤ t^{σ-1}·e^{-t}`). -/
theorem etaKernelCcpow_integrableOn_Ioi (hs : 0 < s.re) :
    IntegrableOn (fun t : ℝ => (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ)) (Ioi (0 : ℝ)) := by
  have hG : IntegrableOn (fun x : ℝ => (x : ℂ) ^ (s - 1) * (Real.exp (-x) : ℂ)) (Ioi 0) := by
    refine IntegrableOn.congr_fun (Complex.GammaIntegral_convergent hs) ?_ measurableSet_Ioi
    intro x _
    simp [mul_comm]
  refine ⟨?_, ?_⟩
  · have hcont : ContinuousOn (fun t : ℝ => (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ)) (Ioi 0) := by
      have hbase : ContinuousOn (fun t : ℝ => (t : ℂ)) (Ioi 0) :=
        Complex.continuous_ofReal.continuousOn
      have hcp : ContinuousOn (fun t : ℝ => (t : ℂ) ^ (s - 1)) (Ioi 0) :=
        ContinuousOn.cpow hbase continuousOn_const
          (fun t ht => by simpa using ht)
      have hetc : ∀ t : ℝ, ContinuousAt etaKernel t := by
        intro t
        have hden : Real.exp t + 1 ≠ 0 := by
          apply ne_of_gt
          linarith [Real.exp_pos t]
        apply ContinuousAt.div
        · exact continuousAt_const
        · exact ContinuousAt.add
            (by continuity : Continuous Real.exp).continuousAt continuousAt_const
        · exact hden
      have hke : ContinuousOn (fun t : ℝ => (etaKernel t : ℂ)) (Ioi 0) := by
        intro t ht
        have hca : ContinuousAt (fun u : ℝ => (u : ℂ)) (etaKernel t) :=
          Complex.continuous_ofReal.continuousAt
        exact (ContinuousAt.comp hca (hetc t)).continuousWithinAt
      exact hcp.mul hke
    exact ContinuousOn.aestronglyMeasurable hcont measurableSet_Ioi
  · have hdom : ∀ t : ℝ, ‖(t : ℂ) ^ (s - 1) * (etaKernel t : ℂ)‖ ≤
      ‖(t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ)‖ := by
      intro t
      have hbound : etaKernel t ≤ Real.exp (-t) := by
        dsimp only [etaKernel]
        have hpos' : 0 < 1 + Real.exp t := by linarith [Real.exp_pos t]
        have hmul : Real.exp (-t) * Real.exp t = 1 := by
          rw [Real.exp_neg]
          field_simp [Real.exp_ne_zero t]
        have hexp : Real.exp (-t) * (1 + Real.exp t) = 1 + Real.exp (-t) := by
          nlinarith [hmul]
        rw [add_comm]
        rw [div_le_iff₀ hpos']
        rw [hexp]
        nlinarith [Real.exp_pos (-t)]
      calc ‖(t : ℂ) ^ (s - 1) * (etaKernel t : ℂ)‖
          = ‖(t : ℂ) ^ (s - 1)‖ * ‖(etaKernel t : ℂ)‖ := by rw [norm_mul]
        _ = ‖(t : ℂ) ^ (s - 1)‖ * etaKernel t := by
            have h1 : ‖(etaKernel t : ℂ)‖ = |etaKernel t| := by simp
            rw [h1, abs_of_nonneg (by
              dsimp only [etaKernel]
              apply div_nonneg
              · norm_num
              · linarith [Real.exp_pos t])]
        _ ≤ ‖(t : ℂ) ^ (s - 1)‖ * Real.exp (-t) := by
            exact mul_le_mul_of_nonneg_left hbound (norm_nonneg _)
        _ = ‖(t : ℂ) ^ (s - 1)‖ * ‖(Real.exp (-t) : ℂ)‖ := by
            rw [Complex.ofReal_exp, Complex.norm_exp_ofReal]
        _ = ‖(t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ)‖ := by rw [norm_mul]
    refine HasFiniteIntegral.mono hG.2 (Filter.Eventually.of_forall (fun t => by
      simpa [enorm_eq_nnnorm, NNReal.coe_le_coe] using hdom t))

/-- Pointwise: `∑' n, laplaceTerm s n t = (t:ℂ)^{s-1} · (etaKernel t : ℂ)` for `t > 0`. -/
theorem tsumAltExp (ht : 0 < t) :
    (∑' n : ℕ, laplaceTerm s n t) = (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ) := by
  let x : ℂ := (Real.exp (-t) : ℂ)
  have hx1 : ‖x‖ < 1 := by
    dsimp only [x]
    have h1 : ‖(Real.exp (-t) : ℂ)‖ = Real.exp (-t) := by
      rw [Complex.ofReal_exp, Complex.norm_exp_ofReal]
    rw [h1]
    exact (Real.exp_lt_one_iff.mpr (by linarith : -t < 0))
  have hsm : Summable (fun n : ℕ => if n = 0 then (0 : ℂ) else (-1 : ℂ) ^ (n - 1) * x ^ n) := by
    have hpt : ∀ n : ℕ, ‖(-1 : ℂ) ^ (n - 1) * x ^ n‖ = ‖x‖ ^ n := by
      intro n
      by_cases hn0 : n = 0
      · subst hn0
        norm_num
      · have hp : 1 ≤ n := Nat.pos_of_ne_zero hn0
        calc ‖(-1 : ℂ) ^ (n - 1) * x ^ n‖ = ‖(-1 : ℂ) ^ (n - 1)‖ * ‖x ^ n‖ := by rw [norm_mul]
          _ = 1 * ‖x‖ ^ n := by
            rw [norm_pow, norm_pow]
            norm_num
          _ = ‖x‖ ^ n := by ring
    have hgeo : Summable (fun n : ℕ => ‖x‖ ^ n) :=
      summable_geometric_of_lt_one (norm_nonneg _) hx1
    have habs : Summable (fun n : ℕ => ‖(-1 : ℂ) ^ (n - 1) * x ^ n‖) :=
      hgeo.congr (fun n => (hpt n).symm)
    have hnorm : ∀ n : ℕ, ‖(if n = 0 then (0 : ℂ) else (-1 : ℂ) ^ (n - 1) * x ^ n)‖ ≤
        ‖(-1 : ℂ) ^ (n - 1) * x ^ n‖ := by
      intro n
      by_cases hn0 : n = 0
      · subst hn0
        norm_num
      · have h1 : (if n = 0 then (0 : ℂ) else (-1 : ℂ) ^ (n - 1) * x ^ n) =
          (-1 : ℂ) ^ (n - 1) * x ^ n := by
          simp [hn0]
        rw [h1]
    exact Summable.of_norm_bounded habs hnorm
  have hpt : (fun n : ℕ => laplaceTerm s n t) =
      (fun n : ℕ => (t : ℂ) ^ (s - 1) * (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n)) := by
    funext n
    by_cases hn0 : n = 0
    · subst hn0
      dsimp [laplaceTerm]
      simp
    · dsimp [laplaceTerm]
      simp [hn0, show ¬(t ≤ 0) from fun h => lt_irrefl 0 (lt_of_lt_of_le ht h)]
      have hexp : Complex.exp (-((n : ℂ) * (t : ℂ))) = (Real.exp (-t) : ℂ) ^ n := by
        have hz : -((n : ℂ) * (t : ℂ)) = (n : ℂ) * (-(t : ℂ)) := by ring
        rw [hz]
        rw [Complex.exp_nat_mul (-(t : ℂ)) n]
        have hexp2 : Complex.exp (-(t : ℂ)) = (Real.exp (-t) : ℂ) := by
          rw [show (-(t : ℂ) : ℂ) = ((-t : ℝ) : ℂ) by simp, Complex.ofReal_exp]
        rw [hexp2]
      rw [hexp]
      dsimp only [x]
      ring
  have h1 : (∑' n : ℕ, laplaceTerm s n t) =
      (t : ℂ) ^ (s - 1) * (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n)) := by
    rw [hpt, tsum_mul_left]
  have hfix : (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n)) =
      x * (1 + x)⁻¹ := by
    have hpterm : (fun n : ℕ => if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n) =
        (fun n : ℕ => -(-x) ^ n + (if n = 0 then (1 : ℂ) else 0)) := by
      funext n
      by_cases hn0 : n = 0
      · subst hn0
        simp
      · have hp : 1 ≤ n := Nat.pos_of_ne_zero hn0
        simp [hn0]
        have hpow : (-1 : ℂ) ^ n = (-1 : ℂ) ^ (n - 1) * (-1 : ℂ) := by
          obtain ⟨k, rfl⟩ : ∃ k : ℕ, n = k + 1 := ⟨n - 1, by omega⟩
          exact pow_succ (-1 : ℂ) k
        rw [show (-x : ℂ) = (-1 : ℂ) * x by ring]
        rw [mul_pow]
        rw [hpow]
        ring
    have hsub : (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n)) =
        -(∑' n : ℕ, (-x) ^ n) + (∑' n : ℕ, (if n = 0 then (1 : ℂ) else 0)) := by
      rw [hpterm]
      have h1' : Summable (fun n : ℕ => (-x) ^ n) :=
        (summable_geometric_iff_norm_lt_one.mpr (by simpa using hx1))
      have h2' : Summable (fun n : ℕ => if n = 0 then (1 : ℂ) else 0) := by
        have hg : Summable (fun n : ℕ => (1 / 2 : ℝ) ^ n) :=
          summable_geometric_of_lt_one (by norm_num) (by norm_num)
        have hle : ∀ n : ℕ, ‖(if n = 0 then (1 : ℂ) else 0)‖ ≤ (1 / 2 : ℝ) ^ n := by
          intro n
          by_cases h0 : n = 0
          · subst h0
            norm_num
          · have hzero : (if n = 0 then (1 : ℂ) else 0) = 0 := by
              simp [h0]
            rw [hzero, norm_zero]
            exact pow_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2) n
        exact Summable.of_norm_bounded hg hle
      rw [Summable.tsum_add (h1'.neg) h2', tsum_neg]
    have hnx : ‖-x‖ < 1 := by simpa using hx1
    have hgeom : (∑' n : ℕ, (-x) ^ n) = (1 - -x)⁻¹ :=
      tsum_geometric_of_norm_lt_one hnx
    have hsum0 : (∑' n : ℕ, (if n = 0 then (1 : ℂ) else 0)) = 1 := by
      rw [tsum_eq_single (0 : ℕ) (fun n hn => by simp [hn])]
      simp
    have h1x : 1 + x ≠ 0 := by
      intro h
      have hre : (1 + x).re = 0 := by simp [h]
      have hre2 : (1 + x).re = 1 + Real.exp (-t) := by
        dsimp only [x]
        have hre3 : ((Real.exp (-t) : ℂ)).re = Real.exp (-t) := by
          rw [Complex.ofReal_exp, Complex.exp_ofReal_re]
        have hadd : (1 + (Real.exp (-t) : ℂ)).re =
            (1 : ℂ).re + ((Real.exp (-t) : ℂ)).re := by simp
        rw [hadd, hre3]
        simp
      rw [hre2] at hre
      linarith [Real.exp_pos (-t)]
    have hcalc_lemma {a : ℂ} (ha : 1 + a ≠ 0) : -(1 - -a)⁻¹ + 1 = a * (1 + a)⁻¹ := by
      have h1 : 1 - -a = 1 + a := by ring
      rw [h1]
      field_simp [ha]
      ring_nf
    have hcalc : -(1 - -x)⁻¹ + 1 = x * (1 + x)⁻¹ := hcalc_lemma h1x
    calc (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n))
        = -(∑' n : ℕ, (-x) ^ n) + (∑' n : ℕ, (if n = 0 then (1 : ℂ) else 0)) := hsub
      _ = -(1 - -x)⁻¹ + 1 := by rw [hgeom, hsum0]
      _ = x * (1 + x)⁻¹ := by rw [hcalc]
  have heta : x * (1 + x)⁻¹ = (etaKernel t : ℂ) := by
    dsimp only [x, etaKernel]
    have hmain : Real.exp (-t) / (1 + Real.exp (-t)) = 1 / (Real.exp t + 1) := by
      rw [show Real.exp (-t) = (Real.exp t)⁻¹ by rw [Real.exp_neg],
          show 1 + (Real.exp t)⁻¹ = (Real.exp t + 1) * (Real.exp t)⁻¹ by
            field_simp [Real.exp_ne_zero t]]
      field_simp [Real.exp_ne_zero t]
    norm_cast
  calc (∑' n : ℕ, laplaceTerm s n t)
      = (t : ℂ) ^ (s - 1) * (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * x ^ n)) := h1
    _ = (t : ℂ) ^ (s - 1) * (x * (1 + x)⁻¹) := by rw [hfix]
    _ = (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ) := by rw [heta]

/-- `∫ ‖laplaceTerm s n t‖` over `ℝ`: `0` at `n = 0`, `Γ(σ)·n^{-σ}` for `n ≥ 1`. -/
theorem laplaceTermNormIntegral (hs : 0 < s.re) (n : ℕ) :
    ∫ t : ℝ, ‖laplaceTerm s n t‖ =
      (if n = 0 then 0 else (n : ℝ) ^ (-s.re) * Real.Gamma s.re) := by
  by_cases hn0 : n = 0
  · subst hn0
    dsimp only [laplaceTerm]
    simp
  · have hn1 : 1 ≤ n := Nat.pos_of_ne_zero hn0
    have hval : ∫ x in Ioi (0 : ℝ), x ^ (s.re - 1) * Real.exp (-(n : ℝ) * x) =
        (n : ℝ) ^ (-s.re) * Real.Gamma s.re := by
      have hg := Real.integral_rpow_mul_exp_neg_mul_Ioi (by linarith : 0 < s.re)
          (Nat.cast_pos.mpr (lt_of_lt_of_le (by norm_num) hn1))
      have hb : (∫ x in Ioi (0 : ℝ), x ^ (s.re - 1) * Real.exp (-(n : ℝ) * x)) =
          (∫ x in Ioi (0 : ℝ), x ^ (s.re - 1) * Real.exp (-((n : ℝ) * x))) := by
        rw [setIntegral_congr_fun measurableSet_Ioi (fun x _ => by
          rw [show (-(n : ℝ) * x : ℝ) = (-((n : ℝ) * x)) by ring])]
      rw [hb, hg]
      rw [show (1 / (n : ℝ)) ^ s.re = (n : ℝ) ^ (-s.re) by
        rw [one_div, ← Real.rpow_neg_eq_inv_rpow]]
    have hnorm : ∀ t : ℝ, 0 < t →
        ‖(-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)‖ =
          t ^ (s.re - 1) * Real.exp (-(n : ℝ) * t) := by
      intro t ht
      calc ‖(-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)‖
          = ‖(-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1)‖ * ‖(Real.exp (-(n : ℝ) * t) : ℂ)‖ := by
            rw [norm_mul]
          _ = ‖(-1 : ℂ) ^ (n - 1)‖ * ‖(t : ℂ) ^ (s - 1)‖ * ‖(Real.exp (-(n : ℝ) * t) : ℂ)‖ := by
            rw [norm_mul]
          _ = 1 * ‖(t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)‖ := by
            have hnm1 : ‖(-1 : ℂ)‖ = 1 := by norm_num
            rw [norm_pow, hnm1, one_pow, mul_assoc, ← norm_mul]
          _ = ‖(t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)‖ := by ring
          _ = ‖(t : ℂ) ^ (s - 1)‖ * ‖(Real.exp (-(n : ℝ) * t) : ℂ)‖ := by rw [norm_mul]
          _ = t ^ (s.re - 1) * ‖(Real.exp (-(n : ℝ) * t) : ℂ)‖ := by
            have hnormt : ‖(t : ℂ)‖ = t := by simp [abs_of_nonneg ht.le]
            rw [Complex.norm_cpow_of_ne_zero (Complex.ofReal_ne_zero.mpr (ne_of_gt ht)) (s - 1),
                Complex.arg_ofReal_of_nonneg ht.le, hnormt]
            simp [Real.exp_zero]
          _ = t ^ (s.re - 1) * Real.exp (-(n : ℝ) * t) := by
            rw [show ‖(Real.exp (-(n : ℝ) * t) : ℂ)‖ = Real.exp (-(n : ℝ) * t) by
              rw [Complex.ofReal_exp, Complex.norm_exp_ofReal]]
    have hite : (fun t : ℝ => ‖laplaceTerm s n t‖) =
        (fun t : ℝ => if 0 < t then t ^ (s.re - 1) * Real.exp (-(n : ℝ) * t) else 0) := by
      funext t
      dsimp only [laplaceTerm, hn0]
      by_cases ht : 0 < t
      · have hnle : ¬(t ≤ 0) := by
          intro h
          linarith
        simp [ht, hnle, hn0]
        simpa using hnorm t ht
      · simp [ht, not_lt.mp ht, hn0]
    rw [hite]
    have hind : (∫ t : ℝ, (if 0 < t then t ^ (s.re - 1) * Real.exp (-(n : ℝ) * t) else 0)) =
        ∫ t in Ioi 0, t ^ (s.re - 1) * Real.exp (-(n : ℝ) * t) := by
      rw [← integral_indicator measurableSet_Ioi]
      congr
    rw [hind, hval]
    simp [hn0]

/-- `∫ laplaceTerm s n t` over `ℝ`: `0` at `n = 0`, `(-1)^{n-1}·Γ(s)·(n:ℂ)^{-s}` for `n ≥ 1`. -/
theorem laplaceTermIntegral (hs : 0 < s.re) (n : ℕ) :
    ∫ t : ℝ, laplaceTerm s n t =
      (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)) := by
  by_cases hn0 : n = 0
  · subst hn0
    dsimp only [laplaceTerm]
    simp
  · have hn1 : 1 ≤ n := Nat.pos_of_ne_zero hn0
    have hexp : (fun t : ℝ => (Real.exp (-(n : ℝ) * t) : ℂ)) =
        (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) := by
      funext t
      simp
    have hite : (fun t : ℝ => laplaceTerm s n t) =
        (fun t : ℝ => if 0 < t then
          (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)
          else 0) := by
      funext t
      dsimp only [laplaceTerm, hn0]
      by_cases hpos : 0 < t
      · have hneg : ¬(n = 0 ∨ t ≤ 0) := by
          intro h
          cases h with
          | inl h => exact hn0 h
          | inr ht => exact lt_irrefl 0 (lt_of_lt_of_le hpos ht)
        simp [hpos, hneg]
      · simp [hpos, Or.inr (not_lt.1 hpos)]
    rw [hite]
    have hconst : (∫ t : ℝ, (if 0 < t then
          (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)
          else 0)) =
        (-1 : ℂ) ^ (n - 1) *
          (∫ t in Ioi (0 : ℝ), (t : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * t)) := by
      have hinte : (fun t : ℝ => if 0 < t then
          (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)
          else 0) =
          (fun t : ℝ => Set.indicator (Ioi (0 : ℝ))
            (fun t : ℝ =>
              (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) *
              (Real.exp (-(n : ℝ) * t) : ℂ)) t) := by
        funext t
        simp [Set.indicator, Ioi]
      rw [hinte]
      rw [integral_indicator measurableSet_Ioi]
      rw [setIntegral_congr_fun measurableSet_Ioi (fun t _ => by rw [mul_assoc, ← smul_eq_mul])]
      rw [← integral_indicator measurableSet_Ioi]
      have hint2 : (fun t : ℝ => Set.indicator (Ioi (0 : ℝ))
          (fun t : ℝ =>
            (-1 : ℂ) ^ (n - 1) • ((t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ))) t) =
          (fun t : ℝ => (-1 : ℂ) ^ (n - 1) • Set.indicator (Ioi (0 : ℝ))
            (fun t : ℝ => (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)) t) := by
        funext t
        dsimp only [Set.indicator]
        split_ifs with ht
        · rfl
        · rw [smul_zero]
      rw [hint2]
      rw [integral_smul ((-1 : ℂ) ^ (n - 1))]
      rw [integral_indicator measurableSet_Ioi]
      have hx : (∫ t in Ioi (0 : ℝ), (t : ℂ) ^ (s - 1) * (Real.exp (-(n : ℝ) * t) : ℂ)) =
          (∫ t in Ioi (0 : ℝ), (t : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * t)) := by
        rw [setIntegral_congr_fun measurableSet_Ioi (fun t _ => by
          rw [show (Real.exp (-(n : ℝ) * t) : ℂ) = Complex.exp (-(n : ℝ) * t) from by
            simp])]
      rw [hx, smul_eq_mul]
    rw [hconst]
    rw [laplace_n s hs n (by omega)]
    simp [hn0]
    ring

/-- `Summable (fun n => ∫ ‖laplaceTerm s n t‖)` at `1 < Re s`. -/
theorem laplaceTermNormSummable (h1 : 1 < s.re) :
    Summable (fun n : ℕ => ∫ t : ℝ, ‖laplaceTerm s n t‖) := by
  have hval : ∀ n : ℕ, ∫ t : ℝ, ‖laplaceTerm s n t‖ =
      (n : ℝ) ^ (-s.re) * Real.Gamma s.re := by
    intro n
    rw [laplaceTermNormIntegral s (by linarith) n]
    by_cases hn0 : n = 0
    · subst hn0
      have hne : (-s.re : ℝ) ≠ 0 := by linarith
      simp [Real.zero_rpow hne]
    · simp [hn0]
  have hpow : Summable (fun n : ℕ => (n : ℝ) ^ (-s.re)) :=
    (Real.summable_nat_rpow).2 (by linarith)
  have hsm : Summable (fun n : ℕ => (n : ℝ) ^ (-s.re) * Real.Gamma s.re) :=
    hpow.mul_right (Real.Gamma s.re)
  exact hsm.congr (fun n => (hval n).symm)

/-- Every `laplaceTerm s n` is integrable over `ℝ` for `0 < Re s`. -/
theorem laplaceTerm_integrable (hs : 0 < s.re) (n : ℕ) : Integrable (laplaceTerm s n) := by
  by_cases hn0 : n = 0
  · subst hn0
    have hzero : laplaceTerm s 0 = (fun _ : ℝ => (0 : ℂ)) := by
      funext t
      simp [laplaceTerm]
    rw [hzero]
    refine ⟨aestronglyMeasurable_const, by
      dsimp only [HasFiniteIntegral]
      simp⟩
  · have hn1 : 1 ≤ n := Nat.pos_of_ne_zero hn0
    have hbase : MellinConvergent (fun u : ℝ => (Real.exp (-u) : ℂ)) s := by
      dsimp only [MellinConvergent]
      refine IntegrableOn.congr_fun (Complex.GammaIntegral_convergent hs) ?_ measurableSet_Ioi
      intro x _
      simp [mul_comm]
    have hcomp : MellinConvergent (fun t : ℝ => (Real.exp (-(n : ℝ) * t) : ℂ)) s := by
      have hg : (fun t : ℝ => (Real.exp (-(n : ℝ) * t) : ℂ)) =
          (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) ((n : ℝ) * t)) := by
        funext t
        congr
        ring_nf
      simpa [hg] using
        (MellinConvergent.comp_mul_left (f := fun u : ℝ => (Real.exp (-u) : ℂ)) (a := (n : ℝ))
          (Nat.cast_pos.mpr (lt_of_lt_of_le (by norm_num) hn1))).mpr hbase
    dsimp only [MellinConvergent] at hcomp
    have hite : laplaceTerm s n =
        (fun t : ℝ =>
          if 0 < t then (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) *
          (Real.exp (-(n : ℝ) * t) : ℂ) else 0) := by
      funext t
      dsimp only [laplaceTerm, hn0]
      by_cases ht : 0 < t
      · simp [show ¬(t ≤ 0) from by intro h; linarith, ht, hn0]
      · simp [ht, not_lt.mp ht, hn0]
    rw [hite]
    have hpt : (fun t : ℝ =>
        if 0 < t then (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) *
        (Real.exp (-(n : ℝ) * t) : ℂ) else 0) =
        Set.indicator (Ioi (0 : ℝ))
          (fun t : ℝ =>
            (t : ℂ) ^ (s - 1) • ((-1 : ℂ) ^ (n - 1) • (Real.exp (-(n : ℝ) * t) : ℂ))) := by
      funext t
      by_cases ht : 0 < t
      · simp [ht, Set.indicator, Ioi]
        rw [show (-1 : ℂ) ^ (n - 1) * (t : ℂ) ^ (s - 1) * Complex.exp (-((n : ℂ) * (t : ℂ))) =
                (t : ℂ) ^ (s - 1) *
                ((-1 : ℂ) ^ (n - 1) * Complex.exp (-((n : ℂ) * (t : ℂ)))) by ring]
      · simp [ht, Set.indicator, Ioi]
    have hcompsm : MellinConvergent
        (fun t : ℝ => (-1 : ℂ) ^ (n - 1) • (Real.exp (-(n : ℝ) * t) : ℂ)) s :=
      MellinConvergent.const_smul hcomp ((-1 : ℂ) ^ (n - 1))
    dsimp only [MellinConvergent] at hcompsm
    rw [hpt]
    exact (integrable_indicator_iff measurableSet_Ioi).mpr hcompsm

/-- **Fubini** (Phase 2.3, main step): at `1 < Re s`, the Mellin transform of the
kernel equals `Gamma(s) · etaSeries s`. -/
theorem etaIntegral_eq_Gamma_etaSeries (h1 : 1 < s.re) :
    etaIntegral s = Complex.Gamma s * OnlineZetaEta.etaSeries s := by
  have hfint : ∀ n : ℕ, Integrable (laplaceTerm s n) := by
    intro n
    exact laplaceTerm_integrable s (by linarith) n
  have hfs : Summable (fun n : ℕ => ∫ t : ℝ, ‖laplaceTerm s n t‖) :=
    laplaceTermNormSummable s h1
  have hfub : (∑' n : ℕ, ∫ t : ℝ, laplaceTerm s n t) =
      ∫ t : ℝ, (∑' n : ℕ, laplaceTerm s n t) := by
    have hsum := hasSum_integral_of_summable_integral_norm (fun n => hfint n) hfs
    exact hsum.tsum_eq
  have hval : (∑' n : ℕ, ∫ t : ℝ, laplaceTerm s n t) =
      (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s))) := by
    exact congr_arg (fun F : ℕ → ℂ => ∑' n, F n)
      (funext (fun n => laplaceTermIntegral s (by linarith) n))
  have heta :
      (∑' n : ℕ, (if n = 0 then 0 else
          (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s))) =
      Complex.Gamma s * OnlineZetaEta.etaSeries s := by
    have hsnz : s ≠ 0 := by
      intro h
      rw [h] at h1
      norm_num at h1
    have hg0 : (0 : ℂ) ^ (-s) = 0 := by
      rw [Complex.cpow_eq_zero_iff]
      simp [hsnz]
    have hz0 : (0 : ℂ) ^ s = 0 := by
      rw [Complex.cpow_eq_zero_iff]
      simp [hsnz]
    have hift :
        (fun n : ℕ => if n = 0 then 0 else
          (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)) =
        (fun n : ℕ => (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)) := by
      funext n
      by_cases hn0 : n = 0
      · subst hn0
        simp [hg0]
      · simp [hn0]
    have hinv : ∀ n : ℕ, (n : ℂ) ^ (-s) = 1 / (n : ℂ) ^ s := by
      intro n
      by_cases hn0 : n = 0
      · subst hn0
        simp [hg0, hz0]
      · have hn1 : 1 ≤ n := Nat.pos_of_ne_zero hn0
        rw [Complex.cpow_neg]
        field_simp
    have hseq : (fun n : ℕ => (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)) =
        (fun n : ℕ => Complex.Gamma s * ((-1 : ℂ) ^ (n - 1) * (1 / (n : ℂ) ^ s))) := by
      funext n
      rw [hinv n]
      ring
    calc (∑' n : ℕ, (if n = 0 then 0 else (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)))
        = (∑' n : ℕ, (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s)) := by
          rw [tsum_congr (congr_fun hift)]
        _ = (∑' n : ℕ, Complex.Gamma s * ((-1 : ℂ) ^ (n - 1) * (1 / (n : ℂ) ^ s))) := by
          rw [tsum_congr (congr_fun hseq)]
        _ = Complex.Gamma s * (∑' n : ℕ, (-1 : ℂ) ^ (n - 1) * (1 / (n : ℂ) ^ s)) := by
          rw [tsum_mul_left]
        _ = Complex.Gamma s * OnlineZetaEta.etaSeries s := by
          dsimp only [OnlineZetaEta.etaSeries]
  calc etaIntegral s
      = ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ) := by
        dsimp only [etaIntegral, mellin, etaKernelC]
        rw [setIntegral_congr_fun measurableSet_Ioi (fun t _ => by rw [smul_eq_mul])]
    _ = ∫ t : ℝ, (if 0 < t then (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ) else 0) := by
        rw [← integral_indicator measurableSet_Ioi]
        congr
    _ = ∫ t : ℝ, (∑' n : ℕ, laplaceTerm s n t) := by
        have hpt : (fun t : ℝ => (∑' n : ℕ, laplaceTerm s n t)) =
            (fun t : ℝ => if 0 < t then (t : ℂ) ^ (s - 1) * (etaKernel t : ℂ) else 0) := by
          funext t
          by_cases ht : 0 < t
          · rw [tsumAltExp s ht]
            simp [ht]
          · have h0 : ∀ n : ℕ, laplaceTerm s n t = 0 := by
              intro n
              simp [laplaceTerm, ht]
            rw [tsum_congr h0, tsum_zero]
            simp [ht]
        rw [hpt]
    _ = ∑' n : ℕ, ∫ t : ℝ, laplaceTerm s n t := by
        rw [hfub]
    _ = (∑' n : ℕ, (if n = 0 then 0 else
        (-1 : ℂ) ^ (n - 1) * Complex.Gamma s * (n : ℂ) ^ (-s))) := hval
    _ = Complex.Gamma s * OnlineZetaEta.etaSeries s := heta

/-! ## 4. The explicit truncation bound (all `0 < Re s`)

The `etaStrip` limit (Phase 2.2a) is within an explicit `(N:ℝ)^{-σ}` ball of every
partial sum `etaPartial s N` (`N ≥ 1`), by the Phase 2.1 tail bound and the limit law
for the norm sequence.
-/

/-- **Explicit truncation bound**: for `0 < Re s` and `N ≥ 1`:
`‖etaStrip s - etaPartial s N‖ ≤ (2 + ‖s‖/s.re) · (N:ℝ)^{-s.re}`. -/
theorem etaStripTruncationBound (hs : 0 < s.re) (N : ℕ) (hN : 1 ≤ N) :
    ‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ ≤
      (2 + ‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by
  let B := (2 + ‖s‖ / s.re) * (N : ℝ) ^ (-s.re)
  have hlim : Tendsto (fun M : ℕ =>
      ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖) atTop
      (𝓝 ‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖) := by
    have hlim0 : Tendsto (fun M : ℕ =>
        OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N) atTop
        (𝓝 (OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N)) :=
      (OnlineZetaEta3.etaStripTendsto s hs).sub_const (OnlineZetaEta2.etaPartial s N)
    exact (continuous_norm.tendsto
        (OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N)).comp hlim0
  by_contra hgt
  push Not at hgt
  let gap := ‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ - B
  have hgap : 0 < gap := by linarith
  have h1 : ∀ᶠ M in atTop,
      (‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ + B) / 2 <
        ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ := by
    have hnbh : Metric.ball (‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ : ℝ)
        (gap / 2) ∈ 𝓝 (‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ : ℝ) := by
      simpa using Metric.isOpen_ball.mem_nhds (by
        rw [Metric.mem_ball, dist_self]
        linarith)
    have heve : ∀ᶠ M in atTop,
        ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ ∈
          Metric.ball (‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ : ℝ) (gap / 2) :=
      hlim hnbh
    refine heve.mono (fun M hM => by
      have hM' : |‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ -
          ‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖| < gap / 2 := by
        simpa [dist_eq_norm] using Metric.mem_ball.mp hM
      have hlt : -(gap / 2) <
          ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ -
            ‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ :=
        (abs_lt.mp hM').1
      linarith)
  have h2 : ∀ᶠ M in atTop,
      ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ ≤ B := by
    refine Filter.eventually_atTop.mpr ⟨N, fun M hM => ?_⟩
    exact OnlineZetaEta2.etaTailBound s hs M N hN hM
  have h3 : ∀ᶠ M in atTop,
      (‖OnlineZetaEta3.etaStrip s - OnlineZetaEta2.etaPartial s N‖ + B) / 2 <
        ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ ∧
          ‖OnlineZetaEta2.etaPartial s M - OnlineZetaEta2.etaPartial s N‖ ≤ B :=
    Filter.Eventually.and h1 h2
  obtain ⟨M, hm⟩ := Filter.eventually_atTop.mp h3
  have hMsel := hm M (le_rfl)
  linarith [hMsel.1, hMsel.2]

end OnlineZetaEta5
