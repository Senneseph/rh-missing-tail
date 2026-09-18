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
  simp

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
  simp

/- — Shared one-shot facts for t ≥ T0 — -/

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

/-- 1 ≤ ln t (t ≥ 3, e ≤ 3 by S4W.hE3). -/
theorem hSGtlog1 : 1 ≤ log t := by
  have h1 : (3 : ℝ) ≤ t := by nlinarith [hT0val, ht]
  have h2 : Real.exp 1 ≤ 3 := S4W.hE3
  have h3 : 1 ≤ Real.log 3 := by
    have h4 : Real.log (Real.exp 1) ≤ Real.log 3 :=
      Real.log_le_log (by positivity) h2
    rw [Real.log_exp] at h4
    exact h4
  have h4 : Real.log 3 ≤ Real.log t := Real.log_le_log (by norm_num) h1
  linarith

/-- 0 < t²·Xfloor and √(t²·Xfloor) = t·√Xfloor. -/
theorem hSGfact : 0 < t * t * Xfloor ∧ Real.sqrt (t * t * Xfloor) = t * Real.sqrt Xfloor := by
  have hXpos : 0 < Xfloor := (hXrange).1
  have htpos := hSGtp ht
  constructor
  · nlinarith [htpos, hXpos]
  · have h1 : Real.sqrt (t * t * Xfloor) = Real.sqrt (t * t) * Real.sqrt Xfloor :=
      Real.sqrt_mul (by nlinarith [hT0val, ht]) hXpos.le
    have h2 : Real.sqrt (t * t) = t := by
      rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq (hSGtnn ht)]
    rw [h1, h2]

/-- T0³ ≤ t³. -/
theorem hSGtsq3 : T0 * T0 * T0 ≤ t * t * t := by
  have h2 : T0 * T0 ≤ t * t := hSGtsq ht
  have h3 : 0 ≤ t := hSGtnn ht
  nlinarith [h2, htpos]

/-- 0 < T0. -/
theorem hSGT0pos : 0 < T0 := by
  nlinarith [hT0val]

end

/-- √3 ≤ 17321/10000. -/
theorem hSqrt3 : Real.sqrt 3 ≤ 17321 / 10000 := by
  have h1 : (Real.sqrt 3) ^ 2 = 3 := by rw [Real.sq_sqrt (by norm_num : 0 ≤ 3)]
  have h2 : 3 ≤ (17321 / 10000 : ℝ) ^ 2 := by norm_num
  exact le_of_sq_le_sq (by nlinarith [h1, h2]) (by norm_num)

/-- Stage B term 1: (1/2)·n^{−1/2} ≤ CG11 for t ≥ T0. -/
theorem hCG11 (t : ℝ) (ht : T0 ≤ t) :
    (1 / 2) * (nGrow t : ℝ) ^ (-1 / 2 : ℝ) ≤ CG11 := by
  have hnpos : 0 < (nGrow t : ℝ) := hFloorPos t ht
  have hbase : t * t * Xfloor ≤ (nGrow t : ℝ) := hFloorBase t ht
  have hfact := hSGfact ht
  have hA : (nGrow t : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt (nGrow t : ℝ) := by
    rw [Real.rpow_neg hnpos.le (1 / 2),
        show (nGrow t : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (nGrow t : ℝ) from
          (Real.sqrt_eq_rpow (nGrow t : ℝ)).symm]
  have hB : (t * t * Xfloor) ^ (-1 / 2 : ℝ) = 1 / (t * Real.sqrt Xfloor) := by
    rw [Real.rpow_neg (hSGfact ht |>.1).le (1 / 2),
        show (t * t * Xfloor) ^ (1 / 2 : ℝ) = Real.sqrt (t * t * Xfloor) from
          (Real.sqrt_eq_rpow (t * t * Xfloor)).symm,
        hfact.2]
  have hdec : (nGrow t : ℝ) ^ (-1 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-1 / 2 : ℝ) := by
    rw [hA, hB]
    have hf2 : t * Real.sqrt Xfloor = Real.sqrt (t * t * Xfloor) := hfact.2.symm
    apply one_div_le_one_div_of_le (by positivity)
    simpa [hf2] using Real.sqrt_le_sqrt hbase
  have hC : (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) =
      (1 / (2 * t)) * (1 / Real.sqrt Xfloor) := by
    rw [hB]
    field_simp
  have hD : 1 / Real.sqrt Xfloor ≤ 1 / Xfloor :=
    one_div_le_one_div_of_le (by positivity) hXfsq
  have hE : (1 / (2 * t)) * (1 / Real.sqrt Xfloor) ≤ (1 / (2 * t)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_left hD (by positivity)
  have hF : 1 / (2 * t) ≤ 1 / (2 * T0) := by
    apply one_div_le_one_div_of_le (by positivity)
    nlinarith [hSGT0pos]
  have hG : (1 / (2 * t)) * (1 / Xfloor) ≤ (1 / (2 * T0)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_left hF (by positivity)
  calc (1 / 2) * (nGrow t : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hdec (by norm_num)
    _ = (1 / (2 * t)) * (1 / Real.sqrt Xfloor) := by
      symmetry
      exact hC
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
  have htnn := hSGtnn ht
  have htpos := hSGtp ht
  have htsq3 := hSGtsq3 ht
  have hXpos : 0 < Xfloor := (hXrange).1
  rw [hNorm t]
  have hnormb : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := hSbnd t htnn
  have hdec : (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-3 / 2 : ℝ) := by
    rw [Real.rpow_neg hnpos.le (3 / 2),
        Real.rpow_neg (hSGfact ht |>.1).le (3 / 2)]
    apply one_div_le_one_div_of_le (by positivity)
    exact Real.rpow_le_rpow hbase (by positivity) (by norm_num)
  have hstep1 : (Real.sqrt (1 / 4 + t * t) / 12) *
      (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_right (div_le_div_right' hnormb 12)
      (Real.rpow_nonneg hnpos.le (-3 / 2))
  have hstep2 : ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hdec
      (Real.rpow_nonneg hnpos.le (-3 / 2))
  have hmulr : (t * t * Xfloor) ^ (-3 / 2 : ℝ) =
      (t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ) := by
    rw [Real.mul_rpow (mul_self_nonneg t) hXpos.le]
  have htpow3 : (t * t) ^ (-3 / 2 : ℝ) = 1 / (t * t * t) := by
    rw [Real.rpow_neg (by positivity) (3 / 2)]
    have h1 : (t * t) ^ (3 / 2 : ℝ) = t * t * t := by
      rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
          Real.rpow_add (by positivity) 1 (1 / 2)]
      have h2 : (t * t) ^ (1 / 2 : ℝ) = Real.sqrt (t * t) := by
        rw [Real.sqrt_eq_rpow (t * t)]
      have h3 : Real.sqrt (t * t) = t := by
        rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq htnn]
      rw [h2, h3, Real.rpow_one]
      ring
    rw [h1]
    simp
  have hx32 : Xfloor * Real.sqrt Xfloor = Xfloor ^ (3 / 2 : ℝ) := by
    rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
        Real.rpow_add hXpos 1 (1 / 2), Real.rpow_one]
    have h3 : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
      rw [Real.sqrt_eq_rpow Xfloor]
    rw [h3]
    ring
  have hxi_inv : Xfloor ^ (-3 / 2 : ℝ) ≤ Xfloor ^ (-2 : ℝ) := by
    rw [Real.rpow_neg hXpos.le (3 / 2), hXinv2]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor ≤ Xfloor * Real.sqrt Xfloor :=
      mul_le_mul_of_nonneg_left hXfsq (by positivity)
    simpa [hx32, pow_two] using h1
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
    exact mul_le_mul_of_nonneg_left h3c
      (Real.rpow_nonneg hXpos.le (-3 / 2))
  have hstep4 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) :=
    mul_le_mul_of_nonneg_left hxi_inv (by positivity)
  have hsplit : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
      (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := by
    field_simp [htpos.ne']
    ring
  have hinv2 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
    apply one_div_le_one_div_of_le
    · nlinarith [hSGT0pos]
    · exact hSGtsq ht
  have hinv3 : 1 / (t * t * t) ≤ 1 / (T0 * T0 * T0) := by
    apply one_div_le_one_div_of_le
    · nlinarith [hSGT0pos]
    · exact htsq3
  have hstep5 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) ≤
      (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * Xfloor ^ (-2 : ℝ) := by
    have h1 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
        (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := hsplit
    have h2 : 1 / (2 * t * t * t) = (1 / 2) * (1 / (t * t * t)) := by
      field_simp [htpos.ne']
      ring
    have h3 : (1 / 2) * (1 / (t * t * t)) ≤ (1 / 2) * (1 / (T0 * T0 * T0)) :=
      mul_le_mul_of_nonneg_left hinv3 (by norm_num)
    have h4 : 1 / (t * t) + 1 / (2 * t * t * t) ≤
        1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0)) := by
      simpa [h2] using add_le_add hinv2 h3
    have h5 : (1 / (t * t) + 1 / (2 * t * t * t)) / 12 ≤
        (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 :=
      (div_le_div_right' h4 12)
    have h6 : (((1 / (t * t) + 1 / (2 * t * t * t)) / 12) * Xfloor ^ (-2 : ℝ)) ≤
        (((1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12) * Xfloor ^ (-2 : ℝ)) :=
      mul_le_mul_of_nonneg_left h5 (Real.rpow_nonneg hXpos.le (-2))
    simpa [h1] using h6
  calc (Real.sqrt (1 / 4 + t * t) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ)
      ≤ ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) := hstep1
    _ ≤ ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) := hstep2
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) := hstep3
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) := hstep4
    _ = (1 / (t * t) + 1 / (2 * t * t * t)) / 12 * Xfloor ^ (-2 : ℝ) := by
      rw [show ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
        (1 / (t * t) + 1 / (2 * t * t * t)) / 12 from hsplit]
      ring
    _ ≤ (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * Xfloor ^ (-2 : ℝ) :=
      mul_le_mul_of_nonneg_left
        (div_le_div_right'
          (show 1 / (t * t) + 1 / (2 * t * t * t) ≤
              1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0)) from
            (by
              have h2 : 1 / (2 * t * t * t) = (1 / 2) * (1 / (t * t * t)) := by
                field_simp [htpos.ne']
                ring
              have h3 : (1 / 2) * (1 / (t * t * t)) ≤ (1 / 2) * (1 / (T0 * T0 * T0)) :=
                mul_le_mul_of_nonneg_left
                  (by
                    apply one_div_le_one_div_of_le
                    · nlinarith [hSGT0pos]
                    · exact htsq3) (by norm_num))
              simpa [h2] using add_le_add
                (by
                  apply one_div_le_one_div_of_le
                  · nlinarith [hSGT0pos]
                  · exact hSGtsq ht) h3) 12)
        (Real.rpow_nonneg hXpos.le (-2))
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
  have hXpos : 0 < Xfloor := (hXrange).1
  have hsqrt3 : Real.sqrt 3 / 540 ≤ (17321 / 10000) / 540 :=
    div_le_div_right' hSqrt3 540
  have hdec : (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-5 / 2 : ℝ) := by
    rw [Real.rpow_neg hnpos.le (5 / 2),
        Real.rpow_neg (hSGfact ht |>.1).le (5 / 2)]
    apply one_div_le_one_div_of_le (by positivity)
    exact Real.rpow_le_rpow hbase (by positivity) (by norm_num)
  have hstep0 : (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left (hS3norm t htnn)
      (Real.rpow_nonneg hnpos.le (-5 / 2))
  have hstep1 : (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hsqrt3
      (Real.rpow_nonneg hnpos.le (-5 / 2))
  have hstep2 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hdec
      (mul_nonneg (by norm_num) (pow_nonneg (mul_self_nonneg (t + 3)) 3))
  have hmulr : (t * t * Xfloor) ^ (-5 / 2 : ℝ) =
      (t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ) := by
    rw [Real.mul_rpow (mul_self_nonneg t) hXpos.le]
  have htpow5 : (t * t) ^ (-5 / 2 : ℝ) = 1 / (t * t * t * t * t) := by
    rw [Real.rpow_neg (by positivity) (5 / 2)]
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
      rw [h4, h2, h3, Real.rpow_one]
      ring
    rw [h1]
    simp
  have hx52 : Xfloor * Xfloor * Real.sqrt Xfloor = Xfloor ^ (5 / 2 : ℝ) := by
    rw [show (5 / 2 : ℝ) = 2 + 1 / 2 from by norm_num,
        Real.rpow_add hXpos 2 (1 / 2)]
    have h2a : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
      rw [Real.sqrt_eq_rpow Xfloor]
    have h2b : Xfloor ^ (2 : ℝ) = Xfloor * Xfloor := by
      rw [show (2 : ℝ) = 1 + 1 from by norm_num,
          Real.rpow_add hXpos 1 1, Real.rpow_one]
    rw [h2a, h2b]
    ring
  have hxi_inv : Xfloor ^ (-5 / 2 : ℝ) ≤ Xfloor ^ (-3 : ℝ) := by
    rw [Real.rpow_neg hXpos.le (5 / 2), hXinv3]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor * Xfloor ≤ Xfloor * Xfloor * Real.sqrt Xfloor :=
      mul_le_mul_of_nonneg_left hXfsq (by positivity)
    simpa [hx52, pow_two] using h1
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
        (mul_nonneg (by norm_num) (pow_nonneg (mul_self_nonneg (t + 3)) 3))
    exact mul_le_mul_of_nonneg_left h3c
      (Real.rpow_nonneg hXpos.le (-5 / 2))
  have hstep4 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_left hxi_inv
      (mul_nonneg
        (mul_nonneg (by norm_num) (pow_nonneg (mul_self_nonneg (t + 3)) 3))
        (one_div_nonneg (mul_self_nonneg t)))
  have htp1 : (t + 3) ^ 3 / (t * t * t * t * t) ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
    have h1 : (t + 3) / t = 1 + 3 / t := by
      field_simp [htpos.ne']
      ring
    have hTpos : 0 < T0 := hSGT0pos
    have h2 : 1 / t ≤ 1 / T0 := by
      apply one_div_le_one_div_of_le
      · nlinarith [hTpos]
      · nlinarith [hT0val, ht]
    have h3 : 3 / t ≤ 3 / T0 :=
      simpa using mul_le_mul_of_nonneg_left h2 (by norm_num)
    have h4 : 1 + 3 / t ≤ 1 + 3 / T0 := add_le_add_right h3 1
    have h5 : ((t + 3) / t) ^ 3 ≤ (1 + 3 / T0) ^ 3 :=
      pow_le_pow_left₀ (by positivity) h4 3
    have h6 : (t + 3) ^ 3 / (t * t * t * t * t) = ((t + 3) / t) ^ 3 / (t * t) := by
      field_simp [htpos.ne']
      ring
    have h7 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
      apply one_div_le_one_div_of_le
      · nlinarith [hTpos]
      · exact hSGtsq ht
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
      exact mul_le_mul_of_nonneg_left h5 (by positivity)
    calc (t + 3) ^ 3 / (t * t * t * t * t)
        = ((t + 3) / t) ^ 3 / (t * t) := h6
      _ ≤ ((t + 3) / t) ^ 3 / (T0 * T0) := h8
      _ ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := h9
  have htp1' : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) =
      ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) := by
    field_simp [htpos.ne']
    ring
  have hstep6 : ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) ≤
      ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_left htp1
      (mul_nonneg (by norm_num) (Real.rpow_nonneg hXpos.le (-3)))
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
      rw [← htp1']
    _ ≤ ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
          Xfloor ^ (-3 : ℝ) := hstep6
    _ = ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
          (1 / (Xfloor * Xfloor * Xfloor)) := by
      rw [hXinv3]
    _ ≤ CG13 := by
      norm_num [Xfloor, CG13, hT0val]
