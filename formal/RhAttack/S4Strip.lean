/-
S4Strip.lean — 25af: the (i-b) t^4-strip-composition residual, closed in Lean.

Stage map (25af port of the 25ab/S4Growth architecture):
  S1 (§2): Xwire component bounds on the t^4 family + hX4 (X4fun <= X4UBfun)
           + hXp2 (exp (X4fun t) <= 2).
  S2 (§3): p8_B(t, n4 t) <= A1 t^-2 + A2 t^-5 + A3 t^-7   (W term).
  S3 (§4): mown floor: mown(t, d) >= F4 * t^-2 for d >= 1/200.
  S4 (§5): M-term: M e^{X4} X4 <= MTUBfun t; final squeeze s4_strip_close.

Numerical source of truth (dps-50 directional certification, all PASS):
  scripts/rh/day028_25af_constants.py / out_day028_25af_constants.txt
  (25af survey: scripts/rh/day027_25af_owncompo_survey.py, verdict (A)).

Theorem (bound level, free M):
  t >= 1000, 1/200 <= d <= 1/2, 0 <= M <= S4W.Zbound t:
    p8_B t (n4 t) + M * exp (X4fun t) * X4fun t < S4O.mown t d
-/

import Mathlib
import RhAttack.B3Core
import RhAttack.P8Floor
import RhAttack.S4Window
import RhAttack.S4Own
import RhAttack.S4Gap
import RhAttack.S4Growth

namespace S4Strip
open Real

/- =================================================================
   §0  family and UB functions (25af constants, directional)
   ================================================================= -/

/-- 25af growing wire: n4(t) = ceil(3.1e7 t^4). -/
noncomputable def n4 (t : ℝ) : ℕ := ⌈(31000000 : ℝ) * t ^ 4⌉₊

/-- 25af t^4 detector strip edges: G4 = 6.2e7 t^4, B4 = 1.24e8 t^4 = 2 G4. -/
def G4 (t : ℝ) : ℝ := 62000000 * t ^ 4
def B4 (t : ℝ) : ℝ := 124000000 * t ^ 4

/-- The Xwire on the strip (exact B3Core model: Bf, Sbar, Cf, Kbar). -/
noncomputable def X4fun (t : ℝ) : ℝ :=
    Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t)

/-- Bf(t, G4 t) <= Bf4UB t (S1). -/
noncomputable def Bf4UB (t : ℝ) : ℝ :=
    (2 + 1 / t + 1 / (t * t)) * (1 / (t ^ 6)) / (62000000 * 62000000)

/-- Sbar(B4 t) + Sbar(G4 t) <= SsumUB t (S1). -/
noncomputable def SsumUB (t : ℝ) : ℝ := 20 + 4 * Real.log t

/-- Cf(t, G4 t) <= Cf4UB t (S1). -/
def Cf4UB (t : ℝ) : ℝ := 4 * t * t + 2

/-- |Kbar(G4 t)| <= Kbar4UB t (S1). -/
noncomputable def Kbar4UB (t : ℝ) : ℝ :=
    (10 + 2 * Real.log t) / (2 * 62000000 * 62000000 * t ^ 8)

/-- X4(t) <= X4UBfun t for t >= 1000 (S1; the chain). -/
noncomputable def X4UBfun (t : ℝ) : ℝ := (16 / 10 ^ 15 + 35 / 10 ^ 16 * Real.log t) / t ^ 6

/-- M e^{X4} X4 <= MTUBfun t for M <= Zbound t (S4). -/
noncomputable def MTUBfun (t : ℝ) : ℝ := 25 / 10 ^ 15 / t ^ (19 / 4 : ℝ)

/-- The d-edge floor: mown(t, d) >= F4 * t^-2 for t >= 1000, d >= 1/200. -/
noncomputable def F4 : ℝ := (10 : ℝ) ^ 8 / (10 ^ 6 + 1) ^ 2

noncomputable def A1 : ℝ := 8981 / 10 ^ 8
noncomputable def A2 : ℝ := 5 / 10 ^ 13
noncomputable def A3 : ℝ := 1 / 10 ^ 20

/-
   Exact anchors (dps-50 script day028_25af_constants.py, sections [0]/[3], integers):
   8981^2 * 4 * 31000000 = 10001636764000000 > 10^16              (A1 strict)
   2001*10^13 = 20010000000000000 <= 120000*31000000*5567 (A2)
   17321^2 = 300017041 >= 3*10^8                           (sqrt 3 upper)
   5567^2 = 30991489 <= 31000000                           (sqrt N4 lower)
   17321*1003^3*10^20 <= 540*10^4*1000^3*31000000^2*5567   (A3)
-/

/- =================================================================
   §1  side conditions and elementary helpers
   (Honest 4.33.1 quirk: `variable` blocks are INVISIBLE to later
    declarations once a second variable references the first -- use
    explicit binders, the 25ab house style.)
   ================================================================= -/

/-- Strip domain: t >= 1000. -/
lemma st_tpos (t : ℝ) (ht : 1000 ≤ t) : 0 < t := by linarith

/-- 27/10 < e, via the norm_num-certified real e > 2.7182818283. -/
lemma st_e6 : (27 : ℝ) / 10 < Real.exp 1 := by linarith [Real.exp_one_gt_d9]

/-- 6 < ln 1000:  6 = 6·1 < 6·ln 3 < 3·ln 9 < 3·ln 10 = ln 1000,
    where 1 < ln 3 since exp 1 < 3. -/
lemma st_hex : (6 : ℝ) < Real.log 1000 := by
  have h13 : (1 : ℝ) < Real.log 3 := by
    rw [← Real.log_exp 1]
    exact Real.log_lt_log (Real.exp_pos 1) Real.exp_one_lt_three
  calc (6 : ℝ) = 6 * 1 := by norm_num
    _ < 6 * Real.log 3 := mul_lt_mul_of_pos_left h13 (by norm_num)
    _ = 3 * Real.log 9 := by
      rw [show (9 : ℝ) = 3 ^ 2 by norm_num, Real.log_pow 3 2]
      ring
    _ < 3 * Real.log 10 :=
      mul_lt_mul_of_pos_left (Real.log_lt_log (by norm_num) (by norm_num)) (by norm_num)
    _ = Real.log 1000 := by
      rw [show (1000 : ℝ) = (10 : ℝ) ^ 3 from by norm_num, Real.log_pow 10 3]
      ring

/-- ln 1000 < 7 (i.e. 1000 < e^7). -/
lemma st_ln7 : Real.log 1000 < 7 := by
  have hA : (1000 : ℝ) < Real.exp 7 := by
    calc (1000 : ℝ) < (27 / 10 : ℝ) ^ 7 := by norm_num
      _ < (Real.exp 1) ^ 7 := pow_lt_pow_left₀ st_e6 (by norm_num) (by norm_num : (7 : ℕ) ≠ 0)
      _ = Real.exp 7 := exp_one_pow 7
  rw [← Real.log_exp 7]
  exact Real.log_lt_log (by norm_num) hA

/-- 6 < ln t for t >= 1000 (ln 1000 > 6, ln monotone). -/
lemma st_L6 (t : ℝ) (ht : 1000 ≤ t) : (6 : ℝ) < Real.log t :=
  lt_of_lt_of_le st_hex (Real.log_le_log (by norm_num) ht)

/-- ln 124 < 5 and ln 62 < 5 ((27/10)^5 = 143.489... > 124). -/
lemma st_ln124 : Real.log 124 < 5 := by
  have hA : (124 : ℝ) < Real.exp 5 := by
    calc (124 : ℝ) < (27 / 10 : ℝ) ^ 5 := by norm_num
      _ < (Real.exp 1) ^ 5 := pow_lt_pow_left₀ st_e6 (by norm_num) (by norm_num : (5 : ℕ) ≠ 0)
      _ = Real.exp 5 := exp_one_pow 5
  rw [← Real.log_exp 5]
  exact Real.log_lt_log (by norm_num) hA

lemma st_ln62 : Real.log 62 < 5 := by
  have hA : (62 : ℝ) < Real.exp 5 := by
    calc (62 : ℝ) < (27 / 10 : ℝ) ^ 5 := by norm_num
      _ < (Real.exp 1) ^ 5 := pow_lt_pow_left₀ st_e6 (by norm_num) (by norm_num : (5 : ℕ) ≠ 0)
      _ = Real.exp 5 := exp_one_pow 5
  rw [← Real.log_exp 5]
  exact Real.log_lt_log (by norm_num) hA


/-- 2 ln s <= s for all s > 0. -/
lemma st_h2logS_le_S (s : ℝ) (hs : 0 < s) : 2 * Real.log s ≤ s := by
  rcases lt_or_ge s 1 with h1 | h1'
  · have hneg : Real.log s < 0 := Real.log_neg hs h1
    nlinarith
  ·
      have hr : 2 * Real.log (Real.sqrt s) = Real.log s := by
        rw [Real.log_sqrt (le_of_lt hs)]
        ring
      have hsb1 : (1 : ℝ) ≤ Real.sqrt s := by
        simpa using Real.sqrt_le_sqrt h1'
      have hbnd : 4 * Real.log (Real.sqrt s) ≤ 4 * (Real.sqrt s - 1) := by
        nlinarith [Real.log_le_sub_one_of_pos (Real.sqrt_pos.2 hs), hsb1]
      have hsq : 4 * (Real.sqrt s - 1) ≤ s := by
        have hu2 : (Real.sqrt s) ^ 2 = s := Real.sq_sqrt (le_of_lt hs)
        have hsqn : 0 ≤ (Real.sqrt s - 2) ^ 2 := sq_nonneg (Real.sqrt s - 2)
        nlinarith [hu2, hsqn]
      nlinarith [hr, hbnd, hsq]

/-- (ln t)^2 <= t for t >= 1000 (elementary: ln t = 2 ln (sqrt t) <= sqrt t,
    hence (ln t)^2 <= ln t * sqrt t <= sqrt t * sqrt t = t). -/
lemma st_L2le_t (t : ℝ) (ht : 1000 ≤ t) : (Real.log t) ^ 2 ≤ t := by
  have ht0 : 0 < t := by linarith
  have hL0 : 0 ≤ Real.log t := le_of_lt (Real.log_pos (by linarith))
  have hLle : Real.log t ≤ Real.sqrt t := by
    have hr : 2 * Real.log (Real.sqrt t) = Real.log t := by
      rw [Real.log_sqrt (le_of_lt ht0)]
      ring
    have hh : 2 * Real.log (Real.sqrt t) ≤ Real.sqrt t :=
      st_h2logS_le_S (Real.sqrt t) (Real.sqrt_pos.2 ht0)
    simpa [hr] using hh
  have hsq : (Real.log t) ^ 2 ≤ Real.log t * Real.sqrt t := by
    simpa [pow_two] using mul_le_mul_of_nonneg_left hLle hL0
  have hsq2 : Real.log t * Real.sqrt t ≤ Real.sqrt t * Real.sqrt t :=
    mul_le_mul_of_nonneg_right hLle (Real.sqrt_nonneg t)
  have hrt : Real.sqrt t * Real.sqrt t = t := by
    simpa [pow_two] using Real.sq_sqrt (le_of_lt ht0)
  simpa [hrt] using le_trans hsq hsq2

/-- 160/27 <= ln t for t >= 1000 (160/27 < 6 < ln t) -- the M-chain switch. -/
lemma st_L16027 (t : ℝ) (ht : 1000 ≤ t) : (160 : ℝ) / 27 ≤ Real.log t := by
  have h6 : (160 : ℝ) / 27 < 6 := by norm_num
  have hL6 : (6 : ℝ) < Real.log t := st_L6 t ht
  exact le_of_lt (lt_trans h6 hL6)


/- =================================================================
   §2 (S1)  Xwire component bounds on the t^4 family + hX4 + exp bound
   ================================================================= -/

/-- The square of the strip scale c4 = 62000000. -/
def c4sq : ℝ := 62000000 * 62000000

/-- 0 < c4sq. -/
lemma st_c4sq_pos : 0 < c4sq := by norm_num [c4sq]

/-- For a >= 0 and 0 < d2 <= d1: a / d1 <= a / d2 (division decreasing in the denominator). -/
lemma st_divdecr (a d1 d2 : ℝ) (ha : 0 ≤ a) (hd1 : 0 < d1) (hd2 : 0 < d2) (hdd : d2 ≤ d1) :
    a / d1 ≤ a / d2 := by
  rw [div_eq_mul_inv, div_eq_mul_inv]
  apply mul_le_mul_of_nonneg_left
  · rw [inv_le_inv₀ hd1 hd2]
    exact hdd
  · exact ha

/-- G4 t >= c4 * 1000^4 for t >= 1000. -/
lemma st_G4ge (t : ℝ) (ht : 1000 ≤ t) : (62000000 : ℝ) * 1000 ^ 4 ≤ G4 t := by
  rw [G4]
  exact mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 4) (by norm_num)

/-- (G4 t)^2 = c4sq * t^8 (exact). -/
lemma st_G4sq (t : ℝ) : G4 t * G4 t = c4sq * t ^ 8 := by
  rw [G4, c4sq]
  ring

/-- 0 < G4 t for t >= 1000. -/
lemma st_G4pos (t : ℝ) (ht : 1000 ≤ t) : 0 < G4 t := by
  rw [G4]
  apply mul_pos (by norm_num)
  exact pow_pos (by linarith) 4

/-- zmax < 1/2 (exact rational). -/
lemma st_zmax_half : (4000001 / 4000000) / (c4sq * 1000 ^ 6) < 1 / 2 := by
  norm_num [c4sq]

/-- 0 < 2 * (G4 t)^2 + 1/2 denominator. -/
lemma st_hpos1 (t : ℝ) (ht : 1000 ≤ t) : 0 < 2 * (G4 t * G4 t + 1 / 4) := by
  nlinarith [st_G4pos t ht]

/-- 0 < c4sq * t ^ 6. -/
lemma st_ct6 (t : ℝ) (ht : 1000 ≤ t) : 0 < c4sq * t ^ 6 := by
  apply mul_pos
  · norm_num [c4sq]
  · exact pow_pos (by linarith) 6

/-- 0 < c4sq * t ^ 8. -/
lemma st_ct8 (t : ℝ) (ht : 1000 ≤ t) : 0 < c4sq * t ^ 8 := by
  apply mul_pos
  · norm_num [c4sq]
  · exact pow_pos (by linarith) 8

/-- c4sq * 1000 ^ 6 <= c4sq * t ^ 6. -/
lemma st_c10006 (t : ℝ) (ht : 1000 ≤ t) : c4sq * 1000 ^ 6 ≤ c4sq * t ^ 6 :=
  mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6)
    (by norm_num [c4sq])

/-- 0 <= c4sq * t ^ 6. -/
lemma st_ct6_nonneg (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ c4sq * t ^ 6 := (st_ct6 t ht).le

/-- Pointwise z-bound: z(t) <= (4000001/4000000)/(c4sq * t^6) for t >= 1000. -/
lemma st_zmax_t (t : ℝ) (ht : 1000 ≤ t) :
    w t / (G4 t * G4 t + 1 / 4) ≤ (4000001 / 4000000) / (c4sq * t ^ 6) := by
  have hG2 : 0 < G4 t * G4 t := by
    have hpos : 0 < G4 t := by
      rw [G4]
      apply mul_pos (by norm_num)
      exact pow_pos (by linarith) 4
    nlinarith
  have hstep1 : w t / (G4 t * G4 t + 1 / 4) ≤ w t / (G4 t * G4 t) :=
    st_divdecr _ _ _ (by dsimp [w]; nlinarith)
      (by nlinarith [st_G4pos t ht]) (by nlinarith [st_G4pos t ht]) (by nlinarith [st_G4pos t ht])
  have hstep2 : w t / (G4 t * G4 t) = (1 + 1 / (4 * t * t)) / (c4sq * t ^ 6) := by
    rw [st_G4sq, w]
    field_simp [st_c4sq_pos.ne', show (0 : ℝ) < t from by linarith]
  have hstep3 : (1 + 1 / (4 * t * t)) / (c4sq * t ^ 6) ≤ (4000001 / 4000000) / (c4sq * t ^ 6) :=
    (div_le_div_of_nonneg_right (by
      have hinv : 1 / (4 * t * t) ≤ 1 / 4000000 := by
        have h6b : 4000000 ≤ 4 * t * t := by nlinarith
        rw [one_div, one_div, inv_le_inv₀ (by positivity) (by norm_num : 0 < (4000000 : ℝ))]
        exact h6b
      linarith) (st_ct6_nonneg t ht))
  calc w t / (G4 t * G4 t + 1 / 4) ≤ w t / (G4 t * G4 t) := hstep1
    _ = (1 + 1 / (4 * t * t)) / (c4sq * t ^ 6) := hstep2
    _ ≤ (4000001 / 4000000) / (c4sq * t ^ 6) := hstep3

/-- z(t) < 1/2 for t >= 1000. -/
lemma st_zhalf (t : ℝ) (ht : 1000 ≤ t) : w t / (G4 t * G4 t + 1 / 4) < 1 / 2 := by
  have hz : w t / (G4 t * G4 t + 1 / 4) ≤ (4000001 / 4000000) / (c4sq * t ^ 6) :=
    st_zmax_t t ht
  have hshr : (4000001 / 4000000) / (c4sq * t ^ 6) ≤ (4000001 / 4000000) / (c4sq * 1000 ^ 6) :=
    st_divdecr _ _ _ (by norm_num : (0 : ℝ) ≤ 4000001 / 4000000)
      (st_ct6 t ht) (by norm_num [c4sq]) (st_c10006 t ht)
  exact lt_of_le_of_lt (le_trans hz hshr) st_zmax_half

/-- Bf(t, G4 t) <= Bf4UB t (component (B4)). -/
lemma st_hBf4 (t : ℝ) (ht : 1000 ≤ t) : Bf t (G4 t) ≤ Bf4UB t := by
  dsimp only [Bf, Bf4UB]
  set z := w t / (G4 t * G4 t + 1 / 4) with hz
  have hzhalf : z < 1 / 2 := by simpa [hz] using st_zhalf t ht
  have hz1 : 0 < 1 - z := by linarith
  have hT1 : 1 / (2 * (G4 t * G4 t + 1 / 4)) ≤ 1 / (t * t) / (c4sq * t ^ 6) := by
    have hu : 0 < G4 t * G4 t + 1 / 4 := by nlinarith [st_G4pos t ht]
    have hstep1 : 1 / (2 * (G4 t * G4 t + 1 / 4)) ≤ 1 / (G4 t * G4 t + 1 / 4) := by
      rw [div_le_iff₀ (st_hpos1 t ht)]
      field_simp
      norm_num
    have hstep2 : 1 / (G4 t * G4 t + 1 / 4) ≤ 1 / (c4sq * t ^ 8) := by
      rw [div_le_iff₀ hu]
      field_simp [st_c4sq_pos.ne', show (0 : ℝ) < t from by linarith]
      rw [le_div_iff₀ (by norm_num [c4sq])]
      nlinarith [show G4 t * G4 t = c4sq * t ^ 8 from st_G4sq t]
    calc 1 / (2 * (G4 t * G4 t + 1 / 4)) ≤ 1 / (G4 t * G4 t + 1 / 4) := hstep1
      _ ≤ 1 / (c4sq * t ^ 8) := hstep2
      _ = 1 / (t * t) / (c4sq * t ^ 6) := by field_simp [st_c4sq_pos.ne', show (0 : ℝ) < t from by linarith]
  have hT2 : z / (1 - z) ≤ (4000001 / 4000000) / (c4sq * t ^ 6) * (1 + 1 / 10 ^ 19) := by
    have hzpos : 0 ≤ z := by
      have hwnon : 0 ≤ w t := by dsimp [w]; nlinarith
      apply div_nonneg hwnon
      nlinarith [st_G4pos t ht]
    have hT2a : z / (1 - z) ≤ z * (1 + 2 * z) := by
      have h1z : 1 / (1 - z) ≤ 1 + 2 * z := by
        rw [div_le_iff₀ hz1]
        nlinarith
      calc z / (1 - z) = z * (1 / (1 - z)) := by ring
        _ ≤ z * (1 + 2 * z) := mul_le_mul_of_nonneg_left h1z hzpos
    have hzb : z ≤ (4000001 / 4000000) / (c4sq * t ^ 6) := by simpa [hz] using st_zmax_t t ht
    have h2z : 2 * z ≤ 1 / 10 ^ 19 := by
      calc 2 * z ≤ 2 * ((4000001 / 4000000) / (c4sq * t ^ 6)) :=
          mul_le_mul_of_nonneg_left hzb (by norm_num)
        _ = (4000001 / 4000000) * (2 / (c4sq * t ^ 6)) := by ring
        _ ≤ (4000001 / 4000000) * (2 / (c4sq * 1000 ^ 6)) := by
          have hstep : 2 / (c4sq * t ^ 6) ≤ 2 / (c4sq * 1000 ^ 6) :=
            st_divdecr _ _ _ (by norm_num)
              (st_ct6 t ht) (by norm_num [c4sq]) (st_c10006 t ht)
          exact mul_le_mul_of_nonneg_left hstep (by norm_num : (0 : ℝ) ≤ 4000001 / 4000000)
        _ ≤ 1 / 10 ^ 19 := by norm_num [c4sq]
    have hT2b : z * (1 + 2 * z) ≤ ((4000001 / 4000000) / (c4sq * t ^ 6)) * (1 + 2 * z) :=
      mul_le_mul_of_nonneg_right hzb (by linarith [hzpos] : 0 ≤ 1 + 2 * z)
    calc z / (1 - z) ≤ z * (1 + 2 * z) := hT2a
      _ ≤ ((4000001 / 4000000) / (c4sq * t ^ 6)) * (1 + 2 * z) := hT2b
      _ ≤ ((4000001 / 4000000) / (c4sq * t ^ 6)) * (1 + 1 / 10 ^ 19) :=
        mul_le_mul_of_nonneg_left (by nlinarith [h2z])
          (by
            apply div_nonneg
            · norm_num
            · exact st_ct6_nonneg t ht)
  have hT3 : t / (G4 t * G4 t + 1 / 4) ≤ (1 / t) / (c4sq * t ^ 6) := by
    have hpos : 0 < t := by linarith
    have hstep1 : t / (G4 t * G4 t + 1 / 4) ≤ t / (G4 t * G4 t) :=
      st_divdecr _ _ _ (by linarith : 0 ≤ t)
        (by nlinarith [st_G4pos t ht]) (by nlinarith [st_G4pos t ht]) (by nlinarith [st_G4pos t ht])
    have hstep2 : t / (G4 t * G4 t) = (1 / t) / (c4sq * t ^ 6) := by
      rw [st_G4sq]
      field_simp [st_c4sq_pos.ne', hpos]
    exact le_trans hstep1 (le_of_eq hstep2)
  have hBfE : Bf t (G4 t) = 1 / (2 * (G4 t * G4 t + 1 / 4)) + z / (1 - z) +
        t / (G4 t * G4 t + 1 / 4) := rfl
  have hstepE : (1 / (t * t) / (c4sq * t ^ 6)) +
          ((4000001 / 4000000) / (c4sq * t ^ 6) * (1 + 1 / 10 ^ 19)) + (1 / t) / (c4sq * t ^ 6) =
          (1 / (t * t) + (4000001 / 4000000) * (1 + 1 / 10 ^ 19) + 1 / t) * (1 / (c4sq * t ^ 6)) := by
    field_simp [(st_ct6 t ht).ne']
  calc Bf t (G4 t) = 1 / (2 * (G4 t * G4 t + 1 / 4)) + z / (1 - z) + t / (G4 t * G4 t + 1 / 4) :=
      hBfE
    _ ≤ 1 / (t * t) / (c4sq * t ^ 6) + z / (1 - z) + (1 / t) / (c4sq * t ^ 6) :=
      add_le_add (add_le_add hT1 le_rfl) hT3
    _ ≤ 1 / (t * t) / (c4sq * t ^ 6) +
          (4000001 / 4000000) / (c4sq * t ^ 6) * (1 + 1 / 10 ^ 19) + (1 / t) / (c4sq * t ^ 6) := by
      apply add_le_add
      · apply add_le_add
        · exact le_rfl
        · exact hT2
      · exact le_rfl
    _ = (1 / (t * t) + (4000001 / 4000000) * (1 + 1 / 10 ^ 19) + 1 / t) * (1 / (c4sq * t ^ 6)) := hstepE
    _ ≤ ((2 + 1 / t + 1 / (t * t)) * (1 / (c4sq * t ^ 6))) := by
      have hc : (4000001 / 4000000) * (1 + 1 / 10 ^ 19) ≤ 2 := by norm_num
      have hnum2 : 1 / (t * t) + (4000001 / 4000000) * (1 + 1 / 10 ^ 19) + 1 / t ≤
            2 + 1 / t + 1 / (t * t) := by nlinarith [hc]
      have hnn : 0 ≤ 1 / (c4sq * t ^ 6) := by
        apply div_nonneg
        · norm_num
        · exact st_ct6_nonneg t ht
      exact mul_le_mul_of_nonneg_right hnum2 hnn
    _ = (2 + 1 / t + 1 / (t * t)) / (t ^ 6 * c4sq) := by
      field_simp [(st_ct6 t ht).ne']
    _ = (2 + 1 / t + 1 / (t * t)) * (1 / (t ^ 6)) / (62000000 * 62000000) := by
      dsimp [c4sq]
      ring
    _ = Bf4UB t := by
      dsimp only [Bf4UB]


/- =================================================================
   §2b (S1)  remaining Xwire component bounds: log anchors, Ssum, Cf,
        Kbar, the X4 chain bound, and the exp bound.

   The single exp anchor (log 124000000 < 19) uses the dps-9 certified
   bound 2.7182818283 < e (Mathlib `Real.exp_one_gt_d9`):
     124000000 * 10^190 <= 27182818283^19   (exact integers, norm_num)
     =>  1.24e8 <= e_d9^19 < e^19  =>  log 124000000 < 19.
   All other log bounds follow by monotonicity + log_mul/log_pow.
   ================================================================= -/

/-- e_d9 := 27182818283/10^10 (the dps-9 certified lower bound for e). -/
noncomputable def e_d9 : ℝ := 27182818283 / 10 ^ 10

/-- 124000000 * (10^10)^19 <= 27182818283^19 (exact integer arithmetic). -/
lemma st_ed9_19 : (124000000 : ℝ) * (10 ^ 10 : ℝ) ^ 19 ≤ (27182818283 : ℝ) ^ 19 := by
  norm_num

/-- e_d9 < e. -/
lemma st_ed9_lt_e : e_d9 < Real.exp 1 := by
  rw [e_d9, show (27182818283 : ℝ) / 10 ^ 10 = (2.7182818283 : ℝ) from by norm_num]
  exact Real.exp_one_gt_d9


/-- log 124000000 < 19. -/
lemma st_logB_anchor : Real.log 124000000 < 19 := by
  have heq : (e_d9 : ℝ) ^ (19 : ℝ) = (27182818283 : ℝ) ^ (19 : ℝ) / (10 ^ 10 : ℝ) ^ (19 : ℝ) := by
    rw [show (e_d9 : ℝ) = (27182818283 : ℝ) / (10 ^ 10 : ℝ) from by rw [e_d9],
        Real.div_rpow (by norm_num : (0 : ℝ) ≤ 27182818283) (by norm_num : (0 : ℝ) ≤ 10 ^ 10)]
  have hA : (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ 19 := by
    have hA' : (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ (19 : ℝ) := by
      rw [heq]
      have hden : 0 < (10 ^ 10 : ℝ) ^ (19 : ℝ) :=
        Real.rpow_pos_of_pos (by norm_num : (0 : ℝ) < 10 ^ 10) 19
      rw [le_div_iff₀ hden]
      have hn : (10 ^ 10 : ℝ) ^ (19 : ℝ) = (10 ^ 10 : ℝ) ^ 19 := by norm_num
      rw [hn]
      nlinarith [st_ed9_19]
    have hnum : (e_d9 : ℝ) ^ 19 = (e_d9 : ℝ) ^ (19 : ℝ) := by norm_num
    calc (124000000 : ℝ) ≤ (e_d9 : ℝ) ^ (19 : ℝ) := hA'
      _ = (e_d9 : ℝ) ^ 19 := hnum.symm
  have hB : (e_d9 : ℝ) ^ 19 < Real.exp 19 := by
    calc (e_d9 : ℝ) ^ 19 < (Real.exp 1) ^ 19 :=
        pow_lt_pow_left₀ st_ed9_lt_e (by rw [e_d9]; norm_num : (0 : ℝ) ≤ e_d9) (by norm_num : (19 : ℕ) ≠ 0)
      _ = Real.exp 19 := exp_one_pow 19
  calc Real.log 124000000 ≤ Real.log ((e_d9 : ℝ) ^ 19) :=
      Real.log_le_log (by norm_num : (0 : ℝ) < 124000000) hA
    _ < Real.log (Real.exp 19) :=
      Real.log_lt_log (pow_pos (by rw [e_d9]; norm_num : (0 : ℝ) < e_d9) 19) hB
    _ = (19 : ℝ) := Real.log_exp 19

/-- log 62000000 < 19 (transitivity: 62000000 < 124000000). -/
lemma st_logG_anchor : Real.log 62000000 < 19 := by
  have hlt : Real.log 62000000 < Real.log 124000000 :=
    Real.log_lt_log (by norm_num : (0 : ℝ) < 62000000) (by norm_num)
  linarith [st_logB_anchor]

/-- 0 < log (B4 t) for t >= 1000. -/
lemma st_logB_pos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (B4 t) := by
  have hB4 : (1 : ℝ) < B4 t := by
    dsimp only [B4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 124000000 from by norm_num]
  exact Real.log_pos hB4

/-- log (B4 t) < 19 + 4 log t. -/
lemma st_B4log (t : ℝ) (ht : 1000 ≤ t) : Real.log (B4 t) < 19 + 4 * Real.log t := by
  have ht0 : 0 < t := st_tpos t ht
  have ht4 : 0 < t ^ 4 := pow_pos ht0 4
  have hL4 : Real.log (t ^ 4) = 4 * Real.log t := by
    rw [Real.log_pow t 4]
    ring
  calc Real.log (B4 t) = Real.log (124000000 * t ^ 4) := by dsimp only [B4]
    _ = Real.log 124000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0) ht4.ne'
    _ = Real.log 124000000 + 4 * Real.log t := by rw [hL4]
    _ < 19 + 4 * Real.log t := by linarith [st_logB_anchor]

/-- 0 < log (G4 t) for t >= 1000. -/
lemma st_logG_pos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (G4 t) := by
  have hG4 : (1 : ℝ) < G4 t := by
    dsimp only [G4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 62000000 from by norm_num]
  exact Real.log_pos hG4

/-- log (G4 t) < 19 + 4 log t. -/
lemma st_G4log (t : ℝ) (ht : 1000 ≤ t) : Real.log (G4 t) < 19 + 4 * Real.log t := by
  have ht0 : 0 < t := st_tpos t ht
  have ht4 : 0 < t ^ 4 := pow_pos ht0 4
  have hL4 : Real.log (t ^ 4) = 4 * Real.log t := by
    rw [Real.log_pow t 4]
    ring
  calc Real.log (G4 t) = Real.log (62000000 * t ^ 4) := by dsimp only [G4]
    _ = Real.log 62000000 + Real.log (t ^ 4) :=
        Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) ht4.ne'
    _ = Real.log 62000000 + 4 * Real.log t := by rw [hL4]
    _ < 19 + 4 * Real.log t := by linarith [st_logG_anchor]

/-- log (19 + 4L) <= 18 + 4L for L >= 0 (log x <= x - 1). -/
lemma st_log19L (L : ℝ) (hL0 : 0 ≤ L) : Real.log (19 + 4 * L) ≤ 18 + 4 * L := by
  have hpos : 0 < 19 + 4 * L := by nlinarith
  have hlm1 : Real.log (19 + 4 * L) ≤ (19 + 4 * L) - 1 :=
    Real.log_le_sub_one_of_pos hpos
  convert hlm1 using 1
  ring

/-- (S4) Sbar(B4 t) + Sbar(G4 t) <= 20 + 4 log t. -/
lemma st_hSsum (t : ℝ) (ht : 1000 ≤ t) : Sbar (B4 t) + Sbar (G4 t) ≤ SsumUB t := by
  set L := Real.log t with hL
  have hL0 : 0 ≤ L := by dsimp only [L]; exact Real.log_nonneg (by linarith : 1 ≤ t)
  have hlb1 : Real.log (B4 t) < 19 + 4 * L := by simpa [hL] using st_B4log t ht
  have hlg1 : Real.log (G4 t) < 19 + 4 * L := by simpa [hL] using st_G4log t ht
  have hlbpos : 0 < Real.log (B4 t) := by simpa [hL] using st_logB_pos t ht
  have hlgpos : 0 < Real.log (G4 t) := by simpa [hL] using st_logG_pos t ht
  have hllB : Real.log (Real.log (B4 t)) ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlbpos (le_of_lt hlb1)
  have hllG : Real.log (Real.log (G4 t)) ≤ Real.log (19 + 4 * L) :=
    Real.log_le_log hlgpos (le_of_lt hlg1)
  have hllub : Real.log (19 + 4 * L) ≤ 18 + 4 * L := st_log19L L hL0
  have hSb : Sbar (B4 t) + Sbar (G4 t) =
      (0.110 : ℝ) * (Real.log (B4 t) + Real.log (G4 t)) +
      (0.290 : ℝ) * (Real.log (Real.log (B4 t)) + Real.log (Real.log (G4 t))) + 4.58 := by
    unfold Sbar
    ring
  calc Sbar (B4 t) + Sbar (G4 t)
      = (0.110 : ℝ) * (Real.log (B4 t) + Real.log (G4 t)) + (0.290 : ℝ) * (Real.log (Real.log (B4 t)) + Real.log (Real.log (G4 t))) + 4.58 := hSb
    _ ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * Real.log (19 + 4 * L)) + 4.58 := by
      refine add_le_add (add_le_add ?_ ?_) ?_
      · nlinarith [le_of_lt hlb1, le_of_lt hlg1]
      · nlinarith [hllB, hllG]
      · norm_num
    _ ≤ (0.110 : ℝ) * (38 + 8 * L) + (0.290 : ℝ) * (2 * (18 + 4 * L)) + 4.58 := by
      nlinarith [hllub]
    _ = 19.2 + 3.2 * L := by ring
    _ ≤ 20 + 4 * L := by nlinarith [hL0]
    _ = SsumUB t := by
      unfold SsumUB
      rw [hL]

/-- 1/(1-e) <= 1+2e for 0 <= e <= 1/2. -/
lemma st_inv_eps (e : ℝ) (he0 : 0 ≤ e) (he : e ≤ 1 / 2) : 1 / (1 - e) ≤ 1 + 2 * e := by
  have hden : 0 < 1 - e := sub_pos_of_lt (by nlinarith : e < 1)
  have hm : 0 ≤ e * (1 - 2 * e) := mul_nonneg he0 (by nlinarith : 0 ≤ 1 - 2 * e)
  have hgoal : 1 ≤ (1 + 2 * e) * (1 - e) := by nlinarith [hm]
  rw [div_le_iff₀ hden]
  exact hgoal

/-- (C4) Cf(t, G4 t) <= 4 t^2 + 2. -/
lemma st_hCf4 (t : ℝ) (ht : 1000 ≤ t) : Cf t (G4 t) ≤ Cf4UB t := by
  have ht0 : 0 < t := st_tpos t ht
  have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
  have hgp : 0 < G4 t * G4 t - t * t := by
    rw [hG4sq]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
    have hc4t : 2 ≤ c4sq * t ^ 6 := by
      calc 2 ≤ c4sq * 1000 ^ 6 := hc4
        _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
    nlinarith [hc4t, pow_pos ht0 2]
  have hG2pos : 0 < G4 t * G4 t := by nlinarith [st_G4pos t ht]
  have heps : t * t / (G4 t * G4 t) ≤ 1 / 2 := by
    rw [hG4sq]
    rw [div_le_iff₀ (st_ct8 t ht)]
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hmid : (2 : ℝ) * t * t ≤ c4sq * 1000 ^ 6 * (t * t) := by
      have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
      have hstep1 : (2 : ℝ) * t * t = (t * t) * 2 := by ring
      have hstep2 : (t * t) * 2 ≤ (t * t) * (c4sq * 1000 ^ 6) := by
        apply mul_le_mul_of_nonneg_left hc4
        nlinarith [ht0.le]
      have hstep3 : (t * t) * (c4sq * 1000 ^ 6) = c4sq * 1000 ^ 6 * (t * t) := by ring
      calc (2 : ℝ) * t * t = (t * t) * 2 := hstep1
      _ ≤ (t * t) * (c4sq * 1000 ^ 6) := hstep2
      _ = c4sq * 1000 ^ 6 * (t * t) := hstep3
    have hstep : c4sq * 1000 ^ 6 * (t * t) ≤ c4sq * t ^ 6 * (t * t) := by
      apply mul_le_mul_of_nonneg_right
      · apply mul_le_mul_of_nonneg_left ht6
        exact st_c4sq_pos.le
      · nlinarith [ht0.le]
    have hcalc : 2 * t * t ≤ c4sq * t ^ 8 := by
      calc 2 * t * t ≤ c4sq * 1000 ^ 6 * (t * t) := hmid
        _ ≤ c4sq * t ^ 6 * (t * t) := hstep
        _ = c4sq * t ^ 8 := by ring
    nlinarith [hcalc]
  have herr : 1 - t * t / (G4 t * G4 t) = (G4 t * G4 t - t * t) / (G4 t * G4 t) := by
    have hG2ne : G4 t * G4 t ≠ 0 := hG2pos.ne'
    have h1 : (1 : ℝ) = (G4 t * G4 t) / (G4 t * G4 t) := by
      rw [div_self hG2ne]
    rw [h1]
    field_simp [hG2ne]
  have hright : 1 / (1 - t * t / (G4 t * G4 t)) = (G4 t * G4 t) / (G4 t * G4 t - t * t) := by
    rw [herr]
    field_simp [hG2pos.ne', hgp]
  have hw0 : 0 ≤ w t := by dsimp only [w]; nlinarith [ht0.le]
  have heps0 : 0 ≤ t * t / (G4 t * G4 t) :=
    div_nonneg (mul_nonneg ht0.le ht0.le) (le_of_lt hG2pos)
  have h4e : 4 * (t * t / (G4 t * G4 t)) * w t ≤ 2 * t * t := by
    have hhw : 4 * (t * t / (G4 t * G4 t)) * w t = 4 * (t * t + 1 / 4) / (c4sq * t ^ 6) := by
      rw [w, hG4sq]
      field_simp [pow_pos ht0 8, pow_pos ht0 6, st_c4sq_pos.ne']
    rw [hhw]
    rw [div_le_iff₀ (st_ct6 t ht)]
    have ht2' : (1 : ℝ) ≤ t * t := by
      have ht2 : t ≤ t * t := by nlinarith [ht0.le, ht]
      exact le_trans (by linarith [ht]) ht2
    have hinv : 1 / (t * t) ≤ 1 := (div_le_one₀ (mul_pos ht0 ht0)).2 ht2'
    have hct : (4 : ℝ) + 1 / (t * t) ≤ (2 * c4sq : ℝ) * 1000 ^ 6 := by
      have hc : (5 : ℝ) ≤ (2 * c4sq : ℝ) * 1000 ^ 6 := by norm_num [c4sq]
      nlinarith [hinv, hc]
    have hnum : 4 * t * t + 1 ≤ (2 * c4sq : ℝ) * t ^ 6 * (t * t) := by
      have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
      have hbig : (2 * c4sq : ℝ) * 1000 ^ 6 ≤ (2 * c4sq : ℝ) * t ^ 6 := by
        apply mul_le_mul_of_nonneg_left ht6
        nlinarith [st_c4sq_pos]
      have hstep1 : (4 : ℝ) * t * t + 1 = (t * t) * (4 + 1 / (t * t)) := by
        field_simp [(pow_pos ht0 2).ne']
      have hstep2 : (t * t) * (4 + 1 / (t * t)) ≤ (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) := by
        apply mul_le_mul_of_nonneg_left hct
        nlinarith [ht0.le]
      have hstep3 : (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) ≤ (t * t) * ((2 * c4sq : ℝ) * t ^ 6) := by
        apply mul_le_mul_of_nonneg_left hbig
        nlinarith [ht0.le]
      have hstep4 : (t * t) * ((2 * c4sq : ℝ) * t ^ 6) = (2 * c4sq : ℝ) * t ^ 8 := by ring
      calc (4 : ℝ) * t * t + 1 = (t * t) * (4 + 1 / (t * t)) := hstep1
      _ ≤ (t * t) * ((2 * c4sq : ℝ) * 1000 ^ 6) := hstep2
      _ ≤ (t * t) * ((2 * c4sq : ℝ) * t ^ 6) := hstep3
      _ = (2 * c4sq : ℝ) * t ^ 6 * (t * t) := by ring
    nlinarith [hnum]
  calc Cf t (G4 t)
      = 1 + 2 * w t * ((G4 t * G4 t) / (G4 t * G4 t - t * t)) := by
        dsimp only [Cf, w]
        field_simp [hG2pos.ne', hgp]
      _ = 1 + 2 * w t * (1 / (1 - t * t / (G4 t * G4 t))) := by
        rw [← hright]
      _ ≤ 1 + 2 * w t * (1 + 2 * (t * t / (G4 t * G4 t))) := by
        nlinarith [st_inv_eps (t * t / (G4 t * G4 t)) heps0 heps, hw0]
      _ = 1 + 2 * w t + 4 * (t * t / (G4 t * G4 t)) * w t := by ring
      _ ≤ 1 + 2 * w t + 2 * t * t := by nlinarith [h4e]
      _ = 1 + 2 * (t * t + 1 / 4) + 2 * t * t := by
        rw [show (w t : ℝ) = t * t + 1 / 4 from by dsimp only [w]]
      _ ≤ 4 * t * t + 2 := by nlinarith

/-- Kbar(G4 t) > 0 for t >= 1000. -/
lemma st_Kbarpos (t : ℝ) (ht : 1000 ≤ t) : 0 < Kbar (G4 t) := by
  have hg1 : (1 : ℝ) < G4 t := by
    dsimp only [G4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1) (by linarith : 1 ≤ t) 4
    nlinarith [ht4, show (1 : ℝ) ≤ 62000000 from by norm_num]
  have hlg : 0 < Real.log (G4 t) := Real.log_pos hg1
  have hlg1 : (1 : ℝ) < Real.log (G4 t) := by
    have ht0 : 0 < t := st_tpos t ht
    have heq : Real.log (G4 t) = Real.log 62000000 + 4 * Real.log t := by
      dsimp only [G4]
      rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) (pow_pos ht0 4).ne',
          Real.log_pow t 4]
      ring
    have hL : (6 : ℝ) < Real.log t := st_L6 t ht
    have hlp : 0 < Real.log 62000000 := Real.log_pos (by norm_num : (1 : ℝ) < 62000000)
    rw [heq]
    nlinarith [hL, hlp]
  have hllg : 0 < Real.log (Real.log (G4 t)) := Real.log_pos hlg1
  have hden : 0 < 2 * G4 t * G4 t := by
    apply mul_pos
    · nlinarith [hg1]
    · nlinarith [hg1]
  unfold Kbar
  apply div_pos
  · nlinarith [hlg, hllg]
  · exact hden

/-- (K4) Kbar(G4 t) <= (10 + 2 log t) / (2 c4^2 t^8). -/
lemma st_hKbar4 (t : ℝ) (ht : 1000 ≤ t) : Kbar (G4 t) ≤ Kbar4UB t := by
  set L := Real.log t with hL
  have hL6 : (6 : ℝ) < L := by simpa [hL] using st_L6 t ht
  have ht0 : 0 < t := st_tpos t ht
  have hlg : Real.log (G4 t) < 19 + 4 * L := by simpa [hL] using st_G4log t ht
  have hlg0 : 0 < Real.log (G4 t) := by simpa [hL] using st_logG_pos t ht
  have hllg : Real.log (Real.log (G4 t)) ≤ 18 + 4 * L := by
    calc Real.log (Real.log (G4 t)) ≤ Real.log (19 + 4 * L) :=
          Real.log_le_log hlg0 (le_of_lt hlg)
      _ ≤ 18 + 4 * L := st_log19L L (by linarith [hL6])
  have hden2 : 2 * G4 t * G4 t = 2 * c4sq * t ^ 8 := by
    have hgg : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
    rw [show (2 : ℝ) * G4 t * G4 t = 2 * (G4 t * G4 t) from by ring, hgg]
    ring
  have hnum : 0.110 * (Real.log (G4 t) + 1 / 2) +
        0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290 ≤ 10 + 2 * L := by
    have h1 : 0.110 * (Real.log (G4 t) + 1 / 2) ≤ 0.110 * (19 + 4 * L + 1 / 2) := by
      nlinarith [le_of_lt hlg]
    have h2 : 0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) ≤
        0.290 * (18 + 4 * L + 1 / 2) := by
      nlinarith [hllg]
    nlinarith [h1, h2, hL6]
  have hdenpos : 0 < 2 * c4sq * t ^ 8 := by
    nlinarith [st_c4sq_pos, pow_pos ht0 8]
  calc Kbar (G4 t)
      = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * G4 t * G4 t) := by
        unfold Kbar
        rfl
      _ = (0.110 * (Real.log (G4 t) + 1 / 2) +
          0.290 * (Real.log (Real.log (G4 t)) + 1 / 2) + 2.290) / (2 * c4sq * t ^ 8) := by
        rw [hden2]
      _ ≤ (10 + 2 * L) / (2 * c4sq * t ^ 8) := by
        exact div_le_div_of_nonneg_right hnum (le_of_lt hdenpos)
      _ = Kbar4UB t := by
        unfold Kbar4UB
        rw [show (L : ℝ) = Real.log t from by dsimp only [L]]
        field_simp [st_c4sq_pos.ne', (pow_pos ht0 8).ne']
        dsimp only [c4sq]
        ring

/-- 0 <= X4fun t for t >= 1000. -/
lemma st_X4nonneg (t : ℝ) (ht : 1000 ≤ t) : 0 ≤ X4fun t := by
  dsimp only [X4fun]
  have ht0 : 0 < t := st_tpos t ht
  have hg2 : 0 < G4 t * G4 t + 1 / 4 := by nlinarith [st_G4pos t ht]
  have heps : w t / (G4 t * G4 t + 1 / 4) < 1 / 2 := st_zhalf t ht
  have hden : 0 < 1 - w t / (G4 t * G4 t + 1 / 4) := by linarith [heps]
  have hBfE : Bf t (G4 t) =
      1 / (2 * (G4 t * G4 t + 1 / 4)) +
      (w t / (G4 t * G4 t + 1 / 4)) / (1 - w t / (G4 t * G4 t + 1 / 4)) +
      t / (G4 t * G4 t + 1 / 4) := by
    unfold Bf
    rfl
  apply add_nonneg
  · apply mul_nonneg
    · rw [hBfE]
      have ht1 : 0 ≤ 1 / (2 * (G4 t * G4 t + 1 / 4)) := by
        apply div_nonneg
        · norm_num
        · nlinarith [st_G4pos t ht]
      have ht2 : 0 ≤ t / (G4 t * G4 t + 1 / 4) := by
        apply div_nonneg
        · nlinarith [ht]
        · nlinarith [st_G4pos t ht]
      have ht3 : 0 ≤ (w t / (G4 t * G4 t + 1 / 4)) / (1 - w t / (G4 t * G4 t + 1 / 4)) := by
        apply div_nonneg
        · apply div_nonneg
          · dsimp only [w]; nlinarith [ht]
          · nlinarith [st_G4pos t ht]
        · exact hden.le
      nlinarith [ht1, ht2, ht3]
    · unfold Sbar
      have hllB : 0 < Real.log (Real.log (B4 t)) := by
        have hq : (1 : ℝ) < Real.log (B4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (B4 t) := by
            have ht4 : 0 < t ^ 4 := pow_pos ht0 4
            have heq : Real.log (124000000 * t ^ 4) = Real.log 124000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0) ht4.ne',
                  Real.log_pow t 4]
              ring
            dsimp only [B4]
            rw [heq]
            nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 124000000), hL]
          linarith [hge]
        exact Real.log_pos hq
      have hllG : 0 < Real.log (Real.log (G4 t)) := by
        have hq : (1 : ℝ) < Real.log (G4 t) := by
          have hL : (6 : ℝ) < Real.log t := st_L6 t ht
          have hge : 4 * Real.log t ≤ Real.log (G4 t) := by
            have ht4 : 0 < t ^ 4 := pow_pos ht0 4
            have heq : Real.log (62000000 * t ^ 4) = Real.log 62000000 + 4 * Real.log t := by
              rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) ht4.ne',
                  Real.log_pow t 4]
              ring
            dsimp only [G4]
            rw [heq]
            nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 62000000), hL]
          linarith [hge]
        exact Real.log_pos hq
      apply add_nonneg
      · apply add_nonneg
        · nlinarith [st_logB_pos t ht]
        · nlinarith [hllB]
      · apply add_nonneg
        · nlinarith [st_logG_pos t ht]
        · nlinarith [hllG]
  · apply mul_nonneg
    · unfold Cf
      have hgp : 0 < G4 t * G4 t - t * t := by
        have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
        rw [hG4sq]
        have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
        have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
        have hc4t : 2 ≤ c4sq * t ^ 6 := by
          calc 2 ≤ c4sq * 1000 ^ 6 := hc4
            _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
        nlinarith [hc4t, pow_pos ht0 2]
      have hwp : 0 < w t := by dsimp only [w]; nlinarith [st_G4pos t ht]
      have htpos : 0 < 2 * w t * (G4 t * G4 t) := by
        nlinarith [hwp, st_G4pos t ht]
      have hCf1 : 0 ≤ 2 * w t * (G4 t * G4 t) / (G4 t * G4 t - t * t) :=
        div_nonneg htpos.le (le_of_lt hgp)
      nlinarith [hCf1]
    · exact le_of_lt (st_Kbarpos t ht)

/- 0 < log (log (B4 t)) and 0 < log (log (G4 t)) for t >= 1000. -/
lemma st_llBpos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (Real.log (B4 t)) := by
  have ht0 : 0 < t := st_tpos t ht
  have hq : (1 : ℝ) < Real.log (B4 t) := by
    have hL : (6 : ℝ) < Real.log t := st_L6 t ht
    have hge : 4 * Real.log t ≤ Real.log (B4 t) := by
      have ht4 : 0 < t ^ 4 := pow_pos ht0 4
      have heq : Real.log (124000000 * t ^ 4) = Real.log 124000000 + 4 * Real.log t := by
        rw [Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0) ht4.ne',
            Real.log_pow t 4]
        ring
      dsimp only [B4]
      rw [heq]
      nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 124000000), hL]
    linarith [hge]
  exact Real.log_pos hq

lemma st_llGpos (t : ℝ) (ht : 1000 ≤ t) : 0 < Real.log (Real.log (G4 t)) := by
  have ht0 : 0 < t := st_tpos t ht
  have hq : (1 : ℝ) < Real.log (G4 t) := by
    have hL : (6 : ℝ) < Real.log t := st_L6 t ht
    have hge : 4 * Real.log t ≤ Real.log (G4 t) := by
      have ht4 : 0 < t ^ 4 := pow_pos ht0 4
      have heq : Real.log (62000000 * t ^ 4) = Real.log 62000000 + 4 * Real.log t := by
        rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0) ht4.ne',
            Real.log_pow t 4]
        ring
      dsimp only [G4]
      rw [heq]
      nlinarith [Real.log_pos (by norm_num : (1 : ℝ) < 62000000), hL]
    linarith [hge]
  exact Real.log_pos hq

set_option maxHeartbeats 1000000

/-- (X4) X4fun t <= X4UBfun t for t >= 1000 (component chain). -/
lemma st_X4bound (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ X4UBfun t := by
  dsimp only [X4fun]
  have ht0 : 0 < t := st_tpos t ht
  have hL0 : 0 ≤ Real.log t := Real.log_nonneg (by linarith : 1 ≤ t)
  have hBf : Bf t (G4 t) ≤ Bf4UB t := st_hBf4 t ht
  have hSsum : Sbar (B4 t) + Sbar (G4 t) ≤ SsumUB t := st_hSsum t ht
  have hSs0 : 0 ≤ Sbar (B4 t) + Sbar (G4 t) := by
    unfold Sbar
    nlinarith [st_logB_pos t ht, st_llBpos t ht, st_logG_pos t ht, st_llGpos t ht]
  have hCf : Cf t (G4 t) ≤ Cf4UB t := st_hCf4 t ht
  have hCf0 : 0 ≤ Cf t (G4 t) := by
    unfold Cf
    have hgp2 : 0 < G4 t * G4 t - t * t := by
      have hG4sq : G4 t * G4 t = c4sq * t ^ 8 := st_G4sq t
      rw [hG4sq]
      have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
      have hc4 : (2 : ℝ) ≤ c4sq * 1000 ^ 6 := by norm_num [c4sq]
      have hc4t : 2 ≤ c4sq * t ^ 6 := by
        calc 2 ≤ c4sq * 1000 ^ 6 := hc4
          _ ≤ c4sq * t ^ 6 := mul_le_mul_of_nonneg_left ht6 (by linarith [st_c4sq_pos])
      nlinarith [hc4t, pow_pos ht0 2]
    have hwp : 0 < w t := by dsimp only [w]; nlinarith [st_G4pos t ht]
    have htpos : 0 < 2 * w t * (G4 t * G4 t) := by nlinarith [hwp, st_G4pos t ht]
    have hfrac : 0 ≤ 2 * w t * (G4 t * G4 t) / (G4 t * G4 t - t * t) :=
      div_nonneg htpos.le (le_of_lt hgp2)
    nlinarith [hfrac]
  have hK : Kbar (G4 t) ≤ Kbar4UB t := st_hKbar4 t ht
  have hK0 : 0 ≤ Kbar (G4 t) := le_of_lt (st_Kbarpos t ht)
  have hBf0 : 0 ≤ Bf4UB t := by
    unfold Bf4UB
    have hint : 0 ≤ 1 / t := by rw [one_div]; exact inv_nonneg.mpr ht0.le
    have hint2 : 0 ≤ 1 / (t * t) := by rw [one_div]; exact inv_nonneg.mpr (mul_nonneg ht0.le ht0.le)
    have hnumB : 0 ≤ (2 : ℝ) + 1 / t + 1 / (t * t) := by nlinarith [hint, hint2]
    have hint6 : 0 ≤ (1 : ℝ) / t ^ 6 := by
      rw [one_div]
      exact inv_nonneg.mpr (pow_nonneg ht0.le 6)
    apply div_nonneg
    · nlinarith [hnumB, hint6]
    · norm_num
  have hCf4UB0 : 0 ≤ Cf4UB t := by
    dsimp only [Cf4UB]
    nlinarith [ht]

  have hBfS : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) ≤
      Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) :=
    mul_le_mul hBf le_rfl hSs0 hBf0
  have hBs : Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) ≤ Bf4UB t * SsumUB t :=
    mul_le_mul le_rfl hSsum hSs0 hBf0
  have hCfK : Cf t (G4 t) * Kbar (G4 t) ≤ Cf4UB t * Kbar (G4 t) :=
    mul_le_mul hCf le_rfl hK0 hCf4UB0
  have hKs : Cf4UB t * Kbar (G4 t) ≤ Cf4UB t * Kbar4UB t :=
    mul_le_mul le_rfl hK hK0 hCf4UB0
  have hfinal : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
      Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t := by
    have hm1 : Bf t (G4 t) * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) := by
      nlinarith [hBfS]
    have hm2 : Bf4UB t * (Sbar (B4 t) + Sbar (G4 t)) + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf t (G4 t) * Kbar (G4 t) := by
      nlinarith [hBs]
    have hm3 : Bf4UB t * SsumUB t + Cf t (G4 t) * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf4UB t * Kbar (G4 t) := by
      nlinarith [hCfK]
    have hm4 : Bf4UB t * SsumUB t + Cf4UB t * Kbar (G4 t) ≤
        Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t := by
      nlinarith [hKs]
    nlinarith [hm1, hm2, hm3, hm4]

  set L := Real.log t with hL
  have hL0' : 0 ≤ L := hL0
  have hTden : 0 < t ^ 6 * c4sq := mul_pos (pow_pos ht0 6) st_c4sq_pos
  have hb : Bf4UB t * SsumUB t ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    unfold Bf4UB; unfold SsumUB
    dsimp only [L]
    have hc4 : c4sq = (62000000 * 62000000 : ℝ) := by dsimp only [c4sq]
    have hinv : (2 : ℝ) + 1 / t + 1 / (t * t) ≤ 2001001 / 10 ^ 6 := by
      have h1t : 1 / t ≤ 1 / 1000 := by
        rw [one_div, one_div, inv_le_inv₀ ht0 (by norm_num : (0 : ℝ) < 1000)]
        exact ht
      have h1t2a : 1 / (t * t) = (1 / t) ^ 2 := by ring
      have h1t2b : (1 / t) ^ 2 ≤ (1 / 1000) ^ 2 :=
        pow_le_pow_left₀ (by rw [one_div] at *; exact inv_nonneg.mpr ht0.le) h1t 2
      have h1t2c : (1 / 1000 : ℝ) ^ 2 = 1 / 10 ^ 6 := by norm_num
      have h1t2 : 1 / (t * t) ≤ 1 / 10 ^ 6 := by
        rw [h1t2a]
        linarith [h1t2b, h1t2c]
      nlinarith [h1t, h1t2, show (2 : ℝ) ≤ 2001001 / 10 ^ 6 from by norm_num]
    have hS0 : 0 ≤ 20 + 4 * L := by nlinarith [hL0']
    have h1 : (2 + 1 / t + 1 / (t * t)) * (20 + 4 * L) ≤
        (2001001 / 10 ^ 6) * (20 + 4 * L) :=
      mul_le_mul_of_nonneg_right hinv hS0
    have hD : 0 < (10 : ℝ) ^ 6 * (62000000 * 62000000) * t ^ 6 := by
      apply mul_pos
      · apply mul_pos
        · norm_num
        · norm_num
      · exact pow_pos ht0 6
    have hSlog : 20 + 4 * Real.log t = 20 + 4 * L := by rw [← hL]
    rw [hSlog]
    rw [show (2 + 1 / t + 1 / (t * t)) * (1 / t ^ 6) / (62000000 * 62000000) * (20 + 4 * L) =
        ((2 + 1 / t + 1 / (t * t)) * (20 + 4 * L)) * ((1 / t ^ 6) / (62000000 * 62000000)) from by
      field_simp [(pow_pos ht0 6).ne', (by norm_num : (0 : ℝ) ≠ 62000000 * 62000000)]
    ]
    rw [show (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) =
        ((2001001 / 10 ^ 6) * (20 + 4 * L)) * ((1 / t ^ 6) / (62000000 * 62000000)) from by
      rw [hc4]
      field_simp [(pow_pos ht0 6).ne', (pow_pos (by norm_num : (0 : ℝ) < 10) 6).ne',
          (by norm_num : (0 : ℝ) ≠ 62000000 * 62000000)]
    ]
    have hDpos : 0 ≤ (1 / t ^ 6) / (62000000 * 62000000) := by
      apply div_nonneg
      · rw [one_div]; exact inv_nonneg.mpr (pow_nonneg ht0.le 6)
      · norm_num
    exact mul_le_mul_of_nonneg_right h1 hDpos
  have hc : Cf4UB t * Kbar4UB t ≤ (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    unfold Cf4UB
    unfold Kbar4UB
    dsimp only [L]
    have hc4 : (4 : ℝ) * t * t + 2 ≤ (4000002 : ℝ) / 10 ^ 6 * (t * t) := by
      have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
      have hinv : 2 ≤ (2 : ℝ) / 10 ^ 6 * (t * t) := by
        have hinv1 : (2 : ℝ) = (2 : ℝ) / 10 ^ 6 * (1000 * 1000 : ℝ) := by norm_num
        have ht2' : 1000 * 1000 ≤ t * t := by simpa [show (1000 : ℝ) ^ 2 = 1000 * 1000 from by ring, pow_two] using ht2
        have hstep : (2 : ℝ) / 10 ^ 6 * (1000 * 1000 : ℝ) ≤ (2 : ℝ) / 10 ^ 6 * (t * t) := by
          apply mul_le_mul_of_nonneg_left ht2'
          nlinarith [show (0 : ℝ) < 10 ^ 6 from by norm_num]
        linarith [hinv1, hstep]
      nlinarith [hinv]
    have hK0' : 0 ≤ (10 + 2 * Real.log t) / (2 * c4sq * t ^ 8) := by
      apply div_nonneg
      · nlinarith [hL0]
      · exact le_of_lt (by nlinarith [st_c4sq_pos, pow_pos ht0 8])
    have hB0 : 0 ≤ (4000002 : ℝ) / 10 ^ 6 * (t * t) := by
      apply mul_nonneg
      · norm_num
      ·       exact mul_self_nonneg t
    have hmul : (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) ≤
        ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
            exact mul_le_mul hc4 le_rfl hK0' hB0
    have hstep : ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) =
        (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := by
      have hconst : (4000002 : ℝ) = 2 * 2000001 := by norm_num
      field_simp [(st_ct8 t ht).ne', (st_ct6 t ht).ne', (pow_pos ht0 2).ne']
      rw [hconst]
      ring
    have hstep2 : (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) =
        (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
      dsimp only [L]
    have hd : (2 * 62000000 * 62000000 * t ^ 8 : ℝ) = 2 * c4sq * t ^ 8 := by
      dsimp only [c4sq]
      ring
    calc (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * 62000000 * 62000000 * t ^ 8))
        = (4 * t * t + 2) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := by
          rw [hd]
    _ ≤ ((4000002 : ℝ) / 10 ^ 6 * (t * t)) * ((10 + 2 * Real.log t) / (2 * c4sq * t ^ 8)) := hmul
    _ = (2000001 : ℝ) * (10 + 2 * Real.log t) / (10 ^ 6 * c4sq * t ^ 6) := hstep
    _ = (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := hstep2

  have hc1 : (60020030 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 160 := by norm_num [c4sq]
  have hc2 : (12004006 : ℝ) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * 35 := by norm_num [c4sq]
  have hsum : (60020030 + 12004006 * L) * 10 ^ 16 ≤ 10 ^ 6 * c4sq * (160 + 35 * L) := by
    nlinarith [hc1, hc2, mul_nonneg (by norm_num : 0 ≤ (12004006 : ℝ) * 10 ^ 16) hL0']
  have hmid : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
      (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
    have hadd : (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) +
        (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) =
        (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
      field_simp [(st_ct6 t ht).ne', (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 6) st_c4sq_pos).ne']
      ring
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t
        ≤ (2001001 : ℝ) * (20 + 4 * L) / (10 ^ 6 * c4sq * t ^ 6) +
          (2000001 : ℝ) * (10 + 2 * L) / (10 ^ 6 * c4sq * t ^ 6) := by
          nlinarith [hb, hc]
    _ = (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := hadd
  have hsqueeze : (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) ≤
      (160 + 35 * L) / (10 ^ 16 * t ^ 6) := by
    have hsumt : (60020030 + 12004006 * L) * 10 ^ 16 * t ^ 6 ≤
        10 ^ 6 * c4sq * (160 + 35 * L) * t ^ 6 :=
      mul_le_mul_of_nonneg_right hsum (pow_nonneg ht0.le 6)
    have heq1 : (60020030 + 12004006 * L) * 10 ^ 16 * t ^ 6 =
        (60020030 + 12004006 * L) * (10 ^ 16 * t ^ 6) := by ring
    have heq2 : 10 ^ 6 * c4sq * (160 + 35 * L) * t ^ 6 =
        (160 + 35 * L) * (10 ^ 6 * c4sq * t ^ 6) := by ring
    rw [div_le_div_iff₀ (mul_pos (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 6) st_c4sq_pos) (pow_pos ht0 6))
        (mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6))]
    calc (60020030 + 12004006 * L) * (10 ^ 16 * t ^ 6)
        = (60020030 + 12004006 * L) * 10 ^ 16 * t ^ 6 := by rw [← heq1]
    _ ≤ 10 ^ 6 * c4sq * (160 + 35 * L) * t ^ 6 := hsumt
    _ = (160 + 35 * L) * (10 ^ 6 * c4sq * t ^ 6) := by rw [heq2]
  have htotal2 : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
      (160 + 35 * L) / (10 ^ 16 * t ^ 6) := by
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
          (60020030 + 12004006 * L) / (10 ^ 6 * c4sq * t ^ 6) := hmid
    _ ≤ (160 + 35 * L) / (10 ^ 16 * t ^ 6) := hsqueeze
  have hend : (160 + 35 * L) / (10 ^ 16 * t ^ 6) = X4UBfun t := by
    unfold X4UBfun
    field_simp [(mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)).ne']
    ring
  have htotal : Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤ X4UBfun t := by
    calc Bf4UB t * SsumUB t + Cf4UB t * Kbar4UB t ≤
        (160 + 35 * L) / (10 ^ 16 * t ^ 6) := htotal2
      _ = X4UBfun t := hend
  nlinarith [hfinal, htotal]


set_option maxHeartbeats 200000

/-- (E3) X4UBfun t <= 1/2 for t >= 1000. -/
lemma st_XUBhalf (t : ℝ) (ht : 1000 ≤ t) : X4UBfun t ≤ 1 / 2 := by
  dsimp only [X4UBfun]
  set L := Real.log t
  have hL0 : 0 ≤ L := by dsimp only [L]; exact Real.log_nonneg (by linarith : 1 ≤ t)
  have ht0 : 0 < t := st_tpos t ht
  have ht2 : t ≤ t * t := by nlinarith [ht0.le, ht]
  have ht2p : t ≤ t ^ 2 := by simpa [pow_two] using ht2
  have hL2 : (L : ℝ) ^ 2 ≤ t := st_L2le_t t ht
  have hL2t : (L : ℝ) ^ 2 ≤ t ^ 2 := le_trans hL2 ht2p
  have hLtle : L ≤ t := (sq_le_sq₀ hL0 ht0.le).mp hL2t
  have hstep1 : (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6 =
      16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) := by
    field_simp [(pow_pos ht0 6).ne']
  have hD16 : 0 < (10 : ℝ) ^ 16 * t ^ 6 :=
    mul_pos (pow_pos (by norm_num : (0 : ℝ) < 10) 16) (pow_pos ht0 6)
  have hlt : 35 * L / (10 ^ 16 * t ^ 6) ≤ 35 * t / (10 ^ 16 * t ^ 6) := by
    field_simp [hD16.ne']
    nlinarith [hLtle]
  have hstep2 : 16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) ≤
      16 / (10 ^ 15 * t ^ 6) + 35 * t / (10 ^ 16 * t ^ 6) := by
    exact add_le_add (by linarith : 16 / (10 ^ 15 * t ^ 6) ≤ 16 / (10 ^ 15 * t ^ 6)) hlt
  have h5 : 35 * t / (10 ^ 16 * t ^ 6) = 35 / (10 ^ 16 * t ^ 5) := by
    field_simp [(pow_pos ht0 6).ne', (pow_pos ht0 5).ne']
  have h6a : 16 / (10 ^ 15 * t ^ 6) ≤ 16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) := by
    have ht6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 6
    have hc6 : 10 ^ 15 * (1000 : ℝ) ^ 6 ≤ 10 ^ 15 * t ^ 6 :=
      mul_le_mul_of_nonneg_left ht6 (by norm_num : (0 : ℝ) ≤ 10 ^ 15)
    exact div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 16)
      (by norm_num : (0 : ℝ) < 10 ^ 15 * (1000 : ℝ) ^ 6) hc6
  have h6b : 35 / (10 ^ 16 * t ^ 5) ≤ 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) := by
    have ht5 : (1000 : ℝ) ^ 5 ≤ t ^ 5 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 5
    have hc5 : 10 ^ 16 * (1000 : ℝ) ^ 5 ≤ 10 ^ 16 * t ^ 5 :=
      mul_le_mul_of_nonneg_left ht5 (by norm_num : (0 : ℝ) ≤ 10 ^ 16)
    exact div_le_div_of_nonneg_left (by norm_num : (0 : ℝ) ≤ 35)
      (by norm_num : (0 : ℝ) < 10 ^ 16 * (1000 : ℝ) ^ 5) hc5
  have h6c : 16 / (10 ^ 15 * t ^ 6) + 35 / (10 ^ 16 * t ^ 5) ≤
      16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) + 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) :=
    add_le_add h6a h6b
  calc (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6
      = 16 / (10 ^ 15 * t ^ 6) + 35 * L / (10 ^ 16 * t ^ 6) := hstep1
    _ ≤ 16 / (10 ^ 15 * t ^ 6) + 35 * t / (10 ^ 16 * t ^ 6) := hstep2
    _ = 16 / (10 ^ 15 * t ^ 6) + 35 / (10 ^ 16 * t ^ 5) := by rw [h5]
    _ ≤ 16 / (10 ^ 15 * (1000 : ℝ) ^ 6 : ℝ) + 35 / (10 ^ 16 * (1000 : ℝ) ^ 5 : ℝ) := h6c
    _ ≤ 1 / 2 := by norm_num

/-- (E3) X4fun t <= 1/2 for t >= 1000 (from the X4 bound chain). -/
lemma st_X4half (t : ℝ) (ht : 1000 ≤ t) : X4fun t ≤ 1 / 2 := by
  calc X4fun t ≤ X4UBfun t := st_X4bound t ht
    _ ≤ 1 / 2 := st_XUBhalf t ht

/-- exp (1/2) <= 2. -/
lemma st_e12 : Real.exp (1 / 2) ≤ 2 := by
  have h34a : Real.exp 1 < 4 := by linarith [Real.exp_one_lt_three]
  have h4 : (2 : ℝ) ^ 2 = 4 := by norm_num
  have h34 : Real.exp 1 < (2 : ℝ) ^ 2 := by
    rw [← h4] at h34a
    exact h34a
  have heq : (Real.exp (1 / 2) : ℝ) ^ 2 = Real.exp 1 := by
    rw [pow_two, ← Real.exp_add (1 / 2) (1 / 2)]
    rw [show (1 / 2 : ℝ) + 1 / 2 = 1 from by norm_num]
  have hsq : (Real.exp (1 / 2) : ℝ) ^ 2 < (2 : ℝ) ^ 2 := by rw [heq]; exact h34
  have hp : 0 ≤ Real.exp (1 / 2) := Real.exp_nonneg (1 / 2)
  exact (sq_le_sq₀ hp (by norm_num : (0 : ℝ) ≤ 2)).mp (le_of_lt hsq)

/-- (E4) exp (X4fun t) <= 2 for t >= 1000. -/
lemma st_eX4le2 (t : ℝ) (ht : 1000 ≤ t) : Real.exp (X4fun t) ≤ 2 := by
  calc Real.exp (X4fun t) ≤ Real.exp (1 / 2) :=
        Real.exp_le_exp.mpr (st_X4half t ht)
    _ ≤ 2 := st_e12
/- — §3: W terms — p8_B(t, n4 t) ≤ A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷ (certified anchors,
    scripts/rh/day028_25af_constants.py [0][3]). — -/

/-- ceil bridge: 31000000·t⁴ ≤ (n4 t : ℝ). -/
lemma st_ceilLo (t : ℝ) : (31000000 : ℝ) * t ^ 4 ≤ (n4 t : ℝ) := by
  dsimp only [n4]
  exact Nat.le_ceil ((31000000 : ℝ) * t ^ 4)

/-- n4 t > 0 for t ≥ 1000. -/
lemma st_n4pos (t : ℝ) (ht : 1000 ≤ t) : 0 < (n4 t : ℝ) := by
  have hoc : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos (st_tpos t ht) 4)
  linarith [st_ceilLo t, hoc]

/-- sqrt anchor: 5567 ≤ √31000000 (exact integers: 5567² ≤ 31000000). -/
lemma st_sqrt5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := by
  have hsq : (5567 : ℝ) ^ 2 ≤ (Real.sqrt 31000000) ^ 2 := by
    rw [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 31000000)]
    norm_num
  exact (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 5567) (Real.sqrt_nonneg 31000000)).mp hsq

/-- (A1) W1: (1/2)·n4⁻¹ᐟ² ≤ A1·t⁻². -/
lemma st_W1 (t : ℝ) (ht : 1000 ≤ t) :
    (1 / 2 : ℝ) * (n4 t : ℝ) ^ (-1 / 2 : ℝ) ≤ A1 * t ^ (-2 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hmono : (n4 t : ℝ) ^ (-1 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-1 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-1 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-1 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-1 / 2 : ℝ) * t ^ (-2 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [show (t ^ 4 : ℝ) = (t : ℝ) ^ (4 : ℝ) from by simp]
    rw [← Real.rpow_mul ht0.le 4 (-1 / 2 : ℝ), show (4 * (-1 / 2) : ℝ) = (-2 : ℝ) from by ring]
  have hconst : (1 / 2 : ℝ) * (31000000 : ℝ) ^ (-1 / 2 : ℝ) ≤ A1 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hinv : (31000000 : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt 31000000 := by
      have hexp : (-1 / 2 : ℝ) = -(1 / 2 : ℝ) := by ring
      rw [hexp, Real.rpow_neg hc.le (1 / 2 : ℝ)]
      rw [show (31000000 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 31000000 from
          (Real.sqrt_eq_rpow (31000000 : ℝ)).symm]
      exact (one_div (Real.sqrt 31000000)).symm
    rw [hinv]
    have ha : (0 : ℝ) ≤ 1 / 2 := by norm_num
    have hb : 0 ≤ A1 * Real.sqrt 31000000 := by
      apply mul_nonneg
      · dsimp only [A1]; norm_num
      · exact Real.sqrt_nonneg 31000000
    have hsq : (1 / 2 : ℝ) ^ 2 ≤ (A1 * Real.sqrt 31000000) ^ 2 := by
      have hR : (A1 * Real.sqrt 31000000 : ℝ) ^ 2 = A1 ^ 2 * 31000000 := by
        rw [mul_pow, Real.sq_sqrt hc.le]
      rw [hR]
      norm_num [A1]
    have hle : (1 / 2 : ℝ) ≤ A1 * Real.sqrt 31000000 := (sq_le_sq₀ ha hb).mp hsq
    have hfold : (1 / 2 : ℝ) * (1 / Real.sqrt 31000000) = (1 / 2 : ℝ) / Real.sqrt 31000000 := by ring
    rw [hfold, div_le_iff₀ hrs]
    exact hle
  calc (1 / 2 : ℝ) * (n4 t : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2 : ℝ) * (31000000 * t ^ 4) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hmono (by norm_num : (0 : ℝ) ≤ 1 / 2)
    _ = (1 / 2 : ℝ) * ((31000000 : ℝ) ^ (-1 / 2 : ℝ) * t ^ (-2 : ℝ)) := by rw [hsplit]
    _ = ((1 / 2 : ℝ) * (31000000 : ℝ) ^ (-1 / 2 : ℝ)) * t ^ (-2 : ℝ) := by ring
    _ ≤ A1 * t ^ (-2 : ℝ) :=
        mul_le_mul_of_nonneg_right hconst (Real.rpow_nonneg ht0.le (-2 : ℝ))

/-- (A2) W2: (‖s‖/12)·n4⁻³ᐟ² ≤ A2·t⁻⁵, s = 1/2 + i·t. -/
lemma st_W2 (t : ℝ) (ht : 1000 ≤ t) :
    (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ) ≤
        A2 * t ^ (-5 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hs : ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (1 / 4 + t * t) := S4G.hNorm t
  rw [hs]
  have hnorm : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := S4G.hSbnd t (le_of_lt ht0)
  have hmono : (n4 t : ℝ) ^ (-3 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-3 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-3 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-3 / 2 : ℝ) * t ^ (-6 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [show (t ^ 4 : ℝ) = (t : ℝ) ^ (4 : ℝ) from by simp]
    rw [← Real.rpow_mul ht0.le 4 (-3 / 2 : ℝ), show (4 * (-3 / 2) : ℝ) = (-6 : ℝ) from by ring]
  -- (t+1/2)·t⁻⁶ ≤ (2001/2000)·t⁻⁵  [t ≥ 1000 ⟹ 1/(2t) ≤ 1/2000]
  have htf : (t + 1 / 2 : ℝ) * t ^ (-6 : ℝ) ≤ (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) := by
    have hcore : (t + 1 / 2 : ℝ) ≤ (2001 / 2000 : ℝ) * t := by
      have h3 : (3 : ℝ) ≤ (3 / 1000 : ℝ) * t := by
        calc (3 : ℝ) = (3 / 1000 : ℝ) * 1000 := by ring
          _ ≤ (3 / 1000 : ℝ) * t :=
            mul_le_mul_of_nonneg_left ht (by norm_num : (0 : ℝ) ≤ 3 / 1000)
      nlinarith [h3]
    have htm : (t : ℝ) * t ^ (-6 : ℝ) = t ^ (-5 : ℝ) := by
      rw [show (t : ℝ) * (t : ℝ) ^ (-6 : ℝ) = (t : ℝ) ^ (1 : ℝ) * (t : ℝ) ^ (-6 : ℝ) from
          (congrArg (fun (x : ℝ) => x * (t : ℝ) ^ (-6 : ℝ)) (Real.rpow_one t).symm),
          ← Real.rpow_add ht0 (1 : ℝ) (-6 : ℝ), show (1 : ℝ) + (-6 : ℝ) = (-5 : ℝ) from by ring]
    calc (t + 1 / 2 : ℝ) * t ^ (-6 : ℝ)
        ≤ ((2001 / 2000 : ℝ) * t) * t ^ (-6 : ℝ) :=
          mul_le_mul_of_nonneg_right hcore (Real.rpow_nonneg ht0.le (-6 : ℝ))
      _ = (2001 / 2000 : ℝ) * (t * t ^ (-6 : ℝ)) := by ring
      _ = (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) := by rw [htm]
  have hA2raw : (31000000 : ℝ) ^ (-3 / 2 : ℝ) * (2001 / 24000 : ℝ) ≤ A2 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hbridge : (31000000 : ℝ) ^ (-3 / 2 : ℝ) = 1 / (31000000 * Real.sqrt 31000000) := by
      have hexp : (-3 / 2 : ℝ) = -(3 / 2 : ℝ) := by ring
      rw [hexp, Real.rpow_neg hc.le (3 / 2 : ℝ)]
      rw [show (31000000 : ℝ) ^ (3 / 2 : ℝ) = 31000000 * Real.sqrt 31000000 from by
        rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by ring, Real.rpow_add hc 1 (1 / 2 : ℝ)]
        rw [show (31000000 : ℝ) ^ (1 : ℝ) = 31000000 from Real.rpow_one (31000000 : ℝ),
            show (31000000 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 31000000 from
              (Real.sqrt_eq_rpow (31000000 : ℝ)).symm]
      ]
      exact (one_div (31000000 * Real.sqrt 31000000)).symm
    rw [hbridge]
    have h5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := st_sqrt5567
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hd1 : 0 < 31000000 * Real.sqrt 31000000 := mul_pos hc hrs
    have hd2 : (0 : ℝ) < 31000000 * 5567 := by norm_num
    have hinner : 31000000 * 5567 ≤ 31000000 * Real.sqrt 31000000 := by
      have h1 : (31000000 : ℝ) * 5567 = 5567 * 31000000 := by ring
      have h2 : (31000000 : ℝ) * Real.sqrt 31000000 = Real.sqrt 31000000 * 31000000 := by ring
      rw [h1, h2]
      exact mul_le_mul_of_nonneg_right h5567 (by norm_num : (0 : ℝ) ≤ 31000000)
    have hinv : 1 / (31000000 * Real.sqrt 31000000) ≤ 1 / (31000000 * 5567) := by
      rw [div_le_div_iff₀ hd1 hd2, one_mul, one_mul]
      exact hinner
    have hstep : (2001 / 24000 : ℝ) / (31000000 * Real.sqrt 31000000) ≤
        (2001 / 24000 : ℝ) / (31000000 * 5567) := by
      have hL : (2001 / 24000 : ℝ) / (31000000 * Real.sqrt 31000000) =
          (2001 / 24000 : ℝ) * (1 / (31000000 * Real.sqrt 31000000)) := by field_simp
      have hR : (2001 / 24000 : ℝ) / (31000000 * 5567) =
          (2001 / 24000 : ℝ) * (1 / (31000000 * 5567)) := by field_simp
      rw [hL, hR]
      exact mul_le_mul_of_nonneg_left hinv (by norm_num : (0 : ℝ) ≤ 2001 / 24000)
    have hfinal : (2001 / 24000 : ℝ) / (31000000 * 5567) ≤ (5 : ℝ) / 10 ^ 13 := by
      have h1 : (2001 / 24000 : ℝ) / (31000000 * 5567) = 2001 / (24000 * 31000000 * 5567) := by ring
      rw [h1]
      rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 24000 * 31000000 * 5567)
          (by norm_num : (0 : ℝ) < 10 ^ 13)]
      norm_num
    calc 1 / (31000000 * Real.sqrt 31000000) * (2001 / 24000 : ℝ)
        = (2001 / 24000 : ℝ) / (31000000 * Real.sqrt 31000000) := by ring
      _ ≤ (2001 / 24000 : ℝ) / (31000000 * 5567) := hstep
      _ ≤ (5 : ℝ) / 10 ^ 13 := hfinal
      _ = A2 := by dsimp only [A2]
  have hstep0 : Real.sqrt (1 / 4 + t * t) / 12 ≤ (t + 1 / 2) / 12 := by
    rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 12) (by norm_num : (0 : ℝ) < 12)]
    nlinarith [hnorm]
  have hposc : 0 ≤ (31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12 :=
    div_nonneg (Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) (-3 / 2 : ℝ)) (by norm_num)
  have hpre : 0 ≤ (t + 1 / 2) / 12 := by
    apply div_nonneg
    · nlinarith [le_of_lt ht0]
    · norm_num
  calc (Real.sqrt (1 / 4 + t * t) / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ)
      ≤ ((t + 1 / 2) / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hstep0 (Real.rpow_nonneg (st_n4pos t ht).le (-3 / 2 : ℝ))
    _ ≤ ((t + 1 / 2) / 12) * (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) := by
        have hstep : (n4 t : ℝ) ^ (-3 / 2 : ℝ) * ((t + 1 / 2) / 12) ≤
            (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) * ((t + 1 / 2) / 12) :=
          mul_le_mul_of_nonneg_right hmono hpre
        calc (t + 1 / 2) / 12 * (n4 t : ℝ) ^ (-3 / 2 : ℝ)
            = (n4 t : ℝ) ^ (-3 / 2 : ℝ) * ((t + 1 / 2) / 12) := by ring
          _ ≤ (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) * ((t + 1 / 2) / 12) := hstep
          _ = (t + 1 / 2) / 12 * (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) := by ring
    _ = ((t + 1 / 2) / 12) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * t ^ (-6 : ℝ)) := by rw [hsplit]
    _ = ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) * ((t + 1 / 2) * t ^ (-6 : ℝ)) := by ring
    _ ≤ ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) * ((2001 / 2000 : ℝ) * t ^ (-5 : ℝ)) := by
        have hco : 0 ≤ (31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12 :=
          div_nonneg (Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) (-3 / 2 : ℝ)) (by norm_num)
        have hstep : (t + 1 / 2 : ℝ) * t ^ (-6 : ℝ) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) ≤
            (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) :=
          mul_le_mul_of_nonneg_right htf hco
        calc (31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12 * ((t + 1 / 2) * t ^ (-6 : ℝ))
            = (t + 1 / 2) * t ^ (-6 : ℝ) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) := by ring
          _ ≤ (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) := hstep
          _ = ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) * ((2001 / 2000 : ℝ) * t ^ (-5 : ℝ)) := by ring
    _ = ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * (2001 / 24000 : ℝ)) * t ^ (-5 : ℝ) := by ring
    _ ≤ A2 * t ^ (-5 : ℝ) :=
        mul_le_mul_of_nonneg_right hA2raw (Real.rpow_nonneg ht0.le (-5 : ℝ))

/-- (A3) W3: (√3/540)·‖s(s+1)(s+2)‖·n4⁻⁵ᐟ² ≤ A3·t⁻⁷. -/
lemma st_W3 (t : ℝ) (ht : 1000 ≤ t) :
    (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (n4 t : ℝ) ^ (-5 / 2 : ℝ) ≤ A3 * t ^ (-7 : ℝ) := by
  set H3 := ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ with hH3
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hsqrt3 : Real.sqrt 3 ≤ (17321 : ℝ) / 10 ^ 4 := by
    calc Real.sqrt 3 ≤ (17321 : ℝ) / 10000 := S4G.hSqrt3
      _ = (17321 : ℝ) / 10 ^ 4 := by norm_num
  have hs3 : ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ ≤ (t + 3) ^ 3 := S4G.hS3norm t (le_of_lt ht0)
  have hmono : (n4 t : ℝ) ^ (-5 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-5 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-5 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [show (t ^ 4 : ℝ) = (t : ℝ) ^ (4 : ℝ) from by simp]
    rw [← Real.rpow_mul ht0.le 4 (-5 / 2 : ℝ), show (4 * (-5 / 2) : ℝ) = (-10 : ℝ) from by ring]
  -- (t+3)³ ≤ (1003/1000)³·t³  [t ≥ 1000 ⟹ 1 + 3/t ≤ 1003/1000]
  have ht3 : (t + 3 : ℝ) ^ 3 ≤ (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by
    have h1 : (t + 3 : ℝ) ≤ (1003 / 1000 : ℝ) * t := by
      have h3 : (3 : ℝ) ≤ (3 / 1000 : ℝ) * t := by
        calc (3 : ℝ) = (3 / 1000 : ℝ) * 1000 := by ring
          _ ≤ (3 / 1000 : ℝ) * t :=
            mul_le_mul_of_nonneg_left ht (by norm_num : (0 : ℝ) ≤ 3 / 1000)
      nlinarith [h3]
    have hpow : (t + 3 : ℝ) ^ 3 ≤ ((1003 / 1000 : ℝ) * t) ^ 3 :=
      pow_le_pow_left₀ (by nlinarith [le_of_lt ht0]) h1 3
    have hmul : ((1003 / 1000 : ℝ) * t) ^ 3 = (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by
      rw [mul_pow]
    calc (t + 3 : ℝ) ^ 3 ≤ ((1003 / 1000 : ℝ) * t) ^ 3 := hpow
      _ = (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by rw [hmul]
  -- t³·t⁻¹⁰ = t⁻⁷
  have ht7 : (t : ℝ) ^ 3 * t ^ (-10 : ℝ) = t ^ (-7 : ℝ) := by
    rw [show (t : ℝ) ^ 3 = (t : ℝ) ^ (3 : ℝ) from by simp]
    rw [← Real.rpow_add ht0 (3 : ℝ) (-10 : ℝ)]
    rw [show (3 : ℝ) + (-10 : ℝ) = (-7 : ℝ) from by ring]
  have hA3raw : (17321 : ℝ) / 10 ^ 4 / 540 * (31000000 : ℝ) ^ (-5 / 2 : ℝ) *
      (1003 / 1000 : ℝ) ^ 3 ≤ A3 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hbridge : (31000000 : ℝ) ^ (-5 / 2 : ℝ) = 1 / (31000000 ^ 2 * Real.sqrt 31000000) := by
      have hexp : (-5 / 2 : ℝ) = -(5 / 2 : ℝ) := by ring
      rw [hexp, Real.rpow_neg hc.le (5 / 2 : ℝ)]
      rw [show (31000000 : ℝ) ^ (5 / 2 : ℝ) = 31000000 ^ 2 * Real.sqrt 31000000 from by
        rw [show (5 / 2 : ℝ) = 2 + 1 / 2 from by ring, Real.rpow_add hc 2 (1 / 2 : ℝ)]
        rw [show (31000000 : ℝ) ^ (2 : ℝ) = (31000000 ^ 2 : ℝ) from by norm_num,
            show (31000000 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 31000000 from
              (Real.sqrt_eq_rpow (31000000 : ℝ)).symm]
      ]
      exact (one_div (31000000 ^ 2 * Real.sqrt 31000000)).symm
    rw [hbridge]
    have h5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := st_sqrt5567
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hd1 : 0 < 31000000 ^ 2 * Real.sqrt 31000000 := mul_pos (pow_pos hc 2) hrs
    have hd2 : (0 : ℝ) < 31000000 ^ 2 * 5567 := by norm_num
    have hinner : 31000000 ^ 2 * 5567 ≤ 31000000 ^ 2 * Real.sqrt 31000000 := by
      have h1 : (31000000 : ℝ) ^ 2 * 5567 = 5567 * 31000000 ^ 2 := by ring
      have h2 : (31000000 : ℝ) ^ 2 * Real.sqrt 31000000 = Real.sqrt 31000000 * 31000000 ^ 2 := by ring
      rw [h1, h2]
      exact mul_le_mul_of_nonneg_right h5567 (pow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) 2)
    have hinv : 1 / (31000000 ^ 2 * Real.sqrt 31000000) ≤ 1 / (31000000 ^ 2 * 5567) := by
      rw [div_le_div_iff₀ hd1 hd2, one_mul, one_mul]
      exact hinner
    have hK : 0 ≤ (17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3 := by
      apply mul_nonneg
      · apply div_nonneg
        · norm_num
        · norm_num
      · exact pow_nonneg (by norm_num : (0 : ℝ) ≤ 1003 / 1000) 3
    have hstep : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
        (31000000 ^ 2 * Real.sqrt 31000000) ≤
        ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) / (31000000 ^ 2 * 5567) := by
      have hL : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
          (31000000 ^ 2 * Real.sqrt 31000000) =
          ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) *
            (1 / (31000000 ^ 2 * Real.sqrt 31000000)) := by field_simp
      have hR : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
          (31000000 ^ 2 * 5567) =
          ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) *
            (1 / (31000000 ^ 2 * 5567)) := by field_simp
      rw [hL, hR]
      exact mul_le_mul_of_nonneg_left hinv hK
    have hfinal : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
        (31000000 ^ 2 * 5567) ≤ (1 : ℝ) / 10 ^ 20 := by
      have h1 : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
          (31000000 ^ 2 * 5567) =
          17321 * 1003 ^ 3 / (10 ^ 4 * 540 * 1000 ^ 3 * 31000000 ^ 2 * 5567) := by
        field_simp
      rw [h1]
      rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 10 ^ 4 * 540 * 1000 ^ 3 * 31000000 ^ 2 * 5567)
          (by norm_num : (0 : ℝ) < 10 ^ 20)]
      norm_num
    calc (17321 : ℝ) / 10 ^ 4 / 540 * (1 / (31000000 ^ 2 * Real.sqrt 31000000)) *
        (1003 / 1000 : ℝ) ^ 3
        = ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) /
            (31000000 ^ 2 * Real.sqrt 31000000) := by ring
      _ ≤ ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) / (31000000 ^ 2 * 5567) := hstep
      _ ≤ (1 : ℝ) / 10 ^ 20 := hfinal
      _ = A3 := by dsimp only [A3]

  calc (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (n4 t : ℝ) ^ (-5 / 2 : ℝ)
      = (Real.sqrt 3 / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by rw [← hH3]
    _ ≤ ((17321 / 10 ^ 4) / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
        have hL : (Real.sqrt 3 / 540 : ℝ) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) =
            (Real.sqrt 3 / 540) * (H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) := by ring
        have hR : ((17321 / 10 ^ 4 : ℝ) / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) =
            ((17321 / 10 ^ 4) / 540) * (H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) := by ring
        rw [hL, hR]
        have h54 : (Real.sqrt 3 / 540 : ℝ) ≤ (17321 / 10 ^ 4) / 540 := by
          have hL2 : (Real.sqrt 3 / 540 : ℝ) = (1 / 540 : ℝ) * Real.sqrt 3 := by ring
          have hR2 : ((17321 / 10 ^ 4 : ℝ) / 540) = (1 / 540 : ℝ) * (17321 / 10 ^ 4) := by ring
          rw [hL2, hR2]
          exact mul_le_mul_of_nonneg_left hsqrt3 (by norm_num : (0 : ℝ) ≤ 1 / 540)
        exact mul_le_mul_of_nonneg_right h54 (mul_nonneg (norm_nonneg _)
            (Real.rpow_nonneg (st_n4pos t ht).le (-5 / 2 : ℝ)))
    _ ≤ ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
        have hpre : 0 ≤ ((17321 / 10 ^ 4) / 540) * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
          apply mul_nonneg
          · apply div_nonneg <;> norm_num
          · exact Real.rpow_nonneg (st_n4pos t ht).le (-5 / 2 : ℝ)
        have hstep : H3 * (((17321 / 10 ^ 4) / 540) * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) ≤
            (t + 3) ^ 3 * (((17321 / 10 ^ 4) / 540) * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) :=
          mul_le_mul_of_nonneg_right hs3 hpre
        calc ((17321 / 10 ^ 4) / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ)
            = H3 * (((17321 / 10 ^ 4) / 540) * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) := by ring
          _ ≤ (t + 3) ^ 3 * (((17321 / 10 ^ 4) / 540) * (n4 t : ℝ) ^ (-5 / 2 : ℝ)) := hstep
          _ = ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by ring
    _ ≤ ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) := by
        have hpre : 0 ≤ (t + 3) ^ 3 * ((17321 / 10 ^ 4) / 540) := by
          apply mul_nonneg
          · exact pow_nonneg (by nlinarith [le_of_lt ht0]) 3
          · apply div_nonneg <;> norm_num
        have hstep : (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) * ((17321 / 10 ^ 4) / 540) ≤
            (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) * ((17321 / 10 ^ 4) / 540) :=
          calc (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) * ((17321 / 10 ^ 4) / 540)
              = (n4 t : ℝ) ^ (-5 / 2 : ℝ) * ((t + 3) ^ 3 * ((17321 / 10 ^ 4) / 540)) := by ring
                _ ≤ (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) *
                    ((t + 3) ^ 3 * ((17321 / 10 ^ 4) / 540)) :=
                    mul_le_mul_of_nonneg_right hmono hpre
                _ = (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) *
                    ((17321 / 10 ^ 4) / 540) := by ring
        calc ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ)
            = (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) * ((17321 / 10 ^ 4) / 540) := by ring
          _ ≤ (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) *
              ((17321 / 10 ^ 4) / 540) := hstep
          _ = ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) := by ring
    _ = ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
        ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by rw [hsplit]
    _ ≤ ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
        ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by
        have hpre : 0 ≤ (17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by
          apply mul_nonneg
          · apply div_nonneg <;> norm_num
          · apply mul_nonneg
            · exact Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) (-5 / 2 : ℝ)
            · exact Real.rpow_nonneg ht0.le (-10 : ℝ)
        have hstep : ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
            ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) ≤
            ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
            ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by
          have hstep2 : (t + 3) ^ 3 *
              ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) ≤
              ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
              ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) :=
            mul_le_mul_of_nonneg_right ht3 hpre
          calc ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
                  ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))
              = (t + 3) ^ 3 *
                  ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) := by ring
                _ ≤ ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
                    ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) := hstep2
                _ = ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
                    ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by ring
        exact hstep
    _ = ((17321 / 10 ^ 4) / 540) * (31000000 : ℝ) ^ (-5 / 2 : ℝ) * (1003 / 1000 : ℝ) ^ 3 *
        ((t : ℝ) ^ 3 * t ^ (-10 : ℝ)) := by ring
    _ = ((17321 / 10 ^ 4) / 540) * (31000000 : ℝ) ^ (-5 / 2 : ℝ) * (1003 / 1000 : ℝ) ^ 3 *
        (t : ℝ) ^ (-7 : ℝ) := by
        rw [ht7]
      _ ≤ A3 * t ^ (-7 : ℝ) :=
          mul_le_mul_of_nonneg_right hA3raw (Real.rpow_nonneg ht0.le (-7 : ℝ))


/-- (W) p8_B(t, n4 t) ≤ A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷. -/
theorem st_hW (t : ℝ) (ht : 1000 ≤ t) :
    p8_B t (n4 t) ≤ A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) := by
  dsimp only [p8_B]
  nlinarith [st_W1 t ht, st_W2 t ht, st_W3 t ht]

/- — §4: mown floor — F4·t⁻² ≤ mown(t,d); — §5: M-term chain + final squeeze.
    Certified chains: scripts/rh/day028_25af_constants.py [5] and the M-chain [4]. — -/

/-- (F4a) floor: F4·t⁻² ≤ mown(t, d) for d ≥ 1/200, t ≥ 1000. -/
theorem st_mownfloor (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hdl : (1 / 200 : ℝ) ≤ d)
    (hd : d ≤ 1 / 2) :
    F4 * t ^ (-2 : ℝ) ≤ S4O.mown t d := by
  have ht0 : 0 < t := st_tpos t ht
  have hscale : (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 ≤ S4O.mown t d :=
    S4O.hMownScaleLo t d ht0 hd0 hd
  have hd2 : (4 : ℝ) * (1 / 200) ^ 2 ≤ 4 * d ^ 2 := by
    have hsq : (1 / 200 : ℝ) ^ 2 ≤ d ^ 2 :=
      (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 1 / 200) (le_of_lt hd0)).mpr hdl
    exact mul_le_mul_of_nonneg_left hsq (by norm_num : (0 : ℝ) ≤ 4)
  have hstep1 : (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 ≤ 4 * d ^ 2 / t ^ 2 := by
    rw [div_le_div_iff₀ (pow_pos ht0 2) (pow_pos ht0 2)]
    exact mul_le_mul_of_nonneg_right hd2 (pow_nonneg ht0.le 2)
  have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
  have hfrac : (1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1) ≤ t ^ 2 / (t ^ 2 + 1) := by
    rw [div_le_div_iff₀ (by nlinarith : (0 : ℝ) < (1000 : ℝ) ^ 2 + 1)
        (by nlinarith : (0 : ℝ) < t ^ 2 + 1)]
    nlinarith [ht2]
  have hfrac2 : ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 ≤ (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
    have ha : (0 : ℝ) ≤ (1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1) := by
      apply div_nonneg
      · norm_num
      · nlinarith
    exact pow_le_pow_left₀ ha hfrac 2
  have hcombo : (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 *
      ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 ≤
      (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
    calc (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2
        ≤ ((4 * (1 / 200 : ℝ) ^ 2) / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
          have hpre : 0 ≤ (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 := by
            apply div_nonneg
            · norm_num
            · exact pow_nonneg ht0.le 2
          exact mul_le_mul_of_nonneg_left hfrac2 hpre
      _ ≤ (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
        have hv : 0 ≤ (t ^ 2 / (t ^ 2 + 1)) ^ 2 := by
          apply pow_nonneg
          apply div_nonneg
          · exact pow_nonneg ht0.le 2
          · nlinarith
        exact mul_le_mul_of_nonneg_right hstep1 hv
  have hF : F4 * t ^ (-2 : ℝ) =
      (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 := by
    dsimp only [F4]
    have hinv : (t : ℝ) ^ (-2 : ℝ) = 1 / (t : ℝ) ^ 2 := by
      rw [Real.rpow_neg ht0.le 2, show (t : ℝ) ^ (2 : ℝ) = (t ^ 2 : ℝ) from by simp]
      exact (one_div (t ^ 2)).symm
    rw [hinv]
    field_simp [(st_tpos t ht).ne']
    ring
  calc F4 * t ^ (-2 : ℝ)
      = (4 * (1 / 200 : ℝ) ^ 2) / t ^ 2 * ((1000 : ℝ) ^ 2 / ((1000 : ℝ) ^ 2 + 1)) ^ 2 := hF
    _ ≤ (4 * d ^ 2 / t ^ 2) * (t ^ 2 / (t ^ 2 + 1)) ^ 2 := hcombo
    _ ≤ S4O.mown t d := hscale

/-- (Z) final constant: A1 + (A2 + A3 + 25/10¹⁵)/10³ < F4. -/
theorem st_finalconst : A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000 < F4 := by
  dsimp only [A1, A2, A3, F4]
  norm_num

/-- (MT) M-term: M·exp(X4)·X4 ≤ MTUB(t) for M ≤ Zbound(t). -/
theorem st_hMterm (t M : ℝ) (ht : 1000 ≤ t) (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    M * Real.exp (X4fun t) * X4fun t ≤ MTUBfun t := by
  have ht0 : 0 < t := st_tpos t ht
  set L := Real.log t with hLdef
  have hx4 : (0 : ℝ) ≤ X4fun t := st_X4nonneg t ht
  have hx4ub : X4fun t ≤ X4UBfun t := st_X4bound t ht
  have hexp : Real.exp (X4fun t) ≤ 2 := st_eX4le2 t ht
  have hs1 : M * Real.exp (X4fun t) * X4fun t ≤ M * 2 * X4fun t := by
    have hMexp : M * Real.exp (X4fun t) ≤ M * 2 :=
      mul_le_mul_of_nonneg_left hexp hM0
    exact mul_le_mul_of_nonneg_right hMexp hx4
  have hs2 : M * 2 * X4fun t ≤ S4W.Zbound t * 2 * X4fun t := by
    have ht2x : (0 : ℝ) ≤ 2 * X4fun t :=
      mul_nonneg (by norm_num : (0 : ℝ) ≤ 2) hx4
    rw [show (M : ℝ) * 2 * X4fun t = M * (2 * X4fun t) from by ring,
        show (S4W.Zbound t : ℝ) * 2 * X4fun t = S4W.Zbound t * (2 * X4fun t) from by ring]
    exact mul_le_mul_of_nonneg_right hMz ht2x
  have hs3 : S4W.Zbound t * 2 * X4fun t = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t := by
    dsimp only [S4W.Zbound]
    rw [hLdef]
    ring
  have hc4 : (0 : ℝ) ≤ (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L := by
    exact mul_nonneg
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 32 / 10)
        (Real.rpow_nonneg ht0.le (1 / 4 : ℝ)))
      (Real.log_nonneg (by linarith : (1 : ℝ) ≤ t))
  have hs4 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t ≤
      (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t :=
    mul_le_mul_of_nonneg_left hx4ub hc4
  have hs5 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t =
      (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) := by
    dsimp only [X4UBfun]
  have hsumub : (16 / 10 ^ 15 + 35 / 10 ^ 16 * L : ℝ) * L ≤ (62 / 10 ^ 16 : ℝ) * L * L := by
    have hLge : (160 : ℝ) / 27 ≤ L := st_L16027 t ht
    have hL0 : (0 : ℝ) ≤ L := le_trans (by norm_num : (0 : ℝ) ≤ 160 / 27) hLge
    have hcore : (160 : ℝ) * L ≤ (27 : ℝ) * L * L := by
      have h1 : (160 / 27 : ℝ) * L ≤ L * L := mul_le_mul_of_nonneg_right hLge hL0
      calc (160 : ℝ) * L
          = (160 / 27 : ℝ) * L * 27 := by ring
        _ ≤ L * L * 27 := mul_le_mul_of_nonneg_right h1 (by norm_num : (0 : ℝ) ≤ 27)
        _ = (27 : ℝ) * L * L := by ring
    have hswitch : (16 / 10 ^ 15 : ℝ) * L ≤ (27 / 10 ^ 16 : ℝ) * L * L := by
      rw [show (16 / 10 ^ 15 : ℝ) * L = (160 : ℝ) * L / 10 ^ 16 from by ring,
          show (27 / 10 ^ 16 : ℝ) * L * L = (27 : ℝ) * L * L / 10 ^ 16 from by ring]
      rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 10 ^ 16)
          (by norm_num : (0 : ℝ) < 10 ^ 16)]
      exact mul_le_mul_of_nonneg_right hcore (by norm_num : (0 : ℝ) ≤ 10 ^ 16)
    calc (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L
        = (16 / 10 ^ 15) * L + (35 / 10 ^ 16) * L * L := by ring
      _ ≤ (27 / 10 ^ 16) * L * L + (35 / 10 ^ 16) * L * L :=
          add_le_add hswitch le_rfl
      _ = (62 / 10 ^ 16) * L * L := by ring
  have hs7 : (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) ≤
      (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by
    calc (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6)
        = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L *
            ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * t ^ (-6 : ℝ)) := by
          have hinvA : ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L : ℝ) / t ^ 6) =
              (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * (1 / (t : ℝ) ^ 6) := by ring
          rw [hinvA]
          have hinv6 : 1 / (t : ℝ) ^ 6 = (t : ℝ) ^ (-6 : ℝ) := by
            rw [Real.rpow_neg ht0.le 6, show (t : ℝ) ^ (6 : ℝ) = (t ^ 6 : ℝ) from by simp]
            exact one_div (t ^ 6)
          rw [hinv6]
      _ = (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L *
          ((t : ℝ) ^ (1 / 4 : ℝ) * t ^ (-6 : ℝ)) := by ring
      _ = (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L * t ^ (-23 / 4 : ℝ) := by
          have ht23 : (t : ℝ) ^ (1 / 4 : ℝ) * (t : ℝ) ^ (-6 : ℝ) = (t : ℝ) ^ (-23 / 4 : ℝ) := by
            rw [← Real.rpow_add ht0 (1 / 4 : ℝ) (-6 : ℝ)]
            rw [show (1 / 4 : ℝ) + (-6 : ℝ) = (-23 / 4 : ℝ) from by ring]
          rw [ht23]
      _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by
          have hpre : (0 : ℝ) ≤ (32 / 10 : ℝ) * L * t ^ (-23 / 4 : ℝ) :=
            mul_nonneg
              (mul_nonneg (by norm_num : (0 : ℝ) ≤ 32 / 10)
                (Real.log_nonneg (by linarith : (1 : ℝ) ≤ t)))
              (Real.rpow_nonneg ht0.le (-23 / 4 : ℝ))
          calc (32 / 10 : ℝ) * (16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L * t ^ (-23 / 4 : ℝ)
              = (32 / 10 : ℝ) * t ^ (-23 / 4 : ℝ) * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) * L) := by ring
                _ ≤ (32 / 10 : ℝ) * t ^ (-23 / 4 : ℝ) * ((62 / 10 ^ 16 : ℝ) * L * L) :=
                    mul_le_mul_of_nonneg_left hsumub
                      (mul_nonneg (by norm_num : (0 : ℝ) ≤ 32 / 10)
                        (Real.rpow_nonneg ht0.le (-23 / 4 : ℝ)))
                _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := by ring
  have hs8 : (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) ≤
      (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := by
    have hL2 : L * L ≤ (t : ℝ) := by
      have h1 : L * L = (Real.log t) ^ 2 := by
        calc L * L
            = (Real.log t) * L := by rw [hLdef]
          _ = (Real.log t) * (Real.log t) := by rw [hLdef]
          _ = (Real.log t) ^ 2 := by rw [pow_two]
      rw [h1]
      exact st_L2le_t t ht
    have hpre : (0 : ℝ) ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) :=
      mul_nonneg
        (mul_nonneg (by norm_num : (0 : ℝ) ≤ 32 / 10)
          (by norm_num : (0 : ℝ) ≤ 62 / 10 ^ 16))
        (Real.rpow_nonneg ht0.le (-23 / 4 : ℝ))
    calc (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ)
        = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) * (L * L) := by ring
      _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-23 / 4 : ℝ) * t :=
          mul_le_mul_of_nonneg_left hL2 hpre
      _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := by ring
  have hcore19 : t * t ^ (-23 / 4 : ℝ) = t ^ (-19 / 4 : ℝ) := by
    rw [show (t : ℝ) * (t : ℝ) ^ (-23 / 4 : ℝ) = (t : ℝ) ^ (1 : ℝ) * (t : ℝ) ^ (-23 / 4 : ℝ) from
        (congrArg (fun (x : ℝ) => x * (t : ℝ) ^ (-23 / 4 : ℝ)) (Real.rpow_one t).symm)]
    rw [← Real.rpow_add ht0 (1 : ℝ) (-23 / 4 : ℝ)]
    rw [show (1 : ℝ) + (-23 / 4 : ℝ) = (-19 / 4 : ℝ) from by ring]
  have ht19 : (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) =
      (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-19 / 4 : ℝ) := by
    calc (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ)
        = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * (t * t ^ (-23 / 4 : ℝ)) := by ring
          _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-19 / 4 : ℝ) := by rw [hcore19]
  calc M * Real.exp (X4fun t) * X4fun t
      ≤ M * 2 * X4fun t := hs1
    _ ≤ S4W.Zbound t * 2 * X4fun t := hs2
    _ = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4fun t := by rw [hs3]
    _ ≤ (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * X4UBfun t := hs4
    _ = (32 / 10 : ℝ) * t ^ (1 / 4 : ℝ) * L * ((16 / 10 ^ 15 + 35 / 10 ^ 16 * L) / t ^ 6) := by rw [hs5]
    _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * L * L * t ^ (-23 / 4 : ℝ) := hs7
    _ ≤ (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t * t ^ (-23 / 4 : ℝ) := hs8
    _ = (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) * t ^ (-19 / 4 : ℝ) := by rw [ht19]
    _ ≤ (25 / 10 ^ 15 : ℝ) * t ^ (-19 / 4 : ℝ) :=
        mul_le_mul_of_nonneg_right (by norm_num : (32 / 10 : ℝ) * (62 / 10 ^ 16 : ℝ) ≤ 25 / 10 ^ 15)
          (Real.rpow_nonneg ht0.le (-19 / 4 : ℝ))
    _ = MTUBfun t := by
      dsimp only [MTUBfun]
      have hinv : (t : ℝ) ^ (-19 / 4 : ℝ) = 1 / t ^ (19 / 4 : ℝ) := by
        rw [show (t : ℝ) ^ (-19 / 4 : ℝ) = (t : ℝ) ^ (-(19 / 4 : ℝ)) from by
              congr 1
              norm_num]
        rw [Real.rpow_neg ht0.le (19 / 4 : ℝ)]
        exact (one_div (t ^ (19 / 4 : ℝ))).symm
      rw [hinv]
      ring
/-- (S) W+M cap at the strip: p8_B + M-term ≤ [A1+(A2+A3+25/10¹⁵)/10³]·t⁻². -/
theorem st_hSQ (t M : ℝ) (ht : 1000 ≤ t) (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t ≤
        (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hW := st_hW t ht
  have hM := st_hMterm t M ht hM0 hMz
  -- C·t^(-k) ≤ C·10⁻³·t⁻² for C ≥ 0, k ≥ 3, t ≥ 1000
  have hterm (C : ℝ) (k : ℝ) (hC : 0 ≤ C) (hk3 : (3 : ℝ) ≤ k) :
      C * t ^ (-k) ≤ C / 1000 * t ^ (-2 : ℝ) := by
    have hpow : t ^ (-k) ≤ t ^ (-3 : ℝ) :=
      Real.rpow_le_rpow_of_exponent_le (by linarith : (1 : ℝ) ≤ t) (by linarith : -k ≤ -3)
    have hA : C * t ^ (-k) ≤ C * t ^ (-3 : ℝ) := mul_le_mul_of_nonneg_left hpow hC
    have hinv1 : t ^ (-1 : ℝ) ≤ 1 / 1000 := by
      rw [show (t : ℝ) ^ (-1 : ℝ) = 1 / t from by
        rw [Real.rpow_neg ht0.le 1, Real.rpow_one, ← one_div]]
      rw [one_div_le_one_div ht0 (by norm_num : (0 : ℝ) < 1000)]
      linarith
    have hB : C * t ^ (-3 : ℝ) ≤ C / 1000 * t ^ (-2 : ℝ) := by
      calc C * t ^ (-3 : ℝ)
          = C * (t ^ (-2 : ℝ) * t ^ (-1 : ℝ)) := by
            have heq : (t : ℝ) ^ (-2 : ℝ) * (t : ℝ) ^ (-1 : ℝ) = (t : ℝ) ^ (-3 : ℝ) := by
              rw [← Real.rpow_add ht0 (-2 : ℝ) (-1 : ℝ)]
              rw [show (t : ℝ) ^ ((-2 : ℝ) + (-1 : ℝ)) = (t : ℝ) ^ (-3 : ℝ) from by
                    ring]
            rw [← heq]
          _ ≤ C * (t ^ (-2 : ℝ) * (1 / 1000)) := by
            have hstep : t ^ (-2 : ℝ) * t ^ (-1 : ℝ) ≤ t ^ (-2 : ℝ) * (1 / 1000) :=
              mul_le_mul_of_nonneg_left hinv1 (Real.rpow_nonneg ht0.le (-2 : ℝ))
            exact mul_le_mul_of_nonneg_left hstep hC
          _ = C / 1000 * t ^ (-2 : ℝ) := by ring
    calc C * t ^ (-k)
        ≤ C * t ^ (-3 : ℝ) := hA
      _ ≤ C / 1000 * t ^ (-2 : ℝ) := hB
  have hA2c := hterm A2 (5 : ℝ) (by dsimp only [A2]; norm_num) (by norm_num)
  have hA3c := hterm A3 (7 : ℝ) (by dsimp only [A3]; norm_num) (by norm_num)
  have hMc := hterm (25 / 10 ^ 15) (19 / 4 : ℝ) (by norm_num) (by norm_num)
  have hmt : MTUBfun t = (25 / 10 ^ 15 : ℝ) * t ^ (-(19 / 4 : ℝ)) := by
    dsimp only [MTUBfun]
    have hinv : (t : ℝ) ^ (-(19 / 4 : ℝ)) = 1 / t ^ (19 / 4 : ℝ) := by
      rw [Real.rpow_neg ht0.le (19 / 4 : ℝ)]
      exact (one_div (t ^ (19 / 4 : ℝ))).symm
    rw [hinv]
    ring
  have hMtc : MTUBfun t ≤ 25 / 10 ^ 15 / 1000 * t ^ (-2 : ℝ) := by
    rw [hmt]
    exact hMc
  have hWcap : A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) ≤
      (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) := by
    nlinarith [hA2c, hA3c]
  calc p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t
      ≤ A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) + MTUBfun t := by
        nlinarith [hW, hM]
    _ ≤ (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) + MTUBfun t := add_le_add hWcap le_rfl
    _ ≤ (A1 + (A2 + A3) / 1000) * t ^ (-2 : ℝ) + 25 / 10 ^ 15 / 1000 *
        t ^ (-2 : ℝ) := add_le_add le_rfl hMtc
    _ = (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := by ring


/- — THE (i-b) STRIP CLOSURE (bound level, 25af). — -/

/-- THE 25af OWN-REGIME STRIP CLOSURE. For 1000 ≤ t, 1/200 ≤ d ≤ 1/2, M ∈ [0, Zbound(t)]:
    p8_B(t, n4 t) + M·exp(X4(t))·X4(t) < mown(t, d). -/
theorem s4_strip_close (t d M : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hdl : (1 / 200 : ℝ) ≤ d) (hd : d ≤ 1 / 2)
    (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t < S4O.mown t d := by
  have hfloor : F4 * t ^ (-2 : ℝ) ≤ S4O.mown t d := st_mownfloor t d ht hd0 hdl hd
  have hsqe : p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t ≤
      (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := st_hSQ t M ht hM0 hMz
  have htin2 : 0 < t ^ (-2 : ℝ) := Real.rpow_pos_of_pos (st_tpos t ht) (-2 : ℝ)
  have hstrict : (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) <
      F4 * t ^ (-2 : ℝ) :=
    mul_lt_mul_of_pos_right st_finalconst htin2
  have h1 : p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t < F4 * t ^ (-2 : ℝ) :=
    lt_of_le_of_lt hsqe hstrict
  exact lt_of_lt_of_le h1 hfloor

/- =================================================================
   §6  day033 — sharper d-dependent floor (item 6 = 25af residual (3))
   =================================================================

Numerical source of truth (exact rational algebra; every identity in
this section machine-verified over an exact Fraction grid by
scripts/rh/day033_dfloor.py, out_day033_dfloor.txt):
  edge d_F in [0.0047384080, 0.0047384081]; working edge
  r2' = 47384091/10^10 = 0.0047384091 with the EXACT margin
  A1 + (A2+A3+25/10^15)/1000 < FshU (r2'^2) (rel. 4.26e-7).

Structure (no derivatives; pure positive-term decompositions only):
  mown(t, d) = u(u+4v) / AB(v) · e^{c(t,d)},   u = d^2, v = t^2,
  AB(v) = v^2 + (2u+1/2)·v + (1/4-u)^2,  c = Cown >= 0 for d <= 1/2,
  and the ratio part v·(u+4v)/AB(v) is increasing in v >= 10^6 because
  N(v) := v(u+4v)·Dstar - X·AB(v)
         = Aco·(v-10^6)^2 + Bsh·(v-10^6)
  with Aco > 0 and Bsh > 0 (positive-term decompositions, st_Nshift,
  hAco_pos, hBsh_pos here).
   ================================================================= -/

/-- day033 sharp floor edge: r2' = 47384091/10^10 = 0.0047384091, a
    strict 10-decimal rational just ABOVE the exact squeeze edge d_F
    (certified d_F in [0.0047384080, 0.0047384081]). -/
noncomputable def r2prime : ℝ := (47384091 : ℝ) / 10000000000

/-- day033 sharp floor in u = d^2: the value of t^2·mown(t, d) with the
    e^c factor dropped, at t = 1000; a valid floor for all t >= 1000
    (st_mownfloor_sharp). -/
noncomputable def FshU (u : ℝ) : ℝ :=
    1000000 * u * (u + 4000000) /
      (1000000000000 + 2000000 * u + 500000 + ((1 / 4 : ℝ) - u) ^ 2)

/-- day033 sharp floor in d: Fsh d = FshU (d^2). -/
noncomputable def Fsh (d : ℝ) : ℝ := FshU (d ^ 2)

/-- day033: r2prime is a positive rational. -/
theorem hr2prime_pos : 0 < r2prime := by
  dsimp only [r2prime]
  exact div_pos (by norm_num : (0 : ℝ) < 47384091)
      (by norm_num : (0 : ℝ) < 10000000000)

/-! day033 SHARP FLOOR: for all 1000 ≤ t, 0 < d ≤ 1/2,
    FshU (d^2) * t^-2 ≤ mown(t, d).
    mown(t, d) = u(u+4v)/AB(v)·e^c (u = d^2, v = t^2, e^c = e^{Cown} ≥ 1);
    after cancelling the common factor u > 0 the floor cross-multiplies to
    N4(v) := v(u+4v)·Dstar - Xf·(v^2 + (2u+1/2)·v + (1/4-u)^2) ≥ 0,
    Xf := 10^6·(u + 4·10^6), which factors as
    N4(v) = Aco·(v-10^6)^2 + Bsh·(v-10^6) with
    Aco = 4(1/4-u)^2 + 7·10^6·u + 2·10^6 > 0 and Bsh > 0 on 0 < u ≤ 1/4
    (all exact, day033).  Replaces the d ≥ 1/200 use of F4 on the whole
    strip 0 < d ≤ 1/2; the old F4 line st_mownfloor is unchanged. -/
set_option maxHeartbeats 1600000
theorem st_mownfloor_sharp (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hd : d ≤ 1 / 2) : Fsh (d) * t ^ (-2 : ℝ) ≤ S4O.mown t d := by
  have htpos : 0 < t := st_tpos t ht
  set u := d ^ 2 with hu
  set v := t ^ 2 with hv
  have huv : 0 < u := sq_pos_of_pos hd0
  have huvN : 0 ≤ u := huv.le
  have hud : u ≤ 1 / 4 := by
    rw [hu]
    have hq : d ^ 2 ≤ (1 / 2) ^ 2 :=
      (sq_le_sq₀ hd0.le (by norm_num : (0 : ℝ) ≤ 1 / 2)).mpr hd
    rw [show (1 / 2 : ℝ) ^ 2 = 1 / 4 from by norm_num] at hq
    exact hq
  have hvpos : 0 < v := by rw [hv]; exact pow_pos htpos 2
  have hAb : S4O.Aown t d * S4O.Bown t d =
      v ^ 2 + (2 * u + 1 / 2) * v + ((1 / 4 : ℝ) - u) ^ 2 := by
    dsimp only [S4O.Aown, S4O.Bown, u, v]
    ring
  have hApos : 0 < S4O.Aown t d := by
    dsimp only [S4O.Aown]
    nlinarith [pow_pos htpos 2]
  have hBpos : 0 < S4O.Bown t d := by
    dsimp only [S4O.Bown]
    nlinarith [pow_pos htpos 2]
  have hc : 0 ≤ S4O.Cown t d := by
    dsimp only [S4O.Cown]
    have h1 : 0 ≤ (1 / 2 + d) / S4O.Aown t d :=
      div_nonneg (by nlinarith [hd0.le]) hApos.le
    have h2 : 0 ≤ (1 / 2 - d) / S4O.Bown t d :=
      div_nonneg (by nlinarith [hd]) hBpos.le
    exact add_nonneg h1 h2
  have hexp : 1 ≤ Real.exp (S4O.Cown t d) := one_le_exp hc
  have hmown : S4O.mown t d =
      u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d) *
        Real.exp (S4O.Cown t d) := by
    dsimp only [S4O.mown, S4O.Aown, S4O.Bown, S4O.Cown, u, v]
  set Dstar := 1000000000000 + 2000000 * u + 500000 +
      ((1 / 4 : ℝ) - u) ^ 2 with hDs
  have hDpos : 0 < Dstar := by
    dsimp only [Dstar]
    have h1 : 0 ≤ 1000000000000 := by norm_num
    have h2 : 0 ≤ 2000000 * u :=
      mul_nonneg (by norm_num : (0 : ℝ) ≤ 2000000) huvN
    have h3 : 0 ≤ 500000 := by norm_num
    have h4 : 0 ≤ ((1 / 4 : ℝ) - u) ^ 2 := sq_nonneg ((1 / 4 : ℝ) - u)
    linarith [h1, h2, h3, h4]
  have hABpos : 0 < S4O.Aown t d * S4O.Bown t d := mul_pos hApos hBpos
  set Xf := 1000000 * u + 4000000000000 with hXd
  have hFshU : FshU u = u * Xf / Dstar := by
    dsimp only [FshU, Xf, Dstar]
    ring
  have hFsh_eq : Fsh (d) = FshU u := by
    dsimp only [Fsh, u]
  have hvlo : (10 : ℝ) ^ 6 ≤ v := by
    rw [hv]
    have h1 : 1000 ^ 2 ≤ t ^ 2 :=
      pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
    rw [show (10 : ℝ) ^ 6 = 1000 ^ 2 from by norm_num]
    exact h1
  have hs : 0 ≤ v - (10 : ℝ) ^ 6 := sub_nonneg.mpr hvlo
  set Aco := 4 * ((1 / 4 : ℝ) - u) ^ 2 + 7000000 * u + 2000000 with hAcod
  have hAco_pos : 0 < Aco := by
    dsimp only [Aco]
    have h1 : 0 ≤ 4 * ((1 / 4 : ℝ) - u) ^ 2 := by
      linarith [sq_nonneg ((1 / 4 : ℝ) - u)]
    have h2 : 0 ≤ 7000000 * u :=
      mul_nonneg (by norm_num : (0 : ℝ) ≤ 7000000) huvN
    have h3 : (0 : ℝ) < 2000000 := by norm_num
    linarith [h1, h2, h3]
  set Bsh := u * Dstar - Xf * (2 * u + 1 / 2) + 2000000 * Aco with hBshd
  have hBsh_exp : Bsh = 2000000000000 + u * (6000000000000 - 500000 - 2000000 * u) +
      8000000 * ((1 / 4 : ℝ) - u) ^ 2 + u * Dstar := by
    dsimp only [Bsh, Aco, Xf]
    ring
  have hBsh_pos : 0 < Bsh := by
    have hb : 2000000 * u ≤ 2000000 * (1 / 4) :=
      mul_le_mul_of_nonneg_left hud (by norm_num : (0 : ℝ) ≤ 2000000)
    have h1 : 0 < 6000000000000 - 500000 - 2000000 * u := by
      nlinarith [hb, show (2000000 : ℝ) * (1 / 4) = 500000 from by norm_num,
        show (0 : ℝ) < 6000000000000 - 500000 - 500000 from by norm_num]
    have h2 : 0 < u * (6000000000000 - 500000 - 2000000 * u) :=
      mul_pos huv h1
    have h3 : 0 ≤ 8000000 * ((1 / 4 : ℝ) - u) ^ 2 := by
      linarith [sq_nonneg ((1 / 4 : ℝ) - u)]
    have h4 : 0 < u * Dstar := mul_pos huv hDpos
    have h5 : (0 : ℝ) < 2000000000000 := by norm_num
    rw [hBsh_exp]
    nlinarith [h5, h2, h3, h4]
  have hNshift : v * (u + 4 * v) * Dstar -
      Xf * (v ^ 2 + (2 * u + 1 / 2) * v + ((1 / 4 : ℝ) - u) ^ 2) =
      Aco * (v - 1000000) ^ 2 + Bsh * (v - 1000000) := by
    dsimp only [Aco, Bsh, Dstar, Xf]
    ring
  have hNn : 0 ≤ u * (v * (u + 4 * v) * Dstar -
      Xf * (v ^ 2 + (2 * u + 1 / 2) * v + ((1 / 4 : ℝ) - u) ^ 2)) := by
    rw [hNshift]
    have h1 : 0 ≤ u * Aco * (v - 1000000) ^ 2 := by
      have h12 : 0 ≤ u * Aco := mul_nonneg huvN hAco_pos.le
      exact mul_nonneg h12 (sq_nonneg (v - 1000000))
    have h2 : 0 ≤ u * Bsh * (v - 1000000) := by
      have h21 : 0 ≤ u * Bsh := mul_nonneg huvN (le_of_lt hBsh_pos)
      exact mul_nonneg h21 (by
        have hs0 : 0 ≤ v - 1000000 := by
          have hv0 : (10 : ℝ) ^ 6 = 1000000 := by norm_num
          rw [hv0] at hs
          exact hs
        exact hs0)
    ring_nf at h1 h2 ⊢
    linarith [h1, h2]
  have h2 : t ^ (2 : ℝ) = t ^ 2 := by norm_num
  have ht1 : (t : ℝ) ^ (-2 : ℝ) = 1 / t ^ 2 := by
    rw [Real.rpow_neg htpos.le (2 : ℝ), inv_eq_one_div, h2]
  have htinv : (t : ℝ) ^ (-2 : ℝ) = 1 / v := by
    rw [ht1, hv]
  have hnum : 0 ≤ u * (u + 4 * v) :=
    mul_nonneg huv.le (by nlinarith [huvN, hvpos.le])
  calc Fsh (d) * t ^ (-2 : ℝ)
      = FshU u * (t ^ (-2 : ℝ)) := by rw [hFsh_eq]
    _ = FshU u / v := by
      rw [htinv, hFshU]
      ring
    _ ≤ u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d) := by
      rw [hFshU, div_div]
      exact (div_le_div_iff₀ (mul_pos hDpos hvpos) hABpos).2 (by
        rw [hAb]
        ring_nf at hNn ⊢
        linarith [hNn])
    _ = 1 * (u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d)) := by ring
    _ ≤ Real.exp (S4O.Cown t d) *
        (u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d)) := by
      have hW0b : 0 ≤ u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d) :=
        div_nonneg hnum hABpos.le
      exact mul_le_mul_of_nonneg_right hexp hW0b
    _ = (u * (u + 4 * v) / (S4O.Aown t d * S4O.Bown t d)) *
        Real.exp (S4O.Cown t d) := by ring
    _ = S4O.mown t d := by
      dsimp only [S4O.mown]


set_option maxHeartbeats 200000
set_option maxHeartbeats 1600000
/-- day033: FshU INCREASING in u on 0 < u ≤ 1/4.
    Nsh(u) := 10^6 u^2 + 4·10^12 u (the FshU numerator), Dstar(u) as
    above:  Nsh(u2)·Dstar(u1) - Nsh(u1)·Dstar(u2) = (u2 - u1)·Q with Q
    positive (the negative cross term is bounded by u1·u2 ≤ 1/16;
    day033-verified exactly). -/
theorem st_Fsh_mono (u1 u2 : ℝ) (hu1 : 0 < u1) (h : u1 ≤ u2)
    (hu2 : u2 ≤ 1 / 4) : FshU u1 ≤ FshU u2 := by
  set K := (1000000000000 : ℝ) + 500000 + 1 / 16 with hKd
  have hKpos : 0 < K := by
    dsimp only [K]
    norm_num
  set Nsh1 := 1000000 * u1 ^ 2 + 4000000000000 * u1 with hN1d
  set Nsh2 := 1000000 * u2 ^ 2 + 4000000000000 * u2 with hN2d
  set D1 := u1 ^ 2 + ((3999999 : ℝ) / 2) * u1 + K with hD1d
  set D2 := u2 ^ 2 + ((3999999 : ℝ) / 2) * u2 + K with hD2d
  have hD1pos : 0 < D1 := by
    dsimp only [D1]
    nlinarith [hu1.le, hKpos.le, show (0 : ℝ) ≤ u1 ^ 2 from by
      nlinarith [sq_nonneg u1]]
  have hD2pos : 0 < D2 := by
    have huu2 : 0 ≤ u2 := by linarith
    dsimp only [D2]
    nlinarith [huu2, hKpos.le, show (0 : ℝ) ≤ u2 ^ 2 from by
      nlinarith [sq_nonneg u2]]
  have hden1 : 1000000000000 + 2000000 * u1 + 500000 + ((1 / 4 : ℝ) - u1) ^ 2 =
      D1 := by
    dsimp only [D1, K]
    ring
  have hnum1 : 1000000 * u1 * (u1 + 4000000) = Nsh1 := by
    ring
  have hN1eq : FshU u1 = Nsh1 / D1 := by
    dsimp only [FshU]
    rw [hden1, hnum1]
  have hden2 : 1000000000000 + 2000000 * u2 + 500000 + ((1 / 4 : ℝ) - u2) ^ 2 =
      D2 := by
    dsimp only [D2, K]
    ring
  have hnum2 : 1000000 * u2 * (u2 + 4000000) = Nsh2 := by
    ring
  have hN2eq : FshU u2 = Nsh2 / D2 := by
    dsimp only [FshU]
    rw [hden2, hnum2]
  have hQ : Nsh2 * D1 - Nsh1 * D2 =
      (u2 - u1) * (1000000 * K * (u1 + u2) + 4000000000000 * K +
        u1 * u2 * (-(2000000000000 + 500000))) := by
    dsimp only [Nsh1, Nsh2, D1, D2, K]
    ring
  set Dneg := (2000000000000 : ℝ) + 500000 with hDneld
  have hcoeq : 1000000 * ((3999999 : ℝ) / 2) - 4000000000000 = -Dneg := by
    dsimp only [Dneg]
    ring
  have huu2 : 0 ≤ u2 := by linarith
  have huu : u1 * u2 ≤ 1 / 16 := by
    have h1 : u1 * u2 ≤ u2 * u2 := mul_le_mul_of_nonneg_right h huu2
    have hq : u2 ^ 2 ≤ (1 / 4 : ℝ) ^ 2 :=
      (sq_le_sq₀ huu2 (by norm_num : (0 : ℝ) ≤ 1 / 4)).mpr hu2
    ring_nf at hq ⊢
    linarith [h1, hq]
  have hneg : u1 * u2 * (-Dneg) ≥ (1 / 16 : ℝ) * (-Dneg) := by
    dsimp only [Dneg]
    have hprod : 0 ≤ ((1 / 16 : ℝ) - u1 * u2) * Dneg := by
      dsimp only [Dneg]
      have huu0 : 0 ≤ (1 / 16 : ℝ) - u1 * u2 := by
        rw [sub_nonneg]
        exact huu
      exact mul_nonneg huu0 (by norm_num :
        (0 : ℝ) ≤ 2000000000000 + 500000)
    have hb : u1 * u2 * Dneg ≤ (1 / 16 : ℝ) * Dneg := by
      rw [← sub_nonneg]
      ring_nf at hprod ⊢
      linarith [hprod]
    have hgoal_l : u1 * u2 * (-(2000000000000 + 500000)) =
        -(u1 * u2 * (2000000000000 + 500000)) := by ring
    have hgoal_r : (1 / 16 : ℝ) * (-(2000000000000 + 500000)) =
        -((1 / 16 : ℝ) * (2000000000000 + 500000)) := by ring
    rw [hgoal_l, hgoal_r]
    exact neg_le_neg hb
  have hQpos : 0 < 1000000 * K * (u1 + u2) + 4000000000000 * K +
      u1 * u2 * (-(2000000000000 + 500000)) := by
    have hT1 : 0 ≤ 1000000 * K * (u1 + u2) := by
      have h1 : 0 ≤ 1000000 * K := mul_nonneg (by norm_num : (0 : ℝ) ≤ 1000000) hKpos.le
      have h2 : 0 ≤ u1 + u2 := add_nonneg hu1.le huu2
      exact mul_nonneg h1 h2
    have hmid : (4000000000000 : ℝ) * K - (1 / 16 : ℝ) * Dneg > 0 := by
      dsimp only [K, Dneg]
      norm_num
    dsimp only [Dneg] at hneg
    calc 1000000 * K * (u1 + u2) + 4000000000000 * K +
        u1 * u2 * (-(2000000000000 + 500000))
      ≥ 0 + 4000000000000 * K + (1 / 16 : ℝ) * (-(2000000000000 + 500000)) :=
        by ring_nf at hT1 hneg ⊢; linarith [hT1, hneg]
      _ = 4000000000000 * K - (1 / 16 : ℝ) * Dneg := by
        dsimp only [Dneg]
        ring
      _ = 4000000000000 * K - (1 / 16 : ℝ) * (2000000000000 + 500000) := by
        dsimp only [Dneg]
      _ > 0 := by
        dsimp only [Dneg] at hmid
        exact hmid
  have hnumnn : 0 ≤ Nsh2 * D1 - Nsh1 * D2 := by
    rw [hQ]
    have h21 : 0 ≤ u2 - u1 := by linarith
    exact mul_nonneg h21 (le_of_lt hQpos)
  have hsubnn : 0 ≤ Nsh2 / D2 - Nsh1 / D1 := by
    field_simp [hD1pos.ne', hD2pos.ne']
    ring_nf at hnumnn ⊢
    linarith [hnumnn]
  calc FshU u1
      = Nsh1 / D1 := hN1eq
    _ ≤ Nsh2 / D2 := by linarith [hsubnn]
    _ = FshU u2 := by rw [hN2eq]

set_option maxHeartbeats 200000
/-- day033 EXACT MARGIN (norm_num on exact rationals):
    A1 + (A2 + A3 + 25/10^15)/1000 < FshU (r2prime^2).
    The strict line of the sharp squeeze; the exact Fraction margin
    computed by day033 is +3.8287e-11 (rel. 4.26e-7). -/
theorem st_hfinal_sharp :
    (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000 : ℝ) < FshU (r2prime ^ 2) := by
  dsimp only [A1, A2, A3, FshU, r2prime]
  field_simp
  norm_num

/-- THE day033 SHARP STRIP CLOSURE (item 6 port): for 1000 ≤ t,
    r2' ≤ d ≤ 1/2, 0 ≤ M ≤ Zbound(t):
    p8_B(t, n4 t) + M·exp(X4(t))·X4(t) < mown(t, d).
    The d-edge is the certified exact rational r2' = 47384091/10^10
    (5.23% below the old 1/200 edge, day033[10]).  The old
    s4_strip_close above is unchanged: on d ≥ 1/200 both statements
    hold; the new one covers the extra band (r2', 1/200). -/
theorem s4_strip_close_sharp (t d M : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hdl : r2prime ≤ d) (hd : d ≤ 1 / 2)
    (hM0 : 0 ≤ M) (hMz : M ≤ S4W.Zbound t) :
    p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t < S4O.mown t d := by
  have hsqe : p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t ≤
      (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) :=
    st_hSQ t M ht hM0 hMz
  have htin2 : 0 < t ^ (-2 : ℝ) :=
    Real.rpow_pos_of_pos (st_tpos t ht) (-2 : ℝ)
  have hstrict : (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) <
      FshU (r2prime ^ 2) * t ^ (-2 : ℝ) :=
    mul_lt_mul_of_pos_right st_hfinal_sharp htin2
  have hrp_pos : 0 < r2prime := by
    dsimp only [r2prime]
    exact div_pos (by norm_num : (0 : ℝ) < 47384091)
      (by norm_num : (0 : ℝ) < 10000000000)
  have hd2 : r2prime ^ 2 ≤ d ^ 2 :=
    (sq_le_sq₀ hrp_pos.le hd0.le).mpr hdl
  have hd2q : d ^ 2 ≤ 1 / 4 := by
    have hq : d ^ 2 ≤ (1 / 2) ^ 2 :=
      (sq_le_sq₀ hd0.le (by norm_num : (0 : ℝ) ≤ 1 / 2)).mpr hd
    rw [show (1 / 2 : ℝ) ^ 2 = 1 / 4 from by norm_num] at hq
    exact hq
  have hFmono : FshU (r2prime ^ 2) ≤ FshU (d ^ 2) :=
    st_Fsh_mono (r2prime ^ 2) (d ^ 2) (sq_pos_of_pos hrp_pos) hd2 hd2q
  have hfloor : FshU (d ^ 2) * t ^ (-2 : ℝ) ≤ S4O.mown t d :=
    st_mownfloor_sharp t d ht hd0 hd
  calc p8_B t (n4 t) + M * Real.exp (X4fun t) * X4fun t
      ≤ (A1 + (A2 + A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := hsqe
    _ < FshU (r2prime ^ 2) * t ^ (-2 : ℝ) := hstrict
    _ ≤ FshU (d ^ 2) * t ^ (-2 : ℝ) :=
      mul_le_mul_of_nonneg_right hFmono htin2.le
    _ ≤ S4O.mown t d := hfloor
