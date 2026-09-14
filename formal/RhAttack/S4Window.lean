import Mathlib
import RhAttack.B0
import RhAttack.B3Core
import RhAttack.P8Floor

/-! S4a — the window-regime wire squeeze, FIRST GREEN OF S4
(day-023 25m; DISCOVERY_LOG 25l/25m; spec p1.2 §S4).

S4 (P12Uniform.lean) is the squeeze

    Bwire(t) + Mr(t) + Mf(t) < flo(t, d)          (uniform in t),

the floors being A4.1b (far: 1), C1a (own: the pole), and the pinned
near floor `p8_f_near_pin = 0.9975`; the wires live in `P8Floor`
(`p8_B`, residual forms of `p8_residual_wired`) with `Sbar`/`Bf`/`Cf`/
`Kbar` from `B3Core` (theorem form: A4.2/A4.3).

This module proves the squeeze at the WIRE level for WINDOW-regime
pairs on the band [1000, 110000], with every wire in closed form:

  Bwire(t) = p8_B(t, floor(13t/8)) — the P4 floor at the list scale
        n = floor(13t/8) (m = 40 onset branch, argmin edge; any branch
        is a valid wire — the closure's N witness is free).
  Mr(t)    = Xwire(t) — the `b3BoundExplicit` RHS (band (G, B], G = 1e7,
        B = 1e8) as a def-level mirror of the Lean theorem.
  Mf(t)    = M·exp(Xwire(t))·Xwire(t), M = bridge product mass |K(t)|
        with the wire |K(t)| = |ζ(t)|/|C(t)| ≤ 1.6·t^{1/4}·ln t =
        Zbound(t), using |C(½+it)| ≥ 1 (CITED: functional-equation
        bridge constant) and the convexity-type bound
        |ζ(½+it)| ≤ 1.6·t^{1/4}·ln t (CITED: conservative classical
        constant, DLMF 25.15.4-type; t ≥ 2).

HONEST SPLIT:
  LEAN-PROVEN — `s4a_window_squeeze` (the wire squeeze on [1000, 1e5]).
  CITED       — |C(½+it)| ≥ 1; the convexity constant 1.6.
  PINNED      — the endpoint T0 = 110000 (25m pin: crossing
        t_c = 113957.110061; W monotone increasing on [1e3, t_c] by
        400-pt finite-difference check; margin 0.0591 at T0 on the
        tight pin) and the constants R1..RM below, certified by
        `scripts/rh/day023_s4a_constants.py` (200k-point sampling:
        every bound valid over the whole interval; argmax of term i:
        term1 @1000, term2 @1000, term3 @T0).
The two CITED steps chain into the single mass hypothesis hM (the
statement carries the mass as an input wire, exactly as A4.3
(`p8_residual_wired`) does).

OPEN REMAINDER (25l): the window band above t* (bound sharpness:
Bwire grows like k·sqrt(t), measured deficit is O(1); the crossover
to certified measurements is data, not this theorem) and the
own-regime strip {t ≥ γ₀, 0 < d ≤ ½} (the definition side at the
4d²/t² scale — the prize content).
-/

namespace S4W

/- — constants — -/

/-- List scale (zeros ≤ 1e7) and Xval band upper end. -/
def Gc : ℝ := 1e7
def Bc : ℝ := 1e8

/-- Squeeze endpoint (25m pin). -/
def T0 : ℝ := 110000

/-- The explicit Xval wire: the `b3BoundExplicit` RHS as a def (the
    theorem form is A4.2/A4.3; this is its numeric spine). -/
@[reducible]
noncomputable def Xwire (t : ℝ) : ℝ :=
    Bf t Gc * (Sbar Bc + Sbar Gc) + Cf t Gc * Kbar Gc

/-- CITED convexity-type bound for |ζ(½+it)|, t ≥ 2 (conservative
    constant 1.6). -/
@[reducible]
noncomputable def Zbound (t : ℝ) : ℝ := 1.6 * t ^ (1 / 4 : ℝ) * Real.log t

/- Padded endpoint bounds, certified by day023_s4a_constants.py. -/
def R1 : ℝ := 0.01242
def R2 : ℝ := 0.00128
def R3 : ℝ := 0.3181
def RX : ℝ := 0.00185
def RZ : ℝ := 350.1
def RM : ℝ := 0.649

/-- The endpoint total is strictly below the near-regime pin. -/
theorem hTotal : R1 + R2 + R3 + RM < p8_f_near_pin := by
  norm_num [p8_f_near_pin, R1, R2, R3, RX, RZ, RM]

/- — small lemma bank (every step individually norm_num-closed; all
    irrational quantities rounded in the needed direction) — -/

/-- √(8/13) ≤ 7845/10000. -/
lemma hs8 : Real.sqrt (8 / 13 : ℝ) ≤ 7845 / 10000 := by
  rw [Real.sqrt_le_iff]
  norm_num

/-- √(1625/1624) ≤ 1.00031. -/
lemma hs1625 : Real.sqrt (1625 / 1624 : ℝ) ≤ 1.00031 := by
  rw [Real.sqrt_le_iff]
  norm_num

/-- 1/√1625 ≤ 2481/100000 [squared: 1/1625 ≤ (2481/100000)²]. -/
lemma hs1625inv : 1 / Real.sqrt 1625 ≤ 2481 / 100000 := by
  have hpos : 0 < Real.sqrt 1625 := by positivity
  have h10 : Real.sqrt 1625 * Real.sqrt 1625 = 1625 := by
    rw [show Real.sqrt 1625 * Real.sqrt 1625 = (Real.sqrt 1625) ^ 2 from by ring,
      Real.sq_sqrt (show 0 ≤ (1625 : ℝ) from by norm_num)]
  have hsq : (1 / Real.sqrt 1625) ^ 2 = 1 / 1625 := by
    have : (1 / Real.sqrt 1625) ^ 2 =
        (1 / Real.sqrt 1625) * (1 / Real.sqrt 1625) := by ring
    rw [this]
    field_simp [h10]
    norm_num
  have hd : (1 / Real.sqrt 1625) ^ 2 ≤ (2481 / 100000) ^ 2 := by
    rw [hsq]
    norm_num
  have hx : 0 ≤ 1 / Real.sqrt 1625 := by positivity
  have hy : 0 < (2481 / 100000 : ℝ) := by norm_num
  have hdiff : 0 ≤ ((2481 / 100000) - 1 / Real.sqrt 1625) *
        ((2481 / 100000) + 1 / Real.sqrt 1625) := by
    nlinarith [hd]
  have hsum : 0 < (2481 / 100000) + 1 / Real.sqrt 1625 := by positivity
  nlinarith

/-- √3 ≤ 1.7321. -/
lemma hs3 : Real.sqrt 3 ≤ 1.7321 := by
  rw [Real.sqrt_le_iff]
  norm_num

/-- √T0 ≤ 332. -/
lemma hsT0 : Real.sqrt T0 ≤ 332 := by
  rw [Real.sqrt_le_iff]
  norm_num [T0]

/- — floor facts for n = floor(13t/8), t ≥ 1000 — -/

/-- n > 13t/8 − 1 (true for all t: no bound needed). -/
theorem hFloorLo (t : ℝ) : (13 * t / 8 : ℝ) - 1 < (Nat.floor (13 * t / 8) : ℝ) := by
  have h : 13 * t / 8 < (Nat.floor (13 * t / 8) : ℝ) + 1 :=
    Nat.lt_floor_add_one (13 * t / 8)
  linarith

/-- (n : ℝ) ≥ (13t/8)·(1624/1625) for t ≥ 1000
    [1 − 8/(13t) ≥ 1 − 8/13000 = 1624/1625]. -/
theorem hFloorBase (t : ℝ) (ht : 1000 ≤ t) :
    (13 * t / 8 : ℝ) * (1624 / 1625) ≤ (Nat.floor (13 * t / 8) : ℝ) := by
  have h13t : (13 * t : ℝ) ≥ 13000 := by
    nlinarith [show (13000 : ℝ) = 13 * 1000 from by norm_num, ht]
  have h2 : 8 / (13 * t) ≤ 1 / 1625 := by
    have hpos : 0 < 13 * t := by nlinarith [ht]
    have hinv : 1 / (13 * t) ≤ 1 / 13000 := by
      apply (one_div_le_one_div _ _).mpr
      · exact h13t
      · exact hpos
      · norm_num
    calc 8 / (13 * t)
        = 8 * (1 / (13 * t)) := by field_simp
      _ ≤ 8 * (1 / 13000) := by
        exact mul_le_mul_of_nonneg_left hinv (by norm_num : (0 : ℝ) ≤ 8)
      _ = 1 / 1625 := by norm_num
  have h5 : (1 - 1 / 1625 : ℝ) = 1624 / 1625 := by norm_num
  have h7 : (13 * t / 8 : ℝ) * (1 - 8 / (13 * t)) = 13 * t / 8 - 1 := by
    field_simp
  have h5in : 1 - 1 / 1625 ≤ 1 - 8 / (13 * t) := by linarith [h2]
  have h8 : (13 * t / 8 : ℝ) * (1624 / 1625) ≤
      (13 * t / 8 : ℝ) * (1 - 8 / (13 * t)) := by
    rw [show (1624 / 1625 : ℝ) = 1 - 1 / 1625 from by norm_num]
    exact mul_le_mul_of_nonneg_left h5in (by positivity : 0 ≤ 13 * t / 8)
  nlinarith [h8, h7, hFloorLo t]

/-- 0 < (n : ℝ). -/
theorem hFloorPos (t : ℝ) (ht : 1000 ≤ t) : 0 < (Nat.floor (13 * t / 8) : ℝ) := by
  have hA : (13 * 1000 / 8 : ℝ) = 1625 := by norm_num
  have hB : (13 * 1000 / 8 : ℝ) ≤ 13 * t / 8 := by nlinarith [ht]
  have h0 : 0 < 13 * t / 8 - 1 := by linarith [hA, hB]
  have hf0 : (13 * t / 8 : ℝ) - 1 < (Nat.floor (13 * t / 8) : ℝ) := hFloorLo t
  linarith [h0, hf0]

/- — rpow → sqrt helpers (p8_B is written with rpow) — -/
variable {n : ℕ}

/-- (n : ℝ)^(-1/2) = 1/√n for n > 0. -/
theorem hpow1 (hn : 0 < (n : ℝ)) :
    (n : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt (n : ℝ) := by
  have h0 : 0 ≤ (n : ℝ) := by positivity
  have hA : (n : ℝ) ^ (-1 / 2 : ℝ) = (n : ℝ) ^ (-(1 / 2) : ℝ) := by
    congr
    ring
  rw [hA]
  rw [Real.rpow_neg h0 (1 / 2)]
  rw [show (n : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (n : ℝ) from
    (Real.sqrt_eq_rpow (n : ℝ)).symm]
  simp

/-- (x : ℝ)^(-3/2) = 1/(x·√x) for x > 0. -/
theorem hpow3 (x : ℝ) (hx : 0 < x) :
    x ^ (-3 / 2 : ℝ) = 1 / (x * Real.sqrt x) := by
  have hA : x ^ (-3 / 2 : ℝ) = x ^ (-(3 / 2) : ℝ) := by
    congr
    ring
  rw [hA]
  rw [Real.rpow_neg (by positivity : 0 ≤ x) (3 / 2)]
  have hB : x ^ (3 / 2 : ℝ) = x * Real.sqrt x := by
    have : (3 / 2 : ℝ) = 1 + 1 / 2 := by norm_num
    rw [this]
    rw [Real.rpow_add hx 1 (1 / 2)]
    rw [Real.rpow_one, (Real.sqrt_eq_rpow x).symm]
  rw [hB]
  simp

/- — Bwire term 1: (1/2)·n^(-1/2) ≤ R1 — -/

theorem hTerm1 (t : ℝ) (ht : 1000 ≤ t) :
    1 / 2 * (Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ) ≤ R1 := by
  have hn : 0 < (Nat.floor (13 * t / 8) : ℝ) := hFloorPos t ht
  have hbase : (13 * t / 8 : ℝ) * (1624 / 1625) ≤ (Nat.floor (13 * t / 8) : ℝ) :=
    hFloorBase t ht
  have h1 : (Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ) =
      1 / Real.sqrt (Nat.floor (13 * t / 8) : ℝ) := by
    rw [hpow1 hn]
  have h2 : 1 / Real.sqrt (Nat.floor (13 * t / 8) : ℝ) ≤
      1 / Real.sqrt ((13 * t / 8) * (1624 / 1625)) := by
    apply (one_div_le_one_div _ _).mpr
    · exact Real.sqrt_le_sqrt hbase
    · positivity
    · positivity
  have h3 : Real.sqrt ((13 * t / 8 : ℝ) * (1624 / 1625)) =
      Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625) :=
    Real.sqrt_mul (by positivity : 0 ≤ (13 * t / 8 : ℝ)) (1624 / 1625)
  have h4 : 13 * t / 8 ≥ 1625 := by
    have hA : (13 * 1000 / 8 : ℝ) = 1625 := by norm_num
    nlinarith [hA, ht]
  have h5 : 1 / Real.sqrt (13 * t / 8) ≤ 1 / Real.sqrt 1625 := by
    apply (one_div_le_one_div _ _).mpr
    · exact Real.sqrt_le_sqrt h4
    · positivity
    · positivity
  have h6 : 1 / (Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625)) =
      (1 / Real.sqrt (13 * t / 8)) / Real.sqrt (1624 / 1625) := by
    field_simp [show Real.sqrt (13 * t / 8) ≠ 0 from by positivity,
      show Real.sqrt (1624 / 1625) ≠ 0 from by positivity]
  have h7 : (1 / Real.sqrt (13 * t / 8)) / Real.sqrt (1624 / 1625) ≤
      (1 / Real.sqrt 1625) / Real.sqrt (1624 / 1625) := by
    field_simp [show Real.sqrt (13 * t / 8) ≠ 0 from by positivity,
      show Real.sqrt 1625 ≠ 0 from by positivity,
      show Real.sqrt (1624 / 1625) ≠ 0 from by positivity]
    exact Real.sqrt_le_sqrt h4
  have h9sq : Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625) = 1624 / 1625 := by
    rw [show Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625) =
        (Real.sqrt (1624 / 1625)) ^ 2 from by ring,
      Real.sq_sqrt (show 0 ≤ (1624 / 1625 : ℝ) from by norm_num)]
  have h9h : (1 / Real.sqrt (1624 / 1625)) ^ 2 = 1625 / 1624 := by
    have : (1 / Real.sqrt (1624 / 1625)) ^ 2 =
        (1 / Real.sqrt (1624 / 1625)) * (1 / Real.sqrt (1624 / 1625)) := by ring
    rw [this]
    have hq : Real.sqrt (1624 / 1625) ≠ 0 := by positivity
    have hq2 : (1 / Real.sqrt (1624 / 1625)) * (1 / Real.sqrt (1624 / 1625)) =
        1 / (Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625)) := by field_simp [hq]
    rw [hq2, h9sq]
    norm_num
  have h9d : (1 / Real.sqrt (1624 / 1625)) ^ 2 ≤ (1.00031 : ℝ) ^ 2 := by
    rw [h9h]
    norm_num
  have h9 : 1 / Real.sqrt (1624 / 1625) ≤ 1.00031 := by
    have h9x : 0 ≤ 1 / Real.sqrt (1624 / 1625) := by positivity
    have h9y : 0 < (1.00031 : ℝ) := by norm_num
    have h9diff : 0 ≤ ((1.00031 : ℝ) - 1 / Real.sqrt (1624 / 1625)) *
          ((1.00031 : ℝ) + 1 / Real.sqrt (1624 / 1625)) := by
      nlinarith [h9d]
    have h9sum : 0 < (1.00031 : ℝ) + 1 / Real.sqrt (1624 / 1625) := by positivity
    nlinarith
  have h8 : (1 / Real.sqrt 1625) / Real.sqrt (1624 / 1625) ≤
      (1 / Real.sqrt 1625) * 1.00031 := by
    have h8a : (1 / Real.sqrt 1625) / Real.sqrt (1624 / 1625) =
        (1 / Real.sqrt 1625) * (1 / Real.sqrt (1624 / 1625)) := by
      field_simp
    rw [h8a]
    exact mul_le_mul_of_nonneg_left h9 (by positivity : 0 ≤ 1 / Real.sqrt 1625)
  have h11 : 1 / Real.sqrt 1625 ≤ 2481 / 100000 := hs1625inv
  have h13 : (1 / Real.sqrt 1625) * 1.00031 ≤ (2481 / 100000) * 1.00031 := by
    exact mul_le_mul_of_nonneg_right h11 (by norm_num : (0 : ℝ) ≤ 1.00031)
  calc 1 / 2 * (Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ)
      = 1 / 2 * (1 / Real.sqrt (Nat.floor (13 * t / 8) : ℝ)) := by
        rw [h1]
      _ ≤ 1 / 2 * (1 / Real.sqrt ((13 * t / 8) * (1624 / 1625))) := by
        exact mul_le_mul_of_nonneg_left h2 (by norm_num : (0 : ℝ) ≤ 1 / 2)
      _ = 1 / 2 * (1 / (Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625))) := by
        rw [h3]
      _ = 1 / 2 * ((1 / Real.sqrt (13 * t / 8)) / Real.sqrt (1624 / 1625)) := by
        rw [h6]
      _ ≤ 1 / 2 * ((1 / Real.sqrt 1625) / Real.sqrt (1624 / 1625)) := by
        exact mul_le_mul_of_nonneg_left h7 (by norm_num : (0 : ℝ) ≤ 1 / 2)
      _ ≤ 1 / 2 * ((1 / Real.sqrt 1625) * 1.00031) := by
        exact mul_le_mul_of_nonneg_left h8 (by norm_num : (0 : ℝ) ≤ 1 / 2)
      _ ≤ 1 / 2 * ((2481 / 100000) * 1.00031) := by
        exact mul_le_mul_of_nonneg_left h13 (by norm_num : (0 : ℝ) ≤ 1 / 2)
      _ ≤ R1 := by
        norm_num [R1]
        <;>
        (try
          (
            have : (2481 / 100000 : ℝ) * 1.00031 * (1 / 2) ≤ R1 := by norm_num
            linarith [this]
          ))

/- — 1/√(1624/1625) pad (reused by terms 2 and 3) — -/

/-- 1/√(1624/1625) ≤ 1.00031 [squared: 1625/1624 ≤ 1.00031²]. -/
lemma h1624recip : 1 / Real.sqrt (1624 / 1625) ≤ 1.00031 := by
  have h9sq : Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625) = 1624 / 1625 := by
    rw [show Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625) =
        (Real.sqrt (1624 / 1625)) ^ 2 from by ring,
      Real.sq_sqrt (show 0 ≤ (1624 / 1625 : ℝ) from by norm_num)]
  have h9h : (1 / Real.sqrt (1624 / 1625)) ^ 2 = 1625 / 1624 := by
    have : (1 / Real.sqrt (1624 / 1625)) ^ 2 =
        (1 / Real.sqrt (1624 / 1625)) * (1 / Real.sqrt (1624 / 1625)) := by ring
    rw [this]
    have hq : Real.sqrt (1624 / 1625) ≠ 0 := by positivity
    have hq2 : (1 / Real.sqrt (1624 / 1625)) * (1 / Real.sqrt (1624 / 1625)) =
        1 / (Real.sqrt (1624 / 1625) * Real.sqrt (1624 / 1625)) := by field_simp [hq]
    rw [hq2, h9sq]
    norm_num
  have h9d : (1 / Real.sqrt (1624 / 1625)) ^ 2 ≤ (1.00031 : ℝ) ^ 2 := by
    rw [h9h]
    norm_num
  have h9x : 0 ≤ 1 / Real.sqrt (1624 / 1625) := by positivity
  have h9diff : 0 ≤ ((1.00031 : ℝ) - 1 / Real.sqrt (1624 / 1625)) *
        ((1.00031 : ℝ) + 1 / Real.sqrt (1624 / 1625)) := by
    nlinarith [h9d]
  have h9sum : 0 < (1.00031 : ℝ) + 1 / Real.sqrt (1624 / 1625) := by positivity
  nlinarith

/- — Zbound mass wire: 1.6·t^{1/4}·ln t ≤ RZ on [1000, T0].
    The ln ≤ 12 part routes through an elementary exp lower bound
    (finite-geometric, no tsum / Taylor machinery): -/

/-- exp(1) ≥ (51/50)^50, from 1 + 1/50 ≤ exp(1/50) raised to the 50th. -/
theorem hEbound : (51 / 50 : ℝ) ^ 50 ≤ Real.exp 1 := by
  have h1 : 1 + 1 / 50 ≤ Real.exp (1 / 50) := by
    rw [show (1 : ℝ) + 1 / 50 = (1 / 50) + 1 from by ring]
    exact Real.add_one_le_exp (1 / 50)
  have h2 : (1 + 1 / 50) ^ 50 ≤ (Real.exp (1 / 50)) ^ 50 :=
    pow_le_pow_left₀ (by norm_num : 0 ≤ (1 : ℝ) + 1 / 50) h1 50
  have h3 : (Real.exp (1 / 50)) ^ 50 = Real.exp (50 * (1 / 50)) :=
    (Real.exp_nat_mul (1 / 50) 50).symm
  have h4 : Real.exp (50 * (1 / 50)) = Real.exp 1 := by
    rw [show (50 * (1 / 50) : ℝ) = 1 from by norm_num]
  calc (51 / 50 : ℝ) ^ 50
      = (1 + 1 / 50) ^ 50 := by norm_num
      _ ≤ (Real.exp (1 / 50)) ^ 50 := h2
      _ = Real.exp (50 * (1 / 50)) := by rw [h3]
      _ = Real.exp 1 := by rw [h4]

/-- 110000 ≤ exp(12) — chain: 110000 ≤ 3.2^10 ≤ (((51/50)^6)^10)^10 = (51/50)^600
    = ((51/50)^50)^12 ≤ (exp 1)^12 = exp 12. -/
theorem hE12 : (110000 : ℝ) ≤ Real.exp 12 := by
  have h1 : (51 / 50 : ℝ) ^ 50 ≤ Real.exp 1 := hEbound
  have h2 : ((51 / 50 : ℝ) ^ 50) ^ 12 ≤ (Real.exp 1) ^ 12 :=
    pow_le_pow_left₀ (by positivity : 0 ≤ (51 / 50 : ℝ) ^ 50) h1 12
  have h3 : (Real.exp 1) ^ 12 = Real.exp 12 := by
    have hA : (Real.exp 1) ^ 12 = Real.exp ((12 : ℝ) * 1) := (Real.exp_nat_mul 1 12).symm
    have hB : Real.exp ((12 : ℝ) * 1) = Real.exp 12 := by
      rw [show (12 : ℝ) * 1 = 12 from by norm_num]
    rw [hA, hB]
  have h4 : ((51 / 50 : ℝ) ^ 50) ^ 12 = (((51 / 50 : ℝ) ^ 6) ^ 10) ^ 10 := by
    have hL : ((51 / 50 : ℝ) ^ 50) ^ 12 = (51 / 50 : ℝ) ^ 600 := by
      rw [← pow_mul, show (50 : ℕ) * 12 = 600 from by norm_num]
    have hR : (((51 / 50 : ℝ) ^ 6) ^ 10) ^ 10 = (51 / 50 : ℝ) ^ 600 := by
      rw [← pow_mul, ← pow_mul, show (6 : ℕ) * (10 * 10) = 600 from by norm_num]
    rw [hL, hR.symm]
  have h6 : (110000 : ℝ) ≤ (32 / 10 : ℝ) ^ 10 := by norm_num
  calc (110000 : ℝ)
      ≤ (32 / 10 : ℝ) ^ 10 := h6
      _ ≤ (((51 / 50 : ℝ) ^ 6) ^ 10) ^ 10 :=
        pow_le_pow_left₀ (by norm_num : 0 ≤ (32 / 10 : ℝ))
          (by norm_num : (32 / 10 : ℝ) ≤ ((51 / 50 : ℝ) ^ 6) ^ 10) 10
      _ = ((51 / 50 : ℝ) ^ 50) ^ 12 := by rw [h4]
      _ ≤ (Real.exp 1) ^ 12 := h2
      _ = Real.exp 12 := by rw [h3]
/-- t^{1/4} ≤ 18.23 for 0 < t ≤ T0 (18.23⁴ = 110445.02 ≥ 110000). -/
theorem hTqr (t : ℝ) (ht : 0 < t) (htu : t ≤ T0) : t ^ (1 / 4 : ℝ) ≤ 18.23 := by
  have h1 : (1 / 2 : ℝ) * (1 / 2) = 1 / 4 := by norm_num
  have hA : (t ^ (1 / 2 : ℝ)) ^ (1 / 2 : ℝ) = t ^ (1 / 4 : ℝ) := by
    rw [← h1, ← Real.rpow_mul (by positivity : 0 ≤ t) (1 / 2 : ℝ) (1 / 2 : ℝ)]
  have hB : (t ^ (1 / 2 : ℝ)) ^ (1 / 2 : ℝ) = Real.sqrt (Real.sqrt t) := by
    rw [show Real.sqrt t = t ^ (1 / 2 : ℝ) from Real.sqrt_eq_rpow t,
      show Real.sqrt (t ^ (1 / 2 : ℝ)) = (t ^ (1 / 2 : ℝ)) ^ (1 / 2 : ℝ) from
        Real.sqrt_eq_rpow (t ^ (1 / 2 : ℝ))]
  have hC : t ^ (1 / 4 : ℝ) = Real.sqrt (Real.sqrt t) := by
    rw [← hA, hB]
  rw [hC]
  rw [Real.sqrt_le_iff]
  constructor
  · norm_num
  · rw [Real.sqrt_le_iff]
    constructor
    · positivity
    · have : (18.23 : ℝ) * 18.23 = 332.3329 := by norm_num
      have : (332.3329 : ℝ) * 332.3329 ≥ 110000 := by norm_num
      have : (110000 : ℝ) = T0 := by norm_num [T0]
      nlinarith [htu, ‹(110000 : ℝ) = T0›, ‹(332.3329 : ℝ) * 332.3329 ≥ 110000›,
        ‹(18.23 : ℝ) * 18.23 = 332.3329›]

/-- ln t ≤ 12 for 0 < t ≤ T0 (110000 < exp 12). -/
theorem hLog12 (t : ℝ) (ht : 0 < t) (htu : t ≤ T0) : Real.log t ≤ 12 := by
  have h1 : Real.log t ≤ Real.log T0 := by
    have hT : 0 < T0 := by norm_num [T0]
    exact Real.log_le_log ht (by nlinarith [htu, show (110000 : ℝ) = T0 from by norm_num [T0]])
  have h2 : Real.log T0 ≤ 12 := by
    rw [Real.log_le_iff_le_exp (by norm_num [T0] : 0 < T0)]
    rw [show (T0 : ℝ) = 110000 from by norm_num [T0]]
    exact hE12
  linarith [h1, h2]

/-- The convexity mass wire on the band: Zbound t ≤ RZ for t ∈ [1000, T0]. -/
theorem hZbound (t : ℝ) (ht : 1000 ≤ t) (htu : t ≤ T0) : Zbound t ≤ RZ := by
  have hpos : 0 < t := by nlinarith
  have hq : t ^ (1 / 4 : ℝ) ≤ 18.23 := hTqr t hpos htu
  have hl : Real.log t ≤ 12 := hLog12 t hpos htu
  calc (Zbound t)
      = 1.6 * t ^ (1 / 4 : ℝ) * Real.log t := by rfl
      _ = 1.6 * (t ^ (1 / 4 : ℝ) * Real.log t) := by
        exact mul_assoc (1.6 : ℝ) (t ^ (1 / 4 : ℝ)) (Real.log t)
      _ ≤ (1.6 : ℝ) * (18.23 * 12) := by
        have hll : 0 ≤ Real.log t := by
          have h2 : (1 : ℝ) ≤ t := by nlinarith
          exact Real.log_nonneg h2
        have hstep : t ^ (1 / 4 : ℝ) * Real.log t ≤ (18.23 : ℝ) * 12 := by
          have h1 : t ^ (1 / 4 : ℝ) * Real.log t ≤ (18.23 : ℝ) * Real.log t := by
            exact mul_le_mul_of_nonneg_right hq hll
          have h2b : (18.23 : ℝ) * Real.log t ≤ (18.23 : ℝ) * 12 := by
            exact mul_le_mul_of_nonneg_left hl (by norm_num : (0 : ℝ) ≤ 18.23)
          calc (t ^ (1 / 4 : ℝ) * Real.log t)
              ≤ (18.23 : ℝ) * Real.log t := by exact h1
              _ ≤ (18.23 : ℝ) * 12 := by exact h2b
        exact mul_le_mul_of_nonneg_left hstep (by norm_num : (0 : ℝ) ≤ 1.6)
      _ = (1.6 : ℝ) * 18.23 * 12 := by
        exact (mul_assoc (1.6 : ℝ) 18.23 12).symm
      _ ≤ RZ := by norm_num [RZ]

/-- exp(RX) ≤ 1.002, from 1 − RX ≤ exp(−RX) (inverted), then exact
    rational arithmetic on 1/(1 − RX). -/
theorem hExpRX : Real.exp RX ≤ 1.002 := by
  have hneg : (−RX) + 1 ≤ Real.exp (−RX) := Real.add_one_le_exp (−RX)
  have hexp : 0 < Real.exp (−RX) := Real.exp_pos (−RX)
  have hden2 : 0 < (−RX) + 1 := by
    norm_num [RX]
  calc (Real.exp RX : ℝ)
      = (Real.exp (−RX))⁻¹ := by
        rw [← Real.exp_neg (−RX), inv_inv (Real.exp RX)]
      _ ≤ ((−RX) + 1)⁻¹ := by
        apply (one_div_le_one_div hexp hden2).mpr
        exact hneg
      _ = (1 − RX)⁻¹ := by
        rw [show (−RX) + 1 = 1 − RX from by ring]
      _ ≤ (1.002 : ℝ) := by
        norm_num [RX]

/- — Bwire term 2: sqrt(t²+¼)/12 · n^(-3/2) ≤ R2 — -/

theorem hTerm2 (t : ℝ) (ht : 1000 ≤ t) :
    Real.sqrt (1 / 4 + t * t) / 12 * (Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ) ≤ R2 := by
  have hbase : (13 * t / 8 : ℝ) * (1624 / 1625) ≤ (Nat.floor (13 * t / 8) : ℝ) :=
    hFloorBase t ht
  have hpos : 0 < (13 * t / 8 : ℝ) := by nlinarith
  have hfloor : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := by
    rw [Real.sqrt_le_iff]
    constructor
    · nlinarith
    · nlinarith
  have hfloor12 : Real.sqrt (1 / 4 + t * t) / 12 ≤ (t + 1 / 2) / 12 := by
    have hl : Real.sqrt (1 / 4 + t * t) / 12 =
        Real.sqrt (1 / 4 + t * t) * (1 / 12) := by field_simp
    have hr : (t + 1 / 2) / 12 = (t + 1 / 2) * (1 / 12) := by field_simp
    rw [hl, hr]
    exact mul_le_mul_of_nonneg_right hfloor (by
      norm_num : (0 : ℝ) ≤ 1 / 12)
  have h1 : (Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ) =
      1 / ((Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8))) := by
    rw [hpow3 (Nat.floor (13 * t / 8) : ℝ) (hFloorPos t ht)]
  have h2 : ((13 * t / 8 : ℝ) * (1624 / 1625)) ^ (-3 / 2 : ℝ) =
      1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625))) := by
    rw [hpow3 ((13 * t / 8 : ℝ) * (1624 / 1625)) (mul_pos hpos (by
      norm_num : 0 < (1624 / 1625 : ℝ)))]
  have hnpos : 0 < (Nat.floor (13 * t / 8) : ℝ) := hFloorPos t ht
  have h3 : (Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)) ≥
      (13 * t / 8) * (1624 / 1625) * Real.sqrt ((13 * t / 8) * (1624 / 1625)) := by
    have h4 : (13 * t / 8) * (1624 / 1625) * Real.sqrt ((13 * t / 8) * (1624 / 1625)) ≤
        (13 * t / 8) * (1624 / 1625) * Real.sqrt (Nat.floor (13 * t / 8)) := by
      exact mul_le_mul_of_nonneg_left (Real.sqrt_le_sqrt hbase)
          (by nlinarith [show 0 ≤ (1624 : ℝ) from by norm_num, ht])
    have h5 : (13 * t / 8) * (1624 / 1625) * Real.sqrt (Nat.floor (13 * t / 8)) ≤
        (Nat.floor (13 * t / 8)) * Real.sqrt (Nat.floor (13 * t / 8)) := by
      exact mul_le_mul_of_nonneg_right hbase (by
        positivity)
    nlinarith [h4, h5]
  have h4 : 1 / ((Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8))) ≤
      1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625))) := by
    apply (one_div_le_one_div _ _).mpr
    · exact h3
    · positivity
    · positivity
  calc Real.sqrt (1 / 4 + t * t) / 12 * (Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ)
      ≤ (t + 1 / 2) / 12 * (Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ) := by
        exact mul_le_mul_of_nonneg_right hfloor12 (by
          apply le_of_lt
          exact Real.rpow_pos_of_pos (hFloorPos t ht) (-3 / 2))
      _ = (t + 1 / 2) / 12 * (1 / ((Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)))) := by
        rw [h1]
      _ ≤ (t + 1 / 2) / 12 * (1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625)))) := by
        rw [show (t + 1 / 2) / 12 * (1 / ((Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)))) =
            (1 / ((Nat.floor (13 * t / 8) : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)))) * ((t + 1 / 2) / 12) from by ring,
          show (t + 1 / 2) / 12 * (1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625)))) =
            (1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625)))) * ((t + 1 / 2) / 12) from by ring]
        exact mul_le_mul_of_nonneg_right h4 (by
          positivity : 0 ≤ (t + 1 / 2) / 12)
      _ = (t + 1 / 2) / 12 * (1 / ((13 * t / 8) * (1624 / 1625) * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625))) := by
        have hden : ((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625)) =
            (13 * t / 8) * (1624 / 1625) * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625) := by
          rw [Real.sqrt_mul (by positivity : 0 ≤ (13 * t / 8 : ℝ)) (1624 / 1625)]
          ring
        rw [show 1 / (((13 * t / 8) * (1624 / 1625)) * Real.sqrt ((13 * t / 8) * (1624 / 1625))) =
            1 / ((13 * t / 8) * (1624 / 1625) * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625)) from by
          rw [hden]]
      _ = (t + 1 / 2) / 12 * (8 / 13) * (1625 / 1624) / (t * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625)) := by
        field_simp
      _ = ((t + 1 / 2) / t) * (8 / 13) * (1625 / 1624) / (12 * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625)) := by
        field_simp
      _ ≤ 1.0005 * (8 / 13) * (1625 / 1624) / (12 * Real.sqrt 1625 * Real.sqrt (1624 / 1625)) := by
        have h1000 : (t + 1 / 2) / t ≤ 1.0005 := by
          have hinv : 1 / t ≤ 1 / 1000 := by
            apply (one_div_le_one_div _ _).mpr
            · nlinarith [ht]
            · nlinarith [ht]
            · norm_num
          have : 0 < t := by nlinarith [ht]
          calc (t + 1 / 2) / t
              = 1 + 1 / (2 * t) := by
                field_simp
                <;> ring
              _ ≤ 1 + 1 / 2000 := by
                have h2t : 2 * t ≥ 2000 := by nlinarith [ht]
                have h2i : 1 / (2 * t) ≤ 1 / 2000 := by
                  apply (one_div_le_one_div _ _).mpr
                  · exact h2t
                  · nlinarith [ht]
                  · norm_num
                exact add_le_add_right h2i 1
              _ = 1.0005 := by norm_num
        have hrec : 1 / Real.sqrt (13 * t / 8) ≤ 1 / Real.sqrt 1625 := by
          have h1625 : 13 * t / 8 ≥ 1625 := by
            have h10 : (13 * 1000 / 8 : ℝ) = 1625 := by norm_num
            nlinarith [h10, ht]
          apply (one_div_le_one_div _ _).mpr
          · exact Real.sqrt_le_sqrt h1625
          · positivity
          · positivity
        have hstep : ((t + 1 / 2) / t) * (1 / Real.sqrt (13 * t / 8)) ≤
            1.0005 * (1 / Real.sqrt 1625) := by
          have h1 : ((t + 1 / 2) / t) * (1 / Real.sqrt (13 * t / 8)) ≤
              1.0005 * (1 / Real.sqrt (13 * t / 8)) := by
            exact mul_le_mul_of_nonneg_right h1000 (by
              positivity)
          have h2 : 1.0005 * (1 / Real.sqrt (13 * t / 8)) ≤
              1.0005 * (1 / Real.sqrt 1625) := by
            exact mul_le_mul_of_nonneg_left hrec (by
              norm_num : (0 : ℝ) ≤ 1.0005)
          calc ((t + 1 / 2) / t) * (1 / Real.sqrt (13 * t / 8))
              ≤ 1.0005 * (1 / Real.sqrt (13 * t / 8)) := h1
              _ ≤ 1.0005 * (1 / Real.sqrt 1625) := h2
        have hC : 0 ≤ (8 / 13) * (1625 / 1624) / 12 * (1 / Real.sqrt (1624 / 1625)) := by
          positivity
        rw [show ((t + 1 / 2) / t) * (8 / 13) * (1625 / 1624) /
            (12 * Real.sqrt (13 * t / 8) * Real.sqrt (1624 / 1625)) =
            (((t + 1 / 2) / t) * (1 / Real.sqrt (13 * t / 8))) *
            ((8 / 13) * (1625 / 1624) / 12 * (1 / Real.sqrt (1624 / 1625))) from by
          field_simp]
        rw [show 1.0005 * (8 / 13) * (1625 / 1624) /
            (12 * Real.sqrt 1625 * Real.sqrt (1624 / 1625)) =
            (1.0005 * (1 / Real.sqrt 1625)) *
            ((8 / 13) * (1625 / 1624) / 12 * (1 / Real.sqrt (1624 / 1625))) from by
          field_simp]
        exact mul_le_mul_of_nonneg_right hstep hC
      _ ≤ R2 := by
        calc 1.0005 * (8 / 13) * (1625 / 1624) /
            (12 * Real.sqrt 1625 * Real.sqrt (1624 / 1625))
            = ((1 / Real.sqrt 1625) * (1 / Real.sqrt (1624 / 1625))) *
            (1.0005 * (8 / 13) * (1625 / 1624) / 12) := by
              field_simp
            _ ≤ ((2481 / 100000) * 1.00031) * (1.0005 * (8 / 13) * (1625 / 1624) / 12) := by
              have hX : (1 / Real.sqrt 1625) * (1 / Real.sqrt (1624 / 1625)) ≤
                  (2481 / 100000) * 1.00031 := by
                have h1 : (1 / Real.sqrt 1625) * (1 / Real.sqrt (1624 / 1625)) ≤
                    (2481 / 100000) * (1 / Real.sqrt (1624 / 1625)) := by
                  exact mul_le_mul_of_nonneg_right hs1625inv (by
                    positivity)
                have h2 : (2481 / 100000) * (1 / Real.sqrt (1624 / 1625)) ≤
                    (2481 / 100000) * 1.00031 := by
                  exact mul_le_mul_of_nonneg_left h1624recip (by
                    norm_num : (0 : ℝ) ≤ 2481 / 100000)
                calc (1 / Real.sqrt 1625) * (1 / Real.sqrt (1624 / 1625))
                    ≤ (2481 / 100000) * (1 / Real.sqrt (1624 / 1625)) := h1
                    _ ≤ (2481 / 100000) * 1.00031 := h2
              exact mul_le_mul_of_nonneg_right hX (by
                norm_num : (0 : ℝ) ≤ 1.0005 * (8 / 13) * (1625 / 1624) / 12)
            _ ≤ R2 := by
              norm_num [R2]

/- — Bwire term 3, the Xwire/Zbound wires, and
    s4a_window_squeeze: next atoms (see DISCOVERY_LOG 25m and
    scripts/rh/day023_s4a_constants.py for the certified constants
    R2, R3, RX, RZ, RM and their bound structures) — -/

end S4W
