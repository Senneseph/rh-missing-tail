# The Riemann Hypothesis from the Series Side

**Exact action identities for Dirichlet tails, the measured width ladders
they generate, the onset at which zero content first enters the budget —
and a separation program with explicit falsifiers.**

*Preliminary note, staged experimental program · v0 · 2026-09-09.
Status: stages 0–1 PASS, stage 2 certified to 10⁶ **with no ghosts**, stage 3
in progress. This is a note to mathematicians, not a claim. Every number
has a script, a precision label, and a reproducer in `results/` and `scripts/`.*

---

## The program: hypotheses in stages

This is a **staged experimental program** aimed at RH, not a single
result. Each stage tests one hypothesis with a pre-registered
falsifier, and the outcome of stage *n* determines what stage *n*+1 is
allowed to claim. As of v0: **no ghosts** — no off-line zero, no
violation of the width laws, no unexplained S growth. Fingers crossed.

| Stage | Hypothesis | Test | Status (v0) |
|---|---|---|---|
| **0 — Instrument** | H0: dual float64 stack + dps oracle + twin-floor protocol certify their own counts (no systematic error) | dt/2 stability re-walks; two-engine agreement; measured chunk reliability | **PASS** — reliability model measured (1 dead chunk in ~70,000) with demonstrated detect-and-correct pipeline; Day-007 port-as-audit bonus (a TS port caught a ψ‴ defect in the float engine, dps-verified and fixed) |
| **1 — Identity & ladder** | H1: the Dirichlet tail is a *flat action*; the series-side laws (D = −P, the M₁ tables, the symmetries) are universal | E7a identity at dps-50 on generic paths; E2-exact: 18/18 phases at 1e-10, zero fits | **PASS** |
| **2 — Counterexample search** | H2: if RH fails below T, the certified walk finds it (off-line pair ⇒ 2K jump; S growth beyond O(1)) | GPU walk dt = 5×10⁻⁴ + dt/2 stability endpoints + dps-40 2K/S certificate | **10⁶ certified: no ghosts.** 10⁷ in progress |
| **3 — Zero-side identification** | H3: the measured onset C *is* the Riemann-1859 kernel's zero-side budget (nearest zero dominates, coefficient matches) | E7b: decompose C over the 138,065-zero list with the 1859 density kernel; E5: the zero-sum in missing-tail language | In progress (reads verbatim; test designed) |
| **4 — Generalization** | H4: the width laws extend beyond odd-prime quadratic cells (even-modulus antipodal structure; F₂₄ non-multiplicative) | τ₁₂ (2×4×3) exact table; F₂₄ front/back raw + M₁; E6 F₂₄ rolling invariants | **τ₁₂ + F₂₄ measured** (antipode sign-flip vs near-identity — two cell classes, two laws); q = 17 table in §8 (third odd modulus, all integers, mirror + trace exact) |
| **5 — Reduction (not claimed)** | If H3 passes: RH ⟺ no off-line pair ∀t, with the zero side pinned to the explicit-formula kernel | E5 bridge + structural write-up | **Not run. Not claimed.** |

What follows is the report of stages 0–2 (the abstract and the tables),
the certificates, the falsifier for each hypothesis, and the road for
stages 3–5.

---

## Abstract

No new axioms. Nothing in this note requires a tool that is not
textbook-old. We report (i) one exact identity, (ii) the structure it
measures, and (iii) a program whose next steps are specific and
falsifiable.

**The identity.** Write `A(u) = Σ_{n≤u} a(n)` for a step path and
`φ(u) = u^{−s}` for an observation weight. The summation-by-parts
identity

```
Σ_{n=N+1}^{M} a(n)·n^{−s} = A(M)M^{−s} − A(N)N^{−s} + s ∫_N^M A(u)·u^{−s−1} du
```

holds **exactly** for every step path, every s, every N < M; we verify
it at 50 decimal digits on periodic and non-periodic paths
(residuals 10⁻⁵¹–10⁻⁵³). In action language the functional
`edge(M) + edge(N) + interior − source` is a **total differential**:
a *flat* action, with no Euler–Lagrange equation, in which **every path
is stationary**. The content is that this flatness is variational
*reason* the series-side laws are universal: a closed action cannot see
zeros, and cannot see t, at order zero.

**What it measures.** For a periodic cell `a(n) = χ(n)` (odd-prime
quadratic characters, q = 5 and 13), the tail admits the exact residue
split `tail = Σ_j χ(j) q^{−s} ζ(s, n₁(j)/q)` (Hurwitz per class). Used
as a *computation* — no asymptotic fitting — it yields at 10⁻¹⁰: the
edge law **D = −P(r)** on all 18/18 phases; the width (cell-moment)
tables `M₁(χ₅) = {2/5, 2/5, −3/5, −3/5, 2/5}` and an **all-integer**
13-phase table for χ₁₃; the t-independence of M₁; and two structural
laws measured at both moduli, **M₁(r) = M₁(−r mod q)** and
**Σ_r M₁(r) = 0**. The next rung of the ladder, at χ₅ r = 1, is the
complex drift coefficient `(3/5 + 2i/5)·(t/N)` with decay exponent
−1.0005 ± 0.001, whose real and imaginary parts carry *different*
phase-group moments — the first measured cross-phase coupling in a
truncation ladder.

**Where zeros enter.** For the ζ tail (unbounded path, the regularized
case) the measured zero-oscillatory term C satisfies
**C/|I| = ½·(t/N)** to four digits and first becomes visible at
**½·t = N** — the unit-magnification configuration of the reciprocal
lens, which we read as the moment the *zero-side interior action*
overtakes the *edge (cell) action* in the missing-tail budget. The
classic ½ of the Euler–Maclaurin half-term is the same width object
M₁ in the smooth-path slot: one ladder, two entry points.

**What gives us today (stage 2, certified).** A certified exclusion: no
off-critical-line zero pair below 10⁶ (exact N(10⁵) = 138,065 and
N(10⁶) = 1,747,142; S(10⁵) = −2.558419306, S(10⁶) = −2.508632116 at
40+ digits; the parity certificate 2K = −2 at 10⁶ and 5·10⁵), the
twin-census in (10⁵, 10⁶] (19 twins, gaps 0.0295×10⁻²–0.174×10⁻²),
a per-decade S-envelope that stays O(1) through 10⁶, and a measured
reliability model for the GPU walk that found and localized a single
dead counting chunk in ~70,000 (the 10⁷ run is in progress; the
certified bound at v0 is 10⁶).

**What it does not claim.** The Riemann hypothesis is open in this
repository: stages 3–5 are open or not-run, and stage 5 is a shape, not
a result. Nothing here is believed to be inexplicable to a seasoned
reader: every ingredient (Abel summation, Euler–Maclaurin, Hurwitz
zeta, the 1859 explicit formula, optimal truncation) is classical.
What we add is the exactness-as-computation, the measured structure at
10⁻¹⁰, the flatness reading of universality, and a zero-side program
(E5/E7 in `PLAN.md`) whose first test — a spectral decomposition of the
measured onset C over the zero list with the Riemann-1859 density
kernel — is specific enough to fail.

## Materials

- `results/zero-finder.md` — **the certified zero finder**: n →
  ρₙ = ½ + iγₙ computed (RVM bracket → certified twin-floor walk from a
  dps-certified anchor → float bisection → dps tail), with the first
  dps-certified output γ₁₃₈,₀₆₆ = 100000.74372338832472… and the honest
  precision statement (the dps floor at these heights, not the dps
  setting).
- `results/width-ladder-tables.md` — the M₁ tables (χ₅, χ₁₃, τ₁₂, F₂₄),
  the D = −P certificate, the drift coefficient, the onset ratio, the
  front/back (antipodal) structure at the first even modulus; with file
  pointers to the raw dps outputs.
- `results/certified-zero-survey.md` — N, S, 2K, twins, max|S|
  per decade, the walk-defect post-mortem; dps and engine labels on
  every figure.
- `PLAN.md` — the postulates (P-W width, P-G half, P-Z separation,
  P-A action-and-rolling layer, P-E action identity, P-0 discipline)
  with per-item status: verified / measured (precision) / conjecture,
  and the falsifier for each.
- `references.md` — everything cited, with the prior-art line drawn
  explicitly: what is classical (and whose), what is new here.
- `scripts/` — reproduction: the TypeScript stack (strict functional
  lint: no `for`/`if`, one function per file) for all
  measurement-side code, and the dps (mpmath) scripts for the
  exact-identity and high-precision verification. Dual-stack is
  policy: every measured number has a float64 twin and an
  arbitrary-precision twin that must agree.

## Authors and disclosure

- **[Owner full name]** — conception, experimental design,
  direction, interpretation. (BS- and MS-equivalent training in
  mathematics and computer science; working interest in physics and
  the history of experiments.)
- **Qwen (Alibaba Qwen team)** — co-developing instrument:
  implementation, computation, drafting, and cross-checking, running
  locally as `pi-qwen-vast` on the first author's hardware (AMD
  Strix-Halo APU, ROCm GPU; mpmath, CuPy, TypeScript, Node).
- **AI disclosure.** A large language model substantially contributed
  to the investigation, implementation, and text. All numerical
  claims in this repository are reproducible from `scripts/`; the
  model was not permitted to substitute recalled values for computed
  ones, and the discipline that caught every recall-vs-
  computation incident the instrument committed (for example:
  a hand-count of the F₂₄ cell sum returned 118; the code
  verified 108, mean 9/2 — logged and corrected).
- **Award.** No prize claim is made from this repository;
  attribution or shared credit is left to whatever committee is
  competent to decide it.
