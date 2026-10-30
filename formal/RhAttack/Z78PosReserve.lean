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
import RhAttack.Z78ArviDensity

open Real Set Complex

/-
[Z78PosReserve]  (PR #99 tracker record `positive-reserve-selected-gap`,
Joseph Bebel; internal module naming `PR98Improvement`.)

PROVENANCE (B6 section 8 adoption protocol - the EIGHTH supersession the
chain has absorbed, after 0133 / 0142 / 0162 / 0195 / 0200 / 0203 /
0211; see Z78ArviDensity for the template):
* CATALOGUE (a pointer - pointers are NOT provenance): tmp/b6audit/tracker_catalog_1030b.json (as_of 2026-10-30, 45 records + 1 historical)
  carries this record MERGED 2026-10-30T12:44:37Z at the exact boundary
  8733819666133/10000000000000 (= 0.8733819666133) - the current BOARD
  BEST (smallest theta on the board at the pull; the same 2026-10-30
  morning batch carries two new records strictly WEAKER, both subsumed
  by this one and NOT adopted: selected-leaf-refined-return
  0.8733821435 merged 2026-10-30T10:00:03Z, and EIGHTH's own dependency
  arvi-selected-leaf 0.87341198 merged 2026-10-30T07:47:37Z), status
  framework-verified, first verified 2026-10-30T12:41:13Z,
  PR #99, Joseph Bebel, title "All-moduli Dirichlet nonvanishing at 0.8733819666133".
* PROVENANCE FETCH + IDENTITY: the submission source was fetched at the
  pinned source_commit 9e17ac75d786905195f5f87aa8e15496c8a9bfc0 (repo
  GTimG/QuasiRiemannTracker; 236 files in the submission
  src tree, submissions/2026-10-30-positive-reserve-selected-gap/src) and
  snapshot-guarded: the replay refuses to run unless every file matches
  the tmp/z78s37/positive-reserve-selected-gap_sha256.txt hashes
  (236/236 at stage C).  The canonical
  entry (`Candidate.bound (src/Candidate/Main.lean)`) states, at the EXACT rational
  8733819666133/10000000000000, the all-moduli Dirichlet nonvanishing
  boundary; its statement text was identity-checked against the
  catalogue record AND independently fetched+quoted at the pinned commit
  before adoption.
* BUILD CONE: all EIGHT build-cone src trees were verified
  BYTE-IDENTICAL (src) to the frozen replay copies (8/8 - openai-baseline, hailey-collet-1252270103, sil-density-split-20261026, density-split-fine-chain, arvi-repeated-marks-on-sil-face-20261025, arvi-density, arvi-selected-leaf, joint-detector-fine-chain (conveyor cone report, 0234 run)).
  Six of them are ACTUALLY imported by the record's cone (the four direct
  Submissions prefixes - openai-baseline, hailey-collet, arvi-repeated-
  marks, arvi-selected-leaf - and, transitively through arvi-selected-leaf,
  sil-density-split and arvi-density); joint-detector-fine-chain is on the
  board builds_on chain but is NOT imported by the record or by
  arvi-selected-leaf, so it is excluded from the compilation cone (0211
  precedent: "trees ACTUALLY imported"), verified byte-identical regardless.
  The replay reuses the frozen compiled oleans in one merged root (the
  0234-grown seed: 0148/0195/0200/0203/0211 oleans + the 178-module
  arvi-selected-leaf pre-stage of 2026-10-30) and compiles only the
  record's 235 own proof-cone modules (the src tree
  minus the stage-D entry file Candidate/Main.lean).
* PIN: mathlib d13f23b723b8a846827a245b89c10fc7d3f11612; Lean 4.34.1
  by pinned binary (the PATH lean is 4.35.0 and corrupts olean headers).
* REPLAY (this program, independent second-party, 2026-10-30):
  - Stage C: independent per-module kernel compilation of the
    235 own proof-cone modules (single merged olean
    root, dependency-ordered scheduling, 30-min per-module deadline):
    235/235 clean, 0 failed,
    0 skipped in 137s
    (record: tmp/z78s39/stageC_summary.json + per-module logs (full run: 235/235 in 137s, 0 failed, 0 skipped)).
  - Stage D: D1 the canonical statement at the exact rational
    kernel-accepted; D2 axiom audit of the endpoint: {propext, Classical.choice, Quot.sound}
    - the standard Lean class, no new axioms; D3 the zeta-consequence
    form compiles at the exact rational (theorem zeta_consequence_0234 compiles at the exact rational); D4
    0 `sorry` tokens across the whole submission src tree (236 files) (record: tmp/z78s39/stageD/ (D1 Candidate.lean.olean; D2 axiom output; D3 d3root/zeta_probe.lean + zeta_probe.olean; D4 sweep by the conveyor)).
* ZETA SCOPE: the record is the all-Dirichlet statement; the zeta
  zero-free form Re s > 8733819666133/10000000000000 is its q = 1
  specialization (Stage D3 probe; the pole guard inert).  Board best at
  the 2026-10-30 catalogue pull (merged 12:44Z).
* STATUS IN THIS PROGRAM: a NAMED EXTERNAL INPUT of the same class as
  [Z78] / [Z78L] / [Z78T] / [Z78G] / [Z78C] / [Z78SIL32] /
  [Z78FineChain] / [Z78DensityRefined] / [Z78ArviDensity] - a
  kernel-verified external theorem, entered only as a hypothesis.  The
  boundary is the exact rational 8733819666133/10000000000000 itself
  (the record's Lean statement works at the rational - no bracketing).
* SNAPSHOT CAVEAT: the tracker board is a moving frontier; a newer
  verified snapshot supersedes this part mechanically (B6 packet
  section 8).  No RH claim anywhere: this is a zero-free half-plane,
  still 0.3733819666133 away from the critical line in off-line
  distance.  Still far from 1/2.
-/

namespace Z78PosReserve

/-- The certified rational boundary: the tracker record
    `density-split-fine-chain` proves its all-Dirichlet statement at
    exactly `8733819666133/10000000000000` (see header).  Exact:
    `8733819666133/10000000000000 = 0.8733819666133`. -/
noncomputable def posReserveUpper : ℝ := (8733819666133 : ℝ) / 10000000000000

/-- The off-line distance bound it yields: an off-pair zero sits in
    `[1 - posReserveUpper, posReserveUpper] x C` (functional equation),
    hence `d0 = |Re - 1/2| <= posReserveUpper - 1/2`.  Exact value:
    `0.3733819666133` < sil32D0max < colletD0max < gaoD0max < qxD0max < 3/8. -/
noncomputable def posReserveD0max : ℝ := posReserveUpper - 1 / 2

/-- The boundary is strictly below the [Z78SIL32] boundary (norm_num
    certificate): this is what makes [Z78PosReserve] a strict
    strengthening of [Z78FineChain] - and transitively of [Z78SIL32],
    [Z78C], [Z78G], [Z78T], [Z78L] and [Z78]. -/
theorem posReserveUpper_lt_arvi : posReserveUpper < Z78ArviDensity.arviUpper := by
  dsimp only [posReserveUpper, Z78ArviDensity.arviUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78SIL32] off-pair bound
    (no numeric work: subtraction is monotone). -/
theorem posReserveD0max_lt_posReserveD0max : posReserveD0max < Z78ArviDensity.arviD0max := by
  dsimp only [posReserveD0max, Z78ArviDensity.arviD0max]
  exact sub_lt_sub_right posReserveUpper_lt_arvi (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all predecessors by
    transitivity): the open face genuinely shrinks. -/
theorem posReserveD0max_lt_38 : posReserveD0max < 3 / 8 :=
  lt_trans posReserveD0max_lt_posReserveD0max Z78ArviDensity.arviD0max_lt_38

/-- The [Z78PosReserve] named external input (kernel-verified; see header
    for provenance and status).  The Riemann zeta function (Mathlib's
    `riemannZeta`) is zero-free in the half-plane `Re s >
    posReserveUpper`; the principal-pole guard `s != 1` is the [Z78Liu]
    consequence-form guard (inert on the pinned Mathlib, where
    `riemannZeta_one_ne_zero`). -/
def externalZeroFree78PosReserve : Prop :=
  forall (s : ℂ), posReserveUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78FineChain]: zero-free
    on `Re s > posReserveUpper` (with `posReserveUpper < sil32Upper`)
    implies zero-free on `Re s > sil32Upper`.  The pole guard is carried
    through verbatim. -/
theorem extPosReserve_implies_extArvi (hz : externalZeroFree78PosReserve) :
    Z78ArviDensity.externalZeroFree78Arvi := by
  intro s hs hguard
  exact hz s (lt_trans posReserveUpper_lt_arvi hs) hguard

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78C] (transitivity
    through [Z78FineChain] and [Z78SIL32]). -/
theorem extPosReserve_implies_extCollet (hz : externalZeroFree78PosReserve) :
    Z78Collet.externalZeroFree78Collet :=
  Z78ArviDensity.extArvi_implies_extCollet (extPosReserve_implies_extArvi hz)

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78G] (transitivity
    through [Z78FineChain], [Z78SIL32] and [Z78C]). -/
theorem extPosReserve_implies_extGao (hz : externalZeroFree78PosReserve) :
    Z78Gao.externalZeroFree78Gao :=
  Z78ArviDensity.extArvi_implies_extGao (extPosReserve_implies_extArvi hz)

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78T] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C] and [Z78G]). -/
theorem extPosReserve_implies_extTrack (hz : externalZeroFree78PosReserve) :
    Z78Track.externalZeroFree78Track :=
  Z78ArviDensity.extArvi_implies_extTrack (extPosReserve_implies_extArvi hz)

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78L] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C], [Z78G] and [Z78T]). -/
theorem extPosReserve_implies_extLiu (hz : externalZeroFree78PosReserve) :
    Z78Liu.externalZeroFree78Liu :=
  Z78ArviDensity.extArvi_implies_extLiu (extPosReserve_implies_extArvi hz)

/-- (PROVEN)  [Z78PosReserve] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78FineChain] and all intermediate records). -/
theorem extPosReserve_implies_ext78 (hz : externalZeroFree78PosReserve) :
    Z78.externalZeroFree78 :=
  Z78ArviDensity.extArvi_implies_ext78 (extPosReserve_implies_extArvi hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - posReserveUpper <= Re <= posReserveUpper`
    under [Z78PosReserve].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78PosReserve]). -/
theorem zetaZeroStripPosReserve (hz : externalZeroFree78PosReserve) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - posReserveUpper ≤ ρ.re ∧ ρ.re ≤ posReserveUpper := by
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
  have hlo : 1 - posReserveUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - posReserveUpper := not_le.mp h
    have hc : posReserveUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ posReserveUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78PosReserve]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= posReserveD0max` — the sharp
    [Z78PosReserve] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78PosReserve]. -/
theorem offPairD0lePosReserve (q : ZeroSet) (hz : externalZeroFree78PosReserve)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ posReserveD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripPosReserve hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ posReserveD0max := by
    rw [abs_le]
    constructor
    · dsimp only [posReserveD0max]
      nlinarith [hstrip.2]
    · dsimp only [posReserveD0max]
      nlinarith [hstrip.1]
  simpa using hle


/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - posReserveUpper = 0.1266180333867`, `posReserveD0max = posReserveUpper - 1/2 = 0.3733819666133`. -/
def zeroFreeThetaPosReserve : Float := 0.8733819666133
def stripLoPosReserve : Float := 0.1266180333867
def offPairD0MaxPosReserve : Float := 0.3733819666133
#eval zeroFreeThetaPosReserve
#eval stripLoPosReserve
#eval offPairD0MaxPosReserve

end Z78PosReserve
