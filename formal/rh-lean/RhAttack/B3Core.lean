/- B3Core — B-3 shared atoms (pulled out of B3.lean, day-016 move):
    the §1 model functions + `variable (x : ℝ)` + `lift` + `NHat_deriv`.
    Needed by both B3.lean and B3Abel.lean; same lines, same names. -/
import Mathlib

open Real Set MeasureTheory intervalIntegral

noncomputable section

-- =====================================================================
-- §1 model functions (flat). Regime everywhere: e ≤ G ≤ B, 0 < t < G.
-- =====================================================================

/-- (2π)⁻¹ — elaborated once, used everywhere (canonical atom; keeps the
    log-arguments of the C¹ bridge lemmas definitionally in sync). -/
def twoPiInv : ℝ := ((2 : ℝ) * π)⁻¹

/-- n̂(x) = ln(x·(2π)⁻¹)·(2π)⁻¹: the RVM pair density (one per on-line height). -/
def nHat (x : ℝ) : ℝ := log (x * twoPiInv) * twoPiInv

/-- N̂(x) = (x·(2π)⁻¹)·(ln(x·(2π)⁻¹) − 1) + 7/8 — the RVM main term, flat. -/
def NHat (x : ℝ) : ℝ := x * twoPiInv * (log (x * twoPiInv) - 1) + 7 / 8

/-- S̄(x) = 0.110 ln x + 0.290 ln ln x + 2.290 — the Platt–Trudgian
    unconditional explicit S-bound (T ≥ e). Model copy of the citation;
    source in the file header. -/
def Sbar (x : ℝ) : ℝ := 0.110 * log x + 0.290 * log (log x) + 2.290

/-- u(γ) = γ² + ¼. -/
def u (x : ℝ) : ℝ := x * x + 1 / 4

/-- w(t) = t² + ¼. -/
def w (t : ℝ) : ℝ := t * t + 1 / 4

/-- f_t(x) := ½/u(x) + ln(1 − w(t)/u(x)) — Re of the on-line pair factor
    for one zero of height x > t (B-4 algebra; log argument positive). -/
def fT (t x : ℝ) : ℝ := 1 / 2 / u x + log (1 - w t / u x)

/-- f'_t(x) (x > t), flat: −x/u² + 2xw/(u(u−w)), u − w = x² − t². -/
def fTp (t x : ℝ) : ℝ :=
    -x / (u x)^2 + 2 * x * w t / (u x * (x * x - t * t))

/-- |f_t(x)| ≤ Bf(t,G) for x ≥ G > t (spec §2 Lemma 1). -/
def Bf (t G : ℝ) : ℝ :=
    1 / (2 * (G * G + 1 / 4)) + (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4))
    + t / (G * G + 1 / 4)

/-- |f'_t(x)| ≤ Cf(t,G)/x³ for x ≥ G > t. -/
def Cf (t G : ℝ) : ℝ := 1 + 2 * w t * (G * G) / (G * G - t * t)

/-- K̄(G) — an upper bound for ∫_G^B S̄·x⁻³ (B ≥ G ≥ e) from explicit
    primitives (see Kbar_le). -/
def Kbar (G : ℝ) : ℝ :=
    (0.110 * (log G + 1 / 2) + 0.290 * (log (log G) + 1 / 2) + 2.290) / (2 * G * G)

-- =====================================================================
-- §2 the two C¹ lemmas and the f / f' bounds
-- =====================================================================

variable (x : ℝ)

/-- Function transport over a pointwise equality: from HasDerivAt S D x
    and S = C, derive HasDerivAt C D x (4.33.1 has no HasDerivAt.congr_f;
    this congrArg bridge is used by every C¹ lemma below). -/
theorem lift {xpt : ℝ} {S C : ℝ → ℝ} (hfe : S = C) {D : ℝ}
    (h : HasDerivAt S D xpt) : HasDerivAt C D xpt :=
  Eq.mp (congrArg (fun (g : ℝ → ℝ) => HasDerivAt g D xpt) hfe) h

/-- N̂′(x) = n̂(x), x > 0. -/
theorem NHat_deriv (x : ℝ) (hx : 0 < x) : HasDerivAt NHat (nHat x) x := by
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

