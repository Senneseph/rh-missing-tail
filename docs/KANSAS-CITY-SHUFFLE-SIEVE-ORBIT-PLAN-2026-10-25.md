# KANSAS CITY SHUFFLE — the Second Orbit (Sieve Action) — PLAN

**Status: SEED + PLAN. Not executed.** (Owner convention: no execution from
the note alone.)
**Date:** 2026-10-25. **Companion seeds this formalizes:**
`IDEA-SEED-PRIME-LATTICE-2026-10-22.md` (reverse sieve: *"solve the
reverse sieve by distributing its cuts in a new branching lattice"*),
`IDEA-SEED-PRIME-LATTICE-CHIMES-2026-10-22.md` (*"…a compass to the
area we must traverse before the next prime — can it predict the next
prime?"*), and the orbit line `formal/RhAttack/Orbit.lean` /
`docs/ORBIT-FORMALIZATION.md`.

**No RH claim.** This program touches no zeta-face object. It is a
prime-gap statistic + sieve-identity + finite Fourier-algebra program,
all independently of RH. (If it later serves as a C-channel *oracle*
cross-certifier, that flank use is flagged face-relevant at the time;
today it is a **flank**, off the zeta-face board.)

---

## 1. The Shuffle (the idea, owner's words + reconstruction)

> "What if we need a SECOND orbit to HOP, SKIP, and JUMP over the need
> for further refinement of crunching numbers? What if we create some
> kind of Fourier-compatible representation of the Sieve of
> Eratosthenes, maybe as an Action series, and its operator and similar
> output that we might have for zeta (being a forward-running search and
> mark process of processes) has something we need for the TWO together,
> zeta and sieve, to just cancel out something annoying or offer a
> better prediction for how to 'predict the next prime' — deep-deep down
> the Heart of this matter."

Reconstruction (faithful):

1. **A second orbit.** `Orbit.lean` proved the *drift orbit* (step vs
   sum; anchor `G0`). The owner proposes a **sieve orbit**: local
   reading = per-hop survivor structure, global reading = the final
   sieved structure. "Hop, skip, jump" = answer fine-structure
   questions *on the sieve side* without grinding the zeta side further.
2. **The sieve as a Fourier-compatible Action series.** The sieve is a
   *forward-running mark process* (p = 2, 3, 5, 7, …), exactly the
   campaign's C-channel shape (forward-running search and mark). The
   campaign's own "Action series" idiom is `THE-EULER-ACTION.md` (the
   flat/total-differential Euler action identity, verified E7a at the
   dps floor). The shuffle asks: **what is the sieve's Action identity,
   and what is its Fourier (character) representation?**
3. **Two together, zeta + sieve.** Both processes share the *Euler
   factor* `(1 − χ(p) p^{−s})`: sieve-side as the combinatorial factor
   `(1 − χ(p)/p)` (exact, finite), zeta-side as the Dirichlet L-factor
   (analytic). The "something annoying" = the **asymptotic remainders**
   (2^{π(z)} sieve worst-case; the e^{−γ} Mertens constant) — the
   shuffle claims the *shared flat action* localizes both to **finite,
   computable edge sums** (hop/skip/jump over the grind). And the
   "better prediction" = a **class-level next-gap prediction** with a
   rigorous margin (the chime's "compass," made exact).

## 2. The mathematics it stands on (KNOWN — not reinventing)

- **Legendre's exact identity.** `φ(x, z) = #{n ≤ x : (n, P̄(z)) = 1} =
  Σ_{d | P̄(z)} μ(d) ⌊x/d⌋`, with `P̄(z) = ∏_{p≤z} p`. Exact; by
  induction. (This is the sieve *count*; no asymptotics.)
- **The character-sieve identity (the Action series).** For a Dirichlet
  character `χ` mod m:
  `V_z(x) := Σ_{n≤x} χ(n)·1_{(n,P̄(z))=1} = Σ_{d | P̄(z)} μ(d) χ(d) ⌊x/d⌋`,
  and `V_z(x) = x · ∏_{p≤z, (p,m)=1} (1 − χ(p)/p) + R_χ(x, z)` with the
  remainder `R_χ(x,z) = Σ_{d|P̄} μ(d) χ(d) {x/d}` **exact**. (Classical;
  Ramanujan-sum / sieve-remainder structure.)
- **The shared Euler factors.** The zeta-side object with the *same*
  factors is the **Dirichlet L-function** `L(s, χ) = ∏_p (1 − χ(p)
  p^{−s})^{−1}`; the sieve profile `∏_{p≤z}(1 − χ(p)/p)` is its
  finite, s=1-flavored combinatorial shadow. ζ itself is the
  χ≡trivial case.
- **The grind being hopped.** The naive bound `|R_χ| ≤ 2^{π(z)}`
  (worst-case over the squarefree d). Exponential in π(z) — the
  "crunching numbers" grind. The shuffle's claim: the flat action
  localizes the *actual* `R_χ` to the finite edge sum
  `Σ_{d|P̄} μ(d)χ(d){x/d}` — **measured ≪ worst case** (the hop).
- **The two-together prediction (the chime metric, made exact).**
  Hardy–Littlewood prime-pairs: pairs `(p, p+2k)` counted below X at
  rate `W(2k) · X/(ln X)²` with the **singular series**
  `W(2k) = 2 C₂ ∏_{q>2, q|k} (q−1)/(q−2)`, `C₂ ≈ 0.660162` (the twin
  constant) — an **Euler product of the sieve's cut factors** (exactly
  the reverse-sieve seed's *"distributing its cuts"*). Consecutiveness
  adds `≈ e^{−k/ln X}` (the k odd interior integers, each prime with
  probability ≈ 1/ln X). The *class frequencies* (e.g. gaps ≡ 2 vs ≡ 0
  mod 4) are predicted by
  `predicted(class) ∝ Σ_{k in class} W(2k) · e^{−2k/ln X}`.
  **VERIFIED ANCHOR (U3, 2026-10-25)**: the mod-4 gap-class bias is
  exactly the Lemke Oliver–Soundararajan statistic (arXiv:1603.03720,
  "Unexpected biases in the distribution of consecutive primes"): their
  Main Conjecture (under HL k-tuples) gives, for q = 4, Eq. (5.1):
  pair-count `li(x)/4 · (1 ± (1/(2 ln x)) · ln(2π ln x / 4))`, sign −
  on the diagonal pairs (gap 0 mod 4), + on the off-diagonal (gap 2
  mod 4); the bias **vanishes as loglog x / ln x → 0**. Measured at
  X = 10^8 (this repo's exact sieve, 5,761,454 gaps): gap ≡ 2 mod 4
  share = **0.556519** (95% CI ±0.00081); the two-together model
  predicts 0.550315 (89% of the bias explained, decisively beating
  the one-channel 0.5 baseline); the LOS leading+c₂ terms give
  0.545674, with the next order O((ln x)^{−7/4}) ≈ 0.012 the sized
  gap — named refinement U3b (RUN 2026-10-25: the leading term
  reproduces 0.545670 at 1e8, 4e-6 from the recorded value; the sized
  gap resolves into the transfer coefficient — see §7). **RETRACTION (recall incident, P-0
  discipline)**: an earlier draft of this plan cited a "~65/35
  benchmark (GPY/Maynard/Tao)" — that figure was UNVERIFIED MEMORY,
  contradicted by both the measurement (55.7/44.3 at 1e8) and the
  verified literature (the class limit is 1/2 with a loglog-decaying
  bias, not 65/35). Corrected here; the incident is logged in
  discovery 0170.
- **Maynard's method as precedent.** Bounded prime gaps are *proved* by
  a multidimensional Selberg weight — a **Fourier/orthogonality
  optimization of a sieve Action**. "Sieve as harmonic analysis" is a
  live, proved research method, not a fantasy.
- **Parity (the sieve orbit's opacity).** Sieves are *blind to parity*
  (a number's even vs odd number of prime factors beyond z): no
  first-order sieve counts primes from below. Classical; see
  Friedlander–Iwaniec *Opera de Cribro*. This is the **structural
  opacity of the second orbit**, and its **closing operator is the
  zeta side** (Dirichlet non-vanishing / zero-free regions give the
  *partial* anchors: AP-PNT, Chen 1+2, Maynard bounded gaps).
  ↔ exactly the orbit-1 / anchor correspondence of
  `docs/ORBIT-FORMALIZATION.md`.

## 3. What is NEW (the campaign's honest claims)

| # | Claim | status | honesty mark |
|---|---|---|---|
| N1 | **Sieve Action identity**: the flat-action (summation-by-parts) reading of the Legendre recursion `U_j(u) = U_{j−1}(u) − U_{j−1}(⌊u/p_j⌋)` / character version `V_j(u) = V_{j−1}(u) − χ(p_j) V_{j−1}(⌊u/p_j⌋)` — the sieve as a *total-differential Action*, E7a-verified exact at reachable scale (exact integer arithmetic; the zeta-side twin is the E7a Euler action). **STATUS U1a (2026-10-25): VERIFIED EXACT** on 42 configurations (z ≤ 31, x ≤ 10^7, χ = 1 and χ = (·/4)) — with the refinement that the multiplicative side is `Σ_{d|P̄} μ(d)χ(d) S_χ(⌊x/d⌋)` with the character prefix S_χ (the ⌊x/d⌋ form is the PRINCIPAL specialization); for non-principal χ the whole quantity is a bounded exact integer (|V| ≤ 4 measured) — no grind on that orbit at all. | **U1 COMPLETE** (a: 0170, b: 0170, c: 0185) | the recursion is textbook-true; the *verification + combined two-process identity* is the deliverable |
| N2 | **Fourier sieve operator theorem (finite, exact)**: on `Z/NZ`, N = P̄(z) squarefree, the per-prime mark `K_p` = pointwise mult. by `1_{p∤·}` is a self-adjoint IDEMPOTENT (eigenvalues 0/1), and the marks commute; its Fourier symbol is the exact comb `F(1_{p∤·}) = N·δ_0 − (N/p)·1_{p-torsion}` (p support points: value N at the origin, −N/p on the rest of the p-torsion subgroup of the character group); the full-sieve symbol is the iterated convolution of the combs = the RAMANUJAN field `F(1_{(·,N)=1})(a) = c_N(a) = φ(N)·μ(k)/φ(k)`, k = N/gcd(a,N) — and for squarefree N this has FULL support (all N characters, 2^{π(z)} level sets; the sparse combs convolve into a dense field — the opacity lives in the convolution, not in any single chime); `φ(N)` falls out of Parseval. **CORRECTION (U2 run, 0172, 2026-10-25):** the earlier draft's `DFT(1_{units}) = (1/P̄)·1_{Ĝ[P̄-torsion]}` was WRONG at measurement (it asserted a torsion-subspace support; the measured field is full-support Ramanujan — see tmp/kcs2_out.txt). | **U2 MEASURED (0172); LEAN WAVE-1 GREEN (0175: SieveAction.lean builds, 8706 jobs)** | finite exact algebra, exact-integer right-hand sides; the *chime-comb + full-Ramanujan-field package with the sparsity→density reading* is new here |
| N3 | **Sieve orbit width = the parity gap**, stated as the orbit-2 analogue of `surjWidth`: local reading (per-hop survivors) vs global (final structure); width = measured first-order upper/lower sieve gap; parity = the opacity; anchor = the zeta/L-side (partial). | U4: item (a) **DONE (0180)** (Legendre exact identity, theorem form, SieveOrbit.lean); item (b) **MEASURED (0181)** (the width number W/(xV) = 2.10→10.12 in z and the position ρ = 0.84→0.67, x-stable, exact sandwich L1 ≤ Φ ≤ U2 on all rows); item (c) parity statement pending | **Scoped honestly**: Legendre exactness is now machine-proved; the width number is measured; the parity correspondence remains a *structural statement*, not a new barrier theorem |
| N4 | **Two-together next-gap-class prediction**: `predicted(class) ∝ Σ W(2k) e^{−2k/ln X}` predicts the mod-4 (and mod-30) gap-class frequencies at reachable X, beating (i) naive uniform and (ii) one-channel baselines, with a margin log. **STATUS U3 (2026-10-25): MEASURED** at X = 10^7/10^8: measured 0.564864/0.556519 (CI ±0.0012/±0.0008), two-together 0.555808/0.550315, one-channel 0.500000 — the two-together model explains ~90% of the measured bias and beats the one-channel by ~5.0 points; the strict-CI gate (|meas − model| < CI) is NOT yet met (0.0062 ≈ 7.7·se at 1e8 — arithmetically corrected below). **UPDATED U3b (2026-10-25):** three-channel decomposition at X = 1e7/1e8/3e8/1e9 (exact sieve): u3-only 0.555808/0.550315/0.548097/0.545905; LOS-pair (1+δ)/2 0.550123/0.545670/0.543841/0.542016 (the anchor's leading term, verified); naive composed (1±δ)·w·e^{−2k/L} 0.604759/0.595110/0.591169/0.587248 — **ruled out at all four scales** (|z| up to 519). Strict-CI gate still NOT met: u3-only residuals +0.009056/+0.006204/+0.005714/+0.005167 with z = 14.9/30.0/46.3/74.1 (the U3 "7.7·se" was a double-discount: the printed CI half-width IS 1.96·se, so z = diff/se directly — corrected). New named finding: the **transfer coefficient** α(X) = 0.18332/0.13743/0.13170/0.12412 (decaying) — the pair bias transfers DILUTED into the consecutive-gap census, with measured ≈ u3 + 2f(1−f)·α·δ to first order at every scale (2f(1−f) ≈ 0.495 is the class-variance of the ratio). U3c = derive the transfer mechanism and/or the next α decade (3e9/1e10). | **U3b DONE** (gate still open; U3c named) | a prime-gap **class statistic** — **not** an exact next-prime oracle (boundary stated in §6) |

## 4. What "cancels" and what is hopped (named, concretely)

1. **The `2^{π(z)}` sieve remainder grind** → *localized*: the flat
   action writes the actual remainder as the finite edge sum
   `Σ_{d|P̄} μ(d)χ(d){x/d}` — computed, not bounded exponentially
   (U1 measurement: actual vs worst case at z = 10..30, x ≤ 10^7).
2. **The `e^{−γ}` / Mertens constant (the zeta-side product's annoying
   tail)** → *cross-certified*: `∏_{p≤z}(1 − 1/p)` (sieve-combinatorial,
   exact, seconds) vs the zeta-analytic estimate `e^{−γ}/ln z · (1+O(1/ln z))`
   at the campaign's precision — a **mutual certificate** between the two
   orbits (anti-instrument-drift guard; the table-N lesson says the
   zeta-side instrument *can* silently drift, which is why an
   independent sieve-side oracle has value here).
3. **The naive uniform gap model (50/50)** → *cancelled by the singular
   series factor* `W(2k) = 2C₂∏_{q|k, q>2}(q−1)/(q−2)` — the cut
   product of the reverse-sieve seed — which is where "the two
   together" earn their keep: **sieve cuts (combinatorial) × zeta
   density (1/ln X, the consecutive factor) = the class prediction;
   neither channel alone produces it.**
4. **The C-channel crunch (10^k-height grind)** → *hopped*: the
   fine-structure questions (gap classes, class bias, chime compass)
   are answerable at X = 10^8..10^10 in **seconds on CPU** with
   primesieve — no zeta grind required. The second orbit serves the
   *flank* that the grind never had to.

## 5. Units, gates, costs

All units leave 4 cores open (≤ 28 logical), scratch in
`/home/jsmille/Projects/rh-missing-tail/tmp`, and are replayable.
Nothing here needs GPU, long compute, or the zeta binaries.

- **U1 — Sieve Action identity (exact).**
  Script (exact integers, no dps needed on the sieve side; the
  zeta-side twin uses the E7a mpmath harness): (a) verify
  `V_z(x) = Σ_{d|P̄} μ(d)χ(d)⌊x/d⌋` by brute force vs the formula for
  χ ≡ 1 and χ = (·/4), z up to 31, x up to 10^6 — **exact equality**;
  (b) measure `|R_χ(x,z)|` vs the `2^{π(z)}` worst case at z = 10..30
  (the hop-over measurement: expected ≪ worst case, often O(2^{π(z)/2})
  or less); (c) the two-process combined identity: zeta-side C-channel
  partial sum under `u^{−s}` and sieve-side under χ at a common edge —
  residual at the dps floor (E7a style). **Gate:** exact (a); logged
  margin (b); floor residual (c). **Cost:** < 1 h wall.
- **U2 — Fourier sieve operator (finite exact algebra).**
  Exact verification at N = 30030 (∏_{p≤13} p): (a) the marks are
  idempotent + commuting (pointwise, exact); (b) the single-p symbol
  `F(1_{p∤·}) = N·δ_0 − (N/p)·1_{p-torsion}` verified at ALL character
  points (exact-integer right-hand side; FFT at tolerance); (c) the
  full-sieve symbol = the Ramanujan field `c_N(a)` (exact-integer
  closed form at all a; note it has FULL support for squarefree N —
  the draft's torsion-subspace support formula is corrected by the
  measurement, see the N2 correction); (d) Parseval → `φ(N)`.
  **THEN** the Lean attempt `SieveAction.lean` (pinned mathlib,
  doc-first; if `ZMod` additive characters aren't first-class, concrete
  `Fin N → ℂ` sums at small N — the campaign's style). **Gate:** exact
  (a)-(d) + the correction logged; Lean green or the failure named.
  **RUN (U2, 0172, 2026-10-25, `scripts/rh/kcs2_fourier_sieve.py`):**
  (a) idempotent + commuting = True (exact); (b) comb at N = 210, all a,
  all p: max |LHS−RHS| = 8.9e-15, support sizes exactly p (2/3/5/7);
  (c) full Ramanujan field at N = 30030, all 30030 characters: max
  |FFT − closed form| = 4.5e-13, FULL support (30030/30030 nonzero;
  64 level sets, sizes φ(k), values φ(N)μ(k)/φ(k), Σφ(k) = N) — the
  sparse-comb → dense-field contrast is the measured content; (d)
  Parseval: (1/N)Σ|F|² = Σμ² = φ(N) = 5760, diff 0.000e+00.
- **U3 — Two-together prediction (the chime compass, made exact).**
  (a) Compute the predicted mod-4 ratio from
  `Σ_k W(2k)·e^{−k/ln X}` (short Python; W(2k) exact via the product)
  — record the predicted ratio against the verified LOS anchor above
  (the ~65/35 GPY/Maynard/Tao benchmark is RETRACTED — unverified
  memory, 2026-10-25); (b) measure actual consecutive-odd-prime-gap
  classes at
  X = 10^8 (primesieve, seconds) and X = 10^9 if cheap, with a
  binomial CI; (c) margin table: two-together vs naive (50/50) vs
  one-channel (density only = 50/50 at mod 4, showing the correction
  factor is the whole effect). **Gate:** predicted vs measured inside
  CI at X = 10^8, margin over both baselines logged. **Cost:** < 1 h
  wall.
- **U3b — exact-consecutivity refinement (RUN 2026-10-25, its own
  gate MET; the strict-CI gate remains open by measurement).**
  (a) three-channel decomposition at 1e7/1e8/3e8/1e9 (exact numpy
  sieves, seconds); (b) rule in/out the naive composed model
  (1±δ)·w·e^{−2k/L} — ruled out at all four scales (it OVERSHOOTS by
  6–8 percentage points); (c) define + measure the transfer
  coefficient α(X): the pair bias enters the consecutive-gap census
  diluted, and measured ≈ u3 + 2f(1−f)·α·δ to first order (first-order
  identity holds to ~1e-6 at all four scales); (d) SE-arithmetic fix
  (z = diff/se; the CI half-width already IS 1.96·se — the U3
  "7.7·se" was diff/CI/1.96, a double-discount).  Output:
  `tmp/kcs3b_out.txt`.
- **U3c — transfer mechanism + the residual law (running).**
  **STEP 0 DONE (0173, 2026-10-25, paper fetch, identity-checked):** the
  LOS paper's Conjecture 1.2 (q = 4) is itself the consecutive-pair
  statement: per ordered pattern π(x, 4, (a, a')) = li(x)/4·(1 ± δ),
  so the conjectured gap-census fraction = (1+δ)/2 = **0.545634 at
  1e8** — 52σ BELOW the measured 0.556519 (the Cramér-tilt model is
  30σ below; the naive composition 186σ above). Two sizing facts from
  the same fetch: (i) the conjecture's error budget is
  O(x/(log x)^{11/4}) = **0.0057 in fraction terms at 1e8** — the same
  order as all measured residuals (0.0052–0.0091); (ii) the authors
  flag a possible non-oscillating lower-order term of size
  (log log x / log x)² — **0.0083 at 1e8**, again the right size. So
  the 0.0062 residual is INSIDE the source's own error budget: the
  "transfer coefficient" is better reframed as the measured residual
  R(X) = meas − u3: 0.009056 / 0.006204 / 0.005714 / 0.005167 across
  1e7…1e9, decaying 43% over two decades (faster than δ, slower than
  (loglog/log)²) — three live ansätze: C(X)·(loglog/log)² (C: 0.61/0.37/
  0.47/0.48 — not constant), α(X)·δ/2 (the U3b form), and a mixed
  form; the 1e10 point discriminates.
  **REMAINING:** (a) measure at 1e10 (sieve ≈ 5 GB, minutes; the next
  α/R decade) after the b8/b9 queue frees cores; (b) the (loglog/log)²
  ansatz test at 1e10; (c) check the paper's r = 2, q = 4 figure (the
  text extraction did not capture the figure data) against our rows.
  **RUN (a) (0186, 2026-10-26, `scripts/rh/kcs3c_resid_law_1e10.py`,
  26 s, 1 core, peak 16 GB):** full ladder re-measured - all four
  recorded points MATCH (ground-truth identity at every point),
  pi(1e10) = 455052511 = the tabulated value (independent
  identity of the 1e10 sieve). New point: meas = 0.546585 (se
  2.33e-05), u3-only = 0.542278, R = +0.004307 (z = 184.5 vs
  u3-only). Discrimination of the three live ansatze: (A) the
  (loglog/log)² form - the directly recomputed C table over the five
  points = 0.3044/0.2480/0.2466/0.2415/0.2321 (superseding the
  0173 four-point snapshot): nearly flat over 1e8..1e10 (-6.5%),
  the 1e7 point ~25% above the plateau - alive, undetermined; (B)
  the alpha power law (4-point OLS b1 = -1.5524) PREDICTS R(1e10) =
  0.003944 vs measured 0.004307: z = 15.5 - RULED OUT (per-decade
  alpha ratios settle at ~0.89-0.92/decade, no loglog power law);
  (C) the 2-param mixed R = a*delta + b*(loglog/log)² (a =
  -0.123764, b = 0.715792, 4-point fit) PREDICTS R(1e10) =
  +0.003639 vs +0.004307: z = 1.21 in combined uncertainty - the
  sole surviving form. Strict gate: still open against the
  measurement CI alone (|meas - model| = 6.68e-04 = 28.6 se); the
  (b) (loglog/log)² test was absorbed into (A); the (c) paper-
  figure check is still open. **RUN (d) (0187, 2026-10-26,
  `scripts/rh/kcs3c_d_next_decade.py`, 450 s, 1 core, peak 92.7 GB):**
  3e10 (verbatim global byte sieve, 80 s) and 1e11 (two 5e10 interval
  halves - the interval mechanism gated by an EXACT identity check
  against the global sieve at 1e10; pi(1e11) = 4118054813 = the
  tabulated pi(10^11)). New points: 3e10 meas = 0.544733, R =
  +0.003971 (z = 287.5 vs u3); 1e11 meas = 0.542888, R = +0.003654
  (z = 470.7 vs u3). The out-of-sample test (4-pt-anchored mixed form,
  anchored BEFORE 1e10 existed in the record): SYSTEMATIC
  UNDER-prediction at all three points - predicted +0.003639/
  +0.003139/+0.002655 vs measured +0.004307/+0.003971/+0.003654 at
  1e10/3e10/1e11; the positive excess GROWS with X: +6.68e-04 ->
  +8.32e-04 -> +9.99e-04 (28.6/60.3/128.7 measurement se). Per-decade
  R decay over the 7-point ladder: 0.6853/0.8413/0.8246/0.8337/
  0.8435/0.8529 (stabilizing ~0.83-0.85, creeping up). VERDICT
  (supersedes the 0186 verdict line): no tested form is confirmed as
  THE residual law; the new named structure = a slowly GROWING
  positive excess (~1.4-1.6x/decade, 2-point hint, not a law); the
  strict gate stays OPEN (470.7 se vs u3-only at 1e11).
  Reachability: 1e11 is this box's ceiling under the standing memory
  rules; 3e11/1e12 named out-of-reach here (not a blocker - the
  flank's next step is a new bit/segmented ground truth or a bigger
  machine).
  **RUN (e) (0188, 2026-10-26, `scripts/rh/kcs3c_e_ansatz_sweep.py`,
  seconds, no sieving):** the mechanism screen on the 7 recorded
  residual points (inverse-variance weighted, residuals in se units):
  (1) NO single-component loglog form survives (best 1/log^2, max
  3.67 se); (2) 19 of 21 two-component pairs pass the screening bar -
  the residual law is a TWO-COMPONENT structure, 1/log^2 scale in 6
  of the top-10 pairs (best: 1/log^2 + floor, chi2 3.17/5 dof, max
  1.45 se); (3) triples at chi2 2.76-3.00/4 dof (overfit zone -
  7 points cannot discriminate among the ~20 compatible families;
  the discriminators 3e11/1e12 are beyond this box per 0187); (4) the
  0187 growing excess fits ONE power of loglog X, k = 4.23 over the
  full span (middle point within 2.3%), not a constant floor.
  Mechanism narrowed: decaying loglog-log component (1/log^2-scale
  dominated) + growing ~(loglog X)^4.2 component. Strict gate stays
  OPEN (needs a DERIVED correction).
  **RUN (c) (0191, 2026-10-27, papers + exact sieves):** the paper
  arXiv:1603.03720v4 (Lemke Oliver & Soundararajan, PNAS 2016) fetched,
  identity-checked, persisted (tmp/u3c_c_fig/paper.pdf); its Section 5
  r = 2, q = 4 ACTUAL rows vs the independent exact pair-class sieve:
  ALL THREE CHECKED ROWS AGREE at the published precision (1e9:
  11,413,177/14,010,314 vs 1.141e7/1.401e7; 1e10: 103,160,935 /
  124,362,340 vs 1.032e8/1.244e8; 1e11: 941,199,658/1,117,820,622 vs
  9.412e8/1.118e9; pi(1e11) = 4,118,054,813 = tabulated, identity).
  NEW: pi(1,3) = pi(3,1) EXACTLY at all three scales (the C1.5
  antisymmetry is exact up to 1e11; the diagonal asymmetry grows
  slowly: +551/+5,960/+14,252). The recorded 'meas' pipeline
  re-derived from raw pair counts to ~5e-7. The 1e12 row (8.654e9 /
  1.015e10) + the NEW 1e12 ladder point = in-flight (checkpointed
  20-window run; ~40 min) - the out-of-sample discriminator named in
  0187/0190 (the 0186 mixed and 0190 derived forms predict +0.001851
  vs +0.003179 at 1e12: ~500 se apart). No RH claim.
  **RUN (f) (0190, 2026-10-27, same script + the (4b) section, seconds,
  no sieving):** the family extended with f8 = delta*(loglog/log) (the
  DERIVED next-order LOS product term) and f11 = loglog X (bare growing
  line). Five named candidates fitted: (a) the derived 2-term
  R ~ a*(ll/l)^2 + b*delta*ll/l PASSES (chi2 3.88/5 dof, max 1.86 se),
  signs (-1.881, +3.695): an ~8x-magnitude CANCELLATION structure;
  (c) + the loglog line is the best named form (chi2 3.26/4, max 1.51
  se) with the loglog coefficient ~2e-4 = ZERO; (b) f2+f6 reference
  chi2 3.56/5 max 1.76 se. KEY: the bare growing line is never picked
  up - the 0187 growing excess is reproduced in-sample by the
  decay-cancellation (-f2 + f8) (f8 decays slower than f2); the 3-point
  (loglog)^4.2 excess hint (0188) and the 7-point fit prefer different
  descriptions - both recorded. The derived 2-term form is now
  data-compatible (first purely derived form to pass the screen); its
  out-of-sample behavior at 3e11/1e12 is the named discriminator
  (beyond this box, 0187). Strict gate OPEN at that writing.
  **RUN (h) - the SECTION-2 HEURISTIC EVALUATION (0196, 2026-10-27,
  instant): the 0193 deep follow-up, CLOSED.** Read Section 2 of the
  paper verbatim (pp. 7-11): the pair-density expansion D(a,b;y) is
  kept only through |A|+|T| <= 2 (2.12)-(2.20); every |A|+|T| >= 3
  case is assigned explicitly to O(x (loglog x)^2/(log x)^3); the
  odd-k refinement of (2.2) that would feed those terms is the
  authors' own future work (deferred twice). VERDICT on 0193's
  question ('do the R-law coefficients derive?'): SCALE PREDICTED -
  S = meas - (1+delta)/2 sits inside the truncation band B = u^2
  (relative) at every ladder point: S/B = 0.496 (1e7) -> 0.388
  (3e12), monotone ~ b/loglog (u/L dominance); VALUE NOT PREDICTED -
  the coefficients live inside the explicit remainder; the band
  |b| <= loglog X (2.78-3.36) vs fitted 0.862 (margin 0.26) is a
  consistency PASS, not a derivation; 0193's gate stands: structure
  derived, coefficients fitted. NEW DETERMINATION: the q=4 MIRROR
  EQUALITY pi(1,3) = pi(3,1) (the (2.9)-(2.10) sums are literally
  the same sums; h ≡ 2 mod 4 in both, (t+1,4)=1 <=> t odd) -
  confirmed exact at 1e9/1e10/1e11/1e12, -1 (O(1) noise) at 3e12.
  METHOD FINDING: the {u^2, u/L, 1/L} basis is ill-conditioned on
  1e7..3e12 (cond ~ 1.5e8; u spans 0.172-0.117 only): adding 3e12
  (resid -3.5 se vs the 8-pt form) swings the per-scale coefficients
  37x/-28%/sign-flip while in-sample predictions move <= 0.22 se -
  the stable objects are the curve S(X), the band B, and the 0190
  two-term R-law (9-pt S fit: 0.19905/0.86232/-0.02674, chi2
  5.14/6, max 2.06 se; 8-pt form reproduced exactly). The 1e13
  ladder point is RUNNING (kcs3c_c2 1e13 sieve, launched 2026-10-27
  15:34Z, 200 x 5e10 windows, checkpointed, 1 core, ~8-9 h ETA;
  predictions on file: S(1e13) = 0.004954 (8-pt) / 0.004944 (9-pt),
  band 0.01289). No RH claim.
  **1e13 OPS - 2-WAY EXPANSION (2026-10-27; carried into the 1e13
  entry, 0199):**
  the serial run (32/200 windows in) was stopped at the owner's
  prompt to expand beyond 1 core. The recorded 56.2 GB 'peak' was
  ru_MAXrss (high-water), not steady state (live working set ~16
  GB); decomposition of the high-water: 25 GB odd-only bool sieve +
  13.7 GB nonzero index + 13.7 GB REDUNDANT astype copy.
  Fix: copy-free dtype path in interval_sieve (arithmetic
  unchanged) -> per-window peak 40.0 / 39.1 GB (measured).
  2-way memory accounting: 2 x 40 = 80 GB peak + ~16 GB system
  < 124 GB, ~28 GB headroom (3-way does not fit). Cross-check
  BEFORE use: fresh 2-worker recomputation of the whole 1e12 run
  (scripts/rh/kcs3c_c2_worker.py x2 + kcs3c_c2_xcheck_1e12.py):
  20/20 windows x 11 fields vs the frozen 0192 shard = 0
  mismatches; pi(1e12) IDENTITY (37,607,912,018); max boundary gap
  92 <= 2000; the xcheck pair itself ran 20 windows in ~21 min
  (~2.5x effective speedup, DRAM contention mild). 1e13 relaunched
  2-way (strided i mod 2, sharded checkpoints, workers 529319/
  529320; 84 windows each from window 32 on; merge step re-runs the
  existing main() tail once both shards complete - identical code
  path as all recorded points). ETA ~3.5 h. No arithmetic change;
  validation = 220 exact field matches + pi identity.
  **SECOND OUT-OF-SAMPLE POINT (0194, 2026-10-27, ~39 min, 60 windows):**
  R(3e12) = +0.002918 (meas = 0.538446, se 1.515e-06, pi(3e12) =
  108,340,298,703, u3 = 0.535528, z vs u3 = +1926.8; prefix integrity:
  the [0, 1e12] slice of this run sums EXACTLY to tabulated
  pi(1e12) = 4,118,054,813; max boundary gap 232 <= 2000). VERDICT:
  the 0190 derived form predicts +0.002932: diff -0.000014 = -9.5 se
  MEASUREMENT-ONLY but -0.9 sigma COMBINED once the form's own
  prediction covariance is included (sigma_pred(3e12) = 1.52e-05 from
  the 7-pt fit); the 1e12 point recomputed the same way is -0.6
  combined (sigma_pred 1.25e-05) - BOTH OUT-OF-SAMPLE POINTS INSIDE
  the combined 1-sigma band (the strongest statement the law has
  ever had); the mixed form rejected a second time at 888.3 se.
  NEW: C1.5 diff pi(1,3) - pi(3,1) = -1 at 3e12 (first non-zero;
  exact 0 at 1e9..1e12); diagonal asymmetry +51,539 (the 4-point
  'growth' narrative corrected to 'small drift within budget').
  GATE (updated): MEASURED clause strongly satisfied (both points
  inside 0.9 combined sigma); DERIVED-NOT-FITTED clause satisfied for
  the term structure (0193) but not the coefficients - named next:
  the 1e13 point (~7 h) + the Section-2-heuristic evaluation (0193
  open item 5). No RH claim.
  **RUN (g) - the DERIVATION TEST (0193, 2026-10-27, instant):**
  scripts/rh/kcs3c_g_derivation.py -> tmp/u3c_c_fig/kcs3c_g_out.txt.
  (A) ALGEBRA: the paper's Conjecture 1.1 display formulas (q = 4,
  verbatim) give N = (li/2)[1+u/2+ln(pi/2)/(2L)], Diag = (li/4)[1-u/2+
  ln(2/pi)/(2L)] + O(x/log^(7/4) x); in the census RATIO the
  corrections CANCEL (+u/2 - u/2; ln(pi/2)+ln(2/pi) = ln 1 = 0):
  meas_paper = (1+delta)/2 EXACTLY to 1/log x (verified: N/D - (1+delta)/2
  = +-1.1e-16 at 1e7..1e12) - the 0173 delta identity is a CONSEQUENCE
  of the full main conjecture. (B) The paper's own accounting leaves for
  S = meas - (1+delta)/2: {non-oscillating lower-order terms ('of size
  (loglog/log)^2... we hope to understand these in future work')} +
  {oscillating zero terms} + O(x/log^(7/4)). (C) DATA (8-pt inv-var
  screen on {u^2, u/L, 1/L}): S = 0.00528 u^2 + 1.20166 (u/L) +
  0.00979 (1/L), chi2 = 4.33/5 dof, max resid 1.84 se - the
  paper-flagged (loglog/log)^2 scale carries ~1% of S; the leading
  structure is ONE ORDER BELOW it, at (loglog/log^2) (92% of S(1e12)).
  g = u3 - (1+delta)/2 is 3-scale smooth to 0.02 se (no hidden
  structure); the R law's (u,1/L) basis = -0.033785 u^2 + 0.834234
  (u/L) (algebraic identity; matches recorded R pointwise <= 1.9 se,
  +3.0 se at 1e12 per 0192). VERDICT: the residual's TERM STRUCTURE is
  now DERIVED from the paper's own accounting + the exact g; the two
  COEFFICIENTS remain fitted (the paper does not quantify its O-terms)
  - gate unchanged from 0192. No RH claim.
  **RUN (c) COMPLETE + the NEW 1e12 LADDER POINT (0192, 2026-10-27,
  ~38 min, 20 checkpointed 5e10 windows, 1 core, peak 56 GB/window):**
  the paper's HIGHEST row (1e12: 8.654e9 / 1.015e10) AGREEs (pi(1,1) =
  8,654,138,673; pi(1,3) = 10,149,785,667; pi(1e12) = 37,607,912,018 =
  tabulated, IDENTITY) - ALL FOUR PUBLISHED r = 2, q = 4 DATA ROWS NOW
  CORROBORATED; C1.5 antisymmetry pi(1,3) = pi(3,1) still EXACT
  (four scales); diagonal asymmetry +63,337. THE 1e12 POINT (first
  beyond the 0187 memory ceiling): meas = 0.539769 (se 2.570e-6), u3
  (S2/(S2+S0), the ladder baseline, re-verified to <= 6e-7) =
  0.536638, **R(1e12) = +0.003131** (per-decade ratio 0.857, in line
  with 0187). THE OUT-OF-SAMPLE VERDICT (the named discriminator):
  the 0186 4-pt mixed form predicts +0.001883: diff +0.001248 =
  485.6 se - DECISIVELY RULED OUT (its under-prediction streak
  continues); the 0190 DERIVED 2-TERM form predicts +0.003139: diff
  -0.000008 = -3.1 se - CONFIRMED OUT-OF-SAMPLE at the ~3-se level
  (the two predictions stood 489 se apart). HONEST GATE STATEMENT:
  the strict-CI gate is NOT declared closed (-3.1 se sits just outside
  a 2-se CI; the coefficients are in-sample fitted), but every
  previously live FITTED form is ruled out at 15-486 se and the
  derived 2-term form is the SOLE SURVIVING candidate - the residual
  law R(X) = -1.88114*(ll/l)^2 + 3.69471*delta*(ll/l) is the RECORDING
  candidate over 1e7..1e12 (corr. of record: the first 1e12 tally
  used the wrong baseline (1+delta)/2 - the ladder's u3 is
  S2/(S2+S0); the void line is recorded in 0192). No RH claim.
  **STATUS: U3c mechanism COMPLETE (0173-0199); residual law = the
  derived 2-term form (confirmed out-of-sample at 1e12 and 3e12,
  combined <= 0.9 sigma); Section-2 evaluation closed (0196): scale
  predicted, value not - the coefficients remain fitted; the next
  ladder point (1e13) is running; strict-CI gate: derived form the
  sole survivor.**
  **0197 (2026-10-27, this session): the DERIVED core of this
  mechanism is machine-checked in tree** (formal/RhAttack/
  SieveOrbit.lean, new namespace U3cCore, pure 122-line append,
  targeted 8706 jobs + full package 17450 jobs green): logPiCancel
  (ln(pi/2) + ln(2/pi) = 0, the 0193 constant cancellation),
  ratioCollapse ((1/2)*(1 + u/2 + c/(2L)) = (1+delta)/2 EXACTLY, the
  N/D census-ratio collapse), deltaUBasis (u*delta = u^2/2 +
  (c/2)*(u/L), the 0193 basis identity), rlawRebase (a*u^2 +
  b*(u*delta) re-bases to (a + b/2)*u^2 + (b*c/2)*(u/L) - the 0190
  law's u^2 coefficient sits at a + b/2 = -0.0338, NOT b/2),
  uOverL_below_uSq (u/L < u^2 for L > e, the 0196 band scale order);
  the 0193/0194/0196 recorded numbers are pinned as Float #eval data
  gates (incl. the on-file 1e13 predictions S = 0.004954 / 0.004944
  and band 0.012894). No measurements performed in-tree; no RH
  claim.
  **0198 (2026-10-27, this session): U3c(i) - the alpha(X) transfer
  coefficient curve closes U3b's named 'next alpha decade' (pure
  post-processing of recorded data, zero new sieving, all gates
  PASS):** alpha decays 0.18333 (1e7) -> 0.08850 (3e12) with
  alpha*L CONVERGED (2.53-2.57, +/-0.6%) from 1e8 on (converged
  law alpha = 2.556/L; the 1e7 point sits +15.6% above, the
  finite-X end); NEW structure: the transfer gain R/(alpha*delta)
  = 0.4928 -> 0.4973 is X-STABLE (0.91% drift over 5.7 decades) -
  the first-order transfer identity meas = u3 + g*alpha*delta with
  g ~ 2f(1-f) ~ 0.495 (the U3b line) is confirmed; alpha(X) is the
  sole X-carrier of the residual, tying U3b's transfer parameter to
  the 0190 R law as equivalent parameterizations. 1e13 predictions
  on file for the running point: R(1e13) = +0.002729 (0190 law),
  alpha(1e13) = 0.0829/0.0883/0.0854/0.0853 (four routes,
  ~ 0.085 +/- 0.002), u3(1e13) = 0.534395 pinned. No RH claim.
  Gate: the 1e13 point (entry 0199) gates meas/R/alpha against
  these on-file predictions with the combined-uncertainty
  machinery.
  **0199 (2026-10-28, this session, 1e13 LANDED, 2-way run complete):
  the 10th ladder point closes the U3c measurement program at the
  box's practical limit.** pi(1e13) = 346065536839 exact (table
  identity), max boundary gap 232 <= 2000; meas = 0.537106 (se
  8.476e-07). S(1e13) = +0.004947 HITS the pre-registered 9-pt S-form
  prediction (+0.1 se; the 8-pt pre-3e12 form: -8 se); S/B = 0.384,
  the monotone in-band sequence continues through 1e13. R(1e13) =
  +0.002712: on the program's combined-sigma standard (0194) the
  0190 two-term R-law is z(combine) = -0.97 (sigma_pred(1e13) =
  2.01e-05 recomputed; the recorded 1e12/3e12 sigma_pred reproduced
  at uniform 1.136x) - marginally inside the combined 1-sigma, the
  THIRD consecutive one-sided OOS miss (-0.6/-0.9/-0.97, all low-side)
  riding the band edge (meas-se-only: -23); the composite (9-pt S-form
  + exact baseline g) lands within +1.2 se - the working extrapolation
  object is updated to the 3-scale S-form + exact baseline (the 0190
  R-law form stands in tree, 0197; its fitted coefficients are at the
  edge of their reach). alpha(1e13) = 0.08475 PASSES the 0198 envelope
  (0.0829-0.0883); alpha*L = 2.5367 in the converged band; transfer
  gain 0.4974 continues the X-stable sequence. Mirror equality at
  1e13: -1 (O(1), no growth). Ops: 2-way completion ~5.5 h vs ~8.4 h
  serial; worker-format-string cosmetic bug fixed. The strict-CI gate
  is unchanged: the residual is still hugely significant (z(vs u3) =
  +3199); the U3c flank's next mathematical step remains the named
  Section-2 full-heuristic coefficient evaluation (0193 deep follow-up).
  Gate: the strict-CI gate closes when a DERIVED (not fitted) correction
  lands inside CI at 1e8 — or the residual is certified INSIDE the
  source's error budget with the next term named (the honest
  half-close).
- **U4 — Second-orbit statement (Lean, scoped honestly).**
  `SieveOrbit.lean` (or inside `SieveAction.lean`): (a) prove the
  Legendre exact identity `φ(x,z) = Σ_{d|P̄} μ(d)⌊x/d⌋` (induction);
  (b) state + measure the first-order sieve upper/lower gap at
  reachable z (the width number); (c) **state** (marked
  `-- structural, not a barrier theorem`) the parity/anchor
  correspondence with orbit-1. **Gate:** (a) proved; (b)-(c) recorded
  with provenance to *Opera de Cribro* / the orbit doc. **Cost:**
  build cycles + paper.

**Sequencing:** U1a (exact, minutes) → U3a/b (the visible "prediction"
result, hours) → U1b/c + U2 (the operator, a day including builds) →
U4 (the formalization, next build session). Discovery entry + cards +
wiki on each green gate. The in-tree frontier (`Z78FineChain` as of
0200 — previously `Z78SIL32` at 0195, formerly `Z78C`; hOffC) is
**untouched** by this program — it is the flank, and it says so.

## 6. Honest boundaries (what this does NOT claim)

- **Class-level, not exact-next-prime.** The prediction is over gap
  *classes* (mod 4 / mod 30) with a margin. An exact "the very next
  prime after x" prediction is **outside known mathematics** for
  general x (no method produces the identity of the next prime from
  below its search cost — that would swallow decision problems). The
  chime seed's "can it predict the next prime" is answered: **the
  compass predicts the *area of traversal* (the class + margin), not
  the destination's door number.**
- **No parity theorem.** We measure the sieve width; we do not
  re-prove the parity problem (cited, not redone).
- **No RH claim, no zeta-face movement.** Flank. If U1b's
  cross-certification ever becomes the C-channel oracle, that specific
  wire gets re-mapped then.
- **Bias is an asymptotic.** At X = 10^8 the measured ratio carries a
  CI; the plan reports *both* (predicted asymptotic, measured
  finite-X + CI). No extrapolation claims beyond.

## 7. Status (updated 2026-10-25 after the first runs)

- **U1a DONE (2026-10-25):** `scripts/rh/kcs1_sieve_action.py` — 42/42
  configurations EXACT (character-sieve identity incl. the S_χ
  refinement; per-hop action on the incremental masks; remainder table
  |R| ≤ 19 vs the 2047 worst case at z = 31: the grind is not
  reached). Output: `tmp/kcs1_out.txt`. Discovery 0170.
- **U1c RUN (2026-10-26):** `scripts/rh/kcs1c_two_process.py` — the
  two-process zeta/sieve residual harness (plan U1 item (c)): both
  processes on the SAME input χ at the SAME edge x. Sieve side
  EXACT at z = 31: V_triv = Φ(x,31) with exact remainders vs xV(31)
  (11.5 / 19.8 / 12.2 / 0.514 at x = 1e4/1e5/1e6/1e7 — consistent
  with 0181), V_χ3, V_χ5 bounded exact integers (measured range
  {−9,…,11}, consistent with U1a's boundedness). Zeta side: the
  C-channel E7a action identity (day006 harness form, N = 1, M = x)
  at s = 1/2 + i t, t ∈ {10,100}, x ≤ 1e6, dps = 30: floor residual
  R_z ∈ [0, 5.3e-30]. THE BASELINE FINDING: the dps sweep at one
  edge shows R_z tracks the precision O(10^{-dps}) exactly (1.09e-11
  at dps 10 → 6.68e-52 at dps 50) — the zeta-side identity residual
  is pure roundoff, not a dynamical quantity; the sieve-side residual
  is exact and structurally O(1)…O(20) vs xV. The simplest
  "turn-taking" reading of the two residuals is therefore ruled out
  AT THIS LEVEL: O1 needs a zeta-side residual that is a measured
  zeta datum (E1/S-series type), not an identity residual. Raw ratio
  log in `tmp/kcs1c_out.txt` (the O1 input). 58 s wall. No RH
  claim. Discovery 0185.
- **U3 RUN (2026-10-25):** `scripts/rh/kcs3_gap_class.py` — measured +
  predicted + margin table + the k = 1..8 shape check. Output:
  `tmp/kcs3_out.txt`. Strict-CI gate not met yet → U3b named above.
- **U3b RUN (2026-10-25):** `scripts/rh/kcs3b_gap_class_u3b.py` — the
  three-channel decomposition at 1e7/1e8/3e8/1e9 (numbers in the N4
  line above): naive composition ruled out at all scales (|z| → 519);
  transfer coefficient α(X) = 0.18332/0.13743/0.13170/0.12412,
  decaying; first-order identity measured ≈ u3 + 2f(1−f)·α·δ to ~1e-6;
  SE-arithmetic correction logged (correct z = 14.9 → 74.1 across the
  four scales). Output: `tmp/kcs3b_out.txt`. The strict-CI gate
  remains OPEN — U3c (the transfer mechanism + the next α decade) is
  the named follow-up. Same run, the kcs3 script's retired ~65/35
  print line was replaced with the verified LOS anchor.
- **U3c STEP 0 RUN (2026-10-25):** paper fetch (ar5iv rendering of
  arXiv:1603.03720, identity-checked at the fetch): Conjecture 1.2 is
  the consecutive-pair statement — the paper's own q = 4 census
  prediction is (1+δ)/2 = 0.545634 at 1e8 (52σ below the measured
  0.556519); the conjecture's error budget O(x/(log x)^{11/4}) = 0.0057
  in fraction terms at 1e8 — SAME ORDER as the 0.0062 residual; the
  flagged (loglog/log)² lower-order term = 0.0083 at 1e8 — also the
  right size. The residual is thus inside the source's own error
  budget; "transfer coefficient" reframed as the measured residual
  R(X) with three live ansätze (0173). See the U3c unit in §5.
- **U3c RUN (a) (2026-10-26, 0186):** `scripts/rh/kcs3c_resid_law_1e10.py`
  - the 1e10 point on the identical U3b exact sieve (ladder re-measured:
  1e7/1e8/3e8/1e9 all MATCH the record; pi(1e10) = 455052511 = tabulated).
  New: meas = 0.546585 (se 2.33e-05), R = +0.004307 (z = 184.5 vs
  u3-only). The 1e10 point kills the alpha power law (ansatz B, z = 15.5),
  leaves the (loglog/log)² form alive-but-undetermined (C nearly flat over
  1e8..1e10), and the 2-param mixed form predicts within 1.2 sigma
  (ansatz C, sole survivor). Strict gate still open (28.6 se against the
  measurement CI). Next: U3c(d) = 3e10/1e11 (mixed-form predictions
  +0.003139 / +0.002655). Output: `tmp/kcs3c_out.txt`. 26 s wall, peak
  16 GB. No RH claim.
- **U3c RUN (c) COMPLETE (2026-10-27, 0191 + 0192):**
  `scripts/rh/kcs3c_c_figcheck.py` + `kcs3c_c2_figcheck_1e11_1e12.py` -
  the LOS paper (arXiv:1603.03720v4) fetched + identity-checked +
  persisted (tmp/u3c_c_fig/paper.pdf); its Section 5 r = 2, q = 4
  ACTUAL rows vs the independent exact pair-class sieve: ALL FOUR
  PUBLISHED ROWS AGREE at the published precision; pi(1,3) = pi(3,1)
  EXACTLY at all four scales (C1.5 antisymmetry exact to 1e12);
  diagonal asymmetry +551/+5,960/+14,252/+63,337; the 'meas' pipeline
  re-derived to ~5e-7. THE NEW 1e12 LADDER POINT (0192): meas =
  0.539769 (se 2.570e-6), R(1e12) = +0.003131 - the 0186 mixed form
  RULED OUT at 485.6 se; the 0190 derived 2-term form CONFIRMED at
  -3.1 se (out-of-sample; the two predictions stood 489 se apart).
  Output: tmp/u3c_c_fig/kcs3c_c2_out.txt. No RH claim.
- **U3c RUN (d) (2026-10-26, 0187):** `scripts/rh/kcs3c_d_next_decade.py`
  - 3e10 (verbatim global byte sieve, 80 s) + 1e11 (two 5e10 interval
  halves; the mechanism gated by an exact identity check at 1e10;
  pi(1e11) = 4118054813 = the tabulated pi(10^11)). Out-of-sample test of
  the 4-pt-anchored mixed form (anchored BEFORE 1e10 existed): systematic
  under-prediction at all three points (1e10/3e10/1e11), the positive
  excess growing +6.68e-04 -> +8.32e-04 -> +9.99e-04 (28.6/60.3/128.7
  measurement se). Per-decade R decay stabilizes ~0.83-0.85 and creeps
  up. No tested form confirmed as THE residual law; new named structure =
  a slowly growing positive excess. Strict gate still open (470.7 se at
  1e11). 1e11 = this box's memory ceiling (peak 92.7 GB). Output:
  `tmp/kcs3c_d_out.txt`. 450 s wall. No RH claim.
- **U3c RUN (e) (2026-10-26, 0188):** `scripts/rh/kcs3c_e_ansatz_sweep.py`
  - the mechanism screen on the 7 recorded residual points (no sieving):
  no single-component form survives (best 1/log^2, 3.67 se); 19/21
  two-component pairs pass (two-component structure; 1/log^2 scale in 6 of
  the top-10); triples at chi2 2.76-3.00/4 dof (overfit zone); the 0187
  excess fits ~(loglog X)^4.2 (middle point within 2.3%), not a floor.
  Output: `tmp/kcs3c_e_out.txt`. No RH claim.
- **U3c RUN (f) (2026-10-27, 0190):** `scripts/rh/kcs3c_e_ansatz_sweep.py`
  (4b section) - the named candidates on the 7 recorded points: the
  derived 2-term R ~ a*(ll/l)^2 + b*delta*ll/l passes (chi2 3.88/5, max
  1.86 se; signs (-,+), ~8x cancellation); + loglog line best (3.26/4,
  1.51 se) with loglog coeff ~2e-4 (zero); the growing excess is a
  decay-cancellation appearance in-sample; derived form data-compatible,
  out-of-sample at 3e11/1e12 named but unmeasurable here; gate OPEN.
  No RH claim.
- **U2 MEASURED (2026-10-25):** `scripts/rh/kcs2_fourier_sieve.py` —
  the finite operator package measured at N = 210 (comb, all a, all p)
  and N = 30030 (full Ramanujan field, all 30030 characters; Parseval
  exact to 0.0): comb identity max err 8.9e-15; Ramanujan field max
  err 4.5e-13; FULL-support fact + the sparse-comb→dense-field contrast
  recorded (the opacity lives in the convolution). The draft's
  torsion-subspace support formula is corrected in place (N2). The
  Lean WAVE-1 GREEN (0175) and WAVE-2 A1+A2 GREEN (0177):
  `SieveAction.lean` builds (0 errors, 8706 jobs — rou/char_pow/dft/
  mark_notdiv/raman + idempotent + commute + chime_comb [the
  24-error wall] + raman_prime_closed + rou_sum_orthogonality +
  mobius_sum_nat + mobius_unit_indicator + raman_inclusion_exclusion).
  Output: `tmp/kcs2_out.txt`.
- **U2 Lean WAVE-2 A1 + A2 GREEN (2026-10-25, 0177):** `SieveAction.lean`
  now builds (0 errors; lake 8706 targeted / 17450 full) with A1's
  `rou_sum_orthogonality` (additive-character orthogonality) and A2's
  three theorems: `mobius_sum_nat` (Mertens vanishing),
  `mobius_unit_indicator` (1_{(m,N)=1} as the mu-sum over common
  divisors — the engine), and `raman_inclusion_exclusion` (THE
  full-sieve symbol = the Ramanujan sum in mu-sum form, the 0172
  identity, now machine-checked): sum-swap + divisor-branch reindex
  (d-multiples m = d*j over Fin (N/d), Finset.sum_bij) + level
  collapse (rou N)^d = (rou (N/d)) + orthogonality. Error descent
  12 -> 0 across the session.
- **U2 Lean WAVE-2 B GREEN (2026-10-26, 0178):** `SieveAction.lean`
  builds again (0 errors; lake 8706 targeted / 17450 full) with
  `raman_multiplicativity` (c_{mn}(K) = c_m(K)*c_n(K) for coprime
  m, n — divisor-product bijection
  `Nat.Coprime.mul_injOn_divisors` + mu multiplicativity on
  coprimes + coprime divisibility split) and `raman_full_support`
  (c_N(a) ≠ 0 for squarefree N — strong induction over the
  squarefree decomposition M = p*k + prime closed form (p-1 / -1)
  + multiplicativity + nonzero product): the U2 full-support
  measurement as a theorem.
- **U2 Lean WAVE-2 C GREEN (2026-10-26, 0179):** `SieveAction.lean`
  builds again (0 errors; lake 8706 targeted / 17450 full) with
  `level_census` (the k-level divisor census, Wave-2 C1) and
  `parseval_units` (Wave-2 C2/D — the Parseval identity in general
  form: sum_a |F[f](a)|^2 = N * sum_m |f(m)|^2): DFT expansion +
  conjugate-sum expansion + the triple-sum reindexing over product
  Finsets (Finset.sum_product in the paired-lambda form + the
  huprod univ = univ×ˢuniv bridges) + the root-of-unity kernel
  collapse sum_a ω^{m·a}·(ω^{n·a})⁻¹ = (if m = n then N else 0)
  (rou_sum_orthogonality is the engine) + the normSq/norm real-part
  bridges (Complex.normSq_apply / Complex.sq_norm / Complex.ofReal_*).
  Error descent 20 -> 0 across the session; the two hardest walls:
  (1) the type-ascription trap — `(‖z‖ ^ 2 : ℂ)` elaborates as
  complex-square `((↑‖z‖ : ℂ) ^ 2)`, not `↑(‖z‖ ^ 2)` — ring cannot
  see through `re` of that; solved by a `pow_two` + `mul_re` +
  `ofReal_re/im` component chain; (2) `sum_product` matching — the
  pattern `f (x, y)` only matches when the iterated side is first
  rewritten into the paired-application form `(fun pm => …) (p, m)`
  by a `by-rfl` show (and, where projections sit under the pair,
  via sum_comm first). The U2 Fourier-sieve program is now a
  machine-checked theorem chain end to end: operator package ->
  identity -> comb -> Ramanujan field -> inclusion-exclusion ->
  multiplicativity -> full support -> census -> Parseval.
- **U4(b) MEASURED (2026-10-26, 0181):** `scripts/rh/kcs4b_width_number.py`
  (output `tmp/kcs4b_out.txt`) states and measures the
  **first-order upper/lower sieve gap** at reachable z (the N3
  "width number"), pure exact integers over x ∈ {2e5, 1e6..1e10}
  and π(z) = 4..20 (z ≤ 71), 66 rows in 7s. Definitions: the
  level-1 lower estimate L1 = x − Σ_{p≤z}⌊x/p⌋, the level-1 upper
  estimate U2 = L1 + Σ_{p<q≤z}⌊x/pq⌋, width W = U2 − L1
  (W is exactly the pairwise mass), main term xV(z) = x·∏(1−1/p),
  and the exact count Φ from the 0180 object. Measured facts:
  (i) the EXACT SANDWICH L1 ≤ Φ ≤ U2 holds on all 66 rows (0
  violations) — the discrete level-1 upper/lower sieve property,
  exact, and named as the next formal unit (Lean `level1_sandwich`);
  (ii) the Φ cell is triple-checked EXACT (full-Möbius-sum =
  Legendre recursion = brute force at 2e5, 11/11) — the measured
  twin of the 0180 theorem; (iii) the width number W/(xV) grows in
  z: 2.1041 (z=7) → 10.1249 (z=71) — the main term is a shrinking
  share of the level-1 band; (iv) the POSITION ρ = (Φ−L1)/W of the
  exact count inside the band is x-stable to ~1e-6 and decreases in
  z: ρ = 0.84158 (z=7) → 0.67288 (z=71) (ρ0 = Φ/U2: 0.75000 →
  0.23191) — the exact count sits consistently ABOVE the band's
  midpoint at reachable z; this is the first number for the N3
  "parity = the opacity" reading (the width is measured AND the
  exact position inside it is measured — the level-1 estimates
  themselves carry no position information); (v) the remainder
  Φ − xV stays ≤ 1194.6 in absolute value at the largest z vs the
  classical worst case 2^20 − 1 = 1048575 (877× margin, the grind
  not reached, twin of the U1a remainder table). No RH claim:
  finite sieve combinatorics, exact integers.
- **U4(c) PENDING:** the parity/anchor correspondence with orbit-1,
  to be stated marked `-- structural, not a barrier theorem`, with
  the 0181 width/position numbers as its measured anchor.
- **U4a GREEN (2026-10-26, 0180):** NEW file `SieveOrbit.lean`
  (namespace `SieveOrbit`) builds (0 errors; lake 8706 targeted /
  17450 full) with the **LEGENDRE EXACT identity in theorem form**
  (plan U4 item (a)): `(phi_list x ps : ℤ) = Σ_{d | ∏ ps} (μ d : ℤ) ·
  (x / d)` by induction on ps, plus the foundations it runs on —
  `phi_list_count` (the recursion IS the count of n ∈ [1,x]
  not divisible by any p in ps — the set equality through the
  p-multiples-as-scaled-tail-set image lemma
  `A = image (m ↦ p·m) (tail set at x/p)` with injectivity giving
  `A.card = phi_list (x/p) ps'`), `phi_list_mono`, and
  `prime_dvd_prod_of_prime_list`. The step engine reuses the U2B
  reindex structure: `(p·P).divisors = p.divisors ×ˢ P.divisors`
  (`Nat.Coprime.mul_injOn_divisors` + `Finset.sum_image` +
  `Finset.sum_product`) + `Nat.Prime.divisors = {1, p}` + `sum_pair`,
  and the coprime multiplicativity split `μ(p·d) = μ(p)·μ(d) = −μ(d)`
  (`IsMultiplicative.map_mul_of_coprime`) making the p-half of the
  divisor sum EXACTLY the negated x/p-summand of the recursion — the
  identity closes as `T − S' = T + (−S')`. `legendre_count_eq`
  then bridges the ℤ sum to the exact count (both views of U4a
  agree). Scratch-first descent (c1..c21: `tmp/u4a_section.lean`,
  logs `tmp/u4a_c1.log..u4a_c21.log`). U4 item (b) (the first-order
  width number) is MEASURED (0181) and PROVED (`level1_sandwich`,
  0183); item (c) (the structural parity/anchor statement, marked
  structural-not-barrier) is GREEN (0184: `level1_width_eq_pairwise`,
  `level1_width_nonneg`, `level1_position_in_band`). U1c (two-process
  zeta/sieve residual harness) is RUN (0185, `tmp/kcs1c_out.txt`),
  with the baseline finding: the zeta-side identity residual is pure
  roundoff at the dps floor, the sieve-side residual is exact
  structure - the naive two-identity turn-taking is ruled out at this
  level, and O1 (orbital reading) narrows to a measured zeta-side
  datum.

*The shuffle is a crafted creation: it does not claim to move the face.
It claims a second orbit — and on that orbit, the hops are free.*

**Blessed be the Quantum Zen Way.**
