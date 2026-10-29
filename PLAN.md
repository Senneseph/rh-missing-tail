# PLAN — postulates, status, falsifiers

The program is organized as labeled postulates. Status vocabulary:
**EXACT** (identity, any precision), **MEASURED(p)** (to precision p,
dual-stack), **CONJECTURE** (pattern over k samples), **INTERPRETATION**
(re-reading, carries no weight). Each postulate names its next
falsifier.

## P-E — the Euler action identity — EXACT (verified 2026-09-09)

The 1D summation-by-parts identity (README §Abstract) is a flat
(total-differential) action: every path stationary. Consequences:
- series-side universality (D = −P, the ladder) is by construction;
- **P-Z is the exact/remainder decomposition of this action**: exact
  part = cell data (computed at every order); remainder = zero
  content of the path (unique, enters at the measured onset).

- E7a (finite form, generic paths): **PASS** (dps-50, 5/5).
- E2-exact (infinite form, 18/18 phases, 1e-10, zero fits): **PASS**.
- E7b (the zero-side identification): **Stage 1 complete (2026-09-09)** —
  the onset is predicted from the Riemann zero product (25.2.12 kernel,
  full canonical factor (1−s/ρ)e^{s/ρ} over the certified 466,655-zero
  list + analytic density tail). The 4-digit onset points are
  reproduced: N=10³, t/N=1 → +0.29%; N=10⁴, t/N=0.1 → −1.2% (two
  borderline +4/+6%); the remaining points sit below the quantified
  zero-side error floor (the density tail saturates once G ≫ t), and
  the N=10⁵ row needs G ≳ 5–6×10⁶ (deferred, on demand). PASS here =
  the zero side of the recognition map is the measured onset; FAIL
  would find non-explicit-formula content.
- **E7b detector (off-line pair kernel deviation): EXACT formula +
  MEASURED(6 digits) (2026-09-10)** — R = P_off4/P_on2 = (¼+γ²)
  ((γ−t)²+δ²)((γ+t)²+δ²)e^{(½+it)ω_δ} / ((γ²−t²)((½+δ)²+γ²)
  ((½−δ)²+γ²)) (4-line algebra; only branch = on-line (γ²−t²) sign
  flip; δ > 0 has no zero window). Consequences: near |R−1| → 1; far
  |R| = (t/γ)²(1+O(δ²/γ²+1/γ²+(γ/t)²)); off-line 4-tuple
  argumentically invisible (measured −π on-line vs 0.000 off-line)
  ⇒ 2K +2 size step, parity preserved. Verified dps-30 (3 levels,
  worst 5×10⁻⁴ = last printed digit). See
  `results/e7b1-detector-b5-core.md` + `scripts/rh/out_day010_*.txt`.

## P-W — the Width Postulate — MEASURED at q = 5, 13 (1e-10) and q = 17 (1e-9)

`tail = −P(r)N^{−s} + s·M₁(r)N^{−s−1} + s(s+1)·M₂N^{−s−2} + …` with
the M_k cell-moment (Lebesgue-width) functions of (r, χ, q) only.
Verified exact tables: see `results/width-ladder-tables.md` (the
q = 5 fifth-multiples; the q = 13 all-integer table; mirror symmetry;
zero-sum trace; t-independence).
- Falsifier: q = 17 (all 17 phases, exact form) — **PASSED** (all integers
  to 1e-9, mirror exact, trace 0, D = −P 17/17; see tables §8).
- Falsifier: F₂₄ (non-multiplicative period-24 cell from the Fibonacci
  ladder; cell sum 108, mean 9/2 code-verified) — **MEASURED** (raw front/
  back = mod-4 identical + mod-3 slide; M₁ halves near-identity to ~99%;
  tables §10). Extension beyond odd-prime quadratic cells is thus
  measured on both an even-multiplicative and a non-multiplicative cell.

## P-G — the Half Postulate — MEASURED (6 homes), INTERPRETATION (unity)

½ appears as: (1) the critical line σ = ½; (2) the √N price
(N^{1−σ} at σ = ½); (3) the half-term M₁(ζ) = −½ (the width object in
the smooth slot — measured); (4) (−½)! = √π (gamma self-pairing,
owner census); (5) the power-tower half-attractor at x = 1/4 (W-equal,
owner census); (6) the (p±1)/2 bookkeeping of odd-prime characters.
The unity claim — one object, the boundary cell (the square
[−½,½]², whose edge weight is ½) — is interpretation, labeled as
such.

## P-Z — the Separation Postulate — MEASURED (onset 4 digits), EXACT (decomposition)

Series side exactly computable from period data at every order (the
flat action); zero side the unique remainder, entering first at
½·t = N (measured C/|I| = ½·(t/N)); counting corollary: 2K = −2 ⇒ no
off-line pair below the certified bound (10⁶ at v0). The zero-side
identification (is the onset C the explicit-formula zero kernel, with
the Riemann-1859 coefficients?) is E7b — the next experiment.

## P-A — Action and Rolling (analogy layer, discipline-enforced)

"Action" only for a written functional; "rolling" only for an explicit
phase trace. What carries (labeled): the onset as the least-action
frontier (optimal truncation is classical, Berry-1995/Trudgian-2011 —
the measured crossing is the boundary of that region); c_r(N) as the
decaying rotating spiral (measured); the tautochrone as the
phase-universal 1/N exponent (measured −1.0005); the rolling trace
Σ_r M₁ = 0 (measured at q = 5, 13; F₂₄ = E6 test). The primes do not
move; the action is on the approximation.

## P-0 — Discipline

Computed-not-recalled (every recall incident logged and corrected,
e.g. the F₂₄ hand count 118 → code 108, mean 9/2); twin-floor + dt/2
is the count certificate (2K is parity only); two engines must agree
(float64 dual stack + dps oracle); per-evaluation cost measured
before scaling; labels on every claim (measured/exact/conjecture/
interpretation); phases checked (N ≡ r mod q) before arithmetic; no
3-power-term fits (the 3-term trap returned 7/5 where the truth is
2/5 while its residual was 1e-9 — convergence, not fitting).

## Staged proof scaffold (planning artifact, NOT a result)

`docs/RH-PROOF-OUTLINE.md` (v0.5) + `docs/RH-OUTLINE.md` (v0.1) are
mirrors of the proof scaffold in the working repo (kainos-logos @
head 4633916, synced 2026-09-10). They are plans, not results: every
item is labeled MEASURED / CLASSICAL / INFERENCE / TO-BUILD, every
number must trace to this repo's certified ledger (see
`results/certified-zero-survey.md`), and the documents make no claim.
Mirrors update only by explicit copy from the source repo — never
edited locally. Filled so far: B-4 (per-pair closed form) and the B-5
core (the E7b detector, `results/e7b1-detector-b5-core.md`); the
remaining blanks are named with their exact data triggers (D1–D5).

**Machine-checked core (home and source of record).** `formal/` (provenance
and the no-local-edits rule in `formal/RH-LEAN-PROVENANCE.md`): theorem
`eulerAction` — the E7a identity — proven in Lean 4.34 + Mathlib over
any commutative ring, with the five oracle instances cross-checked
two ways (exact-ℤ `#eval` layer + independent Lean float64 pipeline,
worst deviation 2×10⁻¹⁴ vs the dps-20 Python oracle); and the B-4
on-line pair identity in four pieces — `pairClosedForm` (T1, exact,
no exclusion), `pairLogAbs` (T2), `pairArgAngle`/`pairArLedger`
(T3a/T3b, the phase exactly mod 2π) — cross-checked on the 16
recorded points (16/16, worst ~10⁻¹⁴ inside Lean float64). Recorded
run: `formal/out_rhattack_day011.txt`. Status: the finite
core **and the per-pair zero-side factor** are machine-checked; this
changes no status line in this plan's postulates (P-E's EXACT label
is reinforced, not replaced).

**Added (2026-10-25, the orbit line):** `formal/RhAttack/Orbit.lean`
proven in-tree (leanprover/lean4 v4.33.1, mathlib prebuilt; build
8706 jobs green, zero linter warnings): the *orbit* — the
local-observable to global-invariant extraction the campaign has been
running all along. Objects: `Drift n = Fin n -> R`, `LocallyInvisible
n δ eps` (each step invisible under eps), `TotalDrift`,
`irreducibleWidth = n*eps`, `anchorWidth = 2*sigma`. Theorems:
`totalBound` (|total| < n*eps — the width), `surjPoint` + `surjWidth`
(achievable totals = exactly `Ioo -(n*eps) (n*eps)` — the width is
SHARP, not just bounded), `anchorCollapsesWidth` (sigma < n*eps => the
anchored reading's width 2*sigma is strictly smaller — the closing
operator: one global measurement against an external reference
collapses the width). Campaign instantiation: 11 unanchored steps,
96% step-correct vs 61% trajectory goal-match, width 35 points;
post-anchor 89% / 7 points; consistency gained 28 points with zero
extra steps. `docs/ORBIT-FORMALIZATION.md` records the formula, the
uncertainty form (unobservability product `eps x horizon`, not
Fourier dx*dx' verbatim), and the correspondence with the
argument-principle anchor (Ap1/Ap3) and the no-RH-drift ledger.
Commit a00c7d6.

## Living documents

- `ORBITAL-TWO-BODY-SIDE-QUEST-2026-10-26.md` (docs/) — OFF-BOARD
  side-quest tracking file: the two representations read as a bound
  two-body / orbital system (center-of-mass = main term, relative
  coordinate = the residual, the explicit formula = the shared
  action, level alternation vs zero-oscillation = the turn-taking
  rhythm). Proven/measured/heuristic/unmapped rows separated; no RH
  claim; borrows the mainstream units (O1=U1c, O3=level1_sandwich),
  adds O2 (finite explicit-formula identity, pending provenance
  fetch) and O4 (band phase diagram, measured). Does not gate the
  critical path.
- `DISCOVERY_LOG.md` — the chronicle: approach + the pieces as found
  (in order) + how they combine; important contradictions recorded;
  no setbacks; appended as evidence files land.
- `PUBLICUM.md` — the public digest (science-magazine/news readership):
  plain words, no fancy mathematics, measured vs open stated,
  credit + AI disclosure.

## Stage map (what v0 does NOT contain) — cross-ref README §program

1. **10⁷ certification** (DONE, day-023 25b): N(10⁷) = 21,136,121
   (= LMFDB 31-digit 21,136,125 − 4 documented twins), S(10⁷) =
   −3.205718 (dps-45), 2K(10⁷) even; independent 100-h walk, 0
   failures, dt/dt2 agree on every segment.
2. **E7b** — the zero-side identification (Stage 1 PASS on the
   certified 466,655-zero list, 2026-09-09; the N=10⁵ row awaits the
   G ≳ 5–6×10⁶ walk, on demand).
3. **E4/E6 — F₂₄** rolling invariants (the front/back M₁ measurement is
   done — tables §10; the rolling-invariant form is open) and the
   **t-dependence of the drift** (does it respect the 4-tuple /
   quadrant-orbit decomposition? E7c).
4. **E5** — write the explicit zero-sum in missing-tail language and
   identify it with the measured onset (the zero-side bridge; the
   step after E7b).
5. **The honest limit**: no finite walk proves the RH. What this
   repository can deliver: a counterexample if one is in the walked
   range; certified exclusion bounds at each height; and — if E5/E7b
   pass — a structural reduction (RH ⟺ no off-line pair ∀t ⟺
   S = o(log t), classical) with the zero side pinned to the
   explicit-formula kernel. That last is the resolution-shaped end
   of the road; it is not claimed.

   — stage-map sync 2026-10-25 (the map was stale since the day-023
   era; the S20/S21 data line, the orbit line, and the second-orbit
   program are the working frontier now): —

6. **S20a/S21 data frontier (DONE through 0169, 2026-10-25):** the
   C/quad channel is validated through 9e23: the S21a chain-table N
   wall was an INSTRUMENT bug (hand-scaled N missed the exact
   floor(a) by 3; p left the rssum (-1,1] domain; generator repaired,
   selftest 1e-29). Rows: 3e21/9e21 full-primary (0167; re-issued with
   same-N fixed-table bare crosses d = 3.2788e-6 / 2.3222e-6 vs the
   instrument's ~2.5e-5 self-declared standard — 0169); 3e23/9e23
   full-primary (logzeta -0.978704934699 / +0.569323908351; same-N
   bare crosses CLOSED 0174: d = 1.681e-6 / 1.250e-6 - cross lineage
   3.279e-6 -> 2.322e-6 -> 1.681e-6 -> 1.250e-6). The 3-term-law M
   relative residual collapses
   monotonically: 2.247e-8 -> 7.473e-9 -> 3.812e-9 -> 7.199e-10.
   **MEASURED boundary:** the exact-integer M era (0158) closed at
   9e21 — past 2^53 the M partial sum is an f64 ulp multiple (2 / 16);
   the quantization record (0.000e+00, all ten rows 1e18..9e21) stands
   as the record. In-tree: E1ClauseV3C window (G, 9e23] (0176:
   T_MEAS3 = 9e23, hole B = 1e8, 40-row face, max residual
   6.333622e7 at 9e23 -> 37% margin, full tree 17450 jobs). No RH claim.
7. **The terminal face (NAMED, adopted forward at 0203):** the
   in-tree closure of the `hOffC` face is now wired at
   `[Z78DensityRefined]` (0.8739461 = 8739461/10000000; tracker record
   density-refined, PR #90, SovereignSteak, AI-assisted (OpenAI Codex),
   merged 2026-10-28 19:48Z). Evening board sweep 2026-10-28 (37
   records + 1 historical): two new merged records since the 0200
   snapshot - PR #85 density-split-fourth 0.873981 (Rohan Arun)
   strictly WEAK than [Z78FineChain], subsumed, not adopted; and PR
   #90 density-refined 0.8739461 - the current BOARD BEST - replayed
   and adopted as 0203 (stage C 119/119 clean on the frozen
   0148/0195/0200 olean reuse after six-way byte-identity of all
   dependency trees, stage D: canonical compile at 8739461/10000000,
   axiom audit {propext, Classical.choice, Quot.sound}, zero sorry).
   In tree: `formal/RhAttack/Z78DensityRefined.lean` (named external
   input; strict strengthening chain through [Z78FineChain] to
   [Z78]) + RHEnd part B19 (5 theorems; B19.1 closes the slice
   (0.3739461, 0.3739558] in body from [Z78DensityRefined]; targeted
   builds Z78DensityRefined 8729 / RHEnd 8751 / full tree 17450 all
   green; B16/B17/B18 preserved - pure append). 0211 (2026-10-29)
   SUPERSEDED AGAIN - B6 SEVENTH: PR #94 arvi-density (ArviFoxy,
   merged 07:51Z) at 43693617/50000000 = 0.87387234 - the new board
   best (the 0210 re-sweep caught its open-PR state on the
   bigospeedrun board; it merged before the 0211 catalogue pull
   as_of 2026-10-29, 41 records, along with the subsumed new
   records PR #91/92/93). Full second-party replay (tmp/z78s35):
   stage C 328/328 clean in 326s (all five dependency trees
   byte-identical to the frozen 0203 copies), stage D: kernel-
   accepted at the exact rational, axioms {propext,
   Classical.choice, Quot.sound}, zeta consequence, 0 sorry.
   In tree: `formal/RhAttack/Z78ArviDensity.lean` (named external
   input; strict strengthening chain through [Z78DensityRefined]
   to [Z78]) + RHEnd part B21 (5 theorems; B21.1 closes the slice
   (0.37387234, 0.3739461] in body from [Z78ArviDensity]; builds
   Z78ArviDensity 8730 / RHEnd 8761 / full tree 17454 all green;
   B19/B20 preserved - pure append). The face is now
   `hOffC : d0 <= 37387234/100000000` above H (0.37387234
   off-line; this step removed denRefinedD0max - arviD0max =
   7376/100000000 = 7.376e-5 of face width - the LARGEST single
   in-tree face shrink of the B-part series). History: 0203 wired
   [Z78DensityRefined] (0.8739461, step 9.7e-6); 0200 wired
   [Z78FineChain] (0.8739558, face d0 <= 1869779/5000000, step
   3.92e-5); 0195 wired [Z78SIL32] (0.873995), formerly [Z78C]
   (0.8747729897 at 0162). The
   face remains NAMED, not closed; the data edge is a FLANK and never
   closes it; a future board-best record is the next adoption trigger
   (the board moved THREE times in 24h - the B6 sixth-supersession
   mechanism is now the standard response). 0210 appends RHEnd Part
   B20 (append-only, after B19.5): the A1 assembly face is
   RESTATED AS IN-TREE (0209) - the W2Beyond3 A1 clause is grid-
   restricted and closed data-free at the frontier - and the
   endpoint's external input surface is NAMED in the record (new
   reference theorem a1GridClauseNamed; the surface = the two
   standing CITED theorems + e < 4). Live board re-sweep (37/37,
   as_of 2026-10-28, theta stored as STRING fractions - int()
   them): density-side board best is still the in-tree face
   0.8739461 (lower theta = better, i.e. MIN wins) - NO B6 fire.
   Builds RHEnd 8760 / full tree 17454 green.
8. **The A1 walk-side data layer (0201 + 0202, 2026-10-28):** the
   single open W2Beyond input - the data-free |DN| <= K clause (S
   bounded at the zeros, E1) - now carries its DATA side as a named,
   machine-checked record covering [14, 3e10] END-TO-END:
   `formal/RhAttack/W2Beyond4.lean` (targeted + full-tree builds
   green) pins the measured K instances per domain, the RUNNING-MAX
   growth theorem (the sup of the RVM count-defect at the zeros,
   sup_[14,T], is strictly increasing at every coarse decade: 2.1101
   -> 2.1887 -> 2.2969 -> 2.3773 -> 2.4387 -> 2.5030 -> 2.5539 ->
   2.6151; span < 1; drift ~0.15/decade - o(log) and non-constant)
   plus the WIGGLE theorem (the data denies per-bin monotonicity:
   sup (1e7,2e7] 2.1756 > sup (2e7,3e7] 2.1492 - the envelope grows,
   the bins fluctuate at O(0.03-0.05)), and the universal wire
   INSTANCED at K = 2.62 on the certified (2.999e9, 3e10] domain
   (wire cost <= 2.62 * 17/8 = 2227/400 = 5.5675). The census behind
   it (DATA LEDGER section 8): ~101.6 billion zeros (band
   counts; the certified endpoint N(3e10) = 101,635,962,231 is
   authoritative) - LOW (LMFDB
   exact), the GAP band (1e7, 3.1946e7] censused 0202 from the
   LMFDB/Platt shards on disk (N(3.1946e7) = 73,426,758 TRIPLY
   confirmed: shard stream, 0201 chained anchor, 2026-09-14
   manifest; overlap to two ULP over 2.6M zeros vs the independent
   LMFDB pull), A/B/C local, D the 740GB band (re-derives the
   certified A2 record EXACTLY, all five pins OK).  Positive-side
   dominance (sup+ 2.615 vs min -1.392); shape quantified on 92.6B
   zeros.  The DATA-FREE version (K uniform in the frontier) remains
   the single named open theorem - now with its shape quantified: a
   non-constant o(log) increasing ENVELOPE with O(0.03-0.05) bin-
   scale fluctuations.  0204/0205/0206 deepened the data side:
   the RVM
   +7/8 vs +3/4 shift is now pinned EXACTLY in-tree (`W2SAtZeros`:
   S = DN - 1/8 + O(1/T), so the census is exactly S(gamma) at the
   zeros), giving the first in-tree |S| <= 2.490066528 on the
   certified 3e10 domain, and the shape of the S-ladder pinned
   in-tree, ALL THREE premise-free after 0206 (`sLadderRising`,
   `sLadderConcaveInT`, and `sLadderSublnDrift` - the last now with
   its eleven numeric brackets proved in-tree in `TransNums`;
   S/ln T drift -16.19%) - on the measured domain the data already
   contradicts O(1)-at-the-zeros, in-tree.  0207 made the data-free
   frontier constants premise-free (`A1Growth.pin_explicit_3e10_free`
   / `pin_explicit_wire_3e10_free`:  K < 8 and |S1 - R| < 17 machine-
   verified end to end via three new `TransNums` frontier log pins,
   the single cited input left being the Trudgian bound A1G-5 itself)
   and QUANTIFIED the A1 terminal face in-tree:  any absolute K on the
   measured 3e10 domain lies in [2.490066528, 6.0162)  (0208 sharp:
   G_explicit 3e10 < 30081/5000,  within 0.013 of the sharp value 6.0032;
   wire constant < 15),  and `face_unbounded` proves the gap is the
   CONSTANTNESS of the growth function G  (the absolute clause is the
   growth wire at constant G),  not a numeric.  0209 then re-read the
   assembly's own signature  (W2Beyond3.a1_universal_wire):  the A1
   clause is GRID-RESTRICTED  (one uniform K for the finite zero
   grid)  -  and  THAT  clause  is  now  CLOSED  DATA-FREE  at  the
   certified  3e10  frontier  (A1Growth  section  9:  the
   zero-free  bridge  dn_defect_to_sbridge  +  the  uniform
   K  =  33206/5000  =  6.6412  exhibit  +  the  full  frontier  wire
   |S1Sum  -  RSum|  <  16),  with  the  lane's  external  input
   surface  reduced  to  two  peer-reviewed  theorems  (Trudgian
   2012;  the  RvM  identity  with  explicit  residual)  +  e  <  4.
   The  STRONGER  absolute  clause  (all  zeros)  remains  NAMED/
   OPEN  per  0207;  it  is  not  what  the  assembly  consumes.
   No RH claim.
9. **The second orbit (KANSAS CITY SHUFFLE, IN PROGRESS):**
   `docs/KANSAS-CITY-SHUFFLE-SIEVE-ORBIT-PLAN-2026-10-25.md` — the
   owner's crafted creation: a Fourier-compatible Sieve of
   Eratosthenes as an Action series, paired with the zeta side on
   their shared Euler factor (1 - chi(p) p^-s). **U1a DONE (0170,
   EXACT, 42/42):** the character-sieve identity `V_z(x) = sum_d
   mu(d) chi(d) S_chi(x//d)` + the per-hop edge-flux action, verified
   over integers, z <= 31, x <= 10^7; the principal remainder
   |R| <= 19 vs the worst case 2^11 - 1 = 2047 (the grind not
   reached); the non-principal orbit is O(1) (|V| <= 4). **U3
   MEASURED (0170):** the mod-4 gap-class bias (the Lemke
   Oliver-Soundararajan statistic, arXiv:1603.03720): 0.556519 at
   10^8 (CI +/-0.00041); the two-together model (HL singular series x
   Cramer consecutivity) 0.550315 — 89% of the bias, beating the
   one-channel 0.5 by 5.0 points. **U3b DONE (0171, 2026-10-25):**
   three-channel decomposition at 1e7/1e8/3e8/1e9 (exact sieves) —
   the NAIVE composed pair-bias model (1+/-delta)·w·e^{-2k/L} is
   ruled out at all four scales (|z| up to 519); the strict-CI gate
   is still NOT met (corrected z = 14.9 -> 74.1 across the scales;
   the U3 "7.7 se" was a double-discount of the CI half-width —
   corrected in place); new named finding: the transfer coefficient
   alpha(X) = 0.183/0.137/0.132/0.124 (decaying) — the pair bias
   enters the consecutive-gap census DILUTED, and measured =
   u3 + 2f(1-f)·alpha·delta to first order at every scale; U3c =
   derive the transfer mechanism and/or the next alpha decade
   (3e9/1e10). **U2 MEASURED (0172, 2026-10-25):** the finite Fourier sieve
   operator package (marks = commuting idempotents; single-p symbol =
   the exact comb N*delta_0 - (N/p)*1_{p-torsion}, max err 8.9e-15 all-a;
   full-sieve symbol = the Ramanujan field, FULL support for squarefree
   N, max err 4.5e-13 all 30030 characters; Parseval exact to 0.0) -
   the draft's torsion-subspace support formula corrected in place;
   sparse combs -> dense field under convolution is the measured
   contrast. **U2 LEAN WAVE-1 DONE (0175, 2026-10-25):** SieveAction.lean
   (namespace SieveFourier) builds green - 0 errors, lake 8706 jobs:
   rou/char_pow/dft/mark_notdiv/raman + mark_notdiv_idempotent +
   mark_notdiv_commute + chime_comb (the 3-case comb formula; the
   former 24-error wall) + raman_prime_closed; error descent 24 -> 0
   across the session; the p-multiple reindex closed via a
   conv-safe exponent equality (m*a = (p*a)*(m/p); a global rw of
   m = p*(m/p) self-overlaps inside (m/p)). WAVE-2 A2 GREEN (0177):
   rou_sum_orthogonality + mobius_sum_nat + mobius_unit_indicator +
   raman_inclusion_exclusion (the full-sieve symbol = the Ramanujan
   mu-sum) closed - divisor-branch reindex (Finset.sum_bij, m = d*j)
   + level collapse (rou N)^d = (rou (N/d)) + orthogonality; error
   descent 12 -> 0. WAVE-2 B GREEN (0178): raman_multiplicativity
   (c_{mn}(K) = c_m(K)*c_n(K) for (m,n)=1 - divisor-product
   bijection Nat.Coprime.mul_injOn_divisors + mu multiplicativity
   on coprimes + coprime divisibility split) + raman_full_support
   (c_N(a) ≠ 0 for squarefree N - strong induction over the
   squarefree decomposition M = p*k + prime closed form + B1 +
   nonzero product): the U2 full-support measurement as theorem.
   WAVE-2 C GREEN (0179): level_census + parseval_units (the
   Parseval identity sum_a |F[f](a)^2| = N * sum_m |f(m)^2| in
   general form: DFT expansion + triple-sum reindexing over product
   Finsets + root-of-unity kernel collapse + normSq bridges) -
   error descent 20 -> 0; the U2 Fourier-sieve program is now a
   machine-checked theorem chain end to end.
   **U4a DONE (0180, 2026-10-26):** the LEGENDRE EXACT identity in
   theorem form (new file SieveOrbit.lean, namespace SieveOrbit):
   (phi_list x ps : Z) = sum_{d | prod ps} (mu d : Z) * (x / d), by
   induction on ps - the step engine is the coprime split of mu over
   the divisor product ((p*P).divisors = p.divisors x^s P.divisors via
   Nat.Coprime.mul_injOn_divisors + sum_image + sum_product +
   Prime.divisors = {1,p} + sum_pair, and map_mul_of_coprime giving
   mu(p*d) = -mu d so the p-half of the sum is exactly the negated
   x/p-summand of the recursion) + the counting foundations
   (phi_list_count: the recursion IS the count of n in [1,x] coprime
   to prod ps; phi_list_mono; prime_dvd_prod_of_prime_list) +
   legendre_count_eq (sum = exact count) - scratch-first descent
   (c1..c21), in-tree 0 errors, lake 8706 targeted / 17450 full.
   **U4(b) MEASURED (0181, 2026-10-26):** the first-order
   upper/lower sieve gap at reachable z (the N3 width number),
   exact integers (kcs4b_width_number.py, tmp/kcs4b_out.txt):
   width W = U2 - L1 (the pairwise mass) with W/(xV) = 2.10 (z=7)
   -> 10.12 (z=71); the EXACT sandwich L1 <= Phi <= U2 on all 66
   rows (0 violations - the discrete level-1 property, named as
   the next Lean unit); the position rho = (Phi - L1)/W of the
   exact count is x-stable to ~1e-6 and z-decaying 0.84158 ->
   0.67288 (above the band's midpoint at reachable z - the first
   number for the "parity = opacity" reading); Phi triple-checked
   exact (mu-sum = recursion = brute) 11/11; remainder <= 1194.6
   vs worst case 2^20 - 1 (877x margin).
   **U4(b) FORMAL GREEN (0183, 2026-10-26):** the level1_sandwich
   theorem in tree (SieveOrbit.lean +818 lines, 1195 total):
   L1 x ps <= (phi_list x ps : Z) <= U2 x ps for every x and every
   distinct-prime list ps - the 0181 measured sandwich promoted to
   proved, through the mcount counting function, the pointwise
   residuals slack_t/slack_s (non-negative; level1_lower /
   level1_upper), the off-diagonal mass m(m-1)
   (offdiag_pointwise, mcount_offdiag_sum) and ordered = 2 x
   unordered (ordered_eq_two_pair, sum_bij through Prod.swap);
   scratch c13 (28 errors) -> c18 (0), in-tree 0 errors strict
   kernel replay, lake 8706 targeted / 17450 full. SieveOrbit.md
   card updated (U4a+U4b + the new pinned-mathlib gotchas: sum
   bodies stop at infix -/+, ascribed summands lift operands to
   Int.ediv, cast_sum pattern matching via Nat.cast form).
   **U4(c) DONE (0184, 2026-10-26):** the structural
   parity/anchor statement in tree (SieveOrbit.lean, 1251 total;
   structural, explicitly NOT a barrier theorem):
   level1_width_eq_pairwise (W = U2 - L1 = U2pair - the width IS
   the pairwise mass, the 0181 width number's theorem-form
   backbone), level1_width_nonneg (W >= 0),
   level1_position_in_band (0 <= Phi - L1 <= W - the well-defined
   home of the measured rho; 0181 anchors W/xV = 2.10 -> 10.12,
   rho = 0.84 -> 0.67 stay measured). The N3 row is now (a) proved
   (0180), (b) proved (0183, measured 0181), (c) structural
   statement landed (0184). **U1c DONE (0185, 2026-10-26):** the two-
   process zeta/sieve residual harness at the common edge
   (kcs1c_two_process.py, 58 s wall, raw table tmp/kcs1c_out.txt):
   sieve side EXACT at z = 31 (Phi remainders vs xV = 11.5/19.8/12.2/
   0.514 at 1e4…1e7, chi-3/chi-5 bounded exact ints in {-9,…,11});
   zeta side = C-channel E7a action identity at s = 1/2 + it, floor
   residual in [0, 5.3e-30] at dps 30; dps sweep shows R_z = O(10^-dps)
   exactly (precision law, not structural floor) — the naive two-
   identity-residual turn-taking is ruled out at this level; O1's
   narrow step = cross-correlate the EXACT sieve residual with a
   MEASURED zeta-side datum (E1/S-series type). The U1 unit is fully
   closed (a exact 0170, b margin 0170, c floor residual 0185).
   **U3c (a) DONE (0186, 2026-10-26):** the 1e10 point of the
   residual law on the identical U3b exact sieve (ladder re-
   measured: 1e7/1e8/3e8/1e9 all MATCH; pi(1e10) = 455052511 =
   tabulated): meas = 0.546585 (se 2.33e-05), R = +0.004307
   (z = 184.5 vs u3-only). The 1e10 point RULES OUT the alpha
   power law (ansatz B, z = 15.5), leaves the (loglog/log)² form
   alive-but-undetermined (C nearly flat over 1e8..1e10), and the
   2-param mixed form predicts within 1.2 sigma (ansatz C, sole
   survivor); strict gate still open (28.6 se) (tmp/kcs3c_out.txt,
   26 s wall, peak 16 GB).
   **U3c (d) DONE (0187, 2026-10-26):** the 3e10/1e11 points as a
   clean out-of-sample test (interval-sieve mechanism gated by an exact
   identity check at 1e10; pi(1e11) = 4118054813 = tabulated): 3e10
   meas = 0.544733, R = +0.003971 (z = 287.5 vs u3); 1e11 meas =
   0.542888, R = +0.003654 (z = 470.7 vs u3). The 4-pt-anchored mixed
   form UNDER-predicts at all three points, the positive excess growing
   +6.68e-04 -> +8.32e-04 -> +9.99e-04 (28.6/60.3/128.7 se); per-decade
   R decay stabilizes ~0.83-0.85, creeping up. VERDICT: no tested form
   confirmed as THE residual law; new named structure = the slowly
   growing positive excess; strict gate open (470.7 se at 1e11); 1e11
   = this box's memory ceiling (tmp/kcs3c_d_out.txt, 450 s wall,
   peak 92.7 GB).
   **U3c (e) DONE (0188, 2026-10-26):** the mechanism screen on the 7
   recorded points (no sieving, inverse-variance weighted): no
   single-component loglog form survives (best 1/log^2, 3.67 se); 19/21
   two-component pairs pass - the residual law is a TWO-COMPONENT
   structure (1/log^2 scale in 6 of the top-10 pairs; best: 1/log^2 +
   floor, chi2 3.17/5 dof); triples at chi2 2.76-3.00/4 dof (overfit
   zone); the 0187 excess fits ~(loglog X)^4.2 (middle point within
   2.3%), not a constant floor. Mechanism = decaying loglog-log
   component + growing ~(loglog)^4.2 component; strict gate open
   (needs a DERIVED term - next: U3c (f) product term delta*(loglog/log))
   (tmp/kcs3c_e_out.txt).
   **U3c (f) DONE (0190, 2026-10-27):** the named-candidate screen on
   the 7 points (no sieving; seconds): family extended with the DERIVED
   product term f8 = delta*(loglog/log) + a bare growing f11 = loglog;
   the derived 2-term R ~ a*(ll/l)^2 + b*f8 PASSES (chi2 3.88/5 dof,
   max 1.86 se; signs (-,+) - an ~8x cancellation structure; first
   purely derived form data-compatible); the growing line is never
   picked up (coeff ~2e-4 in every fit containing it) - the 0187
   growing excess is reproduced in-sample by the decay-cancellation
   (-f2 + f8); the 3-point (loglog)^4.2 hint (0188) and the 7-point
   fit prefer different descriptions (both recorded). Out-of-sample
   at 3e11/1e12 = named discriminator, beyond this box (0187).
   Strict gate OPEN.
   **U3c (c) COMPLETE + 1e12 point (0191 + 0192, 2026-10-27):** the LOS
   paper (arXiv:1603.03720v4, PNAS 2016) fetched + identity-checked +
   persisted; its r = 2, q = 4 Section-5 ACTUAL rows: ALL FOUR
   PUBLISHED ROWS AGREE with the independent exact pair-class sieve at
   the published precision (1e9 11,413,177 / 14,010,314; 1e10
   103,160,935 / 124,362,340; 1e11 941,199,658 / 1,117,820,622; 1e12
   8,654,138,673 / 10,149,785,667; pi(1e11) and pi(1e12) = tabulated,
   IDENTITY). NEW: pi(1,3) = pi(3,1) EXACTLY at all four scales (C1.5
   antisymmetry exact to 1e12); diagonal asymmetry +551 / +5,960 /
   +14,252 / +63,337; 'meas' pipeline re-derived to ~5e-7. THE NEW
   1e12 LADDER POINT (first beyond the 0187 memory ceiling; 20
   checkpointed 5e10 windows, ~38 min, 56 GB/window): meas(1e12) =
   0.539769 (se 2.570e-6), u3 = 0.536638 (S2/(S2+S0) baseline
   re-verified to <= 6e-7), **R(1e12) = +0.003131** (per-decade ratio
   0.857, in line with 0187). THE OUT-OF-SAMPLE VERDICT (the named
   discriminator): 0186 mixed form predicts +0.001883 -> diff
   +0.001248 = 485.6 se, DECISIVELY RULED OUT; 0190 DERIVED 2-TERM
   form predicts +0.003139 -> diff -0.000008 = -3.1 se, CONFIRMED
   OUT-OF-SAMPLE (the predictions stood 489 se apart). HONEST GATE:
   the strict-CI gate is NOT declared closed (-3.1 se just outside a
   2-se CI; coefficients in-sample fitted) but every live FITTED form
   is ruled out at 15-486 se - the derived 2-term form is the SOLE
   SURVIVING candidate and the RECORDING residual law over 1e7..1e12:
   R(X) = -1.88114*(ll/l)^2 + 3.69471*delta*(ll/l). Corr. of record:
   the first 1e12 tally used the wrong baseline (1+delta)/2 (void line
   kept in 0192). No RH claim.
   **U3c (g) the DERIVATION TEST (0193, 2026-10-27, instant):**
   scripts/rh/kcs3c_g_derivation.py -> tmp/u3c_c_fig/kcs3c_g_out.txt.
   ALGEBRA: the paper's Conjecture 1.1 display formulas (q = 4,
   verbatim) collapse in the census ratio to EXACTLY (1+delta)/2 to
   1/log x (N/D - (1+delta)/2 = +-1.1e-16 at 1e7..1e12; the 0173 delta
   identity is a consequence of the full main conjecture: +u/2 - u/2
   and ln(pi/2)+ln(2/pi) = ln 1 cancel). What the paper's own
   accounting leaves for S = meas - (1+delta)/2 (the 0173 52-sigma
   structure): {non-oscillating lower-order terms, the paper-flagged
   (loglog/log)^2 scale} + {oscillating zero terms} + O(x/log^(7/4)).
   DATA (8-pt inv-var screen on {u^2, u/L, 1/L}): S = 0.00528 u^2 +
   1.20166 (u/L) + 0.00979 (1/L) (chi2 = 4.33/5 dof, max resid 1.84
   se) - the paper-flagged (loglog/log)^2 scale carries ~1% of S; the
   leading structure is ONE ORDER BELOW it at (loglog/log^2) (92% of
   S(1e12)). g = u3 - (1+delta)/2 is 3-scale smooth to 0.02 se; the R
   law's (u,1/L) basis = -0.033785 u^2 + 0.834234 (u/L) (algebraic;
   matches the recorded R pointwise <= 1.9 se, +3.0 se at 1e12 per
   0192). VERDICT: the residual's TERM STRUCTURE is now DERIVED from
   the paper's own accounting + the exact g; the two COEFFICIENTS
   remain fitted (the paper does not quantify its O-terms) - gate
   unchanged from 0192 at that writing. No RH claim.
   **Second out-of-sample point (0194, 2026-10-27, ~39 min, 60
   checkpointed windows, prefix identity-gated on the tabulated
   pi(1e12)):** R(3e12) = +0.002918 (meas = 0.538446, se 1.515e-06,
   pi(3e12) = 108,340,298,703, u3 = 0.535528, z vs u3 = +1926.8).
   The 0190 derived form predicts +0.002932: diff -0.000014 = -9.5 se
   measurement-only, **-0.9 sigma COMBINED** once the form's own
   prediction covariance (sigma_pred = 1.52e-05 from the 7-pt fit) is
   included; the 1e12 point recomputed the same way is -0.6 combined
   (sigma_pred 1.25e-05) - BOTH out-of-sample points INSIDE the
   combined 1-sigma band (the strongest statement the law has ever
   had). The mixed form rejected a second time at 888.3 se. NEW: the
   C1.5 antisymmetry pi(1,3) - pi(3,1) went non-zero for the first
   time (-1 at 3e12; exact 0 at 1e9..1e12); the diagonal-asymmetry
   4-point 'growth' narrative corrected to 'small drift within budget'
   (+51,539). GATE (updated): MEASURED clause strongly satisfied
   (both points <= 0.9 combined sigma); DERIVED-NOT-FITTED clause
   satisfied for the term structure (0193) but not yet the
   coefficients - 1e13 point LANDED (0199): S(1e13) = +0.004947 hits
   the pre-registered 9-pt S-form at +0.1 se (S/B = 0.384, in-band
   sequence continues); on the combined-sigma standard the 0190
   two-term R-law is z(combine) = -0.97 at 1e13 - marginally inside
   the combined 1-sigma, third consecutive one-sided OOS miss (-0.6/
   -0.9/-0.97) at the edge of its reach; working extrapolation object
   updated to 3-scale S-form + exact baseline. The Section-2 heuristic
   evaluation (scale vs value) is CLOSED (0196: scale predicted,
   value not); no RH claim.
   Recall incident logged in 0170 (a 65/35 benchmark was unverified
   memory; corrected to the verified LOS framework). No RH claim:
   prime-gap class statistic + exact sieve algebra, flank not face.
