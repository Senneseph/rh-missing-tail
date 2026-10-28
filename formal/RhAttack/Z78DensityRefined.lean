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

open Real Set Complex

namespace Z78DensityRefined

/-- The certified rational boundary: the tracker record
    `density-split-fine-chain` proves its all-Dirichlet statement at
    exactly `8739461/10000000` (see header).  Exact:
    `8739461/10000000 = 0.8739461`. -/
noncomputable def denRefinedUpper : ℝ := (8739461 : ℝ) / 10000000

/-- The off-line distance bound it yields: an off-pair zero sits in
    `[1 - denRefinedUpper, denRefinedUpper] x C` (functional equation),
    hence `d0 = |Re - 1/2| <= denRefinedUpper - 1/2`.  Exact value:
    `0.3739461` < sil32D0max < colletD0max < gaoD0max < qxD0max < 3/8. -/
noncomputable def denRefinedD0max : ℝ := denRefinedUpper - 1 / 2

/-- The boundary is strictly below the [Z78SIL32] boundary (norm_num
    certificate): this is what makes [Z78DensityRefined] a strict
    strengthening of [Z78FineChain] - and transitively of [Z78SIL32],
    [Z78C], [Z78G], [Z78T], [Z78L] and [Z78]. -/
theorem denRefinedUpper_lt_fineChain : denRefinedUpper < Z78FineChain.fineChainUpper := by
  dsimp only [denRefinedUpper, Z78FineChain.fineChainUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78SIL32] off-pair bound
    (no numeric work: subtraction is monotone). -/
theorem denRefinedD0max_lt_denRefinedD0max : denRefinedD0max < Z78FineChain.fineChainD0max := by
  dsimp only [denRefinedD0max, Z78FineChain.fineChainD0max]
  exact sub_lt_sub_right denRefinedUpper_lt_fineChain (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all predecessors by
    transitivity): the open face genuinely shrinks. -/
theorem denRefinedD0max_lt_38 : denRefinedD0max < 3 / 8 :=
  lt_trans denRefinedD0max_lt_denRefinedD0max Z78FineChain.fineChainD0max_lt_38

/-- The [Z78DensityRefined] named external input (kernel-verified; see header
    for provenance and status).  The Riemann zeta function (Mathlib's
    `riemannZeta`) is zero-free in the half-plane `Re s >
    denRefinedUpper`; the principal-pole guard `s != 1` is the [Z78Liu]
    consequence-form guard (inert on the pinned Mathlib, where
    `riemannZeta_one_ne_zero`). -/
def externalZeroFree78DenRefined : Prop :=
  forall (s : ℂ), denRefinedUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78FineChain]: zero-free
    on `Re s > denRefinedUpper` (with `denRefinedUpper < sil32Upper`)
    implies zero-free on `Re s > sil32Upper`.  The pole guard is carried
    through verbatim. -/
theorem extDenRefined_implies_extFineChain (hz : externalZeroFree78DenRefined) :
    Z78FineChain.externalZeroFree78FineChain := by
  intro s hs hguard
  exact hz s (lt_trans denRefinedUpper_lt_fineChain hs) hguard

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78C] (transitivity
    through [Z78FineChain] and [Z78SIL32]). -/
theorem extDenRefined_implies_extCollet (hz : externalZeroFree78DenRefined) :
    Z78Collet.externalZeroFree78Collet :=
  Z78FineChain.extFineChain_implies_extCollet (extDenRefined_implies_extFineChain hz)

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78G] (transitivity
    through [Z78FineChain], [Z78SIL32] and [Z78C]). -/
theorem extDenRefined_implies_extGao (hz : externalZeroFree78DenRefined) :
    Z78Gao.externalZeroFree78Gao :=
  Z78FineChain.extFineChain_implies_extGao (extDenRefined_implies_extFineChain hz)

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78T] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C] and [Z78G]). -/
theorem extDenRefined_implies_extTrack (hz : externalZeroFree78DenRefined) :
    Z78Track.externalZeroFree78Track :=
  Z78FineChain.extFineChain_implies_extTrack (extDenRefined_implies_extFineChain hz)

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78L] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C], [Z78G] and [Z78T]). -/
theorem extDenRefined_implies_extLiu (hz : externalZeroFree78DenRefined) :
    Z78Liu.externalZeroFree78Liu :=
  Z78FineChain.extFineChain_implies_extLiu (extDenRefined_implies_extFineChain hz)

/-- (PROVEN)  [Z78DensityRefined] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78FineChain] and all intermediate records). -/
theorem extDenRefined_implies_ext78 (hz : externalZeroFree78DenRefined) :
    Z78.externalZeroFree78 :=
  Z78FineChain.extFineChain_implies_ext78 (extDenRefined_implies_extFineChain hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - denRefinedUpper <= Re <= denRefinedUpper`
    under [Z78DensityRefined].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78DensityRefined]). -/
theorem zetaZeroStripDenRefined (hz : externalZeroFree78DenRefined) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - denRefinedUpper ≤ ρ.re ∧ ρ.re ≤ denRefinedUpper := by
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
  have hlo : 1 - denRefinedUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - denRefinedUpper := not_le.mp h
    have hc : denRefinedUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ denRefinedUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78DensityRefined]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= denRefinedD0max` — the sharp
    [Z78DensityRefined] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78DensityRefined]. -/
theorem offPairD0leDenRefined (q : ZeroSet) (hz : externalZeroFree78DenRefined)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ denRefinedD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripDenRefined hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ denRefinedD0max := by
    rw [abs_le]
    constructor
    · dsimp only [denRefinedD0max]
      nlinarith [hstrip.2]
    · dsimp only [denRefinedD0max]
      nlinarith [hstrip.1]
  simpa using hle


/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - denRefinedUpper = 0.1260539`, `denRefinedD0max = denRefinedUpper - 1/2 = 0.3739461`. -/
def zeroFreeThetaDenRefined : Float := 0.8739461
def stripLoDenRefined : Float := 0.1260539
def offPairD0MaxDenRefined : Float := 0.3739461
#eval zeroFreeThetaDenRefined
#eval stripLoDenRefined
#eval offPairD0MaxDenRefined

end Z78DensityRefined
