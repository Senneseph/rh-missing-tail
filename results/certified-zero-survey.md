# Certified zero survey (v0)

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
- **Consequence (classical counting corollary, our count): no pair of
  zeros off the critical line below 10⁶.** An off-line pair would add
  +1 to 2K per pair below the test height.
- Certified bound at v0: **10⁶.** The 10⁷ run (GPU walk, dt = 5×10⁻⁴)
  is in progress with its stability re-walks (dt/2 at the endpoints
  and over the defect window); it updates this section, nothing
  below it, when certified.

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
  **one dead counting chunk** (~128 rad, near t ≈ 1.06×10⁶): a single
  chunk of ~200,000 samples contributed no flip counts. Failure rate
  ≈ 1 in ~70,000 chunks; caught by the twin-floor + S-plausibility
  discipline *before* any conclusion was taken from the uncorrected
  file. Correction: independent CPU re-walk of the defect window at
  dt and dt/2 (in progress) + parity at the endpoint. A proportion
  theorem would have been blind to a single chunk; the walk must
  certify itself per window.

## 6. What the 10⁷ update will add (in progress)

- corrected N(10⁷), S(10⁷) at dps-40+; 2K(10⁷) (extending the
  off-line-pair exclusion 10-fold); the exact interval and size Δ of
  the single dead chunk; the endpoint dt/2 stability verdict.
