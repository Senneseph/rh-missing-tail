/-
**D1F - The named infinite-lifting gap fails for on-line zeros with classical
linear height growth (D1E named-gap follow-through).**
NO RH CLAIM.

This is the D1-series continuation (D1C, D1C-2, D1D, D1E, D1F...): D1E named
the convergence input `D1E.gap_infiniteLifting_convergence` that a zero family
must satisfy for its finite Laplace identity to lift to an infinite
meromorphic expression: for EVERY s with 0 < s.re (avoiding the pole locus)
the weighted series  sum_n |w(rho_n) * exp(-(s + rho_n) c) / (s + rho_n)|
must be summable.

D1F answers that question in the case the terminal-face program actually
needs, with weight identically 1:

  * Theorem `lineGapTerm_ge_harmonic`: if every zero sits on the critical
    line (re = 1/2) and the (n+1)-st enumerated zero has classical linear
    height growth |Im rho_n| <= C (n+1)  (the Riemann-von Mangoldt content),
    then every gap summand dominates a scaled harmonic term:
      |e^{-(s + rho_n) c} / (s + rho_n)| >= E(s) / (D (n+1)),
    with E(s) = e^{-(s.re + 1/2) c} > 0 (on the line the decay is
    height-independent) and D = ||s|| + 1/2 + C > 0.

  * Lemma `dyadicBlockExceeds`: no matter which starting point is chosen,
    some dyadic block [m, 2m) of any sequence bounded below by E/(D (n+1))
    accumulates norm > E/(4D).

  * Theorem `lineGapSeries_notSummable`: by the Cauchy-vanishing criterion
    (`cauchySeq_finset_iff_sum_vanishing` + `summable_iff_cauchySeq_finset`),
    the unweighted gap series is THEREFORE NOT summable for any s avoiding
    the pole locus - in particular for every s with 0 < s.re.

CONSEQUENCE (in the D1E language): even under the joint assumption "all
zeros on the line + classical VMM linear growth" (RH restricted to the
statement in question, plus the classical growth law), the named gap of D1E
is NOT satisfied for weight 1. The D1E statement's only escape hatch is a
weight w vanishing on the zero set; any terminal-face route through the
Danesh lifting must therefore exploit that (or a different mechanism).

NO RH CLAIM: every theorem here is conditional on the stated line + growth
hypotheses. Nothing about the unproven parts of RH is assumed.
-/
import Mathlib
import RhAttack.D1D
import RhAttack.D1E
open scoped BigOperators

namespace D1F

/-- The unweighted per-zero gap summand at the point of interest `s` (weight 1),
for the enumerated family `f` and decay parameter `c`. -/
noncomputable def gapTerm (f : ℕ → ℂ) (c : ℝ) (s : ℂ) (n : ℕ) : ℝ :=
    ‖Complex.exp (-((s + f n) * (c : ℂ))) / (s + f n)‖

/-- A real times the imaginary unit has plain absolute-value norm. -/
lemma norm_real_imul (x : ℝ) : ‖((x : ℂ) * Complex.I)‖ = |x| := by
  have hI : ‖(Complex.I : ℂ)‖ = 1 := Complex.norm_I
  have hnx : ‖(x : ℂ)‖ = |x| := RCLike.norm_ofReal x
  calc
    ‖((x : ℂ) * Complex.I)‖ = ‖(x : ℂ)‖ * ‖Complex.I‖ := by rw [norm_mul]
    _ = |x| * 1 := by
      rw [hnx, Complex.norm_I]
    _ = |x| := by rw [mul_one]

/-- The exponential decay is exactly pinned by the real part, and the norm of
the reciprocal splits off. -/
theorem gapTerm_eq_exp_over_norm (f : ℕ → ℂ) (c : ℝ) (s : ℂ) (n : ℕ) :
    gapTerm f c s n = Real.exp (-((s + f n).re * c)) / ‖s + f n‖ := by
  have hz : (-( (s + f n) * (c : ℂ))).re = -((s + f n).re * c) := by
    have hmul : ((s + f n) * (c : ℂ)).re = (s + f n).re * c := by
      rw [Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im, mul_zero, sub_zero]
    rw [Complex.neg_re, hmul]
  have hexp :
      ‖Complex.exp (-((s + f n) * (c : ℂ)))‖ = Real.exp (-((s + f n).re * c)) := by
    rw [Complex.norm_exp, hz]
  unfold gapTerm
  rw [norm_div, hexp]

/-- On the critical line the exponential factor is height-independent:
E(s) = e^{-(s.re + 1/2) c}. -/
noncomputable def E (c : ℝ) (s : ℂ) : ℝ :=
    Real.exp (-((s.re + 1 / 2) * c))

theorem lineGapTerm_eq (f : ℕ → ℂ) (c : ℝ) (s : ℂ) (n : ℕ)
    (hline : ∀ n, (f n).re = 1 / 2) :
    gapTerm f c s n = E c s / ‖s + f n‖ := by
  have hs : (s + f n).re = s.re + 1 / 2 := by
    rw [Complex.add_re, hline n]
  rw [gapTerm_eq_exp_over_norm, hs, E]

/-- A single gap summand dominates a scaled harmonic term (on-line + VMM-type
linear height growth). -/
theorem lineGapTerm_ge_harmonic (f : ℕ → ℂ) (c : ℝ) (C : ℝ) (s : ℂ) (n : ℕ)
    (hline : ∀ n, (f n).re = 1 / 2)
    (hns : s + f n ≠ 0) (hC : 0 < C) (hCn : ∀ n, |(f n).im| ≤ C * (n + 1 : ℝ)) :
    E c s / ((‖s‖ + 1 / 2 + C) * (n + 1 : ℝ)) ≤ gapTerm f c s n := by
  set D := ‖s‖ + 1 / 2 + C with hDdef
  have hdens : f n = ((1 / 2 : ℝ) : ℂ) + (f n - ((1 / 2 : ℝ) : ℂ)) := by ring
  have hpure : f n - ((1 / 2 : ℝ) : ℂ) = (f n).im * Complex.I := by
    apply Complex.ext
    · simp only [Complex.sub_re, Complex.ofReal_re, Complex.ofReal_im,
        Complex.mul_re, Complex.I_re, Complex.I_im, mul_zero, zero_mul, hline n]
      ring_nf
    · simp only [Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im,
        Complex.mul_im, Complex.I_re, Complex.I_im, sub_zero, mul_one, add_zero]
      ring_nf
  have hnorm : ‖s + f n‖ ≤ ‖s‖ + 1 / 2 + C * (n + 1 : ℝ) := by
    calc
      ‖s + f n‖ = ‖s + ((1 / 2 : ℝ) : ℂ) + (f n - ((1 / 2 : ℝ) : ℂ))‖ := by
        have hsum2 : ((1 / 2 : ℝ) : ℂ) + (f n - ((1 / 2 : ℝ) : ℂ)) = f n := by
          rw [add_comm, sub_add_cancel]
        have htmp : s + ((1 / 2 : ℝ) : ℂ) + (f n - ((1 / 2 : ℝ) : ℂ)) = s + f n := by
          rw [add_assoc, hsum2]
        rw [← htmp]
      _ = ‖s + ((1 / 2 : ℝ) : ℂ) + (f n).im * Complex.I‖ := by
        rw [hpure]
      _ ≤ ‖s + ((1 / 2 : ℝ) : ℂ)‖ + ‖(f n).im * Complex.I‖ :=
          norm_add_le (s + ((1 / 2 : ℝ) : ℂ)) _
      _ ≤ ‖s‖ + ‖((1 / 2 : ℝ) : ℂ)‖ + ‖(f n).im * Complex.I‖ := by
        linarith [norm_add_le s ((1 / 2 : ℝ) : ℂ)]
      _ = ‖s‖ + |(1 / 2 : ℝ)| + ‖(f n).im * Complex.I‖ := by
        have hh : ‖((1 / 2 : ℝ) : ℂ)‖ = |(1 / 2 : ℝ)| :=
            RCLike.norm_ofReal ((1 / 2 : ℝ) : ℝ)
        rw [hh]
      _ = ‖s‖ + 1 / 2 + |(f n).im| := by
        rw [abs_of_pos (by norm_num : (0 : ℝ) < 1 / 2), norm_real_imul ((f n).im)]
      _ ≤ ‖s‖ + 1 / 2 + C * (n + 1 : ℝ) := by
        nlinarith [hCn n]
  have hhalf : 0 < (1 / 2 : ℝ) := by norm_num
  have hD : 0 < D := by
    nlinarith [norm_nonneg s, hhalf, hC]
  have hden : ‖s + f n‖ ≤ D * (n + 1 : ℝ) := by
    calc
      _ ≤ ‖s‖ + 1 / 2 + C * (n + 1 : ℝ) := hnorm
      _ ≤ (‖s‖ + 1 / 2 + C) * (n + 1 : ℝ) := by
        have h1 : ‖s‖ ≤ ‖s‖ * (n + 1 : ℝ) := by
          nlinarith [norm_nonneg s, Nat.zero_le n]
        have h2 : (1 / 2 : ℝ) ≤ (1 / 2) * (n + 1 : ℝ) := by
          nlinarith [Nat.zero_le n]
        nlinarith [h1, h2]
      _ = D * (n + 1 : ℝ) := rfl
  calc
    E c s / (D * (n + 1 : ℝ)) = Real.exp (-((s.re + 1 / 2) * c)) / (D * (n + 1 : ℝ)) := by
      rw [E]
    _ ≤ Real.exp (-((s.re + 1 / 2) * c)) / ‖s + f n‖ := by
      have hden0 : 0 < ‖s + f n‖ := norm_pos_iff.2 hns
      have hrecip : 1 / (D * (n + 1 : ℝ)) ≤ 1 / ‖s + f n‖ :=
          one_div_le_one_div_of_le hden0 hden
      have hE : 0 < Real.exp (-((s.re + 1 / 2) * c)) := Real.exp_pos _
      calc
        Real.exp (-((s.re + 1 / 2) * c)) / (D * (n + 1 : ℝ)) =
            Real.exp (-((s.re + 1 / 2) * c)) * (1 / (D * (n + 1 : ℝ))) := by
          field_simp [hD]
        _ ≤ Real.exp (-((s.re + 1 / 2) * c)) * (1 / ‖s + f n‖) :=
            mul_le_mul_of_nonneg_left hrecip (le_of_lt hE)
        _ = Real.exp (-((s.re + 1 / 2) * c)) / ‖s + f n‖ := by
          field_simp [hden0]
    _ = gapTerm f c s n := by
      rw [lineGapTerm_eq f c s n hline, E]

/-- No matter which starting point is chosen, some dyadic block [m, 2m) of a
sequence bounded below by E / (D (n+1)) accumulates norm > E / (4 D). -/
theorem dyadicBlockExceeds (E D : ℝ) (hE : 0 < E) (hD : 0 < D) (m : ℕ) (hm : 0 < m)
    (g : ℕ → ℝ) (hlb : ∀ k ∈ Finset.Ico m (2 * m), E / (D * (k + 1 : ℝ)) ≤ g k) :
    ‖(∑ k ∈ Finset.Ico m (2 * m), g k)‖ > E / (4 * D) := by
  have hc : (Finset.Ico m (2 * m)).card = m := by
    rw [Nat.card_Ico]
    omega
  have hnonneg (k : ℕ) (hk : k ∈ Finset.Ico m (2 * m)) : 0 ≤ g k := by
    have hlb0 : 0 ≤ E / (D * (k + 1 : ℝ)) := by
      apply div_nonneg
      · linarith [hE]
      · nlinarith [Nat.zero_le k, hD]
    linarith [hlb k hk, hlb0]
  have hsum : ∑ k ∈ Finset.Ico m (2 * m), g k ≥ E / (2 * D) := by
    calc
      _ ≥ ∑ k ∈ Finset.Ico m (2 * m), (E / (D * (k + 1 : ℝ))) :=
          Finset.sum_le_sum (fun k hk => hlb k hk)
      _ ≥ ∑ k ∈ Finset.Ico m (2 * m), (E / (D * (2 * m : ℝ))) := by
        apply Finset.sum_le_sum
        intro k hk
        simp only [Finset.mem_Ico] at hk
        have hkℕ : k + 1 ≤ 2 * m := by omega
        have hkn : (k : ℝ) + 1 ≤ (2 * m : ℝ) := by
          norm_cast
        have hD0 : 0 < D * (k + 1 : ℝ) := by
          nlinarith [Nat.zero_le k, hD]
        have hD1 : 0 < D * (2 * m : ℝ) := by
          nlinarith [hm, hD]
        have hrecip : 1 / (D * (2 * m : ℝ)) ≤ 1 / (D * (k + 1 : ℝ)) :=
            one_div_le_one_div_of_le hD0 (mul_le_mul_of_nonneg_left hkn (le_of_lt hD))
        calc
          (E : ℝ) / (D * (k + 1 : ℝ)) = E * (1 / (D * (k + 1 : ℝ))) := by
            field_simp [hD0]
          _ ≥ E * (1 / (D * (2 * m : ℝ))) :=
              mul_le_mul_of_nonneg_left hrecip (le_of_lt hE)
          _ = E / (D * (2 * m : ℝ)) := by
            field_simp [hD1]
      _ = (m : ℝ) * (E / (D * (2 * m : ℝ))) := by
        have hsc : (∑ k ∈ Finset.Ico m (2 * m), (E / (D * (2 * m : ℝ)))) =
            (m : ℝ) * (E / (D * (2 * m : ℝ))) := by
          rw [Finset.sum_const, hc]
          ring_nf
        exact hsc
      _ = E / (2 * D) := by
        have hm0r : (m : ℝ) ≠ 0 := by positivity
        have hDen1 : D * (2 * (m : ℝ)) ≠ 0 := by positivity
        have hDen2 : (2 : ℝ) * D ≠ 0 := by positivity
        field_simp [hm0r, hDen1, hDen2]
  have h4 : E / (4 * D) < E / (2 * D) := by
    have h4D : 0 < 4 * D := by positivity
    have h2D : 0 < 2 * D := by positivity
    have hrev : (1 : ℝ) / (4 * D) < (1 : ℝ) / (2 * D) :=
        (one_div_lt_one_div h4D h2D).mpr (by nlinarith [hD])
    have hmul : E * ((1 : ℝ) / (4 * D)) < E * ((1 : ℝ) / (2 * D)) :=
        mul_lt_mul_of_pos_left hrev hE
    have hE4 : E / (4 * D) = E * ((1 : ℝ) / (4 * D)) := (mul_one_div E (4 * D)).symm
    have hE2 : E / (2 * D) = E * ((1 : ℝ) / (2 * D)) := (mul_one_div E (2 * D)).symm
    rw [hE4, hE2]
    exact hmul
  have hnn : 0 ≤ ∑ k ∈ Finset.Ico m (2 * m), g k :=
      Finset.sum_nonneg (fun k hk => hnonneg k hk)
  calc
    E / (4 * D) < E / (2 * D) := h4
    _ ≤ ‖(∑ k ∈ Finset.Ico m (2 * m), g k)‖ := by
      rw [Real.norm_eq_abs, abs_of_nonneg hnn]
      exact hsum

/-- The unweighted gap series is NOT summable for any s avoiding the pole
locus, under line + classical linear height growth. (In particular for every
s with 0 < s.re.) -/
theorem lineGapSeries_notSummable (f : ℕ → ℂ) (c : ℝ) (s : ℂ)
    (hline : ∀ n, (f n).re = 1 / 2)
    (hgrow : ∃ C > (0 : ℝ), ∀ n, |(f n).im| ≤ C * (n + 1 : ℝ))
    (hns : ∀ n, s + f n ≠ 0) :
    ¬ Summable (fun n : ℕ => gapTerm f c s n) := by
  rcases hgrow with ⟨C, hC0, hCn⟩
  have hE : 0 < Real.exp (-((s.re + 1 / 2) * c)) := Real.exp_pos _
  have hhalf : 0 < (1 / 2 : ℝ) := by norm_num
  have hD : 0 < ‖s‖ + 1 / 2 + C := by
    nlinarith [norm_nonneg s, hhalf, hC0]
  have hlb (k : ℕ) :
      Real.exp (-((s.re + 1 / 2) * c)) / ((‖s‖ + 1 / 2 + C) * (k + 1 : ℝ)) ≤
        gapTerm f c s k :=
    lineGapTerm_ge_harmonic f c C s k hline (hns k) hC0 hCn
  have hnot_cauchy :
      ¬ CauchySeq (fun (u : Finset ℕ) => ∑ n ∈ u, gapTerm f c s n) := by
    intro hca
    have hvan := (cauchySeq_finset_iff_sum_vanishing (f := fun n => gapTerm f c s n)).mp hca
    set r := Real.exp (-((s.re + 1 / 2) * c)) / (4 * (‖s‖ + 1 / 2 + C)) with hrdef
    have hr : 0 < r := by
      dsimp only [r]
      have hden4 : 0 < 4 * (‖s‖ + 1 / 2 + C) := by
        apply mul_pos
        · norm_num
        · exact hD
      exact div_pos hE hden4
    have hevan := hvan (Metric.ball (0 : ℝ) r) (Metric.ball_mem_nhds (0 : ℝ) hr)
    obtain ⟨s0, htail⟩ := hevan
    have hblock : ∃ m, 0 < m ∧ Disjoint (Finset.Ico m (2 * m)) s0 := by
      by_cases hs0e : s0 = ∅
      · use 1
        constructor
        · norm_num
        · rw [hs0e]
          exact Finset.disjoint_left.mpr (fun a _ => Finset.notMem_empty a)
      · have hn : s0.Nonempty := Finset.nonempty_iff_ne_empty.mpr hs0e
        use s0.max' hn + 1
        constructor
        · omega
        · exact Finset.disjoint_left.mpr
            (fun k hki hk0 => by
              have hmax : k ≤ s0.max' hn :=
                  ((Finset.max'_le_iff (s := s0) (H := hn) (x := s0.max' hn)).mp le_rfl) k hk0
              have hlbk : s0.max' hn + 1 ≤ k := by
                simp only [Finset.mem_Ico] at hki
                exact hki.1
              nlinarith)
    obtain ⟨m, hm, hdisj⟩ := hblock
    have hbig :
        ‖(∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k)‖ > r := by
      unfold r
      apply dyadicBlockExceeds (Real.exp (-((s.re + 1 / 2) * c))) (‖s‖ + 1 / 2 + C)
        hE hD m hm (fun n => gapTerm f c s n)
      intro k hk
      exact hlb k
    have hnotin :
        (∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k) ∉ Metric.ball (0 : ℝ) r := by
      intro hmem
      rw [Metric.mem_ball] at hmem
      have hdist :
          dist (0 : ℝ) (∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k) =
            ‖(∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k)‖ := by
        rw [dist_eq_norm]
        have S0 : (0 : ℝ) - (∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k) =
            - (∑ k ∈ Finset.Ico m (2 * m), gapTerm f c s k) := by simp
        rw [S0, Real.norm_eq_abs, abs_neg, Real.norm_eq_abs]
      rw [dist_comm, hdist] at hmem
      nlinarith [hbig, hmem]
    exact hnotin (htail (Finset.Ico m (2 * m)) hdisj)
  intro hsum
  have hca := (summable_iff_cauchySeq_finset (f := fun n => gapTerm f c s n)).mp hsum
  exact hnot_cauchy hca

end D1F
