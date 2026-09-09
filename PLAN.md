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
- E7b (the big one): spectral decomposition of the measured onset C
  over the zero list with the Riemann-1859 density kernel
  (1/lnx − 2Σ x^{−1/2}cos(γ lnx)/lnx), nearest zero dominant.
  **NEXT.** PASS certifies the zero side of the recognition map;
  FAIL finds non-explicit-formula content.

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

## Stage map (what v0 does NOT contain) — cross-ref README §program

1. **10⁷ certification** (in progress): corrected N(10⁷), S(10⁷),
   2K(10⁷), the dead-chunk Δ.
2. **E7b** — the zero-side spectral test (days, not weeks; data on
   hand).
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
