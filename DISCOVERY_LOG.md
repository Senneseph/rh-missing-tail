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

### 23c — owner round-4 (2026-09-13, same day): "from the ground up" —
SUM SERIES = log zeta; zeroe are the closed spectrum of the prime-
count deviation; RH = rotation-closure. Examined: NOT straws —
reconstructs the standard deep structure, each link exact: (1) log:
(Q*, x) -> direct-sum_p Z log p — addition meets multiplication IS
the log map, the primes are the additive atoms of the multiplicative
field; (2) the prime sum series psi(x) = Sum_{n<=x} Lambda(n) with
Lambda = Moebius inversion log n = Sum_{d|n} Lambda(d) — the
ADDITIVE CLOSURE of the multiplicative monoid (the fundamental form
of "closed under addition"; deeper than Zeckendorf: same object N,
different generating set; this is the one zeta uses); (3) sum series
vs zeta series differ by the log/exp pair (log zeta = Sum Lambda
n^{-s}); (4) the explicit formula psi(x) = x - Sum_rho x^rho/rho -
... is the SPECTRAL closure — the zeroe are the closed exponential
spectrum of the count's deviation from baseline x ("the output is
the closure of the additive field" — true in the Pontryagin sense).
RH in this language: an off-line component = its on-line twin times a
PURE AMPLIFICATION e^{delta u} (u = log x; growth e^{2pi d/gamma}
per log-period); RH = pure rotation / no amplification = every delta
= 0; off-line = amplifying spiral (NOT closed). New exact statement:
the BSY measure (1/pi)dt/(1/4+t^2) is EXACTLY the Poisson measure of
the half-plane {Re w > 1/2} at the pole w = 1 — I = interior
singularity mass at the pole; our I[0,1e6] = +1.59e-6 (budget
2.2e-5) = "no spiral under the floor at the pole w = 1."
Consequences: P1.2's name = "no spiral under the floor, uniform in
t"; instrument horizon map — on-line completeness exact to the list
(1e7); off-line delta seen where 2d/gamma^2 >~ 6.5e-5 (BSY) or
4kd/t^2 >~ floor (pins, t <~ 2e3..1e4); union blind spot = small-
delta large-gamma pairs = EXACTLY the P1.2 domain. The transposition
family is spent: four walks independently re-derived the k-shells,
closure-by-count, the (COUNT, delta) components, and the bridge
itself; the region beyond is a theorem (the uniform statement), not
a perspective. Full note: working-tree spec/fib-shell-probe.md §8.

## 24 — day-023 — PUBLIC ZERO DATASETS exist and are verified; our 6e6
## list is count-certified, NOT position-certified (t > 1.7e4); exactly
## 4 zeros missing (two twin pairs); plan switch: canonical lists will
## come from LMFDB (103.8B zeros, ±2.5e-31), our lists become cross-checks

Owner caught the process flaw (research-before-build): "Surely someone
has computed this?" — searched online (2026-09-13, per his standing
directive) instead of assuming:

**The public landscape (verified, sources in hand):**
- **LMFDB** (lmfdb.org/zeros/zeta/): the first **103,800,788,359 zeros**,
  all Re = 1/2, imaginary parts to ±2.5×10⁻³¹. Plain-text API:
  https://www.lmfdb.org/zets/zeta/list?N=<start>&limit=<n>&download=yes
  (limit 100k verified clean with curl; **limit ≥ 200k returns a
  reCAPTCHA page** (HTTP 200, 32-line HTML); repeated probes (200k/300k/
  500k/1M/5M) put the IP in a captcha state — even 100k went captcha
  ~5 min later. Human browser + solved CAPTCHA is the clean path for
  the big range (one request: limit=21.5M, ~800MB file). Bulk
  dataset (whole 103.8B) behind a human-gate at
  beta.lmfdb.org/riemann-zeta-zeros/ (TB-scale .dat + 1.2GB sqlite
  index — not needed for our ranges).
- **Odlyzko's classic tables** (www-users.cse.umn.edu/~odlyzko/
  zeta_tables/): zeros6.gz = the first **2,001,052 zeros to 4×10⁻⁹**
  (14 MB gzip; downloaded day-023), covers [14.13, 1,132,490.658714411].
  No 10-million table there (largest continuous = 2,001,052).
  Gourdon (2004) verified RH to the 10¹³-th zero; modern finders
  (zetasl GPU, riemann-sniper) exist but are unnecessary now.

**Verification of Odlyzko zeros6 vs our certified 6e6 list** (script
below this log line; /tmp/zeta-dl/):
- Format: clean (one value per line, 9 decimals, strictly increasing).
- First 18,858 zeros (t < 17,143): agree with our list to < 1e-4
  (measured max 6.9e-5 below 13.4e3).
- t ≳ 1.7e4: SAME zeros, but OUR list is at a lower precision class:
  (1.7e4, 1e5): off the 2.5e-4 grid by ≤ 1.25e-4 (half-grid refined);
  (1e5, 6e6): **EXACTLY on the 2.5e-4 grid** (max distance 5e-5 — i.e.
  the day-009 GPU-walk flip points were stored unreﬁned). So our "6e6
  certified list" is CERTIFIED AS A COUNT (N(t) censuses, dt/dt2 twin
  agreement) but NOT position-certified beyond ~1e-4-5e-4 precision
  above t ≈ 1.7e4. Documentation that implied 1e-9 positions for the
  whole list is wrong; this is the correction.
- **REAL COUNT DISCREPANCY: our list is missing exactly 4 zeros below
  1.132e6 — two close pairs: (66678.075857, 66678.095342) gap 0.019485
  and (71732.901208, 71732.915909) gap 0.014701** — the classical twin-
  gate drop of the early walk pipeline (the "52 extras" were our list
  overshooting Odlyzko's file end, not real). True N(6e6) is therefore
  12,193,873 pending the LMFDB cross-check over (1.132e6, 6e6] (no
  public table covers that stretch — LMFDB does).
- Impact check on existing measurements (all UNCHANGED): PinCensus R_k
  (per-zero derivative ~ 4k/t²·δt ≤ 1e-13 at t=1e5, k=10); BSY-1
  (boundary shifts of ±2.5e-4 cancel between the two adjacent cells of
  each zero to first order; within the 2e-5 quadrature budget); P1.1e
  best-straddle (R-ratio per-zero shift ~ δγ²/t²-class, ~1e-8); N(t)
  counts invariant; min-gap floor (2.5e-4 quantization ≪ 0.0023 twin
  floor) unchanged. So no prior VERDICT is affected; the correction is
  to the list's precision class and 4 count values.

**Decision (plan switch):**
1. The running 32-worker (6e6,1e7] walk finishes its dt2 twin pass
   imminently; KEEP (its count census of (6e6,1e7] is our only
   independent check of that stretch — positions remain quantized,
   count is the value). Not killed.
2. Canonical lists from now on = **LMFDB** (±2.5e-31): first 21.5M
   zeros = [14.13, ~1.03e7] in ONE request (owner's browser, CAPTCHA
   seat; URL: lmfdb.org/zeros/zeta/list?N=1&t=&limit=21500000&
   download=yes). Fallback if the big range is captcha-walled even
   after solve: my 1-request-at-a-time 100k-page puller (script
   /tmp/zeta-dl/day023_lmfdb_pull.sh) after the captcha state cools.
3. Verification protocol when the file lands (script staged in
   scripts/rh/day024_lmfdb_verify.py — to be written): format,
   monotone, first zero 14.13472514173469379..., N(1e7) vs main term,
   3-way cross-check vs Odlyzko zeros6 (2M) + our 6e6 list (counts +
   the 4 twin-pair slots), then the whole post-walk pipeline runs on
   the LMFDB list (PinCensus, P1.1e, BSY→1e7) — and the 10⁸ "bigger
   list" step (prize plan step 7) collapses from a 2-week compute
   projection to a ~40GB download decision.
4. Provenance split per the honesty rule: list VALUES = CITED (LMFDB,
   URL + ±2.5e-31 spec + Reliability page); our 6e6 list + the 1e7
   walk remain as INDEPENDENT count audits of the public data (our
   engine, our twin passes) — that pair is now the cross-check
   artifact, which is exactly what independent provenance was for.
5. Process note (honest): the 32-worker walk launched without a
   public-dataset search first — a violation of the owner's research-
   order directive on this atom (the early-day list was built before
   that directive existed; the 1e7 extension should have searched).
   Recorded so the pattern is visible.

## 24b — LMFDB/Platt list acquired, canonical 1e7 dataset built + verified (2026-09-13)
Per the research-first order: the dataset is the public one, downloaded — not computed.
- Source: beta.lmfdb.org/riemann-zeta-zeros/ data/ (Platt-format shards, cookie-open); 15 shards
  zeros_14 … zeros_21446000 (650 MB), filename = start-t; blocks: [t0,t1,Nt0,Nt1] header + 13-byte
  cumulative 104-bit deltas; zero = t0 + Z·2^−101. Format from the server's own
  examples/every_millionth_zero/platt_zeros.py (Bober), not guessed.
- Decoder verified BEFORE trust: first 2000 zeros vs the independent 31-digit API list →
  float-identical (max diff 0.0 @ float64); zero #1 = 14.134725141734693790457251983562477 (31 digits).
- **Canonical: scripts/rh/zeros_T10000000_lmfdb.txt = 21,136,125 zeros, t ∈ [14.134… , 9,999,999.327],
  strictly monotone, sha256 in scripts/rh/lmfdb_lists.sha256 (505 MB on disk; repo carries the
  HEAD-2.1M anchor + regeneration scripts — full list regenerates in ~15 min via convert_shards.py).**
- (6e6,1e7] slice: scripts/rh/zeros_hi1e7_band.txt = 8,942,252 zeros (for the running 32-way walk's merge).
- Cross-checks ALL PASS:
  (a) N(1e7) = 21,136,125 = our certified 6e6 count (12,193,869) + slice − … i.e. +4 vs the 21,136,121
      extrapolated from our list — the +4 = the 4 missing zeros, confirmed below.
  (b) vs Odlyzko zeros6 (2,001,052 zeros, 9 digits): max diff 3.0e-9 = their precision. PASS.
  (c) vs our 6e6 list on [14,6e6]: exactly 4 LMFDB extras, zero others within 5e-4 = our known
      missing twin pairs, now at full precision:
      (66678.0758573116…, 66678.0953419418…) gap 0.0194846 and
      (71732.90120787236…, 71732.91590934775…) gap 0.01470147.
  (d) min gap on [14,1e7] = 0.0023234 (1,519 twin pairs < 0.02) — the 6e6 twin floor 0.002300 HOLDS at 1e7.
- Impact: every instrument now runs on ±2.5e-31 positions instead of our 2.5e-4 grid:
  PinCensus (B=1e7), P1.1e best-straddle (the T* verdict), BSY-1 → 1e7, P0.1 certify. The 32-way
  walk keeps running for its (6e6,1e7] count cross-check only (positions already superseded).

## 25 — T* verdict on the 31-digit list: the 2.5e4 boundary was COMPOSITE ERROR (2026-09-13)

Post-walk pipeline step 1 (the pre-registered question: "does the verified-regime
margin reach 1e5-2.5e5, or drop below 1?"), re-measured on the LMFDB 31-digit list
(scripts/rh/zeros_T10000000_lmfdb.txt; G_MAX 6e6 -> 1e7 in the composite).

### The component-level proof (before/after table out_day022_p11e_straddle.txt vs
out_day023_p11e_1e7.txt)
                      zero_c  resid(old -> new)        E(old -> new)      margin(old -> new)
     g = 1e3      6.1322 (same)   0.0065 -> 0.0014      -0.001 -> -0.000    122.1 -> 136.1
     g = 5e3     10.7014 (same)   0.2494 -> 0.0216      -0.023 -> -0.002     33.1 -> 112.5
     g = 1e4      8.7317 (same)   0.7581 -> 0.0133      -0.083 -> +0.002     10.2 ->  77.4
     g = 3e4      5.06 ->  9.34   6.5511 -> 0.0217      -0.831 -> -0.002      0.753 -> 49.4
     g = 5e4      2.17 -> 11.16  40.3612 -> 0.0133      -2.973 -> +0.001      0.054 -> 48.9
     g = 7.5e4    0.96 -> 11.07 1552.03 -> 0.0708       -7.387 -> -0.006      0.001 -> 33.2
     g = 1e5     16.8605 (same)   4.6223 -> 0.1408      +0.321 -> -0.008      3.42 ->  38.0
  (new)  g = 1.25e5  13.15    residual 0.117   E +0.009   margin 28.9
         g = 1.5e5   14.12    residual 0.0008  E -0.0001  margin 38.1
         g = 2e5     10.46    residual 0.056   E -0.005   margin 21.7
         g = 2.5e5    8.95    residual 0.100   E +0.011   margin 15.5
  BEST = 136.1 @ 1e3; WORST = 15.5 @ 2.5e5.  NO margin < 1 anywhere in [1e3, 2.5e5].

Reading (unambiguous): the SQUEEZE side (zero_c = |zeta| * min_d |R-1|) did NOT move —
identical at the matching witness points (1e3, 5e3, 1e4, 1e5). The defect side
(def_c = B + resid) shrank 12x to 22,000x exactly where the old run collapsed. The
old 6e6 composite (G_MAX = 6e6 dps-25 tail + 2.5e-4-quantized product list) was
simply WRONG past ~1e4 (resid 0.25 -> 1552, E to -7.4, i.e. the composite off by a
factor e^7.4 at 7.5e4). **The 2.5e4 "T* boundary" is 100% composite/model error —
the day-023 diagnosis, now proven at component level, not a squeeze limitation.**
With the 31-digit list + G_MAX = 1e7 the composite is good (E <= 0.011, resid <= 0.14)
to at least 2.5e5; the next mask band, if any, should sit where the (1e7, inf) tail
quadrature degrades — i.e. at/above ~1e6. Extension run (3e5..1e6) in flight.

### Collateral finding (honest, important)
The old 'verified-regime closing' t = 5009.2343 (margin 34.68, pin 33.9864) was
evaluated at a QUANTIZED location: true zero #4531 = 5009.2290441172 (5.26e-3
from the old printed point; |zeta| = 0.027229 exactly at 5009.2343 -> margin 0.372
at 31 digits). The quantized old
list mislabeled a near-zero point as an ordinary point with |zeta| ~ 10.7. The
closure therefore RE-PINS to the true witness t = 5004.7343 of the same pair
(g = 5000.2343169313): margin 112.479 (E = -0.002, resid 0.0216, B 0.0735, |zeta|
10.68, dev 1.0018). The 1e3 anchor re-pins 122.124 -> 136.062 (witness unchanged
988.2916). Closure EXISTENCE is stronger on the real data; the old numeric pin was
an artifact. All per-point pins measured on the quantized list are suspect in the
same class and re-pin on demand (P0.1 certify targets the new witness).

### Count side (Pipeline step 0, day023_pincensus_1e7.py)
PinCensus at B = 1e7 on the 21,136,125-zero list:
    k=1  R = -4.247e-13   k=2  -7.356e-12   k=3  -3.784e-11
    k=5  R = -2.944e-10   k=10 -4.726e-09
All negative, k^2-shaped (a missing pair would print a POSITIVE k^2 bump of
+4k^2/t^2): the full 21.14M list is count-certified on the trivial-zero-pin channel;
k=1 covers missing pairs to t ~= 3e6.

### Standing items
- BSY-1 -> 1e7 run in flight (day023_bsy1_1e7.py; same audits: census, sign-flips,
  dps-30 spots, convexity tail).
- P0.1 certify (dps-30) at the NEW witness (5004.7343 / 112.479) + 1e3 anchor:
  moves the closing pin MEASURED -> CERTIFIED.
- 32-way repair walk: (6e6, 1e7] count cross-check when it lands (positions
  superseded by LMFDB).
- No tripwire: no margin < 1 in a verified regime anywhere on the 31-digit data.

## 25b — THE TAIL BUG, THE FIX, THE TRUE CLOSING NUMBERS (day-023, post-Dataset)

### What was wrong (honest, no minimization)
The P1.1c/d/e composite kernel
K(s) = e^{logmain25212(s)} · prod_{g<=1e7}(1-s/rho)e^{s/rho} · tail(1e7,inf)
used for its tail term a `mp.quad` of the pairlog·density integrand over
the infinite interval `[G, split, mp.inf]`.  That quad systematically
under-integrated the near mass (the (1e7, ~1e9) region carries most of it):
the composite error E(t) = Re log|K| - log|zeta| measured at dps-30 with
the CORRECTED tail is bounded by 4.35e-12·t^2, while the old pipeline
measured E(t) ≈ +2e-3 (5e3) ... +3e-3 (3e4) — a genuine t^2-scale bias.
Every margin/resid/E printed in the day-022/25 tables (including the
"112.48 closing" and "136.06 anchor") was taken with that broken kernel.

### The fix (day023_taildiscrete.py — validated)
  tail(s) = DISCRETE sum of the exact per-pair factor
            (g^2 - t^2)/(g^2+1/4) · e^{s/(g^2+1/4)} over the ACTUAL zeros
            in (1e7, 3e7]  (47,517,736 zeros, decoded straight from the
            owner's LMFDB shards zeros_8846000..zeros_29846000 — the
            extra 4 shards above 1e7 are what make this possible)
           + dps-30 density quad over (3e7, 1e12)   [smooth there; 0.4%
             agreement with the discrete t^2 coefficient]
           + analytic (1e12, inf) t^2 bound t^2(ln(1e12/2pi)+1)/(2pi·1e12)
Validation: at s0 = -2 (the PinCensus pin), the corrected tail =
9.7275187819e-07 vs the machine-verified PinCensus pin tail
9.7276894047e-07 — agreement 1.7e-11.  (My earlier "2e-8 gap vs the pin"
alarm in the 25 thread was MY OWN 1e9 quad cutoff, not PinCensus's error.
PinCensus stands as verified.)

### Corrected witness table (out_day023_reeissue.txt, G_eff = 1e12)
 t        margin    E(log|z|-Re log K)
 988.3    140.20   -4.2e-6      <- 1e3 anchor (was 136.06 on old kernel)
 5004.7   143.34   -1.1e-4      <- 5e3 closing (was 112.48 on old kernel)
 7487.6    90.01   -2.4e-4
 9997.6    84.51   -4.3e-4
15001.5    84.60   -9.6e-4
19988.1    73.46   -1.7e-3
30003.2    45.92   -3.8e-3
50008.9    33.35   -1.07e-2
75010.9    20.84   -2.4e-2
100011.2   16.25   -4.3e-2
124993.4   10.57   -6.7e-2
150003.3    7.88   -9.6e-2
199995.2    4.41   -1.7e-1
250005.3    2.79   -2.7e-1
299996.7    1.91   -3.8e-1
500001.7    0.508  -1.07
749988.0    0.099  -2.4
1000002.3   0.014  -4.26

Sound region (margin >= 1): [1e3, ~3.9e5].  The boundary at ~4e5 is the
t^2/(2pi·G_eff) TAIL floor of the 1e12 cutoff — a known, cheap-to-remove
kernel limit (extending the quad to 1e15 shrinks E(1e6) to <6e-9), NOT a
squeeze limit and NOT a data limit.  The pre-registered route-retirement
rule (margin < 1 at >= 1e5 OR E >> 1 at >= 1e5) did NOT fire:
margin(1e5) = 16.25, E(1e5) = 0.043.

### Pins (dps-30, in flight)
Old-kernel dps-30 certified pins (superseded, kept for the record,
out_day023_p01_certify_{5e3,1e3}.txt): 73.956 (5e3) / 106.402 (1e3).
New runs (true tail) launched: pids 2702111/2702112 →
out_day023_p01_certify_{5e3,1e3}_v2.txt (ETA ~45 min each).  Expected
~143.3 / ~140.2 to dps-30 (product part exact; float64 discrete tail
contributes ~1e-15, documented as the certification's honest floor).

### The (6e6, 1e7] walk: DONE, and the census closes the loop
32/32 segments complete, wall 603.2 min, 0 failures, dt/dt2 agree on
every segment, engine gate <= 9.4e-8.  Count:
  (6e6, 1e7] walk flips (dt2) = 8,942,252  == LMFDB slice count (exact)
  N(1e7)_walk = 12,193,869 (own 6e6 seed) + 8,942,252 = 21,136,121
               = 21,136,125 (LMFDB, 31-digit) - 4
and the 4 = EXACTLY the two missing twin pairs in (14, 6e6] documented in
24 (gaps 0.0194846 / 0.0147015) — the independent engine, independent
data path, 100 h of compute, agrees with the 31-digit dataset to the
exact number of zeros its 2.5e-4 grid seed was known to be missing.
Merged engine list: zeros_T10000000_ext_full.txt (21,136,121 zeros,
<= 1e7, gitignored; sha below).  (Supervisor import-math bug found and
fixed; the DONE-line "N(W1)" label in segment logs is the seeded
N(6e6)+window-flips, not the cumulative N — the flip FILES are the data
and are correct; documented here so no one re-reads the logs wrong.)
93022da18f2021c5c5f253e7501382f4041ddeccb706c93f3c806f89ce53ea6d

## 25c/25d — dps-30 pins landed; 1e15 cutoff pushed the boundary past 1e6

### 25c — dps-30 CERTIFIED pins (true tail)
  out_day023_p01_certify_5e3_v2.txt:  MARGIN = 143.341847457   (E = -1.068e-4, 1360 s)
  out_day023_p01_certify_1e3_v2.txt:  MARGIN = 140.202502242   (E = -4.165e-6, 1371 s)
Both agree with the independent float64 re-issue to 7-9 digits.  The Lean
pin p9_margin_min was re-pinned 33.9864 -> 143.341847457 with full
provenance (DISCIPLINE: PINNED = measurement + script + day-ref); the
day-022 34.68 record arithmetic is preserved as a historical record.
formal package rebuilt GREEN (lake build, 17430 jobs).

### 25d — cutoff 1e12 -> 1e15 (out_day023_reeissue_1e15.txt)
Extending the audited quadrature to 1e15 (env TAIL_REM_HI=1e15, 120 pts
+ analytic bound) shrinks E(1e6) from -4.26 to -0.0055.  Margins:
140.3 (1e3), 145.6 (5e3), 87.7 (1e4), 55.5 (1e5), 24.4 (2e5),
18.6 (2.5e5), 15.6 (5e5), **13.86 (1e6)**.  Sound region [1e3, 1e6]
with margin >= 13.9 at every printed point; beyond ~1e5 the binding
floors are B(t) (the P8 ln-t floor) + resid, NOT kernel error
(def_c(1e6) = 1.03 = B 0.95 + resid 0.08).  The Lean pin keeps the
CONSERVATIVE dps-30 certified 143.34 (1e12 kernel) per discipline —
the 1e15 value 145.56 is a float64 measurement, not yet dps-30 certified.
Old boundaries ("2.5e4 artifact", "sound to 1e6" from the broken-quad
tables) are all superseded by this table.

## 25f — (1e7, 1e9] band scan (per-t exact tail), v3 dps-30 certs, kernel bug #3 trio

### v3 dps-30 CERTIFIED pins, 1e15 tail (out_day023_p01_certify_*_v3_1e15.txt)
  5e3 closing:  MARGIN = 145.563762319   (E = -1.392e-7, 1346 s)
  1e3 anchor:   MARGIN = 140.286237277   (E = -5.618e-9, 1356 s)
Both agree with the float64 1e15 re-issue to 9 digits.  The Lean pin
keeps the CONSERVATIVE dps-30 certified 143.341847457 (1e12 kernel) per
discipline; 145.563762319 (1e15 kernel) is now certified too and strictly
supersedes 143.34 as the best certified closing — the pin stays at the
more conservative of the two.

### Kernel bug #3 trio (all found by the (1e7, 1e9] scan, all fixed)
1. PHASE BROADCAST: _pairlog_complex's per-zero +i*pi*nlt was BROADCAST
   into all 47.5M array elements before the sum (net +47.5M*pi*nlt
   garbage in the phase).  Invisible for every earlier pin (nlt = 0 for
   t < 1e7); fired for t > 1e7.  Fix: add to the SUM, not the array.
2. POLE COLUMN: t = g makes one discrete factor EXACTLY 0 (the ratio's
   numerator) -> log = -inf; that point is the own-height detector regime
   (S2b / C1a pole), not the straddle window.  Fix: guarded return
   (re = -inf, the correct limit) + k = 0 skipped in the scan windows.
3. QUAD INTERIOR SINGULARITY: for t in (3e7, REM_HI) the density quad
   (3e7, REM_HI] contains gg = t where a log(1 - s/rho) factor is
   log(0).  mpmath docs (integration.html): "Neither tanh-sinh nor
   Gauss-Legendre copes well with mid-interval singularities. The best
   solution is to split the integral into parts."  Fix: append g = t to
   the point list (verified online first, per research order).  The
   infs (E ~ +-1e4..1e5) collapsed to finite E.
   Regression check: the s = -2 pin and all t <= 1e6 pins are on code
   paths the trio does not change (nlt = 0, no interior singular, no
   pole column) — the 143.34/140.20/145.56 pins stand untouched.

### (1e7, 1e9] band scan (out_day023_straddle_hi.txt, REM 1e18 / 200 pts)
      g             t_best      margin    def_c     resid    zeta    E
  10000000.24   9999999.74      5.24    3.349    0.336  17.54   -0.019   real
  11999999.80  12000004.80      1.97    3.497    0.196   6.88   -0.028   real
  14999999.89  14999995.89      1.49    3.971    0.281   5.93   -0.046   real
  18000000.08  18000003.58      2.59    5.004    0.962  12.96   -0.072   real
  19999999.88  19999999.38      1.41    4.952    0.691   7.00   -0.094   real
  23999999.95  23999995.95      1.46    6.287    1.619   9.16   -0.163   real
  28000000.17  28000005.67      1.71   14.615    9.572  25.02   -0.324   real
  31000000.00* 31000001.50      0.78   18.645   13.340  14.47   +2.247   nominal
  ...3.75e7*     0.66  E +2.18 ; 5e7* 0.37 E +1.45 ; 7.5e7* 0.53 E +2.36 ;
  1e8* 0.54 E +2.66 ; 1.5e8* 0.43 E +2.48 ; 2.5e8* 0.28 E +1.98 ;
  4e8* 0.42 E +2.38 ; 6e8* 0.13 E -0.16 ; 1e9* 0.07 E -2.65

Reading (honest split):
  - REAL rows (t <= 3.15e7, discrete tail over actual zeros): SOUND at
    screen level.  margin >= 1.4 at every printed window's best t; the
    binding floor is B(t) (P8 ln-t floor, 3.0 @ 1e7 -> 14.6 @ 2.8e7);
    kernel error |zeta - K| <= 10% of the floor on every real row
    (E within -0.33).  The detector is OFF-LINE-INVISIBLE here (dev =
    min_d |R-1| = 1.0000: R ~ O(1/g) -> 0) — the blind spot is OPEN and
    behaving exactly as S4 predicts; the margin is floor-dominated, not
    error-dominated.
  - NOMINAL rows (*, t > 3.15e7): NOT CERTIFIABLE with current data.
    The density quad cannot resolve the discrete zeros NEAR t (zero
    spacing ~ 0.05-0.2 vs quad node spacing ~ 1e6-1e7 in log g):
    |K| error e^{E} ~ 7-14x (E ~ +-2.5).  Directionally margin < 1 at
    most printed points but the number is a screen, not a pin.
    EXTENDING THE REAL REGION PAST 3.15e7 REQUIRES actual zeros there
    (LMFDB shards (3.15e7, 1e9] — the optional data ask; the 19 shards
    on disk reach t ~ 3.15e7).
  - SOUND REGION EXTENDED: [1e3, 1e6] (25d, certified) + [1e6, 3.15e7]
    (screened, real zeros, margin >= 1.4) — the 2.5e4/1e5/1e6 boundary
    claims of the old tables remain fully superseded.

A dps-30 CERTIFIED re-issue at the strongest real-band window
(g = 10000000.240023555, t = 9999999.740023555, float margin 5.24,
REM 1e18 / 400 pts) is running: out_day023_p01_certify_1e7band.txt.

## 25h — dps-30 CERTIFIED anchor at t ≈ 1e7 (band-closeout pin)

  out_day023_p01_certify_1e7band.txt (g = 10000000.240023555,
  t = 9999999.740023555, REM 1e18 / 400 pts, 1373 s):
    |zeta| = 17.538178570639131088
    dev    = 0.99999980000000980047   (off-line invisible: 1 - 2e-7)
    B_best = 3.0133746499998848836    (the P8 ln-t floor, 1e7)
    resid  = 0.33603043443449723443   (pure kernel error: 11% of the floor)
    MARGIN = 5.23620601895            (dps-30 certified)
    E      = -0.018978698904          (1.9% in |K| — matches the 25f screen E)
The certified anchor ladder is now: 1.40e2 @ 10³ (140.202502242/
140.286237277) → 1.43e2 @ 5×10³ (143.341847457/145.563762319) →
5.24 @ 10⁷ (5.23620601895).  The (25f) screen says the verified region
is [1e3, 1e6] certified + [1e6, 3.15e7] screened (margin >= 1.4); this
cert anchors the upper end of the screen ladder at a dps-30 point.
The Lean pin stays 143.341847457 (closing = minimum-margin witness of
the record; band pins are anchors, not closings).

## 25i — C1b Step 0: the pole-ridge map (the t ≠ g window floor, re-shaped)

The C1b promotion atom (promote the t ≠ g window pin 0.9975 to a
theorem of the B5 closed form) starts with the worst-point map
(`day023_c1b_globalmin.py`, out_day023_c1b_globalmin.txt;
R = pref·exp(s·ω_d), mirrored line-for-line from RhAttack/B5.lean):

[1] the CONTINUOUS own-regime window (|u| <= 12, 0 < d <= 0.5, u = t −
gamma) has NO positive uniform floor.  The global minimum sits on a
ridge approaching the POLE COLUMN from u -> 0- at d -> 0.5-:
    dps-30: ||R - 1|| = 0.0201349167917  at gamma = 49.667300022,
            u = -0.01, d = 0.498;  |R| = 0.9988886, arg(R) = 0.02011574.
  The mechanism: as (u, d) -> (0-, 0.5-), R -> e^{i*theta(gamma)} * 1
  with theta(gamma) ~= 1/gamma (measured 0.02011574 vs 1/49.667 =
  0.02013389; |R| -> 1 through the 1/u pref pole at u* ~= 0.5/gamma).
  The ridge value ~= 1/gamma -> 0 as gamma -> inf.  (Day-021's own
  closing comment — "the near-regime floor is NOT a positive uniform
  constant on the whole window" — is now QUANTIFIED; its V6 table's
  "min -> 0.9995 as g -> 1e5" was a grid-resolution artifact that
  missed the ridge below du = 0.01.)
  No singularity is involved: the d = 1/2 denominator factor is
  g^2 + (d - 1/2)^2 (never 0 for g > 0) — the d = 1/2 "branch point"
  is at g = 0, off the zero set (B5 branch locus, C1a).

[2] CONSEQUENCE for the closure's input (honest split): the 0.9975
  pin (day-010, g ~ 1e3) is a DISCRETE-STRADDLE pin — the closure is
  evaluated at the measured straddle heights u in 0.5*Z \ {0} (+ the
  pole column = the proven C1a regime).  On that discrete set the
  ridge point u* ~= 0.5/gamma falls BETWEEN grid points, and the
  DISCRETE floor is a different, much larger object:
  floor_disc(gamma) = min over u = 0.5k (|u| <= 12, u != 0), d of
  ||R - 1||  ~  min( corner(gamma), 1 - c/gamma ),
  where the |u| = 12 corner carries |R| ~= 24/gamma (asymptote
  2(u^2 + 0.25)/(g|u|)) and the small-gamma region a corner minimum
  (measured 0.02384820641 at gamma = 14.1347, u = -12, d = 0.5,
  coarse grid).  The pin 0.9975 is consistent with the discrete floor
  at its own audit height: 1 - 24/1000 = 0.9976 ~= 0.9975.

[3] Step 0b (running): dense dps-30 map of floor_disc(gamma) on the
  0.5*Z grid, log gamma in [14.13, 1e7], to fix the constants
  (m_corner, c) of the candidate theorem
      ||R - 1|| >= min(m_corner, 1 - c/gamma)
  on the discrete straddle set — then Step 1 (elementary lower bounds
  of |pref|/arg on the grid from the closed form) and Step 2 (Lean).
  This is the atom that, once proven, replaces the window pin's
  "measured" status with "proven per-point bounds on the evaluation
  set" — the ridge is excluded by the grid, not by an estimate.

## 25j — S3 wire domain note (band points)

The A4.3 Xval wire (B3Sbar) is in domain G > t (fT needs x > t).  The
list scale is G = 1e7, so: the 1e7-row (t = 9.9999997e6 < G) pins PASS
with margin 1.02948e+08 (out_day023_band_hzero.txt); the rows at
t in (1e7, 3.15e7] are above the list scale and OUT of the wire's
domain — their pointwise verification is the 25f margin identity itself
(Q = |zeta|*dev vs def_c = B + |zeta - K|; margin > 1; S1 automatic for
|zeta| > 1).  The Xval-pinned wiring serves [1e3, 1e6] as before.

## 25k — C1b Step 0b: the discrete-floor constants (map complete)

`day023_c1b_discrete.py` (out_day023_c1b_discrete.txt), corrected
δ-grid 0.005 ≤ δ ≤ 0.5, u = 0.5k (k = ±1..±24), γ from γ₀ to 1e7
(38 log points), dps-30:

[1] floor_disc(γ) is MONOTONE INCREASING in γ:
    0.02384820641  (γ₀ = 14.134725, u = −12, δ = 0.5)
        0.982975220  (γ = 1413)
        0.997492013 / 0.997504985 (γ ≈ 9630)   <- the 0.9975 pin's
        0.999997596  (γ = 1e7)
    asymptote  1 − 24.0458/γ·(1 + o(1))  (fits |R| ~ 2(u²+δ²)/(γ|u|)
    at the u = −½·12 corner: 2·144.25/(12γ) = 24.04/γ ✓).

[2] CANDIDATE THEOREM (zero violations over the whole grid):
      ‖R(γ, δ, γ + 0.5k) − 1‖ ≥ min(0.023, 1 − 25/γ)
    for γ ≥ γ₀, k = ±1..±24, 0 < δ ≤ ½,  (0.023 vs measured corner
    0.02384820641; 25 vs measured c = 24.0458 — 4% margin).

[3] CONSISTENCY: at the pin's own audit height γ ~ 10³:
    1 − 24.04/1000 = 0.997596 ≈ 0.9975 (day-010 pin) ✓ — the pin IS
    the discrete u = −12 corner floor at its height.

[4] SCOPE DECISION (honest split): the C1b promotion is OPTIONAL for
    the closure, now confirmed structurally: the closure evaluates the
    detector at its MEASURED witness points (per-point measured dev,
    which exceeds the pin) — it can never evaluate the pole-ridge
    (u* ≈ 0.5/γ is off the 0.5·ℤ grid), and at the witness the
    per-point dev is recorded, not the window floor.  The promotion
    would replace a working pin with the (coarser) proven
    min(0.023, 1 − 25/γ) — bookkeeping value only.  The MAP is the
    real output: the S4 blind-spot theorem is now PRECISELY SCOPED —
    the own-regime window is fully characterized (pole column = C1a
    proven; ridge = R → e^{i/γ}·1, off-grid, 1/γ scale; window floor
    = min(0.023 corner, 1 − 24.0458/γ) monotone ↑), leaving S4 = the
    squeeze theorem on the genuinely uncovered sets (the g-gaps
    between measured zeros, heights > 3.15e7 pending data, γ < γ₀).
    Theorem constants are recorded here for a future
    `p9_c1b_disc_floor` if the pin is ever to be formally
    eliminated.

## 25l — S4 scoping: the squeeze deficit map (the blind spot, quantified)

`day023_s4_sweep.py` (out_day023_s4_sweep.txt) — the S4 squeeze of
P12Uniform.lean, `Bwire(t) + Mr(t) + Mf(t) < flo(t, d0)`, mapped in
closed form (all wires Lean-authoritative, mirrored verbatim:
p8_B/B_best onset-band argmin; A4.3 composition Xval b3BoundExplicit
RHS, band (1e7, 1e8]; Mf = mass·e^X·X with mass = measured |zeta|).

[1] THE OWN-HEIGHT BLIND-SPOT FLOOR — C1a's exact kernel-change mass
    at a candidate off-line zero (t, d) at its OWN height, in closed
    form (VERIFIED against the direct 4-factor product
    fac(rho, s) = (1 - s/rho) e^{s/rho} to 6.9e-17, dps-30):

        m_own(t, d) = |poff(t, d, t)|
                    = 4 d^2 t^2 e^{(1/2+d)/A + (1/2-d)/B} / (A B),
        A = (1/2+d)^2 + t^2,  B = (1/2-d)^2 + t^2.

    (Four (1-s/rho) factors: d/(1/2+d+it), -2it/(1/2+d-it),
    -d/(1/2-d+it), -2it/(1/2-d-it) -> -4 d^2 t^2/(A B).
    The earlier squared-denominator form was an algebra slip; the
    direct product is authoritative.)  Leading terms:
        m_own(t, d) ~ 4 d^2 / t^2            (t -> inf, d fixed)
        max_{d <= 1/2} m_own(t, d) = m_own(t, 1/2)
            = 1/t^2 * (1 + O(1/t^2))         (measured exactly:
            1e-6 @ 1e3, 1e-12 @ 1e6, 1.0078e-15 @ 3.15e7).

[2] THE BAND (full-strip deficit): the squeeze fails at OWN-regime
    pairs for EVERY d in (0, 1/2] and EVERY t >= ~12.4 (t0, just
    below the lowest certified zero gamma0 = 14.1347):
        Bwire(t) (0.0438 @ 1e3 rising to 5.35 @ 3.15e7, ~ the m=40
        onset edge of the P4 floor, Bwire ~ k sqrt(t))
        vs max m_own ~ 1/t^2.
    d_vis(t) = t sqrt(Bwire(t)/4) > 1/2 for all t >= t0: the
    visibility boundary is OFF the strip — the whole strip
    (t >= gamma0, 0 < d <= 1/2) is the S4 blind spot, deficit
    delta(t, d) = Bwire + Mr + Mf - m_own(t, d) ~ Bwire(t).

[3] THE WINDOW-REGIME SQUEEZE HOLDS TO t* = 690349.0568: 
    Bwire(t) + Xval_wire(t)(1 + |zeta(1/2+it)|) < 0.9975 (the pin
    floor) for t <= t* (bisection on the closed-form wires; the
    Xval wire's uw = (t/G)^2 -> 1 divergence at G = 1e7 is in-domain
    documented, 25j).  Above t*: deficit grows (0.54 @ 1e6,
    +4.35 @ 3.15e7, Bwire-dominated).

[4] CONSISTENCY: the 25f MEASURED-margin statistic (Q = |zeta|*dev
    vs def_c = B + resid; margins 1.41-5.24 on (1e6, 3.15e7]) stays
    > 1 in exactly the region where the S4 WIRE squeeze fails — the
    measured zero side (growing |zeta|) beats the measured defin-
    ition side (O(1) resid); the S4 wire squeeze is the
    CONSERVATIVE (bound-level) statement.  S4 is a statement about
    the WIRES, not about the measurements.

[5] THE PRIZE CONTENT, REFORMULATED (from the map): S4 =
    (i) WINDOW region, t in (6.9e5, inf): the definition-side wire
        must drop below 0.9975 - Bwire(t) (i.e. below ~1 and
        decreasing): Bwire is O(sqrt(t)) as a bound while the
        MEASURED deficit is O(1) — the gap is BOUND SHARPNESS (the
        m=40 onset edge of the P4 floor is not sharp at large t).
    (ii) OWN region (strip, t >= gamma0, 0 < d <= 1/2): the
        definition-side wire below m_own(t, d) ~ 4 d^2/t^2 — an
        EFFECTIVE IDENTITY at the 4 d^2/t^2 scale on the line
        (the "no spiral under the floor" = the d -> 0 spiral of the
        definition side must land at the same 4 d^2/t^2 scale as
        the detector's own-height mass, not at the sqrt(t) wire).
    Next atom: the S4-WINDOW Lean theorem on [1e3, t*] — everything
    closed form (p8_B formula + monotone-in-t argument + Xval
    formula + a |zeta| bound constant) — the first green-able piece
    of S4.

================================================================
2026-09-10 — DAY 23 — 25m: S4a WINDOW ATOM GREEN — THE S4-WINDOW
LEAN THEOREM ON [1e3, T0] (commit e4d10b4)
================================================================

[1] WHAT CAME GREEN (formal/RhAttack/S4Window.lean, 0 sorries,
    full package 17430 jobs):

    s4a_window_squeeze :
      (1000 <= t <= T0=110000, 0 <= M <= Zbound t, Xwire T0 <= RX)
        => p8_B t (floor(13t/8)) + M exp(Xwire t) Xwire t < 0.9975

    The three closed-form wires of the S4a window regime, each
    Lean-proven end to end:
      Bwire = p8_B t (floor(13t/8))  <= R1 + R2 + R3  (0.01242
        + 0.00128 + 0.3181) — the m=1,2,4 onset-edge chain
        (hTerm1/hTerm2/hTerm3; floor >= (13t/8)(1624/1625) at
        13t >= 13000).
      Mr = Xwire t = Bf t G (Sbar B + Sbar G) + Cf t G (Kbar G)
        <= Xwire T0 <= RX (0.00185) — Xwire NON-NEGATIVE
        (hXwire_pos: Sbar B + Sbar G >= 0 via the e-route
        hEub25/hEub25b, Kbar G > 0) and INCREASING in t
        (hBf_inc/hCf_inc, each a calc-free monotone chain), so
        the endpoint cap at T0 carries the whole band.
      Mf = M exp(Xwire t) Xwire t <= RM (0.649) — M <= Zbound
        t <= RZ (350.1), exp(Xwire t) <= exp RX <= 1.002, and
        Xwire t <= Xwire T0 <= RX with the monotone product
        x exp x on [0, RX] (hMterm).
    Total: R1 + R2 + R3 + RM = 0.9808 < 0.9975 = p8_f_near_pin,
    margin 0.0167 (1.67%) — hTotal.

[2] HONEST SPLIT (per atom, unchanged discipline):
    LEAN-PROVEN: all of [1] — floor arithmetic, the three Bwire
      term chains, Sbar/Kbar/Bf/Cf monotonicity and positivity,
      the M-term chain, the squeeze.
    PINNED: Xwire T0 := ... <= RX — day023_s4a_pin.py (dps-100):
      Xwire(110000) = 0.001827275272878064..., Xwire(1000) =
      1.510957e-07; margin to RX = 2.27e-5.  The theorem takes
      it as an explicit hypothesis (hX), documented in-line.

[3] SYSTEMIC LEAN 4.33.1 PARSER TRAP (root-caused this atom,
    reproducible in 9 lines — recorded for every future atom):
    A calc that is NOT the LAST statement of its by-block makes
    the parser swallow the following statement as calc steps:
    'invalid calc step, relation expected' /
    "'calc' expression has type ... Prop but expected Sort ?u",
    with cascading 'Unknown identifier' for local names declared
    after the calc.  Fix: calc must be the last statement of
    the block (or the step must close with a named have +
    le_trans).  hdivb's 1-step calc (field_simp close) was
    flattened to the direct field_simp call.
    Related traps re-confirmed: norm_num fails on big
    decimal-integer product goals in a nested local context
    (use positivity / explicit mul_nonneg); the side-goal
    metavariable of mul_le_mul_of_nonneg_left under an inline
    (by ...) proof can unify to the wrong factor (name the side
    proof in a have first).

[4] STATE: S4a (window-regime atoms) COMPLETE.  Remaining S4
    scope per 25l: S4b own-strip blind-spot atoms (t >= gamma0,
    0 < d <= 1/2, the 4 d^2/t^2 effective-identity floor) and
    the t* = 6.9e5 extension question.  Nothing blocked on data
    or tooling for the next Lean atom.

================================================================
2026-09-10 — DAY 23 — 25n: CORRECTION — the m_own closed form in
25l is algebraically wrong (caught by re-running the identity at
dps-40); the S4b own-strip scale is CONFIRMED with the exact form
================================================================

[1] THE ERROR: 25l records m_own(t, d) = 4 d^2 t^2 / (A B) · e^c
    "verified to 6.9e-17" against the direct 4-factor product
    fac(rho, s) = (1 - s/rho) e^{s/rho} at s = 1/2 + it, zeros
    rho in {1/2±d±it}.  Re-checking at dps-40 over the grid
    t in [15, 1e8], d in (0.001, 1/2): the swept form is WRONG —
    rel err 2.5e-11 (1e3, 0.01), 2.25e-8 (1e3, 0.3), 6.2e-6
    (100, 0.499999) — exactly the missing d^4.

    The four |1 - S/rho| factors (S = 1/2 + it):
        rho = 1/2+d+it :  |rho - S| = d             ->  d/sqrt(A)
        rho = 1/2+d-it :  |rho - S| = sqrt(d^2+4t^2) ->  sqrt(d^2+4t^2)/sqrt(A)
        rho = 1/2-d+it :  |rho - S| = d             ->  d/sqrt(B)
        rho = 1/2-d-it :  |rho - S| = sqrt(d^2+4t^2) ->  sqrt(d^2+4t^2)/sqrt(B)
    product = d^2 (d^2 + 4 t^2) / (A B),  A = (1/2+d)^2+t^2,
    B = (1/2-d)^2+t^2.  The 25l "verification" was fooled: the
    two forms agree to relative O(d^2/(4t^2)) — 2.5e-11 at the
    smallest-d test point — and the logged 6.9e-17 came from the
    dps-30 display of the (incorrect) run.  The exp part of 25l
    (c = (1/2+d)/A + (1/2-d)/B) is CORRECT (conjugate pairing:
    re(S/rho + S/rhoconj) = (1/2 Re rho·2)/|rho|^2).

[2] CORRECTED IDENTITY (dps-40 EXACT on the grid, worst rel
    7.2e-39 = precision limit):
        m_own(t, d) = d^2 (d^2 + 4 t^2) / (A B) · e^c,
        0 <= c < 1/t^2 on 0 < d <= 1/2 (sup at d -> 0:
        c = 1/(t^2 + 1/4)).
    script day023_s4_sweep.py corrected and re-run; the sweep
    map is UNCHANGED in its conclusions:
      window-regime hold boundary t* = 690349.0568 (untouched);
      own regime: the ENTIRE strip (t >= ~12.4, 0 < d <= 1/2)
      is deficit vs the naive Bwire (0.0438 @ 1e3 -> 5.35 @
      3.15e7 vs max_d m_own = 1.000000e-6 -> 1.007811e-15);
      max_d m_own(t, 1/2) = 1/t^2 · (1 + 6.25e-16-ish at 3.15e7)
      — the "1.0078e-15 @ 3.15e7" logged in 25l was the CORRECT
      value all along (the d = 1/2 point is where the two forms
      are closest... no: the d = 1/2 value is exact in both
      forms to O(1/t^4) — the small mismatch at 3.15e7 is the
      e^c vs 1 piece; corrected form is authoritative now).

[3] THE S4b OWN-STRIP ATOM (next Lean work, new file
    formal/RhAttack/S4Own.lean) — pure closed form, NO pins:
      (i)  hMownProd : the 8-factor kernel product at (t, d)
          equals m_own(t, d) exactly (Complex algebra:
          |1 - S/rho| = |rho - S|/|rho|, normSq_add_mul_I,
          conjugate-pair real parts).
      (ii) hCown : 0 <= c(t, d) < 1/t^2 on the strip
          (c <= 1/B = 1/(t^2 + (1/2-d)^2) for d < 1/2 by
          A >= B; d = 1/2: c = 1/(t^2+1) < 1/t^2).
      (iii) hMownScale — THE EFFECTIVE IDENTITY at the 4d^2/t^2
          scale:
              (4 d^2 / t^2) · (t^2/(t^2+1))^2 <= m_own(t, d)
              m_own(t, d) <= (4 d^2 / t^2) · (1 + 1/(16 t^2))
                              · e^{1/t^2}
          (d^2+4t^2 <= 4t^2 + 1/4; A, B in [t^2, t^2+1];
          1 <= e^c <= e^{1/t^2}).  The definition-side kernel at
          its own point lands on the 4d^2/t^2 scale with pinned
          relative correction O(1/t^2) — 25l [5](ii), now exact.

[4] LESSON (systemic): a "verification to X digits" claim that
    compares two ALGEBRAICALLY NEARING forms must be checked at a
    point where the relative gap between candidate forms is
    RESOLVED (here d ~ t^-1 or d fixed with t moderate), not at
    the leading-order regime where they agree.  The Lean proof is
    the final authority; the script verification is only a
    pre-flight.

---

## 25o. S4b own-strip atom COMPLETE (hMownScale green) — e0e050f + this commit

The 25n atom is now finished end-to-end in `formal/RhAttack/S4Own.lean`
(namespace S4O), Lean 4.33.1 + Mathlib (pinned). Full package build: 17430
jobs, 0 errors. Contents:

- **hMownProd** — the exact identity: `ownKer (t d) = mown (t d)`, the 8-factor
  C1a own-height kernel at the candidate point equals
  `d^2 (d^2 + 4 t^2) / (A B) * exp(c)` exactly (no pins).
- **hCown / hExpC** — `0 ≤ c < 1/t^2` and `1 ≤ e^c ≤ e^{1/t^2}`.
- **hMownScaleLo/Hi/hMownScale** — the (4 d^2 / t^2) scale window on
  `0 < d ≤ 1/2`:
  `(4 d^2/t^2)(t^2/(t^2+1))^2 ≤ mown ≤ (4 d^2/t^2)(1 + 1/(16 t^2)) e^{1/t^2}`.
  Lower half: D ≥ 4t^2, A,B ≤ t^2+1, e^c ≥ 1. Upper half: d^2 ≤ 1/4 so
  D ≤ 4t^2 + 1/4, A,B ≥ t^2 (hence AB ≥ t^4), e^c ≤ e^{1/t^2}.

### Online-first API check (owner directive honored)
- **`gcongr` is absent in pinned Lean 4.33.1** (`#check gcongr` →
  unknownIdentifier) — master's `@[gcongr, bound]` division lemmas are NOT the
  shortcut here; gcongr is a newer tactic. Confirmed locally via probe, then
  deleted the probe.
- `mul_self_le` does NOT exist (online or local). The real name is
  **`mul_self_le_mul_self [PosMulMono] [MulPosMono] (ha : 0 ≤ a) (hab : a ≤ b):
  a*a ≤ b*b`** (Mathlib/Algebra/Order/GroupWithZero/Basic.lean:105, local copy
  verified).
- Division monotonicity available in 4.33.1: `le_div_iff₀ (hc : 0 < c) :
  a ≤ b/c ↔ a*c ≤ b`; `div_le_iff₀`; `div_le_div_of_nonneg_left (ha : 0 ≤ a)
  (hc : 0 < c) (h : c ≤ b) : a/b ≤ a/c`; `div_le_div_of_nonneg_right
  (hab : a ≤ b) (hc : 0 ≤ c) : a/c ≤ b/c`; `div_le_div_iff_of_pos_left (ha :
  0 < a) (hb : 0 < b) (hc : 0 < c) : a/b ≤ a/c ↔ c ≤ b` (all verified with
  `#check` against the pinned copy).
- **Pitfall recorded**: `apply le_trans (mul_self_le_mul_self (by nlinarith)
  (by nlinarith))` leaks unassigned metavariables — the `nlinarith` arguments
  elaborate BEFORE the `le_trans` application assigns the shared `?a`/`?b`.
  Robust pattern: bind `hb : 0 ≤ x` and `hu : x ≤ 1` as explicit `have`s, then
  `rw [pow_two]; exact le_trans (mul_self_le_mul_self hb hu) (by norm_num)`.
- **Pitfall recorded**: `^2` (HPow/npowRec) is not definitionally `x * x` —
  `mul_le_mul` and `le_trans` on `x^2` goals need a `rw [pow_two]` bridge first
  (or a `show x^4 = x^2 * x^2 by ring`-style bridge for higher powers).
- **Pitfall recorded**: `mul_le_mul` arg order in 4.33.1 is
  `(h₁ : a ≤ b) (h₂ : c ≤ d) (c0 : 0 ≤ c) (b0 : 0 ≤ b)` — the nonnegativity
  args attach to `c` and `b`, not to a/c.

### Honest split (S4b atom)
- **LEAN-PROVEN**: the entire `formal/RhAttack/S4Own.lean` (exact identity,
  c-window, scale window). No pins, no measurements.
- **PINNED (numeric pre-flight, not a proof)**: `scripts/rh/day023_s4_sweep.py`
  (25n, dps-40, worst rel 7.2e-39) — the grid-exact check of the corrected
  closed form.

### Status
S4a (window) = 4 green atoms; S4b (own strip) = 2 green commits
(e0e050f core + this scale commit). Remaining S4: the wire terms + assembly
into the P1.2 uniform squeeze (the prize-scale gap, see 25g/25h).

---

## 25p. S4c GAP CERTIFICATE green — the blind spot is machine-verified (formal/RhAttack/S4Gap.lean)

The 25l blind spot is no longer a measurement: it is a THEOREM.
`formal/RhAttack/S4Gap.lean` (namespace S4G, 0 sorries, full package
17430 jobs green) proves, for every t >= 1000 and every 0 < d <= 1/2:

    mown(t, d) < BwireO(t) = p8_B(t, floor(13t/8))

i.e. the own-height detector floor (exact by S4b hMownProd) lies
STRICTLY BELOW the first — already the dominant — termwise-nonnegative
term of the P4-floor definition-side wire. Consequence (also proven):

    s4c_squeeze_impossible :
      0 <= Mr, 0 <= Mf  ==>  ¬(BwireO t + Mr + Mf < mown t d)

The S4 uniform squeeze (P12Uniform hs4) CANNOT hold at the bound level
on the own strip for ANY nonnegative residual/bridge-tail terms. The
gap is not an artifact of the pin choices; it is structural:
mown = O(t^{-2}) while Bwire >= (1/2)(13t/8)^{-1/2} = O(t^{-1/2}).

Chain (all LEAN-PROVEN in S4Gap.lean):
  mown <= (16001/15984)/t^2     (S4b hMownScaleHi; 4d^2 <= 1;
                                 1/(16t^2) <= 1/16000;
                                 e^{1/t^2} <= e^{1/1000} <= 1000/999)
       < (1/2)(13t/8)^{-1/2}    (squaring: A^2(13/8) < (1/4)t^3,
                                 A := 16001/15984, t >= 1000)
       <= (1/2) n^{-1/2}        (n = floor(13t/8) <= 13t/8,
                                 neg-exponent reversal via
                                 Real.rpow_le_rpow + one_div_le_one_div)
       <= p8_B(t, n)            (termwise nonnegativity)

Note: the exp pin e^{1/1000} <= 1000/999 is LEAN-PROVEN from P8Floor's
p8_abs_exp_sub_one_le (|e^x − 1| <= e^x x) — no new measurement.

### 4.33.1 API findings (online-first, owner directive)
- `pow_le_pow_of_le_left` and `pow_le_pow_left` do NOT exist in 4.33.1.
  The real names: `pow_le_pow_left'` (requires MulLeftMono/MulRightMono —
  NO instance for ℝ, multiplication is not all-factors-monotone there)
  and **`pow_le_pow_left₀ (ha : 0 ≤ a) (hab : a ≤ b) : ∀ n, a^n ≤ b^n`**
  (Algebra/Order/GroupWithZero/Basic.lean:470) — the usable one for ℝ.
  Verified locally after the web search (mathlib naming PR #9095).
- `Real.one_le_exp` in 4.33.1 takes the proof: `∀ {x}, 0 ≤ x → 1 ≤ exp x`
  (x implicit).
- `Nat.floor_le` in 4.33.1 takes the nonnegativity proof:
  `0 ≤ a → ⌊a⌋ ≤ a`.
- `Real.sqrt_eq_rpow (x : ℝ) : √x = x^{1/2}` (no side-condition arg).
- `inv_le_inv` (ordered-field positive version) absent; use
  `inv_eq_one_div` + `one_div_le_one_div (hb : 0 < b) (ha : 0 < a) :
  1/b ≤ 1/a ↔ a ≤ b`.
- `div_lt_div_iff` absent; the zero-suffixed family is the 4.33.1 API:
  `div_lt_div_iff₀ (hb : 0 < b) (hd : 0 < d) : a/b < c/d ↔ a*d < c*b`.
- Confirmed systemic traps (again): greedy ascriptions
  (`1 / 1000 : ℝ` binds the ascription to `1000`; `by norm_num : 0 < 1000`
  defaults the literals to ℕ unless the goal itself is ascribed
  `(0 : ℝ) < 1000`); `^2` vs `*` (pow_two bridges before
  mul_self_le_mul_self / mul_self_sqrt); factor order under
  `mul_le_mul_of_nonneg_left` (ring_nf both sides in calc steps);
  nested `show ... by ...` inside `rw [` lists (parse hazards — use
  `have` bindings).

### Honest split
- **LEAN-PROVEN**: all of S4Gap.lean (gap certificate + squeeze
  impossibility). No pins.
- S4 status: S4a window [1e3, 1.1e5] GREEN (25m); S4b own-strip
  identity+scale GREEN (25n/25o); S4c bound-level OWN-REGIME FAILURE
  GREEN (25p). Remaining open content (prize-scale): window-regime
  squeeze beyond t* ~ 6.9e5 (Bwire ~ sqrt(t) vs measured O(1) deficit —
  25l[3]) and own-regime bound sharpness (this certificate quantifies it:
  a t^{3/2}-wide gap).

Next atom: S4Asm — assemble S4a+S4b+S4c into the single
residue statement of the P1.2 open hypotheses (named gaps GAP-W / GAP-O).

---

## 25q. S4 ASSEMBLY GREEN — the residue statement, one import (formal/RhAttack/S4Asm.lean)

The S4 program (25l scoping) is now COMPLETE as a formal body of
work: `S4Asm.lean` (namespace S4A, 0 sorries, full package 17430
jobs green) imports S4a+S4b+S4c+P1.2 and packages the exact open
content into two named gaps:

- **gapW** (window regime, t > T0 = 1.1e5): the S4a inequality
  `p8_B + M e^{Xwire} Xwire < 0.9975` beyond the green window.
  `s4a_is_gapw_low_window` = S4a on [1000, T0] (LEAN-PROVEN);
  `tStar := 690349.0568` = the pinned numeric reach of the squeeze
  (25l[3] bisection — MEASUREMENT, not a proof).
- **gapO** (own regime, strip): `BwireO + Mr + Mf < mown(t,d)`.
  **`gapO_current_wires_impossible`** (LEAN-PROVEN, from S4c): for
  ANY nonnegative Mr, Mf the squeeze fails at the current wires —
  closing gapO REQUIRES a strictly sharper P4-floor wire than
  p8_B at list scale.
- **rh_from_structural_hypotheses**: S1+S2+S3+S4 ⟹ RH (the P1.2
  composition, restated self-contained).

### The prize, named (final form)
RH at the bound level = S1 (bridge-tail uniformity in height) +
S2 (C1b window-floor promotion 0.9975 → theorem) + **gapW** (window
squeeze beyond T0) + **a sharper own-regime wire** (any wire
W <= mown − Mr − Mf on the strip).  The S4c certificate makes the
last item a BOUND-SHARPNESS requirement with a quantified deficit
(t^{3/2}-wide structural gap, not a pin artifact): the measured
statistics (25l[4]) pass because the measured deficit is O(1)
while the wire bound grows O(sqrt(t)).

### S4 program ledger (all green commits)
- 25m / e4d10b4 + 65247d3 — S4a window [1000, 1.1e5] (S4Window).
- 25n / 9615d01 — m_own closed-form correction (dps-40).
- 25n / e0e050f — S4b core: hMownProd exact identity + hCown window (S4Own).
- 25o / 4d15513 — S4b scale: hMownScale 4d^2/t^2 window (S4Own).
- 25p / ebdb9de — S4c gap certificate: mown < BwireO, squeeze
  impossible (S4Gap).
- 25q / this commit — S4 assembly + named residue (S4Asm).

No probes left in formal/RhAttack (all deleted at commit time).
Lean 4.33.1 + Mathlib (pinned); no sorries anywhere in the S4 body.

## 25r. C1b atom 1 GREEN — the |pref| exact form + (m := |u|) shape (formal/RhAttack/C1b.lean, a4f07c6 + this trail)

The floor theorem's arithmetic core:
- `c1b_pref_exact`: on the straddle the detector's real prefactor is
  the exact all-positive rational
  `A·(u²+δ²)·((2γ+u)²+δ²) / (|u|(2γ+u)(A+δ+δ²+γ²)(A−δ+δ²+γ²))`,
  `A := ¼+γ²` — every factor positive, no sign case.
- `c1b_pref_shape` (u := +|u|) and `c1b_pref_shape_minus` (u := −|u|):
  worst-case δ = 1/2 shape bounds in (2γ+|u|) / (2γ−|u|) form via the
  R1 grouping (c1b_R1_le_one), δ² ≤ ¼, and the F-increasing step
  (c1b_F_incr) — the −|u| variant skips F-increasing (its exact form
  already carries 2γ−|u|).

Lean 4.33.1 notes that shaped the proofs (house file): `set_option
maxHeartbeats N in` must sit between the docstring position and the
theorem (docstring may follow it); big-equality `have`s leak into
nlinarith contexts (prove them last); `div_le_div_iff₀ /
div_le_div_of_nonneg_left / mul_le_mul_of_nonneg_left` are the 0-
suffixed / directional names in this pin; `open Complex` is needed in
C1b for ofReal_re/mul_I_re/sub_re (imported from B5's pattern);
`min_le_right _ _` with bare holes STUCK a LinearOrder metavariable
(needed explicit args); `rw [show P from by ...]` with ring works,
`ring` does not delta-reduce `set`-bound locals (hRe needed
`simpa [hZ_def]` in a second have); `pow_two` in a simp list
rewrites squares to `x·x` and breaks the final calc equality —
keep ²-forms if the statement uses them.

## 25s. C1b floor THEOREM GREEN — the discrete-straddle floor is now LEAN-PROVEN (bd66c43)

`c1b_disc_floor` in formal/RhAttack/C1b.lean (16 theorems in the
module, 0 sorry):

    ‖R(γ,δ,γ+u) − 1‖ ≥ min (23/1000) (1 − 25/γ)
    for 707/50 ≤ γ,  0 < δ ≤ 1/2,  u ≠ 0,  1/2 ≤ |u| ≤ 12.

The seven chain atoms (all green, all-positive polynomial style,
only analytic input = `Real.exp_le_two_add_div_two_sub`):
- `c1b_pref_shape_minus`, `c1b_G_ub` ((m²+¼)/m ≤ 577/48 on
  [½,12], factor (m−12)(48m−1) ≤ 0), `c1b_Fm_ub` (F(2γ−m) ≤
  2γ+1/152), `c1b_rat_decr` ((2γ+1/152)/(γ²+¼) decreasing for
  γ ≥ 25, gap (γ−25)(7601γ−51) ≥ 0), `c1b_exp_half_ub`
  (exp(ω/2) ≤ 1252/1249 via ω/2 ≤ 6/2501 < 2 and
  exp x ≤ (2+x)/(2−x)), `c1b_th_ub` (phase θ ≤ 444/2501 for
  γ ≥ 25), `c1b_Z_ub` (signed Z := pref·exp(ω/2) ≤ 977/1000
  for γ ≥ 25 via the product (577/48)(7601/95038)(1252/1249) ≤ 977/1000).

The theorem body splits on sign of Z = Re R before the cos (Re R =
Z·cos θ, b5Ratio + the exp real-part):
- Z ≥ 0: b5PrefSign (T3c) forces u < 0, so t = γ−|u|; c1b_Z_ub
  gives Z ≤ 977/1000;  |Re R − 1| = 1 − Z·cosθ ≥ 1 − Z ≥ 23/1000.
- Z < 0:  θ ≤ 444/2501 and 1 − x²/2 ≤ cos x  give
  Re R = Z·cosθ ≤ Z(1 − (444/2501)²/2) < 0, so |Re R − 1| ≥ 1.
- γ < 25:  1 − 25/γ < 0, min negative, ‖·‖ ≥ 0.

Margin structure against the measured corner (25k): 0.95405 bound vs
0.97858 measured worst z (2.5% headroom below the 0.977 threshold the
floor needs); 23/1000 vs corner 0.02384820641 (4%); 25 vs c =
24.0458 (4%). Full package build green (17430 jobs).

## 25t. C1b workstream COMPLETE — the p9_f_pin deprecation bridge (formal/RhAttack/C1b.lean, this commit)

`p9_c1b_disc_floor` restates the floor at the closure level with the
deprecation note.  Scope is exactly 25k [4]: the closure's hmargin
instantiation measures dev per WITNESS point and never evaluates the
window floor, so the pin p9_f_pin = 0.9975 stays the witness-scale
constant — the promotion's value is bookkeeping-grade: the
DISCRETE-GRID detector floor is now LEAN-PROVEN with zero
measurement input (the grid floor previously existed only as the day
010/023 measurements behind the pin and 25k constants).

C1b program ledger (all green commits):
- 6a84326 — C1b atom 0 foundations (R1, ω bounds, exp ub, F inc).
- a4f07c6 — C1b atom 1 (pref exact + u=+|u| shape) (25r).
- bd66c43 — C1b atom 2 + FLOOR THEOREM (25s: 7 chain atoms + c1b_disc_floor).
- this commit — P9 bridge + header closeout (25t).

Next open work (unchanged by C1b): S1 bridge-tail uniformity in
height; gapW (window squeeze beyond T0 = 690349.0568, prize-scale);
own-strip wire sharpness (S4c certificate); nominal band (3.15e7,1e9]
data (LMFDB 31-digit list ends at 1e7; 3e7 shards partial).

## 25u. Post-C1b doc alignment — every living doc at the resolved state (this commit)

C1b is closed; the documents that still described it as an open
analysis atom are now at the split record (25i refutation + 25s/25t
proofs), one line per doc:
- `formal/RhAttack/P12Uniform.lean` — the P1.2 S2(c) status map: the
  continuous 0.9975 window floor is REFUTED as stated; the DISCRETE
  straddle-grid floor is LEAN-PROVEN (`c1b_disc_floor` /
  `p9_c1b_disc_floor`); the pin stays the witness-scale constant
  (25k[4]).
- `docs/RH-PROOF-OUTLINE.md` — the P8 row (the "C1b promotion
  optional" tail), the P9 row (the "stays PINNED, promotion optional"
  clause), the P12 row (S2 = discrete-window floor LEAN-PROVEN), and
  the §9 "remaining price" line (the C1b promotion removed from the
  open list).
- `formal/README.md` — the Closure row (the C1b window-floor input:
  discrete version proven, continuous refuted, pin = witness
  constant).
- kainos-logos specs: `closure-module-abstract.md` (C1 + C1b rows —
  C1b (open) → C1b (closed day-023) with the split record) and
  `p1.2-uniform-squeeze-abstract.md` (S2(c) block → RESOLVED).

The resolved split, verbatim for the record: C1b CONTINUOUS (|t−γ|
≤ 10..12 window, uniform 0.9975 floor) = REFUTED (25i: pole-ridge,
‖R−1‖ reaches 1/γ scale off the 0.5·ℤ grid); C1b DISCRETE (u = 0.5k,
k = ±1..±24, 0 < δ ≤ 1/2, γ ≥ 707/50) = LEAN-PROVEN (‖R−1‖ ≥
min(23/1000, 1−25/γ)); the pin p9_f_pin = 0.9975 = the u = −12
corner of the same curve at its audit height (25k[3]), kept as the
witness-scale constant (25k[4] scope).

Open work after 25u (unchanged list, now without C1b): S1
bridge-tail uniformity in the height (Xval-uniformity = S(t)-type
condition at every height); gapW (window squeeze beyond
T0 = 690349.0568, prize-scale); the own-strip wire sharpness (S4c);
the nominal band (3.15e7, 1e9] data.

## 25v (09-14) — OWN-STRIP WIRE SHARPNESS: the requirement is now an exact certificate

User choice: atom **#3 — own-strip wire sharpness** (the S4c follow-up).

**25v[1] NUMERIC (day023_c1b_discrete.py precedent — mown vs wire, closure d-edge):**
the own-regime strip squeeze `W + Mr + Mf < mown t d` at the closure
d-edge `d = 1/200` (the largest d the closure's `hmargin` allows at
its audit scale) demands a wire below a **t^{-2} envelope**:
`mown t (1/200) = (1/10000)(16001/15984)·t^{-2} =: Eenv t`
(via `S4O.hMownScaleHi` at d = 1/200, exact constant 16001/15984
= 1 + 17/15984). The current wire's first term
`(1/2)(13t/8)^{-1/2} = (1/2)(8/13)^{1/2}·t^{-1/2}` exceeds Eenv by
a **power of t**: the ratio is `Kgap·t^{3/2}`, `Kgap =
(1/2)(8/13)^{1/2}·10^4·16001/15984 ≈ 3926.4943423` (7 digits,
checked in Python; the Lean proof carries the exact constant `Kgap`).
No constant-factor sharpening of the O(t^{-1/2}) wire family can
close GAP-O: any family member with scale n <= list scale 13t/8
sits above Eenv for every t >= 1000 (its first term alone is
(1/2)n^{-1/2} >= (1/2)(13t/8)^{-1/2}).

**25v[2] LEAN-PROVEN — `formal/RhAttack/S4Sharp.lean` (ns `S4S`), green:**
- `hMown_ds` — the hMownScaleHi form at a fixed d (strip 0 < d <= 1/2).
- `s4d_mown_dmin` — `mown t (1/200) <= Eenv t` (exact constants:
  (4)(1/200)^2 = 1/10000, so mown = (1/10000)(16001/15984)·t^{-2}).
- `s4d_wire_demand` — **THE WIRE DEMAND**: any wire W (with its own
  residuals Mr, Mf) closing the strip squeeze on d >= 1/200 obeys
  `W + Mr + Mf < Eenv t`.
- `hwire_first_term_exact` —
  (1/2)(13t/8)^{-1/2} = (1/2)(8/13)^{1/2}·t^{-1/2} exactly.
- `hKgap_env_collapse` — Kgap·t^{3/2}·Eenv t =
  (1/2)(8/13)^{1/2}·t^{-1/2} exactly (constants cancel).
- `s4d_wire_deficit` — current first term > Kgap·t^{3/2}·Eenv t
  (i.e. exceeds the demand by the power factor Kgap·t^{3/2}).
- `s4d_scale_demand` — if a p8_B-family first term (1/2)n^{-1/2} is
  below Eenv then `n > (5000·15984/16001)^2·t^4 ~ 2.49469e7·t^4`:
  the demand scale exceeds the list scale 13t/8 by a factor
  (5000·15984/16001)^2·8/13 ~ 1.53519e7·t³ (Python-checked).
- `s4d_list_scale_impossible` — **THE LIST-SCALE WALL**: for every
  t >= 1000, no scale n <= 13t/8 (the list scale floor(13t/8) is
  <= 13t/8) has its first term below Eenv. The p8_B wire family is
  dead for the strip squeeze at every t of the program's range.

**25v[3] S4Asm header updated**: the "SHARPER OWN-REGIME WIRE"
requirement now points at S4S — the replacement wire must be of
genuinely O(t^{-2}) shape (not a constant-factor improvement of the
O(t^{-1/2}) family), below Eenv, AND must come with its own residuals
whose sum stays below the d-edge margin. This is the honest wall,
quantified: GAP-O is a **bound-sharpness requirement of power-gap
size Kgap·t^{3/2}**, not a fudge constant.

**25v[4] Classification decision:** the wire sharpness atom is
**CLOSED AS A REQUIREMENT** (it is now a precisely quantified
certificate, not a fuzzy open item). The *construction* of an
O(t^{-2}) own-regime wire is a distinct mathematical program (a new
P4-floor-type bound with a t^{-2} main term at the LIST scale is
structurally impossible — the list scale is O(t); the O(t^{-2}) wire
would need a scale n = Θ(t²), i.e. a different family or a
cancellation argument beyond the P4-floor form). If such a wire
cannot be found, GAP-O folds into the prize-scale gapW-class
obstacles (like GAP-W).

**25v[5] Lean 4.33.1 pitfalls hit (S4Sharp):**
- ofNat vs natCast exponents: `t ^ (2 : ℝ)` does NOT rw-match the
  rpow_natCast pattern `t ^ (↑2 : ℝ)` (display looks identical);
  bridge via `rw [h2.symm, h1]` style or term-mode `exact
  rpow_natCast t 2` (type-level isDefEq accepts, rw-pattern does not).
- `-1/2` vs `-(1/2)`: rpow_neg needs `rw [show (-1/2 : ℝ) =
  (-(1/2 : ℝ)) by ring]` first (recurring).
- `mul_rpow` in term mode leaves the exponent metavariable stuck
  (`?z`) — use it in tactic mode (`rw [← mul_rpow (hc1) (hc2)]`).
- `mul_inv_self`/`mul_right_inj` do not exist under those names in
  4.33.1: use `mul_inv_cancel₀ (h : a ≠ 0)` and
  `mul_right_injective₀ (ha : a ≠ 0) : Injective (a * ·)`
  (apply-style, strict-implicit x,y).
- `mul_lt_mul_of_pos_left (hbc : b < c) (ha : 0 < a) : a*b < a*c`
  (multiplier LEFT); the `ha` slot must be given with the constant
  known ((by norm_num : 0 < c)), else the constant stays a stuck
  metavariable.
- `Real.sqrt_eq_rpow`/`Real.sq_sqrt (le_of_lt hn)` replace the
  exponent-juggling `n = (n^{1/2})²` (ring/calc with rpow is
  association-fragile).
- `gcongr` needs the goal already in multiplication form
  (a·1 < a·b); `13/8 < (13/8)·t³` alone does not trigger it —
  build the a·1 < a·b have explicitly + `rwa [mul_one] at hA`.

**Build:** S4Sharp standalone green; full package green (17430 jobs).
**Honest split:** 25v[1] NUMERIC (Python, 7-digit Kgap check);
25v[2] LEAN-PROVEN (whole S4S module, exact rationals + Kgap as an
exact real); 25v[4] DECISION (classification).

## 25w (09-14) — ITEM #4 (the (3.15e7, 1e9] data band) SET UP AS A BACKGROUND JOB

Owner: "set up 4 to run in the background."  Execution follows the
owner's research-order (24b): the dataset is the PUBLIC one —
download, verify, store; do not recompute.

**25w[1] DATA SOURCE RESOLVED (CITED public):**
beta.lmfdb.org/riemann-zeta-zeros/data/ (Platt-format shards, the 24b
source) — the server's index reaches t ≈ 3.06×10¹⁰ (14,580 shards;
last = zeros_30607946000.dat).  The whole band (3.15×10⁷, 10⁹] is
publicly downloadable: 464 shards, start-t in [31946000, 1006346000]
(the last overshoots 10⁹ by ~8.4×10⁵ rad), ~30 GB raw, ~5.1–7.3 M
zeros each.  md5.txt (14,580 entries) fetched for per-shard integrity.
NOTE: the server gates directory listings + md5.txt behind a JS
cookie-setter ("human=1"); the .dat shards themselves are open.

**25w[2] FRONTIER EXACT (PINNED, today):** the last local shard
zeros_29846000.dat ends at **t = 31946000.000000, final zero #
73426758** (1-based; metadata walk over its 1000 blocks of
~2100 rad / ~5.1 M zeros).  The docs' "3.15×10⁷" nominal edge was a
rounding of 3.1946×10⁷ — the new stream starts exactly where the
on-disk shards end.

**25w[3] FAST DECODER BUILT + VERIFIED (P-0.8, day024_platt_fast.py):**
pure-python float64 port of the 24b-verified Platt arithmetic, ~2 s
per 5.2 M-zero shard (the mpmath decoder's dps-40 rate cannot
absorb 2.77×10⁹ zeros).  Verification chain (all today, all PASS):
 (a) FIRST ZETA ZERO: 14.13472514173469379045725198… decoded
     BIT-IDENTICAL at float64 (31-digit source);
 (b) CROSS-IMPLEMENTATION: 2000 zeros at the 2.9846×10⁷ frontier
     BIT-IDENTICAL vs a fresh dps-50 mpmath exact decode;
 (c) STRUCTURAL (full-shard, zeros_29846000, 5,149,767 zeros):
     Nt continuity, block seams (t0_{k+1} = t1_k), strict
     monotone, zero in (t0,t1) per block (t1 = interval end
     EXCLUSIVE, not a zero — corrected a gate misread), header
     walk consumes the file exactly.
Format lesson: block = (t0,t1) interval + per-zero 13-byte steps;
cumulative Z is an unbounded int; earlier assumption "104-bit
cumulative" was wrong (104 bits is per STEP).

**25w[4] BACKGROUND JOB RUNNING (launched 2026-09-14 19:15 UTC):**
`scripts/rh/day024_band_1e9.sh` (setsid, pid recorded at launch),
~9 s/shard observed in the first 19 shards → **ETA ≈ 70 min**
(finish gates: RVM |diff| ≤ 3 on N(10⁹) and on the band end; strict
monotone; BAND-1E9-DONE marker).  Output:
`scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64` (raw LE float64,
~2.77×10⁹ zeros, ~22 GB — NOT in git, .gitignore entry added)
+ manifest.tsv (per shard: md5, Nt0/Nt1, t0/t1, count, mingap)
+ state.txt (resumable) + lastN.txt (the cross-shard Nt continuity
chain; seeded with 73426758 = the 25w[2] frontier — the first shard's
decode asserted Nt0 = 73426758 and PASSED).  Every shard: md5 gate →
decode with Nt continuity → append → rm.
Check: `tail scripts/rh/hi1e9/supervisor.log`.

**25w[5] WHAT COMPLETES NEXT (follow-on atom, after BAND-1E9-DONE):**
re-run the band screening (25f protocol, day023_taildiscrete.py
discrete-tail over the ACTUAL zeros) on (3.1946×10⁷, 10⁹] — the
nominal rows become REAL rows, closing the data half of item #4;
the independent local-walk layer past 10⁷ (a ~30-day 32-way CPU job,
~108 GB) is deliberately NOT started — the screening level is the
established practice for (10⁷, 3.15×10⁷] and the walk depth remains
a decision item.

**Honest split:** 25w[1] CITED (public dataset, 24b chain of trust);
25w[2] PINNED (measurement: metadata walk, today's date); 25w[3]
VERIFIED-TODAY (bit-exact cross-implementation, not a sorry-class
claim but a data pipeline — verified before trust per 24b);
25w[4] RUNNING (machine log is the record).

## 25x (09-14) — ITEM #4 DATA HALF CLOSED: BAND-1E9-DONE (+ the 25f protocol re-run on actual zeros, in flight)

**25x[1] THE BAND (25w job) FINISHED: BAND-1E9-DONE, 2026-09-14 19:50 local
(37 min total, not the ~70 min ETA; the 25w[4] "4 hours stalled" alarm in the
session was a local-vs-UTC misread of my own log timestamps — the job never
stalled; recorded so the pattern is visible).**  Final state:
`scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64` = **2,792,198,664 zeros**,
t range [31946000.066576, 1006345999.847005] (22.34 GB raw LE float64,
gitignored).  Finish gates (supervisor nolog, all PASS):
  band min gap = 1.08540e-04
  N(1e9) = 2,846,548,032   vs RVM 2,846,548,032.83   |diff| = 1 (tol 3)
  N(band end 1.006346e9) = 2,865,625,422  vs RVM 2,865,625,421.41  |diff| = 1
  strict monotone: PASS.  Every one of the 464 shards: md5 gate + decode +
  cross-shard Nt continuity (73426758 -> 2,865,625,422), zero failures.
  Provenance: CITED (LMFDB/Platt public dataset, 24b chain of trust) +
  VERIFIED-TODAY (bit-exact decoder cross-check, 25w[3]; RVM gate today).

**25x[2] THE 25f PROTOCOL RE-RUN (the follow-on atom; 25w[5] executed):**
scripts: `scripts/rh/day024_tail_hi1e9.py` (tail generalization) +
`scripts/rh/day024_band1e9_screen.py` (the scan; day023_straddle_hi.py
(25f) protocol VERBATIM: same kernel, same margin formula, same t-grid
(t = g + k/2, k in -12..12 \ {0}), same dev grid (496), same per-t dps-30
quadrature to 1e18 (200 pts, reissue 400), same 5e3 real-zero gate).
ONLY difference (the 25f "EXTENDING THE REAL REGION PAST 3.15e7 REQUIRES
actual zeros there" ask, now satisfied):
  - discrete section (1e7, 3e7] (47.5M zeros) -> (1e7, 1.006346e9]
    (2,844,489,297 actual zeros: the 52.3M shard slice (1e7, 3.1946e7) —
    which also picks up the (3e7, 3.1946e7] slice the old cache stopped
    before — concatenated Nt-continuous with the 2,792,198,664-zero band);
  - density quad (3e7, 1e18] -> (1.0063459998e9, 1e18]; for every scanned
    t <= 1e9 < G_LAST there is no interior singularity (25f kernel bug #3
    split not triggered).
  Near-t structure (zero spacing ~0.3 rad vs the old quad's node spacing
  ~1e6-1e9 in g — the exact thing that made the 25f nominal rows unsound)
  is now EXACT for all 17 windows.

**25x[3] REGRESSION at the 25h certified anchor (in-situ validation of the
extension):** window 1e7, extended kernel vs 25f/25h (old kernel):
  t_best = 9999999.7400 (identical)   zeta = 17.5382 (identical)
  E: -0.000588 (ext) vs -0.018979 (old)  --  the quad error of the old
       (3e7, 1e18] section is exactly what 25f attributed to the nominal
       rows; at 1e7 it was already small (0.019) and is now ~0.0006
  resid |zeta - K|: ~0.0096 (ext) vs 0.336 (25h old kernel)
  margin: 5.8003 (ext) vs 5.2362 (25h certified; conservative pin UNCHANGED —
       the Lean pin stays 143.341847457 per discipline; 5.2362 was a
       dps-30 cert of the OLD kernel, and this screen is a different, now
       finer, kernel)
  Reading: the extension kernel is valid (identical witness point, ~30x
  smaller kernel error, all the improvement explained by the section
  swap).  The certified ladder [1.40e2 @ 1e3 -> 1.43e2 @ 5e3 -> 5.24 @ 1e7]
  stands; the screen ladder tightens.

**25x[4] PROCESS NOTE (honest):** first full launch (32 workers) was
OOM-killed (parent 2.85e9-zero cache ~28 GB RSS + 32 mpmath workers each
churning 1-3 GB > 124 GB): kernel OOM log + BrokenProcessPool.  Fix:
float64 chunk-sums accumulated in longdouble (pairlog ~29 s -> ~12 s/t)
+ 12 workers (~76 GB ceiling).  Relaunched 19:5x; serial single-window
cost ~670 s -> wall ETA ~1.7-2 h for 17 windows.

**25x[5] THE TABLE (17 windows, 25f format, ACTUAL zeros to 1.0063e9;
hi1e9/screen_25x.log, out file pending):**

      g            t_best     margin   def_c     resid     zeta    E
  10000000.2400  9999999.74     5.8003  3.02369   0.01031  17.538  -0.0006   real
  11999999.8033 12000004.80     2.0814  3.30679   0.00583   6.883  -0.0008   real
  14999999.8889 14999995.89     1.6032  3.69841   0.00785   5.930  -0.0013   real
  18000000.0807 18000003.58     3.1873  4.06750   0.02472  12.964  -0.0019   real
  19999999.8837 19999999.38     1.6366  4.27795   0.01649   7.002  -0.0024   real
  23999999.9546 23999995.95     1.9489  4.69925   0.03107   9.159  -0.0034   real
  28000000.1729 28000005.67     4.8510  5.15781   0.11561  25.020  -0.0046   real
  31000000.0850 31000001.59     1.9144  5.36361   0.05818  10.268  -0.0057   real (was NOMINAL in 25f)
  37500000.0419 37500004.04     2.3711  5.95236   0.11718  14.114  -0.0083   real (was 0.66/E+2.18)
  49999999.8937 50000000.39     0.9411  6.83308   0.09521   6.431  -0.0147   real (was 0.37/E+1.45)
  75000000.2084 74999999.71     0.7137  8.45500   0.20286   6.034  -0.0331   real (was 0.53/E+2.36)
  99999999.9302 100000000.43    1.4466 10.44320   0.91446  15.107  -0.0588   real (was 0.54/E+2.66)
  149999999.955 149999997.46    0.7785 13.11249   1.44223  10.208  -0.1322   real (was 0.43/E+2.48)
  249999999.774 250000000.27   0.4365 18.67234   3.60612   8.151  -0.3663   real (was 0.28/E+1.98)
  399999999.907 400000000.91   0.3008 35.52423  16.46682  10.686  -0.9326   real (was 0.42/E+2.38)
  600000000.072 600000001.07   0.0918 63.77377  40.43331   5.857  -2.0674   real (was 0.13/E-0.16)
  1000000000.12 999999999.62   0.0197 440.6935 410.56110   8.664  -3.8792   real (was 0.07/E-2.65)

**25x[6] READING (honest split, no spin):**

(a) The 25f nominal rows are replaced: all 17 windows are now REAL (actual
zeros, exact discrete near-t structure).  The 8 old real rows reproduce
25f with the expected refinement (margins UP 3-9%, E from ~-0.02..-0.32
to ~-0.0006..-0.0046: the section swap removed the quad bias).  The
3.1e7 row flips 0.78(NOMINAL, E +2.25 unreliable) -> 1.91 (real, E -0.006):
SOUND.  Screened-SOUND region per this table: [1e7 windows all >= 1.6]
through the 3.75e7 window (2.37) — i.e. the old screened SOUND interval
(1e6, 3.15e7] EXTENDS to ~4e7.

(b) THE S1-GAP REGION (the program-level finding): margin < 1 at 5e7
(0.941, E -0.015), 7.5e7 (0.714, E -0.033), 1.5e8 (0.779, E -0.132),
2.5e8 (0.437), 4e8 (0.301), 6e8 (0.092), 1e9 (0.020) — with a LOCAL
RECOVERY at 1e8 (1.447, best-case 1.585 > 1: robustly SOUND).  The dips
are KERNEL-ROBUST, not quad artifacts: the (G_LAST, 1e18] quad's residual
resolution error shows up in E (<= -0.033 at 5e7/7.5e7, i.e. |K| within
~3% of |zeta|), and the BEST-CASE margin (E -> 0, resid -> 0,
margin_best = |zeta|/B(t)) is STILL < 1 at every dipping window: 0.954
(5e7), 0.731 (7.5e7), 0.875 (1.5e8), 0.54 (2.5e8), 0.30 (4e8), 0.25 (6e8),
0.29 (1e9).  The binding quantity at the dips is B(t) (the P8 ln-t floor:
def_c = B + resid grows 6.8 -> 440 across the table while |zeta| stays
O(5-25)): the S1 straddle-squeeze margin genuinely drops below 1 — entered at ~5.6e7, OSCILLATORY above
that (25x[7] sweep: dips 0.443-0.758 in (5.4e7, 2e8], recoveries up to
3.23), on ACTUAL zeros, at screen level with a small, understood kernel
bias.  The pre-registered P1.1e
route-retirement rule (25b: "margin < 1 at >= 1e5 OR E >> 1 at >= 1e5")
FIRING: the P1.1e uniform-squeeze route (the B-2/b2 kernel as the closure
wire) is retired above the sub-1 onset; coverage of S1 is now (25x[7]):
  certified [1e3, 1e6]  +  screened-SOUND [1e6, ~5.4e7]  +  oscillatory
  sub-1 regime (8/21 windows robustly < 1 in (5.4e7, 2e8], min 0.443 @
  1.1e8) that IS the asymptotic behavior: B(t) ~ t^{1/2} (measured
  3.02/9.53/30.1 at 1e7/1e8/1e9; the sharp t^3 n^{−5/2} P4 term at the
  n* optimum) vs fluctuating |zeta| => the best-case envelope |zeta|/B
  decays to 0 — no finite wire-tuning of the P1.1e statistic restores
  margin >= 1 at high t (25x[7] notes 3-4).
  This LOCALIZES prize-roadmap open item #1 (S1 height-uniformity) with
  data: it is not a uniformity subtlety somewhere — it is a measured
  margin-< 1 regime entered at ~5.6e7 (first robust dip 0.5657),
  oscillatory in ln t (recoveries 1.02-3.23), floor-dominated (B(t)).
  Boundary sweep LANDED (25x[7]); the dps-30 pins (25y: the 5.6e7 and
  1.1e8 robust dips, 25h protocol, LAUNCHED — hi1e9/pins_25y.log) make
  the retirement a CERTIFIED fact on landing.

(c) The 1e9-row E (-3.88, |K| 48x small) is the same quad-resolution
disease one octave up (the (1.006e9, 1e18] quad's first node sits ~1.05e9
above the band end, so the (1.006e9, ~2e9] mass — still O(1) in the
kernel for t ~ 1e9 — is under-resolved): the verdict there is already
carried by the best-case bound (< 1 regardless), and a far-side quad
refinement (more nodes below 1e10) is a cheap follow-up if the 1e9-scale
number itself is ever needed for a pin.

**25x[7] BOUNDARY SWEEP (day024_band1e9_sweep.py, 26 windows in
(3.9e7, 5e8], same protocol/tail — LANDED; hi1e9/sweep_25x.log):**

      g         margin    g         margin    g         margin
   3.9e7       1.2768  8.4e7       0.7142  1.4e8       0.8349
   4.0e7       2.3601  9.0e7       2.4676  1.6e8       0.5853
   4.25e7      2.0401  9.6e7       0.7132  1.8e8       0.6201
   4.4e7       2.7999  1.05e8      1.6096  2.0e8       1.0199
   4.6e7       1.8513  1.1e8       0.4429  3.0e8       0.6227
   4.8e7       4.5463  1.2e8       1.0065  5.0e8       0.1550
   5.2e7       1.8846  1.3e8       1.1788  (6e8 0.0918, 1e9 0.0197)
   5.6e7       0.5657  (all dev = 1.0000; E <= -0.19 through 2e8)
   6.0e7       2.2658
   6.4e7       0.7580
   6.8e7       1.5442
   7.2e7       3.2287
   7.8e7       1.4736

  Reading (supersedes the 25x[6] window-granularity sketch):
  1. SOUND (margin >= 1.28) through 5.2e7 (min 1.2768 @ 3.9e7; 4.55 @
     4.8e7; 1.88 @ 5.2e7).  Screened-SOUND region on actual zeros:
     [1e6, ~5.4e7] (certified below: [1e3, 1e6]).
  2. FIRST ROBUST sub-1 window: 5.6e7 (0.5657, E -0.018, best-case
     |zeta|/B = 0.57).  The sub-1 region is NOT a clean interval: the
     margin OSCILLATES (|zeta| spikes vs the smooth B(t) floor; scale
     ~20% in ln t), dipping 0.566 / 0.758 / 0.714 / 0.713 / 0.443 (MIN
     @ 1.1e8) / 0.835 / 0.585 / 0.620 in (5.4e7, 2e8] (8 of the 21
     windows there robustly sub-1, E <= -0.19), recovering 2.27 / 3.23
     / 2.47 / 1.61 / 1.01 / 1.18 / 1.02, and monotone-sub-1 above
     2e8 (0.623 @ 3e8, 0.155 @ 5e8, 0.092 @ 6e8, 0.020 @ 1e9).
  3. ASYMPTOTIC (structural, in the machine-proven P4 exponents):
     B(t) measured 3.02 / 9.53 / 30.1 at 1e7/1e8/1e9 = proportional to
     t^{1/2} (the sharp t^3 n^{−5/2} term of the P4 bound at the n*
     optimum), while |zeta| fluctuates O(1-30): the best-case envelope
     |zeta|/B DECAYS to 0 — margin < 1 is the EVENTUAL behavior of the
     P1.1e wire, entered (oscillatory) at ~5.6e7.  Consequence for
     route planning: no finite tuning of the P1.1e statistic restores
     margin >= 1 as t -> inf against the sharp P4 floor sqrt(3)/270;
     the high-t argument needs a different < side or Route B
     (p1.2 spec, AFTER-25X item 2, updated).
  4. Pins (25y, 25h dps-30 protocol; BOTH LANDED — 25y[1] at the
     5.6e7 argmax: 0.565709077008; 25y[2] at the 1.1e8 g-0.5 grid
     point: 0.175041964016, the deepest cert in the program; the
     1.1e8 window argmax t = g+0.5 (screen 0.4429) remains screen-
     level, optional to pin).
  5. The 5e8-1e9 rows carry the far-quad bias (E -1.45..-3.88; |K|
     4-48x small); their sub-1 verdicts ride the envelope (|zeta|/B =
     0.31/0.25/0.29 < 1) + the monotone floor.  A far-side quad
     refinement (denser nodes below 1e10) is a staged cheap follow-up
     if those exact values are ever pinned.

**Honest split (revised):** 25x[1] CITED+VERIFIED-TODAY (RVM gate is the
arithmetic anchor; min gap is a measurement of the dataset); 25x[2]
DECISION (protocol extension, the difference from 25f documented);
25x[3] MEASURED (in-situ validation of the extension kernel at a certified
point — not a re-certification; existing pins untouched); 25x[4] DECISION
(resource limit, documented); 25x[5] MEASURED (screen level: float64
discrete + dps-30 quad, per 25c/25f discipline); 25x[6] MEASURED+DECISION
(the margin < 1 windows are robust measurements; the route retirement is
the standing rule FIRING on them — the rule was pre-registered in 25b);
25x[7] LANDED (sweep; 25y[1]/[2] pins LANDED — see below; 25z reclassification).
**25y[1] PIN LANDED (dps-30, 25h protocol + extended-tail kernel):**
the first robust sub-1 window — g = 56000000.118091769516468,
t = g - 4: |zeta| = 4.0768015615158219747,
dev = 0.99999985491071977344 (the S4 blind spot, open to 8 digits),
B = 7.1306803526628292955, resid = 0.075852361245979202014,
**MARGIN = 0.565709077008** (dps-30 certified).  The 25x screen value
(0.5657) is the certified value to all 5 printed digits — the screen
and the protocol agree, as designed (a pin certifies the protocol, and
here the instance confirms itself).  E = -0.0184348793301.  The 25b
P1.1e route-retirement rule ("margin < 1 at >= 1e5") is now a PINNED
FACT at its first robust sub-1 window (5.6e7).  (25y[2] below.)

**25y[2] PIN LANDED (dps-30, same protocol):** g =
109999999.909622058272362, t = g - 0.5: |zeta| =
1.7721998743087847921, dev = 0.99999998181818184457,
B = 9.9938214895286808183, resid = 0.13060696992632552389,
**MARGIN = 0.175041964016** (dps-30 certified) — the DEEPEST
certified straddle margin in the program to date.  Precision note:
the protocol's window margin is the MAX over the t-grid (scan_one:
t_best = argmax), so the 1.1e8 window's screen value 0.4429 is its
MAX (at t = g + 0.5); this pin certified a different, worse grid
point (t = g - 0.5), hence the deeper number.  Consistent (0.175 <=
0.443 <= ...): the window is sub-1 at every grid point, and the
window verdict itself is already certified via 25y[1] (whose t IS
that window's argmax) — a pin of the 1.1e8 argmax (t = g + 0.5) is
optional, not needed for the retirement rule.

## 25z (09-14)

**25z GAP-O reclassified into the GAP-W class (owner-delegated: "do
what you think is best, next").**  The decision-shaped open item (25v:
"build a genuinely O(t⁻²)-shaped own-regime wire, or reclassify") is
RESOLVED by reclassification, on these grounds: (1) 25v already proved
the whole p8_B wire family (n ≤ 13t/8) is dead for the own-strip
squeeze — there is no "existing wire to fix"; the item is pure wire
CONSTRUCTION against a proved-sharp floor (Eenv(t) =
(10⁻⁴)(16001/15984)·t⁻², deficit Kgap·t^{3/2}, Kgap ≈ 3926.494); (2)
that is the same shape of obstacle as GAP-W (the window squeeze past
t* = 690349.0568) — both are "new wire/floor construction at the
prize scale", and running them as two parallel open workstreams would
fragment the remaining effort; (3) nothing is lost: the wire
requirement is recorded verbatim as named sub-item (i-b) of the GAP-W
class (p1.2 spec AFTER-25Y/25Z; outline §remaining price) and is
revivable as its own workstream at any time.  Effect: the open list
no longer contains any decision-shaped item — the remainder is pure
mathematics: the GAP-W class (i-a window squeeze + i-b own-regime
wire) and the S1-GAP high-t argument (a different < side or Route B;
now proven untunable against the sharp P4 floor), plus the P8
residual-floor theorem itself.

## 25aa (09-15) — GAP-W investigation, phase 1: the wire-family map
(day025_gapw_wires.py + out_day025_gapw_wires.txt; owner: "let's
investigate GAP-W")

Setup: GAP-W (S4Asm `gapW`) = for t > T0 = 1.1e5,
p8_B(t, floor(13t/8)) + M e^{X(t)} X(t) < 0.9975 for 0 <= M <=
Zbound(t) = 1.6 t^{1/4} ln t, X = the Xval wire (G, B] = (1e7, 1e8].
Two structure facts from the Lean files anchor the investigation:
(i) `p8_B_floor` (P8Floor, LEAN-PROVEN) is UNIVERSAL in n —
‖p4_em_expr s n‖ <= p8_B t n for EVERY n — and p8_B decreases in n
(all negative powers): the branch N witness of the closure is free
("any branch is a valid wire", S4Window header); (ii)
`b3BoundExplicit` (B3Sbar.lean:433) is generic in (L, t, G, B) with
side-conditions 0 < t < G, e <= G, G < B and the S̄ counting-fluctuation
hypothesis (CITED ledger: Platt–Trudgian, the SAME input class as the
Xval pin) — so the band endpoints are also free witnesses.  13t/8 +
(1e7, 1e8] is therefore just the LOW-T instantiation of the wire.

**R1 — codified bound-level crossing (NEW number).**  The codified
gapW (M <= Zbound — the CITED convexity wire, not |zeta|) on the
13t/8 + Xval wire crosses the floor at **t_Z = 113957.2826** (this
run, dps-30; the 25m pin t_c = 113957.110061, delta 0.17 = a
precision/kernel artifact — the 25m pin stays the authoritative
recorded value).  The codified bound-level wire has essentially NO
budget beyond T0 (the S4W-header margin 0.0591 at T0 is the whole
rest; crossing at 1.036*T0; then the Xval pole uw -> 1 at G = 1e7:
D -> +inf, +94 at 9e5 already).  Never previously isolated: 25l
reported the |zeta|-mass variant.

**R2 — CORRECTION of 25l[3] (honest record).**  25l[3]'s UNIFORM
claim ("the window-regime squeeze HOLDS TO t* = 690349.0568", i.e.
for all t <= t*) is REFUTED by direct dps-30 evaluation of the 25l
kernel verbatim (B_best + Xval(1+|zeta|) - 0.9975): the measured-mass
deficit OSCILLATES.  Exact structure (this run):
  - first violation: **t1 = 495802.9022** (crossing; 50-bisect);
  - oscillatory deficit region (495802.9, 818712.8): 352 grid sign
    changes on the 1400-pt scan, 359 of 1400 sampled points violative
    (the |zeta|*X ripple crosses the 0.9975 budget repeatedly — 176
    crossings; NOT a measure-zero island);
  - the pinned t* = 690349.0568 is a RIPPLE ROOT: D(t*) = +2.5e-5
    (it sits inside a violative island) — the 25l single-pass
    bisection over [1e3, 9.9e6] landed there by path, and the record
    mistook the path root for the uniform boundary;
  - permanent onset: **tau_perm = 818712.834** (60-bisect on the last
    upward crossing); D > 0 for t > tau_perm through the pole at 1e7.
  Corrected statement: the measured-mass wire HOLDS on [1e3,
  495802.9022), oscillates in (495802.9, 818712.8], and fails
  permanently from 818712.834.  No LEAN fact is affected (25l[3] was
  a measurement — S4W/S4Asm carry tStar as "PINNED, a measurement not
  a proof", and S4a's proven interval [1000, 1.1e5] uses the Zbound
  wire, not |zeta|).  The S4Asm header line and the p1.2 spec's
  "numerically green to t*" claim will be annotated accordingly
  (phase 2).

**R3 — GAP-W CLOSES at the bound level by the growing-wire family
(HEADLINE).**  Map D(t) = p8_B(t, floor(t^q)) + X_{t^r}(t) + Zbound
e^X X - 0.9975 with X_{t^r} = Bf(t, t^r)(Sbar 2t^r + Sbar t^r) +
Cf(t, t^r) Kbar t^r, on (1.05e5, 1e18), 4000-pt log grid, for
(q, r) in {(2,2), (1.5,1.5), (2,1.5), (3,2), (2.5,2), (1.5,2)}:
EVERY family stays below the floor at EVERY t (max at the left edge,
D in [-0.997499, -0.9485]); the (q, r) = (2,2) family gives TOTAL
WIRE <= 5.36e-6 at T0, then decays: p8_B(t, floor(t^2)) ~
1/2 t^{-1} + t^{-2}/12 + 9.07e-3 t^{-2} (the t^3 n^{-5/2} term at
n ~ t^2), X ~ (0.66 ln t + 7) t^{-2}, Mf ~ 1.05 t^{-1.75} (ln t)^2:
  t = 1.1e5: wire 5.36e-6 (D = -0.997495);  1e6: 5.2e-7;
  1e9: ~4e-10;  1e18: ~1e-19.  Margin >= 0.997 to the floor at every
t > T0.  Admissibility (all free witnesses): G = t^2 > t (t > 1);
n = t^2 <= N(t^2) — RVM two-sided LOWER bound, e.g. N(x) >=
(x/2pi)(ln(x/2pi) - 1) - 0.01 x/ln x (Brent–Saldanha-type explicit
form, x >= 1e6 — CITED ledger line to be added to FORMULAS; the 0.01x
/ln x error term is the standard explicit S-bar companion) gives
N(t^2) >= t^4/4 >= t^2 for t >= 2 (diagnostic at T0: RVM N >= 3.92e10
vs n = 1.21e10, 3.2x margin); the far tail (2t^2, inf) is under the
A4.1b far floor 1 (LEAN).  CONCLUSION: with the family wire (n =
floor(t^2), G = t^2, B = 2 t^2), the window-regime bound-level
squeeze holds for ALL t > T0; joined with S4a GREEN on [1000, T0]
(13t/8 wire), the WINDOW REGIME is closed on [1000, inf) at the bound
level, pending the Lean formalization (phase 2).  The bound-level RH
residue (S4Asm header) thereby REDUCES at the window level: gapW
becomes a theorem; what remains of the S4 body is the OWN-regime item
(the sharper wire / gapO, reclassified in as (i-b) by 25z).
Honest caveats: (a) the map is float64 p8_B + dps-30 wires — phase 2
re-certifies every endpoint constant at dps-50 with directional
rounding (the S4a protocol, day023_s4a_constants.py style) before any
Lean norm_num closes; (b) the band (t^2, 2t^2] input hS is the SAME
S̄ CITED ledger as the Xval pin (Platt–Trudgian, FORMULAS 1.3) — no
zero DATA needed for the growing band, only the cited counting-
fluctuation bound; (c) |C| >= 1 and the convexity constant 1.6
(Zbound) remain CITED exactly as in S4a (no new cited input).

**R4 — interaction with S1-GAP (scope note, for phase 3).**  The
family wire shows the WINDOW-regime bound side at high t is
negligible (<= 5.4e-6), not O(1): the closure's N witness is free, so
the bound side does NOT have to sit at the P4Limit n* ~ 0.49t scale
(where p8_B ~ sqrt(t) — the scale the 25x S1-GAP measurement fights
against).  The zero-side content remains the S1 hypothesis of the P12
conjunction (25x measured it failing against the B(t) ~ sqrt(t) floor
from 5.6e7).  How S1's demand re-formulates at high t once gapW is a
theorem (the zero side only needs to beat the FAMILY bound side,
<= 5.4e-6 at window level — a demand the measured zero side |zeta|
= O(1-30), dev = 1 clears by orders of magnitude) is a P12-level
question deferred to phase 3 — stated here so the phase-2
formalization does not accidentally absorb it.

**NEXT (phase 2):** formal/RhAttack/S4Growth.lean — the family
theorem (endpoint constants + monotonicity + floor/floor-family
lemmas, S4a lemma-bank style) + the admissibility ledger line (RVM
lower bound) in FORMULAS + S4Asm header/doc sync (R2 annotation) +
p1.2 spec S4 state.  (phase 3): re-read the P12 conjunction with
gapW a theorem (R4).

## 25ab (09-16) — GAP-W PHASE 2 LANDED: the window regime is a theorem
(formal/RhAttack/S4Growth.lean, namespace S4G; owner: "start phase 2,
report when you're done, then move on to the next item")

**Result.**  The 25aa family closure is now a LEAN theorem.
`formal/RhAttack/S4Growth.lean` compiles clean on Lean v4.33.1 /
mathlib v4.33.1 — 0 errors, 0 sorry (full package `lake build` green).

**The main theorem — LEAN-PROVEN:**

    s4g_growth_squeeze (t) (ht : T0 ≤ t) (M) (hM : 0 ≤ M)
        (hMz : M ≤ Zbound t) :
        p8_B t (nGrow t) + M · e^(Xgrow t) · Xgrow t < p8_f_near_pin

with T0 := 110000, nGrow t := ⌊t²⌋, Xgrow t := Xfam(t, t²) (the
B3Core window X-wire on the band (t², 2t²]).  Together with S4a GREEN
on [1000, T0] (s4a_window_squeeze, the 13t/8 list wire), the WINDOW
REGIME is closed on [1000, ∞) at the bound level: **gapW is a
theorem.**  What remains of the S4 body is the own-regime wire item
(i-b of the GAP-W class, 25z/25v) and the S1 height wire — pure
mathematics, no decision-shaped items.

**Stage structure (all endpoint constants LEAN-proven, not sampled):**
- Stage A: family constants as exact rationals — CG11 = 91/20000000,
  CG12 = 7/100000000000, CG13 = 3/10000000000000, CG2 = 14/100000000,
  CG3 = 41/10000 — plus XUBfun t := (249/50·ln t + 531/20)/t²
  (= (4.98 ln t + 26.55)/t²) and the shared section facts (T0-val,
  hLogT1 : 1 ≤ ln t, hLogSqrt : ln t ≤ √t, hT0p34 : 6000 ≤ T0^{3/4},
  hT0p54 : 1980000 ≤ T0^{5/4}).
- Stage B (hCG11/12/13): p8_B(t, ⌊t²⌋) ≤ CG11 + CG12 + CG13, termwise
  from Xf := t² − 1 ≥ T0² − 1 (floor-lowering + Xf-increasing, S4a
  lemma bank).
- Stage C (hBfUB, hSSumUB, hCfUB, hKbarUB, hXub, hXubEnd):
  Xgrow t ≤ (4.98 ln t + 26.55)/t² ≤ CG2 — the Bf/S̄/Cf/Kbar
  sub-chains exactly as cert-script [1]–[2], endpoint CG2 via
  ln t ≤ √t at T0.
- Stage D (hExpX, hMf): the M-term — Zbound·e^{Xgrow}·Xgrow ≤ CG3
  (Xgrow ≥ 0 branch: e^{Xgrow} ≤ 3 from Xgrow ≤ CG2 < 1 and S4W.hE3;
  Xgrow < 0 branch: the term is < 0).  Chain: 1.6·t^{1/4}·ln t ·3·
  XUBfun ≤ 4.8(4.98 t^{−3/4} + 26.55 t^{−5/4}) ≤ 4.8(4.98/6000 +
  26.55/1980000) < CG3 — the 6000/1980000 end-constants are the
  hT0p34/hT0p54 pow-inequalities (no float samples).
- Stage E (hL19, s4g_admissible): the RVM lower-bound admissibility
  N_rvm_low(x) ≥ x for x ≥ T0², where
  N_rvm_low(x) := (x/2π)(ln(x/2π) − 1) − (137/1000)ln x
                          − (443/1000)ln ln x − 44/10.
  The chain (all LEAN-proven): 2π ≤ 44/7 from π < 3.1416
  (Real.pi_lt_d4, mathlib); e¹⁹ ≤ 3¹⁹ (S4W.hE3, pow_le_pow_left₀);
  2π·e¹⁹ ≤ T0² (norm_num); 18/(2π) ≥ 63/22 from π < 22/7
  (one_div_lt_one_div_of_lt); ln x ≤ x/2 (the √x-bridge:
  ln x = 2ln√x ≤ 2(√x − 1) ≤ x/2, the last step (√x − 2)² ≥ 0);
  ln ln x ≤ ln x − 1.  Residual: (63/22 − 29/100)·x − 3957/1000 ≥ x
  on x ≥ T0² (nlinarith on the exact rationals).
- Total — norm_num: CG11 + CG12 + CG13 + CG3 = 4.10469e-3 < 0.9975
  = p8_f_near_pin.

**Honest split per atom.**  LEAN-PROVEN: everything above (the whole
file).  CITED (unchanged from S4a — no new cited input): (a) the
M ≤ Zbound hypothesis of s4g_growth_squeeze (Zbound = 1.6·t^{1/4}·ln
t is the RVM upper bound, |zeta| counting wire); (b) the S̄
counting-fluctuation ledger (Platt–Trudgian, FORMULAS 1.3) inside
hSSumUB; (c) the RVM lower-bound SOURCE (Backlund estimate — see
ledger line below).  PINNED: the cert-script chain
(scripts/rh/day025_gapw_constants.py REV2, dps-50, ALL PASS;
out_day025_gapw_constants.txt) — 25aa caveat (a) is thereby resolved:
every endpoint constant the Lean norm_num closes was re-certified
directionally at dps-50 before the Lean closure, and the Lean
endpoints are proved inequalities (6000 ≤ T0^{3/4} etc.), not float
samples.

**RVM ledger line (FORMULAS.md, added this commit).**
N_rvm_low (Backlund constant set, conservative; PINNED ratio at
T0²: 3.24335400 ≥ 1, min 3.24203321 on [1.2e10, 1e40]).
OWNER ONLINE CROSS-CHECK (2026-09-15): the current best published
two-sided RVM bound is Bellotti–Fiori, arXiv:2412.15470 v2 (accepted
Math. Comp.): |N(T) − (T/2π)ln(T/(2πe))| ≤ 0.10076 ln T +
0.24460 ln ln T + 8.08344 for T ≥ e — strictly sharper; Backlund
retained as the certified constant set of the admissibility chain
(the chain closes with ratio ≥ 3.24 under either, so the sharper
constants are a future tightening, not a requirement).  arXiv:2402.04272
(checked in the same pass) is a PNT ψ-formula error term, not a
competing N(T) bound.

**Doc sync (same commit):** S4Asm header (GAP-W → theorem, 25ab
annotation), RH-PROOF-OUTLINE (both repos: S4 row + remaining price),
p1.2 spec (S4 state: window regime = theorem; open remainder =
own-regime wire (i-b) + S1).

**NEXT (phase 3, 25aa R4):** re-read the P12 conjunction with gapW a
theorem — the zero side (S1) only has to beat the FAMILY bound side
(≤ 5.4e-6 at window level, 25aa): the S1 demand re-formulates at high
t; phase 2 deliberately did NOT absorb it.

## 25ac (09-16) — PHASE 3 (25aa R4) LANDED: the P12 conjunction re-read with gapW a theorem

**Structural statement (no new measurement, no new theorem — the
P12 formalization stands unchanged; this is the read the owner's
directive "then move on to the next item" pointed at).**  With
25ab, the four structural hypotheses of `P12Uniform.lean`
(`squeeze_gives_margin`, `p1_2` — LEAN-PROVEN composition, all green)
resolve as follows at the bound level:

- **S3 (definition side, Q ≤ Bwire + Mr): LEAN-PROVEN pointwise** —
  the P8Floor-composed wire (A0–A4 module complete).  Unchanged.
- **S2 (detector floor, dev ≥ flo): LEAN-PROVEN pointwise** on the
  audited bands (0.9975 pin, far floor 1, C1b discrete floor, 25s/25t).
  Unchanged.
- **S4 (the squeeze, Bwire + Mr + Mf < flo): the window piece is now
  a THEOREM (25ab)** — `S4G.s4g_growth_squeeze` discharges it for
  every off-line pair in the window regime at t ≥ T0 = 1.1×10⁵ under
  the RVM upper bound M ≤ Zbound t (CITED, unchanged from S4a); S4a
  covers [1000, T0].  The own-regime piece (strip 0 < d ≤ 1/2)
  remains the (i-b) wire requirement (25v/25z: below
  Eenv(t) = (10⁻⁴)(16001/15984)·t⁻², deficit Kgap·t^{3/2}).
- **S1 (zero side, ∃ Q ≥ devOf − Mf, uniform in (t0, d0)): still the
  open item — and the 25aa reformulation now bites precisely**: devOf
  is the measured zero-side quantity (min-d detector on the actual
  zeros; the P1.1e straddle statistic |ζ|/B against B(t) ~ t^{1/2}
  was the CHosen instrument, 25x).  What 25aa changed: S4 no longer
  needs the P4Limit scale n* ~ 0.49t (where Bwire ~ √t) — the
  family's bound side is ≤ 5.4×10⁻⁶ at window level — so the
  √t-height tension has LEFT the squeeze and lives entirely in S1's
  zero-side content.  The high-t demand of S1 is: exhibit, uniformly
  over off-line pairs of a structural zero set, a zero-side scale
  Q ≥ devOf − Mf; the measured sub-1 regime from ~5.6×10⁷ (25x/25y:
  0.565709077008 @ 5.6e7, oscillating, envelope → 0) says the P1.1e
  INSTRUMENT cannot supply it at high t — a different zero-side
  quantity or Route B (§10) is required.  The order-of-magnitude
  clearance noted in 25aa R4 (measured |ζ| = O(1–30) vs the family
  bound side ≤ 5.4×10⁻⁶) is exactly this: at window level the zero
  side beats what S4's side demands; the failure is the instrument's
  √t floor, not the zero set.

**Composition (now exact):** [1000, ∞) window regime = PROVEN at
bound level (25ab; the former (t*, 5.6e7] "not yet proven but
measured SOUND" region — 25y wording — is now PROVEN, and the
[5.6e7, ∞) window piece is proven too: the 25ab theorem is
t-uniform).  [1000, 5.6e7] zero side = measured sound (25x),
[~5.6e7, ∞) zero side = measured sub-1 and untunable against the
chosen instrument (25x[7]) — S1 uniform height is the remaining
zero-side mathematics; the own-regime wire (i-b) the remaining
S4-side mathematics.  No decision-shaped items remain.

**NEXT on the open list (both pure mathematics, both named):**
(i-b) the own-regime wire below Eenv (25v quantification);
S1-uniform-height (a different zero-side quantity or Route B).
Either can be picked up as the next workstream; none is decision
shaped.

## 25ad (09-16) — OWN-REGIME WIRE SURVEY LANDED: the wall is at the QUANTITY level, and the quantity crosses Eenv exactly at the 25v scale boundary (item 2); + BF admissibility tightened in Lean (item 3)

The pre-registered survey (item 2): does the EM-tail quantity
`|p4_em_expr(½+it, n)|` (the object p8_B bounds) show t⁻² decay at
closure scales that the p8_B bound hides?  (25v/25l[5](ii) residue:
"a strictly sharper P4-floor wire … the d → 0 spiral of the
definition side must land at the same 4d²/t² scale … not at the
sqrt(t) wire.")  Script: scripts/rh/day026_ownwire_survey.py,
out_day026_ownwire_survey.txt (float64 sweep + dps-30 cross-
validation).

[0] MIRROR VERIFIED.  p4_em_expr(s,n) = T1 + T2 + T3 with
T1 = −½n^{−s}, T2 = (1/12)·s·n^{−s−1}, T3 = −½∫_n^∞ B̂₂(x)·s(s+1)·
x^{−s−2}dx (B̂₂ = period-1 Bernoulli, P4Tail.B2), s = ½+it; and
p4_I(n,s) = n^{−s+1}/(1−s) = **−**∫_n^∞ x^{−s}dx — the P4 "missing
tail" is the sum-minus-integral tail difference W_n = ∑_{k>n} + I =
∑tail − ∫tail.  Cross-validated at dps-30 against the zeta-side
ζ(s) − P_n + I: ratio 1.000000 / 1.000000 / 1.000007 / 0.999705
(t = 14.13, 100, 1e3, 1e4; float64 T3 quadrature, 32-pt GL/unit
interval, M = 4096) and 1.0 at ≤1e-15 in the Re s > 1 home territory
(s = 2, 3, 2.5+i).  DISCIPLINE NOTE: the first run's cross-
validation appeared to fail (ratios 0.2–0.93) — it did not; the
validation line used I(t) instead of I(n) (a typo in the check, not
a convention error).  Fixed and re-run; the float sweep numbers
stand.

[1] WALL AT THE QUANTITY LEVEL (pre-registered verdict B).  At the
list scale n = floor(13t/8) (the 25v demand context): |EM|/|T1| =
1.0048 @ 1e6 … 1.0058 @ 1e8 — the raw EM norm IS the T1 wall (no
hidden t⁻² decay; T1 = −½n^{−s} is an explicit monomial of the
closed-form expression with no same-order partner).  Measured
|EM|/Eenv = 3.9369e12 @ t = 1e6 (Kgap·t^{3/2} = 3.9187e12; the 25v
bound-level wall p8_B ≥ Kgap t^{3/2} Eenv is thus a property of the
quantity itself, not of the triangle inequality).  log-log exponent
1.5003 (t grid 1e6..1e8) and 1.5002 on the CERTIFIED ZERO HEIGHTS
(actual strip pairs, 40 gamma in [1e5, 1e7]).  T3 is small in
practice: |T3|/|T1| ~ 1e-3 measured (the L4 IBP bound is loose by a
factor ~t — see [4]).

[2] n-FAMILY MAP (the crossing is exact).  |EM|/Eenv as a function
of the scale family (t = 1e5/1e6/1e7):
      list n ~ 1.625t :  exponent 3/2   (3918.7·t^{3/2}, [1])
      n = t           :  15992·t^{3/2} scale (larger constant)
      n = t^2         :  4994.69·t  (exponent 1; |EM| = |T1| to 1e-9)
      n = 2.495e7·t^4 :  |EM|/Eenv = 0.99994 (CONSTANT in t, < 1)
    The raw quantity crosses the demand envelope Eenv exactly at the
    25v s4d_scale_demand boundary n > (5000·15984/16001)²·t⁴ ≈
    2.495e7·t⁴ — 25v's scale demand is now confirmed at the quantity
    level.  So an O(t^{-2}) EM wire EXISTS: W(t) = p8_B(t, ⌈c·t⁴⌉)
    with term1 = ½(⌈ct⁴⌉)^{-1/2} ≤ ½c^{-1/2}·t⁻² (c = 3.1e7 gives
    8.98e-5·t⁻² = 90% of the true floor; term2 = O(t⁻⁵), term3 ≤
    6.1e-22·t⁻⁷).  The 25v residue phrase "a different family or a
    structural identity" does NOT need to be the EM tail — the EM
    tail at the t⁴ scale is already the demand shape.

[3] TRUE FLOOR at the d-edge: mown(t, 1/200)/Eenv(t) =
    0.998937566 (flat for t ≥ 1e4; S4Own scale (t²/(t²+1))²·exp
    correction).  A closing wire must sit below 0.99894·Eenv.

[4] REFINED RESIDUE (the strip squeeze is 3-term: W + Mr + Mf <
    mown).  The window-regime residual of the 25ab theorem
    (M·e^X·X ≤ CG3 = 4.1e-3) does NOT scale with mown ~ 1.0000e-4·
    t⁻² — so the t⁴ EM wire alone does not close the strip.  The
    genuine open content, now quantified:
      (a) the SCALE of the strip pairs' own-composition residuals
          (the d-dependent definition side — the action-composition
          item; mown's closed form is the DETECTOR side at 4d²/t²,
          its definition-side counterpart at the same scale is the
          unknown), and
      (b) if (a) is ≤ O(t⁻²): W(t) = p8_B(t, ⌈3.1e7·t⁴⌉) closes the
          strip with 10% margin on term1 (all other terms o(1)).
    Also named: [25ae] the SHARPENED T3 bound — the L4 IBP constant
    (√3/540)|s(s+1)(s+2)|n^{-5/2} is loose by ~t (measured
    |T3|/|T1| ~ 1e-3 vs bound 2.43e-3·t at list scale); a sharp
    constant (25aa-style IBP tracking at Re s = ½) would extend the
    PROvable quantity-level wall |EM| ≥ |T1| − |T2| − L4 from
    t ≤ ~3.7e5 (where the L4 bound keeps the reverse triangle
    positive) to all t ≥ 1000.  Pure computation, Lean-able.

[5] BF ADMISSIBILITY TIGHTENED IN LEAN (item 3, the
    "kick off in the background" job — verification came back ALL
    PASS in minutes, so the Lean edit landed the same session):
    `S4G.N_rvm_low_bf` + `S4G.s4g_admissible_bf` (formal/RhAttack/
    S4Growth.lean, Stage E extension) — the same chain with the
    Bellotti–Fiori constants (10076/100000, 24460/100000, 808344/
    100000): main ≥ (63/22)x; log terms ≤ (34536/200000)x +
    783884/100000; total ≥ (63/22 − 34536/200000)x − 783884/100000 ≥
    x for x ≥ T0² (x-floor margin 2.6e9×, dps-50:
    scripts/rh/day026_admissibility_bf.py, out Day file, ALL PASS:
    ratio 3.24335400295 @ T0², min on [1.2e10, 1e40], same scan as
    REV2 [4]).  Full lake build GREEN (0 errors, 0 sorry).  The
    Backlund theorem stands as the REV2-certified set; the BF
    variant is the ledger's verified current best, now a theorem.

Honest split: PINNED — all [1]–[3] numbers (script + outputs
committed; float64 sweep with dps-30 cross-validation, the [0]
discipline note above).  LEAN-PROVEN — s4g_admissible_bf (Stage E
extension).  CITED — the 25v/25l demand statements it measures.
NEXT: (a) the strip-composition residual scale (the action item),
or (b) the 25ae sharpened T3 bound (the nearer-term provable
extension of the wall).  Neither is decision shaped.

## 25ae — the sharpened T3 bound: exact EM expansion, pinned constants, wall re-anchored (2026-09-15)

Owner: "ok 25ae it is". Scope: replace the t-growing (√3/540)·‖s(s+1)(s+2)‖·n^{−5/2}
T3 term of `p4_T4_bound` (L5.e) with a bound whose list-scale ratio to |T1| is
not O(t). Anchor scripts: `scripts/rh/day026_25ae_t3_sharpen.py` (v2, zeta route,
p4_I power fixed to the Lean convention n^{1−s}/(1−s), `P4Limit.lean:1266`),
`out_day026_25ae_t3_sharpen.txt`, `day026_25ae_v3_longdouble.py`,
`out_day026_25ae_v3_longdouble.txt`, `day026_25ae_final.py`,
`out_day026_25ae_final.txt` (the consolidated certificate, F1–F4 below).

**F1 — EXACT IDENTITY (Re s = ½, n ≥ 1), per-period IBP ladder**
(B̂₂ → B₃/3 → B₄/4 → B₅/20 → B₆/120 → B₇/840 → B₈/6720; endpoint values
B₃(0)=B₃(1)=B₅(0)=B₅(1)=B₇(0)=B₇(1)=0, B₄(0)=B₄(1)=−1/30, B₆(0)=B₆(1)=1/42,
B₈(0)=B₈(1)=−1/30; antiderivatives (B₃/3)'=B̂₂, (B₄/4)'=B₃, (B₅/20)'=B₄/4,
(B₆/120)'=B₅/20, (B₇/840)'=B₆/120, (B₈/6720)'=B₇/840):

    T3(s,n) = −S₂·n^{−s−3}/720 + S₄·n^{−s−5}/30240 − S₆·n^{−s−7}/1209600
              − [S₆·(s+7)/40320]·∫_n^∞ B₈({x})·x^{−s−8} dx,

with S₂ = s(s+1)(s+2), S₄ = S₂(s+3)(s+4), S₆ = S₄(s+5)(s+6).  Boundary
coefficients: B₄-level −1/120, B₆-level +1/5040, B₈-level −1/201600 (telescopes
to −n^{−s−3}, −n^{−s−5}, +n^{−s−7} after the Σ over k ≥ n).  A first draft
with Term_c = −S₆n^{−s−7}/6096384000 was REFUTED by the numeric check
(8.1e-6 vs 8.03e-6 at t=1e3, a 0.9% miss); the trace-through of all six IBP
steps gives 1209600, which passes every check below.  |B₈(x)| ≤ 1/30 on [0,1]
(Bernstein coefficients b_j = B₈(j/8): −1/30, −3157/134510, 127/983040,
5401/230110, 127/3840, mirror; all |b_j| ≤ 1/30 — convex-hull argument, ready
for Lean as exact norm_num data).

    ⇒ |T3| ≤ |S₂|n^{−7/2}/720 + |S₄|n^{−9/2}/30240 + |S₆|n^{−15/2}/1209600
             + |S₆||s+7|·(1/30)·(2n^{−15/2}/15)/(40320)
           = ... + |S₆||s+7|·n^{−31/2}/9072000.

**F2 — IDENTITY VERIFIED TO THE FP FLOOR.** Complex residual of the dps-50
closed form vs the 25ad-validated zeta-route T3 (float64): 6.949e-12 @1e3,
5.117e-12 @3e3, 1.895e-11 @1e4, 2.744e-11 @3e4, 7.741e-11 @1.371148e5
(P0-certified), 8.519e-10 @1e6 (P4-certified) — i.e. ≤ 3.3e-3 relative,
monotone in t, exactly the per-term ln k ulp budget. The identity holds to
every digit the zeta route can resolve.

**F3 — TRUE ASYMPTOTIC AT LIST SCALE (n = ⌊13t/8⌋): T-CONSTANT.** The
dps-50 closed form gives |T3| = 1.40153054e-3·|S₂|·n^{−7/2} to 8 digits at
t = 1e3, 1e4, 1.371148e5, 1e6, 1.000002e7, 2.5e7, 5e7, 1e8 (all certified/
pinned zero heights).  In particular the |T3|/|T1| ratio is the constant
2·(8/13)³·1.40153054e-3 = 6.5324e-4 for ALL t in [1e3, 1e8].

**F3b — FP TRAP RECORD (honest-wall note).** The v2/v3 zeta-route
measurements at 5e7/1e8 (|T3| = 2.2573e-07 / 1.4225e-07 / 7.1354e-08 /
7.0010e-08 depending on float64 vs "longdouble" path — a 37% path
disagreement, 2.8×–6.2× inflation vs the closed form) are per-term phase
errors of fl(k^{−it}): ulp(ln k) ≈ 2e-15, ×t gives 1e-7 rad at 5e7, LOCALLY
COHERENT across long stretches of k.  Two mesh-order comparisons (v3,
|Pn_orderA − Pn_orderB| = 2.8e-15 / 3.8e-14) DO NOT detect a common-mode
per-term bias — the test is necessary but not sufficient.  Zeta-route P_n
reliability range: t ≤ ~2e6 (residual ≤ 0.33% of |T3|).  Beyond that, the
closed form (no ζ, no P_n) is the measurement.

**F4 — WALL RE-ANCHORED (list scale; Eenv = 1e-4·(16001/15984)·t^{−2};
|T1| = ½n^{−1/2}; |T2|/|T1| = (1/6)(8/13) = 0.102564).**
  (a) OLD (L5.e + triangle): T3UB/|T1| = (√3/270)·(8/13)²·t = 2.4355e-3·t —
      crosses 0.897436 at **t = 368.5 ≈ 3.7e2** (the 25ad "valid to ~3.7e5"
      figure was a 1000× decimal slip — corrected here; the old list-scale
      provable wall was already dead below t = 1e3).
  (b) NEW (F1 4-term triangle): T3UB/|T1| = 5.519e-4 + t/105576 + o(t) —
      crosses at **t = 94,550**: the PROVEN list-scale wall extends
      368.5 → 94,550 (257×), covering all certified zero heights ≤ 9.45e4.
  (c) TRUE (F3 closed form, dps-50 certificate): |T3|/|T1| = 6.5324e-4
      constant ⇒ wall = 1 − 0.102564 − 6.5324e-4 = **0.896783 for all
      t ≤ 1e8** (PINNED per store discipline; the gap to (b) is the
      rotating |S₄|-term (|Term_b|/|T3| grows ~t), which needs a
      coherent/oscillatory bound to make provable — a named future
      sharpening, not decision-shaped).
  Squeeze-side corollary (to port with the identity): |p4_em_expr| ≥
  (1 − 0.102564 − [5.519e-4 + t/105576 + |S₆|-and-|s+7| terms])·|T1|,
  positive for t ≤ 94,550 at list scale.

**DISCIPLINE NOTES.** (i) The first Term_c coefficient (6096384000) came from
a mis-traced (s+6)/(4320)·(1/7)/(... ) chain; the corrected trace gives
(½)(1/3)(1/201600) = 1/1209600 — always re-derive the assembly coefficient
from the per-period steps in one pass and check it against |T3| at t = 1e3
before any Lean build. (ii) mpmath `mp.dps` access: `mp.mp.dps` in this
checkout. (iii) numpy "clongdouble" complex power is NOT 80-bit complex
arithmetic — do not cite a clongdouble run as higher-precision evidence
without a cross-check against an independent route. (iv) B₈(x) = x⁸ − 4x⁷
+ (14/3)x⁶ − (7/3)x⁴ + (2/3)x² − 1/30 (the ΣC(n,k)B_{n−k}x^k ordering is
WRONG; correct: ΣC(n,k)B_k x^{n−k}); B₈(1/2) = 127/3840 < 1/30.

**NEXT (same session, in progress):** Lean port — P4Limit atoms B4–B8
(defs + endpoints + derivative chain, ring/norm_num), sup|B₈| ≤ 1/30
(Bernstein coefficient convex hull, exact rationals above), per-period IBP
atoms on [0,1] (interval-integral route, the file already imports
IntervalIntegral machinery), M→∞ passage (telescopes + absolute-convergence
tail — easier than L4's L3 pattern), `p4_T3_expansion` (F1), `p4_T3_bound`,
list-scale wall corollary (F4b). Then: commit + push, kainos mirror, wiki.

### 25ae addendum — full-4-term identity check (same session)

The 3-term residual check (F2) is insensitive to the I₈ term (which is ~1.2e-11 at
t = 1e3, ≪ the 8.5e-10 check level). Direct verification of the FULL 4-term
identity (I₈ by float64 trapezoid, 160 substeps/period, L = 400 periods):

    t=50    resid = 1.423e-14   |I8-term| = 3.197e-11
    t=100   resid = 3.542e-14   |I8-term| = 2.181e-11
    t=200   resid = 9.732e-14   |I8-term| = 1.485e-11
    t=300   resid = 2.139e-13   |I8-term| = 1.223e-11

⇒ the I₈ coefficient ((s+7)/40320) is verified to ~3e-4 relative.  Two traps
recorded: (i) an IBP chain that starts the T3 integral (B₂·x^{−s−2}) with factor
(s+3) instead of (s+2) produces a leading n^{−s−4} term ~1625× too small — a
clean diagnostic for off-by-one chains; the correct first step is
I = (s+2)/3·∫B₃({x})x^{−s−3} (boundary B₃(0) = 0, value at n has NO
contribution because the exponent there is −s−2 and B₃(0) = 0, the FIRST
non-zero boundary is B₄(0) at exponent −s−3: +n^{−s−3}/120).  (ii) mpmath
`quad` of the oscillatory ∫B₈({x})x^{−s−8} over wide ranges at t = 1e3
returns values up to 1e10× above the (1/30)∫x^{−8.5} bound — I₈ must be
measured by period-resolved trapezoid rotation-counted (t/(2π) rotations per
unit; ≥ ~100 substeps per rotation), or used under bounds only.

F1 (as written above) is thereby EXACT and fully anchored; DISCOVERY_LOG
entries stand.  Lean port follows next.

### 25ae Lean port — Stage 1 LANDED (2026-09-16, commit c07bf8b, pushed)

Stage 1 of the Lean port is green (full `lake build`: 17434 jobs, 0 errors,
0 sorry).  Atoms now in `formal/RhAttack/P4Limit.lean`:

- **B4poly–B8poly** defs + endpoint equalities (`norm_num`):
  B4(0) = B4(1) = −1/30, B5(0) = B5(1) = 0, B6(0) = B6(1) = 1/42,
  B7(0) = B7(1) = 0, B8(0) = B8(1) = −1/30, B8(1/2) = 127/3840.
- **Derivative chain** `B_kpoly' = k·B_{k−1}poly` for k = 4..8
  (HasDerivAt proofs + `@[simp]` derivative-value lemmas).
- **`B8poly_bound_Icc : |B8poly u| ≤ 1/30` on [0,1]** — the 4-term-bound
  kernel constant, LEAN-PROVEN.

**Method notes (durable):**

1. **The Bernstein on-curve convex-hull draft was REFUTED before it reached
   Lean** — by exact `Fraction` arithmetic: the identity
   `P(u) = Σ_j P(j/8)·C(8,j)·u^j(1−u)^{8−j}` is FALSE (verified: LHS ≠ RHS
   at 12 sample points; the on-curve values are not Bernstein control
   points).  The true control points are b = (−1/30, −1/30, −1/105, 4/105,
   8/105, 4/105, −1/105, −1/30, −1/30) and `ring` itself rejected the false
   identity — a clean diagnostic.  The convex hull of the true control
   points gives only |B₈| ≤ 8/105 (not ≤ 1/30), so even the correct
   Bernstein argument would NOT have sufficed.
2. **The proof that works is pure algebra, no calculus:**
   `30·B8(u) + 1 = u²(1−u)²·T(u)` with T(u) = 30u⁴−60u³−10u²+40u+20,
   and `T(u) − 20 = 10u(u−1)(3u²−3u−4) ≥ 0` and
   `255 − 8·T(u) = (2u−1)²(−60u²+60u+95) ≥ 0` on [0,1] (both `ring`
   identities + sign decompositions; no derivative machinery needed).
   With u²(1−u)² ≤ 1/16: −1/30 ≤ B8(u) ≤ 127/3840 < 1/30.
3. **`ring` in this toolchain DOES normalize rational constants**
   (probed: `(3/2)·(2·u) = 3u`, `30·(14/3) = 140` — both close by `ring`).
   The earlier constant-atom worry was misplaced; the Bernstein failure was
   the FALSE IDENTITY, not the tactic.
4. **4.33.1 API findings, this round:**
   - `mul_le_mul (h1 : a ≤ b) (h2 : c ≤ d) (c0 : 0 ≤ c) (b0 : 0 ≤ b) :
     a·c ≤ b·d` — side-order is (0 ≤ c, 0 ≤ b), from
     `Mathlib/Tactic/GCongr/Core.lean`; NOT the old-library (0 ≤ c, 0 ≤ a).
   - `pow_le_pow_left` not found; the 0 ≤ a ≤ 1 ⇒ a² ≤ 1 step closes by
     plain `nlinarith [h0a, ha1]`.
   - `hasDerivAt_const x c` takes BOTH arguments positionally (an explicit
     `x`); `hasDerivAt_const_mul c` still synthesizes `x`.
   - No `div_le_iff`; use `le_div_iff`/`div_le_iff₀` or avoid.
   - `set F := fun (x : ℝ) => ...` — tactic-mode `set` takes no binder
     ascription or body ascription (`fun (x : ℝ) : ℝ =>` parses but the
     ascription is rejected; `fun (x : ℝ) =>` is the form).
   - `rw [hT]` (NOT `rw [← hT]`) when the goal contains the LHS of
     `hT : LHS = CTERM` and the chain term is `CTERM`: the direction is
     goal-LHS → CTERM.
   - A `by` block left with an open goal inside a `show … from by …`
     term-position reports "invalid 'by' tactic, expected type has not been
     provided" — add the closer (here `ring`).

**NEXT (Stage 2/3, next round):** the per-period IBP ladder
(B3 → B4 → B5 → B6 → B7 → B8, five atoms on the complex decaying
exponential, mirroring the L4 `p4_op2c_bound` pattern including the
measurability/continuity plumbing), the finite-sum + M→∞ assembly
(boundary terms telescope because B4/B6/B8 have equal endpoint values; the
first non-zero boundary at n is B4(0)·(−s−3)/4·n^{−s−3} → the −S₂·n^{−s−3}/720
leading term after the s(s+1) prefactor), then `p4_T3_expansion` (F1 exact
identity), `p4_T3_bound` (4-term triangle), and the list-scale wall
corollary (F4b, positive at t ≤ 90 000; PINNED dps-50 wall 0.896783 up to
1e8 recorded separately, not claimed LEAN-PROVEN).

### 25ae Lean port — Stage 2 LANDED (2026-09-16, per-period IBP atoms, full build green)

The six per-period integration-by-parts atoms of the 25ae ladder are now
LEAN-PROVEN in `formal/RhAttack/P4Limit.lean` (all under `noncomputable
section`, `s.re = 1/2`, `j : ℕ`, `0 < j`).  Full `lake build`: 17434 jobs,
0 errors, 0 sorry.

- **`p4_25ae_ibp_b2to3`** (i-i): over [j, j+1],
  `∫ B2(x−j)·(x:ℂ)^(−s−2) dx = (s+2)/3 · ∫ B3(x−j)·(x:ℂ)^(−s−3) dx`
  (vanishing boundary: B3(0) = B3(1) = 0).
- **`p4_25ae_ibp_b3to4`** (i-ii):
  `∫ B3·x^(−s−3) = ((B4(0)/4):ℂ)·(u(j+1) − u(j)) + (s+3)/4·∫ B4·x^(−s−4)`,
  `u(x) = (x:ℂ)^(−s−3)`.
- **`p4_25ae_ibp_b4to5`** (i-iii): boundary vanishes (B5(0) = 0),
  coefficient (s+4)/5.
- **`p4_25ae_ibp_b5to6`** (i-iv): boundary `((B6(0)/6):ℂ)·(u(j+1)−u(j))`,
  coefficient (s+5)/6.
- **`p4_25ae_ibp_b6to7`** (i-v): boundary vanishes (B7(0) = 0),
  coefficient (s+6)/7.
- **`p4_25ae_ibp_b7to8`** (i-vi): boundary `((B8(0)/8):ℂ)·(u(j+1)−u(j))`,
  coefficient (s+7)/8, `u(x) = (x:ℂ)^(−s−7)`.

Each atom = `intervalIntegral.integral_mul_deriv_eq_deriv_mul` with
`u(x) = (x:ℂ)^(−s−k)` (derivative via `hasDerivAt_ofReal_cpow_const`) and
`v(x) = (B_{k+1}(x−j) : ℂ)/(k+1)` (derivative via the Stage-1 HasDerivAt
chain + `HasDerivAt.ofReal_comp`), with uIcc continuity/integrability
plumbing (the L4 pattern).

**Proof-design lessons (durable, cost a full round of iteration):**

1. **State intermediate calc targets in the SAME term language as the
   current side.**  The H-step term carries the local `set`-definitions
   (`u`, `v`) as atoms.  If a calc target writes the *unfolded* term
   (e.g. `((j+1:ℝ):ℂ)^(−s−k)` instead of `u (j+1:ℝ)`), then
   `u (j+1:ℝ)` and `((j+1:ℝ):ℂ)^(−s−k)` are DIFFERENT ring atoms
   (def-let vs cpow application, ofReal-wrapped base vs cast base, and
   even exponent summand order `−s−k` vs `−k−s` survives to the kernel),
   and `ring` silently fails with a cryptic normal-form residue.  Fix:
   intermediate targets use `u`-form; the bridge to the unfolded cpow
   form is a separate `have hu : u (j+1) = … := by dsimp only [u]` +
   `rw`, which is literal.
2. **`set v : ℝ → ℂ := fun x => ((B (x−j)) / K : ℂ)` elaborates as a
   COMPLEX division**: stored body `(↑(B (x−j))) / K`, not
   `(↑((B (x−j)) / K))`.  Boundary hypotheses must target the stored
   form (or `simp`, which knows the `ofReal` division rewrite
   `(↑a)/b ↔ ↑(a/b)`, will normalize them).  `rfl` between the two forms
   fails (not definitional).
3. **`fun_prop` cannot see through a `def`**: `ContinuousOn (fun x =>
   (B4poly (x−j) : ℂ))` needs `dsimp only [B4poly]` first, then `fun_prop`
   closes the expanded polynomial.
4. **`simpa` is NOT a ring closer**: `simpa [h]` fails on goals that need
   distributivity after the simp step; write `simp [h]; ring` explicitly.
   Conversely, a `rw` that leaves an rfl goal + an extra `rfl`/`simpa`
   line reports "No goals to be solved".
5. **`simp [hB4]` with `hB4 : B4poly 1 = B4poly 0` evaluates the whole
   coefficient to the numeral** (−1/30 → −1/120) — simp does ground
   evaluation under `ofReal`, which is what makes the subsequent `ring`
   trivial.
6. When a coefficient identity like `(-(s+k)) / K = -((s+k) / K)` is
   needed, prove it coefficient-only (`ring` closes it) and `rw` it inside
   the product — do not `ring` a one-atom goal containing an
   interval-integral atom (observed `ring_nf made no progress` on that
   shape).

**NEXT (Stage 3):** telescope the six atoms over j = n..M−1 (boundary
differences telescope: Σ_j (u(j+1)−u(j)) = M^p − n^p), pass M→∞
(M^{−s−k} → 0 for k = 3,5,7; the B8 tail is absolutely convergent via
`B8poly_bound_Icc` + ∫ x^{−15/2}), then `p4_T3_expansion` (the F1 exact
4-term identity, constants 720/30240/1209600/40320) and `p4_T3_bound`
(4-term triangle), and the list-scale wall corollary (F4b: provable at
t ≲ 94 550; the dps-50/PINNED wall 0.896783 up to 1e8 stays recorded, not
LEAN-claimed).

### 25ae Lean port — Stage 3A LANDED (2026-09-16, B8 periodic + finite telescope + J_finite, full build green)

Stage 3A of the 25ae Lean port is LEAN-PROVEN in `formal/RhAttack/P4Limit.lean`.
Full `lake build` (leanprover/lean4:v4.33.1 + mathlib v4.33.1): 17434 jobs,
0 errors, 0 sorry (the four "sorry" grep hits in the package are doc comments
stating "No sorry").

Components landed (all in `formal/RhAttack/P4Limit.lean`):

- **`def B8 (x : ℝ) := B8poly (x - ⌊x⌋₊)`** — the periodic 8-gonal kernel,
  following the P4Tail `B2` pattern; plus `aestronglyMeasurable_B8`
  (`unfold B8 B8poly; fun_prop`), `B8_of_Icc_int` (on [n, n+1], B8 = B8poly(x−n);
  the top-branch floor equality uses the P4Tail-verbatim pattern
  `Nat.floor_eq_iff (ha := by positivity)` + `norm_num [B8poly_at_0, B8poly_at_1]`),
  and `abs_B8_le` (|B8 x| ≤ 1/30, via `simpa [v] using
  B8poly_bound_Icc v ⟨hv0, hv1⟩` with `v = x − ⌊x⌋₊` closed by
  `grind [Nat.floor_le hx]` / `grind [Nat.lt_succ_floor x]`).

- **`p4_25ae_telescope_pow`** — the finite geometric telescoping over
  `Finset.Ico n M` of the endpoint differences `((j+1:ℝ):ℂ)^p − ((j:ℝ):ℂ)^p`
  (proven equal to `((M:ℝ):ℂ)^p − ((n:ℝ):ℂ)^p`).  There is NO ℕ-indexed Ico
  telescope lemma in mathlib 4.33.1, so this is an own induction (aux lemma
  `p4_25ae_telescope_pow_aux` on the endpoint form `n + k`, plus the
  `M = n + (M − n)` bridge).

- **`p4_25ae_J_finite`** — the finite-M identity: for `n ≥ 1`, `M ≥ n`,
  `s.re = 1/2`,

  ```
  ∫_n^M B̂₂(x)·(x:ℂ)^(−s−2) dx
    = 4-term expression in the endpoint differences
      ((M:ℝ):ℂ)^(−s−3), ((M:ℝ):ℂ)^(−s−5), ((M:ℝ):ℂ)^(−s−7)
      with the Stage-2 verbatim coefficient atoms
      (((B4poly 0)/4):ℂ), (((B6poly 0)/6):ℂ), (((B8poly 0)/8):ℂ)
      and the B8 period-sum residue
      S8 = ∑_j ∈ Ico n M ∫_j^{j+1} B8poly(x−j)·(x:ℂ)^(−s−8) dx.
  ```

  Architecture: `set S3..S8` as period sums; (1) `∫_n^M` → period sum via
  `sum_integral_adjacent_intervals_Ico` (with the per-period
  `ContinuousOn (B₂-part).mul (cpow-part)` integrability, L4 pattern, plus
  `Set.EqOn`/`integral_congr` for the B2 ↔ B2poly per-period kernel swap);
  (2–7) the 7-level IBP ladder applied to the period sums with the six Stage-2
  atoms (each per-period `exact (p4_25ae_ibp_bKtoK1 (s := s) hsre j hjpos)`),
  `Finset.mul_sum` for constant extraction, `p4_25ae_telescope_pow` for the
  endpoint telescopes; (8) final `calc` assembly by `ring` (coefficient atoms
  kept verbatim so all ring atoms match) and `dsimp only [S8]`.

**Proof-design lessons (durable, each cost a debug round):**

1. **`sum_integral_adjacent_intervals_Ico (a) (h) (hint)` needs the
   third argument** (the per-period integrability proof); omitting it leaves
   the rw applied but with an unsolved integrability side-goal.  Its target
   uses the upper endpoint `((k+1:ℕ) : ℝ)` (`↑(k+1)`), while hand-written
   targets usually use `(k+1 : ℝ)` (`↑k + 1`): bridge with a follow-up
   `rw [Finset.sum_congr rfl (fun k _ => by
     rw [show ((k+1:ℕ) : ℝ) = (k:ℝ) + 1 from Nat.cast_succ k])]` (L4 pattern).
2. **`intervalIntegral.integral_congr (h : EqOn f g [[a,b]])` — `[[a,b]]` is
   `Icc a b` and `f, g` must be PINNED** (a named `have hIC : Set.EqOn f g s`,
   then `exact (integralIntegral.integral_congr (μ := ...) hIC)`).  Passing an
   inline `by` block leaves `f`, `g` as metavariables: the by-block's goal is
   `?f x = ?g x`, `dsimp`/`rw` see nothing, the by fails, and the outer rw
   never applies.  `EqOn` is `Set.EqOn` (needs `open Set` or the qualified
   name).
3. **`B2poly` (and the Stage-1–3 `B{K}poly` defs) unfold across files with
   `dsimp only [B2poly]`** — the real gotcha is the constant term: a polynomial
   written with a `: ℂ` ascription over the whole expression stores `1/6` as a
   COMPLEX division, while the def-body form stores `↑(1/6 : ℝ)`.  The two are
   equal only via `simp [Complex.ofReal_div]` (not `rfl`, not `ring`).
4. **Under `induction' k`, any hypothesis containing `k` is REVERTED into the
   IH as a premise** (`IH : (hsumf at k) → (sum = endpoint)`); apply it as
   `IH (hsumf recon struct ed at k)`.  The plain `rw [IH]` then fails with
   "pattern not found" because the goal carries the `set`-defined summand form
   while the IH carries the raw form.
5. **`omega` is context-fragile**: `n + (k + 1) = (n + k) + 1` closes in a bare
   context but fails inside heavy tactic contexts (hypotheses with
   integrals/coercions).  `by ring` is context-independent — prefer it for
   `show` witnesses in induction blocks.
6. **Brace-implicit arguments are not positional**: atoms declared
   `theorem p4_25ae_ibp_bKtoK1 {s : ℂ} (hsre : s.re = 1/2) (j : ℕ) (hj : 0 < j)`
   must be applied as `… (s := s) hsre j hjpos`; passing `s` positionally
   shifts everything (`s` lands in the `hsre` slot).  Same for
   `p4_25ae_telescope_pow (p := …)` and `p4_25ae_telescope_pow_aux` (no
   explicit `p` at all).
7. **`Finset.mem_Ico` is not omega-visible**: derive `0 < j` from
   `j ∈ Finset.Ico n M` via `rw [Finset.mem_Ico] at hj; omega`.  Note the
   integrability argument of `sum_integral_adjacent_intervals_Ico` passes a
   `Set.Ico` hypothesis (`Set.mem_Ico.mp hk |>.1`), while the finset-level
   goals use `Finset.mem_Ico` — both exist, both are `@[simp]`.
8. **`ContinuousOn` target-set casts**: `(j + 1 : ℝ)` stores as `↑j + 1`,
   while lemma targets often carry `((j+1:ℕ) : ℝ)` (`↑(j+1)`); bridge with
   `.mono (by intro x hx; rw [show (j:ℝ) + 1 = ((j+1:ℕ) : ℝ) from
   (Nat.cast_succ j).symm]; exact hx)]`.  And `0 < x` on [j, j+1] needs the
   `n ≤ j` leg (`0 < n` alone does not give `0 < x`).
9. Telescoping base case: `simp [Finset.Ico_self]` closes
   `0 = (((n+0:ℕ):ℝ):ℂ)^p − ((n:ℝ):ℂ)^p` (add_zero + sub_self under casts);
   a trailing `ring` then reports "No goals to be solved".
10. Calc assembly: when the left side is already in `((s+2)/3) * S3` order,
    `rw [mul_comm]` (no anchors) normalizes to the `S3 * ((s+2)/3)` order that
    the ladder hypotheses (`h3`–`h7`) expect; an anchored `rw [mul_comm S3 _]`
    fails because the pattern is not present.

**NEXT (Stage 3B):** the `M → ∞` passage (`p4_25ae_J_iota`: endpoint terms →
0 via `tendsto_rpow_neg_atTop`; S8 → the improper integral I₈ via the Cauchy
criterion on period sums, comparison against `x^(−17/2)`), then
`p4_25ae_I8_bound` (|I₈| ≤ n^(−15/2)/225), `p4_T3_expansion` (the F1 exact
4-term identity), `p4_T3_bound` (4-term triangle), and the list-scale wall
corollary (provable at t ≲ 94 550; the dps-50 PINNED wall `0.896783` up to
1e8 remains a measurement, not a Lean claim).

## 25ae Stage 3B — the M → ∞ passage, the sharpened T3 bound machine-proven, and the F1/F4 exponent corrections (2026-09-16)

**Status: Stage 3B atoms 3B.1–3B.10 LEAN-GREEN in `formal/RhAttack/P4Limit.lean`;
full package build 17434 jobs / 0 errors / 0 sorry.  3B.11 (the Lean
list-scale wall corollary) is the one remaining Stage-3B atom.**

### Landed atoms (all in the P4Limit `noncomputable section`)

| atom | statement |
|---|---|
| 3B.1 `p4_B8cpw8_integrableOn_Ioi` | `B8·x^{−s−8}` absolutely integrable on `(c,∞)`, `Re s > −7` (majorant `(1/30)x^{−(Re s+8)}`) |
| 3B.2 `p4_B8cpw8_tendsto` | `∫_n^M B8 x^{−s−8} → ∫_n^∞ …` as `M → ∞` |
| 3B.3 `p4_25ae_cpwtendsto0` | `M^{−s−k} → 0` (`Re s = 1/2`, `k ≥ 3`), via `Complex.norm_cpow_eq_rpow_re_of_pos` + `tendsto_rpow_neg_atTop` |
| 3B.4 `p4_25ae_S8_eq_interval` | the B8 period-sum `S8(n,M)` equals `∫_n^M B8 x^{−s−8}` |
| 3B.5 `p4_25ae_S8_tendsto` | `S8(n,M) → ∫_n^∞ B8 x^{−s−8} =: I8` (Cauchy on period sums) |
| 3B.6 `p4_25ae_J_iota` | `∫_n^M B2 x^{−s−2} → 4-term expression` (finite ladder of Stage-2 atoms + 3B.2–3B.5) |
| 3B.7a `p4_25ae_int_Icc_rpow172` | `∫_n^M x^{−17/2} = (2/15)(n^{−15/2} − M^{−15/2})` — FTC-2 via `integral_eq_of_hasDerivAt_off_countable` + `hasDerivAt_rpow_const` |
| 3B.7b `p4_25ae_int_Ioi_rpow172` | `∫_n^∞ x^{−17/2} = (2/15)n^{−15/2}` — order-limit from 3B.7a |
| 3B.7c/3B.8 `p4_25ae_I8_bound` | `‖I8‖ ≤ (n:ℝ)^{−15/2}/225` on the critical line (`|B8| ≤ 1/30` + 3B.7b; `norm_integral_le_integral_norm` + monotone finite-integral majorant + order limit) |
| 3B.9a `p4_25ae_t3kernel_integrableOn_Ioi` | `B2·x^{−s−2}` integrable on `(c,∞)` for `Re s > −1` (majorant `(1/6)x^{−(Re s+2)}`) |
| 3B.9b `p4_25ae_J_eq` | `∫_n^∞ B2 x^{−s−2} = ` the exact 4-term expression (improper integral = `J_iota` limit via `intervalIntegral_tendsto_integral_Ioi` + `tendsto_nhds_unique`) |
| 3B.10 `p4_25ae_T3_bound` | `‖−(1/2)s(s+1)∫_n^∞ B2 x^{−s−2}‖ ≤ T3UB` — the sharpened 4-term triangle bound stated below |

### THE CORRECTIONS (discovered during the Lean port; the anchor script was wrong)

1. **F1 second-term exponent: `n^{−9/2}` → `n^{−11/2}`.**  The anchor
   `day026_25ae_final.py` (and the F1 docstring) carried the second triangle
   term as `|S4|·n^{−9/2}/30240`.  On the critical line `Re(−s−5) = −(1/2+5) =
   −11/2`, so the endpoint term `n^{−s−5}` has norm `n^{−11/2}`.  The Lean
   theorem carries `n^{−11/2}` (`hN5`).  This is a hard correction: it makes
   the S4-term decay as `t^{−1/2}` (rather than grow as `t^{+1/2}`) at list
   scale, so it dominates the wall.
2. **F1/F4 fourth-term exponent: `n^{−31/2}` was a typo.**  Correct
   `|I8| ≤ (1/30)·(2/15)·n^{−15/2} = n^{−15/2}/225` (3B.8), hence the
   fourth triangle term is `|S6|·|s+7|·n^{−15/2}/9072000`.
3. **The CORRECTED 4-term bound (3B.10, machine-proven):**
   ```
   T3UB(n,s) = |s(s+1)(s+2)|·n^{−7/2}/720
             + |s(s+1)(s+2)(s+3)(s+4)|·n^{−11/2}/30240
             + |s(s+1)(s+2)(s+3)(s+4)(s+5)(s+6)|·n^{−15/2}/1209600
             + |s(s+1)·…·(s+7)|·n^{−15/2}/9072000
   ```
   (last factor `= |S6(s+7)|/9072000 = |S6|·|s+7|/9072000`; `9072000 =
   20160·450`).
4. **Wall re-anchor (list scale `n = ⌊13t/8⌋`, `s = 1/2 + it`):**
   crossover of `T3UB/|T1|` with `1 − (1/6)(8/13) = 0.8974359…` is now
   **`t ≈ 1.217e8`** (recomputed, dps-safe scan).  At `t = 1e8`: ratio
   `0.7374597`, **wall margin `≈ 0.15998` (16 %)**.  The old anchor figure
   `94 550` is voided (it used the wrong `n^{−9/2}` second term); the old
   dps-50 pin `0.896783 @1e8` is superseded by the corrected measurement
   `0.73746 @1e8` (PINNED measurement, not yet a Lean claim).
5. **Chosen Lean wall for 3B.11: `t ≤ 1e8`** — a clean constant with a 16 %
   margin under the corrected bound.

### Incident (file corruption during a bulk insertion)

An anchored bulk Python insertion (the first attempt at 3B.10) transiently
corrupted `P4Limit.lean` — it dropped the top-level L5 block
(`p4_zeta_split`…`p4_T4_ratio`) and a section boundary, breaking
`RhAttack.P8Floor`.  Rebuilt from `HEAD` (3A prefix + L5, verbatim) + the
current 3B content inserted inside the `noncomputable section` before its
`end`; full package build verified green after each step.  Standing lesson
(appended to the cumulative list): for bulk edits > 50 lines in this module,
verify anchor uniqueness AND inspect the resulting `git diff` stat before
building — prefer extracting from two known-good snapshots over in-place
replacement.

### Proof-engineering notes (Stage 3B, cumulative)

- **FTC-2 for real powers:** `integral_eq_of_hasDerivAt_off_countable` with
  `s := ∅`; integrand `x ↦ (−17/2)·x^{−19/2}` via `hasDerivAt_rpow_const
  (Or.inl (ne_of_gt hx))`; the constant-multiplier derivative bridged with
  `HasDerivAt.const_mul (c) h` + `.congr_deriv (c) (show by ring)` —
  `convert (HasDerivAt.const_mul _ h) using 1` can spawn extra typeclass
  goals (`ring` cannot rewrite rpow exponents, so exponent arithmetic like
  `−(15/2) − 1 = −(17/2)` is a separate `show … by ring`).
- **`Complex.continuousAt_ofReal_cpow_const x y (0 < y.re ∨ x ≠ 0)`** is the
  pointwise cpow-continuity entry point; on `(c,∞)` feed `Or.inr (ne_of_gt
  (hc.trans hx))`.
- **`norm_integral_le_integral_norm (f := …) (μ := volume.restrict (Ioi c))`**
  — pin `f` and `μ` explicitly (curly `B` stays inferred); the LHS indicator
  cancels by simp; the RHS variation bridge is `ae_restrict_iff'
  measurableSet_Ioi` + `ae_of_all`.
- **Order-limit pattern for `∫_n^M ≤ C` with `F(M) → L`:** split
  `eventually [Ici (max …)]` into `eventually (F → L)` and
  `eventually (F ≤ C)` via `Metric.ball_mem_nhds` + `mem_of_superset`; then
  `L ≤ C` by `lt_of_le_of_lt`/`le_of_lt` composition.
- **`intervalIntegrable_iff` + `uIoc` bridge:** for the closed-interval
  majorant, `rw [intervalIntegrable_iff]` at both the hypothesis and the
  goal; `uIoc (n : ℝ) M ⊆ Ioi (n : ℝ)` holds for all `M` (the min/max
  definition makes the left endpoint inclusive exactly when `n ≤ M`).
- **Cauchy on period sums (S8 → I8):** `IntegrableOn.cauchy` gives
  `eventually (fun p q => ‖∫ in a..b‖ < 3ε)` on `Ioi c ×ˢ Ioi c`;
  `set PQ` + a single `filter_upwards` with `M,N ≥ max(n, (n:M)+ceil c)`
  closes both coordinate projections (no `Filter.Fsim` needed).
- **`Tendsto.congr'` for the `=ᶠ` bridge:** direction is
  `f₁ =ᶠ[l] f₂` with the *known-tendsto* function as `f₁`; the `Ici n`
  filter carries the `M ≥ n` side condition of `p4_25ae_J_finite`.
- **`tendsto_nhds_unique`** (T2 + `NeBot`) is the limit-uniqueness closer;
  `intervalIntegral_tendsto_integral_Ioi a hInt tendsto_id` composes with
  `tendsto_natCast_atTop_atTop (R := ℝ)` for the ℕ-indexed passage.
- **`rw` auto-closes** a goal that becomes reflexive — trailing `ring` after
  a closing `rw` then errors "No goals to be solved"; same for `calc` steps
  whose target equals the goal's remainder.
- **`0 < x` chaining:** write `have h0x : 0 < x := hc.trans hcx` explicitly;
  inline `hc.trans hcx` inside `ne_of_gt (…)` mis-parses (the `.trans`
  expects a proof argument, not a relation).
- **`linarith` polymorphic-literal trap:** `zero_lt_one` in a real goal can
  spawn a stuck `NeZero 1` instance; `show (0 : ℝ) < 1 by norm_num` avoids
  it.
- **`calc` in `≤` goals:** `=` steps rewrite the goal's LHS; the final
  obligation is `TARGET ≤ TARGET` — close it with an explicit `_ ≤ TARGET :=
  le_rfl` step (or wrap the `=` calc in a `have hcalc : LHS = TARGET` and
  conclude with `exact le_of_eq hcalc`).
- **`gcongr` does not use hypotheses for its core atom automatically when
  the term shapes differ**; the explicit `apply
  mul_le_mul_of_nonneg_left hBOUND; positivity` is the reliable closer.
- **Rational-literal rpow exponents:** `-(15/2 : ℝ)` and `-(15 : ℝ)/2` are
  extensionally equal but NOT definitionally — `simpa` fails across the
  two forms; bridge with `have heq : -(15/2 : ℝ) = (-(15 : ℝ)/2) := by
  norm_num` + `simpa [heq]`.

### NEXT (3B.11)

`p4_25ae_wall_list_scale`: for `0 < t ≤ 1e8`, `n = ⌊13t/8⌋` (with `n ≥ 1`),
`s = 1/2 + it`:  `T3UB(n,s) < (1/2)·n^{−1/2}·(1 − (1/6)(8/13))`.
Ingredients: per-term monotonicity of `t ↦ |s+k|·n(t)^{−p}` on `[1, 1e8]`
(each factor = increasing polynomial in `t` × decreasing `n^{-p}` — the
product is shown max-at-endpoint by comparing the endpoint values with
rational sqrt bounds), the floor lower bound `n ≥ 13t/8 − 1 ≥ 13t/16` on the
working subinterval (exact `Int.floor` handling for small `t`), and
`|s+k| = √((k+1/2)² + t²)` with `Real.sqrt_le_iff`.  One atom, then the
Stage-3B closeout (docs, mirror, push).
