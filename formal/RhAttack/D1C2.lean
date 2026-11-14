import RhAttack.D1C
import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

/-!
**D1C-2 — differentiating the Laplace transform under the integral
(formal unit 2)** (0392, option B, lane D — the Danesh pole-obstruction
criterion, arXiv 2611.10726, continued).

Unit D1C (the engine) established that under the exponential bound
`‖F t‖ ≤ C·e^{α t}` for t > 0, the zero-extended Laplace integrand
`t ↦ Fext F t · e^{-s t}` is Bochner-integrable for Re s > α
(`D1C.laplaceAbsIntegrable`), so its integral

    Φ(s) = ∫ t : ℝ, Fext F t · e^{-s t}

is well-defined on the half-plane `hp α` (`D1C.hp`). This unit proves
the missing analytic link: for every `s₀` with `Re s₀ > α`, the
parameter map `Φ` is **complex differentiable** at `s₀`, with derivative
the integral of the pointwise parameter derivative,

    Φ'(s₀) = ∫ t : ℝ, Fext F t · (−t) · e^{−s₀ t},

and the derivative integrand is itself Bochner-integrable.

ROUTE. Mathlib's `hasDerivAt_integral_of_dominated_loc_of_deriv_le`
(parametric integral, RCLike parameter field — instantiated here at
`𝕜 := ℂ`), with the uniform ball `B(s₀, (Re s₀ − α)/2)` (on which
`Re z ≥ α + (Re s₀ − α)/2 > α`) and the integrable derivative majorant

    t ↦ (2C/(r·e)) · e^{−(r/2)·t}  (t > 0),   0  (t ≤ 0),    r := (Re s₀ − α)/2 > 0,

proved pointwise in the proof of `hasDerivAt_laplaceTransform`: the
raw derivative estimate `‖F' z t‖ ≤ C·t·e^{(α − Re z)·t}`
(`derivPtBoundRaw`) plus `Re z ≥ Re s₀ − r` and the standard
polynomial absorption `t ≤ (2/(r·e))·e^{(r/2)·t}`
(`tAbsorbedByExp`, from `ln x ≤ x − 1` at `x = (r/2)·t`). The pointwise
complex differentiability of `z ↦ e^{−z t}` at each ball point is the
chain `hasDerivAt_mul_const` + (commutativity bridge) + `cexp` +
`mul_const` (`integrandHasDerivAt`, valid for every `t`: for t ≤ 0 the
zero-extension makes the integrand constant, `hasDerivAt_zero`).

CONCLUSION. `differentiableOn_laplaceTransform`:

    DifferentiableOn ℂ (laplaceTransform F) (hp α),

and the composed Danesh corollary `daneshPoleContradiction` follows
immediately from `D1C.poleObstruction`: under the O(e^{α t}) bound,
`Φ` is differentiable on `hp α`, hence locally bounded at every point
of `hp α` — it has NO pole there. So any zero-sum representation of
`Φ` that forces a GENUINE POLE (unbounded with non-zero residue) at an
off-critical zero `z₀` with `Re z₀ > α` is a contradiction.

SCOPE / NO RH CLAIM: this unit delivers link (a) of D1C's header
(differentiability of the Laplace transform on `hp α`). It is an
ENGINE piece, formalized and proven; it is not a proof of RH. The
remaining link is (b): the in-tree pointwise equality of the Laplace
integral `Φ(s)` with the zero-sum meromorphic object on the relevant
domain (Danesh Theorem 4.1's half-plane Re s > 1/2, together with the
convergence input from in-tree zero counting). The terminal face
is NOT reduced by this unit; consuming the Danesh criterion against
the face is a separate explicit unit, and none has been executed.
-/

namespace D1C2

open D1C
open MeasureTheory
open Set

open scoped Topology

/-- The (zero-extended) Laplace transform of a measurable oscillation F:
    `Φ(s) = ∫ t : ℝ, Fext F t · e^{-s t}`. Under the `O(e^{α t})` bound it is
    well-defined for `Re s > α` via `D1C.laplaceAbsIntegrable`. -/
noncomputable def laplaceTransform (F : ℝ → ℂ) (s : ℂ) : ℂ :=
    ∫ (t : ℝ), laplaceIntegrand F s t

/-- The pointwise parameter derivative of the integrand at parameter
    `s₀`: `t ↦ Fext F t · (−t) · e^{−s₀·t}`. -/
noncomputable def laplaceDerivIntegrand (F : ℝ → ℂ) (s₀ : ℂ) (t : ℝ) : ℂ :=
    Fext F t * (-(t : ℂ)) * Complex.exp (-(s₀ * t))

/-- The parameter-derivative integrand is measurable. -/
theorem measurable_laplaceDerivIntegrand (F : ℝ → ℂ) (hF : Measurable F) (s₀ : ℂ) :
    Measurable (laplaceDerivIntegrand F s₀) := by
  have hexp : Measurable (fun t : ℝ => Complex.exp (-(s₀ * (t : ℂ)))) := by
    have hcont : Continuous (fun t : ℝ => Complex.exp (-(s₀ * (t : ℂ)))) := by continuity
    exact hcont.measurable
  have hlin : Measurable (fun t : ℝ => (-(t : ℂ))) := by
    have hcont : Continuous (fun t : ℝ => (-(t : ℂ))) := by continuity
    exact hcont.measurable
  have heq : laplaceDerivIntegrand F s₀ =
      (fun t : ℝ => Fext F t * (-(t : ℂ)) * Complex.exp (-(s₀ * t))) := by
    ext t
    simp [laplaceDerivIntegrand]
  rw [heq]
  exact ((measurable_Fext F hF).mul hlin).mul hexp

section

variable {α : ℝ} (C : ℝ) (hC : 0 ≤ C) (F : ℝ → ℂ) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t))

/-- The standard polynomial absorption: for `r > 0` and `t > 0`,
    `t ≤ (2/(r·e))·e^{(r/2)·t}` (from `ln x ≤ x − 1` at `x = (r/2)·t`). -/
theorem tAbsorbedByExp (r : ℝ) (hr : 0 < r) (t : ℝ) (ht : 0 < t) :
    t ≤ 2 / (r * Real.exp 1) * Real.exp ((r / 2) * t) := by
  have hlr : 0 < r / 2 := by positivity
  have hx : 0 < (r / 2) * t := by positivity
  have hlog : Real.log t ≤ (r / 2) * t - 1 - Real.log (r / 2) := by
    have hlt : Real.log t = Real.log ((r / 2) * t) - Real.log (r / 2) := by
      rw [Real.log_mul (ne_of_gt hlr) (ne_of_gt ht)]
      ring
    rw [hlt]
    exact sub_le_sub_right (Real.log_le_sub_one_of_pos hx) (Real.log (r / 2))
  have h1 : t ≤ Real.exp ((r / 2) * t - 1 - Real.log (r / 2)) := by
    calc
      t = Real.exp (Real.log t) := (Real.exp_log ht).symm
      _ ≤ Real.exp ((r / 2) * t - 1 - Real.log (r / 2)) :=
        (Real.exp_le_exp (x := Real.log t)).mpr hlog
  have h2 : Real.exp ((r / 2) * t - 1 - Real.log (r / 2)) =
      Real.exp ((r / 2) * t) * (1 / Real.exp 1) * (2 / r) := by
    have hA : (r / 2) * t - 1 - Real.log (r / 2) =
        (r / 2) * t + (-(1 + Real.log (r / 2))) := by ring
    rw [hA, Real.exp_add]
    have hB' : -(1 + Real.log (r / 2)) = -1 + -Real.log (r / 2) := by ring
    rw [hB', Real.exp_add, Real.exp_neg (1 : ℝ)]
    have hC : Real.exp (-Real.log (r / 2)) = 1 / (r / 2) := by
      have hloginv : -Real.log (r / 2) = Real.log ((r / 2)⁻¹) :=
        (Real.log_inv (r / 2)).symm
      rw [hloginv, Real.exp_log (by positivity : 0 < (r / 2)⁻¹)]
      ring
    rw [hC]
    field_simp
  have h3 : t ≤ Real.exp ((r / 2) * t) * (1 / Real.exp 1) * (2 / r) :=
    le_trans h1 (le_of_eq h2)
  field_simp at h3 ⊢
  ring_nf at h3 ⊢
  simpa using h3

/-- The integrable derivative majorant on a ball of radius `r` around a
    point with `Re s₀ > α`: `(2C/(r·e))·e^{-(r/2)·t}` for t > 0, else 0. -/
noncomputable def derivMajorant (r : ℝ) (C : ℝ) : ℝ → ℝ :=
    fun t => (2 * C / (r * Real.exp 1)) * (if 0 < t then Real.exp (-(r / 2) * t) else 0)

/-- The majorant is Bochner-integrable on ℝ (exponential decay on
    (0, ∞), zero on (−∞, 0]). -/
theorem derivMajorantIntegrable (r : ℝ) (hr : 0 < r) :
    Integrable (derivMajorant r C) := by
  have hneg : (-(r / 2) : ℝ) < 0 := by linarith
  have hkernel : IntegrableOn (fun t : ℝ => Real.exp (-(r / 2) * t)) (Ioi (0 : ℝ)) :=
    integrableOn_exp_mul_Ioi (a := -(r / 2)) hneg (c := (0 : ℝ))
  have hconst : IntegrableOn (fun t : ℝ =>
      (2 * C / (r * Real.exp 1)) * Real.exp (-(r / 2) * t)) (Ioi (0 : ℝ)) :=
    hkernel.const_mul (2 * C / (r * Real.exp 1))
  have hpoint : EqOn (fun t : ℝ => (2 * C / (r * Real.exp 1)) * Real.exp (-(r / 2) * t))
      (derivMajorant r C) (Ioi (0 : ℝ)) := by
    intro t ht
    have hp : 0 < t := ht
    simp [derivMajorant, hp]
  have hIoi : IntegrableOn (derivMajorant r C) (Ioi (0 : ℝ)) :=
    IntegrableOn.congr_fun hconst hpoint (by continuity)
  have hzero : EqOn (fun _ : ℝ => (0 : ℝ)) (derivMajorant r C) (Iic (0 : ℝ)) := by
    intro t ht
    by_cases hpos : 0 < t
    · exfalso
      have hle : t ≤ 0 := by simpa using ht
      exact lt_irrefl (0 : ℝ) (lt_of_lt_of_le hpos hle)
    · simp [derivMajorant, hpos]
  have hIic : IntegrableOn (derivMajorant r C) (Iic (0 : ℝ)) :=
    IntegrableOn.congr_fun (integrableOn_zero (s := (Iic (0 : ℝ)))) hzero (by continuity)
  have hunion : IntegrableOn (derivMajorant r C) (Ioi (0 : ℝ) ∪ Iic (0 : ℝ)) :=
    hIoi.union hIic
  have huniv : Ioi (0 : ℝ) ∪ Iic (0 : ℝ) = Set.univ := by
    ext t
    constructor
    · intro _; trivial
    · intro _
      by_cases h : 0 < t
      · left
        exact h
      · right
        by_contra h2
        exact h ((not_le (a := (t : ℝ)) (b := (0 : ℝ))).mp h2)
  rw [huniv] at hunion
  simpa using hunion

/-- Raw pointwise derivative bound (no ball needed): for `t > 0`,
    `‖laplaceDerivIntegrand F z t‖ ≤ C·t·e^{(α − Re z)·t}`. -/
theorem derivPtBoundRaw (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t))
    (z : ℂ) (t : ℝ) (hpos : 0 < t) :
    ‖laplaceDerivIntegrand F z t‖ ≤ C * t * Real.exp ((α - z.re) * t) := by
  have hFextb : ‖Fext F t‖ ≤ C * Real.exp (α * t) := by
    have hFext : Fext F t = F t := by simp [Fext, hpos]
    rw [hFext]
    exact hB t hpos
  have hre_k : (-(z * t)).re = -(z.re * t) := by
    simp only [Complex.neg_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
    ring
  have hexp_k : ‖Complex.exp (-(z * t))‖ = Real.exp (-(z.re * t)) := by
    rw [Complex.norm_exp, hre_k]
  have hn : ‖(-(t : ℂ))‖ = t := by
    calc
      ‖(-(t : ℂ))‖ = ‖(t : ℂ)‖ := norm_neg _
      _ = |t| := by norm_cast
      _ = t := abs_of_pos hpos
  calc
    ‖laplaceDerivIntegrand F z t‖ = ‖(Fext F t * (-(t : ℂ))) * Complex.exp (-(z * t))‖ := by
      simp [laplaceDerivIntegrand]
    _ = ‖Fext F t * (-(t : ℂ))‖ * ‖Complex.exp (-(z * t))‖ := by rw [norm_mul]
    _ = (‖Fext F t‖ * ‖(-(t : ℂ))‖) * Real.exp (-(z.re * t)) := by
      rw [norm_mul, hexp_k]
    _ = (‖Fext F t‖ * t) * Real.exp (-(z.re * t)) := by rw [hn]
    _ ≤ ((C * Real.exp (α * t)) * t) * Real.exp (-(z.re * t)) := by
      gcongr
    _ = (C * t) * (Real.exp (α * t) * Real.exp (-(z.re * t))) := by ring
    _ = (C * t) * Real.exp ((α - z.re) * t) := by
      rw [show Real.exp (α * t) * Real.exp (-(z.re * t)) =
          Real.exp ((α - z.re) * t) from by
        rw [← Real.exp_add]
        ring]

/-- Pointwise complex differentiability of the integrand: for fixed `t`,
    `z ↦ laplaceIntegrand F z t = Fext F t · e^{-z·t}` is complex
    differentiable at every `z`, with derivative `laplaceDerivIntegrand F z t`.
    (For `t ≤ 0` the zero-extension makes the integrand constant.) -/
theorem integrandHasDerivAt (z : ℂ) (t : ℝ) :
    HasDerivAt (fun (w : ℂ) => laplaceIntegrand F w t) (laplaceDerivIntegrand F z t) z := by
  by_cases hpos_t : 0 < t
  · have hext : Fext F t = F t := by simp [Fext, hpos_t]
    have hlin1 : HasDerivAt (fun (w : ℂ) => w * (-(t : ℂ))) (-(t : ℂ)) z :=
      hasDerivAt_mul_const (-(t : ℂ))
    have hlin : HasDerivAt (fun (w : ℂ) => (-(t : ℂ)) * w) (-(t : ℂ)) z := by
      have heq : (fun (w : ℂ) => (-(t : ℂ)) * w) = (fun (w : ℂ) => w * (-(t : ℂ))) := by
        ext w
        ring
      rw [← heq] at hlin1
      exact hlin1
    have hexp : HasDerivAt (fun (w : ℂ) => Complex.exp ((-(t : ℂ)) * w))
        (Complex.exp ((-(t : ℂ)) * z) * (-(t : ℂ))) z := hlin.cexp
    have hfull : HasDerivAt (fun (w : ℂ) => Complex.exp ((-(t : ℂ)) * w) * Fext F t)
        ((Complex.exp ((-(t : ℂ)) * z) * (-(t : ℂ))) * Fext F t) z :=
      hexp.mul_const (Fext F t)
    have hgoal : (fun (w : ℂ) => laplaceIntegrand F w t) =
        (fun (w : ℂ) => Complex.exp ((-(t : ℂ)) * w) * Fext F t) := by
      ext w
      simp [laplaceIntegrand, hext]
      rw [show -((w : ℂ) * (t : ℂ)) = (-(t : ℂ)) * w from by ring]
      ring
    have hexpeq : (-(t : ℂ)) * z = -(z * (t : ℂ)) := by ring
    have hdval : (Complex.exp ((-(t : ℂ)) * z) * (-(t : ℂ))) * Fext F t =
        laplaceDerivIntegrand F z t := by
      simp [laplaceDerivIntegrand]
      rw [show -(z * (t : ℂ)) = (-(t : ℂ)) * z from hexpeq.symm]
      ring
    rw [← hgoal, hdval] at hfull
    exact hfull
  · have hext : Fext F t = 0 := by simp [Fext, hpos_t]
    have hzero : (fun (w : ℂ) => laplaceIntegrand F w t) = (fun _ : ℂ => (0 : ℂ)) := by
      ext w
      simp [laplaceIntegrand, hext]
    have hd : HasDerivAt (fun _ : ℂ => (0 : ℂ)) 0 z := hasDerivAt_zero (x := z)
    have hval : laplaceDerivIntegrand F z t = 0 := by
      simp [laplaceDerivIntegrand, hext]
    rw [← hzero] at hd
    rw [← hval] at hd
    exact hd

/-- THE D1C-2 CORE: for every `s₀` with `Re s₀ > α`, the Laplace
    transform is complex differentiable at `s₀`, with derivative the
    integral of the pointwise parameter derivative, and the derivative
    integrand is Bochner-integrable. -/
theorem hasDerivAt_laplaceTransform (hC : 0 ≤ C) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t)) (s₀ : ℂ) (hpos : s₀.re > α) :
    Integrable (laplaceDerivIntegrand F s₀) ∧
      HasDerivAt (laplaceTransform F) (∫ (t : ℝ), laplaceDerivIntegrand F s₀ t) s₀ := by
  set r : ℝ := (s₀.re - α) / 2 with hrval
  have hr : 0 < r := by linarith
  have hF_int : Integrable (laplaceIntegrand F s₀) :=
    laplaceAbsIntegrable hC F hF hB s₀ hpos
  have hF_meas : ∀ᶠ (s : ℂ) in 𝓝 s₀,
      AEStronglyMeasurable (fun (t : ℝ) => laplaceIntegrand F s t) := by
    apply Filter.Eventually.of_forall
    intro s
    exact (measurable_laplaceIntegrand F hF s).aestronglyMeasurable
  have hF'_meas : AEStronglyMeasurable (fun (t : ℝ) => laplaceDerivIntegrand F s₀ t) :=
    (measurable_laplaceDerivIntegrand F hF s₀).aestronglyMeasurable
  have hbound_int : Integrable (derivMajorant r C) := derivMajorantIntegrable (C := C) r hr
  have h_bound : ∀ᵐ (t : ℝ) ∂volume, ∀ (z : ℂ), z ∈ Metric.ball s₀ r →
      ‖laplaceDerivIntegrand F z t‖ ≤ derivMajorant r C t := by
    apply Filter.Eventually.of_forall
    intro t
    by_cases hpos_t : 0 < t
    · intro z hz
      have hzr : z.re ≥ s₀.re - r := by
        have hlow : (z - s₀).re ≥ -‖z - s₀‖ := by
          have habs : ‖(z - s₀).re‖ ≤ ‖z - s₀‖ := by
            simpa using Complex.abs_re_le_norm (z - s₀)
          calc
            (z - s₀).re ≥ -‖(z - s₀).re‖ := neg_abs_le ((z - s₀).re)
            _ ≥ -‖z - s₀‖ := neg_le_neg habs
        have hmid : z.re ≥ s₀.re - ‖z - s₀‖ := by
          calc
            z.re = s₀.re + (z - s₀).re := by
              simp only [Complex.sub_re]
              ring
            _ ≥ s₀.re + (-‖z - s₀‖) := by linarith [hlow]
            _ = s₀.re - ‖z - s₀‖ := by ring_nf
        have hball : ‖z - s₀‖ < r := by
          simpa [dist_eq_norm] using Metric.mem_ball.mp hz
        linarith [hmid, hball]
      have hraw : ‖laplaceDerivIntegrand F z t‖ ≤ C * t * Real.exp ((α - z.re) * t) :=
        derivPtBoundRaw C F hB z t hpos_t
      have hheq : α - s₀.re + r = (-(r : ℝ)) := by ring
      have hle1 : α - z.re ≤ α - s₀.re + r := by linarith [hzr]
      have hle2 : (α - z.re) * t ≤ (-(r : ℝ)) * t := by
        calc
          (α - z.re) * t ≤ (α - s₀.re + r) * t :=
            mul_le_mul_of_nonneg_right hle1 (le_of_lt hpos_t)
          _ = (-(r : ℝ)) * t := by rw [hheq]
      have hzexp : Real.exp ((α - z.re) * t) ≤ Real.exp (-(r : ℝ) * t) :=
        Real.exp_le_exp.2 hle2
      have hnnt : 0 ≤ C * t := mul_nonneg hC (le_of_lt hpos_t)
      have hmid : C * t * Real.exp ((α - z.re) * t) ≤ C * t * Real.exp (-(r : ℝ) * t) := by
        gcongr <;> assumption
      have hcore : C * t ≤ 2 * C / (r * Real.exp 1) * Real.exp ((r / 2) * t) := by
        have hT : t ≤ 2 / (r * Real.exp 1) * Real.exp ((r / 2) * t) := tAbsorbedByExp r hr t hpos_t
        have hstep : C * t ≤ C * (2 / (r * Real.exp 1) * Real.exp ((r / 2) * t)) := by
          have hraw := mul_le_mul_of_nonneg_right hT hC
          simpa [mul_assoc, mul_comm, mul_left_comm] using hraw
        have hscale : C * (2 / (r * Real.exp 1) * Real.exp ((r / 2) * t)) =
            2 * C / (r * Real.exp 1) * Real.exp ((r / 2) * t) := by
          field_simp
        rw [← hscale]
        exact hstep
      have habs : C * t * Real.exp (-(r : ℝ) * t) ≤
          (2 * C / (r * Real.exp 1) * Real.exp ((r / 2) * t)) * Real.exp (-(r : ℝ) * t) :=
        mul_le_mul_of_nonneg_right hcore (le_of_lt (Real.exp_pos (-(r : ℝ) * t)))
      calc
        ‖laplaceDerivIntegrand F z t‖ ≤ C * t * Real.exp ((α - z.re) * t) := hraw
        _ ≤ C * t * Real.exp (-(r : ℝ) * t) := hmid
        _ ≤ (2 * C / (r * Real.exp 1) * Real.exp ((r / 2) * t)) * Real.exp (-(r : ℝ) * t) :=
          habs
        _ = (2 * C / (r * Real.exp 1)) * (Real.exp ((r / 2) * t) * Real.exp (-(r : ℝ) * t)) := by
          ring
        _ = (2 * C / (r * Real.exp 1)) * Real.exp (((r / 2) - r) * t) := by
          rw [show Real.exp ((r / 2) * t) * Real.exp (-(r : ℝ) * t) =
              Real.exp (((r / 2) - r) * t) from by
            rw [← Real.exp_add]
            congr
            ring]
        _ = (2 * C / (r * Real.exp 1)) * Real.exp (-(r / 2) * t) := by
          rw [show ((r / 2) - r) * t = (-(r / 2)) * t from by ring]
        _ = derivMajorant r C t := by simp [derivMajorant, hpos_t]
    · intro z _
      have hext : Fext F t = 0 := by simp [Fext, hpos_t]
      have h0 : laplaceDerivIntegrand F z t = 0 := by simp [laplaceDerivIntegrand, hext]
      simp [h0, derivMajorant, hpos_t]
  have h_diff : ∀ᵐ (t : ℝ) ∂volume, ∀ (z : ℂ), z ∈ Metric.ball s₀ r →
      HasDerivAt (fun (w : ℂ) => laplaceIntegrand F w t) (laplaceDerivIntegrand F z t) z := by
    apply Filter.Eventually.of_forall
    intro t z _
    exact integrandHasDerivAt F z t
  have hs : Metric.ball s₀ r ∈ 𝓝 s₀ := Metric.ball_mem_nhds s₀ hr
  have main := hasDerivAt_integral_of_dominated_loc_of_deriv_le hs hF_meas hF_int hF'_meas
      h_bound hbound_int h_diff
  have hfun : (fun n : ℂ => ∫ (a : ℝ), laplaceIntegrand F n a ∂volume) = laplaceTransform F := by
    funext n
    dsimp [laplaceTransform]
  have h2 := main.2
  rw [hfun] at h2
  exact ⟨by simpa using main.1, h2⟩

/-- Complex differentiability at each point of the half-plane. -/
theorem differentiableAt_laplaceTransform (hC : 0 ≤ C) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t)) (s₀ : ℂ) (hpos : s₀.re > α) :
    DifferentiableAt ℂ (laplaceTransform F) s₀ := by
  have hres := hasDerivAt_laplaceTransform C F hC hF hB s₀ hpos
  exact hres.2.differentiableAt

/-- Holomorphic on the whole half-plane `hp α` (complex differentiable at
    every point of it). -/
theorem differentiableOn_laplaceTransform (hC : 0 ≤ C) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t)) :
    DifferentiableOn ℂ (laplaceTransform F) (hp α) := by
  intro s₀ hs₀
  have hres := hasDerivAt_laplaceTransform C F hC hF hB s₀ (by simpa [hp] using hs₀)
  exact hres.2.differentiableAt.differentiableWithinAt

end

/-- DANESH POLE CONTRADICTION, end to end (engine + differentiability):
    under `‖F t‖ ≤ C·e^{α t}` (t > 0), the Laplace transform `Φ` of `F`
    is complex differentiable on `hp α`; hence it is locally bounded at
    every point of `hp α`. Any zero-sum representation that forces `Φ`
    to be UNBOUNDED (genuine pole, non-zero residue) at a point `s₀` of
    `hp α` — e.g. an off-critical zero `z₀` with `Re z₀ > α` — is thus a
    contradiction. -/
theorem daneshPoleContradiction (α : ℝ) (C : ℝ) (hC : 0 ≤ C) (F : ℝ → ℂ) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t))
    (s₀ : ℂ) (hs₀ : s₀ ∈ hp α)
    (hPole : ∀ (B δ : ℝ) (hδ : 0 < δ),
      ∃ (y : ℂ), y ∈ Metric.ball s₀ δ ∧ y ∈ hp α ∧ ‖laplaceTransform F y‖ > B) :
    False := by
  have hre : s₀.re > α := by simpa [hp] using hs₀
  have hdiff : DifferentiableOn ℂ (laplaceTransform F) (hp α) :=
    differentiableOn_laplaceTransform C F hC hF hB
  exact D1C.poleObstruction α hdiff s₀ hs₀ hPole

end D1C2
