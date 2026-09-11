/- B3Sbar — the B-3 §5 section (pulled out of B3.lean, day-016 move):
    the S̄ primitives P011/Q029/R229 + sqInv_deriv + the four primitive
    derivative lemmas + Kbar_le + the master bound b3BoundExplicit
    (B-2's M(G,t) at finite B). Same lines, same names. -/
import Mathlib
import RhAttack.B3Core
import RhAttack.B3Abel

open Real Set MeasureTheory intervalIntegral

noncomputable section

variable (x : ℝ)

-- =====================================================================
-- §5 the explicit finite bound (B-2's M(G,t), finite-B form)
-- =====================================================================

-- Explicit primitives (flat). Regime: x ≥ e.  P011' = 0.110·ln x · x⁻³;
-- Q029' = 0.290·(ln ln x)·x⁻³ − 0.290/(2 x³ ln x);  R229' = 2.290·x⁻³.
def P011 (x : ℝ) : ℝ := -(0.110 * (log x + 1 / 2)) / (2 * x * x)
def Q029 (x : ℝ) : ℝ := -(0.290 / 2) * log (log x) / (x * x)
def R229 (x : ℝ) : ℝ := -(2.290 / 2) / (x * x)
/-- (z·z)⁻¹ has derivative −((x·x)²)⁻¹·2x for x > 0 (shared building block). -/
theorem sqInv_deriv (x : ℝ) (hx : 0 < x) :
    HasDerivAt (fun z : ℝ => (z * z)⁻¹) (-((x * x) ^ 2)⁻¹ * (2 * x)) x := by
  have hsqS : HasDerivAt ((fun z : ℝ => z) * (fun z : ℝ => z)) (1 * x + x * 1) x :=
    (hasDerivAt_id' (x := x)).mul (hasDerivAt_id' (x := x))
  have hsqFe : ((fun z : ℝ => z) * (fun z : ℝ => z)) = (fun z : ℝ => z * z) := by
    ext z
    simp
  have hsq : HasDerivAt (fun z : ℝ => z * z) (1 * x + x * 1) x := lift hsqFe hsqS
  have hsqD : HasDerivAt (fun z : ℝ => z * z) (2 * x) x := hsq.congr_deriv (by ring)
  have hS : HasDerivAt ((fun y : ℝ => y⁻¹) ∘ (fun z : ℝ => z * z))
      (-((x * x) ^ 2)⁻¹ * (2 * x)) x :=
    HasDerivAt.comp x (hasDerivAt_inv (x := x * x) (show x * x ≠ 0 from by nlinarith [hx])) hsqD
  have hFe : ((fun y : ℝ => y⁻¹) ∘ (fun z : ℝ => z * z)) = (fun z : ℝ => (z * z)⁻¹) := by
    ext z
    simp
  exact lift hFe hS

/-- P011′(x) = 0.110·ln x·x⁻³, x > 0. -/
theorem P011_deriv (x : ℝ) (hx : 0 < x) : HasDerivAt P011 (0.110 * log x / x^3) x := by
  let c : ℝ := -(0.110 / 2)
  have hlog : HasDerivAt log x⁻¹ x := hasDerivAt_log hx.ne'
  have hhalfS : HasDerivAt (log + (fun _ : ℝ => (1 / 2 : ℝ))) (x⁻¹ + 0) x :=
    HasDerivAt.add hlog (hasDerivAt_const x (1 / 2 : ℝ))
  have hhalfFe : (log + (fun _ : ℝ => (1 / 2 : ℝ))) = (fun z : ℝ => log z + 1 / 2) := by
    ext z
    simp
  have hhalf : HasDerivAt (fun z : ℝ => log z + 1 / 2) (x⁻¹ + 0) x := lift hhalfFe hhalfS
  have hhalfD : HasDerivAt (fun z : ℝ => log z + 1 / 2) x⁻¹ x := hhalf.congr_deriv (by ring)
  have hc : HasDerivAt (fun z : ℝ => c * (log z + 1 / 2)) (c * x⁻¹) x :=
    (hhalfD).const_mul c
  have hinv : HasDerivAt (fun z : ℝ => (z * z)⁻¹) (-((x * x) ^ 2)⁻¹ * (2 * x)) x :=
    sqInv_deriv x hx
  -- mul surface (4.33.1 order): c' * d x + c x * d'
  have hS : HasDerivAt
      ((fun z : ℝ => c * (log z + 1 / 2)) * (fun z : ℝ => (z * z)⁻¹))
      ((c * x⁻¹) * (x * x)⁻¹ + (c * (log x + 1 / 2)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    hc.mul hinv
  have hSFe : (fun z : ℝ => (c * (log z + 1 / 2)) * (z * z)⁻¹) =
      (fun z : ℝ => c * (log z + 1 / 2) * (z * z)⁻¹) := by ext z; ring
  have hFin : HasDerivAt
      (fun z : ℝ => c * (log z + 1 / 2) * (z * z)⁻¹)
      ((c * x⁻¹) * (x * x)⁻¹ + (c * (log x + 1 / 2)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    lift hSFe hS
  have hFinFe : (fun z : ℝ => c * (log z + 1 / 2) * (z * z)⁻¹) = P011 := by
    ext z
    rw [show c = -(0.110 / 2) from rfl]
    dsimp [P011]
    field_simp
  have hF : HasDerivAt P011
      ((c * x⁻¹) * (x * x)⁻¹ + (c * (log x + 1 / 2)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    lift hFinFe hFin
  exact hF.congr_deriv (by
    field_simp
    ring)

/-- Q029′(x) = 0.290·ln(ln x)·x⁻³ − 0.290/(2·x³·ln x), 1 < x. -/
theorem Q029_deriv (x : ℝ) (hx : 1 < x) :
    HasDerivAt Q029 (0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x)) x := by
  let c : ℝ := -(0.290 / 2)
  have hlx : 0 < log x := Real.log_pos hx
  have hx0 : x ≠ 0 := ne_of_gt (show (0 : ℝ) < x from by linarith)
  have hloglogS : HasDerivAt (log ∘ log) ((log x)⁻¹ * x⁻¹) x :=
    HasDerivAt.comp x (hasDerivAt_log (x := log x) hlx.ne') (hasDerivAt_log hx0)
  have hloglogFe : (log ∘ log) = (fun z : ℝ => log (log z)) := by ext z; simp
  have hloglog : HasDerivAt (fun z : ℝ => log (log z)) ((log x)⁻¹ * x⁻¹) x :=
    lift hloglogFe hloglogS
  have hc : HasDerivAt (fun z : ℝ => c * log (log z)) (c * ((log x)⁻¹ * x⁻¹)) x :=
    (hloglog).const_mul c
  have hinv : HasDerivAt (fun z : ℝ => (z * z)⁻¹) (-((x * x) ^ 2)⁻¹ * (2 * x)) x :=
    sqInv_deriv x (by linarith)
  -- mul surface (4.33.1 order): c' * d x + c x * d'
  have hS : HasDerivAt
      ((fun z : ℝ => c * log (log z)) * (fun z : ℝ => (z * z)⁻¹))
      ((c * ((log x)⁻¹ * x⁻¹)) * (x * x)⁻¹ +
         (c * log (log x)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    hc.mul hinv
  have hSFe : (fun z : ℝ => (c * log (log z)) * (z * z)⁻¹) =
      (fun z : ℝ => c * log (log z) * (z * z)⁻¹) := by ext z; ring
  have hFin : HasDerivAt
      (fun z : ℝ => c * log (log z) * (z * z)⁻¹)
      ((c * ((log x)⁻¹ * x⁻¹)) * (x * x)⁻¹ +
         (c * log (log x)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    lift hSFe hS
  have hFinFe : (fun z : ℝ => c * log (log z) * (z * z)⁻¹) = Q029 := by
    ext z
    rw [show c = -(0.290 / 2) from rfl]
    dsimp [Q029]
    field_simp
  have hF : HasDerivAt Q029
      ((c * ((log x)⁻¹ * x⁻¹)) * (x * x)⁻¹ +
         (c * log (log x)) * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    lift hFinFe hFin
  exact hF.congr_deriv (by
    field_simp
    ring)

/-- R229′(x) = 2.290·x⁻³, x > 0. -/
theorem R229_deriv (x : ℝ) (hx : 0 < x) : HasDerivAt R229 (2.290 / x^3) x := by
  let c : ℝ := -(2.290 / 2)
  have hc : HasDerivAt (fun z : ℝ => c * (z * z)⁻¹) (c * (-((x * x) ^ 2)⁻¹ * (2 * x))) x :=
    (sqInv_deriv x hx).const_mul c
  have hcFe : (fun z : ℝ => c * (z * z)⁻¹) = R229 := by
    ext z
    rw [show c = -(2.290 / 2) from rfl]
    dsimp [R229]
    field_simp
  have hF : HasDerivAt R229 (c * (-((x * x) ^ 2)⁻¹ * (2 * x))) x := lift hcFe hc
  exact hF.congr_deriv (by
    field_simp
    ring)
/-- ∫_G^B S̄·x⁻³ ≤ K̄(G) for e ≤ G < B (explicit-primitive proof;
    spec/b2-tail-bound.md §5). -/
theorem Kbar_le (G B : ℝ) (hG : Real.exp 1 ≤ G) (h'GB : G < B) :
    ∫ x in G..B, Sbar x / x^3 ≤ Kbar G := by
  have he1 : 1 < Real.exp 1 := by
    calc (1 : ℝ) = Real.exp 0 := Real.exp_zero.symm
      _ < Real.exp 1 := Real.exp_lt_exp.1 (by norm_num)
  have hposG : 0 < G := by linarith [Real.exp_pos 1, hG]
  have h1G : 1 < G := by linarith [he1, hG]
  have h1B : Real.exp 1 ≤ B := by linarith
  have hposB : 0 < B := by linarith [Real.exp_pos 1, h1B]
  have hlogG : 1 ≤ log G := by
    calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
      _ ≤ log G := log_le_log (Real.exp_pos 1) hG
  have hlogB : 1 ≤ log B := by
    calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
      _ ≤ log B := log_le_log (Real.exp_pos 1) h1B
  -- pointwise primitives
  have hP : ∀ x ∈ Icc G B, HasDerivAt P011 (0.110 * log x / x^3) x := by
    intro x hx
    exact P011_deriv x (by linarith [hposG, hx.1])
  have hQ : ∀ x ∈ Icc G B,
      HasDerivAt Q029 (0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x)) x := by
    intro x hx
    exact Q029_deriv x (by linarith [h1G, hx.1])
  have hR : ∀ x ∈ Icc G B, HasDerivAt R229 (2.290 / x^3) x := by
    intro x hx
    exact R229_deriv x (by linarith [hposG, hx.1])
  -- integrability of the five primitive functions (all continuous on Icc G B)
  have hlogx_cont : ∀ x ∈ Icc G B, 0 < log x := by
    intro x hx
    have hle : log G ≤ log x := log_le_log hposG (by linarith [hx.1])
    have hge : 1 ≤ log x := by linarith [hlogG, hle]
    linarith [hge]
  have hIIPc : ContinuousOn (fun x : ℝ => 0.110 * log x / x^3) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hlog : ContinuousAt log x := continuousAt_log (ne_of_gt hx0)
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC1 : ContinuousAt (fun _ : ℝ => (0.110 : ℝ)) x := continuousAt_const
    have hA : ContinuousAt (fun z : ℝ => 0.110 * log z) x := hC1.mul hlog
    exact (hA.div hz3p (ne_of_gt (pow_pos hx0 3))).continuousWithinAt (s := Icc G B)
  have hIIP : IntervalIntegrable (fun x : ℝ => 0.110 * log x / x^3) volume G B :=
    hIIPc.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  have hIIQdc : ContinuousOn
      (fun x : ℝ => 0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x)) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hlx : 1 ≤ log x := by linarith [hlogG, log_le_log hposG (by linarith [hx.1])]
    have hlx0 : 0 < log x := by linarith [hlx]
    have hlog : ContinuousAt log x := continuousAt_log (ne_of_gt hx0)
    have hloglog : ContinuousAt (fun z : ℝ => log (log z)) x :=
      continuousAt_log (ne_of_gt hlx0) |>.comp hlog
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC1 : ContinuousAt (fun _ : ℝ => (0.290 : ℝ)) x := continuousAt_const
    have hA : ContinuousAt (fun z : ℝ => 0.290 * log (log z)) x := hC1.mul hloglog
    have htermA : ContinuousAt (fun z : ℝ => (0.290 * log (log z)) / z ^ 3) x :=
      hA.div hz3p (ne_of_gt (pow_pos hx0 3))
    have hC2 : ContinuousAt (fun _ : ℝ => (2 : ℝ)) x := continuousAt_const
    have htwo : ContinuousAt (fun z : ℝ => 2 * z ^ 3 * log z) x :=
      (hC2.mul hz3p).mul hlog
    have hB : ContinuousAt (fun z : ℝ => 0.290 / (2 * z ^ 3 * log z)) x :=
      hC1.div htwo (by
        apply mul_ne_zero
        · apply mul_ne_zero
          · norm_num
          · exact ne_of_gt (pow_pos hx0 3)
        · exact ne_of_gt hlx0)
    have hsum : ContinuousAt (fun z : ℝ => (0.290 * log (log z)) / z ^ 3 -
        0.290 / (2 * z ^ 3 * log z)) x := htermA.sub hB
    exact hsum.continuousWithinAt (s := Icc G B)
  have hIIQd : IntervalIntegrable
      (fun x : ℝ => 0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x)) volume G B :=
    hIIQdc.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  have hIIRc : ContinuousOn (fun x : ℝ => 2.290 / x^3) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC1 : ContinuousAt (fun _ : ℝ => (2.290 : ℝ)) x := continuousAt_const
    exact (hC1.div hz3p (ne_of_gt (pow_pos hx0 3))).continuousWithinAt (s := Icc G B)
  have hIIR : IntervalIntegrable (fun x : ℝ => 2.290 / x^3) volume G B :=
    hIIRc.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  have hIIremc : ContinuousOn (fun x : ℝ => 0.290 / (2 * x^3 * log x)) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hlx := hlogx_cont x hx
    have hlog : ContinuousAt log x := continuousAt_log (ne_of_gt hx0)
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC2 : ContinuousAt (fun _ : ℝ => (2 : ℝ)) x := continuousAt_const
    have h23 : ContinuousAt (fun z : ℝ => 2 * z ^ 3) x := hC2.mul hz3p
    have h23l : ContinuousAt (fun z : ℝ => 2 * z ^ 3 * log z) x := h23.mul hlog
    have hC1 : ContinuousAt (fun _ : ℝ => (0.290 : ℝ)) x := continuousAt_const
    exact (hC1.div h23l (by
      apply mul_ne_zero
      · apply mul_ne_zero
        · norm_num
        · exact ne_of_gt (pow_pos hx0 3)
      · exact ne_of_gt hlx)).continuousWithinAt (s := Icc G B)
  have hIIrem : IntervalIntegrable (fun x : ℝ => 0.290 / (2 * x^3 * log x)) volume G B :=
    hIIremc.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  have hIIrem2c : ContinuousOn (fun x : ℝ => 0.290 / (2 * x^3)) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC2 : ContinuousAt (fun _ : ℝ => (2 : ℝ)) x := continuousAt_const
    have h23 : ContinuousAt (fun z : ℝ => 2 * z ^ 3) x := hC2.mul hz3p
    have hC1 : ContinuousAt (fun _ : ℝ => (0.290 : ℝ)) x := continuousAt_const
    exact (hC1.div h23 (by
      apply mul_ne_zero
      · norm_num
      · exact ne_of_gt (pow_pos hx0 3))).continuousWithinAt (s := Icc G B)
  have hIIrem2 : IntervalIntegrable (fun x : ℝ => 0.290 / (2 * x^3)) volume G B :=
    hIIrem2c.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  have hIIQsc : ContinuousOn (fun x : ℝ => 0.290 * log (log x) / x^3) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hposG, hx.1]
    have hlx : 1 ≤ log x := by linarith [hlogG, log_le_log hposG (by linarith [hx.1])]
    have hlx0 : 0 < log x := by linarith [hlx]
    have hlog : ContinuousAt log x := continuousAt_log (ne_of_gt hx0)
    have hloglog : ContinuousAt (fun z : ℝ => log (log z)) x :=
      continuousAt_log (ne_of_gt hlx0) |>.comp hlog
    have hId := continuousAt_id' (x : ℝ)
    have hz2 : ContinuousAt (fun z : ℝ => z * z) x := hId.mul hId
    have hz3 : ContinuousAt (fun z : ℝ => z * z * z) x := hz2.mul hId
    have hz3Fe : (fun z : ℝ => z * z * z) = (fun z : ℝ => z ^ 3) := by ext z; ring
    have hz3p : ContinuousAt (fun z : ℝ => z ^ 3) x := hz3.congr hz3Fe.eventuallyEq
    have hC1 : ContinuousAt (fun _ : ℝ => (0.290 : ℝ)) x := continuousAt_const
    have hA : ContinuousAt (fun z : ℝ => 0.290 * log (log z)) x := hC1.mul hloglog
    exact (hA.div hz3p (ne_of_gt (pow_pos hx0 3))).continuousWithinAt (s := Icc G B)
  have hIIQs : IntervalIntegrable (fun x : ℝ => 0.290 * log (log x) / x^3) volume G B :=
    hIIQsc.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'GB)
  -- primitive values (the hasDerivAt FTC)
  have vP : ∫ x in G..B, 0.110 * log x / x^3 = P011 B - P011 G := by
    rw [integral_eq_sub_of_hasDerivAt]
    · intro x hx
      exact hP x (by simpa [uIcc_of_le (le_of_lt h'GB)] using hx)
    · exact hIIP
  have vQd : ∫ x in G..B, 0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x) =
      Q029 B - Q029 G := by
    rw [integral_eq_sub_of_hasDerivAt]
    · intro x hx
      exact hQ x (by simpa [uIcc_of_le (le_of_lt h'GB)] using hx)
    · exact hIIQd
  have vR : ∫ x in G..B, 2.290 / x^3 = R229 B - R229 G := by
    rw [integral_eq_sub_of_hasDerivAt]
    · intro x hx
      exact hR x (by simpa [uIcc_of_le (le_of_lt h'GB)] using hx)
    · exact hIIR
  have vQ : ∫ x in G..B, 0.290 * log (log x) / x^3 =
      (Q029 B - Q029 G) + ∫ x in G..B, 0.290 / (2 * x^3 * log x) := by
    have hpt : ∀ x, (0.290 * log (log x) / x^3) =
        (0.290 * log (log x) / x^3 - 0.290 / (2 * x^3 * log x)) +
        (0.290 / (2 * x^3 * log x)) := by
      intro x
      ring
    rw [integral_congr_uIoo (fun x (_ : x ∈ uIoo G B) => hpt x)]
    rw [integral_add hIIQd hIIrem, vQd]
  -- the S̄-x⁻³ decomposition
  have hU (x : ℝ) (hx : x ∈ uIoo G B) : x ∈ Icc G B := by
    rw [uIoo_of_lt h'GB] at hx
    exact ⟨le_of_lt hx.1, le_of_lt hx.2⟩
  have vS : ∫ x in G..B, Sbar x / x^3 =
      (P011 B - P011 G) + (Q029 B - Q029 G) + (∫ x in G..B, 0.290 / (2 * x^3 * log x)) +
        (R229 B - R229 G) := by
    have hpt : ∀ x ∈ Icc G B, (Sbar x / x^3) =
        (0.110 * log x / x^3) + (0.290 * log (log x) / x^3) + (2.290 / x^3) := by
      intro x hx
      have hx0 : 0 < x := by linarith [hposG, hx.1]
      have hlx := hlogx_cont x hx
      dsimp only [Sbar]
      field_simp [hx0.ne', hlx.ne']
    rw [integral_congr_uIoo (fun x (hx : x ∈ uIoo G B) => hpt x (hU x hx))]
    rw [integral_add (hIIP.add hIIQs) hIIR]
    rw [integral_add hIIP hIIQs]
    rw [vP, vQ, vR]
    ring
  -- the primitives descend at B (all three are ≤ 0 at x = B)
  have hPn : P011 B ≤ 0 := by
    have h1 : 0 < 0.110 * (log B + 1 / 2) := by
      apply mul_pos
      · norm_num
      · linarith [hlogB]
    have h2 : 0 < 2 * B * B := by nlinarith [hposB]
    dsimp only [P011]
    rw [div_le_iff₀ (by nlinarith [hposB])]
    nlinarith [h1]
  have hQn : Q029 B ≤ 0 := by
    have hlnln : 0 ≤ log (log B) := by
      calc 0 = log 1 := (Real.log_one).symm
        _ ≤ log (log B) := log_le_log (by norm_num) hlogB
    have h1 : 0 ≤ (0.290 / 2) * log (log B) := by
      apply mul_nonneg
      · norm_num
      · exact hlnln
    dsimp only [Q029]
    have hBB : 0 < B * B := by nlinarith [hposB]
    rw [div_le_iff₀ hBB]
    ring_nf
    nlinarith [h1]
  have hRn : R229 B ≤ 0 := by
    dsimp only [R229]
    have h1 : 0 < (2.290 / 2) / (B * B) := by
      apply div_pos
      · norm_num
      · nlinarith [hposB]
    linarith [h1]
  -- the remainder is bounded by removing the ln: 1/ln x ≤ 1 for x ≥ e
  have hremle : ∫ x in G..B, 0.290 / (2 * x^3 * log x) ≤ ∫ x in G..B, 0.290 / (2 * x^3) := by
    have hpt : ∀ x ∈ Icc G B, 0.290 / (2 * x^3 * log x) ≤ 0.290 / (2 * x^3) := by
      intro x hx
      have hx0 : 0 < x := by linarith [hposG, hx.1]
      have hlx : 1 ≤ log x := by
        linarith [hlogG, log_le_log hposG (le_of_lt (lt_of_le_of_lt hx.1 h'GB))]
      have hinv : 1 / log x ≤ 1 := (div_le_one (by linarith [hlx])).mpr hlx
      calc 0.290 / (2 * x^3 * log x) = (0.290 / (2 * x^3)) * (1 / log x) := by
        field_simp [hx0.ne', show log x ≠ 0 from by linarith [hlx]]
        <;> ring_nf
        <;> field_simp [hx0.ne', show log x ≠ 0 from by linarith [hlx]]
        <;> ring
      _ ≤ (0.290 / (2 * x^3)) * 1 := by
        apply mul_le_mul_of_nonneg_left hinv
        apply div_nonneg
        · norm_num
        · nlinarith [hx0]
      _ = 0.290 / (2 * x^3) := by ring
    haveI : IntervalIntegrable (fun x : ℝ => 0.290 / (2 * x^3 * log x)) volume G B := hIIrem
    haveI : IntervalIntegrable (fun x : ℝ => 0.290 / (2 * x^3)) volume G B := hIIrem2
    exact intervalIntegral.integral_mono_on (by linarith : G ≤ B) hIIrem hIIrem2 hpt
  -- ∫ 0.290/(2x³) = (0.290/2.290/2)·(R229 B − R229 G)
  have v029 : ∫ x in G..B, 0.290 / (2 * x^3) = (0.290 / (2 * 2.290)) * (R229 B - R229 G) := by
    have hpt : ∀ x ∈ uIoo G B, (0.290 / (2 * x^3)) =
        ((0.290 / (2 * 2.290)) * (2.290 / x^3)) := by
      intro x hx
      have hxIoo : x ∈ Ioo G B := by
        rw [uIoo_of_lt h'GB] at hx
        exact hx
      have hx0 : 0 < x := by linarith [hposG, hxIoo.1]
      field_simp [hx0.ne']
      ring
    rw [integral_congr_uIoo hpt]
    rw [show ∫ x in G..B, (0.290 / (2 * 2.290)) * (2.290 / x^3) =
        ∫ x in G..B, (2.290 / x^3) * (0.290 / (2 * 2.290)) from by
      rw [integral_congr_uIoo (fun x _ => by ring)]
    rw [integral_mul_const (0.290 / (2 * 2.290)) (fun x : ℝ => 2.290 / x^3), vR]
    ring
  -- assemble
  calc ∫ x in G..B, Sbar x / x^3
      = (P011 B - P011 G) + (Q029 B - Q029 G) + (∫ x in G..B, 0.290 / (2 * x^3 * log x)) +
          (R229 B - R229 G) := by
        rw [vS]
      _ ≤ (0 - P011 G) + (0 - Q029 G) + (∫ x in G..B, 0.290 / (2 * x^3 * log x)) +
          (0 - R229 G) := by
        nlinarith [hPn, hQn, hRn]
      _ = -P011 G - Q029 G + (∫ x in G..B, 0.290 / (2 * x^3 * log x)) - R229 G := by
        ring
      _ ≤ -P011 G - Q029 G + (∫ x in G..B, 0.290 / (2 * x^3)) - R229 G := by
        add_le_add (add_le_add (add_le_add le_rfl le_rfl) hremle) le_rfl
      _ = -P011 G - Q029 G + (0.290 / (2 * 2.290)) * (R229 B - R229 G) - R229 G := by
        rw [v029]
      _ ≤ -P011 G - Q029 G + (0.290 / (2 * 2.290)) * (0 - R229 G) - R229 G := by
        have hc : 0 < 0.290 / (2 * 2.290) := by norm_num
        nlinarith [hc, hRn]
      _ = Kbar G := by
        dsimp only [P011, Q029, R229, Kbar]
        field_simp [show G ≠ 0 from by linarith [hposG]]
        ring

/-- The explicit finite bound (B-2's M(G,t), finite-B form): for a
    counting step N_L approximating the RVM main term N̂ with fluctuation
    bounded by the Platt–Trudgian S̄ (J. Number Theory 147 (2015) 842-851,
    Cor 1; ledged in FORMULAS §1.3), the Σ-vs-model-kernel residual on
    [G, B] is at most Bf·(S̄ B + S̄ G) + Cf·K̄(G). -/
theorem b3BoundExplicit (L : List ℝ) (t G B : ℝ) (ht : 0 < t) (hGt : t < G)
    (hG : Real.exp 1 ≤ G) (hGB : G < B)
    (hS : ∀ x ∈ Icc G B, |NList L x - NHat x| ≤ Sbar x) :
    |((L.map (fun (g : ℝ) => if G < g ∧ g ≤ B then fT t g else 0)).sum) -
      ∫ x in G..B, nHat x * fT t x| ≤
      Bf t G * (Sbar B + Sbar G) + Cf t G * Kbar G := by
  -- differentiability of fT t on Icc G B (pointwise) + closed-form derivative
  have hfderiv : ∀ x ∈ Icc G B, HasDerivAt (fun x : ℝ => fT t x) (deriv (fun x : ℝ => fT t x) x) x := by
    intro x hx
    have h := fT_deriv t x ht (by linarith [hGt, hx.1])
    simpa [HasDerivAt.deriv h] using h
  have hf'eq : ∀ x ∈ Icc G B, deriv (fun x : ℝ => fT t x) x = fTp t x := by
    intro x hx
    exact HasDerivAt.deriv (fT_deriv t x ht (by linarith [hGt, hx.1]))
  have hFtpCont : ContinuousOn (fun x : ℝ => fTp t x) (Icc G B) := by
    intro x hx
    have hx0 : 0 < x := by linarith [hGt, hx.1]
    have hux : 0 < u x := by dsimp only [u]; nlinarith [hx0]
    have hx3 : 0 < x * x - t * t := by nlinarith [hGt, hx.1]
    have hId : ContinuousAt (fun z : ℝ => z) x := continuousAt_id' (x : ℝ)
    have hC1 : ContinuousAt (fun _ : ℝ => (1 / 4 : ℝ)) x := continuousAt_const
    have hu : ContinuousAt (fun z : ℝ => z * z + 1 / 4) x :=
      hId.mul hId |>.add hC1
    have huFe : (fun z : ℝ => z * z + 1 / 4) = (fun z : ℝ => u z) := by
      ext z
      dsimp only [u]
    have huU : ContinuousAt (fun z : ℝ => u z) x := hu.congr huFe.eventuallyEq
    have hu2 : ContinuousAt (fun z : ℝ => (u z) ^ 2) x :=
      huU.mul huU |>.congr
        ((by ext z; ring : (fun z : ℝ => u z * u z) = (fun z : ℝ => (u z) ^ 2))).eventuallyEq
    have hinvu : ContinuousAt (fun z : ℝ => ((u z) ^ 2)⁻¹) x := by
      apply ContinuousAt.comp'
      · exact continuousAt_inv₀ (ne_of_gt (pow_pos hux 2))
      · exact hu2
    have hz1 : ContinuousAt (fun z : ℝ => -z) x := hId.neg
    have hterm1 : ContinuousAt (fun z : ℝ => -z / (u z) ^ 2) x :=
      hz1.div hu2 (ne_of_gt (pow_pos hux 2))
    have hCt : ContinuousAt (fun _ : ℝ => (t * t : ℝ)) x := continuousAt_const
    have hxx : ContinuousAt (fun z : ℝ => z * z - t * t) x :=
      hId.mul hId |>.sub hCt
    have hd : ContinuousAt (fun z : ℝ => u z * (z * z - t * t)) x := huU.mul hxx
    have hC2 : ContinuousAt (fun _ : ℝ => (2 : ℝ)) x := continuousAt_const
    have hCw : ContinuousAt (fun _ : ℝ => (w t : ℝ)) x := continuousAt_const
    have hnum : ContinuousAt (fun z : ℝ => 2 * z * (w t)) x :=
      hC2.mul hId |>.mul hCw
    have hhd : 0 < u x * (x * x - t * t) := by nlinarith [hux, hx3]
    have hterm2 : ContinuousAt
        (fun z : ℝ => (2 * z * (w t)) / (u z * (z * z - t * t))) x :=
      hnum.div hd (ne_of_gt hhd)
    have hsum : ContinuousAt (fun z : ℝ => -z / (u z) ^ 2 +
        (2 * z * (w t)) / (u z * (z * z - t * t))) x := hterm1.add hterm2
    have hFe : (fun z : ℝ => -z / (u z) ^ 2 +
        (2 * z * (w t)) / (u z * (z * z - t * t))) =
        (fun z : ℝ => fTp t z) := by
      ext z
      dsimp only [fTp]
    exact (hsum.congr hFe.eventuallyEq).continuousWithinAt (s := Icc G B)
  have hf'cont : ContinuousOn (deriv (fun x : ℝ => fT t x)) (Icc G B) :=
    hFtpCont.congr (fun x hx => hf'eq x hx)
  have hFcont : ContinuousOn (fun x : ℝ => fT t x) (Icc G B) :=
    HasDerivAt.continuousOn hfderiv
  have hposGx : ∀ x ∈ Icc G B, 0 < x := fun x hx => by linarith [hGt, hx.1]
  have hnHat : ContinuousOn nHat (Icc G B) := nHatContinuousOn hposGx
  have hNHat : ContinuousOn NHat (Icc G B) := NHatContinuousOn hposGx
  -- integrability
  have hII_f' : IntervalIntegrable (fun x => deriv (fun x : ℝ => fT t x) x) volume G B :=
    (hFtpCont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt hGB)).congr_ae (by
      rw [uIoc_of_le (le_of_lt hGB), ← restrict_Ioo_eq_restrict_Ioc]
      exact Set.EqOn.aeEq_restrict
        (fun x (hx : x ∈ Ioo G B) => by
          simpa using (hf'eq x ⟨le_of_lt hx.1, le_of_lt hx.2⟩).symm
        ) measurableSet_Ioo)
  have hII_NHatf' : IntervalIntegrable (fun x => NHat x * deriv (fun x : ℝ => fT t x) x) volume G B :=
    (hNHat.mul hf'cont).intervalIntegrable_of_Icc (μ := volume) (le_of_lt hGB)
  have hII_NListf' : IntervalIntegrable (fun x => NList L x * deriv (fun x : ℝ => fT t x) x) volume G B :=
    NListRayIntegrable L (by linarith : G < B) hf'cont
  have hII_nHatf : IntervalIntegrable (fun x => nHat x * fT t x) volume G B :=
    hnHat.mul hFcont |>.intervalIntegrable_of_Icc (μ := volume) (le_of_lt hGB)
  -- the LHS identity
  have hAbel : ∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x =
      fT t B * NList L B - fT t G * NList L G -
        (L.map (fun (g : ℝ) => if G < g ∧ g ≤ B then fT t g else 0)).sum :=
    b3Abel L (by linarith : G < B) hfderiv hf'cont
  have hIBP : ∫ x in G..B, nHat x * fT t x =
      NHat B * fT t B - NHat G * fT t G - (∫ x in G..B, NHat x * deriv (fun x : ℝ => fT t x) x) :=
    nHatIBP (by linarith : G < B) (by linarith : 0 < G) hfderiv hf'cont
  set Δfun := fun x : ℝ => (NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x with hΔ
  have hΔeq : ∫ x in G..B, Δfun x =
      (∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x) -
        (∫ x in G..B, NHat x * deriv (fun x : ℝ => fT t x) x) := by
    have hptΔ : ∀ x ∈ uIoo G B, Δfun x =
        NList L x * deriv (fun x : ℝ => fT t x) x - NHat x * deriv (fun x : ℝ => fT t x) x := by
      intro x hx
      dsimp only [Δfun]
      ring
    rw [integral_congr_uIoo hptΔ]
    rw [intervalIntegral.integral_sub hII_NListf' hII_NHatf']
  have hlhs : (L.map (fun (g : ℝ) => if G < g ∧ g ≤ B then fT t g else 0)).sum -
      ∫ x in G..B, nHat x * fT t x =
      fT t B * (NList L B - NHat B) -
        (fT t G * (NList L G - NHat G) + ∫ x in G..B, Δfun x) := by
    calc (L.map (fun (g : ℝ) => if G < g ∧ g ≤ B then fT t g else 0)).sum -
          ∫ x in G..B, nHat x * fT t x
        = (fT t B * NList L B - fT t G * NList L G -
            ∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x) -
            ∫ x in G..B, nHat x * fT t x := by
          rw [show (L.map (fun (g : ℝ) => if G < g ∧ g ≤ B then fT t g else 0)).sum =
              fT t B * NList L B - fT t G * NList L G -
                ∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x from
            by linarith [hAbel]]
      _ = (fT t B * NList L B - fT t G * NList L G -
            ∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x) -
          (NHat B * fT t B - NHat G * fT t G -
            ∫ x in G..B, NHat x * deriv (fun x : ℝ => fT t x) x) := by
        rw [hIBP]
      _ = fT t B * (NList L B - NHat B) -
          (fT t G * (NList L G - NHat G) + ∫ x in G..B, Δfun x) := by
        rw [hΔeq]
        ring
  -- the bound
  have hSB : |NList L B - NHat B| ≤ Sbar B := hS B (by constructor <;> linarith)
  have hSG : |NList L G - NHat G| ≤ Sbar G := hS G (by constructor <;> linarith)
  have hBf : |fT t B| ≤ Bf t G := fT_bound t B G ht hGt (by linarith)
  have hGf : |fT t G| ≤ Bf t G := fT_bound t G G ht hGt (by linarith)
  have hBfN : 0 ≤ Bf t G := by
    dsimp only [Bf]
    have hden : 0 < 1 - w t / (G * G + 1 / 4) := by
      rw [sub_pos, div_lt_one (by nlinarith)]
      dsimp only [w]
      nlinarith [hGt]
    apply add_nonneg
    · apply add_nonneg
      · apply div_nonneg
        · norm_num
        · nlinarith
      · apply div_nonneg
        · apply div_nonneg
          · dsimp only [w]
            nlinarith
          · nlinarith
        · linarith [hden]
    · apply div_nonneg
      · linarith [ht]
      · nlinarith
  have hSbarB : 0 ≤ Sbar B := by
    have h1 : 1 ≤ log B := by
      calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
        _ ≤ log B := log_le_log (Real.exp_pos 1) (by linarith [hG, hGB])
    have h2 : 0 ≤ log (log B) := by
      calc 0 = log 1 := (Real.log_one).symm
        _ ≤ log (log B) := log_le_log (by norm_num) h1
    dsimp only [Sbar]
    apply add_nonneg
    · apply add_nonneg
      · apply mul_nonneg <;> (try norm_num) <;> linarith [h1]
      · apply mul_nonneg <;> (try norm_num) <;> exact h2
    · norm_num
  have hSbarG : 0 ≤ Sbar G := by
    have h1 : 1 ≤ log G := by
      calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
        _ ≤ log G := log_le_log (Real.exp_pos 1) hG
    have h2 : 0 ≤ log (log G) := by
      calc 0 = log 1 := (Real.log_one).symm
        _ ≤ log (log G) := log_le_log (by norm_num) h1
    dsimp only [Sbar]
    apply add_nonneg
    · apply add_nonneg
      · apply mul_nonneg <;> (try norm_num) <;> linarith [h1]
      · apply mul_nonneg <;> (try norm_num) <;> exact h2
    · norm_num
  have hCfN : 0 ≤ Cf t G := by
    dsimp only [Cf]
    apply add_nonneg
    · norm_num
    · apply div_nonneg
      · apply mul_nonneg
        · apply mul_nonneg
          · norm_num
          · dsimp only [w]
            nlinarith
        · nlinarith
      · nlinarith [hGt]
  rw [hlhs]
  calc |(fT t B * (NList L B - NHat B)) -
        (fT t G * (NList L G - NHat G) + ∫ x in G..B, Δfun x)|
      ≤ |(fT t B * (NList L B - NHat B))| +
          |(fT t G * (NList L G - NHat G)) + ∫ x in G..B, Δfun x| :=
        abs_sub (fT t B * (NList L B - NHat B))
          (fT t G * (NList L G - NHat G) + ∫ x in G..B, Δfun x)
    _ ≤ |(fT t B * (NList L B - NHat B))| + |(fT t G * (NList L G - NHat G))| +
          |∫ x in G..B, Δfun x| := by
      apply add_le_add_left
      simpa using abs_sub (fT t G * (NList L G - NHat G))
        (-(∫ x in G..B, Δfun x))
    _ = |fT t B| * |NList L B - NHat B| + |fT t G| * |NList L G - NHat G| +
          |∫ x in G..B, Δfun x| := by
        rw [abs_mul, abs_mul]
    _ ≤ Bf t G * Sbar B + Bf t G * Sbar G + |∫ x in G..B, Δfun x| := by
        have hX : |fT t B| * |NList L B - NHat B| ≤ Bf t G * Sbar B := by
          calc |fT t B| * |NList L B - NHat B| ≤ Bf t G * |NList L B - NHat B| :=
              mul_le_mul_of_nonneg_right hBf (abs_nonneg _)
            _ ≤ Bf t G * Sbar B :=
              mul_le_mul_of_nonneg_left hSB hBfN
        have hG : |fT t G| * |NList L G - NHat G| ≤ Bf t G * Sbar G := by
          calc |fT t G| * |NList L G - NHat G| ≤ Bf t G * |NList L G - NHat G| :=
              mul_le_mul_of_nonneg_right hGf (abs_nonneg _)
            _ ≤ Bf t G * Sbar G :=
              mul_le_mul_of_nonneg_left hSG (by linarith [hBfN])
        apply add_le_add
        · apply add_le_add
          · exact hX
          · exact hG
        · exact le_rfl
    _ = Bf t G * (Sbar B + Sbar G) + |∫ x in G..B, Δfun x| := by
        rw [mul_add]
        ring
    _ ≤ Bf t G * (Sbar B + Sbar G) + Cf t G * Kbar G := by
        have hcZ : |∫ x in G..B, Δfun x| ≤ Cf t G * Kbar G := by
          have hIIdiff : IntervalIntegrable (fun x => NList L x * deriv (fun x : ℝ => fT t x) x -
              NHat x * deriv (fun x : ℝ => fT t x) x) volume G B :=
            hII_NListf'.sub hII_NHatf'
          have hIIabs : IntervalIntegrable
              (fun x => |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x|) volume G B :=
            (show IntervalIntegrable
                (fun x : ℝ => abs (NList L x * deriv (fun x : ℝ => fT t x) x -
                  NHat x * deriv (fun x : ℝ => fT t x) x)) volume G B from
              hIIdiff.abs).congr_ae (by
                rw [uIoc_of_le (le_of_lt hGB), ← restrict_Ioo_eq_restrict_Ioc]
                exact Set.EqOn.aeEq_restrict
                  (fun x (hx : x ∈ Ioo G B) => by
                    ring
                  ) measurableSet_Ioo)
          have hZ1 : |∫ x in G..B, Δfun x| ≤
              ∫ x in G..B, |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x| := by
            have hpt2 : ∀ x ∈ uIoo G B, Δfun x =
                (NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x := by
              intro x hx
              dsimp only [Δfun]
              ring
            have hI : ∫ x in G..B, Δfun x =
                ∫ x in G..B, (NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x := by
              rw [integral_congr_uIoo hpt2]
            rw [hI]
            exact abs_integral_le_integral_abs
          have hf'pt : ∀ x ∈ Icc G B,
              |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x| ≤
                Sbar x * |deriv (fun x : ℝ => fT t x) x| := by
            intro x hx
            calc |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x|
                = |NList L x - NHat x| * |deriv (fun x : ℝ => fT t x) x| := by rw [abs_mul]
              _ ≤ Sbar x * |deriv (fun x : ℝ => fT t x) x| := by
                apply mul_le_mul_of_nonneg_right (hS x hx)
                exact abs_nonneg _
          have hSbarf'cont : ContinuousOn
              (fun x : ℝ => Sbar x * |deriv (fun x : ℝ => fT t x) x|) (Icc G B) := by
            intro x hx
            have hx0 : 0 < x := by linarith [hGt, hx.1]
            have h1 : 1 ≤ log x := by
              linarith [show log G ≤ log x from log_le_log (by linarith [ht, hGt]) hG,
                show 1 ≤ log G from by
                  calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
                    _ ≤ log G := log_le_log (Real.exp_pos 1) hG]
            have h2 : 0 < log x := by linarith [h1]
            have hd : deriv (fun x : ℝ => fT t x) x = fTp t x :=
              hf'eq x hx
            rw [hd]
            haveI : 0 < x := hx0
            haveI : 0 < log x := h2
            haveI : 0 < u x := by nlinarith
            haveI : 0 < x * x - t * t := by nlinarith [hGt, hx.1]
            continuity
          have hIISbarf' : IntervalIntegrable
              (fun x : ℝ => Sbar x * |deriv (fun x : ℝ => fT t x) x|) volume G B :=
            hSbarf'cont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt hGB)
          have hZ2 : ∫ x in G..B, |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x| ≤
              ∫ x in G..B, Sbar x * |deriv (fun x : ℝ => fT t x) x| := by
            haveI := hIIabs
            haveI := hIISbarf'
            exact intervalIntegral.integral_mono_on (by linarith : G ≤ B) hIIabs hIISbarf' hf'pt
          have hf'bound : ∀ x ∈ Icc G B,
              Sbar x * |deriv (fun x : ℝ => fT t x) x| ≤ Sbar x * (Cf t G / x^3) := by
            intro x hx
            have hf'd : |deriv (fun x : ℝ => fT t x) x| ≤ Cf t G / x^3 := by
              have hd : deriv (fun x : ℝ => fT t x) x = fTp t x :=
                hf'eq x hx
              rw [hd]
              exact fTp_bound t x G ht hGt (by linarith [hx.1])
            have hsx : 0 ≤ Sbar x := by
              dsimp only [Sbar]
              have h1 : 1 ≤ log x := by
                linarith [show log G ≤ log x from log_le_log (by linarith [ht, hGt]) hG,
                  show 1 ≤ log G from by
                    calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
                      _ ≤ log G := log_le_log (Real.exp_pos 1) hG]
              have h2l : 0 ≤ log (log x) := by
                calc 0 = log 1 := (Real.log_one).symm
                  _ ≤ log (log x) := log_le_log (by linarith [h1]) (le_of_lt (by linarith [h1]))
              apply add_nonneg
              · apply add_nonneg
                · apply mul_nonneg
                  · norm_num
                  · linarith [h1]
                · apply mul_nonneg
                  · norm_num
                  · exact h2l
              · norm_num
            apply mul_le_mul_of_nonneg_left hf'd
            exact hsx
          have hIISc : IntervalIntegrable (fun x : ℝ => Sbar x * (Cf t G / x^3)) volume G B := by
            have hcont : ContinuousOn (fun x : ℝ => Sbar x * (Cf t G / x^3)) (Icc G B) := by
              intro x hx
              have hx0 : 0 < x := by linarith [hGt, hx.1]
              have h1 : 1 ≤ log x := by
                linarith [show log G ≤ log x from log_le_log (by linarith [ht, hGt]) hG,
                  show 1 ≤ log G from by
                    calc (1 : ℝ) = log (Real.exp 1) := (Real.log_exp 1).symm
                      _ ≤ log G := log_le_log (Real.exp_pos 1) hG]
              have h2 : 0 < log x := by linarith [h1]
              haveI : 0 < x := hx0
              haveI : 0 < log x := h2
              continuity
            exact hcont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt hGB)
          have hZ3 : ∫ x in G..B, Sbar x * |deriv (fun x : ℝ => fT t x) x| ≤
              ∫ x in G..B, Sbar x * (Cf t G / x^3) := by
            haveI := hIISbarf'
            haveI := hIISc
            exact intervalIntegral.integral_mono_on (by linarith : G ≤ B) hIISbarf' hIISc hf'bound
          have hZ4 : ∫ x in G..B, Sbar x * (Cf t G / x^3) =
              Cf t G * ∫ x in G..B, Sbar x / x^3 := by
            have hpt : ∀ x ∈ uIoo G B, (Sbar x * (Cf t G / x^3)) =
                ((Sbar x / x^3) * (Cf t G)) := by
              intro x hx
              have hxIoo : x ∈ Ioo G B := by
                rw [uIoo_of_lt hGB] at hx
                exact hx
              have hx0 : 0 < x := by linarith [hGt, hxIoo.1]
              field_simp [hx0.ne']
            rw [integral_congr_uIoo hpt]
            rw [intervalIntegral.integral_mul_const (Cf t G) (fun x : ℝ => Sbar x / x^3)]
            ring
          calc |∫ x in G..B, Δfun x|
              ≤ ∫ x in G..B, |(NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x| := hZ1
            _ ≤ ∫ x in G..B, Sbar x * |deriv (fun x : ℝ => fT t x) x| := hZ2
            _ ≤ ∫ x in G..B, Sbar x * (Cf t G / x^3) := hZ3
            _ = Cf t G * ∫ x in G..B, Sbar x / x^3 := by rw [hZ4]
            _ ≤ Cf t G * Kbar G :=
              mul_le_mul_of_nonneg_left (Kbar_le G B hG hGB) hCfN
        exact add_le_add (by rw [← mul_add]) hcZ
