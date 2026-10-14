/-
Rh-missing-tail, the C-LINE -- the MAIN-TERM BRIDGE:  the engine's
Stirling main term  lm(s)  (DLMF 25.2.12 form)  is EXACTLY  the
xi-convention main factor  |mainFac s|  plus the named constant
C_bridge/2  (t-independent),  at every height  s = 1/2 + it.

  PART A (pure,  data-free) :  mainFac / xiz  definitions,
    mainFac_reduced,  zeta_eq_main_xi,  xiz_zero_tendsto
    (xi(0) = 1/2  as the removable value),  log_abs_decomp,
    engine_lm  (faithful mirror of  scripts/rh/s3_ledger_recon_
    margin_sweep.py  logmain25212),  and the headline exact
    identity

        Re(engine_lm (1/2 + i t))  =  log |mainFac (1/2 + i t)|
                                     + C_bridge / 2 - log 2     (t > 0)

    with the c-theorem form

        =  log |mainFac| + log (1/2) - Ex_total + EPS,
        EPS  :=  C_bridge / 2 + Ex_total.

   This is the Lean-certifiable half of the numerically verified
   main-term identity  (s6/s7:  2 heights  1e-6;  s8:  all 505
   ledger rows  |measured residual| <= 2.073e-6  --  the f64
   engine agrees with this exact formula to its own precision).
  PART C (data,  E7a-style gate) :  Float re-evaluations of
    C_bridge  and  EPS  against the dps-50 oracle  (transcription
    + arithmetic check;  the reals of this mathlib pin are not
    #eval-able,  cf.  E7a header).

PROVENANCE:
  Engine formula : scripts/rh/s3_ledger_recon_margin_sweep.py
                   (logmain25212;  day037_h1_3e10.py  lm field)
  Verified       : tmp/s6_c_closedform.jsonl,  tmp/s7_c_theorem.jsonl,
                   tmp/s8_m_true_sample.jsonl  (field  eps)
  c theorem      : DISCOVERY_LOG 2026-10-14 entries;  forensics 3.12
  xi(0) = 1/2   : xiz_zero_tendsto  (LEAN-PROVEN here);  the
                   dps-30 check  0.499999999999988  is recorded s7

Lean 4.33.1 + Mathlib (pinned rev v4.33.1).
No sorry in this file.
-/
import Mathlib

set_option linter.style.header false

namespace MainBridge
open BigOperators Topology Filter Set

/-- pi^{s/2} form of the main factor. -/
private lemma half_re {z : ℂ} : (z / 2).re = z.re / 2 := by
  have hinv : (2 : ℂ)⁻¹ = (1 / 2 : ℝ) := by norm_num
  rw [div_eq_mul_inv, Complex.mul_re, hinv, Complex.ofReal_re,
    Complex.ofReal_im]
  ring

private lemma half_add_one_re {z : ℂ} : (z / 2 + 1).re = z.re / 2 + 1 := by
  have : (1 : ℂ) = (1 : ℝ) := by norm_num
  rw [this, Complex.add_re, Complex.ofReal_re, half_re]

/-- The exact xi-convention main factor of the zeta kernel:

    mainFac s  =  2 / (s (s-1) GammaR s)
                 =  pi^{s/2} / ((s-1) Gamma (s/2+1))      (mainFac_reduced)
                 =  2 pi^{s/2} / (s (s-1) Gamma (s/2))   (the s6 main_ex)

    zeta(s) = mainFac s * xiz s  (zeta_eq_main_xi).  -/
noncomputable def mainFac (s : ℂ) : ℂ := 2 / (s * (s - 1) * Complex.Gammaℝ s)

/-- The xi factor,  completed-zeta convention:

    xiz s  =  (s/2) (s-1)  completedRiemannZeta s
           =  the classic xi(s);  xiz_zero_tendsto  proves
            xi(0) = 1/2  (the removable value at  0).  -/
noncomputable def xiz (s : ℂ) : ℂ := (s / 2) * (s - 1) * completedRiemannZeta s

/-- The engine Stirling main term  (DLMF 25.2.12 form,  principal
    log branches)  -- faithful mirror of  logmain25212:

    lm(s)  =  s log(2 pi) - (1 + gamma/2) s - log 2
              - log (s-1)  - log Gamma (s/2 + 1).  -/
noncomputable def engine_lm (s : ℂ) : ℂ :=
    s * (Real.log (2 * Real.pi) : ℂ)
      - ((1 + Real.eulerMascheroniConstant / 2) : ℂ) * s
      - (Real.log 2 : ℂ)
      - Complex.log (s - 1)
      - Complex.log (Complex.Gamma (s / 2 + 1))

/-- The bridge constant:  C = log(2 sqrt pi) - 1 - gamma/2.
    The exact Re-level identity  (main_term_bridge)  is

        Re(engine_lm s) = log |mainFac s| + C/2 - log 2   (s = 1/2 + i t).  -/
noncomputable def C_bridge : ℝ :=
    Real.log (2 * Real.sqrt Real.pi) - 1 - Real.eulerMascheroniConstant / 2

/-- Ex_total -- the modeled excess sum  (t-independent):
    the sum of  1 / (2 (g^2 + 1/4))  over all modeled pairs
    (GN grid + D-band quad).   Provenance:  tmp/s6_c_closedform.jsonl
    field  Ex_m  (dps-30 value,  re-evaluated in s6).  -/
def Ex_total : ℝ := 0.011547733381927177

/-- The c-theorem residual:  EPS := C/2 + Ex_total.
    Exact side  (this file):  bridge_eps_form.   Data side:  the
    f64 engine lm agrees with the exact formula within  2.073e-6
    at all 505 ledger rows  (tmp/s8_m_true_sample.jsonl,  field
    eps);  dps-50 oracle:  EPS = -1.2110113333990715e-07.  -/
noncomputable def EPS : ℝ := C_bridge / 2 + Ex_total

/-! ## Part A -- the exact identities (data-free) -/

private lemma hpi_c : (Real.pi : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr Real.pi_ne_zero

/-- pi^{s/2} form of the main factor. -/
theorem mainFac_reduced (s : ℂ) (hs0 : s ≠ 0) (hs1 : s ≠ 1) (hrep : 0 < s.re) :
    mainFac s = (Real.pi : ℂ) ^ (s / 2) / ((s - 1) * Complex.Gamma (s / 2 + 1)) := by
  have hgr : Complex.Gamma (s / 2) ≠ 0 :=
    Complex.Gamma_ne_zero_of_re_pos (by rw [half_re]; linarith)
  have hsub : s - 1 ≠ 0 := by
    intro h
    apply hs1
    have hext := Complex.ext_iff.mp h
    apply Complex.ext
    · simp only [Complex.sub_re] at hext
      norm_num at hext ⊢
      linarith
    · simp only [Complex.sub_im] at hext
      norm_num at hext ⊢
      linarith
  have hsz2 : s / 2 ≠ 0 := by
    intro h3
    apply hs0
    field_simp at h3
    norm_num at h3
    exact h3
  have gao : Complex.Gamma (1 + s / 2) = (s / 2) * Complex.Gamma (s / 2) := by
    rw [show 1 + s / 2 = s / 2 + 1 from by ring]
    exact Complex.Gamma_add_one (s / 2) hsz2
  have hinvπ : (Real.pi : ℂ) ^ (s / 2) * (Real.pi : ℂ) ^ (-s / 2) = 1 := by
    have hw1 : (Real.pi : ℂ) ^ (s / 2) =
        Complex.exp (Complex.log (Real.pi : ℂ) * (s / 2)) :=
      Complex.cpow_def_of_ne_zero hpi_c (s / 2)
    have hw2 : (Real.pi : ℂ) ^ (-s / 2) =
        Complex.exp (Complex.log (Real.pi : ℂ) * (-s / 2)) :=
      Complex.cpow_def_of_ne_zero hpi_c (-s / 2)
    rw [hw1, hw2]
    have hsum : Complex.log (Real.pi : ℂ) * (s / 2) +
        Complex.log (Real.pi : ℂ) * (-s / 2) = 0 := by ring
    rw [← Complex.exp_add, hsum, Complex.exp_zero]
  dsimp only [mainFac]
  rw [Complex.Gammaℝ_def, show (s / 2 + 1 : ℂ) = 1 + s / 2 from by ring]
  rw [gao]
  field_simp [hs0, hsub, hgr, hinvπ]
  have hinv2 : (Real.pi : ℂ) ^ (-(s / 2)) * (Real.pi : ℂ) ^ (s / 2) = 1 := by
    convert hinvπ using 1
    ring
  rw [hinv2]

/-- zeta = main factor times the xi factor. -/
theorem zeta_eq_main_xi (s : ℂ) (hs1 : s ≠ 1) (hrep : 0 < s.re) :
    riemannZeta s = mainFac s * xiz s := by
  have hs0 : s ≠ 0 := by
    intro h
    have hre : s.re = 0 := by
      rw [(Complex.ext_iff).mp h |>.1]
      norm_num
    linarith
  have hsub : s - 1 ≠ 0 := by
    intro h
    apply hs1
    have hext := Complex.ext_iff.mp h
    apply Complex.ext
    · simp only [Complex.sub_re] at hext
      norm_num at hext ⊢
      linarith
    · simp only [Complex.sub_im] at hext
      norm_num at hext ⊢
      linarith
  have hgr : Complex.Gammaℝ s ≠ 0 := Complex.Gammaℝ_ne_zero_of_re_pos hrep
  dsimp only [mainFac, xiz]
  rw [riemannZeta_def_of_ne_zero hs0]
  field_simp [hs0, hsub, hgr]

/-- Punctured-continuity step:  a function continuous at  0  with
    value  c  tends to  c  along  the punctured neighborhood filter. -/
theorem contAt_tendsto_hnpunct (f : ℂ → ℂ) (hf : ContinuousAt f (0 : ℂ)) :
    Tendsto f (𝓝[≠] (0 : ℂ)) (𝓝 (f (0 : ℂ))) := by
  calc map f (𝓝[≠] (0 : ℂ)) ≤ map f (𝓝 (0 : ℂ)) :=
      Filter.map_mono (show 𝓝[≠] (0 : ℂ) ≤ 𝓝 (0 : ℂ) from
        by simp [nhdsWithin, inf_le_left])
    _ ≤ 𝓝 (f (0 : ℂ)) := hf

/-- The removable value at 0:  xi(0) = 1/2.
    (dps-30 cross-check:  0.499999999999988,  s7.)  -/
theorem xiz_zero_tendsto : Tendsto xiz (𝓝[≠] (0 : ℂ)) (𝓝 (1 / 2 : ℂ)) := by
  set f1 : ℂ → ℂ := fun s => Complex.Gamma (1 + s / 2) with hf1
  set f2 : ℂ → ℂ := fun s => s - 1 with hf2
  set f3 : ℂ → ℂ := fun s => (Real.pi : ℂ) ^ (-s / 2) with hf3
  set f4 : ℂ → ℂ := fun s => riemannZeta s with hf4
  have hball : ∀ᶠ (s : ℂ) in 𝓝 (0 : ℂ), ‖s‖ < 1 := by
    have hopen : IsOpen (Metric.ball (0 : ℂ) 1) := Metric.isOpen_ball
    have hmem : (0 : ℂ) ∈ Metric.ball (0 : ℂ) 1 :=
      Metric.mem_ball_self (by norm_num)
    filter_upwards [hopen.mem_nhds hmem] with s hb
    simpa using Metric.mem_ball.mp hb
  have hpoint : ∀ᶠ (s : ℂ) in 𝓝[≠] (0 : ℂ),
      xiz s = f1 s * f2 s * f3 s * f4 s := by
    rw [eventually_nhdsWithin_iff]
    filter_upwards [hball] with s hs01
    intro hsne
    have hgs : Complex.Gamma (s / 2) ≠ 0 := by
      intro hgz
      have hpole := (Complex.Gamma_eq_zero_iff (s / 2)).mp hgz
      rcases hpole with ⟨m, hmeq⟩
      by_cases hm0 : m = 0
      · have hs0 : s = 0 := by
          rw [hm0] at hmeq
          field_simp at hmeq
          norm_num at hmeq
          exact hmeq
        exact hsne hs0
      · have hm1 : (1 : ℕ) ≤ m := by omega
        have hs : s = -2 * (m : ℂ) := by
          rw [div_eq_iff (two_ne_zero' ℂ)] at hmeq
          ring_nf at hmeq ⊢
          exact hmeq
        have hsre : s.re = -2 * (m : ℝ) := by
          rw [hs, Complex.mul_re, Complex.neg_re, Complex.neg_im]
          have h2re : (2 : ℂ).re = 2 := by norm_num
          have h2im : (2 : ℂ).im = 0 := by norm_num
          have hmre : (m : ℂ).re = (m : ℝ) := by norm_cast
          have hmim : (m : ℂ).im = 0 := by norm_cast
          rw [h2re, h2im, hmre, hmim]
          ring
        have habs2 : (2 : ℝ) ≤ 2 * (m : ℝ) := by
          have h1 : (1 : ℝ) ≤ m := by exact_mod_cast hm1
          nlinarith [h1]
        have hab : |s.re| ≤ ‖s‖ := Complex.abs_re_le_norm s
        have hneg : -2 * (m : ℝ) ≤ 0 := by
          nlinarith [show (0 : ℝ) ≤ m from by exact_mod_cast Nat.zero_le m]
        have habsre : 2 * (m : ℝ) ≤ ‖s‖ := by
          have : |-2 * (m : ℝ)| = 2 * (m : ℝ) := by
            rw [abs_of_nonpos hneg]
            ring
          simpa [this, hsre] using hab
        linarith
    have hsz2 : s / 2 ≠ 0 := by
      by_contra h3
      apply hsne
      have : s = 2 * (s / 2) := by ring
      rw [this, h3, mul_zero]
      rfl
    have hgao : Complex.Gamma (1 + s / 2) = (s / 2) * Complex.Gamma (s / 2) := by
      rw [show 1 + s / 2 = s / 2 + 1 from by ring]
      exact Complex.Gamma_add_one (s / 2) hsz2
    have hgr : Complex.Gammaℝ s ≠ 0 := by
      rw [Complex.Gammaℝ_def]
      refine mul_ne_zero ?_ hgs
      rw [Complex.cpow_def_of_ne_zero hpi_c]
      exact Complex.exp_ne_zero _
    have hrel : completedRiemannZeta s = Complex.Gammaℝ s * riemannZeta s := by
      have this := riemannZeta_def_of_ne_zero hsne
      field_simp [hgr] at this
      rw [mul_comm] at this
      exact this.symm
    dsimp only [xiz, f1, f2, f3, f4]
    calc (s / 2) * (s - 1) * completedRiemannZeta s
        _ = (s / 2) * (s - 1) * (Complex.Gammaℝ s * riemannZeta s) := by
            rw [hrel]
          _ = ((s / 2) * Complex.Gamma (s / 2)) * (s - 1) *
              ((Real.pi : ℂ) ^ (-s / 2)) * riemannZeta s := by
            rw [Complex.Gammaℝ_def]
            ring
          _ = Complex.Gamma (1 + s / 2) * (s - 1) *
              ((Real.pi : ℂ) ^ (-s / 2)) * riemannZeta s := by
            rw [hgao]
          _ = f1 s * f2 s * f3 s * f4 s := by
            dsimp only [f1, f2, f3, f4]
  have hf10 : f1 0 = 1 := by
    dsimp [f1]
    rw [show (1 + (0 : ℂ) / 2 : ℂ) = 1 from by norm_num, Complex.Gamma_one]
  have hp1 : Tendsto f1 (𝓝[≠] (0 : ℂ)) (𝓝 (1 : ℂ)) := by
    have hc : ContinuousAt f1 (0 : ℂ) := by
      dsimp only [f1]
      apply ContinuousAt.comp
      · convert Complex.differentiableAt_Gamma_one.continuousAt using 1
        norm_num
      · exact ContinuousAt.add continuousAt_const
          (ContinuousAt.div continuousAt_id continuousAt_const (by norm_num))
    convert contAt_tendsto_hnpunct f1 hc using 1
    rw [hf10]
  have hp2 : Tendsto f2 (𝓝[≠] (0 : ℂ)) (𝓝 (-1 : ℂ)) := by
    have hc : ContinuousAt f2 (0 : ℂ) := by
      dsimp only [f2]
      exact ContinuousAt.sub continuousAt_id continuousAt_const
    convert contAt_tendsto_hnpunct f2 hc using 1
    simp only [hf2]
    ring
  have hp3 : Tendsto f3 (𝓝[≠] (0 : ℂ)) (𝓝 (1 : ℂ)) := by
    have hcp : f3 = fun s => Complex.exp (Complex.log (Real.pi : ℂ) * (-s / 2)) := by
      funext s
      dsimp only [f3]
      rw [Complex.cpow_def_of_ne_zero hpi_c]
    rw [hcp]
    have hc : ContinuousAt (fun s : ℂ =>
        Complex.exp (Complex.log (Real.pi : ℂ) * (-s / 2))) (0 : ℂ) := by
      apply ContinuousAt.comp
      · convert Complex.continuous_exp.continuousAt
        <;> ring
      apply ContinuousAt.mul continuousAt_const
      exact ContinuousAt.div (ContinuousAt.neg continuousAt_id)
          continuousAt_const (by norm_num)
    convert contAt_tendsto_hnpunct _ hc using 1
    simp
  have hf40 : f4 0 = -1 / 2 := by
    dsimp [f4]
    rw [riemannZeta_zero]
  have hp4 : Tendsto f4 (𝓝[≠] (0 : ℂ)) (𝓝 ((-1 / 2 : ℂ))) := by
    have hc : ContinuousAt f4 (0 : ℂ) := by
      dsimp only [f4]
      convert (differentiableAt_riemannZeta (show (0 : ℂ) ≠ 1 from by norm_num)).continuousAt
      <;> funext s <;> rfl
    convert contAt_tendsto_hnpunct f4 hc using 1
    rw [hf40]
  have hprod : Tendsto (fun s : ℂ => f1 s * f2 s * f3 s * f4 s)
      (𝓝[≠] (0 : ℂ)) (𝓝 ((1 : ℂ) * -1 * 1 * (-1 / 2))) :=
    Tendsto.mul (Tendsto.mul (Tendsto.mul hp1 hp2) hp3) hp4
  have hgoal : Tendsto (fun s : ℂ => f1 s * f2 s * f3 s * f4 s)
      (𝓝[≠] (0 : ℂ)) (𝓝 (1 / 2 : ℂ)) := by
    convert hprod using 1
    norm_num
  exact (tendsto_congr' hpoint).mpr hgoal

/-- Real and imaginary parts of the critical-line point. -/
private theorem line_re_im (t : ℝ) :
    ((1 / 2 : ℂ) + (t : ℂ) * Complex.I).re = 1 / 2 ∧
    ((1 / 2 : ℂ) + (t : ℂ) * Complex.I).im = t := by
  have : (1 / 2 : ℂ) = (1 / 2 : ℝ) := by norm_num
  constructor
  · rw [this]
    simp only [Complex.add_re, Complex.mul_re, Complex.ofReal_re,
      Complex.ofReal_im, Complex.I_re, Complex.I_im]
    ring
  · rw [this]
    simp only [Complex.add_im, Complex.mul_im, Complex.ofReal_re,
      Complex.ofReal_im, Complex.I_re, Complex.I_im]
    ring

/-- The main factor is nonzero on the critical line away from  0,  1. -/
private theorem mainFac_ne_zero_on_line (t : ℝ) (ht : 0 < t) :
    mainFac ((1 / 2 : ℂ) + (t : ℂ) * Complex.I) ≠ 0 := by
  set s : ℂ := (1 / 2 : ℂ) + (t : ℂ) * Complex.I with hs
  have hs0 : s ≠ 0 := by
    intro h0
    have hre := (Complex.ext_iff).mp h0 |>.1
    norm_num at hre
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    linarith
  have hsub : s - 1 ≠ 0 := by
    intro h2
    have hre := (Complex.ext_iff).mp h2 |>.1
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    have : (-1 / 2 : ℝ) = 0 := by
      simp only [Complex.sub_re] at hre
      rw [hre2] at hre
      norm_num at hre
    linarith
  have hgm : Complex.Gamma (s / 2 + 1) ≠ 0 :=
    Complex.Gamma_ne_zero_of_re_pos (by
      have hre : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
      rw [half_add_one_re, hre]
      norm_num)
  have hs1 : s ≠ 1 := by
    intro h1
    apply hsub
    rw [h1]
    norm_num
  have hr := mainFac_reduced s hs0 hs1 (by
    rw [hs]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.I_im]
    norm_num)
  rw [hr]
  have hpi : (Real.pi : ℂ) ^ (s / 2) ≠ 0 := by
    rw [Complex.cpow_def_of_ne_zero hpi_c]
    exact Complex.exp_ne_zero _
  exact div_ne_zero hpi (mul_ne_zero hsub hgm)

/-- Log-abs decomp on the critical line:
    log |zeta s| = log |mainFac s| + log |xiz s|  (zeta s ≠ 0). -/
theorem log_abs_decomp (t : ℝ) (ht : 0 < t)
    (hz : riemannZeta ((1 / 2 : ℂ) + (t : ℂ) * Complex.I) ≠ 0) :
    Real.log ‖riemannZeta ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ =
      Real.log ‖mainFac ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ +
      Real.log ‖xiz ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ := by
  set s : ℂ := (1 / 2 : ℂ) + (t : ℂ) * Complex.I with hs
  have hs0 : s ≠ 0 := by
    intro h0
    have hre := (Complex.ext_iff).mp h0 |>.1
    norm_num at hre
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    linarith
  have hsub : s - 1 ≠ 0 := by
    intro h2
    have hre := (Complex.ext_iff).mp h2 |>.1
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    have : (-1 / 2 : ℝ) = 0 := by
      simp only [Complex.sub_re] at hre
      rw [hre2] at hre
      norm_num at hre
    linarith
  have hshalf : s / 2 ≠ 0 := by
    by_contra h3
    apply hs0
    have : s = 2 * (s / 2) := by ring
    rw [this, h3, mul_zero]
  have hz0 : riemannZeta s ≠ 0 := by simpa using hz
  have hlam : completedRiemannZeta s ≠ 0 := by
    by_contra hl
    have hgr : Complex.Gammaℝ s ≠ 0 :=
      Complex.Gammaℝ_ne_zero_of_re_pos (by
        have hre : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
        rw [hre]
        norm_num)
    have this := riemannZeta_def_of_ne_zero hs0
    field_simp [hgr] at this
    have hrel : completedRiemannZeta s = Complex.Gammaℝ s * riemannZeta s := by
      rw [mul_comm] at this
      exact this.symm
    rw [hrel] at hl
    exact (mul_ne_zero hgr hz0) hl
  have hxz : xiz s ≠ 0 := by
    dsimp only [xiz]
    exact mul_ne_zero (mul_ne_zero hshalf hsub) hlam
  have hm : mainFac s ≠ 0 := mainFac_ne_zero_on_line t ht
  have hs1b : s ≠ 1 := by
    intro h1
    apply hsub
    rw [h1]
    norm_num
  dsimp only [s]
  rw [zeta_eq_main_xi s hs1b (by
    dsimp [s]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.I_im]
    ring_nf
    norm_num),
    Complex.norm_mul]
  have hnp : ‖mainFac s‖ ≠ 0 := fun h => hm (norm_eq_zero.1 h)
  have hnz : ‖xiz s‖ ≠ 0 := fun h => hxz (norm_eq_zero.1 h)
  rw [Real.log_mul hnp hnz]

/-! ## Part B -- the headline:  the main-term bridge (exact) -/

/-- THE BRIDGE (Re level,  exact,  no zero-free hypothesis):
    at every height  s = 1/2 + i t  (t > 0),

        Re (lm s)  =  log |mainFac s|  +  C_bridge / 2 - log 2.

    The exact identity behind the numerically verified main-term
    equality  (measured residual  EPS,  Part C).  -/
theorem main_term_bridge (t : ℝ) (ht : 0 < t) :
    (engine_lm ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)).re =
      Real.log ‖mainFac ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ +
        C_bridge / 2 - Real.log 2 := by
  set s : ℂ := (1 / 2 : ℂ) + (t : ℂ) * Complex.I with hs
  have hrep : 0 < s.re := by
    have hre : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    rw [hre]
    norm_num
  have hsub : s - 1 ≠ 0 := by
    intro h2
    have hre := (Complex.ext_iff).mp h2 |>.1
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    have : (-1 / 2 : ℝ) = 0 := by
      simp only [Complex.sub_re] at hre
      rw [hre2] at hre
      norm_num at hre
    linarith
  have hgmsub : Complex.Gamma (s / 2 + 1) ≠ 0 :=
    Complex.Gamma_ne_zero_of_re_pos (by rw [half_add_one_re]; linarith [hrep])
  have hs1b : s ≠ 1 := by
    intro h1
    apply hsub
    rw [h1]
    norm_num
  have hr := mainFac_reduced s (by
    intro h0
    have hre := (Complex.ext_iff).mp h0 |>.1
    norm_num at hre
    have hre2 : s.re = 1 / 2 := by simpa [hs] using (line_re_im t).1
    linarith) hs1b hrep
  have habs : Real.log ‖mainFac s‖ =
      Real.log ‖(Real.pi : ℂ) ^ (s / 2)‖ - Real.log ‖s - 1‖ -
      Real.log ‖Complex.Gamma (s / 2 + 1)‖ := by
    rw [hr, Complex.norm_div]
    have hpi : (Real.pi : ℂ) ^ (s / 2) ≠ 0 := by
      rw [Complex.cpow_def_of_ne_zero hpi_c]
      exact Complex.exp_ne_zero _
    have hnum2 : ‖(Real.pi : ℂ) ^ (s / 2)‖ ≠ 0 := fun h => hpi (norm_eq_zero.1 h)
    have hden2 : ‖(s - 1) * Complex.Gamma (s / 2 + 1)‖ ≠ 0 :=
      fun h => mul_ne_zero hsub hgmsub (norm_eq_zero.1 h)
    have hA : ‖s - 1‖ ≠ 0 := fun h => hsub (norm_eq_zero.1 h)
    have hB : ‖Complex.Gamma (s / 2 + 1)‖ ≠ 0 :=
      fun h => hgmsub (norm_eq_zero.1 h)
    rw [Real.log_div hnum2 hden2, Complex.norm_mul, Real.log_mul hA hB]
    ring
  have hexp : Real.log ‖(Real.pi : ℂ) ^ (s / 2)‖ = Real.log Real.pi / 4 := by
    have hcpow : (Real.pi : ℂ) ^ (s / 2) =
        Complex.exp (Complex.log (Real.pi : ℂ) * (s / 2)) :=
      Complex.cpow_def_of_ne_zero hpi_c (s / 2)
    rw [hcpow, Complex.norm_exp, Real.log_exp]
    have hlogπ : Complex.log (Real.pi : ℂ) = (Real.log Real.pi : ℂ) :=
      (Complex.ofReal_log (le_of_lt Real.pi_pos)).symm
    rw [hlogπ]
    have hreal : ((Real.log Real.pi : ℂ) * (s / 2)).re = Real.log Real.pi / 4 := by
      rw [Complex.mul_re, half_re]
      simp only [Complex.ofReal_re, Complex.ofReal_im]
      have hsre : s.re = 1 / 2 := by
        simpa [hs] using (line_re_im t).1
      rw [hsre]
      ring
    rw [hreal]
  have H : (engine_lm s).re =
      Real.log ‖mainFac s‖ + (C_bridge / 2 - Real.log 2) := by
    calc (engine_lm s).re
        _ = s.re * Real.log (2 * Real.pi) -
            (1 + Real.eulerMascheroniConstant / 2) * s.re -
            Real.log 2 - (Complex.log (s - 1)).re -
            (Complex.log (Complex.Gamma (s / 2 + 1))).re := by
          dsimp only [engine_lm]
          simp only [Complex.sub_re, Complex.add_re, Complex.mul_re,
            Complex.sub_im, Complex.add_im, Complex.ofReal_re,
            Complex.ofReal_im]
          norm_num
        _ = (1 / 2) * Real.log (2 * Real.pi) -
            (1 + Real.eulerMascheroniConstant / 2) / 2 -
            Real.log 2 - Real.log ‖s - 1‖ -
            Real.log ‖Complex.Gamma (s / 2 + 1)‖ := by
          have hsre : s.re = 1 / 2 := by
            simpa [hs] using (line_re_im t).1
          rw [hsre, Complex.log_re, Complex.log_re]
          have hre1 : (1 / 2) * (2 : ℝ) = 1 := by norm_num
          ring
        _ = Real.log ‖mainFac s‖ + (C_bridge / 2 - Real.log 2) := by
          rw [habs, hexp]
          dsimp only [C_bridge]
          have hsplit : Real.log (2 * Real.pi) = Real.log 2 + Real.log Real.pi := by
            rw [Real.log_mul (show (2 : ℝ) ≠ 0 by norm_num) Real.pi_ne_zero]
          have hsplit2 : Real.log (2 * Real.sqrt Real.pi) =
              Real.log 2 + Real.log Real.pi / 2 := by
            have hsq : (Real.sqrt Real.pi : ℝ) ≠ 0 := by
              intro h
              nlinarith [Real.sqrt_pos.2 Real.pi_pos, h]
            rw [Real.log_mul (show (2 : ℝ) ≠ 0 by norm_num) hsq,
              Real.log_sqrt (le_of_lt Real.pi_pos)]
          rw [hsplit, hsplit2]
          ring
  dsimp only [s]
  rw [H]
  ring

/-- c-theorem form of the bridge:  the named residual  EPS.
    (Measured face:  the f64 engine lm agrees with the exact
    formula within  2.073e-6  at all 505 ledger rows  --
    tmp/s8_m_true_sample.jsonl.)  -/
theorem bridge_eps_form (t : ℝ) (ht : 0 < t) :
    (engine_lm ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)).re =
      Real.log ‖mainFac ((1 / 2 : ℂ) + (t : ℂ) * Complex.I)‖ +
        Real.log (1 / 2) - Ex_total + EPS := by
  rw [main_term_bridge t ht]
  have hlog : -Real.log 2 = Real.log (1 / 2) := by
    have : (1 / 2 : ℝ) = (2 : ℝ)⁻¹ := by ring
    rw [this]
    exact (Real.log_inv 2).symm
  dsimp only [EPS]
  linarith [hlog]

/-! ## Part C -- the data part (E7a-style gates)

  The reals of this mathlib pin are not  #eval-able,  so the
  numeric cross-check runs over Float  (independent kernel
  arithmetic)  exactly as  E7a  does:  transcription + arithmetic
  of the pinned constants,  against the dps-50 oracle  (mpmath
  s6/s7 record).  The exact real-side content is Part B.
-/

/-- log(2 sqrt pi) - 1 - gamma/2,  re-evaluated in Float with the
    kernel  Float.log /  Float.sqrt  and the transcribed gamma
    (dps-20 of  the canonical value).  -/
def C_float : Float :=
    (2 * Float.sqrt Float.pi).log - 1 - (0.5772156649015329 : Float) / 2

#eval C_float
  -- dps-50 oracle: -0.02309570896612103383500550576614791107...

def EPS_float : Float := C_float / 2 + (0.011547733381927 : Float)

#eval EPS_float
  -- dps-50 oracle: -1.2110113333990715e-07

#eval C_float / 2
  -- = -0.0115478544830605 (the leading part of the measured EPS)

end MainBridge
