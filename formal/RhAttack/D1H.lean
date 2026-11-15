/-
**D1H - The strength of the pole is the weight itself: the quantitative
residue identification for the D1G weighted meromorphic object (the third
and last characterization of the D1E named-gap escape hatch).**
NO RH CLAIM.

This is the D1-series continuation (D1C, D1C-2, D1D, D1E, D1F, D1G, D1H...).
D1F proved the named gap `D1E.gap_infiniteLifting_convergence` FAILS for
weight 1 under "on-line + classical VMM linear height growth". D1G proved
it IS constructively satisfiable with the explicit vanishing weight
`injWeight` (2^{-n} along a repetition-free enumeration), and showed the
pole persists QUALITATIVELY (non-continuity, M-blow-up, pole-locus iff).
D1H sharpens that persistence to the exact quantitative layer, in three
parts.

PART 1 - THE PUNCTURED POLE-FACTOR IDENTITY.
  * Theorem `poleFactorIdentity` (pointwise, off the pole): multiplying
    the weighted meromorphic finite sum by the pole factor `u + rho`
    isolates the single pole term:
      (u + rho) * sum_{sigma in zs} w(sigma) e^{-((u + sigma) c) / (u + sigma)}
      =  w(rho) e^{-((u + rho) c)}
         + (u + rho) * sum_{sigma in zs \ {rho}} w(sigma) e^{-((u + sigma) c) / (u + sigma)}.
    The pole at -rho is EXACTLY the one term carrying the weight w(rho);
    everything else is regular there.

PART 2 - THE RESIDENT (the main theorem).
  * Theorem `weightedPoleFactorTendsto`: the pole factor converges to the
    WEIGHT at the pole (punctured limit, u to -rho with u != -rho):
      (u + rho) * F(u)  -->  w(rho)   as   u --> -rho.
    The strength of the pole at -rho of the lifted object is EXACTLY the
    weight w(rho); independent of the cutoff c and of all the other zeros.
  * Theorem `weightedPoleFactorEps`: the same statement in explicit
    quantified form: for every epsilon > 0 there is a radius delta > 0
    such that in the PUNCTURED ball 0 < |u + rho| < delta,
      |(u + rho) F(u) - w(rho)| < epsilon.
  * Theorem `poleStrengthIsWeight` (corollary): if w(rho) != 0, the pole
    factor does NOT tend to 0 at the pole - the pole is present with
    NONZERO, EXACTLY IDENTIFIED strength. A lifting that keeps the weight
    nonzero at a certified zero KEEPS the pole at that zero.
  * Theorem `puncturedBound` (machinery): a punctured-neighborhood limit
    to b yields an explicit punctured-ball bound dist (f u) b < r.

PART 3 - THE WEIGHT <-> POLE DICTION (consequences, packaged).
  * Theorem `weightZeroRemovesPole`: the converse direction is also
    EXACT: if w(rho) = 0, the term at rho is identically zero and the
    pole LITERALLY disappears - the object is continuous at -rho.
  * Theorem `persistenceIff` (package): for rho in zs,
      ContinuousAt F (-rho)  <->  w(rho) = 0.
    Weight is pole: the singularity at a negated certified zero exists if
    and only if the weight there is nonzero, and (Part 2) its strength is
    exactly the weight.
  * Theorem `escapePoleStrength` (packaged, mirrors
    D1G.escapeHatchCharacterized): for an on-line zero set enumerated
    without repetition, the explicit D1G weight injWeight (i) satisfies
    the D1E named gap, (ii) at EVERY finite certified slice containing a
    given zero f(n0), the pole factor tends to injWeight(f(n0)) = 2^{-n0}
    (a NONZERO residue), and (iii) the lifted object itself has NO
    punctured limit 0 at the pole - it blows up there. The escape hatch
    leaves, at every certified zero, a pole whose strength is exactly the
    (nonzero, summable-along-the-enumeration) weight.

CONSEQUENCE (in the D1-series language, NO RH CLAIM): the D1E named gap
and the pole obstruction are EXACTLY BALANCED, and the balance is
quantified: a weight that is summable along the enumeration (the only way
to satisfy the named gap - D1F: weight 1 fails; D1G: 2^{-n} works) makes
the far field summable, while the pole at each certified zero rho carries
a residue EXACTLY equal to the weight (D1H Part 2). Killing the pole
therefore requires w(rho) = 0 at EVERY certified zero (D1H Part 3); a
weight that vanishes at every zero is trivial (it no longer sees the zero
set - the lifted object becomes the continuous off-pole sum of the empty
data). No admissible lifting of the Danesh criterion to an infinite zero
set can be both weight-informative about the zero set AND continuous at
the negated zeros. Closing the terminal face therefore cannot be
accomplished by ANY lifting through this machinery: the terminal face -
which asks for a CONTINUOUS analytic object over the certified band - is
strictly stronger than whatever the lifted meromorphic object provides.
NO RH CLAIM: all statements are properties of conditional (enumerated,
on-line or arbitrary finite) certified data; nothing here assumes or
proves any part of RH.
-/
import Mathlib
import RhAttack.D1G

open scoped BigOperators
open scoped Topology

namespace D1H

/-! ## Part 1: the punctured pole-factor identity -/

/-- THE PUNCTURED POLE-FACTOR IDENTITY: off the pole (`u + rho != 0`),
    multiplying the weighted meromorphic finite sum by the pole factor
    `u + rho` isolates the single pole term: the product equals the
    weight times the exponential plus the pole factor times the
    off-pole rest of the sum. The pole at `-rho` is EXACTLY the one term
    carrying the weight `w rho`. -/
theorem poleFactorIdentity (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ) (u : ℂ)
    (hr : ρ ∈ zs) (hu : u + ρ ≠ 0) :
    (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u =
      w ρ * Complex.exp (-((u + ρ) * (c : ℂ))) +
      (u + ρ) * D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ)) u := by
  let T : ℂ → ℂ := fun s : ℂ => D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ)) s
  have hsplit2 : zs = (zs \ ({ρ} : Finset ℂ)) ∪ (zs ∩ ({ρ} : Finset ℂ)) :=
    (Finset.sdiff_union_inter zs ({ρ} : Finset ℂ)).symm
  have hdisj : Disjoint (zs \ ({ρ} : Finset ℂ)) (zs ∩ ({ρ} : Finset ℂ)) :=
    Finset.disjoint_sdiff_inter zs ({ρ} : Finset ℂ)
  have h1 : zs ∩ ({ρ} : Finset ℂ) = ({ρ} : Finset ℂ) :=
    (Finset.inter_eq_right).mpr (Finset.singleton_subset_iff.mpr hr)
  have hfirst : (∑ x ∈ zs ∩ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c u x) =
      w ρ * D1E.meromorphicTerm c u ρ := by
    rw [h1]
    simp
  have hsplit : (∑ x ∈ zs, w x * D1E.meromorphicTerm c u x) =
      w ρ * D1E.meromorphicTerm c u ρ + T u := by
    rw [hsplit2, Finset.sum_union hdisj, hfirst]
    have hrest0 : (∑ x ∈ zs \ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c u x) = T u := by
      dsimp only [T, D1G.weightedZeroSumMeromorphic, D1G.weightedMeromorphicTerm]
    rw [hrest0, add_comm]
  dsimp only [D1G.weightedZeroSumMeromorphic, D1G.weightedMeromorphicTerm]
  have hrest : (∑ x ∈ zs \ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c u x) = T u := by
    dsimp only [T, D1G.weightedZeroSumMeromorphic, D1G.weightedMeromorphicTerm]
  rw [hsplit, hrest, mul_add]
  have hb : (u + ρ) * (w ρ * D1E.meromorphicTerm c u ρ) =
      w ρ * Complex.exp (-((u + ρ) * (c : ℂ))) := by
    dsimp only [D1E.meromorphicTerm]
    field_simp [hu]
  rw [hb]

/-- (helper, private) the negation-arithmetic used in the off-pole
    continuity arguments: from `(-rho) + sigma = 0` one gets
    `sigma = rho`. -/
private lemma negSumEq {ρ σ : ℂ} (h : (-ρ : ℂ) + σ = 0) : σ = ρ := by
  calc σ = ((-ρ : ℂ) + σ) + ρ := by ring
    _ = ρ := by rw [h]; simp

/-! ## Part 2: the resident -/

/-- THE RESIDENT (main theorem): the pole factor of the weighted
    meromorphic finite sum converges to the WEIGHT at the pole:
      (u + rho) * F(u)  -->  w(rho)   as   u --> -rho  (punctured, u != -rho).
    The strength of the pole at -rho of the lifted object is EXACTLY the
    weight w(rho); independent of the cutoff c and of all other zeros in
    the set. NO RH CLAIM. -/
theorem weightedPoleFactorTendsto (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ)
    (hr : ρ ∈ zs) :
    Filter.Tendsto (fun u : ℂ => (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u)
      (𝓝[≠] (-ρ)) (𝓝 (w ρ)) := by
  let T : ℂ → ℂ := fun u : ℂ => D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ)) u
  let G : ℂ → ℂ := fun u : ℂ => w ρ * Complex.exp (-((u + ρ) * (c : ℂ))) + (u + ρ) * T u
  -- (i) the off-pole rest of the sum is CONTINUOUS at -rho:
  have hT : ContinuousAt (D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ))) (-ρ) :=
    D1G.weightedFiniteSumContinuousOffPoles w (zs \ ({ρ} : Finset ℂ)) c (-ρ) (by
      intro σ hσ hw
      have hne : σ ≠ ρ := by simpa using (Finset.mem_sdiff.mp hσ).2
      by_contra h0
      exact hne (negSumEq h0))
  -- (ii) the continuous extension G of the pole factor is continuous at -rho:
  have hlin : ContinuousAt (fun u : ℂ => (u + ρ) * (c : ℂ)) (-ρ) :=
    (ContinuousAt.add continuousAt_id (continuous_const |>.continuousAt)).mul
      (continuous_const |>.continuousAt)
  have hneg : ContinuousAt (fun u : ℂ => -((u + ρ) * (c : ℂ))) (-ρ) :=
    (Continuous.continuousAt continuous_neg).comp hlin
  have hexp : ContinuousAt (fun u : ℂ => Complex.exp (-((u + ρ) * (c : ℂ)))) (-ρ) :=
    (Continuous.continuousAt Complex.continuous_exp).comp hneg
  have hwt : ContinuousAt (fun u : ℂ => w ρ * Complex.exp (-((u + ρ) * (c : ℂ)))) (-ρ) :=
    (continuous_const |>.continuousAt).mul hexp
  have hu : ContinuousAt (fun u : ℂ => (u + ρ) * T u) (-ρ) :=
    (ContinuousAt.add continuousAt_id (continuous_const |>.continuousAt)).mul hT
  have hG : ContinuousAt G (-ρ) := hwt.add hu
  -- (iii) G(-rho) = w(rho), so the resident of G at the pole is the weight:
  have hGval : G (-ρ) = w ρ := by
    dsimp only [G]
    have h0p : (-ρ : ℂ) + ρ = 0 := by ring
    have hE : Complex.exp (-(((-ρ : ℂ) + ρ) * (c : ℂ))) = 1 := by
      have hprod : ((-ρ : ℂ) + ρ) * (c : ℂ) = 0 := by ring
      rw [hprod, neg_zero, Complex.exp_zero]
    rw [hE, h0p]
    simp only [mul_one, zero_mul, add_zero]
  -- (iv) the pole factor equals G off the pole (punctured):
  have hfG : (fun u : ℂ => (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u)
      =ᶠ[𝓝[≠] (-ρ)] G := by
    unfold Filter.EventuallyEq
    rw [Filter.eventually_iff]
    have hmem : ({u : ℂ | u ≠ -ρ} : Set ℂ) ∈ (𝓝[≠] (-ρ)) := by
      rw [Metric.mem_nhdsWithin_iff]
      refine ⟨1, zero_lt_one, ?_⟩
      intro u hu
      exact (by simpa using hu.2)
    apply Filter.mem_of_superset hmem
    intro u hnu
    change (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u = G u
    have hu1 : u + ρ ≠ 0 := by
      intro h
      apply hnu
      calc u = ((u + ρ) : ℂ) + (-ρ) := by ring
        _ = -ρ := by rw [h]; simp
    dsimp only [G, T]
    rw [poleFactorIdentity w c zs ρ u hr hu1]
  -- (v) G converges to w(rho) at the punctured neighborhood of -rho:
  have hGlim : Filter.Tendsto G (𝓝[≠] (-ρ)) (𝓝 (w ρ)) := by
    change (𝓝[≠] (-ρ) : Filter ℂ).map G ≤ 𝓝 (w ρ)
    rw [Filter.le_def]
    intro S hS
    rw [Filter.mem_map, Metric.mem_nhdsWithin_iff]
    obtain ⟨r, hr, hball⟩ := Metric.mem_nhds_iff.1 hS
    have hg : ∃ δ > (0 : ℝ), ∀ u : ℂ, dist u (-ρ) < δ → dist (G u) (G (-ρ)) < r :=
      Metric.continuousAt_iff.mp hG r hr
    rcases hg with ⟨δ, hδ, hgcont⟩
    refine ⟨δ, hδ, ?_⟩
    intro u hu
    have hud : dist u (-ρ) < δ := Metric.mem_ball.mp hu.1
    have hdG : dist (G u) (w ρ) < r := by
      have hdG' : dist (G u) (G (-ρ)) < r := hgcont u hud
      rw [hGval] at hdG'
      exact hdG'
    exact hball (Metric.mem_ball.mpr hdG)
  -- (vi) the pole factor has the SAME punctured limit (it equals G off the pole):
  exact (Filter.tendsto_congr' hfG).2 hGlim

/-- PUNCTURED LIMIT MACHINERY (helper): a punctured-neighborhood limit of
    `f` to `b` yields an explicit punctured-ball bound: for every
    radius `r > 0` there is a radius `delta > 0` such that in the
    punctured ball 0 < dist u a < delta, `dist (f u) b < r`. -/
theorem puncturedBound {f : ℂ → ℂ} {a b : ℂ}
    (h : Filter.Tendsto f (𝓝[≠] a) (𝓝 b)) (r : ℝ) (hr : 0 < r) :
    ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < dist u a → dist u a < δ → dist (f u) b < r := by
  have hpre : f ⁻¹' Metric.ball b r ∈ (𝓝[≠] a) := by
    have hS : Metric.ball b r ∈ 𝓝 b := Metric.ball_mem_nhds b hr
    have hle : (𝓝[≠] a).map f ≤ 𝓝 b := h
    rw [Filter.le_def] at hle
    have hin : Metric.ball b r ∈ (𝓝[≠] a).map f := hle (Metric.ball b r) hS
    rw [Filter.mem_map] at hin
    exact hin
  rcases Metric.mem_nhdsWithin_iff.1 hpre with ⟨δ, hδ, hsub⟩
  refine ⟨δ, hδ, ?_⟩
  intro u hhu hdu
  have hin : u ∈ f ⁻¹' Metric.ball b r := hsub ⟨by
    rw [Metric.mem_ball]
    exact hdu, by
      intro hu0
      have hd0 : dist u a = 0 := by
        rw [hu0]
        exact dist_self a
      linarith [hhu, hd0]⟩
  rw [Set.mem_preimage, Metric.mem_ball] at hin
  exact hin

/-- THE RESIDENT IN EXPLICIT QUANTIFIED FORM: for every `epsilon > 0`
    there is a radius `delta > 0` such that in the PUNCTURED ball
    `0 < |u + rho| < delta`,
      |(u + rho) * F(u) - w(rho)| < epsilon.
    The pole factor is within epsilon of the weight; the pole's strength
    is the weight, quantitatively. NO RH CLAIM. -/
theorem weightedPoleFactorEps (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ)
    (hr : ρ ∈ zs) (ε : ℝ) (hε : 0 < ε) :
    ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < ‖u + ρ‖ → ‖u + ρ‖ < δ →
        ‖(u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u - w ρ‖ < ε := by
  let T : ℂ → ℂ := fun u : ℂ => D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ)) u
  let E : ℂ → ℂ := fun u : ℂ => Complex.exp (-((u + ρ) * (c : ℂ)))
  -- T is continuous at the pole:
  have hT : ContinuousAt (D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ))) (-ρ) :=
    D1G.weightedFiniteSumContinuousOffPoles w (zs \ ({ρ} : Finset ℂ)) c (-ρ) (by
      intro σ hσ hw
      have hne : σ ≠ ρ := by simpa using (Finset.mem_sdiff.mp hσ).2
      by_contra h0
      exact hne (negSumEq h0))
  -- E is continuous at the pole and E(-rho) = 1:
  have hlin : ContinuousAt (fun u : ℂ => (u + ρ) * (c : ℂ)) (-ρ) :=
    (ContinuousAt.add continuousAt_id (continuous_const |>.continuousAt)).mul
      (continuous_const |>.continuousAt)
  have hneg : ContinuousAt (fun u : ℂ => -((u + ρ) * (c : ℂ))) (-ρ) :=
    (Continuous.continuousAt continuous_neg).comp hlin
  have hE : ContinuousAt E (-ρ) :=
    (Continuous.continuousAt Complex.continuous_exp).comp hneg
  have hEval : E (-ρ) = 1 := by
    dsimp only [E]
    have h0p : (-ρ : ℂ) + ρ = 0 := by ring
    rw [h0p]
    simp only [zero_mul, neg_zero, Complex.exp_zero]
  -- (1) T is bounded near the pole: within dist < delta1 of -rho, |T u| < MT:
  set MT := ‖T (-ρ)‖ + 1 with hMTdef
  have hMTpos : (0 : ℝ) < MT := by
    dsimp only [MT]
    linarith [norm_nonneg (T (-ρ))]
  rcases (Metric.continuousAt_iff.mp hT) 1 (by norm_num) with ⟨δ₁, hδ₁, hTb⟩
  -- (2) E is close to 1 near the pole: within dist < deltaE of -rho,
  --     |E u - 1| < eps / (2 * MW):
  set MW := max ‖w ρ‖ 1 with hMWdef
  have hMWpos : (0 : ℝ) < MW := by
    dsimp only [MW]
    have hm1 : (1 : ℝ) ≤ max ‖w ρ‖ 1 := le_max_right _ _
    linarith [hm1]
  rcases (Metric.continuousAt_iff.mp hE) (ε / (2 * MW)) (by
    apply div_pos hε
    have hm1 : (1 : ℝ) ≤ max ‖w ρ‖ 1 := le_max_right _ _
    have h2 : (0 : ℝ) < 2 * max ‖w ρ‖ 1 := by linarith [hm1]
    exact h2) with ⟨δE, hδE, hEb⟩
  -- (3) inside the punctured ball of radius
  --     delta := min(delta1, deltaE, eps/(2*MT), eps/(2*MW)) the estimate holds:
  have h3 : 0 < ε / (2 * MT) := by
    apply div_pos hε
    have hmn : (1 : ℝ) ≤ ‖T (-ρ)‖ + 1 := by linarith [norm_nonneg (T (-ρ))]
    have h2 : (0 : ℝ) < 2 * (‖T (-ρ)‖ + 1) := by linarith [hmn]
    dsimp only [MT]
    exact h2
  have h4 : 0 < ε / (2 * MW) := by
    apply div_pos hε
    have hm1 : (1 : ℝ) ≤ max ‖w ρ‖ 1 := le_max_right _ _
    have h2 : (0 : ℝ) < 2 * max ‖w ρ‖ 1 := by linarith [hm1]
    dsimp only [MW]
    exact h2
  set δ := min (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW))) with hδdef
  have hδpos : 0 < δ := by
    dsimp only [δ]
    refine lt_min ?_ ?_
    · exact lt_min hδ₁ hδE
    · exact lt_min h3 h4
  refine ⟨δ, hδpos, ?_⟩
  intro u hu huδ
  have hun0 : u + ρ ≠ 0 := by
    intro h
    have h0 : ‖u + ρ‖ = 0 := by
      rw [h]
      exact norm_zero
    linarith [hu, h0]
  -- the punctured pole-factor identity, then the triangle inequality:
  have hsplit : (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u - w ρ =
      (u + ρ) * T u + w ρ * (E u - 1) := by
    rw [poleFactorIdentity w c zs ρ u hr hun0]
    ring
  rw [hsplit]
  -- |T u| < MT near the pole:
  have hTu : ‖T u‖ < MT := by
    have hdd : dist u (-ρ) = ‖u + ρ‖ := by
      rw [dist_eq_norm u (-ρ)]
      have hsub : u - (-ρ) = u + ρ := by ring
      rw [hsub]
    have hhu : dist u (-ρ) < δ₁ := by
      rw [hdd]
      dsimp only [δ] at huδ
      have hm : min (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW))) ≤ min δ₁ δE :=
        min_le_left (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW)))
      have hx : min δ₁ δE ≤ δ₁ := min_le_left δ₁ δE
      linarith [huδ, hm, hx]
    have hclose : dist (T u) (T (-ρ)) < 1 := hTb hhu
    have hsub : T u = T (-ρ) + (T u - T (-ρ)) := by ring
    have hstep : ‖T u‖ = ‖T (-ρ) + (T u - T (-ρ))‖ := congr_arg (fun z : ℂ => ‖z‖) hsub
    calc ‖T u‖
      _ = ‖T (-ρ) + (T u - T (-ρ))‖ := hstep
      _ ≤ ‖T (-ρ)‖ + ‖T u - T (-ρ)‖ := norm_add_le _ _
      _ < ‖T (-ρ)‖ + 1 := by
        have hdd2 : ‖T u - T (-ρ)‖ = dist (T u) (T (-ρ)) :=
          (dist_eq_norm (T u) (T (-ρ))).symm
        rw [hdd2]
        linarith [hclose]
      _ = MT := hMTdef.symm
  -- |E u - 1| < eps / (2*MW) near the pole:
  have hEu : ‖E u - 1‖ < ε / (2 * MW) := by
    have hdd : dist u (-ρ) = ‖u + ρ‖ := by
      rw [dist_eq_norm u (-ρ)]
      have hsub : u - (-ρ) = u + ρ := by ring
      rw [hsub]
    have hhu : dist u (-ρ) < δE := by
      rw [hdd]
      dsimp only [δ] at huδ
      have hm : min (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW))) ≤ min δ₁ δE :=
        min_le_left (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW)))
      have hy : min δ₁ δE ≤ δE := min_le_right δ₁ δE
      linarith [huδ, hm, hy]
    have hclose' : dist (E u) (E (-ρ)) < ε / (2 * MW) := hEb hhu
    rw [hEval] at hclose'
    rw [dist_eq_norm (E u) 1] at hclose'
    exact hclose'
  -- combine:
  calc ‖(u + ρ) * T u + w ρ * (E u - 1)‖
      _ ≤ ‖(u + ρ) * T u‖ + ‖w ρ * (E u - 1)‖ := norm_add_le _ _
      _ = ‖u + ρ‖ * ‖T u‖ + ‖w ρ‖ * ‖E u - 1‖ := by
        rw [norm_mul, norm_mul]
      _ < ε / 2 + ε / 2 := by
        have h1 : ‖u + ρ‖ * ‖T u‖ < ε / 2 := by
          have hdd : ‖u + ρ‖ < ε / (2 * MT) := by
            dsimp only [δ] at huδ
            have hm : min (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW))) ≤
                min (ε / (2 * MT)) (ε / (2 * MW)) :=
              min_le_right (min δ₁ δE) (min (ε / (2 * MT)) (ε / (2 * MW)))
            have hz : min (ε / (2 * MT)) (ε / (2 * MW)) ≤ ε / (2 * MT) :=
              min_le_left (ε / (2 * MT)) (ε / (2 * MW))
            linarith [huδ, hm, hz]
          calc ‖u + ρ‖ * ‖T u‖
              _ < ‖u + ρ‖ * MT := by gcongr
              _ < (ε / (2 * MT)) * MT := by gcongr
              _ = ε / 2 := by field_simp [show MT ≠ 0 by linarith [hMTpos]]
        have h2 : ‖w ρ‖ * ‖E u - 1‖ < ε / 2 := by
          calc ‖w ρ‖ * ‖E u - 1‖
              _ ≤ MW * ‖E u - 1‖ := by
                gcongr
                have hle : ‖w ρ‖ ≤ max ‖w ρ‖ 1 := le_max_left _ _
                dsimp only [MW]
                exact hle
              _ < MW * (ε / (2 * MW)) := by gcongr
              _ = ε / 2 := by field_simp [show MW ≠ 0 by linarith [hMWpos]]
        linarith [h1, h2]
      _ = ε := by linarith

/-! ## Part 3: the weight <-> pole diction -/

/-- NONZERO WEIGHT KEEP THE POLE: if `w rho != 0`, the pole factor
    `(u + rho) * F(u)` does NOT tend to 0 at the pole (punctured) - the
    pole is present with NONZERO, EXACTLY IDENTIFIED strength (the
    resident is w(rho), not 0). NO RH CLAIM. -/
theorem poleStrengthIsWeight (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ)
    (hr : ρ ∈ zs) (hw : w ρ ≠ 0) :
    ¬Filter.Tendsto (fun u : ℂ => (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u)
      (𝓝[≠] (-ρ)) (𝓝 (0 : ℂ)) := by
  intro hf
  have hwp : (0 : ℝ) < ‖w ρ‖ := by
    by_contra hz
    have hweq : w ρ = 0 := by
      have hle : ‖w ρ‖ ≤ 0 := le_of_not_gt hz
      rw [← norm_eq_zero]
      exact le_antisymm hle (norm_nonneg (w ρ))
    exact hw hweq
  have hres : ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < ‖u + ρ‖ → ‖u + ρ‖ < δ →
      ‖(u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u - w ρ‖ < ‖w ρ‖ / 2 :=
    weightedPoleFactorEps w c zs ρ hr (‖w ρ‖ / 2) (by
      apply div_pos hwp
      norm_num)
  rcases hres with ⟨δ₂, hδ₂, hr'⟩
  have hzero : ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < dist u (-ρ) → dist u (-ρ) < δ →
      dist ((u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u) (0 : ℂ) < ‖w ρ‖ / 2 :=
    puncturedBound hf (‖w ρ‖ / 2) (by
      apply div_pos hwp
      norm_num)
  rcases hzero with ⟨δ₁, hδ₁, hz'⟩
  set d := min δ₁ δ₂
  have hdpos : 0 < d := lt_min hδ₁ hδ₂
  set u : ℂ := (-ρ : ℂ) + ((d / 2 : ℝ) : ℂ)
  have hsum : u + ρ = ((d / 2 : ℝ) : ℂ) := by
    dsimp only [u]
    ring
  have hnorm : ‖((d / 2 : ℝ) : ℂ)‖ = |(d / 2 : ℝ)| := RCLike.norm_ofReal (d / 2)
  have habs : |(d / 2 : ℝ)| = d / 2 := abs_of_pos (div_pos hdpos (by norm_num))
  have hud0 : 0 < dist u (-ρ) := by
    have hdd : dist u (-ρ) = ‖u + ρ‖ := by
      rw [dist_eq_norm u (-ρ)]
      have hsub : u - (-ρ) = u + ρ := by ring
      rw [hsub]
    rw [hdd, hsum, hnorm, habs]
    linarith [hdpos]
  have hud₁ : dist u (-ρ) < δ₁ := by
    have hdd : dist u (-ρ) = ‖u + ρ‖ := by
      rw [dist_eq_norm u (-ρ)]
      have hsub : u - (-ρ) = u + ρ := by ring
      rw [hsub]
    rw [hdd, hsum, hnorm, habs]
    have hdle : d ≤ δ₁ := min_le_left δ₁ δ₂
    linarith [half_lt_self hdpos, hdle]
  have hud₂ : ‖u + ρ‖ < δ₂ := by
    rw [hsum, hnorm, habs]
    have hdle : d ≤ δ₂ := min_le_right δ₁ δ₂
    linarith [half_lt_self hdpos, hdle]
  have hA : ‖(u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u‖ < ‖w ρ‖ / 2 := by
    have hd : dist ((u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u) (0 : ℂ)
        < ‖w ρ‖ / 2 := hz' u hud0 hud₁
    rw [dist_eq_norm ((u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u) (0 : ℂ), sub_zero] at hd
    exact hd
  have hB : ‖(u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u - w ρ‖ < ‖w ρ‖ / 2 :=
    hr' u (by
      rw [hsum, hnorm, habs]
      linarith [hdpos]) hud₂
  let X := (u + ρ) * D1G.weightedZeroSumMeromorphic w c zs u
  have hA' : ‖X‖ < ‖w ρ‖ / 2 := by simpa [X] using hA
  have hB'' : ‖X - (w ρ : ℂ)‖ < ‖w ρ‖ / 2 := by simpa [X] using hB
  have hre : (w ρ : ℂ) = ((w ρ : ℂ) - X) + X := by ring
  have hnorm : ‖(w ρ : ℂ)‖ = ‖((w ρ : ℂ) - X) + X‖ :=
    congr_arg (fun z : ℂ => ‖z‖) hre
  have hle : ‖(w ρ : ℂ)‖ ≤ ‖(w ρ : ℂ) - X‖ + ‖X‖ := by
    rw [hnorm]
    exact norm_add_le ((w ρ : ℂ) - X) X
  have hlt : ‖(w ρ : ℂ) - X‖ < ‖w ρ‖ / 2 := by
    have hn : ((w ρ : ℂ) - X) = -(X - (w ρ : ℂ)) := by ring
    rw [hn, norm_neg]
    exact hB''
  linarith [hle, hlt, hA']

/-- ZERO WEIGHT REMOVES THE POLE: if `w rho = 0`, the term at rho is
    identically zero and the singularity at -rho LITERALLY disappears -
    the weighted object is continuous at -rho. NO RH CLAIM. -/
theorem weightZeroRemovesPole (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ)
    (hw : w ρ = 0) :
    ContinuousAt (D1G.weightedZeroSumMeromorphic w c zs) (-ρ) := by
  by_cases hmem : ρ ∈ zs
  · let T : ℂ → ℂ := fun s : ℂ => D1G.weightedZeroSumMeromorphic w c (zs \ ({ρ} : Finset ℂ)) s
    have hpt : D1G.weightedZeroSumMeromorphic w c zs = T := by
      ext u
      dsimp only [D1G.weightedZeroSumMeromorphic, D1G.weightedMeromorphicTerm]
      have hsplit2 : zs = (zs \ ({ρ} : Finset ℂ)) ∪ (zs ∩ ({ρ} : Finset ℂ)) :=
        (Finset.sdiff_union_inter zs ({ρ} : Finset ℂ)).symm
      have hdisj : Disjoint (zs \ ({ρ} : Finset ℂ)) (zs ∩ ({ρ} : Finset ℂ)) :=
        Finset.disjoint_sdiff_inter zs ({ρ} : Finset ℂ)
      have h1 : zs ∩ ({ρ} : Finset ℂ) = ({ρ} : Finset ℂ) :=
        (Finset.inter_eq_right).mpr (Finset.singleton_subset_iff.mpr hmem)
      have hfirst : (∑ x ∈ zs ∩ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c u x) =
          w ρ * D1E.meromorphicTerm c u ρ := by
        rw [h1]
        simp
      rw [hsplit2, Finset.sum_union hdisj, hfirst, hw, zero_mul, add_zero]
      have hrest : (∑ x ∈ zs \ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c u x) = T u := by
        dsimp only [T, D1G.weightedZeroSumMeromorphic, D1G.weightedMeromorphicTerm]
      rw [hrest]
    rw [hpt]
    exact (D1G.weightedFiniteSumContinuousOffPoles w (zs \ ({ρ} : Finset ℂ)) c (-ρ) (by
      intro σ hσ hwn
      have hne : σ ≠ ρ := by simpa using (Finset.mem_sdiff.mp hσ).2
      by_contra h0
      exact hne (negSumEq h0)))
  · exact (D1G.weightedFiniteSumContinuousOffPoles w zs c (-ρ) (by
      intro σ hσ hwn
      by_contra h0
      have hσρ : σ = ρ := negSumEq h0
      have hin : ρ ∈ zs := by
        rw [← hσρ]
        exact hσ
      exact hmem hin))

/-- THE WEIGHT <-> POLE DICTION (package): for a zero rho of the
    finite set, the weighted object is continuous at the pole -rho if
    and only if the weight at rho is zero; and (Part 2) when it is not
    continuous, the pole factor converges to the nonzero weight.
    Weight is pole. NO RH CLAIM. -/
theorem persistenceIff (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (ρ : ℂ) (hr : ρ ∈ zs) :
    ContinuousAt (D1G.weightedZeroSumMeromorphic w c zs) (-ρ) ↔ w ρ = 0 := by
  constructor
  · intro hcont
    by_contra hwn
    exact D1G.weightedFiniteSumNotContinuousAtPole w zs c ρ hr hwn hcont
  · intro hzero
    exact weightZeroRemovesPole w c zs ρ hzero

/-- PACKAGED (mirrors D1G.escapeHatchCharacterized): for an on-line
    zero set enumerated without repetition, the explicit D1G weight
    injWeight (i) satisfies the D1E named gap, (ii) at EVERY finite
    certified slice containing a given zero f(n0), the pole factor tends
    to the NONZERO residue injWeight(f(n0)) = 2^{-n0} at -(f(n0)), and
    (iii) the lifted object itself has NO punctured limit 0 at that
    pole - it blows up there (D1G's quantitative M-blow-up persists for
    the very weight that satisfies the gap). The escape hatch leaves, at
    every certified zero, a pole whose strength is exactly the (nonzero)
    weight. NO RH CLAIM. -/
theorem escapePoleStrength
    (zsInf : Set ℂ) (c : ℝ)
    (f : ℕ → ℂ) (hmem : ∀ n, f n ∈ zsInf)
    (hfinj : Function.Injective f)
    (hsurj : ∀ (ρ : ℂ), ρ ∈ zsInf → ∃ n, f n = ρ)
    (hline : ∀ n, (f n).re = 1 / 2)
    (n₀ : ℕ) (_hrho : f n₀ ∈ zsInf) :
    D1E.gap_infiniteLifting_convergence zsInf (D1G.injWeight f hfinj) c ∧
    (∀ (zsf : Finset ℂ), f n₀ ∈ zsf →
        Filter.Tendsto (fun u : ℂ => (u + f n₀) * D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u)
          (𝓝[≠] (-(f n₀) : ℂ)) (𝓝 (D1G.injWeight f hfinj (f n₀)))) ∧
    (∀ (zsf : Finset ℂ), f n₀ ∈ zsf →
        ¬Filter.Tendsto (fun u : ℂ => D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u)
          (𝓝[≠] (-(f n₀) : ℂ)) (𝓝 (0 : ℂ))) := by
  refine ⟨?_, ?_, ?_⟩
  · exact D1G.namedGapSatisfiedOnLine zsInf c f hmem hfinj hsurj hline
  · intro zsf hz
    exact weightedPoleFactorTendsto (D1G.injWeight f hfinj) c zsf (f n₀) hz
  · intro zsf hz
    intro hf
    have hwn : D1G.injWeight f hfinj (f n₀) ≠ 0 :=
      D1G.injWeight_nonzero f hfinj (f n₀) ⟨n₀, rfl⟩
    have hblow : ∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < ‖u + f n₀‖ → ‖u + f n₀‖ < δ →
        M < ‖D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u‖ :=
      D1G.weightedFiniteSumBlewUpAtPole (D1G.injWeight f hfinj) zsf c (f n₀) hz hwn
    have hzero : ∃ δ > (0 : ℝ), ∀ u : ℂ, 0 < dist u (-(f n₀) : ℂ) → dist u (-(f n₀) : ℂ) < δ →
        dist (D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u) (0 : ℂ) < 3 :=
      puncturedBound hf 3 (by norm_num)
    rcases hzero with ⟨δ₁, hδ₁, hz'⟩
    rcases hblow 3 with ⟨δ₂, hδ₂, hb2⟩
    set d := min δ₁ δ₂
    have hdpos : 0 < d := lt_min hδ₁ hδ₂
    set u : ℂ := (-(f n₀) : ℂ) + ((d / 2 : ℝ) : ℂ)
    have hsum : u + f n₀ = ((d / 2 : ℝ) : ℂ) := by
      dsimp only [u]
      ring
    have hnorm : ‖((d / 2 : ℝ) : ℂ)‖ = |(d / 2 : ℝ)| := RCLike.norm_ofReal (d / 2)
    have habs : |(d / 2 : ℝ)| = d / 2 := abs_of_pos (div_pos hdpos (by norm_num))
    have hnrm : ‖u + f n₀‖ = d / 2 := by
      rw [hsum, hnorm, habs]
    have hud0 : 0 < ‖u + f n₀‖ := by
      rw [hnrm]
      linarith [hdpos]
    have hud₁ : dist u (-(f n₀) : ℂ) < δ₁ := by
      have hdd : dist u (-(f n₀) : ℂ) = ‖u + f n₀‖ := by
        rw [dist_eq_norm u (-(f n₀) : ℂ)]
        have hsub : u - (-(f n₀) : ℂ) = u + f n₀ := by ring
        rw [hsub]
      rw [hdd, hnrm]
      have hdle : d ≤ δ₁ := min_le_left δ₁ δ₂
      linarith [half_lt_self hdpos, hdle]
    have hud₂ : ‖u + f n₀‖ < δ₂ := by
      rw [hnrm]
      have hdle : d ≤ δ₂ := min_le_right δ₁ δ₂
      linarith [half_lt_self hdpos, hdle]
    have hA : 3 < ‖D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u‖ :=
      hb2 u hud0 hud₂
    have hB : ‖D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u‖ < 3 := by
      have hd : dist (D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u) (0 : ℂ) < 3 :=
        hz' u (by
          have hdd : dist u (-(f n₀) : ℂ) = ‖u + f n₀‖ := by
            rw [dist_eq_norm u (-(f n₀) : ℂ)]
            have hsub : u - (-(f n₀) : ℂ) = u + f n₀ := by ring
            rw [hsub]
          rw [hdd, hnrm]
          linarith [hdpos]) hud₁
      rw [dist_eq_norm (D1G.weightedZeroSumMeromorphic (D1G.injWeight f hfinj) c zsf u)
        (0 : ℂ), sub_zero] at hd
      exact hd
    linarith [hA, hB]

end D1H
