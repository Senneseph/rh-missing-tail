# PROVENANCE — `formal/rh-lean/` (machine-checked core)

**MIRROR — a certified artifact, planning-adjacent.** Source of record:
`kainos-logos` `scripts/rh-lean/`, repo head `eaa7a7f` (2026-09-10).
Synced 2026-09-10. **No edits here** — updates propagate only by
explicit copy from the source repo — never edited locally.

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
   (**CROSS-CHECK PASS 5/5, worst deviation 2×10⁻¹⁴** vs dps-20).

This upgrades the identity's status from "verified at 50 digits in
Python" to **machine-checked**: the statement is a theorem of Lean, and
the numeric layer is an independent implementation agreeing to
float64-level. Nothing here touches zeros, RH, or analytic statements.

## Run it yourself

`formal/rh-lean/README.md` has the full instructions; in short:

```sh
# one-time: install elan + Lean 4 (https://www.lean-lang.org)
cd formal/rh-lean
lake build          # fetches the prebuilt Mathlib cache (minutes)
lake exe rhattack   # prints the 5-instance cross-check table + PASS line
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
