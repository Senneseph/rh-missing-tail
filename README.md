# The Riemann Hypothesis from the Series Side

**Exact action identities for Dirichlet tails, the measured width ladders
they generate, the onset at which zero content first enters the budget —
and a separation program with explicit falsifiers.**

## The argument as constructed *<sub>state: 2026-09-13</sub>*

The argument below is a **complete
proof skeleton of the Riemann Hypothesis**. Its pieces are either
**(i) proven** (the marked pieces are machine-checked in Lean 4.33.1 +
Mathlib, a pinned stable toolchain), **(ii) classical** (taken from the
literature), or **(iii) measured** (to the stated precision; every number
here has a committed script, a precision label, and a named raw output —
§Materials). Exactly **one** piece, the *residual floor* of Part 7, is
**open**; the argument of Part 8 is stated as a proof **conditional on
that one piece**. Nothing in this repository claims that the Riemann
Hypothesis has been proved.

### 1. The hypothesis, and the counting reframe

The Riemann zeta function ζ(s), for Re(s) > 1,

    ζ(s) = ∏_p (1 − p^−s)^−1,

continues meromorphically to ℂ (single simple pole at s = 1) and satisfies
the functional equation relating s to 1 − s. Its non-trivial zeros are
those in the strip 0 < Re(s) < 1. **RH** asserts: every non-trivial zero
ρ has Re(ρ) = ½.

Two classical facts frame everything: (F1) ζ(x) > 0 for real x ∈ (0,1), so
any off-line zero is non-real; (F2) by ζ̄(s) = ζ(̄s) and the functional
equation, non-real zeros come in four-tuples {ρ, ρ̄, 1 − ρ, 1 − ρ̄} — so
every off-line zero generates **two** zeros at the same positive height.

The Riemann–von Mangoldt formula counts zeros by height. With

    N(t) = #{ non-trivial zeros ρ : 0 < Im(ρ) ≤ t },
    main(t) = x·ln x − x − 1/8,  x = t/(2π),
    S(t) = N(t) − main(t),

and N_on(t) counting only the on-line zeros and D(t) = N(t) − N_on(t)
counting the **off-line** zeros at positive height ≤ t:

> **Counting lemma (proven; machine-checked).** Under F1–F2, D is a
> non-decreasing, even-valued step function, and **RH holds if and only if
> D(t) = 0 for all t > 0.**

A failure of RH is thus a *counting event*: some positive height carries
more zeros than the critical line alone would. The remainder of this
section turns that observation into a machine.

**Unconditional certified data** (two independent numerical engines
agreeing to the last zero, with dps-certified anchors): **N(10⁷) =
21,136,121**, S(10⁷) = −3.205718 (45 decimal digits), and the parity
certificate 2K(10⁷) is even. By the counting lemma, **there is no
off-line zero pair below height 10⁷** — the strongest unconditional
statement of this repository to date (|S| stays 2.558, 2.509, 3.206 at
10⁵, 10⁶, 10⁷: an O(1) envelope, no drift).

### 2. The strategy in one paragraph

At every height t, compare **two independently defined objects**. The
**definition side** (Part 3): ζ(½ + it) computed from the Euler sum and
its integral tail — no zero input at all — reduced to a function W_n whose
size is an explicit, zero-count-free quantity. The **zero side** (Part
4): the Riemann-1859 canonical product over the **on-line** zeros,
truncated at a finite height G, plus a **rigorously bounded** error M(G, t)
for the zeros above G. Three stages then close the argument: a **bridge**
(Part 5) saying that, for the actual zero set, the two sides are *the
same object*, up to exactly the bounded tail; a **detector** (Part 6) —
an *exact algebraic theorem* — saying that an off-line pair, at its own
height, changes the kernel by at least f(δ, t₀)·|K|, with f explicit and
**bounded below independently of the off-line distance δ**; and a **floor**
(Part 7, the open piece) bounding the definition side *below* the detector
scale, with no zero-count input. Part 8 combines them.

### 3. The definition side: the missing tail

For n ∈ ℕ and s = ½ + it, write the Euler sum to n, the first-term integral
approximation of the rest, and their residual

    P_n(s) = Σ_{k=1}^n k^−s,      I(n, s) = n^{1−s}/(1 − s),
    W_n(t) = ζ(½ + it) − P_n(½ + it) − I(n, ½ + it).

W_n is the "missing tail": what remains of ζ after stripping the first n
terms and their first-term integral. All of this is computable from the
definition alone (Riemann–Siegel at height t; no zero list, no RH).

> **The missing-tail law.** The zeros enter at *second* order in
> ζ − P_n. In the onset window t/n ≈ 2 the measured law is
>
>     |W_n(t)| / |I(n, ½ + it)| = ½·(t/n) + O(corrections),
>
> to **four digits, independent of n** across n ∈ {10³, 10⁴, 10⁵}; the
> explicit error disks of the Euler–Maclaurin remainder contain all 15
> measured points on both of two independent computation stacks. The
> corrections are the Euler–Maclaurin remainder of Σ_{k>n} k^−s − I(n, s).
> **Strictification (in progress).** The Euler–Maclaurin machinery
> underneath is machine-checked: the first-order identity at integer
> endpoints, and the finite second-order law (the finite core of the
> Riemann 1859 identity), for every C² real-valued f on [n, m],
>
>     Σ_{k=n}^{m−1} f(k) = ∫_n^m f + ½(f(m) − f(n))
>                        + (1/12)(f′(m) − f′(n)) − ½∫_n^m B̂₂(x) f″(x) dx,
>
> with B̂₂ the periodized second Bernoulli polynomial — stated and
> verified in an abstract real-closed normed field (in particular ℝ).
> The passage to the limit M → ∞ with an explicit remainder at s = ½ is
> the remaining formal content of this part.

W_n is the quantity from which the floor of Part 7 must be built: known
without zeros. The action-principle reading of this identity — and the
width-ladder structure it explains — is documented in
`docs/THE-EULER-ACTION.md`.

### 4. The zero side: the kernel and its rigorous tail

**The canonical product.** In the convergent 1859 form (DLMF 25.2.12),
truncated at height G over the on-line zeros:

    K(s; G) = Main(s) · ∏_{ρ∈on-line, 0<Im ρ≤G} (1 − s/ρ) e^{s/ρ} · e^{T(G,s)},

where Main is the explicit main factor and T(G, s) is the tail term for
the zeros above G. Each on-line pair {½ + iγ, ½ − iγ} contributes a
**closed form** (exact; machine-checked; agreement with direct
high-precision evaluation ≤ 3.5×10⁻¹⁴ in magnitude, ≤ 3.2×10⁻¹⁶ rad in
argument):

    la_pair(γ, t) = ½/(¼ + γ²) + ln|1 − (¼ + t²)/(¼ + γ²)|,
    ar_pair(γ, t) = t/(¼ + γ²) − π·[γ < t].

The kernel is therefore a float64-vectorizable sum over the certified
zero list (12,193,869 zeros up to G = 6×10⁶, each certified to 30 digits;
16/16 float cross-checks against the high-precision record).

**The tail, bounded unconditionally.** Writing the tail as an integral
plus an error, |E(G, t)| ≤ M(G, t) with

    M(G, t) = S̄(G)·B_f(G,t) + C_f(G,t)·K_f(G,t),

given by the Platt–Trudgian explicit S-bound (J. Number Theory 147 (2015)
842–851, Cor. 1), |S(T)| ≤ 0.110 ln T + 0.290 ln ln T + 2.290 (T ≥ e).
At the certified scale G = 6×10⁶: M(6×10⁶, 10³) = 1.3×10⁻⁷, growing to
5.3×10⁻³ at t = 2×10⁵ (it reproduces the log|γ − t| singularity at
the truncation edge). The Abel mechanism behind the formula was verified
on **7.4 million real certified zeros** to the quadrature limit. A finite
certified list plus M(G, t) therefore stands in for the infinite zero
set with a rigorously bounded error — no infinite computation, no RH
input. (Caveat, carried honestly: M bounds the *on-line* tail; the
off-line zeros above G are a separate, recorded quantity — they are the
signal the Part 6 detector measures, not a defect of the kernel.)

### 5. The bridge: ζ is its own kernel

For a finite zero list L, write the bridge map Ψ_L(t) = e^{T(t)}·
∏_{γ∈L} F(γ, t) (tail model times pair kernel) and the truncated kernel
K_L(t) = ∏_{γ∈L∪{tail}} F(γ, t). Then **K_L and Ψ_L differ by exactly
the single factor exp(T(t) − Σ_T ln F)** — the one number measuring how
well the tail model T approximates the logarithm of the true tail
product (machine-checked, ζ-free finite core). There is no hidden
remainder: the bridge's error *is* the tail error, term by term.

The finite bridge is an **exact Abel decomposition** (machine-checked):
the counting step N_L(x) = #{γ ∈ L : γ ≤ t} is folded into the exact
integral identity

    ∫_a^b N_L(x) f′(x) dx = Σ_{γ∈L, a≤γ≤b} f(γ),

and, through a smooth comparator N̂ interpolating the counting step, the
integration-by-parts bridge

    ∫_a^b N̂ f′ = N̂(b) f(b) − N̂(a) f(a) − ∫_a^b N̂′ f

moves all differentiation to the smooth, explicit, bounded comparator.
The discrete zero set and the continuous Riemann–von Mangoldt main term
are related by *exact* calculus, not approximation — so "definition side"
and "zero side" in Parts 6–8 are **one object written two ways**, whose
only disagreement is the rigorously bounded tail M(G, t) of Part 4.

### 6. The detector: what an off-line pair does to the kernel

Fix a height γ and move the on-line pair {½ ± iγ} off the line by δ > 0
into the four-tuple {½ ± δ ± iγ}. With P_on the on-line pair's canonical
factors and P_off the off-line four-tuple's, the rest of the product is
unchanged and cancels in the ratio **R(s, δ) = P_off(s)/P_on(s)** — a
two-factor algebraic object with no normalization ambiguity and no
approximation. Its **exact closed form** (s = ½ + it; proven;
machine-checked; verified to six digits against the direct four-zero
definition and the measured data):

    R(s, δ) = (¼ + γ²)·((γ − t)² + δ²)·((γ + t)² + δ²)
              ────────────────────────────────────────────── · e^{s·ω_δ}
              (γ² − t²)·((½ + δ)² + γ²)·((½ − δ)² + γ²),

    ω_δ = (1 + 2δ)/((½ + δ)² + γ²) + (1 − 2δ)/((½ − δ)² + γ²) − 1/(¼ + γ²) ∈ ℝ.

A real signed prefactor times a pure constant-rate phase; the only branch
is the sign flip at t = γ. **The magnitude, in its three regimes** (all
exact):

- **Near the pair** (|t − γ| ≤ 10): |R − 1| = 0.9975–1.0201 across the
  full grid δ ∈ [0.005, 0.5] (56/56 points, formula vs direct dps and
  measured data to 5×10⁻⁴). An off-line pair at its own height forces a
  kernel change of **at least 99.75% of the kernel's own size**.
- **At twice the height** (t = 2γ): |R − 1| = 4.0000 *exactly*, all δ.
- **Far from the pair** (t = cγ, c > 1): |R − 1| = (c² − 1) to six digits
  (c = 10, 50, 100 give 99.99998, 2.499999×10³, 9.999998×10³) —
  **(t/γ)² − 1, δ-flat to O(10⁻⁶)**. The detector margin grows
  quadratically with the height ratio.

**No dead δ-window.** The magnitude numerator
((t−γ)² + δ²)((t+γ)² + δ²) = (t² − γ²)² + 2δ²(t² + γ²) + δ⁴ is a
polynomial in δ with all coefficients positive: **no δ > 0 annihilates
it.** The detector is robust for *every* off-line distance.

And the fingerprint is one-sided: when a pair goes off-line, the count N
steps up by 2 at height γ, but the *argument* of ζ along the line does
**not** wind (the off-line pair factor has a real-negative numerator and
net phase 0 across the straddle window, where the on-line pair winds by
−π). The count sees the ghost; the argument does not — which is precisely
why the S/2K certificate of Part 1 detects off-line pairs as *size* jumps
at all.

### 7. The open piece: the residual floor

> **The required theorem.** For all t > 0,
>
>     | W_n(t) − [ K_on(t) − (P_n(½+it) − I(n, ½+it)) ] | < min_δ f(δ, t),
>
> proved **from the definition side alone** — no zero count at any height
> enters the proof. The right-hand side is the detector scale of Part 6
> (≥ 0.998·|K| near the pair; ~ (t/γ)²·|K| far), with f(δ, t) = |R − 1|.

Two routes are named. **Route A (residual floor)** builds it from the
strictified missing-tail law of Part 3 (its Euler–Maclaurin remainder) plus
the tail bound M(G, t) of Part 4; it works for δ above a sensitivity
threshold to be pinned by measurement, and the measured margin — dps-30-
certified verified-regime closing **143.341847457×** (t = 5004.7343,
corrected discrete tail, 1e12 remainder; **145.563762319** with the 1e15
remainder — DISCOVERY_LOG 25c/25d) — plus the verified region [10³, 10⁶]
(margin ≥ 13.9, certified) extended on real zeros to 3.15×10⁷ (margin ≥
1.4, screened — DISCOVERY_LOG 25f) with the 1×10⁷ zero list DONE (25b:
independent 100-h walk, N(10⁷) = 21,136,121 = LMFDB − 4 documented twins)
says it is within reach, and the old "erosion" numbers (34.68, the
122 → 2.3 trend, the 1.053 at 5×10⁴) are RETIRED — day-023 found and
fixed a kernel tail-integration defect that had masked them (25b). **Route B (uniform dynamics)**
proves 2K(t) even for all t directly — equivalently, S stays in the
on-line band — with no sensitivity threshold; at full strength it is
essentially RH-equivalent, the classical S(t) lifting being the open
engineering question. The measured data arbitrate: if the Route-A margin
collapses, Route A is retired and Route B carries the argument. Either way,
Part 7 is the single remaining gap — *stated, bounded below, with two
named routes*.

### 8. The closure *(conditional on Part 7)*

**Assume RH fails.** By the counting lemma D(t) > 0 somewhere; the
positive zero heights are discrete (Riemann–von Mangoldt: finitely many up
to any T; the smallest zero height is a certified classical number, ≈
14.13). Take the off-line pair of **minimal** positive height t₀, at
distance δ₀ > 0 from the line. (1) By the bridge (Part 5), the
definition–zero gap at t₀ is the tail-bounded difference of the two
sides, and by the detector (Part 6) it is **≥ f(δ₀, t₀)·|K(t₀)|** with
f(δ₀, t₀) = |R − 1| ≥ 0.9975 (day-010 straddle pin, C1's t ≠ g window),
the tail M(G, t₀) being far below that scale.
(2) By the floor (Part 7), the same quantity is **< f(δ₀, t₀)·|K(t₀)|**,
from the definition side alone. (3) Contradiction. Hence D(t₀) = 0; by
minimality, D ≡ 0; by the counting lemma, **RH**. ∎ — *conditional on
Part 7.*

### Status of each piece (2026-09-14, day-023 25f)

- **Proven, machine-checked (Lean 4.33.1 + Mathlib, pinned stable):** the
  counting lemma (Part 1); the per-pair closed forms (Part 4); the detector
  closed form and its magnitude, including the no-dead-window polynomial
  (Part 6); the bridge's ζ-free finite core, the exact finite Abel
  decomposition, and the explicit tail bound at finite height (Part 5);
  the first-order and finite second-order Euler–Maclaurin laws, and the
  M → ∞ passage with the T4 bound of the strictified missing-tail law
  (Part 3, `formal/RhAttack/P4Limit.lean` L1–L5); the residual-floor line
  A0–A4 (Part 7, `formal/RhAttack/P8Floor.lean`); the conditional closure
  module with its audit records machine-verified against the re-pinned
  closing (Part 8, `formal/RhAttack/Closure.lean` — C0/C5/C5b/C1a/C6/C7,
  pin **143.341847457**, day-023 re-pin; 33.9864/34.68 RETIRED — old
  kernel tail, DISCOVERY_LOG 25b/25c); **the P1.2 uniform statement
  (S1–S4 decomposition, `formal/RhAttack/P12Uniform.lean`, GREEN — the
  formal name of the single open gap, day-023 25e).
- **Classical (literature):** F1–F2; Riemann–von Mangoldt; the 1859 product
  (DLMF 25.2.12); Platt–Trudgian's explicit S-bound.
- **Measured (precision labeled, scripts committed):** the missing-tail
  onset law, 4 digits, n-independent (Part 3); the detector regime values
  vs the four-zero definition and the data, 6 digits (Part 6); the
  certified zero survey to 10⁷ and the zero list to 6×10⁶ (Parts 1, 4);
  the Abel mechanism on 7.4M real certified zeros (Part 4); the closure
  audit package (cross-band straddle audits; dps-30 CERTIFIED closing
  143.341847457 (1e12 tail) / 145.563762319 (1e15 tail) @ t = 5004.7343
  and anchor 140.202502242 / 140.286237277 @ 10³; verified region
  [10³, 10⁶] + screened [10⁶, 3.15×10⁷] margin ≥ 1.4 — DISCOVERY_LOG
  25c/25f; all earlier "erosion" readings (34.68, 122 → 2.3, 1.053)
  RETIRED — day-023 25b found the true cause: the (B,∞) tail
  QUADRATURE (not the model) under-integrated the near mass; the
  day-020/21 "tail-model error" explanation is itself superseded by 25b).
- **In progress:** the residual-floor theorem itself (Part 7, Routes A/B)
  — the P4/P8/P9/P12 formal machinery beneath it is complete; the 1×10⁷
  zero list is DONE (day-023 25b: independent 100-h walk, N(10⁷) =
  21,136,121 = LMFDB − 4 documented twins) and the verified regime is
  [10³, 10⁶] certified + [10⁶, 3.15×10⁷] screened (25f).
- **Open:** the residual floor (Part 7) — the single remaining gap.

*The complete reader-facing exposition of this argument — with full
provenance for every number — is maintained as
`docs/RH-PROOF-OUTLINE.md` (table of contents: `docs/INDEX.md`); the
machine-checked pieces live in `formal/` (§Materials).*

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
| **2 — Counterexample search** | H2: if RH fails below T, the certified walk finds it (off-line pair ⇒ 2K jump; S growth beyond O(1)) | GPU walk dt = 5×10⁻⁴ + dt/2 stability endpoints + dps-40 2K/S certificate | **10⁶ and 10⁷ certified: no off-line zero pair below 10⁷** (day-014 closeout: N(10⁷) = 21,136,121, S = −3.205718 dps-45, 2K even — the early +246 estimate was falsified by the two-engine direct count; `docs/certified-zero-survey.md`) |
| **3 — Zero-side identification** | H3: the measured onset C *is* the zero-side explicit-formula budget (the Riemann-1859 zero product, not just the nearest zero) | E7b: predict the 4-digit onset law from the zero product over the certified list + analytic tail; E5: the zero-sum in missing-tail language | **Stage 1 complete (2026-09-09):** zero-side product kernel reproduces the 4-digit onset points — N=10³, t/N=1: +0.29%; N=10⁴, t/N=0.1: −1.2% (two borderline +4/+6%); the rest lie below the quantified zero-side error floor (density tail saturates once G ≫ t). The N=10⁵ row needs G ≳ 5–6×10⁶ — deferred, on demand |
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
dead counting chunk in ~70,000 (the 10⁷ closeout landed on day-014:
N(10⁷) = 21,136,121, S(10⁷) = −3.205718 at dps-45, 2K even).

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

- [docs/zero-finder.md](docs/zero-finder.md) — **the certified zero finder**: n →
  ρₙ = ½ + iγₙ computed (RVM bracket → certified twin-floor walk from a
  dps-certified anchor → float bisection → dps tail), with the first
  dps-certified output γ₁₃₈,₀₆₆ = 100000.74372338832472… and the honest
  precision statement (the dps floor at these heights, not the dps
  setting).
- [docs/width-ladder-tables.md](docs/width-ladder-tables.md) — the M₁ tables (χ₅, χ₁₃, τ₁₂, F₂₄),
  the D = −P certificate, the drift coefficient, the onset ratio, the
  front/back (antipodal) structure at the first even modulus; with file
  pointers to the raw dps outputs.
- [docs/certified-zero-survey.md](docs/certified-zero-survey.md) — N, S, 2K, twins, max|S|
  per decade, the walk-defect post-mortem; dps and engine labels on
  every figure.
- [docs/e7b1-detector-b5-core.md](docs/e7b1-detector-b5-core.md) — the
  exact off-line pair kernel deviation (the E7b *detector* half of the
  zero-side bridge): an EXACT formula for the 25.2.12 zero-product kernel
  (identity verified at dps-30) + a 6-digit measurement in the certified
  G = 3×10⁵ context.
- [PLAN.md](PLAN.md) — the postulates (P-W width, P-G half, P-Z separation,
  P-A action-and-rolling layer, P-E action identity, P-0 discipline)
  with per-item status: verified / measured (precision) / conjecture,
  and the falsifier for each.
- [DISCOVERY_LOG.md](DISCOVERY_LOG.md) — **the chronicle**: the approach and the pieces
  as found (in order), how they combine, and the important
  contradictions (recorded and resolved or standing). Living document;
  entries are appended when the evidence files land. Does not track
  setbacks.
- [PUBLICUM.md](PUBLICUM.md) — **the public digest**: what the work is and why it
  may work, in plain words for science-magazine / news readers; no
  fancy mathematics; states what is measured vs open; carries the
  credit and AI-disclosure lines.
- [A_SPECTRAL_SOLUTION.md](A_SPECTRAL_SOLUTION.md) — the program set to
  music: the song "A Spectral Solution" (J. S. Miller & ChatGPT), with
  the link to the Suno track. Art accompanying the work, not a claim.
- [references.md](references.md) — references and the prior-art line;
  items marked **[pin]** are used in the working notes but their full
  bibliographic data must be checked against the primary source before
  any submission.
- [docs/INDEX.md](docs/INDEX.md) — the documents in `docs/`: the
  reader-facing proof exposition, the proof scaffold, the Euler action
  identity document, the four measured-record documents (zero finder,
  width ladders, certified zero survey, E7b detector record), and the
  provenance of the machine-checked core. The single entry point for
  `docs/`.
- [formal/README.md](formal/README.md) — the Lean
  package README: the stable toolchain pin (Lean 4.33.1 + Mathlib),
  the one-command verify recipe, and the layout of the `RhAttack`
  modules.
- [formal/RH-LEAN-PROVENANCE.md](formal/RH-LEAN-PROVENANCE.md) — home,
  source of record, and sync rule for `formal/`.
- `formal/` — **the machine-checked core** (home and source of
  record — provenance in
  [formal/RH-LEAN-PROVENANCE.md](formal/RH-LEAN-PROVENANCE.md)): the E7a identity
  proven in Lean 4.33.1 + Mathlib over any commutative ring, the B-4
  on-line pair identity proven in four pieces (exact closed form T1;
  log-magnitude T2; phase exactly mod 2π, T3a/T3b), plus the 5/5 E7a
  oracle cross-check and the 16/16 B-4 point cross-check (run +
  recorded output in the tree). One-command verifiable:
  `lake build && lake exe rhattack`.
- **The Lean proof files (direct links)** — the machine-checked
  pieces, one per file (`formal/`, Lean 4.33.1 + Mathlib; the
  `rhattack` executable re-runs all runtime cross-checks):
  - [Main.lean](formal/Main.lean) — the `rhattack` gate
    executable (E7a / B-4 / B-5 / B-3 runtime cross-checks)
  - [RhAttack.lean](formal/RhAttack.lean) — the root module
    (imports every piece below, with the day-attributed history)
  - [RhAttack/E7a.lean](formal/RhAttack/E7a.lean) — the five
    certified E7a oracle instances (ported, cross-checked)
  - [RhAttack/EulerAction.lean](formal/RhAttack/EulerAction.lean) — the E7a
    Euler action identity (the exact finite-sum identity)
  - [RhAttack/B0.lean](formal/RhAttack/B0.lean) — the counting
    equivalence of the outline (RH ⟺ D ≡ 0 over an abstract zero set)
  - [RhAttack/B3.lean](formal/RhAttack/B3.lean) — the B-3
    bridge: finite exact Abel decomposition, the RVM-comparator bridge,
    the explicit finite bound, the ζ-free residual decomposition
    (pieces: B3Core / B3Abel / B3Sbar)
  - [RhAttack/B4.lean](formal/RhAttack/B4.lean) — the B-4
    on-line per-pair closed form (T1/T2/T3a/T3b)
  - [RhAttack/B5.lean](formal/RhAttack/B5.lean) — the B-5 core:
    the exact off-line/on-line ratio theorem
  - [RhAttack/P4Em.lean](formal/RhAttack/P4Em.lean) — the P4
    1st-order Euler–Maclaurin formula (verbatim port of a published
    Lean proof, Apache 2.0)
  - [RhAttack/P4Tail.lean](formal/RhAttack/P4Tail.lean) — the P4
    2nd-order *per-period* identity (`int_B1f'_period`)
  - [RhAttack/P4Em2.lean](formal/RhAttack/P4Em2.lean) — the P4
    *global finite* 2nd-order Euler–Maclaurin law (`em2_finite`)
  - [RhAttack/P4Limit.lean](formal/RhAttack/P4Limit.lean) — the P4
    *strictification* L1–L5: the M → ∞ passage with explicit remainder,
    the P4 identity and the ‖W_n‖ bound at Re s = ½, the T4 corollary
  - [RhAttack/P8Floor.lean](formal/RhAttack/P8Floor.lean) — the P8
    *residual-floor line* A0–A4: the same-object definition-side floor,
    the bridge-wired residual (the M(G,t) wire), the B5 closed-form
    detector atoms, the zero-decision inequality
  - [RhAttack/Closure.lean](formal/RhAttack/Closure.lean) — the P9
    *conditional closure*: C0/C5/C5b/C1a/C6/C7 + the audit pins (pin
    **143.341847457**, day-023 re-pin, dps-30 certified; 33.9864 RETIRED,
    25b/25c) — the machine core of the §8 contradiction argument
  - [RhAttack/P12Uniform.lean](formal/RhAttack/P12Uniform.lean) — the P1.2
    *uniform statement*: the S1–S4 decomposition (zero side / detector
    floor / definition side / the uniform squeeze) + `squeeze_gives_margin`
    + `p1_2` — the formal name of the single open gap (day-023 25e)
- **Master formula ledger (working tree):** `plan/40-prize-islands/
  rh-attack/FORMULAS.md` — every formula this work uses, labeled
  (verbatim-read / measured + file + precision / derived + file /
  classical + source / read-pending) and indexed to its home file.
  Disciplinary rule enforced there: a formula is read from its primary
  source *before* first use — no training-memory recall for zero-side
  or engine formulas.
- **Reproducer scripts (working tree):** the code has one home — the
  private working tree (`kainos-logos/scripts/`, sibling of this
  repository; a local checkout carries it here as the `scripts/`
  symlink: `rh/` the measurement + dps (mpmath) scripts and their raw
  outputs, `rh-ts/` the TypeScript zero-finder stack — strict functional
  lint: no `for`/`if`, one function per file). This repo deliberately
  carries only the measured record, the plan, the references, and the
  machine-checked core (`formal/`, home and source of record — see its
  [provenance file](formal/RH-LEAN-PROVENANCE.md)) — so no number in `docs/` exists without a named script and
  a named raw output file. The census file `rh/zeros_T100000.txt` (138,065 dps-
  certified zeros to t = 10⁵) lives there too. All paths cited in
  `docs/` resolve from the working-tree root.

## Authors and disclosure

- **Jesse S. Miller** — conception, experimental design,
  direction, interpretation. (BS - Mathematics and Computer Science, Emory University; working interest in the histories of the Natural Sciences.)  
  **L. McGeorge** [-](https://suno.com/song/033eff6c-a93d-49f4-b9d7-a4553ac12b6e) Creative Partner
-  **hagr** - Spiritual Support
- **Qwen (my quant, my trusty Clanker)** — @ Alibaba Qwen team for co-developing instrument:
  implementation, computation, drafting, and cross-checking, running locally as `pi-qwen-vast` (Pi Agent Harness, Vast.ai rental) on the first author's hardware.
- **AI disclosure.** A large language model substantially contributed
  to the investigation, implementation, and text. All numerical
  claims in this repository are reproducible from the working tree
  (§Materials); the
  model was not permitted to substitute recalled values for computed
  ones, and the discipline that caught every recall-vs-
  computation incident the instrument committed (for example:
  a hand-count of the F₂₄ cell sum returned 118; the code
  verified 108, mean 9/2 — logged and corrected).
- **Award.** No prize claim is made from this repository;
  attribution or shared credit is left to whatever committee is
  competent to decide it.
- **RH Authorship.** Eternal Copyright - Life, The Universe, and Everything @ The Supreme Being. Local, most-recent Earth derivation: &copy; Jesse S. Miller
- **Divine Providence Guiding My Hand.** Felt.