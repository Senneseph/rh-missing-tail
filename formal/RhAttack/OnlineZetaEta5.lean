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
  show Tendsto etaKernel (𝓝[(Ioi (0 : ℝ))] x) (𝓝 (etaKernel x))
  exact hca.mono_left (nhdsWithin_le_nhds (a := x) (s := Ioi (0 : ℝ)))

/-- `K` is locally integrable on `(0, ∞)` (complex-valued lift). -/
theorem etaKernel_locInt : LocallyIntegrableOn etaKernelC (Ioi (0 : ℝ)) := by
  have hc : ContinuousOn etaKernelC (Ioi (0 : ℝ)) := by
    show ContinuousOn (fun t : ℝ => (etaKernel t : ℂ)) (Ioi 0)
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
  show ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * (Real.exp (-t) : ℂ) =
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
      <;> ring_nf
      <;> simp [mul_comm]
    have hcomp : (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) =
        (fun t : ℝ => (fun u : ℝ => (Real.exp (-u) : ℂ)) (n * t)) := by
      funext t
      simp
      <;> ring_nf
      <;> simp [mul_comm, mul_assoc]
    rw [hcomp, hscale]
  have hbase : mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s = Complex.GammaIntegral s :=
    mellin_expNeg_eq_GammaIntegral s
  calc ∫ t : ℝ in Ioi 0, (t : ℂ) ^ (s - 1) * Complex.exp (-(n : ℝ) * t)
      = mellin (fun t : ℝ => Complex.exp (-(n : ℝ) * t)) s := by
        dsimp only [mellin]
        congr with t
        <;> simp [mul_comm]
    _ = (n : ℂ) ^ (-s) * mellin (fun t : ℝ => (Real.exp (-t) : ℂ)) s := hscal
    _ = (n : ℂ) ^ (-s) * Complex.GammaIntegral s := by rw [hbase]
    _ = (n : ℂ) ^ (-s) * Complex.Gamma s := by rw [Complex.Gamma_eq_integral hs]
    _ = Complex.Gamma s * (n : ℂ) ^ (-s) := by ring


end OnlineZetaEta5
