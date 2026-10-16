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

Effort note: items 1-3 and 6 are a few hours of machine
and diff work; item 4 is a focused patch audit; item 5 is
the weeks-scale item. A GO on the input requires item 4 to
pass and item 5 to reach at least "no flaw found in the
load-bearing pieces"; items 1-3 and 6 should pass unconditionally.

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
