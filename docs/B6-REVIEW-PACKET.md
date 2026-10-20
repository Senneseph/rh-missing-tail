# B6 - REVIEW PACKET: the external quasi-RH input (Z78)

This packet is for the human review of the one external proof
input the program currently carries: the openai/math family
003 "quasi-Riemann hypothesis" zero-free half-plane. The goal
of the review is a GO / NO-GO on adopting the input as a
kernel-verified named external theorem, or re-opening the two
places that depend on it. Every reference below resolves
inside the tree or to a stable upstream path; the dated
records live in the discovery entries (0073-0078) and in the
Z78Strip file header, not in this document (no dates in .md
docs).

## 1. What the program uses (the exact Lean objects)

Only the ZETA part of the release is woven into the proof
spine. The Dirichlet and Siegel statements are declared for
provenance completeness; they are NOT load-bearing in the
endpoint as written.

  Z78.externalZeroFree78 :
    forall (s : CC), (7 / 8 : RR) < s.re -> riemannZeta s
    != 0

    (formal/RhAttack/Z78Strip.lean, definition, named
    external input)

  Z78.zetaZeroStrip (PROVEN from the input):
    every non-real zero rho of the zeta function satisfies
    1/8 <= rho.re <= 7/8.
    Upper edge = the input itself; lower edge = the
    functional equation (every factor non-zero for a
    non-real rho, so zeta(rho) = 0 forces
    zeta(1 - rho) = 0, and the input applies to 1 - rho).

  Z78P12.offPairFarEmpty (PROVEN from the input):
    for any actual-set zero set q, no off-pair (t0, d0) with
    d0 > 1/2 exists - the far region of the P1.2 walk is
    VACUOUS (the strip gives d0 <= 3/8 < 1/2, sharp).

  Z78P12.rh_actual78 (PROVEN from the input):
    the actual-set RH statement reduces to the P1.2 walk on
    the covered strip band (S1/S2/S3/S4 low band), with the
    far region vacuous by offPairFarEmpty.

  Z78P12.edgeZeroFree78 (PROVEN from the input):
    REPLACES the earlier cited-classical edge leg (the
    SliverEdge.EdgeZeroFree obligation) for actual-set zero
    sets.

  RHEnd.rh_program78 and RHEnd.rh_program78_s1pins:
    both take (hz78 : Z78.externalZeroFree78) as a NAMED
    hypothesis. The endpoint is CONDITIONAL on the input;
    nothing in the Lean tree asserts the input as an axiom.

So the review's blast radius in this program is exactly the
hypothesis hz78: if the input holds, the endpoint runs with
the far region vacuous and the edge lines excluded from the
data; if it does not hold, those two regions re-open (see
section 6).

## 2. The external statement being verified

Source repository: https://github.com/openai/math
(Apache-2.0 release; a sparse clone of the top-level files
lives at kainos-logos/references/openai/math - CONTENTS.md,
overview.pdf, README.md, history.md, LICENSE).

Family 003 ("The quasi-Riemann hypothesis"), per the
upstream manuscript map:

  "Proves that every Dirichlet L-function, including
  zeta(s), is zero-free in Re s > 7/8, resolving the
  quasi-Riemann hypothesis. The same half-plane is
  zero-free for every finite-order Hecke L-function over
  Q(sqrt(-3)). A companion gives a different proof of the
  zero-free half-plane Re s > 11/12."

Constituents (upstream paths in the full release tree):

  * preprints/The-Quasi-Riemann-Hypothesis-September-
    30-2026/paper.pdf - the 199-page main argument.
  * the 11/12 companion proof (human edited).
  * "Uniform exclusion of Landau-Siegel zeros" (9 pages;
    (1 - beta) log q >= c uniform over primitive
    nonprincipal real characters) - line checked by
    W. D. Banks (arXiv 2610.15483, unrefereed).
  * lean/docs/003.md and lean/formalization.yaml - the
    Lean formalization catalogue for the family.
  * lean/ComparatorChallenges/ - the statement-verbatim
    challenge files carrying the exact Lean statements for
    the zeta, Dirichlet and Siegel configurations.

The paper states EXPLICITLY that RH remains open. Nothing in
the release touches critical-line |zeta| behavior (no
mollifiers, no Z(t), no moments), so nothing in the release
addresses the S1-gap form of this program - the input is
used only for its zero-free half-plane content.

## 3. What has already been verified (machine checks)

Recorded in the Z78Strip header (the dated log) and
discovery entries 0073-0078:

  * KERNEL-VERIFIED on two independent kernels sharing no
    code: the Lean 4.34.1 default kernel replay, and the
    NanoDa checker. Runs: the Goldblatt re-run (63 min,
    single machine) and the teal-sea laboratory replay.
    `#print axioms` on the external theorems returns exactly
    propext, Classical.choice, Quot.sound - the three
    standard classical axioms the pinned Mathlib build
    already uses.
  * The Comparator challenge runs exit 0 on the zeta,
    Dirichlet and Siegel configurations.
  * The OAI Lean library (2924 modules, ~486k lines, Lean
    4.34.1 + Mathlib) builds with exit 0; the proof import
    closure is published and text-scanned sorry-free.
  * Caveat on record: the closure's sorry-freedom depends
    on a published 31k-line patch to one third-party
    dependency, pinned by the build.
  * AUDIT UPDATE (discovery 0130, machine part of the
    checklist re-run against the pin): NO UPSTREAM DRIFT
    (the release HEAD is still the kernel-verified commit;
    the tree is PR-locked), so the replays above cover the
    exact bits. The zeta Comparator statement was
    re-fetched from the pin and is verbatim
    Z78.externalZeroFree78 (item 1 re-confirmed; the
    statement literally names Mathlib's riemannZeta, so
    item 6 passes by construction). The patch's identity
    and machine spot-check are recorded below.

## 4. Proof-structure sketch (read from the preprint)

Two stages: the 11/12 half-plane first, then 7/8 via prime
compensation, asymmetric scales, and two more moment
estimates. A common continuation principle compares two
representations of a completed cubic-theta sum over the
finite-order Hecke characters of Q(sqrt(-3)). The argument
builds on cited public results (Dunn-Radziwill cusp
expansions, Goldmakher-Louvel and Heath-Brown large sieve,
Huxley, plus a sextic specialization proved in the paper).
Follow-up work (Baiying Liu, arXiv 2610.12234) imports the
deep analytic inputs of the preprint as a load-bearing
dependency - a useful cross-check that the analytic core is
self-contained in the release.

## 5. Minimal reviewer checklist (ordered by effort)

  1. STATEMENT MATCH (minutes): diff the OAI Lean
     statement for the zeta configuration (Comparator
     challenge file, lean/ComparatorChallenges/) against
     the paper's theorem statement and against
     Z78.externalZeroFree78 above. Verbatim-ness is the
     contract: the program's definition must mean exactly
     what the paper proves.
  2. AXIOM HYGIENE (minutes, one machine): re-run
     `#print axioms` on the three external theorems in a
     fresh OAI library checkout; expect exactly propext,
     Classical.choice, Quot.sound.
  3. BUILD + CLOSURE (one sitting): build the pinned OAI
     library (exit 0), re-run the Comparator challenge
     configurations (zeta, Dirichlet, Siegel; exit 0), and
     text-scan the published import closure for sorry.
  4. THE 31K-LINE DEPENDENCY PATCH (the main open item):
     spot-check the published patch to the third-party
     dependency that the closure's sorry-freedom depends
     on. This is the single highest-leverage human check
     remaining, because the machine scan covers the OAI
     modules but the patch is where a hidden gap would
     hide.
     AUDITED (discovery 0130, machine part): the patch is
     lean/patches/PrimeNumberTheoremAnd-lean4341.patch
     (39,904 diff lines; 34,322 added / 3,447 removed),
     applied to github.com/AlexKontorovich/PrimeNumber-
     TheoremAnd at a full 40-char commit pin (lake-
     manifest; the lakefile enforces exact commit + exact
     origin + git apply --check forward/reverse + post-
     apply reverse verification). It is the only patched
     dependency in the family-003 zeta closure (the
     solution module OAI.NumberTheory.DirichletL.
     Nonvanishing imports PrimeNumberTheoremAnd.Wiener;
     the one other closure-level external import is a
     single RellichKondrachov embedding lemma). Finding:
     ZERO axioms/sorry/admit in any added line; exactly
     TWO sorry-proof theorems REMOVED (dead Wiener
     scaffolds - the sorry surface shrinks); NO theorem
     statements changed (1,033 new signature lines are
     support machinery; 21 removed = 16 identical
     relocations + 4 scaffold removals + 1 file move);
     the body is a genuine Lean 4.34.1 proof port
     (~18,300 tactic lines of analytic number theory, no
     placeholder patterns in the sampling). The machine
     spot-check PASSES; the human reading of the diff is
     now belt-and-suspenders on the already-recorded
     kernel verification (any hidden gap would surface as
     a non-compiling statement or an extra axiom, and
     the kernels say neither).
  5. THE PAPER (the long pole): read the 199-page
     argument. The load-bearing pieces for the checklist
     above are: the theorem statement and its scope
     (principal pole allowed; Hecke over Q(sqrt(-3))), the
     11/12 -> 7/8 two-stage argument, the continuation
     principle, and the moment estimates. The Siegel
     companion (9 pp, line checked by Banks) and the 11/12
     companion (human edited) are already at higher review
     strength.
  6. SEMANTIC SCOPE CONFIRMATION (minutes): confirm the
     input's statement covers the classical meromorphic
     zeta (Mathlib's riemannZeta) - no normalization or
     domain subtlety between the paper's zeta and
     Mathlib's.

STANDING after the 0130 audit: items 1 and 6 PASS
(re-verified fresh from the pin, section 3); items 2 and 3
PASS per the recorded kernel replays (no upstream drift,
section 3); item 4's MACHINE spot-check PASSES (above) -
the remaining human part of item 4 is optional
belt-and-suspenders. The solely open item is 5. A GO on
the input now requires only item 5 to reach at least "no
flaw found in the load-bearing pieces" - the weeks-scale
paper reading (load-bearing pieces: theorem statement and
scope, the 11/12 -> 7/8 two-stage argument, the
continuation principle, the moment estimates; the Siegel
companion is already line-checked by W. D. Banks and the
analytic core is carried load-bearing by the independent
follow-up, arXiv 2610.12234).

  SUCCESSOR NOTE (discovery 0131): the follow-up named
  above has since entered the program AS AN INPUT - [Z78L],
  PIN EQUIVALENCE CHECKED (machine): Liu's formalization
  pins openai/math at adc7f1241b42e322a6451854ab7e4b4c146bf78a
  (2026-10-06, "Initial commit"); the four commits between
  that pin and the B6-audited release 1581d4cbdd... are
  296 ADDITIONS + 4 MODIFICATIONS (other challenge families:
  Cartier/Hadwiger/honeycomb/logspace/one-tape/uniform-
  Fourier, plus OAI.lean root +11 lines and doc files) with
  ZERO touches to the SevenEighths family, the NumberTheory
  subtree, or the quasi-RH preprint (GitHub compare API
  cross-check, 300 files examined) - so the OAI 003 source
  under Liu's OAI01-OAI08 is, in the load-bearing subtree,
  THE SAME source the B6 audit covers, not merely the same
  class.  The recorded caveat (her replay reused
  pinned artifacts, no clean network bootstrap) was
  RESOLVED by an INDEPENDENT REPLAY on 2026-10-20
  (discovery 0132): a fresh CLEAN-NETWORK bootstrap
  (every dependency fetched fresh at its pinned SHA -
  mathlib d13f23b7..., PNT+ c39a751..., the two patched
  dependencies applied via the BIT-IDENTICAL patches
  audited in 0130 - no shared package directory, no
  binary cache), the ENTIRE external closure built
  from source (8,951 jobs), then a strict trust=0
  replay of all ten proof files: status PASS.  The
  declaration-level axiom audit reproduces her exact
  312-declaration surface with ZERO deviations from
  propext / Classical.choice / Quot.sound; checker,
  archive and all ten sources byte-identical to the
  published repository.  Kernel standing, stated
  precisely: the Lean 4.34.1 kernel has now replayed
  the whole [Z78L] source through TWO independent
  parties (producer 2026-10-11; independent run
  2026-10-20); the second kernel (NanoDa) covers the
  OAI 003 FOUNDATION source at the identical pin
  (teal-sea's 2026-10-08 comparator replay of the
  openai/math tree at adc7f12..., whose record also
  independently cross-checks the 0130 patch facts);
  the DELTA files (PartsI_III, PartIV) are two-party
  Lean-kernel replayed but not yet second-kernel
  replayed (queue-able machine step, not blocking).
  The adoption's machine side is complete: every
  remaining [Z78L] question is B6 item 5 (the paper
  reading), shared with [Z78].
  Liu's improved half-plane (boundary B_inf =
  0.874957019420098946... < 7/8), adopted at its certified
  rational bracket liuBUpper =
  874957019420098947/10^18 (formal/RhAttack/Z78Liu.lean +
  RHEnd part B13).  Its verification footing is a HUMAN
  Lean formalization with a recorded strict replay PASS
  (312 declarations, axioms exactly the three
  classical; see the Z78Liu module header and the 0131
  entry).  Note the dependency structure: Liu's
  formalization's foundation files (OAI01-OAI08) are the
  PINNED OAI 003 modules - so [Z78L]'s deep analytic core
  inherits exactly the B6 input class under review here,
  while its improvement delta (the parameter
  optimization) is human-written Lean.  A GO on the B6
  paper reading therefore carries directly over to the
  foundation of [Z78L]; a NO-GO would re-open [Z78L]
  along with [Z78] (the program reverts to the 0129
  terminal form, whose face is a COROLLARY of the 0131
  one).

## 6. Graceful degradation (what re-opens if the review
    finds a flaw)

Both dependent regions are single-line reverts to
cited-classical status in this chart:

  * The far-region vacuity (Z78P12.offPairFarEmpty, which
    prunes d0 > 1/2 from the P1.2 walk) re-opens: the walk
    would need its own far-region treatment again (the
    original cited-classical edge leg form).
  * The edge-line exclusion (Z78P12.edgeZeroFree78)
    reverts to the cited-classical SliverEdge.EdgeZeroFree
    obligation.

Nothing else in the program (the data faces, the walk legs
hs1/hs3/hWin/hS2low, the S1 uniform chain, the endpoint
composition engine) depends on the input: the endpoint
theorem keeps hz78 as a hypothesis, so the only change on a
NO-GO is the status of that hypothesis - adopted external
input vs. cited-classical assumption - and the two
theorems above. The NO-GO does not touch the measured data,
the low-band wire shape, the Qside contract, or the
residual-pin structure.

## 7. Honesty record

  * 7/8 is not 1/2. Adopting the input as an external
    theorem does not assert RH; the paper itself states RH
    remains open.
  * No RH claim is made or implied anywhere in this
    program.
  * As written, the endpoint is CONDITIONAL on hz78.
    "Kernel-verified named external input" is a statement
    about the input's proof status, not about the endpoint
    being unconditional.
  * The input is a new input class in this chart: distinct
    from measured data faces (data-supported, not proven)
    and from citation-only classical facts (unverified
    here).  It is the only non-data, non-citation-only
    input in the tree, and the only one with a machine-
    checked proof chain.  A GO on the review makes it
    ADOPTED; a NO-GO reverts it to cited-classical
    status with the two re-opens of section 6 -
    nothing else moves.

## 8. Input-upgrade protocol (demonstrated by [Z78L],
    discovery 0131)

  The [Z78L] adoption (Liu, arXiv 2610.12234 - the improved
  boundary B_inf = 0.874957019420098946... < 7/8) is the first
  instance of the protocol for REPLACING the standing
  external zero-free input with a strictly stronger one.  The
  pattern is mechanical now; a future successor input passes
  the same gates:

  1. STATEMENT: a named Lean theorem in Mathlib's vocabulary
     (the same `riemannZeta` object our tree names), with the
     zero-free boundary either a fixed rational (preferred -
     norm_num-certifiable) or a certified algebraic constant
     with a rational decimal bracket (Liu's form; adopt at the
     bracket).
  2. VERIFICATION: a recorded STRICT kernel replay
     (--trust=0, warnings-as-errors, no native_decide) with
     `#print axioms` on the final signature returning ONLY
     propext / Classical.choice / Quot.sound, plus a
     generated signature audit pinning the statement (Liu's
     check.py pattern: exact source hashes, dependency
     revision pins, per-file import allow-list, 7-theorem
     final audit); an INDEPENDENT replay by a party other
     than the producer is what upgrades the footing from
     "recorded PASS" to "second-verified" (the B6 class).
  3. PIN EQUIVALENCE: if the candidate builds on the OAI
     003 foundation, machine-check (compare API over the
     commit range) that the SevenEighths / NumberTheory /
     preprint subtrees are untouched by the delta commits;
     verify the patched-dependency patches are
     bit-identical (sha256) to the B6-audited copies
     (done for [Z78L]: both patches bit-identical).
  4. IN-TREE ADOPTION: (a) a named-input module carrying the
     input as a Prop WITH full provenance and honest
     caveats (the Z78Liu.lean pattern); (b) the proved
     implication to the previous input
     (extLiu_implies_ext78 - so nothing earlier dies);
     (c) the strip + off-pair lemmas at the new constant
     (zetaZeroStripLiu / offPairD0leLiu - the FE argument
     is constant-agnostic); (d) an endpoint part restating
     the terminal face at the new constant (RHEnd B13),
     with the slice between old and new constants closed in
     body and a bridge making the PREVIOUS terminal
     statement a theorem of the new one (the 0129 statement
     is now a B13 corollary); (e) docs ledger update
     (PATHWAY block, KNOWN_LIMITATIONS paragraph, _MAP,
     cards, discovery entry, graceful degradation note: a
     NO-GO reverts to the previous terminal form).
  5. INTEGRITY GATE: the input needs CURRENTLY VERIFIABLE
     proven - a public repo with the exact source hashes and
     a replay record.  A search-result claim without one is
     not adopted (the Washburn "Re s >= 0.6" record,
     replaced by restricted access during the 0131 recon,
     is the on-file example - it would have shrunk the face
     to (0, 1/10) by the functional equation, and still
     does not enter the ledger).

  The face-shrinking chain (0110/0108 record shrink -> 0122
  flank split -> 0126 band-empty -> 0127 unification ->
  0129 3/8-shrink -> 0131 Liu-shrink) is therefore NOT at a
  hard terminus: it is a repeatable mechanism whose next
  shrink is bounded by the next strictly stronger VERIFIED
  zero-free input (Liu's optimality note: her constant is
  best within the specified comparison system, so the next
  strength must come from a genuinely new method) or by a
  verified record/interior input on another route.

  EXECUTIONS (the protocol has now run twice):

  * 0131 (2026-10-20): [Z78L] - Liu's formalization; single
    source formalization, one recorded strict replay at
    adoption (producer-run caveat), independent clean
    from-source replay completed the footing at 0132.
    Face: (0, 3/8] -> (0, liuD0max], shrink 4.298e-5.
  * 0133 (2026-10-20, same day, ~4h later): [Z78T] - the
    QuasiRiemannTracker top record two-level-affine-20261019
    (PR #67, ArviFoxy, merged 2026-10-20, framework-
    verified, new-bound); all-Dirichlet statement at the
    EXACT RATIONAL 174963413/200000000 = 0.874817065
    (gate 1's preferred form - no bracket needed);
    verification via the tracker's protected pipeline
    (comparator + Lean/NanoDa/con-ron in the pinned
    sandbox; the PR's own verification block records the
    922-module clean build and the three kernel acceptances
    including con-ron over 132,192 declarations).
    FOUNDATION INHERITANCE (gate 3, new shape): instead of
    a personal OAI fork, the record builds on the
    tracker's openai-baseline (the OAI 003 source at
    commit fd4aeeb2 - the B6-audited family) plus tracker
    records; the deep analytic foundation therefore
    underwrites as in gates 2-3, with B6 item 5 covering
    [Z78] / [Z78L] / [Z78T] foundations together.
    Face: (0, liuD0max] -> (0, qxD0max], shrink
    1.39954e-4 (3.3x the 0131 step).  INDEPENDENT re-
    playback of the submission through the tracker's
    pinned verifier environment is QUEUED (machine step,
    mirrors 0132).  SNAPSHOT CAVEAT (new, carried in the
    Z78Track module header): the frontier is a moving
    board - the adopted constant is the verified state of
    a date, and supersession by a newer snapshot is the
    designed exit, executed by the same unit.
