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
   norm_num.  Mathlib pins: intermediate_value_Ico/Ico', exists_deriv_eq_slope,
   rpow_add / rpow_neg / rpow_natCast, mul_self_sqrt, Real.sqrt_eq_rpow,
   one_rpow, lt_succ_floor / floor_eq_iff' / le_floor_iff' / one_le_floor_iff /
   floor_le_of_le, div_neg_iff / div_pos_iff, one_div_lt_one_div, inv_le_inv₀,
   rpow_le_rpow. -/
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
      exact (inv_le_inv₀ (le_of_lt (rpow_pos_of_pos hba p)) (le_of_lt (rpow_pos_of_pos ha p)))
        .mpr (rpow_le_rpow (le_of_lt ha) hab (le_of_lt hp))
    _ = a ^ (-p) := by rw [heq, rpow_neg ha p]

/-- b^(-1/2) ≤ a^(-1/2) for 0 < a ≤ b. -/
theorem t3wB_invpow12_mono {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    b ^ (-1/2 : ℝ) ≤ a ^ (-1/2 : ℝ) := by
  have hba : 0 < b := by linarith [ha, hab]
  rw [t3wB_rpow_neg_half b hba, t3wB_rpow_neg_half a ha]
  rw [one_div_le_one_div (Real.sqrt_pos.mpr (le_of_lt ha))
      (Real.sqrt_pos.mpr (le_of_lt hba))]
  exact Real.sqrt_le_sqrt hab

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
  · apply mul_pos
    · apply Real.sqrt_pos.mpr
      dsimp only [t3w_prod]
      apply Finset.prod_pos
      intro k hk
      positivity
    · exact rpow_pos_of_pos hbase
  · apply mul_pos
    · exact rpow_pos_of_pos hlt
    · apply div_pos
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
    exact (t3wB_RhasDerivAt i hmem (by linarith [ha, hx.1])).differentiableAt
  have hCO : ContinuousOn (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := hDO.continuousOn
  have hDOo : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Ioo a b) := by
    intro x hx
    exact (t3wB_RhasDerivAt i hmem (by linarith [ha, hx.1])).differentiableAt
  obtain ⟨c, hc, hcd⟩ : ∃ c ∈ Set.Ioo a b, deriv (fun x : ℝ => t3wB_R i x) c =
      (t3wB_R i b - t3wB_R i a) / (b - a) :=
    exists_deriv_eq_slope (fun x : ℝ => t3wB_R i x) hab hCO hDOo
  have hcneg : deriv (fun x : ℝ => t3wB_R i x) c < 0 := hderivneg c hc.1 hc.2
  have hab0 : 0 < b - a := by linarith [hab]
  have hq : (t3wB_R i b - t3wB_R i a) / (b - a) < 0 := by rw [← hcd]; exact hcneg
  have hdiffneg : t3wB_R i b - t3wB_R i a < 0 := by
    rcases (div_neg_iff).1 hq with (hleft | hright)
    · exact hleft.1
    · exfalso
      linarith [hab0, hright.2]
  linarith [hdiffneg]

/-- Dual: derivative of R_i positive on (a, b) implies R_i a < R_i b. -/
theorem t3wB_R_strict_inc (i : ℕ) (hmem : i ∈ ({2, 4, 6, 7} : Finset ℕ))
    {a b : ℝ} (ha : 13 ≤ a) (hab : a < b) (hb : b ≤ (10 : ℝ) ^ 8)
    (hderivpos : ∀ x, a < x → x < b → 0 < deriv (fun t : ℝ => t3wB_R i t) x) :
    t3wB_R i a < t3wB_R i b := by
  have hDO : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := by
    intro x hx
    exact (t3wB_RhasDerivAt i hmem (by linarith [ha, hx.1])).differentiableAt
  have hCO : ContinuousOn (fun x : ℝ => t3wB_R i x) (Set.Icc a b) := hDO.continuousOn
  have hDOo : DifferentiableOn ℝ (fun x : ℝ => t3wB_R i x) (Set.Ioo a b) := by
    intro x hx
    exact (t3wB_RhasDerivAt i hmem (by linarith [ha, hx.1])).differentiableAt
  obtain ⟨c, hc, hcd⟩ : ∃ c ∈ Set.Ioo a b, deriv (fun x : ℝ => t3wB_R i x) c =
      (t3wB_R i b - t3wB_R i a) / (b - a) :=
    exists_deriv_eq_slope (fun x : ℝ => t3wB_R i x) hab hCO hDOo
  have hnpos : 0 < deriv (fun x : ℝ => t3wB_R i x) c := hderivpos c hc.1 hc.2
  have hab0 : 0 < b - a := by linarith [hab]
  have hq : 0 < (t3wB_R i b - t3wB_R i a) / (b - a) := by rw [← hcd]; exact hnpos
  have hdiffpos : 0 < t3wB_R i b - t3wB_R i a := by
    rcases (div_pos_iff).1 hq with (hleft | hright)
    · exact hleft.1
    · exfalso
      linarith [hab0, hright.2]
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
  · exact le_of_lt (t3wB_R246_anti hi (lt_of_le_of_ne ht (Ne.symm hte13)) (by linarith [ht8]))

-- ---------------------------------------------------------------- i = 7 valley

/-- num_7 has a zero in the open interval (13, 20). -/
theorem t3wB_num7_zero_in_13_20 : ∃ z, 13 < z ∧ z < 20 ∧ t3wB_num7 z = 0 := by
  have hcont : ContinuousOn t3wB_num7 (Set.Icc 13 20) := by continuity
  have hgate := t3wB_num7_gate
  have himg : (0 : ℝ) ∈ Set.Ico (t3wB_num7 13) (t3wB_num7 20) :=
    ⟨hgate.1, hgate.2⟩
  have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ico 13 20 :=
    (intermediate_value_Ico (by norm_num) hcont) 0 himg
  obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ico 13 20, t3wB_num7 w = 0 := by
    simpa [Set.mem_image] using hsub
  exact ⟨w, hwm.1, hwm.2, hwz⟩

/-- num_7 < 0 on [13, z) given 13 < z and num_7 z = 0. -/
theorem t3wB_num7_sign_left {z t : ℝ} (h13z : 13 < z) (hz0 : t3wB_num7 z = 0)
    (ht : 13 ≤ t) (htz : t < z) : t3wB_num7 t < 0 := by
  by_contra hnn
  by_cases hz_t : t3wB_num7 t = 0
  · exact t3wB_num7_single_zero t z (by linarith [ht]) htz hz_t hz0
  · have hpos : 0 < t3wB_num7 t := by
      by_contra' hge
      exact hnn (lt_of_le_of_ne hge (Ne.symm hz_t))
    have hcont : ContinuousOn t3wB_num7 (Set.Icc 13 t) := by continuity
    have himg : (0 : ℝ) ∈ Set.Ico (t3wB_num7 13) (t3wB_num7 t) :=
      ⟨t3wB_num7_gate.1, hpos⟩
    have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ico 13 t :=
      (intermediate_value_Ico (by linarith [ht]) hcont) 0 himg
    obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ico 13 t, t3wB_num7 w = 0 := by
      simpa [Set.mem_image] using hsub
    exact t3wB_num7_single_zero w z (by linarith [hwm.1]) (lt_trans hwm.2 htz) hwz hz0

/-- num_7 > 0 on (z, ∞) given 13 < z and num_7 z = 0. -/
theorem t3wB_num7_sign_right {z t : ℝ} (h13z : 13 < z) (hz0 : t3wB_num7 z = 0)
    (htz : z < t) : 0 < t3wB_num7 t := by
  by_contra hnn
  by_cases hz_t : t3wB_num7 t = 0
  · exact t3wB_num7_single_zero z t (by linarith [h13z]) htz hz0 hz_t
  · have hneg : t3wB_num7 t < 0 := by
      by_contra' hge
      exact hnn (lt_of_le_of_ne hge (Ne.symm hz_t))
    by_cases h20 : t ≤ 20
    · have hcont : ContinuousOn t3wB_num7 (Set.Icc t 20) := by continuity
      have himg : (0 : ℝ) ∈ Set.Ico (t3wB_num7 t) (t3wB_num7 20) :=
        ⟨hneg, t3wB_num7_gate.2⟩
      have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ico t 20 :=
        (intermediate_value_Ico (by linarith [h20]) hcont) 0 himg
      obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ico t 20, t3wB_num7 w = 0 := by
        simpa [Set.mem_image] using hsub
      exact t3wB_num7_single_zero z w (by linarith [h13z]) (lt_trans htz hwm.1) hz0 hwz
    · have h20s : 20 < t := by
        by_contra h20n
        have h20ge : t ≤ 20 := by linarith [h20n]
        contradiction
      have hcont : ContinuousOn t3wB_num7 (Set.Icc 20 t) := by continuity
      have himg : (0 : ℝ) ∈ Set.Ico (t3wB_num7 t) (t3wB_num7 20) :=
        ⟨hneg, t3wB_num7_gate.2⟩
      have hsub : (0 : ℝ) ∈ t3wB_num7 '' Set.Ico 20 t :=
        (intermediate_value_Ico' (by linarith [h20s]) hcont) 0 himg
      obtain ⟨w, hwm, hwz⟩ : ∃ w ∈ Set.Ico 20 t, t3wB_num7 w = 0 := by
        simpa [Set.mem_image] using hsub
      -- z is the unique zero in [13, ∞), hence equals the one in (13, 20)
      obtain ⟨z0, hz013, hz020, hz0z⟩ := t3wB_num7_zero_in_13_20
      have hzeq : z = z0 := by
        by_contra hne
        by_cases hzo : z < z0
        · exact t3wB_num7_single_zero z z0 (by linarith [h13z]) hzo hz0 hz0z
        · by_cases hze : z = z0
          · exact hze
          · have hz0z_l : z0 ≤ z := by
              by_contra hz0zl
              have hzl : z < z0 := by linarith [hz0zl]
              contradiction
            exact t3wB_num7_single_zero z0 z (by linarith [hz013])
              (lt_of_le_of_ne hz0z_l (Ne.symm hze)) hz0z hz0
      have hz20 : z < 20 := by rwa [hzeq]
      exact t3wB_num7_single_zero z w (by linarith [h13z]) (lt_trans hz20 hwm.1) hz0 hwz

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
        t3wB_num7_sign_left z x h13z hz0 (by linarith [hx1]) (lt_trans hx2 hzt)
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
        t3wB_num7_sign_right z x h13z hz0 (by linarith [hts, hx1])
      have hR : 0 < t3wB_R 7 x := t3wB_R_pos hmem (by linarith [hx1])
      have hd : 0 < t3wB_den 7 x := t3wB_den_pos (by linarith [hx1])
      have hq : 0 < t3wB_num7 x / t3wB_den 7 x := div_pos.2 (Or.inl ⟨hnum, hd⟩)
      have hcd : deriv (fun w : ℝ => t3wB_R 7 w) x =
          t3wB_R 7 x * (t3wB_num7 x / t3wB_den 7 x) :=
        (t3wB_RhasDerivAt 7 hmem (by linarith [hx1])).deriv
      rw [hcd]
      nlinarith [hR, hq]
    by_cases hte8 : t = (10 : ℝ) ^ 8
    · rw [hte8]
    · have hte8s : t < (10 : ℝ) ^ 8 := lt_of_le_of_ne ht8 (Ne.symm hte8)
      exact le_of_lt (t3wB_R_strict_inc 7 hmem (by linarith [ht, hts]) hte8s (by norm_num) hderp)

-- ---------------------------------------------------------------- endpoint squares
-- Each proof: dsimp + numeric normalization, then a block-form calc turning
-- R_i(T)^2 into  (prod) * (nlo)^(−2p)⁻¹ * (4·c·(78/70)²/d²), closed by one
-- norm_num [t3w_prod] against the exact literal.

/-- R_2(13)^2 = exact rational. -/
theorem t3wB_R2_13_sq : (t3wB_R 2 13 : ℝ) ^ 2 = 118844923935296 / 154571611490816995125 := by
  dsimp only [t3wB_R, t3w_p, t3w_d]
  have hnum1 : (13 * 13 / 8 - 1 : ℝ) = 161 / 8 := by norm_num
  have hnum2 : (13 * 13 / 8 : ℝ) = 169 / 8 := by norm_num
  rw [hnum1, hnum2]
  have hbase : (0 : ℝ) < 161 / 8 := by norm_num
  have hltb : (0 : ℝ) < 169 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 2 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : (Real.sqrt (t3w_prod 13 2) : ℝ) ^ 2 = t3w_prod 13 2 :=
    Real.mul_self_sqrt hprod
  have h2 : ((161 / 8 : ℝ) ^ (-(7/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-7 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (7/2 : ℝ)]
    norm_num
  have heq : (-7 : ℝ) = -((7 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-7 : ℝ) = ((161 / 8 : ℝ) ^ 7)⁻¹ := by
    rw [heq, rpow_neg hbase.le (7 : ℝ), rpow_natCast]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 720) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 720 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) hltb]
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
  have hltb : (0 : ℝ) < 169 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 4 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : (Real.sqrt (t3w_prod 13 4) : ℝ) ^ 2 = t3w_prod 13 4 :=
    Real.mul_self_sqrt hprod
  have h2 : ((161 / 8 : ℝ) ^ (-(11/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-11 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (11/2 : ℝ)]
    norm_num
  have heq : (-11 : ℝ) = -((11 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-11 : ℝ) = ((161 / 8 : ℝ) ^ 11)⁻¹ := by
    rw [heq, rpow_neg hbase.le (11 : ℝ), rpow_natCast]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 30240) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 30240 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) hltb]
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
  have hltb : (0 : ℝ) < 169 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 6 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : (Real.sqrt (t3w_prod 13 6) : ℝ) ^ 2 = t3w_prod 13 6 :=
    Real.mul_self_sqrt hprod
  have h2 : ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-15 : ℝ) = ((161 / 8 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ), rpow_natCast]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 1209600) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 1209600 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) hltb]
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
  have hltb : (0 : ℝ) < 169 / 8 := by norm_num
  have hprod : (0 : ℝ) ≤ t3w_prod 13 7 := by
    dsimp only [t3w_prod]
    apply Finset.prod_nonneg
    intro k hk
    positivity
  have h1 : (Real.sqrt (t3w_prod 13 7) : ℝ) ^ 2 = t3w_prod 13 7 :=
    Real.mul_self_sqrt hprod
  have h2 : ((161 / 8 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (161 / 8 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (161 / 8 : ℝ) ^ (-15 : ℝ) = ((161 / 8 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ), rpow_natCast]
  have hC : (2 * ((169 / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / 9072000) ^ 2 =
      (4 * (169 / 8 : ℝ) * (78/70) ^ 2) / 9072000 ^ 2 := by
    ring_nf
    rw [show ((169 / 8 : ℝ) ^ (1/2 : ℝ)) ^ 2 = (169 / 8 : ℝ) from
      t3wB_rpow_half_sq (169 / 8 : ℝ) hltb]
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
  have h1 : (Real.sqrt (t3w_prod ((10 : ℝ) ^ 8) 7) : ℝ) ^ 2 =
      t3w_prod ((10 : ℝ) ^ 8) 7 := Real.mul_self_sqrt hprod
  have h2 : ((162499999 : ℝ) ^ (-(15/2 : ℝ))) ^ 2 = (162499999 : ℝ) ^ (-15 : ℝ) := by
    rw [t3wB_rpow_sq_neg hbase (15/2 : ℝ)]
    norm_num
  have heq : (-15 : ℝ) = -((15 : ℝ)) := by norm_num
  have h4 : (162499999 : ℝ) ^ (-15 : ℝ) = ((162499999 : ℝ) ^ 15)⁻¹ := by
    rw [heq, rpow_neg hbase.le (15 : ℝ), rpow_natCast]
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
  calc
    t3wB_R 2 t + t3wB_R 4 t + t3wB_R 6 t + t3wB_R 7 t ≤
        t3wB_K2 + t3wB_K4 + t3wB_K6 + t3wB_K7 := by
      gcongr
      all_goals (try exact h2) <;> (try exact h4) <;> (try exact h6) <;>
        (try exact h7) <;> (try exact t3wB_R2_13_lt_K2) <;>
        (try exact t3wB_R4_13_lt_K4) <;> (try exact t3wB_R6_13_lt_K6) <;>
        (try exact t3wB_R7_1e8_lt_K7)
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
    t3wB_rpow_negp_le hnd hngt hp
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
    rw [← hn]
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
      all_goals (try exact hT2) <;> (try exact hT4) <;> (try exact hT6) <;> (try exact hT7)
    _ = (t3wB_R 2 t + t3wB_R 4 t + t3wB_R 6 t + t3wB_R 7 t) * t3wB_target t := by ring
    _ < 1 * t3wB_target t := by
      gcongr
      · exact t3wB_wall_sum ht ht8
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
      rw [hn]
      exact floor_le (by linarith [ht])
    have hn1 : 1 ≤ n := by
      have h1 : (1 : ℝ) ≤ 13 * t / 8 := by
        calc
          (1 : ℝ) ≤ 13 / 8 := by norm_num
          _ ≤ 13 * t / 8 := by
            gcongr
            · linarith [ht]
            · norm_num
      rw [hn]
      exact one_le_floor_iff.mpr h1
    have hnpos : (0 : ℝ) < n := by linarith [hn1]
    have htarget : t3wB_target t ≤ (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
      dsimp only [t3wB_target]
      have hinv : (13 * t / 8 : ℝ) ^ (-1/2 : ℝ) ≤ (n : ℝ) ^ (-1/2 : ℝ) :=
        t3wB_invpow12_mono hnpos hfloor
      nlinarith [hinv]
    exact lt_of_lt_of_le hB htarget
  · -- Part A (1 ≤ t < 13): the four bands
    have hlt13 : t < 13 := by linarith [h13]
    by_cases hA1 : t < 16 / 13
    · -- A1: [1, 16/13)  =>  n = 1
      have hA : t3w_T3UB n t < 35 / 78 := t3w_wall_A1 ht hA1 hn
      have hn1 : n = 1 := by
        rw [hn]
        rw [floor_eq_iff' (by norm_num : (1 : ℕ) ≠ 0)]
        constructor
        · linarith [ht]
        · linarith [hA1]
      have hc : (35/78 : ℝ) ≤ (1/2 : ℝ) * (1 : ℝ) ^ (-1/2 : ℝ) * (35/39) := by
        rw [one_rpow 1]
        norm_num
      refine lt_of_lt_of_le hA ?_
      rw [hn1]
      exact hc
    · by_cases hA2 : t < 4
      · -- A2: [16/13, 4)  =>  2 ≤ n ≤ 6
        have htA2 : 16 / 13 ≤ t := by linarith [hA1]
        have hA : t3w_T3UB n t < 35 / 234 := t3w_wall_A2 htA2 hA2 hn
        have hnm : n ≤ 6 := by
          rw [hn]
          exact floor_le_of_le (by linarith [hA2])
        have hn2 : 2 ≤ n := by
          rw [hn]
          rw [(le_floor_iff' (by norm_num : (2 : ℕ) ≠ 0))]
          linarith [htA2]
        have hnpos : (0 : ℝ) < n := by linarith [hn2]
        have h6 : (1/3 : ℝ) < (6 : ℝ) ^ (-1/2 : ℝ) := by
          rw [t3wB_rpow_neg_half 6 (by norm_num)]
          rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
          rw [Real.sqrt_lt' (by norm_num)]
          norm_num
        refine lt_of_lt_of_le hA ?_
        calc
          (35/234 : ℝ) = (35/78 : ℝ) * (1/3 : ℝ) := by norm_num
          _ < (35/78 : ℝ) * ((6 : ℝ) ^ (-1/2 : ℝ)) :=
            mul_lt_mul_of_pos_left h6 (by norm_num)
          _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
            mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos hnm) (by norm_num)
          _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
      · by_cases hA3 : t < 8
        · -- A3: [4, 8)  =>  7 ≤ n ≤ 12
          have htA3 : 4 ≤ t := by linarith [hA2]
          have hA : t3w_T3UB n t < 35 / 312 := t3w_wall_A3 htA3 hA3 hn
          have hnm : n ≤ 12 := by
            rw [hn]
            exact floor_le_of_le (by linarith [hA3])
          have hn7 : 7 ≤ n := by
            rw [hn]
            rw [(le_floor_iff' (by norm_num : (7 : ℕ) ≠ 0))]
            linarith [htA3]
          have hnpos : (0 : ℝ) < n := by linarith [hn7]
          have h12 : (1/4 : ℝ) < (12 : ℝ) ^ (-1/2 : ℝ) := by
            rw [t3wB_rpow_neg_half 12 (by norm_num)]
            rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
            rw [Real.sqrt_lt' (by norm_num)]
            norm_num
          refine lt_of_lt_of_le hA ?_
          calc
            (35/312 : ℝ) = (35/78 : ℝ) * (1/4 : ℝ) := by norm_num
            _ < (35/78 : ℝ) * ((12 : ℝ) ^ (-1/2 : ℝ)) :=
              mul_lt_mul_of_pos_left h12 (by norm_num)
            _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
              mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos hnm) (by norm_num)
            _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
        · -- A4: [8, 13)  =>  13 ≤ n ≤ 21
          have htA4 : 8 ≤ t := by linarith [hA3]
          have hA : t3w_T3UB n t < 35 / 390 := t3w_wall_A4 htA4 (by linarith [hA3, hlt13]) hn
          have hnm : n ≤ 21 := by
            rw [hn]
            exact floor_le_of_le (by linarith [hlt13])
          have hn13 : 13 ≤ n := by
            rw [hn]
            rw [(le_floor_iff' (by norm_num : (13 : ℕ) ≠ 0))]
            linarith [htA4]
          have hnpos : (0 : ℝ) < n := by linarith [hn13]
          have h21 : (1/5 : ℝ) < (21 : ℝ) ^ (-1/2 : ℝ) := by
            rw [t3wB_rpow_neg_half 21 (by norm_num)]
            rw [one_div_lt_one_div (by norm_num) (Real.sqrt_pos.mpr (by norm_num))]
            rw [Real.sqrt_lt' (by norm_num)]
            norm_num
          refine lt_of_lt_of_le hA ?_
          calc
            (35/390 : ℝ) = (35/78 : ℝ) * (1/5 : ℝ) := by norm_num
            _ < (35/78 : ℝ) * ((21 : ℝ) ^ (-1/2 : ℝ)) :=
              mul_lt_mul_of_pos_left h21 (by norm_num)
            _ ≤ (35/78 : ℝ) * ((n : ℝ) ^ (-1/2 : ℝ)) :=
              mul_le_mul_of_nonneg_left (t3wB_invpow12_mono hnpos hnm) (by norm_num)
            _ = (1/2 : ℝ) * (n : ℝ) ^ (-1/2 : ℝ) * (35/39) := by ring
