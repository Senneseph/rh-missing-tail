/- — Stage C: Xgrow (the b3BoundExplicit wire) bound — -/

/-- ln t ≥ 1 for t ≥ T0 (since exp 1 ≤ 3 ≤ 110000 ≤ t). -/
theorem hLogT1 (t : ℝ) (ht : T0 ≤ t) : 1 ≤ Real.log t := by
  have htpos := hSGtp ht
  have h1 : Real.exp 1 < t := by
    linarith [S4W.hE3, hT0val, ht]
  have h2 : Real.log (Real.exp 1) = 1 := by rw [Real.log_exp]
  have h3 : Real.log (Real.exp 1) < Real.log t := Real.log_lt_log htpos h1
  linarith [h2, h3]

/-- Bf(t, t²) ≤ (2 + 1/T0 + 1/T0²)/t² for t ≥ T0. -/
theorem hBfUB (t : ℝ) (ht : T0 ≤ t) :
    Bf t (Ggrow t) ≤ (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := by
  have htpos := hSGtp ht
  have hT0p : 0 < T0 := hSGT0pos
  have hDpos : 0 < t * t * t * t + 1 / 4 := by positivity
  have hDm : 0 < t * t * t * t - t * t := by
    have ht2 : 1 < t * t := by nlinarith [hT0val, hSGtsq ht]
    have h1 : t * t - 1 > 0 := by linarith
    nlinarith [h1, htpos]
  have hp2 : (w t / (t * t * t * t + 1 / 4)) / (1 - w t / (t * t * t * t + 1 / 4)) =
      (t * t + 1 / 4) / (t * t * t * t - t * t) := by
    unfold w
    field_simp [hDpos.ne', hDm.ne']
    ring
  have h1 : 1 / (2 * (t * t * t * t + 1 / 4)) ≤ 1 / (2 * t * t * t * t) := by
    apply one_div_le_one_div_of_le
    · positivity
    · nlinarith
  have h3 : t / (t * t * t * t + 1 / 4) ≤ 1 / (t * t * t) := by
    have h1 : 1 / (t * t * t * t + 1 / 4) ≤ 1 / (t * t * t * t) :=
      one_div_le_one_div_of_le (by positivity) (by nlinarith)
    have h2 : t / (t * t * t * t + 1 / 4) ≤ t / (t * t * t * t) := by
      have h2a : t / (t * t * t * t + 1 / 4) = t * (1 / (t * t * t * t + 1 / 4)) := by ring
      have h2b : t / (t * t * t * t) = t * (1 / (t * t * t * t)) := by ring
      rw [h2a, h2b]
      exact mul_le_mul_of_nonneg_left h1 (by positivity)
    have h3b : t / (t * t * t * t) = 1 / (t * t * t) := by
      field_simp [htpos.ne']
    rw [h3b] at h2
      exact h2
  have hnumub : t * t + 1 / 4 ≤ 2 * (t * t - 1) := by
    nlinarith [hT0val, hSGtsq ht]
  have hp2b : (t * t + 1 / 4) / (t * t * t * t - t * t) ≤ 2 / (t * t) := by
    have h2 : (2 * (t * t - 1)) / (t * t * t * t - t * t) = 2 / (t * t) := by
      field_simp [htpos.ne', hDm.ne']
      ring
    have h1 : (t * t + 1 / 4) / (t * t * t * t - t * t) ≤
        (2 * (t * t - 1)) / (t * t * t * t - t * t) :=
      mul_le_mul_of_nonneg_right hnumub (by positivity)
    calc (t * t + 1 / 4) / (t * t * t * t - t * t)
        ≤ (2 * (t * t - 1)) / (t * t * t * t - t * t) := h1
      _ = 2 / (t * t) := h2
  have hb : Bf t (Ggrow t) =
      1 / (2 * (t * t * t * t + 1 / 4)) +
      (t * t + 1 / 4) / (t * t * t * t - t * t) + t / (t * t * t * t + 1 / 4) := by
    unfold Bf, Ggrow
    rw [hp2]
    field_simp [hDpos.ne']
    ring
  have hfin : 2 / (t * t) + 1 / (t * t * t) + 1 / (2 * t * t * t * t) ≤
      (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := by
    have h1 : 1 / (t * t * t) ≤ 1 / (T0 * t * t) := by
      have h1a : T0 * t * t ≤ t * t * t := by
        have h1b : T0 * t ≤ t * t := mul_le_mul_of_nonneg_left ht (by positivity)
        nlinarith [h1b, htpos]
      exact (one_div_le_one_div_of_le (by positivity) h1a)
    have h2 : 1 / (2 * t * t * t * t) ≤ 1 / (T0 * T0 * t * t) := by
      have h2a : T0 * T0 * t * t ≤ 2 * t * t * t * t := by
        have h2b : T0 * T0 ≤ 2 * t * t := by nlinarith [hSGtsq ht]
        nlinarith [h2b, htpos]
      exact (one_div_le_one_div_of_le (by positivity) h2a)
    have hR : (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) =
        2 / (t * t) + 1 / (T0 * t * t) + 1 / (T0 * T0 * t * t) := by
      field_simp [htpos.ne', hT0p]
      ring
    have h1b : 1 / T0 / (t * t) = 1 / (T0 * t * t) := by ring
    have h2b : 1 / (T0 * T0) / (t * t) = 1 / (T0 * T0 * t * t) := by ring
    rw [hR, h1b, h2b]
    nlinarith [h1, h2]
  calc Bf t (Ggrow t)
      = 1 / (2 * (t * t * t * t + 1 / 4)) +
        (t * t + 1 / 4) / (t * t * t * t - t * t) + t / (t * t * t * t + 1 / 4) := hb
    _ ≤ 1 / (2 * t * t * t * t) + 2 / (t * t) + 1 / (t * t * t) := by
      gcongr <;> (try assumption) <;> (try exact h3)
    _ ≤ 2 / (t * t) + 1 / (t * t * t) + 1 / (2 * t * t * t * t) := by
      ring_nf
      <;> simp [add_assoc, add_comm, add_left_comm]
    _ ≤ (2 + 1 / T0 + 1 / (T0 * T0)) / (t * t) := hfin

/-- Sbar(2t²) + Sbar(t²) ≤ 2·ln t + 11 for t ≥ T0. -/
theorem hSSumUB (t : ℝ) (ht : T0 ≤ t) :
    Sbar (Bgrow t) + Sbar (Ggrow t) ≤ 2 * Real.log t + 11 := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 ht ht
  have hLpos : 0 < Real.log t := hL.le
  have hln2 : Real.log 2 ≤ 1 := Real.log_le_sub_one_of_pos (by norm_num : 0 < 2)
  have hln2pos : 0 < Real.log 2 := Real.log_pos (by norm_num : 1 < 2)
  have hln2L : Real.log (2 * Real.log t) ≤ 1 + Real.log (Real.log t) := by
    have h1 : Real.log (2 * Real.log t) = Real.log 2 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hLpos.ne']
    rw [h1]
    nlinarith [hln2]
  have hlnL2 : Real.log (Real.log 2 + 2 * Real.log t) ≤ 2 + Real.log (Real.log t) := by
    have h1 : Real.log 2 + 2 * Real.log t ≤ 3 * Real.log t := by
      nlinarith [hln2, hL]
    have h2 : Real.log (Real.log 2 + 2 * Real.log t) ≤ Real.log (3 * Real.log t) :=
      Real.log_le_log (by nlinarith [hln2pos, hLpos]) h1
    have h3 : Real.log (3 * Real.log t) = Real.log 3 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (3 : ℝ) ≠ 0) hLpos.ne']
    have h4 : Real.log 3 ≤ 2 := Real.log_le_sub_one_of_pos (by norm_num : 0 < 3)
    rw [h2, h3]
    nlinarith [h4]
  have hlnLub : Real.log (Real.log t) ≤ Real.log t / 2 := hLogHalf (Real.log t) hL
  have hexp : Sbar (Bgrow t) + Sbar (Ggrow t) =
      (22 / 100) * Real.log t + 0.110 * Real.log 2 + 0.290 * Real.log (2 * Real.log t) +
      0.290 * Real.log (Real.log 2 + 2 * Real.log t) + (458 / 100) := by
    unfold Sbar, Ggrow, Bgrow
    have h1 : Real.log (t * t) = 2 * Real.log t := by
      rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
      ring
    have h2 : Real.log (2 * t * t) = Real.log 2 + 2 * Real.log t := by
      rw [show (2 * t * t : ℝ) = 2 * (t * t) from by ring,
          Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) htpos.ne', h1]
      ring
    have h3 : Real.log (Real.log (t * t)) = Real.log (2 * Real.log t) := by rw [h1]
    have h4 : Real.log (Real.log (2 * t * t)) = Real.log (Real.log 2 + 2 * Real.log t) := by
      rw [show (2 * t * t : ℝ) = 2 * (t * t) from by ring, h2, show (2 * (t * t) : ℝ) = t * t * 2 from by ring]
      ring
    rw [show (Bgrow t : ℝ) = 2 * (t * t) from by ring, h2, h4,
        show (Ggrow t : ℝ) = t * t from by ring, h1, h3]
    ring
  rw [hexp]
  have hmid : (22 / 100) * Real.log t + 0.110 * Real.log 2 + 0.290 * Real.log (2 * Real.log t) +
      0.290 * Real.log (Real.log 2 + 2 * Real.log t) + 458 / 100 ≤
      Real.log t + 11 := by
    nlinarith [hln2, hln2L, hlnL2, hlnLub]
  nlinarith [hmid, hL]

/-- Cf(t, t²) ≤ 2t² + 9/2 + 5/t² for t ≥ T0. -/
theorem hCfUB (t : ℝ) (ht : T0 ≤ t) :
    Cf t (Ggrow t) ≤ 2 * t * t + 9 / 2 + 5 / (t * t) := by
  have htpos := hSGtp ht
  have hDm : 0 < t * t - 1 := by
    have ht2 : 1 < t * t := by nlinarith [hT0val, hSGtsq ht]
    linarith
  have hc : Cf t (Ggrow t) = 2 * t * t + 7 / 2 + 5 / (2 * (t * t - 1)) := by
    unfold Cf, Ggrow, w
    field_simp [hDm.ne']
    ring
  rw [hc]
  have h1 : t * t ≤ 2 * (t * t - 1) := by
    nlinarith [hT0val, hSGtsq ht]
  have h2 : 1 / (2 * (t * t - 1)) ≤ 1 / (t * t) :=
    one_div_le_one_div_of_le (by positivity) h1
  have h3 : 5 / (2 * (t * t - 1)) ≤ 5 / (t * t) := by
    have h3a : 5 / (2 * (t * t - 1)) = 5 * (1 / (2 * (t * t - 1))) := by ring
    have h3b : 5 / (t * t) = 5 * (1 / (t * t)) := by ring
    rw [h3a, h3b]
    exact mul_le_mul_of_nonneg_left h2 (by norm_num)
  nlinarith [h3]

/-- Kbar(t²) ≤ (0.51·ln t + 2.78)/(2t⁴) for t ≥ T0. -/
theorem hKbarUB (t : ℝ) (ht : T0 ≤ t) :
    Kbar (Ggrow t) ≤ (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 ht ht
  have hLpos : 0 < Real.log t := hL.le
  have h1 : Real.log (t * t) = 2 * Real.log t := by
    rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
    ring
  have h2 : Real.log (Real.log (t * t)) = Real.log (2 * Real.log t) := by rw [h1]
  have hln2L : Real.log (2 * Real.log t) ≤ 1 + Real.log (Real.log t) := by
    have h1b : Real.log (2 * Real.log t) = Real.log 2 + Real.log (Real.log t) := by
      rw [Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) hLpos.ne']
    rw [h1b]
    nlinarith [Real.log_le_sub_one_of_pos (by norm_num : 0 < 2)]
  have hlnLub : Real.log (Real.log t) ≤ Real.log t / 2 := hLogHalf (Real.log t) hL
  have heq : Kbar (Ggrow t) =
      (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290) / (2 * t * t * t * t) := by
    unfold Kbar, Ggrow
    have hd : 0 ≠ 2 * t * t * t * t := by positivity
    field_simp [hd, h1, h2]
    ring
  rw [heq]
  have hnum : 0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
      2.290 ≤ 0.51 * Real.log t + 2.78 := by
    have h3 : 0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290 = 0.22 * Real.log t + 0.29 * Real.log (2 * Real.log t) + 2.49 := by
      ring
    rw [h3]
    have h4 : 0.22 * Real.log t + 0.29 * (1 + Real.log (Real.log t)) + 2.49 ≤
        0.51 * Real.log t + 2.78 := by
      nlinarith [hlnLub]
    nlinarith [h4, hln2L]
  have hd : 0 < 2 * t * t * t * t := by positivity
  calc (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
      2.290) / (2 * t * t * t * t)
      ≤ (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) := by
    have h1b : (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290) / (2 * t * t * t * t) =
        (0.110 * (2 * Real.log t + 1 / 2) + 0.290 * (Real.log (2 * Real.log t) + 1 / 2) +
        2.290) * (1 / (2 * t * t * t * t)) := by
      rw [div_eq_mul_inv]
    have h2b : (0.51 * Real.log t + 2.78) / (2 * t * t * t * t) =
        (0.51 * Real.log t + 2.78) * (1 / (2 * t * t * t * t)) := by
      rw [div_eq_mul_inv]
    rw [h1b, h2b]
    exact mul_le_mul_of_nonneg_left hnum (by positivity)

theorem hDfrac (t : ℝ) (ht : T0 ≤ t) :
    (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) ≤
      (1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0)) / (t * t) := by
  have htpos := hSGtp ht
  have hT0p : 0 < T0 := hSGT0pos
  have hlhs : (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) =
      1 / (t * t) + 9 / (4 * t * t * t * t) + 5 / (2 * t * t * t * t * t * t) := by
    field_simp [htpos.ne']
    ring
  have hrs : (1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0)) / (t * t) =
      1 / (t * t) + 9 / (4 * T0 * T0 * t * t) + 5 / (2 * T0 * T0 * T0 * T0 * t * t) := by
    field_simp [htpos.ne', hT0p]
    ring
  rw [hlhs, hrs]
  have h1 : 9 / (4 * t * t * t * t) ≤ 9 / (4 * T0 * T0 * t * t) := by
    have h1a : T0 * T0 * t * t ≤ t * t * t * t := by
      have h1b : T0 * T0 ≤ t * t := hSGtsq ht
      nlinarith [h1b, htpos]
    have h1b : 1 / (4 * t * t * t * t) ≤ 1 / (4 * T0 * T0 * t * t) :=
      one_div_le_one_div_of_le (by positivity) h1a
    exact mul_le_mul_of_nonneg_left h1b (by norm_num)
  have h2 : 5 / (2 * t * t * t * t * t * t) ≤ 5 / (2 * T0 * T0 * T0 * T0 * t * t) := by
    have h2a : T0 * T0 * T0 * T0 * t * t ≤ t * t * t * t * t * t := by
      have h2b : T0 * T0 ≤ t * t := hSGtsq ht
      have h2c : T0 * T0 * T0 * T0 ≤ t * t * t * t := by
        have h2d : 0 ≤ T0 * T0 := by positivity
        nlinarith [h2b, h2d]
      nlinarith [h2c, htpos]
    have h2b : 1 / (2 * t * t * t * t * t * t) ≤ 1 / (2 * T0 * T0 * T0 * T0 * t * t) :=
      one_div_le_one_div_of_le (by positivity) h2a
    exact mul_le_mul_of_nonneg_left h2b (by norm_num)
  have h3 : 1 / (t * t) ≤ 1 / (t * t) := le_rfl
  nlinarith [h1, h2, h3]

/-- The main X bound: Xgrow t ≤ XUBfun t = (4.98·ln t + 26.55)/t² for t ≥ T0. -/
theorem hXub (t : ℝ) (ht : T0 ≤ t) : Xgrow t ≤ XUBfun t := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 ht ht
  have hBf := hBfUB t ht
  have hS := hSSumUB t ht
  have hC := hCfUB t ht
  have hK := hKbarUB t ht
  have hD := hDfrac t ht
  have hS0 : 0 ≤ Sbar (Bgrow t) + Sbar (Ggrow t) := by
    have h1 : 1 < Real.log (2 * t * t) := by
      have h1a : Real.log (2 * t * t) = Real.log 2 + 2 * Real.log t := by
        rw [show (2 * t * t : ℝ) = 2 * (t * t) from by ring,
            Real.log_mul (by norm_num : (2 : ℝ) ≠ 0) htpos.ne']
        ring
      rw [h1a]
      nlinarith [hL, Real.log_pos (by norm_num : (1 : ℝ) < 2)]
    have h2 : 0 < Real.log (Real.log (2 * t * t)) := Real.log_pos h1
    have h3 : 1 < 2 * Real.log t := by nlinarith [hL]
    have h4 : 0 < Real.log (2 * Real.log t) := Real.log_pos h3
    have h5 : 1 < Real.log (t * t) := by
      have h5a : Real.log (t * t) = 2 * Real.log t := by
        rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
        ring
      rw [h5a]
      nlinarith [hL]
    have h6 : 0 < Real.log (Real.log (t * t)) := Real.log_pos h5
    unfold Sbar, Bgrow, Ggrow
    refine add_nonneg ?_ ?_
    · nlinarith [h1, h2]
    · nlinarith [h3, h4, h5, h6]
      exact add_nonneg (by nlinarith [h1, h2]) (by nlinarith [h5, h6])
  have hK0 : 0 ≤ Kbar (Ggrow t) := by
    unfold Kbar, Ggrow
    have h1 : 1 < Real.log (t * t) := by
      have h1a : Real.log (t * t) = 2 * Real.log t := by
        rw [show (t * t : ℝ) = t * t from rfl, Real.log_mul htpos.ne' htpos.ne']
        ring
      rw [h1a]
      nlinarith [hL]
    have h2 : 0 < Real.log (Real.log (t * t)) := Real.log_pos h1
    refine div_nonneg ?_ (by positivity)
    nlinarith [h1, h2]
  have h051 : 0 ≤ 0.51 * Real.log t + 2.78 := by nlinarith [hL]
  have heq : Xgrow t =
      Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) + Cf t (t * t) * Kbar (t * t) := by
    unfold Xgrow, Ggrow, Bgrow
    ring
  have hXUB : XUBfun t = (4.98 * Real.log t + 26.55) / (t * t) := by
    unfold XUBfun
    field_simp [htpos.ne']
    ring
  set A2 := 2 + 1 / T0 + 1 / (T0 * T0) with hA2
  set D2 := 1 + 9 / (4 * T0 * T0) + 5 / (2 * T0 * T0 * T0 * T0) with hD2
  have hA2ub : 2 * A2 + 0.51 * D2 ≤ 4.98 := by
    dsimp [A2, D2]
    norm_num [hT0val]
  have hD2ub : 11 * A2 + 2.78 * D2 ≤ 26.55 := by
    dsimp [A2, D2]
    norm_num [hT0val]
  calc Xgrow t
      = Bf t (t * t) * (Sbar (2 * t * t) + Sbar (t * t)) + Cf t (t * t) * Kbar (t * t) := heq
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) + Cf t (t * t) * Kbar (t * t) := by
      gcongr
      · exact hS0
      · rw [show A2 / (t * t) = A2 / (t * t) from rfl]
        exact hBf
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) +
        (2 * t * t + 9 / 2 + 5 / (t * t)) * Kbar (t * t) := by
      gcongr
      · exact hK0
      · exact hC
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) +
        (2 * t * t + 9 / 2 + 5 / (t * t)) / (2 * t * t * t * t) * (0.51 * Real.log t + 2.78) := by
      gcongr
      · positivity
      · exact hK
    _ ≤ A2 / (t * t) * (2 * Real.log t + 11) + D2 / (t * t) * (0.51 * Real.log t + 2.78) := by
      gcongr
      · exact h051
      · exact hD
    _ ≤ (4.98 * Real.log t + 26.55) / (t * t) := by
      have h1 : A2 / (t * t) * (2 * Real.log t + 11) =
          A2 * (2 * Real.log t + 11) / (t * t) := by
        field_simp [htpos.ne']
        ring
      have h2 : D2 / (t * t) * (0.51 * Real.log t + 2.78) =
          D2 * (0.51 * Real.log t + 2.78) / (t * t) := by
        field_simp [htpos.ne']
        ring
      rw [h1, h2]
      have h3 : A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78) ≤
          4.98 * Real.log t + 26.55 := by
        have h3a : A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78) =
            (2 * A2 + 0.51 * D2) * Real.log t + (11 * A2 + 2.78 * D2) := by
          ring
        rw [h3a]
        nlinarith [hA2ub, hD2ub, hL]
      have h4 : A2 * (2 * Real.log t + 11) / (t * t) + D2 * (0.51 * Real.log t + 2.78) / (t * t) =
          (A2 * (2 * Real.log t + 11) + D2 * (0.51 * Real.log t + 2.78)) / (t * t) := by
        field_simp [htpos.ne']
        ring
      rw [h4]
      have h5 : 0 < t * t := by positivity
      rw [div_le_iff h5]
      nlinarith [h3]
    _ = XUBfun t := by rw [hXUB]

/-- XUBfun t ≤ CG2 for t ≥ T0. -/
/- For t ≥ T0: ln t ≤ √t, √t/t² = t^{-3/2} decreasing, √T0 ≤ 332. -/
def T0pow32 : ℝ := T0 ^ (-3 / 2 : ℝ)

theorem hXubEnd (t : ℝ) (ht : T0 ≤ t) : XUBfun t ≤ CG2 := by
  have htpos := hSGtp ht
  have hL : 1 ≤ Real.log t := hLogT1 ht ht
  have hXUB : XUBfun t = (4.98 * Real.log t + 26.55) / (t * t) := by
    unfold XUBfun
    field_simp [htpos.ne']
    ring
  rw [hXUB]
  have h1 : Real.log t ≤ Real.sqrt t := hLogSqrt t (by nlinarith [hT0val, ht])
  have h2 : (4.98 * Real.log t + 26.55) / (t * t) ≤
      4.98 * Real.sqrt t / (t * t) + 26.55 / (t * t) := by
    have h2a : (4.98 * Real.log t + 26.55) / (t * t) =
        4.98 * Real.log t / (t * t) + 26.55 / (t * t) := by
      field_simp [htpos.ne']
      ring
    rw [h2a]
    have h2b : 4.98 * Real.log t / (t * t) ≤ 4.98 * Real.sqrt t / (t * t) := by
      have h2c : 4.98 * Real.log t ≤ 4.98 * Real.sqrt t :=
        mul_le_mul_of_nonneg_left h1 (by norm_num)
      have h2d : 4.98 * Real.log t / (t * t) =
          (4.98 * Real.log t) * (1 / (t * t)) := by rw [div_eq_mul_inv]
      have h2e : 4.98 * Real.sqrt t / (t * t) =
          (4.98 * Real.sqrt t) * (1 / (t * t)) := by rw [div_eq_mul_inv]
      rw [h2d, h2e]
      exact mul_le_mul_of_nonneg_right h2c (by positivity)
    nlinarith [h2b]
  have h3 : 4.98 * Real.sqrt t / (t * t) = 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) := by
    have h1 : Real.sqrt t / (t * t) = (t : ℝ) ^ (-3 / 2 : ℝ) := by
      have h1a : Real.sqrt t = (t : ℝ) ^ (1 / 2 : ℝ) := by rw [Real.sqrt_eq_rpow t]
      have h1b : (t * t : ℝ) = (t : ℝ) ^ (2 : ℝ) := by
        rw [show (2 : ℝ) = 1 + 1 from by norm_num,
            Real.rpow_add (by positivity : 0 ≤ t) 1 1, Real.rpow_one, Real.rpow_one]
      have h1c : (t : ℝ) ^ (1 / 2 : ℝ) / (t : ℝ) ^ (2 : ℝ) = (t : ℝ) ^ (-3 / 2 : ℝ) := by
        have h1d : ((t : ℝ) ^ (2 : ℝ))⁻¹ = (t : ℝ) ^ (-2 : ℝ) := by
          rw [Real.rpow_neg (by positivity : 0 ≤ t) 2]
        have h1e : (t : ℝ) ^ (1 / 2 : ℝ) / (t : ℝ) ^ (2 : ℝ) =
            (t : ℝ) ^ (1 / 2 : ℝ) * ((t : ℝ) ^ (2 : ℝ))⁻¹ := by
          rw [div_eq_mul_inv]
        rw [h1e, h1d, show (-3 / 2 : ℝ) = (1 / 2 : ℝ) + (-2 : ℝ) from by norm_num,
            Real.rpow_add (by positivity : 0 ≤ t) (1 / 2) (-2)]
      rw [h1a, h1b, h1c]
    rw [h1]
  rw [h3]
  have h4 : (t : ℝ) ^ (-3 / 2 : ℝ) ≤ T0 ^ (-3 / 2 : ℝ) := by
    have h4a : (t : ℝ) ^ (-3 / 2 : ℝ) = 1 / (t : ℝ) ^ (3 / 2 : ℝ) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
          Real.rpow_neg (by positivity : 0 ≤ t) (3 / 2)]
    have h4b : (T0 : ℝ) ^ (-3 / 2 : ℝ) = 1 / (T0 : ℝ) ^ (3 / 2 : ℝ) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
          Real.rpow_neg (by positivity : 0 ≤ T0) (3 / 2)]
    rw [h4a, h4b]
    apply one_div_le_one_div_of_le
    · positivity
    · exact Real.rpow_le_rpow (by positivity : 0 ≤ T0) ht (by norm_num)
  have h8 : 26.55 / (t * t) ≤ 26.55 / (T0 * T0) := by
    have h1 : 1 / (t * t) ≤ 1 / (T0 * T0) :=
      one_div_le_one_div_of_le (by positivity) (hSGtsq ht)
    have h1b : 26.55 / (t * t) = 26.55 * (1 / (t * t)) := by ring
    have h1c : 26.55 / (T0 * T0) = 26.55 * (1 / (T0 * T0)) := by ring
    rw [h1b, h1c]
    exact mul_le_mul_of_nonneg_left h1 (by norm_num)
  have h5 : 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) + 26.55 / (t * t) ≤
      4.98 * T0 ^ (-3 / 2 : ℝ) + 26.55 / (T0 * T0) := by
    have h5a : 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) ≤ 4.98 * T0 ^ (-3 / 2 : ℝ) :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    nlinarith [h5a, h8]
  have h6 : T0 ^ (-3 / 2 : ℝ) = Real.sqrt T0 / (T0 * T0) := by
    have h1 : T0 ^ (-3 / 2 : ℝ) = 1 / (T0 ^ (3 / 2 : ℝ)) := by
      rw [show (-3 / 2 : ℝ) = -(3 / 2) from by norm_num,
          Real.rpow_neg (by positivity : 0 ≤ T0) (3 / 2)]
    have h2 : T0 ^ (3 / 2 : ℝ) = T0 * Real.sqrt T0 := by
      rw [show (3 / 2 : ℝ) = 1 + 1 / 2 from by norm_num,
          Real.rpow_add (by positivity : 0 ≤ T0) 1 (1 / 2), Real.rpow_one]
      have h3 : (T0 : ℝ) ^ (1 / 2 : ℝ) = Real.sqrt T0 := by rw [Real.sqrt_eq_rpow T0]
      rw [h3]
    have hsq : (Real.sqrt T0) ^ 2 = T0 := by
      rw [Real.sq_sqrt (by positivity : 0 ≤ T0)]
    rw [h1, h2]
    field_simp [hSGT0pos.ne', hsq]
    ring
  have h7 : 4.98 * T0 ^ (-3 / 2 : ℝ) ≤ 4.98 * 332 / (T0 * T0) := by
    rw [h6]
    calc 4.98 * (Real.sqrt T0 / (T0 * T0))
        = (4.98 * Real.sqrt T0) * (1 / (T0 * T0)) := by
          rw [div_eq_mul_inv]
          ring
      _ ≤ (4.98 * 332) * (1 / (T0 * T0)) := by
          have h1 : 4.98 * Real.sqrt T0 ≤ 4.98 * 332 :=
            mul_le_mul_of_nonneg_left hT0sqrt (by norm_num)
          exact mul_le_mul_of_nonneg_right h1 (by positivity)
      _ = 4.98 * 332 / (T0 * T0) := by
          rw [div_eq_mul_inv]
          ring
  calc (4.98 * Real.log t + 26.55) / (t * t)
      ≤ 4.98 * Real.sqrt t / (t * t) + 26.55 / (t * t) := h2
    _ = 4.98 * (t : ℝ) ^ (-3 / 2 : ℝ) + 26.55 / (t * t) := by rw [h3]
    _ ≤ 4.98 * T0 ^ (-3 / 2 : ℝ) + 26.55 / (T0 * T0) := h5
    _ ≤ 4.98 * 332 / (T0 * T0) + 26.55 / (T0 * T0) := by
      gcongr
      · exact h7
      · norm_num
    _ = (4.98 * 332 + 26.55) / (T0 * T0) := by
      field_simp [hSGT0pos]
      ring
    _ ≤ CG2 := by
      norm_num [CG2, hT0val]
