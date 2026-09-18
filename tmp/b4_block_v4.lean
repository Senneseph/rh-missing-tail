/- 25ae Stage 3B.11 - Part B, batch 4: monotonicity / endpoint bounds / final wall.
   Architecture (exact record: scripts/rh/day026_25ae_t3wallB.py):
     * i = 2,4,6 : num_i < 0 for all t > 0  =>  h_i < 0  =>  R_i strictly
       decreasing on [13, 1e8]  =>  R_i(t) <= R_i(13) < K_i (endpoint).
     * i = 7     : num_7 has a unique zero z* in (13, 20) (batch 2 single-zero
       + batch 4 IVT)  =>  R_7 decreases on [13, z*], increases on [z*, 1e8]
       =>  R_7(t) <= max(R_7(13), R_7(1e8)) = R_7(1e8)  (R_7(13) < R_7(1e8)
       via B7_13 < LB7_1e8)  <= K_7.
     * K_2 + K_4 + K_6 + K_7 < 1 (exact, norm_num)  =>  sum_i R_i(t) < 1 on
       [13, 1e8]  =>  t3w_T3UB n t < t3wB_target t (floor-corrected terms).
   Endpoint bounds are proven by SQUARING: R_i(T)^2 is a pure rational whose
   exact value is given (literal) and compared against K_i^2 / LB^2 by
   norm_num.  Mathlib pins: intermediate_value_Ioo / Ioo' (subset form),
   exists_deriv_eq_slope, rpow_add, rpow_neg, rpow_natCast, rpow_pos_of_pos,
   inv_le_inv0, one_div_lt_one_div, Real.mul_self_sqrt, lt_trichotomous-free
   sign arguments (by_cases + not_lt / not_le), Int.floor_eq_iff /
   Int.le_floor / Int.toNat_of_nonneg / floor_lt (nat floor) / lt_succ_floor. -/
set_option maxSynthPendingDepth 8

-- ---------------------------------------------------------------- rpow helpers

/-- x^(-1/2) = 1 / sqrt(x) for x > 0. -/
theorem t3wB_rpow_neg_half (a : ℝ) (ha : 0 < a) : a ^ (-1/2 : ℝ) = 1 / Real.sqrt a := by
  have heq : (-1/2 : ℝ) = -(1/2 : ℝ) := by ring
  have heq2 : a ^ (1/2 : ℝ) = Real.sqrt a := (sqrt_eq_rpow a).symm
  calc
    a ^ (-1/2 : ℝ) = (a ^ (1/2 : ℝ))⁻¹ := by rw [heq, rpow_neg (le_of_lt ha) ((1/2 : ℝ))]
    _ = (Real.sqrt a)⁻¹ := by rw [heq2]
    _ = 1 / Real.sqrt a := by ring

/-- (x^(-p))^2 = x^(-2p) for x > 0. -/
theorem t3wB_rpow_sq_neg {x : ℝ} (hx : 0 < x) (p : ℝ) :
    (x ^ (-p : ℝ)) ^ 2 = x ^ (-(2 * p) : ℝ) := by
  have heq : (-p : ℝ) + (-p : ℝ) = -(2 * p) := by ring
  calc
    (x ^ (-p : ℝ)) ^ 2 = x ^ (-p : ℝ) * x ^ (-p : ℝ) := by rw [pow_two]
    _ = x ^ ((-p : ℝ) + (-p : ℝ)) := by rw [← rpow_add hx]
    _ = x ^ (-(2 * p) : ℝ) := by rw [heq]

/-- (x^(1/2))^2 = x for x > 0. -/
theorem t3wB_rpow_half_sq (x : ℝ) (hx : 0 < x) : (x ^ (1/2 : ℝ)) ^ 2 = x := by
  have heq : (1/2 : ℝ) + (1/2 : ℝ) = 1 := by norm_num
  calc
    (x ^ (1/2 : ℝ)) ^ 2 = x ^ (1/2 : ℝ) * x ^ (1/2 : ℝ) := by rw [pow_two]
    _ = x ^ ((1/2 : ℝ) + (1/2 : ℝ)) := by rw [← rpow_add hx]
    _ = x ^ (1 : ℝ) := by rw [heq]
    _ = x := by rw [Real.rpow_one]

/-- b^(-p) ≤ a^(-p) for 0 < a ≤ b, p > 0 (x ↦ x^(-p) is decreasing). -/
theorem t3wB_rpow_negp_le {a b p : ℝ} (ha : 0 < a) (hab : a ≤ b) (hp : 0 < p) :
    b ^ (-p) ≤ a ^ (-p) := by
  have hba : 0 < b := by linarith [ha, hab]
  have heq : -p = -(p : ℝ) := by ring
  calc
    b ^ (-p) = (b ^ p)⁻¹ := by rw [heq, rpow_neg (le_of_lt hba) p]
    _ ≤ (a ^ p)⁻¹ := by
      exact (inv_le_inv₀ (rpow_pos_of_pos hba p) (rpow_pos_of_pos ha p)).mpr
        (rpow_le_rpow (le_of_lt ha) hab (le_of_lt hp))
    _ = a ^ (-p) := by rw [heq, rpow_neg (le_of_lt ha) p]

/-- b^(-1/2) ≤ a^(-1/2) for 0 < a ≤ b. -/
theorem t3wB_invpow12_mono {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    b ^ (-1/2 : ℝ) ≤ a ^ (-1/2 : ℝ) := by
  have hba : 0 < b := by linarith [ha, hab]
  rw [t3wB_rpow_neg_half b hba, t3wB_rpow_neg_half a ha]
  rw [one_div_le_one_div (Real.sqrt_pos.mpr ha) (Real.sqrt_pos.mpr hba)]
  exact Real.sqrt_le_sqrt hab

/-- num_7 is differentiable (hence continuous) everywhere: flat polynomial. -/
theorem t3wB_num7_differentiable : Differentiable ℝ t3wB_num7 := by
  intro _
  dsimp only [t3wB_num7]
  differentiability

-- ---------------------------------------------------------------- positivity

/-- `0 < R_i(t)` for `i ∈ {2,4,6,7}`, `t ≥ 13`. -/
theorem t3wB_R_pos {i : ℕ} (hii : i ∈ ({2, 4, 6, 7} : Finset ℕ)) {t : ℝ} (ht : 13 ≤ t) :
    0 < t3wB_R i t := by
  dsimp only [t3wB_R]
  have hbase : 0 < 13 * t / 8 - 1 := by linarith [ht]
  have hlt : 0 < 13 * t / 8 := by linarith [ht]
  have hmem0 : i = 2 ∨ i = 4 ∨ i = 6 ∨ i = 7 := by
    simp only [Finset.mem_insert, Finset.mem_singleton] at hii
    tauto
  apply mul_pos
  · apply Real.sqrt_pos.mpr
    dsimp only [t3w_prod]
    apply Finset.prod_pos
    intro k hk
    positivity
  · exact rpow_pos_of_pos hbase (-(t3w_p i))
  · apply div_pos
    · apply mul_pos
      · apply mul_pos
        · norm_num
        · exact rpow_pos_of_pos hlt (1/2 : ℝ)
      · norm_num
    · rcases hmem0 with (h2 | h4 | h6 | h7)
      · rw [h2]
        norm_num [t3w_d]
      · rw [h4]
        norm_num [t3w_d]
      · rw [h6]
        norm_num [t3w_d]
      · rw [h7]
        norm_num [t3w_d]

-- ---------------------------------------------------------------- MVT transport

/-- MVT sign transport: derivative of R_i negative on all of (a, b) with
    13 ≤ a < b ≤ 1e8 implies R_i b < R_i a. -/
theorem t3wB_R_strict_anti (i : ℕ) (hmem : i ∈ ({2, 4, 6, 7} : Finset ℕ))
    {a b : ℝ} (ha : 13 ≤ a) (hab : a < b) (hb : b ≤ (10 : ℝ) ^ 8)
    (hderivneg : ∀ x, a < x → x < b → deriv (fun t : ℝ => t3wB_R i t) x < 0) :
    t3wB_R i b < t3wB_R i a := by
  have hDO : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := by
    intro x hx
    have hx13 : 13 ≤ x := by linarith [ha, hx.1]
    exact (t3wB_RhasDerivAt i hmem hx13).differentiableAt
  have hCO : ContinuousOn (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := hDO.continuousOn
  have hDOo : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Ioo a b) := by
    intro x hx
    have hx13 : 13 ≤ x := by linarith [ha, hx.1]
    exact (t3wB_RhasDerivAt i hmem hx13).differentiableAt
  obtain ⟨c, hc, hcd⟩ : ∃ c ∈ Set.Ioo a b, deriv (fun x : ℝ => t3wB_R i x) c =
      (t3wB_R i b - t3wB_R i a) / (b - a) :=
    exists_deriv_eq_slope (fun x : ℝ => t3wB_R i x) hab hCO hDOo
  have hcneg : deriv (fun x : ℝ => t3wB_R i x) c < 0 := hderivneg c hc.1 hc.2
  have hab0 : 0 < b - a := by linarith [hab]
  have hq : (t3wB_R i b - t3wB_R i a) / (b - a) < 0 := by rw [← hcd]; exact hcneg
  have hdiffneg : t3wB_R i b - t3wB_R i a < 0 := by
    rcases (div_neg_iff).1 hq with (hleft | hright)
    · exact hleft.2
    · exfalso
      linarith [hab0, hright.1]
  linarith [hdiffneg]

/-- Dual: derivative of R_i positive on (a, b) implies R_i a < R_i b. -/
theorem t3wB_R_strict_inc (i : ℕ) (hmem : i ∈ ({2, 4, 6, 7} : Finset ℕ))
    {a b : ℝ} (ha : 13 ≤ a) (hab : a < b) (hb : b ≤ (10 : ℝ) ^ 8)
    (hderivpos : ∀ x, a < x → x < b → 0 < deriv (fun t : ℝ => t3wB_R i t) x) :
    t3wB_R i a < t3wB_R i b := by
  have hDO : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := by
    intro x hx
    have hx13 : 13 ≤ x := by linarith [ha, hx.1]
    exact (t3wB_RhasDerivAt i hmem hx13).differentiableAt
  have hCO : ContinuousOn (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := hDO.continuousOn
  have hDOo : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Ioo a b) := by
    intro x hx
    have hx13 : 13 ≤ x := by linarith [ha, hx.1]
    exact (t3wB_RhasDerivAt i hmem hx13).differentiableAt
  obtain ⟨c, hc, hcd⟩ : ∃ c ∈ Set.Ioo a b, deriv (fun x : ℝ => t3wB_R i x) c =
      (t3wB_R i b - t3wB_R i a) / (b - a) :=
    exists_deriv_eq_slope (fun x : ℝ => t3wB_R i x) hab hCO hDOo
  have hnpos : 0 < deriv (fun x : ℝ => t3wB_R i x) c := hderivpos c hc.1 hc.2
  have hab0 : 0 < b - a := by linarith [hab]
  have hq : 0 < (t3wB_R i b - t3wB_R i a) / (b - a) := by rw [← hcd]; exact hnpos
  have hdiffpos : 0 < t3wB_R i b - t3wB_R i a := by
    rcases (div_pos_iff).1 hq with (hleft | hright)
    · exact hleft.2
    · exfalso
      linarith [hab0, hright.1]
  linarith [hdiffpos]

/-- R_i strictly decreasing on [13, 1e8] for i ∈ {2,4,6} (num_i < 0). -/
theorem t3wB_R246_anti {i : ℕ} (hi : i ∈ ({2, 4, 6} : Finset ℕ)) {t u : ℝ}
    (ht : 13 ≤ t) (htu : t < u) (hu : u ≤ (10 : ℝ) ^ 8) : t3wB_R i u < t3wB_R i t := by
  have hmemi : i = 2 ∨ i = 4 ∨ i = 6 := by
    simp only [Finset.mem_insert, Finset.mem_singleton] at hi
    tauto
  have hmem : i ∈ ({2, 4, 6, 7} : Finset ℕ) := by
    rcases hmemi with (h2 | h4 | h6)
    · rw [h2]
      simp
    · rw [h4]
      simp
    · rw [h6]
      simp
  have hderivneg : ∀ x, t < x → x < u → deriv (fun w : ℝ => t3wB_R i w) x < 0 := by
    intro x hx1 hx2
    have hx13 : 13 ≤ x := by linarith [ht, hx1]
    have hx0 : 0 < x := by linarith [hx13]
    have hR : 0 < t3wB_R i x := t3wB_R_pos hmem hx13
    have hd : 0 < t3wB_den i x := t3wB_den_pos hx13
    have hnum : t3wB_num i x < 0 := by
      rcases hmemi with (h2 | h4 | h6)
      · rw [h2]
        norm_num [t3wB_num]
        exact t3wB_num2_neg hx0
      · rw [h4]
        norm_num [t3wB_num]
        exact t3wB_num4_neg hx0
      · rw [h6]
        norm_num [t3wB_num]
        exact t3wB_num6_neg hx0
    have hq : t3wB_num i x / t3wB_den i x < 0 := div_neg_of_neg_of_pos hnum hd
    have hcd : deriv (fun w : ℝ => t3wB_R i w) x =
        t3wB_R i x * (t3wB_num i x / t3wB_den i x) :=
      (t3wB_RhasDerivAt i hmem hx13).deriv
    rw [hcd]
    nlinarith [hR, hq]
  exact t3wB_R_strict_anti i hmem ht htu hu hderivneg

/-- R_i(t) ≤ R_i(13) for i ∈ {2,4,6}, t ∈ [13, 1e8]. -/
theorem t3wB_R246_le_13 {i : ℕ} (hi : i ∈ ({2, 4, 6} : Finset ℕ)) {t : ℝ}
    (ht : 13 ≤ t) (ht8 : t ≤ (10 : ℝ) ^ 8) : t3wB_R i t ≤ t3wB_R i 13 := by
  by_cases hte13 : t = 13
  · simpa [hte13]
  · exact le_of_lt (t3wB_R246_anti hi (by norm_num) (lt_of_le_of_ne ht (Ne.symm hte13)) ht8)

-- ---------------------------------------------------------------- i = 7 valley structure

/-- num_7 has a zero in the open interval (13, 20). -/
theorem t3wB_num7_zero_in_13_20 : ∃ z, 13 < z ∧ z < 20 ∧ t3wB_num7 z = 0 := by
  have hcont : ContinuousOn t3wB_num7 (Set.Icc 13 20) :=
    t3wB_num7_differentiable.continuous.continuousOn
  have hgate := t3wB_num7_gate
  have himg0 : (0 : ℝ) ∈ Set.Ioo (t3wB_num7 13) (t3wB_num7 20) := ⟨hgate.1, hgate.2⟩
  have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ioo 13 20 :=
    (intermediate_value_Ioo (by norm_num) hcont) himg0
  obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ioo 13 20, t3wB_num7 w = 0 := by
    simpa [Set.mem_image] using hsub
  exact ⟨w, hwm.1, hwm.2, hwz⟩

/-- num_7 < 0 on [13, z) given 13 < z and num_7 z = 0. -/
theorem t3wB_num7_sign_left {z t : ℝ} (h13z : 13 < z) (hz0 : t3wB_num7 z = 0)
    (ht : 13 ≤ t) (htz : t < z) : t3wB_num7 t < 0 := by
  by_contra hnn
  by_cases hz_t : t3wB_num7 t = 0
  · exact t3wB_num7_single_zero t z (by linarith [ht]) htz hz_t hz0
  · have hpos : 0 < t3wB_num7 t := by
      have hge : (0 : ℝ) ≤ t3wB_num7 t := not_lt.mp hnn
      exact lt_of_le_of_ne hge hz_t.symm
    by_cases ht13 : t = 13
    · rw [ht13]
      linarith [t3wB_num7_gate.1, hpos]
    · have ht13s : 13 < t := lt_of_le_of_ne ht (Ne.symm ht13)
      have hcont : ContinuousOn t3wB_num7 (Set.Icc 13 t) :=
        t3wB_num7_differentiable.continuous.continuousOn
      have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ioo 13 t :=
        (intermediate_value_Ioo ht13s hcont) ⟨t3wB_num7_gate.1, hpos⟩
      obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ioo 13 t, t3wB_num7 w = 0 := by
        simpa [Set.mem_image] using hsub
      exact t3wB_num7_single_zero w z (by linarith [hwm.1]) (lt_trans hwm.2 htz) hwz hz0

/-- num_7 > 0 on (z, ∞) given 13 < z and num_7 z = 0. -/
theorem t3wB_num7_sign_right {z t : ℝ} (h13z : 13 < z) (hz0 : t3wB_num7 z = 0)
    (htz : z < t) : 0 < t3wB_num7 t := by
  by_contra hnn
  by_cases hz_t : t3wB_num7 t = 0
  · exact t3wB_num7_single_zero z t (by linarith [h13z]) htz hz0 hz_t
  · have hle : t3wB_num7 t ≤ 0 := not_lt.mp hnn
    have hneg : t3wB_num7 t < 0 := lt_of_le_of_ne hle hz_t.symm
    by_cases hz20 : z < 20
    · -- z < 20: contradiction via a fresh zero between t and 20 (or 20 and t)
      by_cases ht20 : t < 20
      · have hcont : ContinuousOn t3wB_num7 (Set.Icc t 20) :=
          t3wB_num7_differentiable.continuous.continuousOn
        have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ioo t 20 :=
          (intermediate_value_Ioo ht20 hcont) ⟨hneg, t3wB_num7_gate.2⟩
        obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ioo t 20, t3wB_num7 w = 0 := by
          simpa [Set.mem_image] using hsub
        exact t3wB_num7_single_zero z w (by linarith [h13z]) (lt_trans hz20 hwm.1) hz0 hwz
      · by_cases hte20 : t = 20
        · rw [hte20]
          linarith [t3wB_num7_gate.2, hneg]
        · have ht20ge : (20 : ℝ) ≤ t := by
            by_contra h
            exact hte20 (le_antisymm (by linarith [h]) (by linarith [ht20]))
          have ht20s : 20 < t := lt_of_le_of_ne ht20ge (Ne.symm hte20)
          have hcont : ContinuousOn t3wB_num7 (Set.Icc 20 t) :=
            t3wB_num7_differentiable.continuous.continuousOn
          have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ioo 20 t :=
            (intermediate_value_Ioo' ht20ge hcont) ⟨hneg, t3wB_num7_gate.2⟩
          obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ioo 20 t, t3wB_num7 w = 0 := by
            simpa [Set.mem_image] using hsub
          exact t3wB_num7_single_zero z w (by linarith [h13z]) (lt_trans hz20 hwm.1) hz0 hwz
    · -- z ≥ 20: the (13,20)-zero z0 is a second zero, contradicting uniqueness
      obtain ⟨z0, hz013, hz020, hz0z⟩ := t3wB_num7_zero_in_13_20
      exact t3wB_num7_single_zero z0 z (by linarith [hz013])
        (lt_of_lt_of_le hz020 (not_lt.mp hz20)) hz0z hz0

-- ---------------------------------------------------------------- endpoint squares
-- Each proof: dsimp + numeric normalization, then a block-form calc turning
-- R_i(T)^2 into  A * B * C, with A = t3w_prod(T,i), B = (161/8 or
-- 162499999)^(-odd), C = 4*c*(78/70)^2/d^2, closed by one norm_num [t3w_prod]
-- against the exact Python-generated rational literal.

/-- R_2(13)^2 = exact rational. -/
theorem t3wB_R2_13_sq : (t3wB_R 2 13 : ℝ) ^ 2 = 118844923935296 / 154571611490816995125 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hnum1 : (13 * 13 / 8 - 1 : ℝ) = 161 / 8 := by norm_num
  have hnum2 : (13 * 13 / 8 : ℝ) = 169 / 8 := by norm_num
  rw [hnum1, hnum2]
  have hbase : (0 : ℝ) < 161 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 2 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : Real.sqrt (t3w_prod 13 2) * Real.sqrt (t3w_prod 13 2) = t3w_prod 13 2 := by
    rw [← pow_two, Real.mul_self_sqrt hprod]
  have h2 : ((161 / 8 : ℝ) ^ (-(7/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-7 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (7/2 : ℝ)]
    norm_num
  have heq : (-7 : ℝ) = -((7 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-7 : ℝ) = ((161 / 8 : ℝ) ^ 7)⁻¹ := by
    rw [heq, rpow_neg hbase.le (7 : ℝ)]
    try rw [show (161 / 8 : ℝ) ^ (7 : ℝ) = (161 / 8 : ℝ) ^ 7 from
      rpow_natCast (161 / 8 : ℝ) 7]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 720 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) (by norm_num)]
    ring
  calc
    (Real.sqrt (t3w_prod 13 2) * ((161 / 8 : ℝ)) ^ (-(7/2 : ℝ)) *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720)) ^ 2 =
      Real.sqrt (t3w_prod 13 2) * Real.sqrt (t3w_prod 13 2) *
        ((161 / 8 : ℝ) ^ (-(7/2 : ℝ))) ^ 2 *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 := by ring
    _ = Real.sqrt (t3w_prod 13 2) * Real.sqrt (t3w_prod 13 2) *
          (161 / 8 : ℝ) ^ (-7 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 := by rw [h2]
    _ = t3w_prod 13 2 * (161 / 8 : ℝ) ^ (-7 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 := by rw [h1]
    _ = t3w_prod 13 2 * ((161 / 8 : ℝ) ^ 7)⁻¹ *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 := by rw [h4]
    _ = t3w_prod 13 2 * ((161 / 8 : ℝ) ^ 7)⁻¹ *
          ((4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 720 ^ 2) := by rw [hC]
    _ = 118844923935296 / 154571611490816995125 := by norm_num [t3w_prod]

/-- R_4(13)^2 = exact rational. -/
theorem t3wB_R4_13_sq : (t3wB_R 4 13 : ℝ) ^ 2 =
    166976167369699397632 / 1832026787852958362589213845205 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hnum1 : (13 * 13 / 8 - 1 : ℝ) = 161 / 8 := by norm_num
  have hnum2 : (13 * 13 / 8 : ℝ) = 169 / 8 := by norm_num
  rw [hnum1, hnum2]
  have hbase : (0 : ℝ) < 161 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 4 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : Real.sqrt (t3w_prod 13 4) * Real.sqrt (t3w_prod 13 4) = t3w_prod 13 4 := by
    rw [← pow_two, Real.mul_self_sqrt hprod]
  have h2 : ((161 / 8 : ℝ) ^ (-(11/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-11 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (11/2 : ℝ)]
    norm_num
  have heq : (-11 : ℝ) = -((11 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-11 : ℝ) = ((161 / 8 : ℝ) ^ 11)⁻¹ := by
    rw [heq, rpow_neg hbase.le (11 : ℝ)]
    try rw [show (161 / 8 : ℝ) ^ (11 : ℝ) = (161 / 8 : ℝ) ^ 11 from
      rpow_natCast (161 / 8 : ℝ) 11]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 30240 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) (by norm_num)]
    ring
  calc
    (Real.sqrt (t3w_prod 13 4) * ((161 / 8 : ℝ)) ^ (-(11/2 : ℝ)) *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240)) ^ 2 =
      Real.sqrt (t3w_prod 13 4) * Real.sqrt (t3w_prod 13 4) *
        ((161 / 8 : ℝ) ^ (-(11/2 : ℝ))) ^ 2 *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 := by ring
    _ = Real.sqrt (t3w_prod 13 4) * Real.sqrt (t3w_prod 13 4) *
          (161 / 8 : ℝ) ^ (-11 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 := by rw [h2]
    _ = t3w_prod 13 4 * (161 / 8 : ℝ) ^ (-11 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 := by rw [h1]
    _ = t3w_prod 13 4 * ((161 / 8 : ℝ) ^ 11)⁻¹ *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 := by rw [h4]
    _ = t3w_prod 13 4 * ((161 / 8 : ℝ) ^ 11)⁻¹ *
          ((4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 30240 ^ 2) := by rw [hC]
    _ = 166976167369699397632 / 1832026787852958362589213845205 := by norm_num [t3w_prod]

/-- R_6(13)^2 = exact rational. -/
theorem t3wB_R6_13_sq : (t3wB_R 6 13 : ℝ) ^ 2 =
    89962083646107683860987904 / 6154677881116414452349664940830428922025 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hnum1 : (13 * 13 / 8 - 1 : ℝ) = 161 / 8 := by norm_num
  have hnum2 : (13 * 13 / 8 : ℝ) = 169 / 8 := by norm_num
  rw [hnum1, hnum2]
  have hbase : (0 : ℝ) < 161 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 6 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : Real.sqrt (t3w_prod 13 6) * Real.sqrt (t3w_prod 13 6) = t3w_prod 13 6 := by
    rw [← pow_two, Real.mul_self_sqrt hprod]
  have h2 : ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-15 : ℝ) = ((161 / 8 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ)]
    try rw [show (161 / 8 : ℝ) ^ (15 : ℝ) = (161 / 8 : ℝ) ^ 15 from
      rpow_natCast (161 / 8 : ℝ) 15]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 1209600 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) (by norm_num)]
    ring
  calc
    (Real.sqrt (t3w_prod 13 6) * ((161 / 8 : ℝ)) ^ (-(15/2 : ℝ)) *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600)) ^ 2 =
      Real.sqrt (t3w_prod 13 6) * Real.sqrt (t3w_prod 13 6) *
        ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 := by ring
    _ = Real.sqrt (t3w_prod 13 6) * Real.sqrt (t3w_prod 13 6) *
          (161 / 8 : ℝ) ^ (-15 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 := by rw [h2]
    _ = t3w_prod 13 6 * (161 / 8 : ℝ) ^ (-15 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 := by rw [h1]
    _ = t3w_prod 13 6 * ((161 / 8 : ℝ) ^ 15)⁻¹ *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 := by rw [h4]
    _ = t3w_prod 13 6 * ((161 / 8 : ℝ) ^ 15)⁻¹ *
          ((4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 1209600 ^ 2) := by rw [hC]
    _ = 89962083646107683860987904 / 6154677881116414452349664940830428922025 := by norm_num [t3w_prod]

/-- R_7(13)^2 = exact rational. -/
theorem t3wB_R7_13_sq : (t3wB_R 7 13 : ℝ) ^ 2 =
    81055837365143023158750101504 / 1384802523251193251778674611686846507455625 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hnum1 : (13 * 13 / 8 - 1 : ℝ) = 161 / 8 := by norm_num
  have hnum2 : (13 * 13 / 8 : ℝ) = 169 / 8 := by norm_num
  rw [hnum1, hnum2]
  have hbase : (0 : ℝ) < 161 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 7 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : Real.sqrt (t3w_prod 13 7) * Real.sqrt (t3w_prod 13 7) = t3w_prod 13 7 := by
    rw [← pow_two, Real.mul_self_sqrt hprod]
  have h2 : ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-15 : ℝ) = ((161 / 8 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ)]
    try rw [show (161 / 8 : ℝ) ^ (15 : ℝ) = (161 / 8 : ℝ) ^ 15 from
      rpow_natCast (161 / 8 : ℝ) 15]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 9072000 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) (by norm_num)]
    ring
  calc
    (Real.sqrt (t3w_prod 13 7) * ((161 / 8 : ℝ)) ^ (-(15/2 : ℝ)) *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000)) ^ 2 =
      Real.sqrt (t3w_prod 13 7) * Real.sqrt (t3w_prod 13 7) *
        ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 *
        (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by ring
    _ = Real.sqrt (t3w_prod 13 7) * Real.sqrt (t3w_prod 13 7) *
          (161 / 8 : ℝ) ^ (-15 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h2]
    _ = t3w_prod 13 7 * (161 / 8 : ℝ) ^ (-15 : ℝ) *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h1]
    _ = t3w_prod 13 7 * ((161 / 8 : ℝ) ^ 15)⁻¹ *
          (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h4]
    _ = t3w_prod 13 7 * ((161 / 8 : ℝ) ^ 15)⁻¹ *
          ((4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 9072000 ^ 2) := by rw [hC]
    _ = 81055837365143023158750101504 / 1384802523251193251778674611686846507455625 := by norm_num [t3w_prod]

/-- R_7(1e8)^2 = exact rational. -/
theorem t3wB_R7_1e8_sq : (t3wB_R 7 ((10 : ℝ) ^ 8) : ℝ) ^ 2 =
    14398259200000244770406400001614872756224005272201572352009007288401013767837884111715843115050092587181234200281095880009027100280323125 /
    21360431829313261673820000841563695299036580953278545649660396368733132229015023167121415547283983009835047816936714803783124645176147968 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hT : (13 * ((10 : ℝ) ^ 8) / 8 - 1 : ℝ) = 162499999 := by norm_num
  have hTc : (13 * ((10 : ℝ) ^ 8) / 8 : ℝ) = 162500000 := by norm_num
  rw [hT, hTc]
  have hbase : (0 : ℝ) < 162499999 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod ((10 : ℝ) ^ 8) 7 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) *
      Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) = t3w_prod ((10 : ℝ) ^ 8) 7 := by
    rw [← pow_two, Real.mul_self_sqrt hprod]
  have h2 : ((162499999 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (162499999 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (162499999 : ℝ) ^ (-15 : ℝ) = ((162499999 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ)]
    try rw [show (162499999 : ℝ) ^ (15 : ℝ) = (162499999 : ℝ) ^ 15 from
      rpow_natCast (162499999 : ℝ) 15]
  have hC : (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 =
      (4 * (162500000 : ℝ) * (78/70) ^ 2) / 9072000 ^ 2 := by
    ring_nf
    rw [show ((162500000 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (162500000 : ℝ) from
      t3wB_rpow_half_sq (162500000 : ℝ) (by norm_num)]
    ring
  calc
    (Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) * (162499999 : ℝ) ^ (-(15/2 : ℝ)) *
        (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000)) ^ 2 =
      Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) * Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) *
        ((162499999 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 *
        (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by ring
    _ = Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) * Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) *
          (162499999 : ℝ) ^ (-15 : ℝ) *
          (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h2]
    _ = t3w_prod ((10 : ℝ) ^ 8) 7 * (162499999 : ℝ) ^ (-15 : ℝ) *
          (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h1]
    _ = t3w_prod ((10 : ℝ) ^ 8) 7 * ((162499999 : ℝ) ^ 15)⁻¹ *
          (2 * (162500000 : ℝ) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 := by rw [h4]
    _ = t3w_prod ((10 : ℝ) ^ 8) 7 * ((162499999 : ℝ) ^ 15)⁻¹ *
          ((4 * (162500000 : ℝ) * (78/70) ^ 2) / 9072000 ^ 2) := by rw [hC]
    _ = 14398259200000244770406400001614872756224005272201572352009007288401013767837884111715843115050092587181234200281095880009027100280323125 /
        21360431829313261673820000841563695299036580953278545649660396368733132229015023167121415547283983009835047816936714803783124645176147968 := by
      norm_num [t3w_prod]

-- ---------------------------------------------------------------- endpoint bounds

/-- R_2(13) < K_2 (squaring; both positive). -/
theorem t3wB_R2_13_lt_K2 : t3wB_R 2 13 < t3wB_K2 := by
  have hsq : (t3wB_R 2 13 : ℝ) ^ 2 < t3wB_K2 ^ 2 := by
    rw [t3wB_R2_13_sq]
    norm_num [t3wB_K2]
  have hR : 0 < t3wB_R 2 13 := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_K2 := by norm_num [t3wB_K2]
  nlinarith [hsq, hR, hK]

/-- R_4(13) < K_4. -/
theorem t3wB_R4_13_lt_K4 : t3wB_R 4 13 < t3wB_K4 := by
  have hsq : (t3wB_R 4 13 : ℝ) ^ 2 < t3wB_K4 ^ 2 := by
    rw [t3wB_R4_13_sq]
    norm_num [t3wB_K4]
  have hR : 0 < t3wB_R 4 13 := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_K4 := by norm_num [t3wB_K4]
  nlinarith [hsq, hR, hK]

/-- R_6(13) < K_6. -/
theorem t3wB_R6_13_lt_K6 : t3wB_R 6 13 < t3wB_K6 := by
  have hsq : (t3wB_R 6 13 : ℝ) ^ 2 < t3wB_K6 ^ 2 := by
    rw [t3wB_R6_13_sq]
    norm_num [t3wB_K6]
  have hR : 0 < t3wB_R 6 13 := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_K6 := by norm_num [t3wB_K6]
  nlinarith [hsq, hR, hK]

/-- R_7(13) < B7_13 (strict upper bound at 13). -/
theorem t3wB_R7_13_lt_B7_13 : t3wB_R 7 13 < t3wB_B7_13 := by
  have hsq : (t3wB_R 7 13 : ℝ) ^ 2 < t3wB_B7_13 ^ 2 := by
    rw [t3wB_R7_13_sq]
    norm_num [t3wB_B7_13]
  have hR : 0 < t3wB_R 7 13 := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_B7_13 := by norm_num [t3wB_B7_13]
  nlinarith [hsq, hR, hK]

/-- R_7(1e8) < K_7 (strict upper bound at 1e8). -/
theorem t3wB_R7_1e8_lt_K7 : t3wB_R 7 ((10 : ℝ) ^ 8) < t3wB_K7 := by
  have hsq : (t3wB_R 7 ((10 : ℝ) ^ 8) : ℝ) ^ 2 < t3wB_K7 ^ 2 := by
    rw [t3wB_R7_1e8_sq]
    norm_num [t3wB_K7]
  have hR : 0 < t3wB_R 7 ((10 : ℝ) ^ 8) := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_K7 := by norm_num [t3wB_K7]
  nlinarith [hsq, hR, hK]

/-- LB7_1e8 < R_7(1e8) (strict lower bound at 1e8). -/
theorem t3wB_LB7_1e8_lt_R7_1e8 : t3wB_LB7_1e8 < t3wB_R 7 ((10 : ℝ) ^ 8) := by
  have hsq : t3wB_LB7_1e8 ^ 2 < (t3wB_R 7 ((10 : ℝ) ^ 8) : ℝ) ^ 2 := by
    rw [t3wB_R7_1e8_sq]
    norm_num [t3wB_LB7_1e8]
  have hR : 0 < t3wB_R 7 ((10 : ℝ) ^ 8) := t3wB_R_pos (by simp) (by norm_num)
  have hK : 0 < t3wB_LB7_1e8 := by norm_num [t3wB_LB7_1e8]
  nlinarith [hsq, hR, hK]

/-- B7_13 < LB7_1e8, hence R_7(13) < R_7(1e8). -/
theorem t3wB_R7_13_lt_1e8 : t3wB_R 7 13 < t3wB_R 7 ((10 : ℝ) ^ 8) := by
  have hKmid : t3wB_B7_13 < t3wB_LB7_1e8 := by norm_num [t3wB_B7_13, t3wB_LB7_1e8]
  exact lt_trans (t3wB_R7_13_lt_B7_13) (lt_trans hKmid (t3wB_LB7_1e8_lt_R7_1e8))

-- ---------------------------------------------------------------- i = 7 maximum

/-- R_7(t) ≤ R_7(1e8) for all t ∈ [13, 1e8] (valley + endpoint comparison). -/
theorem t3wB_R7_le_1e8 {t : ℝ} (ht : 13 ≤ t) (ht8 : t ≤ (10 : ℝ) ^ 8) :
    t3wB_R 7 t ≤ t3wB_R 7 ((10 : ℝ) ^ 8) := by
  have hmem : (7 : ℕ) ∈ ({2, 4, 6, 7} : Finset ℕ) := by simp
  obtain ⟨z, h13z, hz20, hz0⟩ := t3wB_num7_zero_in_13_20
  by_cases hzt : t ≤ z
  · -- decreasing on [13, t] (since t ≤ z): R_7 t ≤ R_7 13 < R_7 (1e8)
    have hder : ∀ x, 13 < x → x < t → deriv (fun w : ℝ => t3wB_R 7 w) x < 0 := by
      intro x hx1 hx2
      have hnum : t3wB_num7 x < 0 :=
        t3wB_num7_sign_left h13z hz0 (by linarith [hx1]) (lt_trans hx2 hzt)
      have hR : 0 < t3wB_R 7 x := t3wB_R_pos hmem (by linarith [hx1])
      have hd : 0 < t3wB_den 7 x := t3wB_den_pos (by linarith [hx1])
      have hq : t3wB_num7 x / t3wB_den 7 x < 0 := div_neg_of_neg_of_pos hnum hd
      have hcd : deriv (fun w : ℝ => t3wB_R 7 w) x =
          t3wB_R 7 x * (t3wB_num7 x / t3wB_den 7 x) :=
        (t3wB_RhasDerivAt 7 hmem (by linarith [hx1])).deriv
      rw [hcd]
      nlinarith [hR, hq]
    by_cases hte13 : t = 13
    · rw [hte13]
      exact t3wB_R7_13_lt_1e8
    · have hte13s : 13 < t := lt_of_le_of_ne ht (Ne.symm hte13)
      have hanti : t3wB_R 7 t < t3wB_R 7 13 :=
        t3wB_R_strict_anti 7 hmem (by norm_num) hte13s (by linarith [ht8]) hder
      exact lt_of_lt_of_le hanti (t3wB_R7_13_lt_1e8)
  · have hts : z < t := by
      by_contra htsn
      exact hzt (by linarith [htsn])
    have hderp : ∀ x, t < x → x < (10 : ℝ) ^ 8 → 0 < deriv (fun w : ℝ => t3wB_R 7 w) x := by
      intro x hx1 hx2
      have hnum : 0 < t3wB_num7 x :=
        t3wB_num7_sign_right h13z hz0 (by linarith [hts, hx1])
      have hR : 0 < t3wB_R 7 x := t3wB_R_pos hmem (by linarith [hx1])
      have hd : 0 < t3wB_den 7 x := t3wB_den_pos (by linarith [hx1])
      have hq : 0 < t3wB_num7 x / t3wB_den 7 x := div_pos hnum hd
      have hcd : deriv (fun w : ℝ => t3wB_R 7 w) x =
          t3wB_R 7 x * (t3wB_num7 x / t3wB_den 7 x) :=
        (t3wB_RhasDerivAt 7 hmem (by linarith [hx1])).deriv
      rw [hcd]
      nlinarith [hR, hq]
    by_cases hte8 : t = (10 : ℝ) ^ 8
    · rw [hte8]
    · have hte8s : t < (10 : ℝ) ^ 8 := lt_of_le_of_ne ht8 (Ne.symm hte8)
      exact le_of_lt (t3wB_R_strict_inc 7 hmem (by linarith [ht, hts]) hte8s (by norm_num) hderp)

-- ---------------------------------------------------------------- K-sum and wall band

/-- The exact K-constant sum is < 1. -/
theorem t3wB_K_sum_lt_1 : t3wB_K2 + t3wB_K4 + t3wB_K6 + t3wB_K7 < 1 := by
  norm_num [t3wB_K2, t3wB_K4, t3wB_K6, t3wB_K7]

/-- Sum_i R_i(t) < 1 on the band [13, 1e8]. -/
theorem t3wB_wall_sum {t : ℝ} (ht : 13 ≤ t) (ht8 : t ≤ (10 : ℝ) ^ 8) :
    t3wB_R 2 t + t3wB_R 4 t + t3wB_R 6 t + t3wB_R 7 t < 1 := by
  have h2 : t3wB_R 2 t ≤ t3wB_R 2 13 := t3wB_R246_le_13 (by simp) ht ht8
  have h4 : t3wB_R 4 t ≤ t3wB_R 4 13 := t3wB_R246_le_13 (by simp) ht ht8
  have h6 : t3wB_R 6 t ≤ t3wB_R 6 13 := t3wB_R246_le_13 (by simp) ht ht8
  have h7 : t3wB_R 7 t ≤ t3wB_R 7 ((10 : ℝ) ^ 8) := t3wB_R7_le_1e8 ht ht8
  have hK2 : t3wB_R 2 t ≤ t3wB_K2 := le_trans h2 (le_of_lt (t3wB_R2_13_lt_K2))
  have hK4 : t3wB_R 4 t ≤ t3wB_K4 := le_trans h4 (le_of_lt (t3wB_R4_13_lt_K4))
  have hK6 : t3wB_R 6 t ≤ t3wB_K6 := le_trans h6 (le_of_lt (t3wB_R6_13_lt_K6))
  have hK7 : t3wB_R 7 t ≤ t3wB_K7 := le_trans h7 (le_of_lt (t3wB_R7_1e8_lt_K7))
  calc
    t3wB_R 2 t + t3wB_R 4 t + t3wB_R 6 t + t3wB_R 7 t ≤
        t3wB_K2 + t3wB_K4 + t3wB_K6 + t3wB_K7 := by
      gcongr
      · exact hK2
      · exact hK4
      · exact hK6
      · exact hK7
    _ < 1 := t3wB_K_sum_lt_1

/-- Floor-corrected term bridge: t3w_term n t i ≤ R_i(t) * target(t)
    whenever (13t/8 - 1) ≤ n (holds at n = floor(13t/8)₊ for t ≥ 13). -/
theorem t3wB_term_le {i : ℕ} (hii : i ∈ ({2, 4, 6, 7} : Finset ℕ)) (n : ℕ) {t : ℝ}
    (ht : 13 ≤ t) (hngt : 13 * t / 8 - 1 ≤ (n : ℝ)) :
    t3w_term n t i ≤ t3wB_R i t * t3wB_target t := by
  have hn0 : (0 : ℝ) < 13 * t / 8 - 1 := by linarith [ht]
  have hnd : 0 < (n : ℝ) := lt_of_lt_of_le hn0 hngt
  have hmem0 : i = 2 ∨ i = 4 ∨ i = 6 ∨ i = 7 := by
    simp only [Finset.mem_insert, Finset.mem_singleton] at hii
    tauto
  have hp : 0 < t3w_p i := by
    rcases hmem0 with (h2 | h4 | h6 | h7)
    · rw [h2]
      norm_num [t3w_p]
    · rw [h4]
      norm_num [t3w_p]
    · rw [h6]
      norm_num [t3w_p]
    · rw [h7]
      norm_num [t3w_p]
  dsimp only [t3w_term]
  have hty : t3wB_R i t * t3wB_target t =
      Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) / (t3w_d i) :=
    t3wB_Rtarget i ht
  rw [hty]
  have hxy : (n : ℝ) ^ (-(t3w_p i)) ≤ ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) :=
    t3wB_rpow_negp_le hn0 hngt hp
  have hA : 0 ≤ Real.sqrt (t3w_prod t i) / (t3w_d i) := by
    apply div_nonneg
    · exact Real.sqrt_nonneg _
    · rcases hmem0 with (h2 | h4 | h6 | h7)
      · rw [h2]
        norm_num [t3w_d]
      · rw [h4]
        norm_num [t3w_d]
      · rw [h6]
        norm_num [t3w_d]
      · rw [h7]
        norm_num [t3w_d]
  have hL : Real.sqrt (t3w_prod t i) * ((n : ℝ) ^ (-(t3w_p i))) / (t3w_d i) =
      (Real.sqrt (t3w_prod t i) / (t3w_d i)) * ((n : ℝ) ^ (-(t3w_p i))) := by ring
  have hR : Real.sqrt (t3w_prod t i) * ((13 * t / 8 - 1 : ℝ)) ^ (-(t3w_p i)) / (t3w_d i) =
      (Real.sqrt (t3w_prod t i) / (t3w_d i)) * ((13 * t / 8 - 1) ^ (-(t3w_p i))) := by ring
  rw [hL, hR]
  exact mul_le_mul_of_nonneg_left hxy hA

-- ---------------------------------------------------------------- Part B wall band

/-- For 13 ≤ t ≤ 1e8 with n = floor(13t/8)₊:  t3w_T3UB n t < t3wB_target t. -/
theorem t3wB_wall_band {t : ℝ} (ht : 13 ≤ t) (ht8 : t ≤ (10 : ℝ) ^ 8) {n : ℕ}
    (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) : t3w_T3UB n t < t3wB_target t := by
  have hfl : (13 * t / 8 : ℝ) < (n.succ : ℝ) := by
    rw [hn]
    exact lt_succ_floor (13 * t / 8)
  have hngt : 13 * t / 8 - 1 ≤ (n : ℝ) := by
    rw [Nat.cast_succ]
    linarith [hfl]
  have hT2 : t3w_term n t 2 ≤ t3wB_R 2 t * t3wB_target t :=
    t3wB_term_le (by simp : (2 : ℕ) ∈ ({2, 4, 6, 7} : Finset ℕ)) n ht hngt
  have hT4 : t3w_term n t 4 ≤ t3wB_R 4 t * t3wB_target t :=
    t3wB_term_le (by simp : (4 : ℕ) ∈ ({2, 4, 6, 7} : Finset ℕ)) n ht hngt
  have hT6 : t3w_term n t 6 ≤ t3wB_R 6 t * t3wB_target t :=
    t3wB_term_le (by simp : (6 : ℕ) ∈ ({2, 4, 6, 7} : Finset ℕ)) n ht hngt
  have hT7 : t3w_term n t 7 ≤ t3wB_R 7 t * t3wB_target t :=
    t3wB_term_le (by simp : (7 : ℕ) ∈ ({2, 4, 6, 7} : Finset ℕ)) n ht hngt
  calc
    t3w_T3UB n t = t3w_term n t 2 + t3w_term n t 4 + t3w_term n t 6 + t3w_term n t 7 := rfl
    _ ≤ t3wB_R 2 t * t3wB_target t + t3wB_R 4 t * t3wB_target t +
        t3wB_R 6 t * t3wB_target t + t3wB_R 7 t * t3wB_target t := by
      gcongr
      · exact hT2
      · exact hT4
      · exact hT6
      · exact hT7
    _ = (t3wB_R 2 t + t3wB_R 4 t + t3wB_R 6 t + t3wB_R 7 t) * t3wB_target t := by ring
    _ < 1 * t3wB_target t := by
      gcongr
      · exact t3wB_wall_sum ht ht8
      · dsimp only [t3wB_target]
        apply mul_pos
        · apply mul_pos
          · norm_num
          · exact rpow_pos_of_pos (by linarith [ht]) (-(1/2 : ℝ))
        · norm_num
    _ = t3wB_target t := one_mul _

-- ---------------------------------------------------------------- the final 25ae wall

/-- THE 25ae LIST-SCALE WALL (full range 1 ≤ t ≤ 1e8): for
    n = floor(13t/8)₊,  t3w_T3UB n t < (1/2) * n^(-1/2) * (35/39).
    Part A (1 ≤ t < 13): the band theorems t3w_wall_A1..A4 (each band's wall
    constant is strictly below the n-form target at that band's maximal n).
    Part B (13 ≤ t ≤ 1e8): wall band + target ≤ n-form via the floor bound
    n ≤ 13t/8, so (13t/8)^(-1/2) ≤ n^(-1/2). -/
theorem p4_25ae_wall_list_scale {t : ℝ} (ht : 1 ≤ t) (htmax : t ≤ (10 : ℝ) ^ 8)
    {n : ℕ} (hn : n = ⌊(13 : ℝ) * t / 8⌋₊) :
    t3w_T3UB n t < (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
  by_cases h13 : 13 ≤ t
  · -- Part B
    have hB : t3w_T3UB n t < t3wB_target t := t3wB_wall_band h13 (by linarith [htmax]) hn
    have hfloor : (n : ℝ) ≤ 13 * t / 8 := by
      have h0 : (0 : ℝ) ≤ 13 * t / 8 := by linarith [ht]
      rw [hn]
      have hfz : (0 : ℤ) ≤ ⌊(13 * t / 8 : ℝ)⌋ := Int.floor_nonneg.mpr h0
      rw [Int.toNat_of_nonneg hfz]
      exact mod_cast Int.floor_le (13 * t / 8)
    have hn1 : 1 ≤ n := by
      have h1x : (1 : ℝ) ≤ 13 * t / 8 := by
        have h13t : (13 : ℝ) ≤ 13 * t := by
          exact mul_le_mul_of_nonneg_left ht (by norm_num)
        linarith [h13t]
      rw [hn]
      have hfz1 : (1 : ℤ) ≤ ⌊(13 * t / 8 : ℝ)⌋ := Int.le_floor.mpr h1x
      rw [Int.toNat_of_nonneg (by linarith [hfz1])]
      exact mod_cast hfz1
    have hnpos : (0 : ℝ) < n := by linarith [hn1]
    have hinv : (13 * t / 8 : ℝ) ^ (-1/2 : ℝ) ≤ (n : ℝ) ^ (-1/2 : ℝ) :=
      t3wB_invpow12_mono hnpos hfloor
    have htarget : t3wB_target t ≤ (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
      dsimp only [t3wB_target]
      exact (mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_left hinv (by norm_num)) (by norm_num))
    exact lt_of_lt_of_le hB htarget
  · -- Part A (1 ≤ t < 13): the four bands
    have hlt13 : t < 13 := by linarith [h13]
    by_cases hA1 : t < 16 / 13
    · -- A1: [1, 16/13)  =>  1 ≤ 13t/8 < 2  =>  n = 1
      have hA : t3w_T3UB n t < 35 / 78 := t3w_wall_A1 ht hA1 hn
      have hlo : (1 : ℝ) ≤ 13 * t / 8 := by
        have h13t : (13 : ℝ) ≤ 13 * t := by
          exact mul_le_mul_of_nonneg_left ht (by norm_num)
        linarith [h13t]
      have hhi : 13 * t / 8 < (2 : ℝ) := by
        have ht2 : (13 : ℝ) * t < 16 := by
          rw [show (16 : ℝ) = 13 * (16/13 : ℝ) from by norm_num]
          exact mul_lt_mul_of_pos_left hA1 (by norm_num)
        linarith [ht2]
      have hn1 : n = 1 := by
        have hfzeq : ⌊(13 * t / 8 : ℝ)⌋ = (1 : ℤ) := by
          rw [Int.floor_eq_iff]
          constructor
          · exact Int.cast_le.mpr hlo
          · linarith [hhi]
        rw [hfzeq]
        rw [Int.toNat_of_nonneg (by norm_num : 0 ≤ (1 : ℤ))]
        norm_num
      have hc : (35/78 : ℝ) ≤ (1/2 : ℝ) * (1 : ℝ) ^ (-1/2 : ℝ) * (35/39) := by norm_num
      have hcalc : (35/78 : ℝ) < (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
        rw [hn1, one_rpow 1]
        norm_num
      exact lt_trans hA hcalc
    · by_cases hA2 : t < 4
      · -- A2: [16/13, 4)  =>  13t/8 < 13/2 < 7  =>  n ≤ 6
        have htA2 : 16 / 13 ≤ t := by linarith [hA1]
        have hA : t3w_T3UB n t < 35 / 234 := t3w_wall_A2 htA2 hA2 hn
        have hlo2 : (2 : ℝ) ≤ 13 * t / 8 := by
          have ht16 : (13 : ℝ) * t ≥ 16 := by
            rw [show (16 : ℝ) = 13 * (16/13 : ℝ) from by norm_num]
            exact mul_le_mul_of_nonneg_left htA2 (by norm_num)
          linarith [ht16]
        have hn2 : (2 : ℕ) ≤ n := by
          rw [hn]
          have hfz2 : (2 : ℤ) ≤ ⌊(13 * t / 8 : ℝ)⌋ := Int.le_floor.mpr hlo2
          rw [Int.toNat_of_nonneg (by linarith [hfz2])]
          exact mod_cast hfz2
        have hnpos : (0 : ℝ) < n := by linarith [hn2]
        have hnm : n ≤ 6 := by
          rw [hn]
          have ht7 : (13 : ℝ) * t < 52 := by
            rw [show (52 : ℝ) = 13 * 4 from by norm_num]
            exact mul_lt_mul_of_pos_left hA2 (by norm_num)
          have hf7 : 13 * t / 8 < (7 : ℝ) := by linarith [ht7]
          have hlt7 : ⌊(13 * t / 8 : ℝ)⌋₊ < 7 :=
            (floor_lt (by linarith [hlo2])).mpr hf7
          exact Nat.le_of_lt_succ hlt7
        have hcalc : (35/234 : ℝ) < (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
          calc
            (35/234 : ℝ) = (35/78 : ℝ) * (1/3 : ℝ) := by norm_num
            _ < (35/78 : ℝ) * ((6 : ℝ) ^ (-1/2 : ℝ)) := by
              have h6 : (1/3 : ℝ) < (6 : ℝ) ^ (-1/2 : ℝ) := by
                rw [t3wB_rpow_neg_half 6 (by norm_num)]
                rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
                rw [Real.sqrt_lt' (by norm_num)]
                norm_num
              exact mul_lt_mul_of_pos_left h6 (by norm_num)
            _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
              mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos (Nat.cast_le.mpr hnm))
                (by norm_num)
            _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
        exact lt_trans hA hcalc
      · by_cases hA3 : t < 8
        · -- A3: [4, 8)  =>  13t/8 < 13  =>  n ≤ 12
          have htA3 : 4 ≤ t := by linarith [hA2]
          have hA : t3w_T3UB n t < 35 / 312 := t3w_wall_A3 htA3 hA3 hn
          have hlo2 : (2 : ℝ) ≤ 13 * t / 8 := by
            have ht52 : (13 : ℝ) * t ≥ 52 := by
              rw [show (52 : ℝ) = 13 * 4 from by norm_num]
              exact mul_le_mul_of_nonneg_left htA3 (by norm_num)
            linarith [ht52]
          have hn2 : (2 : ℕ) ≤ n := by
            rw [hn]
            have hfz2 : (2 : ℤ) ≤ ⌊(13 * t / 8 : ℝ)⌋ := Int.le_floor.mpr hlo2
            rw [Int.toNat_of_nonneg (by linarith [hfz2])]
            exact mod_cast hfz2
          have hnpos : (0 : ℝ) < n := by linarith [hn2]
          have hnm : n ≤ 12 := by
            rw [hn]
            have ht104 : (13 : ℝ) * t < 104 := by
              rw [show (104 : ℝ) = 13 * 8 from by norm_num]
              exact mul_lt_mul_of_pos_left hA3 (by norm_num)
            have hf13 : 13 * t / 8 < (13 : ℝ) := by linarith [ht104]
            have hlt13 : ⌊(13 * t / 8 : ℝ)⌋₊ < 13 :=
              (floor_lt (by linarith [hlo2])).mpr hf13
            exact Nat.le_of_lt_succ hlt13
          have hcalc : (35/312 : ℝ) < (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
            calc
              (35/312 : ℝ) = (35/78 : ℝ) * (1/4 : ℝ) := by norm_num
              _ < (35/78 : ℝ) * ((12 : ℝ) ^ (-1/2 : ℝ)) := by
                have h12 : (1/4 : ℝ) < (12 : ℝ) ^ (-1/2 : ℝ) := by
                  rw [t3wB_rpow_neg_half 12 (by norm_num)]
                  rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
                  rw [Real.sqrt_lt' (by norm_num)]
                  norm_num
                exact mul_lt_mul_of_pos_left h12 (by norm_num)
              _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
                mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos (Nat.cast_le.mpr hnm))
                  (by norm_num)
              _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
          exact lt_trans hA hcalc
        · -- A4: [8, 13)  =>  13t/8 < 169/8 < 22  =>  n ≤ 21
          have htA4 : 8 ≤ t := by linarith [hA3]
          have hA : t3w_T3UB n t < 35 / 390 :=
            t3w_wall_A4 htA4 (by linarith [hA3, hlt13]) hn
          have hlo2 : (2 : ℝ) ≤ 13 * t / 8 := by
            have ht104 : (13 : ℝ) * t ≥ 104 := by
              rw [show (104 : ℝ) = 13 * 8 from by norm_num]
              exact mul_le_mul_of_nonneg_left htA4 (by norm_num)
            linarith [ht104]
          have hn2 : (2 : ℕ) ≤ n := by
            rw [hn]
            have hfz2 : (2 : ℤ) ≤ ⌊(13 * t / 8 : ℝ)⌋ := Int.le_floor.mpr hlo2
            rw [Int.toNat_of_nonneg (by linarith [hfz2])]
            exact mod_cast hfz2
          have hnpos : (0 : ℝ) < n := by linarith [hn2]
          have hnm : n ≤ 21 := by
            rw [hn]
            have ht169 : (13 : ℝ) * t < 169 := by
              rw [show (169 : ℝ) = 13 * 13 from by norm_num]
              exact mul_lt_mul_of_pos_left hlt13 (by norm_num)
            have hf22 : 13 * t / 8 < (22 : ℝ) := by linarith [ht169]
            have hlt22 : ⌊(13 * t / 8 : ℝ)⌋₊ < 22 :=
              (floor_lt (by linarith [hlo2])).mpr hf22
            exact Nat.le_of_lt_succ hlt22
          have hcalc : (35/390 : ℝ) < (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
            calc
              (35/390 : ℝ) = (35/78 : ℝ) * (1/5 : ℝ) := by norm_num
              _ < (35/78 : ℝ) * ((21 : ℝ) ^ (-1/2 : ℝ)) := by
                have h21 : (1/5 : ℝ) < (21 : ℝ) ^ (-1/2 : ℝ) := by
                  rw [t3wB_rpow_neg_half 21 (by norm_num)]
                  rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
                  rw [Real.sqrt_lt' (by norm_num)]
                  norm_num
                exact mul_lt_mul_of_pos_left h21 (by norm_num)
              _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
                mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos (Nat.cast_le.mpr hnm))
                  (by norm_num)
              _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
          exact lt_trans hA hcalc
