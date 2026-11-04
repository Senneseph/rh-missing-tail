/-  T4OffLM  --  THE  0273/0274  XI-PRODUCT  FACE  RECORD  AT  tPT2:
   OFF-BOARD  BOUND-LEVEL  RESIDUAL  (the  T4OffLB...LL  class).

   The  0273  program  (route  (b),  discovery  0273/0273a-r,
   2026-11-03  ->  2026-11-09)  attacked  the  terminal  face
   (claim  (b),  0270):  zero-freeness  of  sigma  in
   (0.1252270103,  1/2)  at  t  >=  tPT2  =  3,000,175,332,800,
   by  the  xi-product  explicit  formula  at  face  height:

       log|zeta(s)|  =  log(1/2)  -  Re  log  phi(s)  +  S(s)  +  U(s),
       S   =  sum  of  f(g;s)  over  the  KNOWN  zeros  (data),
       U   =  Int  f rho dg  (main  term)  +  fluctuation,
     with  the  fluctuation  bounded  by  the  R-vM  per-unit
     count  law  |fluct|  <=  B_unk  (working  class  constant
     B1  =  A0  ln  t  with  A0  =  3.4;  the  0275  provenance
     audit  pins  this  as  a  DATA-LEVEL  class  constant,  not
     the  cited  theorem  value  -  see  T4OffLN  and  entry
     0275  for  the  published  HSXW  2022  explicit  bounds).

   THE  MACHINE  WAS  VALIDATED  END-TO-END  (the  0272
   discipline):  day068  count-residual  GREEN  (worst  3.4e-37);
   the  lshard  reader  repaired  (CUMULATIVE  intra-block
   deltas)  and  validated  on  all  11  shards;  the  t  =  1e9
   anchor  at  the  data  floor;  the  tPT2  unknown-side  main
   term  DUAL  (c4-decomp  g-space  pin  vs  u-substitution
   y-space,  dps-60;  gates  at  t  =  1e9  and  t  =  4e9  both
   PASS  with  relative  agreement  below  1e-30  after  the
   0275  repair;  tPT2  dual  spread  9.002e-6  absolute  on  a
   2.5e12  main  term);  day074  re-probed  at  t  =  tPT2  +  3e9.

   THE  CORRECT  FACE  DISCRIMINANT  (0274  FOURTH  correction):
   the  0273-design  "K'  >  B_unk  implies  exclusion"  was  a
   MISREADING:  B_unk  covers  EVERY  law-conformant  unknown-zero
   configuration  -  including  configurations  with  a  zero  in
   the  probe  disk  -  so  comparing  the  negative  main  term
   K'  against  B_unk  proves  nothing  about  zeros.  The  sound
   quantities  are  the  MEASURED  fluctuation
   fluc  :=  log|zeta(s)|  -  K'  against  the  envelopes:
   (v)  VALIDITY  |fluc|  <=  B_unk;  (n)  NO  EXCLUSION  when
   the  slack  B_unk  -  fluc  is  POSITIVE;  (r)  the  window
   count  of  the  frontier  unit  window  W  =  (tPT2  -  1,
   tPT2  +  1]  as  the  genuine  quantitative  discriminant.

   THE  FIFTH  CORRECTION  (2026-11-09)  -  MAIN-TERM  BIAS:
   the  c4-decomposition  pin  of  the  unknown-side  main  term
   (U_pin_c4  in  day072_face_U_repair.py)  DOUBLE-COUNTED  the
   c4/g^2  tail  mass  beyond  Y2  =  2^24  *  160  *  t:  its
   analytic  tail  term  already  contained  that  mass,  and  a
   second  "tail2"  term  added  it  again.  The  bias  is
   -8,823.2915  at  tPT2  (sigma-flat  to  5e-4)  and  -1.005e7
   at  t  =  1000  tPT2  (the  spurious  "day075  closure  FAIL"
   was  this  bias,  NOT  a  zero  configuration  and  NOT  a
   quadrature  defect).  The  repair  (day072,  0275  unit)
   replaces  tail2  by  the  certified  h160  residual  R2  with
   |h160  +  1/2|  <=  1/5  asserted;  after  the  repair  the
   dual  integrators  agree  to  1.4e-18  (tPT2)  and  1.4e-15
   (t  =  1000  tPT2)  ABSOLUTE.  CONSEQUENCE:  every  K'  and
   fluc  value  of  the  0273a-r/0274-era  face  table  that  used
   the  c4pin  main  term  is  contaminated  by  exactly  this
   bias  (the  u-substitution  integral,  the  S  stream,  the
   zeta  pin,  the  kernels  and  all  TELESCOPED  ENVELOPES  were
   NEVER  affected).  The  corrected  table  is  the  *_n  group
   below  (day072c  re-run,  dual-validated);  the  superseded
   contaminated  values  are  kept  as  the  *_old  group  for  the
   record.  In  particular  the  draft  0274  line  "window  count
   k  <=  33  /  33  /  34  /  34  (5.9x  reduction  of  about
   196)"  is  RETRACTED:  the  corrected  fluc  is  ~236  (optimal
   cut),  not  ~9,060,  so  under  the  same  A0  =  3.4  envelope
   the  window  bound  is  k  <=  348  (WEAKER  than  the  raw
   2-unit  R-vM  count  of  about  195  -  no  refined  reduction
   under  that  envelope).  The  genuinely  certified  window
   reduction  at  tPT2  comes  from  the  PUBLISHED  explicit
   HSXW  2022  S-bound  route  (T4OffLN):  N(t  +  1)  -  N(t  -
   1)  <=  22  (sigma-independent,  no  local  data  required).
   The  VERDICT  OF  0274  IS  UNCHANGED  in  substance:  the
   face  is  OPEN  (no  exclusion),  the  gap  to  exclusion  is
   now  9,759.74  ..  9,778.32  (sigma_A  ..  sigma_N)  -  a
   STRUCTURAL  gap,  not  the  9.4%  of  the  draft;  no  RH
   claim.

   THE  RESULT  (this  module,  corrected):  the  main  term  K'
   is  NEGATIVE  and  FACE-FLAT  (|K'|  <  240)  at  both  data
   cuts;  the  identity  premise  holds  inside  the  certified
   envelope  with  slack  10,066  ..  11,128  (98.1%  ..  97.9%
   of  the  envelope);  and  the  frontier  window  is  certified
   at  k  <=  348  under  the  A0  =  3.4  envelope  (k  <=  22
   under  the  published  HSXW  S-route,  T4OffLN).  No  RH
   claim.

   PROVENANCE  (authoritative  map):  in-repo  zero  ORDINATES
   end  at  gData  =  30,001,045,999.98  (100x  below  the  face
   height);  [Z-PT2]  (Platt-Trudgian,  arXiv:2004.09765,  pinned
   0263)  establishes  ON-LINE-NESS  up  to  tPT2  by  sign-change
   counting  with  interval  arithmetic,  and  records  that  NO
   zero  list  beyond  the  counting  was  generated:  no
   ordinates  in  (gData,  tPT2]  exist  in  the  repo  or  in
   the  cited  record.

   The  numerals  below  are  the  outputs  of  the  validated
   numeric  machine  after  the  0275  repair:  corrected  face
   table  scripts/rh/day072_face_U_repair.py  re-run  (out file
   out_day072c_face_corrected.txt);  the  gData-cut  pin  shift
   (SUM  -  Int  f  rho  =  -7.20996094,  sigma-flat)  from
   scripts/rh/day073b_3e10_sum.py  (out_day073b_3e10_sum.json);
   the  contaminated  0274  draft  table  (out_day072_face_U_repair.txt)
   is  the  *_old  group  (bias  -8,823.2915).  Recorded  as  a
   NAMED  BOUND-LEVEL  RESIDUAL  in  the  house  pattern  (T4OffLL
   S2  class):  arithmetic  over  the  recorded  verified
   numerals,  OFF-BOARD  (no  zeta  evaluation  in  body).  -/

import  Mathlib
import  RhAttack.WinCount

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false
set_option  linter.style.docString  false

open  Real

namespace  T4OffLM

/-  The  face  (claim  (b),  0270  route  (b)  scope):  the
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
    left  edge  VALUE  (probed  for  edge  sharpness,  NOT  a
    member  of  the  OPEN  face)  and  three  interior  points.  -/

def  sigA  :  ℚ  :=  1252270103  / 10 ^ 10    --  0.1252270103  (left  edge  VALUE)
def  sigQ  :  ℚ  :=  1  / 4                  --  0.25
def  sigF  :  ℚ  :=  2  / 5                  --  0.40
def  sigN  :  ℚ  :=  49  / 100               --  0.49

theorem  sigAedgeValue  :  (sigA :  ℝ)  =  (aFace :  ℝ)  :=  by  norm_num  [sigA,  aFace]
theorem  sigQIsFace  :  faceSigma  (sigQ :  ℝ)  :=  by  norm_num  [sigQ,  aFace,  faceSigma]
theorem  sigFIsFace  :  faceSigma  (sigF :  ℝ)  :=  by  norm_num  [sigF,  aFace,  faceSigma]
theorem  sigNIsFace  :  faceSigma  (sigN :  ℝ)  :=  by  norm_num  [sigN,  aFace,  faceSigma]

/-  =================================================================
   THE  SUPERSEDED  0274  DRAFT  VALUES  (contaminated  by  the
   c4pin  tail2  double-count  bias  -8,823.2915;  kept  for  the
   record  -  the  FIFTH  CORRECTION).  Everything  else  in  this
   file  uses  the  corrected  *_n  values.  -/

def  K3Aold  :  ℚ  :=  -(9042185335 : ℚ) / 10 ^ 6       --  -9042.185335  (=  corrected  +  bias)
def  K3Qold  :  ℚ  :=  -(9045537874 : ℚ) / 10 ^ 6       --  -9045.537874
def  K3Fold  :  ℚ  :=  -(9049568635 : ℚ) / 10 ^ 6       --  -9049.568635
def  K3Nold  :  ℚ  :=  -(9051986604 : ℚ) / 10 ^ 6       --  -9051.986604

def  KpinAold  :  ℚ  :=  -(90493952959375 : ℚ) / 10 ^ 10    --  -9049.3952959375
def  KpinQold  :  ℚ  :=  -(90527478349375 : ℚ) / 10 ^ 10    --  -9052.7478349375
def  KpinFold  :  ℚ  :=  -(90567785959375 : ℚ) / 10 ^ 10    --  -9056.7785959375
def  KpinNold  :  ℚ  :=  -(90591965649375 : ℚ) / 10 ^ 10    --  -9059.1965649375

def  flucAold  :  ℚ  :=  905956 / 100            --  9,059.56  (contaminated)
def  flucQold  :  ℚ  :=  905964 / 100            --  9,059.64
def  flucFold  :  ℚ  :=  905986 / 100            --  9,059.86
def  flucNold  :  ℚ  :=  906028 / 100            --  9,060.28

/-  The  bias  itself  (absolute,  the  tail2  double-count):
    I_unk(old)  -  I_unk(corrected)  =  -8,823.2915  (sigma_A/Q/N,
    -8,823.2920  at  sigma_F;  sigma-flat  to  5e-4).  -/
def  biasTPT2  :  ℚ  :=  -(88232915 : ℚ) / 10 ^ 4       --  -8,823.2915

theorem  biasNeg  :  (biasTPT2 : ℝ) < 0  :=  by  norm_num  [biasTPT2]

/-  =================================================================
   THE  CORRECTED  MAIN  TERM  (0275  repair,  day072c  re-run,
   dual-validated  spread  9.002e-6  absolute).  K'  =  S  +
   I_unk  -  Re  log  phi  +  log(1/2)  at  t  =  tPT2:
     K3n   =  the  GLAST  cut  (S  over  the  9,068,473,888
             known  zeros,  I_unk  over  (GLAST,  inf));
     KpinN =  the  gData  OPTIMAL  cut  pin  =  K3n  -  7.2100
             (the  day073b  density  residual  SUM  -  Int,
             sigma-flat  to  8  digits  against  a  9.874e11
             integral).
   K'  is  FACE-FLAT  (|K'|  <  240):  the  near-cancellation  S
   +  I_unk  -  Re  log  phi  is  the  validated  structure.  -/

def  K3An   :  ℚ  :=  -(218893831 : ℚ) / 10 ^ 6      --  -218.893831
def  K3Qn   :  ℚ  :=  -(222246370 : ℚ) / 10 ^ 6      --  -222.246370
def  K3Fn   :  ℚ  :=  -(226276643 : ℚ) / 10 ^ 6      --  -226.276643
def  K3Nn   :  ℚ  :=  -(228695100 : ℚ) / 10 ^ 6      --  -228.695100

def  pinShift  :  ℚ  :=  -(72100 : ℚ) / 10 ^ 4       --  -7.2100  (SUM  -  Int,  day073b)

def  KpinAn  :  ℚ  :=  -(226103831 : ℚ) / 10 ^ 6      --  -226.103831  (gData  pin,  corrected)
def  KpinQn  :  ℚ  :=  -(229456370 : ℚ) / 10 ^ 6      --  -229.456370
def  KpinFn  :  ℚ  :=  -(233486643 : ℚ) / 10 ^ 6      --  -233.486643
def  KpinNn  :  ℚ  :=  -(235905100 : ℚ) / 10 ^ 6      --  -235.905100

theorem  k3nNegA  :  (K3An : ℝ) < 0  :=  by  norm_num  [K3An]
theorem  k3nNegQ  :  (K3Qn : ℝ) < 0  :=  by  norm_num  [K3Qn]
theorem  k3nNegF  :  (K3Fn : ℝ) < 0  :=  by  norm_num  [K3Fn]
theorem  k3nNegN  :  (K3Nn : ℝ) < 0  :=  by  norm_num  [K3Nn]
theorem  kpinnNegA  :  (KpinAn : ℝ) < 0  :=  by  norm_num  [KpinAn]
theorem  kpinnNegQ  :  (KpinQn : ℝ) < 0  :=  by  norm_num  [KpinQn]
theorem  kpinnNegF  :  (KpinFn : ℝ) < 0  :=  by  norm_num  [KpinFn]
theorem  kpinnNegN  :  (KpinNn : ℝ) < 0  :=  by  norm_num  [KpinNn]

/-  FACE-FLAT:  the  corrected  main  term  is  small  at  face
    height  (|K'|  <  240  on  the  gData  pin,  all  four
    sigmas)  -  an  arithmetic  fact  about  the  validated
    machine  output  (the  contaminated  draft  values  sat  at
    -9,042  ..  -9,060  purely  from  the  bias).  -/
def  faceFlatA  :  ℚ  :=  240
theorem  flatAAbs  :  abs (KpinAn : ℝ) < (faceFlatA : ℝ)  :=  by  norm_num  [KpinAn,  faceFlatA]
theorem  flatQAbs  :  abs (KpinQn : ℝ) < (faceFlatA : ℝ)  :=  by  norm_num  [KpinQn,  faceFlatA]
theorem  flatFAbs  :  abs (KpinFn : ℝ) < (faceFlatA : ℝ)  :=  by  norm_num  [KpinFn,  faceFlatA]
theorem  flatNAbs  :  abs (KpinNn : ℝ) < (faceFlatA : ℝ)  :=  by  norm_num  [KpinNn,  faceFlatA]

/-  =================================================================
   THE  CERTIFIED  FLUCTUATION  ENVELOPES  (UNCHANGED  by  the
   FIFTH  CORRECTION  -  pure  kernel  telescoping,  no  main
   term  involved):  exact  monotone-piece  telescoping  with
   B1  =  3.4  ln  tPT2  (the  A0  =  3.4  working  class
   constant;  its  provenance  status  is  pinned  in  0275 /
   T4OffLN):
     Bunk  =  the  FULL  envelope  over  the  unknown  side  at
             the  OPTIMAL  gData  cut  (day073  certified);
     Ewin  =  the  CONDITIONAL  envelope  over  the  zeros
             OUTSIDE  the  frontier  unit  window  W  (window
             edge  budgets  removed).  -/

def  BunkA  :  ℚ  :=  1030285 / 100           --  10302.85  (gData  cut,  full)
def  BunkQ  :  ℚ  :=  1042149 / 100           --  10421.49
def  BunkF  :  ℚ  :=  1069000 / 100           --  10690.00
def  BunkN  :  ℚ  :=  1136476 / 100           --  11364.76

def  EwinA  :  ℚ  :=  999601  / 100           --  9996.01   upper  (9,995.9916  computed)
def  EwinQ  :  ℚ  :=  1000641 / 100           --  10,006.41  upper  (10,006.3657)
def  EwinF  :  ℚ  :=  1001385 / 100           --  10,013.85  upper  (10,013.7905)
def  EwinN  :  ℚ  :=  1001531 / 100           --  10,015.31  upper  (10,015.2338)

/-  =================================================================
   THE  CORRECTED  MEASURED  FLUCTUATION  fluc  :=  log|zeta(s)|
   -  K'_pin  (gData  cut):  LOWER  bounds  of  the  dps-stable
   values  236.273255  /  236.351075  /  236.573934  /
   236.997216  (stable  to  1e-6  across  dps  30/50/80;  the
   GLAST-cut  counterparts  229.063294  ..  229.787251  are  in
   the  day072c  record).  The  contaminated  draft  values
   9,059.56  ..  9,060.28  are  the  *_old  group  above  (bias
   -8,823.2915,  exactly).  -/

def  flucAn  :  ℚ  :=  23627  / 100           --  236.27   (lower  of  236.273255)
def  flucQn  :  ℚ  :=  23635  / 100           --  236.35   (lower  of  236.351075)
def  flucFn  :  ℚ  :=  23657  / 100           --  236.57   (lower  of  236.573934)
def  flucNn  :  ℚ  :=  23699  / 100           --  236.99   (lower  of  236.997216)

/-  THE  WINDOW  KERNEL  EXTREMES  (f  over  W  x  the  face;
    UNCHANGED  -  pure  kernel):  f  <=  -fedge  <  0  at  every
    zero  of  W  with  real  part  in  the  face;  |f_edge|  >=
    the  recorded  LOWER  bounds.  -/

def  fedgeA  :  ℚ  :=  2797  / 100             --  27.97   (|f(tPT2 -/+ 1)|  =  27.970831)
def  fedgeQ  :  ℚ  :=  2800  / 100             --  28.00   (28.006232)
def  fedgeF  :  ℚ  :=  2803  / 100             --  28.03   (28.031570)
def  fedgeN  :  ℚ  :=  2803  / 100             --  28.03   (28.036495)

/-  =================================================================
   (v)  VALIDITY  AT  FACE  HEIGHT:  THE  IDENTITY  PREMISE  HOLDS
   INSIDE  THE  CERTIFIED  ENVELOPE  (corrected  fluc).
   =================================================================
   -/

theorem  validnA  :  (flucAn : ℝ) <= (BunkA : ℝ)  :=  by  norm_num  [flucAn,  BunkA]
theorem  validnQ  :  (flucQn : ℝ) <= (BunkQ : ℝ)  :=  by  norm_num  [flucQn,  BunkQ]
theorem  validnF  :  (flucFn : ℝ) <= (BunkF : ℝ)  :=  by  norm_num  [flucFn,  BunkF]
theorem  validnN  :  (flucNn : ℝ) <= (BunkN : ℝ)  :=  by  norm_num  [flucNn,  BunkN]

/-  =================================================================
   (n)  NO  EXCLUSION:  THE  CERTIFIED  ENVELOPE  IS  OPEN
   (corrected  slacks  -  98%  of  the  full  envelope).
   =================================================================
   -/

def  slackAn  :  ℚ  :=  BunkA - flucAn          --  10,066.58
def  slackQn  :  ℚ  :=  BunkQ - flucQn          --  10,185.14
def  slackFn  :  ℚ  :=  BunkF - flucFn          --  10,453.43
def  slackNn  :  ℚ  :=  BunkN - flucNn          --  11,127.77

theorem  opennA  :  (slackAn : ℝ) > 0  :=  by  norm_num  [slackAn,  BunkA,  flucAn]
theorem  opennQ  :  (slackQn : ℝ) > 0  :=  by  norm_num  [slackQn,  BunkQ,  flucQn]
theorem  opennF  :  (slackFn : ℝ) > 0  :=  by  norm_num  [slackFn,  BunkF,  flucFn]
theorem  opennN  :  (slackNn : ℝ) > 0  :=  by  norm_num  [slackNn,  BunkN,  flucNn]

/-  =================================================================
   (r)  THE  WINDOW-COUNT  BOUND  (corrected,  A0  =  3.4
       envelope):  the  frontier  unit  window  W  =  (tPT2  -  1,
       tPT2  +  1]  contains  at  most  348  zeros  at  each  of
       the  four  probed  sigmas  -  against  about  195  for
       the  raw  2-unit  R-vM  count  under  the  same  constant
       (so  the  refined  discriminant  is  NOT  sharper  than
       the  raw  law  under  A0  =  3.4;  the  draft  0274  line
       "k  <=  33/33/34/34"  is  RETRACTED  as  a  bias
       artifact).  The  published  HSXW  2022  S-route  sharpens
       the  SAME  window  to  at  most  22  (T4OffLN).
   =================================================================
   fluc  =  fluc_X  +  sum_W  f:  |fluc_X|  <=  Ewin  and  sum_W
   f  <=  -k  fedge  (k  zeros  in  W,  each  f  <=  -fedge):
   a  conformant  configuration  with  k  zeros  in  W  requires
   fluc  <=  Ewin  -  k  fedge;  the  theorems  record  that  k
   beyond  348  is  inconsistent  with  the  MEASURED  fluc.  -/

theorem  windownA  :  (EwinA : ℝ) - 349 * (fedgeA : ℝ) < (flucAn : ℝ)  :=  by
  norm_num  [EwinA,  fedgeA,  flucAn]
theorem  windownQ  :  (EwinQ : ℝ) - 349 * (fedgeQ : ℝ) < (flucQn : ℝ)  :=  by
  norm_num  [EwinQ,  fedgeQ,  flucQn]
theorem  windownF  :  (EwinF : ℝ) - 349 * (fedgeF : ℝ) < (flucFn : ℝ)  :=  by
  norm_num  [EwinF,  fedgeF,  flucFn]
theorem  windownN  :  (EwinN : ℝ) - 349 * (fedgeN : ℝ) < (flucNn : ℝ)  :=  by
  norm_num  [EwinN,  fedgeN,  flucNn]

/-  THE  GAP  TO  EXCLUSION  (corrected,  named,  for  0276  and
    beyond):  the  window  is  proven  EMPTY  (k  =  0)  iff
   Ewin  <  fluc  -  |fedge|  (at  least  k  =  1  must  die).
   Corrected  gap  Ewin  -  fluc  =  9,759.74  ..  9,778.32:
   a  STRUCTURAL  gap  (the  draft  "9.4%  sharpening"  line  is
   superseded):  no  known  published  per-unit  count  or  S
   constant  closes  the  window;  the  0275  S-route  count  of
   22  (T4OffLN)  is  the  strongest  certified  statement.  -/

def  gapToExclAn  :  ℚ  :=  EwinA - flucAn      --  9,759.74
def  gapToExclQn  :  ℚ  :=  EwinQ - flucQn      --  9,770.06
def  gapToExclFn  :  ℚ  :=  EwinF - flucFn      --  9,777.28
def  gapToExclNn  :  ℚ  :=  EwinN - flucNn      --  9,778.32

theorem  gapPosnA  :  (gapToExclAn : ℝ) > 0  :=  by  norm_num  [gapToExclAn,  EwinA,  flucAn]
theorem  gapPosnQ  :  (gapToExclQn : ℝ) > 0  :=  by  norm_num  [gapToExclQn,  EwinQ,  flucQn]
theorem  gapPosnF  :  (gapToExclFn : ℝ) > 0  :=  by  norm_num  [gapToExclFn,  EwinF,  flucFn]
theorem  gapPosnN  :  (gapToExclNn : ℝ) > 0  :=  by  norm_num  [gapToExclNn,  EwinN,  flucNn]

/-  =================================================================
   THE  CORRECTED  0274  RECORD  (t  =  tPT2,  gData  cut,  every
   probed  sigma):  the  main  term  is  NEGATIVE  and  face-flat;
   the  identity  premise  HOLDS  inside  the  certified
   envelope  (validn*);  the  slack  is  POSITIVE  (face  OPEN
   -  no  exclusion);  the  frontier  window  is  certified  at
   k  <=  348  under  the  A0  =  3.4  envelope  (k  <=  22
   under  the  published  HSXW  S-route,  T4OffLN).  The
   terminal  face  (claim  (b),  hence  the  hOffCPT2
   residual,  hence  RH)  REMAINS  OPEN  at  this  record.  No
   RH  claim.  -/
theorem  faceOpenAtTPT2  :
    (((K3An : ℝ) < 0 ∧ (KpinAn : ℝ) < 0) ∧
      (((flucAn : ℝ) <= (BunkA : ℝ)) ∧ ((slackAn : ℝ) > 0)))
    ∧  (((K3Qn : ℝ) < 0 ∧ (KpinQn : ℝ) < 0) ∧
      (((flucQn : ℝ) <= (BunkQ : ℝ)) ∧ ((slackQn : ℝ) > 0)))
    ∧  (((K3Fn : ℝ) < 0 ∧ (KpinFn : ℝ) < 0) ∧
      (((flucFn : ℝ) <= (BunkF : ℝ)) ∧ ((slackFn : ℝ) > 0)))
    ∧  (((K3Nn : ℝ) < 0 ∧ (KpinNn : ℝ) < 0) ∧
      (((flucNn : ℝ) <= (BunkN : ℝ)) ∧ ((slackNn : ℝ) > 0)))  :=
  ⟨⟨⟨k3nNegA,  kpinnNegA⟩,  ⟨validnA,  opennA⟩⟩,
   ⟨⟨k3nNegQ,  kpinnNegQ⟩,  ⟨validnQ,  opennQ⟩⟩,
   ⟨⟨k3nNegF,  kpinnNegF⟩,  ⟨validnF,  opennF⟩⟩,
   ⟨⟨k3nNegN,  kpinnNegN⟩,  ⟨validnN,  opennN⟩⟩⟩

end  T4OffLM
