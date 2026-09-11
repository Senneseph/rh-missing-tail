# PROVENANCE — `formal/rh-lean/` (machine-checked core)

**HOME AND SOURCE OF RECORD.** Since 2026-09-14 this repo
(`rh-missing-tail`) is where the Lean package **lives**.
`kainos-logos/scripts/rh-lean` is a **symlink into this directory**:

    kainos-logos/scripts/rh-lean -> ../../rh-missing-tail/formal/rh-lean

All daily work happens through that path; every file lives and is
committed here. (Older revisions of this document described a
one-way "copy-only mirror" scheme — superseded and wrong; the copy
scheme is what lost visibility of the B-3 work.)

## State at head (day-014, 2026-09-14)

- Toolchain: **Lean 4.33.1 (stable) + Mathlib 4.33.1** (pinned; no
  rc/nightly).
- **PROVEN and float-cross-checked:**
  - E7a — Euler action identity over any commutative ring
    (`RhAttack/EulerAction.lean`, `eulerAction`) + 5/5 oracle
    cross-check (`out_rhattack_day012.txt`).
  - B-4 — on-line pair identity, 4 parts + 16/16 float cross-check
    (`RhAttack/B4.lean`).
  - B-0 — counting equivalence, RH iff D = 0 (`RhAttack/B0.lean`).
  - B-5 CORE — `b5Ratio`/`b5Abs`/`b5NoffPos`/`b5PrefSign` + 12/12
    float cross-check (`RhAttack/B5.lean`).
  - B-2 — on-line tail bound (proven day-013; its Lean realization is
    §5 of B-3 — the explicit finite bound, B-2's M(G,t), finite-B form).
- **WIP:** B-3 Lean skeleton (`RhAttack/B3.lean`) — finite explicit
  tail bound + ζ-free residual decomposition. §1–§3 model
  definitions/derivatives/bounds and §7 `B3Float` cross-check
  (PASS) are in place; §4–§6 (finite Abel, smooth IBP, Kbar bound,
  explicit finite bound) are mid atomic-repair — 48 elaboration
  errors mapped, API pins in `ProbeJ/K/K2/K3.lean`.
- `Main.lean` wires the A/B gate (`lake exe rhattack`).
- `references/LEAN4-4331-QUICKREF.md` — the extracted 4.33.1 API
  quickref (permanent lookup: verified names, signatures, behaviors,
  pitfalls). `references/mathlib-4.33.1` → `.lake/packages/mathlib`
  (local symlink). `references/lean4-core-4.33.1/` — vendored Lean
  core source, **gitignored (local-only, 772 MB)**.
- `Bt*.lean`, `Probe*.lean` — standalone test files and
  API-pin-probes; the verified evidence behind the quickref.

## Build

    cd <this directory>          # or through the symlink
    export PATH="$HOME/.elan/bin:$PATH"
    lake build
    lake exe rhattack            # A/B gate: E7a, B-4, B-0, B-5, B-3
