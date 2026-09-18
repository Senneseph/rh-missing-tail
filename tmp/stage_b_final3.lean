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
    · positivity
    · nlinarith [ht]
  have hG : (1 / (2 * t)) * (1 / Xfloor) ≤ (1 / (2 * T0)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_right hF (one_div_nonneg.2 (mul_self_nonneg Xfloor))
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
    mul_le_mul_of_nonneg_right hxi_inv (by positivity)
  have hsplit : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
      (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := by
    field_simp [htpos.ne']
    ring
  have hsumub : 1 / (t * t) + 1 / (2 * t * t * t) ≤
      1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0)) := by
    have h2 : 1 / (2 * t * t * t) = (1 / 2) * (1 / (t * t * t)) := by
      field_simp [htpos.ne']
      ring
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
    ring
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
      (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left (hS3norm t htnn)
      (mul_nonneg
        (div_nonneg (Real.sqrt_nonneg 3) (by norm_num))
        (Real.rpow_nonneg hnpos.le (-5 / 2)))
  have hstep1 : (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hsqrt3d
      (mul_nonneg (pow_nonneg (by nlinarith [htnn]) 3)
        (Real.rpow_nonneg hnpos.le (-5 / 2)))
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
        (pow_nonneg (by nlinarith [htnn]) 3))
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
      rw [h4, h2, h3]
    rw [h1]
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
          (pow_nonneg (by nlinarith [htnn]) 3))
    exact mul_le_mul_of_nonneg_right h3c (Real.rpow_nonneg hXpos.le (-5 / 2))
  have hstep4 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_right hxi_inv
      (mul_nonneg
        (mul_nonneg (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
          (pow_nonneg (by nlinarith [htnn]) 3))
        (one_div_nonneg.2 (mul_self_nonneg t)))
  have htp1 : (t + 3) ^ 3 / (t * t * t * t * t) ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
    have h1 : (t + 3) / t = 1 + 3 / t := by
      field_simp [htpos.ne']
      ring
    have h2 : 1 / t ≤ 1 / T0 := by
      apply one_div_le_one_div_of_le
      · exact hSGT0pos
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
      exact mul_le_mul_of_nonneg_left h5 (by positivity)
    calc (t + 3) ^ 3 / (t * t * t * t * t)
        = ((t + 3) / t) ^ 3 / (t * t) := h6
      _ ≤ ((t + 3) / t) ^ 3 / (T0 * T0) := h8
      _ ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := h9
  have htp1eq : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
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
      (mul_nonneg (by norm_num : (0 : ℝ) ≤ (17321 / 10000) / 540)
        (one_div_nonneg.2 (mul_self_nonneg Xfloor)))
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
