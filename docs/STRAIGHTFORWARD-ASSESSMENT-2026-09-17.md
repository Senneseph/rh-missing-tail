# The Riemann Hypothesis, tried with machine-checkable steps — a straightforward assessment

*What this is.* A self-contained status of the project as of 2026-09-17,
written to be forwarded to a mathematician in *any* field: every concept is
introduced before it is used, and project-specific names (codes, files,
commit ids) sit in parentheses so they can be skimmed or dropped. It is the
same honest split the proof outline keeps: machine-proven, pinned
(certified), cited — and no prize claim is made or implied.

---

## 1. The problem, in one paragraph

The Riemann zeta function (a certain infinite series in a complex variable,
central to the distribution of prime numbers) has "non-trivial zeros" —
solutions of ζ(s) = 0 away from the trivial ones. The Riemann Hypothesis
(RH) says they all lie on the vertical line Re(s) = ½, the "critical
line." Proving RH means showing there are no zeros anywhere off that line.

## 2. The project

An independent attempt to prove RH with a property most proof attempts do
not have: **every nontrivial step is independently audit-verified** — either
machine-checked or numerically certified — with a public log recording
exactly what is at which status (the project repos are named
`rh-missing-tail` / Kainos-Logos; all stages are journaled in a discovery
log, `DISCOVERY_LOG.md`). Three verification statuses are tracked per
component:

- **Machine-proven ("LEAN-PROVEN")**: a theorem in Lean 4 + mathlib, a
  proof-assistant whose checks are mechanical down to a tiny trusted kernel.
  If it compiles, the inequality is true, full stop.
- **Pinned ("PINNED")**: explicit numerical constants computed with
  directed high-precision arithmetic and certified to exact rationals — not
  "plausible decimals."
- **Cited ("CITED")**: classical theorems from the literature used as
  inputs (e.g., a zero-counting asymptotic), honestly flagged as such.

## 3. The strategy

The classical route: a zero-counting identity (an explicit formula à la
Riemann–von Mangoldt) counts zeros in a region as a main term plus an
oscillatory error tail. If, in some off-line region, a rigorous *lower
bound* on the main term exceeds a rigorous *upper bound* on the tail plus
all other corrections, the count is impossible — and that region is forced
zero-free. The project decomposes the off-line plane into families of test
configurations (project code: the "S4 uniform squeeze" program),
parameterized by height *t* (how far up the line you are) and a width/offset
parameter *d*. Each family reduces to a pure inequality between explicit
functions of *t* and *d* — "bound level." One free amplitude *M* in the
argument is universally bounded by a classical zero-density envelope
(Backlund–von Mangoldt type), so the correct statement is "for all *M* in
the envelope," and that is what is proved (the so-called "free-M" form).

## 4. What is actually proved so far

- The full foundational machinery (counting identities, decompositions, the
  first zero-counting windows) is machine-proven or pinned (code: E7a,
  B-series, the S4 program; the piece-by-piece status table in
  `docs/RH-PROOF-OUTLINE.md` §9).
- **Regime 1 — "window"** (code 25ab): one natural family of off-line
  regions, at heights *t* ≥ 1000, is squeezed: main-term lower bound
  strictly dominates tail + *M*-term, as a machine-checked theorem
  (`S4G.s4g_growth_squeeze` in `formal/RhAttack/S4Growth.lean`).
- **A core estimate at list scale** (code 25ae): a 4-term triangle bound on
  the oscillatory tail — the hardest pointwise inequality in the foundation
  — is machine-proven across the full range 1 ≤ *t* ≤ 10⁸, with exact
  rational constants at every endpoint (`p4_25ae_wall_list_scale` in
  `formal/RhAttack/P4Em2.lean`).
- **Regime 2 — "own-regime strip"** (code 25af, completed 2026-09-17): the
  second major family, covering *d* ∈ [1/200, 1/2] — i.e., tests at a fixed
  meaningful distance from the line — is now closed at height *t* ≥ 1000:
  for every *d* in the strip and every *M* in the envelope, tail bound +
  *M*-term < main-term lower bound, strictly. That theorem
  (`S4Strip.s4_strip_close` in `formal/RhAttack/S4Strip.lean`, ≈1,700 lines
  of verified Lean, full build green, every constant pinned) is the current
  frontier artifact.
- Importantly, a prior survey (code 25ad/25af) established *what the wall
  was* before this month: not a logical gap but a quantitative one — the
  relevant quantity crosses the envelope exactly at a known scale boundary.
  Working from that diagnosis, a different family of tests (scaling like
  *t*⁴) closed the closure-relevant part of the strip with a ~10% margin on
  the leading term and the rest far below budget. The progress pattern:
  diagnose the wall as a numbers problem, then beat the numbers.

## 5. What remains — honest version

Same-program work (quantified, next in line):

1. **Regime composition** (code: item (i-b)): how the two closed regimes
   account for mass when they overlap — the next explicit inequality, of
   the same kind as what was just closed.
2. **The thin strip below *d* = 1/200**: the lower bound currently in use
   has a floor at *d* ≥ 1/200. Below it, the constants don't yet close;
   it's open, though at the current scale it's not closure-relevant (the
   true squeeze edge sits at *d\** ≈ 0.00474, below the floor).
3. **Assembly**: packing window + strip into one theorem over the union of
   regimes (mechanically small; code: S4Asm).
4. **Demoting a cited input to machine-proven**: the test-function input
   class is currently carried by a cited classical estimate
   (Platt–Trudgian type). Closing that gap is a separate open thread.

Whole-program honesty (say this part out loud):

- What exists is a **bound-level closure of two major off-line regimes,
  starting at height *t* ≥ 1000**, with every nontrivial step
  machine-verified or certified. That is a genuine, publishable-grade
  fragment of an off-line zero-free statement — not a metaphor.
- It is **not** yet a proof of RH. The program requires *every* regime off
  the line — all heights including below 1000, all strips, all the low-height
  territory — to close with the same verified ingredients, and some inputs
  are still cited rather than machine-proven. Nobody can currently forecast
  whether this decomposition strategy reaches the full plane; that is an
  open quantitative question, and the project treats it as such.
- The standing discipline (kept to date): no claim of a prize or a solution
  is ever made or implied.

## 6. The sentence to remember

The off-critical-line plane is being decomposed into explicit-inequality
regimes, and two of the major regimes are now fully closed by
machine-checked proof with certified constants — and the remaining work is
identified, quantified, and of the same kind. It's a long march where every
step is verifiable by anyone, rather than a leap of faith.

---

*Provenance (2026-09-17).* This document is a snapshot layer over
`docs/RH-PROOF-OUTLINE.md` (the full piece-by-piece status table with
per-number provenance) and `DISCOVERY_LOG.md` (the journal). The frontier
artifact is commit f3b3b18 of this repository ("25af Stages 1–5 (Lean port
LANDED): S4Strip module green — s4_strip_close LEAN-PROVEN"). All quoted
numbers (1/200, 10⁸, d\* ≈ 0.00474, ~10% margin) come from the pinned
constants scripts committed alongside the modules they certify. Framing:
owner-conceived project with AI co-developed instruments, fully disclosed;
no prize claim is made or implied.
