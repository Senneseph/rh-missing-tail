/-
W2Kernel — M1 of the W2 Lean plan (docs/W2-LEAN-PLAN.md), round 6.

The kernel algebra of the band-local Efull defect, EXACT, no data:

  Ker(g, t) = log|g - t| + log(g + t) - log(g^2 + 1/4)
              + (1/2)/(g^2 + 1/4)        (the real Efull kernel; no 2*pi)
  Nas(x)    = (x/2pi)*log(x/2pi) - x/2pi + 7/8   (RVM asymptote)
  Rho(x)    = log(x/2pi)/(2pi)           (RVM density)
  Sm(g, t)  = 1/(g + t) - 2g/(g^2 + 1/4)
              - g/(g^2 + 1/4)^2          (smooth part of Ker')

Round-6 content:
  * W2K.kerTail       (K1, tail): the three case-free kernel terms.
  * W2K.kerHasDerivAt (K1): Ker'_g = 1/(g - t) + Sm(g, t),
      g != t, g + t > 0.  The log|g - t| term splits into the two
      neighborhood cases g > t / g < t (|u - t| equals u - t /
      t - u near g); the single formula 1/(g - t) is the same on
      either side.
  * W2K.nasHasDerivAt (K3): Nas'_x = Rho(x) EXACTLY,  x > 0.
  * W2K.rhoHasDerivAt : Rho'_x = 1/((2pi)*x),  x > 0.

Architecture (matched to the pinned mathlib 4.33.1 conclusions):
  * The pinned combinators state their conclusions in POINTWISE
    notation:  add -> (f + g),  mul -> (c * d),  sub -> (f - g),
    const_mul -> (fun y => c * d y),  div_const -> (fun x => c x / d),
    inv -> (c⁻¹),  log -> (fun y => log (f y)).  Every intermediate
    `have` therefore carries the EXACT conclusion type (unannotated
    inferences where the shape is only known after the fact), so no
    term ever fights the elaborator.
  * The named-def / lambda goal form is bridged at exactly ONE place
    per theorem:  HasDerivAt.congr_of_eventuallyEq (pinned
    Analysis/Calculus/Deriv/Basic.lean) against a neighborhood
    equality proved by  ext + dsimp + div_eq_mul_inv (in a field
    a / b reduces to a * b⁻¹) — the same "simpa using" spirit as
    mathlib's own combinator proofs (current online tree).
  * hasDerivAt_id' / hasDerivAt_const (point, c) / hasDerivAt_log
    are the pinned forms used throughout.

K4 (log-telescope) and the bound lemmas (E1-E4) land later.
-/
import Mathlib

open Real Filter
open scoped Topology

namespace W2K

/-- RVM smooth asymptote.  Domain x > 0. -/
noncomputable def Nas (x : ℝ) : ℝ :=
  (x / (2 * Real.pi)) * log (x / (2 * Real.pi)) - x / (2 * Real.pi) + 7 / 8

/-- RVM density.  Domain x > 0. -/
noncomputable def Rho (x : ℝ) : ℝ := log (x / (2 * Real.pi)) / (2 * Real.pi)

/-- The real Efull kernel in the variable g (parameter t).
    Domain: g + t > 0, g != t.  No 2*pi factor (it is not in the
    Efull kernel — 2*pi appears only in Nas/Rho). -/
noncomputable def Ker (g t : ℝ) : ℝ :=
  log |g - t| + log (g + t)
  - log (g * g + 1 / 4) + (1 / 2) / (g * g + 1 / 4)

/-- Smooth part of the kernel derivative. -/
noncomputable def Sm (g t : ℝ) : ℝ :=
  1 / (g + t) - 2 * g / (g * g + 1 / 4)
  - g / (g * g + 1 / 4) ^ 2

end W2K

open W2K

/-! ## K1: the kernel derivative decomposition -/

theorem W2K.kerTail (g t : ℝ) (hne : g ≠ t) (hpos : 0 < g + t)
    (hg2 : 0 < g * g + 1 / 4)
    (hlogabs : HasDerivAt (fun u : ℝ => log |u - t|) (1 / (g - t)) g) :
    HasDerivAt (fun u => Ker u t) (1 / (g - t) + Sm g t) g := by
  let fLin : ℝ → ℝ := (fun x : ℝ => x) + (fun _ : ℝ => t)
  have hlin : HasDerivAt fLin (1 + 0) g :=
    HasDerivAt.add (hasDerivAt_id' g) (hasDerivAt_const g t)
  let fLs : ℝ → ℝ := fun y => log (fLin y)
  have hfgLin : fLin g = g + t := by simp [fLin]
  have hlogsum : HasDerivAt fLs ((1 + 0) / (fLin g)) g :=
    hlin.log (by simpa [hfgLin] using ne_of_gt hpos)
  let fSqm : ℝ → ℝ := (fun x : ℝ => x) * (fun x : ℝ => x)
  have hmul := HasDerivAt.mul (hasDerivAt_id' g) (hasDerivAt_id' g)
  let fSqIn : ℝ → ℝ := fSqm + (fun _ : ℝ => 1 / 4)
  have hsqin := HasDerivAt.add hmul (hasDerivAt_const g (1 / 4))
  have hfgSq : fSqIn g = g * g + 1 / 4 := by simp [fSqIn, fSqm]
  let fLsq : ℝ → ℝ := fun z => log (fSqIn z)
  have hlogsq := hsqin.log (by simpa [hfgSq] using ne_of_gt hg2)
  let fInv2 : ℝ → ℝ := fSqIn⁻¹
  have hinv2 := HasDerivAt.inv hsqin (by simpa [hfgSq] using ne_of_gt hg2)
  let fInv : ℝ → ℝ := fun w => (1 / 2 : ℝ) * (fInv2 w)
  have hinv := HasDerivAt.const_mul (1 / 2 : ℝ) hinv2
  have hfinal := ((hlogabs.add hlogsum).sub hlogsq).add hinv
  let F : ℝ → ℝ := ((fun u : ℝ => log |u - t|) + fLs) - fLsq + fInv
  have hpoint : (fun u : ℝ => Ker u t) = F := by
    ext u
    dsimp only [Ker, F, fLs, fLsq, fInv, fInv2, fSqm, fSqIn, fLin]
    simp [div_eq_mul_inv]
  have heq : (fun u : ℝ => Ker u t) =ᶠ[𝓝 g] F := by
    simpa only [hpoint] using (EventuallyEq.refl (𝓝 g) (fun u : ℝ => Ker u t))
  exact (hfinal.congr_of_eventuallyEq heq).congr_deriv
    (by simp [Sm, fLin]; try field_simp [one_div, pow_two, hne, hpos.ne', hg2.ne']; try ring)

theorem W2K.kerHasDerivAt (g t : ℝ) (hne : g ≠ t)
    (hpos : 0 < g + t) :
    HasDerivAt (fun u => Ker u t) (1 / (g - t) + Sm g t) g := by
  have hg2 : 0 < g * g + 1 / 4 :=
    add_pos_of_nonneg_of_pos (by nlinarith) (by norm_num)
  by_cases hgt : g > t
  · have hsub : 0 < g - t := sub_pos.mpr hgt
    let fSub : ℝ → ℝ := (fun x : ℝ => x) - (fun _ : ℝ => t)
    have hlin : HasDerivAt fSub (1 - 0) g :=
      HasDerivAt.sub (hasDerivAt_id' g) (hasDerivAt_const g t)
    have hfg : fSub g = g - t := by simp [fSub]
    have hlogd : HasDerivAt (fun y : ℝ => log (fSub y)) ((1 - 0) / (fSub g)) g :=
      hlin.log (by simpa [hfg] using ne_of_gt hsub)
    have hsubd : HasDerivAt (fun y : ℝ => log (fSub y)) (1 / (g - t)) g :=
      hlogd.congr_deriv (by simp [fSub]; try field_simp [hsub.ne']; try ring)
    have heq : (fun u : ℝ => log |u - t|) =ᶠ[𝓝 g] (fun y : ℝ => log (fSub y)) := by
      filter_upwards [Ioi_mem_nhds hgt] with u hu
      rw [abs_of_pos (sub_pos.mpr hu)]
      simp [fSub]
    exact kerTail g t hne hpos hg2 ((heq.hasDerivAt_iff).mpr hsubd)
  · have hlt : g < t := lt_of_le_of_ne (not_lt.mp hgt) hne
    have hts : 0 < t - g := sub_pos.mpr hlt
    let fSub : ℝ → ℝ := (fun _ : ℝ => t) - (fun x : ℝ => x)
    have hlin : HasDerivAt fSub (0 - 1) g :=
      HasDerivAt.sub (hasDerivAt_const g t) (hasDerivAt_id' g)
    have hfg : fSub g = t - g := by simp [fSub]
    have hlogd : HasDerivAt (fun y : ℝ => log (fSub y)) ((0 - 1) / (fSub g)) g :=
      hlin.log (by simpa [hfg] using ne_of_gt hts)
    have hsubd : HasDerivAt (fun y : ℝ => log (fSub y)) (1 / (g - t)) g :=
      hlogd.congr_deriv (by simp [fSub]; try field_simp [hne, hts.ne']; try ring)
    have heq : (fun u : ℝ => log |u - t|) =ᶠ[𝓝 g] (fun y : ℝ => log (fSub y)) := by
      filter_upwards [Iio_mem_nhds hlt] with u hu
      rw [abs_sub_comm, abs_of_pos (sub_pos.mpr hu)]
      simp [fSub]
    exact kerTail g t hne hpos hg2 ((heq.hasDerivAt_iff).mpr hsubd)

/-! ## K3: the Nas / Rho derivatives -/

theorem W2K.twoPiPos : 0 < 2 * Real.pi :=
  mul_pos (by norm_num) (pi_pos : 0 < Real.pi)

theorem W2K.nasHasDerivAt (x : ℝ) (hpos : 0 < x) :
    HasDerivAt Nas (Rho x) x := by
  have hp : 0 < 2 * Real.pi := W2K.twoPiPos
  have hxp : 0 < x / (2 * Real.pi) := div_pos hpos hp
  let fDiv : ℝ → ℝ := fun x => (fun y : ℝ => y) x / (2 * Real.pi)
  have hdiv : HasDerivAt fDiv (1 / (2 * Real.pi)) x := (hasDerivAt_id' x).div_const (2 * Real.pi)
  have hlog : HasDerivAt (fun y : ℝ => log (fDiv y)) ((1 / (2 * Real.pi)) / (fDiv x)) x :=
    hdiv.log (ne_of_gt hxp)
  have hprod := HasDerivAt.mul hdiv hlog
  have hsub := HasDerivAt.sub hprod hdiv
  have hfinal := HasDerivAt.add hsub (hasDerivAt_const x (7 / 8))
  let fFin : ℝ → ℝ := (fDiv * (fun y : ℝ => log (fDiv y))) - fDiv + (fun _ : ℝ => 7 / 8)
  have hpoint : (fun u : ℝ => Nas u) = fFin := by
    ext u
    dsimp only [Nas, fDiv, fFin]
    simp [div_eq_mul_inv]
  have heq : (fun u : ℝ => Nas u) =ᶠ[𝓝 x] fFin := by
    simpa only [hpoint] using (EventuallyEq.refl (𝓝 x) (fun u : ℝ => Nas u))
  exact (hfinal.congr_of_eventuallyEq heq).congr_deriv
    (by simp [fDiv, Rho]; try field_simp [hp.ne', hpos.ne']; try ring)

theorem W2K.rhoHasDerivAt (x : ℝ) (hpos : 0 < x) :
    HasDerivAt Rho (1 / (2 * Real.pi * x)) x := by
  have hp : 0 < 2 * Real.pi := W2K.twoPiPos
  have hxp : 0 < x / (2 * Real.pi) := div_pos hpos hp
  let fDiv : ℝ → ℝ := fun x => (fun y : ℝ => y) x / (2 * Real.pi)
  have hdiv : HasDerivAt fDiv (1 / (2 * Real.pi)) x := (hasDerivAt_id' x).div_const (2 * Real.pi)
  have hlog : HasDerivAt (fun y : ℝ => log (fDiv y)) ((1 / (2 * Real.pi)) / (fDiv x)) x :=
    hdiv.log (ne_of_gt hxp)
  have hfinal := HasDerivAt.div_const hlog (2 * Real.pi)
  let fFin : ℝ → ℝ := fun u => (fun y : ℝ => log (fDiv y)) u / (2 * Real.pi)
  have hpoint : (fun u : ℝ => Rho u) = fFin := by
    ext u
    dsimp only [Rho, fDiv, fFin]
  have heq : (fun u : ℝ => Rho u) =ᶠ[𝓝 x] fFin := by
    simpa only [hpoint] using (EventuallyEq.refl (𝓝 x) (fun u : ℝ => Rho u))
  exact (hfinal.congr_of_eventuallyEq heq).congr_deriv
    (by simp [fDiv, Rho]; try field_simp [hp.ne', hpos.ne', hxp.ne']; try ring)
