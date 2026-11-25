import Mathlib
import RhAttack.OnlineZetaEta

open Set Complex Real
open BigOperators MeasureTheory Filter Topology

namespace OnlineZetaEta2

/-
honline Phase 2.1: the eta series on the half-plane 0 < Re s (first piece of the
identity-theorem extension of `OnlineZetaEta.etaIdentity`).

This module builds the conditional-convergence machinery for

    etaSeries(s) = ∑' n, (-1)^(n-1) / n^s     (0 < Re s)

in local lemmas (classical, no external input):

1. `abelSummation` — the finite Abel (partial-summation) identity (pure algebra,
   verified symbolically before transcription).
2. (later) `etaDiffBound` — the mean-value bound
   `‖n^{-s} - (n+1)^{-s}‖ ≤ ‖s‖ · n^{-(Re s + 1)}` for `0 < Re s`, `0 < n`.
3. (later) `etaSeriesSummableStrip` — `Summable (n ↦ (-1)^{n-1} / n^s)` for
   `0 < Re s`.

NO RH CLAIM. NO NEW AXIOMS. Machine-checked against pinned Mathlib v4.33.1.

ELABORATION NOTE: every theorem takes `s` and its hypotheses as explicit
parameters in its own header (pattern of OnlineZetaEta.lean).
-/

/-! ### 1. The finite Abel (partial-summation) identity

For sequences `aSeq`, `fSeq : ℕ → ℂ` and `A^{incl}_m := ∑ k ∈ range (m+1), aSeq k`
(so `aSeq m = A^{incl}_m - A^{incl}_{m-1}`), the identity (verified symbolically
for all `a ≥ 1`, `L ≥ 1`; empty last sum when `L = 1`):

```
∑ n ∈ range L, aSeq (a+n) · fSeq (a+n)
  = (∑ k ∈ range (a+L), aSeq k) · fSeq (a+L-1)
    - (∑ k ∈ range a, aSeq k) · fSeq a
    + ∑ j ∈ range (L-1), (∑ k ∈ range (a+j+1), aSeq k) · (fSeq (a+j) - fSeq (a+j+1))
```

This is the tool that turns "partial sums of `aSeq` bounded by 1" (the alternating
signs) + "differences of `fSeq` summable" into convergence of `Σ aSeq · fSeq`. -/

theorem abelSummation (a L : ℕ) (ha : 0 < a) (hL : 0 < L) (aSeq fSeq : ℕ → ℂ) :
    (∑ n ∈ Finset.range L, aSeq (a + n) * fSeq (a + n)) =
      (∑ k ∈ Finset.range (a + L), aSeq k) * fSeq (a + L - 1) -
      (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
      (∑ j ∈ Finset.range (L - 1),
        (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) := by
  -- Induction on L (step case: old value `L`, new value `L + 1`).
  induction' L with L ih
  · -- L = 0: excluded by hL
    exfalso
    omega
  · -- L + 1, with hL : 0 < L + 1
    by_cases hLpos : 0 < L
    · -- L ≥ 1: the induction hypothesis applies at L.
      have ih' := ih hLpos
      have hsum_split :
          (∑ n ∈ Finset.range (L + 1), aSeq (a + n) * fSeq (a + n)) =
            (∑ n ∈ Finset.range L, aSeq (a + n) * fSeq (a + n)) + aSeq (a + L) * fSeq (a + L) := by
        rw [Finset.sum_range_succ, add_comm]
      have hA : (∑ k ∈ Finset.range (a + L + 1), aSeq k) =
               (∑ k ∈ Finset.range (a + L), aSeq k) + aSeq (a + L) := by
        rw [Finset.sum_range_succ, add_comm]
      have hR : (∑ j ∈ Finset.range L,
              (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) =
            (∑ j ∈ Finset.range (L - 1),
              (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) +
            (∑ k ∈ Finset.range (a + L), aSeq k) * (fSeq (a + L - 1) - fSeq (a + L)) := by
        rw [show (Finset.range L : Finset ℕ) = Finset.range ((L - 1) + 1) from by
          rw [Nat.sub_add_cancel (by omega)],
          Finset.sum_range_succ,
          show (a + (L - 1)) + 1 = a + L from by omega,
          show a + (L - 1) = a + L - 1 from by omega]
      -- the (L + 1)-RHS is the L-RHS plus exactly aSeq (a+L) · fSeq (a+L)
      have hdiff :
          ((∑ k ∈ Finset.range (a + L + 1), aSeq k) * fSeq (a + L) -
             (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
             (∑ j ∈ Finset.range L,
               (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1)))) =
            ((∑ k ∈ Finset.range (a + L), aSeq k) * fSeq (a + L - 1) -
               (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
               (∑ j ∈ Finset.range (L - 1),
                 (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1)))) +
            aSeq (a + L) * fSeq (a + L) := by
        rw [hA, hR]
        ring
      -- normalize the goal's `a + (L + 1)` / `L + 1 - 1` shapes
      have hgoal_norm :
          (∑ k ∈ Finset.range (a + (L + 1)), aSeq k) * fSeq (a + (L + 1) - 1) -
            (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
            (∑ j ∈ Finset.range (L + 1 - 1),
              (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) =
            (∑ k ∈ Finset.range (a + L + 1), aSeq k) * fSeq (a + L) -
            (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
            (∑ j ∈ Finset.range L,
              (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) := by
        rw [show (a + (L + 1)) - 1 = a + L from by omega,
          show a + (L + 1) = a + L + 1 from by omega,
          show (L + 1) - 1 = L from by omega]
      rw [hgoal_norm]
      calc
        (∑ n ∈ Finset.range (L + 1), aSeq (a + n) * fSeq (a + n)) =
            (∑ n ∈ Finset.range L, aSeq (a + n) * fSeq (a + n)) + aSeq (a + L) * fSeq (a + L) := hsum_split
        _ = (((∑ k ∈ Finset.range (a + L), aSeq k) * fSeq (a + L - 1) -
               (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
               (∑ j ∈ Finset.range (L - 1),
                 (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1)))) +
            aSeq (a + L) * fSeq (a + L)) := by rw [ih']
        _ = (∑ k ∈ Finset.range (a + L + 1), aSeq k) * fSeq (a + L) -
            (∑ k ∈ Finset.range a, aSeq k) * fSeq a +
            (∑ j ∈ Finset.range L,
              (∑ k ∈ Finset.range (a + j + 1), aSeq k) * (fSeq (a + j) - fSeq (a + j + 1))) := by
          rw [hdiff]
    · -- L = 0 (base case: L = 1 in the new value)
      have hLzero : L = 0 := by omega
      subst L
      simp only [Nat.zero_add, Nat.add_zero, Nat.add_sub_cancel, Nat.sub_self,
        Finset.range_one, Finset.range_zero, Finset.sum_empty, zero_add, add_zero]
      rw [Finset.sum_singleton, Finset.sum_range_succ, Nat.add_zero]
      ring

/-! ### 2. The mean-value bound for the eta terms

For `0 < Re s` and `0 < n`:

```
‖n^{-s} - (n+1)^{-s}‖ ≤ ‖s‖ · n^{-(Re s + 1)}
```

via the derivative of `x ↦ (x : ℂ)^{-s}` on `[n, n+1]` and
`norm_sub_le_integral_of_norm_deriv_le_of_le`. -/

theorem etaDiffBound (s : ℂ) (hs : 0 < s.re) (n : ℕ) (hn : 0 < n) :
    ‖(n : ℂ) ^ (-s) - ((n + 1) : ℂ) ^ (-s)‖ ≤ ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := by
  set g : ℝ → ℂ := fun x ↦ (x : ℂ) ^ (-s) with hg_def
  -- the derivative of g at x > 0 is `-s * (x : ℂ)^{-s - 1}`
  have hdg : ∀ x : ℝ, 0 < x → deriv g x = -s * (x : ℂ) ^ (-s - 1) := by
    intro x hx0
    have hslit : (x : ℂ) ∈ slitPlane := by
      simp only [slitPlane]
      exact Or.inl (mod_cast hx0)
    -- the complex derivative of y ↦ y^{-s} at (x : ℂ)
    have hdgC : HasDerivAt (fun y : ℂ => y ^ (-s)) (-s * (x : ℂ) ^ (-s - 1)) (x : ℂ) := by
      simpa using HasDerivAt.cpow_const (c := (-s : ℂ)) (hasDerivAt_id (↑x : ℂ)) hslit
    -- restrict to the real line via the embedding
    have hdg' : HasDerivAt g (-s * (x : ℂ) ^ (-s - 1)) x := by
      simpa [hg_def] using hdgC.comp_ofReal
    exact hdg'.deriv
  -- its norm: ‖(x : ℂ)^z‖ = x^{z.re} for x > 0 (arg = 0 there)
  have hnormpow : ∀ x : ℝ, 0 < x → ‖(x : ℂ) ^ (-s - 1)‖ = x ^ (-s - 1).re := by
    intro x hx0
    have harg : arg (x : ℂ) = 0 := by
      simpa using arg_ofReal_of_nonneg (le_of_lt hx0)
    have habs : ‖(x : ℂ)‖ = x := by
      simpa [abs_of_pos hx0]
    have hnz : (x : ℂ) ≠ 0 := by
      by_contra h
      have := (Complex.ext_iff.mp h)
      norm_num at this
      linarith [this, hx0]
    calc
      ‖(x : ℂ) ^ (-s - 1)‖ = ‖(x : ℂ)‖ ^ (-s - 1).re / Real.exp (arg (x : ℂ) * (-s - 1).im) :=
        norm_cpow_of_ne_zero hnz (-s - 1)
      _ = ‖(x : ℂ)‖ ^ (-s - 1).re := by
        rw [harg, zero_mul, Real.exp_zero, div_one]
      _ = x ^ (-s - 1).re := by rw [habs]
  -- the exponent is negative: (-s - 1).re = -(s.re + 1) < 0
  have hexp : (-s - 1).re = -(s.re + 1) := by
    simp [Complex.neg_re]
    ring
  have hexpneg : 0 > (-s - 1).re := by
    rw [hexp]
    linarith [hs]
  -- monotonicity of x ↦ x^{(-s-1).re} on (0, ∞) with a negative exponent
  have hanti : AntitoneOn (fun x : ℝ => x ^ (-s - 1).re) (Set.Ioi (0 : ℝ)) :=
    antitoneOn_rpow_Ioi_of_exponent_nonpos (le_of_lt hexpneg)
  -- bound the derivative's norm on (n, n+1)
  have hderivbound : ∀ x : ℝ, x ∈ Set.Ioo (n : ℝ) (n + 1) → ‖deriv g x‖ ≤ ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := by
    intro x hx
    have hx0 : 0 < x := by
      have h₁ : (n : ℝ) < x := hx.1
      have h₂ : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    have h₁ : ‖deriv g x‖ = ‖-s * (x : ℂ) ^ (-s - 1)‖ := by
      rw [hdg x hx0]
    have h₂ : ‖-s * (x : ℂ) ^ (-s - 1)‖ = ‖-s‖ * ‖(x : ℂ) ^ (-s - 1)‖ := by
      rw [norm_mul]
    have h₃ : ‖-s‖ = ‖s‖ := by simp [norm_neg]
    have h₄ : ‖(x : ℂ) ^ (-s - 1)‖ = x ^ (-s - 1).re := hnormpow x hx0
    have h₅ : x ^ (-s - 1).re ≤ (n : ℝ) ^ (-s - 1).re := by
      have h₆ : (n : ℝ) ≤ x := hx.1.le
      have h₇ : 0 < (n : ℝ) := mod_cast hn
      exact hanti h₇ hx0 h₆
    have h₆ : (n : ℝ) ^ (-s - 1).re = (n : ℝ) ^ (-(s.re + 1)) := by rw [hexp]
    calc
      ‖deriv g x‖ = ‖-s * (x : ℂ) ^ (-s - 1)‖ := h₁
      _ = ‖-s‖ * ‖(x : ℂ) ^ (-s - 1)‖ := h₂
      _ = ‖s‖ * ‖(x : ℂ) ^ (-s - 1)‖ := by rw [h₃]
      _ = ‖s‖ * x ^ (-s - 1).re := by rw [h₄]
      _ ≤ ‖s‖ * (n : ℝ) ^ (-s - 1).re := by gcongr
      _ = ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := by rw [h₆]
  -- continuity / differentiability of g on the interval
  have hfc : ContinuousOn g (Set.Icc (n : ℝ) (n + 1)) := by
    have hslit : ∀ x : ℝ, x ∈ Set.Icc (n : ℝ) (n + 1) → (x : ℂ) ∈ slitPlane := by
      intro x hx
      simp only [slitPlane]
      exact Or.inl (by
        norm_cast
        have hnpos : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
        linarith [hx.1, hnpos])
    exact ContinuousOn.cpow_const Complex.continuous_ofReal.continuousOn hslit
  have hfd : DifferentiableOn ℝ g (Set.Ioo (n : ℝ) (n + 1)) := by
    intro x hx
    have hx0 : 0 < x := by
      have h₁ : (n : ℝ) < x := hx.1
      have h₂ : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    have hslit : (x : ℂ) ∈ slitPlane := by
      simp only [slitPlane]
      exact Or.inl (mod_cast hx0)
    have hdgC : HasDerivAt (fun y : ℂ => y ^ (-s)) _ (x : ℂ) :=
      HasDerivAt.cpow_const (c := (-s : ℂ)) (hasDerivAt_id (↑x : ℂ)) hslit
    have hda : HasDerivAt g _ x := hdgC.comp_ofReal
    exact hda.differentiableAt.differentiableWithinAt
  -- MVT-norm with the constant majorant B x := ‖s‖ · n^{-(σ+1)}
  have hB : IntervalIntegrable (fun _ : ℝ => ‖s‖ * (n : ℝ) ^ (-(s.re + 1))) MeasureTheory.volume (n : ℝ) (n + 1) :=
    intervalIntegrable_const (μ := MeasureTheory.volume) (a := (n : ℝ)) (b := (n + 1 : ℝ))
  have hMVT : ‖g (n + 1) - g n‖ ≤ ∫ x in (n : ℝ)..(n + 1 : ℝ), ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := by
    have hab : (n : ℝ) ≤ (n : ℝ) + 1 := by linarith
    refine norm_sub_le_integral_of_norm_deriv_le_of_le hab hfc hfd ?_ hB
    apply Filter.Eventually.of_forall
    intro x hx
    exact hderivbound x hx
  -- the integral of the constant is the constant (interval length 1)
  have hint : ∫ x in (n : ℝ)..(n + 1 : ℝ), ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) =
      ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := by
    rw [intervalIntegral.integral_const]
    simp [smul_one]
  calc
    ‖(n : ℂ) ^ (-s) - ((n + 1) : ℂ) ^ (-s)‖ =
        ‖((n : ℝ) : ℂ) ^ (-s) - (((n + 1) : ℝ) : ℂ) ^ (-s)‖ := by
      congr
      <;> norm_cast
    _ = ‖g (n : ℝ) - g (n + 1 : ℝ)‖ := by simp only [hg_def]
    _ = ‖g (n + 1) - g n‖ := by rw [← neg_sub, norm_neg]
    _ ≤ ∫ x in (n : ℝ)..(n + 1 : ℝ), ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := hMVT
    _ = ‖s‖ * (n : ℝ) ^ (-(s.re + 1)) := hint

/-! ### 3. The eta series: partial sums are Cauchy for `0 < Re s`

The alternating Dirichlet series `∑' n, (-1)^(n-1) / n^s` converges for every `s`
with `0 < Re s` (absolutely for `1 < Re s`, conditionally for `0 < Re s ≤ 1`).
We establish the Cauchy criterion for its partial sums directly, without passing
through `Summable`:

* `etaTerm` / `etaPartial` — terms and partial sums (the `n = 0` term is 0);
* `etaNormPow` — `‖(k : ℂ)^s‖ = k^{Re s}` for `k ≥ 1`;
* `etaAltPartialBound` — the alternating-sign partial sums `∑_{k ≤ m} (-1)^k`
  have norm `≤ 1` (telescoping: `2·A_m = 1 - (-1)^{m+1}`);
* `etaTailBound` — the key estimate: for `1 ≤ N ≤ M`, `0 < Re s`,
  `‖P_M - P_N‖ ≤ (2 + ‖s‖ / Re s) · N^{-Re s}` — via the finite Abel identity
  (`abelSummation`) with `aSeq k := -(-1)^k` (bounded partial sums),
  `fSeq k := (k : ℂ)^{-s}` (differences controlled by `etaDiffBound`), and the
  integral test for the antitone p-series `x ↦ x^{-(Re s + 1)}`;
* `etaPartialSumsCauchy` — the Cauchy criterion, since `N^{-Re s} → 0`.

NO RH CLAIM. NO NEW AXIOMS. -/

noncomputable def etaTerm (s : ℂ) (n : ℕ) : ℂ := (-1 : ℂ) ^ (n - 1) * (1 / (n : ℂ) ^ s)

noncomputable def etaPartial (s : ℂ) (N : ℕ) : ℂ := ∑ n ∈ Finset.range (N + 1), etaTerm s n

private noncomputable def altPartial (m : ℕ) : ℂ := ∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ k

/-- For `k ≥ 1`, `‖(k : ℂ)^s‖ = k^{Re s}` (argument of a positive real is 0). -/
lemma etaNormPow (s : ℂ) (k : ℕ) (hk : 0 < k) : ‖(k : ℂ) ^ s‖ = (k : ℝ) ^ s.re := by
  have hnpos : 0 < (k : ℝ) := Nat.cast_pos (α := ℝ).mpr hk
  have hnz : (k : ℂ) ≠ 0 := by
    by_contra h
    have := (Complex.ext_iff.mp h)
    norm_num at this
    linarith [this, hnpos]
  have harg : arg (k : ℂ) = 0 := by
    simpa using arg_ofReal_of_nonneg hnpos.le
  have habs : ‖(k : ℂ)‖ = (k : ℝ) := by
    simpa [abs_of_pos hnpos]
  calc
    ‖(k : ℂ) ^ s‖ = ‖(k : ℂ)‖ ^ s.re / Real.exp (arg (k : ℂ) * s.im) :=
      norm_cpow_of_ne_zero hnz s
    _ = ‖(k : ℂ)‖ ^ s.re := by
      rw [harg, zero_mul, Real.exp_zero, div_one]
    _ = (k : ℝ) ^ s.re := by rw [habs]

/-- The alternating partial sum `A_m = ∑_{k ≤ m} (-1)^k` satisfies
`2·A_m = 1 - (-1)^{m+1}` (telescoping), hence `‖A_m‖ ≤ 1` for all `m`. -/
lemma etaAltPartialBound (m : ℕ) : ‖altPartial m‖ ≤ 1 := by
  -- shift: `(-1) · A_m = ∑ j ∈ Ico 1 (m+2), (-1)^j`
  have hmap : Finset.map (addLeftEmbedding 1) (Finset.range (m + 1)) =
      Finset.Ico 1 (m + 2) := by
    ext x
    constructor
    · -- mp
      rw [Finset.mem_map, Finset.mem_Ico]
      rintro ⟨j, hj, rfl⟩
      simp only [addLeftEmbedding_apply, Finset.mem_range] at *
      exact ⟨by omega, by omega⟩
    · -- mpr
      rw [Finset.mem_map, Finset.mem_Ico]
      rintro ⟨h1, h2⟩
      apply Exists.intro (x - 1)
      constructor
      · simp only [Finset.mem_range]
        omega
      · simp only [addLeftEmbedding_apply]
        exact Nat.add_sub_of_le h1
  have hshift : (-1 : ℂ) * altPartial m = ∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j := by
    calc
      (-1 : ℂ) * altPartial m =
          (∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ k) * (-1 : ℂ) := by
        rw [altPartial, mul_comm]
      _ = ∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ k * (-1 : ℂ) := by
        rw [Finset.sum_mul]
      _ = ∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ (k + 1) := by
        apply Finset.sum_congr rfl
        intro k _
        exact (pow_succ ((-1 : ℂ)) k).symm
      _ = ∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ (1 + k) := by
        apply Finset.sum_congr rfl
        intro k _
        rw [Nat.add_comm]
      _ = ∑ x ∈ Finset.map (addLeftEmbedding 1) (Finset.range (m + 1)),
          (-1 : ℂ) ^ x := by
        have hsumimg : (∑ x ∈ Finset.image (addLeftEmbedding 1) (Finset.range (m + 1)),
            (-1 : ℂ) ^ x) =
            (∑ x ∈ Finset.range (m + 1), (-1 : ℂ) ^ ((addLeftEmbedding 1) x)) :=
          Finset.sum_image (f := fun x : ℕ => (-1 : ℂ) ^ x) (g := addLeftEmbedding 1)
            (s := Finset.range (m + 1)) (by
              intro x hx y hy h
              simp only [addLeftEmbedding_apply] at h
              omega)
        have hexp : (∑ k ∈ Finset.range (m + 1), (-1 : ℂ) ^ (1 + k)) =
            (∑ x ∈ Finset.range (m + 1), (-1 : ℂ) ^ ((addLeftEmbedding 1) x)) := by
          apply Finset.sum_congr rfl
          intro k _
          simp only [addLeftEmbedding_apply]
        rw [Finset.map_eq_image]
        exact hexp.trans hsumimg.symm
      _ = ∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j := by rw [hmap]
  -- the Ico sum: `∑_{j=1}^{m+1} (-1)^j = A_m + (-1)^{m+1} - 1`
  have hsumIco : (∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j) =
      altPartial m + (-1 : ℂ) ^ (m + 1) - 1 := by
    have hU : Finset.range (m + 2) = Finset.range 1 ∪ Finset.Ico 1 (m + 2) := by
      rw [show Finset.range (m + 2) = Finset.range (1 + (m + 1)) from by ring,
        Finset.range_add,
        show Finset.map (addLeftEmbedding 1) (Finset.range (m + 1)) =
            Finset.Ico 1 (m + 2) from hmap]
    have hdisj : Disjoint (Finset.range 1) (Finset.Ico 1 (m + 2)) := by
      rw [Finset.disjoint_left]
      intro x hx hx'
      simp only [Finset.mem_range, Finset.mem_Ico] at hx hx'
      omega
    have h1 : (∑ x ∈ Finset.range (m + 2), (-1 : ℂ) ^ x) =
        (∑ x ∈ Finset.range 1, (-1 : ℂ) ^ x) + (∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j) := by
      rw [hU, Finset.sum_union hdisj]
    have h3 : (∑ x ∈ Finset.range (m + 2), (-1 : ℂ) ^ x) =
        altPartial m + (-1 : ℂ) ^ (m + 1) := by
      rw [altPartial, show Finset.range (m + 2) = Finset.range ((m + 1) + 1) from by ring,
        Finset.sum_range_succ]
    calc
      (∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j) =
          (∑ x ∈ Finset.range (m + 2), (-1 : ℂ) ^ x) - 1 := by
        calc
          _ = (∑ x ∈ Finset.range 1, (-1 : ℂ) ^ x) +
              (∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j) - 1 := by ring
          _ = (∑ x ∈ Finset.range (m + 2), (-1 : ℂ) ^ x) - 1 := by rw [← h1]
      _ = (altPartial m + (-1 : ℂ) ^ (m + 1)) - 1 := by rw [h3]
      _ = altPartial m + (-1 : ℂ) ^ (m + 1) - 1 := by ring
  -- the telescope: `2 · A_m = 1 - (-1)^{m+1}`
  have htele : 2 * altPartial m = 1 - (-1 : ℂ) ^ (m + 1) := by
    calc
      2 * altPartial m = ((1 : ℂ) - (-1 : ℂ)) * altPartial m := by ring
      _ = altPartial m - (-1 : ℂ) * altPartial m := by ring
      _ = altPartial m - (∑ j ∈ Finset.Ico 1 (m + 2), (-1 : ℂ) ^ j) := by
        rw [hshift]
      _ = altPartial m - (altPartial m + (-1 : ℂ) ^ (m + 1) - 1) := by
        rw [hsumIco]
      _ = 1 - (-1 : ℂ) ^ (m + 1) := by ring
  have hA : altPartial m = (1 - (-1 : ℂ) ^ (m + 1)) / 2 := by
    apply mul_left_cancel₀ (show (2 : ℂ) ≠ 0 from by norm_num)
    calc
      2 * altPartial m = 1 - (-1 : ℂ) ^ (m + 1) := htele
      _ = 2 * ((1 - (-1 : ℂ) ^ (m + 1)) / 2) := by ring
  calc
    ‖altPartial m‖ = ‖(1 - (-1 : ℂ) ^ (m + 1)) / 2‖ := by rw [hA]
    _ = ‖1 - (-1 : ℂ) ^ (m + 1)‖ / ‖(2 : ℂ)‖ := by rw [norm_div]
    _ = ‖1 - (-1 : ℂ) ^ (m + 1)‖ / 2 := by
      rw [show ‖(2 : ℂ)‖ = 2 from by norm_num]
    _ ≤ 2 / 2 := by
      gcongr
      · calc
          ‖1 - (-1 : ℂ) ^ (m + 1)‖ ≤ ‖(1 : ℂ)‖ + ‖(-1 : ℂ) ^ (m + 1)‖ :=
            norm_sub_le (1 : ℂ) ((-1 : ℂ) ^ (m + 1))
          _ = 1 + ‖(-1 : ℂ) ^ (m + 1)‖ := by rw [norm_one]
          _ = 2 := by
            have h1 : ‖(-1 : ℂ) ^ (m + 1)‖ = 1 := by
              calc
                ‖(-1 : ℂ) ^ (m + 1)‖ = ‖(-1 : ℂ)‖ ^ (m + 1) := by
                  rw [norm_pow]
                _ = 1 ^ (m + 1) := by norm_num
                _ = 1 := by simp
            rw [h1]
            norm_num
    _ = 1 := by norm_num

/-- Key estimate for the eta partial sums: for `1 ≤ N ≤ M` and `0 < Re s`,
`‖P_M - P_N‖ ≤ (2 + ‖s‖ / Re s) · N^{-Re s}`. -/
theorem etaTailBound (s : ℂ) (hs : 0 < s.re) (M N : ℕ) (hN : 1 ≤ N) (hNM : N ≤ M) :
    ‖etaPartial s M - etaPartial s N‖ ≤ (2 + ‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by
  by_cases hMN : M = N
  · -- M = N: the difference is 0 and the bound is nonnegative
    subst M
    simp only [etaPartial, sub_self, norm_zero]
    have hc : 0 ≤ 2 + ‖s‖ / s.re := by
      apply add_nonneg
      · norm_num
      · exact div_nonneg (norm_nonneg s) (le_of_lt hs)
    exact mul_nonneg hc (rpow_nonneg (Nat.cast_nonneg N) (-s.re))
  · -- N < M: Abel decomposition + mean-value differences + integral test
    have hNM' : N < M := Nat.lt_of_le_of_ne hNM (Ne.symm hMN)
    have hL : 0 < M - N := Nat.sub_pos_of_lt hNM'
    have hNpos : 0 < N := by omega
    -- segment: `P_M - P_N = ∑ k ∈ Ico (N+1) (M+1), etaTerm s k`
    have hsplit : etaPartial s M - etaPartial s N =
        ∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k := by
      have hmap : Finset.map (addLeftEmbedding (N + 1)) (Finset.range (M - N)) =
          Finset.Ico (N + 1) (M + 1) := by
        ext x
        constructor
        · -- mp
          rw [Finset.mem_map, Finset.mem_Ico]
          rintro ⟨j, hj, rfl⟩
          simp only [addLeftEmbedding_apply, Finset.mem_range] at *
          exact ⟨by omega, by omega⟩
        · -- mpr
          rw [Finset.mem_map, Finset.mem_Ico]
          rintro ⟨h1, h2⟩
          apply Exists.intro (x - (N + 1))
          constructor
          · simp only [Finset.mem_range]
            omega
          · simp only [addLeftEmbedding_apply]
            exact Nat.add_sub_of_le h1
      have hU : Finset.range (M + 1) = Finset.range (N + 1) ∪ Finset.Ico (N + 1) (M + 1) := by
        have hshow : M + 1 = (N + 1) + (M - N) := by
          have hd : M = N + (M - N) := (Nat.add_sub_of_le hNM).symm
          rw [hd]
          omega
        rw [show Finset.range (M + 1) = Finset.range ((N + 1) + (M - N)) from
            congrArg Finset.range hshow,
          Finset.range_add, hmap]
      have hdisj : Disjoint (Finset.range (N + 1)) (Finset.Ico (N + 1) (M + 1)) := by
        rw [Finset.disjoint_left]
        intro x hx hx'
        simp only [Finset.mem_range, Finset.mem_Ico] at hx hx'
        omega
      have h1 : (∑ k ∈ Finset.range (M + 1), etaTerm s k) =
          (∑ k ∈ Finset.range (N + 1), etaTerm s k) +
          (∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k) := by
        rw [hU, Finset.sum_union hdisj]
      rw [show etaPartial s M =
          etaPartial s N + ∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k from by
            rw [etaPartial, etaPartial, h1]]
      simp only [etaPartial]
      exact add_sub_cancel_left _ _
    -- term factorization: `etaTerm s k = -(-1)^k · (k : ℂ)^{-s}` for `k ≥ 1`
    have hterm : ∀ k, 1 ≤ k → etaTerm s k = -((-1 : ℂ) ^ k) * ((k : ℂ) ^ (-s)) := by
      intro k hk
      have hrel : (-1 : ℂ) ^ (k - 1) = -((-1 : ℂ) ^ k) := by
        have hcalc : (-1 : ℂ) ^ k = (-1 : ℂ) * (-1 : ℂ) ^ (k - 1) := by
          conv =>
            lhs
            rw [(Nat.add_sub_of_le hk).symm, pow_add]
          ring
        rw [hcalc]
        ring
      calc
        etaTerm s k = (-1 : ℂ) ^ (k - 1) * (1 / (k : ℂ) ^ s) := rfl
        _ = -((-1 : ℂ) ^ k) * (1 / (k : ℂ) ^ s) := by rw [hrel]
        _ = -((-1 : ℂ) ^ k) * ((k : ℂ) ^ (-s)) := by
          rw [show (1 / (k : ℂ) ^ s) = (k : ℂ) ^ (-s) from by
            rw [one_div, Complex.cpow_neg]]
    -- the Abel decomposition (`abelSummation` with `a := N + 1`, `L := M - N`)
    set T1 := (∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) * ((M : ℂ) ^ (-s)) with hT1
    set T2 := (∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) * ((N + 1 : ℂ) ^ (-s)) with hT2
    set T3 := (∑ j ∈ Finset.range (M - N - 1),
      (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
      (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))) with hT3
    have habel : (∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k) = T1 - T2 + T3 := by
      have hraw := abelSummation (N + 1) (M - N) (by omega) hL
        (aSeq := fun k => -((-1 : ℂ) ^ k)) (fSeq := fun k => (Nat.cast k : ℂ) ^ (-s))
      have hshiftL : (∑ n ∈ Finset.range (M - N),
              -((-1 : ℂ) ^ (N + 1 + n)) * (((N + 1 + n) : ℂ) ^ (-s))) =
          (∑ k ∈ Finset.Ico (N + 1) (M + 1),
            -((-1 : ℂ) ^ k) * ((k : ℂ) ^ (-s))) := by
        have hmap : Finset.map (addLeftEmbedding (N + 1)) (Finset.range (M - N)) =
            Finset.Ico (N + 1) (M + 1) := by
          ext x
          constructor
          · -- mp
            rw [Finset.mem_map, Finset.mem_Ico]
            rintro ⟨j, hj, rfl⟩
            simp only [addLeftEmbedding_apply, Finset.mem_range] at *
            exact ⟨by omega, by omega⟩
          · -- mpr
            rw [Finset.mem_map, Finset.mem_Ico]
            rintro ⟨h1, h2⟩
            apply Exists.intro (x - (N + 1))
            constructor
            · simp only [Finset.mem_range]
              omega
            · simp only [addLeftEmbedding_apply]
              exact Nat.add_sub_of_le h1
        calc
          (∑ n ∈ Finset.range (M - N),
              -((-1 : ℂ) ^ (N + 1 + n)) * (((N + 1 + n) : ℂ) ^ (-s))) =
              (∑ x ∈ Finset.map (addLeftEmbedding (N + 1)) (Finset.range (M - N)),
                -((-1 : ℂ) ^ x) * ((x : ℂ) ^ (-s))) := by
            have hsumimg : (∑ x ∈ Finset.image (addLeftEmbedding (N + 1))
                (Finset.range (M - N)), -((-1 : ℂ) ^ x) * ((x : ℂ) ^ (-s))) =
                (∑ x ∈ Finset.range (M - N),
                  -((-1 : ℂ) ^ ((addLeftEmbedding (N + 1)) x)) *
                  (((addLeftEmbedding (N + 1)) x : ℂ) ^ (-s))) :=
              Finset.sum_image
                (f := fun x : ℕ => -((-1 : ℂ) ^ x) * ((x : ℂ) ^ (-s)))
                (g := addLeftEmbedding (N + 1)) (s := Finset.range (M - N)) (by
                  intro x hx y hy h
                  simp only [addLeftEmbedding_apply] at h
                  omega)
            have hexp : (∑ n ∈ Finset.range (M - N),
                    -((-1 : ℂ) ^ (N + 1 + n)) * (((N + 1 + n) : ℂ) ^ (-s))) =
                (∑ x ∈ Finset.range (M - N),
                  -((-1 : ℂ) ^ ((addLeftEmbedding (N + 1)) x)) *
                  (((addLeftEmbedding (N + 1)) x : ℂ) ^ (-s))) := by
              apply Finset.sum_congr rfl
              intro n _
              simp only [addLeftEmbedding_apply]
              norm_cast
            rw [Finset.map_eq_image]
            exact hexp.trans hsumimg.symm
          _ = (∑ k ∈ Finset.Ico (N + 1) (M + 1),
                -((-1 : ℂ) ^ k) * ((k : ℂ) ^ (-s))) := by rw [hmap]
      have htop : (∑ k ∈ Finset.range (N + 1 + (M - N)), -((-1 : ℂ) ^ k)) *
          (Nat.cast ((N + 1 + (M - N)) - 1) : ℂ) ^ (-s) =
          (∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) * ((M : ℂ) ^ (-s)) := by
        have h2n : N + 1 + (M - N) = M + 1 := by omega
        rw [h2n, Nat.add_sub_cancel]
      have hthird : (∑ j ∈ Finset.range (M - N - 1),
              (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
              ((Nat.cast (N + 1 + j) : ℂ) ^ (-s) -
                (Nat.cast (N + 1 + j + 1) : ℂ) ^ (-s))) =
          (∑ j ∈ Finset.range (M - N - 1),
            (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
            (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))) := by
        apply Finset.sum_congr rfl
        intro j _
        rw [show (Nat.cast (N + 1 + j) : ℂ) = (N + 1 + j : ℂ) from by norm_cast,
          show (Nat.cast (N + 1 + j + 1) : ℂ) = ((N + 2 + j) : ℂ) from by
            norm_cast
            omega]
      calc
        (∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k) =
            (∑ k ∈ Finset.Ico (N + 1) (M + 1),
              -((-1 : ℂ) ^ k) * ((k : ℂ) ^ (-s))) := by
          apply Finset.sum_congr rfl
          intro k hk
          have hk1 : 1 ≤ k := by
            simp only [Finset.mem_Ico] at hk
            omega
          rw [hterm k hk1]
        _ = (∑ n ∈ Finset.range (M - N),
              -((-1 : ℂ) ^ (N + 1 + n)) * ((Nat.cast (N + 1 + n) : ℂ) ^ (-s))) := by
          rw [← hshiftL]
          apply Finset.sum_congr rfl
          intro n _
          rw [show (N + 1 + n : ℂ) = (Nat.cast (N + 1 + n) : ℂ) from by norm_cast]
        _ = (∑ k ∈ Finset.range (N + 1 + (M - N)), -((-1 : ℂ) ^ k)) *
            ((Nat.cast ((N + 1 + (M - N)) - 1) : ℂ) ^ (-s)) -
            (∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) *
            ((Nat.cast (N + 1) : ℂ) ^ (-s)) +
            (∑ j ∈ Finset.range (M - N - 1),
              (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
              ((Nat.cast (N + 1 + j) : ℂ) ^ (-s) -
                (Nat.cast (N + 1 + j + 1) : ℂ) ^ (-s))) := by
          rw [← hraw]
        _ = (∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) * ((M : ℂ) ^ (-s)) -
            (∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) *
            ((Nat.cast (N + 1) : ℂ) ^ (-s)) +
            (∑ j ∈ Finset.range (M - N - 1),
              (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
              (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))) := by
          rw [htop, hthird]
        _ = (∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) * ((M : ℂ) ^ (-s)) -
            (∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) * ((N + 1 : ℂ) ^ (-s)) +
            (∑ j ∈ Finset.range (M - N - 1),
              (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
              (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))) := by
          rw [show (Nat.cast (N + 1) : ℂ) = (N + 1 : ℂ) from by norm_cast]
    -- norm of the Abel decomposition
    calc
      ‖etaPartial s M - etaPartial s N‖ =
          ‖∑ k ∈ Finset.Ico (N + 1) (M + 1), etaTerm s k‖ := by rw [hsplit]
      _ = ‖T1 - T2 + T3‖ := by rw [habel]
      _ ≤ ‖T1‖ + ‖T2‖ + ‖T3‖ := by
        calc
          ‖T1 - T2 + T3‖ ≤ ‖T1 - T2‖ + ‖T3‖ :=
            norm_add_le (T1 - T2) T3
          _ ≤ (‖T1‖ + ‖T2‖) + ‖T3‖ := by
            gcongr
            exact norm_sub_le T1 T2
          _ = ‖T1‖ + ‖T2‖ + ‖T3‖ := by ring
      _ ≤ (M : ℝ) ^ (-s.re) + (N + 1 : ℝ) ^ (-s.re) + ‖T3‖ := by
        gcongr
        · calc
            ‖T1‖ = ‖(∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) *
                ((M : ℂ) ^ (-s))‖ := by rw [hT1]
            _ = ‖∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)‖ *
                ‖(M : ℂ) ^ (-s)‖ := by rw [norm_mul]
            _ ≤ 1 * ‖(M : ℂ) ^ (-s)‖ := by
              gcongr
              have hA : (∑ k ∈ Finset.range (M + 1), -((-1 : ℂ) ^ k)) =
                  -((∑ k ∈ Finset.range (M + 1), (-1 : ℂ) ^ k)) := by
                rw [Finset.sum_neg_distrib]
              rw [hA, norm_neg]
              simpa [altPartial] using etaAltPartialBound M
            _ = ‖(M : ℂ) ^ (-s)‖ := by rw [one_mul]
            _ = (M : ℝ) ^ (-s.re) := by
              have hMpos : 0 < M := by omega
              rw [etaNormPow (-s) M hMpos]
              simp [Complex.neg_re]
        · calc
            ‖T2‖ = ‖(∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) *
                ((N + 1 : ℂ) ^ (-s))‖ := by rw [hT2]
            _ = ‖∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)‖ *
                ‖(N + 1 : ℂ) ^ (-s)‖ := by rw [norm_mul]
            _ ≤ 1 * ‖(N + 1 : ℂ) ^ (-s)‖ := by
              gcongr
              have hA : (∑ k ∈ Finset.range (N + 1), -((-1 : ℂ) ^ k)) =
                  -((∑ k ∈ Finset.range (N + 1), (-1 : ℂ) ^ k)) := by
                rw [Finset.sum_neg_distrib]
              rw [hA, norm_neg]
              simpa [altPartial] using etaAltPartialBound N
            _ = ‖(N + 1 : ℂ) ^ (-s)‖ := by rw [one_mul]
            _ = (N + 1 : ℝ) ^ (-s.re) := by
              have hb : (N + 1 : ℂ) = (Nat.cast (N + 1) : ℂ) := by
                simp [Nat.cast_add, Nat.cast_one]
              rw [hb, etaNormPow (-s) (N + 1) (by omega : 0 < N + 1)]
              norm_cast
      _ ≤ (M : ℝ) ^ (-s.re) + (N + 1 : ℝ) ^ (-s.re) +
          (∑ j ∈ Finset.range (M - N - 1),
            ‖((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s)‖) := by
        gcongr
        · calc
            ‖T3‖ = ‖∑ j ∈ Finset.range (M - N - 1),
                (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
                (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))‖ := by
              rw [hT3]
            _ ≤ ∑ j ∈ Finset.range (M - N - 1),
                ‖(∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) *
                (((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s))‖ := by
              apply norm_sum_le
            _ = ∑ j ∈ Finset.range (M - N - 1),
                ‖∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)‖ *
                ‖((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s)‖ := by
              apply Finset.sum_congr rfl
              intro j _
              rw [norm_mul]
            _ ≤ ∑ j ∈ Finset.range (M - N - 1),
                1 * ‖((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s)‖ := by
              gcongr
              have hA : (∑ k ∈ Finset.range (N + 1 + j + 1), -((-1 : ℂ) ^ k)) =
                  -((∑ k ∈ Finset.range (N + 1 + j + 1), (-1 : ℂ) ^ k)) := by
                rw [Finset.sum_neg_distrib]
              simpa [hA, norm_neg, altPartial] using etaAltPartialBound (N + 1 + j)
            _ = ∑ j ∈ Finset.range (M - N - 1),
                ‖((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s)‖ := by
              apply Finset.sum_congr rfl
              intro j _
              rw [one_mul]
      _ ≤ (M : ℝ) ^ (-s.re) + (N + 1 : ℝ) ^ (-s.re) +
          ‖s‖ * (∑ j ∈ Finset.range (M - N - 1), (N + 1 + j : ℝ) ^ (-(s.re + 1))) := by
        gcongr
        · calc
            (∑ j ∈ Finset.range (M - N - 1),
              ‖((N + 1 + j) : ℂ) ^ (-s) - ((N + 2 + j) : ℂ) ^ (-s)‖) ≤
              (∑ j ∈ Finset.range (M - N - 1),
                ‖s‖ * (N + 1 + j : ℝ) ^ (-(s.re + 1))) := by
              gcongr
              have h := etaDiffBound s hs (N + 1 + j) (by omega)
              simpa [show ((N + 1 + j + 1) : ℂ) = ((N + 2 + j) : ℂ) from by
                norm_cast
                omega] using h
            _ = ‖s‖ * (∑ j ∈ Finset.range (M - N - 1),
                (N + 1 + j : ℝ) ^ (-(s.re + 1))) := by
              rw [← Finset.mul_sum]
      _ ≤ (M : ℝ) ^ (-s.re) + (N + 1 : ℝ) ^ (-s.re) +
          ‖s‖ * ((N : ℝ) ^ (-s.re) / s.re) := by
        gcongr
        · -- the j-sum ≤ ∫ x in Ioi N, x^{-(σ+1)} (integral test, via the tsum tail)
          have hanti : AntitoneOn (fun x : ℝ => x ^ (-(s.re + 1) : ℝ)) (Ici (N : ℝ)) := by
            have h1 : AntitoneOn (fun x : ℝ => x ^ (-(s.re + 1) : ℝ)) (Ioi (0 : ℝ)) :=
              antitoneOn_rpow_Ioi_of_exponent_nonpos (by linarith [hs])
            exact h1.mono (by
              intro x hx
              dsimp only [Ioi, Ici, Set.mem_ofPred_eq] at hx ⊢
              have hN0 : 0 < (N : ℝ) := Nat.cast_pos.mpr hNpos
              linarith [hx, hN0])
          have hinteg : IntegrableOn (fun x : ℝ => x ^ (-(s.re + 1) : ℝ)) (Ioi (N : ℝ)) :=
            OnlineZeta.integrableIoiRpowNeg (by linarith [hs]) N hNpos
          have hnn : ∀ t ∈ Ioi (N : ℝ), 0 ≤ t ^ (-(s.re + 1) : ℝ) := by
            intro t ht
            exact rpow_nonneg (by
              have hN0 : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
              linarith [hN0, by simpa using ht]) (-(s.re + 1))
          set g : ℕ → ℝ := fun n => (n : ℝ) ^ (-(s.re + 1) : ℝ) with hg_def
          have hsum : Summable g :=
            AntitoneOn.summable_of_integrableOn_Ioi (f := fun x : ℝ => x ^ (-(s.re + 1) : ℝ))
              (N := 1)
              ((OnlineZeta.rpowNegAntitone (σ := s.re + 1) (by linarith [hs])).mono (by
                intro x hx
                rw [Nat.cast_one] at hx
                exact hx))
              (OnlineZeta.integrableIoiRpowNeg (by linarith [hs]) 1 (by norm_num))
              (by
                intro t ht
                exact rpow_nonneg (by
                  have h1 : (0 : ℝ) ≤ (1 : ℝ) := by norm_num
                  linarith [h1, by simpa using ht]) (-(s.re + 1)))
          have hshift : Summable (fun n => g (n + N + 1)) := by
            have h' : Summable (fun n => g (n + (N + 1))) := by
              rw [summable_nat_add_iff (N + 1)]
              exact hsum
            convert h' using 1
            funext n
            ring_nf
          have hnonneg : ∀ i ∉ Finset.range (M - N - 1), 0 ≤ g (i + N + 1) := by
            intro i _
            exact rpow_nonneg (by
              norm_cast
              omega) (-(s.re + 1))
          calc
            (∑ j ∈ Finset.range (M - N - 1), (N + 1 + j : ℝ) ^ (-(s.re + 1))) ≤
                (∑' n : ℕ, g (n + N + 1)) := by
              have hlhs : (∑ j ∈ Finset.range (M - N - 1),
                      (N + 1 + j : ℝ) ^ (-(s.re + 1))) =
                  ∑ j ∈ Finset.range (M - N - 1), g (j + N + 1) := by
                apply Finset.sum_congr rfl
                intro j _
                have hb : (N + 1 + j : ℝ) = ((j + N + 1) : ℝ) := by
                  norm_cast
                  ring
                rw [hb]
                simp only [hg_def]
                rw [show (↑j + ↑N + 1 : ℝ) = (Nat.cast (j + N + 1) : ℝ) from by
                  norm_cast]
              rw [hlhs]
              exact Summable.sum_le_tsum (Finset.range (M - N - 1)) hnonneg hshift
            _ ≤ ∫ x in Ioi (N : ℝ), x ^ (-(s.re + 1) : ℝ) := by
              exact AntitoneOn.tsum_comp_add_le_integral N hanti hinteg hnn
            _ = (N : ℝ) ^ (-s.re) / s.re := by
              rw [OnlineZeta.integralIoiRpowNeg (by linarith [hs]) N hNpos]
              congr
              <;> ring
      _ ≤ (2 + ‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by
        have hMleN : (M : ℝ) ^ (-s.re) ≤ (N : ℝ) ^ (-s.re) := by
          apply (OnlineZeta.rpowNegAntitone (by linarith [hs]) :
            AntitoneOn (fun x : ℝ => x ^ (-s.re)) (Ici 1))
          · simp only [Set.mem_Ici]
            exact mod_cast hN
          · simp only [Set.mem_Ici]
            exact mod_cast Nat.le_trans hN hNM
          · exact mod_cast hNM
        have hN1le : (N + 1 : ℝ) ^ (-s.re) ≤ (N : ℝ) ^ (-s.re) := by
          apply (OnlineZeta.rpowNegAntitone (by linarith [hs]) :
            AntitoneOn (fun x : ℝ => x ^ (-s.re)) (Ici 1))
          · simp only [Set.mem_Ici]
            exact mod_cast hN
          · simp only [Set.mem_Ici]
            exact mod_cast (by omega)
          · exact mod_cast (by omega)
        calc
          _ = (M : ℝ) ^ (-s.re) + (N + 1 : ℝ) ^ (-s.re) +
              ‖s‖ * ((N : ℝ) ^ (-s.re) / s.re) := by ring
          _ ≤ (N : ℝ) ^ (-s.re) + (N : ℝ) ^ (-s.re) +
              ‖s‖ * ((N : ℝ) ^ (-s.re) / s.re) := by
            gcongr
          _ = 2 * (N : ℝ) ^ (-s.re) + (‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by
            have h1 : ‖s‖ * ((N : ℝ) ^ (-s.re) / s.re) =
                (‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by
              field_simp [ne_of_gt hs]
            rw [h1]
            ring
          _ = (2 + ‖s‖ / s.re) * (N : ℝ) ^ (-s.re) := by ring

/-- The partial sums of the eta series form a Cauchy sequence for `0 < Re s`. -/
theorem etaPartialSumsCauchy (s : ℂ) (hs : 0 < s.re) :
    CauchySeq (fun N : ℕ => etaPartial s N) := by
  rw [Metric.cauchySeq_iff]
  intro ε hε
  set c := 2 + ‖s‖ / s.re with hc_def
  have hc : 0 < c := by
    rw [hc_def]
    have hdiv : 0 ≤ (‖s‖ : ℝ) / s.re :=
      div_nonneg (norm_nonneg s) (le_of_lt hs)
    exact lt_of_lt_of_le (show (0 : ℝ) < 2 from by norm_num)
      (le_add_of_nonneg_right hdiv)
  have hδ : 0 < ε / c := div_pos hε hc
  -- eventually `(n : ℝ)^{-Re s} < ε / c` (since `(n : ℝ)^{-Re s} → 0`)
  have h1 : Tendsto (fun x : ℝ => x ^ (-s.re)) atTop (𝓝 0) := tendsto_rpow_neg_atTop hs
  have h2 : Tendsto (fun n : ℕ => (n : ℝ) ^ (-s.re)) atTop (𝓝 0) :=
    h1.comp tendsto_natCast_atTop_atTop
  have hU : {n : ℕ | (n : ℝ) ^ (-s.re) ∈ Metric.ball (0 : ℝ) (ε / c)} ∈ atTop := by
    rw [← Filter.mem_map']
    exact h2 (Metric.ball_mem_nhds 0 hδ)
  obtain ⟨N0, hN0⟩ := Filter.mem_atTop_sets.mp hU
  use max 1 N0
  intro m hm n hn
  have hm1 : 1 ≤ m := by
    have := le_max_left 1 N0
    linarith [hm, this]
  have hn1 : 1 ≤ n := by
    have := le_max_left 1 N0
    linarith [hn, this]
  cases le_total m n with
  | inl hmn =>
    have hbnd := etaTailBound s hs n m hm1 hmn
    calc
      dist (etaPartial s m) (etaPartial s n) = ‖etaPartial s m - etaPartial s n‖ := by
        exact dist_eq_norm _ _
      _ = ‖etaPartial s n - etaPartial s m‖ := by rw [← neg_sub, norm_neg]
      _ ≤ (2 + ‖s‖ / s.re) * (m : ℝ) ^ (-s.re) := hbnd
      _ = (c : ℝ) * (m : ℝ) ^ (-s.re) := by rw [hc_def]
      _ < ε := by
        have hsmallm : (m : ℝ) ^ (-s.re) < ε / c := by
          have hm0 : N0 ≤ m := le_trans (le_max_right 1 N0) hm
          have hmem : (m : ℝ) ^ (-s.re) ∈ Metric.ball (0 : ℝ) (ε / c) := hN0 m hm0
          have hdist : dist ((m : ℝ) ^ (-s.re)) 0 < ε / c := by simpa using hmem
          have hnn : 0 ≤ (m : ℝ) ^ (-s.re) :=
            rpow_nonneg (by
              norm_cast
              omega) (-s.re)
          have hnorm : dist ((m : ℝ) ^ (-s.re)) 0 = ‖(m : ℝ) ^ (-s.re)‖ := by simp
          rw [hnorm, Real.norm_eq_abs, abs_of_nonneg hnn] at hdist
          exact hdist
        calc
          (c : ℝ) * (m : ℝ) ^ (-s.re) < (c : ℝ) * (ε / c) := by
            apply mul_lt_mul_of_pos_left hsmallm hc
          _ = ε := by
            field_simp [ne_of_gt hc]
  | inr hnm =>
    have hbnd := etaTailBound s hs m n hn1 hnm
    calc
      dist (etaPartial s m) (etaPartial s n) = ‖etaPartial s m - etaPartial s n‖ := by
        exact dist_eq_norm _ _
      _ ≤ (2 + ‖s‖ / s.re) * (n : ℝ) ^ (-s.re) := hbnd
      _ = (c : ℝ) * (n : ℝ) ^ (-s.re) := by rw [hc_def]
      _ < ε := by
        have hsmalln : (n : ℝ) ^ (-s.re) < ε / c := by
          have hn0 : N0 ≤ n := le_trans (le_max_right 1 N0) hn
          have hmem : (n : ℝ) ^ (-s.re) ∈ Metric.ball (0 : ℝ) (ε / c) := hN0 n hn0
          have hdist : dist ((n : ℝ) ^ (-s.re)) 0 < ε / c := by simpa using hmem
          have hnn : 0 ≤ (n : ℝ) ^ (-s.re) :=
            rpow_nonneg (by
              norm_cast
              omega) (-s.re)
          have hnorm : dist ((n : ℝ) ^ (-s.re)) 0 = ‖(n : ℝ) ^ (-s.re)‖ := by simp
          rw [hnorm, Real.norm_eq_abs, abs_of_nonneg hnn] at hdist
          exact hdist
        calc
          (c : ℝ) * (n : ℝ) ^ (-s.re) < (c : ℝ) * (ε / c) := by
            apply mul_lt_mul_of_pos_left hsmalln hc
          _ = ε := by
            field_simp [ne_of_gt hc]

end OnlineZetaEta2
