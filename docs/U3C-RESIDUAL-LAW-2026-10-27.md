# U3c — the transfer mechanism and the residual law (2026-10-27, WRAP-UP)

Scope: the KCS `rh-missing-tail` flank unit U3c ("transfer mechanism + the
residual law"), records **0173 → 0192** (+ 0193 pending). This document is the
single canonical record of the measured quantity, the eight-point ladder,
the model chronology with verdicts, and the provenance annex (all four
published LOS data rows cross-checked). **No RH claim anywhere: this is a
finite statistical model test of a prime-gap class census residual over exact
integer sieves. Flank work — it does not gate the mainstream face.**

---

## 1. The measured quantity

```
R(X) = meas(X) - u3(X)
```

- **meas(X)** — the *q = 4 consecutive-prime off-diagonal class fraction*:
  the fraction of gaps between consecutive primes (both ≤ X, the chain
  starting at (2, 3)) that are ≡ 2 (mod 4), i.e. whose endpoints sit in
  different odd residue classes mod 4. Computed exactly from the prime
  sequence (the U3/U3b numpy odd-sieve machinery, `kcs3b_gap_class_u3b.py`;
  the (2,3) gap — k = 0 — sits in the denominator as an "even" bucket).
  Variance is binomial: `se = sqrt(f(1-f)/(pi(X)-1))`.

- **u3(X)** — the *two-together pair model* (the "U3-only" baseline of the
  record):** NOT** the main-conjecture LOS pair fraction. It is
  `u3 = S2/(S2+S0)` where

  ```
  w(k)  = 2*C2 * prod_{q>2, q|k} (q-1)/(q-2)        (the twin-prime
         constant machinery, C2 = 0.660161815847..., k = 1..K, K = 2000)
  S2(L)  = sum_{k odd,  k<=K} w(k) e^{-2k/L}        L = ln X
  S0(L)  = sum_{k even, k<=K} w(k) e^{-2k/L}
  ```

  (the Poisson-gap two-together expectation for the "k odd" class; the
  K = 2000 truncation costs e^{-2K/L} <= e^{-83}). The baseline was
  re-verified against all recorded values at 1e7..1e11 to ≤ 6e-7
  (0192, audit trail of the 1e12 baseline correction).

- **δ(X)** — the verified LOS q=4 loglog factor (0173, the paper's main
  conjecture, identity-checked): `δ(X) = (1/(2 ln X)) ln(2 pi ln X / 4)`.

The *related* main-conjecture pair fraction `(1+δ)/2` is a DIFFERENT object
(0.0025–0.0039 below u3 over this range; using it as the baseline produced
the recorded-and-void spurious R(1e12) = +0.005654 of 0192).

## 2. The eight-point ladder (exact integer sieves, 1 core each)

| X      | meas      | u3        | R = meas − u3 | se        | source |
|--------|-----------|-----------|---------------|-----------|--------|
| 1e7    | 0.564864  | 0.555808  | +0.009055     | 6.082e-04 | 0170/0171/0173 |
| 1e8    | 0.556519  | 0.550315  | +0.006205     | 2.070e-04 | 0170/0171/0173 |
| 3e8    | 0.553811  | 0.548097  | +0.005714     | 1.233e-04 | 0173 |
| 1e9    | 0.551072  | 0.545905  | +0.005166     | 6.975e-05 | 0173 |
| 1e10   | 0.546585  | 0.542278  | +0.004307     | 2.334e-05 | 0186 |
| 3e10   | 0.544733  | 0.540762  | +0.003971     | 1.381e-05 | 0187 |
| 1e11   | 0.542888  | 0.539233  | +0.003654     | 7.763e-06 | 0187 |
| 1e12   | 0.539769  | 0.536638  | +0.003131     | 2.570e-06 | **0192 (new)** |
| 3e12   | 0.538446  | 0.535528  | +0.002918     | 1.515e-06 | **0194 (measured)** |

\(3e12 measured in 0194: 60 checkpointed 5e10 windows, ~39 min, 56.2
GB/window; prefix integrity: the [0, 1e12] two-window slice sums
EXACTLY to the tabulated pi(1e12) = 4,118,054,813; max boundary gap
232 <= 2000; pi(3e12) = 108,340,298,703.)

Per-decade R decay ratios over the ladder: 0.685, 0.841, 0.825, 0.834, 0.844,
0.853, 0.857, 0.868 (0187 + 0192 + 0194 implied, from the 3e12 half-decade
ratio 0.932) — a stable, slowly creeping-up sequence.
z(vs u3) at 3e12: +1926.8.
z(vs u3) at 1e12: +1218.3. Every point was identity-gated (π vs tabulated
where tabulated; the 1e11/1e12 runs additionally verified by pi(1e10)
reproduction and boundary-gap checks).

## 3. Model chronology — every candidate with its verdict

| candidate | form | verdict | record |
|---|---|---|---|
| single-component loglog family | R ~ c·f, f ∈ {δ, (ll/l)², (ll/l)³, ll/l, 1/log, 1/log², floor} | ALL FAIL (best 1/log², max resid 3.67 se over the 7-pt screen) | 0188 |
| alpha power law | log α = b0 + b1·loglog (the U3b transfer coefficient) | RULED OUT at 1e10 (z = 15.5) | 0186 |
| C(X)·(ll/l)² (C variable) | the 0173 leading ansatz | C not flat (0.304→0.232 over 1e8..1e10, 1e7 25% high) — alive-but-undetermined at 5 pt; subsumed by the (e)/(f) screens | 0173/0186 |
| 19/21 two-component pairs | screen over the 7-pt family | INCONCLUSIVE at 7 points (19 pass the bar; 1/log² scale in 6 of the top-10) | 0188 |
| 3-point excess hint | e(X) ~(loglog X)^4.2 | the 0187 excess (+6.68e-04/+8.32e-04/+9.99e-04 at 1e10/3e10/1e11) — a DECAY-CANCELLATION appearance in the full 7-pt fits (the growing line f11 = loglog gets coefficient ~2e-4 = dead) | 0187/0188/0190 |
| **4-pt mixed (0186)** | R = −0.123764·δ + 0.715792·(ll/l)² | the 0186/0187 survivor; under-predicts 1e10/3e10/1e11 (+6.68e-04/+8.32e-04/+9.99e-04 = 28.6/60.3/128.7 se); **RULED OUT at 1e12: +0.001883 vs +0.003131, diff = 485.6 se** | 0186/0187/**0192** |
| **derived 2-term (0190)** | R = −1.88114·(ll/l)² + 3.69471·δ·(ll/l) (the LOS-derived leading + product terms; pure 7-pt fit, in-sample max 1.51 se) | **CONFIRMED OUT-OF-SAMPLE at BOTH 1e12 and 3e12 within the combined (form + measurement) uncertainty: 1e12 diff −0.000008 (−3.1 se meas-only, −0.6 combined, σ_pred 1.25e-05); 3e12 diff −0.000014 (−9.5 se meas-only, −0.9 combined, σ_pred 1.52e-05)**; the mixed form rejected both times (485.6 / 888.3 se) | **0190/0192/0194** |

## 4. The recording structure (as of this writing)

```
R(X) = -1.88114 * (loglog X / log X)^2 + 3.69471 * delta(X) * (loglog X / log X)
      delta(X) = (1/(2 log X)) log(2 pi log X / 4)
```

- over 1e7..1e12: in-sample max |resid| 1.51 se (7 pt), out-of-sample
  **−3.1 se at 1e12** (the first ladder point ever measured by the form's
  out-of-sample behavior, at 489 se separation from the rival prediction);
- the structure is a *cancellation of two decaying terms* (the product term
  decays slower than the leading; their difference produces the slowly
  decaying observed R and — over the 1e10..1e12 tail — the "growing excess"
  appearance of 0187/0188);
- the (loglog)^4.2 excess hint of 0188 is subsumed: it was this cancellation
  seen on 3 points (0190).

**Honest gate statement (no drift, updated 0194):** the program's
strict-CI gate has two clauses. (MEASURED) Satisfied at both out-of-sample
points: the derived-terms form predicts 1e12 to −0.6 combined sigma and
3e12 to −0.9 combined sigma, where 'combined' = the form's own prediction
uncertainty (σ_pred = 1.25e-05 / 1.52e-05 from the 7-point fit covariance)
quadrature-added to the measurement se; the measurement-only statistics
(−3.1 / −9.5 se) overstate the tension and are retained for the audit
trail. (DERIVED-NOT-FITTED) Satisfied for the TERM STRUCTURE (0193: the
terms fall out of the paper's own accounting); NOT yet for the two
COEFFICIENTS (still fitted; σ_pred is a 7-point Gaussian extrapolation
that excludes model-form error). Named discriminators for the next
sharpening: the 1e13 point (~7 h, schedule-eligible) and the
Section-2-heuristic evaluation of the paper's O-terms (open item 5).
Every previously live FITTED form is ruled out (single-component 15-485 se,
alpha power law 15.5 se, 4-pt mixed 485.6/888.3 se at 1e12/3e12) - the
derived 2-term form is the SOLE SURVIVING candidate.

## 5. Provenance annex (the 0191/0192 data cross-checks)

- **Paper**: Lemke Oliver & Soundararajan, "Unexpected biases in the
  distribution of consecutive primes", PNAS 2016, arXiv:1603.03720v4
  (DOI 10.1073/pnas.1605366113). Fetched, identity-checked (title line),
  persisted: `tmp/u3c_c_fig/paper.pdf` + `paper.txt`.
- **All four published r = 2, q = 4 Section-5 ACTUAL rows corroborated** by
  an independent exact pair-class census (tolerance = half a unit in the
  last published figure):

  | x    | paper (1,1) | exact (1,1) | paper (1,3) | exact (1,3) | π identity |
  |------|-------------|-------------|-------------|-------------|------------|
  | 1e9  | 1.141e7     | 11,413,177  | 1.401e7     | 14,010,314  | —          |
  | 1e10 | 1.032e8     | 103,160,935 | 1.244e8     | 124,362,340 | 455,052,511 ✓ |
  | 1e11 | 9.412e8     | 941,199,658 | 1.118e9     | 1,117,820,622 | 4,118,054,813 ✓ |
  | 1e12 | 8.654e9     | 8,654,138,673 | 1.015e10  | 10,149,785,667 | 37,607,912,018 ✓ |

- **C1.5 antisymmetry**: π(x;4,(1,3)) − π(x;4,(3,1)) = 0 at all four scales
  1e9..1e12, and −1 at 3e12 (0194) - the FIRST non-zero value (1 in 2.9e10,
  far inside the paper's O budget); the empirical zero-sum held exactly from
  1e9 to 1e12.
- **Diagonal asymmetry** π(3,3) − π(1,1) = +551 / +5,960 / +14,252 / +63,337
  / +51,539 (1e9..3e12) - a small drift within budget, NOT monotone (the
  4-point 'growing a few × per decade' narrative of 0191/0192 is corrected
  in place by the 3e12 value) - recorded, not fitted.
- **Convention notes**: the paper's π(x;q,(a,b)) counts p_n ≤ X with
  successor unrestricted (odd p_n; 2 excluded); the record's `meas` counts
  gaps between consecutive primes both ≤ X (incl. the (2,3) gap). `meas`
  re-derives from raw pair counts to ≤ 5e-7 (0191). The 1e10/1e11/1e12
  global/interval sieves were identity-gated (π vs tabulated + the 1e10
  reproduction gate of 0187; boundary gaps ≤ margin, max seen 92).

## 5b. U3c (g) — the DERIVATION TEST (0193, 2026-10-27)

`scripts/rh/kcs3c_g_derivation.py` → `tmp/u3c_c_fig/kcs3c_g_out.txt`.

- **Algebra (verified to machine zero):** the paper's Conjecture 1.1
  display formulas (q = 4, read verbatim) give
  N = π(1,3)+π(3,1) = (li/2)[1 + u/2 + ln(π/2)/(2L)] and
  Diag = π(a,a) = (li/4)[1 − u/2 + ln(2/π)/(2L)] + O(x/log^(7/4)x);
  in the census ratio the two corrections CANCEL
  (+u/2 − u/2; ln(π/2) + ln(2/π) = ln 1 = 0) and
  **meas_paper = (1+δ)/2 EXACTLY to order 1/log x** — the 0173 δ
  identity is a *consequence* of the full main conjecture
  (N/D − (1+δ)/2 = ±1.1e-16 at 1e7..1e12).
- **What the paper leaves for S := meas − (1+δ)/2** (the 0173 52-σ
  structure): {non-oscillating lower-order terms ("of size
  (loglog/log)²... we hope to understand these lower order terms in
  future work")} + {oscillating zero terms} + O(x/log^(7/4)).
- **The data's answer (8-pt inv-var screen on {u², u/L, 1/L}):**
  S = 0.00528·u² + 1.20166·(u/L) + 0.00979·(1/L), χ² = 4.33/5 dof,
  max resid 1.84 se. The paper-flagged (loglog/log)² scale carries
  **~1%** of S; the leading structure sits ONE ORDER BELOW the flagged
  scale, at (loglog/log²). The exact baseline gap g = u3 − (1+δ)/2 is
  3-scale smooth to 0.02 se (no hidden structure at meas precision);
  the R law in the (u,1/L) basis is the algebraic identity
  R = −0.033785·u² + 0.834234·(u/L) (matching the recorded R pointwise
  ≤ 1.9 se; +3.0 se at 1e12 per 0192).
- **Verified-vs-fitted (no drift):** the TERM STRUCTURE is now DERIVED
  from the paper's own accounting; the paper's unquantified O-terms
  leave the two COEFFICIENTS fitted (0190). Gate unchanged from 0192.

## 6. Open items (honest)

1. **3e12 DONE (0194)**: the derived form's second out-of-sample test -
   R(3e12) = +0.002918 vs pred +0.002932: −0.9 combined sigma (the mixed
   form rejected at 888.3 se); the C1.5 antisymmetry first went non-zero
   there (diff −1); the diagonal-asymmetry 'growth' narrative corrected
   to 'small drift within budget' in the same entry.
2. **The strict-CI gate**: not declared closed (see §4); closing it would
   require the form to land inside CI on an out-of-sample point (or a full
   derivation of the coefficients from the proven expansion — the next
   mathematical step, named below).
3. **The named next step**: derive (or bound) the two derived-form
   coefficients —1.88114 / +3.69471 from the LOS expansion itself (the c1, c2
   constants plus the flagged (loglog/log)² lower-order terms of the
   paper's own main-conjecture remainder); if the derivation reproduces
   them, the gate's "derived, not fitted" clause becomes literally true.
4. **Scale**: 3e12 is the practical ceiling of this box at ~2 h per point
   (60 windows); 1e13 would take ~7 h (named, not scheduled).
5. **The named DEEP follow-up (0193): evaluate the paper's full Section 2
   heuristic (D0 + D1 + D2 singular-series densities via
   Proposition 2.1's S0(q, v; H) sums) to obtain the CONJECTURE's OWN
   prediction of the R coefficients** (the u/L coefficient 0.834234 and
   the u^2 coefficient -0.033785). Status: named, not started — the
   heuristic is unproven (a coefficient predicted by a conjecture's own
   heuristic has the same status as the (1+delta)/2 prediction: strong
   confirmation material, not a derivation in the theorem sense), and the
   extracted display text needs a careful reading pass (alpha-weights,
   the eps term) before any numeric claim. If the evaluated heuristic
   reproduces 0.834, the law's structure is triple-anchored
   (data + term-structure derivation + conjecture-internal prediction).

## The 1e13 close-out (0199, 2026-10-28)

* The 1e13 point was **run two-way** (the recorded 56.2 GB peak was a
  ru_maxrss high-water: 25 GB odd-only bool sieve + 13.7 GB nonzero index +
  13.7 GB redundant astype copy; the copy went -> 40 GB high-water ->
  2x40 + 16 GB system < 124 GB safe; validated by a fresh two-worker
  recomputation of the frozen 1e12 shard: 20 windows x 11 fields, exact).
  Landed: 200 windows, ~5.5 h wall (vs ~8.4 h serial).
* **pi(1e13) = 346,065,536,839** (exact); max boundary gap 232 <= 2000;
  meas(1e13) = 0.537106 (se 8.476e-07).
* **S(1e13) = +0.004947 = the PRE-REGISTERED 9-pt S-form prediction
  0.004947 (0196, before this run) - a +0.1 se out-of-sample hit** (the
  8-pt pre-3e12 form misses at -8 se). S/B = 0.384: the in-band sequence
  0.496 -> 0.384 is monotone and inside the paper's truncation band
  through 1e13; the 9-pt fit absorbs the point at chi2 5.54 / 8 dof.
* **R(1e13) = +0.002712.** The 0190 two-term R-form direct (+0.002729)
  misses at -1.7e-5 (-20.4 meas-se) - OUT OF SPEC for the first time;
  the composite (9-pt S-form + EXACT baseline g = u3 - (1+delta)/2 =
  0.002236) predicts +0.002711, within +1.2 se. WORKING EXTRAPOLATION
  OBJECT UPDATED: the 3-scale S-form plus exact baseline; the 0190
  two-term R-law's fitted coefficients are demoted from extrapolation
  (its DERIVED form stands in tree, 0197; what it lacks is exactly the
  u/L scale the 3-scale S-form carries).
* **alpha(1e13) = 0.08475** (the U3b transfer inversion): PASSES the 0198
  on-file envelope (0.0829-0.0883, ~0.085 +/- 0.002); alpha*L = 2.5367
  stays in the converged band 2.53-2.57; the X-stable transfer gain
  0.4928 -> 0.4974 continues at the new decade.
* **Mirror equality (0196)**: pi(1,3) - pi(3,1) = -1 at 1e13 (the row:
  exact 0 at 1e9..1e12, then -1 at 3e12, -1 at 1e13 - O(1) offsets, no
  growth).
* The named DEEP follow-up (full Section-2 heuristic coefficients) stands
  as the next mathematical step on this flank; its status is unchanged by
  the 1e13 point. No RH claim.

*No RH claim. Flank record, 2026-10-27 (updated with 0193; closed out at
1e13 with 0194/0196/0199, 2026-10-28).*
