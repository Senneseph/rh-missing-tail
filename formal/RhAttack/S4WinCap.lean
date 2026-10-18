import Mathlib
import RhAttack.B0
import RhAttack.B3Core
import RhAttack.B4
import RhAttack.B5
import RhAttack.P8Floor
import RhAttack.P12Uniform
import RhAttack.S4Own
import RhAttack.S4Window
import RhAttack.S4Growth
import RhAttack.S4Asm
import RhAttack.S1LowT
import RhAttack.Z78P12

/- S4WinCap -- the hWin window floor cap + the face identity.

   WHAT (three new formal facts; no RH claim anywhere):

   (1) poffOwnMown:  ‖poff(t,d,t)‖ = S4O.mown t d  for
       0 < t, 0 < d <= 1/2 -- B5's four canonical off-line factors
       at the pair's OWN HEIGHT are exactly the S4Own own-mass
       kernel (the same 8-factor product (1 - S/rho)·exp(S/rho);
       S4O.hMownProd is the closed-form bridge, 25n).

   (2) floorBelowWire:  for EVERY 1000 <= t, 0 < d < 1/200
         S1LowT.floStripMin t d  <  S4A.BwireR t d
       i.e. the unified S2 floor (min(‖poff‖, max(floWin,0))) sits
       strictly BELOW a single term (the first tail term
       (1/2)·n^{−1/2}) of the window S4 wire, on the whole window
       band.  The floor is the own-kernel 4d²/t² scale (it vanishes
       like d² as d -> 0) while the wire is d-INDEPENDENT and >=
       (1/2)·⌊13t/8⌋^{−1/2} (t <= T0) or >= (1/2)·⌊t²⌋^{−1/2}
       (t > T0).  The cap constant: the floor is < 31/(10^5·t²) on
       the band (each own-kernel factor pinned separately); the
       tail term beats it by > 10^11 x at (t = 1e7, d = 1/200).

   (3) hwinFaceImpliesZeroExclusion:  the hWin face of
       RHEnd.rh_program78 (window wire + Mf < floStripMin at the
       off-pair windows t >= 1000, d < 1/200; stated here with the
       Z78P12 wire aliases exactly as in RHEnd) is EQUIVALENT to
       ZERO-EXCLUSION: q has no off-line zeros at all in
       [1000, ∞) x (0, 1/200).  The squeeze instrument is
       machine-certified NOT to reach the window band: the floor is
       below a single wire term there.  The face itself remains
       OPEN -- it asserts zero-exclusion on a band no instrument in
       the tree reaches (classical zero-free regions give
       Re >= 1 - c/ln t, nowhere near 1/2 - 1/200).  No RH claim.

   MEASURED BACKSTOP (survey s35a, tmp/s35a_hwin_far_survey.py,
   log tmp/s35a_hwin_survey.log -- the script reproduces the Lean
   pins before results are trusted):
     - margin = floStripMin - (Bwire+Mr) < 0 at EVERY surveyed
       (t, d) on  t in [1e3 .. 3e10] (19 log heights) x
       d in (1e-9, 1/200) (41 log points + cap);
     - floor = 4d²/t² to rel 2e-13 (the ‖poff‖ side of the min);
     - window wire total: 4.55e-6 at t = 1.1e5 (growth branch)
       -> 1.67e-11 at t = 3e10;  0.0438..0.9365 on [1e3, T0];
     - Xwire(T0) = 1.827275e-3 <= RX = 1.85e-3 (reproduces the 25m
       pinned hX from scratch);  the 25m total at T0 = 0.936536
       < 0.9975 (reproduces hTotal's content).

   HONESTY: (1)-(2) are LEAN-PROVEN (closed forms + norm_num
   pins); (3) follows LEAN-PROVEN from them; the face is OPEN.
-/

namespace S4WC

open Real Set B0 P12

variable {t d : ℝ}

/- — (1) — the own-height identity — -/

/-- sLine t = S4O.S t (both 1/2 + i·t; halfR = (2 : ℝ)⁻¹ = 1/2). -/
lemma sLine_eq_S (t : ℝ) : sLine t = S4O.S t := by
  dsimp only [sLine, S4O.S, halfR]
  apply Complex.ext
  · norm_num
  · ring

/-- B5's four off-line zeros at (t, d) coincide with S4O's
    z1..z4 (rhoPP (+d,+t), rhoPM (+d,−t), rhoNP (−d,+t),
    rhoNM (−d,−t)). -/
lemma rhoPP_eq_z1 (t d : ℝ) : rhoPP t d = S4O.z1 t d := by
  dsimp only [rhoPP, S4O.z1, halfR]
  apply Complex.ext
  · rw [show ((2 : ℝ)⁻¹ : ℝ) = (1 / 2 : ℝ) from by norm_num]
    simp
  · simp
lemma rhoPM_eq_z2 (t d : ℝ) : rhoPM t d = S4O.z2 t d := by
  dsimp only [rhoPM, S4O.z2, halfR]
  apply Complex.ext
  · rw [show ((2 : ℝ)⁻¹ : ℝ) = (1 / 2 : ℝ) from by norm_num]
    simp
  · simp
lemma rhoNP_eq_z3 (t d : ℝ) : rhoNP t d = S4O.z3 t d := by
  dsimp only [rhoNP, S4O.z3, halfR]
  apply Complex.ext
  · rw [show ((2 : ℝ)⁻¹ : ℝ) = (1 / 2 : ℝ) from by norm_num]
    simp
  · simp
lemma rhoNM_eq_z4 (t d : ℝ) : rhoNM t d = S4O.z4 t d := by
  dsimp only [rhoNM, S4O.z4, halfR]
  apply Complex.ext
  · rw [show ((2 : ℝ)⁻¹ : ℝ) = (1 / 2 : ℝ) from by norm_num]
    simp
  · simp

/-- B5's 4-factor product at (t, d, t) is the 8-factor own-kernel
    product at S4O's z1..z4 (same order: PP, PM, NP, NM). -/
lemma poff_integrand (t d : ℝ) :
    poff t d t =
      (1 - S4O.S t / S4O.z1 t d) * Complex.exp (S4O.S t / S4O.z1 t d) *
      (1 - S4O.S t / S4O.z2 t d) * Complex.exp (S4O.S t / S4O.z2 t d) *
      (1 - S4O.S t / S4O.z3 t d) * Complex.exp (S4O.S t / S4O.z3 t d) *
      (1 - S4O.S t / S4O.z4 t d) * Complex.exp (S4O.S t / S4O.z4 t d) := by
  dsimp only [poff, fac]
  simp only [sLine_eq_S, rhoPP_eq_z1, rhoPM_eq_z2, rhoNP_eq_z3, rhoNM_eq_z4]
  ring

/-- THE OWN-HEIGHT IDENTITY: at the pair's own height the B5
    off-line factor product has mass exactly S4O's own kernel,
    hence exactly the 25n closed form mown (S4O.hMownProd). -/
theorem poffOwnMown (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    ‖poff t d t‖ = S4O.mown t d := by
  rw [poff_integrand t d]
  exact S4O.hMownProd t d ht hd0 hd

/- — (2) — the floor cap — -/

/-- THE OWN-KERNEL SCALE PIN (window band): for 1000 <= t and
    0 < d < 1/200,
      S4O.mown t d < (31 / 100000 : ℝ) / t².
    Each factor pinned separately (S4O.hMownScaleHi):
    4d² < 1/10000 (d < 1/200); 1 + 1/(16t²) < 16000001/16000000
    (t >= 1000);  exp(1/t²) <= 1/(1 - 1/t²) <= 1000000/999999
    (ln(1-x) <= -x for x in (0,1)). -/
theorem mownWindowScale (ht : 1000 ≤ t) (hd0 : 0 < d) (hdw : d < 1 / 200) :
    S4O.mown t d < (31 / 100000 : ℝ) / t ^ 2 := by
  have hposT : 0 < t := by nlinarith [ht]
  have hdH : d <= 1 / 2 := by
    nlinarith [hdw, show (1 / 200 : ℝ) < 1 / 2 from by norm_num]
  have hH : S4O.mown t d <= (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) *
      Real.exp (1 / t ^ 2) := S4O.hMownScaleHi t d hposT hd0 hdH
  have ht1e6 : (1000000 : ℝ) <= t ^ 2 := by
    have h1 : (1000 : ℝ) * (1000 : ℝ) <= (1000 : ℝ) * t :=
      mul_le_mul_of_nonneg_left ht (by norm_num)
    have h2 : (1000 : ℝ) * t <= t * t :=
      mul_le_mul_of_nonneg_right ht (by nlinarith [ht])
    nlinarith [h1, h2, show (1000 : ℝ) * (1000 : ℝ) = 1000000 from by norm_num,
      show t * t = t ^ 2 from by ring]
  have hd2 : d ^ 2 < (1 / 200 : ℝ) ^ 2 := by
    have hdiff : d - 1 / 200 < 0 := by linarith [hdw]
    have hsum : 0 < d + 1 / 200 := by nlinarith [hd0]
    have hprod : (d - 1 / 200) * (d + 1 / 200) < 0 := mul_neg_of_neg_of_pos hdiff hsum
    nlinarith [show (d - 1 / 200) * (d + 1 / 200) = d ^ 2 - (1 / 200) ^ 2 from by ring,
      show (1 / 200 : ℝ) ^ 2 = 1 / 40000 from by norm_num, hprod]
  have hA : (4 * d ^ 2 : ℝ) < (1 : ℝ) / 10000 := by
    have h1 : d ^ 2 < (1 / 40000 : ℝ) := by
      calc d ^ 2 < (1 / 200 : ℝ) ^ 2 := hd2
        _ = (1 / 40000 : ℝ) := by norm_num
    have h2 : 4 * d ^ 2 < 4 * (1 / 40000 : ℝ) :=
      mul_lt_mul_of_pos_left h1 (by norm_num)
    have h3 : 4 * (1 / 40000 : ℝ) = (1 : ℝ) / 10000 := by norm_num
    rw [h3] at h2
    exact h2
  have hB : (1 + 1 / (16 * t ^ 2) : ℝ) <= 16000001 / 16000000 := by
    have h1 : (16000000 : ℝ) <= 16 * t ^ 2 := by
      have h2 : (16 : ℝ) * (1000000 : ℝ) <= (16 : ℝ) * (t ^ 2) :=
        mul_le_mul_of_nonneg_left ht1e6 (by norm_num)
      have h3 : (16000000 : ℝ) = (16 : ℝ) * (1000000 : ℝ) := by norm_num
      nlinarith [h2, h3]
    have h2 : (1 : ℝ) / (16 * t ^ 2) <= (1 : ℝ) / 16000000 :=
      (one_div_le_one_div (by positivity) (by positivity)).mpr h1
    nlinarith [show (16000001 : ℝ) / 16000000 = 1 + (1 : ℝ) / 16000000 from by norm_num, h2]
  have hx1 : (1 / t ^ 2 : ℝ) < 1 := by
    have h1 : (1 : ℝ) < t ^ 2 := by nlinarith [ht1e6]
    exact (div_lt_one (by positivity)).mpr h1
  have h1m : (0 : ℝ) < 1 - 1 / t ^ 2 := by nlinarith [hx1]
  have hlogpin : (1 / t ^ 2 : ℝ) <= -Real.log (1 - 1 / t ^ 2) := by
    have h1 : Real.log (1 - 1 / t ^ 2) <= (1 - 1 / t ^ 2 : ℝ) - 1 :=
      Real.log_le_sub_one_of_pos h1m
    have h2 : (1 - 1 / t ^ 2 : ℝ) - 1 = -(1 / t ^ 2) := by ring
    rw [h2] at h1
    linarith
  have hexp : Real.exp (1 / t ^ 2) <= 1 / (1 - 1 / t ^ 2) := by
    have h1 : Real.exp (1 / t ^ 2) <= Real.exp (-Real.log (1 - 1 / t ^ 2)) :=
      Real.exp_le_exp.mpr hlogpin
    have h2 : Real.exp (-Real.log (1 - 1 / t ^ 2)) = (1 - 1 / t ^ 2)⁻¹ := by
      rw [Real.exp_neg, Real.exp_log h1m]
    have h3 : (1 - 1 / t ^ 2 : ℝ)⁻¹ = 1 / (1 - 1 / t ^ 2) := by
      field_simp
    nlinarith [h1, h2, h3]
  have hC : Real.exp (1 / t ^ 2) <= (1000000 : ℝ) / 999999 := by
    have h1 : (1 : ℝ) - 1 / t ^ 2 >= 999999 / 1000000 := by
      have h2 : (1 / t ^ 2 : ℝ) <= (1 : ℝ) / 1000000 :=
        (one_div_le_one_div (by positivity) (by positivity)).mpr ht1e6
      nlinarith [h2]
    calc Real.exp (1 / t ^ 2)
        <= 1 / (1 - 1 / t ^ 2) := hexp
      _ <= 1 / (999999 / 1000000) :=
          (one_div_le_one_div (by positivity) (by positivity)).mpr h1
      _ = (1000000 : ℝ) / 999999 := by field_simp
  have hrest1 : (0 : ℝ) < (1 + 1 / (16 * t ^ 2) : ℝ) := by positivity
  have hrest2 : (0 : ℝ) < Real.exp (1 / t ^ 2) := Real.exp_pos _
  have hrest : (0 : ℝ) < (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) :=
    mul_pos hrest1 hrest2
  have hstep1a : (4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) <
      (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) :=
    mul_lt_mul_of_pos_right hA hrest1
  have hstep1 : (4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) *
      Real.exp (1 / t ^ 2) <
      (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) :=
    mul_lt_mul_of_pos_right hstep1a hrest2
  have hstep2 : (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) *
      Real.exp (1 / t ^ 2) <=
      (1 / 10000 : ℝ) * (16000001 / 16000000) * Real.exp (1 / t ^ 2) := by
    have h1 : (1 + 1 / (16 * t ^ 2) : ℝ) * Real.exp (1 / t ^ 2) <=
        (16000001 / 16000000 : ℝ) * Real.exp (1 / t ^ 2) :=
      mul_le_mul_of_nonneg_right hB (le_of_lt hrest2)
    have h2 : (1 / 10000 : ℝ) * ((1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) =
        (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := by ring
    have h3 : (1 / 10000 : ℝ) * ((16000001 / 16000000) * Real.exp (1 / t ^ 2)) =
        (1 / 10000 : ℝ) * (16000001 / 16000000) * Real.exp (1 / t ^ 2) := by ring
    have h4 : (1 / 10000 : ℝ) * ((1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) <=
        (1 / 10000 : ℝ) * ((16000001 / 16000000) * Real.exp (1 / t ^ 2)) := by
      nlinarith [show (1 / 10000 : ℝ) * ((1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) <=
        (1 / 10000 : ℝ) * ((16000001 / 16000000) * Real.exp (1 / t ^ 2)) from
        mul_le_mul_of_nonneg_left h1 (by norm_num)]
    calc (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
        = (1 / 10000 : ℝ) * ((1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) := h2.symm
      _ <= (1 / 10000 : ℝ) * ((16000001 / 16000000) * Real.exp (1 / t ^ 2)) := h4
      _ = (1 / 10000 : ℝ) * (16000001 / 16000000) * Real.exp (1 / t ^ 2) := h3
  have hstep3 : (1 / 10000 : ℝ) * (16000001 / 16000000) *
      Real.exp (1 / t ^ 2) <=
      (1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999) :=
    mul_le_mul_of_nonneg_left hC (by norm_num)
  have hprod : (4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) <
      (1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999) := by
    calc (4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
        < (1 / 10000 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := hstep1
      _ <= (1 / 10000 : ℝ) * (16000001 / 16000000) * Real.exp (1 / t ^ 2) := hstep2
      _ <= (1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999) := hstep3
  have h1e4 : (1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999) <
      (31 / 100000 : ℝ) := by norm_num
  calc S4O.mown t d
      <= (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) := hH
    _ = ((4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) / t ^ 2 := by
        field_simp [show (0 : ℝ) ≠ t ^ 2 from by positivity]
        <;> ring
    _ < ((1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999)) / t ^ 2 := by
        have h1 : ((4 * d ^ 2 : ℝ) * (1 + 1 / (16 * t ^ 2)) *
            Real.exp (1 / t ^ 2)) * t ^ 2 <
            ((1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999)) * t ^ 2 :=
          mul_lt_mul_of_pos_right hprod (by positivity)
        exact (div_lt_div_iff₀ (by positivity) (by positivity)).mpr h1
    _ <= (31 / 100000 : ℝ) / t ^ 2 := by
        have h2 : ((1 / 10000 : ℝ) * (16000001 / 16000000) * (1000000 / 999999)) *
            t ^ 2 <= (31 / 100000 : ℝ) * t ^ 2 :=
          mul_le_mul_of_nonneg_right (le_of_lt h1e4) (by positivity)
        exact (div_le_div_iff₀ (by positivity) (by positivity)).mpr h2

/-- NEAR BRANCH: 31/(100000·t²) < ½/√(13t/8)  for t >= 1000.
    Core: 31·√(13t/8) < 50000·t²  (squaring: 12493t/8 < 2·10⁹·t⁴,
    from t⁴ > t for t > 1 and 12493/8 < 2·10⁹). -/
theorem nearTailBelowScale (ht : 1000 ≤ t) :
    (31 / 100000 : ℝ) / t ^ 2 < 1 / 2 / Real.sqrt (13 * t / 8) := by
  have hpos : 0 < t := by nlinarith [ht]
  have h13t : 0 < 13 * t / 8 := by nlinarith [ht]
  have hcore : (31 : ℝ) * Real.sqrt (13 * t / 8) < 50000 * t ^ 2 := by
    have hsq : (31 * Real.sqrt (13 * t / 8)) ^ 2 < (50000 * t ^ 2) ^ 2 := by
      have h1 : (31 * Real.sqrt (13 * t / 8)) ^ 2 = (31 : ℝ) ^ 2 * (13 * t / 8) := by
        calc (31 * Real.sqrt (13 * t / 8)) ^ 2
            = (31 : ℝ) ^ 2 * (Real.sqrt (13 * t / 8)) ^ 2 := by ring
          _ = (31 : ℝ) ^ 2 * (13 * t / 8) := by
              rw [Real.sq_sqrt h13t.le]
      have h2 : (50000 * t ^ 2) ^ 2 = (50000 : ℝ) ^ 2 * t ^ 4 := by
        have h3 : (50000 * t ^ 2 : ℝ) ^ 2 = (50000 : ℝ) ^ 2 * (t ^ 2) ^ 2 := by ring
        have h4 : (t ^ 2 : ℝ) ^ 2 = t ^ 4 := by ring
        rw [h3, h4]
      rw [h1, h2]
      have h3 : (31 : ℝ) ^ 2 * (13 * t / 8) = (12493 / 8 : ℝ) * t := by ring
      have h4 : (50000 : ℝ) ^ 2 = (2500000000 : ℝ) := by norm_num
      rw [h3, h4]
      have ht4 : (1 : ℝ) < t ^ 4 := by
        have h5 : (1 : ℝ) < t := by nlinarith [ht, show (1 : ℝ) < 1000 from by norm_num]
        have h6 : (0 : ℝ) < t := by nlinarith [h5]
        have h7 : (1 : ℝ) * t < t * t := mul_lt_mul_of_pos_right h5 (by nlinarith [h6])
        have h8 : (1 : ℝ) < t * t := by nlinarith [h7, show (1 : ℝ) * t = t from by ring]
        have h9 : (0 : ℝ) < t * t := by nlinarith [h8]
        have h10 : (t * t : ℝ) * 1 < (t * t) * (t * t) := mul_lt_mul_of_pos_left h8 (by nlinarith [h9])
        calc (1 : ℝ) < t * t := h8
          _ = (t * t) * 1 := by ring
          _ < (t * t) * (t * t) := h10
          _ = t ^ 4 := by ring
      have h5 : (t : ℝ) < t ^ 4 := by
        have h6 : (1 : ℝ) < t ^ 3 := by
          have h7 : (1 : ℝ) < t := by nlinarith [ht, show (1 : ℝ) < 1000 from by norm_num]
          have h8 : (0 : ℝ) < t := by nlinarith [h7]
          have h9 : (1 : ℝ) * t < t * t := mul_lt_mul_of_pos_right h7 (by nlinarith [h8])
          have h10 : (1 : ℝ) < t * t := by nlinarith [h9, show (1 : ℝ) * t = t from by ring]
          have h11 : (0 : ℝ) < t * t := by nlinarith [h10]
          have h12 : (t * t : ℝ) * 1 < (t * t) * t :=
            mul_lt_mul_of_pos_left h7 (by nlinarith [h8])
          nlinarith [h12, show (t * t : ℝ) * t = t ^ 3 from by ring,
            show (t * t : ℝ) * 1 = t ^ 2 from by ring]
        have h7 : (t : ℝ) * 1 < t * t ^ 3 := mul_lt_mul_of_pos_left h6 (by positivity)
        nlinarith [h7, show (t : ℝ) * t ^ 3 = t ^ 4 from by ring,
          show (t : ℝ) * 1 = t from by ring]
      have h6 : (12493 / 8 : ℝ) * t < (12493 / 8 : ℝ) * t ^ 4 :=
        mul_lt_mul_of_pos_left h5 (by norm_num : (0 : ℝ) < (12493 / 8 : ℝ))
      have h7 : (12493 / 8 : ℝ) * t ^ 4 < (2 * 1000000000 : ℝ) * t ^ 4 := by
        have h8 : (12493 / 8 : ℝ) < (2 : ℝ) * 1000000000 := by norm_num
        have h9 : (0 : ℝ) < t ^ 4 := by nlinarith [ht4]
        exact mul_lt_mul_of_pos_right h8 h9
      have h7b : (2 * 1000000000 : ℝ) * t ^ 4 <= (50000 : ℝ) ^ 2 * t ^ 4 := by
        have h8 : (2 * 1000000000 : ℝ) <= (50000 : ℝ) ^ 2 := by
          nlinarith [show (2 * 1000000000 : ℝ) <= 2500000000 from by norm_num,
            show (50000 : ℝ) ^ 2 = 2500000000 from by norm_num]
        have h9 : (0 : ℝ) <= t ^ 4 := by nlinarith [ht4]
        exact mul_le_mul_of_nonneg_right h8 h9
      nlinarith [h6, h7, h7b]
    have hL : (0 : ℝ) <= (31 : ℝ) * Real.sqrt (13 * t / 8) := by
      positivity
    have hR : (0 : ℝ) < (50000 : ℝ) * t ^ 2 := by positivity
    have hdiff : (0 : ℝ) < (50000 * t ^ 2) ^ 2 - (31 * Real.sqrt (13 * t / 8)) ^ 2 := by
      nlinarith [hsq]
    have hsum : (0 : ℝ) < (50000 : ℝ) * t ^ 2 + (31 : ℝ) * Real.sqrt (13 * t / 8) := by
      positivity
    have hfact : ((50000 : ℝ) * t ^ 2 - (31 : ℝ) * Real.sqrt (13 * t / 8)) *
        ((50000 : ℝ) * t ^ 2 + (31 : ℝ) * Real.sqrt (13 * t / 8)) =
        (50000 * t ^ 2) ^ 2 - (31 * Real.sqrt (13 * t / 8)) ^ 2 := by ring
    have hposd : (0 : ℝ) < (50000 : ℝ) * t ^ 2 - (31 : ℝ) * Real.sqrt (13 * t / 8) := by
      by_contra h
      have h1 : (50000 : ℝ) * t ^ 2 - (31 : ℝ) * Real.sqrt (13 * t / 8) <= 0 := by
        linarith [h]
      have h2 : ((50000 : ℝ) * t ^ 2 - (31 : ℝ) * Real.sqrt (13 * t / 8)) *
          ((50000 : ℝ) * t ^ 2 + (31 : ℝ) * Real.sqrt (13 * t / 8)) <= 0 :=
        mul_nonpos_of_nonpos_of_nonneg h1 (le_of_lt hsum)
      have h3 : (0 : ℝ) < ((50000 : ℝ) * t ^ 2 - (31 : ℝ) * Real.sqrt (13 * t / 8)) *
          ((50000 : ℝ) * t ^ 2 + (31 : ℝ) * Real.sqrt (13 * t / 8)) := by
        nlinarith [hfact, hdiff]
      nlinarith [h2, h3]
    linarith [hposd]
  have hmult : (31 / 100000 : ℝ) / t ^ 2 * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) <
      (1 / 2 / Real.sqrt (13 * t / 8)) * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) := by
    have hA : (1 / 2 / Real.sqrt (13 * t / 8)) * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) = t ^ 2 := by
      field_simp [show Real.sqrt (13 * t / 8) ≠ 0 from by positivity]
      <;> ring
    have hB : (31 / 100000 : ℝ) / t ^ 2 * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) =
        (31 : ℝ) * Real.sqrt (13 * t / 8) / 50000 := by
      field_simp [show t ^ 2 ≠ 0 from by positivity]
      <;> ring
    rw [hA, hB]
    have hC : (31 : ℝ) * Real.sqrt (13 * t / 8) / 50000 < t ^ 2 := by
      have h1 : (31 : ℝ) * Real.sqrt (13 * t / 8) < 50000 * t ^ 2 := hcore
      have h2 : (0 : ℝ) < 50000 := by norm_num
      have h3 : (31 : ℝ) * Real.sqrt (13 * t / 8) < t ^ 2 * 50000 := by
        nlinarith [h1, show t ^ 2 * 50000 = 50000 * t ^ 2 from by ring]
      exact (div_lt_iff₀ h2).mpr h3
    nlinarith [hC]
  have hfin : (31 / 100000 : ℝ) / t ^ 2 < 1 / 2 / Real.sqrt (13 * t / 8) := by
    by_contra h
    have h1 : (31 / 100000 : ℝ) / t ^ 2 >= 1 / 2 / Real.sqrt (13 * t / 8) := by
      linarith [h]
    have h2 : (31 / 100000 : ℝ) / t ^ 2 * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) >=
        (1 / 2 / Real.sqrt (13 * t / 8)) * (2 * t ^ 2 * Real.sqrt (13 * t / 8)) := by
      have h3 : (0 : ℝ) <= 2 * t ^ 2 * Real.sqrt (13 * t / 8) := by positivity
      exact mul_le_mul_of_nonneg_right h1 h3
    nlinarith [hmult, h2]
  exact hfin

/-- FAR BRANCH: 31/(100000·t²) < 1/(2t)  for t > T0 (110000).
    (62t < 100000·t²  ⟸  t(100000t − 62) > 0, with 100000t > 62
    since t > 110000.) -/
theorem farTailBelowScale (ht : 1000 ≤ t) (htT : ¬ t <= S4W.T0) :
    (31 / 100000 : ℝ) / t ^ 2 < 1 / (2 * t) := by
  have hT : (110000 : ℝ) < t := by
    by_contra h
    have h1 : t <= 110000 := by linarith [h]
    have h2 : t <= S4W.T0 := by
      have h3 : (S4W.T0 : ℝ) = 110000 := by rfl
      simpa [h3] using h1
    exact htT h2
  have h1 : (62 : ℝ) < 100000 * t := by
    have h2 : (62 : ℝ) < 100000 * (110000 : ℝ) := by norm_num
    have h3 : 100000 * (110000 : ℝ) <= 100000 * t :=
      mul_le_mul_of_nonneg_left (le_of_lt hT) (by norm_num)
    nlinarith [h2, h3]
  have h2 : (31 : ℝ) * (2 * t) < 100000 * t ^ 2 := by
    have h3 : (0 : ℝ) < 100000 * t - 62 := by nlinarith [h1]
    have h4 : (0 : ℝ) < t := by nlinarith [ht]
    have h5 : (0 : ℝ) < t * (100000 * t - 62) := mul_pos h4 h3
    nlinarith [h5, show t * (100000 * t - 62) = 100000 * t ^ 2 - (62 : ℝ) * t from by ring,
      show ((31 : ℝ) * (2 * t) : ℝ) = (62 : ℝ) * t from by ring]
  calc (31 / 100000 : ℝ) / t ^ 2
      = (31 : ℝ) / (100000 * t ^ 2) := by
          field_simp [show t ^ 2 ≠ 0 from by positivity]
          <;> ring
      _ < 1 / (2 * t) := by
          have h3 : (0 : ℝ) < 100000 * t ^ 2 := by positivity
          have h4 : (0 : ℝ) < 2 * t := by nlinarith [ht]
          have h5 : (31 : ℝ) * (2 * t) < (1 : ℝ) * (100000 * t ^ 2) := by
            simpa [mul_one] using h2
          exact (div_lt_div_iff₀ h3 h4).mpr h5

/-- THE FLOOR CAP: on the whole window band 1000 <= t, 0 < d < 1/200
    the unified S2 floor is strictly below the window S4 wire's first
    tail term, hence below the full wire total (survey s35a records
    the measured picture; see the module header). -/
theorem floorBelowWire (ht : 1000 ≤ t) (hd0 : 0 < d) (hdw : d < 1 / 200) :
    S1LowT.floStripMin t d < S4A.BwireR t d := by
  have hpos : 0 < t := by nlinarith [ht]
  have hdH : d <= 1 / 2 := by
    nlinarith [hdw, show (1 / 200 : ℝ) < 1 / 2 from by norm_num]
  have hmown : ‖poff t d t‖ = S4O.mown t d :=
    poffOwnMown t d hpos hd0 hdH
  have hscale : S4O.mown t d < (31 / 100000 : ℝ) / t ^ 2 :=
    mownWindowScale ht hd0 hdw
  have hflomin : S1LowT.floStripMin t d <= ‖poff t d t‖ := by
    dsimp only [S1LowT.floStripMin]
    simpa using min_le_left _ _
  have hfloor : S1LowT.floStripMin t d < (31 / 100000 : ℝ) / t ^ 2 :=
    lt_of_le_of_lt hflomin (lt_of_eq_of_lt hmown hscale)
  have hnotwin : ¬ (1 / 200 <= d) := by
    intro h
    nlinarith [hdw, h]
  by_cases ht0 : t <= S4W.T0
  · -- near branch: BwireR = p8_B t ⌊13t/8⌋
    have hb : S4A.BwireR t d = p8_B t (Nat.floor (13 * t / 8)) := by
      dsimp only [S4A.BwireR]
      rw [if_pos ⟨ht, hdH⟩, if_neg hnotwin, if_pos ht0]
    rw [hb]
    have hn : (0 : ℝ) < (Nat.floor (13 * t / 8) : ℝ) := S4W.hFloorPos t ht
    have hsq : 1 / (2 * Real.sqrt (13 * t / 8)) <=
        1 / (2 * Real.sqrt (Nat.floor (13 * t / 8))) := by
      have h1 : Real.sqrt (Nat.floor (13 * t / 8)) <= Real.sqrt (13 * t / 8) :=
        Real.sqrt_le_sqrt (Nat.floor_le (by nlinarith [ht, hpos] : (0 : ℝ) <= 13 * t / 8))
      have h2 : (2 : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)) <=
          (2 : ℝ) * Real.sqrt (13 * t / 8) :=
        mul_le_mul_of_nonneg_left h1 (by norm_num)
      have h3 : (0 : ℝ) < (2 : ℝ) * Real.sqrt (13 * t / 8) := by positivity
      have h4 : (0 : ℝ) < (2 : ℝ) * Real.sqrt (Nat.floor (13 * t / 8)) := by
        have h5 : (0 : ℝ) < Real.sqrt (Nat.floor (13 * t / 8)) := by
          have h6 : (0 : ℝ) < (Nat.floor (13 * t / 8) : ℝ) := hn
          exact Real.sqrt_pos.mpr h6
        nlinarith [h5]
      exact (one_div_le_one_div h3 h4).mpr h2
    have hinv : (1 / 2 : ℝ) * ((Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ)) =
        1 / (2 * Real.sqrt (Nat.floor (13 * t / 8))) := by
      rw [S4W.hpow1 hn]
      have h1 : Real.sqrt (Nat.floor (13 * t / 8)) ≠ 0 := by positivity
      field_simp [h1]
      <;> ring
    have hX : 0 <= (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) *
        ((Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ)) := by
      have h1 : (0 : ℝ) <= ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ := by positivity
      have h2 : (0 : ℝ) < 12 := by norm_num
      have h3 : (0 : ℝ) <= ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12 :=
        mul_nonneg h1 (show (0 : ℝ) <= (12 : ℝ)⁻¹ from by norm_num)
      have h4 : (0 : ℝ) < (Nat.floor (13 * t / 8) : ℝ) ^ (-3 / 2 : ℝ) :=
        Real.rpow_pos_of_pos (by nlinarith [hn]) (-3 / 2)
      nlinarith [h3, h4]
    have hY : 0 <= (Real.sqrt 3 / 540) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
        ((Nat.floor (13 * t / 8) : ℝ) ^ (-5 / 2 : ℝ)) := by
      have h1 : (0 : ℝ) <= Real.sqrt 3 / 540 := by positivity
      have h2 : 0 <= ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ := by
        positivity
      have h3 : (0 : ℝ) < (Nat.floor (13 * t / 8) : ℝ) ^ (-5 / 2 : ℝ) :=
        Real.rpow_pos_of_pos (by nlinarith [hn]) (-5 / 2)
      exact mul_nonneg (mul_nonneg h1 h2) (le_of_lt h3)
    have htail : (1 / 2 : ℝ) * ((Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ)) <=
        p8_B t (Nat.floor (13 * t / 8)) := by
      dsimp only [p8_B]
      nlinarith [hX, hY]
    have hbeat : (31 / 100000 : ℝ) / t ^ 2 < 1 / 2 / Real.sqrt (13 * t / 8) :=
      nearTailBelowScale ht
    calc S1LowT.floStripMin t d
        < (31 / 100000 : ℝ) / t ^ 2 := hfloor
      _ < 1 / 2 / Real.sqrt (13 * t / 8) := hbeat
      _ = 1 / (2 * Real.sqrt (13 * t / 8)) := by
          field_simp [show Real.sqrt (13 * t / 8) ≠ 0 from by positivity]
          <;> ring
      _ <= 1 / (2 * Real.sqrt (Nat.floor (13 * t / 8))) := hsq
      _ = (1 / 2 : ℝ) * ((Nat.floor (13 * t / 8) : ℝ) ^ (-1 / 2 : ℝ)) := by
          rw [hinv.symm]
      _ <= p8_B t (Nat.floor (13 * t / 8)) := htail
  · -- far branch: BwireR = p8_B t ⌊t²⌋
    have hb : S4A.BwireR t d = p8_B t (S4G.nGrow t) := by
      dsimp only [S4A.BwireR]
      rw [if_pos ⟨ht, hdH⟩, if_neg hnotwin, if_neg ht0]
    rw [hb]
    have hT : (110000 : ℝ) < t := by
      by_contra h
      have h1 : t <= 110000 := by linarith [h]
      have h2 : t <= S4W.T0 := by
        have h3 : (S4W.T0 : ℝ) = 110000 := by rfl
        simpa [h3] using h1
      exact ht0 h2
    have hTg : S4G.T0 < t := by
      have h1 : (S4G.T0 : ℝ) = 110000 := by rfl
      simpa [h1] using hT
    have hn : (0 : ℝ) < (S4G.nGrow t : ℝ) := S4G.hFloorPos t (le_of_lt hTg)
    have hinv : (1 / 2 : ℝ) * ((S4G.nGrow t : ℝ) ^ (-1 / 2 : ℝ)) =
        1 / (2 * Real.sqrt (S4G.nGrow t)) := by
      rw [S4W.hpow1 hn]
      have h1 : Real.sqrt (S4G.nGrow t) ≠ 0 := by positivity
      field_simp [h1]
      <;> ring
    have hsur : Real.sqrt (t * t) = t := by
      have h1 : (0 : ℝ) <= t := by nlinarith [ht]
      have h2 : Real.sqrt (t * t) = Real.sqrt (t ^ 2) := by
        rw [show (t : ℝ) * t = t ^ 2 from by ring]
      rw [h2, Real.sqrt_sq h1]
    have hsq : 1 / (2 * t) <= 1 / (2 * Real.sqrt (S4G.nGrow t)) := by
      have h1 : (Nat.floor (t * t) : ℝ) <= t * t :=
        Nat.floor_le (by nlinarith [ht, hT, show (0 : ℝ) <= t * t from by positivity])
      have h2 : Real.sqrt (S4G.nGrow t) <= t := by
        calc Real.sqrt (S4G.nGrow t) <= Real.sqrt (t * t) :=
            Real.sqrt_le_sqrt h1
          _ = t := hsur
      have h3 : (0 : ℝ) < (2 : ℝ) * t := by nlinarith [ht]
      have h4 : (0 : ℝ) < (2 : ℝ) * Real.sqrt (S4G.nGrow t) := by
        have h5 : (0 : ℝ) < Real.sqrt (S4G.nGrow t) := Real.sqrt_pos.mpr hn
        nlinarith [h5]
      have h5 : (2 : ℝ) * Real.sqrt (S4G.nGrow t) <= (2 : ℝ) * t :=
        mul_le_mul_of_nonneg_left h2 (by norm_num)
      exact (one_div_le_one_div h3 h4).mpr h5
    have hX : 0 <= (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) *
        ((S4G.nGrow t : ℝ) ^ (-3 / 2 : ℝ)) := by
      have h1 : (0 : ℝ) <= ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ := by positivity
      have h3 : (0 : ℝ) <= ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12 :=
        mul_nonneg h1 (show (0 : ℝ) <= (12 : ℝ)⁻¹ from by norm_num)
      have h4 : (0 : ℝ) < (S4G.nGrow t : ℝ) ^ (-3 / 2 : ℝ) :=
        Real.rpow_pos_of_pos (by nlinarith [hn]) (-3 / 2)
      nlinarith [h3, h4]
    have hY : 0 <= (Real.sqrt 3 / 540) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
        ((S4G.nGrow t : ℝ) ^ (-5 / 2 : ℝ)) := by
      have h1 : (0 : ℝ) <= Real.sqrt 3 / 540 := by positivity
      have h2 : 0 <= ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ := by
        positivity
      have h3 : (0 : ℝ) < (S4G.nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
        Real.rpow_pos_of_pos (by nlinarith [hn]) (-5 / 2)
      exact mul_nonneg (mul_nonneg h1 h2) (le_of_lt h3)
    have htail : (1 / 2 : ℝ) * ((S4G.nGrow t : ℝ) ^ (-1 / 2 : ℝ)) <=
        p8_B t (S4G.nGrow t) := by
      dsimp only [p8_B]
      nlinarith [hX, hY]
    have hbeat : (31 / 100000 : ℝ) / t ^ 2 < 1 / (2 * t) :=
      farTailBelowScale ht ht0
    calc S1LowT.floStripMin t d
        < (31 / 100000 : ℝ) / t ^ 2 := hfloor
      _ < 1 / (2 * t) := hbeat
      _ <= 1 / (2 * Real.sqrt (S4G.nGrow t)) := hsq
      _ = (1 / 2 : ℝ) * ((S4G.nGrow t : ℝ) ^ (-1 / 2 : ℝ)) := by
          rw [hinv.symm]
      _ <= p8_B t (S4G.nGrow t) := htail

/- — (3) — the face identity — -/

/-- The hWin face of RHEnd.rh_program78, restated verbatim with the
    Z78P12 wire aliases (Z78P12.BwireP/MrP/MfP are thin aliases of
    S4A.BwireR/MrR/MfR: RHEnd's own S4 leg bridges them by the same
    simpa). -/
def hWinFace (q : ZeroSet) : Prop :=
    ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 < (1 / 200 : ℝ) →
      offPair q t0 d0 →
      Z78P12.BwireP (t0, d0) + Z78P12.MrP (t0, d0) +
        Z78P12.MfP (t0, d0) < S1LowT.floStripMin t0 d0

/-- Xgrow t > 0 for t > T0: every factor is positive — Bf(t, t²)
    (three positive terms; (t²+1/4)/(t⁴+1/4) < 1 for t > 1),
    Sbar(2t²) + Sbar(t²) (S4W.hLn27: ln(t²) >= 3 on t > 110000, so
    Sbar > 0.33 + 2.29 > 0), Cf(t, t²) (t⁴ − t² > 0), Kbar(t²)
    (numerator positive by the same ln-pin, denominator > 0). -/
theorem hXgrowPos (t : ℝ) (htT : ¬ t <= S4W.T0) : 0 < S4G.Xgrow t := by
  dsimp only [S4G.Xgrow, S4G.Ggrow, S4G.Bgrow]
  have hT : (110000 : ℝ) < t := by
    by_contra h
    have h1 : t <= 110000 := by linarith [h]
    have h2 : t <= S4W.T0 := by
      have h3 : (S4W.T0 : ℝ) = 110000 := by rfl
      simpa [h3] using h1
    exact htT h2
  have h27 : (27 : ℝ) <= t * t := by
    have h1 : (110000 : ℝ) * 110000 <= (110000 : ℝ) * t :=
      mul_le_mul_of_nonneg_left (le_of_lt hT) (by norm_num)
    have h2 : (110000 : ℝ) * t <= t * t :=
      mul_le_mul_of_nonneg_right (le_of_lt hT) (by nlinarith [hT])
    have h3 : (27 : ℝ) < (110000 : ℝ) * 110000 := by norm_num
    nlinarith [h1, h2, h3]
  have hln : (3 : ℝ) <= Real.log (t * t) := S4W.hLn27 (t * t) h27
  have hlnln : (0 : ℝ) <= Real.log (Real.log (t * t)) := by
    have h1 : (1 : ℝ) <= Real.log (t * t) := by nlinarith [hln]
    exact Real.log_nonneg (by nlinarith [h1])
  have hBf : (0 : ℝ) < Bf t (t * t) := by
    dsimp only [Bf, w]
    have h1 : (0 : ℝ) < (t * t : ℝ) * (t * t) + 1 / 4 := by positivity
    have h2 : (0 : ℝ) < (t * t + 1 / 4 : ℝ) := by positivity
    have h3 : (0 : ℝ) < (t * t + 1 / 4 : ℝ) / ((t * t) * (t * t) + 1 / 4) :=
      div_pos h2 h1
    have h4 : (1 : ℝ) < t * t := by
      have h5 : (1 : ℝ) < t := by nlinarith [hT, show (1 : ℝ) < 110000 from by norm_num]
      have h6 : (0 : ℝ) < t := by nlinarith [h5]
      have h7 : (1 : ℝ) * t < t * t := mul_lt_mul_of_pos_right h5 (by nlinarith [h6])
      nlinarith [h7, show (1 : ℝ) * t = t from by ring]
    have h5 : (t * t : ℝ) < (t * t) * (t * t) := by
      have h6 : (0 : ℝ) < t * t := by nlinarith [h4]
      have h7 : (t * t : ℝ) * 1 < (t * t) * (t * t) := mul_lt_mul_of_pos_left h4 h6
      have h8 : (t * t : ℝ) = (t * t) * 1 := by ring
      rw [h8.symm] at h7
      exact h7
    have h6 : (t * t + 1 / 4 : ℝ) / ((t * t) * (t * t) + 1 / 4) < 1 :=
      (div_lt_one (by positivity)).mpr (by nlinarith [h5])
    have h7 : (0 : ℝ) < (1 : ℝ) -
        (t * t + 1 / 4) / ((t * t) * (t * t) + 1 / 4) := sub_pos.mpr h6
    have h8 : (0 : ℝ) < 1 / (2 * ((t * t : ℝ) * (t * t) + 1 / 4)) := by positivity
    have h9 : (0 : ℝ) < (t * t + 1 / 4 : ℝ) / ((t * t) * (t * t) + 1 / 4) /
        (1 - (t * t + 1 / 4) / ((t * t) * (t * t) + 1 / 4)) := div_pos h3 h7
    have h10 : (0 : ℝ) < t / ((t * t : ℝ) * (t * t) + 1 / 4) := by positivity
    exact add_pos (add_pos h8 h9) h10
  have hSb1 : (0 : ℝ) < Sbar (t * t) := by
    dsimp only [Sbar]
    have h1 : (0.33 : ℝ) <= 0.110 * Real.log (t * t) := by
      have h2 : (3 : ℝ) <= Real.log (t * t) := hln
      nlinarith [show (0.110 : ℝ) * 3 = 0.33 from by norm_num, h2,
        show (0 : ℝ) < 0.110 from by norm_num]
    have h2 : (0 : ℝ) <= 0.290 * Real.log (Real.log (t * t)) :=
      mul_nonneg (show (0 : ℝ) <= 0.290 from by norm_num) hlnln
    nlinarith [h1, h2, show (0 : ℝ) < 2.290 from by norm_num]
  have hSb2 : (0 : ℝ) < Sbar (2 * t * t) := by
    dsimp only [Sbar]
    have h1 : (27 : ℝ) <= 2 * (t * t) := by nlinarith [h27, show (0 : ℝ) <= t * t from by positivity]
    have h1b : (27 : ℝ) <= 2 * t * t := by
      have h1c : (2 * t * t : ℝ) = 2 * (t * t) := by ring
      simpa [h1c] using h1
    have h2 : (3 : ℝ) <= Real.log (2 * t * t) := S4W.hLn27 (2 * t * t) h1b
    have h3 : (0 : ℝ) <= Real.log (Real.log (2 * t * t)) := by
      have h4 : (1 : ℝ) <= Real.log (2 * t * t) := by nlinarith [h2]
      exact Real.log_nonneg (by nlinarith [h4])
    have h4 : (0.33 : ℝ) <= 0.110 * Real.log (2 * t * t) := by
      nlinarith [show (0.110 : ℝ) * 3 = 0.33 from by norm_num, h2,
        show (0 : ℝ) < 0.110 from by norm_num]
    have h5 : (0 : ℝ) <= 0.290 * Real.log (Real.log (2 * t * t)) :=
      mul_nonneg (show (0 : ℝ) <= 0.290 from by norm_num) h3
    nlinarith [h4, h5, show (0 : ℝ) < 2.290 from by norm_num]
  have hCf : (0 : ℝ) < Cf t (t * t) := by
    dsimp only [Cf, w]
    have h1 : (0 : ℝ) < (t * t : ℝ) * (t * t) - t * t := by
      have h2 : (1 : ℝ) < t * t := by
        have h3 : (1 : ℝ) < t := by nlinarith [hT, show (1 : ℝ) < 110000 from by norm_num]
        have h4 : (0 : ℝ) < t := by nlinarith [h3]
        have h5 : (1 : ℝ) * t < t * t := mul_lt_mul_of_pos_right h3 (by nlinarith [h4])
        nlinarith [h5, show (1 : ℝ) * t = t from by ring]
      have h3 : (0 : ℝ) < t * t := by nlinarith [h2]
      have h4 : (t * t : ℝ) * 1 < (t * t) * (t * t) :=
        mul_lt_mul_of_pos_left h2 (by nlinarith [h3])
      nlinarith [h4, show (t * t : ℝ) * 1 = t * t from by ring]
    have h2 : (0 : ℝ) < (2 * (t * t + 1 / 4) * ((t * t) * (t * t)) : ℝ) := by positivity
    have h3 : (0 : ℝ) < (2 * (t * t + 1 / 4) * ((t * t) * (t * t)) : ℝ) /
        ((t * t) * (t * t) - t * t) := div_pos h2 h1
    nlinarith [show 1 + (2 * (t * t + 1 / 4) * ((t * t) * (t * t)) : ℝ) /
        ((t * t) * (t * t) - t * t) > 1 by
        nlinarith [h3, show (2 * (t * t + 1 / 4) * ((t * t) * (t * t)) : ℝ) /
          ((t * t) * (t * t) - t * t) > 0 from h3]]
  have hKb : (0 : ℝ) < Kbar (t * t) := by
    dsimp only [Kbar]
    have h1 : (0 : ℝ) < Real.log (t * t) + 1 / 2 := by nlinarith [hln]
    have h2 : (0 : ℝ) < 0.110 := by norm_num
    have h3 : (0 : ℝ) < 0.110 * (Real.log (t * t) + 1 / 2) := mul_pos h2 h1
    have h4 : (0 : ℝ) < Real.log (Real.log (t * t)) + 1 / 2 := by nlinarith [hlnln]
    have h5 : (0 : ℝ) <= 0.290 := by norm_num
    have h6 : (0 : ℝ) <= 0.290 * (Real.log (Real.log (t * t)) + 1 / 2) :=
      mul_nonneg h5 (le_of_lt h4)
    have h7 : (2.290 : ℝ) > 0 := by norm_num
    have h8 : (0 : ℝ) < 0.110 * (Real.log (t * t) + 1 / 2) +
        0.290 * (Real.log (Real.log (t * t)) + 1 / 2) + 2.290 := by
      nlinarith [h3, h6, h7]
    have h9 : (0 : ℝ) < (2 : ℝ) * (t * t) * (t * t) := by positivity
    exact div_pos h8 h9
  have h1 : (0 : ℝ) < Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) :=
    mul_pos hBf (add_pos hSb2 hSb1)
  have h2 : (0 : ℝ) < Cf t (t * t) * Kbar (t * t) := mul_pos hCf hKb
  exact add_pos h1 h2

/-- THE FACE IDENTITY (direction 1): any zero set whose hWin face
    holds has NO off-line zeros in the band [1000, ∞) x (0, 1/200).
    The squeeze instrument is certified NOT to reach the band: the
    floor there is strictly below a single wire term, while the
    residue term Mr is nonnegative and Mf is 0. -/
theorem hwinFaceImpliesZeroExclusion (q : ZeroSet) (hWin : hWinFace q) :
    ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 < (1 / 200 : ℝ) →
      ¬ offPair q t0 d0 := by
  intro t0 d0 ht0 hd0 hdw hz
  have hwire : S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) <
      S1LowT.floStripMin t0 d0 := by
    simpa [Z78P12.BwireP, Z78P12.MrP, Z78P12.MfP] using hWin t0 d0 ht0 hd0 hdw hz
  have hfloor : S1LowT.floStripMin t0 d0 < S4A.BwireR t0 d0 :=
    floorBelowWire ht0 hd0 hdw
  have hMf : S4A.MfR (t0, d0) = 0 := rfl
  have hdH : d0 <= 1 / 2 := by
    nlinarith [hdw, show (1 / 200 : ℝ) < 1 / 2 from by norm_num]
  have hMrgen : (0 : ℝ) <= S4A.MrR t0 d0 := by
    dsimp only [S4A.MrR]
    rw [if_pos ⟨ht0, hdH⟩]
    have hnotwin : ¬ (1 / 200 <= d0) := by
      intro h
      nlinarith [hdw, h]
    simp only [if_neg hnotwin]
    by_cases htT : t0 <= S4W.T0
    · rw [if_pos htT]
      have hz : (0 : ℝ) < S4W.Zbound t0 := by
        dsimp only [S4W.Zbound]
        have h1 : (1 : ℝ) < t0 := by nlinarith [ht0]
        have h2 : (0 : ℝ) < t0 ^ (1 / 4 : ℝ) :=
          Real.rpow_pos_of_pos (by nlinarith [ht0]) (1 / 4)
        have h3 : (0 : ℝ) < Real.log t0 :=
          Real.log_pos (by nlinarith [h1])
        have h4 : (0 : ℝ) < 1.6 := by norm_num
        positivity
      have hx : (0 : ℝ) <= S4W.Xwire t0 := S4W.hXwire_pos t0 (by nlinarith [ht0]) htT
      have he : (0 : ℝ) < Real.exp (S4W.Xwire t0) := Real.exp_pos _
      have h1 : (0 : ℝ) < S4W.Zbound t0 * Real.exp (S4W.Xwire t0) := mul_pos hz he
      exact mul_nonneg h1.le hx
    · rw [if_neg htT]
      have hx : (0 : ℝ) < S4G.Xgrow t0 := hXgrowPos t0 htT
      have hz : (0 : ℝ) < S4W.Zbound t0 := by
        dsimp only [S4W.Zbound]
        have h1 : (1 : ℝ) < t0 := by nlinarith [ht0]
        have h2 : (0 : ℝ) < t0 ^ (1 / 4 : ℝ) :=
          Real.rpow_pos_of_pos (by nlinarith [ht0]) (1 / 4)
        have h3 : (0 : ℝ) < Real.log t0 :=
          Real.log_pos (by nlinarith [h1])
        have h4 : (0 : ℝ) < 1.6 := by norm_num
        positivity
      have he : (0 : ℝ) < Real.exp (S4G.Xgrow t0) := Real.exp_pos _
      have h1 : (0 : ℝ) < S4W.Zbound t0 * Real.exp (S4G.Xgrow t0) := mul_pos hz he
      exact mul_nonneg h1.le hx.le
  have hsum : S4A.BwireR t0 d0 <=
      S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) := by
    linarith [hMrgen, hMf]
  have hcontra : S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) <
      S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) := by
    calc S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0)
        < S1LowT.floStripMin t0 d0 := hwire
      _ < S4A.BwireR t0 d0 := hfloor
      _ <= S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) := hsum
  exact lt_irrefl _ hcontra

/-- THE FACE IDENTITY (direction 2, vacuous): a zero set with no
    off-line zeros in the band satisfies the hWin face. -/
theorem zeroExclusionImpliesFace (q : ZeroSet)
    (hnz : ∀ (t0 d0 : ℝ), 1000 ≤ t0 → 0 < d0 → d0 < (1 / 200 : ℝ) →
        ¬ offPair q t0 d0) :
    hWinFace q := by
  intro t0 d0 ht0 hd0 hdw hz
  exact False.elim (hnz t0 d0 ht0 hd0 hdw hz)

end S4WC
