# scripts/ — reproduction (self-contained snapshot)

This folder is **self-contained**: every script cited by a `measured`
claim in `results/` is present here, so this repository can be read and
reproduced on its own without the larger private working project it was
grown from. It is a **curated snapshot**, copied (not linked) — the full
measurement project is bigger and more complex than what the staged
document needs, so only the referential subset ships.

## Layout

- `rh/` — Python / dps (mpmath) measurement + exact-identity scripts and
  their raw `.txt` outputs:

  | file | produces / backs |
  |---|---|
  | `day003_census_1e5.py` | the Day-3 census to 10⁵ (N, S, 2K, the zero list) |
  | `zeros_T100000.txt` | the 138,065 dps-certified zeros to t = 10⁵ (certified *data*) |
  | `day006_e7a_action_identity.py` | the exact Euler action identity (5/5, dps-50) |
  | `day006_e2_exact_m1.py` | the χ₅ / χ₁₃ exact-width M₁ tables (q = 5, 13) |
  | `day006_chi17_exact.py` | the χ₁₇ exact-width M₁ table (q = 17) |
  | `day006_cyclotomic_12_24.py` | τ₁₂ (2×4×3) + F₂₄ front/back raw |
  | `day006_fib24_rerun.py` | F₂₄ mean-centered M₁ (6-cut least-squares) |
  | `day007_psid3_fix_check.py` | the ψ‴ engine-audit fix (dps-verified) |
  | `day007_zero_at_dps.py` | the certified zero-finder dps tail |
  | `zeta_core.py` | the validated float64 Z(t) engine (Riemann–Siegel) |
  | `out_*.txt` | the raw dps outputs the tables quote, verbatim |

- `rh-ts/` — the TypeScript zero-finder stack (`n → ρₙ = ½ + iγₙ`): the
  Riemann–Siegel engine port, the Riemann–von Mangoldt bracket, the
  certified twin-floor walk, and the bisection — plus all tests. Strict
  functional lint: no `for`/`if`, one function per file,
  one-directional data flow.

## How to run

- **TypeScript** (the zero-finder): `cd rh-ts && npm install && npm run
  check && npm test` (Node 22, tsx; zero external dependencies).
- **dps (mpmath)**: the `rh/*.py` scripts run under mpmath
  (arbitrary-precision; see the header of each script for its `dps`).
  They are the exact-identity and high-precision oracles the
  float64 measurements are certified against.
- **Census / walks**: the 10⁵ census is reproducible from
  `zeros_T100000.txt` + `day003_census_1e5.py`. The large S(t) walk data
  (hundreds of MB) is **not** shipped; the figures derived from it are
  printed verbatim in `results/certified-zero-survey.md`, and the walk
  scripts reference that file by name.

## Provenance

Copied from the private working project (single source of truth for the
code) at the v0 snapshot. If you regenerate figures, they must agree
with the raw outputs here at the labeled precision — that agreement is
the dual-stack discipline the results pages rely on.
