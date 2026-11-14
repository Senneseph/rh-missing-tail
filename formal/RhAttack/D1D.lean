import RhAttack.D1C2
import Mathlib

/-!
# D1D — Link (b): the Laplace integral IS the zero-sum meromorphic object

The Danesh pole-obstruction unit (D1C, D1C-2) delivers the ENGINES:
D1C proves the half-line kernel integral and the pole obstruction in the
Laplace-integral representation; D1C-2 proves LAPLACE-TRANSFORM
HOLOMORPHY on the admissible growth half-plane `hp alpha` (link (a)).
This unit is link (b): the in-tree equality between the Laplace-integral
object and the ZERO-SUM MEROMORPHIC OBJECT, plus the named structural
pole/growth gap.

Contents
--------
1. `zeroMode rho t = exp(-rho t)`; its norm is `exp(-Re(rho) t)`.
2. LINK (b), ONE MODE: for `(s + rho).re > 0`,
   `∫_(c,∞) e^{-rho t} e^{-s t} dt = e^{-(s+rho) c} / (s + rho)` —
   the pointwise kernel identity (the exponents add) plus the D1C
   half-line kernel integral, entirely in the tree.
3. LINK (b), FINITE ZERO SET (the core equality): for any finite zero set
   `zs` and weights `cs`, the Laplace integral of the finite zero-sum
   oscillation equals the zero-sum meromorphic object, term by term:
   `∫ (c,∞) (∑ e^{-rho t}) e^{-s t} = ∑ e^{-(s+rho) c} / (s + rho)`.
4. Growth of the zero-sum oscillation: under the per-mode growth-floor
   condition, the oscillation obeys the D1C-2 exponential bound with
   exponent `alpha`, so `D1C2.differentiableOn_laplaceTransform`
   applies to it (the zero-sum oscillation's Laplace transform is
   differentiable on `hp alpha`).
5. THE NAMED STRUCTURAL POLE/GROWTH GAP: a zero mode `e^{-rho t}` with
   a pole at `-rho` in the growth half-plane `hp alpha` requires
   `alpha < -Re(rho)` — i.e. the pole fires only when the admissible
   growth exponent is STRICTLY BELOW the mode's own exponent. Equivalently,
   no admissible growth half-plane `hp alpha` that supports the
   zero-sum oscillation (all modes with `-Re(rho) <= alpha`) contains a
   mode's pole. This is the structural gap Danesh's criterion exploits:
   the zero-sum meromorphic object has poles at the negated zeros, while
   the Laplace transform (under an admissible growth bound) is holomorphic
   on the whole half-plane — so a zero-sum representation is forced to
   converge/cancel on exactly the half-planes where the poles would live.

SCOPE / NO RH CLAIM: this is an ENGINE unit. It proves in-tree the
equality of the two objects and names the structural gap; it does not
close the terminal face and makes no RH claim.
-/



open Complex
open Set
open MeasureTheory
open scoped BigOperators
open scoped Topology

namespace D1D

/-! ## The zero mode -/

/-- The mode of an explicit-formula zero oscillation at a zero `rho`:
    `e^{-rho t}` (real `t`, complex output). Its norm is
    `e^{-Re(rho) t}` — so a zero on the critical line `rho = 1/2 + i*gamma`
    gives a mode of slow decay `e^{-(1/2) t}`. -/
noncomputable def zeroMode (ρ : ℂ) (t : ℝ) : ℂ :=
    Complex.exp (-(ρ * (t : ℂ)))

/-- (machine) The norm of the mode: `|e^{-rho t}| = e^{-Re(rho) t}`. -/
theorem zeroModeNorm (ρ : ℂ) (t : ℝ) :
    ‖zeroMode ρ t‖ = Real.exp (-(ρ.re) * t) := by
  unfold zeroMode
  rw [Complex.norm_exp]
  have hre : (-(ρ * (t : ℂ))).re = -(ρ.re * t) := by
    simp only [Complex.neg_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
    ring
  rw [hre]
  ring

/-! ## Link (b), one mode: the Laplace integral IS the meromorphic object -/

/-- The Laplace integral of one zero mode over the half-line `(c, ∞)`. -/
noncomputable def zeroModeLaplaceInt (ρ s : ℂ) (c : ℝ) : ℂ :=
    ∫ (t : ℝ) in Ioi c, zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))

/-- LINK (b), one mode, **in the tree**: for `(s + ρ).re > 0`,
    `∫ (c,∞) e^{-rho t} e^{-s t} dt = e^{-(s+rho) c} / (s + ρ)`.
    Proof is the pointwise kernel identity (the exponents add) plus
    the D1C half-line kernel integral. -/
theorem zeroModeLaplaceInt_eq (ρ s : ℂ) (hs : 0 < (s + ρ).re) (c : ℝ) :
    zeroModeLaplaceInt ρ s c = Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ) := by
  have hfun : (fun t : ℝ => zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) =
      (fun t : ℝ => Complex.exp (-((s + ρ) * (t : ℂ)))) := by
    ext t
    unfold zeroMode
    have heq : -(ρ * (t : ℂ)) + (-(s * (t : ℂ))) = -((s + ρ) * (t : ℂ)) := by ring
    rw [← Complex.exp_add, heq]
  unfold zeroModeLaplaceInt
  conv_lhs => rw [hfun]
  simpa only [] using D1C.integral_laplaceKernel (s + ρ) hs c

/-! ## Link (b), finite zero set: the core equality -/

/-- LINK (b) — **the core in-tree equality** (finite zero set, no
    convergence hypotheses): for a finite zero set `zs`, the Laplace
    integral over `(c, ∞)` of the finite zero-sum oscillation equals
    the zero-sum meromorphic object, term by term:
    `∫ (∑ e^{-rho t}) e^{-s t}` = `∑ e^{-(s+rho) c} / (s + rho)`.
    All zeros of the certified band have this shape (finite, on-line
    data, weights 1); the theorem is stated for arbitrary finite sets. -/
theorem zeroSetLaplace (zs : Finset ℂ) (s : ℂ) (c : ℝ)
    (hs : ∀ (ρ : ℂ) (hr : ρ ∈ zs), 0 < (s + ρ).re) :
    (∫ (t : ℝ) in Ioi c, (∑ ρ ∈ zs, zeroMode ρ t) * Complex.exp (-(s * (t : ℂ)))) =
    ∑ ρ ∈ zs, Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ) := by
  -- (i) move the exponential inside the finite sum
  have hfun : (fun t : ℝ => (∑ ρ ∈ zs, zeroMode ρ t) * Complex.exp (-(s * (t : ℂ)))) =
      (fun t : ℝ => ∑ ρ ∈ zs, zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) := by
    funext t
    exact Finset.sum_mul zs (fun ρ : ℂ => zeroMode ρ t) (Complex.exp (-(s * (t : ℂ))))
  -- (ii) integrability of each term (D1C kernel integrability, pointwise
  --     kernel identity)
  have himp (ρ : ℂ) (hr : ρ ∈ zs) : IntegrableOn
      (fun t : ℝ => zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) (Ioi c) := by
    have hk : IntegrableOn (fun t : ℝ => Complex.exp (-((s + ρ) * (t : ℂ)))) (Ioi c) :=
      D1C.laplaceKernelIntegrable (s + ρ) (hs ρ hr) c
    have hpt : EqOn (fun t : ℝ => Complex.exp (-((s + ρ) * (t : ℂ))))
        (fun t : ℝ => zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) (Ioi c) := by
      intro t _
      show Complex.exp (-((s + ρ) * (t : ℂ))) =
          zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))
      unfold zeroMode
      have heq : -((s + ρ) * (t : ℂ)) = -(ρ * (t : ℂ)) + (-(s * (t : ℂ))) := by ring
      rw [heq, Complex.exp_add]
    exact IntegrableOn.congr_fun hk hpt (by continuity)
  -- (iii) pull the finite sum out of the integral
  conv_lhs => rw [hfun]
  rw [integral_finsetSum zs (fun ρ hr => himp ρ hr)]
  -- (iv) term by term, the one-mode identity
  exact Finset.sum_congr rfl (fun ρ hr => zeroModeLaplaceInt_eq ρ s (hs ρ hr) c)

/-! ## The finite zero-set oscillation and its growth -/

/-- The (coefficient-weighted) finite zero-set oscillation, zero-extended
    below 0 (the D1C-2 input shape). -/
noncomputable def zeroSetOsc (zs : Finset ℂ) (cs : ℂ → ℂ) (t : ℝ) : ℂ :=
    if ht : 0 < t then (∑ z ∈ zs, cs z * zeroMode z t) else 0

/-- (machine) A single mode is measurable (it is a complex exponential
    in a continuous variable). -/
theorem measurable_zeroMode {z : ℂ} : Measurable (fun t : ℝ => zeroMode z t) := by
  have : (fun t : ℝ => zeroMode z t) = (fun t : ℝ => Complex.exp (-(z * (t : ℂ)))) := by
    funext t
    unfold zeroMode
    rfl
  rw [this]
  apply Continuous.measurable
  continuity

/-- (machine) The zero-extended zero-set oscillation is measurable. The
    positive-t branch (a finite sum of weighted modes) is measurable by a
    `Finset.induction` step (`sum_insert` + measurability of one mode);
    the zero-extension is a `Measurable.ite`. -/
theorem measurable_zeroSetOsc (zs : Finset ℂ) (cs : ℂ → ℂ) :
    Measurable (zeroSetOsc zs cs) := by
  classical
  have hsum : Measurable (fun t : ℝ => (∑ z ∈ zs, cs z * zeroMode z t)) := by
    induction zs using Finset.induction with
    | empty =>
      have : (fun t : ℝ => (∑ z ∈ ∅, cs z * zeroMode z t)) =
          (fun _ : ℝ => (0 : ℂ)) := by
        funext t
        simpa using Finset.sum_empty
      rw [this]
      exact measurable_const
    | insert z s hz ih =>
      have hsplit (t : ℝ) : (∑ x ∈ insert z s, cs x * zeroMode x t) =
          cs z * zeroMode z t + (∑ x ∈ s, cs x * zeroMode x t) :=
        Finset.sum_insert hz
      have hfun : (fun t : ℝ => (∑ x ∈ insert z s, cs x * zeroMode x t)) =
          (fun t : ℝ => cs z * zeroMode z t + (∑ x ∈ s, cs x * zeroMode x t)) := by
        funext t
        rw [hsplit t]
      rw [hfun]
      apply Measurable.add
      · exact Measurable.mul (measurable_const : Measurable (fun _ : ℝ => cs z)) measurable_zeroMode
      · exact ih
  rw [show zeroSetOsc zs cs =
      (fun t : ℝ => if ht : 0 < t then (∑ z ∈ zs, cs z * zeroMode z t) else 0) from by
    funext t
    split_ifs with hh
    all_goals
      simp [zeroSetOsc, hh]]
  apply Measurable.ite
  · exact measurableSet_Ioi
  · exact hsum
  · exact measurable_const

/-- (machine) The growth exponent floor for ONE mode: any valid
    exponential growth bound `|e^{-rho t}| <= C * e^{alpha t}` (for all
    `t > 0`) forces `alpha >= -Re(rho)`. Equivalently: no mode admits a
    growth exponent strictly below its own exponent. (One side of the
    pole-position gap; see `poleFireRequiresStrictlySlowerGrowth`.) -/
theorem zeroModeGrowthFloor (ρ : ℂ) (α C : ℝ)
    (hB : ∀ (t : ℝ), 0 < t → ‖zeroMode ρ t‖ ≤ C * Real.exp (α * t)) :
    0 ≤ α + (ρ : ℂ).re := by
  by_contra h
  -- r = -(alpha + re(rho)) > 0, and e^{-rho t} = e^{r t} * e^{alpha t}, so
  -- hB gives e^{r t} <= C for all t > 0: impossible (exponential growth).
  set r : ℝ := -(α + (ρ : ℂ).re) with hr
  have hrpos : 0 < r := by
    rw [hr]
    have hlt : α + (ρ : ℂ).re < 0 := by
      by_contra h2
      exact h (not_lt.mp h2)
    linarith
  have h1 : ∀ (t : ℝ), 0 < t → Real.exp (r * t) ≤ C := by
    intro t ht
    have hbound := hB t ht
    rw [zeroModeNorm ρ t] at hbound
    have hpos : 0 < Real.exp (-(α * t)) := Real.exp_pos (-(α * t))
    have hbound' : Real.exp (-(ρ.re) * t) * Real.exp (-(α * t)) ≤
        C * (Real.exp (α * t) * Real.exp (-(α * t))) := by
      have h1 := mul_le_mul_of_nonneg_right hbound hpos.le
      rwa [← mul_assoc]
    have heq : r * t = (-(ρ.re) * t) + (-(α * t)) := by
      rw [hr]
      ring
    calc
      Real.exp (r * t) = Real.exp ((-(ρ.re) * t) + (-(α * t))) := by rw [heq]
      _ = Real.exp (-(ρ.re) * t) * Real.exp (-(α * t)) :=
        Real.exp_add (-(ρ.re) * t) (-(α * t))
      _ ≤ C * (Real.exp (α * t) * Real.exp (-(α * t))) := hbound'
      _ = C * Real.exp (α * t + (-(α * t))) := by
        congr
        rw [← Real.exp_add]
      _ = C * Real.exp 0 := by
        congr
        ring
      _ = C := by
        rw [Real.exp_zero]
        ring
  by_cases hC : 0 ≤ C
  · -- choose t with r*t > log(C + 1): then e^{r t} > C + 1 > C
    set tstar : ℝ := (Real.log (C + 1) + 1) / r with htd
    have hnum : 0 < Real.log (C + 1) + 1 := by
      have : (0 : ℝ) ≤ Real.log (C + 1) := Real.log_nonneg (by linarith)
      linarith
    have ht : 0 < tstar := by
      rw [htd]
      exact div_pos hnum hrpos
    have hexp : Real.exp (r * tstar) = (C + 1) * Real.exp 1 := by
      have ht' : r * tstar = Real.log (C + 1) + 1 := by
        rw [htd]
        field_simp [hrpos.ne']
      rw [ht', Real.exp_add, Real.exp_log (by linarith : 0 < C + 1)]
    have hgt : (C + 1) * Real.exp 1 > C := by
      have hposC1 : 0 < C + 1 := by linarith
      have he : 1 < Real.exp 1 := lt_trans (show (1 : ℝ) < 2.7182818283 from by norm_num)
          Real.exp_one_gt_d9
      calc
        (C + 1) * Real.exp 1 > (C + 1) * 1 := mul_lt_mul_of_pos_left he hposC1
        _ = C + 1 := by ring
        _ > C := by linarith
    linarith [hexp, hgt, h1 tstar ht]
  · -- C < 0: take t = 1; the left side is positive, the right is negative
    have hCneg : C < 0 := not_le.mp hC
    have hpoint := hB 1 (by norm_num)
    have hpos : 0 < ‖zeroMode ρ 1‖ := by
      rw [zeroModeNorm ρ 1]
      exact Real.exp_pos _
    have hnegR : C * Real.exp (α * 1) < 0 :=
      mul_neg_of_neg_of_pos hCneg (Real.exp_pos (α * 1))
    linarith

/-- (machine) The finite zero-set oscillation obeys the D1C-2 exponential
    bound with exponent `alpha` (any `alpha` at or above the growth floor
    `-re(z)` for every mode `z` in the set): for `t > 0`,
    `|zeroSetOsc zs cs t| <= (∑ |cs z|) * e^{alpha t}`. -/
theorem zeroSetOscGrowthExponent (zs : Finset ℂ) (cs : ℂ → ℂ) (α : ℝ)
    (hα : ∀ (z : ℂ) (hz : z ∈ zs), 0 ≤ α + z.re) (t : ℝ) (ht : 0 < t) :
    ‖zeroSetOsc zs cs t‖ ≤ (∑ z ∈ zs, ‖cs z‖) * Real.exp (α * t) := by
  have hopen : zeroSetOsc zs cs t = (∑ z ∈ zs, cs z * zeroMode z t) := by
    simp [zeroSetOsc, ht]
  rw [hopen]
  have hterm (z : ℂ) (hz : z ∈ zs) : ‖cs z * zeroMode z t‖ ≤ ‖cs z‖ * Real.exp (α * t) := by
    rw [norm_mul (cs z) (zeroMode z t), zeroModeNorm z t]
    have hexp : Real.exp (-(z.re) * t) ≤ Real.exp (α * t) :=
      Real.exp_le_exp.mpr (by
        nlinarith [hα z hz])
    gcongr
  calc
    ‖(∑ z ∈ zs, cs z * zeroMode z t)‖ ≤ ∑ z ∈ zs, ‖cs z * zeroMode z t‖ :=
      norm_sum_le zs (fun z => cs z * zeroMode z t)
    _ ≤ ∑ z ∈ zs, ‖cs z‖ * Real.exp (α * t) :=
      Finset.sum_le_sum fun z hz => hterm z hz
    _ = (∑ z ∈ zs, ‖cs z‖) * Real.exp (α * t) := by
      rw [Finset.sum_mul]

/-! ## Differentiability of the zero-set Laplace transform (D1C-2) -/

/-- The zero-set oscillation's Laplace transform is differentiable on the
    admissible growth half-plane `hp alpha` — the D1C-2 link-(a) engine
    applies to oscillations of exactly the shape produced by a finite zero
    sum (measurable, exponentially bounded with the per-mode growth floor). -/
theorem zeroSetOscLaplaceDifferentiable (zs : Finset ℂ) (cs : ℂ → ℂ) (α : ℝ)
    (hα : ∀ (z : ℂ) (hz : z ∈ zs), 0 ≤ α + z.re) :
    DifferentiableOn ℂ (D1C2.laplaceTransform (zeroSetOsc zs cs)) (D1C.hp α) := by
  set C : ℝ := (∑ z ∈ zs, ‖cs z‖) with hCdef
  have hC : 0 ≤ C := by
    rw [hCdef]
    exact Finset.sum_nonneg fun z _ => norm_nonneg _
  exact D1C2.differentiableOn_laplaceTransform C (zeroSetOsc zs cs) hC
      (measurable_zeroSetOsc zs cs)
      (fun t ht => zeroSetOscGrowthExponent zs cs α hα t ht)

/-! ## The pole position: the named structural gap -/

/-- THE NAMED STRUCTURAL POLE/GROWTH GAP, stated. The pole of the mode's
    meromorphic contribution sits at `-rho`; it lies in the admissible
    growth half-plane `hp alpha` iff `alpha < -Re(rho)` — i.e. the pole
    fires only when the admissible growth exponent is STRICTLY BELOW the
    mode's own decay exponent. -/
theorem poleFireRequiresStrictlySlowerGrowth (ρ : ℂ) (α : ℝ) :
    (-ρ) ∈ D1C.hp α ↔ α < -(ρ.re) := by
  constructor
  · intro h
    simp only [D1C.hp, Complex.neg_re] at h
    exact h
  · intro h
    simp only [D1C.hp, Complex.neg_re]
    exact h

/-- A mode whose oscillation satisfies an admissible growth bound
    (`|e^{-rho t}| <= C * e^{alpha t}` for all `t > 0`) can NEVER have
    its pole inside the corresponding admissible growth half-plane:
    the growth floor forces `alpha >= -Re(rho)`, while a pole in
    `hp alpha` would require `alpha < -Re(rho)`. This is the structural
    content of the Danesh criterion: under the admissible growth bound,
    the Laplace transform is holomorphic on the whole half-plane (D1C-2),
    so any zero-sum representation of it must not place poles there —
    the poles at the negated zeros are excluded by the growth floor. -/
theorem poleNeverInAdmissibleGrowthHalfPlane (ρ : ℂ) (α C : ℝ)
    (hB : ∀ (t : ℝ), 0 < t → ‖zeroMode ρ t‖ ≤ C * Real.exp (α * t)) :
    ¬ ((-ρ) ∈ D1C.hp α) := by
  intro h
  have hfloor : 0 ≤ α + (ρ : ℂ).re := zeroModeGrowthFloor ρ α C hB
  have hlt : α < -(ρ.re) := (poleFireRequiresStrictlySlowerGrowth ρ α).mp h
  have hneg : α + (ρ : ℂ).re < 0 := by linarith
  linarith

end D1D
