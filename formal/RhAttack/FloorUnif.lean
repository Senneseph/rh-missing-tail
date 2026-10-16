import Mathlib
import RhAttack.B4
import RhAttack.B5
import RhAttack.S4Own
import RhAttack.S1LowT
import RhAttack.S4Asm
import RhAttack.Z78P12

open Real Set B0 P12

/-!
**FloorUnif — the floor-unification bridge: the S2 own-detector
and the S4 own-mass are the SAME quantity.**

The program carried two notations of the four off-line zero
product at the height of its own pole:
  S2 side (B5):  poff (γ δ t) = Π_j fac (rho*_j (γ δ)) (sLine t)
                 with fac (ρ s) = (1 − s/ρ) exp (s/ρ),
                 rhoPP/PM/NP/NM = 1/2 ± δ ± iγ;
  S4 side (S4O): ownKer (t d) = Π_j (1 − S t / z_j) exp (S t / z_j)
                 with z1..z4 = 1/2 ± d ± it, S t = 1/2 + it.
These are the SAME product under the renamings z1 = rhoPP,
z2 = rhoPM, z3 = rhoNP, z4 = rhoNM, S t = sLine t, hence

    ||poff (t d t)|| = ownKer (t d) = mown (t d)

(the last equality = hMownProd).  On the covered strip band
(1000 <= t, 0 < d <= 1/2) the unified S2 floor

    floStripMin (t d) = min (||poff (t d t)||, max (floWin t, 0))

collapses to the S4 own-mass itself, because the window term
floWin t sits at its cap 23/1000 there and mown t d is bounded
by (4 d²/t²)(1 + 1/(16 t²)) exp (1/t²) (hMownScale) which is
< 3.000003e-6 < 23/1000 on the band.

CONSEQUENCE (s4StripUnifiedFloor): on the covered strip region
(1000 <= t, 1/200 <= d <= 1/2) the PROVEN covered squeeze
(s4asm_strip_region_S4, the t^4 wire) holds against the
UNIFIED P1.2 floor floStripMin — the SAME floor that the S2
leg proves devStripMin dominates (s2_strip_min).  The low-
band and high-band S4 floors are one function on their common
strip domain; the floor mismatch that kept the two bands'
reductions separate is closed.  The window branch (d < 1/200)
is UNCHANGED: there the own-mass scale ~ 4d²/t² vanishes with
d and the proven squeeze is the d-independent one against the
near pin — the named S4 blind-spot territory (day029 reading:
not closure-relevant below the certified edge d* =
0.0047384091).

Also: s2ActualFullBand — S2 for the actual set with NO upper
cap on the height: the atoms s2_strip_min have no t0 cap
(c1b_disc_floor / p9_poff_own_height_pos hold for all gamma
>= 707/50), the sliver part is the data vacuity
(sliverOffPairsEmpty, Z78P12).

Honesty: LEAN-PROVEN (this file); no new data; no RH claim.
Lean 4.33.1 / mathlib v4.33.1 (pinned).
-/

namespace FUnif

open S4O S1LowT

/- Data gates (Float world; the Real forms carry the
   theorems): the band edge, the certified mown cap on the
   band, the window-floor cap, and the margin between. -/
def bandLoT : Float := 1000
def mownCapBand : Float := 0.0006
def floWinCapVal : Float := 0.023
#eval bandLoT
#eval mownCapBand < floWinCapVal
#eval floWinCapVal - mownCapBand

/-- The S4 direct kernel as a COMPLEX product (the body of
    ownKer under its norm). -/
@[reducible] noncomputable def ownKerC (t d : ℝ) : ℂ :=
    (1 - S t / z1 t d) * Complex.exp (S t / z1 t d) *
    (1 - S t / z2 t d) * Complex.exp (S t / z2 t d) *
    (1 - S t / z3 t d) * Complex.exp (S t / z3 t d) *
    (1 - S t / z4 t d) * Complex.exp (S t / z4 t d)

/-- (PROVEN)  ownKer is the norm of its complex body. -/
theorem ownKerIsNorm (t d : ℝ) : ownKer t d = ‖ownKerC t d‖ := by
  dsimp only [ownKer, ownKerC]

/-- (PROVEN)  the S2 factor product at its own height equals
    the S4 direct kernel body: same four factors
    (1 − s/ρ) exp (s/ρ), same four zeros {1/2 ± d ± it}
    (rhoPP/PM/NP/NM = z1/z2/z3/z4, sLine t = S t). -/
theorem poffIsOwnKerC (t d : ℝ) : poff t d t = ownKerC t d := by
  dsimp only [poff, fac, ownKerC]
  have hhalf : halfR = (1 / 2 : ℝ) := by
    dsimp only [halfR]
    norm_num
  have hz1 : rhoPP t d = z1 t d := by
    dsimp only [rhoPP, z1]
    rw [hhalf]
    apply Complex.ext
    · simp
      try ring
    · simp
      try ring
  have hz2 : rhoPM t d = z2 t d := by
    dsimp only [rhoPM, z2]
    rw [hhalf]
    apply Complex.ext
    · simp
      try ring
    · simp
      try ring
  have hz3 : rhoNP t d = z3 t d := by
    dsimp only [rhoNP, z3]
    rw [hhalf]
    apply Complex.ext
    · simp
      try ring
    · simp
      try ring
  have hz4 : rhoNM t d = z4 t d := by
    dsimp only [rhoNM, z4]
    rw [hhalf]
    apply Complex.ext
    · simp
      try ring
    · simp
      try ring
  have hs : sLine t = S t := by
    dsimp only [sLine, S]
    rw [hhalf]
  rw [hz1, hz2, hz3, hz4, hs]
  ring

/-- (PROVEN)  the S2 own detector IS the S4 own mass. -/
theorem poffOwnMass (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d ≤ 1 / 2) :
    ‖poff t d t‖ = mown t d := by
  rw [poffIsOwnKerC]
  rw [← ownKerIsNorm t d]
  exact hMownProd t d ht hd0 hd

/-- (PROVEN)  on the covered band (1000 <= t) the window floor
    sits at its cap: floWin t = 23/1000 > 0 (since
    1 − 25/t >= 1 − 25/1000 = 237/250). -/
theorem floWinCap (t : ℝ) (ht : 1000 ≤ t) :
    floWin t = 23 / 1000 ∧ 0 < floWin t := by
  have htp : 0 < t := by linarith
  have h1 : (1 : ℝ) / t ≤ (1 : ℝ) / 1000 :=
    (one_div_le_one_div htp (by norm_num : (0 : ℝ) < 1000)).mpr ht
  have h25 : 25 / t ≤ (25 : ℝ) / 1000 := by
    rw [show (25 / t = (25 : ℝ) * (1 / t)) by ring,
        show (25 : ℝ) / 1000 = (25 : ℝ) * (1 / 1000) by ring]
    exact mul_le_mul_of_nonneg_left h1 (by norm_num : (0 : ℝ) ≤ 25)
  have hflo : (23 : ℝ) / 1000 ≤ 1 - 25 / t := by
    nlinarith [h25]
  have heq : floWin t = (23 : ℝ) / 1000 := by
    rw [floWin]
    rw [show min (23 / 1000 : ℝ) (1 - 25 / t) = (23 : ℝ) / 1000 from
      (min_eq_left_iff).mpr hflo]
  rw [heq]
  exact ⟨rfl, by norm_num⟩

/-- (PROVEN)  the own-mass is strictly below the window-floor
    cap on the covered band: mown (t d) < 23/1000.  Chain:
      mown <= (4d²/t²)(1 + 1/(16t²)) exp (1/t²)   [hMownScale]
           <= (1/t²)·(2)·(3) = 6/t²                [4d² <= 1,
                  1+1/(16t²) <= 2, exp (1/t²) <= 3]
           <= 6/10000 = 6e-4  <  23/1000. -/
theorem mownBelowFloWinCap (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hd : d ≤ 1 / 2) : mown t d < floWin t := by
  have htp : 0 < t := by linarith
  have hscale := hMownScale t d htp hd0 hd
  have ht2 : (1000000 : ℝ) ≤ t ^ 2 := by nlinarith [sq_nonneg t]
  have h4d : 4 * d ^ 2 ≤ (1 : ℝ) := by
    have h2d : 0 ≤ 2 * d := by nlinarith
    have h2d' : 2 * d ≤ 1 := by linarith
    have hsq : (2 * d) ^ 2 ≤ 1 := by
      calc (2 * d) ^ 2 ≤ 1 * (2 * d) := by
            nlinarith [h2d, h2d']
        _ ≤ 1 := by nlinarith [h2d, h2d']
    nlinarith [hsq]
  have hA : (1 : ℝ) + 1 / (16 * t ^ 2) ≤ 2 := by
    have hx : 1 / (16 * t ^ 2) ≤ 1 := by
      rw [div_le_one (by positivity : 0 < 16 * t ^ 2)]
      nlinarith
    linarith
  have hB : Real.exp (1 / t ^ 2) ≤ 3 := by
    have hle : 1 / t ^ 2 ≤ 1 := by
      rw [div_le_one (sq_pos_of_pos htp)]
      nlinarith
    exact le_trans (Real.exp_le_exp.mpr hle) (le_of_lt Real.exp_one_lt_three)
  have hnum : 4 * d ^ 2 * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2) ≤ 6 := by
    calc 4 * d ^ 2 * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)
        ≤ 4 * d ^ 2 * 2 * Real.exp (1 / t ^ 2) := by
          exact mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hA (by nlinarith : 0 ≤ 4 * d ^ 2))
            (le_of_lt (Real.exp_pos _))
        _ = 8 * d ^ 2 * Real.exp (1 / t ^ 2) := by ring
        _ ≤ 8 * d ^ 2 * 3 := by
          exact mul_le_mul_of_nonneg_left hB (by nlinarith : 0 ≤ 8 * d ^ 2)
        _ = 24 * d ^ 2 := by ring
        _ ≤ 24 * (1 / 4 : ℝ) := by
          exact mul_le_mul_of_nonneg_left
            (by nlinarith [h4d] : d ^ 2 ≤ 1 / 4) (by norm_num : (0 : ℝ) ≤ 24)
        _ = 6 := by norm_num
  have hhring : (4 * d ^ 2 / t ^ 2) * (1 + 1 / (16 * t ^ 2)) *
      Real.exp (1 / t ^ 2) =
      (4 * d ^ 2 * (1 + 1 / (16 * t ^ 2)) * Real.exp (1 / t ^ 2)) / t ^ 2 := by
    field_simp
    <;> ring
  have htop : mown t d ≤ (6 : ℝ) / 10000 := by
    have hright := hscale.2
    rw [hhring] at hright
    have hstep1 : (4 * d ^ 2 * (1 + 1 / (16 * t ^ 2)) * Real.exp
        (1 / t ^ 2)) / t ^ 2 ≤ (6 : ℝ) / t ^ 2 := by
      exact div_le_div_of_nonneg_right hnum (by nlinarith : 0 ≤ t ^ 2)
    have hstep2 : (6 : ℝ) / t ^ 2 ≤ (6 : ℝ) / 10000 := by
      exact div_le_div_of_nonneg_left (by norm_num : 0 ≤ (6 : ℝ))
        (by norm_num : (0 : ℝ) < 10000)
        (le_trans (by norm_num : (10000 : ℝ) ≤ 1000000) ht2)
    exact le_trans hright (le_trans hstep1 hstep2)
  have hflo := floWinCap t ht
  calc mown t d
       _ ≤ (6 : ℝ) / 10000 := htop
       _ < (23 : ℝ) / 1000 := by norm_num
       _ = floWin t := hflo.1.symm

/-- (PROVEN)  the unified floor: on the covered band the S2
    floor function floStripMin equals the S4 own-mass. -/
theorem floStripMin_eq_mownOnBand (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d)
    (hd : d ≤ 1 / 2) :
    S1LowT.floStripMin t d = mown t d := by
  have hhm : 0 < t := by linarith
  rw [S1LowT.floStripMin, poffOwnMass t d hhm hd0 hd]
  have hflo := floWinCap t ht
  have hmax : max (floWin t) 0 = floWin t := by
    rw [max_eq_left hflo.2.le]
  rw [hmax]
  exact min_eq_left (le_of_lt (mownBelowFloWinCap t d ht hd0 hd))

/-- (PROVEN)  the covered strip squeeze in the UNIFIED P1.2
    floor form: on 1000 <= t, 1/200 <= d <= 1/2, the concrete
    residue wires satisfy  BwireR + MrR + MfR < floStripMin —
    the same floor the S2 leg proves devStripMin dominates
    (s2_strip_min).  The two bands now share one floor. -/
theorem s4StripUnifiedFloor (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2) :
    S4A.BwireR t0 d0 + S4A.MrR t0 d0 + S4A.MfR (t0, d0) <
        S1LowT.floStripMin t0 d0 := by
  have hown : 1000 ≤ t0 ∧ d0 ≤ 1 / 2 := ⟨ht0, hd⟩
  rw [floStripMin_eq_mownOnBand t0 d0 ht0 (by linarith) hd]
  dsimp only [S4A.BwireR, S4A.MrR, S4A.MfR]
  rw [if_pos hown, if_pos hdlo, if_pos hown, if_pos hdlo, add_zero]
  exact S4A.s4asm_strip_region_S4 t0 d0 ht0 hdlo hd

/-- (PROVEN)  S2 for the actual set on the FULL band
    (0 < t0 — no upper cap, 0 < d0 <= 1/2): the concrete
    detector devStripMin dominates the concrete floor
    floStripMin.  Regimes: t0 >= 707/50 — the PROVEN
    s2_strip_min (C1b window atom + C1a own-height atom,
    edge d0 = 1/2 included; both atoms have no t0 cap);
    the sliver t0 < 707/50 — vacuous under the named on-line
    record (Z78P12.sliverOffPairsEmpty). -/
theorem s2ActualFullBand (q : ZeroSet)
    (honline : ∀ ρ ∈ q.Z, 0 < (|ρ.im| : ℝ) → (|ρ.im| : ℝ) <
      (707 : ℝ) / 50 → ρ.re = 1 / 2)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hd0u : d0 ≤ 1 / 2)
    (hp : P12.offPair q t0 d0) :
    S1LowT.devStripMin t0 d0 ≥ S1LowT.floStripMin t0 d0 := by
  by_cases hsliver : t0 < (707 : ℝ) / 50
  · exact False.elim (
      Z78P12.sliverOffPairsEmpty q honline t0 d0 ht0 hsliver hd0 hd0u hp)
  · exact S1LowT.s2_strip_min t0 d0 (by linarith) hd0 hd0u

end FUnif
