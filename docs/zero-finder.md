# The certified zero finder — n → ρₙ = ½ + iγₙ, computed

**The program that the owner asked for first, in honest form.** Input: an
integer n. Output: the n-th non-trivial zero ρₙ = ½ + iγₙ (γₙ > 0, ordered
by height), **computed by the walk-and-certify pipeline below — not looked
up** — with a dps tail and the measured certificate chain. The technique is
classical (Riemann–Siegel zero hunt); the contribution here is the
certification discipline and the dual-stack instrumentation, same honest
frame as the rest of this document.

## The pipeline (as shipped)

```
n  ──►  Riemann–von Mangoldt main-term inversion
          f(T) = T/2π (ln(T/2π) − 1) + 7/8,  Newton (f' = ln(T/2π)/2π)
       ──►  height bracket t₀ ± w,  w = max(0.75, 16 · spacing(t₀))
       ──►  certified walk from a dps-certified anchor (walkFrom, NStart):
             Z(t) sign flips on [walkFrom, t₀ + w],  dt = 2.5×10⁻⁴
             (below the measured twin floor: min gap 2.95×10⁻³ through 10⁶)
       ──►  the (n − NStart)-th flip brackets γₙ in a dt window
       ──►  bisection to float64   (the float engine brackets, ~10⁻⁸)
       ──►  dps tail (mpmath, the Zmp formula Re[e^{iθ}ζ(½+it)], θ per
             DLMF 25.10.2): the location certified at the measured dps
             floor, with S(γₙ) checked against the decade envelope and
             the S(1e6) dps anchor.
```

Anchors in use: **N(1e5) = 138,065** (dps-certified census; the file of
138,065 zero heights ships with the material) and **N(1e6) = 1,747,142**
(dps-certified, the hidden-twin-corrected value). For n ≤ 138,065 the
census file IS the certified output; the finder's job starts at n = 138,066.

## First certified output (Day-007)

n = 138,066 — the FIRST zero above the dps-certified anchor, found by the
walk (it is not in the census file):

```
γ₁₃₈,₀₆₆  = 100000.74372338832472451031208038330078125   (dps tail)
float walk = 100000.74372348833                          (agreement 10⁻⁷)
slope       = −15.58120492    (large: simple in the dps sense)
S(γ)        = −2.703628652    (within the measured decade envelope;
                               S(1e5) + d(main)/dt × 0.7437 to 1e-3)
```

**Honest precision statement.** The dps tail at t ≈ 10⁵ is bounded by the
*measured* mpmath evaluation floor at these heights (≈ 10⁻⁶ in |Z|,
≈ 10⁻⁷ in height), not by the dps setting; the float layer brackets to
10⁻⁸. Same shape as everything else in this document: the number ships
with the scale at which it is certified.

## What this does and does not claim

- **Does:** turn "give me zero number n" into a *computed, certified*
  quantity with a named tolerance, on a machine anyone can re-run;
  cross-checked against the independent 138,065-value census where the
  ranges overlap (reproduces it to the 2-term engine floor below t ≈ 10⁴,
  to 10⁻⁶ above).
- **Does not:** claim novelty of the zero-hunt technique (Riemann–Siegel,
  and its modern forms, are textbook); claim simplicity or multiplicity
  statements (the slope is a dps measurement, and a large slope is not a
  simplicity proof); and it does not touch the RH question directly — see
  the stage table: this is Stage-0/1 instrumentation (H0/H1), in service
  of Stage 2 (the counterexample search) and Stage 3 (the zero-side
  identification).

## Reproduction

- float64 engine + bracket + walk + tests: `scripts/rh-ts/` (TypeScript,
  `npm run check`, `npm test`; 39/39, the goldens include two census
  positions and the t < 40 guard).
- dps tail: `scripts/rh/day007_zero_at_dps.py` (docker mpmath; takes the
  float bracket as its argument).
- census file: `scripts/rh/zeros_T100000.txt` (138,065 values, the Day-3
  census, dps-verified at the endpoint).
