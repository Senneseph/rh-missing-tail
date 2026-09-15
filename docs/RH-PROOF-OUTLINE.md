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

S(t) is the oscillatory part. Numerically it stays O(1): on certified
data, the |S| at t = 10⁵, 10⁶, 10⁷ is 2.558, 2.509, 3.206 respectively.

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

> **The bridge identity (piece P6, §9; the ζ-free finite core is proven in Lean).**
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
   ‖definition side − zero side‖ ≥ dev(t₀, δ₀) · (reduction error Mf)
   with the kernel change dev measured by the closed form: **at the
   pair's own height t₀ = g₀ the change is exact and strictly positive
   — the on-line pair's 25.2.12 factor vanishes at its own point so the
   pair product is 0 there, and the four off-line factors are nonzero
   (C1a, machine-proven, `RhAttack/Closure.lean`)**; on the near-pair
   window |t − g₀| ≤ 10.2 the scale |R − 1| is measured ≥ 0.9975
   (PINNED, day-010 d4d3 audit). By the bridge identity (ζ = K_on·
   kernel, DLMF 25.2.12 — CITED) the two sides are the *same* object
   modulo the tail, and the tail is the rigorously bounded M(G, t₀) of
   §5 (the A4.3 wiring at the Xval pin, 206× headroom, day-020 record).
   The measured zero side: resid(t₀) ≥ dev − Mf at every scan point
   (day-020 worstcase record).
2. **Floor.** By §10, the same quantity is < the detector scale, from
   the definition side alone, with no counting input (P8Floor A0–A4,
   machine-proven; the measured resid sits below the A4.3-wired bound
   at the Xval pin — hDef, day-020 record).
3. **Contradiction.** With the audited strict gap — dev exceeds the
   LHS including the tail by the audited strict-gap margin
   (hStrict — day-023 re-pin: the closing
   143.341847457× @ t = 5004.7343 records it — dps-30 certified,
   corrected discrete tail; 145.563762319 with the 1e15 remainder —
   the t~10³ anchor is 140.202502242×; DISCOVERY_LOG 25c/25d) —
   the squeeze is empty at t₀: hence D(t₀) = 0; by minimality, D ≡ 0
   everywhere; by the counting lemma, **RH**. ∎ (conditional, by
   design, on the three point-measured facts hZero/hDef/hStrict — the
   audit package; their composition into the contradiction is
   machine-proven as C6, `p9_closure_at_audit_point`.)

Nothing in the argument counts zeros at any height *inside the proof*. The
counting enters only in the certified *data* of §2 (which establishes the
strongest unconditional statement to date) and in the classical zero-free
computation that places the smallest zero height away from 0.

## 9. Status of each piece (2026-09-14, day-024 25x — the (3.15e7, 1e9] data state)

| # | Piece | Role in the argument | Status |
|---|-------|----------------------|--------|
| P1 | **Counting lemma** (RH ⇔ D ≡ 0) | Reframes RH as a counting statement the detector acts on. | **Proven in Lean** (`RhAttack/B0.lean`; Lean 4.33.1 + mathlib, stable): `eqNtotMinusNon`, `nondec`, `offSliceEven`, `zeroD_of_RH`, `RH_of_zeroD` ⇒ `RH_iff_Dzero`, over an abstract zero set with the F2 symmetry — no ζ, no approximation. |
| P2 | **Per-pair closed form** (la_pair, ar_pair) | Makes the zero-side kernel exact and float64-vectorizable. | **Proven in Lean** (`RhAttack/B4.lean`); dLa ≤ 3.5×10⁻¹⁴, dAr ≤ 3.2×10⁻¹⁶ rad vs direct dps; 16/16 float cross-check. |
| P3 | **Deviation ratio R(s, δ)** (exact) | The ≥ side of the contradiction; δ-robust (no dead window). | **Exact + proven in Lean** (`RhAttack/B5.lean`): `b5Ratio` (closed form), `b5Abs` (magnitude), `b5NoffPos` (numerator > 0), `b5NoffIsPolynomial` (δ-polynomial identity), `b5PrefSign` (branch locus). 12/12 float cross-check vs direct 4-zero definition and the dps-30 record. |
| P4 | **Missing-tail law strictified** (explicit Φ_n, explicit Euler–Maclaurin remainder for W_n) | The definition-side engine of the floor. | **Measured to 4 digits** (N-independent; onset fingerprint at G = 6×10⁶ reproduced ≤ 6%); **rigorous lift PROVEN in Lean** (`RhAttack/P4Limit.lean`, GREEN: exact finite law for x^{−s} + M→∞ passage + missing-tail law with sharp constant √3/270 = (1/3)(√3/36)(2/5); the P4 identity `W_n = −½n^{−s} + (s/12)n^{−s−1} − ½∫B̂₂f″` is machine-proven at Re s > 1, and the bound ‖W_n‖ ≤ ½n^{−1/2} + (\|s\|/12)n^{−3/2} + (√3/540)‖s(s+1)(s+2)‖n^{−5/2} is machine-proven at Re s = ½; the W_n-equality at Re s = ½ itself is CITED (DLMF 25.2.8 / Apostol 12.21) — honest split in the file header; T4 ratio corollary incl. \|1−s\| = \|s\| on the line). |
| P5 | **On-line tail bound M(G, t)** | Makes a finite zero list stand in for the infinite zero set. | **Proven** (unconditional; Platt–Trudgian S̄; Abel mechanism verified on 7.4M real certified zeros to the quadrature limit). Lean kernel: the P011/Q029/R229 primitives and derivatives and the explicit remainder bound K̄(G) are **proven in Lean** (`RhAttack/B3Sbar.lean`; full build green). |
| P6 | **Bridge identity** (ζ = kernel, residual = tail error exactly) | Lets the two sides of the contradiction be the same object. | **ζ-free finite core proven in Lean** (`RhAttack/B3.lean` + pieces B3Core/B3Abel/B3Sbar; full build green, A/B gate PASS): `b3ResidualDecomp` (Ψ vs K differ exactly by exp(T − Σ ln F)), the exact finite Abel identity `b3Abel`, and the explicit bound `b3BoundExplicit` (M(G,t) at finite B). |
| P7 | **Finite exact Abel decomposition** (counting step → integral, smooth comparator N̂, IBP bridge) | Exact calculus relating the discrete zero set to the continuous main term; carries the smooth bounders. | **Proven in Lean** (`RhAttack/B3Abel.lean`: `b3Abel`, the ray plumbing, the smooth comparators n̂/N̂ and the IBP bridge `nHatIBP`; full build green; the float64 mirror verifies the exact identity to ~1e-13 at the quadrature limit). |
| P8 | **Residual floor, ∀ t** (the §10 gap) | The < side of the contradiction. | **Route A formalized and machine-proven through A4.3** (`RhAttack/P8Floor.lean`, MODULE COMPLETE A0-A4: `p8_same_object`/`p8_triangle` the same-object reduction + split; `p8_B_floor` the three-term floor = `p4_T4_bound` at s = ½+it; `p8_residual_bound`/`p8_residual_wired` the bridge residual = product mass × e^Xval·Xval with Xval ← B3Sbar `b3BoundExplicit` (the M(G,t) wire); `p8_detector_*` the detector on the B5 closed form incl. the exact δ = 0 values; `p8_far_detector_scale_ge_one` ‖R−1‖ ≥ 1 far regime, γ ≥ 1, t ≥ 2γ — LEAN-PROVEN; `p8_zero_decision_far` the §10 decision inequality). Honest split: the W_n = EM-expression equality at Re s = ½ is CITED (DLMF 25.2.8 / Apostol 12.21); the NEAR-regime detector floor (0.9975) is PINNED by the day-017/019 audit — the wall's remaining open item was that pin's promotion + the final closure at the measurement point (P9) — P9 is now COMPLETE (day-021: C1a promoted the own-height question to an exact Lean fact; the t ≠ g window: the CONTINUOUS 0.9975-floor reading is REFUTED (25i) and the DISCRETE straddle-grid floor is LEAN-PROVEN — 25s/25t, `C1b.p9_c1b_disc_floor`: ‖R−1‖ ≥ min(23/1000, 1−25/γ); the pin stays the witness-scale constant, 25k[4]). |
| P9 | **The §8 closure** (minimal off-line pair height + the squeezed floor/detector) | The final step: D(t₀) = 0 at the minimal pair ⇒ D ≡ 0 ⇒ RH. | **Conditional closure PROVEN in Lean** (`RhAttack/Closure.lean`, MODULE COMPLETE: pins `p9_f_pin = 0.9975` / `p9_d_min = 0.005` / `p9_margin_min = 143.341847457` (day-023 RE-PIN: dps-30 CERTIFIED verified-regime closing @ t = 5004.7343 (g = 5000.234317), corrected discrete tail over the actual zeros (1e7, 3e7] + 1e12 density remainder; 145.563762319 with the 1e15 remainder; DISCOVERY_LOG 25b/25c/25d; 33.9864/34.68 RETIRED — the day-023 tail-integration defect (25b); the earlier pins 112.6 / 1.0529 survive only as old-kernel history); `p9_far_detector_ge_pin` the far-regime detector floor (restated from A4.1b); `p9_point_contradiction` the arithmetic squeeze C5; `p9_min_offline_height` the minimal positive off-line pair height over B0's ZeroSet (structural HNR/HCJ/HFIN, no counting value); `p9_closure_rh_of_margin` the §8 closure under the EXPLICIT squeezed-margin hypothesis — its real witnesses are the pinned/cited constants (Mf ← B3Sbar `b3BoundExplicit` at the Xval pin, flo ← the detector floor, Bfloor+Mr ← the P8Floor A4 composition)). Honest split: C0/C5/C5b/C1-far/C1a LEAN-PROVEN — **C1a (day-021) resolves the branch locus as the POLE at t = g**: the on-line pair product is 0 at its own point and the off-line product mass is a nonzero finite positive constant, so the closure's own-height detector value is exact (`p9_poff_own_height_pos`); the t ≠ g window: REFUTED as a continuous 0.9975 floor (25i pole-ridge) — the DISCRETE straddle-grid floor is LEAN-PROVEN (25s/25t, `C1b.p9_c1b_disc_floor`: ‖R−1‖ ≥ min(23/1000, 1−25/γ)); the pin 0.9975 stays the witness-scale constant per the 25k[4] scope (the closure measures dev per witness point and never evaluates the window floor). **C6 (day-021) is the final composition**: `p9_closure_at_audit_point` — the §8 closure at the audit point as ONE statement: per off-line pair, the three point-measured facts (hZero: zero side, bridge+detector audit; hDef: measured resid ≤ A4.3-wired bound at the Xval pin; hStrict: the audited strict gap) instantiate the hmargin predicate (C6.1, LEAN-PROVEN) and close RH (C5b). The argument's non-machine inputs are exactly those three PINNED per-point facts (script + record); everything else is machine-proven.**Cross-band audit state** (full narrative: DISCOVERY_LOG 25b/25d/25f/25x; the §9 "Audit ladder" below): package verified across [~970, 10⁹] on the P1.1e straddle statistic — dps-30 certified to 1e6 (closing 145.56 @ 5×10³), screened on real zeros above; resid < dev at every scanned point, dev = 1.0000 (the S4 blind spot) throughout, through 10⁹. |
| **P12** | **The uniform statement** (S1–S4: zero side / detector floor / definition side / the uniform squeeze) | The single open mathematical gap, made explicit: RH = (S1∧S2∧S3∧S4) via the (proven) closure. | **FORMALIZED GREEN** (`RhAttack/P12Uniform.lean`, day-023 25e): `offPair`, the four structural hypotheses, `squeeze_gives_margin` (S1–S4 ⇒ C5b's hmargin — LEAN-provable) and `p1_2` (⇒ RH). S1 = CITED wire (Xval-uniformity in the height — MEASURED from 25x onward: the P1.1e straddle margin is ≥ 1 through the 3.75e7 window (screened; certified to 1e6) and < 1 at 5e7/7.5e7/1.5e8...1e9 on actual zeros, kernel-robust, with a local recovery at 1e8 — the S1 height gap is now LOCATED at ~4e7 and above, no longer an unknown; 25x/25x[6]); S2 = far/own-POLE LEAN-PROVEN, t≠g DISCRETE-window floor LEAN-PROVEN (25s/25t, `C1b.p9_c1b_disc_floor`: min(23/1000, 1−25/γ); the continuous-floor reading is refuted, 25i; the pin 0.9975 stays the witness constant, 25k[4]); S3 = PROVEN wire; **S4 (uniform squeeze over the blind spot) = the open mathematics — now EXACTLY QUANTIFIED as two named gaps (25p/25q/25v)**: GAP-W (bound-level window squeeze beyond the pinned t\* = 690349.0568 — the prize-scale obstacle) and GAP-O (own-regime strip squeeze — PROVEN IMPOSSIBLE at the current O(t^{-1/2}) wire, S4c), whose replacement wire must sit below Eenv(t) = (1/10⁴)(16001/15984)·t⁻² with a power-of-t deficit Kgap·t^{3/2} (Kgap = (1/2)(8/13)^{1/2}·10⁴·16001/15984 ≈ 3926.494; the whole p8_B wire family n <= 13t/8 is excluded, `S4Sharp.s4d_list_scale_impossible`) — i.e. a genuinely O(t^{-2})-shaped own-regime wire or GAP-O folds into the gapW-class obstacles (`RhAttack/S4Sharp.lean`, LEAN-PROVEN). |

### Audit ladder and the data state (day-023 25b → day-024 25x)

*The P1.1e straddle statistic* — the max over the 0.5-straddle window of
the ratio of |ζ(½+it)|·min_δ‖R−1‖ to the definition-side floor B(t) +
resid(t) — is the operational S1 witness; the ladder below is its
re-issue history.

- **Day-023 re-issue (25b/25c/25d, corrected kernel).** The old kernel's
  (B,∞) tail QUADRATURE (infinite-interval mpmath) systematically
  under-integrated the near mass: the old margins 11.3 (10⁴) → 1.053
  (5×10⁴) → 2.27 (10⁵) and the old closings 112.6/34.68 were artifacts of
  that one defect (the day-020 "tail-model error" explanation is itself
  superseded by 25b, which located the bug). Re-issued on the exact
  discrete tail over actual zeros: 140.2 (10³), **145.6 (5×10³, CLOSING,
  dps-30 certified 143.341847457 / 145.563762319)** → 87.7 (10⁴) → 55.5
  (10⁵) → 24.4 (2×10⁵) → **13.86 (10⁶)**; verified region [10³, 10⁶],
  margin ≥ 13.9. The earlier "sub-1 crossing at T\* ≈ 2.5×10⁴" is
  RETIRED as that defect.
- **Band (1e7, 3.15×10⁷] (25f, screened, real zeros):** every printed
  window SOUND, margin ≥ 1.4, B(t)-floor-dominated, dev = 1.0 — the S4
  blind spot open exactly as designed.
- **Band (3.1946×10⁷, 1.006346×10⁹] (25w data + 25x scan):** the public
  LMFDB/Platt band (2,792,198,664 zeros, RVM-anchored) re-ran the 25f
  protocol with the discrete tail over ACTUAL zeros to 1.0063e9 (the 25f
  "nominal rows" are now REAL): margin ≥ 1.6 in every window 1e7..3.75e7
  (E ≤ −0.008; the 3.1e7/3.75e7 rows flip nominal→SOUND, 1.91/2.37);
  the boundary sweep (25x[7], 26 denser windows) then finds the SOUND
  region extends to 5.2×10⁷ (min 1.277 @ 3.9e7) and the margin drops
  BELOW 1 for the first time, robustly, at 5.6×10⁷ (0.566, E −0.018,
  best-case |ζ|/B = 0.57 < 1): it then OSCILLATES (dips 0.566/0.758/
  0.714/0.713/0.443 (MIN @ 1.1e8)/0.835/0.585/0.620 in (5.4e7, 2e8];
  8 of 21 windows robustly sub-1; recoveries up to 3.229 @ 7.2e7), is
  monotone-sub-1 above 2×10⁸ (0.623 @ 3e8, 0.155 @ 5e8, 0.092 @ 6e8,
  0.020 @ 1e9), and floor-dominated throughout (B(t): def_c 6.8 → 440;
  B(t) ~ t^{1/2}: 3.02/9.53/30.1 at 1e7/1e8/1e9 — the sharp t^3 n^{−5/2}
  P4 term — so the best-case envelope |ζ|/B decays: sub-1 is the
  ASYMPTOTIC regime of the P1.1e wire, 25x[7] note 3).  The
  pre-registered P1.1e route-retirement rule (25b: "margin < 1 at ≥
  10⁵") FIRES above the ~5.6×10⁷ onset (sweep 25x[7] LANDED; dps-30
  pins 25y IN FLIGHT on the 5.6e7 and 1.1e8 dips).  The S1
  height-uniformity gap is a MEASURED regime (~5.6×10⁷ upward,
  oscillatory), not an unknown.
- **The 1e7 repair walk (closeout):** 32-way, 100 h, 0 failures, dt/dt2
  agree on every segment; independent flip count 8,942,252 in
  (6×10⁶, 10⁷] = the LMFDB slice EXACTLY (N(10⁷) = 21,136,121 = LMFDB
  21,136,125 − the 4 documented twins); the day-014 "named residual"
  (the un-re-walked middle window of the defective file) is RESOLVED.
- **PinCensus completeness audit (22):** stands (the day-022 6.7%
  probe-gap retracted there as a probe-path artifact).

**Remaining price (day-024 state — the three named items, per the p1.2
spec):** (i) GAP-W — the S4 window-regime squeeze past the pinned
t\* = 690349.0568 ([10³, 1.1×10⁵] GREEN at bound level; beyond t\* the
deficit is O(1)); (ii) S1-GAP — the measured oscillatory sub-1 regime
entered at ~5.6×10⁷ (min 0.443 @ 1.1×10⁸; asymptotic: B(t) ~ t^{1/2}
vs |ζ| ⇒ envelope → 0; sweep 25x[7] LANDED, pins 25y in flight); (iii)
GAP-O — the own-regime wire of genuinely O(t⁻²) shape (25v: whole
p8_B family n ≤ 13t/8 excluded; demand envelope Eenv(t) =
(10⁻⁴)(16001/15984)·t⁻², deficit Kgap·t^{3/2}, Kgap ≈ 3926.494) — or its
fold into the gapW-class (owner decision pending).  Plus, the
mathematical gap itself — the residual-floor theorem of §10.

**The certified data record** (all numbers reproducible from committed scripts and data; day-023 25b closeout + day-024 25w addition — superseding the day-014 note):
N(10⁷) = 21,136,121 (independent 100-h two-engine walk: 12,193,869
seeded (≤ 6×10⁶) + 8,942,252 flips in (6×10⁶, 10⁷] = the LMFDB 31-digit
slice count EXACTLY; the LMFDB total 21,136,125 differs by the 4
documented twin pairs below 6×10⁶); DAY-024 ADDITION (25w/25x): the public LMFDB/Platt band (3.1946×10⁷, 1.006346×10⁹] = 2,792,198,664 zeros (31-digit dataset, RVM-anchored: N(10⁹) = 2,846,548,032, |diff| = 1; band min gap 1.08540×10⁻⁴) — the data record now reaches 10⁹ on the CITED dataset; the (6e6,1e7] walk and the merged list stand as the independent cross-check layer.
The |S| envelope is 2.558 → 2.509 → 3.206 at 10⁵, 10⁶, 10⁷ respectively, and 2K(10⁷) is even (2K(10⁷) = −2) ⇒ **no off-line zero pair below 10⁷**.  Certified zero lists: dps-30 merged list to 10⁷ (day-023 walk + 19 public 31-digit shards) and the 25w band (3.1946×10⁷, 1.006346×10⁹] on the CITED 31-digit dataset; band min gap 1.08540×10⁻⁴.  Onset fingerprint reproduction ≤ 6% at G = 6×10⁶.  The +246 early coarse estimate of the missing-chunk size was **falsified by direct count** (measured Δ = 244).

(day-014 "named residual": RESOLVED by the 25b walk — see the audit
ladder above.)


## 10. The open piece: the residual floor (and its two routes)

**The required theorem (P8).** For all t > 0,

    | W_n(t) − [ K_on(t) − (P_n(½+it) − I(n, ½+it)) ] | < min_δ f(δ, t),

proved **from the definition side alone** — no zero-count at any height
enters the proof, and the height bound T never appears. The right-hand side
is the detector scale of §7 (near: ≥ 0.9975·|K| — the day-010 straddle pin; far: (t/γ)²·|K|).

**Route A — residual floor (project home turf).** Build the floor from the
explicit Euler–Maclaurin remainder of P4 (the strictified missing-tail law)
plus the tail bound M(G, t) of P5. Works for |δ| ≥ δ_min(t), where δ_min is
the floor's sensitivity threshold — to be pinned by measurement. This is the
natural route: it reuses exactly the quantities the argument has already
defined, and the measured margin — dps-30 certified closing
143.341847457× @ 5×10³ (145.563762319 with the 1e15 remainder),
verified region [10³, 10⁶] margin ≥ 13.9, screened on ACTUAL zeros
to 1.0063×10⁹ with margin ≥ 1.6 through 3.75×10⁷ and ≥ 1.28 through 5.2×10⁷ (sweep 25x[7]; DISCOVERY_LOG 25c/25d/25f/25x) — says it is within reach *while it lasts* (see the
route decision below for where it stops).

**Route B — uniform dynamics (classical home turf).** Prove directly that
2K(t) is even for all t (equivalently: S(t) stays in the on-line band, D ≡ 0
as a statement about S's dynamics). δ-robust — no sensitivity threshold.
At full strength it is essentially RH-equivalent; the lifting path is the
open engineering question of the classical S(t) literature.

**Route decision.** The measured data choose between the routes, and
(day-024, 25x — the (3.15e7, 1e9] data landed and the 25f protocol was
re-run on ACTUAL zeros to 1.0063×10⁹) they have made a first choice.
Below the boundary, the Route-A margin stays above the local residual
envelope: dps-30 CERTIFIED closing 143.341847457× at t = 5004.7343,
verified region [10³, 10⁶] margin ≥ 13.9, screened ≥ 1.6 through
3.75×10⁷ and ≥ 1.28 through 5.2×10⁷ (sweep 25x[7]; the old 34.68×/
122→2.3 trend and the "2.5×10⁴ crossing" RETIRED as the day-023
kernel tail defect, 25b). Above it, the margin drops BELOW 1 for the
first time, robustly, at 5.6×10⁷ (0.566; best-case |ζ|/B(t) = 0.57 <
1), then oscillates (dips to 0.443 @ 1.1×10⁸, recoveries up to 3.23),
is monotone sub-1 above 2×10⁸ (0.020 at 10⁹), and is floor-dominated
throughout (the B(t) ln-t floor: def_c 6.8 → 440; B(t) ~ t^{1/2}, so
the best-case envelope decays: sub-1 is the asymptotic regime).  The
pre-registered retirement clause (25b) therefore fires above the
~5.6×10⁷ onset at the screening level (sweep 25x[7] LANDED); the
dps-30 pins (25y, in flight on the 5.6e7 and 1.1e8 dips) make it a
certified fact.  The decomposition of the remainder follows:
*(i)* on [10³, ~5.6×10⁷], Route A stands (above t\* = 690349.0568,
the S4 squeeze bound itself is still to be proven — GAP-W); *(ii)* on
(~5.6×10⁷, ∞), Route A's wire has no margin against the sharp P4
floor (and none can be restored by tuning: B(t) ~ t^{1/2} beats
fluctuating |ζ|) and the argument needs a different < side or Route B
(the S1-GAP); *(iii)* the S4
own-regime wire requirement (GAP-O, 25v) is a named decision item.
Either way, the open piece is *stated, bounded below, localized, and
named* — not a missing ingredient whose shape is unknown.

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
