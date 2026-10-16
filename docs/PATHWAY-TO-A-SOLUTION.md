# PATHWAY TO A SOLUTION -- the current single source of truth

This document is the re-chart of the program:  where we stand,  what a
solution requires,  what has been measured as a hard constraint,  and the
branches that remain.  If any other document in this repo conflicts with
this one about the STATE of the program,  this document governs;
DISCOVERY_LOG.md governs the history (it alone carries dates);
formal/LEAN-GUIDE.md governs the Lean tree and gates.

No RH claim is made or implied anywhere in this chart.

## 1.  Position  (verified  /  measured  /  open)

Lean side  (build green,  sorry-free gated modules,  pinned toolchain):

  Closure        the 8-closure:  margin -> RH,  the 1987/1995
                 argument-reduction theorem,  proven.
  P1.2           closure = S1 zero side + S2 detector floor
                 + S3 definition side + S4 squeeze.  Named,
                 pointwise atoms,  covered region proven.
  Z78 input      external quasi-RH strip (Re s > 7/8 zero-free,
                 openai/math family 003,  kernel-verified on two
                 kernels,  human review in progress) entered as a
                 NAMED external input (prop with provenance,  not a
                 dependency).  Proven from it:  zetaZeroStrip
                 (1/8 <= Re <= 7/8),  offPairD0le (d0 <= 3/8,
                 sharp),  offPairFarEmpty (far region d0 > 1/2
                 VACUOUS for actual-set zero sets),
                 edgeZeroFree78 (edge lines Re = 0 / 1 excluded).
  S2             COMPLETE for the actual set:  low band
                 (s2ActualLowBandComplete;  sliver vacuous under
                 the on-line record)  and full band,  no t0 cap
                 (s2ActualFullBand,  via floor unification).
  FloorUnif      the S2 own-detector and the S4 own-mass are ONE
                 function (poffIsOwnKerC,  poffOwnMass);  on the
                 covered band (1000 <= t,  0 < d <= 1/2)  the
                 concrete floor floStripMin = mown;  the proven t^4
                 covered squeeze reads against the unified floor
                 (s4StripUnifiedFloor).
  S1Sample       sample-to-uniform bridge in force (for smooth
                 faces;  scoped out above G where the wp face
                 carries log cusps at true super-G zeros);  row
                 faces + L-faces gated both flanks
                 (L1 = 13.5856 below G,  L2 = 78.9887 above G);
                 covers measured (Dv1 = 5.809927e9 below G,
                 Dv = 900*G above G);  t-metric bridge formal but
                 VACUOUS at measured L;  cusp robustness is the
                 operative between-row control (log cusp at a row
                 <= ln(1/d) + face,  ~14 even at d = 1e-6,  far
                 inside the row faces).
  E1Clause v3    the above-G clause,  DATA-SUPPORTED (not proven):
                 M_defect(t) = -25256007 ln t + 523513775 on
                 (G, 1000*G],  B = 7000 data-supported;  composed
                 with the walk into RH (if_E1V3_and_walk).
  S4             covered region (t >= 1000,  1/200 <= d <= 1/2)
                 PROVEN via the t^4 squeeze;  named bound-level
                 residues outside the covered region
                 (S4Gap / S4Sharp family).
  Data pins      505-point reissue below G (margin mnew < 1),
                 certified zero set to G,  low sliver all on the
                 critical line,  eps and channel pins stable.

Data side  (measured,  on disk,  gate-checked where gated):

  Defect law     M = A ln t + B on (1G,  ~1e6G]:  28 rows,
                 max residual 7719,  integer-quantized M.
  Far census     s25 rows 2e6G .. 5e7G (t to 1.5e18):  the smooth
                 law now BENDS.  Drift of measured M away from the
                 pre-census ln-t law turns on around 1e6G-2e6G and
                 runs t^2-like over the far rows (per-doubling
                 ratios 4.1,  4.0,  6.3 -- approaching the t^2
                 value 4);  single-power fit p = 2.23 +- 0.03,
                 K = 2.0e-10  (fit rms 0.27 in log:  the turn-on,
                 not a pure power over the whole range).  This is
                 the first NON-LOG input to the far-structure
                 question.  The t^2/G far-bias kernel family (the
                 s12/s20 candidate list) is the leading match.
  Channel audit  the f64 u-trap cross-check degraded smoothly with
                 t (diff ~1e8 at 1e11 up to ~5e13 at 1.5e18):
                 adjudicated a 2M-point f64-grid discretization
                 limit,  NOT a signal.  The dps-40 split
                 quadrature channel is authoritative;  all 5 census
                 rows pass the exact f64 sum-accounting check
                 (recorded M = fl(sum of recorded channels));
                 dps-80 I_far recheck at 2e7G / 5e7G is the
                 outstanding verification (in progress at the
                 moment of this writing).
  Derivative face L-faces + floors both flanks;  cusps at true
                 (mostly uncertified) super-G zeros above G,
                 partial cancellation in M' below G;  smooth
                 remainder face O(1) at zero-free targets.

## 2.  What a solution requires  (the branches)

The composition is fixed and machine-checked:  RH follows from a
zero-set closure,  and the closure decomposes into the four legs S1..S4.
A solution is a route that supplies ALL four legs (plus the data clause)
for the ACTUAL zeta zero set.  The branches:

  B1  zero-side witness  (S1 uniformity)
      OPEN -- research scale.  The collective part of the problem:
      every zero enters every zeta value,  and the uniform
      off-line-pair witness is exactly where local attacks die
      (as every known local attack does).  Pointwise structure is
      proven;  uniformity is currently measured from the sampled
      row faces,  L-faces,  and covers,  with the P12 squeeze as
      the formal between-row control.  This is THE open item.
  B2  detector floor  (S2)
      CLOSED:  s2ActualLowBandComplete + s2ActualFullBand,  one
      unified floor floStripMin = mown on the covered band.
  B3  definition side  (S3)
      PROVEN pointwise under the wired mass inputs
      (bound-level wires,  named).
  B4  squeeze  (S4)
      PARTIALLY OPEN:  covered region proven (t^4);  the
      bound-level residues outside the covered region are named
      (S4Gap family).  Closing the residues to the universal
      squeeze is a formal gap with a named shape.
  B5  data clause above G  (E1 v3)
      DATA-SUPPORTED,  not proven.  Domain (G, 1000*G].  The far
      drift (B7) starts ABOVE the clause domain (~2e6G),  so the
      clause support is unchanged so far;  monitoring.
  B6  external quasi-RH input  (Z78)
      KERNEL-VERIFIED externally (two kernels),  human review in
      progress.  Provenance is recorded (openai/math family 003).
      If the review finds a flaw,  the far-region vacuity and the
      edge-line exclusion reopen -- both are single-line reverts to
      cited-classical status in this chart.
  B7  far-side structure  (the census drift)
      NEW.  The drift is the first non-smooth-log input;
      deconvolution (s27 next) forward-simulates parametric
      far-count biases against the engine kernel to locate where
      in (G, 1e30] the count structure sits.  Feeds B1 (the walk)
      and B5 (law territory).

## 3.  Measured constraints  (anything that proves RH must
    reproduce these)

  - Defect law  (1G, 1e6G]:  ln t with A = -2.525484e7,
    B = +5.234850e8  (28-row),  integer-quantized M,  max
    residual 7719.
  - v3 near-domain constants:  A = -25256007,  B = 523513775,
    max residual 6704 on the 21 near straddle rows
    (6063 when the s26 near-band recheck is applied).
  - Far drift:  turns on around 1e6G-2e6G,  t^2-like per-doubling
    ratios (4.1 / 4.0 / 6.3) over 1e7G-5e7G;  D ~ K x^p global fit
    p = 2.23,  K = 2.0e-10.
  - Integer quantization of M (f64-exact) at ALL 33 rows to date.
  - Sum-accounting:  M = fl(sum of channels) exactly on the census
    rows.
  - Row faces / L-faces / covers as gated in S1Sample.
  - Cusp structure at true zeros both flanks;  smooth remainder
    face O(1) at zero-free targets.
  - Zero-free edges (Re = 0,  Re = 1) and the 7/8 strip under the
    named external input.

## 4.  What would change our minds

  - The dps-80 I_far recheck fails on any census row  ->  the
    drift is an engine artifact;  the t^2 family is killed and the
    far structure is re-derived from clean rows.
  - Deconvolution attributes the drift to a localized mechanism
    (a specific kernel/g behavior) rather than count structure in
    (G, 1e30]  ->  B7 re-formulated.
  - A between-row violation beyond cusp robustness appears in any
    band  ->  B1 data-refuted there;  the row-face clause
    re-scoped.
  - The external human review breaks the 7/8 strip  ->  B6
    reopens;  far region stops being vacuous;  edge lines revert to
    cited classical.
  - A defect face inside (G, 1000G] leaves the v3 support  ->
    E1 v4 re-gate.

## 5.  Next moves,  in order

  1.  Land the dps-80 census verification (in progress)  ->  lock
      the five far rows as data.
  2.  s27:  deconvolve the drift  ->  locate the far-count
      structure in (G, 1e30]  (parametric bias forward-simulated
      through the engine's own kernel;  the s19/s19b smooth-data
      limit is exactly what this input removes).
  3.  Formal:  the S1 uniform statement + walk composition against
      the current faces (P12 squeeze remains the formal
      between-row control);  track the external review of B6.
  4.  Docs:  this document is updated by EVERY milestone commit;
      no silent re-chart.

## 6.  Document governance  (flow of truth)

Single source of truth for STATE:  this document.
Single source of truth for HISTORY:  docs/discovery/  (one JSON per
entry,  generated interactive view  docs/discovery/DISCOVERY.html;
the  root  DISCOVERY_LOG.md  is  FROZEN  as  the  archival  record
through  the  FloorUnif  milestone  --  new  history  is  written  as
fresh  JSON  entries  only;  the  dated-record  rule  is  carried per
entry  file).
Single source of truth for the Lean tree:  formal/LEAN-GUIDE.md.

Historical documents (their reasoning remains valid;  their STATE
descriptions were superseded at their time and are NOT the current
chart):

  docs/SOLUTION-SHAPE.md        one-clause E1/CL era
  A_SPECTRAL_SOLUTION.md,  docs/
  SPECTRAL-*.md                 spectral reframe era
  docs/END_GAME_PLAN.md,  docs/
  H1-*.md                       fleet era (dropped)
  plan documents                per-day work plans

Rule:  milestone commit  ->  update this document (if state moved)  +
write the discovery entry  ->  push.  A document that disagrees with
this one about state is stale by definition and gets a supersession
pointer at its top.
