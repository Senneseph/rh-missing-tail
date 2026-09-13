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

  **The 10⁷ closeout set (day-014; backs `results/certified-zero-survey.md` v1):**

  | file | produces / backs |
  |---|---|
  | `day006_early_rewalk.py` + `out_day006_early_rewalk.txt` | the independent CPU re-walk (10⁶, 1.4×10⁶] — 773,829 flips, dt/dt2-EXACT; dead chunk (10⁶, 1,000,128], Δ = 244 |
  | `day009b_zero_walk_1e5_6e6_gpu.py`, `day010_ext6e6_supervisor.sh`, `chain_verify_6e6.py` | the second engine: the 6×10⁶ GPU zero walk + supervisor + chain verification (its same-window count, 773,829, is the independent confirmation) |
  | `day005g_dt025_window.py` + `out_day005g_dt025.txt` | the tail re-walk (9.9×10⁶, 10⁷] — 227,197 = 227,197 EXACT |
  | `day014_dps45_arg1e7.py` + `out_day014_dps45_arg1e7.txt` | the dps-45 principal-arg parity layer at the four certified heights (both +244 and +246 families pass — recorded as the honest wall that parity cannot arbitrate them) |
  | `day005h_verify_1e7.py` + `day005h_mp.py` | the pre-staged M3 verifier, broken two ways, then fixed (companion) — the P-0.9 bug log entry |
  | `out_day014_dps45_d244.BUGGY-verified-gamma-arg.txt` | the broken verifier's first run, kept verbatim as provenance |

  (The 6×10⁶ list itself is a multi-MB data artifact of the working repo;
  the snapshot ships the scripts, not the list.)

  **The closure-audit set (day-020–023; backs the DISCOVERY_LOG 15–22
  records — the CLOSING pins, the re-pin, the P1.1 statistics, the
  PinCensus, the 1×10⁷ repair):**

  | file | produces / backs |
  |---|---|
  | `day020_worstcase.py` + `out_day020_worstcase.txt` | the all-band worst-case audit: the 112.6× region record at t = 1006.7916 (Closure.lean C7.1) |
  | `day020_xval_pin.py` + `out_day020_xval_pin.txt` | the Xval pin (206× headroom at t = 1000.0416; C7.2) |
  | `day021b_weakspot.py` + `out_day021b_weakspot.txt` | the 5×10⁴ weak-spot record (reclassified as the composite tail-model inflation asymptote; C7.4) |
  | `day021_c1b_dps.py` + `out_day021_c1b_dps.txt`, `day021_c1b_worstpoint.py` + `out_day021_c1b_worst.txt` | the C1b window-floor dps oracle + worst straddle point (the 0.9975 pin) |
  | `day022_worstcase_ext.py` + `out_day022_worstcase_ext.txt` | the day-022 re-pin record: verified-regime closing 34.68 @ t = 5009.2343 (C7.3) |
  | `day022_p11b_regime.py` + `out_day022_p11b_regime.txt` | the 10⁶–6×10⁶ regime bound (0.0% regime support — the statistic is blind ≥ 10⁵ at list scale 6×10⁶) |
  | `day022_p11c_corrected.py`, `day022_p11d_ownheight.py`, `day022_p11e_straddle.py` + outputs | the P1.1 statistics sequence: window-min → own-height → **best-straddle (the closure-faithful trend)**: 122 → 2.3 sound, crossing 1 at 3×10⁴ = the composite (B,∞) model-error boundary T* ≈ 2.5×10⁴ (DISCOVERY_LOG 21) |
  | `day022_scalefree_tripwire.py` + `out_day022_scalefree.txt`, `day022_tripwire_6e6.py` + `out_day022_tripwire_6e6.txt` | the verified-regime tripwires (scale-free decay; B(t) growth) — none fired |
  | `out_day022b_upperband.txt`, `out_day022c_upperband.txt` | the upper-band straddle audit records (scripts in the working tree) |
  | `day022_trivial0_probe.py` + `out_day022_trivial0_probe.txt` | the trivial-zero detector probe (retired as a detector — the own-height channel is 10³–10⁶× stronger; became the PinCensus below; DISCOVERY_LOG 21) |
  | `day023_pincensus.py` + `out_day023_pincensus.txt` | the PinCensus completeness audit: R_k ≤ O(−3.4×10⁻⁹…−3.5×10⁻⁷) for k = 1, 2, 3, 5, 10 — the 12,193,869-zero list independently certified (DISCOVERY_LOG 22) |
  | `day023_ext1e7_seg.py`, `day023_ext1e7_supervisor.py`, `ext1e7/` | the 1×10⁷ repair-list walk (32-way CPU, **running** at snapshot time; merges to `ext1e7/zeros_T10000000_ext_full.txt`, then PinCensus + P1.1e re-runs on the repaired list) |

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
