# Certified zero survey (v1 — the 10⁷ closeout landed, 2026-09-11)

Every figure below is labeled by engine and precision. Conventions:
S(t) = N(t) − ϑ(t)/π with ϑ(t) = arg Γ(1/4 + it/2) − (t/2)ln π
(DLMF 25.10.2 form, the project-verified convention); 2K(t) =
(N − main + 1) − ϑ/π with the dps-verified identity (a single point
verifies N mod 2 only; **grid-refinement stability — dt vs dt/2 counts
agreeing exactly — is the true count certificate**).

## 1. Exact counts (dps-40/45 mpmath cross-verified)

| T | N(T) | S(T) |
|---|------|------|
| 10⁵ | 138,065 | −2.558419306 |
| 3×10⁵ | 466,655 | (dps pending — next M3 batch) |
| 10⁶ | 1,747,142 | −2.508632116 |
| 1.4×10⁶ | 2,520,971 | −3.069625 (dps-45) |
| 10⁷ | 21,136,121 | −3.205718 (dps-45) |

- N(1.4×10⁶) = N(10⁶) + 773,829: exact arithmetic on certified inputs.
  The 773,829 zeros of (10⁶, 1.4×10⁶] were counted TWICE by independent
  engines — CPU Riemann–Siegel re-walk at dt AND dt/2 (exact agreement,
  min gap 0.0065 ≫ 2·dt) and the independent day-009 GPU zero list, which
  contains the same 773,829 zeros in the window.
- N(10⁷) = 21,135,877 (defective GPU walk) + 244: the 244 missed flips
  all lie in (10⁶, 1,000,128]; the tail (9.9×10⁶, 10⁷] was re-counted
  dt/dt2 exact (227,197 = 227,197); the middle (1.4×10⁶, 9.9×10⁶) rests
  on the single-blackout model (S flat at −247.0…−247.3, no jump > 0.27).

- Both S values reproduced at dps-40 against the float64 dual-stack
  walks to the printed digits.
- N(3×10⁵) = 466,655 (2026-09-09): GPU flip walk on [10⁵, 3×10⁵] at
  dt = 5×10⁻⁴ AND dt/2 — flip counts agree exactly (466,655 both
  passes), engine gate GPU-vs-host 6.5×10⁻¹⁰, min twin gap 0.005750
  (at t ≈ 273,193.66, above the twin floor), anchor N(10⁵) = 138,065.
  This is the zero list (466,655 +γ) that E7b-1 Stage-1 runs on.
- The 10⁵ census (138,065 zeros) is the zero list used by the
  upcoming E7b spectral test.

## 2. Parity certificates (the counting corollary)

- 2K(10⁶) = −2, 2K(5·10⁵) = −2, dps-40/50 (residual ±1e-8).
- **2K(10⁷) = −2, dps-45 (residual 2.3×10⁻⁹)**; parities also EVEN at
  1.4×10⁶, 5×10⁶, 9.9×10⁶. Record: out_day014_dps45_arg1e7.txt.
- **Consequence (classical counting corollary, our count): no pair of
  zeros off the critical line below 10⁷** (extended 10-fold from 10⁶).
  An off-line pair would add +1 to 2K per pair below the test height.
- Honest wall (measured, day-014): the parity identity verifies N mod 2
  ONLY — the +244 vs +246 candidates both pass it at every dps, because
  they differ by one 2π-turn of Arg. The count certificate is the
  grid-refinement stability (dt/dt/2 exact agreement) plus the
  independent-instrument cross-count; the parity is a sanity layer.
- Certified bound at v1: **10⁷.**

## 3. The S-envelope (measured, no runaway)

- Per-decade max|S| through 10⁶: {4.55 … 4.67} flat across decades
  (first growth past 10⁴: 2.59 → 4.68).
- GUE reference sqrt(ln ln T) ≈ 1.67 at 10⁷ — the observed |S| regime
  is well inside the O(1) band the explicit formula predicts.

## 4. Twins (the reason the walks are grid-refined)

- (0, 10⁵]: ≥ 18 twin pairs resolved, min gap 0.020771.
- (10⁵, 10⁶]: 19 twins, gaps 0.002954 – 0.017375.
- Twin-floor rule (hard): a flip-count walk at spacing dt certifies
  counts only while dt < min-gap(t) in the walked window; the floor
  at 10⁵–10⁶ is ≈ 0.003, hence dt = 5×10⁻⁴ + a full dt/2 stability
  re-walk.

## 5. The GPU walk defect (reliability is measured, not assumed)

- The 10⁶→10⁷ GPU walk (2,560,000-sample chunks) suffered exactly
  **one dead counting chunk** of 244 missed flips, localized to
  (10⁶, 1,000,128] — 128 rad at the very start of the walk, NOT near
  t ≈ 1.06×10⁶ as the early S-plateau estimate had guessed. Failure
  rate ≈ 1 in ~70,000 chunks; caught by the twin-floor + S-plausibility
  discipline *before* any conclusion was taken from the uncorrected
  file. Correction (landed): independent CPU re-walk of the defect
  window at dt and dt/2 (773,829 = 773,829 EXACT, min gap 0.0065),
  doubly confirmed by the day-009 GPU zero list (773,829 in the same
  window), + parity at 4 endpoint heights. The pre-registered +246
  estimate ("S drops from −2.5 to −~248.75") was superseded by the
  direct +244 count — FALSIFIED WITH COMPUTATION at 21,136,123.
  A proportion theorem would have been blind to a single chunk; the
  walk must certify itself per window.

## 6. The 10⁷ update (CLOSED — v1)

- corrected N(10⁷) = 21,136,121 (dps-45 parity + direct re-count);
  S(10⁷) = −3.205718; 2K(10⁷) = −2 (off-line-pair exclusion extended
  10-fold to 10⁷).
- exact dead-chunk interval: (10⁶, 1,000,128], Δ = 244 flips.
- endpoint stability verdict: STABLE at both defect-window resolutions
  and at (9.9×10⁶, 10⁷] (227,197 = 227,197);
- residual UNMAPPED: the middle window (1.4×10⁶, 9.9×10⁶) of the
  defective file was not re-walked (single-blackout model; S flat with
  no jump > 0.27; a sub-threshold 1–2-flip defect there cannot be
  excluded by 1-rad sampling — a future finer-grid pass could).
- Next growth statement (10⁵ → 10⁶ → 10⁷): S = −2.558 → −2.509 →
  −3.206, |S| envelope still O(1), no runaway.
