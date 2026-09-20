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
    have h12 : (144 : ℝ) = 12 * 12 := by norm_num
    rw [h12]
    simpa [mul_comm] using mul_le_mul_of_nonneg_right hkl (by norm_num)
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
    have h12 : (144 : ℝ) = 12 * 12 := by norm_num
    rw [h12]
    simpa [mul_comm] using mul_le_mul_of_nonneg_right hkl (by norm_num)
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
    have hstep : 145 * (M + 1) = 145 * ((4 * g + kR) ^ 2 + 1) := by
      dsimp only [M]
    rw [hstep]
    have h4gk : 4 * g + kR ≤ 4 * g + 12 := by linarith [hkl]
    have h4g12 : 0 ≤ 4 * g + 12 := by linarith
    have h4gk0 : 0 ≤ 4 * g + kR := by linarith
    have hsq : 145 * ((4 * g + kR) ^ 2 + 1) ≤ 145 * ((4 * g + 12) ^ 2 + 1) := by
      have hs : (4 * g + kR) ^ 2 + 1 ≤ (4 * g + 12) ^ 2 + 1 := by
        nlinarith [h4gk, h4g12, h4gk0]
      exact mul_le_mul_of_nonneg_left hs (by norm_num)
    linarith [hA145, hsq]
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
  have hD0nn : 0 ≤ D0 := by
    interval_cases k
    · -- k = 1
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (188477565 : ℝ) + (74965591 : ℝ) * (g - 15) ^ 1 + (12424053 : ℝ) * (g - 15) ^ 2 + (1098180 : ℝ) * (g - 15) ^ 3 + (54603 : ℝ) * (g - 15) ^ 4 + (1448 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 2
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (193560039 : ℝ) + (76731350 : ℝ) * (g - 15) ^ 1 + (12668671 : ℝ) * (g - 15) ^ 2 + (1115076 : ℝ) * (g - 15) ^ 3 + (55185 : ℝ) * (g - 15) ^ 4 + (1456 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 3
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (197868381 : ℝ) + (78302085 : ℝ) * (g - 15) ^ 1 + (12894909 : ℝ) * (g - 15) ^ 2 + (1131204 : ℝ) * (g - 15) ^ 3 + (55755 : ℝ) * (g - 15) ^ 4 + (1464 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 4
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (201314890 : ℝ) + (79660699 : ℝ) * (g - 15) ^ 1 + (13101655 : ℝ) * (g - 15) ^ 2 + (1146540 : ℝ) * (g - 15) ^ 3 + (56313 : ℝ) * (g - 15) ^ 4 + (1472 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 5
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (203809167 : ℝ) + (80789735 : ℝ) * (g - 15) ^ 1 + (13287789 : ℝ) * (g - 15) ^ 2 + (1161060 : ℝ) * (g - 15) ^ 3 + (56859 : ℝ) * (g - 15) ^ 4 + (1480 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 6
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (205258113 : ℝ) + (81671376 : ℝ) * (g - 15) ^ 1 + (13452175 : ℝ) * (g - 15) ^ 2 + (1174740 : ℝ) * (g - 15) ^ 3 + (57393 : ℝ) * (g - 15) ^ 4 + (1488 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 7
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (205565931 : ℝ) + (82287445 : ℝ) * (g - 15) ^ 1 + (13593669 : ℝ) * (g - 15) ^ 2 + (1187556 : ℝ) * (g - 15) ^ 3 + (57915 : ℝ) * (g - 15) ^ 4 + (1496 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 8
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (204634126 : ℝ) + (82619405 : ℝ) * (g - 15) ^ 1 + (13711111 : ℝ) * (g - 15) ^ 2 + (1199484 : ℝ) * (g - 15) ^ 3 + (58425 : ℝ) * (g - 15) ^ 4 + (1504 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 9
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (202361505 : ℝ) + (82648359 : ℝ) * (g - 15) ^ 1 + (13803333 : ℝ) * (g - 15) ^ 2 + (1210500 : ℝ) * (g - 15) ^ 3 + (58923 : ℝ) * (g - 15) ^ 4 + (1512 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 10
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (198644175 : ℝ) + (82355050 : ℝ) * (g - 15) ^ 1 + (13869151 : ℝ) * (g - 15) ^ 2 + (1220580 : ℝ) * (g - 15) ^ 3 + (59409 : ℝ) * (g - 15) ^ 4 + (1520 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 11
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (193375545 : ℝ) + (81719861 : ℝ) * (g - 15) ^ 1 + (13907373 : ℝ) * (g - 15) ^ 2 + (1229700 : ℝ) * (g - 15) ^ 3 + (59883 : ℝ) * (g - 15) ^ 4 + (1528 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    · -- k = 12
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hc : D0 = (186446326 : ℝ) + (80722815 : ℝ) * (g - 15) ^ 1 + (13916791 : ℝ) * (g - 15) ^ 2 + (1237836 : ℝ) * (g - 15) ^ 3 + (60345 : ℝ) * (g - 15) ^ 4 + (1536 : ℝ) * (g - 15) ^ 5 + (16 : ℝ) * (g - 15) ^ 6 := by
        dsimp only [D0, A, M, kR]
        ring
      rw [hc]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
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
    have h2 : 0 ≤ PP * x * (x - 1 / 4) := by
      have hrew : PP * x * (x - 1 / 4) = -PP * x * (1 / 4 - x) := by ring
      rw [hrew]
      apply mul_nonneg
      · exact neg_nonneg.mpr hPPn2
      · apply mul_nonneg
        · positivity
        · exact sub_nonneg.mpr hxL
    exact add_nonneg h1 h2
  have hHHx : (g * g * (g * g) + g * g * (1 / 2 + 2 * x) + (1 / 4 - x) ^ 2) = HH := by
    dsimp only [HH]
    have hHH : HH = g * g * (g * g) + g * g * (1 / 2 + 2 * d * d) +
        (1 / 4 - d * d) ^ 2 := by
      dsimp only [HH]
      ring
    rw [hHH, hx_def]
  have hcore : (g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d) ≤
      (kR * kR + 1) * (M + 1) * HH := by
    have hDb : D + (g * g + 1) * g * g * (kR * kR + 4 * d * d) * (M + 4 * d * d) =
        (kR * kR + 1) * (M + 1) * HH := by
      dsimp only [D]
      rw [show g * g * (g * g) + g * g * (1 / 2 + 2 * x) + (1 / 4 - x) ^ 2 = HH from
        hHHx]
      have hB : (kR * kR + 4 * d * d) * (M + 4 * d * d) =
          (kR * kR + 4 * x) * (M + 4 * x) := by
        rw [hx_def]
        ring
      rw [hB]
      ring
    rw [hDb]
    exact le_add_of_nonneg_left hDnn
  set Fc := (g * g + 1 / 4) * kR * (4 * g + kR) / 4 with hFc_def
  have hFcp : 0 < Fc := by
    dsimp only [Fc]
    have h1 : 0 < (g * g + 1 / 4) * kR * (4 * g + kR) := by
      apply mul_pos
      · positivity
      · apply mul_pos
        · linarith [hkR]
        · linarith
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
        rw [show (g * g + 1 / 4) * kR * (4 * g + kR) / 4 = Fc from hFc_def.symm]
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
    have hlg : 0 < g := by linarith
    have h41 : 0 < 4 * kR := by
      refine mul_pos (by norm_num) (by linarith [hkR])
    have h1 : 0 < 4 * kR * (4 * g + kR) * (g * g + 1) := by
      have h21 : 0 < 4 * kR * (4 * g + kR) := by
        refine mul_pos h41 _
        linarith
      refine mul_pos h21 _
      positivity
    exact mul_pos (mul_pos h1 hlg) hlg
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
    have hP0 : 0 ≤ ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (1) * (4 * g + (1)) - ((1) * (1) + 1) * ((4 * g + (1)) ^ 2 + 1) * (2) * (4 * g + (2)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (1) * (4 * g + (1)) - ((1) * (1) + 1) * ((4 * g + (1)) ^ 2 + 1) * (2) * (4 * g + (2)) = (249669 : ℝ) + (47604 : ℝ) * ((g - 15)) ^ 1 + (3024 : ℝ) * ((g - 15)) ^ 2 + (64 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (2 * 2 + 1) * ((4 * g + (2)) ^ 2 + 1) * 4 * (1) * (4 * g + (1)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (1 * 1 + 1) * ((4 * g + 1) ^ 2 + 1) * 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (1) * (4 * g + (1)) - ((1) * (1) + 1) * ((4 * g + (1)) ^ 2 + 1) * (2) * (4 * g + (2))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (1) * (4 * g + (1)) - ((1) * (1) + 1) * ((4 * g + (1)) ^ 2 + 1) * (2) * (4 * g + (2))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (1) * (4 * g + (1)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (1 * 1 + 1) * ((4 * g + 1) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (2 * 2 + 1) * ((4 * g + (2)) ^ 2 + 1))
      (c := 4 * (1) * (4 * g + (1)) * (g * g + 1) * g * g)
      (d := 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 2:  Rcorner g 2 <= Rcorner g 3
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (2) * (4 * g + (2)) - ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (3) * (4 * g + (3)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (2) * (4 * g + (2)) - ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (3) * (4 * g + (3)) = (1289275 : ℝ) + (243140 : ℝ) * ((g - 15)) ^ 1 + (15280 : ℝ) * ((g - 15)) ^ 2 + (320 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (3 * 3 + 1) * ((4 * g + (3)) ^ 2 + 1) * 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (2 * 2 + 1) * ((4 * g + 2) ^ 2 + 1) * 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (2) * (4 * g + (2)) - ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (3) * (4 * g + (3))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (2) * (4 * g + (2)) - ((2) * (2) + 1) * ((4 * g + (2)) ^ 2 + 1) * (3) * (4 * g + (3))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (2 * 2 + 1) * ((4 * g + 2) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (3 * 3 + 1) * ((4 * g + (3)) ^ 2 + 1))
      (c := 4 * (2) * (4 * g + (2)) * (g * g + 1) * g * g)
      (d := 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 3:  Rcorner g 3 <= Rcorner g 4
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (3) * (4 * g + (3)) - ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (4) * (4 * g + (4)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (3) * (4 * g + (3)) - ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (4) * (4 * g + (4)) = (3000461 : ℝ) + (555404 : ℝ) * ((g - 15)) ^ 1 + (34256 : ℝ) * ((g - 15)) ^ 2 + (704 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (4 * 4 + 1) * ((4 * g + (4)) ^ 2 + 1) * 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (3 * 3 + 1) * ((4 * g + 3) ^ 2 + 1) * 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (3) * (4 * g + (3)) - ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (4) * (4 * g + (4))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (3) * (4 * g + (3)) - ((3) * (3) + 1) * ((4 * g + (3)) ^ 2 + 1) * (4) * (4 * g + (4))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (3 * 3 + 1) * ((4 * g + 3) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (4 * 4 + 1) * ((4 * g + (4)) ^ 2 + 1))
      (c := 4 * (3) * (4 * g + (3)) * (g * g + 1) * g * g)
      (d := 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 4:  Rcorner g 4 <= Rcorner g 5
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (4) * (4 * g + (4)) - ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (5) * (4 * g + (5)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (4) * (4 * g + (4)) - ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (5) * (4 * g + (5)) = (5492331 : ℝ) + (997356 : ℝ) * ((g - 15)) ^ 1 + (60336 : ℝ) * ((g - 15)) ^ 2 + (1216 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (5 * 5 + 1) * ((4 * g + (5)) ^ 2 + 1) * 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (4 * 4 + 1) * ((4 * g + 4) ^ 2 + 1) * 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (4) * (4 * g + (4)) - ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (5) * (4 * g + (5))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (4) * (4 * g + (4)) - ((4) * (4) + 1) * ((4 * g + (4)) ^ 2 + 1) * (5) * (4 * g + (5))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (4 * 4 + 1) * ((4 * g + 4) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (5 * 5 + 1) * ((4 * g + (5)) ^ 2 + 1))
      (c := 4 * (4) * (4 * g + (4)) * (g * g + 1) * g * g)
      (d := 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 5:  Rcorner g 5 <= Rcorner g 6
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (5) * (4 * g + (5)) - ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (6) * (4 * g + (6)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (5) * (4 * g + (5)) - ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (6) * (4 * g + (6)) = (8882029 : ℝ) + (1582436 : ℝ) * ((g - 15)) ^ 1 + (93904 : ℝ) * ((g - 15)) ^ 2 + (1856 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (6 * 6 + 1) * ((4 * g + (6)) ^ 2 + 1) * 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (5 * 5 + 1) * ((4 * g + 5) ^ 2 + 1) * 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (5) * (4 * g + (5)) - ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (6) * (4 * g + (6))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (5) * (4 * g + (5)) - ((5) * (5) + 1) * ((4 * g + (5)) ^ 2 + 1) * (6) * (4 * g + (6))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (5 * 5 + 1) * ((4 * g + 5) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (6 * 6 + 1) * ((4 * g + (6)) ^ 2 + 1))
      (c := 4 * (5) * (4 * g + (5)) * (g * g + 1) * g * g)
      (d := 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 6:  Rcorner g 6 <= Rcorner g 7
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (6) * (4 * g + (6)) - ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (7) * (4 * g + (7)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (6) * (4 * g + (6)) - ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (7) * (4 * g + (7)) = (13294979 : ℝ) + (2324564 : ℝ) * ((g - 15)) ^ 1 + (135344 : ℝ) * ((g - 15)) ^ 2 + (2624 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (7 * 7 + 1) * ((4 * g + (7)) ^ 2 + 1) * 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (6 * 6 + 1) * ((4 * g + 6) ^ 2 + 1) * 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (6) * (4 * g + (6)) - ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (7) * (4 * g + (7))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (6) * (4 * g + (6)) - ((6) * (6) + 1) * ((4 * g + (6)) ^ 2 + 1) * (7) * (4 * g + (7))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (6 * 6 + 1) * ((4 * g + 6) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (7 * 7 + 1) * ((4 * g + (7)) ^ 2 + 1))
      (c := 4 * (6) * (4 * g + (6)) * (g * g + 1) * g * g)
      (d := 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 7:  Rcorner g 7 <= Rcorner g 8
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (7) * (4 * g + (7)) - ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (8) * (4 * g + (8)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (7) * (4 * g + (7)) - ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (8) * (4 * g + (8)) = (18865125 : ℝ) + (3238140 : ℝ) * ((g - 15)) ^ 1 + (185040 : ℝ) * ((g - 15)) ^ 2 + (3520 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (8 * 8 + 1) * ((4 * g + (8)) ^ 2 + 1) * 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (7 * 7 + 1) * ((4 * g + 7) ^ 2 + 1) * 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (7) * (4 * g + (7)) - ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (8) * (4 * g + (8))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (7) * (4 * g + (7)) - ((7) * (7) + 1) * ((4 * g + (7)) ^ 2 + 1) * (8) * (4 * g + (8))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (7 * 7 + 1) * ((4 * g + 7) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (8 * 8 + 1) * ((4 * g + (8)) ^ 2 + 1))
      (c := 4 * (7) * (4 * g + (7)) * (g * g + 1) * g * g)
      (d := 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 8:  Rcorner g 8 <= Rcorner g 9
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (8) * (4 * g + (8)) - ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (9) * (4 * g + (9)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (8) * (4 * g + (8)) - ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (9) * (4 * g + (9)) = (25735171 : ℝ) + (4338044 : ℝ) * ((g - 15)) ^ 1 + (243376 : ℝ) * ((g - 15)) ^ 2 + (4544 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (9 * 9 + 1) * ((4 * g + (9)) ^ 2 + 1) * 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (8 * 8 + 1) * ((4 * g + 8) ^ 2 + 1) * 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (8) * (4 * g + (8)) - ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (9) * (4 * g + (9))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (8) * (4 * g + (8)) - ((8) * (8) + 1) * ((4 * g + (8)) ^ 2 + 1) * (9) * (4 * g + (9))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (8 * 8 + 1) * ((4 * g + 8) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (9 * 9 + 1) * ((4 * g + (9)) ^ 2 + 1))
      (c := 4 * (8) * (4 * g + (8)) * (g * g + 1) * g * g)
      (d := 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 9:  Rcorner g 9 <= Rcorner g 10
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (9) * (4 * g + (9)) - ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (10) * (4 * g + (10)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (9) * (4 * g + (9)) - ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (10) * (4 * g + (10)) = (34056821 : ℝ) + (5639636 : ℝ) * ((g - 15)) ^ 1 + (310736 : ℝ) * ((g - 15)) ^ 2 + (5696 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (10 * 10 + 1) * ((4 * g + (10)) ^ 2 + 1) * 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (9 * 9 + 1) * ((4 * g + 9) ^ 2 + 1) * 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (9) * (4 * g + (9)) - ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (10) * (4 * g + (10))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (9) * (4 * g + (9)) - ((9) * (9) + 1) * ((4 * g + (9)) ^ 2 + 1) * (10) * (4 * g + (10))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (9 * 9 + 1) * ((4 * g + 9) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (10 * 10 + 1) * ((4 * g + (10)) ^ 2 + 1))
      (c := 4 * (9) * (4 * g + (9)) * (g * g + 1) * g * g)
      (d := 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 10:  Rcorner g 10 <= Rcorner g 11
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (10) * (4 * g + (10)) - ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (11) * (4 * g + (11)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (10) * (4 * g + (10)) - ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (11) * (4 * g + (11)) = (43991019 : ℝ) + (7158756 : ℝ) * ((g - 15)) ^ 1 + (387504 : ℝ) * ((g - 15)) ^ 2 + (6976 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (11 * 11 + 1) * ((4 * g + (11)) ^ 2 + 1) * 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (10 * 10 + 1) * ((4 * g + 10) ^ 2 + 1) * 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (10) * (4 * g + (10)) - ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (11) * (4 * g + (11))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (10) * (4 * g + (10)) - ((10) * (10) + 1) * ((4 * g + (10)) ^ 2 + 1) * (11) * (4 * g + (11))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (10 * 10 + 1) * ((4 * g + 10) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (11 * 11 + 1) * ((4 * g + (11)) ^ 2 + 1))
      (c := 4 * (10) * (4 * g + (10)) * (g * g + 1) * g * g)
      (d := 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)
  · -- k = 11:  Rcorner g 11 <= Rcorner g 12
    dsimp only [Rcorner]
    have hP0 : 0 ≤ ((12) * (12) + 1) * ((4 * g + (12)) ^ 2 + 1) * (11) * (4 * g + (11)) - ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (12) * (4 * g + (12)) := by
      set v := g - 15 with hv_def
      have hv : 0 ≤ v := by linarith
      have hsum : ((12) * (12) + 1) * ((4 * g + (12)) ^ 2 + 1) * (11) * (4 * g + (11)) - ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (12) * (4 * g + (12)) = (55708189 : ℝ) + (8911724 : ℝ) * ((g - 15)) ^ 1 + (474064 : ℝ) * ((g - 15)) ^ 2 + (8384 : ℝ) * ((g - 15)) ^ 3 := by
        ring
      rw [hsum]
      rw [show (g - 15) = v from hv_def.symm]
      positivity
    have hS : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
      have h1 : 0 < 4 * (g * g + 1 / 4) := by
        refine mul_pos (by norm_num) (by positivity)
      have h2 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) := by
        refine mul_pos h1 (by positivity)
      have h2g : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g := by
        refine mul_pos h2 _
        linarith
      have h3 : 0 < 4 * (g * g + 1 / 4) * (g * g + 1) * g * g := by
        refine mul_pos h2g _
        positivity
      exact h3.le
    have hid : (g * g + 1 / 4) * (12 * 12 + 1) * ((4 * g + (12)) ^ 2 + 1) * 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g - (g * g + 1 / 4) * (11 * 11 + 1) * ((4 * g + 11) ^ 2 + 1) * 4 * (12) * (4 * g + (12)) * (g * g + 1) * g * g = 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((12) * (12) + 1) * ((4 * g + (12)) ^ 2 + 1) * (11) * (4 * g + (11)) - ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (12) * (4 * g + (12))) := by
      ring
    have hprod : 0 ≤ 4 * (g * g + 1 / 4) * (g * g + 1) * g * g * (((12) * (12) + 1) * ((4 * g + (12)) ^ 2 + 1) * (11) * (4 * g + (11)) - ((11) * (11) + 1) * ((4 * g + (11)) ^ 2 + 1) * (12) * (4 * g + (12))) :=
      mul_nonneg hS hP0
    rw [hid] at hprod
    have hden1 : 0 < 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    have hden2 : 0 < 4 * (12) * (4 * g + (12)) * (g * g + 1) * g * g := by
      apply mul_pos <;> (try norm_num) <;> (try linarith) <;> (try nlinarith)
    exact div_le_div_of_mul
      (a := (g * g + 1 / 4) * (11 * 11 + 1) * ((4 * g + 11) ^ 2 + 1))
      (b := (g * g + 1 / 4) * (12 * 12 + 1) * ((4 * g + (12)) ^ 2 + 1))
      (c := 4 * (11) * (4 * g + (11)) * (g * g + 1) * g * g)
      (d := 4 * (12) * (4 * g + (12)) * (g * g + 1) * g * g)
      hden1 hden2 (le_of_sub_nonneg hprod)

theorem s3a_lt1 (g : ℝ) (hg : 15 ≤ g) : Rcorner g 12 < 1 := by
  dsimp [Rcorner]
  set Df := 48 * (4 * g + 12) * (g * g + 1) * g * g -
      (g * g + 1 / 4) * 145 * ((4 * g + 12) ^ 2 + 1) with hDf_def
  have hP : Df = (6389018 : ℝ) + 15155250 * (g - 15) + 3486811 * (g - 15) ^ 2 +
      313632 * (g - 15) ^ 3 + 12656 * (g - 15) ^ 4 + 192 * (g - 15) ^ 5 := by
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
    refine mul_pos (mul_pos _ (by norm_num)) _
    · positivity
    · positivity
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
      exact sub_lt_one_of_pos (1 : ℝ) hdv
theorem s3a_bound13 (g : ℝ) (hg : 40 ≤ g) : Rcorner g 12 ≤ 13 / g := by
  dsimp [Rcorner]
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
  have h2 : Ralg g (k : ℝ) (1 / 2) = Rcorner g (k : ℝ) :=
    corner_eq g (k : ℝ) (by linarith) (by linarith [hk1])
  have h3 : Rcorner g (k : ℝ) ≤ Rcorner g 12 := by
    interval_cases k
  · -- k = 1
    calc
      Rcorner g (1 : ℝ) ≤ Rcorner g (2 : ℝ) :=
          s3a_kmon g (by linarith) 1 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (2 : ℝ) :=
          s3a_kmon g (by linarith) 1 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (3 : ℝ) :=
          s3a_kmon g (by linarith) 2 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (4 : ℝ) :=
          s3a_kmon g (by linarith) 3 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (5 : ℝ) :=
          s3a_kmon g (by linarith) 4 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 2
    calc
      Rcorner g (2 : ℝ) ≤ Rcorner g (3 : ℝ) :=
          s3a_kmon g (by linarith) 2 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (3 : ℝ) :=
          s3a_kmon g (by linarith) 2 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (4 : ℝ) :=
          s3a_kmon g (by linarith) 3 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (5 : ℝ) :=
          s3a_kmon g (by linarith) 4 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 3
    calc
      Rcorner g (3 : ℝ) ≤ Rcorner g (4 : ℝ) :=
          s3a_kmon g (by linarith) 3 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (4 : ℝ) :=
          s3a_kmon g (by linarith) 3 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (5 : ℝ) :=
          s3a_kmon g (by linarith) 4 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 4
    calc
      Rcorner g (4 : ℝ) ≤ Rcorner g (5 : ℝ) :=
          s3a_kmon g (by linarith) 4 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (5 : ℝ) :=
          s3a_kmon g (by linarith) 4 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 5
    calc
      Rcorner g (5 : ℝ) ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (6 : ℝ) :=
          s3a_kmon g (by linarith) 5 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 6
    calc
      Rcorner g (6 : ℝ) ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (7 : ℝ) :=
          s3a_kmon g (by linarith) 6 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 7
    calc
      Rcorner g (7 : ℝ) ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (8 : ℝ) :=
          s3a_kmon g (by linarith) 7 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 8
    calc
      Rcorner g (8 : ℝ) ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (9 : ℝ) :=
          s3a_kmon g (by linarith) 8 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 9
    calc
      Rcorner g (9 : ℝ) ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (10 : ℝ) :=
          s3a_kmon g (by linarith) 9 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 10
    calc
      Rcorner g (10 : ℝ) ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (11 : ℝ) :=
          s3a_kmon g (by linarith) 10 (by norm_num) (by norm_num)
        _ ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 11
    calc
      Rcorner g (11 : ℝ) ≤ Rcorner g (12 : ℝ) :=
          s3a_kmon g (by linarith) 11 (by norm_num) (by norm_num)
  · -- k = 12
    rfl
  calc
    Ralg g (k : ℝ) d ≤ Ralg g (k : ℝ) (1 / 2) := h1
    _ = Rcorner g (k : ℝ) := h2
    _ ≤ Rcorner g 12 := h3
    _ ≤ 13 / g := s3a_bound13 g hg40

end S3a
