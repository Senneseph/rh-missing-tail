/-
**D1G - The named infinite-lifting gap is constructively satisfiable:
a vanishing weight satisfies it, and the pole obstruction at every
certified zero persists under that weight (D1E named-gap follow-through,
the escape hatch D1F pointed to, made explicit and quantified).**
NO RH CLAIM.

This is the D1-series continuation (D1C, D1C-2, D1D, D1E, D1F, D1G...):
D1E named the convergence input `D1E.gap_infiniteLifting_convergence`
that a zero family must satisfy for its finite Laplace identity to lift
to an infinite meromorphic expression. D1F proved the named gap FAILS
for weight 1 under "on-line + classical VMM linear growth". D1G now does
the complementary half of the same story, in three parts.

PART 1 - THE ON-LINE TERM BOUND (the key simplification).
  * Theorem `meromorphicTermBoundOnLine`: if `rho` sits on the critical
    line (re = 1/2) and `0 < s.re`, then
      |e^{-(s + rho) c} / (s + rho)| <= e^{-(s.re + 1/2) c} / (s.re + 1/2).
    On the line the denominator is uniformly controlled by the POSITIVE
    real part `s.re + 1/2` (independent of `s.im` and of the zero), and
    the exponential modulus is controlled by the real part alone.

PART 2 - SUFFICIENCY OF A VANISHING WEIGHT.
  * Theorem `namedGapSummableOnLine`: if the norm sequence
      (n |-> |w (f n)|)
    is summable (any weight whose size is summable along the enumeration),
    then the D1E named-gap series IS summable at every s with 0 < s.re
    (comparison against the Part-1 bound).
  * Definition `injWeight` + Theorem `injWeight_summable`: for any
    repetition-free (injective) enumeration f of complex points, the
    constructive weight
      w(rho) := 2^{-n}   (w.r.t. the unique index n with f n = rho),
                0        (w.r.t. rho not in the range)
    has summable norm sequence (the geometric series ratio 1/2).
  * Theorem `namedGapSatisfiedOnLine`: therefore, for any zero set on
    the critical line with a repetition-free enumeration, the D1E named
    gap `D1E.gap_infiniteLifting_convergence` HOLDS (with the explicit
    weight `injWeight`).

TOGETHER D1F + D1G pin down the escape hatch: through the Danesh lifting,
the named gap can only be satisfied by a weight whose size decays along
the enumeration (D1F: weight 1 fails; D1G: 2^{-n} works). This is exactly
the "weight vanishing on the zero set" that D1F's CONSEQUENCE named.

PART 3 - THE POLE PERSISTS UNDER ANY SUCH WEIGHT (the punchline).
  * Theorem `weightedFiniteSumContinuousOffPoles`: the weighted meromorphic
    finite sum is continuous at u whenever u is not the NEGATION of a
    zero with NONZERO weight (zeros of zero weight are invisible).
  * Theorem `meromorphicTermBlewUp`: a single meromorphic term blows up
    at its own pole, quantitatively: for every M >= 0 there is a puncture
    of radius at most 1 in which its norm exceeds M, with the bound
      |e^{-z c} / z| >= e^{-|c|} / |z|  for 0 < |z| < 1.
  * Theorem `weightedFiniteSumBlewUpAtPole`: if w rho != 0 and
    rho in zs, the weighted finite sum BLOWS UP at -rho (quantitatively,
    the same uniform "for all M" statement D1E proved for weight 1).
  * Theorem `weightedFiniteSumNotContinuousAtPole`: in particular it is
    NOT continuous at -rho.
  * Theorem `weightedPoleLocusIff`: the singular locus of the weighted
    finite object is EXACTLY the set of negated zeros of nonzero weight.
  * Theorem `escapeHatchCharacterized` (packaged): for an on-line zero
    set enumerated without repetition, the explicit weight from Part 2
    (i) satisfies the D1E named gap, (ii) vanishes NOWHERE on the zero
    set, and (iii) consequently every finite certified slice containing
    a given zero carries that zero's pole at -rho in the lifted object:
    NON-CONTINUITY persists under the very weights that make the lifting
    well-defined.

CONSEQUENCE (in the D1E language, NO RH CLAIM): the named gap is not the
terminal obstruction for on-line zero sets - it is constructively
satisfiable. The terminal obstruction is the pole itself: any lifting of
the Danesh criterion to the infinite zero set must carry, at every
certified zero rho on the line, a pole at -rho (residue w(rho e^{-rho c},
nonzero for every admissible weight). The lifted object is meromorphic
precisely in the negated zero set; closing the terminal face requires
killing that pole, which no admissible weight can do.
-/
import Mathlib
import RhAttack.D1F
open scoped BigOperators

namespace D1G

/-! ## The weighted meromorphic object -/

/-- One weighted term of the zero-sum meromorphic object:
    `w rho * e^{-(u + rho) c} / (u + rho)`. -/
noncomputable def weightedMeromorphicTerm (w : ℂ → ℂ) (c : ℝ) (u : ℂ) (ρ : ℂ) : ℂ :=
    w ρ * D1E.meromorphicTerm c u ρ

/-- The weighted zero-sum meromorphic object attached to a finite zero
    set `zs`, weights `w`, cutoff `c`, evaluated at `u`. -/
noncomputable def weightedZeroSumMeromorphic (w : ℂ → ℂ) (c : ℝ) (zs : Finset ℂ) (u : ℂ) : ℂ :=
    ∑ ρ ∈ zs, weightedMeromorphicTerm w c u ρ

/-! ## Part 1: the on-line term bound -/

/-- THE ON-LINE TERM BOUND: for `rho` on the critical line (re = 1/2)
    and `0 < s.re`, the meromorphic term at `s` is bounded by replacing
    the (complex) denominator by the positive real number `s.re + 1/2`:
      |e^{-(s + rho) c} / (s + rho)| <= e^{-(s.re + 1/2) c} / (s.re + 1/2).
    The denominator control is uniform in `s.im` and in `rho`; on the
    line this is the whole game. NO RH CLAIM. -/
theorem meromorphicTermBoundOnLine (ρ : ℂ) (c : ℝ) (s : ℂ)
    (hline : ρ.re = 1 / 2) (hs : 0 < s.re) :
    ‖D1E.meromorphicTerm c s ρ‖ ≤
      Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2) := by
  have hre : (s + ρ).re = s.re + 1 / 2 := by rw [Complex.add_re, hline]
  have hpos : 0 < s.re + 1 / 2 := by linarith
  calc
    ‖D1E.meromorphicTerm c s ρ‖ =
        ‖Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)‖ := by
      dsimp only [D1E.meromorphicTerm]
    _ = ‖Complex.exp (-((s + ρ) * (c : ℂ)))‖ / ‖s + ρ‖ :=
      norm_div _ _
    _ = Real.exp (-((s + ρ).re * c)) / ‖s + ρ‖ := by
      have hneg : (-((s + ρ) * (c : ℂ))).re = -(((s + ρ) * (c : ℂ)).re) :=
        by simp only [Complex.neg_re]
      have hmuleq : ((s + ρ) * (c : ℂ)).re = (s + ρ).re * c := by
        simp only [Complex.ofReal_im, Complex.ofReal_re, Complex.mul_re]
        ring
      rw [Complex.norm_exp, hneg, hmuleq]
    _ = Real.exp (-((s.re + 1 / 2) * c)) / ‖s + ρ‖ := by
      rw [hre]
    _ ≤ Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2) := by
      have hnm : s.re + 1 / 2 ≤ ‖s + ρ‖ := by
        have habs : |(s + ρ).re| ≤ ‖s + ρ‖ := Complex.abs_re_le_norm (s + ρ)
        have hnonneg : 0 ≤ (s + ρ).re := by
          rw [hre]
          linarith [hs]
        calc
          s.re + 1 / 2 = (s + ρ).re := by simpa using hre.symm
            _ = |(s + ρ).re| := (abs_of_nonneg hnonneg).symm
            _ ≤ ‖s + ρ‖ := habs
      have hexp : 0 ≤ Real.exp (-((s.re + 1 / 2) * c)) := (Real.exp_pos _).le
      have hzpos : 0 < ‖s + ρ‖ := by
        have hne : s + ρ ≠ 0 := by
          by_contra h
          have hre0 : (s + ρ).re = 0 := by
            rw [h]
            norm_num
          rw [hre] at hre0
          linarith [hpos]
        by_contra hz
        push_neg at hz
        have hnz : 0 ≤ ‖s + ρ‖ := norm_nonneg _
        have heq : ‖s + ρ‖ = 0 := le_antisymm hz hnz
        have hzero : s + ρ = 0 := by
          rw [norm_eq_zero] at heq
          exact heq
        exact hne hzero
      have hinv : 1 / (‖s + ρ‖) ≤ 1 / (s.re + 1 / 2) :=
        one_div_le_one_div_of_le hpos hnm
      calc
        Real.exp (-((s.re + 1 / 2) * c)) / ‖s + ρ‖ ≤
            Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2) := by
          have hd1 : 0 < ‖s + ρ‖ := hzpos
          have hd2 : 0 < s.re + 1 / 2 := hpos
          rw [div_le_div_iff₀ hd1 hd2]
          exact mul_le_mul_of_nonneg_left hnm hexp

/-- Weighted form of the on-line bound: the weight norm factors out. -/
theorem weightedTermBoundOnLine (w : ℂ → ℂ) (ρ : ℂ) (c : ℝ) (s : ℂ)
    (hline : ρ.re = 1 / 2) (hs : 0 < s.re) :
    ‖w ρ * D1E.meromorphicTerm c s ρ‖ ≤
      ‖w ρ‖ * (Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2)) := by
  calc
    ‖w ρ * D1E.meromorphicTerm c s ρ‖ =
        ‖w ρ‖ * ‖D1E.meromorphicTerm c s ρ‖ := norm_mul _ _
    _ ≤ ‖w ρ‖ * (Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2)) :=
      mul_le_mul_of_nonneg_left (meromorphicTermBoundOnLine ρ c s hline hs)
        (norm_nonneg (w ρ))

/-! ## Part 2: the named gap, satisfied by a vanishing weight -/

/-- SUFFICIENCY: if the weight-norm sequence along the enumeration is
    summable, then the D1E named-gap series is summable at every
    admissible point s (0 < s.re) - for on-line zeros. NO RH CLAIM. -/
theorem namedGapSummableOnLine (f : ℕ → ℂ) (w : ℂ → ℂ) (c : ℝ) (s : ℂ)
    (hline : ∀ n, (f n).re = 1 / 2)
    (hw : Summable (fun n : ℕ => ‖w (f n)‖))
    (hs : 0 < s.re) :
    Summable (fun n : ℕ =>
        ‖w (f n) * Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)‖) := by
  set K : ℝ := Real.exp (-((s.re + 1 / 2) * c)) / (s.re + 1 / 2) with hKdef
  have hK : 0 ≤ K := by
    dsimp only [K]
    exact div_nonneg (Real.exp_pos _).le (by linarith [hs])
  have hle (n : ℕ) :
      ‖w (f n) * Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)‖ ≤
        K * ‖w (f n)‖ := by
    have h : ‖w (f n) * D1E.meromorphicTerm c s (f n)‖ ≤
        ‖w (f n)‖ * K := weightedTermBoundOnLine w (f n) c s (hline n) hs
    have heq : w (f n) * Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n) =
        w (f n) * (Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)) := by
      ring
    calc
      ‖w (f n) * Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)‖ =
          ‖w (f n) * (Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n))‖ :=
        congrArg (fun x : ℂ => ‖x‖) heq
      _ = ‖w (f n) * D1E.meromorphicTerm c s (f n)‖ := by
        dsimp only [D1E.meromorphicTerm]
      _ ≤ K * ‖w (f n)‖ := by
        simpa [mul_comm] using h
  have hKsum : Summable (fun n : ℕ => K * ‖w (f n)‖) := hw.mul_left K
  exact Summable.of_nonneg_of_le (fun n => norm_nonneg _) hle hKsum

/-- CONSTRUCTIVE VANISHING WEIGHT: for a repetition-free (injective)
    enumeration f, the weight `injWeight f hfinj (f n) = 2^{-n}` (at the
    index of the point; 0 off the range). The norm sequence along the
    enumeration is the summable geometric series of ratio 1/2. -/
noncomputable def injWeight (f : ℕ → ℂ) (hfinj : Function.Injective f) (ρ : ℂ) : ℂ := by
  classical
  exact if h : ∃! n, f n = ρ then ((1 / 2 : ℝ) : ℂ) ^ (Classical.choose (ExistsUnique.exists h))
    else 0

/-- The constructed weight at an enumerated point is exactly `2^{-n}`. -/
theorem injWeight_at_f (f : ℕ → ℂ) (hfinj : Function.Injective f) (n₀ : ℕ) :
    injWeight f hfinj (f n₀) = ((1 / 2 : ℝ) : ℂ) ^ n₀ := by
  dsimp only [injWeight]
  split_ifs with h
  · have hchoose : Classical.choose (ExistsUnique.exists h) = n₀ := by
      have hspec : f (Classical.choose (ExistsUnique.exists h)) = f n₀ :=
        Classical.choose_spec (ExistsUnique.exists h)
      exact hfinj hspec
    rw [hchoose]
  · exfalso
    exact h (⟨n₀, rfl, fun m hm => hfinj hm⟩ : ∃! (n : ℕ), f n = f n₀)

/-- The norm sequence of the constructed weight along its enumeration is
    the summable geometric series of ratio 1/2. -/
theorem injWeight_summable (f : ℕ → ℂ) (hfinj : Function.Injective f) :
    Summable (fun n : ℕ => ‖injWeight f hfinj (f n)‖) := by
  have hnorm (n : ℕ) :
      ‖injWeight f hfinj (f n)‖ = (1 / 2 : ℝ) ^ n := by
    rw [injWeight_at_f f hfinj n, norm_pow]
    have hb : ‖((1 / 2 : ℝ) : ℂ)‖ = (1 / 2 : ℝ) := by norm_num
    exact congrArg (fun x => x ^ n) hb
  have hseq : (fun n : ℕ => ‖injWeight f hfinj (f n)‖) =
      (fun n : ℕ => (1 / 2 : ℝ) ^ n) := funext hnorm
  rw [hseq]
  exact summable_geometric_two

/-- The constructed weight vanishes NOWHERE on its range: it is
    `2^{-n}` at every enumerated point, a nonzero complex. -/
theorem injWeight_nonzero (f : ℕ → ℂ) (hfinj : Function.Injective f) (ρ : ℂ)
    (h : ∃ n, f n = ρ) :
    injWeight f hfinj ρ ≠ 0 := by
  obtain ⟨n₀, hn₀⟩ := h
  have hρ : ρ = f n₀ := by rw [← hn₀]
  subst_vars
  intro hzero
  rw [injWeight_at_f f hfinj n₀] at hzero
  have hnorm : ‖((1 / 2 : ℝ) : ℂ) ^ n₀‖ = 0 := by
    rw [hzero, norm_zero]
  have hpos : 0 < ‖((1 / 2 : ℝ) : ℂ) ^ n₀‖ := by
    rw [norm_pow ((1 / 2 : ℝ) : ℂ) n₀]
    have hhalf : ‖((1 / 2 : ℝ) : ℂ)‖ = 1 / 2 := by
      calc ‖((1 / 2 : ℝ) : ℂ)‖ = |(1 / 2 : ℝ)| := RCLike.norm_ofReal (1 / 2 : ℝ)
        _ = 1 / 2 := abs_of_pos (by norm_num : (0 : ℝ) < 1 / 2)
    rw [hhalf]
    exact pow_pos (by norm_num : (0 : ℝ) < 1 / 2) n₀
  have hcontra : ¬(0 < ‖((1 / 2 : ℝ) : ℂ) ^ n₀‖) := by
    intro hlt
    have hz : ‖((1 / 2 : ℝ) : ℂ) ^ n₀‖ = 0 := hnorm
    linarith
  exact hcontra hpos

/-- THE NAMED GAP IS SATISFIED, CONSTRUCTIVELY (on-line case). For any zero
    set on the critical line with a repetition-free enumeration, the
    explicit weight `injWeight` (2^{-n} at the n-th point) makes
    `D1E.gap_infiniteLifting_convergence` hold. Together with D1F (weight 1
    FAILS under line + VMM growth), this pins down the escape hatch: the
    Danesh lifting through the named gap needs a weight whose size decays
    along the enumeration. NO RH CLAIM. -/
theorem namedGapSatisfiedOnLine
    (zsInf : Set ℂ) (c : ℝ)
    (f : ℕ → ℂ) (hmem : ∀ n, f n ∈ zsInf)
    (hfinj : Function.Injective f)
    (hsurj : ∀ (ρ : ℂ), ρ ∈ zsInf → ∃ n, f n = ρ)
    (hline : ∀ n, (f n).re = 1 / 2) :
    D1E.gap_infiniteLifting_convergence zsInf (injWeight f hfinj) c := by
  right
  use f, hmem, hsurj
  intro s hs _
  exact namedGapSummableOnLine f (injWeight f hfinj) c s hline
    (injWeight_summable f hfinj) hs

/-! ## Part 3: the pole persists under any such weight -/

/-- The weighted meromorphic finite sum is continuous at `u₀` whenever
    `u₀` is not the negation of a zero with NONZERO weight (zeros of zero
    weight are invisible to the object). -/
theorem weightedFiniteSumContinuousOffPoles (w : ℂ → ℂ) (zs : Finset ℂ) (c : ℝ)
    (u₀ : ℂ) (h : ∀ (ρ : ℂ) (hr : ρ ∈ zs), w ρ ≠ 0 → u₀ + ρ ≠ 0) :
    ContinuousAt (weightedZeroSumMeromorphic w c zs) u₀ := by
  classical
  show ContinuousAt (fun u : ℂ => ∑ ρ ∈ zs, w ρ * D1E.meromorphicTerm c u ρ) u₀
  induction zs using Finset.induction with
  | empty =>
    change ContinuousAt (fun _ : ℂ => (0 : ℂ)) u₀
    exact (continuous_const : Continuous (fun _ : ℂ => (0 : ℂ))).continuousAt
  | insert ρ s hρ ih =>
    have hρne : w ρ ≠ 0 → u₀ + ρ ≠ 0 := h ρ (Finset.mem_insert_self ρ s)
    simp only [Finset.sum_insert hρ]
    have ih' : ContinuousAt (fun u : ℂ => ∑ ρ' ∈ s, w ρ' * D1E.meromorphicTerm c u ρ') u₀ :=
      ih (by
        intro ρ' hr'
        exact h ρ' (Finset.mem_insert_of_mem hr'))
    have hterm : ContinuousAt (fun u : ℂ => w ρ * D1E.meromorphicTerm c u ρ) u₀ := by
      by_cases hw : w ρ = 0
      · simp only [hw, zero_mul]
        exact (continuous_const : Continuous (fun _ : ℂ => (0 : ℂ))).continuousAt
      exact (continuous_const : Continuous (fun _ : ℂ => (w ρ : ℂ))).continuousAt.mul
        (D1E.meromorphicTermContinuous ρ c u₀ (hρne hw))
    exact ContinuousAt.add hterm ih'

/-- A single meromorphic term BLOWS UP at its own pole, quantitatively:
    for every M >= 0 there is a puncture of radius <= 1 in which the
    term's norm exceeds M. The mechanism: for 0 < |z| < 1,
      |e^{-z c} / z| >= e^{-|c|} / |z| >= e^{-|c|} / (e^{-|c|} / (M + 1)) = M + 1.
    NO RH CLAIM. -/
theorem meromorphicTermBlewUp (ρ : ℂ) (c : ℝ) (M : ℝ) (hM : 0 ≤ M) :
    ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ →
        M < ‖D1E.meromorphicTerm c s ρ‖ := by
  set qB := Real.exp (-(|c| : ℝ)) with hqBdef
  have hqB : 0 < qB := Real.exp_pos _
  have hM1 : 0 < M + 1 := by linarith
  set δ := min 1 (qB / (M + 1)) with hddef
  have hdivq : 0 < qB / (M + 1) := div_pos hqB hM1
  have hδ : 0 < δ := lt_min (by norm_num) hdivq
  refine ⟨δ, hδ, fun s hs hd => ?_⟩
  have hq : ‖s + ρ‖ < 1 := by linarith [hd, min_le_left 1 (qB / (M + 1))]
  have hq2 : ‖s + ρ‖ < qB / (M + 1) := by linarith [hd, min_le_right 1 (qB / (M + 1))]
  have hrebound : |(s + ρ).re| < 1 := by
    linarith [Complex.abs_re_le_norm (s + ρ)]
  have hexp : qB ≤ ‖Complex.exp (-((s + ρ) * (c : ℂ)))‖ := by
    calc
      qB = Real.exp (-(|c| : ℝ)) := by dsimp only [qB]
      _ ≤ Real.exp (-((s + ρ).re * c)) := by
        have hrc : (s + ρ).re * c ≤ |c| := by
          calc (s + ρ).re * c ≤ |(s + ρ).re * c| := le_abs_self _
            _ = |(s + ρ).re| * |c| := abs_mul (s + ρ).re c
            _ ≤ 1 * |c| := mul_le_mul_of_nonneg_right hrebound.le (abs_nonneg c)
            _ = |c| := one_mul _
        have hx : -|c| ≤ -((s + ρ).re * c) := by
          linarith [hrc]
        exact (Real.exp_le_exp.mpr hx)
      _ = ‖Complex.exp (-((s + ρ) * (c : ℂ)))‖ := by
        have hneg : (-((s + ρ) * (c : ℂ))).re = -(((s + ρ) * (c : ℂ)).re) :=
          by simp only [Complex.neg_re]
        have hmuleq : ((s + ρ) * (c : ℂ)).re = (s + ρ).re * c := by
          simp only [Complex.ofReal_im, Complex.ofReal_re, Complex.mul_re]
          ring
        have hexp_eq : ‖Complex.exp (-((s + ρ) * (c : ℂ)))‖ =
            Real.exp (-((s + ρ).re * c)) := by
          rw [Complex.norm_exp, hneg, hmuleq]
        exact hexp_eq.symm
  have hge : qB / (qB / (M + 1)) ≤ qB / ‖s + ρ‖ := by
    rw [div_le_div_iff₀ hdivq hs]
    exact mul_le_mul_of_nonneg_left hq2.le hqB.le
  have hmid : qB / (qB / (M + 1)) = M + 1 := by
    dsimp only [qB]
    field_simp [hqB.ne', hM1.ne']
  calc
    M < M + 1 := by linarith
    _ = qB / (qB / (M + 1)) := by rw [hmid]
    _ ≤ qB / ‖s + ρ‖ := hge
    _ ≤ ‖Complex.exp (-((s + ρ) * (c : ℂ)))‖ / ‖s + ρ‖ := by
      rw [div_le_div_iff₀ hs hs]
      exact mul_le_mul_of_nonneg_right hexp hs.le
    _ = ‖Complex.exp (-((s + ρ) * (c : ℂ))) / (s + ρ)‖ := by
      rw [norm_div (Complex.exp (-((s + ρ) * (c : ℂ)))) (s + ρ)]
    _ = ‖D1E.meromorphicTerm c s ρ‖ := by
      dsimp only [D1E.meromorphicTerm]

/-- The weighted meromorphic finite sum BLOWS UP at the negation of any
    zero of nonzero weight: for every M there is a punctured ball around
    `-rho` in which its norm exceeds M (the same quantitative statement
    D1E proves for weight 1, now with arbitrary weights). NO RH CLAIM. -/
theorem weightedFiniteSumBlewUpAtPole (w : ℂ → ℂ) (zs : Finset ℂ) (c : ℝ) (ρ : ℂ)
    (hr : ρ ∈ zs) (hwn : w ρ ≠ 0) :
    ∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ →
        M < ‖weightedZeroSumMeromorphic w c zs s‖ := by
  classical
  intro M
  -- split the zero set: the pole term at rho, and the off-pole rest T
  set S := (zs \ ({ρ} : Finset ℂ))
  let T : ℂ → ℂ := fun u : ℂ => ∑ ρ' ∈ S, w ρ' * D1E.meromorphicTerm c u ρ'
  have hTcont : ContinuousAt T (-ρ) := by
    dsimp only [T]
    exact weightedFiniteSumContinuousOffPoles w S c (-ρ) (by
      intro ρ' hr' hw'
      dsimp only [S] at hr'
      have hne : ρ' ≠ ρ := by simpa using (Finset.mem_sdiff.mp hr').2
      by_contra h
      have h0 : (-ρ : ℂ) + ρ' = 0 := by simpa using h
      have heq : ρ' = ρ := by
        calc ρ' = (-ρ + ρ') + ρ := by ring
          _ = ρ := by rw [h0]; simp
      exact hne heq)
  -- T is locally bounded near -rho
  have hTbound : ∃ δT > (0 : ℝ), ∀ (s : ℂ), ‖s + ρ‖ < δT → ‖T s‖ ≤ ‖T (-ρ)‖ + 1 := by
    rcases Metric.continuousAt_iff.mp hTcont 1 (by norm_num) with ⟨δT, hδT, hTb⟩
    have h : ∀ (s : ℂ), ‖s + ρ‖ < δT → ‖T s‖ ≤ ‖T (-ρ)‖ + 1 := by
      intro s hs
      have h1 : ‖T s - T (-ρ)‖ < 1 := by
        rw [← dist_eq_norm (T s) (T (-ρ))]
        have hsd : dist s (-ρ) < δT := by
          rw [dist_eq_norm s (-ρ)]
          have heq : s - (-ρ) = s + ρ := by ring
          rw [heq]
          exact hs
        exact hTb hsd
      have h2 : ‖T s‖ ≤ ‖T s - T (-ρ)‖ + ‖T (-ρ)‖ := by
        calc
          ‖T s‖ = ‖(T s - T (-ρ)) + T (-ρ)‖ := by
            have : (T s - T (-ρ)) + T (-ρ) = T s := by ring
            rw [this]
          _ ≤ ‖T s - T (-ρ)‖ + ‖T (-ρ)‖ := norm_add_le _ _
      linarith
    exact ⟨δT, hδT, h⟩
  obtain ⟨δT, hδT, hTb⟩ := hTbound
  set B := ‖T (-ρ)‖ + 1
  have hBn : 0 ≤ B := by
    dsimp only [B]
    linarith [norm_nonneg (T (-ρ))]
  have hTw (s : ℂ) (hs : ‖s + ρ‖ < δT) : ‖T s‖ ≤ B := by
    dsimp only [B]
    exact hTb s hs
  -- decomposition: F s = (w rho) * (pole term at s) + T s
  have hdecomp (s : ℂ) : weightedZeroSumMeromorphic w c zs s =
      (w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s := by
    dsimp only [weightedZeroSumMeromorphic, weightedMeromorphicTerm]
    have hsplit : zs = (zs \ ({ρ} : Finset ℂ)) ∪ (zs ∩ ({ρ} : Finset ℂ)) :=
      (Finset.sdiff_union_inter zs ({ρ} : Finset ℂ)).symm
    have hdisj : Disjoint (zs \ ({ρ} : Finset ℂ)) (zs ∩ ({ρ} : Finset ℂ)) :=
      Finset.disjoint_sdiff_inter zs ({ρ} : Finset ℂ)
    rw [hsplit, Finset.sum_union hdisj]
    have hrest : (∑ x ∈ zs \ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c s x) =
        T s := by
      dsimp only [T, S]
    have h1 : zs ∩ ({ρ} : Finset ℂ) = ({ρ} : Finset ℂ) :=
      (Finset.inter_eq_right).mpr (Finset.singleton_subset_iff.mpr hr)
    have hfirst : (∑ x ∈ zs ∩ ({ρ} : Finset ℂ), w x * D1E.meromorphicTerm c s x) =
        w ρ * D1E.meromorphicTerm c s ρ := by
      rw [h1]
      simp
    rw [hrest, hfirst]
    rw [add_comm]

  by_cases hM : 0 ≤ M
  · -- the pole term dominates: choose the puncture from the single-term blow-up
    have hwpos : 0 < ‖(w ρ : ℂ)‖ := by
      by_contra hn
      push_neg at hn
      have hnz : 0 ≤ ‖(w ρ : ℂ)‖ := norm_nonneg _
      have heq : ‖(w ρ : ℂ)‖ = 0 := le_antisymm hn hnz
      rw [norm_eq_zero] at heq
      exact hwn heq
    have hsing : ∃ δ1 > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ1 →
        (M + B + 1) / ‖(w ρ : ℂ)‖ < ‖D1E.meromorphicTerm c s ρ‖ :=
      meromorphicTermBlewUp ρ c ((M + B + 1) / ‖(w ρ : ℂ)‖)
        (by positivity)
    obtain ⟨δ1, hδ1, hblow⟩ := hsing
    set δ := min δT δ1
    refine ⟨δ, lt_min hδT hδ1, fun s hs hclose => ?_⟩
    have hsT : ‖s + ρ‖ < δT := lt_of_lt_of_le hclose (min_le_left (a := δT) (b := δ1))
    have hs1 : ‖s + ρ‖ < δ1 := lt_of_lt_of_le hclose (min_le_right (a := δT) (b := δ1))
    have hTbound1 : ‖T s‖ ≤ B := hTw s hsT
    have hblow1 : (M + B + 1) / ‖(w ρ : ℂ)‖ < ‖D1E.meromorphicTerm c s ρ‖ :=
      hblow s hs hs1
    have hA : M + B + 1 < ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ := by
      have hstep : ‖(w ρ : ℂ)‖ * ((M + B + 1) / ‖(w ρ : ℂ)‖) <
          ‖(w ρ : ℂ)‖ * ‖D1E.meromorphicTerm c s ρ‖ :=
        mul_lt_mul_of_pos_left hblow1 hwpos
      have heq : ‖(w ρ : ℂ)‖ * ((M + B + 1) / ‖(w ρ : ℂ)‖) = M + B + 1 := by
        field_simp [hwpos.ne']
      rw [← heq]
      rw [norm_mul]
      exact hstep
    have htri : ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s‖ ≥
        ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ - ‖T s‖ := by
      have hsub : ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ =
          ‖((w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s) - T s‖ := by
        have : ((w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s) - T s =
            (w ρ : ℂ) * D1E.meromorphicTerm c s ρ := by ring
        rw [this]
      rw [hsub]
      -- reverse triangle: ‖a - b‖ ≤ ‖a‖ + ‖b‖ with a := F s, b := T s gives
      -- ‖w rho t‖ ≤ ‖F s‖ + ‖T s‖, i.e. ‖F s‖ ≥ ‖w rho t‖ - ‖T s‖.
      have hF : ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s‖ + ‖T s‖ ≥
          ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ := by
        have h : ‖((w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s) - T s‖ ≤
            ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s‖ + ‖T s‖ :=
          norm_sub_le _ _
        simpa [hsub] using h
      linarith
    have hfinal :
        M < ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s‖ := by
      have hsubB : ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ - ‖T s‖ ≥
          ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ - B :=
        sub_le_sub_left hTbound1 _
      have hsubM : ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ - B ≥ M + 1 := by
        have hA' : M + B + 1 < ‖(w ρ : ℂ) * D1E.meromorphicTerm c s ρ‖ := hA
        linarith [hA']
      linarith [htri, hsubB, hsubM]
    have hF : weightedZeroSumMeromorphic w c zs s =
        (w ρ : ℂ) * D1E.meromorphicTerm c s ρ + T s := hdecomp s
    rw [hF]
    exact hfinal
  · -- M < 0: any positive radius works
    refine ⟨1, by norm_num, fun s _ _ => ?_⟩
    have hMneg : M < 0 := lt_of_not_ge hM
    have hF : 0 ≤ ‖weightedZeroSumMeromorphic w c zs s‖ := norm_nonneg _
    linarith

/-- NON-CONTINUITY at the pole (weighted): if `w rho != 0` and
    `rho ∈ zs`, the weighted finite object is NOT continuous at `-rho`. -/
theorem weightedFiniteSumNotContinuousAtPole (w : ℂ → ℂ) (zs : Finset ℂ) (c : ℝ)
    (ρ : ℂ) (hr : ρ ∈ zs) (hwn : w ρ ≠ 0) :
    ¬ContinuousAt (weightedZeroSumMeromorphic w c zs) (-ρ) := by
  intro hcont
  set F : ℂ → ℂ := weightedZeroSumMeromorphic w c zs with hFdef
  have hblow : ∀ M : ℝ, ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ →
      M < ‖F s‖ := fun M => by
    simpa [hFdef] using weightedFiniteSumBlewUpAtPole w zs c ρ hr hwn M
  have hM' : ∃ δ > (0 : ℝ), ∀ s : ℂ, 0 < ‖s + ρ‖ → ‖s + ρ‖ < δ →
      ‖F (-ρ)‖ + 2 < ‖F s‖ := hblow (‖F (-ρ)‖ + 2)
  rcases hM' with ⟨δ, hδ, hblow'⟩
  rcases Metric.continuousAt_iff.mp hcont 1 (by norm_num) with ⟨δc, hδc, hcont'⟩
  set d := min δ δc
  have hdpos : 0 < d := lt_min hδ hδc
  set ε : ℝ := d / 3
  have hε : 0 < ε := by
    dsimp only [ε]
    exact div_pos hdpos (by norm_num)
  have hεsmall : ε < d := by
    dsimp only [ε]
    exact div_lt_self hdpos (by norm_num)
  set s1 : ℂ := -ρ + (ε : ℂ)
  have hsub : s1 + ρ = ((d / 3 : ℝ) : ℂ) := by
    dsimp only [s1, ε]
    ring
  have hnorm : ‖((d / 3 : ℝ) : ℂ)‖ = |(d / 3 : ℝ)| :=
    RCLike.norm_ofReal (d / 3 : ℝ)
  have habs : |(d / 3 : ℝ)| = d / 3 :=
    abs_of_pos (div_pos hdpos (by norm_num : (0 : ℝ) < 3))
  have hpos1 : 0 < ‖s1 + ρ‖ := by
    rw [hsub, hnorm, habs]
    linarith [hdpos]
  have hclose1 : ‖s1 + ρ‖ < δ := by
    rw [hsub, hnorm, habs]
    have hdle : d ≤ δ := min_le_left δ δc
    linarith [hεsmall, hdle]
  have hclose2 : dist s1 (-ρ) < δc := by
    rw [dist_eq_norm s1 (-ρ)]
    have hsub2 : s1 - (-ρ) = s1 + ρ := by ring
    rw [hsub2, hsub, hnorm, habs]
    have hdle : d ≤ δc := min_le_right δ δc
    linarith [hεsmall, hdle]
  have hblow1 : ‖F (-ρ)‖ + 2 < ‖F s1‖ := hblow' s1 hpos1 hclose1
  have hdist : dist (F s1) (F (-ρ)) < 1 := hcont' hclose2
  have htri : ‖F (-ρ)‖ ≥ ‖F s1‖ - ‖F s1 - F (-ρ)‖ := by
    have h1 : F (-ρ) = F s1 - (F s1 - F (-ρ)) := by abel
    calc
      ‖F (-ρ)‖ = ‖F s1 - (F s1 - F (-ρ))‖ := congrArg (fun x : ℂ => ‖x‖) h1
      _ ≥ ‖F s1‖ - ‖F s1 - F (-ρ)‖ := by
        have h2 : ‖F s1‖ = ‖(F s1 - (F s1 - F (-ρ))) + (F s1 - F (-ρ))‖ := by
          have : (F s1 - (F s1 - F (-ρ))) + (F s1 - F (-ρ)) = F s1 := by ring
          rw [this]
        rw [h2]
        linarith [norm_add_le (F s1 - (F s1 - F (-ρ))) (F s1 - F (-ρ))]
  have hdist2 : ‖F s1 - F (-ρ)‖ < 1 := by
    rw [dist_eq_norm (F s1) (F (-ρ))] at hdist
    exact hdist
  linarith [hblow1, hdist2, htri]

/-- Weighted pole-locus theorem: the weighted meromorphic finite object
    is continuous at `u` if and only if `u` is not the negation of a
    zero with NONZERO weight (zeros of zero weight are invisible). -/
theorem weightedPoleLocusIff (w : ℂ → ℂ) (zs : Finset ℂ) (c : ℝ) (u : ℂ) :
    ContinuousAt (weightedZeroSumMeromorphic w c zs) u ↔
        u ∉ {v : ℂ | ∃ (ρ : ℂ) (hr : ρ ∈ zs), v = -ρ ∧ w ρ ≠ 0} := by
  constructor
  · intro hcont
    by_contra hbad
    have hbad' : ∃ (ρ : ℂ) (hr : ρ ∈ zs), u = -ρ ∧ w ρ ≠ 0 := by simpa using hbad
    obtain ⟨ρ, hr, hneg, hwn⟩ := hbad'
    have hcont2 : ContinuousAt (weightedZeroSumMeromorphic w c zs) (-ρ) := by
      rw [hneg] at hcont
      exact hcont
    exact weightedFiniteSumNotContinuousAtPole w zs c ρ hr hwn hcont2
  · intro hnot
    exact weightedFiniteSumContinuousOffPoles w zs c u (by
      intro ρ hr hwn
      by_contra hn0
      have h0 : u + ρ = 0 := by simpa using hn0
      have heq : u = -ρ := by
        calc u = (u + ρ) + (-ρ) := by ring
          _ = -ρ := by rw [h0]; simp
      have hbad : u ∈ {v : ℂ | ∃ (ρ' : ℂ) (hr' : ρ' ∈ zs), v = -ρ' ∧ w ρ' ≠ 0} :=
        ⟨ρ, hr, by simpa [heq] using rfl, hwn⟩
      exact absurd hbad hnot)

/-! ## The packaged statement -/

/-- ESCAPE HATCH, CHARACTERIZED (packaged). For on-line zero sets with a
    repetition-free enumeration and the explicit weight of Part 2:
    (i) the D1E named gap HOLDS (the Danesh lifting input is satisfiable
        on the line - in sharp contrast to D1F, where weight 1 FAILS
        under line + VMM growth);
    (ii) the weight vanishes NOWHERE on the zero set, so no certified
        zero is erased by it;
    (iii) consequently EVERY finite certified slice containing a given
        zero rho carries, at -rho, the pole of the lifted object: the
        weighted finite object is NOT continuous there (Theorem
        `weightedFiniteSumNotContinuousAtPole`).
    The lifting through the named gap removes no obstruction: it only
    makes the meromorphic object well-defined, and every admissible
    weight keeps every certified pole. NO RH CLAIM: a property of
    conditional (enumerated, on-line) certified data; it neither assumes
    nor proves any part of RH. -/
theorem escapeHatchCharacterized
    (zsInf : Set ℂ) (c : ℝ)
    (f : ℕ → ℂ) (hmem : ∀ n, f n ∈ zsInf)
    (hfinj : Function.Injective f)
    (hsurj : ∀ (ρ : ℂ), ρ ∈ zsInf → ∃ n, f n = ρ)
    (hline : ∀ n, (f n).re = 1 / 2)
    (n₀ : ℕ) (hrho : f n₀ ∈ zsInf) :
    D1E.gap_infiniteLifting_convergence zsInf (injWeight f hfinj) c ∧
    injWeight f hfinj (f n₀) ≠ 0 ∧
    ∀ (zsf : Finset ℂ), (∀ (ρ' : ℂ), ρ' ∈ zsf → ρ' ∈ zsInf) → f n₀ ∈ zsf →
      ¬ContinuousAt (fun u : ℂ =>
        weightedZeroSumMeromorphic (injWeight f hfinj) c zsf u) (-f n₀) := by
  refine ⟨?_, ?_, ?_⟩
  · exact namedGapSatisfiedOnLine zsInf c f hmem hfinj hsurj hline
  · exact injWeight_nonzero f hfinj (f n₀) ⟨n₀, rfl⟩
  · intro zsf hzf hr'
    have hzero : ∃ n, f n = f n₀ := ⟨n₀, rfl⟩
    exact weightedFiniteSumNotContinuousAtPole (injWeight f hfinj) zsf c
      (f n₀) hr' (injWeight_nonzero f hfinj (f n₀) hzero)

end D1G
