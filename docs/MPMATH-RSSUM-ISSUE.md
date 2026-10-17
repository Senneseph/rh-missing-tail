# Draft mpmath issue: Riemann-Siegel zeta at Re=1/2 disagrees with
# independent quadrature channels at high working precision

Status: DRAFT for upstream.  Local reproduction and cross-channel
evidence on record in this repo (tmp/s34e_*, scripts/rh/zetac).
No RH claim anywhere; this is a pure numerical-accuracy report.

## Short version

`mpmath.zeta(0.5 + 1j*t)` for large t, evaluated through the
Riemann-Siegel path (`rszeta`, `sigma = 1/2`, `der = 0`), returns
values at dps >= 20 that disagree with dps 15 and with two
independent fixed-precision (quad-double) assemblies by up to ~5
in `log|zeta|`.  The disagreement is NOT a precision-limiting
effect: raising dps from 20 to 40 leaves the value digit-identical,
while dps 15 alone is the outlier-looking branch.  The error is
localized to the ADR rssum correction (the Arias-de-Reyna
F/coefficient chain), not to the primary S1 sum.

## Reproduction sketch

At a single height (the f64 integer 15000522999990988800, ~1.5e19),
one fresh process per dps:

  dps    log|zeta(1/2 + i t)|     |zeta|
  15     +2.9370199551            18.859560149492072
  20     +1.7289704098            5.63538...
  30     +1.7289704098            5.63538...
  40     +1.7289704098            5.63538...

So dps 20/30/40 agree with each other to 10 digits and dps 15 is
the lone value.  That pattern (a stable "wrong" value at high dps,
a different value at low dps) is the signature of a working-width
threshold inside the algorithm, not of rounding.

### Decomposition (the localizing evidence)

mpmath's RS path returns `z = 2 e^{i theta} (S1 + rssum*S3)`.
Wrapping the two components:

  component        dps-15              dps-40
  S1 (zetasum_sieved)  exact (fixed-pt,
                       wpsum auto)     exact, matches dps-15 and
                       and the C       an independent C/quad S1 to
                       channel to ~2e-14 ~2e-14  ->  S1 is fine
  rssum*S3          (9.1e-06, 7.5e-06), |z| = 1.18e-05  (CLEAN)
                                 (garbage), |z| = 13.86 (WRONG)

The S1 primary sum is correct at BOTH precisions (it is a
fixed-width fixed-point sieve with its own auto width, `wpsum`,
which is independent of the outer dps).  The rssum*S3 correction,
built from the ADR F/coefficient table at a working width that
grows with dps, is the component that is correct at dps 15 and
wrong at dps >= 20.  Its magnitude at dps 40 (13.86) dwarfs the
whole correction's natural scale (~1e-5), which is why the final
`|zeta|` lands ~13.2 away from the truth and `log|zeta|` shifts by
~1.2..5.

### Cross-checks independent of mpmath

Two fixed-precision C assemblies, `__float128` + quad-double
(hi/lo), link the system `libquadmath` (no headers needed beyond the
runtime .so):

  1.  The full RS form (S1 + rssum*S3 + S3, the same formula mpmath
      uses, with its own ADR coefficient table emitted at high
      precision as machine-reconstructible integer triples).
  2.  A BARE-cosine form:  Z(t) ~ 2 sum_{n<=N} cos(theta - t ln n)
      / sqrt(n)  +  O(t^-1/4).  This shares NOTHING with the F/
      coefficient/rssum path (no tables, no Horner, no S3, no
      rssum) - only the QD trig and the constant 2*pi.

  height    full RS form     bare cosine     mpmath dps-15
  1e8G      4.2863568042     4.2863862899    (not run)
  3e8G      26.7033746986    26.703361444
  5e8G      18.8595601495    18.8595810231   18.859560149492072
  1e9G      0.2978699056     0.2978611079

The full RS C form and the bare-cosine C form agree to ~1e-5 (the
rssum*S3 + O(t^-1/4) scale), and mpmath at dps 15 agrees with the C
full RS form to ~1e-14 (same S1, same rssum magnitude).  mpmath at
dps >= 20 does not.  The independent bare-cosine assembly - which
cannot inherit an rssum/F-table bug - corroborates the dps-15 and C
values against the dps-20+ mpmath values.

## Where to look (hypothesis, not a fix)

`mpmath/functions/rszeta.py`, the rssum construction: the ADR
F(m) coefficients, the `D[n,k]` table, and the working precision
allocated to their Horner/sum evaluation.  The F table is computed
at a precision that is a function of the outer dps; the evidence is
consistent with a too-small working width (or a too-coarse
fixed-point cutoff) in that chain at dps >= 20 for these large N
(N ~ 1.5e9 terms), while the S1 sum has its own internal `wpsum`
auto-width and is unaffected.  The S1 side is exonerated directly
(zetasum_sieved output is identical and correct at both precisions).

## Suggested tests to add

  - A dps sweep {10,15,20,30,40} of `mp.zeta(mpc(0.5, t))` at a
    fixed large t (e.g. the integer 15000522999990988800),
    asserting convergence of log|zeta| (successive dps differences
    shrinking), at a height where N = floor(sqrt(t/2pi)) is O(1e9).
  - A component test wrapping Rszeta_set / the rssum builder to
    expose rssum*S3 in isolation, asserting |rssum*S3| stays at its
    natural scale (O(a^-1/2) times O(1)) rather than O(10).
  - A cross-check of the RS form against the bare-cosine form
    2 sum cos(theta - t ln n)/sqrt(n) to the O(t^-1/4) + rssum
    scale, which is an independent route to the same value.

## Provenance and caveats

  - mpmath 1.4.1, CPython 3.12.3, x86-64.
  - All mpmath values are fresh processes (one process per dps) to
    avoid state carryover; the C channel is a separate binary.
  - The C coefficient table for the full RS form is generated from
    high-precision source and emitted as exact integer triples; the
    bare cosine form needs no such table.
  - Nothing here is a claim about the Riemann hypothesis; it is a
    report that the zeta values a downstream census consumes shift
    by O(1) in log|zeta| when the working precision crosses a
    threshold, and that the shift is localized to the rssum term.
