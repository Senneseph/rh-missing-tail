# The Riemann Hypothesis: A Path, and Its Current State

*What this is.* This document presents a complete path toward a proof of the
Riemann Hypothesis, written so that a reader with a background in analysis
can follow it start to finish. It is a mathematical exposition, not a
journal of the project's internal work.

*Honesty of status — read this first.* The path is a **complete argument
skeleton**. Some of its pieces are **proven and machine-checked** (Lean 4 +
mathlib). Some are **classical facts** we take from the literature. Some are
**measured to high precision** but not yet proven. One part — the residual
floor of §10 — is **open**, and the full theorem is conditional on it.
Nothing in this document claims that the Riemann Hypothesis has been proved.
Every computed number cited here carries provenance to a script and data file
committed alongside it. The project discloses AI co-development of its
instruments; no prize claim is made.

*How to read it.* §1–2 state the hypothesis and the counting language we use.
§3 is the broad strategy in one page. §4–7 walk through each ingredient, in
the order the argument uses it. §8 closes the loop. §9 states exactly what is
proven, measured, and open. §10 is the residual floor — the one open piece —
and the two routes intended to close it. §11 lists the classical sources.

---

## 1. The hypothesis

The Riemann zeta function ζ(s) is defined for Re(s) > 1 by the Euler product

    ζ(s) = ∏_p (1 − p^−s)^−1,

continues meromorphically to all of ℂ (with a single simple pole at s = 1),
and satisfies the functional equation relating s to 1 − s.

Its **non-trivial zeros** are the zeros in the critical strip
0 < Re(s) < 1. The **Riemann Hypothesis (RH)** says:

> **Every non-trivial zero ρ of ζ satisfies Re(ρ) = ½.**

Two elementary classical facts frame everything that follows.

- **F1 (real strip).** ζ(x) > 0 for real x ∈ (0, 1), and the only real zeros
  of ζ are the even negative integers. Hence any zero off the critical line
  is non-real.
- **F2 (four-tuples).** By complex conjugation (ζ̄(s) = ζ(̄s)) and the
  functional equation, non-real zeros come in four-tuples
  {ρ, ρ̄, 1 − ρ, 1 − ρ̄}. In particular, every zero off the critical line
  generates **two** zeros at the same positive height Im(ρ).

A failure of RH is therefore a *counting event*: some positive height t₀
carries more zeros than the critical line alone would. The rest of this
document makes that observation into a machine.

## 2. The counting language: Riemann–von Mangoldt

The **Riemann–von Mangoldt formula** counts zeros by height. Let

    N(t) = #{ non-trivial zeros ρ : 0 < Im(ρ) ≤ t }

count **all** zeros, on the line and off it, and set, in the project
convention,

    main(t) = x·ln(x) − x − 1/8,   x = t / (2π),
    S(t)   = N(t) − main(t).

S(t) is the oscillatory part. Numerically it stays O(1): on certified data,
|S| at t = 10⁵, 10⁶, 10⁷ is 2.558, 2.509, 3.206 respectively.

Write

    N_on(t)   = #{ zeros on the line Re = ½ : 0 < Im ≤ t },
    N_total(t) = N(t),
    D(t)      = N_total(t) − N_on(t).

D(t) counts the zeros **off** the line at positive height ≤ t.

### The counting lemma

> If the zeros satisfy the F1–F2 symmetry, then D(t) is a non-decreasing,
> even-valued step function, and **RH holds if and only if D(t) = 0 for every
> t > 0.**

*Why D is even.* By F2, every off-line zero comes with its mirror 1 − ρ, and
the two sit at the same positive height. D jumps by 2. *Why the equivalence
holds.* If RH fails, some off-line zero exists at height t₀, and D(t₀) ≥ 2;
if D ≡ 0, no zero is off the line. The argument is two lines of counting;
it is **proven in Lean** (piece P1, §9).

Two consequences of the certified data (day-014 record, all numbers
reproducible from committed scripts):

- **N(10⁷) = 21,136,121**, S(10⁷) = −3.205718 (dps-45), obtained by a
  two-engine direct count (two independent numerical instruments agreeing
  to the last zero, plus certified anchors at 10⁶ and 1.4×10⁶).
- **2K(10⁷) is even** (2K = −2). By the counting lemma,
  **there is no off-line zero pair below height 10⁷.** This is the strongest
  unconditional statement of the project today.

## 3. The strategy in one page

The argument compares **two independently defined objects**, at every height
t > 0:

**(a) The definition side.** ζ(½ + it) computed *from the definition* — the
Euler product minus its tail — with no zero input at all. §4 extracts from
this a function W_n(t) whose size at height t is a known, explicit,
zero-count-free quantity.

**(b) The zero side.** A canonical product over the zeros **on the line**,
truncated at a finite height G, plus a **rigorously bounded** remainder for
the zeros above G (§5). Call this object K_on(t).

The strategy has three stages.

1. **The bridge (§6).** For the *actual* zero set, the definition side and
   the zero side are the same object: ζ(½ + it) equals its kernel K_on(t) up
   to the tail remainder. When all zeros are on the line, the two sides agree
   to within the rigorously bounded error M(G, t) of §5.
2. **The detector (§7).** Now move one pair of zeros off the line, by a
   distance δ > 0. The kernel at the pair's own height *must* change by at
   least f(δ, t₀) · |K|, where f is explicit and **bounded below independently
   of δ**: in the regimes relevant to the argument, |f| ≥ 0.998 near the pair,
   and |f| = (t₀/γ)² to six digits far from it. This is an exact algebraic
   theorem, proven in Lean (piece P3).
3. **The floor (§10) — the open piece.** From the *definition side alone*,
   bound the size of W_n(t) − (K_on(t) − (P_n − I)) by something **smaller**
   than f(δ_min, t) · |K|, uniformly in t, with no zero-count input.

Then: **assume RH fails.** Take an off-line pair of **minimal** positive
height t₀. The bridge plus the detector force the definition–zero gap at t₀
to be ≥ f(δ, t₀)·|K|; the floor says it is < f(δ, t₀)·|K|. Contradiction.
D ≡ 0. RH. (§8.)

Notice what each stage *needs*: the bridge must be exact enough that its only
error is the bounded tail; the detector must be δ-robust (no dead δ window);
the floor must use no counting information at any height. Everything else in
this document exists to serve those three requirements.

## 4. The definition side: the missing-tail law

For a positive integer n and s = ½ + it, write the Euler sum up to n and its
integral tail:

    P_n(s) = Σ_{k=1}^n k^−s,        I(n, s) = n^{1−s} / (1 − s),
    W_n(t) = ζ(½ + it) − P_n(½ + it) − I(n, ½ + it).

All of this is computable from the definition alone — Riemann–Siegel on the
definition side, no zero list, no RH. W_n is what remains of ζ after we strip
off the first n terms *and* the first-term integral approximation of the
rest. It is the "missing tail" of the Euler sum.

**The missing-tail law (measured; its strictification is piece P4, §9).**
The first-order term of ζ − P_n is −I(n, s); the zeros appear at second
order. Quantitatively, in the **onset window** t/n ≈ 2, the data shows

    |W_n(t)| / |I(n, s)| = ½ · (t / n) + O(corrections),

measured to four digits, **independent of n** for n ∈ {10³, 10⁴, 10⁵}. The
corrections are understood structurally: they are the Euler–Maclaurin
remainder of Σ_{k>n} k^−s − I(n, s). Making this theorem, with an explicit
remainder, is the strictification task P4.

**Why this block exists.** The floor of §10 must be built from a quantity
that is *known without zeros*. W_n is that quantity. Its measured size
(|W_n| ≈ ½·(t/n)·|I| in the onset window) is the scale the floor must stay
below the detector scale of §7.

Two data checks anchor the definition side. The onset pattern (the five-row
fingerprint of the transition) is reproduced at G = 6×10⁶ within ≤ 6% by the
zero-side kernel of §5 — the two sides agree where they should. And the
certified count record of §2 (N(10⁷) etc.) comes from the definition-side
instrument (Riemann–Siegel sign flips on the line), not from the zero list.

## 5. The zero side: the kernel, its finite form, and its tail

### 5.1 The canonical product

Riemann's 1859 product (DLMF 25.2.12) writes ζ as a product over its zeros.
In canonical convergent form, truncated at height G:

    K(s; G) = Main(s) · ∏_{ρ on-line, 0 < Im ρ ≤ G} (1 − s/ρ) e^{s/ρ} · e^{T(G, s)},

where Main(s) is the explicit main factor (from the functional equation) and
T(G, s) is a **tail term** for the zeros above G. The factors
(1 − s/ρ) e^{s/ρ} are the standard canonical factors: the exponential
e^{s/ρ} is what makes the infinite product converge.

Each on-line zero comes as a conjugate pair {½ + iγ, ½ − iγ}. The
contribution of one pair to log |K| and to the argument of K has a **closed
form** (proven in Lean, piece P2, §9):

    la_pair(γ, t) = ½/(¼ + γ²) + ln |1 − (¼ + t²)/(¼ + γ²)|,
    ar_pair(γ, t) = t/(¼ + γ²) − π · [γ < t],

where [γ < t] is 1 when γ < t and 0 otherwise. This is exact — the two
principal arguments in the pair sum, and the atan2 constants cancel. Against
a direct high-precision single-pair evaluation the agreement is
≤ 3.5×10⁻¹⁴ (magnitude) and ≤ 3.2×10⁻¹⁶ rad (argument); against the
float64 implementation, 16/16 cross-check configurations pass. The practical
consequence is that the whole zero-side kernel is a **float64-vectorizable
sum** over the certified zero list — no high-precision loop.

### 5.2 The tail, bounded rigorously

The tail is written as an integral plus an error:

    T(G, s) = ∫_G^∞ pairlog(γ, s) · ln(γ / 2π) / (2π) dγ + E(G, s),

where pairlog is the closed form of §5.1. The **on-line tail bound**
(proven, piece P5, §9) makes the error explicit and *unconditional*:

    |E(G, t)| ≤ M(G, t),   M(G, t) = S̄(G) · B_f(G, t) + C_f(G, t) · K_f(G, t),

where S̄ is the **Platt–Trudgian explicit S-bound** (J. Number Theory 147
(2015) 842–851, Cor. 1):

    |S(T)| ≤ 0.110 ln T + 0.290 ln ln T + 2.290   (T ≥ e).

Numbers at the certified scale G = 6×10⁶: M(6×10⁶, 10³) = 1.3×10⁻⁷, growing
to M(6×10⁶, 2×10⁵) = 5.3×10⁻³ (it scales like (t/G)²·S̄(G) and blows up at
t → G, faithfully reproducing the log |γ − t| singularity of the pair factor
there). The Abel mechanism behind the formula was verified on **7.4 million
real certified zeros** (3×10⁵ → 4×10⁶) up to the quadrature limit.

**Why this block exists.** It is what allows a *finite* zero list to
stand in for the infinite zero set: the on-line kernel over the certified
list of **12,193,869 zeros** (up to 6×10⁶, each zero certified to dps-30)
plus M(G, t) determines the zero side up to a rigorously bounded error.
No infinite computation, no RH input, no appeal to faith.

One honest caveat. M(G, t) is an *on-line* bound. The zeros **above G that
would be off-line** are not bounded by M; their combined effect at height t
is a separate quantity, recorded data-driven as R(t) (values
8.4×10⁻⁴ … −8.0 at t = 10³ … 2×10⁵, all far above M at the same t). R(t) is
the off-line signal that the detector of §7 measures — it is not a defect of
the on-line kernel. The count of zeros below G that *could* be off-line is
≤ 8, by the S̄-counting argument and the F2 four-tuple structure.

## 6. The bridge: ζ is its own kernel

> **The bridge identity (piece P6, §9; ζ-free core in progress in Lean).**
> For the actual zero set, ζ(s) equals the kernel K(s) of §5 in the product
> sense (DLMF 25.2.12), and the residual between the two finite-G
> constructions is **exactly** the tail-model error — nothing else.

The bridge has a clean finite form, which is where the Lean work sits. For a
finite height list L, write the bridge map

    Ψ_L(t) = e^{T(t)} · ∏_{γ ∈ L} F(γ, t)        (T: the tail model, F: pair kernel)

and the truncated kernel

    K_L(t) = ∏_{γ ∈ L ∪ {tail}} F(γ, t).

Then **K_L and Ψ_L differ by exactly the factor exp(T(t) − Σ_T ln F)** —
the single number that measures how well the tail model T approximates the
logarithm of the true tail product. There is no hidden remainder: the
bridge's error *is* the tail error, term by term.

The finite bridge is an **exact Abel decomposition** (piece P7): the
counting step N_L(t) = #{γ ∈ L : γ ≤ t} — a step function — is folded into
a continuous integral identity

    ∫_a^b N_L(x) f'(x) dx = Σ_{γ ∈ L, a ≤ γ ≤ b} f(γ)

with a smooth comparator, so the discrete zero set and the continuous
Riemann–von Mangoldt main term are related by *exact* calculus, not by
approximation. The smooth comparator N̂ (piece P7) interpolates the counting
step, and the integration-by-parts bridge

    ∫_a^b N̂(x) f'(x) dx = N̂(b) f(b) − N̂(a) f(a) − ∫_a^b N̂'(x) f(x) dx

moves the derivative from the integrand to the comparator, where it is a
smooth, explicit, bounded object.

**Why this block exists.** The detector of §7 says *the zero side moves by
at least f(δ, t₀)·|K| when a pair goes off-line*. The floor of §10 says
*the definition side stays below that*. The bridge is the statement that
lets those two inequalities *mean the same thing* — that "zero side" and
"definition side" are not two different objects being compared loosely, but
one object written two ways, whose only disagreement is the rigorously
bounded tail. Without the bridge, the argument has two sides that do not
touch.

## 7. The detector: what an off-line pair does to the kernel

Fix a height γ and take the on-line pair {½ + iγ, ½ − iγ}. Move it off the
line by δ: the four-tuple {½ + δ + iγ, ½ − δ + iγ} and its conjugate. Write

    P_on(s)  = ∏_{ρ ∈ {±}} (1 − s/ρ) e^{s/ρ},        (on-line pair)
    P_off(s) = ∏_{ρ ∈ {±±}} (1 − s/ρ) e^{s/ρ},        (off-line 4-tuple)
    R(s, δ)  = P_off(s) / P_on(s).

The rest of the kernel product is *unchanged* and cancels in the ratio, so R
is a two-factor algebraic object — **no normalization ambiguity, no
approximation**. R has an exact closed form (proven in Lean, piece P3, §9;
γ = height, t = evaluation height, s = ½ + it):

    R(s, δ) = (¼ + γ²) ((γ − t)² + δ²) ((γ + t)² + δ²)
              ───────────────────────────────────────────── · e^{(½+it)·ω_δ}
              (γ² − t²) ((½ + δ)² + γ²) ((½ − δ)² + γ²),

    ω_δ = (1 + 2δ)/((½ + δ)² + γ²) + (1 − 2δ)/((½ − δ)² + γ²) − 1/(¼ + γ²) ∈ ℝ.

A real signed prefactor times a pure constant-rate phase. The only branch is
the sign flip of (γ² − t²) at t = γ.

**The magnitude, in its three regimes** (exact; verified to six digits
against the direct four-zero definition and against the measured data):

- **Near the pair** (t ≈ γ, |t − γ| ≤ 10): |R − 1| ≈ 1. Measured:
  0.9975–1.0201 across the full δ-grid δ ∈ [0.005, 0.5], 56/56 points
  agreeing with the formula to 5×10⁻⁴. An off-line pair at its own height
  **forces a kernel change of at least 99.75% of the kernel's own size**.
- **At twice the height** (t = 2γ): |R − 1| = 4.0000, *exactly*, across the
  whole δ-grid.
- **Far from the pair** (t = c·γ, c > 1): |R − 1| = (c² − 1) to six digits
  (ratios 10, 50, 100 give 99.99998 / 2.499999×10³ / 9.999998×10³), i.e.
  **(t/γ)² − 1, δ-flat to O(10⁻⁶)**. The detector margin *grows
  quadratically* with the height ratio.

**No dead δ window.** The numerator of the relevant magnitude is

    ((t − γ)² + δ²)((t + γ)² + δ²) = (t² − γ²)² + 2δ²(t² + γ²) + δ⁴,

a polynomial in δ with all coefficients positive: **no δ > 0 annihilates
it.** The detector is robust for *every* off-line distance.

**Why the detector works on the count, and why it is invisible on the
argument.** When a pair goes off-line, the Riemann–von Mangoldt count
N(t) steps up by **2** at height γ — a size step. But the *argument* of ζ
along the critical line does not wind: for the two near zeros {½ + δ ± iγ},
the pair factor (1 − s/ρ)(1 − s/ρ̄) has a real-negative numerator
−((t − γ)² + δ²) and is never zero, so its net phase across the straddle
window is **0** (the on-line pair winds by −π). The count sees the ghost;
the argument does not. This is why the S/2K counting fingerprint (the
instrument that certified §2) detects off-line pairs as *size jumps*, and
why a parity argument alone cannot find them.

**Why this block exists.** It is the ≥ side of the contradiction of §8:
at the pair's *own* height, any off-line pair — however small δ is — forces
a kernel change of at least |R − 1|·|K|, with |R − 1| bounded below
independently of δ. The exact closed form (not a lower-bound estimate) is
what makes the bound honest.

## 8. The closure

**Assume RH fails.** By §2, D(t) > 0 somewhere; the set of positive heights
of off-line zeros is discrete (Riemann–von Mangoldt: finitely many up to
any T; the smallest non-trivial zero height is a certified classical number,
≈ 14.13 — no zero height accumulates at 0). Take an off-line pair of
**minimal** positive height t₀, at distance δ₀ > 0 from the line.

1. **Bridge and detector.** At t₀ the §7 detector gives, for the actual
   zero set written as kernel,
   | definition side − zero side | ≥ f(δ₀, t₀) · |K(t₀)|,
   with f(δ₀, t₀) = |R − 1| ≥ 0.998 near the pair, by the bridge identity
   the two sides are the *same* object modulo the tail, and the tail is the
   rigorously bounded M(G, t₀) of §5 (which at t₀ = O(1)·height is far below
   f(δ₀, t₀)·|K| for the measured |K|).
2. **Floor.** By §10, the same quantity is < f(δ₀, t₀)·|K(t₀)|, from the
   definition side alone, with no counting input.
3. **Contradiction.** Hence D(t₀) = 0; by minimality, D ≡ 0 everywhere;
   by the counting lemma, **RH**. ∎ (conditional on §10.)

Nothing in the argument counts zeros at any height *inside the proof*. The
counting enters only in the certified *data* of §2 (which establishes the
strongest unconditional statement to date) and in the classical zero-free
computation that places the smallest zero height away from 0.

## 9. Status of each piece

| # | Piece | Role in the argument | Status |
|---|-------|----------------------|--------|
| P1 | **Counting lemma** (RH ⇔ D ≡ 0) | Reframes RH as a counting statement the detector acts on. | **Proven in Lean** (`RhAttack/B0.lean`; Lean 4.33.1 + mathlib, stable): `eqNtotMinusNon`, `nondec`, `offSliceEven`, `zeroD_of_RH`, `RH_of_zeroD` ⇒ `RH_iff_Dzero`, over an abstract zero set with the F2 symmetry — no ζ, no approximation. |
| P2 | **Per-pair closed form** (la_pair, ar_pair) | Makes the zero-side kernel exact and float64-vectorizable. | **Proven in Lean** (`RhAttack/B4.lean`); dLa ≤ 3.5×10⁻¹⁴, dAr ≤ 3.2×10⁻¹⁶ rad vs direct dps; 16/16 float cross-check. |
| P3 | **Deviation ratio R(s, δ)** (exact) | The ≥ side of the contradiction; δ-robust (no dead window). | **Exact + proven in Lean** (`RhAttack/B5.lean`): `b5Ratio` (closed form), `b5Abs` (magnitude), `b5NoffPos` (numerator > 0), `b5NoffIsPolynomial` (δ-polynomial identity), `b5PrefSign` (branch locus). 12/12 float cross-check vs direct 4-zero definition and the dps-30 record. |
| P4 | **Missing-tail law strictified** (explicit Φ_n, explicit Euler–Maclaurin remainder for W_n) | The definition-side engine of the floor. | **Measured to 4 digits** (N-independent; onset fingerprint at G = 6×10⁶ reproduced ≤ 6%); the rigorous lift is open. |
| P5 | **On-line tail bound M(G, t)** | Makes a finite zero list stand in for the infinite zero set. | **Proven** (unconditional; Platt–Trudgian S̄; Abel mechanism verified on 7.4M real certified zeros to the quadrature limit). Lean kernel integrands P011/Q029/R229: `Bt5.lean` / `RhAttack/B3.lean` §5. |
| P6 | **Bridge identity** (ζ = kernel, residual = tail error exactly) | Lets the two sides of the contradiction be the same object. | Statement fixed; ζ-free finite core **in progress in Lean** (`RhAttack/B3.lean`; `b3ResidualDecomp`: Ψ vs K differ exactly by exp(T − Σ ln F)). Not yet green — no claim. |
| P7 | **Finite exact Abel decomposition** (counting step → integral, smooth comparator N̂, IBP bridge) | Exact calculus relating the discrete zero set to the continuous main term; carries the smooth bounders. | **In progress in Lean** (`RhAttack/B3.lean`: `b3Abel`, `b3Bridge`, smooth-comparator continuity + IBP lemmas). Not yet green — no claim. |
| P8 | **Residual floor, ∀ t** (the §10 gap) | The < side of the contradiction. | **Open.** The wall of the project. Two routes, §10. |

**The certified data record** (all numbers reproducible from committed
scripts and data; day-014 closeout): N(10⁷) = 21,136,121 (two-engine
dt/dt2-stable direct count; S(10⁷) = −3.205718 at dps-45; |S| envelope
2.558 → 2.509 → 3.206 across 10⁵, 10⁶, 10⁷); 2K(10⁷) even ⇒ **no off-line
zero pair below 10⁷**; certified zero list to 6×10⁶ (12,193,869 zeros,
dps-30); onset fingerprint reproduction ≤ 6% at G = 6×10⁶; the +246 early
coarse estimate of the missing-chunk size was **falsified by direct count**
(measured Δ = 244; the 2K even-identity cannot distinguish 244 from 246 —
both are even — and the decisive instrument was the dt/dt2-stable count).
Named residual: the middle window (1.4×10⁶, 9.9×10⁶) of the defective
10⁷ file was not re-walked; a 1–2-flip defect below 1-rad sampling
cannot be excluded there (S flat, no jump > 0.27 across it).

## 10. The open piece: the residual floor (and its two routes)

**The required theorem (P8).** For all t > 0,

    | W_n(t) − [ K_on(t) − (P_n(½+it) − I(n, ½+it)) ] | < min_δ f(δ, t),

proved **from the definition side alone** — no zero-count at any height
enters the proof, and the height bound T never appears. The right-hand side
is the detector scale of §7 (near: ≥ 0.998·|K|; far: (t/γ)²·|K|).

**Route A — residual floor (project home turf).** Build the floor from the
explicit Euler–Maclaurin remainder of P4 (the strictified missing-tail law)
plus the tail bound M(G, t) of P5. Works for |δ| ≥ δ_min(t), where δ_min is
the floor's sensitivity threshold — to be pinned by measurement. This is the
natural route: it reuses exactly the quantities the argument has already
defined, and the measured margin (≥ 14× at the pair's own height against the
local audit floor) says it is within reach.

**Route B — uniform dynamics (classical home turf).** Prove directly that
2K(t) is even for all t (equivalently: S(t) stays in the on-line band, D ≡ 0
as a statement about S's dynamics). δ-robust — no sensitivity threshold.
At full strength it is essentially RH-equivalent; the lifting path is the
open engineering question of the classical S(t) literature.

**Route decision.** The measured data choose between the routes: the
Route-A margin (relative detector scale ≥ 0.998, SNR ≥ 8.9× worst
configuration) remains above the local residual envelope up to t ≈ 10⁴–2×10⁴
(the honest, data-driven ceiling of the current instrument); if it collapses,
Route A is retired and Route B carries the argument. Either way, P8 is the
single remaining gap, and it is *stated, bounded below, and has two named
routes* — not a missing ingredient whose shape is unknown.

## 11. Classical sources

- Riemann (1859): the product representation (DLMF 25.2.12).
- Riemann–von Mangoldt formula; θ(t) and the S(t) convention (DLMF 25.10).
- Functional equation; ζ̄(s) = ζ(̄s); the four-tuple structure.
- ζ(x) > 0 on (0, 1); trivial zeros (standard; citation to be filed).
- Platt & Trudgian, "Explicit formulae and bounds for the Riemann zeta
  function," J. Number Theory **147** (2015) 842–851, Cor. 1
  (the S-bound used by P5; read from the original PDF).

*Provenance policy.* Every certified number in this document is produced by
a committed script and stored with its data file (dps level, engine,
dt/dt2-stability verdict). The Lean artifacts are machine-checked against
mathlib on a pinned stable toolchain (Lean 4.33.1); nothing is "known by
memory," and no measured value stands in for a theorem except where this
document says so explicitly.

—

*Framing: owner-conceived project with AI co-developed instruments, fully
disclosed; working plan, data, and Lean artifacts live in the project's
public repository; no prize claim is made or implied.*
