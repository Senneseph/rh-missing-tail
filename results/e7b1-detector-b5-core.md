# E7b detector: the off-line pair kernel deviation — EXACT formula (2026-09-10)

**Status: EXACT (identity verified at dps-30 against the definition) +
MEASURED(6 digits) in the certified G = 3×10⁵ kernel context.**
This is a property of the 25.2.12 zero product, not a zero-count
certification; it is the *detector* half of the E7b bridge: how visibly
an off-line zero pair changes the zero-side kernel.

## Statement

Let s = ½ + it (t > 0, t ≠ γ), P_on(s) = ∏_{ρ∈{½+iγ, ½−iγ}}
(1−s/ρ)e^{s/ρ} (the on-line pair factor) and P_off(s,δ) the product over
the 4-tuple {½±δ±iγ}. With

ω_δ = (1+2δ)/((½+δ)²+γ²) + (1−2δ)/((½−δ)²+γ²) − 1/(¼+γ²) ∈ ℝ,

the exact ratio is

**R(s,δ) := P_off/P_on = (¼+γ²)((γ−t)²+δ²)((γ+t)²+δ²) ·
e^{(½+it)·ω_δ} / ( (γ²−t²)((½+δ)²+γ²)((½−δ)²+γ²) )**

Proof: 4 lines — P = [∏(ρ−s)/∏ρ]·e^{s·Σρ⁻¹}; grouping the four off-line
zeros as {½+δ±iγ} and {½−δ±iγ} makes each group's product
(i(±γ−t))² − δ² = −((γ∓t)²+δ²) (real, negative; the product strictly
positive for δ > 0 — **no zero of δ > 0 annihilates the deviation**);
the only branch is the on-line (γ²−t²) sign flip at t = γ; all Σρ⁻¹
sums are real.

## Consequences (exact from the formula)

- **Near (t ≈ γ):** |R−1| → 1 exactly (R → 0 for fixed δ > 0); the
  on-line pair contributes a −π phase jump across t = γ, the off-line
  4-tuple contributes **0.000** (measured −3.142 vs +0.000 rad) — the
  off-line pair is *argumentically invisible* on the central line.
  Consequence for the 2K/S walk: N_total +2, line-argument winding 0 ⇒
  2K steps +2 — **parity preserved, no flip; a ghost pair is a size step,
  never a parity event** (the same detector family that found the
  246-missed-flip dead GPU chunk by |S|-size).
- **Far (t ≫ γ):** |R| = (t/γ)²·(1 + O(δ²/γ² + 1/γ² + (γ/t)²)) — the
  deviation grows *quadratically* with the height ratio.
- **Uniform (measured):** over δ ∈ [0.005, 0.5] and 8 height configs
  (near, 2γ, far ×3), 56 measured points agree with the formula to
  5×10⁻⁴ (last printed digit); the forced relative kernel change
  |ΔK|/|K| = |R−1| ≥ 0.998 everywhere — no dead δ-window in the
  measured range (the δ-dependence is an explicit all-positive
  polynomial in the prefactor).

## Verification (three levels)

1. dps-15, G = 3×10⁵ certified list, full 25.2.12 kernel context:
   56 measured points (near: t = γ*±{1.0, 0.25, 10}, γ* = 999.791572;
   2γ*; far: t = 10/50/100·γ*) × δ grid —
   `scripts/rh/out_day010_d4d3.txt`, `out_day010_d4farscale.txt`
   (docker mpmath 1.3.0 verified env).
2. dps-30 direct 8-zero computation of P_off/P_on (definition): the
   formula agrees to ≤ 6×10⁻²⁶ (14/14 configs).
3. dps-30 formula vs the measured table: worst |Δ| = 5×10⁻⁴ — the last
   printed digit of the dps-15 measurements. `scripts/rh/out_day010_b5core_check.txt`
   (`scripts/rh/b5core_check.py`, host mpmath; no tail integrals — the
   ratio involves only the 8 moved zeros).

## PROVEN in Lean (2026-09-11)

The exact ratio above is now a theorem of Lean (**4.33.1 stable** +
Mathlib 4.33.1): `formal/rh-lean/RhAttack/B5.lean` proves `b5Ratio`
(the T1 closed form, as stated in this file), `b5Abs` (T2 magnitude),
`b5NoffPos`/`b5NoffIsPolynomial` (no δ > 0 zero-window), `b5PrefSign`
(the (γ²−t²) sign flip at t = γ is the only branch). The mirror's
`B5Float` layer re-derives R from the 6 factors in float64 and checks
the closed form against the direct definition and the dps-30
recorded values — **12/12 PASS** (worst closed-vs-direct
1.9×10⁻¹⁴ rel; worst vs-record 4.2×10⁻⁸ rel; recorded run
`formal/rh-lean/out_rhattack_day012.txt`).

## What this does NOT claim

- It is a statement about the 25.2.12 *product* — the bridge to ζ (25.2.12
  = ζ in the convergent sense) is Stage 1 of E7b, reproduced to 4 digits
  on the certified list; the rigorous remainder (density tail) is the
  open piece that must be paired with this detector for a contradiction
  argument.
- No height is walked in this result; no zero beyond the certified list
  is used. δ < 0.005 is unmeasured (the formula extends it; the even
  positive leading term excludes zeros for all δ > 0).
