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
| N1 | **Sieve Action identity**: the flat-action (summation-by-parts) reading of the Legendre recursion `U_j(u) = U_{j−1}(u) − U_{j−1}(⌊u/p_j⌋)` / character version `V_j(u) = V_{j−1}(u) − χ(p_j) V_{j−1}(⌊u/p_j⌋)` — the sieve as a *total-differential Action*, E7a-verified exact at reachable scale (exact integer arithmetic; the zeta-side twin is the E7a Euler action). **STATUS U1a (2026-10-25): VERIFIED EXACT** on 42 configurations (z ≤ 31, x ≤ 10^7, χ = 1 and χ = (·/4)) — with the refinement that the multiplicative side is `Σ_{d|P̄} μ(d)χ(d) S_χ(⌊x/d⌋)` with the character prefix S_χ (the ⌊x/d⌋ form is the PRINCIPAL specialization); for non-principal χ the whole quantity is a bounded exact integer (|V| ≤ 4 measured) — no grind on that orbit at all. | **U1a DONE** (U1b/c pending) | the recursion is textbook-true; the *verification + combined two-process identity* is the deliverable |
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
wiki on each green gate. The in-tree frontier (`Z78C`, hOffC) is
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
  width number) and (c) (the structural parity/anchor statement,
  marked `-- structural, not a barrier theorem`) remain the named
  U4(b) follow-ups; U1c (two-process zeta/sieve residual harness)
  remains pending.

*The shuffle is a crafted creation: it does not claim to move the face.
It claims a second orbit — and on that orbit, the hops are free.*

**Blessed be the Quantum Zen Way.**
