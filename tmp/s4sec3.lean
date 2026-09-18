/- — §3: W terms — p8_B(t, n4 t) ≤ A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷ (certified anchors,
    scripts/rh/day028_25af_constants.py [0][3]). — -/

/-- ceil bridge: 31000000·t⁴ ≤ (n4 t : ℝ). -/
lemma st_ceilLo (t : ℝ) : (31000000 : ℝ) * t ^ 4 ≤ (n4 t : ℝ) := by
  dsimp only [n4]
  exact Nat.le_ceil ((31000000 : ℝ) * t ^ 4)

/-- n4 t > 0 for t ≥ 1000. -/
lemma st_n4pos (t : ℝ) (ht : 1000 ≤ t) : 0 < (n4 t : ℝ) := by
  have hoc : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos (st_tpos t ht) 4)
  linarith [st_ceilLo t, hoc]

/-- sqrt anchor: 5567 ≤ √31000000 (exact integers: 5567² ≤ 31000000). -/
lemma st_sqrt5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := by
  have hsq : (5567 : ℝ) ^ 2 ≤ (Real.sqrt 31000000) ^ 2 := by
    rw [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 31000000)]
    norm_num
  exact (sq_le_sq₀ (by norm_num : (0 : ℝ) ≤ 5567) (Real.sqrt_nonneg 31000000)).mpr hsq

/-- (A1) W1: (1/2)·n4⁻¹ᐟ² ≤ A1·t⁻². -/
lemma st_W1 (t : ℝ) (ht : 1000 ≤ t) :
    (1 / 2 : ℝ) * (n4 t : ℝ) ^ (-1 / 2 : ℝ) ≤ A1 * t ^ (-2 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hmono : (n4 t : ℝ) ^ (-1 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-1 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-1 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-1 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-1 / 2 : ℝ) * t ^ (-2 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [← Real.rpow_mul ht0 4 (-1 / 2 : ℝ), show (4 * (-1 / 2) : ℝ) = (-2 : ℝ) from by ring]
  have hconst : (1 / 2 : ℝ) * (31000000 : ℝ) ^ (-1 / 2 : ℝ) ≤ A1 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hinv : (31000000 : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt 31000000 := by
      rw [Real.rpow_neg hc.le (1 / 2 : ℝ), Real.sqrt_eq_rpow]
      ring
    rw [hinv]
    have ha : (0 : ℝ) ≤ 1 / 2 := by norm_num
    have hb : 0 ≤ A1 * Real.sqrt 31000000 := by
      apply mul_nonneg
      · dsimp only [A1]; norm_num
      · exact Real.sqrt_nonneg 31000000
    have hsq : (1 / 2 : ℝ) ^ 2 ≤ (A1 * Real.sqrt 31000000) ^ 2 := by
      have hR : (A1 * Real.sqrt 31000000 : ℝ) ^ 2 = A1 ^ 2 * 31000000 := by
        rw [pow_two, mul_assoc, mul_comm (Real.sqrt 31000000) A1, ← mul_assoc, mul_self,
            Real.sq_sqrt hc.le]
        ring
      rw [hR]
      norm_num [A1]
    have hle : (1 / 2 : ℝ) ≤ A1 * Real.sqrt 31000000 := (sq_le_sq₀ ha hb).mp hsq
    rw [div_le_iff₀ hrs]
    exact hle
  calc (1 / 2 : ℝ) * (n4 t : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2 : ℝ) * (31000000 * t ^ 4) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hmono (by norm_num : (0 : ℝ) ≤ 1 / 2)
    _ = (1 / 2 : ℝ) * ((31000000 : ℝ) ^ (-1 / 2 : ℝ) * t ^ (-2 : ℝ)) := by rw [hsplit]
    _ = ((1 / 2 : ℝ) * (31000000 : ℝ) ^ (-1 / 2 : ℝ)) * t ^ (-2 : ℝ) := by ring
    _ ≤ A1 * t ^ (-2 : ℝ) :=
        mul_le_mul_of_nonneg_right hconst (Real.rpow_nonneg ht0.le (-2 : ℝ))

/-- (A2) W2: (‖s‖/12)·n4⁻³ᐟ² ≤ A2·t⁻⁵, s = 1/2 + i·t. -/
lemma st_W2 (t : ℝ) (ht : 1000 ≤ t) :
    (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ) ≤
        A2 * t ^ (-5 : ℝ) := by
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hs : ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ = Real.sqrt (1 / 4 + t * t) := S4G.hNorm t
  rw [hs]
  have hnorm : Real.sqrt (1 / 4 + t * t) ≤ t + 1 / 2 := S4G.hSbnd t (le_of_lt ht0)
  have hmono : (n4 t : ℝ) ^ (-3 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-3 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-3 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-3 / 2 : ℝ) * t ^ (-6 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [← Real.rpow_mul ht0 4 (-3 / 2 : ℝ), show (4 * (-3 / 2) : ℝ) = (-6 : ℝ) from by ring]
  -- (t+1/2)·t⁻⁶ ≤ (2001/2000)·t⁻⁵  [t ≥ 1000 ⟹ 1/(2t) ≤ 1/2000]
  have htf : (t + 1 / 2 : ℝ) * t ^ (-6 : ℝ) ≤ (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) := by
    have hcore : (t + 1 / 2 : ℝ) ≤ (2001 / 2000 : ℝ) * t := by
      have h3 : (3 : ℝ) ≤ (3 / 1000 : ℝ) * t := by
        calc (3 : ℝ) = (3 / 1000 : ℝ) * 1000 := by ring
          _ ≤ (3 / 1000 : ℝ) * t :=
            mul_le_mul_of_nonneg_left ht (by norm_num : (0 : ℝ) ≤ 3 / 1000)
      nlinarith [h3]
    have htm : (t : ℝ) * t ^ (-6 : ℝ) = t ^ (-5 : ℝ) := by
      rw [mul_comm, Real.rpow_add ht0 (-(6 : ℝ)) 1, show (-(6 : ℝ) + 1 = (-5 : ℝ)) from by ring]
    calc (t + 1 / 2 : ℝ) * t ^ (-6 : ℝ)
        ≤ ((2001 / 2000 : ℝ) * t) * t ^ (-6 : ℝ) :=
          mul_le_mul_of_nonneg_right hcore (Real.rpow_nonneg ht0.le (-6 : ℝ))
      _ = (2001 / 2000 : ℝ) * (t * t ^ (-6 : ℝ)) := by ring
      _ = (2001 / 2000 : ℝ) * t ^ (-5 : ℝ) := by rw [htm]
  have hA2raw : (31000000 : ℝ) ^ (-3 / 2 : ℝ) * (2001 / 24000 : ℝ) ≤ A2 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hbridge : (31000000 : ℝ) ^ (-3 / 2 : ℝ) = 1 / (31000000 * Real.sqrt 31000000) := by
      rw [Real.rpow_neg hc.le (3 / 2 : ℝ)]
      rw [show (31000000 : ℝ) ^ (3 / 2 : ℝ) = 31000000 * Real.sqrt 31000000 from by
        rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by ring, Real.rpow_add hc 1 (1 / 2 : ℝ)]
        rw [show (31000000 : ℝ) ^ (1 : ℝ) = 31000000 from by norm_num,
            show (31000000 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 31000000 from by
              rw [Real.sqrt_eq_rpow]]
        ring
      ]
      ring
    rw [hbridge]
    have h5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := st_sqrt5567
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hinv : 1 / (31000000 * Real.sqrt 31000000) ≤ 1 / (31000000 * 5567) := by
      have hd1 : 0 < 31000000 * Real.sqrt 31000000 := mul_pos hc hrs
      have hd2 : 0 < 31000000 * 5567 := by norm_num
      rw [div_le_div_iff₀ hd1 hd2]
      exact mul_le_mul_of_nonneg_left h5567 hc.le
    calc (31000000 : ℝ) ^ (-3 / 2 : ℝ) * (2001 / 24000 : ℝ)
        = ((2001 : ℝ) / 24000) * 1 / (31000000 * Real.sqrt 31000000) := by ring
      _ ≤ ((2001 : ℝ) / 24000) * 1 / (31000000 * 5567) :=
          mul_le_mul_of_nonneg_left hinv (by norm_num : (0 : ℝ) ≤ (2001 : ℝ) / 24000)
      _ ≤ (5 : ℝ) / 10 ^ 13 := by
        have h1 : ((2001 : ℝ) / 24000) * 1 / (31000000 * 5567) =
            2001 / (24000 * 31000000 * 5567) := by ring
        rw [h1]
        rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 24000 * 31000000 * 5567)
            (by norm_num : (0 : ℝ) < 10 ^ 13)]
        norm_num
  have hstep0 : Real.sqrt (1 / 4 + t * t) / 12 ≤ (t + 1 / 2) / 12 := by
    rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 12) (by norm_num : (0 : ℝ) < 12)]
    nlinarith [hnorm]
  have hposc : 0 ≤ (31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12 :=
    div_nonneg (Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) (-3 / 2 : ℝ)) (by norm_num)
  calc (Real.sqrt (1 / 4 + t * t) / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ)
      ≤ ((t + 1 / 2) / 12) * (n4 t : ℝ) ^ (-3 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hstep0 (Real.rpow_nonneg (st_n4pos t ht).le (-3 / 2 : ℝ))
    _ ≤ ((t + 1 / 2) / 12) * (31000000 * t ^ 4) ^ (-3 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hmono (by nlinarith [le_of_lt ht0])
    _ = ((t + 1 / 2) / 12) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * t ^ (-6 : ℝ)) := by rw [hsplit]
    _ = ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) * ((t + 1 / 2) * t ^ (-6 : ℝ)) := by ring
    _ ≤ ((31000000 : ℝ) ^ (-3 / 2 : ℝ) / 12) * ((2001 / 2000 : ℝ) * t ^ (-5 : ℝ)) :=
        mul_le_mul_of_nonneg_right htf hposc
    _ = ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * (2001 / 24000 : ℝ)) * t ^ (-5 : ℝ) := by ring
    _ ≤ A2 * t ^ (-5 : ℝ) :=
        mul_le_mul_of_nonneg_right hA2raw (Real.rpow_nonneg ht0.le (-5 : ℝ))

/-- (A3) W3: (√3/540)·‖s(s+1)(s+2)‖·n4⁻⁵ᐟ² ≤ A3·t⁻⁷. -/
lemma st_W3 (t : ℝ) (ht : 1000 ≤ t) :
    (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (n4 t : ℝ) ^ (-5 / 2 : ℝ) ≤ A3 * t ^ (-7 : ℝ) := by
  set H3 := ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ with hH3
  have ht0 : 0 < t := st_tpos t ht
  have hnpos : 0 < (n4 t : ℝ) := st_n4pos t ht
  have hbase : 0 < (31000000 : ℝ) * t ^ 4 :=
    mul_pos (by norm_num : (0 : ℝ) < 31000000) (pow_pos ht0 4)
  have hsqrt3 : Real.sqrt 3 ≤ (17321 : ℝ) / 10 ^ 4 := S4G.hSqrt3
  have hs3 : ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
      (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ ≤ (t + 3) ^ 3 := S4G.hS3norm t (le_of_lt ht0)
  have hmono : (n4 t : ℝ) ^ (-5 / 2 : ℝ) ≤ (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) :=
    (Real.rpow_le_rpow_iff_of_neg hnpos hbase (by norm_num : (-5 / 2 : ℝ) < 0)).mpr (st_ceilLo t)
  have hsplit : (31000000 * t ^ 4 : ℝ) ^ (-5 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ) := by
    rw [Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 31000000) (pow_nonneg ht0.le 4)]
    rw [← Real.rpow_mul ht0 4 (-5 / 2 : ℝ), show (4 * (-5 / 2) : ℝ) = (-10 : ℝ) from by ring]
  -- (t+3)³ ≤ (1003/1000)³·t³  [t ≥ 1000 ⟹ 1 + 3/t ≤ 1003/1000]
  have ht3 : (t + 3 : ℝ) ^ 3 ≤ (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by
    have h1 : (t + 3 : ℝ) ≤ (1003 / 1000 : ℝ) * t := by
      have h3 : (3 : ℝ) ≤ (3 / 1000 : ℝ) * t := by
        calc (3 : ℝ) = (3 / 1000 : ℝ) * 1000 := by ring
          _ ≤ (3 / 1000 : ℝ) * t :=
            mul_le_mul_of_nonneg_left ht (by norm_num : (0 : ℝ) ≤ 3 / 1000)
      nlinarith [h3]
    have hpow : (t + 3 : ℝ) ^ 3 ≤ ((1003 / 1000 : ℝ) * t) ^ 3 :=
      pow_le_pow_left₀ (by nlinarith [le_of_lt ht0]) h1 3
    have hmul : ((1003 / 1000 : ℝ) * t) ^ 3 = (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by
      rw [mul_pow]
    calc (t + 3 : ℝ) ^ 3 ≤ ((1003 / 1000 : ℝ) * t) ^ 3 := hpow
      _ = (1003 / 1000 : ℝ) ^ 3 * t ^ 3 := by rw [hmul]
  -- t³·t⁻¹⁰ = t⁻⁷
  have ht7 : (t : ℝ) ^ 3 * t ^ (-10 : ℝ) = t ^ (-7 : ℝ) := by
    rw [show (t : ℝ) ^ 3 = (t : ℝ) ^ (3 : ℝ) from by simp]
    rw [← Real.rpow_add ht0 (3 : ℝ) (-10 : ℝ)]
    rw [show (3 : ℝ) + (-10 : ℝ) = (-7 : ℝ) from by ring]
  have hA3raw : (17321 : ℝ) / 10 ^ 4 / 540 * (31000000 : ℝ) ^ (-5 / 2 : ℝ) *
      (1003 / 1000 : ℝ) ^ 3 ≤ A3 := by
    have hc : (0 : ℝ) < 31000000 := by norm_num
    have hbridge : (31000000 : ℝ) ^ (-5 / 2 : ℝ) = 1 / (31000000 ^ 2 * Real.sqrt 31000000) := by
      rw [Real.rpow_neg hc.le (5 / 2 : ℝ)]
      rw [show (31000000 : ℝ) ^ (5 / 2 : ℝ) = 31000000 ^ 2 * Real.sqrt 31000000 from by
        rw [show (5 / 2 : ℝ) = 2 + 1 / 2 from by ring, Real.rpow_add hc 2 (1 / 2 : ℝ)]
        have heq2 : (31000000 : ℝ) ^ 2 = (31000000 ^ 2 : ℝ) := by norm_num
        rw [heq2, show (31000000 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt 31000000 from by
          rw [Real.sqrt_eq_rpow]]
        ring
      ]
      ring
    rw [hbridge]
    have h5567 : (5567 : ℝ) ≤ Real.sqrt 31000000 := st_sqrt5567
    have hrs : 0 < Real.sqrt 31000000 := Real.sqrt_pos.mpr hc
    have hinv : 1 / (31000000 ^ 2 * Real.sqrt 31000000) ≤ 1 / (31000000 ^ 2 * 5567) := by
      have hd1 : 0 < 31000000 ^ 2 * Real.sqrt 31000000 :=
        mul_pos (pow_pos hc 2) hrs
      have hd2 : 0 < 31000000 ^ 2 * 5567 := by norm_num
      rw [div_le_div_iff₀ hd1 hd2]
      exact mul_le_mul_of_nonneg_left h5567 (pow_nonneg hc.le 2)
    have hcoef : 0 ≤ (17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3 := by
      apply mul_nonneg
      · apply div_nonneg
        · norm_num
        · norm_num
      · exact pow_nonneg (by norm_num : (0 : ℝ) ≤ 1003 / 1000) 3
    calc (17321 : ℝ) / 10 ^ 4 / 540 * (31000000 : ℝ) ^ (-5 / 2 : ℝ) * (1003 / 1000 : ℝ) ^ 3
        = ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) * 1 /
            (31000000 ^ 2 * Real.sqrt 31000000) := by ring
      _ ≤ ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) * 1 /
            (31000000 ^ 2 * 5567) :=
          mul_le_mul_of_nonneg_left hinv hcoef
      _ ≤ (1 : ℝ) / 10 ^ 20 := by
        have h1 : ((17321 : ℝ) / 10 ^ 4 / 540 * (1003 / 1000 : ℝ) ^ 3) * 1 /
            (31000000 ^ 2 * 5567) =
            17321 * 1003 ^ 3 / (10 ^ 4 * 540 * 1000 ^ 3 * 31000000 ^ 2 * 5567) := by
          field_simp
          ring
        rw [h1]
        rw [div_le_div_iff₀ (by norm_num : (0 : ℝ) < 10 ^ 4 * 540 * 1000 ^ 3 * 31000000 ^ 2 * 5567)
            (by norm_num : (0 : ℝ) < 10 ^ 20)]
        norm_num
  calc (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ *
      (n4 t : ℝ) ^ (-5 / 2 : ℝ)
      = (Real.sqrt 3 / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by rw [← hH3]
    _ ≤ ((17321 / 10 ^ 4) / 540) * H3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
        have hstep : (Real.sqrt 3 / 540) * H3 ≤ ((17321 / 10 ^ 4) / 540) * H3 :=
          mul_le_mul_of_nonneg_right hsqrt3 (norm_nonneg _)
        exact mul_le_mul_of_nonneg_right hstep (mul_nonneg (norm_nonneg _)
            (Real.rpow_nonneg (st_n4pos t ht).le (-5 / 2 : ℝ)))
    _ ≤ ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (n4 t : ℝ) ^ (-5 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hs3 (by
          apply mul_nonneg
          · apply div_nonneg <;> norm_num
          · exact pow_nonneg (by nlinarith [le_of_lt ht0]) 3)
    _ ≤ ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 * (31000000 * t ^ 4) ^ (-5 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hmono (by
          apply mul_nonneg
          · apply div_nonneg <;> norm_num
          · exact pow_nonneg (by nlinarith [le_of_lt ht0]) 3)
    _ = ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
        ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by rw [hsplit]
    _ ≤ ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
        ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by
        have hstep : ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
            ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) ≤
            ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
            ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) :=
          calc ((17321 / 10 ^ 4) / 540) * (t + 3) ^ 3 *
                  ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))
              = ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) *
                  (t + 3) ^ 3 := by ring
                _ ≤ ((17321 / 10 ^ 4) / 540 * ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ))) *
                    ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) := by
                  apply mul_le_mul_of_nonneg_right ht3
                  apply mul_nonneg
                  · apply div_nonneg <;> norm_num
                  · exact Real.rpow_nonneg (by norm_num : (0 : ℝ) ≤ 31000000) (-5 / 2 : ℝ)
                _ = ((17321 / 10 ^ 4) / 540) * ((1003 / 1000 : ℝ) ^ 3 * t ^ 3) *
                    ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t ^ (-10 : ℝ)) := by ring
        exact hstep
    _ = ((17321 / 10 ^ 4) / 540) * (31000000 : ℝ) ^ (-5 / 2 : ℝ) * (1003 / 1000 : ℝ) ^ 3 *
        ((t : ℝ) ^ 3 * t ^ (-10 : ℝ)) := by ring
    _ = ((17321 / 10 ^ 4) / 540) * (31000000 : ℝ) ^ (-5 / 2 : ℝ) * (1003 / 1000 : ℝ) ^ 3 *
        (t : ℝ) ^ (-7 : ℝ) := by
        rw [ht7]

/-- (W) p8_B(t, n4 t) ≤ A1·t⁻² + A2·t⁻⁵ + A3·t⁻⁷. -/
theorem st_hW (t : ℝ) (ht : 1000 ≤ t) :
    p8_B t (n4 t) ≤ A1 * t ^ (-2 : ℝ) + A2 * t ^ (-5 : ℝ) + A3 * t ^ (-7 : ℝ) := by
  dsimp only [p8_B]
  nlinarith [st_W1 t ht, st_W2 t ht, st_W3 t ht]
