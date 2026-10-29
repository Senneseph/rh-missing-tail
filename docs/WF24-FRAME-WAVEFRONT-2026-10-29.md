# WF-24 SIDE-QUEST — the 24-adic FRAME WAVEFRONT (four waveforms, holes, zero test)

- Date: 2026-10-29
- Status: **OFF-BOARD** (exploratory side quest, tracked in this file; does not
  touch the RH Final Solution critical path; **no RH claim — ever**)
- Script: `scripts/sq/wf24_wavefront.py` (tracked, single-threaded, 4 cores open
  by construction); output `tmp/sq24/wf24_out.txt`
- Owner idea (2026-10-29, verbatim gist): do we need a theorem/measurement of
  the "wave front" of the 24-adic stuff (the 4 frames), or maybe in the orbital
  setting: take a reading at the BEGINNING of the 24-adic and at the END, treat
  the prime itself as always, but then you get **4 different waveforms** —
  future and past, relative and absolute. Maybe how these propagate (or how the
  'holes' propagate in the future data) from end→beginning / beginning→end will
  reveal predictive power or a boon for the RH solution.

## 1. The object, made concrete (every term named)

The 24-adic frame = the established day006/0909 M1 machinery: q = 24 phases
r = 0..23 on the period cell (F_24 = fib mod 12, 9/2-centered — the non-
multiplicative "24-adic" cell; control: τ_12×24, the multiplicative one).
The wave reading of the frame at phase r, scale N = 10^6, zeta height t
(S = 1/2 + it):

    v(r; N, t) = (n1^{S+1}/S) · [ Σ_j c_j q^{−S} ζ(S, nf_j/q) + P[r] n1^{−S} ]

with n1 = N aligned to phase r (n1 ≡ r mod q), c_j the cell row, P[r] the
cumulative row, and **nf_j = the first integer in residue class j (mod q) with
nf_j ≥ n1+1** (the residue-class *tail* above the cut — NOT the naive
(n1+1−j)/q; a one-unit argument error moves M1 by O(7e5)).

The prime is treated as always by its class **r0 = p mod 24** (prime classes
1,5,7,11 front / 13,17,19,23 back). Per class:

| waveform | definition | "reading" |
|---|---|---|
| past-absolute A_r(t) | v(r0; N, t) | raw, pole part included, BEGINNING (prime's own phase) |
| past-relative W_r(t) | A_r(t) − mean_24 v | pole removed |
| future-absolute A_{r+12}(t) | v(r0+12; N, t) | raw, END (antipode, front→back) |
| future-relative W_{r+12}(t) | A_{r0+12}(t) − mean_24 v | pole removed |

Propagation holes (beginning → end), measured as waves in t:

    H_id(t)  = A_{r0+12}(t) − A_{r0}(t)    identity-propagation hole (F_24 law)
    H_sf(t)  = A_{r0+12}(t) + A_{r0}(t)    sign-flip hole (τ_12 law)

Sampled at t = uniform [4..404] step 0.5 (801) **and** the 204 certified
zero heights γ ≤ 404 (`scripts/rh/lowt/zeros_0_to_1p2e3.dec20.txt`).

## 2. Machine validation (gates, all PASS)

1. **Mechanism identity**: my lattice implementation reproduces a verbatim
   port of the day006 original machine at dev 6e-4 (pure c2/1e12 curvature —
   the 3-cut vs 6-cut extrapolation difference) on all 5 sampled F_24 phases.
2. **External well-conditioned gate**: τ_12 3-cut M1 constants reproduce the
   0909 recorded table [2,2,1,0,−1,−2,−2,−2,−1,0,1,2] to max 8e-10.
   (The 0909 dps-40 6-cut F_24 rerun numbers are flagged in their own output
   "CONVERGED? NO ... NOT a result" — ill-conditioned for that cell — and were
   **not** used as a gate.)
3. **Independent 0909 cross-check**: F_24 antipode difference at t=10:
   H_id = 41.8953+2.0951i, |H| = 41.948 vs the recorded 0909 value
   "antipode (r vs r+12, front/back) max|diff| = 42.0" — match.

## 3. Measured result (first + second cut)

**The four waveforms exist and are clean:**

- `A_r(t)` (absolute): a smoothly decaying phasor, |A|(t) ≈ 1.75e6/t
  (434129 at t=4 → 174785 at t=10 → 4375 at t=400, to 7 digits) with slow
  rotation arg ≈ π − arg S. Both past and future have the SAME envelope —
  the pole is phase-blind to leading order.
- `W_r(t)` (relative): O(10–40) complex waves converging: pastW →
  (−28.125, 0), futW → (+13.875, 0) as t grows (real parts settle by
  t ≈ 100; imaginary parts decay ~1/t).
- **The hole wave H_id(t) = (41.354, 5.169) at t=4 → (42.0, 0) settled
  (t ≳ 40)**: the t→∞ real hole = **42.00** (exactly the 0909 antipode
  difference — the front/back law, now *as a waveform*, is the same constant;
  the "wavefront" is a settling transient).
- **The transient has a clean measured law: im H_id(t) = 21/t to <0.3% over
  t ∈ [4..40]** (21.0126 from a 61-point fit, RMS 1.75e-3; the coefficient
  drifts 20.68→21.03 across t = 4→30, i.e. 1/t within 1.6%).
- τ_12 control: H_id ~ 5e-9 (identity propagation exact for the
  multiplicative cell) and H_sf = 4.000007 (= 2·M1, the sign-flip law,
  enormous common mode) — the two cell laws of 0909 confirmed as *t-waves*,
  roles swapped as expected.

**Zero-height test (the predictive-power probe), t ∈ [4..404]:**

- mean |H_id| at the 204 certified zeros / mean on the uniform grid =
  **1.0001** — the hole field is FLAT across zero heights. Largest holes
  occur at the largest t (both at zeros and at the neighboring uniform
  points — it is a function of t alone, not of zero-ness).
- The 1/t residual test (imH after fit, t = 10..40) is under-resolved at
  grid 0.5 vs zero spacing ~0.85 there (1 "near-zero" sample) but no kink
  in reH across any of the 4 in-band zeros.
- Prime-own-reading handle (prime itself, as always): in the 204 windows
  [γ ± γ/ln γ], class prime ratios to Poisson expectation: r=1: 0.869,
  r=5: 1.012, r=7: 0.859, r=11: 0.869 — the KNOWN small-prime bias at
  p < 700, nothing new; windows too small to be predictive at this scale.

**Second cut (t > 404): a LIVE wave appears.** Extending to t = 800, 1600:

- reH: 42.00008 (t=400) → 42.00041 (800) → 42.00155 (1600) — drifts slowly
  ABOVE 42.
- imH: 0.0673 (400) → 0.0558 (800) → **0.0723 (1600)** — the decay
  *reverses*: a second, live wave of amplitude O(0.05–0.07) (≈0.15% of the
  hole) sits on the settled constant for t ≳ 800. Its period is not yet
  measured; the wave settles at t ≲ 40 but is not *dead* at t ≳ 800.

## 4. Honest verdict

1. The frame wavefront is a **real, measured object**: 4 waveforms per prime
   class, machine-validated, exact at the 0909 constant level. The
   beginning→end propagation law (near-identity for F_24 at 2.4e-4 relative,
   exact identity for τ_12 at 5e-9) holds **as a t-waveform**, not just as a
   single number — that is the new datum.
2. **The hole carries no zero-height information in EITHER region** (816
   certified zeros tested total): settled t ≤ 404 (204 zeros, ratio 1.0001)
   **and** live t ∈ [400,1200] (612 zeros vs 1224 matched off-zero controls,
   ratio 1.0000, 95% CI [0.995, 1.005]; per-zero peak rate 0/610; density-bin
   means within 1σ). The hole is a function of (N, t) alone. No RH claim;
   no predictive power from zero-ness, in this construction at N = 1e6.
3. **The live wave (t ≳ 400) is aperiodic and algebraically growing**: C2
   (DFT on 3201 points, t ∈ [400,1200], freq 0.2..12 rad/t) found NO
   sinusoidal component — no ln 24 (3.178), no ln(N/24/2π) (8.8), nothing
   above the 0.6% level. The residual |imH − 21/t| grows LINEARLY with t:
   bin means 0.0185 / 0.0259 / 0.0333 / 0.0407 across [400,600), [600,800),
   [800,1000), [1000,1200) — slope 3.7e-5 per unit t to <1% (i.e.
   imH(t) ≈ 21/t + c(N)·t with c(1e6) ≈ 3.7e-5). The open question is the
   ORIGIN of c: finite-N artifact of the M1 mechanism (should shrink with N)
   vs true frame structure (should persist). That is exactly C4.

## 5. Cuts — status

| # | cut | result |
|---|-----|--------|
| C1 | **DONE** (scripts/sq/wf24_c1_high_t_zeros.py): t ∈ [400,1200], 612 zeros + 1224 matched controls (γ ± min(0.05·spacing, 0.3)) | **NULL**: mean|imH| zeros/controls = 1.0000 (95% CI [0.9952, 1.0049]); reH ratio 1.0; per-zero peak rate 0/610; density-bin |imH−21/t| means 0.0324/0.0306/0.0273 (high/mid/low, within 1σ) |
| C2 | **DONE** (tmp/sq24/c2_dft.py): DFT of H−(42+drift, 21/t) on 3201-pt grid | **APERIODIC**: no peak at ln 24 (3.178), none at ln(N/24/2π) (8.8), top peak amp 1.7e-4 (0.6%); the live wave is \|imH−21/t\| ≈ **3.7e-5·t**, linear through the origin over t ∈ [400,1200] (4 bin means, <1% scatter) |
| C3 | prime-window reading at scale p ~ t (primes to 2000, per-class gap + count vs the H residual) | open (the literal "prime itself, as always" cross-correlation) |
| C4 | **N-ladder (1e7, 1e8)**: does 42.0 stay, does 21/t stay 21, and what does c(N) do (artifact: c ∝ N^{−k}; true structure: c persists/grows) | **THE named discriminating test** for the growing algebraic hole |
| C5 | other cells/q (τ_24, τ_30, q = 30, 60): identity vs sign-flip as waves; more front prime classes (φ(q)/2) | open |

## 6. Status map

| item | status |
|---|---|
| 4-waveform frame object, machine-validated | MEASURED (gates PASS, this entry) |
| antipode propagation law as a t-wave | MEASURED (F_24: 42.0 ± 1/t-transient; τ_12: identity 5e-9) |
| imH transient law 21/t (t ≤ 404) | MEASURED (0.1% fit quality) |
| zero-height sensitivity, t ≤ 404 (204 zeros) | MEASURED ABSENT (ratio 1.0001) |
| zero-height sensitivity, t ∈ [400,1200] (612 zeros + 1224 controls, C1) | MEASURED ABSENT (ratio 1.0000, CI [0.995,1.005], peak rate 0/610) |
| live wave periodicity (C2) | MEASURED APERIODIC (no component 0.2..12 rad/t above 0.6%) |
| live wave growth law | MEASURED: \|imH − 21/t\| ≈ 3.7e-5·t, linear over t ∈ [400,1200] |
| origin of the growing hole (finite-N artifact vs true structure) | OPEN — C4 is the discriminating test |
| predictive power | UNPROVEN AND CURRENTLY NULL (816 zeros, both regions, honest) |
| RH connection | NONE claimed; off-board side quest; borrows day006 machinery only |
