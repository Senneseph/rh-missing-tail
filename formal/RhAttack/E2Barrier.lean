/-
# (E2Barrier)  The E2 absolute-sum barrier  —  as a Lean record.

The E2 entry of  docs/S1-A1-EXPLORATION.md  ("The absolute-sum
barrier on the R2 route")  is a NEGATIVE-RESULT record:  the
R2/driftTwoSided mechanism  (pin the start,  sum a pointwise
envelope of the per-gap absolute deviations)  cannot deliver a
uniform  K ~ O(1)  pointwise  A1  bound,  because any valid
envelope dominates the walk's total variation,  and that total
variation is LINEAR in the zero count.

This file records the barrier formally,  in three parts:

  1.  `envelope_dominates_total_variation`  (fact 2,  exact):
      any pointwise envelope  f  of the per-gap absolute
      deviations  eps  satisfies  Σ f >= Σ eps.
  2.  `no_constant_closer`  (the barrier,  exact theorem,
      HYPOTHETICAL input):  if the per-gap absolute
      deviations stay uniformly away from zero  (a δ-floor),
      then NO finite constant K bounds the mechanism's output
      over all band sizes.  The δ-floor is the open formal
      ingredient  (E2 fact 4  —  the positive-density
      oscillation fact;  the unconditional density theorem
      STTB,  arXiv:2010.10675,  carries vacuous constants  —
      hence the floor is an HYPOTHESIS here,  not a proven
      fact).
  3.  the MEASURED record for our verified 3 x 10^10 band
      (`band3e10`):  the certified pins,  and the derived
      scale statements  (norm_num  on the certified digits).

What this file does NOT claim:  anything about zeta beyond
the pins of the verified band.  The pins are the outputs of
the certified data layer  (A2 class);  this record packages
them so the barrier statement is checkable,  and no new
arithmetic is invented.
-/
import Mathlib

open Finset

namespace E2Barrier

/- 1.  Fact 2,  exact:  the envelope dominates the total
    variation. -/

/-- The `driftTwoSided` bound form  (K0  +  Σ f)  with a
    POINTWISE envelope  f >= eps  dominates  K0  +  Σ eps,
    the walk's total variation  (+  the pin error  K0). -/
theorem envelope_dominates_total_variation (K0 : ℝ)
    (eps f : ℕ → ℝ) (hN : ℕ)
    (henv : ∀ i ∈ Finset.range hN, eps i ≤ f i) :
    K0 + (∑ i ∈ Finset.range hN, eps i) ≤
        K0 + (∑ i ∈ Finset.range hN, f i) :=
  add_le_add_right (Finset.sum_le_sum henv) K0

/- 2.  The barrier:  a δ-floor on the per-gap deviations
    rules out any constant closer. -/

/-- If  |Δ_i - 1|  >= δ  > 0  at every zero i,  then the
    absolute-sum mechanism's output  K0 + Σ_{i < N} eps_i
    is unbounded in  N  —  no finite K  bounds it.  (The
    δ-floor is the E2 fact-4  oscillation hypothesis;  on
    the verified band it holds on MEAN,  with certified
    mean >= 1/3;  see  `mean_ge_third`.) -/
theorem no_constant_closer (K0 : ℝ) (eps : ℕ → ℝ)
    (hδ : ∃ δ > 0, ∀ i, eps i ≥ δ) :
    ¬ ∃ K : ℝ, ∀ N : ℕ, K0 + (∑ i ∈ Finset.range N, eps i) ≤ K := by
  obtain ⟨δ, hδ0, hδall⟩ := hδ
  intro hK
  obtain ⟨K, hKall⟩ := hK
  -- an  N  with  N·δ  >  max 1 (K - K0)
  let M : ℕ := Nat.ceil ((max 1 (K - K0)) / δ)
  have hM : (M : ℝ) ≥ (max 1 (K - K0)) / δ := Nat.le_ceil ((max 1 (K - K0)) / δ)
  have hM' : (M : ℝ) * δ ≥ max 1 (K - K0) := by
    have hM'' : (M : ℝ) * δ ≥ ((max 1 (K - K0)) / δ) * δ :=
      mul_le_mul_of_nonneg_right hM (le_of_lt hδ0)
    have hM''' : ((max 1 (K - K0)) / δ) * δ = max 1 (K - K0) := by
      field_simp [hδ0.ne']
    linarith [hM'', hM''']
  have hN : ((M + 1) : ℝ) * δ > max 1 (K - K0) := by
    linarith [hM', hδ0]
  have hsum : (∑ i ∈ Finset.range (M + 1), eps i) ≥ (M + 1 : ℝ) * δ := by
    have h1 : (∑ i ∈ Finset.range (M + 1), eps i) ≥
        (∑ i ∈ Finset.range (M + 1), (δ : ℝ)) :=
      Finset.sum_le_sum fun i _ => hδall i
    have h2 : (∑ i ∈ Finset.range (M + 1), (δ : ℝ)) = (M + 1 : ℝ) * δ := by
      simp [Finset.sum_const, Finset.card_range]
    linarith [h1, h2]
  have hcontr : K0 + (∑ i ∈ Finset.range (M + 1), eps i) > K := by
    calc K0 + (∑ i ∈ Finset.range (M + 1), eps i)
        ≥ K0 + ((M + 1) : ℝ) * δ := add_le_add_right hsum K0
      _ > K0 + (max 1 (K - K0)) := add_lt_add_right hN K0
      _ ≥ K0 + (K - K0) := add_le_add_right (le_max_right (1 : ℝ) (K - K0)) K0
      _ = K := by ring
  linarith [hKall (M + 1), hcontr]

/- 3.  The measured record (fact 3,  our verified band). -/

/-- A record band:  the certified pins of the data layer. -/
structure MeasuredBand where
  name : String
  nZeros : ℕ
  sumEpsCert : ℝ   -- certified per-gap absolute-deviation sum
  supDn : ℝ        -- certified sup of  |DN|  on the band

/-- The verified 3 x 10^10 zero band  (re-fetched byte-exact,
    gated).  Pins:  92,577,877,714  zeros;
    SUM_EPS_CERT  =  31,047,116,350.923088;
    sup |DN|      =  2.615067. -/
def band3e10 : MeasuredBand :=
  { name := "band3e10"
    nZeros := 92577877714
    sumEpsCert := 31047116350.923088
    supDn := 2.615067 }

/-- Certified per-zero mean of the absolute deviation. -/
noncomputable def meanAbs (b : MeasuredBand) : ℝ := b.sumEpsCert / (b.nZeros : ℝ)

/-- Measured scale of the barrier on the record band:
    the absolute-sum output  (K0  =  0)  is  at least  10^9
    times the walk's certified amplitude.  The A1 target is
    a  K  of order  2.6;  the mechanism's bound is of order
    3.1 x 10^10. -/
theorem barrier_band3e10 :
    band3e10.sumEpsCert ≥ 10^9 * band3e10.supDn := by
  norm_num [band3e10, meanAbs]

/-- FACT 3,  certified:  the per-zero mean absolute
    deviation on the record band is  >=  1/3  (it is
    ≈ 0.33535)  —  the per-gap  |drift|  does NOT tend to 0. -/
theorem mean_ge_third : meanAbs band3e10 ≥ 1/3 := by
  norm_num [band3e10, meanAbs]

/-- The certified pin error  K0  is  O(1)  relative  to the
    band scale:  sup|DN|  <  3,  while  the certified sum  is
    >  10^9. -/
theorem pins_separate_scales :
    2.6 < band3e10.supDn ∧ band3e10.sumEpsCert > 10^9 := by
  norm_num [band3e10]

end E2Barrier
