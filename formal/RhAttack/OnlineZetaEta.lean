import Mathlib
import RhAttack.OnlineZeta

open Set Complex Real
open BigOperators

namespace OnlineZetaEta

/-
honline Phase 2.0: the eta-zeta identity (first piece of the in-strip engine).

The in-strip engine (Phase 2) evaluates `ζ(s)` for `0 < Re s ≤ 1` via the
eta series `η(s) = Σ (−1)^{n−1} n^{−s}` (convergent for `Re s > 0`), linked
to the zeta series by the classical identity

    η(s) = (1 − 2^{1−s}) · ζ(s).

At this stage the identity is proven where both sides are absolute sums
(`Re s > 1`), directly from the Dirichlet series — no analytic continuation
is involved yet. The extension to `0 < Re s ≤ 1` is a later sub-lemma
(identity theorem over the connected domain `Re s > 0`, `s ≠ 1`).

NO RH CLAIM. NO NEW AXIOMS. Machine-checked against pinned Mathlib v4.33.1.

ELABORATION NOTE: every theorem takes `s` and `hs` as explicit parameters
in its own header. In Lean 4, section variables (implicit or explicit) are
captured into a declaration only when they appear in its signature, and an
implicit variable that does not appear in a def's type cannot be synthesized
at application sites; explicit per-theorem parameters avoid both traps.
-/

/-- The alternating (eta) series; the `n = 0` term is `0`. -/
noncomputable def etaSeries (s : ℂ) : ℂ :=
  ∑' n : ℕ, (-1 : ℂ) ^ (n - 1) * (1 / (n : ℂ) ^ s)

/-- The product law for nonnegative real bases and a complex exponent:
`(x · y)^z = x^z · y^z` for `x, y ≥ 0` (via the exponential definition and
`log (x · y) = log x + log y`). -/
theorem cpowMulRealNonneg (x y : ℝ) (hx : 0 ≤ x) (hy : 0 ≤ y) (z : ℂ) :
    ((x * y : ℝ) : ℂ) ^ z = (x : ℂ) ^ z * (y : ℂ) ^ z := by
  rcases eq_or_ne x 0 with (rfl | hxn)
  · rcases eq_or_ne y 0 with (rfl | hyn)
    · by_cases hzn : z = 0
      · simp [hzn]
      · simp [Complex.cpow_eq_zero_iff, hzn]
    · by_cases hzn : z = 0
      · simp [hzn]
      · simp [Complex.cpow_eq_zero_iff, hzn]
  · rcases eq_or_ne y 0 with (rfl | hyn)
    · by_cases hzn : z = 0
      · simp [hzn]
      · simp [Complex.cpow_eq_zero_iff, hzn]
    · have h0xy : x * y ≠ 0 := mul_ne_zero hxn hyn
      rw [Complex.cpow_def_of_ne_zero (by simpa using h0xy) z,
          Complex.cpow_def_of_ne_zero (by simpa using hxn) z,
          Complex.cpow_def_of_ne_zero (by simpa using hyn) z]
      rw [← Complex.ofReal_log (mul_nonneg hx hy), Real.log_mul hxn hyn,
          ← Complex.ofReal_log hx, ← Complex.ofReal_log hy]
      have hrw : (((Real.log x + Real.log y : ℝ) : ℂ)) * z =
          ((Real.log x : ℝ) : ℂ) * z + ((Real.log y : ℝ) : ℂ) * z := by
        rw [Complex.ofReal_add, add_mul]
      rw [hrw, Complex.exp_add]

private noncomputable def zetaTerm (s : ℂ) (n : ℕ) : ℂ := 1 / (n : ℂ) ^ s

/-- The `n = 0` term of the zeta series is `0` (for `s ≠ 0`). -/
theorem zetaTerm0 (s : ℂ) (hs : 1 < s.re) : zetaTerm s 0 = 0 := by
  dsimp only [zetaTerm]
  have hsnz : s ≠ 0 := by
    intro h
    rw [h] at hs
    norm_num at hs
  simp [Complex.cpow_eq_zero_iff, hsnz]

/-- The zeta series is summable for `Re s > 1`. -/
theorem zetaSeriesSummable (s : ℂ) (hs : 1 < s.re) :
    Summable (fun n : ℕ => zetaTerm s n) := by
  have hpt : (fun n : ℕ => zetaTerm s n) = (fun n : ℕ => 1 / (n : ℂ) ^ s) := by
    funext n
    dsimp [zetaTerm]
  simpa [hpt] using (Complex.summable_one_div_nat_cpow).mpr hs

/-- The eta series is summable for `Re s > 1`. -/
theorem etaSeriesSummable (s : ℂ) (hs : 1 < s.re) :
    Summable (fun n : ℕ => (-1 : ℂ) ^ (n - 1) * zetaTerm s n) := by
  have h1 : Summable (fun n : ℕ => (-1 : ℂ) ^ n * zetaTerm s n) := by
    have hpt : (fun n : ℕ => zetaTerm s n) = (fun n : ℕ => 1 / (n : ℂ) ^ s) := by
      funext n
      dsimp [zetaTerm]
    simpa [hpt] using Summable.alternating ((Complex.summable_one_div_nat_cpow).mpr hs)
  have h2 : ∀ n : ℕ, (-1 : ℂ) ^ (n - 1) * zetaTerm s n =
      -((-1 : ℂ) ^ n * zetaTerm s n) := by
    intro n
    cases n with
    | zero =>
      dsimp only [zetaTerm]
      have hsnz : s ≠ 0 := by
        intro h
        rw [h] at hs
        norm_num at hs
      simp [Complex.cpow_eq_zero_iff, hsnz]
    | succ m =>
      have hpow : (-1 : ℂ) ^ (m + 1) = (-1 : ℂ) ^ m * (-1 : ℂ) := by rw [pow_succ]
      rw [show (Nat.succ m - 1 : ℕ) = m by simp, hpow]
      ring
  exact Summable.congr (Summable.neg h1) (fun b => (h2 b).symm)

/-- The eta-zeta identity for `Re s > 1`:
`η(s) = (1 − 2^{1−s}) · ζ(s)`. -/
theorem etaIdentity (s : ℂ) (hs : 1 < s.re) :
    etaSeries s = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by
  have hζtsum : riemannZeta s = ∑' n : ℕ, zetaTerm s n := by
    have hpt : (fun n : ℕ => zetaTerm s n) = (fun n : ℕ => 1 / (n : ℂ) ^ s) := by
      funext n
      dsimp [zetaTerm]
    simpa [hpt] using zeta_eq_tsum_one_div_nat_cpow hs
  set g : ℕ → ℂ := fun n => (-1 : ℂ) ^ (n - 1) * zetaTerm s n with hg
  have he : Summable (fun k : ℕ => g (2 * k)) :=
    (etaSeriesSummable s hs).comp_injective (mul_right_injective₀ (two_ne_zero' ℕ))
  have ho : Summable (fun k : ℕ => g (2 * k + 1)) :=
    (etaSeriesSummable s hs).comp_injective
      ((add_left_injective 1).comp (mul_right_injective₀ (two_ne_zero' ℕ)))
  have hsplit : (∑' k : ℕ, g (2 * k)) + (∑' k : ℕ, g (2 * k + 1)) =
      ∑' n : ℕ, g n := tsum_even_add_odd he ho
  have hge : ∀ k : ℕ, g (2 * k) = -zetaTerm s (2 * k) := by
    intro k
    cases k with
    | zero =>
      dsimp only [g, zetaTerm]
      have hsnz : s ≠ 0 := by
        intro h
        rw [h] at hs
        norm_num at hs
      simp [Complex.cpow_eq_zero_iff, hsnz]
    | succ m =>
      dsimp only [g]
      have hexp : (2 * (m + 1) - 1 : ℕ) = 2 * m + 1 := by omega
      have hpow : (-1 : ℂ) ^ (2 * m + 1) = (-1 : ℂ) := by
        rw [pow_add, pow_mul (-1 : ℂ) 2 m, show (-1 : ℂ) ^ 2 = 1 by ring, one_pow, one_mul, pow_one]
      rw [hexp, hpow]
      ring
  have hgo : ∀ k : ℕ, g (2 * k + 1) = zetaTerm s (2 * k + 1) := by
    intro k
    dsimp only [g]
    have hexp : (2 * k + 1 - 1 : ℕ) = 2 * k := by omega
    have hpow : (-1 : ℂ) ^ (2 * k) = 1 := by
      rw [pow_mul (-1 : ℂ) 2 k, show (-1 : ℂ) ^ 2 = 1 by ring, one_pow]
    rw [hexp, hpow]
    ring
  have heven : ∑' k : ℕ, g (2 * k) = -(∑' k : ℕ, zetaTerm s (2 * k)) := by
    have hpw : (fun k : ℕ => g (2 * k)) = (fun k : ℕ => -zetaTerm s (2 * k)) := by
      funext k
      exact hge k
    rw [hpw, tsum_neg]
  have hodd : ∑' k : ℕ, g (2 * k + 1) = ∑' k : ℕ, zetaTerm s (2 * k + 1) := by
    have hpw : (fun k : ℕ => g (2 * k + 1)) = (fun k : ℕ => zetaTerm s (2 * k + 1)) := by
      funext k
      exact hgo k
    rw [hpw]
  have hzpoint : ∀ k : ℕ, zetaTerm s (2 * k) = (2 : ℂ) ^ (-s) * zetaTerm s k := by
    intro k
    dsimp only [zetaTerm]
    have hmul : ((2 * k : ℕ) : ℂ) ^ s = (2 : ℂ) ^ s * (k : ℂ) ^ s := by
      rw [Nat.cast_mul]
      have hcast : (2 : ℕ) * (k : ℕ) = ((2 * (k : ℝ) : ℝ) : ℂ) := by norm_cast
      have hcastk : (k : ℂ) = ((k : ℝ) : ℂ) := by norm_cast
      rw [hcast]
      have hT := cpowMulRealNonneg 2 (k : ℝ) (by norm_num) (Nat.cast_nonneg k) s
      rw [← hcastk] at hT
      exact hT
    rw [hmul, one_div, mul_inv_rev ((2 : ℂ) ^ s) ((k : ℂ) ^ s), ← Complex.cpow_neg (2 : ℂ) s]
    ring
  have hevenZ : ∑' k : ℕ, zetaTerm s (2 * k) =
      (2 : ℂ) ^ (-s) * (∑' k : ℕ, zetaTerm s k) := by
    have hpw : (fun k : ℕ => zetaTerm s (2 * k)) =
        (fun k : ℕ => (2 : ℂ) ^ (-s) * zetaTerm s k) := by
      funext k
      exact hzpoint k
    rw [hpw, tsum_mul_left]
  have hef : Summable (fun k : ℕ => zetaTerm s (2 * k)) :=
    (zetaSeriesSummable s hs).comp_injective (mul_right_injective₀ (two_ne_zero' ℕ))
  have hof : Summable (fun k : ℕ => zetaTerm s (2 * k + 1)) :=
    (zetaSeriesSummable s hs).comp_injective
      ((add_left_injective 1).comp (mul_right_injective₀ (two_ne_zero' ℕ)))
  have hsplitZ : (∑' k : ℕ, zetaTerm s (2 * k)) + (∑' k : ℕ, zetaTerm s (2 * k + 1)) =
      ∑' n : ℕ, zetaTerm s n := tsum_even_add_odd hef hof
  have hoddZ : ∑' k : ℕ, zetaTerm s (2 * k + 1) =
      (∑' n : ℕ, zetaTerm s n) - (∑' k : ℕ, zetaTerm s (2 * k)) := by
    rw [← hsplitZ]
    ring
  have h2one : (2 : ℂ) ^ (1 : ℂ) = 2 := by
    rw [Complex.cpow_def_of_ne_zero (by norm_num : (2 : ℂ) ≠ 0) (1 : ℂ), mul_one,
        Complex.exp_log (by norm_num : (2 : ℂ) ≠ 0)]
  have hpow2 : (2 : ℂ) ^ (1 - s) = (2 : ℂ) * (2 : ℂ) ^ (-s) := by
    rw [sub_eq_add_neg, Complex.cpow_add 1 (-s) (by norm_num : (2 : ℂ) ≠ 0), h2one]
  calc
    etaSeries s = ∑' n : ℕ, g n := rfl
    _ = (∑' k : ℕ, g (2 * k)) + (∑' k : ℕ, g (2 * k + 1)) := hsplit.symm
    _ = (-(∑' k : ℕ, zetaTerm s (2 * k))) + (∑' k : ℕ, zetaTerm s (2 * k + 1)) := by
      rw [heven, hodd]
    _ = (-(∑' k : ℕ, zetaTerm s (2 * k))) +
        ((∑' n : ℕ, zetaTerm s n) - (∑' k : ℕ, zetaTerm s (2 * k))) := by
      rw [hoddZ]
    _ = (∑' n : ℕ, zetaTerm s n) - 2 * (∑' k : ℕ, zetaTerm s (2 * k)) := by ring
    _ = (∑' n : ℕ, zetaTerm s n) -
        2 * ((2 : ℂ) ^ (-s) * (∑' k : ℕ, zetaTerm s k)) := by
      rw [hevenZ]
    _ = (∑' n : ℕ, zetaTerm s n) - (2 : ℂ) ^ (1 - s) * (∑' n : ℕ, zetaTerm s n) := by
      rw [hpow2]
      ring
    _ = riemannZeta s - (2 : ℂ) ^ (1 - s) * riemannZeta s := by
      rw [← hζtsum]
    _ = (1 - (2 : ℂ) ^ (1 - s)) * riemannZeta s := by ring

end OnlineZetaEta
