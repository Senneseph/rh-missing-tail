import Mathlib
import RhAttack.LevWall2

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 ThetaInf LevWall LevWall2

open scoped Topology
open MeasureTheory

/-!
**LevWall5 — the WEIGHT-AGNOSTIC wall kernel
(0301, option B, unit 13: the scoped weighted-variant attempt).**

PURPOSE:
  The 0301 scoped attempt is the smooth REWEIGHTING family of the
  classical Levinson mollifier — for a fixed real exponent
  a > 0  (the classical Levinson weight has  a = 1):
      M_{a,Y}(s)  =  ∑_{n≤Y}  μ(n) e^{-s log n} (1 − log n/log Y)^a,
  studied as a possible lever on the  (1.2)  wall.  Two claims
  structure the audit:

  (A)  THE WALL ALGEBRA IS WEIGHT-AGNOSTIC  (machine, this file):
      for ANY mollifier family  W : Y ↦ w_Y  (Y the length),
      the residual expands on  [T, 2T]
          ∫ ‖1 − w_Y‖²  =  (2T−T) + ∫‖w_Y‖² − 2∫Re(w_Y),
      and the LIMIT ALGEBRA is the same:
          [∫‖w_{T^θ}‖²/T → 1 + 1/θ]  +  [∫Re(w_{T^θ})/T → 1]
        ⇒  ∫‖1 − w_{T^θ}‖²/T → 1/θ.
      NO property of the weight is used — only continuity.
      The classical LevWall2 wall (`residSharp`) is an exact
      INSTANCE (the bridges below).  Consequently ANY explicit
      variant (reweighted family, degree-lifted test functions,
      other mollifier shapes) gets the sharp 1/θ residual for
      free from its two named inputs — and the PUBLISHED REACH
      of those two inputs is the ENTIRE variant's reach:  the
      variant's power is carried by the off-diagonal EXONENT,
      not by the algebra.

  (B)  SMOOTH REWEIGHTING IS AN AMPLITUDE-LEVEL LEVER  (record
      audit, 0300/0301 pattern — NOT machine-provable here;
      it is a claim about the published off-diagonal sums):
      for fixed  a > 0,  w_a(n)/w_1(n)  =  (1 − log n/log Y)^{a−1}
      is a smoothly varying AMPLITUDE on  [1, Y];  its insertion
      into the (1.2) off-diagonal double sum multiplies the sum's
      BOUND CONSTANT (O_a(1) via bounded variation of the weight,
      the standard summation-by-parts bookkeeping of the
      Conrey-type off-diagonal analysis) but changes NONE of the
      sum's EXONENTS —  and the published reach of (1.2)
      (0 < θ < 1/2 Levinson-moment form;  4/7 via Conrey's
      variant;  lattice max  4/7  =  `LevWall.levWallGap`)
      is a constraint purely on those exponents  (the
      Deshouillers-Iwaniec / Kloosterman range of the
      off-diagonal machinery,  0292-PRZZ pin:  the open knob is
      the degree/truncation TRADE-OFF,  not the amplitude).
      CONSEQUENCE:  no smooth reweighting  M_{a,Y}  moves the
      wall past  4/7;  the attempt is sealed at its published
      boundary  (the 0280 negative-audit pattern).  The genuine
      remaining attack surface is the degree/truncation
      trade-off AT THE (1.2) LEVEL  (unit 14, 0302).

MACHINE-VERIFIED CONTENT (this file, no RH claim):
  1.  `residExpandGen`  —  the general weighted-moment
      interval expansion (any family  W,  continuity only);
  2.  `residSharpGen`   —  the general sharp 1/θ limit algebra
      (the wall theorem, weight-agnostic);
  3.  `classicInstance_eq`, `reMainF_Wlev_eq`, `iMomF_Wlev_eq`
      —  the bridges:  the classical  LevWall2  objects are
      exactly the  Wlev  instance of the general kernel  (the
      0294  wall theorem  `residSharp`  is  `residSharpGen`
      instantiated at  Wlev  with the same two inputs).
-/

namespace LevWall5

/-! ### 1.  The general kernel (any mollifier family) -/

/-- THE GENERAL RESIDUAL MOMENT for a mollifier family
    `W : Y ↦ w_Y` on Radziwiłł's doubled window  [T, 2T]:
    ∫_T^{2T} ‖1 − w_Y(t)‖² dt. -/
noncomputable def residGenF (W : ℝ → (ℝ → ℂ)) (Y T : ℝ) : ℝ :=
    ∫ t in T..(2 * T), ‖1 - W Y t‖ ^ 2

/-- THE GENERAL (1.2)-STYLE MOMENT  ∫_T^{2T} ‖w_Y(t)‖² dt. -/
noncomputable def iMomF (W : ℝ → (ℝ → ℂ)) (Y T : ℝ) : ℝ :=
    ∫ t in T..(2 * T), ‖W Y t‖ ^ 2

/-- THE GENERAL RE-MAIN TERM  ∫_T^{2T} Re(w_Y(t)) dt. -/
noncomputable def reMainF (W : ℝ → (ℝ → ℂ)) (Y T : ℝ) : ℝ :=
    ∫ t in T..(2 * T), (W Y t).re

/-! ### 2.  The expansion (machine) -/

/-- (PROVEN, machine)  THE WEIGHT-AGNOSTIC EXPANSION:  for ANY
    family  W  (only  `Continuous (W Y)`  needed),  on  [T, 2T]
    with  T ≥ 0:
      residGenF W Y T  =  (2T − T) + iMomF W Y T − 2 · reMainF W Y T.
    This is `LevWall2.residExpand` with the specific integrand
    `wTheta` replaced by an arbitrary continuous complex function
    —  the weight enters nowhere. -/
theorem residExpandGen (W : ℝ → (ℝ → ℂ)) (Y T : ℝ)
    (hW : Continuous (W Y)) (hT : 0 ≤ T) :
    residGenF W Y T = (2 * T - T) + iMomF W Y T - 2 * reMainF W Y T := by
  have hpt : ∀ t, ‖1 - W Y t‖ ^ 2 = 1 + ‖W Y t‖ ^ 2 - 2 * (W Y t).re :=
      fun t => LevWall2.residPointwise (W Y t)
  have hnorm : Continuous (fun t : ℝ => ‖W Y t‖ ^ 2) := by
    have hcont : Continuous (fun t : ℝ => W Y t) := hW
    continuity
  have hre : Continuous (fun t : ℝ => (W Y t).re) :=
      Continuous.comp continuous_re hW
  have hI1 : IntervalIntegrable (fun _ : ℝ => (1 : ℝ)) volume T (2 * T) :=
      (continuous_const : Continuous (fun _ : ℝ => (1 : ℝ))).intervalIntegrable T (2 * T)
  have hIN : IntervalIntegrable (fun t : ℝ => ‖W Y t‖ ^ 2) volume T (2 * T) :=
      hnorm.intervalIntegrable T (2 * T)
  have hIR : IntervalIntegrable (fun t : ℝ => (W Y t).re) volume T (2 * T) :=
      hre.intervalIntegrable T (2 * T)
  have hIsig : IntervalIntegrable (fun t : ℝ => 1 + ‖W Y t‖ ^ 2) volume T (2 * T) :=
      (continuous_const.add hnorm).intervalIntegrable T (2 * T)
  have hI2r : IntervalIntegrable (fun t : ℝ => 2 * (W Y t).re) volume T (2 * T) :=
      ((continuous_const : Continuous (fun _ : ℝ => (2 : ℝ))).mul hre).intervalIntegrable T (2 * T)
  have hC :
      (∫ t in T..(2 * T), ‖1 - W Y t‖ ^ 2) =
        (∫ t in T..(2 * T), (1 + ‖W Y t‖ ^ 2 - 2 * (W Y t).re : ℝ)) := by
    rw [intervalIntegral.integral_congr fun t _ => hpt t]
  have hsub :
      (∫ t in T..(2 * T), (1 + ‖W Y t‖ ^ 2 - 2 * (W Y t).re : ℝ)) =
        (∫ t in T..(2 * T), (1 + ‖W Y t‖ ^ 2)) -
        (∫ t in T..(2 * T), (2 * (W Y t).re : ℝ)) :=
    intervalIntegral.integral_sub hIsig hI2r
  have hadd :
      (∫ t in T..(2 * T), (1 + ‖W Y t‖ ^ 2)) =
        (∫ t in T..(2 * T), (1 : ℝ)) + (∫ t in T..(2 * T), ‖W Y t‖ ^ 2) :=
    intervalIntegral.integral_add hI1 hIN
  have hmul :
      (∫ t in T..(2 * T), (2 * (W Y t).re : ℝ)) =
      (2 : ℝ) * (∫ t in T..(2 * T), (W Y t).re) :=
    intervalIntegral.integral_const_mul 2 _
  have hconst : (∫ t in T..(2 * T), (1 : ℝ)) = 2 * T - T := by
    rw [intervalIntegral.integral_const]
    ring
  have hIeq : iMomF W Y T = (∫ t in T..(2 * T), ‖W Y t‖ ^ 2) := by
    rw [iMomF]
  have hC2 :
      (∫ t in T..(2 * T), ‖1 - W Y t‖ ^ 2) =
      (2 * T - T) + (∫ t in T..(2 * T), ‖W Y t‖ ^ 2) -
      (2 : ℝ) * (∫ t in T..(2 * T), (W Y t).re) := by
    rw [hC, hsub, hadd, hmul, hconst]
  change (∫ t in T..(2 * T), ‖1 - W Y t‖ ^ 2) =
      (2 * T - T) + iMomF W Y T - 2 * reMainF W Y T
  rw [hC2, ← hIeq, reMainF]


/-! ### 3.  The sharp limit algebra (machine) -/

/-- (PROVEN, machine)  THE WEIGHT-AGNOSTIC WALL ALGEBRA:
    for ANY family  W  (continuous on positive lengths),
        [iMomF W (T^θ) T / T → 1 + 1/θ]
        [reMainF W (T^θ) T / T → 1]
    imply
        residGenF W (T^θ) T / T → 1/θ.
    This is `LevWall2.residSharp` with `wTheta` generalized:
    the sharp  1/θ  residual (Radziwiłł's universal bound hit
    with  c = 1)  is forced by the two named inputs ALONE —
    no structure of the weight is used.  Hence the published
    reach of any explicit variant of the mollifier is EXACTLY
    the published reach of its two inputs —  carried by the
    off-diagonal EXONENT barrier. -/
theorem residSharpGen (W : ℝ → (ℝ → ℂ)) (θ : ℝ) (hθ : 0 < θ)
    (hWpos : ∀ Y > 0, Continuous (W Y))
    (hI : Tendsto (fun T : ℝ => iMomF W (T ^ θ) T / T) atTop (𝓝 (1 + 1 / θ)))
    (hM : Tendsto (fun T : ℝ => reMainF W (T ^ θ) T / T) atTop (𝓝 1)) :
    Tendsto (fun T : ℝ => residGenF W (T ^ θ) T / T) atTop (𝓝 (1 / θ)) := by
  have hE : ∀ T > 0, residGenF W (T ^ θ) T / T =
      1 + iMomF W (T ^ θ) T / T - 2 * (reMainF W (T ^ θ) T / T) := by
    intro T hT
    rw [residExpandGen W (T ^ θ) T (hWpos (T ^ θ) (Real.rpow_pos_of_pos hT θ)) (le_of_lt hT)]
    rw [show (2 * T - T : ℝ) = T from by ring]
    field_simp [hT.ne']
  have hF : (fun T : ℝ => residGenF W (T ^ θ) T / T) =ᶠ[atTop]
      (fun T : ℝ => 1 + iMomF W (T ^ θ) T / T - 2 * (reMainF W (T ^ θ) T / T)) := by
    filter_upwards [Ioi_mem_atTop 1] with T hT
    rw [hE T (zero_lt_one.trans (Set.mem_Ioi.mp hT))]
  have hB : Tendsto (fun T : ℝ => 2 * (reMainF W (T ^ θ) T / T)) atTop (𝓝 (2 * (1 : ℝ))) :=
      Tendsto.const_mul (2 : ℝ) hM
  have hA : Tendsto (fun T : ℝ => 1 + iMomF W (T ^ θ) T / T - 2 * (reMainF W (T ^ θ) T / T))
      atTop (𝓝 ((1 + (1 + 1 / θ)) - 2 * (1 : ℝ))) :=
    (tendsto_const_nhds.add hI).sub hB
  have hlim : (1 + (1 + 1 / θ)) - 2 * (1 : ℝ) = 1 / θ := by
    field_simp [hθ.ne']
    ring
  have hA' : Tendsto (fun T : ℝ => 1 + iMomF W (T ^ θ) T / T - 2 * (reMainF W (T ^ θ) T / T))
      atTop (𝓝 (1 / θ)) := by
    convert hA using 1
    rw [hlim]
  exact (tendsto_congr' hF).mpr hA'


/-! ### 4.  The bridges:  the classical wall is an instance -/

/-- THE CLASSICAL FAMILY:  Wlev(Y)(t)  =  wTheta(Y)(t)
    =  M_Y(1/2+it)·ζ(1/2+it)  (LevWall2's integrand). -/
noncomputable def Wlev (Y t : ℝ) : ℂ := wTheta Y t

/-- (PROVEN, machine)  the classical residual family is
    DEFINITIONALLY the LevWall2 residual  (the kernel is
    faithful):  residGenF Wlev Y T  =  LevWall2.thetaResid Y T. -/
theorem classicInstance_eq (Y T : ℝ) :
    residGenF Wlev Y T = LevWall2.thetaResid Y T := by
  dsimp [residGenF, Wlev, LevWall2.thetaResid]

/-- (PROVEN, machine)  the classical re-main bridge:
    reMainF Wlev Y T  =  LevWall2.thetaReMain Y T. -/
theorem reMainF_Wlev_eq (Y T : ℝ) :
    reMainF Wlev Y T = LevWall2.thetaReMain Y T := by
  dsimp [reMainF, Wlev, LevWall2.thetaReMain]

/-- (PROVEN, machine)  the classical (1.2)-moment bridge:
    iMomF Wlev Y T  =  thetaIMoment Y T (2·T)
    (pointwise  ‖m·z‖²  =  ‖m‖²·‖z‖²,  LevWall2's
    `wThetaNormEqMoment`;  integrand-congruence). -/
theorem iMomF_Wlev_eq (Y T : ℝ) :
    iMomF Wlev Y T = thetaIMoment Y T (2 * T) := by
  rw [iMomF, thetaIMoment]
  dsimp [Wlev]
  rw [intervalIntegral.integral_congr fun t _ => (LevWall2.wThetaNormEqMoment Y t)]
  rfl

/-- (PROVEN, machine)  THE BRIDGE THEOREM  (statement of the
    instance relationship, wiring only):  the 0294 wall theorem
    `LevWall2.residSharp`  is exactly  `residSharpGen`  at
    `Wlev` —  given the same two named inputs
    (`asympAt2T θ`,  `mozMain θ`),  the same conclusion follows
    from the general kernel.  (Both are proven theorems;  this
    records that the general kernel specializes correctly  -
    proved by re-deriving the conclusion of  `residSharp`
    through  `residSharpGen`.) -/
theorem residSharp_is_instance (θ : ℝ) (hθ : 0 < θ)
    (hI : asympAt2T θ) (hM : mozMain θ) :
    Tendsto (fun T : ℝ => residGenF Wlev (T ^ θ) T / T) atTop (𝓝 (1 / θ)) := by
  have hI' : Tendsto (fun T : ℝ => iMomF Wlev (T ^ θ) T / T) atTop (𝓝 (1 + 1 / θ)) := by
    have hF : (fun T : ℝ => iMomF Wlev (T ^ θ) T / T) =ᶠ[atTop]
        (fun T : ℝ => thetaIMoment (T ^ θ) T (2 * T) / T) := by
      filter_upwards [Ioi_mem_atTop 1] with T hT
      rw [iMomF_Wlev_eq (T ^ θ) T]
    exact (tendsto_congr' hF).mpr hI
  have hM' : Tendsto (fun T : ℝ => reMainF Wlev (T ^ θ) T / T) atTop (𝓝 1) := by
    have hF : (fun T : ℝ => reMainF Wlev (T ^ θ) T / T) =ᶠ[atTop]
        (fun T : ℝ => LevWall2.thetaReMain (T ^ θ) T / T) := by
      filter_upwards [Ioi_mem_atTop 1] with T hT
      rw [reMainF_Wlev_eq (T ^ θ) T]
    exact (tendsto_congr' hF).mpr hM
  have hW : ∀ Y > 0, Continuous (Wlev Y) := fun Y _hY => wThetaContinuous Y
  exact residSharpGen Wlev θ hθ hW hI' hM'

end LevWall5
