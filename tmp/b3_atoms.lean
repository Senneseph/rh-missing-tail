/- 25ae Stage 3B.11 - Part B, batch 3: LogDeriv architecture for R_i' = R_i * h_i.
   Ordinary transformations borrowed from Mathlib.Analysis.Calculus.LogDeriv
   (logDeriv_prod / logDeriv_comp / logDeriv_mul / logDeriv_mul_const) -
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
      change DifferentiableAt Real (fun x : Real =>
          (∏ k ∈ Finset.range (n + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) *
          (x ^ 2 + ((n + 1 : Real) + 1/2) ^ 2)) t
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
      change logDeriv (fun x : Real =>
          (∏ k ∈ Finset.range (n + 1), x ^ 2 + (k + 1/2 : Real) ^ 2) *
          (x ^ 2 + (n + 1 + 1/2 : Real) ^ 2)) t =
        ∑ k ∈ Finset.range ((n + 1) + 1), 2 * t / (t ^ 2 + (k + 1/2 : Real) ^ 2)
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
      t3w_prod t i * (∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2) ^ 2)) := by
  have hg : 0 < t3w_prod t i := by
    dsimp only [t3w_prod]
    apply Finset.prod_pos
    intro k hk
    positivity
  have hlog := t3wB_logDeriv_t3wProd i t
  rw [logDeriv_apply] at hlog
  field_simp [hg.ne']
  exact hlog

/-- logDeriv of sqrt(t3w_prod): sum over k of t/(t^2 + (k+1/2)^2). -/
theorem t3wB_logDeriv_sqrtProd (i : Nat) (t : Real) :
    logDeriv (fun x : Real => Real.sqrt (t3w_prod x i)) t =
      ∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2) ^ 2) := by
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
    have hnz : Real.sqrt (t3w_prod t i) != 0 := by positivity
    rw [logDeriv_apply]
    have hd : deriv (fun z : Real => Real.sqrt z) (t3w_prod t i) =
        1 / (2 * Real.sqrt (t3w_prod t i)) := by
      rw [(hasDerivAt_sqrt (hP.ne')).deriv]
    rw [hd]
    field_simp [hP.ne', hnz]
    rw [mul_assoc, mul_self_sqrt hP.le]
    ring
  rw [hl, t3wB_prod_deriv i t]
  field_simp [hP.ne']
  have hS : (1/2 : Real) * (∑ k ∈ Finset.range (i + 1), 2 * t / (t ^ 2 + (k + 1/2) ^ 2)) =
      ∑ k ∈ Finset.range (i + 1), t / (t ^ 2 + (k + 1/2) ^ 2) := by
    rw [Finset.mul_sum]
    congr
    intro k hk
    ring
  rw [hS]

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
      rw [(Real.hasDerivAt_rpow_const (Or.inl hbz) y).deriv]
    rw [hd]
    field_simp [hbz, hnz]
    rw [show (a * t + b) ^ (y - 1) = (a * t + b) ^ y / (a * t + b) from by
      rw [Real.rpow_sub hb0 y 1, Real.rpow_one]]
    field_simp [hbz, hnz]
  rw [hl]
  have hi : deriv (fun x : Real => a * x + b) t = a := by
    rw [(((hasDerivAt_id t).const_mul a).add (hasDerivAt_const t b)).deriv]
    ring
  rw [hi]
  field_simp
  ring
