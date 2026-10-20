import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu

open Real Set Complex

/-!
**Z78Track — [Z78T]: the QuasiRiemannTracker frontier input
(the two-level-affine all-Dirichlet half-plane), and its strip
corollary.**

PROVENANCE (no recall — every reference resolves):
  Source:  QuasiRiemannTracker (github.com/GTimG/
           QuasiRiemannTracker), record
           `two-level-affine-20261019` (PR #67, ArviFoxy),
           MERGED 2026-10-20 (tracker HEAD d6103b24af1e...),
           status `framework-verified`, label `new-bound`;
           tracker live catalogue as of 2026-10-20 (25 records;
           this is the current top entry, the smallest
           theta on the board).
  Math:    an all-Dirichlet zero-free half-plane at the
           CERTIFIED RATIONAL boundary
           `174963413 / 200000000 = 0.874817065`:
             for every q >= 1, every complex Dirichlet
             character χ mod q (Mathlib's
             `DirichletCharacter.LFunction`), and every
             s with `174963413/200000000 < s.re`,
             `¬ (χ = 1 ∧ s = 1) → L(χ, s) ≠ 0`
           (the principal pole (χ = 1, s = 1) excluded; the
           Riemann zeta is the case χ = 1).  The class bound
           is computed IN THE LEAN KERNEL: it lies in the
           interval [0.874817064464, 0.874817064465] and the
           9-digit claim is its ceiling (bracket, argmin and
           the junction positions 0.638012 / 0.702651 /
           0.04005052 are all kernel-proven; no pasted
           constants — the tracker's no-hardcoding check
           passes).  The proof builds ON the tracker's
           foundation records: openai-baseline (the OAI 7/8
           half-plane, the same OAI 003 source under the B6
           audit), Akash Levy's weighted numerator (PR 6),
           Gao's balanced marked ledger (PR 63), Collet's
           affine step (cycle 61, PR 42) and the
           radical-asymmetric count (PR 50); the method is a
           second affine step for the LOW children (the
           record's own description, preserved in the
           modules).
  Scale:   923 files, 922 Lean modules, 127,695 added lines;
           Apache-2.0 with inherited notices.
  VERIFICATION STATUS (tracker catalogue verification_note,
    as of 2026-10-20, plus the PR #67 verification block;
    re-inspected for this module, 2026-10-20):
    * "Comparator checked the canonical all-Dirichlet
      statement at 174963413/200000000 for the submitted
      commit. Lean, NanoDa and con-ron accepted the proof in
      the standard sandbox" — the tracker's protected
      admission pipeline (three independent kernels plus the
      statement comparator), after which the result was
      merged and published as a new board bound;
    * PR #67's own verification block: clean build of all
      922 modules (pinned Lean 4.34.1, no errors, no sorry),
      `Candidate.bound` depending only on `propext`,
      `Classical.choice`, `Quot.sound`; independent kernels
      (lean4export, NanoDa, con-ron — 132,192 declarations
      accepted) run against the canonical statement;
      923-file byte identity; the tracker's pinned
      tooling (tool-pins.json: Palomar sandbox and every
      kernel binary sha256-locked) makes the pipeline
      reproducible;
    * recorded caveats kept on file: the kernel runs are
      those of the tracker's protected workflow and of the
      submitter (PR #67 notes that if the hosted worker is
      single-threaded, the run rests on the submitter's
      independently verified local execution — the same
      producer-run posture as the [Z78L] recorded replay);
      an independent replay of the submission in this
      environment is QUEUED (machine step after this
      module); the deep analytic foundation is the OAI 003
      source under the B6 audit — B6 item 5 (the 199-page
      paper reading) underwrites this record as it
      underwrites [Z78] and [Z78L].
  STATUS IN THIS PROGRAM:  a NAMED EXTERNAL INPUT of the same
  class as [Z78] / [Z78L] — a kernel-verified external
  theorem, entered only as a hypothesis.  The zeta statement
  consumed here (χ = 1, pole guard `s ≠ 1`, inert on the
  pinned Mathlib where `riemannZeta_one_ne_zero`) is a direct
  CONSEQUENCE of the verified all-Dirichlet statement.  The
  boundary is the exact rational 174963413/200000000 itself
  (no algebraic constant to bracket — the record's Lean
  statement already works at the rational).
  SNAPSHOT CAVEAT:  the tracker's board is a moving frontier
  — this record is the verified state as of 2026-10-20; a
  successor snapshot supersedes it mechanically (this
  module's B14 pattern is the upgrade path).  No RH claim
  anywhere: this is a zero-free half-plane, still 0.374817065
  away from the critical line in off-line distance.  Still
  far from 1/2.
-/

namespace Z78Track

/-- The certified rational boundary: the tracker record
    `two-level-affine-20261019` proves its all-Dirichlet
    statement at exactly `174963413 / 200000000` (see header).
    Exact: `174963413 / 200000000`. -/
noncomputable def qxUpper : ℝ := (174963413 : ℝ) / 200000000

/-- The off-line distance bound it yields: an off-pair zero
    sits in `[1 - qxUpper, qxUpper] x C` (functional
    equation), hence `d0 = |Re - 1/2| <= qxUpper - 1/2`.
    Exact value: `74963413 / 200000000 = 0.374817065 < 3/8`. -/
noncomputable def qxD0max : ℝ := qxUpper - 1 / 2

/-- The boundary is strictly below the Liu boundary (norm_num
    certificate): this is what makes [Z78T] a strict
    strengthening of [Z78L] — and transitively of [Z78]
    (cross-multiplication: 174963413 · 10^18 <
    874957019420098947 · 200000000). -/
theorem qxUpper_lt_liuB : qxUpper < Z78Liu.liuBUpper := by
  dsimp only [qxUpper, Z78Liu.liuBUpper]
  norm_num

/-- The off-pair bound is strictly below the Liu off-pair
    bound (no numeric work: subtraction is monotone). -/
theorem qxD0max_lt_liuD0max : qxD0max < Z78Liu.liuD0max := by
  dsimp only [qxD0max, Z78Liu.liuD0max]
  exact sub_lt_sub_right qxUpper_lt_liuB (1 / 2)

/-- The off-pair bound is strictly below 3/8 (both predecessors
    by transitivity): the open face genuinely shrinks. -/
theorem qxD0max_lt_38 : qxD0max < 3 / 8 :=
  lt_trans qxD0max_lt_liuD0max Z78Liu.liuD0max_lt_38

/-- The [Z78T] named external input (kernel-verified; see
    header for provenance and status).  The Riemann zeta
    function (Mathlib's `riemannZeta` — the χ = 1 case of the
    verified all-Dirichlet statement) is zero-free in the
    half-plane `Re s > qxUpper`; the principal-pole guard
    `s ≠ 1` is carried from the statement's
    `¬ (χ = 1 ∧ s = 1)` clause (inert on the pinned Mathlib,
    where `riemannZeta_one_ne_zero`).  This is a CONSEQUENCE
    form of the verified statement (χ = 1 specialization),
    hence a valid named input of the [Z78Liu] pattern. -/
def externalZeroFree78Track : Prop :=
  ∀ (s : ℂ), qxUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78T] STRICTLY STRENGTHENS [Z78L]: zero-free on
    `Re s > qxUpper` (with `qxUpper < liuBUpper`) implies
    zero-free on `Re s > liuBUpper`.  The pole guard `s ≠ 1`
    is carried through verbatim (both statements carry it);
    the guardless [Z78] form follows transitively, where the
    guard is discharged by `riemannZeta_one_ne_zero` in
    `Z78Liu.extLiu_implies_ext78`. -/
theorem extTrack_implies_extLiu (hzT : externalZeroFree78Track) :
    Z78Liu.externalZeroFree78Liu := by
  intro s hs hguard
  exact hzT s (lt_trans qxUpper_lt_liuB hs) hguard

/-- (PROVEN)  [Z78T] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78L]). -/
theorem extTrack_implies_ext78 (hzT : externalZeroFree78Track) :
    Z78.externalZeroFree78 :=
  Z78Liu.extLiu_implies_ext78 (extTrack_implies_extLiu hzT)

/-- (PROVEN)  Every non-real zero of the zeta function lies in
    the strip `1 - qxUpper <= Re <= qxUpper` under [Z78T].
    Identical argument to `Z78Liu.zetaZeroStripLiu` with the
    sharper boundary: upper edge = [Z78T] itself; lower edge =
    the functional equation (all factors non-zero for a
    non-real point) pushes `zeta(1 - rho) = 0`, and [Z78T]
    applied to `1 - rho` gives the lower edge.  The pole guard
    is discharged by non-reality (upper edge) and `1 - rho ≠ 1`
    (lower edge). -/
theorem zetaZeroStripTrack (hzT : externalZeroFree78Track) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - qxUpper ≤ ρ.re ∧ ρ.re ≤ qxUpper := by
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
  have hlo : 1 - qxUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - qxUpper := not_le.mp h
    have hc : qxUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hzT (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ qxUpper := by
    by_contra h
    exact (hzT ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract zero
    set, under [Z78T]: if every element of `q.Z` is an actual
    zero of Mathlib's zeta (the classical instantiation the B-0
    header leaves to citation), then every off-line pair (t0,
    d0) of `q` has off-line distance `d0 <= qxD0max` — the
    sharp tracker value (zeros sit in `[1 - qxUpper, qxUpper]`,
    so `|Re - 1/2| <= qxUpper - 1/2`, both edges the same
    distance `qxD0max` from the line).  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays empty
    for any actual-set zero set under [Z78T]. -/
theorem offPairD0leTrack (q : ZeroSet) (hzT : externalZeroFree78Track)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ qxD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripTrack hzT ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ qxD0max := by
    rw [abs_le]
    constructor
    · dsimp only [qxD0max]
      nlinarith [hstrip.2]
    · dsimp only [qxD0max]
      nlinarith [hstrip.1]
  simpa using hle

/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - qxUpper = 0.125182935`,
    `qxD0max = qxUpper - 1/2 = 0.374817065`. -/
def zeroFreeThetaTrack : Float := 0.874817065
def stripLoTrack : Float := 0.125182935
def offPairD0MaxTrack : Float := 0.374817065
#eval zeroFreeThetaTrack
#eval stripLoTrack
#eval offPairD0MaxTrack

end Z78Track
