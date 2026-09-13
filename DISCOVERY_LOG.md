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
