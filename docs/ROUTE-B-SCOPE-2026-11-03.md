# ROUTE (b) SCOPE — analytic zero-freeness of the terminal strip (2026-11-03, discovery 0270)

## The claim (exact)

**Claim (b).** ζ has no zero ρ with
- ‖ρ.im‖ ≥ tPT2 = 3,000,175,332,800, and
- ρ.re ∈ (1 − colletUpper, 1/2) with colletUpper = 8747729897/10¹⁰
  (i.e. 0.1252270103 < ρ.re < 1/2; by the functional equation this is
  equivalent to the right-strip (1/2, colletUpper] at the reflected height).

With [Z78C] (off-line zeros above the frontier sit in
[1 − colletUpper, colletUpper]) and the Platt on-line record below tPT2,
Claim (b) **is** the terminal face hOffCPT2, hence **is** RH.
No census kernel, no squeeze, no pin family — a direct exclusion of
ζ itself.

## Why nothing classical reaches it (gap probe, 2026-11-03)

At t = tPT2 (log t = 28.73):

| method | zero-free reach (right edge; left by functional equation) |
|---|---|
| de la Vallée Poussin scale (c = 1/57.54) | σ ≥ 0.999395, σ ≤ 0.000605 |
| Korobov–Vinogradov (c = 1/57.54 form) | σ ≥ 0.998763, σ ≤ 0.001237 |
| in-hand [Z78C] shell | σ < 0.125227 or σ > 0.874773 (all heights) |
| Platt on-line | t ≤ tPT2 (data ends here) |
| **target strip** | **0.125227 < σ < 1/2 at t ≥ tPT2** |

The classical boundaries add NOTHING inside the target strip at any
height: the K–V left edge at σ ≤ 0.001237 is 0.123990 below the target's
left edge at tPT2 (and the gap only widens slowly). Zero-density methods
cannot vanish in the left strip either (best at σ = 1/2: N(1/2,T) ≪ T^0.543,
a positive exponent). Claim (b) is therefore beyond the known boundary /
density toolkit — it needs an RH-class argument, not a sharpened boundary.

## Tool review (what can / cannot attack the strip)

1. **Levinson's method** — RULLED OUT as a direct tool. Levinson extends
   a zero-free region from the right side (from σ ≥ 1 − c/log t toward
   smaller σ) and needs a starting zero-free region that touches the
   target from the right; the left strip (σ < 1/2) is not reachable from
   any known zero-free region.
2. **Argument principle on R = [0.125227, 1/2] × [T, T+h]** — the zero
   count in R is (1/2π)Δarg ζ on ∂R, provided no zeros lie on ∂R.
   Riemann–von Mangoldt gives the TOTAL count in (0, 1) × [T, T+h], not
   the count in R — subtracting the on-line count is circular (the
   difference is exactly the unknown). The missing object is a **|ζ|
   lower bound / argument control on the left edge σ = 0.125227** (where
   convexity gives only an upper bound). A rectangle argument with the
   top/bottom edges on known zero-free horizontal lines and the left edge
   argument-controlled is the cleanest classical-shaped attempt; the left
   edge is the hard part.
3. **Explicit formula at explicit heights** (project-native) — count zeros
   in the strip from the explicit formula with the KNOWN zeros below tPT2
   as explicit input (Platt record: all on-line, bit-pinned 0263). The
   residual sums over t > tPT2 must be bounded — this is where the
   project's own spectral machinery (W-kernels, A4.3 mass, S4 strip
   floors) may contribute as ANALYTIC bounds rather than census data.
   **This is the first attack line.**
4. **Density + repulsion** — RULLED OUT unconditionally (no exponent in
   the left strip goes negative; even the σ = 1/2 exponent is positive).

## First concrete unit (next formal/numeric fire)

Prove or falsify, at explicit heights, the **left-edge control sub-claim**:
for σ = a = 0.1252270103 (the collet lower edge) and t ≥ tPT2, bound
|ζ(a + it)| BELOW (not above) by a computable function — e.g. via
Jensen / Turán power-sum machinery on the circle around a + it, or via
the explicit formula truncated at tPT2 (known zeros) plus a bounded
tail. If a lower bound |ζ(a+it)| ≥ f(t) > 0 holds for all t ≥ tPT2, the
left edge of R is zero-free and the rectangle argument can proceed.

Status: OPEN (research). Probe to be written: day066 left-edge |ζ|
survey at a = colletLower over t ∈ [tPT2, tPT2 + 10⁵·√tPT2-scale windows],
interval arithmetic, against the explicit-formula tail.
