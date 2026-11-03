/-  T4OffLM  --  THE  0273/0274  XI-PRODUCT  FACE  RECORD  AT  tPT2:
   OFF-BOARD  BOUND-LEVEL  RESIDUAL  (the  T4OffLB...LL  class).

   The  0273  program  (route  (b),  discovery  0273/0273a-r,
   2026-11-03  ->  2026-11-07)  attacked  the  terminal  face
   (claim  (b),  0270):  zero-freeness  of  sigma  in
   (0.1252270103,  1/2)  at  t  >=  tPT2  =  3,000,175,332,800,
   by  the  xi-product  explicit  formula  at  face  height:

       log|zeta(s)|  =  log(1/2)  -  Re  log  phi(s)  +  S(s)  +  U(s),
       S   =  sum  of  f(g;s)  over  the  KNOWN  zeros  (data),
       U   =  Int  f rho dg  (main  term)  +  fluctuation,
     with  the  fluctuation  bounded  by  the  R-vM  per-unit
     count  law  |fluct|  <=  B_unk  (Titchmarsh  9.2  form,
     B1  =  A0  ln  t  =  3.4  ln  t,  telescoping  over  the
     exact  monotone  pieces  of  f).

   The  machine  was  validated  END-TO-END  before  any  face
   reading  (the  0272  discipline):  day068  count-residual
   GREEN  (worst  3.4e-37  over  9  known-territory  rectangles);
   the  lshard  reader  repaired  (13-byte  records  are
   CUMULATIVE  intra-block  deltas)  and  validated  on  all  11
   shards;  the  t  =  1e9  anchor  closes  at  the  data  floor
   (rel  1.7e-7);  the  tPT2  unknown-side  main  term  is  DUAL
   (c4-decomp  g-space  pin  vs  u-substitution  y-space,
   dps-60,  calibrated  gates  at  t  =  1e9  rel  2.18e-9  and
   t  = 4e9  dip-in-range  rel  4.37e-10;  tPT2  dual  spread
   rel  3.5e-9);  day074  re-probed  at  t  =  tPT2  +  3e9  with
   the  identity  again  closing  inside  the  certified  bound.

   THE  CORRECT  FACE  DISCRIMINANT  (0274  fourth  correction,
   2026-11-07):  the  0273-design  "K'  >  B_unk  implies
   exclusion"  criterion  (step  4  of  5.4)  was  a  MISREADING:
   the  bound  B_unk  covers  EVERY  law-conformant  unknown-zero
   configuration  -  including  configurations  with  a  zero  in
   the  probe  disk  -  so  comparing  the  (negative)  main  term
   K'  against  B_unk  proves  nothing  about  zeros.  The  sound
   quantities  are  the  MEASURED  fluctuation
   fluc  :=  log|zeta(s)|  -  K'  against  the  envelopes:
   (v)   VALIDITY:  |fluc|  <=  B_unk  (the  identity  premise  -
         machine-verified  true  at  tPT2  (both  data  cuts)  and
         at  tPT2  +  3e9,  all  four  probed  sigmas);
   (n)   NO  EXCLUSION:  the  measured  fluc  lies  INSIDE  the
         certified  envelope  with  POSITIVE  slack
         B_unk  -  fluc  =  +1,243  (sigA,  optimal  cut)  ..  +2,304
         (sigN):  the  face  hypothesis  (a  zero  at  the  probed
         points  and  in  the  surrounding  unit  window)  is
         CONFORMANT  with  the  certified  count-law  machinery:
         NOTHING  is  excluded;
   (r)   FACE  REDUCTION  (the  genuine  new  quantitative  result):
         the  window-count  upper  bound.  For  the  unit  window
         W  =  (tPT2  -  1,  tPT2  +  1]  on  the  zero  ORDINATES,
         fluc  =  fluc_X  +  sum_W  f  with  |fluc_X|  <=  E_win
         (the  certified  envelope  over  the  zeros  OUTSIDE  W,
         both  monotone  pieces  re-telescoped  with  the  W  edge
         budgets  removed)  and  sum_W  f  <=  -k  |f_edge|  for  k
         zeros  in  W  (each  in  W  contributes  f  <=  f_edge  <  0):
         k  >  (E_win  -  fluc)  /  |f_edge|  is  INCONSISTENT  with
         the  measured  fluc.  The  raw  R-vM  law  alone  allows
         up  to  about  196  zeros  in  W;  the  measured  fluc  +
         the  certified  envelope  cut  that  to
         k  <=  33  /  33  /  34  /  34  (sigA  /  sigQ  /  sigF  /
         sigN)  -  a  5.9x  certified  reduction  of  the  face
         content  at  the  frontier  height,  obtained  WITHOUT  any
         data  past  gData  =  3.0001e10.  (k  >  0  survives:  the
         window  is  NOT  proven  empty:  the  face  stays  open.)

   THE  RESULT  (this  module):  the  corrected  main  term  K'  is
   NEGATIVE  at  both  data  cuts  (arithmetic  fact,  recorded);
   the  identity  premise  holds  INSIDE  the  certified  envelope
   with  positive  slack  (face  OPEN  -  no  exclusion);  and  the
   face  content  of  the  frontier  unit  window  is  CERTIFIABLY
   REDUCED  (<=  33/33/34/34  instead  of  <=  about  196).
   The  GAP  TO  EXCLUSION:  the  window  count  k  =  0  is
   excluded  at  sigA  iff  E_win  <  fluc  =  9,059.56,  i.e.  a
   9.4%  sharpening  of  the  certified  envelope  -  the  next
   named  unit  (0275:  sharp  local-count  constant  and  kernel
   sharpening,  no  new  data).

   PROVENANCE  (authoritative  map,  2026-11-07):  the  in-repo
   zero  ORDINATES  end  at  gData  =  30,001,045,999.98  (100x
   below  the  face  height  -  gDataBelowTPT2Over100);  the
   [Z-PT2]  citation  (Platt-Trudgian,  arXiv:2004.09765,  PINNED
   0263)  establishes  ON-LINE-NESS  up  to  tPT2  by  sign-change
   counting  WITH  INTERVAL  ARITHMETIC  -  the  paper  itself
   records  that  NO  zero  list  beyond  the  counting  was
   generated  ("we  had  nowhere  to  store  that  many  zeroes"):
   no  ordinates  in  (gData,  tPT2]  exist  in  the  repo  or  in
   the  cited  record.

   The  numerals  below  are  the  outputs  of  the  validated
   numeric  machine  (scripts/rh/day072_face_U_repair.py,
   out_day072_face_U_repair.txt;  scripts/rh/day073_wall_3e10_split.py,
   out_day073_wall_3e10_split.txt;  scripts/rh/day073b_3e10_sum.py,
   out_day073b_3e10_sum.json;  scripts/rh/day074_tslope_probe.py,
   out_day074_tslope.txt).  Recorded  as  a  NAMED  BOUND-LEVEL
   RESIDUAL  in  the  house  pattern  (T4OffLL  S2  class):
   arithmetic  over  the  recorded  verified  numerals,  full
   provenance  in  the  docstrings,  OFF-BOARD  (no  zeta  evaluation
   in  body).  No  RH  claim.  -/

import  Mathlib
import  RhAttack.WinCount

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false
set_option  linter.style.docString  false

open  Real

namespace  T4OffLM

/-  The  face  (claim  (b),  0270 route  (b)  scope):  the
    terminal  face  is  the  sigma  interval  (aFace,  1/2)  at
    t  >=  tPT2;  with  the  [Z78C]  shell  and  the  [Z-PT2]
    on-line  record  below  tPT2,  its  zero-freeness  IS  the
    hOffCPT2  residual,  hence  IS  RH  (0270).  -/

def  aFace  :  ℚ  :=  1252270103  /  10 ^ 10     --  0.1252270103

def  faceSigma  (σ  :  ℝ)  :  Prop  :=  (aFace :  ℝ)  <  σ  ∧  σ  <  1  /  2

/-  The  END  OF  THE  IN-REPO  ZERO  ORDINATE  DATA:  the  last
    zero  of  the  hi3e10  band  (92,577,877,714  zeros,  raw
    little-endian  f64,  740,623,021,712  bytes,  no  header;
    first  =  2,999,246,000.182257,  last  =  this).  -/

def  gData  :  ℚ  :=  30001045999981976  /  10 ^ 6    --  30,001,045,999.981976

/--  THE  100x  DATA  GAP:  the  in-repo  zero  coordinates  end
    a  full  factor  of  100  below  the  face  height  (gData  =
    3.0001e10  <  3.0001753e10  =  tPT2/100).  -/
theorem  gDataBelowTPT2Over100  :  (gData :  ℝ)  <  WinC.tPT2  /  100  :=  by
  norm_num  [gData,  WinC.tPT2]

/-  The  four  validated  PROBE  SIGMAS  (0273  machine):  the  face
    left  edge  itself  (a  BOUNDARY  VALUE  -  probed  for  edge
    sharpness,  NOT  a  member  of  the  OPEN  face  (aFace,  1/2))
    and  three  interior  face  points.  -/

def  sigA  :  ℚ  :=  1252270103  /  10 ^ 10    --  0.1252270103  (the  left  edge  VALUE)
def  sigQ  :  ℚ  :=  1  /  4                  --  0.25
def  sigF  :  ℚ  :=  2  /  5                  --  0.40
def  sigN  :  ℚ  :=  49  /  100               --  0.49

/-  sigA  is  the  left-edge  VALUE  (aFace  <  σ  fails  at  σ  =  aFace
    since  the  face  is  open  there);  the  three  interior  probe
    sigmas  lie  in  the  face.  -/

theorem  sigAedgeValue  :  (sigA :  ℝ)  =  (aFace :  ℝ)  :=  by  norm_num  [sigA,  aFace]
theorem  sigQIsFace  :  faceSigma  (sigQ :  ℝ)  :=  by  norm_num  [sigQ,  aFace,  faceSigma]
theorem  sigFIsFace  :  faceSigma  (sigF :  ℝ)  :=  by  norm_num  [sigF,  aFace,  faceSigma]
theorem  sigNIsFace  :  faceSigma  (sigN :  ℝ)  :=  by  norm_num  [sigN,  aFace,  faceSigma]

/-  THE  VALIDATED  MAIN  TERM  (0273a-r,  day072,  t  =  tPT2,
    GLAST  cut):  K'  =  S  +  I_unk  -  Re  log  phi  +  log(1/2)
    for  the  four  probed  sigmas.  Dual  main  term  spread  rel
    3.5e-9;  S-stream  9,068,473,888  zeros  (repaired  reader,
    boundary  ownership).  THE  0274  PIN  (day073b,  gData  cut,
    the  92.5e9-zero  exact  float64  sum  over  (GLAST,  gData],
    pre-flight  vs  mpmath  dps-30  worst  1.8e-15):  K'_opt  =
    K'(GLAST)  +  (SUM  -  Int  f  rho  dg)  -  the  0274  band
    (plus/minus  1799.20)  collapsed  to  the  PIN:  the  density
    residual  (SUM  -  Int)  is  only  -7.2100  (sigma-flat  to
    4  digits  against  a  9.874e11  integral).  -/

def  K3A  :  ℚ  :=  -(9042185335 :  ℚ)  /  10 ^ 6    --  -9042.185335  (GLAST  cut)
def  K3Q  :  ℚ  :=  -(9045537874 :  ℚ)  /  10 ^ 6    --  -9045.537874
def  K3F  :  ℚ  :=  -(9049568635 :  ℚ)  /  10 ^ 6    --  -9049.568635
def  K3N  :  ℚ  :=  -(9051986604 :  ℚ)  /  10 ^ 6    --  -9051.986604

def  KpinA  :  ℚ  :=  -(90493952959375 :  ℚ)  /  10 ^ 10    --  -9049.3952959375  (gData  pin)
def  KpinQ  :  ℚ  :=  -(90527478349375 :  ℚ)  /  10 ^ 10    --  -9052.7478349375
def  KpinF  :  ℚ  :=  -(90567785959375 :  ℚ)  /  10 ^ 10    --  -9056.7785959375
def  KpinN  :  ℚ  :=  -(90591965649375 :  ℚ)  /  10 ^ 10    --  -9059.1965649375

theorem  k3NegA  :  (K3A :  ℝ)  <  0  :=  by  norm_num  [K3A]
theorem  k3NegQ  :  (K3Q :  ℝ)  <  0  :=  by  norm_num  [K3Q]
theorem  k3NegF  :  (K3F :  ℝ)  <  0  :=  by  norm_num  [K3F]
theorem  k3NegN  :  (K3N :  ℝ)  <  0  :=  by  norm_num  [K3N]
theorem  kpinNegA  :  (KpinA :  ℝ)  <  0  :=  by  norm_num  [KpinA]
theorem  kpinNegQ  :  (KpinQ :  ℝ)  <  0  :=  by  norm_num  [KpinQ]
theorem  kpinNegF  :  (KpinF :  ℝ)  <  0  :=  by  norm_num  [KpinF]
theorem  kpinNegN  :  (KpinN :  ℝ)  <  0  :=  by  norm_num  [KpinN]

/-  THE  CERTIFIED  FLUCTUATION  ENVELOPES  (exact  monotone-piece
    telescoping,  B1  =  3.4  ln  tPT2;  f  decreasing  on  (G,  t],
    increasing  on  [t,  32t];  the  (32t,  inf)  tail  exact  via
    f  =  c4/g^2  +  O(g^-4)):
    -  Bunk  =  the  FULL  envelope  over  the  unknown  side  at  the
       OPTIMAL  gData  cut  (day073  certified  bounds;  the
       GLAST-cut  counterparts  11,202.38  ..  12,264.29  are  in
       the  record);
    -  Ewin  =  the  CONDITIONAL  envelope  over  the  zeros  OUTSIDE
       the  frontier  unit  window  (tPT2  -  1,  tPT2  +  1]  (the
       window  edge  budgets  removed;  the  re-telescoped  two-piece
       certificate).  Ewin  is  the  operative  bound  for  the
       window-count  reduction.  -/

def  BunkA  :  ℚ  :=  1030285  /  100           --  10302.85  (gData  cut,  full)
def  BunkQ  :  ℚ  :=  1042149  /  100           --  10421.49
def  BunkF  :  ℚ  :=  1069000  /  100           --  10690.00
def  BunkN  :  ℚ  :=  1136476  /  100           --  11364.76

def  EwinA  :  ℚ  :=  999601  /  100             --  9996.01  upper  (9,995.9916  computed)
def  EwinQ  :  ℚ  :=  1000641  /  100            --  10,006.41  upper  (10,006.3657)
def  EwinF  :  ℚ  :=  1001385  /  100            --  10,013.85  upper  (10,013.7905)
def  EwinN  :  ℚ  :=  1001531  /  100            --  10,015.31  upper  (10,015.2338)

/-  THE  MEASURED  FLUCTUATION  fluc  :=  log|zeta(s)|  -  K'_opt
    (independent  dps  zeta  minus  the  day073b  pin):
    9,059.56  /  9,059.64  /  9,059.87  /  9,060.29  (LOWER  bounds
    recorded;  the  dps-30/50/80  values  are  stable  to  1e-6).  -/

def  flucA  :  ℚ  :=  905956  /  100            --  9,059.56  (lower  bound  of  9,059.564759)
def  flucQ  :  ℚ  :=  905964  /  100            --  9,059.64  (lower  bound  of  9,059.642475)
def  flucF  :  ℚ  :=  905986  /  100            --  9,059.86  (lower  bound  of  9,059.865896)
def  flucN  :  ℚ  :=  906028  /  100            --  9,060.28  (lower  bound  of  9,060.288765)

/-  THE  WINDOW  KERNEL  EXTREMES  (f  over  W  x  the  face):
    f  <=  f_edge  <  0  at  every  zero  of  W  with  real  part  in
    the  face  (sup  over  the  zero  real  part  in  the  kernel,  a
    =  0.5  -  sigma):  |f_edge|  >=  the  recorded  LOWER  bounds;
    f  >=  f(tPT2)  (the  dip  minimum,  most  negative).  -/

def  fedgeA  :  ℚ  :=  2797  /  100             --  27.97   (|f(tPT2 -/+ 1)|  =  27.970831)
def  fedgeQ  :  ℚ  :=  2800  /  100             --  28.00   (28.006232)
def  fedgeF  :  ℚ  :=  2803  /  100             --  28.03   (28.031570)
def  fedgeN  :  ℚ  :=  2803  /  100             --  28.03   (28.036495)

/-  =================================================================
   (v)  VALIDITY  AT  FACE  HEIGHT:  THE  IDENTITY  PREMISE  HOLDS
   INSIDE  THE  CERTIFIED  ENVELOPE.
   =================================================================
   fluc  <=  Bunk  (all  four  probed  sigmas,  optimal  cut):
   the  actual  unknown-zero  configuration  (whatever  it  is,
   including  the  content  of  the  frontier  window)  is
   COUNT-LAW  CONFORMANT.  At  the  GLAST  cut  the  slack  is
   larger  (2,150  ..  3,211);  at  t  =  tPT2  +  3e9  (day074)
   the  identity  closes  again  (slacks  2,141  ..  3,203).  -/

/--  VALIDITY  (sigA):  the  measured  fluctuation  is  inside  the
    certified  envelope  at  t  =  tPT2,  gData  cut.  -/
theorem  validA  :  (flucA :  ℝ)  <=  (BunkA :  ℝ)  :=  by  norm_num  [flucA,  BunkA]
/--  VALIDITY  (sigQ).  -/
theorem  validQ  :  (flucQ :  ℝ)  <=  (BunkQ :  ℝ)  :=  by  norm_num  [flucQ,  BunkQ]
/--  VALIDITY  (sigF).  -/
theorem  validF  :  (flucF :  ℝ)  <=  (BunkF :  ℝ)  :=  by  norm_num  [flucF,  BunkF]
/--  VALIDITY  (sigN).  -/
theorem  validN  :  (flucN :  ℝ)  <=  (BunkN :  ℝ)  :=  by  norm_num  [flucN,  BunkN]

/-  =================================================================
   (n)  NO  EXCLUSION:  THE  CERTIFIED  ENVELOPE  IS  OPEN.
   =================================================================
   slack  :=  Bunk  -  fluc  >  0  (all  sigmas):  the  face
   hypothesis  (a  zero  at  /  near  the  probed  points)  is
   CONFORMANT  with  the  certified  machinery;  the  face  is  NOT
   excluded  at  tPT2  (nor  at  tPT2  +  3e9,  day074).  The  named
   slacks  are  the  true  "distance  to  exclusion"  -  NOT  the
   signed  K'  -  Bunk  numbers  of  the  superseded  0274  draft
   (those  mixed  the  sign  of  the  negative  main  term  into  the
   criterion;  see  entry  0274  fourth  correction).  -/

def  slackA  :  ℚ  :=  BunkA  -  flucA          --  1,243.29  (computed  1,243.2858)
def  slackQ  :  ℚ  :=  BunkQ  -  flucQ          --  1,361.85  (computed  1,361.8523)
def  slackF  :  ℚ  :=  BunkF  -  flucF          --  1,630.14  (computed  1,630.1348)
def  slackN  :  ℚ  :=  BunkN  -  flucN          --  2,304.48  (computed  2,304.4734)

/--  FACE  OPEN  (sigA):  Bunk  -  fluc  =  1,243.29  >  0.  -/
theorem  openA  :  (slackA :  ℝ)  >  0  :=  by  norm_num  [slackA,  BunkA,  flucA]
/--  FACE  OPEN  (sigQ).  -/
theorem  openQ  :  (slackQ :  ℝ)  >  0  :=  by  norm_num  [slackQ,  BunkQ,  flucQ]
/--  FACE  OPEN  (sigF).  -/
theorem  openF  :  (slackF :  ℝ)  >  0  :=  by  norm_num  [slackF,  BunkF,  flucF]
/--  FACE  OPEN  (sigN).  -/
theorem  openN  :  (slackN :  ℝ)  >  0  :=  by  norm_num  [slackN,  BunkN,  flucN]

/-  =================================================================
   (r)  THE  CERTIFIED  WINDOW-COUNT  REDUCTION  AT  THE  FRONTIER:
       the  frontier  unit  window  W  =  (tPT2  -  1,  tPT2  +  1]
       contains  at  most  33  /  33  /  34  /  34  zeros  (sigA  /
       sigQ  /  sigF  /  sigN)  -  against  about  196  for  the  raw
       R-vM  law  alone  (2  B1  +  mean  over  two  unit  intervals).
   =================================================================
   fluc  =  fluc_X  +  sum_W  f:  |fluc_X|  <=  Ewin  (certified,
   window  removed)  and  sum_W  f  <=  -k  fedge  (k  zeros  in  W,
   each  f  <=  -fedge  <  0):  a  conformant  configuration  with
   k  zeros  in  W  requires  fluc  <=  Ewin  -  k  fedge.  The  named
   theorems  record  that  k  beyond  the  bound  makes  that
   impossible  against  the  MEASURED  fluc.  -/

/--  WINDOW  COUNT  (sigA):  k  >=  34  zeros  in  W  are
    INCONSISTENT  with  the  certified  envelope  +  the  measured
    fluctuation:  EwinA  -  34  fedgeA  <  flucA.  -/
theorem  windowA  :  (EwinA :  ℝ)  -  34  * (fedgeA :  ℝ)  <  (flucA :  ℝ)  :=  by
  norm_num  [EwinA,  fedgeA,  flucA]
/--  WINDOW  COUNT  (sigQ):  EwinQ  -  34  fedgeQ  <  flucQ.  -/
theorem  windowQ  :  (EwinQ :  ℝ)  -  34  * (fedgeQ :  ℝ)  <  (flucQ :  ℝ)  :=  by
  norm_num  [EwinQ,  fedgeQ,  flucQ]
/--  WINDOW  COUNT  (sigF):  EwinF  -  35  fedgeF  <  flucF.  -/
theorem  windowF  :  (EwinF :  ℚ)  -  35  * (fedgeF :  ℚ)  <  (flucF :  ℚ)  :=  by
  norm_num  [EwinF,  fedgeF,  flucF]
/--  WINDOW  COUNT  (sigN):  EwinN  -  35  fedgeN  <  flucN.  -/
theorem  windowN  :  (EwinN :  ℚ)  -  35  * (fedgeN :  ℚ)  <  (flucN :  ℚ)  :=  by
  norm_num  [EwinN,  fedgeN,  flucN]

/-  THE  GAP  TO  EXCLUSION  (named,  for  0275):  the  window  is
    proven  EMPTY  (k  =  0)  iff  Ewin  <  fluc.  At  the  optimal
    cut  (computed):  sigma_A:  Ewin  9,995.99  vs  fluc  9,059.56:
    a  9.4%  envelope  sharpening  (3.4  ->  3.08  on  A0,  or  the
    kernel  equivalent)  would  close  the  sigma-A  window;  the
    other  sigmas  need  10.2%  /  9.9%  /  9.9%.  -/

def  gapToExclA  :  ℚ  :=  EwinA  -  flucA      --  936.45  (computed  936.4268)
def  gapToExclQ  :  ℚ  :=  EwinQ  -  flucQ      --  946.77  (computed  946.7232)
def  gapToExclF  :  ℚ  :=  EwinF  -  flucF      --  953.99  (computed  953.9246)
def  gapToExclN  :  ℚ  :=  EwinN  -  flucN      --  955.03  (computed  954.9451)

theorem  gapPosA  :  (gapToExclA :  ℝ)  >  0  :=  by  norm_num  [gapToExclA,  EwinA,  flucA]
theorem  gapPosQ  :  (gapToExclQ :  ℝ)  >  0  :=  by  norm_num  [gapToExclQ,  EwinQ,  flucQ]
theorem  gapPosF  :  (gapToExclF :  ℝ)  >  0  :=  by  norm_num  [gapToExclF,  EwinF,  flucF]
theorem  gapPosN  :  (gapToExclN :  ℝ)  >  0  :=  by  norm_num  [gapToExclN,  EwinN,  flucN]

/-  THE  COMPOSITE  STATEMENT  (t  =  tPT2,  every  probed  sigma,
    optimal  gData  cut):
      the  corrected  main  term  is  NEGATIVE  (arithmetic);
      the  identity  premise  HOLDS  inside  the  certified  envelope
      (validA..N);
      the  envelope  has  POSITIVE  SLACK  (face  OPEN  -  no
      exclusion);
      the  frontier  unit  window  is  CERTIFIABLY  REDUCED  (<=  33/33/34/34
      instead  of  about  196).
    The  terminal  face  (claim  (b),  hence  the  hOffCPT2  residual,
    hence  RH)  REMAINS  OPEN  at  this  record.  No  RH  claim.  -/
theorem  faceOpenAtTPT2  :
    (((K3A :  ℝ)  <  0  ∧  (KpinA :  ℝ)  <  0)  ∧
      (((flucA :  ℝ)  <=  (BunkA :  ℝ))  ∧  ((slackA :  ℝ)  >  0)))
    ∧  (((K3Q :  ℝ)  <  0  ∧  (KpinQ :  ℝ)  <  0)  ∧
      (((flucQ :  ℝ)  <=  (BunkQ :  ℝ))  ∧  ((slackQ :  ℝ)  >  0)))
    ∧  (((K3F :  ℝ)  <  0  ∧  (KpinF :  ℝ)  <  0)  ∧
      (((flucF :  ℝ)  <=  (BunkF :  ℝ))  ∧  ((slackF :  ℝ)  >  0)))
    ∧  (((K3N :  ℝ)  <  0  ∧  (KpinN :  ℝ)  <  0)  ∧
      (((flucN :  ℝ)  <=  (BunkN :  ℝ))  ∧  ((slackN :  ℝ)  >  0)))  :=
  ⟨⟨⟨k3NegA,  kpinNegA⟩,  ⟨validA,  openA⟩⟩,
   ⟨⟨k3NegQ,  kpinNegQ⟩,  ⟨validQ,  openQ⟩⟩,
   ⟨⟨k3NegF,  kpinNegF⟩,  ⟨validF,  openF⟩⟩,
   ⟨⟨k3NegN,  kpinNegN⟩,  ⟨validN,  openN⟩⟩⟩

end  T4OffLM
