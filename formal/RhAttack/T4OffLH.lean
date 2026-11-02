/- T4OffLH -- THE Q2 DECOUPLED FAMILY, EXHAUSTED FOR ALL d0 (the
   empty tension/face intersection) - OFF-BOARD NEGATIVE MARGIN
   RECORD (the T4OffLB/LC/LD/LE/LF/LG class).  No RH claim.

   THE MAP (target height t >= WinC.tPT2, 0 < d0 < 1/2):

   The decoupled squeeze (T4OffLE.t4LE_squeeze_decoupled) at the
   decoupled fill run Noff = ceil nIdeal can fire at a pair only if
   two in-body facts hold simultaneously:
     (T)  TENSION  - the EM fill floor sits ABOVE the S4 wire wall:
            wallLo t d0 (Noff t d0) > S4A.BwireR t d0 + S4A.MrR t d0
            (the contradiction leg of T4OffLG.s3legInfeas: floor > own
            > wire when it holds);
     (F)  the S3 FACE - the fill run is at or above the S4 window
          schedule (so the kernel bound t4l_wall_tuned applies at
          Noff):
            t4l_schedB t (1/2 - d0) <= (Noff t d0 : ...).

   Coverage of d0-space at target height:
     [1/200, 1/2)      (T) + not (F)  - IN BODY, 0260 (T4OffLG):
                       kernel(Noff) > BwireR + MrR everywhere;
     (0, d0near]       (F) + not (T)  - IN BODY, HERE (S1 + S2):
                       Noff >= schedB and wallLo(Noff) <= BwireR + MrR
                       (no tension - the wire wall covers the floor
                       with an enormous margin);
     (d0near, d0star)  (F) + not (T)  - MEASURED, day064 (table:
                       worst wallLo/(BwireR+MrR) = 0.971 at the
                       d0star edge; Noff/schedB in [1, 127]);
     [d0star, 1/200)   not (F)        - MEASURED, day064
                       (Noff/schedB < 1: 0.489 at 4e-3, 0.198 at
                       5e-3) - in any case (T) + the 0260 in-body
                       result already rule out the squeeze on all of
                       [1/200, 1/2).
   d0star = 31000000^(-1/4)/4 = 3.350423e-3 is the exact
   (t-independent) Noff/schedB crossover; d0near = 1e-3 is the
   norm_num-clean working threshold of THIS module (strictly inside
   the safe band; all margins at d0near are 7.9x or better).

   CONCLUSION: (T) and (F) are DISJOINT in d0 at target height - the
   squeeze tension lives at d0 > ~4.74e-3 (t-uniform: the 0260 band,
   in body on [1/200, 1/2) via T4OffLG) while the S3 face only holds
   at d0 <= d0star = 3.35e-3 (here in body on the safe half-subband
   (0, d0near], measured to the edge by day064).  The decoupled
   family has NO contradiction zone for ANY d0 at ANY target height:
   T4OffLH (in body) + T4OffLG (in body) + day064 (measured seams).
   The Q2 line (0257-0260) is EXHAUSTED as a closure route for
   hOffCPT2.

   SHARPENED RESIDUE (replacing 0260's residue note): any S3 leg
   able to discharge a tension-zone pair (d0 > ~4.74e-3, t >= tPT2)
   must bound the TRUE fill |zeta (sL) - (p4_P Noff sL - p4_I Noff
   sL)| - NOT the EM-kernel lower bound, which 0260/here show sits
   strictly ABOVE the wire wall on the whole tension zone.  That is
   either a zeta-data-class input (route (a): certified on-line
   records pushed above the frontier) or a genuinely new argument
   OUTSIDE the EM-squeeze class (route (b)).  hOffCPT2 stays open;
   the B24/B25 exact-rational board stays as the data conveyor.

   POWER-DISCIPLINE NOTE: every literal power on a real base in this
   file is typed explicitly ((4 : (NAT)), (2 : (NAT))) so that it
   matches the in-tree S4Strip.n4 nat-power term; genuinely real
   exponents (rpow) are used only for non-integer expressions.
   CALC-DISCIPLINE NOTE (Lean 4.33): calc steps carry ONLY term
   proofs or single-line 'by' proofs in this file. -/

import  Mathlib
import  RhAttack.S4Strip
import  RhAttack.S4Window
import  RhAttack.S4Growth
import  RhAttack.S4WinCap
import  RhAttack.S4Asm
import  RhAttack.P8Floor
import  RhAttack.WinCount
import  RhAttack.T4OffL
import  RhAttack.T4OffLE

open  Real

set_option  linter.style.longLine  false

namespace  T4OffLH

/-!  S  S0  THE  NEAR-LINE  THRESHHOLDS  (exact,  t-independent)  -/

/-- Exact  Noff/schedB  crossover  (up  to  the  +1  ceil  sliver,
    day064):  d0star  =  3.1e7^(-1/4)  /  4  =  3.350423e-3.
    DOCUMENTED  CONSTANT  -  not  needed  by  the  proofs  below
    (the  working  threshold  d0near  is  strictly  inside  the
    safe  band  and  norm_num-clean). -/
noncomputable  def  d0star  :  ℝ  :=  (31000000  :  ℝ)  ^  (-1  /  4  :  ℝ)  /  4

/-- Safe  working  threshold  of  this  module:  d0near  =  1e-3
    <  d0star  =  1.67521e-3  (7.9x  margin  on  the  schedule
    comparison  at  this  point  of  the  band). -/
noncomputable  def  d0near  :  ℝ  :=  1  /  1000

lemma  d0near_pos  :  0  <  d0near  :=  by
  dsimp  only  [d0near]
  norm_num

/-- d0near  <  1/200  (the  module  band  lies  strictly  inside
    the  near-line  window  branch  of  S4A.BwireR/MrR). -/
lemma  d0near_lt_d0low  :  d0near  <  (1  /  200  :  ℝ)  :=  by
  dsimp  only  [d0near]
  norm_num

/-!  S  S1  THE  SCHEDULE  COMPARISON  (in  body):  on  the  safe
    near  subband  the  decoupled  fill  run  is  AT  OR  ABOVE  the
    S4  window  schedule  -  the  S3  face  is  POSSIBLE  here.  -/

theorem  NoFf_above_sched  (t  d0  :  ℝ)
    (ht  :  1000  <=  t)  (hd0  :  0  <  d0)  (hdn  :  d0  <=  d0near)  :
    t4l_schedB  t  ((1  /  2)  -  d0)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
  set  σ  :=  (1  /  2  :  ℝ)  -  d0  with  hσdef
  have  hσinv  :  (1  /  2  -  d0)  =  σ  :=  hσdef.symm
  have  hhalf :  d0  <  (1  /  2  :  ℝ)  :=  by
    nlinarith  [d0near_lt_d0low,  hdn,  show  (0  :  ℝ)  <  1  /  2  from  by  norm_num]
  have  hσp  :  0  <  σ  :=  by  linarith  [hhalf]
  have  hs2p  :  0  <  2  *  σ  :=  by  linarith  [hσp]
  --  (a)  positivity  of  the  ideal  run  and  the  ceiling  bound:
  have  hNnσ :  0  <  (T4OffLE.nIdeal  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.nIdeal]
    apply  mul_pos
    ·  exact  rpow_pos_of_pos  (by  positivity)  _
    ·  exact  rpow_pos_of_pos  (by  linarith  [ht])  _
  have  hNceil  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.Noff]
    exact  Nat.le_ceil  (T4OffLE.nIdeal  t  d0)
  have  hNp :  0  <  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.Noff]
    exact  lt_of_lt_of_le  hNnσ  (Nat.le_ceil  (T4OffLE.nIdeal  t  d0))
  --  (b)  the  power  identity  nIdeal^(2 sigma)  =  t^4  /  (256  d0^4):
  have  hA :  0  <  (16  :  ℝ)  *  d0  *  d0  :=  by  positivity
  have  hB :  0  <  t  :=  by  linarith  [ht]
  have  hC :  0  <  (16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  :=
    rpow_pos_of_pos  hA  _
  have  hD :  0  <  t  ^  (2  /  (1  /  2  -  d0))  :=
    rpow_pos_of_pos  hB  _
  have  hexp1  :  (-(1  /  (1  /  2  -  d0)))  *  (2  *  σ)  =  (-2  :  ℝ)  :=  by
    rw  [hσinv]
    field_simp  [hσp.ne']
    <;>  ring
  have  hexp2  :  (2  /  (1  /  2  -  d0))  *  (2  *  σ)  =  (4  :  ℝ)  :=  by
    rw  [hσinv]
    field_simp  [hσp.ne']
    <;>  ring
  have  ht4  :  t  ^  (4  :  ℝ)  =  t  ^  (4  :  ℕ)  :=  rpow_natCast  t  4
  have  hinv  :  (16  *  d0  *  d0)  ^  (-2  :  ℝ)  =  1  /  (256  *  d0  ^  (4  :  ℕ))  :=  by
    rw  [rpow_neg  (le_of_lt  hA)  2]
    rw  [show  (2  :  ℝ)  =  (2  :  ℕ)  from  by  norm_num]
    rw  [rpow_natCast  (16  *  d0  *  d0)  2]
    field_simp  [hA.ne',  hd0.ne']
    ring
  have  hpow2  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (2  *  σ)  =
      t  ^  (4  :  ℕ)  /  (256  *  d0  ^  (4  :  ℕ))  :=  by
    calc  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (2  *  σ)
        =  ((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  *  t  ^  (2  /  (1  /  2  -  d0)))  ^  (2  *  σ)  :=
          rfl
      _  =  ((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  :  ℝ)  ^  (2  *  σ)  *
            (t  ^  (2  /  (1  /  2  -  d0)))  ^  (2  *  σ)  :=
          mul_rpow  (le_of_lt  hC)  (le_of_lt  hD)
      _  =  (16  *  d0  *  d0)  ^  ((-(1  /  (1  /  2  -  d0)))  *  (2  *  σ))  *
            t  ^  ((2  /  (1  /  2  -  d0))  *  (2  *  σ))  :=  by
        rw  [←  rpow_mul  (le_of_lt  hA)  (-(1  /  (1  /  2  -  d0)))  (2  *  σ),  ←  rpow_mul  (le_of_lt  hB)  (2  /  (1  /  2  -  d0))  (2  *  σ)]
      _  =  (16  *  d0  *  d0)  ^  (-2  :  ℝ)  *  t  ^  (4  :  ℝ)  :=  by  rw  [hexp1,  hexp2]
      _  =  (16  *  d0  *  d0)  ^  (-2  :  ℝ)  *  t  ^  (4  :  ℕ)  :=  by  rw  [ht4]
      _  =  t  ^  (4  :  ℕ)  /  (256  *  d0  ^  (4  :  ℕ))  :=  by  rw  [hinv];  ring
  --  (c)  base  monotonicity  up  to  the  fill  run:
  have  hmono  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (2  *  σ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (2  *  σ)  :=
    rpow_le_rpow  (le_of_lt  hNnσ)  hNceil  (by  linarith  [hs2p])
  --  (d)  the  d0^4  bound  at  the  safe  threshold:
  have  hd4  :  d0  ^  (4  :  ℕ)  <=  d0near  ^  (4  :  ℕ)  :=
    pow_le_pow_left₀  (by  linarith  [hd0])  hdn  4
  have  hden2  :  (256  :  ℝ)  *  d0near  ^  (4  :  ℕ)  <=  1  /  (16  *  31000000)  :=  by
    dsimp  only  [d0near]
    norm_num
  have  hstep1  :  (256  :  ℝ)  *  d0  ^  (4  :  ℕ)  <=  256  *  d0near  ^  (4  :  ℕ)  :=  by
    apply  mul_le_mul_of_nonneg_left  hd4
    norm_num
  have  hden  :  (256  :  ℝ)  *  d0  ^  (4  :  ℕ)  <=  1  /  (16  *  31000000)  :=  by
    calc  (256  :  ℝ)  *  d0  ^  (4  :  ℕ)  <=  256  *  d0near  ^  (4  :  ℕ)  :=  hstep1
      _  <=  1  /  (16  *  31000000)  :=  hden2
  --  (e)  t^4  /  (256  d0^4)  >=  16  *  3.1e7  *  t^4  >=  3.1e7  t^4  +  1:
  have  hprod  :  (16  *  31000000  :  ℝ)  *  (256  *  d0  ^  (4  :  ℕ))  <=  1  :=  by
    calc  (16  *  31000000  :  ℝ)  *  (256  *  d0  ^  (4  :  ℕ))
        =  (256  *  d0  ^  (4  :  ℕ))  *  (16  *  31000000)  :=  by  ring
      _  <=  (1  /  (16  *  31000000))  *  (16  *  31000000)  :=  by  apply  mul_le_mul_of_nonneg_right  hden;  norm_num
      _  =  1  :=  by  field_simp
  have  hmargin  :  (16  *  31000000)  *  t  ^  (4  :  ℕ)  <=
      t  ^  (4  :  ℕ)  /  (256  *  d0  ^  (4  :  ℕ))  :=  by
    have  hb  :  0  <  (256  :  ℝ)  *  d0  ^  (4  :  ℕ)  :=
      mul_pos  (by  norm_num)  (pow_pos  hd0  4)
    rw  [le_div_iff₀  hb]
    calc  ((16  *  31000000  :  ℝ)  *  t  ^  (4  :  ℕ))  *  (256  *  d0  ^  (4  :  ℕ))
        =  t  ^  (4  :  ℕ)  *  ((16  *  31000000  :  ℝ)  *  (256  *  d0  ^  (4  :  ℕ)))  :=  by  ring
      _  <=  t  ^  (4  :  ℕ)  *  1  :=  mul_le_mul_of_nonneg_left  hprod  (le_of_lt  (pow_pos  (by  linarith  [ht])  4))
      _  =  t  ^  (4  :  ℕ)  :=  by  ring
  have  hmargin2  :  (16  *  31000000  :  ℝ)  *  t  ^  (4  :  ℕ)  >=
      31000000  *  t  ^  (4  :  ℕ)  +  1  :=  by
    have  h15  :  1  <=  (15  *  31000000  :  ℝ)  *  t  ^  (4  :  ℕ)  :=  by
      have  h10 :  (1000 : ℝ) ^ (4 : ℕ) <=  t ^ (4 : ℕ) :=
        pow_le_pow_left₀  (by  norm_num)  ht  4
      have  hc :  1  <=  (15  *  31000000 :  ℝ)  *  (1000 :  ℝ)  ^  (4  :  ℕ)  :=  by  norm_num
      apply  le_trans  hc
      exact  mul_le_mul_of_nonneg_left  h10  (by  norm_num)
    nlinarith  [h15]
  --  (f)  the  window  run  and  the  final  comparison:
  have  hn4  :  (S4Strip.n4  t  :  ℝ)  <=  31000000  *  t  ^  (4  :  ℕ)  +  1  :=  by
    dsimp  only  [S4Strip.n4]
    exact  le_of_lt  (Nat.ceil_lt_add_one_of_gt_neg_one  (by
      nlinarith  [show  (0  :  ℝ)  <=  31000000  *  t  ^  (4  :  ℕ)  from  by  positivity]))
  have  hN4  :  (S4Strip.n4  t  :  ℝ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (2  *  σ)  :=  by
    calc  (S4Strip.n4  t  :  ℝ)  <=  31000000  *  t  ^  (4  :  ℕ)  +  1  :=  hn4
      _  <=  (16  *  31000000)  *  t  ^  (4  :  ℕ)  :=  hmargin2
      _  <=  t  ^  (4  :  ℕ)  /  (256  *  d0  ^  (4  :  ℕ))  :=  by  linarith  [hmargin]
      _  =  (T4OffLE.nIdeal  t  d0)  ^  (2  *  σ)  :=  by  rw  [hpow2]
      _  <=  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (2  *  σ)  :=  hmono
  have  hx  :  0  <=  (S4Strip.n4  t  :  ℝ)  :=  by
    dsimp  only  [S4Strip.n4]
    exact  Nat.cast_nonneg  _
  have  hexp  :  0  <=  (1  :  ℝ)  /  (2  *  σ)  :=  by
    apply  div_nonneg
    ·  norm_num
    ·  linarith  [hs2p]
  have  hx1  :  ((2  :  ℝ)  *  σ)  *  (1  /  (2  *  σ))  =  1  :=  by
    field_simp  [hσp.ne']
  have  hstep3  :  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (2  *  σ))  ^  (1  /  (2  *  σ))  =
      (T4OffLE.Noff  t  d0  :  ℝ)  ^  ((2  *  σ)  *  (1  /  (2  *  σ)))  :=
    (rpow_mul  (le_of_lt  hNp)  (2  *  σ)  (1  /  (2  *  σ))).symm
  have  hstep4  :  (T4OffLE.Noff  t  d0  :  ℝ)  ^  ((2  *  σ)  *  (1  /  (2  *  σ)))  =
      (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
    rw  [hx1,  rpow_one]
  calc  t4l_schedB  t  ((1  /  2)  -  d0)
      =  (S4Strip.n4  t  :  ℝ)  ^  (1  /  (2  *  σ))  :=  rfl
    _  <=  ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (2  *  σ))  ^  (1  /  (2  *  σ))  :=
      rpow_le_rpow  hx  hN4  hexp
    _  =  (T4OffLE.Noff  t  d0  :  ℝ)  ^  ((2  *  σ)  *  (1  /  (2  *  σ)))  :=  hstep3
    _  =  (T4OffLE.Noff  t  d0  :  ℝ)  :=  hstep4

/-!  S  S2  NO  TENSION  ON  THE  SAFE  NEAR  SUBBAND  (in  body):
    the  fill  floor  sits  BELOW  the  S4  wire  wall  -  the
    squeeze  has  no  contradiction  zone  here.  -/

theorem  noTension_target  (t  d0  :  ℝ)
    (ht  :  WinC.tPT2  <=  t)  (hd0  :  0  <  d0)  (hdn  :  d0  <=  d0near)  :
    T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  <=  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  by
  set  σ  :=  (1  /  2  :  ℝ)  -  d0  with  hσdef
  have  hσinv  :  (1  /  2  -  d0)  =  σ  :=  hσdef.symm
  dsimp  only  [WinC.tPT2]  at  ht
  have  ht0 :  (1000 : ℝ) <=  t  :=  by
    have hT : (1000 : ℝ) <= (3000175332800 : ℝ) := by norm_num
    linarith  only  [hT,  ht]
  have  htp  :  0  <  t  :=  by  linarith  only  [ht0]
  have  hhalf :  d0  <  (1  /  2  :  ℝ)  :=  by
    nlinarith  only  [d0near_lt_d0low,  hdn,  show  (0  :  ℝ)  <  1  /  2  from  by  norm_num]
  have  hσp  :  0  <  σ  :=  by  linarith  only  [hσdef,  hhalf]
  --  (a)  positivity  and  the  ceiling  bound:
  have  hNnσ :  0  <  (T4OffLE.nIdeal  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.nIdeal]
    apply  mul_pos
    ·  exact  rpow_pos_of_pos  (by  positivity)  _
    ·  exact  rpow_pos_of_pos  (by  linarith  only  [ht0])  _
  have  hNp  :  0  <  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.Noff]
    exact  lt_of_lt_of_le  hNnσ  (Nat.le_ceil  (T4OffLE.nIdeal  t  d0))
  have  hNceil  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=  by
    dsimp  only  [T4OffLE.Noff]
    exact  Nat.le_ceil  (T4OffLE.nIdeal  t  d0)
  --  (b)  wallLo  <=  the  leading  T1  term  (T2,  T3  subtracted):
  have  hT2  :  0  <=  (‖t4l_sOffL  t  d0‖  /  12)  *
      (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(3  /  2  -  d0))  :=
    mul_nonneg  (div_nonneg  (norm_nonneg  _)  (by  norm_num))
      (le_of_lt  (rpow_pos_of_pos  hNp  _))
  have  hT3  :  0  <=  (Real.sqrt  3  /  216)  *
      ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *
        (t4l_sOffL  t  d0  +  2)‖  *
      ((T4OffLE.Noff  t  d0  :  ℝ)  ^  (-((1  /  2  -  d0)  +  2)))  /
      ((1  /  2  -  d0)  +  2)  :=  by
    have  hden :  0  <=  ((1  /  2  :  ℝ)  -  d0)  +  2  :=  by  nlinarith  only  [hd0,  hhalf]
    have  hP  :  0  <=  (Real.sqrt  3  /  216)  *
        ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *
          (t4l_sOffL  t  d0  +  2)‖  :=
      mul_nonneg  (div_nonneg  (Real.sqrt_nonneg  3)  (by  norm_num))
        (norm_nonneg  _)
    have  hQ  :  0  <=  (T4OffLE.Noff  t  d0  :  ℝ)  ^
        (-((1  /  2  -  d0)  +  2))  :=
      le_of_lt  (rpow_pos_of_pos  hNp  _)
    apply  div_nonneg  ?_  hden
    exact  mul_nonneg  hP  hQ
  have  hwall  :  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  <=
      (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))  :=  by
    dsimp  only  [T4OffLE.wallLo]
    nlinarith  only  [hT2,  hT3]
  --  (c)  Noff^(-sigma)  <=  nIdeal^(-sigma)  =  16  d0^2  t^(-2):
  have  hNσ  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  σ  <=  (T4OffLE.Noff  t  d0  :  ℝ)  ^  σ  :=
    rpow_le_rpow  (le_of_lt  hNnσ)  hNceil  (by  linarith  only  [hσp])
  have  hL  :  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-σ)  =
      1  /  (T4OffLE.Noff  t  d0  :  ℝ)  ^  σ  :=  by
    rw  [rpow_neg  (le_of_lt  hNp)  σ]
    ring
  have  hR  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)  =
      1  /  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  σ  :=  by
    rw  [rpow_neg  (le_of_lt  hNnσ)  σ]
    ring
  have  hpos1  :  0  <  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  σ  :=
    rpow_pos_of_pos  hNnσ  _
  have  hpos2  :  0  <  (T4OffLE.Noff  t  d0  :  ℝ)  ^  σ  :=
    rpow_pos_of_pos  hNp  _
  have  hNoffnσ  :  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-σ)  <=
      (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)  :=  by
    calc  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-σ)
        =  1  /  (T4OffLE.Noff  t  d0  :  ℝ)  ^  σ  :=  hL
      _  <=  1  /  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  σ  :=
        (one_div_le_one_div  hpos2  hpos1).2  hNσ
      _  =  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)  :=  hR.symm
  have  hA :  0  <  (16  :  ℝ)  *  d0  *  d0  :=  by  positivity
  have  hC :  0  <  (16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  :=
    rpow_pos_of_pos  hA  _
  have  hD :  0  <  t  ^  (2  /  (1  /  2  -  d0))  :=  rpow_pos_of_pos  htp  _
  have  hneg1  :  (-(1  /  (1  /  2  -  d0)))  *  (-σ)  =  (1  :  ℝ)  :=  by
    rw  [hσinv]
    field_simp  [hσp.ne']
    <;>  ring
  have  hneg2  :  (2  /  (1  /  2  -  d0))  *  (-σ)  =  (-2  :  ℝ)  :=  by
    rw  [hσinv]
    field_simp  [hσp.ne']
    <;>  ring
  have  hnσ  :  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)  =  16  *  d0  *  d0  *  t  ^  (-2  :  ℝ)  :=  by
    calc  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)
        =  ((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0)))  *  t  ^  (2  /  (1  /  2  -  d0)))  ^  (-σ)  :=
          rfl
      _  =  ((16  *  d0  *  d0)  ^  (-(1  /  (1  /  2  -  d0))))  ^  (-σ)  *
            (t  ^  (2  /  (1  /  2  -  d0)))  ^  (-σ)  :=
          mul_rpow  (le_of_lt  hC)  (le_of_lt  hD)
      _  =  (16  *  d0  *  d0)  ^  ((-(1  /  (1  /  2  -  d0)))  *  (-σ))  *
            t  ^  ((2  /  (1  /  2  -  d0))  *  (-σ))  :=  by
        rw  [←  rpow_mul  (le_of_lt  hA)  (-(1  /  (1  /  2  -  d0)))  (-σ),  ←  rpow_mul  (le_of_lt  htp)  (2  /  (1  /  2  -  d0))  (-σ)]
      _  =  (16  *  d0  *  d0)  ^  (1  :  ℝ)  *  t  ^  (-2  :  ℝ)  :=  by  rw  [hneg1,  hneg2]
      _  =  16  *  d0  *  d0  *  t  ^  (-2  :  ℝ)  :=  by  rw  [rpow_one  (16  *  d0  *  d0)]
  --  (d)  the  t-uniform  margin  to  (1/2)  t^(-1):
  have  h16n  :  (16  :  ℝ)  *  d0near  *  d0near  <=  t  :=  by
    have  hc  :  (16  :  ℝ)  *  d0near  *  d0near  <=  (1  :  ℝ)  :=  by
      dsimp  only  [d0near]
      norm_num
    nlinarith  only  [hc,  ht0]
  have  hte  :  t  ^  (-2  :  ℝ)  =  t  ^  (-1  :  ℝ)  *  t  ^  (-1  :  ℝ)  :=  by
    rw  [show  (-2  :  ℝ)  =  (-1  :  ℝ)  +  (-1  :  ℝ)  from  by  ring,
      rpow_add  htp  (-1)  (-1)]
  have  hdiv  :  (8  *  d0near  *  d0near)  *  t  ^  (-1  :  ℝ)  =
      (8  *  d0near  *  d0near)  /  t  :=  by
    rw  [rpow_neg  (le_of_lt  htp)  1,  rpow_one]
    ring
  have  hd  :  (8  *  d0near  *  d0near)  *  t  ^  (-1  :  ℝ)  <=  1  /  2  :=  by
    rw  [hdiv,  div_le_iff₀  htp]
    nlinarith  only  [h16n]
  have  h8near  :  (8  :  ℝ)  *  d0near  *  d0near  *  t  ^  (-2  :  ℝ)  <=
      (1  /  2  :  ℝ)  *  t  ^  (-1  :  ℝ)  :=  by
    calc  (8  :  ℝ)  *  d0near  *  d0near  *  t  ^  (-2  :  ℝ)
        =  ((8  *  d0near  *  d0near)  *  t  ^  (-1  :  ℝ))  *  t  ^  (-1  :  ℝ)  :=  by  rw  [hte];  ring
      _  <=  (1  /  2  :  ℝ)  *  t  ^  (-1  :  ℝ)  :=
        mul_le_mul_of_nonneg_right  hd  (le_of_lt  (rpow_pos_of_pos  htp  _))
  --  (e)  the  wire  wall  at  the  growth  run:
  have  hTg  :  S4W.T0  <=  t  :=  by
    dsimp  only  [S4W.T0]
    have  hT0l :  (110000 : ℝ) <= (3000175332800 : ℝ) := by norm_num
    linarith  only  [hT0l,  ht]
  have  hnG  :  0  <  (S4G.nGrow  t : ℝ) := by
    have hTg2 : S4G.T0 <=  t := by
      dsimp  only  [S4G.T0]
      exact  hTg
    exact  S4G.hFloorPos  t  hTg2
  have  hfl  :  (S4G.nGrow  t  :  ℝ)  <=  t  *  t  :=  by
    dsimp  only  [S4G.nGrow]
    exact  Nat.floor_le  (by  positivity  :  0  <=  t  *  t)
  have  hL1  :  (1  /  2  :  ℝ)  *  t  ^  (-1  :  ℝ)  =  1  /  (2  *  t)  :=  by
    rw  [show  t  ^  (-1  :  ℝ)  =  t ⁻¹  from  by
      rw  [rpow_neg  (le_of_lt  htp)  1,  rpow_one]]
    field_simp
  have  hR1  :  (1  /  2  :  ℝ)  *  ((S4G.nGrow  t  :  ℝ)  ^  (-1  /  2  :  ℝ))  =
      1  /  (2  *  Real.sqrt  (S4G.nGrow  t))  :=  by
    rw  [S4W.hpow1  hnG]
    field_simp
  have  hsq  :  Real.sqrt  (S4G.nGrow  t)  <=  t  :=  by
    have  hts  :  Real.sqrt  (t  *  t)  =  t  :=
      Real.sqrt_mul_self  (le_of_lt  htp)
    calc  Real.sqrt  (S4G.nGrow  t)  <=  Real.sqrt  (t  *  t)  :=  Real.sqrt_le_sqrt  hfl
      _  =  t  :=  hts
  have  hhalf1  :  (1  /  2  :  ℝ)  *  t  ^  (-1  :  ℝ)  <=
      (1  /  2  :  ℝ)  *  ((S4G.nGrow  t  :  ℝ)  ^  (-1  /  2  :  ℝ))  :=  by
    rw  [hL1,  hR1]
    rw  [one_div_le_one_div  (by  linarith  only  [htp])
      (by  linarith  only  [Real.sqrt_pos.mpr  hnG])]
    nlinarith  only  [hsq]
  have  hT  :  ¬  (t  <=  S4W.T0)  :=  by
    by_contra  h
    dsimp  only  [S4W.T0]  at  h
    have  hT0l :  (110000 : ℝ) <  (3000175332800 : ℝ)  :=  by  norm_num
    linarith  only  [h,  hT0l,  ht]
  have  hfar  :  ¬  ((1  /  200  :  ℝ)  <=  d0)  :=  by
    intro  h
    nlinarith  only  [h,  hdn,  d0near_lt_d0low]
  have  hdl1  :  d0  <=  (1  /  2  :  ℝ)  :=  le_of_lt  hhalf
  have  hh  :  1000  <=  t  ∧  d0  <=  1  /  2  :=
    ⟨ht0,  hdl1⟩
  have  hBwire  :  S4A.BwireR  t  d0  =  p8_B  t  (S4G.nGrow  t)  :=  by
    dsimp  only  [S4A.BwireR,  S4G.nGrow]
    rw  [if_pos  ⟨ht0,  hdl1⟩,  if_neg  hfar,  if_neg  hT]
  have  hMrR  :  0  <  S4A.MrR  t  d0  :=  by
    dsimp  only  [S4A.MrR]
    rw  [if_pos  ⟨ht0,  hdl1⟩,  if_neg  hfar,  if_neg  hT]
    have  htp  :  0  <  t  :=  by  linarith  only  [ht]
    have  hlog  :  1  <  t  :=  by  linarith  only  [ht]
    have  hT0l  :  (110000  :  ℝ)  <  (3000175332800 : ℝ)  :=  by  norm_num
    have  hlogt  :  0  <  Real.log  t  :=
      Real.log_pos  (by  nlinarith  only  [ht,  hT0l])
    have  hZ  :  0  <  S4W.Zbound  t  :=  by
      dsimp  only  [S4W.Zbound]
      apply  mul_pos  (mul_pos  (by  norm_num)  (rpow_pos_of_pos  htp  _))
      exact  hlogt
    have  hexp  :  0  <  Real.exp  (S4G.Xgrow  t)  :=  Real.exp_pos  _
    have  hXg  :  0  <  S4G.Xgrow  t  :=  S4WC.hXgrowPos  t  hT
    apply  mul_pos  (mul_pos  hZ  hexp)
    exact  hXg
  have  hp1  :  0  <=  (‖((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I‖  /  12)  *
      ((S4G.nGrow  t  :  ℝ)  ^  (-3  /  2  :  ℝ))  :=  by
    apply  mul_nonneg
    ·  apply  div_nonneg  (norm_nonneg  _)  (by  norm_num)
    ·  exact  le_of_lt  (rpow_pos_of_pos  hnG  _)
  have  hp2  :  0  <=  (Real.sqrt  3  /  540)  *
      ‖(((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I)  *
        (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  1)  *
        (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  2)‖  *
      ((S4G.nGrow  t  :  ℝ)  ^  (-5  /  2  :  ℝ))  :=  by
    have  h1 :  0  <=  (Real.sqrt  3  /  540)  *
        ‖(((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I)  *
          (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  1)  *
          (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  2)‖  :=  by
      apply  mul_nonneg
      ·  apply  div_nonneg  (Real.sqrt_nonneg  3)  (by  norm_num)
      ·  exact  norm_nonneg  _
    exact  mul_nonneg  h1  (le_of_lt  (rpow_pos_of_pos  hnG  _))
  calc  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)
      <=  (1  /  2  :  ℝ)  *  (T4OffLE.Noff  t  d0  :  ℝ)  ^  (-(1  /  2  -  d0))  :=  hwall
    _  <=  (1  /  2  :  ℝ)  *  (T4OffLE.nIdeal  t  d0  :  ℝ)  ^  (-σ)  :=
      mul_le_mul_of_nonneg_left  hNoffnσ  (by  norm_num  :  0  <=  (1  /  2  :  ℝ))
    _  =  (1  /  2  :  ℝ)  *  (16  *  d0  *  d0  *  t  ^  (-2  :  ℝ))  :=  by  rw  [hnσ]
    _  =  (8  :  ℝ)  *  d0  *  d0  *  t  ^  (-2  :  ℝ)  :=  by  ring
    _  <=  (8  :  ℝ)  *  d0near  *  d0near  *  t  ^  (-2  :  ℝ)  :=  by
      have  hd2'  :  d0  *  d0  <=  d0near  *  d0near  :=
        mul_le_mul  hdn  hdn  (le_of_lt  hd0)
          (le_of_lt  (by  linarith  only  [hdn,  d0near_pos]  :  0  <  d0near))
      have  htinv  :  0  <  t  ^  (-2  :  ℝ)  :=  rpow_pos_of_pos  htp  _
      have  hc  :  0  <  (8  :  ℝ)  *  t  ^  (-2  :  ℝ)  :=
        mul_pos  (by  norm_num)  htinv
      rw  [show  (8  :  ℝ)  *  d0  *  d0  *  t  ^  (-2  :  ℝ)  =
            (8  :  ℝ)  *  t  ^  (-2  :  ℝ)  *  (d0  *  d0)  from  by  ring,
           show  (8  :  ℝ)  *  d0near  *  d0near  *  t  ^  (-2  :  ℝ)  =
            (8  :  ℝ)  *  t  ^  (-2  :  ℝ)  *  (d0near  *  d0near)  from  by  ring]
      exact  mul_le_mul_of_nonneg_left  hd2'  (le_of_lt  hc)
    _  <=  (1  /  2  :  ℝ)  *  t  ^  (-1  :  ℝ)  :=  h8near
    _  <=  (1  /  2  :  ℝ)  *  ((S4G.nGrow  t  :  ℝ)  ^  (-1  /  2  :  ℝ))  :=  hhalf1
    _  <=  p8_B  t  (S4G.nGrow  t)  :=  by
      dsimp  only  [p8_B]
      nlinarith  only  [hp1,  hp2]
    _  =  S4A.BwireR  t  d0  :=  hBwire.symm
    _  <=  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      le_add_of_nonneg_right  (le_of_lt  hMrR)

/-!  S  S3  THE  EXHAUSTION  COROLLARY:  AT  TARGET  HEIGHT  the
    squeeze  tension  IMPLIES  d0  >  d0near  -  the  tension  zone
    and  the  S3-face  zone  of  this  module  are  disjoint,  and
    (with  0260's  in-body  face  infeasibility  on  [1/200,  1/2)
    and  the  day064  measured  seams)  the  decoupled  family  has
    NO  contradiction  zone  for  any  d0.  -/

theorem  tensionImpliesAbove  (t  d0  :  ℝ)
    (ht  :  WinC.tPT2  <=  t)  (hd0  :  0  <  d0)  (hdhalf  :  d0  <  (1  /  2  :  ℝ))  :
    T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  ->
    d0near  <  d0  :=  by
  dsimp  only  [WinC.tPT2]  at  ht
  intro  hten
  by_contra  hnot
  have  hd  :  d0  <=  d0near  :=  le_of_not_gt  hnot
  have  hle  :=  noTension_target  t  d0  ht  hd0  hd
  nlinarith  only  [hle,  hten]

end  T4OffLH
