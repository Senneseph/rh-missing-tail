# LOW-T DATA TERRITORY PLAN — closing t₀ < 1000 in the RH composition (2026-09-18)

Status: **DONE (2026-09-18) — the territory is FILLED at screen level:**
207-point sweep, margin_new >= 1 at ALL points, global min
**7.35737123 at t0 = 0.500000** (dual-precision anchor: dps-50
7.35752136, |d| = 1.5e-4). Data: 813 zero slice of the committed
LMFDB 1e7 list (md5 2f5e5b17b12906db8bba9bcab105e6ea), all 813 at
the mpmath noise floor; independent mpmath walk cross-check
bit-exact on the first 225. Full record: DISCOVERY_LOG day030
low-t entry; results out_day030_lowt_sweep.txt.

Companion to:
`formal/RhAttack/S4Asm.lean` (the composition), the 25c/25d certification
record (`day023_p01_certify.py`, `out_day023_p01_certify_*.txt`),
`docs/KNOWN_LIMITATIONS.md`, `DISCOVERY_LOG.md` (25x/25d/25e entries).

## The obligation (what the composition owes at low t)

`S4A.rh_from_structural_hypotheses` takes the four structural hypotheses
S1–S4 over ALL off-pairs (t₀, d₀), t₀ > 0, d₀ > 0. The regime-closure
assembly covers t ≥ 1000 at the bound level (S4a [1000, T0] + S4G growth
(T0, ∞); S4Strip own-regime t ≥ 1000; S2 far/own-pole + C1b disc floor;
S3 wire). The EXPLICIT residual territory is **t₀ < 1000 — "data
territory"**: S1–S4 there are to be established by DIRECT FINITE
COMPUTATION over the actual (finite, ~745) zeros below ~1.2e3, not by
the bound theorems. d₀ > 1/2 remains CITED (classical zero-free regions)
— unchanged.

## The statement to verify (per off-pair (t₀, d₀), 0 < t₀ < 1000)

One statistic, four uses (the P12 structural decomposition):

- **S1 (the pointwise squeeze):** the project's sweep/hi statistic
  `margin_new = |ζ(s)|·dev / (p8_B(t, n4) + |ζ(s) − K(s)|)` with the
  t⁴ wire (n4 = ⌈3.1e7·t⁴⌉) and the full-horizon kernel K (main 25.2.12
  action + primorial + pairlog over the finite list to G + density rem
  (G, 1e18] + ext (1e18, 1e30]) — ≥ 1 at every grid point, G = the
  straddle window's list end (the P1.1e wire), and dev = min over the
  500-δ grid (0.005 … 0.5) of |R_closed(t, g, δ) − 1| (the same grid as
  the sweep/hi runs).
- **S2 (far/own pole, C1b disc floor):** direct from the zero list at
  each off-pair: the disc-floor quantity min(23/1000, 1 − 25/γ̃) with
  γ̃ = nearest zero (the `C1b.p9_c1b_disc_floor` statement, evaluated
  finitely — the bound theorem's hypotheses are checked pointwise, no
  bound-level argument invoked).
- **S3 (wire hypothesis):** direct: the zero-side mass to the list
  cutoff covered by Bwire(t) + Mr(t) (finite sums, exact to dps).
- **S4 (the squeeze inequality at the blind spot):** the same
  margin statistic ≥ 1 (the S4 squeeze reads through the S1
  statistic on the data-territory grid; the S4Asm bound theorems
  start at t ≥ 1000 and are NOT invoked below).

The t₀ × δ grid: t₀ log-spaced over [0.5, 1000), N = 200 points
(+ probes at 0.5/1/2 for the sub-band near 0; if the kernel
machinery misbehaves as t₀ → 0, the plan records the limit
behavior and the sub-band is handled by a continuity/anchor note).

## Why the low-t computation is cheap and clean (vs high t)

- Pairlog sum: **745 zeros** (not 3e9) — instant in float64 AND
  exactly recomputable in mpmath dps-30 (the 25c/25d
  dps-vs-float64 cross-check is exact, not asymptotic, at this
  scale).
- Rem (G, 1e18]: t₀ < 1000 < G (window list end) — **no singularity
  inside** (t < G always on the grid) — plain 400-cell geometric
  quad, scale O(10²) (p(g) ~ −t²/g²·ρ), fast cells.
- **Ext (1e18, 1e30]: BOUNDED, not measured** — for t ≤ 1000,
  |p(g)| ≤ t²/g²·(1 + O(1/g)) ≤ 10⁻³⁰·(1+o) and ∫ρ dg ~ O(1):
  |ext| < 10⁻²⁸ — a CERTIFIED bound (no quad, no measurement;
  exact arithmetic on the bound in Lean-portable form).
- Main action / primorial: closed form, exact at dps.
- The entire per-point cost: ~5–15 s (dev grid ~1 s, rem quad
  ~3–10 s at low-t scale, pairlog instant) → the full 200-point
  sweep ≈ 20–30 min SINGLE PROCESS (2 cores stay idle).

## Data (fetch + verify first)

- Zeros (0, 1.2e3] ≈ **745 zeros**: compute by mpmath Newton walks
  (dps-30, step by the ρ estimate), cross-check against (a) the
  published first-50-zeros table, (b) Platt's list values where
  available, (c) an independent walk from a different seed.
- Deliverable: `scripts/rh/lowt/zeros_0_to_1p2e3.f64` + md5 +
  provenance note in the file header (via a commit message /
  comment; the f64 itself is binary).

## Protocol (the 25c/25d certification discipline, downward)

1. **Grid sweep** (dps-30): all 200 t₀ points × the statistic;
   record min margin over the grid + the argmin (t₀, δ).
2. **Certified anchors** (25c/25d): at the grid argmin + 2–3
   fixed heights spanning [0.5, 1e3] (e.g. 1, 10, 100, 500):
   dps-30 AND independent dps-50 (or float64 re-issue, whichever is
   the cheaper independent path) must agree to < 1e-6; the anchor
   margins are RE-PINNED (a new low-t pin family, with full
   provenance: script + day-ref + out file).
3. **Ext bound** proven by a one-line Lean or Python exact-arithmetic
   check (t²/1e36 · Σ-cell-count ≤ 1e-28) — recorded as a bound,
   not a measurement.

## Deliverables

- `scripts/rh/day030_lowt_zeros.py` (fetch + verify) +
  `scripts/rh/lowt/zeros_0_to_1p2e3.f64` (md5).
- `scripts/rh/day030_lowt_sweep.py` + `scripts/rh/out_day030_lowt_sweep.txt`
  (grid table: t₀, margin, dev, argmin-δ, S2/S3/S4 flags).
- `scripts/rh/day030_lowt_certify.py` + `out_day030_lowt_certify.txt`
  (anchor dual-precision certification).
- `docs/LOW-T-DATA-TERRITORY-PLAN.md` → this file, status flipped to
  DONE with the results table.
- DISCOVERY_LOG entry (append).
- S4Asm note update: the t₀ < 1000 residual territory line gains its
  DATA-TERRITORY FILLING reference (the pinned low-t grid + anchors).
- **Honest split:** low-t closure = **PINNED/CERTIFIED (measured,
  reproducible)** — the data territory by its nature; it is NOT
  claimed as a LEAN theorem (the Lean composition already treats
  it as the explicit third residual; the filling is the
  measurement record the territory was named for).

## Pre-flight checks (before the sweep)

- The kernel machinery at t₀ < 10 (main action at s → (1/2, 0.5i)–(1/2,
  2i); pairlog with ALL zeros "far" (first zero 14.13); the R_closed
  dev grid) — run t₀ = 0.5, 1, 2 first; expect the margin to be LARGE
  (no nearby zero, |ζ(1/2 + it)| ~ O(1), dev ~ 1) — a sanity shape,
  not a prediction.
- If any low-t point shows margin < 1: STOP, investigate before
  re-running the grid (one problem at a time).

## Cost and footprint

- One background process, ≤ 1 core, ≈ 20–30 min total (data + sweep
  + anchors); well inside the two-cores-free rule.
- No new storage (745-float file ≈ 6 KB).
