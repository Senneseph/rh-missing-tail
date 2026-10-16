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
                 dps-80 verification PASSED:  I_far dps-40 == dps-80
                 bit-identical at 2e7G and 5e7G,  log|zeta| dps-40
                 == dps-60 bit-identical,  plus a fresh-process 3-
                 precision cross (dps 40/60/80  bit-identical,  the
                 integral is cheap:  0.2 s).  The five far rows are
                 LOCKED as data.
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
      the formal between-row control.  The full formal chain is
      now  GATED:  S1Sample  (t-Lipschitz  bridge,  below  G)
      +  S1Cusp  (cusp-aware  bridge,  above  G)  +  S1Uni-
      form  (the  S1  UNIFORM  statement  on  the  full  program
      domain  --  two-sided  below  G,  dead-zone  plunge,  one-
      sided  E1-threat  above  G  --  and  its  composition
      s1UniformAndWalk  into  RH  on  the  four  walk  legs).
      The  named  open  items  are  the  data  faces  (row
      faces,  L  faces,  covers,  dead  zone,  cusp  spacing
      +  amplitude)  and  the  E1ClauseV3  clause  itself.
      The  whole  program's  residual  now  has  EXACTLY  ONE
      STATEMENT:  RHEnd.rh_program78  (THE  ENDPOINT,  actual
      set  +  [Z78],  at  the  CONCRETE  wire):  S2  covered,
      S4  strip  band,  S4  low  band,  and  the  far  region
      are  PROVEN  IN  THE  BODY;  the  residual  is  named
      once  as  hs1  (the  S1  witness),  hs3  (the  S3  wire),
      hWin  (the  S4  window-pin  SHAPE:  closure  pinned  at
      0.9975  vs  the  unified  S2  floor  <=  own  mass  <=
      6e-4,  gate  ratio  1662.5),  and  hS2low  (the  S2  low-
      band  pin;  the  sliver  part  is  vacuous  under  the
      named  on-line  record).  This  is  THE  open  item.
      WALK  SPINE  CONTRACT  (2026-10-16):  the  Q  of  the  S1
      and  S3  legs  is  ONE  CONCRETE  SCALE  Qside  (the
      measured  |zeta|  fill  under  the  A4.3  wire):  S1 =
      Qside  \>=  devOf  -  Mf,  S3  =  Qside  \<=  Bwire  +  Mr.
      The  old  exists-Q  /  for-all-Q  form  decoupled  the
      legs  and  made  S3  unsatisfiable  for  any  finite  wire
      (a  dead  form  -  the  spine  was  a  stack  of  tautolo-
      gies);  the  whole  spine  is  now  retyped  (P12Uniform,
      ZetaZeroSet,  E1Clause,  S4Asm,  Z78P12,  S1Uniform,
      S1LowT,  RHEnd)  -  discovery  0088.
      LIVENESS  AUDIT  (discovery  0089):  the  retyped  spine
      is  a  GENUINE  squeeze-contradiction,  not  a  dead  form:
      the  6-wire  tuple  (zero  side,  dev,  floor,  error,
      def  side,  residue)  is  jointly  contradictory  ONLY  AT
      A  PAIR  WHERE  AN  OFF-PAIR  EXISTS  (assume  one;  the
      wire  hypothesis  materializes  the  tuple  at  its
      minimum-height  pair;  p9_point_contradiction  forces
      False)  -  the  contradiction  across  four  SEPARATELY
      CHECKABLE  legs  is  the  engine's  work.  This  differs
      from  the  0088  dead  form,  where  the  contradiction
      sat  INSIDE  ONE  LEG  (S3,  unsatisfiable  for  any
      finite  wire,  no  data  content).  The  algebraic  core
      is  cross-checked  independently,  Mathlib-only:
      ProbeMargin6.margin6_unsat  (green).
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
      ACTIVE  AT  THE  LEVERAGED  WALL.  Verified  data  (dps-80):
      the  drift  is  small  positive  at  3e5G-1e6G  (the  (t/g0)^2
      kernel-tail  bump,  first  data  below  the  2e3G  census
      onset),  crosses  zero  at  t/G  in  (7e5,  1e6),  then  grows
      NEGATIVE  t^2-like  (per-doubling  ~4.0  by  1e7G).  s29
      deconvolution  (33  rows):  positive  far-side  count  excess,
      g-side  window  [2e8G,  1e11G],  lognormal  sigma  ~1,  best
      single  configuration  ~1e9G,  amplitude  O(1e8..1e11);
      position-amplitude  degeneracy  over  ~3-4  decades  because
      every  measured  row  is  in  t  <<  g0.  Cross-run  lock:  the
      s28  re-run  of  5e6G  matches  s25  EXACTLY  (-475565520).
      s30  LOCKED  two  new  far  rows  (I_far  dps40/60/80
      identical  +  f64  sum  match):  1e8G  (M = -648727552)  and
      3e8G  (M = -1458497536)  --  the  verified  extreme  boundary
      now  stands  at  9e18  (was  1.5e18).  FRESH-PROCESS  WALL
      PROBE  VERDICT:  the  dps-40  zeta  channel  SUCCEEDS  at
      t  =  9e18  (logzeta  =  -1.57280218,  63  min,  73.7  GB
      peak  -  an  independent  re-derivation  of  the  3e8G
      census  row's  zeta  channel)  but  is  OOM-KILLED  FRESH
      at  t  =  3e19  (114.6  GB  anon-rss  against  124  GB
      system  RAM)  -  the  wall  is  FUNDAMENTAL  for  the
      dps-40  channel  on  this  machine,  at  [9e18,  3e19).
      s31z  LADDER  VERDICT  (dps  15/20/30/40  at  3e19/9e19/
      3e20,  fresh  processes:  ALL  OOM-killed  in  the  first
      dps-15  call,  dmesg  confirmed):  the  per-term  cost  of
      the  N  =  sqrt(t/2pi)  precompute  is  NEARLY
      PRECISION-INDEPENDENT  (~  53-62  B  over  dps
      15..40)  -  low  precision  does  NOT  move  the  wall;
      it  is  LOCKED  at  [9e18,  3e19)  for  all  mpmath
      precisions  on  this  124 GB  machine.  s31z2  is  in
      flight:  the  5e8G  row  (t  =  1.5e19,  N  =  1.545e9,
      model  83-95  GB  -  the  LAST  reachable  height,  one
      fresh  process  per  dps  in  the  ladder).
      Breaking  the  g-side  degeneracy  needs  rows  at
      t  ~  g0  (~3e20),  ~33x  past  the  verified  9e18  --  an
      engine  task,  not  a  data  task.  Feeds  B1  (the  walk)
      and  B5  (law  territory);

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
  - Integer quantization of M (f64-exact) at ALL 35 rows to date
    (28  law-band  rows  +  the  5  s25  far  rows  +  the  2  s30
    extreme  rows).
  - s30  extreme  rows:  M(3.0001e18)  =  -648727552  (1e8G)  and
    M(9.0003e18)  =  -1458497536  (3e8G);  I_far  dps40  =  dps60
    =  dps80  on  both;  f64  sum  match  exact  on  both.
  - Sum-accounting:  M = fl(sum of channels) exactly on the census
    rows.
  - Row faces / L-faces / covers as gated in S1Sample.
  - Cusp structure at true zeros both flanks;  smooth remainder
    face O(1) at zero-free targets.
  - Zero-free edges (Re = 0,  Re = 1) and the 7/8 strip under the
    named external input.

## 4.  What would change our minds

  - Deconvolution attributes the drift to a localized mechanism
    (a specific kernel/g behavior) rather than count structure in
    (G, 1e30]  ->  B7 re-formulated.  (The dps-80 census
    verification has PASSED -- the drift is measured data,  not an
    engine artifact.)
  - A between-row violation beyond cusp robustness appears in any
    band  ->  B1 data-refuted there;  the row-face clause
    re-scoped.
  - The external human review breaks the 7/8 strip  ->  B6
    reopens;  far region stops being vacuous;  edge lines revert to
    cited classical.
  - A defect face inside (G, 1000G] leaves the v3 support  ->
    E1 v4 re-gate.

## 5.  Next moves,  in order

  1.  FAR-ENGINE  WALL  (s31z2  in  flight):  LOCKED  -  the
      s31z  ladder  shows  the  mpmath  zeta  wall  at
      [9e18,  3e19)  holds  at  ALL  precisions.  THE  5e8G
      LADDER:  dps-15  LANDED  (t  =  1.5000523e19,  logzeta  =
      +2.9370199551,  peak  92.6  GB,  69.8  min)  -  the  last
      reachable  height  is  REAL  REACHABLE  (the  model  was
      ~  11%  low);  dps-20/30/40  in  sequence  (fresh  pro-
      cess  each);  if  dps-40  (the  census  channel)  lands,
      the  staggered  row  protocol  locks  the  boundary  at
      1.5e19;  if  not,  9e18  stands  (the  dps-15  value  is
      recorded  either  way)  and  the  remaining  levers  are  a
      C  zeta  channel  or  more  RAM.  Until  then  B7  stands
      at  its  leveraged  wall.
  2.  Formal:  THE  ENDPOINT  IS  NAMED  AND  THE  SPINE  IS
      CORRECT  -  RHEnd.rh_program78  is  GATED  (four  of  the
      squeeze  regimes  closed  IN  BODY;  the  named  residual
      reduced  to  hs1  (S1  witness),  hs3  (S3  wire),  hWin
      (S4  window-pin  shape),  hS2low  (S2  low-band  pin)),
      and  the  Q  CONTRACT  OF  THE  WALK  SPINE  IS  RETYPED
      TO  THE  CONCRETE  SCALE  Qside  (the  old  form  was  a
      dead  form  -  unsatisfiable  S3;  discovery  0088);  the
      retyped  spine  is  live  (liveness  audit  -  discovery
      0089,  ProbeMargin6  green;  full  build  17450),  and
      Qside  IS  NOW  A  NAMED  DATA  FACE  (discovery  0090):
      QSide.lean  pins  the  day-020  audit  band  (4  candidate
      pairs,  straddle  window  12,  overall  worst  t  =
      1006.7916,  resid  =  0.08168,  dev  =  9.198,  margin
      112.6x;  Xval  pin  headroom  206x)  with  LEAN-PROVEN
      exact-rational  +  Float  gates  (qsideFaceGated);
      Qside  IS  the  measured  |zeta|  fill  resid  =
      |zeta(1/2+it)  -  K_on(t)|  under  the  A4.3  wiring.
      Next  formal  move:  hook  the  QSide  face  into  the
      low-band  leg  (hS2low  /  hs1  at  the  audited  band)
      as  the  CHECKABLE  INSTANCE  of  the  walk  spine,  then
      track  the  external  review  of  B6.
  3.  Docs:  this document is updated by EVERY milestone commit;
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
