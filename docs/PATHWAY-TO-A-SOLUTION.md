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
      THE REVIEW PACKET IS COMPILED (B6-REVIEW-PACKET.md, discovery
      0098):  the exact objects (ONE load-bearing statement -
      externalZeroFree78,  zeta-only;  Dirichlet/Siegel declared
      but not woven;  the endpoint carries hz78 as a NAMED
      hypothesis),  the upstream sources + paths,  the 2-kernel
      verification record,  an ordered 6-item reviewer checklist
      (the 31k-line dependency patch is the highest-leverage human
      item;  the 199-page paper is the long pole),  and the
      degradation path.  If the review finds a flaw,  the
      far-region vacuity and the edge-line exclusion reopen --
      both are single-line reverts to cited-classical status in
      this chart (nothing else moves).
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
      precisions  on  this  124 GB  machine.  s31z2  LADDER  COMPLETE:
      dps-15  (;2.937),  dps-20/30/40  ALL  AGREED
      (logzeta  =  ;1.7289704098,  peaks  92.6/95.1  GB).
      [CORRECTED,  s34/discovery  0100:  the  'dps-15  is  the
      outlier'  verdict  FLIPS  -  dps-15  was  the  truthful
      run;  the  dps-20/30/40  values  are  corrupted  by
      mpmath's  own  ADR  rssum  correction  (rssumS3  =  13.86
      magnitude  at  dps-40  vs  1.18e-5  true,  S1  exact  at
      every  precision;  mpmath  dps-15  ==  C  channel  to
      1e-12).  The  corrected  5e8G  logzeta  channel  is
      2.9370199551  (C  +  dps-15),  NOT  1.7289704098.]
      THE  STAGGERED  ROW  PROTOCOL  LOCKED
      THE  5e8G  ROW  (discovery  0096):  M  =  -3035441152
      (integer;  f64  sum  match  by  construction;  I_far
      dps40  ==  dps60  ==  dps80  bit-identical;  staged
      f64  association  3.6e6  ulp  on  the  record)  -  the
      verified  extreme  boundary  NOW  STANDS  AT  1.5e19
      (the  LAST  mpmath-reachable  row  on  this  machine;
      higher  rows  need  a  C  zeta  channel  or  more
      RAM).  
      ***  THE  C/QUAD  CHANNEL  AND  THE  RSSUM  FINDING  (s34,
      discovery  0100)  ***  A  C/quad  (__float128  +  QD  hi/lo,
      quadmath  linked  without  dev  headers,  tables  as  exact
      integer  triples, scripts/rh/zetac)  Riemann-Siegel  channel
      is  NOW  THE  ZETA  CHANNEL  OF  RECORD  PAST  THE  WALL:
      it  matches  fresh  mpmath  to  ~1e-12  at  t  =  1e17..
      1.5e18,  and  an  INDEPENDENT  bare-cosine  assembly  (no
      F/c/rssum  tables)  agrees  with  it  to  1.3e-5..2.9e-5  at
      1e8G/3e8G/5e8G/1e9G.  The  5e8G  decomposition  (S1  vs
      rz  =  S1  +  rssum*S3  at  dps-15  and  dps-40,  same  t)
      LOCALIZES  THE  MPMATH  BUG  TO  THE  RSSUM  F/COEFFICIENT
      CHAIN  AT  THE  HIGH  WORKING-WIDTH  CHAINS  (J  >=  ~33,
      L  =  4,  M  =  9-12;  the  dps-15  chain  is  clean)  -
      S1  (zetasum_sieved)  IS  EXACT  AT  EVERY  RELEVANT
      PRECISION  (S1  dps-40  =  C  S1  to  ~2e-14).  The
      dps-20+  zeta  anchors  of  the  THREE  FAR  ROWS  ARE
      THEREFORE  CORRECTED  (provenance  C/quad,  cross-checked):
      1e8G  logzeta  =  1.455437142349  (was
      4.4929618099354),  3e8G  logzeta  =  3.284789950625
      (was  -1.5728021802385705),  5e8G  logzeta  =
      2.9370199551  (was  1.7289704098;  C  +  mpmath  dps-15
      to  1e-12).  THE  M  VALUES  OF  THE  THREE  FAR  ROWS
      ARE  UNCHANGED  (recomputed  f64  identity, s34g:  M_old
      ==  M_new  BIT-EXACT,  integer  quantization  resid
      exactly  0.0  -  the  f64  association  at  1e18-1e19
      scale  absorbs  lz  shifts  below  ~O(512))  -  so  the
      s33  re-deconvolution  (fit  on  the  M  values)  STANDS
      UNCHANGED.  PAST-THE-WALL  LOGZETA  DATUMS  HAVE  LANDED
      FROM  THE  C  CHANNEL  (the  reason  the  channel  was
      built):  1e9G  logzeta  =  -1.211098446310  (bare-cos
      cross  d  =  8.8e-06),  1e10G  logzeta  =
      0.455887846369,  3e10G  logzeta  =  2.012486593295;
      the  M  values  of  these  rows  need  the  stream
      channels  (s34f  1e9G  queued;  s34j  1e10G+3e10G
      queued)  -  the  g-side  degeneracy-break  rows  are  now
      a  COMPUTATION  TASK,  not  a  wall.  SUB-WALL  ROWS  ARE
      CLEAN  (re-verified  post-correction):  the  LAST  sub-wall
      census  row  is  5e7G  (a  =  4.886e8),  which  is  the
      SAME  height  class  as  the  verified-clean  point
      t  =  1.5e18  (a  =  4.886e8,  C  ==  mpmath  dps-40  to
      1e-12);  the  corruption  onset  is  STRICTLY  above  it
      (first  confirmed  corruption  at  1e8G,  a  =  6.91e8;
      the  s34k  probe  at  a  =  5.9e8  pins  the  onset).
      So  no  sub-wall  census  row  (all  a  <=  4.886e8)  is
      in  the  corrupted  region  and  their  recorded  logzeta
      channels  stand;  confirmatory  C  crosses  at  5e7G  and
      2e7G  are  queued  on  the  exact  row  heights.  FAR-DRIFT  SHAPE  AT  THE  THREE
      EXTREME  ROWS  (arithmetic,  s32c;  RE-VERIFIED  POST-
      CORRECTION  by  s34g  on  the  unchanged  M  values  -
      identical  fit):  |M|  is  an  EXACT
      quadratic  in  t  (residuals  <<  f64  rounding):
      the  t^2  coefficient  (in  1e8G  units)  is  ;9.59e7
      -  the  drift  is  CONVEX  /  accelerating  (local
      exponent  0.74  then  1.43),  while  |I_far|/t  is
      CONSTANT  to  6  digits  (2.61790e-11):  the  far
      integral  is  t-LINEAR  (settled  channel),  the
      t^2  drift  lives  in  the  M  balance  (the  (t/g0)^2
      kernel-tail  term  engaging).  s33  RE-DECONVOLUTION  (the
      s29  family  on  all  36  rows,  the  3  extreme  rows  now
      in  the  far  set):  the  extreme  curvature  PULLS  THE
      g-side  WINDOW  UP  --  P1  pole  best  h0  =  2e10G
      (max|res|  2.8e5,  ~1e-4  relative  at  the  5e8G  row),
      P3  lognormal  best  at  1e11G  (2.75e5),  admissible
      h0  compressed  from  the  s29  window  [2e8G,  1e11G]
      to  ~[1e10G,  1e12G]  with  the  best  fits  at  the
      UPPER  edge  (h0  ~ 1e10G..1e11G,  best-config  amplitude
      O(1e9..1e12));  the  position-amplitude  degeneracy
      SURVIVES  but  narrows  to  ~2  decades,  and  the
      row  needed  to  break  it  moves  to  t  ~  g0  ~
      3e20..3e21  --  even  deeper  past  the  verified  1.5e19
      [s34  UPDATE:  the  C  channel  HAS  BROKEN  THE  MPMATH
      WALL  -  past-the-wall  logzeta  at  1e9G/1e10G/3e10G
      has  LANDED  (see  the  C/QUAD  block  above);  the  row
      M  values  are  queued  (s34f/s34j),  and  the
      degeneracy  break  becomes  a  computation  task  on  this
      machine].  Feeds  B1  (the  walk)  and  B5  (law
      territory);

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
  - Integer quantization of M (f64-exact) at ALL 36 rows to date
    (28  law-band  rows  +  the  5  s25  far  rows  +  the  2  s30
    extreme  rows  +  the  1  staggered  5e8G  row)  -
    RE-VERIFIED  AFTER  THE  RSSUM  CORRECTION  (s34g:  the
    three  extreme-row  M  values  are  bit-exact  unchanged
    under  the  corrected  logzeta  channels;  the  quantization
    resid  is  exactly  0.0).
  - 5e8G  staggered  row  (THE  LAST  mpmath-REACHABLE  ROW,
    t  =  1.5000523e19):  M  =  -3035441152,  I_far  =
    -1.1781387477189394e19  (dps40  ==  dps60  ==  dps80),
    log|zeta|  =  ;1.7289704098  (dps20/30/40  agree;
    dps-15  =  ;2.937  the  precision  outlier);  zeta
    channel  from  the  fresh-process  ladder,  channels  from
    stage  A  (staggered  -  the  row  does  not  fit  one
    process).
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
      ~  11%  low);  dps-20  LANDED  (logzeta  =  +1.7289704098,
      75.1  min)  and  dps-30  LANDED  (logzeta  =  +1.7289704098
      -  AGREES  with  dps-20;  peak  95.1  GB):  the  dps-15  value
      is  the  OUTLIER  (precision  artifact  at  N  ~  1.5e9
      terms),  the  emerging  stable  value  at  5e8G  is
      log|zeta|  ~  +1.729  (|zeta|  ~  5.64);  dps-40  (the
      census  channel)  LANDED:  logzeta  =  +1.7289704098,
      PEAK  95.1  GB  -  DIGIT-IDENTICAL  to  dps-20/30  (three-
      precision  agreement;  dps-15  =  ;2.937  adjudicated  the
      precision  outlier);  the  STAGGERED  ROW  PROTOCOL  RAN:
      s32a  non-zeta  channels  (eps  =  ;0.7047,  M_partial  =
      -3035441152,  f64  partial  sum  match;  I_far  dps40  ==
      dps60  ==  dps80  bit-identical)  +  s32b  merge:
      THE  5e8G  ROW  IS  LOCKED  -  M  =  -3035441152
      (integer;  f64  sum  match;  staged  association  3.6e6
      ulp  on  the  record);  the  verified  extreme  boundary
      MOVES  9e18  <~  1.5e19  -  THE  LAST  MPMATH-REACHABLE
      ROW  ON  THIS  124  GB  MACHINE  [s34:  the  C  channel
      HAS  SINCE  BROKEN  THIS  WALL  -  see  the  C/QUAD  block
      in  section  2;  1e9G/1e10G/3e10G  logzeta  landed,  M
      values  queued].  THIS  ROW  ALSO  CARRIES  THE
      CORRECTED  LOGZETA  CHANNEL  (2.9370199551,  NOT
      1.7289704098):  the  recorded  M  =  -3035441152  IS
      UNCHANGED  BY  THE  CORRECTION  (f64  association  window,
      s34g  bit-exact);  provenance  is  now  C/quad  +  mpmath
      dps-15  cross.
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
      |zeta(1/2+it)  -  K_on(t)|  under  the  A4.3  wiring;
      and  THE  SECTION-8  CLOSE  AT  THE  AUDIT  BAND  IS
      MACHINE-VERIFIED  (discovery  0091):  mPin  =  1/112.6
      (the  C4  margin  pin)  +  section8_close_at_audit  -  no
      real  X  with  the  C2  lower  bound  dev*(1-mPin)  AND
      the  C3  margin  bound  dev/112.6;  the  engine's
      contradiction  instantiated  at  the  data  face.  Next
      formal  move:  THE  LOW-BAND  WIRE  SHAPE  IS  GATED
      (discovery  0092,  LowWires.lean):  the  R-wires  are
      definitional  zero  below  the  strip,  the  floor  is
      the  near  pin,  and  lowBandSqueezeShape  pins  the
      three  nontrivial  low-band  legs  as  JOINTLY
      contradictory  (0.9975  <=  devStripMin  <=  Qside  <=
      0)  -  the  squeeze  shape  at  the  low-band  wire
      configuration;  and  THE  S1  >=  SIDE  ATOM  IS  GATED
      (discovery  0093,  S1Ge.lean):  the  pointwise  hs1  core
      |zeta  -  K|  >=  devW  -  Mval  from  A0  (p8_same_object)
      +  the  reverse  triangle  +  the  A4.3  mass  premise  -
      the  P1.2  spec's  "LEAN-PROVEN  POINTWISE  under  the  mass
      premise"  row  -  and  THE  HS1  FACE  IS  NAMED
      (discovery  0094,  S1Face.lean):  hs1AtZero  shows  the
      hs1  leg  at  an  ACTUAL  zero  IS  THE  S1Ge  THEOREM
      ITSELF  (zeta  =  0  collapses  the  A0  fill  to  |K|,
      so  the  leg  reads  |K|  >=  devW  -  Mval  -  its  data
      input  is  the  pins,  not  a  bare  witness),  and
      hs1FaceAtAudit  names  the  face  at  the  day-020  band
      (zero-side  claim  vs  resid  pin:  joint  incompatibility
      =  the  squeeze  the  endpoint  consumes)  -  and  THE
      ENDPOINT  IS  RESTATED  (discovery  0095,  RHEnd  Part  B2):
      rh_program78_s1pins  is  the  endpoint  with  the  bare  hs1
      scale  inequality  REPLACED  by  the  PIN  FAMILY  over  the
      witness  zero  (P1  fill  =  the  A0  fill;  P2  the  kernel
      magnitude  pin  devFacePt  <=  |W_n|;  P3  the  A4.3  mass
      pin;  P4  the  absorption  pin  devProg  +  mval  <=
      devFacePt):  the  hs1  leg  is  DERIVED  IN  BODY  via
      S1Face.hs1AtZero,  so  the  residual  narrows  from  "an
      inequality  to  support"  to  "the  pins  to  support"
      (same  content,  checkable  shape)  -  and  THE  LOW-BAND
      OFF-PAIR  EXCLUSION  IS  GATED  (discovery  0099,
      LowExcl.lean):  endpointWireLow  pulls  the  definitional-
      zero  wire  shape  of  LowWires  through  the  endpoint's
      Z78P12  aliases  (BwireP  +  MrP  =  0,  plus  MfP  =  0,
      below  the  strip),  and  lowBandLegsFalse  proves  the
      three  low-band  legs  in  the  EXACT  endpoint  leg  form
      (hs1  Qside  >=  devProg;  hS2low  devProg  >=  0.9975;
      hs3  Qside  <=  BwireP  +  MrP)  are  JOINTLY
      contradictory  at  any  low-band  point  (0.9975  <=
      devProg  <=  Qside  <=  0);  offPairExcludedLowBand  is
      the  corollary:  NO  zero  set  carries  a  low-band
      off-pair  (0  <  t0  <  1000,  0  <  d0  <=  1/2)  while
      the  three  legs  hold  there  -  the  squeeze  (discovery
      0089)  stated  as  an  exclusion  about  the  zero  set,
      not  a  shape  lemma;  the  d0  >  1/2  half  is
      [Z78]-vacuous  (offPairFarEmpty,  in  the  RHEnd  body).
      The  low-band  instance  of  the  endpoint  residual  is
      thereby  SELF-EXCLUDING:  the  obligation  to  support  the
      three  leg  hypotheses  at  EVERY  off-pair  excludes  low-
      band  off-pairs  by  pure  logic  (the  contradiction  needs
      no  datum  -  it  fires  for  ANY  Qside,  ANY  devProg),
      so  the  data  program  only  has  to  feed  the  legs  for
      off-pairs  at  1000  and  above  (covered  region  =  the
      audited  band  data;  window  =  the  window  pin;  far
      region  =  [Z78]-vacuous  apart  from  the  named  blind
      spot).  THE  S4  BLIND-SPOT  FACE  IS  NAMED  AND  ITS  OWN-FLOOR
      FORM  IS  MACHINE-CLOSED-OFF  (discovery  0101,  S4Blind.
      lean):  blindSpot  =  the  own-regime  strip  at  the  pole-
      mass-invisible  scale  (2  d  /  t^2  <  6.5e-5,  25a
      instrument  scale),  squeezeImpossibleOnBlind  proves  the
      squeeze  BwireO  +  Mr  +  Mf  <  mown  IMPOSSIBLE  at  any
      blind-spot  pair  (S4G.s4c_squeeze_impossible  on  the
      strip),  the  25-series  boundary  pins  are  arithmetic-
      gated  (tstarHold  =  690349.0568,  closing  witness
      5004.7343  margin  143.3418,  I(1e7)  =  1.29e-6),  and
      s4OpenFace  is  the  NAMED  open  residue  (S4  at  blind-
      spot  pairs  in  any  wiring  flo  >=  mown  -  measured
      at  the  instrument  boundaries,  not  proven).  The
      remaining  open  content  is  now  EXACTLY  the  named
      faces:  the  hs1  pin  family,  the  hs3  wire  pin,
      hWin  (the  S4  window-pin  shape),  the  C  channel  row
      M  values  (s34f/s34j  in  flight),  the  blind-spot
      S4  face  (S4Blind.s4OpenFace),  and  the  external
      review  of  B6.
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
