/-
S4WinGate.lean — 0243/25ac: the PART C GATE at face height (window slice).

CONTEXT (authoritative, in-tree):
  * The B22 terminal face (RHEnd.rh_program78_stripfront_mach_unifiedPosReserve_PT2)
    is the single residual
        hOffCPT2 :  forall t0 >= WinC.tPT2, 0 < d0 <= Z78PosReserve.posReserveD0max,
                    ~ offPair q t0 d0
    with WinC.tPT2 = 3000175332800 and the EIGHTH record covering
    d0 > posReserveD0max = 0.3733819666133.  The face splits into a BAND slice
    [1/200, posReserveD0max] (all squeeze legs in body + the E1 data clause)
    and a WINDOW slice (0, 1/200).
  * The WINDOW slice is the "Part C gate" of the RHEnd docstring: the in-tree
    window wire (25ab/25ae/25af: the 13t/8 and nGrow = floor(t^2) schedules)
    is pinned below the NEAR PIN 0.9975, while the UNIFIED S2 floor there is
    S1LowT.floStripMin — the gap between the two is the bound-level residue
    (the hWin hypothesis of the endpoint).
  * The day058 sweep (scripts/rh/day058_partC_gate.py REV2,
    out_day058_partC_gate.txt, closed forms at 60 dps) established, with the
    exact evaluation point s = B4.sLine t = 1/2 + i t:
      floor(t, d) = |B5.pown(t, d, t)|
          = d^2 (d^2 + 4 t^2) e^{C(t,d)} / ((a^2+t^2)(b^2+t^2)),
        a = 1/2+d, b = 1/2-d,
        C(t,d) = a/(a^2+t^2) + b/(b^2+t^2)  (>= 0),
      i.e. floor ~ 4 d^2 e^{1/t^2} / t^2, CONTINUOUS with the band floor
      (mown) across d = 1/200 — as the unified-FloorUnif architecture
      requires — and VANISHING as d -> 0.
  * Consequences (measured, 60 dps):
      (i)  NO non-d-dependent wire can close the window S4 leg uniformly in
           0 < d < 1/200 at face height (floor -> 0 beats every fixed wire);
           the near-line slice (0, d*) with d* ~= sqrt(A1/4) ~= 4.7384e-3 is
           bound-level OPEN BY STRUCTURE (the data/pointwise territory, like
           the E1 clause rows).
      (ii) The machine's BAND schedule n4(t) = ceil(3.1e7 t^4) — already the
           in-tree band wire (S4Asm) with the 25af pin WIRE <= (A1 +
           (A2+A3+25e-15)e-3) t^-2, A1 = 8981/10^8 — DOES close the window S4
           leg on the d-substrip d >= 1/210 (pin margin 0.97%, sharp 1.0%;
           at d = 1/200 the margin is 11.35%), T-independently (both sides
           are pure t^-2).
      (iii) The current in-tree window wire (nGrow = floor(t^2),
           WIRE ~ 1/2 t^-1) misses the floor by ~ t/(8 d^2) (at tPT2,
           d = 1/200: ~1.5e16; DIVERGING in t) — the quantified Part C gap.
  WHAT THIS FILE PINS (bound level; the 25af wire pins are REUSED, not
      re-derived):
      S0  the exact pair-factor magnitude at s = 1/2 + i t (S0).
      S1  the window-floor factorization + the lower/upper estimates that
          identify floStripMin = |pown| on the window at face height.
      S2  THE GATE (theorem partCgate_n4):  for t >= WinC.tPT2 and
          1/210 <= d < 1/200,
            p8_B t (n4 t) + Zbound t * exp (X4fun t) * X4fun t
                < S1LowT.floStripMin t d
          i.e. under the n4 schedule the strip wire is strictly below the
          unified S2 floor on the window slice [1/210, 1/200).
  HONESTY (locked): bound-level machine-wire arithmetic on the closed forms
      of B5, P8Floor, S4Strip/S4Growth, S1LowT, S4W.  No zeta evaluation, no
      zero existence, no RH claim.  This does NOT yet rewire the endpoint:
      the in-tree window wire in S4Asm is still the 13t/8/nGrow family; the
      next step (B23 window wiring) consumes this gate by switching the
      window branch to the n4 schedule for t >= tPT2, closing the window S4
      leg on [1/210, 1/200) and leaving the near-line slice (0, 1/210) as
      the data/pointwise territory.  No RH claim.
-/
import Mathlib
import RhAttack.B4
import RhAttack.B5
import RhAttack.S1LowT
import RhAttack.S4Window
import RhAttack.S4Strip
import RhAttack.P8Floor
import RhAttack.WinCount

namespace S4WG
open Real
open Complex

/- =================================================================
   §0  the pair-factor lemma (the conjugate pair at s = 1/2 + i t, exact)
   ================================================================= -/

/-- For δ with 0 < 1/2 + δ and t > 0: the product of the two canonical
    factors at the conjugate zeros {1/2 + δ + i t, 1/2 + δ - i t}, evaluated
    at s = 1/2 + i t (the B4.sLine reference point), has magnitude
        |δ| * sqrt(δ^2 + 4 t^2) * e^{(1/2+δ)/((1/2+δ)^2 + t^2)} / ((1/2+δ)^2 + t^2).
    The offset |δ| is the horizontal distance of the zero from the critical
    line.  The zero real part is written in the flat complex form (the
    elaborated shape of B5.rhoPP/rhoPM — 1/2 and the offset are separate
    coerced summands), so the lemma applies directly to poffExpand. -/
theorem pairfac_norm (δ t : ℝ) (hδ0 : 0 < (1 / 2 : ℝ) + δ) (ht : 0 < t) :
    ‖fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
       fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
    |δ| * Real.sqrt (δ ^ 2 + 4 * t ^ 2) *
      Real.exp ((1 / 2 + δ) / ((1 / 2 + δ) ^ 2 + t ^ 2)) / ((1 / 2 + δ) ^ 2 + t ^ 2) := by
  -- All identity steps on complex terms go through Complex.ext + simp + ring:
  -- the simp list collapses every coerced atom to a real, where ring works.
  -- (The elab push-in of `(... : ℂ)` ascriptions breaks naive simp/rw on
  -- .re/.im projections — this layout never hits them.)
  set c : ℝ := (1 / 2 : ℝ) + δ
  set s : ℂ := ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I with hs
  set r1 : ℂ := (c : ℂ) + (t : ℂ) * I with hr1
  set r2 : ℂ := (c : ℂ) + Complex.ofReal (-(t : ℝ)) * I with hr2
  set D : ℝ := c ^ 2 + t ^ 2
  have hc : 0 < c := by
    dsimp only [c]
    exact hδ0
  have hDnz : 0 < D := by
    dsimp only [D]
    nlinarith [sq_pos_of_pos ht, sq_nonneg c]
  have hr1nz : r1 ≠ 0 := by
    intro h
    rw [hr1, Complex.ext_iff] at h
    simp only [Complex.add_re, Complex.sub_re, Complex.add_im, Complex.sub_im,
        Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im] at h
    norm_num at h
    nlinarith [h.1, hc, ht]
  have hr2nz : r2 ≠ 0 := by
    intro h
    rw [hr2, Complex.ext_iff] at h
    simp only [Complex.add_re, Complex.sub_re, Complex.add_im, Complex.sub_im,
        Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im] at h
    norm_num at h
    nlinarith [h.1, hc, ht]
  -- The flat zeros from the statement are exactly r1 / r2.
  have hb1 : ((1 / 2 : ℝ) : ℂ) + (δ : ℂ) + (t : ℂ) * I = r1 := by
    rw [show ((1 / 2 : ℝ) : ℂ) + (δ : ℂ) = (c : ℂ) from (Complex.ofReal_add (1 / 2 : ℝ) δ).symm]
  have hb2 : ((1 / 2 : ℝ) : ℂ) + (δ : ℂ) - (t : ℂ) * I = r2 := by
    rw [show ((1 / 2 : ℝ) : ℂ) + (δ : ℂ) = (c : ℂ) from (Complex.ofReal_add (1 / 2 : ℝ) δ).symm,
        show (c : ℂ) - (t : ℂ) * I = (c : ℂ) + Complex.ofReal (-(t : ℝ)) * I by
          apply Complex.ext
          · simp only [Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.ofReal_re,
              Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
              Complex.I_re, Complex.I_im]
            ring
          · simp only [Complex.add_im, Complex.sub_im, Complex.mul_re, Complex.mul_im,
              Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
              Complex.I_re, Complex.I_im]
            ring]
  -- step 0: unfold fac.
  have hstep0 :
      ‖fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
      ‖(1 - s / r1) * (1 - s / r2) * (Complex.exp (s / r1) * Complex.exp (s / r2))‖ := by
    unfold fac
    rw [hb1, hb2]
    rw [show ((1 - s / r1) * Complex.exp (s / r1)) *
            ((1 - s / r2) * Complex.exp (s / r2)) =
        (1 - s / r1) * (1 - s / r2) * (Complex.exp (s / r1) * Complex.exp (s / r2)) by ring]
  -- normSq denominators (normSq lemmas match raw-coerced terms).
  have hnsq1 : Complex.normSq r1 = D := by
    rw [hr1, Complex.normSq_add_mul_I c t]
  have hnsq2 : Complex.normSq r2 = D := by
    rw [hr2, Complex.normSq_add_mul_I c (-(t : ℝ))]
    ring
  -- pole norms.
  have hnr1 : ‖r1‖ = Real.sqrt (c ^ 2 + t ^ 2) := by
    rw [hr1, Complex.norm_def, Complex.normSq_add_mul_I c t]
  have hnr2 : ‖r2‖ = Real.sqrt (c ^ 2 + t ^ 2) := by
    rw [hr2, Complex.norm_def, Complex.normSq_add_mul_I c (-(t : ℝ))]
    rw [show c ^ 2 + (-(t : ℝ)) ^ 2 = c ^ 2 + t ^ 2 by ring]
  -- re / im of s / r1 + s / r2 : pure real arithmetic via div_re / div_im.
  have hre_sum : (s / r1 + s / r2).re = c / D := by
    rw [Complex.add_re, Complex.div_re s r1, Complex.div_re s r2, hnsq1, hnsq2,
        hs, hr1, hr2]
    simp only [Complex.add_re, Complex.sub_re, Complex.add_im, Complex.sub_im,
        Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
    ring
  have him_sum : (s / r1 + s / r2).im = 2 * c * t / D := by
    rw [Complex.add_im, Complex.div_im s r1, Complex.div_im s r2, hnsq1, hnsq2,
        hs, hr1, hr2]
    simp only [Complex.add_im, Complex.add_re, Complex.sub_im, Complex.sub_re,
        Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
    ring
  -- zero-to-line distances.
  have hdiff1 : r1 - s = Complex.ofReal (c - 1 / 2 : ℝ) := by
    rw [hr1, hs]
    apply Complex.ext
    · simp only [Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.ofReal_re,
        Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
    · simp only [Complex.add_im, Complex.sub_im, Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
  have hdiff2 : r2 - s = Complex.ofReal (c - 1 / 2 : ℝ) - Complex.ofReal (2 * t : ℝ) * I := by
    rw [hr2, hs]
    apply Complex.ext
    · simp only [Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.ofReal_re,
        Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
    · simp only [Complex.add_im, Complex.sub_im, Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
  have hnr1m : ‖r1 - s‖ = |c - 1 / 2| := by
    rw [hdiff1, Complex.norm_def, Complex.normSq_ofReal, Real.sqrt_mul_self_eq_abs]
  have hneg : Complex.ofReal (c - 1 / 2 : ℝ) - Complex.ofReal (2 * t : ℝ) * I =
      Complex.ofReal (c - 1 / 2 : ℝ) + Complex.ofReal (-(2 * t : ℝ)) * I := by
    apply Complex.ext
    · simp only [Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.ofReal_re,
        Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
    · simp only [Complex.add_im, Complex.sub_im, Complex.mul_re, Complex.mul_im,
        Complex.ofReal_re, Complex.ofReal_im, Complex.neg_re, Complex.neg_im,
        Complex.I_re, Complex.I_im]
      ring
  have hnr2m : ‖r2 - s‖ = Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) := by
    rw [hdiff2, hneg, Complex.norm_def,
        Complex.normSq_add_mul_I (c - 1 / 2) (-(2 * t : ℝ))]
    rw [show (c - 1 / 2) ^ 2 + (-(2 * t : ℝ)) ^ 2 = (c - 1 / 2) ^ 2 + 4 * t ^ 2 by ring]
  -- norms of the (1 − s/r) factors.
  have hnm1 : ‖1 - s / r1‖ = |c - 1 / 2| / Real.sqrt (c ^ 2 + t ^ 2) := by
    rw [show 1 - s / r1 = (r1 - s) / r1 by field_simp [hr1nz], norm_div, hnr1m, hnr1]
  have hnm2 : ‖1 - s / r2‖ =
      Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) / Real.sqrt (c ^ 2 + t ^ 2) := by
    rw [show 1 - s / r2 = (r2 - s) / r2 by field_simp [hr2nz], norm_div, hnr2m, hnr2]
  -- norm of the exp pair.
  have hexp_norm : ‖Complex.exp (s / r1) * Complex.exp (s / r2)‖ =
      Real.exp (c / (c ^ 2 + t ^ 2)) := by
    rw [← Complex.exp_add, Complex.norm_exp, hre_sum]
  -- assemble the product norm.
  have hprod_norm :
      ‖(1 - s / r1) * (1 - s / r2) * (Complex.exp (s / r1) * Complex.exp (s / r2))‖ =
        |c - 1 / 2| * Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) *
        Real.exp (c / (c ^ 2 + t ^ 2)) / (c ^ 2 + t ^ 2) := by
    calc ‖(1 - s / r1) * (1 - s / r2) * (Complex.exp (s / r1) * Complex.exp (s / r2))‖
      = ‖(1 - s / r1) * (1 - s / r2)‖ * ‖Complex.exp (s / r1) * Complex.exp (s / r2)‖ := by
          rw [norm_mul]
      _ = (|c - 1 / 2| / Real.sqrt (c ^ 2 + t ^ 2)) *
          (Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) / Real.sqrt (c ^ 2 + t ^ 2)) *
          Real.exp (c / (c ^ 2 + t ^ 2)) := by
          rw [norm_mul, hnm1, hnm2, hexp_norm]
      _ = |c - 1 / 2| * Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) *
          Real.exp (c / (c ^ 2 + t ^ 2)) / (c ^ 2 + t ^ 2) := by
          have hsqD : Real.sqrt (c ^ 2 + t ^ 2) * Real.sqrt (c ^ 2 + t ^ 2) =
              c ^ 2 + t ^ 2 := by
            rw [show (Real.sqrt (c ^ 2 + t ^ 2)) * (Real.sqrt (c ^ 2 + t ^ 2)) =
                    (Real.sqrt (c ^ 2 + t ^ 2)) ^ 2 by ring,
                Real.sq_sqrt (le_of_lt (by nlinarith [sq_pos_of_pos ht, sq_nonneg c]))]
          field_simp [hDnz.ne']
          rw [show (Real.sqrt (c ^ 2 + t ^ 2)) ^ 2 = c ^ 2 + t ^ 2 by
                rw [Real.sq_sqrt (le_of_lt (by nlinarith [sq_pos_of_pos ht, sq_nonneg c]))]]
          <;> ring
  -- bridge c / (c^2 + t^2) to the flat (1/2 + δ) form.
  have hc3 : c - 1 / 2 = δ := by
    dsimp only [c]
    ring
  calc ‖fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) + (δ : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖
    = ‖(1 - s / r1) * (1 - s / r2) * (Complex.exp (s / r1) * Complex.exp (s / r2))‖ := hstep0
    _ = |c - 1 / 2| * Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) *
        Real.exp (c / (c ^ 2 + t ^ 2)) / (c ^ 2 + t ^ 2) := hprod_norm
    _ = |δ| * Real.sqrt (δ ^ 2 + 4 * t ^ 2) *
        Real.exp ((1 / 2 + δ) / ((1 / 2 + δ) ^ 2 + t ^ 2)) / ((1 / 2 + δ) ^ 2 + t ^ 2) := by
      rw [show |c - 1 / 2| = |δ| by rw [hc3],
          show Real.sqrt ((c - 1 / 2) ^ 2 + 4 * t ^ 2) = Real.sqrt (δ ^ 2 + 4 * t ^ 2) by
            rw [show (c - 1 / 2) ^ 2 + 4 * t ^ 2 = δ ^ 2 + 4 * t ^ 2 by rw [hc3]],
          show Real.exp (c / (c ^ 2 + t ^ 2)) =
                Real.exp ((1 / 2 + δ) / ((1 / 2 + δ) ^ 2 + t ^ 2)) by
            rw [show c / (c ^ 2 + t ^ 2) = (1 / 2 + δ) / ((1 / 2 + δ) ^ 2 + t ^ 2) by
                  rw [show c = 1 / 2 + δ by dsimp only [c],
                      show c ^ 2 + t ^ 2 = (1 / 2 + δ) ^ 2 + t ^ 2 by
                        rw [show c = 1 / 2 + δ by dsimp only [c]]]],
          show c ^ 2 + t ^ 2 = (1 / 2 + δ) ^ 2 + t ^ 2 by
            rw [show c = 1 / 2 + δ by dsimp only [c]]]
/- =================================================================
   §1  the window floor (S1LowT.floStripMin on 0 < d < 1/200)
   ================================================================= -/

/-- The exponent C(t,d) = a/(a^2+t^2) + b/(b^2+t^2) of the unified window
    floor (the canonical 4-factor product at s = 1/2 + i t). -/
noncomputable def wFloorC (t d : ℝ) : ℝ :=
    (1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2) + (1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)

/-- Definitional expansion of the 4-zero canonical product with
    halfR = (2:R)⁻¹ normalized to the literal 1/2, in the flat complex form
    (the elaborated shape of B5.rhoPP etc. — the 1/2 and d are separate
    coerced summands). -/
theorem poffExpand (t d : ℝ) :
    poff t d t =
      fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
      fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
      fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
      fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) := by
  dsimp only [poff, rhoPP, rhoPM, rhoNP, rhoNM, sLine, halfR]
  rw [show (2 : ℝ)⁻¹ = 1 / 2 by norm_num]

/-- The exact own-height (window-floor) factorization: at s = sLine t the
    4-zero canonical product has magnitude
        d^2 (d^2 + 4 t^2) e^{wFloorC(t,d)} / ((a^2+t^2)(b^2+t^2)),
    a = 1/2+d, b = 1/2-d.  Both flanks satisfy |c - 1/2| = d.  This is the
    same closed form as the band floor mown (S4Own) — the unified floor is
    continuous across d = 1/200. -/
theorem windowFloorForm (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d < 1 / 2) :
    ‖poff t d t‖ =
      d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) /
        (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
  rw [poffExpand]
  have ha : 0 < (1 / 2 : ℝ) + d := by linarith [hd0]
  have hb : 0 < (1 / 2 : ℝ) - d := by linarith [hd]
  have hpa := pairfac_norm d t ha ht
  have hpb := pairfac_norm (-(d : ℝ)) t hb ht
  -- regroup (P1*P2) * (P3*P4)
  have hgrp :
      ‖fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
         fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
         fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
         fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
      ‖fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ *
      ‖fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ := by
    have hh :
        fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
        fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) =
        (fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
          fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)) *
        (fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
          fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)) := by
      ring
    rw [hh]
    exact norm_mul _ _
  have hp1 : ‖fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
       fac (((1 / 2 : ℝ) : ℂ) + (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
      d * Real.sqrt (d ^ 2 + 4 * t ^ 2) *
      Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) / ((1 / 2 + d) ^ 2 + t ^ 2) := by
    rw [hpa, abs_of_pos hd0]
  have hp2 : ‖fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
       fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
      d * Real.sqrt (d ^ 2 + 4 * t ^ 2) *
      Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)) / ((1 / 2 - d) ^ 2 + t ^ 2) := by
    have hM : ‖fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
           fac (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ =
        ‖fac (((1 / 2 : ℝ) : ℂ) + Complex.ofReal (-(d : ℝ)) + (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I) *
           fac (((1 / 2 : ℝ) : ℂ) + Complex.ofReal (-(d : ℝ)) - (t : ℂ) * I) (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * I)‖ := by
      rw [show (((1 / 2 : ℝ) : ℂ) - (d : ℂ) + (t : ℂ) * I) =
                (((1 / 2 : ℝ) : ℂ) + (-(d : ℂ))) + (t : ℂ) * I by ring,
          show (((1 / 2 : ℝ) : ℂ) - (d : ℂ) - (t : ℂ) * I) =
                (((1 / 2 : ℝ) : ℂ) + (-(d : ℂ))) - (t : ℂ) * I by ring]
      try simp [Complex.ofReal_neg]
    rw [hM, hpb, abs_neg, abs_of_pos hd0, show (-(d : ℝ)) ^ 2 = d ^ 2 by ring,
        show (1 / 2 + -d : ℝ) = 1 / 2 - d by ring]
  have hexp : Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) *
      Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)) = Real.exp (wFloorC t d) := by
    rw [← Real.exp_add]
    dsimp only [wFloorC]
    <;> ring
  have hX : 0 ≤ d ^ 2 + 4 * t ^ 2 := by nlinarith [sq_nonneg d, sq_nonneg t]
  have hsq2 : Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.sqrt (d ^ 2 + 4 * t ^ 2) = d ^ 2 + 4 * t ^ 2 := by
    rw [← Real.sqrt_mul hX (d ^ 2 + 4 * t ^ 2), Real.sqrt_mul_self hX]
  have hnum :
      d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) *
          (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2))) =
      d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) := by
    have hh : d * Real.sqrt (d ^ 2 + 4 * t ^ 2) *
        Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) *
        (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2))) =
        d * d * (Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.sqrt (d ^ 2 + 4 * t ^ 2)) *
        (Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) *
          Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2))) := by ring
    rw [hh, hsq2, hexp]
    ring
  have hh1 : (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) /
      ((1 / 2 + d) ^ 2 + t ^ 2)) *
      (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)) /
      ((1 / 2 - d) ^ 2 + t ^ 2)) =
      (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2)) *
        (d * Real.sqrt (d ^ 2 + 4 * t ^ 2) * Real.exp ((1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)))) /
      (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
    field_simp
    <;> ring
  rw [hgrp, hp1, hp2, hh1, hnum]

/-- S1a: the unified window floor is bounded below by 4 d^2 t^2 / (1+t^2)^2
    (the e^{wFloorC} factor is >= 1 and the denominators are <= (1+t^2)^2). -/
theorem windowFloorLo (t d : ℝ) (ht : 0 < t) (hd0 : 0 < d) (hd : d < 1 / 2) :
    ‖poff t d t‖ ≥ 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := by
  have ha : (1 / 2 + d : ℝ) ^ 2 ≤ 1 := by
    have h : (1 / 2 + d : ℝ) < 1 := by linarith [hd]
    nlinarith [sq_nonneg (1 / 2 + d), h]
  have hb : (1 / 2 - d : ℝ) ^ 2 ≤ 1 := by
    have h1 : 0 ≤ (1 / 2 : ℝ) - d := by linarith [hd]
    have h2 : (1 / 2 : ℝ) - d < 1 := by linarith [hd]
    nlinarith [sq_nonneg ((1 / 2 : ℝ) - d), h1, h2]
  have hD : ((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2) ≤ (1 + t ^ 2) ^ 2 := by
    nlinarith [ha, hb, sq_nonneg ((1 / 2 + d) * ((1 / 2 - d))),
      mul_nonneg (sq_nonneg (1 / 2 + d)) (sq_nonneg (1 / 2 - d))]
  have hC : 0 < wFloorC t d := by
    dsimp only [wFloorC]
    have hnum1 : 0 < (1 / 2 : ℝ) + d := by nlinarith [hd0]
    have hnum2 : 0 < (1 / 2 : ℝ) - d := by linarith
    have htp : 0 < t ^ 2 := pow_pos ht 2
    have hden1 : 0 < (1 / 2 + d) ^ 2 + t ^ 2 := by nlinarith [htp, sq_nonneg (1 / 2 + d)]
    have hden2 : 0 < (1 / 2 - d) ^ 2 + t ^ 2 := by nlinarith [htp, sq_nonneg ((1 / 2 : ℝ) - d)]
    exact add_pos (div_pos hnum1 hden1) (div_pos hnum2 hden2)
  have he : Real.exp (wFloorC t d) ≥ 1 := by
    rw [← Real.exp_zero]
    exact Real.exp_le_exp.mpr (le_of_lt hC)
  have hstep : 4 * d ^ 2 * t ^ 2 / (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) ≥
      4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := by
    have hnum : 0 ≤ 4 * d ^ 2 * t ^ 2 := by positivity
    rw [ge_iff_le]
    exact div_le_div₀ hnum (le_rfl : 4 * d ^ 2 * t ^ 2 ≤ 4 * d ^ 2 * t ^ 2) (by positivity) hD
  have hgoal : d ^ 2 * (4 * t ^ 2) / (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) =
      4 * d ^ 2 * t ^ 2 / (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by ring
  calc ‖poff t d t‖ = d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) /
          (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
        exact windowFloorForm t d ht hd0 hd
    _ ≥ d ^ 2 * (4 * t ^ 2) / (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
        rw [ge_iff_le]
        have hcX : 0 ≤ d ^ 2 * (d ^ 2 + 4 * t ^ 2) := by positivity
        have hN3 : d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) ≥
            d ^ 2 * (d ^ 2 + 4 * t ^ 2) := by
          nlinarith [he, hcX]
        apply (div_le_iff₀ (by positivity :
          0 < (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)))).mpr
        field_simp [show (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) ≠ 0 by positivity]
        nlinarith [hN3]
      _ = 4 * d ^ 2 * t ^ 2 / (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := hgoal
    _ ≥ 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := hstep

/-- S1b: the unified window floor is tiny on the window at face height
    (needed to select min(|pown|, floWin-tail) = |pown|). -/
theorem windowFloorHi (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hdw : d < 1 / 200) :
    ‖poff t d t‖ ≤ 3 / (4000 * t ^ 2) := by
  have hd0_ : 0 < d := hd0
  have hdh : d < 1 / 2 := by linarith
  have ht0 : 0 < t := by linarith [ht, show (0 : ℝ) < 1000 from by norm_num]
  have hd2 : d ^ 2 ≤ 1 / 40000 := by
    nlinarith [show d ≤ 1 / 200 from by linarith, show 0 ≤ d from by linarith]
  have hXY : d ^ 2 + 4 * t ^ 2 ≤ 4 * t ^ 2 + 1 := by nlinarith [hd2]
  have hCpos : 0 < wFloorC t d := by
    dsimp only [wFloorC]
    have hnum1 : 0 < (1 / 2 : ℝ) + d := by nlinarith [hd0]
    have hnum2 : 0 < (1 / 2 : ℝ) - d := by nlinarith [hdw]
    have htp : 0 < t ^ 2 := pow_pos ht0 2
    have hden1 : 0 < (1 / 2 + d) ^ 2 + t ^ 2 := by nlinarith [htp, sq_nonneg (1 / 2 + d)]
    have hden2 : 0 < (1 / 2 - d) ^ 2 + t ^ 2 := by nlinarith [htp, sq_nonneg ((1 / 2 : ℝ) - d)]
    exact add_pos (div_pos hnum1 hden1) (div_pos hnum2 hden2)
  have hCb : wFloorC t d ≤ 1 / 2 := by
    dsimp only [wFloorC]
    have hX : (1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2) ≤ (1 / 2 + d) / t ^ 2 := by
      have hnum : 0 ≤ 1 / 2 + d := by nlinarith [hd0]
      have hbnd : t ^ 2 ≤ (1 / 2 + d) ^ 2 + t ^ 2 := by nlinarith [sq_nonneg (1 / 2 + d)]
      exact div_le_div₀ hnum (le_rfl : (1 / 2 + d) ≤ (1 / 2 + d)) (by positivity) hbnd
    have hY : (1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2) ≤ (1 / 2 - d) / t ^ 2 := by
      have hnum : 0 ≤ 1 / 2 - d := by nlinarith [hdw]
      have hbnd : t ^ 2 ≤ (1 / 2 - d) ^ 2 + t ^ 2 := by nlinarith [sq_nonneg ((1 / 2 : ℝ) - d)]
      exact div_le_div₀ hnum (le_rfl : (1 / 2 - d) ≤ (1 / 2 - d)) (by positivity) hbnd
    have hT2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := by
      have hpos : (0 : ℝ) ≤ t + 1000 := by linarith [ht, show 0 ≤ 1000 from by norm_num]
      nlinarith [ht, sq_nonneg (t - 1000), hpos]
    have hT : 1 / t ^ 2 ≤ 1 / (1000 : ℝ) ^ 2 := by
      apply one_div_le_one_div_of_le (by norm_num : 0 < (1000 : ℝ) ^ 2)
      linarith [hT2]
    have hsum : (1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2) +
        (1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2) ≤ 1 / t ^ 2 := by
      have h1 : (1 / 2 + d) / t ^ 2 + (1 / 2 - d) / t ^ 2 = 1 / t ^ 2 := by
        field_simp
        <;> ring
      calc (1 / 2 + d) / ((1 / 2 + d) ^ 2 + t ^ 2) + (1 / 2 - d) / ((1 / 2 - d) ^ 2 + t ^ 2)
          ≤ (1 / 2 + d) / t ^ 2 + (1 / 2 - d) / t ^ 2 := add_le_add hX hY
        _ = 1 / t ^ 2 := h1
    have hlast : 1 / t ^ 2 ≤ 1 / 2 := by
      calc (1 / t ^ 2 : ℝ) ≤ 1 / (1000 : ℝ) ^ 2 := hT
        _ ≤ 1 / 2 := by norm_num
    linarith [hsum, hlast]
  have he2 : Real.exp (wFloorC t d) ≤ 2 := by
    have hb : Real.exp (1 / 2) < 2 := by
      have hlog : (1 / 2 : ℝ) < Real.log 2 := by
        have h1 : (1 / 2 : ℝ) < 0.6931471803 := by norm_num
        have h2 : 0.6931471803 < Real.log 2 := Real.log_two_gt_d9
        linarith [h1, h2]
      calc Real.exp (1 / 2) < Real.exp (Real.log 2) := Real.exp_lt_exp.mpr hlog
        _ = 2 := Real.exp_log (by norm_num)
    have hlt : Real.exp (wFloorC t d) < 2 := by
      calc Real.exp (wFloorC t d) ≤ Real.exp (1 / 2) := Real.exp_le_exp.mpr hCb
        _ < 2 := hb
    exact le_of_lt hlt
  have hD : 0 < ((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2) := by positivity
  have hD2 : ((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2) ≥ t ^ 4 := by
    nlinarith [sq_nonneg ((1 / 2 + d) * ((1 / 2 - d))),
      mul_nonneg (sq_nonneg (1 / 2 + d)) (sq_nonneg (1 / 2 - d)),
      mul_nonneg (sq_nonneg (1 / 2 + d)) (sq_nonneg t),
      mul_nonneg (sq_nonneg (1 / 2 - d)) (sq_nonneg t)]
  have hN : d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d) ≤
      (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2 := by
    calc d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d)
      ≤ d ^ 2 * (d ^ 2 + 4 * t ^ 2) * 2 := by gcongr
      _ ≤ (1 / 200) ^ 2 * (d ^ 2 + 4 * t ^ 2) * 2 := by gcongr
      _ ≤ (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2 := by gcongr
  have hmain : (d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d)) /
          (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) ≤
          (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2 / t ^ 4 := by
    exact div_le_div₀ (by nlinarith : 0 ≤ (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2) hN
      (by positivity : 0 < t ^ 4) hD2
  have hfin : (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2 / t ^ 4 ≤ 3 / (4000 * t ^ 2) := by
    have ht2 : (1 : ℝ) ≤ t ^ 2 := by nlinarith [ht]
    field_simp
    <;> nlinarith [ht2]
  calc ‖poff t d t‖ = (d ^ 2 * (d ^ 2 + 4 * t ^ 2) * Real.exp (wFloorC t d)) /
          (((1 / 2 + d) ^ 2 + t ^ 2) * ((1 / 2 - d) ^ 2 + t ^ 2)) := by
        exact windowFloorForm t d ht0 hd0 hdh
    _ ≤ (1 / 200) ^ 2 * (4 * t ^ 2 + 1) * 2 / t ^ 4 := hmain
    _ ≤ 3 / (4000 * t ^ 2) := hfin

/-- S1c: on the window at face height the unified S2 floor IS the own-height
    mass (the min with the floWin tail selects |pown|, since |pown| <= 7.5e-10
    < 23/1000 while floWin t = 23/1000 for t >= 1000). -/
theorem floWindowIsPown (t d : ℝ) (ht : 1000 ≤ t) (hd0 : 0 < d) (hdw : d < 1 / 200) :
    S1LowT.floStripMin t d = ‖poff t d t‖ := by
  dsimp only [S1LowT.floStripMin, S1LowT.floWin]
  have ht50 : (50 : ℝ) ≤ t := by linarith [ht, show (50 : ℝ) ≤ 1000 from by norm_num]
  have hfw : (23 / 1000 : ℝ) ≤ 1 - 25 / t := by
    have h25 : (25 : ℝ) / t ≤ (25 : ℝ) / 50 :=
      div_le_div₀ (show (0 : ℝ) ≤ 25 by norm_num)
        (show (25 : ℝ) ≤ 25 by norm_num)
        (show (0 : ℝ) < 50 by norm_num) ht50
    have hfift : (25 : ℝ) / 50 ≤ 1 / 2 := by norm_num
    have hhalf : (25 : ℝ) / t ≤ 1 / 2 := by linarith [h25, hfift]
    have h1h : 1 - 25 / t ≥ 1 / 2 := by linarith [hhalf]
    linarith [h1h, show (23 / 1000 : ℝ) ≤ 1 / 2 from by norm_num]
  have hpown : ‖poff t d t‖ ≤ 23 / 1000 := by
    have hh := windowFloorHi t d ht hd0 hdw
    have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := by
      have hpos : (0 : ℝ) ≤ t + 1000 := by linarith [ht, show 0 ≤ 1000 from by norm_num]
      nlinarith [ht, sq_nonneg (t - 1000), hpos]
    have hden : 4000 * (1000 : ℝ) ^ 2 ≤ 4000 * t ^ 2 := by
      apply mul_le_mul_of_nonneg_left ht2
      norm_num
    have hinv : 1 / (4000 * t ^ 2) ≤ 1 / (4000 * (1000 : ℝ) ^ 2) := by
      have h40 : (0 : ℝ) < 4000 * (1000 : ℝ) ^ 2 := by norm_num
      have h41 : (0 : ℝ) < 4000 * t ^ 2 := by positivity
      exact (one_div_le_one_div h41 h40).mpr hden
    have hmid : 3 / (4000 * t ^ 2) ≤ 3 / (4000 * (1000 : ℝ) ^ 2) := by
      calc 3 / (4000 * t ^ 2) = 3 * (1 / (4000 * t ^ 2)) := by field_simp
        _ ≤ 3 * (1 / (4000 * (1000 : ℝ) ^ 2)) := by gcongr
        _ = 3 / (4000 * (1000 : ℝ) ^ 2) := by field_simp
    calc ‖poff t d t‖ ≤ 3 / (4000 * t ^ 2) := hh
      _ ≤ 3 / (4000 * (1000 : ℝ) ^ 2) := hmid
      _ ≤ 23 / 1000 := by norm_num
  have hM : ‖poff t d t‖ ≤ max (min (23 / 1000 : ℝ) (1 - 25 / t)) 0 := by
    have h23 : (23 / 1000 : ℝ) ≤ min (23 / 1000 : ℝ) (1 - 25 / t) :=
      le_min (le_rfl : (23 / 1000 : ℝ) ≤ (23 / 1000 : ℝ)) hfw
    calc ‖poff t d t‖ ≤ (23 / 1000 : ℝ) := hpown
      _ ≤ min (23 / 1000 : ℝ) (1 - 25 / t) := h23
      _ ≤ max (min (23 / 1000 : ℝ) (1 - 25 / t)) 0 :=
        by simpa using le_max_of_le_left (le_rfl :
            min (23 / 1000 : ℝ) (1 - 25 / t) ≤ min (23 / 1000 : ℝ) (1 - 25 / t))
  exact min_eq_left hM

/-- S1d: the unified S2 window floor lower bound at the face (clean form). -/
theorem windowFloorLo2 (t d : ℝ) (ht : WinC.tPT2 ≤ t) (hdw : 0 < d) (hdh : d < 1 / 200) :
    S1LowT.floStripMin t d ≥ 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := by
  have h1000 : 1000 ≤ t := by
    have hpt2 : WinC.tPT2 = (3000175332800 : ℝ) := by rfl
    have hcmp : (1000 : ℝ) ≤ 3000175332800 := by norm_num
    linarith [hpt2, hcmp, ht]
  have ht0 : 0 < t := by linarith [h1000, show (0 : ℝ) < 1000 from by norm_num]
  have hdh2 : d < 1 / 2 := by linarith
  rw [floWindowIsPown t d h1000 hdw hdh]
  exact windowFloorLo t d ht0 hdw hdh2

/- =================================================================
   §2  THE GATE (window S4 leg under the n4 schedule, at face height)
   ================================================================= -/

/-- THE GATE (0243/25ac):  for t >= WinC.tPT2 and 1/210 <= d < 1/200,
    the strip wire under the n4 schedule (the 25af pin:
        p8_B t (n4 t) + Zbound t * exp (X4fun t) * X4fun t
            <= (A1 + (A2 + A3 + 25/10^15)/1000) * t^-2,  A1 = 8981/10^8)
    lies STRICTLY BELOW the unified S2 window floor:
        floor >= 4 d^2 t^2 / (1 + t^2)^2.
    The pin chain: 8981e-8 + 2.55e-17 < 8982e-8 < (4/44100)(1 - 10^-18)
    <= 4 d^2 (1 - 10^-18) (d >= 1/210), and at t >= tPT2 >= 10^12,
    (1 - 10^-18) t^-2 <= t^2/(1+t^2)^2 (i.e. (1+10^-24)^2 (1-10^-18) <= 1).
    Pin margin at d = 1/210: ~0.97% (sharp 1.0%); at d = 1/200: 11.35%.
    The gate is T-invariant in scale (both sides pure t^-2).  Measured
    (day058 sweep REV2):  the crossing is d*(t) ~= sqrt(A1/4) ~= 4.7384e-3
    and 1/210 = 4.7619e-3 sits above it.  No zeta, no zeros, no RH claim. -/
theorem partCgate_n4 (t d : ℝ) (ht : WinC.tPT2 ≤ t) (hdlo : 1 / 210 ≤ d) (hdhi : d < 1 / 200) :
    p8_B t (S4Strip.n4 t) + S4W.Zbound t *
        Real.exp (S4Strip.X4fun t) * S4Strip.X4fun t <
        S1LowT.floStripMin t d := by
  have h1000 : 1000 ≤ t := by
    have hpt2 : WinC.tPT2 = (3000175332800 : ℝ) := by rfl
    have hcmp : (1000 : ℝ) ≤ 3000175332800 := by norm_num
    linarith [hpt2, hcmp, ht]
  have ht0 : 0 < t := by linarith [h1000, show (0 : ℝ) < 1000 from by norm_num]
  have hz0 : 0 < S4W.Zbound t := by
    dsimp only [S4W.Zbound]
    refine mul_pos ?_ ?_
    · refine mul_pos ?_ ?_
      · norm_num
      · exact Real.rpow_pos_of_pos ht0 (1 / 4)
    · exact Real.log_pos (by
        have hpt2 : (1 : ℝ) < WinC.tPT2 := by
          rw [show (WinC.tPT2 : ℝ) = 3000175332800 by rfl]
          norm_num
        linarith)
  have hMz : S4W.Zbound t ≤ S4W.Zbound t := le_rfl
  have hwire :
      p8_B t (S4Strip.n4 t) + S4W.Zbound t * Real.exp (S4Strip.X4fun t) *
          S4Strip.X4fun t ≤
          (S4Strip.A1 + (S4Strip.A2 + S4Strip.A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) := by
    simpa using S4Strip.st_hSQ t (S4W.Zbound t) h1000 (le_of_lt hz0) hMz
  have hinv : t ^ (-2 : ℝ) = 1 / t ^ 2 := by
    rw [Real.rpow_neg (le_of_lt ht0), show t ^ (2 : ℝ) = t ^ 2 by norm_num]
    field_simp [show t ^ 2 ≠ 0 by positivity]
  have hC : S4Strip.A1 + (S4Strip.A2 + S4Strip.A3 + 25 / 10 ^ 15) / 1000 ≤ 8982 / 10 ^ 8 := by
    dsimp only [S4Strip.A1, S4Strip.A2, S4Strip.A3]
    norm_num
  have hrat : (8982 / 10 ^ 8 : ℝ) < (4 / 44100 : ℝ) * (1 - 1 / 10 ^ 18) := by
    norm_num
  have hd2 : 4 / 44100 ≤ 4 * d ^ 2 := by
    have hpos : 0 ≤ d := by linarith
    have hd1 : d ≥ 1 / 210 := hdlo
    have hsq : d ^ 2 ≥ (1 / 210 : ℝ) ^ 2 := by
      nlinarith [hd1, hpos, show (0 : ℝ) ≤ 1 / 210 from by norm_num]
    have hsq2 : (1 / 210 : ℝ) ^ 2 = 1 / 44100 := by norm_num
    nlinarith [hsq, hsq2]
  -- the t-invariant step ingredients
  have hx : 1 / t ^ 2 ≤ 1 / (10 : ℝ) ^ 24 := by
    have hT12 : (10 : ℝ) ^ 12 ≤ t := by
      have hpt : WinC.tPT2 = (3000175332800 : ℝ) := rfl
      have hcmp : (10 : ℝ) ^ 12 ≤ 3000175332800 := by norm_num
      linarith [hpt, hcmp]
    have hT2 : (10 : ℝ) ^ 24 ≤ t ^ 2 := by
      have hpos : (0 : ℝ) ≤ t + (10 : ℝ) ^ 12 := by linarith [hT12]
      nlinarith [hT12, sq_nonneg (t - (10 : ℝ) ^ 12), hpos]
    apply one_div_le_one_div_of_le (by positivity)
    linarith [hT2]
  have hx2 : 2 * (1 / t ^ 2) + (1 / t ^ 2) ^ 2 ≤ 1 / 10 ^ 18 := by
    have ha : 2 * (1 / t ^ 2) ≤ 2 / (10 : ℝ) ^ 24 := by
      rw [show 2 / (10 : ℝ) ^ 24 = 2 * (1 / (10 : ℝ) ^ 24) by ring]
      apply mul_le_mul_of_nonneg_left hx
      norm_num
    have hb : (1 / t ^ 2) ^ 2 ≤ (1 / (10 : ℝ) ^ 24) ^ 2 := by
      nlinarith [hx, show 0 ≤ 1 / t ^ 2 from by positivity]
    have hsum : 2 / (10 : ℝ) ^ 24 + (1 / (10 : ℝ) ^ 24) ^ 2 ≤ 1 / 10 ^ 18 := by norm_num
    nlinarith [ha, hb, hsum]
  have hT : (1 + 1 / t ^ 2 : ℝ) ^ 2 * (1 - 1 / 10 ^ 18) ≤ 1 := by
    have hε : 0 ≤ 1 - 1 / 10 ^ 18 := by norm_num
    have hexp : (1 + 1 / t ^ 2 : ℝ) ^ 2 = 1 + 2 * (1 / t ^ 2) + (1 / t ^ 2) ^ 2 := by ring
    rw [hexp]
    nlinarith [hx2, hε]
  have hcore : (1 - 1 / 10 ^ 18 : ℝ) / t ^ 2 ≤ t ^ 2 / (1 + t ^ 2) ^ 2 := by
    have hstep : (1 - 1 / 10 ^ 18) * (1 + t ^ 2) ^ 2 ≤ t ^ 4 := by
      have hA : (1 - 1 / 10 ^ 18) * (1 + t ^ 2) ^ 2 =
          t ^ 4 * ((1 + 1 / t ^ 2) ^ 2 * (1 - 1 / 10 ^ 18)) := by
        field_simp [pow_two, mul_comm, mul_assoc, mul_left_comm]
        <;> ring
      rw [hA]
      nlinarith [hT, show 0 ≤ t ^ 4 from by positivity]
    rw [show (1 - 1 / 10 ^ 18) / t ^ 2 =
            (1 - 1 / 10 ^ 18) * (1 + t ^ 2) ^ 2 / (t ^ 2 * (1 + t ^ 2) ^ 2) by
          field_simp [show t ^ 2 ≠ 0 from by positivity,
            show (1 + t ^ 2) ^ 2 ≠ 0 from by positivity]
          <;> ring,
        show t ^ 2 / (1 + t ^ 2) ^ 2 = t ^ 4 / (t ^ 2 * (1 + t ^ 2) ^ 2) by
          rw [show t ^ 4 = t ^ 2 * t ^ 2 by ring]
          field_simp [show t ^ 2 ≠ 0 from by positivity,
            show (1 + t ^ 2) ^ 2 ≠ 0 from by positivity]
          <;> ring]
    apply mul_le_mul_of_nonneg_right hstep
    positivity
  have hhd0 : 0 < d := by linarith
  have hflo := windowFloorLo2 t d ht hhd0 hdhi
  have hchain : (8982 / 10 ^ 8 : ℝ) * (1 / t ^ 2) < 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := by
    have h1 : (8982 / 10 ^ 8 : ℝ) * (1 / t ^ 2) < (4 / 44100 : ℝ) * (1 - 1 / 10 ^ 18) * (1 / t ^ 2) := by
      exact mul_lt_mul_of_pos_right hrat (by positivity)
    calc (8982 / 10 ^ 8 : ℝ) * (1 / t ^ 2)
      < (4 / 44100 : ℝ) * (1 - 1 / 10 ^ 18) * (1 / t ^ 2) := h1
      _ = (4 / 44100 : ℝ) * ((1 - 1 / 10 ^ 18) * (1 / t ^ 2)) := by ring
      _ ≤ 4 * d ^ 2 * ((1 - 1 / 10 ^ 18) * (1 / t ^ 2)) := by
          gcongr
      _ = 4 * d ^ 2 * ((1 - 1 / 10 ^ 18) / t ^ 2) := by
          field_simp
          <;> ring
      _ ≤ 4 * d ^ 2 * (t ^ 2 / (1 + t ^ 2) ^ 2) := by
          apply mul_le_mul_of_nonneg_left hcore
          positivity
      _ = 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := by ring
  calc
    p8_B t (S4Strip.n4 t) + S4W.Zbound t * Real.exp (S4Strip.X4fun t) *
        S4Strip.X4fun t
      ≤ (S4Strip.A1 + (S4Strip.A2 + S4Strip.A3 + 25 / 10 ^ 15) / 1000) * t ^ (-2 : ℝ) :=
          hwire
    _ = (S4Strip.A1 + (S4Strip.A2 + S4Strip.A3 + 25 / 10 ^ 15) / 1000) * (1 / t ^ 2) := by
        rw [hinv]
    _ ≤ (8982 / 10 ^ 8 : ℝ) * (1 / t ^ 2) := by
        apply mul_le_mul hC le_rfl
        · positivity
        · norm_num
    _ < 4 * d ^ 2 * t ^ 2 / (1 + t ^ 2) ^ 2 := hchain
    _ ≤ S1LowT.floStripMin t d := hflo

/- =================================================================
   §3  THE  REV2  MAP  PIN  (measured crossing <-> formal threshold)
   ================================================================= -/

/-- REV2 crossing pin (day058_partC_gate.py, the t-independent
    ratio map at t = WinC.tPT2):  the measured wire/floor crossing
    of the n4 wire against the window floor is
        d*(t) = sqrt(A1 / 4) ~= 4.738400...e-3
    (both sides ∝ t^-2,  ratio t-independent to 7 digits),  and the
    formal threshold 1/210 of `partCgate_n4` sits strictly on the
    WIRE side of it:  d* < 1/210 < 1/200.  Pure rational/real
    arithmetic;  no zero evaluation.  The near-line slice
    (0, d*) — and hence (0, 1/210) — remains bound-level open by
    structure (the window floor has a leading d^2 factor and
    vanishes as d -> 0).  No RH claim. -/
theorem rev2mapPin : Real.sqrt (S4Strip.A1 / 4) < (1 / 210 : ℝ) ∧ (1 / 210 : ℝ) < (1 / 200 : ℝ) := by
  constructor
  · rw [Real.sqrt_lt (by norm_num [S4Strip.A1] : 0 ≤ S4Strip.A1 / 4)
        (by norm_num : 0 ≤ (1 / 210 : ℝ))]
    norm_num [S4Strip.A1]
  · norm_num

/-- The gate band of `partCgate_n4` in one line:  the n4-schedule S4
    wire (B4 canonical product + zeta-bound slack) is strictly below
    the unified S2 floor on the window slice [1/210, 1/200) above the
    PT2 height — while the in-tree band wire (S4Asm's 13t/8 / nGrow
    schedule,  REV2 measured to miss the floor by ~ t/(8 d^2) at the
    1/200 edge) does NOT close that slice;  the n4 schedule is the
    wire that clears.  See `partCgate_n4` for the statement and the
    module doc for the honest boundary (near-line slice open at the
    bound level;  zero-exclusion of the actual zero set still rides
    on the S1 zero-side leg;  no RH claim). -/
theorem substripGateMap (t d : ℝ) (ht : WinC.tPT2 ≤ t) (hdlo : 1 / 210 ≤ d)
    (hdhi : d < 1 / 200) :
    p8_B t (S4Strip.n4 t) + S4W.Zbound t *
        Real.exp (S4Strip.X4fun t) * S4Strip.X4fun t <
    S1LowT.floStripMin t d ∧
    Real.sqrt (S4Strip.A1 / 4) < d := by
  constructor
  · exact partCgate_n4 t d ht hdlo hdhi
  · have hdstar : Real.sqrt (S4Strip.A1 / 4) < 1 / 210 := rev2mapPin.1
    linarith [hdlo]

end S4WG
