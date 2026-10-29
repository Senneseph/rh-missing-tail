/-
[Z78DensityRefined]  (tracker record `density-refined`, PR #90,
SovereignSteak, AI-assisted (OpenAI Codex).)

PROVENANCE (B6 section 8 adoption protocol - the SIXTH supersession the
chain has absorbed, after 0133 / 0142 / 0162 / 0195 / 0200; see Z78FineChain
for the template):
* CATALOGUE (a pointer - pointers are NOT provenance): the live
  QuasiRiemannTracker catalogue (gtimg.github.io/QuasiRiemannTracker/
  catalogue.json, as_of 2026-10-28, 37 records + 1 historical; snapshot
  tmp/tracker_catalog_1029.json) carries this record with status
  `framework-verified`, submitted 2026-10-28T17:21:14Z, first_verified
  2026-10-28T18:29:42Z, merged 2026-10-28T19:48:56Z, and the certified
  rational boundary 0.8739461 (exact rational in the Lean statement; the
  Float values below the theorems are display aids only).  The same pull
  carries ONE other new merged record - PR #85 density-split-fourth
  (Rohan Arun) at 873981/1000000 = 0.873981, merged 2026-10-28T10:29:32Z -
  strictly WEAKER than [Z78FineChain] (0.873981 > 0.8739558); it is
  subsumed and is NOT adopted separately.  This record is the current
  BOARD BEST (smallest theta on the board at the pull).
* PROVENANCE FETCH + IDENTITY: the submission source was fetched at the
  pinned source_commit 3c225e927dae1d0f1283ed10ac9222607a6395c5 (repo
  GTimG/QuasiRiemannTracker; 120 files in the submission src tree,
  submissions/2026-10-28-density-refined/src) and snapshot-guarded: the
  replay refuses to run unless every file matches the
  tmp/z78s34/refined_sha256.txt hashes (120/120 at stage C).  The canonical
  entry (`Candidate.bound`, src/Candidate/Main.lean) states, at the EXACT
  rational 8739461/10000000, the all-moduli, pole-excluded Dirichlet
  nonvanishing boundary; its statement text was identity-checked against
  the catalogue record.
* BUILD CONE: `builds_on` = openai-baseline, hailey-collet-1252270103,
  sil-fourth-power-20261025, arvi-repeated-marks-on-sil-face-20261025,
  sil-density-split-20261026, density-split-fine-chain.  All six
  dependency trees were verified BYTE-IDENTICAL (src) to the frozen 0200
  replay copies (tmp/z78s33/repo_finechain/submissions/*, at
  a284f4da56f7d65b3b4bd4c3f6b00699f9dddde1) - so the replay reuses the
  0148/0195/0200 compiled oleans in one merged root and compiles only the
  record's 119 own proof-cone modules (the 120-file src minus the stage-D
  entry file Candidate/Main.lean).
* PIN: mathlib d13f23b723b8a846827a245b89c10fc7d3f11612; Lean 4.34.1
  by pinned binary (the PATH lean is 4.35.0 and corrupts olean headers).
* REPLAY (this program, independent second-party, 2026-10-28):
  - Stage C: independent per-module kernel compilation of the 119 own
    proof-cone modules (single merged olean root, dependency-ordered
    scheduling, 30-min per-module deadline): 119/119 clean, 0 failed,
    0 skipped (record: tmp/z78s34/stageC_summary.json + per-module logs).
  - Stage D: Stage D1 the canonical statement `Candidate.bound` at the
    exact rational kernel-accepted, proved by the record's own endpoint
    declaration QRH.DensityRefined.dirichlet_nonvanishing
    (statement match at the rational); Stage D2 axiom audit of the
    endpoint: {propext, Classical.choice, Quot.sound} - the standard
    Lean class, no new axioms; Stage D3 the zeta-consequence form
    compiles at the exact rational; Stage D4 0 `sorry` tokens across the
    whole submission src tree (record: tmp/z78s34/stageD_full.log).
* METHOD (record's own words): refines the count-source chain using the
  widened density interface proved in tracker PR89.  Fifty-nine exact
  transitions, each decrementing Lambda by 1/400, start from Jacob
  Sussman's tracker PR86 final source and reach
  G(488842537/500000000, 4388001/2000000, 1/10); PR86 step 38 supplies
  the separate physical source, as exposed by PR89.  Regenerated admission
  and return certificates give the exact boundary 8739461/10000000 =
  0.8739461 at h = 80513/100000, with the principal pole excluded.  The
  required widened-density lemmas and physical-source proof from pending
  PR89 are included with separate namespaces; no pending source
  dependency is required.
* ZETA SCOPE: the record is the all-Dirichlet statement; the zeta
  zero-free form Re s > 8739461/10000000 is its q = 1 specialization
  (Stage D3 probe; the pole guard inert).  Board best at the
  2026-10-28 catalogue pull (merged 19:48Z that evening).
* STATUS IN THIS PROGRAM: a NAMED EXTERNAL INPUT of the same class as
  [Z78] / [Z78L] / [Z78T] / [Z78G] / [Z78C] / [Z78SIL32] /
  [Z78FineChain] - a kernel-verified external theorem, entered only as a
  hypothesis.  The boundary is the exact rational 8739461/10000000
  itself (the record's Lean statement works at the rational - no
  bracketing).
* SNAPSHOT CAVEAT: the tracker board is a moving frontier; a newer
  verified snapshot supersedes this part mechanically (B6 packet
  section 8).  No RH claim anywhere: this is a zero-free half-plane,
  still 0.3739461 away from the critical line in off-line distance.
  Still far from 1/2.
-/

import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu
import RhAttack.Z78Track
import RhAttack.Z78Gao
import RhAttack.Z78Collet
import RhAttack.Z78Sil32
import RhAttack.Z78FineChain
import RhAttack.Z78DensityRefined

open Real Set Complex

/-
[Z78ArviDensity]  (tracker record `arvi-density`, PR #94, ArviFoxy.)

PROVENANCE (B6 section 8 adoption protocol - the SEVENTH supersession the
chain has absorbed, after 0133 / 0142 / 0162 / 0195 / 0200 / 0203; see
Z78DensityRefined for the template):
* CATALOGUE (a pointer - pointers are NOT provenance): the live
  QuasiRiemannTracker catalogue (gtimg.github.io/QuasiRiemannTracker/
  catalogue.json, as_of 2026-10-29, 41 records; snapshot
  tmp/tracker_catalog_1029c.json) carries this record MERGED
  2026-10-29T07:51:58Z at the exact boundary 43693617/50000000
  (= 0.87387234) - the current BOARD BEST (smallest theta on the board
  at the pull).  The same pull carries THREE other new MERGED records,
  all strictly WEAKER than this one and subsumed: PR #93
  joint-detector-fine-chain (Joseph Bebel) 87393379/100000000 =
  0.87393379, PR #92 density-ten (SovereignSteak) 0.87394434464,
  PR #91 density-batch (SovereignSteak) 0.873945166.  (The 0210 in-tree
  face [Z78DensityRefined] 0.8739461 is itself subsumed by all four.)
* PROVENANCE FETCH + IDENTITY: the submission source was fetched at the
  pinned source_commit e5a82f72d8ff39a3cc1ad044e6acd727e77a3fc4 (repo
  GTimG/QuasiRiemannTracker; 329 files in the submission src tree,
  submissions/2026-10-29-arvi-density/src) and snapshot-guarded: the
  replay refuses to run unless every file matches the
  tmp/z78s35/arvi_sha256.txt hashes (328/328 at stage C).  The canonical
  entry (`Candidate.bound`, src/Candidate/Main.lean) states, at the EXACT
  rational 43693617/50000000, the all-moduli, pole-excluded Dirichlet
  nonvanishing boundary; its statement text was identity-checked against
  the catalogue record AND independently fetched+quoted at the pinned
  commit before adoption (the record's own words: "a marked density chain
  to the 1/2 floor" - it counts the HIGH rows of Sil's density step with
  the repeated-mark count of PR #76, lowers the density floor to 1/2 as
  in PR #90, and runs 129 exact marked steps from the boot face of PR #86
  with a regenerated five-branch return).
* BUILD CONE: `builds_on` = openai-baseline, hailey-collet-1252270103,
  sil-fourth-power-20261025, arvi-repeated-marks-on-sil-face-20261025,
  sil-density-split-20261026, density-split-fine-chain.  All FIVE
  dependency src trees actually imported (openai-baseline 2928,
  hailey-collet 3548, arvi PR76 700, fine-chain PR86 94, sil density
  split 538) were verified BYTE-IDENTICAL (src) to the frozen 0203
  replay copies (tmp/z78s34/repo_refined/submissions/*, at the PR #90
  pinned tree) - so the replay reuses the 0148/0195/0200/0203 compiled
  oleans in one merged root (the 0203 work root: 8400 oleans) and
  compiles only the record's 328 own proof-cone modules (the 329-file
  src minus the stage-D entry file Candidate/Main.lean).
* PIN: mathlib d13f23b723b8a846827a245b89c10fc7d3f11612; Lean 4.34.1
  by pinned binary (the PATH lean is 4.35.0 and corrupts olean headers).
* REPLAY (this program, independent second-party, 2026-10-29):
  - Stage C: independent per-module kernel compilation of the 328 own
    proof-cone modules (single merged olean root, dependency-ordered
    scheduling, 30-min per-module deadline): 328/328 clean, 0 failed,
    0 skipped in 326s (record: tmp/z78s35/stageC_summary.json +
    per-module logs).
  - Stage D: D1 the canonical statement `Candidate.bound` at the exact
    rational kernel-accepted; D2 axiom audit of the endpoint
    QRH.ArviDensity.dirichlet_nonvanishing_f50: {propext,
    Classical.choice, Quot.sound} - the standard Lean class, no new
    axioms; D3 the zeta-consequence form compiles at the exact rational;
    D4 0 `sorry` tokens across the whole submission src tree (record:
    tmp/z78s35/stageD_full.log).
* ZETA SCOPE: the record is the all-Dirichlet statement; the zeta
  zero-free form Re s > 43693617/50000000 is its q = 1 specialization
  (Stage D3 probe; the pole guard inert).  Board best at the
  2026-10-29 catalogue pull (merged 07:51Z).
* STATUS IN THIS PROGRAM: a NAMED EXTERNAL INPUT of the same class as
  [Z78] / [Z78L] / [Z78T] / [Z78G] / [Z78C] / [Z78SIL32] /
  [Z78FineChain] / [Z78DensityRefined] - a kernel-verified external
  theorem, entered only as a hypothesis.  The boundary is the exact
  rational 43693617/50000000 itself (the record's Lean statement works
  at the rational - no bracketing).
* SNAPSHOT CAVEAT: the tracker board is a moving frontier; a newer
  verified snapshot supersedes this part mechanically (B6 packet
  section 8).  No RH claim anywhere: this is a zero-free half-plane,
  still 0.37387234 away from the critical line in off-line distance.
  Still far from 1/2.
-/

namespace Z78ArviDensity

/-- The certified rational boundary: the tracker record
    `density-split-fine-chain` proves its all-Dirichlet statement at
    exactly `43693617/50000000` (see header).  Exact:
    `43693617/50000000 = 0.87387234`. -/
noncomputable def arviUpper : ℝ := (43693617 : ℝ) / 50000000

/-- The off-line distance bound it yields: an off-pair zero sits in
    `[1 - arviUpper, arviUpper] x C` (functional equation),
    hence `d0 = |Re - 1/2| <= arviUpper - 1/2`.  Exact value:
    `0.37387234` < sil32D0max < colletD0max < gaoD0max < qxD0max < 3/8. -/
noncomputable def arviD0max : ℝ := arviUpper - 1 / 2

/-- The boundary is strictly below the [Z78SIL32] boundary (norm_num
    certificate): this is what makes [Z78ArviDensity] a strict
    strengthening of [Z78FineChain] - and transitively of [Z78SIL32],
    [Z78C], [Z78G], [Z78T], [Z78L] and [Z78]. -/
theorem arviUpper_lt_denRefined : arviUpper < Z78DensityRefined.denRefinedUpper := by
  dsimp only [arviUpper, Z78DensityRefined.denRefinedUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78SIL32] off-pair bound
    (no numeric work: subtraction is monotone). -/
theorem arviD0max_lt_arviD0max : arviD0max < Z78DensityRefined.denRefinedD0max := by
  dsimp only [arviD0max, Z78DensityRefined.denRefinedD0max]
  exact sub_lt_sub_right arviUpper_lt_denRefined (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all predecessors by
    transitivity): the open face genuinely shrinks. -/
theorem arviD0max_lt_38 : arviD0max < 3 / 8 :=
  lt_trans arviD0max_lt_arviD0max Z78DensityRefined.denRefinedD0max_lt_38

/-- The [Z78ArviDensity] named external input (kernel-verified; see header
    for provenance and status).  The Riemann zeta function (Mathlib's
    `riemannZeta`) is zero-free in the half-plane `Re s >
    arviUpper`; the principal-pole guard `s != 1` is the [Z78Liu]
    consequence-form guard (inert on the pinned Mathlib, where
    `riemannZeta_one_ne_zero`). -/
def externalZeroFree78Arvi : Prop :=
  forall (s : ℂ), arviUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78FineChain]: zero-free
    on `Re s > arviUpper` (with `arviUpper < sil32Upper`)
    implies zero-free on `Re s > sil32Upper`.  The pole guard is carried
    through verbatim. -/
theorem extArvi_implies_extDenRefined (hz : externalZeroFree78Arvi) :
    Z78DensityRefined.externalZeroFree78DenRefined := by
  intro s hs hguard
  exact hz s (lt_trans arviUpper_lt_denRefined hs) hguard

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78C] (transitivity
    through [Z78FineChain] and [Z78SIL32]). -/
theorem extArvi_implies_extCollet (hz : externalZeroFree78Arvi) :
    Z78Collet.externalZeroFree78Collet :=
  Z78DensityRefined.extDenRefined_implies_extCollet (extArvi_implies_extDenRefined hz)

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78G] (transitivity
    through [Z78FineChain], [Z78SIL32] and [Z78C]). -/
theorem extArvi_implies_extGao (hz : externalZeroFree78Arvi) :
    Z78Gao.externalZeroFree78Gao :=
  Z78DensityRefined.extDenRefined_implies_extGao (extArvi_implies_extDenRefined hz)

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78T] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C] and [Z78G]). -/
theorem extArvi_implies_extTrack (hz : externalZeroFree78Arvi) :
    Z78Track.externalZeroFree78Track :=
  Z78DensityRefined.extDenRefined_implies_extTrack (extArvi_implies_extDenRefined hz)

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78L] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C], [Z78G] and [Z78T]). -/
theorem extArvi_implies_extLiu (hz : externalZeroFree78Arvi) :
    Z78Liu.externalZeroFree78Liu :=
  Z78DensityRefined.extDenRefined_implies_extLiu (extArvi_implies_extDenRefined hz)

/-- (PROVEN)  [Z78ArviDensity] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78FineChain] and all intermediate records). -/
theorem extArvi_implies_ext78 (hz : externalZeroFree78Arvi) :
    Z78.externalZeroFree78 :=
  Z78DensityRefined.extDenRefined_implies_ext78 (extArvi_implies_extDenRefined hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - arviUpper <= Re <= arviUpper`
    under [Z78ArviDensity].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78ArviDensity]). -/
theorem zetaZeroStripArvi (hz : externalZeroFree78Arvi) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - arviUpper ≤ ρ.re ∧ ρ.re ≤ arviUpper := by
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
  have hlo : 1 - arviUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - arviUpper := not_le.mp h
    have hc : arviUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ arviUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78ArviDensity]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= arviD0max` — the sharp
    [Z78ArviDensity] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78ArviDensity]. -/
theorem offPairD0leArvi (q : ZeroSet) (hz : externalZeroFree78Arvi)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ arviD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripArvi hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ arviD0max := by
    rw [abs_le]
    constructor
    · dsimp only [arviD0max]
      nlinarith [hstrip.2]
    · dsimp only [arviD0max]
      nlinarith [hstrip.1]
  simpa using hle


/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - arviUpper = 0.12612766`, `arviD0max = arviUpper - 1/2 = 0.37387234`. -/
def zeroFreeThetaArvi : Float := 0.87387234
def stripLoArvi : Float := 0.12612766
def offPairD0MaxArvi : Float := 0.37387234
#eval zeroFreeThetaArvi
#eval stripLoArvi
#eval offPairD0MaxArvi

end Z78ArviDensity
