/-
Copyright (c) 2026 honline project. All rights reserved.
Released under Apache-2.0.

# Phase 0.5 — disk zero count for the honline program

The circular argument principle, built from the pinned Mathlib v4.33.1
circle-integral lemmas (exact statements audited in the Phase 0 ledger of
`docs/ONLINE-FORMALIZATION-SCOPE.md`):

- `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable`
  (the residue unit: `∮ (z-w)⁻¹ • f = 2πi · f w`),
- `circleIntegral_eq_zero_of_differentiable_on_off_countable`
  (kills the non-singular part of the logarithmic derivative),
- `MeromorphicOn.extract_zeros_poles`
  (factors `f = (∏ᶠ (·-u)^{divisor}) · g` with `g` analytic and nonzero).

Target (to be proved in this module):

```
countZerosDisk : for f analytic on a nbd of the closed disk closedBall c R,
  no zeros on the circle, and no infinite-order vanishing inside,
  ∮_{C(c,R)} f'/f = 2πi · (Σᶠ u, divisor f (closedBall c R) u)
```

For entire f (like ζ) the divisor is supported on the zeros with positive
multiplicity, so the sum is the zero count with multiplicity.

NO RH CLAIM. No `sorry`, no `admit`, no axioms. All constants are classical.
-/
import Mathlib

open Complex Set Function Filter MeromorphicOn Metric


/-! ## Definitions -/

/-- The divisor sum of `f` on the closed disk `closedBall c |R|`: the count
    of zeros minus the count of poles, each with multiplicity. `finsum` is
    `0` when the support is infinite, but the support of the divisor of a
    meromorphic function is finite on a compact disk
    (`locallyFinsuppWithin.finiteSupport`). -/
noncomputable def zeroCount (c : ℂ) (R : ℝ) (f : ℂ → ℂ) : ℤ :=
  finsum (fun u : ℂ => divisor f (closedBall c |R|) u)

/-! ## Setup lemmas -/

variable {c : ℂ} {R : ℝ} {f : ℂ → ℂ} {u : ℂ}

/-- Analytic on a neighbourhood of the closed ball ⇒ meromorphic on it. -/
theorem analyticOnNhd_closedBall_meromorphicOn
    (hA : AnalyticOnNhd ℂ f (closedBall c R)) :
    MeromorphicOn f (closedBall c R) :=
  fun u hu => (hA u hu).meromorphicAt

/-- The divisor of a meromorphic function on a compact disk has finite
    support. -/
theorem divisor_closedBall_finiteSupport :
    (divisor f (closedBall c |R|)).support.Finite :=
  (divisor f (closedBall c |R|)).finiteSupport (isCompact_closedBall c |R|)

/-- Analytic on a neighbourhood of the closed ball ⇒ continuous on it. -/
theorem analyticOnNhd_closedBall_continuousOn
    (hA : AnalyticOnNhd ℂ f (closedBall c R)) :
    ContinuousOn f (closedBall c R) :=
  hA.continuousOn

/-- Analytic on a neighbourhood of the closed ball ⇒ complex-differentiable
    at every point of the open ball. -/
theorem analyticOnNhd_closedBall_differentiableAt_ball
    (hA : AnalyticOnNhd ℂ f (closedBall c R))
    (z : ℂ) (hz : z ∈ ball c R) : DifferentiableAt ℂ f z :=
  (hA z (ball_subset_closedBall hz)).differentiableAt

/-- Analytic on a neighbourhood of the closed ball ⇒ differentiable at every
    point of the closed ball (in particular on the circle). -/
theorem analyticOnNhd_closedBall_differentiableAt_closedBall
    (hA : AnalyticOnNhd ℂ f (closedBall c R))
    (z : ℂ) (hz : z ∈ closedBall c R) : DifferentiableAt ℂ f z :=
  (hA z hz).differentiableAt

/-- If `f` is analytic at `u`, the meromorphic divisor of `f` on `U` at `u`
    is a nonnegative integer (zero when `f` vanishes to infinite order at
    `u`, i.e. is locally zero). -/
theorem divisor_nonneg_of_analyticAt {U : Set ℂ}
    (hA : AnalyticAt ℂ f u) (hmer : MeromorphicOn f U) (hu : u ∈ U) :
    0 ≤ (divisor f U) u := by
  have hcond : MeromorphicOn f U ∧ u ∈ U := ⟨hmer, hu⟩
  have hd : (divisor f U) u = (meromorphicOrderAt f u).untop₀ := by
    dsimp only [divisor]
    exact if_pos hcond
  rw [hd]
  have hnn : 0 ≤ meromorphicOrderAt f u := hA.meromorphicOrderAt_nonneg
  by_cases htop : meromorphicOrderAt f u = ⊤
  · -- `f` vanishes to infinite order at `u`: the divisor entry is `0`.
    rw [htop]
    simp only [WithTop.untop₀_top]
    exact le_rfl
  · -- finite order: the untop₀ entry is the order itself, hence `≥ 0`.
    have hfin : (meromorphicOrderAt f u).untop₀ = meromorphicOrderAt f u :=
      WithTop.coe_untop₀_of_ne_top htop
    simpa [hfin] using hnn

/-! ## The circular argument principle -/

section argumentPrinciple

variable (c : ℂ) (R : ℝ) (hR : 0 < R) (f : ℂ → ℂ)

open BigOperators
open scoped Topology

/-! ### The finite local zero factor -/

/-- The finite local zero factor of `f` on the closed disk `closedBall c |R|`:
    `φ(z) = ∏ᶠ u : ℂ, (z - u) ^ divisor f (closedBall c |R|) u`.
    Away from the divisor support the factors are `1`, so this is a genuine
    finite product. -/
noncomputable def phiDisk (c : ℂ) (R : ℝ) (f : ℂ → ℂ) (z : ℂ) : ℂ :=
  ∏ᶠ u : ℂ, (z - u : ℂ) ^ divisor f (closedBall c |R|) u

/-- `phiDisk` equals the finite product over the divisor support: with
    `F : Finset ℂ` and `(F : Set ℂ) = support (divisor f (closedBall c |R|))`,
    `phiDisk c |R| f z = ∏ u ∈ F, (z - u) ^ divisor f (closedBall c |R|) u`. -/
theorem phiDisk_eq_finset (c : ℂ) (R : ℝ) (f : ℂ → ℂ) (F : Finset ℂ)
    (hF : (F : Set ℂ) = (divisor f (closedBall c |R|)).support) (z : ℂ) :
    phiDisk c |R| f z = ∏ u ∈ F, (z - u : ℂ) ^ divisor f (closedBall c |R|) u := by
  simp only [phiDisk]
  have habs : abs (abs R) = abs R := by
    rw [abs_of_nonneg (abs_nonneg R)]
  rw [habs]
  set D := divisor f (closedBall c |R|) with hD
  have hmulsupp : mulSupport (fun u : ℂ => (z - u : ℂ) ^ D u) ⊆ F := by
    intro u hu
    rw [mem_mulSupport] at hu
    have hDnz : D u ≠ 0 := by
      by_contra hD0
      have hD0' : D u = 0 := by simpa using hD0
      rw [hD0', zpow_zero] at hu
      exact hu rfl
    rw [hF]
    dsimp only [D]
    simp only [Function.mem_support, ne_eq]
    exact hDnz
  rw [finprod_eq_finsetProd_of_mulSupport_subset (fun u : ℂ => (z - u : ℂ) ^ D u)
      hmulsupp (s := F)]

/-! ### Finite products of differentiable/analytic functions -/

/-- A finite product of complex-differentiable functions is
    complex-differentiable. -/
theorem finset_prod_differentiableAt {ι : Type*} (F : Finset ι)
    (g : ι → ℂ → ℂ) (x : ℂ) :
    (∀ i ∈ F, DifferentiableAt ℂ (g i) x) → DifferentiableAt ℂ (fun y => ∏ i ∈ F, g i y) x := by
  intro hg
  classical
  induction F using Finset.induction_on with
  | empty =>
    simp [Finset.prod_empty]
  | insert a F ha ih =>
    rw [show (fun y => ∏ i ∈ insert a F, g i y) =
        (fun y => (∏ i ∈ F, g i y) * g a y) from by
      funext y
      rw [Finset.prod_insert ha]
      ring_nf]
    exact DifferentiableAt.mul (ih (fun i hi => hg i (Finset.mem_insert_of_mem hi)))
      (hg a (Finset.mem_insert_self a F))

/-- A finite product of analytic functions is analytic. -/
theorem finset_prod_analyticAt {ι : Type*} (F : Finset ι)
    (g : ι → ℂ → ℂ) (x : ℂ) :
    (∀ i ∈ F, AnalyticAt ℂ (g i) x) → AnalyticAt ℂ (fun y => ∏ i ∈ F, g i y) x := by
  intro hg
  classical
  induction F using Finset.induction_on with
  | empty =>
    simpa [Finset.prod_empty] using analyticAt_const
  | insert a F ha ih =>
    rw [show (fun y => ∏ i ∈ insert a F, g i y) =
        (fun y => (∏ i ∈ F, g i y) * g a y) from by
      funext y
      rw [Finset.prod_insert ha]
      ring_nf]
    exact AnalyticAt.mul (ih (fun i hi => hg i (Finset.mem_insert_of_mem hi)))
      (hg a (Finset.mem_insert_self a F))

/-! ### The product-logarithmic-derivative lemma -/

/-- The product-logarithmic-derivative lemma for finite products of integer
    powers: for a finite set `F`, `d : ℂ → ℤ`, and `z ∉ F`:
    `deriv (∏ (· - u)^{d u}) z / ∏ (z - u)^{d u} = ∑_{u ∈ F} d(u) / (z - u)`. -/
theorem finset_prod_logDeriv {F : Finset ℂ} (d : ℂ → ℤ) (z : ℂ)
    (hdz : ∀ u ∈ F, z ≠ u) :
    deriv (fun w => ∏ u ∈ F, (w - u : ℂ) ^ d u) z /
      (∏ u ∈ F, (z - u : ℂ) ^ d u) =
      ∑ u ∈ F, (d u : ℂ) / (z - u) := by
  induction F using Finset.induction_on with
  | empty =>
    simp only [Finset.prod_empty, deriv_const, Finset.sum_empty, div_one]
  | insert a F ha ih =>
    set Q := fun w => ∏ u ∈ F, (w - u : ℂ) ^ d u with hQ
    have hdaz : z ≠ a := hdz a (Finset.mem_insert_self a F)
    have hdzF : ∀ u ∈ F, z ≠ u := fun u hu => hdz u (Finset.mem_insert_of_mem hu)
    have hQnz : Q z ≠ 0 := by
      rw [Finset.prod_ne_zero_iff]
      intro u hu
      exact zpow_ne_zero (d u) (sub_ne_zero.mpr (hdzF u hu))
    have hanz : (z - a : ℂ) ^ d a ≠ 0 :=
      zpow_ne_zero (d a) (sub_ne_zero.mpr hdaz)
    have hQd : DifferentiableAt ℂ Q z := by
      rw [hQ]
      exact finset_prod_differentiableAt F (fun u w => (w - u : ℂ) ^ d u) z (fun u hu =>
        (HasDerivAt.comp_sub_const z u
          (hasDerivAt_zpow (d u) (z - u)
            (Or.inl (sub_ne_zero.mpr (hdzF u hu))))).differentiableAt)
    have hAd : HasDerivAt (fun w => (w - a : ℂ) ^ d a)
        ((d a : ℂ) * (z - a) ^ (d a - 1)) z :=
      HasDerivAt.comp_sub_const z a
        (hasDerivAt_zpow (d a) (z - a) (Or.inl (sub_ne_zero.mpr hdaz)))
    set P := fun w => ∏ u ∈ insert a F, (w - u : ℂ) ^ d u with hP
    have hPQ : P = fun w => Q w * (w - a : ℂ) ^ d a := by
      funext w
      dsimp only [P, Q]
      rw [show ∏ u ∈ insert a F, (w - u : ℂ) ^ d u =
          (∏ u ∈ F, (w - u : ℂ) ^ d u) * (w - a : ℂ) ^ d a from by
        calc
          _ = (w - a : ℂ) ^ d a * ∏ u ∈ F, (w - u : ℂ) ^ d u :=
            Finset.prod_insert ha
          _ = _ := by ring_nf]
    have hPnd : DifferentiableAt ℂ P z := by
      rw [hPQ]
      exact DifferentiableAt.mul hQd (HasDerivAt.differentiableAt hAd)
    have hih : deriv Q z / Q z = ∑ u ∈ F, (d u : ℂ) / (z - u) := by
      simpa [Q] using ih hdzF
    -- the derivative of `P` at `z`, via the product rule:
    have hPQd : HasDerivAt P (deriv Q z * (z - a) ^ d a +
        Q z * ((d a : ℂ) * (z - a) ^ (d a - 1))) z := by
      refine HasDerivAt.congr_of_eventuallyEq (hQd.hasDerivAt.mul hAd) ?_
      exact Filter.eventually_of_mem (univ_mem (f := 𝓝 z)) (fun w _ => by
        rw [hPQ]
        simp)
    have hderiv : deriv P z =
        deriv Q z * (z - a) ^ d a + Q z * ((d a : ℂ) * (z - a) ^ (d a - 1)) :=
      HasDerivAt.unique hPnd.hasDerivAt hPQd
    have hPval : P z = Q z * (z - a) ^ d a := by
      dsimp only [P, Q]
      rw [show ∏ u ∈ insert a F, (z - u : ℂ) ^ d u =
          (∏ u ∈ F, (z - u : ℂ) ^ d u) * (z - a : ℂ) ^ d a from by
        calc
          _ = (z - a : ℂ) ^ d a * ∏ u ∈ F, (z - u : ℂ) ^ d u :=
            Finset.prod_insert ha
          _ = _ := by ring_nf]
    have hc1 : deriv Q z * (z - a) ^ d a / (Q z * (z - a) ^ d a) =
        deriv Q z / Q z := by
      field_simp [hQnz, hanz]
    have hc2 : Q z * ((d a : ℂ) * (z - a) ^ (d a - 1)) / (Q z * (z - a) ^ d a) =
        (d a : ℂ) / (z - a) := by
      have hzpow : (z - a : ℂ) ^ d a = (z - a) ^ (d a - 1) * (z - a) := by
        have hexp : d a = (d a - 1) + 1 := (Int.sub_add_cancel (d a) 1).symm
        have hl : (z - a : ℂ) ^ d a = (z - a : ℂ) ^ ((d a - 1) + 1) :=
          congrArg (fun n : ℤ => (z - a : ℂ) ^ n) hexp
        rw [hl, zpow_add₀ (sub_ne_zero.mpr hdaz) (d a - 1) 1, zpow_one]
      rw [hzpow]
      field_simp [hQnz, hanz, zpow_ne_zero (d a - 1) (sub_ne_zero.mpr hdaz)]
    have hdiv : deriv Q z * (z - a) ^ d a / (Q z * (z - a) ^ d a) +
          Q z * ((d a : ℂ) * (z - a) ^ (d a - 1)) / (Q z * (z - a) ^ d a) =
        (deriv Q z * (z - a) ^ d a +
          Q z * ((d a : ℂ) * (z - a) ^ (d a - 1))) / (Q z * (z - a) ^ d a) := by
      field_simp [mul_ne_zero hQnz hanz]
    calc deriv P z / P z
        = (deriv Q z * (z - a) ^ d a +
            Q z * ((d a : ℂ) * (z - a) ^ (d a - 1))) / (Q z * (z - a) ^ d a) := by
          rw [hPval, hderiv]
      _ = deriv Q z * (z - a) ^ d a / (Q z * (z - a) ^ d a) +
            Q z * ((d a : ℂ) * (z - a) ^ (d a - 1)) / (Q z * (z - a) ^ d a) :=
        hdiv.symm
      _ = deriv Q z / Q z + (d a : ℂ) / (z - a) := by
        rw [hc1, hc2]
      _ = ∑ u ∈ F, (d u : ℂ) / (z - u) + (d a : ℂ) / (z - a) := by
        rw [hih]
      _ = ∑ u ∈ insert a F, (d u : ℂ) / (z - u) := by
        rw [Finset.sum_insert ha]
        ring_nf

/-! ### Accumulation points of closed disks -/

/-- A point of the closed disk (with `R > 0`) is an accumulation point of the
    closed disk (the disk has no isolated points). -/
theorem accPt_closedBall {c : ℂ} {R : ℝ} (hR : 0 < R) (z : ℂ)
    (hz : z ∈ closedBall c R) :
    AccPt z (𝓟 (closedBall c R)) := by
  rw [accPt_iff_nhds]
  intro U hU
  obtain ⟨ε, hε, hball⟩ : ∃ ε > 0, ball z ε ⊆ U := by
    have hzint : z ∈ interior U := mem_interior_iff_mem_nhds.2 hU
    obtain ⟨ε, hε, hball0⟩ : ∃ ε > 0, ball z ε ⊆ interior U :=
      Metric.isOpen_iff.mp isOpen_interior z hzint
    exact ⟨ε, hε, hball0.trans interior_subset⟩
  by_cases hzc : z = c
  · -- `z = c`: step by `min ε R / 2` in the direction `1`:
    set ε' := min ε R / 2 with hεp
    have hεp : 0 < ε' := by
      rw [hεp]
      exact div_pos (lt_min_iff.2 ⟨hε, hR⟩) two_pos
    set w := c + (ε' : ℂ) with hw
    have hwne : w ≠ z := by
      intro he
      rw [hzc, hw] at he
      have h0 : (ε' : ℂ) = 0 := by
        have h1 : c + (ε' : ℂ) = c + 0 := by simpa using he
        exact (add_left_cancel_iff (a := c) (b := (ε' : ℂ)) (c := (0 : ℂ))).mp h1
      have h1 : ‖(ε' : ℂ)‖ = |ε'| := RCLike.norm_ofReal ε'
      have h2 : |(ε' : ℝ)| = 0 := by
        have h2a : (ε' : ℂ) = (0 : ℂ) := by simpa using h0
        have h2b : ‖(ε' : ℂ)‖ = 0 := by simp [h2a]
        simpa [h1] using h2b
      have h3 : (ε' : ℝ) = 0 := abs_eq_zero.mp h2
      linarith [hεp]
    have hwU : w ∈ U := by
      have hwb : w ∈ ball c ε := by
        rw [Metric.mem_ball, dist_eq, hw]
        have h1 : c + (ε' : ℂ) - c = (ε' : ℂ) := by ring_nf
        have hnorm : ‖(ε' : ℂ)‖ = |ε'| := RCLike.norm_ofReal ε'
        rw [h1, hnorm, abs_of_pos hεp]
        have h1' : (ε' : ℝ) < ε := by
          dsimp only [ε']
          have h2 : min ε R ≤ ε := min_le_left ε R
          linarith
        linarith
      have hwz : w ∈ ball z ε := by
        rw [hzc]
        exact hwb
      exact hball hwz
    have hwC : w ∈ closedBall c R := by
      rw [Metric.mem_closedBall, dist_eq, hw]
      have h1 : c + (ε' : ℂ) - c = (ε' : ℂ) := by ring_nf
      have hnorm : ‖(ε' : ℂ)‖ = |ε'| := RCLike.norm_ofReal ε'
      rw [h1, hnorm, abs_of_pos hεp]
      have h1' : (ε' : ℝ) ≤ R := by
        dsimp only [ε']
        have h2 : (2 : ℝ) * (min ε R / 2) = min ε R := by ring_nf
        nlinarith [h2, min_le_right ε R]
      linarith
    exact ⟨w, ⟨hwU, hwC⟩, hwne⟩
  · -- `z ≠ c`: step from `z` toward `c` (stays in the closed disk):
    set ε' := min ε (4 * R) with hεp
    have hεp : 0 < ε' := by
      rw [hεp]
      exact lt_min_iff.2 ⟨hε, by nlinarith⟩
    set t := (ε' : ℝ) / 4 with ht
    have htp : 0 < t := by
      dsimp only [t]
      linarith
    set v := (c - z) / ‖c - z‖ with hv
    have hpos : 0 < ‖c - z‖ := norm_pos_iff.mpr (sub_ne_zero.mpr (Ne.symm hzc))
    have hvc : ‖v‖ = 1 := by
      dsimp only [v]
      have hnorm : ‖((‖c - z‖ : ℝ) : ℂ)‖ = ‖c - z‖ := by
        have h1 : ‖((‖c - z‖ : ℝ) : ℂ)‖ = |‖c - z‖| := RCLike.norm_ofReal (‖c - z‖)
        rw [h1, abs_of_nonneg (norm_nonneg (c - z))]
      rw [norm_div, hnorm, div_self hpos.ne']
    set w := z + (t : ℂ) * v with hw
    have hwne : w ≠ z := by
      intro he
      rw [hw] at he
      have h0 : (t : ℂ) * v = 0 := by
        have h1 : z + (t : ℂ) * v = z + 0 := by simpa using he
        exact (add_left_cancel_iff (a := z) (b := (t : ℂ) * v)
          (c := (0 : ℂ))).mp h1
      have htnc : (t : ℂ) ≠ 0 := by
        intro he2
        have h1 : ‖(t : ℂ)‖ = |t| := RCLike.norm_ofReal t
        have h2 : |t| = 0 := by
          have h2a : ‖(t : ℂ)‖ = 0 := by simp [he2]
          simpa [h1] using h2a
        have h3 : t = 0 := abs_eq_zero.mp h2
        linarith [htp]
      have hv0 : v = 0 := by
        have h0c : (t : ℂ) * v = (t : ℂ) * 0 := by
          rw [mul_zero]
          exact h0
        exact mul_left_cancel₀ htnc h0c
      have hv0n : ‖v‖ = 0 := by simp [hv0]
      have hv1 : ‖v‖ = 1 := hvc
      linarith [hv1, hv0n]
    have hwU : w ∈ U := by
      have hwb : w ∈ ball z ε := by
        rw [Metric.mem_ball, dist_eq, hw]
        have h1 : z + (t : ℂ) * v - z = (t : ℂ) * v := by ring_nf
        have hnorm : ‖(t : ℂ)‖ = |t| := RCLike.norm_ofReal t
        rw [h1, norm_mul, hvc, mul_one, hnorm, abs_of_pos htp]
        have hlt : t < ε' := by
          dsimp only [t]
          linarith
        have hle : ε' ≤ ε := by
          dsimp only [ε']
          exact min_le_left ε (4 * R)
        linarith
      exact hball hwb
    have hwC : w ∈ closedBall c R := by
      rw [Metric.mem_closedBall, dist_eq, hw]
      -- `w - c = (z - c) * (1 - t / ‖c - z‖)`:
      have hlin : z + (t : ℂ) * v - c =
          (z - c) * (1 - (t : ℂ) / ‖c - z‖) := by
        rw [hv]
        have hcnez : (‖c - z‖ : ℂ) ≠ 0 := by
          norm_cast
          exact hpos.ne'
        field_simp [hcnez, hpos.ne']
        ring_nf
      rw [hlin, norm_mul]
      have hRz : ‖z - c‖ ≤ R := by
        rw [Metric.mem_closedBall] at hz
        simpa [dist_eq] using hz
      -- the inner complex term is the cast of a real expression:
      have hnorm : ‖1 - (t : ℂ) / ‖c - z‖‖ = |1 - t / ‖c - z‖| := by
        have hof : (1 - (t : ℂ) / ‖c - z‖ : ℂ) = Complex.ofReal (1 - t / ‖c - z‖) := by
          simp
        rw [hof]
        exact RCLike.norm_ofReal (1 - t / ‖c - z‖)
      rw [hnorm]
      by_cases hsmall : t ≤ ‖c - z‖
      · have ht1 : t / ‖c - z‖ ≤ 1 := by
          rw [div_le_one hpos]
          exact hsmall
        rw [abs_of_nonneg (by linarith [ht1])]
        have hmul : ‖z - c‖ * (1 - t / ‖c - z‖) = ‖z - c‖ - t := by
          have hnz : ‖c - z‖ ≠ 0 := hpos.ne'
          have h1 : ‖z - c‖ * (t / ‖c - z‖) = t := by
            rw [norm_sub_rev z c]
            exact mul_div_cancel₀ t hnz
          rw [mul_sub, mul_one, h1]
        rw [hmul]
        linarith [hRz]
      · have ht1 : 1 < t / ‖c - z‖ := by
          rw [one_lt_div hpos]
          linarith [hsmall]
        rw [abs_of_nonpos (by linarith [ht1])]
        have hneg : -(1 - t / ‖c - z‖) = t / ‖c - z‖ - 1 := by ring
        rw [hneg]
        have hmul : ‖z - c‖ * (t / ‖c - z‖ - 1) = t - ‖z - c‖ := by
          have hnz : ‖c - z‖ ≠ 0 := hpos.ne'
          have h1 : ‖z - c‖ * (t / ‖c - z‖) = t := by
            rw [norm_sub_rev z c]
            exact mul_div_cancel₀ t hnz
          rw [mul_sub, h1]
          ring
        rw [hmul]
        have hle : t ≤ R := by
          dsimp only [t, ε']
          linarith [min_le_right ε (4 * R)]
        linarith [hle, norm_nonneg (z - c)]
    exact ⟨w, ⟨hwU, hwC⟩, hwne⟩

/-! ## The main theorem -/

/-- The circular argument principle (analytic case): if `f` is analytic on a
    neighbourhood of the closed disk `closedBall c |R|`, has no zeros on the
    circle, and vanishes to finite order everywhere on the disk, then the
    circular integral of the logarithmic derivative is `2πi` times the
    (finite) sum of the divisor entries — the zero count with multiplicity
    for entire `f`. -/
theorem countZerosDisk (c : ℂ) (R : ℝ) (hR : 0 < R) (f : ℂ → ℂ)
    (hA : AnalyticOnNhd ℂ f (closedBall c |R|))
    (hnozero : ∀ z ∈ sphere c |R|, f z ≠ 0)
    (hnotop : ∀ u ∈ closedBall c |R|, meromorphicOrderAt f u ≠ ⊤) :
    (∮ z in C(c, |R|), deriv f z / f z) =
      (2 * Real.pi * Complex.I : ℂ) * (zeroCount c |R| f : ℂ) := by
  set U := closedBall c |R| with hUdef
  set D := divisor f U with hDdef
  set F := D.support with hFdef
  have hRabs : 0 < |R| := abs_pos.mpr (by linarith)
  have hmer : MeromorphicOn f U := analyticOnNhd_closedBall_meromorphicOn hA
  have hfin : F.Finite := by
    dsimp only [F, D]
    exact (divisor f U).finiteSupport (isCompact_closedBall c |R|)
  -- the support of the divisor lies in `U`:
  have hFsubsetU : F ⊆ U := by
    dsimp only [F, D]
    exact (divisor f U).supportWithinDomain
  -- every divisor point is a zero of `f`:
  have hFzero : ∀ u ∈ F, f u = 0 := by
    intro u huF
    have hDn0 : D u ≠ 0 := by
      dsimp only [F, D] at huF ⊢
      simp only [Function.mem_support, ne_eq] at huF
      exact huF
    have huU : u ∈ U := hFsubsetU huF
    have hfAu : AnalyticAt ℂ f u := hA u huU
    have hDval : D u = ((analyticOrderAt f u).map (↑)).untop₀ := by
      dsimp only [D]
      exact hA.divisor_apply huU
    by_contra hfz
    have horn : analyticOrderAt f u = 0 := by
      rw [AnalyticAt.analyticOrderAt_eq_zero hfAu]
      exact hfz
    have hdz : D u = 0 := by
      rw [hDval, horn]
      simp
    exact hDn0 hdz
  -- 1. the factorization `f =ᶠ[codiscreteWithin U] φ • g`:
  obtain ⟨g, hgA, hgNZ, hgEq⟩ :=
    MeromorphicOn.extract_zeros_poles hmer (fun u => hnotop u.val u.prop) hfin
  -- the finite workhorse `ψ(z) = ∏_{u ∈ F} (z - u)^{D u}`:
  set ψ := fun w : ℂ => ∏ u ∈ hfin.toFinset, (w - u : ℂ) ^ D u with hψdef
  -- `ψ` is the factorized rational function itself:
  have hfinD : (D : ℂ → ℤ).HasFiniteSupport := by
    dsimp only [Function.HasFiniteSupport, F, D]
    simpa [D] using hfin
  have hψφ : (∏ᶠ u : ℂ, (· - u) ^ D u) = ψ := by
    have hfefun : (∏ᶠ u : ℂ, (· - u) ^ D u) =
        (fun x : ℂ => ∏ᶠ u : ℂ, (x - u) ^ D u) :=
      Function.FactorizedRational.finprod_eq_fun (d := D) hfinD
    rw [hfefun]
    funext x
    have hmulsupp : mulSupport (fun u : ℂ => (x - u : ℂ) ^ D u) ⊆
        (hfin.toFinset : Set ℂ) := by
      intro u hu
      rw [mem_mulSupport] at hu
      by_contra h
      have hF0 : u ∉ F := by
        rw [Set.Finite.coe_toFinset] at h
        exact h
      have hD0 : D u = 0 := by
        have hnotsupp : u ∉ D.support := hF0
        rw [Function.mem_support] at hnotsupp
        classical
        exact not_not.mp hnotsupp
      rw [hD0, zpow_zero] at hu
      exact hu rfl
    rw [finprod_eq_finsetProd_of_mulSupport_subset (fun u : ℂ => (x - u : ℂ) ^ D u)
        hmulsupp (s := hfin.toFinset)]
  -- hence `f =ᶠ[codiscreteWithin U] (fun w => ψ w * g w)`:
  have hsmul : (∏ᶠ u : ℂ, (· - u) ^ D u) • g = (fun w => ψ w * g w) := by
    funext w
    rw [hψφ, Pi.smul_apply']
    simp
  have hfg : f =ᶠ[codiscreteWithin U] (fun w => ψ w * g w) := by
    simpa [← hsmul] using hgEq
  -- 2. the pointwise logarithmic-derivative identity on the circle:
  have hcircle : ∀ z ∈ sphere c |R|, deriv f z / f z =
      (∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u)) + deriv g z / g z := by
    intro z hz
    have hzU : z ∈ U := by
      dsimp only [U]
      rw [Metric.mem_closedBall]
      rw [(Metric.mem_sphere).mp hz]
    have hfz : f z ≠ 0 := hnozero z hz
    have hgz : g z ≠ 0 := hgNZ ⟨z, hzU⟩
    have hfA : AnalyticAt ℂ f z := hA z hzU
    have hgA : AnalyticAt ℂ g z := hgA z hzU
    -- `z` is not a divisor point:
    have hznsup : z ∉ F := by
      by_contra h
      have hf0 : f z = 0 := hFzero z h
      exact hfz hf0
    have hzu : ∀ u ∈ hfin.toFinset, z ≠ u := by
      intro u hu
      by_contra hzeq
      have huF : u ∈ F := by
        rw [Set.Finite.mem_toFinset] at hu
        exact hu
      have hzF : z ∈ F := by
        rw [hzeq]
        exact huF
      exact hznsup hzF
    -- 2a. the germ identity `f =ᶠ[𝓝[≠] z] (fun w => ψ w * g w)`:
    have hacc : AccPt z (𝓟 U) := accPt_closedBall hRabs z hzU
    have hψA : AnalyticAt ℂ ψ z := by
      dsimp only [ψ]
      exact finset_prod_analyticAt hfin.toFinset (fun u w => (w - u : ℂ) ^ D u) z (fun u hu =>
        AnalyticAt.zpow (AnalyticAt.sub analyticAt_id (analyticAt_const (v := u)))
          (sub_ne_zero.mpr (hzu u hu)))
    have hψNZ : ψ z ≠ 0 := by
      dsimp only [ψ]
      rw [Finset.prod_ne_zero_iff]
      intro u hu
      exact zpow_ne_zero (D u) (sub_ne_zero.mpr (hzu u hu))
    have hψNFAt : MeromorphicNFAt (fun w => ψ w * g w) z := by
      have hpmul : ψ * g = fun w => ψ w * g w := by
        funext w
        rfl
      rw [← hpmul]
      rw [meromorphicNFAt_mul_iff_left hgA hgz]
      exact (meromorphicNFAt_iff_analyticAt_or).2 (Or.inl hψA)
    have hφmgAt : MeromorphicAt (fun w => ψ w * g w) z := hψNFAt.meromorphicAt
    have hfgerm : f =ᶠ[𝓝[≠] z] (fun w => ψ w * g w) :=
      MeromorphicAt.eventuallyEq_nhdsNE_of_eventuallyEq_codiscreteWithin
        hfA.meromorphicAt hφmgAt hzU hacc hfg
    -- the filter `𝓝[≠] z` is nontrivial in `ℂ`:
    have hnebot : NeBot (𝓝[≠] z) := by
      rw [← mem_closure_iff_nhdsWithin_neBot]
      rw [Metric.mem_closure_iff]
      intro ε hε
      set s := (ε : ℝ) / 2 with hs
      have hsp : 0 < s := by
        dsimp only [s]
        linarith
      refine ⟨z + (s : ℂ), by
        intro he
        have h0 : (s : ℂ) = 0 := by
          have h1 : z + (s : ℂ) = z + 0 := by simpa using he
          exact (add_left_cancel_iff (a := z) (b := (s : ℂ))
            (c := (0 : ℂ))).mp h1
        have hsnz : (s : ℂ) ≠ 0 := by
          intro he2
          have h1 : ‖(s : ℂ)‖ = 0 := by simp [he2]
          have h2 : ‖(s : ℂ)‖ = |s| := RCLike.norm_ofReal s
          have h3 : |s| = 0 := by simpa [h2] using h1
          have h4 : s = 0 := abs_eq_zero.mp h3
          linarith [hsp]
        contradiction, by
        rw [dist_eq]
        ring_nf
        have h1 : ‖(s : ℂ)‖ = |s| := RCLike.norm_ofReal s
        rw [norm_neg, h1, abs_of_pos hsp]
        have hlt : s < ε := by
          dsimp only [s]
          linarith
        linarith⟩
    let hnebotI : NeBot (𝓝[≠] z) := hnebot
    -- 2b. the pointwise identity `f z = ψ z * g z`:
    have hfnd : DifferentiableAt ℂ f z := hfA.differentiableAt
    have hpgc : ContinuousAt (fun w => ψ w * g w) z :=
      (hψA.continuousAt).mul hgA.continuousAt
    have hfz1 : f z = ψ z * g z := by
      have h1 : Tendsto f (𝓝[≠] z) (𝓝 (f z)) :=
        Tendsto.mono_left (hfnd.continuousAt.tendsto)
          (nhdsWithin_le_nhds (a := z) (s := {z}ᶜ))
      have h2 : Tendsto (fun w => ψ w * g w) (𝓝[≠] z) (𝓝 (ψ z * g z)) :=
        Tendsto.mono_left (hpgc.tendsto)
          (nhdsWithin_le_nhds (a := z) (s := {z}ᶜ))
      simpa using tendsto_nhds_unique_of_eventuallyEq h1 h2 hfgerm
    -- 2c. the derivative equality `deriv f z = deriv (ψ · g) z`:
    set H := fun w => ψ w * g w with hH
    have hHnd : DifferentiableAt ℂ H z :=
      hψA.differentiableAt.mul hgA.differentiableAt
    have hderiv : deriv f z = deriv H z := by
      set qf := fun w => (f w - f z) / (w - z) with hqf
      set qH := fun w => (H w - H z) / (w - z) with hqH
      have hqfeq : qf =ᶠ[𝓝[≠] z] qH := by
        rw [hqf, hqH, Filter.EventuallyEq]
        filter_upwards [hfgerm] with w hw
        by_cases hwz : w - z = 0
        · simp [hwz, hw, hfz1]
        · have heq : f w - f z = H w - H z := by
            rw [hw, hfz1]
          rw [heq]
      have hqfT : Tendsto qf (𝓝[≠] z) (𝓝 (deriv f z)) := by
        rw [hqf]
        have hsl : (fun w => (f w - f z) / (w - z)) = slope f z := by
          funext w
          rw [slope]
          simp only [smul_eq_mul, div_eq_inv_mul, vsub_eq_sub]
        rw [hsl]
        exact hasDerivAt_iff_tendsto_slope.mp hfnd.hasDerivAt
      have hqHT : Tendsto qH (𝓝[≠] z) (𝓝 (deriv H z)) := by
        rw [hqH]
        have hsl : (fun w => (H w - H z) / (w - z)) = slope H z := by
          funext w
          rw [slope]
          simp only [smul_eq_mul, div_eq_inv_mul, vsub_eq_sub]
        rw [hsl]
        exact hasDerivAt_iff_tendsto_slope.mp hHnd.hasDerivAt
      simpa using tendsto_nhds_unique_of_eventuallyEq hqfT hqHT hqfeq
    -- 2d. the algebra:
    have h1 : deriv f z / f z = deriv H z / (ψ z * g z) := by
      rw [hderiv, hfz1]
    have hPval : deriv H z = deriv ψ z * g z + ψ z * deriv g z := by
      have h1d : HasDerivAt H (deriv ψ z * g z + ψ z * deriv g z) z := by
        rw [hH]
        have hψd' : HasDerivAt ψ (deriv ψ z) z := hψA.differentiableAt.hasDerivAt
        have hgd' : HasDerivAt g (deriv g z) z := hgA.differentiableAt.hasDerivAt
        exact hψd'.mul hgd'
      have h2d : HasDerivAt H (deriv H z) z := hHnd.hasDerivAt
      exact HasDerivAt.unique h2d h1d
    have h2 : deriv H z / (ψ z * g z) = deriv ψ z / ψ z + deriv g z / g z := by
      rw [hPval]
      field_simp [hfz, hψNZ, hgz]
    have h3 : deriv ψ z / ψ z = ∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u) := by
      dsimp only [ψ]
      exact finset_prod_logDeriv (d := D) z hzu
    -- put it together:
    rw [h1, h2, h3]
  -- 3. the circle integral:
  -- every divisor point lies strictly inside the disk:
  have hFball : ∀ u ∈ hfin.toFinset, u ∈ ball c |R| := by
    intro u hu
    have huF : u ∈ F := by
      rw [Set.Finite.mem_toFinset] at hu
      exact hu
    have hf0 : f u = 0 := hFzero u huF
    have hnotS : u ∉ sphere c |R| := by
      intro huS
      exact hnozero u huS hf0
    have hle : dist u c ≤ |R| := by
      have huU : u ∈ U := hFsubsetU huF
      rw [Metric.mem_closedBall] at huU
      exact huU
    have hne : dist u c ≠ |R| := by
      intro he
      have hus : u ∈ sphere c |R| := by
        rw [Metric.mem_sphere]
        exact he
      exact hnotS hus
    rw [Metric.mem_ball]
    exact lt_of_le_of_ne hle hne
  -- the residue unit:
  have hresidue : ∀ u ∈ hfin.toFinset,
      (∮ z in C(c, |R|), (D u : ℂ) / (z - u)) =
        (2 * Real.pi * Complex.I : ℂ) * (D u : ℂ) := by
    intro u hu
    have := circleIntegral_div_sub_of_differentiable_on_off_countable
      (R := |R|) (s := (∅ : Set ℂ)) Set.countable_empty (hFball u hu)
      continuousOn_const (fun z _ => differentiableAt_const (D u : ℂ))
    simpa using this
  -- `g'/g` is continuous on the closed disk and differentiable in the open ball:
  have hS2cont : ContinuousOn (fun z => deriv g z / g z) (closedBall c |R|) := by
    have hgdcont : ContinuousOn (deriv g) (closedBall c |R|) := by
      have hder : AnalyticOnNhd ℂ (deriv g) (closedBall c |R|) :=
        fun u hu => (hgA u hu).deriv
      exact hder.continuousOn
    have hgNZset : ∀ z ∈ U, g z ≠ 0 := fun z hz => hgNZ ⟨z, hz⟩
    have hginv : ContinuousOn (fun z => (g z)⁻¹) (closedBall c |R|) :=
      hgA.continuousOn.inv₀ hgNZset
    exact hgdcont.mul hginv
  have hS2zero : (∮ z in C(c, |R|), deriv g z / g z) = 0 :=
    circleIntegral_eq_zero_of_differentiable_on_off_countable (abs_nonneg R)
      (R := |R|) (s := (∅ : Set ℂ)) Set.countable_empty hS2cont (fun z hz => by
        have hzU : z ∈ closedBall c |R| :=
          ball_subset_closedBall (Set.mem_of_mem_sdiff hz)
        have hgAz : AnalyticAt ℂ g z := hgA z hzU
        exact hgAz.deriv.differentiableAt.div hgAz.differentiableAt
          (hgNZ ⟨z, hzU⟩))
  -- integrability of the summands:
  have hS1cont : ContinuousOn (fun z => ∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u))
      (sphere c |R|) := by
    have hterm : ∀ u ∈ hfin.toFinset,
        ContinuousOn (fun z => (D u : ℂ) / (z - u)) (sphere c |R|) := by
      intro u hu
      have hznz : ∀ z ∈ sphere c |R|, z - u ≠ 0 := by
        intro z hz
        by_contra he
        have hzeq : z = u := sub_eq_zero.mp he
        have huS : u ∈ sphere c |R| := by
          rw [← hzeq]
          exact hz
        have huF : u ∈ F := by
          rw [Set.Finite.mem_toFinset] at hu
          exact hu
        have hf0 : f u = 0 := hFzero u huF
        exact hnozero u huS hf0
      have hcont : ContinuousOn (fun z => (z - u : ℂ)) (sphere c |R|) := by
        fun_prop
      have hinv : ContinuousOn (fun z => ((z - u : ℂ))⁻¹) (sphere c |R|) :=
        hcont.inv₀ hznz
      have hcst : ContinuousOn (fun z : ℂ => (D u : ℂ)) (sphere c |R|) :=
        continuousOn_const
      exact hcst.mul hinv
    have hsumCont : ∀ (F' : Finset ℂ),
        (∀ u ∈ F', ContinuousOn (fun z => (D u : ℂ) / (z - u)) (sphere c |R|)) →
        ContinuousOn (fun z => ∑ u ∈ F', (D u : ℂ) / (z - u)) (sphere c |R|) := by
      intro F' h
      induction F' using Finset.induction_on with
      | empty =>
        simpa [Finset.sum_empty] using continuousOn_const
      | insert i s his ih =>
        have hsum : (fun z => ∑ u ∈ insert i s, (D u : ℂ) / (z - u)) =
            (fun z => (D i : ℂ) / (z - i) + ∑ u ∈ s, (D u : ℂ) / (z - u)) := by
          funext z
          rw [Finset.sum_insert his]
        rw [hsum]
        exact (h i (Finset.mem_insert_self i s)).add
          (ih (fun u hu => h u (Finset.mem_insert_of_mem hu)))
    exact hsumCont hfin.toFinset hterm
  have hS1int : CircleIntegrable (fun z => ∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u))
      c |R| :=
    ContinuousOn.circleIntegrable (abs_nonneg R) hS1cont
  have hS2int : CircleIntegrable (fun z => deriv g z / g z) c |R| :=
    ContinuousOn.circleIntegrable (abs_nonneg R)
      (hS2cont.mono sphere_subset_closedBall)
  -- the `zeroCount` bridge:
  have hzc : (zeroCount c |R| f : ℂ) = ∑ u ∈ hfin.toFinset, (D u : ℂ) := by
    rw [zeroCount]
    rw [abs_of_nonneg (abs_nonneg R)]
    have hsub : support (fun u : ℂ => divisor f (closedBall c |R|) u) ⊆
        (hfin.toFinset : Set ℂ) := by
      intro u hu
      have huF : u ∈ F := by
        dsimp only [F, D]
        simpa using hu
      rw [Set.Finite.coe_toFinset]
      exact huF
    rw [finsum_eq_finsetSum_of_support_subset
      (fun u : ℂ => divisor f (closedBall c |R|) u) hsub]
    rw [Int.cast_sum]
  -- assemble:
  calc (∮ z in C(c, |R|), deriv f z / f z)
      = ∮ z in C(c, |R|),
          (∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u)) + (deriv g z / g z) := by
        rw [circleIntegral.integral_congr (R := |R|) (abs_nonneg R)
            (fun z hz => hcircle z hz)]
      _ = (∮ z in C(c, |R|), ∑ u ∈ hfin.toFinset, (D u : ℂ) / (z - u)) +
          (∮ z in C(c, |R|), deriv g z / g z) :=
        circleIntegral.integral_add hS1int hS2int
      _ = (∑ u ∈ hfin.toFinset, ∮ z in C(c, |R|), (D u : ℂ) / (z - u)) +
          (∮ z in C(c, |R|), deriv g z / g z) := by
        rw [circleIntegral.integral_fun_sum (fun u hu => by
          have hznz : ∀ z ∈ sphere c |R|, z - u ≠ 0 := by
            intro z hz
            by_contra he
            have hzeq : z = u := sub_eq_zero.mp he
            have huS : u ∈ sphere c |R| := by
              rw [← hzeq]
              exact hz
            have huF : u ∈ F := by
              rw [Set.Finite.mem_toFinset] at hu
              exact hu
            have hf0 : f u = 0 := hFzero u huF
            exact hnozero u huS hf0
          have hcont : ContinuousOn (fun z => (z - u : ℂ)) (sphere c |R|) := by
            fun_prop
          have hinv : ContinuousOn (fun z => ((z - u : ℂ))⁻¹) (sphere c |R|) :=
            hcont.inv₀ hznz
          have hcst : ContinuousOn (fun z : ℂ => (D u : ℂ)) (sphere c |R|) :=
            continuousOn_const
          exact ContinuousOn.circleIntegrable (abs_nonneg R) (hcst.mul hinv))]
      _ = (∑ u ∈ hfin.toFinset, (2 * Real.pi * Complex.I : ℂ) * (D u : ℂ)) +
          (∮ z in C(c, |R|), deriv g z / g z) := by
        rw [Finset.sum_congr rfl (fun u hu => hresidue u hu)]
      _ = (2 * Real.pi * Complex.I : ℂ) * (∑ u ∈ hfin.toFinset, (D u : ℂ)) +
          (∮ z in C(c, |R|), deriv g z / g z) := by
        rw [← Finset.mul_sum]
      _ = (2 * Real.pi * Complex.I : ℂ) * (zeroCount c |R| f : ℂ) +
          (∮ z in C(c, |R|), deriv g z / g z) := by
        rw [hzc]
      _ = (2 * Real.pi * Complex.I : ℂ) * (zeroCount c |R| f : ℂ) := by
        rw [hS2zero]
        simp

end argumentPrinciple
