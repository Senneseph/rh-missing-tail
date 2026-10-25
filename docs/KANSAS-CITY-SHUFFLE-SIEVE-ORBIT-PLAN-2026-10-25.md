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
| N2 | **Fourier sieve operator theorem (finite, exact)**: on `Z/NZ`, N = P̄(z) squarefree, the mark operator `K_p` (multiply by `1_{p∤·}`) lives in the group algebra (commutative); in the DFT basis `K̂_p` is the **averaging operator over the p-torsion subgroup of the character group** (idempotent, commuting projections); hence `DFT(1_{(·,P̄)=1}) = (1/P̄)·1_{Ĝ[P̄-torsion]}`, and `φ(P̄)` falls out of Parseval. Each chime = the p-torsion comb (the per-prime tone); the full sieve = the joint torsion projection. | to verify (U2) | finite exact algebra; the *package as one theorem with the chime correspondence* is new here |
| N3 | **Sieve orbit width = the parity gap**, stated as the orbit-2 analogue of `surjWidth`: local reading (per-hop survivors) vs global (final structure); width = measured first-order upper/lower sieve gap; parity = the opacity; anchor = the zeta/L-side (partial). | to verify (U4) | **Scoped honestly**: Legendre exactness is proved; the parity correspondence is a *structural statement*, not a new barrier theorem |
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
  Exact verification at N = 30030 (∏_{p≤13} p) and N ≤ 10^7, z ≤ 9:
  (a) `K̂_p` = p-torsion averaging (idempotent, commutes with all
  `K̂_q`); (b) `DFT(1_{units}) = (1/P̄)·1_{P̄-torsion}` — verify the
  *entire* spectrum (exact Q/integer where possible; FFT + tolerance
  otherwise, with the exact-Q cross-check at N = 30030); (c) Parseval →
  `φ(P̄) = ∏(p−1)`. **Then** the Lean attempt `SieveAction.lean`
  (pinned mathlib, doc-first; if `ZMod` additive characters aren't
  first-class, concrete `Fin N → ℂ` sums at small N — the campaign's
  style). **Gate:** exact (a)-(c); Lean green or the failure named.
  **Cost:** < 2 h wall + build cycles.
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
- **U3c — transfer mechanism + the α decay (next unit).**
  (a) derive α from the per-class conditional normalization / the
  "no prime in between" reweighting (the (1±δ) factor acts on pair
  COUNTS; the consecutive-gap census conditions on both the pair and
  the empty interval — the transfer is what that conditioning does to
  the factor); (b) measure α at 3e9/1e10 (sieve seconds; memory ≤
  2.5 GB) to resolve the decay law (measured α: 0.183 → 0.137 →
  0.132 → 0.124 across 1e7 → 1e9, ~7% per ×3, not yet identified with
  a clean function).  Gate: the strict-CI gate closes when a DERIVED
  (not fitted) α-variant lands inside CI at 1e8.
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
- **U2 / U1b / U1c / U4:** as scoped in §5, next build sessions.

*The shuffle is a crafted creation: it does not claim to move the face.
It claims a second orbit — and on that orbit, the hops are free.*

**Blessed be the Quantum Zen Way.**
