# RH-PROOF-OUTLINE — full proof skeleton with numbered blanks

**Status: DRAFT PROOF SKELETON v0.7 (2026-09-11).** v0.7: **B-5 CORE now
PROVEN in Lean** — `b5Ratio` (T1 exact ratio), `b5Abs` (T2), `b5NoffPos`,
`b5PrefSign`, `b5NoffIsPolynomial`, in `scripts/rh-lean/RhAttack/B5.lean`,
with the 12-config float64 cross-check wired into `Main.lean` (worst
closed-vs-direct 1.9×10⁻¹⁴ rel, worst vs dps-30 record 4.2×10⁻⁸ rel —
12/12 PASS). The whole Lean line moved to the STABLE toolchain
(lean4 v4.33.1 + mathlib v4.33.1) at the owner's direction; rc2 had
multiple regressions (day-012 §1). E7a/B-4/B-0 re-verified green on the
stable pin (5/5, 16/16, #eval!). v0.6: D1 LANDED — the
corrected 6×10⁶ list (N(6×10⁶) = 12,193,869; an off-by-one had truncated it
at 5.9×10⁶, found via the chain's own S-line flag, fixed and re-certified)
and the G = 6×10⁶ onset rows: the Stage-1 five-row onset pattern is
reproduced within ≤6% (zero-side residuals 5.9×10⁻⁵–1.8×10⁻³ of |ζ|); the
tail error E(G,s) is tabled row-by-row and the honest method ceiling
t ≲ 10⁴–2×10⁴ is CONFIRMED at G = 6×10⁶ (B-2's remaining task is to bound
this E). B-4 label upgraded MEASURED → PROVEN (Lean, `formal/rh-lean`).
v0.5: B-5 core theorem FILLED
(D4/D3; 2K mechanism settled; δ-robust f-scale; far-point correction). v0.3:
D3-FINE landed — local audit floor pinned (median 2.9e-3 / p90 1.86e-2 / max
3.89e-2), Route-A SNR measured (≥8.9× worst config; ≥14× at the pair's own
height), D4-height 6e-2 explained as adjacent-zero |ζ|-scale effect. v0.4:
D4-FARSCALE landed — the far-pair regime is MEASURED: |R−1| = (t₀/γ*)² to
6 digits at ratios 10/50/100 (100.000 / 2499.999 / 9999.998), δ-flat to
O(1e-6) — the detector margin GROWS quadratically with height ratio; the
v0.1 shrinkage note is decisively dead. v0.5: **B-5 core theorem FILLED**
— exact closed form for the kernel-deviation ratio R = off4/on2, proved by
4-zero algebra and verified at dps-30 against the definition AND the
measured 6-digit table (worst |formula−measured| 5×10⁻⁴ = last printed
digit; |formula−direct| 6×10⁻²⁶); see `out_day010_b5core_check.txt`.
NOT a proof. No claim. Every step is labeled **MEASURED** / **CLASSICAL** /
**TO-BUILD** / **■ filled**.

**Mirror:** `rh-missing-tail` `docs/RH-PROOF-OUTLINE.md` (synced 2026-09-10,
v0.5 @ 9b848df). Propagate by explicit copy after commit — never edit
the mirror locally.
Blanks are `[B-n]` with exact statements; the blank ledger at the end maps each to
its data trigger. Companion: `RH-OUTLINE.md` (state + strategy + triggers D1–D5).
Discipline: formulas only from `FORMULAS.md` (ledger); certified numbers carry
script+data provenance (P-0.9).

---

**THEOREM (target — not claimed).** Every non-trivial zero of ζ satisfies Re ρ = ½.

**Proof.** (structure; blanks numbered)

## §0 Reduction to a counting statement

- **F-0.1** ζ(x) > 0 for x ∈ (0,1) — [CLASSICAL, citation pending] — excludes
  real off-line zeros; non-trivial zeros are non-real.
- **F-0.2** Trivial zeros are the negative even integers — [CLASSICAL].
- **F-0.3** Non-real zeros occur in 4-tuples {ρ, ρ̄, 1−ρ, 1−ρ̄} (conjugation +
  functional equation) — [CLASSICAL, DLMF 25.12/25.3].
- **F-0.4** Riemann–von Mangoldt in the project convention:
  main(t) = x·ln x − x − ⅛, x = t/2π; S(t) = N(t) − main(t); N(t) = #zeros
  with 0 < Im ρ ≤ t (counts ALL zeros, on- and off-line) — [CLASSICAL formula;
  convention + dps-40 verification at 10⁵/10⁶/10⁷: day-003/004b/010,
  `out_day003_s_arg_mpmath.txt`; S(10⁷)=−1.2057, 2K=0 @2.25×10⁻⁹].
- **F-0.5** Definition-side computability: ζ(½+it) by Riemann–Siegel from the
  definition (no zero input — the project float engine, dps-corrected);
  Z(t) = e^{iθ(t)}ζ(½+it) real between its zeros; N_on(t) = #{Z zero: 0<γ≤t}.
  Both N_total and N_on are definable functions of ζ alone.
- **[B-0]** (TO-BUILD, LOW) Counting equivalence:
  **D(t) := N_total(t) − N_on(t) is even-valued, step, RH ⇔ D(t) ≡ 0.**
  D jumps by 2 at each off-line pair height (F-0.3: a 4-tuple contributes two
  zeros at the same positive height). Statement is a 2-line counting argument
  from F-0.1–F-0.5. Lean M4 can house B-0 + B-4.

Henceforth: **RH ⇔ D ≡ 0** (B-0).

## §1 The two sides of the onset residual (no zero input)

**Definitions** — **F-1.1**: P_n(s) = Σ_{k=1}^n k^{−s}; I(n,s) = n^{1−s}/(1−s);
W_n(t) := ζ(½+it) − P_n(½+it) − I(n,½+it); C_n(t) = |W_n(t)|. All definition-side
(F-0.5): computable at every height, no RH, no zero list.

- **F-1.2** **MEASURED** (day-004b; 4 digits; N-independent across N ∈ {10³,10⁴,10⁵};
  onset at t/N ≈ 2): C_n(t)/|I| = ½·(t/N) + O(correction), in the onset window.
- **[B-1]** (TO-BUILD, = G4) **Exact onset theorem**: make F-1.2 rigorous —
  W_n(t) = e^{iΦ_n(t)}·(½)(t/n)|I| + R_n(t) with explicit Φ_n and a remainder
  R_n(t) from the Euler–Maclaurin expansion of Σ_{k>n} k^{−s} − I(n,s) with
  remainder bound. Data trigger: D2 (beyond-4-digit fits, certified list).
- **F-1.3** **CLASSICAL (READ)** zero-side kernel, DLMF 25.2.12 (Riemann 1859
  product; ledger FORMULAS.md E7b): for a zero set 𝒵,
  K(s;𝒵) = Main_25.2.12(s) · Π_{ρ∈𝒵, |Imρ|≤G} (1−s/ρ)e^{s/ρ} · e^{T(G,s)},
  T the analytic density tail (closed-form integrand, ledger).
- **[B-4]** **■ FILLED — PROVEN IN LEAN (2026-09-10)** On-line per-pair
  closed form: T1–T3b machine-checked in `rh-lean` (`formal/rh-lean`
  `RhAttack/B4.lean`: `pairClosedForm` exact with no exclusion,
  `pairLogAbs` = la_pair verbatim, `pairArgAngle`/`pairArLedger` the phase
  exactly mod 2π) + 16/16 float64 cross-check; measure record below
  (`/tmp/rh/d4_unit_pair.py`, first 100 certified zeros, t both sides of
  each γ):
  - la_pair(g,t) = ½/(¼+g²) + log|1 − (¼+t²)/(¼+g²)|
  - ar_pair(g,t) = t/(¼+g²) − π·[g < t]   (sum of the two principal args;
    atan2 constants cancel in-pair)
  - deviation vs exact mpmath single-pair: dLa ≤ 3.5×10⁻¹⁴, dAr ≤ 3.2×10⁻¹⁶ rad.
  - singularity: la_pair → −∞ iff a listed γ equals t numerically (SINGULAR,
    reported — never FAIL; the certified list has none at the test points).
  - consequence: the on-line product reduces to a float64-vectorizable sum
    (no mpmath loop) — the M2 TS module `zero-product-log` implements this.
  - **cross-method validation (day-010 Job A, `out_day009c_vectorized_rerun.txt`,
    P-0.9):** the float64 vector product reproduces the CERTIFIED Stage-1 table
    point-for-point at G = 3×10⁵ — (10³,1.0): +0.29%, (10⁴,0.1): −1.17%,
    (10³,2.0): +5.79%, (10⁴,0.2): +4.23% (Ψ-errs 6.44×10⁻⁵ / 6.44×10⁻⁵ /
    1.80×10⁻³ / 1.80×10⁻³) — and matches the mpmath reference to dLa
    4.5×10⁻¹³, dAr 7.2×10⁻¹⁴ (in π units, nearest-integer distance) on the
    138,065-pair prefix, hard-asserted (<1e-6) before any emit.
- **[B-2]** (TO-BUILD, = G3) **Rigorous tail**: T(G,s) = ∫_G^∞ pairlog(γ,s)
  · ln(γ/2π)/(2π) dγ + E(G,s) with an explicit |E(G,s)| ≤ M(G,t). MEASURED:
  the density-tail error saturates in G once G ≫ t (S-scale sum-vs-∫ against
  actual spacings; coefficient ~20–40) — M is non-vanishing; the honest
  method ceiling at current G is t ≲ 10⁴–2×10⁴. **D1 LANDED (2026-09-10,
  `out_day010_onset_G6e6.txt`, verified docker mpmath 1.3.0, complete
  corrected list):** the G = 6×10⁶ product side reproduces the onset at the
  five near rows within ≤6% (residuals: (10³,1.0) 5.9×10⁻⁵, (10³,2.0)
  1.8×10⁻³, (10⁴,0.1) 5.9×10⁻⁵, (10⁴,0.2) 1.8×10⁻³; the (10³,0.1/0.5)
  rows +70% are the known N-scale onset-window correction, Stage-1
  identical); E(G,s) grows past 8×10⁻² by t = 10⁴ and is O(1)–O(10) at
  t = 5×10⁴–2×10⁵ — the ceiling is CONFIRMED, and B-2's remaining task is
  the explicit bound M(G,t) ≥ this E. The zero side is now validated on a
  12.2M-zero list; the definition side (W_n) is unchanged.
- **[B-3]** (TO-BUILD, = H3 lift) **Bridge identity**: for the actual zero set
  𝒵_ℂ,  ζ(s) = K(s;𝒵_ℂ) in the product sense (25.2.12), finite-G residual
  governed by B-2's M(G,s). Evidence: Stage-1 MEASURED at G=3×10⁵ (certified
  list; docker mpmath 1.3.0 verified env): zero-side reproduces the 4-digit
  onset — (10³,1.0): 0.5086 vs 0.5071 (+0.29%), (10⁴,0.1): 0.0494 vs 0.0500
  (−1.2%); two borderlines +4.2/+5.8%; the rest below the quantified floor.

## §2 Detectors: off-line ⇒ deviation

- **[B-5]** (TO-BUILD, = G2) **Kernel-deviation lemma**: for an explicit
  off-line pair {β+iγ₀, (1−β)+iγ₀} (δ = β−½ ≠ 0), the kernel change under
  that pair's move,
  ΔK(s) := K(s; 𝒵 with the pair off-line) − K(s; 𝒵 on-line),
  satisfies |ΔK(½+it₀)| ≥ f(δ, t₀)·|K(½+it₀; on-line)| for t₀ ≈ γ₀, f explicit
  (a 2-factor algebraic comparison inside a convergent product — the rest of
  the product is shared and cancels exactly, so NO normalization ambiguity).
  **MEASURED v0 (2026-09-10; `out_day010_d4d3.txt`; certified 3×10⁵ list;
  docker mpmath 1.3.0; γ* = 999.791572; δ grid [0.005, 0.5]; 6 heights):**
  - **f-scale.** R := off4/on2 (pair factors only; same 25.2.12
    normalization on both sides, cancels exactly): t₀ = γ*±0.25, γ*±1.0:
    |R−1| = 0.998–1.002; t₀ = γ*+10: 1.020; t₀ = 2γ*: **4.0000 exactly**
    across the whole δ grid. Structural reading (2-factor algebra, matches):
    δ→0 sends the 4-tuple to a doubled on-line pair, off4 → on2², so R →
    F_pair; |R−1| = |F_pair−1| with F_pair(t₀) = (γ*²−t₀²)/(¼+γ*²)+… ≪ 1
    near resonance (hence ≈ 1) and F_pair(2γ*) ≈ −3 (hence 4).
    dev := |K|·|R−1| = forced |ΔK|: 0.032–2.26 in absolute kernel units,
    δ-robust (≤0.4% drift at t₀ ≈ γ*; ≤25% at 2γ*; 0.00% at 2γ*).
    **Measured v0 bound: an off-line pair at δ ∈ [0.005, 0.5] forces a
    kernel change ≥ 99.8% of the kernel magnitude itself (near-resonant
    geometry; all six measured configurations).**
  - **2K/S mechanism — SETTLED (measured, structural + numerical).** Net
    phase across the straddle window t ∈ [γ*∓2]: on-line pair factor
    −3.142 rad (≈ −π: the straddled zero winds once; its conjugate is
    ∼2γ* off the path) vs off-line 4-tuple **+0.000 rad for every δ** —
    structurally exact: for the two near zeros {½+δ+iγ₀, ½−δ+iγ₀},
    (1−s/ρ)(1−s/ρ′) = −((t−γ₀)²+δ²) / (fixed complex) — real-negative
    numerator, never zero ⇒ phase constant in t (net 0); the mirror half
    is smooth. **Hence an off-line pair is argumentically INVISIBLE on the
    central line**: RVM counts it (+2 to N_total), the line argument does
    not wind ⇒ 2K steps +2, **parity preserved, no flip**. The S/2K walk
    sees a ghost pair as a SIZE step (+2) — the same detector family that
    found the 246 dead chunk by S-size, not parity (F-2.1). The walk-based
    (S, 2K) fingerprint is thereby the δ-robust complement of the
    kernel-deviation family — both routes keep their coverage story.
  - **Far-pair regime — MEASURED (v0.4, `out_day010_d4farscale.txt`,
    ratios 10/50/100, same δ grid):** |R−1| = 99.99998 / 2.499999×10³ /
    9.999998×10³ — i.e. **(t₀/γ*)² to 6 digits** (10², 50², 100²),
    δ-flat to O(10⁻⁶ relative) across [0.005, 0.5]; dev = 3.47×10² /
    4.18×10⁴ / 3.71×10³; SNR vs local |ζ−K|: 1.2×10³ / 2.6×10³ / 2.4×10⁴.
    **The v0.1 "~δ/(t−γ₀) shrinkage" note is decisively dead: the margin
    GROWS quadratically with the height ratio.** Measured f-regimes, all 8
    height configs × 7 δ values (56 points): near resonance |R−1| ≈ 1
    (≥ 0.998); 2γ*: 4.000; far: (t₀/γ*)². Unified measured lower bound:
    |ΔK|/|K| = |R−1| ≥ 0.998 uniformly over the measured δ grid and all
    measured height ratios (the δ→0 drift is ≤0.03% in the near regime and
    O(1e-6) in the far regime — no dead δ window). SNR context: the far
    audit |ζ−K| itself degrades past t ≈ 2×10⁴ (B-2's D1 problem — the 6e6
    chain), which is exactly why Route A must be paired with the rigorous
    tail B-2; even so the relative form |R−1| — which needs NO audit floor
    — is the clean detector statement.
  - **Audit floor (D3 first pass, coarse): ** |ζ(½+it) − K_on(t)| (G = 3×10⁵),
    t ∈ [950, 1050] @ 5-unit grid (21 pts): median 1.78×10⁻³, p90
    8.07×10⁻³, max 2.46×10⁻² (t = 980); spike ratio max/median 13.9 (the
    ≥5× investigation trigger fired). D4 heights in the same neighborhood
    show |ζ−K| ≈ 6.2–7.0×10⁻² (5 of 6; the 2γ* height: 3.1×10⁻²) — the
    residual floor is STRUCTURE at the unit (zero-crowd) scale, not a
    constant. **D3-FINE LANDED** (`out_day010_d3fine.txt`; [975,1025]@0.5u,
    99 pts): median 2.90×10⁻³, p90 1.86×10⁻², p99 3.20×10⁻², max
    3.89×10⁻² (t = 1024.5); top band scattered — NO localization, NO 100×
    ghost spike; the coarse max (2.46e-2 @980) sits inside the fine top
    band (consistent). **Route-A SNR (measured, conservative): forced
    |ΔK| 0.168–2.26 vs the fine local envelope ⇒ worst config 8.9×; at the
    pair's own height (the minimal-contradiction case) ≥ 14×, up to 260×;
    relative form |R−1| ≥ 0.998 vs audit relative floor ≤ ~2×10⁻² ⇒ ≥ 50×.**
    Note (resolved, no longer open): the D4 heights' own |ζ−K| ≈
    6.2–7.0×10⁻² (5 of 6) is |ζ|-scale at adjacent listed zeros (four of
    the six heights sit within ≤0.036 of 998.827547 / 1001.349483 /
    1009.806591) — a measurement-height effect, not a floor.
  Status: **core FILLED (v0.5, exact + verified); composition remains in
  B-6A.** Data: all regimes measured. Theorem: the measured law holds
  EXACTLY as below — no residual approximation in the core.
- **F-2.1** **MEASURED**: the self-certifying instrument (H0) certifies
  D(t) = 0 up to T: 10⁶ (2K even, dps-40); 10⁷ (S = −1.2057 O(1), 2K = 0 to
  2.25×10⁻⁹ dps-40, dt/dt2-STABLE window 227,197); the flat-|S|≈247 dead
  chunk at ~1.06×10⁶ was found by the S-size detector and corrected (+246) —
  the ghost-exclusion mechanism in action. Final 10⁷ redundancy re-walk: in
  flight (day-006 early re-walk, started day 9).

## §3 The ∀t closure — the main gap (G1)

- **[B-6A]** (TO-BUILD; **Route A** — project home turf) **Residual-floor
  theorem**: for all t > 0,
  |W_n(t) − [K(½+it; 𝒵_on(t)) − (P_n − I(n,s))]| < f_n(t),
  proved from the definition side (F-0.5) + B-1 + B-2 — **no count at any
  height; T never enters the proof.** Composition with B-3 + B-5: an off-line
  pair at t₀ forces the LHS ≥ f(δ,t₀) at its own height — contradiction.
  Coverage: pairs with |δ| ≥ δ_min(t) (the floor's sensitivity threshold;
  δ_min to be measured by D4).
- **[B-6B]** (TO-BUILD; **Route B** — classical home turf) **Uniform
  dynamics**: 2K(t) even ∀t (equivalently: S(t) stays in the on-line band;
  D is identically 0) — an S(t)-program of the classical type. δ-robust
  (no sensitivity floor). Depth note: at full strength essentially
  RH-equivalent; the lifting path is the open engineering question.
- **[B-6C]** **■ partial** **Hybrid interim claim**: D(t) = 0 for t ≤ T
  (F-2.1: T = 10⁶ certified; T = 10⁷ pending final redundancy) **and**
  (B-6A ∨ B-6B) for t > T. This is the claim the project can stand behind
  at any moment; it sharpens but does not close RH.
- **Route decision rule (from RH-OUTLINE §4):** D1 (tail-saturation data) +
  D4 (kernel-deviation margin) choose between A and B. If the A-margin
  collapses, A is retired and B/C take over. C always remains the interim
  certified claim.

- **[B-5 CORE] ✓ FILLED — exact ratio theorem (2026-09-10 v0.5).**
  Definitions (from [B-5]): s = ½+it (t > 0, t ≠ γ), P_on(s) =
  ∏_{ρ∈{½+iγ, ½−iγ}} (1−s/ρ)e^{s/ρ}, P_off(s,δ) = ∏_{ρ∈{½±δ±iγ}}
  (1−s/ρ)e^{s/ρ}, R(s,δ) = P_off/P_on.
  **Theorem.** Let
  ω_δ := (1+2δ)/((½+δ)²+γ²) + (1−2δ)/((½−δ)²+γ²) − 1/(¼+γ²) ∈ ℝ.
  Then
  R(s,δ) = (¼+γ²)((γ−t)²+δ²)((γ+t)²+δ²) / ( (γ²−t²)((½+δ)²+γ²)((½−δ)²+γ²) )
            · e^{(½+it)·ω_δ}.
  (Real signed prefactor × pure constant-rate phase; the sign flip of
  (γ²−t²) at t = γ is the ONLY branch — the off-line numerator
  ((γ−t)²+δ²)((γ+t)²+δ²) is strictly positive for δ > 0.)
  **Proof (4 lines).** P = [∏(ρ−s)/∏ρ]·e^{s·Σρ⁻¹} on each side. (i)
  ∏(ρj−s): off-line, grouped as {½+δ±iγ} and {½−δ±iγ}: each group gives
  (i(±γ−t))² − δ² = −((γ∓t)²+δ²) (real, negative); the product is the
  stated positive real. On-line: (i(γ−t))·(−i(γ+t)) = γ²−t². (ii)
  ∏ρ: off-line ((½+δ)²+γ²)((½−δ)²+γ²) (real, positive); on-line ¼+γ².
  (iii) Σρ⁻¹: in both cases real (conjugate-pair sums): the stated ω_δ
  and 1/(¼+γ²). (iv) Ratio. □
  **Verification (3-level, `out_day010_b5core_check.txt`, dps-30):**
  formula vs direct 8-zero definition: |Δ| ≤ 6×10⁻²⁶ (14/14 configs);
  formula vs measured |R−1| (dps-15, G=3×10⁵, 56 points): worst |Δ| =
  5×10⁻⁴ = the last printed digit. Consequences, all now exact:
  (a) far (t > γ): |R| = (γ²+¼)((t−γ)²+δ²)((t+γ)²+δ²)/
  ((t²−γ²)((½+δ)²+γ²)((½−δ)²+γ²))·e^{ω_δ/2}, an all-real-positive
  prefactor × constant-rate phase; expanding,
  |R| = (t²−γ²)/(γ²+¼+δ²)·(1 + 2δ²(t²+γ²)/(t²−γ²)² + O(δ⁴/(t²−γ²)²)),
  hence |R| = (t/γ)²·(1 + O(δ²/γ² + 1/γ² + (γ/t)²)); the
  measured c² in |R−1| at t = c·γ is (c²−1) + 1: the +1 is the exact π
  branch (prefactor < 0 for t > γ) with phase ≈ π (ω_δ·t = O(c/γ));
  (b) near: R(δ→0) = −F_pair; for fixed δ > 0 with t → γ: R → 0
  exactly (off-line numerator stays positive, (γ²−t²) → 0 in the
  denominator) so |R−1| → 1 exactly; the measured near-spread
  0.9975–1.0201 is the exact prefactor at (t−γ) ∈ [−1, 10],
  δ ∈ [0.005, 0.5] — 56/56 points agree to 5×10⁻⁴;
  (c) δ has NO zero-window: |R|·(t²−γ²)((½+δ)²+γ²)((½−δ)²+γ²)/(γ²+¼)
  = ((t−γ)²+δ²)((t+γ)²+δ²) = (t²−γ²)² + 2δ²(t²+γ²) + δ⁴, a polynomial in
  δ with all-positive coefficients — no δ > 0 annihilates it;
  (d) the phase is t·ω_δ + (0 or π): the −π winding at t = γ belongs to
  the ON-LINE factor only (measured −3.142 vs +0.000) — the
  argument-invisibility + 2K +2 size-step mechanism of the [B-5] block
  above, now backed by the exact form.
  **What B-5 still owes B-6A:** composing |ΔK| = |K|·|R−1| (this
  theorem) with the rigorous local floor (B-2, from D1) into a
  contradiction — that is B-6A's construction, not B-5's.

  **✓ PROVEN in Lean (2026-09-11, stable 4.33.1).** `b5Ratio` (T1 above,
  as stated — the theorem statement carries the (½±δ)²+γ² form), `b5Abs`
  (T2: ‖R‖ = |pref|·exp(ω_δ/2)), `b5NoffIsPolynomial` (the (c)-polynomial
  identity), `b5NoffPos` ((c): the off-line numerator > 0 for t > 0,
  t ≠ γ, all δ), `b5PrefSign` (t > γ ⇔ pref < 0 — the only branch).
  Float layer `B5Float`: closed form vs the DIRECT 6-factor definition
  vs the dps-30 record, 12/12 PASS (day-012 §3). Toolchain note: def
  bodies `omegaD`/`pref` use the flat monomial form of the denominators
  (identical reals — the ring normalizer cannot see through the `halfR`
  def constant); B-4 carries a documented two-line compat shim for the
  4.34-core lemmas `ite_eq_left`/`ite_eq_right`.

## §4 Closure (conditional on the blanks)

Assume RH fails. By F-0.3 take an off-line pair of **minimal** positive
height t₀ (members β+iγ₀, (1−β)+iγ₀; δ = β−½ ≠ 0).
1. By B-3 (bridge identity for the ACTUAL zero set) and B-5 (kernel
   deviation at the pair's own height):
   |W_n(t₀) − K(½+it₀; 𝒵_on(t₀))| ≥ f(δ, t₀)·|K|.
2. By B-6A (Route A; requires |δ| ≥ δ_min) or B-6B (Route B; any δ):
   the same quantity < f(δ, t₀)·|K|.
3. Contradiction ⇒ D ≡ 0 ⇒ (B-0) RH. **Q.E.D. — conditional on
   B-0, B-1, B-2, B-3, B-5, B-6(route).**

---

## Blank ledger (what fills each blank)

| B | Content | Vehicle | Data trigger | Status |
|---|---------|---------|--------------|--------|
| B-0 | counting equivalence RH⇔D≡0 | writing; Lean M4 | — | TO-BUILD (LOW) |
| B-1 | exact onset law + remainder (G4) | Euler–Maclaurin lifting | D2 (fits beyond 4 digits) | TO-BUILD |
| B-2 | rigorous tail remainder M(G,t) (G3) | tail analysis | **D1 LANDED 2026-09-10 (ceiling t ≲ 2×10⁴ confirmed; E tabled in `out_day010_onset_G6e6.txt`)** | TO-BUILD (statement ready; bound open) |
| B-3 | bridge identity as identity+residual (H3 lift) | follows B-1∧B-2; TS kernel (M2) | D1, D3 | TO-BUILD |
| B-4 | on-line per-pair closed form (la, ar) + validation | Lean T1–T3b + dps-25 + float64 16/16 | — | **■ FILLED — PROVEN (Lean)** |
| B-5 | detector lemma f(δ,t) + S/2K mechanism | 4-zero algebra + D4/D3/D4-far + dps-30 check | **ALL DATA LANDED; CORE THEOREM EXACT + PROVEN IN LEAN** (R closed form; \|formula−measured\| ≤5×10⁻⁴, \|formula−direct\| ≤6×10⁻²⁶; Lean 4.33.1: b5Ratio/b5Abs/b5NoffPos/b5PrefSign + 12/12 float cross-check) | **■ core FILLED (v0.5, PROVEN v0.7)** — composition with the floor is B-6A's |
| B-6A/B | ∀t closure (route decision) | lifting theorem | D1+D4 margin | **TO-BUILD (the wall)** |
| B-6C | hybrid interim claim (RH to T) | H2 instrument | D5 (10⁷ redundancy — in flight) | ■ partial |

**Classical inputs to cite (G6):** 25.2.12 product; θ and S conventions
(25.10); RVM; functional equation; ζ>0 on (0,1) (citation pending — F-0.1).

## What the incoming data does to this document

- **6×10⁶ chain LANDED (2026-09-10)** (`out_day010_onset_G6e6.txt` +
  `zeros_T6000000_ext_full.txt`): D1 verdict as above. Incident on the
  record: the first-issued list was silently truncated at 5.9×10⁶ by an
  off-by-one in the walk's segment boundary loop; the chain's own
  informational S-line flagged it (−219,016.93 where O(1) expected), it was
  fixed and the list re-certified (S(6×10⁶) = −2.93, true O(1)) BEFORE any
  onset run was used — no onset row in this file rests on the truncated
  list. Route-decision input: D4's relative margin (|R−1| ≥ 0.998) still
  sits above the residual floor up to t ≈ 5×10⁴ (0.42) on this table; the
  ceiling t ≲ 2×10⁴ stands for the route-A audit; route choice is a
  v0.7 decision (needs the B-2 bound to make the comparison at a fixed t).
- **D4 prototype LANDED** (2026-09-10): B-5 v0 measured — mechanism
  settled (off-line pair = argumentically invisible, 2K +2 size step,
  parity preserved), δ-robust f-scale (≥99.8% of |K| forced change on the
  measured grid).
- **D4-FARSCALE LANDED** (2026-09-10): ratios 10/50/100 give
  |R−1| = (t₀/γ*)² to 6 digits — amplification confirmed, shrinkage note
  dead; the relative detector statement (|ΔK|/|K| ≥ 0.998 uniform) stands
  without any audit floor.
- **D3 LANDED, coarse + fine** (2026-09-10): local audit floor pinned
  (fine: 2.9/18.6/38.9 e-3; no spike, no localization); Route-A SNR
  measured ≥8.9× worst config, ≥14× at the pair's own height; the D4-height
  6e-2 resolved as adjacent-zero |ζ|-scale (measurement-height effect). A
  future 100× fine-grid spike would still stop everything (direct
  content).
- **10⁷ redundancy lands** (day-006 early re-walk): closes F-2.1/B-6C at
  T = 10⁷.
- Nothing in this file is retracted by data; data only moves blanks between
  TO-BUILD and FILLED, and can swap the route (A↔B) per the decision rule.
