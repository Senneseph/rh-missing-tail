/- 25ae Stage 3B.11 - Part B, batch 3: LogDeriv architecture for R_i' = R_i * h_i.
   Ordinary transformations borrowed from Mathlib.Analysis.Calculus.LogDeriv
   (logDeriv_comp / logDeriv_mul / logDeriv_const) and
   Mathlib.Analysis.SpecialFunctions.Pow.Deriv (Real.hasDerivAt_rpow_const) -
   online-corroborated, present in mathlib v4.33.1. -/

-- Unify the h_i numerators (0 off {2,4,6,7}).
def t3wB_num (i : Nat) : Real -> Real :=
  if i = 2 then t3wB_num2
  else if i = 4 then t3wB_num4
  else if i = 6 then t3wB_num6
  else if i = 7 then t3wB_num7
  else 0

/-- logDeriv of the quadratic x^2 + c (c > 0): 2t/(t^2 + c). -/
theorem t3wB_logDeriv_quad (c : Real) (hc : 0 < c) (t : Real) :
    logDeriv (fun x : Real => x ^ 2 + c) t = 2 * t / (t ^ 2 + c) := by
  rw [logDeriv_apply]
  have hd : deriv (fun x : Real => x ^ 2 + c) t = 2 * t := by
    simpa using ((hasDerivAt_pow 2 t).add (hasDerivAt_const t c)).deriv
  rw [hd]

/-- t3w_prod is differentiable at every real t (finite product of quadratics). -/
theorem t3wB_prod_differentiableAt (i : Nat) (t : Real) :
    DifferentiableAt Real (fun x : Real => t3w_prod x i) t := by
  induction i with
  | zero =>
      dsimp only [t3w_prod]
      simp only [Finset.prod_range_succ, Finset.prod_range_zero, one_mul, Nat.cast_zero, zero_add]
      exact ((hasDerivAt_pow 2 t).add (hasDerivAt_const t ((1/2 : Real) ^ 2))).differentiableAt
  | succ n ih =>
      dsimp only [t3w_prod]
      have hsplit : (fun x : Real => ∏ k ∈ Finset.range ((n + 1) + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) =
          (fun x : Real => (∏ k ∈ Finset.range (n + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) *
            (x ^ 2 + ((n + 1 : Real) + 1/2) ^ 2)) := by
        funext x
        rw [Finset.prod_range_succ]
        ring
      rw [hsplit]
      simpa using ih.mul
        ((hasDerivAt_pow 2 t).add (hasDerivAt_const t (((n + 1 : Real) + 1/2) ^ 2))).differentiableAt

/-- logDeriv of t3w_prod: sum over k of 2t/(t^2 + (k+1/2)^2). -/
theorem t3wB_logDeriv_t3wProd (i : Nat) (t : Real) :
    logDeriv (fun x : Real => t3w_prod x i) t =
      ∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2) := by
  induction i with
  | zero =>
      dsimp only [t3w_prod]
      simp only [Finset.prod_range_succ, Finset.prod_range_zero, one_mul, Nat.cast_zero, zero_add,
        Finset.sum_range_succ, Finset.sum_range_zero, add_zero]
      have hc : 0 < (1/2 : Real) ^ 2 := by norm_num
      exact t3wB_logDeriv_quad hc t
  | succ n ih =>
      dsimp only [t3w_prod]
      have hsplit : (fun x : Real => ∏ k ∈ Finset.range ((n + 1) + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) =
          (fun x : Real => (∏ k ∈ Finset.range (n + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) *
            (x ^ 2 + ((n + 1 : Real) + 1/2) ^ 2)) := by
        funext x
        rw [Finset.prod_range_succ]
        ring
      rw [hsplit]
      have hP : 0 < ∏ k ∈ Finset.range (n + 1), t ^ 2 + (k + 1/2 : Real) ^ 2 := by
        apply Finset.prod_pos
        intro k hk
        positivity
      have hQ : 0 < t ^ 2 + (n + 1 + 1/2 : Real) ^ 2 := by positivity
      have hc : 0 < (n + 1 + 1/2 : Real) ^ 2 := by positivity
      rw [logDeriv_mul t (ne_of_gt hP) (ne_of_gt hQ) (t3wB_prod_differentiableAt n t)
          (((hasDerivAt_pow 2 t).add (hasDerivAt_const t ((n + 1 + 1/2 : Real) ^ 2))).differentiableAt)]
      rw [t3wB_logDeriv_t3wProd n t, t3wB_logDeriv_quad hc t,
        Finset.sum_range_succ (m := n + 1) (f := fun k => 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2))]
      ring

/-- deriv of t3w_prod: P * sum_k 2t/(t^2 + (k+1/2)^2). -/
theorem t3wB_prod_deriv (i : Nat) (t : Real) :
    deriv (fun x : Real => t3w_prod x i) t =
      t3w_prod t i * (∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2)) := by
  have hg : 0 < t3w_prod t i := by
    dsimp only [t3w_prod]
    apply Finset.prod_pos
    intro k hk
    positivity
  have hlog := t3wB_logDeriv_t3wProd i t
  have hmul : deriv (fun x : Real => t3w_prod x i) t =
      logDeriv (fun x : Real => t3w_prod x i) t * (t3w_prod t i) := by
    rw [show logDeriv (fun x : Real => t3w_prod x i) t =
        deriv (fun x : Real => t3w_prod x i) t / (t3w_prod t i) from by
      rw [logDeriv_apply]]
    rw [div_mul_cancel (deriv (fun x : Real => t3w_prod x i) t) hg.ne']
  rw [hmul, hlog]
  ring

/-- logDeriv of sqrt(t3w_prod): sum over k of t/(t^2 + (k+1/2)^2). -/
theorem t3wB_logDeriv_sqrtProd (i : Nat) (t : Real) :
    logDeriv (fun x : Real => Real.sqrt (t3w_prod x i)) t =
      ∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2 : Real) ^ 2) := by
  have hP : 0 < t3w_prod t i := by
    dsimp only [t3w_prod]
    apply Finset.prod_pos
    intro k hk
    positivity
  have hcomp : logDeriv (fun x : Real => Real.sqrt (t3w_prod x i)) t =
      logDeriv (fun z : Real => Real.sqrt z) (t3w_prod t i) * deriv (fun x : Real => t3w_prod x i) t :=
    logDeriv_comp (hasDerivAt_sqrt (hP.ne')).differentiableAt (t3wB_prod_differentiableAt i t)
  rw [hcomp]
  have hl : logDeriv (fun z : Real => Real.sqrt z) (t3w_prod t i) = 1 / (2 * t3w_prod t i) := by
    have hnz : Real.sqrt (t3w_prod t i) != 0 := ne_of_gt (Real.sqrt_pos.mpr hP)
    rw [logDeriv_apply]
    have hd : deriv (fun z : Real => Real.sqrt z) (t3w_prod t i) =
        1 / (2 * Real.sqrt (t3w_prod t i)) :=
      (hasDerivAt_sqrt (hP.ne')).deriv
    rw [hd]
    field_simp [hP.ne', hnz]
    rw [mul_assoc, mul_self_sqrt hP.le]
    ring
  rw [hl, t3wB_prod_deriv i t]
  field_simp [hP.ne']
  have hS : (∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2)) =
      2 * (∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2 : Real) ^ 2)) := by
    rw [show (∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2)) =
        ∑ k ∈ Finset.range (i + 1), (2 : Real) * (t / (t ^ 2 + (k + 1/2 : Real) ^ 2)) from by
      congr
      intro k hk
      ring]
    rw [Finset.mul_sum]
    ring
  rw [hS]
  ring

/-- logDeriv of (a*x + b)^y at t (base > 0, rpow differentiable at base):
    y * a / (a*t + b). -/
theorem t3wB_logDeriv_rpowLin (a b : Real) (y : Real) (t : Real) (hb0 : 0 < a * t + b)
    (hdrp : DifferentiableAt Real (fun u : Real => u ^ y) (a * t + b)) :
    logDeriv (fun x : Real => (a * x + b) ^ y) t = y * a / (a * t + b) := by
  have hbz : a * t + b != 0 := ne_of_gt hb0
  have hinner : DifferentiableAt Real (fun x : Real => a * x + b) t :=
    (((hasDerivAt_id t).const_mul a).add (hasDerivAt_const t b)).differentiableAt
  have hcomp : logDeriv (fun x : Real => (a * x + b) ^ y) t =
      logDeriv (fun u : Real => u ^ y) (a * t + b) * deriv (fun x : Real => a * x + b) t :=
    logDeriv_comp hdrp hinner
  rw [hcomp]
  have hl : logDeriv (fun u : Real => u ^ y) (a * t + b) = y / (a * t + b) := by
    have hnz : (a * t + b) ^ y != 0 := ne_of_gt (rpow_pos_of_pos hb0 y)
    rw [logDeriv_apply]
    have hd : deriv (fun u : Real => u ^ y) (a * t + b) = y * (a * t + b) ^ (y - 1) := by
      simpa using (Real.hasDerivAt_rpow_const (Or.inl hbz) y).deriv
    rw [hd]
    field_simp [hbz, hnz]
    rw [show (a * t + b) ^ (y - 1) = (a * t + b) ^ y / (a * t + b) from by
      rw [Real.rpow_sub hb0 y 1, Real.rpow_one]]
    field_simp [hbz, hnz]
  rw [hl]
  have hi : deriv (fun x : Real => a * x + b) t = a := by
    simpa using (((hasDerivAt_id t).const_mul a).add (hasDerivAt_const t b)).deriv
  rw [hi]
  field_simp
  ring

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
    have hlAB : logDeriv (fun x : ℝ => Real.sqrt (t3w_prod x i) * ((13 * x / 8 - 1 : ℝ)) ^ (-(t3w_p i))) t =
        (∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2 : ℝ) ^ 2)) +
          (-(t3w_p i)) * (13/8 : ℝ) / (13 * t / 8 - 1) := by
      rw [logDeriv_mul t (ne_of_gt (mul_pos hA0 hBv)) hBv hA hBf]
      rw [t3wB_logDeriv_sqrtProd i t]
      have hlB : logDeriv (fun x : ℝ => (13 * x / 8 - 1 : ℝ) ^ (-(t3w_p i))) t =
          (-(t3w_p i)) * (13/8 : ℝ) / (13 * t / 8 - 1) := by
        have hBfeta2 : (fun x : ℝ => (13 * x / 8 - 1 : ℝ) ^ (-(t3w_p i))) =
            (fun x : ℝ => ((13/8 : ℝ) * x + (-1 : ℝ)) ^ (-(t3w_p i))) := by
          funext x
          ring
        rw [hBfeta2, t3wB_logDeriv_rpowLin (13/8 : ℝ) (-1 : ℝ) (-(t3w_p i)) t hB0' hBdiff']
        rw [show (13/8 : ℝ) * t + (-1 : ℝ) = 13 * t / 8 - 1 from by ring]
      rw [hlB]
    have hlK : logDeriv (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) t =
        (1/2 : ℝ) * (13/8 : ℝ) / (13 * t / 8) := by
      have hshape : (fun x : ℝ => 2 * ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (78/70) / (t3w_d i)) =
          (fun x : ℝ => ((13 * x / 8 : ℝ)) ^ (1/2 : ℝ) * (2 * (78/70 : ℝ) / (t3w_d i))) := by
        funext x
        ring
      rw [hshape]
      rw [logDeriv_mul t hCv hc0 hCf (differentiableAt_const t (2 * (78/70 : ℝ) / (t3w_d i)))]
      have hCeta : (fun x : ℝ => (13 * x / 8 : ℝ) ^ (1/2 : ℝ)) =
          (fun x : ℝ => ((13/8 : ℝ) * x + 0) ^ (1/2 : ℝ)) := by
        funext x
        ring
      rw [hCeta, t3wB_logDeriv_rpowLin (13/8 : ℝ) 0 (1/2 : ℝ) t hL0' hCdiff', logDeriv_const, add_zero]
      rw [show (13/8 : ℝ) * t = 13 * t / 8 from by ring]
    rw [hlAB, hlK]
    have hsum : ∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2 : ℝ) ^ 2) =
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
    have hmul : deriv (fun x : ℝ => t3wB_R i x) t =
        logDeriv (fun x : ℝ => t3wB_R i x) t * (t3wB_R i t) := by
      rw [show logDeriv (fun x : ℝ => t3wB_R i x) t =
          deriv (fun x : ℝ => t3wB_R i x) t / (t3wB_R i t) from by
        rw [logDeriv_apply]]
      rw [div_mul_cancel (deriv (fun x : ℝ => t3wB_R i x) t) hf0]
    rw [hmul, hlog, hhh]
    ring
  have hda : HasDerivAt (fun x : ℝ => t3wB_R i x) (deriv (fun x : ℝ => t3wB_R i x) t) t :=
    hdiff.hasDerivAt
  rw [hderiv] at hda
  exact hda
