/-
# (S3a)  The detector algebraic core:  exact monotonicity and crossing.

Lean port of the S3a detector bound (END_GAME_PLAN section 3.4, queue
item 4):  the rational part of R_closed on the quantized straddles
t = g + k/2, k a nonzero integer, d in [0, 1/2]:

  Ralg(g, k, d) = (g^2 + 1/4) (k^2/4 + d^2) ((2g + k/2)^2 + d^2)
                  ------------------------------------------------
                  (k/2) (2g + k/2) (g^2 + (1/2 + d)^2) (g^2 + (1/2 - d)^2)

(the absolute value of the algebraic core;  k > 0 without loss by
sign symmetry).  The measured facts (probe scripts/rh/day035_s3a_probe.py,
exact Fraction algebra tmp/s3a_exact*.py) are now LEAN lemmas:

  (crossing)  the exact g0 crossing:  Ralg(14, 12, 1/2) > 1 and
              Ralg(15, 12, 1/2) < 1  (g0 = 15:  below 15 the detector
              core can exceed 1, and is finite pinned data territory);
  (d-corner)  for g >= 15, 1 <= k <= 12, 0 <= d <= 1/2 the corner
              d = 1/2 is uniform worst:  Ralg(g, k, d) <= Ralg(g, k, 1/2);
  (k-mon)     for g >= 15, 1 <= k < 12 the outer straddle is uniform
              worst:  Rcorner(g, k) <= Rcorner(g, k + 1);
  (decay)     Rcorner(g, 12) < 1 for g >= 15 and
              Rcorner(g, 12) <= 13 / g for g >= 40  (the dev
              lower bound 1 - 13/g at large g;  the ~12/g rate is
              asymptotic — the exact corner ratio sits at ~12.8/g at
              g = 1e5 by the probe, below 13/g from g >= 40 on).

The exponential factor of R_closed (|exp(s w)| = exp(w/2), w a real
O(1/g^2) combination) is carried by the already-proven C1b discrete
floor (p9_c1b_disc_floor, 1 - 25/g with the 23/1000 witness-scale
margin) and by the wire algebra;  this module is the pure algebraic
side that the certificate composes with.
-/
import Mathlib

-- S3a is a heavy algebraic-certificate file:  the d-corner and
-- k-monotonicity statements carry large ring-certified polynomial identities,
-- so the file-wide heartbeat budget is raised (Lean 4 default is 200000).
set_option maxHeartbeats 400000

open BigOperators

namespace S3a

/-- The algebraic core on the quantized straddle (see file header). -/
noncomputable def Ralg (g k d : ℝ) : ℝ :=
  (g * g + 1 / 4) * ((k / 2) ^ 2 + d * d) * ((2 * g + k / 2) ^ 2 + d * d) /
    ((k / 2) * (2 * g + k / 2) *
      (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2))

/-- At d = 1/2 the (1/2 - d) square collapses to 0 and the core
simplifies:  Rcorner(g, k) =
(g^2 + 1/4)(k^2 + 1)((4g + k)^2 + 1) / (4 k (4g + k)(g^2 + 1) g^2). -/
noncomputable def Rcorner (g k : ℝ) : ℝ :=
  (g * g + 1 / 4) * (k * k + 1) * ((4 * g + k) ^ 2 + 1) /
    (4 * k * (4 * g + k) * (g * g + 1) * g * g)

/-- The ratio bridge missing from the pin (the usual div_le_div lemma
family is trimmed from this mathlib snapshot):  a / c <= b / d follows
from a * d <= b * c, with positive denominators. -/
theorem div_le_div_of_mul (a b c d : ℝ) (hc : 0 < c) (hd : 0 < d)
    (h : a * d ≤ b * c) : a / c ≤ b / d := by
  set D := c * d with hD_def
  have hDpos : 0 < D := by
    rw [hD_def]
    exact mul_pos hc hd
  have hA : a / c * D = a * d := by
    rw [hD_def]
    field_simp [hc.ne', hd.ne']
  have hB : b / d * D = b * c := by
    rw [hD_def]
    field_simp [hc.ne', hd.ne']
  have hmul : a / c * D ≤ b / d * D := by
    rw [hA, hB]
    exact h
  have hdinv : 0 ≤ D⁻¹ := inv_nonneg.mpr (le_of_lt hDpos)
  calc
    a / c = (a / c * D) * D⁻¹ := by field_simp [hDpos.ne']
    _ ≤ (b / d * D) * D⁻¹ := mul_le_mul_of_nonneg_right hmul hdinv
    _ = b / d := by field_simp [hDpos.ne']

/-- The exact corner simplification at d = 1/2. -/
theorem corner_eq (g k : ℝ) (hg : 0 < g) (hk : 0 < k) :
    Ralg g k (1 / 2) = Rcorner g k := by
  dsimp [Ralg, Rcorner]
  have hgk : 0 < 2 * g + k / 2 := by linarith [hg, hk]
  have h4gk : 0 < 4 * g + k := by linarith [hg, hk]
  have hgnz : g ≠ 0 := by linarith
  field_simp [hg, hk, hgk, h4gk, hgnz]
  ring

/-- (crossing)  below the crossing:  Ralg(14, 12, 1/2) > 1. -/
theorem s3a_crossing14 : Ralg 14 12 (1 / 2) > 1 := by
  rw [corner_eq (14 : ℝ) 12 (by norm_num) (by norm_num)]
  norm_num [Rcorner]

/-- (crossing)  at the crossing:  Ralg(15, 12, 1/2) < 1  (exact g0 = 15). -/
theorem s3a_crossing15 : Ralg 15 12 (1 / 2) < 1 := by
  rw [corner_eq (15 : ℝ) 12 (by norm_num) (by norm_num)]
  norm_num [Rcorner]

/-! (d-corner)  uniform worst d = 1/2.  Structure:  with
M := (4g + k)^2, A := (k^2 + 1)(M + 1), B := (k^2 + 4d^2)(M + 4d^2)
and h(d) := (g^2 + (1/2+d)^2)(g^2 + (1/2-d)^2), for 0 <= d <= 1/2 we have
B <= A  (from 4d^2 <= 1, twice)  and
h(d) = g^2 (g^2 + 1) + g^2 (2 d^2) + (1/4 - d^2)^2  >=  g^2 (g^2 + 1),
so the cross-multiplied difference  A h(d) - g^2 (g^2 + 1) B  is bounded
below by  g^2 (g^2 + 1) (A - B) >= 0. -/
private theorem s3a_kg2 (g kR : ℝ) (hg : 15 ≤ g) (hkR : 1 ≤ kR) (hkl : kR ≤ 12) :
    kR * kR + 1 ≤ 2 * g * g + 2 := by
  have h1 : kR * kR ≤ 12 * kR :=
    mul_le_mul_of_nonneg_right hkl (le_of_lt (by linarith [hkR]))
  have h2 : 12 * kR ≤ 144 := by
    calc
      12 * kR = kR * 12 := by ring
      _ ≤ 12 * 12 := mul_le_mul_of_nonneg_right hkl (by norm_num)
      _ = 144 := by norm_num
  have h145 : 145 ≤ 2 * g * g + 2 := by nlinarith
  linarith [h1, h2, h145]

theorem s3a_dcorner (g : ℝ) (hg : 15 ≤ g) (k : ℕ) (hk : 1 ≤ k) (hkL : k ≤ 12)
    (d : ℝ) (hdd : 0 ≤ d) (hddh : d ≤ 1 / 2) :
    Ralg g (k : ℝ) d ≤ Ralg g (k : ℝ) (1 / 2) := by
  let kR : ℝ := (k : ℝ)
  have hkR : 1 ≤ kR := by
    dsimp only [kR]
    exact_mod_cast hk
  set M := (4 * g + kR) ^ 2 with hM_def
  set A := (kR * kR + 1) * (M + 1) with hA_def
  set HH := (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2) with hHH_def
  set x := d * d with hx_def
  have hxL : x ≤ 1 / 4 := by
    rw [hx_def]
    nlinarith [hddh]
  have hkl : kR ≤ 12 := by
    dsimp only [kR]
    exact_mod_cast hkL
  have h144 : 12 * kR ≤ 144 := by
    calc
      12 * kR = kR * 12 := by ring
      _ ≤ 12 * 12 := mul_le_mul_of_nonneg_right hkl (by norm_num)
      _ = 144 := by norm_num
  have hkk : kR * kR ≤ 144 := by
    have h1 : kR * kR ≤ 12 * kR :=
      mul_le_mul_of_nonneg_right hkl (by linarith [hkR])
    linarith [h1, h144]
  have hkkp : kR * kR + 1 ≤ 145 := by linarith [hkk]
  have hM1pos : 0 ≤ M + 1 := by
    dsimp only [M]
    positivity
  have hM1 : (4 * g + kR) ^ 2 + 1 ≤ (4 * g + 12) ^ 2 + 1 := by
    have h4gk : 4 * g + kR ≤ 4 * g + 12 := by linarith [hkl]
    have h4g12 : 0 ≤ 4 * g + 12 := by linarith
    have h4gk0 : 0 ≤ 4 * g + kR := by linarith
    have hsq : (4 * g + kR) ^ 2 ≤ (4 * g + 12) ^ 2 := by
      nlinarith [h4gk, h4g12, h4gk0]
    linarith [hsq]
  have hC1 : 16 * g * g * (g * g) + 16 * g * g ≥ 145 * ((4 * g + 12) ^ 2 + 1) := by
    set v := g - 15 with hv_def
    have hv : 0 ≤ v := by linarith
    have hc : 16 * g * g * (g * g) + 16 * g * g - 145 * ((4 * g + 12) ^ 2 + 1) =
        (61775 : ℝ) + 132960 * (g - 15) + 19296 * (g - 15) ^ 2 +
          960 * (g - 15) ^ 3 + 16 * (g - 15) ^ 4 := by
      ring
    have hgoal : 0 ≤ 16 * g * g * (g * g) + 16 * g * g - 145 * ((4 * g + 12) ^ 2 + 1) := by
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    linarith [hgoal]
  have hA145 : (kR * kR + 1) * (M + 1) ≤ 145 * (M + 1) :=
    mul_le_mul_of_nonneg_right hkkp hM1pos
  have hA145b : (kR * kR + 1) * (M + 1) ≤ 145 * ((4 * g + 12) ^ 2 + 1) := by
    have h4gk : 4 * g + kR ≤ 4 * g + 12 := by linarith [hkl]
    have h4g12 : 0 ≤ 4 * g + 12 := by linarith
    have h4gk0 : 0 ≤ 4 * g + kR := by linarith
    have hsq : (4 * g + kR) ^ 2 + 1 ≤ (4 * g + 12) ^ 2 + 1 := by
      nlinarith [h4gk, h4g12, h4gk0]
    have hmid : 145 * (M + 1) ≤ 145 * ((4 * g + 12) ^ 2 + 1) := by
      dsimp only [M]
      exact mul_le_mul_of_nonneg_left hsq (by norm_num)
    linarith [hA145, hmid]
  have hPPn : A - 16 * (g * g * (g * g) + g * g) ≤ 0 := by
    dsimp only [A, M]
    have h1 : (kR * kR + 1) * (M + 1) ≤ 145 * ((4 * g + 12) ^ 2 + 1) := by
      have h4gk : 4 * g + kR ≤ 4 * g + 12 := by linarith [hkl]
      have h4g12 : 0 ≤ 4 * g + 12 := by linarith
      have h4gk0 : 0 ≤ 4 * g + kR := by linarith
      have hsq : (4 * g + kR) ^ 2 + 1 ≤ (4 * g + 12) ^ 2 + 1 := by
        nlinarith [h4gk, h4g12, h4gk0]
      exact le_trans hA145 (mul_le_mul_of_nonneg_left hsq (by norm_num))
    have h2 : 145 * ((4 * g + 12) ^ 2 + 1) ≤ 16 * g * g * (g * g) + 16 * g * g := by
      linarith [hC1]
    have h3 : (kR * kR + 1) * (M + 1) ≤ 16 * g * g * (g * g) + 16 * g * g := by
      linarith [h1, h2]
    nlinarith [h3]
  set D0 := A * (g * g + 1 / 4) ^ 2 - kR * kR * M * (g * g * (g * g) + g * g)
      with hD0_def
  have hD0id : D0 = (kR * kR + M + 1) * (g * g * (g * g)) +
      ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) +
      (kR * kR + 1) * (M + 1) / 16 := by
    dsimp only [D0, A, M]
    ring
  have hD0nn : 0 ≤ D0 := by
    by_cases hk1 : k = 1
    · -- k = 1:  D0 = (M+2) g^4 + g^2 + M/8 + 1/8
      have hd0 : D0 = (M + 2) * (g * g * (g * g)) + (g * g) + M / 8 + 1 / 8 := by
        dsimp only [D0, A, kR]
        rw [hk1]
        ring
      rw [hd0]
      have hm : 0 ≤ M := by
        dsimp only [M]
        exact sq_nonneg (4 * g + kR)
      apply add_nonneg
      · apply add_nonneg
        · apply add_nonneg
          · apply mul_nonneg
            · have hM2 : 0 ≤ M + 2 := by linarith [hm]
              exact hM2
            · exact mul_self_nonneg (g * g)
          · exact mul_self_nonneg g
        · apply div_nonneg
          · exact hm
          · norm_num
      · norm_num
    · -- k >= 2
      have hk2 : 2 ≤ k := by omega
      have h225 : 225 ≤ g * g := by nlinarith
      have hg2nn : 0 ≤ g * g := by nlinarith
      have hg4nn : 0 ≤ g * g * (g * g) :=
        mul_self_nonneg (g * g)
      have hk2nn : 0 ≤ kR * kR := mul_self_nonneg kR
      have hm : 0 ≤ M := by
        dsimp only [M]
        exact sq_nonneg (4 * g + kR)
      have hE1 : (M + 1) * (g * g * (g * g)) ≤ (kR * kR + M + 1) * (g * g * (g * g)) := by
        have hM1 : M + 1 ≤ kR * kR + M + 1 := by
          have hadd : 0 ≤ kR * kR := hk2nn
          linarith
        exact mul_le_mul_of_nonneg_right hM1 hg4nn
      have h225g : 225 * (g * g) ≤ g * g * (g * g) :=
        mul_le_mul_of_nonneg_right h225 hg2nn
      have hE1c : (M + 1) * (225 * (g * g)) ≤ (M + 1) * (g * g * (g * g)) :=
        mul_le_mul_of_nonneg_left h225g hM1pos
      have hk2143 : kR * kR - 1 ≤ 143 := by linarith [hkk]
      have hMk : M * (kR * kR - 1) ≤ M * 143 :=
        mul_le_mul_of_nonneg_left hk2143 hm
      have hMk2 : -M * 143 * (1 / 2) ≤ -M * (kR * kR - 1) * (1 / 2) := by
        have hmid : -(M * 143) * (1 / 2) ≤ -(M * (kR * kR - 1)) * (1 / 2) :=
          mul_le_mul_of_nonneg_right (neg_le_neg hMk) (by norm_num)
        rw [show -M * 143 * (1 / 2) = -(M * 143) * (1 / 2) from by ring,
            show -M * (kR * kR - 1) * (1 / 2) = -(M * (kR * kR - 1)) * (1 / 2) from by ring]
        exact hmid
      have hMk2g : -M * 143 * (1 / 2) * (g * g) ≤
          -M * (kR * kR - 1) * (1 / 2) * (g * g) :=
        mul_le_mul_of_nonneg_right hMk2 hg2nn
      have hTpos : ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) ≥
          -M * (kR * kR - 1) * (1 / 2) * (g * g) := by
        have htid : ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) =
            (-M * (kR * kR - 1) * (1 / 2) + (kR * kR + 1) * (1 / 2)) * (g * g) := by ring
        rw [htid]
        have hpos : 0 ≤ (kR * kR + 1) * (1 / 2) * (g * g) :=
          mul_nonneg (mul_nonneg (add_nonneg (mul_self_nonneg kR) (by norm_num))
            (by norm_num)) hg2nn
        have hdist : (-M * (kR * kR - 1) * (1 / 2) + (kR * kR + 1) * (1 / 2)) * (g * g) =
            -M * (kR * kR - 1) * (1 / 2) * (g * g) + (kR * kR + 1) * (1 / 2) * (g * g) := by ring
        rw [hdist]
        exact (le_add_of_nonneg_right hpos).ge
      have hE2 : ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) ≥
          -M * 143 * (1 / 2) * (g * g) := by
        calc
          _ ≥ -M * (kR * kR - 1) * (1 / 2) * (g * g) := hTpos
          _ ≥ -M * 143 * (1 / 2) * (g * g) := by
            have hr : -M * (kR * kR - 1) * (1 / 2) * (g * g) =
                (-M * (kR * kR - 1) * (1 / 2)) * (g * g) := by ring
            have hr2 : -M * 143 * (1 / 2) * (g * g) =
                (-M * 143 * (1 / 2)) * (g * g) := by ring
            rw [hr, hr2]
            exact mul_le_mul_of_nonneg_right hMk2 hg2nn
      have hco : 0 ≤ 225 * (M + 1) - M * 143 / 2 := by
        rw [show 225 * (M + 1) - M * 143 / 2 = 225 + (307 / 2) * M from by ring]
        apply add_nonneg
        · norm_num
        · exact mul_nonneg (by norm_num) hm
      have hE3 : 0 ≤ (kR * kR + 1) * (M + 1) / 16 := by
        apply div_nonneg
        · exact mul_nonneg (add_nonneg (mul_self_nonneg kR) (by norm_num)) hM1pos
        · norm_num
      rw [hD0id]
      calc
        0
          ≤ 225 * (M + 1) * (g * g) - M * 143 * (1 / 2) * (g * g) := by
            rw [show 225 * (M + 1) * (g * g) - M * 143 * (1 / 2) * (g * g) =
              (225 * (M + 1) - M * 143 / 2) * (g * g) from by ring]
            exact mul_nonneg hco hg2nn
          _ ≤ (M + 1) * (g * g * (g * g)) - M * 143 * (1 / 2) * (g * g) := by
            rw [show 225 * (M + 1) * (g * g) = (M + 1) * (225 * (g * g)) from by ring]
            exact sub_le_sub_right hE1c (M * 143 * (1 / 2) * (g * g))
          _ ≤ (M + 1) * (g * g * (g * g)) - M * 143 * (1 / 2) * (g * g) +
              (kR * kR + 1) * (M + 1) / 16 :=
            le_add_of_nonneg_right hE3
          _ ≤ (kR * kR + M + 1) * (g * g * (g * g)) -
              M * 143 * (1 / 2) * (g * g) +
              (kR * kR + 1) * (M + 1) / 16 := by
            have hE1s : (M + 1) * (g * g * (g * g)) ≤
                (kR * kR + M + 1) * (g * g * (g * g)) := hE1
            rw [show (M + 1) * (g * g * (g * g)) - M * 143 * (1 / 2) * (g * g) +
                (kR * kR + 1) * (M + 1) / 16 =
                ((M + 1) * (g * g * (g * g)) - M * 143 * (1 / 2) * (g * g)) +
                  (kR * kR + 1) * (M + 1) / 16 from by ring]
            exact add_le_add (sub_le_sub_right hE1s (M * 143 * (1 / 2) * (g * g))) (le_rfl)
          _ ≤ (kR * kR + M + 1) * (g * g * (g * g)) +
              ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) +
              (kR * kR + 1) * (M + 1) / 16 := by
            have hr : (kR * kR + M + 1) * (g * g * (g * g)) -
                M * 143 * (1 / 2) * (g * g) +
                (kR * kR + 1) * (M + 1) / 16 =
                ((kR * kR + M + 1) * (g * g * (g * g)) -
                  M * 143 * (1 / 2) * (g * g)) + (kR * kR + 1) * (M + 1) / 16 := by
              ring
            rw [hr]
            have hr2 : (kR * kR + M + 1) * (g * g * (g * g)) +
                ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) +
                (kR * kR + 1) * (M + 1) / 16 =
                ((kR * kR + M + 1) * (g * g * (g * g)) +
                  ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g)) +
                  (kR * kR + 1) * (M + 1) / 16 := by
              ring
            rw [hr2]
            exact add_le_add (add_le_add
                (le_rfl) (by
                  have hs : -M * 143 * (1 / 2) * (g * g) ≤
                      ((kR * kR + 1) - M * (kR * kR - 1)) / 2 * (g * g) := hE2
                  linarith [hs])) (le_rfl)
  set PP := A - 16 * (g * g * (g * g) + g * g) with hPP_def
  have hPPn2 : PP ≤ 0 := hPPn
  set D := A * (g * g * (g * g) + g * g * (1 / 2 + 2 * x) + (1 / 4 - x) ^ 2) -
      (kR * kR + 4 * x) * (M + 4 * x) * (g * g * (g * g) + g * g) with hD_def
  have hChord : D = (1 - 4 * x) * D0 + PP * x * (x - 1 / 4) := by
    dsimp only [D, D0, PP, A, M]
    ring
  have hDnn : 0 ≤ D := by
    rw [hChord]
    have h1 : 0 ≤ (1 - 4 * x) * D0 :=
      mul_nonneg (by linarith [hxL]) hD0nn
    have hxnn : 0 ≤ x := by
      rw [hx_def]
      exact mul_self_nonneg d
    have h2 : 0 ≤ PP * x * (x - 1 / 4) := by
      have hrew : PP * x * (x - 1 / 4) = -PP * x * (1 / 4 - x) := by ring
      rw [hrew]
      apply mul_nonneg
      · apply mul_nonneg
        · exact neg_nonneg.mpr hPPn2
        · exact hxnn
      · exact sub_nonneg.mpr hxL
    exact add_nonneg h1 h2
  have hHHx : (g * g * (g * g) + g * g * (1 / 2 + 2 * x) + (1 / 4 - x) ^ 2) = HH := by
    dsimp only [HH]
    rw [hx_def]
    ring
  have hcore : (g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d) ≤
      (kR * kR + 1) * (M + 1) * HH := by
    have hB : (kR * kR + 4 * d * d) * (M + 4 * d * d) = (kR * kR + 4 * x) * (M + 4 * x) := by
      rw [hx_def]
      ring
    have X := (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g)
    have hDb : D + (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) =
        (kR * kR + 1) * (M + 1) * HH := by
      dsimp only [D]
      rw [hHHx]
      ring
    have hDb2 : (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) + D =
        (kR * kR + 1) * (M + 1) * HH := by
      have hcomm : (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) + D =
          D + (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) := by ring
      rw [hcomm]
      exact hDb
    have hX : (g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d) =
        (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) := by
      rw [hx_def]
      ring
    rw [hX]
    calc
      _ ≤ (kR * kR + 4 * x) * (M + 4 * x) * ((g * g + 1) * g * g) + D :=
        le_add_of_nonneg_right hDnn
      _ = (kR * kR + 1) * (M + 1) * HH := hDb2

  set Fc := (g * g + 1 / 4) * kR * (4 * g + kR) / 4 with hFc_def
  have hFcp : 0 < Fc := by
    dsimp only [Fc]
    have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
    have hg2p : 0 < g * g := mul_pos h0g h0g
    have hkRp : 0 < kR := lt_of_lt_of_le (by norm_num) hkR
    have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
    have h4gkp : 0 < 4 * g + kR := by
      have hkknn : 0 ≤ kR := le_trans (by norm_num) hkR
      have hl : 4 * g ≤ 4 * g + kR := by
        have hs : 4 * g + 0 ≤ 4 * g + kR := add_le_add_right hkknn (4 * g)
        simpa [add_zero] using hs
      exact lt_of_lt_of_le h4gp hl
    have hg2qp : 0 < g * g + 1 / 4 := by
      have hl : g * g ≤ g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        simpa [add_zero] using hs
      exact lt_of_lt_of_le hg2p hl
    have h1 : 0 < (g * g + 1 / 4) * kR * (4 * g + kR) := by
      apply mul_pos
      · apply mul_pos
        · exact hg2qp
        · exact hkRp
      · exact h4gkp
    exact div_pos h1 (by norm_num)
  have hb1 : 4 * ((kR / 2) ^ 2 + d * d) = kR * kR + 4 * d * d := by ring
  have hb2 : 4 * ((2 * g + kR / 2) ^ 2 + d * d) = (4 * g + kR) ^ 2 + 4 * d * d := by ring
  have hL : (g * g + 1 / 4) * ((kR / 2) ^ 2 + d * d) *
      ((2 * g + kR / 2) ^ 2 + d * d) *
      (4 * kR * (4 * g + kR) * (g * g + 1) * g * g) =
      Fc * ((g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d)) := by
    calc
      _ = (g * g + 1 / 4) * kR * (4 * g + kR) / 4 * 16 *
          ((kR / 2) ^ 2 + d * d) * ((2 * g + kR / 2) ^ 2 + d * d) *
          (g * g + 1) * g * g := by ring
      _ = (g * g + 1 / 4) * kR * (4 * g + kR) / 4 *
          (4 * ((kR / 2) ^ 2 + d * d)) * (4 * ((2 * g + kR / 2) ^ 2 + d * d)) *
          (g * g + 1) * g * g := by ring
      _ = (g * g + 1 / 4) * kR * (4 * g + kR) / 4 *
          (kR * kR + 4 * d * d) * ((4 * g + kR) ^ 2 + 4 * d * d) *
          (g * g + 1) * g * g := by
        rw [hb1, hb2]
      _ = (g * g + 1 / 4) * kR * (4 * g + kR) / 4 *
          ((g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d)) := by
        rw [show (4 * g + kR) ^ 2 = M from hM_def.symm]
        ring
      _ = Fc * ((g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d)) := by
        have hFcinv : Fc = (g * g + 1 / 4) * kR * (4 * g + kR) / 4 := hFc_def
        rw [show Fc * ((g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d)) =
            (g * g + 1 / 4) * kR * (4 * g + kR) / 4 *
              ((g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d)) from by
          rw [hFcinv]]
  have hb3 : (kR / 2) * (2 * g + kR / 2) = (kR * (4 * g + kR)) / 4 := by ring
  have hR : (g * g + 1 / 4) * (kR * kR + 1) * ((4 * g + kR) ^ 2 + 1) *
      ((kR / 2) * (2 * g + kR / 2) * (g * g + (1 / 2 + d) ^ 2) *
        (g * g + (1 / 2 - d) ^ 2)) =
      Fc * ((kR * kR + 1) * (M + 1) *
          (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2)) := by
    calc
      _ = (g * g + 1 / 4) * (kR * kR + 1) * (M + 1) *
          ((kR / 2) * (2 * g + kR / 2)) *
          (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2) := by
        rw [show (4 * g + kR) ^ 2 + 1 = M + 1 from by
          rw [hM_def]]
        ring
      _ = (g * g + 1 / 4) * (kR * kR + 1) * (M + 1) *
          ((kR * (4 * g + kR)) / 4) *
          (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2) := by
        rw [hb3]
      _ = Fc * ((kR * kR + 1) * (M + 1) *
          (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2)) := by
        rw [hFc_def]
        ring
  have hX : (g * g + 1 / 4) * ((kR / 2) ^ 2 + d * d) *
      ((2 * g + kR / 2) ^ 2 + d * d) *
      (4 * kR * (4 * g + kR) * (g * g + 1) * g * g) ≤
      (g * g + 1 / 4) * (kR * kR + 1) * ((4 * g + kR) ^ 2 + 1) *
        ((kR / 2) * (2 * g + kR / 2) * (g * g + (1 / 2 + d) ^ 2) *
          (g * g + (1 / 2 - d) ^ 2)) := by
    rw [hL, hR]
    apply mul_le_mul_of_nonneg_left
    · have hh2 : (kR * kR + 1) * (M + 1) * HH = (kR * kR + 1) * (M + 1) *
          (g * g + (1 / 2 + d) ^ 2) * (g * g + (1 / 2 - d) ^ 2) := by
        rw [hHH_def]
        ring
      exact le_trans hcore (le_of_eq hh2)
    · exact hFcp.le
  have hden1 : 0 < (kR / 2) * (2 * g + kR / 2) * (g * g + (1 / 2 + d) ^ 2) *
      (g * g + (1 / 2 - d) ^ 2) := by
    have hg2 : 0 < g * g := mul_pos (by linarith) (by linarith)
    have h13 : 0 < (kR / 2) * (2 * g + kR / 2) := by
      refine mul_pos (by linarith [hkR]) (by linarith)
    have h14 : 0 < (kR / 2) * (2 * g + kR / 2) * (g * g + (1 / 2 + d) ^ 2) :=
      mul_pos h13 (by
        have hT : 0 ≤ (1 / 2 + d) * (1 / 2 + d) := mul_self_nonneg (1 / 2 + d)
        linarith [hg2, hT])
    exact mul_pos h14 (by
      have hT : 0 ≤ (1 / 2 - d) * (1 / 2 - d) := mul_self_nonneg (1 / 2 - d)
      linarith [hg2, hT])
  have hden2 : 0 < 4 * kR * (4 * g + kR) * (g * g + 1) * g * g := by
    have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
    have hg2p : 0 < g * g := mul_pos h0g h0g
    have h41 : 0 < 4 * kR := mul_pos (by norm_num) (lt_of_lt_of_le (by norm_num) hkR)
    have hkknn : 0 ≤ kR := le_trans (by norm_num) hkR
    have h4gk : 0 < 4 * g + kR := by
      have hs : 4 * g + 0 ≤ 4 * g + kR := add_le_add_right hkknn (4 * g)
      have hl : 4 * g ≤ 4 * g + kR := by simpa [add_zero] using hs
      have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
      exact lt_of_lt_of_le h4gp hl
    have h21 : 0 < 4 * kR * (4 * g + kR) := mul_pos h41 h4gk
    have hg1p : 0 < g * g + 1 := by
      have hl : g * g ≤ g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        simpa [add_zero] using hs
      exact lt_of_lt_of_le hg2p hl
    have h1 : 0 < 4 * kR * (4 * g + kR) * (g * g + 1) := mul_pos h21 hg1p
    have h1g : 0 < 4 * kR * (4 * g + kR) * (g * g + 1) * g := mul_pos h1 h0g
    exact mul_pos h1g h0g
  rw [corner_eq g kR (by linarith) (by linarith [hkR])]
  exact div_le_div_of_mul
    (a := (g * g + 1 / 4) * ((kR / 2) ^ 2 + d * d) *
        ((2 * g + kR / 2) ^ 2 + d * d))
    (b := (g * g + 1 / 4) * (kR * kR + 1) * ((4 * g + kR) ^ 2 + 1))
    (c := (kR / 2) * (2 * g + kR / 2) * (g * g + (1 / 2 + d) ^ 2) *
        (g * g + (1 / 2 - d) ^ 2))
    (d := 4 * kR * (4 * g + kR) * (g * g + 1) * g * g)
    hden1 hden2 hX

theorem s3a_kmon (g : ℝ) (hg : 15 ≤ g) (k : ℕ) (hk : 1 ≤ k) (hkL : k < 12) :
    Rcorner g (k : ℝ) ≤ Rcorner g ((k + 1) : ℝ) := by
  interval_cases k
  · -- k = 1:  Rcorner g 1 <= Rcorner g 2
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 5 * ((4 * g + 2) ^ 2 + 1) * (4 * g + 1) - 2 * ((4 * g + 1) ^ 2 + 1) * 2 * (4 * g + 2) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 5 * ((4 * g + 2) ^ 2 + 1) * (4 * g + 1) - 2 * ((4 * g + 1) ^ 2 + 1) * 2 * (4 * g + 2) = (249669 : ℝ) + (47604 : ℝ) * ((g - 15)) ^ 1 + (3024 : ℝ) * ((g - 15)) ^ 2 + (64 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (5 * ((4 * g + 2) ^ 2 + 1) * (4 * g + 1) - 2 * ((4 * g + 1) ^ 2 + 1) * 2 * (4 * g + 2)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (4 * (4 * g + 1) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 2 * ((4 * g + 1) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (5 * ((4 * g + 2) ^ 2 + 1) * (4 * g + 1) - 2 * ((4 * g + 1) ^ 2 + 1) * 2 * (4 * g + 2)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (4 * (4 * g + 1) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 2 * ((4 * g + 1) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 2 * ((4 * g + 1) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (4 * (4 * g + 1) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 4 * (4 * g + 1) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 4 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (1 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 1 := by
        have hs : 4 * g + 0 ≤ 4 * g + 1 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 1 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 4 * (4 * g + 1) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 4 * (4 * g + 1) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 4 * (4 * g + 1) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 8 * (4 * g + 2) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 8 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (2 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 2 := by
        have hs : 4 * g + 0 ≤ 4 * g + 2 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 2 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 8 * (4 * g + 2) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 8 * (4 * g + 2) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 8 * (4 * g + 2) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 2 * ((4 * g + 1) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1))
      (c := 4 * (4 * g + 1) * (g * g + 1) * g * g)
      (d := 8 * (4 * g + 2) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 2:  Rcorner g 2 <= Rcorner g 3
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 10 * ((4 * g + 3) ^ 2 + 1) * 2 * (4 * g + 2) - 5 * ((4 * g + 2) ^ 2 + 1) * 3 * (4 * g + 3) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 10 * ((4 * g + 3) ^ 2 + 1) * 2 * (4 * g + 2) - 5 * ((4 * g + 2) ^ 2 + 1) * 3 * (4 * g + 3) = (1289275 : ℝ) + (243140 : ℝ) * ((g - 15)) ^ 1 + (15280 : ℝ) * ((g - 15)) ^ 2 + (320 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (10 * ((4 * g + 3) ^ 2 + 1) * 2 * (4 * g + 2) - 5 * ((4 * g + 2) ^ 2 + 1) * 3 * (4 * g + 3)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (10 * ((4 * g + 3) ^ 2 + 1) * 2 * (4 * g + 2) - 5 * ((4 * g + 2) ^ 2 + 1) * 3 * (4 * g + 3)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (8 * (4 * g + 2) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 8 * (4 * g + 2) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 8 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (2 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 2 := by
        have hs : 4 * g + 0 ≤ 4 * g + 2 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 2 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 8 * (4 * g + 2) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 8 * (4 * g + 2) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 8 * (4 * g + 2) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 12 * (4 * g + 3) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 12 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (3 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 3 := by
        have hs : 4 * g + 0 ≤ 4 * g + 3 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 3 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 12 * (4 * g + 3) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 12 * (4 * g + 3) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 12 * (4 * g + 3) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 5 * ((4 * g + 2) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1))
      (c := 8 * (4 * g + 2) * (g * g + 1) * g * g)
      (d := 12 * (4 * g + 3) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 3:  Rcorner g 3 <= Rcorner g 4
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 17 * ((4 * g + 4) ^ 2 + 1) * 3 * (4 * g + 3) - 10 * ((4 * g + 3) ^ 2 + 1) * 4 * (4 * g + 4) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 17 * ((4 * g + 4) ^ 2 + 1) * 3 * (4 * g + 3) - 10 * ((4 * g + 3) ^ 2 + 1) * 4 * (4 * g + 4) = (3000461 : ℝ) + (555404 : ℝ) * ((g - 15)) ^ 1 + (34256 : ℝ) * ((g - 15)) ^ 2 + (704 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (17 * ((4 * g + 4) ^ 2 + 1) * 3 * (4 * g + 3) - 10 * ((4 * g + 3) ^ 2 + 1) * 4 * (4 * g + 4)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (17 * ((4 * g + 4) ^ 2 + 1) * 3 * (4 * g + 3) - 10 * ((4 * g + 3) ^ 2 + 1) * 4 * (4 * g + 4)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (12 * (4 * g + 3) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 12 * (4 * g + 3) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 12 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (3 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 3 := by
        have hs : 4 * g + 0 ≤ 4 * g + 3 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 3 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 12 * (4 * g + 3) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 12 * (4 * g + 3) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 12 * (4 * g + 3) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 16 * (4 * g + 4) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 16 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (4 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 4 := by
        have hs : 4 * g + 0 ≤ 4 * g + 4 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 4 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 16 * (4 * g + 4) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 16 * (4 * g + 4) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 16 * (4 * g + 4) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 10 * ((4 * g + 3) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1))
      (c := 12 * (4 * g + 3) * (g * g + 1) * g * g)
      (d := 16 * (4 * g + 4) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 4:  Rcorner g 4 <= Rcorner g 5
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 26 * ((4 * g + 5) ^ 2 + 1) * 4 * (4 * g + 4) - 17 * ((4 * g + 4) ^ 2 + 1) * 5 * (4 * g + 5) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 26 * ((4 * g + 5) ^ 2 + 1) * 4 * (4 * g + 4) - 17 * ((4 * g + 4) ^ 2 + 1) * 5 * (4 * g + 5) = (5492331 : ℝ) + (997356 : ℝ) * ((g - 15)) ^ 1 + (60336 : ℝ) * ((g - 15)) ^ 2 + (1216 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (26 * ((4 * g + 5) ^ 2 + 1) * 4 * (4 * g + 4) - 17 * ((4 * g + 4) ^ 2 + 1) * 5 * (4 * g + 5)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (26 * ((4 * g + 5) ^ 2 + 1) * 4 * (4 * g + 4) - 17 * ((4 * g + 4) ^ 2 + 1) * 5 * (4 * g + 5)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (16 * (4 * g + 4) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 16 * (4 * g + 4) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 16 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (4 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 4 := by
        have hs : 4 * g + 0 ≤ 4 * g + 4 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 4 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 16 * (4 * g + 4) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 16 * (4 * g + 4) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 16 * (4 * g + 4) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 20 * (4 * g + 5) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 20 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (5 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 5 := by
        have hs : 4 * g + 0 ≤ 4 * g + 5 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 5 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 20 * (4 * g + 5) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 20 * (4 * g + 5) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 20 * (4 * g + 5) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 17 * ((4 * g + 4) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1))
      (c := 16 * (4 * g + 4) * (g * g + 1) * g * g)
      (d := 20 * (4 * g + 5) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 5:  Rcorner g 5 <= Rcorner g 6
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 37 * ((4 * g + 6) ^ 2 + 1) * 5 * (4 * g + 5) - 26 * ((4 * g + 5) ^ 2 + 1) * 6 * (4 * g + 6) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 37 * ((4 * g + 6) ^ 2 + 1) * 5 * (4 * g + 5) - 26 * ((4 * g + 5) ^ 2 + 1) * 6 * (4 * g + 6) = (8882029 : ℝ) + (1582436 : ℝ) * ((g - 15)) ^ 1 + (93904 : ℝ) * ((g - 15)) ^ 2 + (1856 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (37 * ((4 * g + 6) ^ 2 + 1) * 5 * (4 * g + 5) - 26 * ((4 * g + 5) ^ 2 + 1) * 6 * (4 * g + 6)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (37 * ((4 * g + 6) ^ 2 + 1) * 5 * (4 * g + 5) - 26 * ((4 * g + 5) ^ 2 + 1) * 6 * (4 * g + 6)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (20 * (4 * g + 5) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 20 * (4 * g + 5) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 20 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (5 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 5 := by
        have hs : 4 * g + 0 ≤ 4 * g + 5 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 5 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 20 * (4 * g + 5) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 20 * (4 * g + 5) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 20 * (4 * g + 5) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 24 * (4 * g + 6) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 24 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (6 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 6 := by
        have hs : 4 * g + 0 ≤ 4 * g + 6 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 6 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 24 * (4 * g + 6) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 24 * (4 * g + 6) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 24 * (4 * g + 6) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 26 * ((4 * g + 5) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1))
      (c := 20 * (4 * g + 5) * (g * g + 1) * g * g)
      (d := 24 * (4 * g + 6) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 6:  Rcorner g 6 <= Rcorner g 7
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 50 * ((4 * g + 7) ^ 2 + 1) * 6 * (4 * g + 6) - 37 * ((4 * g + 6) ^ 2 + 1) * 7 * (4 * g + 7) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 50 * ((4 * g + 7) ^ 2 + 1) * 6 * (4 * g + 6) - 37 * ((4 * g + 6) ^ 2 + 1) * 7 * (4 * g + 7) = (13294979 : ℝ) + (2324564 : ℝ) * ((g - 15)) ^ 1 + (135344 : ℝ) * ((g - 15)) ^ 2 + (2624 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (50 * ((4 * g + 7) ^ 2 + 1) * 6 * (4 * g + 6) - 37 * ((4 * g + 6) ^ 2 + 1) * 7 * (4 * g + 7)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (50 * ((4 * g + 7) ^ 2 + 1) * 6 * (4 * g + 6) - 37 * ((4 * g + 6) ^ 2 + 1) * 7 * (4 * g + 7)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (24 * (4 * g + 6) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 24 * (4 * g + 6) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 24 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (6 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 6 := by
        have hs : 4 * g + 0 ≤ 4 * g + 6 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 6 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 24 * (4 * g + 6) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 24 * (4 * g + 6) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 24 * (4 * g + 6) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 28 * (4 * g + 7) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 28 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (7 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 7 := by
        have hs : 4 * g + 0 ≤ 4 * g + 7 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 7 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 28 * (4 * g + 7) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 28 * (4 * g + 7) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 28 * (4 * g + 7) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 37 * ((4 * g + 6) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1))
      (c := 24 * (4 * g + 6) * (g * g + 1) * g * g)
      (d := 28 * (4 * g + 7) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 7:  Rcorner g 7 <= Rcorner g 8
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 65 * ((4 * g + 8) ^ 2 + 1) * 7 * (4 * g + 7) - 50 * ((4 * g + 7) ^ 2 + 1) * 8 * (4 * g + 8) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 65 * ((4 * g + 8) ^ 2 + 1) * 7 * (4 * g + 7) - 50 * ((4 * g + 7) ^ 2 + 1) * 8 * (4 * g + 8) = (18865125 : ℝ) + (3238140 : ℝ) * ((g - 15)) ^ 1 + (185040 : ℝ) * ((g - 15)) ^ 2 + (3520 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (65 * ((4 * g + 8) ^ 2 + 1) * 7 * (4 * g + 7) - 50 * ((4 * g + 7) ^ 2 + 1) * 8 * (4 * g + 8)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (65 * ((4 * g + 8) ^ 2 + 1) * 7 * (4 * g + 7) - 50 * ((4 * g + 7) ^ 2 + 1) * 8 * (4 * g + 8)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (28 * (4 * g + 7) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 28 * (4 * g + 7) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 28 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (7 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 7 := by
        have hs : 4 * g + 0 ≤ 4 * g + 7 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 7 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 28 * (4 * g + 7) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 28 * (4 * g + 7) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 28 * (4 * g + 7) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 32 * (4 * g + 8) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 32 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (8 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 8 := by
        have hs : 4 * g + 0 ≤ 4 * g + 8 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 8 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 32 * (4 * g + 8) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 32 * (4 * g + 8) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 32 * (4 * g + 8) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 50 * ((4 * g + 7) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1))
      (c := 28 * (4 * g + 7) * (g * g + 1) * g * g)
      (d := 32 * (4 * g + 8) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 8:  Rcorner g 8 <= Rcorner g 9
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 82 * ((4 * g + 9) ^ 2 + 1) * 8 * (4 * g + 8) - 65 * ((4 * g + 8) ^ 2 + 1) * 9 * (4 * g + 9) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 82 * ((4 * g + 9) ^ 2 + 1) * 8 * (4 * g + 8) - 65 * ((4 * g + 8) ^ 2 + 1) * 9 * (4 * g + 9) = (25735171 : ℝ) + (4338044 : ℝ) * ((g - 15)) ^ 1 + (243376 : ℝ) * ((g - 15)) ^ 2 + (4544 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (82 * ((4 * g + 9) ^ 2 + 1) * 8 * (4 * g + 8) - 65 * ((4 * g + 8) ^ 2 + 1) * 9 * (4 * g + 9)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (82 * ((4 * g + 9) ^ 2 + 1) * 8 * (4 * g + 8) - 65 * ((4 * g + 8) ^ 2 + 1) * 9 * (4 * g + 9)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (32 * (4 * g + 8) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 32 * (4 * g + 8) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 32 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (8 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 8 := by
        have hs : 4 * g + 0 ≤ 4 * g + 8 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 8 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 32 * (4 * g + 8) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 32 * (4 * g + 8) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 32 * (4 * g + 8) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 36 * (4 * g + 9) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 36 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (9 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 9 := by
        have hs : 4 * g + 0 ≤ 4 * g + 9 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 9 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 36 * (4 * g + 9) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 36 * (4 * g + 9) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 36 * (4 * g + 9) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 65 * ((4 * g + 8) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1))
      (c := 32 * (4 * g + 8) * (g * g + 1) * g * g)
      (d := 36 * (4 * g + 9) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 9:  Rcorner g 9 <= Rcorner g 10
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 101 * ((4 * g + 10) ^ 2 + 1) * 9 * (4 * g + 9) - 82 * ((4 * g + 9) ^ 2 + 1) * 10 * (4 * g + 10) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 101 * ((4 * g + 10) ^ 2 + 1) * 9 * (4 * g + 9) - 82 * ((4 * g + 9) ^ 2 + 1) * 10 * (4 * g + 10) = (34056821 : ℝ) + (5639636 : ℝ) * ((g - 15)) ^ 1 + (310736 : ℝ) * ((g - 15)) ^ 2 + (5696 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (101 * ((4 * g + 10) ^ 2 + 1) * 9 * (4 * g + 9) - 82 * ((4 * g + 9) ^ 2 + 1) * 10 * (4 * g + 10)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (101 * ((4 * g + 10) ^ 2 + 1) * 9 * (4 * g + 9) - 82 * ((4 * g + 9) ^ 2 + 1) * 10 * (4 * g + 10)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (36 * (4 * g + 9) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 36 * (4 * g + 9) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 36 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (9 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 9 := by
        have hs : 4 * g + 0 ≤ 4 * g + 9 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 9 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 36 * (4 * g + 9) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 36 * (4 * g + 9) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 36 * (4 * g + 9) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 40 * (4 * g + 10) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 40 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (10 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 10 := by
        have hs : 4 * g + 0 ≤ 4 * g + 10 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 10 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 40 * (4 * g + 10) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 40 * (4 * g + 10) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 40 * (4 * g + 10) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 82 * ((4 * g + 9) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1))
      (c := 36 * (4 * g + 9) * (g * g + 1) * g * g)
      (d := 40 * (4 * g + 10) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 10:  Rcorner g 10 <= Rcorner g 11
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 122 * ((4 * g + 11) ^ 2 + 1) * 10 * (4 * g + 10) - 101 * ((4 * g + 10) ^ 2 + 1) * 11 * (4 * g + 11) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 122 * ((4 * g + 11) ^ 2 + 1) * 10 * (4 * g + 10) - 101 * ((4 * g + 10) ^ 2 + 1) * 11 * (4 * g + 11) = (43991019 : ℝ) + (7158756 : ℝ) * ((g - 15)) ^ 1 + (387504 : ℝ) * ((g - 15)) ^ 2 + (6976 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (122 * ((4 * g + 11) ^ 2 + 1) * 10 * (4 * g + 10) - 101 * ((4 * g + 10) ^ 2 + 1) * 11 * (4 * g + 11)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (122 * ((4 * g + 11) ^ 2 + 1) * 10 * (4 * g + 10) - 101 * ((4 * g + 10) ^ 2 + 1) * 11 * (4 * g + 11)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (40 * (4 * g + 10) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 40 * (4 * g + 10) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 40 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (10 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 10 := by
        have hs : 4 * g + 0 ≤ 4 * g + 10 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 10 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 40 * (4 * g + 10) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 40 * (4 * g + 10) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 40 * (4 * g + 10) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 44 * (4 * g + 11) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 44 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (11 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 11 := by
        have hs : 4 * g + 0 ≤ 4 * g + 11 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 11 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 44 * (4 * g + 11) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 44 * (4 * g + 11) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 44 * (4 * g + 11) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 101 * ((4 * g + 10) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1))
      (c := 40 * (4 * g + 10) * (g * g + 1) * g * g)
      (d := 44 * (4 * g + 11) * (g * g + 1) * g * g)
      hden1 hden2 hle
  · -- k = 11:  Rcorner g 11 <= Rcorner g 12
    dsimp only [Rcorner]
    norm_num
    have hP0 : 0 ≤ 145 * ((4 * g + 12) ^ 2 + 1) * 11 * (4 * g + 11) - 122 * ((4 * g + 11) ^ 2 + 1) * 12 * (4 * g + 12) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : 145 * ((4 * g + 12) ^ 2 + 1) * 11 * (4 * g + 11) - 122 * ((4 * g + 11) ^ 2 + 1) * 12 * (4 * g + 12) = (55708189 : ℝ) + (8911724 : ℝ) * ((g - 15)) ^ 1 + (474064 : ℝ) * ((g - 15)) ^ 2 + (8384 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hg2p : 0 < g * g := mul_pos h0g h0g
      have hg2pp : 0 < g * g + 1 / 4 := by
        have hs : g * g + 0 ≤ g * g + 1 / 4 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 / 4 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have hg1p : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le hg2p hl
      have h1 : 0 < 4 * (g * g + 1 / 4) := mul_pos (by norm_num) hg2pp
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := mul_pos h1 hg1p
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := mul_pos h2 h0g
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := mul_pos h2g h0g
      exact h3.le
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (145 * ((4 * g + 12) ^ 2 + 1) * 11 * (4 * g + 11) - 122 * ((4 * g + 11) ^ 2 + 1) * 12 * (4 * g + 12)) :=
      mul_nonneg hS hP0
    have hsub : ((g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (48 * (4 * g + 12) * (g * g + 1) * g * g) = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (145 * ((4 * g + 12) ^ 2 + 1) * 11 * (4 * g + 11) - 122 * ((4 * g + 11) ^ 2 + 1) * 12 * (4 * g + 12)) := by
      ring
    have hpos : 0 ≤ ((g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) - ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (48 * (4 * g + 12) * (g * g + 1) * g * g) := by
      rw [hsub]
      exact hprod
    have hle : ((g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1)) * (48 * (4 * g + 12) * (g * g + 1) * g * g) ≤ ((g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1)) * (44 * (4 * g + 11) * (g * g + 1) * g * g) := le_of_sub_nonneg hpos
    have hden1 : 0 < 44 * (4 * g + 11) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 44 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (11 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 11 := by
        have hs : 4 * g + 0 ≤ 4 * g + 11 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 11 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 44 * (4 * g + 11) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 44 * (4 * g + 11) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 44 * (4 * g + 11) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    have hden2 : 0 < 48 * (4 * g + 12) * (g * g + 1) * g * g := by
      have h1 : (0 : ℝ) < 48 := by norm_num
      have h0g : 0 < g := lt_of_lt_of_le (by norm_num) hg
      have hk0 : 0 ≤ (12 : ℝ) := by norm_num
      have h4gk : 0 < 4 * g + 12 := by
        have hs : 4 * g + 0 ≤ 4 * g + 12 := add_le_add_right hk0 (4 * g)
        have hl : 4 * g ≤ 4 * g + 12 := by simpa [add_zero] using hs
        have h4gp : 0 < 4 * g := mul_pos (by norm_num) h0g
        exact lt_of_lt_of_le h4gp hl
      have h11 : 0 < 48 * (4 * g + 12) := mul_pos h1 h4gk
      have hg1p2 : 0 < g * g + 1 := by
        have hs : g * g + 0 ≤ g * g + 1 := add_le_add_right (by norm_num) (g * g)
        have hl : g * g ≤ g * g + 1 := by simpa [add_zero] using hs
        exact lt_of_lt_of_le (mul_pos h0g h0g) hl
      have h12 : 0 < 48 * (4 * g + 12) * (g * g + 1) := mul_pos h11 hg1p2
      have h13 : 0 < 48 * (4 * g + 12) * (g * g + 1) * g := mul_pos h12 h0g
      exact mul_pos h13 h0g
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * 122 * ((4 * g + 11) ^ 2 + 1))
      (b := (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1))
      (c := 44 * (4 * g + 11) * (g * g + 1) * g * g)
      (d := 48 * (4 * g + 12) * (g * g + 1) * g * g)
      hden1 hden2 hle

theorem s3a_lt1 (g : ℝ) (hg : 15 ≤ g) : Rcorner g 12 < 1 := by
  dsimp [Rcorner]
  norm_num
  set Df := 48 * (4 * g + 12) * (g * g + 1) * g * g -
      (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) with hDf_def
  have hP : Df = (25556075 : ℝ) / 4 + 15155250 * (g - 15) +
      3486811 * (g - 15) ^ 2 + 313632 * (g - 15) ^ 3 + 12656 * (g - 15) ^ 4 +
      192 * (g - 15) ^ 5 := by
    dsimp only [Df]
    ring
  have hDpos : 0 < Df := by
    rw [hP]
    positivity
  have hden : 0 < 48 * (4 * g + 12) * (g * g + 1) * g * g := by
    have h1 : 0 < 48 * (4 * g + 12) * (g * g + 1) := by
      refine mul_pos (mul_pos (by norm_num) (by linarith))
        (by positivity)
    exact mul_pos (mul_pos h1 (by linarith)) (by linarith)
  have hNpos : 0 < (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) := by
    positivity
  have hdiv : 0 < (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) /
      (48 * (4 * g + 12) * (g * g + 1) * g * g) :=
    div_pos hNpos hden
  calc
    (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) /
        (48 * (4 * g + 12) * (g * g + 1) * g * g) =
      1 - (48 * (4 * g + 12) * (g * g + 1) * g * g -
          (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1)) /
        (48 * (4 * g + 12) * (g * g + 1) * g * g) := by
      field_simp [hden.ne']
      ring
    _ < 1 := by
      have hdv : 0 < (48 * (4 * g + 12) * (g * g + 1) * g * g -
          (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1)) /
          (48 * (4 * g + 12) * (g * g + 1) * g * g) :=
        div_pos hDpos hden
      exact sub_lt_self (1 : ℝ) hdv
theorem s3a_bound13 (g : ℝ) (hg : 40 ≤ g) : Rcorner g 12 ≤ 13 / g := by
  dsimp [Rcorner]
  norm_num
  have hnum : 0 ≤ 704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 + 16032 * g -
      21025 := by
    have hrew : 704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 + 16032 * g -
        21025 =
        (33970655 : ℝ) + 50630752 * (g - 40) + 3594604 * (g - 40) ^ 2 +
          86912 * (g - 40) ^ 3 + 704 * (g - 40) ^ 4 := by
      ring
    rw [hrew]
    positivity
  have hcross : (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) * g ≤
      13 * (48 * (4 * g + 12) * (g * g + 1) * g * g) := by
    have hdiff : 13 * (48 * (4 * g + 12) * (g * g + 1) * g * g) -
        (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) * g =
        (g * (704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 + 16032 * g -
          21025)) / 4 := by
      ring
    have hsub : 0 ≤ 13 * (48 * (4 * g + 12) * (g * g + 1) * g * g) -
        (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) * g := by
      rw [hdiff]
      have hgn : 0 ≤ g * (704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 +
          16032 * g - 21025) :=
        mul_nonneg (by linarith) hnum
      rw [show (g * (704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 +
            16032 * g - 21025)) / 4 =
          (g * (704 * g ^ 4 - 25728 * g ^ 3 - 76436 * g ^ 2 + 16032 * g -
            21025)) * (1 / 4) from by ring]
      exact mul_nonneg hgn (by norm_num)
    linarith [hsub]
  have hden1 : 0 < 48 * (4 * g + 12) * (g * g + 1) * g * g := by
    have h1 : 0 < 48 * (4 * g + 12) * (g * g + 1) := by
      refine mul_pos (mul_pos (by norm_num) (by linarith))
        (by positivity)
    exact mul_pos (mul_pos h1 (by linarith)) (by linarith)
  exact div_le_div_of_mul
    (a := (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1))
    (b := 13)
    (c := 48 * (4 * g + 12) * (g * g + 1) * g * g)
    (d := g)
    hden1 (by linarith) hcross

/-- (dev)  the composed algebraic-detector statement:  on the quantized
straddle grid (1 <= k <= 12, 0 <= d <= 1/2),  the worst-case algebraic
core at g >= 40 is bounded by  13 / g  (d-corner + k-chain + decay),
and the exact crossing sits at g0 = 15 (s3a_crossing14/15). -/
theorem s3a_dev (g : ℝ) (hg40 : 40 ≤ g) (k : ℕ) (hk1 : 1 ≤ k) (hkL : k ≤ 12)
    (d : ℝ) (hd0 : 0 ≤ d) (hdL : d ≤ 1 / 2) :
    Ralg g (k : ℝ) d ≤ 13 / g := by
  have h1 : Ralg g (k : ℝ) d ≤ Ralg g (k : ℝ) (1 / 2) :=
    s3a_dcorner g (by linarith) k hk1 hkL d hd0 hdL
  have h2 : Ralg g (k : ℝ) (1 / 2) = Rcorner g (k : ℝ) := by
    have hkc : (1 : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk1
    have hkn : 0 ≤ (k : ℝ) := le_trans (by norm_num : (0 : ℝ) ≤ 1) hkc
    exact corner_eq g (k : ℝ) (by linarith [hkc]) (by linarith [hkn, hg40])
  have h3 : Rcorner g (k : ℝ) ≤ Rcorner g 12 := by
    interval_cases k
    · -- k = 1
      norm_num
      have h1 : Rcorner g (1 : ℝ) ≤ Rcorner g (2 : ℝ) := by
        simpa [show (↑1 : ℝ) = (1 : ℝ) from by norm_num,
               show (↑1 : ℝ) + 1 = (2 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 1 (by norm_num) (by norm_num)
      have h2 : Rcorner g (2 : ℝ) ≤ Rcorner g (3 : ℝ) := by
        simpa [show (↑2 : ℝ) = (2 : ℝ) from by norm_num,
               show (↑2 : ℝ) + 1 = (3 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 2 (by norm_num) (by norm_num)
      have h3 : Rcorner g (3 : ℝ) ≤ Rcorner g (4 : ℝ) := by
        simpa [show (↑3 : ℝ) = (3 : ℝ) from by norm_num,
               show (↑3 : ℝ) + 1 = (4 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 3 (by norm_num) (by norm_num)
      have h4 : Rcorner g (4 : ℝ) ≤ Rcorner g (5 : ℝ) := by
        simpa [show (↑4 : ℝ) = (4 : ℝ) from by norm_num,
               show (↑4 : ℝ) + 1 = (5 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 4 (by norm_num) (by norm_num)
      have h5 : Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) := by
        simpa [show (↑5 : ℝ) = (5 : ℝ) from by norm_num,
               show (↑5 : ℝ) + 1 = (6 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 5 (by norm_num) (by norm_num)
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact ((((((((((h1.trans h2).trans h3).trans h4).trans h5).trans h6).trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 2
      norm_num
      have h2 : Rcorner g (2 : ℝ) ≤ Rcorner g (3 : ℝ) := by
        simpa [show (↑2 : ℝ) = (2 : ℝ) from by norm_num,
               show (↑2 : ℝ) + 1 = (3 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 2 (by norm_num) (by norm_num)
      have h3 : Rcorner g (3 : ℝ) ≤ Rcorner g (4 : ℝ) := by
        simpa [show (↑3 : ℝ) = (3 : ℝ) from by norm_num,
               show (↑3 : ℝ) + 1 = (4 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 3 (by norm_num) (by norm_num)
      have h4 : Rcorner g (4 : ℝ) ≤ Rcorner g (5 : ℝ) := by
        simpa [show (↑4 : ℝ) = (4 : ℝ) from by norm_num,
               show (↑4 : ℝ) + 1 = (5 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 4 (by norm_num) (by norm_num)
      have h5 : Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) := by
        simpa [show (↑5 : ℝ) = (5 : ℝ) from by norm_num,
               show (↑5 : ℝ) + 1 = (6 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 5 (by norm_num) (by norm_num)
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact (((((((((h2.trans h3).trans h4).trans h5).trans h6).trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 3
      norm_num
      have h3 : Rcorner g (3 : ℝ) ≤ Rcorner g (4 : ℝ) := by
        simpa [show (↑3 : ℝ) = (3 : ℝ) from by norm_num,
               show (↑3 : ℝ) + 1 = (4 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 3 (by norm_num) (by norm_num)
      have h4 : Rcorner g (4 : ℝ) ≤ Rcorner g (5 : ℝ) := by
        simpa [show (↑4 : ℝ) = (4 : ℝ) from by norm_num,
               show (↑4 : ℝ) + 1 = (5 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 4 (by norm_num) (by norm_num)
      have h5 : Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) := by
        simpa [show (↑5 : ℝ) = (5 : ℝ) from by norm_num,
               show (↑5 : ℝ) + 1 = (6 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 5 (by norm_num) (by norm_num)
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact ((((((((h3.trans h4).trans h5).trans h6).trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 4
      norm_num
      have h4 : Rcorner g (4 : ℝ) ≤ Rcorner g (5 : ℝ) := by
        simpa [show (↑4 : ℝ) = (4 : ℝ) from by norm_num,
               show (↑4 : ℝ) + 1 = (5 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 4 (by norm_num) (by norm_num)
      have h5 : Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) := by
        simpa [show (↑5 : ℝ) = (5 : ℝ) from by norm_num,
               show (↑5 : ℝ) + 1 = (6 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 5 (by norm_num) (by norm_num)
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact (((((((h4.trans h5).trans h6).trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 5
      norm_num
      have h5 : Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) := by
        simpa [show (↑5 : ℝ) = (5 : ℝ) from by norm_num,
               show (↑5 : ℝ) + 1 = (6 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 5 (by norm_num) (by norm_num)
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact ((((((h5.trans h6).trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 6
      norm_num
      have h6 : Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) := by
        simpa [show (↑6 : ℝ) = (6 : ℝ) from by norm_num,
               show (↑6 : ℝ) + 1 = (7 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 6 (by norm_num) (by norm_num)
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact (((((h6.trans h7).trans h8).trans h9).trans h10).trans h11)
    · -- k = 7
      norm_num
      have h7 : Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) := by
        simpa [show (↑7 : ℝ) = (7 : ℝ) from by norm_num,
               show (↑7 : ℝ) + 1 = (8 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 7 (by norm_num) (by norm_num)
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact ((((h7.trans h8).trans h9).trans h10).trans h11)
    · -- k = 8
      norm_num
      have h8 : Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) := by
        simpa [show (↑8 : ℝ) = (8 : ℝ) from by norm_num,
               show (↑8 : ℝ) + 1 = (9 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 8 (by norm_num) (by norm_num)
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact (((h8.trans h9).trans h10).trans h11)
    · -- k = 9
      norm_num
      have h9 : Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) := by
        simpa [show (↑9 : ℝ) = (9 : ℝ) from by norm_num,
               show (↑9 : ℝ) + 1 = (10 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 9 (by norm_num) (by norm_num)
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact ((h9.trans h10).trans h11)
    · -- k = 10
      norm_num
      have h10 : Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) := by
        simpa [show (↑10 : ℝ) = (10 : ℝ) from by norm_num,
               show (↑10 : ℝ) + 1 = (11 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 10 (by norm_num) (by norm_num)
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact (h10.trans h11)
    · -- k = 11
      norm_num
      have h11 : Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) := by
        simpa [show (↑11 : ℝ) = (11 : ℝ) from by norm_num,
               show (↑11 : ℝ) + 1 = (12 : ℝ) from by norm_num] using
          s3a_kmon g (le_trans (by norm_num : (15 : ℝ) ≤ 40) hg40) 11 (by norm_num) (by norm_num)
      exact h11
    · -- k = 12
      norm_num
  calc
    Ralg g (k : ℝ) d ≤ Ralg g (k : ℝ) (1 / 2) := h1
    _ = Rcorner g (k : ℝ) := h2
    _ ≤ Rcorner g 12 := h3
    _ ≤ 13 / g := s3a_bound13 g hg40

end S3a
