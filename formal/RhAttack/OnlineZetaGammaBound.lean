import Mathlib

open Set Real Complex Filter MeasureTheory

-- the Euler-integral norm reduction involves a few heavy measure-theory
-- elaborations (a.e. congruence over the restricted volume)
set_option maxHeartbeats 40000

namespace OnlineZetaGammaBound

/-
honline Phase 1: explicit Gamma bounds on the left-side region.

The functional-equation transport in `OnlineZetaFE`
(`zetaFEtransport` / `zetaTailTransportLeft`) expresses `ζ s` for
`s.re < 0` in terms of `‖Γ(1 - s)‖` with `1 - s` in the half-plane
`re > 0`. The disk-count program (N1/N2) needs an EXPLICIT, computable
upper bound for `‖Complex.Gamma z‖` when `z.re` lies in a fixed
interval `[1, P]`. The pinned Mathlib build has no Stirling
asymptotics for `Complex.Gamma`, so we derive the bound locally:

  1. Pointwise tail control (real calculus, no measure theory):
     for `2a ≤ t`, `a ≥ 0`,
       t^a e^{-t} ≤ (2a)^a e^{-a} e^{-t/2},
     from `log u ≤ u - 1` at `u = t/(2a) ≥ 1`.

  2. Complex-to-real reduction: for `0 < z.re`,
       ‖Γ z‖ ≤ Γ(z.re)   (real Gamma),
     by the Euler integral `Γ z = ∫₀^∞ e^{-x} x^{z-1} dx`,
     `‖·‖ ≤ ∫‖·‖`, and `‖(x : ℂ)^{z-1}‖ = x^{z.re-1}` for `x > 0`
     (via `cpow_def_of_ne_zero` + `log (x : ℂ) = (log x : ℂ)` +
     `‖exp w‖ = e^{w.re}`).

Together these give `‖Γ z‖ ≤ Γ(z.re)` with `z.re ∈ [1, P]`, reducing
the complex problem to an explicit bound for the REAL Gamma on a
compact interval — the next increment.

NO RH CLAIM: pure estimates for the (complex and real) Gamma function.
-/

/-- Pointwise exponential-tail bound: for `2a ≤ t` and `a ≥ 0`,
    `t^a · e^{-t} ≤ (2a)^a · e^{-a} · e^{-t/2}`.

This is the elementary engine behind the explicit real-Gamma upper
bound on `[1, ∞)`: it controls the tail `∫_A^∞ t^a e^{-t}` by
`(2a)^a e^{-a} · 2 e^{-A/2}`. -/
theorem tPowExpTailBound (a t : ℝ) (ha : 0 ≤ a) (ht : 2 * a ≤ t) :
    t ^ a * Real.exp (-t) ≤ (2 * a) ^ a * Real.exp (-a) * Real.exp (-(1 / 2) * t) := by
  by_cases hz : a = 0
  · have ht0 : 0 ≤ t := by simpa [hz] using ht
    have h1 : t ^ (0 : ℝ) = 1 := Real.rpow_zero t
    have h2 : (2 * (0 : ℝ)) ^ (0 : ℝ) = 1 := Real.rpow_zero (2 * (0 : ℝ))
    have h3 : Real.exp (-(0 : ℝ)) = 1 := by norm_num
    have h5 : -t ≤ -(1 / 2) * t := by
      have ht2 : 0 ≤ t / 2 := by linarith
      nlinarith
    rw [hz, h1, h2, h3, mul_one, one_mul]
    simpa using Real.exp_le_exp.mpr h5
  · have hpos : 0 < a := by
      by_contra h
      push Not at h
      have heq : a = 0 := le_antisymm h ha
      contradiction
    have htwo : 0 < 2 * a := by linarith
    have hhp : 0 < t := by linarith
    -- log u ≤ u - 1 at u = t/(2a) ≥ 1
    have hln : Real.log (t / (2 * a)) ≤ t / (2 * a) - 1 := by
      have hposu : 0 < t / (2 * a) := div_pos (by linarith) htwo
      exact Real.log_le_sub_one_of_pos hposu
    -- multiply by a > 0: a·log(t/(2a)) ≤ a·(t/(2a) - 1) = t/2 - a
    have hA : a * (Real.log t - Real.log (2 * a)) ≤ t / 2 - a := by
      have hA1 : a * Real.log (t / (2 * a)) ≤ t / 2 - a := by
        calc
          a * Real.log (t / (2 * a)) ≤ a * (t / (2 * a) - 1) := by gcongr
          _ = t / 2 - a := by field_simp [hpos.ne']
      have hlog : Real.log (t / (2 * a)) = Real.log t - Real.log (2 * a) := by
        rw [Real.log_div (by linarith) (by linarith)]
      simpa [hlog] using hA1
    -- exponentiate both sides of the log-form inequality
    have hL : t ^ a * Real.exp (-t) = Real.exp (a * Real.log t - t) := by
      rw [Real.rpow_def_of_pos hhp]
      rw [← Real.exp_add]
      ring_nf
    have hR : (2 * a) ^ a * Real.exp (-a) * Real.exp (-(1 / 2) * t) =
        Real.exp (a * Real.log (2 * a) - a - (1 / 2) * t) := by
      rw [Real.rpow_def_of_pos htwo]
      rw [← Real.exp_add, ← Real.exp_add]
      ring_nf
    rw [hL, hR]
    have hdiff : a * Real.log t - t ≤ a * Real.log (2 * a) - a - (1 / 2) * t := by
      calc
        a * Real.log t - t
          = a * (Real.log t - Real.log (2 * a)) + (a * Real.log (2 * a) - t) := by ring
        _ ≤ (t / 2 - a) + (a * Real.log (2 * a) - t) := by linarith [hA]
        _ = a * Real.log (2 * a) - a - (1 / 2) * t := by ring
    exact Real.exp_le_exp.mpr hdiff

/-- Norm reduction for the Euler integral: for `0 < z.re`,
    `‖Γ z‖ ≤ Γ(z.re)` (the real Gamma at the real part).

Route: `Γ z = ∫₀^∞ e^{-x} x^{z-1} dx` (Mathlib `Gamma_eq_integral`),
`‖∫ f‖ ≤ ∫ ‖f‖`, and the pointwise identity
`‖e^{-x} · (x : ℂ)^{z-1}‖ = e^{-x} · x^{z.re-1}` for `x > 0`, which
follows from `cpow_def_of_ne_zero`, `log (x : ℂ) = (log x : ℂ)`,
`‖exp w‖ = e^{w.re}`, and `‖exp(I·u)‖ = 1`. -/
theorem cGammaLeRealGammaRe {z : ℂ} (hz : 0 < z.re) :
    ‖Complex.Gamma z‖ ≤ Real.Gamma z.re := by
  have hzr : 0 < (z.re : ℝ) := hz
  have hnorm : ∀ x ∈ Ioi 0,
      ‖Real.exp (-x) * (x : ℂ) ^ (z - 1)‖ = Real.exp (-x) * x ^ (z.re - 1) := by
    intro x hx
    have hx0 : 0 < x := by simpa using hx
    have h3 : (x : ℂ) ≠ 0 := by
      intro he
      have hreal : (x : ℝ) = 0 := Complex.ofReal_eq_zero.mp he
      linarith [hx0]
    have h1 : ‖Real.exp (-x) * (x : ℂ) ^ (z - 1)‖ = Real.exp (-x) * ‖(x : ℂ) ^ (z - 1)‖ := by
      have h2 : ‖(Real.exp (-x) : ℂ)‖ = Real.exp (-x) := by
        have h2' : ‖(Real.exp (-x) : ℂ)‖ = |Real.exp (-x)| :=
          RCLike.norm_ofReal (Real.exp (-x))
        rw [h2']
        exact abs_of_pos (Real.exp_pos (-x))
      rw [norm_mul, h2]
    have h2 : ‖(x : ℂ) ^ (z - 1)‖ = x ^ (z.re - 1) := by
      rw [Complex.cpow_def_of_ne_zero h3]
      have hlog : Complex.log (x : ℂ) = (Real.log x : ℂ) :=
        (Complex.ofReal_log (le_of_lt hx0)).symm
      rw [hlog]
      have hnormexp : ‖Complex.exp ((Real.log x : ℂ) * (z - 1))‖ =
          Real.exp ((Real.log x : ℂ) * (z - 1)).re := by
        rw [Complex.norm_exp]
      rw [hnormexp]
      have hre : ((Real.log x : ℂ) * (z - 1)).re = Real.log x * (z.re - 1) := by
        have h1' : ((Real.log x : ℂ) * (z - 1)).re =
            (Real.log x : ℝ) * (z - 1).re := by
          simp [Complex.ofReal_re, Complex.ofReal_im, Complex.mul_re]
        have h2' : (z - 1 : ℂ).re = z.re - 1 := by simp
        rwa [h2'] at h1'
      rw [hre]
      have h3' : Real.exp (Real.log x * (z.re - 1)) = x ^ (z.re - 1) := by
        rw [Real.rpow_def_of_pos hx0]
      simpa using h3'
    simpa [h2] using h1
  calc
    ‖Complex.Gamma z‖ = ‖∫ x in Ioi 0, Real.exp (-x) * (x : ℂ) ^ (z - 1)‖ := by
      rw [Complex.Gamma_eq_integral hzr, Complex.GammaIntegral]
    _ ≤ ∫ x in Ioi 0, ‖Real.exp (-x) * (x : ℂ) ^ (z - 1)‖ :=
      MeasureTheory.norm_integral_le_integral_norm
        (f := fun x : ℝ => Real.exp (-x) * (x : ℂ) ^ (z - 1))
        (μ := volume.restrict (Ioi 0))
    _ = ∫ x in Ioi 0, Real.exp (-x) * x ^ (z.re - 1) :=
      MeasureTheory.integral_congr_ae
        (f := fun x : ℝ => ‖Real.exp (-x) * (x : ℂ) ^ (z - 1)‖)
        (g := fun x : ℝ => Real.exp (-x) * (x : ℝ) ^ (z.re - 1))
        (μ := volume.restrict (Ioi 0))
        ((ae_restrict_iff' measurableSet_Ioi).mpr
          (Filter.Eventually.of_forall (fun x hx => hnorm x hx)))
    _ = Real.Gamma z.re := by
      rw [Real.Gamma_eq_integral (by positivity)]

end OnlineZetaGammaBound
