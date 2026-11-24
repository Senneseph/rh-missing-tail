# honline formalization scope

## The target statement

The B25 endpoint (`RHEnd.rh_program78_stripfront_mach_unifiedContinuumAnchor_PT2`,
and its concretization `ZetaConcrete.rh_program78_qz_continuumAnchor_PT2`)
carries the named input

```
honline : ∀ ρ ∈ qz.Z, 0 < |ρ.im| → |ρ.im| < 707/50 → ρ.re = 1/2
```

(the classical small-height on-line fact; 707/50 = 14.14). It is the
smallest of the four residual named inputs (`hzF`, `honline`, `hPT2`,
`hOffC`) and the only one that is a theorem of classical mathematics with
a bounded numerical proof — i.e. the only one that can in principle be
DISCHARGED in-tree, the same way `hqz` was discharged by ZetaConcrete
(0476).

## Proof structure (classical, independent of any external exposition)

Let `T0 := 707/50`. Take `ρ ∈ qz.Z` with `0 < |ρ.im| < T0`.

1. **Strip.** `0 < ρ.re < 1` — already PROVEN in-tree
   (`ZetaConcrete.zetaNontrivialInStrip`; fe-pairing +
   `riemannZeta_ne_zero_of_one_le_re`). So `ρ` lies in the open
   rectangle `R0 = (0,1) × (0, T0)` (or its conjugate; the case split
   on the sign of `ρ.im` is harmless).

2. **Count.** The slice
   `S(T0) := {ρ | ζ ρ = 0 ∧ 0 < ρ.re < 1 ∧ 0 < ρ.im < T0}` is a SINGLE
   element. This is the new mathematical content: a rigorous zero-count
   `#S(T0) = 1` (multiplicity-free, since the count must be exactly one
   and zeros of ζ are simple off the real axis — or prove the count and
   simplicity together).

3. **Orbit.** If `ρ ∈ S(T0)` had `ρ.re ≠ 1/2`, the orbit
   `{ρ, ρ*, 1-ρ, 1-ρ*}` (closure under `zetaConjZero` and
   `zetaFeZero`, both PROVEN in-tree) would be four distinct points, all
   in `S(T0)` — contradicting the count. Hence `ρ.re = 1/2`.

Steps 1 and 3 are pure logic over the already-proven `ZeroSet` fields;
the entire remaining work is step 2.

## Step 2: what the count needs, audited against pinned Mathlib v4.33.1

**Available in the pinned build (read-only infrastructure):**

- `MeromorphicOn.circleAverage_log_norm` (Jensen's formula,
  `Mathlib/Analysis/Complex/JensenFormula.lean`) — the circular mean of
  `log‖f‖` in terms of the zeros/poles inside the disk; the exact
  counting statement to be audited in Phase 0.
- `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable` and
  `circleIntegral_div_sub_of_differentiable_on_off_countable`
  (`Mathlib/Analysis/Complex/CauchyIntegral.lean`) — circular-contour
  residue/winding counts; the circular argument principle is likely
  buildable from these in a few local lemmas.
- Full `Complex` contour-integration machinery, `Complex.Gamma`,
  `riemannZeta_eq_mul_completedRiemannZeta₀`,
  `completedRiemannZeta₀_one_sub`, `Complex.cpow_conj`,
  `Gamma_ne_zero`, Dirichlet-series convergence lemmas
  (`Mathlib/NumberTheory/LSeries/Dirichlet.lean`).

**NOT in the pinned build (grepped, empty):**

- No rectangular argument principle (no `argument_principle` at all).
- No Riemann-Siegel formula (no `riemannSiegel` / `Zfun` / theta
  function machinery in `Mathlib/Analysis/SpecialFunctions` or
  `NumberTheory`).
- No residue/meromorphic-zeros file of its own (Jensen is the
  counting home).

**Consequence — the count goes through a DISK, not a rectangle.**
The classical rectangle `[0,1] × [0,T0]` has no argument principle
available. Instead: center a disk on the critical line,
`D := disk (1/2 + (T0/2)·I) R` with `R := sqrt(1/4 + (T0/2)²) + δ`
(δ a small explicit slack). Then:

- `D` contains the whole strip slice `{0 < ρ.re < 1 ∧ |ρ.im| < T0}`
  (worst case: a corner of the strip rectangle, distance
  `sqrt(1/4 + (T0/2)²)` from the center).
- Every non-real zero with `|ρ.im| < T0` is in the strip by step 1,
  hence in `D`.
- The NEXT actual zero (the second critical-line zero,
  `1/2 + 21.0220i`) sits at distance `≈ 13.95` from the center while
  `R ≈ 7.09 + δ` — so the disk isolates the strip slice PROVIDED no
  hypothetical off-line zero with `T0 < ρ.im ≤ R_im_max` sneaks in;
  the boundary annulus `T0 < ρ.im ≤ R + something` is handled by an
  explicit zero-free-band assertion (below).

**The three numerical assertions (all bounded, all in exact/interval
arithmetic in Lean):**

- **(N1) Disk count.** The zero-count of `ζ` inside `D` (via Jensen or
  the circular argument principle) is EXACTLY 1. The circular mean of
  `log‖ζ‖` (or the winding of `ζ' / ζ`) is evaluated from an EXPLICIT
  formula for `ζ`: on the circle of radius `≈ 7.09` around
  `1/2 + 7.07·I`, every point has `Re s ∈ (-6.59, 7.59)` — the part
  with `Re s > 1` is evaluated by the absolutely convergent Dirichlet
  series with a tail bound; the part with `Re s < 1` is transported by
  the completed functional equation to `1 - s̄`-side points where the
  series converges; the Gamma/cpow factors are bounded by explicit
  Gamma estimates (to be derived locally — another local-lemma
  project, pattern of the ZetaConcrete Mellin work).
- **(N2) Boundary separation.** No zero on the circle `‖s - c‖ = R`
  (sharp `R`): an explicit `|ζ(s)| ≥ m > 0` on the circle.
- **(N3) Annulus nonvanishing.** No zero in
  `{s | 0 < s.re < 1 ∧ T0 < s.im ≤ R_im}` (the thin band above `T0`
  reached by the disk): explicit `|ζ(s)| ≥ m' > 0` there.
  (N1 + N2 + N3 together give `#S(T0) = 1`: every strip zero is in D;
  D contains exactly one zero; the band above T0 is empty; hence the
  single zero of D is the strip zero.)

**Work breakdown (phases, each ending in a green commit):**

- **Phase 0 — exact statement audit.** Read the exact pinned statements
  of `MeromorphicOn.circleAverage_log_norm`,
  `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable`,
  `circleIntegral_div_sub_of_differentiable_on_off_countable`; pin down
  which one yields an EXACT integer count for ζ (entire, so no pole
  bookkeeping) and what hypotheses (differentiability on the disk,
  off-countable zero set, no boundary zeros) must be supplied. Output:
  a one-page ledger of the exact lemmas + a local `countZerosDisk`
  statement.
- **Phase 1 — explicit ζ evaluation engine.** Local lemmas:
  `zetaDirichletTail (s, N) : |ζ s - Σ_{n≤N} n^{-s}| ≤ B(s,N)` with
  `B` an explicit closed-form bound for `Re s ≥ 1 + ε`; the
  functional-equation transport lemma (value at `s` from value-side at
  `1-s` with the completed factors); explicit bounds for
  `|Complex.Gamma (s/2 + 1)|` and `|π ^ (-s/2)|` on the explicit
  compact region (log-Gamma bounds derived locally).
- **Phase 2 — the count (N1) + boundary (N2).** Assembled from Phase 0
  + Phase 1; the circular-mean integral computed as a finite
  sum-of-arcs with each arc bounded by the Phase 1 engine; all
  constants exact rationals / `norm_num`.
- **Phase 3 — the band (N3).** `|ζ(s)| ≥ m'` on the thin band by the
  same engine (the band has `Re s ∈ (0,1)`, so the functional-equation
  side is used throughout; a finite arc decomposition again).
- **Phase 4 — assembly.** `zetaSliceOneT0 : #S(T0) = 1`; the orbit
  argument; `honlineT0 : ∀ ρ ∈ qz.Z, 0 < |ρ.im| ∧ |ρ.im| < T0 → ρ.re = 1/2`;
  plug into `ZetaConcrete.rh_program78_qz_continuumAnchor_PT2`,
  removing `honline` from the named inputs. Residual gap: three named
  components (`hzF`, `hPT2`, `hOffC`).

**Honest risk assessment.**

- The count is a DISK count via Jensen/circular argument principle, NOT
  the textbook rectangle — the annulus separation (N3) is the price and
  is a genuine (but bounded) numerical assertion.
- If `circleAverage_log_norm` in the pinned build does NOT yield an
  exact integer (e.g. it is stated with a limit, or requires the
  function to be nonvanishing on the boundary up to an `ae` clause that
  the numerical bounds do not satisfy), Phase 0 may force building the
  circular argument principle locally from
  `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable` —
  estimated local-lemma cost: modest (the heavy analytic work is in
  Phase 1 anyway).
- Phases 1–3 are bounded but real: expect on the order of 500–1500
  lines of Lean across a handful of modules. No new axioms; no RH
  claim at any phase; every phase commits green or not at all.
- Nothing in this project touches the terminal face (`hOffC`) — that
  remains the named open research object.

## Phase 0 — exact statement audit (DONE, ledger below)

**A1. Jensen's formula (exact, usable).** Pinned
`Mathlib/Analysis/Complex/JensenFormula.lean`,
`MeromorphicOn.circleAverage_log_norm {c} {R} {f}` (`hR : R ≠ 0`,
`h₁f : MeromorphicOn f (closedBall c |R|)`):
```
circleAverage (log ‖f ·‖) c R
  = ∑ᶠ u, divisor f (closedBall c |R|) u * log (R * ‖c - u‖⁻¹)
    + divisor f (closedBall c |R|) c * log R
    + log ‖meromorphicTrailingCoeffAt f c‖
```
For `f = riemannZeta` (entire; `ζ c ≠ 0` at the center — a Phase 1
numerical assertion) this is exactly
circular mean of `log ‖ζ ·‖` = `log ‖ζ c‖` + Σ over zeros `u` in the
closed disk of `order(u) · log(R / ‖c - u‖)`. Since every zero in the
disk satisfies `‖c - u‖ ≤ R`, every summand is `≥ 0`, so
`A := circleAverage (log ‖ζ ·‖) c R - log ‖ζ c‖` upper-bounds the
total zero order inside the disk: **total order ≤ ⌊A⌋ whenever A is
computed rigorously with an error band not crossing an integer**.
Combined with a separate existence assertion (one zero inside, via a
rigorous sign change of the Z-function in `(14, 14.2)` — a bounded
numerical assertion of the Phase 1 engine), the count is exactly one.
The analytic specialization `AnalyticOnNhd.circleAverage_log_norm`
(`h₂f : f c ≠ 0`) is also available.

**A2. Circular Cauchy integral formula (exact, usable).** Pinned
`Mathlib/Analysis/Complex/CauchyIntegral.lean`,
`circleIntegral_div_sub_of_differentiable_on_off_countable` (`s`
countable, `w ∈ ball c R`, `f` continuous on the closed ball,
differentiable on the open ball off `s`):
```
(∮ z in C(c, R), f z / (z - w)) = 2 * π * I * f w
```
The circular argument principle (winding of `ζ'/ζ` over the circle =
total zero order inside, when ζ is zero-free on the circle) is a
LOCAL derivation from this plus the local logarithmic-derivative
residue fact `ζ'/ζ ~ order/(s - u)` near a zero of given order
(standard, short, to be written as a local lemma). Estimated local
lemma cost: modest.

**A3. Euler–Maclaurin: NOT in the pinned build** (grep across
`Mathlib/` empty). If the Riemann–Siegel engine is chosen for the
`0 < Re s ≤ 1` band, an explicit-remainder Euler–Maclaurin must be
derived locally (Bernoulli-polynomial form, classical).

**A4. Riemann–Siegel: NOT in the pinned build** (no
`riemannSiegel` / `Zfun` / theta machinery anywhere in `Mathlib`).

**Engine decision (open, Phase 1 input).** Two self-contained
candidates for rigorous ζ-evaluation in the band `0 < Re s ≤ 1`,
`t ∈ (0, 30)`:
- **(E-1) Euler-transformed eta series:** `ζ(s) = η(s) / (1 - 2^{1-s})`
  with `η(s) = Σ (-1)^{n-1} n^{-s}` (convergent for `Re s > 0`,
  alternating with decreasing magnitudes) pushed through Euler's
  series transformation — the difference terms `Δ^k (n ↦ n^{-s})` are
  explicit finite sums and decay geometrically; the remainder is a
  classical explicit bound. Uniform estimates, no asymptotics.
- **(E-2) Riemann–Siegel formula:** derived locally from the
  functional equation + truncated Dirichlet sum + local Euler–Maclaurin
  (A3); at `t ≤ 30` the main sum has ≤ ~16 terms; the remainder
  estimate is delicate but classical.
Leaning (E-1) for formalizability (uniform, non-asymptotic bounds,
no special-function estimates); (E-2) as fallback if (E-1)'s
difference-term control proves awkward. Both are classical
mathematics; neither imports any external proof artifact.

## Independence-protocol note

Small-height zero counting (Riemann 1859; modern rigorous small-T
computations) is classical mathematics. This project derives its own
explicit bounds and constants from the pinned Mathlib infrastructure;
no external proof artifact, constant, or record is used as input, per
the standing protocol (day-024 adjudication).
