# rh-lean — the RH-attack Lean package (Lean 4.33.1 + Mathlib, stable pin)

The machine-checked core of the kainos-logos RH-attack. This directory is the
**source of record** for the Lean artifacts (the kainos-logos
`scripts/rh-lean` path is a symlink into it).

The proof path this package serves is written for a human reader in
[`docs/RH-PROOF-OUTLINE.md`](../docs/RH-PROOF-OUTLINE.md) — read that first.
The outline's §9 names the pieces **P1–P8**; the file map below is the bridge
between those names and the files here. The internal project IDs
(`B0`–`B5`, `E7a`, …) are kept as *file names* for stability — journals,
verifier scripts, and import paths reference them by name.

**Toolchain (pinned, stable only):** `leanprover/lean4:v4.33.1` + mathlib
v4.33.1 (`lean-toolchain`). rc/nightly are banned (rc2 regressions burned a
session; see the day-012 journal).

## File map (outline piece → file)

### The proof pieces (`RhAttack/`)

| File | Outline piece | What it is | Status |
|---|---|---|---|
| `RhAttack/B0.lean` | **P1** — counting lemma | RH ⇔ D ≡ 0 over an abstract zero set (no ζ): `eqNtotMinusNon`, `nondec`, `offSliceEven`, `zeroD_of_RH` / `RH_of_zeroD` ⇒ `RH_iff_Dzero`. | **GREEN** (re-verified 2026-09-11) |
| `RhAttack/B4.lean` | **P2** — per-pair closed form | The zero-side kernel per conjugate pair: `pairClosedForm` (T1 exact), `pairLogAbs` (T2), `pairArgAngle` / `pairArLedger` (T3a/T3b phase), + `B4Float` 16-point cross-check. | **GREEN** |
| `RhAttack/B5.lean` | **P3** — deviation ratio | The off-line pair's effect on the kernel, exact: `b5Ratio` (closed form `pref·e^{sω_δ}`), `b5Abs`, `b5NoffPos`, `b5NoffIsPolynomial` (no δ-dead-window), `b5PrefSign`, + `B5Float` 12-config cross-check. | **GREEN** |
| `RhAttack/B3Core.lean` | **P6 / P7** — shared atoms | The B-3 atoms: `twoPiInv`, `nHat`, `NHat`, `Sbar`, `u`, `w`, `fT`, `fTp`, `Bf`, `Cf`, `Kbar`, §1/§2 derivatives (`lift`, `NHat_deriv`, `fT_deriv`), `fT_bound` / `fTp_bound` / `negLog1mY_le`. | **GREEN** |
| `RhAttack/B3Abel.lean` | **P7** — finite exact Abel decomposition | `NList` (counting step), the ray plumbing (`rayIntegrand`, `rayIntegrable`, `NListRayIntegrable`, `rayInt_eval`, `rayEndFormEq`), `b3Abel` (Σ_L f vs ∫ N_L f′ exact), §4.4 smooth comparators n̂/N̂ (`nHatContinuousOn` …) + the IBP bridge `nHatIBP`. | **GREEN** |
| `RhAttack/B3Sbar.lean` | **P5 / P6** — the S-bound kernel + remainder | Antiderivative primitives `P011` / `Q029` / `R229` (Platt–Trudgian 0.110 / 0.290 / 2.290) + `sqInv_deriv`, their derivatives, `Kbar_le` (∫ S̄/x³ ≤ K̄(G)), `b3BoundExplicit` (the explicit M(G,t) at finite B: `|Σ_L fT − ∫ nHat·fT| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G)`). | **GREEN** |
| `RhAttack/B3.lean` | **P6 / P7** — the bridge + the A/B gate | Composes the three pieces + `b3ResidualDecomp` (bridge Ψ vs kernel K differ **exactly** by exp(T − Σ_T ln F)) + §7 `B3Float`: the float64 mirror (exact finite Abel identity at the quadrature limit + the explicit bound) run by the gate. | **GREEN** — full build green; A/B gate PASS (day-016) |
| `RhAttack/P4Em.lean` | **P4** — atom-1: 1st-order EM (verbatim port) | The published Lean proof of the 1st-order Euler–Maclaurin formula (`B1` kernel, `sum_eq_integral_add_integral_deriv`), from Alex Kontorovich's `PrimeNumberTheoremAnd` (Apache 2.0; v4.32.2 → our 4.33.1 pin, body byte-identical, one documented linter option). Engine of the P4 second-order EM + remainder atoms (spec: `p4-tail-law-abstract.md`; P4 line in progress, day-017). | **GREEN** (atom-1 of the P4 line) |
| `RhAttack/P4Tail.lean` | **P4** — atom-2: per-period 2nd-order EM | The unit-period `B1·f′` identity `int_B1f'_period` (2nd-order remainder via the periodic `B2`, RCLike-𝕜 generic) + the `B2` periodic-remainder kernel and its integrability lemmas; the per-period engine that P4Em2 stitches. (spec §T3.) | **GREEN** (atom-2 of the P4 line) |
| `RhAttack/P4Em2.lean` | **P4** — atom-2b: global finite 2nd-order EM | `em2_finite`: ∑ Ioc f = ∫ f + ½(f m − f n) + (1/12)(f′ m − f′ n) − ½∫ B̂₂·f″ — the finite core of the Riemann 1859 identity (1859 continuation cited under the no-ζ convention; DLMF 25.2.12 cross-check, day-019). Built from P4Em + P4Tail + interval additivity + a local telescope (`ico_sum_telescope`). | **GREEN** (atom-2b of the P4 line) |
| `RhAttack/P4Limit.lean` | **P4** — atoms L1–L5: the M→∞ passage | The derivative family for `f(x)=x^{−s}` (L1: `p4_f_hasDerivAt`, `p4_f1_hasDerivAt`, `p4_f2_hasDerivAt`, `p4_f1_at`, `p4_f2_at`, `p4_f1_on_Icc`, `p4_f2_on_Icc`), the exact finite law for `x^{−s}` (L2: `p4_integral_closed` antiderivative `x^{1−s}/(1−s)`, `p4_finite_em2` every endpoint + the `B2` remainder explicit), and the M→∞ passage (L3, Gamma-template method: `p4_f2_abs_eq` + `p4_f2_continuousOn_Ioi` + `p4_f2_integrableOn_Ioi` absolute convergence of the bare f″ tail, `p4_f2_integral_Ioi_eq` closed value `s·c^{−s−1}` via pinned `integral_Ioi_cpow_of_lt`, `p4_kernel_integrableOn_Ioi` the B̂₂-kernel tail dominated by `|B2|≤1/6`, and `p4_kernel_tendsto`/`p4_f2_tendsto` the verbatim `intervalIntegral_tendsto_integral_Ioi` M→∞ passage), and the missing-tail law (L4, IBP route: `p4_op2c_bound` — |∫ B̂₂ x·x^{−s−2}| ≤ √3/270·‖s+2‖·n^{−5/2} via two IBPs with the periodic `B3poly` (max |B3| = √3/36 at u=(3±√3)/6, computed) — plus `p4_f2_tail_bound` — ‖∫ f̂″_{≥n}‖ ≤ ‖s(s+1)‖·√3/270·‖s+2‖·n^{−5/2} via factor extraction + FTC for `n^{−7/2}` + `le_of_tendsto`). L5 (P4 statement + T4 bound `B_n(t)`) assembles downstream. | **GREEN** (L1-L5 of the P4 line: L5 = `p4_Tn_Tendsto` / `p4_zeta_split` / `p4_Tn_eq` / `p4_identity` / `p4_T4_bound` / `p4_T4_ratio`; the Re s = 1/2 W_n-equality is cited per DLMF 25.2.8, see the file header) |
| `RhAttack/P8Floor.lean` | **P8** — the residual-floor line (Route A, definition side alone) | A0+A1: `p4_Wn` (the definition-side W_n) + `p8_same_object` (same-object reduction) + `p8_triangle` (via `norm_sub_le`). A2a: `p8_B` (the three-term floor at s = ½+it) + `p8_B_floor` (instantiation of `p4_T4_bound`). A2b: `p8_residual_exact` (factored bridge residual, via `B3.b3ResidualDecomp`), `p8_abs_exp_sub_one_le` (|e^x−1| ≤ e^\|x\|·\|x\|, both-sign analysis, no MVT), `p8_residual_bound` (the residual = product mass × a function of the ONE model-defect x = Tt − Σ_T ln F; zeta-free, no counting). A3: `p8_noff_delta_min` (the B5 off-line numerator is δ-monotone, no dead δ window), `p8_detector_abs_lower` (reverse triangle → the B5 closed magnitude), `p8_pref_omega_zero` + `p8_detector_norm_at_zero` (the δ = 0 exact closed forms: pref = (γ²−t²)/(¼+γ²), ω₀ = 1/(¼+γ²), ‖R(0)‖ = \|γ²−t²\|/(¼+γ²)·e^{ω₀/2}). A4.1: `p8_far_detector_mag_ge_two` (‖R(γ,0,t)‖ ≥ 2 for γ ≥ 1, t ≥ 2γ) + `p8_far_detector_scale_ge_one` (‖R−1‖ ≥ 1 in the far regime — the zero-decision reduces to floor + residual < 1). A4.2: `p8_f_near_pin` (0.9975, the PINNED near-regime floor, day-017/019 audit) + `p8_f_far_floor` (1, LEAN-PROVEN) + `p8_zero_decision_far` (the outline §10 decision inequality, far form). A4.3: `p8_residual_wired` — the M(G,t) wire: the residual absorbs |x| ≤ Xval (Xval = the B3Sbar `b3BoundExplicit` output at the measurement point) into mass·e^Xval·Xval. **MODULE COMPLETE (A0–A4).** The W_n = EM-expression equality at Re s = ½ is **CITED** (DLMF 25.2.8 / Apostol 12.21); the near-regime detector floor is **PINNED** (day-017/019 audit). | **GREEN** (A0, A1, A2a, A2b, A3.1, A3.2a, A3.2b.1, A4.1, A4.2, A4.3 — one green commit per atom) |
| `RhAttack/Closure.lean` | **P9** — the closure (outline §8: floor vs detector → no off-line pair) | Pins: `p9_f_pin` (0.9975, the PINNED near-regime detector floor, day-010 d4d3 audit), `p9_d_min` (0.005, the measured d-grid edge — Route A's price), `p9_margin_min` (112.6, the day-020 worstcase audit minimum margin) + `p9_m_pin` (= 1/112.6). C1-far: `p9_far_detector_ge_pin` (far regime ‖R(γ,0,t)−1‖ ≥ f_pin, restated from P8Floor A4.1b). C5: `p9_point_contradiction` (the arithmetic squeeze: Q ≥ dev − Mf with dev ≥ flo and Q ≤ Bfloor + Mr with Bfloor + Mr + Mf < flo — empty). C0: `p9_min_offline_height` (over B0's ZeroSet: if an off-line zero exists, a MINIMUM positive off-line pair height t0 exists — structural HNR/HCJ/HFIN only, no counting value; the finite-slice Finset.image-height-minimum via `isLeast_min'`). C5b: `p9_closure_rh_of_margin` (the §8 conditional closure: RH fails ⇒ off-line zero ⇒ minimal pair (t0, d0) ⇒ squeezed margin at (t0, d0) ⇒ the C5 contradiction ⇒ RH; the margin hypothesis hmargin is EXPLICIT — its real witnesses are the pinned/cited measurement constants: Mf = the b3BoundExplicit wire at the Xval pin, flo = the detector floor, Bfloor+Mr = the P8Floor A4 composition). **MODULE COMPLETE — the §8 conditional closure.** The C1b own-regime (branch-locus) detector-floor promotion is the open analysis atom. | **GREEN** (pins, C1-far, C5, C0, C5b — no sorry) |
| `RhAttack/EulerAction.lean` | supporting exact identity | `eulerAction`: the Euler-action / Abel-summation identity, exact in **every commutative ring** (pure finite algebra; the machine-checked engine behind E7a). | **GREEN** |
| `RhAttack/E7a.lean` | supporting (data provenance) | The five certified oracle instances of the Euler action, ported (exact-ℤ data via `#eval`; float64 LHS pipeline vs the dps-20 Python record). | **GREEN** (5/5 via `Main.lean`) |

### The harness

| File | What it is | Status |
|---|---|---|
| `Main.lean` | The executable **`rhattack`** — runtime cross-check gate: E7a 5/5, B-4 16/16, B-5 12/12, B-3 A/B gate (Lean float64 vs the machine-checked theorems + Python oracle records). A red gate is structurally impossible to misread. | **GREEN** |
| `RhAttack.lean` | Library root — imports all the pieces, **including `RhAttack.B3`** (day-016; the split pieces are green) and the P4 line **`RhAttack.P4Em` / `P4Tail` / `P4Em2` / `P4Limit`** (days 017–019) and the P8 residual floor **`RhAttack.P8Floor`** + the P9 closure **`RhAttack.Closure`** (day 020). | **GREEN** |

### Test files (recipe locks before porting into B3)

| File | What it is |
|---|---|
| `Bt2.lean` | B-3 §2 derivative recipe (NHat_deriv / fT_deriv): surface-`have` → `lift` transport → `congr_deriv` scalar bridge; canonical-atom discipline. |
| `Bt5.lean` | B-3 §5 antiderivative derivatives for the S-bound kernel integrands P011 / Q029 / R229 (Platt–Trudgian 0.110 / 0.290 / 2.290). |
| `Bt6.lean` | Atomic probes for B3 §4.4/§5 continuity rewrites (ContinuousAt chains, the =ᶠ[𝓝x] bridge, List ∑/∏, NList simp behavior). |
| `BtF.lean` | `B3Float` — the float64 pair-kernel layer F, Fp for the B-3 bridge (now wired into `Main.lean` as the B-3 A/B gate, day-016; the production layer lives in `B3.lean` §7). |
| `BtL.lean` | `lift` — HasDerivAt transport through function equality (ported into B3 §2) + canonical-atom goals. |

### API pin probes (`Probe*.lean`, days 013–15)

One-shot instruments: each probes a mathlib fact or tactic behavior in this
pinned 4.33.1, is run to green, and its recipe is ported into `B3.lean` / the
test files. They keep the "no guess-iterate" rule auditable — every syntax
form used in the B-3 repair has a probe behind it.

| File | Pins |
|---|---|
| `ProbeA` | `.abs` composition of continuity; `log` monotone; `¬a<b ⇒ b≤a` |
| `ProbeB` | ray value, cases p1 (c ≤ a) / p2 (a < c < b) |
| `ProbeC` | `derivIntegrableCont` + p8/p9 |
| `ProbeD` | rayInt_eval v1/v2 (c < b branch) |
| `ProbeE` | rayInt_eval v3/v4 (c ≤ a branch) |
| `ProbeF` | IntervalIntegrable ↔ IntegrableOn (Ioc/Icc), tiny pins |
| `ProbeG` | IntegrableOn over uIoc; IntervalIntegrable add; abs/nlinarith |
| `ProbeH` | ContinuousAt through affine maps; membership lemmas |
| `ProbeI` | `eq_sub_of_add_eq`; one-way div forms (calc) |
| `ProbeJ` | EqOn with implicit point; `integral_const` smul target |
| `ProbeK` | EqOn dot-apply; `integral_const` → `(1-y)⁻¹` smul |
| `ProbeK2` | 2-point abs via `abs_add_le` + `abs_neg` (no 2-arg `abs_sub` here) |
| `ProbeK3` | `not_le.mp` / `not_lt.mp`; rayEndFormEq Strategy A |
| `ProbeK4` | `hf'cont (x := x) hx \|>.abs` green; htarget smul green; single-expression comp **failed**; 4-arg `sub_div` **failed** (true signature 3-arg) |
| `ProbeK5` | **named-arg** `ContinuousAt.comp (g := log) …` green (the hmid fix); `continuity` tactic **dead** for log∘mul; 3-arg `sub_div` green |
| `ProbeL` | `field_simp` + `ring_nf` closers (fTp_bound inverse-atom behavior) |
| `ProbeM` | NList cons-case: `rw [dif_pos hg]` **fails** (map-binder hygiene), `simp [hg]` closes — the proven recipe |
| `ProbeN`/`ProbeN2` | top-level decls keep their SHORT names across modules (the split of B3.lean into B3Core/B3Abel rests on this pin) |
| `ProbeN3` | `linarith` does **not** flip `¬(g<b)` to `b≤g`; `simp only [not_lt] at h` does (the rayEndFormEq g=b branch) |
| `ProbeN4` | the g=b derivation menu under the split_ifs context (all alternatives pinned) |
| `ProbeN5` | `-e ≤ 0` goals: `.neg_le` field **invalid** in 4.33.1; `positivity` **refuses** the form; `div_le_iff₀` + `norm_num` closes (the Kbar_le hRn fix) |
| `ProbeN6` | calc-step justifications: SAME-LINE tactic or `by { }` block only (bare `:= by` + next-line leaks into calc-continuation parse); `field_simp` auto-closes; `positivity` sees `0 ≤ 2·x³` where `nlinarith [hx0]` does not |
| `ProbeN7` | building `=ᶠ[𝓝[s] x]`: set-pointwise `simpa using hfg` **fails**; `EventuallyEq.of_eq` from full equality works (`nhdsWithin x s` long form) |
| `ProbeN8` | `continuity` (aesop) **cannot** close `z^3` / `c / z^3` at a point (all 3 forms red); explicit `.mul`/`.congr`/`ContinuousAt.div` + `.continuousWithinAt` is the green route (the B3Sbar hInv3 fix) |

### References & toolchain

| Path | What it is |
|---|---|
| (kainos-logos) `references/LEAN4-4331-QUICKREF.md` | The pinned-API quick reference this repair runs on (pinned facts, exact file:line sources). Lives in the **kainos-logos** working repo, not in this public one. |
| (reproducible) `.lake/packages/mathlib` | Working mathlib source for the "no guess — read the pinned source" discipline: the gitignored lake cache, reproduced exactly by the `lean-toolchain` pin below (Lean core likewise comes from the toolchain install — no copies are kept in this repo). |
| (kainos-logos) `references/official-lean4-docs/` | The official Lean 4 reference (tactic language, tactic reference, proofs chapter) + book chapters, `curl`-pinned as text. Lives in the **kainos-logos** working repo (gitignored local references), not in this public one. |
| `lean-toolchain` | `leanprover/lean4:v4.33.1` (stable pin). |
| `lakefile.toml` | Package `rhattack` (lib + exe). |

## Reproduce from scratch (fresh machine)

```sh
# 1. toolchain (https://www.lean-lang.org): installs elan + lean + lake
#    (in this environment elan.leanlang.org was unreachable — install
#    elan manually from its GitHub release, then `elan-init -y`.)
# 2. build (fetches the prebuilt Mathlib cache from the community store)
lake build
# 3. run the cross-check gate
lake exe rhattack
```

Expected: **E7a 5/5 + B-4 16/16 + B-5 12/12 + B-3 CROSS-CHECK PASS**, worst
deviations ~1e-13 scale (a transcription error would show ~1e-12·O(1)); the
B-3 gate reports the Abel rel-err, the explicit-bound margin (must be > 0),
and the quadrature self-check.
`lake build` compiles the whole package (all pieces, including B-3, green —
day-016).

## Provenance (no recall — every number traces)

- Proof path (human-readable): `../docs/RH-PROOF-OUTLINE.md` (byte-identical
  twin of `plan/40-prize-islands/rh-attack/RH-PROOF-OUTLINE.md`).
- Formula ledger: `plan/40-prize-islands/rh-attack/FORMULAS.md` (E7b block:
  per-pair closed form; §2.1: Euler action).
- Python oracle records (the cross-check targets): `../rh/out_day006_euler_action_identity.txt`
  (dps-50), `../rh/out_day011_e7a_oracle20.txt` (dps-20 port values),
  `../rh/out_day010_pair_unit.txt` (B-4 16 points),
  `../rh/out_day010_b5core_check.txt` (B-5 dps-30).
- Toolchain discipline: pinned stable 4.33.1 + mathlib 4.33.1 — no rc.

*Owner-conceived project, AI co-developed instruments (disclosed); no prize
claim (see the project README in the kainos-logos plan directory).*
