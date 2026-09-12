# PROVENANCE — `formal/` (machine-checked core)

**HOME AND SOURCE OF RECORD.** The Lean package **lives in this
repository** (`rh-missing-tail`), with `formal/` as the package root
(flattened from `formal/rh-lean/` on 2026-09-12 — no sub-directory).
`kainos-logos/scripts/rh-lean` is a **symlink into this directory**:

    kainos-logos/scripts/rh-lean -> ../../rh-missing-tail/formal

All daily work happens through that path; every file lives and is
committed here. (Older revisions of this document described a
one-way "copy-only mirror" scheme — superseded and wrong; the copy
scheme is what lost visibility of the B-3 work.)

## State of the tree (2026-09-12)

- **Toolchain:** Lean **4.33.1 (stable) + Mathlib 4.33.1 pinned** (no
  rc/nightly); the pin is `formal/lean-toolchain`.
- `formal/RhAttack.lean` — root module; imports every piece below, with
  the day-attributed history.
- `formal/RhAttack/` — the pieces, all green and imported:
  `EulerAction.lean` (the E7a Euler action identity over any
  commutative ring), `E7a.lean` (the five certified oracle instances),
  `B0.lean` (counting equivalence, RH iff D ≡ 0), `B3.lean` + pieces
  `B3Core/B3Abel/B3Sbar` (the B-3 bridge: finite exact Abel
  decomposition, RVM comparator, explicit finite bound, ζ-free
  residual decomposition), `B4.lean` (on-line pair identity, four
  parts), `B5.lean` (B-5 core exact ratio theorem), `P4Em.lean` (P4
  1st-order Euler–Maclaurin, verbatim port of a published proof),
  `P4Tail.lean` (P4 per-period 2nd-order identity), `P4Em2.lean`
  (P4 global finite 2nd-order law).
- `formal/Main.lean` — the `rhattack` gate executable (E7a 5/5, B-4
  16/16, B-5 12/12, B-3 A/B checks at float64 vs the committed record).
- `formal/out_rhattack_day01{1,2}.txt` — the committed records of the
  last green gate runs.
- **Not in this repository** (by the repo-split rule — this repo holds
  only the proof output): the Lean syntax probes / scratch recipes
  (`Probe*.lean`, `Bt*.lean`) — day-to-day double-checks, not proofs;
  they live in the working tree
  `kainos-logos/scripts/rh-lean-probes/` (pass/fail state at creation
  recorded in the day journals). All internal progress tracking
  (day journals, specs, prompts) likewise lives in the working tree
  `kainos-logos/plan/40-prize-islands/rh-attack/`.
- Reference material lives in the working repo
  `kainos-logos/references/` (repo-split rule — the proof repo holds no
  toolchain copies): the pinned API quickref
  `LEAN4-4331-QUICKREF.md` (verified names, signatures, file:line
  sources against the pinned toolchain) and the `official-lean4-docs/`
  archive. The reproducible toolchain reference is the `lean-toolchain`
  pin + the gitignored `.lake/packages` cache; pinned-source greps
  resolve through it.

## Build

    cd formal/                  # or through the working-tree symlink
    export PATH="$HOME/.elan/bin:$PATH"
    lake build
    lake exe rhattack           # gates: E7a 5/5, B-4 16/16, B-5 12/12,
                                # B-3 A/B (record above)
