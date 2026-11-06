import Mathlib
import RhAttack.ThetaInf
import RhAttack.LevWall

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd ThetaInf LevWall

open scoped Topology
open MeasureTheory

/-!
**LevWall2 — the Radziwiłł limitation and the WALL SHARPENED
(0294, option B, unit 6).**

PROVENANCE (primary source, pulled 2026-11-11, ar5iv of
arXiv:1207.6583 — Maksym Radziwiłł, "Limitations to mollifying
ζ(s)", Stanford):

* ABSTRACT (verbatim): "We establish limitations to how well one
  can mollify the Riemann zeta-function on the critical line with
  mollifiers of arbitrary length. Our result gives a non-trivial
  lower bound for the contribution of the off-diagonal terms to
  mollified moments of ζ(s). On the Riemann Hypothesis, we
  establish a connection between the mollified moment and
  Montgomery's Pair Correlation Function."
* THEOREM 1 (verbatim shape): for all θ > 0 there is an absolute
  c > 0 such that for all T large and all
  M_θ(s) = ∑_{n≤T^θ} a(n)/n^s with a(n) ≪ n^ε, a(1) = 1:
      ℐ(M_θ) := (1/T) ∫_T^{2T} |1 − ζ(1/2+it) M_θ(1/2+it)|² dt
                ≥ c / θ.
  UNCONDITIONAL — the universal (non-sharp) limitation is ALREADY
  PROVEN (cited; not the gap).  Verbatim: "We would like to
  understand if ℐ(M_θ) can be much smaller than 1/θ when M_θ(s)
  is a longer mollifier, say with θ > 1. We show that the answer
  is 'no'."
* PROPOSITION B (Soundararajan, quoted in the paper):  IF
  θ < 1/2,  then  as T→∞
      ℐ(M_θ) ∼ ∑_{m,n≤T^θ} a(m)ā(n)/[m,n] ·
              ( log(T (m,n)²/(2π m n)) + 2 log 2 + 2γ − 1 ) − 1
              ≥ 1/θ + o(1),
  "For θ < 1/2 we show that c = 1, using an asymptotic formula
  for ℐ, due to Balasubramanian, Conrey and Heath-Brown."  For
  θ > 1/2 the lower bound instead comes from Proposition A (a
  Sobolev-type inequality on the zeros), with a WEAKER c  -
  the EXPLICIT OFF-DIAGONAL FORM is the barrier.

SHARPENING OF [LEV-WALL] (0293):
  * the universal limitation  ℐ ≥ c/θ  is NOT the gap  (it is
    already unconditional  -  Radziwiłł Theorem 1);
  * the OPEN content of lane M2 is the SHARP asymptotic - the
    residual moment at length T^θ achieving exactly 1/θ  (c = 1,
    the explicit off-diagonal quadratic form)  -  published only
    for  0 < θ < 1/2  (B-C-H-B/Soundararajan;  the (1.2)-style
    asymptotic extends to 4/7 via Conrey's variant mollifier  -
    0293).

MACHINE-VERIFIED CONTENT (no RH claim):
  1. `residPointwise`  -  ‖1−w‖² = 1 + ‖w‖² − 2·Re(w);
  2. `line_ne_pole`, `zetaLineContinuous`, `mollLineContinuous`,
     `wThetaContinuous`  -  the critical-line integrand is
     continuous (Mathlib's `differentiableAt_riemannZeta`);
  3. `residExpand`  -  the integral identity  (machine):
       thetaResid(Y,T) = (2T−T) + thetaIMoment(Y,T,2T)
                        − 2·thetaReMain(Y,T);
  4. `residSharp`  -  THE WALL THEOREM (machine, limit algebra):
       [asympAt2T θ] + [mozMain θ]  (explicit cited inputs)
       imply  levSharp θ  -  the residual moment achieves
       exactly 1/θ;
  5. range arithmetic  -  1/2 + 1/34 = 9/17  (the B-C-H-B
     length),  9/17 < 4/7  (Conrey's frontier lies beyond it),
     1/2 < 9/17 < 4/7 < 1.
-/

namespace LevWall2

/-! ### 1.  The critical-line integrand (Radziwiłł's window) -/

/-- The critical line  t ↦ 1/2 + it  (never meets the pole at
    1:  Re = 1/2 ≠ 1). -/
noncomputable def line (t : ℝ) : ℂ := Complex.mk (1 / 2) t

/-- (PROVEN, machine)  the line as an affine-map identity  (used
    for the continuity proof):  1/2 + it  =  (1/2) + t·I. -/
theorem line_ext : line = (fun t : ℝ => (1 / 2 : ℂ) + (t : ℂ) * Complex.I) := by
  ext t
  simp only [line, Complex.ext_iff]
  simp

/-- (PROVEN, machine)  the critical line is continuous. -/
theorem line_cont : Continuous (line : ℝ → ℂ) := by
  rw [line_ext]
  continuity

/-- (PROVEN, machine)  the critical line avoids the pole. -/
theorem line_ne_pole (t : ℝ) : line t ≠ 1 := by
  intro heq
  have hre := congrArg Complex.re heq
  simp only [line] at hre
  norm_num at hre

/-- THE MOLLIFIED ZETA ON THE CRITICAL LINE:
    w(Y, t) = M_Y(1/2+it) · ζ(1/2+it).  `thetaResid` integrates
    ‖1−w‖²;  `thetaIMoment` integrates ‖w‖²;  `thetaReMain`
    integrates Re(w).  All on Radziwiłł's window [T, 2T]. -/
noncomputable def wTheta (Y t : ℝ) : ℂ :=
    thetaMoll Y (line t) * riemannZeta (line t)

/-- THE RE MAIN-TERM integral:  ∫_T^{2T} Re(M_Y · ζ) dt. -/
noncomputable def thetaReMain (Y T : ℝ) : ℝ :=
    ∫ t in T..(2 * T), (wTheta Y t).re

/-- THE RESIDUAL MOMENT (Radziwiłł's ℐ, unscaled):
    ∫_T^{2T} |1 − M_Y · ζ|² dt. -/
noncomputable def thetaResid (Y T : ℝ) : ℝ :=
    ∫ t in T..(2 * T), ‖1 - wTheta Y t‖ ^ 2

/-! ### 2.  Continuity (machine) -/

/-- (PROVEN, machine)  the critical-line zeta factor is
    continuous:  Mathlib's `differentiableAt_riemannZeta` on
    `{1}ᶜ`,  composed with the line. -/
theorem zetaLineContinuous : Continuous (fun t : ℝ => riemannZeta (line t)) :=
  continuous_iff_continuousAt.mpr fun t =>
    ContinuousAt.comp
      ((differentiableAt_riemannZeta (line_ne_pole t)).continuousAt)
      (line_cont.continuousAt)

/-- (PROVEN, machine)  the Levinson mollifier factor is
    continuous in  t  (finite sum of continuous terms;  the
    `Real.log`-constants are fixed in  t). -/
theorem mollLineContinuous (Y : ℝ) :
    Continuous (fun t : ℝ => thetaMoll Y (line t)) := by
  have hline : Continuous (line : ℝ → ℂ) := line_cont
  dsimp only [thetaMoll]
  continuity

/-- (PROVEN, machine)  the full integrand  w  is continuous. -/
theorem wThetaContinuous (Y : ℝ) : Continuous (fun t : ℝ => wTheta Y t) :=
  (mollLineContinuous Y).mul zetaLineContinuous

/-! ### 3.  THE INTEGRAL EXPANSION (machine) -/

/-- (PROVEN, machine)  the pointwise identity (the algebraic
    heart):   ‖1−w‖²  =  1 + ‖w‖² − 2·Re(w). -/
theorem residPointwise (w : ℂ) :
    ‖1 - w‖ ^ 2 = 1 + ‖w‖ ^ 2 - 2 * w.re := by
  have hL : ‖1 - w‖ ^ 2 = Complex.normSq (1 - w) :=
      (Complex.normSq_eq_norm_sq (1 - w)).symm
  have hR : ‖w‖ ^ 2 = Complex.normSq w := (Complex.normSq_eq_norm_sq w).symm
  rw [hL, hR]
  rw [Complex.normSq_apply, Complex.normSq_apply]
  simp
  ring

/-- (PROVEN, machine)  the norm-square of the theta-zeta factor
    is exactly the integrand of `thetaIMoment`  (the published
    (1.2) moment)  at the critical line. -/
theorem wThetaNormEqMoment (Y t : ℝ) :
    ‖wTheta Y t‖ ^ 2 =
      ‖thetaMoll Y (line t)‖ ^ 2 * ‖riemannZeta (line t)‖ ^ 2 := by
  have hmul : ‖wTheta Y t‖ =
      ‖thetaMoll Y (line t)‖ * ‖riemannZeta (line t)‖ := by
    rw [wTheta]
    exact norm_mul _ _
  rw [show ‖wTheta Y t‖ ^ 2 = (‖thetaMoll Y (line t)‖ * ‖riemannZeta (line t)‖) ^ 2 from by
      rw [hmul]]
  ring

/-- (PROVEN, machine)  interval-linearity:  on  [T, 2T]
    (T ≥ 0)  the residual integral expands into
    (constant + the (1.2)-moment − 2·the re main). -/
theorem residExpand (Y T : ℝ) (hT : 0 ≤ T) :
    thetaResid Y T =
      (2 * T - T) + thetaIMoment Y T (2 * T) - 2 * thetaReMain Y T := by
  have hpt : ∀ t, ‖1 - wTheta Y t‖ ^ 2 = 1 + ‖wTheta Y t‖ ^ 2 - 2 * (wTheta Y t).re :=
      fun t => residPointwise (wTheta Y t)
  have hcont : Continuous (fun t : ℝ => wTheta Y t) := wThetaContinuous Y
  have hnorm : Continuous (fun t : ℝ => ‖wTheta Y t‖ ^ 2) := by
    have hcont : Continuous (fun t : ℝ => wTheta Y t) := wThetaContinuous Y
    continuity
  have hre : Continuous (fun t : ℝ => (wTheta Y t).re) :=
      Continuous.comp continuous_re hcont
  have hI1 : IntervalIntegrable (fun _ : ℝ => (1 : ℝ)) volume T (2 * T) :=
      (continuous_const : Continuous (fun _ : ℝ => (1 : ℝ))).intervalIntegrable T (2 * T)
  have hIN : IntervalIntegrable (fun t : ℝ => ‖wTheta Y t‖ ^ 2) volume T (2 * T) :=
      hnorm.intervalIntegrable T (2 * T)
  have hIR : IntervalIntegrable (fun t : ℝ => (wTheta Y t).re) volume T (2 * T) :=
      hre.intervalIntegrable T (2 * T)
  have hIsig : IntervalIntegrable (fun t : ℝ => 1 + ‖wTheta Y t‖ ^ 2) volume T (2 * T) :=
      (continuous_const.add hnorm).intervalIntegrable T (2 * T)
  have hI2r : IntervalIntegrable (fun t : ℝ => 2 * (wTheta Y t).re) volume T (2 * T) :=
      ((continuous_const : Continuous (fun _ : ℝ => (2 : ℝ))).mul hre).intervalIntegrable T (2 * T)
  have hC :
      (∫ t in T..(2 * T), ‖1 - wTheta Y t‖ ^ 2) =
        (∫ t in T..(2 * T), (1 + ‖wTheta Y t‖ ^ 2 - 2 * (wTheta Y t).re : ℝ)) := by
    rw [intervalIntegral.integral_congr fun t _ => hpt t]
  have hsub :
      (∫ t in T..(2 * T), (1 + ‖wTheta Y t‖ ^ 2 - 2 * (wTheta Y t).re : ℝ)) =
        (∫ t in T..(2 * T), (1 + ‖wTheta Y t‖ ^ 2)) -
        (∫ t in T..(2 * T), (2 * (wTheta Y t).re : ℝ)) :=
    intervalIntegral.integral_sub hIsig hI2r
  have hadd :
      (∫ t in T..(2 * T), (1 + ‖wTheta Y t‖ ^ 2)) =
        (∫ t in T..(2 * T), (1 : ℝ)) + (∫ t in T..(2 * T), ‖wTheta Y t‖ ^ 2) :=
    intervalIntegral.integral_add hI1 hIN
  have hmul :
      (∫ t in T..(2 * T), (2 * (wTheta Y t).re : ℝ)) =
      (2 : ℝ) * (∫ t in T..(2 * T), (wTheta Y t).re) :=
    intervalIntegral.integral_const_mul 2 _
  have hconst : (∫ t in T..(2 * T), (1 : ℝ)) = 2 * T - T := by
    rw [intervalIntegral.integral_const]
    ring
  have hIeq : thetaIMoment Y T (2 * T) = (∫ t in T..(2 * T), ‖wTheta Y t‖ ^ 2) := by
    rw [thetaIMoment]
    change (∫ t : ℝ in T..(2 * T),
        ‖thetaMoll Y (line t)‖ ^ 2 * ‖riemannZeta (line t)‖ ^ 2) =
      (∫ t : ℝ in T..(2 * T), ‖wTheta Y t‖ ^ 2)
    rw [intervalIntegral.integral_congr fun t _ => (wThetaNormEqMoment Y t).symm]
  change (∫ t in T..(2 * T), ‖1 - wTheta Y t‖ ^ 2) =
      (2 * T - T) + thetaIMoment Y T (2 * T) - 2 * thetaReMain Y T
  rw [hC, hsub, hadd, hmul, hconst, ← hIeq, thetaReMain]


/-! ### 4.  The wall at the sharp constant (machine) -/

/-- (1.2) AT θ ON THE DOUBLED WINDOW [T, 2T]  (named cited
    input - the published (1.2) asymptotic, window form): -/
def asympAt2T (θ : ℝ) : Prop :=
    Tendsto (fun (T : ℝ) => thetaIMoment (T ^ θ) T (2 * T) / T)
      atTop (𝓝 (1 + 1 / θ))

/-- THE MOLLIFIER MAIN TERM (named cited input):
    the averaged re part  Re(M_Y·ζ)  over  [T, 2T]  at scale T
    converges to 1  (the point of the mollifier:  M_Y·ζ ≈ 1 on
    average). -/
def mozMain (θ : ℝ) : Prop :=
    Tendsto (fun (T : ℝ) => thetaReMain (T ^ θ) T / T) atTop (𝓝 1)

/-- THE SHARP RESIDUAL ASYMPTOTIC AT θ  (the named open part of
    [LEV-WALL] after the 0294 sharpening  -  see
    `barrierAsymp`):  the residual moment achieves exactly
    1/θ.  PUBLISHED REACH:  0 < θ < 1/2  (B-C-H-B/Soundararajan,
    the explicit off-diagonal quadratic form, c = 1).  OPEN for
    θ > 1/2. -/
def levSharp (θ : ℝ) : Prop :=
    Tendsto (fun (T : ℝ) => thetaResid (T ^ θ) T / T) atTop (𝓝 (1 / θ))

/-- (PROVEN, machine)  THE WALL THEOREM, limit algebra:
    [asympAt2T θ] + [mozMain θ]  imply  the sharp residual
    1/θ  -  i.e.  any proof of the (1.2) asymptotic (with the
    mollifier main term) must make the residual achieve EXACTLY
    1/θ:  the Radziwiłł universal bound is hit with c = 1. -/
theorem residSharp (θ : ℝ) (hθ : 0 < θ)
    (hI : asympAt2T θ) (hM : mozMain θ) : levSharp θ := by
  have hE : ∀ T > 0, thetaResid (T ^ θ) T / T =
      1 + thetaIMoment (T ^ θ) T (2 * T) / T - 2 * (thetaReMain (T ^ θ) T / T) := by
    intro T hT
    rw [residExpand (T ^ θ) T (le_of_lt hT)]
    rw [show (2 * T - T : ℝ) = T from by ring]
    field_simp [hT.ne']
  have hF : (fun T : ℝ => thetaResid (T ^ θ) T / T) =ᶠ[atTop]
      (fun T : ℝ => 1 + thetaIMoment (T ^ θ) T (2 * T) / T - 2 * (thetaReMain (T ^ θ) T / T)) := by
    filter_upwards [Ioi_mem_atTop 1] with T hT
    rw [hE T (zero_lt_one.trans (Set.mem_Ioi.mp hT))]
  have hB : Tendsto (fun T : ℝ => 2 * (thetaReMain (T ^ θ) T / T)) atTop (𝓝 (2 * (1 : ℝ))) :=
      Tendsto.const_mul (2 : ℝ) hM
  have hA : Tendsto (fun T : ℝ => 1 + thetaIMoment (T ^ θ) T (2 * T) / T - 2 * (thetaReMain (T ^ θ) T / T))
      atTop (𝓝 ((1 + (1 + 1 / θ)) - 2 * (1 : ℝ))) :=
    (tendsto_const_nhds.add hI).sub hB
  have hlim : (1 + (1 + 1 / θ)) - 2 * (1 : ℝ) = 1 / θ := by
    field_simp [hθ.ne']
    ring
  have hA' : Tendsto (fun T : ℝ => 1 + thetaIMoment (T ^ θ) T (2 * T) / T - 2 * (thetaReMain (T ^ θ) T / T))
      atTop (𝓝 (1 / θ)) := by
    convert hA using 1
    rw [hlim]
  exact (tendsto_congr' hF).mpr hA'

/-! ### 5.  Named cited propositions and range arithmetic -/

/-- [BARRIER-ASYMP]  (named open input - 0294 sharpening):
    `levSharp θ`.  PUBLISHED REACH  0 < θ < 1/2:
    Soundararajan Proposition B (quoted in the 0294 header),
    via the B-C-H-B asymptotic formula for the explicit
    off-diagonal quadratic form (c = 1).  For  θ > 1/2  the
    lower bound of Radziwiłł Theorem 1 instead comes from
    Proposition A (Sobolev-type inequality on the zeros),  with
    a weaker c  -  the explicit form is the barrier.  (The
    universal NON-SHARP limitation ℐ ≥ c/θ for all θ > 0 is
    Radziwiłł's UNCONDITIONAL theorem - documented in the 0294
    header,  cited,  not the gap.)  -/
def barrierAsymp (θ : ℝ) : Prop := levSharp θ

/-- (PROVEN, machine)  the B-C-H-B length is  1/2 + 1/34 = 9/17. -/
theorem bchb917_from_formula : (1 / 2 : ℚ) + 1 / 34 = 9 / 17 := by norm_num

/-- (PROVEN, machine)  9/17 < 4/7:  Conrey's published frontier
    for the (1.2) asymptotic lies beyond the B-C-H-B length. -/
theorem bchb917_lt_conrey : (9 / 17 : ℚ) < 4 / 7 := by norm_num

/-- (PROVEN, machine)  the ordering of the whole published
    landscape:  1/2 (Levinson / the 1/2 barrier)  <  9/17
    (B-C-H-B length)  <  4/7 (Conrey's frontier for (1.2))  < 1. -/
theorem publishedLandscape :
    ((1 / 2 : ℚ) < (9 / 17 : ℚ)) ∧ ((9 / 17 : ℚ) < (4 / 7 : ℚ)) ∧ ((4 / 7 : ℚ) < 1) := by
  constructor
  · norm_num
  · constructor
    · norm_num
    · norm_num

end LevWall2
