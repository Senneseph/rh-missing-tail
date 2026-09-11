import Mathlib

/- Test file: B-3 §5 antiderivative derivs (P011/Q029/R229) in the
canonical-atom recipe (Bt2-verified). -/

noncomputable section
namespace Bt5

open Real

def P011 (x : ℝ) : ℝ := -(0.110 * (log x + 1 / 2)) / (2 * x * x)
def Q029 (x : ℝ) : ℝ := -(0.290 / 2) * log (log x) / (x * x)
def R229 (x : ℝ) : ℝ := -(2.290 / 2) / (x * x)

/-- Function transport (same as B3.lift). -/
theorem lift {xpt : ℝ} {S C : ℝ → ℝ} (hfe : S = C) {D : ℝ}
    (h : HasDerivAt S D xpt) : HasDerivAt C D xpt :=
  Eq.mp (congrArg (fun (g : ℝ → ℝ) => HasDerivAt g D xpt) hfe) h

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

end Bt5
end
