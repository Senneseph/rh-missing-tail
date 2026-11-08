import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3
import RhAttack.CE4
import RhAttack.CE5
import RhAttack.CE6
import RhAttack.CE7
import RhAttack.CE8
import RhAttack.CE9
import RhAttack.CE10
import RhAttack.CE11
import RhAttack.CE12
import RhAttack.CE13
import RhAttack.CE14
import RhAttack.CE15
import RhAttack.CE16
import RhAttack.CE17
import RhAttack.CE18
import RhAttack.CE19
import RhAttack.CE20
import RhAttack.CE21
import RhAttack.CE22
import RhAttack.CE23
import RhAttack.CE24
import RhAttack.CE25
import RhAttack.CE26
import RhAttack.CE27
import RhAttack.CE28
import RhAttack.CE29
import RhAttack.CE30
import RhAttack.CE31
import RhAttack.CE32
import RhAttack.CE33
import RhAttack.CE34
import RhAttack.CE35
import RhAttack.CE36
import RhAttack.CE37
import RhAttack.CE38
import RhAttack.CE39
import RhAttack.CE40
import RhAttack.CE41
import RhAttack.CE42
import RhAttack.CE42B
import RhAttack.CE43
import RhAttack.CE44
import RhAttack.CE45
import RhAttack.CE46
import RhAttack.CE47
import RhAttack.CE48
import RhAttack.CE49
import RhAttack.CE50

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48 CE49 CE50
open scoped Topology

/-!
**CE51 — the terminal  face  re-anchored  at  the
FIFTY-FIRST  certified  window  (0357,  option  B,
unit  70  —  lane  M5).  SNAPPED  WINDOW:  the
requested  final  b  =  12 363 154 477 119  was  not
a  good  Gram  point  at  working  precision,  so  the
pipeline  snapped  it  DOWN  by  1  to  b  =
12 363 154 477 118  (width  b  −  a  =  19 999)  -
the  first  snapped  window  since  window  40
(width  19 998);  the  snapped-width  family  is  now
2,  3,  8,  11,  17,  18,  19,  21,  31,  40,  51.
ONE  ROSSER-BLOCK  EXCEPTION  INSIDE,  RESCUED,
QUOTA-MET,  and  RECORDED  (not  suppressed):
block  [12 363 154 473 629,  12 363 154 473 632]
(need  3,  found  1,  193  points,  m  =  64)
was  rescued  by  the  union  interval  [
12 363 154 473 628,  12 363 154 473 633]
(need  5,  FOUND  5,  m  =  4)  -  the  first
internal  exception  since  window  45  (the
double-rescue);  the  five-consecutive-clean
streak  (w46  —  w50)  ends  here.  The  independent
verifier  RECOMPUTES  the  WINDOW  TOTAL
(sign_changes_inside  =  19 999  =  b  −  a)  and
the  two  end  Rosser  runs  (49  /  47)  -  the
only  quantities  that  enter  the  Turing  step;
the  rescued  block  does  not  affect  either.
Frontier:  242 988  units  above  H0  (the
225 000-unit  crossing  of  CE48  carried,
proven  here  as  frontierPast225k  at  the
new  frontier);  the  next  round  mark,
250 000,  now  sits  7 012  ahead  -  at
the  ~4 673/window  pace  the  crossing  is
expected  in  window  53  (7 012  −  ~4 673
=  ~2 339  left  after  w52;  the  next
~4 673  carries  it).  Cumulative  certified
count  =  1 039 988  over  (g_a1,  g_b51]
(1 019 989  at  w50's  end  +  19 999  -
the  snap  cost  one  count  unit;
the  1 000 000 mark  [w50]  is  carried).
Corrected  chain  continues:  w42  →  w42b
→  w43  →  w44  →  w45  →  w46  →  w47
→  w48  →  w49  →  w50  →  w51,  every
seam  bit-identical  (window  51  launched
from  b50  correctly;  the  seam  audit
passed  bit-identically  BEFORE  this
module  was  written).  NO  RH  CLAIM.  -/

/- PROVENANCE  (our  run,  2026-11-08;  pipeline  =
Murphy's  Apache-2.0  deposit,  same  as  CE1-CE50):
  RUN  PARAMETERS:  a  =  12 363 154 457 119
  (=  b50,  window  50's  final  b  -  launched
  correctly  from  the  chain  frontier,  per
  the  0348  process  rule),  b  requested  =
  a  +  20 000  =  12 363 154 477 119,  b  ACTUAL
  =  12 363 154 477 118  (SNAPPED  DOWN  by
  1  -  final  endpoint  not  a  good  Gram
  point  at  working  precision;  a  remains
  good,  no  snap),  M  =  60,  C_R  = 1,  28
  workers,  33 636  evaluations,  2532.2  s.
  CERTIFICATE  (window51_b51.json):  the
  b  −  a  =  19 999  zeros  of  ζ  with  g_a51
  <  Im  s  <=  g_b51  are  ALL  SIMPLE  and
  on  the  line,  where
      g_a51  (recorded  exact  dyadic  ball,
      this  run's  a)  =  116063670761562604479645262733743461387  x
      2^-85,  radius  16777217  x  2^-110
      (i.e.  3 000 175 571 115.696289062500
      + or -  1.29e-26),  and  this  ball  is
      BIT-IDENTICAL  to  CE50's  recorded
      g_b50  (exact  dyadic  tuple
      comparison,  2026-11-08)  -  the  seam
      audit  PASSED  BEFORE  this  module  was
      written  (the  0348  process  rule);
      g_b51  =  3 000 175 575 788.397949218750
      + or -  1.29e-26  (exact  dyadic  tuple
      as  recorded:  [116063670942328987203539826434559195545,  -85,
      16777217,  -110];  the  floor
      tCE51  sits  0.3979  above  the
      previous  integer  -  robust  to  the
      1.29e-26  radius  by  many  orders  of
      magnitude;  the  standard  two-decimal
      lower  bound  gB51Lo  has  a  margin
      of  ~6.0e-3;  the  two-decimal
      round-down  does  not  equal  the
      floor,  so  no  CASING  is  needed,
      window  38  /  CE38  remaining  the
      only  CASING  case  so  far).
      Turing  runs  of  consecutive  good
      Rosser  blocks:  49  left  of  g_a51,
      47  right  of  g_b51  (both  >=  K  =
      12);  0  cross-check  failures  (all
      33 636  records);  0  undetermined
      Gram  signs.
      INTERNAL  ROSSER-BLOCK  EXCEPTION
      (recorded,  not  suppressed):  ONE
      block  [12 363 154 473 629,
      12 363 154 473 632]  failed  the
      initial  quota  (need  3,  found  1,
      193  points,  m  =  64)  and  was
      RESCUED  by  the  union  interval
      [12 363 154 473 628,  12 363 154 473
      633]  (need  5,  FOUND  5,  m  =  4).
      The  independent  verifier
      RECOMPUTES  the  WINDOW  TOTAL  and
      the  two  end  Rosser  runs  -  the
      only  quantities  that  enter  the
      Turing  step;  the  exception  is
      recorded  in  this  header  and  in
      discovery  0357.
  VERIFICATION  (three  layers,  same  as
  CE2-CE50):
    (1)  ENVIRONMENT  REPEAT  (Murphy's
         window-1  certificate  re-verified
         -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on
         window51_b51.json:  "CERTIFIED:
         true",  points_checked  = 33 636,
         sign_changes_inside  =  19 999
         =  b  −  a,  roesser_failures_inside
         =  1  (the  recorded,  quota-met
         rescue  above),  turing_ok  =
         true,  K_conservative  = 12
         (K_required:  Trudgian  Cor2.3
         =  [5.71899  + or -  1.23e-6],
         doubled  =  [11.4380  + or -
         1.76e-5],  Amberger  Thm2.3  =
         [9.14967  + or -  4.14e-6]  -
         all  below  12),  endpoints
         recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the
         recorded  g_a51  ball  is
         bit-identical  to  CE50's
         recorded  g_b50  ball  (exact
         dyadic  decode,  2026-11-08;
         audit  performed  BEFORE  this
         module  was  written).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE51  =  3 000 175 575 788,
      tCE51  −  tCE50  =  4 673   (the
      20th  increment  -  the  4 673
      pace  after  the  one-shot  4
      672  break  at  w45->46;  no
      periodicity  assumed),
      tCE51  −  tPT2  = 242 988  (the
      225 000-unit  mark  [CE48]
      carried;  the  next  round  mark
      250 000  sits  7 012  ahead  -
      at  the  running  pace  the
      crossing  is  expected  in
      window  53),
  CERTIFIED  COUNT  (pipeline  data,
      machine-tracked  over  the  chain;
      the  snap  cost  one  unit):
      over  (g_a1,  g_b51]  =  1 019 989
      +  19 999  =  1 039 988  (the
      1 000 000 mark  [w50,  0356]  is
      carried);  counts  are  consumed
      as  citations,  not  re-derived
      in-tree.
  HONESTY  (trust  base):  as  CE2-CE50
  -  the  pipeline's  own  controls,  its
  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification
  layers;  a  RE-RUN  of  a  third-party
  pipeline,  not  a  from-scratch
  independent  certification.  The  Rosser
  rescue  is  RECORDED,  not  suppressed.
  NO  RH  CLAIM.  -/

namespace CE51


/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b51  (the
    recorded  ball  is  3 000 175 575
    788.397949218750  with  radius  ~=
    1.29e-26;  this  rational  rounds
    the  bottom  down  at  two
    decimals,  margin  ~6.0e-3;  the
    final  b  of  window  51  was
    SNAPPED  down  by  1  -  see  the
    header).  -/
def gB51Lo : ℚ := 300017557578839 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB51Lo:
    tCE51  =  3 000 175 575 788.  -/
def tCE51 : ℕ := 3000175575788

theorem tCE51_lt_gB51Lo : (tCE51 : ℝ) < (gB51Lo : ℝ) := by
  norm_num [gB51Lo, tCE51]

theorem tCE50_lt_tCE51 : (tCE50 : ℝ) < (tCE51 : ℝ) := by
  norm_num [CE50.tCE50, tCE51]

/-- Record:  the  seam  order  gB50Lo
    <
    tCE51
    (the
    band
    (gB50Lo,
    tCE51]
    is
    nonempty
    and
    lies
    above
    window
    50's
    frontier
    tCE50).
    -/
theorem gB50Lo_lt_tCE51 : (gB50Lo : ℝ) < (tCE51 : ℝ) := by
  norm_num [CE50.gB50Lo, tCE51]

/-- The  face  height  shrank
    by  a  FURTHER
    4 673
    units
    past
    tCE50:
    the
    4 673
    pace
    since
    the
    one-shot
    4 672
    break
    at
    w45  →  w46
    (the
    20th
    increment
    is
    4 673)
    -
    the
    Gram
    spacings
    wobble
    by
    units,
    not
    periodic;
    recorded
    honestly,
    no
    pattern
    assumed.
    -/
theorem faceShrinkCE51 : (tCE51 : ℝ) - (tCE50 : ℝ) = 4673 := by
  norm_num [tCE51, CE50.tCE50]

/-- THE  EXTENDED  GEAR  (machine):
    the
    new
    frontier
    stands
    242 988
    units
    above
    the
    Platt-Trudgian
    frontier
    H0
    (window
    51
    is
    SNAPPED,
    width
    19 999;
    the
    225 000-unit
    mark
    —
    crossed
    in
    window
    48,
    the
    CE48
    MILESTONE
    unit
    —
    is
    carried;
    the
    next
    round
    mark
    250 000
    now
    sits
    7 012
    ahead
    -
    at
    the
    ~4 673
    per-window
    pace
    the
    crossing
    is
    expected
    in
    window
    53;
    compute
    the
    floor
    when
    g_b53
    decodes,
    do
    not
    pre-announce).
    -/
theorem frontierGapAboveH0 : (tCE51 : ℝ) - WinC.tPT2 = 242988 := by
  norm_num [tCE51, WinC.tPT2]

/-- MILESTONE  CARRY
    (machine):
    tCE51
    −
    tPT2
    =
    242 988
    exceeds
    200 000
    (crossed
    at
    the
    fill
    CE42B).
    -/
theorem frontierPast200k : (tCE51 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE51 : ℝ) - WinC.tPT2 = 242988 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  CARRY
    (machine):
    tCE51
    −
    tPT2
    =
    242 988
    exceeds
    175 000
    (the
    CE38
    mark).
    -/
theorem frontierPast175k : (tCE51 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE51 : ℝ) - WinC.tPT2 = 242988 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE  CARRY
    (machine,
    PROVEN):
    tCE51
    −
    tPT2
    =
    242 988
    exceeds
    225 000
    -
    the
    225
    000-unit
    mark
    (crossed
    in
    window
    48,
    the
    CE48
    MILESTONE
    unit)
    is
    carried
    at
    the
    new
    frontier.
    The
    round-mark
    sequence
    above
    H0:
    100
    000  @
    CE22,
    125
    000  @
    CE27,
    150
    000  @
    CE33,
    175
    000  @
    CE38,
    200
    000  @
    CE42B,
    225
    000  @
    CE48.
    The
    next
    round
    mark,
    250
    000,
    sits
    7 012
    units
    ahead
    (window
    51
    is
    SNAPPED;
    expect
    window
    53).
    The
    1 000  000-certified-zero
    mark
    (window
    50,
    0356)
    is
    also
    carried
    -
    counts
    are
    pipeline
    data,
    recorded
    in
    the
    header,
    not
    in-tree
    arithmetic.
    -/
theorem frontierPast225k : (tCE51 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE51 : ℝ) - WinC.tPT2 = 242988 := frontierGapAboveH0
  linarith [h]
/-- Record:
    the
    rationalized
    slice
    caps
    are
    well
    ordered
    (gB50Lo
    <
    gB51Lo)
    -
    the
    window-51
    band
    (gB50Lo,
    gB51Lo]
    lies
    strictly
    above
    window
    50's
    certified
    region
    (gB49Lo,
    gB50Lo].
    -/
theorem gB50Lo_lt_gB51Lo : (gB50Lo : ℝ) < (gB51Lo : ℝ) := by
  norm_num [CE50.gB50Lo, gB51Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,
    OUR
    WINDOW-50
    RUN
    (window50_b50.json),
    FULL
    SLICE
    -
    re-cited
    at
    the
    CE51
    level]
    every
    zeta
    zero
    with
    gB49Lo
    <
    Im
    ρ
    <=
    gB50Lo
    is
    on
    the
    critical
    line.
    Same
    derivation
    as
    at
    the
    CE50
    level:
    for
    t0
    =
    Im
    ρ
    in
    (gB49Lo,
    gB50Lo],
    either
    t0
    <=
    g_b49
    (g_a50
    =
    g_b49,
    recorded
    exact
    dyadic
    tuple
    [29015917645196795743551458640382313851,
    -83,
    16777217,
    -110]
    -
    the
    chain
    seam,
    audit
    PASSED
    BEFORE
    CE50
    was
    written)
    -
    then
    t0
    sits
    in
    window
    49's
    certified
    region
    (g_a49,
    g_b49]
    -
    or
    t0
    >
    g_b49
    =
    g_a50,
    in
    which
    case
    t0
    <=
    gB50Lo
    <=
    g_b50
    puts
    t0
    in
    window
    50's
    certified
    region
    (g_a50,
    g_b50].
    The
    two
    certified
    regions
    union
    to
    (g_a49,
    g_b50]
    which
    contains
    (gB49Lo,
    gB50Lo]
    (machine:
    gB49Lo
    <
    tCE50
    <
    gB50Lo,
    from
    CE50).
    Named
    Prop
    consumed
    as
    a
    hypothesis;
    not
    proven
    in-tree.
    -/
def ce50WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB49Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB50Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,
    OUR
    WINDOW-51
    RUN
    (window51_b51.json),
    SLICE]
    every
    zeta
    zero
    with
    gB50Lo
    <
    Im
    ρ
    <=
    tCE51
    is
    on
    the
    critical
    line.
    Derivation
    (recorded):
    for
    t0
    =
    Im
    ρ
    in
    (gB50Lo,
    tCE51],
    either
    t0
    <=
    g_b50
    (the
    true
    Gram
    point
    -
    g_a51
    =
    g_b50,
    recorded
    exact
    dyadic
    tuple
    [116063670761562604479645262733743461387,
    -85,
    16777217,
    -110],
    i.e.
    3
    000  175  571
    115.696289062500
    +
    or
    -
    1.29e-26,
    BIT-IDENTICAL
    in
    both
    certificates
    -
    the
    chain
    seam,
    audit
    PASSED
    BEFORE
    this
    module
    was
    written
    per
    the
    0348
    process
    rule;
    gB50Lo
    <
    g_b50)
    -
    then
    t0
    sits
    in
    window
    50's
    certified
    region
    (g_a50,
    g_b50]
    -
    or
    t0
    >
    g_b50
    =
    g_a51,
    in
    which
    case
    t0
    <=
    tCE51
    <
    gB51Lo
    <=
    g_b51
    puts
    t0
    in
    window
    51's
    certified
    region
    (g_a51,
    g_b51]
    (window
    51
    is
    SNAPPED:
    b
    −
    a
    =
    19 999,
    one
    recorded
    quota-met
    Rosser
    rescue
    -
    see
    the
    header).
    The
    two
    certified
    regions
    union
    to
    (g_a50,
    g_b51]
    which
    contains
    (gB50Lo,
    tCE51]
    (machine:
    gB50Lo
    <
    tCE51
    <
    gB51Lo).
    Named
    Prop
    consumed
    as
    a
    hypothesis;
    not
    proven
    in-tree.
    -/
def ce51WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB50Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE51 : ℝ) → ρ.re = 1 / 2

/-- THE
    COMPOSITE
    BAND
    CLAUSE
    (machine):
    zeros
    in
    (tPT2,
    tCE51]
    are
    on
    the
    line,
    given
    the
    fifty-two
    window
    clauses
    (windows
    1
    through
    42,
    the
    fill,
    windows
    43
    through
    50
    [full
    slices],
    and
    window
    51
    [terminal
    slice])
    -
    the
    splits
    at
    gA2Hi,
    gB2Lo,
    ...,
    gB42Lo,
    gB42BLo,
    gB43Lo,
    gB44Lo,
    gB45Lo,
    gB46Lo,
    gB47Lo,
    gB48Lo,
    gB49Lo,
    gB50Lo
    are
    pure
    case
    splits.
    -/
theorem bandOfWindows51 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : CE22.ce21WinClauseFull)
    (h22 : CE23.ce22WinClauseFull) (h23 : CE24.ce23WinClauseFull)
    (h24 : CE25.ce24WinClauseFull) (h25 : CE26.ce25WinClauseFull)
    (h26 : CE27.ce26WinClauseFull) (h27 : CE28.ce27WinClauseFull)
    (h28 : CE29.ce28WinClauseFull) (h29 : CE30.ce29WinClauseFull)
    (h30 : CE31.ce30WinClauseFull)
    (h31 : CE32.ce31WinClauseFull)
    (h32 : CE33.ce32WinClauseFull)
    (h33 : CE34.ce33WinClauseFull)
    (h34 : CE35.ce34WinClauseFull)
    (h35 : CE36.ce35WinClauseFull)
    (h36 : CE37.ce36WinClauseFull)
    (h37 : CE38.ce37WinClauseFull)
    (h38 : CE39.ce38WinClauseFull)
    (h39 : CE40.ce39WinClauseFull)
    (h40 : CE41.ce40WinClauseFull)
    (h41 : ce41WinClauseFull)
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : CE49.ce48WinClauseFull) (h50 : CE50.ce49WinClauseFull) (h51 : ce50WinClauseFull) (h52 : ce51WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE51 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
          · exact h5 ρ hz (not_le.mp hseam4) hseam5
          · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
            · exact h6 ρ hz (not_le.mp hseam5) hseam6
            · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
              · exact h7 ρ hz (not_le.mp hseam6) hseam7
              · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
                · exact h8 ρ hz (not_le.mp hseam7) hseam8
                · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
                  · exact h9 ρ hz (not_le.mp hseam8) hseam9
                  · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
                    · exact h10 ρ hz (not_le.mp hseam9) hseam10
                    · by_cases hseam11 : ρ.im ≤ (gB11Lo : ℝ)
                      · exact h11 ρ hz (not_le.mp hseam10) hseam11
                      · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
                        · exact h12 ρ hz (not_le.mp hseam11) hseam12
                        · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
                          · exact h13 ρ hz (not_le.mp hseam12) hseam13
                          · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
                            · exact h14 ρ hz (not_le.mp hseam13) hseam14
                            · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
                              · exact h15 ρ hz (not_le.mp hseam14) hseam15
                              · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
                                · exact h16 ρ hz (not_le.mp hseam15) hseam16
                                · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
                                  · exact h17 ρ hz (not_le.mp hseam16) hseam17
                                  · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
                                    · exact h18 ρ hz (not_le.mp hseam17) hseam18
                                    · by_cases hseam19 : ρ.im ≤ (gB19Lo : ℝ)
                                      · exact h19 ρ hz (not_le.mp hseam18) hseam19
                                      · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
                                        · exact h20 ρ hz (not_le.mp hseam19) hseam20
                                        · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
                                          · exact h21 ρ hz (not_le.mp hseam20) hseam21
                                          · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
                                            · exact h22 ρ hz (not_le.mp hseam21) hseam22
                                            · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
                                              · exact h23 ρ hz (not_le.mp hseam22) hseam23
                                              · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
                                                · exact h24 ρ hz (not_le.mp hseam23) hseam24
                                                · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
                                                  · exact h25 ρ hz (not_le.mp hseam24) hseam25
                                                  · by_cases hseam26 : ρ.im ≤ (gB26Lo : ℝ)
                                                    · exact h26 ρ hz (not_le.mp hseam25) hseam26
                                                    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
                                                      · exact h27 ρ hz (not_le.mp hseam26) hseam27
                                                      · by_cases hseam28 : ρ.im ≤ (gB28Lo : ℝ)
                                                        · exact h28 ρ hz (not_le.mp hseam27) hseam28
                                                        · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
                                                          · exact h29 ρ hz (not_le.mp hseam28) hseam29
                                                          · by_cases hseam30 : ρ.im ≤ (gB30Lo : ℝ)
                                                            · exact h30 ρ hz (not_le.mp hseam29) hseam30
                                                            · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
                                                              · exact h31 ρ hz (not_le.mp hseam30) hseam31
                                                              · by_cases hseam32 : ρ.im ≤ (gB32Lo : ℝ)
                                                                · exact h32 ρ hz (not_le.mp hseam31) hseam32
                                                                · by_cases hseam33 : ρ.im ≤ (gB33Lo : ℝ)
                                                                  · exact h33 ρ hz (not_le.mp hseam32) hseam33
                                                                  · by_cases hseam34 : ρ.im ≤ (gB34Lo : ℝ)
                                                                    · exact h34 ρ hz (not_le.mp hseam33) hseam34
                                                                    · by_cases hseam35 : ρ.im ≤ (gB35Lo : ℝ)
                                                                      · exact h35 ρ hz (not_le.mp hseam34) hseam35
                                                                      · by_cases hseam36 : ρ.im ≤ (gB36Lo : ℝ)
                                                                        · exact h36 ρ hz (not_le.mp hseam35) hseam36
                                                                        · by_cases hseam37 : ρ.im ≤ (gB37Lo : ℝ)
                                                                          · exact h37 ρ hz (not_le.mp hseam36) hseam37
                                                                          · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
                                                                            · exact h38 ρ hz (not_le.mp hseam37) hseam38
                                                                            · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
                                                                              · exact h39 ρ hz (not_le.mp hseam38) hseam39
                                                                              · by_cases hseam40 : ρ.im ≤ (gB40Lo : ℝ)
                                                                                · exact h40 ρ hz (not_le.mp hseam39) hseam40
                                                                                · by_cases hseam41 : ρ.im ≤ (gB41Lo : ℝ)
                                                                                  · exact h41 ρ hz (not_le.mp hseam40) hseam41
                                                                                  · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
                                                                                    · exact h42 ρ hz (not_le.mp hseam41) hseam42
                                                                                    · by_cases hseam43 : ρ.im ≤ (gB42BLo : ℝ)
                                                                                      · exact h43 ρ hz (not_le.mp hseam42) hseam43
                                                                                      · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
                                                                                        · exact h44 ρ hz (not_le.mp hseam43) hseam44
                                                                                        · by_cases hseam45 : ρ.im ≤ (gB44Lo : ℝ)
                                                                                          · exact h45 ρ hz (not_le.mp hseam44) hseam45
                                                                                          · by_cases hseam46 : ρ.im ≤ (gB45Lo : ℝ)
                                                                                            · exact h46 ρ hz (not_le.mp hseam45) hseam46
                                                                                            · by_cases hseam47 : ρ.im ≤ (gB46Lo : ℝ)
                                                                                              · exact h47 ρ hz (not_le.mp hseam46) hseam47
                                                                                              · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
                                                                                                · exact h48 ρ hz (not_le.mp hseam47) hseam48
                                                                                                · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
                                                                                                  · exact h49 ρ hz (not_le.mp hseam48) hseam49
                                                                                                  · by_cases hseam50 : ρ.im ≤ (gB49Lo : ℝ)
                                                                                                    · exact h50 ρ hz (not_le.mp hseam49) hseam50
                                                                                                    · by_cases hseam51 : ρ.im ≤ (gB50Lo : ℝ)
                                                                                                      · exact h51 ρ hz (not_le.mp hseam50) hseam51
                                                                                                      · exact h52 ρ hz (not_le.mp hseam51) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE
    FRONTIER
    MOVED
    AGAIN
    (window
    51,
    SNAPPED):
    [Z-PT2]
    +
    the
    fifty-two
    cited
    window
    clauses
    =>
    the
    on-line
    census
    holds
    up
    to
    tCE51.
    -/
theorem allOnLineUpToCE51 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : ce50WinClauseFull) (hW52 : ce51WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE51 : ℝ) := by
  have hband := bandOfWindows51 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE
    RE-ANCHORED
    FACE
    (window
    51):
    no
    off-line
    zero
    with
    positive
    height
    above
    tCE51.
    -/
def terminalFaceCE51 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE51 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure
    logic:
    the
    CE50
    face
    implies
    the
    CE51
    face
    (tCE51
    >
    tCE50).
    -/
theorem faceCE50_implies_faceCE51 (q : ZeroSet)
    (hface : CE50.terminalFaceCE50 q) :
    terminalFaceCE51 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE50_lt_tCE51, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,
    EQUIVALENT  UNDER  THE  BAND:  the
    extra  band  (tCE50,  tCE51]  is
    certified  empty  (window  50  full
    slice  +  window  51  together
    -
    the  latter  SNAPPED,  width
    19 999,  with  one  recorded
    quota-met  Rosser  rescue;  see
    the  header)
    -
    re-anchoring  is  a
    CERTIFICATE,  not  a  logical
    move  (the  face  is  the  same
    open  object,  now  certified
    4 673  higher;
    the  225 000-unit
    mark  (CE48)  is
    carried  —
    see  frontierPast225k;  the
    1 000  000-certified-zero
    mark  [window
    50]  is  also  carried
    —
    counts  are  pipeline  data,
    not  in-tree  arithmetic).
    -/
theorem terminalFaceCE51_iff_faceCE50 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW51 : ce50WinClauseFull) (hW52 : ce51WinClause) :
    terminalFaceCE51 q ↔ CE50.terminalFaceCE50 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE51 : ℝ)
    · by_cases hseam51 : ρ.im ≤ (gB50Lo : ℝ)
      · exact hW51 ρ (hqz ρ hρ) (by linarith [ht, CE50.gB49Lo_lt_tCE50, tCE50_lt_tCE51]) hseam51
      · exact hW52 ρ (hqz ρ hρ) (not_le.mp hseam51) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE50_implies_faceCE51 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT
    tCE51
    (pure  logic).  -/
theorem rh_split_at_CE51 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE51 : ℝ) ∧ terminalFaceCE51 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE51 : ℝ)
      · exact hCensus ρ hρ hpos hle
      · exact hFace ρ hρ (not_le.mp hle)
    · have hneg : ρ.im < 0 := by
        have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne hle0 hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstpos : 0 < (star ρ).im := by
        have h : (star ρ).im = -ρ.im := by rfl
        rw [h]
        exact neg_pos.mpr hneg
      have hstRe : (star ρ).re = 1 / 2 := by
        by_cases hle : (star ρ).im ≤ (tCE51 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (window  51,
    corrected  chain  continues,
    SNAPPED  WINDOW  -
    the
    final  b  snapped  down  by
    1,  width  19 999;
    ONE  recorded  quota-met
    Rosser  rescue;  the
    1 000  000-certified-zero
    mark  [window
    50]  and  the
    225 000-unit  frontier
    mark  [CE48]
    are  carried):
    given  [Z-PT2]
    +
    the  fifty-two  cited
    window  clauses
    ([CE1-WIN],
    [CE2-WIN-FULL],
    ...
    [CE47-WIN-FULL],
    [CE48-WIN-FULL],
    [CE49-WIN-FULL],
    [CE50-WIN-FULL],
    [CE51-WIN]),
    all-heights  RH
    <->
    terminalFaceCE51.
    NO
    RH
    CLAIM.
    -/
theorem rh_reanchored_CE51 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : ce50WinClauseFull) (hW52 : ce51WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE51 q := by
  have hcensus := allOnLineUpToCE51 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hqz
  have hsplit := rh_split_at_CE51 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE51 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : CE49.ce48WinClauseFull) (hW50 : CE50.ce49WinClauseFull) (hW51 : ce50WinClauseFull) (hW52 : ce51WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE51 q) :
    RH q :=
  (rh_reanchored_CE51 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hW51 hW52 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE51_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE51 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE51
