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
      ***  THE  FAR-ANCHOR  ADJUDICATION  (s34,  repr-t  finding;
      discovery  0100/0101,  final  entry  0102)  ***  THE
      C/QUAD  CHANNEL  (__float128  +  QD  hi/lo,  quadmath
      without  dev  headers,  exact-integer  tables,
      scripts/rh/zetac)  IS  THE  ZETA  CHANNEL  OF  RECORD
      PAST  THE  WALL  AND  (post-adjudication)  AT  ALL
      FAR  HEIGHTS:  it  matches  fresh  mpmath  to  ~1e-12
      AT  EXACT  ROW  HEIGHTS  (t  =  1e17..3e20  class),  and
      the  INDEPENDENT  bare-cosine  assembly  (no  tables)
      agrees  to  1.3e-5..2.9e-5  at  1e8G..1e9G.  THE  OLD
      "CORRUPTED"  FAR  ANCHORS  WERE  NOT  MPMATH
      CORRUPTION:  EVERY  OLD  CENSUS  PROBE  (s30,  s31z2)
      EVALUATED  mpmath  AT  mpf(repr(f64  t))  -  the
      decimal  REPR  OF  THE  ROW'S  F64  HEIGHT,  OFFSET
      FROM  THE  EXACT  F64  INTEGER  BY  O(1..1e4).  ZERO
      DENSITY  IS  ~6  PER  UNIT  t,  SO  THE  VALUE  CHANGES
      O(1)  PER  OFFSET.  REPRODUCED  EXACTLY  AT  THE  REPR
      HEIGHTS  BY  AN  INDEPENDENT  CHANNEL:  5e7G  mpmath
      (t+120)  =  0.5676737452478491  (=  old  anchor,  all
      16  digits);  1e8G  C(t+240)  =  4.492961809935  (=
      old  anchor  4.4929618099354);  3e8G  C(t-256)  =
      -1.572802180239  (=  old  anchor
      -1.5728021802385705).  THE  s31z2  5e8G  ANCHOR  (
      1.7289704098)  WAS  ALSO  AT  THE  REPR  HEIGHT
      (t+200)  -  its  source  used  mpf(repr(t))  too  -  so
      the  two  5e8G  "classes"  DIFFER  IN  HEIGHT,  NOT
      IN  STATE  (confirmation  queued:  fresh  mpmath  at
      the  repr  5e8G  +  a  forced-low  entry-width  run  at
      exact  5e8G;  s34l  T1  has  landed  CLEAN,  entry
      prec  173  /  S1  width  235  /  2.937019955061246  =
      C  to  all  digits;  T2  running  for  the  determinism
      call).  MPMATH  HAS  NOT  BEEN  SHOWN  WRONG  AT  ANY
      HEIGHT  IN  THIS  AUDIT;  the  upstream  issue  draft
      (docs/MPMATH-RSSUM-ISSUE.md)  is  REWRITTEN  v2  on
      this  finding  and  is  NOT  filed.  RE-ISSUED  ROWS
      (s34o):  ALL  EIGHT  FAR  ROWS  (5  sub-wall  +  3
      extreme)  RECOMPUTED  ON  EXACT-T  C  LOGZETA  -  ALL
      M  VALUES  UNCHANGED  (0  SHIFT),  ALL  EXACTLY
      INTEGER-QUANTIZED  (resid  0.0):  THE  M  CHANNEL  IS
      UNCOUPLED  FROM  O(1-5)  lz  NOISE  AT  THESE
      SCALES.  RE-ANCHORED  LOGZETA  CHANNELS  (exact  t,  of
      record):  2e6G  0.865468081636,  5e6G
      -3.111670188752,  1e7G  0.122468610055,  2e7G
      1.242954054874,  5e7G  -1.395123890841,  1e8G
      1.455437142349,  3e8G  3.284789950625,  5e8G
      2.937019955061,  1e9G  -1.211098446310,  1e10G
      0.455887846369,  3e10G  2.012486593295.  THE
      PAST-THE-WALL  CENSUS  IS  COMPLETE  THROUGH  3e10G:
      1e9G  M  =  -10384437248  (s34f,  resid  0.0),  1e10G
      M  =  -978196824064  and  3e10G  M  =
      -8798461100032  (s34j,  resid  0.0).  C-CHANNEL
      TOOLING  FIX  (same  audit):  the  zchain  struct
      held  t  AS  A  C  DOUBLE  and  the  ZETAC_TEST_T  hook
      PARSED  WITH  STRTOD  -  BOTH  SILENTLY  QUANTIZE  FAR
      HEIGHTS  TO  THE  F64  GRID  (they  would  fake
      height-flatness);  the  hook  is  now  F128  +  an  f128
      override;  the  table  rows  are  UNAFFECTED  (their
      literals  round  to  the  exact  f64  integers  -
      verified  -  every  recorded  C  value  was  already
      AT  THE  EXACT  ROW  HEIGHT).  FAR-DRIFT  SHAPE  AT  THE  THREE
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
      machine].  s33b  PAST-THE-WALL  RE-DECONVOLUTION  (39
      rows,  far  set  through  3e10G):  THE  FAR  DRIFT
      D(t)  =  M  -  (A  ln  t  +  B)  (A,  B  from  the
      near  face)  IS  A  PURE  QUADRATIC  IN  t  OVER
      THREE  DECADES  -  1e9G:  -9.7750e9,  1e10G:
      -9.7753e11  (ratio  100.000),  3e10G:  -8.7978e12
      (ratio  9.000);  |D|  =  1.086e-29  *  t^2  to  3
      digits,  i.e.  in  g  =  t/G  units  M  ~
      -9.776e-9  *  g^2  dominates.  THE  B7
      POSITION-AMPLITUDE  DEGENERACY  IS  BROKEN  ON  THE
      MEASURED  DOMAIN:  the  far  M  law  is  NOT  the
      near  log  law  -  the  residual  shape  is  NOW
      EXACTLY  IDENTIFIED  (no  free  shape  parameter);
      the  s33  "degeneracy  survives"  reading  is
      SUPERSEDED.  DATA  READING  GUIDE:  docs/DATA-LEDGER.md
      (generated,  machine-verified  tables:  exact  f64  row
      integers,  repr  offsets,  the  channel  of  record,  the
      old  anchors,  the  M  identity  inputs,  provenance,  the
      audit  trap  list)  -  read  it  before  interpreting  any
      far  number.  RESOLUTION  FLOOR  (s34w,  measured):  the
      repr  offsets  of  the  four  low  rows  (2..48  units)  are
      INVISIBLE  at  dps-15  (the  53-bit  width  estimate
      quantizes  the  term  count  to  an  effective  height
      resolution  of  ~9..90  units  at  6e16..6e17)  but  WERE
      resolved  at  the  s25  dps-40:  s34x  re-ran  those  repr
      heights  at  dps-40  (fresh  process  each)  and  ALL  FOUR
      OLD  LOW  ANCHORS  REPRODUCE  BIT-EXACTLY  (dt  =  0.0  to
      the  printed  float),  with  the  exact-height  control  at
      the  canonical  value  to  1  ulp  -  the  repr-t  artifact
      record  is  CLOSED  for  the  ENTIRE  row  set  (the  high
      rows'  120..256  unit  offsets  reproduce  even  at  dps-15
      and  are  adjudicated).  FORMAL:  formal/RhAttack/B7Far.lean
      GATED  (five  norm_num  gates  on  the  MFar  pins  -
      decomposition  nl  =  M  -  D,  the  near-log  share  windows
      and  its  >=10x-per-decade  decay,  NOT-A-LINE-IN-LN-T
      (second  drop  ratio  8.0804  in  [7,9]  vs  the  ln-line
      0.477121  and  the  t*ln-t  2.2875),  and  T^2  STEP
      CONSISTENCY  (drop  ratio  within  4.6e-4  of  the  pure  t^2
      step  ratio  8.0808081  at  the  exact  pinned  heights  -
      the  residual  shape  is  the  t^2  /  kernel  -t^2/g^2
      family,  identified)  plus  b7OpenFace  -  the  open
      mechanism  (positive  far-side  excess  on  the  s29  g-window
      [2e8,  1e11]  whose  generated  drift  hits  the  pinned  D)
      as  a  named  Prop  in  the  S4Blind  s4OpenFace  pattern;
      the  endpoint  is  untouched  (far  region  vacuous  in  body
      from  [Z78];  B7  is  a  measured  constraint,  not  one  of
      the  four  named  residuals).  Feeds  B1  (the  walk)  and
      B5  (law  territory);  FORMAL:  formal/RhAttack/S4WinCap.lean
      GATED  (the  hWin  window  cap  +  face  identity;  s35a  data
      backstop  survey  in  tmp/s35a_hwin_far_survey.py,  log
      tmp/s35a_hwin_survey.log):  (1)  poffOwnMown  -  at  the
      pair's  own  height  the  B5  off-line  factor  mass  equals
      S4O.mown  (the  8-factor  kernel  =  B5's  four  factors  at
      (t, d, t);  the  25n  closed-form  bridge  is  S4O.hMownProd);
      (2)  floorBelowWire  -  on  the  WHOLE  window  band  1000  \<=  t,
      0  <  d  <  1/200,  floStripMin  <=  mown  <  31/(10^5  t^2)
      (each  own-kernel  factor  pinned  separately;  exp  pin  via
      log  x  <=  x-1)  and  that  cap  is  STRICTLY  below  the
      P8  tail  term  at  the  wire  index  on  BOTH  branches  (near
      t  ≤  110000:  squaring  chain  to  50000^2  t^4;  far  t  >  110000:
      62t  <  100000  t^2)  -  so  the  S2  floor  never  meets  the
      S4  wire  on  the  window  band;  (3)  the  FACE  IDENTITY  -
      hWinFace  (the  hWin  hypothesis  of  RHEnd.rh_program78,
      restated  verbatim  over  the  Z78P12  wire  aliases)  is
      EQUIVALENT  to  zero-exclusion  of  off-line  zeros  on  <= 1000,
      inf)  x  (0,  1/200):  the  squeeze  instrument  is  certified
      to  NOT  reach  the  window  band,  so  the  face  IS  the
      zero-exclusion  statement  there.  hXgrowPos  (S4G.Xgrow  >  0
      past  T0,  by  the  S4W.hLn27  ln-pin)  carries  the  far
      branch's  Mr  positivity.  THE  FACE  REMAINS  OPEN:  it
      asserts  zero-exclusion  on  a  band  no  instrument  in  the
      tree  reaches  (classical  zero-free  regions  stop  far  from
      Re  1/2  -  1/200);  the  endpoint  and  the  other  three
      named  residuals  are  untouched  -  hWin  is  now
      CHARACTERIZED,  not  closed.  No  RH  claim.
      FORMAL:  formal/RhAttack/WinCount.lean  GATED  (the  hWin
      SHINK;  the  face's  open  content  shrinks  twice,  two
      INDEPENDENT  routes):  (A)  THE  CLASSICAL  FRONTIER  -
      tPT  :=  30610046000  pins  the  rigorous  zero-isolation
      record  (Platt,  "Isolating  some  non-trivial  zeros  of
      Zeta":  interval-arithmetic  isolation  of  every
      non-trivial  zero  with  0  <  Im  <=  tPT  to  +-  2^-102,
      an  independent  verification  of  the  line  to  that
      height;  the  public  LMFDB  zero  stream  ends  at  exactly
      this  height  -  the  record's  own  frontier):  [Z-PT]
      allOnLineUpTo  q  tPT  is  CITED  over  the  ABSTRACT
      ZeroSet  (the  Z78-strip  pattern),  and  faceSplit
      certifies  S4WC.hWinFace  q  <->  hWinFaceResidual  q  -
      under  [Z-PT]  the  face  IS  zero-exclusion  on  (tPT,  inf)
      x  (0,  1/200):  the  open  face  of  the  endpoint's  hWin
      residual  shrinks  by  a  height  factor  of  about  3e7
      (from  1000  to  3.06e10);  the  higher  literature
      frontier  (RH  verified  up  to  3  x  10^12,
      Platt-Trudgian,  arXiv:2004.09765)  is  named  as  an
      optional  add-on  input.  (B)  THE  3e9  RECORD  SHADOW
      (an  independent  route,  record-derived):  the  H1  3e9
      stream  record  is  pinned  and  re-gated  -  Nline  :=
      9064192826  (the  exact  on-line  count  at  3e9)  and
      rvm3e9  :=  9064192825.58  (the  recorded  RVM  value;
      RVM  counts  the  STRIP  zeros):  pinGates  machine-checks
      diff  =  21/50  and  |diff|  =  0.42  <=  3  (the  fleet's
      own  +-3  RVM  finish  gate);  D_even  (LEAN-PROVEN  for
      ANY  ZeroSet:  the  off-line  excess  of  (0,  t]  is
      even  -  the  whole-slice  twin  of  B0.offSliceEven)  and
      offExcessBound  (q  with  the  pinned  on-line  count  whose
      strip  count  passes  the  record's  +-3  gate  has
      B0.D  q  (3e9)  <=  2  -  AT  MOST  ONE  OFF-LINE  ORBIT
      below  3e9  -  0  or  2  with  D_even).  The  RESIDUAL  IS
      OPEN:  zero-exclusion  on  (3.06e10,  inf)  x  (0,  1/200)
      is  where  no  instrument  in  the  tree  reaches  (the
      classical  zero-free  regions  stop  at  Re  >  1  -  c/ln
      t,  nowhere  near  Re  =  1/2  +-  1/200,  and  the
      measured  zero  walk  ends  at  the  frontier).  The
      endpoint  and  the  other  three  named  residuals  are
      untouched.  No  RH  claim.
      FORMAL:  the  shrink  is  now  WIRED  AT  THE  ENDPOINT
      (discovery  0107):  RHEnd  Part  B3  adds
      rh_program78_winpt  -  rh_program78  with  hWin  DERIVED  IN
      BODY  from  the  CITED  frontier  [Z-PT]  plus  the  residual
      face  (WinC.hWinFaceResidual):  under  [Z-PT],  the
      endpoint's  hWin  premise  is  EXACTLY  zero-exclusion  of
      off-line  zeros  on  (3.06e10,  inf)  x  (0,  1/200)  (the
      S4WinCap  face  identity  +  WinC.faceSplit;  no  off-pairs
      on  [1000,  tPT]  follow  from  [Z-PT]  alone)  -  the
      residual's  open  height  interval  at  the  endpoint  shrinks
      by  a  factor  of  about  3e7.  The  3e9  record  shadow
      (offExcessBound:  off-line  excess  below  3e9  is  0  or  2
      under  the  record's  +-3  gate)  stays  an  independent,
      record-derived  constraint  on  the  same  open  region  and
      is  deliberately  kept  OUT  of  the  endpoint  premises.  The
      endpoint  statement  itself  (rh_program78)  is  UNTOUCHED;
      full  tree  re-verified  green  (17450  jobs).  No  RH
      claim.
      FORMAL:  the  two  shrink  routes  MERGE  BELOW  THE
      FRONTIER  (discovery  0108,  WinCount  section  (C),
      451  lines  total):  dZeroBelowRecord  proves  that  any
      zero  set  consistent  with  [Z-PT]  has  D(3e9)  =  0
      EXACTLY  (the  B0.zeroD_of_RH  slice-filter  pattern  with
      the  RH  hypothesis  replaced  by  the  frontier  on  (0,
      tPT];  strictly  sharper  than  the  shadow's  D  <=  2;
      0  is  the  even  case  of  D_even),  and  rvmGateDischarged
      proves  that  the  recorded  exact  count  Nline  implies
      the  fleet's  +-3  RVM  gate  |Ntot  -  rvm3e9|  <=  3  as  a
      theorem  (pure  record  arithmetic  via  pinGates;  the
      frontier  is  not  used  in  that  arithmetic).  Below  tPT
      the  routes  carry  each  other's  load:  [Z-PT]  gives  D
      =  0,  and  the  pinned  count  re-derives  the  +-3  gate
      that  offExcessBound  consumed  as  a  hypothesis.  NOTE
      (search  record):  a  fully  CITED  S(t)  error  bound  at
      3e9  (to  make  the  shadow  gate  cited  rather  than
      recorded)  was  pursued  doc-first  -  the  best  available
      explicit  unconditional  bound  found  (Trudgian,
      |S(T)|  <=  0.1013  log  T  for  large  T  -  arXiv:1010.4596
      /  Math.  Comp.  78  (2009))  evaluates  to  <~  2.21  at
      3e9,  ABOVE  the  3  -  5/8  <=  1.875  needed  to  force
      the  +-3  gate  from  the  RVM  formula  alone;  the  gate
      therefore  stays  recorded  data  (as  the  fleet  ran  it),
      and  the  route  merge  above  is  the  clean  closure.  No
      RH  claim;  full  tree  green  (17450  jobs),  0  sorry,  99
      cards.
      FORMAL:  THE  HS1  UNIFORMITY  TRACK  IS  PINNED  AT  ITS
      FRONTIER  (discovery  0109):  formal/RhAttack/S1Marg.lean
      GATED  (193  lines,  0  sorry)  -  where  S1Face  closes  hs1
      at  the  day-020  audited  band,  the  OPEN  piece  is  the
      uniformity  track  ("does  the  squeeze  hold  at  every
      witness  height,  with  what  margin?"):  the  P1.1e
      BEST-STRADDLE  CLOSURE  STATISTIC  (the  margin  of  the  hs1
      composite  squeeze  at  the  best  straddle  point  of  the
      window)  is  pinned  from  three  CERTIFIED  runs  at  the  25
      candidate  heights  in  [1e3,  2.8e7]  (the  1e7  run:  14
      candidates,  per-t  quadrature  to  1e18;  the  1e6ext:  4;
      the  (1e7,  1e9]  band  scan:  the  7  REAL-zero  candidates
      only  -  dps-30  per-t  quadrature  with  the  exact
      discrete  tail  over  47,517,736  LMFDB  zeros;  the  9
      higher  "exp"  rows  are  exploratory  nominal  points  and
      are  deliberately  NOT  pinned)  -  and  the  regime  is
      GATED  by  exact-rational  norm_num  on  the  anchors:
      the  25x  window  (margin  >=  25  up  to  the  150000.2616
      candidate,  38.053;  <  25  at  199999.7053,  21.665:  the
      certified  25x  regime  closes  between  1.5e5  and  2e5),
      the  >=  13  class  to  1e6  (13.068  at  999999.7934),
      the  >=  1  class  to  the  end  of  the  certified  band
      (minimum  1.4138  at  19999999.8837),  the  height  order,
      and  the  DECAY  order  (28.918  >  15.504  >  13.068  >
      5.2362  >  1.4138  -  the  regime  degrades  monotonically
      with  height).  The  named  face  (hs1MargFace,  b7OpenFace
      pattern)  is  the  uniform  statement  itself  -  every
      height  that  carries  an  off-pair  zero  has  margin
      >=  1  -  OPEN:  the  pins  are  its  measured  shadow  at
      the  25  candidates;  the  exploratory  "exp"  signal
      (margins  below  1  from  3.1e7)  is  the  recorded
      indication  that  the  composite  becomes  the  limiting
      object  above  the  certified  regime  (the  repair-list
      class).  The  endpoint  is  UNTOUCHED  (hs1  remains  a
      named  residual,  read  by  S1Face.hs1AtZero,  closed  at
      the  audited  band,  pin  family  form  in  RHEnd  Part
      B2);  this  module  is  a  MEASURED  CONSTRAINT  (anything
      that  proves  RH  must  reproduce  the  margin  regime).  No
      RH  claim;  full  tree  green  (17450  jobs),  100  cards.
      FORMAL:  THE  ENDPOINT  COLLAPSES  TO  THE  CITED  FRONTIER
      (discovery  0110):  RHEnd  Part  B4  adds  rh_program78_frontier
      -  the  strongest  composition  in  the  program  shape  so  far:
      every  named  residual  of  rh_program78  (hs1  S1  witness,  hs3
      S3  wire,  hWin  S4  window  pin,  hS2low  S2  low-band  pin)
      is  quantified  over  OFF-PAIR  zeros,  and  WinCount  adds
      noOffLineBelowPT  -  for  ANY  zero  set  consistent  with  the
      cited  [Z-PT]  frontier  (zeros  up  to  tPT  =  3.06e10  on  the
      line),  there  is  NO  off-line  zero  below  tPT  at  ANY  offset
      (t0  =  0  by  non-realness,  0  <  t0  by  the  sign  argument
      with  the  conjugate  twin)  -  so  below  the  frontier  ALL
      FOUR  residuals  are  VACUOUS,  and  the  new  endpoint  variant
      takes  [Z-PT]  plus  ONLY  the  above-frontier  content:  hs1  and
      hs3  restricted  to  t0  >=  tPT  (bound-level  wire  inequalities
      at  hypothetical  off-pairs  -  no  measured  data  can  speak
      there;  no  zero  list  past  the  frontier  in  the  tree)  plus
      the  hWin  residual  face  (zero-exclusion  on  (tPT,  inf)  x
      (0,  1/200));  hS2low  DISAPPEARS  ENTIRELY  (its  domain  (0,
      1000)  sits  below  the  frontier  and  is  vacuous  under  [Z-PT]).
      The  whole  residue  of  the  endpoint  (four  named  residuals  on
      (0,  inf)  x  (0,  1/2))  is  now  content  STRICTLY  ABOVE  tPT  =
      3.06e10  -  one  height  interval,  where  no  instrument  in  the
      tree  reaches  (the  classical  zero-free  regions  stop  at
      Re  >  1  -  c/ln  t,  nowhere  near  Re  =  1/2  +-  1/200).
      No  RH  claim;  full  tree  green  (17450  jobs),  0  sorry,  100
      cards.
      FORMAL:  THE  ENDPOINT  OVER  THE  STRIP  FRONTIER  (discovery
      0111):  RHEnd  Part  B5  adds  rh_program78_stripfront  -  the
      lever-1  investigation  of  whether  the  above-frontier  hs1/
      hs3  faces  are  body-provable  lands  as  a  PRECISE  VERDICT:
      in  the  strip  band  (t0  >=  1000,  1/200  <=  d0  <=  1/2)
      the  four  closure  legs  form  a  contradiction  at  any
      off-pair  zero  -  S1:  scale  >=  devProg;  S2:  devProg  >=
      floStripMin  (in  body,  s2ActualFullBand,  NO  HEIGHT  CAP);
      S3:  scale  <=  Bwire  +  Mr;  S4:  Bwire  +  Mr  <  floStripMin
      (in  body,  s4StripUnifiedFloor,  NO  HEIGHT  CAP)  -  so  the
      squeeze  cycle  needs  only  the  two  SCALE  faces  there,  and
      in  the  window  band  (d0  <  1/200)  the  hWin  zero-exclusion
      above  the  frontier  kills  every  off-pair  directly:  the
      hs1/hs3  premises  shrink  from  all  d0  in  (0,  1/2]  to  the
      STRIP  BAND  above  tPT.  What  is  BEHIND  the  two  strip  faces
      (named  in  the  docstring  -  the  body  does  NOT  close  them).
      G-hs3  is  the  off-line  LIFT  of  the  critical-line  T4  wire
      (p8_B_floor  instantiates  p4_T4_bound  at  Re  s  =  1/2;  an
      off-pair  zero  is  off  the  line  by  definition;  the  tree
      has  no  kernel  upper  bound  at  off-line  points  -  the  P3
      mass  pin  is  a  premise  by  design),  and  G-hs1  is  the  scale
      anti-degeneracy  lower  bound  (body  has  kernel  UPPER  bounds
      and  detector  LOWER  bounds  only  -  its  measured  shadow  is
      the  S1Marg  margin  track).  G-hs1  +  G-hs3  on  (tPT,  inf)  x
      [1/200,  1/2]  ARE  the  strip-band  zero-exclusion:  the entire
      above-frontier  residue  of  the  endpoint  is  now  named  -
      two  analytic  gap  statements  plus  the  window  face.
      FORMAL:  THE  B7  WALK  CONSUMER  (discovery  0112):  B7Far
      section  D  wires  the  card's  first  consumer  candidate  -  the
      "walk  (B1)"  of  the  old  layout  is  the  W2T.DN  tail-walk
      drift  operator  with  the  W2Beyond  drift  step  law.  b7WalkFace
      states  the  b7OpenFace  pattern  with  gen  =  that  operator  over
      three  consecutive  steps  (N0  =  0),  and  b7WalkHitAny  proves  it
      BY  CONSTRUCTION:  for  ANY  three  reals  a,  b,  c  there  is  a
      count  grid  whose  walk  drift  hits  them  at  steps  1,  2,  3
      (grid  =  i  -  value_i  at  i  in  {1,  2,  3},  0  elsewhere)  -
      the  WALK  OPERATOR  HAS  EMPTY  STRUCTURAL  CONSTRAINT  on  a  drift
      triple,  so  the  walk  is  NOT  excluded  as  the  B7  mechanism,  and
      the  open  link  of  the  walk  candidate  is  exactly  the  E  ->
      grid  INPUT  map  (the  excess  driving  the  count-grid
      increments),  which  is  not  in  the  tree.  The  law-territory
      candidate  (B5  =  the  concrete  4-factor  own-detector  poff)
      remains  unconsumed.  No  RH  claim;  full  tree  green  (17450
      jobs),  0  sorry,  100  cards.
      FORMAL:  THE  B7  LAW-TERRITORY  CONSUMER  (discovery  0113):
      B7Far  section  E  wires  the  card's  second  consumer
      candidate  -  the  old  "law-territory  (B5)"  -  which  in  the
      current  module  layout  is  the  P4  TAIL-LAW  family  (P4Limit,
      the  EM-tail  T3  wall).  The  law's  T3  tail  bound  (t3w_T3UB:
      the  certified  tail  size  at  height  t,  cutoff  n  =
      floor(13t/8))  closes  on  the  WHOLE  wall  range  1  <=  t  <=
      1e8  (p4_25ae_wall_list_scale)  -  that  is  the  wall  the  B7
      record  calls  "past-the-wall"  (the  far  M  rows  and  the  D
      drift  sit  beyond  it,  s33b).  The  law-territory  mechanism
      is  STRUCTURALLY  EXCLUDED  (b7LawExcluded)  on  two  exact
      grounds:  POSITION  -  the  B7  support  window  [2e8,  1e11]
      and  all  three  pinned  far  heights  sit  beyond  the  wall
      range  (b7WindowBeyondLawWall  /  b7PinsBeyondLawWall,
      norm_num),  where  the  law  makes  no  statement  (the  wall  is
      not  closed  above  1e8);  MAGNITUDE  -  on  the  whole  wall
      range  the  certified  tail  content  is  strictly  below  1/2
      (lawTailBelowHalf:  the  n  =  0  branch  by  (0:R)^(-1/2)  <=
      1,  the  n  >=  1  branch  by  n^(-1/2)  <=  1  and  35/39  <  1)
      while  every  B7  pinned  drift  is  strictly  above  1/2  (the
      smallest,  |D9|  =  9774967307,  growing  |D9|  <  |D10|  <
      |D30|)  -  a  gap  of  about  14  orders  of  magnitude.  The
      two  consumers  together  bracket  the  mechanism  space  of
      b7OpenFace:  the  WALK  candidate  SURVIVES  (realizable  by
      construction;  open  link  =  the  E  ->  grid  input  map),  the
      LAW-TERRITORY  candidate  IS  EXCLUDED  (position  +
      magnitude),  and  the  remaining  B7  mechanism  content  is  the
      UNNAMED  channel  of  the  excess  input  E  itself  past  the
      wall.  No  RH  claim;  full  tree  green  (17450  jobs),  0
      sorry,  100  cards.

  FORMAL:  THE  E  FACE  (discovery  0114):  B7Far  section  F
      gives  b7OpenFace  its  measured  shadow,  like  the  other
      faces:  the  SIX-ROW  past-the-wall  drift  chain  is  pinned
      (dD1e8  =  -97446239.9,  dD3e8  =  -879453192.2,  dD5e8  =
      -2443487733.7  at  the  wall-edge  rows  1e8G/3e8G/5e8G  -
      s33b,  cross-checked  identical  in  s33  -  plus  D9/D10/
      D30  from  MFa),  with  the  growth  chain  dChainGrowth
      (|D|  grows  at  every  step,  one  norm_num)  and  the
      window  anchors  eWinLo  2e8  /  eWinHi  1e11  in  g/G
      units  (eWindowGates:  window  order  +  window  past
      the  T3  wall  top).  b7ChainLawGap  is  the  composed
      exclusion  over  the  whole  chain:  law  content  (t3w_
      T3UB)  is  <  1/2  at  every  certified  height  in  [1,
      1e8]  while  every  value  of  the  six-row  chain  is  >
      1/2  -  including  the  wall-edge  row  itself.  Part  A  of
      the  deconvolution  record  is  noted:  the  min-norm  solve
      localizes  NOTHING  (no  delta-e  support  above  3e-3  in
      either  s29  or  s33b)  -  the  excess  exists  only  at
      the  window  +  drift-hit  level,  exactly  the  boundary
      of  the  unnamed  E  channel  (0113).  The  section  E
      narrative  is  refined  to  the  TWO-READING  position
      ground  (raw  height  parameter  vs  g/G  window;  the
      census  scale  G  and  the  record's  own  mpmath  wall  at
      ~9e18  are  record-level;  the  T3  wall  top  1e8  lies
      below  both).  Also  fixed:  the  section  D  bullet
      committed  at  0113  (the  linter-suggested  `split_ifs
      <;>  (try  contradiction;  ring)`)  parsed  as  try(
      contradiction;  ring)  and  left  the  true  branches
      unsolved  (that  round's  full-tree  green  was  a  lake
      cache  artifact);  rewritten  in  the  unambiguous
      all_goals  form  and  verified  green.  No  RH  claim;
      full  tree  green  (17450  jobs),  0  sorry,  100  cards.

  FORMAL:  THE  ENDPOINT  AT  THE  PLATT-TRUDGIAN  FRONTIER
      (discovery  0115):  the  bodies  of  rh_program78_frontier
      and  rh_program78_stripfront  are  UNIFORM  in  the
      frontier  -  RHEnd  part  B6  writes  them  once  with  H  a
      PARAMETER  (rh_program78_frontierH,  rh_program78_
      stripfrontH;  hH  1000  <=  H  for  the  hS2low  vacuity)
      and  instantiates  at  BOTH  cited  frontiers.  The  second
      frontier  is  the  PLATT-TRUDGIAN  verified  record
      (arXiv:2004.09765,  Theorem  1,  verified  against  the
      paper  this  round):  RH  is  true  up  to  height
      3,000,175,332,800  -  the  lowest  12,363,153,437,138
      non-trivial  zeros  have  Re  =  1/2,  rigorous  interval
      arithmetic,  and  the  paper  independently  verifies  the
      Platt  tPT  isolation.  Pinned  as  WinC.tPT2  with
      ptFrontierOrder  (tPT  <  tPT2,  one  norm_num);  the  face
      split  is  generalized  to  WinC.faceSplitH  (S4WC.
      hWinFace  <->  hWinFaceResidualH  q  H  under  [Z-H])  with
      faceResidualMonotone  (the  face  at  the  smaller
      frontier  implies  the  face  at  the  larger;  the  gap
      between  the  frontiers  is  open  content,  not  in  the
      tree).  The  instances  rh_program78_frontier_PT2  and
      rh_program78_stripfront_PT2  put  the  ENTIRE  named
      residue  of  the  endpoint  (G-hs1,  G-hs3,  the  window
      zero-exclusion  face)  STRICTLY  ABOVE  3,000,175,332,800
      instead  of  above  30,610,046,000  -  the  open  height
      interval  shrinks  by  about  100x  at  ZERO  computational
      cost  (a  published,  rigorous,  independently
      verifiable  record  replaces  a  computed  walk;  no  new
      zeros  are  claimed).  Same  honesty  as  every  variant:
      [Z-PT2]  CITED;  the  above-frontier  faces  OPEN;  no  RH
      claim.  Full  tree  green  (17450  jobs),  0  sorry,  100
      cards.

  FORMAL:  THE  G-hs3  ATTACK  -  THE  T4  WALL  LIFTS  OFF  THE
      LINE  (discovery  0116):  G-hs3  (the  endpoint's  off-line
      lift  of  the  critical-line  T4  wire)  is  no  longer  an
      analytic  barrier.  The  new  module  T4Off.lean  proves  the
      T4  wall  of  P4Limit  (the  B-wire  source)  OFF  THE
      LINE:  p4_T4_bound_gen  -  for  -1  <  s.re  (BOTH  sides  of
      the  critical  line)  and  n  >  0,  |p4_em_expr  s  n|  <=
      (1/2)  n^-s.re  +  (|s|/12)  n^-s.re-1  +  (sqrt(3)/216)
      |s(s+1)(s+2)|  n^-(s.re+2)/(s.re+2),  with  exact  off-line
      powers;  the  atoms  p4_op2c_bound_gen  /
      p4_f2_tail_bound_gen  carry  the  exact  constant
      (sqrt(3)/108)|s+2|  (x  |s(s+1)|)  n^-(s.re+2)/(s.re+2).
      The  wall's  entire  proof  structure  (per-period  IBP  with
      the  B3  primitive  and  the  |B3poly|  <=  sqrt(3)/36  pin,
      boundary  cancellation,  unit-interval  summation,  FTC
      reassembly,  M->inf  bounded-limit  passage)  uses  the
      critical-line  hypothesis  in  exactly  THREE  places  -  the
      endpoint  complex-power  norms  (valid  for  every  Re  s  >
      -1)  and  the  tail  antiderivative  x^-(s.re+2)/-(s.re+2)
      (needing  s.re  +  2  >  0)  -  and  all  three  lift  to
      uniform  statements;  sharpness  theorems  (t4genTerm12_
      at_line  /  t4genTerm3_at_line)  recover  the  on-line
      statement  exactly  at  s.re  =  1/2  (sqrt(3)/540).  WHAT
      THIS  CLOSES:  G-hs3-i  -  at  a  hypothetical  off-pair  zero
      rho  in  the  strip  band  (1/200  <=  |rho.re  -  1/2|  <=
      1/2),  zeta(rho)  =  0  makes  W_n(rho)  =  -(P_n  -  I_n)(rho)
      by  the  SAME  cited  DLMF  25.2.8  identity  the  tree  cites
      on  the  line  (its  analytic-continuation  bridge  reaches
      every  Re  s  >  1/2  -  BOTH  sides  of  the  strip  band),
      so  the  EM  scale  |W_n(rho)|  is  now  MACHINE-BOUNDED
      off  the  line  at  the  strip  n-schedule.  WHAT  REMAINS
      (named  in  the  file  docstring):  G-hs3-ii  -  the  P6
      finite-kernel  gap  |K(rho)  -  (P_n  -  I_n)(rho)|  <=
      M_wire  LIFTED  OFF  THE  LINE  (the  g-product  terms  carry
      g^-sigma  factors  with  sigma  =  rho.re  =  1/2  +/-  d0  that
      the  on-line  wire  never  evaluates);  G-hs3-iii  -  the
      margin  composition  (i)  +  (ii)  <  floStripMin(t0,  d0)
      on  the  strip  band  above  the  frontier.  With  ii  +  iii,
      hs3  holds  IN  BODY  at  every  off-pair  above  the
      frontier  and  drops  out  of  the  endpoint  premises  of
      rh_program78_stripfront_PT2;  G-hs1  stays  open.  No  RH
      claim:  bound  theorems  about  a  concrete  kernel
      expression,  exactly  the  status  of  the  on-line  T4
      wall.  Full  tree  green  (17450  jobs),  0  sorry,  101
      cards.

  FORMAL:  G-hs3-i  CLOSED  AT  THE  ENDPOINT  LEVEL  -  THE
      STRIP-BAND  DOMINATION  (discovery  0117):  the  new
      module  T4OffD.lean  closes  the  last  component  gap
      between  discovery  0116  and  a  live  endpoint  leg:
      t4wall_offline_le_bwires  proves  that  for  every
      1000  <=  t0  and  1/200  <=  d0  <=  1/2,  the
      OFF-LINE  lifted  T4  wall  (p4_T4_bound_gen  at  the
      canonical  strip  point  (1/2 + d0) + it0  with  the
      t^4  n-schedule  S4Strip.n4)  is  TERMWISE  below  the
      ON-LINE  B-wire  P8Floor.p8_B  t0  (S4Strip.n4  t0)
      -  the  wire  the  endpoint  already  pays  for  on
      the  line.  The  three  termwise  dominations:  term
      1  is  damped  by  n^(-d0);  term  2  trades  the
      norm  ratio  <=  6/5  (the  1/200  strip  width
      against  the  t^4  growth)  against  n^(-d0)  >=  6/5
      at  the  band  edge  (the  200th-root  wall  n  >=
      (6/5)^200);  term  3  trades  the  per-factor
      translation  ratio  <=  2001/2000  (product
      (2001/2000)^3  =  1.0015...)  against  the  wall
      constant  540  vs  216  (a  factor  2)  and  the
      (5/2 + d0)  denominator,  with  the  damping  constant
      (2001/2000)^3  *  n^(-d0)  <=  (2/5)  *  (5/2 + d0)
      (n^(-d0)  <=  1  and  (2001/2000)^3  <  1.0016  <=
      (2/5)  *  2.505  =  1.002  -  the  margin  is  pure
      constant  arithmetic).  CONSEQUENCE  for  the
      endpoint:  the  hs3  side  of  the  strip-frontier
      premise  (the  EM  scale  at  an  off-pair  zero)  is
      now  dominated  by  the  strip  B-wire  BwireR(t0,
      d0)  at  EVERY  point  of  the  band  -  G-hs3-i  is
      closed  in  endpoint  form,  not  just  at  component
      level.  WHAT  REMAINS:  G-hs3-ii  -  the  P6
      finite-kernel  gap  /  Mr  wire  lifted  off  the
      line  (the  g-product  terms  carry  g^-sigma  factors
      the  on-line  wire  never  evaluates);  G-hs3-iii
      -  the  final  margin  composition  (i)  +  (ii)  <
      floStripMin(t0,  d0)  on  the  strip  band  above
      the  frontier  (the  B-wire  term  already  sits  in
      that  sum  in  the  S4A  strip  floor  -  iii  is
      largely  the  bookkeeping  step).  With  ii  +  iii,
      hs3  holds  IN  BODY  at  every  off-pair  above  the
      frontier  and  drops  out  of  the  endpoint
      premises;  G-hs1  stays  open.  No  RH  claim:
      termwise  domination  between  two  explicit  wire
      expressions  on  a  concrete  band.  Full  tree
      green  (17450  jobs),  0  sorry,  102  cards.

  FORMAL:  G-hs3-ii  +  G-hs3-iii  CLOSED  IN  THE  MACHINE  -  THE
      MR  WIRE  LIFTED  OFF  THE  LINE  (discovery  0118):  the  new
      module  T4OffM.lean  (812  lines,  0  sorry,  GATED,  full
      tree  green)  closes  the  K-side  half  of  the  G-hs3
      program.  The  off-line  M-wire:  t4m_ZboundOff  (t0,  d0)
      :=  1.6  *  t0^(1/4  +  d0/2)  *  ln  t0  -  the  CITED
      DLMF  25.15.4-type  convexity  mass  (the  SAME  1.6  the
      tree  already  cites  on  the  line,  transferred  through
      the  functional  equation  |zeta(rho)  /  C(rho)|  =
      |zeta(1  -  rho)|  at  the  off-pair  zero;  the  worst
      side  is  sigma  =  1/2  +  d0)  -  the  ONLY  non-machine
      input  of  the  module  -  and  t4m_MwireOff  (t0,  d0)
      :=  ZboundOff  *  e^X4fun  *  X4fun  (the  on-line
      M  *  e^X  *  X  shape  at  the  lifted  mass;  the  b3
      correction  is  sigma-independent,  so  no  new  analytic
      barrier).  Machine  chain  (all  LEAN-proven  on  the
      band,  pins  audited  by  tmp/t4offm_audit.py,  margin
      ~16  orders  at  the  corner):  t4m_shape  (ZboundOff  =
      on-line  Zbound  *  t^(d/2));  t4m_Mterm  (MwireOff  <=
      MTUBfun  *  t^(d/2)  via  the  on-line  st_hMterm  chain);
      t4m_Mpin  (MTUBfun  *  t^(d/2)  <=  2.5e-15  *  t^(-9/2));
      t4m_Bupper  (p8_B  t0  (S4Strip.n4  t0)  <=  9e-5  *
      t^(-2),  three  termwise  pins  against  the  n  >=  3.1e7
      *  t^4  floor);  t4m_margin  [G-hs3-iii:  p8_B  +
      MwireOff  <  S1LowT.floStripMin  on  the  band  -  corner
      9e-5  +  2.5e-15  *  t^(-5/2)  <  F4];  t4m_Bmono  (p8_B
      t  n  <=  p8_B  t  m  for  m  <=  n  -  schedule
      comparison);  t4m_resid_strip  [terminal,  P8Floor-A5
      shape:  triangle  +  t4m_margin,  under  hW  (the  lifted
      T4  wall)  and  hK  (K  -  (P_n  -  I_n)(s)  under  the
      lifted  M-wire)].  CONSEQUENCE:  on  the  strip  band
      above  the  frontier,  the  endpoint  hs3  leg  reduces  (via
      T4OffD  +  t4m_Bmono  for  hW,  t4m_resid_strip  for  hK)
      to  ONE  cited  convexity  mass  -  hs3  becomes  body-
      provable  above  the  frontier  and  drops  out  of  the
      RHEnd  stripfront  premises  in  the  next  step.  No  RH
      claim:  the  only  non-machine  input  is  a  CITED
      classical  convexity  bound;  every  machine  part  is
      checked  on  a  concrete  band.  Full  tree  green  (17450
      jobs),  0  sorry,  102  cards.


  FORMAL:  G-hs3  MACHINED  AT  THE  ENDPOINT  (discovery
      0119):  the  splice  0118  predicted  now  exists  in
      RHEnd.lean  part  B7  (1037  lines,  0  sorry,  GATED,
      full  tree  green):  the  theorem
      rh_program78_stripfront_mach  (and  its  [Z-PT2]
      instance  rh_program78_stripfront_mach_PT2)  calls  the
      regime  closure  with  the  lifted  wire
      Mr  :=  MrLift  =  t4m_MwireOff  on  the  strip  band,
      S4A.MrR  elsewhere.  The  named  hs3  face  is  now
      the  LIFTED-wire  statement:  over  the  strip  band  above
      the  frontier,  Qside  <=  ||p4_em_expr  (t4o_sOff  t0
      d0)  (n4  t0)||  +  t4m_MwireOff  t0  d0  -  the  off-line
      EM  wall  plus  the  off-line  lifted  M-wire,  whose  only
      non-machine  content  is  the  CITED  1.6  convexity
      mass.  Both  machine  steps  of  that  face  are  IN
      BODY  at  the  endpoint:  the  wall  side  by
      t4wall_offline_le_bwires  (0117)  and  the  floor  side
      by  t4m_margin  (0118)  -  so  the  S3  leg  AND  the
      S4  strip  leg  of  the  stripfront  endpoint  above  the
      frontier  are  body-proven  from  the  machined  face.
      The  named  residual  of  the  stripfront  endpoint  is
      exactly  G-hs1  (S1  scale  face,  open),  the  window
      zero-exclusion  face  (open),  and  the  machined  hs3
      face  (cited-content,  not  an  analytic  barrier  in
      the  tree);  all  strictly  above  3,000,175,332,800.
      t4m_Bmono  additionally  lets  the  witness  level  run
      the  wall  on  any  smaller  admissible  schedule.
      No  RH  claim.  Full  tree  green  (17450  jobs),
      0  sorry,  102  cards.


  FORMAL:  G-hs1  RESTATED  AS  THE  PIN  FAMILY  (discovery
      0120):  RHEnd.lean  part  B8  (1190  lines,  0  sorry,
      GATED,  full  tree  green):  the  theorem
      rh_program78_stripfront_mach_s1pins  (and  its  _PT2
      instance)  replaces  the  G-hs1  scale  face  of  the
      machined  stripfront  endpoint  with  the  B2  PIN
      FAMILY  restricted  to  strip-band  witness  zeros:
      P1  fill  (Qside  =  |zeta  rho  -  Kfun  rho|),  P2
      kernel  magnitude  (devFacePt  <=  |W_n|),  P3  the
      A4.3  mass,  P4  absorption;  the  face  is  derived  in
      body  via  S1Face.hs1AtZero  (the  B2  derivation,
      restricted).  CONSEQUENCE:  the  machined  stripfront
      endpoint  at  tPT2  has  NO  analytic  face  left  -  its
      residual  is  (i)  the  P1-P4  pin  family  at  strip-
      band  witness  zeros  (data  faces,  measurable  by  the
      E1ClauseV3  /  S1Face  machinery  where  records  reach),
      (ii)  the  window  zero-exclusion  face  (the  NEXT
      classical  zero-free  record  to  cite  or  produce
      above  3,000,175,332,800),  and  (iii)  the  machined
      hs3  face  (the  per-witness  CITED  1.6  convexity
      evaluation).  What  the  program  now  needs  is  data
      and  records  above  the  verified  frontier,  not  new
      analytic  machinery  in  the  tree.  No  RH  claim.
      Full  tree  green  (17450  jobs),  0  sorry,  102
      cards.


  FORMAL:  G-hs3-left  -  THE  FLANK  ASYMMETRY  AT  THE
      MACHINE  (discovery  0121):  T4OffL.lean  (619  lines,
      0  sorry,  GATED,  full  tree  green  17450  jobs).
      CORRECTION  to  the  0119/0120  all-flanks  wording:
      the  G-hs3  closure  (0116-0120,  T4OffD/T4OffM)  lives
      at  the  canonical  point  t4o_sOff  =  (1/2  +  d0)  +
      i*t  -  i.e.  it  covers  sigma  =  Re  s  >=  1/2  ONLY.
      The  raw  EM  tail's  first  T4  term  (1/2)*n^{-sigma}
      decays  in  n  only  at  rate  sigma;  at  the  LEFT
      FLANK  (sigma  =  1/2  -  d0  <  1/2)  the  tree's
      uniform  n^4  schedule  cannot  close  the  S3  wire,
      and  T4OffL  records  this  AS  A  FORMAL  BARRIER
      (exact  rational  pins,  zero  numerics):  (1)  BAND
      EDGE  d0  =  1/200  (sigma  =  99/200):  for  t  >=
      10^10  the  first  T4  term  at  the  n4  schedule
      STRICTLY  EXCEEDS  the  endpoint  floor  (crossing
      threshold  t  >  (15750/9999)^50  ~=  7.33e9;  frontier
      margin  ~13%;  t4l_barrier_edge,  instantiated  at  tPT2
      in  t4l_barrier_edge_PT2);  (2)  SIGMA  =  0  (d0  =
      1/2):  the  first  T4  term  is  identically  1/2  at
      EVERY  schedule  n  and  never  falls  below  the
      floor  -  no  schedule  can  close  the  wire  there
      (t4l_barrier_sigma0);  (3)  NO  schedule  uniform  in
      d0  over  the  band  covers  it,  and  d0  =  1/2  is
      unreachable  at  every  schedule  (per-point  closure
      at  fixed  d0  <  1/2  needs  a  left-tuned  schedule
      with  a  large  exponent).  CONSEQUENCE:  the  endpoint
      residual  at  tPT2  is  again  FOUR  named  faces  -  the
      P1-P4  pin  family  (data),  the  window  zero-exclusion
      (record),  the  machined  hs3  (machine-verified  at
      the  RIGHT-FLANK  witness;  cited  1.6  mass)  -  plus
      G-hs3-left:  the  S3  face  at  a  LEFT-FLANK  witness
      is  ANALYTIC  CONTENT  in  the  original  sense,  not  a
      data  or  citation  item.  The  barriers  are  formal
      negative  results  about  the  machine  wire;  they  say
      nothing  about  whether  left-flank  zeros  exist.  No
      RH  claim.  Full  tree  green  (17450  jobs),  0
      sorry.


  FORMAL:  G-hs3-left  AT  THE  ENDPOINT  -  THE  HS3  FACE
      SPLIT  BY  FLANK  (discovery  0122):  RHEnd.lean  part
      B9  (1505  lines,  0  sorry,  GATED,  full  tree  green
      17450  jobs)  states  the  machined  stripfront  endpoint
      with  the  hs3  face  split  by  the  FLANK  of  the  off-
      pair  witness  -  the  off-pair  (t0,  d0)  records  no
      flank,  and  t4l_flankSplit  gives  the  split  (an
      off-pair  with  d0  !=  0  is  a  right-flank  off-pair
      (re  =  1/2  +  d0)  or  a  left-flank  off-pair  (re  =
      1/2  -  d0),  pinned  by  the  |.|-shape  of  the  pair).
      rh_program78_stripfront_mach_left  (+  _PT2  at  the
      Platt-Trudgian  frontier):  the  endpoint  holds  from
      (i)  G-hs1  (open,  as  before),  (ii)  the  window  zero-
      exclusion  face  (open,  as  before),  (iii)  hs3  at  a
      RIGHT-FLANK  witness  in  the  machine-closable  B7
      shape  (off-line  EM  wall  at  t4o_sOff,  n4  schedule
      +  lifted  M-wire;  T4OffD  closes  the  S3  leg  IN
      BODY),  and  (iv)  G-hs3-left:  hs3  at  a  LEFT-FLANK
      witness  stated  at  PAIR  LEVEL  (Qside  <=  Bwire  +
      Mr)  -  the  named  analytic  face.  t4l_rightFaceOfSingle
      records  that  the  B7  single-face  premise  restricts  to
      the  right-flank  face  (the  split  endpoint  asks  no  more
      of  the  right  flank  than  B7  did);  the  S4  (floor)
      side  is  FLANK-INDEPENDENT  (t4m_margin)  -  only  the
      S3  (wire)  side  carries  the  flank.  CONSEQUENCE:  the
      endpoint  residual  in  THE  MACHINE  is  now  exactly
      the  four-face  ledger  of  0121  -  machine/ledger
      lockstep.  The  two  remaining  0121  candidates  attach
      to  this  theorem:  (1)  squeeze  G-hs3-left  at  the
      MEASURED  left-flank  zeros  below/around  the  frontier
      (shrinking  the  analytic  face  to  a  named  height
      band,  hWin-pattern);  (2)  a  left-tuned  schedule
      family  (the  barrier's  contrapositive  as  a  construction)
      would  DISCHARGE  the  face  in  body.  No  RH  claim.

  FORMAL:  THE  LEFT-TUNED  SCHEDULE  FAMILY,  IN  THE  MACHINE
      (discovery  0123):  T4OffL.lean  section  S7  (919  lines,
      0  sorry,  GATED,  full  tree  green  17450  jobs)  is  the
      POSITIVE  DUAL  of  the  S4  barriers  -  the  barrier's
      contrapositive  as  a  construction.  (1)  t4l_schedA
      (sigma)  =  (9999/2)^{1/sigma}  -  the  critical  scale
      constant:  at  B  =  A(sigma)*t^{2/sigma}  the  first  T4
      term  computes  (1/2)*B^{-sigma}  =  (1/9999)*t^{-2}  -
      EXACTLY  the  edge-floor  scale  target.  (2)  t4l_schedA_
      pos:  positive  for  every  sigma  >  0.  (3)  t4l_sched
      Term1:  at  t  >=  1000,  sigma  >  0,  EVERY  schedule  n
      at  or  above  the  critical  scale  puts  the  first  T4
      term  at  or  below  the  floor  scale  (identity  chain,
      no  numeric  pins).  (4)  t4l_schedBeat4:  at  t  =  10^10
      and  the  band  edge  sigma  =  99/200  the  critical  scale
      STRICTLY  EXCEEDS  the  uniform  machine  schedule  n4  -
      the  barrier  restated  as  a  schedule  comparison,  pinned
      to  a  norm_num  99th  power  ((9999/2)^200*10^40  >
      62000000^99).  (5)  t4l_schedDiverge:  for  EVERY  A  >  0
      some  d0  in  [1/200,  1/2)  needs  A(1/2-d0)  >  A  -  the
      tuned  constant  is  UNBOUNDED  as  d0  ->  1/2;  NO  d0-
      uniform  schedule  exists.  CONSEQUENCE:  G-hs3-left  is
      not  'the  wire  is  too  weak'  but  'the  wire  is  the
      wrong  KIND'  -  the  obligation  is  per-point,  and  the
      per-point  schedule  is  now  EXPLICIT  in  the  machine.
      The  analytic  residue  is  unchanged  and  honest:  that
      the  FULL  S3  squeeze  (not  just  the  first  T4  term)
      holds  at  the  tuned  schedule  at  the  left-flank
      witness.  No  RH  claim.witness.  No  RH  claim.

  VERDICT:  THE  DATA  SQUEEZE  DEGENERATES  -  THE  FACE  IS
      DATA-MINIMAL  (discovery  0124):  candidate  (1)  of  0122/
      0123  closes  as  a  dead  branch,  evidenced  in  three
      independent  routes.  (1)  MECHANISM:  the  in-tree  zero
      finders  operate  ON  THE  CRITICAL  LINE  (Riemann-Siegel
      /  Platt  record);  the  Platt  .pd  format  stores  per-
      zero  104-bit  STEPS  for  the  t-coordinate  ONLY  -  no
      measured  real  part  of  a  zero  exists  anywhere  in
      the  program's  data.  (2)  ROW  FORMAT:  the  21-column
      fleet  rows  are  CHANNEL/MARGIN  values  at  TRIAL  points
      (x,  t,  g,  k)  -  the  Re-looking  fields  are  mnew/
      mcert  margins,  not  coordinates.  (3)  GEOMETRY:  in
      rh_program78_stripfront_mach_left_PT2  the  face  hs3Left-
      PT2  is  STATED  on  t0  >=  WinC.tPT2  -  below  it  the
      cited  record  premise  (allOnLineUpTo  q  tPT2)  elimi-
      nates  off-pairs  from  the  face's  domain;  above  it  no
      measured  data  exists.  The  face's  support  is  EXACTLY
      the  unverified  territory:  nothing  below  can  be
      squeezed  (the  face  is  not  there)  and  the  audit
      against  measured  left-flank  zeros  is  VACUOUS  (there
      are  none,  by  mechanism  and  by  record).  Structural
      lesson:  with  the  endpoint  stated  AT  the  verified
      frontier,  every  analytic  face  is  automatically  data-
      minimal  -  the  squeeze  pattern  (0106/0108)  only  works
      when  a  face  extends  BELOW  a  higher  verified  height.
      Live  routes  for  G-hs3-left:  (A)  ANALYTIC  -  the  full
      S3  squeeze  at  S7's  explicit  tuned  schedule  (left-
      flank  S3  tail  theory;  the  true  residual);  (B)
      MEASURED  SHADOW  (evidence  only)  -  a  numerical  grid
      of  the  walk-vs-BwireP+MrLift  inequality  at  LEFT-
      FLANK  trial  points  at  or  below  3e12  against  the
      actual  zeros:  a  clean  shadow  is  encouragement  for
      (A),  a  violation  is  a  discovery  (the  shape  of  the
      squeeze  failing  at  trial  points).  (C)  frontier
      extension  is  external  record-keeping.  No  RH  claim.

  FORMAL:  THE  LEFT-FLANK  S3  WALL,  IN  THE  MACHINE,  AT
      THE  SQUARE-ROOT  SCHEDULE  (discovery  0125):  T4OffL.
      lean  section  S8  (1738  lines,  0  sorry,  GATED,  full
      tree  green  17450  jobs)  discharges  the  S3  LEFT  LEG
      of  G-hs3-left  IN  BODY,  at  the  schedule  the  barrier
      computation  forces.  (1)  t4l_schedB  (t,  sigma)  =
      (n4  t)^{1/(2  sigma)}  -  the  square-root  schedule:  at
      n  =  schedB  the  first  T4  term  computes  (1/2)*
      n^{-sigma}  =  (1/2)*(n4  t)^{-1/2}  -  EXACTLY  the  on-
      line  T1  scale  of  the  p8  floor;  t4l_sched_pow  is
      the  single  schedule  fact  (n  >=  schedB  and  a  >  0
      imply  n^a  >=  (n4  t)^{a/(2  sigma)}).  (2)  The  left-
      norm  win:  t4l_wall_norm1  (||sL||  <=  ||sOn||  on  the
      band)  and  t4l_wall_norm_prod  (the  triple  product
      sL(sL+1)(sL+2)  is  termwise  norm-smaller  than  the  on-
      line  product).  (3)  The  T3  coefficient  pins,  exact
      99th-power  norm_num:  t4l_T3pin  (3.1e7^{2/99}  >=
      500/499),  t4l_T3pin2  (3.1e7^{2/99}  >=  10/9),  and
      t4l_T3margin:  (n4  t)^{(1-2sigma)/sigma}  >=  5/(2
      (sigma+2))  for  sigma  <=  99/200  -  the  one  power
      margin  that  absorbs  the  216-vs-540  constant  ratio
      (split  at  sigma  =  1/4:  the  pin2  route  vs  the  n4-
      square  route).  (4)  THE  MAIN  LEFT  WALL  t4l_wall_
      tuned:  for  t  >=  1000,  1/200  <=  d0  <  1/2,  EVERY
      n  at  or  above  t4l_schedB  t  (1/2  -  d0):
      ||p4_em_expr  (t4l_sOffL  t  d0)  n||  <=  p8_B  t  (n4
      t)  -  the  mirror,  on  the  left  flank,  of
      t4wall_offline_le_bwires  (T4OffD).  (5)  The  endpoint-
      face  composition  t4l_face_left_body  (the  same
      witnesses  satisfy  ||p4_em_expr(sL)  n||  <=
      S4A.BwireR  t  d0  +  t4m_MwireOff  t  d0,  via  the
      band  identity  BwireR  =  p8_B  t  (n4  t))  and
      t4l_face_left_band  (for  EVERY  band  off-pair  at  t0
      >=  10^10,  n  =  ceil(schedB)  witnesses  the  wall).
      Pre-checked  in  tmp/s35b_leftflank_precheck.py  (dps50
      mpmath  detector  port,  right-wall  gate  clean  0.7990):
      at  the  square-root  schedule  the  max  termwise  ratio
      against  p8_B(t,  n4(t))  is  1.0000  on  the  survey
      grid  (T1  matches  by  construction,  T2/T3  strict
      below);  the  T3  pin  worst  log10  margin  0.3929  (~2.47x).
      The  d0  =  1/2  slice  (sigma  =  0)  stays  the  0121
      barrier  -  the  schedule  diverges  there,  excluded  by
      d0  <  1/2.  CORRECTION  OF  STATUS  after  the  pre-
      check:  the  G-hs3-left  face  does  NOT  dissolve  into
      one  body  theorem  -  the  S3  left  leg  is  machinable
      (0125)  but  the  S1  leg  is  not  closed  by  the  tuned-
      tail  Qside:  devProg  (t,  d0)  /  (p8_B  (t,  n4)  +
      MrLift  (t,  d0))  >=  1.11  at  the  band  edge  d0  =
      1/200,  growing  to  ~1.1e4  by  d0  =  1/2  -  numerically
      the  band  squeeze  window  is  EMPTY  (no  Qside  can
      satisfy  S1  and  S3  jointly  at  a  band  off-pair
      under  the  endpoint's  concrete  definitions).  The
      residual  is  the  S9  question:  formal  band-emptiness
      above  the  frontier  (and  the  role  of  the  P1-P4  pin
      family  if  the  window  is  empty  -  B6  cross-check
      pending).  No  RH  claim.






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
