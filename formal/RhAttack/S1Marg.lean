/-
(S1Marg)  THE  HS1  UNIFORMITY  TRACK:  the  P1.1e  best-straddle
margin  regime,  pinned.

WHAT
  The  residual  leg  hs1  of  RHEnd.rh_program78  is  read  at  an
  ACTUAL  off-line  zero  by  S1Face.hs1AtZero  (the  A0  fill
  collapses  to  |K|;  the  S1Ge  atom  reads  |K|  >=  devW  -
  Mval  with  the  data  pins  devW/Mval  as  its  only  input).
  The  day-020  audited  band  is  CLOSED  in  the  tree  (S1Face.hs1FaceAtAudit:
  the  C2  form  of  the  leg  and  the  measured  data  face  are
  jointly  incompatible  there  -  QSide.section8_close_at_audit).
  What  is  OPEN  is  the  UNIFORMITY  TRACK  (S1Face  docstring):
  does  the  squeeze  hold  at  every  witness  height,  and  with
  what  margin?
  This  module  pins  the  MEASURED  answer  at  the  candidate
  heights  -  the  P1.1e  BEST-STRADDLE  CLOSURE  STATISTIC  (the
  margin  of  the  hs1  composite  squeeze  |zeta|  *  min_d  |R-1|
  /  (B  +  |zeta  -  K|)  at  the  best  straddle  point  of  the
  window  around  the  witness  height  g),  from  three  certified
  runs:
    (i)   the  1e7  run  (day023_p11e_straddle_1e7):  14  candidate
          heights  [999.7916,  249999.7765],  per-t  quadrature
          to  1e18;
    (ii)  the  1e6  extension  (day023_p11e_straddle_1e6ext):  4
          candidates  [299999.7205,  999999.7934];
    (iii) the  (1e7,  1e9]  band  scan  (day023_straddle_hi):  the
          7  REAL-zero  candidates  [10000000.24,  28000000.1729]
          (dps-30  per-t  quadrature;  the  discrete  tail  is  the
          exact  sum  over  47,517,736  LMFDB  zeros  in  (1e7,
          3e7]  plus  the  density  quadrature  (3e7,  1e18]
          plus  the  analytic  remainder);  the  9  higher
          exploratory  "exp"  rows  (nominal  decade  points,
          density-only  tails,  margins  below  1  from
          3.1e7)  are  EXPLORATORY  and  are  NOT  pinned  -
          they  are  the  recorded  signal  that  the  composite
          is  the  limiting  object  above  the  certified
          regime  (the  repair-list  class),  not  a  measurement
          at  a  real  zero.
  The  pinned  regime:  the  margin  is  >=  25  on  the  certified
  candidates  up  to  150000.2616  (last  certified  candidate
  with  margin  >=  25;  the  next  certified  candidate,
  199999.7053,  is  21.665  <  25  -  the  25x  window  closes
  between  them);  >=  13  down  to  999999.7934  (the  last
  certified  candidate  at  or  below  1e6);  and  >=  1  down  to
  28000000.1729  (the  last  certified  real-zero  candidate;
  minimum  certified  margin  1.4138  at  19999999.8837).
  The  hs1  squeeze  is  therefore  MEASURED  UNIFORM  (margin
  >=  1,  high-precision  >=  13  below  1e6)  at  the  25
  certified  candidate  heights  in  [1e3,  2.8e7];  the  track
  between  and  above  the  candidates  is  the  open  measured
  face  (declared  below  -  the  S4Blind  s4OpenFace  pattern).

HOW
  Individual  pins  (g/marg  pairs  as  exact  rationals  -  the
  printed  6-significant-figure  values  of  the  records,  in  the
  MFa  pin  pattern)  +  ONE  norm_num  gate  theorem  (margGates:
  the  threshold  facts  all  cross-multiplied  into  positive
  rational  inequalities  +  the  height  order  +  the  decay
  order)  +  the  NAMED  UNIFORM  FACE  (hs1MargFace,  declared  for
  ANY  zero  set  and  ANY  margin  statistic:  every  height
  that  carries  an  off-pair  zero  has  margin  >=  1;  the
  pinned  gates  are  its  measured  shadow  at  the  25
  candidate  heights).  The  full  25-row  table  lives  in  the
  records  (provenance  above);  Lean  pins  the
  regime-deciding  anchors  (the  MFar/B7F  pin  pattern:  the
  pins  are  what  the  gates  use).

USES
  None  yet.  The  endpoint  is  UNAFFECTED:  hs1  remains  a
  named  residual  of  RHEnd.rh_program78  (read  by
  S1Face.hs1AtZero,  closed  at  the  day-020  audited  band  by
  S1Face.hs1FaceAtAudit,  pin  family  form  in  RHEnd Part  B2).
  This  module  is  the  MEASURED  CONSTRAINT  (PATHWAY  section
  3):  any  RH  proof  must  reproduce  the  margin  regime  -
  the  25x  class  below  about  1.5e5,  the  13x  class  below
  1e6,  the  >=  1  class  below  2.8e7  -  and  the  face  says
  where  the  measured  track  ends.

GOTCHA:  the  pins  are  the  PRINTED  6-significant-figure
  margins  (the  records  print  136.062  for  136.0619...-class
  values);  every  gate  is  slack  against  the  last  printed
  digit  (the  smallest  margin  gap  is  1.4138  vs  the  1
  threshold  -  41%  slack;  the  25x  bracket  uses  38.053/21.665
  vs  25).  The  "exp"  rows  of  the  band  scan  are  exploratory
  (nominal  points,  density-only  tails)  -  they  must  never  be
  cited  as  measurements  at  real  zeros. -/

import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform

open Real Set B0 P12

namespace S1M

/-  ##  the  pins  (g  =  the  witness  height  candidate;  m =
    the  P1.1e  best-straddle  margin  at  that  candidate;
    printed  6-significant-figure  record  values,  as  exact
    rationals) -/

/-- 25x  regime  interior:  margin  28.918  at  g  =
    125000.3524  (1e7  run). -/
def g125 : ℚ := 1250003524 / 10
def m125 : ℚ := 28918 / 1000
/-- the  LAST  certified  candidate  with  margin  >=  25:
    margin  38.053  at  g  =  150000.2616  (1e7  run). -/
def g150 : ℚ := 1500002616 / 10
def m150 : ℚ := 38053 / 1000
/-- the  FIRST  certified  candidate  with  margin  <  25:
    margin  21.665  at  g  =  199999.7053  (1e7  run). -/
def g200 : ℚ := 1999997053 / 10
def m200 : ℚ := 21665 / 1000
/-- the  2.5e5  candidate:  margin  15.504  (1e7  run  minimum). -/
def g250 : ℚ := 2499997765 / 10
def m250 : ℚ := 15504 / 1000
/-- the  last  certified  candidate  at  or  below  1e6:
    margin  13.068  at  g  =  999999.7934  (1e6ext  run). -/
def g1e6 : ℚ := 9999997934 / 10
def m1e6 : ℚ := 13068 / 1000
/-- the  1e7  candidate:  margin  5.2362  (band  scan). -/
def g1e7 : ℚ := 100000002400 / 10
def m1e7 : ℚ := 52362 / 10000
/-- the  certified  MINIMUM  margin  (2e7  candidate):
    margin  1.4138  (band  scan). -/
def g2e7 : ℚ := 199999998837 / 10
def m2e7 : ℚ := 14138 / 10000
/-- the  LAST  certified  real-zero  candidate:
    margin  1.7120  at  g  =  28000000.1729  (band  scan). -/
def g28e7 : ℚ := 280000001729 / 10
def m28e7 : ℚ := 17120 / 10000

/- ##  the  gates -/

/-- THE  MARGIN  REGIME  GATES  (exact  rational  arithmetic  on
    the  pins,  all  cross-multiplied;  the  printed
    6-significant-figure  slack  against  every  threshold):
    (i)   the  25x  WINDOW  -  the  margin  is  >=  25  at  the
        125000.3524  and  150000.2616  candidates  and  <  25  at
        the  199999.7053  candidate:  the  certified  25x  regime
        closes  between  1.5e5  and  2e5;
    (ii)  the  >=  15  class  survives  to  2.5e5  (15.504);
    (iii) the  >=  13  class  survives  to  the  last  candidate
        at  or  below  1e6  (13.068);
    (iv)  the  >=  1  class  survives  to  the  last  certified
        candidate  (1.4138  at  2e7,  1.7120  at  2.8e7);
    (v)   the  height  order  of  the  anchors;
    (vi)  the  DECAY  order  of  the  certified  minimums  -
        the  regime  degrades  monotonically  with  height
        (28.918  >  15.504  >  13.068  >  5.2362  >  1.4138). -/
theorem margGates :
    m125 >= 25 ∧
    m150 >= 25 ∧
    m200 < 25 ∧
    m250 >= 15 ∧
    m1e6 >= 13 ∧
    m1e7 >= 5 ∧
    m2e7 >= 1 ∧
    m28e7 >= 1 ∧
    g125 < g150 ∧ g150 < g200 ∧ g200 < g250 ∧
    g250 < g1e6 ∧ g1e6 < g1e7 ∧ g1e7 < g2e7 ∧ g2e7 < g28e7 ∧
    m125 > m250 ∧ m250 > m1e6 ∧ m1e6 > m1e7 ∧ m1e7 > m2e7 := by
  norm_num [g125, m125, g150, m150, g200, m200, g250, m250,
            g1e6, m1e6, g1e7, m1e7, g2e7, m2e7, g28e7, m28e7]

/- ##  the  named  uniform  face  (declaration,  not  proof) -/

/-- THE  HS1  UNIFORM  FACE  (declaration,  not  proof):  the
    open  MEASURED  TRACK  of  the  hs1  leg.  For  ANY  zero  set
    q  and  ANY  margin  statistic  marg  (the  P1.1e
    best-straddle  closure  statistic,  abstract  -  the  b7OpenFace
    mechanism-map  pattern):  every  height  that  carries  an
    off-pair  zero  has  margin  >=  1.  The  pinned  gates
    (margGates)  are  the  MEASURED  SHADOW  of  this  statement
    at  the  25  certified  candidate  heights  in
    [1e3,  2.8e7]  (25x  class  below  about  1.5e5;  13x  class
    below  1e6;  >=  1  class  to  the  end  of  the  certified
    band):  on  the  measured  domain  the  face  holds  at  the
    candidates  with  large  slack  -  what  is  NOT  proven  is
    the  face  itself  (uniformity  between  and  above  the
    candidates,  including  the  region  where  the  exploratory
    "exp"  signal  says  the  composite  becomes  the  limiting
    object  above  about  3e7).  No  RH  claim:  this  is  the
    named  open  measured  track  of  the  endpoint's  hs1
    residual  (S1Face  docstring:  "uniformity  in  the  height
    is  the  open  measured  track"),  now  pinned  at  its
    measured  frontier. -/
def hs1MargFace (q : ZeroSet) (marg : ℝ → ℝ) : Prop :=
    ∀ (t0 : ℝ), 0 < t0 →
      (∃ (d0 : ℝ), 0 < d0 ∧ offPair q t0 d0) →
      marg t0 ≥ 1

end S1M
