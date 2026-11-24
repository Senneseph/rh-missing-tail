/-
OnlineZetaFE.lean — honline project, Phase 1c: functional-equation transport of
the explicit Dirichlet-series tail bound (OnlineZeta.zetaDirichletTail, Phase 1b)
to the LEFT of the critical line.

What this module provides (no RH claim; pure analytic estimates on Mathlib's
riemannZeta):

  (1) `zetaFEtransport`: for `s.re < 0`, Mathlib's functional equation
      `riemannZeta_one_sub` reoriented to express `ζ s` in terms of `ζ (1 - s)`,
      whose real part is `1 - s.re > 1` — i.e. RIGHT of the critical line, where
      the Phase 1b tail bound applies.

  (2) `zetaTailTransportLeft`: the explicit transport inequality. For
      `s.re < 0` and `0 < N`:

        ‖ζ s‖ ≤ 2 · (2π)^(s.re - 1) · ‖Γ(1 - s)‖ · ‖cos(π(1 - s)/2)‖
                 · ( Σ_{1 ≤ n ≤ N} n^(s.re - 1) + N^(s.re) / (-s.re) )

      The sum and the tail term are REAL (no complex quantities); the only
      unevaluated analytic factors are the two norms `‖Γ(1 - s)‖` and
      `‖cos(π(1 - s)/2)‖`, which are explicit expressions in `s`. Bounding
      `‖Γ(1 - s)‖` on vertical strips (the right half-plane Re ≥ 1+δ) is the
      next sub-lemma of Phase 1c and is left open here on purpose — no
      inequality is asserted that is not proved.

Position in the honline program (docs/ONLINE-FORMALIZATION-SCOPE.md):
Phase 1a strip (done, ZetaConcrete.zetaNontrivialInStrip) → Phase 1b right-side
explicit engine (done, OnlineZeta) → Phase 1c LEFT-side transport (this file)
→ Phase 2 in-strip explicit engine (Euler-transformed eta / Riemann-Siegel)
→ Phase 3 disk count for the first-zero slice → boundary separation → assembly
of `honline`. The terminal face above the census frontier remains the named
open object; nothing here touches it.

NO RH CLAIM. No new axioms. Pinned Mathlib v4.33.1 as read-only infrastructure.
-/

import RhAttack.OnlineZeta
import Mathlib

open Set Complex Real Filter
open MeasureTheory Finset

set_option maxHeartbeats 400000

namespace OnlineZetaFE

/-! The functional equation in transport orientation. -/

/-- Mathlib's `riemannZeta_one_sub` reoriented: for `s.re < 0`,
    `ζ s = 2 · (2π)^(-(1-s)) · Γ(1-s) · cos(π(1-s)/2) · ζ(1-s)`, where
    `(1 - s).re = 1 - s.re > 1`. -/
theorem zetaFEtransport {s : ℂ} (hsre : s.re < 0) :
    riemannZeta s = 2 * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
      Complex.cos (π * (1 - s) / 2) * riemannZeta (1 - s) := by
  have hne1 : (1 - s : ℂ) ≠ 1 := by
    intro h
    have := congr_arg (·.re) h
    simp [sub_re, one_re] at this
    linarith [hsre]
  have hnneg : ∀ n : ℕ, (1 - s : ℂ) ≠ -n := by
    intro n h
    have hre := congr_arg (·.re) h
    have hlhs : (1 - s : ℂ).re = 1 - s.re := by simp [sub_re]
    have hcast : (n : ℂ).re = (n : ℝ) := rfl
    have hrhs : (-n : ℂ).re = -((n : ℝ)) := by rw [neg_re, hcast]
    have hlin : 1 - s.re = -((n : ℝ)) := by simpa [hlhs, hrhs] using hre
    have hsum : (s.re : ℝ) = 1 + (n : ℝ) := by linarith
    have hpos : 0 < (s.re : ℝ) := by linarith [hsum, Nat.cast_nonneg (α := ℝ) n]
    linarith [hpos, hsre]
  have hFE := riemannZeta_one_sub hnneg hne1
  have hleft : (1 - (1 - s) : ℂ) = s := by ring
  rw [hleft] at hFE
  exact hFE

/-! The explicit transport inequality. -/

/-- For `s.re < 0` and `0 < N`:
      ‖ζ s‖ ≤ 2 · (2π)^(s.re - 1) · ‖Γ(1 - s)‖ · ‖cos(π(1-s)/2)‖
               · (Σ_{1 ≤ n ≤ N} n^(s.re - 1) + N^(s.re) / (-s.re)).
    Proof: transport via `zetaFEtransport`, then the Phase 1b tail bound
    `OnlineZeta.zetaDirichletTail` applied at `1 - s` (real part `1 - s.re > 1`),
    then norm estimates. The partial sum is over `Ico 1 (N + 1)` = `1..N`;
    the `n = 0` term of the `range (N + 1)` formulation is provably `0`. -/
theorem zetaTailTransportLeft {s : ℂ} (hsre : s.re < 0) (N : ℕ) (hN : 0 < N) :
    ‖riemannZeta s‖ ≤ 2 * (2 * Real.pi : ℝ) ^ (s.re - 1) *
      ‖Complex.Gamma (1 - s)‖ * ‖Complex.cos (π * (1 - s) / 2)‖ *
      ((∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1)) + (N : ℝ) ^ (s.re) / (-(s.re))) := by
  have hwre : 1 < (1 - s : ℂ).re := by
    have : (1 - s : ℂ).re = 1 - s.re := by simp [sub_re]
    rw [this]
    linarith [hsre]
  -- Phase 1b tail bound at 1 - s:
  have htail0 := OnlineZeta.zetaDirichletTail hwre N hN
  have htail' : (N : ℝ) ^ (1 - (1 - s : ℂ).re) / ((1 - s : ℂ).re - 1) =
      (N : ℝ) ^ (s.re) / (-(s.re)) := by
    have hre : (1 - s : ℂ).re = 1 - s.re := by simp [sub_re]
    rw [hre]
    rw [show (1 - (1 - s.re) : ℝ) = s.re by ring]
    rw [show ((1 - s.re : ℝ) - 1 : ℝ) = -(s.re) by ring]
  -- The n = 0 term of the range (N + 1) partial sum is 0:
  have hnw : (1 - s : ℂ) ≠ 0 := by
    intro h
    have := congr_arg (·.re) h
    simp [sub_re] at this
    linarith [hwre]
  have hf0 : (1 : ℂ) / (0 : ℂ) ^ (1 - s) = 0 := by
    rw [zero_cpow hnw, div_zero]
  -- Termwise norm bound on the partial-sum terms (n = 0 and n ≥ 1):
  have hterm (n : ℕ) (hn : n ∈ Finset.range (N + 1)) :
      ‖(1 : ℂ) / (n : ℂ) ^ (1 - s)‖ ≤ (n : ℝ) ^ (s.re - 1) := by
    by_cases hn0 : n = 0
    · subst hn0
      rw [Nat.cast_zero (R := ℂ), Nat.cast_zero (R := ℝ)]
      rw [zero_cpow hnw, div_zero, norm_zero]
      rw [zero_rpow (show (s.re - 1 : ℝ) ≠ 0 by linarith [hsre])]
    · have hn1 : 0 < n := Nat.pos_of_ne_zero hn0
      have hnR : (0 : ℝ) < n := by exact_mod_cast hn1
      have hre : (1 - s : ℂ).re = 1 - s.re := by simp [sub_re]
      have heq : ‖(1 : ℂ) / (n : ℂ) ^ (1 - s)‖ = (n : ℝ) ^ (s.re - 1) := by
        have hexp : (-(1 - s : ℂ).re : ℝ) = s.re - 1 := by
          simp [hre]
        calc
          ‖(1 : ℂ) / (n : ℂ) ^ (1 - s)‖ = ‖(1 : ℂ)‖ / ‖(n : ℂ) ^ (1 - s)‖ := norm_div _ _
          _ = 1 / ‖(n : ℂ) ^ (1 - s)‖ := by rw [norm_one]
          _ = ‖(n : ℂ) ^ (1 - s)‖⁻¹ := by rw [div_eq_mul_inv, one_mul]
          _ = ((n : ℝ) ^ (1 - s).re)⁻¹ := by
              have hnc : (n : ℂ) = ((n : ℝ) : ℂ) := by norm_cast
              rw [hnc, norm_cpow_eq_rpow_re_of_pos hnR]
          _ = (n : ℝ) ^ (-(1 - s).re) := by
              rw [← rpow_neg hnR.le (1 - s).re]
          _ = (n : ℝ) ^ (s.re - 1) := by rw [hexp]
      exact heq.le
  -- The real sum over range (N + 1) equals the sum over Ico 1 (N + 1)
  -- (the n = 0 term is 0^(s.re - 1) = 0):
  have hrealsplit : (∑ n ∈ Finset.range (N + 1), (n : ℝ) ^ (s.re - 1)) =
      ∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1) := by
    have h0 : (0 : ℝ) ^ (s.re - 1) = 0 := by
      rw [zero_rpow (show (s.re - 1 : ℝ) ≠ 0 by linarith [hsre])]
    have hunion : (Finset.range (N + 1) : Finset ℕ) = (Finset.Ico 1 (N + 1) : Finset ℕ) ∪ {0} := by
      ext x
      by_cases hx0 : x = 0
      · subst hx0
        simp [Finset.mem_Ico]
      · have hx1 : 1 ≤ x := Nat.succ_le_of_lt (Nat.pos_of_ne_zero hx0)
        simp [Finset.mem_Ico, Finset.mem_insert, Finset.mem_singleton, hx1, hx0]
    have hdisj : Disjoint (Finset.Ico 1 (N + 1) : Finset ℕ) ({0} : Finset ℕ) := by
      rw [Finset.disjoint_left]
      intro x hx
      simp only [Finset.mem_Ico, Finset.mem_insert, Finset.mem_singleton] at hx
      simp only [Finset.mem_insert, Finset.mem_singleton]
      linarith
    rw [hunion, Finset.sum_union hdisj, Finset.sum_singleton, Nat.cast_zero (R := ℝ), h0, add_zero]
  -- ζ(1 - s) bounded by partial-sum norms + tail:
  have hXY : ‖riemannZeta (1 - s)‖ ≤
      (∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1)) + (N : ℝ) ^ (s.re) / (-(s.re)) := by
    set P := ∑ n ∈ Finset.range (N + 1), (1 : ℂ) / (n : ℂ) ^ (1 - s) with hPdef
    have hP0 : P = ∑ n ∈ Finset.Ico 1 (N + 1), (1 : ℂ) / (n : ℂ) ^ (1 - s) := by
      have hunion : (Finset.range (N + 1) : Finset ℕ) = (Finset.Ico 1 (N + 1) : Finset ℕ) ∪ {0} := by
        ext x
        by_cases hx0 : x = 0
        · subst hx0
          simp [Finset.mem_Ico]
        · have hx1 : 1 ≤ x := Nat.succ_le_of_lt (Nat.pos_of_ne_zero hx0)
          simp [Finset.mem_Ico, Finset.mem_insert, Finset.mem_singleton, hx1, hx0]
      have hdisj : Disjoint (Finset.Ico 1 (N + 1) : Finset ℕ) ({0} : Finset ℕ) := by
        rw [Finset.disjoint_left]
        intro x hx
        simp only [Finset.mem_Ico, Finset.mem_insert, Finset.mem_singleton] at hx
        simp only [Finset.mem_insert, Finset.mem_singleton]
        linarith
      rw [hPdef, hunion, Finset.sum_union hdisj, Finset.sum_singleton, Nat.cast_zero (R := ℂ), hf0, add_zero]
    calc
      ‖riemannZeta (1 - s)‖
      _ = ‖(riemannZeta (1 - s) - P) + P‖ := by ring_nf
      _ ≤ ‖riemannZeta (1 - s) - P‖ + ‖P‖ := norm_add_le _ _
      _ ≤ (N : ℝ) ^ (1 - (1 - s : ℂ).re) / ((1 - s : ℂ).re - 1) +
          ‖(∑ n ∈ Finset.Ico 1 (N + 1), (1 : ℂ) / (n : ℂ) ^ (1 - s))‖ := by
          have hP0n : ‖P‖ = ‖(∑ n ∈ Finset.Ico 1 (N + 1), (1 : ℂ) / (n : ℂ) ^ (1 - s))‖ := by
            rw [hP0]
          rw [hP0n]
          exact add_le_add htail0 (le_rfl)
      _ ≤ (N : ℝ) ^ (1 - (1 - s : ℂ).re) / ((1 - s : ℂ).re - 1) +
          ∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1) := by
          gcongr
          calc
            ‖(∑ n ∈ Finset.Ico 1 (N + 1), (1 : ℂ) / (n : ℂ) ^ (1 - s))‖ ≤
                ∑ n ∈ Finset.Ico 1 (N + 1), ‖(1 : ℂ) / (n : ℂ) ^ (1 - s)‖ := norm_sum_le _ _
            _ ≤ ∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1) :=
              Finset.sum_le_sum fun n hn => by
                have hnr : n ∈ (Finset.range (N + 1) : Finset ℕ) := by
                  simp only [Finset.mem_Ico, Finset.mem_range] at hn ⊢
                  exact hn.2
                exact hterm n hnr
      _ = (∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1)) + (N : ℝ) ^ (s.re) / (-(s.re)) := by
          rw [htail']
          ring_nf
  -- Transport:
  have hFE := zetaFEtransport hsre
  have hnorm2 : ‖(2 : ℂ)‖ = 2 := by norm_num
  have hbase : (2 * π : ℂ) = ((2 * Real.pi : ℝ) : ℂ) := by norm_cast
  have hexp : ((- (1 - s) : ℂ)).re = (s.re - 1 : ℝ) := by
    have hre : (1 - s : ℂ).re = 1 - s.re := by simp [sub_re]
    rw [neg_re, hre]
    ring
  calc
    ‖riemannZeta s‖
    _ = ‖2 * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
        Complex.cos (π * (1 - s) / 2) * riemannZeta (1 - s)‖ := by
        rw [hFE]
    _ ≤ ‖(2 : ℂ)‖ * ‖((2 * π : ℂ)) ^ (-(1 - s))‖ * ‖Complex.Gamma (1 - s)‖ *
        ‖Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ := by
        have h1 : ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
            Complex.cos (π * (1 - s) / 2) * riemannZeta (1 - s)‖ ≤
            ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
            Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ :=
          norm_mul_le _ _
        have h2 : ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
            Complex.cos (π * (1 - s) / 2)‖ ≤
            ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s)‖ *
            ‖Complex.cos (π * (1 - s) / 2)‖ :=
          norm_mul_le _ _
        have h3 : ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s)‖ ≤
            ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s))‖ * ‖Complex.Gamma (1 - s)‖ :=
          norm_mul_le _ _
        have h4 : ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s))‖ ≤
            ‖(2 : ℂ)‖ * ‖((2 * π : ℂ)) ^ (-(1 - s))‖ :=
          norm_mul_le _ _
        calc
          _ ≤ ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s) *
              Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ := h1
          _ ≤ ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s)) * Complex.Gamma (1 - s)‖ *
              ‖Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ :=
            mul_le_mul_of_nonneg_right h2 (norm_nonneg _)
          _ ≤ ‖(2 : ℂ) * ((2 * π : ℂ)) ^ (-(1 - s))‖ * ‖Complex.Gamma (1 - s)‖ *
              ‖Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ :=
            mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right h3 (norm_nonneg _))
              (norm_nonneg _)
          _ ≤ ‖(2 : ℂ)‖ * ‖((2 * π : ℂ)) ^ (-(1 - s))‖ * ‖Complex.Gamma (1 - s)‖ *
              ‖Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ :=
            mul_le_mul_of_nonneg_right
              (mul_le_mul_of_nonneg_right (mul_le_mul_of_nonneg_right h4 (norm_nonneg _))
                (norm_nonneg _))
              (norm_nonneg _)
    _ = 2 * (2 * Real.pi : ℝ) ^ (s.re - 1) * ‖Complex.Gamma (1 - s)‖ *
        ‖Complex.cos (π * (1 - s) / 2)‖ * ‖riemannZeta (1 - s)‖ := by
        rw [hnorm2, hbase]
        rw [norm_cpow_eq_rpow_re_of_pos (show (0 : ℝ) < 2 * Real.pi by linarith [pi_pos]) (-(1 - s))]
        rw [hexp]
    _ ≤ 2 * (2 * Real.pi : ℝ) ^ (s.re - 1) * ‖Complex.Gamma (1 - s)‖ *
        ‖Complex.cos (π * (1 - s) / 2)‖ *
        ((∑ n ∈ Finset.Ico 1 (N + 1), (n : ℝ) ^ (s.re - 1)) + (N : ℝ) ^ (s.re) / (-(s.re))) := by
        have hcoef : 0 ≤ 2 * (2 * Real.pi : ℝ) ^ (s.re - 1) * ‖Complex.Gamma (1 - s)‖ *
            ‖Complex.cos (π * (1 - s) / 2)‖ := by
          have hp : 0 < (2 * Real.pi : ℝ) := by linarith [pi_pos]
          have he : 0 < (2 * Real.pi : ℝ) ^ (s.re - 1) := rpow_pos_of_pos hp _
          have hh : 0 < 2 * (2 * Real.pi : ℝ) ^ (s.re - 1) := mul_pos (by norm_num) he
          exact mul_nonneg (mul_nonneg (le_of_lt hh) (norm_nonneg _)) (norm_nonneg _)
        exact mul_le_mul_of_nonneg_left hXY hcoef

end OnlineZetaFE
