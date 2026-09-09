# The width ladders — tables and certificates

All values below: dps-35/45 mpmath (docker) unless labeled float64
dual-stack. No asymptotic fit anywhere in this file — the tables come
from the exact identity, extrapolated in 1/N (measured single exponent
−1.0005 ± 0.001) with a 3rd-cut guard.

## 1. The identity (E7a)

```
Σ_{n=N+1}^{M} a(n)·n^{−s} = A(M)M^{−s} − A(N)N^{−s} + s ∫_N^M A(u)·u^{−s−1} du
```
Exact for every step path A, every s. Verified dps-50, 5/5 cases
(periodic χ₅ paths at t = 1, 10, 100 over 26–204 periods, and a
non-periodic random ±1 path): residuals 2.09e-53 .. 1.67e-51.
Output: `day006_euler_action_identity` run (kainos-logos,
`scripts/rh/out_day006_euler_action_identity.txt`).

## 2. Exact tail (the computation, P-E.2)

For a mean-zero primitive character mod q with band `P(r)`:

```
tail(N, s) = Σ_{n>N} χ(n) n^{−s} = Σ_{j : χ(j)≠0} χ(j) · q^{−s} · ζ_H(s, n₁(j)/q)
```
where `n₁(j)` is the first integer > N in class j (exact integers,
residue discipline). M₁(r) := lim_{N→∞} (tail + P(r)·N^{−s})·N^{s+1}/s
evaluated by 2-cut linear-in-1/N extrapolation (guard residual
1.6e-14 .. 5.7e-14, N ≈ 10⁶, dps-35).

## 3. χ₅ (q = 5), t = 10 — 1e-10

| r | P(r) | M₁(r) |
|---|------|-------|
| 0 | 0 | +2/5 |
| 1 | 1 | +2/5 |
| 2 | 0 | −3/5 |
| 3 | −1 | −3/5 |
| 4 | 0 | +2/5 |

- D = −P: verified at 1e-10 on all 5 phases (the edge flux of the
  closed action).
- Two-valued structure: M₁ = +2s/5 for r ∈ {0,1,4}; −3s/5 for
  r ∈ {2,3}; ratio |−3/5|/(2/5) = 3/2 exact (measured 1.50000 to 7
  digits, arg offset −π, two stacks: float64 TS and dps mpmath).
- **t-independence**: r = 0, 2 give identical M₁ at t = 3 (1e-10).

## 4. χ₁₃ (q = 13), t = 10 — 1e-10, ALL INTEGERS

| r | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|----|----|----|
| P(r) | 0 | 1 | 0 | 1 | 2 | 1 | 0 | −1 | −2 | −1 | 0 | −1 | 0 |
| M₁(r) | 2 | 2 | 1 | 1 | 0 | −2 | −3 | −3 | −2 | 0 | 1 | 1 | 2 |

- All 13 values are integers; r = 4, 9 (the P = ±2 phases) are
  exactly 0.
- D = −P verified at 1e-10 on all 13 phases.

## 5. Structural laws measured at three moduli (conjecture: odd-prime quadratic cells generally)

1. **Mirror symmetry**: M₁(r) = M₁(−r mod q) for every r — measured at
   q = 5, 13, 17.
2. **Zero-sum rolling trace**: Σ_{r=0}^{q−1} M₁(r) = 0 — measured at
   q = 5, 13, 17 (the "centroid height of the period roll" is zero — the
   rolling/tautochrone layer, see PLAN.md P-A).
3. **t-independence**: M₁ depends on (r, χ) only, to 1e-10 (checked
   at t = 3 and t = 10).
4. **Integer-valuedness** (q = 13; q = 5 fifth-multiples): the
   general statement "M₁(r, χ) ∈ ℚ of small denominator, actually ℤ
   at q = 13" is the shape to test at q = 17.

## 6. Second rung (drift) — measured, one phase, 4 digits

χ₅, r = 1, t = 10, N = 10⁴·2ᵏ, 7-point log-log:

```
c_r(N)/s = M₁ + (3/5 + 2i/5)·(t/N) + O(N^{−2}),   drift exponent −1.00052 ± 0.001
```

- The exponent is phase-universal in the 5-phase table (all at
  O(N⁻¹), two stacks).
- **Cross-phase coupling**: the imaginary part of the drift carries
  M₁(r) *itself* (2/5); the real part carries the *other*
  phase-group's moment (3/5 = |M₁(group B)|). First measured
  instance of such coupling in a truncation ladder.

## 7. The onset (ζ tail, σ = ½) — measured 4 digits

```
C/|I| = ½·(t/N),  crossing 1 at t/N = 2
```
(zero-oscillation term C vs pole/edge term I; the N-column 10⁴–10⁵
clean, re-verified at the EM cap lift; t = 10⁴·k columns agree to 4
digits.) The half-term −½·N^{−s} of the Euler–Maclaurin ladder is M₁
in the smooth-path slot — measured day-004 as |ζ(s)−P_N| =
N^{1−σ}/|1−s|, first tail T₁/T₀ = 2.000, second tail −½N^{−s}.

Reading (labeled interpretation): the onset is the unit-magnification
configuration (object u = N, image v = t/2, u = v) of the reciprocal
lens u ↦ 1/u under which the missing tail is the image of the cell
structure — i.e. the moment the zero-side interior action overtakes
the edge action in the budget. At onset the boundary cell holds
1/π of one zero-wavelength in log-space.



## 8. χ₁₇ (q = 17), t = 10 — 1e-9, ALL INTEGERS (the third odd modulus)

| r | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 |
|---|---|---|---|---|---|---|---|---|----|----|----|----|----|----|----|----|----|
| P(r) | 0 | 1 | 2 | 1 | 2 | 1 | 0 | −1 | 0 | 1 | 0 | −1 | −2 | −1 | −2 | −1 | 0 |
| M₁(r) | 4 | 4 | 3 | 1 | 0 | −2 | −3 | −3 | −2 | −2 | −3 | −3 | −2 | 0 | 1 | 3 | 4 |

- All 17 values integers to the measured 1e-9 (r = 4, 13 are 0 to 1e-10);
  2-cut internal spread 7e-15..1.9e-13.
- D = −P verified 17/17 at 1e-10.
- Mirror M₁(r) = M₁(−r) exact at table precision; trace Σ M₁ = 0 exact —
  the rolling zero-centroid law now holds at **three moduli (5, 13, 17)**.
- The two-valued q = 5 pattern stays q-specific: q = 17 is six-valued
  ({−3, −2, 0, 1, 3, 4}).

## 9. τ₁₂ (q = 12, primitive real Dirichlet) — the first even modulus, 2 × 4 × 3

Measured with the same exact machinery (dps-35, N ≈ 10⁶, zero fits):

| r | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---|---|---|---|---|---|---|---|----|----|----|----|
| P(r) | 0 | 1 | 1 | 1 | 1 | 0 | 0 | −1 | −1 | −1 | −1 | 0 |
| M₁(r) | 2 | 2 | 1 | 0 | −1 | −2 | −2 | −2 | −1 | 0 | 1 | 2 |

- All integers (the r = 3, 9 entries are 0 to 2×10⁻¹⁴).
- **Antipode (front ↔ back, r ↔ r+6): M₁(r+6) = −M₁(r) at 10⁻¹⁰…10⁻¹⁴**
  — sign flip, *measured*. (The character itself carries it:
  τ₁₂(r+6) = −τ₁₂(r) on its support {1,5,7,11}.)
- Mirror M₁(r) = M₁(−r) at 6.5×10⁻¹⁴; trace Σ M₁ = 0 at 3.3×10⁻¹⁴.
- Quadrant 4-tuples (step 3 = 90°): (2, 0, −2, 0), (2, −1, −2, 1),
  (1, −2, −1, 2) — antipode sign-flip pairs, each orbit sums to 0.

In 2×4×3 language: 2 = antipodal sign flip; 4 = zero-sum quadrant orbit;
3 = the three orbits. Status: measured at q = 12 (single instance) →
conjecture until τ₂₀/τ₂₈ (queued) and the odd q = 17.

## 10. F₂₄ front/back (the Fibonacci-mod-12 cell, mean-centered)

Two cell classes, two front-back laws (both measured):

- **RAW (exact, no approximation).** front = [1,1,2,3,5,8,1,9,10,7,5,0],
  back = [5,5,10,3,1,4,5,9,2,11,1,0]. back − front (mod 12) =
  4·[1,1,2,0,2,2,1,0,1,1,2,0]: every entry divisible by 4 — **the two
  halves are identical mod 4 (the quadrant part of the cell); the front/
  back slide is a mod-3 shift.** "The next 12 sweep the back quadrants" is
  literally true at the mod-4 level.
- **M₁ (dps-40, 6-cut least-squares, per-phase relative guard 10⁻⁶).**
  All 24 phases = a common mass (−17,470 ± 349,150i, scale a genuine cell
  feature: half-integer values, t = 10 phase) + per-phase structure ≤ ~40.
  **Antipode max|M₁(r) − M₁(r+12)| = 42: back = front to ~99%** (near-
  identity, NOT the τ₁₂ sign flip). Non-multiplicative cells organize
  front/back differently from multiplicative ones.
- **Open (E7c):** the t-dependent drift (second rung, §6) is the live
  t-object; whether it respects the 4-tuple decomposition is unmeasured.
