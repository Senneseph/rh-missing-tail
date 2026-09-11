/-
Copyright (c) 2026 kainos-logos rh-attack (owner-directed research;
set_option maxErrors 500
AI co-developed instrument; no prize claim — see
plan/40-prize-islands/rh-attack/README.md).
-/

import Mathlib
set_option maxErrors 500

set_option linter.style.header false
set_option linter.style.longLine false

open Real Set MeasureTheory intervalIntegral

/- **B-3** — the bridge identity, Lean image (outline [B-3];
    `spec/b2-tail-bound.md`; FORMULAS §2.8).

    PROVENANCE (no recall — every reference resolves):
      plan/40-prize-islands/rh-attack/RH-PROOF-OUTLINE.md v0.8, [B-3]:
        "Bridge identity: for the actual zero set 𝒵_ℂ, ζ(s) = K(s;𝒵_ℂ)
          in the product sense (25.2.12), finite-G residual governed by
          B-2's M(G,s)."
      plan/40-prize-islands/rh-attack/spec/b2-tail-bound.md (2026-09-13):
        the B-2 bound, the Abel decomposition (verified on 7.4M real
        certified zeros to quadrature limit), and the R(t) redefinition.
        This file is the Lean image for the abstract ON-LINE model: a
        counting step N_L over a finite height list L, the smooth RVM
        comparator NHat, and the pair kernel fT.

    HONESTY LABELS (claim policy: certified artifact, no RH claim).
    - Nothing here is a statement about ζ. 25.2.12 is not in Mathlib;
      the ζ-step is the citation the outline assigns to B-3's classical
      part (same no-ζ convention as B-0). b3ResidualDecomp is the ζ-free
      core: the bridge map Ψ = e^{Tt}·∏_L F and the kernel
      K = ∏_{L∪T} F differ by EXACTLY the factor exp(Tt − Σ_T ln F) —
      the residual of the bridge is the tail-model error, nothing else.
    - b3Abel is the finite exact Abel decomposition (Σ-vs-∫ with the
      counting step); b3Bridge adds the smooth RVM comparator
      (N = NHat + S); b3BoundExplicit specializes to fT with the
      Platt–Trudgian S̄ (J. Number Theory 147 (2015) 842–851, Cor 1 —
      read 2026-09-13 from the original PDF; ledger FORMULAS §1.3):
      the FINITE form of B-2's M(G,t) (spec §5 K is ∫_G^∞; here the
      explicit finite bound Cf·Kbar(G); B → ∞ is a documented limit
      step — B-6A consumes the finite form at working B).
    - Flat-def discipline (B-5 lesson): every def feeding ring /
      nlinarith / HasDerivAt is in flat monomial form.
-/
namespace B3

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
      exact heq x hxc
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
    rw [intervalIntegral.integral_const,
        show (1 - y)⁻¹ * (1 - (1 - y)) = y * (1 - y)⁻¹ by ring]
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
      have hPn : 1 - w t / u x ≠ 0 := ne_of_gt (sub_pos.mpr hwu1)
      have hPs : 1 - (1 - w t / u x) = w t / u x := by ring
      calc (w t / u x) / (1 - w t / u x)
          = (1 - (1 - w t / u x)) / (1 - w t / u x) := by rw [← hPs]
        _ = 1 / (1 - w t / u x) - (1 - w t / u x) / (1 - w t / u x) := by
            rw [sub_div]
        _ = 1 / (1 - w t / u x) - 1 := by rw [div_self hPn]
    have hQ : (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) =
        1 / (1 - w t / (G * G + 1 / 4)) - 1 := by
      have hQn : 1 - w t / (G * G + 1 / 4) ≠ 0 := ne_of_gt (sub_pos.mpr hq1)
      have hQs : 1 - (1 - w t / (G * G + 1 / 4)) = w t / (G * G + 1 / 4) := by ring
      calc (w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4))
          = (1 - (1 - w t / (G * G + 1 / 4))) / (1 - w t / (G * G + 1 / 4)) :=
            by rw [← hQs]
        _ = 1 / (1 - w t / (G * G + 1 / 4)) -
            (1 - w t / (G * G + 1 / 4)) / (1 - w t / (G * G + 1 / 4)) := by
            rw [sub_div]
        _ = 1 / (1 - w t / (G * G + 1 / 4)) - 1 := by rw [div_self hQn]
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
        have hwn2 : 0 ≤ 2 * w t := by
          dsimp only [w]
          nlinarith
        rw [div_le_iff₀ (by nlinarith [hx0])]
        field_simp [show x^3 ≠ 0 from pow_ne_zero 3 hx0.ne']
        exact mul_le_mul_of_nonneg_left hratio hwn2
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


-- =====================================================================
-- §4 the counting step N_L, the ray integrand, and the exact finite
--      Abel decomposition (the B-3 bridge kernel, ζ-free).
-- ---------------------------------------------------------------------
-- 4.33.1 API notes (doc-verified 2026-09-13 against the pinned
-- Mathlib 4.33.1 source; no guess-iterate):
--   * List algebra is fold-based in core (lean4 tag v4.33.1):
--     List.sum_nil / List.sum_cons / List.sum_append / List.prod_append
--     all exist (Init.Data.List.Lemmas, v4.33.1 tag source).
--   * the FTC used everywhere is the hasDerivAt form (no C¹ hypothesis):
--     integral_eq_sub_of_hasDerivAt
--     (Mathlib/MeasureTheory/Integral/IntervalIntegral/FundThmCalculus.lean:1149):
--     (∀ x ∈ uIcc a b, HasDerivAt f (f' x) x) + IntervalIntegrable f'
--       ⟹ ∫ a..b f' = f b − f a.
--   * def intervalIntegral f a b := ∫ x in Ioc a b, f x − ∫ x in Ioc b a, f x
--     (Mathlib/MeasureTheory/Integral/IntervalIntegral/Basic.lean:657).
--   * value congr on ∫ a..b: integral_congr_uIoo (no integrability arg,
--     NullSingletonClass ℝ); pointwise → ae: Set.EqOn.aeEq_restrict +
--     restrict_Ioo_eq_restrict_Ioc + uIoc_of_le (Mathlib's own idiom,
--     Mathlib/.../IntervalIntegral/ContDiff.lean:34-46).
--   * HasDerivAt.contDiffOn does NOT exist in 4.33.1 — differentiability
--     is passed pointwise (HasDerivAt) + continuity of the derivative,
--     which the model functions provide in closed form.
-- =====================================================================

/-- N_L(x) = #{g ∈ L : g ≤ x} — the counting step over the finite height
    list L. -/
def NList (L : List ℝ) (x : ℝ) : ℝ :=
    (L.map (fun (g : ℝ) => if g ≤ x then (1 : ℝ) else 0)).sum

/-- The ray integrand at jump point c: (c ≤ x) ⟼ deriv f x, else 0. -/
def rayIntegrand (f : ℝ → ℝ) (c : ℝ) (x : ℝ) : ℝ := if c ≤ x then deriv f x else 0

-- ---------------------------------------------------------------------
-- §4.1 integrability plumbing (the only nontrivial measure part)
-- ---------------------------------------------------------------------

variable {f : ℝ → ℝ} {a b c : ℝ}

/-- deriv f is interval-integrable when continuous on [a,b] (a < b). -/
theorem derivIntegrableCont (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (deriv f) volume a b :=
  hf'cont.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)

/-- The ray integrand is interval-integrable (three cases on c). -/
theorem rayIntegrable (c : ℝ) (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (fun x => rayIntegrand f c x) volume a b := by
  by_cases hc' : c ≤ a
  · -- c ≤ a: ray integrand = deriv f pointwise on uIoc a b
    refine (derivIntegrableCont h'ab hf'cont).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        have hcxe : c ≤ x := by linarith [hc', hx.1]
        dsimp only [rayIntegrand]
        exact if_pos hcxe
      ) measurableSet_Ioo
  · by_cases hcb : b ≤ c
    · -- b ≤ c: ray integrand = 0 pointwise on uIoc a b
      have hzero : IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume a b :=
        continuousOn_const (c := (0 : ℝ)) (s := Icc a b)
          |>.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)
      refine hzero.congr_ae ?_
      rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
      exact Set.EqOn.aeEq_restrict
         (fun x (hx : x ∈ Ioo a b) => by
           have hnot : ¬ c ≤ x := by
             intro h1
             linarith [h1, hx.2, hcb]
           dsimp only [rayIntegrand]
           exact (if_neg hnot).symm
         ) measurableSet_Ioo
    · -- a < c < b: split uIoc a b = uIoc a c ∪ uIoc c b at c
      have hc'b : c < b := by linarith
      have hf'c : ContinuousOn (deriv f) (Icc c b) :=
        hf'cont.mono (Icc_subset_Icc (by linarith) le_rfl)
      have hset : uIoc a b = uIoc a c ∪ uIoc c b := by
        ext x
        rw [uIoc_of_le (le_of_lt h'ab),
            uIoc_of_le (le_of_lt (by linarith : a < c)),
            uIoc_of_le (le_of_lt hc'b)]
        simp only [Set.mem_Ioc, Set.mem_union]
        constructor
        · rintro ⟨ha, hxb⟩
          by_cases hc : c < x
          · exact Or.inr ⟨hc, hxb⟩
          · exact Or.inl ⟨ha, not_lt.mp hc⟩
        · rintro (Or.inl ⟨ha, hxc⟩ | Or.inr ⟨hc, hxb⟩)
          · exact ⟨ha, le_trans hxc (le_of_lt hc'b)⟩
          · exact ⟨le_trans (le_of_lt (by linarith : a < c)) hc, hxb⟩
      have hL : IntegrableOn (fun x : ℝ => rayIntegrand f c x) (uIoc a c) := by
        have hz : IntervalIntegrable (fun _ : ℝ => (0 : ℝ)) volume a c :=
          continuousOn_const (c := (0 : ℝ)) (s := Icc a c)
            |>.intervalIntegrable_of_Icc (μ := volume) (by linarith)
        have hz' : IntegrableOn (fun _ : ℝ => (0 : ℝ)) (uIoc a c) volume :=
          intervalIntegrable_iff.mp hz
        refine hz'.congr_fun_ae ?_
        rw [uIoc_of_le (by linarith), ← restrict_Ioo_eq_restrict_Ioc]
        exact Set.EqOn.aeEq_restrict
          (fun x (hx : x ∈ Ioo a c) => by
            have hnot : ¬ c ≤ x := by
              intro h1
              linarith [h1, hx.2]
            dsimp only [rayIntegrand]
            exact (if_neg hnot).symm
          ) measurableSet_Ioo
      have hR : IntegrableOn (fun x : ℝ => rayIntegrand f c x) (uIoc c b) := by
        have hII : IntervalIntegrable (fun x : ℝ => rayIntegrand f c x) volume c b :=
          (derivIntegrableCont hc'b hf'c).congr_ae (by
            rw [uIoc_of_le (le_of_lt hc'b), ← restrict_Ioo_eq_restrict_Ioc]
            exact Set.EqOn.aeEq_restrict
              (fun x (hx : x ∈ Ioo c b) => by
                have hcxe : c ≤ x := le_of_lt hx.1
                dsimp only [rayIntegrand]
                exact (if_pos hcxe).symm
              ) measurableSet_Ioo)
        exact intervalIntegrable_iff.mp hII
      rw [intervalIntegrable_iff]
      rw [hset]
      exact hL.union hR

/-- N_L · deriv f is interval-integrable (induction on L over the rays). -/
theorem NListRayIntegrable (L : List ℝ) (h'ab : a < b)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    IntervalIntegrable (fun x => NList L x * deriv f x) volume a b := by
  induction L with
  | nil =>
    refine (continuousOn_const (c := (0 : ℝ)) (s := Icc a b)
        |>.intervalIntegrable_of_Icc (μ := volume) (le_of_lt h'ab)).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        dsimp only [NList]
        simp
      ) measurableSet_Ioo
  | cons g tail ih =>
    refine (IntervalIntegrable.add ih (rayIntegrable g h'ab hf'cont)).congr_ae ?_
    rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
    exact Set.EqOn.aeEq_restrict
      (fun x (hx : x ∈ Ioo a b) => by
        by_cases hg : g ≤ x
        · dsimp only [NList, rayIntegrand]
          rw [dif_pos hg]
          ring
        · dsimp only [NList, rayIntegrand]
          rw [dif_neg hg]
          ring
      ) measurableSet_Ioo

-- ---------------------------------------------------------------------
-- §4.2 the ray value (three cases on the jump point)
-- ---------------------------------------------------------------------

/-- ∫_a^b (c ≤ x ⟼ deriv f x | 0) = f b − f a | f b − f c | 0,
    according as c ≤ a | a < c < b | b ≤ c. -/
theorem rayInt_eval (c : ℝ) (h'ab : a < b)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, rayIntegrand f c x =
      if c ≤ a then f b - f a else if c < b then f b - f c else 0 := by
  by_cases hc' : c ≤ a
  · rw [if_pos hc']
    have hCong : ∀ x ∈ uIoo a b, rayIntegrand f c x = deriv f x := by
      intro x hx
      rw [uIoo_of_lt h'ab] at hx
      have hcxe : c ≤ x := by linarith [hc', hx.1]
      dsimp only [rayIntegrand]
      exact if_pos hcxe
    rw [integral_congr_uIoo hCong]
    exact integral_eq_sub_of_hasDerivAt
      (fun x (hx : x ∈ uIcc a b) =>
        hfderiv x (by
          rw [uIcc_of_le (le_of_lt h'ab)] at hx
          exact hx))
      (derivIntegrableCont h'ab hf'cont)
  · by_cases hcb : c < b
    · rw [if_neg hc', if_pos hcb]
      have hfda : ∀ x ∈ Icc a c, HasDerivAt f (deriv f x) x := fun x hx =>
        hfderiv x ⟨hx.1, hx.2.trans (le_of_lt hcb)⟩
      have hfda' : ContinuousOn (deriv f) (Icc a c) :=
        hf'cont.mono (Icc_subset_Icc le_rfl (le_of_lt hcb))
      have hfdc : ∀ x ∈ Icc c b, HasDerivAt f (deriv f x) x := fun x hx =>
        hfderiv x ⟨le_trans (by linarith : a ≤ c) hx.1, hx.2⟩
      have hfdc' : ContinuousOn (deriv f) (Icc c b) :=
        hf'cont.mono (Icc_subset_Icc (le_of_lt (by linarith)) le_rfl)
      have hadd : ∫ x in a..b, rayIntegrand f c x =
          ∫ x in a..c, rayIntegrand f c x + ∫ x in c..b, rayIntegrand f c x :=
        (integral_add_adjacent_intervals
          (rayIntegrable c (by linarith : a < c) hfda')
          (rayIntegrable c (by linarith : c < b) hfdc')).symm
      rw [hadd]
      have hleft : ∫ x in a..c, rayIntegrand f c x = 0 := by
        have hCong : ∀ x ∈ uIoo a c, rayIntegrand f c x = 0 := by
          intro x hx
          rw [uIoo_of_lt (by linarith : a < c)] at hx
          have hnot : ¬ c ≤ x := by
            intro h1
            linarith [h1, hx.2]
          dsimp only [rayIntegrand]
          exact if_neg hnot
        rw [integral_congr_uIoo hCong]
        exact integral_zero
      have hright : ∫ x in c..b, rayIntegrand f c x = ∫ x in c..b, deriv f x := by
        have hCong : ∀ x ∈ uIoo c b, rayIntegrand f c x = deriv f x := by
          intro x hx
          rw [uIoo_of_lt (by linarith : c < b)] at hx
          have hcxe : c ≤ x := le_of_lt hx.1
          dsimp only [rayIntegrand]
          exact if_pos hcxe
        rw [integral_congr_uIoo hCong]
      rw [hleft, hright]
      exact integral_eq_sub_of_hasDerivAt
        (fun x (hx : x ∈ uIcc c b) =>
          let hx' : x ∈ Icc c b := by simpa [uIcc_of_le (le_of_lt hcb)] using hx
          hfdc x hx')
        (derivIntegrableCont (by linarith : c < b) hfdc')
    · rw [if_neg hc', if_neg hcb]
      have hCong : ∀ x ∈ uIoo a b, rayIntegrand f c x = 0 := by
        intro x hx
        rw [uIoo_of_lt h'ab] at hx
        have hnot : ¬ c ≤ x := by
          intro h1
          linarith [h1, hx.2, hcb]
        dsimp only [rayIntegrand]
        exact if_neg hnot
      rw [integral_congr_uIoo hCong]
      exact integral_zero

-- ---------------------------------------------------------------------
-- §4.3 the exact finite Abel decomposition
-- ---------------------------------------------------------------------

/-- The three-case ray value (the RHS of rayInt_eval) rewritten in
    endpoint-sum form — the algebraic bridge b3Abel uses to fold
    rayInt_eval into the Abel sum. -/
theorem rayEndFormEq (a b g : ℝ) (f : ℝ → ℝ) :
    f b * (if g ≤ b then (1 : ℝ) else 0) - f a * (if g ≤ a then (1 : ℝ) else 0)
      - (if a < g ∧ g ≤ b then f g else 0) =
      if g ≤ a then f b - f a else if g < b then f b - f g else 0 := by
  split_ifs <;> (try linarith) <;> ring

/-- The exact finite Abel identity: for the counting step N_L over the
    finite height list L,
      ∫_a^b N_L(x) f'(x) dx = f(b) N_L(b) − f(a) N_L(a) − Σ_{a<g≤b} f(g).
    -/
theorem b3Abel (L : List ℝ) (h'ab : a < b)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, NList L x * deriv f x =
      f b * NList L b - f a * NList L a - (L.map (fun (g : ℝ) => if a < g ∧ g ≤ b then f g else 0)).sum
      := by
  induction L with
  | nil =>
    have h0 : ∀ x, NList [] x * deriv f x = 0 := by
      intro x
      dsimp only [NList]
      ring
    dsimp only [NList]
    rw [integral_congr_uIoo h0, integral_zero]
    ring
  | cons g tail ih =>
    have hpt : ∀ x, NList (g :: tail) x * deriv f x =
        rayIntegrand f g x + NList tail x * deriv f x := by
      intro x
      dsimp only [NList, rayIntegrand]
      by_cases hg : g ≤ x
      · rw [dif_pos hg]
        ring
      · rw [dif_neg hg]
        ring
    rw [integral_congr_uIoo (fun x _ => hpt x)]
    rw [integral_add (rayIntegrable g h'ab hf'cont) (NListRayIntegrable tail h'ab hf'cont)]
    have hsum := ih
    have hpt2 : ∫ x in a..b, rayIntegrand f g x =
        f b * (if g ≤ b then (1 : ℝ) else 0) - f a * (if g ≤ a then (1 : ℝ) else 0)
          - (if a < g ∧ g ≤ b then f g else 0) := by
      rw [rayInt_eval g h'ab hfderiv hf'cont, ← rayEndFormEq a b g f]
    rw [hpt2, hsum]
    dsimp only [NList]
    simp
    split_ifs <;> ring

-- ---------------------------------------------------------------------
-- §4.4 the smooth comparator (RVM main term) piece — IBP on N̂
-- ---------------------------------------------------------------------

variable (t₀ : ℝ)

/-- n̂ is continuous off 0. -/
theorem nHatContinuousOn {s : Set ℝ} (hs : ∀ x ∈ s, 0 < x) : ContinuousOn nHat s := by
  intro x hx
  have hpos : 0 < x * twoPiInv :=
    mul_pos (hs x hx) (inv_pos.mpr (by nlinarith [Real.pi_pos]))
  have h1 : ContinuousAt (fun z : ℝ => z * twoPiInv) x :=
    (continuousAt_id' (x : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (x * twoPiInv) :=
    Real.continuousAt_log (ne_of_lt hpos)
  have h3 : ContinuousAt (fun w : ℝ => w * twoPiInv) (log (x * twoPiInv)) :=
    (continuousAt_id' (log (x * twoPiInv))).mul
      (continuousAt_const (twoPiInv : ℝ))
  exact (h3.comp (h2.comp h1)).continuousWithinAt (s := s)

/-- N̂ is continuous off 0. -/
theorem NHatContinuousOn {s : Set ℝ} (hs : ∀ x ∈ s, 0 < x) : ContinuousOn NHat s := by
  intro x hx
  have hpos : 0 < x * twoPiInv :=
    mul_pos (hs x hx) (inv_pos.mpr (by nlinarith [Real.pi_pos]))
  have h1 : ContinuousAt (fun z : ℝ => z * twoPiInv) x :=
    (continuousAt_id' (x : ℝ)).mul continuousAt_const
  have h2 : ContinuousAt (fun w : ℝ => log w) (x * twoPiInv) :=
    Real.continuousAt_log (ne_of_lt hpos)
  have hmid : ContinuousAt (fun z : ℝ => log (z * twoPiInv)) x := h2.comp h1
  have h6 : ContinuousAt (fun z : ℝ => log (z * twoPiInv) - 1) x :=
    hmid.sub continuousAt_const
  have h7 : ContinuousAt (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1)) x :=
    h1.mul h6
  have hC7 : ContinuousAt (fun _ : ℝ => (7 : ℝ) / 8) x := continuousAt_const
  have h8 : ContinuousAt
      (fun z : ℝ => (z * twoPiInv) * (log (z * twoPiInv) - 1) + 7 / 8) x :=
    h7.add hC7
  exact h8.continuousWithinAt (s := s)

/-- The IBP bridge for the smooth comparator:
    ∫_a^b n̂ f = f(b) N̂(b) − f(a) N̂(a) − ∫_a^b N̂ f'. -/
theorem nHatIBP {f : ℝ → ℝ} {a b : ℝ} (h'ab : a < b) (h'a : 0 < a)
    (hfderiv : ∀ x ∈ Icc a b, HasDerivAt f (deriv f x) x)
    (hf'cont : ContinuousOn (deriv f) (Icc a b)) :
    ∫ x in a..b, nHat x * f x =
      NHat b * f b - NHat a * f a - ∫ x in a..b, NHat x * deriv f x := by
  set H := fun x : ℝ => NHat x * f x with hH
  have hposx (x : ℝ) (hx : x ∈ Icc a b) : 0 < x := by linarith [h'a, hx.1]
  have hHderiv : ∀ x ∈ Icc a b, HasDerivAt H (nHat x * f x + NHat x * deriv f x) x := by
    intro x hx
    have hNH : HasDerivAt NHat (nHat x) x := NHat_deriv x (lt_of_lt_of_le h'a hx.1)
    have hf := hfderiv x hx
    rw [hH]
    exact hNH.mul hf
  have hHcont : ContinuousOn H (Icc a b) :=
    (NHatContinuousOn hposx).mul (HasDerivAt.continuousOn hfderiv)
  have hII_nHatf : IntervalIntegrable (fun x : ℝ => nHat x * f x) volume a b :=
    ((nHatContinuousOn hposx).mul (HasDerivAt.continuousOn hfderiv) :
      ContinuousOn (fun x : ℝ => nHat x * f x) (Icc a b)).intervalIntegrable_of_Icc
      (μ := volume) (le_of_lt h'ab)
  have hII_NHatf' : IntervalIntegrable (fun x : ℝ => NHat x * deriv f x) volume a b :=
    ((NHatContinuousOn hposx).mul hf'cont :
      ContinuousOn (fun x : ℝ => NHat x * deriv f x) (Icc a b)).intervalIntegrable_of_Icc
      (μ := volume) (le_of_lt h'ab)
  have hII_dH : IntervalIntegrable (deriv H) volume a b := by
    have hae : (deriv H) =ᵐ[volume.restrict (uIoc a b)]
        (fun x : ℝ => nHat x * f x + NHat x * deriv f x) := by
      rw [uIoc_of_le (le_of_lt h'ab), ← restrict_Ioo_eq_restrict_Ioc]
      exact Set.EqOn.aeEq_restrict
        (fun x (hx : x ∈ Ioo a b) =>
          HasDerivAt.deriv (hHderiv x ⟨le_of_lt hx.1, le_of_lt hx.2⟩)
        ) measurableSet_Ioo
    exact (hII_nHatf.add hII_NHatf').congr_ae hae.symm
  calc ∫ x in a..b, nHat x * f x
      = ∫ x in a..b, (nHat x * f x + NHat x * deriv f x) - ∫ x in a..b, NHat x * deriv f x :=
        eq_sub_of_add_eq (intervalIntegral.integral_add hII_nHatf hII_NHatf').symm
    _ = ∫ x in a..b, deriv H x - ∫ x in a..b, NHat x * deriv f x := by
      have hCong2 : ∀ x ∈ uIoo a b, (nHat x * f x + NHat x * deriv f x : ℝ) = deriv H x := by
        intro x hx
        rw [uIoo_of_lt h'ab] at hx
        exact (HasDerivAt.deriv (hHderiv x ⟨le_of_lt hx.1, le_of_lt hx.2⟩)).symm
      rw [integral_congr_uIoo hCong2]
      rfl
    _ = NHat b * f b - NHat a * f a - ∫ x in a..b, NHat x * deriv f x := by
      have hHftc : ∫ x in a..b, deriv H x = NHat b * f b - NHat a * f a :=
        integral_eq_sub_of_hasDerivAt
          (fun x (hx : x ∈ uIcc a b) => by
            rw [uIcc_of_le (le_of_lt h'ab)] at hx
            let h0 := hHderiv x hx
            exact h0.congr_deriv (HasDerivAt.deriv h0 |>.symm))
          hII_dH
      rw [hHftc]

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
      (P011 B - P011 G) + (Q029 B - Q029 G) + ∫ x in G..B, 0.290 / (2 * x^3 * log x) +
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
      = (P011 B - P011 G) + (Q029 B - Q029 G) + ∫ x in G..B, 0.290 / (2 * x^3 * log x) +
          (R229 B - R229 G) := by
        rw [vS]
      _ ≤ (0 - P011 G) + (0 - Q029 G) + ∫ x in G..B, 0.290 / (2 * x^3 * log x) +
          (0 - R229 G) := by
        nlinarith [hPn, hQn, hRn]
      _ = -P011 G - Q029 G + ∫ x in G..B, 0.290 / (2 * x^3 * log x) - R229 G := by
        ring
      _ ≤ -P011 G - Q029 G + ∫ x in G..B, 0.290 / (2 * x^3) - R229 G := by
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
      NHat B * fT t B - NHat G * fT t G - ∫ x in G..B, NHat x * deriv (fun x : ℝ => fT t x) x :=
    nHatIBP (by linarith : G < B) (by linarith : 0 < G) hfderiv hf'cont
  set Δfun := fun x : ℝ => (NList L x - NHat x) * deriv (fun x : ℝ => fT t x) x with hΔ
  have hΔeq : ∫ x in G..B, Δfun x =
      ∫ x in G..B, NList L x * deriv (fun x : ℝ => fT t x) x -
        ∫ x in G..B, NHat x * deriv (fun x : ℝ => fT t x) x := by
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
-- =====================================================================
-- §6 the residual split (zeta-free core of the B-3 bridge)
-- =====================================================================

/-- Residual split (zeta-free): e^{Tt} · ∏_{g∈L} F = (∏_{g∈L∪T} F) · e^{Tt − Σ_T ln F}
    for positive F on L ++ T. Composed with F-0.5 + B-1 + B-2 this is B-6A's
    Route A engine: an off-line pair at t0 forces the LHS ≥ f(δ, t0) at its
    own height. (4.33.1 core API, probe-verified: List.map_cons /
    List.prod_cons / List.sum_cons / List.prod_append /
    List.mem_append_right / List.Mem.tail; (L.map F).prod and
    (L.map f).sum forms — List.sum/List.prod are element-operators.) -/
theorem b3ResidualDecomp (L T : List ℝ) (Tt : ℝ) (F : ℝ → ℝ)
    (hpos : ∀ g ∈ L ++ T, 0 < F g) :
    Real.exp Tt * (L.map (fun (g : ℝ) => F g)).prod =
      ((L ++ T).map (fun (g : ℝ) => F g)).prod *
      Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
  have hTexp (T2 : List ℝ) (hTpos : ∀ g ∈ T2, 0 < F g) :
      (T2.map (fun (g : ℝ) => F g)).prod =
        Real.exp ((T2.map (fun (g : ℝ) => Real.log (F g))).sum) := by
    induction T2 with
    | nil => simp
    | cons g T2 ih =>
      have ih' : (T2.map (fun (g : ℝ) => F g)).prod =
          Real.exp ((T2.map (fun (g : ℝ) => Real.log (F g))).sum) :=
        ih (fun g2 (hg2 : g2 ∈ T2) => hTpos g2 (List.Mem.tail g hg2))
      have hposg : 0 < F g := hTpos g (List.Mem.head T2)
      simp only [List.map_cons, List.prod_cons, List.sum_cons]
      rw [Real.exp_add (Real.log (F g))
        ((T2.map (fun (g : ℝ) => Real.log (F g))).sum),
        Real.exp_log hposg, ih']
  have hTmain : (T.map (fun (g : ℝ) => F g)).prod =
      Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) :=
    hTexp T (fun g (hg : g ∈ T) => hpos g (List.mem_append_right L hg))
  calc Real.exp Tt * (L.map (fun (g : ℝ) => F g)).prod
      = (L.map (fun (g : ℝ) => F g)).prod * Real.exp Tt := by ring
    _ = (L.map (fun (g : ℝ) => F g)).prod *
        (Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) *
          Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
        calc (L.map (fun (g : ℝ) => F g)).prod * Real.exp Tt
            = (L.map (fun (g : ℝ) => F g)).prod * Real.exp
                ((T.map (fun (g : ℝ) => Real.log (F g))).sum +
                  (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
                rw [show (T.map (fun (g : ℝ) => Real.log (F g))).sum +
                      (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) = Tt by ring]
              _ = (L.map (fun (g : ℝ) => F g)).prod *
                  (Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) *
                    Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
                rw [Real.exp_add ((T.map (fun (g : ℝ) => Real.log (F g))).sum)
                  (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)]
    _ = (L.map (fun (g : ℝ) => F g)).prod * (T.map (fun (g : ℝ) => F g)).prod *
        Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
        rw [← hTmain]
        ring
    _ = ((L ++ T).map (fun (g : ℝ) => F g)).prod *
        Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
        rw [← List.prod_append, ← List.map_append]
        ring
end
end B3
-- =====================================================================
-- §7 float64 cross-check (pure Float; no Mathlib ℝ — the A/B gate)
-- =====================================================================
-- Mirrors the B-3 model in Float64 and runs two checks at
-- t = 2.5, G = 6, B = 40 with the toy off-line list
-- L = [7.3, 12.1, 19.4, 27.8, 33.0]:
--   (1) the EXACT finite Abel identity (b3Abel) at quadrature limit
--       (8-node Gauss–Legendre, segments split at each zero height);
--   (2) the explicit bound (b3BoundExplicit / Kbar_le):
--       |Σ_L fT − ∫ nHat·fT| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G).
-- A/B gate: this must agree with the Lean theorems' content (same
-- formulas, same regime), byte-for-byte in logic, to machine precision
-- in numerics. P-0.9: a PASS line with a flagged anomaly is not a PASS.
namespace B3Float

def piF : Float := 3.141592653589793

def myAbs (x : Float) : Float := if x < 0 then -x else x
def myMax (a b : Float) : Float := if a < b then b else a

def F (t x : Float) : Float :=
    (1 : Float) / (2 * (x * x + (1 : Float) / 4)) +
      Float.log (1 - (t * t + (1 : Float) / 4) / (x * x + (1 : Float) / 4))

def Fp (t x : Float) : Float :=
    -x / (x * x + (1 : Float) / 4) ^ 2 +
      2 * x * (t * t + (1 : Float) / 4) /
        ((x * x + (1 : Float) / 4) * (x * x - t * t))

def nF (x : Float) : Float :=
    Float.log (x / (2 * piF)) / (2 * piF)

def NHatF (x : Float) : Float :=
    x / (2 * piF) * (Float.log (x / (2 * piF)) - 1) + (7 : Float) / 8

def sBarF (x : Float) : Float :=
    (0.110 : Float) * Float.log x + (0.290 : Float) * Float.log (Float.log x) +
      (2.290 : Float)

def BfF (t G : Float) : Float :=
    (1 : Float) / (2 * (G * G + (1 : Float) / 4)) +
      (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4) /
        (1 - (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4)) +
      t / (G * G + (1 : Float) / 4)

def CfF (t G : Float) : Float :=
    1 + 2 * (t * t + (1 : Float) / 4) * (G * G) / (G * G - t * t)

def KbarF (G : Float) : Float :=
    ((0.110 : Float) * (Float.log G + (1 : Float) / 2) +
        (0.290 : Float) * (Float.log (Float.log G) + (1 : Float) / 2) + (2.290 : Float)) /
      (2 * G * G)

/-- N_L(x) = #{g ∈ L : g ≤ x} (foldl counter — List-fold discipline). -/
def nListF (L : List Float) (x : Float) : Float :=
    L.foldl (fun (a : Float) g => a + (if g <= x then (1 : Float) else 0)) 0

-- 8-node Gauss–Legendre on [-1, 1] (standard table; exact for degree ≤ 15)
-- Table COMPUTED 2026-09-14 with mpmath-50dps (roots of P8,
-- w_i = 2/((1-x_i^2) P8'(x_i)^2)), verified against the moment
-- identites to 50 digits; the runtime glMomErr self-check (< 1e-12)
-- re-verifies it in Float64.  "constants computed, never recalled".
def gln : Array Float := #[
    -0.9602898564975363, -0.7966664774136267, -0.525532409916329, -0.1834346424956498,
     0.1834346424956498,  0.525532409916329,  0.7966664774136267,  0.9602898564975363]

def glw : Array Float := #[
     0.10122853629037626, 0.22238103445337448, 0.31370664587788727, 0.362683783378362,
     0.362683783378362,   0.31370664587788727, 0.22238103445337448, 0.10122853629037626]

/-- One 8-node Gauss–Legendre segment [a, b], composed over 8 sub-segments
    (composite order 16 for smooth integrands; no nodes beyond the table). -/
def glInt (a b : Float) (f : Float → Float) : Float :=
    let h := (b - a) / 8
    let seg (a0 : Float) : Float :=
      let m2 := h / 2
      let c  := a0 + h / 2
      (gln.zip glw).foldl (fun (s : Float) (x : Float × Float) =>
        s + m2 * x.2 * f (m2 * x.1 + c)) 0
    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0] |>.foldl (fun (acc : Float) k =>
      acc + seg (a + h * (k - 1))) 0

/-- Moment self-check of the table: |Σw − 2| + |Σwξ² − 2/3| + |Σwξ⁶ − 2/7|
    (odd moments vanish by symmetry; must be < 1e-12 in Float64). -/
def glMomErr : Float :=
    let (m0, m2, m6) := gln.zip glw |>.foldl (fun (acc : Float × Float × Float) (x : Float × Float) =>
      let (a, b, c) := acc
      let x2 := x.1 * x.1
      (a + x.2, b + x.2 * x2, c + x.2 * x2 * x2 * x2)) (0, 0, 0)
    myAbs (m0 - 2) + myAbs (m2 - (2 : Float) / 3) + myAbs (m6 - (2 : Float) / 7)

/-- Segment the interval at every zero height strictly inside [a, b]. -/
def splitIntR (a b : Float) (rest : List Float) (f : Float → Float) : Float :=
    match rest with
    | [] => glInt a b f
    | g :: gs =>
      if g <= a ∨ g >= b then
        splitIntR a b gs f
      else
        glInt a g f + splitIntR g b gs f

def splitInt (a b : Float) (L : List Float) (f : Float → Float) : Float :=
    splitIntR a b (L.filter (fun g => g > a && g < b)) f

/-! The A/B run (B4Float style): prints both checks, returns
    (abelRelativeError, boundMargin) — margin strictly positive iff (2) holds. -/
def run : IO (Float × Float) := do
    let tF : Float := 2.5
    let G  : Float := 6
    let B  : Float := 40
    let L  : List Float := [7.3, 12.1, 19.4, 27.8, 33.0]
    let f  : Float → Float := F tF
    -- (1) exact finite Abel identity:
    --     ∫_G^B N_L f' = f(B)·N_L(B) − f(G)·N_L(G) − Σ_{g: G<g≤B} f(g)
    let LsumF := L.foldl (fun (a : Float) g =>
      a + (if G < g && g <= B then f g else 0)) 0
    let Iabel := splitInt G B L (fun x => nListF L x * Fp tF x)
    let NRHS  := f B * nListF L B - f G * nListF L G - LsumF
    let abelRel := myAbs (Iabel - NRHS) / myMax (myAbs Iabel) (myAbs NRHS)
    IO.println "  check 1 — exact finite Abel identity (int N_L f' vs fB·NB − fG·NG − Sum f):"
    IO.println s!"    rel-err·1e12 = {abelRel * 1e12}"
    -- (2) explicit bound: |Sum f − int nF·f| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G)
    let Ikernel := splitInt G B L (fun x => nF x * f x)
    let lhs2 := myAbs (LsumF - Ikernel)
    let rhs2 := BfF tF G * (sBarF B + sBarF G) + CfF tF G * KbarF G
    let margin := (rhs2 - lhs2) / rhs2
    IO.println "  check 2 — explicit bound |Sum f − int nF·f| ≤ Bf·(SbarB + SbarG) + Cf·Kbar(G):"
    IO.println s!"    margin·1e3 = {margin * 1e3}     (bound LHS·1e3={lhs2 * 1e3}, RHS·1e3={rhs2 * 1e3})"
    IO.println s!"    gl-mom-err·1e12 = {glMomErr * 1e12}     (table self-check, must be < 1e9)"
    if abelRel < 1e-9 && margin > 0 && glMomErr < 1e-12 then
      IO.println "B-3 CROSS-CHECK PASS"
    else
      IO.println "B-3 CROSS-CHECK FAIL"
    pure (abelRel, margin)

end B3Float
