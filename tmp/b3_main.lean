/- Main derivative identity: R_i' = R_i * h_i = R_i * num_i/den_i on [13, inf).
   Proof: logDeriv of the product (A * B) * K2 where A = sqrt(t3w_prod),
   B = (13x/8 - 1)^(-p_i), K2 = 2*(13x/8)^(1/2)*(78/70)/d_i; constant pieces
   carry logDeriv 0, leaving exactly h_i. -/
theorem t3wB_RhasDerivAt (i : ℕ) (hii : i ∈ ({2, 4, 6, 7} : Finset ℕ)) {t : ℝ} (ht : 13 ≤ t) :
    HasDerivAt (fun x : ℝ => t3wB_R i x) (t3wB_R i t * (t3wB_num i t / t3wB_den i t)) t := by
  have ht0 : 0 < t := by linarith [ht]
  have hB0 : 0 < 13 * t / 8 - 1 := by linarith [ht]
  have hL0 : 0 < 13 * t / 8 := by linarith [ht]
  have hB0' : 0 < (13/8 : ℝ) * t + (-1 : ℝ) := by
    rw [show (13/8 : ℝ) * t + (-1 : ℝ) = 13 * t / 8 - 1 from by ring]
    exact hB0
  have hL0' : 0 < (13/8 : ℝ) * t + 0 := by
    rw [add_zero, show (13/8 : ℝ) * t = 13 * t / 8 from by ring]
    exact hL0
  have hP0 : 0 < t3w_prod t i := by
    dsimp only [t3w_prod]
    apply Finset.prod_pos
    intro k hk
    positivity
  have hmem : i = 2 ∨ i = 4 ∨ i = 6 ∨ i = 7 := by
    simp only [Finset.mem_insert, Finset.mem_singleton] at hii
    tauto
  have hdpos : 0 < t3w_d i := by
    rcases hmem with (h2 | h4 | h6 | h7)
    · rw [h2]
      norm_num [t3w_d]
    · rw [h4]
      norm_num [t3w_d]
    · rw [h6]
      norm_num [t3w_d]
    · rw [h7]
      norm_num [t3w_d]
  have hA0 : 0 < Real.sqrt (t3w_prod t i) := Real.sqrt_pos.mpr hP0
  have hBv : 0 < (13 * t / 8 - 1 : ℝ) ^ (-(t3w_p i)) := rpow_pos_of_pos hB0 _
  have hCv : 0 < (13 * t / 8 : ℝ) ^ (1/2 : ℝ) := rpow_pos_of_pos hL0 _
  have hK0 : 2 * ((13 * t / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i) != 0 :=
    ne_of_gt (div_pos (mul_pos (mul_pos (by norm_num : 0 < (2 : ℝ)) hCv)
      (by norm_num : 0 < (78/70 : ℝ))) hdpos)
  have hc0 : 2 * (78/70 : ℝ) / (t3w_d i) != 0 :=
    ne_of_gt (div_pos (by norm_num : 0 < 2 * (78/70 : ℝ)) hdpos)
  -- differentiability pieces
  have hlinB' : DifferentiableAt ℝ (fun x : ℝ => (13/8 : ℝ) * x + (-1 : ℝ)) t := by
    simpa using ((HasDerivAt.const_mul (13/8 : ℝ) (hasDerivAt_id t)).add
      (hasDerivAt_const t (-1 : ℝ))).differentiableAt
  have hA : DifferentiableAt ℝ (fun x : ℝ => Real.sqrt (t3w_prod x i)) t :=
    (hasDerivAt_sqrt (hP0.ne')).differentiableAt.comp (t3wB_prod_differentiableAt i t)
  have hBdiff : DifferentiableAt ℝ (fun u : ℝ => u ^ (-(t3w_p i))) (13 * t / 8 - 1) := by
    exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt hB0))).differentiableAt
  have hCdiff : DifferentiableAt ℝ (fun u : ℝ => u ^ (1/2 : ℝ)) (13 * t / 8) := by
    exact (Real.hasDerivAt_rpow_const (Or.inl (ne_of_gt hL0))).differentiableAt
  have hBpt : (13/8 : ℝ) * t + (-1 : ℝ) = 13 * t / 8 - 1 := by ring
  have hBdiff' : DifferentiableAt ℝ (fun u : ℝ => u ^ (-(t3w_p i))) ((13/8 : ℝ) * t + (-1 : ℝ)) := by
    rw [← hBpt] at hBdiff
    exact hBdiff
  have hLpt : (13/8 : ℝ) * t + 0 = 13 * t / 8 := by ring
  have hCdiff' : DifferentiableAt ℝ (fun u : ℝ => u ^ (1/2 : ℝ)) ((13/8 : ℝ) * t + 0) := by
    rw [← hLpt] at hCdiff
    exact hCdiff
  have hBf : DifferentiableAt ℝ (fun x : ℝ => (13 * x / 8 - 1 : ℝ) ^ (-(t3w_p i))) t :=
    hBdiff.comp (by
      simpa [show (fun x : ℝ => 13 * x / 8 - 1) = (fun x : ℝ => (13/8 : ℝ) * x + (-1 : ℝ)) from by
        funext x
        ring] using hlinB')
  have hCf : DifferentiableAt ℝ (fun x : ℝ => (13 * x / 8 : ℝ) ^ (1/2 : ℝ)) t :=
    hCdiff.comp (by
      simpa [show (fun x : ℝ => 13 * x / 8) = (fun x : ℝ => (13/8 : ℝ) * x) from by
        funext x
        ring] using (HasDerivAt.const_mul (13/8 : ℝ) (hasDerivAt_id t)).differentiableAt)
  -- K2 differentiable: K2 = C * (2 * 78/70 / d_i) after ring-bridge
  have hK : DifferentiableAt ℝ (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) t := by
    have hshape : (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) =
        (fun x : ℝ => (2 * (78/70 : ℝ) / (t3w_d i)) * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ)) := by
      funext x
      ring
    rw [hshape]
    exact hCf.const_mul (2 * (78/70 : ℝ) / (t3w_d i))
  have hdiff : DifferentiableAt ℝ (fun x : ℝ => t3wB_R i x) t := by
    dsimp only [t3wB_R]
    have hRshape : (fun x : ℝ => Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i)) *
        (2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))) =
        (fun x : ℝ => (Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i))) *
          (2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))) := by
      funext x
      ring
    rw [hRshape]
    exact (hA.mul hBf).mul hK
  -- logDeriv identity
  have hlog : logDeriv (fun x : ℝ => t3wB_R i x) t = t3wB_h i t := by
    dsimp only [t3wB_R]
    have hRshape : (fun x : ℝ => Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i)) *
        (2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))) =
        (fun x : ℝ => (Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i))) *
          (2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i))) := by
      funext x
      ring
    rw [hRshape]
    rw [logDeriv_mul]
    · exact ne_of_gt (mul_pos hA0 hBv)
    · exact hK0
    · exact hA.mul hBf
    · exact hK
    have hlAB : logDeriv (fun x : ℝ => Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i))) t =
        (∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2) ^ 2)) +
          (-(t3w_p i)) * (13/8 : ℝ) / (13 * t / 8 - 1) := by
      rw [logDeriv_mul hA0 hBv hA hBf]
      · rw [t3wB_logDeriv_sqrtProd i t]
      · have hBfeta : (fun x : ℝ => (13 * x / 8 - 1 : ℝ) ^ (-(t3w_p i))) =
            (fun x : ℝ => ((13/8 : ℝ) * x + (-1 : ℝ)) ^ (-(t3w_p i))) := by
          funext x
          ring
        rw [hBfeta, t3wB_logDeriv_rpowLin (13/8 : ℝ) (-1 : ℝ) (-(t3w_p i)) t hB0' hBdiff']
        rw [show (13/8 : ℝ) * t + (-1 : ℝ) = 13 * t / 8 - 1 from by ring]
    have hlK : logDeriv (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) t =
        (1/2 : ℝ) * (13/8 : ℝ) / (13 * t / 8) := by
      have hshape : (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) =
          (fun x : ℝ => ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (2 * (78/70 : ℝ) / (t3w_d i))) := by
        funext x
        ring
      rw [hshape]
      rw [logDeriv_mul hCv hc0 hCf (differentiableAt_const t (2 * (78/70 : ℝ) / (t3w_d i)))]
      have hCeta : (fun x : ℝ => (13 * x / 8 : ℝ) ^ (1/2 : ℝ)) =
          (fun x : ℝ => ((13/8 : ℝ) * x + 0) ^ (1/2 : ℝ)) := by
        funext x
        ring
      rw [hCeta, t3wB_logDeriv_rpowLin (13/8 : ℝ) 0 (1/2 : ℝ) t hL0' hCdiff']
      rw [add_zero, show (13/8 : ℝ) * t = 13 * t / 8 from by ring]
      rw [logDeriv_const]
      ring
    rw [hlAB, hlK]
    have hsum : ∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2) ^ 2) =
        ∑ k ∈ Finset.range (i + 1), (4 : ℝ) * t / (4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2) := by
      congr
      intro k hk
      have hd1 : t ^ 2 + (k + 1/2 : ℝ) ^ 2 != 0 := ne_of_gt (by positivity)
      have hd2 : 4 * t ^ 2 + (2 * k + 1 : ℝ) ^ 2 != 0 := ne_of_gt (by positivity)
      field_simp [hd1, hd2]
      ring
    have h12 : (1/2 : ℝ) * (13/8 : ℝ) / (13 * t / 8) = 1 / (2 * t) := by
      field_simp [ht0.ne', hL0.ne']
      ring
    rw [t3wB_h, hsum, h12]
    ring
  -- deriv identity
  have hderiv : deriv (fun x : ℝ => t3wB_R i x) t =
      t3wB_R i t * (t3wB_num i t / t3wB_den i t) := by
    have hhh : t3wB_h i t = t3wB_num i t / t3wB_den i t := by
      rcases hmem with (h2 | h4 | h6 | h7)
      · rw [h2]
        exact t3wB_h2_id ht
      · rw [h4]
        exact t3wB_h4_id ht
      · rw [h6]
        exact t3wB_h6_id ht
      · rw [h7]
        exact t3wB_h7_id ht
    have hf0 : t3wB_R i t != 0 := by
      dsimp only [t3wB_R]
      apply ne_of_gt
      positivity
    have hdennz : t3wB_den i t != 0 := (t3wB_den_pos ht).ne'
    have hlog' : deriv (fun x : ℝ => t3wB_R i x) t / t3wB_R i t =
        t3wB_num i t / t3wB_den i t := by
      rw [logDeriv_apply]
      rw [hlog]
      rw [hhh]
    have hcross : deriv (fun x : ℝ => t3wB_R i x) t * t3wB_den i t =
        t3wB_R i t * t3wB_num i t := by
      exact (div_eq_div_iff hf0 hdennz).mpr hlog'
    field_simp [hf0, hdennz]
    exact hcross
  have hda : HasDerivAt (fun x : ℝ => t3wB_R i x) (deriv (fun x : ℝ => t3wB_R i x) t) t :=
    hdiff.hasDerivAt
  rw [hderiv] at hda
  exact hda
