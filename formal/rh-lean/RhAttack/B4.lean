/-
  B4.lean — the on-line per-pair closed form (B-4), theorem + cross-check.

  PROVENANCE (no recall — every reference resolves):
    Ledger      : plan/40-prize-islands/rh-attack/FORMULAS.md (E7b block,
                  per-pair closed form la_pair / ar_pair) and
                  RH-PROOF-OUTLINE.md [B-4] block (the statement +
                  verification record below).
    Python ref  : scripts/rh/d4_unit_pair.py — dps-25 mpmath single-pair
                  reference vs the float64 vectorized closed form.
    Record      : scripts/rh/out_day010_pair_unit.txt — 16 points
                  (4 certified zero heights × 4 straddle/remote t),
                  worst dLa = 3.464e-14, dAr = 3.235e-16, PASS.
    Cross-val   : scripts/rh/out_day009c_vectorized_rerun.txt (Job A,
                  point-for-point reproduction of the certified Stage-1
                  onset table by the float64 vector product).

  STATEMENT (the B-4 core).  Write  s = ½ + i t  (t > 0), and for a
  certified zero height γ > 0 the on-line conjugate pair

      ρ₁ = ½ + iγ ,   ρ₂ = ½ − iγ ,   Bv(γ) := 1 / (¼ + γ²).

  With the 25.2.12 canonical factors F_ρ(s) = (1 − s/ρ)·e^{s/ρ}:

  (T1, EXACT, no exclusion)
      F_ρ1 · F_ρ2 = (γ² − t²)·Bv · e^{s · Bv} .
    The whole two-zero factor collapses to (a real signed prefactor) ×
    (one exponential).  True even at t = γ (both sides 0).

  (T2, t ≠ γ)   the log-magnitude, the ledger's la_pair verbatim:
      log ‖F_ρ1 · F_ρ2‖ = ½·Bv + log |1 − (t² + ¼)·Bv|.

  (T3, t ≠ γ)   the additive phase, the ledger's ar_pair:
      arg F_ρ1 + arg F_ρ2 = t·Bv − π·[t > γ]   (mod 2π),
    stated two ways: (T3a) exactly in the circle type Real.Angle,
    (T3b) in ℝ with an explicit 2πℤ multiple.  The branch is the
    sign flip of the prefactor at t = γ — nothing else: the
    "atan2 constants cancel in-pair" is the content.

  PART 4 — float64 cross-check (mirroring d4_unit_pair.py, but the
  comparison is closed-form-vs-DIRECT-PRODUCT inside LEAN FLOAT, an
  independent check of the recorded dps-25-vs-float check): the 16
  recorded points, #eval-able, deviations expected ~1e-14.
  DONE (day-011): 16/16 points, worst dLa = 8.5e-14, dAr = 4.4e-16 —
  the double-roundoff scale predicted; out_rhattack_day011.txt.
-/
import Mathlib
import RhAttack.E7a

set_option linter.style.header false
-- `ht` stays in the statement (the B-4 record domain is γ, t > 0) even
-- though T1's algebra does not spend it
set_option linter.unusedVariables false

noncomputable section

open Complex

variable {γ t : ℝ}

/-- 4.33.1 compatibility — Lean 4.34 (rc/core) added `ite_eq_left` /
    `ite_eq_right` to `Init/Core.lean` (lines 1179/1188 in the rc2 source);
    stable 4.33.1's sanctioned forms are `ite_cond_eq_true` /
    `ite_cond_eq_false` with `eq_true` / `eq_false` (Init/SimpLemmas.lean).
    These shims keep the rc2-era spellings below valid, proofs unmodified. -/
theorem ite_eq_left {α : Sort u} {c : Prop} {d : Decidable c} (hc : c) {a b : α} :
    (if c then a else b) = a :=
  ite_cond_eq_true _ _ (h := eq_true hc)

theorem ite_eq_right {α : Sort u} {c : Prop} {d : Decidable c} (hnc : ¬ c) {a b : α} :
    (if c then a else b) = b :=
  ite_cond_eq_false _ _ (h := eq_false hnc)

/-- Half, as a single elaborated real constant (def and rewrite sites must
    carry the identical term — numeral literals re-elaborate per context). -/
def halfR : ℝ := (2 : ℝ)⁻¹

/-- Bv(γ) = 1/(¼ + γ²) — the pair's real scale. -/
def Bv (γ : ℝ) : ℝ := 1 / (1 / 4 + γ ^ 2)

/-- s = ½ + i t on the critical line. -/
def sLine (t : ℝ) : ℂ := halfR + (t : ℝ) * I

/-- The on-line pair members (built from `halfR` so every occurrence is
    the one named term — no per-site numeral re-elaboration). -/
def rhoP (γ : ℝ) : ℂ := halfR + (γ : ℝ) * I
def rhoM (γ : ℝ) : ℂ := halfR - (γ : ℝ) * I

/-- The 25.2.12 canonical factor for one zero ρ at height s. -/
def fac (ρ s : ℂ) : ℂ := (1 - s / ρ) * exp (s / ρ)

/-- The on-line pair product at (γ, t). -/
def pairProd (γ t : ℝ) : ℂ :=
  fac (rhoP γ) (sLine t) * fac (rhoM γ) (sLine t)

/-- ofReal is injective (proof via the re-projection, the form `simp`
    cannot reach here — used as an explicit closer). -/
lemma ofRealInj {a b : ℝ} : ofReal a = ofReal b ↔ a = b := by
  constructor
  · rintro h
    have := congr_arg (fun z : ℂ => z.re) h
    simpa [ofReal_re] using this
  · rintro h
    rw [h]

/-- Pure-imaginary product: (a·I)·(b·I) = −ab (real). -/
lemma imMulIm (a b : ℝ) : ((a : ℂ) * I) * ((b : ℂ) * I) = ofReal (-a * b) := by
  rw [Complex.ext_iff]
  constructor <;> simp [ofReal_re, ofReal_im]

#check Bv
#check sLine
#check rhoP
#check rhoM
#check fac
#check pairProd

-- =====================================================================
-- T1 — the exact closed form
-- =====================================================================

/-- (T1) The two on-line factors collapse to a real signed prefactor
    times one exponential.  Holds for all γ > 0, t > 0 — INCLUDING
    t = γ (both sides 0). -/
theorem pairClosedForm (hγ : 0 < γ) (ht : 0 < t) :
    pairProd γ t = ofReal ((γ ^ 2 - t ^ 2) * Bv γ) * exp (sLine t * (Bv γ : ℂ)) := by
  have hρP : rhoP γ ≠ 0 := by
    intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoP] at this
    linarith
  have hρM : rhoM γ ≠ 0 := by
    intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoM] at this
    linarith
  -- normSq of a line (re + im·I), both signs — plain ring, no pattern games
  have normSqLine (a b : ℝ) : normSq ((a : ℂ) + (b : ℂ) * I) = a ^ 2 + b ^ 2 := by
    simp only [normSq_apply, add_re, add_im, ofReal_re, ofReal_im, mul_I_re, mul_I_im]
    ring
  have normSqMinusLine (a b : ℝ) : normSq ((a : ℂ) - (b : ℂ) * I) = a ^ 2 + b ^ 2 := by
    simp only [normSq_apply, sub_re, sub_im, ofReal_re, ofReal_im, mul_I_re, mul_I_im]
    ring
  -- the Coe of a real: re/im in isolation (the default simp set rewrites
  -- (↑x).re toward normSq forms in big goals; doing it alone is reliable)
  have hbvre : ((Bv γ : ℂ)).re = Bv γ := by simp [ofReal_re]
  have hbvim : ((Bv γ : ℂ)).im = 0 := by simp [ofReal_im]
  -- (i) 1/ρP + 1/ρM = Bv (real): ρP + ρM = 1, ρP·ρM = ¼ + γ²
  --     (stated in INV form so the hexp rewrite matches field_simp output)
  have hsum : rhoP γ + rhoM γ = (1 : ℂ) := by
    rw [Complex.ext_iff]
    constructor <;> (simp [rhoP, rhoM, halfR] <;> ring)
  have hinv : (rhoP γ)⁻¹ + (rhoM γ)⁻¹ = (Bv γ : ℂ) := by
    rw [Complex.ext_iff]
    constructor
    · rw [hbvre]
      simp [rhoP, rhoM, add_re, inv_re]
      rw [normSqLine halfR γ, normSqMinusLine halfR γ]
      norm_num [halfR]
      rw [Bv]
      field_simp
      norm_num
    · rw [hbvim]
      simp [rhoP, rhoM, add_im, inv_im]
      rw [normSqLine halfR γ, normSqMinusLine halfR γ]
      field_simp [halfR]
      ring
  -- (ii) the polynomial part: (1 − s/ρP)(1 − s/ρM) = (γ² − t²)·Bv (real)
  have hpoly :
      (1 - sLine t / rhoP γ) * (1 - sLine t / rhoM γ) =
        ofReal ((γ ^ 2 - t ^ 2) * Bv γ) := by
    -- (ρP − s) = i(γ − t), (ρM − s) = −i(t + γ): pure imaginary straddles
    have hstr : rhoP γ - sLine t = (γ - t : ℝ) * I := by
      rw [Complex.ext_iff]
      constructor <;> (simp [rhoP, sLine] <;> ring)
    have hstrM : rhoM γ - sLine t = (-(t + γ) : ℝ) * I := by
      rw [Complex.ext_iff]
      constructor <;> (simp [rhoM, sLine] <;> ring)
    have hprod : rhoP γ * rhoM γ = ofReal (1 / 4 + γ ^ 2) := by
      -- NOTE: (γ² : ℂ) elaborates as (↑γ)² (the square is over ℂ), so
      -- pow_two must be unfolded before ofReal_re/ofReal_im can see the base
      rw [Complex.ext_iff]
      constructor
      · simp [rhoP, rhoM, halfR, pow_two, ofReal_re, ofReal_im]
        norm_num [halfR]
      · simp [rhoP, rhoM, halfR, pow_two, ofReal_re, ofReal_im]
        ring
    field_simp [Bv]
    rw [hstr, hstrM, hprod, imMulIm (γ - t) (-(t + γ)), ← ofReal_mul, ofRealInj]
    rw [Bv]
    field_simp
    ring
  -- (iii) the exponential part: exp(s/ρP)·exp(s/ρM) = exp(s·Bv)
  have hexp : exp (sLine t / rhoP γ) * exp (sLine t / rhoM γ) =
      exp (sLine t * Bv γ) := by
    rw [← exp_add, div_eq_mul_inv, div_eq_mul_inv]
    congr
    rw [← mul_add, hinv]
  calc pairProd γ t
      = (1 - sLine t / rhoP γ) * (1 - sLine t / rhoM γ) *
          (exp (sLine t / rhoP γ) * exp (sLine t / rhoM γ)) := by
        dsimp only [pairProd, fac]
        ring
      _ = ofReal ((γ ^ 2 - t ^ 2) * Bv γ) * exp (sLine t * Bv γ) := by
        rw [hpoly, hexp]

/-- (γ² − t²)·Bv γ ≠ 0 when t ≠ γ (both positive). Both sides of the
    exclusion: γ·t > 0 makes γ² = t² equivalent to γ = t. -/
theorem pairPolyNeZero (hne : t ≠ γ) (hγ : 0 < γ) (ht : 0 < t) :
    (γ ^ 2 - t ^ 2) * Bv γ ≠ 0 := by
  intro h
  have hBv : 0 < Bv γ := by simp [Bv]; positivity
  have hP0 : γ ^ 2 - t ^ 2 = 0 := (mul_eq_zero.1 h).resolve_right hBv.ne'
  have hsum : 0 < γ + t := add_pos hγ ht
  have hsub : γ - t = 0 := by
    have hprod : (γ - t) * (γ + t) = 0 := by
      rw [sq_sub_sq] at hP0
      rwa [mul_comm]
    exact (mul_eq_zero.1 hprod).resolve_right (ne_of_gt hsum)
  exact hne (eq_comm.mpr (sub_eq_zero.mp hsub))

/-- T2 — the log-magnitude half of the ledger, verbatim. For t ≠ γ,
    log ‖pair product‖ = ½·Bv + log |1 − (t² + ¼)·Bv|. (At t = γ the
    pair product is 0 and the ledger branch is the onset singularity.) -/
theorem pairLogAbs (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) :
    Real.log ‖pairProd γ t‖ = halfR * Bv γ + Real.log |1 - (t ^ 2 + 1 / 4) * Bv γ| := by
  have hBv : 0 < Bv γ := by simp [Bv]; positivity
  have hP : (γ ^ 2 - t ^ 2) * Bv γ ≠ 0 := pairPolyNeZero hne hγ ht
  have hinner : (γ ^ 2 - t ^ 2) * Bv γ = 1 - (t ^ 2 + 1 / 4) * Bv γ := by
    simp [Bv]
    field_simp
    ring
  -- the exponent splits into a real part (the ½·Bv) and an imaginary part (the t·Bv)
  have hW : sLine t * (Bv γ : ℂ) = ofReal (halfR * Bv γ) + ofReal (t * Bv γ) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [sLine, ofReal_mul, ofReal_re, ofReal_im] <;> ring)
  have hexpW : ‖exp (sLine t * (Bv γ : ℂ))‖ = Real.exp (halfR * Bv γ) := by
    rw [hW, Complex.exp_add, Complex.norm_mul,
        Complex.norm_exp_ofReal (halfR * Bv γ),
        Complex.norm_exp_ofReal_mul_I (t * Bv γ)]
    ring
  calc Real.log ‖pairProd γ t‖
      = Real.log (‖ofReal ((γ ^ 2 - t ^ 2) * Bv γ)‖ * ‖exp (sLine t * (Bv γ : ℂ))‖) := by
        rw [pairClosedForm hγ ht, Complex.norm_mul]
      _ = Real.log (|(γ ^ 2 - t ^ 2) * Bv γ| * Real.exp (halfR * Bv γ)) := by
        rw [Complex.norm_real, hexpW]
        simp
      _ = Real.log |(γ ^ 2 - t ^ 2) * Bv γ| + Real.log (Real.exp (halfR * Bv γ)) := by
        rw [Real.log_mul (abs_ne_zero.2 hP) (Real.exp_ne_zero (halfR * Bv γ))]
      _ = Real.log |(γ ^ 2 - t ^ 2) * Bv γ| + halfR * Bv γ := by
        rw [Real.log_exp]
      _ = Real.log |1 - (t ^ 2 + 1 / 4) * Bv γ| + halfR * Bv γ := by
        rw [hinner]
      _ = halfR * Bv γ + Real.log |1 - (t ^ 2 + 1 / 4) * Bv γ| := by
        rw [add_comm]

-- T3 — the log-argument half of the ledger. Stated in Real.Angle (= the
-- exact mod-2π circle, no branch cuts) in the angle-sum form, and in the
-- ℝ ledger form (∃ k : ℤ) via pairArLedger.

/-- T3a — angle form: the pair argument = t·Bv + (π if the pair is
    crossed, i.e. t > γ; else 0), exactly mod 2π. -/
theorem pairArgAngle (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) :
    (arg (fac (rhoP γ) (sLine t)) : Real.Angle) +
        (arg (fac (rhoM γ) (sLine t)) : Real.Angle) =
      (t * Bv γ : Real.Angle) + (if t > γ then (Real.pi : Real.Angle) else 0) := by
  have hBv : 0 < Bv γ := by simp [Bv]; positivity
  -- the factors are never zero: fac(ρ) = 0 would put s on the pair pole
  have hfacPnz : fac (rhoP γ) (sLine t) ≠ 0 := by
    dsimp only [fac]
    intro h
    have h1 : 1 - sLine t / rhoP γ = 0 :=
      (mul_eq_zero.1 h).resolve_right (exp_ne_zero (sLine t / rhoP γ))
    have hρnz : rhoP γ ≠ 0 := by
      intro h
      have := congr_arg (fun z : ℂ => z.im) h
      simp [rhoP] at this
      exact hγ.ne' this
    have hs : sLine t = rhoP γ := by
      have h1' : sLine t / rhoP γ = 1 := (sub_eq_zero.mp h1).symm
      have : sLine t = (sLine t / rhoP γ) * rhoP γ := by field_simp [hρnz]
      rwa [h1', one_mul] at this
    have := congr_arg (fun z : ℂ => z.im) hs
    simp [sLine, rhoP] at this
    exact hne this
  have hfacMnz : fac (rhoM γ) (sLine t) ≠ 0 := by
    dsimp only [fac]
    intro h
    have h1 : 1 - sLine t / rhoM γ = 0 :=
      (mul_eq_zero.1 h).resolve_right (exp_ne_zero (sLine t / rhoM γ))
    have hρnz : rhoM γ ≠ 0 := by
      intro h
      have := congr_arg (fun z : ℂ => z.im) h
      simp [rhoM] at this
      linarith
    have hs : sLine t = rhoM γ := by
      have h1' : sLine t / rhoM γ = 1 := (sub_eq_zero.mp h1).symm
      have : sLine t = (sLine t / rhoM γ) * rhoM γ := by field_simp [hρnz]
      rwa [h1', one_mul] at this
    have := congr_arg (fun z : ℂ => z.im) hs
    simp [sLine, rhoM] at this
    linarith
  -- the real part of s·Bv is positive; the spiral factor's argument is exactly t·Bv
  have hW : sLine t * (Bv γ : ℂ) = ofReal (halfR * Bv γ) + ofReal (t * Bv γ) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [sLine, ofReal_mul, ofReal_re, ofReal_im] <;> ring)
  have hsecond : (arg (exp (sLine t * (Bv γ : ℂ))) : Real.Angle) = (t * Bv γ : Real.Angle) := by
    rw [hW, Complex.exp_add_mul_I (ofReal (halfR * Bv γ)) (ofReal (t * Bv γ))]
    rw [← ofReal_exp (halfR * Bv γ)]
    rw [← ofReal_cos (t * Bv γ), ← ofReal_sin (t * Bv γ)]
    rw [← Real.Angle.cos_coe (t * Bv γ), ← Real.Angle.sin_coe (t * Bv γ)]
    rw [Complex.arg_mul_cos_add_sin_mul_I_coe_angle (Real.exp_pos (halfR * Bv γ))
        ((t * Bv γ : Real.Angle))]
  -- the pair product factors as [real × unit-modulus spiral]
  have hP : (γ ^ 2 - t ^ 2) * Bv γ ≠ 0 := pairPolyNeZero hne hγ ht
  have hPnz : ofReal ((γ ^ 2 - t ^ 2) * Bv γ) ≠ 0 := by
    intro h
    have this := congr_arg (fun z : ℂ => z.re) h
    rw [ofReal_re ((γ ^ 2 - t ^ 2) * Bv γ)] at this
    rw [show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
    exact (pairPolyNeZero hne hγ ht) this
  have hexpWnz : exp (sLine t * (Bv γ : ℂ)) ≠ 0 := exp_ne_zero (sLine t * (Bv γ : ℂ))
  have hbridge : (arg (pairProd γ t) : Real.Angle) =
      (arg (ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) : Real.Angle) +
        (arg (exp (sLine t * (Bv γ : ℂ))) : Real.Angle) := by
    rw [pairClosedForm hγ ht, Complex.arg_mul_coe_angle hPnz hexpWnz]
  by_cases hgt : t > γ
  · -- crossed: the real factor is negative, contributes π
    have hPneg : (γ ^ 2 - t ^ 2) * Bv γ < 0 := by
      have hsub : γ - t < 0 := by linarith
      have hsum : 0 < γ + t := add_pos hγ ht
      have hn : γ ^ 2 - t ^ 2 < 0 := by
        rw [sq_sub_sq, mul_comm]
        exact mul_neg_of_neg_of_pos hsub hsum
      exact mul_neg_of_neg_of_pos hn hBv
    have hfirst : (arg (ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) : Real.Angle) = (Real.pi : Real.Angle) := by
      rw [Complex.arg_ofReal_of_neg hPneg]
    calc (arg (fac (rhoP γ) (sLine t)) : Real.Angle) +
            (arg (fac (rhoM γ) (sLine t)) : Real.Angle)
        = (arg (pairProd γ t) : Real.Angle) := by
          dsimp only [pairProd]
          rw [Complex.arg_mul_coe_angle hfacPnz hfacMnz]
        _ = (arg (ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) : Real.Angle) +
            (arg (exp (sLine t * (Bv γ : ℂ))) : Real.Angle) := by
          rw [hbridge]
        _ = (t * Bv γ : Real.Angle) + (if t > γ then (Real.pi : Real.Angle) else 0) := by
          rw [hfirst, hsecond, ite_eq_left hgt]
          abel
  · -- uncrossed: the real factor is positive, contributes 0
    have hlt : t < γ := lt_of_le_of_ne (le_of_not_gt hgt) hne
    have hPpos : 0 < (γ ^ 2 - t ^ 2) * Bv γ := by
      have hsub : 0 < γ - t := by linarith
      have hsum : 0 < γ + t := add_pos hγ ht
      have hp : 0 < γ ^ 2 - t ^ 2 := by rw [sq_sub_sq]; exact mul_pos hsum hsub
      exact mul_pos hp hBv
    have hfirst : (arg (ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) : Real.Angle) = (0 : Real.Angle) := by
      rw [Complex.arg_ofReal_of_nonneg (le_of_lt hPpos)]
      rfl
    calc (arg (fac (rhoP γ) (sLine t)) : Real.Angle) +
            (arg (fac (rhoM γ) (sLine t)) : Real.Angle)
        = (arg (pairProd γ t) : Real.Angle) := by
          dsimp only [pairProd]
          rw [Complex.arg_mul_coe_angle hfacPnz hfacMnz]
        _ = (arg (ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) : Real.Angle) +
            (arg (exp (sLine t * (Bv γ : ℂ))) : Real.Angle) := by
          rw [hbridge]
        _ = (t * Bv γ : Real.Angle) + (if t > γ then (Real.pi : Real.Angle) else 0) := by
          rw [hfirst, hsecond, ite_eq_right (by
              by_contra h
              linarith [hlt, h])]
          abel

/-- T3b — ℝ ledger form: the pair argument equals the ledger value
    t·Bv − π·[t > γ], modulo 2π. -/
theorem pairArLedger (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) :
    ∃ k : ℤ,
      (arg (fac (rhoP γ) (sLine t)) + arg (fac (rhoM γ) (sLine t))) =
      t * Bv γ - (if t > γ then Real.pi else 0) + (k : ℝ) * (2 * Real.pi) := by
  have hA : (arg (fac (rhoP γ) (sLine t)) : Real.Angle) +
      (arg (fac (rhoM γ) (sLine t)) : Real.Angle) =
      (t * Bv γ : Real.Angle) + (if t > γ then (Real.pi : Real.Angle) else 0) :=
    pairArgAngle hγ ht hne
  -- the coe of the real argument-sum
  have hL : ((arg (fac (rhoP γ) (sLine t)) + arg (fac (rhoM γ) (sLine t)) : ℝ) : Real.Angle) =
      (arg (fac (rhoP γ) (sLine t)) : Real.Angle) + (arg (fac (rhoM γ) (sLine t)) : Real.Angle) := by
    exact Real.Angle.coe_add _ _
  by_cases hgt : t > γ
  · have hAEq : ((arg (fac (rhoP γ) (sLine t)) + arg (fac (rhoM γ) (sLine t)) : ℝ) : Real.Angle) =
      ((t * Bv γ + Real.pi : ℝ) : Real.Angle) := by
      rw [hL, hA, ite_eq_left hgt]
      exact (Real.Angle.coe_add _ _).symm
    obtain ⟨k, hk⟩ := (Real.Angle.angle_eq_iff_two_pi_dvd_sub).mp hAEq
    refine ⟨k + 1, ?_⟩
    rw [ite_eq_left hgt, show ((k + 1 : ℤ) : ℝ) = (k : ℝ) + 1 from by
          rw [Int.cast_add, Int.cast_one]]
    nlinarith
  · have hlt : t < γ := lt_of_le_of_ne (le_of_not_gt hgt) hne
    have hAEq : ((arg (fac (rhoP γ) (sLine t)) + arg (fac (rhoM γ) (sLine t)) : ℝ) : Real.Angle) =
        ((t * Bv γ : ℝ) : Real.Angle) := by
      rw [hL, hA, ite_eq_right (by
              by_contra h
              linarith [hlt, h]), add_zero]
    obtain ⟨k, hk⟩ := (Real.Angle.angle_eq_iff_two_pi_dvd_sub).mp hAEq
    refine ⟨k, ?_⟩
    rw [ite_eq_right (by
              by_contra h
              linarith [hlt, h])]
    nlinarith
    
-- PART 4 — the runtime cross-check (float64, classless, as in E7a).
-- 16 recorded points: g ∈ {30.42488, 72.06716, 146.00098, 236.52423} ×
-- t ∈ {50.0, g−0.3, g+0.3, 2000.0} — the same table as
-- scripts/rh/out_day010_pair_unit.txt (there cross-validated against a
-- dps-25 reference, worst dLa=3.464e-14, dAr=3.235e-16). Here BOTH sides
-- are float64: the ledger closed form (T2/T3: la, ar) vs the direct
-- float64 evaluation of the pair product (fac factors, complex exp,
-- log-norm, atan2). A correct port shows differences ~1e-14 (double
-- roundoff of the two evaluation orders); a transcription error shows O(1).

section
variable {γ t : ℝ}

end

namespace B4Float

def F := Float × Float  -- (re, im), deliberately class-free

def Fadd (a b : F) : F := (a.1 + b.1, a.2 + b.2)
def Fsub (a b : F) : F := (a.1 - b.1, a.2 - b.2)
def Fmul (a b : F) : F := (a.1 * b.1 - a.2 * b.2, a.1 * b.2 + a.2 * b.1)
def Fdiv (a b : F) : F :=
  let d := b.1 * b.1 + b.2 * b.2
  ((a.1 * b.1 + a.2 * b.2) / d, (a.2 * b.1 - a.1 * b.2) / d)
def Freal (r : Float) : F := (r, 0.0)
def FlogAbs (a : F) : Float := (a.1 * a.1 + a.2 * a.2).log / 2.0
def Farg (a : F) : Float := a.2.atan2 a.1
def Fexp (z : F) : F :=
  let e := z.1.exp
  (e * z.2.cos, e * z.2.sin)

/-- The ledger's closed form at (g, t) — the T2/T3 theorems:
    la = ½·Bv + log |1 − (t²+¼)·Bv|,  ar = t·Bv − π·[t > g]. -/
def ledger (g t : Float) : Float × Float :=
  let Bv := 1.0 / (0.25 + g * g)
  let inner := 1.0 - (t * t + 0.25) * Bv
  (0.5 * Bv + inner.abs.log, t * Bv - (if g < t then Float.pi else 0.0))

/-- The direct float64 evaluation of the pair product
    (1 − s/ρP)·exp(s/ρP) · (1 − s/ρM)·exp(s/ρM),  s = ½ + it. -/
def direct (g t : Float) : F :=
  let s := (0.5, t)
  let fac (rho : F) : F := Fmul (Fsub (Freal 1.0) (Fdiv s rho)) (Fexp (Fdiv s rho))
  Fmul (fac (0.5, g)) (fac (0.5, -g))

/-- Angle difference reduced into [−π, π]. -/
def diffAr (a b : Float) : Float :=
  let d := a - b
  (if d > Float.pi then d - 2 * Float.pi
   else if d < -Float.pi then d + 2 * Float.pi
   else d).abs

def pts : List (Float × Float) :=
  let gs : List Float := [30.42488, 72.06716, 146.00098, 236.52423]
  gs.flatMap (fun g => [(g, 50.0), (g, g - 0.3), (g, g + 0.3), (g, 2000.0)])

def go (l : List (Float × Float)) (w : Float × Float) : IO (Float × Float) :=
  match l with
  | [] => pure w
  | (g, t) :: r => do
    let (laL, arL) := ledger g t
    let p := direct g t
    let dLa := (laL - FlogAbs p).abs
    let dAr := diffAr arL (Farg p)
    -- 4.34 s! has no float format specs: report the deviations scaled by 1e15
    -- (the 6-display-digit values are the significant digits).
    IO.println s!"  g={g}  t={t}:  dLa·1e15 = {dLa * 1e15}   \
dAr·1e15 = {dAr * 1e15}"
    go r (max w.1 dLa, max w.2 dAr)

def run : IO (Float × Float) := do
  let w ← go pts (0.0, 0.0)
  if w.1 ≤ 1e-12 && w.2 ≤ 1e-12 then
    IO.println s!"B-4 CROSS-CHECK PASS: worst dLa·1e15 = {w.1 * 1e15}, \
worst dAr·1e15 = {w.2 * 1e15} (threshold 1e-12)"
  else
    IO.println s!"B-4 CROSS-CHECK FAIL: worst dLa·1e15 = {w.1 * 1e15}, \
worst dAr·1e15 = {w.2 * 1e15}"
  pure w

end B4Float

#check pairClosedForm
#check pairPolyNeZero
#check pairLogAbs
#check pairArgAngle
#check pairArLedger

end
