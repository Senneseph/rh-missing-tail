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
7. **The terminal face (NAMED, unchanged):** the in-tree closure of
   the `hOffC` face remains blocked on the external `[Z78C]` frontier
   (0.8747729897, below in-tree; frontier board sweep 2026-10-24:
   28 records, nothing new, no adoption trigger). The data edge is a
   FLANK — it never closes the face; the face stays named.
8. **The second orbit (KANSAS CITY SHUFFLE, IN PROGRESS):**
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
   descent 12 -> 0. Remaining Wave-2 (raman_multiplicativity /
   raman_full_support / raman_level_census / parseval_units) staged.
   **U4 TO-BUILD:** the parity-as-width statement.
   Recall incident logged in 0170 (a 65/35 benchmark was unverified
   memory; corrected to the verified LOS framework). No RH claim:
   prime-gap class statistic + exact sieve algebra, flank not face.
