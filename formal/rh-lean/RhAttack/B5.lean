/-
Copyright (c) 2026 kainos-logos rh-attack (owner-directed research;
AI co-developed instrument; no prize claim — see
plan/40-prize-islands/rh-attack/README.md).
-/
import Mathlib
import RhAttack.B4

-- Same file-scoped waiver as B0.lean: the style.header linter wants the
-- module doc-string BEFORE `open`, the rc2 parser rejects that order;
-- the parseable layout is open → doc attached to the first decl.
set_option linter.style.header false
open Complex

noncomputable section

variable {γ t : ℝ}

/-- **B-5 CORE** — the exact off-line/on-line ratio theorem (B-5), day-012.
    For  s = ½ + i t  (t > 0, t ≠ γ) and the 25.2.12 canonical factors
    F_ρ(s) = (1 − s/ρ)·e^{s/ρ}, write

      P_on(s)   = F_{½+iγ}(s) · F_{½−iγ}(s)            (the B-4 pair, reused
                  from RhAttack.B4 as `pairProd`)
      P_off(s,δ) = ∏_{ρ ∈ {½+δ±iγ, ½−δ±iγ}} F_ρ(s)     (four factors)
      R(s,δ)    = P_off / P_on ,   ω_δ := (1+2δ)/((½+δ)²+γ²) + (1−2δ)/((½−δ)²+γ²) − 1/(¼+γ²).

    **Theorem (T1 `b5Ratio`).**  R(s,δ) = pref·e^{s·ω_δ} with the REAL
    prefactor

      pref = (¼+γ²)·((γ−t)²+δ²)·((γ+t)²+δ²) / ((γ²−t²)·((½+δ)²+γ²)·((½−δ)²+γ²)).

    True for every real δ (the record domain is δ > 0).  The only
    sign/branch carrier in the whole formula is the on-line factor
    (γ²−t²), whose sign flips exactly at t = γ (`b5PrefSign`); the
    off-line numerator ((γ−t)²+δ²)·((γ+t)²+δ²) is strictly positive for
    t > 0, t ≠ γ (`b5NoffPos`) and equals the all-nonnegative polynomial
    `b5NoffIsPolynomial` — so no δ > 0 produces a zero window (outline
    consequence (c), now machine-checked).  T2 `b5Abs` is the exact
    magnitude form of outline consequence (a):
    ‖R‖ = |pref|·exp(ω_δ/2) — an all-real prefactor times a
    constant-rate phase (‖e^{it·ω_δ}‖ = 1 exactly).

    PROVENANCE (no recall — every reference resolves):
    - Ledger: RH-PROOF-OUTLINE.md [B-5 CORE] block (statement, the
      4-line proof, consequences (a)–(d), verification record).
    - Python ref: scripts/rh/b5core_check.py (dps-30; formula vs the
      DIRECT-PRODUCT definition over the 2 on-line + 4 off-line zeros,
      vs the measured dps-15 table).
    - Record: scripts/rh/out_day010_b5core_check.txt — 12 configs
      (6 far t = c·γ*, c ∈ {10, 50, 100}, δ ∈ {0.005, 0.5};
      6 near, δ = 0.005), γ* = 999.791572 the certified zero nearest
      1000 from zeros_T300000_ext_full.txt; worst |formula−direct| =
      5.978e-26; B5-CORE CHECK PASS.
    - Record flags (flagged here, not silently harmonized):
      (1) the script's header comment says "8-zero" while its `direct`
          definition uses 2 on-line + 4 off-line = 6 zeros; the code is
          the record;
      (2) the outline's "14/14 configs" vs the 12 config rows actually
          emitted (14 counted the two WORST lines);
      (3) the "2g" near config uses t = 2γ* − 0.416856, not 2γ*
          (matching the measured-zero context at G = 3e5);
      (4) B-4 ground rules apply verbatim — see RhAttack/B4.lean header
          and day-011 §§3, 4d.

    HONESTY: an algebraic identity for products of the canonical
    factors over the stated zero SETS — it uses no property of ζ (not
    even their actual zero status) and proves neither RH nor the
    kernel-deviation bound f(δ,t) of [B-5] (that composition is B-6A's
    and needs B-3 for the actual zero set).  The float layer below
    re-derives R from the 6 factors in float64 and compares with the
    closed form and the recorded dps-30 values — an independent port
    check.

    First declaration below: `omegaD` (real): the off-line inverse-zero
    sum minus the on-line one.
-/
-- (def body in flat monomial form: (½±δ)² + γ² = ¼ ± δ + δ² + γ² —
--  identical reals; the flat form keeps the ring normalizer from seeing the
--  opaque `halfR` def constant inside the denominators (no-recall note: this
--  is what lets `hsumOff`/`hpref` close by `field_simp` + `ring` exactly).)
def omegaD (γ δ : ℝ) : ℝ :=
  (1 + 2 * δ) / (1 / 4 + δ + δ ^ 2 + γ ^ 2)
    + (1 - 2 * δ) / (1 / 4 - δ + δ ^ 2 + γ ^ 2) - 1 / (1 / 4 + γ ^ 2)

/-- The four off-line zeros, grouped as {½+δ±iγ} (PP/PM) and {½−δ±iγ} (NP/NM). -/
def rhoPP (γ δ : ℝ) : ℂ := (halfR + δ) + (γ : ℂ) * I
def rhoPM (γ δ : ℝ) : ℂ := (halfR + δ) - (γ : ℂ) * I
def rhoNP (γ δ : ℝ) : ℂ := (halfR - δ) + (γ : ℂ) * I
def rhoNM (γ δ : ℝ) : ℂ := (halfR - δ) - (γ : ℂ) * I

/-- The four off-line canonical factors at (γ,δ,t). -/
def poff (γ δ t : ℝ) : ℂ :=
  fac (rhoPP γ δ) (sLine t) * fac (rhoPM γ δ) (sLine t) *
      fac (rhoNP γ δ) (sLine t) * fac (rhoNM γ δ) (sLine t)

/-- R(s,δ) = P_off / P_on (the direct 6-zero definition). -/
def Rratio (γ δ t : ℝ) : ℂ := poff γ δ t / pairProd γ t

/-- The exact real prefactor of the closed form (T1). -/
-- (def body in flat monomial form, as `omegaD`: (½±δ)² + γ² = ¼ ± δ + δ² + γ².)
def pref (γ δ t : ℝ) : ℝ :=
  (1 / 4 + γ ^ 2) * ((γ - t) ^ 2 + δ ^ 2) * ((γ + t) ^ 2 + δ ^ 2) /
    ((γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2))

/-- Generic complex product of two real+imaginary forms, stated once so
    the proof below stays pure `ring`. -/
lemma reImProd (a b c d : ℝ) :
    ((a : ℂ) + (b : ℂ) * I) * ((c : ℂ) + (d : ℂ) * I) =
      ofReal (a * c - b * d) + ofReal (a * d + b * c) * I := by
  rw [Complex.ext_iff]
  constructor <;> (simp [ofReal_re, ofReal_im, mul_I_re, mul_I_im] <;> ring)

#check omegaD
#check rhoPP
#check rhoPM
#check rhoNP
#check rhoNM
#check poff
#check Rratio
#check pref

-- =====================================================================
-- T1 — the exact closed form  R(s,δ) = pref · e^{s·ω_δ}
-- =====================================================================

/-- The four off-line zeros are nonzero (imaginary parts ±γ). -/
theorem rhoOffNeZero (hγ : 0 < γ) (δ : ℝ) :
    rhoPP γ δ ≠ 0 ∧ rhoPM γ δ ≠ 0 ∧ rhoNP γ δ ≠ 0 ∧ rhoNM γ δ ≠ 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoPP] at this
    linarith
  · intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoPM] at this
    linarith
  · intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoNP] at this
    linarith
  · intro h
    have := congr_arg (fun z : ℂ => z.im) h
    simp [rhoNM] at this
    linarith

/-- The conjugate-pair product, for free reals: (a + i b)(a − i b) = a² + b².
    The one complex-algebra fact hga/hgb instantiate. -/
theorem conjPairProd {a b : ℝ} :
    (a + (b : ℂ) * I) * (a - (b : ℂ) * I) = ((a ^ 2 + b ^ 2 : ℝ) : ℂ) := by
  rw [Complex.ext_iff]
  constructor
  · simp [pow_two, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
      add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring
  · simp [pow_two, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
      add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring

/-- (T1) The off-line/on-line ratio collapses to a REAL signed prefactor
    times the single exponential e^{s·ω_δ}.  Holds for every real δ. -/
theorem b5Ratio (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) (δ : ℝ) :
    Rratio γ δ t = ofReal (pref γ δ t) * exp (sLine t * (omegaD γ δ : ℂ)) := by
  let N := (γ - t) ^ 2 + δ ^ 2
  let M := (γ + t) ^ 2 + δ ^ 2
  -- NOTE: flat monomial bodies ((½±δ)²+γ² expanded).  In lean4 v4.34.0-rc2
  -- a local `let` is opaque to the checker (rfl on a let-equality fails —
  -- verified 2026-09-11) and by-name dsimp/simp on lets is a no-op; the
  -- tactic normalizers (ring/nlinarith/field_simp) handle them.  Keeping
  -- the bodies flat (no defs, no powers) lets every step close.
  let DA := 1 / 4 + δ + δ ^ 2 + γ ^ 2
  let DB := 1 / 4 - δ + δ ^ 2 + γ ^ 2
  have hNpos : 0 < N := by
    have hne' : γ - t ≠ 0 := by
      rintro h
      exact hne (by linarith)
    nlinarith [sq_pos_iff.mpr hne', sq_nonneg δ]
  have hMpos : 0 < M := by
    have hgt : 0 < γ + t := add_pos hγ ht
    nlinarith [mul_pos hgt hgt, sq_nonneg δ]
  -- (flat let bodies: 0 < ¼±δ+δ²+γ² is (±) 0 ≤ (δ±½)² + 0 < γ²;
  --  nlinarith delta-reduces the local let and completes the square)
  have hDApos : 0 < DA := by
    dsimp only [DA]
    have hs : 1 / 4 + δ + δ ^ 2 = (δ + 1 / 2) ^ 2 := by ring
    have hA : 0 ≤ 1 / 4 + δ + δ ^ 2 := by rw [hs]; exact sq_nonneg (δ + 1 / 2)
    nlinarith [hA, mul_pos hγ hγ]
  have hDBpos : 0 < DB := by
    dsimp only [DB]
    have hs : 1 / 4 - δ + δ ^ 2 = (δ - 1 / 2) ^ 2 := by ring
    have hA : 0 ≤ 1 / 4 - δ + δ ^ 2 := by rw [hs]; exact sq_nonneg (δ - 1 / 2)
    nlinarith [hA, mul_pos hγ hγ]
  have hDAz : DA ≠ 0 := ne_of_gt hDApos
  have hDBz : DB ≠ 0 := ne_of_gt hDBpos
  have hDDnz : DA * DB ≠ 0 := mul_ne_zero hDAz hDBz
  have hBz : (1 / 4 + γ ^ 2 : ℝ) ≠ 0 := by
    intro h
    nlinarith [mul_pos hγ hγ]
  have hP0real : (γ ^ 2 - t ^ 2) * Bv γ ≠ 0 := pairPolyNeZero hne hγ ht
  have hP0nz : ofReal ((γ ^ 2 - t ^ 2) * Bv γ) ≠ 0 := by
    intro h
    exact hP0real (ofReal_eq_zero.mp h)
  -- (i) the off-line (ρ−s) straddles: re ±δ, im ±(γ±t)
  have hstrA1 : rhoPP γ δ - sLine t = (δ : ℂ) + (γ - t) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [rhoPP, sLine, halfR] <;> ring)
  have hstrA2 : rhoPM γ δ - sLine t = (δ : ℂ) + (-(γ + t)) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [rhoPM, sLine, halfR] <;> ring)
  have hstrB1 : rhoNP γ δ - sLine t = (-(δ) : ℂ) + (γ - t) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [rhoNP, sLine, halfR] <;> ring)
  have hstrB2 : rhoNM γ δ - sLine t = (-(δ) : ℂ) + (-(γ + t)) * I := by
    rw [Complex.ext_iff]
    constructor <;> (simp [rhoNM, sLine, halfR] <;> ring)
  -- (ii) the two group products: X ± iY, with X = δ²+γ²−t², Y = 2tδ
  -- (zzC recipe: the ext/simp list below is the `simp?` output for this
  -- exact shape; `ring` in this toolchain knows no I² = −1, so the lifting
  -- happens in simp, not in ring — verified in isolation before use.)
  let X := δ ^ 2 + γ ^ 2 - t ^ 2
  let Y := 2 * t * δ
  have hgrA : (rhoPP γ δ - sLine t) * (rhoPM γ δ - sLine t) =
      ofReal X + ofReal (-(Y)) * I := by
    rw [hstrA1, hstrA2]
    rw [Complex.ext_iff]
    constructor
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> ring
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> ring
  have hgrB : (rhoNP γ δ - sLine t) * (rhoNM γ δ - sLine t) =
      ofReal X + ofReal Y * I := by
    rw [hstrB1, hstrB2]
    rw [Complex.ext_iff]
    constructor
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> ring
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> ring
  -- (iii) the full off-line (ρ−s) product: (X+iY)(X−iY) = X²+Y² = N·M (real)
  have hNoff : (rhoPP γ δ - sLine t) * (rhoPM γ δ - sLine t) *
      (rhoNP γ δ - sLine t) * (rhoNM γ δ - sLine t) = ofReal (N * M) := by
    rw [hgrA, mul_assoc, hgrB]
    rw [Complex.ext_iff]
    constructor
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> (dsimp [X, Y, N, M]; ring)
    · simp only [neg_add_rev, mul_re, mul_im, add_re, add_im, sub_re, sub_im,
        ofReal_re, ofReal_im, I_re, I_im, mul_zero, mul_one, add_zero, zero_add,
        sub_zero, neg_re, neg_im, neg_zero, neg_mul, sub_self, ofReal_sub,
        ofReal_add, ofReal_pow, ofReal_neg, ofReal_mul, ofReal_ofNat,
        re_ofNat, im_ofNat, zero_mul, pow_two] <;> (dsimp [X, Y]; ring)
  -- (iv) the off-line zero products: (X+iγ)(X−iγ) with X real, Y = ±γ
  -- NOTE (toolchain rc quirk, verified 2026-09-11): in lean4 v4.34.0-rc2 a
  -- local `let` is OPAQUE to the checker (rfl `example (let x := 1+1 ...`
  -- fails) and to simp/dsimp by-name, but tactic normalizers (ring,
  -- nlinarith, field_simp) DO delta-reduce local lets.  Every proof step
  -- below that equates a let-bound expression with its body therefore
  -- closes with a normalizer tactic, never `exact`/`rfl`/`show`.
  have hga : rhoPP γ δ * rhoPM γ δ = ofReal DA := by
    rw [Complex.ext_iff]
    constructor
    · simp [rhoPP, rhoPM, halfR, pow_two, ofReal_re, ofReal_im, mul_I_re,
        mul_I_im, add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring
    · simp [rhoPP, rhoPM, halfR, pow_two, ofReal_re, ofReal_im, mul_I_re,
        mul_I_im, add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring
  have hgb : rhoNP γ δ * rhoNM γ δ = ofReal DB := by
    rw [Complex.ext_iff]
    constructor
    · simp [rhoNP, rhoNM, halfR, pow_two, ofReal_re, ofReal_im, mul_I_re,
        mul_I_im, add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring
    · simp [rhoNP, rhoNM, halfR, pow_two, ofReal_re, ofReal_im, mul_I_re,
        mul_I_im, add_re, add_im, sub_re, sub_im, I_re, I_im] <;> ring
  have hDoff : rhoPP γ δ * rhoPM γ δ * rhoNP γ δ * rhoNM γ δ = ofReal (DA * DB) := by
    rw [hga, mul_assoc, hgb, ← ofReal_mul DA DB]
  -- (v) the off-line inverse sums (L6 recipe: field_simp with the local
  -- sum/product equalities; `norm_num [halfR]` closes the 2·½ arithmetic)
  have hPPnz : rhoPP γ δ ≠ 0 := (rhoOffNeZero hγ δ).1
  have hPMnz : rhoPM γ δ ≠ 0 := (rhoOffNeZero hγ δ).2.1
  have hNPnz : rhoNP γ δ ≠ 0 := (rhoOffNeZero hγ δ).2.2.1
  have hNMnz : rhoNM γ δ ≠ 0 := (rhoOffNeZero hγ δ).2.2.2
  have hsumA : rhoPP γ δ + rhoPM γ δ = (2 * (halfR + δ) : ℂ) := by
    rw [Complex.ext_iff]
    constructor
    · simp [rhoPP, rhoPM, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
        add_re, add_im, sub_re, sub_im] <;> ring
    · simp [rhoPP, rhoPM, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
        add_re, add_im, sub_re, sub_im] <;> ring
  have hsumB : rhoNP γ δ + rhoNM γ δ = (2 * (halfR - δ) : ℂ) := by
    rw [Complex.ext_iff]
    constructor
    · simp [rhoNP, rhoNM, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
        add_re, add_im, sub_re, sub_im] <;> ring
    · simp [rhoNP, rhoNM, ofReal_re, ofReal_im, mul_I_re, mul_I_im,
        add_re, add_im, sub_re, sub_im] <;> ring
  have hsumAs : rhoPM γ δ + rhoPP γ δ = (2 * (halfR + δ) : ℂ) := by
    rw [add_comm, hsumA]
  have hgas : rhoPM γ δ * rhoPP γ δ = ofReal DA := by
    rw [mul_comm, hga]
  have hsumBs : rhoNM γ δ + rhoNP γ δ = (2 * (halfR - δ) : ℂ) := by
    rw [add_comm, hsumB]
  have hgbs : rhoNM γ δ * rhoNP γ δ = ofReal DB := by
    rw [mul_comm, hgb]
  -- (targets written as `ofReal` of a REAL division — a bare `(_ : ℂ)`
  --  ascription would elaborate the division in ℂ, i.e. as complex division of
  --  per-term-coerced reals, which is not definitionally ofReal-of-real and
  --  defeats later `rw`/`ring` matching)
  have hinvA : (rhoPP γ δ)⁻¹ + (rhoPM γ δ)⁻¹ = ofReal ((1 + 2 * δ) / DA) := by
    calc (rhoPP γ δ)⁻¹ + (rhoPM γ δ)⁻¹
        = (rhoPP γ δ + rhoPM γ δ) * (rhoPP γ δ * rhoPM γ δ)⁻¹ := by
          field_simp [hPPnz, hPMnz]
          ring
        _ = (2 * (halfR + δ) : ℂ) * (ofReal DA)⁻¹ := by rw [hsumA, hga]
        _ = ofReal ((1 + 2 * δ) / DA) := by
          -- (field_simp must clear the inverse of the COERCED denom; the real
          --  `DA ≠ 0` does not match `(DA : ℂ) ≠ 0` — bridge via ofReal_eq_zero)
          have hDAc : (DA : ℂ) ≠ 0 := by
            intro h
            exact hDAz (ofReal_eq_zero.mp h)
          simp [mul_inv_cancel₀ hDAc]
          norm_num [halfR]
          ring
  have hinvB : (rhoNP γ δ)⁻¹ + (rhoNM γ δ)⁻¹ = ofReal ((1 - 2 * δ) / DB) := by
    calc (rhoNP γ δ)⁻¹ + (rhoNM γ δ)⁻¹
        = (rhoNP γ δ + rhoNM γ δ) * (rhoNP γ δ * rhoNM γ δ)⁻¹ := by
          field_simp [hNPnz, hNMnz]
          ring
        _ = (2 * (halfR - δ) : ℂ) * (ofReal DB)⁻¹ := by rw [hsumB, hgb]
        _ = ofReal ((1 - 2 * δ) / DB) := by
          have hDBc : (DB : ℂ) ≠ 0 := by
            intro h
            exact hDBz (ofReal_eq_zero.mp h)
          simp [mul_inv_cancel₀ hDBc]
          norm_num [halfR]
          ring
  have hsumOff : (rhoPP γ δ)⁻¹ + (rhoPM γ δ)⁻¹ + (rhoNP γ δ)⁻¹ + (rhoNM γ δ)⁻¹ =
      ((omegaD γ δ + Bv γ) : ℂ) := by
    rw [hinvA, add_assoc, hinvB]
    -- (hinv targets sit in the ofReal image of ℝ: unfold omegaD/Bv, zeta the
    --  flat lets by name, decompose the remaining ofReal-of-a-sum with the
    --  homomorphism lemmas, and let `ring` cancel the on/off inverse terms)
    rw [omegaD, Bv]
    dsimp [DA, DB]
    simp [ofReal_add, ofReal_sub, ofReal_neg]
  -- (vi) the off-line exponential product
  have hexpl : exp (sLine t / rhoPP γ δ) * exp (sLine t / rhoPM γ δ) *
      exp (sLine t / rhoNP γ δ) * exp (sLine t / rhoNM γ δ) =
      exp (sLine t * ((omegaD γ δ + Bv γ) : ℂ)) := by
    rw [← exp_add, ← exp_add, ← exp_add,
        div_eq_mul_inv, div_eq_mul_inv, div_eq_mul_inv, div_eq_mul_inv]
    congr
    rw [← mul_add, ← mul_add, ← mul_add, hsumOff]
  -- (vii) per-factor rewrite 1 − s/ρ = (ρ−s)/ρ
  have hfac (ρ : ℂ) (hρ : ρ ≠ 0) : 1 - sLine t / ρ = (ρ - sLine t) / ρ := by
    field_simp [hρ] <;> ring
  -- (viii) the off-line polynomial part: Π(1−s/ρ) = (N·M)/(DA·DB) (real)
  have hpoly : (1 - sLine t / rhoPP γ δ) * (1 - sLine t / rhoPM γ δ) *
          (1 - sLine t / rhoNP γ δ) * (1 - sLine t / rhoNM γ δ) =
        ofReal (N * M / (DA * DB)) := by
    calc (1 - sLine t / rhoPP γ δ) * (1 - sLine t / rhoPM γ δ) *
            (1 - sLine t / rhoNP γ δ) * (1 - sLine t / rhoNM γ δ)
        = ((rhoPP γ δ - sLine t) / rhoPP γ δ) * ((rhoPM γ δ - sLine t) / rhoPM γ δ) *
            ((rhoNP γ δ - sLine t) / rhoNP γ δ) * ((rhoNM γ δ - sLine t) / rhoNM γ δ) := by
          rw [hfac (rhoPP γ δ) hPPnz, hfac (rhoPM γ δ) hPMnz,
              hfac (rhoNP γ δ) hNPnz, hfac (rhoNM γ δ) hNMnz]
        _ = (rhoPP γ δ - sLine t) * (rhoPM γ δ - sLine t) *
            (rhoNP γ δ - sLine t) * (rhoNM γ δ - sLine t) /
            (rhoPP γ δ * rhoPM γ δ * rhoNP γ δ * rhoNM γ δ) := by
          field_simp [hPPnz, hPMnz, hNPnz, hNMnz] <;> ring
        _ = ofReal (N * M) / ofReal (DA * DB) := by rw [hNoff, hDoff]
        _ = ofReal (N * M / (DA * DB)) := by rw [← ofReal_div (N * M) (DA * DB)]
  -- (ix) poff reassembled (the calc LHS must stay `poff γ δ t`)
  have hPoff : poff γ δ t =
      ofReal (N * M / (DA * DB)) * exp (sLine t * ((omegaD γ δ + Bv γ) : ℂ)) := by
    calc poff γ δ t
        = (1 - sLine t / rhoPP γ δ) * exp (sLine t / rhoPP γ δ) *
            (1 - sLine t / rhoPM γ δ) * exp (sLine t / rhoPM γ δ) *
            (1 - sLine t / rhoNP γ δ) * exp (sLine t / rhoNP γ δ) *
            (1 - sLine t / rhoNM γ δ) * exp (sLine t / rhoNM γ δ) := by
          dsimp [poff, fac]
          ring
        _ = (1 - sLine t / rhoPP γ δ) * (1 - sLine t / rhoPM γ δ) *
            (1 - sLine t / rhoNP γ δ) * (1 - sLine t / rhoNM γ δ) *
            (exp (sLine t / rhoPP γ δ) * exp (sLine t / rhoPM γ δ) *
             exp (sLine t / rhoNP γ δ) * exp (sLine t / rhoNM γ δ)) := by
          ring
        _ = ofReal (N * M / (DA * DB)) * exp (sLine t * ((omegaD γ δ + Bv γ) : ℂ)) := by
          rw [hpoly, hexpl]
  -- (x) the on-line side (B-4 T1, black box) and the split of e^{s(ω+B)}
  have hPon : pairProd γ t = ofReal ((γ ^ 2 - t ^ 2) * Bv γ) * exp (sLine t * (Bv γ : ℂ)) :=
    pairClosedForm hγ ht
  have hE12 : exp (sLine t * ((omegaD γ δ + Bv γ) : ℂ)) =
      exp (sLine t * (omegaD γ δ : ℂ)) * exp (sLine t * (Bv γ : ℂ)) := by
    rw [show sLine t * ((omegaD γ δ + Bv γ) : ℂ) =
        sLine t * (omegaD γ δ : ℂ) + sLine t * (Bv γ : ℂ) from by ring]
    rw [exp_add]
  have hE2nz : exp (sLine t * (Bv γ : ℂ)) ≠ 0 := exp_ne_zero (sLine t * (Bv γ : ℂ))
  -- (xi) main calc: cancel e^{s·Bv}, absorb A/B into one ofReal
  calc Rratio γ δ t
      = poff γ δ t / pairProd γ t := by rw [Rratio]
      _ = (ofReal (N * M / (DA * DB)) * exp (sLine t * ((omegaD γ δ + Bv γ) : ℂ))) /
        (ofReal ((γ ^ 2 - t ^ 2) * Bv γ) * exp (sLine t * (Bv γ : ℂ))) := by
        rw [hPoff, hPon]
      _ = (ofReal (N * M / (DA * DB)) * exp (sLine t * (omegaD γ δ : ℂ)) *
          exp (sLine t * (Bv γ : ℂ))) /
        (ofReal ((γ ^ 2 - t ^ 2) * Bv γ) * exp (sLine t * (Bv γ : ℂ))) := by
        rw [hE12]
        ring
      _ = (ofReal (N * M / (DA * DB)) / ofReal ((γ ^ 2 - t ^ 2) * Bv γ)) *
          exp (sLine t * (omegaD γ δ : ℂ)) := by
        field_simp [hP0nz, hE2nz] <;> ring
      _ = ofReal (N * M / (DA * DB) / ((γ ^ 2 - t ^ 2) * Bv γ)) *
          exp (sLine t * (omegaD γ δ : ℂ)) := by
        rw [← ofReal_div (N * M / (DA * DB)) ((γ ^ 2 - t ^ 2) * Bv γ)]
      _ = ofReal (pref γ δ t) * exp (sLine t * (omegaD γ δ : ℂ)) := by
        have hpref : N * M / (DA * DB) / ((γ ^ 2 - t ^ 2) * Bv γ) = pref γ δ t := by
          dsimp [N, M, DA, DB, pref, Bv]
          field_simp [hDDnz, hP0real, hBz] <;> (norm_num [halfR]; ring)
        rw [hpref]

-- =====================================================================
-- T2/T3 — exact magnitude and sign facts (outline consequences (a), (c))
-- =====================================================================

/-- (T2) The exact magnitude form (outline (a), all-real part):
    ‖R‖ = |pref|·exp(ω_δ/2) — the constant-rate phase has unit modulus. -/
theorem b5Abs (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) (δ : ℝ) :
    ‖Rratio γ δ t‖ = |pref γ δ t| * Real.exp (omegaD γ δ / 2) := by
  have hRe : (sLine t * (omegaD γ δ : ℂ)).re = omegaD γ δ / 2 := by
    simp [sLine, ofReal_re, ofReal_im, mul_I_re, mul_I_im]
    <;> (norm_num [halfR]; ring)
  have hexpN : ‖exp (sLine t * (omegaD γ δ : ℂ))‖ = Real.exp (omegaD γ δ / 2) := by
    rw [Complex.norm_exp, hRe]
  calc ‖Rratio γ δ t‖
      = ‖ofReal (pref γ δ t) * exp (sLine t * (omegaD γ δ : ℂ))‖ := by
        rw [b5Ratio hγ ht hne δ]
      _ = ‖ofReal (pref γ δ t)‖ * ‖exp (sLine t * (omegaD γ δ : ℂ))‖ := by
        rw [Complex.norm_mul]
      _ = |pref γ δ t| * Real.exp (omegaD γ δ / 2) := by
        rw [Complex.norm_real, hexpN] <;> simp

/-- (T3a) The off-line numerator is the all-nonnegative δ-polynomial
    (outline (c)) — used for the no-zero-window statement. -/
theorem b5NoffIsPolynomial (γ t δ : ℝ) :
    ((t - γ) ^ 2 + δ ^ 2) * ((t + γ) ^ 2 + δ ^ 2) =
      (t ^ 2 - γ ^ 2) ^ 2 + 2 * δ ^ 2 * (t ^ 2 + γ ^ 2) + δ ^ 4 := by ring

/-- (T3b) No zero window: for t > 0, t ≠ γ the off-line numerator is
    strictly positive for EVERY real δ — no δ > 0 annihilates it. -/
theorem b5NoffPos (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) (δ : ℝ) :
    0 < ((t - γ) ^ 2 + δ ^ 2) * ((t + γ) ^ 2 + δ ^ 2) := by
  have h1 : 0 < (t - γ) ^ 2 := by
    have hne' : t - γ ≠ 0 := by
      rintro h
      exact hne (by linarith)
    exact sq_pos_iff.mpr hne'
  have h2 : 0 < (t + γ) ^ 2 := by
    nlinarith [show 0 < (t + γ) * (t + γ) from mul_pos (add_pos ht hγ) (add_pos ht hγ)]
  have hX : 0 < (t - γ) ^ 2 + δ ^ 2 := by nlinarith [h1]
  have hY : 0 < (t + γ) ^ 2 + δ ^ 2 := by nlinarith [h2]
  exact mul_pos hX hY

/-- (T3c) The only sign carrier: pref < 0 ⟺ t > γ — the sign flip of
    (γ²−t²) at t = γ is the ONLY branch in the closed form. -/
theorem b5PrefSign (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) (δ : ℝ) :
    (pref γ δ t < 0) ↔ t > γ := by
  simp only [pref]
  have hNpos : 0 < (1 / 4 + γ ^ 2) * ((γ - t) ^ 2 + δ ^ 2) * ((γ + t) ^ 2 + δ ^ 2) := by
    have hA : 0 < 1 / 4 + γ ^ 2 := by nlinarith [mul_pos hγ hγ]
    have hB : 0 < (γ - t) ^ 2 + δ ^ 2 := by
      have hne' : γ - t ≠ 0 := by
        rintro h
        exact hne (by linarith)
      nlinarith [sq_pos_iff.mpr hne']
    have hC : 0 < (γ + t) ^ 2 + δ ^ 2 := by
      have hgt : 0 < γ + t := add_pos hγ ht
      nlinarith [mul_pos hgt hgt]
    have h1 : 0 < (1 / 4 + γ ^ 2) * ((γ - t) ^ 2 + δ ^ 2) := mul_pos hA hB
    exact mul_pos h1 hC
  -- (flat monomial form of (½±δ)² + γ², matching the `pref` def body)
  have hDApos : 0 < 1 / 4 + δ + δ ^ 2 + γ ^ 2 := by
    have hs : 1 / 4 + δ + δ ^ 2 = (δ + 1 / 2) ^ 2 := by ring
    have hA : 0 ≤ 1 / 4 + δ + δ ^ 2 := by rw [hs]; exact sq_nonneg (δ + 1 / 2)
    nlinarith [hA, mul_pos hγ hγ]
  have hDBpos : 0 < 1 / 4 - δ + δ ^ 2 + γ ^ 2 := by
    have hs : 1 / 4 - δ + δ ^ 2 = (δ - 1 / 2) ^ 2 := by ring
    have hA : 0 ≤ 1 / 4 - δ + δ ^ 2 := by rw [hs]; exact sq_nonneg (δ - 1 / 2)
    nlinarith [hA, mul_pos hγ hγ]
  have hP0real : (γ ^ 2 - t ^ 2) * Bv γ ≠ 0 := pairPolyNeZero hne hγ ht
  apply Iff.intro
  · -- pref < 0  =>  t > γ  (contrapositive: t < γ makes the denominator > 0,
      --  so pref ≥ 0)
    intro h
    by_contra hgt
    have hlt : t < γ := lt_of_le_of_ne (not_lt.mp hgt) hne
    have hγ2t : 0 < γ ^ 2 - t ^ 2 := by
      rw [sq_sub_sq]
      exact mul_pos (add_pos hγ ht) (by linarith [hlt])
    have hD0 : 0 < (γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) := by
      have h1 : 0 < (γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) := mul_pos hγ2t hDApos
      exact mul_pos h1 hDBpos
    have hdiv : 0 ≤ (1 / 4 + γ ^ 2) * ((γ - t) ^ 2 + δ ^ 2) * ((γ + t) ^ 2 + δ ^ 2) /
        ((γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2)) := by
      apply div_nonneg (le_of_lt hNpos)
      exact le_of_lt hD0
    linarith [hdiv, h]
  · -- t > γ  =>  pref < 0  (numerator > 0, denominator < 0)
    intro htg
    have hγ2t : γ ^ 2 - t ^ 2 < 0 := by
      rw [sq_sub_sq, mul_comm]
      exact mul_neg_of_neg_of_pos (sub_neg.mpr htg) (add_pos hγ ht)
    have hD1 : (γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) < 0 :=
      mul_neg_of_neg_of_pos hγ2t hDApos
    have hDneg : (γ ^ 2 - t ^ 2) * (1 / 4 + δ + δ ^ 2 + γ ^ 2) * (1 / 4 - δ + δ ^ 2 + γ ^ 2) < 0 :=
      mul_neg_of_neg_of_pos hD1 hDBpos
    rw [div_eq_mul_inv]
    exact mul_neg_of_pos_of_neg hNpos (inv_lt_zero.mpr hDneg)

#check b5Ratio
#check b5Abs
#check b5NoffIsPolynomial
#check b5NoffPos
#check b5PrefSign

-- PART 4 — the runtime cross-check (float64, classless, as in B4/E7a).
-- 12 recorded configs (out_day010_b5core_check.txt): for γ* = 999.791572
-- (the certified zero nearest 1000, zeros_T300000_ext_full.txt), the
-- closed form (T1) vs the DIRECT 6-factor definition, both in float64,
-- compared on |R−1| (the recorded quantity).  A correct port shows
-- relative differences ~1e-13 (double roundoff of the two evaluation
-- orders) and matches the recorded dps-30 7-decimal print at the
-- print's own scale.  A transcription error shows O(1).

namespace B5Float
def F := Float × Float  -- (re, im), deliberately class-free

def Fadd (a b : F) : F := (a.1 + b.1, a.2 + b.2)
def Fsub (a b : F) : F := (a.1 - b.1, a.2 - b.2)
def Fmul (a b : F) : F := (a.1 * b.1 - a.2 * b.2, a.1 * b.2 + a.2 * b.1)
def Fdiv (a b : F) : F := by
  let d := b.1 * b.1 + b.2 * b.2
  exact ((a.1 * b.1 + a.2 * b.2) / d, (a.2 * b.1 - a.1 * b.2) / d)
def Freal (r : Float) : F := (r, 0.0)
def Fexp (z : F) : F := by
  let e := z.1.exp
  exact (e * z.2.cos, e * z.2.sin)

/-- ‖R − 1‖ for a complex float. -/
def Fabs1 (a : F) : Float := by
  let d := Fsub a (Freal 1.0)
  exact (d.1 * d.1 + d.2 * d.2).sqrt

/-- γ* as recorded. -/
def G5 : Float := 999.791572

/-- The T1 closed form in float64: pref · e^{s·ω_δ},  s = ½ + it. -/
def closed (d t : Float) : F := by
  let g := G5
  let w := (1 + 2 * d) / ((0.5 + d) * (0.5 + d) + g * g) +
      (1 - 2 * d) / ((0.5 - d) * (0.5 - d) + g * g) - 1 / (0.25 + g * g)
  let p := (0.25 + g * g) * ((g - t) * (g - t) + d * d) * ((g + t) * (g + t) + d * d) /
      ((g * g - t * t) * ((0.5 + d) * (0.5 + d) + g * g) * ((0.5 - d) * (0.5 - d) + g * g))
  exact Fmul (Freal p) (Fexp (0.5 * w, t * w))

/-- The direct 6-factor definition in float64: P_off / P_on over the
    2 on-line + 4 off-line zeros. -/
def direct (d t : Float) : F := by
  let g := G5
  let s := (0.5, t)
  let fac (rho : F) : F := Fmul (Fsub (Freal 1.0) (Fdiv s rho)) (Fexp (Fdiv s rho))
  let on := Fmul (fac (0.5, g)) (fac (0.5, -g))
  let off := Fmul (Fmul (fac (0.5 + d, g)) (fac (0.5 + d, -g)))
      (Fmul (fac (0.5 - d, g)) (fac (0.5 - d, -g)))
  exact Fdiv off on

/-- The 12 recorded configs (t, δ, recorded |R−1|_formula, 7 decimal
    places).  far: t = c·γ*, c ∈ {10,50,100}, δ ∈ {0.005, 0.5};
    near: t ∈ {γ*±0.25/1/10}, 2γ*−0.416856 (the record's "2g" — see the
    header flag), δ = 0.005. -/
def pts : List (Float × Float × Float) := by
  let g := G5
  exact [
    (10 * g, 0.005, 99.9999752), (10 * g, 0.5, 99.9999262),
     (50 * g, 0.005, 2499.9993751), (50 * g, 0.5, 2499.9981257),
     (100 * g, 0.005, 9999.9975029), (100 * g, 0.5, 9999.9925023),
     (g - 1, 0.005, 0.9980005), (g - 0.25, 0.005, 0.9994998),
     (g + 0.25, 0.005, 1.0005004), (g + 1, 0.005, 1.0020015),
     (g + 10, 0.005, 1.0201042), (2 * g - 0.416856, 0.005, 3.9983317)]

def go (l : List (Float × Float × Float)) (w1 w2 : Float) : IO (Float × Float) :=
  match l with
  | [] => pure (w1, w2)
  | (t, d, rec) :: r => do
    let a := Fabs1 (closed d t)
    let b := Fabs1 (direct d t)
    let dCD := (a - b).abs / a
    let dRec := (a - rec).abs / rec
    -- 4.34 s! has no float format specs: report the RELATIVE deviations
    -- scaled (dCD by 1e12, dRec by 1e6 — the 6-display-digit forms are
    -- the significant digits).
    IO.println s!"  t={t}  d={d}:  |R-1| closed={a}  direct={b}  recorded={rec}  \
dCD_rel·1e12={dCD * 1e12}  dRec_rel·1e6={dRec * 1e6}"
    go r (max w1 dCD) (max w2 dRec)

def run : IO (Float × Float) := do
  let w ← go pts 0.0 0.0
  if w.1 ≤ 1e-12 && w.2 ≤ 1e-6 then
    IO.println s!"B-5 CROSS-CHECK PASS: worst dCD_rel·1e12 = {w.1 * 1e12}, \
worst dRec_rel·1e6 = {w.2 * 1e6} (thresholds 1e-12 / 1e-6, 12/12 points)"
  else
    IO.println s!"B-5 CROSS-CHECK FAIL: worst dCD_rel·1e12 = {w.1 * 1e12}, \
worst dRec_rel·1e6 = {w.2 * 1e6}"
  pure w

end B5Float

end
