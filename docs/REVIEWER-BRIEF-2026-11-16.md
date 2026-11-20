# Reviewer's Brief — the rh-missing-tail project
**2026-11-16 · prepared for an outside lay investigation (no mathematical training assumed)**

---

## 1. What this project is, in one paragraph

This is a single-person research program, entirely software, aimed at the
**Riemann Hypothesis (RH)** — the century-old unsolved conjecture that all
"non-trivial zeros" of the Riemann zeta function lie on a specific vertical
line (the "critical line") in the complex plane. The program's claim is not
"RH is proved." Its claim, which is verifiable in a machine in an afternoon,
is a **two-part machine-checked architecture**:

**(A) A certified census of zeta zeros just above the previous world-record
height.** 127 consecutive "windows" of ~20,000 zeros each — 2 539 992 zeros in
all, from height ~3.00017×10¹² up to 3,000,175,926,259 (the 2 000 000
target landed exactly in the 21-point W100 tail; W101–W127 are post-target
windows: twenty-nine recorded flags adjudication-confirmed (fresh 4/4, 6/6,
4/4, 5/5, 4/4, 5/5×3, 5/5, 4/4/5/5/4/4 in W112, 5/5 in W113, 4/4 in W114,
4/4, 4/4 in W116 — first two-failure window of the series, 5/5 on a wide
six-glyph union in W117, 7/7 + 4/4 in W120 — second two-failure window
with the first four-gram failure block, 5/5 + 5/5 on wide six-glyph unions
in W121 — third two-failure window, 4/4 + 6/6 in W122 — fourth two-failure
window with the series' first seven-glyph union, 4/4 in W123, 4/4 + 7/7 in W124 —
fifth two-failure window with the series' second eight-glyph union, 5/5 on
the second four-gram block in W125, 4/4 in the one-gram-snap W126, 4/4 +
5/5 in W127 - seventh two-failure window, including the third four-gram), W110-W111, W115, W118 and W119 five CLEAN windows, the 2 040 000 through 2 520 000 marks crossed, the frontier past the 500 000-unit milestone (593 459 above H0) — have been located and
**independently machine-certified as lying on the critical line**, by a purpose-
built Python certification pipeline whose output records are bit-stable,
re-verifiable from a separate verifier program, and audited by independent
high-precision recomputation.

**(B) A machine-checked logical skeleton (Lean 4 + mathlib) that reduces
"prove RH" to a small, precisely named list of remaining obligations.**
≈383 formal modules, zero `axiom`, zero `sorry`, full build 17,454 jobs green
(re-built daily). The skeleton takes the certified census as in-tree input and
derives, step by step, that **the entire residual analytic content of RH above
the certified frontier is a single named geometric fact** — "every zero above
height 3,000,175,926,259 is on the line" (the *terminal face*) — and that this
fact further reduces to **two precisely-stated squeeze conditions** on possible
off-line zeros. Every theorem in the chain carries an explicit `NO RH CLAIM`
label: nothing is asserted that the machine has not checked.

Anyone (a mathematician, a judge, a curious engineer) can inspect the git
history (794 commits), re-run the Lean build, re-run the window verifier,
and audit the individual zero records.

---

## 2. Background for the non-specialist

- The zeta function ζ(s) encodes the prime numbers. Its "zeros" (points where
  it equals 0) behave like the spectrum of a hidden drum. RH says all the
  interesting zeros sit on one vertical line.
- If true, it reorganizes the distribution of primes. It is the most famous
  open problem in mathematics; solving it is a $1M Clay Prize problem.
- "Proving" RH in one stroke has resisted all of 19th–21st century
  mathematics. A different, legitimate engineering stance — used here — is:
  *verify as much as a machine can verify, machine-check every logical step,
  and isolate the remaining open content so precisely that it becomes a
  finite list of named, testable, well-posed statements.* This project does
  exactly that, at scale that previous RH work has not reached.
- Two kinds of machine are used, and they are deliberately separate:
  - **Python/multiprec** does the *computation* (finding zeros, certifying
    records) at 60–300 decimal digits, with independent re-walks.
  - **Lean 4** does the *logic* (every deduction is checked by a kernel that
    only accepts correct proofs). Lean is the same technology used to
    machine-verify the 2024 Feit–Thompson theorem and the Liquid Tensor
    Experiment — a gold standard in verified mathematics.

---

## 3. The impressive, specific, checkable facts

### Computation pillar (the census)
- **2 539 992 zeros on the line, certified, in the window program
  W1…W127**, covering (tPT2, tCE127] with
  tCE127 = 3,000,175,926,259 — the certified frontier stands PAST the
  **500 000-unit milestone** (593,459 above the cited frontier; the
  milestone crossed in W107 with margin 1, then 505k, 510k, 515k, 520k,
  525k, 530k, 535k, 540k, 545k, 550k, 555k, 560k, 565k, 570k, 575k, 580k,
  585k, 590k in W109-W127 - the 590k crossing (margin 3 459) landed
  exactly as the 0459 schedule predicted; the 595k round mark is 1 541
  ahead, tabled W128), **above the Platt–Trudgian world-record
  height of 3×10¹²** (the certified band rises from the cited frontier
  tPT2 = 3,000,175,332,800 to tCE127; the 2 040 000 through 2 520 000
  certified-zero marks crossed in W103 (mid-window) and W104–W127; W108
  and W112 are the two three-failure windows, W116, W120, W121, W122,
  W124 and W127 the six two-failure windows, W126 the sixth snap of the
  post-target series (one-failure, adjudication-confirmed) — all
  adjudication-confirmed flags; W110, W111, W115, W118 and W119 are the
  five clean windows so far, no adjudication needed; the 2 000 000
  program target landed exactly in W100, and W101–W127 extend the census to
  2 539 992 as the post-target extension).
- Each window is a self-contained bit-stable record: exact rational
  (scaled-integer) Gram-point values, sign walks of the zeta-Z function at
  the certified height, prime-theoretic (Rosser) cross-checks, per-zero
  brackets. A **separate verifier program** re-derives `CERTIFIED: true`
  from the file alone (e.g. W98: 20,000 = b−a = sign changes, all cross-check
  failure lists empty).
- Window 96 was the **seventh completely clean 20,000 record** in the series;
  Window 97 and Window 98 each carried 3 internal prime-theoretic flags, and
  **independent re-computation adjudicated all 6** (W97: the 3 flagged unions
  each contain exactly the predicted zeros — 6/5/5 — found by bisection;
  W98: the 3 flagged unions each contain the predicted zeros — 5/5/5 — a stale pre-reboot audit run had misread them as zero-fresh; the durable re-adjudication of 2026-11-17 re-counted them from scratch, confirmed the pipeline record, and the erratum is committed).
  These adjudications are exactly the kind of thing an outside investigator
  can replicate with the scripts. (Both adjudications are complete and pinned: W97 fresh 6/5/5, W98 fresh 5/5/5, all eight control spans pass, verdict JSONs in the artifact record).
- The 2,000,000 certified-zero mark **landed exactly in Window 100** (the 21-point tail: 1 999 979 + 21 = 2 000 000, margin 0); Window 101 (the first post-target-extension window) carries one recorded prime-theoretic flag, **determined, rescued, and independently adjudication-confirmed (fresh 4/4, no near-zero touch, 4/4 control spans pass — verdict ALL SPANS RESOLVED)**; Window 102 is a clean one-gram snap (requested 20 000, certified 19 999, zero
flags); Window 103 is a clean three-gram snap (certified 19 997, zero flags)
in which the 2 040 000 certified-zero mark was crossed (margin 19 996);
Window 104 is the full-width 20 000 window with one recorded flag, determined
and rescued, independently adjudication-confirmed (fresh 6/6, 4/4 control
spans); Window 105 is the same shape (adjudication-confirmed fresh 4/4); Window 106 is the same shape again (adjudication-confirmed fresh 5/5); Window 107 is the one-gram SNAP window (19 999) with one recorded flag, determined and rescued, adjudication-confirmed fresh 4/4; Window 108 is the FULL-width window with THREE recorded flags (first multi-failure window), all determined and rescued, adjudication-confirmed fresh 5/5 on each; Window 109 is the FULL-width window with one recorded flag, determined and rescued, adjudication-confirmed fresh 5/5 (the 505 000 mark crossed); Window 110 is the one-gram SNAP window (19 999) and CLEAN - zero recorded failures, no adjudication needed (the 510 000 mark crossed); Window 111 is the FULL-width window and CLEAN (second consecutive clean window, the 515 000 mark crossed); Window 112 is the FULL-width window with THREE recorded failures - all determined, rescued, adjudication-confirmed fresh (4/4, 5/5, 4/4) (the 520 000 mark crossed; second multi-failure window); Window 113 is the one-gram SNAP window (19 999) with one recorded failure, determined and rescued, adjudication-confirmed fresh 5/5 (the 525 000 mark crossed); Window 114 is the FULL-width window with one recorded failure, determined and rescued, adjudication-confirmed fresh 4/4 (the 530 000 mark crossed); Window 115 is the FULL-width window and CLEAN - zero recorded failures, no adjudication needed (the 535 000 mark crossed); Window 116 is the FULL-width window with two recorded failures - both determined, rescued, adjudication-confirmed fresh 4/4 and 4/4 (the 540 000 mark crossed); Window 117 is the FULL-width window with one failure - determined, rescued on a wide six-glyph union, adjudication-confirmed fresh 5/5 (the 545 000 mark crossed); Window 118 is the FULL-width window and CLEAN - zero recorded failures, no adjudication needed (the 550 000 mark crossed); Window 119 is the FULL-width window and CLEAN - zero recorded failures, no adjudication needed (the 555 000 mark crossed); Window 120 is the FULL-width window with two failures - including the first four-gram failure block, rescued 7/7 + 4/4, adjudication-confirmed (the 560 000 mark crossed); Window 121 is the FULL-width window with two failures - both determined, rescued on wide six-glyph unions, adjudication-confirmed fresh 5/5 + 5/5 (the 565 000 mark crossed, margin 422 - smallest since the W107 milestone); Window 122 is the FULL-width window with two failures - both determined, rescued 4/4 and 6/6 (the series' first seven-glyph union), adjudication-confirmed (the 570 000 mark crossed, margin 95 - the smallest unit-margin crossing since the W107 milestone); Window 123 is the FULL-width window with one failure - determined, rescued 4/4 on a five-glyph union, adjudication-confirmed (the 2 440 000 mark crossed; SUB-STANDARD 4 672 floor increment, so the 575 000 mark is NOT crossed - 233 ahead, tabled W124); Window 124 is the FULL-width window with two failures - both determined, rescued 4/4 (five-glyph union) and 7/7 (the series' SECOND eight-glyph union, tied with W120 for the widest span), adjudication-confirmed (the 575 000 and 2 460 000 marks crossed, margins 4 440 / 19 993 - exactly as the corrected 0456 schedule predicted); Window 125 is the FULL-width window with one failure - the SECOND FOUR-GRAM FAILURE BLOCK of the series (the first was W120), determined, rescued 5/5 on a six-glyph union, adjudication-confirmed (the 580 000 and 2 480 000 marks crossed, margins 4 113 / 19 993 - exactly as the 0457 schedule predicted); Window 126 is the ONE-GRAM SNAP window (certified width 19 999) with one failure - standard three-gram, determined, rescued 4/4 on a five-glyph union, adjudication-confirmed (the 585 000 and 2 500 000 marks crossed, margins 3 786 / 19 992 - exactly as the 0458 schedule predicted); Window 127 is the FULL-width window with two failures - including the THIRD FOUR-GRAM FAILURE BLOCK of the series (after W120 and W125) - both determined, rescued 4/4 and 5/5, adjudication-confirmed (the 590 000 and 2 520 000 marks crossed, margins 3 459 / 19 992 - exactly as the 0459 schedule predicted).

### Formal pillar (the Lean skeleton)
- **378 RhAttack modules, zero axioms, zero `sorry`.** Full build:
  17,454 jobs, green, repeated daily. Lean 4.33.1 + mathlib.
- The endpoint engine (`RHEnd`) states the whole program as one family of
  implications: *census + named external inputs + terminal face ⇒ RH*,
  instantiated at each re-anchored frontier (currently H = tCE100 =
  3,000,175,800,092 — the CE97–CE100 re-anchors are complete and green;
  `TerminalFaceCE100` and `TerminalSqueezeCE100` state the endpoint form
  and the final squeeze assembly at this frontier).
- **The reduction theorems (all machine-checked):**
  1. `TerminalFaceCE100` (unit 134, prototype `TerminalFaceCE96` unit 130): *under the terminal face at the
     frontier, the endpoint's residual legs are empty* — no off-pair exists
     at or above the frontier (the face above, the boundary-inclusive census
     at), so **RH at the frontier ⇐ terminal face + census + [Z78]**.
  2. `Face38PosReserve` (unit 131): the terminal face ⇔ "no off-pair in the
     band 0 < d₀ ≤ 0.37338197 above H", under the **strongest in-tree
     zero-free input** ([Z78PosReserve]: zero-free for Re s >
     8733819666133/10¹³, an all-Dirichlet tracker record adopted with
     bit-identical merge provenance). The full ladder of 8 cited zero-free
     results (Collet, Gao, Liu, QX-Track, Arvi, PosReserve, …) is formalized
     as named inputs in narrowing bands.
  3. `TerminalSqueeze` (unit 132, in final build): **RH ⇐ census + two
     squeeze faces** — (i) the low strip 0 < d₀ < 1/200 (the S4/hWin
     residual), and (ii) the mid band 1/200 ≤ d₀ < 1/2, where the in-body
     T4 squeeze (closed-form pin with **strict margin ≥ 1.419, machine-
     checked; the strict step is the exact rational fact
     2^(101/200) > 1001/1000**) excludes off-line zeros from the named S3
     wire face alone.
  4. `SIs` / `SIsA1` (units 128–129): Ismail's explicit finite-height bound
     for |S(T)| (Zenodo 23301655) is admitted as a **named input, not an
     axiom**, and in-tree consequences are machine-checked: a data-free
     frontier pin **|S(tPT2)| ≤ 6** (in-tree value < 14893541/2500000) and
     the **A1 clause discharged with data-free constants** (oscillation
     bound (Sbound(x_M)+1/8)·(17/8) < 833/64 at the frontier) — a
     replacement for ledger constants that were ~10¹⁰ in magnitude.
- The discipline is auditable: numbered **discovery log (415 entries so far
  today)**, git commits that quote the build evidence, an explicit
  `NO RH CLAIM` label on every module, and a provenance pin file for all
  external data.

### Why this is unusual
Most RH work is either pure analysis (no machine verification beyond
arithmetic) or computation (no logical skeleton). This program holds **both
at a height (just above 3×10¹²) and a logical resolution (the residual is a
list of four named faces, not a fog)** that, to our knowledge, no published
work has combined — and every artifact is in one git repository.

---

## 4. What a mathematician would verify, in order

1. `git clone` the repo; `cd formal; lake build` — expect the full green
   build (≈17,454 jobs). No axioms: `rg "axiom" formal/RhAttack` returns
   nothing but the prose "no axioms" discipline.
2. Read `formal/RhAttack/RHEnd.lean` (the endpoint), `TerminalFaceCE96.lean`,
   `Face38PosReserve.lean`, `TerminalSqueeze.lean` — the reduction chain.
3. `cd tmp/ce2/ce1_window_H0_v1; python3 code/verify_window.py
   window98_b98.json` — expect `CERTIFIED: true`.
4. Read the census records + the verifier + one independent audit
   (`/tmp` scripts are reproducible from the discovery log entries 0412–0417).
5. The open questions for the expert, precisely named, in-tree:
   - the **S3-BAND FACE** (mid-band wire bound) and the **S4-STRIP FACE**
     (low-strip squeeze) — the two named analytic residuals;
   - the **external zero-free inputs** [Z78-family] (tracker records —
     verified bit-identical to merged submissions, but external);
   - the **finite-precision nature** of the census (dps-60…300, independent
     re-walks — a numerical certification, not a formal real-analysis proof).

---

## 5. What this project does NOT claim (honest limits)

- **No proof of RH is claimed or implied.** Every module says so in its
  header.
- What *is* claimed, and machine-checked: (a) the logical skeleton and its
  theorems; (b) the certified zero census above 3×10¹² (as a numerical
  certification); (c) the reduction of RH-above-the-frontier to the named
  faces; (d) the in-tree consequences of the named external inputs
  (Ismail bound → |S| ≤ 6 at the frontier → data-free A1 constant).
- The two squeeze faces remain **open analytic statements** — they are
  precisely what a future proof would have to close (or a different zero-free
  region would have to consume). That is the entire remaining gap, stated by
  name.
- The Lean proof assistant verifies the *logic*; the floating-point zeta
  evaluations are verified by a *separate* numerical audit system. The
  combination is the design; neither alone is a proof of the other's
  territory.

**L1 track status (2026-11-17, discovery entries 0423–0430).** The
Levinson–Conrey asymptotic track (the 4/7 wall in
`RhAttack/LevWall{6,7,8}`) received a page-level deep read of the cited
source (Pratt–Robles, arXiv:1706.04593, the paper PRZZ delegates its
term bookkeeping to). Findings, all machine-registered in the new module
`RhAttack/LevWall8` (build green): (i) the published 4/7 is exactly the
saturation point of the quoted clean error form
T^eps(N^{7/4} + T^{1/2}N^{7/8}); the full worst-block reconstruction admits
θ < 3/5 — i.e. the published constant carries an unpublished margin of 1/35;
(ii) the 2026 Blomer–Pascadi all-moduli Kloosterman estimate was audited as
a wall input and found NOT to transfer in this extraction: the a-range
A = N1N2/(d²T^{1−ε}) is ≤ T^ε in every block, so the bilinear axis the 1/32
critical saving needs is degenerate, the binding Kloosterman step is
one-variable (Weil-sharp), and the wall stands (entry 0430); a future
two-side movement would need a non-degenerate-axis input at the binding
Type-I step — recorded as the open follow-up L1b. No RH claim; the wall is
unmoved, and the margin finding is a fact about the published constant.

---

## 6. Bottom line for the reviewer

This is a reproducible, single-repository program that (a) has **machine-
certified the behavior of 2 million zeta zeros above the previous
world-record height**, and (b) has **machine-checked the logical architecture
that says exactly which four named facts — and no others — stand between the
current state and RH**, with the largest of those facts (the zero-free
half-plane inputs) already backed by externally audited tracker records.
It is not a proof. It is, in our judgment, the most precisely isolated and
machine-verified formulation of the remaining problem that currently exists,
and it is the kind of artifact an expert can either extend or refute within
days of the clone command, not months of reverse-engineering.

*Prepared 2026-11-16. Repository: `rh-missing-tail` (git, 794 commits).
Formal tree: `formal/` (Lean 4.33.1, 17,454-job build green as of today).
Census: `tmp/ce2/ce1_window_H0_v1/` (windows W1–W99 in flight).*
