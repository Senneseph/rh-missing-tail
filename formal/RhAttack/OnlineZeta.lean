/-
OnlineZeta: honline project, Phase 1b - the explicit zeta-evaluation engine.

STATUS: first artifact of the numerical core of the honline project
(`docs/ONLINE-FORMALIZATION-SCOPE.md`): an EXPLICIT tail bound for the
Dirichlet series of Mathlib's `riemannZeta` at `Re s > 1`, everything
machine-checked in pinned Mathlib v4.33.1 (read-only infrastructure).

The bound (this module): for `1 < s.re` and `0 < N`,
    ‖ζ s - Σ_{1 ≤ n ≤ N} n^{-s}‖ ≤ N^{1-σ} / (σ - 1),   σ := s.re.

This is the workhorse for evaluating `ζ s` to any explicit precision at
points to the RIGHT of the critical line.  The functional-equation
transport (phase 1c) will mirror it to the left of the line, and the
Jensen circular mean (phase 2) consumes both.

HONESTY: no RH claim.  A pure analytic estimate (the classical integral
test), no new axioms.
-/
import Mathlib

open Set Complex Real Filter
open MeasureTheory Finset

namespace OnlineZeta

variable {σ : ℝ}

/-! ## 1.  The comparison series -/

/-- `x ↦ x ^ -σ` is antitone on `[1, ∞)` for `σ > 0`. -/
lemma rpowNegAntitone (hσ : 0 < σ) :
    AntitoneOn (fun x : ℝ => x ^ (-σ : ℝ)) (Ici 1) := by
  intro x hx y hy hxy
  have h1x : (1 : ℝ) ≤ x := hx
  have h1y : (1 : ℝ) ≤ y := hy
  have hx0 : 0 < x := by linarith
  have hy0 : 0 < y := by linarith
  have hle : x ^ σ ≤ y ^ σ := rpow_le_rpow hx0.le hxy (le_of_lt hσ)
  have hxp : 0 < x ^ σ := rpow_pos_of_pos hx0 σ
  have hyp : 0 < y ^ σ := rpow_pos_of_pos hy0 σ
  have hcalc : (y : ℝ) ^ (-σ : ℝ) ≤ (x ^ σ)⁻¹ := by
    calc
      (y : ℝ) ^ (-σ : ℝ) = (y ^ σ)⁻¹ := by rw [rpow_neg hy0.le]
      _ ≤ (x ^ σ)⁻¹ := by
        have h1 : (x ^ σ) * (y ^ σ)⁻¹ ≤ 1 := by
          have := mul_le_mul_of_nonneg_right hle (inv_nonneg.mpr (le_of_lt hyp))
          simpa [mul_inv_cancel₀ hyp.ne'] using this
        have := mul_le_mul_of_nonneg_right h1 (inv_pos.mpr hxp |>.le)
        have h3 : (x ^ σ) * (y ^ σ)⁻¹ * (x ^ σ)⁻¹ = (y ^ σ)⁻¹ := by
          calc
            _ = (x ^ σ) * (x ^ σ)⁻¹ * (y ^ σ)⁻¹ := by ring
            _ = 1 * (y ^ σ)⁻¹ := by rw [mul_inv_cancel₀ hxp.ne']
            _ = (y ^ σ)⁻¹ := by rw [one_mul]
        simpa [h3] using this
  simpa [rpow_neg hx0.le] using hcalc

/-! ## 2.  The half-line integral of `x ^ -σ` -/

/-- For `1 < σ`, the antiderivative `x ↦ x ^ (1 - σ) / (1 - σ)` has
    derivative `x ^ -σ` at every `x ≠ 0`. -/
private lemma Fderiv (hσ : 1 < σ) (x : ℝ) (hx : x ≠ 0) :
    HasDerivAt (fun x : ℝ => x ^ (1 - σ) / (1 - σ)) ((x : ℝ) ^ (-σ : ℝ)) x := by
  have hne : (1 : ℝ) - σ ≠ 0 := by
    by_contra h
    have : (1 : ℝ) = σ := by linarith
    exact lt_irrefl σ (by linarith [h, this])
  have hd : HasDerivAt (fun x : ℝ => x ^ (1 - σ)) ((1 - σ) * x ^ ((1 - σ) - 1)) x :=
    hasDerivAt_rpow_const (Or.inl hx)
  have hdF := hd.div_const (1 - σ)
  have h1 : ((1 - σ) * x ^ ((1 - σ) - 1)) / (1 - σ) = ((1 - σ) * x ^ (-σ : ℝ)) / (1 - σ) := by
    congr
    rw [show (1 - σ : ℝ) - 1 = -σ by ring]
  have h2 : ((1 - σ) * x ^ (-σ : ℝ)) / (1 - σ) = x ^ (-σ : ℝ) := by
    calc
      _ = ((1 - σ) * x ^ (-σ : ℝ)) * (1 - σ)⁻¹ := by rw [div_eq_mul_inv]
      _ = x ^ (-σ : ℝ) * ((1 - σ) * (1 - σ)⁻¹) := by ring
      _ = x ^ (-σ : ℝ) * 1 := by rw [mul_inv_cancel₀ hne]
      _ = x ^ (-σ : ℝ) := by rw [mul_one]
  simpa [h1, h2] using hdF

/-- For `1 < σ`, the antiderivative `x ↦ x ^ (1 - σ) / (1 - σ)` tends
    to `0` at infinity. -/
private lemma Ftend0 (hσ : 1 < σ) :
    Tendsto (fun x : ℝ => x ^ (1 - σ) / (1 - σ)) atTop (nhds (0 : ℝ)) := by
  have hne : (1 : ℝ) - σ ≠ 0 := by
    by_contra h
    have : (1 : ℝ) = σ := by linarith
    exact lt_irrefl σ (by linarith [h, this])
  have h₁ : 0 < σ - 1 := by linarith
  have h₂ : Tendsto (fun x : ℝ => x ^ (σ - 1)) atTop atTop := tendsto_rpow_atTop h₁
  have h₃ : ∀ᶠ (x : ℝ) in atTop, x ^ (1 - σ) = ((x : ℝ) ^ (σ - 1))⁻¹ := by
    filter_upwards [eventually_gt_atTop 0] with x hx
    rw [show (1 : ℝ) - σ = -(σ - 1) by ring, rpow_neg (le_of_lt hx)]
  have h₄ : Tendsto (fun x : ℝ => ((x : ℝ) ^ (σ - 1))⁻¹) atTop (nhds (0 : ℝ)) :=
    tendsto_inv_atTop_zero.comp h₂
  have hg1 : Tendsto (fun x : ℝ => x ^ (1 - σ)) atTop (nhds (0 : ℝ)) :=
    (tendsto_congr' h₃).mpr h₄
  have hg2 : Tendsto (fun x : ℝ => x ^ (1 - σ) * (1 - σ)⁻¹) atTop (nhds (0 * (1 - σ)⁻¹)) :=
    Filter.Tendsto.mul_const (1 - σ)⁻¹ hg1
  have heq : (fun x : ℝ => x ^ (1 - σ) * (1 - σ)⁻¹) = (fun x : ℝ => x ^ (1 - σ) / (1 - σ)) := by
    funext x
    rw [div_eq_mul_inv]
  simpa using Tendsto.congr (fun x => by rw [div_eq_mul_inv]) hg2

/-- For `1 < σ` and `0 < N`, `x ↦ x ^ -σ` is integrable on `(N, ∞)`. -/
lemma integrableIoiRpowNeg (hσ : 1 < σ) (N : ℕ) (hN : 0 < N) :
    IntegrableOn (fun x : ℝ => (x : ℝ) ^ (-σ : ℝ)) (Ioi (N : ℝ)) := by
  set F := fun x : ℝ => x ^ (1 - σ) / (1 - σ) with hFdef
  have hderiv : ∀ x ∈ Ici (N : ℝ), HasDerivAt F ((x : ℝ) ^ (-σ : ℝ)) x := by
    intro x hx
    have hle : (N : ℝ) ≤ x := by simpa using hx
    have hN0 : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
    have hx0 : 0 < x := by linarith [hle, hN0]
    exact Fderiv hσ x hx0.ne'
  have hnpos : ∀ x ∈ Ioi (N : ℝ), 0 ≤ (x : ℝ) ^ (-σ : ℝ) :=
    fun x hx => rpow_nonneg (by
      have hN0 : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
      have hx1 : (N : ℝ) < x := by simpa using hx
      linarith [hN0, hx1]) (-σ)
  exact integrableOn_Ioi_deriv_of_nonneg' hderiv hnpos (Ftend0 hσ)

/-- For `1 < σ` and `0 < N`:
    `∫ x in (N, ∞), x ^ -σ dx = N ^ (1 - σ) / (σ - 1)`. -/
lemma integralIoiRpowNeg (hσ : 1 < σ) (N : ℕ) (hN : 0 < N) :
    ∫ x in Ioi (N : ℝ), (x : ℝ) ^ (-σ : ℝ) = (N : ℝ) ^ (1 - σ) / (σ - 1) := by
  set F := fun x : ℝ => x ^ (1 - σ) / (1 - σ) with hFdef
  have hderiv : ∀ x ∈ Ici (N : ℝ), HasDerivAt F ((x : ℝ) ^ (-σ : ℝ)) x := by
    intro x hx
    have hle : (N : ℝ) ≤ x := by simpa using hx
    have hN0 : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
    have hx0 : 0 < x := by linarith [hle, hN0]
    exact Fderiv hσ x hx0.ne'
  have hnpos : ∀ x ∈ Ioi (N : ℝ), 0 ≤ (x : ℝ) ^ (-σ : ℝ) :=
    fun x hx => rpow_nonneg (by
      have hN0 : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
      have hx1 : (N : ℝ) < x := by simpa using hx
      linarith [hN0, hx1]) (-σ)
  rw [integral_Ioi_of_hasDerivAt_of_nonneg' hderiv hnpos (Ftend0 hσ)]
  -- goal: 0 - N ^ (1 - σ) / (1 - σ) = N ^ (1 - σ) / (σ - 1)
  dsimp only [F]
  have hne : (1 : ℝ) - σ ≠ 0 := by
    by_contra h
    have : (1 : ℝ) = σ := by linarith
    exact lt_irrefl σ (by linarith [h, this])
  have hne2 : (σ - 1 : ℝ) ≠ 0 := by linarith [hσ]
  have hinv : ((σ - 1 : ℝ))⁻¹ = -((1 - σ) : ℝ)⁻¹ := by
    rw [show (σ - 1 : ℝ) = -((1 : ℝ) - σ) by ring, neg_inv]
  field_simp [hne, hne2, hinv]
  ring

/-! ## 3.  The tail bound -/

set_option maxHeartbeats 400000 in
/-- **Dirichlet-series tail.**  For `1 < s.re` and `0 < N`,
    `‖ζ s - Σ_{n ∈ range (N+1)} n^{-s}‖ ≤ N^{1-σ} / (σ - 1)` with
    `σ := s.re`.  (The `n = 0` term of the tsum is `0`, so the partial
    sum equals `Σ_{1 ≤ n ≤ N} n^{-s}`.) -/
theorem zetaDirichletTail {s : ℂ} (hs : 1 < s.re) (N : ℕ) (hN : 0 < N) :
    ‖riemannZeta s - ∑ n ∈ range (N + 1), (1 : ℂ) / (n : ℂ) ^ s‖
        ≤ (N : ℝ) ^ (1 - s.re) / (s.re - 1) := by
  set σ := s.re with hσdef
  have hσ1 : 1 < σ := hs
  have hσ0 : 0 < σ := lt_trans zero_lt_one hσ1
  have hs0 : s ≠ 0 := by
    by_contra h
    subst h
    dsimp only [σ] at hs
    rw [Complex.zero_re] at hs
    linarith
  set f := fun (n : ℕ) => (1 : ℂ) / (n : ℂ) ^ s with hfdef
  -- ζ s = the tsum of f
  have htsum : riemannZeta s = ∑' (n : ℕ), f n := zeta_eq_tsum_one_div_nat_cpow hs
  -- pointwise norm computation
  have hnorm : (fun n : ℕ => ‖f n‖) = (fun n : ℕ => (n : ℝ) ^ (-σ : ℝ)) := by
    funext n
    by_cases hn : n = 0
    · subst n
      have hzero : (f 0 : ℂ) = 0 := by
        dsimp only [f]
        rw [Nat.cast_zero, zero_cpow hs0, div_zero]
      rw [hzero, norm_zero]
      rw [Nat.cast_zero]
      rw [zero_rpow (show (-σ : ℝ) ≠ 0 by linarith)]
    · have hpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hn
      calc ‖f n‖
          = ‖(1 : ℂ) / (n : ℂ) ^ s‖ := by rw [hfdef]
        _ = 1 / ‖(n : ℂ) ^ s‖ := by rw [norm_div, norm_one]
        _ = 1 / (n : ℝ) ^ σ := by
          rw [← ofReal_natCast, norm_cpow_eq_rpow_re_of_pos hpos]
        _ = (n : ℝ) ^ (-σ : ℝ) := by
          rw [show (1 : ℝ) / (n : ℝ) ^ σ = ((n : ℝ) ^ σ)⁻¹ from by ring,
              ← rpow_neg (by linarith : 0 ≤ (n : ℝ)) σ]
  -- the p-series is summable (integral test)
  have hsummNorm : Summable (fun n : ℕ => (n : ℝ) ^ (-σ : ℝ)) := by
    have hanti : AntitoneOn (fun x : ℝ => x ^ (-σ : ℝ)) (Ici ((1 : ℕ) : ℝ)) := by
      intro x hx y hy hxy
      have h1 : (1 : ℝ) ≤ x := by
        have := by simpa using hx
        linarith [show (1 : ℝ) ≤ ((1 : ℕ) : ℝ) from by norm_num]
      have h2 : (1 : ℝ) ≤ y := by
        have := by simpa using hy
        linarith [show (1 : ℝ) ≤ ((1 : ℕ) : ℝ) from by norm_num]
      exact (rpowNegAntitone hσ0) h1 h2 (by linarith)
    have hint := integrableIoiRpowNeg hσ1 (N := 1) (by norm_num)
    have hnn : ∀ t ∈ Ioi ((1 : ℕ) : ℝ), 0 ≤ t ^ (-σ : ℝ) :=
      fun t ht => rpow_nonneg (by
        have ht1 : (1 : ℝ) < t := by simpa using ht
        linarith) (-σ)
    exact AntitoneOn.summable_of_integrableOn_Ioi (N := 1) hanti hint hnn
  -- absolute convergence of the complex series
  have hsumm : Summable f := by
    have h1 : Summable (fun n : ℕ => ‖f n‖) := by
      rw [hnorm]
      exact hsummNorm
    exact summable_norm_iff.mp h1
  -- ζ s minus the partial sum is the shifted tail
  have hshift : riemannZeta s - ∑ n ∈ range (N + 1), f n = ∑' (k : ℕ), f (k + N + 1) := by
    rw [htsum, ← hsumm.sum_add_tsum_nat_add (N + 1)]
    abel
  -- norm of each shifted term
  have hnormShift : ∀ k, ‖f (k + N + 1)‖ = (k + N + 1 : ℝ) ^ (-σ : ℝ) := by
    intro k
    have := hnorm
    simpa using congrArg (fun g => g (k + N + 1)) this
  -- summability of the shifted norm series (shift of the absolutely convergent norm series)
  have hsummShift : Summable fun k : ℕ => ‖f (k + N + 1)‖ := by
    have h1 : Summable (fun n : ℕ => ‖f n‖) := by
      rw [hnorm]
      exact hsummNorm
    exact (summable_nat_add_iff (N + 1)).mpr h1
  calc ‖riemannZeta s - ∑ n ∈ range (N + 1), (1 : ℂ) / (n : ℂ) ^ s‖
      = ‖∑' (k : ℕ), f (k + N + 1)‖ := by rw [hshift]
    _ ≤ ∑' (k : ℕ), ‖f (k + N + 1)‖ := norm_tsum_le_tsum_norm hsummShift
    _ ≤ ∫ x in Ioi (N : ℝ), (x : ℝ) ^ (-σ : ℝ) := by
      rw [show (fun k : ℕ => ‖f (k + N + 1)‖) = (fun k : ℕ => ((k + N + 1 : ℕ) : ℝ) ^ (-σ : ℝ)) from by
        funext k
        simpa [show ((k + N + 1 : ℕ) : ℝ) = (k + N + 1 : ℝ) from by
          rw [Nat.cast_add, Nat.cast_add, Nat.cast_one]] using hnormShift k]
      have hantiT : AntitoneOn (fun x : ℝ => (x : ℝ) ^ (-σ : ℝ)) (Ici (N : ℝ)) := by
        intro x hx y hy hxy
        have h1 : (1 : ℝ) ≤ x := by
          have := by simpa using hx
          linarith [show (1 : ℝ) ≤ (N : ℝ) from by exact_mod_cast Nat.one_le_of_lt hN]
        have h2 : (1 : ℝ) ≤ y := by
          have := by simpa using hy
          linarith [show (1 : ℝ) ≤ (N : ℝ) from by exact_mod_cast Nat.one_le_of_lt hN]
        exact (rpowNegAntitone hσ0) h1 h2 (by linarith)
      exact AntitoneOn.tsum_comp_add_le_integral (N) hantiT
        (integrableIoiRpowNeg hσ1 N hN)
        (fun t ht => rpow_nonneg (by
          have hN0 : (0 : ℝ) < (N : ℝ) := Nat.cast_pos.mpr hN
          have ht1 : (N : ℝ) < t := by simpa using ht
          linarith [hN0, ht1]) (-σ))
    _ = (N : ℝ) ^ (1 - σ) / (σ - 1) := integralIoiRpowNeg hσ1 N hN

end OnlineZeta
