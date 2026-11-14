/-
**D1E - Danesh pole-obstruction criterion (packaging unit).**
NO RH CLAIM.

This unit packages the D1C / D1C-2 / D1D engines into the named
pole-obstruction criterion that the terminal-face program consumes:

1. `zeroSetLaplaceWeighted` - the finite zero-set Laplace identity with
   arbitrary complex weights (D1D.zeroSetLaplace is the unweighted case):
   the half-line Laplace integral of a weighted zero sum equals the
   weighted zero-sum meromorphic object term by term.
2. `zeroSumMeromorphic` + `poleLocusIff` - the meromorphic finite sum
   obtained from a finite zero set is continuous exactly off the negated
   zero set; at a negated zero it blows up quantitatively and is
   therefore not continuous there.
3. `poleObstructionCriterion` - the packaged statement: a pole fire at
   height `-rho` (for a zero `rho` of the finite zero set) lands exactly
   on the singular locus of the in-tree meromorphic object.
4. `gap_infiniteLifting_convergence` - the NAMED gap (no claim): the
   lift of the finite identity to an infinite zero set requires exactly
   the absolute summability of the weighted meromorphic sum, the input
   the terminal face leaves open.
-/

import Mathlib
import RhAttack.D1C
import RhAttack.D1D

open MeasureTheory Set
open scoped BigOperators

namespace D1E

/-! ## The meromorphic finite sum -/

/-- One term of the zero-sum meromorphic object at cutoff `c`,
    evaluated at the point `u`: `e^{-(u + rho) c} / (u + rho)`. -/
noncomputable def meromorphicTerm (c : ℝ) (u : ℂ) (ρ : ℂ) : ℂ :=
    Complex.exp (-((u + ρ) * (c : ℂ))) / (u + ρ)

/-- The zero-sum meromorphic object attached to a finite zero set `zs`
    and cutoff `c`, evaluated at `u`: the right-hand side of D1D's
    link (b) equality. -/
noncomputable def zeroSumMeromorphic (zs : Finset ℂ) (c : ℝ) (u : ℂ) : ℂ :=
    ∑ ρ ∈ zs, meromorphicTerm c u ρ

/-! ## Weighted link (b) -/

/-- LINK (b), weighted version of D1D.zeroSetLaplace: arbitrary complex
    weights `w rho`. The half-line Laplace integral of the weighted
    zero-sum oscillation equals the weighted meromorphic finite sum,
    term by term, under admissibility `0 < (s + rho).re`.
    NO RH CLAIM: finite zero set, certified data only. -/
theorem zeroSetLaplaceWeighted (zs : Finset ℂ) (w : ℂ → ℂ) (s : ℂ) (c : ℝ)
    (hs : ∀ (ρ : ℂ) (hr : ρ ∈ zs), 0 < (s + ρ).re) :
    (∫ (t : ℝ) in Ioi c, (∑ ρ ∈ zs, w ρ * D1D.zeroMode ρ t) * Complex.exp (-(s * (t : ℂ)))) =
    ∑ ρ ∈ zs, w ρ * (meromorphicTerm c s ρ) := by
  -- (i) the weighted exponential distributes into the summand
  have hfun2 : (fun t : ℝ => (∑ ρ ∈ zs, w ρ * D1D.zeroMode ρ t) * Complex.exp (-(s * (t : ℂ)))) =
      (fun t : ℝ => ∑ ρ ∈ zs, w ρ * (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) := by
    funext t
    rw [Finset.sum_mul]
    refine Finset.sum_congr rfl fun ρ _ => ?_
    rw [mul_assoc]
  -- (ii) integrability of each weighted term
  have himp (ρ : ℂ) (hr : ρ ∈ zs) : IntegrableOn
      (fun t : ℝ => w ρ * (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) (Ioi c) := by
    have hk : IntegrableOn (fun t : ℝ => Complex.exp (-((s + ρ) * (t : ℂ)))) (Ioi c) :=
      D1C.laplaceKernelIntegrable (s + ρ) (hs ρ hr) c
    have hpt : EqOn (fun t : ℝ => Complex.exp (-((s + ρ) * (t : ℂ))))
        (fun t : ℝ => D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) (Ioi c) := by
      intro t _
      show Complex.exp (-((s + ρ) * (t : ℂ))) =
          D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))
      unfold D1D.zeroMode
      have heq : -((s + ρ) * (t : ℂ)) = -(ρ * (t : ℂ)) + (-(s * (t : ℂ))) := by ring
      rw [heq, Complex.exp_add]
    have hwmk : IntegrableOn
        (fun t : ℝ => D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ)))) (Ioi c) :=
      IntegrableOn.congr_fun hk hpt (by continuity)
    exact Integrable.const_mul hwmk (w ρ)
  -- (iii) move the weighted exponential inside; pull the finite sum out
  conv_lhs => rw [hfun2]
  rw [integral_finsetSum zs (fun ρ hr => himp ρ hr)]
  -- (iv) term by term: pull the weight out, apply D1D's one-mode identity
  refine Finset.sum_congr rfl fun ρ hr => ?_
  have hwmul : (∫ (t : ℝ) in Ioi c, w ρ * (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) =
      w ρ • (∫ (t : ℝ), (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))
      ∂ (volume.restrict (Ioi c))) := by
    have hm2s : (fun t : ℝ => w ρ * (D1D.zeroMode ρ t *
        Complex.exp (-(s * (t : ℂ))))) =
        (fun t : ℝ => (w ρ) • (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) := by
      funext t
      rfl
    rw [hm2s]
    rw [integral_smul (w ρ) (fun t : ℝ => D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))]
  have hlapeq : (∫ (t : ℝ) in Ioi c, (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) =
      D1D.zeroModeLaplaceInt ρ s c := by
    dsimp only [D1D.zeroModeLaplaceInt]
  calc
    (∫ (t : ℝ) in Ioi c, w ρ * (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))) =
        w ρ • (∫ (t : ℝ), (D1D.zeroMode ρ t * Complex.exp (-(s * (t : ℂ))))
          ∂ (volume.restrict (Ioi c))) := hwmul
    _ = w ρ • D1D.zeroModeLaplaceInt ρ s c := by
      rw [← hlapeq]
    _ = w ρ • (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
      rw [D1D.zeroModeLaplaceInt_eq ρ s (hs ρ hr) c]
    _ = w ρ * (meromorphicTerm c s ρ) := by
      have hsm : (w ρ) • (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) =
          (w ρ) * (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := rfl
      rw [hsm]
      dsimp only [meromorphicTerm]

/-! ## Continuity away from the poles -/

/-- One term of the meromorphic finite sum is continuous away from `-rho`. -/
theorem meromorphicTermContinuous (ρ : ℂ) (c : ℝ) (u₀ : ℂ) (h : u₀ + ρ ≠ 0) :
    ContinuousAt (fun u : ℂ => meromorphicTerm c u ρ) u₀ := by
  have hlin : ContinuousAt (fun u : ℂ => (u + ρ) * (c : ℂ)) u₀ :=
    (ContinuousAt.add continuousAt_id (continuous_const |>.continuousAt)).mul
      (continuous_const |>.continuousAt)
  have hneg : ContinuousAt (fun u : ℂ => -((u + ρ) * (c : ℂ))) u₀ :=
    (Continuous.continuousAt continuous_neg).comp hlin
  have hexp : ContinuousAt (fun u : ℂ => Complex.exp (-((u + ρ) * (c : ℂ)))) u₀ :=
    (Continuous.continuousAt Complex.continuous_exp).comp hneg
  have hlin2 : ContinuousAt (fun u : ℂ => u + ρ) u₀ :=
    ContinuousAt.add continuousAt_id (continuous_const |>.continuousAt)
  show ContinuousAt (fun u : ℂ => Complex.exp (-((u + ρ) * (c : ℂ))) / (u + ρ)) u₀
  exact ContinuousAt.div hexp hlin2 h

/-- The meromorphic finite sum is continuous at every point that is not
    a negated zero of the finite zero set. -/
theorem finiteSumContinuousOffPoles (zs : Finset ℂ) (c : ℝ) (u₀ : ℂ)
    (h : ∀ (ρ : ℂ) (hr : ρ ∈ zs), u₀ + ρ ≠ 0) :
    ContinuousAt (zeroSumMeromorphic zs c) u₀ := by
  classical
  show ContinuousAt (fun u : ℂ => ∑ ρ ∈ zs, meromorphicTerm c u ρ) u₀
  induction zs using Finset.induction with
  | empty =>
    change ContinuousAt (fun _ : ℂ => (0 : ℂ)) u₀
    exact (continuous_const : Continuous (fun _ : ℂ => (0 : ℂ))).continuousAt
  | insert ρ s hρ ih =>
    have hρne := h ρ (Finset.mem_insert_self ρ s)
    simp only [Finset.sum_insert hρ]
    have ih' : ContinuousAt (fun u : ℂ => ∑ ρ' ∈ s, meromorphicTerm c u ρ') u₀ :=
      ih (by
        intro ρ' hr'
        exact h ρ' (Finset.mem_insert_of_mem hr'))
    exact ContinuousAt.add (meromorphicTermContinuous ρ c u₀ hρne) ih'

/-! ## Blow-up at the negated zeros (quantitative) -/

theorem finiteSumBlewUpAtPole (zs : Finset ℂ) (c : ℝ) (u₀ : ℂ)
    (hρ : ∃ (ρ : ℂ) (hr : ρ ∈ zs), u₀ = -ρ) :
    ∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s - u₀‖ → ‖s - u₀‖ < δ →
        M < ‖zeroSumMeromorphic zs c s‖ := by
  classical
  obtain ⟨ρ₀, hr₀, hu₀⟩ := hρ
  -- split the zero set at the pole
  set zf := Finset.filter (fun ρ : ℂ => u₀ + ρ = 0) zs with hzf
  set zc := Finset.filter (fun ρ : ℂ => u₀ + ρ ≠ 0) zs with hzc
  -- the pole block has at least one member (rho_0 itself)
  have hN : 1 ≤ zf.card := by
    have hin : ρ₀ ∈ zf := Finset.mem_filter.mpr ⟨hr₀, by rw [hu₀]; ring⟩
    by_contra hbad
    have hz : zf.card < 1 := by linarith
    have h0 : zf.card = 0 := by omega
    have hempty : zf = ∅ := (Finset.card_eq_zero).mp h0
    have hmemempty : ρ₀ ∈ (∅ : Finset ℂ) := by simpa [hempty] using hin
    have hcontra : ρ₀ ∉ (∅ : Finset ℂ) := by simp
    exact hcontra hmemempty
  -- T := the off-pole part
  set T : ℂ → ℂ := zeroSumMeromorphic zc c with hTdef
  have hTcont : ContinuousAt T u₀ :=
    finiteSumContinuousOffPoles zc c u₀ (by
      intro ρ hr
      exact (Finset.mem_filter.mp hr).2)
  -- T is locally bounded near u0
  have hTbound : ∃ δT > (0 : ℝ), ∀ (s : ℂ), ‖s - u₀‖ < δT → ‖T s‖ ≤ ‖T u₀‖ + 1 := by
    rcases Metric.continuousAt_iff.mp hTcont 1 (by norm_num) with ⟨δT, hδT, hTb⟩
    have h : ∀ (s : ℂ), ‖s - u₀‖ < δT → ‖T s‖ ≤ ‖T u₀‖ + 1 := by
      intro s hs
      have h1 : ‖T s - T u₀‖ < 1 := by
        rw [← dist_eq_norm (T s) (T u₀)]
        have hsd : dist s u₀ < δT := by
          rw [dist_eq_norm s u₀]
          exact hs
        exact hTb hsd
      have h2 : ‖T s‖ ≤ ‖T s - T u₀‖ + ‖T u₀‖ := by
        calc
          ‖T s‖ = ‖(T s - T u₀) + T u₀‖ := by
            have : (T s - T u₀) + T u₀ = T s := by ring
            rw [this]
          _ ≤ ‖T s - T u₀‖ + ‖T u₀‖ := norm_add_le _ _
      linarith
    exact ⟨δT, hδT, h⟩
  -- decomposition: F(s) = (card zf) * e^{-((s-u0)c)} / (s - u0) + T(s)
  have hdecomp (s : ℂ) : zeroSumMeromorphic zs c s =
      (zf.card : ℂ) * (Complex.exp (-((s - u₀) * (c : ℂ))) / (s - u₀)) + T s := by
    dsimp only [zeroSumMeromorphic, meromorphicTerm]
    set mtPole : ℂ := Complex.exp (-((s - u₀) * (c : ℂ))) / (s - u₀) with hmtPole
    have haddpt (ρ : ℂ) : (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) =
        (if u₀ + ρ = 0 then mtPole else 0) + (if u₀ + ρ = 0 then 0 else
            Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
      dsimp only [mtPole]
      split_ifs with hP1
      · have hr' : ρ = -u₀ := eq_neg_of_add_eq_zero_right hP1
        have hsρ : s + ρ = s - u₀ := by rw [hr']; ring
        rw [hsρ]
        simp
      · simp
    have hsum : (∑ ρ ∈ zs, (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) =
        (∑ ρ ∈ zs, (if u₀ + ρ = 0 then mtPole else 0)) +
        (∑ ρ ∈ zs, (if u₀ + ρ = 0 then 0 else Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) := by
      have hpt : (∑ ρ ∈ zs, (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) =
          ∑ ρ ∈ zs, ((if u₀ + ρ = 0 then mtPole else 0) +
              (if u₀ + ρ = 0 then 0 else Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) := by
        refine Finset.sum_congr rfl fun ρ _ => haddpt ρ
      rw [hpt, Finset.sum_add_distrib]
    rw [hsum]
    -- the pole block
    let poleP : ℂ → Prop := fun ρ : ℂ => u₀ + ρ = 0
    have hpole : (∑ ρ ∈ zs, (if u₀ + ρ = 0 then mtPole else 0)) =
        (zf.card : ℂ) * mtPole := by
      have hb1 : (∑ ρ ∈ zs, (if u₀ + ρ = 0 then mtPole else 0)) =
          (∑ ρ ∈ zs with poleP ρ, (mtPole : ℂ)) := by
        rw [← Finset.sum_filter poleP (fun _ : ℂ => (mtPole : ℂ))]
      have hb2 : (∑ ρ ∈ zs with poleP ρ, (mtPole : ℂ)) =
          (∑ ρ ∈ zf, (mtPole : ℂ)) := by
        dsimp only [zf, poleP]
      have hconst : (∑ ρ ∈ zf, (mtPole : ℂ)) = (zf.card : ℂ) * mtPole := by
        rw [Finset.sum_const mtPole]
        ring
      rw [hb1, hb2, hconst]
    rw [hpole]
    -- the off-pole block
    let offP : ℂ → Prop := fun ρ : ℂ => u₀ + ρ ≠ 0
    have hoffs : (∑ ρ ∈ zs, (if u₀ + ρ = 0 then 0 else
        Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) =
        (∑ ρ ∈ zc, Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
      have hif : (fun ρ : ℂ => if u₀ + ρ = 0 then 0 else
          (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) =
          (fun ρ : ℂ => if offP ρ then (Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) else 0) := by
        funext ρ
        by_cases h0 : u₀ + ρ = 0
        · rw [if_pos h0, if_neg (fun hne => hne h0)]
        · rw [if_neg h0, if_pos h0]
      have hfs : (∑ ρ ∈ zs, (if offP ρ then
          Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ) else 0)) =
          (∑ ρ ∈ zc, Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
        have hb1 : (∑ ρ ∈ zs, (if offP ρ then
            Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ) else 0)) =
            (∑ ρ ∈ zs with offP ρ,
              Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
          rw [← Finset.sum_filter offP (fun ρ : ℂ =>
            Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))]
        have hb2 : (∑ ρ ∈ zs with offP ρ,
            Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) =
            (∑ ρ ∈ zc, Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
          dsimp only [zc, offP]
        rw [hb1, hb2]
      calc
        (∑ ρ ∈ zs, (if u₀ + ρ = 0 then 0 else
            Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ))) =
            ∑ ρ ∈ zs, (if offP ρ then
              Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ) else 0) := by
          refine Finset.sum_congr rfl ?_
          intro ρ _
          exact congr_fun hif ρ
        _ = (∑ ρ ∈ zc, Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)) := by
          rw [hfs]
    rw [hoffs]
    dsimp only [T, zeroSumMeromorphic, meromorphicTerm, mtPole]

  intro M
  by_cases hM : 0 ≤ M
  · -- M >= 0: the estimate
    obtain ⟨δT, hδT, hTbnd⟩ := hTbound
    set R : ℝ := M + ‖T u₀‖ + 1 with hRdef
    have hR : 0 < R := by
      dsimp only [R]
      linarith [hM, norm_nonneg (T u₀)]
    set A : ℝ := (zf.card : ℝ) * Real.exp (-(abs c)) with hAdef
    have hA : 0 < A := by
      dsimp only [A]
      have hNpos : 0 < (zf.card : ℝ) := by
        exact_mod_cast Nat.pos_of_ne_zero (show zf.card ≠ 0 from by
          intro hz
          linarith [hN])
      exact mul_pos hNpos (Real.exp_pos (-(abs c)))
    set δ := min (min δT 1) (A / R) with hδdef
    have hδ : 0 < δ := by
      dsimp only [δ]
      exact lt_min (lt_min hδT (by norm_num)) (div_pos hA hR)
    refine ⟨δ, hδ, ?_⟩
    intro s hpos hclose
    dsimp only [δ] at hclose
    have hTclose : ‖s - u₀‖ < δT := by
      calc
        ‖s - u₀‖ < min (min δT 1) (A / R) := hclose
        _ ≤ min δT 1 := min_le_left (min δT 1) (A / R)
        _ ≤ δT := min_le_left δT 1
    have h1 : ‖s - u₀‖ < 1 := by
      calc
        ‖s - u₀‖ < min (min δT 1) (A / R) := hclose
        _ ≤ min δT 1 := min_le_left (min δT 1) (A / R)
        _ ≤ 1 := min_le_right δT 1
    have hdiv : ‖s - u₀‖ < A / R := by
      calc
        ‖s - u₀‖ < min (min δT 1) (A / R) := hclose
        _ ≤ A / R := min_le_right (min δT 1) (A / R)
    set mainA : ℂ := (zf.card : ℂ) * (Complex.exp (-((s - u₀) * (c : ℂ))) / (s - u₀))
      with hmainAdef
    -- |mainA| >= A / |s - u0|
    have hmain : ‖mainA‖ ≥ A / ‖s - u₀‖ := by
      have hexp : ‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ =
          Real.exp (-((s - u₀) * (c : ℂ)).re) := by
        rw [Complex.norm_exp]
        simp only [Complex.neg_re]
      have hre : ((s - u₀) * (c : ℂ)).re ≤ (abs c) * ‖s - u₀‖ := by
        have h1' : ((s - u₀) * (c : ℂ)).re = (s - u₀).re * c := by
          simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
          ring
        rw [h1']
        calc
          (s - u₀).re * c ≤ abs ((s - u₀).re * c) := le_abs_self _
          _ = abs ((s - u₀).re) * abs c := by rw [abs_mul]
          _ ≤ ‖s - u₀‖ * abs c := mul_le_mul_of_nonneg_right
              (Complex.abs_re_le_norm (s - u₀)) (abs_nonneg c)
          _ = abs c * ‖s - u₀‖ := by rw [mul_comm]
      have hx : (s - u₀).re * c ≤ (abs c) * ‖s - u₀‖ := by
        rw [show (s - u₀).re * c = ((s - u₀) * (c : ℂ)).re from by
          simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
          ring]
        exact hre
      have hstep1 : Real.exp (-(abs c) * ‖s - u₀‖) ≤
          Real.exp (-((s - u₀) * (c : ℂ)).re) := by
        rw [show -((s - u₀) * (c : ℂ)).re = -((s - u₀).re * c) from by
          simp only [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
          ring]
        have hneg : (-(abs c) : ℝ) * ‖s - u₀‖ = -((abs c) * ‖s - u₀‖) := by ring
        rw [hneg]
        exact Real.exp_le_exp.mpr (neg_le_neg hx)
      have hstep2 : Real.exp (-(abs c)) ≤ Real.exp (-(abs c) * ‖s - u₀‖) := by
        have hmul : (abs c) * ‖s - u₀‖ ≤ (abs c) := by
          simpa [mul_one] using mul_le_mul_of_nonneg_left (le_of_lt h1) (abs_nonneg c)
        have hneg : (-(abs c) : ℝ) * ‖s - u₀‖ = -((abs c) * ‖s - u₀‖) := by ring
        rw [hneg]
        exact Real.exp_le_exp.mpr (neg_le_neg hmul)
      have hexpl : Real.exp (-(abs c)) ≤ ‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ := by
        rw [hexp]
        exact le_trans hstep2 hstep1
      have hus : s - u₀ ≠ 0 := by
        intro hz
        have hzero : ‖s - u₀‖ = 0 := by simpa [hz] using eq_comm
        linarith [hpos, hzero]
      dsimp only [mainA]
      have hcard : ‖(zf.card : ℂ)‖ = (zf.card : ℝ) := by
        simp only [norm_natCast]
      calc
        ‖(zf.card : ℂ) * (Complex.exp (-((s - u₀) * (c : ℂ))) / (s - u₀))‖ =
            ‖(zf.card : ℂ)‖ * ‖Complex.exp (-((s - u₀) * (c : ℂ))) / (s - u₀)‖ := by
          rw [norm_mul]
        _ = (zf.card : ℝ) * (‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ / ‖s - u₀‖) := by
          rw [hcard, norm_div]
        _ = (zf.card : ℝ) * ‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ / ‖s - u₀‖ := by ring
        _ ≥ (zf.card : ℝ) * Real.exp (-(abs c)) / ‖s - u₀‖ := by
          have hcardpos : 0 ≤ (zf.card : ℝ) := by
            exact_mod_cast Nat.zero_le (zf.card)
          have hmul2 : (zf.card : ℝ) * Real.exp (-(abs c)) ≤
              (zf.card : ℝ) * ‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ :=
            mul_le_mul_of_nonneg_left hexpl hcardpos
          have hdiv2 : (zf.card : ℝ) * Real.exp (-(abs c)) / ‖s - u₀‖ ≤
              (zf.card : ℝ) * ‖Complex.exp (-((s - u₀) * (c : ℂ)))‖ / ‖s - u₀‖ :=
            mul_le_mul_of_nonneg_right hmul2 (le_of_lt (inv_pos.mpr hpos))
          linarith [hdiv2]
    -- the final chain
    have hTb : ‖T s‖ ≤ ‖T u₀‖ + 1 := hTbnd s hTclose
    have hrev : ‖mainA + T s‖ ≥ ‖mainA‖ - ‖T s‖ := by
      have h1 : ‖mainA‖ = ‖(mainA + T s) + -(T s)‖ := by
        congr 1
        ring
      rw [h1]
      have h2 : ‖(mainA + T s) + -(T s)‖ ≤ ‖mainA + T s‖ + ‖-(T s)‖ :=
        norm_add_le (mainA + T s) (-(T s))
      have h3 : ‖-(T s)‖ = ‖T s‖ := by simp only [norm_neg]
      have h4 : ‖mainA‖ ≤ ‖mainA + T s‖ + ‖T s‖ := by linarith [h2, h3]
      linarith [h4]
    have hRclose : (M + ‖T u₀‖ + 1) * ‖s - u₀‖ < A := by
      calc
        (M + ‖T u₀‖ + 1) * ‖s - u₀‖ ≤ R * ‖s - u₀‖ := by
          dsimp only [R]
          exact mul_le_mul_of_nonneg_right le_rfl (norm_nonneg (s - u₀))
        _ < R * (A / R) := by
          exact mul_lt_mul_of_pos_left hdiv hR
        _ = A := by field_simp [hR.ne']
    have hfinal : M < A / ‖s - u₀‖ - (‖T u₀‖ + 1) := by
      have hlt : M + ‖T u₀‖ + 1 < A / ‖s - u₀‖ := by
        calc
          M + ‖T u₀‖ + 1 =
              (M + ‖T u₀‖ + 1) * ‖s - u₀‖ * ‖s - u₀‖⁻¹ := by
            field_simp [hpos.ne']
          _ < A * ‖s - u₀‖⁻¹ :=
            mul_lt_mul_of_pos_right hRclose (inv_pos.mpr hpos)
          _ = A / ‖s - u₀‖ := by rw [← div_eq_mul_inv A ‖s - u₀‖]
      linarith [hlt]
    calc
      M < A / ‖s - u₀‖ - (‖T u₀‖ + 1) := hfinal
      _ ≤ A / ‖s - u₀‖ - ‖T s‖ := by
        have hsub : A / ‖s - u₀‖ - (‖T u₀‖ + 1) ≤ A / ‖s - u₀‖ - ‖T s‖ :=
          sub_le_sub_left hTb (A / ‖s - u₀‖)
        linarith [hsub]
      _ ≤ ‖mainA + T s‖ := by
        linarith [hmain, hrev]
      _ = ‖zeroSumMeromorphic zs c s‖ := by
        rw [hdecomp s]
  · -- M < 0: trivial
    refine ⟨1, by norm_num, ?_⟩
    intro s hpos hclose
    have hMneg : M < 0 := by linarith
    linarith [hMneg, norm_nonneg (zeroSumMeromorphic zs c s)]

/-- A quantity that blows up at a point cannot be continuous there. -/
theorem finiteSumNotContinuousAtPole (zs : Finset ℂ) (c : ℝ) (u₀ : ℂ)
    (hρ : ∃ (ρ : ℂ) (hr : ρ ∈ zs), u₀ = -ρ) :
    ¬ContinuousAt (zeroSumMeromorphic zs c) u₀ := by
  intro hcont
  set F : ℂ → ℂ := zeroSumMeromorphic zs c with hFdef
  have hblow : ∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s - u₀‖ → ‖s - u₀‖ < δ →
      M < ‖F s‖ := finiteSumBlewUpAtPole zs c u₀ hρ
  have hM' : ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s - u₀‖ → ‖s - u₀‖ < δ →
      ‖F u₀‖ + 2 < ‖F s‖ := hblow (‖F u₀‖ + 2)
  rcases hM' with ⟨δ, hδ, hblow'⟩
  rcases Metric.continuousAt_iff.mp hcont 1 (by norm_num) with ⟨δc, hδc, hcont'⟩
  set d := min δ δc with hddef
  have hdpos : 0 < d := lt_min hδ hδc
  set ε : ℝ := d / 3 with hedef
  have hε : 0 < ε := by
    dsimp only [ε]
    exact div_pos hdpos (by norm_num)
  have hεsmall : ε < d := by
    dsimp only [ε]
    exact div_lt_self hdpos (by norm_num)
  set s1 : ℂ := u₀ + (ε : ℂ) with hs1def
  have hclose1 : ‖s1 - u₀‖ < δ := by
    dsimp only [s1, ε]
    have hsub : s1 - u₀ = ((d / 3 : ℝ) : ℂ) := by
      dsimp only [s1, ε]
      ring
    rw [hsub]
    have hnorm : ‖((d / 3 : ℝ) : ℂ)‖ = |(d / 3 : ℝ)| :=
      RCLike.norm_ofReal (d / 3 : ℝ)
    rw [hnorm]
    rw [abs_of_pos (div_pos hdpos (by norm_num : (0 : ℝ) < 3))]
    have hdle : d ≤ δ := min_le_left δ δc
    linarith [hεsmall, hdle]
  have hpos1 : 0 < ‖s1 - u₀‖ := by
    dsimp only [s1]
    have hsub : s1 - u₀ = ((d / 3 : ℝ) : ℂ) := by
      dsimp only [s1, ε]
      ring
    rw [hsub]
    have hnorm : ‖((d / 3 : ℝ) : ℂ)‖ = |(d / 3 : ℝ)| :=
      RCLike.norm_ofReal (d / 3 : ℝ)
    rw [hnorm]
    rw [abs_of_pos (div_pos hdpos (by norm_num : (0 : ℝ) < 3))]
    linarith [hdpos]
  have hclose2 : ‖s1 - u₀‖ < δc := by
    dsimp only [s1, ε]
    have hsub : s1 - u₀ = ((d / 3 : ℝ) : ℂ) := by
      dsimp only [s1, ε]
      ring
    rw [hsub]
    have hnorm : ‖((d / 3 : ℝ) : ℂ)‖ = |(d / 3 : ℝ)| :=
      RCLike.norm_ofReal (d / 3 : ℝ)
    rw [hnorm]
    rw [abs_of_pos (div_pos hdpos (by norm_num : (0 : ℝ) < 3))]
    have hdle : d ≤ δc := min_le_right δ δc
    linarith [hεsmall, hdle]
  have hblow1 : ‖F u₀‖ + 2 < ‖F s1‖ := hblow' s1 hpos1 hclose1
  have hcont1 : ‖F s1 - F u₀‖ < 1 := by
    rw [← dist_eq_norm (F s1) (F u₀)]
    have hd2 : dist s1 u₀ < δc := by
      rw [dist_eq_norm s1 u₀]
      exact hclose2
    exact hcont' hd2
  have htri : ‖F u₀‖ ≥ ‖F s1‖ - ‖F s1 - F u₀‖ := by
    have h1 : F u₀ = F s1 - (F s1 - F u₀) := by abel
    calc
      ‖F u₀‖ = ‖F s1 - (F s1 - F u₀)‖ := congrArg (fun x : ℂ => ‖x‖) h1
      _ ≥ ‖F s1‖ - ‖F s1 - F u₀‖ := by
        have h2 : ‖F s1‖ = ‖(F s1 - (F s1 - F u₀)) + (F s1 - F u₀)‖ := by
          congr 1
          abel
        rw [h2]
        linarith [norm_add_le (F s1 - (F s1 - F u₀)) (F s1 - F u₀)]
  linarith [hblow1, hcont1, htri]

/-! ## The pole locus and the packaged criterion -/

/-- The singular locus of the meromorphic finite sum is exactly the set
    of negated zeros of the finite zero set. -/
theorem poleLocusIff (zs : Finset ℂ) (c : ℝ) (u : ℂ) :
    ContinuousAt (zeroSumMeromorphic zs c) u ↔
        u ∉ {v : ℂ | ∃ (ρ : ℂ) (hr : ρ ∈ zs), v = -ρ} := by
  constructor
  · intro hcont
    by_contra hbad
    have hbad' : ∃ (ρ : ℂ) (hr : ρ ∈ zs), u = -ρ := by
      obtain ⟨ρ, hr, hv⟩ := hbad
      exact ⟨ρ, hr, by simpa using hv⟩
    exact finiteSumNotContinuousAtPole zs c u hbad' hcont
  · intro hnotpole
    exact finiteSumContinuousOffPoles zs c u (by
      intro ρ hr
      by_contra h
      have hneg : u = -ρ := eq_neg_of_add_eq_zero_right (by simpa [add_comm] using h)
      have hbad : u ∈ {v : ℂ | ∃ (ρ : ℂ) (hr : ρ ∈ zs), v = -ρ} := ⟨ρ, hr, hneg⟩
      exact absurd hbad hnotpole)

/-- DANESH POLE-OBSTRUCTION CRITERION (packaged).
    If `rho` is a member of the certified finite zero set, then the
    pole fired by the term at `s = -rho` lands exactly on the singular
    locus of the in-tree meromorphic object `zeroSumMeromorphic`:
    (i) the object is NOT continuous at `-rho`,
    (ii) it BLOWS UP at `-rho` (unboundedly, quantitatively),
    (iii) it IS continuous at every other point.
    The finite machinery therefore cannot smooth a pole fire at a
    certified zero: closing it is exactly the infinite-lifting input
    named by `gap_infiniteLifting_convergence`.
    NO RH CLAIM: a property of certified finite data. -/
theorem poleObstructionCriterion (zs : Finset ℂ) (ρ : ℂ) (c : ℝ) (hr : ρ ∈ zs) :
    (¬ContinuousAt (zeroSumMeromorphic zs c) (-ρ)) ∧
    (∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ →
        M < ‖zeroSumMeromorphic zs c s‖) ∧
    (∀ u : ℂ, (∀ (ρ' : ℂ) (hr' : ρ' ∈ zs), u ≠ -ρ') →
        ContinuousAt (zeroSumMeromorphic zs c) u) := by
  have hpole : ∃ (ρ' : ℂ) (hr' : ρ' ∈ zs), (-ρ : ℂ) = -ρ' := ⟨ρ, hr, rfl⟩
  refine ⟨?_, ?_, ?_⟩
  · exact finiteSumNotContinuousAtPole zs c (-ρ) hpole
  · refine fun M => ?_
    obtain ⟨δ, hδ, hblow⟩ := finiteSumBlewUpAtPole zs c (-ρ) hpole M
    refine ⟨δ, hδ, fun s hs hclose => ?_⟩
    have hrs : s - (-ρ) = s + ρ := by ring
    have hpos' : 0 < ‖s - (-ρ)‖ := by rw [hrs]; exact hs
    have hclose' : ‖s - (-ρ)‖ < δ := by rw [hrs]; exact hclose
    simpa using hblow s hpos' hclose'
  · intro u hgood
    exact finiteSumContinuousOffPoles zs c u (by
      intro ρ' hr'
      by_contra h
      have hbad : u = -ρ' :=
        eq_neg_of_add_eq_zero_right (by simpa [add_comm] using h)
      exact hgood ρ' hr' hbad)

/-! ## The named gap: the infinite lifting -/

/-- NAMED GAP (no claim): the exact analytic input needed to pass from
    the finite D1D/D1E identity to the infinite zero set. For an
    enumeration `f` of the infinite zero set, the weighted meromorphic
    series `∑_n w (f n) e^{-(s + f n) c} / (s + f n)` must be
    absolutely summable at every admissible point `s` (away from the
    poles), with the empty zero set as the vacuous base case. The
    finite side is fully proven in this file; this summability is the
    missing ingredient the terminal face leaves open. -/
def gap_infiniteLifting_convergence
    (zsInf : Set ℂ) (w : ℂ → ℂ) (c : ℝ) : Prop :=
    zsInf = ∅ ∨
    ∃ (f : ℕ → ℂ) (_ : ∀ n, f n ∈ zsInf)
      (h_surj : ∀ (ρ : ℂ), ρ ∈ zsInf → ∃ n, f n = ρ),
    ∀ (s : ℂ), 0 < s.re → (∀ n, s + f n ≠ 0) →
      Summable (fun n : ℕ =>
        ‖w (f n) * Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)‖)

end D1E
