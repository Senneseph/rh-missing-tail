import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.Z78Strip
import RhAttack.Z78Liu
import RhAttack.Z78Track
import RhAttack.Z78Gao
import RhAttack.Z78Collet

open Real Set Complex

/-
[Z78SIL32]  (tracker record `sil-density-split-20261026`, PR #83, Sil.)

PROVENANCE (B6 section 8 adoption protocol - the FOURTH supersession the
chain has absorbed, after 0133 / 0142 / 0162; see Z78Collet for the
template):
* CATALOGUE (a pointer - pointers are NOT provenance): the live
  QuasiRiemannTracker catalogue (gtimg.github.io/QuasiRiemannTracker/
  catalogue.json, as_of 2026-10-27, 33 records) carries this record with
  status `framework-verified`, submitted 2026-10-26T19:52:40Z, first_verified 2026-10-27T05:28:36Z,
  merged 2026-10-27T06:11:09Z, and the certified rational boundary 0.873995 (exact
  rational in the Lean statement; the Float values below the theorems
  are display aids only).
* PROVENANCE FETCH + IDENTITY: the submission source was fetched at the
  pinned source_commit f4bc792dff57f9f63fe791521c6c49497ff6a571 (repo GTimG/QuasiRiemannTracker; 538
  files in the submission src tree) and snapshot-guarded: the replay
  refuses to run unless every file matches the tmp/z78s32/sil32_sha256.txt
  hashes.  The canonical entry
  (`Candidate.bound`, submissions/sil-density-split-20261026/src/Candidate/Main.lean)
  states, at the EXACT rational 174799/200000, the all-moduli, pole-excluded
  Dirichlet nonvanishing boundary; its statement text was
  identity-checked against the catalogue record.
* BUILD CONE: `builds_on` = openai-baseline, hailey-collet-1252270103, sil-fourth-power-20261025, arvi-repeated-marks-on-sil-face-20261025.  The proof cone compiles against
  the 0148 frozen replay artifacts - the openai-baseline (2928 files)
  and hailey-collet (3548 files) trees were verified BYTE-IDENTICAL to
  the frozen 0148 copies in all three 2026-10-27 snapshots, and the
  arvi tree inside the sil32 snapshot is byte-identical to the arvi31
  pinned snapshot - so the replay reuses the 0148 compiled oleans and
  compiles 537 own modules in a single merged olean root.
* PIN: mathlib d13f23b723b8a846827a245b89c10fc7d3f11612; Lean 4.34.1
  by pinned binary (the PATH lean is 4.35.0 and corrupts olean headers).
* REPLAY (this program, independent second-party, 2026-10-27):
  - Stage C: independent per-module kernel compilation of the 537 own
    proof-cone modules (single merged olean root, dependency-ordered
    scheduling, 30-min per-module deadline): 537/537 clean
    (record: tmp/z78s32/stageC_summary.json + per-module logs).
  - Stage D: Stage D1 the canonical statement `Candidate.bound` at the
    exact rational kernel-accepted, proved by the record's own endpoint
    declaration (statement match at the rational); Stage D2 axiom audit
    of `Candidate.bound` (record: tmp/z78s32/stageD/); Stage D3 0
    `sorry` tokens across the whole submission src tree.
* METHOD (record's own words): Dirichlet nonvanishing at 0.873995 via a density-split common-divisor bootstrap: from the fourth-power global source G(99999/100000, 93/25, 3/50) a generic cube-free common-divisor source step is iterated (cube-free columns with K3 local kernels, the first artificial divisor kept inside the Hilbert-space Cauchy inequality); a density split closes the bootstrap.
* ZETA SCOPE: The tree carries its own zeta-scope endpoint (`Final.zeta_of_literal_numerator`, via `Cycle25.zeta_of_hecke`, the bridge vendored in the byte-identical hailey-collet tree): `theta < s.re -> riemannZeta s != 0` at exactly 174799/200000; the named input below is its guarded form (the s != 1 guard inert). Board best at the 2026-10-27 catalogue pull (merged 06:11Z that morning).
* STATUS IN THIS PROGRAM: a NAMED EXTERNAL INPUT of the same class as
  [Z78] / [Z78L] / [Z78T] / [Z78G] / [Z78C] - a kernel-verified
  external theorem, entered only as a hypothesis.  The boundary is the
  exact rational 174799/200000 itself (the record's Lean statement works at the
  rational - no bracketing).
* SNAPSHOT CAVEAT: the tracker board is a moving frontier; a newer
  verified snapshot supersedes this part mechanically (B6 packet
  section 8).  No RH claim anywhere: this is a zero-free half-plane,
  still 0.373995 away from the critical line in off-line distance.
  Still far from 1/2.
-/

namespace Z78Sil32

/-- The certified rational boundary: the tracker record `sil-density-split-20261026` proves
    its all-Dirichlet statement at exactly `174799/200000` (see header).
    Exact: `174799/200000 = 0.873995`. -/
noncomputable def sil32Upper : ℝ := (174799 : ℝ) / 200000

/-- The off-line distance bound it yields: an off-pair zero sits in
    `[1 - sil32Upper, sil32Upper] x C` (functional equation), hence
    `d0 = |Re - 1/2| <= sil32Upper - 1/2`.  Exact value: `0.373995` <
    colletD0max < gaoD0max < qxD0max < 3/8. -/
noncomputable def sil32D0max : ℝ := sil32Upper - 1 / 2

/-- The boundary is strictly below the [Z78C] boundary (norm_num
    certificate): this is what makes [Z78SIL32] a strict strengthening
    of [Z78C] - and transitively of [Z78G], [Z78T], [Z78L] and [Z78]. -/
theorem sil32Upper_lt_collet : sil32Upper < Z78Collet.colletUpper := by
  dsimp only [sil32Upper, Z78Collet.colletUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78C] off-pair bound
    (no numeric work: subtraction is monotone). -/
theorem sil32D0max_lt_colletD0max : sil32D0max < Z78Collet.colletD0max := by
  dsimp only [sil32D0max, Z78Collet.colletD0max]
  exact sub_lt_sub_right sil32Upper_lt_collet (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all predecessors by
    transitivity): the open face genuinely shrinks. -/
theorem sil32D0max_lt_38 : sil32D0max < 3 / 8 :=
  lt_trans sil32D0max_lt_colletD0max Z78Collet.colletD0max_lt_38

/-- The [Z78SIL32] named external input (kernel-verified; see header for
    provenance and status).  The Riemann zeta function (Mathlib's
    `riemannZeta`) is zero-free in the half-plane `Re s > sil32Upper`;
    the principal-pole guard `s != 1` is the [Z78Liu] consequence-form
    guard (inert on the pinned Mathlib, where
    `riemannZeta_one_ne_zero`). -/
def externalZeroFree78Sil32 : Prop :=
  forall (s : ℂ), sil32Upper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78SIL32] STRICTLY STRENGTHENS [Z78C]: zero-free on
    `Re s > sil32Upper` (with `sil32Upper < Z78Collet.colletUpper`)
    implies zero-free on `Re s > Z78Collet.colletUpper`.  The pole
    guard is carried through verbatim. -/
theorem extSil32a_implies_extCollet (hz : externalZeroFree78Sil32) :
    Z78Collet.externalZeroFree78Collet := by
  intro s hs hguard
  exact hz s (lt_trans sil32Upper_lt_collet hs) hguard

/-- (PROVEN)  [Z78SIL32] STRICTLY STRENGTHENS [Z78G] (transitivity
    through [Z78C]). -/
theorem extSil32a_implies_extGao (hz : externalZeroFree78Sil32) :
    Z78Gao.externalZeroFree78Gao :=
  Z78Collet.extColet_implies_extGao (extSil32a_implies_extCollet hz)

/-- (PROVEN)  [Z78SIL32] STRICTLY STRENGTHENS [Z78T] (transitivity
    through [Z78C] and [Z78G]). -/
theorem extSil32a_implies_extTrack (hz : externalZeroFree78Sil32) :
    Z78Track.externalZeroFree78Track :=
  Z78Collet.extColet_implies_extTrack (extSil32a_implies_extCollet hz)

/-- (PROVEN)  [Z78SIL32] STRICTLY STRENGTHENS [Z78L] (transitivity
    through [Z78C], [Z78G] and [Z78T]). -/
theorem extSil32a_implies_extLiu (hz : externalZeroFree78Sil32) :
    Z78Liu.externalZeroFree78Liu :=
  Z78Collet.extColet_implies_extLiu (extSil32a_implies_extCollet hz)

/-- (PROVEN)  [Z78SIL32] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78C] and all intermediate records). -/
theorem extSil32a_implies_ext78 (hz : externalZeroFree78Sil32) :
    Z78.externalZeroFree78 :=
  Z78Collet.extColet_implies_ext78 (extSil32a_implies_extCollet hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - sil32Upper <= Re <= sil32Upper`
    under [Z78SIL32].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78SIL32]). -/
theorem zetaZeroStripSil32 (hz : externalZeroFree78Sil32) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - sil32Upper ≤ ρ.re ∧ ρ.re ≤ sil32Upper := by
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
  have hlo : 1 - sil32Upper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - sil32Upper := not_le.mp h
    have hc : sil32Upper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ sil32Upper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩


/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78SIL32]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= sil32D0max` — the sharp
    [Z78SIL32] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78SIL32]. -/
theorem offPairD0leSil32 (q : ZeroSet) (hz : externalZeroFree78Sil32)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ sil32D0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripSil32 hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ sil32D0max := by
    rw [abs_le]
    constructor
    · dsimp only [sil32D0max]
      nlinarith [hstrip.2]
    · dsimp only [sil32D0max]
      nlinarith [hstrip.1]
  simpa using hle


/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - sil32Upper = 0.126005`, `sil32D0max = sil32Upper - 1/2 = 0.373995`. -/
def zeroFreeThetaSIL32 : Float := 0.873995
def stripLoSIL32 : Float := 0.126005
def offPairD0MaxSIL32 : Float := 0.373995
#eval zeroFreeThetaSIL32
#eval stripLoSIL32
#eval offPairD0MaxSIL32

end Z78Sil32
