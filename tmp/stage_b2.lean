/- — Stage B: p8_B term bounds — -/

/-- The floor factor: n(t) ≥ t²·Xfloor for t ≥ T0 (hFloorBase). -/
noncomputable def Xfloor : ℝ := 1 - 1 / (T0 * T0)

/-- 0 < Xfloor < 1. -/
theorem hXrange : 0 < Xfloor ∧ Xfloor < 1 := by
  constructor
  · rw [Xfloor]
    have h1 : 1 / (T0 * T0) < 1 :=
      (div_lt_one (by positivity : 0 < T0 * T0)).2 (by nlinarith [hT0val])
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

/- — Shared one-shot facts for t ≥ T0 — -/

variable {t : ℝ} (ht : T0 ≤ t)

/-- 0 < t. -/
theorem hSGtp : 0 < t := by
  nlinarith [hT0val, ht]

/-- 0 ≤ t. -/
theorem hSGtnn : 0 ≤ t := (hSGtp ht).le

/-- T0² ≤ t². -/
theorem hSGtsq : T0 * T0 ≤ t * t := by
  nlinarith [hT0val, ht, mul_self_nonneg t]

/-- 1 ≤ ln t (t ≥ 3, e ≤ 3 by S4W.hE3, so t ≥ e and ln t ≥ 1). -/
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

/-- √(t²·Xfloor) = t·√Xfloor and 0 < t²·Xfloor. -/
theorem hSGfact : 0 < t * t * Xfloor ∧ Real.sqrt (t * t * Xfloor) = t * Real.sqrt Xfloor := by
  have hXpos : 0 < Xfloor := (hXrange).1
  have htpos := hSGtp ht
  constructor
  · positivity
  · have h1 : Real.sqrt (t * t * Xfloor) = Real.sqrt (t * t) * Real.sqrt Xfloor :=
      Real.sqrt_mul (by nlinarith [hT0val, ht]) hXpos.le
    have h2 : Real.sqrt (t * t) = t := by
      rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq (hSGtnn ht)]
    rw [h1, h2]

end

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
    nlinarith [ht]
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
  have htsq := hSGtsq ht
  have hXpos : 0 < Xfloor := (hXrange).1
  rw [hNorm t]
  have hdec : (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-3 / 2 : ℝ) := by
    rw [Real.rpow_neg hnpos.le (3 / 2),
        Real.rpow_neg (hSGfact ht |>.1).le (3 / 2)]
    apply one_div_le_one_div_of_le (by positivity)
    exact Real.rpow_le_rpow hbase (by positivity) (by norm_num)
  have hnormb : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := hSbnd t htnn
  have hstep1 : (Real.sqrt (1 / 4 + t * t) / 12) *
      (nGrow t : ℝ) ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_right
      (div_le_div_of_nonneg hnormb (by norm_num))
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
      rw [h2, h3]
      ring
    rw [h1]
    field_simp [htpos.ne']
  have hxi_inv : Xfloor ^ (-3 / 2 : ℝ) ≤ Xfloor ^ (-2 : ℝ) := by
    rw [Real.rpow_neg hXpos.le (3 / 2),
        show Xfloor ^ (-2 : ℝ) = 1 / (Xfloor * Xfloor) from by
          rw [Real.rpow_neg hXpos.le 2,
              show Xfloor ^ (2 : ℝ) = Xfloor * Xfloor from by
                rw [show (2 : ℝ) = 1 + 1 from by norm_num,
                    Real.rpow_add hXpos 1 1, Real.rpow_one]
                ring,
              pow_two]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor ≤ Xfloor * Real.sqrt Xfloor :=
      mul_le_mul_of_nonneg_left hXfsq (by positivity)
    have h2 : Xfloor * Real.sqrt Xfloor = Xfloor ^ (3 / 2 : ℝ) := by
      rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
          Real.rpow_add hXpos 1 (1 / 2), Real.rpow_one]
      have h3 : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
        rw [Real.sqrt_eq_rpow Xfloor]
      rw [h3]
      ring
    rw [h2] at h1
    simpa [pow_two] using h1
  have hstep3a : ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) =
      ((t + 1 / 2) / 12) * ((t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ)) := by
    rw [hmulr]
  have hstep3b : ((t + 1 / 2) / 12) * ((t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ)) ≤
      ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) := by
    have h1 : ((t + 1 / 2) / 12) * (t * t) ^ (-3 / 2 : ℝ) ≤
        ((t + 1 / 2) / 12) * (1 / (t * t * t)) :=
      mul_le_mul_of_nonneg_left htpow3.le (by positivity)
    have h2 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) =
        (((t + 1 / 2) / 12) * (1 / (t * t * t))) * Xfloor ^ (-3 / 2 : ℝ) := by ring
    rw [h2]
    exact (le_of_eq (by ring)).trans (mul_le_mul_of_nonneg_left h1 (by positivity))
  have hstep4 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) ≤
      ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) := by
    have h1 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) ≥ 0 := by positivity
    have h2 : (((t + 1 / 2) / 12) * (1 / (t * t * t))) * Xfloor ^ (-3 / 2 : ℝ) ≤
        (((t + 1 / 2) / 12) * (1 / (t * t * t))) * Xfloor ^ (-2 : ℝ) :=
      mul_le_mul_of_nonneg_left hxi_inv (by positivity)
    simpa [mul_assoc] using h2
  have hsplit : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
      (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := by
    field_simp [htpos.ne']
    ring
  have hinv2 : 1 / (t * t) ≤ 1 / (T0 * T0) := by
    apply one_div_le_one_div_of_le (by positivity)
    exact htsq
  have hinv3 : 1 / (t * t * t) ≤ 1 / (T0 * T0 * T0) := by
    have h1 : T0 * T0 * T0 ≤ t * t * t := by
      have h2 : T0 * T0 ≤ t * t := htsq
      have h3 : 0 ≤ T0 * T0 := by positivity
      have h4 : t * t ≥ 0 := by positivity
      nlinarith [h2, htpos.le]
    apply one_div_le_one_div_of_le (by positivity)
    exact h1
  have hstep5 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) ≤
      (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * Xfloor ^ (-2 : ℝ) := by
    have h1 : ((t + 1 / 2) / 12) * (1 / (t * t * t)) =
        (1 / (t * t) + 1 / (2 * t * t * t)) / 12 := hsplit
    have h2 : (1 / (t * t) + 1 / (2 * t * t * t)) / 12 ≤
        (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 := by
      have h3 : 1 / (2 * t * t * t) = (1 / 2) * (1 / (t * t * t)) := by
        field_simp [htpos.ne']
        ring
      have h4 : (1 / 2) * (1 / (t * t * t)) ≤ (1 / 2) * (1 / (T0 * T0 * T0)) :=
        mul_le_mul_of_nonneg_left hinv3 (by norm_num)
      have h5 : 1 / (t * t) + (1 / 2) * (1 / (t * t * t)) ≤
          1 / (T0 * T0) + (1 / 2) * (1 / (T0 * T0 * T0)) :=
        add_le_add hinv2 h4
      simpa [h3] using (div_le_div_of_nonneg h5 (by norm_num : 0 ≤ 12))
    have h6 : (((1 / (t * t) + 1 / (2 * t * t * t)) / 12) * Xfloor ^ (-2 : ℝ)) ≤
        (((1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12) * Xfloor ^ (-2 : ℝ)) :=
      mul_le_mul_of_nonneg_left h2 (by positivity)
    simpa [h1] using h6
  calc (Real.sqrt (1 / 4 + t * t) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ)
      ≤ ((t + 1 / 2) / 12) * (nGrow t : ℝ) ^ (-3 / 2 : ℝ) := hstep1
    _ ≤ ((t + 1 / 2) / 12) * (t * t * Xfloor) ^ (-3 / 2 : ℝ) := hstep2
    _ = ((t + 1 / 2) / 12) * ((t * t) ^ (-3 / 2 : ℝ) * Xfloor ^ (-3 / 2 : ℝ)) := hstep3a
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-3 / 2 : ℝ) := hstep3b
    _ ≤ ((t + 1 / 2) / 12) * (1 / (t * t * t)) * Xfloor ^ (-2 : ℝ) := hstep4
    _ ≤ (1 / (T0 * T0) + 1 / (2 * T0 * T0 * T0)) / 12 * Xfloor ^ (-2 : ℝ) := hstep5
    _ ≤ CG12 := by
      norm_num [Xfloor, CG12, hT0val]
    _ ≤ CG12 := by norm_num
  simpa using this

/-- Upper bound for term 3: (17321/10000)/540 · ‖s(s+1)(s+2)‖-style constant chain.
    √3 ≤ 17321/10000. -/
theorem hSqrt3 : Real.sqrt 3 ≤ 17321 / 10000 := by
  have h1 : 0 ≤ (Real.sqrt 3 : ℝ) := Real.sqrt_nonneg 3
  have h2 : 0 ≤ (17321 : ℝ) / 10000 := by norm_num
  have h3 : 3 ≤ (17321 / 10000 : ℝ) ^ 2 := by norm_num
  have h4 : (Real.sqrt 3) ^ 2 = 3 := by rw [Real.sq_sqrt (by norm_num : 0 ≤ 3)]
  exact le_of_sq_le_sq (by nlinarith [h4, h3]) h2

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
  rw [hS3norm t htnn]
  have hsqrt3 : Real.sqrt 3 / 540 ≤ (17321 / 10000) / 540 :=
    div_le_div_of_nonneg hSqrt3 (by norm_num)
  have hdec : (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-5 / 2 : ℝ) := by
    rw [Real.rpow_neg hnpos.le (5 / 2),
        Real.rpow_neg (hSGfact ht |>.1).le (5 / 2)]
    apply one_div_le_one_div_of_le (by positivity)
    exact Real.rpow_le_rpow hbase (by positivity) (by norm_num)
  have hstep1 : (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hsqrt3 (by positivity)
  have hstep2 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_left hdec (by positivity)
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
        ring
      rw [h4, h2, h3]
      ring
    rw [h1]
    field_simp [htpos.ne']
  have hxi_inv : Xfloor ^ (-5 / 2 : ℝ) ≤ Xfloor ^ (-3 : ℝ) := by
    rw [Real.rpow_neg hXpos.le (5 / 2),
        show Xfloor ^ (-3 : ℝ) = 1 / (Xfloor * Xfloor * Xfloor) from by
          rw [Real.rpow_neg hXpos.le 3,
              show Xfloor ^ (3 : ℝ) = Xfloor * Xfloor * Xfloor from by
                rw [show (3 : ℝ) = 1 + 2 from by norm_num,
                    Real.rpow_add hXpos 1 2, Real.rpow_one,
                    show (2 : ℝ) = 1 + 1 from by norm_num,
                    Real.rpow_add hXpos 1 1, Real.rpow_one]
                ring,
              pow_two]
    apply one_div_le_one_div_of_le (by positivity)
    have h1 : Xfloor * Xfloor * Xfloor ≤ Xfloor ^ (5 / 2 : ℝ) := by
      have h1a : Xfloor * Xfloor * Xfloor ≤ Xfloor * Xfloor * Real.sqrt Xfloor :=
        mul_le_mul_of_nonneg_left hXfsq (by positivity)
      have h2 : Xfloor * Xfloor * Real.sqrt Xfloor = Xfloor ^ (5 / 2 : ℝ) := by
        have h3 : Xfloor ^ (1 / 2 : ℝ) = Real.sqrt Xfloor := by
          rw [Real.sqrt_eq_rpow Xfloor]
        rw [show (5 / 2 : ℝ) = 1 + 1 + 1 / 2 from by norm_num,
            Real.rpow_add hXpos 1 1, Real.rpow_one,
            show ((1 : ℝ) + 1 / 2 : ℝ) = 3 / 2 from by norm_num,
            Real.rpow_add hXpos 1 (1 / 2), Real.rpow_one, h3]
        ring
      simpa [h2] using h1a
    simpa [pow_two] using h1
  have hstep3a : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) =
      ((17321 / 10000) / 540) * (t + 3) ^ 3 *
        ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) := by
    rw [hmulr]
  have hstep3b : ((17321 / 10000) / 540) * (t + 3) ^ 3 *
        ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) := by
    have h1 : (t + 3) ^ 3 * Xfloor ^ (-5 / 2 : ℝ) =
        Xfloor ^ (-5 / 2 : ℝ) * (t + 3) ^ 3 := by ring
    have h2 : (17321 / 10000) / 540 * (t + 3) ^ 3 *
        ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) =
      ((17321 / 10000) / 540 * (t + 3) ^ 3 * (t * t) ^ (-5 / 2 : ℝ)) *
        Xfloor ^ (-5 / 2 : ℝ) := by ring
    have h3 : (17321 / 10000) / 540 * (t + 3) ^ 3 * (t * t) ^ (-5 / 2 : ℝ) ≤
        (17321 / 10000) / 540 * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) :=
      mul_le_mul_of_nonneg_left htpow5.le (by positivity)
    have h4 : (((17321 / 10000) / 540 * (t + 3) ^ 3 * (1 / (t * t * t * t * t))) *
        Xfloor ^ (-5 / 2 : ℝ)) =
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) := by ring
    rw [h2, h4]
    exact mul_le_mul_of_nonneg_left h3 (by positivity)
  have hstep4 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-5 / 2 : ℝ) ≤
      ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_left hxi_inv (by positivity)
  have htp1 : (t + 3) ^ 3 / (t * t * t * t * t) ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
    have h1 : (t + 3) / t = 1 + 3 / t := by
      field_simp [htpos.ne']
      ring
    have h2 : 3 / t ≤ 3 / T0 := by
      apply one_div_le_one_div_of_le (by positivity)
      nlinarith [ht]
    have h3 : 1 + 3 / t ≤ 1 + 3 / T0 := add_le_add_right h2 1
    have h4 : 0 ≤ (t + 3) / t := by positivity
    have h5 : 0 ≤ 1 + 3 / T0 := by positivity
    have h6 : ((t + 3) / t) ^ 3 ≤ (1 + 3 / T0) ^ 3 :=
      pow_le_pow_left₀ (by positivity) h3 3
    have h7 : (t + 3) ^ 3 / (t * t * t * t * t) = ((t + 3) / t) ^ 3 / (t * t) := by
      field_simp [htpos.ne']
      ring
    have h8 : ((t + 3) / t) ^ 3 / (t * t) ≤ ((t + 3) / t) ^ 3 / (T0 * T0) := by
      have h8a : 0 < t * t := by positivity
      have h8b : 0 < T0 * T0 := by positivity
      rw [div_le_div_iff h8a h8b]
      nlinarith [h6, htsq]
    have h9 : ((t + 3) / t) ^ 3 / (T0 * T0) = (1 + 3 / T0) ^ 3 / (T0 * T0) := by
      rw [← h3]
      -- (1 + 3/t)^3 replaced by itself; we need (1+3/T0)^3: use h3 to replace (t+3)/t
      -- actually: ((t+3)/t)^3/(T0*T0): substitute (t+3)/t ≤ ... we need equality with
      -- (1+3/t)^3/(T0*T0), which is h1:
      rw [h1]
    calc ((t + 3) / t) ^ 3 / (T0 * T0)
        ≤ (1 + 3 / T0) ^ 3 / (T0 * T0) := by
      have h10 : 0 < T0 * T0 := by positivity
      rw [div_le_div_iff h10 h10]
      nlinarith [h6]
  have hstep5 : ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) =
      ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) := by
    ring
  have hstep6 : ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
        Xfloor ^ (-3 : ℝ) ≤
      ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
        Xfloor ^ (-3 : ℝ) :=
    mul_le_mul_of_nonneg_left htp1 (by positivity)
  calc (Real.sqrt 3 / 540) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
        (nGrow t : ℝ) ^ (-5 / 2 : ℝ)
      ≤ (Real.sqrt 3 / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hS3norm_ub (by positivity)
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (nGrow t : ℝ) ^ (-5 / 2 : ℝ) := hstep1
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (t * t * Xfloor) ^ (-5 / 2 : ℝ) := hstep2
    _ = ((17321 / 10000) / 540) * (t + 3) ^ 3 *
          ((t * t) ^ (-5 / 2 : ℝ) * Xfloor ^ (-5 / 2 : ℝ)) := hstep3a
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
          Xfloor ^ (-5 / 2 : ℝ) := hstep3b
    _ ≤ ((17321 / 10000) / 540) * (t + 3) ^ 3 * (1 / (t * t * t * t * t)) *
          Xfloor ^ (-3 : ℝ) := hstep4
    _ = ((17321 / 10000) / 540) * ((t + 3) ^ 3 / (t * t * t * t * t)) *
          Xfloor ^ (-3 : ℝ) := by
      rw [← hstep5]
    _ ≤ ((17321 / 10000) / 540) * ((1 + 3 / T0) ^ 3 / (T0 * T0)) *
          Xfloor ^ (-3 : ℝ) := hstep6
    _ ≤ CG13 := by
      norm_num [Xfloor, CG13, hT0val]
    _ ≤ CG13 := by norm_num
  simpa using this
