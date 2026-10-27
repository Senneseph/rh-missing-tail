# ORBITAL / TWO-BODY SIDE-QUEST — the two representations as a bound system

- Date: 2026-10-26
- Status: **OFF-BOARD** (exploratory; tracks its own file; does NOT block the
  RH Final Solution critical path; no RH claim — ever)
- Owner request: explore the "orbital mechanics" reading as far as it makes
  sense: the interaction between the two representations (zero-ensemble /
  zeta-side vs prime-coverage / sieve-side) — how they influence each other
  "in their dance," maybe taking turns to decide the overall rhythm, evolving
  harmonically, with a "strangely defined" shared law — perhaps the **Euler
  action for both** — or a fact of the **two-body problem** type solving part
  of it.

## 1. The honest map (metaphor → named object → status)

Discipline: every row is tagged PROVEN / MEASURED / HEURISTIC / UNMAPPED.
Metaphor rows are allowed **only** when they point at a named object.

| orbital language            | object in the program                                                                  | status     |
| --------------------------- | --------------------------------------------------------------------------------------- | ---------- |
| the two bodies              | zero ensemble {ρ} (zeta side)  and  prime-coverage action on [1,x] (sieve side)         | both finite/enumerable: proven 0175-0184 (sieve side); zeta side via E1/S-series |
| the dance / one system, two representations | Riemann–von Mangoldt explicit formula (spectral trace = geometric trace, shared test potential) | real theorem, off-board; Lean machinery exists (see O2) |
| Euler action for both       | primes act on [1,x] by coverage (the repo's Euler action, 0180 phi_list); zero side acts through the explicit-formula kernel; a **shared finite trace operator T(φ)** with T_zeta(φ) = T_sieve(φ) + named residual is the named goal | UNMAPPED (O2) |
| center of mass              | main term: x (zeta side), x·V(z) (sieve side)                                           | PROVEN decompositions (E1 clauses, U4b L1/U2) |
| relative coordinate         | residual: ψ(x)−x type (zeta); Φ−(sieve main term) (sieve); per-level L_k/U_k slacks     | MEASURED (U1b, 0181); U1c = the two-process relative coordinate |
| energy conservation         | total mass conserved across levels = Legendre exact identity (0180)                     | PROVEN in-tree |
| virial / stability band     | level-1 sandwich L1 ≤ Φ ≤ U2; width W = U2−L1 = pairwise mass exactly                   | PROVEN in-tree (0183 `level1_sandwich`; 0184 `level1_width_eq_pairwise`: the width mass identity is now a theorem); measured on 66 rows (0181) |
| adiabatic invariant / phase | band position ρ = (Φ−L1)/W: x-stable to ~1e-6, smooth monotone decay in z (0181)        | MEASURED (0181); in-tree 0184 `level1_position_in_band` names its home (0 ≤ Φ−L1 ≤ W) |
| two-body integrability      | pair/level-1 structure: fully exact, finite, no approximation                            | PROVEN (0180, 0183, 0184) |
| three-body chaos onset      | twin/triple prime correlations; U3/U3b gap-class: model explicit HEURISTIC; naive pair-bias composition ruled out (U3b) | MEASURED + HEURISTIC |
| turn-taking rhythm          | sieve: odd/even level alternation (inclusion–exclusion parity); zeta: e^{iρt} oscillation in t   | baseline measured (0185): the two IDENTITY residuals are at different scales (one is roundoff at the dps floor, the other exact structure) - naive turn-taking ruled out at this level; the dynamical variant needs a measured zeta-side datum, O1 open |
| harmonic evolution          | "always harmonically evolves" = stability statement of the relative coordinate under x- and z-evolution | candidate statement: see O4; not yet measured as a joint law |

## 1b. The two-body reduction, made concrete (exploration)

> The owner's question: can the interaction between the two representations
> be read as a bound two-body system — the two "bodies" taking turns to
> decide the overall rhythm, evolving harmonically, with a shared law (a
> "Euler action for both")?

**Step 1 — the only real "interaction" is the explicit-formula duality.**
There is no force, no potential, no Hamiltonian in these systems. The one
object where the two ensembles genuinely meet as *equal terms of one
identity* is the Riemann–von Mangoldt explicit formula (Weil form), for an
even test function h analytic in a strip:

    Σ_ρ  h(γ)                        [SPECTRAL side: the zero ensemble]
    = Σ_p Σ_{m ≥ 1} (log p) h̃(m log p)
                                            [GEOMETRIC side: prime powers]
      + (trivial-zero + pole-at-1 + γ/π archimedean terms)

(ρ = 1/2 + iγ; h̃ is the Fourier–Mellin transform of h.) The same kernel h
samples the zeros on one side and the prime powers on the other. **This IS
"the Euler action for both"** — one object, one law, two bases. It is a
real theorem, not an analogy. (Selberg's trace formula is the same
structure for a hyperbolic surface: trace over Laplace eigenvalues = sum
over closed geodesics; zeros ↔ eigenvalues, primes ↔ geodesics.)

**Step 2 — the coordinate correspondence (what maps to what).**
| orbital quantity   | object                                                          |
| ------------------ | --------------------------------------------------------------- |
| body A             | the zero ensemble {ρ}                                           |
| body B             | the prime ensemble / sieve survivors                            |
| the shared law     | the explicit-formula kernel h (the test function)               |
| center of mass     | the main term x (from the pole at s = 1); sieve main term x·V(z) |
| relative coord (A) | R_ζ(x) := ψ(x) − x = −Σ_ρ x^ρ/ρ − (small)                        |
| relative coord (B) | R_sieve(x,z) := Φ(x,P(z)) − x·V(z)                              |
| conserved/adiabatic| the level-1 band position ρ(x,z) (x-stable to ~1e-6 — 0181)      |
| the relaxation var | z (sieve depth): W/xV grows and ρ decays as z grows — 0181        |
| the "rhythm" (A)   | the zero oscillation x^γ (frequency = Im ρ)                      |
| the "rhythm" (B)   | the sieve remainder fluctuation / prime-gap modulation           |

**Step 3 — the honest honesty: A and B are DIFFERENT objects.**
R_ζ(x) is a sum over zeros (driven by the spectrum of ζ). R_sieve(x,z) is
a count of z-sieved integers whose fluctuation comes from a *different*
mechanism (the combinatorics of small-prime divisibility, the inclusion–
exclusion remainder). There is **no automatic identity** between them.
So the "dance" reading is *not* given; it is a **hypothesis**: that the two
residuals, though different objects, are *correlated* because both ultimately
live on the same prime data. That hypothesis is the entire physical content
of the orbital picture — and it is **falsifiable**.

**Step 4 — the sharp, falsifiable core of the whole side-quest.**
> **Hypothesis ORBITAL.**  The zeta-side residual R_ζ(x) and the
> sieve-side residual R_sieve(x,z), computed at fixed z as functions of x
> over a range, are cross-correlated with a measurable, non-decaying
> structure. If they are uncorrelated (coefficient → 0 as x grows), the
> two-body reading is pure metaphor with zero content; if correlated, the
> "shared Euler action" (the explicit-formula kernel) has a concrete,
> measurable signature.

This reduces the entire "dance / rhythm / two-body" intuition to **one
measurable question** — which is exactly the mainstream **U1c** two-process
zeta/sieve residual harness. The side-quest does not add a new program; it
names what U1c is *measuring* in the language of the shared action. O1 is
therefore "run U1c and read the correlation in the orbital vocabulary."

**Step 5 — what the "harmonic evolution" claim does and does not say.**
- "Always evolves harmonically" → **measured, not assumed**: at level 1
  the count always sits inside the band (L1 ≤ Φ ≤ U2, 0 violations on all
  66 rows of 0181), and its *position* ρ is x-stable. That is a harmonic
  / bounded-evolution statement for the sieve body, **proven at level 1**.
- It says **nothing** a priori about the zeta body's residual or about the
  *joint* (A,B) evolution. The joint harmonic claim is precisely hypothesis
  ORBITAL. Do not conflate the (proven) single-body band containment with
  the (open) two-body correlation.

**Step 6 — where "two-body" is genuinely right and where it stops.**
- Genuinely two-body (integrable): the **pair** structure — one integer n
  with one prime divisor relation, the off-diagonal F×F count,
  `m(n)(m(n)−1)`, the level-1 band. Exact, finite, machine-checked target
  (`level1_sandwich`). The two-body problem is solvable because it reduces
  to a relative + center-of-mass coordinate — and so does the level-1 sieve
  (main term + pairwise remainder).
- Where it stops (three-body → chaos): once three or more small primes
  act on n (twin/triple correlations), integrability breaks; this is the
  U3/U3b region where we go heuristic and the naive pair factorization is
  ruled out. **The two-body solvability and the three-body chaos onset are
  real structural facts about the sieve hierarchy**, and the orbital picture
  recovers the standard integrability→chaos intuition correctly. That is the
  deepest place the metaphor earns its keep.

## 2. Real theorems that anchor the side-quest

1. **Explicit formula as the shared action.** The Riemann–von Mangoldt
   explicit formula is the literal "same trace in two bases": sum over zeros
   + archimedean terms = sum over primes (+ pole term), for a test function.
   The Selberg trace formula is the same structure for closed geodesics.
   Nothing in the program yet uses it as an object; that is O2.
2. **Center-of-mass / relative-coordinate reduction (two-body theorem).**
   Newtonian two-body ⇒ one relative degree of freedom + free CM motion.
   The program already performs this reduction: main term + residual, at
   every stage (E1, S-series, U1b, 0181). The side-quest borrows the reading,
   adds no new proof work.
3. **Integrability threshold.** Two-body = integrable = our exact region
   (pair structure, level 1). Three-body = non-integrable in general = our
   first heuristic region (U3/U3b). The threshold lands *exactly* where the
   program first lost exactness. (Structural observation, not a theorem.)
4. **Lean anchor for the zeta-side kernel.** A 2025 Lean 4 + Mathlib
   formal-verification project of RH-related results (explicit-formula
   machinery, RH as a verifiable condition) is public. **Provenance rule:
   pointer is not provenance — before any adoption, fetch the repo,
   identity-check the commit, record it here, and replay the needed
   statements locally.** (Do not cite names/details from memory.)

## 3. Named forward path (side-quest units)

- **O1 = U1c (shared, not new).** The two-process zeta/sieve residual
  harness *is* the relative-coordinate measurement. Run it on the orbital
  reading: ρ_rel(x) = joint statistic of (sieve residual at x,z) and
  (zeta-side residual at x). x-sweep × z-sweep; exact integers; no RH claim.
  **RUN (0185, 2026-10-26, `scripts/rh/kcs1c_two_process.py`, 58 s wall, raw
  table `tmp/kcs1c_out.txt`):** both processes on the same input χ at the same
  edge x; sieve side EXACT at z = 31 (Φ remainders vs xV: 11.5/19.8/12.2/0.514
  at x = 1e4…1e7; the χ3/χ5 variants bounded exact integers, measured range
  {−9,…,11}); zeta side = the C-channel E7a action identity at s = 1/2 + it,
  t ∈ {10,100}, x ≤ 1e6, dps 30. **Baseline finding (recorded honestly):**
  the dps sweep at one edge shows the zeta-side identity residual tracks the
  precision exactly (1.09e-11 at dps 10 → 6.68e-52 at dps 50, i.e. O(10^{-dps}))
  — it is pure roundoff, NOT a dynamical quantity — while the sieve-side
  residual is exact and structurally O(1)…O(20) vs xV. The simplest
  turn-taking reading of the two *identity* residuals is therefore ruled out
  at this level. O1's corrected next step: take the zeta-side component to be
  a MEASURED zeta datum (E1/S-series residual type, the mainstream's own
  residual), and cross-correlate it with the exact sieve residual at matched
  (x, z). The raw ratio log is recorded as the O1 input.
- **O2 (off-board, formal).** State + prove a named finite explicit-formula
  identity in Lean for one explicit test function; cite (fetched +
  identity-checked) the 2025 Lean verification project as API anchor.
  This is the "Euler action for both" in theorem form. Precondition now met
  (U4c green 0184, U1c run 0185) - still OFF-BOARD: start only when the main
  program names it.
- **O3 (borrowed).** The level-1 virial band. Already the mainstream
  `level1_sandwich` unit — the side-quest re-uses it, adds no work.
- **O4 (measurement, cheap) — FOLLOW-UP MEASURED (0189, 2026-10-26,
  `scripts/rh/o4_band_phase_sweep.py`, `tmp/o4_out.txt`).**  The 0181
  phase table extended to z in {31, 50, 71, 100, 200, 400} at fixed
  x in {2e5, 1e6, 1e7, 1e8, 1e9, 1e10} (exact integers, the in-tree
  SieveOrbit definitions; 0.3 s wall):
    (1) THE BAND DOES NOT TIGHTEN: the relative width W/Φ GROWS in z -
        6.56 (z = 31) -> 20.35 (z = 400) at x = 1e10 (x3.1 over the
        sweep), for every x; deeper sieves widen the level-1 band
        relative to the count;
    (2) the in-band position rho = (Phi - L1)/W drifts DOWN slowly in z -
        0.7166 -> 0.6083 (x = 1e10) - no sign of settling by z = 400;
        at fixed z it is x-STABLE (spread over x <= 2.2e-3 - the 0181
        x-stability law persists at depth, degrading only mildly);
    (3) at z = 400 the first VISIBLE SPLIT between the main-term width and
        the count-based width appears: W/(xV) = 20.3414 vs W/Phi =
        20.3517, i.e. Phi = 0.99949 * xV - a 5.06e-4 deficit of the exact
        count from the main term, invisible in the widths until depth
        (the classical sieve error drifts in z; the band phase resolves
        it to relative 5e-4).
  MEASURED only; no assertion of a law; no RH claim; OFF-BOARD.
  Optional deeper follow-up (named, not done): z beyond 400 with the same
  memoized recursion - diminishing returns.

## 4. Open conceptual questions (the "strangely defined" law)

- Is there a finite "Lagrangian" L(n, ω; φ) such that both traces are
  sums of the same kernel over different lattices? (Explicit formula
  suggests yes at the formal level; the finite exact version is the
  open question.)
- Is the level index k playing the role of time, with the band position
  ρ(k) a conserved/adiabatic quantity? (0181 is level 1 only — a level
  ladder would test this; cost: higher-level exact counting.)
- Does the parity alternation (level k ≡ 0/1 mod 2) couple to a phase that
  the zeta-side residue carries? (This is the turn-taking question;
  O1 measures the raw version.)
- Where does integrability-break show up in numbers: is the U3b
  triple-correlation excess a "chaotic residual" with a scale? (U3b data
  exists; reinterpretation only.)

## 5. Rules for this file

- OFF-BOARD: nothing here may gate or delay the mainstream map.
- Provenance: every borrowed theorem/fact gets (source fetched, commit/URL,
  local replay) before it is "adopted."
- No RH claim in this file or in anything it spawns.
- Every unit O1..O4 that produces a number or theorem gets a discovery-log
  entry and this file updated in the same commit.
