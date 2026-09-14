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
   COMPLETE (25s/25t): all atoms green —
     c1b_pref_exact / c1b_pref_shape      — (25r) |pref| exact + shape
     c1b_pref_shape_minus                 — (25s) u = -m shape
     c1b_G_ub / c1b_Fm_ub / c1b_rat_decr  — (25s) rational chain
     c1b_exp_half_ub / c1b_th_ub          — (25s) exp + phase bounds
     c1b_Z_ub                             — (25s) signed Z <= 977/1000
     c1b_disc_floor                       — (25s) THE FLOOR THEOREM
     p9_c1b_disc_floor                    — (25t) P9 closure bridge
   (the p9_f_pin deprecation bridge, 25k [4] scope).

   Honest split: LEAN-PROVEN (no pins in this file); the window
   constants (γ0 = 14.14 lower edge, W = 12, δmax = 1/2) are the
   instrument's pinned range (25i/25k).  Lean 4.33.1 + Mathlib.
-/

open Real
open Complex

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

/-- Exact |pref| identity on the straddle (t = gamma + u, u != 0): all
    denominator factors except -(u*(2*gamma+u)) are positive on the
    pinned range, so the absolute values close to the positive
    rational form. -/
theorem c1b_pref_exact (γ δ u : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hu : 0 < |u|) (huL : |u| ≤ 12) :
    |pref γ δ (γ + u)| =
        (1 / 4 + γ ^ 2) * (u ^ 2 + δ ^ 2) * ((2 * γ + u) ^ 2 + δ ^ 2) /
          (|u| * (2 * γ + u) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) := by
  dsimp only [pref]
  have h2gu : 0 < 2 * γ + u := by
    have h2g : 2 * γ ≥ 2 * (707 / 50) := by nlinarith
    nlinarith [neg_abs_le u, huL, h2g]
  have hCsq : 1 / 4 - δ + δ ^ 2 = (δ - 1 / 2) ^ 2 := by ring
  have hCpos : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    rw [hCsq]
    nlinarith [hγ, pow_two_nonneg (δ - 1 / 2)]
  have hsA : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by nlinarith
  have hsq1 : (γ - (γ + u)) ^ 2 = u ^ 2 := by ring
  have hsq2 : (γ + (γ + u)) ^ 2 = (2 * γ + u) ^ 2 := by ring
  have hden : γ ^ 2 - (γ + u) ^ 2 = -(u * (2 * γ + u)) := by ring
  have hus : u ≠ 0 := by
    rintro h0
    rw [h0] at hu
    simpa using hu
  have hnumpos : 0 ≤ (1 / 4 + γ ^ 2) * (u ^ 2 + δ ^ 2) * ((2 * γ + u) ^ 2 + δ ^ 2) := by
    repeat' (apply mul_nonneg <;> nlinarith)
  rw [hsq1, hsq2, hden]
  have hPabs : |-(u * (2 * γ + u)) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)| =
      |u| * (2 * γ + u) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) := by
    rw [abs_mul, abs_mul, abs_neg, abs_mul, abs_of_pos h2gu, abs_of_pos hsA, abs_of_pos hCpos]
  have hnu : u * (2 * γ + u) ≠ 0 := mul_ne_zero hus (ne_of_gt h2gu)
  have hPnz : -(u * (2 * γ + u)) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) ≠ 0 := by
    rw [mul_assoc]
    exact mul_ne_zero (neg_ne_zero.mpr hnu)
      (mul_ne_zero (ne_of_gt hsA) (ne_of_gt hCpos))
  rw [abs_div, abs_of_nonneg hnumpos, hPabs]


set_option maxHeartbeats 400000 in

/-- |pref(γ,δ,γ+u)| in the (m := |u|) rational shape, the worst case
    δ = 1/2:  |pref| <= (u²+1/4)·((2γ+m)²+1/4) / (m·(2γ+m)·(¼+γ²)).
    Chain: exact form = grouped product --(δ² → 1/4 in the numerator
    factor)--(R1 ≤ 1 via c1b_R1_le_one)--(F-increasing via
    c1b_F_incr on [1/2, ∞)).  Scoped heartbeat bump: the calc normalizes
    6-factor rational expressions (elaboration cost, not stuck). -/
theorem c1b_pref_shape (γ δ u : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hu : 0 < |u|) (huL : |u| ≤ 12) :
    |pref γ δ (γ + u)| ≤
        (u ^ 2 + 1 / 4) * ((2 * γ + |u|) ^ 2 + 1 / 4) /
          (|u| * (2 * γ + |u|) * (1 / 4 + γ ^ 2)) := by
  have hApos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hBpos : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by nlinarith
  have hCpos : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    nlinarith [show 1 / 4 - δ + δ ^ 2 = (δ - 1 / 2) ^ 2 by ring]
  have h2g : 2 * γ ≥ 2 * (707 / 50) := by nlinarith
  have h2gu : 0 < 2 * γ + u := by
    nlinarith [neg_abs_le u, huL, h2g]
  have h2gm : 0 < 2 * γ + |u| := by nlinarith
  have hR1 : (1 / 4 + γ ^ 2) ^ 2 ≤
      (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) :=
    c1b_R1_le_one γ δ hγ hd hdL
  have hmnz : |u| ≠ 0 := (ne_of_lt hu).symm
  have hnzA : 1 / 4 + γ ^ 2 ≠ 0 := ne_of_gt hApos
  have hnzB : 1 / 4 + δ + δ ^ 2 + γ ^ 2 ≠ 0 := ne_of_gt hBpos
  have hnzC : 1 / 4 - δ + δ ^ 2 + γ ^ 2 ≠ 0 := ne_of_gt hCpos
  have hnz2gu : 2 * γ + u ≠ 0 := ne_of_gt h2gu
  have hnz2gm : 2 * γ + |u| ≠ 0 := ne_of_gt h2gm
  have hdelta : δ ^ 2 ≤ 1 / 4 := by
    nlinarith [pow_two_nonneg δ, hdL]
  have hnum1 : u ^ 2 + δ ^ 2 ≤ u ^ 2 + 1 / 4 := by nlinarith [hdelta]
  have hnum2 : (2 * γ + u) ^ 2 + δ ^ 2 ≤ (2 * γ + u) ^ 2 + 1 / 4 := by nlinarith [hdelta]
  have hnum12 : (u ^ 2 + δ ^ 2) * ((2 * γ + u) ^ 2 + δ ^ 2) ≤
      (u ^ 2 + 1 / 4) * ((2 * γ + u) ^ 2 + 1 / 4) := by
    apply mul_le_mul
    · exact hnum1
    · exact hnum2
    · nlinarith
    · nlinarith
  have hst1 : (1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) ≤
      1 / (1 / 4 + γ ^ 2) := by
    apply (div_le_div_iff₀ (by nlinarith [hBpos, hCpos]) (by nlinarith [hApos])).mpr
    nlinarith [hR1]
  have hfu : ((2 * γ + u) ^ 2 + 1 / 4) / (2 * γ + u) =
      (2 * γ + u) + 1 / (4 * (2 * γ + u)) := by
    field_simp [hnz2gu]
    try ring
  have hfm : ((2 * γ + |u|) ^ 2 + 1 / 4) / (2 * γ + |u|) =
      (2 * γ + |u|) + 1 / (4 * (2 * γ + |u|)) := by
    field_simp [hnz2gm]
    try ring
  have hx1 : 1 / 2 ≤ 2 * γ + u := by
    nlinarith [neg_abs_le u, huL, h2g]
  have hxy : 2 * γ + u ≤ 2 * γ + |u| := by nlinarith [le_abs_self u]
  have hF : ((2 * γ + u) ^ 2 + 1 / 4) / (2 * γ + u) ≤
      ((2 * γ + |u|) ^ 2 + 1 / 4) / (2 * γ + |u|) := by
    rw [hfu, hfm]
    exact c1b_F_incr (2 * γ + u) (2 * γ + |u|) hx1 hxy
  have hstep3 : 0 ≤ (u ^ 2 + 1 / 4) / (|u| * (1 / 4 + γ ^ 2)) := by
    apply div_nonneg
    · nlinarith
    · apply mul_nonneg
      · exact abs_nonneg u
      · nlinarith
  have hden01 : 0 ≤ |u| * (2 * γ + u) := by
    apply mul_nonneg
    · exact abs_nonneg u
    · nlinarith
  have hfac : 0 ≤ (1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) := by
    apply div_nonneg
    · nlinarith
    · nlinarith
  have hstep4 : 0 ≤ (u ^ 2 + 1 / 4) * ((2 * γ + u) ^ 2 + 1 / 4) / (|u| * (2 * γ + u)) := by
    apply div_nonneg
    · nlinarith
    · exact hden01
  have hexact := c1b_pref_exact γ δ u hγ hd hdL hu huL
  rw [hexact]
  calc _
    _ = ((u ^ 2 + δ ^ 2) * ((2 * γ + u) ^ 2 + δ ^ 2) / (|u| * (2 * γ + u))) *
        ((1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2))) := by { field_simp [hmnz, hnz2gu, hnzB, hnzC]; try ring }
    _ ≤ ((u ^ 2 + 1 / 4) * ((2 * γ + u) ^ 2 + 1 / 4) / (|u| * (2 * γ + u))) *
        ((1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2))) := (mul_le_mul_of_nonneg_right (div_le_div_of_nonneg_right hnum12 hden01) hfac)
    _ ≤ ((u ^ 2 + 1 / 4) * ((2 * γ + u) ^ 2 + 1 / 4) / (|u| * (2 * γ + u))) *
        (1 / (1 / 4 + γ ^ 2)) := (mul_le_mul_of_nonneg_left hst1 hstep4)
    _ = ((u ^ 2 + 1 / 4) * ((2 * γ + u) ^ 2 + 1 / 4)) /
          (|u| * (2 * γ + u) * (1 / 4 + γ ^ 2)) := by { field_simp [hmnz, hnz2gu, hnzA]; try ring }
    _ = ((u ^ 2 + 1 / 4) / (|u| * (1 / 4 + γ ^ 2))) *
          (((2 * γ + u) ^ 2 + 1 / 4) / (2 * γ + u)) := by { field_simp [hmnz, hnz2gu, hnzA]; try ring }
    _ ≤ ((u ^ 2 + 1 / 4) / (|u| * (1 / 4 + γ ^ 2))) *
          (((2 * γ + |u|) ^ 2 + 1 / 4) / (2 * γ + |u|)) := by { apply mul_le_mul_of_nonneg_left hF; exact hstep3 }
    _ = (u ^ 2 + 1 / 4) * ((2 * γ + |u|) ^ 2 + 1 / 4) /
          (|u| * (2 * γ + |u|) * (1 / 4 + γ ^ 2)) := by { field_simp [hmnz, hnz2gm, hnzA]; try ring }

set_option maxHeartbeats 400000 in

/-- (C1b-2i) The u = -m shape of |pref|, worst-case δ = 1/2:
    |pref(γ,δ,γ-m)| <= (m²+1/4)·((2γ-m)²+1/4) / (m·(2γ-m)·(¼+γ²)).
    The -m analogue of c1b_pref_shape: the exact form already
    carries 2γ-m, so no F-increasing step is needed. -/
theorem c1b_pref_shape_minus (γ m δ : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hm : 0 < m) (hmL : m ≤ 12) :
    |pref γ δ (γ - m)| ≤
        (m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) /
          (m * (2 * γ - m) * (1 / 4 + γ ^ 2)) := by
  have hApos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hBpos : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by nlinarith
  have hCpos : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    nlinarith [show 1 / 4 - δ + δ ^ 2 = (δ - 1 / 2) ^ 2 by ring]
  have h2gm : 0 < 2 * γ - m := by nlinarith
  have hR1 : (1 / 4 + γ ^ 2) ^ 2 ≤
      (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) :=
    c1b_R1_le_one γ δ hγ hd hdL
  have hnzm : m ≠ 0 := ne_of_gt hm
  have hnzA : 1 / 4 + γ ^ 2 ≠ 0 := ne_of_gt hApos
  have hnzB : 1 / 4 + δ + δ ^ 2 + γ ^ 2 ≠ 0 := ne_of_gt hBpos
  have hnzC : 1 / 4 - δ + δ ^ 2 + γ ^ 2 ≠ 0 := ne_of_gt hCpos
  have hnz2gm : 2 * γ - m ≠ 0 := ne_of_gt h2gm
  have hdelta : δ ^ 2 ≤ 1 / 4 := by nlinarith [pow_two_nonneg δ, hdL]
  have hnum1 : m ^ 2 + δ ^ 2 ≤ m ^ 2 + 1 / 4 := by nlinarith [hdelta]
  have hnum2 : (2 * γ - m) ^ 2 + δ ^ 2 ≤ (2 * γ - m) ^ 2 + 1 / 4 := by nlinarith [hdelta]
  have hnum12 : (m ^ 2 + δ ^ 2) * ((2 * γ - m) ^ 2 + δ ^ 2) ≤
      (m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) := by
    apply mul_le_mul
    · exact hnum1
    · exact hnum2
    · nlinarith
    · nlinarith
  have hst1 : (1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) ≤
      1 / (1 / 4 + γ ^ 2) := by
    apply (div_le_div_iff₀ (by nlinarith [hBpos, hCpos]) (by nlinarith [hApos])).mpr
    nlinarith [hR1]
  have hden01 : 0 ≤ m * (2 * γ - m) := by nlinarith
  have hfac : 0 ≤ (1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) := by
    apply div_nonneg
    · nlinarith
    · nlinarith
  have hstep4 : 0 ≤ (m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m)) := by
    apply div_nonneg
    · nlinarith
    · exact hden01
  have habsm : |(-m : ℝ)| = m := by rw [abs_neg, abs_of_pos hm]
  have hun : 0 < |(-m : ℝ)| := by rw [habsm]; exact hm
  have hul : |(-m : ℝ)| ≤ 12 := by rw [habsm]; exact hmL
  have hexact := c1b_pref_exact γ δ (-m) hγ hd hdL hun hul
  rw [show (γ : ℝ) - m = γ + -m from by ring, hexact]
  simp only [abs_neg]
  simp only [show (-m : ℝ) ^ 2 = m ^ 2 by ring,
      show (2 * γ + -m : ℝ) = 2 * γ - m by ring,
      show |m| = m from abs_of_pos hm]
  calc _
    _ = ((m ^ 2 + δ ^ 2) * ((2 * γ - m) ^ 2 + δ ^ 2) / (m * (2 * γ - m))) *
        ((1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2))) := by { field_simp [hnzm, hnz2gm, hnzB, hnzC]; try ring }
    _ ≤ ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m))) *
        ((1 / 4 + γ ^ 2) / ((1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2))) :=
      (mul_le_mul_of_nonneg_right (div_le_div_of_nonneg_right hnum12 hden01) hfac)
    _ ≤ ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m))) *
        (1 / (1 / 4 + γ ^ 2)) := (mul_le_mul_of_nonneg_left hst1 hstep4)
    _ = (m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) /
          (m * (2 * γ - m) * (1 / 4 + γ ^ 2)) := by { field_simp [hnzm, hnz2gm, hnzA]; try ring }

/-- (C1b-2ii) G(m) := (m²+1/4)/m = m + 1/(4m) is at most G(12) = 577/48
    on [1/2, 12]; 48m²-577m+12 = (m-12)(48m-1) <= 0 there. -/
lemma c1b_G_ub (m : ℝ) (hm0 : 1 / 2 ≤ m) (hmL : m ≤ 12) :
    (m ^ 2 + 1 / 4) / m ≤ 577 / 48 := by
  have hpos : 0 < m := by linarith
  rw [div_le_iff₀ hpos]
  have hq : 48 * m ^ 2 - 577 * m + 12 = (m - 12) * (48 * m - 1) := by ring
  have hq0 : (m - 12) * (48 * m - 1) ≤ 0 := by
    apply mul_nonpos_of_nonpos_of_nonneg
    · linarith
    · nlinarith
  have hq0' : 48 * m ^ 2 - 577 * m + 12 ≤ 0 := by rw [hq]; exact hq0
  nlinarith [hq0']

/-- (C1b-2iii) F(2γ-m) := ((2γ-m)²+1/4)/(2γ-m) <= 2γ + 1/152 for
    25 <= γ, 1/2 <= m <= 12:  (2γ-m) <= 2γ and 1/(4(2γ-m)) <= 1/152. -/
lemma c1b_Fm_ub (γ m : ℝ) (hg : 25 ≤ γ) (hm0 : 1 / 2 ≤ m) (hmL : m ≤ 12) :
    ((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m) ≤ 2 * γ + 1 / 152 := by
  have hx : 0 < 2 * γ - m := by nlinarith
  have hF : ((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m) =
      (2 * γ - m) + 1 / (4 * (2 * γ - m)) := by
    field_simp [hx]
  have ha : 2 * γ - m ≤ 2 * γ := by nlinarith
  have hb : 1 / (4 * (2 * γ - m)) ≤ 1 / 152 := by
    rw [div_le_div_iff₀ (by nlinarith) (by norm_num)]
    nlinarith
  rw [hF]
  exact add_le_add ha hb

/-- (C1b-2iv) (2γ+1/152)/(γ²+1/4) is at most its γ = 25 value,
    7601/95038; the cross-multiplied gap is (γ-25)(7601γ-51). -/
lemma c1b_rat_decr (γ : ℝ) (hg : 25 ≤ γ) :
    (2 * γ + 1 / 152) / (γ ^ 2 + 1 / 4) ≤ 7601 / 95038 := by
  have hden : 0 < γ ^ 2 + 1 / 4 := by nlinarith
  have hq : 7601 * γ ^ 2 - 190076 * γ + 1275 = (γ - 25) * (7601 * γ - 51) := by ring
  have hq0 : 0 ≤ (γ - 25) * (7601 * γ - 51) := by
    apply mul_nonneg
    · linarith
    · nlinarith
  have hs : 7601 * γ ^ 2 - 190076 * γ + 1275 ≥ 0 := by rw [hq]; exact hq0
  field_simp [hden]
  nlinarith [hs]

/-- (C1b-2v) exp(ω/2) <= 1252/1249 for 25 <= γ:  ω/2 <= 3/(2A) <= 6/2501
    and the rational bound Real.exp_le_two_add_div_two_sub (x < 2). -/
lemma c1b_exp_half_ub (γ δ : ℝ) (hg : 25 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2) :
    Real.exp (omegaD γ δ / 2) ≤ 1252 / 1249 := by
  have hAlow : 2501 / 4 ≤ 1 / 4 + γ ^ 2 := by nlinarith
  have hApos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have h1 : omegaD γ δ / 2 ≤ (3 : ℝ) / (2 * (1 / 4 + γ ^ 2)) := by
    have h25 : (707 : ℝ) / 50 ≤ 25 := by norm_num
    have hγ' : 707 / 50 ≤ γ := le_trans h25 hg
    have hω : omegaD γ δ ≤ 3 / (1 / 4 + γ ^ 2) := c1b_omega_ub γ δ hγ' hd hdL
    have hω2 : omegaD γ δ * (1 / 4 + γ ^ 2) ≤ 3 := by
      calc omegaD γ δ * (1 / 4 + γ ^ 2)
          _ ≤ (3 / (1 / 4 + γ ^ 2)) * (1 / 4 + γ ^ 2) :=
            mul_le_mul_of_nonneg_right hω (by positivity)
          _ = 3 := by field_simp
    rw [div_le_div_iff₀ (by norm_num) (by positivity)]
    nlinarith [hω2]
  have hmid : (3 / 2 : ℝ) / (1 / 4 + γ ^ 2) ≤ (3 / 2) / (2501 / 4) :=
    div_le_div_of_nonneg_left (by norm_num) (by norm_num) hAlow
  have h2 : (3 : ℝ) / (2 * (1 / 4 + γ ^ 2)) ≤ 6 / 2501 := by
    calc (3 : ℝ) / (2 * (1 / 4 + γ ^ 2))
        _ = (3 / 2 : ℝ) / (1 / 4 + γ ^ 2) := by field_simp
        _ ≤ (3 / 2) / (2501 / 4) := hmid
        _ = 6 / 2501 := by norm_num
  have hx0 : (0 : ℝ) ≤ 6 / 2501 := by norm_num
  have hx2 : (6 : ℝ) / 2501 < 2 := by norm_num
  have h3 : Real.exp (omegaD γ δ / 2) ≤ Real.exp (6 / 2501) :=
    Real.exp_le_exp.mpr (le_trans h1 h2)
  calc Real.exp (omegaD γ δ / 2)
      _ ≤ Real.exp (6 / 2501) := h3
      _ ≤ (2 + 6 / 2501) / (2 - 6 / 2501) := Real.exp_le_two_add_div_two_sub hx0 hx2
      _ = 1252 / 1249 := by norm_num

/-- (C1b-2vi) Phase bound: (γ+u)·ω <= 444/2501 for 25 <= γ, |u| <= 12.
    t := γ+u lies in [13, γ+12];  ω <= 3/(¼+γ²);  the rational
    (3(γ+12))/(γ²+1/4) is decreasing (gap (γ-25)(444γ+3597) >= 0). -/
lemma c1b_th_ub (γ δ u : ℝ) (hg : 25 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hum : 1 / 2 ≤ |u|) (huL : |u| ≤ 12) :
    (γ + u) * omegaD γ δ ≤ 444 / 2501 := by
  have hu1 : -12 ≤ u := (abs_le.mp huL).1
  have hu2 : u ≤ 12 := (abs_le.mp huL).2
  have ht0 : 0 ≤ γ + u := by nlinarith [hu1]
  have hω0 : 0 ≤ omegaD γ δ := (c1b_omega_pos γ δ (by nlinarith [hg]) hd hdL).le
  have h25 : (707 : ℝ) / 50 ≤ 25 := by norm_num
  have hωub : omegaD γ δ ≤ 3 / (1 / 4 + γ ^ 2) :=
    c1b_omega_ub γ δ (le_trans h25 hg) hd hdL
  have hApos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have htub : γ + u ≤ γ + 12 := by nlinarith [hu2]
  have hq : 444 * γ ^ 2 - 7503 * γ - 89925 = (γ - 25) * (444 * γ + 3597) := by ring
  have hq0 : 0 ≤ (γ - 25) * (444 * γ + 3597) := by
    apply mul_nonneg
    · linarith
    · nlinarith
  have hqpos : 444 * γ ^ 2 - 7503 * γ - 89925 ≥ 0 := by rw [hq]; exact hq0
  calc (γ + u) * omegaD γ δ
      _ ≤ (γ + u) * (3 / (1 / 4 + γ ^ 2)) :=
        mul_le_mul_of_nonneg_left hωub ht0
      _ ≤ (γ + 12) * (3 / (1 / 4 + γ ^ 2)) :=
        mul_le_mul_of_nonneg_right htub (by positivity)
      _ ≤ 444 / 2501 := by { field_simp [hApos]; nlinarith [hqpos] }

set_option maxHeartbeats 400000 in

/-- (C1b-2vii) The signed-Z bound, 25 <= γ:
    pref(γ,δ,γ-m)·exp(ω/2) <= 977/1000  when pref >= 0.
    Chain:  |pref| shape (2γ-m form) --(G(m) <= 577/48,  F <= 2γ+1/152,
    ratio decreasing in γ,  exp(ω/2) <= 1252/1249) --(977/1000). -/
theorem c1b_Z_ub (γ m δ : ℝ) (hg : 25 ≤ γ) (hm0 : 1 / 2 ≤ m) (hmL : m ≤ 12)
    (hd : 0 < δ) (hdL : δ ≤ 1 / 2) (hpref : 0 ≤ pref γ δ (γ - m)) :
    pref γ δ (γ - m) * Real.exp (omegaD γ δ / 2) ≤ 977 / 1000 := by
  have hmpos : 0 < m := by linarith
  have hshape := c1b_pref_shape_minus γ m δ (by nlinarith [hg]) hd hdL hmpos hmL
  have hexp : Real.exp (omegaD γ δ / 2) ≤ 1252 / 1249 := c1b_exp_half_ub γ δ hg hd hdL
  have h1 : pref γ δ (γ - m) * Real.exp (omegaD γ δ / 2) ≤
      |pref γ δ (γ - m)| * Real.exp (omegaD γ δ / 2) :=
    mul_le_mul_of_nonneg_right (le_abs_self (pref γ δ (γ - m))) (Real.exp_pos (omegaD γ δ / 2)).le
  have hshape_exp : |pref γ δ (γ - m)| * Real.exp (omegaD γ δ / 2) ≤
      ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
        Real.exp (omegaD γ δ / 2) :=
    mul_le_mul_of_nonneg_right hshape (Real.exp_pos (omegaD γ δ / 2)).le
  have hshape0 : 0 ≤ (m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2)) := by
    apply div_nonneg
    · nlinarith
    · apply mul_nonneg
      · apply mul_nonneg
        · linarith [hmpos]
        · nlinarith
      · nlinarith
  have h2 : ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
      Real.exp (omegaD γ δ / 2) ≤
      ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
        (1252 / 1249) :=
    mul_le_mul_of_nonneg_left hexp hshape0
  have hx : 0 < 2 * γ - m := by nlinarith
  have hApos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  have hX : (m ^ 2 + 1 / 4) / m ≤ 577 / 48 := c1b_G_ub m hm0 hmL
  have hY : ((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m) ≤ 2 * γ + 1 / 152 :=
    c1b_Fm_ub γ m hg hm0 hmL
  have hY0 : 0 ≤ ((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m) := by
    apply div_nonneg
    · nlinarith
    · nlinarith
  have hXY : ((m ^ 2 + 1 / 4) / m) * (((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m)) ≤
      (577 / 48) * (2 * γ + 1 / 152) := by
    simpa only [mul_comm] using mul_le_mul hX hY hY0 (by norm_num)
  have hR : (2 * γ + 1 / 152) / (1 / 4 + γ ^ 2) ≤ 7601 / 95038 := by
    simpa [add_comm] using c1b_rat_decr γ hg
  have hS : (577 / 48) * ((2 * γ + 1 / 152) / (1 / 4 + γ ^ 2)) ≤ (577 / 48) * (7601 / 95038) :=
    mul_le_mul_of_nonneg_left hR (by norm_num)
  have hshp : ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) =
      (((m ^ 2 + 1 / 4) / m) * (((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m))) / (1 / 4 + γ ^ 2) := by
    field_simp [hmpos, hx, hApos]
  have h3 : ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
      (1252 / 1249) ≤ 977 / 1000 := by
    calc _
      _ = ((((m ^ 2 + 1 / 4) / m) * (((2 * γ - m) ^ 2 + 1 / 4) / (2 * γ - m))) /
          (1 / 4 + γ ^ 2)) * (1252 / 1249) := by rw [hshp]
      _ ≤ (((577 / 48) * (2 * γ + 1 / 152)) / (1 / 4 + γ ^ 2)) * (1252 / 1249) := by {
        apply mul_le_mul_of_nonneg_right;
        · apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
          nlinarith [hXY]
        · norm_num }
      _ = (577 / 48) * ((2 * γ + 1 / 152) / (1 / 4 + γ ^ 2)) * (1252 / 1249) := by
        field_simp [hApos]
      _ ≤ (577 / 48) * (7601 / 95038) * (1252 / 1249) :=
        mul_le_mul_of_nonneg_right hS (by norm_num)
      _ ≤ 977 / 1000 := by norm_num
  calc pref γ δ (γ - m) * Real.exp (omegaD γ δ / 2)
      _ ≤ |pref γ δ (γ - m)| * Real.exp (omegaD γ δ / 2) := h1
      _ ≤ ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
        Real.exp (omegaD γ δ / 2) := hshape_exp
      _ ≤ ((m ^ 2 + 1 / 4) * ((2 * γ - m) ^ 2 + 1 / 4) / (m * (2 * γ - m) * (1 / 4 + γ ^ 2))) *
        (1252 / 1249) := h2
      _ ≤ 977 / 1000 := h3

set_option maxHeartbeats 400000 in

/-- (C1b) THE DISCRETE-STRADDLE FLOOR:
    ‖R(γ,δ,γ+u) - 1‖ >= min (23/1000) (1 - 25/γ)  on the measured grid
    707/50 <= γ,  0 < δ <= 1/2,  u != 0,  1/2 <= |u| <= 12.

    Proof split on the sign of Z := pref·exp(ω/2) (Re R = Z·cos θ):
      Z >= 0:  b5PrefSign gives u < 0, so t = γ - |u|;  the c1b_Z_ub
        chain gives Z <= 977/1000, hence  |Re R - 1| = 1 - Re R >= 1 - Z
        >= 23/1000  (and min <= 23/1000 unconditionally).
      Z < 0:   the phase bound θ <= 444/2501 and 1 - x²/2 <= cos x give
        Re R = Z·cos θ <= Z·(1 - (444/2501)²/2) < 0, hence
        |Re R - 1| >= 1.
      γ < 25:  1 - 25/γ < 0, so the min is negative and ‖·‖ >= 0 suffices.

    The exp bound Real.exp_le_two_add_div_two_sub (mathlib, verified
    against the pinned 4.33.1 build) is the only non-obvious analytic
    input; everything else is all-positive polynomial arithmetic. -/
theorem c1b_disc_floor (γ δ u : ℝ) (hγ : 707 / 50 ≤ γ) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hum : 1 / 2 ≤ |u|) (huL : |u| ≤ 12) (hu0 : u ≠ 0) :
    ‖Rratio γ δ (γ + u) - 1‖ ≥ min (23 / 1000) (1 - 25 / γ) := by
  have hγp : 0 < γ := by linarith
  have hu1 : -12 ≤ u := (abs_le.mp huL).1
  have hu2 : u ≤ 12 := (abs_le.mp huL).2
  have ht0 : 0 < γ + u := by nlinarith
  have htne : γ + u ≠ γ := by
    by_contra h
    have heq : u = 0 := by linarith
    exact hu0 heq
  have hRe0 : (sLine (γ + u) * (omegaD γ δ : ℂ)).re = omegaD γ δ / 2 := by
    simp [sLine, ofReal_re, ofReal_im, mul_I_re, mul_I_im]
    <;> (norm_num [halfR]; ring)
  have hIm0 : (sLine (γ + u) * (omegaD γ δ : ℂ)).im = (γ + u) * omegaD γ δ := by
    simp [sLine, ofReal_re, ofReal_im, mul_I_re, mul_I_im, mul_im]
    <;> ring
  set Z := pref γ δ (γ + u) * Real.exp (omegaD γ δ / 2) with hZ_def
  have hRe : (Rratio γ δ (γ + u) - 1).re =
      pref γ δ (γ + u) * Real.exp (omegaD γ δ / 2) * Real.cos ((γ + u) * omegaD γ δ) - 1 := by
    rw [b5Ratio hγp ht0 htne δ, sub_re, mul_re, ofReal_im, zero_mul, ofReal_re,
        one_re, Complex.exp_re, hRe0, hIm0]
    ring
  have hRe2 : (Rratio γ δ (γ + u) - 1).re = Z * Real.cos ((γ + u) * omegaD γ δ) - 1 := by
    simpa [hZ_def] using hRe
  have hnormre : ‖Rratio γ δ (γ + u) - 1‖ ≥ |Z * Real.cos ((γ + u) * omegaD γ δ) - 1| := by
    rw [← hRe2]
    exact Complex.abs_re_le_norm (Rratio γ δ (γ + u) - 1)
  by_cases hZpos : 0 ≤ Z
  · by_cases hγ25 : (25 : ℝ) ≤ γ
    · have hupref : 0 ≤ pref γ δ (γ + u) := by
        by_contra hn
        push_neg at hn
        have hneg : Z < 0 := by
          rw [hZ_def]
          nlinarith [hn, Real.exp_pos (omegaD γ δ / 2)]
        nlinarith [hZpos, hneg]
      have hunneg : u < 0 := by
        by_contra h
        push_neg at h
        have hupos : 0 < u := lt_of_le_of_ne h (Ne.symm hu0)
        have htpos : γ < γ + u := by linarith
        have hneg : pref γ δ (γ + u) < 0 := (b5PrefSign hγp ht0 htne δ).mpr htpos
        nlinarith [hupref, hneg]
      have htu : γ + u = γ - |u| := by
        have hus : u + |u| = 0 := by
          rw [abs_of_neg hunneg]
          ring
        rw [show γ - |u| = γ + u from by nlinarith [hus]]
      have hZub : Z ≤ 977 / 1000 := by
        have hZm : Z = pref γ δ (γ - |u|) * Real.exp (omegaD γ δ / 2) := by
          rw [hZ_def, htu]
        rw [hZm]
        exact c1b_Z_ub γ (|u|) δ hγ25 hum huL hd hdL (by simpa [htu] using hupref)
      have hReub : Z * Real.cos ((γ + u) * omegaD γ δ) ≤ Z := by
        simpa [mul_comm, mul_one] using mul_le_mul_of_nonneg_right (Real.cos_le_one _) hZpos
      have hlt10 : Z * Real.cos ((γ + u) * omegaD γ δ) - 1 ≤ 0 := by
        nlinarith [hReub, hZub]
      have habs : |Z * Real.cos ((γ + u) * omegaD γ δ) - 1| =
          1 - Z * Real.cos ((γ + u) * omegaD γ δ) := by
        rw [abs_of_nonpos hlt10, neg_sub]
      calc ‖Rratio γ δ (γ + u) - 1‖
          _ ≥ |Z * Real.cos ((γ + u) * omegaD γ δ) - 1| := hnormre
          _ = 1 - Z * Real.cos ((γ + u) * omegaD γ δ) := habs
          _ ≥ 1 - Z := by linarith [hReub]
          _ ≥ 1 - 977 / 1000 := by linarith [hZub]
          _ = 23 / 1000 := by norm_num
          _ ≥ min (23 / 1000) (1 - 25 / γ) := min_le_left (23 / 1000) (1 - 25 / γ)
    · have h1 : 1 - 25 / γ < 0 := by
        rw [show 1 - 25 / γ = (γ - 25) / γ by field_simp [hγp.ne']] 
        rw [div_neg_iff]
        exact Or.inr ⟨by nlinarith, hγp⟩
      linarith [min_le_right (23 / 1000) (1 - 25 / γ), norm_nonneg (Rratio γ δ (γ + u) - 1), h1]
  · by_cases hγ25 : (25 : ℝ) ≤ γ
    · have hZneg : Z < 0 := not_le.mp hZpos
      have hθ0 : 0 ≤ (γ + u) * omegaD γ δ := by
        apply mul_nonneg
        · linarith
        · exact (c1b_omega_pos γ δ (by nlinarith [hγ]) hd hdL).le
      have hthub : (γ + u) * omegaD γ δ ≤ 444 / 2501 := c1b_th_ub γ δ u hγ25 hd hdL hum huL
      have hc0pos : 0 < 1 - (444 / 2501) ^ 2 / 2 := by norm_num
      have hc0 : 1 - (444 / 2501) ^ 2 / 2 ≤ Real.cos ((γ + u) * omegaD γ δ) := by
        have hsq : ((γ + u) * omegaD γ δ) ^ 2 ≤ (444 / 2501) ^ 2 := by
          rw [pow_two, pow_two]
          nlinarith [hθ0, hthub]
        calc 1 - (444 / 2501) ^ 2 / 2
            _ ≤ 1 - ((γ + u) * omegaD γ δ) ^ 2 / 2 := by nlinarith [hsq]
            _ ≤ Real.cos ((γ + u) * omegaD γ δ) := one_sub_sq_div_two_le_cos
      have hZc : Z * Real.cos ((γ + u) * omegaD γ δ) ≤ Z * (1 - (444 / 2501) ^ 2 / 2) := by
        exact mul_le_mul_of_nonpos_left hc0 hZneg.le
      have hlt10 : Z * Real.cos ((γ + u) * omegaD γ δ) - 1 ≤ 0 := by
        nlinarith [hZc, hZneg, hc0pos]
      have habs : |Z * Real.cos ((γ + u) * omegaD γ δ) - 1| =
          1 - Z * Real.cos ((γ + u) * omegaD γ δ) := by
        rw [abs_of_nonpos hlt10, neg_sub]
      calc ‖Rratio γ δ (γ + u) - 1‖
          _ ≥ |Z * Real.cos ((γ + u) * omegaD γ δ) - 1| := hnormre
          _ = 1 - Z * Real.cos ((γ + u) * omegaD γ δ) := habs
          _ ≥ 1 - Z * (1 - (444 / 2501) ^ 2 / 2) := by linarith [hZc]
          _ ≥ 1 := by nlinarith [hZneg, hc0pos]
          _ ≥ 23 / 1000 := by norm_num
          _ ≥ min (23 / 1000) (1 - 25 / γ) := min_le_left (23 / 1000) (1 - 25 / γ)
    · have h1 : 1 - 25 / γ < 0 := by
        rw [show 1 - 25 / γ = (γ - 25) / γ by field_simp [hγp.ne']] 
        rw [div_neg_iff]
        exact Or.inr ⟨by nlinarith, hγp⟩
      linarith [min_le_right (23 / 1000) (1 - 25 / γ), norm_nonneg (Rratio γ δ (γ + u) - 1), h1]

/- (25t) The P9 closure bridge: the discrete-floor theorem restated
   against the closure's pin, with the deprecation note (25k [4]). -/

/-- (C1b → P9) THE DISCRETE-STRADDLE FLOOR AT THE CLOSURE LEVEL:
    ‖R(g,δ,g+u) - 1‖ ≥ min (23/1000) (1 - 25/g)  for  707/50 ≤ g,
    0 < δ ≤ 1/2,  u ∈ (1/2·ℤ) \ {0}, |u| ≤ 12.

    DEPRECATION NOTE (25k [3][4]): the day-010 measured window pin
    p9_f_pin = 0.9975 IS the u = -12 corner of this same discrete
    curve at its audit height (1 - 24.0458/10³ ≈ 0.9975; the proven
    constants 23/1000 and 25 carry the 4% margin).  This theorem
    replaces the MEASURED window floor by a PROVEN one on the
    discrete grid: no measurement input remains for the grid floor.
    Per the 25k scope decision the pin itself stays the
    witness-scale constant of the hmargin instantiation (the closure
    measures dev per witness point and never evaluates the window
    floor) — the promotion's value is bookkeeping-grade. -/
theorem p9_c1b_disc_floor (g δ u : ℝ) (hg : 707 / 50 ≤ g) (hd : 0 < δ) (hdL : δ ≤ 1 / 2)
    (hum : 1 / 2 ≤ |u|) (huL : |u| ≤ 12) (hu0 : u ≠ 0) :
    ‖Rratio g δ (g + u) - 1‖ ≥ min (23 / 1000) (1 - 25 / g) :=
  c1b_disc_floor g δ u hg hd hdL hum huL hu0
