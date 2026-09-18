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
> throughout. No prize claim is made or implied.

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

### H2 — The (10¹⁸, ∞) kernel section is numerically bounded, not analytically
**Status (2026-09-17, day029 rescheck):** the (400, 400) sweep configuration is RESOLUTION-STABLE — Efull(1e9/4e8/6e8) stable to < 5×10⁻⁵ across the full npts 200→2000 × npts2 400→2000 ladder (both sections, dps-30, differential from the sweep anchors; `day029_efull_rescheck.py`, `out_day029_efull_rescheck.txt`). The quad-resolution part of H2 is therefore closed at screen level for the verified range; the (10³⁰, ∞) tail remains bounded by the "1 − O(t²/10³⁰) < 10⁻⁹" heuristic, and a PROVABLE comparison bound on it (the t²/g²·log-density decay; the classical S̄(t) technique) is the remaining analytic unit, Lean-portable.
**Note (2026-09-18):** the rescheck's "resolution-stable" is stability **within the complex path** over npts; the complex path itself is known wrong against the validated real path (H5) — the closure claim above applies to the recorded (complex-path) numbers; the corrected tail quad is in flight (docs/QUAD-FIX-PLAN.md).
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

### H5 — The kernel tail quads (G,10¹⁸] and (10¹⁸,10³⁰] ran on mpmath's complex path, which is known wrong here
**Status (2026-09-18, day029/030 discovery):** at the 1e9 anchor the complex-integrand tail quad (G1, 1018] — the construction of **every** recorded run, onset through day029 — is **+2.5267e9 (in log)** off from the real-path integral of Re(integrand), which triple-agrees to 13 digits (401-list / single interval / per-cell sum at −4236379269.6977525 vs complex −1709644719.5582716). Identical on mpmath 1.3.0 **and** 1.4.1: documented library clause ("quad() may fail to provide full accuracy" for functions with many bumps), not a version regression. The true tail sum (γ > G) IS the correctly-converged density integral (Σ−∫ fluctuation O(1e-5); N ~ 6×10¹⁴; smooth integrand on g > t) — this is a MEASUREMENT-layer defect, not a mathematics defect. **Consequences (quantified):** (i) every recorded Efull/residf/margin since onset is a complex-path value; (ii) margin ≥ 1 holds in **both** constructions at all 36 windows/straddles — the corrected margin relaxes to dev = min_δ|R(s,δ)−1| (measured 1.0000000028 / 1.0000000025 / 0.9999999973 / 1.0000000006 / 1.0000000062 at 1.2/1.4/1.6/1.8/1.95e9) — the realized scale is inside the pinned near-floor band [0.9975, 1.0201] (H3) with one sub-1 dip (−2.7e-9 at the 1.6e9 straddle); (iii) the S1 asymptotic question is re-expressed as the dev-floor question (does realized min_δ|R−1| stay ≥ 1 / in-band above 1e9?), replacing the Efull saturation-vs-divergence framing. **Open:** cell-level mechanism (QUAD-FIX step 1 in flight) + corrected anchor/straddle table (step 3); until then the complex-path numbers stand as recorded, tagged.

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
5. **The Platt–Trudgian 3×10¹² on-line certificate** — the data
   backbone of everything "verified ≤ 10⁹" (seam/Nt continuity
   re-checked exactly by us: Nt = 73426758, gap = one zero spacing).

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
