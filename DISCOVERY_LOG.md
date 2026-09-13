# DISCOVERY_LOG — the chronicle

*Living document, 2026-09-10. This file chronicles the **approach** and
the **pieces we found along the way**, in the order they were found, and
how they combine. It does not track setbacks. It **does** track
important contradictions — disagreements between a measurement, an
expectation, or a recorded value, and how each was resolved. Every
number below traces to a certified output named in
`results/`, or to a labeled status (MEASURED / EXACT / IN-FLIGHT) in
the staged scaffold (`docs/`). New entries are appended in order; an
entry is written only when its evidence file lands.*

---

## 1. The approach

**RH is a question about the primes. The zeros are the side question.**

The classical view attacks the zeros directly (bounds for S(t),
density theorems…). We do the opposite: treat the **prime side** as
primary — the truncated prime data, the zeta value computed *from its
definition* (Riemann–Siegel), the partial sums, the integral — treat
all of it as computable at every height **without using any zero** —
and ask where, and at what size, the **zero content** must enter that
budget. RH then reduces to a counting statement (`D ≡ 0`, no off-line
pair at any height), and the whole program is: build an instrument
that certifies its own counts, measure the exact prime-side laws, find
the measurable point where zero content first enters, and show that
entry is *exactly* the Riemann-1859 zero product kernel.

The working method is the **four operations** on the approximation
(add / remove / duplicate / alter one term, one cell, one zero, one
height at a time), run on an instrument that is disciplined like a lab:
two engines must agree, every count is self-certified (twin-floor),
every constant is computed not recalled, every claim is labeled. The
owner's standing intuition — that **½ is the central object** (the
critical line, the half-term, the onset at ½·t = N, (−½)! = √π, the
power-tower half-attractor…) — enters as a *measurement target*: each
home of ½ is measured separately, and the unity claim stays labeled
INTERPRETATION (PLAN.md, P-G).

The pieces below are the findings, in order.

---

## 2. The pieces, as found

### 2.1 The self-certifying instrument (days 1–4)

A float64 zero-finding engine (dual dt-stacks + dps oracle spot
checks) that **certifies its own counts**: a count is accepted only if
two floor spacings agree (dt/dt2 twin-floor), and the count at each
certified height is spot-verified at high precision (2K parity, S
value, dps). **What it caught on its own:** one dead counting chunk in
~70,000 at the 10⁷ walk (a flat |S| ≈ 247 plateau where flips
stopped) — localized by S-*size*, not by parity, corrected as +246
flips, and the whole walk re-certified (`results/certified-zero-survey.md`).
This is the referee every later number is measured in front of.
**Crown jewel of the instrument:** a program that takes n and returns
the n-th non-trivial zero *by computation, not lookup* (dps-certified
bracket → twin-floor walk from a dps anchor → float bisection → dps
tail; first output γ₁₃₈₀₆₆ = 100000.74372338832472…,
`results/zero-finder.md`).

### 2.2 The missing-tail / width ladder (days 3–5)

Truncate the zeta series at n = N: the missing tail has an **exact
residue split** per Dirichlet cell (Hurwitz zeta per residue class).
Used as a *computation* (no asymptotic fitting) it yields, to 10⁻¹⁰:

- the edge law **D = −P** (the edge term is exactly minus the cell
  partial sum) on 18/18 phases at χ₅ and χ₁₃, 17/17 at χ₁₇;
- the **width (cell-moment) tables** M₁ — all rational: χ₅ in fifths
  {2/5, 2/5, −3/5, −3/5, 2/5}, χ₁₃ **all integers** (13 phases),
  χ₁₇ all integers to 1e-9;
- two structural laws at every odd-prime modulus measured:
  **M₁(r) = M₁(−r mod q)** (mirror) and **Σ_r M₁(r) = 0** (zero-sum
  trace); t-independence of M₁;
- a complex drift coefficient (3/5 + 2i/5)·(t/N) at the χ₅ r = 1
  rung, decay exponent −1.0005 ± 0.001, whose real and imaginary parts
  carry *different* phase-group moments — the first measured
  cross-phase coupling in a truncation ladder.

**The reading (labeled):** the Dirichlet tail is a **flat action** —
the exact part is cell data computable at every order, the remainder
is zero content. Universality of the ladder is then *by construction*
(a closed action cannot see zeros or t), which is what the ½
intuition is about on the prime side. (`results/width-ladder-tables.md`.)

### 2.3 The Euler action identity — E7a (day 6)

The finite summation-by-parts identity (README §Abstract):

```
Σ_{n=N+1}^{M} a(n)·n^{−s} = A(M)M^{−s} − A(N)N^{−s} + s ∫_N^M A(u)·u^{−s−1} du
```

holds **exactly** for every step path a(n), every s, every N < M;
verified at 50 digits on periodic and non-periodic paths (residuals
10⁻⁵¹–10⁻⁵³, `FORMULAS.md` §2.1). This is the bridge object: series
side, action side, and zero-side remainder all speak the same
language. Used as a *computer* it produced the E2-exact infinite-form
test (18/18 phases at 1e-10, zero fits). **2026-09-10: the identity is
now PROVEN in Lean** (any commutative ring, one-induction proof) with
a 5/5 independent float64 cross-check against the Python oracle
(worst deviation 2×10⁻¹⁴) — `formal/`, one-command
verifiable. A finite identity that was "measured exact" is now
"machine-checked exact".

### 2.4 The onset (days 4–5) — where zero content first enters

For the ζ tail (unbounded path, regularized), the measured
zero-oscillatory term C obeys, in the onset window,

**C/|I| = ½·(t/N)** — to **four digits**, **N-independent** across
N ∈ {10³, 10⁴, 10⁵}, first visible at **½·t = N** (the
unit-magnification configuration of the reciprocal lens). Beyond
t/N ≈ 2 the scaling changes regime (measured, in the width
ladder tables). Reading (labeled): ½·t = N is the moment the
zero-side interior action overtakes the edge (cell) action in the
missing-tail budget. The classic ½ of the Euler–Maclaurin half-term
is the same width object M₁ in the smooth-path slot — one ladder, two
entry points. (P-G in PLAN.md: the six measured homes of ½.)

### 2.5 Certified counterexample search (days 5–9) — and the 246

Certified, no-ghost results standing at v0:

- N(10⁵) = 138,065; N(3×10⁵) = 466,655 (GPU, dt/dt2 exact, gate
  6.5×10⁻¹⁰); N(10⁶) = 1,747,142; S(10⁵) = −2.558419306,
  S(10⁶) = −2.508632116 (40+ digits); 2K = −2 at 10⁶ (parity: even,
  no off-line pair); twin census 19 in (10⁵, 10⁶];
- **N(10⁷) = 21,136,123 — triple-certified** (dt/dt2-stable window
  227,197; corrected +246 chunk; dps-40 spot); S(10⁷) = −1.2057
  (O(1)); 2K(10⁷) = 0 at 2.25×10⁻⁹ (dps-40). One final redundancy
  re-walk was still in flight at the sync of this document
  (IN-FLIGHT — closes the last redundancy slot; no scaffold change).

The 246 itself is the instrument's design point made concrete: an
off-line pair (or a defect) is **invisible to the parity certificate**
(2K counts parity only) and is found by **S-size** instead. The
detector family the proof later needs (off-line ⇒ measurable
deviation) was *already in the pipeline*, proven on a real defect
before the zero-side theory existed. (`results/certified-zero-survey.md`.)

### 2.6 The 24-adic front/back — two cell classes, two laws (days 6–8)

The ladder was generalized past odd-prime quadratic cells:

- **τ₁₂** (the 2×4×3 multiplicative period-12 cell): exact M₁ table;
- **F₂₄** (the *non-multiplicative* period-24 cell from the
  Fibonacci ladder; cell sum 108, code-verified mean 9/2): the raw
  front/back split is mod-4 identical + a mod-3 slide; M₁ halves are
  **near-identity** (contrast: the multiplicative even cell τ₁₂ has
  the **antipode sign-flip** M₁(r+6) = −M₁(r) at 1e-10..1e-14);
  the F₂₄ cyclotomic pole sits at 9/2 (the "9/2 pole", measured, not
  conflation with τ₁₂'s structure — τ₁₂ and F₂₄ are different
  objects that both live near 24);
- the quadruple corner law 180°−720°/q and the multiplicative /
  non-multiplicative cell split.

The owner's 12/24 "front sweeps the front quadrants, back sweeps the
back" image was **measured**: the antipode law is real at 1e-10..1e-14
on the multiplicative cell; the 24-cell M₁ landscape is near-identity
rather than sign-flip. The unification ("3 units per quadrant in π")
did **not** become a load-bearing object: the side-quest was **sealed
v0.5–v0.7** after its measured parts passed — a boundary decision,
recorded here because the measurement stands while the interpretation
is deliberately left out of the proof path. (Contradiction log §3.2.)

### 2.7 The zero-side bridge — E7b Stage 1 (day 9)

Read the primary sources verbatim (Riemann 1859, p. 9; DLMF 25.2 /
25.4): the **product over zeros** is DLMF **25.2.12** —

```
ζ(s) = (2π)^s e^{−(1+γ_E/2)s} / (2(s−1)Γ(s/2+1)) · Π_ρ (1−s/ρ)·e^{s/ρ}
```

— with the analytic density tail appended. Two structural facts
measured: (i) on the critical line each conjugate **pair-factor is
exactly real** (the two principal arguments sum to a multiple of π;
atan2 constants cancel in-pair); (ii) the zero side reduces to a
float64-vectorizable sum (B-4: closed per-pair form, dps-25
unit-checked, cross-validated point-for-point against the certified
table by the vector re-run). **Stage 1 result:** the zero-side kernel
(over the certified 466,655-zero list + analytic tail) **reproduces
the measured 4-digit onset** — (N=10³, t/N=1): +0.29%; (N=10⁴,
t/N=0.1): −1.2%; two borderlines +4.2/+5.8%; the rest below the
quantified zero-side error floor (the density tail saturates once
G ≫ t). A prime-side law (computed without using zeros) is reproduced
by the zero side (which uses *only* the zero list + textbook
analysis), at the predicted heights, with 4-digit agreement and a
quantified error budget: the bridge is **real**, and its constants are
measured. (`spec/onset-bridge-e7b1.md`, `FORMULAS.md` E7b-1.)

### 2.8 The detector — off-line pair ⇒ forced deviation (day 10)

The G2 question (would an off-line zero be *detectable*?) answered in
two layers:

- **Exact core (B-5, v0.5):** replace one on-line pair in the 25.2.12
  kernel by an off-line pair at δ = β − ½ ≠ 0. The kernel-deviation
  ratio R = P_off4 / P_on2 has a **closed form from 4 lines of
  algebra** (real-signed prefactor × constant-rate phase; the only
  branch is the on-line prefactor's sign flip at t = γ; δ > 0 has a
  *no-zero-window*, its magnitude is a δ-polynomial with all-positive
  coefficients). Measured regimes, all 56 grid points: near resonance
  |R − 1| ≈ 1 (≥ 0.998); at twice the pair's height exactly 4.0000;
  in the far regime |R−1| = (t₀/γ*)² to 6 digits — the detector margin
  **grows quadratically** with height ratio. Verified dps-30, three
  levels (formula vs definition ≤ 6×10⁻²⁶; formula vs measurement ≤
  5×10⁻⁴ = the last printed digit).
- **Mechanism (settled, measured + structural):** an off-line
  4-tuple is **argumentically invisible on the central line** (its
  near-pair factor is real-negative, never zero ⇒ net phase 0.000
  across the straddle window, vs −π on-line) while the
  Riemann–von Mangoldt count *does* count it ⇒ **2K takes a +2 size
  step, parity is preserved, no flip**. The detector is therefore
  exactly the *S-size family that already found the 246* — the
  instrument built in §2.1 is the theorem's eye. Route-A
  signal-to-noise, measured against the fine local audit floor: ≥ 8.9×
  worst configuration, ≥ 14× at the pair's own height; in the
  relative form |ΔK|/|K| ≥ 0.998 uniformly, no audit floor needed.
  (`results/e7b1-detector-b5-core.md`, `docs/RH-PROOF-OUTLINE.md` B-5.)

### 2.9 The staged proof skeleton (day 10)

The pieces combine into a skeleton with numbered blanks
(`docs/RH-PROOF-OUTLINE.md`, v0.5):

**RH ⇔ D(t) ≡ 0** (B-0, a 2-line counting equivalence from classical
inputs) where D = N_total − N_on-line jumps by 2 at each off-line pair
height. The proof contains **two sides of one identity**: the
definition side (ζ from Riemann–Siegel, P_n, I, hence W(t) — no zero
input, computable ∀t) and the zero-side kernel 25.2.12 + tail. The
three propositions: (i) on-line ⇒ explicit dynamics (the measured
onset + exact pair form + rigorous tail — B-1, B-2, B-3, B-4 filled);
(ii) off-line ⇒ forced deviation (B-5, **core FILLED, exact**);
(iii) the ∀t closure — the one open wall, with three candidate routes
(A: prime-oracle + residual floor; B: uniform S/2K dynamics; C:
hybrid interim) and a written **decision rule on incoming data**
(D1 tail-saturation walk, D2 beyond-4-digit fits, D3 W-audit, D4
detector margin, D5 10⁷ redundancy — D4 all landed; D1, D5 in flight
at sync). The skeleton is explicitly **not a proof**: every step is
labeled, every blank names its data trigger, and the document states
what would kill it.

### 2.10 The formal instrument (days 10–11)

The reasoning tooling itself became part of the artifact:

- **kainos-logos store trained on the proof object:** a Prolog-style
  proof store discharged the skeleton's implications, ran the
  circularity query (**CLEAN** — no cycle touches the target; the
  "substitute the on-line zero set into ζ" knot is a mechanically
  checked property, not a discipline prayer), honored the invariant
  that `rh` stays status = hypothesis (**no `theorem:riemann`
  assertion exists anywhere**), and demonstrated the *drop-in*
  property four times (new data files appeared ⇒ corresponding
  assertions flipped candidate→established automatically, no module
  edited).
- **Lean 4 + Mathlib:** the E7a identity proven over any commutative
  ring; 5/5 oracle instances cross-checked by an independent Lean
  float64 pipeline (worst 2×10⁻¹⁴); `formal/` in this repo,
  one-command verifiable. The finite core of the proof is now an
  external, machine-auditable fact.
- **The B-4 pair identity joined the machine-checked core (same
  day):** the two DLMF-25.2.12 on-line factors for a certified zero
  height, `RhAttack/B4.lean` — T1: they collapse *exactly*, for all
  γ,t > 0 (even at the crossing t = γ), to a real signed prefactor
  times one exponential; T2: the log-magnitude in the ledger's
  verbatim form; T3: the additive phase exactly mod 2π — stated in
  the branch-cut-free circle type (no `atan2` principal-value
  machinery at all) and in ℝ with an explicit 2πℤ multiple. Cross-
  checked on the 16 recorded points inside Lean float64 (closed form
  vs direct fac product): 16/16, worst deviations ~10⁻¹⁴ — the
  predicted double-roundoff scale. What this means for the story:
  the per-pair content of the zero-side bridge — "the constants
  cancel in-pair, and the crossing is a sign flip, nothing else" —
  is now an external, machine-auditable fact, in the same package.

---

## 3. Important contradictions (recorded, resolved or standing)

By the owner's rule, setbacks are not logged here; contradictions are.

### 3.1 The ledger mis-attribution (DLMF 25.2.11 vs 25.2.12) — RESOLVED

The formula ledger carried "25.2.11 = product over zeros". The
verbatim read gate (raw TeX captured, committed) found **25.2.11 is
the Euler *prime* product**; the zero product is **25.2.12**. Corrected
in the ledger before any zero-side formula first used it. This is the
computed-not-recalled discipline working exactly as designed: a
recorded value disagreed with the primary source, and the primary
source won. (Also caught in the same read pass: the 25.11 Hurwitz
correction to the earlier on-line pair-factor note.)

### 3.2 The 12/24 front/back image vs the 24-cell measurements — SEALED, measurement kept

The owner's image (front 12 / back 12, "3 units per quadrant in π")
split under measurement: the **antipode sign-flip law is real**
(M₁(r+6) = −M₁(r) at 1e-10..1e-14, multiplicative cell) but the
non-multiplicative 24-cell (F₂₄) shows **near-identity** halves
instead of sign flip, and no 12/24 split of the π structure was
measured at the claimed strength. Resolution: the *measurements*
stand and are in the width tables (two cell classes, two laws —
genuinely informative); the *unifying interpretation* was sealed as a
closed side-quest (v0.5–v0.7) and is **excluded from the proof path**
deliberately. Important not because it was wrong, but because the
project demonstrated it can kill one of its own images on data — and
chose the measurement over the picture.

### 3.3 The 3-term trap (convergence vs truth) — RESOLVED, discipline written

A three-term fit of the χ₅ edge moment returned **7/5** with a
residual of 1e-9 — "converged" to the wrong value while the exact
table (no fitting involved) said **2/5**. Resolution: exact tables
only; the no-3-power-term-fits rule was written into P-0. This is the
one standing reminder in the store that *precision of a fit is not
truth of a value*; every width table in `results/` is fitted-or-not
labeled accordingly.

### 3.4 2K(10⁶) = −2 vs 2K(10⁷) = 0 — RESOLVED by the instrument

Not a contradiction once read, but a near-miss one that was caught:
the parity certificate is even at both heights, but the 10⁶ value
(−2) is the *un-corrected* count (2K counts flips mod 2: −2 ≡ 0),
while the 10⁷ walk carried the +246 defect correction and the
dps-40 2K = 0 at 2.25×10⁻⁹. Both are consistent with no off-line
content; the discrepancy is bookkeeping, logged with the defect
post-mortem in `results/certified-zero-survey.md`.

### 3.5 Standing tension (not resolved — this is the open problem)

**What is measured vs what is closed:** the prime-side law is
measured to 4 digits and N-independent; the zero side reproduces it
inside a quantified floor; the exact finite core is machine-checked;
the *∀t* closure (B-6, the (iii) proposition) is **open**, with its
candidate routes, margins, and decision rules written. The skeleton
is a scaffold with numbered blanks, not a proof; the repository claims
exactly what the labels say (README §What it does not claim) and no
more.

---

## 4. Where the chronicle stands (sync 2026-09-10)

Found and in force: the instrument (§2.1), the flat-action ladder
(§2.2), E7a EXACT → machine-checked (§2.3), the onset (§2.4), the
certified no-ghost bound 10⁶ / 10⁷-triple (§2.5), two cell classes
(§2.6), the reproduced bridge (§2.7), the exact detector (§2.8).
Combining: the staged skeleton (§2.9) + the formal instrument
(§2.10). In flight at sync: the G = 6×10⁶ list walk (decides B-2's
tail model and the A/B route) and the final 10⁷ redundancy (closes
§2.5's last slot). Next entry is written when the first of those
lands.

---

## 5. The 10⁷ redundancy lands — and the LOCKED candidate falls (2026-09-11)

*Supersedes §4's in-flight list (both slots now landed: the G = 6×10⁶ chain,
day-010/11, and the final 10⁷ redundancy). Entry written because an
evidence file landed — and because this is the log's contradiction case.*

**The contradiction (the log's own purpose).** The pre-registered LOCKED
candiate for the dead-chunk size was **+246** (a coarse |ΔS| estimate from
the S-plateau, never a direct count). The completed re-walk (PID 1142170,
~23 CPU-h, exited 2026-09-10 20:22 local; record
`scripts/rh/out_day006_early_rewalk.txt`) **measured +244**. Both are even —
and that is the honest wall: the 2K even-identity **cannot arbitrate 244
vs 246 at any precision** (N enters mod 2; 2K = −2 and 2K = 0 are both
even; the dps-45 principal-arg test passes both families, dist ≤ 2.3×10⁻⁹).
The arbiter is the dt/dt2-stable direct count, doubly confirmed: the
re-walk's window (10⁶, 1.4×10⁶] count **773,829** is independently
reproduced to the last zero by the day-009 6e6 GPU zero list (same window,
same count, different engine).

**Certified (day-014 record; replaces all DEFECTIVE 1e7 numbers).**
N(10⁷) = **21,136,121** · S(10⁷) = **−3.205718** (dps-45) · 2K even ⇒
**no off-line zero pair below 10⁷**. Dead chunk located precisely:
(10⁶, 1,000,128], Δ = 244 flips, 128 rad (the early "~1.06×10⁶ plateau"
localization is revised). Named residual: the middle window
(1.4×10⁶, 9.9×10⁶) was not re-walked — a 1–2-flip defect below 1-rad
sampling is not excluded there (S flat, no jump > 0.27).

**Logged bug (P-0.9).** The pre-staged verifier `day005h_verify_1e7.py` was
broken two ways and had never run to completion (payload concatenated into
source; principal-arg where the identity only has principal-arg strength).
Fixed (`day005h_mp.py` companion); the buggy first run is kept as
`out_day014_dps45_d244.BUGGY-verified-gamma-arg.txt`. The code-beats-
memory rule worked, and the broken check cost exactly the one re-check the
owner demanded before trusting the number.

**Repository structure (same day).** The Lean package now **lives in this
repository** (`formal/`, source of record; the kainos-logos path is
a symlink) — `formal/RH-LEAN-PROVENANCE.md`; the proof path was rewritten as
a public linear exposition with named pieces P1–P8 (`docs/RH-PROOF-OUTLINE.md`,
byte-identical with the working-repo source of record); every Lean file
carries a purpose header (what it is / role / status); reference material
moved to the working repo (`kainos-logos/references/`).

## 6. The P4 line turns green — and a formalization trap worth naming (2026-09-12)

**State of the P4 line (rh-missing-tail).** Four machine-checked atoms,
one per commit, zero sorry: `P4Em` (1st-order EM, verbatim port of the
published proof), `P4Tail` (per-period 2nd-order identity + the periodic
`B2` kernel), `P4Em2` (the global finite 2nd-order law
`∑ f = ∫ f + ½Δf + (1/12)Δf′ − ½∫ B̂₂f″`), and `P4Limit` L1+L2
(the `x ↦ x^{−s}` derivative family + the exact finite law with the
antiderivative `x^{1−s}/(1−s)` and the `B2` remainder explicit —
`7d42ced`). L3–L5 (kernel convergence at `M→∞`, the OP1/OP2 remainder
bounds, the stated bound `|W_n(t)| ≤ B_n(t)`) are queued. Every `lake
build` green (17426 jobs); all four runtime cross-check gates PASS.

**The trap (named for the record).** In Lean 4 / mathlib, a term printed
as `↑(B2 x) * deriv (deriv f) x` can hide *which* coercion instantiated
the `↑`. A theorem stated for generic `[RCLike 𝕜]` (like `em2_finite`)
elaborates the real scalar through the RCLike coercion
(`ofReal := Algebra.cast`); the same printed term in a concrete `ℂ` file
elaborates through the higher-priority `Coe ℝ ℂ` (`Complex.ofReal`). The
two kernels print identically but are **not unification-equal**, so
`rw [h]` silently fails with "did not find an occurrence of the pattern"
— a failure mode with no error pointing at the cause. The probe that
root-caused it (four cast forms against the live goal; only
`algebraMap`/`Algebra.cast` match) is logged in the day-019 §12 journal
and pinned in the `P4Limit` header. Rule for this codebase: when
rewriting into a generic-`RCLike`-land term, spell the scalar as
`algebraMap (R := ℝ) (A := ℂ) (·)`. Costs nothing (`algebraMap x = (x : ℂ)`
is `rfl`); saves a day.

## 7. The missing-tail law turns green — and the draft constant had to die (2026-09-13)

**L4 of the P4 line is green** (`e1e3402`, on top of L1 `0af15f0`, L2
`7d42ced`, L3 `5506b8f`): the two tail theorems of the rigorous P4
statement,

- `p4_op2c_bound` — |∫_{n..∞} B̂₂(x)·x^{−s−2} dx| ≤ √3/270 · ‖s+2‖ ·
  n^{−5/2} (|s.re| = 1/2), proven by a **per-period integration by parts**
  with the cubic period-1 extension `B3poly` of `B3` (periodicity from
  the Bernoulli-3 identity, `B3poly(0)=B3poly(1)=0` kills the boundary
  terms on every `[k, k+1]`, and `∫_0^1 B2 u · B3poly' du =
  B3poly(1) − B3poly(0)` closed by `ring` — the identity B2 = B3'/3 is
  what supplies the factor 1/3);
- `p4_f2_tail_bound` — ‖∫_{n..∞} f̂″_{≥n}‖ = ‖s(s+1)‖ · ‖∫ B̂₂ x·x^{−s−2}‖
  ≤ ‖s(s+1)‖ · √3/270 · ‖s+2‖ · n^{−5/2}, via `integral_congr_ae` +
  `integral_smul`, the FTC for the `x^{−7/2}` integral (antiderivative
  `−(2/5)·x^{−5/2}`, derivative bridge closed by `ring` on the rpow atom).

**The constant, computed (the P4 numeric rule), and one wall of the
numeric itself.** The final constant comes from the per-period IBP route:
the factor 1/3 (B2 = B3'/3) times max `|B3poly|` = √3/36 (at
u = (3±√3)/6, exact) times `∫_n^∞ x^{−(s.re+3)} dx` = (2/5)·n^{−5/2}
— pure multiplication, `(1/3)·(√3/36)·(2/5) = 2√3/540 = √3/270`, i.e.
**√3/270 · ‖s+2‖ · n^{−5/2}**, with no slack anywhere.

Two numeric findings, both recorded as they actually are:

1. **A false alarm, corrected.** Early in the day a direct
   `mp.quad(integrand, [n, ∞])` evaluation of the B̂₂-kernel tail
   appeared to violate the draft constant √3/108 at large n
   (ratios up to ~9). Cross-checking with two independent reliable routes
   — (a) an infinite quad of the IBP-transformed integrand B̂₃·x^{−s−3}
   and (b) a per-period chunked quad sum with an analytic
   max-kernel tail correction — agreed with each other to <1% and were
   **5.4× smaller** than the direct-route value. The direct
   infinite-quad over the periodic kernel is the broken number; the
   corrected 35-point grid (t ∈ {0,1,2,5,10}, n ∈ {1,2,3,5,10,21,50},
   overestimated tail) gives **0/35 violations for BOTH constants**,
   worst ratios **LHS/(C108·|s+2|·n^{−5/2}) = 0.341** and
   **LHS/(C270·|s+2|·n^{−5/2}) = 0.853**. Conclusion: the draft
   constant √3/108 was **not** refuted — it simply has ~3× more slack;
   the adopted √3/270 is the sharp one the IBP route produces exactly.
   Lesson (filed): never let a single numeric integrator's verdict kill
   or bless a formal constant; cross-route agreement first.
2. The formal √3/270 theorem is consistent with the corrected numerics
   (worst observed usage 0.853 < 1), as expected since the Lean proof
   is the exact arithmetic of the IBP route.

**Transferable Lean lessons (pinned in the P4Limit header):**

1. `HasDerivAt.comp` in 4.33.1 takes the point as an explicit **first**
   argument: `HasDerivAt.comp x hh₂ hh`.
2. `ContinuousOn.intervalIntegrable` takes **no** endpoint arguments.
3. `uIcc`'s lower bound is `min a b` — bridge with `min_eq_left` before
   `nlinarith`.
4. `tendsto_order` unpacks `Tendsto f l (𝓝 a)` into the two one-sided
   eventual inequalities; and `le_of_tendsto (lim) (h : ∀ᶠ c, f c ≤ b) :
   a ≤ b` takes an eventual upper bound straight to the limit — the
   by_contra + `filter_upwards` dance is unnecessary (and
   `filter_upwards` does not work on a goal of `False` anyway; it needs a
   π-goal).
5. `∀ᶠ` is a Prop, not a structure: no `.imp` dot; compose with
   `filter_upwards [h1, h2] with x h1 h2`.
6. `Nat.cast_pos`'s algebra argument is `α` — spell `(α := ℝ)` or the
   instance search sticks.
7. `ring` closes coefficient identities with rpow atoms
   (`−(2/5)·(−5/2)·x^{−7/2} = x^{−7/2}`) — treat the rpow as a monomial
   atom.

Full repo build green (0 errors); all four runtime gates PASS. P4Limit
now holds L1+L2+L3+L4; the remaining P4 layer is L5 (assemble the P4
statement `|W_n(t)| ≤ B_n(t)` from the atoms).

## 8. L5 GREEN — the P4 line composes: identity at Re s > 1, bound at Re s = 1/2 (2026-09-15)

One composition atom at a time (owner's one-at-a-time rule), each built
green before the next:

- **L5.a `p4_Tn_Tendsto`** (816d77f): the M→∞ limit of the tail partial
  sums `∑_{n<k≤m} k^{−s}` is the closed constant `p4_Tn_lim` — endpoint
  terms + the bare f″ kernel tail. Built on L3's `p4_kernel_tendsto` +
  `tendsto_rpow_neg_atTop` for `x ↔ x^{−s−1}` on ℕ.
- **L5.b `p4_zeta_split`**: the 1-indexed split
  `riemannZeta s = ∑_{0≤k<n} 1/(k+1)^{-s} + ∑_{k≥n} 1/(k+1)^{-s}` via
  `zeta_eq_tsum_one_div_nat_add_one_cpow` (avoids the `0^s` singularity of
  `zeta_eq_tsum_one_div_nat_cpow`) + `Complex.summable_one_div_nat_cpow`
  + `Summable.sum_add_tsum_nat_add'`.
- **L5.c `p4_Tn_eq`**: the second tsum = `∑_{0≤k<n} k^{−s} +
  p4_Tn_lim s n` — `Summable.tendsto_sum_tsum_nat` (tail partial sums →
  tsum, with the L5.a `congr'` for eventual equality) + L2's finite EM
  law `em2_finite` on every prefix + `FunLike.funext` to absorb the
  `fun i => (i:ℝ)` cast.
- **L5.d `p4_identity`** — **the P4 line-statement, machine-proven for
  Re s > 1**: `riemannZeta s − P_n s + I(n,s) = p4_em_expr s n`, where
  `p4_em_expr := −½n^{−s} + (s/12)n^{−s−1} − ½∫_n^∞ B̂₂({x})·f″(x)dx`
  (kernel form; `f″` = `p4_f2` = `s(s+1)x^{−s−2}`, so the explicit
  `s(s+1)` form is a one-line simp corollary). Assembly: L5.b + L5.c +
  `norm_cast` on the single-cast/natural-cast complex powers + `ring`.
- **L5.e `p4_T4_bound`** — **the P4 bound at Re s = ½**:
  `‖p4_em_expr s n‖ ≤ ½n^{−1/2} + (‖s‖/12)n^{−3/2} + (√3/540)·
  ‖s(s+1)(s+2)‖·n^{−5/2}` — triangle inequality on the three display
  terms; the kernel term is L4.4 (`p4_f2_tail_bound`, sharp √3/270) with
  the leading ½. The equality `W_n = p4_em_expr` **at Re s = ½ itself**
  is CITED (DLMF 25.2.8 / Apostol Thm 12.21: both sides agree on
  Re s > 1 by L5.d and are analytic on {Re s > −1}\{−1,−2}); the bound
  on the EM expression is fully Lean-proven there.

Honest split, documented in `P4Limit.lean`'s L5 header: Lean proves the
identity on Re s > 1 and the bound on the expression at Re s = ½; the
bridge at the critical line is the published EM extension (cited).

New tooling pins: `zeta_eq_tsum_one_div_nat_add_one_cpow`,
`Summable.sum_add_tsum_nat_add'`, `Summable.tendsto_sum_tsum_nat`,
`summable_nat_add_iff`, `tendsto_nhds_unique`, `Filter.Tendsto.congr'`
(set-valued eventual-equality congruence), `Finset.sum_range_add` +
`Finset.sum_union` for the range↔Ioc bridge, `Complex.one_re`,
`Complex.norm_cpow_eq_rpow_re_of_pos` (after the single-cast bridge
`(n : ℂ) = ((n : ℝ) : ℂ)`), `norm_sub_le`, `norm_add_le`, `le_rfl` as a
calc-closer.

Full repo build GREEN (0 errors, 17426 jobs); gates A-D PASS.

## 9. L5.f GREEN — the T4 ratio corollary (2026-09-15)

`p4_one_minus_s_conj`: on the critical line Re s = ½, `1 − s = star s`
(conj-re/im via `Complex.conj_re`/`conj_im`, which plain `simp` applies
even though `rw`/`simp only` cannot match their `starRingEnd` pattern).
Hence the correction scale |I| = n^{1/2}/|1−s| simplifies to
n^{1/2}/|s|.

`p4_T4_ratio`: the three-term ratio bound
‖em_expr‖·|1−s|·n^{−1/2} ≤ (‖s‖/2)n^{−1} + (‖s‖²/12)n^{−2} +
(√3/540)‖s‖·‖s(s+1)(s+2)‖n^{−3} — p4_T4_bound multiplied by
|1−s|·n^{−1/2} = |s|·n^{−1/2}, with the rpow products (−1/2)+(−k/2)
via `Real.rpow_add ←`.

Honesty note: the module sketch's draft T4 line in (t²+¼)(|s|+1) form
was checked and is WRONG for large t (fails at t = 10); the exact
product form above is what holds for every t, and is what the measured
15-point table (0.0500 … 1.0620) is checked against (P4Float gate).

New pins/lessons: `|·|` (abs) notation fails on ℂ with "Lattice ℂ" —
use `‖·‖`; plain `simp` (not `simp only`) is needed for
`Complex.conj_re`/`conj_im`; `ring_nf` keeps `x^2` as a power (does not
expand to `x·x`) — `simp only [pow_two]` first; `rw [h1, …, hn]` skips
non-matching entries (order matters for failure reporting); `‖s(s+1)(s+2)‖`
gets its interior expanded to `‖s·2 + s²·3 + s³‖` under `ring_nf` — both
sides expand, so the final `ring` closes.

Full repo build GREEN (17426 jobs, 0 errors); gates A-D PASS. The P4Limit
module (all of L1-L5) is now complete: the P4 missing-tail line — exact
law on Re s > 1, bound + ratio corollary at Re s = ½ — is machine-proven.

## 10. P8Floor module GREEN through A4.1 — the residual-floor line (2026-09-16)

Route A of the §10 residual floor, formalized in `formal/RhAttack/P8Floor.lean`
from the spec `kainos-logos/.../spec/p8floor-routeA-abstract.md`. Seven green
commits, one per atom: `18f9b2e` (A0+A1), `7c07343` (A2a), `775174b` (A2b.1),
`4d4a5d5` (A2b.2), `d571f70` (A3.1+A3.2a), `ef1aff1` (A3.2b.1), `63fdae8`
(A4.1).

**What is machine-proven (LEAN-PROVEN):**
- A0+A1: the same-object reduction — the outline's LHS
  `|W_n(t) − [K_on(t) − (P_n − I)]|` is EXACTLY `‖δK‖ + bridge residual +
  floor` under `p8_triangle` (reverse triangle via `norm_sub_le`); `p4_Wn`
  fixes the definition-side W_n so no ζ appears anywhere.
- A2a: `p8_B_floor` — the three-term P4 floor at s = ½+it is literally
  `p4_T4_bound` (half-critical-line instantiation).
- A2b: `p8_residual_exact` factors the bridge residual
  `e^{Tt}·∏_L F − ∏_{L∪T} F = ∏_{L∪T} F·(e^{Tt − Σ_T ln F} − 1)` (B3
  `b3ResidualDecomp` + ring); `p8_abs_exp_sub_one_le` proves
  `|e^x − 1| ≤ e^{|x|}·|x|` with a BOTH-sign analysis built on
  `add_one_lt_exp` (`x ≠ 0 → x+1 < e^x`) + `one_le_exp` — no MVT (the MVT
  route's resolution friction: `hasDerivAt_exp` ambiguity,
  `differentiableAt` vs `differentiableWithinAt`, `div_mul_cancel` arg
  order — abandoned cleanly); `p8_residual_bound` then makes the residual
  the product's own mass × a function of the ONE model-defect number
  x := Tt − Σ_T ln F. Zeta-free, counting-free.
- A3: `p8_noff_delta_min` — B5's off-line numerator
  `((t−γ)²+δ²)((t+γ)²+δ²) = (t²−γ²)² + 2δ²(t²+γ²) + δ⁴` (all
  coefficients ≥ 0) is δ-monotone, minimized at δ = 0 — no dead δ window;
  `p8_detector_abs_lower` — reverse triangle (`abs_dist_sub_le R 1 0`)
  routes `‖R − 1‖ ≥ |‖R‖ − 1|` into B5 `b5Abs`' closed magnitude;
  `p8_pref_omega_zero` / `p8_detector_norm_at_zero` — at δ = 0 the closed
  form collapses to explicit numbers (pref = (γ²−t²)/(¼+γ²), ω₀ =
  1/(¼+γ²), ‖R(0)‖ = |γ²−t²|/(¼+γ²)·e^{ω₀/2}) — the far-regime seeds.
- A4.1: far regime, γ ≥ 1, t ≥ 2γ: `‖R(γ,0,t)‖ ≥ 2` and hence
  `‖R − 1‖ ≥ 1` — the zero-decision inequality (outline §7: floor +
  residual < detector) reduces there to bounding floor + residual below 1.

**Honest split (per the honesty rule):**
- The W_n = EM-expression equality AT Re s = ½: CITED (DLMF 25.2.8 /
  Apostol 12.21) — same split as P4Limit L5.e.
- The NEAR-regime detector floor (t ≈ γ, the branch locus excluded from
  B5's closed form at t = γ): PINNED by the day-017/019 near-regime audit
  (0.9975 – 1.0201 across the grid; margin ≥ 14× at the pair's own
  height) — A4.2 is the next atom and will state this as a
  measurement-pinned constant.
- The M(G,t) wire (B3Sbar `b3BoundExplicit` composition into the residual
  chain): next after A4.2.

**New 4.33.1 pins/lessons:** `mul_lt_mul_of_pos` in this mathlib is the
4-argument 2-sided form (a<b, c<d, 0<a, 0<d) — single-sided lemmas are
`mul_lt_mul_of_pos_left`/`_right`; `abs_dist_sub_le (x y z) :
|dist x z − dist y z| ≤ dist x y`; `div_le_div_iff₀ hb hd` (field form; the
Unbundled `div_le_div_iff_right` needs `Group`, which ℝ's multiplicative
monoid is not); `le_div_iff₀`; `abs_div (a b)` takes ELEMENT args (no proof,
field default); `mul_eq_zero : (a·b = 0) ↔ …` — use `.mp`; `sq_lt_sq` is
an IFF (nlinarith squares positive atoms instead); `show E, from P` and
`show E := by P` are UNPARSEABLE in 4.33.1 in tactic lists and as terms —
annotated by-terms `(by t : E)` or named haves only; CJK brackets 〈〉
(U+3008/9) vs Lean angle brackets ⟨⟩ (U+27E8/9) keep getting confused —
`obtain ⟨a, b, c⟩ := …` needs the latter; a bare `calc` step whose LHS
carries a `·1` factor needs `simpa [mul_one]`; calc mixing one strict `<`
step makes the whole calc's type strict — promote to `le_of_lt` first.

Full-repo build GREEN (17428 jobs, 0 errors); zero `sorry`/`admit` in
P8Floor; B5-CORE CHECK PASS (worst 5.978e-26); rhattack smoke exe: E7a /
B-4 / B-5 / B-3 all CROSS-CHECK PASS.

## 11. P8Floor completes — A4.2 + A4.3, module (A0-A4) green (2026-09-16)

Two atoms close the line (commits `04a633d`, `1d8e68f`):

**A4.2 — the decision under the pinned floors.** `p8_f_near_pin := 0.9975`
stated as the *measurement-pinned* near-regime floor (day-017/019 audit
grid: |t−γ| ≤ 10.21, δ ∈ {0.005, 0.5}, measured 0.997500–1.020104) —
explicitly NOT a Lean-proven bound (the audit is its authority);
`p8_f_far_floor := 1` (the A4.1b LEAN-PROVEN far floor); and
`p8_zero_decision_far`: outline §10's decision inequality in symbolic
form — `p8_B t n + Mval < ‖R(γ,0,t) − 1‖` for γ ≥ 1, t ≥ 2g whenever
floor + P5-mass < 1 (`lt_of_lt_of_le` over A4.1b).

**A4.3 — the M(G,t) wire (P5 side live).** `p8_residual_wired`: given
the model-defect bound `|x| ≤ Xval` (Xval = the B3Sbar
`b3BoundExplicit` RHS `Bf t G·(Sbar B + Sbar G) + Cf t G·Kbar G` at the
measurement point, wired as an explicit hypothesis per the honesty
rule), the bridge residual `e^{Tt}∏_L F − ∏_{L∪T} F` is
`mass·e^Xval·Xval`. Two `gcongr` steps (exp monotone + nonnegativity of
mass and |x|).

**Module composition (header now carries it):** the §10 LHS splits by
A1 into ‖W_n‖ + ‖K − (P_n − I)‖; side 1 = p8_B (A2a, P4Limit L5 bound
at ½+it); side 2 = mass·e^Xval·Xval (A2b + A4.3 + Sbar); the RHS
detector routed through B5 closed forms (A3), far floor 1 (A4.1,
LEAN-PROVEN), near floor 0.9975 (A4.2, PINNED). The statement holds
pointwise wherever floor + mass sit below the regime floor.

New lessons: bare `gcongr` in 4.33.1 auto-discharges core + side goals
from local context — bullets cause "No goals to be solved"; quoted
heredocs carry `\uXXXX` VERBATIM into Lean (use literal UTF-8 or a
python pass after); a python `s[:i]` slice before writing truncated the
A4.3 block once (caught by re-reading the file tail before committing —
verify after every slice-based rewrite).

Full-repo build GREEN (17428 jobs); zero sorry/admit; B5-CORE CHECK
PASS; gate smoke all PASS.

## 12. Xval pin — the concrete M(G,t) constant at the measurement point (2026-09-16)

`scripts/rh/day020_xval_pin.py` (record: `scripts/rh/out_day020_xval_pin.txt`)
pins the A4.3 hypothesis `|x| <= Xval` at the audit measurement point
(t = 1000.041572, band (G, B] = (2t, 10^5] = (2000.083144, 100000],
certified zero list <= 10^5, day-014 record). Model functions copied
line-for-line from `B3Core.lean` (no-recall rule), dps-30:

    actual sum (136,548 factors fT)   = -543.74112770383...
    Tt (quadrature of nHat . fT)      = -543.72187385967...
    x = Tt - sum                      = 0.019253844165493...
    Xval = Bf(Sbar B + Sbar G) + Cf.Kbar
         = 0.3335835312 (3.7143 + 4.2650) + 2.66689e5 . 4.8925e-7
         = 3.9665418656908...
    MARGIN = Xval / |x| = 206.0x        -> PASS
    hS premise at G: |NList - NHat| = 0.0693 <= Sbar G = 3.7143  -> PASS
    hS premise at B: |NList - NHat| = 3.5584 <= Sbar B = 4.2650  -> PASS

So at the measurement point the P8Floor A4.3 wire runs with the
concrete pinned constant Xval = 3.9665418656908 (margin 206x), and
the b3BoundExplicit hypothesis hS is verified at both band endpoints
against the certified list. The residual at this height is then
bounded by mass . e^3.9665 . 3.9665 — while the D3 measured LHS
(|zeta - K_on|) at the same height is 6.43e-05 (d4d3 record) and the
near-regime detector floor is the pinned 0.9975 . |K| — the route-A
decision holds at the measurement point with the full pinned-constant
chain. (The cross-band worst case, e.g. the t = 980 residual spike
2.465e-02 vs the detector there, needs the <= 3e5 list — queued.)

## 13. Cross-band worst-case audit — route A HOLDS, min margin >= 112x (2026-09-16)

`scripts/rh/day020_worstcase.py` (record: `scripts/rh/out_day020_worstcase.txt`)
scans the queued cross-band question. Provenance: functions copied
verbatim from the d4 generator (day009c blob 63ea96d5, per its header);
certified list <= 3e5 (466,655 zeros); dps-15; closed-form R (P3/B5,
Lean-proven) spot-checked against the direct 4-zero definition at each
candidate (|diff| ~ 1e-16, matching the P3 5e-4 class record).

Setup (the S8 pairing, made explicit): for each candidate pair height
g (an ACTUAL zero height), on the straddle window t in [g-12, g+12]
(step 0.5), the pointwise route-A decision is
    resid(t) = |zeta(1/2+it) - K_on(t)|   (S10 LHS; A0: zeta - K_on)
    dev(t)   = |K_on(t)| * min_{d in {0.005..0.5}} |R(g,d,t) - 1|
    margin(t) = dev / resid.

Results (overall worst in bracket):
    g = 999.791572 (the d4 pair):  worst t = 1006.7916  resid = 0.0817  dev = 9.20  margin = 112.6
    g = 980.578001 (queued t=980 cross-band):  WORST t = 978.578  resid = 0.0164  dev = 1.95  margin = 118.6
    g = 1019.912440:  worst t = 1016.9124  margin = 122.0
    g = 1040.264038:  worst t = 1041.264  margin = 116.5
    OVERALL: min margin = 112.6, decision HOLDS on every scanned window.

Key finding: the apparent sub-1 margin at t = 1009.79 in the d4 record
(dev 0.0324 vs resid 0.0627) is the WRONG pairing — it uses the d4 pair
(g = 999.79) at an evaluation height 10.2 units away, where |K| is small
near a foreign zero. The S8 closure compares at the candidate pair's
OWN height with its OWN pair; under that pairing the min margin is >= 112x
across [968.6, 1052.3]. The queued t = 980 spike (resid 2.465e-2 in the
D3 scan) is dominated ~120x at g = 980.58.

d_min pin (S10, Route A's price): min over the measured grid edges
d >= 0.005 — the floor is d-independent (P4 limit law) and the detector
has no dead d window (P3: numerator a positive polynomial in d^2), so
the measured lower edge d_min = 0.005 is the operative threshold.

## 14. P9 Closure module GREEN — the §8 conditional closure (2026-09-16, goal turn)

The next outline gap after P8 (spec: kainos-logos
`plan/40-prize-islands/rh-attack/spec/closure-module-abstract.md`) is
the §8 closure itself. New module `formal/RhAttack/Closure.lean`
(P9), registered at `RhAttack.lean`. Full build GREEN (17430 jobs,
0 errors, 0 sorry); B5-CORE CHECK PASS; rhattack smoke all PASS.

Atoms (all machine-proven under the explicit measurement input):
  - Pins: `p9_f_pin = 0.9975` (the near-regime detector floor,
    day-010 d4d3 audit: |R−1| = 0.997500…1.020104 across d = 0.005
    … 0.5 on |t−g| ≤ 10; closed form vs direct 4-zero to ~1e-16 in
    the §13 run), `p9_d_min = 0.005` (the measured d-grid edge —
    Route A's price; the floor is d-independent and the detector has
    no dead-d window), `p9_margin_min = 112.6`, `p9_m_pin = 1/112.6`
    (the §13 worstcase audit minimum margin; note: `p9_m_pin` is a
    `noncomputable def` — ℝ division — a 4.33.1 gate to know).
  - C1-far `p9_far_detector_ge_pin`: far regime (γ ≥ 1, t ≥ 2γ)
    ‖R(γ,0,t)−1‖ ≥ f_pin — restated from P8Floor A4.1b (≥ 1 ≥
    f_pin). The near/own-regime half stays PINNED; its promotion to a
    Lean theorem is the open atom C1b (the branch-locus d,t
    two-variable minimum of |R−1|) — the remaining "Route A's price".
  - C5 `p9_point_contradiction`: the arithmetic squeeze — Q ≥ dev −
    Mf (bridge + detector, ≥ side), dev ≥ flo, Q ≤ Bfloor + Mr
    (P8Floor definition side, < side), Bfloor + Mr + Mf < flo → the
    point is empty. Pure `linarith`.
  - C0 `p9_min_offline_height`: over B0's structural ZeroSet (HNR/
    HCJ/HFIN — no counting value enters), an off-line zero exists
    iff a MINIMUM positive off-line pair height t0 exists, with an
    off-line zero at exactly t0 and every off-line zero height ≥ t0.
    Technique: positive-height representative (conjugation, the B0
    RH_of_zeroD idiom), the finite slice as an explicit `set … with`
    equation (local `let`s are opaque to the checker — the B5
    lesson), membership iff's by `simpa [Finite.mem_toFinset,
    Set.mem_inter_iff]`, then the Finset.image of the heights and
    `Finset.isLeast_min'` (4.33.1 shape: `min'_le`/`min'_mem` take
    (s, proof-of-nonempty) as EXPLICIT arguments in that order; the
    `IsLeast`/`lowerBounds` route gives the minimum inequality for
    the SAME nonempty proof — the subtype-instance `min' ⟨x, hx⟩`
    form is a different noncomputable `inf'` value and does not `rfl`
    against the `H`-instance).
  - C5b `p9_closure_rh_of_margin`: the §8 closure. RH fails ⇒
    (C0) a minimal off-line pair (t0, d0) exists ⇒ the squeezed
    margin hypothesis at (t0, d0) (its six real witnesses ARE the
    pinned/cited constants: the bridge-tail bound Mf, the detector
    floor flo, the definition-side floor Bfloor + Mr) ⇒ C5 empty ⇒
    contradiction ⇒ RH. Counting-free per §8's own words: only the
    structural ZeroSet interface and the explicit measurement input
    enter.

Honest split: C0/C5/C5b/C1-far LEAN-PROVEN (C5b under the explicit
hmargin — the module does not assume the measurements inside Lean);
the near-regime detector floor PINNED (C1b OPEN). The composition is
conditional by design: instantiating hmargin with the pinned
constants (f_pin, d_min, m_pin + the P8Floor A4/Xval wires) is the
day-020 numerical verification, and C1b is the remaining analysis
price.

## 15. C1a — the branch locus IS the pole: the own-height detector facts GREEN (2026-09-16/17, after the P9 module went green)

**Setup.** The P9 closure (section 14) left one priced item: the
detector floor at the candidate pair's own height (the "own regime"),
recorded as PINNED (0.9975, day-010 d4d3 straddle audit). The closure
itself — C5b — evaluates the squeezed margin exactly at the MINIMAL
off-line pair height t0 = g. So the question sharpens: what is the
detector AT t = g, not just near g?

**Finding (day021_c1b_worstpoint.py, scripts/rh/out_day021_c1b_worst.txt).**
The ratio R(g, d, t) has a POLE at t = g: the on-line pair's 25.2.12
factor (1 − (s/ρ + ρ/s)/2) vanishes at s = ρ (its own point), so
pairProd(g, g) = 0 while all four off-line factors remain nonzero for
0 < d < 1/2 (their real parts are 1/2 ± d, δ, 1/2 ∓ δ, all > 0 at
t = g). The kernel change the zero side of the contradiction carries
at own height is therefore the off-line product mass poff(g, d, g) —
a finite, nonzero, POSITIVE-constant factor times the bridge exp. The
window-floor scan (the audit's original target) shows the rest:
|R| crosses |R| = 1 with phase jump π (a unit-circle crossing = a
sign flip of Re(R − 1)) on |t − g| ≲ O(1/γ), the worst |R − 1| dips
scale ~ 1/γ (measured: ~1/γ·0.06–0.11 at γ ≈ 1000 with δ = 0.005–
0.02, worst δ = 0.06 at γ = 129.98) — i.e. the t ≠ g window is
well-behaved but NOT the closure's evaluation point.

**Lean (C1a, RhAttack/Closure.lean, all 7 atoms LEAN-PROVEN,
deterministic tactics only).**
  p9_fac_self_zero            — (1 − 2·(z/z)/2)·e¹ = 0 (div_self)
  p9_pairProd_at_own_height   — pairProd γ γ = 0 (ρ ≠ 0; Re(ρ) = 1/2 > 0)
  p9_fac_ne_zero_of_ne        — fac ρ s ≠ 0 iff s ≠ ρ, ρ ≠ 0 (field_simp)
  p9_poff_own_height_nz_full  — poff γ δ γ ≠ 0 for 0 < δ < 1/2 (the four
                                factors: Re = 1/2 ± δ / δ nonzero; s ≠ ρᵢ
                                by the add_right_inj/lt_irrefl route)
  p9_kernel_change_at_own_height — poff − pairProd = poff ≠ 0 (exact)
  p9_detector_at_own_height   — ‖poff − pairProd‖ = ‖poff‖ (simp)
  p9_poff_own_height_pos      — 0 < ‖poff γ δ γ‖ (norm_pos_iff)

**Consequence for the §8 closure.** The "0.998 at own height" line of
the outline is not a floor at all — it is the pole: the ≥ side at t0
is exact and its mass is strictly positive. The PINNED 0.9975 window
floor remains an honest recorded audit of the t ≠ g regime (its C1b
promotion — the branch-locus d,t two-variable minimum of |R − 1| —
is now OPTIONAL for the closure; the pin is a conservative statement
about window behavior the closure does not need). The conditional
closure stays conditional only on its measurement inputs (margins),
as designed; no detector-side pin is on the critical path anymore.

**Toolchain pin (Lean 4.33.1).** Hit a NONDETERMINISTIC linarith
failure while proving the C1a factor lemmas: "synthetic hole has
already been defined" (termElabSyntheticMVar, the lt_irrefl route),
same file failing once then passing repeatedly; a micro-probe
isolated it to linarith on equality goals with strict hypotheses in
the context (ring on the same identity is fine). Online search
(2026-09-13) found no published mathlib4 issue with this exact trace
(general synthetic-hole / congr hole-hogging threads only).
Workaround adopted: the C1a section uses deterministic tactics only
(simp/rw/norm_num/field_simp/add_right_inj/lt_irrefl) and keeps
1/2 out of the decision procedures. Recorded here so a future
commit does not reintroduce a flaky linarith.

## 16. C6 — the audit-point margin wire: §8 at the audit point is one statement (2026-09-17)

**Goal.** C5b (`p9_closure_rh_of_margin`) closes §8 under the
explicit hmargin hypothesis.  The remaining work was to NAME the
audit-point instantiation: which measurement facts, in which form,
make hmargin at the audit point hold.

**Spec.** `kainos-logos/.../spec/c6-margin-wire-abstract.md`.

**The audit package (formulas from scripts/rh/day020_worstcase.py).**
At each candidate pair height g and scan height t:
  resid(t) = |zeta(1/2+it) - K_on(t)|     (= Q, the S10 LHS, A0
                                              same-object)
  dev(t)   = |K_on(t)| * min_d |R(g,d,t)-1| (kernel change, S7
                                              detector)
  MARGIN(t) = dev/resid                    (record: worst 112.6 over
                                             4 candidate pairs x
                                             straddle windows)
The hmargin witness tuple is (Q, dev, flo := dev, Mf, Bf, Mr), so
the per-point package is exactly three measurement facts:
  hZero   Q >= dev - Mf      (zero side: bridge S6 + detector S7;
                              the CITED identity zeta = K_on *
                              kernel (DLMF 25.2.12) + measured
                              reduction — day-010 d4d3 / day-020)
  hDef    Q <= Bf + Mr       (measured resid below the A4.3-wired
                              bound at the Xval pin — out_day020_
                              xval_pin.txt, 206x headroom)
  hStrict Bf + Mr + Mf < dev (the audited strict gap — the 112.6x
                              margin is this inequality in point
                              form)

**Lean (RhAttack/Closure.lean, C6, both atoms LEAN-PROVEN).**
  C6.1 p9_audited_package_strict — the package packs into the
    hmargin witness tuple: (Q, dev, dev, Mf, Bf, Mr) with hZero,
    le_rfl (dev >= dev), hDef, hStrict.  Six-line term; the value is
    the NAMED interface between the audit and the closure.
  C6.2 p9_closure_at_audit_point — the TOTAL composition:
    RH q  from  (per off-line pair (t0,d0), the three fact package),
    body = p9_closure_rh_of_margin q (hmargin := C6.1 o hAudit).
    One line; the content is the statement itself: §8 at the audit
    point, no unnamed hypothesis.

**Where the §8 argument stands (honest split, final).**
  Machine-proven: C0 minimality, C5 squeeze, C5b closure, C1-far,
  C1a (the own-height pole + positive mass), C6.1/C6.2 composition,
  P8Floor A0-A4 (definition side), P4Limit L1-L5, B0/B2/B3/B4/B5.
  PINNED per point (script + record, computed never recalled):
    hZero  — the zero-side measurement (day-010 d4d3 + day-020)
    hDef   — the resid-vs-wired-bound measurement at Xval (xval pin)
    hStrict — the 112.6x strict-gap measurement (worstcase record)
  CITED: the bridge identity (DLMF 25.2.12); W_n = EM-expression at
  Re s = 1/2 (DLMF 25.2.8 / Apostol 12.21); Sbar/M(G,t) Platt-
  Trudguan.  OPTIONAL: C1b (the t != g window floor promotion).
The full build is 17430 jobs, 0 errors, 0 sorry; B5-CORE CHECK
PASS; the rhattack smoke PASSes; probe deleted.

## 17. C7 — the record arithmetic, machine-verified (2026-09-17)

The two closing records carry arithmetic claims computed from
printed point values; C7 makes those claims exact-rational
machine-checked facts (norm_num; the printed decimals are exact
rationals) — "computed, never recalled" now extends from the
measurement to the verification of the measurement's own arithmetic:

  p9_worstcase_record_margin : 9.198 >= 112.6 * 0.08168
    (out_day020_worstcase.txt, overall worst point t = 1006.7916,
     pair g = 999.791572; the closing number 112.6 re-verifies
     from the printed resid/dev)
  p9_xval_record_headroom : 3.9665418656908 >= 206 * 0.019253844165493
    (out_day020_xval_pin.txt, t = 1000.041572, band
     (2000.083144, 10^5]; the 206x pin re-verifies at 15 digits)

Precision discipline: per-pair printed values (e.g. the 980 pair's
"118.6") can FAIL such re-verification at 4-significant-figure
print precision (1.949/0.01644 = 118.55...); only closing numbers
are machine-checked, and the closing number is the overall worst
case. If a future audit adds a new closing constant, its C7 check
travels with it.

RhAttack/Closure.lean C7 section; full build 17430 jobs 0 errors
0 sorry; B5-CORE PASS; smoke PASS; probe deleted.

## 18. The cross-band record: coverage to 10^5, the closing margin re-pins to 1.053 (2026-021 records)

**Why.** The C6 audit-point closure needs the per-point package at
the hypothetical minimal off-line pair — of arbitrary height.  The
day-020 record covered the t ~ 10^3 region (4 pairs, worst margin
112.6).  This step extends the band to its feasible ceiling and
characterizes the margin's dependence on t.

**The runs** (scripts `day022_worstcase_ext.py` family, records
`out_day022_worstcase_ext.txt`, `out_day022b_upperband.txt`,
`out_day022c_upperband.txt`, `out_day021b_weakspot.txt`; same
functions verbatim from day020, W = 12, 7-delta grid; the weak spot
refined to DT = 0.25 + 10-delta grid):

  candidate pair g (nearest actual zero)   worst-point margin
  -----------------------------------------  ------------------
  ~980/1000/1020/1040 (day-020, 4 pairs)     112.6 (t = 1006.79)
  2000.434515   87.39      2499.862043     73.07
  2999.494493   62.46      4000.017285     45.99
  5000.234317   34.68      7499.635017     19.09
  10000.065344  11.29      15000.008791    5.494
  20000.128166  3.325      29999.710030    1.756
  50000.406752  1.053 (CLOSING, t = 49990.656752,
                     resid = 65.91129441, dev = 69.40177926,
                     exact margin 1.05295731)
  100000 (pair 99999.700948)  2.269 (RECOVERY — resid =
                     0.03019; the LHS is oscillatory, the
                     envelope decays, the point values
                     fluctuate)

**Findings.**
  1. The pointwise decision resid < dev HOLDS at every scanned
     point up to t = 10^5 (15 candidate pairs, straddle windows,
     DT = 0.5, weak spot DT = 0.25).  No sub-1 point measured.
  2. The per-region worst margin erodes from 112.6 at 10^3 to the
     closing 1.053 at 5*10^4 — roughly C/t on the envelope — then
     the 10^5 window recovers to 2.269 (resid oscillatory; the
     decay is an envelope statement, not monotone).
  3. The weak spot is a REAL 1.05 plateau, not a grid artifact
     (refined grid confirms the same margin at a different t,
     49990.656752; resid/dev ~ 0.95 across the local neighborhood).
  4. The closing number RE-PINS: p9_margin_min 112.6 -> 1.0529
     (computed under-estimate of 1.05295731 — the printed 8-digit
     values re-verify only at the under-estimate; C7.3
     p9_weakspot_record_margin machine-checks it).  The t ~ 10^3
     value 112.6 survives as the region record (C7.1).

**Honest state of the S8 claim (updated).** Verified on the
measured band [~970, 10^5] at grid resolution for 15 candidate
pair heights. Remaining measurement price, stated: (i) g-space
gaps between the 15 candidate heights (a hypothetical pair at an
unscanned height has no package record at its own height); (ii)
bands below ~970 and beyond 10^5; (iii) the 5% margin at the weak
spot is within the grid-resolution comfort zone.  The Lean
composition (C0/C5/C5b/C1a/C6/C7) is unchanged by this step — it
consumes whatever the record says at each point.

Leaning: the re-pin is a DOCUMENTATION + pin change (p9_m_pin
follows); C7.3 added; full build 17430 jobs 0 errors 0 sorry;
B5-CORE PASS; smoke PASS.
# DISCOVERY_LOG — the chronicle

*Living document, 2026-09-10. This file chronicles the **approach** and
the **pieces we found along the way**, in the order they were found, and
how they combine. It does not track setbacks. It **does** track
important contradictions — disagreements between a measurement, an
expectation, or a recorded value, and how each was resolved. Every
number below traces to a certified output named in
`results/`, or to a labeled status (MEASURED / EXACT / IN-FLIGHT) in
the staged scaffold (`docs/`). New entries are appended in order; an
entry is written only when its evidence file lands.*

---

## 1. The approach

**RH is a question about the primes. The zeros are the side question.**

The classical view attacks the zeros directly (bounds for S(t),
density theorems…). We do the opposite: treat the **prime side** as
primary — the truncated prime data, the zeta value computed *from its
definition* (Riemann–Siegel), the partial sums, the integral — treat
all of it as computable at every height **without using any zero** —
and ask where, and at what size, the **zero content** must enter that
budget. RH then reduces to a counting statement (`D ≡ 0`, no off-line
pair at any height), and the whole program is: build an instrument
that certifies its own counts, measure the exact prime-side laws, find
the measurable point where zero content first enters, and show that
entry is *exactly* the Riemann-1859 zero product kernel.

The working method is the **four operations** on the approximation
(add / remove / duplicate / alter one term, one cell, one zero, one
height at a time), run on an instrument that is disciplined like a lab:
two engines must agree, every count is self-certified (twin-floor),
every constant is computed not recalled, every claim is labeled. The
owner's standing intuition — that **½ is the central object** (the
critical line, the half-term, the onset at ½·t = N, (−½)! = √π, the
power-tower half-attractor…) — enters as a *measurement target*: each
home of ½ is measured separately, and the unity claim stays labeled
INTERPRETATION (PLAN.md, P-G).

The pieces below are the findings, in order.

---

## 2. The pieces, as found

### 2.1 The self-certifying instrument (days 1–4)

A float64 zero-finding engine (dual dt-stacks + dps oracle spot
checks) that **certifies its own counts**: a count is accepted only if
two floor spacings agree (dt/dt2 twin-floor), and the count at each
certified height is spot-verified at high precision (2K parity, S
value, dps). **What it caught on its own:** one dead counting chunk in
~70,000 at the 10⁷ walk (a flat |S| ≈ 247 plateau where flips
stopped) — localized by S-*size*, not by parity, corrected as +246
flips, and the whole walk re-certified (`results/certified-zero-survey.md`).
This is the referee every later number is measured in front of.
**Crown jewel of the instrument:** a program that takes n and returns
the n-th non-trivial zero *by computation, not lookup* (dps-certified
bracket → twin-floor walk from a dps anchor → float bisection → dps
tail; first output γ₁₃₈₀₆₆ = 100000.74372338832472…,
`results/zero-finder.md`).

### 2.2 The missing-tail / width ladder (days 3–5)

Truncate the zeta series at n = N: the missing tail has an **exact
residue split** per Dirichlet cell (Hurwitz zeta per residue class).
Used as a *computation* (no asymptotic fitting) it yields, to 10⁻¹⁰:

- the edge law **D = −P** (the edge term is exactly minus the cell
  partial sum) on 18/18 phases at χ₅ and χ₁₃, 17/17 at χ₁₇;
- the **width (cell-moment) tables** M₁ — all rational: χ₅ in fifths
  {2/5, 2/5, −3/5, −3/5, 2/5}, χ₁₃ **all integers** (13 phases),
  χ₁₇ all integers to 1e-9;
- two structural laws at every odd-prime modulus measured:
  **M₁(r) = M₁(−r mod q)** (mirror) and **Σ_r M₁(r) = 0** (zero-sum
  trace); t-independence of M₁;
- a complex drift coefficient (3/5 + 2i/5)·(t/N) at the χ₅ r = 1
  rung, decay exponent −1.0005 ± 0.001, whose real and imaginary parts
  carry *different* phase-group moments — the first measured
  cross-phase coupling in a truncation ladder.

**The reading (labeled):** the Dirichlet tail is a **flat action** —
the exact part is cell data computable at every order, the remainder
is zero content. Universality of the ladder is then *by construction*
(a closed action cannot see zeros or t), which is what the ½
intuition is about on the prime side. (`results/width-ladder-tables.md`.)

### 2.3 The Euler action identity — E7a (day 6)

The finite summation-by-parts identity (README §Abstract):

```
Σ_{n=N+1}^{M} a(n)·n^{−s} = A(M)M^{−s} − A(N)N^{−s} + s ∫_N^M A(u)·u^{−s−1} du
```

holds **exactly** for every step path a(n), every s, every N < M;
verified at 50 digits on periodic and non-periodic paths (residuals
10⁻⁵¹–10⁻⁵³, `FORMULAS.md` §2.1). This is the bridge object: series
side, action side, and zero-side remainder all speak the same
language. Used as a *computer* it produced the E2-exact infinite-form
test (18/18 phases at 1e-10, zero fits). **2026-09-10: the identity is
now PROVEN in Lean** (any commutative ring, one-induction proof) with
a 5/5 independent float64 cross-check against the Python oracle
(worst deviation 2×10⁻¹⁴) — `formal/`, one-command
verifiable. A finite identity that was "measured exact" is now
"machine-checked exact".

### 2.4 The onset (days 4–5) — where zero content first enters

For the ζ tail (unbounded path, regularized), the measured
zero-oscillatory term C obeys, in the onset window,

**C/|I| = ½·(t/N)** — to **four digits**, **N-independent** across
N ∈ {10³, 10⁴, 10⁵}, first visible at **½·t = N** (the
unit-magnification configuration of the reciprocal lens). Beyond
t/N ≈ 2 the scaling changes regime (measured, in the width
ladder tables). Reading (labeled): ½·t = N is the moment the
zero-side interior action overtakes the edge (cell) action in the
missing-tail budget. The classic ½ of the Euler–Maclaurin half-term
is the same width object M₁ in the smooth-path slot — one ladder, two
entry points. (P-G in PLAN.md: the six measured homes of ½.)

### 2.5 Certified counterexample search (days 5–9) — and the 246

Certified, no-ghost results standing at v0:

- N(10⁵) = 138,065; N(3×10⁵) = 466,655 (GPU, dt/dt2 exact, gate
  6.5×10⁻¹⁰); N(10⁶) = 1,747,142; S(10⁵) = −2.558419306,
  S(10⁶) = −2.508632116 (40+ digits); 2K = −2 at 10⁶ (parity: even,
  no off-line pair); twin census 19 in (10⁵, 10⁶];
- **N(10⁷) = 21,136,123 — triple-certified** (dt/dt2-stable window
  227,197; corrected +246 chunk; dps-40 spot); S(10⁷) = −1.2057
  (O(1)); 2K(10⁷) = 0 at 2.25×10⁻⁹ (dps-40). One final redundancy
  re-walk was still in flight at the sync of this document
  (IN-FLIGHT — closes the last redundancy slot; no scaffold change).

The 246 itself is the instrument's design point made concrete: an
off-line pair (or a defect) is **invisible to the parity certificate**
(2K counts parity only) and is found by **S-size** instead. The
detector family the proof later needs (off-line ⇒ measurable
deviation) was *already in the pipeline*, proven on a real defect
before the zero-side theory existed. (`results/certified-zero-survey.md`.)

### 2.6 The 24-adic front/back — two cell classes, two laws (days 6–8)

The ladder was generalized past odd-prime quadratic cells:

- **τ₁₂** (the 2×4×3 multiplicative period-12 cell): exact M₁ table;
- **F₂₄** (the *non-multiplicative* period-24 cell from the
  Fibonacci ladder; cell sum 108, code-verified mean 9/2): the raw
  front/back split is mod-4 identical + a mod-3 slide; M₁ halves are
  **near-identity** (contrast: the multiplicative even cell τ₁₂ has
  the **antipode sign-flip** M₁(r+6) = −M₁(r) at 1e-10..1e-14);
  the F₂₄ cyclotomic pole sits at 9/2 (the "9/2 pole", measured, not
  conflation with τ₁₂'s structure — τ₁₂ and F₂₄ are different
  objects that both live near 24);
- the quadruple corner law 180°−720°/q and the multiplicative /
  non-multiplicative cell split.

The owner's 12/24 "front sweeps the front quadrants, back sweeps the
back" image was **measured**: the antipode law is real at 1e-10..1e-14
on the multiplicative cell; the 24-cell M₁ landscape is near-identity
rather than sign-flip. The unification ("3 units per quadrant in π")
did **not** become a load-bearing object: the side-quest was **sealed
v0.5–v0.7** after its measured parts passed — a boundary decision,
recorded here because the measurement stands while the interpretation
is deliberately left out of the proof path. (Contradiction log §3.2.)

### 2.7 The zero-side bridge — E7b Stage 1 (day 9)

Read the primary sources verbatim (Riemann 1859, p. 9; DLMF 25.2 /
25.4): the **product over zeros** is DLMF **25.2.12** —

```
ζ(s) = (2π)^s e^{−(1+γ_E/2)s} / (2(s−1)Γ(s/2+1)) · Π_ρ (1−s/ρ)·e^{s/ρ}
```

— with the analytic density tail appended. Two structural facts
measured: (i) on the critical line each conjugate **pair-factor is
exactly real** (the two principal arguments sum to a multiple of π;
atan2 constants cancel in-pair); (ii) the zero side reduces to a
float64-vectorizable sum (B-4: closed per-pair form, dps-25
unit-checked, cross-validated point-for-point against the certified
table by the vector re-run). **Stage 1 result:** the zero-side kernel
(over the certified 466,655-zero list + analytic tail) **reproduces
the measured 4-digit onset** — (N=10³, t/N=1): +0.29%; (N=10⁴,
t/N=0.1): −1.2%; two borderlines +4.2/+5.8%; the rest below the
quantified zero-side error floor (the density tail saturates once
G ≫ t). A prime-side law (computed without using zeros) is reproduced
by the zero side (which uses *only* the zero list + textbook
analysis), at the predicted heights, with 4-digit agreement and a
quantified error budget: the bridge is **real**, and its constants are
measured. (`spec/onset-bridge-e7b1.md`, `FORMULAS.md` E7b-1.)

### 2.8 The detector — off-line pair ⇒ forced deviation (day 10)

The G2 question (would an off-line zero be *detectable*?) answered in
two layers:

- **Exact core (B-5, v0.5):** replace one on-line pair in the 25.2.12
  kernel by an off-line pair at δ = β − ½ ≠ 0. The kernel-deviation
  ratio R = P_off4 / P_on2 has a **closed form from 4 lines of
  algebra** (real-signed prefactor × constant-rate phase; the only
  branch is the on-line prefactor's sign flip at t = γ; δ > 0 has a
  *no-zero-window*, its magnitude is a δ-polynomial with all-positive
  coefficients). Measured regimes, all 56 grid points: near resonance
  |R − 1| ≈ 1 (≥ 0.998); at twice the pair's height exactly 4.0000;
  in the far regime |R−1| = (t₀/γ*)² to 6 digits — the detector margin
  **grows quadratically** with height ratio. Verified dps-30, three
  levels (formula vs definition ≤ 6×10⁻²⁶; formula vs measurement ≤
  5×10⁻⁴ = the last printed digit).
- **Mechanism (settled, measured + structural):** an off-line
  4-tuple is **argumentically invisible on the central line** (its
  near-pair factor is real-negative, never zero ⇒ net phase 0.000
  across the straddle window, vs −π on-line) while the
  Riemann–von Mangoldt count *does* count it ⇒ **2K takes a +2 size
  step, parity is preserved, no flip**. The detector is therefore
  exactly the *S-size family that already found the 246* — the
  instrument built in §2.1 is the theorem's eye. Route-A
  signal-to-noise, measured against the fine local audit floor: ≥ 8.9×
  worst configuration, ≥ 14× at the pair's own height; in the
  relative form |ΔK|/|K| ≥ 0.998 uniformly, no audit floor needed.
  (`results/e7b1-detector-b5-core.md`, `docs/RH-PROOF-OUTLINE.md` B-5.)

### 2.9 The staged proof skeleton (day 10)

The pieces combine into a skeleton with numbered blanks
(`docs/RH-PROOF-OUTLINE.md`, v0.5):

**RH ⇔ D(t) ≡ 0** (B-0, a 2-line counting equivalence from classical
inputs) where D = N_total − N_on-line jumps by 2 at each off-line pair
height. The proof contains **two sides of one identity**: the
definition side (ζ from Riemann–Siegel, P_n, I, hence W(t) — no zero
input, computable ∀t) and the zero-side kernel 25.2.12 + tail. The
three propositions: (i) on-line ⇒ explicit dynamics (the measured
onset + exact pair form + rigorous tail — B-1, B-2, B-3, B-4 filled);
(ii) off-line ⇒ forced deviation (B-5, **core FILLED, exact**);
(iii) the ∀t closure — the one open wall, with three candidate routes
(A: prime-oracle + residual floor; B: uniform S/2K dynamics; C:
hybrid interim) and a written **decision rule on incoming data**
(D1 tail-saturation walk, D2 beyond-4-digit fits, D3 W-audit, D4
detector margin, D5 10⁷ redundancy — D4 all landed; D1, D5 in flight
at sync). The skeleton is explicitly **not a proof**: every step is
labeled, every blank names its data trigger, and the document states
what would kill it.

### 2.10 The formal instrument (days 10–11)

The reasoning tooling itself became part of the artifact:

- **kainos-logos store trained on the proof object:** a Prolog-style
  proof store discharged the skeleton's implications, ran the
  circularity query (**CLEAN** — no cycle touches the target; the
  "substitute the on-line zero set into ζ" knot is a mechanically
  checked property, not a discipline prayer), honored the invariant
  that `rh` stays status = hypothesis (**no `theorem:riemann`
  assertion exists anywhere**), and demonstrated the *drop-in*
  property four times (new data files appeared ⇒ corresponding
  assertions flipped candidate→established automatically, no module
  edited).
- **Lean 4 + Mathlib:** the E7a identity proven over any commutative
  ring; 5/5 oracle instances cross-checked by an independent Lean
  float64 pipeline (worst 2×10⁻¹⁴); `formal/` in this repo,
  one-command verifiable. The finite core of the proof is now an
  external, machine-auditable fact.
- **The B-4 pair identity joined the machine-checked core (same
  day):** the two DLMF-25.2.12 on-line factors for a certified zero
  height, `RhAttack/B4.lean` — T1: they collapse *exactly*, for all
  γ,t > 0 (even at the crossing t = γ), to a real signed prefactor
  times one exponential; T2: the log-magnitude in the ledger's
  verbatim form; T3: the additive phase exactly mod 2π — stated in
  the branch-cut-free circle type (no `atan2` principal-value
  machinery at all) and in ℝ with an explicit 2πℤ multiple. Cross-
  checked on the 16 recorded points inside Lean float64 (closed form
  vs direct fac product): 16/16, worst deviations ~10⁻¹⁴ — the
  predicted double-roundoff scale. What this means for the story:
  the per-pair content of the zero-side bridge — "the constants
  cancel in-pair, and the crossing is a sign flip, nothing else" —
  is now an external, machine-auditable fact, in the same package.

---

## 3. Important contradictions (recorded, resolved or standing)

By the owner's rule, setbacks are not logged here; contradictions are.

### 3.1 The ledger mis-attribution (DLMF 25.2.11 vs 25.2.12) — RESOLVED

The formula ledger carried "25.2.11 = product over zeros". The
verbatim read gate (raw TeX captured, committed) found **25.2.11 is
the Euler *prime* product**; the zero product is **25.2.12**. Corrected
in the ledger before any zero-side formula first used it. This is the
computed-not-recalled discipline working exactly as designed: a
recorded value disagreed with the primary source, and the primary
source won. (Also caught in the same read pass: the 25.11 Hurwitz
correction to the earlier on-line pair-factor note.)

### 3.2 The 12/24 front/back image vs the 24-cell measurements — SEALED, measurement kept

The owner's image (front 12 / back 12, "3 units per quadrant in π")
split under measurement: the **antipode sign-flip law is real**
(M₁(r+6) = −M₁(r) at 1e-10..1e-14, multiplicative cell) but the
non-multiplicative 24-cell (F₂₄) shows **near-identity** halves
instead of sign flip, and no 12/24 split of the π structure was
measured at the claimed strength. Resolution: the *measurements*
stand and are in the width tables (two cell classes, two laws —
genuinely informative); the *unifying interpretation* was sealed as a
closed side-quest (v0.5–v0.7) and is **excluded from the proof path**
deliberately. Important not because it was wrong, but because the
project demonstrated it can kill one of its own images on data — and
chose the measurement over the picture.

### 3.3 The 3-term trap (convergence vs truth) — RESOLVED, discipline written

A three-term fit of the χ₅ edge moment returned **7/5** with a
residual of 1e-9 — "converged" to the wrong value while the exact
table (no fitting involved) said **2/5**. Resolution: exact tables
only; the no-3-power-term-fits rule was written into P-0. This is the
one standing reminder in the store that *precision of a fit is not
truth of a value*; every width table in `results/` is fitted-or-not
labeled accordingly.

### 3.4 2K(10⁶) = −2 vs 2K(10⁷) = 0 — RESOLVED by the instrument

Not a contradiction once read, but a near-miss one that was caught:
the parity certificate is even at both heights, but the 10⁶ value
(−2) is the *un-corrected* count (2K counts flips mod 2: −2 ≡ 0),
while the 10⁷ walk carried the +246 defect correction and the
dps-40 2K = 0 at 2.25×10⁻⁹. Both are consistent with no off-line
content; the discrepancy is bookkeeping, logged with the defect
post-mortem in `results/certified-zero-survey.md`.

### 3.5 Standing tension (not resolved — this is the open problem)

**What is measured vs what is closed:** the prime-side law is
measured to 4 digits and N-independent; the zero side reproduces it
inside a quantified floor; the exact finite core is machine-checked;
the *∀t* closure (B-6, the (iii) proposition) is **open**, with its
candidate routes, margins, and decision rules written. The skeleton
is a scaffold with numbered blanks, not a proof; the repository claims
exactly what the labels say (README §What it does not claim) and no
more.

---

## 4. Where the chronicle stands (sync 2026-09-10)

Found and in force: the instrument (§2.1), the flat-action ladder
(§2.2), E7a EXACT → machine-checked (§2.3), the onset (§2.4), the
certified no-ghost bound 10⁶ / 10⁷-triple (§2.5), two cell classes
(§2.6), the reproduced bridge (§2.7), the exact detector (§2.8).
Combining: the staged skeleton (§2.9) + the formal instrument
(§2.10). In flight at sync: the G = 6×10⁶ list walk (decides B-2's
tail model and the A/B route) and the final 10⁷ redundancy (closes
§2.5's last slot). Next entry is written when the first of those
lands.

---

## 5. The 10⁷ redundancy lands — and the LOCKED candidate falls (2026-09-11)

*Supersedes §4's in-flight list (both slots now landed: the G = 6×10⁶ chain,
day-010/11, and the final 10⁷ redundancy). Entry written because an
evidence file landed — and because this is the log's contradiction case.*

**The contradiction (the log's own purpose).** The pre-registered LOCKED
candiate for the dead-chunk size was **+246** (a coarse |ΔS| estimate from
the S-plateau, never a direct count). The completed re-walk (PID 1142170,
~23 CPU-h, exited 2026-09-10 20:22 local; record
`scripts/rh/out_day006_early_rewalk.txt`) **measured +244**. Both are even —
and that is the honest wall: the 2K even-identity **cannot arbitrate 244
vs 246 at any precision** (N enters mod 2; 2K = −2 and 2K = 0 are both
even; the dps-45 principal-arg test passes both families, dist ≤ 2.3×10⁻⁹).
The arbiter is the dt/dt2-stable direct count, doubly confirmed: the
re-walk's window (10⁶, 1.4×10⁶] count **773,829** is independently
reproduced to the last zero by the day-009 6e6 GPU zero list (same window,
same count, different engine).

**Certified (day-014 record; replaces all DEFECTIVE 1e7 numbers).**
N(10⁷) = **21,136,121** · S(10⁷) = **−3.205718** (dps-45) · 2K even ⇒
**no off-line zero pair below 10⁷**. Dead chunk located precisely:
(10⁶, 1,000,128], Δ = 244 flips, 128 rad (the early "~1.06×10⁶ plateau"
localization is revised). Named residual: the middle window
(1.4×10⁶, 9.9×10⁶) was not re-walked — a 1–2-flip defect below 1-rad
sampling is not excluded there (S flat, no jump > 0.27).

**Logged bug (P-0.9).** The pre-staged verifier `day005h_verify_1e7.py` was
broken two ways and had never run to completion (payload concatenated into
source; principal-arg where the identity only has principal-arg strength).
Fixed (`day005h_mp.py` companion); the buggy first run is kept as
`out_day014_dps45_d244.BUGGY-verified-gamma-arg.txt`. The code-beats-
memory rule worked, and the broken check cost exactly the one re-check the
owner demanded before trusting the number.

**Repository structure (same day).** The Lean package now **lives in this
repository** (`formal/`, source of record; the kainos-logos path is
a symlink) — `formal/RH-LEAN-PROVENANCE.md`; the proof path was rewritten as
a public linear exposition with named pieces P1–P8 (`docs/RH-PROOF-OUTLINE.md`,
byte-identical with the working-repo source of record); every Lean file
carries a purpose header (what it is / role / status); reference material
moved to the working repo (`kainos-logos/references/`).

## 6. The P4 line turns green — and a formalization trap worth naming (2026-09-12)

**State of the P4 line (rh-missing-tail).** Four machine-checked atoms,
one per commit, zero sorry: `P4Em` (1st-order EM, verbatim port of the
published proof), `P4Tail` (per-period 2nd-order identity + the periodic
`B2` kernel), `P4Em2` (the global finite 2nd-order law
`∑ f = ∫ f + ½Δf + (1/12)Δf′ − ½∫ B̂₂f″`), and `P4Limit` L1+L2
(the `x ↦ x^{−s}` derivative family + the exact finite law with the
antiderivative `x^{1−s}/(1−s)` and the `B2` remainder explicit —
`7d42ced`). L3–L5 (kernel convergence at `M→∞`, the OP1/OP2 remainder
bounds, the stated bound `|W_n(t)| ≤ B_n(t)`) are queued. Every `lake
build` green (17426 jobs); all four runtime cross-check gates PASS.

**The trap (named for the record).** In Lean 4 / mathlib, a term printed
as `↑(B2 x) * deriv (deriv f) x` can hide *which* coercion instantiated
the `↑`. A theorem stated for generic `[RCLike 𝕜]` (like `em2_finite`)
elaborates the real scalar through the RCLike coercion
(`ofReal := Algebra.cast`); the same printed term in a concrete `ℂ` file
elaborates through the higher-priority `Coe ℝ ℂ` (`Complex.ofReal`). The
two kernels print identically but are **not unification-equal**, so
`rw [h]` silently fails with "did not find an occurrence of the pattern"
— a failure mode with no error pointing at the cause. The probe that
root-caused it (four cast forms against the live goal; only
`algebraMap`/`Algebra.cast` match) is logged in the day-019 §12 journal
and pinned in the `P4Limit` header. Rule for this codebase: when
rewriting into a generic-`RCLike`-land term, spell the scalar as
`algebraMap (R := ℝ) (A := ℂ) (·)`. Costs nothing (`algebraMap x = (x : ℂ)`
is `rfl`); saves a day.

## 7. The missing-tail law turns green — and the draft constant had to die (2026-09-13)

**L4 of the P4 line is green** (`e1e3402`, on top of L1 `0af15f0`, L2
`7d42ced`, L3 `5506b8f`): the two tail theorems of the rigorous P4
statement,

- `p4_op2c_bound` — |∫_{n..∞} B̂₂(x)·x^{−s−2} dx| ≤ √3/270 · ‖s+2‖ ·
  n^{−5/2} (|s.re| = 1/2), proven by a **per-period integration by parts**
  with the cubic period-1 extension `B3poly` of `B3` (periodicity from
  the Bernoulli-3 identity, `B3poly(0)=B3poly(1)=0` kills the boundary
  terms on every `[k, k+1]`, and `∫_0^1 B2 u · B3poly' du =
  B3poly(1) − B3poly(0)` closed by `ring` — the identity B2 = B3'/3 is
  what supplies the factor 1/3);
- `p4_f2_tail_bound` — ‖∫_{n..∞} f̂″_{≥n}‖ = ‖s(s+1)‖ · ‖∫ B̂₂ x·x^{−s−2}‖
  ≤ ‖s(s+1)‖ · √3/270 · ‖s+2‖ · n^{−5/2}, via `integral_congr_ae` +
  `integral_smul`, the FTC for the `x^{−7/2}` integral (antiderivative
  `−(2/5)·x^{−5/2}`, derivative bridge closed by `ring` on the rpow atom).

**The constant, computed (the P4 numeric rule), and one wall of the
numeric itself.** The final constant comes from the per-period IBP route:
the factor 1/3 (B2 = B3'/3) times max `|B3poly|` = √3/36 (at
u = (3±√3)/6, exact) times `∫_n^∞ x^{−(s.re+3)} dx` = (2/5)·n^{−5/2}
— pure multiplication, `(1/3)·(√3/36)·(2/5) = 2√3/540 = √3/270`, i.e.
**√3/270 · ‖s+2‖ · n^{−5/2}**, with no slack anywhere.

Two numeric findings, both recorded as they actually are:

1. **A false alarm, corrected.** Early in the day a direct
   `mp.quad(integrand, [n, ∞])` evaluation of the B̂₂-kernel tail
   appeared to violate the draft constant √3/108 at large n
   (ratios up to ~9). Cross-checking with two independent reliable routes
   — (a) an infinite quad of the IBP-transformed integrand B̂₃·x^{−s−3}
   and (b) a per-period chunked quad sum with an analytic
   max-kernel tail correction — agreed with each other to <1% and were
   **5.4× smaller** than the direct-route value. The direct
   infinite-quad over the periodic kernel is the broken number; the
   corrected 35-point grid (t ∈ {0,1,2,5,10}, n ∈ {1,2,3,5,10,21,50},
   overestimated tail) gives **0/35 violations for BOTH constants**,
   worst ratios **LHS/(C108·|s+2|·n^{−5/2}) = 0.341** and
   **LHS/(C270·|s+2|·n^{−5/2}) = 0.853**. Conclusion: the draft
   constant √3/108 was **not** refuted — it simply has ~3× more slack;
   the adopted √3/270 is the sharp one the IBP route produces exactly.
   Lesson (filed): never let a single numeric integrator's verdict kill
   or bless a formal constant; cross-route agreement first.
2. The formal √3/270 theorem is consistent with the corrected numerics
   (worst observed usage 0.853 < 1), as expected since the Lean proof
   is the exact arithmetic of the IBP route.

**Transferable Lean lessons (pinned in the P4Limit header):**

1. `HasDerivAt.comp` in 4.33.1 takes the point as an explicit **first**
   argument: `HasDerivAt.comp x hh₂ hh`.
2. `ContinuousOn.intervalIntegrable` takes **no** endpoint arguments.
3. `uIcc`'s lower bound is `min a b` — bridge with `min_eq_left` before
   `nlinarith`.
4. `tendsto_order` unpacks `Tendsto f l (𝓝 a)` into the two one-sided
   eventual inequalities; and `le_of_tendsto (lim) (h : ∀ᶠ c, f c ≤ b) :
   a ≤ b` takes an eventual upper bound straight to the limit — the
   by_contra + `filter_upwards` dance is unnecessary (and
   `filter_upwards` does not work on a goal of `False` anyway; it needs a
   π-goal).
5. `∀ᶠ` is a Prop, not a structure: no `.imp` dot; compose with
   `filter_upwards [h1, h2] with x h1 h2`.
6. `Nat.cast_pos`'s algebra argument is `α` — spell `(α := ℝ)` or the
   instance search sticks.
7. `ring` closes coefficient identities with rpow atoms
   (`−(2/5)·(−5/2)·x^{−7/2} = x^{−7/2}`) — treat the rpow as a monomial
   atom.

Full repo build green (0 errors); all four runtime gates PASS. P4Limit
now holds L1+L2+L3+L4; the remaining P4 layer is L5 (assemble the P4
statement `|W_n(t)| ≤ B_n(t)` from the atoms).

## 8. L5 GREEN — the P4 line composes: identity at Re s > 1, bound at Re s = 1/2 (2026-09-15)

One composition atom at a time (owner's one-at-a-time rule), each built
green before the next:

- **L5.a `p4_Tn_Tendsto`** (816d77f): the M→∞ limit of the tail partial
  sums `∑_{n<k≤m} k^{−s}` is the closed constant `p4_Tn_lim` — endpoint
  terms + the bare f″ kernel tail. Built on L3's `p4_kernel_tendsto` +
  `tendsto_rpow_neg_atTop` for `x ↔ x^{−s−1}` on ℕ.
- **L5.b `p4_zeta_split`**: the 1-indexed split
  `riemannZeta s = ∑_{0≤k<n} 1/(k+1)^{-s} + ∑_{k≥n} 1/(k+1)^{-s}` via
  `zeta_eq_tsum_one_div_nat_add_one_cpow` (avoids the `0^s` singularity of
  `zeta_eq_tsum_one_div_nat_cpow`) + `Complex.summable_one_div_nat_cpow`
  + `Summable.sum_add_tsum_nat_add'`.
- **L5.c `p4_Tn_eq`**: the second tsum = `∑_{0≤k<n} k^{−s} +
  p4_Tn_lim s n` — `Summable.tendsto_sum_tsum_nat` (tail partial sums →
  tsum, with the L5.a `congr'` for eventual equality) + L2's finite EM
  law `em2_finite` on every prefix + `FunLike.funext` to absorb the
  `fun i => (i:ℝ)` cast.
- **L5.d `p4_identity`** — **the P4 line-statement, machine-proven for
  Re s > 1**: `riemannZeta s − P_n s + I(n,s) = p4_em_expr s n`, where
  `p4_em_expr := −½n^{−s} + (s/12)n^{−s−1} − ½∫_n^∞ B̂₂({x})·f″(x)dx`
  (kernel form; `f″` = `p4_f2` = `s(s+1)x^{−s−2}`, so the explicit
  `s(s+1)` form is a one-line simp corollary). Assembly: L5.b + L5.c +
  `norm_cast` on the single-cast/natural-cast complex powers + `ring`.
- **L5.e `p4_T4_bound`** — **the P4 bound at Re s = ½**:
  `‖p4_em_expr s n‖ ≤ ½n^{−1/2} + (‖s‖/12)n^{−3/2} + (√3/540)·
  ‖s(s+1)(s+2)‖·n^{−5/2}` — triangle inequality on the three display
  terms; the kernel term is L4.4 (`p4_f2_tail_bound`, sharp √3/270) with
  the leading ½. The equality `W_n = p4_em_expr` **at Re s = ½ itself**
  is CITED (DLMF 25.2.8 / Apostol Thm 12.21: both sides agree on
  Re s > 1 by L5.d and are analytic on {Re s > −1}\{−1,−2}); the bound
  on the EM expression is fully Lean-proven there.

Honest split, documented in `P4Limit.lean`'s L5 header: Lean proves the
identity on Re s > 1 and the bound on the expression at Re s = ½; the
bridge at the critical line is the published EM extension (cited).

New tooling pins: `zeta_eq_tsum_one_div_nat_add_one_cpow`,
`Summable.sum_add_tsum_nat_add'`, `Summable.tendsto_sum_tsum_nat`,
`summable_nat_add_iff`, `tendsto_nhds_unique`, `Filter.Tendsto.congr'`
(set-valued eventual-equality congruence), `Finset.sum_range_add` +
`Finset.sum_union` for the range↔Ioc bridge, `Complex.one_re`,
`Complex.norm_cpow_eq_rpow_re_of_pos` (after the single-cast bridge
`(n : ℂ) = ((n : ℝ) : ℂ)`), `norm_sub_le`, `norm_add_le`, `le_rfl` as a
calc-closer.

Full repo build GREEN (0 errors, 17426 jobs); gates A-D PASS.

## 9. L5.f GREEN — the T4 ratio corollary (2026-09-15)

`p4_one_minus_s_conj`: on the critical line Re s = ½, `1 − s = star s`
(conj-re/im via `Complex.conj_re`/`conj_im`, which plain `simp` applies
even though `rw`/`simp only` cannot match their `starRingEnd` pattern).
Hence the correction scale |I| = n^{1/2}/|1−s| simplifies to
n^{1/2}/|s|.

`p4_T4_ratio`: the three-term ratio bound
‖em_expr‖·|1−s|·n^{−1/2} ≤ (‖s‖/2)n^{−1} + (‖s‖²/12)n^{−2} +
(√3/540)‖s‖·‖s(s+1)(s+2)‖n^{−3} — p4_T4_bound multiplied by
|1−s|·n^{−1/2} = |s|·n^{−1/2}, with the rpow products (−1/2)+(−k/2)
via `Real.rpow_add ←`.

Honesty note: the module sketch's draft T4 line in (t²+¼)(|s|+1) form
was checked and is WRONG for large t (fails at t = 10); the exact
product form above is what holds for every t, and is what the measured
15-point table (0.0500 … 1.0620) is checked against (P4Float gate).

New pins/lessons: `|·|` (abs) notation fails on ℂ with "Lattice ℂ" —
use `‖·‖`; plain `simp` (not `simp only`) is needed for
`Complex.conj_re`/`conj_im`; `ring_nf` keeps `x^2` as a power (does not
expand to `x·x`) — `simp only [pow_two]` first; `rw [h1, …, hn]` skips
non-matching entries (order matters for failure reporting); `‖s(s+1)(s+2)‖`
gets its interior expanded to `‖s·2 + s²·3 + s³‖` under `ring_nf` — both
sides expand, so the final `ring` closes.

Full repo build GREEN (17426 jobs, 0 errors); gates A-D PASS. The P4Limit
module (all of L1-L5) is now complete: the P4 missing-tail line — exact
law on Re s > 1, bound + ratio corollary at Re s = ½ — is machine-proven.

## 10. P8Floor module GREEN through A4.1 — the residual-floor line (2026-09-16)

Route A of the §10 residual floor, formalized in `formal/RhAttack/P8Floor.lean`
from the spec `kainos-logos/.../spec/p8floor-routeA-abstract.md`. Seven green
commits, one per atom: `18f9b2e` (A0+A1), `7c07343` (A2a), `775174b` (A2b.1),
`4d4a5d5` (A2b.2), `d571f70` (A3.1+A3.2a), `ef1aff1` (A3.2b.1), `63fdae8`
(A4.1).

**What is machine-proven (LEAN-PROVEN):**
- A0+A1: the same-object reduction — the outline's LHS
  `|W_n(t) − [K_on(t) − (P_n − I)]|` is EXACTLY `‖δK‖ + bridge residual +
  floor` under `p8_triangle` (reverse triangle via `norm_sub_le`); `p4_Wn`
  fixes the definition-side W_n so no ζ appears anywhere.
- A2a: `p8_B_floor` — the three-term P4 floor at s = ½+it is literally
  `p4_T4_bound` (half-critical-line instantiation).
- A2b: `p8_residual_exact` factors the bridge residual
  `e^{Tt}·∏_L F − ∏_{L∪T} F = ∏_{L∪T} F·(e^{Tt − Σ_T ln F} − 1)` (B3
  `b3ResidualDecomp` + ring); `p8_abs_exp_sub_one_le` proves
  `|e^x − 1| ≤ e^{|x|}·|x|` with a BOTH-sign analysis built on
  `add_one_lt_exp` (`x ≠ 0 → x+1 < e^x`) + `one_le_exp` — no MVT (the MVT
  route's resolution friction: `hasDerivAt_exp` ambiguity,
  `differentiableAt` vs `differentiableWithinAt`, `div_mul_cancel` arg
  order — abandoned cleanly); `p8_residual_bound` then makes the residual
  the product's own mass × a function of the ONE model-defect number
  x := Tt − Σ_T ln F. Zeta-free, counting-free.
- A3: `p8_noff_delta_min` — B5's off-line numerator
  `((t−γ)²+δ²)((t+γ)²+δ²) = (t²−γ²)² + 2δ²(t²+γ²) + δ⁴` (all
  coefficients ≥ 0) is δ-monotone, minimized at δ = 0 — no dead δ window;
  `p8_detector_abs_lower` — reverse triangle (`abs_dist_sub_le R 1 0`)
  routes `‖R − 1‖ ≥ |‖R‖ − 1|` into B5 `b5Abs`' closed magnitude;
  `p8_pref_omega_zero` / `p8_detector_norm_at_zero` — at δ = 0 the closed
  form collapses to explicit numbers (pref = (γ²−t²)/(¼+γ²), ω₀ =
  1/(¼+γ²), ‖R(0)‖ = |γ²−t²|/(¼+γ²)·e^{ω₀/2}) — the far-regime seeds.
- A4.1: far regime, γ ≥ 1, t ≥ 2γ: `‖R(γ,0,t)‖ ≥ 2` and hence
  `‖R − 1‖ ≥ 1` — the zero-decision inequality (outline §7: floor +
  residual < detector) reduces there to bounding floor + residual below 1.

**Honest split (per the honesty rule):**
- The W_n = EM-expression equality AT Re s = ½: CITED (DLMF 25.2.8 /
  Apostol 12.21) — same split as P4Limit L5.e.
- The NEAR-regime detector floor (t ≈ γ, the branch locus excluded from
  B5's closed form at t = γ): PINNED by the day-017/019 near-regime audit
  (0.9975 – 1.0201 across the grid; margin ≥ 14× at the pair's own
  height) — A4.2 is the next atom and will state this as a
  measurement-pinned constant.
- The M(G,t) wire (B3Sbar `b3BoundExplicit` composition into the residual
  chain): next after A4.2.

**New 4.33.1 pins/lessons:** `mul_lt_mul_of_pos` in this mathlib is the
4-argument 2-sided form (a<b, c<d, 0<a, 0<d) — single-sided lemmas are
`mul_lt_mul_of_pos_left`/`_right`; `abs_dist_sub_le (x y z) :
|dist x z − dist y z| ≤ dist x y`; `div_le_div_iff₀ hb hd` (field form; the
Unbundled `div_le_div_iff_right` needs `Group`, which ℝ's multiplicative
monoid is not); `le_div_iff₀`; `abs_div (a b)` takes ELEMENT args (no proof,
field default); `mul_eq_zero : (a·b = 0) ↔ …` — use `.mp`; `sq_lt_sq` is
an IFF (nlinarith squares positive atoms instead); `show E, from P` and
`show E := by P` are UNPARSEABLE in 4.33.1 in tactic lists and as terms —
annotated by-terms `(by t : E)` or named haves only; CJK brackets 〈〉
(U+3008/9) vs Lean angle brackets ⟨⟩ (U+27E8/9) keep getting confused —
`obtain ⟨a, b, c⟩ := …` needs the latter; a bare `calc` step whose LHS
carries a `·1` factor needs `simpa [mul_one]`; calc mixing one strict `<`
step makes the whole calc's type strict — promote to `le_of_lt` first.

Full-repo build GREEN (17428 jobs, 0 errors); zero `sorry`/`admit` in
P8Floor; B5-CORE CHECK PASS (worst 5.978e-26); rhattack smoke exe: E7a /
B-4 / B-5 / B-3 all CROSS-CHECK PASS.

## 11. P8Floor completes — A4.2 + A4.3, module (A0-A4) green (2026-09-16)

Two atoms close the line (commits `04a633d`, `1d8e68f`):

**A4.2 — the decision under the pinned floors.** `p8_f_near_pin := 0.9975`
stated as the *measurement-pinned* near-regime floor (day-017/019 audit
grid: |t−γ| ≤ 10.21, δ ∈ {0.005, 0.5}, measured 0.997500–1.020104) —
explicitly NOT a Lean-proven bound (the audit is its authority);
`p8_f_far_floor := 1` (the A4.1b LEAN-PROVEN far floor); and
`p8_zero_decision_far`: outline §10's decision inequality in symbolic
form — `p8_B t n + Mval < ‖R(γ,0,t) − 1‖` for γ ≥ 1, t ≥ 2g whenever
floor + P5-mass < 1 (`lt_of_lt_of_le` over A4.1b).

**A4.3 — the M(G,t) wire (P5 side live).** `p8_residual_wired`: given
the model-defect bound `|x| ≤ Xval` (Xval = the B3Sbar
`b3BoundExplicit` RHS `Bf t G·(Sbar B + Sbar G) + Cf t G·Kbar G` at the
measurement point, wired as an explicit hypothesis per the honesty
rule), the bridge residual `e^{Tt}∏_L F − ∏_{L∪T} F` is
`mass·e^Xval·Xval`. Two `gcongr` steps (exp monotone + nonnegativity of
mass and |x|).

**Module composition (header now carries it):** the §10 LHS splits by
A1 into ‖W_n‖ + ‖K − (P_n − I)‖; side 1 = p8_B (A2a, P4Limit L5 bound
at ½+it); side 2 = mass·e^Xval·Xval (A2b + A4.3 + Sbar); the RHS
detector routed through B5 closed forms (A3), far floor 1 (A4.1,
LEAN-PROVEN), near floor 0.9975 (A4.2, PINNED). The statement holds
pointwise wherever floor + mass sit below the regime floor.

New lessons: bare `gcongr` in 4.33.1 auto-discharges core + side goals
from local context — bullets cause "No goals to be solved"; quoted
heredocs carry `\uXXXX` VERBATIM into Lean (use literal UTF-8 or a
python pass after); a python `s[:i]` slice before writing truncated the
A4.3 block once (caught by re-reading the file tail before committing —
verify after every slice-based rewrite).

Full-repo build GREEN (17428 jobs); zero sorry/admit; B5-CORE CHECK
PASS; gate smoke all PASS.

## 12. Xval pin — the concrete M(G,t) constant at the measurement point (2026-09-16)

`scripts/rh/day020_xval_pin.py` (record: `scripts/rh/out_day020_xval_pin.txt`)
pins the A4.3 hypothesis `|x| <= Xval` at the audit measurement point
(t = 1000.041572, band (G, B] = (2t, 10^5] = (2000.083144, 100000],
certified zero list <= 10^5, day-014 record). Model functions copied
line-for-line from `B3Core.lean` (no-recall rule), dps-30:

    actual sum (136,548 factors fT)   = -543.74112770383...
    Tt (quadrature of nHat . fT)      = -543.72187385967...
    x = Tt - sum                      = 0.019253844165493...
    Xval = Bf(Sbar B + Sbar G) + Cf.Kbar
         = 0.3335835312 (3.7143 + 4.2650) + 2.66689e5 . 4.8925e-7
         = 3.9665418656908...
    MARGIN = Xval / |x| = 206.0x        -> PASS
    hS premise at G: |NList - NHat| = 0.0693 <= Sbar G = 3.7143  -> PASS
    hS premise at B: |NList - NHat| = 3.5584 <= Sbar B = 4.2650  -> PASS

So at the measurement point the P8Floor A4.3 wire runs with the
concrete pinned constant Xval = 3.9665418656908 (margin 206x), and
the b3BoundExplicit hypothesis hS is verified at both band endpoints
against the certified list. The residual at this height is then
bounded by mass . e^3.9665 . 3.9665 — while the D3 measured LHS
(|zeta - K_on|) at the same height is 6.43e-05 (d4d3 record) and the
near-regime detector floor is the pinned 0.9975 . |K| — the route-A
decision holds at the measurement point with the full pinned-constant
chain. (The cross-band worst case, e.g. the t = 980 residual spike
2.465e-02 vs the detector there, needs the <= 3e5 list — queued.)

## 13. Cross-band worst-case audit — route A HOLDS, min margin >= 112x (2026-09-16)

`scripts/rh/day020_worstcase.py` (record: `scripts/rh/out_day020_worstcase.txt`)
scans the queued cross-band question. Provenance: functions copied
verbatim from the d4 generator (day009c blob 63ea96d5, per its header);
certified list <= 3e5 (466,655 zeros); dps-15; closed-form R (P3/B5,
Lean-proven) spot-checked against the direct 4-zero definition at each
candidate (|diff| ~ 1e-16, matching the P3 5e-4 class record).

Setup (the S8 pairing, made explicit): for each candidate pair height
g (an ACTUAL zero height), on the straddle window t in [g-12, g+12]
(step 0.5), the pointwise route-A decision is
    resid(t) = |zeta(1/2+it) - K_on(t)|   (S10 LHS; A0: zeta - K_on)
    dev(t)   = |K_on(t)| * min_{d in {0.005..0.5}} |R(g,d,t) - 1|
    margin(t) = dev / resid.

Results (overall worst in bracket):
    g = 999.791572 (the d4 pair):  worst t = 1006.7916  resid = 0.0817  dev = 9.20  margin = 112.6
    g = 980.578001 (queued t=980 cross-band):  WORST t = 978.578  resid = 0.0164  dev = 1.95  margin = 118.6
    g = 1019.912440:  worst t = 1016.9124  margin = 122.0
    g = 1040.264038:  worst t = 1041.264  margin = 116.5
    OVERALL: min margin = 112.6, decision HOLDS on every scanned window.

Key finding: the apparent sub-1 margin at t = 1009.79 in the d4 record
(dev 0.0324 vs resid 0.0627) is the WRONG pairing — it uses the d4 pair
(g = 999.79) at an evaluation height 10.2 units away, where |K| is small
near a foreign zero. The S8 closure compares at the candidate pair's
OWN height with its OWN pair; under that pairing the min margin is >= 112x
across [968.6, 1052.3]. The queued t = 980 spike (resid 2.465e-2 in the
D3 scan) is dominated ~120x at g = 980.58.

d_min pin (S10, Route A's price): min over the measured grid edges
d >= 0.005 — the floor is d-independent (P4 limit law) and the detector
has no dead d window (P3: numerator a positive polynomial in d^2), so
the measured lower edge d_min = 0.005 is the operative threshold.

## 14. P9 Closure module GREEN — the §8 conditional closure (2026-09-16, goal turn)

The next outline gap after P8 (spec: kainos-logos
`plan/40-prize-islands/rh-attack/spec/closure-module-abstract.md`) is
the §8 closure itself. New module `formal/RhAttack/Closure.lean`
(P9), registered at `RhAttack.lean`. Full build GREEN (17430 jobs,
0 errors, 0 sorry); B5-CORE CHECK PASS; rhattack smoke all PASS.

Atoms (all machine-proven under the explicit measurement input):
  - Pins: `p9_f_pin = 0.9975` (the near-regime detector floor,
    day-010 d4d3 audit: |R−1| = 0.997500…1.020104 across d = 0.005
    … 0.5 on |t−g| ≤ 10; closed form vs direct 4-zero to ~1e-16 in
    the §13 run), `p9_d_min = 0.005` (the measured d-grid edge —
    Route A's price; the floor is d-independent and the detector has
    no dead-d window), `p9_margin_min = 112.6`, `p9_m_pin = 1/112.6`
    (the §13 worstcase audit minimum margin; note: `p9_m_pin` is a
    `noncomputable def` — ℝ division — a 4.33.1 gate to know).
  - C1-far `p9_far_detector_ge_pin`: far regime (γ ≥ 1, t ≥ 2γ)
    ‖R(γ,0,t)−1‖ ≥ f_pin — restated from P8Floor A4.1b (≥ 1 ≥
    f_pin). The near/own-regime half stays PINNED; its promotion to a
    Lean theorem is the open atom C1b (the branch-locus d,t
    two-variable minimum of |R−1|) — the remaining "Route A's price".
  - C5 `p9_point_contradiction`: the arithmetic squeeze — Q ≥ dev −
    Mf (bridge + detector, ≥ side), dev ≥ flo, Q ≤ Bfloor + Mr
    (P8Floor definition side, < side), Bfloor + Mr + Mf < flo → the
    point is empty. Pure `linarith`.
  - C0 `p9_min_offline_height`: over B0's structural ZeroSet (HNR/
    HCJ/HFIN — no counting value enters), an off-line zero exists
    iff a MINIMUM positive off-line pair height t0 exists, with an
    off-line zero at exactly t0 and every off-line zero height ≥ t0.
    Technique: positive-height representative (conjugation, the B0
    RH_of_zeroD idiom), the finite slice as an explicit `set … with`
    equation (local `let`s are opaque to the checker — the B5
    lesson), membership iff's by `simpa [Finite.mem_toFinset,
    Set.mem_inter_iff]`, then the Finset.image of the heights and
    `Finset.isLeast_min'` (4.33.1 shape: `min'_le`/`min'_mem` take
    (s, proof-of-nonempty) as EXPLICIT arguments in that order; the
    `IsLeast`/`lowerBounds` route gives the minimum inequality for
    the SAME nonempty proof — the subtype-instance `min' ⟨x, hx⟩`
    form is a different noncomputable `inf'` value and does not `rfl`
    against the `H`-instance).
  - C5b `p9_closure_rh_of_margin`: the §8 closure. RH fails ⇒
    (C0) a minimal off-line pair (t0, d0) exists ⇒ the squeezed
    margin hypothesis at (t0, d0) (its six real witnesses ARE the
    pinned/cited constants: the bridge-tail bound Mf, the detector
    floor flo, the definition-side floor Bfloor + Mr) ⇒ C5 empty ⇒
    contradiction ⇒ RH. Counting-free per §8's own words: only the
    structural ZeroSet interface and the explicit measurement input
    enter.

Honest split: C0/C5/C5b/C1-far LEAN-PROVEN (C5b under the explicit
hmargin — the module does not assume the measurements inside Lean);
the near-regime detector floor PINNED (C1b OPEN). The composition is
conditional by design: instantiating hmargin with the pinned
constants (f_pin, d_min, m_pin + the P8Floor A4/Xval wires) is the
day-020 numerical verification, and C1b is the remaining analysis
price.

## 15. C1a — the branch locus IS the pole: the own-height detector facts GREEN (2026-09-16/17, after the P9 module went green)

**Setup.** The P9 closure (section 14) left one priced item: the
detector floor at the candidate pair's own height (the "own regime"),
recorded as PINNED (0.9975, day-010 d4d3 straddle audit). The closure
itself — C5b — evaluates the squeezed margin exactly at the MINIMAL
off-line pair height t0 = g. So the question sharpens: what is the
detector AT t = g, not just near g?

**Finding (day021_c1b_worstpoint.py, scripts/rh/out_day021_c1b_worst.txt).**
The ratio R(g, d, t) has a POLE at t = g: the on-line pair's 25.2.12
factor (1 − (s/ρ + ρ/s)/2) vanishes at s = ρ (its own point), so
pairProd(g, g) = 0 while all four off-line factors remain nonzero for
0 < d < 1/2 (their real parts are 1/2 ± d, δ, 1/2 ∓ δ, all > 0 at
t = g). The kernel change the zero side of the contradiction carries
at own height is therefore the off-line product mass poff(g, d, g) —
a finite, nonzero, POSITIVE-constant factor times the bridge exp. The
window-floor scan (the audit's original target) shows the rest:
|R| crosses |R| = 1 with phase jump π (a unit-circle crossing = a
sign flip of Re(R − 1)) on |t − g| ≲ O(1/γ), the worst |R − 1| dips
scale ~ 1/γ (measured: ~1/γ·0.06–0.11 at γ ≈ 1000 with δ = 0.005–
0.02, worst δ = 0.06 at γ = 129.98) — i.e. the t ≠ g window is
well-behaved but NOT the closure's evaluation point.

**Lean (C1a, RhAttack/Closure.lean, all 7 atoms LEAN-PROVEN,
deterministic tactics only).**
  p9_fac_self_zero            — (1 − 2·(z/z)/2)·e¹ = 0 (div_self)
  p9_pairProd_at_own_height   — pairProd γ γ = 0 (ρ ≠ 0; Re(ρ) = 1/2 > 0)
  p9_fac_ne_zero_of_ne        — fac ρ s ≠ 0 iff s ≠ ρ, ρ ≠ 0 (field_simp)
  p9_poff_own_height_nz_full  — poff γ δ γ ≠ 0 for 0 < δ < 1/2 (the four
                                factors: Re = 1/2 ± δ / δ nonzero; s ≠ ρᵢ
                                by the add_right_inj/lt_irrefl route)
  p9_kernel_change_at_own_height — poff − pairProd = poff ≠ 0 (exact)
  p9_detector_at_own_height   — ‖poff − pairProd‖ = ‖poff‖ (simp)
  p9_poff_own_height_pos      — 0 < ‖poff γ δ γ‖ (norm_pos_iff)

**Consequence for the §8 closure.** The "0.998 at own height" line of
the outline is not a floor at all — it is the pole: the ≥ side at t0
is exact and its mass is strictly positive. The PINNED 0.9975 window
floor remains an honest recorded audit of the t ≠ g regime (its C1b
promotion — the branch-locus d,t two-variable minimum of |R − 1| —
is now OPTIONAL for the closure; the pin is a conservative statement
about window behavior the closure does not need). The conditional
closure stays conditional only on its measurement inputs (margins),
as designed; no detector-side pin is on the critical path anymore.

**Toolchain pin (Lean 4.33.1).** Hit a NONDETERMINISTIC linarith
failure while proving the C1a factor lemmas: "synthetic hole has
already been defined" (termElabSyntheticMVar, the lt_irrefl route),
same file failing once then passing repeatedly; a micro-probe
isolated it to linarith on equality goals with strict hypotheses in
the context (ring on the same identity is fine). Online search
(2026-09-13) found no published mathlib4 issue with this exact trace
(general synthetic-hole / congr hole-hogging threads only).
Workaround adopted: the C1a section uses deterministic tactics only
(simp/rw/norm_num/field_simp/add_right_inj/lt_irrefl) and keeps
1/2 out of the decision procedures. Recorded here so a future
commit does not reintroduce a flaky linarith.

## 16. C6 — the audit-point margin wire: §8 at the audit point is one statement (2026-09-17)

**Goal.** C5b (`p9_closure_rh_of_margin`) closes §8 under the
explicit hmargin hypothesis.  The remaining work was to NAME the
audit-point instantiation: which measurement facts, in which form,
make hmargin at the audit point hold.

**Spec.** `kainos-logos/.../spec/c6-margin-wire-abstract.md`.

**The audit package (formulas from scripts/rh/day020_worstcase.py).**
At each candidate pair height g and scan height t:
  resid(t) = |zeta(1/2+it) - K_on(t)|     (= Q, the S10 LHS, A0
                                              same-object)
  dev(t)   = |K_on(t)| * min_d |R(g,d,t)-1| (kernel change, S7
                                              detector)
  MARGIN(t) = dev/resid                    (record: worst 112.6 over
                                             4 candidate pairs x
                                             straddle windows)
The hmargin witness tuple is (Q, dev, flo := dev, Mf, Bf, Mr), so
the per-point package is exactly three measurement facts:
  hZero   Q >= dev - Mf      (zero side: bridge S6 + detector S7;
                              the CITED identity zeta = K_on *
                              kernel (DLMF 25.2.12) + measured
                              reduction — day-010 d4d3 / day-020)
  hDef    Q <= Bf + Mr       (measured resid below the A4.3-wired
                              bound at the Xval pin — out_day020_
                              xval_pin.txt, 206x headroom)
  hStrict Bf + Mr + Mf < dev (the audited strict gap — the 112.6x
                              margin is this inequality in point
                              form)

**Lean (RhAttack/Closure.lean, C6, both atoms LEAN-PROVEN).**
  C6.1 p9_audited_package_strict — the package packs into the
    hmargin witness tuple: (Q, dev, dev, Mf, Bf, Mr) with hZero,
    le_rfl (dev >= dev), hDef, hStrict.  Six-line term; the value is
    the NAMED interface between the audit and the closure.
  C6.2 p9_closure_at_audit_point — the TOTAL composition:
    RH q  from  (per off-line pair (t0,d0), the three fact package),
    body = p9_closure_rh_of_margin q (hmargin := C6.1 o hAudit).
    One line; the content is the statement itself: §8 at the audit
    point, no unnamed hypothesis.

**Where the §8 argument stands (honest split, final).**
  Machine-proven: C0 minimality, C5 squeeze, C5b closure, C1-far,
  C1a (the own-height pole + positive mass), C6.1/C6.2 composition,
  P8Floor A0-A4 (definition side), P4Limit L1-L5, B0/B2/B3/B4/B5.
  PINNED per point (script + record, computed never recalled):
    hZero  — the zero-side measurement (day-010 d4d3 + day-020)
    hDef   — the resid-vs-wired-bound measurement at Xval (xval pin)
    hStrict — the 112.6x strict-gap measurement (worstcase record)
  CITED: the bridge identity (DLMF 25.2.12); W_n = EM-expression at
  Re s = 1/2 (DLMF 25.2.8 / Apostol 12.21); Sbar/M(G,t) Platt-
  Trudguan.  OPTIONAL: C1b (the t != g window floor promotion).
The full build is 17430 jobs, 0 errors, 0 sorry; B5-CORE CHECK
PASS; the rhattack smoke PASSes; probe deleted.

## 17. C7 — the record arithmetic, machine-verified (2026-09-17)

The two closing records carry arithmetic claims computed from
printed point values; C7 makes those claims exact-rational
machine-checked facts (norm_num; the printed decimals are exact
rationals) — "computed, never recalled" now extends from the
measurement to the verification of the measurement's own arithmetic:

  p9_worstcase_record_margin : 9.198 >= 112.6 * 0.08168
    (out_day020_worstcase.txt, overall worst point t = 1006.7916,
     pair g = 999.791572; the closing number 112.6 re-verifies
     from the printed resid/dev)
  p9_xval_record_headroom : 3.9665418656908 >= 206 * 0.019253844165493
    (out_day020_xval_pin.txt, t = 1000.041572, band
     (2000.083144, 10^5]; the 206x pin re-verifies at 15 digits)

Precision discipline: per-pair printed values (e.g. the 980 pair's
"118.6") can FAIL such re-verification at 4-significant-figure
print precision (1.949/0.01644 = 118.55...); only closing numbers
are machine-checked, and the closing number is the overall worst
case. If a future audit adds a new closing constant, its C7 check
travels with it.

RhAttack/Closure.lean C7 section; full build 17430 jobs 0 errors
0 sorry; B5-CORE PASS; smoke PASS; probe deleted.

## 18. The cross-band record: coverage to 10^5, the closing margin re-pins to 1.053 (2026-021 records)

**Why.** The C6 audit-point closure needs the per-point package at
the hypothetical minimal off-line pair — of arbitrary height.  The
day-020 record covered the t ~ 10^3 region (4 pairs, worst margin
112.6).  This step extends the band to its feasible ceiling and
characterizes the margin's dependence on t.

**The runs** (scripts `day022_worstcase_ext.py` family, records
`out_day022_worstcase_ext.txt`, `out_day022b_upperband.txt`,
`out_day022c_upperband.txt`, `out_day021b_weakspot.txt`; same
functions verbatim from day020, W = 12, 7-delta grid; the weak spot
refined to DT = 0.25 + 10-delta grid):

  candidate pair g (nearest actual zero)   worst-point margin
  -----------------------------------------  ------------------
  ~980/1000/1020/1040 (day-020, 4 pairs)     112.6 (t = 1006.79)
  2000.434515   87.39      2499.862043     73.07
  2999.494493   62.46      4000.017285     45.99
  5000.234317   34.68      7499.635017     19.09
  10000.065344  11.29      15000.008791    5.494
  20000.128166  3.325      29999.710030    1.756
  50000.406752  1.053 (CLOSING, t = 49990.656752,
                     resid = 65.91129441, dev = 69.40177926,
                     exact margin 1.05295731)
  100000 (pair 99999.700948)  2.269 (RECOVERY — resid =
                     0.03019; the LHS is oscillatory, the
                     envelope decays, the point values
                     fluctuate)

**Findings.**
  1. The pointwise decision resid < dev HOLDS at every scanned
     point up to t = 10^5 (15 candidate pairs, straddle windows,
     DT = 0.5, weak spot DT = 0.25).  No sub-1 point measured.
  2. The per-region worst margin erodes from 112.6 at 10^3 to the
     closing 1.053 at 5*10^4 — roughly C/t on the envelope — then
     the 10^5 window recovers to 2.269 (resid oscillatory; the
     decay is an envelope statement, not monotone).
  3. The weak spot is a REAL 1.05 plateau, not a grid artifact
     (refined grid confirms the same margin at a different t,
     49990.656752; resid/dev ~ 0.95 across the local neighborhood).
  4. The closing number RE-PINS: p9_margin_min 112.6 -> 1.0529
     (computed under-estimate of 1.05295731 — the printed 8-digit
     values re-verify only at the under-estimate; C7.3
     p9_weakspot_record_margin machine-checks it).  The t ~ 10^3
     value 112.6 survives as the region record (C7.1).

**Honest state of the S8 claim (updated).** Verified on the
measured band [~970, 10^5] at grid resolution for 15 candidate
pair heights. Remaining measurement price, stated: (i) g-space
gaps between the 15 candidate heights (a hypothetical pair at an
unscanned height has no package record at its own height); (ii)
bands below ~970 and beyond 10^5; (iii) the 5% margin at the weak
spot is within the grid-resolution comfort zone.  The Lean
composition (C0/C5/C5b/C1a/C6/C7) is unchanged by this step — it
consumes whatever the record says at each point.

Leaning: the re-pin is a DOCUMENTATION + pin change (p9_m_pin
follows); C7.3 added; full build 17430 jobs 0 errors 0 sorry;
B5-CORE PASS; smoke PASS.

## 19. Sticky point found by the 6e6 tripwire — the day-020 dev statistic is |K|-scaled (2026-09-13)

**The run.** `day022_tripwire_6e6.py` extended the cross-band scan
to candidate pairs at 10^6, 2e6, 4e6, 6e6 (T6e6 zero list, 12.19M
zeros, G_MAX = 6e6; functions verbatim from day020).  It printed
"route-A pointwise decision VIOLATED" with "margins" 5.3e-10,
2.0e-12, 7.6e-15, 5.7e-26.

**The probe (computed, not recalled).** At the 1e6 "worst" point
(t = 1000005.2935): |K_on| ~ 1e-11 while |zeta| = 0.075143302
(dps-30).  The float64 12M-zero product sum was probed directly:
la(float64 pairwise) vs la(longdouble) vs la(mpmath dps-30 block)
agree to ~2e-9 (la ~ -3.9e5 scale; partial sums to +2.7e6) — the K
values are sound; the margin collapse is STRUCTURAL, not numerical:
  dev = |K_on(t)| * min_d |R(g,d,t)-1| is |K|-scaled; in
  zeta-small regions resid = |zeta - K| ~ |zeta| is NOT
  |K|-scaled, so margin = dev/resid -> 0 generically at high t and
  at ANY sampled zeta-small point.  The statistic is the
  day-020/021 "margin"; it is sound only in the K-dominant regime
  (resid ~ |K| * bridge-infidelity), which the [10^3, 10^5] band
  happened to sit in.

**Consequences (honest, stated before any re-run):**
  1. The 6e6 "VIOLATED" is INVALID as a route-death signal (the
     pre-registered rule applied to the statistic of the
     day-020 audit; that statistic degenerates out of its valid
     regime).  The record is kept on file with an invalidation
     note (append to out_day022_tripwire_6e6.txt).
  2. The CLOSING pin 1.053 (5*10^4) was computed with the same
     statistic.  It is sound at that point (K-dominant regime
     holds there — resid/dev ~ 0.95 with |K|-scale on both via the
     bridge), but the GLOBAL closing claim now carries the caveat:
     "1.053 in the K-dominant screening statistic; a scale-free
     re-audit of the closing band is PENDING (P0/P1 work)."
  3. The scale-free own-height reconstruction is defined (prize
     plan P1.1b): at candidate g — K^no-g (the product EXCLUDING
     g; kernel_on(1/2+ig) = 0 exactly since g is a zero of the
     product itself — the d4 construction's moved-pair kernel),
     the C1a pole mass poff(g,d,g) (finite, positive, exact),
     forced_own = |K^no-g| * |poff|, and the A4.3-wired def-side
     at t0 (B(t0) + Mr, with the |x| <= Xval and hS premises
     re-verified per band, as the xval pin did at 10^3).
  4. This is the first genuine sticky point of the prize plan
     (P1.2 was anticipated as one; this is P1.1's): the trend
     question "does the squeeze hold as t -> infinity" was being
     asked with a statistic that breaks outside its regime.  The
     answer is still UNKNOWN — the valid statistic has been
     defined; it has not yet been run.

**Sticker on the wall:** never extend a measurement statistic past
the regime where its scale cancels; when a run prints a dramatic
result, probe the scale before believing the verdict.

## 20. STICKY POINT #2 — the composite kernel's (B,∞) tail model inflates |K|; the "1.053 closing" is the inflation asymptote (2026-09-13)

**Trigger.** The P1.1b regime-guarded run to 6e6 (out_day022_p11b_regime.txt)
showed 0.0% regime support at 10^6..6e6: |K_comp(t)| ~ 1e-11..1e-26 while
|zeta| ~ O(0.1-100).  Probing the 1e6 point part-by-part
(probe_K_highT.py): each part verified sound — logmain vs Stirling,
la (float64 12M sum) vs longdouble/mpmath block to 3e-9, tail
quadrature dps-20 = dps-50 to 2 decimals — yet Re K_comp = -23.95
vs ln|zeta| = -2.59: the composite kernel is 21.36 NATS = e^21 LOW
in magnitude at t = 1e6 (B = 6e6 list cap).  By elimination the
error is in the (B,∞) tail MODEL (integral nHat·pairlog replacing
the product over zeros beyond the list cap) — the one part the
theory covers only via a bound, not a computation.

**The error curve (computed, out_day022_tailerr_curve):**
E(t) := ln|zeta(1/2+it)| - Re K_comp(t), B = 6e6 fixed:
  t = 1e3: E = -0.004  (0.4%)
  t = 2e3: E = +0.001  (0.1%)
  t = 5e3: E = -0.018  (1.8%)
  t = 7.5e3: E = -0.058 (5.6%)
  t = 1e4: E = -0.085  (8.2%)
  t = 2e4: E = -0.356  (30%)
  t = 5e4: E = -2.98   (f = e^{-E} = 19.73)
  t = 1e6: E = -21.36  (f = e^21)
Crossover to the error-dominated regime: ~5-6e3 (genuine margins
below it: 112.6 -> 87 -> 73 -> 62 -> 46 -> 34.7).

**The fingerprint (the decisive check):** in the error regime the
composite K_comp = f·K_true (f = e^{-E}, real), so the measured
margin at a closing point = dev/resid ≈ (f|zeta|·floor)/((f-1)|zeta|)
= f·floor/(f-1) -> f/(f-1) (floor = min|R-1| ≈ 1 near the pair).
Measured vs predicted:
  2e4:  measured 3.3247  vs f/(f-1) = 3.3236  (4 digits)
  5e4:  measured 1.0529  vs f/(f-1) = 1.0534  (3 digits)
  5009 (g = 5000.234317): measured 34.68 with resid = 8.14e-4 in
  the BRIDGE-DEFECT class (local E ~ 0) — GENUINE statistic.
The "closing 1.053 @ 5*10^4" — headline of the day-021 cross-band
work — is the TAIL-MODEL INFLATION ASYMPTOTE, not a measured
squeeze.  Retracted as a closing claim; kept as a measurement
record of the composite statistic.  The "recovery to 2.269 @ 10^5"
is the error curve saturating (f = 19.73 there too-class), not a
recovery.

**Consequences (honest, machine-wired):**
  1. `p9_margin_min` RE-PINNED 1.0529 -> 33.9864 (new verified-
     regime closing 34.68 @ t = 5009.2343, g = 5000.234317, with
     the 2% model-error envelope deducted; C7 re-anchored to
     p9_5e3_record_margin; the old record kept verbatim as
     p9_weakspot_record_kept with its reclassification).  The
     machine-proven core (C0/C1a/C5/C5b/C6) is UNAFFECTED — it
     consumes the pin abstractly.
  2. The "erosion curve" 112.6 -> 1.053 (day-020/021) re-reads as:
     GENUINE erosion 112.6 -> 34.68 over [~1e3, ~5e3] (the verified
     regime, envelope <= 2%), then MASKED 5e3..~1e5 (measured
     values track f/(f-1), the true margins UNKNOWN there), then
     BLIND >= 1e5 (0% regime support; |K_comp| ~ e^{-21}|zeta| at
     1e6).  The true high-band margin is an OPEN MEASUREMENT
     question, not a measured 1.05.
  3. The tail-model (B,∞) inflation means the composite kernel is
     a valid audit object only where |E(t)| <= ~2%: t <= ~5-6e3 for
     B = 6e6 (envelope 2%), t <= ~1e3 for the older B = 3e5 / 1e5
     lists at similar envelope.  All future audits must carry the
     E(t) check as a first-class output.
  4. Two fix routes for the masked band (5e3..1e5) and beyond:
     (a) P1.1c — an ERROR-BUDGET statistic: renormalize with the
         measured bridge (|zeta| Riemann-Siegel dps-25, independent)
         + the measured E(t) + the Sbar-class phase-error budget,
         so the audit is "margin vs worst-case model error" —
         local, no new data; (b) a LARGER zero list (T ~ 2-3e8,
         ~3.3e8 zeros, file ~4 GB, generation hours-days on this
         box — the rented-compute decision point) so that t/B
         returns to ~1/200 and the plain composite is faithful
         again.  (a) first (hours, not days); (b) if the prize
         case proceeds (the final certification wants the plain
         statistic on a wide band).

**Sticker:** a model's error curve can MASQUERADE as the thing under
measurement — the fingerprint check (measured margin vs the
model-predicted asymptote) is what separates the two.  Measure E
before trusting any |K|-based number.

## 21 — day-023 — the statistics disentangled: straddle is the closure
## metric, the pole is not, and the crossing at ~2.5e4 is the composite's
## error curve, not the squeeze (list repair launched)

### 21.1 — Three candidate statistics, one closure-faithful (Lean-wired)
P1.1 diagnostics (this day) produced three forms of the per-candidate
pair statistic. Which is THE closure metric settled from the Lean
statement itself (Closure.lean, `p9_closure_rh_of_margin`): the margin
hypothesis `hmargin (t0 d0) ... ∃ Q dev flo Mf Bfloor Mr, Q >= dev − Mf ∧ ...`
contains **no evaluation point for Q** — the witness is free. The witness
is what the audit packs: the day-010 d4d3 audit protocol evaluated the
LHS/zero/def sides at **straddle points** of the candidate height (g±ε),
never at the pole g itself (R is singular there). So:

  (a) **window-min** (P1.1c as originally run: min over the 0.5-step
      window of |ζ|·floor_R/(B+resid)) — over-strict: tests points where
      |ζ| → small (zeta minima), fails for the wrong reason (0.24 at the
      10³ anchor where the day-010 audit found the 14× class).
  (b) **pole form** (P1.1d: K^no-g(g)·off4(g) vs B(g)+defect(g)) —
      C1a-exact but ~(d/g)²-class (1e-10 at g~1e3, d~0.005): positive
      (C1a true) yet BELOW the P4 floor (0.044 at 1e3) — the pole mass
      does not power a squeeze. The day-021 spec sentence "the closure
      is evaluated at the pole where C1a gives the exact value; the
      window floor is non-critical" was an over-read of the free-witness
      statement. **Correction (this log):** the closure witnesses are
      realized at straddle points; the C1b window-floor context is the
      closure's zero-side input (it is NOT demotable); C1a remains a
      true pole-branch characterization, not the squeeze engine.
  (c) **best-straddle** (P1.1e: max over the window of
      |ζ(t)|·min_δ|R(g,δ,t)−1|/(B(t)+resid(t))) — the closure-faithful
      statistic (witness t_eval free = best straddle).

### 21.2 — The corrected trend (best-straddle, bridge-true zero side)
`scripts/rh/day022_p11e_straddle.py` → `out_day022_p11e_straddle.txt`:

  g~      best_margin   argmax t    E(t_best)   def side
  999.79  122.1         988.29      −0.001      B+0.0065 sound
  5000.2  33.1          5004.73     −0.023      B+0.249  sound
  7500    16.2          7507.1      −0.042      defect growing
  10000   10.2          9997.6      −0.083      defect growing
  15000   4.56          15011.5     −0.188      defect > B
  20000   2.30          19996.6     −0.349      defect-dominated
  30000   0.753         29994.2     −0.831      defect-dominated
  50000   0.054         49989.9     −2.97       (f−1)|ζ| = 40.4
  75000   0.001         75009.9     −7.39       (f−1)|ζ| = 1552
  100000  3.42          100011.2    +0.32       (f−1)|ζ| = 4.6

  **Crossing 1 at T\* ≈ 2.5×10⁴.** Diagnosis: the ZERO side
  (|ζ|·floor_R) stays O(1–17) all the way — no visible decay of the
  squeeze's zero side. The deficit side is the measured composite defect
  (f−1)|ζ| with f = e^{−E} the log-convex (B,∞) model inflation of
  DISCOVERY_LOG 20 (E: −0.001 → −7.39 over the band). **The crossing is
  the composite-kernel model error, not the squeeze.** The composite is
  the closure's object of analysis (Q, Mf, Mr are all composite-relative);
  when it is bad (t/B large), the squeeze is unmeasurable through it no
  matter how the statistic is written.

  Verified-regime anchors hold: 122× (10³, day-010 14× class at the
  specific audited straddle; 122× is the best over the ±12 window) and
  33× (5e3, consistent with the 33.9864 pin's 34.68 window record).

### 21.3 — Consequence (pre-registered rule, honest reading)
The tripwire ("corrected own-height margin < 1 in verified regime") did
NOT fire: in the regime where the composite is sound (|E| ≲ 0.1,
t ≲ 2×10⁴ at B = 6e6) the best-straddle margin is 2.3–122 — no crossing.
The 2.5×10⁴ crossing is a **composite-validity boundary** (t/B = 1/240
there, (t/B)² growth per DAY-010 D1), not a route-A death signal. The
true trend above 2.5×10⁴ is UNKNOWN with B = 6e6 (masked).

**Repair, now running** (locally, 32-core, ~1.5–2 h wall per measured
7.2e4 samples/s per process — inside the owner's ≤1-day local rule):
`scripts/rh/day023_ext1e7_supervisor.py` (+ `_seg.py` worker), 32
parallel P-0.8-compliant flip-walk segments covering (6e6, 1e7]
(DT=5e-4 + DT2 twin certificate; twin floor 0.002300 re-measured from
the certified 6e6 list; engine gate numpy-vs-host < 1e-6 per segment).
Output: `zeros_T10000000_ext_full.txt` (~21.1e6 zeros; merge + N-main
check at completion). With B = 1e7: t/B = 1/10 at t = 1e5 (sound),
1/40 at 2.5e5 — the P1.1e re-run on the repaired list answers
DEFINITIVELY whether the true squeeze survives 2.5×10⁴→1e5 (the
T\* question), after which P1.2 (uniform theorem, the open-math part)
takes the trend data as its empirical premise.

### 21.4 — Trivial-zero channel (owner question, probed, closed)
"Does an off-line zero show at the trivials?" — the channel is real but
weak and is NOT a contradiction route: at s₀ = −2k the nontrivial-zero
product is pinned to a zero-set-independent constant
(ζ′(s₀)/main′(s₀), all three cross-verified to < 1e-8: closed form,
mpmath diff, one-sided diff — `day022_trivial0_probe.py`,
`out_day022_trivial0_probe.txt`); a single off-line zero at height t
moves that pin by O(k·δ/t²) (1e-8 at t = 1e³, 1e-14 at 1e⁶) — the
own-height C1a channel is ~1e3–1e6× stronger per zero. Side value
retained: the probe is an independent machine audit, and it confirmed
the DISCOVERY_LOG 20 localization — the 12M product machinery is
honest at low heights (composite at s₀ = −2 within 6.7% of the
zero-set-invariant target, degrading 20.3% at −4 and 37.5% at −6 in
step with the t/B tail-model E-curve, not a machinery bug).

## 22 — day-023 — pin machinery fully resolved; PinCensus certified;
## the day-022 "6.7% pin gap" retired (probe artifact, not a defect)

### 22.1 — The pins are correct (three independent routes agree)
The trivial-zero pin constants c_k := P(−2k) = ∏_ρ(1−s/ρ)e^{s/ρ},
evaluated at s = −2 via three independent routes, agree:
  (i)  **bridge-verified kernel**: e^{A(s)}·∏(pairs)·tail matches ζ(s)
       to 3e-9 at s = 2 (vs ζ(2) = π²/6 = 1.644934066848..., the
       "suspicious number" — it is the Basel constant, not φ; the 3e-9
       agreement IS the self-check) and at s = −1.999 (K/ζ =
       0.999999997);
  (ii) **zeta-derivative pin**: c_k = ζ′(−2k)/[d/ds e^{A(s)}]_{s=−2k},
       ζ′ from the CONVERGED dps-50 central difference
       (ζ′(−2) = −0.030448457058393...; mp.diff at dps-40 is NOT
       reliable for this);
  (iii) **direct pair product** over the 12.19M list (longdouble):
       P_B(−2k) agrees with (ii) to −3.4e-9 (k=1) .. −3.5e-7 (k=10),
       k²-shaped and NEGATIVE — the sign/shape of a tail-model
       higher-order correction (0.2% of the leading (B,∞) tail
       4k²·(ln(B/2π)+1)/(2πB)), not a list defect (a missing pair
       would give a POSITIVE +4k²/t² signature).
  **The day-022 probe's "6.7%/20.3%/37.5% gaps at s₀ = −2/−4/−6" is
  RETIRED**: it compared a probe-path composite (its own tail
  quadrature included) against the pin; the TRUE gap between the
  12M product and the pin is ~1.6e-6 (float64, k=1) — i.e., none.
  The "E-curve tracking" narrative of 21.4 is accordingly withdrawn
  as an explanation of those gaps; the probe remains a valid
  low-height cross-check of the machinery.

### 22.2 — PinCensus (owner's trivial-zero idea, realized)
`scripts/rh/day023_pincensus.py` → `out_day023_pincensus.txt`:
  R_k = P_B(−2k)·(1+tail_model_k)/c_k − 1:
       k:    1      2      3      5      10
  R_k: −3.4e-9 −1.3e-8 −3.0e-8 −8.5e-8 −3.5e-7   (= k² tail correction)
  The channel: an off-line pair's PIN signature is
  (4k²/t²)·(count, d-blind) + (4kd/t²)·(off-line, d-sensitive); the
  d-sensitive part is buried under the truncation/model floor for
  t ≳ 30(k=1)..100 — **not an off-line detector** (the own-height
  channel is ~10³–10⁶× stronger). What the pins DO: an independent
  completeness census — a missing/extra pair at height t shifts
  R_k by +4k²/t², detectable over t ≲ 2·sqrt(k²/|R_k|): ~2×10³
  (k=1) .. ~10⁴ (k=10) at the current floor. **The 12.19M list is
  independently certified on this channel** (no positive k² spike).
  The P-0.8 walk to 1e7 (running, ETA ~2 h) will be re-censused the
  same way after merge — a second method independent of the walk's
  own N(t) checks.

### 22.3 — Arithmetic bug record (why the confusion)
The (1+γ/2) factor of the kernel main is **1.2886078** (γ/2 =
0.288608), not 1.154431 (repeated hand-eval error this day); and
the half-product over t>0 zeros relates to the full product by
squaring: |∏_{t>0}(1−s/ρ)e^{s/ρ}|² = P(s) for real s — a 4.5%
"gap" was exactly the missing square (1.046926² = 1.0960635 = c_1
to all printed digits). Both errors are code-checked now (script is
the single source; hand arithmetic retired).

## 23 — day-023 — CONSIDERED (owner intuition probe, no stick): the
## F-shell "closed under addition" route — Zeckendorf is the reference,
## the loop type-checks false, the transposed kernel is the PinCensus

Owner walk-thought (2026-09-13): "Fibonacci groups are closed under
addition — F-numbers up to n construct all members of each n_x shell by
addition; hypothesize off-line primes must belong to an F-shell; an
off-line number would be not-closed by addition for its shell —
contradiction."

- **The solid reference (missing one) exists and compiles in our
  toolchain**: Zeckendorf's theorem (Zeckendorf 1972) — every positive
  integer = sum of distinct NON-CONSECUTIVE Fibonacci numbers, uniquely;
  equivalently every m in [1, F_{k+1}) is additively constructed from
  F_2..F_k (max non-consecutive sum with F_2..F_k = F_{k+1} − 1).
  `Mathlib.Data.Nat.Fib.Zeckendorf` (`Nat.zeckendorf`) verified on disk
  in our pinned v4.33.1 mathlib. The sharp "closed under addition"
  version: addition in φ-based Ostrowski numeration is a finite-state
  computation for the quadratic base φ (Baranwal–Schaeffer–Shallit,
  arXiv 1407.7000; Schmitthenner) — geometrically: bounded carries,
  Sturmian/golden-rotation/cut-and-project (φ-quasicrystal) geometry.
- **Where the loop breaks (exactly)**: step "off-line ⇒ additively not
  closed" is false for EVERY integer — Zeckendorf is unconditional (it
  sees no ζ, no RH). Off-line zeros produce, per the explicit formula,
  −x^ρ/ρ in ψ(x) — a log-scale OSCILLATION (x^β·cos(t log x) bias of
  prime position), not an additive DEFECT. Dirichlet/log-scale algebra
  vs additive-monoid algebra: the bridge proposition is asked for free
  and does not exist. Off-line = bias, not defect. (On-line analogues:
  Littlewood's prime-counting oscillations; the S(t) wobble in our
  closure is the zero-side face of the same oscillation.)
- **The transposed kernel (real, measured, already designed)**: in the
  algebra where off-line zeros DO leave a trace (P(s) at trivial
  points), "shells + additive closure" is exactly the PinCensus: each
  k ∈ {1,2,3,5,10} is a shell and the same off-line pair contributes
  −4k/t + 4kδ/t² — the SAME term, LINEAR in k, in every shell; the
  census tests precisely that additive coherence. Measured null result,
  all five shells (R_k all negative, k² tail-model terms, no +4k²/t²
  missing-pair signature), three-route-verified pins, 12.19M certified
  zeros. Coincidence noted honestly: {1,2,3,5} ⊂ {1,2,3,5,10} are the
  Fibonacci numbers 1,2,3,5 — the design needs no F-ness (k-linearity
  is in the identity), but it is where the hunch touched.
- **Geometry, measured**: zero ladder is log-structured (γ_k ~ 2πk/
  log(2πk), GUE gaps to 10²⁰ per Montgomery–Odlyzko; our list
  reproduces it, twin floor 0.002300) — an F-shell is a binning of a
  log ladder, not its native scale; no φ self-similarity exists to
  exploit. No computation needed this turn.
- **The right habitat for "not-closed" fib structures is a finite
  quotient** (owner's own verified law, wiki 2026-08-28): c ≡ 3 (mod 5)
  does not merge into the main 20-cycle of the fib-pair dynamics, it
  closes on its own 4-cycle — a verified orphan component. On the ζ
  side the finite-quotient habitat is residue bias/oscillation, again
  not additive defect.
- **Verdict**: not an RH route in literal form (step-3 falsehood is a
  type mismatch, not a missing bound); the kernel is transposed and
  already measured null. Banked reference: Zeckendorf 1972. No tripwire,
  no stick, no parked compute.

Full note: working tree
`kainos-logos/.../rh-attack/spec/fib-shell-probe.md`.

### 23a — owner round-2 refinement (2026-09-13, same day): the exact
"closed under addition" reading = "F_6's elements must be made of <=
F_5" (7 = 5+2 witness) — CONFIRMED as Zeckendorf with endpoints; the
loop's obstacle is one bridge sentence ("off-line => additive
not-closure"): individual integers never drift (primality is
membership, zeta-invariant; off-line is a count-bias region) and the
closure is unconditional (not-closedness is the EMPTY SET in every
world). Strongest predicate extracted: "closed within its OWN shell" =
Fibonacci prime (real, non-vacuous, the owner's 7 fails it, but RH-
constant — holds for almost all primes always). The idea is TRUE on
the transposed scale: the off-line zero's "n_x shell" is its
oscillation period [e^t, e^{t+2pi}) and the failure is period-closure
on a GROWING amplitude x^beta, beta > 1/2 — that IS our C5/C5b
content (S(t), B(t), BSY-1 aggregate 2d/gamma^2 <= 6.5e-5, PinCensus
shell coherence). Full note: working-tree spec/fib-shell-probe.md §6.

### 23b — owner round-3 (2026-09-13, same day): the object corrected
to the off-line zero's OWN components ("prime factors or other
components not closed under addition for their F-shell"). Laid out:
the zero's only natural labels (index k, Gram number) carry no
contradiction — additive closure of naturals is unconditional and
zeta-invariant; its real coordinates (d, gamma) have no factorization
(believed transcendental). Final one-sentence wall: NO form of zeta
(canonical product / explicit formula / functional equation — all
three checked) contains a term reaching an additive-DEFECT
predicate; the established zeta->additive channel is the circle
method (Vinogradov family) and it runs counting/oscillation ->
additive THEOREM, not zeta -> additive DEFECT; the defect side is
empty (Zeckendorf). The corrected sentence, TRUE and measurable:
"an off-line zero's d-component would be unclosed by COUNT in its
shells" — per-pair 4kd/t^2 in the k-census (buried t >~ 30..100, the
PinCensus depth limit) + 2d/gamma^2 in the ladder integral (no
burial, BSY) — and the measured absence IS the certificate: COUNT
null (no +4k^2/t^2 spike, k=1..10, 12.19M certified, 3-route pins) +
d null (Sum 2d/gamma^2 <= 6.5e-5, 3-sigma). Three rounds =
triangulation: the owner re-derived the PinCensus/BSY design logic
from a closure intuition (shell -> k-shell; addition -> count;
off-line prime -> off-line zero's components); the last mile is a
certificate, not a contradiction — which is the publishable content.
Full note: working-tree spec/fib-shell-probe.md §7.
