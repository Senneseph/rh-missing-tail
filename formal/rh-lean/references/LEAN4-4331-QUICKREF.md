# Lean 4.33.1 + Mathlib 4.33.1 — QUICK REFERENCE (B-3 and beyond)

Compiled 2026-09-14 from this session's verified lookups (compiler-confirmed probes at
`scripts/rh-lean` and literal reads of the pinned sources). **STOP re-looking-up: this file
is the reference. If in doubt, read the LITERAL CODE in the repos linked below — do not
probe or fetch again.**

## 0. Ground-truth sources (all local)
| Thing | Path |
|---|---|
| Mathlib 4.33.1 full source (7.5G w/ build) | `../.lake/packages/mathlib/` (symlink here as `references/mathlib-4.33.1`) |
| Lean core 4.33.1 source (git clone, tag `v4.33.1`) | `references/lean4-core-4.33.1/` (esp. `src/Init/Data/List/*.lean`, `src/Init/Data/Float/*.lean`) |
| Toolchain | elan `leanprover/lean4:v4.33.1` (stable), PATH needs `$HOME/.elan/bin` |
| Green reference files (working patterns) | `RhAttack/E7a.lean` `RhAttack/B0.lean` `RhAttack/B4.lean` `RhAttack/B5.lean` |
| Compiler is ground truth | `lake env lean <file>` for parse + `#check` (fast, Mathlib o-files cached); `lake build` for full |

## 1. Parser / file-structure rules (4.33.1)
- **A docstring `/-/ ... -/` may only immediately precede a DECLARATION** (def/theorem/lemma/axiom/...).
  Attaching it to `namespace`/`section`/`open`/`import` → **`error: unexpected token 'namespace'; expected 'lemma'`**.
  (B4.lean does this: comment header is a PLAIN `/- ... -/`; the `/-/` doc attaches to the first decl.)
- **Bare `end` is rejected**: `error: Missing name after 'end': Expected the current scope name 'B3'`.
  Use `end B3`, `end B3Float`, etc. (lint `linter.style.missingEnd` on).
- `set_option maxErrors 500` must be OUTSIDE comments (a line inside `/- -/` is inert text).
- `set_option linter.style.header false` + `linter.style.longLine false` used at file tops.
- `open Real Set MeasureTheory` — **MeasureTheory is required** for: `volume`,
  `IntervalIntegrable`, `IntegrableOn`, `integrableOn_const`, `restrict_Ioo_eq_restrict_Ioc`,
  `NullSingletonClass`, `measurableSet_*` are root but `measure`-space ids live there.

## 2. Core `List` API (lean4 tag v4.33.1 — `src/Init/Data/List/`)
- `sum`/`prod` are **foldr-based**; cons lemmas are `rfl` + `@[simp, grind =]`:
  - `List.sum_cons : (a::l).sum = a + l.sum`  (Basic.lean:2073)
  - `List.prod_cons : (a::l).prod = a * l.prod` (Basic.lean:2087)
  - `List.foldr_cons : (a::l).foldr f b = f a (l.foldr f b)` (Lemmas)
  - Also present: `sum_nil/prod_nil/sum_append/prod_append/sum_singleton/prod_singleton/sum_reverse/prod_reverse`.
  - **NOT in core**: `List.sum_map`, `List.sum_filter`, `List.sum_sub` (Mathlib's `Group.List`
    layer has `sum_const_nat`, `prod_*` hom lemmas — see `Mathlib/Algebra/BigOperators/Group/List/Basic.lean`).
- Membership (all in Lemmas.lean, verified verbatim):
  - `List.mem_cons : a ∈ b::l ↔ a = b ∨ a ∈ l` (`@[simp]`)
  - `List.mem_cons_self {a l} : a ∈ a :: l`
  - `List.mem_cons_of_mem (y) {a} {l} : a ∈ l → a ∈ y :: l`
  - `List.mem_append : a ∈ s ++ t ↔ a ∈ s ∨ a ∈ t` (`@[simp]`)
  - `List.mem_append_left {a as} (bs) : a ∈ as → a ∈ as ++ bs` (Basic.lean:863)
  - `List.mem_append_right {b} (as) {bs} : b ∈ bs → b ∈ as ++ bs` (Basic.lean:869)
  - `List.forall_mem_cons`, `List.exists_mem_cons`, `append_of_mem`, `mem_iff_append`.
- `List.filter_cons_of_pos/of_neg` (`@[simp]`); `List.sort (isLt : α → α → Bool)` with `[DecidableEq α]`.
- List `mem` terms are written `.head ..` / `.tail _ h` directly (no `mem.head` names).

## 3. Deriv API (Mathlib `Analysis/Calculus/Deriv/`) — THE CRITICAL SECTION
### 3.1 Basics (Basic.lean) — section `id` has **explicit** `(s x L)` section vars
- `hasDerivAt_id : HasDerivAt id 1 x` — use as `hasDerivAt_id (x := x)`.
  **Its function is literally `id` — `ring`/`field_simp`/`simp` do NOT reduce `id x`** (observed:
  goal `x / (2*π) = id x * (1/(2*π))` is not closed by ring/field_simp, but
  `x / (2*π) = x * (1/(2*π))` IS closed by plain `ring` and by `field_simp`).
  → **Prefer `hasDerivAt_id' : HasDerivAt (fun x : 𝕜 => x) 1 x`** (same section; lambda surface β-reduces under simp/ring).
- `hasDerivAt_const : HasDerivAt (fun _ => c) 0 x` — **x and c are EXPLICIT**: write `hasDerivAt_const x c`.
- `@hasDerivAt_const` elaboration: `hasDerivAt_const x 1` → `HasDerivAt (fun _ => 1) 0 x`.
- `HasDerivAt.congr_deriv (h : HasDerivAt f f' x) (h' : f' = g') : HasDerivAt f g' x` (Basic.lean:602).
- No `HasDerivAt.congr` for the FUNCTION side — bridge function surfaces with an explicit equality
  (see recipe 3.4).

### 3.2 Arithmetic (Add.lean / Mul.lean / Inv.lean / Pow.lean)
- `HasDerivAt.add (hf) (hg) : HasDerivAt (f + g) (f' + g') x` (f+g = Pi pointwise sum).
- `HasDerivAt.sub (hf) (hg) : HasDerivAt (f - g) (f' - g') x`.
- `HasDerivAt.const_sub (c) (hf) : HasDerivAt (c - f) (-f') x`  (CONST ON LEFT — for `f - 1` use `HasDerivAt.sub hf (hasDerivAt_const x 1)`).
- `HasDerivAt.mul (hc) (hd) : HasDerivAt (c * d) (c' * d x + c x * d') x` (Mul.lean:266 — note the ORDER `c'·d x + c x·d'`).
- `HasDerivAt.mul_const (hc) (d) : HasDerivAt (fun y => c y * d) (c' * d) x` (Mul.lean:303).
- `HasDerivAt.const_mul (c) (hd) : HasDerivAt (fun y => c * d y) (c * d') x` (Mul.lean:355).
- `hasDerivAt_inv (x_ne_zero : x ≠ 0) : HasDerivAt (fun y => y⁻¹) (-(x ^ 2)⁻¹) x` (Inv.lean:55) —
  **derivative is `-(x^2)⁻¹`**: composed at inner value p = (h x) the outer deriv is `-((h x) ^ 2)⁻¹`,
  e.g. for h = (·)² at point x: `-((x*x)^2)⁻¹` (NOT `-(x*x)⁻¹`).
- `HasDerivAt.div (hc) (hd) (hx : d x ≠ 0) : HasDerivAt (c / d) ((c' * d x - c x * d') / d x ^ 2) x` (Inv.lean:173).
- `hasDerivAt_log (hx : x ≠ 0) : HasDerivAt log x⁻¹ x` (Log/Deriv.lean:52) — **derivative is `x⁻¹`, not `1/x`**
  (bridge `1/x = x⁻¹` in the scalar hde via `field_simp; ring`).
- `HasDerivAt.pow (h) (n : ℕ) : HasDerivAt (f ^ n) (n * f x ^ (n - 1) * f') x` (Pow.lean:109) —
  surface function is `f ^ n` (Pi power); n=2 at point x gives deriv `2 * f x ^ 1 * 1`… exact surface:
  `2 * ((fun z => z) x) ^ (2 - 1) * 1` when f = `hasDerivAt_id'`.

### 3.3 Composition (Comp.lean) — **x IS EXPLICIT** (source comment, ~line 44):
> "For composition lemmas, we put x explicit to help the elaborator, as otherwise Lean tends
> to get confused since there are too many possibilities for composition" — `variable {...} (x)`
- `HasDerivAt.comp (x : 𝕜) (hh₂ : HasDerivAt h₂ h₂' (h x)) (hh : HasDerivAt h h' x) :
    HasDerivAt (h₂ ∘ h) (h₂' * h') x` (Comp.lean:258)
  → **write `HasDerivAt.comp x hh₂ hh`** (bare two-arg form miselaborates: "expected ℝ").
  Surface function is `(h₂ ∘ h)`, deriv `(h₂' * h')` (h₂' first!).
- `HasDerivAt.comp_of_eq (x) (hh₂) (hh) (hy : y = h x)` (Comp.lean:269).
- `HasDerivAt.scomp` family for vector-in/scalar-out (not needed for B-3).

### 3.4 **THE VERIFIED SURFACE-BRIDGE RECIPE** (probe-green, 4.33.1)
Constructors produce UGLY surface terms (`id x`, `f ^ n`, `h₂ ∘ h`, `f + (fun _ => c)`,
scalar `c' * d x + c x * d'`). Never fight them with `convert` (meta-sorts in convert bullets break
`ring`/`field_simp` — "no progress" on perfectly good goals; congr also descends into HDiv/HMul
type-class constants producing garbage goals like `HDiv.hDiv = HMul.hMul`). The recipe:
```lean
have hfe : (fun z : ℝ => <SURFACE-F>) = (fun z : ℝ => <CLEAN-F>) := by ext z; field_simp [hne]; ring
  -- for composition surfaces: `by ext z; simp` (β-reduction closes it)
have hde : <SURFACE-D> = <CLEAN-D> := by field_simp [hne]; ring   -- scalar equality
have h : HasDerivAt (<CLEAN-F>) (<SURFACE-D>) x :=
  Eq.mpr hfe <CONSTRUCTOR-CHAIN>      -- Eq.mpr hfe : P SURF → P CLEAN
exact h.congr_deriv hde
```
- Give the `have h` an **EXPLICIT type** (guides elaboration; avoids `▸`/pipe on meta types —
  `|> .method` on a meta-typed term gives `Invalid field notation`).
- `Eq.mpr (he : A = B) : P A → P B`; direction: hfe : SURF = CLEAN, chain : P SURF ⇒ P CLEAN.
- NEVER put a function-equality into a `simpa`/`simp` lemma list (`simpa [hfe] using h` →
  "maximum recursion depth has been reached").
- `ext z; ring` works when both sides are ring-identical after β; `ext z; field_simp [hne]; ring`
  when division/π-denominators are involved (`hne : d ≠ 0` as a proper local `have`).
- Plain `ring` closes field identities in ℝ STANDALONE (e.g. `x/(2*π) = x*(1/(2*π))`) — it's the
  CONVERT-bullet meta-sorts, not ring, that break division goals.

### 3.5 Verified full theorems (ready to copy shapes from the probe history / ApiProbe3.lean)
- `hline`: `HasDerivAt (fun z => z/(2*π)) (1/(2*π)) x` via
  `(hasDerivAt_id' (x := x)).mul_const (1/(2*π))` + hfe/hde/congr_deriv.
- `log∘line`: `HasDerivAt (fun z => log (z/(2*π))) (1/x) x` via
  `HasDerivAt.comp x (hasDerivAt_log hpos.ne') hline` + hfe (`ext z; simp`) + hde
  (`(x/(2*π))⁻¹ * (1/(2*π)) = 1/x` by `field_simp; ring`).
- `sq`: `HasDerivAt (fun z => z*z) (2*x) x` via `(hasDerivAt_id' (x := x)).pow 2`,
  hfe `ext z; ring`, hde `2 * ((fun z => z) x) ^ (2 - 1) * 1 = 2*x` by `ring`.
- `inv∘sq`: `HasDerivAt (fun z => (z*z)⁻¹) (-(2*x)/(x*x)^2) x` via
  `HasDerivAt.comp x (hasDerivAt_inv (show x*x ≠ 0)) hsq`,
  hde `-((x*x)^2)⁻¹ * (2*x) = -(2*x)/(x*x)^2` by `field_simp; ring`.
- `1/x`: via `HasDerivAt.div (hasDerivAt_const x 1) (hasDerivAt_id' (x := x)) hx.ne'`,
  hde `0 * x - 1 * 1 = -(1/x^2)` by `ring`.
- `log z − 1`: via `HasDerivAt.sub hslog (hasDerivAt_const x 1)`, hfe `ext z; simp`, hde `1/x - 0 = 1/x`.
- `log z · z`: via `hslog.mul hid`, hfe `ext z; ring`, hde `(1/x)*x + log x * 1 = 1 + log x`.

## 4. Interval-integral API (`MeasureTheory/Integral/IntervalIntegral/`)
- Def: `∫ x in a..b, f x ∂μ` ≝ `∫ x in Ioc a b − ∫ x in Ioc b a` (`intervalIntegral`, Basic.lean:657).
- **FTC (the one to use)** — `integral_eq_sub_of_hasDerivAt` (FundThmCalculus.lean:1149):
  `(hderiv : ∀ x ∈ uIcc a b, HasDerivAt f (f' x) x) + (hint : IntervalIntegrable f' volume a b)
   ⟹ ∫ a..b, f' = f b − f a`.
  Pointwise→ae idiom for the hderiv (Mathlib's own, ContDiff.lean:34-46):
  ```lean
  intro x hx
  simpa [uIcc_of_le (le_of_lt h'ab)] using (pointwise HasDerivAt) x (by simpa using hx)
  ```
- `integral_add (hf) (hg)`, `integral_sub (hf) (hg)` (both take II args; Basic.lean ~785-792).
- `integral_congr_uIoo [NullSingletonClass μ] (h : (uIoo a b).EqOn f g)` (Basic.lean:1246) — FREE value congr on `∫ a..b`.
- `abs_integral_le_integral_abs (hab : a ≤ b)` (Basic.lean:1393).
- `integral_mono_on (h : ∀ x ∈ Icc a b, f x ≤ g x)` (Basic.lean:1432) and `integral_mono_on_of_le_Ioo` (1437) — implicit `[II f] [II g]` instances.
- `integral_mul_const (r) (f) : ∫ (f x * r) = (∫ f) * r` (Basic.lean:822); `integral_const_mul (r) (f) : ∫ (r * f x) = r * ∫ f` (817).
- `integral_add_adjacent_intervals` (1095).

### 4.1 Integrability combinators
- `IntervalIntegrable.congr_ae (hf) (h : f =ᵐ[μ.restrict (Ι a b)] g)` (Basic.lean:103)
  — note `Ι a b` (uIoc) is the natural domain; to move Ioo→Ioc: `rw [uIoc_of_le h, ← restrict_Ioo_eq_restrict_Ioc]` then
  `Set.EqOn.aeEq_restrict (fun x (hx : x ∈ Ioo a b) : A x = B x => by ring) measurableSet_Ioo`
  — `Set.EqOn.aeEq_restrict {μ s} (h : s.EqOn f g) (hs : MeasurableSet s) : f =ᵐ[μ.restrict s] g`
    (Measure/Restrict.lean:648, root `Set` namespace).
- `IntervalIntegrable.congr_uIoo [NullSingletonClass μ] (hf) (h : EqOn f g (uIoo a b))` (108).
- `IntervalIntegrable.add (hf) (hg)` (322), `.sub` (327), `.neg` (231), `.abs` (251), `.norm` (238), `.symm`, `.trans` (208).
- `intervalIntegrable_iff : II f μ a b ↔ IntegrableOn f (Ι a b) μ`; `IntervalIntegrable.def'`.
- `ContinuousOn.intervalIntegrable_of_Icc (h : a ≤ b) : ContinuousOn f (Icc a b) → II f volume a b` (Basic.lean:506).
- `integrableOn_const {C} (hs : μ s ≠ ∞)` default `by finiteness`; `IntegrableOn.congr_fun_ae (hf) (h : f =ᵐ[μ.restrict s] g)` (IntegrableOn.lean:147); `IntegrableOn.add/sub/neg` (266-276).
- `restrict_Ioo_eq_restrict_Ioc : μ.restrict (Ioo a b) = μ.restrict (Ioc a b)` (Measure/Typeclasses/NullSingletonClass.lean:137, **MeasureTheory namespace**).

### 4.2 Unordered intervals (Order/Interval/Set/UnorderedInterval.lean)
- `uIoo a b = Ioo (a ⊓ b) (a ⊔ b)`; `uIoc a b = Ioc (a ⊓ b) (a ⊔ b)` (notation `Ι a b` for uIoc).
- `@[simp] uIoo_of_le (a ≤ b) : uIoo a b = Ioo a b`; `uIoo_of_lt (a < b)`; `uIoo_of_ge/of_gt/of_not_le/of_not_ge`.
- `@[simp] uIoc_of_le (a ≤ b) : Ι a b = Ioc a b`; `uIoc_of_ge`; (`uIicc` family analogous).
- Membership rewrites: `rw [uIoo_of_lt h] at hx` then `rcases hx with ⟨h1, h2⟩`.

### 4.3 ContinuousOn (needed for II)
- `ContinuousOn.mul` (Topology/Algebra/Monoid/Defs.lean:106); add/sub/neg/abs/ring analogues; `.congr (h : f =ᵥ g on s)` pattern used in B-3 §5.
- The `continuity` tactic closes `ContinuousOn` goals for closed-form functions given local
  `haveI : 0 < ...` facts in context.

## 5. Tactic-behavior notes (4.33.1, verified by probe)
- **Do not use `convert`** in surface-bridging (meta-sorts + instance-congr descent; see 3.4).
- `ring`: pure ring + Nat-powers; `id x` opaque; OK on bare ℝ field eqs.
- `field_simp`: the tool for `/`-normalization; pass nonzero facts as named local hyps.
- `nlinarith`/`linarith`: fine (BUT watch for `linarium` typo — cost us 14 occurrences).
- `hasDerivAt` goal printing: unsolved `convert` bullets show POINTWISE goals with `x✝` free
  (not function eqs) for `using 2`, FUNCTION eqs for `using 1` — but both are unreliable: use the recipe.
- `#check` via `lake env lean file.lean` is the fast compiler-ground-truth probe (parse errors appear instantly).
- Float: `s!`-interpolation has no format specs — print pre-scaled values (B4/B5 convention: value·1e12/1e15).

## 6. Float API (4.33.1 core, `src/Init/Data/Float/Float.lean`)
Opaque `@[extern]` math functions, all `Float → Float` (method notation OK):
`Float.log` (428), `Float.log2` (435), `Float.exp` (414), `Float.exp2` (421), `Float.sin` (322),
`Float.cos` (329), `Float.sinh` (372), `Float.cosh` (379), `Float.atan2 (y x)` (365),
`Float.sqrt` (456), `Float.abs` (~503), `Float.pi` (compiler-confirmed via `#check`; resolved in toolchain).
Core Float = bit conversions + basic ops only; **no** `Float.ofReal/Real.toFloat` — the B4/B5 style
hardcodes constants (e.g. `3.141592653589793`) and stays in pure Float.
B4Float pattern (green): `def F := Float × Float`; `Fadd/Fsub/Fmul/Fdiv/Fexp/FlogAbs/Farg` all pure Float.

## 7. B-3 file status map (scripts/rh-lean/RhAttack/B3.lean, 1485 lines as of 2026-09-14)
- Structure: plain `/- -/` header comment (NOT docstring) → `namespace B3` → `noncomputable section`
  → §1 flat defs (`nHat NHat Sbar u w fT fTp Bf Cf Kbar`) → §2 derivs (`variable (x : ℝ)`;
  `NHat_deriv`, `fT_deriv`) → §3 bounds (`negLog1mY_le`, `fT_bound`, `fTp_bound`) →
  §4 Abel core (`NList`, `derivIntegrableCont`, `rayIntegrand`, `rayIntegrable`,
  `NListRayIntegrable`, `rayInt_eval`, `b3Abel`, `nHatContinuousOn`, `NHatContinuousOn`, `nHatIBP`)
  → §5 (`P011 Q029 R229` + derivs, `Kbar_le`, `b3BoundExplicit`) → §6 (`b3ResidualDecomp`)
  → `end` `end` → `namespace B3Float` (§7, pure-Float A/B: 8-node Gauss–Legendre `gln/glw/glInt`,
  `splitIntR/splitInt`, `def run : IO (Float × Float)`) → `end B3Float`.
- **OPEN REWRITE WORK (next)**: §2 `NHat_deriv`/`fT_deriv` and §5 `P011_deriv`/`Q029_deriv`/`R229_deriv`
  still use the pre-recipe `convert` idiom — rewrite per §3.4 above. §4/§5 integrability bullets
  (pointwise ring + `Set.EqOn.aeEq_restrict`) and §6 algebra are recipe-clean.
- Main.lean wires `B3Float.run` after the B5 block (B4-style `let _w3 ← B3Float.run`).
- Scratch `RhAttack/ApiProbe3.lean` — DELETE after §3.4 recipe is ported (also ApiProbe.lean/ApiProbe2.lean/FindProbe.lean if present).
- Regime for all B-3 theorems: `Real.exp 1 ≤ G` (G ≥ e), `0 < t < G`, `G ≤ x` or `G < B` as stated.
- P-0.9: a PASS line coexisting with a flagged anomaly is NOT a PASS.

## 8. Standing environment facts
- Docker `kainos-dev:dev` mount = repo root at `/work` (NEVER `scripts/rh`); host mpmath 1.4.1 quarantined (mp.quad tail bug) — docker mpmath 1.3.0.
- M3 1e7 rewalk PID 1142170 — DO NOT KILL (writes at end; out_day006_early_rewalk.txt 0 bytes normal mid-run).
- Commit policy: only `rh-attack` paths (+ `scripts/rh-lean`); mirrors tracked separately (`rh-missing-tail`).


## 9. TOOL CHART (what each tool does, its behavior, and when to use it)
| Tool | What it does | Behavior / gotchas | When to use |
|---|---|---|---|
| `lake build` | compiles package (o-file cache incremental) | slow first Mathlib pass; later ~seconds per changed file | full gate after each port |
| `lake env lean <f>.lean` | single-file compile; parse errors instant, elaboration to error | Mathlib import makes first elaboration slow until cached | syntax checks, `#check` ground truth |
| `lake exe rhattack` | runs Main.lean → prints all cross-check suites (E7a/B-4/B-0/B-5/B-3) | the A/B gate: ALL must PASS | final verification |
| `#check` | reveals exact elaborated type/arity | use for any "does it exist / what's the signature" question | API pinning (compiler = truth) |
| `rg`/`grep` on `.lake/packages/mathlib` | literal Mathlib 4.33.1 source | exact pinned version — ground truth over the web | name/signature lookup |
| `references/lean4-core-4.33.1` | literal Lean core source (List, Float, ...) | cloned at tag v4.33.1 | core-level lookups |
| `ring` | ring closure incl. Nat powers, standalone field eqs in ℝ | opaque `id x`; broken inside convert bullets (meta-sorts) | pointwise algebra bullets |
| `field_simp [h]` | normalizes /⁻¹; takes named nonzero facts | needs `have h : d ≠ 0` facts in context | division/π-denominator algebra |
| `nlinarith [facts]` / `linarith` | ordered nonlinear/linear arithmetic | watch typo `linarium`; pass positivity facts | inequality bullets |
| `continuity` | continuousOn/continuousAt for closed forms | needs local `haveI : 0 < ...` facts | continuity plumbing |
| `split` / `rcases` / `refine` | case decomposition, structured proof terms | `refine ... ?_` + following tactics = valid hole-fill | structure-heavy proofs |
| `norm_num` | numeric evaluation/closure | fine on ℝ literals, Float literals in terms | constant facts |
| **`convert`** | stepwise goal transformation | **DO NOT USE** for surface bridging (meta-sorts, instance descent) | never — use §3.4 recipe |
| `ext z` | function extensionality | β-reduces lambdas; combine with ring/simp | hfe bridges |
| `by_cases`/`by_contra` | classical case splits | fine (noncomputable section) | 3-case ray arguments |
| Float literals `3.1415...` | Float64 constants | no format specs in `s!` — pre-scale | B3Float |
| `Array.enum.foldl` | fold over (index, elem) pairs | plain `Array.foldl` passes ELEMENTS (glInt bug) | indexed GL quadrature |

## 10. UPDATE PLOT (atomic pieces to complete B-3; each independently testable)
1. **P2 tail fix** (B3.lean §7): delete draft `run : (Bool, Float, Float)` + stray `end B3Float`,
   single IO `run` inside namespace; fix `glInt` to `gln.enum.foldl (fun acc (i, x) => acc + glw[i] * f (m*x + c)) 0`;
   named ends `end` (section) / `end B3`. TEST: `lake env lean B3.lean` reaches §1 decls (no parse errors).
2. **P3 new §2** (standalone `Bt2.lean` = §1 flat defs + NHat_deriv + fT_deriv rewritten per §3.4
   recipe: `hasDerivAt_id'`, explicit `hasDerivAt_const x c`, `HasDerivAt.comp x hh₂ hh`, `HasDerivAt.sub`
   for `log − 1`, `hasDerivAt_add hM (hasDerivAt_const x 7/8)` for NHat +7/8, hfe via `ext z; field_simp; ring`,
   deriv via pow 2 for u, `hasDerivAt_inv`+comp for u⁻¹, div for w u⁻¹, log-of-inv composition for the log term).
   TEST: `lake env lean Bt2.lean` green. THEN port into B3.lean (python replace, assert markers).
3. **P4 new §5 derivs** (standalone `Bt5.lean` = P011/Q029/R229 + three deriv theorems via the same recipe).
   TEST: green. THEN port; also fix `nHatIBP` hHderiv (replace convert with recipe/`HasDerivAt.deriv`).
4. **P5 full build**: `lake build`; fix only compiler-reported residual errors (Kbar_le tail,
   b3BoundExplicit pointwise bullets, §6) one at a time using §3–§5 idioms.
5. **P6 gate**: `lake exe rhattack` → E7a 5/5, B-4 16/16, B-0 eval, B-5 12/12, **B-3 CROSS-CHECK PASS**.
6. **P7 housekeeping**: journal, RH-PROOF-OUTLINE B-3 block, FORMULAS, commit rh-attack paths, wiki obs.
