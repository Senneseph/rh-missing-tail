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
import RhAttack.Z78PosReserve

open Real Set Complex

/-
[Z78GapContact]  (PR #101 tracker record `positive-gap-contact-return`,
Joseph Bebel; internal module naming `PR98Improvement`.)

PROVENANCE (B6 section 8 adoption protocol - the NINTH supersession the
chain has absorbed, after 0133 / 0142 / 0162 / 0195 / 0200 / 0203 /
0211 / the EIGHTH (0235); see Z78PosReserve for the template):
* CATALOGUE (a pointer - pointers are NOT provenance): tracker catalogue JSON pull 2026-11-01T~11:40Z (46 records; snapshot firetime/catalogue_snapshot_*.json) + watcher log tmp/b6audit/tracker/watcher_0212.log (board top = positive-gap-contact-return, merged 2026-11-01T09:53:34)
  carries this record MERGED 2026-11-01T09:53:34Z (merge commit d4fba59d479ece73d28b862b7397e3351acc7b6a) at the exact boundary
  5458637291332547/6250000000000000 (= 0.87338196661320752) - the current
  BOARD BEST (smallest theta on the board), status framework-verified,
  first verified 2026-11-01T11:38:06Z (fire-time state check; all check-runs success since 2026-11-01T02:40Z), PR #101, Joseph Bebel,
  title "All-moduli Dirichlet nonvanishing at 0.87338196661320752".
* PROVENANCE FETCH + IDENTITY: the submission source was fetched at the
  pinned source_commit 20a4c9a5afb5e6c63f9320ccdf765912fb1f29f1 (repo GTimG/QuasiRiemannTracker;
  236 files in the submission src tree,
  submissions/2026-10-31-positive-gap-contact-return/src; pre-stage clone
  tmp/b6audit/prestage101/qr, branch pr101) and snapshot-guarded (see the
  fire-time replay stage log).  The canonical entry
  (`Candidate.bound (src/Candidate/Main.lean); canonical: Qrh.PositiveGap.bound (src/Candidate/Local/Qrh/PositiveGap/BestEndpoint.lean)`) states, at the EXACT rational
  5458637291332547/6250000000000000, the all-moduli Dirichlet
  nonvanishing boundary; its statement text was identity-checked against
  the catalogue record AND independently fetched+quoted at the pinned
  commit before adoption (0248 pre-stage IDEM check).
* BUILD CONE: 4 direct Submissions prefixes ACTUALLY imported (Submissions.openai_baseline 76, Submissions.hailey_collet_1252270103 75, Submissions.arvi_repeated_marks_on_sil_face_20261025 49, Submissions.arvi_selected_leaf 9) + transitive (sil-density-split-20261026, arvi-density via arvi-selected-leaf); all trees byte-identical to the frozen replay copies (0248 pre-stage for the 4 direct; 0234 conveyor cone for the transitive); no other Submissions tree is actually imported (0211 precedent: "trees ACTUALLY imported").  Byte identity at the pinned commit:
  4 direct prefix trees byte-identical at the pinned commit (openai-baseline 2929, hailey-collet-1252270103 3549, arvi-repeated-marks-on-sil-face 701, arvi-selected-leaf 180; 0248 pre-stage diff) + transitive trees per the 0234 frozen cone.
* STATIC GATES (2026-11-01, pinned commit): 0 `sorry` / 0 `axiom` / 0 `native_decide` across the whole submission src tree (236 files, static sweep 2026-11-01 at the pinned commit).
* ZETA SCOPE: 3 files mention zeta: 2 INTENDED zeta-consequence statements (zeta_of_literal_numerator / zeta_of_global_sources - the Stage-D3 class, mirroring the EIGHTH probe) + 2 `rootZeta` helper uses in PR98Improvement/GapAdapters (a proof-side root-number helper, not a zeta-evaluation bypass); Stage D3 re-probes the zeta consequence at the exact rational.
* REPLAY (this program, independent second-party, fire-time):
  - Stage C: independent per-module kernel compilation of the
    235 own proof-cone modules (single merged olean
    root reusing the frozen EIGHTH-cone oleans, dependency-ordered
    scheduling, 30-min per-module deadline): True clean,
    [] (run 1 flagged Candidate.Local.Qrh.PositiveGap.Return.Tuning.FinalRows; its log is 2.2s rc=0 with a healthy 209KB olean - transient worker event, not a compile error; run 2 recompiled it fresh: rc=0, 235/235) failed, [] (run 2: failed=[], skipped=[], ok=235/235) skipped in
    128 (113s run 1 + 15s run 2; 235/235 kernel-clean against the frozen EIGHTH olean root + gao5_replay deps, lean 4.34.1; identity vs EIGHTH src: 182 byte-identical / 0 differs / 53 new)s (record: tmp/b6audit/prestage101/firetime/ (stageC101.log, stageC101_run2.log, stageC_summary.json, cone_identity_vs_eighth.json, logs_positive-gap-contact-return/ per-module logs)).
  - Stage D: D1 the canonical statement at the exact rational
    kernel-accepted; D2 axiom audit of the endpoint: #print axioms (fire-time, merged tree): Candidate.bound, Qrh.PositiveGap.bound, Qrh.PositiveGap.beta_le_theta all = [propext, Classical.choice, Quot.sound] - standard class only; D1 canonical Main.lean compile rc=0; D3 zeta-consequence (q=1) at the exact rational rc=0; D4 sweep: 0 sorry / 0 admit / 0 axiom decls / 0 native_decide / 0 zeta mentions in the new tree (237 files)
    - the standard Lean class, no new axioms; D3 the zeta-consequence
    form compiles at the exact rational; D4 static sweep re-run at merge
    time (record: tmp/b6audit/prestage101/firetime/stageD/ (D1_canonical.log, D2_axiomprobe.log, D3_zetaprobe.log, D4_static_sweep.json, zeta_probe_b23.lean, axiomprobe_b23.lean)).
* ZETA SCOPE (record-level): the record is the all-Dirichlet statement;
  the zeta zero-free form Re s > 5458637291332547/6250000000000000 is its
  q = 1 specialization (Stage D3 probe; the pole guard inert).  Board
  best at the merge-time catalogue pull.
* STATUS IN THIS PROGRAM: a NAMED EXTERNAL INPUT of the same class as
  [Z78] / [Z78L] / [Z78T] / [Z78G] / [Z78C] / [Z78SIL32] /
  [Z78FineChain] / [Z78DensityRefined] / [Z78ArviDensity] /
  [Z78PosReserve] - a kernel-verified external theorem, entered only as a
  hypothesis.  The boundary is the exact rational
  5458637291332547/6250000000000000 itself (the record's Lean statement
  works at the rational - no bracketing).
* SNAPSHOT CAVEAT: the tracker board is a moving frontier; a newer
  verified snapshot supersedes this part mechanically (B6 packet
  section 8).  No RH claim anywhere: this is a zero-free half-plane,
  still 0.37338196661320752 away from the critical line in off-line
  distance.  Still far from 1/2.
-/

namespace Z78GapContact

/-- The certified rational boundary: the tracker record
    `positive-gap-contact-return` proves its all-Dirichlet statement at
    exactly `5458637291332547/6250000000000000` (see header).  Exact:
    `5458637291332547/6250000000000000 = 0.87338196661320752`. -/
noncomputable def gapContactUpper : ℝ := (5458637291332547 : ℝ) / 6250000000000000

/-- The off-line distance bound it yields: an off-pair zero sits in
    `[1 - gapContactUpper, gapContactUpper] x C` (functional equation),
    hence `d0 = |Re - 1/2| <= gapContactUpper - 1/2`.  Exact value:
    `0.37338196661320752` < sil32D0max < colletD0max < gaoD0max < qxD0max < 3/8. -/
noncomputable def gapContactD0max : ℝ := gapContactUpper - 1 / 2

/-- The boundary is strictly below the [Z78SIL32] boundary (norm_num
    certificate): this is what makes [Z78GapContact] a strict
    strengthening of [Z78FineChain] - and transitively of [Z78SIL32],
    [Z78C], [Z78G], [Z78T], [Z78L] and [Z78]. -/
theorem gapContactUpper_lt_posReserve : gapContactUpper < Z78PosReserve.posReserveUpper := by
  dsimp only [gapContactUpper, Z78PosReserve.posReserveUpper]
  norm_num

/-- The off-pair bound is strictly below the [Z78SIL32] off-pair bound
    (no numeric work: subtraction is monotone). -/
theorem gapContactD0max_lt_posReserveD0max : gapContactD0max < Z78PosReserve.posReserveD0max := by
  dsimp only [gapContactD0max, Z78PosReserve.posReserveD0max]
  exact sub_lt_sub_right gapContactUpper_lt_posReserve (1 / 2)

/-- The off-pair bound is strictly below 3/8 (all predecessors by
    transitivity): the open face genuinely shrinks. -/
theorem gapContactD0max_lt_38 : gapContactD0max < 3 / 8 :=
  lt_trans gapContactD0max_lt_posReserveD0max Z78PosReserve.posReserveD0max_lt_38

/-- The [Z78GapContact] named external input (kernel-verified; see header
    for provenance and status).  The Riemann zeta function (Mathlib's
    `riemannZeta`) is zero-free in the half-plane `Re s >
    gapContactUpper`; the principal-pole guard `s != 1` is the [Z78Liu]
    consequence-form guard (inert on the pinned Mathlib, where
    `riemannZeta_one_ne_zero`). -/
def externalZeroFree78GapContact : Prop :=
  forall (s : ℂ), gapContactUpper < s.re → s ≠ 1 → riemannZeta s ≠ 0

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78FineChain]: zero-free
    on `Re s > gapContactUpper` (with `gapContactUpper < sil32Upper`)
    implies zero-free on `Re s > sil32Upper`.  The pole guard is carried
    through verbatim. -/
theorem extGapContact_implies_extPosReserve (hz : externalZeroFree78GapContact) :
    Z78PosReserve.externalZeroFree78PosReserve := by
  intro s hs hguard
  exact hz s (lt_trans gapContactUpper_lt_posReserve hs) hguard

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78C] (transitivity
    through [Z78FineChain] and [Z78SIL32]). -/
theorem extGapContact_implies_extCollet (hz : externalZeroFree78GapContact) :
    Z78Collet.externalZeroFree78Collet :=
  Z78PosReserve.extPosReserve_implies_extCollet (extGapContact_implies_extPosReserve hz)

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78G] (transitivity
    through [Z78FineChain], [Z78SIL32] and [Z78C]). -/
theorem extGapContact_implies_extGao (hz : externalZeroFree78GapContact) :
    Z78Gao.externalZeroFree78Gao :=
  Z78PosReserve.extPosReserve_implies_extGao (extGapContact_implies_extPosReserve hz)

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78T] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C] and [Z78G]). -/
theorem extGapContact_implies_extTrack (hz : externalZeroFree78GapContact) :
    Z78Track.externalZeroFree78Track :=
  Z78PosReserve.extPosReserve_implies_extTrack (extGapContact_implies_extPosReserve hz)

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78L] (transitivity
    through [Z78FineChain], [Z78SIL32], [Z78C], [Z78G] and [Z78T]). -/
theorem extGapContact_implies_extLiu (hz : externalZeroFree78GapContact) :
    Z78Liu.externalZeroFree78Liu :=
  Z78PosReserve.extPosReserve_implies_extLiu (extGapContact_implies_extPosReserve hz)

/-- (PROVEN)  [Z78GapContact] STRICTLY STRENGTHENS [Z78] (transitivity
    through [Z78FineChain] and all intermediate records). -/
theorem extGapContact_implies_ext78 (hz : externalZeroFree78GapContact) :
    Z78.externalZeroFree78 :=
  Z78PosReserve.extPosReserve_implies_ext78 (extGapContact_implies_extPosReserve hz)

/-- (PROVEN)  Every non-real zero of the zeta function lies
    in the strip `1 - gapContactUpper <= Re <= gapContactUpper`
    under [Z78GapContact].  Identical argument to
    `Z78Gao.zetaZeroStripGao` with the sharper boundary ([Z78GapContact]). -/
theorem zetaZeroStripGapContact (hz : externalZeroFree78GapContact) (ρ : ℂ)
    (hρ : riemannZeta ρ = 0) (hρim : ρ.im ≠ 0) :
    1 - gapContactUpper ≤ ρ.re ∧ ρ.re ≤ gapContactUpper := by
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
  have hlo : 1 - gapContactUpper ≤ ρ.re := by
    by_contra h
    have hlt : ρ.re < 1 - gapContactUpper := not_le.mp h
    have hc : gapContactUpper < ((1 : ℂ) - ρ).re := by
      rw [sub_re (1 : ℂ) ρ]
      norm_num
      linarith only [hlt]
    exact (hz (1 - ρ) hc h1neρ) h1rho0
  have hhi : ρ.re ≤ gapContactUpper := by
    by_contra h
    exact (hz ρ (not_le.mp h) hρne1) hρ
  exact ⟨hlo, hhi⟩

/-- (PROVEN, glue)  The instantiating step for an abstract
    zero set, under [Z78GapContact]: if every element of `q.Z` is an
    actual zero of Mathlib's zeta (the classical
    instantiation the B-0 header leaves to citation), then
    every off-line pair (t0, d0) of `q` has off-line
    distance `d0 <= gapContactD0max` — the sharp
    [Z78GapContact] value.  In particular
    `d0 < 3/8 < 1/2`, so the far region (d0 > 1/2) stays
    empty for any actual-set zero set under [Z78GapContact]. -/
theorem offPairD0leGapContact (q : ZeroSet) (hz : externalZeroFree78GapContact)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (t0 d0 : ℝ) (ht0 : 0 < t0) (hd0 : 0 < d0) (hp : P12.offPair q t0 d0) :
    d0 ≤ gapContactD0max := by
  obtain ⟨ρ, hr, hre, him, hd⟩ := hp
  have hstrip := zetaZeroStripGapContact hz ρ (hqz ρ hr) (q.nonReal ρ hr)
  rw [← hd]
  have hle : |ρ.re - 1 / 2| ≤ gapContactD0max := by
    rw [abs_le]
    constructor
    · dsimp only [gapContactD0max]
      nlinarith [hstrip.2]
    · dsimp only [gapContactD0max]
      nlinarith [hstrip.1]
  simpa using hle


/-- Data gates (Float world; the Real forms carry the theorems
    above).  Computed from the certified constants:
    `1 - gapContactUpper = 0.12661803338679248`,
    `gapContactD0max = gapContactUpper - 1/2 = 0.37338196661320752`. -/
def zeroFreeThetaGapContact : Float := 0.87338196661320752
def stripLoGapContact : Float := 0.12661803338679248
def offPairD0MaxGapContact : Float := 0.37338196661320752
#eval zeroFreeThetaGapContact
#eval stripLoGapContact
#eval offPairD0MaxGapContact

end Z78GapContact
