import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu
import RhAttack.Z78Track
import RhAttack.Z78Gao

open Real Set Complex

/-!
**Z78Collet — [Z78C]: the QuasiRiemannTracker
finite-ordinary-source-moments frontier input
(the all-Dirichlet half-plane at 0.8747729897), and its
strip corollary.**

ADOPTED 2026-10-23 (discovery 0162).  PR #69 (Hailey Collet /
HaileyStorm, frozen head ac76d5ef6008d976a7b8f3c1d921af2317e79ce9,
claims 8747729897/10^10) MERGED (merge commit
2cbdbe7c14e926c1eb33fea0919e561038a27880); merge identity
verified 2026-10-23: the merged head IS the frozen-head
replay object, and the full merged submission tree is
blob-SHA-identical to the replayed frozen copy (3549/3549
files at the merge commit).  Catalogue: the tracker board's
top record is this submission (merged 2026-10-23).
Standalone paper (haileystorm.github.io) was 404 at audit
time — REMAINS a named-provenance TODO (does not block
adoption: the B6 section-8 gate is the kernel replay, and it
is PASS at the frozen head, bit-identical to the merged
tree).

PROVENANCE (no recall — every reference resolves):
  Source:  QuasiRiemannTracker (github.com/GTimG/
           QuasiRiemannTracker), PR #69 by HaileyStorm
           (Hailey Collet), opened 2026-10-21T19:58:25Z as a
           DRAFT, frozen head
           ac76d5ef6008d976a7b8f3c1d921af2317e79ce9 checked
           2026-10-21; structured headers:
           QRH-Result: hailey-collet-1252270103,
           QRH-Bound: 8747729897/10000000000,
           QRH-Decimal: 0.8747729897;
           MERGED 2026-10-23T (merge commit
           2cbdbe7c14e926c1eb33fea0919e561038a27880; merged
           head = frozen head ac76d5ef...).
           Depends on the accepted PR67 input
           (two-level-affine-20261019 = the [Z78T] record)
           plus 64 seed source faces, an intermediate return
           (C30, 0.8747759), 221 derived source faces and a
           final return (301-node finite source DAG
           induction, "finite ordinary source moments").
  Math:    an all-Dirichlet zero-free half-plane at the
           CERTIFIED RATIONAL boundary
           `8747729897 / 10000000000 = 0.8747729897`:
             for every q >= 1, every complex Dirichlet
             character χ mod q (Mathlib's
             `DirichletCharacter.LFunction`), and every s
             with `0.8747729897 < s.re`,
             `¬ (χ = 1 ∧ s = 1) → L(χ, s) ≠ 0`
           (the principal pole excluded; the Riemann zeta is
           the case χ = 1, with the statement's pole clause
           inert on the pinned Mathlib where
           `riemannZeta_one_ne_zero`).  Standalone paper:
           https://haileystorm.github.io/research/finite-
           ordinary-source-moments/ (404 at audit time -
           PENDING, named provenance incomplete).
  Scale:   3548 Lean modules in her submission (+ the 2927
           vendored OAI baseline modules of the fork).
  VERIFICATION STATUS (at the FROZEN head ac76d5ef, checked
    2026-10-21):
    * the PR's own status at audit time: DRAFT, "local
      verification is incomplete" - the tracker's protected
      admission pipeline had NOT completed at check time;
    * SECOND-PARTY INDEPENDENT REPLAY (this program's
      standing gate for every adoption — the B6 section-8
      protocol, demonstrated in 0132/0134/0142), run at the
      frozen head: **PASS, 2026-10-21** — Stage C: 6474/6474
      modules (3547 record + 2927 vendored OAI baseline; the
      submission-local Candidate.* trees are not in the proof
      cone) compiled from source in dependency order against
      the tracker-pinned environment (Lean 4.34.1 by pinned
      binary; mathlib @ d13f23b723b8a846827a245b89c10fc7d3f11612
      and the full tracker .lake tree reused from the 0142
      [Z78G] replay — the PR is 437,002 additions / 0
      deletions, so no dependency pin changed), 0 failures,
      3472s; Stage D1: the canonical statements at exactly
      `8747729897/10000000000` in BOTH claimed scopes
      (zeta_nonvanishing: (0.8747729897 < s.re) →
      riemannZeta s ≠ 0, the SAME mathlib object as the
      in-tree Z78* modules; dirichlet_nonvanishing: the
      pole-excluded all-Dirichlet statement) kernel-accepted,
      each proved by her own endpoint declarations (statement
      match at the exact rational); Stage D2: the axiom cone
      of all six endpoint declarations (seed_step, nf_step,
      beta_bound, hecke_nonvanishing, dirichlet_nonvanishing,
      zeta_nonvanishing) is EXACTLY [propext, Classical.
      choice, Quot.sound] — the standard set, no new axioms,
      no sorry axioms; Stage D3: 0 `sorry` tokens across the
      3547 record modules.  Snapshot guard: replay refuses
      to run unless the tarball sha256 matches the frozen
      head pull (8607635a68655484206cb12112605b2734401860d2a597367b5f2cb8b54c5219).
      Record: tmp/b6audit/collet69/replay/{stageC_summary.
      json,stageD_axioms.txt,logs/}.
    * MERGED-HEAD IDENTITY (2026-10-23):  the merged head
      IS  ac76d5ef (GitHub API:  PR #69 head.sha), the merge
      commit is  2cbdbe7c14e926c1eb33fea0919e561038a27880,
      and the  FULL  submission  tree  at  the  merge  commit
      is  blob-SHA-identical  to  the  replayed  frozen  copy
      (3549/3549  files  checked  against  the  GitHub  tree
      API)  -  so  the  frozen-head  replay  is  EXACTLY  the
      merged-head  verification;  no  re-run  was  needed.
      Spot  hash:  ReturnConstants.lean  md5
      b82c177082d3688840fb07cdfee69c62  in  both  trees.
  STATUS IN THIS PROGRAM:  a NAMED EXTERNAL INPUT of the
  same class as [Z78] / [Z78L] / [Z78T] / [Z78G] — a
  kernel-verified external theorem, entered only as a
  hypothesis.  The boundary is the exact rational
  8747729897/10^10 itself (the record's Lean statement works
  at the rational — no bracketing).
  SNAPSHOT CAVEAT:  the tracker's board is a moving
  frontier — this record is the THIRD supersession the chain
  has absorbed (0133: [Z78] -> [Z78T]; 0142: [Z78T] ->
  [Z78G]; now [Z78G] -> [Z78C]) by the same B6 section-8
  mechanism.  Ceiling analysis (0147): the record sits
  2.116e-4 ABOVE its own family's named-margin corner
  (theta* = 0.8745613585650727 at the named-margin layer),
  so further same-family descent is plausible in the
  tracker race; the engine is input-uniform (a licensed
  better input does not improve the output).
  No RH claim anywhere: this is a zero-free half-plane,
  still 0.3747729897 away from the critical line in off-line
  distance.  Still far from 1/2.
-/

namespace Z78Collet

/-- The certified rational boundary: the tracker record
    `hailey-collet-1252270103` proves its all-Dirichlet
    statement at exactly `8747729897 / 10^10` (see header).
    Exact: `8747729897 / 10000000000 = 0.8747729897`. -/
noncomputable def colletUpper : ℝ := (8747729897 : ℝ) / 10 ^ 10

/-- The off-line distance bound it yields: an off-pair zero
    sits in `[1 - colletUpper, colletUpper] x C` (functional
    equation), hence `d0 = |Re - 1/2| <= colletUpper - 1/2`.
    Exact value: `3747729897 / 10^10 = 0.3747729897 <
    gaoD0max < qxD0max < 3/8`. -/
noncomputable def colletD0max : ℝ := colletUpper - 1 / 2

/-- The boundary is strictly below the [Z78G] boundary
    (norm_num certificate, cross-multiplication:
    8747729897 · 10^3 < 8748087 · 10^6): this is what makes
    [Z78C] a strict strengthening of [Z78G] — and
    transitively of [Z78T], [Z78L] and [Z78]. -/
theorem colletUpper_lt_gao : colletUpper < Z78Gao.gaoUpper := by
  dsimp only [colletUpper, Z78Gao.gaoUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78G]
    off-pair bound (no numeric work: subtraction is
    monotone). -/
theorem colletD0max_lt_gaoD0max : colletD0max < Z78Gao.gaoD0max := by
  dsimp only [colletD0max, Z78Gao.gaoD0max]
  exact sub_lt_sub_right colletUpper_lt_gao (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all
    predecessors by transitivity): the open face genuinely
    shrinks. -/
theorem colletD0max_lt_38 : colletD0max < 3 / 8 :=
  lt_trans colletD0max_lt_gaoD0max Z78Gao.gaoD0max_lt_38

/-- The [Z78C] named external input (kernel-verified; see
    header for provenance and status).  The Riemann zeta
    function (Mathlib's `riemannZeta` — the χ = 1 case of
    the verified all-Dirichlet statement) is zero-free in
    the half-plane `Re s > colletUpper`; the principal-pole
    guard `s ≠ 1` is carried from the statement's
    `¬ (χ = 1 ∧ s = 1)` clause (inert on the pinned
    Mathlib, where `riemannZeta_one_ne_zero`).  This is a
    CONSEQUENCE form of the verified statement (χ = 1
    specialization), hence a valid named input of the
    [Z78Liu] pattern. -/
def externalZeroFree78Collet : Prop :=
  ∀ (s : ℂ), colletUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78C] STRICTLY STRENGTHENS [Z78G]: zero-free
    on `Re s > colletUpper` (with `colletUpper < gaoUpper`)
    implies zero-free on `Re s > gaoUpper`.  The pole guard
    `s ≠ 1` is carried through verbatim. -/
theorem extColet_implies_extGao (hzC : externalZeroFree78Collet) :
    Z78Gao.externalZeroFree78Gao := by
  intro s hs hguard
  exact hzC s (lt_trans colletUpper_lt_gao hs) hguard

/-- (PROVEN)  [Z78C] STRICTLY STRENGTHENS [Z78T]
    (transitivity through [Z78G]). -/
theorem extColet_implies_extTrack (hzC : externalZeroFree78Collet) :
    Z78Track.externalZeroFree78Track :=
  Z78Gao.extGao_implies_extTrack (extColet_implies_extGao hzC)

/-- (PROVEN)  [Z78C] STRICTLY STRENGTHENS [Z78L]
    (transitivity through [Z78G] and [Z78T]). -/
theorem extColet_implies_extLiu (hzC : externalZeroFree78Collet) :
    Z78Liu.externalZeroFree78Liu :=
  Z78Gao.extGao_implies_extLiu (extColet_implies_extGao hzC)

/-- (PROVEN)  [Z78C] STRICTLY STRENGTHENS [Z78]
    (transitivity through [Z78G], [Z78T] and [Z78L]). -/
theorem extColet_implies_ext78 (hzC : externalZeroFree78Collet) :
    Z78.externalZeroFree78 :=
  Z78Gao.extGao_implies_ext78 (extColet_implies_extGao hzC)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - colletUpper <= Re <= colletUpper`
    under [Z78C].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary. -/
theorem zetaZeroStripCollet (hzC : externalZeroFree78Collet) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - colletUpper ≤ ρ.re ∧ ρ.re ≤ colletUpper := by
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
  have hlo : 1 - colletUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - colletUpper := not_le.mp h
    have hc : colletUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hzC (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ colletUpper := by
    by_contra h
    exact (hzC ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78C]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= colletD0max` — the sharp
    finite-ordinary-source-moments value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78C]. -/
theorem offPairD0leCollet (q : ZeroSet) (hzC : externalZeroFree78Collet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ colletD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripCollet hzC ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ colletD0max := by
    rw [abs_le]
    constructor
    · dsimp only [colletD0max]
      nlinarith [hstrip.2]
    · dsimp only [colletD0max]
      nlinarith [hstrip.1]
  simpa using hle

/-- Data gates (Float world; the Real forms carry the
    theorems above).  Computed from the certified
    constants: `1 - colletUpper = 0.1252270103`,
    `colletD0max = colletUpper - 1/2 = 0.3747729897`. -/
def zeroFreeThetaCollet : Float := 0.8747729897
def stripLoCollet : Float := 0.1252270103
def offPairD0MaxCollet : Float := 0.3747729897
#eval zeroFreeThetaCollet
#eval stripLoCollet
#eval offPairD0MaxCollet

end Z78Collet
