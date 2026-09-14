import Mathlib
import RhAttack.B4
import RhAttack.B5
import RhAttack.P8Floor
import RhAttack.Closure

/- C1b — the DISCRETE-STRADDLE detector floor (25i RESOLVED-2 / 25k).

   After 25i, the continuous-window floor is REFUTED (pole + ridge:
   ‖R - 1‖ reaches 1/γ scale off the grid).  The closure evaluates the
   detector at the DISCRETE straddle heights u = 0.5k (k = ±1..±24,
   |u| <= 12, u != 0) plus the pole column (C1a — proven exact).  THE
   25k CANDIDATE THEOREM (zero violations on the dps-30 grid):

       ‖R(γ, δ, γ + 0.5k) - 1‖ >= min(23/1000, 1 - 25/γ)
       for γ >= 14.14, k = ±1..±24, 0 < δ <= 1/2,

   with 4% margin constants (23/1000 vs measured corner
   0.02384820641; 25 vs measured c = 24.0458).

   This module builds the theorem bottom-up (all-positive polynomial
   house style, no MVT).  C1b.0 (this file): the foundations
     c1b_R1_le_one  — the R1 grouping factor <= 1
     c1b_omega_pos  — 0 < ω_δ
     c1b_omega_ub   — ω_δ <= 3/(¼+γ²)
     c1b_exp_ub     — e^{ω/2} <= 120/119
     c1b_F_incr     — F(x) = x + 1/(4x) increasing for x >= 1/2
   Next atoms: the |pref| shape bound, the 25/γ corner polynomial
   (J > 0 on the grid), and the ‖R - 1‖ composition.

   Honest split: LEAN-PROVEN (no pins in this file); the window
   constants (γ0 = 14.14 lower edge, W = 12, δmax = 1/2) are the
   instrument's pinned range (25i/25k).  Lean 4.33.1 + Mathlib.
-/

open Real

/-- The grouped R1 denominator: (A+δ+δ²)(A-δ+δ²) = A² + δ²(2A+δ²-1),
    A := ¼+γ². -/
theorem c1b_den_group (γ δ : ℝ) :
    (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) =
        (1 / 4 + γ ^ 2) ^ 2 + δ ^ 2 * (2 * (1 / 4 + γ ^ 2) + δ ^ 2 - 1) := by
  ring

/-- R1 <= 1 on the pinned range (γ >= 14.14, 0 < δ <= 1/2): the surplus
    δ²(2A+δ²-1) is nonnegative (A >= 1 gives 2A+δ²-1 >= 1). -/
theorem c1b_R1_le_one (γ δ : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2) :
    (1 / 4 + γ ^ 2) ^ 2 ≤
        (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) := by
  have hA : 1 / 4 + γ ^ 2 ≥ 1 := by nlinarith
  have hsurp : 0 ≤ δ ^ 2 * (2 * (1 / 4 + γ ^ 2) + δ ^ 2 - 1) := by
    apply mul_nonneg (pow_two_nonneg δ)
    nlinarith [hA]
  nlinarith [c1b_den_group γ δ, hsurp]

/-- 0 < ω_δ on the pinned range (δ in (0, 1/2], γ >= 14.14):
    (1+2δ)/(A+δ+δ²) > 1/A  (cross-multiplying: 2A > 1 + δ, A >= 200)
    and the (1-2δ) term is nonnegative. -/
theorem c1b_omega_pos (γ δ : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2) :
    0 < omegaD γ δ := by
  dsimp only [omegaD]
  have hA : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hB : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by nlinarith
  have hC : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    rw [show 1 / 4 - δ + δ ^ 2 + γ ^ 2 = γ ^ 2 + (δ - 1 / 2) ^ 2 by ring]
    nlinarith [pow_two_nonneg γ, pow_two_nonneg (δ - 1 / 2),
      show 0 < (707 / 50 : ℝ) ^ 2 by norm_num, hγ]
  have hT1 : 1 / (1 / 4 + γ ^ 2) < (1 + 2 * δ) / (1 / 4 + δ + δ ^ 2 + γ ^ 2) := by
    apply (div_lt_div_iff₀ hA hB).mpr
    have hprod : (1 + 2 * δ) * (1 / 4 + γ ^ 2) - 1 * (1 / 4 + δ + δ ^ 2 + γ ^ 2) =
        δ * (2 * γ ^ 2 - 1 / 2 - δ) := by ring
    have hpos : 2 * γ ^ 2 - 1 / 2 - δ > 0 := by nlinarith
    rw [← sub_pos, hprod]
    exact mul_pos hd hpos
  have ht2 : 0 ≤ (1 - 2 * δ) / (1 / 4 - δ + δ ^ 2 + γ ^ 2) :=
    div_nonneg (by nlinarith) (by nlinarith)
  linarith [hT1, ht2]

/-- ω_δ <= 3/(¼+γ²) on the pinned range.  (1+2δ)/(A+δ+δ²) <= 2/A;
    (1-2δ)/(A-δ+δ²) <= 1/(γ²+(δ-1/2)²) <= 1/γ² <= 2/A;  minus 1/A. -/
theorem c1b_omega_ub (γ δ : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2) :
    omegaD γ δ ≤ 3 / (1 / 4 + γ ^ 2) := by
  have hA : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hB : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by nlinarith
  have hC : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    rw [show 1 / 4 - δ + δ ^ 2 + γ ^ 2 = γ ^ 2 + (δ - 1 / 2) ^ 2 by ring]
    nlinarith [pow_two_nonneg γ, pow_two_nonneg (δ - 1 / 2),
      show 0 < (707 / 50 : ℝ) ^ 2 by norm_num, hγ]
  have hT1 : (1 + 2 * δ) / (1 / 4 + δ + δ ^ 2 + γ ^ 2) ≤ 2 / (1 / 4 + γ ^ 2) := by
    calc _
      _ ≤ 2 / (1 / 4 + δ + δ ^ 2 + γ ^ 2) :=
        div_le_div_of_nonneg_right (by nlinarith) (by nlinarith)
      _ ≤ 2 / (1 / 4 + γ ^ 2) :=
        div_le_div_of_nonneg_left (by nlinarith) (by nlinarith) (by nlinarith)
  have hsq : 1 / 4 - δ + δ ^ 2 + γ ^ 2 = γ ^ 2 + (δ - 1 / 2) ^ 2 := by ring
  have hT2 : (1 - 2 * δ) / (1 / 4 - δ + δ ^ 2 + γ ^ 2) ≤ 1 / (1 / 4 - δ + δ ^ 2 + γ ^ 2) := by
    rw [hsq]
    apply div_le_div_of_nonneg_right (by nlinarith) (by nlinarith)
  have hT2b : 1 / (1 / 4 - δ + δ ^ 2 + γ ^ 2) ≤ 1 / γ ^ 2 := by
    rw [hsq]
    rw [one_div_le_one_div (by nlinarith) (by nlinarith)]
    nlinarith
  have hT2c : 1 / γ ^ 2 ≤ 2 / (1 / 4 + γ ^ 2) := by
    apply (div_le_div_iff₀ (by nlinarith : 0 < γ ^ 2) (by nlinarith : 0 < 1 / 4 + γ ^ 2)).2
    nlinarith
  have homega : omegaD γ δ = (1 + 2 * δ) / (1 / 4 + δ + δ ^ 2 + γ ^ 2) +
      (1 - 2 * δ) / (1 / 4 - δ + δ ^ 2 + γ ^ 2) - 1 / (1 / 4 + γ ^ 2) := by
    dsimp only [omegaD]
  calc omegaD γ δ
    = (1 + 2 * δ) / (1 / 4 + δ + δ ^ 2 + γ ^ 2) +
        (1 - 2 * δ) / (1 / 4 - δ + δ ^ 2 + γ ^ 2) - 1 / (1 / 4 + γ ^ 2) := by rw [homega]
    _ ≤ 2 / (1 / 4 + γ ^ 2) + 1 / γ ^ 2 - 1 / (1 / 4 + γ ^ 2) := by
      linarith [hT1, hT2, hT2b]
    _ = 1 / (1 / 4 + γ ^ 2) + 1 / γ ^ 2 := by ring
    _ ≤ 1 / (1 / 4 + γ ^ 2) + 2 / (1 / 4 + γ ^ 2) := by linarith [hT2c]
    _ = 3 / (1 / 4 + γ ^ 2) := by ring

/-- e^{ω/2} <= 120/119 on the pinned range.  ω/2 <= 3/(2A) with
    A = ¼+γ² and 2A > 360 (γ >= 14.14), so ω/2 < 1/120;  by
    p8_abs_exp_sub_one_le (|e^x - 1| <= e^x·x) at x >= 0:
    e^x <= 1/(1-x) <= 1/(1-1/120) = 120/119. -/
theorem c1b_exp_ub (γ δ : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2) :
    Real.exp (omegaD γ δ / 2) ≤ 120 / 119 := by
  have hpos0 : 0 ≤ omegaD γ δ / 2 := by
    apply div_nonneg
    · nlinarith [c1b_omega_pos γ δ hγ hd hdL]
    · norm_num
  have hA : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hw2 : omegaD γ δ / 2 <= 3 / (2 * (1 / 4 + γ ^ 2)) := by
    have hub : omegaD γ δ <= 3 / (1 / 4 + γ ^ 2) := c1b_omega_ub γ δ hγ hd hdL
    have hmul : omegaD γ δ * (2 * (1 / 4 + γ ^ 2)) <=
        3 / (1 / 4 + γ ^ 2) * (2 * (1 / 4 + γ ^ 2)) :=
      mul_le_mul_of_nonneg_right hub (by nlinarith : 0 <= 2 * (1 / 4 + γ ^ 2))
    have hsix : 3 / (1 / 4 + γ ^ 2) * (2 * (1 / 4 + γ ^ 2)) = 6 := by
      field_simp
      ring
    apply (div_le_div_iff₀ (by norm_num : (0 : ℝ) < 2) (by nlinarith : 0 < 2 * (1 / 4 + γ ^ 2))).2
    ring_nf
    nlinarith [hmul, hsix]
  have hfrac : 3 / (2 * (1 / 4 + γ ^ 2)) < 1 / 120 := by
    apply (div_lt_div_iff₀ (by nlinarith : 0 < 2 * (1 / 4 + γ ^ 2)) (by norm_num : (0 : ℝ) < 120)).2
    norm_num
    nlinarith
  have hx0 : omegaD γ δ / 2 < 1 / 120 := lt_of_le_of_lt hw2 hfrac
  have hx1 : omegaD γ δ / 2 < 1 := by
    linarith [hx0, show 1 / 120 < 1 by norm_num]
  have hexp : Real.exp (omegaD γ δ / 2) - 1 ≤
      Real.exp (omegaD γ δ / 2) * (omegaD γ δ / 2) := by
    have hp := p8_abs_exp_sub_one_le (omegaD γ δ / 2)
    have hx0 : 0 <= omegaD γ δ / 2 := hpos0
    have habse : |omegaD γ δ / 2| = omegaD γ δ / 2 := abs_of_nonneg hx0
    have hrsh : Real.exp |omegaD γ δ / 2| * |omegaD γ δ / 2| =
        Real.exp (omegaD γ δ / 2) * (omegaD γ δ / 2) := by
      simp only [habse]
    calc Real.exp (omegaD γ δ / 2) - 1
      _ ≤ |Real.exp (omegaD γ δ / 2) - 1| := le_abs_self _
      _ ≤ Real.exp |omegaD γ δ / 2| * |omegaD γ δ / 2| := hp
      _ = Real.exp (omegaD γ δ / 2) * (omegaD γ δ / 2) := by rw [hrsh]
  have hinv : Real.exp (omegaD γ δ / 2) <= 1 / (1 - omegaD γ δ / 2) := by
    apply (le_div_iff₀ (by nlinarith [hx0] : 0 < 1 - omegaD γ δ / 2)).2
    have hmult : Real.exp (omegaD γ δ / 2) * (1 - omegaD γ δ / 2) ≤ 1 := by
      have he : Real.exp (omegaD γ δ / 2) >= 1 := Real.one_le_exp (by nlinarith [hpos0])
      nlinarith [hexp, he, hx0]
    exact hmult
  have hfinal : 1 / (1 - omegaD γ δ / 2) ≤ 120 / 119 := by
    have hdpos : 0 < 1 - omegaD γ δ / 2 := by nlinarith [hx0]
    apply (div_le_div_iff₀ hdpos (by norm_num : (0 : ℝ) < 119)).2
    norm_num
    nlinarith [hx0]
  linarith

/-- F(x) = x + 1/(4x) is increasing for x >= 1/2:
    F(y) - F(x) = (y-x)(4xy-1)/(4xy) >= 0 (4xy >= 4·(1/2)·(1/2) = 1). -/
theorem c1b_F_incr (x y : ℝ) (hx : 1 / 2 <= x) (hxy : x <= y) :
    x + 1 / (4 * x) <= y + 1 / (4 * y) := by
  have hposx : 0 < x := by nlinarith
  have hposy : 0 < y := by nlinarith
  have hdiff : y + 1 / (4 * y) - (x + 1 / (4 * x)) =
      (y - x) * (4 * x * y - 1) / (4 * x * y) := by
    field_simp
    ring
  rw [← sub_nonneg, hdiff]
  have h4xy : 0 ≤ 4 * x * y - 1 := by
    have h4x2 : 4 * x * x ≥ 1 := by nlinarith
    nlinarith [hxy]
  apply div_nonneg
  · nlinarith [h4xy, hxy]
  · nlinarith
