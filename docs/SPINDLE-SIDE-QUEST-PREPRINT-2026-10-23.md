#  THE  EULER  SPINDLE  GAME

A  frozen  discrete  structure  over  the  primes,  and  five
passes  at  reading  it

Side-quest  preprint,  2026-10-23.  Construction:  the  prime
branching  lattice  of  IDEA-SEED-PRIME-LATTICE  (2026-10-22);
the  spindle  game  (pass  1,  F14);  all  five  passes  executed
2026-10-22/23  at  X  =  2e6  and  X  =  1e8.  Companion  docs:
PRIME-LATTICE-EXPLORATION,  -CHIMES,  PRIME-BLOOM-PASS3,
SPINDLE-NS-FEASIBILITY,  SPINDLE-EXECUTION-PLAN  (running  log),
SPINDLE-VARIATIONAL-PASS5,  PRIME-LATTICE-SIDE-QUEST-REPORT
(the  tally).  NS  material  is  a  STRUCTURAL  BOUNDING
TEMPLATE,  not  an  established  theorem  (T6  audit,  section
5).  NO  RH  CLAIM  IN  ANY  DIRECTION,  ANYWHERE  IN  THIS
PREPRINT.

##  1.  The  construction  (frozen)

A  SPINDLE  is  a  pair  (p,  d)  where  p  is  prime,  d  is  even,
2  ≤  d  ≤  D  (D  =  2000),  and  p  −  d  and  p  − 2d  are
both  prime.  The  three  primes  p  − 2d,  p  − d,  p  form  a
3-term  arithmetic  progression  (3-AP)  of  common  difference
d;  d  is  the  chord  of  the  spindle  at  height  p.

Attached  to  each  spindle:

  *  AREA  A(p,  d)  =  |(p  − 5d)(p  − 2d)|  —  the  product  of
     the  two  template  factors.  (The  NS  bounding  template
     places  the  "action"  zero  at  d  =  p/5  and  the  chord-end
     zero  at  d  =  p/2;  the  form  is  OURS;  see  section  5.)
  *  THREADS  S(p,  d)  =  prod_{q | (p − 2d)(p − d)}  q^{v_q(p−1)}-style
     product  —  the  cost  of  the  spindle's  threads  (gcd-
     structure  of  p  − 1  against  the  chord  endpoints).
  *  PHANTOM  FLUX  —  the  per-chord  divisor-density  residual
     of  the  endpoints  against  the  ln  model.

The  CHORD  STRUCTURE  of  p  is  its  valid  chord  set  {d}.
The  spindle  game  at  scale  X  is  the  set  of  all  spindles
with  p  ≤  X.

Counting  (F1,  theorem-grade):  valid  chords  are  exactly  the
even  d  whose  two  death  congruences  (d  ≡  p,  d  ≡  2p  mod  q,
q  |  3d)  survive;  the  count  is  congruence  arithmetic  with
a  3/4  mod-3  screening  core.  Total  budget  B(X)  (sum  of
endpoint  divisor  flux)  is  EXACTLY  computable  and  equals
the  ln  model  to  0.25%  at  2e6  (F2)  and  0.25%  of  1e8  at
1e8  (B(1e8)  =  1,862,122,325;  T5).

Scale  facts  (measured):  at  2e6,  148,933  primes  carry  at
least  one  chord  (148,928  =  99.997%);  2,204,797  spindles.
At  1e8:  5,718,108  primes,  50,630,458  spindles,  mean  8.9
chords  per  prime  =  ln(1e8)  class.  Structure  is  UNIVERSAL
at  both  scales  (primes  and  random-odd  null  alike:  100%
nonempty  chord  sets).

##  2.  The  theorem-grade  results

W1  (F1,  chord  census).  The  valid  chord  count  c(p)  =  |{
d  even,  2  ≤  d  ≤  D,  p − d,  p − 2d  prime  }|  is  determined
by  the  sieve  residue  classes  of  p;  no  two  primes  in  a
fixed  residue  class  mod  M  (M  the  3·5·7  wheel)  differ  in
mean  chord  count  beyond  the  classical  congruence  terms.

W2  (F2,  exact  budget).  B(X)  =  Σ_{spindles}  flux  is
computed  exactly  at  2e6  (29,326,240)  and  1e8  (1,862,122,325)
and  tracks  the  ln  model  within  0.25%;  the  T5  conservation
(lagged  ln-detrended  drift  +0.31%)  certifies  B  as  a
CONSERVED  flow  of  the  game.

W3  (F11,  wheel  triangle).  The  wheel-triangle  theorem:
within  the  3·5·7  wheel  residue  system,  the  3-AP  spine
(p − 2d,  p − d,  p)  of  every  spindle  projects  to  one  of
the  finitely  many  wheel  triangles;  the  census  of  triads
(2,204,797  at  2e6;  50,630,458  at  1e8)  is  exact  against
the  wheel  count.

W4  (F15-T2  +  T7c,  finite  corner).  The  set  C  =  {
(p,  d)  :  A(p,d)/S(p,d)  <  100  }  is  FINITE  and  SCALE-FROZEN:
exactly  14  members  at  both  2e6  and  1e8,  all  p  ≤  4201,
minimum  A/S  =  8.5  at  (29,  d  =  6).  Every  member  of  C
satisfies  |p  − 5d|  =  1  —  p  ≡  1  or  4  (mod  10)  with
d  =  (p  ∓  1)/5,  the  chord  placed  exactly  at  the
template  zero  d  =  p/5,  achieving  the  per-p  minimum  area
A  =  1  ·  (p  − 2d).  Top  example:  4201,  d  =  840,
r  =  d/p  =  0.2000  EXACT,  A  =  2521  =  1  ·  2521.

##  3.  The  measured  results  (five  passes)

Pass  1  (F14,  2e6):  feasibility  +  construction.  Pass  2  (F15,
1e8,  4  sub-readings):

  T1   parity  decomposition:  post-parity  prime/null  ratio
       1.262  (16.97  vs  13.44  mean  chords  per  p);  the
       headline  1.884  is  NOT  pure  parity  —  a  genuine
       +26%  prime-side  excess.
  T1r  4-adic  refinement:  the  excess  is  VALUATION  UNIFORM
       (1.27718  /  1.27742  /  1.27431  /  1.26891  /  1.26426
       over  v_2  =  1. . .  5)  —  a  constant  prime-side
       factor  ≈ 1.27,  not  2-adic  structure.
  T2   closure  tightness:  C  finite  (W4);  min  A/S  frozen
       at  8.5;  the  enclosure  is  uniformly  lax  above
       height  ≈  7000.
  T3   vortex  search:  class  means  [1.0967,  0.9273,  1.0468,
       0.9328]  structural;  layer  σ  =  0.221%,  max  deviation
       0.986%,  2  /  400  flags  —  NO  VORTEX.
  T4   spindle  dynamics:  flat  deciles  (3.799–3.808),  height
       slope  0.00021,  top-1%  elongation  0.999  ×  —  NO
       DYNAMICS.
  T5   phantom  flow  conservation:  B  conserved  (W2);  the  only
       systematic  deviation  is  low-height  asymptotic
       convergence  (layers  0–4  at  +12.9%,  +0.04%  at  the
       top).

Pass  3  (F13,  the  bloom):  the  Euler  primal  bloom  measure
is  POSITIVE  —  the  p/5  zero  line  carries  r  =  0.2508  of
the  chord  mass  one  class  above  the  congruence  baseline;
the  only  positive  "organization"  signal  found  in  five
passes.

Pass  4  (T6,  NS  provenance):  primary-source  audit  of  the
NS  /  Euler  Lean  landscape  (section  5).

Pass  5  (F16,  the  variational  reading,  the  owner  variant
"do  the  primes  compete  to  minimize  the  action  and  predict
the  next  gap?"):

  T7a  null  selection:  chord  richness  ratio  prime/null  =
       14.804  /  19.812  =  0.7472  vs  the  mod-3  prediction
       of  EXACTLY  3/4  (0.75);  per-chord  area  ratio  0.541;
       per-chord  1/S  ratio  0.849.  All  congruence  arithmetic
       of  p  itself  (for  prime  p,  both  death  classes
       d  ≡  p,  d  ≡  2p  (mod  3)  kill  2/3  of  the  even
       chords;  random  odd  m  averages  4/9  survival).
  T7c  the  corner  (W4)  is  exactly  the  area-minimizing
       family  —  "the  winners  are  the  minimizers"  holds
       literally,  and  the  winner  set  is  the  congruence
       classes  p  ≡  1,  4  (mod  5)  in  the  chord  range:
       selection  as  arithmetic,  not  as  choice.
  T7d  the  phantom  transient  (density  "reliability")  decays
       29.1%  →  11.7%  over  100  height  layers,  fast  at
       first,  persistent  floor  =  the  documented  ln-model
       gap  —  mild  maturation  at  the  density  level  only.
  T7e  gap  prediction:  the  game's  event  sequence  IS  the
       prime  sequence  (99.997%  pass-through):
             lag-1  log-gap  autcorr
             spindle  primes   −0.0658  (−25σ,  n  =  148,928)
             ALL  primes       −0.0657  (3-digit  identical)
             random-odd  null  −0.0003
             ALL  primes  1e8  −0.0482  (−115σ,  n  = 5,761,455)
       Fano  11.8294  (spindle)  vs  11.8807  (all  primes);
       the  next-gap  median  vs  local  rate  decile  curve  is
       the  trivial  local  prime-density  effect  (12  12  12
       12  10  10  10  10  10  8  at  2e6;  14…14  12…12  at
       1e8  over  a  1e6  window).  The  only  predictability  in
       the  system  is  the  primes'  own  gap  ALTERNATION  (after
       a  small  gap  a  larger  one  is  likelier  —  the
       anti-burst  /  twin-bias  direction),  inherited  verbatim,
       scale-stable  with  ≈ 1/ln  x  decay.

##  4.  Verdict

CLOSED-FLAT  (passes  1–4:  the  enclosure  is  uniformly  slack,
no  vortex,  no  dynamics,  no  growing  blowup  family)  and
CLOSED-NEUTRAL  (pass  5:  no  active  optimization  or  gap
prediction  beyond  the  primes'  own  alternation).  The  F15
flatness  has  its  variational  explanation:  the  structure  has
NO  DEGREE  OF  FREEDOM  LEFT  TO  MOVE  —  every  spindle  is
present,  the  game  is  fully  determined  by  the  primes  that
built  it,  and  they  are  themselves  only  weakly
self-predicting.  Read  that  way,  the  "NS  game"  is  at  the
minimum  of  every  functional  in  the  family  by  vacuity:
nothing  competes  with  anything,  because  nothing  is
ever  chosen.  The  one  place  the  question  still  has  teeth
is  a  construction  with  actual  choices  (spindles  over  chime
branches)  —  parked,  section  7.

##  5.  Posture  and  honesty

NS  provenance  (T6,  primary-source  level,  2026-10-23):
the  OpenAI  announcement  (2026-09-08)  claims  forced  NS  C+D
at  every  viscosity  plus  an  UNFORCED  Euler  FTS;  the  Lean
repository  (openai/NavierStokesAndEuler,  Lean  4.34.0-rc2  +
Mathlib)  is  public  and  was  cloned  and  inspected;  the
Buckmaster  statement  (Cordoba  &  Martinez-Zorua  B–A  origin)
was  read  in  full;  public  papers  located  (Kosulsuz  SMCD261007
class);  the  lean4.dev  note  (2026-09-09)  says  "independent
assessment  ongoing";  the  CMI  announcement  was  PULLED  after
a  priority  dispute  (Sep  3  email,  Sep  6  calls,  both
authorship  offers  declined);  first  LLM  Lean-verified  proof
dated  2026-08-22.  No  CMI  certification  exists.  No  unforced
viscous  3D-NS  result  —  either  the  way.  The  NS  /  Euler
Lean  claims  are  therefore  treated  as  UNVERIFIED,  and  the
NS  material  in  this  preprint  serves  only  as  a  STRUCTURAL
BOUNDING  TEMPLATE  for  the  shape  of  A(p,  d).  The  A  form
(itself  —  the  p/5  and  p/2  zeros,  the  7p/20  maximum)  is
OUR  CONSTRUCTION;  W4  is  a  statement  about  that  construction,
not  an  independent  natural  selection  of  the  mod-5  family
by  anything  NS-like.

No  RH  claim:  the  spindle  game  is  a  self-contained  discrete
object  over  the  primes;  its  theorems  (W1–W4)  are  about
the  game;  nothing  here  is  a  zero-exclusion,  a  margin,  or
a  proof  in  any  direction  of  a  RH  statement.

##  6.  Reproducibility

All  probes  are  vectorized,  single-session,  and  reproducible
from  a  fresh  sieve:

  tmp/sx1a_prime_lattice.py     construction  +  triads  (F1–F8)
  tmp/sx1c2_triangles.py        wheel  triangles  (F11)
  tmp/sx2_chimes.py             chime  branches  (F9)
  tmp/sx3_bloom.py              bloom  measure  (F10–F13)
  tmp/sx4_spindle.py            2e6  passes  (F14,  T1)
  tmp/sx5_scale1e8.py           1e8  passes  (F15,  T1r–T5)  233 s
  tmp/sx6_variational.py        2e6  variational  (F16,  T7a–e)  4.6 s
  1e8  prime-gap  control       inline,  0.5 s
  +  each  *_stats.json  +  *_run.log  beside  it.

Seeds:  null  samples  fixed  (20261023).  Runtime  total,  all
five  passes:  ≈  6  minutes  of  CPU  on  this  box.

##  7.  Keep  /  park

KEEP:  W1,  W2,  W3,  W4  (theorem-grade);  F13  (the  one
positive  organization  measure  in  the  family);  T7c  as  the
standalone  fact  "the  minimum-A/S  spindles  are  the  |p  − 5d|
=  1  family,  p  ≡  1,  4  (mod  5)";  the  audit  protocol  of
pass  5  (null  +  no-filter  control  +  lag  +  predictability
curve  before  any  "optimization"  claim  is  allowed).

PARK:  chime-branch  spindles  (the  one  face  where  the  "game"
would  have  real  choices  —  a  new  seed  doc  for  another
session,  if  the  owner  wants  it).  No  further  scale-up  of
the  frozen  construction:  W4  is  proven  finite  and  the  ratios
are  congruence-law,  so  1e9  would  change  nothing.

The  book  closes  at  F16.
