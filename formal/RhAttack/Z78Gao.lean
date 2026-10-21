import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu
import RhAttack.Z78Track

open Real Set Complex

/-!
**Z78Gao — [Z78G]: the QuasiRiemannTracker five-step-affine
frontier input (the all-Dirichlet half-plane at 0.8748087),
and its strip corollary.**

PROVENANCE (no recall — every reference resolves):
  Source:  QuasiRiemannTracker (github.com/GTimG/
           QuasiRiemannTracker), record
           `gao-five-step-affine-20261020` (PR #68,
           Zhongpai Gao / Gaozhongpai), MERGED
           2026-10-21T07:16:31Z, first verified
           2026-10-21T02:06:55Z, status `framework-verified`;
           source commit
           f07bb2418990a9976c0da5f65bb6a7a77da94c9a.
           Tracker live catalogue 2026-10-21: this record is
           the CURRENT TOP ENTRY (smallest theta on the
           25-record board), strictly stronger than the
           previously adopted [Z78T] frontier
           (two-level-affine-20261019, 0.874817065).
  Math:    an all-Dirichlet zero-free half-plane at the
           CERTIFIED RATIONAL boundary
           `8748087 / 10000000 = 0.8748087`:
             for every q >= 1, every complex Dirichlet
             character χ mod q (Mathlib's
             `DirichletCharacter.LFunction`), and every
             s with `8748087/10^7 < s.re`,
             `¬ (χ = 1 ∧ s = 1) → L(χ, s) ≠ 0`
           (the principal pole (χ = 1, s = 1) excluded; the
           Riemann zeta is the case χ = 1).  Method (record
           description, preserved): a finite-depth affine
           argument through FIVE affine stages that follows
           LOW continuations and counts returned HIGH
           histories jointly with one final density payment;
           both the detector and the weighted numerator use
           an ACTUAL uniformly constructed root moment
           (`Cycle153Endpoint.actualRootMomentFactory` —
           "the moment factory is constructed from actual
           finite native sources; it is not a hypothesis of
           this theorem"); the finite backward induction,
           all-height split, source thresholds and canonical
           endpoint are supplied as Lean proofs.  Builds on
           (record `builds_on` list, 10 records, in
           dependency order as declared): openai-baseline,
           akashlevy-20261009-weighted-numerator,
           cycle25-quartic-20261010, cycle61-c0125139,
           radical-asymmetric-count-20261014,
           detector-affine-c0125154,
           gao-directional-affine-20261016,
           gao-balanced-marked-20261017,
           no-hardcoding-20261017,
           two-level-affine-20261019 — the direct DESCENDANT
           of [Z78T]; the candidate tree (1514 Lean files,
           1515 with metadata.json) is self-contained,
           inlining its copies of the Cycle25/Cycle63
           framework (inherited notices retained,
           Apache-2.0).
  Scale:   1514 Lean modules in the candidate; the two
           `src/Submissions` dependency subtrees
           (openai_baseline: 2927 files,
           akashlevy_20261009_weighted_numerator: 228
           files) are BYTE-IDENTICAL at source commit
           f07bb241... to the copies replayed for [Z78T] in
           0134 (checked 2026-10-21).
  VERIFICATION STATUS (tracker certificate
    `certificates/gao-five-step-affine-20261020.json`,
    retrieved 2026-10-21):
    * `theta_exact = "8748087/10000000"`, verified
      2026-10-21T02:06:55Z, kernels: Lean default, nanoda,
      con-ron; report run 39514163334 (attempt 1),
      report_sha256 e7221b03... — the tracker's protected
      admission pipeline (three independent kernels plus
      the statement comparator), after which the record was
      merged and published as the new board top;
    * verification_note: "Comparator checked the canonical
      all-Dirichlet statement at 8748087/10000000 for the
      submitted commit. Lean, NanoDa and con-ron accepted
      the proof in the standard sandbox";
    * SECOND-PARTY INDEPENDENT REPLAY (this program's
      standing gate for every adoption — the B6 section-8
      protocol, demonstrated in 0132/0134): assembled in
      this environment from the exact source commit
      (1514 candidate files sha256-guarded, entry-point
      byte-identity verified against the raw GitHub fetch,
      dependency subtrees byte-identity verified against the
      0134 replay tree) and compiled module-by-module in
      dependency order against the warm standard
      environment (Lean 4.34.1 pinned; mathlib @
      d13f23b723, PrimeNumberTheoremAnd @ c39a7511 (+ the
      B6-audited patch), rellich-kondrachov @ 70f85d4c
      (+ the B6-audited patch):
      **PASS, 2026-10-21** — Stage C: 4669/4669 modules
      (1514 candidate + the two byte-identical Submissions
      subtrees) compiled from source in dependency order,
      0 failures, 3089s; Stage D1: the one-line kernel
      bridge to `Candidate.bound` type-checks against the
      canonical all-Dirichlet statement at exactly
      `8748087/10000000` (statement match); Stage D2: the
      axiom cone of the canonical statement is exactly
      `[propext, Classical.choice, Quot.sound]` (the
      standard set — same footing as the 0132/0134
      replays of [Z78L]/[Z78T]); Stage D3: 0 `sorry`
      tokens in the 1514-file candidate cone.  Record:
      tmp/b6audit/tracker/gao5_replay/stageC_summary.json
      + stageD log/axioms; deviations from the official
      receipt (default kernel only — the official run
      also used nanoda and con-ron; no bwrap sandbox;
      external footprint rebuilt from source) recorded
      and immaterial to the result.
  STATUS IN THIS PROGRAM:  a NAMED EXTERNAL INPUT of the
  same class as [Z78] / [Z78L] / [Z78T] — a kernel-verified
  external theorem, entered only as a hypothesis.  The zeta
  statement consumed here (χ = 1, pole guard `s ≠ 1`, inert
  on the pinned Mathlib where `riemannZeta_one_ne_zero`) is
  a direct CONSEQUENCE of the verified all-Dirichlet
  statement.  The boundary is the exact rational
  8748087/10^7 itself (the record's Lean statement already
  works at the rational — no bracketing).
  SNAPSHOT CAVEAT:  the tracker's board is a moving
  frontier — this record is the verified state as of
  2026-10-21; this is the SECOND supersession the chain has
  absorbed (0133: [Z78] -> [Z78T]; now [Z78T] -> [Z78G]),
  by the same B6 section-8 mechanism the 0141 ceiling
  analysis predicted was the ONLY way the record could
  move (a new structural cycle, not tuning of cycle63).
  No RH claim anywhere: this is a zero-free half-plane,
  still 0.3748087 away from the critical line in off-line
  distance.  Still far from 1/2.
-/

namespace Z78Gao

/-- The certified rational boundary: the tracker record
    `gao-five-step-affine-20261020` proves its all-Dirichlet
    statement at exactly `8748087 / 10^7` (see header).
    Exact: `8748087 / 10000000 = 0.8748087`. -/
noncomputable def gaoUpper : ℝ := (8748087 : ℝ) / 10 ^ 7

/-- The off-line distance bound it yields: an off-pair zero
    sits in `[1 - gaoUpper, gaoUpper] x C` (functional
    equation), hence `d0 = |Re - 1/2| <= gaoUpper - 1/2`.
    Exact value: `3748087 / 10^7 = 0.3748087 < qxD0max
    < 3/8`. -/
noncomputable def gaoD0max : ℝ := gaoUpper - 1 / 2

/-- The boundary is strictly below the [Z78T] boundary
    (norm_num certificate, cross-multiplication:
    8748087 · 200000000 < 174963413 · 10^7): this is what
    makes [Z78G] a strict strengthening of [Z78T] — and
    transitively of [Z78L] and [Z78]. -/
theorem gaoUpper_lt_qx : gaoUpper < Z78Track.qxUpper := by
  dsimp only [gaoUpper, Z78Track.qxUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78T]
    off-pair bound (no numeric work: subtraction is
    monotone). -/
theorem gaoD0max_lt_qxD0max : gaoD0max < Z78Track.qxD0max := by
  dsimp only [gaoD0max, Z78Track.qxD0max]
  exact sub_lt_sub_right gaoUpper_lt_qx (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all
    predecessors by transitivity): the open face genuinely
    shrinks. -/
theorem gaoD0max_lt_38 : gaoD0max < 3 / 8 :=
  lt_trans gaoD0max_lt_qxD0max Z78Track.qxD0max_lt_38

/-- The [Z78G] named external input (kernel-verified; see
    header for provenance and status).  The Riemann zeta
    function (Mathlib's `riemannZeta` — the χ = 1 case of
    the verified all-Dirichlet statement) is zero-free in
    the half-plane `Re s > gaoUpper`; the principal-pole
    guard `s ≠ 1` is carried from the statement's
    `¬ (χ = 1 ∧ s = 1)` clause (inert on the pinned
    Mathlib, where `riemannZeta_one_ne_zero`).  This is a
    CONSEQUENCE form of the verified statement (χ = 1
    specialization), hence a valid named input of the
    [Z78Liu] pattern. -/
def externalZeroFree78Gao : Prop :=
  ∀ (s : ℂ), gaoUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78G] STRICTLY STRENGTHENS [Z78T]: zero-free
    on `Re s > gaoUpper` (with `gaoUpper < qxUpper`)
    implies zero-free on `Re s > qxUpper`.  The pole guard
    `s ≠ 1` is carried through verbatim; the guardless
    [Z78] form follows transitively, where the guard is
    discharged by `riemannZeta_one_ne_zero` in
    `Z78Liu.extLiu_implies_ext78`. -/
theorem extGao_implies_extTrack (hzG : externalZeroFree78Gao) :
    Z78Track.externalZeroFree78Track := by
  intro s hs hguard
  exact hzG s (lt_trans gaoUpper_lt_qx hs) hguard

/-- (PROVEN)  [Z78G] STRICTLY STRENGTHENS [Z78L]
    (transitivity through [Z78T]). -/
theorem extGao_implies_extLiu (hzG : externalZeroFree78Gao) :
    Z78Liu.externalZeroFree78Liu :=
  Z78Track.extTrack_implies_extLiu (extGao_implies_extTrack hzG)

/-- (PROVEN)  [Z78G] STRICTLY STRENGTHENS [Z78]
    (transitivity through [Z78T] and [Z78L]). -/
theorem extGao_implies_ext78 (hzG : externalZeroFree78Gao) :
    Z78.externalZeroFree78 :=
  Z78Track.extTrack_implies_ext78 (extGao_implies_extTrack hzG)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - gaoUpper <= Re <= gaoUpper` under
    [Z78G].  Identical argument to
    `Z78Track.zetaZeroStripTrack` with the sharper
    boundary: upper edge = [Z78G] itself; lower edge = the
    functional equation (all factors non-zero for a
    non-real point) pushes `zeta(1 - rho) = 0`, and [Z78G]
    applied to `1 - rho` gives the lower edge.  The pole
    guard is discharged by non-reality (upper edge) and
    `1 - rho ≠ 1` (lower edge). -/
theorem zetaZeroStripGao (hzG : externalZeroFree78Gao) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - gaoUpper ≤ ρ.re ∧ ρ.re ≤ gaoUpper := by
  have h1neρ : (1 : ℂ) - ρ ≠ 1 := by
    intro h
    have hρ0 : ρ = 0 := by
      have := congr_arg (· + ρ) h
      rw [sub_add_cancel] at this
      have := congr_arg (· - (1 : ℂ)) this
      ring_nf at this
      exact this.symm
    exact hρim (by rw [hρ0]; exact zero_im)
  have hρne1 : ρ ≠ 1 := by
    intro heq
    exact hρim (by rw [heq]; norm_num)
  have hneNm : ∀ n : ℕ, (1 : ℂ) - ρ ≠ -n := by
    intro n hn
    have := congr_arg (· + ρ) hn
    rw [sub_add_cancel] at this
    have h1 : ρ = (1 : ℂ) + (n : ℂ) := by
      have := congr_arg (· + (n : ℂ)) this
      ring_nf at this
      exact this.symm
    have h0 : ρ.im = 0 := by
      rw [h1, add_im, one_im]
      have h2 : ((n : ℕ) : ℂ) = (((n : ℕ) : ℝ) : ℂ) := rfl
      rw [h2, ofReal_im]
      simp
    exact hρim h0
  have hfe : riemannZeta ρ =
      2 * (2 * π) ^ (-(1 - ρ)) * Gamma (1 - ρ) *
      cos ((π : ℂ) * (1 - ρ) / 2) * riemannZeta (1 - ρ) := by
    simpa using riemannZeta_one_sub hneNm h1neρ
  have hc2p : (2 * π : ℂ) ≠ 0 := by
    intro h
    rw [mul_eq_zero] at h
    rcases h with h2 | hπ
    · have h2n : (2 : ℂ) ≠ 0 := by
        intro h2b
        have h2re : (2 : ℂ).re = (2 : ℝ) := by norm_num
        have := congr_arg Complex.re h2b
        rw [h2re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        exact (by norm_num : (2 : ℝ) ≠ 0) this
      exact h2n h2
    · have hπn : (π : ℂ) ≠ 0 := by
        intro hπb
        have := congr_arg Complex.re hπb
        rw [ofReal_re, show (0 : ℂ).re = (0 : ℝ) from by norm_num] at this
        nlinarith [Real.pi_pos]
      exact hπn hπ
  have hexp : (2 * π : ℂ) ^ (-(1 - ρ)) ≠ 0 :=
    cpow_ne_zero_iff.mpr (Or.inl hc2p)
  have hgm : Gamma (1 - ρ) ≠ 0 :=
    Gamma_ne_zero hneNm
  have hcos : cos ((π : ℂ) * (1 - ρ) / 2) ≠ 0 := by
    intro h
    obtain ⟨k, hk⟩ := (Complex.cos_eq_zero_iff).1 h
    field_simp [show (π : ℂ) ≠ 0 from by
      intro h; simp only [Complex.ext_iff] at h; exact (Real.pi_pos).ne' h.1] at hk
    have hρ' : ρ = -(2 * ↑k : ℂ) := by
      have := congr_arg (· - (1 : ℂ)) hk
      ring_nf at this
      rw [← neg_inj, neg_neg]
      rw [mul_comm] at this
      exact this
    have h0 : ρ.im = 0 := by
      rw [hρ', neg_im]
      have h1r : ((2 * k : ℤ) : ℝ) = 2 * (k : ℝ) := by norm_num
      have h2 : ((↑(2 * k : ℤ)) : ℂ) = (↑(2 * k : ℝ) : ℂ) := by exact_mod_cast h1r
      simpa [h2] using (ofReal_im (2 * (k : ℝ)))
    exact hρim h0
  have h1rho0 : riemannZeta (1 - ρ) = 0 := by
    by_contra hnz
    have hzρ : riemannZeta ρ ≠ 0 := by
      rw [hfe]
      refine mul_ne_zero ?_ hnz
      refine mul_ne_zero ?_ hcos
      refine mul_ne_zero ?_ hgm
      exact mul_ne_zero (by norm_num : (2 : ℂ) ≠ 0) hexp
    exact hzρ hρ
  have hlo : 1 - gaoUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - gaoUpper := not_le.mp h
    have hc : gaoUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hzG (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ gaoUpper := by
    by_contra h
    exact (hzG ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78G]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= gaoD0max` — the sharp five-step value
    (zeros sit in `[1 - gaoUpper, gaoUpper]`, so
    `|Re - 1/2| <= gaoUpper - 1/2`, both edges the same
    distance `gaoD0max` from the line).  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78G]. -/
theorem offPairD0leGao (q : ZeroSet) (hzG : externalZeroFree78Gao)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ gaoD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripGao hzG ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ gaoD0max := by
    rw [abs_le]
    constructor
    · dsimp only [gaoD0max]
      nlinarith [hstrip.2]
    · dsimp only [gaoD0max]
      nlinarith [hstrip.1]
  simpa using hle

/-- Data gates (Float world; the Real forms carry the
    theorems above).  Computed from the certified
    constants: `1 - gaoUpper = 0.1251913`,
    `gaoD0max = gaoUpper - 1/2 = 0.3748087`. -/
def zeroFreeThetaGao : Float := 0.8748087
def stripLoGao : Float := 0.1251913
def offPairD0MaxGao : Float := 0.3748087
#eval zeroFreeThetaGao
#eval stripLoGao
#eval offPairD0MaxGao

end Z78Gao
