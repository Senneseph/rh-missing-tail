# PROVENANCE — `formal/rh-lean/` (machine-checked core)

**HOME AND SOURCE OF RECORD.** Since 2026-09-11 (move commit
`49663fe`) this repo (`rh-missing-tail`) is where the Lean package **lives**.
`kainos-logos/scripts/rh-lean` is a **symlink into this directory**:

    kainos-logos/scripts/rh-lean -> ../../rh-missing-tail/formal/rh-lean

All daily work happens through that path; every file lives and is
committed here. (Older revisions of this document described a
one-way "copy-only mirror" scheme — superseded and wrong; the copy
scheme is what lost visibility of the B-3 work.)

## State at head (day-015, 2026-09-11)

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
  definitions/derivatives/bounds and the float layer are in place; §4–§6
  are mid one-thing-at-a-time atomic repair — 48 → 30 elaboration errors
  (day-014/15), API pins in `ProbeJ–M, ProbeK2/K3/K4/K5.lean` (each probe
  carries a header naming what it pins and where it was ported). Not yet
  green; not imported by `RhAttack.lean` until it is.
- `Main.lean` wires the A/B gate (`lake exe rhattack`).
- Reference material lives in the working repo `kainos-logos/references/`
  (repo-split rule — the proof repo holds no toolchain copies): the pinned
  API quickref `LEAN4-4331-QUICKREF.md` (verified names, signatures,
  file:line sources against the pinned toolchain) and the
  `official-lean4-docs/` archive. The reproducible toolchain reference is
  the `lean-toolchain` pin (v4.33.1) + the gitignored `.lake/packages`
  cache; pinned-source greps resolve through it.
- `Bt*.lean`, `Probe*.lean` — standalone test files and
  API-pin-probes; the verified evidence behind the quickref.

## Build

    cd <this directory>          # or through the symlink
    export PATH="$HOME/.elan/bin:$PATH"
    lake build
    lake exe rhattack            # gate: E7a 5/5, B-4 16/16, B-5 12/12
                                       # (B-3 joins the gate when green)
