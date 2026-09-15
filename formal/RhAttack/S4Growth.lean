import Mathlib
import RhAttack.B0
import RhAttack.B3Core
import RhAttack.P8Floor
import RhAttack.S4Window

/-!
# S4Growth — 25ab: the growing-wire family closes GAP-W (window regime) for all t > T0

GAP-W (formal/RhAttack/S4Asm.lean) is the bound-level witness gap: the S4a 13t/8
(fixed-band) witness family covers t ∈ [1000, T0] (`s4a_window_squeeze`) but has NO
budget beyond T0 (codified crossing t_Z = 113957.28, 25aa). The GROWING family

    n(t) = ⌊t²⌋,   G(t) = t²,   B(t) = 2t²

(all free witnesses — `p8_B_floor` is universal in n; `b3BoundExplicit` is generic in
(L, t, G, B) with 0 < t < G, e ≤ G, G < B) keeps the total wire below a small fraction
of the 0.9975 floor for EVERY t ≥ T0 and decaying. This file is the Lean
formalization, S4a endpoint-constant style.

THEOREM (`s4g_gapW_growth`): for all t ≥ T0 = 110000 and 0 ≤ M ≤ Zbound(t),

    p8_B t (⌊t²⌋) + M · exp(Xgrow t) · Xgrow t  <  p8_f_near_pin   (0.9975),

Xgrow t = Bf(t, t²)·(Sbar(2t²) + Sbar(t²)) + Cf(t, t²)·Kbar(t²) — the
`b3BoundExplicit` right side for the band (t², 2t²], verbatim from the B3Core/B3Sbar
defs. With S4a on [1000, T0], the window regime is closed on [1000, ∞) at the bound
level (25aa + this file).

HONEST SPLIT (atom-by-atom):
- LEAN-PROVEN here: the pure wire inequality (endpoint constants CG11/CG12/CG13/CG2/CG3
  from the 25ab dps-50 directional certification, scripts/rh/day025_gapw_constants.py →
  out_day025_gapw_constants.txt, on the B3Core EXACT defs — all component bounds and
  endpoint comparisons verified, 0/3200 violations on [T0, 1e18]); the side conditions;
  the floor bounds for n = ⌊t²⌋; the admissibility margin `n(t) ≤ N_rvm_low(t²)`
  (`s4g_admissible`).
- CITED (ledger-form, not Lean): (i) the convexity/|C| ≥ 1 constants, identical class to
  S4a; (ii) Riemann–von Mangoldt error bounds, all checked against public sources on
  2026-09-15: BACKLUND (1918), for all T > 2:
  |N(T) − (T/2π)·ln(T/(2π·e)) − 7/8| < 0.137·ln T + 0.443·ln ln T + 4.350
  (as stated in the Wikipedia "Riemann–von Mangoldt formula" article, which references
  Backlund; the tabulated 5.2250 form is the same bound with the 7/8 absorbed).
  Sharper modern two-sided forms WITHOUT the 7/8 (not needed here):
  Hasanalizade–Shen–Wong (JNT 235 (2022) 219–241, Cor. 1.2):
  |N(T) − (T/2π)ln(T/(2π·e))| ≤ 0.1038·ln T + 0.2573·ln ln T + 9.3675 for T ≥ e;
  Bellotti–Fiori (arXiv:2412.15470, Math. Comp.):
  |N(T) − (T/2π)ln(T/(2π·e))| ≤ 0.10076·ln T + 0.24460·ln ln T + 8.08344 for T ≥ e.
  We use only BACKLUND: dropping +7/8 (conservative) and padding 4.350 → 4.4 gives
  the Lean def `N_rvm_low`. Measured admissibility ratio N_lower(t²)/t² ≥ 3.24 on
  [T0², 1e40] (PINNED, 25ab).
  (iii) the S̄ counting-fluctuation ledger for the band (t², 2t²] input — the same
  CITED Platt–Trudgian class as the Xval pin (same `b3BoundExplicit` hypothesis).
  No ZERO DATA is needed at the bound level.
- PINNED: 25aa out_day025_gapw_wires.txt (family wire, X(T0) = 1.45e−9 exact-B3Core
  value 1.45060731709157e−9, margin ≥ 0.997 to the floor on (1.05e5, 1e18)); 25ab
  out_day025_gapw_constants.txt REV2 (the full chain certified at dps-50).
-/

namespace S4G
open Real

/- — The wire family (free witnesses, generic in t) — -/

/-- n(t) = ⌊t²⌋ — the witness integer (free: `p8_B_floor` is universal in n). -/
noncomputable def nGrow (t : ℝ) : ℕ := Nat.floor (t * t)

/-- G(t) = t² — band lower endpoint (free: `b3BoundExplicit` is generic in (L, t, G, B)). -/
def Ggrow (t : ℝ) : ℝ := t * t

/-- B(t) = 2 t² — band upper endpoint. -/
def Bgrow (t : ℝ) : ℝ := 2 * t * t

/-- Xgrow(t) = the `b3BoundExplicit` right side for the band (t², 2t²]:
      Bf(t, t²)·(Sbar(2t²) + Sbar(t²)) + Cf(t, t²)·Kbar(t²). -/
noncomputable def Xgrow (t : ℝ) : ℝ :=
    Bf t (Ggrow t) * (Sbar (Bgrow t) + Sbar (Ggrow t)) + Cf t (Ggrow t) * Kbar (Ggrow t)

/-- Join point with S4a's GREEN window. -/
def T0 : ℝ := S4W.T0   -- 110000

/-- CITED (S4a): the convexity wire Zbound(t) = 1.6·t^{1/4}·ln t. -/
noncomputable def Zbound (t : ℝ) : ℝ := S4W.Zbound t

/- — Endpoint constants (25ab REV2 dps-50 certification; directional rounding UP) — -/

/-- p8_B term 1: (1/2)·n^{−1/2} ≤ CG11 at t ≥ T0. -/
noncomputable def CG11 : ℝ := 91 / 20000000

/-- p8_B term 2: (‖s‖/12)·n^{−3/2} ≤ CG12 at t ≥ T0. -/
noncomputable def CG12 : ℝ := 7 / 100000000000

/-- p8_B term 3: (√3/540)·‖s(s+1)(s+2)‖·n^{−5/2} ≤ CG13 at t ≥ T0. -/
noncomputable def CG13 : ℝ := 3 / 10000000000000

/-- Provable X bound on the B3Core EXACT defs:
      Xgrow t ≤ XUBfun t := (4.98·ln t + 26.55)/t²  for t ≥ T0.
    (X(T0) exact = 1.45060731709157e−9; XUBfun(T0) = 6.97e−9.) -/
noncomputable def XUBfun (t : ℝ) : ℝ := (249 / 50) * log t / (t * t) + (531 / 20) / (t * t)

/-- XUBfun t ≤ CG2 at t ≥ T0 (via ln t ≤ √t, decreasing, √T0 ≤ 332). -/
noncomputable def CG2 : ℝ := 14 / 100000000

/-- M-term bound: Zbound(t)·exp(Xgrow t)·Xgrow t ≤ CG3 at t ≥ T0
    (exp(X) ≤ exp(1) ≤ 3; (ln t)² ≤ t, ln t ≤ √t; T0^{−3/4} ≤ 1/6000, T0^{−5/4} ≤ 1/1980000). -/
noncomputable def CG3 : ℝ := 41 / 10000

/- — Side conditions (free-witness hypotheses of b3BoundExplicit / p8_B) — -/

/-- T0 = 110000 (norm_num anchor for all endpoint constants). -/
theorem hT0val : T0 = 110000 := by
  norm_num [T0, S4W.T0]

/-- 0 < t < G for t ≥ T0. -/
theorem hGt (t : ℝ) (ht : T0 ≤ t) : 0 < t ∧ t < Ggrow t := by
  constructor
  · nlinarith [hT0val, ht]
  · rw [Ggrow]
    have h1 : 1 < t := by nlinarith [hT0val, ht]
    nlinarith [h1]

/-- e ≤ G for t ≥ T0 (e ≤ 3 and t² ≥ T0² ≥ 3²). -/
theorem hGrowE (t : ℝ) (ht : T0 ≤ t) : Real.exp 1 ≤ Ggrow t := by
  rw [Ggrow]
  have h1 : Real.exp 1 ≤ 3 := S4W.hE3
  have h2 : (3 : ℝ) ≤ t := by nlinarith [hT0val, ht]
  have h3 : (3 : ℝ) * (3 : ℝ) ≤ t * t := mul_le_mul h2 h2 (by norm_num) (by nlinarith [h2])
  nlinarith [h1, h3]

/-- G < B for t ≥ T0. -/
theorem hGB (t : ℝ) (ht : T0 ≤ t) : Ggrow t < Bgrow t := by
  rw [Ggrow, Bgrow]
  have h1 : 0 < t := by nlinarith [hT0val, ht]
  have h2 : 0 < t * t := by nlinarith [h1]
  nlinarith [h2]

/- — Floor facts for n = ⌊t²⌋ — -/

/-- t² − 1 < ⌊t²⌋ (t > 0). -/
theorem hFloorLo (t : ℝ) (ht : 0 < t) : t * t - 1 < (nGrow t : ℝ) := by
  rw [nGrow]
  have h1 : t * t < (Nat.floor (t * t) : ℝ) + 1 := Nat.lt_floor_add_one (t * t)
  linarith

/-- n(t) ≥ t²·(1 − 1/T0²) for t ≥ T0. -/
theorem hFloorBase (t : ℝ) (ht : T0 ≤ t) :
    t * t * (1 - 1 / (T0 * T0)) ≤ (nGrow t : ℝ) := by
  have hpos : 0 < t := by nlinarith [hT0val, ht]
  have hT0pos : 0 < T0 := by norm_num [hT0val]
  have h2 : T0 * T0 ≤ t * t := by
    have h3 : 110000 ≤ t := by simpa [hT0val] using ht
    have h4 : 110000 * 110000 ≤ 110000 * t := mul_le_mul_of_nonneg_left h3 (by norm_num)
    have h5 : 110000 * t ≤ t * t := mul_le_mul_of_nonneg_right h3 (by nlinarith [h3])
    rw [hT0val]
    exact le_trans h4 h5
  have h1 : 1 / (t * t) ≤ 1 / (T0 * T0) :=
    one_div_le_one_div_of_le (by positivity) h2
  have h2b : 1 - 1 / (T0 * T0) ≤ 1 - 1 / (t * t) := by linarith [h1]
  have h3b : t * t * (1 - 1 / (T0 * T0)) ≤ t * t * (1 - 1 / (t * t)) := by
    rw [show (t * t) * (1 - 1 / (T0 * T0)) = (1 - 1 / (T0 * T0)) * (t * t) from by ring_nf,
        show (t * t) * (1 - 1 / (t * t)) = (1 - 1 / (t * t)) * (t * t) from by ring_nf]
    exact mul_le_mul_of_nonneg_right h2b (mul_self_nonneg t)
  have hA : t * t * (1 - 1 / (t * t)) = t * t - 1 := by
    field_simp [hpos.ne']
  have hf : t * t - 1 < (nGrow t : ℝ) := hFloorLo t hpos
  linarith [hA, h3b, hf]

/-- n(t) > 0 for t ≥ T0. -/
theorem hFloorPos (t : ℝ) (ht : T0 ≤ t) : 0 < (nGrow t : ℝ) := by
  have h1 : 0 < T0 * T0 - 1 := by norm_num [hT0val]
  have h2 : T0 * T0 ≤ t * t := by
    have h3 : 110000 ≤ t := by simpa [hT0val] using ht
    have h4 : 110000 * 110000 ≤ 110000 * t := mul_le_mul_of_nonneg_left h3 (by norm_num)
    have h5 : 110000 * t ≤ t * t := mul_le_mul_of_nonneg_right h3 (by nlinarith [h3])
    rw [hT0val]
    exact le_trans h4 h5
  have h3 : T0 * T0 - 1 ≤ t * t - 1 := by linarith [h2]
  have h4 : t * t - 1 < (nGrow t : ℝ) := hFloorLo t (by nlinarith [hT0val, ht])
  linarith [h1, h3, h4]

/- — rpow / sqrt / complex-norm helpers — -/

variable {n : ℕ}

/-- (n : ℝ)^(-5/2) = 1/(n²·√n) for n > 0. -/
theorem hpow5 (hn : 0 < (n : ℝ)) :
    (n : ℝ) ^ (-5 / 2 : ℝ) = 1 / ((n : ℝ) * (n : ℝ) * Real.sqrt (n : ℝ)) := by
  have hA : (n : ℝ) ^ (-5 / 2 : ℝ) = (n : ℝ) ^ (-(5 / 2) : ℝ) := by congr; ring
  rw [hA, Real.rpow_neg hn.le (5 / 2)]
  have hB : (n : ℝ) ^ (5 / 2 : ℝ) = (n : ℝ) * (n : ℝ) * Real.sqrt (n : ℝ) := by
    have h1 : (5 / 2 : ℝ) = 2 + 1 / 2 := by norm_num
    rw [h1, Real.rpow_add hn 2 (1 / 2)]
    have h3 : (n : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (n : ℝ) := (Real.sqrt_eq_rpow (n : ℝ)).symm
    rw [h3]
    have h2 : (n : ℝ) ^ (2 : ℝ) = (n : ℝ) ^ 2 := (Real.rpow_natCast (n : ℝ) 2)
    rw [h2, pow_two]
  rw [hB]
  field_simp [show (n : ℝ) * (n : ℝ) * Real.sqrt (n : ℝ) ≠ 0 from by positivity]

/-- ‖(1/2) + i t‖ = √(1/4 + t²). -/
theorem hNorm (t : ℝ) :
    ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (1 / 4 + t * t) := by
  rw [Complex.norm_def, Complex.normSq_add_mul_I (1 / 2 : ℝ) t,
      show (1 / 2 : ℝ) ^ 2 = 1 / 4 from by norm_num, pow_two]

/-- ‖(3/2) + i t‖ = √(9/4 + t²). -/
theorem hNorm3 (t : ℝ) :
    ‖((3 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (9 / 4 + t * t) := by
  rw [Complex.norm_def, Complex.normSq_add_mul_I (3 / 2 : ℝ) t,
      show (3 / 2 : ℝ) ^ 2 = 9 / 4 from by norm_num, pow_two]

/-- ‖(5/2) + i t‖ = √(25/4 + t²). -/
theorem hNorm5 (t : ℝ) :
    ‖((5 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (25 / 4 + t * t) := by
  rw [Complex.norm_def, Complex.normSq_add_mul_I (5 / 2 : ℝ) t,
      show (5 / 2 : ℝ) ^ 2 = 25 / 4 from by norm_num, pow_two]

/-- √(t² + 1/4) ≤ t + 1/2 (t ≥ 0). -/
theorem hSbnd (t : ℝ) (ht : 0 ≤ t) : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := by
  have h1 : 0 ≤ t + 1 / 2 := by nlinarith [ht]
  have h2 : 1 / 4 + t * t ≤ (t + 1 / 2) ^ 2 := by
    nlinarith [ht]
  exact (Real.sqrt_le_iff).2 ⟨h1, h2⟩

/-- √(t²+1/4)·√(t²+9/4)·√(t²+25/4) ≤ (t+3)³ (t ≥ 0). -/
theorem hS3bnd (t : ℝ) (ht : 0 ≤ t) :
    Real.sqrt (1 / 4 + t * t) * Real.sqrt (9 / 4 + t * t) * Real.sqrt (25 / 4 + t * t) ≤
        (t + 3) ^ 3 := by
  have h1 : Real.sqrt (1 / 4 + t * t) ≤ t + 3 := by
    have hA : 0 ≤ t + 3 := by nlinarith [ht]
    exact (Real.sqrt_le_iff).2 ⟨hA, by nlinarith [ht]⟩
  have h2 : Real.sqrt (9 / 4 + t * t) ≤ t + 3 := by
    have hA : 0 ≤ t + 3 := by nlinarith [ht]
    exact (Real.sqrt_le_iff).2 ⟨hA, by nlinarith [ht]⟩
  have h3 : Real.sqrt (25 / 4 + t * t) ≤ t + 3 := by
    have hA : 0 ≤ t + 3 := by nlinarith [ht]
    exact (Real.sqrt_le_iff).2 ⟨hA, by nlinarith [ht]⟩
  have hA : Real.sqrt (1 / 4 + t * t) * Real.sqrt (9 / 4 + t * t) ≤ (t + 3) * (t + 3) :=
    mul_le_mul h1 h2 (by positivity) (by nlinarith [ht])
  calc Real.sqrt (1 / 4 + t * t) * Real.sqrt (9 / 4 + t * t) * Real.sqrt (25 / 4 + t * t) =
      (Real.sqrt (1 / 4 + t * t) * Real.sqrt (9 / 4 + t * t)) * Real.sqrt (25 / 4 + t * t) := by ring
    _ ≤ ((t + 3) * (t + 3)) * Real.sqrt (25 / 4 + t * t) := by
      apply mul_le_mul_of_nonneg_right hA
      positivity
    _ ≤ ((t + 3) * (t + 3)) * (t + 3) := by
      apply mul_le_mul_of_nonneg_left h3
      nlinarith [ht]
    _ = (t + 3) ^ 3 := by ring

/-- ‖s·(s+1)·(s+2)‖ ≤ (t+3)³ for s = (1/2) + i t, t ≥ 0. -/
theorem hS3norm (t : ℝ) (ht : 0 ≤ t) :
    ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ ≤ (t + 3) ^ 3 := by
  set s := ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I with hs
  have h1 : s + 1 = ((3 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    rw [hs]
    apply Complex.ext
    · simp
      norm_num
    · norm_num
  have h2 : s + 2 = ((5 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    rw [hs]
    apply Complex.ext
    · simp
      norm_num
    · norm_num
  rw [h1, h2]
  have h3 : ‖s * (((3 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((5 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I)‖ =
      ‖s‖ * ‖((3 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ *
      ‖((5 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ := by
    rw [Complex.norm_mul, Complex.norm_mul]
  rw [h3, hNorm t, hNorm3 t, hNorm5 t]
  exact hS3bnd t ht

/-- ln x ≤ x/2 for x ≥ 1. -/
theorem hLogHalf (x : ℝ) (hx : 1 ≤ x) : Real.log x ≤ x / 2 := by
  by_cases h2 : x ≤ 2
  · have h1 : Real.log x ≤ x - 1 := Real.log_le_sub_one_of_pos (by nlinarith [hx])
    have h3 : x - 1 ≤ x / 2 := by linarith [h2]
    linarith [h1, h3]
  · have h2b : 2 < x := not_le.mp h2
    have hx2 : 0 < x / 2 := by
      apply div_pos (by nlinarith [h2b])
      norm_num
    have h1 : Real.log (x / 2) ≤ x / 2 - 1 := Real.log_le_sub_one_of_pos hx2
    have h3 : Real.log x = Real.log (x / 2) + Real.log 2 := by
      have h5 : x = (x / 2) * 2 := by ring
      have h6 : Real.log ((x / 2) * 2) = Real.log (x / 2) + Real.log 2 :=
        Real.log_mul (by nlinarith [hx2]) (by norm_num : (2 : ℝ) ≠ 0)
      rw [← h6]
      exact congrArg Real.log h5
    have h4 : Real.log 2 ≤ 1 := by
      linarith [Real.log_le_sub_one_of_pos (show 0 < (2 : ℝ) from by norm_num)]
    have h5 : Real.log x ≤ (x / 2 - 1) + 1 := by linarith [h3, h1, h4]
    linarith [h5]

/-- ln t ≤ t^{1/2} for t ≥ 1 (hLogHalf applied to √t). -/
theorem hLogSqrt (t : ℝ) (ht : 1 ≤ t) : Real.log t ≤ t ^ (1 / 2 : ℝ) := by
  have ht0 : 0 < t := by nlinarith [ht]
  have hy : t ^ (1 / 2 : ℝ) ≥ 1 := by
    by_contra h
    have h1 : t ^ (1 / 2 : ℝ) < 1 := by linarith [h]
    have h3 : t ^ (1 / 2 : ℝ) * (t ^ (1 / 2 : ℝ)) < 1 := by
      have h4 : t ^ (1 / 2 : ℝ) * (t ^ (1 / 2 : ℝ)) ≤ 1 * (t ^ (1 / 2 : ℝ)) :=
        mul_le_mul_of_nonneg_right h1.le (by positivity)
      have h5 : 1 * (t ^ (1 / 2 : ℝ)) < 1 := by nlinarith [h1]
      linarith [h4, h5]
    have h4 : (t ^ (1 / 2 : ℝ)) ^ 2 = t := by
      rw [pow_two, ← Real.rpow_add ht0 (1 / 2) (1 / 2)]
      rw [show (1 / 2 + 1 / 2 : ℝ) = 1 from by norm_num, Real.rpow_one]
    have h5 : t < 1 := by nlinarith [h3, h4]
    linarith [h5, ht]
  have h1 : Real.log (t ^ (1 / 2 : ℝ)) ≤ (t ^ (1 / 2 : ℝ)) / 2 := hLogHalf (t ^ (1 / 2 : ℝ)) hy
  have h2 : 2 * Real.log (t ^ (1 / 2 : ℝ)) = Real.log t := by
    have h3 : Real.log (t ^ (1 / 2 : ℝ)) = (1 / 2) * Real.log t := by
      rw [Real.log_rpow ht0 (1 / 2)]
    rw [h3]
    ring_nf
  calc Real.log t = 2 * Real.log (t ^ (1 / 2 : ℝ)) := by rw [h2]
    _ ≤ 2 * ((t ^ (1 / 2 : ℝ)) / 2) := by
      apply mul_le_mul_of_nonneg_left h1
      norm_num
    _ = t ^ (1 / 2 : ℝ) := by ring

/-- T0^{3/4} ≥ 6000 (hence T0^{−3/4} ≤ 1/6000).
    By contraposition: T0^{3/4} < 6000 → T0³ < 6000⁴, but 110000³ > 6000⁴. -/
theorem hT0p34 : (6000 : ℝ) ≤ T0 ^ (3 / 4 : ℝ) := by
  by_contra hn
  have h1 : T0 ^ (3 / 4 : ℝ) < 6000 := by linarith [hn]
  have h2 : (T0 ^ (3 / 4 : ℝ)) ^ 4 < (6000 : ℝ) ^ 4 :=
    pow_lt_pow_left₀ h1 (by
      have hpos : 0 < T0 := by norm_num [hT0val]
      positivity) (by norm_num)
  have h3 : (T0 ^ (3 / 4 : ℝ)) ^ 4 = T0 ^ 3 := by
    have h5 : 0 < T0 := by norm_num [hT0val]
    have hsq1 : (T0 ^ (3 / 4 : ℝ)) ^ 2 = T0 ^ (3 / 2 : ℝ) := by
      rw [pow_two, ← Real.rpow_add h5 (3 / 4) (3 / 4)]
      ring_nf
    have hsq2 : (T0 ^ (3 / 2 : ℝ)) ^ 2 = T0 ^ (3 : ℝ) := by
      rw [pow_two, ← Real.rpow_add h5 (3 / 2) (3 / 2)]
      congr
      norm_num
    calc (T0 ^ (3 / 4 : ℝ)) ^ 4 = ((T0 ^ (3 / 4 : ℝ)) ^ 2) ^ 2 := by ring
      _ = (T0 ^ (3 / 2 : ℝ)) ^ 2 := by rw [hsq1]
      _ = T0 ^ (3 : ℝ) := hsq2
      _ = T0 ^ 3 := (Real.rpow_natCast T0 3)
  have h4 : T0 ^ 3 < (6000 : ℝ) ^ 4 := by linarith [h2, h3]
  have h5 : (T0 : ℝ) ^ 3 = (110000 : ℝ) ^ 3 := by
    rw [hT0val]
  have h6 : (110000 : ℝ) ^ 3 ≥ (6000 : ℝ) ^ 4 := by
    norm_num
  linarith [h4, h5, h6]

/-- T0^{5/4} ≥ 1980000 (hence T0^{−5/4} ≤ 1/1980000).
    By contraposition: T0^{5/4} < 1980000 → T0⁵ < 1980000⁴, but 110000⁵ > 1980000⁴. -/
theorem hT0p54 : (1980000 : ℝ) ≤ T0 ^ (5 / 4 : ℝ) := by
  by_contra hn
  have h1 : T0 ^ (5 / 4 : ℝ) < (1980000 : ℝ) := by linarith [hn]
  have h2 : (T0 ^ (5 / 4 : ℝ)) ^ 4 < (1980000 : ℝ) ^ 4 :=
    pow_lt_pow_left₀ h1 (by
      have hpos : 0 < T0 := by norm_num [hT0val]
      positivity) (by norm_num)
  have h3 : (T0 ^ (5 / 4 : ℝ)) ^ 4 = T0 ^ 5 := by
    have h5 : 0 < T0 := by norm_num [hT0val]
    have hsq1 : (T0 ^ (5 / 4 : ℝ)) ^ 2 = T0 ^ (5 / 2 : ℝ) := by
      rw [pow_two, ← Real.rpow_add h5 (5 / 4) (5 / 4)]
      ring_nf
    have hsq2 : (T0 ^ (5 / 2 : ℝ)) ^ 2 = T0 ^ (5 : ℝ) := by
      rw [pow_two, ← Real.rpow_add h5 (5 / 2) (5 / 2)]
      congr
      norm_num
    calc (T0 ^ (5 / 4 : ℝ)) ^ 4 = ((T0 ^ (5 / 4 : ℝ)) ^ 2) ^ 2 := by ring
      _ = (T0 ^ (5 / 2 : ℝ)) ^ 2 := by rw [hsq1]
      _ = T0 ^ (5 : ℝ) := hsq2
      _ = T0 ^ 5 := (Real.rpow_natCast T0 5)
  have h4 : T0 ^ 5 < (1980000 : ℝ) ^ 4 := by linarith [h2, h3]
  have h5 : (T0 : ℝ) ^ 5 = (110000 : ℝ) ^ 5 := by
    rw [hT0val]
  have h6 : (110000 : ℝ) ^ 5 ≥ (1980000 : ℝ) ^ 4 := by
    norm_num
  linarith [h4, h5, h6]

/-- √T0 ≤ 332 (332² = 110224 ≥ 110000). -/
theorem hT0sqrt : Real.sqrt T0 ≤ (332 : ℝ) := by
  have h1 : T0 ≤ (332 : ℝ) ^ 2 := by
    rw [hT0val]
    norm_num
  have h2 : Real.sqrt T0 ≤ Real.sqrt ((332 : ℝ) ^ 2) := Real.sqrt_le_sqrt h1
  have h3 : Real.sqrt ((332 : ℝ) ^ 2) = (332 : ℝ) := Real.sqrt_sq (by norm_num)
  linarith [h2, h3]

/- — Stage B: p8_B term bounds — -/

/-- The floor factor: n(t) ≥ t²·Xfloor for t ≥ T0 (hFloorBase). -/
noncomputable def Xfloor : ℝ := 1 - 1 / (T0 * T0)

/-- 0 < Xfloor < 1. -/
theorem hXrange : 0 < Xfloor ∧ Xfloor < 1 := by
  have hT : 0 < T0 := by nlinarith [hT0val]
  have hhh : 0 < T0 * T0 := mul_pos hT hT
  constructor
  · rw [Xfloor]
    have h1 : 1 / (T0 * T0) < 1 :=
      (div_lt_one hhh).2 (by nlinarith [hT0val])
    linarith [h1]
  · rw [Xfloor]
    have h1 : 0 < 1 / (T0 * T0) := by positivity
    linarith [h1]

/-- Xfloor ≤ √Xfloor (since 0 < Xfloor ≤ 1). -/
theorem hXfsq : Xfloor ≤ Real.sqrt Xfloor := by
  have hpos : 0 < Xfloor := (hXrange).1
  have hle : Xfloor ≤ 1 := (hXrange).2.le
  apply le_of_sq_le_sq (by
    have h1 : (Real.sqrt Xfloor) ^ 2 = Xfloor := by
      rw [Real.sq_sqrt hpos.le]
    nlinarith [h1, hle]
  ) (by positivity)

theorem hXinv2 : Xfloor ^ (-2 : ℝ) = 1 / (Xfloor * Xfloor) := by
  have hpos : 0 < Xfloor := (hXrange).1
  have h1 : (Xfloor : ℝ) ^ (2 : ℝ) = Xfloor * Xfloor := by
    rw [show (2 : ℝ) = 1 + 1 from by norm_num,
        Real.rpow_add hpos 1 1, Real.rpow_one]
  rw [Real.rpow_neg hpos.le 2, h1]
  field_simp

theorem hXinv3 : Xfloor ^ (-3 : ℝ) = 1 / (Xfloor * Xfloor * Xfloor) := by
  have hpos : 0 < Xfloor := (hXrange).1
  have h2sq : (Xfloor : ℝ) ^ (2 : ℝ) = Xfloor * Xfloor := by
    rw [show (2 : ℝ) = 1 + 1 from by norm_num,
        Real.rpow_add hpos 1 1, Real.rpow_one]
  have h1 : (Xfloor : ℝ) ^ (3 : ℝ) = Xfloor * Xfloor * Xfloor := by
    rw [show (3 : ℝ) = 1 + 2 from by norm_num,
        Real.rpow_add hpos 1 2, Real.rpow_one, h2sq]
    ring
  rw [Real.rpow_neg hpos.le 3, h1]
  field_simp

/- — Shared one-shot facts for t ≥ T0 — -/

/-- 0 < T0. -/
theorem hSGT0pos : 0 < T0 := by
  nlinarith [hT0val]

section
variable {t : ℝ} (ht : T0 ≤ t)
include ht

/-- 0 < t. -/
theorem hSGtp : 0 < t := by
  nlinarith [hT0val, ht]

/-- 0 ≤ t. -/
theorem hSGtnn : 0 ≤ t := (hSGtp ht).le

/-- T0² ≤ t². -/
theorem hSGtsq : T0 * T0 ≤ t * t := by
  nlinarith [hT0val, ht, mul_self_nonneg t]

/-- T0³ ≤ t³. -/
theorem hSGtsq3 : T0 * T0 * T0 ≤ t * t * t := by
  have h2 : T0 * T0 ≤ t * t := hSGtsq ht
  have htpos := hSGtp ht
  nlinarith [h2, htpos]

/-- 0 < t²·Xfloor and √(t²·Xfloor) = t·√Xfloor. -/
theorem hSGfact : 0 < t * t * Xfloor ∧ Real.sqrt (t * t * Xfloor) = t * Real.sqrt Xfloor := by
  have hXpos : 0 < Xfloor := (hXrange).1
  have htpos := hSGtp ht
  constructor
  · exact mul_pos (mul_pos htpos htpos) hXpos
  · have hpos_t2 : 0 ≤ t * t := by positivity
    have hfactor : (t * t * Xfloor) ^ (1 / 2 : ℝ) =
        (t * t) ^ (1 / 2 : ℝ) * Xfloor ^ (1 / 2 : ℝ) := by
      rw [Real.mul_rpow hpos_t2 hXpos.le]
    have h1 : Real.sqrt (t * t * Xfloor) = Real.sqrt (t * t) * Real.sqrt Xfloor := by
      rw [Real.sqrt_eq_rpow (t * t * Xfloor), hfactor,
          Real.sqrt_eq_rpow (t * t), Real.sqrt_eq_rpow Xfloor]
    have h2 : Real.sqrt (t * t) = t := by
      rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq (hSGtnn ht)]
    rw [h1, h2]

end

/-- √3 ≤ 17321/10000. -/
theorem hSqrt3 : Real.sqrt 3 ≤ 17321 / 10000 := by
  have h1 : (Real.sqrt 3) ^ 2 = 3 := by rw [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]
  have h2 : 3 ≤ (17321 / 10000 : ℝ) ^ 2 := by norm_num
  exact le_of_sq_le_sq (by nlinarith [h1, h2]) (by norm_num)

/-- Stage B term 1: (1/2)·n^{−1/2} ≤ CG11 for t ≥ T0. -/
theorem hCG11 (t : ℝ) (ht : T0 ≤ t) :
    (1 / 2) * (nGrow t : ℝ) ^ (-1 / 2 : ℝ) ≤ CG11 := by
  have hnpos : 0 < (nGrow t : ℝ) := hFloorPos t ht
  have hbase : t * t * Xfloor ≤ (nGrow t : ℝ) := hFloorBase t ht
  have htpos := hSGtp ht
  have hXpos : 0 < Xfloor := (hXrange).1
  have hfactpos : 0 < t * t * Xfloor := (hSGfact ht).1
  have hfact : Real.sqrt (t * t * Xfloor) = t * Real.sqrt Xfloor := (hSGfact ht).2
  have hA : (nGrow t : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt (nGrow t : ℝ) := by
    rw [show (-1 / 2 : ℝ) = -(1 / 2) from by norm_num,
        Real.rpow_neg hnpos.le (1 / 2)]
    have h2 : (nGrow t : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (nGrow t : ℝ) :=
      (Real.sqrt_eq_rpow (nGrow t : ℝ)).symm
    rw [h2]
    field_simp
  have hB : (t * t * Xfloor) ^ (-1 / 2 : ℝ) = 1 / (t * Real.sqrt Xfloor) := by
    rw [show (-1 / 2 : ℝ) = -(1 / 2) from by norm_num,
        Real.rpow_neg hfactpos.le (1 / 2)]
    have h2 : (t * t * Xfloor) ^ (1 / 2 : ℝ) = Real.sqrt (t * t * Xfloor) :=
      (Real.sqrt_eq_rpow (t * t * Xfloor)).symm
    rw [h2, hfact]
    field_simp
  have hdec : (nGrow t : ℝ) ^ (-1 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-1 / 2 : ℝ) := by
    rw [hA, hB]
    apply one_div_le_one_div_of_le (by positivity)
    have hf2 : t * Real.sqrt Xfloor = Real.sqrt (t * t * Xfloor) := hfact.symm
    simpa [hf2] using Real.sqrt_le_sqrt hbase
  have hC : (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) =
      (1 / (2 * t)) * (1 / Real.sqrt Xfloor) := by
    rw [hB]
    have h1 : (1 / 2) * (1 / (t * Real.sqrt Xfloor)) =
        1 / (2 * t * Real.sqrt Xfloor) := by
      field_simp [htpos.ne']
    have h2 : (1 / (2 * t)) * (1 / Real.sqrt Xfloor) =
        1 / (2 * t * Real.sqrt Xfloor) := by
      field_simp [htpos.ne']
    rw [h1, h2]
  have hD : 1 / Real.sqrt Xfloor ≤ 1 / Xfloor :=
    one_div_le_one_div_of_le hXpos hXfsq
  have hE : (1 / (2 * t)) * (1 / Real.sqrt Xfloor) ≤ (1 / (2 * t)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_left hD (one_div_nonneg.2 (by nlinarith [htpos]))
  have hF : 1 / (2 * t) ≤ 1 / (2 * T0) := by
    apply one_div_le_one_div_of_le
    · exact mul_pos (by norm_num : (0 : ℝ) < 2) hSGT0pos
    · nlinarith [ht, hT0val]
  have hG : (1 / (2 * t)) * (1 / Xfloor) ≤ (1 / (2 * T0)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_right hF (one_div_nonneg.2 hXpos.le)
  calc (1 / 2) * (nGrow t : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hdec (by norm_num)
    _ = (1 / (2 * t)) * (1 / Real.sqrt Xfloor) := hC
    _ ≤ (1 / (2 * t)) * (1 / Xfloor) := hE
    _ ≤ (1 / (2 * T0)) * (1 / Xfloor) := hG
    _ ≤ CG11 := by
      norm_num [Xfloor, CG11, hT0val]

/-- Stage B term 2: (‖s‖/12)·n^{−3/2} ≤ CG12 for t ≥ T0. -/
theorem hCG12 (t : ℝ) (ht : T0 ≤ t) :
    (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) *
      (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤ CG12 := by
  have hnpos : 0 < (nGrow t : ℝ) := hFloorPos t ht
  have hbase : t * t * Xfloor ≤ (nGrow t : ℝ) := hFloorBase t ht
  have htpos := hSGtp ht
  have htnn := hSGtnn ht
  have htsq := hSGtsq ht
  have htsq3 := hSGtsq3 ht
  have hXpos : 0 < Xfloor := (hXrange).1
  have hfactpos : 0 < t * t * Xfloor := (hSGfact ht).1
  rw [hNorm t]
  have hnormb : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := hSbnd t htnn
  have hdiv : Real.sqrt (1 / 4 + t * t) / 12 ≤ (t + 1 / 2) / 12 := by
    nlinarith [hnormb]
  have hstep1 : (Real.sqrt (1 / 4 + t * t) / 12) *
      (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_right hdiv (Real.rpow_nonneg hnpos.le (-3 / 2))
  have hA3 : (nGrow t : ℝ) ^ (-3 / 2 : ℝ) = 1 / ((nGrow t : ℝ) ^ (3 / 2 : ℝ)) := by
    rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
        Real.rpow_neg hnpos.le (3 / 2)]
    field_simp
  have hB3 : (t * t * Xfloor) ^ (-3 / 2 : ℝ) = 1 / ((t * t * Xfloor) ^ (3 / 2 : ℝ)) := by
    rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
        Real.rpow_neg hfactpos.le (3 / 2)]
    field_simp
  have hexp2 : (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-3 / 2 : ℝ) := by
    rw [hA3, hB3]
    apply one_div_le_one_div_of_le
      (Real.rpow_pos_of_pos hfactpos (3 / 2))
    exact Real.rpow_le_rpow hfactpos.le hbase (by norm_num)
  have hstep2 : ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hexp2 (by positivity)
  have hmulr : (t * t * Xfloor) ^ (-3 / 2 : ℝ) =
      (t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ) := by
    rw [Real.mul_rpow (by positivity) hXpos.le]
  have htpow3 : (t * t) ^ (-3 / 2 : ℝ) = 1 / (t * t * t) := by
    rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
        Real.rpow_neg (by positivity) (3 / 2)]
    have h1 : (t * t) ^ (3 / 2 : ℝ) = t * t * t := by
      rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
          Real.rpow_add (by positivity) 1 (1 / 2)]
      have h2 : (t * t) ^ (1 / 2 : ℝ) = Real.sqrt (t * t) := by
        rw [Real.sqrt_eq_rpow (t * t)]
      have h3 : Real.sqrt (t * t) = t := by
        rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq htnn]
      rw [h2, h3, Real.rpow_one]
    rw [h1]
    field_simp
  have hx32 : Xfloor * Real.sqrt Xfloor = Xfloor ^ (3 / 2 : ℝ) := by
    rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
        Real.rpow_add hXpos 1 (1 / 2), Real.rpow_one]
    have h3 : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
      rw [Real.sqrt_eq_rpow Xfloor]
    rw [h3]
  have hxi_inv : Xfloor ^ (-3 / 2 : ℝ) ≤ Xfloor ^ (-2 : ℝ) := by
    have hL : Xfloor ^ (-3 / 2 : ℝ) = 1 / (Xfloor ^ (3 / 2 : ℝ)) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
          Real.rpow_neg hXpos.le (3 / 2)]
      field_simp
    rw [hL, hXinv2]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor ≤ Xfloor * Real.sqrt Xfloor :=
      mul_le_mul_of_nonneg_left hXfsq (by positivity)
    simpa [hx32] using h1
  have hstep3 : ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) := by
    have h3a : ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) =
        ((t + 1 / 2) / 12) * ((t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ)) := by
      rw [hmulr]
    rw [h3a]
    have h3b : ((t + 1 / 2) / 12) * ((t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ)) =
        (((t + 1 / 2) / 12) * (t * t) ^ (-3 / 2 : ℝ)) * Xfloor ^ (-3 / 2 : ℝ) := by
      ring
    rw [h3b]
    have h3c : ((t + 1 / 2) / 12) * (t * t) ^ (-3 / 2 : ℝ) ≤
        ((t + 1 / 2) / 12) * (1 / (t * t * t)) :=
      mul_le_mul_of_nonneg_left htpow3.le (by positivity)
    exact mul_le_mul_of_nonneg_right h3c (Real.rpow_nonneg hXpos.le (-3 / 2))
  have hstep4 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) :=
    mul_le_mul_of_nonneg_left hxi_inv (by positivity)
  have hsplit : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
      (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := by
    field_simp [htpos.ne']
  have hsumub : 1 / (t * t) + 1 / (2 * t * t * t) ≤
      1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0)) := by
    have h2 : 1 / (2 * t * t * t) = (1 / 2) * (1 / (t * t * t)) := by
      field_simp [htpos.ne']
    have hT2 : 0 < T0 * T0 := mul_pos hSGT0pos hSGT0pos
    have hT3 : 0 < T0 * T0 * T0 := mul_pos hT2 hSGT0pos
    have hinv2 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
      apply one_div_le_one_div_of_le
      · exact hT2
      · exact htsq
    have hinv3 : 1 / (t * t * t) ≤ 1 / (T0 * T0 * T0) := by
      apply one_div_le_one_div_of_le
      · exact hT3
      · exact htsq3
    have h3 : (1 / 2) * (1 / (t * t * t)) ≤ (1 / 2) * (1 / (T0 * T0 * T0)) :=
      mul_le_mul_of_nonneg_left hinv3 (by norm_num)
    simpa [h2] using add_le_add hinv2 h3
  have htail : (1 / (t * t) + 1 / (2 * t * t * t)) / 12 ≤
      (1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0))) / 12 := by
    nlinarith [hsumub]
  have hform : (1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0))) / 12 =
      (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 := by
    field_simp
  calc (Real.sqrt (1 / 4 + t * t) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ)
      ≤ ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) := hstep1
    _ ≤ ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) := hstep2
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) := hstep3
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) := hstep4
    _ = (1 / (t * t) + 1 / (2 * t * t * t)) / 12 * Xfloor ^ (-2 : ℝ) := by
      rw [show ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
        (1 / (t * t) + 1 / (2 * t * t * t)) / 12 from hsplit]
    _ ≤ (1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0))) / 12 * Xfloor ^ (-2 : ℝ) :=
      mul_le_mul_of_nonneg_right htail (Real.rpow_nonneg hXpos.le (-2))
    _ = (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * Xfloor ^ (-2 : ℝ) := by
      rw [show (1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0))) / 12 =
        (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 from hform]
    _ = (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * (1 / (Xfloor * Xfloor)) := by
      rw [hXinv2]
    _ ≤ CG12 := by
      norm_num [Xfloor, CG12, hT0val]

/-- Stage B term 3: (√3/540)·‖s(s+1)(s+2)‖·n^{−5/2} ≤ CG13 for t ≥ T0. -/
theorem hCG13 (t : ℝ) (ht : T0 ≤ t) :
    (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤ CG13 := by
  have hnpos : 0 < (nGrow t : ℝ) := hFloorPos t ht
  have hbase : t * t * Xfloor ≤ (nGrow t : ℝ) := hFloorBase t ht
  have htpos := hSGtp ht
  have htnn := hSGtnn ht
  have htsq := hSGtsq ht
  have hXpos : 0 < Xfloor := (hXrange).1
  have hfactpos : 0 < t * t * Xfloor := (hSGfact ht).1
  have hsqrt3d : Real.sqrt 3 / 540 ≤ (17321 / 10000) / 540 := by
    nlinarith [hSqrt3]
  have hstep0 : (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) := by
    have h1 : Real.sqrt 3 / 540 *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
            (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
            (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ ≤
        Real.sqrt 3 / 540 * (t + 3) ^ 3 :=
      mul_le_mul_of_nonneg_left (hS3norm t htnn)
        (div_nonneg (Real.sqrt_nonneg 3) (by norm_num))
    exact mul_le_mul_of_nonneg_right h1 (Real.rpow_nonneg hnpos.le (-5 / 2))
  have hstep1 : (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) := by
    have h1 : Real.sqrt 3 / 540 * (t + 3) ^ 3 ≤
        (17321 / 10000) / 540 * (t + 3) ^ 3 :=
      mul_le_mul_of_nonneg_right hsqrt3d (pow_nonneg (add_nonneg htnn (by norm_num : (0 : ℝ) ≤ 3)) 3)
    exact mul_le_mul_of_nonneg_right h1 (Real.rpow_nonneg hnpos.le (-5 / 2))
  have hA5 : (nGrow t : ℝ) ^ (-5 / 2 : ℝ) = 1 / ((nGrow t : ℝ) ^ (5 / 2 : ℝ)) := by
    rw [show (-5 / 2 : ℝ) = -(5 / 2) from by norm_num,
        Real.rpow_neg hnpos.le (5 / 2)]
    field_simp
  have hB5 : (t * t * Xfloor) ^ (-5 / 2 : ℝ) = 1 / ((t * t * Xfloor) ^ (5 / 2 : ℝ)) := by
    rw [show (-5 / 2 : ℝ) = -(5 / 2) from by norm_num,
        Real.rpow_neg hfactpos.le (5 / 2)]
    field_simp
  have hexp2 : (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-5 / 2 : ℝ) := by
    rw [hA5, hB5]
    apply one_div_le_one_div_of_le
      (Real.rpow_pos_of_pos hfactpos (5 / 2))
    exact Real.rpow_le_rpow hfactpos.le hbase (by norm_num)
  have hstep2 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hexp2
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
        (pow_nonneg (add_nonneg htnn (by norm_num : (0 : ℝ) ≤ 3)) 3))
  have hmulr : (t * t * Xfloor) ^ (-5 / 2 : ℝ) =
      (t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ) := by
    rw [Real.mul_rpow (by positivity) hXpos.le]
  have htpow5 : (t * t) ^ (-5 / 2 : ℝ) = 1 / (t * t * t * t * t) := by
    rw [show (-5 / 2 : ℝ) = -(5 / 2) from by norm_num,
        Real.rpow_neg (by positivity) (5 / 2)]
    have h1 : (t * t) ^ (5 / 2 : ℝ) = t * t * t * t * t := by
      rw [show (5 / 2 : ℝ) = 2 + 1 / 2 from by norm_num,
          Real.rpow_add (by positivity) 2 (1 / 2)]
      have h2 : (t * t) ^ (1 / 2 : ℝ) = Real.sqrt (t * t) := by
        rw [Real.sqrt_eq_rpow (t * t)]
      have h3 : Real.sqrt (t * t) = t := by
        rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq htnn]
      have h4 : (t * t) ^ (2 : ℝ) = t * t * t * t := by
        rw [show (2 : ℝ) = 1 + 1 from by norm_num,
            Real.rpow_add (by positivity) 1 1, Real.rpow_one]
        ring
      rw [h4, h2, h3]
    rw [h1]
    field_simp
  have hx52 : Xfloor * Xfloor * Real.sqrt Xfloor = Xfloor ^ (5 / 2 : ℝ) := by
    rw [show (5 / 2 : ℝ) = 2 + 1 / 2 from by norm_num,
        Real.rpow_add hXpos 2 (1 / 2)]
    have h2a : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
      rw [Real.sqrt_eq_rpow Xfloor]
    have h2b : Xfloor ^ (2 : ℝ) = Xfloor * Xfloor := by
      rw [show (2 : ℝ) = 1 + 1 from by norm_num,
          Real.rpow_add hXpos 1 1, Real.rpow_one]
    rw [h2b, h2a]
  have hxi_inv : Xfloor ^ (-5 / 2 : ℝ) ≤ Xfloor ^ (-3 : ℝ) := by
    have hL : Xfloor ^ (-5 / 2 : ℝ) = 1 / (Xfloor ^ (5 / 2 : ℝ)) := by
      rw [show (-5 / 2 : ℝ) = -(5 / 2) from by norm_num,
          Real.rpow_neg hXpos.le (5 / 2)]
      field_simp
    rw [hL, hXinv3]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor * Xfloor ≤ Xfloor * Xfloor * Real.sqrt Xfloor :=
      mul_le_mul_of_nonneg_left hXfsq (by positivity)
    simpa [hx52] using h1
  have hstep3 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) := by
    have h3a : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) =
        ((17321 / 10000) / 540) * (t + 3) ^ 3 *
          ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) := by
      rw [hmulr]
    rw [h3a]
    have h3b : ((17321 / 10000) / 540) * (t + 3) ^ 3 *
        ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) =
      (((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t) ^ (-5 / 2 : ℝ)) *
        Xfloor ^ (-5 / 2 : ℝ) := by
      ring
    rw [h3b]
    have h3c : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t) ^ (-5 / 2 : ℝ) ≤
        ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) :=
      mul_le_mul_of_nonneg_left htpow5.le
        (mul_nonneg (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
          (pow_nonneg (add_nonneg htnn (by norm_num : (0 : ℝ) ≤ 3)) 3))
    exact mul_le_mul_of_nonneg_right h3c (Real.rpow_nonneg hXpos.le (-5 / 2))
  have hstep4 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_left hxi_inv
      (mul_nonneg
        (mul_nonneg (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
          (pow_nonneg (add_nonneg htnn (by norm_num : (0 : ℝ) ≤ 3)) 3))
        (by positivity))
  have htp1 : (t + 3) ^ 3 / (t * t * t * t * t) ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
    have h1 : (t + 3) / t = 1 + 3 / t := by
      field_simp [htpos.ne']
    have h2 : t⁻¹ ≤ T0⁻¹ := by
      rw [← one_div, ← one_div]
      exact one_div_le_one_div_of_le hSGT0pos ht
    have h3 : 3 / t ≤ 3 / T0 :=
      mul_le_mul_of_nonneg_left h2 (by norm_num : (0 : ℝ) ≤ 3)
    have h4 : 1 + 3 / t ≤ 1 + 3 / T0 := add_le_add_right h3 1
    have h5 : ((t + 3) / t) ^ 3 ≤ (1 + 3 / T0) ^ 3 := by
      simpa [h1] using pow_le_pow_left₀ (by positivity) h4 3
    have h6 : (t + 3) ^ 3 / (t * t * t * t * t) = ((t + 3) / t) ^ 3 / (t * t) := by
      field_simp [htpos.ne']
    have h7 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
      apply one_div_le_one_div_of_le
      · exact mul_pos hSGT0pos hSGT0pos
      · exact htsq
    have h8 : ((t + 3) / t) ^ 3 / (t * t) ≤ ((t + 3) / t) ^ 3 / (T0 * T0) := by
      have h8a : ((t + 3) / t) ^ 3 / (t * t) =
          ((t + 3) / t) ^ 3 * (1 / (t * t)) := by simp [div_eq_mul_inv]
      have h8b : ((t + 3) / t) ^ 3 / (T0 * T0) =
          ((t + 3) / t) ^ 3 * (1 / (T0 * T0)) := by simp [div_eq_mul_inv]
      rw [h8a, h8b]
      exact mul_le_mul_of_nonneg_left h7 (by positivity)
    have h9 : ((t + 3) / t) ^ 3 / (T0 * T0) ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
      have h9a : ((t + 3) / t) ^ 3 / (T0 * T0) =
          ((t + 3) / t) ^ 3 * (1 / (T0 * T0)) := by simp [div_eq_mul_inv]
      have h9b : (1 + 3 / T0) ^ 3 / (T0 * T0) =
          (1 + 3 / T0) ^ 3 * (1 / (T0 * T0)) := by simp [div_eq_mul_inv]
      rw [h9a, h9b]
      exact mul_le_mul_of_nonneg_right h5
        (one_div_nonneg.2 (by norm_num [hT0val] : 0 ≤ T0 * T0))
    calc (t + 3) ^ 3 / (t * t * t * t * t)
        = ((t + 3) / t) ^ 3 / (t * t) := h6
      _ ≤ ((t + 3) / t) ^ 3 / (T0 * T0) := h8
      _ ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := h9
  have htp1eq : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) =
      ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) := by
    field_simp [htpos.ne']
  have hstep6a : ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) ≤
      ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) :=
    mul_le_mul_of_nonneg_left htp1 (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
  have hstep6 : ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) ≤
      ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_right hstep6a (Real.rpow_nonneg hXpos.le (-3))
  calc (Real.sqrt 3 / 540) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
        (nGrow t : ℝ) ^ (-5 / 2 : ℝ)
      ≤ (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) := hstep0
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) := hstep1
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) := hstep2
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
          Xfloor ^ (-5 / 2 : ℝ) := hstep3
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
          Xfloor ^ (-3 : ℝ) := hstep4
    _ = ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
          Xfloor ^ (-3 : ℝ) := by
      rw [← htp1eq]
    _ ≤ ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
          Xfloor ^ (-3 : ℝ) := hstep6
    _ = ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
          (1 / (Xfloor * Xfloor * Xfloor)) := by
      rw [hXinv3]
    _ ≤ CG13 := by
      norm_num [Xfloor, CG13, hT0val]

/- — Stage C: Xgrow (the b3BoundExplicit wire) bound — -/

/-- ln t ≥ 1 for t ≥ T0 (since exp 1 ≤ 3 ≤ 110000 ≤ t). -/
theorem hLogT1 (t : ℝ) (ht : T0 ≤ t) : 1 ≤ Real.log t := by
  have htpos := hSGtp ht
  have h1 : Real.exp 1 < t := by
    linarith [S4W.hE3, hT0val, ht]
  have h2 : Real.log (Real.exp 1) = 1 := by rw [Real.log_exp]
  have h3 : Real.log (Real.exp 1) < Real.log t := Real.log_lt_log (Real.exp_pos 1) h1
  linarith [h2, h3]

/-- Bf(t, t²) ≤ (2 + 1/T0 + 1/T0²)/t² for t ≥ T0. -/
theorem hBfUB (t : ℝ) (ht : T0 ≤ t) :
    Bf t (Ggrow t) ≤ (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := by
  have htpos := hSGtp ht
  have hT0p : 0 < T0 := hSGT0pos
  have hDpos : 0 < t * t * t * t + 1 / 4 := by positivity
  have hDm : 0 < t * t * t * t - t * t := by
    have ht2 : 1 < t * t := by nlinarith [hT0val, hSGtsq ht]
    have h1 : t * t - 1 > 0 := by linarith
    nlinarith [h1, htpos]
  have hwd : w t = t * t + 1 / 4 := by rfl
  have hpd1 : 1 - w t / (t * t * t * t + 1 / 4) =
      (t * t * t * t - t * t) / (t * t * t * t + 1 / 4) := by
    rw [hwd]
    field_simp [hDpos.ne']
    ring_nf
  have hpd2 : (w t / (t * t * t * t + 1 / 4)) /
        (1 - w t / (t * t * t * t + 1 / 4)) =
      w t / (t * t * t * t - t * t) := by
    rw [hpd1]
    field_simp [hDpos.ne', hDm.ne']
  have hp2 : (w t / (t * t * t * t + 1 / 4)) / (1 - w t / (t * t * t * t + 1 / 4)) =
      (t * t + 1 / 4) / (t * t * t * t - t * t) := by
    rw [hpd2, hwd]
  have h1 : 1 / (2 * (t * t * t * t + 1 / 4)) ≤ 1 / (2 * t * t * t * t) := by
    have h1a : 0 < 2 * t * t * t * t := by positivity
    have h1d : 2 * (t * t * t * t + 1 / 4) = 2 * t * t * t * t + 1 / 2 := by ring
    have h1b : 2 * t * t * t * t ≤ 2 * (t * t * t * t + 1 / 4) := by
      nlinarith [h1d]
    exact one_div_le_one_div_of_le h1a h1b
  have h3 : t / (t * t * t * t + 1 / 4) ≤ 1 / (t * t * t) := by
    have h1 : 1 / (t * t * t * t + 1 / 4) ≤ 1 / (t * t * t * t) :=
      one_div_le_one_div_of_le (by positivity) (by nlinarith)
    have h2 : t / (t * t * t * t + 1 / 4) ≤ t / (t * t * t * t) := by
      have h2a : t / (t * t * t * t + 1 / 4) = t * (1 / (t * t * t * t + 1 / 4)) := by ring
      have h2b : t / (t * t * t * t) = t * (1 / (t * t * t * t)) := by ring
      rw [h2a, h2b]
      exact mul_le_mul_of_nonneg_left h1 (by positivity)
    have h3b : t / (t * t * t * t) = 1 / (t * t * t) := by
      field_simp [htpos.ne']
    rw [h3b] at h2
    exact h2
  have hnumub : t * t + 1 / 4 ≤ 2 * (t * t - 1) := by
    nlinarith [hT0val, hSGtsq ht]
  have hp2b : (t * t + 1 / 4) / (t * t * t * t - t * t) ≤ 2 / (t * t) := by
    have h2 : (2 * (t * t - 1)) / (t * t * t * t - t * t) = 2 / (t * t) := by
      have h2a : (2 * (t * t - 1)) * (t * t) = 2 * (t * t * t * t - t * t) := by ring
      rw [div_eq_div_iff hDm.ne' ((by positivity : 0 < t * t).ne')]
      exact h2a
    have h1 : (t * t + 1 / 4) / (t * t * t * t - t * t) ≤
        (2 * (t * t - 1)) / (t * t * t * t - t * t) :=
      mul_le_mul_of_nonneg_right hnumub (by positivity)
    calc (t * t + 1 / 4) / (t * t * t * t - t * t)
        ≤ (2 * (t * t - 1)) / (t * t * t * t - t * t) := h1
      _ = 2 / (t * t) := h2
  have hb : Bf t (Ggrow t) =
      1 / (2 * (t * t * t * t + 1 / 4)) +
      (t * t + 1 / 4) / (t * t * t * t - t * t) + t / (t * t * t * t + 1 / 4) := by
    have hg : Ggrow t = t * t := by rfl
    unfold Bf
    rw [show (Ggrow t : ℝ) * (Ggrow t : ℝ) = (t * t) * (t * t) from by rw [hg],
        show ((t * t) * (t * t) : ℝ) = t * t * t * t from by ring, hp2]
  have hfin : 2 / (t * t) + 1 / (t * t * t) + 1 / (2 * t * t * t * t) ≤
      (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := by
    have h1 : 1 / (t * t * t) ≤ 1 / (T0 * t * t) := by
      have h1a : T0 * t * t ≤ t * t * t := by
        have h1b : T0 * t ≤ t * t := mul_le_mul_of_nonneg_right ht (by positivity)
        nlinarith [h1b, htpos]
      exact (one_div_le_one_div_of_le (by positivity) h1a)
    have h2 : 1 / (2 * t * t * t * t) ≤ 1 / (T0 * T0 * t * t) := by
      have h2a : T0 * T0 * t * t ≤ 2 * t * t * t * t := by
        have h2b : T0 * T0 ≤ 2 * t * t := by nlinarith [hSGtsq ht]
        nlinarith [h2b, htpos]
      exact (one_div_le_one_div_of_le (by positivity) h2a)
    have hR : (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) =
        2 / (t * t) + 1 / (T0 * t * t) + 1 / (T0 * T0 * t * t) := by
      field_simp [htpos.ne', hT0p]
    rw [hR]
    nlinarith [h1, h2]
  calc Bf t (Ggrow t)
      = 1 / (2 * (t * t * t * t + 1 / 4)) +
        (t * t + 1 / 4) / (t * t * t * t - t * t) + t / (t * t * t * t + 1 / 4) := hb
    _ ≤ 1 / (2 * t * t * t * t) + 2 / (t * t) + 1 / (t * t * t) := by
      gcongr <;> assumption
    _ ≤ 2 / (t * t) + 1 / (t * t * t) + 1 / (2 * t * t * t * t) := by
      exact le_of_eq (by abel)
    _ ≤ (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := hfin

/-- Sbar(2t²) + Sbar(t²) ≤ 2·ln t + 11 for t ≥ T0. -/
theorem hSSumUB (t : ℝ) (ht : T0 ≤ t) :
    Sbar (Bgrow t) + Sbar (Ggrow t) ≤ 2 * Real.log t + 11 := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hLpos : 0 < Real.log t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) hL
  have hln2p : Real.log 2 ≤ 2 - 1 := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)
  have hln2 : Real.log 2 ≤ 1 := by nlinarith [hln2p]
  have hln2pos : 0 < Real.log 2 := Real.log_pos (by norm_num : (1 : ℝ) < 2)
  have hln2L : Real.log (2 * Real.log t) ≤ 1 + Real.log (Real.log t) := by
    have h1 : Real.log (2 * Real.log t) = Real.log 2 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hLpos.ne']
    rw [h1]
    nlinarith [hln2]
  have hlnL2 : Real.log (Real.log 2 + 2 * Real.log t) ≤ 2 + Real.log (Real.log t) := by
    have h1 : Real.log 2 + 2 * Real.log t ≤ 3 * Real.log t := by
      nlinarith [hln2, hL]
    have h2 : Real.log (Real.log 2 + 2 * Real.log t) ≤ Real.log (3 * Real.log t) :=
      Real.log_le_log (by nlinarith [hln2pos, hLpos]) h1
    have h3 : Real.log (3 * Real.log t) = Real.log 3 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (3 : ℝ) ≠ 0) hLpos.ne']
    have h4p : Real.log 3 ≤ 3 - 1 := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 3)
    have h4 : Real.log 3 ≤ 2 := by nlinarith [h4p]
    nlinarith [h2, h3, h4]
  have hlnLub : Real.log (Real.log t) ≤ Real.log t / 2 := hLogHalf (Real.log t) hL
  have hexp : Sbar (Bgrow t) + Sbar (Ggrow t) =
      (44 / 100) * Real.log t + 0.110 * Real.log 2 + 0.290 * Real.log (2 * Real.log t) +
      0.290 * Real.log (Real.log 2 + 2 * Real.log t) + (458 / 100) := by
    unfold Sbar Ggrow Bgrow
    have h1 : Real.log (t * t) = 2 * Real.log t := by
      rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
      ring
    have h2 : Real.log (2 * t * t) = Real.log 2 + 2 * Real.log t := by
      rw [show (2 * t * t : ℝ) = 2 * (t * t) from by ring,
          Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) ((by positivity : 0 < t * t).ne'), h1]
    have h3 : Real.log (Real.log (t * t)) = Real.log (2 * Real.log t) := by rw [h1]
    have h4 : Real.log (Real.log (2 * t * t)) = Real.log (Real.log 2 + 2 * Real.log t) := by
      rw [h2]
    rw [h4, h2, h3, h1]
    ring_nf
  rw [hexp]
  have hmid : (44 / 100) * Real.log t + 0.110 * Real.log 2 + 0.290 * Real.log (2 * Real.log t) +
      0.290 * Real.log (Real.log 2 + 2 * Real.log t) + 458 / 100 ≤
      Real.log t + 11 := by
    nlinarith [hln2, hln2L, hlnL2, hlnLub, hL]
  nlinarith [hmid, hL]

/-- Cf(t, t²) ≤ 2t² + 9/2 + 5/t² for t ≥ T0. -/
theorem hCfUB (t : ℝ) (ht : T0 ≤ t) :
    Cf t (Ggrow t) ≤ 2 * t * t + 9 / 2 + 5 / (t * t) := by
  have htpos := hSGtp ht
  have hDm : 0 < t * t - 1 := by
    have ht2 : 1 < t * t := by nlinarith [hT0val, hSGtsq ht]
    linarith
  have hc : Cf t (Ggrow t) = 2 * t * t + 7 / 2 + 5 / (2 * (t * t - 1)) := by
    have h1 : Ggrow t = t * t := by rfl
    have h2 : w t = t * t + 1 / 4 := by rfl
    unfold Cf
    rw [show (Ggrow t : ℝ) = t * t from h1, h2]
    have hden : (t * t * (t * t) - t * t : ℝ) = t * t * (t * t - 1) := by ring
    rw [hden]
    have hnum : 2 * (t * t + 1 / 4) * ((t * t) * (t * t)) =
        (t * t) * (t * t) * (2 * t * t + 1 / 2) := by ring
    rw [hnum]
    have hc1 : (t * t) * (t * t) * (2 * t * t + 1 / 2) / (t * t * (t * t - 1)) =
        (t * t) * (2 * t * t + 1 / 2) / (t * t - 1) := by
      have htt : 0 < t * t := by positivity
      field_simp [htt.ne', hDm.ne']
    rw [hc1]
    have hfrac : (t * t) * (2 * t * t + 1 / 2) / (t * t - 1) =
        2 * t * t + 5 / 2 + 5 / (2 * (t * t - 1)) := by
      field_simp [hDm.ne']
      have hnum2 : t ^ 2 * (t ^ 2 * 2 ^ 2 + 1) = 4 * t ^ 4 + t ^ 2 := by ring
      rw [hnum2]
      have hdiv : 4 * t ^ 4 + t ^ 2 = (t ^ 2 * 2 ^ 2 + 5) * (t ^ 2 - 1) + 5 := by ring
      rw [hdiv]
      have hadd : ((t ^ 2 * 2 ^ 2 + 5) * (t ^ 2 - 1) + 5) / (t ^ 2 - 1) =
          (t ^ 2 * 2 ^ 2 + 5) * (t ^ 2 - 1) / (t ^ 2 - 1) + 5 / (t ^ 2 - 1) := by
        field_simp [hDm.ne']
      rw [hadd]
      have hA : (t ^ 2 * 2 ^ 2 + 5) * (t ^ 2 - 1) / (t ^ 2 - 1) = t ^ 2 * 2 ^ 2 + 5 := by
        field_simp [hDm.ne']
        exact div_self (by simpa [pow_two] using hDm.ne')
      rw [hA]
    rw [hfrac]
    ring
  rw [hc]
  have h1 : t * t ≤ 2 * (t * t - 1) := by
    nlinarith [hT0val, hSGtsq ht]
  have h2 : 1 / (2 * (t * t - 1)) ≤ 1 / (t * t) :=
    one_div_le_one_div_of_le (by positivity) h1
  have h3 : 5 / (2 * (t * t - 1)) ≤ 5 / (t * t) := by
    have h3a : 5 / (2 * (t * t - 1)) = 5 * (1 / (2 * (t * t - 1))) := by ring
    have h3b : 5 / (t * t) = 5 * (1 / (t * t)) := by ring
    rw [h3a, h3b]
    exact mul_le_mul_of_nonneg_left h2 (by norm_num)
  nlinarith [h3]

/-- Kbar(t²) ≤ (0.51·ln t + 2.78)/(2t⁴) for t ≥ T0. -/
theorem hKbarUB (t : ℝ) (ht : T0 ≤ t) :
    Kbar (Ggrow t) ≤ (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hLpos : 0 < Real.log t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) hL
  have h1 : Real.log (t * t) = 2 * Real.log t := by
    rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
    ring
  have h2 : Real.log (Real.log (t * t)) = Real.log (2 * Real.log t) := by rw [h1]
  have hlog2p : Real.log 2 ≤ 2 - 1 := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)
  have hlog2 : Real.log 2 ≤ 1 := by nlinarith [hlog2p]
  have hln2L : Real.log (2 * Real.log t) ≤ 1 + Real.log (Real.log t) := by
    have h1b : Real.log (2 * Real.log t) = Real.log 2 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hLpos.ne']
    rw [h1b]
    nlinarith [hlog2]
  have hlnLub : Real.log (Real.log t) ≤ Real.log t / 2 := hLogHalf (Real.log t) hL
  have heq : Kbar (Ggrow t) =
      (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290) / (2 * t * t * t * t) := by
    unfold Kbar Ggrow
    rw [h2, h1, show (2 * (t * t) * (t * t) : ℝ) = 2 * t * t * t * t from by ring]
  rw [heq]
  have hnum : 0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
      2.290 ≤ 0.51 * Real.log t + 2.78 := by
    have h3 : 0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290 = 0.22 * Real.log t + 0.29 * Real.log (2 * Real.log t) + 2.49 := by
      ring
    rw [h3]
    have h4 : 0.22 * Real.log t + 0.29 * (1 + Real.log (Real.log t)) + 2.49 ≤
        0.51 * Real.log t + 2.78 := by
      nlinarith [hlnLub]
    nlinarith [h4, hln2L]
  have hd : 0 < 2 * t * t * t * t := by positivity
  calc (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
      2.290) / (2 * t * t * t * t)
      ≤ (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) := by
        rw [div_le_div_iff₀ hd hd]
        nlinarith [hnum]

theorem hDfrac (t : ℝ) (ht : T0 ≤ t) :
    (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) ≤
      (1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0)) / (t * t) := by
  have htpos := hSGtp ht
  have hT0p : 0 < T0 := hSGT0pos
  have hlhs : (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) =
      1 / (t * t) + 9 / (4 * t * t * t * t) + 5 / (2 * t * t * t * t * t * t) := by
    field_simp [htpos.ne']
    ring
  have hrs : (1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0)) / (t * t) =
      1 / (t * t) + 9 / (4 * T0 * T0 * t * t) + 5 / (2 * T0 * T0 * T0 * T0 * t * t) := by
    field_simp [htpos.ne', hT0p]
  rw [hlhs, hrs]
  have h1 : 9 / (4 * t * t * t * t) ≤ 9 / (4 * T0 * T0 * t * t) := by
    have h1a : 4 * T0 * T0 * t * t ≤ 4 * t * t * t * t := by gcongr
    have h1b : (4 * t * t * t * t)⁻¹ ≤ (4 * T0 * T0 * t * t)⁻¹ := by
      simpa using one_div_le_one_div_of_le (by positivity) h1a
    exact mul_le_mul_of_nonneg_left h1b (by norm_num : (0 : ℝ) ≤ 9)
  have h2 : 5 / (2 * t * t * t * t * t * t) ≤ 5 / (2 * T0 * T0 * T0 * T0 * t * t) := by
    have h2a : 2 * T0 * T0 * T0 * T0 * t * t ≤ 2 * t * t * t * t * t * t := by gcongr
    have h2b : (2 * t * t * t * t * t * t)⁻¹ ≤ (2 * T0 * T0 * T0 * T0 * t * t)⁻¹ := by
      simpa using one_div_le_one_div_of_le (by positivity) h2a
    exact mul_le_mul_of_nonneg_left h2b (by norm_num : (0 : ℝ) ≤ 5)
  have h3 : 1 / (t * t) ≤ 1 / (t * t) := le_rfl
  apply add_le_add
  · apply add_le_add
    · exact le_of_eq rfl
    · exact h1
  · exact h2

/-- The main X bound: Xgrow t ≤ XUBfun t = (4.98·ln t + 26.55)/t² for t ≥ T0. -/
theorem hXub (t : ℝ) (ht : T0 ≤ t) : Xgrow t ≤ XUBfun t := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hBf := hBfUB t ht
  have hS := hSSumUB t ht
  have hC := hCfUB t ht
  have hK := hKbarUB t ht
  have hD := hDfrac t ht
  have hS0 : 0 ≤ Sbar (Bgrow t) + Sbar (Ggrow t) := by
    have h1 : 1 < Real.log (2 * t * t) := by
      have h1a : Real.log (2 * t * t) = Real.log 2 + 2 * Real.log t := by
        rw [show (2 * t * t : ℝ) = 2 * (t * t) from by ring,
            Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) ((by positivity : 0 < t * t).ne'),
            Real.log_mul htpos.ne' htpos.ne']
        ring
      rw [h1a]
      nlinarith [hL, Real.log_pos (by norm_num : (1 : ℝ) < 2)]
    have h2 : 0 < Real.log (Real.log (2 * t * t)) := Real.log_pos h1
    have h3 : 1 < 2 * Real.log t := by nlinarith [hL]
    have h4 : 0 < Real.log (2 * Real.log t) := Real.log_pos h3
    have h5 : 1 < Real.log (t * t) := by
      have h5a : Real.log (t * t) = 2 * Real.log t := by
        rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
        ring
      rw [h5a]
      nlinarith [hL]
    have h6 : 0 < Real.log (Real.log (t * t)) := Real.log_pos h5
    unfold Sbar Bgrow Ggrow
    refine add_nonneg ?_ ?_
    · nlinarith [h1, h2]
    · nlinarith [h3, h4, h5, h6]
  have hK0 : 0 ≤ Kbar (Ggrow t) := by
    unfold Kbar Ggrow
    have h1 : 1 < Real.log (t * t) := by
      have h1a : Real.log (t * t) = 2 * Real.log t := by
        rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
        ring
      rw [h1a]
      nlinarith [hL]
    have h2 : 0 < Real.log (Real.log (t * t)) := Real.log_pos h1
    refine div_nonneg ?_ (by positivity)
    nlinarith [h1, h2]
  have h051 : 0 ≤ 0.51 * Real.log t + 2.78 := by nlinarith [hL]
  have heq : Xgrow t =
      Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) + Cf t (t * t) * Kbar (t * t) := by
    unfold Xgrow Ggrow Bgrow
    ring
  have hXUB : XUBfun t = (4.98 * Real.log t + 26.55) / (t * t) := by
    unfold XUBfun
    field_simp [htpos.ne']
    ring
  set A2 := 2 + 1 / T0 + 1 / (T0 * T0) with hA2
  set D2 := 1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0) with hD2
  have hA2ub : 2 * A2 + 0.51 * D2 ≤ 4.98 := by
    dsimp [A2, D2]
    norm_num [hT0val]
  have hD2ub : 11 * A2 + 2.78 * D2 ≤ 26.55 := by
    dsimp [A2, D2]
    norm_num [hT0val]
  calc Xgrow t
      = Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) + Cf t (t * t) * Kbar (t * t) := heq
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) + Cf t (t * t) * Kbar (t * t) := by
      have hBf' : Bf t (t * t) ≤ A2 / (t * t) := by simpa [Ggrow] using hBf
      have hstepa : Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) ≤
          A2 / (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) :=
        mul_le_mul_of_nonneg_right hBf' hS0
      have hA2pos : 0 < A2 := by
        dsimp [A2]
        norm_num [hT0val]
      have hstepb : A2 / (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) ≤
          A2 / (t * t) * (2 * Real.log t + 11) :=
        mul_le_mul_of_nonneg_left hS (div_nonneg hA2pos.le (by positivity))
      exact add_le_add (hstepa.trans hstepb) le_rfl
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) +
        (2 * t * t + 9 / 2 + 5 / (t * t)) * Kbar (t * t) := by
      have hC' : Cf t (t * t) ≤ 2 * t * t + 9 / 2 + 5 / (t * t) := by simpa [Ggrow] using hC
      exact add_le_add le_rfl (mul_le_mul_of_nonneg_right hC' hK0)
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) +
        (2 * t * t + 9 / 2 + 5 / (t * t)) * ((0.51 * Real.log t + 2.78) / (2 * t * t * t * t)) := by
      have hK' : Kbar (t * t) ≤ (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) := by
        simpa [Ggrow] using hK
      exact add_le_add le_rfl (mul_le_mul_of_nonneg_left hK' (by positivity))
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) + D2 / (t * t) * (0.51 * Real.log t + 2.78) := by
      rw [show (2 * t * t + 9 / 2 + 5 / (t * t)) *
              ((0.51 * Real.log t + 2.78) / (2 * t * t * t * t)) =
              (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) *
                (0.51 * Real.log t + 2.78) from by ring]
      exact add_le_add le_rfl (mul_le_mul_of_nonneg_right hD h051)
    _ ≤ (4.98 * Real.log t + 26.55) / (t * t) := by
      have h1 : A2 / (t * t) * (2 * Real.log t + 11) =
          A2 * (2 * Real.log t + 11) / (t * t) := by
        field_simp [htpos.ne']
      have h2 : D2 / (t * t) * (0.51 * Real.log t + 2.78) =
          D2 * (0.51 * Real.log t + 2.78) / (t * t) := by
        field_simp [htpos.ne']
      rw [h1, h2]
      have h3 : A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78) ≤
          4.98 * Real.log t + 26.55 := by
        have h3a : A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78) =
            (2 * A2 + 0.51 * D2) * Real.log t + (11 * A2 + 2.78 * D2) := by
          ring
        rw [h3a]
        have hLnn : 0 ≤ Real.log t := by
          exact (lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) hL).le
        have h3b : (2 * A2 + 0.51 * D2) * Real.log t ≤ 4.98 * Real.log t :=
          mul_le_mul_of_nonneg_right hA2ub hLnn
        nlinarith [h3b, hD2ub]
      have h4 : A2 * (2 * Real.log t + 11) / (t * t) + D2 * (0.51 * Real.log t + 2.78) / (t * t) =
          (A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78)) / (t * t) := by
        field_simp [htpos.ne']
      rw [h4]
      have h5 : 0 < t * t := by positivity
      rw [div_le_iff₀ h5]
      field_simp [h5.ne']
      ring_nf at h3 ⊢
      exact h3
    _ = XUBfun t := by rw [hXUB]

/-- XUBfun t ≤ CG2 for t ≥ T0. -/
/- For t ≥ T0: ln t ≤ √t, √t/t² = t^{-3/2} decreasing, √T0 ≤ 332. -/
theorem hXubEnd (t : ℝ) (ht : T0 ≤ t) : XUBfun t ≤ CG2 := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hXUB : XUBfun t = (4.98 * Real.log t + 26.55) / (t * t) := by
    unfold XUBfun
    field_simp [htpos.ne']
    ring
  rw [hXUB]
  have h1 : Real.log t ≤ Real.sqrt t := by
    simpa [Real.sqrt_eq_rpow] using hLogSqrt t (by nlinarith [hT0val, ht])
  have h2 : (4.98 * Real.log t + 26.55) / (t * t) ≤
      4.98 * Real.sqrt t / (t * t) + 26.55 / (t * t) := by
    have h2a : (4.98 * Real.log t + 26.55) / (t * t) =
        4.98 * Real.log t / (t * t) + 26.55 / (t * t) := by
      field_simp [htpos.ne']
    rw [h2a]
    have h2b : 4.98 * Real.log t / (t * t) ≤ 4.98 * Real.sqrt t / (t * t) := by
      have h2c : 4.98 * Real.log t ≤ 4.98 * Real.sqrt t :=
        mul_le_mul_of_nonneg_left h1 (by norm_num)
      have h2d : 4.98 * Real.log t / (t * t) =
          (4.98 * Real.log t) * (1 / (t * t)) := by
        rw [div_eq_mul_inv]
        ring
      have h2e : 4.98 * Real.sqrt t / (t * t) =
          (4.98 * Real.sqrt t) * (1 / (t * t)) := by
        rw [div_eq_mul_inv]
        ring
      rw [h2d, h2e]
      exact mul_le_mul_of_nonneg_right h2c (by positivity)
    nlinarith [h2b]
  have h3 : 4.98 * Real.sqrt t / (t * t) = 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) := by
    have h1 : Real.sqrt t / (t * t) = (t : ℝ) ^ (-3 / 2 : ℝ) := by
      have h1a : Real.sqrt t = (t : ℝ) ^ (1 / 2 : ℝ) := by rw [Real.sqrt_eq_rpow t]
      have h1b : (t * t : ℝ) = (t : ℝ) ^ (2 : ℝ) := by
        rw [show (t : ℝ) ^ (2 : ℝ) = t ^ 2 from (Real.rpow_natCast t 2), pow_two]
      have h1c : (t : ℝ) ^ (1 / 2 : ℝ) / (t : ℝ) ^ (2 : ℝ) = (t : ℝ) ^ (-3 / 2 : ℝ) := by
        have h1d : ((t : ℝ) ^ (2 : ℝ))⁻¹ = (t : ℝ) ^ (-2 : ℝ) := by
          rw [Real.rpow_neg (by positivity : 0 ≤ t) 2]
        have h1e : (t : ℝ) ^ (1 / 2 : ℝ) / (t : ℝ) ^ (2 : ℝ) =
            (t : ℝ) ^ (1 / 2 : ℝ) * ((t : ℝ) ^ (2 : ℝ))⁻¹ := by
          rw [div_eq_mul_inv]
        rw [h1e, h1d, show (-3 / 2 : ℝ) = (1 / 2 : ℝ) + (-2 : ℝ) from by norm_num,
            Real.rpow_add htpos (1 / 2) (-2)]
      rw [h1a, h1b, h1c]
    have hbr : 4.98 * Real.sqrt t / (t * t) = 4.98 * (Real.sqrt t / (t * t)) := by
      field_simp [htpos.ne']
    rw [hbr, h1]
  apply le_trans h2
  rw [h3]
  have h4 : (t : ℝ) ^ (-3 / 2 : ℝ) ≤ T0 ^ (-3 / 2 : ℝ) := by
    have h4a : (t : ℝ) ^ (-3 / 2 : ℝ) = 1 / (t : ℝ) ^ (3 / 2 : ℝ) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num, Real.rpow_neg htpos.le (3 / 2)]
      simp
    have h4b : (T0 : ℝ) ^ (-3 / 2 : ℝ) = 1 / (T0 : ℝ) ^ (3 / 2 : ℝ) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num, Real.rpow_neg (by norm_num [hT0val]) (3 / 2)]
      simp
    rw [h4a, h4b]
    apply one_div_le_one_div_of_le
    · exact rpow_pos_of_pos (by norm_num [hT0val] : 0 < (T0 : ℝ)) (3 / 2 : ℝ)
    · exact Real.rpow_le_rpow (by norm_num [hT0val]) ht (by norm_num)
  have h8 : 26.55 / (t * t) ≤ 26.55 / (T0 * T0) := by
    have h1 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
      simpa using one_div_le_one_div_of_le (by norm_num [hT0val]) (hSGtsq ht)
    have h1b : 26.55 / (t * t) = 26.55 * (1 / (t * t)) := by ring
    have h1c : 26.55 / (T0 * T0) = 26.55 * (1 / (T0 * T0)) := by ring
    rw [h1b, h1c]
    exact mul_le_mul_of_nonneg_left h1 (by norm_num)
  have h5 : 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) + 26.55 / (t * t) ≤
      4.98 * T0 ^ (-3 / 2 : ℝ) + 26.55 / (T0 * T0) := by
    have h5a : 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) ≤ 4.98 * T0 ^ (-3 / 2 : ℝ) :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    exact add_le_add h5a h8
  have h6 : T0 ^ (-3 / 2 : ℝ) = Real.sqrt T0 / (T0 * T0) := by
    have h1 : T0 ^ (-3 / 2 : ℝ) = 1 / (T0 ^ (3 / 2 : ℝ)) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num, Real.rpow_neg (by norm_num [hT0val]) (3 / 2)]
      simp
    have h2 : T0 ^ (3 / 2 : ℝ) = T0 * Real.sqrt T0 := by
      rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
          Real.rpow_add (by norm_num [hT0val]) 1 (1 / 2), Real.rpow_one (T0 : ℝ)]
      have h3 : (T0 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt T0 := by rw [Real.sqrt_eq_rpow T0]
      rw [h3]
    have hsq : (Real.sqrt T0) ^ 2 = T0 := by
      rw [Real.sq_sqrt (by norm_num [hT0val])]
    rw [h1, h2]
    have hden : 0 < T0 * Real.sqrt T0 :=
      mul_pos hSGT0pos (Real.sqrt_pos.mpr hSGT0pos)
    rw [div_eq_div_iff hden.ne' (mul_ne_zero hSGT0pos.ne' hSGT0pos.ne')]
    ring_nf
    rw [hsq]
    ring
  have h7 : 4.98 * T0 ^ (-3 / 2 : ℝ) ≤ 4.98 * 332 / (T0 * T0) := by
    rw [h6]
    calc 4.98 * (Real.sqrt T0 / (T0 * T0))
        = (4.98 * Real.sqrt T0) * (1 / (T0 * T0)) := by
          rw [div_eq_mul_inv]
          ring
      _ ≤ (4.98 * 332) * (1 / (T0 * T0)) := by
          have h1 : 4.98 * Real.sqrt T0 ≤ 4.98 * 332 :=
            mul_le_mul_of_nonneg_left hT0sqrt (by norm_num)
          exact mul_le_mul_of_nonneg_right h1 (by norm_num [hT0val])
      _ = 4.98 * 332 / (T0 * T0) := by
          rw [div_eq_mul_inv]
          ring
  have hfin1 : 4.98 * Real.sqrt t / (t * t) + 26.55 / (t * t) =
      4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) + 26.55 / (t * t) := by
    rw [h3]
  have hfin2 : 4.98 * T0 ^ (-3 / 2 : ℝ) + 26.55 / (T0 * T0) ≤
      4.98 * 332 / (T0 * T0) + 26.55 / (T0 * T0) :=
    add_le_add h7 (le_of_eq (by ring))
  have hfin3 : 4.98 * 332 / (T0 * T0) + 26.55 / (T0 * T0) =
      (4.98 * 332 + 26.55) / (T0 * T0) := by
    field_simp [hSGT0pos]
  have hfin4 : (4.98 * 332 + 26.55) / (T0 * T0) ≤ CG2 := by
    norm_num [CG2, hT0val]
  exact (h5.trans hfin2).trans ((le_of_eq hfin3).trans hfin4)

/- ================================================================
Stage D: M-term bound and the main theorem (25ab REV2 chain).
-/

/-- exp(Xgrow t) ≤ 3 for t ≥ T0 (X ≤ XUBfun ≤ CG2 < 1, e ≤ 3). -/
theorem hExpX (t : ℝ) (ht : T0 ≤ t) : Real.exp (Xgrow t) ≤ 3 := by
  have hCG21 : CG2 ≤ 1 := by norm_num [CG2]
  have hx1 : Xgrow t ≤ 1 := le_trans (hXub t ht) (le_trans (hXubEnd t ht) hCG21)
  calc Real.exp (Xgrow t) ≤ Real.exp 1 := Real.exp_le_exp.mpr hx1
    _ ≤ 3 := S4W.hE3

/-- Zbound(t) > 0 for t ≥ T0. -/
theorem hZpos (t : ℝ) (ht : T0 ≤ t) : 0 < Zbound t := by
  unfold Zbound
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hLp : 0 < Real.log t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1) hL
  apply mul_pos
  · apply mul_pos
    · norm_num
    · exact rpow_pos_of_pos htpos (1 / 4)
  · exact hLp

/-- rpow helper: t^{1/4}·(1/t²) = t^{−7/4}. -/
theorem htpow4 (t : ℝ) (ht : T0 ≤ t) :
    (t : ℝ) ^ (1 / 4 : ℝ) * (1 / (t * t)) = (t : ℝ) ^ (-7 / 4 : ℝ) := by
  have htpos := hSGtp ht
  have h2 : (1 / (t * t) : ℝ) = (t : ℝ) ^ (-2 : ℝ) := by
    have ht2 : (t * t : ℝ) = (t : ℝ) ^ (2 : ℝ) := by
      rw [show (t * t : ℝ) = (t : ℝ) ^ 2 from by ring]
      exact (Real.rpow_natCast t 2).symm
    rw [ht2, one_div, ← Real.rpow_neg htpos.le (2 : ℝ)]
  calc (t : ℝ) ^ (1 / 4 : ℝ) * (1 / (t * t))
      = (t : ℝ) ^ (1 / 4 : ℝ) * (t : ℝ) ^ (-2 : ℝ) := by rw [h2]
    _ = (t : ℝ) ^ (1 / 4 + (-2) : ℝ) := (Real.rpow_add htpos (1 / 4) (-2)).symm
    _ = (t : ℝ) ^ (-7 / 4 : ℝ) := by norm_num

/-- rpow helper: t^{1/2}·t^{−7/4} = t^{−5/4}. -/
theorem htpow5 (t : ℝ) (ht : T0 ≤ t) :
    (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) = (t : ℝ) ^ (-5 / 4 : ℝ) := by
  have htpos := hSGtp ht
  calc (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)
      = (t : ℝ) ^ (1 / 2 + (-7 / 4) : ℝ) := (Real.rpow_add htpos (1 / 2) (-7 / 4)).symm
    _ = (t : ℝ) ^ (-5 / 4 : ℝ) := by norm_num

/-- M-term: Zbound(t)·exp(Xgrow t)·Xgrow t ≤ CG3 for t ≥ T0. -/
theorem hMf (t : ℝ) (ht : T0 ≤ t) :
    Zbound t * Real.exp (Xgrow t) * Xgrow t ≤ CG3 := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 t ht
  have hLnn : 0 ≤ Real.log t := le_trans (by norm_num : (0 : ℝ) ≤ 1) hL
  have hLs : Real.log t ≤ (t : ℝ) ^ (1 / 2 : ℝ) :=
    hLogSqrt t (by nlinarith [hT0val, ht])
  have hLsq : Real.log t * Real.log t ≤ t := by
    have hsq : (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (1 / 2 : ℝ) = t := by
      calc (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (1 / 2 : ℝ) =
          (t : ℝ) ^ (1 / 2 + 1 / 2 : ℝ) := (Real.rpow_add htpos (1 / 2) (1 / 2)).symm
        _ = (t : ℝ) ^ (1 : ℝ) := by norm_num
        _ = t := Real.rpow_one (t : ℝ)
    have h1 : Real.log t * Real.log t ≤ Real.log t * (t : ℝ) ^ (1 / 2 : ℝ) :=
      mul_le_mul_of_nonneg_left hLs hLnn
    have h2 : Real.log t * (t : ℝ) ^ (1 / 2 : ℝ) ≤
        (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (1 / 2 : ℝ) :=
      mul_le_mul_of_nonneg_right hLs (rpow_nonneg htpos.le (1 / 2))
    exact le_trans h1 (le_trans h2 (le_of_eq hsq))
  have hUB : XUBfun t = (249 / 50 * Real.log t + 531 / 20) / (t * t) := by
    unfold XUBfun
    field_simp [htpos.ne']
  have hZ : Zbound t = 1.6 * (t : ℝ) ^ (1 / 4 : ℝ) * Real.log t := by
    unfold Zbound
    rfl
  by_cases hXnn : 0 ≤ Xgrow t
  · have hX := hXub t ht
    have hexp := hExpX t ht
    have hZp : 0 < Zbound t := hZpos t ht
    have hprod : Zbound t * Real.exp (Xgrow t) * Xgrow t ≤ Zbound t * 3 * Xgrow t := by
      have h1 : Zbound t * Real.exp (Xgrow t) ≤ Zbound t * 3 :=
        mul_le_mul_of_nonneg_left hexp hZp.le
      have h2 : (Zbound t * Real.exp (Xgrow t)) * Xgrow t ≤ (Zbound t * 3) * Xgrow t :=
        mul_le_mul_of_nonneg_right h1 hXnn
      ring_nf at h2 ⊢
      exact h2
    have h34 : Zbound t * 3 * Xgrow t ≤ Zbound t * 3 * XUBfun t :=
      mul_le_mul_of_nonneg_left hX (mul_nonneg hZp.le (by norm_num : (0 : ℝ) ≤ 3))
    have h35 : Zbound t * 3 * XUBfun t ≤
        4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t) *
          (t : ℝ) ^ (-7 / 4 : ℝ) := by
      rw [hZ, hUB]
      have heq : 1.6 * (t : ℝ) ^ (1 / 4 : ℝ) * Real.log t * 3 *
              ((249 / 50 * Real.log t + 531 / 20) / (t * t)) =
          4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t) *
            (t : ℝ) ^ (-7 / 4 : ℝ) := by
        have hF : (t : ℝ) ^ (1 / 4 : ℝ) * (1 / (t * t)) = (t : ℝ) ^ (-7 / 4 : ℝ) :=
          htpow4 t ht
        rw [show 1.6 * (t : ℝ) ^ (1 / 4 : ℝ) * Real.log t * 3 *
                ((249 / 50 * Real.log t + 531 / 20) / (t * t)) =
              1.6 * 3 * Real.log t * (249 / 50 * Real.log t + 531 / 20) *
                ((t : ℝ) ^ (1 / 4 : ℝ) * (1 / (t * t))) from by
            rw [div_eq_mul_inv]
            ring,
            show 1.6 * 3 * Real.log t * (249 / 50 * Real.log t + 531 / 20) *
                    ((t : ℝ) ^ (1 / 4 : ℝ) * (1 / (t * t))) =
              1.6 * 3 * Real.log t * (249 / 50 * Real.log t + 531 / 20) *
                (t : ℝ) ^ (-7 / 4 : ℝ) from by
            rw [hF],
            show (1.6 : ℝ) * 3 = 4.8 from by ring]
        ring_nf
      rw [heq]
    have h36 : 4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t) *
            (t : ℝ) ^ (-7 / 4 : ℝ) ≤
        4.8 * (249 / 50 * (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) +
                531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) := by
      have hinner : 249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t ≤
          249 / 50 * (t : ℝ) + 531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ) := by
        have hx : (249 / 50 : ℝ) * (Real.log t * Real.log t) ≤ (249 / 50 : ℝ) * (t : ℝ) :=
          mul_le_mul_of_nonneg_left hLsq (by norm_num)
        have hy : (531 / 20 : ℝ) * Real.log t ≤ (531 / 20 : ℝ) * (t : ℝ) ^ (1 / 2 : ℝ) :=
          mul_le_mul_of_nonneg_left hLs (by norm_num)
        ring_nf at hx hy ⊢
        nlinarith [hx, hy]
      calc 4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t) *
              (t : ℝ) ^ (-7 / 4 : ℝ)
          = (4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t)) *
              (t : ℝ) ^ (-7 / 4 : ℝ) := by ring
        _ ≤ (4.8 * (249 / 50 * (t : ℝ) + 531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ))) *
              (t : ℝ) ^ (-7 / 4 : ℝ) :=
            mul_le_mul_of_nonneg_right
              (mul_le_mul_of_nonneg_left hinner (by norm_num))
              (rpow_pos_of_pos htpos (-7 / 4)).le
        _ = 4.8 * (249 / 50 * (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) +
                531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) := by ring
    have h37 : 4.8 * (249 / 50 * (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) +
            531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) =
        4.8 * (249 / 50 * (t : ℝ) ^ (-3 / 4 : ℝ) + 531 / 20 * (t : ℝ) ^ (-5 / 4 : ℝ)) := by
      have h1a : (249 / 50 : ℝ) * (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) =
          249 / 50 * ((t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) := by ring
      have h2a : (531 / 20 : ℝ) * (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) =
          531 / 20 * ((t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) := by ring
      rw [h1a, h2a]
      have hp34 : (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) = (t : ℝ) ^ (-3 / 4 : ℝ) := by
        have h1 : (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) =
            (t : ℝ) ^ (1 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) := by
          rw [Real.rpow_one (t : ℝ)]
        have h2 : (t : ℝ) ^ (1 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) =
            (t : ℝ) ^ (-3 / 4 : ℝ) := by
          rw [(Real.rpow_add htpos 1 (-7 / 4)).symm,
              show (1 : ℝ) + (-7 / 4 : ℝ) = (-3 / 4 : ℝ) from by ring]
        exact h1.trans h2
      rw [hp34, htpow5 t ht]
    have h38 : 4.8 * (249 / 50 * (t : ℝ) ^ (-3 / 4 : ℝ) + 531 / 20 * (t : ℝ) ^ (-5 / 4 : ℝ)) ≤
        4.8 * (249 / 50 * T0 ^ (-3 / 4 : ℝ) + 531 / 20 * T0 ^ (-5 / 4 : ℝ)) := by
      have hant3 : (t : ℝ) ^ (-3 / 4 : ℝ) ≤ T0 ^ (-3 / 4 : ℝ) :=
        (antitoneOn_rpow_Ioi_of_exponent_nonpos (by norm_num : (-3 / 4 : ℝ) ≤ 0))
          hSGT0pos htpos ht
      have hant5 : (t : ℝ) ^ (-5 / 4 : ℝ) ≤ T0 ^ (-5 / 4 : ℝ) :=
        (antitoneOn_rpow_Ioi_of_exponent_nonpos (by norm_num : (-5 / 4 : ℝ) ≤ 0))
          hSGT0pos htpos ht
      have h1b : 249 / 50 * (t : ℝ) ^ (-3 / 4 : ℝ) ≤ 249 / 50 * T0 ^ (-3 / 4 : ℝ) :=
        mul_le_mul_of_nonneg_left hant3 (by norm_num)
      have h2b : 531 / 20 * (t : ℝ) ^ (-5 / 4 : ℝ) ≤ 531 / 20 * T0 ^ (-5 / 4 : ℝ) :=
        mul_le_mul_of_nonneg_left hant5 (by norm_num)
      have h3b : 249 / 50 * (t : ℝ) ^ (-3 / 4 : ℝ) + 531 / 20 * (t : ℝ) ^ (-5 / 4 : ℝ) ≤
          249 / 50 * T0 ^ (-3 / 4 : ℝ) + 531 / 20 * T0 ^ (-5 / 4 : ℝ) :=
        add_le_add h1b h2b
      exact mul_le_mul_of_nonneg_left h3b (by norm_num : (0 : ℝ) ≤ 4.8)
    have h39 : 4.8 * (249 / 50 * T0 ^ (-3 / 4 : ℝ) + 531 / 20 * T0 ^ (-5 / 4 : ℝ)) ≤ CG3 := by
      have hd1 : T0 ^ (-3 / 4 : ℝ) ≤ 1 / 6000 := by
        rw [show (-3 / 4 : ℝ) = (-(3 / 4 : ℝ)) from by ring,
            Real.rpow_neg (le_of_lt hSGT0pos) (3 / 4)]
        simpa using one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 6000) hT0p34
      have hd2 : T0 ^ (-5 / 4 : ℝ) ≤ 1 / 1980000 := by
        rw [show (-5 / 4 : ℝ) = (-(5 / 4 : ℝ)) from by ring,
            Real.rpow_neg (le_of_lt hSGT0pos) (5 / 4)]
        simpa using one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 1980000) hT0p54
      have hstep : 4.8 * (249 / 50 * T0 ^ (-3 / 4 : ℝ) + 531 / 20 * T0 ^ (-5 / 4 : ℝ)) ≤
          4.8 * (249 / 50 / 6000 + 531 / 20 / 1980000) := by
        gcongr
        · nlinarith [hd1]
        · nlinarith [hd2]
      have hend : 4.8 * (249 / 50 / 6000 + 531 / 20 / 1980000) ≤ CG3 := by
        norm_num [CG3]
      exact le_trans hstep hend
    calc Zbound t * Real.exp (Xgrow t) * Xgrow t
        ≤ Zbound t * 3 * Xgrow t := hprod
      _ ≤ Zbound t * 3 * XUBfun t := h34
      _ ≤ 4.8 * (249 / 50 * Real.log t * Real.log t + 531 / 20 * Real.log t) *
            (t : ℝ) ^ (-7 / 4 : ℝ) := h35
      _ ≤ 4.8 * (249 / 50 * (t : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ) +
                531 / 20 * (t : ℝ) ^ (1 / 2 : ℝ) * (t : ℝ) ^ (-7 / 4 : ℝ)) := h36
      _ = 4.8 * (249 / 50 * (t : ℝ) ^ (-3 / 4 : ℝ) + 531 / 20 * (t : ℝ) ^ (-5 / 4 : ℝ)) := h37
      _ ≤ 4.8 * (249 / 50 * T0 ^ (-3 / 4 : ℝ) + 531 / 20 * T0 ^ (-5 / 4 : ℝ)) := h38
      _ ≤ CG3 := h39
  · push_neg at hXnn
    have hZp : 0 < Zbound t := hZpos t ht
    have hexp : 0 < Real.exp (Xgrow t) := Real.exp_pos (Xgrow t)
    have hneg : Zbound t * Real.exp (Xgrow t) * Xgrow t < 0 :=
      mul_neg_of_pos_of_neg (mul_pos hZp hexp) hXnn
    have hCG3p : 0 < CG3 := by norm_num [CG3]
    nlinarith [hneg, hCG3p]

/-- The main wire inequality: for all t ≥ T0 and 0 ≤ M ≤ Zbound(t),
      p8_B t (nGrow t) + M · exp(Xgrow t) · Xgrow t  <  p8_f_near_pin. -/
theorem s4g_growth_squeeze (t : ℝ) (ht : T0 ≤ t) (M : ℝ) (hM : 0 ≤ M)
    (hMz : M ≤ Zbound t) :
    p8_B t (nGrow t) + M * Real.exp (Xgrow t) * Xgrow t < p8_f_near_pin := by
  have htot : CG11 + CG12 + CG13 + CG3 < p8_f_near_pin := by
    norm_num [CG11, CG12, CG13, CG3, p8_f_near_pin]
  have hB : p8_B t (nGrow t) ≤ CG11 + CG12 + CG13 :=
    add_le_add (add_le_add (hCG11 t ht) (hCG12 t ht)) (hCG13 t ht)
  by_cases hXnn : 0 ≤ Xgrow t
  · have hMterm : M * Real.exp (Xgrow t) * Xgrow t ≤ CG3 := by
      have he : 0 ≤ Real.exp (Xgrow t) := (Real.exp_pos (Xgrow t)).le
      have hm : M * (Real.exp (Xgrow t) * Xgrow t) ≤
          Zbound t * (Real.exp (Xgrow t) * Xgrow t) :=
        mul_le_mul_of_nonneg_right hMz (mul_nonneg he hXnn)
      have hassoc : M * Real.exp (Xgrow t) * Xgrow t =
          M * (Real.exp (Xgrow t) * Xgrow t) := by ring
      have hassoc2 : Zbound t * Real.exp (Xgrow t) * Xgrow t =
          Zbound t * (Real.exp (Xgrow t) * Xgrow t) := by ring
      rw [hassoc]
      calc M * (Real.exp (Xgrow t) * Xgrow t)
          ≤ Zbound t * (Real.exp (Xgrow t) * Xgrow t) := hm
        _ = Zbound t * Real.exp (Xgrow t) * Xgrow t := hassoc2.symm
        _ ≤ CG3 := hMf t ht
    have h1 : p8_B t (nGrow t) + M * Real.exp (Xgrow t) * Xgrow t ≤
        (CG11 + CG12 + CG13) + CG3 := add_le_add hB hMterm
    have h2 : (CG11 + CG12 + CG13) + CG3 = CG11 + CG12 + CG13 + CG3 := by ring
    have h3 : (CG11 + CG12 + CG13) + CG3 < p8_f_near_pin := by
      rw [h2]
      exact htot
    exact lt_of_le_of_lt h1 h3
  · push_neg at hXnn
    have hMterm : M * Real.exp (Xgrow t) * Xgrow t ≤ 0 :=
      mul_nonpos_of_nonneg_of_nonpos (mul_nonneg hM (Real.exp_pos (Xgrow t)).le) (le_of_lt hXnn)
    have h1 : p8_B t (nGrow t) + M * Real.exp (Xgrow t) * Xgrow t ≤
        p8_B t (nGrow t) + 0 := add_le_add_right hMterm (p8_B t (nGrow t))
    have h2 : p8_B t (nGrow t) + 0 ≤ (CG11 + CG12 + CG13) + 0 :=
      add_le_add_left hB 0
    have h3 : (CG11 + CG12 + CG13) + 0 ≤ (CG11 + CG12 + CG13) + CG3 :=
      add_le_add_right (show (0 : ℝ) ≤ CG3 from by norm_num [CG3]) (CG11 + CG12 + CG13)
    have hsum : p8_B t (nGrow t) + M * Real.exp (Xgrow t) * Xgrow t ≤
        (CG11 + CG12 + CG13) + CG3 := le_trans (le_trans h1 h2) h3
    have h2b : (CG11 + CG12 + CG13) + CG3 = CG11 + CG12 + CG13 + CG3 := by ring
    have h3b : (CG11 + CG12 + CG13) + CG3 < p8_f_near_pin := by
      rw [h2b]
      exact htot
    exact lt_of_le_of_lt hsum h3b


/- ================================================================
Stage E: Admissibility — RVM lower bound (certified chain [4], 25ab).

CITED (Backlund RVM estimate, conservative certified form used by the
REV2 script): for T ≥ 11,
  |N(T) - (T/(2π))·log(T/(2πe))| ≤ 0.137·log T + 0.443·log log T + 4.4,
hence N(T) ≥ N_rvm_low(T), where
  N_rvm_low(x) = (x/2π)·(log(x/2π) - 1) - (137/1000) log x
                            - (443/1000) log log x - 44/10.
(Owner's online cross-check, 2026-09-15: the current best published
two-sided bound is Bellotti–Fiori, arXiv:2412.15470, accepted by
Math. Comp.: for T ≥ e,
  |N(T) - (T/2π)·log(T/(2πe))| ≤ 0.10076 log T + 0.24460 log log T
  + 8.08344.
Backlund is retained as the certified constant set of the REV2 script;
the two-sided form is used here only in its lower-bound direction.
The Bellotti–Fiori variant is formalized below as
`N_rvm_low_bf` / `s4g_admissible_bf` (25ac+: dps-50 certificate
scripts/rh/day026_admissibility_bf.py, ALL PASS — same chain shape,
exact rationals 10076/100000, 24460/100000, 808344/100000.)

PINNED (scripts/rh/day025_gapw_constants.py [4],
out_day025_gapw_constants.txt):
  N_lower(T0^2)/T0^2 = 3.24335400 (need >= 1)
  min ratio on [1.2e10, 1e40] = 3.24203321 @ 1.2e10
-/

/-- RVM lower-bound function (Backlund constants; see Stage E header). -/
noncomputable def N_rvm_low (x : ℝ) : ℝ :=
    x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) -
      137 / 1000 * Real.log x - 443 / 1000 * Real.log (Real.log x) - 44 / 10

/-- For x ≥ T0², log(x/(2π)) ≥ 19. -/
theorem hL19 (x : ℝ) (hx : T0 * T0 ≤ x) : 19 ≤ Real.log (x / (2 * Real.pi)) := by
  have hT2pos : 0 < T0 * T0 := by norm_num [hT0val]
  have hx0 : 0 < x := lt_of_lt_of_le hT2pos hx
  have hpos : 0 < 2 * Real.pi := mul_pos (by norm_num : (0 : ℝ) < 2) Real.pi_pos
  have he19 : Real.exp 19 ≤ 3 ^ 19 := by
    have hexp : Real.exp 19 = Real.exp 1 ^ 19 := by
      simpa using Real.exp_nat_mul (1 : ℝ) 19
    rw [hexp]
    exact (pow_le_pow_left₀ (Real.exp_pos 1).le S4W.hE3) 19
  have h2p : 2 * Real.pi ≤ 44 / 7 := by
    have hpi : Real.pi < 22 / 7 := by
      apply lt_of_lt_of_le Real.pi_lt_d4
      norm_num
    nlinarith [hpi]
  have hprod : 2 * Real.pi * Real.exp 19 ≤ T0 * T0 := by
    calc 2 * Real.pi * Real.exp 19
        ≤ (44 / 7) * Real.exp 19 :=
            mul_le_mul_of_nonneg_right h2p (Real.exp_pos 19).le
      _ ≤ (44 / 7) * 3 ^ 19 :=
            mul_le_mul_of_nonneg_left he19 (by norm_num : (0 : ℝ) ≤ 44 / 7)
      _ ≤ T0 * T0 := by
        norm_num [hT0val]
  have h1 : Real.exp 19 ≤ x / (2 * Real.pi) := by
    have hbig : 2 * Real.pi * Real.exp 19 ≤ x := le_trans hprod hx
    rw [le_div_iff₀ hpos]
    simpa [mul_comm] using hbig
  calc (19 : ℝ) = Real.log (Real.exp 19) := (Real.log_exp 19).symm
    _ ≤ Real.log (x / (2 * Real.pi)) :=
        Real.log_le_log (Real.exp_pos 19) h1

/-- The admissibility theorem: for x ≥ T0², N_rvm_low(x) ≥ x.
    (REV2 pinned ratio at T0²: 3.24335400 ≥ 1.) -/
theorem s4g_admissible (x : ℝ) (hx : T0 * T0 ≤ x) : N_rvm_low x ≥ x := by
  have hT2pos : 0 < T0 * T0 := by norm_num [hT0val]
  have hx0 : 0 < x := lt_of_lt_of_le hT2pos hx
  have hpos : 0 < 2 * Real.pi := mul_pos (by norm_num : (0 : ℝ) < 2) Real.pi_pos
  have hL19x : 19 ≤ Real.log (x / (2 * Real.pi)) := hL19 x hx
  -- log terms
  have hlogz : Real.log x ≤ x / 2 := by
    have hsrt : 0 < Real.sqrt x := Real.sqrt_pos.mpr hx0
    have hlog2 : Real.log (Real.sqrt x) ≤ Real.sqrt x - 1 :=
      Real.log_le_sub_one_of_pos hsrt
    have h2 : 2 * Real.log (Real.sqrt x) ≤ 2 * (Real.sqrt x - 1) :=
      mul_le_mul_of_nonneg_left hlog2 (by norm_num : (0 : ℝ) ≤ 2)
    have h3 : 2 * (Real.sqrt x - 1) ≤ x / 2 := by
      let u : ℝ := Real.sqrt x
      have hs : u * u = x := by
        rw [← pow_two]
        exact Real.sq_sqrt hx0.le
      rw [show (x : ℝ) = u * u from hs.symm, _root_.Real.sqrt_mul_self (Real.sqrt_nonneg x)]
      have hgap : (u * u) / 2 - 2 * (u - 1) = (1 / 2) * ((u - 2) * (u - 2)) := by ring
      have hgapnn : 0 ≤ (u * u) / 2 - 2 * (u - 1) := by
        rw [hgap]
        exact mul_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2) (mul_self_nonneg (u - 2))
      exact (sub_nonneg).mp hgapnn
    have h1c : 2 * Real.log (Real.sqrt x) = Real.log x := by
      have hs : Real.log (Real.sqrt x) = Real.log x / 2 := Real.log_sqrt hx0.le
      rw [hs]
      ring
    exact le_trans (le_of_eq h1c.symm) (le_trans h2 h3)
  have hlogx19 : 19 ≤ Real.log x := by
    have heq : x / (2 * Real.pi) * (2 * Real.pi) = x := by
      field_simp [hpos.ne']
    have hlogmul : Real.log (x / (2 * Real.pi) * (2 * Real.pi)) = Real.log x :=
      congrArg Real.log heq
    rw [← hlogmul, Real.log_mul (by positivity) (by positivity)]
    have hl2p : 0 < Real.log (2 * Real.pi) :=
      Real.log_pos (show (1 : ℝ) < 2 * Real.pi from by linarith [Real.pi_gt_three])
    nlinarith [hL19x, hl2p]
  have hlogzpos : 0 < Real.log x := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 19) hlogx19
  have hlnln : Real.log (Real.log x) ≤ Real.log x - 1 :=
    Real.log_le_sub_one_of_pos hlogzpos
  have hsum : 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) + 44 / 10 ≤
      29 / 100 * x + 3957 / 1000 := by
    have h1 : 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) ≤
        137 / 1000 * Real.log x + 443 / 1000 * (Real.log x - 1) :=
      add_le_add le_rfl
        (mul_le_mul_of_nonneg_left hlnln (by norm_num : (0 : ℝ) ≤ 443 / 1000))
    have h3 : 29 / 50 * Real.log x + 3957 / 1000 ≤ 29 / 50 * (x / 2) + 3957 / 1000 :=
      add_le_add_left
        (mul_le_mul_of_nonneg_left hlogz (by norm_num : (0 : ℝ) ≤ 29 / 50)) (3957 / 1000)
    calc 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) + 44 / 10
        ≤ 137 / 1000 * Real.log x + 443 / 1000 * (Real.log x - 1) + 44 / 10 :=
            add_le_add_left h1 (44 / 10)
      _ = 29 / 50 * Real.log x + 3957 / 1000 := by ring
      _ ≤ 29 / 50 * (x / 2) + 3957 / 1000 := h3
      _ = 29 / 100 * x + 3957 / 1000 := by ring
  -- main term
  have hstep1 : Real.log (x / (2 * Real.pi)) - 1 ≥ 18 := by
    have hG : 0 ≤ (Real.log (x / (2 * Real.pi)) - 1) - 18 := by
      have heq : (Real.log (x / (2 * Real.pi)) - 1) - 18 =
          Real.log (x / (2 * Real.pi)) - 19 := by ring
      rw [heq]
      exact (sub_nonneg).mpr hL19x
    exact (sub_nonneg).mp hG
  have h2pi9 : 18 / (2 * Real.pi) = 9 / Real.pi := by
    rw [div_eq_mul_inv, show (2 * Real.pi : ℝ)⁻¹ = (2 : ℝ)⁻¹ * Real.pi⁻¹ from by ring,
        div_eq_mul_inv]
    ring
  have hratio : 9 / Real.pi ≥ 63 / 22 := by
    have hpi : Real.pi < 22 / 7 := by
      apply lt_of_lt_of_le Real.pi_lt_d4
      norm_num
    have hinv : (22 / 7 : ℝ)⁻¹ < Real.pi⁻¹ := by
      have h1 : 1 / (22 / 7) < 1 / Real.pi :=
        one_div_lt_one_div_of_lt Real.pi_pos hpi
      simpa [one_div] using h1
    have hstep : 9 * (22 / 7 : ℝ)⁻¹ < 9 * Real.pi⁻¹ :=
      mul_lt_mul_of_pos_left hinv (by norm_num : (0 : ℝ) < 9)
    have hlt : 63 / 22 < 9 / Real.pi := by
      calc (63 / 22 : ℝ) = 9 * (7 / 22) := by norm_num
        _ = 9 * (22 / 7 : ℝ)⁻¹ := by rw [inv_div]
        _ < 9 * Real.pi⁻¹ := hstep
        _ = 9 / Real.pi := by rw [div_eq_mul_inv]
    exact le_of_lt hlt
  have hmainl : x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) ≥
      (63 / 22) * x := by
    have h3 : x / (2 * Real.pi) * 18 ≥ (63 / 22) * x := by
      calc (x / (2 * Real.pi)) * 18 = x * (18 / (2 * Real.pi)) := by ring
        _ = x * (9 / Real.pi) := by rw [h2pi9]
        _ ≥ x * (63 / 22) :=
            mul_le_mul_of_nonneg_left hratio hx0.le
        _ = (63 / 22) * x := by ring
    calc x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1)
        ≥ x / (2 * Real.pi) * 18 :=
            mul_le_mul_of_nonneg_left hstep1 (div_pos hx0 hpos).le
      _ ≥ (63 / 22) * x := h3
  -- total
  calc (N_rvm_low x : ℝ)
      = x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) -
          (137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) + 44 / 10) := by
        dsimp [N_rvm_low]
        ring
    _ ≥ (63 / 22) * x - (29 / 100 * x + 3957 / 1000) := by
        nlinarith [hmainl, hsum]
    _ ≥ x := by
        nlinarith [hT0val, hx]

/-- RVM lower-bound function (Bellotti–Fiori constants; see Stage E
    header): N_rvm_low_bf(x) = (x/2π)(log(x/2π) − 1)
    − (10076/100000)log x − (24460/100000)log log x − 808344/100000. -/
noncomputable def N_rvm_low_bf (x : ℝ) : ℝ :=
    x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) -
      10076 / 100000 * Real.log x - 24460 / 100000 * Real.log (Real.log x) -
      808344 / 100000

/-- The admissibility theorem (Bellotti–Fiori variant): for x ≥ T0²,
    N_rvm_low_bf(x) ≥ x.  (25ac+: dps-50 certificate
    scripts/rh/day026_admissibility_bf.py, ALL PASS: ratio at T0² =
    3.24335400295, min on [1.2e10, 1e40]; x-floor margin 2.6e9×.) -/
theorem s4g_admissible_bf (x : ℝ) (hx : T0 * T0 ≤ x) : N_rvm_low_bf x ≥ x := by
  have hT2pos : 0 < T0 * T0 := by norm_num [hT0val]
  have hx0 : 0 < x := lt_of_lt_of_le hT2pos hx
  have hpos : 0 < 2 * Real.pi := mul_pos (by norm_num : (0 : ℝ) < 2) Real.pi_pos
  have hL19x : 19 ≤ Real.log (x / (2 * Real.pi)) := hL19 x hx
  -- log terms
  have hlogz : Real.log x ≤ x / 2 := by
    have hsrt : 0 < Real.sqrt x := Real.sqrt_pos.mpr hx0
    have hlog2 : Real.log (Real.sqrt x) ≤ Real.sqrt x - 1 :=
      Real.log_le_sub_one_of_pos hsrt
    have h2 : 2 * Real.log (Real.sqrt x) ≤ 2 * (Real.sqrt x - 1) :=
      mul_le_mul_of_nonneg_left hlog2 (by norm_num : (0 : ℝ) ≤ 2)
    have h3 : 2 * (Real.sqrt x - 1) ≤ x / 2 := by
      let u : ℝ := Real.sqrt x
      have hs : u * u = x := by
        rw [← pow_two]
        exact Real.sq_sqrt hx0.le
      rw [show (x : ℝ) = u * u from hs.symm, _root_.Real.sqrt_mul_self (Real.sqrt_nonneg x)]
      have hgap : (u * u) / 2 - 2 * (u - 1) = (1 / 2) * ((u - 2) * (u - 2)) := by ring
      have hgapnn : 0 ≤ (u * u) / 2 - 2 * (u - 1) := by
        rw [hgap]
        exact mul_nonneg (by norm_num : (0 : ℝ) ≤ 1 / 2) (mul_self_nonneg (u - 2))
      exact (sub_nonneg).mp hgapnn
    have h1c : 2 * Real.log (Real.sqrt x) = Real.log x := by
      have hs : Real.log (Real.sqrt x) = Real.log x / 2 := Real.log_sqrt hx0.le
      rw [hs]
      ring
    exact le_trans (le_of_eq h1c.symm) (le_trans h2 h3)
  have hlogx19 : 19 ≤ Real.log x := by
    have heq : x / (2 * Real.pi) * (2 * Real.pi) = x := by
      field_simp [hpos.ne']
    have hlogmul : Real.log (x / (2 * Real.pi) * (2 * Real.pi)) = Real.log x :=
      congrArg Real.log heq
    rw [← hlogmul, Real.log_mul (by positivity) (by positivity)]
    have hl2p : 0 < Real.log (2 * Real.pi) :=
      Real.log_pos (show (1 : ℝ) < 2 * Real.pi from by linarith [Real.pi_gt_three])
    nlinarith [hL19x, hl2p]
  have hlogzpos : 0 < Real.log x := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 19) hlogx19
  have hlnln : Real.log (Real.log x) ≤ Real.log x - 1 :=
    Real.log_le_sub_one_of_pos hlogzpos
  have hsum : 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) + 44 / 10 ≤
      29 / 100 * x + 3957 / 1000 := by
    have h1 : 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) ≤
        137 / 1000 * Real.log x + 443 / 1000 * (Real.log x - 1) :=
      add_le_add le_rfl
        (mul_le_mul_of_nonneg_left hlnln (by norm_num : (0 : ℝ) ≤ 443 / 1000))
    have h3 : 29 / 50 * Real.log x + 3957 / 1000 ≤ 29 / 50 * (x / 2) + 3957 / 1000 :=
      add_le_add_left
        (mul_le_mul_of_nonneg_left hlogz (by norm_num : (0 : ℝ) ≤ 29 / 50)) (3957 / 1000)
    calc 137 / 1000 * Real.log x + 443 / 1000 * Real.log (Real.log x) + 44 / 10
        ≤ 137 / 1000 * Real.log x + 443 / 1000 * (Real.log x - 1) + 44 / 10 :=
            add_le_add_left h1 (44 / 10)
      _ = 29 / 50 * Real.log x + 3957 / 1000 := by ring
      _ ≤ 29 / 50 * (x / 2) + 3957 / 1000 := h3
      _ = 29 / 100 * x + 3957 / 1000 := by ring
  have hsum : 10076 / 100000 * Real.log x + 24460 / 100000 * Real.log (Real.log x) + 808344 / 100000 ≤
      34536 / 200000 * x + 783884 / 100000 := by
    have h1 : 10076 / 100000 * Real.log x + 24460 / 100000 * Real.log (Real.log x) ≤
        10076 / 100000 * Real.log x + 24460 / 100000 * (Real.log x - 1) :=
      add_le_add le_rfl
        (mul_le_mul_of_nonneg_left hlnln (by norm_num : (0 : ℝ) ≤ 24460 / 100000))
    have h3 : 34536 / 100000 * Real.log x ≤ 34536 / 100000 * (x / 2) :=
      mul_le_mul_of_nonneg_left hlogz (by norm_num : (0 : ℝ) ≤ 34536 / 100000)
    calc 10076 / 100000 * Real.log x + 24460 / 100000 * Real.log (Real.log x) + 808344 / 100000
        ≤ 10076 / 100000 * Real.log x + 24460 / 100000 * (Real.log x - 1) + 808344 / 100000 :=
            add_le_add_left h1 (808344 / 100000)
      _ = 34536 / 100000 * Real.log x + 783884 / 100000 := by ring
      _ ≤ 34536 / 100000 * (x / 2) + 783884 / 100000 :=
          add_le_add_left h3 (783884 / 100000)
      _ = 34536 / 200000 * x + 783884 / 100000 := by ring
  -- main term
  have hstep1 : Real.log (x / (2 * Real.pi)) - 1 ≥ 18 := by
    have hG : 0 ≤ (Real.log (x / (2 * Real.pi)) - 1) - 18 := by
      have heq : (Real.log (x / (2 * Real.pi)) - 1) - 18 =
          Real.log (x / (2 * Real.pi)) - 19 := by ring
      rw [heq]
      exact (sub_nonneg).mpr hL19x
    exact (sub_nonneg).mp hG
  have h2pi9 : 18 / (2 * Real.pi) = 9 / Real.pi := by
    rw [div_eq_mul_inv, show (2 * Real.pi : ℝ)⁻¹ = (2 : ℝ)⁻¹ * Real.pi⁻¹ from by ring,
        div_eq_mul_inv]
    ring
  have hratio : 9 / Real.pi ≥ 63 / 22 := by
    have hpi : Real.pi < 22 / 7 := by
      apply lt_of_lt_of_le Real.pi_lt_d4
      norm_num
    have hinv : (22 / 7 : ℝ)⁻¹ < Real.pi⁻¹ := by
      have h1 : 1 / (22 / 7) < 1 / Real.pi :=
        one_div_lt_one_div_of_lt Real.pi_pos hpi
      simpa [one_div] using h1
    have hstep : 9 * (22 / 7 : ℝ)⁻¹ < 9 * Real.pi⁻¹ :=
      mul_lt_mul_of_pos_left hinv (by norm_num : (0 : ℝ) < 9)
    have hlt : 63 / 22 < 9 / Real.pi := by
      calc (63 / 22 : ℝ) = 9 * (7 / 22) := by norm_num
        _ = 9 * (22 / 7 : ℝ)⁻¹ := by rw [inv_div]
        _ < 9 * Real.pi⁻¹ := hstep
        _ = 9 / Real.pi := by rw [div_eq_mul_inv]
    exact le_of_lt hlt
  have hmainl : x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) ≥
      (63 / 22) * x := by
    have h3 : x / (2 * Real.pi) * 18 ≥ (63 / 22) * x := by
      calc (x / (2 * Real.pi)) * 18 = x * (18 / (2 * Real.pi)) := by ring
        _ = x * (9 / Real.pi) := by rw [h2pi9]
        _ ≥ x * (63 / 22) :=
            mul_le_mul_of_nonneg_left hratio hx0.le
        _ = (63 / 22) * x := by ring
    calc x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1)
        ≥ x / (2 * Real.pi) * 18 :=
            mul_le_mul_of_nonneg_left hstep1 (div_pos hx0 hpos).le
      _ ≥ (63 / 22) * x := h3
  -- total
  calc (N_rvm_low_bf x : ℝ)
      = x / (2 * Real.pi) * (Real.log (x / (2 * Real.pi)) - 1) -
          (10076 / 100000 * Real.log x + 24460 / 100000 * Real.log (Real.log x) + 808344 / 100000) := by
        dsimp [N_rvm_low_bf]
        ring
    _ ≥ (63 / 22) * x - (34536 / 200000 * x + 783884 / 100000) := by
        nlinarith [hmainl, hsum]
    _ ≥ x := by
        nlinarith [hT0val, hx]

end S4G
