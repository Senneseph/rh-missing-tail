# The [S1] data layer on the 3e10 band (driftTwoSided certificate)

Producer:  `scripts/rh/day036_epsilon_sweep.py` (single
streaming pass over the verified band of `results/3E10-BAND.md`,
bounded-memory,  selftest PASS before the run:  the
discriminating check  —  the end DN landing at the +0.125
generator-convention offset  —  measured 4.8e-7 off on 2M
synthetic zeros).  79.2 min wall.  All arithmetic f64 with a
certified per-gap error budget of 1e-4  (3 half-ulps of the
n_asym evaluation pair <= 2.2e-5;  margin x4.5).

**The certificate (the driftTwoSided data contract).**
Per consecutive zero pair (gaps = 92,577,877,713):
    eps_i = |n_asym(t_{i+1}) - n_asym(t_i) - 1|

    SUM_EPS      = 31,037,858,563.151787
    + margin     =        9,257,787.771300     (1e-4 x gaps)
    SUM_EPS_CERT = 31,047,116,350.923088   (rigorous)

together with  W2Beyond1.driftTwoSided  (LEAN-PROVEN,  the
R2 reduction:  |DN(j) - DN(0)| <= sum of the per-gap eps),
this is the UNIFORM WALK BOUND on the band:

    sup over k in the band of |DN(k) - DN(0)|
        <= 31,047,116,351.45           (pinned |DN(0)| = 0.525129)

i.e.  the measured 2.62 is under a proven ceiling of
3.1e10.  The margin term is 0.03% of the sum  —  the
certificate is data-tight to within the documented f64
budget.  The bound is a proven ceiling,  not a tight fit
(pre-registered framing);  its content is that every step of
it is machine- or data-certified.

**Gap statistics (the certificate's inputs).**
    Delta = n_asym increment range:  [0.000076294,  4.301822662]
    worst eps:                       3.301822662
    min raw gap (t units):           2.2888e-05
The lowest Delta is the 23-microsecond zero pair (Rho-scale
~7.6e-5);  the highest Delta is a ~4.3-RVM-unit super-gap.

**The walk pin (S3e convention,  chains with the 3e9 pin).**
    DN(0) at OLD_END (seam,  from the 3e9 walk)  = +0.525129318
    sup |DN| over the band (2.9992e9, 3.0001e10]      = 2.615067
    DN at band end (the NEXT band's pinned start)     = +0.904983521

With the previous pin  sup|DN| = 2.4772 on (1e7, 2.9992e9]
(day035 S3e),  the global measured sup|DN| on (1e7, 3.0e10]
is therefore  2.615067:  the telescope walk remains bounded
past 9.06e9 zeros up to 1.016e11 zeros  —  the no-divergence
read is now PINNED DATA at 3e10,  not density model.

**Cross-checks.**  N(3.0e10) = 101,635,962,231 (independent
binary search over the file;  last zero under =
2.9999999999762012e10;  vs RVM |diff| = 0.09)  —  identical
to the finish-gate pin.  Zero count CHAIN-EXACT with lastN.

**Outcome classification (pre-registered rule,  preprint
gate section).**  This is the [S1] DATA layer:  the R2 route's
per-gap sum is now explicit and certified on the extended
band.  It is A2-class content  —  domain-verified by rule,  not
asserted:  the A1 "final resolution" framing requires the
UNIVERSAL (analytic) epsilon,  which remains the open
research theorem (ceiling item 1),  now with its data side
fully in place.  No RH claim is made or implied at any
outcome short of that.
