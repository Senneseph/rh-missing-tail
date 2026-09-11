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
| `RhAttack/B3.lean` | **P6 / P7** — the bridge + finite Abel/IBP machinery | ζ-free bridge core: `b3ResidualDecomp` (bridge Ψ vs kernel K differ **exactly** by exp(Tt − Σ_T ln F)), `b3Abel` (finite exact Abel decomposition, counting step N_L), `b3Bridge` (smooth RVM comparator N = NHat + S), §2 NHat/fT derivatives, §5 S-bound integrands P011/Q029/R229, §6 continuity + IBP (`nHatIBP`). | **WIP** — atomic repair in progress (48→30 at last run, day-014/15); **not** imported until green; no claim |
| `RhAttack/EulerAction.lean` | supporting exact identity | `eulerAction`: the Euler-action / Abel-summation identity, exact in **every commutative ring** (pure finite algebra; the machine-checked engine behind E7a). | **GREEN** |
| `RhAttack/E7a.lean` | supporting (data provenance) | The five certified oracle instances of the Euler action, ported (exact-ℤ data via `#eval`; float64 LHS pipeline vs the dps-20 Python record). | **GREEN** (5/5 via `Main.lean`) |

### The harness

| File | What it is | Status |
|---|---|---|
| `Main.lean` | The executable **`rhattack`** — runtime cross-check gate: E7a 5/5, B-4 16/16, B-5 12/12 (Lean float64 vs Python oracle records). A red gate is structurally impossible to misread. | **GREEN** |
| `RhAttack.lean` | Library root — imports the green pieces. `RhAttack.B3` is deliberately **not** imported until green (one line, then). | **GREEN** |

### Test files (recipe locks before porting into B3)

| File | What it is |
|---|---|
| `Bt2.lean` | B-3 §2 derivative recipe (NHat_deriv / fT_deriv): surface-`have` → `lift` transport → `congr_deriv` scalar bridge; canonical-atom discipline. |
| `Bt5.lean` | B-3 §5 antiderivative derivatives for the S-bound kernel integrands P011 / Q029 / R229 (Platt–Trudgian 0.110 / 0.290 / 2.290). |
| `Bt6.lean` | Atomic probes for B3 §4.4/§5 continuity rewrites (ContinuousAt chains, the =ᶠ[𝓝x] bridge, List ∑/∏, NList simp behavior). |
| `BtF.lean` | `B3Float` — float64 pair-kernel layer F, Fp for the B-3 bridge (not green until the B-3 float cross-check lands). |
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

Expected: **E7a 5/5 + B-4 16/16 + B-5 12/12 CROSS-CHECK PASS**, worst
deviations ~1e-13 scale (a transcription error would show ~1e-12·O(1)).
`lake build` compiles the green set; `RhAttack/B3.lean` is checked
individually (`lake env lean RhAttack/B3.lean`) until it goes green and
joins the library root.

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
