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


-- -----------------------------------------------------------------
-- §2/§3 moved in from B3.lean (day-016 move): f′ = fT_deriv +
-- the scalar bounds negLog1mY_le / fT_bound / fTp_bound — shared
-- with B3Sbar.lean's master bound; same lines, same names.
----------------------------------------------------------------------

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

-- =====================================================================
-- §3 scalar inequalities for the f / f' bound assembly
-- =====================================================================

/-- −ln(1−y) ≤ y/(1−y) for 0 < y < 1 (−ln(1−y) = ∫_{1−y}^1 dx/x
    and 1/z ≤ 1/(1−y) on [1−y, 1]). -/
theorem negLog1mY_le (y : ℝ) (hy0 : 0 < y) (hy1 : y < 1) :
    -log (1 - y) ≤ y / (1 - y) := by
  have hz : 0 < 1 - y := by linarith
  have hC1 : ContDiffOn ℝ 1 log (Icc (1 - y) 1) :=
    (contDiffOn_log (n := (1 : ℕ∞))).mono (fun z hz' =>
      ne_of_gt (lt_of_lt_of_le hz hz'.1))
  have h1 : ∫ z in (1 - y)..1, (1 / z) = log 1 - log (1 - y) := by
    have heq : EqOn (fun z : ℝ => (1 / z)) (deriv log) (uIcc (1 - y) 1) := by
      intro z hz'
      rw [deriv_log z, inv_eq_one_div z]
    have heq' : ∀ x ∈ uIoo (1 - y) 1, (1 / x) = deriv log x := by
      intro x hx
      rw [uIoo_of_lt (by linarith : (1 - y) < 1)] at hx
      have hxc : x ∈ uIcc (1 - y) 1 := by
        rw [uIcc_of_le (by linarith : (1 : ℝ) - y ≤ 1)]
        exact ⟨le_of_lt hx.1, le_of_lt hx.2⟩
      exact heq hxc
    rw [integral_congr_uIoo heq']
    exact intervalIntegral.integral_deriv_of_contDiffOn_Icc hC1
      (by linarith : (1 - y) ≤ 1)
  have hstep : -log (1 - y) = ∫ z in (1 - y)..1, (1 / z) := by
    rw [h1, Real.log_one, zero_sub]
  rw [hstep]
  have hbound : (∫ z in (1 - y)..1, (1 / z)) ≤ ∫ z in (1 - y)..1, (1 / (1 - y)) := by
    have hI1 : IntervalIntegrable (fun z : ℝ => 1 / z) volume (1 - y) 1 := by
      have hcont1 : ContinuousOn (fun z : ℝ => 1 / z) (Icc (1 - y) 1) := by
        intro z hz'
        have hzpos : 0 < z := lt_of_lt_of_le hz hz'.1
        have hc1 : ContinuousAt (fun _ : ℝ => (1 : ℝ)) z := continuousAt_const
        have hid : ContinuousAt (fun w : ℝ => w) z := continuousAt_id' (z : ℝ)
        exact (hc1.div hid (ne_of_gt hzpos)).continuousWithinAt (s := Icc (1 - y) 1)
      exact hcont1.intervalIntegrable_of_Icc (μ := volume) (by linarith : 1 - y ≤ 1)
    have hI2 : IntervalIntegrable (fun z : ℝ => (1 / (1 - y))) volume (1 - y) 1 :=
      continuousOn_const (c := (1 / (1 - y))) (s := Icc (1 - y) 1)
        |>.intervalIntegrable_of_Icc (μ := volume) (by linarith : 1 - y ≤ 1)
    exact integral_mono_on
      (hab := by linarith)
      (hf := hI1) (hg := hI2)
      (h := fun z (hz' : z ∈ Icc (1 - y) 1) =>
        (one_div_le_one_div (show 0 < z from by linarith [show 1 - y ≤ z from hz'.1, hz])
            hz).mpr hz'.1)
  have htarget : ∫ z in (1 - y)..1, (1 / (1 - y)) = y / (1 - y) := by
    rw [intervalIntegral.integral_const, smul_eq_mul]
    ring
  linarith [hbound, htarget]

/-- |f_t(x)| ≤ Bf(t,G) for G > t, x ≥ G (spec §2 Lemma 1). -/
theorem fT_bound (t x G : ℝ) (ht : 0 < t) (hGt : t < G) (hxG : G ≤ x) :
    |fT t x| ≤ Bf t G := by
  have hx0 : 0 < x := by linarith
  have hu : 0 < u x := by dsimp only [u]; nlinarith
  have hv : 0 < G * G + 1 / 4 := by nlinarith
  have hq1 : w t / (G * G + 1 / 4) < 1 := by
    dsimp only [w]
    rw [div_lt_iff₀ hv]
    nlinarith [hGt]
  have hwu0 : 0 < w t / u x := by
    dsimp only [u, w]
    positivity
  have hwu1 : w t / u x < 1 := by
    rw [div_lt_iff₀ hu]
    dsimp only [u, w]
    nlinarith [hGt, hxG, show 0 ≤ G from by linarith [hGt]]
  have hlogneg : log (1 - w t / u x) ≤ 0 := by
    linarith [log_le_sub_one_of_pos (sub_pos.mpr hwu1)]
  have hlogabs : -log (1 - w t / u x) ≤ (w t / u x) / (1 - w t / u x) :=
    negLog1mY_le (w t / u x) hwu0 hwu1
  have hmono : (w t / u x) / (1 - w t / u x) ≤
      (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) := by
    have hAB : w t / u x ≤ w t / (G * G + 1 / 4) := by
      rw [div_le_div_iff₀ hu hv]
      have hg2u : G * G + 1 / 4 ≤ u x := by
        dsimp only [u]
        nlinarith [hxG, show 0 ≤ G from by linarith [hGt]]
      have hwN : 0 ≤ w t := by dsimp only [w]; nlinarith
      exact mul_le_mul_of_nonneg_left hg2u hwN
    have hP : (w t / u x) / (1 - w t / u x) = 1 / (1 - w t / u x) - 1 := by
      -- (e)/(1-e) = 1/(1-e) - 1 with e := w t / u x; denominator isolated via `set d`
      have hPn : 1 - w t / u x ≠ 0 := ne_of_gt (sub_pos.mpr hwu1)
      set d := 1 - w t / u x with hd
      have heqw : w t / u x = 1 - d := by ring
      calc (w t / u x) / (1 - w t / u x)
          = (1 - d) / d := by rw [hd, ← heqw]
        _ = 1 / d - d / d := by rw [sub_div (1 : ℝ) d d]
        _ = 1 / d - 1 := by rw [div_self hPn]
        _ = 1 / (1 - w t / u x) - 1 := by rw [hd]
    have hQ : (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) =
        1 / (1 - w t / (G * G + 1 / 4)) - 1 := by
      -- same shape as hP with denominator 1 - w t / (G*G+1/4)
      have hQn : 1 - w t / (G * G + 1 / 4) ≠ 0 := ne_of_gt (sub_pos.mpr hq1)
      set d := 1 - w t / (G * G + 1 / 4) with hd
      have heqw : w t / (G * G + 1 / 4) = 1 - d := by ring
      calc (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4))
          = (1 - d) / d := by rw [hd, ← heqw]
        _ = 1 / d - d / d := by rw [sub_div (1 : ℝ) d d]
        _ = 1 / d - 1 := by rw [div_self hQn]
        _ = 1 / (1 - w t / (G * G + 1 / 4)) - 1 := by rw [hd]
    rw [hP, hQ]
    have h5 : 1 / (1 - w t / u x) ≤ 1 / (1 - w t / (G * G + 1 / 4)) :=
      (one_div_le_one_div (sub_pos.mpr hwu1) (sub_pos.mpr hq1)).mpr (by nlinarith [hAB])
    linarith [h5]
  have hterm1 : 1 / 2 / u x ≤ 1 / (2 * (G * G + 1 / 4)) := by
    have hU : 2 * u x ≥ 2 * (G * G + 1 / 4) := by
      dsimp only [u]
      nlinarith [hxG]
    field_simp
    nlinarith [hU]
  calc
    |fT t x| = |(1 / 2 / u x) + log (1 - w t / u x)| := rfl
    _ ≤ |1 / 2 / u x| + |log (1 - w t / u x)| := by
      set A := 1 / 2 / u x with hA
      set L := log (1 - w t / u x) with hL
      have htri : |A + L| ≤ |A| + |L| := by
        simpa using abs_sub A (-L)
      simpa [hA, hL] using htri
    _ = 1 / 2 / u x + (-(log (1 - w t / u x))) := by
      rw [abs_of_nonneg (by
        apply div_nonneg
        · norm_num
        · exact le_of_lt hu), abs_of_nonpos (by nlinarith [hlogneg])]
    _ ≤ 1 / 2 / u x + (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) := by
      linarith [hlogabs, hmono]
    _ ≤ 1 / (2 * (G * G + 1 / 4)) + (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) := by
      linarith [hterm1]
    _ ≤ 1 / (2 * (G * G + 1 / 4)) + (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4))
        + t / (G * G + 1 / 4) := by
      have htpos : 0 ≤ t / (G * G + 1 / 4) := by positivity
      nlinarith [htpos]
    _ = Bf t G := rfl

/-- |f'_t(x)| ≤ Cf(t,G)/x³ for G > t, x ≥ G. -/
theorem fTp_bound (t x G : ℝ) (ht : 0 < t) (hGt : t < G) (hxG : G ≤ x) :
    |fTp t x| ≤ Cf t G / x^3 := by
  have hx0 : 0 < x := by linarith
  have hG2t : 0 < G * G - t * t := by nlinarith [hGt]
  have hu : 0 < u x := by dsimp only [u]; nlinarith
  have hx2 : 0 < x * x - t * t := by nlinarith [hGt, hxG]
  have hterm1 : |(-x / (u x)^2)| ≤ 1 / x^3 := by
    rw [show (-x : ℝ) / (u x)^2 = -(x / (u x)^2) by ring, abs_neg]
    rw [abs_of_nonneg (by
      apply div_nonneg
      · exact le_of_lt hx0
      · nlinarith [hu])]
    have h : x / (u x)^2 ≤ 1 / x^3 := by
      rw [div_le_div_iff₀ (by positivity : 0 < (u x)^2) (by positivity : 0 < x^3)]
      rw [show u x = x * x + 1 / 4 from by dsimp only [u]]
      ring_nf
      nlinarith
    linarith [h]
  have hterm2 : |(2 * x * w t / (u x * (x * x - t * t)))| ≤
      (2 * w t * (G * G) / (G * G - t * t)) / x^3 := by
    rw [abs_of_nonneg (by
      apply div_nonneg
      · have hwn : 0 < w t := by dsimp only [w]; nlinarith
        nlinarith [hwn, hx0]
      · nlinarith [hu, hx2])]
    have hdenom : 2 * x * w t / (u x * (x * x - t * t)) ≤
        2 * w t / (x * (x * x - t * t)) := by
      have hu2 : x * x ≤ u x := by
        dsimp only [u]
        nlinarith
      have hnon : 0 ≤ 2 * w t * (x * x - t * t) := by
        dsimp only [w]
        nlinarith
      rw [div_le_div_iff₀ (by nlinarith [hu, hx2]) (by nlinarith [hx0])]
      nlinarith [hu2, hnon]
    have hratio : x * x / (x * x - t * t) ≤ G * G / (G * G - t * t) := by
      rw [div_le_div_iff₀ (by nlinarith [hx2]) (by nlinarith [hG2t])]
      have hdiff : x * x * (G * G - t * t) - G * G * (x * x - t * t) =
          t * t * (G * G - x * x) := by ring
      have hgoal : x * x * (G * G - t * t) ≤ G * G * (x * x - t * t) := by
        have hg2 : G * G ≤ x * x := by nlinarith [hxG, show 0 ≤ G from by linarith [hGt]]
        have hll : G * G - x * x ≤ 0 := by nlinarith [hg2]
        have htt : 0 ≤ t * t := by nlinarith
        have heq : x * x * (G * G - t * t) - G * G * (x * x - t * t) =
            t * t * (G * G - x * x) := by ring
        rw [← sub_nonpos, heq]
        exact mul_nonpos_of_nonneg_of_nonpos htt hll
      exact hgoal
    have hsplit : 2 * w t / (x * (x * x - t * t)) =
        (2 * w t * (x * x / (x * x - t * t))) / x^3 := by
      field_simp [hx0.ne', hx2.ne']
    calc
      2 * x * w t / (u x * (x * x - t * t)) ≤ 2 * w t / (x * (x * x - t * t)) := hdenom
      _ = (2 * w t * (x * x / (x * x - t * t))) / x^3 := hsplit
      _ ≤ (2 * w t * (G * G / (G * G - t * t))) / x^3 := by
        -- same positive denominator on both sides: monotone (· / x^3) carries
        -- the numerator inequality (monotone_div_right_of_nonneg,
        -- Algebra/Order/Field/Basic.lean:168 in pinned mathlib)
        have hwn2 : 0 ≤ 2 * w t := by
          dsimp only [w]
          nlinarith
        exact monotone_div_right_of_nonneg (pow_nonneg hx0.le 3)
          (mul_le_mul_of_nonneg_left hratio hwn2)
      _ = (2 * w t * (G * G) / (G * G - t * t)) / x^3 := by ring_nf
  calc
    |fTp t x| = |(-x / (u x)^2) + (2 * x * w t / (u x * (x * x - t * t)))| := rfl
    _ ≤ |(-x / (u x)^2)| + |(2 * x * w t / (u x * (x * x - t * t)))| := by
      set A := -x / (u x)^2 with hA
      set B := 2 * x * w t / (u x * (x * x - t * t)) with hB
      have htri : |A + B| ≤ |A| + |B| := by
        simpa using abs_sub A (-B)
      simpa [hA, hB] using htri
    _ ≤ 1 / x^3 + (2 * w t * (G * G) / (G * G - t * t)) / x^3 := by
      gcongr
      <;> (try exact hterm1)
      <;> (try exact hterm2)
    _ = (1 + 2 * w t * (G * G) / (G * G - t * t)) / x^3 := by ring_nf
    _ = Cf t G / x^3 := rfl


-- RhAttack/B3Sbar.lean (day-016 move; imported above, names unchanged).

