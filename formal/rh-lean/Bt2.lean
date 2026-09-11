import Mathlib

/- Test file: B-3 §2 (NHat_deriv, fT_deriv), final 4.33.1 recipe:
surface have → `lift` (congrArg transport) → congr_deriv scalar bridge.
Canonical-atom discipline: every subexpression that must appear identically
on both sides of a function-equality bridge is elaborated exactly once —
via a named def (twoPiInv) or a let-bound lambda (gSub/gIn/gLog). -/

noncomputable section
namespace Bt2

open Real

/-- (2π)⁻¹ — elaborated once, used everywhere (canonical atom). -/
def twoPiInv : ℝ := ((2 : ℝ) * π)⁻¹

/-- transport: HasDerivAt SURF D x → HasDerivAt CLEAN D x given SURF = CLEAN -/
def lift {xpt : ℝ} {S C : ℝ → ℝ} (hfe : S = C) {D : ℝ}
    (h : HasDerivAt S D xpt) : HasDerivAt C D xpt :=
  Eq.mp (congrArg (fun (g : ℝ → ℝ) => HasDerivAt g D xpt) hfe) h

variable (x : ℝ)

def nHat (x : ℝ) : ℝ := log (x * twoPiInv) * twoPiInv
def NHat (x : ℝ) : ℝ := x * twoPiInv * (log (x * twoPiInv) - 1) + 7 / 8
def u (x : ℝ) : ℝ := x * x + 1 / 4
def w (t : ℝ) : ℝ := t * t + 1 / 4
def fT (t x : ℝ) : ℝ := 1 / 2 / u x + log (1 - w t / u x)
def fTp (t x : ℝ) : ℝ :=
    -x / (u x)^2 + 2 * x * w t / (u x * (x * x - t * t))

/-- N̂′(x) = n̂(x), x > 0. -/
theorem NHat_deriv (hx : 0 < x) : HasDerivAt NHat (nHat x) x := by
  have hpos2 : 0 < x * twoPiInv :=
    mul_pos hx (inv_pos.mpr (by nlinarith [Real.pi_pos]))
  -- line: z ↦ (id z)·c
  have hlineS : HasDerivAt (fun z : ℝ => (fun y : ℝ => y) z * twoPiInv)
      (1 * twoPiInv) x := (hasDerivAt_id' (x := x)).mul_const twoPiInv
  have hlineFe : (fun z : ℝ => (fun y : ℝ => y) z * twoPiInv) =
      (fun z : ℝ => z * twoPiInv) := by ext z; ring
  have hline : HasDerivAt (fun z : ℝ => z * twoPiInv) (1 * twoPiInv) x :=
    lift hlineFe hlineS
  have hlineD : HasDerivAt (fun z : ℝ => z * twoPiInv) (twoPiInv) x :=
    hline.congr_deriv (by ring)
  -- log(line)
  have hsS : HasDerivAt (log ∘ (fun z : ℝ => z * twoPiInv))
      ((x * twoPiInv)⁻¹ * twoPiInv) x :=
    HasDerivAt.comp x (hasDerivAt_log (x := x * twoPiInv) hpos2.ne') hlineD
  have hsFe : (log ∘ (fun z : ℝ => z * twoPiInv)) =
      (fun z : ℝ => log (z * twoPiInv)) := by ext z; simp
  have hs : HasDerivAt (fun z : ℝ => log (z * twoPiInv))
      ((x * twoPiInv)⁻¹ * twoPiInv) x := lift hsFe hsS
  have hsD : HasDerivAt (fun z : ℝ => log (z * twoPiInv)) (x⁻¹) x :=
    hs.congr_deriv (by
      field_simp
      exact div_self (show twoPiInv ≠ 0 from by
        dsimp only [twoPiInv]
        apply inv_ne_zero
        nlinarith [Real.pi_pos]))
  -- log(line) − 1
  have hRS : HasDerivAt ((fun z : ℝ => log (z * twoPiInv)) - (fun _ : ℝ => (1 : ℝ)))
      (x⁻¹ - 0) x := HasDerivAt.sub hsD (hasDerivAt_const x (1 : ℝ))
  have hRFe : ((fun z : ℝ => log (z * twoPiInv)) - (fun _ : ℝ => (1 : ℝ))) =
      (fun z : ℝ => log (z * twoPiInv) - 1) := by
    ext z
    simp
  have hR : HasDerivAt (fun z : ℝ => log (z * twoPiInv) - 1) (x⁻¹) x :=
    (lift hRFe hRS).congr_deriv (by ring)
  -- product
  have hm : HasDerivAt
      ((fun z : ℝ => z * twoPiInv) * (fun z : ℝ => log (z * twoPiInv) - 1))
      (twoPiInv * (log (x * twoPiInv) - 1) + (x * twoPiInv) * x⁻¹) x :=
    hlineD.mul hR
  have hmFe :
      (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1)) =
        (fun z : ℝ => z * twoPiInv * (log (z * twoPiInv) - 1)) := by ext z; ring
  have hmC : HasDerivAt
      (fun z : ℝ => z * twoPiInv * (log (z * twoPiInv) - 1))
      (twoPiInv * (log (x * twoPiInv) - 1) + (x * twoPiInv) * x⁻¹) x :=
    lift hmFe hm
  -- + 7/8
  have hFin : HasDerivAt
      ((fun z : ℝ => z * twoPiInv * (log (z * twoPiInv) - 1)) + (fun _ : ℝ => (7 / 8 : ℝ)))
      (twoPiInv * (log (x * twoPiInv) - 1) + (x * twoPiInv) * x⁻¹ + 0) x :=
    HasDerivAt.add hmC (hasDerivAt_const x (7 / 8 : ℝ))
  have hFinFe :
      (fun z : ℝ => z * twoPiInv * (log (z * twoPiInv) - 1) + (7 / 8 : ℝ)) = NHat := by
    ext z
    dsimp only [NHat]
  have hNH : HasDerivAt NHat
      (twoPiInv * (log (x * twoPiInv) - 1) + (x * twoPiInv) * x⁻¹ + 0) x :=
    lift hFinFe hFin
  exact hNH.congr_deriv (by
    dsimp only [nHat]
    field_simp
    ring)

/-- fT'_t(x) = fTp(t, x) for x > t > 0. -/
theorem fT_deriv (t x : ℝ) (ht : 0 < t) (hxt : t < x) :
    HasDerivAt (fun x => fT t x) (fTp t x) x := by
  have hu : 0 < u x := by
    dsimp only [u]
    nlinarith
  have hugw : 0 < u x - w t := by
    dsimp only [u, w]
    nlinarith
  have h1m : 0 < 1 - w t / u x := by
    have hwu : w t / u x < 1 := (div_lt_one (by positivity : 0 < u x)).mpr
      (show w t < u x from by dsimp only [u, w]; nlinarith)
    linarith
  -- let-bound canonical inner functions (single elaboration)
  let gSub : ℝ → ℝ := fun z => w t * (u z)⁻¹
  let gIn : ℝ → ℝ := fun z => 1 - gSub z
  let gLog : ℝ → ℝ := fun z => log (gIn z)
  -- sq: z ↦ z·z
  have hsqS : HasDerivAt ((fun z : ℝ => z) * (fun z : ℝ => z)) (1 * x + x * 1) x :=
    (hasDerivAt_id' (x := x)).mul (hasDerivAt_id' (x := x))
  have hsqFe : ((fun z : ℝ => z) * (fun z : ℝ => z)) = (fun z : ℝ => z * z) := by
    ext z
    simp
  have hsq : HasDerivAt (fun z : ℝ => z * z) (1 * x + x * 1) x := lift hsqFe hsqS
  have hsqD : HasDerivAt (fun z : ℝ => z * z) (2 * x) x :=
    hsq.congr_deriv (by ring)
  -- u = z² + ¼
  have huS : HasDerivAt ((fun z : ℝ => z * z) + (fun _ : ℝ => (1 / 4 : ℝ)))
      ((2 * x) + 0) x := HasDerivAt.add hsqD (hasDerivAt_const x (1 / 4 : ℝ))
  have huFe : ((fun z : ℝ => z * z) + (fun _ : ℝ => (1 / 4 : ℝ))) =
      (fun z : ℝ => u z) := by
    ext z
    simp [u]
  have huD : HasDerivAt (fun z : ℝ => u z) (2 * x) x :=
    (lift huFe huS).congr_deriv (by ring)
  -- 1/u
  have h1uS : HasDerivAt ((fun y : ℝ => y⁻¹) ∘ (fun z : ℝ => u z))
      (-((u x) ^ 2)⁻¹ * (2 * x)) x :=
    HasDerivAt.comp x (hasDerivAt_inv (x := u x) hu.ne') huD
  have h1uFe : ((fun y : ℝ => y⁻¹) ∘ (fun z : ℝ => u z)) = (fun z : ℝ => (u z)⁻¹) :=
    by ext z; simp
  have h1u : HasDerivAt (fun z : ℝ => (u z)⁻¹)
      (-((u x) ^ 2)⁻¹ * (2 * x)) x := lift h1uFe h1uS
  have h1uD : HasDerivAt (fun z : ℝ => (u z)⁻¹) (-(2 * x) / (u x)^2) x :=
    h1u.congr_deriv (by field_simp)
  -- (1/2)/u
  have hA : HasDerivAt (fun z : ℝ => (1 / 2 : ℝ) * (u z)⁻¹)
      ((1 / 2 : ℝ) * (-(2 * x) / (u x)^2)) x := (h1uD).const_mul (1 / 2 : ℝ)
  have hAFe : (fun z : ℝ => (1 / 2 : ℝ) * (u z)⁻¹) = (fun z : ℝ => 1 / 2 / u z) := by
    ext z
    field_simp [hu.ne']
  have hAD : HasDerivAt (fun z : ℝ => 1 / 2 / u z) (-x / (u x)^2) x :=
    (lift hAFe hA).congr_deriv (by field_simp)
  -- w/u  =  gSub
  have hdivS : HasDerivAt (fun z : ℝ => (w t) * (u z)⁻¹)
      ((w t) * (-(2 * x) / (u x)^2)) x := (h1uD).const_mul (w t)
  have hdivFe : (fun z : ℝ => (w t) * (u z)⁻¹) = gSub := by ext z; ring
  have hdiv : HasDerivAt gSub ((w t) * (-(2 * x) / (u x)^2)) x :=
    lift hdivFe hdivS
  have hdivD : HasDerivAt gSub (-(2 * x * w t) / (u x)^2) x :=
    hdiv.congr_deriv (by field_simp)
  -- 1 − w/u  =  gIn
  have hinnerS : HasDerivAt ((fun _ : ℝ => (1 : ℝ)) - gSub)
      (0 - (-(2 * x * w t) / (u x)^2)) x :=
    HasDerivAt.sub (hasDerivAt_const x (1 : ℝ)) hdivD
  have hinnerFe : ((fun _ : ℝ => (1 : ℝ)) - gSub) = gIn := by ext z; dsimp
  have hinner : HasDerivAt gIn (2 * x * w t / (u x)^2) x :=
    (lift hinnerFe hinnerS).congr_deriv (by ring)
  -- log(1 − w/u)  =  gLog
  have hBS : HasDerivAt (log ∘ gIn)
      (((1 - w t / u x)⁻¹) * (2 * x * w t / (u x)^2)) x :=
    HasDerivAt.comp x (hasDerivAt_log (x := 1 - w t / u x) h1m.ne') hinner
  have hBFe : (log ∘ gIn) = gLog := by ext z; dsimp
  have hB : HasDerivAt gLog (((1 - w t / u x)⁻¹) * (2 * x * w t / (u x)^2)) x :=
    lift hBFe hBS
  have hBsuf : 1 - w t / u x = (u x - w t) / u x := by
    dsimp only [u, w]
    field_simp
  have hBu : HasDerivAt gLog (2 * x * w t / (u x * (u x - w t))) x :=
    hB.congr_deriv (by
      rw [hBsuf]
      field_simp [hu.ne', ne_of_gt hugw])
  -- sum
  have hsum : HasDerivAt
      ((fun z : ℝ => 1 / 2 / u z) + gLog)
      ((-x / (u x)^2) + (2 * x * w t / (u x * (u x - w t)))) x :=
    HasDerivAt.add hAD hBu
  have hsumFe : (fun z : ℝ => 1 / 2 / u z + log (1 - w t / u z)) =
      (fun z : ℝ => fT t z) := by
    ext z
    dsimp only [fT]
  have hsub : u x - w t = x * x - t * t := by
    dsimp only [u, w]
    ring
  exact (lift hsumFe hsum).congr_deriv (by
    dsimp only [fTp]
    rw [hsub])

end Bt2
end
