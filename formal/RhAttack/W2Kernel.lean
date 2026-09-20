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

open Real Filter BigOperators
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

/-! ## K2: kernel monotonicity (the sign of Ker') -/

/-- (K2, crossed form, exact) For `0 < t < g`, the kernel derivative at g:
    `1/(g - t) + Sm (g t) = g * (2*(t^2 + 1/4)*(g^2 + 1/4) - (g^2 - t^2)) / ((g^2 - t^2)*(g^2 + 1/4)^2)`.
    The crossed difference expands to `2*t^2*g^2 - g^2/2 + (3/2)*t^2 + 1/8`
    (the plan's K2 note writes `2*t^2*g^2 + (3/2)*t^2 + 1/2`; the true expansion
    keeps the `-g^2/2` term, which is why the blanket above-claim needs a
    side condition; see `kerDerivPosAbove`). -/
theorem W2K.kerCrossed (g t : ℝ) (hne : g ≠ t) (hsum : 0 < g + t) :
    1 / (g - t) + Sm g t =
      g * (2 * (t^2 + 1/4) * (g^2 + 1/4) - (g^2 - t^2)) / ((g^2 - t^2) * (g^2 + 1/4) ^ 2) := by
  have hsub : g - t ≠ 0 := sub_ne_zero.mpr hne
  have hprod : g^2 - t^2 = (g - t) * (g + t) := by ring
  rw [Sm, hprod, show g * g + 1/4 = g^2 + 1/4 from by ring]
  field_simp [hsub, hsum.ne', show (g^2 + 1/4) ≠ 0 by positivity]
  ring

/-- (K2, sign, exact) For `0 < t < g`: Ker' > 0 iff the crossed inequality holds. -/
theorem W2K.kerDerivPosAboveCross (g t : ℝ) (ht : 0 < t) (hgt : t < g) :
    (0 < 1 / (g - t) + Sm g t) ↔ 2 * (t^2 + 1/4) * (g^2 + 1/4) > g^2 - t^2 := by
  have hpos_g : 0 < g := lt_trans ht hgt
  have hgq : 0 < g^2 - t^2 := by
    have hprod : g^2 - t^2 = (g - t) * (g + t) := by ring
    rw [hprod]
    exact mul_pos (sub_pos.mpr hgt) (add_pos hpos_g ht)
  have hD : 0 < (g^2 - t^2) * (g^2 + 1/4) ^ 2 :=
    mul_pos hgq (pow_pos (by positivity : 0 < g^2 + 1/4) 2)
  rw [W2K.kerCrossed g t (ne_of_gt hgt) (add_pos (lt_trans ht hgt) ht)]
  constructor
  · intro h
    rw [div_pos_iff] at h
    rcases h with (⟨hga, _⟩ | hneg)
    · exact sub_pos.mp (pos_of_mul_pos_right hga (le_of_lt hpos_g))
    · linarith [hD]
  · intro hcross
    exact div_pos (mul_pos hpos_g (sub_pos.mpr hcross)) hD

/-- (K2, above, sufficient condition) If `t^2 >= 1/2` (in particular for every t in
    the pinned zero bands) and `t < g`, then Ker' > 0. -/
theorem W2K.kerDerivPosAbove (g t : ℝ) (ht : 0 < t) (hgt : t < g) (ht2 : 1/2 ≤ t^2) :
    0 < 1 / (g - t) + Sm g t := by
  have hdiff : 2 * (t^2 + 1/4) * (g^2 + 1/4) - (g^2 - t^2) =
      g^2 * (2 * t^2 - 1/2) + (3/2) * t^2 + 1/8 := by ring
  have h2t2 : 0 ≤ 2 * t^2 - 1/2 := by nlinarith [ht2]
  have hterm : 0 ≤ g^2 * (2 * t^2 - 1/2) := mul_nonneg (sq_nonneg g) h2t2
  have hrem : 0 < (3/2) * t^2 + 1/8 := by positivity
  have hcrossed : 0 < 2 * (t^2 + 1/4) * (g^2 + 1/4) - (g^2 - t^2) := by
    rw [hdiff]
    linarith [hterm, hrem]
  exact (W2K.kerDerivPosAboveCross g t ht hgt).mpr (sub_pos.mp hcrossed)

/-- (K2, below) For `0 < g < t`, Ker' < 0 (unconditional). -/
theorem W2K.kerDerivNegBelow (g t : ℝ) (ht : 0 < t) (hpos_g : 0 < g) (hlt : g < t) :
    1 / (g - t) + Sm g t < 0 := by
  have hne : g ≠ t := hlt.ne
  have hsum : 0 < g + t := add_pos hpos_g ht
  rw [W2K.kerCrossed g t hne hsum]
  have hsq_lt : g^2 < t^2 := by nlinarith [ht, hpos_g, hlt]
  have hcross_pos : 2 * (t^2 + 1/4) * (g^2 + 1/4) - (g^2 - t^2) > 0 := by
    rw [show 2 * (t^2 + 1/4) * (g^2 + 1/4) - (g^2 - t^2) =
          2 * (t^2 + 1/4) * (g^2 + 1/4) + (t^2 - g^2) from by ring]
    exact add_pos (by positivity) (sub_pos.mpr hsq_lt)
  have hD : (g^2 - t^2) * (g^2 + 1/4)^2 < 0 := by
    have hneg : g^2 - t^2 < 0 := sub_neg.mpr hsq_lt
    have hpos4 : 0 < (g^2 + 1/4)^2 := pow_pos (by positivity : 0 < g^2 + 1/4) 2
    nlinarith [hneg, hpos4]
  rw [div_neg_iff]
  left
  exact ⟨mul_pos hpos_g hcross_pos, hD⟩

/-- Ker is continuous on any set where `u - t` and `u + t` never vanish
    (the `u*u + 1/4` denominator is always positive). -/
theorem W2K.kerContinuousOn (t : ℝ) {s : Set ℝ}
    (hs : ∀ u ∈ s, u - t ≠ 0 ∧ u + t ≠ 0) :
    ContinuousOn (fun u => Ker u t) s := by
  have hsub : ContinuousOn (fun u : ℝ => u - t) s :=
    ContinuousOn.sub continuousOn_id (continuousOn_const)
  have habs : ContinuousOn (fun u : ℝ => |u - t|) s :=
    (continuous_abs.continuousOn (s := Set.univ)).comp hsub (fun _ _ => trivial)
  have habsnz : ∀ u ∈ s, |u - t| ≠ 0 := fun u hu =>
    (abs_pos.2 ((hs u hu).1)).ne'
  have hlogA : ContinuousOn (fun u : ℝ => Real.log |u - t|) s :=
    ContinuousOn.log habs habsnz
  have hadd : ContinuousOn (fun u : ℝ => u + t) s :=
    ContinuousOn.add continuousOn_id (continuousOn_const)
  have haddnz : ∀ u ∈ s, u + t ≠ 0 := fun u hu => (hs u hu).2
  have hlogB : ContinuousOn (fun u : ℝ => Real.log (u + t)) s :=
    ContinuousOn.log hadd haddnz
  have hsq : ContinuousOn (fun u : ℝ => u * u + 1/4) s :=
    (ContinuousOn.mul continuousOn_id continuousOn_id).add (continuousOn_const)
  have hsqnz : ∀ u ∈ s, u * u + 1/4 ≠ 0 := fun u _ => by
    have h : 0 < u * u + 1/4 := by
      rw [show u * u = u^2 from by ring]
      positivity
    exact h.ne'
  have hlogC : ContinuousOn (fun u : ℝ => Real.log (u * u + 1/4)) s :=
    ContinuousOn.log hsq hsqnz
  have hinv : ContinuousOn (fun u : ℝ => (u * u + 1/4)⁻¹) s :=
    ContinuousOn.inv₀ hsq hsqnz
  have hfinv : ContinuousOn (fun u : ℝ => (1/2 : ℝ) * (u * u + 1/4)⁻¹) s :=
    ContinuousOn.const_mul hinv (1/2)
  have hKer : (fun u => Ker u t) =
      (fun u => Real.log |u - t| + Real.log (u + t)) -
        (fun u => Real.log (u * u + 1/4)) + (fun u => (1/2) * (u * u + 1/4)⁻¹) := by
    funext u
    simp [Ker, div_eq_mul_inv]
  rw [hKer]
  exact (hlogA.add hlogB).sub hlogC |>.add hfinv

/-- (K2, above, continuous) If `t^2 >= 1/2`, the kernel is strictly increasing
    on (t, infinity) — in particular on (t, G2]. -/
theorem W2K.kerStrictMonoAbove (t : ℝ) (ht : 0 < t) (ht2 : 1/2 ≤ t^2) :
    StrictMonoOn (fun u => Ker u t) (Set.Ioi t) := by
  apply strictMonoOn_of_deriv_pos (convex_Ioi t)
  · exact W2K.kerContinuousOn t (fun u hu =>
      ⟨(by nlinarith [Set.mem_Ioi.mp hu] : 0 < u - t).ne',
       (by nlinarith [Set.mem_Ioi.mp hu, ht] : 0 < u + t).ne'⟩)
  · intro x hx
    rw [interior_Ioi] at hx
    have hlt : t < x := Set.mem_Ioi.mp hx
    have hder : deriv (fun u => Ker u t) x = 1 / (x - t) + Sm x t :=
      (W2K.kerHasDerivAt x t (ne_of_gt hlt) (by nlinarith [hlt, ht])).deriv
    rw [hder]
    exact W2K.kerDerivPosAbove x t ht hlt ht2

/-- (K2, below, continuous) The kernel is strictly decreasing on (0, t). -/
theorem W2K.kerStrictAntiBelow (t : ℝ) (ht : 0 < t) :
    StrictAntiOn (fun u => Ker u t) (Set.Ioo 0 t) := by
  apply strictAntiOn_of_deriv_neg (convex_Ioo 0 t)
  · exact W2K.kerContinuousOn t (fun u hu =>
      ⟨(by nlinarith [hu.1, hu.2] : u - t < 0).ne,
       (by nlinarith [hu.1, ht] : 0 < u + t).ne'⟩)
  · intro x hx
    rw [interior_Ioo] at hx
    have hder : deriv (fun u => Ker u t) x = 1 / (x - t) + Sm x t :=
      (W2K.kerHasDerivAt x t (hx.2.ne) (add_pos hx.1 ht)).deriv
    rw [hder]
    exact W2K.kerDerivNegBelow x t ht hx.1 hx.2

/-! ## K4: the range and log telescopes -/

/-- Range telescope: sum of forward differences over range n. -/
theorem W2K.sumRangeTel (q : ℕ → ℝ) (n : ℕ) :
    (∑ j ∈ Finset.range n, (q (j + 1) - q j)) = q n - q 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    ring

/-- Reversed range telescope. -/
theorem W2K.sumRangeTelRev (q : ℕ → ℝ) (n : ℕ) :
    (∑ j ∈ Finset.range n, (q j - q (j + 1))) = q 0 - q n := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [Finset.sum_range_succ, ih]
    ring

/-- (K4) Log telescope: for a partition x_0 ... x_M, the log-differences
    against the pole t telescope to the endpoint difference. -/
theorem W2K.logTelescope (M : ℕ) (x : ℕ → ℝ) (t : ℝ) :
    (∑ j ∈ Finset.range M, (Real.log |x (j + 1) - t| - Real.log |x j - t|)) =
      Real.log |x M - t| - Real.log |x 0 - t| :=
  W2K.sumRangeTel (fun j : ℕ => Real.log |x j - t|) M
