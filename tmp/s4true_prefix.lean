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

