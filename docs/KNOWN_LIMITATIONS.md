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

## POST-MACHINE STATE (discovery 0120, 2026-10-19 — the endpoint's
## residual is data/record content only)

After discoveries 0116-0120 (G-hs3-ii/iii closed in the machine:
T4Off.lean, T4OffD.lean, T4OffM.lean; the endpoint machined in
RHEnd.lean parts B7/B8), the theorem
`rh_program78_stripfront_mach_s1pins_PT2` (RHEnd.lean, GATED, full
tree green) states the whole program at the Platt-Trudgian verified
frontier tPT2 = 3,000,175,332,800 (arXiv:2004.09765, Theorem 1,
CITED as [Z-PT2]) from EXACTLY four named inputs, all strictly
above that height:

1. **The P1-P4 pin family** at strip-band witness zeros
   (1/200 <= d0 <= 1/2, i.e. 1/2 <= Re rho < 1, t0 >= tPT2):
   P1 fill (`Qside = |zeta rho - Kfun rho|`), P2 kernel magnitude
   (`devFacePt <= |W_n|`), P3 A4.3 mass, P4 absorption. DATA
   OBLIGATION: zeta records at heights above 3.000e12 at the
   off-pair zeros — the per-witness measurement the E1ClauseV3 /
   S1Face machinery makes below the data extent, re-run where the
   zero set above tPT2 is known.

2. **The window zero-exclusion face**: no off-line zeros on
   (tPT2, inf) x (0, 1/200). RECORD OBLIGATION: a zero-verification
   record in the (1/2, 1/2 + 1/200) box above tPT2 — the next
   Platt-Trudgian-class verification to be produced or cited. This
   is the one obligation with NO in-tree analytic substitute (the
   window squeeze is pinned at the near pin ~1662x above the floor,
   bound-level, recorded in Part C of the RHEnd docstring).

3. **The machined hs3 face**: at each strip-band off-pair,
   `Qside <= |EM wall at the canonical point (n4 schedule)| +
   t4m_MwireOff` — whose only non-machine content is the CITED
   classical 1.6 convexity mass (the same bound the tree cites on
   the line, transferred through the functional equation). RECORD
   OBLIGATION: the per-witness convexity evaluation at the off-pair
   point, checkable against the same zeta record as item 1.

4. **[Z-PT2] itself**: all non-trivial zeros with 0 < Im <= tPT2 on
   the line (CITED, arXiv:2004.09765) — plus the standing [Z78]
   external 7/8-strip zero-free input.

No analytic face of the endpoint remains inside the tree: every
open item above is either checkable against a zeta record at the
height (items 1, 3) or a classical verification record (item 2),
not a theorem the tree cannot produce. No RH claim is made or
implied anywhere: the endpoint is a composition around these
named, bounded, recorded obligations.

*Companion: `PATHWAY-TO-A-SOLUTION.md` (the FORMAL blocks at
discovery 0116-0120), `discovery/DISCOVERY.html` (entries 0116-0120),
`formal/cards/RHEnd.md` (parts B5-B8 of the endpoint).*

## FLANK ASYMMETRY CORRECTION (discovery 0121, 2026-10-19 — the
## machined hs3 face covers the RIGHT flank only; G-hs3-left is the
## remaining analytic face)

The "no analytic face remains" statement above was ALL-FLANKS in
wording and RIGHT-FLANK in mechanism. The T4Off closure (discovery
0116-0120) lives at the canonical point `t4o_sOff t0 d0 = (1/2 + d0)
+ i*t0` — i.e. it covers `sigma = Re s = 1/2 + d0 >= 1/2` only.
Discovery 0121 (`formal/RhAttack/T4OffL.lean`, GATED, 619 lines,
0 sorry, full tree green) records the formal negative result about
the machine wire and names the residue:

* **G-hs3-left.** The S3 (wire) content of a LEFT-FLANK off-pair
  (`Re rho = 1/2 - d0 < 1/2`, `1/200 <= d0 <= 1/2`, `t0 > tPT2`) is
  NOT machine-supported by the `n4` wire. Formal barriers (exact
  rational pins, no numerics):
  1. **Band edge** (`d0 = 1/200`, `sigma = 99/200`):
     `t4l_barrier_edge` — for every `t >= 10^10` the first T4 term
     `(1/2)*(n4 t)^{-99/200}` STRICTLY EXCEEDS the endpoint floor
     `floStripMin t (1/200)`; in particular at the Platt-Trudgian
     frontier (margin ~13%; crossing threshold
     `t > (15750/9999)^50 ~= 7.33e9`). The S3 side of the squeeze
     cycle (wall + mass below floor) cannot hold at the left flank
     band edge (`t4l_squeezeImpos_edge`).
  2. **Sigma = 0** (`d0 = 1/2`, `Re = 0`):
     `t4l_barrier_sigma0` — the first T4 term is identically 1/2 at
     EVERY schedule `n`; it never falls below the floor. No schedule
     at all can close the S3 wire at `sigma = 0`
     (`t4l_squeezeImpos_sigma0`).
  3. **No uniform schedule covers the band**: per-point closure at
     fixed `d0 < 1/2` needs a left-tuned schedule whose decay
     `n^{-sigma}` beats the floor's `t^{-2}` (exists with a large
     exponent), but NO schedule uniform in `d0` over the band covers
     it, and `d0 = 1/2` is unreachable at every schedule.
     **Discovery 0123 supplies the positive half of this bullet in
     the machine** (T4OffL section S7): the per-point schedule is
     explicit — `t4l_schedA (sigma) = (9999/2)^{1/sigma}`, run `n`
     at or above `A(sigma)*t^{2/sigma}` — at which the first T4 term
     lands EXACTLY on the edge-floor scale (`t4l_schedTerm1`); the
     critical scale strictly exceeds the uniform `n4` schedule at
     the frontier height (`t4l_schedBeat4`); and the tuned constant
     is unbounded as `d0 -> 1/2` (`t4l_schedDiverge`), which is why
     no uniform schedule can ever serve the band.

Consequently the endpoint residual at tPT2 is again FOUR named
faces, of which exactly one is analytic content inside the tree:

1. P1-P4 pin family at strip-band witness zeros (data, above the
   frontier).
2. Window zero-exclusion face (record above the frontier).
3. Machined hs3 face — machine-verified at the **right-flank**
   witness (`t4o_sOff`); its only non-machine content is the CITED
   1.6 convexity mass (record, as before).
4. **G-hs3-left** — satisfaction of the S3 face at a **left-flank**
   witness: analytic content in the original sense, not a data or
   citation item. Candidate resolutions: a left-tuned tail theory
   (schedule `n ~ t^{4/(1-2*d0)}`-class, d0-dependent, breaks the
   n4 wire's uniformity) — DONE: discovery 0123, T4OffL section S7;
   squeezing the face at measured left-flank zeros below/around the
   frontier — CLOSED as a dead branch by discovery 0124: the face is
   DATA-MINIMAL (its stated support `t0 >= tPT2` sits entirely above
   the measured data, and no measured off-line zero exists in the
   program's ledgers at all — the finders operate on the critical
   line; VERDICT paragraph below); or a different wall.

**Discovery 0122 (2026-10-19 — endpoint lockstep):** the face is now
IN THE MACHINE. `RHEnd.lean` part B9 (the file is 1505 lines, 0
sorry, full tree green) states the endpoint with the hs3 face
SPLIT BY FLANK: `t4l_flankSplit` (an off-pair with `d0 != 0` splits
by the flank of its witness), `rh_program78_stripfront_mach_left`
(the right-flank face is the machine-closable B7 shape — T4OffD in
body; the left-flank face `hs3LeftH` is the pair-level S3 squeeze
`Qside <= Bwire + Mr`, the named analytic face) and the `_PT2`
instance. The endpoint residual in the machine is now exactly the
four-face ledger above: `t4l_rightFaceOfSingle` records that the
B7 single-face premise restricts to the right-flank face, so the
split endpoint asks no more of the right flank than B7 did; the
S4 (floor) side is flank-independent (`t4m_margin`) — only the S3
(wire) side carries the flank. The 0121 candidates 1 (data squeeze
of the face) and 2 (left-tuned schedule family) attach to
`rh_program78_stripfront_mach_left` directly.

**Discovery 0123 (2026-10-19 — the schedule family, in the
machine):** candidate 2 is done, in `T4OffL.lean` section S7 (the
file is 919 lines, 0 sorry, full tree green). The barrier's
contrapositive is now a CONSTRUCTION: `t4l_schedA (sigma) :=
(9999/2)^{1/sigma}` is the critical scale constant (at `B =
A(sigma)*t^{2/sigma}` the first T4 term computes `(1/9999)*t^{-2}`
exactly); `t4l_schedTerm1` closes the first T4 term at or below the
floor scale for every schedule at or above that scale, for every
`t >= 1000`, `sigma > 0` (identity chain, no numerics); `t4l_sched
Beat4` shows the critical scale strictly exceeds the uniform machine
schedule at the frontier height (pinned to the norm_num-able 99th
power `(9999/2)^200*10^40 > 62000000^99`); `t4l_schedDiverge`
proves the tuned constant is unbounded as `d0 -> 1/2` — no d0-
uniform schedule exists, so per-point tuning is essential. The
residue is thereby sharpened from 'the wire is too weak' to 'the
wire is the wrong KIND': the analytic face G-hs3-left is now
precisely that the FULL S3 squeeze (not just the first T4 term) holds
at the explicitly given per-point tuned schedule at the left-flank
witness. The remaining attack candidate is the data squeeze of the
face at measured left-flank zeros (candidate 1).

**Discovery 0124 (2026-10-19 — VERDICT: candidate 1 DEGENERATES, the
face is DATA-MINIMAL):** the data squeeze closes as a dead branch,
evidenced in three independent routes. (1) MECHANISM: the in-tree
zero finders operate ON THE CRITICAL LINE (Riemann-Siegel / Platt
record, `day024_platt_fast.py`); the Platt `.pd` format stores per-
zero 104-bit STEPS for the t-coordinate ONLY and the decoded ledgers
are 8-byte float64 t-streams — no measured real part of a zero
exists anywhere in the program's data. (2) ROW FORMAT: the 21-column
fleet rows (`day037._point_row`: FLAG, x, t, g, mnew, mcert, residf,
zeta, dev, Bexp, Bph, Bz, Bdev, Btail_re, Btail_im, Bprod_re,
Bprod_im, Bqrem, Bqext, nlt, flagbit) are CHANNEL/MARGIN values at
TRIAL points (x, t, g, k) — the Re-looking fields are mnew/mcert
margins, not coordinates. (3) GEOMETRY: in
`rh_program78_stripfront_mach_left_PT2` the face `hs3LeftPT2` is
STATED on `t0 >= WinC.tPT2` — below it the premise `hPT2 : WinC.
allOnLineUpTo q WinC.tPT2` (the cited [Z-PT2] record) eliminates
off-pairs from the face's domain of application; above it no
measured data exists. The face's support is EXACTLY the unverified
territory: nothing below can be squeezed (the face is not there),
and the 'check the squeeze at measured left-flank zeros' audit is
vacuous (there are none, by mechanism and by record). Structural
lesson: with the endpoint stated AT the verified frontier, every
analytic face is automatically data-minimal — the squeeze pattern
(0106/0108) only works when a face extends BELOW a higher verified
height, and G-hs3-left has no such extension. The two live routes
remaining for G-hs3-left are now unambiguous: (A) ANALYTIC — prove
the full S3 squeeze at the explicitly tuned per-point schedule of
T4OffL S7 (left-flank S3 tail theory; the true residual); (B)
MEASURED SHADOW (evidence only) — a numerical grid of the
walk-vs-`BwireP + MrLift` inequality at LEFT-FLANK trial points at
or below 3e12 against the actual zeros: cannot shrink the machine's
face (which lives above tPT2), but a clean shadow is recorded
encouragement for route A and a violation is a discovery (the shape
of the squeeze failing at trial points). Route (C) — extending the
verified frontier — is external record-keeping.

**Discovery 0125 (2026-10-19 — S8: the left-flank S3 WALL, in the
machine, at the square-root schedule):** the S3 LEFT LEG of
G-hs3-left is now discharged IN BODY, in `T4OffL.lean` section S8
(the file is 1738 lines, 0 sorry, full tree green). Content:
(1) `t4l_schedB (t, sigma) := (n4 t)^{1/(2 sigma)}` — the
square-root schedule; at `n = schedB` the first T4 term computes
`(1/2)*n^{-sigma} = (1/2)*(n4 t)^{-1/2}` — exactly the on-line
T1 scale — and `t4l_sched_pow` records the single schedule
fact (for `a > 0`, `n >= schedB` implies `n^a >= (n4 t)^{a/(2
sigma)}`). (2) The left-norm win: `t4l_wall_norm1` (`||sL|| <=
||sOn||` on the band) and `t4l_wall_norm_prod` (the triple product
`sL(sL+1)(sL+2)` is termwise norm-smaller than the on-line
product). (3) The T3 coefficient pins, exact 99th-power `norm_num`:
`t4l_T3pin` (`(31000000)^{2/99} >= 500/499`), `t4l_T3pin2`
(`(31000000)^{2/99} >= 10/9`), and `t4l_T3margin` — for
`sigma <= 99/200`: `(n4 t)^{(1-2sigma)/sigma} >= 5/(2(sigma+2))`,
the one power margin that absorbs the 216-vs-540 constant ratio
(split at `sigma = 1/4`: the pin2 route for `sigma >= 1/4`, the
n4-square route for `sigma < 1/4`). (4) The termwise walls
`t4l_wall_T1/T2/T3` against `p8_B t (n4 t)` and THE MAIN LEFT WALL
`t4l_wall_tuned`: for `t >= 1000`, `1/200 <= d0 < 1/2`, EVERY `n`
at or above `t4l_schedB t (1/2 - d0)`: `||p4_em_expr (t4l_sOffL t
d0) n|| <= p8_B t (n4 t)` — the mirror, on the left flank, of
`t4wall_offline_le_bwires` (T4OffD) on the right flank. (5) The
endpoint-face composition `t4l_face_left_body` (the same witnesses
satisfy `||p4_em_expr(sL) n|| <= S4A.BwireR t d0 + t4m_MwireOff t
d0`, via the band identity `BwireR = p8_B t (n4 t)` plus M-wire
nonnegativity) and `t4l_face_left_band` (for EVERY band off-pair at
`t0 >= 10^10`, `n = ceil(schedB)` witnesses the wall). The S8
statements were pre-checked numerically before Lean
(`tmp/s35b_leftflank_precheck.py`, dps50 mpmath detector port with
the right-wall gate clean at 0.7990): at the square-root schedule
the max termwise ratio against `p8_B(t, n4(t))` is exactly 1.0000
on the survey grid (T1 matches by construction, T2/T3 strictly
below), and the T3 coefficient pin carries ~2.47x worst-case
headroom (log10 0.3929). The `d0 = 1/2` slice (sigma = 0) remains
the 0121 barrier — the square-root schedule diverges at sigma
= 0 and is excluded by `d0 < 1/2`.

STATUS OF G-hs3-left after 0125 (correcting the pre-check
overstatement that the left face is “fully body-dischargeable”):
* **S3 left leg: MACHINABLE IN THE BODY** at the square-root
  schedule (t4l_wall_tuned / t4l_face_left_body /
  t4l_face_left_band).
* **S1 leg: NOT closed.** The pre-check measured
  `devProg(t, d0) / (p8_B(t, n4) + MrLift(t, d0)) >= 1.11` at
  the band edge `d0 = 1/200`, growing with d0 (×10 by
  `d0 = 0.015`, ×178 by `d0 = 0.2`, ×11136 by
  `d0 = 1/2`): the tuned-tail Qside cannot sit between the floor
  and the wire on the band, so the band squeeze window is
  numerically EMPTY under the endpoint's concrete definitions.
* **Residual (next unit, S9, pending the B6 cross-check):**
  whether the endpoint's left face reduces to BAND-EMPTINESS above
  the frontier (no band off-pair can satisfy S1 and S3 jointly),
  and what the P1–P4 pin family's role is if the squeeze
  window is empty.

**Discovery 0126 (2026-10-19 — S9 done: the band squeeze
window is EMPTY IN BODY, and G-hs3-left dissolves):** `RHEnd.lean`
part B10 (the file is 1862 lines, 0 sorry, full tree green)
resolves the 0125 S9 question — stronger and differently
than the numeric plan. (1) **`t4l_bandWireBelow`**: on the
**whole strip band** (1000 ≤ t0, 1/200 ≤ d0 ≤ 1/2),
at **any** off-pair, **both flanks**: `BwireP (t0, d0) + MrLift
(t0, d0) < devProg (t0, d0)` — pure **body** composition of
`t4m_margin` (the S4 wire margin, discovery 0118: `p8_B +
t4m_MwireOff < floStripMin`) with **S2 in body**
(`FUnif.s2ActualFullBand`: `devStripMin ≥ floStripMin` on
the band), via the two band identities (`BwireP = p8_B t0 (n4
t0)`, `MrLift = t4m_MwireOff t0 d0`). No numerics. The S35B
pre-check's measured margin (`devProg / wire ≥ 1.1136` at
the band edge d0 = 1/200, growing to ~1.1e4 by d0 = 1/2) is the
size of this body inequality, not an ingredient of it. (2)
**`t4l_bandEmpty`**: no scale Qside can satisfy **both** squeeze
legs (S1: `Qside ≥ devProg`; S3: `Qside ≤ BwireP +
MrP`) at a band off-pair — the squeeze window is **EMPTY**,
in body, flank-independent. (3) **`t4l_stripFacesEmpty`**: the
**three** strip faces of the B9 endpoint — G-hs1
(Qside ≥ devProg), hs3 at the right witness (the machined
B7 shape), and **G-hs3-left** (hs3 at the left witness, pair
level) — are jointly **contradictory** at every band off-
pair (right branch: B7 shape + T4OffD wall in body; left branch:
direct). **G-hs3-left — and its right-flank twin —
DISSOLVE as independent faces**: they are components of the
strip-band zero-exclusion face. (4) **The vacant endpoint**:
`rh_program78_stripfront_mach_vacant` (+ `_PT2`) states the
endpoint with the three-face bundle replaced by ONE band-
zero-exclusion face `hNoStrip` (no off-pair on [H, ∞) ×
[1/200, 1/2]); `rh_program78_stripfront_mach_vacant_ofB9`
(+ `_PT2_ofB9`) proves the B9 endpoint **implies** the vacant
endpoint in body — for the endpoint, the bundle is
**equivalent** to the single exception face it encodes. The
unverified-region residual is now exactly **two zero-exclusion
faces** (band, window) plus [Z78] plus the below-frontier
record — no analytic face remains inside the tree. **B6
cross-check resolved**: the B6 review packet scopes **only** the
Z78 input (blast radius = `hz78` + the two theorems
`offPairFarEmpty` / `edgeZeroFree78`); the P1–P4 pin
family is **not** in its scope — the pins are the S1-side
**data faces** of Part B8 (P1 fill, P2 kernel magnitude, P3 the
A4.3 mass, P4 absorption) and are the **data side of the
squeeze**: the squeeze certificate (B10.3) certifies in body
that, when the pins hold at a band off-pair, the S3 face is
false there (Qside > wire) — the band-exclusion face is
their combined content. Honest limits: hNoStrip is **OPEN** —
a zero-exclusion statement in the unverified region above the
frontier, on record footing with the window face; B10 changes
the **shape** of the residual (inequality faces → exclusion
faces), not its open height. The S8 left wall stands as the
true positive-dual record of the G-hs3-left barriers
(machine-verified, explicit, not load-bearing for the endpoint).
No RH claim is made or implied.

**Discovery 0127 (2026-10-19 — B11 close-out: the above-
frontier residual is ONE face):** `RHEnd.lean` part B11 (the
file is 2043 lines, 0 sorry, full tree green) unifies the two
exclusion faces of 0126. The band face `hNoStrip` (no off-pair
on [H, ∞) × [1/200, 1/2]) and the window face `hWinH`
(no off-pair on [H, ∞) × (0, 1/200)) have the **identical
form** — zero-exclusion above the frontier — and the
1/200 boundary is a **proof artifact** of the squeeze cycle's
band/window split, not a face boundary; the remaining off-line
region d0 > 1/2 is closed in body from [Z78]
(`Z78P12.offPairFarEmpty`). The endpoint's entire above-
frontier residue is therefore the **SINGLE face** `hOff`:
`forall (t0 d0), H ≤ t0 → 0 < d0 → d0 ≤ 1/2 →
¬ offPair q t0 d0`. `rh_program78_stripfront_mach_unified`
(+ `_PT2`) states the endpoint with that one face plus the
below-frontier record plus [Z78] — the 1/200 boundary no
longer appears anywhere in the statement or the proof;
`rh_program78_stripfront_mach_unified_ofB10`
(+ `_PT2_ofB10`) proves the B10 two-face form **implies** the
unified endpoint in body (the record handles the t0 = H
boundary; the d-split routes to the two faces) — the
unification loses nothing; the two forms are equivalent in
body. **Final above/below-frontier ledger of the endpoint**:
[Z-PT2] record below the frontier (all zeros on the line up to
tPT2 = 3,000,175,332,800) + **one** open exclusion face `hOff`
above the frontier (on (0, 1/2], record footing) + [Z78]
(d0 > 1/2, in body from the external kernel-verified input).
No analytic face, no inequality face, no scale comparison
remains in the tree. Further reduction of `hOff` requires
**extending** the verified zero-exclusion record above tPT2
(external record-keeping, route C of 0124) or a new exclusion
instrument. No RH claim is made or implied.

**Discovery 0129 (2026-10-19 — B12: the open face shrinks to the [Z78]-sharp strip interior 0 < d0 ≤ 3/8):** `RHEnd.lean` part B12 (the file is 2240 lines, 0 sorry, full tree green, 17450 jobs) is the **terminus of the face-shrinking chain**. Key input: `Z78.offPairD0le` — for an actual-set zero set, `offPair q t0 d0 → d0 ≤ 3/8` ([Z78] is zero-free at Re > 7/8; the functional equation mirrors it below 1/8; zeros lie in [1/8, 7/8]; **3/8 is sharp**). So the slice (3/8, 1/2] of the B11 face — including the d0 = 1/2 edge — is closed **in body from [Z78]** with no face (`rhend_slice38Excl`). The endpoint is restated as `rh_program78_stripfront_mach_unified38` (+ `_PT2`): the single open face **hOff38** (no off-pair on [H, ∞) × (0, 3/8]). In the S1/S3 legs and the S4-covered leg, above H, any off-pair is first bounded to d0 ≤ 3/8 from [Z78] (`have h38 := Z78.offPairD0le`) before the face is applied — the B11 d0 ≤ 1/2 splits vanish from those legs. The forms are **equivalent in body**: `unified38_ofB11` (the 1/2-face restricts to the 3/8-face; no [Z78] needed) and `unified_ofB12` (+ _PT2 instances; the 3/8-face + [Z78] close the (3/8, 1/2] slice, recovering the 1/2-face) — the 3/8-form is the natural statement: **its face is exactly the region the external inputs cannot already close**. **Terminal ledger of the endpoint**: [Z-PT2] record below the frontier + one open exclusion face hOff38 on (tPT2, ∞) × (0, 3/8] (record footing, [Z78]-sharp, the 0126 squeeze certificate covers it fully at measured margin ≥ 1.1136) + [Z78] (which now closes **all** of d0 > 3/8 in body: offPairD0le on (3/8, 1/2], offPairFarEmpty on d0 > 1/2). The face-shrinking chain (0110/0108 record shrink → 0122 flank split → 0126 band-empty → 0127 unification → 0129 3/8-shrink) is **at its terminus**: further reduction requires an extended verified zero-exclusion record above tPT2 (route C; no public input as of the 0128 recon) or a zero-free input covering part of the strip interior. No RH claim is made or implied.

**Discovery 0130 (2026-10-20 — B6 item-4 audited, machine part):** the B6 packet's “single highest-leverage remaining human check” was machine-resolved against the pin. The 31k-line patch is `lean/patches/PrimeNumberTheoremAnd-lean4341.patch` (39,904 diff lines; 34,322 added / 3,447 removed), applied to **github.com/AlexKontorovich/PrimeNumberTheoremAnd @ c39a751132c88b6e8080b74c74023fd95b3d8be0** (full 40-char commit pin in lake-manifest; the lakefile enforces exact commit + exact origin + forward/reverse `git apply --check` + post-apply reverse verification). It is the **only patched dependency in the family-003 zeta closure** (the solution module `OAI.NumberTheory.DirichletL.Nonvanishing` — a 1,247-byte statement delegating to `SevenEighths.ProbeFinalAssemblyUnconditional` in the Detector subtree — imports `PrimeNumberTheoremAnd.Wiener`; the one other closure-level external import is a single RellichKondrachov embedding lemma). **Audit findings:** zero axioms/sorry/admit in any added line; exactly **two sorry-proof theorems removed** (dead Wiener decay scaffolds — the dependency's sorry surface *shrinks*); **no theorem statements changed** (1,033 new signature lines are support machinery; the 21 removed signature lines are 16 identical relocations + 4 scaffold removals + 1 file move); the body is a genuine Lean 4.34.1 proof port (~18,300 tactic lines of analytic number theory, no placeholder patterns in the sampling). **No upstream drift:** the release HEAD is still the kernel-verified commit (1581d4cbdd…), tree PR-locked, so the recorded 2026-10-07/08 kernel replays cover the exact bits. **Checklist standing:** items 1 (statement match — the zeta Comparator statement is verbatim `Z78.externalZeroFree78`, same Mathlib `riemannZeta`, re-fetched from the pin) and 6 (semantic scope — the statement literally names Mathlib's object) PASS; items 2 and 3 PASS per the recorded kernel replays (no drift); item 4's machine spot-check PASSES (human diff-reading now optional). **The solely open B6 item is item 5 — the 199-page paper reading (weeks-scale, human)** — corroborated by the two kernel replays, Banks' line-check of the Siegel companion, and the independent follow-up (arXiv 2610.12234) carrying the analytic core load-bearing. Graceful degradation unchanged: a NO-GO re-opens exactly `offPairFarEmpty` and `edgeZeroFree78` to cited-classical status. No RH claim is made or implied.
**Discovery 0131 (2026-10-20 — strip-interior input recon: a NEW kernel-verified input, [Z78L], shrinks the terminal face):** the route-3 watch of discovery 0129 (“zero-free input covering part of the strip interior”) fired. **Found:** Liu, “Slightly improved zero-free half-planes for the quasi-Riemann hypothesis” (arXiv 2610.12234, v2 2026-10-12; github.com/liubaiying101/Improved-zero-free-half-planes-for-the-quasi-Riemann-hypothesis) optimizes the parameter family (b, ˡ, κ) of the 7/8 argument to **B∞ = (18ξ+7)/(18ξ+9) = 0.874957019420098946…** (ξ the isolated root of 1188x³ − 2160x² + 171x + 190 in (0.38858, 0.38859)) — a **strictly stronger zero-free half-plane than [Z78]** (B∞ < 7/8; the band (B∞, 7/8] is newly covered), with the stated pole exclusion and the honesty note “This proves neither the Riemann hypothesis nor nonvanishing on the boundary.” **Verification footing:** HUMAN Lean formalization by the author with recorded strict replay **PASS (11 Oct 2026, Hong Kong)** — Lean 4.34.1, `--trust=0 -DautoImplicit=false -DwarningAsError=true -DmaxHeartbeats=0`, 10 files, **312 audited declarations using only propext / Classical.choice / Quot.sound**, generated 7-signature audit including the **certified decimal bracket 874957019420098946/10¹⁸ < B∞ < 874957019420098947/10¹⁸** and the zeta statement `zeta_nonzero (s) (hs : B∞ < s.re) (hpole : s ≠ 1) : riemannZeta s ≠ 0`. **Recorded caveats (kept on file):** the replay reused pinned external package artifacts (no clean network bootstrap) and “does not claim a second complete invocation of the packaged checker”; the foundation files OAI01–OAI08 are the pinned 2,925 required OAI 003 modules — so the deep analytic core **inherits the B6 input class** while the improvement delta is human-written Lean by an actual mathematician (the strongest available review footing for that part). **In tree** (new module `formal/RhAttack/Z78Liu.lean`, 262 lines, 0 sorry, gated, full tree green): the named input `externalZeroFree78Liu` carries her certified **rational upper boundary** `liuBUpper = 874957019420098947/10¹⁸` (strictly weaker than her algebraic-boundary statement, hence a valid consequence; pole guard inert on the pinned Mathlib via `riemannZeta_one_ne_zero`), with **proven** `extLiu_implies_ext78` ([Z78L] strictly strengthens [Z78] — norm_num: 8·874957019420098947 < 7·10¹⁸), `zetaZeroStripLiu` (actual zeros in [1 − liuBUpper, liuBUpper]) and `offPairD0leLiu` (every actual-set off-pair has **d0 ≤ liuD0max = liuBUpper − 1/2 = 374957019420098947/10¹⁸ < 3/8**, norm_num, sharp at both strip edges). **RHEnd Part B13** (2425 lines, 0 sorry): `rh_program78_stripfront_mach_unifiedLiu` (+_PT2) — the endpoint under [Z78L] with the single open face `hOffL` (no off-pair on [H, ∞) × (0, liuD0max]); the slice (liuD0max, 3/8] of the 0129 face is closed in body from [Z78L] (`rhend_sliceLiuExcl`) and the 0129 terminal statement is a **theorem** of the 0131 one (`...unified38_ofLiu` +_PT2). **Concurrent recon note:** a Zenodo record (10.5281/zenodo.18275102) initially matched as “a certified zero-free region in the half-plane ℛs ≥ 0.6” — which, had it stood, would have shrunk the face to ~1/10 by the functional equation — but the record is **replaced by a restricted-access work and its claim is no longer publicly verifiable: NOT adopted** (the face stays at the Liu constant on verified footing). **Updated terminal ledger:** [Z-PT2] record below the frontier + ONE open face `hOffL` on (tPT2, ∞) × (0, liuD0max] (record footing, [Z78L]-sharp) + [Z78L] (closes all of d0 > liuD0max in body). The face is still exactly where the external inputs are silent — only its certified width moved (~4.3×10⁻¹¹), now an exact rational bracket rather than a round number. Graceful degradation: a NO-GO on [Z78L] reverts the program to the 0129 terminal form (the 3/8 edge under [Z78]) — nothing in the tree depends on [Z78L] beyond Part B13 and the `Z78Liu` module. No RH claim is made or implied.

**Discovery 0132 (2026-10-20 — the independent [Z78L] replay PASSES; the machine side of the adoption is complete):** the queued machine step of 0131 ran to completion on this machine (32 cores, ~124 GB RAM; Lean 4.34.1 Release commit 5045d0056413266e57c625dcd7c365b10e377c52, fresh elan install), driving Liu's own byte-identical checker (`check.py` sha256-matched; `foundations.tar.gz` sha256-matched). **What the run did:** (1) CLEAN NETWORK BOOTSTRAP — every dependency fetched fresh over the network at its pinned SHA (mathlib `d13f23b723b8a846827a245b89c10fc7d3f11612`, leancert `7f91b6eb…`, PrimeCert `0803c2f6…`, PrimeNumberTheoremAnd `c39a7511…`, rellich-kondrachov `70f85d4c…`, plus the ten support packages), no shared package directory, no binary-cache reuse; (2) the two patched dependencies applied via bit-identical patches (sha256s matching the 0130-audited copies) and the ENTIRE external closure built from source — `Build completed successfully (8951 jobs)`; (3) STRICT REPLAY (`--trust=0 -DautoImplicit=false -DwarningAsError=true -DmaxHeartbeats=0`) of all ten proof files (OAI01–OAI08, PartsI_III, PartIV), single-process serial kernel replay (per-file wall 133s/145s/318s/193s/247s/295s/275s/359s/214s/358s), every per-file log empty under warnings-as-errors; (4) the DECLARATION-LEVEL axiom audit covers **all 312 audited declarations — Liu's own count — and every one depends on exactly {propext, Classical.choice, Quot.sound}** (zero deviations), including the final `zeta_nonzero`/`dirichlet_nonzero`/`hecke_nonzero` at the improved boundary, the old-7/8 bridge `beta_le_seven_eighths`, and the certified bracket (`xiInf_explicit`/`boundary_decimal_bracket`) that underwrites `liuBUpper`; (5) the 7-theorem final signature audit PASSed; (6) BYTE IDENTITY: sha256 of all ten proof sources, the archive, and the checker itself MATCH the public repository (clone `46d612c2`). **This resolves the recorded caveat** from her own replay (which reused pinned artifacts and did not exercise a clean bootstrap): the second-party run WAS clean-bootstrap/from-source. **Kernel standing, stated precisely:** the Lean 4.34.1 kernel has now replayed the whole [Z78L] source through TWO independent parties (producer 2026-10-11; this run 2026-10-20); the second-kernel (NanoDa) coverage exists for the OAI 003 FOUNDATION source at the identical pin (teal-sea's 2026-10-08 comparator replay, whose record independently cross-checks the 0130 patch facts); the delta files are two-party Lean-kernel replayed, not yet second-kernel (queue-able, not blocking). **Delta due-diligence (machine reading of her improvement, from hash-verified sources):** the improvement is a one-step parameter lemma (for t ∈ [0.38858, 0.38859] with κ(t) ≤ 3/4: β ≤ (1+κt)/2 ⇒ β ≤ boundary t — the old 7/8 base is the κ = 3/4 case) proved with exact-rational Bernstein-form endpoint geometry, plus a finite bootstrap iteration (every iterate of Kₙ/Bₙ is an actual family bound; the sequences converge to the fixed-point root ξ∞; β ≤ B∞) from the proven 7/8 base — i.e. the stated mechanism (“same strategy, b, ℓ, κ varied”), with her optimality scoped exactly as she states it. **No in-tree change:** the 0131 terminal ledger stands (RHEnd.lean 2425 lines, 0 sorry; face `hOffL` on (tPT2, ∞) × (0, liuD0max]). **What does not move:** no RH claim; B6 item 5 (the 199-page paper reading, weeks-scale human) remains the SOLELY OPEN B6 item and underwrites the foundation of BOTH [Z78] and [Z78L] together; route C was re-checked the same day (teal-sea live record, compiled 2026-10-19: Platt–Trudgian tPT2 still the record; no successor); the Washburn Re s ≥ 0.6 record remains replaced/restricted and un-adopted.

**Discovery 0133 (2026-10-20 — the tracker frontier BEATS Liu while B13 was green: [Z78T] adopted, the face shrinks by 1.39954×10⁻⁴, its second-largest step ever):** the strip-interior input watch of 0129/0131/0132 fires again. The QuasiRiemannTracker (github.com/GTimG/QuasiRiemannTracker) — a public competitive leaderboard of kernel-verified zero-free half-planes (canonical all-Dirichlet statement; protected admission pipeline: Comparator + Lean/NanoDa/con-ron in a pinned sandbox whose `tool-pins.json` sha256-locks every kernel binary) — had, as of the live catalogue of today, passed the tracker-recorded Liu value (0.874957069799) by a DOZEN records (20 of the 25 on the board sit below it) — a race that had already reached 0.874957019420 on 2026-10-09 (nielstron-20261009-tightening and proofcouncil-20261009 — the same bootstrap fixed point as Liu's formalization, three days BEFORE her v2) and then ran 0.874957 → 0.874861 (cycle61, 10-13) → 0.8748559 (10-14) → 0.874840 (10-15) → 0.874836 (10-16) → 0.874830 (10-18) → 0.874828524351 (10-20) → 0.874817065 (10-20, today's top). **Top record as of today:** `two-level-affine-20261019` (PR #67, ArviFoxy, **MERGED 2026-10-20 08:30:51Z**, status `framework-verified`, label `new-bound`, top of the 25-record live catalogue as of 2026-10-20): the **all-Dirichlet zero-free half-plane at the certified rational boundary θ = 174963413/200000000 = 0.874817065** (principal pole excluded; the class bound is COMPUTED IN THE LEAN KERNEL into [0.874817064464, 0.874817064465] with the 9-digit claim its ceiling — no hard-coded constants, the tracker's no-hardcoding check; 923 files / 922 modules / 127,695 lines). **Standing of the verification at adoption:** the tracker's protected pipeline — Comparator checked the canonical all-Dirichlet statement at 174963413/200000000 for the submitted commit; Lean, NanoDa and con-ron accepted the proof in the standard sandbox; merged and published as a new board bound — plus PR #67's own verification block (clean build of all 922 modules on pinned Lean 4.34.1; `Candidate.bound` depending only on propext/Classical.choice/Quot.sound; independent kernel runs: lean4export 148s, NanoDa exit 0 in 159s, con-ron accepting 132,192 declarations in 940s; 923-file byte identity; manifest validator). **Caveat posture (honest, on file):** PR #67 notes the hosted worker's build may rest on the submitter's independently verified local execution if the worker is single-threaded — the same producer-run posture as the [Z78L] recorded replay; an **independent replay of the submission through the tracker's pinned verifier environment is QUEUED** (the same pin family as the 0132 Liu replay: Lean 4.34.1, mathlib d13f23b7, PrimeNumberTheoremAnd c39a7511, rellich-kondrachov 70f85d4c; the 923-file sha256 snapshot, the record metadata, `Main.lean`, the live catalogue, and the verifier inventory are archived under `tmp/b6audit/tracker/`). **Foundation dependency:** the record builds on the tracker's `openai-baseline` (the OAI 7/8 half-plane — the SAME OAI 003 source under the B6 audit) plus tracker records (Akash Levy PR 6, Gao PR 63, Collet cycle61 PR 42, radical-asymmetric PR 50) — so B6 item 5 (the 199-page paper reading, weeks-scale human) underwrites the foundation of **all three** named inputs ([Z78], [Z78L], [Z78T]) together. **In tree:** new module `formal/RhAttack/Z78Track.lean` (named input `externalZeroFree78Track` at `qxUpper = 174963413/200000000` — the χ = 1 specialization of the verified all-Dirichlet statement, pole guard inert via `riemannZeta_one_ne_zero`; **proven** `qxUpper < liuBUpper` (norm_num cross-multiplication), so `extTrack_implies_extLiu` / `extTrack_implies_ext78` strict-strengthen the whole chain; `zetaZeroStripTrack` / `offPairD0leTrack` re-sharpened at the new constant: every actual-set off-pair has **d0 ≤ qxD0max = qxUpper − 1/2 = 74963413/200000000 = 0.374817065 < liuD0max < 3/8**, sharp). **RHEnd Part B14** (ADDITIVE — B12/B13 preserved; RHEnd.lean 2629 lines, 0 sorry, target and full tree green): the slice (qxD0max, liuD0max] is closed in body from [Z78T] (`rhend_sliceTrackExcl`); `rh_program78_stripfront_mach_unifiedTrack` (+_PT2) is the **new terminal endpoint** with ONE open face `hOffT` (no off-pair on [H, ∞) × (0, qxD0max]); the 0131 Liu-form terminal statement is a **theorem** of the 0133 one (B14.4/B14.5) — the additive B-part pattern continues. **Step size:** the face shrank by liuD0max − qxD0max = 1.39954×10⁻⁴ — 3.3× the 0131 input step (4.298×10⁻⁵), the second-largest shrink of the chain after 0129's 1/2 → 3/8 step from [Z78] itself; cumulative face width from 3/8: 1.82935×10⁻⁴. **Snapshot caveat:** the board moves DAILY — [Z78T] is the verified state of 2026-10-20 and a successor snapshot supersedes it mechanically (this unit is the B6-section-8 input-upgrade protocol executed a second time; the protocol is now a demonstrated conveyor). **Updated terminal ledger:** [Z-PT2] record below the frontier + ONE open face `hOffT` on (tPT2, ∞) × (0, qxD0max] with qxD0max = 74963413/200000000 = 0.374817065 (record footing, [Z78T]-sharp; the squeeze certificate still covers the face fully, face minimum unchanged at the d0 = 1/200 edge, margin ≥ 1.1136 to the frontier) + [Z78T] (closes all of d0 > qxD0max in body; [Z78L] and [Z78] remain corollary inputs). Graceful degradation: a NO-GO on [Z78T] reverts to the 0131 terminal form (B13 preserved in tree). No RH claim is made or implied — the face is still exactly where the external inputs are silent; note the classical zero-free regions measured in 0128–0129 (ℛs ≳ 0.504 at t = 3×10¹²) remain far from competing with this input family at any height.

**Discovery 0134 (2026-10-20 — the independent [Z78T] replay PASSES; the machine side of the 0133 adoption is complete):** the queued independent replay of the tracker frontier record ran to completion on this machine (32 cores; Lean 4.34.1 Release commit 5045d0056413266e57c625dcd7c365b10e377c52) in the same structural form the tracker's own standard replay uses (per-module compilation in topological order against the pinned dependency footprint). **What the run did:** (1) BYTE IDENTITY — all 922 candidate `.lean` files verified sha256-identical to the archived 923-file snapshot at replay start; (2) DEPIN-EXACT external footprint — dependencies fetched at exactly the tracker's standard pins (mathlib `d13f23b723b8a846827a245b89c10fc7d3f11612`, PrimeNumberTheoremAnd `c39a751132c88b6e8080b74c74023fd95b3d8be0`, rellich-kondrachov `70f85d4c1bf99c6e7d61e8be4daa6f3664d08d23`) with the two compatibility patches whose sha256s match the B6-0130-audited copies **byte-for-byte** (`08904323…` / `0c121d85…`), and the 273-module pinned closure — independently recomputed from the candidate's own import lines and equal to the B6-0130 closure (the Mathlib closure + `PrimeNumberTheoremAnd.Wiener` + the single RellichKondrachov embedding lemma) — built green **from source**; (3) CANDIDATE COMPILATION — all **4077** modules (922 two-level-affine + 2927 openai-baseline + 228 akashlevy-20261009-weighted-numerator) compiled from source through the Lean 4.34.1 kernel in topological order: **0 failures, 0 not started, 2536 s**; (4) STATEMENT MATCH at kernel level — the canonical all-Dirichlet statement at the literal rational `(174963413/200000000 : ℝ) < s.re` compiles, and the one-line wrapper `exact Candidate.bound χ hs hpole` type-checks against it; and `Candidate/Main.lean` itself states the claim with `Cycle63.Arithmetic.theta := 874817065/1000000000` whose equality to `174963413/200000000` is computed by `norm_num` inside the proof — the boundary is **derived, not inserted**; (5) AXIOM AUDIT — `#print axioms QRH.canonical_bound` after the full closure: **exactly `[propext, Classical.choice, Quot.sound]`** — zero `sorryAx`, zero exotic axioms anywhere in the cone. **Deviations from the official tracker receipt, on file:** Lean-default kernel only (the official also runs NanoDa and con-ron, unavailable here); no bwrap sandbox (dedicated machine); external footprint rebuilt from source at identical pins/patches rather than the official prebuilt snapshot-authenticated libraries (stronger in that respect); statement match via kernel-level type-check against a textually identical canonical statement rather than leanexport+comparator (stronger in that it is at the type level). **[Z78T] is hereby upgraded from recorded-PASS (official pipeline) to independently second-party verified** — the same gate-2 step 0132 executed for [Z78L]; the B6 section-8 input-upgrade protocol (statement / verification / pin-equivalence / in-tree adoption / integrity) has now completed end-to-end for two distinct input families in one session. **No in-tree change:** the 0133 terminal ledger stands (RHEnd part B14, 2629 lines, 0 sorry, full tree green; face `hOffT` on (tPT2, ∞) × (0, qxD0max]). **What does not move:** no RH claim; the face remains exactly where the external inputs are silent; B6 item 5 (the 199-page paper reading, weeks-scale human) remains the solely open B6 item and underwrites the shared OAI 003 foundation of [Z78], [Z78L] and [Z78T] together; the board was re-checked during the run — two-level-affine-20261019 still tops the live 24-record catalogue with zero records stronger than 0.874817065 as of the 2026-10-20 11:30Z fetch (it is a moving snapshot; a strictly stronger merged record supersedes it by the same demonstrated unit).


**Discovery 0135 (2026-10-20 — B6 item 5 CLOSED: the full [Z78] paper read, no flaws found in the load-bearing pieces; the B6 checklist is now complete):** the B6 packet's long pole — item 5, the "weeks-scale human" reading of the 199-page source paper — is done, executed as a piecewise machine read per the 2026-10-20 directive ("we will just compact you"). **Method:** the full 16,677-line TeX (pinned at openai/math `1581d4cbdd...`, TeX sha256 `42a5ee0f...`, PDF sha256 `8fe93046...` on file in `tmp/b6audit/b6item5/provenance_hashes.txt`) read section by section in-tree at claim level, in six summary parts (`summary-part1-intro.md`, `summary-part2-continuation.md`, `summary-part3-arithmetic.md`, `summary-part4-analysis.md`, `summary-part5-reflection-probe-detector.md`, `summary-part6-conclusion-endpoint.md`) plus a `VERDICT.md`; exponent arithmetic re-derived independently at every load-bearing point; summaries re-checked against the source at the load-bearing lemmas. **The six checklist pieces the packet named, status (all PASS):** (1) **theorem statement and scope** — Thm main asserts the uniform HALF-PLANE Re s > 7/8 (strict; boundary not claimed) for ALL finite-order Hecke L over Q(√−3) and ALL Dirichlet L including classical ζ, principal pole allowed; consistent end to end, with the 11/12 theorem as the genuine Stage-I milestone of the same machinery; (2) **principal-pole allowance** — the s = 1 pole is kept and isolated at the (z, w) = (1/6, 1) corner; M(1/6) > 0 is proved without a sign assumption; H_η is a contraction (|H_η − 1| ≤ 1/2) on the target half-plane — no hidden cancellation; (3) **Hecke over Q(√−3)** — O = Z[ω], primary generators, zero-extended sextic symbol powers carried correctly through the additive norm, the quadratic sieve, and the frozen-mask identity (the "a local exponent divisible by six is the indicator of the units, not the constant one" subtlety is handled everywhere it bites); (4) **11/12 → 7/8 two-stage argument** — BOTH stages are applications of ONE continuation principle; Stage I (balanced low + balanced high + late height + transfer) is complete and internally consistent; Stage II uses the compensated probe (slots + plain/inverse moment inductions + local compensation) with a uniform endpoint certificate; (5) **continuation principle** — fully written and valid (Mellin transform + Fourier inversion at Re s = 2 without crossing a zero + identity theorem ⇒ 1/L^S holomorphic past β* − ε* ⇒ contradiction); its only uniformity demand is the target-independence of ω, σ, and both stages meet it with explicitly pretarget choices (Stage I: σ = 1/4800 fixed; Stage II: σ = m/2, m = (1/4)min{m_high, m_w, m_z, m_P} fixed); (6) **moment estimates** — balanced low (planar additive large sieve + unmarked completed-row moment Z^{1+ε}), sextic large sieve (BGL recursion, fixed point 4/3 ⇒ K + D + (KD)^{2/3}), the row envelope R(δ) = min{1, max(1−δ/2, 4/3−δ)}, the plain/inverse witness saturations — verified at the level used. **Key re-derivations (all match the paper exactly):** the Part II common-high identity E(d) = C₀ + (2/3)δ + q/6 − h(1−R) + (d−h)(R + δ/2 − 17/50) **forces C₀ = −1/48** (the one remaining open thread from the read — closed: first line ⇒ −1337/2400 + (25/96)δ + q/6 + d(·); second line ⇒ (C₀ − 1287/2400) + the same; difference −50/2400); the floor bin E(h) ≤ C₀ + (3/4)δ₀ = −7/1200 < 0; the δ = 5/6 endpoint E(h) ≤ C₀ + (3/4−h)δ = −1/48 − δ/16 < 0; the compensated endpoint certificate — an explicit sum-of-squares (3+5y){(4vδ−79)² + 49} + 4y{4vδ[(1+3y)(15+32y)δ + 9−13y] + 265+3485y} ≥ 49(3+5y), with v ≤ 17(3+5y) and 𝓘 ≤ 5/2 — giving **−E_* ≥ 49/440640 > 10⁻⁴ UNIFORMLY** on 1/50 < δ ≤ 5/6, measured against the **moving** C(β*) = C(7/8) + Δ (essential: the certificate is a saving against the hypothesized rightmost zero, not a fixed negative exponent — this is the hinge of the whole paper); the Dirichlet transfer (η(a) = χ(Na); split/inert local factors; L_F^{S_Q}(s, η) = L^{S_Q}(s, χ)L^{S_Q}(s, χχ_{−3}); L(1, χ_{−3}) = π/(3√3) recomputed); the quadratic transfer and the 11/12 closure (σ = m/2 = 1/4800 target-independent). **Verdict: NO FLAWS FOUND.** No bound is applied outside its stated domain (row-dependent contours stay row-specific; the one-sided contour-join discipline and the "empty bin contributes zero" convention are explicit); the single-allocation twist-height bookkeeping holds; every loss budget is stated and sums to the claimed margin (Stage I: 46ε* < m₀/4 with 3m₀/4 retained; Stage II: four allocations < m_high/2 plus the final allowance leaving 3m_high/8, and 3/4 of each of m_w, m_z, m_P). **Honest scope notes (on file, non-blocking):** the audit is a second-party READING with re-derivation, not a kernel check; the slot/amplifier interior of Part II (the "7/37 moment requirement" of lem:plain, the S_i/A_T normalizer asymptotic) was verified at the level its claims are USED in the endpoint assembly (mesh, fixed width gaps, nonzero normalizer, pretarget margins), not coefficient-by-coefficient — a reading-level assurance, stated as such. **Implication:** the FULL B6 CHECKLIST IS NOW CLOSED — all six items pass (1 and 6 from the 0130 re-verification; 2 and 3 from the recorded kernel replays; 4 machine spot-check from 0130; 5 this reading). The [Z78] input class, and with it the shared OAI 003 foundation underwriting [Z78], [Z78L] and [Z78T], has every planned review question answered: producer + independent kernel replays (0132 for [Z78L], 0134 for [Z78T]), the 0130 compatibility-patch audit, the teal-sea second-kernel (NanoDa) foundation replay, pin-equivalence checks (0131 gate 3), and now the full paper reading. The sole machine-side residual in the family is the queue-able, non-blocking second-kernel replay of the [Z78L] DELTA files (PartsI_III + PartIV). **No in-tree change:** RHEnd part B14 stands (2629 lines, 0 sorry, full tree green; face hOffT on (tPT2, ∞) × (0, qxD0max]). **What does not move:** no RH claim; the open face remains exactly where the external inputs are silent; the standing queue is unchanged — supersession watch for anything beyond 174963413/200000000 (board re-checked live at 2026-10-20 11:30Z: none), internal-flank / new-analytic work toward hOffT, and broader RH levers beyond endpoint tail maintenance.

**Discovery 0137 (2026-10-20 — Xu-Sang arXiv:2610.15291 fully read and audited: NO FLAWS FOUND at the audit level; B1 = 0.8748867 stays below [Z78T]; its amplified-numerator + kappa-feedback mechanism is the documented next frontier species):** the follow-up paper mapped in 0136 is read in full (2,894-line TeX, provenance-hashed, `tmp/b6audit/sangxu/`, machine-readable audit in `AUDIT-SUMMARY.md`, gitignored). Theorem (CONDITIONAL on the OAI26 analytic inputs — the B6 item 5 audited source): all finite-order Hecke L over Q(√−3) and all Dirichlet L zero-free in Re s > B1 = 8748867/10^7 = 0.8748867, poles at s = 1 allowed. Three refinements, all verified: (1) **decay retention** extends the total prime length from the OAI maximum ℓ = 1/6 to ℓ = 1/5 (saving −d + (5ℓ+d−1)₊/8 ≤ −7d/8 ≤ 0, exact); (2) the **amplified first moment of the reflected numerator** (a Hölder quarter of OAI's plain fourth moment with sixth-power slot amplitudes) replaces the pointwise subpower bound — the balance identity making the per-block saving length-independent (−ρm − qv(1−2m)/2 = −ρ/2) is exact, and the same prime amplitudes serve row count and numerator average (single allocation); (3) the **κ feedback bootstrap** 7/8 ⇒ κ₀ = 3/4 ⇒ B0 = 69991/80000 ⇒ κ₁ = 29991/40000 ⇒ B1 — licensing identities (1+κ₀)/2 = 7/8 and (1+κ₁)/2 = B0 re-derived exactly; the κ feedback contributes exactly B0 − B1 = 1/1250000. **Independent verifications (all done in-session, exact arithmetic):** both Appendix D endpoint certificates re-derived as EXACT polynomial identities (2Λⱼ𝓙(−Eⱼ−gⱼ) = 𝓐ⱼδ²+𝓑ⱼδ+𝓒ⱼ; all five discriminant coefficients reproduced) ⇒ Eⱼ < −gⱼ on the FULL rectangles 0 ≤ δ ≤ 5/6, 0 ≤ x ≤ 1/2 without sampling; every displayed scalar margin recomputed (small-delta, floor, small-rows all strictly below their stated floors; at small rows my own per-row reconstruction is strictly stronger than the displayed bound); the geometry identities C_b(B(ℓ)) = l_x/2+b/12, B(ℓ) = 11/12−ℓ/4 and all l_x, l_y, h values re-derived; the κ-extension lemma (the only new analytic lemma on OAI's moments, 13/18 ≤ κ ≤ 1) checked at every κ-occurrence in the stated induction (6κ−1 ≥ 10/3 and z < M/20 exact at κ = 13/18; greedy repair cost κ{F/(6κ)+η} ≤ F/6+η exact); the continuation argument is the same continuation principle closed in B6 item 5; the row count at κ = 3/4 reduces EXACTLY to the OAI Part II endpoint balance (D_κ(x) = (37+34y)/18 = the OAI D_x). **Position: B1 = 0.8748867 is 69.9×10⁻⁷ above the [Z78T] boundary 174963413/2000000 = 0.874817065 — WEAKER than the adopted frontier, NOT adopted** (larger boundary = smaller zero-free region). Provenance note: the paper's commented-out Lean companion reference (github.com/xuyd16ai/seven-eighths-numerator-amplification-lean) is a live 404 — no public Lean verification of this mechanism exists; the paper discloses AI-assisted development and asserts no end-to-end Lean verification. The 0136 queue pointer (Sang/Xu read; then Kosulsuz) is hereby advanced: 2610.15291 read; **the trailing 'Kosulsuz 2610.09982' pointer is VOID — corrected in Discovery 0138 (that ID is a Shi-Zuo algebraic-geometry paper; no such author exists; phantom provenance, voided).** No in-tree change: RHEnd B14 stands (2629 lines, 0 sorry, face hOffT on (tPT2, ∞) × (0, 74963413/200000000]). Board re-checked live after this read: 24 records, top still two-level-affine-20261019, no successor to [Z78T]. No RH claim.


**Discovery 0138 (2026-10-20 — PROVENANCE CORRECTION: the 'Kosulsuz 2610.09982' reading-queue entry is a phantom, voided):** the arXiv fetch of 2610.09982 (the pointer recorded in 0136/0137 as a 'Kosulsuz per-zero positive-moment certificate') returned a Tsinghua algebraic-geometry paper — Shi & Zuo, 'A combinatorial criterion for detecting roots of Bernstein-Sato polynomials' (strong monodromy for determinantal/Pfaffian ideals; MSC 14F10; e-print tarball sha256 `6203b14088...` on file) — and author searches find **no mathematician named Kosulsuz**. The pointer is an unmoored memory fragment with an unverified ID, the exact failure mode of the verified-footing rule; it is hereby VOID with no replacement under that name. **Replacement reading queue (all IDs real and verified in the same 2026-10-20 sweep):** (1) **Bellotti–Trudgian–Yang, 'Zero-free regions inspired by work of Heath-Brown', arXiv 2603.21490** (March 2026) — new explicit CLASSICAL zeta zero-free region from the Linnik/Heath-Brown machinery; the only swept record potentially relevant to the frontier comparison (our classical-region survey predates it) — next reading unit; (2) the **de Bruijn–Newman constant Lean formalization** (arXiv 2026-10-08): kernel-checked Λ ≤ 9/32 composed from OAI's 7/8, v1.1 Λ ≤ 0.2811857 from Liu — ecosystem evidence the 003 foundation composes in Lean; (3) **Mori Zenodo 23355293/23355616** (Liu-family boundary 43747851/50000000 = 0.874957020, rational certificate + checker, 2026-10-14) — weaker than [Z78T], provenance-pattern only. **Reinforcement of a standing rule:** an arXiv ID carried in notes is a POINTEER, not a source — fetch and identity-check (title, authors, subject) before any queue bookkeeping claims it.


**Discovery 0139 (2026-10-20 — BTY arXiv:2603.21490 read: new best classical record A = 4.896 / 4.8594; contributes NOTHING to the face; not adopted):** the first real entry of the 0138 queue is read and verified at statement+mechanism level (1,387-line TeX, hashed, tmp/b6audit/bty/): Bellotti–Trudgian–Yang prove ζ(σ+it) ≠ 0 for t ≥ 3, σ > 1 − 1/(4.896 log t) (Thm 1.2: 4.8594 from the thesis constants), beating the Mossinghoff 5.559 record. Mechanism: inductive zero-detector with nonnegative trigonometric polynomial (a₁ > a₀ > 0…), Stechkin pair-positivity, Heath-Brown w-smoothing tensor a 7-term rational discrete approximation of the limiting sigmoid 1/(1+e⁻ᵘ); efficiency c = 859/433 = 1.98383 (loss 0.808% < the claimed 1%, re-derived: Σκ = 433/859); the optimized range 3 ≤ t ≤ e^{76.47} targets the band just above the Platt 3·10¹² plateau, with explicit Littlewood (19.62) covering beyond. **Decisive computation:** 1 − 1/(4.896 log t) meets 0.874817065 at t = 5.112 and is strictly weaker for all larger t; at the face height tPT2 = 3.0001753328·10¹² the BTY boundary is 0.992891 — disjoint from the face [0.125182935, 0.874817065] × (tPT2, ∞). Classical log-width regions are a different species from θ-half-planes: they hug σ = 1 and are subsumed by any fixed-θ input (here [Z78T]) above a small crossover height. **Not adopted; no in-tree constant moves.** Queue: only the two ecosystem-only items remain (DNC Lean composition; Mori 0.874957020 certificate) — footing-analysis only, logged in 0140 if material.


**Discovery 0140 (2026-10-20 — ecosystem close-out; complete quasi-RH frontier map; queue exhausted):** the two remaining queue items plus one board-adjacent record examined; all weaker than [Z78T], nothing adoptable. (1) **DNC Lean composition** (Zenodo 23269134, 2026-10-09; v1.1 Λ ≤ 0.2811857): kernel-checked Λ ≤ 9/32 for the de Bruijn–Newman constant by composing OAI's kernel-checked 7/8 statement — **imported from openai/math at commit adc7f124, the EXACT OAI pin of the 003 family recorded in 0131** — with de Bruijn's heat flow; a third independent Lean consumer of the pinned foundation (after Liu and the tracker). (2) **Mori** (Zenodo 23355293/23355616): boundary 43747851/50000000 = 0.874957020, Liu-family certificate+checker; weaker than the [Z78L] certified upper by 5.8·10⁻¹⁰, far weaker than [Z78T]. (3) **Collet, cycle61** (haileystorm.github.io): boundary 874861/10⁶ = 0.874861 — the tracker frontier author's earlier same-family step. **Frontier map (strong → weak, exact):** [Z78T] 174963413/200000000 (adopted, replay-verified 0134) < Collet 0.874861 < Xu-Sang B1 8748867/10⁷ (0137) < Mori 0.874957020 < Liu [Z78L] 874957019420098947/10¹⁸ (0131) < OAI 7/8 (B6-closed 0135); the top three are exactly the in-tree implication chain extTrack ⇒ extLiu ⇒ ext78. Board watcher: no successor to [Z78T] in the 2026-10-20 live checks; **the external frontier queue is exhausted for this sweep.** Posture unchanged: watch, internal-flank work toward hOffT (|Re s − 1/2| ≤ 74963413/200000000, t > tPT2), broader RH levers. No in-tree change; no RH claim. *CORRECTION (0143): the map line above was representative, not complete - the board at that time already held 26 records (only 6 named), and its Mori/Liu segment is reversed: the actual order strong→weak is nielstron-20261009-tightening 874957019420098946128603850561452983/10^34 (board, STRONGER than [Z78L] certified) > [Z78L] certified 874957019420098947/10^18 > proofcouncil 874957019421/10^12 (board) > Mori 43747851/50000000 = 0.874957020 (Zenodo only, NOT a tracker record) > liu-20261008 (1507−2√921)/1653 (board) > OAI 7/8. Full 26-record map + genealogy in 0143.*

The barriers of T4OffL say nothing about whether left-flank zeros
exist: they are FORMAL NEGATIVE RESULTS about what the current
machine wire can do, stated exactly. No RH claim is made or implied.

**Discovery 0141 (2026-10-20 — CYCLE63 FAMILY CEILING CERTIFIED (numerical): the adopted frontier record two-level-affine-20261019 is at its family-internal optimum; no tuning knob remains; beating 0.874817065 requires a new structural cycle):** full numerical replication + ceiling analysis of the 0133/0134 ADOPTED record (byte-identical replayed source, workspace `tmp/b6audit/tracker/opt/`). **Method:** every constant of the Cycle63 candidate is closed form — the only presentation number is `theta := 874817065/10^9` in `Cycle63/Arithmetic/Constants.lean`; everything else is computed (q0 = firstJunction = rate-channel/fee crossing, q1 = secondJunction = argmin of the class bound, h = hStar, the ledger plane (lambda, B) at the crossings, slotTop = balanced window top rounded to the cell grid; the pipeline is the 3-pass alternation of `TwoLevelLedger.lean`). **Replication (pure Python, `repro.py`):** final q0 = 0.6380116285, q1 = 0.7026509458, slotTop = 0.04005052, lambda = 3.724321310995, B = 0.980386967688, deltaStar = 0.463086695, hStar = 0.797268061, and **class bound thetaMin(lambda,B) = 0.8748170644121718** — the board record's structure reproduced to 10 decimal places; claim margin theta − cb = 5.878×10⁻¹⁰ (the claim sits 5.9×10⁻¹⁰ above the class bound, the offset-budget limit). **Ceiling verification (`scan.py`, `ceiling.py`):** (1) rate margin at the fixed point = 1.7×10⁻¹⁶ (the corner is exact); (2) 2D fine scan (q0 ±1%, q1 ±0.01, feasibility respected): global minimum = the fixed point, gap 0.0 to machine precision; (3) q0-profile: strictly increasing above the crossing (1.7×10⁻⁵ to the domain edge), decreasing toward it from 3/5 — a genuine corner, not a domain artifact; (4) q1-profile: unique interior stationary minimum (first derivative ≤ 6.6×10⁻⁷, quadratic rise 1.3×10⁻³ per 10⁻³ displacement); (5) domain endpoints [3/5,17/25]×[17/25,18/25] verified NON-tight (continuation of q1 to the slot price 4499/6000 monotonically worsens the bound); (6) window-top rounding cost ≤ 2×10⁻¹²; (7) the single non-structural knob — `plainCapacityCost` pinned at 3/4 (the OAI 7/8 baseline price) vs the actual Akash-Levy price 2·10499/12000−1 = 4499/6000 (from the already-imported Levy submission) — RE-TESTED by re-running the pipeline at the tighter price: the class bound drops to 0.8748170640827679 — **WORSE** by 3.3×10⁻¹⁰: the 3/4 pin is at or near the family optimum, not a missed opportunity. **Consequence:** the published two-level-affine CANNOT be beaten by tuning; the next board record must be a NEW structural cycle (the board top's own date was 2026-10-20 — one day old). **Sensitivity map for the next structural author** (the corner must MOVE, not be nudged): linear cost 1.394×10⁻⁴ per unit q0 above the crossing; quadratic ~1.3×10⁻³ per 10⁻³ displacement in q1; balanced window top inert. **Mechanism intelligence** (with 0137): the unexplored combination space where the next record most likely lives is the Xu-Sang amplified/reflected-numerator κ-feedback mechanism on the Collet/Gao two-level-affine substrate (or vice versa). No in-tree change (nothing stronger to adopt); the board watcher stayed live and the adoption protocol for a successor (0133/0134 template) was staged. No RH claim.

**Discovery 0142 (2026-10-21 — BOARD SUPERSESSION EXECUTED: the five-step-affine record (Gao, 0.8748087) beats [Z78T]; B6 section-8 protocol run end-to-end; adopted as [Z78G] with Part B15; terminal face is now hOffG on (0, gaoD0max] with gaoD0max = 3748087/10^7 = 0.3748087):** the board watcher fired the morning of 2026-10-21 — ONE DAY after 0141 proved the adopted cycle63 family is at its family-internal optimum and forecast the next record would be a new structural cycle, the board top moved to exactly that species. **New top:** `gao-five-step-affine-20261020` (PR #68, Zhongpai Gao / Gaozhongpai), MERGED 2026-10-21T07:16:31Z, first verified 2026-10-21T02:06:55Z, framework-verified, source commit f07bb2418990a9976c0da5f65bb6a7a77da94c9a of GTImG/QuasiRiemannTracker — the all-Dirichlet zero-free half-plane at the **certified rational boundary 8748087/10000000 = 0.8748087** (pole excluded), 25-record board top, 8.365×10⁻⁶ stronger than [Z78T]. **Structure (catalogue + paper, read in full):** ArviFoxy's two-level returned-source organization extended to FIVE affine junctions (0.638021915, 0.676506091, 0.693781289, 0.711716695, 0.730301837; recursive region-price identities with 1e-8 per-stage slack); joint count of returned HIGH histories over complete arithmetic histories with one final density payment; terminal payment with the −h(q)R double-count correction; exact rational Bernstein-basis endpoint certificates (positive coefficients on closed rectangles; per-stage budget > 1e-7; endpoint margin θ − 1e-7); the κ-feedback step extending the endpoint from κ* = 2θ−1 to the actual 2β−1 (the Xu-Sang mechanism of 0137, now inside a tracker construction — the 0141/0137 "unexplored combination space" is occupied); a CONCRETE root moment built by backward induction from actual finite native sources (`Cycle153Endpoint.actualRootMomentFactory` — "not a hypothesis of this theorem"); builds on 10 records INCLUDING two-level-affine-20261019 (direct descendant of [Z78T]). **B6 SECTION-8 PROTOCOL (third end-to-end demonstration):** (1) IDENTITY — candidate fetched at the exact source commit (blobless sparse clone; 1514 self-contained candidate Lean files); entrypoint `Candidate/Main.lean` sha256 3f479c8e… byte-identical to the raw GitHub fetch; statement = the canonical all-Dirichlet form (Mathlib `DirichletCharacter.LFunction`, pole guard) at exactly 8748087/10^7. (2) INDEPENDENT SECOND-PARTY REPLAY PASS (2026-10-21, `tmp/b6audit/tracker/gao5_replay/`, this program's standard environment, same pins/patches as 0134: Lean 4.34.1, mathlib d13f23b7…, PrimeNumberTheoremAnd c39a7511 + B6-audited patch, rellich-kondrachov 70f85d4c + B6-audited patch): both Submissions dependency subtrees (openai_baseline 2927 files, akashlevy 228 files) verified **BYTE-IDENTICAL** at f07bb241 to the 0134 replay tree; snapshot guard 1514/1514; **4669/4669 modules compiled from source in dependency order, 0 failures, 0 not started, 3088.7 s**; kernel statement match — the one-line bridge `exact Candidate.bound` type-checks against the canonical statement at exactly 8748087/10000000; axiom cone of the canonical statement **exactly `[propext, Classical.choice, Quot.sound]`**; **0 `sorry` tokens** in the 1514-file cone. Deviations from the official receipt recorded as immaterial (default kernel only — official also ran nanoda + con-ron per certificates/gao-five-step-affine-20261020.json, run 39514163334, report_sha256 e7221b03…; no bwrap sandbox; external footprint rebuilt from source). (3) PIN EQUIVALENCE — the foundation is the SAME byte-identical openai-baseline subtrees under the B6 audit; no OAI delta. (4) IN-TREE ADOPTION AS **[Z78G]** — new module `formal/RhAttack/Z78Gao.lean` (named input `externalZeroFree78Gao` at `gaoUpper = 8748087/10^7`; `gaoD0max = gaoUpper − 1/2 = 3748087/10^7 = 0.3748087`; norm_num chain `gaoUpper < qxUpper < liuBUpper < 7/8`; `extGao_implies_extTrack/_extLiu/_ext78` — the full implication chain [Z78G] → [Z78T] → [Z78L] → [Z78] preserved; `zetaZeroStripGao` / `offPairD0leGao` re-sharpened at the new constant; Float gates 0.8748087/0.1251913/0.3748087). **RHEnd Part B15** (ADDITIVE — B12/B13/B14 preserved; RHEnd.lean 2839 lines, 0 sorry, full tree green): `rhend_sliceGaoExcl` closes the slice (gaoD0max, qxD0max] of the B14 face in body; `rh_program78_stripfront_mach_unifiedGao` (+_PT2) is the **NEW terminal endpoint** with ONE open face **hOffG** (no off-pair on [H, ∞) × (0, gaoD0max]); the 0133 track-form terminal statement is a **theorem** of the 0142 one (B15.4/B15.5) — the additive B-part conveyor runs a third time. (5) PAPER AUDIT (four pages, TeX sha256 6b4b58fd… + parameters.json ff567186… + source-bindings.json 43588e56… on file in `tmp/b6audit/tracker/gao5/`): read in full from the parameter-bound source; the moment is BUILT (backward induction, "no moment, RAW, count or induction hypothesis remains" per the bindings file itself); the endpoint argument (β > θ ⇒ inherited window 51/100 ≤ β ≤ 7/8 licenses the moment ⇒ detector + conjugated weighted numerator on actual sources ⇒ counts with the affine count only inside the moment window ⇒ weighted comparison (12) at θ − 1e-7 ⇒ nonnegative tensor Bernstein certificates ⇒ κ-feedback ⇒ Levy + Collet improve the supremum, contradiction ⇒ β ≤ θ ⇒ inherited Hecke-to-Dirichlet transfer — the OAI paper section audited in full in B6 item 5) is internally consistent with **no load-bearing flaws found** at the audit level; the exact Bernstein coefficients are the kernel's job (paper asserts, Lean proves, replay re-verifies). **Step size:** the face shrank by qxD0max − gaoD0max = 8.365×10⁻⁶ (about one-fifteenth of the 0133 step — decaying returns as the ladders deepen, the 0141 forecast); cumulative face width from 3/8: 1.91300×10⁻⁴. **Updated terminal ledger:** [Z-PT2] record below the frontier + ONE open face hOffG on (tPT2, ∞) × (0, gaoD0max] with gaoD0max = 0.3748087 (record footing, [Z78G]-sharp; squeeze certificate still covers the face fully, face minimum unchanged at the d0 = 1/200 edge, margin ≥ 1.1136) + [Z78G] (closes all of d0 > gaoD0max in body; [Z78T], [Z78L], [Z78] remain corollary inputs, each a named theorem of the 0142 endpoint). Graceful degradation: a NO-GO on [Z78G] reverts to the 0133 terminal form (B14 preserved). **What does not move:** no RH claim — the face is still exactly where the external inputs are silent, now 0.3748087 from the critical line in off-line distance; the board is live again and the watcher anchor is 8748087/10^7 (gao-five-step-affine-20261020) — any strictly stronger merged record supersedes by the same demonstrated unit.

**Discovery 0143 (2026-10-21 — WHAT THE MAP FORGOT: the 0140 "complete" frontier map named 6 of 26 board records (and misordered Mori vs [Z78L]); full 26-record board map + genealogy + author race authored; off-board gaps recovered — Liu arXiv 2610.26835 (number-fields, quartic infimum B♭ = 0.874886647039964… = root of 133488B⁴−376596B³+384534B²−167541B+26231, the cycle25-quartic mechanism), Arun 3/4-level affine public claims (0.874812431 / 0.874810282, conditional on unproved H1–H5, both STILL WEAKER than [Z78G]), open PR #52 (liqsweep WIP 0.8748436 with documented sorries), Gao's method atlas (hourly, 7-dimension decomposition, pending view currently empty), OAI 11/12 program (Ope26b), Cureton–Thorner Dedekind 31/32): nothing beats [Z78G]; no in-tree change; the external queue is REFINED — daily watcher + open-PR scan + atlas pending view + public-claim band (0.8748087, 0.874817065) are the live channels. (2026-10-22 web re-sweep, 0151 unit: the public-claim band re-checked via Exa over the past month — Arun 3/4-level affine x-post 2026-10-21 (0.874810282/0.874812431, H1–H5 unproved in Lean), Sang/Xu B1 = 0.8748867 (Lean companion 404), Mori 0.874957020 (certificate only) all re-surface as the SAME already-ledgered items; board top unchanged at 0.8748087; nothing new in the band.)**

**Discovery 0144 (2026-10-21 — FIVE-STAGE FAMILY CEILING (0141 methodology on [Z78G]): the adopted record is NOT at its family ceiling; the endpoint comparison layer independently re-verified in EXACT rational arithmetic (12 rows × true region, all positive; binding row top/affine region, margin 1.475×10⁻⁷); theta′ descent: CLEAR to δ = 10⁻⁹, FAIL at δ = 2×10⁻⁸, class bound θ* = θ − δ*, δ* ∈ (1.5×10⁻⁸, 2×10⁻⁸) ≈ 1.69×10⁻⁸ (net θ-sensitivity of the binding row ≈ 8.74: the offset depth is structurally amplified); a same-family successor can legitimately claim down toward ≈ 0.874808683 (e.g. 87480869/10⁹ = 0.87480869 immediately certifiable above the 10⁻¹⁵ box-error budget); the decisive step toward the Final Solution remains a NEW STRUCTURAL CYCLE — the comparison systems are being squeezed to their exact infima — no in-tree change, no RH claim.**

**Discovery 0145 (2026-10-21 — B6-5-STYLE FULL READ of Liu arXiv 2610.26835 (v1, 11,410-line source, tmp/b6audit/liu26835/): main theorem Re s > B♭ = 0.874886647039964… (quartic 133488B⁴−376596B³+384534B²−167541B+26231) for EVERY number field K and finite-order Hecke character, via transfer to F = K(ζ12) + cyclic descent; the B♭ quartic INDEPENDENTLY RE-DERIVED from first principles (resultant of the paper's own cr/ℓ* formulas; κ = 2B−1 substitution gives exactly 2× the B-quartic; bracket signs verified); NO FLAWS FOUND at audit level; provenance stack fully pinned and cross-checked (Liu26a = arXiv 2610.12234 = in-tree [Z78L] citation PASS; Ope26b = 'Primitive roots for every admissible integer base', Oct 4 2026, theta source input with zero-free conclusion explicitly NOT used; XS26 v2; CT26 v2 + CTLean pin 09afbb4c; Newton26 Zenodo); B♭ is a scope result over all number fields, STRONGLY WEAKER than [Z78G] on the zeta face (0.87488664… > 0.8748087 — not adoptable in-tree); it is the definitive next-system design document and corroborates the 0141+0144 picture: every comparison family is being squeezed to its exact infimum — the forward path is a new structural cycle or a stronger analytic input; no in-tree change, no RH claim.**

**Discovery 0146 (2026-10-21 — PENDING SUPERSESSION DETECTED AND IDENTITY-VERIFIED: new OPEN PR #69 (Hailey Collet / HaileyStorm, DRAFT, 2026-10-21, frozen head ac76d5ef) claims QRH-Bound 8747729897/10^10 = 0.8747729897 (c = 0.1252270103) for ALL Dirichlet L-functions (zeta + stated Eisenstein Hecke consequences at the same boundary) — 3.57×10⁻⁵ BELOW adopted [Z78G], the largest single-step improvement on the 26-record board; NEW mechanism ('finite ordinary source moments': accepted PR67 two-level-affine input + 64 seed source faces + intermediate return + 221 derived source faces + final return; 3,549 files / 437,002 lines; builds_on = full board lineage); LOCAL VERIFICATION EXPLICITLY INCOMPLETE, protected verification against the canonical Comparator + three kernels requested; paper pre-publication (URL 404); watcher exit-11 fired exactly as designed; position = WATCH — nothing adopted until merged with verified provenance, then the demonstrated B6 section-8 conveyor runs end-to-end (identity at exact commit, replay, kernel statement match at 8747729897/10^10, axiom cone) and in-tree [Z78G] is superseded by a new module with the residual face shrinking to d0 ≤ 3747729897/10^10; if verification fails the item is voided on the record (0138/PR#52 precedent); this is the first announced NEW STRUCTURAL CYCLE after [Z78G], exactly the 0141+0144+0145 forecast; no in-tree change, no RH claim.**

**Discovery 0147 (2026-10-21 — PR#69 MECHANISM CRACKED + LEAPFROG QUESTION ANSWERED (exact rational arithmetic on the frozen head ac76d5ef): the 0.8747729897 claim is a TWO-STAGE "return" chain — PR67 (0.874817065) → intermediate C30 (theta1 = 8747759/10^7, seedK/6 license, gain 4.1165×10⁻⁵) → final (theta2 = 8747729897/10^10, finalK/6 = kappa1 with ZERO license waste, gain 2.9103×10⁻⁶); the step license is the incumbent inequality 6(2β−1) ≤ K, so the chain is exactly the refined-system fixed-point pattern Liu's family exhibits; THE ENGINE IS INPUT-UNIFORM (SeedStep/NFStep hold for every β in [0.51, 0.87481891]) — feeding [Z78G] instead of PR67 widens the license margin (3.69×10⁻⁶ → 2.042×10⁻⁵ in κ) but does NOT change the output: the "her engine, our better input" leapfrog is impossible by the structure itself; CEILING (all 33 named reserves differentiated at her constants, h/B/λ frozen): the claim is NOT at the family corner — a pure c-offset is admitted up to δc* = 2.116311×10⁻⁴ (binding named margin small_width_shortening 4.232×10⁻³, c-slope −16/dp; next: physical_width_lower 6.67×10⁻⁴, floor 1.365×10⁻³), giving the named-margin ceiling θ* = 0.8745613585650727 — so the next race cycle plausibly lands in [0.874561, 0.874773) as a deeper-c re-run of her generator; the 0144 precedent applies: a CLAIM beyond 0.8747729897 requires re-discharging her generated Bernstein/certificate layer at the offset, which belongs to the generator's owner, so no leapfrog of her claim is available to us from the visible structure — the forward path stays: verify (0148), adopt on merge, watch the band; no in-tree change, no RH claim.**

**Discovery 0148 (2026-10-21 — INDEPENDENT REPLAY OF PR#69 FROZEN HEAD: FULL GREEN (the pending supersession is now machine-verified OUTSIDE the tracker pipeline, at the same standard as 0132/0134/0142): stage C 6474/6474 modules compiled from source (3547 record + 2927 vendored OAI baseline; tracker-pinned mathlib d13f23b, Lean 4.34.1 by pinned binary — PATH lean is 4.35.0 and corrupts the v4.34.1 olean headers, recorded as a runbook lesson), 0 failures, 3472 s, snapshot-guarded on tarball sha 8607635a; stage D1 kernel-accepted the canonical statements at EXACTLY 8747729897/10^10 in BOTH claimed scopes (zeta: θ < Re s → riemannZeta s ≠ 0 — the SAME mathlib object as the in-tree Z78* modules; all-Dirichlet: pole-excluded); stage D2 axiom cone of all six endpoint declarations exactly [propext, Classical.choice, Quot.sound] — no new axioms, no sorry axioms; stage D3 zero sorry tokens across her 3547 modules; REMAINING ADOPTION GATES: (a) PR still DRAFT — "local verification incomplete" — merge identity must be re-checked at the MERGED commit (replay ~58 min if the head moved), (b) standalone paper still 404 (named provenance incomplete), (c) catalogue record; CONVEYOR PRE-STAGED: Z78Collet.lean (colletUpper = 8747729897/10^10, colletD0max = 3747729897/10^10, chain [Z78C] ⇒ [Z78G] ⇒ [Z78T] ⇒ [Z78L] ⇒ [Z78]) + Part B16 splice (rhend_sliceColletExcl, unifiedCollet endpoints, unifiedGao_ofColet bridges, terminal face hOffC: d0 ≤ 3747729897/10^10; face shrink 3.571×10⁻⁵ — largest in-tree shrink to date, 4.3× the 0142 step), staged at tmp/b6audit/collet69/prestage/; no in-tree change yet, no RH claim.**

## S17 VERDICT ADDENDUM (discovery 0152, 2026-10-22 — the ln-t
## defect law gains a t^2 term above ~3e16; the in-tree pinned
## two-term law is now known-incorrect on (1e17, T_MEAS])
- The pinned in-tree defect (E1Clause.lean: defect_A = -25256007,
  defect_B = +523513775, mdefect_bounded 6704.088) was fit on the
  21-row face (3e10, 3.0001e13]. S17's 11 new rows (3.16e13 ..
  3.16e18, dps-40 channel, tmp/s17_M_far2.jsonl) measure: the
  two-term residual is O(1e4) to 3.16e16, then -83538 (1e17),
  -1.058e6 (3.16e17), -1.083e7 (1e18), -1.0857e8 (3.16e18) —
  from 3.16e17 on it is -C*t^2 with C = 1.086035e-29 stable to
  3%. Three-term law M(t) = A ln t + B + C t^2: 23-row face
  (8.5 decades) max|resid| 7740.8 (face-native scale), 11 new
  rows 149.9; two-term on the same face 8.58e7.
- Consequence: the 0151 pre-staged E1ClauseV3 T_MEAS extension
  (same two-term constants) is VOID before launch; 0153 re-states
  the clause three-term (C the in-tree rational -1086035/10^39 or
  refit), T_MEAS = 10^18.5, mdefect_bounded re-pinned loose ~2e4.
  No in-tree statement currently covers (3.0001e13, 10^18.5] at
  all, so nothing in-tree is wrong as of this writing — the known
  gap is a missing extension, not a broken bound.
- Mechanism (hypothesis, 0153 nails it by per-component
  deconvolution from the stored row columns logzeta/lm/la/re/
  I_far): the t^2-scale deviation is in the I_far density channel
  (the only component with t^2-scale grid residual at t >> g);
  the eps = +0.7047 constant column is the EXACT-identity
  offset between the two exact closed forms of the log main term
  (logmain25212 is closed-form with exact mpmath loggamma - no
  Stirling truncation; logmain_ex the equivalent form): constant
  by construction, confirming no channel drift; M per row =
  eps + logzeta - lm - la - re - I_far holds to 0.0.

## T2-CLOSED-FORM ADDENDUM (discovery 0153, 2026-10-22 — the t^2
## coefficient above is NOT empirical: it is a closed-form constant
## of the RVM channel's U_TOP cutoff; mechanism resolved)
- C(U) = -(ln(U/2pi) + 1)/(2 pi U); at U = U_TOP = 1e30 (in-tree):
  C = -1.0860681706e-29. Free 3-parameter fit on the 33-row face
  (3.0001046e10 .. 9e18): C_free = -1.0860663478e-29 (rel. 1.7e-5).
- U-ladder (s19u: I_far rebuilt at U' = 1e25, 1e20 from stored rows):
  row-wise coefficient tracks the closed form to 6 digits (1e25) and
  4 digits (1e20); the 1e15/1e12 steps are contaminated by U' < t
  rows (expected). I_far convergence (s19t: 5 resolutions) — the t^2
  is structure, not a quadrature-residual; the 0152 "grid residual"
  hypothesis is retired, the endpoint-U kernel piece is the
  mechanism (ln(1 - t^2/g^2) ~ -t^2/g^2 integrated with density rho
  from t to U; antiderivative -(ln(g/2pi)+1)/(2pi g)).
- S17 COMPLETE: 12th row, the 9e18 wall: M(9e18) = -1.458437e9
  (23-row pre-wall law predicted -1.461e9; closed-form C matches the
  wall row to 0.004%; eps = +0.7047 constant to the wall - no
  channel drift).
- 33-row pins, C = closed form: A = -25254353.62, B = +523472285.05,
  max|resid| = 7996.9 @ 3e11 (s16 far-row band; 12 s17 rows within
  ~+/-400). 0154: in-tree three-term clause (C as a U_TOP
  expression, A/B pinned with margin, E <= 1e4). No in-tree change
  yet; no RH claim.

## S1MR REPAIR NOTE (discovery 0152, 2026-10-22 — the S1Marg
## exploratory dip below 1 above 3.1e7 is at least partly a
## density-tail model artifact; exact-tail re-measurement running)
- The 9 exploratory S1Marg rows (nominal g at 3.1e7 .. 1e9,
  margin 0.7763 -> 0.0654) were measured with the (3e7, 1e18] RVM
  DENSITY quad tail; the S1MR repair re-measures them (and 6 real
  file zeros toward 3e10) with the (3e7, 3e10] tail EXACT over
  the 1.014e11 certified H1 zeros. Until the A/B rows land, the
  "dip" is not a certified sub-1 observation — it is a model
  evaluation on an unmeasured region, same class as the repair
  list (0151). The 25 certified real-zero rows (margin >= 1, all
  at g <= 2.8e7) are unaffected (their t windows are fully inside
  the exact (1e7, 3e7] cache).
- Two f64 precision hazards found pre-launch (both fixed, both
  would have silently corrupted high-t rows): the naive per-pair
  factor g^2-t^2 (55 lost bits for |g-t| < 2e-6 at t ~ 3e10 ->
  factored log|g-t| + log(g+t) - log(g^2+1/4)) and
  mp.mpf(repr(float)) decimal rounding (up to ulp/2 shift in g/t
  at 3e10 -> mp.mpf(float) exact binary). Arbiter 5/5 gates
  green, including a dps-50 mpmath ground-truth check in the
  danger regime.
- Compute policy (owner, 2026-10-22): week-scale CPU jobs
  authorized on this machine with pre-launch alert, 4 logical
  cores + 16 GB free for the OS; S1MR runs <= 16 stream threads /
  12 row workers in serial phases, ~4-6 GB, resumable (jsonl rows
  + per-mode stream caches). Earlier assistant-side "40-70h too
  costly" heuristic superseded by this rule.

## 0155: data face extends to 9e20 (C-channel rows), frontier (9e20, inf)

The C/quad zeta channel already carries census rows at t = 3.0e19,
3.0e20, 9.0e20 (s34f/s34j, chains 3/4/5, past the mpmath wall
[9e18, 3e19)). All three sit on the three-term closed-form law
(0153/0154) with residuals -1.3e4 / -2.8e4 / -4.3e5
(all negative, <= 3.3 sigma of the f64 association-cancellation
noise budget at each height - the THIRD precision hazard, after
g^2-t^2 and repr-float: the M association itself cancels at
t >= 3e19). A ~1e4-scale sign-consistent systematic remains to be
attributed; chains 4/5 have NO independent zeta cross yet (S20a).
The in-tree V3C window (G, 9e18] stays conservative until the
crosses land. The composition itself is PURE: if_E1V3_and_walk
ignores _hE3 (the E clause is the documented data anchor, not a
consumed wire) - extending the law's domain IS extending the data
clause. The data-side open part is (9e20, inf). No RH claim.

## 0154: E1ClauseV3C named in-tree (0153 law as a data clause)

The three-term clause is now a NAMED DATA HOLE in
formal/RhAttack/E1Clause.lean: E1ClauseV3C q 10000 on
(G_LAST, 9e18]; M_defect3 = -25254354 ln t + 523472285 + C3 t^2
with C3 = -(ln(U_TOP/(2 pi)) + 1)/(2 pi U_TOP) named in closed form
at the in-tree truncation U_TOP = 1e30. It coexists with the
two-term E1ClauseV3 q 7000 on (G_LAST, 1000 G_LAST]; the terminal
endpoint face still consumes V3 (S1Uniform.201) -- the V3/V3C
rewire is a wire-budget decision pending the S18 verdict, not yet
made. C3's closed form is a model-level identity about I_far's
U-top truncation (verified in 0153), not a theorem about zeta.
No RH claim.
