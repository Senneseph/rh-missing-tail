# PROVENANCE — `formal/rh-lean/` (machine-checked core)

**MIRROR — a certified artifact, planning-adjacent.** Source of record:
`kainos-logos` `scripts/rh-lean/`, repo head `9620ff4` (2026-09-10,
day-011 Phase 2 B-4 closeout). Synced 2026-09-10 (twice — the v1.1
mirror at `eaa7a7f` was extended the same day). **No edits here** —
updates propagate only by explicit copy from the source repo — never
edited locally.

## What it is

A Lean 4.34 + Mathlib package that

1. **proves** the Euler action identity (E7a — the exact
   summation-by-parts identity, README §Abstract of this repo) over
   *any* commutative ring, for all step paths and all heights:
   `formal/rh-lean/RhAttack/EulerAction.lean`, theorem `eulerAction`;
2. **cross-checks** the five certified oracle instances (χ₅ at three
   heights, an LCG ±1 path at two) two ways: an exact-integer `#eval`
   layer (all ten recorded partial-sum values) and an independent Lean
   float64 re-implementation of the left side against the Python
   oracle values — recorded run: `formal/rh-lean/out_rhattack_day011.txt`
   (**CROSS-CHECK PASS 5/5, worst deviation 2×10⁻¹⁴** vs dps-20);
3. **proves the B-4 on-line pair identity** in four pieces
   (`formal/rh-lean/RhAttack/B4.lean`): T1 `pairClosedForm` — the two
   DLMF-25.2.12 on-line factors for a certified zero height γ collapse
   *exactly*, for all γ,t > 0, to a real signed prefactor times one
   exponential: F_ρ1·F_ρ2 = (γ²−t²)·Bv(γ)·e^{s·Bv(γ)}, s = ½+it,
   Bv(γ) = 1/(¼+γ²) (holds even at t = γ); T2 `pairLogAbs` — the
   log-magnitude in the ledger's verbatim form; T3a `pairArgAngle` /
   T3b `pairArLedger` — the additive phase, exactly mod 2π (stated in
   the branch-cut-free circle type `Real.Angle`, and in ℝ with an
   explicit 2πℤ multiple), t ≠ γ. Plus a PART-4 float64 cross-check on
   the 16 recorded points: the ledger closed form vs a direct
   float64 fac-product evaluation — **16/16 PASS, worst dLa ≈ 8.5×10⁻¹⁴,
   dAr ≈ 4.4×10⁻¹⁶** (the predicted double-roundoff scale; the record
   is cross-validated independently at dps-25 in the source repo).

This upgrades the identity's status from "verified at 50 digits in
Python" to **machine-checked**: the statements are theorems of Lean,
and the numeric layer is an independent implementation agreeing to
float64-level. The B-4 theorems are the *per-pair factor* of the
zero-side bridge (E7b) as a certified artifact — they are statements
about the DLMF-25.2.12 factors evaluated on the critical line, not
about the zeros of ζ, RH, or analytic continuation.

## Run it yourself

`formal/rh-lean/README.md` has the full instructions; in short:

```sh
# one-time: install elan + Lean 4 (https://www.lean-lang.org)
cd formal/rh-lean
lake build          # fetches the prebuilt Mathlib cache (minutes)
lake exe rhattack   # E7a 5-instance table + B-4 16-point table + PASS lines
```

No GPU, no mpmath, no network beyond the Mathlib cache.

## Path notes (the mirror vs the working tree)

The mirrored `README.md` and `.lean` headers cite provenance paths
(relative to the **kainos-logos working tree**, the project home):
`plan/40-prize-islands/rh-attack/FORMULAS.md` §2.1 (the identity's
ledger entry), `scripts/rh/day006_e7a_action_identity.py` (Python
oracle, dps-50 residuals), `scripts/rh/out_day011_e7a_oracle20.txt`
(dps-20 port values). In this repo the same record is summarized in
README §Abstract (the identity) and `references.md`. The copy in
`formal/rh-lean/` is byte-identical to the working tree at sync time,
save one deliberate omission: the `.github/` CI scaffolding (its
placement here would install a build hook on this repo; the working
tree keeps it). If a path above is unresolvable
here, it resolves from the working tree root, per this repo's
Materials policy.

## Claim policy

Certified artifact, no claim: a proof of a finite identity + a
reproducible cross-check. It is evidence for the stage-1 program
(README §program), not a result about RH.
