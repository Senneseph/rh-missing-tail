import Mathlib

open Set Real Complex Filter MeasureTheory
open scoped Topology Interval

set_option linter.unnecessarySimpa false


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


/-!
### Explicit real-Gamma bound (Phase 1, increment 2)

Supporting lemmas for `realGammaBound`:

* `expIoc1A` / `expNegHalfIoi` — the two elementary exponential
  integrals (FTC + a limit at infinity);
* `gammaTailInteq` — the one-step integration-by-parts identity on
  `[1, A]`;
* `rpowIntervalIntegral` — `∫_a^b x^q = (b^{q+1}-a^{q+1})/(q+1)`
  for `q > -1`.
-/
-- 1) ∫_{Ioc 1 A} e^{-x} = e^{-1} - e^{-A} for 1 ≤ A
theorem expIoc1A (A : ℝ) (hA : 1 ≤ A) :
    ∫ x in Ioc 1 A, Real.exp (-x) = Real.exp (-1) - Real.exp (-A) := by
  have hderiv : ∀ x ∈ uIcc 1 A, HasDerivAt (fun x : ℝ => -Real.exp (-x)) (Real.exp (-x)) x :=
    fun x _ => by
      have hf : HasDerivAt (fun y : ℝ => -y) (-1) x := by
        simpa using (hasDerivAt_id x).const_mul (-1)
      have h1 : HasDerivAt (fun x : ℝ => Real.exp (-x)) (-Real.exp (-x)) x := by
        simpa using hf.exp
      have heta : (-(fun x : ℝ => Real.exp (-x)) : ℝ → ℝ) = (fun x : ℝ => -Real.exp (-x)) := by
        funext
        simp [Pi.neg_apply]
      simpa [heta] using h1.neg
  have hint : IntervalIntegrable (fun x : ℝ => Real.exp (-x)) volume 1 A :=
    (by fun_prop : ContinuousOn (fun x : ℝ => Real.exp (-x)) (uIcc 1 A)).intervalIntegrable
  have hftc := intervalIntegral.integral_eq_sub_of_hasDerivAt
    (f := fun x : ℝ => -Real.exp (-x)) hderiv hint
  rw [← intervalIntegral.integral_of_le hA]
  simpa using hftc

-- 2) ∫_{Ioi A} e^{-x/2} = 2 e^{-A/2}
theorem expNegHalfIoi (A : ℝ) :
    ∫ x in Ioi A, Real.exp (-(1 / 2) * x) = 2 * Real.exp (-(1 / 2) * A) := by
  let g := fun x : ℝ => Real.exp (-(1 / 2) * x)
  have hInt : IntegrableOn g (Ioi A) :=
    exp_neg_integrableOn_Ioi A (by norm_num)
  have hderiv : ∀ X : ℝ, ∀ x ∈ uIcc A X,
      HasDerivAt (fun x : ℝ => -2 * Real.exp (-(1 / 2) * x)) (g x) x := by
    intro X x hx
    have hf : HasDerivAt (fun y : ℝ => ((-1) / 2) * y) ((-1) / 2) x := by
      simpa using (hasDerivAt_id x).const_mul ((-1) / 2)
    have h1 : HasDerivAt g (-(1 / 2) * g x) x := by
      have heq : (-(1 / 2) : ℝ) * x = ((-1) / 2) * x := by ring
      have hE : Real.exp (-(1 / 2) * x) = Real.exp (((-1) / 2) * x) := by rw [heq]
      convert hf.exp using 1
      <;> simpa [g, hE] using (by ring)
    have h3 := h1.const_mul (-2)
    simpa [g] using h3
  have hTend : Tendsto (fun X : ℝ => ∫ x in A..X, g x) atTop (𝓝 (∫ x in Ioi A, g x)) :=
    intervalIntegral_tendsto_integral_Ioi A hInt tendsto_id
  have hpartial : ∀ X : ℝ, ∫ x in A..X, g x = 2 * g A - 2 * g X := by
    intro X
    have hint : IntervalIntegrable g volume A X :=
      ((by fun_prop : ContinuousOn g (uIcc A X))).intervalIntegrable
    have hftc := intervalIntegral.integral_eq_sub_of_hasDerivAt
      (f := fun x : ℝ => -2 * Real.exp (-(1 / 2) * x)) (hderiv X) hint
    have hftc' : ∫ x in A..X, g x = 2 * g A - 2 * g X := by
      convert hftc using 1
      simp only [g]
      ring
    exact hftc'
  have hTend2 : Tendsto (fun X : ℝ => 2 * g A - 2 * g X) atTop (𝓝 (2 * g A)) := by
    have h0 : Tendsto (fun X : ℝ => 2 * g X) atTop (𝓝 0) := by
      have h2 : Tendsto (fun X : ℝ => X * ((-1) / 2 : ℝ)) atTop Filter.atBot :=
        Tendsto.atTop_mul_const_of_neg (r := ((-1) / 2)) (by norm_num) tendsto_id
      have h4 : Tendsto (fun X : ℝ => Real.exp (X * ((-1) / 2))) atTop (𝓝 0) := by
        convert Tendsto.comp tendsto_exp_atBot h2
        simp [Function.comp_apply]
      have h1 : Tendsto (fun X : ℝ => g X) atTop (𝓝 0) := by
        have h5 : (fun X : ℝ => Real.exp (X * ((-1) / 2))) =
            (fun X : ℝ => Real.exp (((-1) / 2) * X)) := by
          funext X
          ring
        have h6 : (fun X : ℝ => Real.exp (((-1) / 2) * X)) =
            (fun X : ℝ => g X) := by
          funext X
          simp [g]
          ring
        simpa [h5, h6] using h4
      simpa using h1.const_mul 2
    have h4 : Tendsto (fun X : ℝ => (2 * g A : ℝ) - 2 * g X) atTop (𝓝 (2 * g A - 0)) :=
      Tendsto.sub tendsto_const_nhds h0
    simpa using h4
  have hTendF : Tendsto (fun X : ℝ => ∫ x in A..X, g x) atTop (𝓝 (2 * g A)) := by
    have heq : (fun X : ℝ => ∫ x in A..X, g x) = (fun X : ℝ => 2 * g A - 2 * g X) := by
      funext X
      simpa using hpartial X
    rw [heq]
    exact hTend2
  exact tendsto_nhds_unique hTend hTendF

section
variable (p : ℝ) (A : ℝ)

-- 1) ∫_1..A e^{-t} t^p = e^{-1} - e^{-A} A^p + p ∫_1..A e^{-t} t^{p-1}
theorem gammaTailInteq (q : ℝ) (_hq : 0 < q) (A : ℝ) (hA : 1 ≤ A) :
    ∫ t in (1 : ℝ)..A, Real.exp (-t) * t ^ q =
      Real.exp (-1) - Real.exp (-A) * A ^ q +
      q * ∫ t in (1 : ℝ)..A, Real.exp (-t) * t ^ (q - 1) := by
  have hid : ContinuousOn (fun x : ℝ => x) (uIcc 1 A) := continuousOn_id
  have hpos : ∀ t ∈ uIcc 1 A, 0 < t := by
    intro t ht
    dsimp only [uIcc] at ht
    have hmin : (1 : ℝ) ⊓ A = 1 := ((left_eq_inf (a := (1 : ℝ)) (b := A)).mpr hA).symm
    rw [hmin] at ht
    linarith [ht.1]
  have hu : ∀ t ∈ uIcc 1 A, HasDerivAt (fun t => t ^ q) ((q : ℝ) * t ^ (q - 1)) t :=
    fun t ht => hasDerivAt_rpow_const (Or.inl (ne_of_gt (hpos t ht)))
  have hv : ∀ t ∈ uIcc 1 A, HasDerivAt (fun t : ℝ => Real.exp (-t)) (-Real.exp (-t)) t :=
    fun t _ => by
      have hf : HasDerivAt (fun y : ℝ => -y) (-1) t := hasDerivAt_neg' t
      simpa using hf.exp
  have hcont : ContinuousOn (fun t : ℝ => (q : ℝ) * t ^ (q - 1)) (uIcc 1 A) :=
    ContinuousOn.const_mul
      (hid.rpow_const (p := q - 1) (fun t ht => Or.inl (by
        dsimp only [uIcc] at ht
        have hmin : (1 : ℝ) ⊓ A = 1 := ((left_eq_inf (a := (1 : ℝ)) (b := A)).mpr hA).symm
        rw [hmin] at ht
        linarith [ht.1]))) q
  have huI : IntervalIntegrable (fun t => (q : ℝ) * t ^ (q - 1)) volume 1 A :=
    hcont.intervalIntegrable
  have hexpcont : ContinuousOn (fun t : ℝ => -Real.exp (-t)) (uIcc 1 A) := by fun_prop
  have hvI : IntervalIntegrable (fun t : ℝ => -Real.exp (-t)) volume 1 A :=
    hexpcont.intervalIntegrable
  have hI := intervalIntegral.integral_mul_deriv_eq_deriv_mul hu hv huI hvI
  simp_rw [mul_neg] at hI
  rw [intervalIntegral.integral_neg] at hI
  ring_nf at hI
  have hI2 : ∫ x in (1 : ℝ)..A, x ^ q * Real.exp (-x) =
      Real.exp (-1) - A ^ q * Real.exp (-A) +
        ∫ x in (1 : ℝ)..A, q * x ^ (q - 1) * Real.exp (-x) := by
    have hI3 : ∫ x in (1 : ℝ)..A, x ^ q * Real.exp (-x) =
        -(A ^ q * Real.exp (-A) - Real.exp (-1) -
        ∫ x in (1 : ℝ)..A, q * x ^ (q - 1) * Real.exp (-x)) := by
      rw [← neg_inj]
      have hJ : (-1 : ℝ) + q = q + -1 := by ring
      simpa [sub_eq_add_neg, hJ] using hI
    ring_nf at hI3
    have hJ2 : (-1 : ℝ) + q = q + -1 := by ring
    simpa [sub_eq_add_neg, hJ2, add_comm, add_assoc, add_left_comm] using hI3
  simpa [mul_comm, mul_assoc, mul_left_comm] using hI2

-- 2) ∫_a..b x^q = (b^{q+1} - a^{q+1})/(q+1) for q > -1, 0 < a ≤ b
theorem rpowIntervalIntegral (q : ℝ) (hq : -1 < q) (a b : ℝ) (ha : 0 < a) (hab : a ≤ b) :
    ∫ x in a..b, x ^ q = (b ^ (q + 1) - a ^ (q + 1)) / (q + 1) := by
  have hq1 : 0 < q + 1 := by linarith
  have hF : ∀ x ∈ uIcc a b, HasDerivAt (fun x : ℝ => x ^ (q + 1) / (q + 1)) (x ^ q) x := by
    intro x hx
    have hx0 : 0 < x := by
      dsimp only [uIcc] at hx
      have hmin : a ⊓ b = a := ((left_eq_inf (a := a) (b := b)).mpr hab).symm
      rw [hmin] at hx
      linarith [hx.1]
    have hd : HasDerivAt (fun x : ℝ => x ^ (q + 1)) ((q + 1) * x ^ q) x := by
      convert hasDerivAt_rpow_const (x := x) (p := q + 1) (Or.inl (ne_of_gt hx0))
      ring
    have hd2 : HasDerivAt (fun x : ℝ => x ^ (q + 1) / (q + 1)) ((q + 1) * x ^ q / (q + 1)) x :=
      hd.div_const (q + 1)
    convert hd2
    field_simp [Ne.symm (ne_of_gt hq1)]
  have hFcont : IntervalIntegrable (fun x : ℝ => x ^ q) volume a b := by
    have hcont : ContinuousOn (fun x : ℝ => x ^ q) (uIcc a b) :=
      continuousOn_id.rpow_const (p := q) (fun x hx => Or.inl (by
        intro h
        dsimp only [uIcc, id] at hx h
        have hmin : a ⊓ b = a := ((left_eq_inf (a := a) (b := b)).mpr hab).symm
        rw [hmin] at hx
        linarith [hx.1, h]))
    exact hcont.intervalIntegrable
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hF hFcont]
  ring

/-- Explicit real-Gamma upper bound on `[1, ∞)` above the tail cutoff
    `A ≥ 2(p-1)` (and `A ≥ 1`):

    Γ p ≤ 1 + e^{-1} A^{p-1} + 2 (2(p-1))^{p-1} e^{-(p-1)} e^{-A/2}

    Route: `Γ p = ∫₀^∞ e^{-x} x^{p-1} dx` is split into `[0,1]`
    (bounded by 1), `[1,A]` (integration by parts, then monotonicity of
    `e^{-x}` and the rpow interval integral), and `[A,∞)`
    (`tPowExpTailBound` + the explicit `e^{-x/2}` tail integral).

    NO RH CLAIM: a pure estimate for the real Gamma function. -/
theorem realGammaBound (hp : 1 ≤ p) (hA1 : 1 ≤ A) (hA2 : 2 * (p - 1) ≤ A) :
    Real.Gamma p ≤ 1 + Real.exp (-1) * A ^ (p - 1) +
    2 * (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * A) := by
  let f := fun x : ℝ => Real.exp (-x) * x ^ (p - 1)
  have hp1 : 0 < p := by linarith
  have hpm1 : 0 ≤ p - 1 := by linarith
  -- continuity of f on Ici 0
  have hcontpow1 : ContinuousOn (fun x : ℝ => x ^ (p - 1)) (Ici 0) :=
    continuousOn_id.rpow_const (p := p - 1) (fun x _ => Or.inr hpm1)
  have hcontexp : ContinuousOn (fun x : ℝ => Real.exp (-x)) (Ici 0) := by fun_prop
  have hcontf : ContinuousOn f (Ici 0) := hcontexp.mul hcontpow1
  -- integrability
  have hInt1 : IntegrableOn f (Ioi 1) volume := by
    have hbigO : f =O[atTop] (fun x : ℝ => Real.exp (-(1 / 2) * x)) := by
      -- eventual bound only: for x ≥ 2(p-1), f x = e^{-x}x^{p-1} ≥ 0 and
      -- tPowExpTailBound gives f x ≤ (2(p-1))^{p-1} e^{-(p-1)} e^{-x/2}
      let Cbig := (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1))
      refine Asymptotics.IsBigO.of_bound Cbig ?_
      filter_upwards [Filter.eventually_ge_atTop (2 * (p - 1))] with x hx
      have hpt0 : x ^ (p - 1) * Real.exp (-x) ≤
          (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * x) :=
        tPowExpTailBound (p - 1) x hpm1 hx
      have hC : Real.exp (-(1 / 2) * x) = Real.exp (-(x * 2⁻¹)) := by
        congr
        ring
      have hpt : x ^ (p - 1) * Real.exp (-x) ≤ Cbig * Real.exp (-(x * 2⁻¹)) := by
        calc
          x ^ (p - 1) * Real.exp (-x) ≤
              (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * x) := hpt0
          _ = (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(x * 2⁻¹)) := by rw [hC]
          _ = Cbig * Real.exp (-(x * 2⁻¹)) := by simp [Cbig]
      have hxpow : |x ^ (p - 1)| = x ^ (p - 1) :=
        abs_of_nonneg (Real.rpow_nonneg (by linarith [hpm1, hx]) (p - 1))
      simpa [f, hxpow, mul_comm] using hpt
    have hcontIci1 : ContinuousOn f (Ici 1) :=
      hcontf.mono (Ici_subset_Ici.2 (by norm_num : (0 : ℝ) ≤ 1))
    exact integrable_of_isBigO_exp_neg (b := (1 / 2)) (by norm_num) hcontIci1 hbigO
  have hIntA : IntegrableOn f (Ioi A) volume :=
    hInt1.mono_set (Ioi_subset_Ioi (le_trans (by norm_num) hA1))
  have hInt01 : IntervalIntegrable f volume 0 1 := by
    have hcontu : ContinuousOn f (uIcc 0 1) :=
      hcontf.mono (fun x hx => by
        dsimp only [uIcc] at hx
        have hmin : (0 : ℝ) ⊓ 1 = 0 :=
          ((left_eq_inf (a := (0 : ℝ)) (b := 1)).mpr (by norm_num)).symm
        rw [hmin] at hx
        exact Set.mem_Ici.mpr hx.1)
    exact hcontu.intervalIntegrable
  -- split
  have hsplit : Real.Gamma p =
      (∫ x in (0 : ℝ)..1, f x) + (∫ x in (1 : ℝ)..A, f x) + ∫ x in Ioi A, f x := by
    calc
      Real.Gamma p = ∫ x in Ioi 0, f x := by
        simpa using Real.Gamma_eq_integral hp1
      _ = (∫ x in 0..1, f x) + ∫ x in Ioi 1, f x := by
        rw [← intervalIntegral.integral_interval_add_Ioi' hInt01 hInt1]
      _ = (∫ x in 0..1, f x) + ((∫ x in 1..A, f x) + ∫ x in Ioi A, f x) := by
        have hdiff : ∫ x in Ioi 1, f x = (∫ x in 1..A, f x) + ∫ x in Ioi A, f x := by
          rw [← intervalIntegral.integral_Ioi_sub_Ioi' hInt1 hIntA]
          ring
        rw [hdiff]
      _ = (∫ x in 0..1, f x) + (∫ x in 1..A, f x) + ∫ x in Ioi A, f x := by ring
  -- piece 1
  have hpiece1 : ∫ x in (0 : ℝ)..1, f x ≤ 1 := by
    have hg : IntervalIntegrable (fun (y : ℝ) => y ^ (p - 1)) volume 0 1 := by
      have hcontu : ContinuousOn (fun (y : ℝ) => y ^ (p - 1)) (uIcc 0 1) :=
        hcontpow1.mono (fun x hx => by
          dsimp only [uIcc] at hx
          have hmin : (0 : ℝ) ⊓ 1 = 0 :=
            ((left_eq_inf (a := (0 : ℝ)) (b := 1)).mpr (by norm_num)).symm
          rw [hmin] at hx
          exact Set.mem_Ici.mpr hx.1)
      exact hcontu.intervalIntegrable
    have hmono : ∫ x in 0..1, f x ≤ ∫ x in 0..1, (fun (y : ℝ) => y ^ (p - 1)) x := by
      have := intervalIntegral.integral_mono_on (hab := by norm_num)
        (hf := hInt01) (hg := hg) (fun (x : ℝ) (hx : x ∈ Icc (0 : ℝ) 1) => by
          have hexp : Real.exp (-x) ≤ 1 := by
            calc
              Real.exp (-x) ≤ Real.exp 0 := Real.exp_le_exp.mpr (by linarith [hx.1])
              _ = 1 := Real.exp_zero
          have hpow : 0 ≤ x ^ (p - 1) := Real.rpow_nonneg hx.1 (p - 1)
          simpa [f] using (by nlinarith [hexp, hpow]))
      exact this
    have hantideriv : ∀ x ∈ uIcc 0 1, HasDerivAt (fun x : ℝ => x ^ p / p) (x ^ (p - 1)) x := by
      intro x hx
      have hd : HasDerivAt (fun x : ℝ => x ^ p) (p * x ^ (p - 1)) x := by
        by_cases hx0 : x = 0
        · exact hasDerivAt_rpow_const (Or.inr hp)
        · exact hasDerivAt_rpow_const (Or.inl hx0)
      have hd2 : HasDerivAt (fun x : ℝ => x ^ p / p) (p * x ^ (p - 1) / p) x :=
        hd.div_const p
      convert hd2
      field_simp [ne_of_gt hp1]
    have hFTC : ∫ x in 0..1, (fun x : ℝ => x ^ (p - 1)) x = (1 : ℝ) ^ p / p - (0 : ℝ) ^ p / p := by
      rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hantideriv hg]
    calc
      ∫ x in 0..1, f x ≤ ∫ x in 0..1, (fun (y : ℝ) => y ^ (p - 1)) x := hmono
      _ = (1 : ℝ) ^ p / p - (0 : ℝ) ^ p / p := hFTC
      _ = 1 / p := by
        have h1 : (1 : ℝ) ^ p = 1 := one_rpow p
        have h0 : (0 : ℝ) ^ p = 0 := zero_rpow (ne_of_gt hp1)
        rw [h1, h0, one_div, zero_div]
        ring
      _ ≤ 1 := by
        rw [div_le_one (by linarith : 0 < p)]
        linarith
  -- piece 2
  have hpiece2 : ∫ x in (1 : ℝ)..A, f x ≤ Real.exp (-1) * A ^ (p - 1) := by
    by_cases hpe : 1 < p
    · have hIBP := gammaTailInteq (p - 1) (by linarith) A hA1
      have hexpmono : ∫ x in (1 : ℝ)..A, Real.exp (-x) * x ^ (p - 2) ≤
          Real.exp (-1) * ∫ x in (1 : ℝ)..A, x ^ (p - 2) := by
        have hf : IntervalIntegrable (fun x : ℝ => Real.exp (-x) * x ^ (p - 2)) volume 1 A := by
          have hcontu : ContinuousOn (fun x : ℝ => Real.exp (-x) * x ^ (p - 2)) (uIcc 1 A) := by
            have h1 : ContinuousOn (fun x : ℝ => Real.exp (-x)) (uIcc 1 A) := by fun_prop
            have h2 : ContinuousOn (fun x : ℝ => x ^ (p - 2)) (uIcc 1 A) :=
              continuousOn_id.rpow_const (p := p - 2) (fun x hx => Or.inl (by
                intro h
                dsimp only [uIcc, id] at hx h
                have hmin : (1 : ℝ) ⊓ A = 1 := ((left_eq_inf (a := (1 : ℝ)) (b := A)).mpr hA1).symm
                rw [hmin] at hx
                linarith [hx.1, h]))
            exact h1.mul h2
          exact hcontu.intervalIntegrable
        have hg : IntervalIntegrable (fun x : ℝ => Real.exp (-1) * x ^ (p - 2)) volume 1 A := by
          have h2 : ContinuousOn (fun x : ℝ => x ^ (p - 2)) (uIcc 1 A) :=
            continuousOn_id.rpow_const (p := p - 2) (fun x hx => Or.inl (by
              intro h
              dsimp only [uIcc] at hx
              have hmin : (1 : ℝ) ⊓ A = 1 := ((left_eq_inf (a := (1 : ℝ)) (b := A)).mpr hA1).symm
              rw [hmin] at hx
              dsimp only [id] at h
              linarith [hx.1, h]))
          have hcontu : ContinuousOn (fun x : ℝ => Real.exp (-1) * x ^ (p - 2)) (uIcc 1 A) :=
            ContinuousOn.const_mul h2 (Real.exp (-1))
          exact hcontu.intervalIntegrable
        have := intervalIntegral.integral_mono_on (hab := hA1)
          (hf := hf) (hg := hg) (fun (x : ℝ) (hx : x ∈ Icc (1 : ℝ) A) => by
            have hexp : Real.exp (-x) ≤ Real.exp (-1) :=
              Real.exp_le_exp.mpr (by linarith [hx.1])
            have hpow : 0 ≤ x ^ (p - 2) := Real.rpow_nonneg (by linarith [hx.1]) (p - 2)
            simpa using (by nlinarith [hexp, hpow]))
        have hconst : ∫ x in (1 : ℝ)..A, Real.exp (-1) * x ^ (p - 2) =
            Real.exp (-1) * ∫ x in (1 : ℝ)..A, x ^ (p - 2) := by
          rw [intervalIntegral.integral_const_mul
            (r := Real.exp (-1)) (f := fun x : ℝ => x ^ (p - 2))]
        calc
          ∫ x in (1 : ℝ)..A, Real.exp (-x) * x ^ (p - 2) ≤
              ∫ x in (1 : ℝ)..A, Real.exp (-1) * x ^ (p - 2) := this
          _ = Real.exp (-1) * ∫ x in (1 : ℝ)..A, x ^ (p - 2) := hconst
      have hR0 := rpowIntervalIntegral (p - 2) (by linarith) 1 A (by norm_num) hA1
      have hR : ∫ x in (1 : ℝ)..A, x ^ (p - 2) = (A ^ (p - 1) - 1) / (p - 1) := by
        have hq : p - 2 + 1 = p - 1 := by ring
        convert hR0 using 1
        rw [hq, one_rpow (p - 1)]
      calc
        ∫ x in 1..A, f x = Real.exp (-1) - Real.exp (-A) * A ^ (p - 1) +
            (p - 1) * ∫ x in 1..A, Real.exp (-x) * x ^ (p - 2) := by
          have hIBPeq : ∫ x in 1..A, Real.exp (-x) * x ^ (p - 1) =
              Real.exp (-1) - Real.exp (-A) * A ^ (p - 1) +
              (p - 1) * ∫ x in 1..A, Real.exp (-x) * x ^ (p - 2) := by
            simpa [show p - 2 = p - 1 - 1 from by ring] using hIBP
          simpa [f] using hIBPeq
        _ ≤ Real.exp (-1) - Real.exp (-A) * A ^ (p - 1) +
            (p - 1) * (Real.exp (-1) * ∫ x in 1..A, x ^ (p - 2)) := by gcongr
        _ = Real.exp (-1) - Real.exp (-A) * A ^ (p - 1) +
            (p - 1) * Real.exp (-1) * ∫ x in 1..A, x ^ (p - 2) := by ring
        _ = Real.exp (-1) - Real.exp (-A) * A ^ (p - 1) + Real.exp (-1) * (A ^ (p - 1) - 1) := by
          rw [hR]
          field_simp [ne_of_gt (sub_pos.mpr hpe)]
        _ = A ^ (p - 1) * (Real.exp (-1) - Real.exp (-A)) := by ring
        _ ≤ A ^ (p - 1) * Real.exp (-1) := by
          gcongr
          linarith [Real.exp_pos (-A)]
        _ = Real.exp (-1) * A ^ (p - 1) := by ring
    · have hpeq : p = 1 := le_antisymm (by linarith) hp
      have hf1 : f = (fun x : ℝ => Real.exp (-x)) := by
        funext x
        dsimp only [f]
        rw [hpeq, show (1 : ℝ) - 1 = 0 by norm_num, Real.rpow_zero, mul_one]
      have h1 : ∫ x in 1..A, f x = Real.exp (-1) - Real.exp (-A) := by
        rw [hf1]
        rw [intervalIntegral.intervalIntegral_eq_integral_uIoc
          (fun x : ℝ => Real.exp (-x)) 1 A volume]
        simp only [uIoc_of_le hA1, if_pos hA1, one_smul]
        exact expIoc1A A hA1
      calc
        ∫ x in 1..A, f x = Real.exp (-1) - Real.exp (-A) := h1
        _ ≤ Real.exp (-1) := by linarith [Real.exp_pos (-A)]
        _ = Real.exp (-1) * A ^ (p - 1) := by
          rw [show p - 1 = 0 from by linarith, Real.rpow_zero, mul_one]
  -- piece 3
  have hpiece3 : ∫ x in Ioi A, f x ≤
      2 * (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * A) := by
    let C := (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1))
    let h := fun x : ℝ => C * Real.exp (-(1 / 2) * x)
    have hIntC : IntegrableOn h (Ioi A) volume := by
      have hexp : IntegrableOn (fun x : ℝ => Real.exp (-(1 / 2) * x)) (Ioi A) volume :=
        exp_neg_integrableOn_Ioi A (by norm_num)
      have hexpI : Integrable (fun x : ℝ => Real.exp (-(1 / 2) * x)) (volume.restrict (Ioi A)) :=
        hexp.integrable
      have hc : Integrable (fun x : ℝ => C * Real.exp (-(1 / 2) * x)) (volume.restrict (Ioi A)) :=
        hexpI.const_mul C
      dsimp only [IntegrableOn]
      simpa [h] using hc
    have hmono : ∫ x in Ioi A, f x ≤ ∫ x in Ioi A, h x := by
      apply MeasureTheory.setIntegral_mono_on hIntA hIntC measurableSet_Ioi
      intro x hx
      dsimp only [f, h]
      have hxA : A < x := by simpa using hx
      have hpt : x ^ (p - 1) * Real.exp (-x) ≤
          (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * x) :=
        tPowExpTailBound (p - 1) x hpm1 (by linarith)
      have heq : Real.exp (-x) * x ^ (p - 1) = x ^ (p - 1) * Real.exp (-x) := by ring
      rw [heq]
      have hgoal : x ^ (p - 1) * Real.exp (-x) ≤ C * Real.exp (-(1 / 2) * x) := by
        dsimp [C]
        exact hpt
      exact hgoal
    calc
      ∫ x in Ioi A, f x ≤ ∫ x in Ioi A, h x := hmono
      _ = C * ∫ x in Ioi A, Real.exp (-(1 / 2) * x) := by
        simp [h]
        simpa using (MeasureTheory.integral_const_mul (r := C)
          (f := fun x : ℝ => Real.exp (-(1 / 2) * x)))
      _ = C * (2 * Real.exp (-(1 / 2) * A)) := by
        rw [expNegHalfIoi A]
      _ = 2 * (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * A) := by
        simp [C]
        ring
  -- assembly
  calc
    Real.Gamma p = (∫ x in 0..1, f x) + (∫ x in 1..A, f x) + ∫ x in Ioi A, f x := hsplit
    _ ≤ 1 + Real.exp (-1) * A ^ (p - 1) +
        2 * (2 * (p - 1)) ^ (p - 1) * Real.exp (-(p - 1)) * Real.exp (-(1 / 2) * A) := by
      gcongr

end

/-- Region corollary for the disk-count program: for `z.re ≥ 1`,
    `‖Γ z‖` is bounded by a closed form depending only on `z.re`
    (tail cutoff `A := max 1 (2(z.re-1))`).

    Combines `cGammaLeRealGammaRe` (complex → real) with
    `realGammaBound` (explicit real bound).

    NO RH CLAIM: a pure estimate for `‖Γ z‖` on `re ≥ 1`. -/
theorem cGammaBoundRe {z : ℂ} (hz : 1 ≤ z.re) :
    ‖Complex.Gamma z‖ ≤
      1 + Real.exp (-1) * (max 1 (2 * (z.re - 1))) ^ (z.re - 1) +
      2 * (2 * (z.re - 1)) ^ (z.re - 1) * Real.exp (-(z.re - 1)) *
      Real.exp (-(1 / 2) * max 1 (2 * (z.re - 1))) := by
  have hA1 : 1 ≤ max 1 (2 * (z.re - 1)) := le_max_left _ _
  have hA2 : 2 * (z.re - 1) ≤ max 1 (2 * (z.re - 1)) := le_max_right _ _
  calc
    ‖Complex.Gamma z‖ ≤ Real.Gamma z.re := cGammaLeRealGammaRe (by linarith)
    _ ≤ 1 + Real.exp (-1) * (max 1 (2 * (z.re - 1))) ^ (z.re - 1) +
        2 * (2 * (z.re - 1)) ^ (z.re - 1) * Real.exp (-(z.re - 1)) *
        Real.exp (-(1 / 2) * max 1 (2 * (z.re - 1))) :=
      realGammaBound z.re (max 1 (2 * (z.re - 1))) hz hA1 hA2

end OnlineZetaGammaBound
