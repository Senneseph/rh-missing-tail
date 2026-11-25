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

## Phase status (milestones, in order)

- **Phase 1a (strip)** — DONE: `ZetaConcrete.zetaNontrivialInStrip`
  (`0 < ρ.re < 1` for every non-real zero).
- **Phase 1b (right-side explicit engine)** — DONE:
  `OnlineZeta.zetaDirichletTail` — for `1 < Re s` and `0 < N`,
  `‖ζ s − Σ_{n ≤ N} n^{−s}‖ ≤ N^{1−σ} / (σ − 1)` (explicit
  Dirichlet-series tail bound, locally derived; no such bound in the
  pinned build).
- **Phase 1c (left-side FE transport)** — DONE:
  `OnlineZetaFE.zetaFEtransport` + `OnlineZetaFE.zetaTailTransportLeft`
  — explicit bound for `‖ζ s‖` at `Re s < 0` via Mathlib's functional
  equation `ζ(1−s) = 2(2π)^{−s} Γ(s) cos(πs/2) ζ(s)`.
- **Phase 1c.1 (critical-line Gamma constants)** — DONE:
  `OnlineZetaGamma.gammaHalfItExact` —
  `‖Γ(1/2 + it)‖ = sqrt(π / cosh(π t))` (exactly, via Euler reflection
  + `Γ(conj s) = conj(Γ s)`), with decay corollary
  `gammaHalfItDecay`: `‖Γ(1/2 + it)‖ ≤ sqrt(2π) · e^{−π|t|/2}`.
  These are the constants the disk-count machinery uses to control the
  completed zeta factor on a circle about the first zero.
- **Phase 2 (in-strip explicit engine)** — IN PROGRESS. Done so far:
  `OnlineZetaEta.etaIdentity` — for `Re s > 1`,
  `η(s) = (1 − 2^{1−s}) · ζ(s)` with `η(s) = Σ (−1)^{n−1} n^{−s}`
  (even/odd split of the Dirichlet series, `tsum_even_add_odd`, local
  `cpowMulRealNonneg` product law for `x, y ≥ 0` real bases and complex
  exponent).
  **Phase 2.1 (conditional convergence on `0 < Re s`) — DONE:**
  `OnlineZetaEta2` (green, no `sorry`/`admit`/axioms) —
  `abelSummation` (finite Abel/partial-summation identity, pure algebra),
  `etaDiffBound` (mean-value bound
  `‖n^{−s} − (n+1)^{−s}‖ ≤ ‖s‖ · n^{−(Re s + 1)}` for `0 < Re s`, `0 < n`,
  via `HasDerivAt.cpow_const` + `norm_sub_le_integral_of_norm_deriv_le_of_le`),
  `etaTailBound` (`‖P_M − P_N‖ ≤ (2 + ‖s‖/Re s) · N^{−Re s}` for
  `1 ≤ N ≤ M`, by Abel decomposition + integral test via
  `AntitoneOn.summable_of_integrableOn_Ioi` and
  `AntitoneOn.tsum_comp_add_le_integral` with the local
  `OnlineZeta` rpow facts), and `etaPartialSumsCauchy` — the eta partial
  sums form a `CauchySeq` for `0 < Re s` (the conditional-convergence
  witness needed before any `tsum` is defined in the strip).
  **Phase 2.2a (strip eta function, sequential limit) — DONE:**
  `OnlineZetaEta3` (green, no `sorry`/`admit`/axioms) —
  `etaStrip (s : ℂ) : ℂ := if 0 < s.re then atTop.limUnder (fun N ↦ etaPartial s N)
  else 0` — the strip eta function as the SEQUENTIAL limit of the partial
  sums (for `Re s > 1` this agrees with the tsum `etaSeries`, see below).
  KEY FORMAL FINDING: for `0 < Re s ≤ 1` the eta series is NOT `Summable`
  in the Mathlib sense — `Summable`/`∑'` is the unconditional Finset-net
  notion, and Riemann's rearrangement theorem makes that net non-Cauchy
  for conditionally convergent series (thinning the positive terms past
  any `N₀` makes it diverge; at `s = 1/2` the odd-index partial sums grow
  like `(1/2)·ln N`). So the strip eta value must be the `limUnder` of the
  ordinal-indexed partial sums, not a `∑'` tsum. Consequences:
  (a) `etaStripTendsto` — convergence for `0 < Re s` via
  `CauchySeq.tendsto_limUnder`; (b) `etaStripAgreesEtaSeries` — for
  `Re s > 1` (absolute convergence) the sequential limit equals the tsum
  `etaSeries`, so the Phase 2.0 identity `etaIdentity` applies to
  `etaStrip` on `Re s > 1` (proved with `HasSum.tendsto_sum_nat`,
  `tendsto_atTop_atTop_of_monotone`, `Filter.Tendsto.limUnder_eq`,
  `HasSum.tsum_eq`); (c) `etaStrip_of_nonpos_re` — inert `else` branch.
  **Phase 2.2b (local uniform convergence on balls) — DONE:**
  `OnlineZetaEta3` (green) — `etaPartialSumsUniformCauchyOn` /
  `etaPartialSumsUniformOn`: for `0 < s₀.re`, the eta partial sums are
  uniformly Cauchy (hence converge uniformly) on
  `Metric.ball s₀ (s₀.re / 2)`, from `etaTailBound` with the radius bound
  `r < s.re` on the ball (`ballReStrict`).
  **Phase 2.2c (analyticity + strip identity) — DONE:**
  `OnlineZetaEta4` (green, no `sorry`/`admit`/axioms) —
  (a) `etaPartialDifferentiableOn` — each partial sum
  `etaPartial · N` is differentiable on `0 < Re s` (termwise, via
  `OnlineZetaEta2.etaTermDifferentiableOn` + `DifferentiableOn.fun_sum`);
  (b) `etaPartialTendstoLocallyUniformlyOn` + `etaStripDifferentiableOn`
  + `etaStripAnalyticOnNhd` — `etaStrip` is differentiable, hence
  analytic, on `U = {s : 0 < s.re, s ≠ 1}` (Weierstrass route via
  `TendstoLocallyUniformlyOn.differentiableOn` +
  `analyticOnNhd_iff_differentiableOn`);
  (c) `etaZetaFunAnalyticOnNhd` — `s ↦ (1 − 2^{1−s}) · ζ(s)` is analytic
  on `U` (`differentiable_twoPow` via `differentiable_const_cpow_of_neZero`,
  `analyticOn_riemannZeta` on `{1}ᶜ`, product rule);
  (d) `isPathConnected_reGEOneSdiffOne`,
  `isPathConnected_reBandSdiffOne`, `isPathConnected_isPreconnected`,
  `isPreconnected_U` — `U` is preconnected (straight segments from `2` in
  `{1 ≤ Re s}` and from `1/2` in the band `{0 < Re s ≤ 1}`, glued at
  `1 + i`, the segment arithmetic in `hleg` done in `re`/`im` coordinates
  with `field_simp` + `div_lt_one`/`one_lt_div`);
  (e) `etaFreqEq` — the identity holds frequently at `2` in `𝓝[≠] 2`
  (punctured-neighborhood filter, `NeBot` via `inf_eq_bot_iff` + a
  ball-point argument, `frequently_iff_neBot`);
  (f) **`etaIdentityStrip` — for `0 < Re s` and `s ≠ 1`,
  `etaStrip s = (1 − 2^{1−s}) · ζ(s)`** — the Phase 2.0 identity
  extended to the whole strip `0 < Re s` (except `s = 1`) by the identity
  theorem `AnalyticOnNhd.eqOn_of_preconnected_of_frequently_eq`.
  **Phase 2.3 (explicit evaluation/truncation half) — IN PROGRESS.**
  New module `formal/RhAttack/OnlineZetaEta5.lean` (committed GREEN at
  Sections 1–2; the full Section 3–4 draft is preserved at
  `tmp/OnlineZetaEta5-draft-sections34.lean` and is the immediate next
  work — see "Phase 2.3 handoff" below).

  **Section 1 (kernel + Mellin transform) — DONE, green:**
  `etaKernel t := 1/(e^t+1)`, `etaKernelC t := (etaKernel t : ℂ)`,
  `etaIntegral s := mellin etaKernelC s`.
  `etaKernel_continuousOn`, `etaKernel_locInt`,
  `etaKernel_Oexp : etaKernelC =O[atTop] exp(-·)`,
  `etaKernel_O1 : etaKernelC =O[𝓝[>] 0] const 1`,
  `etaIntegral_convergent` (Mellin convergence for `0 < Re s` via
  `mellinConvergent_of_isBigO_rpow_exp`),
  `etaIntegral_differentiableAt` (holomorphic at every `0 < Re s` via
  `mellin_differentiableAt_of_isBigO_rpow_exp`).

  **Section 2 (Laplace building block) — DONE, green:**
  `mellin_expNeg_eq_GammaIntegral` (`mellin (exp(-·)) s =
  Complex.GammaIntegral s`) and
  `laplace_n (s) (hs : 0 < s.re) (n) (hn : 0 < n) : ∫₀^∞ t^{s-1}
  e^{-nt} dt = Complex.Gamma s · (n:ℂ)^{-s}` (Mellin scaling
  `mellin_comp_mul_left` + `Complex.Gamma_eq_integral`).

  **Section 3 (Fubini step at `1 < Re s`) — DRAFTED, not yet green.**
  Target: `etaIntegral_eq_Gamma_etaSeries (h1 : 1 < s.re) : etaIntegral
  s = Complex.Gamma s · etaSeries s`. Draft components (all in the tmp
  draft file): `laplaceTerm`, `etaKernelCcpow_integrableOn_Ioi`,
  `tsumAltExp`, `laplaceTermNormIntegral`, `laplaceTermIntegral`,
  `laplaceTermNormSummable`, `etaIntegral_eq_Gamma_etaSeries` (Fubini
  via `integral_tsum`).

  **Section 4 (explicit truncation bound, all `0 < Re s`) — DRAFTED.**
  Target: `etaStripTruncationBound (hs : 0 < s.re) (N) (hN : 1 ≤ N) :
  ‖etaStrip s − etaPartial s N‖ ≤ (2 + ‖s‖/s.re) · (N:ℝ)^{-s.re}`
  (Phase 2.1 `etaTailBound` + `etaStripTendsto` + a limit-of-sequence
  ≤ eventual-bound argument via `Filter.eventually_atTop`).

  **Phase 2.3 handoff (exact error ledger at pause).** The draft failed
  its first full build with these localized errors (fixes identified):
  1. `Complex.GammaIntegral_convergent` takes `s` IMPLICIT: use
     `Complex.GammaIntegral_convergent hs`, not `(s hs)`.
  2. `tsum_smul` does NOT exist in this Mathlib. Use
     `Summable.tsum_mul_left (a) (hf : Summable f L) : ∑' i, a * f i =
     a * ∑' i, f i` (Mathlib/Topology/Algebra/InfiniteSum/Ring.lean:55)
     after a pointwise `smul_eq_mul` bridge, or `congr_arg (fun F =>
     ∑' n, F n)` + pointwise equality (no summability needed).
  3. The bare root name `AEStronglyMeasurable` fails elaboration; use
     `MeasureTheory.AEStronglyMeasurable` (or `open MeasureTheory`).
     `MeasurableOn` no longer exists in this Mathlib version — use
     `aestronglyMeasurable_indicator_iff` (root name, exposed) +
     `ContinuousOn.aestronglyMeasurable` (IntegrableOn.lean:760,
     restricted-measure form) for "continuous on the set" measurability.
  4. Verified usable lemmas: `summable_geometric_iff_norm_lt_one`,
     `tsum_geometric_of_norm_lt_one`, `tsum_add`, `tsum_zero`,
     `tsum_congr`, `tsum_coe_ne_top_iff_summable` (ENNReal),
     `summable_nat_rpow {p} : Summable (fun n => (n:ℝ)^p) ↔ p < -1`,
     `integral_rpow_mul_exp_neg_mul_rpow` (MeasureTheory/Integral/
     Gamma.lean: `∫₀^∞ x^q e^{-b x^p} = b^{-(q+1)/p} (1/p) Γ((q+1)/p)`
     with `0 < p`, `-1 < q`, `0 < b`), `Real.Gamma_eq_integral`,
     `integral_indicator`, `integral_const_mul`, `setIntegral_congr`,
     `IntegrableOn.congr_fun`, `HasFiniteIntegral.mono`,
     `norm_cpow_eq_rpow_re_of_pos`, `Real.norm_eq_abs`,
     `Real.cpow_neg`/`Complex.cpow_neg`, `Real.one_rpow`,
     `Complex.GammaIntegral_convergent` (both ℝ and ℂ forms),
     `Real.GammaIntegral_convergent`, `ContinuousOn.const_cpow`,
     `Tendsto.sub_const`, `Filter.eventually_atTop`,
     `abs_lt.mp`, `Complex.norm_add_le'`.
  5. `norm_cpow_ofNat` and `norm_cpow_eq_rpow_re_of_pos` verified for
     the norm identities; `Real.exp_neg_lt_one` for `e^{-t} < 1`.

  **Next session, in order:**
  1. Restore `OnlineZetaEta5.lean` from the green committed state (it
     already is — only Sections 1–2).
  2. Re-append Sections 3–4 from
     `tmp/OnlineZetaEta5-draft-sections34.lean` (everything after
     `/-! ## 3. The Fubini step`), applying fixes 1–2 from the ledger.
  3. Iterate `lake build RhAttack.OnlineZetaEta5` until green; then
     `lake build RhAttack` + `lake build` full.
  4. Delete any probe files; `grep -c "sorry\\|admit"` → 0;
     commit + push (house rule).
  5. Then: Phase 2.3.2 — the Euler-transformed series itself (Δ^k
     terms, 2^{-K} remainder) — or fold the truncation bound +
     Fubini identity into the Phase 3 disk-count plan (the scope's
     Phase 3 entry).

  After Phase 2.3 completes: **Phase 3 (disk count)** — Jensen
  circular mean with a rigorous error band not crossing an integer,
  plus a bounded numerical sign-change assertion in `(14, 14.2)` from
  the Phase 2 engine. Then **Assembly**: `#S(T0) = 1` + orbit argument
  (`ZetaConcrete.zetaSliceSubsingletonOnLine`) discharge `honline`.
- **Phase 3 (disk count)** — after Phase 2: Jensen circular mean with a
  rigorous error band not crossing an integer, plus a bounded numerical
  sign-change assertion in `(14, 14.2)` from the Phase 2 engine.
- **Assembly** — after Phase 3: `#S(T0) = 1` and the orbit argument
  (`ZetaConcrete.zetaSliceSubsingletonOnLine`) discharge `honline`.

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

**Engine decision (input to Phase 2).** Two self-contained
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
