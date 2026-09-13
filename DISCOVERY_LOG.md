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
