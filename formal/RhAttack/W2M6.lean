/-
# (W2, M6)  W2-BEYOND section 7 open content (c) RE-PIN:  G2 = 3e10,
##  with K in Milino form (CITED hypothesis); the data-free branch
##  of the [S1] wire, refuted AT THE PIN.
##
##  Companion unit to W2M5.lean (same data-adjacent pinned-constant
##  pattern; GREEN target, no `sorry`).  Formal twin of the S1-A1
##  exploration E14-E16 (docs/S1-A1-EXPLORATION.md):
##
##    The 3e10 wire is O(1)-normalized (dev_feed = 1 - 13/g <= 1),
##    and any CITE-able, PIN-able uniform bound on the zero-argument
##    step function prices the walk channel at K * C with
##    C >= |p(G1)| >= 1151/100 on the band; at the Milino pin
##    K_mil(3e10) in [612/100, 615/100) the one-sided cost is
##    >= 70, i.e. two-plus orders above the total budget.  The
##    refutation is EXACT:  it is proven here from the cited
##    Milino form plus the band's own left-pin kernel, not measured.
##    (The measured full-channel figure, 509..608 on the 505 in-hand
##    straddles, is strictly larger because C also carries |p(G2)|
##    and the zero-partition TV; this file proves its FLOOR.)
##
##  Contents (all from first principles over mathlib; the only
##  trusted numeric pins are Real.exp_one_gt_d9 / Real.exp_one_lt_d9,
##  i.e.  2.7182818283 < e < 2.7182818286; every other comparison
##  is a closed rational decided by norm_num, each independently
##  verified with exact rational arithmetic before encoding):
##
##  A.  e pins + fractional-height exp bounds via mathlib
##      Real.exp_bound / Real.exp_bound' partial sums
##  B.  the big exp decompositions  e^(n + f) = (e^1)^n * e^f
##      (Real.exp_add + Real.exp_nat_mul bridges on e^1):
##        exp (241/10) < 3e10,   3e10 < exp (121/5),
##        exp (318/100) < 241/10,  121/5 < exp (16/5),
##        exp (57601/10000) < 320
##  C.  log(3e10) in (241/10, 121/5);  loglog(3e10) in (318/100, 16/5)
##  D.  612/100 <= K_mil(3e10) < 615/100
##      where K_mil T = 0.111 log T + 0.275 loglog T + 2.45 + 1/8:
##      TRUDGUAN 2012 (arXiv:1208.5846 Th.1) uniform S-bound,
##      (legacy label "Milino" in this file -- see the attribution
##      note under the K_mil def; verified online: the arithmetic
##      is Trudgian's).
##      zero-height specialization + the exact 1/8 zero-grid
##      convention (E16).  TRUDGUAN'S THEOREM IS CITED, not proven
##      in this file; its 3e10 value is pinned here.
##  E.  pG1 t >= 1151/100 for t >= 3.2e9  (pG1_pin_lower;  the
##      quantity is positive there, so |pG1 t| = pG1 t)
##  F.  K_mil(3e10) * |pG1 t| >= 70 > 1 >= dev_feed
##      (milino_channel_ge_70, refutation_3e10)
##  G.  m6_floor:  the e4_tailFloor wire statement instantiated
##      with K := K_mil(3e10) under the CITED hypothesis
##      |DN gamma| <= K_mil(3e10) at every partition point —
##      the re-pin of W2-BEYOND section 7(c).
-/
import Mathlib
import RhAttack.W2Bound

open BigOperators Real

namespace W2M6

-- The 3e10 band frontier (R1: N(3e10) = 101635962231 zeros; the
-- last zero under 3e10 pinned at 29999999999.762012).
def G2_pin : ℝ := 3 * 10 ^ 10

-- The band's left pin g = 1e7 (g^2 = 10^14).
def G1_pin : ℝ := 1 * 10 ^ 7

-- MILINO'S UNIFORM S-BOUND (legacy name; the theorem is TRUDGUAN'S,
-- see the attribution note below), Milino form, plus the project's exact
-- zero-grid convention offset +1/8 (E16:  DN(gamma) - S(gamma+)
-- equals 1/8 to better than 2e-5 across the top-5 positive
-- excursions; exactly 1/8 up to O(1/gamma) on the zero grid,
-- since DN counts the zero exactly and Nas/S carry the 3/4 and 7/8
-- convention split).  TRUDGUAN 2012, arXiv:1208.5846, Theorem 1:
-- |S(t)| <= 0.111 log t + 0.275 loglog t + 2.45 (t >= e).
-- CITED (a theorem of the literature), not proven here.
--
-- ATTRIBUTION NOTE (valiant-effort pass, verified online):  the
-- constants 0.111/0.275/2.450 and the arXiv number 1208.5846 are
-- Timothy Trudgian, "An improved upper bound for the argument of
-- the Riemann zeta-function on the critical line II", Math. Comp.
-- 81 (2012) 1053-1061, Theorem 1.  The adjacent B. Milino S(t)
-- paper (Ole Miss) and Carneiro-Chandee-Milinovich (arXiv:1503.00955,
-- the RH (1/4) log t / loglog t form) are different results; see
-- RH-LEAN-PROVENANCE.md [A1G-5].  Identifier K_mil kept (legacy
-- label; renaming would ripple through the pins).  The adjacent
-- Platt-Trudgian 2015 form |S(t)| <= 0.11 log t + 0.29 loglog t +
-- 2.29 (t >= e), as cited in arXiv:2010.13307, is marginally
-- sharper at the 3e10 frontier (~5.87 vs ~6.00).
noncomputable def K_mil (T : ℝ) : ℝ :=
  111 / 1000 * Real.log T + 275 / 1000 * Real.log (Real.log T) + (245 / 100 + 1 / 8)

-- The wire kernel p(g; t) at the band's LEFT pin g = 1e7 (E15 form):
--   p = log |g^2 - t^2| - log (g^2 + 1/4) + (1/2)/(g^2 + 1/4)
-- On the band t >= 3.2e9 > g, so |g^2 - t^2| = t^2 - g^2 and the
-- quantity is positive (far lobe ~ 2 log(t/g)).
noncomputable def pG1 (t : ℝ) : ℝ :=
  Real.log (t ^ 2 - 1 * 10 ^ 14) - Real.log (1 * 10 ^ 14 + 1 / 4) +
    (1 / 2) / (1 * 10 ^ 14 + 1 / 4)

-- ------------------------------------------------------------
-- A.  the e pins and the fractional-height exp bounds
-- ------------------------------------------------------------

-- Decimal pins for e (mathlib Real.exp_one_gt_d9 / Real.exp_one_lt_d9).
noncomputable def e1L : ℝ := 27182818283 / 10 ^ 10
noncomputable def e1U : ℝ := 27182818286 / 10 ^ 10

theorem heL : e1L < Real.exp 1 := by
  have heq : e1L = (2.7182818283 : ℝ) := by norm_num [e1L]
  rw [heq]
  exact Real.exp_one_gt_d9

theorem heU : Real.exp 1 < e1U := by
  have heq : e1U = (2.7182818286 : ℝ) := by norm_num [e1U]
  rw [heq]
  exact Real.exp_one_lt_d9

-- The e^n = (e^1)^n bridges needed below (Real.exp_nat_mul, with the
-- single cast hole closed by norm_num).
theorem exp1pow_3 : Real.exp 3 = Real.exp 1 ^ 3 := by
  convert (Real.exp_nat_mul 1 3) using 1
  · norm_num

theorem exp1pow_5 : Real.exp 5 = Real.exp 1 ^ 5 := by
  convert (Real.exp_nat_mul 1 5) using 1
  · norm_num

theorem exp1pow_24 : Real.exp 24 = Real.exp 1 ^ 24 := by
  convert (Real.exp_nat_mul 1 24) using 1
  · norm_num

-- Fractional pins (mathlib partial-sum bounds + closed-rational
-- norm_num comparisons):

-- exp (1/10) < 11052/10000                [25-term upper]
theorem expfrac_1_10_u : Real.exp (1 / 10) < 11052 / 10000 := by
  have hstep := Real.exp_bound' (x := (1 / 10 : ℝ)) (n := 25) (by norm_num) (by norm_num) (by norm_num)
  calc
    Real.exp (1 / 10) ≤ _ := hstep
    _ < 11052 / 10000 := by norm_num

-- 122140/100000 < exp (1/5)               [24-term absolute]
theorem expfrac_1_5_l : 122140 / 100000 < Real.exp (1 / 5) := by
  have hstep := Real.exp_bound (x := (1 / 5 : ℝ)) (n := 24) (by norm_num) (by norm_num)
  have hlow :
      122140 / 100000 <
        (Finset.sum (Finset.range 24) fun m : ℕ => (1 / 5 : ℝ) ^ m / (m.factorial : ℝ)) -
          |(1 / 5 : ℝ)| ^ 24 * (((24 : ℕ).succ : ℝ) / (((24 : ℕ).factorial : ℝ) * ((24 : ℕ) : ℝ))) := by
    norm_num
  have hlo :
      (Finset.sum (Finset.range 24) fun m : ℕ => (1 / 5 : ℝ) ^ m / (m.factorial : ℝ)) -
        Real.exp (1 / 5) ≤
        |(1 / 5 : ℝ)| ^ 24 * (((24 : ℕ).succ : ℝ) / (((24 : ℕ).factorial : ℝ) * ((24 : ℕ) : ℝ))) := by
    exact (abs_sub_le_iff.1 hstep).2
  calc
    122140 / 100000 < _ := hlow
    _ ≤ Real.exp (1 / 5) := by linarith [hlo]

-- ------------------------------------------------------------
-- B.  the big exp decompositions and their pins
-- ------------------------------------------------------------

-- exp (241/10) < 3·10^10
theorem big241u : Real.exp (241 / 10) < 3 * 10 ^ 10 := by
  have h1 : Real.exp (241 / 10) = Real.exp 1 ^ 24 * Real.exp (1 / 10) := by
    rw [show (241 / 10 : ℝ) = 24 + 1 / 10 from by norm_num, Real.exp_add 24 (1 / 10), exp1pow_24]
  calc
    Real.exp (241 / 10) = Real.exp 1 ^ 24 * Real.exp (1 / 10) := h1
    _ ≤ e1U ^ 24 * Real.exp (1 / 10) := by
      gcongr <;> (try exact heU.le) <;> positivity
    _ < e1U ^ 24 * (11052 / 10000) := by
      gcongr <;> (try exact expfrac_1_10_u) <;> (try norm_num [e1U]) <;> positivity
    _ < 3 * 10 ^ 10 := by norm_num [e1U]

-- 3·10^10 < exp (121/5)
theorem big242l : 3 * 10 ^ 10 < Real.exp (121 / 5) := by
  have h1 : Real.exp (121 / 5) = Real.exp 1 ^ 24 * Real.exp (1 / 5) := by
    rw [show (121 / 5 : ℝ) = 24 + 1 / 5 from by norm_num, Real.exp_add 24 (1 / 5), exp1pow_24]
  calc (3 * 10 ^ 10 : ℝ) < e1L ^ 24 * (122140 / 100000) := by norm_num [e1L]
    _ < e1L ^ 24 * Real.exp (1 / 5) := by
      gcongr <;> (try exact expfrac_1_5_l) <;> (try norm_num [e1L]) <;> positivity
    _ ≤ Real.exp 1 ^ 24 * Real.exp (1 / 5) := by
      gcongr <;> (try exact heL.le) <;> (try norm_num [e1L]) <;> positivity
    _ = Real.exp (121 / 5) := by rw [h1]

-- exp (318/100) < 241/10
theorem big318u : Real.exp (318 / 100) < 241 / 10 := by
  have h1 : Real.exp (318 / 100) = Real.exp 1 ^ 3 * Real.exp (9 / 50) := by
    rw [show (318 / 100 : ℝ) = 3 + 9 / 50 from by norm_num, Real.exp_add 3 (9 / 50), exp1pow_3]
  have hfrac : Real.exp (9 / 50) ≤
      (Finset.sum (Finset.range 21) fun m : ℕ => (9 / 50 : ℝ) ^ m / (m.factorial : ℝ)) +
        (9 / 50 : ℝ) ^ 21 * (((21 : ℕ) : ℝ) + 1) / (((21 : ℕ).factorial : ℝ) * ((21 : ℕ) : ℝ)) := by
    have hstep :=
      Real.exp_bound' (x := (9 / 50 : ℝ)) (n := 21) (by norm_num) (by norm_num) (by norm_num)
    exact hstep
  calc
    Real.exp (318 / 100) = Real.exp 1 ^ 3 * Real.exp (9 / 50) := h1
    _ ≤ e1U ^ 3 * Real.exp (9 / 50) := by
      gcongr <;> (try exact heU.le) <;> positivity
    _ ≤ e1U ^ 3 * ((Finset.sum (Finset.range 21) fun m : ℕ => (9 / 50 : ℝ) ^ m / (m.factorial : ℝ)) +
        (9 / 50 : ℝ) ^ 21 * (((21 : ℕ) : ℝ) + 1) / (((21 : ℕ).factorial : ℝ) * ((21 : ℕ) : ℝ))) := by
      gcongr <;> (try exact hfrac) <;> (try norm_num [e1U]) <;> positivity
    _ < 241 / 10 := by norm_num [e1U]

-- 121/5 < exp (16/5)
theorem big32l : 121 / 5 < Real.exp (16 / 5) := by
  have h1 : Real.exp (16 / 5) = Real.exp 1 ^ 3 * Real.exp (1 / 5) := by
    rw [show (16 / 5 : ℝ) = 3 + 1 / 5 from by norm_num, Real.exp_add 3 (1 / 5), exp1pow_3]
  calc (121 / 5 : ℝ) < e1L ^ 3 * (122140 / 100000) := by norm_num [e1L]
    _ < e1L ^ 3 * Real.exp (1 / 5) := by
      gcongr <;> (try exact expfrac_1_5_l) <;> (try norm_num [e1L]) <;> positivity
    _ ≤ Real.exp 1 ^ 3 * Real.exp (1 / 5) := by
      gcongr <;> (try exact heL.le) <;> (try norm_num [e1L]) <;> positivity
    _ = Real.exp (16 / 5) := by rw [h1]

-- exp (57601/10000) < 320      [the log 320 floor pin for the kernel]
theorem big57601u : Real.exp (57601 / 10000) < 320 := by
  have h1 : Real.exp (57601 / 10000) = Real.exp 1 ^ 5 * Real.exp (7601 / 10000) := by
    rw [show (57601 / 10000 : ℝ) = 5 + 7601 / 10000 from by norm_num,
      Real.exp_add 5 (7601 / 10000), exp1pow_5]
  have hfrac : Real.exp (7601 / 10000) ≤
      (Finset.sum (Finset.range 22) fun m : ℕ => (7601 / 10000 : ℝ) ^ m / (m.factorial : ℝ)) +
        (7601 / 10000 : ℝ) ^ 22 * (((22 : ℕ) : ℝ) + 1) / (((22 : ℕ).factorial : ℝ) * ((22 : ℕ) : ℝ)) := by
    have hstep :=
      Real.exp_bound' (x := (7601 / 10000 : ℝ)) (n := 22) (by norm_num) (by norm_num) (by norm_num)
    exact hstep
  calc
    Real.exp (57601 / 10000) = Real.exp 1 ^ 5 * Real.exp (7601 / 10000) := h1
    _ ≤ e1U ^ 5 * Real.exp (7601 / 10000) := by
      gcongr <;> (try exact heU.le) <;> positivity
    _ ≤ e1U ^ 5 * ((Finset.sum (Finset.range 22) fun m : ℕ => (7601 / 10000 : ℝ) ^ m / (m.factorial : ℝ)) +
        (7601 / 10000 : ℝ) ^ 22 * (((22 : ℕ) : ℝ) + 1) / (((22 : ℕ).factorial : ℝ) * ((22 : ℕ) : ℝ))) := by
      gcongr <;> (try exact hfrac) <;> (try norm_num [e1U]) <;> positivity
    _ < 320 := by norm_num [e1U]

-- ------------------------------------------------------------
-- C.  the log(3e10) and loglog(3e10) pins
-- ------------------------------------------------------------

theorem logT_lo : 241 / 10 < Real.log G2_pin :=
  (Real.lt_log_iff_exp_lt (show (0 : ℝ) < G2_pin from by norm_num [G2_pin])).mpr big241u

theorem logT_hi : Real.log G2_pin < 121 / 5 :=
  (Real.log_lt_iff_lt_exp (show (0 : ℝ) < G2_pin from by norm_num [G2_pin])).mpr big242l

theorem loglog_lo : 318 / 100 < Real.log (Real.log G2_pin) := by
  calc
    (318 / 100 : ℝ) < Real.log (241 / 10) :=
      (Real.lt_log_iff_exp_lt (show (0 : ℝ) < 241 / 10 from by norm_num)).mpr big318u
    _ < Real.log (Real.log G2_pin) :=
      Real.log_lt_log (show (0 : ℝ) < 241 / 10 from by norm_num) logT_lo

theorem loglog_hi : Real.log (Real.log G2_pin) < 16 / 5 := by
  calc
    Real.log (Real.log G2_pin) < Real.log (121 / 5) :=
      Real.log_lt_log
        (show (0 : ℝ) < Real.log G2_pin from
          lt_of_lt_of_le (show (0 : ℝ) < 241 / 10 from by norm_num) (le_of_lt logT_lo))
        logT_hi
    _ < 16 / 5 :=
      (Real.log_lt_iff_lt_exp (show (0 : ℝ) < 121 / 5 from by norm_num)).mpr big32l

-- ------------------------------------------------------------
-- D.  the Milino-form K pin at the band frontier
-- ------------------------------------------------------------

theorem kmil_3e10_bounds : 612 / 100 ≤ K_mil G2_pin ∧ K_mil G2_pin < 615 / 100 := by
  dsimp only [K_mil]
  constructor
  · have ha : (111 / 1000 : ℝ) * (241 / 10) ≤ (111 / 1000 : ℝ) * Real.log G2_pin := by
      gcongr <;> (try exact le_of_lt logT_lo) <;> norm_num
    have hb : (275 / 1000 : ℝ) * (318 / 100) ≤ (275 / 1000 : ℝ) * Real.log (Real.log G2_pin) := by
      gcongr <;> (try exact le_of_lt loglog_lo) <;> norm_num
    have hc :
        (612 / 100 : ℝ) ≤
          (111 / 1000 : ℝ) * (241 / 10) + (275 / 1000 : ℝ) * (318 / 100) + (245 / 100 + 1 / 8) := by
      norm_num
    linarith
  · have ha : (111 / 1000 : ℝ) * Real.log G2_pin < (111 / 1000 : ℝ) * (121 / 5) := by
      gcongr <;> (try exact logT_hi) <;> norm_num
    have hb : (275 / 1000 : ℝ) * Real.log (Real.log G2_pin) < (275 / 1000 : ℝ) * (16 / 5) := by
      gcongr <;> (try exact loglog_hi) <;> norm_num
    have hc :
        (111 / 1000 : ℝ) * (121 / 5) + (275 / 1000 : ℝ) * (16 / 5) + (245 / 100 + 1 / 8) <
          615 / 100 := by
      norm_num
    linarith

-- ------------------------------------------------------------
-- E.  the left-pin kernel floor on the band
-- ------------------------------------------------------------

theorem pG1_pin_lower (t : ℝ) (htlo : (32 * 10 ^ 8 : ℝ) ≤ t) : pG1 t ≥ 1151 / 100 := by
  have htp0 : 0 < t := lt_of_lt_of_le (show (0 : ℝ) < 32 * 10 ^ 8 from by norm_num) htlo
  let u : ℝ := (1 * 10 ^ 14 : ℝ) / t ^ 2
  have htp2 : (32 * 10 ^ 8 : ℝ) ^ 2 ≤ t ^ 2 := by
    gcongr <;> (try assumption)
  have sut : u ≤ 1 / 102400 := by
    calc
      u = (1 * 10 ^ 14 : ℝ) / t ^ 2 := rfl
      _ ≤ (1 * 10 ^ 14 : ℝ) / (32 * 10 ^ 8) ^ 2 :=
        (div_le_div_iff_of_pos_left (show (0 : ℝ) < 1 * 10 ^ 14 from by norm_num)
          (show (0 : ℝ) < t ^ 2 from by nlinarith [htp0])
          (show (0 : ℝ) < (32 * 10 ^ 8) ^ 2 from by norm_num)).mpr htp2
      _ = 1 / 102400 := by norm_num
  have hut : u < 1 := lt_of_le_of_lt sut (show (1 / 102400 : ℝ) < 1 from by norm_num)
  have h1u : 0 < 1 - u := sub_pos.mpr hut

  -- log(1/(1-u)) <= 1/(1-u) - 1  =  u/(1-u)   and   log((1-u)⁻¹) = -log(1-u)
  have hpos : 0 < 1 / (1 - u) := by positivity
  have hinv := Real.log_le_sub_one_of_pos hpos
  have heq : (1 / (1 - u)) - 1 = u / (1 - u) := by
    field_simp [show 1 - u ≠ 0 from ne_of_gt h1u]
    ring
  have hle : Real.log (1 / (1 - u)) ≤ u / (1 - u) := by
    rw [heq] at hinv
    exact hinv
  have hlog1u : Real.log (1 / (1 - u)) = -Real.log (1 - u) := by
    have h2 : (1 - u) ⁻¹ = 1 / (1 - u) := by
      field_simp [show 1 - u ≠ 0 from ne_of_gt h1u]
    rw [← h2, Real.log_inv (1 - u)]
  have hlog1u_lo : Real.log (1 - u) ≥ -(u / (1 - u)) := by
    have hle' : -Real.log (1 - u) ≤ u / (1 - u) := by
      rw [hlog1u] at hle
      exact hle
    linarith [hle']

  -- u/(1-u) <= 1/102399   (exact:  102400·u <= 1  is sut)
  have hrecip : 1 / (1 - u) ≤ (102400 : ℝ) / 102399 := by
    have hq : (102400 : ℝ) / 102399 = 1 / (102399 / 102400) := by norm_num
    rw [hq, one_div_le_one_div h1u (show (0 : ℝ) < 102399 / 102400 from by norm_num)]
    nlinarith [sut]
  have hmono : u / (1 - u) ≤ 1 / 102399 := by
    calc
      u / (1 - u) = u * (1 / (1 - u)) := by
        field_simp [show 1 - u ≠ 0 from ne_of_gt h1u]
      _ ≤ (1 / 102400) * (1 / (1 - u)) := by
        gcongr <;> (try exact sut)
      _ ≤ (1 / 102400) * (102400 / 102399) := by
        gcongr <;> (try exact hrecip)
      _ = 1 / 102399 := by norm_num
  have hlog1u2 : Real.log (1 - u) ≥ -1 / 102399 := by
    have hneg : -(1 / 102399 : ℝ) ≤ -(u / (1 - u)) := by linarith
    linarith [hlog1u_lo, hneg]

  -- the log of vanishing-Maslov-factor form
  have hfact : t ^ 2 - 1 * 10 ^ 14 = t ^ 2 * (1 - u) := by
    subst u
    field_simp [show t ^ 2 ≠ 0 from pow_ne_zero 2 (ne_of_gt htp0)]
  have hlogmain : Real.log (t ^ 2 - 1 * 10 ^ 14) = 2 * Real.log t + Real.log (1 - u) := by
    rw [hfact, Real.log_mul (show t ^ 2 ≠ 0 from pow_ne_zero 2 (ne_of_gt htp0)) (show 1 - u ≠ 0 from ne_of_gt h1u)]
    rw [show Real.log (t ^ 2) = 2 * Real.log t from by
      have := Real.log_pow t 2
      rw [this]
      ring]
  have hpform :
      pG1 t = 2 * Real.log t + Real.log (1 - u) - Real.log (1 * 10 ^ 14 + 1 / 4) +
        (1 / 2) / (1 * 10 ^ 14 + 1 / 4) := by
    dsimp only [pG1]
    rw [hlogmain]

  -- the G1-pin constant term:  log(10^14 + 1/4) = log(10^14) + log(1 + 1/(4·10^14))
  have hfar : Real.log (1 * 10 ^ 14 + 1 / 4) = Real.log (10 ^ 14) + Real.log (1 + 1 / (4 * 10 ^ 14)) := by
    calc
      Real.log (1 * 10 ^ 14 + 1 / 4) = Real.log (10 ^ 14 * (1 + 1 / (4 * 10 ^ 14))) := by
        rw [show (1 * 10 ^ 14 : ℝ) + 1 / 4 = 10 ^ 14 * (1 + 1 / (4 * 10 ^ 14)) from by ring]
      _ = Real.log (10 ^ 14) + Real.log (1 + 1 / (4 * 10 ^ 14)) :=
        Real.log_mul (show (10 ^ 14 : ℝ) ≠ 0 from by norm_num)
          (show (1 + 1 / (4 * 10 ^ 14) : ℝ) ≠ 0 from by norm_num)
  have hfarub : Real.log (1 + 1 / (4 * 10 ^ 14)) ≤ 1 / (4 * 10 ^ 14) := by
    have hposf : (0 : ℝ) < 1 + 1 / (4 * 10 ^ 14) := by norm_num
    calc
      Real.log (1 + 1 / (4 * 10 ^ 14)) ≤ (1 + 1 / (4 * 10 ^ 14)) - 1 :=
        Real.log_le_sub_one_of_pos hposf
      _ = 1 / (4 * 10 ^ 14) := by ring

  calc
    pG1 t =
        2 * Real.log t + Real.log (1 - u) - Real.log (1 * 10 ^ 14 + 1 / 4) +
          (1 / 2) / (1 * 10 ^ 14 + 1 / 4) := hpform
    _ ≥ 2 * Real.log (32 * 10 ^ 8) - 1 / 102399 - Real.log (1 * 10 ^ 14 + 1 / 4) := by
      have h2lt : 2 * Real.log (32 * 10 ^ 8) ≤ 2 * Real.log t := by
        have hlm : Real.log (32 * 10 ^ 8) ≤ Real.log t :=
          (Real.log_le_log_iff (show (0 : ℝ) < 32 * 10 ^ 8 from by norm_num)
            (show (0 : ℝ) < t from htp0)).mpr htlo
        exact mul_le_mul_of_nonneg_left hlm (show (0 : ℝ) ≤ 2 from by norm_num)
      have hposc : (0 : ℝ) ≤ (1 / 2) / (1 * 10 ^ 14 + 1 / 4) := by positivity
      have hstep1 : -(1 / 102399 : ℝ) ≤ Real.log (1 - u) :=
        le_of_eq_of_le (show (-1 / 102399 : ℝ) = -(1 / 102399 : ℝ) from by norm_num).symm hlog1u2
      have hA : 2 * Real.log (32 * 10 ^ 8) + -(1 / 102399 : ℝ) ≤
          2 * Real.log t + Real.log (1 - u) :=
        add_le_add h2lt hstep1
      have hB : 2 * Real.log (32 * 10 ^ 8) - 1 / 102399 - Real.log (1 * 10 ^ 14 + 1 / 4) ≤
          2 * Real.log t + Real.log (1 - u) - Real.log (1 * 10 ^ 14 + 1 / 4) :=
        add_le_add hA (le_refl (-Real.log (1 * 10 ^ 14 + 1 / 4)))
      have hcst : 2 * Real.log t + Real.log (1 - u) - Real.log (1 * 10 ^ 14 + 1 / 4) ≤
          2 * Real.log t + Real.log (1 - u) - Real.log (1 * 10 ^ 14 + 1 / 4) +
            (1 / 2) / (1 * 10 ^ 14 + 1 / 4) := by
        exact le_add_of_nonneg_right hposc
      exact le_trans hB hcst
    _ ≥ 2 * Real.log 320 - 1 / 102399 - 1 / (4 * 10 ^ 14) := by
      have ha : 2 * Real.log (32 * 10 ^ 8) = 2 * (Real.log 32 + Real.log (10 ^ 8)) := by
        rw [Real.log_mul (show (32 : ℝ) ≠ 0 from by norm_num) (show (10 ^ 8 : ℝ) ≠ 0 from by norm_num)]
      calc
        2 * Real.log (32 * 10 ^ 8) - 1 / 102399 - Real.log (1 * 10 ^ 14 + 1 / 4) =
            2 * (Real.log 32 + Real.log (10 ^ 8)) - 1 / 102399 -
              (Real.log (10 ^ 14) + Real.log (1 + 1 / (4 * 10 ^ 14))) := by
          rw [ha, hfar]
        _ = 2 * Real.log 32 + 16 * Real.log 10 - 1 / 102399 - Real.log (10 ^ 14) -
              Real.log (1 + 1 / (4 * 10 ^ 14)) := by
          have h108 : Real.log (10 ^ 8) = 8 * Real.log 10 := by
            rw [Real.log_pow (10 : ℝ) 8]
            ring
          rw [h108]
          ring
        _ ≥ 2 * Real.log 32 + 16 * Real.log 10 - 1 / 102399 - Real.log (10 ^ 14) -
              1 / (4 * 10 ^ 14) := by
          nlinarith [hfarub]
        _ = 2 * Real.log 320 - 1 / 102399 - 1 / (4 * 10 ^ 14) := by
          rw [show Real.log 320 = Real.log 32 + Real.log 10 from by
            rw [show (320 : ℝ) = 32 * 10 from by norm_num,
              Real.log_mul (show (32 : ℝ) ≠ 0 from by norm_num) (show (10 : ℝ) ≠ 0 from by norm_num)],
            show Real.log (10 ^ 14 : ℝ) = 14 * Real.log 10 from by
              have := Real.log_pow (10 : ℝ) 14
              rw [this]
              ring]
          ring
    _ ≥ 2 * (57601 / 10000 : ℝ) - 1 / 102399 - 1 / (4 * 10 ^ 14) := by
      have hpin : 57601 / 10000 ≤ Real.log 320 := by
        have :=
          (Real.lt_log_iff_exp_lt (show (0 : ℝ) < 320 from by norm_num)).mpr big57601u
        exact le_of_lt this
      have h2p : 2 * (57601 / 10000 : ℝ) ≤ 2 * Real.log 320 :=
        mul_le_mul_of_nonneg_left hpin (show (0 : ℝ) ≤ 2 from by norm_num)
      linarith [h2p]
    _ ≥ 1151 / 100 := by norm_num

-- ------------------------------------------------------------
-- F.  the refutation at the pin
-- ------------------------------------------------------------

theorem milino_channel_ge_70 (t : ℝ) (htlo : (32 * 10 ^ 8 : ℝ) ≤ t) :
    K_mil G2_pin * abs (pG1 t) ≥ 70 := by
  have hp : pG1 t ≥ 1151 / 100 := pG1_pin_lower t htlo
  have hpos : 0 < pG1 t := lt_of_lt_of_le (show (0 : ℝ) < 1151 / 100 from by norm_num) hp
  have habs : abs (pG1 t) = pG1 t := abs_of_pos hpos
  have hK : 612 / 100 ≤ K_mil G2_pin := (kmil_3e10_bounds).1
  calc
    K_mil G2_pin * abs (pG1 t) = K_mil G2_pin * pG1 t := by rw [habs]
    _ ≥ (612 / 100) * pG1 t :=
      mul_le_mul_of_nonneg_right hK (le_of_lt hpos)
    _ ≥ (612 / 100) * (1151 / 100) :=
      mul_le_mul_of_nonneg_left hp (show (0 : ℝ) ≤ 612 / 100 from by norm_num)
    _ ≥ 70 := by norm_num

-- The wire feed at the pin is dev_feed = 1 - 13/t <= 1; the cited-
-- bounded channel exceeds it (>= 70) for every band height:
theorem refutation_3e10 (t : ℝ) (htlo : (32 * 10 ^ 8 : ℝ) ≤ t) :
    1 - 13 / t < K_mil G2_pin * abs (pG1 t) := by
  have hfeed : 1 - 13 / t < 1 := by
    have hposf : 0 < 13 / t := by positivity
    linarith [hposf]
  have hbig : (1 : ℝ) ≤ K_mil G2_pin * abs (pG1 t) := by
    have h70 : K_mil G2_pin * abs (pG1 t) ≥ 70 := milino_channel_ge_70 t htlo
    linarith [h70, show (1 : ℝ) ≤ 70 from by norm_num]
  linarith [hfeed, hbig]

-- ------------------------------------------------------------
-- G.  the e4_tailFloor wire instantied with K := K_mil(3e10)
-- ------------------------------------------------------------

-- W2-BEYOND section 7(c):  the e4_tailFloor wire statement,
-- instantiated with K := K_mil(G2_pin) under the CITED Milino
-- hypothesis |DN gamma| <= K at every partition point:  the
-- data-free absolute-sum branch is priced at exactly
-- K * (|p G1| + |p G2| + TV) — and F proves K * |p G1| alone
-- already exceeds the feed by two-plus orders of magnitude.
theorem m6_floor (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ)
    (hD0 : abs (W2T.DN N0 Nas 0) ≤ K_mil G2_pin)
    (hDM : abs (W2T.DN N0 Nas M) ≤ K_mil G2_pin)
    (hD : ∀ j ∈ Finset.range M, abs (W2T.DN N0 Nas j) ≤ K_mil G2_pin) :
    W2T.S1Sum M p - W2T.RSum M p Nas ≥
      -(K_mil G2_pin * (abs (p 0) + abs (p M)) +
          K_mil G2_pin * (∑ j ∈ Finset.range M, abs (W2T.DP p j))) :=
  W2B.e4_tailFloor M p N0 Nas (K_mil G2_pin) hD0 hDM hD

end W2M6
