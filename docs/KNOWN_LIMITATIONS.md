# KNOWN LIMITATIONS

> Our caveat, written before the scrutiny, not after it. We are not
> presenting an infallible artifact: we present a decomposed argument
> whose open surface is *explicit*, and we state exactly where a
> finite computation, an audited constant, or a cited theorem stands
> in for a proved universal statement — and what each one would take
> to close. **Expect attacks here; these are the places.**
>
> State of record: 2026-09-17, 25x[8]/day029 (post-25af; S4Asm
> assembly landed; S1-GAP verdict-(A) pre-test landed; full corrected
> sweep in flight). Source documents: `RH-PROOF-OUTLINE.md`,
> `DISCOVERY_LOG.md`, `ROUTE-ANCESTRY-AND-NOVELTY-2026-09-17.md`,
> the honest split per atom (LEAN-PROVEN / CITED / PINNED / MEASURED)
>
> Post-record state (appended):  the 3×10¹⁰ census is landed and
> certified (N(3×10¹⁰) = 101,635,962,231 exact;  sup|DN| = 2.615067 on
> (10⁷, 3×10¹⁰];  pre-registered Outcome A,  A2-class so far),  and the
> [S1] per-gap ε data layer is complete (SUM_EPS_CERT certified over the
> band).  The open-surface items below are unchanged in substance;  the
> current-state pointers are docs/CEILING-REPORT-DAY035.md (post-data
> addendum) and docs/S1-A1-EXPLORATION.md (the [S1]/A1 research log).

## 0. Where all finiteness is contained

The argument's job is to push every use of data, numerics, and
non-machine inputs to a single named boundary — **S1, the on-line
bridge residual** — and to keep the rest as theorems. It does:

- **The infinite parts are theorems.** P12 closure (logic), S2
  (zero-side far/own-pole + discrete floors), S3 (definition side),
  S4 (uniform squeeze: window regime 25ab + own-regime strip 25af +
  S4Asm regime coverage) — all LEAN-PROVEN at explicit constants.
- **The finite parts are measured or pinned, and explicit.** The S1
  territory below the data extent (10⁹) is *measured*; the constants
  that enter the theorems are *pinned* (audited) or *cited*. The seam
  between the two is this ledger.
- **The residue is the pre-registered last mile** (the S1 uniform
  inequality, watch item: residf growth 1.04 → 1.32 → 7.71 at
  4e8 → 6e8 → 1e9, 93% of the signal at the last data point).

## 1. The named last mile (where it should be, not a hole)

- **S1 above the data extent (t > 10⁹): unproved, no data.** The
  uniform statement "corrected def-side residual < zero-side signal
  for all t" is open. Its mathematical core is the Sbar/S1 wire (the
  Platt–Trudgian Cor 1 class, log-scale bound on the on-line
  counting defect — CITED, not formalized) composed against the
  decaying t⁴ P4 floor (already a theorem). The residf growth law
  (measured t²-class at the frontier) is the live deciding question.
  If it holds: a proof. If not: the pre-registered ceiling report at
  the true onset, with true attribution — itself a result.

## 2. Finite computations standing in for universal statements (the attack surface)

These are the four places a reviewer will look first, because a
computation is doing the work of a proof. All are bounded and fixable
without touching the mathematics already closed.

### H1 — The [10⁶, 10⁹] "verified" band is a numerical screen, not a certificate
The straddle sweep's coverage in (10⁶, 10⁹] is **float64 discrete
tails** (2.79×10⁹ actual zeros, longdouble chunking with an
*argued* ~10⁻¹³ per-chunk error) + **dps-30 mpmath quadratures with no
a-posteriori error bound**. It is a high-confidence measurement, not a
P–T-style interval certificate. As it stands, "margin ≥ 1 on
(10⁶, 10⁹]" can in principle be wrong by an unquantified amount.
*Fix:* interval-arithmetic (or machine-checked error-budget) re-run of
the straddle statistic on a dense grid — Platt–Trudgian certification
grade. The single most important pre-submission gap; orthogonal to the
math risk.

**Status (2026-09-19, day034b): RE-ISSUED at certificate grade.**
The straddle grid over [10⁶, 10⁹] (39 windows x 25 straddles = 975
points: P1.1 LOW4 + 4 flagged connectors + day029 A-1 verbatim) was
re-run with fully tracked worst-case error budgets (per-term unit
roundoff, pairwise/longdouble accumulation bounds, dps-30/60 quad
pairs at 400 nodes per section, dps-30/60 zeta/lm/dev agreement,
exact-integer nlt with guard).  Budget model self-tested against
dps-60 exact per-zero arithmetic (20-50x containment, 4 channels);
batched pipeline cross-checked bit-exact against the per-point
reference (CROSSCHECK: PASS).  Result (out_day034_h1cert_b.txt):
**all 975 points certified; worst margin_cert = 1.081637 at t =
1000000001.61565 (10⁹ window; computed 1.081644, budget
9.16e-5); margin_cert < 1: NONE; margin_computed < 1: NONE**; one
wide-budget flag (1.3e8 window, budget 1.76e-4, margin ~101 —
flag, not a violation).  Pre-registered reading C-1 applies:
each grid point now carries an explicit budget; the claim is true
margin >= margin_cert (machine-verified error-budget variant — the
Fix's second variant — not full interval arithmetic).  The
between-grid caveat (H4) is unchanged; the claim is at the grid,
as the screen was.  Full numbers: PHASE1A-CEILING.md section 4;
machinery: scripts/rh/day034b_h1cert.py.

### H2 — The (10¹⁸, ∞) kernel section is numerically bounded, not analytically
**Status (2026-09-17, day029 rescheck):** the (400, 400) sweep configuration is RESOLUTION-STABLE — Efull(1e9/4e8/6e8) stable to < 5×10⁻⁵ across the full npts 200→2000 × npts2 400→2000 ladder (both sections, dps-30, differential from the sweep anchors; `day029_efull_rescheck.py`, `out_day029_efull_rescheck.txt`). The quad-resolution part of H2 is therefore closed at screen level for the verified range; the (10³⁰, ∞) tail remains bounded by the "1 − O(t²/10³⁰) < 10⁻⁹" heuristic, and a PROVABLE comparison bound on it (the t²/g²·log-density decay; the classical S̄(t) technique) is the remaining analytic unit, Lean-portable.
**Note (2026-09-18, CORRECTED):** an earlier same-day draft claimed the complex path is known wrong (see H5); the same-interval per-cell A/B (400/400 cells exact) RETRACTS that — the complex tail-quad was verified correct, and the closure claim above stands as recorded.
**Background:** the full-horizon correction that dissolves the 25x sub-1 dips
(verdict (A), day029) folds the kernel's (10¹⁸, 10³⁰] product section
in via a **400-node log-quadrature without an a-priori error bound** (now
ladder-verified to < 5×10⁻⁵, above), and
bounds (10³⁰, ∞) by the heuristic "1 − O(t²/10³⁰) < 10⁻⁹." The
corrected margins (10.36 / 4.38 / 1.08) and the residf values carry
that uncertified error. *Fix:* a provable comparison bound on the tail
integrand (it decays like t²/g²·log-density; the classical S̄(t)
technique bounds exactly this analytically) — a small analytic unit,
Lean-portable. Priority: high — the S1-GAP verdict rests on this
section.

### H3 — The 0.9975 near-floor is a finite audit used as a universal constant
`p8_f_near_pin = 0.9975` is the *measured* minimum of the detector
scale over the audited δ-grid {0.005, 0.5} at audited heights (the
day-017/019 audit). It is re-confirmed by measurement up to the 10⁹
data extent (dev ≈ 1.0–1.32 across the 25x[8] grid) but **is a model
claim above 10⁹**: A4.2 (unit mass), A3.1 (δ-minimum structure) and
the E7b1 δ→0 limit give the shape, not the three digits. It enters
two otherwise-LEAN theorems (the S4 window branch; the P8 A5 near
terminal). *Fix:* a LEAN universal lower bound on the near scale
(LEAN atoms are ~90% present; the constant is the gap), or a
P–T-grade height-scaled re-audit covering the claimed range.

### H5 — The mpmath complex-tail-quad "defect" — investigated and RETRACTED: an A/B interval confound (2026-09-18)
**Status: RESOLVED — no defect; the recorded numbers stand.** A day029 A/B appeared to show the complex-integrand tail quad off by +2.5267e9 (in log) from real-path integrals (−1709644719.56 vs −4236379269.70 at the 1e9 anchor). The A/B was **confounded**: the complex number was the quad over (G_last = 2.0017459996e9, 1018] (hi-run construction: the boundary layer (t, 3t) is LIST-SUMMED there over the measured zeros), the real numbers over (G1 = 1.0063459998e9, 1018] (sweep construction: boundary layer density-quad); the difference between the intervals is exactly −2.5267345501e9 = the genuine boundary-layer integral, misread as a library error. The SAME-INTERVAL per-cell A/B (day029_cell_diff.py, all 400 cells of (G1, 1018], complex vs real): **400/400 cells agree to all displayed digits** (max |Δ| = 0; cell sums −4236379269.697752 both paths; boundary-layer cell converges to est. error 1e-41 on both). mpmath's complex quad is not defective for our integrands on these intervals (identical results also on 1.3.0); the earlier "recorded values are complex-path" tag is RETRACTED in full. **Genuine residuals (independent of the ghost):** (i) for t > G_last the kernel tail quad (G_last, 1018] contains the log-singularity at g = t IN THE INTERIOR — **RESOLVED 2026-09-18**: the v3 singularity-avoiding rem (`day029_model_split.py`) uses [G_last, t−1e-8] + [t+1e-8, 1e18] (SMOOTH on closed intervals — no tanh-sinh node can round onto g = t, which also bypasses the dps-30 endpoint razor log(0) = −inf that the naive split hit) + the exact O(ε³) annulus e·ρ_t(log e − 1) + e·ρ_t·σ(t) per half (naive-split and closed-form-subtraction variants both documented as false steps; the latter missed ρ inside the singular term). Gates: S1 mp-exact no-split identity, S2 committed-row replay 0.00e+00, S3 15-digit direct-agreement at 4e9, per-part real cross-checks ≤ 7.6e-6. Repaired model Efull: −2.008/−2.288/−0.631/−2.995/−4.133/−2.130 at 2.5e9/4e9/6e9/1e10/2e10/3e10 (oscillatory O(1)–O(4); O(1e10)–O(1e11) component cancellation residual — H2 model-grade; full table in `scripts/rh/out_day029_s1gap_hi.txt`); (ii) splice-comparability calibration D(t) (G1 vs G2) — **RESOLVED 2026-09-18** (`day029_dcheck_splice.py`, `scripts/rh/out_day029_dcheck.txt`): |D| = O(1) (0.59–2.65) at 5 heights — the raw splice levels are a KNOWN O(1) apart (G-calibration), not O(1e-4); the im channel is EXACTLY π×(∫ρ dg − N) = −0.334020615 (the band density model undercounts by 0.106322 zeros — pinned constant, 7-digit verification), the re channel carries a measured O(0.4–1.5) splice lattice-structure offset (a full-counting-function IBP refinement to reach the O(1e-4) fluctuation floor is a named sub-item); no unknown drift — series are read on a single splice per series, cross-splice only after the O(1) calibration. **Lesson (permanent):** before declaring a library defect, pin ALL free A/B parameters (here the splice G); a "discrepancy" equal to the integral over the interval difference is an interval difference.**

### H6 — The low-t data territory (t0 < 1000, d0 <= 1/2) is FILLED at SCREEN level, not a certificate (2026-09-18, closed)

- The S4A composition's explicit residual (the bound theorems
  cover t >= 1000) was filled by direct finite computation per
  docs/LOW-T-DATA-TERRITORY-PLAN.md: 207-point (t0, d0) grid,
  P1.1e wire form, low split at G = 1200, the 500-delta dev grid,
  finite S2 disc floor. Result: margin_new >= 1 at ALL 207 points;
  global min 7.35737123 at t0 = 0.5 (dual-precision dps-30/50
  anchor, |d| <= 3e-4). Data: 813 zero slice of the committed
  LMFDB 1e7 file (md5-locked; all 813 at the mpmath noise floor;
  independent mpmath walk bit-exact on the first 225).
- What it is NOT: a Lean certificate (it is a grid + the proven
  S4Growth cell control + certified tail), and there is NO closed
  form for the uniform low-t remainder lower bound (finite data
  by design; the zero-line product is pinned data, not closed
  form). d0 > 1/2 remains CITED (classical zero-free regions).

### H4 — The "min over d" in the straddle statistic is a grid minimum
The dev-minimum over the off-pair distance is taken on a finite grid
(480 points; 1600 in the pinned reissues), justified by smoothness,
not certified against the continuum infimum. *Fix:* an analytic
δ-structure bound (A3.1's numerator argument is a step of it — a
polynomial theorem) plus a grid-error analysis.

## 3. Cited universals (cited, not finite — same scrutiny, different flavor)

Universal theorems we cite rather than prove, on the demotion list.
A reviewer may ask for each to be machine-proven; the honest split
keeps them CITED with source of record:

1. **Zbound(t) = 1.6·t^{1/4}·log t** — Backlund's explicit
   Riemann–von Mangoldt envelope; our M-envelope in the S4 squeezes.
2. **The Sbar/S1 wire** — Platt–Trudgian Cor 1 (log-scale on-line
   counting defect); the mathematical core of the S1 residue.
3. **The A2c bridge** — W_n = em_expr on Re s = ½ (Apostol / DLMF).
4. **The classical zero-free regions** — exclude d₀ > ½ (Re ρ outside
   (0,1)) for the actual zero set; not encoded in the abstract ZeroSet.
   *day035:* the geometric half is now PROVEN (SliverEdge.
   edgePairAtZeroOne: the d = 1/2 off-pair sits exactly on Re = 1 /
   Re = 0) and the sliver t0 < 707/50 is the named pin record
   (SliverEdge.SliverRecord); CITED bears only the zero-free
   assertion itself (SliverEdge.edgeVoid composes the two).
5. **The Platt–Trudgian 3×10¹² on-line certificate** — the data
   backbone of everything "verified ≤ 10⁹" (seam/Nt continuity
   re-checked exactly by us: Nt = 73426758, gap = one zero spacing).

**Demotion audit against the pinned toolchain (2026-09-19, item 7):**
each CITED was checked against mathlib v4.33.1 (local grep + source
of the pinned checkout) with the current upstream state corroborated
online before the check.

- Items 1 (Backlund RVM) and 2 (P-T Sbar Cor 1): **NOT in mathlib
  4.33.1** (no zero-free-region or zeta-zero-counting content beyond
  the topological set of zeros: closed/discrete/finite-on-compact in
  `NumberTheory/LSeries/ZetaZeros.lean`). A community formalization
  **Zeta23** (Anthropic 2026, "more than two thirds" paper; Lean
  4/mathlib, `anthropics/zeta-23-lean`) proves Weil's explicit formula
  and an RVM local-count bound (Titchmarsh Thm 9.2: the zero count in
  (t, t+1] is O(log(...))) -- the formal machinery a CITED->PROVEN
  demotion of items 1/2 would build on (adoption or re-derivation;
  scheduled, not this item). **On the band [1e3, 1e9] the load shifts
  to the data:** the counted quantities are pinned by our exact
  seam/Nt re-verification (item 5), and the empirical counting
  defect is pinned at 0 (the 25af Sbar datum) -- so items 1/2 bear
  only above 1e9 and for the production methodology.
- Item 3 (A2c bridge): a finite formal-algebra identity on Re s = 1/2
  (gamma/reflection/functional equation); mathlib carries the zeta
  and gamma infrastructure (`RiemannZeta.lean`, completed zeta and
  pole structure). **Next small formalization candidate.**
- Item 4 (classical zero-free, d0 > 1/2): NOT in mathlib 4.33.1;
  Zeta23's abstract zero-config assumes the strip locus, it does not
  prove the classical zero-free region. **Stays CITED and
  load-bearing; a dedicated classical port is a separate project.**
  day035 update: the day030 sweep's d ≤ 1/2 convention means the CITED
  region is load-bearing only beyond the wire's d domain; the edge it
  guards (d = 1/2) is now PROVEN vacuous for the actual set
  (SliverEdge.edgeVoid), so the item's scope has narrowed to the
  stated classical assertion.
- Item 5 (P-T data backbone): **already half-demoted in fact** -- on
  [0, 1e9] the backbone is our own exact re-verification (PINNED);
  their certificate bears the methodology beyond it.

## 4. What looks like a hole but is sound (do not over-hedge)

- **The hX wire pin at T₀ = 1.1×10⁵** is the *correct* use of a finite
  fact: one endpoint + a monotonicity theorem = universal; the
  endpoint constants are norm_num (Lean).
- **The S4 t²/t⁴ wire families** (n = ⌊t²⌋ window; n = ⌈3.1×10⁷·t⁴⌉
  strip) are formal families: theorems for all t ≥ 1000, no finiteness.
  The S4-Sharp impossibility theorems bound the excluded families.
- **The P12 closure** (RH ← S1∧S2∧S3∧S4) is pure logic, machine-proven.
- **The d < 1/200 coverage** is the d-independent window branch (its
  floor is the pinned near scale of H3 — the only caveat).
- **The seam/Nt continuity** of the zero data is exact-verified, not
  assumed.
- **The 25x/25y records** (the sub-1 dips, the 25y pins) stand as
  artifact-corrected history; the pins are certified facts of *that*
  statistics, and the correction (day029) is recorded, not erased.

## 5. The ledger, as a sentence

For every claim in this project, one of: **proven** (infinite part —
the theorems), **measured** (S1 below the data extent — H1-grade,
upgrading to certificate per H1), **pinned** (audited constants — H3,
hX), or **cited** (universals — §3). Nothing else exists by discipline.
The open questions are: H1–H4, §3, and the residue in §1 — and all of
them are now bounded, located, and fixable one at a time.

*Companion documents: `RH-PROOF-OUTLINE.md` (the path and its state),
`ROUTE-ANCESTRY-AND-NOVELTY-2026-09-17.md` (the ancestors and the
novelty claims with their limits), `DISCOVERY_LOG.md` (25x[8]/day029).*

## CORRECTION ADDENDUM (grid counts, append-only)

The H1 entry's "39 windows x 25 straddles = 975" and "all 975
points certified" are superseded: the k = 0 straddle (singular in
R_closed) is excluded in both engines, the executed 3e9 grid is
39 x 24 = 936 points (verified from the ledger: min margin_cert
1.0816362118, 0 rows below 1, 1 budget-width FLAG), and the 3e10
grid is 29 x 24 = 696 points.  No limitation statement is
affected.
