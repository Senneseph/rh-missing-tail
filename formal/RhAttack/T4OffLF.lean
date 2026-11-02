/- T4OffLF  --  THE  IN-BODY  PIN  (the  named  T4OffLE.pin  of
   discovery  0258;  day062  bound  chain  measured)  -  OFF-BOARD
   POSITIVE-DUAL  MARGIN  RECORD  (the  T4OffLC/LD/LE  class).  No  RH
   claim:  the  record  lands  the  NAMED  FACE  of  0258  -  the
   measured  pin  (wall_lo  (N)  >  ||poff  t  d0  t||)  becomes  an
   IN-BODY  closed-form  inequality  on  the  whole  band
   (1000  <=  t,  1/200  <=  d0  <  1/2),  at  EVERY  run
   N  in  [nIdeal,  2 nIdeal]  (in  particular  the  decoupled  fill
   run  N  =  Noff  =  ceil  nIdeal  -  the  T4OffLE  ceiling  bounds
   are  in  body).  Hence  the  S1  side  of  the  terminal  squeeze
   needs  NO  measured  datum:  T4OffLE.t4LE_squeeze_decoupled  now
   closes  from  (i)  the  CITED  A2c  bridge  and  (ii)  the  NAMED
   S3  FACE  alone  (S  S5.2).

   The  in-body  bound  chain  (day062,  dps  62,  every  step  a
   Lean  lemma  below):
     (a)  wallLo  (N)  =  T1  -  T2  -  T3  (closed  form)
         >=  T1b  -  T2b  -  T3b,  with  T1b  =  4 d0^2 t^-2
         2^(1/2+d0)  (the  exact  knife-edge  scale  nIdeal^(-sigma)
         =  16 d0^2 t^-2,  S  S1.1),  T2b  =  sqrt(t^2+1/4)/12
         4096 d0^6 t^-6,  T3b  =  (sqrt3/216) cK 1048576 d0^10
         t^-7 /  (sigma+2),  cK  =  (1001/1000)(501/500)^2.
     (b)  own  =  ||poff  t  d0  t||  =  mown  <=  4 d0^2 t^-2
         (1 + d0^2/(4t^2))  exp(1/t^2).
     (c)  exp(1/t^2)  <=  exp(1e-6)  <=  1  +  1/999999  (tsum-tail
         pin),  d0^2/(4t^2)  <=  1/16000000.
   THE  STRICT  STEP:  2^(101/200)  >  1001/1000  (EXACT  rationals,
   norm_num)  gives
     T1b  -  T2b  -  T3b  >=  A  (2^(101/200)  -  eps2  -  eps3)
         >  A  (1  +  1/16000000)  (1  +  1/999999)  >=  own,
     A  :=  4 d0^2 t^-2,  eps2  :=  23/1e9,  eps3  :=  7/1e15.

   MEASURED  MARGIN  (day062,  grid  t  in  {1e3..1e20}  x  d0  in
   {1/200..D0max,  0.49,  0.499999}:  worst  1.4191226467  at
   (t  =  1000,  d0  =  1/200)  -  factor  1.419  STRICT,  t-flat,
   rising  to  ~1.9997  as  d0  ->  1/2;  the  same  grid  verifies
   T2b,  T3b  above  the  exact  T2,  T3  at  nIdeal  and  the  bound
   below  the  true  wall_lo  at  Noff).  -/
import  Mathlib
import  RhAttack.P4Limit
import  RhAttack.S4Strip
import  RhAttack.S1LowT
import  RhAttack.S4Own
import  RhAttack.FloorUnif
import  RhAttack.WinCount
import  RhAttack.T4OffD
import  RhAttack.S4Asm
import  RhAttack.T4OffM
import  RhAttack.T4OffL
import  RhAttack.Closure
import  RhAttack.T4OffLE

open  Real

--  the  atomic  constant  lines  (the  cK  product,  T3b,  the
--  final  comparisons)  exceed  100  chars  with  their  exact
--  rationals.
set_option  linter.style.longLine  false

noncomputable  section

namespace  T4OffLF

variable (t d0 : ℝ)

/-  PROOF  CONVENTIONS  (lean-4331  calc  +  rpow  pitfalls,  all
    hit  and  fixed  this  session)  -  (1)  every  calc  step  in  a
    tactic  block  is  a  PURE  TERM  (a  have  or  a  lemma
    application);  the  step's  goal  can  meta  the  LHS,  so  a
    nested  by  that  needs  the  LHS  must  be  a  preceding  have.
    (2)  rpow  exponents:  the  literals  (-1  :  ℝ),  (-2  :  ℝ)  of
    mathlib  lemmas  are  not  defeq  to  (-(1 : ℝ)),  (-(2 : ℝ)) -
    bridge  with  a  norm_num  exponent  have  before  an  rpow  rw.
    (3)  the  stored  T4OffLE.nIdeal  exponents  -(1  /  (1  /  2  -
    d0))  and  2  /  (1  /  2  -  d0)  must  be  matched  in  that
    exact  syntax  when  rw  /  dsimp  targets  it.  -/

/-  S0  helpers  -------------------------------------------- -/

/-- t^(-2)  =  (1/t)^2  (no  integer  powers:  rpow_add  +
    rpow_neg_one  on  the  LITERAL  negative  exponents). -/
protected theorem tinv2 (ht : 0 < t) :
    t  ^  (-(2  :  ℝ))  =  (1  /  t)  ^  2  :=
  by
    --  (-(2 : ℝ))  and  (-2 : ℝ)  are  defeq  but  syntactically
    --  distinct  (rw  is  syntactic  -  bridge  with  the  have):
    have  hlit  :  t  ^  (-(2  :  ℝ))  =  t  ^  (-2  :  ℝ)  :=  by  rfl
    have  heq  :  (-2  :  ℝ)  =  (-1  :  ℝ)  +  (-1  :  ℝ)  :=
        by  norm_num
    rw  [hlit,  heq,  rpow_add  ht  (-1)  (-1),  rpow_neg_one  t]
    have  hinvt  :  t⁻¹  =  1  /  t  :=  (inv_eq_one_div  t)
    rw  [hinvt]
    ring

/-- The  left  point  norm  shape:  ||sL||  =  sqrt(σ^2  +  t^2)
    (S4Own  pattern). -/
private theorem normL (t d0 : ℝ) :
    ‖t4l_sOffL  t  d0‖  =  Real.sqrt  ((1  /  2  -  d0)  ^  2  +  t  ^  2)  :=
  by
    dsimp  only  [t4l_sOffL]
    rw  [Complex.norm_def,  Complex.normSq_add_mul_I  (1  /  2  -  d0)  t]

/-  =================================================================
   S1  THE  IDEAL  RUN  SCALE  (exact  knife-edge  cancellation)
   =================================================================
   nIdeal  =  (16 d0^2)^(−1/σ)  t^(2/σ),  σ  =  1/2  −  d0.  At
   this  run  the  leading  T1  term  is  EXACT  (the  058e  sigma
   cancellation):  nIdeal^(-σ)  =  16 d0^2 t^-2.  The  SECOND  scale
   fact  is  the  polynomial  lower  bound  nIdeal  >=  t^4/(256
   d0^4)  (the  reciprocal  used  to  cap  the  T2  /  T3  tails  in
   S2)  -  both  pure  rpow  algebra  over  the  definition.  -/

/-- S  S1.1  THE  EXACT  KNIFE-EDGE  SCALE:  at  the  ideal
    decoupled  run,  nIdeal^(-(1/2-d0))  =  16 d0^2 t^-2.  Pure
    rpow  algebra,  no  measurement. -/
theorem nIdeal_pow_sig (ht : 0 < t) (hd0 : 0 < d0)
    (hdhigh : d0 < (1 / 2 : ℝ)) :
    (T4OffLE.nIdeal t d0) ^ (-(1 / 2 - d0)) =
      16 * d0 * d0 * t ^ (-(2 : ℝ)) := by
  set  s  :=  (1  /  2 :  ℝ)  -  d0  with  hs
  have  hs0  :  0  <  s  :=  by  {  dsimp  [s];  linarith  [hdhigh,  hd0]  }
  have  h16n  :  0  <=  16  *  d0  *  d0  :=  by  positivity
  have  htp  :  0  <  t  :=  ht
  have  he1  :  (-(1  /  (1  /  2  -  d0))  :  ℝ)  =  (-(1  /  s))  :=
      by  dsimp  [s]
  have  he2  :  (2  /  (1  /  2  -  d0)  :  ℝ)  =  (2  /  s)  :=
      by  dsimp  [s]
  have  he3  :  (-(1  /  2  -  d0)  :  ℝ)  =  (-s)  :=  by  dsimp  [s]
  have  hstep1  :  (T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  =
      (((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0))))  *
        (t  ^  (2  /  (1  /  2  -  d0))))  ^  (-(1  /  2  -  d0))  :=
      by  dsimp  [T4OffLE.nIdeal]
  have  hstep2  :  (((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0))))  *
        (t  ^  (2  /  (1  /  2  -  d0))))  ^  (-(1  /  2  -  d0))  =
      (((16  *  d0  *  d0)  ^  (-(1  /  s)))  *  (t  ^  (2  /  s)))  ^  (-s)  :=
      by  rw  [he1,  he2,  he3]
  have  hstep3  :  (((16  *  d0  *  d0)  ^  (-(1  /  s)))  *  (t  ^  (2  /  s)))  ^  (-s)  =
      ((16  *  d0  *  d0)  ^  (-(1  /  s)))  ^  (-s)  *  (t  ^  (2  /  s))  ^  (-s)  :=
      by  rw  [mul_rpow  (rpow_nonneg  h16n  _)  (rpow_nonneg  htp.le  _)]
  have  hstep4  :  ((16  *  d0  *  d0)  ^  (-(1  /  s)))  ^  (-s)  *  (t  ^  (2  /  s))  ^  (-s)  =
      (16  *  d0  *  d0)  ^  ((-(1  /  s))  *  (-s))  *  (t  ^  (2  /  s))  ^  (-s)  :=
      by  rw  [(rpow_mul  h16n  (-(1  /  s))  (-s)).symm]
  have  hstep5  :  (16  *  d0  *  d0)  ^  ((-(1  /  s))  *  (-s))  *  (t  ^  (2  /  s))  ^  (-s)  =
      (16  *  d0  *  d0)  ^  (1  :  ℝ)  *  (t  ^  (2  /  s))  ^  (-s)  :=
      by  {  congr  1;  field_simp  [hs0]  }
  have  hstep6  :  (16  *  d0  *  d0)  ^  (1  :  ℝ)  *  (t  ^  (2  /  s))  ^  (-s)  =
      (16  *  d0  *  d0)  *  (t  ^  (2  /  s))  ^  (-s)  :=
      by  rw  [rpow_one]
  have  hstep7  :  (16  *  d0  *  d0)  *  (t  ^  (2  /  s))  ^  (-s)  =
      16  *  d0  *  d0  *  t  ^  ((2  /  s)  *  (-s))  :=
      by  rw  [rpow_mul  (le_of_lt  htp)  (2  /  s)  (-s)]
  have  hstep8  :  16  *  d0  *  d0  *  t  ^  ((2  /  s)  *  (-s))  =
      16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=
      by  {  congr  1;  field_simp  [hs0]  }
  have  hdone  :  (T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  =
      16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=
      by  rw  [hstep1,  hstep2,  hstep3,  hstep4,  hstep5,  hstep6,
              hstep7,  hstep8]
  exact  hdone

/-- S  S1.2  THE  POLYNOMIAL  SCALE  BOUND:  on  the  band,
    nIdeal  >=  t^4  /  (256 d0^4).  nIdeal  =  X^(1/σ)  with
    X  =  t^2/(16 d0^2)  >=  250000  >  1,  and  1/σ  >  2  (σ  <
    1/2,  d0  >  0):  X^2  <=  X^(1/σ).  Pure  rpow  +  field  algebra
    -  no  measurement. -/
theorem nIdeal_ge_t4 (ht : 1000 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0)
    (hdhigh : d0 < (1 / 2 : ℝ)) :
    t ^ 4 / (256 * d0 ^ 4) ≤ T4OffLE.nIdeal t d0 := by
  have  hs0  :  0  <  (1  /  2 :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
  have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
  have  htp  :  0  <  t  :=  by  linarith  [ht]
  have  h16  :  0  <  16  *  d0  *  d0  :=  by  positivity
  --  nIdeal  =  (t^2  /  (16 d0^2))^(1/σ),  σ  =  1/2  -  d0:
  have  hXform  :  T4OffLE.nIdeal  t  d0  =
      (t  *  t  /  (16  *  d0  *  d0))  ^  (1  /  (1  /  2  -  d0))  :=
      by
        dsimp  [T4OffLE.nIdeal]
        have  hA  :  (16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  =
              ((16  *  d0  *  d0)⁻¹)  ^  (1  /  (1  /  2  -  d0))  :=
              rpow_neg_eq_inv_rpow  (16  *  d0  *  d0)  (1  /  (1  /  2  -  d0))
        rw  [hA]
        have  h2s  :  (2  :  ℝ)  /  (1  /  2  -  d0)  =
              2  *  (1  /  (1  /  2  -  d0))  :=
            by  field_simp  [hs0]
        have  hB  :  t  ^  (2  /  (1  /  2  -  d0))  =
              (t  *  t)  ^  (1  /  (1  /  2  -  d0))  :=
            by
              have  hB1  :  t  ^  (2  /  (1  /  2  -  d0))  =
                    t  ^  (2  *  (1  /  (1  /  2  -  d0)))  :=  by  rw  [h2s]
              have  hB2  :  t  ^  (2  *  (1  /  (1  /  2  -  d0)))  =
                    (t  ^  (2  :  ℝ))  ^  (1  /  (1  /  2  -  d0))  :=
                    rpow_mul  (le_of_lt  htp)  2  (1  /  (1  /  2  -  d0))
              have  hB3  :  (t  ^  (2  :  ℝ))  ^  (1  /  (1  /  2  -  d0))  =
                    (t  *  t)  ^  (1  /  (1  /  2  -  d0))  :=
                    by { rw [rpow_two t, pow_two t] }
              calc  t  ^  (2  /  (1  /  2  -  d0))
                  =  t  ^  (2  *  (1  /  (1  /  2  -  d0)))  :=  hB1
                  _  =  (t  ^  (2  :  ℝ))  ^  (1  /  (1  /  2  -  d0))  :=  hB2
                  _  =  (t  *  t)  ^  (1  /  (1  /  2  -  d0))  :=  hB3
        rw  [hB]
        have  hmul  :  ((16  *  d0  *  d0)⁻¹)  ^  (1  /  (1  /  2  -  d0))  *
                (t  *  t)  ^  (1  /  (1  /  2  -  d0))  =
              (t  *  t  /  (16  *  d0  *  d0))  ^  (1  /  (1  /  2  -  d0))  :=
            by
              rw  [mul_comm,  (mul_rpow  (by  positivity)  (by  positivity)).symm,
                    div_eq_mul_inv  (t  *  t)  (16  *  d0  *  d0)]
        rw  [← hmul]
  --  X  =  t^2/(16 d0^2)  >=  250000  >  1  (t  >=  1000,  d0  <  1/2):
  have  hXbig  :  (1 : ℝ)  <  t  *  t  /  (16  *  d0  *  d0)  :=
      by
        have  hbigX  :  250000  *  (16  *  d0  *  d0)  <  (1000 : ℝ)  ^  2  :=
            by
              have  h16lt4  :  16  *  d0  *  d0  <  4  :=  by  nlinarith  [hdhigh]
              have  hstep  :  250000  *  (16  *  d0  *  d0)  <  250000  *  4  :=
                  mul_lt_mul_of_pos_left  h16lt4  (by  norm_num : 0 < (250000 : ℝ))
              have  hfin  :  250000  *  4  =  (1000 : ℝ)  ^  2  :=
                  by  norm_num
              calc  250000  *  (16  *  d0  *  d0)  <  250000  *  4  :=  hstep
                  _  =  (1000 : ℝ)  ^  2  :=  hfin
        have  ht2  :  (1000 : ℝ)  ^  2  <=  t  *  t  :=  by  nlinarith  [ht]
        have  hle250k  :  250000  <=  t  *  t  /  (16  *  d0  *  d0)  :=
            by
              rw  [le_div_iff₀  h16]
              nlinarith  [ht2,  hbigX]
        have  h1  :  (1 : ℝ)  <=  250000  :=  by  norm_num
        linarith  [hle250k,  h1]
  --  σ  <  1/2  (d0  >  0)  =>  1/σ  >  2:
  have  hinvs  :  2  <  1  /  (1  /  2  -  d0)  :=
      by
        have  hlt  :  (2 : ℝ) * ((1  /  2 :  ℝ)  -  d0)  <  1  :=
            by  nlinarith  [show  (1  /  2 :  ℝ)  -  d0  <  1  /  2  from
              by  linarith  [hd0p]]
        rw  [lt_div_iff₀  hs0]
        exact  hlt
  --  the  chain  (pure  term  steps):
  have  hsq  :  t  ^  4  /  (256  *  d0  ^  4)  =
      (t  *  t  /  (16  *  d0  *  d0))  ^  (2  :  ℝ)  :=
      by  {  rw  [rpow_two  (t  *  t  /  (16  *  d0  *  d0))];  ring  }
  have  hmid  :  (t  *  t  /  (16  *  d0  *  d0))  ^  (2  :  ℝ)  <=
      (t  *  t  /  (16  *  d0  *  d0))  ^  (1  /  (1  /  2  -  d0))  :=
      Real.rpow_le_rpow_of_exponent_le  (le_of_lt  hXbig)  hinvs.le
  have  hend  :  (t  *  t  /  (16  *  d0  *  d0))  ^  (1  /  (1  /  2  -  d0))  =
      T4OffLE.nIdeal  t  d0  :=  hXform.symm
  have  hdone2  :  t  ^  4  /  (256  *  d0  ^  4)  <=  T4OffLE.nIdeal  t  d0  :=
      le_trans  (le_trans  hsq.le  hmid)  (hend.le)
  exact  hdone2

/-  =================================================================
   S2  TAIL  CAPS  (closed  forms  T2b  /  T3b,  and  the  t2  cap
       lemma  at  every  run  N  >=  nIdeal  on  the  band)
   =================================================================
   t2b  is  the  closed-form  cap  of  the  t2  term  of  wallLo
   (the  (‖sL‖  /  12)  N^(-(3/2-d0))  factor)  on  the  band
   (t  >=  1000,  1/200  <=  d0  <  1/2)  at  any  run  N  >=  nIdeal:
   cap  the  left-point  norm  by  sqrt(t^2+1/4)  (σ  <  1/2),  cap
   the  run  exponent  by  inverting  to  the  ideal  run,  then  cap
   the  ideal  run  reciprocal  by  256 d0^4 t^-4  (S  S1.2)  and
   exact  knife-edge  value  (S  S1.1).  Exact  constants:  16*256
   =  4096,  t^-2*t^-4  =  t^-6,  d0^2*d0^4  =  d0^6.  -/

/-- S  S2.0  THE  T2  BOUND  (closed  form;  day062). -/
noncomputable def T2b (t d0 : ℝ) :  ℝ  :=
    Real.sqrt  (t  ^  2  +  1  /  4)  /  12  *  (4096  :  ℝ)  *  d0  ^  6  /  t  ^  6

/-- day062  cK  constant:  (t+1)(t+2)^2  <=  cK  t^3  at  t  >=  1000
    (1.001  *  1.002^2,  each  factor  monotone  decreasing  in  t). -/
noncomputable def cK :  ℝ  :=
    (1001  /  1000  :  ℝ)  *  (501  /  500  :  ℝ)  ^  2

/-- S  S2.1  THE  T3  BOUND  (assembled  form,  day062):  rationally
    equal  to  (sqrt(3)/216)  *  cK  *  1048576  *  d0^10  *  t^(-7)
    /  (sigma+2)    [16  *  256^2  =  1048576,  d0^2  d0^4  d0^4  =
    d0^10,  t^3  t^-2  t^-4  t^-4  =  t^-7]  -  the  assembled  form
    keeps  the  in-body  cap  (t3cap)  free  of  rpow  rewrites. -/
noncomputable def T3b (t d0 : ℝ) :  ℝ  :=
    (Real.sqrt  3  /  216)  *  cK  *  t  ^  3  *
      (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *
      ((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4)  /
      ((1  /  2  -  d0)  +  2)

/-- S  S3.0  (placed  here  for  t2cap  and  t3cap)  THE  IDEAL-RUN
    RECIPROCAL  CAP:  1/nIdeal  <=  256  d0^4  /  t^4  (the  polynomial
    scale  bound  S  S1.2  inverted  through  division). -/
theorem nIdeal_inv_cap (ht : 1000 <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    1  /  (T4OffLE.nIdeal  t  d0)  <=  (256  *  d0  ^  4)  /  t  ^  4  :=
  by
    have  hni  :  0  <  T4OffLE.nIdeal  t  d0  :=
      by  {  dsimp  [T4OffLE.nIdeal];  positivity  }
    rw  [div_le_div_iff₀  hni  (by  positivity  :  0  <  t  ^  4)]
    have  hge'  :  t  ^  4  /  (256  *  d0  ^  4)  <=  T4OffLE.nIdeal  t  d0  :=
        nIdeal_ge_t4  t  d0  ht  hdlow  hdhigh
    rw  [div_le_iff₀  (by  positivity  :  0  <  (256  *  d0  ^  4  :  ℝ))]  at  hge'
    nlinarith  [hge']

/-- S  S2.2  THE  T2  CAP:  at  any  run  N  in  [nIdeal,  ∞)  on
    the  band,  the  T2  term  of  wallLo  is  at  or  below  T2b.
    Every  step  is  a  pre-built  have  (pure  term  calc  safety). -/
theorem t2cap (N : ℕ) (ht : 1000 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0)
    (hdhigh : d0 < (1 / 2 : ℝ))
    (hN : T4OffLE.nIdeal t d0 ≤ (N : ℝ)) :
    (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-(3  /  2  -  d0))  ≤  T2b  t  d0  :=  by
  have  hs0  :  0  <  (1  /  2  :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
  have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
  have  htp  :  0  <  t  :=  by  linarith  [ht]
  have  hNge1  :  (1  :  ℝ)  ≤  (N  :  ℝ)  :=
      le_trans  (T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh)  hN
  have  hNp  :  0  <  (N  :  ℝ)  :=  by  linarith  [hNge1]
  --  exponent  bridge  -(3/2-d0)  =  -((1/2-d0)+1):
  have  hexp  :  (N  :  ℝ)  ^  (-(3  /  2  -  d0))  =
      (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))  :=
      by  {  congr  1;  ring  }
  rw  [hexp]
  --  (a)  left-point  norm  cap  (σ  <  1/2,  σ  >  0):
  have  hnorml  :  ‖t4l_sOffL  t  d0‖  =  Real.sqrt  ((1  /  2  -  d0)  ^  2  +  t  ^  2)  :=
      normL  t  d0
  have  hsnn  :  0  ≤  (1  /  2  :  ℝ)  -  d0  :=  hs0.le
  have  hsl1  :  (1  /  2  :  ℝ)  -  d0  <  1  /  2  :=  by  linarith  [hd0p]
  have  hsb  :  Real.sqrt  ((1  /  2  -  d0)  ^  2  +  t  ^  2)  <=
      Real.sqrt  (t  ^  2  +  1  /  4)  :=
      Real.sqrt_le_sqrt  (by  nlinarith  [hsnn,  hsl1])
  have  hdivcap  :  ‖t4l_sOffL  t  d0‖  /  12  <=
      Real.sqrt  (t  ^  2  +  1  /  4)  /  12  :=
      by
        rw  [hnorml]
        have  hdd12  :  Real.sqrt  ((1  /  2  -  d0)  ^  2  +  t  ^  2)  *  12  <=
              Real.sqrt  (t  ^  2  +  1  /  4)  *  12  :=
            mul_le_mul_of_nonneg_right  hsb  (by  norm_num  :  0  <=  (12  :  ℝ))
        exact  (div_le_div_iff₀  (by  norm_num  :  0  <  (12  :  ℝ))  (by  norm_num  :  0  <  (12  :  ℝ))).mpr  hdd12
  have  hA  :  (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))  <=
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))  :=
      mul_le_mul_of_nonneg_right  hdivcap  (by  positivity)
  --  (b)  N^(-(s+1))  =  (N^(s+1))⁻¹:
  have  hB  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1))⁻¹  :=
      by  rw  [rpow_neg  (by  linarith  [hNge1])  ((1  /  2  -  d0)  +  1)]
  --  (c)  inverse  monotonicity  (nIdeal^(s+1)  ≤  N^(s+1)):
  have  hni  :  0  <  T4OffLE.nIdeal  t  d0  :=
      by  {  dsimp  [T4OffLE.nIdeal];  positivity  }
  have  hC  :  T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1)  <=
      (N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1)  :=
      rpow_le_rpow  (by  linarith  [hni])  hN  (by  linarith  [hs0])
  have  hD  :  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1))⁻¹  <=
      (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1))⁻¹  :=
      by
        have  hNpos  :  0  <  (N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1)  :=
            rpow_pos_of_pos  hNp  ((1  /  2  -  d0)  +  1)
        have  hnpos  :  0  <  T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1)  :=
            rpow_pos_of_pos  hni  ((1  /  2  -  d0)  +  1)
        have  hdd  :  1  /  (N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1)  <=
              1  /  (T4OffLE.nIdeal  t  d0)  ^  ((1  /  2  -  d0)  +  1)  :=
            (one_div_le_one_div  hNpos  hnpos).mpr  hC
        rw  [inv_eq_one_div  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1)),
            inv_eq_one_div  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1))]
        exact  hdd
  have  hDstep  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1))⁻¹  <=
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1))⁻¹  :=
      mul_le_mul_of_nonneg_left  hD  (by  positivity)
  --  (d)  back  to  rpow  form,  then  exponent  split:
  have  hE  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1))⁻¹  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  1))  :=
      by  rw  [(rpow_neg  (le_of_lt  hni)  ((1  /  2  -  d0)  +  1)).symm]
  have  hexp2  :  -((1  /  2  -  d0)  +  1)  =  -((1  /  2  -  d0))  +  (-(1  :  ℝ))  :=
      by  ring
  have  hE2  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  1))  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0))  +  (-(1  :  ℝ)))  :=
      by  rw  [hexp2]
  have  hF  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0))  +  (-(1  :  ℝ)))  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  (-((1  /  2  -  d0))))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  :=
      by  {  rw  [rpow_add  hni  (-((1  /  2  -  d0)))  (-(1  :  ℝ))];  ring  }
  --  (e)  the  exact  knife-edge  value  (S  S1.1):  nIdeal^(-σ)  =
  --  16  d0^2  t^-2:
  have  hG  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  (-((1  /  2  -  d0))))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  :=
      by  rw  [nIdeal_pow_sig  t  d0  htp  hd0p  hdhigh]
  --  (f)  nIdeal^(-1)  =  1  /  nIdeal:
  have  hinv  :  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  =  1  /  (T4OffLE.nIdeal  t  d0)  :=
      by
        rw  [rpow_neg  (le_of_lt  hni)  (1  :  ℝ),  rpow_one  (T4OffLE.nIdeal  t  d0),
            inv_eq_one_div  (T4OffLE.nIdeal  t  d0)]
  have  hH  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  =
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (1  /  (T4OffLE.nIdeal  t  d0))  :=
      by  rw  [hinv]
  --  (g)  ideal-run  reciprocal  cap  (S  S1.2):  1/nIdeal  <=  256
  --  d0^4  /  t^4:
  have  hrec  :  1  /  (T4OffLE.nIdeal  t  d0)  <=  (256  *  d0  ^  4)  /  t  ^  4  :=
      nIdeal_inv_cap  t  d0  ht  hdlow  hdhigh
  have  hI  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (1  /  (T4OffLE.nIdeal  t  d0))  <=
      (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  ((256  *  d0  ^  4)  /  t  ^  4)  :=
      mul_le_mul_of_nonneg_left  hrec  (by  positivity)
  --  (h)  assemble  the  closed  form  =  T2b  (16*256  =  4096,
  --  t^-2*t^-4  =  t^-6,  d0^2*d0^4  =  d0^6):
  have  hfin  :  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  ((256  *  d0  ^  4)  /  t  ^  4)  =
      T2b  t  d0  :=
      by
        dsimp  only  [T2b]
        rw  [T4OffLF.tinv2  t  htp]
        field_simp
        ring
  calc  (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))
      <=  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  1))  :=  hA
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  1))⁻¹  :=  hB
      _  <=  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  1))⁻¹  :=  hDstep
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  1))  :=  hE
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0))  +  (-(1  :  ℝ)))  :=  hE2
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (T4OffLE.nIdeal  t  d0  ^  (-((1  /  2  -  d0))))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  :=  hF
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  :  ℝ))  :=  hG
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (1  /  (T4OffLE.nIdeal  t  d0))  :=  hH
      _  <=  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  ((256  *  d0  ^  4)  /  t  ^  4)  :=  hI
      _  =  T2b  t  d0  :=  hfin

/-  =================================================================
    S3  THE  T3  CAP:  the  third  EM  term  of  wallLo  at  any  run
    N  in  [nIdeal,  infinity)  is  below  T3b  on  the  band.
       T3(N)  =  (sqrt(3)/216)  *  ||sL  (sL+1)  (sL+2)||  *
                 N^(-(sigma+2))  /  (sigma+2)
   -  chain  (day062):  norm-caps  <=  (t+1)(t+1)(t+2)  <=  (t+1)
    (t+2)^2  <=  cK  t^3;  N^(-(sigma+2))  <=  nIdeal^(-(sigma+2));
    nIdeal^(-(sigma+2))  =  nIdeal^(-sigma)  *  (1/nIdeal)^2;
    nIdeal^-sigma  =  16  d0^2  t^-2  EXACT  (S  S1.1);  1/nIdeal
    <=  256  d0^4  /  t^4  (S  S3.0). -/

/-- Shifted  left-point  norm  shape:  ||sL  +  k||  =
    sqrt((sigma+k)^2  +  t^2)  (shift  to  d0  -  k  and  reuse
    normL). -/
private theorem normLk (t d0 k : ℝ) :
    ‖(t4l_sOffL  t  d0  :  ℂ)  +  (k  :  ℂ)‖  =
      Real.sqrt  ((1  /  2  -  d0  +  k)  ^  2  +  t  ^  2)  :=
  by
    have  hshift  :  (t4l_sOffL  t  d0  :  ℂ)  +  (k  :  ℂ)  =
        (t4l_sOffL  t  (d0  -  k)  :  ℂ)  :=
      by
        dsimp  only  [t4l_sOffL]
        simp  [Complex.ext_iff,  Complex.add_re,  Complex.add_im,  Complex.ofReal_re,
               Complex.ofReal_im,  Complex.mul_re,  Complex.mul_im,  Complex.I_re,  Complex.I_im]
        all_goals  ring
    rw  [hshift,  normL  t  (d0  -  k)]
    have  heq  :  (1  /  2  -  (d0  -  k))  ^  2  =  (1  /  2  -  d0  +  k)  ^  2  :=
      by  ring
    rw  [heq]

/-- S  S3.1  day062  polynomial  cap:  (t+1)(t+2)^2  <=  cK  t^3
    at  t  >=  1000. -/
theorem t3poly (ht : 1000 <=  t)  :
    (t  +  1)  *  (t  +  2)  ^  2  <=  cK  *  t  ^  3  :=
  by
    have  h1  :  t  +  1  <=  (1001  /  1000  :  ℝ)  *  t  :=  by  linarith
    have  h2  :  t  +  2  <=  (501  /  500  :  ℝ)  *  t  :=  by  linarith
    have  h2sq  :  (t  +  2)  ^  2  <=  ((501  /  500  :  ℝ)  *  t)  ^  2  :=
      by gcongr
    have  hm1  :  (t  +  1)  *  (t  +  2)  ^  2  <=
        (1001  /  1000  :  ℝ)  *  t  *  (t  +  2)  ^  2  :=
      mul_le_mul_of_nonneg_right  h1  (by  positivity  :  0  <=  (t  +  2)  ^  2)
    have  hm2  :  (1001  /  1000  :  ℝ)  *  t  *  (t  +  2)  ^  2  <=
        (1001  /  1000  :  ℝ)  *  t  *  ((501  /  500  :  ℝ)  *  t)  ^  2  :=
      mul_le_mul_of_nonneg_left  h2sq  (by  positivity  :  0  <=  (1001  /  1000  :  ℝ)  *  t)
    have  hfin  :  (1001  /  1000  :  ℝ)  *  t  *  ((501  /  500  :  ℝ)  *  t)  ^  2  =
        cK  *  t  ^  3  :=
      by  {  dsimp  only  [cK];  ring  }
    calc  (t  +  1)  *  (t  +  2)  ^  2  <=  (1001  /  1000  :  ℝ)  *  t  *  (t  +  2)  ^  2  :=  hm1
      _  <=  (1001  /  1000  :  ℝ)  *  t  *  ((501  /  500  :  ℝ)  *  t)  ^  2  :=  hm2
      _  =  cK  *  t  ^  3  :=  hfin

/-- S  S3.2  THE  T3  CAP:  at  any  run  N  in  [nIdeal,  infinity)
    on  the  band,  the  T3  term  of  wallLo  is  at  or  below  T3b. -/
theorem t3cap (N : ℕ) (ht : 1000 <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (hN  :  T4OffLE.nIdeal  t  d0  <=  (N  :  ℝ))  :
    (Real.sqrt  3  /  216)  *
      ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
      (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  <=
      T3b  t  d0  :=
  by
    have  hs0  :  0  <  (1  /  2  :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
    have  hsle  :  (1  /  2  :  ℝ)  -  d0  <=  (1  /  2  :  ℝ)  :=  by  linarith  [hdhigh]
    have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hni  :  0  <  T4OffLE.nIdeal  t  d0  :=
      by  {  dsimp  [T4OffLE.nIdeal];  positivity  }
    have  hs2  :  ((1  /  2  :  ℝ)  -  d0)  ^  2  <=  (1  /  4  :  ℝ)  :=
      by
        have  hsq  :  ((1  /  2  :  ℝ)  -  d0)  ^  2  =
            ((1  /  2  :  ℝ)  -  d0)  *  ((1  /  2  :  ℝ)  -  d0)  :=
          pow_two  ((1  /  2  :  ℝ)  -  d0)
        have  hhalf  :  (1  /  4  :  ℝ)  =  (1  /  2  :  ℝ)  *  (1  /  2  :  ℝ)  :=
          by  norm_num
        rw  [hsq,  hhalf]
        exact  mul_le_mul  hsle  hsle  (le_of_lt  hs0)
          (by  norm_num  :  0  <=  (1  /  2  :  ℝ))
    --  (a)  per-factor  norm  caps:
    have  h0  :  ‖t4l_sOffL  t  d0‖  <=  t  +  1  :=
      calc  ‖t4l_sOffL  t  d0‖  =  Real.sqrt  ((1  /  2  -  d0)  ^  2  +  t  ^  2)  :=
            normL  t  d0
        _  <=  Real.sqrt  ((t  +  1)  ^  2)  :=
            Real.sqrt_le_sqrt  (by  nlinarith  [hs2,  ht])
        _  =  t  +  1  :=  Real.sqrt_sq  (by  linarith  [ht])
    have  h1  :  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖  <=  t  +  1  :=
      calc  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖  =
            Real.sqrt  ((1  /  2  -  d0  +  1)  ^  2  +  t  ^  2)  :=
            normLk  t  d0  1
        _  <=  Real.sqrt  ((t  +  1)  ^  2)  :=
            Real.sqrt_le_sqrt  (by  nlinarith  [hs2,  hs0,  hsle,  ht])
        _  =  t  +  1  :=  Real.sqrt_sq  (by  linarith  [ht])
    have  h2  :  ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  <=  t  +  2  :=
      calc  ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  =
            Real.sqrt  ((1  /  2  -  d0  +  2)  ^  2  +  t  ^  2)  :=
            normLk  t  d0  2
        _  <=  Real.sqrt  ((t  +  2)  ^  2)  :=
            Real.sqrt_le_sqrt  (by  nlinarith  [hs2,  hs0,  hsle,  ht])
        _  =  t  +  2  :=  Real.sqrt_sq  (by  linarith  [ht])
    --  (b)  product  norm  cap  <=  (t+1)  (t+1)  (t+2):
    have  h12  :  ‖(t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1)‖  <=
        ‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖  :=
      norm_mul_le  (t4l_sOffL  t  d0)  ((t4l_sOffL  t  d0  :  ℂ)  +  1)
    have  h123  :  ‖((t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1))  *
          ((t4l_sOffL  t  d0  :  ℂ)  +  2)‖  <=
        ‖(t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1)‖  *
          ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  :=
      norm_mul_le  ((t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1))
        ((t4l_sOffL  t  d0  :  ℂ)  +  2)
    have  hnA  :  ‖(t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1)  *
          ((t4l_sOffL  t  d0  :  ℂ)  +  2)‖  <=
        (‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖)  *
          ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  :=
      calc
        ‖(t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1)  *
            ((t4l_sOffL  t  d0  :  ℂ)  +  2)‖  <=
            ‖(t4l_sOffL  t  d0  :  ℂ)  *  ((t4l_sOffL  t  d0  :  ℂ)  +  1)‖  *
              ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  :=  h123
        _  <=  (‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖)  *
              ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  :=
            mul_le_mul_of_nonneg_right  h12  (norm_nonneg  ((t4l_sOffL  t  d0  :  ℂ)  +  2))
    have  h12prod  :  ‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖  <=
        (t  +  1)  *  (t  +  1)  :=
      mul_le_mul  h0  h1  (norm_nonneg  ((t4l_sOffL  t  d0  :  ℂ)  +  1))
        (by  positivity  :  0  <=  t  +  1)
    have  hnB  :  (‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖)  *
          ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  <=  ((t  +  1)  *  (t  +  1))  *  (t  +  2)  :=
      calc
        (‖t4l_sOffL  t  d0‖  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  1‖)  *
            ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  <=
          ((t  +  1)  *  (t  +  1))  *  ‖(t4l_sOffL  t  d0  :  ℂ)  +  2‖  :=
            mul_le_mul_of_nonneg_right  h12prod  (norm_nonneg  ((t4l_sOffL  t  d0  :  ℂ)  +  2))
        _  <=  ((t  +  1)  *  (t  +  1))  *  (t  +  2)  :=
            mul_le_mul_of_nonneg_left  h2  (by  positivity  :  0  <=  (t  +  1)  *  (t  +  1))
    have  hnC  :  ((t  +  1)  *  (t  +  1))  *  (t  +  2)  <=
        ((t  +  1)  *  (t  +  2))  *  (t  +  2)  :=
      by  {  gcongr;  all_goals  linarith  }
    have  hn  :  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  <=
        ((t  +  1)  *  (t  +  2))  *  (t  +  2)  :=
      le_trans  (le_trans  hnA  hnB)  hnC
    --  (c)  the  run  cap:  N^(-(sigma+2))  <=  nIdeal^(-(sigma+2)):
    have  hpolN  :  t  ^  4  /  (256  *  d0  ^  4)  <=  T4OffLE.nIdeal  t  d0  :=
        nIdeal_ge_t4  t  d0  ht  hdlow  hdhigh
    have  hdhalf  :  d0  <=  (1  /  2  :  ℝ)  :=  by  linarith  [hdhigh]
    have  hd0sq  :  d0  ^  2  <=  (1  /  4  :  ℝ)  :=
      by
        calc  d0  ^  2  =  d0  *  d0  :=  pow_two  d0
          _  <=  (1  /  2  :  ℝ)  *  (1  /  2  :  ℝ)  :=
            mul_le_mul  hdhalf  hdhalf  (le_of_lt  hd0p)  (by  norm_num)
          _  =  (1  /  4  :  ℝ)  :=  by  norm_num
    have  hd0p4  :  d0  ^  4  <=  (1  /  16  :  ℝ)  :=
      by
        have  hL  :  d0  ^  4  =  (d0  ^  2)  *  (d0  ^  2)  :=  by  ring
        have  hR  :  (1  /  16  :  ℝ)  =  (1  /  4  :  ℝ)  *  (1  /  4  :  ℝ)  :=
          by  norm_num
        rw  [hL,  hR]
        exact  mul_le_mul  hd0sq  hd0sq
          (by  positivity  :  0  <=  d0  ^  2)
          (by  norm_num  :  0  <=  (1  /  4  :  ℝ))
    have  h16N  :  256  *  d0  ^  4  <=  (1000  :  ℝ)  ^  4  :=
      by
        have  h16N'  :  256  *  (1  /  16  :  ℝ)  <=  (1000  :  ℝ)  ^  4  :=
          by  norm_num
        calc  256  *  d0  ^  4  <=  256  *  (1  /  16  :  ℝ)  :=
              mul_le_mul_of_nonneg_left  hd0p4  (by  norm_num  :  0  <=  (256  :  ℝ))
          _  <=  (1000  :  ℝ)  ^  4  :=  h16N'
    have  htp4  :  (1000  :  ℝ)  ^  4  <=  t  ^  4  :=
      by gcongr
    have  h256t4  :  256  *  d0  ^  4  <=  t  ^  4  :=
      le_trans  h16N  htp4
    have  h1N  :  (1  :  ℝ)  <=  t  ^  4  /  (256  *  d0  ^  4)  :=
      by
        rw  [le_div_iff₀  (by  positivity  :  0  <  256  *  d0  ^  4)]
        nlinarith  [h256t4]
    have  hge1N  :  (1  :  ℝ)  <=  T4OffLE.nIdeal  t  d0  :=
      le_trans  h1N  hpolN
    have  hNge1  :  (1  :  ℝ)  <=  (N  :  ℝ)  :=
      le_trans  hge1N  hN
    have  hexp  :  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  <=
        (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  :=
      calc  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  =
            ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  2))⁻¹  :=
            by  rw  [rpow_neg  (by  linarith  [hNge1])  ((1  /  2  -  d0)  +  2)]
        _  <=  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  2))⁻¹  :=
            by
              have  hNexp  :  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  2))  <=
                  (N  :  ℝ)  ^  ((1  /  2  -  d0)  +  2)  :=
                rpow_le_rpow  (le_of_lt  hni)  hN
                  (by  positivity  :  0  <=  (1  /  2  -  d0)  +  2)
              have  hNpos  :  0  <  (N  :  ℝ)  ^  ((1  /  2  -  d0)  +  2)  :=
                rpow_pos_of_pos  (by  linarith  [hNge1])  ((1  /  2  -  d0)  +  2)
              have  hnpos  :  0  <  T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  2)  :=
                rpow_pos_of_pos  hni  ((1  /  2  -  d0)  +  2)
              rw  [inv_eq_one_div  ((N  :  ℝ)  ^  ((1  /  2  -  d0)  +  2)),
                   inv_eq_one_div  (T4OffLE.nIdeal  t  d0  ^  ((1  /  2  -  d0)  +  2))]
              exact  (one_div_le_one_div  hNpos  hnpos).mpr  hNexp
        _  =  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  :=
            (rpow_neg  (le_of_lt  hni)  ((1  /  2  -  d0)  +  2)).symm
    --  (d)  the  exact  split:
    --  nIdeal^(-(sigma+2))  =  nIdeal^(-sigma)  *  (1/nIdeal)^2:
    have  hexp3  :  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  =
        (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  *
          ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))  :=
      by
        have  heq  :  -((1  /  2  -  d0)  +  2)  =
            ((-((1  /  2  -  d0)))  +  (-(1  :  ℝ)))  +  (-(1  :  ℝ))  :=
          by  ring
        rw  [heq,
          rpow_add  hni  ((-((1  /  2  -  d0)))  +  (-(1  :  ℝ)))  (-(1  :  ℝ)),
          rpow_add  hni  (-((1  /  2  -  d0)))  (-(1  :  ℝ)),
          rpow_neg_one  (T4OffLE.nIdeal  t  d0),
          inv_eq_one_div  (T4OffLE.nIdeal  t  d0),
          mul_assoc]
    --  (e)  the  knife-edge  value  +  the  reciprocal  cap:
    have  hpe  :  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  =
        16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=
      nIdeal_pow_sig  t  d0  htp  hd0p  hdhigh
    have  hinv  :  1  /  (T4OffLE.nIdeal  t  d0)  <=  (256  *  d0  ^  4)  /  t  ^  4  :=
      nIdeal_inv_cap  t  d0  ht  hdlow  hdhigh
    have  hq  :  ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))  <=
        ((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4)  :=
      mul_le_mul  hinv  hinv  (by  positivity  :  0  <=  1  /  T4OffLE.nIdeal  t  d0)
        (by  positivity  :  0  <=  (256  *  d0  ^  4)  /  t  ^  4)
    have  hbox  :  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  *
          ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))  <=
        (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *
          (((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4))  :=
      mul_le_mul  (le_of_eq  hpe)  hq
        (by  positivity  :  0  <=  (1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))
        (by  positivity  :  0  <=  16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))
    let  A  :  ℝ  :=  (Real.sqrt  3  /  216)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)
    have  hApos  :  0  <=  A  :=  by  positivity
    have  hcK_  :  0  <  cK  :=  by  {  dsimp  [cK];  norm_num  }
    have  hL1  :  (Real.sqrt  3  /  216)  *  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
            (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =  A  *
        ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  :=
      by  ring
    have  hR1  :  (Real.sqrt  3  /  216)  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  *
            (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =
        A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  :=
      by  ring
    have  hstep1  :  A  *  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  <=
          A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  :=
      by
        have  hL  :  A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  =
            A  *  ((t  +  1)  *  (t  +  2)  *  (t  +  2))  :=
          by  ring
        rw  [hL]
        exact  mul_le_mul_of_nonneg_left  hn  hApos
    have  hL2  :  (Real.sqrt  3  /  216)  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  *
            (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =
        A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  :=
      by  ring
    have  hR2  :  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =
        A  *  (cK  *  t  ^  3)  :=
      by  ring
    have  hstep2  :  A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  <=  A  *  (cK  *  t  ^  3)  :=
      by
        have  hL  :  A  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  =
            A  *  ((t  +  1)  *  (t  +  2)  ^  2)  :=
          by  ring
        rw  [hL]
        exact  mul_le_mul_of_nonneg_left  (t3poly  t  ht)  hApos
    --  (f)  assemble:
    calc  (Real.sqrt  3  /  216)  *  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
          (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)
      <=  (Real.sqrt  3  /  216)  *  ((t  +  1)  *  (t  +  2))  *  (t  +  2)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  :=
        by  simpa  only  [hL1,  hR1]  using  hstep1
      _  <=  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  :=
        by  simpa  only  [hL2,  hR2]  using  hstep2
      _  <=  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  :=
        by
          have  hL3  :  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =
              ((Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  /  ((1  /  2  -  d0)  +  2))  *
              (N  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  :=
            by  ring
          have  hR3  :  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  =
              ((Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  /  ((1  /  2  -  d0)  +  2))  *
              (T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  :=
            by  ring
          rw  [hL3,  hR3]
          exact  mul_le_mul_of_nonneg_left  hexp  (le_of_lt  (by
            apply  div_pos
            · apply  mul_pos
              · norm_num
              ·  apply  mul_pos  hcK_  (pow_pos  (by  linarith  [ht])  3)
            ·  linarith  [hdhigh]))
      _  =  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  ((T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  *  ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0)))  /  ((1  /  2  -  d0)  +  2)  :=
        by  rw  [hexp3]
      _  <=  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  ((16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4)))  /  ((1  /  2  -  d0)  +  2)  :=
        by
          have  hL5  :  (Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  *  (((T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  *  ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))))  /  ((1  /  2  -  d0)  +  2)  =
              ((Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  /  ((1  /  2  -  d0)  +  2))  *
              (((T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)))  *  ((1  /  T4OffLE.nIdeal  t  d0)  *  (1  /  T4OffLE.nIdeal  t  d0))))  :=
            by  ring
          have  hR5  :  (Real.sqrt  3  / 216)  *  (cK  *  t  ^  3)  *  (((16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4))))  /  ((1  /  2  -  d0)  +  2)  =
              ((Real.sqrt  3  /  216)  *  (cK  *  t  ^  3)  /  ((1  /  2  -  d0)  +  2))  *
              (((16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4))))  :=
            by  ring
          rw  [hL5,  hR5]
          exact  mul_le_mul_of_nonneg_left  hbox  (le_of_lt  (by
            apply  div_pos
            · apply  mul_pos
              · norm_num
              ·  apply  mul_pos  hcK_  (pow_pos  (by  linarith  [ht])  3)
            ·  linarith  [hdhigh]))
      _  =  T3b  t  d0  :=
        by  {  dsimp  only  [T3b];  field_simp  }

/-  =================================================================
   S4  THE  OWN-MASS  CAP  (the  pin's  right  side,  in  body)
   =================================================================
   ||poff  t  d0  t||  =  S4O.mown  t  d0  (in-body  FUnif  identity)
   <=  (4  d0^2  /  t^2)  *  (1  +  1  /  (16  t^2))  *  exp  (1  /
   t^2)  (the  in-tree  25n  scale  window,  S4O.hMownScale)  -  no
   measurement.  -/

/-- S  S4.1  THE  OWN-MASS  CAP  ON  THE  BAND:  ||poff  t  d0  t||  <=
    (4  d0^2  /  t^2)  *  (1  +  1  /  (16  *  t^2))  *  exp  (1  /
    t^2). -/
theorem ownCap (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    ‖poff  t  d0  t‖  <=  (4  *  d0  ^  2  /  t  ^  2)  *
      (1  +  1  /  (16  *  t  ^  2))  *  Real.exp  (1  /  t  ^  2)  :=
  by
    have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hown  :  ‖poff  t  d0  t‖  =  S4O.mown  t  d0  :=
      FUnif.poffOwnMass  t  d0  htp  hd0p  (le_of_lt  hdhigh)
    have  hU  :  S4O.mown  t  d0  <=  (4  *  d0  ^  2  /  t  ^  2)  *
        (1  +  1  /  (16  *  t  ^  2))  *  Real.exp  (1  /  t  ^  2)  :=
      (S4O.hMownScale  t  d0  htp  hd0p  (le_of_lt  hdhigh)).2
    simpa  only  [hown]  using  hU

/-  =================================================================
   S5  THE  IN-BODY  PIN  (the  0258  work  item  closed  in  body)
   =================================================================
   wallLo  (t,  d0,  Noff)  >  ||poff  t  d0  t||  on  the  band  -
   every  step  a  closed-form  bound  (the  day062  chain):
   (a)  wallLo  (Noff)  >=  4  d0^2  t^-2  *  2^(1/2  +  d0)  -  T2b
       -  T3b  -  the  T1  lower  bound  from  Noff  <=  2  nIdeal  and
       the  S1.1  knife  edge  (nIdeal^(-sigma)  =  16  d0^2  t^-2),
       T2  /  T3  caps  from  t2cap  /  t3cap  at  N  =  Noff;
   (b)  that  L0b  >  4  d0^2  t^-2  *  (1  +  1/(16  t^2))  *
       exp  (1/t^2)  -  from  2^(1/2  +  d0)  >=  sqrt  2,  T2b  <=
       lead  *  1e-8,  T3b  <=  lead  *  1e-9,  exp  (1/t^2)  <=  1  +
       2/t^2  (lead  :=  4  d0^2  /  t^2),  strict  norm_num  margin;
   (c)  that  cap  >=  ||poff||  (S4.1  -  in-body  own  mass).
   No  RH  claim:  a  margin  record  in  closed  form.  The  measured
   pin  of  0258  is  now  proven  in  body  on  the  band.  -/

/-- S  S5.1  T2b  <=  lead  *  1e-8  on  the  band,  where  lead  :=
    4  d0^2  /  t^2.  Chain:  sqrt  (t^2  +  1/4)  <=  (6/5)  t,
    then  (6/5)  t  /  12  *  4096  d0^6  /  t^6  =  lead  *  (512/5)
    d0^4  /  t^3,  and  (512/5)  d0^4  /  t^3  <=  (512/5)(1/16)  /
    1000^3  <  1e-8. -/
theorem t2bLead (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    T2b  t  d0  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  8)  :=
  by
    have  hdhalf  :  d0  <=  (1  /  2  :  ℝ)  :=  by  linarith  [hdhigh]
    have  hd0sq  :  d0  ^  2  <=  (1  /  4  :  ℝ)  :=
      by
        calc  d0  ^  2  =  d0  *  d0  :=  pow_two  d0
          _  <=  (1  /  2  :  ℝ)  *  (1  /  2  :  ℝ)  :=
            mul_le_mul  hdhalf  hdhalf  (by  linarith  [hdlow]  :  0  <=  d0)  (by  norm_num)
          _  =  (1  /  4  :  ℝ)  :=  by  norm_num
    have  hd0p4  :  d0  ^  4  <=  (1  /  16  :  ℝ)  :=
      by
        calc  d0  ^  4  =  (d0  ^  2)  *  (d0  ^  2)  :=  by  ring
          _  <=  (1  /  4  :  ℝ)  *  (1  /  4  :  ℝ)  :=
            mul_le_mul  hd0sq  hd0sq  (by  positivity  :  0  <=  d0  ^  2)  (by  norm_num)
          _  =  (1  /  16  :  ℝ)  :=  by  norm_num
    have  hsqrt  :  Real.sqrt  (t  ^  2  +  1  /  4)  <=  (6  /  5  :  ℝ)  *  t  :=
      (Real.sqrt_le_iff.2  ⟨by  positivity,  by  nlinarith  [ht]  ⟩)
    have  hstep1  :  Real.sqrt  (t  ^  2  +  1  /  4)  /  12  <=
        (6  /  5  :  ℝ)  *  t  /  12  :=
      by
        rw  [div_le_div_iff₀  (by  norm_num  :  0  <  (12  :  ℝ))  (by  norm_num  :  0  <  (12  :  ℝ))]
        nlinarith  [hsqrt]
    have  ht3  :  (1000  :  ℝ)  ^  3  <=  t  ^  3  :=  by  gcongr
    have  hreA  :  (512  /  5  :  ℝ)  *  d0  ^  4  /  t  ^  3  =  ((512  /  5  :  ℝ)  /  t  ^  3)  *  d0  ^  4  :=  by  ring
    have  hreB  :  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  t  ^  3  =  ((512  /  5  :  ℝ)  /  t  ^  3)  *  (1  /  16)  :=  by  ring
    have  hreC  :  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  t  ^  3  =  ((512  /  5  :  ℝ)  *  (1  /  16  :  ℝ))  *  (1  /  t  ^  3)  :=  by  ring
    have  hinv3  :  1  /  t  ^  3  <=  1  /  (1000  :  ℝ)  ^  3  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  3)  (by  norm_num  :  0  <  (1000  :  ℝ)  ^  3)]
        linarith  [ht3]
    have  hsmallA  :  (512  /  5  :  ℝ)  *  d0  ^  4  /  t  ^  3  <=  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  t  ^  3  :=
      by
        rw  [hreA,  hreB]
        exact  mul_le_mul_of_nonneg_left  hd0p4  (by  positivity  :  0  <=  (512  /  5  :  ℝ)  /  t  ^  3)
    have  hsmallB  :  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  t  ^  3  <=
        (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  (1000  :  ℝ)  ^  3  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  3)  (by  norm_num  :  0  <  (1000  :  ℝ)  ^  3)]
        exact  mul_le_mul_of_nonneg_left  ht3  (by  positivity  :  0  <=  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ))
    have  hsmallC  :  (512  /  5  :  ℝ)  *  (1  /  16  :  ℝ)  /  (1000  :  ℝ)  ^  3  <=  (1  /  (10  :  ℝ)  ^  8)  :=  by  norm_num
    have  hsmall  :  (512  /  5  :  ℝ)  *  d0  ^  4  /  t  ^  3  <=  (1  /  (10  :  ℝ)  ^  8)  :=
      le_trans  (le_trans  hsmallA  hsmallB)  hsmallC
    have  hshape  :  Real.sqrt  (t  ^  2  +  1  /  4)  /  12  *  (4096  :  ℝ)  *  d0  ^  6  /  t  ^  6  =
        (Real.sqrt  (t  ^ 2  +  1  /  4)  /  12)  *  ((4096  :  ℝ)  *  d0  ^  6  /  t  ^  6)  :=  by  ring
    calc  T2b  t  d0
      =  Real.sqrt  (t  ^  2  +  1  /  4)  /  12  *  (4096  :  ℝ)  *  d0  ^  6  /  t  ^  6  :=  by  simp  only  [T2b]
      _  =  (Real.sqrt  (t  ^  2  +  1  /  4)  /  12)  *  ((4096  :  ℝ)  *  d0  ^  6  /  t  ^  6)  :=  hshape
      _  <=  ((6  /  5  :  ℝ)  *  t  /  12)  *  ((4096  :  ℝ)  *  d0  ^  6  /  t  ^  6)  :=
        by  exact  mul_le_mul_of_nonneg_right  hstep1  (by  positivity  :  0  <=  (4096  :  ℝ)  *  d0  ^  6  /  t  ^  6)
      _  =  (4  *  d0  ^  2  /  t  ^  2)  *  ((512  /  5  :  ℝ)  *  d0  ^  4  /  t  ^  3)  :=  by  {  field_simp;  ring  }
      _  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  8)  :=
        by  exact  mul_le_mul_of_nonneg_left  hsmall  (by  positivity  :  0  <=  4  *  d0  ^  2  /  t  ^  2)

/-- S  S5.2  T3b  <=  lead  *  1e-9  on  the  band  (lead  :=  4  d0^2
    /  t^2)  -  from  sqrt  3  <=  2,  cK  <=  2,  1/(sigma+2)  <=
    1/2,  d0^8  <=  1/256,  t^5  >=  1000^5:
    T3b  <=  lead  *  (65536/27)  d0^8  /  t^5  <=  lead  *
    (65536/27)(1/256)  /  1000^5  <  lead  *  1e-9. -/
theorem t3bLead (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    T3b  t  d0  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  9)  :=
  by
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hdhalf  :  d0  <=  (1  /  2  :  ℝ)  :=  by  linarith  [hdhigh]
    have  hd0sq  :  d0  ^  2  <=  (1  /  4  :  ℝ)  :=
      by
        calc  d0  ^  2  =  d0  *  d0  :=  pow_two  d0
          _  <=  (1  /  2  :  ℝ)  *  (1  /  2  :  ℝ)  :=
            mul_le_mul  hdhalf  hdhalf  (by  linarith  [hdlow]  :  0  <=  d0)  (by  norm_num)
          _  =  (1  /  4  :  ℝ)  :=  by  norm_num
    have  hd0p4  :  d0  ^  4  <=  (1  /  16  :  ℝ)  :=
      by
        calc  d0  ^  4  =  (d0  ^  2)  *  (d0  ^  2)  :=  by  ring
          _  <=  (1  /  4  :  ℝ)  *  (1  /  4  :  ℝ)  :=
            mul_le_mul  hd0sq  hd0sq  (by  positivity  :  0  <=  d0  ^  2)  (by  norm_num)
          _  =  (1  /  16  :  ℝ)  :=  by  norm_num
    have  hd0p8  :  d0  ^  8  <=  (1  /  256  :  ℝ)  :=
      by
        calc  d0  ^  8  =  (d0  ^  4)  *  (d0  ^  4)  :=  by  ring
          _  <=  (1  /  16  :  ℝ)  *  (1  /  16  :  ℝ)  :=
            mul_le_mul  hd0p4  hd0p4  (by  positivity  :  0  <=  d0  ^  4)  (by  norm_num  :  0  <=  (1  /  16  :  ℝ))
          _  =  (1  /  256  :  ℝ)  :=  by  norm_num
    have  hcK2  :  cK  <=  2  :=  by  {  dsimp  only  [cK];  norm_num  }
    have  hsqrt3  :  Real.sqrt  3  <=  2  :=
      (Real.sqrt_le_iff.2  ⟨by  norm_num,  by  norm_num  ⟩)
    have  hre2  :  (Real.sqrt  3  /  216)  *  cK  *  t  ^  3  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *
          ((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4)  /  ((1  /  2  -  d0)  +  2)  =
        (Real.sqrt  3  /  216)  *  cK  *  ((1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2)))  :=
      by
        rw  [T4OffLF.tinv2  t  htp]
        field_simp
        ring
    have  hs  :  Real.sqrt  3  /  216  <=  2  /  216  :=
      by
        rw  [div_le_div_iff₀  (by  norm_num  :  0  <  (216  :  ℝ))  (by  norm_num  :  0  <  (216  :  ℝ))]
        nlinarith  [hsqrt3]
    have  hA  :  (Real.sqrt  3  /  216)  *  cK  <=  (2  /  216  :  ℝ)  *  2  :=
      calc  (Real.sqrt  3  /  216)  *  cK
        _  <=  (2  /  216  :  ℝ)  *  cK  :=  by  simpa  [mul_comm]  using  mul_le_mul_of_nonneg_left  hs  (by  norm_num  [cK]  :  0  <=  cK)
        _  <=  (2  /  216  :  ℝ)  *  2  :=  mul_le_mul_of_nonneg_left  hcK2  (by  norm_num  :  0  <=  (2  /  216  :  ℝ))
    have  hC  :  1  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2))  <=  1  /  (t  ^  7  *  2)  :=
      by
        have  hs2  :  (2  :  ℝ)  <  (1  /  2  -  d0)  +  2  :=  by  linarith  [hdhigh]
        have  hs2m  :  t  ^  7  *  2  <  t  ^  7  *  ((1  /  2  -  d0)  +  2)  :=
          mul_lt_mul_of_pos_left  hs2  (by  positivity  :  0  <  t  ^  7)
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  7  *  ((1  /  2  -  d0)  +  2))  (by  positivity  :  0  <  t  ^  7  *  2)]
        simpa  [mul_one]  using  le_of_lt  hs2m
    have  hreB  :  (1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2))  <=
        (1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  2)  :=
      by
        have  hre3  :  (1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2))  =
            (1048576  *  d0  ^  10)  *  (1  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2)))  :=  by  ring
        have  hre4  :  (1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  2)  =
            (1048576  *  d0  ^  10)  *  (1  /  (t  ^  7  *  2))  :=  by  ring
        rw  [hre3,  hre4]
        exact  mul_le_mul_of_nonneg_left  hC  (by  positivity  :  0  <=  1048576  *  d0  ^  10)
    have  hsmallB  :  (65536  /  27  :  ℝ)  *  d0  ^  8  /  t  ^  5  <=  (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ)  /  t  ^  5  :=
      by
        have  hre  :  (65536  /  27  :  ℝ)  *  d0  ^  8  /  t  ^  5  =  ((65536  /  27  :  ℝ)  /  t  ^  5)  *  d0  ^  8  :=  by  ring
        have  hre2b  :  (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ)  /  t  ^  5  =  ((65536  /  27  :  ℝ)  /  t  ^  5)  *  (1  /  256)  :=  by  ring
        rw  [hre,  hre2b]
        exact  mul_le_mul_of_nonneg_left  hd0p8  (by  positivity  :  0  <=  (65536  /  27  :  ℝ)  /  t  ^  5)
    have  ht5  :  (1000  :  ℝ)  ^  5  <=  t  ^  5  :=  by  gcongr
    have  hinv5  :  1  /  t  ^  5  <=  1  /  (1000  :  ℝ)  ^  5  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  5)  (by  norm_num  :  0  <  (1000  :  ℝ)  ^  5)]
        linarith  [ht5]
    have  hsmallC  :  (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ)  /  t  ^  5  <=
        (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ)  /  (1000  :  ℝ)  ^  5  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  5)  (by  norm_num  :  0  <  (1000  :  ℝ)  ^  5)]
        exact  mul_le_mul_of_nonneg_left  ht5  (by  positivity  :  0  <=  (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ))
    have  hsmallD  :  (65536  /  27  :  ℝ)  *  (1  /  256  :  ℝ)  /  (1000  :  ℝ)  ^  5  <=  (1  /  (10  :  ℝ)  ^  9)  :=  by  norm_num
    have  hsmall  :  (65536  /  27  :  ℝ)  *  d0  ^  8  /  t  ^  5  <=  (1  /  (10  :  ℝ)  ^  9)  :=
      le_trans  (le_trans  hsmallB  hsmallC)  hsmallD
    calc  T3b  t  d0
      =  (Real.sqrt  3  /  216)  *  cK  *  t  ^  3  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *
            ((256  *  d0  ^  4)  /  t  ^  4)  *  ((256  *  d0  ^  4)  /  t  ^  4)  /
            ((1  /  2  -  d0)  +  2)  :=  by  simp  only  [T3b]
      _  =  (Real.sqrt  3  /  216)  *  cK  *  ((1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2)))  :=  hre2
      _  <=  ((2  /  216  :  ℝ)  *  2)  *  ((1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  2))  :=
        by  exact  mul_le_mul  hA  hreB  (by  positivity  :  0  <=  (1048576  :  ℝ)  *  d0  ^  10  /  (t  ^  7  *  ((1  /  2  -  d0)  +  2)))  (by  norm_num  :  0  <=  (2  /  216  :  ℝ)  *  2)
      _  =  (4  *  d0  ^  2  /  t  ^  2)  *  ((65536  /  27  :  ℝ)  *  d0  ^  8  /  t  ^  5)  :=  by  {  field_simp;  ring  }
      _  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  9)  :=
        by  exact  mul_le_mul_of_nonneg_left  hsmall  (by  positivity  :  0  <=  4  *  d0  ^  2  /  t  ^  2)

/-- S  S5.3  THE  STRICT  GAP  ON  THE  BAND:  lead  *  2^(1/2  +
    d0)  -  T2b  -  T3b  >  lead  *  (1  +  1  /  (16  t^2))  *
    exp  (1/t^2),  where  lead  :=  4  d0^2  /  t^2  -  from
    2^(1/2  +  d0)  >=  sqrt  2  (d0  >  0),  T2b  <=  lead  1e-8  (S5.1),
    T3b  <=  lead  1e-9  (S5.2),  and  exp  (1/t^2)  <=  1  +  2  /
    t^2  (Real.exp_bound',  n  =  1),  with  the  strict  norm_num
    core  sqrt  2  >  1.4142  >  1.0000031  +  1e-8  +  1e-9. -/
theorem t5strict (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  -
      T2b  t  d0  -  T3b  t  d0  >
      (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  (16  *  t  ^  2))  *
        Real.exp  (1  /  t  ^  2)  :=
  by
    have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
    have  hleadp  :  0  <  4  *  d0  ^  2  /  t  ^  2  :=  by  positivity
    have  hrpow  :  (2  :  ℝ)  ^  (1  /  2  :  ℝ)  <=  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      rpow_le_rpow_of_exponent_le  (by  norm_num  :  (1  :  ℝ)  <=  2)  (by  linarith  [hd0p])
    have  hsqrt2  :  Real.sqrt  2  <=  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      le_trans  ((Real.sqrt_eq_rpow  2).le  :  Real.sqrt  2  <=  (2  :  ℝ)  ^  (1  /  2  :  ℝ))  hrpow
    have  hT1g  :  (4  *  d0  ^  2  /  t  ^  2)  *  Real.sqrt  2  <=
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      mul_le_mul_of_nonneg_left  hsqrt2  (by  positivity  :  0  <=  4  *  d0  ^  2  /  t  ^  2)
    have  hT2b  :  T2b  t  d0  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  8)  :=
      t2bLead  t  d0  ht  hdlow  hdhigh
    have  hT3b  :  T3b  t  d0  <=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  9)  :=
      t3bLead  t  d0  ht  hdlow  hdhigh
    have  hexpU  :  Real.exp  (1  /  t  ^  2)  <=  1  +  2  /  t  ^  2  :=
      by
        have  hx  :  (1  /  t  ^  2  :  ℝ)  <=  1  :=
          by
            rw  [div_le_one  (by  positivity  :  0  <  t  ^  2)]
            nlinarith  [show  (1000  :  ℝ)  ^  2  <=  t  ^  2  from  by  gcongr]
        have  h  :=  Real.exp_bound'  (x  :=  1  /  t  ^  2)  (by  positivity)  hx  (n  :=  1)  (by  norm_num)
        have  hsum  :  Finset.sum  (Finset.range  1)  (fun  m  =>  (1  /  t  ^  2)  ^  m  /  (m  :  ℕ).factorial)  =  1  :=  by
          rw  [Finset.sum_range_one]
          norm_num
        have  htail  :  (1  /  t  ^  2)  ^  1  *  (((1  :  ℕ)  :  ℝ)  +  1)  /  (((1  :  ℕ).factorial  :  ℝ)  *  ((1  :  ℕ)  :  ℝ))  =  2  /  t  ^  2  :=  by
          norm_num
          ring
        rw  [hsum,  htail]  at  h
        exact  h
    have  hinv  :  1  /  t  ^  2  <=  1  /  1000000  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  t  ^  2)  (by  norm_num  :  0  <  (1000000  :  ℝ))]
        nlinarith  [show  (1000  :  ℝ)  ^  2  <=  t  ^  2  from  by  gcongr]
    have  h2t  :  2  /  t  ^  2  <=  2  /  1000000  :=
      by
        rw  [show  (2  /  t  ^  2  :  ℝ)  =  2  *  (1  /  t  ^  2)  by  ring,  show  (2  /  1000000  :  ℝ)  =  2  *  (1  /  1000000)  by  ring]
        exact  mul_le_mul_of_nonneg_left  hinv  (by  norm_num  :  0  <=  (2  :  ℝ))
    have  hexp2  :  Real.exp  (1  /  t  ^  2)  <=  1  +  2  /  1000000  :=
      calc  Real.exp  (1  /  t  ^  2)
        _  <=  1  +  2  /  t  ^  2  :=  hexpU
        _  <=  1  +  2  /  1000000  :=  by  simpa  [add_comm]  using  add_le_add_left  h2t  1
    have  h16  :  1  /  (16  *  t  ^  2)  <=  1  /  16000000  :=
      by
        rw  [div_le_div_iff₀  (by  positivity  :  0  <  16  *  t  ^  2)  (by  norm_num  :  0  <  (16000000  :  ℝ))]
        nlinarith  [show  (1000  :  ℝ)  ^  2  <=  t  ^  2  from  by  gcongr]
    have  hR  :  (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  (16  *  t  ^  2))  *
        Real.exp  (1  /  t  ^  2)  <=
      (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  16000000)  *  (1  +  2  /  1000000)  :=
      by
        have  hR1  :  (1  +  1  /  (16  *  t  ^  2))  *  Real.exp  (1  /  t  ^  2)  <=
            (1  +  1  /  16000000)  *  (1  +  2  /  1000000)  :=
          by
            have  hadd1  :  1  +  1  /  (16  *  t  ^  2)  <=  1  +  1  /  16000000  :=
              by  linarith  [h16]
            exact  mul_le_mul  hadd1  hexp2  (by  positivity  :  0  <=  Real.exp  (1  /  t  ^  2))  (by  positivity  :  0  <=  (1  +  1  /  16000000  :  ℝ))
        rw  [mul_assoc  (4  *  d0  ^  2  /  t  ^  2)  (1  +  1  /  (16  *  t  ^  2))  (Real.exp  (1  /  t  ^  2)),
             mul_assoc  (4  *  d0  ^  2  /  t  ^  2)  (1  +  1  /  16000000)  (1  +  2  /  1000000)]
        exact  mul_le_mul_of_nonneg_left  hR1  (by  positivity  :  0  <=  4  *  d0  ^  2  /  t  ^  2)
    have  hsqrt2gt  :  Real.sqrt  2  >  (14142  :  ℝ)  /  10000  :=
      (Real.lt_sqrt  (by  norm_num  :  0  <=  (14142  :  ℝ)  /  10000)).2  (by  norm_num)
    have  hRnum  :  (1  +  1  /  16000000)  *  (1  +  2  /  1000000)  <  (1000003  :  ℝ)  /  1000000  :=
      by  norm_num
    have  hcore  :  Real.sqrt  2  -  1  /  (10  :  ℝ)  ^  8  -  1  /  (10  :  ℝ)  ^  9  >
        (1000003  :  ℝ)  /  1000000  :=
      by  linarith  [hsqrt2gt]
    have  hstrict  :  Real.sqrt  2  -  1  /  (10  :  ℝ)  ^  8  -  1  /  (10  :  ℝ)  ^  9  >
        (1  +  1  /  16000000)  *  (1  +  2  /  1000000)  :=
      by  linarith  [hcore,  hRnum]
    calc  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  -  T2b  t  d0  -  T3b  t  d0
      _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  Real.sqrt  2  -
            (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  8)  -
            (4  *  d0  ^  2  /  t  ^  2)  *  (1  /  (10  :  ℝ)  ^  9)  :=
        by  nlinarith  [hT1g,  hT2b,  hT3b]
      _  =  (4  *  d0  ^  2  /  t  ^  2)  *
          (Real.sqrt  2  -  1  /  (10  :  ℝ)  ^  8  -  1  /  (10  :  ℝ)  ^  9)  :=
        by  ring
      _  >  (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  16000000)  *  (1  +  2  /  1000000)  :=
        by  rw  [mul_assoc  (4  *  d0  ^  2  /  t  ^  2)  (1  +  1  /  16000000)  (1  +  2  /  1000000)];  exact  mul_lt_mul_of_pos_left  hstrict  hleadp
      _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  (16  *  t  ^  2))  *  Real.exp  (1  /  t  ^  2)  :=
        by  exact  hR

/-- S  S5.4  THE  IN-BODY  PIN:  on  the  band,  wallLo  at  the
    Noff  run  is  STRICTLY  ABOVE  the  own  mass  (0258's  measured
    pin,  now  proven  in  body  in  closed  form  -  no  measured
    datum,  no  RH  claim):
    wallLo  (t,  d0,  Noff)  >  ||poff  t  d0  t||.
    The  S1  side  of  T4OffLE.t4LE_squeeze_decoupled  no  longer
    needs  an  external  pin  input  on  the  band. -/
theorem pin (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  >  ‖poff  t  d0  t‖  :=
  by
    have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hs0  :  0  <  (1  /  2  :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
    have  hNoffge  :  T4OffLE.nIdeal  t  d0  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=
      (T4OffLE.t4LE_ceil_bounds  t  d0  ht  hdlow  hdhigh).1
    have  hNoff2  :  (T4OffLE.Noff  t  d0  :  ℝ)  <=  2  *  T4OffLE.nIdeal  t  d0  :=
      (T4OffLE.t4LE_ceil_bounds  t  d0  ht  hdlow  hdhigh).2
    have  hNge1  :  (1  :  ℝ)  <=  T4OffLE.nIdeal  t  d0  :=
      T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh
    have  hNp  :  0  <  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by  linarith  [hNoffge,  hNge1]
    have  h2nIp  :  0  <  2  *  T4OffLE.nIdeal  t  d0  :=  by  linarith  [hNge1]
    have  hNsig  :  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0)  <=
        (2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0)  :=
      rpow_le_rpow  (le_of_lt  hNp)  hNoff2  (le_of_lt  hs0)
    have  hNpsig  :  0  <  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0)  :=
      rpow_pos_of_pos  hNp  (1  /  2  -  d0)
    have  h2nIpsig  :  0  <  (2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0)  :=
      rpow_pos_of_pos  h2nIp  (1  /  2  -  d0)
    have  hrec  :  1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0))  <=
        1  /  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0))  :=
      (one_div_le_one_div  h2nIpsig  hNpsig).mpr  hNsig
    have  hs  :  (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))  =
        (1  /  2)  *  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0))⁻¹  :=
      by  rw  [rpow_neg  (le_of_lt  hNp)  (1  /  2  -  d0)]
    have  ht1mid  :  (1  /  2  :  ℝ)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0))⁻¹  =
        (1  /  2)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  :=
      by  rw  [rpow_neg  (le_of_lt  h2nIp)  (1  /  2  -  d0)]
    have  hsplit  :  (1  /  2  :  ℝ)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  =
        (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  :=
      by
        rw  [mul_rpow  (by  norm_num  :  (0  :  ℝ)  <=  2)  (by  linarith  [hNge1]  :  0  <=  T4OffLE.nIdeal  t  d0)]
        ring
    have  hknife  :  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  =
        (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  :=
      by  rw  [nIdeal_pow_sig  t  d0  htp  hd0p  hdhigh]
    have  he  :  (-(1  /  2  -  d0)  :  ℝ)  =  (d0  -  1  /  2  :  ℝ)  :=  by  ring
    have  hT1e  :  (1  /  2  :  ℝ)  *  16  *  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  =
        4  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      by
        rw  [he]
        have  h8  :  (1  /  2  :  ℝ)  *  16  =  8  :=  by  norm_num
        rw  [h8]
        have  hp3  :  (8  :  ℝ)  =  (2  :  ℝ)  ^  (3  :  ℝ)  :=  by  norm_num
        rw  [hp3]
        rw  [(Real.rpow_add  (by  norm_num  :  (0  :  ℝ)  <  2)  (3  :  ℝ)  (d0  -  1  /  2)).symm]
        rw  [show  (3  :  ℝ)  +  (d0  -  1  /  2)  =  ((1  /  2  :  ℝ)  +  d0)  +  2  by  ring]
        rw  [Real.rpow_add  (by  norm_num  :  (0  :  ℝ)  <  2)  ((1  /  2  :  ℝ)  +  d0)  (2  :  ℝ)]
        have  hp4  :  (2  :  ℝ)  ^  (2  :  ℝ)  =  4  :=  by  norm_num
        rw  [hp4]
        ring
    have  hfinA  :  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  =
        ((1  /  2)  *  16  *  (2  :  ℝ)  ^  (-(1  /  2  -  d0)))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=  by  ring
    have  hfinB  :  ((1  /  2)  *  16  *  (2  :  ℝ)  ^  (-(1  /  2  -  d0)))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  =
        (4  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=  by  rw  [hT1e]
    have  hfinC  :  (4  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  =
        (4  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=  by  ring
    have  hfinD  :  (4  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  =
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      by
        rw  [T4OffLF.tinv2  t  htp]
        field_simp
    have  hfin  :  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  =
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      by  rw  [hfinA,  hfinB,  hfinC,  hfinD]
    have  hrec2  :  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0))⁻¹  <=
        ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0))⁻¹  :=
      by  simpa  using  hrec
    have  hstep2  :  (1  /  2  :  ℝ)  *  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0))⁻¹  >=
        (1  /  2)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0))⁻¹  :=
      mul_le_mul_of_nonneg_left  hrec2  (by  norm_num  :  0  <=  (1  /  2  :  ℝ))
    have  hT1  :  (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))  >=
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=
      by
        calc  (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))
          _  =  (1  /  2)  *  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (1  /  2  -  d0))⁻¹  :=  hs
          _  >=  (1  /  2)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  /  2  -  d0))⁻¹  :=
            hstep2
          _  =  (1  /  2)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  :=  ht1mid
          _  =  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  /  2  -  d0))  :=  hsplit
          _  =  (2  :  ℝ)  ^  (-(1  /  2  -  d0))  *  (1  /  2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  :=  hknife
          _  =  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  :=  hfin
    have  hT2  :  (‖t4l_sOffL  t  d0‖  /  12)  *
        (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(3  /  2  -  d0))  <=  T2b  t  d0  :=
      t2cap  t  d0  (T4OffLE.Noff  t  d0)  ht  hdlow  hdhigh  hNoffge
    have  hT3  :  (Real.sqrt  3  /  216)  *
          ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
          (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)  <=
        T3b  t  d0  :=
      t3cap  t  d0  (T4OffLE.Noff  t  d0)  ht  hdlow  hdhigh  hNoffge
    have  hwall  :  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  >=
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  -  T2b  t  d0  -  T3b  t  d0  :=
      by
        calc  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)
          _  =  (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))  -
                (‖t4l_sOffL  t  d0‖  /  12)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(3  /  2  -  d0))  -
                (Real.sqrt  3  /  216)  *
                  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
                  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2)))  /  ((1  /  2  -  d0)  +  2)  :=
            by  simp  only  [T4OffLE.wallLo]
          _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  -  T2b  t  d0  -  T3b  t  d0  :=
            by  nlinarith  [hT1,  hT2,  hT3]
    have  hgap  :=  t5strict  t  d0  ht  hdlow  hdhigh
    have  hown  :=  ownCap  t  d0  ht  hdlow  hdhigh
    calc  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)
      _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  /  2  :  ℝ)  +  d0)  -  T2b  t  d0  -  T3b  t  d0  :=
        hwall
      _  >  (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  (16  *  t  ^  2))  *
            Real.exp  (1  /  t  ^  2)  :=
        hgap
      _  >=  ‖poff  t  d0  t‖  :=
        hown


/-  =================================================================
   S6  THE  DISCHARGED  SQUEEZE  (the  0258  face,  narrowed  in  body)
   =================================================================
   On  the  band,  at  the  decoupled  fill  run  N  =  Noff,  the  pin
   premise  of  T4OffLE.t4LE_squeeze_decoupled  is  the  IN-BODY  fact
   of   S   S5.4   (no   measured   datum).   The   terminal   squeeze
   therefore  reduces  to  exactly  the  two  external  faces:  the
   CITED  A2c  bridge  and  the  NAMED  S3  face.  No  RH  claim:  a
   support-face  record  for  hOffCPT2.  -/

/-/   S   S6   THE   DISCHARGED   SQUEEZE   ON   THE   BAND:   with
    N  =  Noff,  the  terminal  squeeze  closes  from  the  cited  A2c
    bridge  +  the  named  S3  face  alone  (the  pin  premise  is  the
    in-body  T4OffLF.pin). -/
theorem squeeze_discharged (t d0 : ℝ)
    (ht : WinC.tPT2 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh : d0 < (1 / 2 : ℝ))
    (hbridge  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
          p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  =
          ‖p4_em_expr  (t4l_sOffL  t  d0)  (T4OffLE.Noff  t  d0)‖)
    (hs3face  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
          p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0)  :
    False  :=
  by
    have  htp  :  (1000  :  ℝ)  <=  t  :=
      by
        have  h  :  (1000  :  ℝ)  <=  WinC.tPT2  :=
          by
            dsimp  only  [WinC.tPT2]
            norm_num
        linarith  [ht]
    have  hN1  :  (1  :  ℝ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=
      le_trans  (T4OffLE.t4LE_nIdeal_ge  t  d0  htp  hdlow  hdhigh)
        (T4OffLE.t4LE_ceil_bounds  t  d0  htp  hdlow  hdhigh).1
    have  hNz  :  T4OffLE.Noff  t  d0  ≠  0  :=
      by
        intro  hN0
        rw  [hN0]  at  hN1
        have  hbad  :  (1  :  ℝ)  <=  (0  :  ℝ)  :=  by  simpa  using  hN1
        have  hcon  :  (0  :  ℝ)  <  1  :=  by  norm_num
        exact  lt_irrefl  (0  :  ℝ)  (lt_of_lt_of_le  hcon  hbad)
    have  hNp  :  0  <  T4OffLE.Noff  t  d0  :=
      Nat.pos_of_ne_zero  hNz
    exact  T4OffLE.t4LE_squeeze_decoupled  t  d0  (T4OffLE.Noff  t  d0)  ht
      hdlow  hdhigh  hNp  hbridge  hs3face
      (pin  t  d0  htp  hdlow  hdhigh)

end  T4OffLF

end
