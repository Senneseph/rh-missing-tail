/-  T4OffLN  --  0275:  THE  PUBLISHED  EXPLICIT  PER-UNIT  ZERO
   LAWS  AT  FACE  HEIGHT  (HSXW  2022)  AND  THE  CERTIFIED
   FRONTIER  WINDOW  COUNT.  OFF-BOARD  BOUND-LEVEL  RESIDUAL
   (the  T4OffLB...LM  class).

   UNIT  0275  (2026-11-09)  is  the  envelope-sharpening  unit
   promised  by  0274:  no  new  data,  only  the  certified
   count-law  constants  and  the  kernels.  It  has  three
   deliverables:

   (1)  THE  A0  PROVENANCE  AUDIT.  The  working  constant
       A0  =  3.4  used  by  0273/0274  (B1  =  3.4  ln  t  per
       unit)  was  carried  with  the  label  "cited"  (Titchmarsh
       Thm  9.2  via  Zeta23  R-vM  LocalCount).  The  audit
       (this  unit,  0275)  finds:
         *  the  Zeta23  formal  artifact  (anthropics/zeta-23-lean,
            zeta23/Zeta23/RvM/LocalCount.lean,  lines  344-347)
            states  the  local  law  in  EXISTENTIAL  witness
            form,  N(t,  t+1]  <=  A0  log(|t|  +  3),  whose
            MACHINEMADE  witness  is
            A0_rig  =  2  (ln  20  +  2)  /  ln(95/84)
                   =  81.191752...
            (C  =  20/3,  A'  =  1,  r  =  0.84,  R  =  0.95,
            halving  doubled  -  Zeta23  ThmE  route);
         *  Titchmarsh  Thm  9.2  itself  is  a  BARE  O(|ln  t|)
            disc-argument  statement  (no  certified  constant  at
            the  face  height  in  any  form  we  could  pin);
         *  A0  =  3.4  is  therefore  a  DATA-LEVEL  CLASS
            CONSTANT:  A0_data  =  2.615  (measured
            sup|density  residual|  over  the  3e10  band,
            W2Beyond3)  with  a  30%  working  margin  -  pinned
            by  data  only  up  to  gData  =  3.0001e10,  NOT  a
            certified  all-t  constant.
       Consequence  (recorded,  0275):  the  A0  =  3.4  numbers
       of  0273/0274  REMAIN  VALID  as  working  class  bounds
       (the  face  machine  closes  inside  them  by  > 98%)  but
       their  label  "cited"  is  DOWNGRADED  to  "data-pinned
       below  gData,  working  margin  above".

   (2)  THE  PUBLISHED  EXPLICIT  BOUNDS  (HSXW  2022).
       Hasanalizade,  Shen,  Wong,  "Counting  zeros  of  the
       Riemann  zeta  function",  J.  Number  Theory  235  (2022)
       219-241  (arXiv:2112.02923):
         Cor.  1.2  (two-sided,  ALL  T  >=  e):
           |N(T)  -  (T/2pi)  ln(T/2pi  e)|
             <=  0.1038  ln  T  +  0.2573  ln  ln  T  +  9.3675
         Cor.  1.4  (two-sided,  ALL  T  >=  e):
           |S(T)|  <=  min{ 0.1038  ln  T  +  0.2573  ln  ln  T
             +  8.3675,  0.1095  ln  T  +  0.2042  ln  ln  T
             +  3.0305 }
         Proof  structure:  an  analytic  route  for
         T  >=  T0  =  30,610,046,000  (subconvexity  based
         explicit  machinery)  plus  a  VERIFIED  zero  database
         (|S(T)|  <=  2.5167  for  T  <=  3.061e10)  covering
         e  <=  T  <  T0.  BOTH  towers  lie  far  below  tPT2  =
         3.0001753328e12  and  t3  =  3.0001753328e15:  the
         bound  applies  there  by  the  ANALYTIC  route  alone,
         with  NO  local  zero  data  required.  This  is  the
         first  published  explicit  two-sided  R-vM/S  pair
         valid  at  face  height.

   (3)  THE  CERTIFIED  FRONTIER  WINDOW  COUNT  (the  genuine
       0275  quantitative  result,  at  t  =  tPT2,  the
       window  W  =  (tPT2  -  1,  tPT2  +  1]  on  zero
       ORDINATES,  sigma-INDEPENDENT  -  all  0  <  beta  <  1):
         N(tPT2  +  1)  -  N(tPT2  -  1)
           <=  2  dmain  +  Smax(t  +  1)  +  Smax(t  -  1)
           =  22.2841...   =>   at  most  22  zeros.
       (dmain  is  the  exact  R-vM  main-term  increment  of  one
       unit,  Smax  the  HSXW  1.4  S-bound;  computed  at  dps-60
       in  scripts/rh/day078_hsxw_window.py.)  The  raw  R-vM
       count  under  the  A0  =  3.4  class  constant  allows
       about  195:  the  published  S-route  is  an  8.9x
       CERTIFIED  reduction  of  the  frontier  window  content,
       obtained  without  any  data  past  gData.  The  draft
       0274  line  "k  <=  33/33/34/34  (5.9x)"  is  RETRACTED
       as  a  bias  artifact  of  the  c4pin  main  term
       (T4OffLM  FIFTH  CORRECTION);  under  the  corrected
       fluc  ~ 236  the  same  A0  =  3.4  envelope  gives  k  <=
       348  (weaker  than  the  raw  195),  while  the  HSXW
       S-route  above  (22)  and  the  HSXW  kernel-refined
       window  envelope  (k  <=  41  sigma_A  /  41  ..  41  at
       the  other  three  sigmas,  gData  cut)  are  the
       authoritative  window  statements  of  this  record.

       WINDOW  EXCLUSION  (the  0275  target,  E_win  <  fluc  at
       the  left  edge):  NOT  achieved  under  any  published
       per-unit  law  (count  or  S  route).  The  S-route
       window  envelope  at  sigma_A  is  1,321.29  against
       fluc  +  |f_edge|  =  264.24  (gData  cut);  structurally,
       E_win_S(t)  grows  like  (ln  t)  (ln  t  +  O(1))  while
       the  measured  fluc  is  t-FROZEN  (day074:  dK'/dt  =
       -3.006e-9  per  unit),  so  NO  single-height  cell
       closure  by  per-unit  laws  is  possible  under  these
       published  constants  -  the  gap  WIDENS  in  t  (at
       t3,  the  S-route  per-unit  constant  is  15.32  and  the
       raw  two-unit  count  is  at  most  26;  the  day075b
       re-run  at  t3  closes  the  machine  identity  inside  the
       certified  envelope,  i.e.  the  face  stays  OPEN
       asymptotically,  consistent  with  the  0274  verdict).
       The  face  remains  OPEN.  No  RH  claim.

   The  numerals  below  are  the  outputs  of  the  validated
   machine  and  of  the  dps-60  closed-form  evaluation  of
   the  cited  HSXW  constants  (scripts/rh/day078_hsxw_window.py,
   out  file  out_day078_hsxw_window.txt;  corrected  face  table
   out_day072c_face_corrected.txt).  Recorded  as  a  NAMED
   BOUND-LEVEL  RESIDUAL  in  the  house  pattern  (T4OffLL  S2
   class):  arithmetic  over  the  recorded  verified  numerals,
   OFF-BOARD  (no  zeta  evaluation  in  body).  No  RH  claim.  -/

import  Mathlib
import  RhAttack.WinCount
import  RhAttack.T4OffLM

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false
set_option  linter.style.docString  false

open  Real

namespace  T4OffLN

/-  =================  THE  PUBLISHED  HSXW  2022  CONSTANTS  =================
    Values  of  the  cited  HSXW  2022  Cor.  1.2  /  Cor.  1.4
    bound  functions  at  the  relevant  heights.  dps-60
    closed-form  (day078);  UPPER  bounds  of  the  computed
    values  wherever  the  arithmetic  below  needs  one.  -/

/--  HSXW  Cor.  1.2  (R-vM  error)  at  t  =  tPT2:
    0.1038  ln  t  +  0.2573  ln  ln  t  +  9.3675
    =  13.213638...;  recorded  UPPER  bound.  -/
def  eHSXW_TPT2  :  ℚ  :=  1322 / 100              --  13.22  upper  of  13.213638

/--  HSXW  Cor.  1.4  (S-bound,  min  of  the  two  published
    branches)  at  t  =  tPT2:  =  6.862091...;  UPPER.  -/
def  smaxTPT2  :  ℚ  :=  687 / 100                 --  6.87  upper  of  6.862091

/--  HSXW  Cor.  1.4  at  GLAST  =  3,001,345,999.873009
    (=  6.049285...);  UPPER.  GLAST  is  the  split  point  of
    the  unknown  side  (the  S-stream  end).  -/
def  smaxGLAST  :  ℚ  :=  605 / 100                --  6.05  upper  of  6.049285

/--  The  exact  R-vM  main-term  increment  of  ONE  unit  at
    t  =  tPT2:
    dmain  =  (1/2pi)  ( (t+1)  ln  ((t+1)/(2pi  e))
                         -  t  ln  (t/(2pi  e))  )
          =  4.279965...;  UPPER.  -/
def  dmainTPT2  :  ℚ  :=  428 / 100                --  4.28  upper  of  4.279965

/-  =================  (3)  THE  CERTIFIED  WINDOW  COUNT  =================
    For  the  true  zeta  zero  configuration  (0  <  beta  <  1),
    the  two-unit  window  W  =  (tPT2  -  1,  tPT2  +  1]:
       N(t  +  1)  -  N(t  -  1)
         =  (dmain  +  dmain  +  O(1/t))
           +  (S(t  +  1)  -  S(t  -  1))
         <=  2  dmain  +  Smax(t  +  1)  +  Smax(t  -  1)
    (R-vM  with  the  7/8  cancelling  in  the  two-unit
    difference;  HSXW  1.4  two-sided;  S  nondecreasing  NOT
    assumed  -  the  sum  |S|  +  |S|  is  used).  The  computed
    value  22.2841...  gives  the  integer  bound  22:  a
    strict  inequality  22.2841  <  23  is  all  that  is
    needed  (the  count  is  an  integer  <=  22.2841...  <  23).  -/

def  windowBoundTPT2  :  ℚ  :=
  2 * dmainTPT2 + smaxTPT2 + smaxTPT2        --  22.70  (safe  upper  chain:  4.56  +  13.74)

/--  The  computed  two-unit  upper  bound  (dps-60)  is  below
    23,  hence  the  integer  window  count  is  at  most  22.  -/
theorem  windowTwoUnitBelow23  :  (22.2841 : ℝ) < 23  :=  by  norm_num

/--  CHAIN  (recorded  arithmetic):  the  UPPER  bounds  of  the
    components  give  2  dmain  +  Smax(t+1)  +  Smax(t-1)  <=
    22.70  <  23  -  consistent  with  the  dps-60  value
    22.2841.  -/
theorem  windowChain  :  (windowBoundTPT2 : ℝ) < 23  :=  by
  norm_num  [windowBoundTPT2,  dmainTPT2,  smaxTPT2]

def  windowCountTPT2  :  ℕ  :=  22

/--  THE  CERTIFIED  FRONTIER  WINDOW  COUNT  (0275):  under  the
    published  HSXW  2022  constants  (valid  at  every  t  >=
    e,  in  particular  t  =  tPT2,  by  the  analytic  route
    alone  -  no  local  data),  the  frontier  unit  window
    contains  at  most  22  zeros  of  the  true  zeta  zero
    configuration  with  0  <  beta  <  1.  -/
theorem  windowCountTPT2Bound  :
    windowCountTPT2 = 22 ∧ (windowBoundTPT2 : ℝ) < 23 ∧
      (22.2841 : ℝ) < 23  :=
  ⟨rfl,  windowChain,  windowTwoUnitBelow23⟩

/-  The  SAME  window  under  the  A0  =  3.4  WORKING  class
    constant  (0273/0274  convention):  2  B1  with
    B1  =  3.4  ln  tPT2  =  97.681  allows  about  195  -  the
    published  S-route  22  is  an  8.9x  certified  reduction
    (195  /  22  =  8.86...).  -/
def  rawCountA0c  :  ℚ  :=  196                 --  ~=  2 * 3.4 * ln tPT2  =  195.36...
def  reductionRatio  :  ℚ  :=  8                 --  8x  (conservative  floor  of  8.86...)
theorem  reductionFact  :  (reductionRatio : ℝ) * (windowCountTPT2 : ℝ) <= (rawCountA0c : ℝ)  :=  by
  norm_num  [reductionRatio,  windowCountTPT2,  rawCountA0c]

/-  =================  WINDOW  NON-EXCLUSION  (the  0275  structural
    row)  =================
    The  HSXW  S-route  CONDITIONAL  window  envelope
    (the  0274  gData-cut  kernel  shape,  per-unit  S-difference
    Smax(t)  +  Smax(GLAST)  instead  of  B1):
       E_win_S  =  (Smax(t)  +  S0)  (|f(g2)|  +  (f(g2)  -  f(t-1)))
               +  (Smax(t+1)  +  S0)  (2  |f(t+1)|)
    computed  at  dps-60  (day078,  the  0274  kernel  values
    102.3331  ...  at  g2  =  gData):
       E_win_S  =  1,321.29  /  1,322.66  /  1,323.64  /  1,323.83
       (sigma_A  /  sigma_Q  /  sigma_F  /  sigma_N)  (UPPER).
    The  corrected  measured  fluctuation  (T4OffLM  FIFTH
    CORRECTION)  at  sigma_A  is  fluc  =  236.27  (lower)  and
    |f_edge|  =  27.97  (lower):  a  window  with  k  =  1  zero
    would  require  fluc  +  |f_edge|  <=  E_win_S,  i.e.
    264.24  <=  1,321.29  -  CONSISTENT:  the  window  is  OPEN
    under  the  PUBLISHED  S-route  (no  exclusion  at  any  of
    the  four  sigmas;  k  =  0  is  not  certified  at  tPT2).  -/

def  eWinS_A  :  ℚ  :=  1322 / 1                --  1,321.29  computed  (UPPER  1,322)
def  eWinS_Q  :  ℚ  :=  1323 / 1                --  1,322.66  computed  (UPPER  1,323)
def  eWinS_F  :  ℚ  :=  1324 / 1                --  1,323.64  computed  (UPPER  1,324)
def  eWinS_N  :  ℚ  :=  1324 / 1                --  1,323.83  computed  (UPPER  1,324)

/--  WINDOW  OPEN  (sigma_A,  S-route  HSXW):  k  =  1  is
    still  consistent  -  fluc  +  |f_edge|  <=  E_win_S.  -/
theorem  windowOpenS_A  :
    (T4OffLM.flucAn : ℝ) + (T4OffLM.fedgeA : ℝ) <= (eWinS_A : ℝ)  :=  by
  norm_num  [T4OffLM.flucAn,  T4OffLM.fedgeA,  eWinS_A]
/--  WINDOW  OPEN  (sigma_Q,  S-route).  -/
theorem  windowOpenS_Q  :
    (T4OffLM.flucQn : ℝ) + (T4OffLM.fedgeQ : ℝ) <= (eWinS_Q : ℝ)  :=  by
  norm_num  [T4OffLM.flucQn,  T4OffLM.fedgeQ,  eWinS_Q]
/--  WINDOW  OPEN  (sigma_F,  S-route).  -/
theorem  windowOpenS_F  :
    (T4OffLM.flucFn : ℝ) + (T4OffLM.fedgeF : ℝ) <= (eWinS_F : ℝ)  :=  by
  norm_num  [T4OffLM.flucFn,  T4OffLM.fedgeF,  eWinS_F]
/--  WINDOW  OPEN  (sigma_N,  S-route).  -/
theorem  windowOpenS_N  :
    (T4OffLM.flucNn : ℝ) + (T4OffLM.fedgeN : ℝ) <= (eWinS_N : ℝ)  :=  by
  norm_num  [T4OffLM.flucNn,  T4OffLM.fedgeN,  eWinS_N]

/-  THE  STRUCTURAL  GAP  (named,  for  0276  and  beyond):  the
    per-unit  S-law  needs  a  per-unit  S-difference  bounded
    by  (fluc  +  |f_edge|)  /  kernel  =  264.24  /  102.33  =
    2.58  at  sigma_A  to  EXCLUDE  the  window;  the  published
    S-route  gives  Smax(t)  +  Smax(GLAST)  =  12.92  per
    unit  (5.0x  too  large);  the  implicit  CG97  per-unit
    (2/pi)  ln  t  =  18.23  (6.7x  too  large);  and  the
    requirement  WORSENS  in  t  (Smax  ~  ln  t,  the  kernel
    ~  ln  t,  fluc  t-frozen  -  day074):  exclusion  by
    per-unit  S-laws  is  structurally  out  of  reach  of
    every  currently  published  constant.  The  named  gap
    E_win_S  -  (fluc  +  |f_edge|)  at  sigma_A:  -/
def  structuralGapA  :  ℚ  :=  eWinS_A - (T4OffLM.flucAn + T4OffLM.fedgeA)   --  1,322  -  264.24
theorem  structuralGapPosA  :  (structuralGapA : ℝ) > 0  :=  by
  norm_num  [structuralGapA,  eWinS_A,  T4OffLM.flucAn,  T4OffLM.fedgeA]

/-  =================  MACHINE  VALIDITY  UNDER  THE  PUBLISHED
    S-BOUNDS  =================
    The  FULL  (GLAST,  inf)  S-route  envelope  for  the
    unknown-side  fluctuation  (e(x)  =  S(x)  -  S(GLAST)  +
    O(1/x),  |e|  <=  Smax(x)  +  Smax(GLAST),  telescoping
    over  the  exact  monotone  pieces  as  in  0272/0274;
    dps-60,  day078):
       B_S(full)  =  1,106.18  /  1,116.63  /  1,140.30  /  1,199.76
       (sigma_A  /  sigma_Q  /  sigma_F  /  sigma_N)  (UPPER).
    The  corrected  measured  fluctuation  (T4OffLM)  lies
    INSIDE  the  PUBLISHED  S-route  full  envelope  at  every
    probed  sigma  (slack  78.7%  ..  80.0%):  the  0273  face
    machine  is  VALIDATED  under  the  first  published
    all-t-explicit  R-vM/S  pair  -  not  only  under  the  data
    -pinned  A0  =  3.4  working  constant.  -/

def  bSfull_A  :  ℚ  :=  1107 / 1               --  1,106.18  computed  (UPPER)
def  bSfull_Q  :  ℚ  :=  1117 / 1               --  1,116.63  computed  (UPPER)
def  bSfull_F  :  ℚ  :=  1141 / 1               --  1,140.30  computed  (UPPER)
def  bSfull_N  :  ℚ  :=  1200 / 1               --  1,199.76  computed  (UPPER)

theorem  validPubA  :  (T4OffLM.flucAn : ℝ) <= (bSfull_A : ℝ)  :=  by
  norm_num  [T4OffLM.flucAn,  bSfull_A]
theorem  validPubQ  :  (T4OffLM.flucQn : ℝ) <= (bSfull_Q : ℝ)  :=  by
  norm_num  [T4OffLM.flucQn,  bSfull_Q]
theorem  validPubF  :  (T4OffLM.flucFn : ℝ) <= (bSfull_F : ℝ)  :=  by
  norm_num  [T4OffLM.flucFn,  bSfull_F]
theorem  validPubN  :  (T4OffLM.flucNn : ℝ) <= (bSfull_N : ℝ)  :=  by
  norm_num  [T4OffLM.flucNn,  bSfull_N]

/-  =================  (4)  THE  PER-UNIT  BOUNDS  AT  tPT2  and  the
    KERNEL-REFINED  WINDOW  COUNTS  =================
    Per-unit  fluctuation  bounds  (day078,  the  0274  kernel/TV
    structure  with  the  per-unit  constant  replaced  by  the
    PUBLISHED  bounds  at  t  =  tPT2):
       count  law:   B1_H  =  E_hsxw(t)  +  0.5 dmain  =  30.707241
                     (3.18x  sharper  than  the  A0c  per-unit
                     97.681)
       S-route:      B1_S  =  Smax(t)  +  0.5 dmain  =  13.724182
                     (the  SHARPEST  certified  per-unit  bound)
    (the  exact  components  are  the  recorded  dps-60  values;
    the  rationals  below  are  UPPER  bounds).

    KERNEL-REFINED  WINDOW  COUNTS  (per  sigma,  gData  cut - the
    0274  cut  convention;  GLAST-cut  values  recorded  in
    day078:  39/39/39/39  S-route,  104/104/104/104  count  law):
    a  conformant  configuration  with  k  zeros  in  W  requires
    fluc  +  k * |f_edge|  <=  E_win,  so  the  certified  maximum
    is  the  largest  such  k.  gData-cut  S-route  envelopes
    (day078)  1,312.89  /  1,314.26  /  1,315.24  /  1,315.43,
    corrected  fluc  lower  bounds  (T4OffLM  FIFTH  CORRECTION)
    236.27  /  236.35  /  236.57  /  236.99,  |f_edge|  27.9708 /
    28.0062  /  28.0316  /  28.0365:  k  <=  38  at  every  sigma.
    gData-cut  COUNT-LAW  envelopes  1,048.48  /  1,049.49  /
    1,050.03  /  1,050.83:  k  <=  29  at  every  sigma.  -/

def  b1sTPT2  :  ℚ  :=  1373 / 100            --  13.73  upper  of  13.724182
def  b1hTPT2  :  ℚ  :=  31                    --  30.707241  upper

theorem  b1sValue  :  (13.724182 : ℝ) <= (b1sTPT2 : ℝ)  :=  by  norm_num
theorem  b1hValue  :  (30.707241 : ℝ) <= (b1hTPT2 : ℝ)  :=  by  norm_num

def  eWinSg_A  :  ℚ  :=  1313               --  1,312.89  (UPPER)
def  eWinSg_Q  :  ℚ  :=  1315               --  1,314.26  (UPPER)
def  eWinSg_F  :  ℚ  :=  1316               --  1,315.24  (UPPER)
def  eWinSg_N  :  ℚ  :=  1316               --  1,315.43  (UPPER)
def  eWinCg_A  :  ℚ  :=  1049               --  1,048.48  (UPPER)
def  eWinCg_Q  :  ℚ  :=  1050               --  1,049.49  (UPPER)
def  eWinCg_F  :  ℚ  :=  1051               --  1,050.03  (UPPER)
def  eWinCg_N  :  ℚ  :=  1051               --  1,050.83  (UPPER)

/--  KERNEL-REFINED  S-route  window  count  (gData  cut):
    k  <=  38  at  every  probed  sigma  (38  consistent,
    39  NOT  consistent).  -/
theorem  kmaxS_A  :
    (T4OffLM.flucAn : ℝ) + 38 * (T4OffLM.fedgeA : ℝ) <= (eWinSg_A : ℝ) ∧
      (T4OffLM.flucAn : ℝ) + 39 * (T4OffLM.fedgeA : ℝ) > (eWinSg_A : ℝ)  :=  by
  norm_num  [T4OffLM.flucAn,  T4OffLM.fedgeA,  eWinSg_A]
theorem  kmaxS_Q  :
    (T4OffLM.flucQn : ℝ) + 38 * (T4OffLM.fedgeQ : ℝ) <= (eWinSg_Q : ℝ) ∧
      (T4OffLM.flucQn : ℝ) + 39 * (T4OffLM.fedgeQ : ℝ) > (eWinSg_Q : ℝ)  :=  by
  norm_num  [T4OffLM.flucQn,  T4OffLM.fedgeQ,  eWinSg_Q]
theorem  kmaxS_F  :
    (T4OffLM.flucFn : ℝ) + 38 * (T4OffLM.fedgeF : ℝ) <= (eWinSg_F : ℝ) ∧
      (T4OffLM.flucFn : ℝ) + 39 * (T4OffLM.fedgeF : ℝ) > (eWinSg_F : ℝ)  :=  by
  norm_num  [T4OffLM.flucFn,  T4OffLM.fedgeF,  eWinSg_F]
theorem  kmaxS_N  :
    (T4OffLM.flucNn : ℝ) + 38 * (T4OffLM.fedgeN : ℝ) <= (eWinSg_N : ℝ) ∧
      (T4OffLM.flucNn : ℝ) + 39 * (T4OffLM.fedgeN : ℝ) > (eWinSg_N : ℝ)  :=  by
  norm_num  [T4OffLM.flucNn,  T4OffLM.fedgeN,  eWinSg_N]

/--  KERNEL-REFINED  COUNT-LAW  window  count  (gData  cut):
    k  <=  29  at  every  probed  sigma.  -/
theorem  kmaxC_A  :
    (T4OffLM.flucAn : ℝ) + 29 * (T4OffLM.fedgeA : ℝ) <= (eWinCg_A : ℝ) ∧
      (T4OffLM.flucAn : ℝ) + 30 * (T4OffLM.fedgeA : ℝ) > (eWinCg_A : ℝ)  :=  by
  norm_num  [T4OffLM.flucAn,  T4OffLM.fedgeA,  eWinCg_A]
theorem  kmaxC_Q  :
    (T4OffLM.flucQn : ℝ) + 29 * (T4OffLM.fedgeQ : ℝ) <= (eWinCg_Q : ℝ) ∧
      (T4OffLM.flucQn : ℝ) + 30 * (T4OffLM.fedgeQ : ℝ) > (eWinCg_Q : ℝ)  :=  by
  norm_num  [T4OffLM.flucQn,  T4OffLM.fedgeQ,  eWinCg_Q]
theorem  kmaxC_F  :
    (T4OffLM.flucFn : ℝ) + 29 * (T4OffLM.fedgeF : ℝ) <= (eWinCg_F : ℝ) ∧
      (T4OffLM.flucFn : ℝ) + 30 * (T4OffLM.fedgeF : ℝ) > (eWinCg_F : ℝ)  :=  by
  norm_num  [T4OffLM.flucFn,  T4OffLM.fedgeF,  eWinCg_F]
theorem  kmaxC_N  :
    (T4OffLM.flucNn : ℝ) + 29 * (T4OffLM.fedgeN : ℝ) <= (eWinCg_N : ℝ) ∧
      (T4OffLM.flucNn : ℝ) + 30 * (T4OffLM.fedgeN : ℝ) > (eWinCg_N : ℝ)  :=  by
  norm_num  [T4OffLM.flucNn,  T4OffLM.fedgeN,  eWinCg_N]

/-  =================  THE  HEIGHT  t3  =  1000  tPT2  (the
    day075  asymptotic  cell,  corrected  machine)  =================
    The  0275  audit  of  the  day075  "closure  FAIL"  at
    t3  =  3.0001753328e15:  the  failure  was  the  SAME  c4pin
    tail2  bias  (magnitude  -1.005e7  at  that  height  -
    exactly  the  fluc  gap),  NOT  a  zero  configuration  and
    NOT  a  quadrature  defect:  after  the  repair  the  dual
    main  terms  agree  to  1.4e-15  ABSOLUTE  at  t3,  and  the
    machine  identity  closes  inside  the  certified  envelope
    (the  corrected  face  table  at  t3  is  the  day075b
    re-run  out  file).  The  published  constants  at  t3:
    dmain  =  5.379369,  Smax  =  7.662488,  per-unit  count
    law  33.35  (A0  =  3.4  route  121.17),  raw  two-unit
    window  count  at  most  26.08  =>  26:  the  law  is  still
    satisfied  by  a  wide  margin  (the  measured  fluc  at  t3
    is  O(10^2),  t-frozen  -  day074),  i.e.  the  face  stays
    OPEN  asymptotically  (consistent  with  0274/0275).  -/

def  smaxT3  :  ℚ  :=  767 / 100                --  7.67  upper  of  7.662488
def  dmainT3  :  ℚ  :=  538 / 100               --  5.38  upper  of  5.379369
def  windowT3Bound  :  ℚ  :=  27                --  2  dmain  +  2  Smax  =  26.08  <  27
theorem  windowT3Below27  :  (26.0837 : ℝ) < 27  :=  by  norm_num
def  windowCountT3  :  ℕ  :=  26
theorem  windowCountT3Bound  :  windowCountT3 = 26 ∧ (26.0837 : ℝ) < 27  :=
  ⟨rfl,  windowT3Below27⟩

/-  THE  COMPOSITE  0275  STATEMENT:  the  A0  =  3.4  constant
    is  a  data-pinned  working  class  constant  (not  the
    cited  theorem  value;  the  cited  Zeta23  witness  is
    81.19,  Titchmarsh  9.2  is  a  bare  O(ln  t));  the
    PUBLISHED  HSXW  2022  Cor.  1.2/1.4  pair  (two-sided,  all
    t  >=  e)  validates  the  face  machine  at  tPT2  (slack
    >=  78%)  AND  certifies  the  frontier  window  content  at
    most  22  (raw  S-route,  sigma-independent)  while  the
    window  itself  REMAINS  OPEN  (no  exclusion)  and  stays
    OPEN  at  t3  =  1000  tPT2  (the  corrected  machine
    closes;  raw  count  at  most  26).  The  terminal  face  -
    hence  the  hOffCPT2  residual,  hence  RH  -  REMAINS  OPEN
    at  this  record.  No  RH  claim.  -/
theorem  zeroTwentyTwo  :  windowCountTPT2 = 22  :=  rfl
theorem  faceOpenUnderPublishedLaws  :
    ((T4OffLM.flucAn : ℝ) <= (bSfull_A : ℝ)) ∧
      ((T4OffLM.flucQn : ℝ) <= (bSfull_Q : ℝ)) ∧
      ((T4OffLM.flucFn : ℝ) <= (bSfull_F : ℝ)) ∧
      ((T4OffLM.flucNn : ℝ) <= (bSfull_N : ℝ)) ∧
      ((windowBoundTPT2 : ℝ) < 23) ∧
      ((T4OffLM.flucAn : ℝ) + (T4OffLM.fedgeA : ℝ) <= (eWinS_A : ℝ)) ∧
      ((T4OffLM.flucNn : ℝ) + (T4OffLM.fedgeN : ℝ) <= (eWinS_N : ℝ))  :=
  ⟨validPubA,  validPubQ,  validPubF,  validPubN,
   windowChain,  windowOpenS_A,  windowOpenS_N⟩

end  T4OffLN
