# INDEX — the `docs/` table of contents

The proof-related documents of this repository. The measured raw
outputs behind every figure live in the working tree
(`kainos-logos/scripts/`); the paths cited throughout resolve from
there.

## Proof and argumentation

| Document | What it is |
|---|---|
| [RH-PROOF-OUTLINE.md](RH-PROOF-OUTLINE.md) | "The Riemann Hypothesis: A Path, and Its Current State" — the reader-facing mathematical exposition of the whole path and its current state, with full provenance for every number. |
| [RH-OUTLINE.md](RH-OUTLINE.md) | The staged proof scaffold: the outline with the per-piece status (mirror of the planning artifact; its source of record lives in the working tree — see the file header). A planning document, not a proof. |
| [THE-EULER-ACTION.md](THE-EULER-ACTION.md) | The Euler action identity — the flat-action (total-differential) reading of summation-by-parts, its recognition map into the zeta map (D = −P as edge flux; the M₁ width ladder as exact period-cell interior action; the onset as an edge-vs-zero budget crossing), with its measured results (E7a exact at dps-50; E2 exact width tables; E7b zero-side onset test). |

## Measured records

| Document | What it is |
|---|---|
| [zero-finder.md](zero-finder.md) | The certified zero finder: n → ρₙ = ½ + iγₙ, computed (walk-and-certify pipeline), with the honest precision statement. |
| [width-ladder-tables.md](width-ladder-tables.md) | The M₁ width tables (χ₅, χ₁₃, τ₁₂, F₂₄), the D = −P certificate, the drift coefficient, the onset ratio, the antipodal structure at the first even modulus. |
| [certified-zero-survey.md](certified-zero-survey.md) | The certified exclusion to 10⁷: N, S, 2K, twins, max\|S\| per decade, the walk-defect post-mortem; engine and precision labels on every figure. |
| [e7b1-detector-b5-core.md](e7b1-detector-b5-core.md) | The exact off-line pair kernel deviation (the E7b *detector* half of the zero-side bridge): an EXACT formula plus a 6-digit measurement in the certified kernel context. |

## Machine-checked core

- [../formal/RH-LEAN-PROVENANCE.md](../formal/RH-LEAN-PROVENANCE.md) —
  home, source of record, and sync rule for the Lean package in
  `formal/` (the proof files themselves: `formal/RhAttack/`, the `rhattack`
  gate — one-command verify: `cd formal/ && lake build && lake exe
  rhattack`).
