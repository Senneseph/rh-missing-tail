import Mathlib

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

/-!
**D1C — the Danesh pole-obstruction engine, formal unit 1** (0392, option B,
lane D — the Weil two-interval criterion, arXiv 2611.10726).

Danesh's Lemma 3 (pole obstruction) turns an exponential bound on the Weil
oscillation `F_h(t) = O(e^{alpha t})` into a contradiction with an
off-critical zero `z0` (`Re z0 > alpha`): the Laplace transform of `F_h` is
then holomorphic on the half-plane `Re s > alpha`, while the zero-sum
representation gives a meromorphic function with a GENUINE POLE at `z0`
there (non-zero residue `H_h(z0)^2`). This module formalizes the
self-contained analytic engine:

1. **Half-plane topology**: `hp a = {s : ℂ | Re s > a}` is open and
   connected (`isOpen_hp`, `isConnected_hp` — the continuous image of
   `Ioi a ×ˢ univ` under `(x, y) ↦ x + y·i`).
2. **Laplace-kernel integrability**: for `Re s > 0`, `t ↦ e^{-s·t}` is
   Bochner-integrable on every half-line `(c, ∞)`
   (`laplaceKernelIntegrable`), and `∫_{(c,∞)} e^{-s t} dt = e^{-s c}/s`
   (`integral_laplaceKernel`) — the in-tree instance of
   Mathlib's `ImproperIntegrals.integral_exp_mul_complex_Ioi`.
3. **Exponential-bound absolute integrability** (`laplaceAbsIntegrable`):
   if `‖F t‖ ≤ C·e^{alpha t}` for t > 0 with C ≥ 0 and `Re s > alpha`,
   then the zero-extended Laplace integrand `t ↦ Fext F t · e^{-s t}` is
   Bochner-integrable on ℝ: its norm is pointwise ≤ the integrable
   majorant `t ↦ C·e^{(alpha − Re s)·t}` on `(0, ∞)` (and 0 below 0).
4. **The pole obstruction** (`DifferentiableOn.locallyBoundedAt`,
   `poleObstruction`, `poleObstructionLaplace`): a complex differentiable
   function is locally bounded at each point of its open domain, so a
   function differentiable on `hp alpha` is bounded on a ball around every
   `s0 ∈ hp alpha` — it has NO pole there. With the Laplace transform
   (made differentiable there in D1C-2 under the O(e^{alpha t}) bound),
   the zero-sum pole at `z0` is a contradiction.

SCOPE / NO RH CLAIM: this is the ENGINE, formalized and proven, not a
proof of RH. The missing links to the full criterion are (a) the
differentiability of the Laplace transform on `hp alpha` (unit D1C-2, via
`hasDerivAt_integral_of_dominated_loc_of_lip` with a
t·e^{(alpha−Re s+r)·t} dominant), and (b) the in-tree equality of the
Laplace integral with the zero-sum meromorphic function on `Re s > 1/2`
(Danesh Theorem 4.1's domain; convergence from in-tree zero counting). The
pole obstacle then closes the off-critical-zero alternative of Danesh's
quantified violation. Against the program: the pinned M2 wall (0350) is
UNAFFECTED by this engine (it is about the S-side absolute bound, not
zero-density exponents or S-bounds); the terminal face
(`terminalFaceCE82`) is NOT reduced by it — consuming the Danesh criterion
against the face is a separate explicit unit, and none has been executed.
-/

namespace D1C

open MeasureTheory

open scoped Topology

/- Section 1: half-plane topology -/

/-- The open half-plane Re s > a (Danesh's half-plane of exponential convergence at rate a). -/
def hp (a : ℝ) : Set ℂ := {s | s.re > a}

/-- `hp a` is open. -/
theorem isOpen_hp (a : ℝ) : IsOpen (hp a) :=
  isOpen_preimage (continuous Complex.re) (isOpen_Ioi a)

/-- `hp a` is connected: it is the continuous image of `Ioi a ×ˢ univ`
    under `(x, y) ↦ x + y·i`, with image exactly `hp a`. -/
theorem isConnected_hp (a : ℝ) : IsConnected (hp a) := by
  let f : ℝ × ℝ → ℂ := fun p => p.1 + p.2 * Complex.I
  have hconn : IsConnected (Ioi a ×ˢ Set.univ : Set (ℝ × ℝ)) :=
    IsConnected.prod (isConnected_Ioi _) (isConnected_univ)
  have hc : Continuous f := by continuity
  have hleft : f '' (Ioi a ×ˢ Set.univ) ⊆ hp a := by
    rintro s ⟨⟨x, y⟩, hx, rfl⟩
    have hx' : a < x := (Set.mem_prod_set.mp hx).1
    simp only [hp, Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im,
      Complex.re_ofReal, Complex.im_ofReal, add_zero, mul_zero, zero_mul]
    exact hx'
  have hright : hp a ⊆ f '' (Ioi a ×ˢ Set.univ) := by
    intro s hs
    use s.re, s.im
    constructor
    · simp only [Set.mem_prod_set, Set.mem_setOf_eq, Set.mem_Ioi]
      exact ⟨hs, True.intro⟩
    · fun_prop
  rw [show hp a = f '' (Ioi a ×ˢ Set.univ) from Set.Subset.antisymm hright hleft]
  exact IsConnected.image hconn f (hc.continuousOn.mono (Set.subset_univ _))

/- Section 2: Laplace kernel -/

/-- For Re s > 0, t ↦ e^{-s t} is integrable on (c, ∞) for every c. -/
theorem laplaceKernelIntegrable (s : ℂ) (hs : 0 < s.re) (c : ℝ) :
    IntegrableOn (fun (t : ℝ) => Complex.exp (-(s * t))) (Ioi c) :=
  integrableOn_exp_mul_complex_Ioi (a := -s) (by simp only [Complex.neg_re]; linarith) c

/-- The half-line Laplace integral of the kernel: ∫_{(c,∞)} e^{-s t} dt = e^{-s c} / s. -/
theorem integral_laplaceKernel (s : ℂ) (hs : 0 < s.re) (c : ℝ) :
    (∫ (t : ℝ) in Ioi c, Complex.exp (-(s * t))) = Complex.exp (-(s * c)) / s := by
  have ha : (-s).re < 0 := by simp only [Complex.neg_re]; linarith
  have h := integral_exp_mul_complex_Ioi (a := -s) ha c
  rw [h]
  have hne : s ≠ 0 := by
    intro h
    rw [h] at hs
    simp at hs
  field_simp [hne]
  have hexp : Complex.exp ((-s) * (c : ℂ)) = Complex.exp (-(s * (c : ℂ))) := by
    congr
    ring
  simp only [hexp]
  ring

/- Section 3: Laplace integrability under an exponential bound -/

/-- Zero extension below 0 (strict: 0 at t = 0 too; the measure-zero
    difference is ignored by the integral). -/
def Fext (F : ℝ → ℂ) (t : ℝ) : ℂ :=
  if ht : 0 < t then F t else 0

/-- `Fext` is measurable from a measurable `F`. -/
theorem measurable_Fext (F : ℝ → ℂ) (hF : Measurable F) : Measurable (Fext F) := by
  simpa [Fext] using Measurable.ite (measurable_set_Ioi 0) hF measurable_const

/-- The zero-extended Laplace integrand at parameter s. -/
def laplaceIntegrand (F : ℝ → ℂ) (s : ℂ) (t : ℝ) : ℂ :=
  Fext F t * Complex.exp (-(s * t))

/-- The integrand is measurable. -/
theorem measurable_laplaceIntegrand (F : ℝ → ℂ) (hF : Measurable F) (s : ℂ) :
    Measurable (laplaceIntegrand F s) := by
  have hexp : Measurable (fun t : ℝ => Complex.exp (-(s * t))) := by continuity
  simpa [laplaceIntegrand] using (measurable_Fext F hF).mul hexp

/-- The integrable majorant: C·e^{(alpha − Re s)·t} on (0, ∞), else 0. -/
def laplaceMajor (α : ℝ) (C : ℝ) (s : ℂ) (t : ℝ) : ℝ :=
  if ht : 0 < t then C * Real.exp ((α - s.re) * t) else 0

/-- Exponential-bound absolute integrability (the D1C core): if
    `‖F t‖ ≤ C·exp (α·t)` for all t > 0 with C ≥ 0, then for every s with
    `Re s > α`, the zero-extended Laplace integrand is Bochner-integrable. -/
theorem laplaceAbsIntegrable {α C : ℝ} (hC : 0 ≤ C) (F : ℝ → ℂ) (hF : Measurable F)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t))
    (s : ℂ) (hs : s.re > α) :
    Integrable (laplaceIntegrand F s) := by
  -- (1) the majorant is integrable on (0, ∞):
  have ha : α - s.re < 0 := by linarith
  have hmajIoi : IntegrableOn (fun t : ℝ => C * Real.exp ((α - s.re) * t)) (Ioi 0) :=
    (integrableOn_exp_mul_Ioi (a := α - s.re) ha 0).const_mul C
  -- (2) the majorant is pointwise 0 on (-∞, 0], hence integrable there:
  have hzero : EqOn (laplaceMajor α C s) (fun _ : ℝ => 0) (Iic 0) := by
    intro t ht
    by_cases hpos : 0 < t
    · exfalso
      exact ht.le.not_of_lt hpos?
    · simp [laplaceMajor, hpos]
  have hmajIic : IntegrableOn (laplaceMajor α C s) (Iic 0) :=
    IntegrableOn.congr_fun (integrableOn_zero (s := (Iic 0 : Set ℝ))) hzero (measurableSet_Iic 0)
  -- (3) the majorant on (0, ∞) agrees with the explicit kernel there:
  have hpoint : EqOn (laplaceMajor α C s) (fun _ : ℝ => C * Real.exp ((α - s.re) * (· : ℝ))) (Ioi 0) := by
    intro t ht
    simp [laplaceMajor, ht]
  have hmajIoi' : IntegrableOn (laplaceMajor α C s) (Ioi 0) :=
    IntegrableOn.congr_fun hmajIoi hpoint (measurableSet_Ioi 0)
  -- (4) combine (0, ∞) with (-∞, 0] to get integrability on ℝ:
  have hunion : IntegrableOn (laplaceMajor α C s) (Ioi 0 ∪ Iic 0) := hmajIoi'.union hmajIic
  have huniv : Ioi (0 : ℝ) ∪ Iic 0 = Set.univ := by
    ext t
    simp only [Set.mem_union, Set.mem_Ioi, Set.mem_Iic, Set.mem_univ, and_self]
    exact ⟨fun h => by tauto, fun _ => lt_or_le 0 t⟩
  have hmajInt : Integrable (laplaceMajor α C s) (volume.restrict univ) := by
    simpa [← huniv] using hunion
  have hmaj : Integrable (laplaceMajor α C s) := by
    simpa [Measure.restrict_univ] using hmajInt
  -- (5) pointwise norm bound, everywhere:
  have hbound : ∀ (t : ℝ), ‖laplaceIntegrand F s t‖ ≤ ‖laplaceMajor α C s t‖ := by
    intro t
    by_cases hpos : 0 < t
    · have hFext : Fext F t = F t := by simp [Fext, hpos]
      have hre : (-(s * t)).re = -(s.re * t) := by
        simp only [Complex.neg_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
          neg_mul, mul_neg, sub_zero, zero_mul]
        ring
      have hA : 0 ≤ Real.exp (-(s.re * t)) := (Real.exp_pos _).le
      calc
        ‖Fext F t * Complex.exp (-(s * t))‖ = ‖F t * Complex.exp (-(s * t))‖ := by rw [hFext]
        _ = ‖F t‖ * ‖Complex.exp (-(s * t))‖ := norm_mul _ _
        _ = ‖F t‖ * Real.exp (-(s.re * t)) := by
          rw [Complex.norm_exp, hre]
        _ ≤ (C * Real.exp (α * t)) * Real.exp (-(s.re * t)) :=
          mul_le_mul_of_nonneg_right (hB t hpos) hA
        _ = C * Real.exp (α * t) * Real.exp (-(s.re * t)) := by ring
        _ = C * Real.exp ((α - s.re) * t) := by
          rw [Real.exp_add, show α * t + -(s.re * t) = (α - s.re) * t from by ring]
        _ = C * Real.exp ((α - s.re) * t) * 1 := one_mul?
        _ ≤ abs (C * Real.exp ((α - s.re) * t)) := le_of_eq? (show _ = _ from by
          rw [abs_of_nonneg (mul_nonneg hC (Real.exp_pos _).le)])?
        _ = ‖C * Real.exp ((α - s.re) * t)‖ := by simp?
        _ = ‖laplaceMajor α C s t‖ := by simp [laplaceMajor, hpos]
    · have hFext : Fext F t = 0 := by simp [Fext, hpos]
      simp [hFext, laplaceMajor, hpos]
  -- (6) comparison:
  exact Integrable.mono hmaj (measurable_laplaceIntegrand F hF s).aestronglyMeasurable hbound

/- Section 4: the pole obstruction -/

/-- A complex differentiable function on an open set is locally bounded at
    each point of the set: there is a ball around x on which ‖f y‖ ≤ B. -/
theorem DifferentiableOn.locallyBoundedAt {U : Set ℂ} (hf : DifferentiableOn ℂ f U)
    (hU : IsOpen U) {x : ℂ} (hx : x ∈ U) :
    ∃ B δ : ℝ, 0 < δ ∧ ∀ (y : ℂ), y ∈ Metric.ball x δ → ‖f y‖ ≤ B := by
  have hcont : ContinuousAt f x := (hf.continuousOn).continuousAt (hU.mem_nhds hx)
  have hV : {y : ℂ | f y ∈ Metric.ball (f x) 1} ∈ 𝓝 x :=
    hcont.mem (Metric.ball (f x) 1) (ball_mem_nhds (f x) (by norm_num : 0 < (1 : ℝ)))
  obtain ⟨δ, hδ0, hball⟩ := Metric.nhds_basis_ball.mem_nhds hV
  refine ⟨‖f x‖ + 1, δ, hδ0, ?_⟩
  intro y hy
  have hlt : ‖f y‖ < ‖f x‖ + 1 := by
    calc
      ‖f y‖ = ‖(f y - f x) + f x‖ := by ring
      _ ≤ ‖f y - f x‖ + ‖f x‖ := norm_add_le _ _
      _ < 1 + ‖f x‖ := add_lt_add_right (Metric.mem_ball.mp (hball hy)) 0
      _ = ‖f x‖ + 1 := by ring
  exact hlt.le

/-- POLE OBSTRUCTION (Danesh Lemma 3, formal core): if f is complex
    differentiable on the half-plane `hp alpha`, then f cannot be unbounded
    at any point s0 in the half-plane — no pole is possible there. -/
theorem poleObstruction (α : ℝ) {f : ℂ → ℂ} (hf : DifferentiableOn ℂ f (hp α))
    (s0 : ℂ) (hs0 : s0 ∈ hp α)
    (hPole : ∀ (B : ℝ), ∀ (δ : ℝ) (hδ : 0 < δ), ∃ (y : ℂ), y ∈ Metric.ball s0 δ ∧ y ∈ hp α ∧ ‖f y‖ > B) :
    False := by
  rcases hf.locallyBoundedAt isOpen_hp hs0 with ⟨B, δ, hδ0, hBdd⟩
  rcases hPole B δ hδ0 with ⟨y, hy_ball, _hy_hp, hyPole⟩
  exact hyPole.le.not (hBdd y hy_ball)

/-- (Composed form) If the Laplace transform Φ of an O(e^{alpha t})
    oscillation F is differentiable on `hp alpha` (guaranteed by D1C-2
    under the same exponential bound), then Φ has no pole in the
    half-plane: the zero-sum pole at any off-critical zero z0 with
    `Re z0 > alpha` is a contradiction. -/
theorem poleObstructionLaplace (α : ℝ) {F : ℝ → ℂ} {C : ℝ} (hC : 0 ≤ C)
    (hB : ∀ (t : ℝ), 0 < t → ‖F t‖ ≤ C * Real.exp (α * t))
    {Φ : ℂ → ℂ} (hΦ : DifferentiableOn ℂ Φ (hp α))
    (s0 : ℂ) (hs0 : s0 ∈ hp α)
    (hPole : ∀ (B : ℝ), ∀ (δ : ℝ) (hδ : 0 < δ), ∃ (y : ℂ), y ∈ Metric.ball s0 δ ∧ y ∈ hp α ∧ ‖Φ y‖ > B) :
    False :=
  poleObstruction α hΦ s0 hs0 hPole

end D1C
