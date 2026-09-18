/- — Stage B: p8_B term bounds — -/

/-- The floor factor: n(t) ≥ t²·Xfloor for t ≥ T0 (hFloorBase). -/
def Xfloor : ℝ := 1 - 1 / (T0 * T0)

/-- 0 < Xfloor < 1. -/
theorem hXrange : 0 < Xfloor ∧ Xfloor < 1 := by
  constructor
  · rw [Xfloor]
    have h1 : 1 / (T0 * T0) < 1 := one_div_lt_one (by nlinarith [hT0val])
    linarith [h1]
  · rw [Xfloor]
    have h1 : 0 < 1 / (T0 * T0) := by positivity
    linarith [h1]

/-- Xfloor ≤ √Xfloor (since 0 < Xfloor ≤ 1). -/
theorem hXfsq : Xfloor ≤ Real.sqrt Xfloor := by
  have hpos : 0 < Xfloor := (hXrange).1
  have hle : Xfloor ≤ 1 := (hXrange).2.le
  apply le_of_sq_le_sq hpos.le (by positivity)
  nlinarith [show (Real.sqrt Xfloor) ^ 2 = Xfloor from by
    rw [Real.sq_sqrt hpos.le]
  , hle]

variable {t : ℝ} (ht : T0 ≤ t)

/-- 0 < t for t ≥ T0. -/
theorem hSGt_pos : 0 < t := by
  nlinarith [hT0val, ht]
/-- 0 ≤ t. -/
theorem hSGt_nn : 0 ≤ t := (hSGt_pos ht).le
/-- T0² ≤ t². -/
theorem hSGt_sq : T0 * T0 ≤ t * t := by
  nlinarith [hT0val, ht, mul_self_nonneg t]
/-- 1 ≤ ln t. -/
theorem hSGt_log1 : 1 ≤ log t := by
  have h1 : (3 : ℝ) ≤ t := by nlinarith [hT0val, ht]
  exact (Real.log_le_log (by nlinarith [hT0val, ht]) h1).trans_le
    (by
      have hE : Real.exp 1 ≤ 3 := S4W.hE3
      have h2 : Real.log 3 ≥ 1 := by
        rw [show (Real.exp 1 : ℝ) ≤ 3 from hE, show Real.log (Real.exp 1) = 1 from
          (Real.log_exp 1).symm]
        -- log 3 ≥ log e = 1, since e ≤ 3 and log is increasing
        exact le_trans (by
          have h3 : Real.exp 1 ≤ 3 := S4W.hE3
          exact (Real.log_le_log (show 0 < Real.exp 1 from by positivity) h3).trans_eq
            ((Real.log_exp 1).symm))
          (by norm_num : (1 : ℝ) ≤ Real.log 3))
  exact h1

/-- The shared factor identity: 0 < t²·Xfloor and √(t²·Xfloor) = t·√(Xfloor). -/
theorem hSGfact : 0 < t * t * Xfloor ∧ Real.sqrt (t * t * Xfloor) = t * Real.sqrt Xfloor := by
  have htpos := hSGt_pos ht
  have hXpos : 0 < Xfloor := (hXrange).1
  constructor
  · positivity
  · have h1 : Real.sqrt (t * t * Xfloor) = Real.sqrt (t * t) * Real.sqrt Xfloor :=
      Real.sqrt_mul (by nlinarith [hT0val, ht]) hXpos.le
    have h2 : Real.sqrt (t * t) = t := by
      rw [show t * t = t ^ 2 from by ring, Real.sqrt_sq (hSGt_nn ht)]
    rw [h1, h2]

/-- term1: (1/2)·n^{−1/2} ≤ CG11 for t ≥ T0. -/
theorem hCG11 (t : ℝ) (ht : T0 ≤ t) :
    (1 / 2) * (nGrow t : ℝ) ^ (-1 / 2 : ℝ) ≤ CG11 := by
  have n : ℕ := nGrow t
  have hnpos : 0 < (n : ℝ) := hFloorPos t ht
  have hbase : t * t * Xfloor ≤ (n : ℝ) := hFloorBase t ht
  have hfact := hSGfact ht
  have hA : (n : ℝ) ^ (-1 / 2 : ℝ) = 1 / Real.sqrt (n : ℝ) := by
    rw [Real.rpow_neg (by positivity) (1 / 2),
        show (n : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt (n : ℝ) from (Real.sqrt_eq_rpow (n : ℝ)).symm]
  have hB : (t * t * Xfloor) ^ (-1 / 2 : ℝ) = 1 / (t * Real.sqrt Xfloor) := by
    rw [Real.rpow_neg (by positivity) (1 / 2),
        show (t * t * Xfloor) ^ (1 / 2 : ℝ) = Real.sqrt (t * t * Xfloor) from
          (Real.sqrt_eq_rpow (t * t * Xfloor)).symm,
        hfact.2]
  have hdec : (n : ℝ) ^ (-1 / 2 : ℝ) ≤ (t * t * Xfloor) ^ (-1 / 2 : ℝ) := by
    rw [hA, hB]
    have hposn : 0 < Real.sqrt (n : ℝ) := by positivity
    have hposf : 0 < t * Real.sqrt Xfloor := by
      have htpos := hSGt_pos ht
      have hXpos : 0 < Xfloor := (hXrange).1
      positivity
    exact one_div_le_one_div_of_le (by positivity) (Real.sqrt_le_sqrt hbase)
  have hC : (1 / (2 * t)) * (1 / Real.sqrt Xfloor) =
      (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) := by
    rw [hB]
    field_simp
    ring_nf
  have hD : 1 / Real.sqrt Xfloor ≤ 1 / Xfloor :=
    one_div_le_one_div_of_le (by positivity) (hXfsq)
  have hE : (1 / (2 * t)) * (1 / Real.sqrt Xfloor) ≤ (1 / (2 * t)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_left hD (by positivity)
  have hF : 1 / (2 * t) ≤ 1 / (2 * T0) :=
    one_div_le_one_div_of_le (by positivity) (by nlinarith [ht])
  have hG : (1 / (2 * t)) * (1 / Xfloor) ≤ (1 / (2 * T0)) * (1 / Xfloor) :=
    mul_le_mul_of_nonneg_left hF (by positivity)
  calc (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ)
      ≤ (1 / 2) * (t * t * Xfloor) ^ (-1 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hdec (by norm_num)
    _ = (1 / (2 * t)) * (1 / Real.sqrt Xfloor) := by
      symmetry
      exact hC
    _ ≤ (1 / (2 * t)) * (1 / Xfloor) := hE
    _ ≤ (1 / (2 * T0)) * (1 / Xfloor) := hG
    _ ≤ CG11 := by
      norm_num [Xfloor, CG11, hT0val]
  simpa using this
