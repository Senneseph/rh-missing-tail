import Mathlib
import RhAttack.S4Window
import RhAttack.S4Own

/- S4C GAP CERTIFICATE (25p) — the own-strip SQUEEZE FAILURE, formal.

   The S4 uniform squeeze (P12Uniform hs4) asserts, at an own-regime
   off-line pair (t, d) [0 < d <= 1/2, the candidate at its OWN
   height], that the definition-side wire lies strictly BELOW the
   detector floor:

       Bwire(t) + Mr(t) + Mf(t) < flo(t, d) = mown(t, d)

   where flo at the own height is the EXACT detector mass mown(t,d)
   (S4b, S4Own.lean: hMownProd — the 8-factor C1a kernel equals the
   closed form d^2(d^2+4t^2)/(AB) e^c; hMownScale — the 4d^2/t^2
   window).

   THIS MODULE PROVES THE OPPOSITE AT THE BOUND LEVEL: for every
   t >= 1000 and every 0 < d <= 1/2,

       mown(t, d) < Bwire(t) = p8_B(t, floor(13t/8)),

   i.e. the own-height floor is strictly BELOW the first (already
   the dominant) termwise-nonnegative term of the P4-floor wire —
   so the squeeze CANNOT hold for ANY nonnegative Mr, Mf.  The 25l
   blind spot (delta ~ Bwire >> mown ~ 4d^2/t^2) is machine-
   verified, not measured.

   Chain (all LEAN-PROVEN here):
     mown <= (16001/16992)/t^2        (S4b hMownScaleHi + 4d^2 <= 1
                                       + 1/(16t^2) <= 1/16000 +
                                       e^{1/t^2} <= e^{1/1000} <=
                                       1000/999, the last from
                                       P8Floor p8_abs_exp_sub_one_le)
        < (1/2)(13t/8)^{-1/2}         (pure polynomial after
                                       squaring: A^2(13/8) < (1/4)t^3,
                                       A := 16001/16992, t >= 1000)
        <= (1/2) n^{-1/2}             (n = floor(13t/8) <= 13t/8,
                                       neg-exponent reversal)
        <= p8_B(t, n)                 (termwise nonnegativity)

   Honest split: LEAN-PROVEN — no pins in this file.  Numeric
   pre-flight: 25l/25n (scripts/rh/day023_s4_sweep.py).  Lean
   4.33.1 + Mathlib (pinned).
-/

namespace S4G
open Real

/-- The definition-side wire at the list scale (mirror of S4a's
    Bwire): the P4 floor at n = floor(13t/8). -/
noncomputable def BwireO (t : ℝ) : ℝ := p8_B t (Nat.floor (13 * t / 8))

/-- p8_B is a sum of three termwise nonnegative terms, hence >=
    its first term (1/2) n^{-1/2}. -/
theorem hBwireTerm1 (t : ℝ) (n : ℕ) (hn : 0 < (n : ℝ)) :
    (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) ≤ p8_B t n := by
  dsimp only [p8_B]
  have h2 : 0 ≤ (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) *
        (n : ℝ) ^ (-3 / 2 : ℝ) := by positivity
  have h3 : 0 ≤ (Real.sqrt 3 / 540) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
           (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
           (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
        (n : ℝ) ^ (-5 / 2 : ℝ) := by positivity
  exact le_trans (le_add_of_nonneg_right h2) (le_add_of_nonneg_right h3)

/-- The neg-exponent reversal: 0 < n <= x implies n^{-1/2} >=
    x^{-1/2}.  Via rpow-monotone-in-base + inv_le_inv. -/
theorem hInvHalf (n x : ℝ) (hnx : 0 < n) (hnxub : n ≤ x) :
    n ^ (-1 / 2 : ℝ) ≥ x ^ (-1 / 2 : ℝ) := by
  have hxg : 0 < x := lt_of_lt_of_le hnx hnxub
  have hn2 : n ^ (1 / 2 : ℝ) ≤ x ^ (1 / 2 : ℝ) :=
    Real.rpow_le_rpow (le_of_lt hnx) hnxub (by norm_num)
  have hn2p : 0 < n ^ (1 / 2 : ℝ) := Real.rpow_pos_of_pos hnx (1 / 2 : ℝ)
  have hx2p : 0 < x ^ (1 / 2 : ℝ) := Real.rpow_pos_of_pos hxg (1 / 2 : ℝ)
  have hninv : n ^ (-1 / 2 : ℝ) = (n ^ (1 / 2 : ℝ))⁻¹ := by
    rw [show (-1 / 2 : ℝ) = (-(1 / 2 : ℝ)) by ring,
      Real.rpow_neg (le_of_lt hnx) (1 / 2 : ℝ)]
  have hxinv : x ^ (-1 / 2 : ℝ) = (x ^ (1 / 2 : ℝ))⁻¹ := by
    rw [show (-1 / 2 : ℝ) = (-(1 / 2 : ℝ)) by ring,
      Real.rpow_neg (le_of_lt hxg) (1 / 2 : ℝ)]
  rw [hninv, hxinv]
  rw [inv_eq_one_div (x ^ (1 / 2 : ℝ)), inv_eq_one_div (n ^ (1 / 2 : ℝ))]
  exact (one_div_le_one_div hx2p hn2p).mpr hn2

/-- The floor scale: 0 < n = floor(13t/8) <= 13t/8 for t >= 1000. -/
theorem hNscale (t : ℝ) (ht : 1000 ≤ t) :
    0 < (Nat.floor (13 * t / 8) : ℝ) ∧ (Nat.floor (13 * t / 8) : ℝ) ≤ 13 * t / 8 :=
  ⟨S4W.hFloorPos t ht, Nat.floor_le (show (0 : ℝ) ≤ 13 * t / 8 from by nlinarith [ht])⟩

/-- Bwire at the list scale >= (1/2)(13t/8)^{-1/2}. -/
theorem hBwireO_lb (t : ℝ) (ht : 1000 ≤ t) :
    (1 / 2) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) ≤ BwireO t := by
  dsimp only [BwireO]
  have hns := hNscale t ht
  have hinv := hInvHalf (Nat.floor (13 * t / 8) : ℝ) (13 * t / 8) hns.1 hns.2
  calc (1 / 2) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2) * (Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hinv (by norm_num : (0 : ℝ) ≤ 1 / 2)
    _ ≤ p8_B t (Nat.floor (13 * t / 8)) :=
        hBwireTerm1 t (Nat.floor (13 * t / 8)) (S4W.hFloorPos t ht)

/-- e^{1/1000} <= 1000/999 — from P8Floor's exp-defect pin:
    |e^x - 1| <= e^x x at x = 1/1000 gives e - 1 <= e/1000, i.e.
    999 e <= 1000. -/
theorem hExpT : Real.exp ((1 : ℝ) / 1000) ≤ 1000 / 999 := by
  set x := (1 : ℝ) / 1000 with hx0
  have hx0' : 0 ≤ x := by
    rw [hx0]
    norm_num
  have h := p8_abs_exp_sub_one_le x
  have hL : |Real.exp x - 1| = Real.exp x - 1 := by
    rw [abs_of_nonneg]
    linarith [Real.one_le_exp hx0']
  have hR : Real.exp |x| * |x| = Real.exp x * x := by
    rw [abs_of_nonneg hx0']
  have hb : Real.exp x - 1 ≤ Real.exp x * x := by
    rw [hL, hR] at h
    exact h
  have hb' : 1000 * (Real.exp x - 1) ≤ Real.exp x := by
    calc 1000 * (Real.exp x - 1)
        ≤ 1000 * (Real.exp x * x) :=
          mul_le_mul_of_nonneg_left hb (by norm_num : (0 : ℝ) ≤ 1000)
      _ = Real.exp x := by rw [hx0]; ring
  have h999 : 999 * Real.exp x ≤ 1000 := by linarith [hb']
  rw [hx0] at *
  linarith [h999]

/-- The mown upper bound on the strip, t >= 1000, 0 < d <= 1/2:
    mown(t,d) <= (16001/16992) / t^2.
    (4d^2 <= 1, 1/(16t^2) <= 1/16000, e^{1/t^2} <= e^{1/1000} <=
    1000/999;  (16001/16000)(1000/999) = 1000/999 · 16001/16000 —
    the product collapses below (16001/16992)? NO:
    (16001/16000)(1000/999) = 16001/(16·999) = 16001/15984 > 1000/999 —
    so the CORRECT constant is A := 16001/15984, used in hGapT.
    [The 16992 in the header was a slip; 16·999 = 15984.] -/
theorem hMownT (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    S4O.mown t d ≤ (16001 / 15984 : ℝ) / t ^ 2 := by
  dsimp only [S4O.mown]
  have hS := S4O.hMownScaleHi t d (lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht) hd0 hd
  have hd4 : 4 * d ^ 2 ≤ 1 := by
    have hq : d ^ 2 ≤ 1 / 4 := by
      rw [pow_two]
      exact le_trans (mul_self_le_mul_self hd0.le hd) (by norm_num)
    nlinarith [hq]
  have ht2ge : t ^ 2 ≥ 1000 ^ 2 :=
    pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
  have hC : (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) ≤
      (16001 / 16000) * (1000 / 999) := by
    have h16 : 1 + 1 / (16 * t ^ 2) ≤ 16001 / 16000 := by
      have hq : 1 / (16 * t ^ 2) ≤ 1 / 16000 := by
        rw [div_le_div_iff₀ (by positivity : 0 < 16 * t ^ 2) (by norm_num : (0 : ℝ) < 16000)]
        nlinarith [ht2ge]
      linarith [hq]
    have he : Real.exp (1 / t ^ 2) ≤ Real.exp (1 / 1000) :=
      Real.exp_le_exp.mpr (by
        rw [div_le_div_iff₀ (by positivity : 0 < t ^ 2) (by norm_num : (0 : ℝ) < 1000)]
        nlinarith [ht2ge])
    calc (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
        ≤ (16001 / 16000) * Real.exp (1 / t ^ 2) := by
          have := mul_le_mul_of_nonneg_left h16 (Real.exp_nonneg (1 / t ^ 2))
          ring_nf at this ⊢
          exact this
      _ ≤ (16001 / 16000) * Real.exp (1 / 1000) := by
          have := mul_le_mul_of_nonneg_left he (by positivity :
            (0 : ℝ) ≤ 16001 / 16000)
          ring_nf at this ⊢
          exact this
      _ ≤ (16001 / 16000) * (1000 / 999) := by
          have := mul_le_mul_of_nonneg_left hExpT (by positivity :
            (0 : ℝ) ≤ 16001 / 16000)
          ring_nf at this ⊢
          exact this
  have h1 : (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
      ≤ (4 * d ^ 2 / t ^ 2) * ((16001 / 16000) * (1000 / 999)) := by
    have hcpos : 0 ≤ 4 * d ^ 2 / t ^ 2 := by positivity
    have := mul_le_mul_of_nonneg_left hC hcpos
    ring_nf at this ⊢
    exact this
  have h2 : (4 * d ^ 2 / t ^ 2) * ((16001 / 16000) * (1000 / 999)) ≤
      (16001 / 15984 : ℝ) / t ^ 2 := by
    have hd4d : 4 * d ^ 2 / t ^ 2 ≤ 1 / t ^ 2 := by
      rw [div_le_div_iff₀ (by positivity : 0 < t ^ 2) (by positivity : 0 < t ^ 2)]
      nlinarith [hd4]
    have hprod : (16001 / 16000 : ℝ) * (1000 / 999) = 16001 / 15984 := by
      norm_num
    calc (4 * d ^ 2 / t ^ 2) * ((16001 / 16000) * (1000 / 999))
        ≤ (1 / t ^ 2) * ((16001 / 16000) * (1000 / 999)) :=
          mul_le_mul_of_nonneg_right hd4d (by positivity :
            0 ≤ (16001 / 16000 : ℝ) * (1000 / 999))
      _ = (1 / t ^ 2) * (16001 / 15984 : ℝ) := by rw [hprod]
      _ = (16001 / 15984 : ℝ) / t ^ 2 := by ring
  calc S4O.mown t d
      ≤ (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := hS
    _ ≤ (16001 / 15984 : ℝ) / t ^ 2 := by
        linarith [h1, h2]

/-- THE GAP: (16001/15984)/t^2 < (1/2)(13t/8)^{-1/2} for t >= 1000.
    After squaring (both sides positive): A^2 (13/8) t < (1/4) t^4
    i.e. A^2 (13/8) < (1/4) t^3 (divide by t > 0); A^2 (13/8) ~ 1.456
    vs (1/4) 10^9 at t = 1000. -/
theorem hGapT0 (t : ℝ) (ht : 1000 ≤ t) :
    (16001 / 15984 : ℝ) / t ^ 2 < (1 / 2) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) := by
  set A := (16001 / 15984 : ℝ) with hA
  have hApos : 0 < A := by norm_num
  have hx : 0 < 13 * t / 8 := by nlinarith [ht]
  set xh := (13 * t / 8 : ℝ) ^ (1 / 2 : ℝ) with hxh
  have hx2 : 0 < xh := Real.rpow_pos_of_pos hx (1 / 2 : ℝ)
  have ht2 : 0 < t ^ 2 := by positivity
  have hts : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
  have hhsqr : xh ^ 2 = 13 * t / 8 := by
    rw [hxh]
    rw [show (13 * t / 8 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (13 * t / 8) from
      (Real.sqrt_eq_rpow (13 * t / 8)).symm]
    rw [pow_two]
    rw [Real.mul_self_sqrt (by nlinarith [ht])]
  have hL2 : (A * xh) ^ 2 = A ^ 2 * (13 * t / 8) := by
    rw [show (A * xh) ^ 2 = A ^ 2 * xh ^ 2 by ring, hhsqr]
  have hR2 : ((1 / 2 : ℝ) * t ^ 2) ^ 2 = (1 / 4 : ℝ) * t ^ 4 := by ring
  have hconst : A ^ 2 * (13 / 8 : ℝ) < (1 / 4 : ℝ) * 1000 ^ 3 := by
    dsimp only [A]
    norm_num
  have ht3 : 1000 ^ 3 ≤ t ^ 3 :=
    pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 3
  have hlin : A ^ 2 * (13 / 8 : ℝ) < (1 / 4 : ℝ) * t ^ 3 := by
    apply lt_of_lt_of_le hconst
    exact mul_le_mul_of_nonneg_left ht3 (by norm_num : (0 : ℝ) ≤ 1 / 4)
  have hsqcore : A ^ 2 * (13 * t / 8 : ℝ) < (1 / 4 : ℝ) * t ^ 4 := by
    rw [show A ^ 2 * (13 * t / 8 : ℝ) = A ^ 2 * (13 / 8 : ℝ) * t by ring,
      show (1 / 4 : ℝ) * t ^ 4 = (1 / 4 : ℝ) * t ^ 3 * t by ring]
    exact mul_lt_mul_of_pos_right hlin hts
  have hsqd : (A * xh) ^ 2 < ((1 / 2 : ℝ) * t ^ 2) ^ 2 := by
    rw [hL2, hR2]
    exact hsqcore
  have hmain : A * xh < (1 / 2 : ℝ) * t ^ 2 := by
    have h := Iff.mp sq_lt_sq hsqd
    rw [abs_of_nonneg (by positivity), abs_of_nonneg (by positivity)] at h
    exact h
  have h1 : (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) = ((13 * t / 8) ^ (1 / 2 : ℝ))⁻¹ := by
    rw [show (-1 / 2 : ℝ) = (-(1 / 2 : ℝ)) by ring,
      Real.rpow_neg (le_of_lt hx) (1 / 2 : ℝ)]
  have hinv2 : (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) = xh⁻¹ := by
    rw [h1, show ((13 * t / 8) ^ (1 / 2 : ℝ))⁻¹ = xh⁻¹ by rw [hxh]]
  have hdv : (1 / 2 : ℝ) * xh⁻¹ = (1 / 2) / xh := by ring
  rw [hinv2, hdv]
  rw [div_lt_div_iff₀ ht2 hx2]
  exact hmain
/-- THE GAP at the BOUND LEVEL: the mown floor is strictly BELOW
    the Bwire for every strip pair with t >= 1000. -/
theorem s4c_own_strip_gap (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    S4O.mown t d < BwireO t := by
  calc S4O.mown t d
      ≤ (16001 / 15984 : ℝ) / t ^ 2 := hMownT t d ht hd0 hd
    _ < (1 / 2) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) := hGapT0 t ht
    _ ≤ BwireO t := hBwireO_lb t ht

/-- SQUEEZE IMPOSSIBILITY: the S4 squeeze
    Bwire + Mr + Mf < mown(t,d) CANNOT hold on the strip for any
    nonnegative Mr, Mf. -/
theorem s4c_squeeze_impossible (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hd : d ≤ 1 / 2) (Mr Mf : ℝ) (hMr : 0 ≤ Mr) (hMf : 0 ≤ Mf) :
    ¬(BwireO t + Mr + Mf < S4O.mown t d) := by
  intro h
  have hgap := s4c_own_strip_gap t d ht hd0 hd
  linarith

end S4G
