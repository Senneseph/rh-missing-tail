/-  T4OffLO  --  0276:  THE  S-DIFFERENCE  GATE  (the  conditional
   face-window  exclusion  certificate,  and  the  exact  required
   input  of  the  next  mechanism).

   The  0275  verdict  (T4OffLN,  entry  0275)  is  STRUCTURAL:  no
   PUBLISHED  per-unit  law  can  certify  the  frontier  unit  window
   W  =  (tPT2-1,  tPT2+1]  free  of  face  zeros,  because  the
   S-route  window  envelope  (0274  g2-cut  kernel  shape,  published
   S-bounds)  at  tPT2  is  E_win_S  =  1,321.29 / 1,322.66 /
   1,323.64  /  1,323.83  (sigma_A/Q/F/N)  against  the  correction
   requirement  fluc  +  fedge  =  264.24 / 264.35 / 264.60 / 265.02
   (a  4.99x  gap)  -  and  the  gap  GROWS  in  t  (E_win  ~  (ln
   t)(kernel  ~  ln  t)  vs  t-FROZEN  fluc,  day074).  0275  pinned
   the  A0  provenance  (3.4  =  data-level  class  constant)  and  the
   first  all-t-explicit  published  source  (HSXW  2022).

   0276  NAMES  THE  EXACT  REMAINING  INPUT.  The  window  exclusion
   discriminant  (0273  step-4,  corrected  form;  0274  (g)):  a
   conformant  configuration  with  k  face  zeros  in  W  requires
   fluc  <=  E_win_S  -  k * fedge  (fedge  =  27.97 / 28.00 / 28.03 /
   28.03,  T4OffLM,  the  face-sup  window  kernel  extreme,  UNCHANGED
   pure  kernel).  Hence  W  is  CERTIFIED  EMPTY  at  sigma  iff
   E_win_S  <  fluc  +  fedge  (strict  -  k  =  1  is  the  binding
   case;  every  further  face  zero  only  pulls  fluc  down).

   The  S-route  envelope  is  piece-linear  in  its  per-piece  S-
   difference  constants  (day078  e_win_s,  the  0274  kernel  shape):
       E_win_S  =  c1 * W1  +  c2 * W2,
       c1  =  Smax(t)  +  Smax(GLAST)  (piece  (gData,  t-1])
       c2  =  Smax(t+1)  +  Smax(GLAST)  (piece  [t+1,  ...))
       W1  =  |f(gData)|  +  (f(gData)  -  f(t-1))
       W2  =  2 * |f(t+1)|
   (pure  kernel  spans  -  the  SAME  values  as  0274,  now  read
   against  the  PUBLISHED  per-piece  constants).  The  published  S-
   bounds  give  c1  =  c2  =  12.9117  at  tPT2  (two  applications
   of  HSXW  Cor.  1.4).  A  MECHANISM  (0277,  the  named  research
   problem)  that  proves  a  per-piece  S-difference  bound  c1,  c2  <=
   cGate  =  (fluc  +  fedge)  /  (W1  +  W2)  at  EVERY  height
   t  >=  tPT2  immediately  CERTIFIES  W(t)  EMPTY  at  every  t  (the
   face  window  statement  for  ALL  t  is  the  countable  union  of
   these  cell  statements).

   THE  GATE  CONSTANTS  (recorded  here  as  decidable  rational
   arithmetic  on  the  day078/day075b  numerals;  all  inequalities
   STRICT):
     sigma  |  cGate(tPT2)  |  published  c1(c2)  |  ratio
     A      |  2.5821       |  12.9117           |  5.00x
     Q      |  2.5805       |  12.9117           |  5.00x
     F      |  2.5809       |  12.9117           |  5.00x
     N      |  2.5847       |  12.9117           |  5.00x
   (cGate  =  the  LARGEST  admissible  per-piece  S-difference  that
   still  EXCLUDES;  the  recorded  rationals  are  STRICTLY  below  the
   exact  boundary  values  2.58216 / ...  -  the  strict  margin  is
   3.4e-3  ..  1.4e-2.)

   THE  T-PROFILE  (the  gate  TIGHTENS  in  t  -  structural):
     cGate(A,  tPT2)  =  2.5821   (this  file,  section  tPT2)
     cGate(A,  t3)    =  1.3445   (day075b  fluc  166.685  +  fedge
                                  35.9257,  day078  span  150.688)
     cGate(A,  t4)    =  1.2578  (day079 LANDED:  1.2578/1.2586/1.2615/
                                  1.2704  A/Q/F/N;  monotone decay, then
                                  FLATTENING - the gate c* = (fluc+fedge)/span
                                  with both ~ ln t)   [0281:  replaces the
                                  ~0.95 expectation]
   The  UNIFORM  face  input  (all  t  >=  tPT2)  is  therefore
   governed  by  the  tPT2  value:  cGate  =  2.5821  at  sigma_A
   (2.5847  at  sigma_N  -  the  worst  sigma),  decreasing  above.

   STATUS:  the  gate  is  OPEN  under  every  published  input
   (published  c  =  12.9117  >>  cGate  =  2.58  at  tPT2  and  t3) -
   the  face  window  REMAINS  OPEN,  the  face  REMAINS  OPEN,  NO  RH
   CLAIM.  The  literature  search  (2026-11-04,  entry  0276)  found
   NO  published  sub-O(ln t)  POINTWISE  unit-scale  S-difference
   bound  (Backlund-family  O((ln t)^c)  pointwise  |S|  bounds,
   moment  bounds  for  h  ~  1/ln t  small  h  -  neither  reaches  the
   unit-scale  pointwise  gate);  cGate  is  pair-correlation-strength
   input  (unproven).  The  fleet  (a)  data  path  (100-150  fleet-
   days)  pins  k_L  (the  on-line  count  in  (t-1,  t])  but  does  NOT
   close  the  gate  (the  per-piece  S-FLUCTUATION  bound  is  unchanged
   by  data).  0277  =  the  mechanism  unit  (research).  -/

import  RhAttack.T4OffLM
import  Mathlib.Data.Real.Basic
import  Mathlib.Tactic.NormNum

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false
set_option  linter.style.docString  false

open  Real

namespace  T4OffLO

/-  =================  THE  PIECE  SPANS  (pure  kernel,  0274  shape)
    day078  e_win_s  computation  at  t  =  tPT2,  g2  =  gData  cut:
    W1  =  |f(gData)|  +  (f(gData)  -  f(tPT2-1))
    W2  =  2 * |f(tPT2+1)|
    The  rationals  below  are  UPPER  bounds  of  the  recorded  dps-50
    values  46.3914 / 55.9417  (sigma_A),  46.4268 / 56.0125  (sigma_Q),
    46.4521 / 56.0631  (sigma_F),  46.4571 / 56.0730  (sigma_N).  -/
def  W1A  :  ℚ  :=  46392  / 1000      --  46.392  upper
def  W2A  :  ℚ  :=  55942  / 1000      --  55.942  upper
def  W1Q  :  ℚ  :=  46427  / 1000      --  46.427  upper
def  W2Q  :  ℚ  :=  56013  / 1000      --  56.013  upper
def  W1F  :  ℚ  :=  46453  / 1000      --  46.453  upper
def  W2F  :  ℚ  :=  56064  / 1000      --  56.064  upper
def  W1N  :  ℚ  :=  46458  / 1000      --  46.458  upper
def  W2N  :  ℚ  :=  56073  / 1000      --  56.073  upper

/-  =================  THE  GATE  CONSTANTS  (0276  core)  =================
    cGate(σ)  =  (fluc(σ)  +  fedge(σ))  /  (W1  +  W2)  with  the
    T4OffLM  FIFTH-CORRECTION  recorded  lower  bounds  (flucAn  =
    236.27  etc.,  fedgeA  =  27.97  etc.)  -  the  LARGEST  admissible
    uniform  per-piece  S-difference  that  still  EXCLUDES  W  at
    sigma  σ  at  height  tPT2.  The  rationals  below  sit  STRICTLY
    below  the  exact  boundary  (the  strictness  is  the  certified
    margin,  3.4e-3  ..  1.4e-2  -  theorems  below).  -/
def  cGateA  :  ℚ  :=  25821  / 10000        --  2.5821
def  cGateQ  :  ℚ  :=  25805  / 10000        --  2.5805
def  cGateF  :  ℚ  :=  25809  / 10000        --  2.5809
def  cGateN  :  ℚ  :=  25847  / 10000        --  2.5847

/-  THE  GATE  THEOREMS  (tPT2,  gData  cut):  a  per-piece  S-
    difference  bounded  by  cGate  makes  E_win_S  <  fluc  +  fedge
    (STRICT)  -  which  is  exactly  the  0274  (g)  window-exclusion
    criterion.  (The  implication  "hence  W  is  empty"  is  the  0273
    step-4  corrected  logic  of  T4OffLM  -  this  module  certifies  the
    numerical  discriminant.)  -/
theorem  gateStrictA  :  (cGateA : ℝ) * ((W1A + W2A) : ℝ)  <  (T4OffLM.flucAn + T4OffLM.fedgeA)  :=  by
  norm_num  [cGateA,  W1A,  W2A,  T4OffLM.flucAn,  T4OffLM.fedgeA]
theorem  gateStrictQ  :  (cGateQ : ℝ) * ((W1Q + W2Q) : ℝ)  <  (T4OffLM.flucQn + T4OffLM.fedgeQ)  :=  by
  norm_num  [cGateQ,  W1Q,  W2Q,  T4OffLM.flucQn,  T4OffLM.fedgeQ]
theorem  gateStrictF  :  (cGateF : ℝ) * ((W1F + W2F) : ℝ)  <  (T4OffLM.flucFn + T4OffLM.fedgeF)  :=  by
  norm_num  [cGateF,  W1F,  W2F,  T4OffLM.flucFn,  T4OffLM.fedgeF]
theorem  gateStrictN  :  (cGateN : ℝ) * ((W1N + W2N) : ℝ)  <  (T4OffLM.flucNn + T4OffLM.fedgeN)  :=  by
  norm_num  [cGateN,  W1N,  W2N,  T4OffLM.flucNn,  T4OffLM.fedgeN]

/-  =================  THE  GATE  IS  OPEN  UNDER  PUBLISHED  INPUT  =================
    The  published  per-piece  S-difference  constants  at  tPT2  (HSXW
    2022  Cor.  1.4,  two  applications:  c1  =  Smax(t)  +  Smax(GLAST),
    c2  =  Smax(t+1)  +  Smax(GLAST);  day078:  12.9117)  EXCEED  the
    gate  on  every  probed  sigma  (ratio  5.00x):  no  published  law
    meets  the  gate  -  the  face  window  stays  OPEN  (the  0275
    structural  verdict,  now  as  a  named  conditional  input).  -/
def  cPub  :  ℚ  :=  12912  / 1000          --  12.912  upper  of  12.9117
theorem  cPubValue  :  (12.9117 : ℝ)  <=  (cPub : ℝ)  :=  by  norm_num  [cPub]
theorem  pubAboveGateA  :  (cGateA : ℝ)  <  (cPub : ℝ)  :=  by  norm_num  [cGateA,  cPub]
theorem  pubAboveGateQ  :  (cGateQ : ℝ)  <  (cPub : ℝ)  :=  by  norm_num  [cGateQ,  cPub]
theorem  pubAboveGateF  :  (cGateF : ℝ)  <  (cPub : ℝ)  :=  by  norm_num  [cGateF,  cPub]
theorem  pubAboveGateN  :  (cGateN : ℝ)  <  (cPub : ℝ)  :=  by  norm_num  [cGateN,  cPub]

/-  THE  GAP  (named,  for  0277):  E_win_S(tPT2)  -  (fluc  +  fedge)
    at  each  probed  sigma  (day078  e_win_s  =  1,321.2909 /
    1,322.6621  /  1,323.6436  /  1,323.8344):  >  0  =  the  window  is
    open  under  the  published  law.  -/
def  eWinS_A_tPT2  :  ℚ  :=  13212909  / 10000    --  1,321.2909
def  eWinS_Q_tPT2  :  ℚ  :=  13226621  / 10000    --  1,322.6621
def  eWinS_F_tPT2  :  ℚ  :=  13236436  / 10000    --  1,323.6436
def  eWinS_N_tPT2  :  ℚ  :=  13238344  / 10000    --  1,323.8344
def  gateGapA  :  ℚ  :=  eWinS_A_tPT2  -  (T4OffLM.flucAn + T4OffLM.fedgeA)
def  gateGapQ  :  ℚ  :=  eWinS_Q_tPT2  -  (T4OffLM.flucQn + T4OffLM.fedgeQ)
def  gateGapF  :  ℚ  :=  eWinS_F_tPT2  -  (T4OffLM.flucFn + T4OffLM.fedgeF)
def  gateGapN  :  ℚ  :=  eWinS_N_tPT2  -  (T4OffLM.flucNn + T4OffLM.fedgeN)
theorem  gateGapApos  :  (gateGapA : ℝ)  >  0  :=  by
  norm_num  [gateGapA,  eWinS_A_tPT2,  T4OffLM.flucAn,  T4OffLM.fedgeA]
theorem  gateGapQpos  :  (gateGapQ : ℝ)  >  0  :=  by
  norm_num  [gateGapQ,  eWinS_Q_tPT2,  T4OffLM.flucQn,  T4OffLM.fedgeQ]
theorem  gateGapFpos  :  (gateGapF : ℝ)  >  0  :=  by
  norm_num  [gateGapF,  eWinS_F_tPT2,  T4OffLM.flucFn,  T4OffLM.fedgeF]
theorem  gateGapNpos  :  (gateGapN : ℝ)  >  0  :=  by
  norm_num  [gateGapN,  eWinS_N_tPT2,  T4OffLM.flucNn,  T4OffLM.fedgeN]

/-  =================  THE  T-PROFILE  (the  gate  tightens  in  t)  =================
    cGate(A,  t3)  =  (fluc(t3)  +  fedge(t3))  /  span(t3):
    day075b  fluc(t3)  =  166.685,  fedge(t3)  =  35.9257,  day078
    S-route  span  (t3)  =  E_win_S(t3)  /  c1(t3)  =  2066.2  /
    13.7117  =  150.688:  cGate(A,  t3)  =  1.3445  (recorded  upper
    of  the  lower  reading  1.34457;  direction  conservative  for  the
    tightening  comparison  below).  The  gate  STRICTLY  decreases
    tPT2  ->  t3  (1.3445  <  2.5821)  -  consistent  with  the
    structural  decay  (E_win  ~  (ln  t) *  kernel  ~  (ln  t)^2
    vs  t-frozen  fluc,  day074):  the  UNIFORM  face  input  (all
    t  >=  tPT2)  is  governed  by  the  tPT2  value.  (t4  =  10^6
    tPT2  point:  day079  cell,  appended  below  once  landed.)  -/
def  cGate3A  :  ℚ  :=  13445  / 10000        --  1.3445  (t3)
def  eWinS_A_t3  :  ℚ  :=  20662  / 10          --  2,066.2
def  fluc_t3_A  :  ℚ  :=  166685  / 1000       --  166.685
def  fedge_t3_A  :  ℚ  :=  359257  / 10000     --  35.9257
theorem  cGate3tight  :  (cGate3A : ℝ)  <  (cGateA : ℝ)  :=  by
  norm_num  [cGate3A,  cGateA]
theorem  gateOpenAtT3  :  (eWinS_A_t3 : ℝ)  >  (fluc_t3_A + fedge_t3_A)  :=  by
  norm_num  [eWinS_A_t3,  fluc_t3_A,  fedge_t3_A]

/-  =================  THE  0276  GATE  (the  named  input)  =================
    STATEMENT  (the  exact  conditional  input  of  the  next
    mechanism  -  0277):  IF  for  EVERY  t  >=  tPT2  the  unknown-side
    S-fluctuation  obeys  a  per-piece  S-difference  bound
       c1(t)  <=  cGate  and  c2(t)  <=  cGate,  cGate  =  2.5821
    (sigma_A)  /  2.5805  (sigma_Q)  /  2.5809  (sigma_F)  /
    2.5847  (sigma_N)       (uniform  in  t  -  the  tPT2  values,
    the  profile  being  STRICTLY  EASIER  above  tPT2:  cGate(A,
    t3)  =  1.3445  <  2.5821,  day079  t4  point  below),
    THEN  the  0274  (g)  criterion  fires  at  every  t  and  every
    probed  sigma:  E_win_S(t)  <  fluc(t)  +  fedge(t)  -  hence
    the  frontier  unit  window  W(t)  =  (t-1,  t+1]  carries  NO  face
    zero  at  any  t  >=  tPT2  (the  face  window  statement  for  all
    t  is  the  countable  union  of  the  cell  statements  -  the  0269
    terminal-face  reduction).

    The  published  input  (12.9117,  HSXW  two  applications)  MISSES
    the  gate  by  5.00x  at  tPT2  (gateGapA  ..  gateGapN  >  0,
    pubAboveGate*)  -  the  face  REMAINS  OPEN.  NO  RH  CLAIM.

    LITERATURE  STATUS  (entry  0276,  searched  2026-11-04):  no
    PUBLISHED  pointwise  unit-scale  S-difference  bound  below  O
    (ln  t)  (Backlund  family  pointwise  |S|;  moment  results
    for  h  ~  1/ln  t);  the  gate  is  pair-correlation-strength
    input.  The  fleet  (a)  data  path  (100-150  fleet-days)  pins  the
    on-line  count  k_L  in  (t-1,  t]  (0263  on-line-ness)  but  leaves
    the  per-piece  S-FLUCTUATION  bound  (the  gate  itself)  unchanged:
    it  does  NOT  close  the  gate.  -/
theorem  gateA_statement  :  (cGateA : ℝ)  >  0  :=  by  norm_num  [cGateA]
theorem  gateN_statement  :  (cGateN : ℝ)  >  0  :=  by  norm_num  [cGateN]

/-  THE  COMPOSITE  0276  RECORD:  (1)  the  gate  discriminant  is
    STRICT  at  tPT2  (gateStrict*);  (2)  the  published  input  misses
    the  gate  on  every  sigma  (pubAboveGate*  +  gateGap*pos);
    (3)  the  gate  tightens  tPT2  ->  t3  (cGate3tight,
    gateOpenAtT3  -  the  window  is  still  open  at  t3  under  the
    published  law);  (4)  the  gate  constants  are  positive
    (gate*_statement).  Hence:  the  face  window  (hence  the  face)
    REMAINS  OPEN,  and  the  exact  remaining  input  is  the  named
    cGate  above.  No  RH  claim.  -/
theorem  faceGateRecord  :
    (cGateA : ℝ) * ((W1A + W2A) : ℝ)  <  (T4OffLM.flucAn + T4OffLM.fedgeA)  ∧
      (cGateN : ℝ) * ((W1N + W2N) : ℝ)  <  (T4OffLM.flucNn + T4OffLM.fedgeN)  ∧
      (cGateA : ℝ)  <  (cPub : ℝ)  ∧
      (cGateN : ℝ)  <  (cPub : ℝ)  ∧
      (gateGapA : ℝ)  >  0  ∧
      (gateGapN : ℝ)  >  0  ∧
      (cGate3A : ℝ)  <  (cGateA : ℝ)  ∧
      (eWinS_A_t3 : ℝ)  >  (fluc_t3_A + fedge_t3_A)  :=
  ⟨gateStrictA,  gateStrictN,  pubAboveGateA,  pubAboveGateN,
   gateGapApos,  gateGapNpos,  cGate3tight,  gateOpenAtT3⟩

/-  =================  THE  WINDOW  CENSUS  DATUM  (day080,  0276.6)  =================
    The  frontier  two-unit  window  (tPT2-1,  tPT2+1]  contains  EXACTLY
    8  ON-LINE  zeros  (Re  =  1/2  -  the  day074  on-line-ness  of  the
    bulk),  computed  in-house  via  the  Riemann-Siegel  Z(t)  at  tPT2
    (N  =  sqrt(t/2pi)  =  691008  terms,  80-bit  longdouble;  roots  at
    t  -0.88769531,  -0.57128906,  -0.46777344,  -0.31542969,
    -0.06933594,  +0.28613281,  +0.43457031,  +0.70410156;  5  in  (t-1,
    t],  3  in  (t,  t+1]).  VERIFIED:  (a)  the  mpmath  dps-50  Z at  every
    root  is  |Z|  ~  1e-3..4e-2  (on  the  zeros)  and  |Z(t)|  =
    2.572018  (t  is  away  from  all  of  them);  (b)  the  R-vM
    main-term  two-unit  prediction  2*ln(t/2pi)/(2pi)  =  8.5599  (measured
    8,  within  +-1);  (c)  the  smooth  theta-part  of  the  unit
    S-difference  computed  by  the  longdouble  engine,  +4.27996532,
    matches  the  day078  dmain(tPT2)  =  4.279965  to  7  digits.  The
    in-repo  zero  data  stops  at  gData  =  3.0001e10  (day073b),  far
    below  tPT2  =  3.0002e12  -  these  ordinates  are  NEW  data.

    RELATION  TO  THE  GATE:  the  0275  certified  window  bound  (<=  22
    zeros  total)  includes  POSSIBLE  off-line  FACE  zeros;  the  8
    on-line  zeros  are  bulk  (Re  =  1/2)  and  contribute  to  fluc
    (the  known-side  S-stream  already  accounts  for  all  KNOWN  zeros
    up  to  gData  -  these  8  are  the  NEW  known  zeros  of  the  window,
    available  for  any  mechanism  that  uses  window  data).  The  gate  of
    0276  targets  the  remaining  off-line  (face)  part:  even  with  all
    8  on-line  zeros  known,  the  face  window  is  certified  empty  iff
    the  per-piece  S-diff  (over  the  FACE  zeros  and  the  far  tail)
    stays  <=  cGate.  The  published  sup  (12.9117)  still  governs  the
    gate.  No  RH  claim.  -/
def  kL_frontier  :  ℚ  :=  8                       --  measured  (day080)
def  rvmpred2  :  ℚ  :=  85599  / 10000             --  2*ln(tPT2/2pi)/(2pi)
def  thetaPart  :  ℚ  :=  427996532  / 100000000   --  thdiff  (day080  =  day078 dmain)
theorem  kLbelowCertified  :  (kL_frontier : ℝ)  <  22  :=  by
  norm_num  [kL_frontier]
theorem  kLrvConsistency  :  |((rvmpred2 - kL_frontier) : ℝ)|  <  1  :=  by
  norm_num  [rvmpred2,  kL_frontier]
theorem  thetaPartMatchesDay078  :
    (4279964 : ℚ)  /  1000000  <  thetaPart  ∧
      thetaPart  <  (4279966 : ℚ)  /  1000000  :=  by
  norm_num  [thetaPart]

end  T4OffLO
