import Mathlib
import RhAttack.S4Gap
import RhAttack.S4Own

/- S4d WIRE-SHARPNESS CERTIFICATE (25v) — "how much sharper is
   sharper" — GAP-O quantified (formal/RhAttack/S4Sharp.lean).

   The S4 program trail: S4a (S4Window) squeezed the window regime
   on [1000, T0]; S4b (S4Own) identified the own-height detector
   mass mown at the 4d²/t² scale; S4c (S4Gap) proved the own-regime
   squeeze IMPOSSIBLE at the current wire (mown < BwireO = p8_B(t,
   floor(13t/8)) on EVERY strip pair); S4Asm
   named the residue: a strictly sharper own-regime wire.  THIS
   MODULE QUANTIFIES HOW MUCH SHARPER, on the closure-relevant
   strip {d >= 1/200} (1/200 = 0.005 = p9_d_min, the closure's
   d-grid edge / Route A's price — the measured witness pairs LIVE
   on the d-grid, so the d -> 0 edge, where mown -> 0 trivially,
   is not closure-relevant):

     (1) hMown_ds / s4d_mown_dmin — the d-SHARP mown envelope:
           mown(t, d) <= (4 d² / t²) (16001/15984)
         (S4G.hMownT without the 4d² <= 1 collapse); at the d-edge
         1/200:  mown(t, 1/200) <= Eenv t.
     (2) s4d_wire_demand — THE DEMAND ENVELOPE: any wire W with
         nonnegative residuals Mr, Mf that CLOSES the strip squeeze
         on d >= 1/200 must satisfy
           W + Mr + Mf < Eenv(t) = (1/10⁴)(16001/15984) t^{-2}
         ~ 1.001064e-4 · t^{-2}.  i.e. the closing wire is an
         O(t^{-2}) identity with the explicit constant.
     (3) s4d_wire_deficit — the current wire sits ABOVE the demand
         by the DIVERGING factor  Kgap · t^{3/2},  Kgap =
         (1/2)(8/13)^{1/2}·10⁴·(15984/16001) ≈ 3918.66  (≈ 1.24e8
         at t = 1000):
           BwireO t >= Kgap · t^{3/2} · Eenv t.
     (4) s4d_scale_demand — no p8_B-FAMILY wire can close the gap
         near: its first term (1/2)n^{-1/2} at ANY scale n with
         (1/2)n^{-1/2} < Eenv t forces
           n > (5000·15984/16001)² · t⁴  ≈  2.495e7 · t⁴
         — a t⁴-scale wire, 1.54e7·t³ ABOVE the list scale
         floor(13t/8) — the deficit is a POWER of t, not a
         constant to tune.

   THE RESIDUE, NOW QUANTIFIED (25v): closing GAP-O requires an
   O(t^{-2}) structural identity for the own-regime definition
   side (the measured definition side already behaves at that
   scale — measured deficit O(1) vs the t^{3/2}-diverging bound
   deficit, 25l[3], script day023_s4_sweep.py — PINNED).  That is
   exactly the prize content the S4a header named: "the definition
   side at the 4d²/t² scale".

   Honest split: LEAN-PROVEN — every statement in this file is
   closed-form arithmetic over S4O/S4G lemmas; no pins.  The
   1/200 d-edge is the closure's pinned Route-A price (the d-grid
   protocol of C6).  Numeric pre-flight: 25l/25n/25p.  Lean
   4.33.1 + Mathlib (pinned).
-/

namespace S4S
open Real B0

/- — the two named quantities — -/

/-- THE DEMAND ENVELOPE (25v): Eenv(t) = (1/10⁴)(16001/15984)·t^{-2}
    — the bound any own-regime wire (+ its nonnegative residuals)
    must sit below at the closure-relevant d-edge 1/200.  ≈
    1.001064e-4 · t^{-2}. -/
noncomputable def Eenv (t : ℝ) : ℝ :=
    (1 / 10000 : ℝ) * (16001 / 15984 : ℝ) * t ^ (-2 : ℝ)

/-- THE SHARPNESS COEFFICIENT (25v): Kgap = (1/2)(8/13)^{1/2}·10⁴·
    (15984/16001) ≈ 3918.6646 — the wire/demand ratio per unit
    t^{3/2}. -/
noncomputable def Kgap : ℝ :=
    (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * 10000 * (15984 / 16001 : ℝ)

/- (1) the d-sharp mown envelope — -/

/-- The d-SHARP own-height envelope: S4G.hMownT's conclusion with
    the 4d² <= 1 collapse withheld — mown(t,d) <= (4d²/t²)(16001/15984)
    on the strip. -/
theorem hMown_ds (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    S4O.mown t d ≤ (4 * d ^ 2 / t ^ 2) * (16001 / 15984 : ℝ) := by
  have hS := S4O.hMownScaleHi t d (lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht) hd0 hd
  have ht2ge : t ^ 2 ≥ 1000 ^ 2 :=
    pow_le_pow_left₀ (by norm_num : (0 : ℝ) ≤ 1000) ht 2
  have hC : (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) ≤ (16001 / 15984 : ℝ) := by
    have h16 : 1 + 1 / (16 * t ^ 2) ≤ 16001 / 16000 := by
      have hq : 1 / (16 * t ^ 2) ≤ 1 / 16000 := by
        rw [div_le_div_iff₀ (by positivity : 0 < 16 * t ^ 2) (by norm_num : (0 : ℝ) < 16000)]
        nlinarith [ht2ge]
      linarith [hq]
    have he : Real.exp (1 / t ^ 2) ≤ Real.exp (1 / 1000) :=
      Real.exp_le_exp.mpr (by
        rw [div_le_div_iff₀ (by positivity : 0 < t ^ 2) (by norm_num : (0 : ℝ) < 1000)]
        nlinarith [ht2ge])
    have he2 : Real.exp (1 / 1000) ≤ 1000 / 999 := S4G.hExpT
    calc (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
        ≤ (16001 / 16000) * Real.exp (1 / t ^ 2) := by
          have := mul_le_mul_of_nonneg_left h16 (Real.exp_nonneg (1 / t ^ 2))
          ring_nf at this ⊢
          exact this
      _ ≤ (16001 / 16000) * Real.exp (1 / 1000) := by
          have := mul_le_mul_of_nonneg_left he (by positivity : (0 : ℝ) ≤ 16001 / 16000)
          ring_nf at this ⊢
          exact this
      _ ≤ (16001 / 16000) * (1000 / 999) := by
          have := mul_le_mul_of_nonneg_left he2 (by positivity : (0 : ℝ) ≤ 16001 / 16000)
          ring_nf at this ⊢
          exact this
      _ = 16001 / 15984 := by norm_num
  calc S4O.mown t d
      ≤ (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := hS
    _ ≤ (4 * d ^ 2 / t ^ 2) * (16001 / 15984 : ℝ) := by
        have := mul_le_mul_of_nonneg_left hC (by positivity : 0 ≤ 4 * d ^ 2 / t ^ 2)
        ring_nf at this ⊢
        exact this

/-- At the closure d-edge 1/200 the floor sits below the DEMAND
    ENVELOPE: mown(t, 1/200) <= Eenv t. -/
theorem s4d_mown_dmin (t : ℝ) (ht : 1000 ≤ t) :
    S4O.mown t (1 / 200) ≤ Eenv t := by
  have h := hMown_ds t (1 / 200) ht (by norm_num) (by norm_num)
  have htp : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
  have hred : (4 * (1 / 200) ^ 2 / t ^ 2 : ℝ) * (16001 / 15984 : ℝ) = Eenv t := by
    dsimp only [Eenv]
    have h4 : (4 : ℝ) * (1 / 200) ^ 2 = 1 / 10000 := by norm_num
    have htpow : 1 / t ^ 2 = t ^ (-2 : ℝ) := by
      have h2inv : (t ^ 2)⁻¹ = t ^ (-2 : ℝ) := by
        have h1 : (t ^ (2 : ℝ))⁻¹ = t ^ (-(2 : ℝ)) := (rpow_neg htp.le (2 : ℝ)).symm
        have h2 : (t : ℝ) ^ (2 : ℝ) = t ^ 2 := rpow_natCast t 2
        rw [h2.symm, h1]
      rw [one_div, h2inv]
    rw [show (4 * (1 / 200) ^ 2 / t ^ 2 : ℝ) = (4 * (1 / 200) ^ 2) * (1 / t ^ 2) by ring,
      h4, htpow]
    ring
  calc S4O.mown t (1 / 200)
      ≤ (4 * (1 / 200) ^ 2 / t ^ 2) * (16001 / 15984 : ℝ) := h
    _ = Eenv t := hred

/- (2) the demand — -/

/-- THE WIRE DEMAND (25v): any wire W (with its residuals Mr, Mf)
    that closes the own-regime strip squeeze on the closure-relevant
    d >= 1/200 must sit below the DEMAND ENVELOPE Eenv(t) =
    (1/10⁴)(16001/15984)·t^{-2} ~ 1.001064e-4·t^{-2}. -/
theorem s4d_wire_demand (t W Mr Mf : ℝ) (ht : 1000 ≤ t)
    (hclose : ∀ (d : ℝ), 1 / 200 ≤ d → d ≤ 1 / 2 → W + Mr + Mf < S4O.mown t d) :
    W + Mr + Mf < Eenv t := by
  have hd := hclose (1 / 200) (by norm_num) (by norm_num)
  have hdmin := s4d_mown_dmin t ht
  linarith [hd, hdmin]

/- (3) the current wire is above the demand by Kgap·t^{3/2} — -/

/-- (1/2)(13t/8)^{-1/2} = (1/2)(8/13)^{1/2}·t^{-1/2} exactly. -/
theorem hwire_first_term_exact (t : ℝ) (ht : 1000 ≤ t) :
    (1 / 2 : ℝ) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) =
        (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * t ^ (-1 / 2 : ℝ) := by
  have htp : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
  have hmul : ((13 / 8 : ℝ) * t) ^ (-1 / 2 : ℝ) =
      (13 / 8 : ℝ) ^ (-1 / 2 : ℝ) * t ^ (-1 / 2 : ℝ) := by
    rw [mul_rpow (by norm_num : (0 : ℝ) ≤ 13 / 8) htp.le]
  have hin : (13 / 8 : ℝ) ^ (-1 / 2 : ℝ) = (8 / 13 : ℝ) ^ (1 / 2 : ℝ) := by
    have hu : (13 / 8 : ℝ) ^ (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) = 1 := by
      rw [← mul_rpow (by norm_num : (0 : ℝ) ≤ 13 / 8) (by norm_num : (0 : ℝ) ≤ 8 / 13),
        show (13 / 8 : ℝ) * (8 / 13 : ℝ) = 1 by norm_num, Real.one_rpow]
    have ha : 0 < (13 / 8 : ℝ) ^ (1 / 2 : ℝ) :=
      rpow_pos_of_pos (by norm_num : (0 : ℝ) < 13 / 8) (1 / 2 : ℝ)
    have hne : (13 / 8 : ℝ) ^ (-1 / 2 : ℝ) = ((13 / 8 : ℝ) ^ (1 / 2 : ℝ))⁻¹ := by
      rw [show (-1 / 2 : ℝ) = (-(1 / 2 : ℝ)) by ring,
        rpow_neg (by norm_num : (0 : ℝ) ≤ 13 / 8) (1 / 2 : ℝ)]
    rw [hne]
    have ha1 : (13 / 8 : ℝ) ^ (1 / 2 : ℝ) ≠ 0 := ne_of_gt ha
    have hg : (13 / 8 : ℝ) ^ (1 / 2 : ℝ) * ((13 / 8 : ℝ) ^ (1 / 2 : ℝ))⁻¹ =
        (13 / 8 : ℝ) ^ (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) := by
      have hL : (13 / 8 : ℝ) ^ (1 / 2 : ℝ) * ((13 / 8 : ℝ) ^ (1 / 2 : ℝ))⁻¹ = 1 :=
        mul_inv_cancel₀ ha1
      rw [hL]
      exact hu.symm
    apply mul_right_injective₀ ha1
    exact hg
  rw [show (13 * t / 8 : ℝ) = (13 / 8 : ℝ) * t by ring, hmul, hin]
  ring

/-- Kgap·t^{3/2}·Eenv(t) = (1/2)(8/13)^{1/2}·t^{-1/2} exactly (the
    constants cancel; t^{3/2}/t² = t^{-1/2}). -/
theorem hKgap_env_collapse (t : ℝ) (ht : 1000 ≤ t) :
    (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * t ^ (-1 / 2 : ℝ) =
        Kgap * t ^ (3 / 2 : ℝ) * Eenv t := by
  have htp : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
  have hpow : t ^ (3 / 2 : ℝ) * t ^ (-2 : ℝ) = t ^ (-1 / 2 : ℝ) := by
    rw [← rpow_add htp (3 / 2 : ℝ) (-2 : ℝ)]
    norm_num
  have hconst : 10000 * (15984 / 16001 : ℝ) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ)) = 1 := by
    norm_num
  calc (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * t ^ (-1 / 2 : ℝ)
      = (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * (t ^ (3 / 2 : ℝ) * t ^ (-2 : ℝ)) := by
        rw [hpow]
    _ = (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * 10000 * (15984 / 16001 : ℝ) *
          ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ)) * t ^ (3 / 2 : ℝ) * t ^ (-2 : ℝ) := by
        have hx : (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) =
            (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) *
            (10000 * (15984 / 16001 : ℝ)) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ)) := by
          have hc : 10000 * (15984 / 16001 : ℝ) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ)) = 1 := by
            norm_num
          have hc' : (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * 10000 *
              (15984 / 16001 : ℝ) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ)) =
              (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) := by
            calc (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * 10000 *
                    (15984 / 16001 : ℝ) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ))
                = (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) *
                    (10000 * (15984 / 16001 : ℝ) * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ))) := by
                  ring
              _ = (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * 1 := by
                  rw [hc]
              _ = (1 / 2 : ℝ) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) := by ring
          rw [← hc']
          ring
        rw [hx]
        ring
    _ = Kgap * t ^ (3 / 2 : ℝ) * Eenv t := by
        dsimp only [Kgap, Eenv]
        ring

/-- THE SHARPNESS CERTIFICATE (25v): for every t >= 1000 the
    current own-strip wire sits ABOVE the demand envelope by the
    diverging factor Kgap·t^{3/2} (≈ 3918.66·t^{3/2}; ≈ 1.2392e8
    at t = 1000):  BwireO t >= Kgap · t^{3/2} · Eenv t. -/
theorem s4d_wire_deficit (t : ℝ) (ht : 1000 ≤ t) :
    S4G.BwireO t ≥ Kgap * t ^ (3 / 2 : ℝ) * Eenv t := by
  have hlb := S4G.hBwireO_lb t ht
  have hA := hwire_first_term_exact t ht
  have hB := hKgap_env_collapse t ht
  calc S4G.BwireO t
      ≥ (1 / 2) * (13 * t / 8 : ℝ) ^ (-1 / 2 : ℝ) := hlb
    _ = (1 / 2) * (8 / 13 : ℝ) ^ (1 / 2 : ℝ) * t ^ (-1 / 2 : ℝ) := hA
    _ = Kgap * t ^ (3 / 2 : ℝ) * Eenv t := hB

/- (4) no p8_B-family wire closes it at list scale — -/

/-- SCALE DEMAND (25v): a first-term wire (1/2)n^{-1/2} (the p8_B
    family, ANY scale n) that gets below the demand envelope forces
    n > (5000·15984/16001)²·t⁴ ≈ 2.495e7·t⁴ — a t⁴-scale wire.
    The list scale floor(13t/8) is O(t): below the demand scale by
    a factor 1.54e7·t³ — the deficit is a POWER of t. -/
theorem s4d_scale_demand (t n : ℝ) (ht : 1000 ≤ t) (hn : 0 < n)
    (hclose : (1 / 2 : ℝ) * n ^ (-1 / 2 : ℝ) < Eenv t) :
    n > (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 := by
  have htp : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
  dsimp only [Eenv] at hclose
  set Xp := (1 / 5000 : ℝ) * (16001 / 15984 : ℝ) * t ^ (-2 : ℝ) with hXp_def
  have h1 : n ^ (-1 / 2 : ℝ) < Xp := by
    have hc : 2 * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ) * t ^ (-2 : ℝ)) = Xp := by
      rw [hXp_def]
      ring
    calc n ^ (-1 / 2 : ℝ)
        = 2 * ((1 / 2 : ℝ) * n ^ (-1 / 2 : ℝ)) := by ring
      _ < 2 * ((1 / 10000 : ℝ) * (16001 / 15984 : ℝ) * t ^ (-2 : ℝ)) :=
        mul_lt_mul_of_pos_left hclose (by norm_num : (0 : ℝ) < 2)
      _ = Xp := by rw [hc]
  have hinvn : n ^ (-1 / 2 : ℝ) = (n ^ (1 / 2 : ℝ))⁻¹ := by
    rw [show (-1 / 2 : ℝ) = (-(1 / 2 : ℝ)) by ring,
      rpow_neg hn.le (1 / 2 : ℝ)]
  have hAn : 0 < n ^ (1 / 2 : ℝ) := rpow_pos_of_pos hn (1 / 2 : ℝ)
  have hXp : 0 < Xp := by
    rw [hXp_def]
    apply mul_pos
    · norm_num
    · exact rpow_pos_of_pos htp (-2 : ℝ)
  have h1' : (1 / n ^ (1 / 2 : ℝ)) < Xp := by
    rw [one_div]
    rw [hinvn] at h1
    exact h1
  have h2 : Xp⁻¹ < n ^ (1 / 2 : ℝ) := by
    have h3 : 1 / Xp < n ^ (1 / 2 : ℝ) :=
      (one_div_lt hXp hAn).mpr h1'
    rw [one_div] at h3
    exact h3
  have hXinv : Xp⁻¹ = 5000 * (15984 / 16001 : ℝ) * t ^ 2 := by
    have hinvA : ((1 / 5000 : ℝ) * (16001 / 15984 : ℝ))⁻¹ = 5000 * (15984 / 16001 : ℝ) := by
      field_simp
    have hinvT : (t ^ (-2 : ℝ))⁻¹ = t ^ 2 := by
      have h1 : t ^ (-2 : ℝ) = (t ^ (2 : ℝ))⁻¹ := rpow_neg htp.le (2 : ℝ)
      have h2 : (t ^ (-2 : ℝ))⁻¹ = (t ^ (2 : ℝ)) := by rw [h1, inv_inv (t ^ (2 : ℝ))]
      rw [h2]
      exact rpow_natCast t 2
    rw [hXp_def]
    calc ((1 / 5000 : ℝ) * (16001 / 15984 : ℝ) * t ^ (-2 : ℝ))⁻¹
        = (((1 / 5000 : ℝ) * (16001 / 15984 : ℝ)) * t ^ (-2 : ℝ))⁻¹ := by ring
      _ = (((1 / 5000 : ℝ) * (16001 / 15984 : ℝ))⁻¹) * (t ^ (-2 : ℝ))⁻¹ := by rw [mul_inv_rev, mul_comm]
      _ = (5000 * (15984 / 16001 : ℝ)) * t ^ 2 := by rw [hinvA, hinvT]
  have h3 : n ^ (1 / 2 : ℝ) > 5000 * (15984 / 16001 : ℝ) * t ^ 2 := by
    have h2' : Xp⁻¹ < n ^ (1 / 2 : ℝ) := h2
    rw [hXinv] at h2'
    exact h2'
  have hn2 : n = (n ^ (1 / 2 : ℝ)) ^ 2 := by
    rw [← Real.sqrt_eq_rpow n, Real.sq_sqrt (le_of_lt hn)]
  have hy0 : 0 ≤ 5000 * (15984 / 16001 : ℝ) * t ^ 2 := by positivity
  have hY2 : (5000 * (15984 / 16001 : ℝ) * t ^ 2) ^ 2 =
      (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 := by
    ring
  have hsq : (n ^ (1 / 2 : ℝ)) ^ 2 > (5000 * (15984 / 16001 : ℝ) * t ^ 2) ^ 2 := by
    have hA := (mul_self_lt_mul_self_iff hy0 (le_of_lt hAn)).mp h3
    simpa [pow_two] using hA
  have hsq' : (n ^ (1 / 2 : ℝ)) ^ 2 > (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 := by
    rw [hY2] at hsq
    exact hsq
  rw [hn2]
  exact hsq'

/- — the list-scale corollary — -/

/-- THE LIST-SCALE WALL (25v): no scale n <= list scale 13t/8 of
    the p8_B family (first term (1/2)n^{-1/2}) sits below the
    demand envelope, for every t >= 1000. -/
theorem s4d_list_scale_impossible (t : ℝ) (ht : 1000 ≤ t) (n : ℝ)
    (hn : 0 < n) (hnu : n ≤ 13 * t / 8) :
    ¬((1 / 2 : ℝ) * n ^ (-1 / 2 : ℝ) < Eenv t) := by
  intro h
  have hreq := s4d_scale_demand t n ht hn h
  have hreq' : (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 < n := by linarith [hreq]
  have hmax : n ≤ 13 * t / 8 := hnu
  have hneed : 13 * t / 8 < (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 := by
    have htp : 0 < t := lt_of_lt_of_le (by norm_num : (0 : ℝ) < 1000) ht
    have htp2 : 0 < t ^ 2 := by positivity
    have htp4 : 0 < t ^ 4 := by positivity
    have hbig : (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 > 13 * t / 8 := by
      have hcoef : (5000 * 15984 / 16001 : ℝ) ^ 2 > 13 / 8 := by
        norm_num
      have htp3pos : 0 < t ^ 3 := by positivity
      have h1 : (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 4 =
          (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 3 * t := by ring
      have h2 : 13 * t / 8 = (13 / 8 : ℝ) * t := by ring
      rw [h1, h2]
      have h3 : (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 3 > 13 / 8 := by
        have hht : (1 : ℝ) < t := by linarith [ht]
        have h1t2 : t < t ^ 2 := by
          have hA := mul_lt_mul_of_pos_left hht htp
          simpa [mul_one, pow_two] using hA
        have ht3 : (1 : ℝ) < t ^ 3 := by
          have ht23 : t ^ 2 < t ^ 3 := by
            have hA := mul_lt_mul_of_pos_left h1t2 htp
            have hB : t * t = t ^ 2 := by ring
            have hC : t * t ^ 2 = t ^ 3 := by ring
            rw [hB, hC] at hA
            exact hA
          calc (1 : ℝ) < t := hht
            _ < t ^ 2 := h1t2
            _ < t ^ 3 := ht23
        have hstep : (13 / 8 : ℝ) < (13 / 8 : ℝ) * t ^ 3 := by
          have hA : (13 / 8 : ℝ) * 1 < (13 / 8 : ℝ) * t ^ 3 :=
            mul_lt_mul_of_pos_left ht3 (by norm_num : (0 : ℝ) < 13 / 8)
          rwa [mul_one] at hA
        have hstep2 : (13 / 8 : ℝ) * t ^ 3 < (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 3 :=
          mul_lt_mul_of_pos_right hcoef (by positivity)
        linarith [hstep, hstep2]
      have h4 : (5000 * 15984 / 16001 : ℝ) ^ 2 * t ^ 3 * t > (13 / 8 : ℝ) * t := by
        apply mul_lt_mul_of_pos_right h3
        exact htp
      linarith
    linarith [hbig]
  linarith [hmax, hneed]

end S4S
