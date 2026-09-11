> **MIRROR — a planning artifact, not a result.** Source of record:
> `kainos-logos` `plan/40-prize-islands/rh-attack/RH-OUTLINE.md`,
> re-synced 2026-09-11 (content v0.1; prior sync 2026-09-10 from head `4633916`).
> No edits here — updates propagate only by explicit copy from the
> source repo (PLAN.md, "Staged proof scaffold"). NOT a proof. No claim.

**Status: SCAFFOLD v0.1 (2026-09-10).** Not a proof. No claim. Every item is labeled
MEASURED / CLASSICAL / INFERENCE / TO-BUILD. Built to be re-opened: §4 lists exactly
which measurements should change it. Companion files: `day-*.md`, `spec/*.md`,
`prompts/M*.md`, `FORMULAS.md` (ledger), `POSTULATES.md` (P-0.x discipline).

**Mirror:** `rh-missing-tail` `docs/RH-OUTLINE.md` (synced 2026-09-10,
v0.1). Propagate by explicit copy after commit — never edit the mirror
locally.

---

## 0. Shape in one paragraph

RH ⟺ "no off-line zero" (zeros off the line come in 4-tuples; real off-line zeros are
classically excluded). Strategy: **do not let any walked count be a step of the proof.**
The finite, self-certifying instrument (H0/H2) is a *calibration tool* for theorems.
The proof object is an identity between two zero-free-computable sides:

- **prime/definition side** — ζ(½+it) (Riemann–Siegel from the definition, no zeros used;
  the project's float engine), the partial sum P_n, the integral I, and hence the onset
  residual W(t) ≝ ζ(½+it) − P_n − I. Computable at *every* height, no RH input.
- **zero side** — the Riemann-1859 product (DLMF 25.2.12): main factor × per-zero
  factors × analytic tail. On the critical line the conjugate pair-factors are **exactly
  real** (MEASURED, Stage 1).

The on-line hypothesis makes the zero side an explicit function of the on-line zero list,
which the same instrument can generate. The three-proposition structure in §3 is what
has to close to give RH *at all heights*; the walk only tests it up to T and calibrates
its constants.

## 1. What we have

| # | Item | Status | Evidence (provenance in day journals / spec files) |
|---|------|--------|---------------------------------------------------|
| H0 | Self-certifying instrument: twin-floor dt/dt2-stable walks + dps 2K/S spot checks + measured engine-reliability map (2-term float64 twin-safe t≳10⁵ only; low-t needs fine dt) | **PASS** | Days 4–9; `spec/zero-core-engine.md`, `spec/zero-walks-and-certificates.md` |
| H1 | Missing-tail action language on the Dirichlet ladder (χ₅, χ₁₃, χ₁₇, τ₁₂, χ₂₄, τ₂₈, χ₅₆): D=−P, exact M₁ tables, quadruple corner 180°−720°/q, multiplicative/non-multiplicative cell split | **PASS, sealed** | Days 6, 8; repo v0.5–v0.7 (closed side-quest) |
| H2 | Counterexample search: certified ghost-free to 10⁶ (2K parity); 10⁷ triple-certified count (S=−1.2057, 2K=0 @2.25×10⁻⁹ dps-40, dt/dt2-STABLE window) with ONE redundant early re-walk left | **NEARLY DONE** | Days 5–6, re-run day 9/10; `spec/zero-walks-and-certificates.md` |
| H3 | Bridge E7b-1 Stage 1: zero-side 25.2.12 kernel + analytic tail reproduce the **measured 4-digit N-independent onset** C/|I| = ½·(t/N) at the clean points (+0.29% at (10³,1.0), −1.2% at (10⁴,0.1)); two borderline (+4.2/+5.8%); rest inside the quantified zero-side error floor | **STAGE 1 DONE** | `out_day009c_onset_pred_certified.txt`, `spec/onset-bridge-e7b1.md`, FORMULAS.md E7b-1 |
| H4 | Same language generalizes across the ladder (closed: next cells 28, 56 measured; 48 not fundamental) | **PASS** | Day 8; repo |

Certified zero counts (provenance: script + list file, P-0.9): 10⁵=138,065 · 3×10⁵=466,655
(GPU, dt/dt2 exact, gate 6.5×10⁻¹⁰) · 10⁶=1,747,142 · 10⁷=21,136,123 (pending final
redundancy — early re-walk running, started day 9).

## 2. Gap list (current rank)

| Gap | Content | Status |
|-----|---------|--------|
| **G1** | Finite T ⇒ ∀t. The counterexample argument stops at the walked height. Fill = §3. | TO-BUILD (scaffold §3) |
| **G2** | **Identification / sensitivity**: an off-line 4-tuple at height t₀ forces a deviation of W/S/2K ≥ f(δ,t₀) > 0 with explicit f. Turns the bridge from *reproducer* into *detector*. | TO-BUILD + executable prototype (D4) |
| **G3** | **Rigorous tail remainder**: the RVM-density tail's error is quantified but saturates in G (sum-vs-∫ against actual spacings, S-scale) — does not vanish. Needs an explicit remainder for the beyond-list pair sum. | TO-BUILD (data trigger D1) |
| **G4** | **Exact onset**: the 4-digit measured law → theorem: C(N,t)/|I| = ½·(t/N) + explicit corrections + remainder (Euler/Maclaurin of the tail). | TO-BUILD (data trigger D2) |
| G5 | Bookkeeping: 10⁷ final redundancy (running); list to 5–6×10⁶ (on-demand, M5); Lean E7a (M4, optional) | IN PROGRESS |
| G6 | Classical inputs to cite: RVM, functional equation, 25.2.12 product, ζ>0 on (0,1) (excludes real off-line zeros), trivial zeros. All READ/flagged CLASSICAL in FORMULAS.md | DONE (citation only) |

## 3. G1 sketch — the general shape of the RH proof (scaffold, re-openable)

### 3.1 The reduction (logical spine)

RH ⇔ **D(t) ≡ 0 for all t**, where D(t) := N_total(t) − N_on-line(t):

- **N_total(t)** = Riemann–von Mangoldt count of *all* zeros with 0 < Im ρ ≤ t.
  Definition-computable at every t (argument of ζ + θ; **no** zero-location input). CLASSICAL formula + MEASURED engine.
- **N_on-line(t)** = count of sign changes of Z(t) = e^{iθ}ζ(½+it). Definition-computable,
  finds on-line zeros only.
- Off-line zeros sit in the half-strip in pairs at equal height (from each 4-tuple), so
  D(t) is even; off-line content at height t₀ ⇔ D jumps at t₀. Real off-line zeros:
  excluded (CLASSICAL: ζ>0 on (0,1); trivial zeros negative even integers).
- **The proof problem**: show D(t) ≡ 0 without walking. The dt/dt2-stable walk verifies
  D=0 *at and between certified heights* — finite, and it is exactly what already
  happened (H2). The ∀t step is G1.

### 3.2 The three propositions (what a complete proof contains)

**(i) ON-LINE ⇒ DYNAMICS.** If all zeros ≤ t are on the line, then the definition-side
quantities W(t), S(t), 2K(t), onset(t/N) obey explicit *on-line laws* with a rigorous
remainder.
= Bridge (H3) + exact onset (G4) + rigorous tail (G3). Status: Stage-1 evidence exists;
the theorem is TO-BUILD. This is the main theorem-lifting work.

**(ii) OFF-LINE ⇒ JUMP.** Fix an explicit off-line 4-tuple {ρ, ρ̄, 1−ρ, 1−ρ̄} at height t₀,
δ = Re ρ − ½ ≠ 0. Then the definition-side quantities at s = ½+it₀ (and in a neighborhood)
deviate from the on-line laws by ≥ f(δ, t₀) > 0, f explicit.
Status: TO-BUILD lemma; difficulty LOW — it is an argument-principle computation for a
postulated explicit zero (per-factor arg/(1−s/ρ) contribution is elementary). The
numerical prototype is executable NOW with existing modules (D4): replace two on-line
factors in the 25.2.12 kernel by their off-line versions, measure the W/onset deviation.

**(iii) DYNAMICS = ON-LINE, ∀t.** The *actual* ζ's W/S/2K/onset obey the on-line laws at
every height.
Status: THE CRUX. Measured true to 10⁷ (H2+H3). A proof of (iii) at all heights is
exactly G1; no route below is chosen yet — §3.3 is the decision surface.

### 3.3 Candidate routes for (iii) (not chosen; data decides per §4)

- **Route A — prime oracle + uniqueness (project home turf).** Prove, for every s on the
  line, ζ(s) = kernel(on-line list to Im s) + T(G) + W_on(s) + R(s) with a rigorous
  |R| that stays *below* the (ii) floor f. Then: if a 4-tuple were off-line at t₀, (ii)
  forces |deviation| ≥ f at s with Im = t₀, contradicting the identity, which was proved
  from the definition (Riemann–Siegel) side + the zero-free-computable W, **not** from any
  assumption about zero locations. No height is "walked"; T drops out of the proof
  entirely.
  *Obstruction to size:* the A-scale margin — as t→∞ compare |W|-scale vs the pair
  contribution's scale (both O(1)-ish). The Stage-1 agreement (4 digits, quantified floor)
  is the evidence the margin exists; D1/D3/D4 measure whether it survives to height.
- **Route B — uniform dynamics bound (classical home turf).** Prove ∀t that 2K(t) is even
  / S(t) stays inside the on-line band (off-line tuples are exactly what put 2K-S outside
  it). This is an S(t)-program of the classical type: under RH one has S=O(log log t);
  unconditional known bounds are far too weak to exclude off-line content — the needed
  S-theorem is project-specific and TO-BUILD.
- **Route C — hybrid.** Walk to T (self-certified, done at 10⁷, extendable at cost),
  Route A or B for t > T. Honest fallback; still requires a (iii)-type statement above T.

Decision rule (scaffold): **A if D1/D4 show the margin holds; B if an S/2K universal
theorem becomes the live object; C always as the interim claim.**

### 3.4 What this attempt carries that is not in the literature (to our knowledge —
flagged INFERENCE, not a survey)

The Stage-1 bridge fact: a **4-digit, N-independent prime-side law** (the onset, onset at
t/N≈2) is *reproduced from the zero product* (25.2.12, on-line pair factors exactly real)
plus an analytic tail, inside a quantified error floor, at certified heights. That is a
concrete (i)-candidate with measured constants — the raw material Route A's lifting
theorem acts on.

## 4. What the data should tell us (re-open triggers)

| # | Measurement | Cost | Decides |
|---|-------------|------|---------|
| D1 | Onset N=10⁵ row at G ≳ 5–6×10⁶ (on-demand GPU walk, M5) | hours, scheduled | whether the G3 saturation model of the tail is right → Route A remainder feasibility |
| D2 | Onset fits **beyond** 4 digits (next correction terms) on the certified 3e5 list | small (list in hand) | the explicit correction shape for G4 |
| D3 | **W-audit** (new, small): at every certified height, W_measured(t) vs W_model(on-line list)(t); any spike = direct content. Sharper, more direct ghost probe than the 2K walk | small | first direct (ii)-type data on the actual ζ |
| D4 | (ii) prototype: explicit off-line pair in the kernel → measure W/S/2K deviation ⇒ f(δ,t₀) numerically | small | the Route-A margin (A-scale) at accessible heights |
| D5 | 10⁷ final redundant re-walk | running (~700 CPU-min at 01:00 EDT 2026-09-10) | closes H2; no scaffold change |

Rule: each D updates the status column of §3.3. If D1 or D4 shows the margin collapses
(or the tail error is not G3-modeled), Route A is retired and B/C take over. If D3 finds
a spike, everything stops and the spike is the new object.

## 5. Standing non-claims

- No `theorem: riemann`; no prize claim; credit framing as per README (owner conception +
  instrument co-development; AI disclosed).
- Certified numbers carry script + data provenance (P-0.9); no stale results cited.
- This file is a working plan-hypothesis, not a result. §3 is a scaffold to be falsified
  or refined by §4, not defended.
