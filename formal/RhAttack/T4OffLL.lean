/-  T4OffLL  --  THE  WIRE-CROSSING  EXTENSION  (the  0266/0267
   named  next  fire):  the  S3  face  is  infeasible  at  EVERY  run
   N  in  [nIdeal,  Nstar),  where  Nstar  is  the  CLOSED  WEAK  WIRE
   CROSSING  -  the  first  run  where  the  T1-only  wall  (T2  /  T3
   tail  corrections  frozen  at  their  2  nIdeal  values)  touches
   the  wire.  Combines  T4OffLK's  range  face  death  on  [nIdeal,
   2  nIdeal]  with  the  new  pointwise  weak  pin  wallLo  (N)  >
   wire  for  2  nIdeal  <=  N  <  Nstar  (no  pin  premise,  no
   bridge  premise  -  everything  in  body).  OFF-BOARD  NEGATIVE
   MARGIN  RECORD  (the  T4OffLB...LK  class).  No  RH  claim.

   Geometry  (day065  map):  Nstar  sits  just  below  the  true
   day065  wire  crossing  N1  (it  freezes  t2/t3  at  their  values
   at  2  nIdeal,  which  are  >=  their  values  at  any  N  >=  2
   nIdeal),  and  day065  shows  N1  >=  N2  at  every  band  point
   (the  S4  gap)  -  the  face  infeasibility  interval  [nIdeal,
   Nstar)  reaches  the  S1-dead  crossing  N2  at  every  grid
   point.  Beyond  Nstar  the  S3  face  becomes  premise-possible
   (the  high-mass  regime  -  outside  the  squeeze  class  by
   0262/0266/0267).  -/

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
import  RhAttack.T4OffLF
import  RhAttack.T4OffLJ
import  RhAttack.T4OffLK

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false

open  Real

namespace  T4OffLL

variable  (t  d0  :  ℝ)

/-  The  frozen  T2  /  T3  tail  constants:  the  T2  /  T3  terms  of
   the  wall  evaluated  at  the  point  2  nIdeal  (the  worst  case
   on  [2  nIdeal,  infinity)  -  they  are  decreasing  there).  -/

noncomputable  def  C2  (t  d0  :  ℝ)  :  ℝ  :=
    ‖t4l_sOffL  t  d0‖  /  12  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(3  /  2  -  d0))

noncomputable  def  C3  (t  d0  :  ℝ)  :  ℝ  :=
    (Real.sqrt  3  /  216)  *
      ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
      (2  *  T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  /  ((1  /  2  -  d0)  +  2)

/-  The  CLOSED  WEAK  WIRE  CROSSING:  the  first  run  of  the
   T1-only  wall  (T2  /  T3  frozen  at  2  nIdeal)  at  which  the
   wall  touches  the  wire:  (1/2)  N  ^  (-sigma)  -  C2  -  C3
   =  wire  <=>  N  =  (2  (wire  +  C2  +  C3))  ^  (-1  /  sigma).
   On  [2  nIdeal,  Nstar)  the  true  wall  is  strictly  above  the
   T1-only  wall,  hence  strictly  above  the  wire  (S1).  -/

noncomputable  def  Nstar  (t  d0  :  ℝ)  :  ℝ  :=
    (2  *  (S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0))  ^  (-(1  /  (1  /  2  -  d0)))

/-  =================================================================
   S0  THE  WIRE  IS  STRICTLY  POSITIVE  ON  THE  BAND
   =================================================================
   BwireR  >=  0  (each  term  of  p8_B  is  nonnegative  -  the
   n  ^  (-1/2)  term  via  rpow_nonneg,  no  positivity  of  the  run
   needed)  +  MrR  >  0  (Zbound  >  0,  exp  >  0,  X4fun  >  0  -
   the  B3Core  kernel  functions  Bf  /  Sbar  /  Cf  /  Kbar  are
   all  strictly  positive  at  the  25af  G4  /  B4  scales  >=  2
   ^  64,  log  2  >  0.6931471803).  -/

/-- S  S0  THE  WIRE  IS  POSITIVE  ON  THE  BAND:  on  the  band,
    0  <  BwireR  +  MrR.  No  RH  claim. -/
theorem  wirePos  (ht  :  1000  <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :  0  <  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  hdh  :  d0  <=  (1  / 2  :  ℝ)  :=  le_of_lt  hdhigh
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hG4  :  S4Strip.G4  t  >  t  :=
      by
        dsimp  only  [S4Strip.G4]
        have  h1 :  1  <=  t  :=  by  linarith  [ht]
        have  ht4 :  t  <=  t  ^  4  :=
          by
            have  ht0  :  0  <= t  :=  by  linarith  [h1]
            have  h2a  :  1  <= t  *  t  :=  by  nlinarith  [h1,  ht0]
            have  ht2  :  0  <= t  *  t  :=  by  nlinarith  [ht0]
            have  h2b  :  1  <= t  *  t  *  t  :=  by  nlinarith  [h2a,  ht2,  h1]
            have  ht3  :  0  <= t  *  t  *  t  :=  by  nlinarith  [ht2]
            calc  t  ^  4  =  t  *  (t  *  t  *  t)  :=  by  ring
              _  >=  t  *  1  :=  by  gcongr  <;>  nlinarith  [h2b,  ht3]
              _  =  t  :=  by  ring
        nlinarith  [ht4]
    have  hB4 :  S4Strip.B4  t  =  2  *  S4Strip.G4  t  :=  by
      dsimp  only  [S4Strip.B4,  S4Strip.G4]
      ring
    have  h64 :  (2  :  ℝ)  ^  64  <=  S4Strip.G4  t  :=
      by
        dsimp  only  [S4Strip.G4]
        have  ht4 :  (1000  :  ℝ)  ^  4  <=  t  ^  4  :=  by
          gcongr
          <;>  (norm_num  <;>  nlinarith  [ht])
        nlinarith  [ht4,  show  (2  :  ℝ)  ^  64  <=  (62000000  :  ℝ)  *  (1000  :  ℝ)  ^  4  by  norm_num]
    have  h65 :  (2  :  ℝ)  ^  65  <=  S4Strip.B4  t  :=
      by  nlinarith  [hB4,  h64]
    have  hlogd  :  (0.6931471803  :  ℝ)  <=  Real.log  2  :=
      le_of_lt  Real.log_two_gt_d9
    --  the  Sbar  values  at  the  B4  /  G4  scales:  log  >=  44,
    --  log-log  >=  log  44  >  0  -  every  term  positive.
    have  hlogG4 :  1  <=  Real.log  (S4Strip.G4  t)  :=
      by
        calc  Real.log  (S4Strip.G4  t)  >=  Real.log  ((2  :  ℝ)  ^  64)  :=
            Real.log_le_log  (by  linarith  [h64])  h64
          _  =  64  *  Real.log  2  :=  by  rw  [Real.log_pow];  norm_num
          _  >=  64  *  (0.6931471803  :  ℝ)  :=
            by  nlinarith  [hlogd]
          _  >=  1  :=  by  norm_num
    have  hllG4 :  0  <=  Real.log  (Real.log  (S4Strip.G4  t))  :=
      Real.log_nonneg  (by  linarith  [hlogG4])
    have  hlogB4 :  1  <=  Real.log  (S4Strip.B4  t)  :=
      by
        calc  Real.log  (S4Strip.B4  t)  >=  Real.log  ((2  :  ℝ)  ^  65)  :=
            Real.log_le_log  (by  linarith  [h65])  h65
          _  =  65  *  Real.log  2  :=  by  rw  [Real.log_pow];  norm_num
          _  >=  65  *  (0.6931471803  :  ℝ)  :=
            by  nlinarith  [hlogd]
          _  >=  1  :=  by  norm_num
    have  hllB4 :  0  <=  Real.log  (Real.log  (S4Strip.B4  t))  :=
      Real.log_nonneg  (by  linarith  [hlogB4])
    have  hSbarG :  0  <  Sbar  (S4Strip.G4  t)  :=
      by
        dsimp  only  [Sbar]
        have  hp1  :  0  <  0.110  *  Real.log  (S4Strip.G4  t)  :=
          mul_pos  (by  norm_num)  (by  linarith  [hlogG4])
        have  hn2  :  0  <=  0.290  *  Real.log  (Real.log  (S4Strip.G4  t))  :=
          mul_nonneg  (by  norm_num)  hllG4
        nlinarith  [hp1,  hn2]
    have  hSbarB :  0  <  Sbar  (S4Strip.B4  t)  :=
      by
        dsimp  only  [Sbar]
        have  hp1  :  0  <  0.110  *  Real.log  (S4Strip.B4  t)  :=
          mul_pos  (by  norm_num)  (by  linarith  [hlogB4])
        have  hn2  :  0  <=  0.290  *  Real.log  (Real.log  (S4Strip.B4  t))  :=
          mul_nonneg  (by  norm_num)  hllB4
        nlinarith  [hp1,  hn2]
    have  hBf :  0  <  Bf  t  (S4Strip.G4  t)  :=
      by
        dsimp  only  [Bf,  u,  w]
        have  hu  :  0  < (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4)  :=  by  positivity
        have  htu  :  t  *  t  < S4Strip.G4  t  *  S4Strip.G4  t  :=
          by
            have  hGp  :  0  < S4Strip.G4  t  :=  by  linarith  [hG4,  htp]
            have  htpG  :  0  < t  *  S4Strip.G4  t  :=  mul_pos  htp  hGp
            nlinarith  [hG4,  htpG]
        have  hwu'  :  t  *  t  +  1  /  4  < S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4  :=
          by  linarith  [htu]
        have  hwu  :  0  <  1  -  (t  *  t  +  1  /  4)  /  (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4)  :=
          by  exact  sub_pos.mpr  ((div_lt_one  hu).mpr  hwu')
        have  hw  :  0  < (t  *  t  +  1  /  4)  :=  by  nlinarith  [htp]
        have  h1  :  0  < 1  /  (2  *  (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4))  :=
          div_pos  (by  norm_num)  (by  linarith  [hu])
        have  h2  :  0  < ((t  *  t  +  1  /  4)  /  (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4))  /
            (1  -  (t  *  t  +  1  /  4)  /  (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4))  :=
          div_pos  (div_pos  hw  hu)  hwu
        have  h3  :  0  < t  /  (S4Strip.G4  t  *  S4Strip.G4  t  +  1  /  4)  :=
          div_pos  htp  hu
        linarith  [h1,  h2,  h3]
    have  hCf :  0  <  Cf  t  (S4Strip.G4  t)  :=
      by
        dsimp  only  [Cf,  w]
        have  htu  :  t  *  t  < S4Strip.G4  t  *  S4Strip.G4  t  :=
          by
            have  hGp  :  0  < S4Strip.G4  t  :=  by  linarith  [hG4,  htp]
            have  htpG  :  0  < t  *  S4Strip.G4  t  :=  mul_pos  htp  hGp
            nlinarith  [hG4,  htpG]
        have  hd  :  0  < (S4Strip.G4  t  *  S4Strip.G4  t  -  t  *  t)  :=
          by  exact  sub_pos.mpr  htu
        have  hterm  :  0  < 2  *  (t  *  t  +  1  /  4)  *  (S4Strip.G4  t  *  S4Strip.G4  t)  /
            (S4Strip.G4  t  *  S4Strip.G4  t  -  t  *  t)  :=
          div_pos  (by  nlinarith  [htp])  hd
        linarith  [hterm]
    have  hK :  0  <  Kbar  (S4Strip.G4  t)  :=
      by
        dsimp  only  [Kbar]
        have  hA  :  0  <  Real.log  (S4Strip.G4  t)  +  1  /  2  :=  by  linarith  [hlogG4]
        have  hB  :  0  <  Real.log  (Real.log  (S4Strip.G4  t))  +  1  /  2  :=
          by  linarith  [hllG4]
        have  hpA  :  0  <  0.110  *  (Real.log  (S4Strip.G4  t)  +  1  /  2)  :=
          mul_pos  (by  norm_num)  hA
        have  hpB  :  0  <  0.290  *  (Real.log  (Real.log  (S4Strip.G4  t))  +  1  /  2)  :=
          mul_pos  (by  norm_num)  hB
        have  hnum  :  0  < 0.110  *  (Real.log  (S4Strip.G4  t)  +  1  /  2)  +
            0.290  *  (Real.log  (Real.log  (S4Strip.G4  t))  +  1  /  2)  +  2.290  :=
          by  nlinarith  [hpA,  hpB]
        have  hden  :  0  < 2  *  S4Strip.G4  t  *  S4Strip.G4  t  :=
          by
          have  hGp  :  0  < S4Strip.G4  t  :=  by  linarith  [hG4,  htp]
          nlinarith  [hGp]
        exact  div_pos  hnum  hden
    have  hX4 :  0  <  S4Strip.X4fun  t  :=
      by
        dsimp  only  [S4Strip.X4fun]
        have  hsum  :  0  <  Sbar  (S4Strip.B4  t)  +  Sbar  (S4Strip.G4  t)  :=
          add_pos  hSbarB  hSbarG
        have  h1  :  0  <  Bf  t  (S4Strip.G4  t)  *  (Sbar  (S4Strip.B4  t)  +  Sbar  (S4Strip.G4  t))  :=
          mul_pos  hBf  hsum
        have  h2  :  0  <  Cf  t  (S4Strip.G4  t)  *  Kbar  (S4Strip.G4  t)  :=
          mul_pos  hCf  hK
        linarith  [h1,  h2]
    have  hZ :  0  <  S4W.Zbound  t  :=
      by
        dsimp  only  [S4W.Zbound]
        have  hlog  :  0  < Real.log  t  :=  Real.log_pos  (by  nlinarith  [ht])
        have  hrp  :  0  < t  ^  (1  /  4  :  ℝ)  :=  rpow_pos_of_pos  htp  (1  /  4)
        have  hc  :  0  < (1.6  :  ℝ)  :=  by  norm_num
        have  h1  :  0  < (1.6  :  ℝ)  *  t  ^  (1  /  4  :  ℝ)  :=  mul_pos  hc  hrp
        exact  mul_pos  h1  hlog
    have  hBw :  0  <=  S4A.BwireR  t  d0  :=
      by
        dsimp  only  [S4A.BwireR,  p8_B]
        rw  [if_pos  (And.intro  ht  hdh)]
        rw  [if_pos  hdlow]
        have  hn  :  0  <= (S4Strip.n4  t  :  ℝ)  :=  Nat.cast_nonneg  (S4Strip.n4  t)
        have  hT1  :  0  <= (1  /  2)  *  (S4Strip.n4  t  :  ℝ)  ^  (-1  /  2  :  ℝ)  :=
          mul_nonneg  (by  norm_num)  (rpow_nonneg  hn  (-1  /  2))
        have  hT2  :  0  <=
            (‖((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I‖  /  12)  *
            (S4Strip.n4  t  :  ℝ)  ^  (-3  /  2  :  ℝ)  :=
          mul_nonneg  (div_nonneg  (norm_nonneg  _)  (by  norm_num))
            (rpow_nonneg  hn  (-3  /  2))
        have  hT3  :  0  <=
            (Real.sqrt  3  /  540)  *
              ‖(((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I)  *
                 (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  1)  *
                 (((1  /  2  :  ℝ)  :  ℂ)  +  (t  :  ℂ)  *  Complex.I  +  2)‖  *
              (S4Strip.n4  t  :  ℝ)  ^  (-5  /  2  :  ℝ)  :=
          by
            apply  mul_nonneg
            · apply  mul_nonneg
              · exact  le_of_lt  (div_pos  (Real.sqrt_pos_of_pos  (by  norm_num  :  (0  :  ℝ)  < 3))
                  (by  norm_num  :  (0  :  ℝ)  < 540))
              · exact  norm_nonneg  _
            · exact  rpow_nonneg  hn  (-5  /  2)
        positivity
    have  hM :  0  <  S4A.MrR  t  d0  :=
      by
        dsimp  only  [S4A.MrR]
        rw  [if_pos  (And.intro  ht  hdh)]
        rw  [if_pos  hdlow]
        have  hE  :  0  < Real.exp  (S4Strip.X4fun  t)  :=  Real.exp_pos  (S4Strip.X4fun  t)
        have  h1  :  0  < S4W.Zbound  t  *  Real.exp  (S4Strip.X4fun  t)  :=
          mul_pos  hZ  hE
        exact  mul_pos  h1  hX4
    nlinarith  [hBw,  hM]

/-  =================================================================
   S1  THE  POINTWISE  WEAK  PIN  ON  [2  nIdeal,  Nstar)
   =================================================================
   wallLo  (N)  =  (1/2)  N  ^  (-sigma)  -  t2  (N)  -  t3  (N)
   >=  (1/2)  N  ^  (-sigma)  -  C2  -  C3     (t2  /  t3  frozen
   at  2  nIdeal  is  an  upper  bound  on  [2  nIdeal,  infinity))
   >  (1/2)  Nstar  ^  (-sigma)  -  C2  -  C3  (N  <  Nstar,
   strict  T1)
   =  wire                                    (Nstar  ^  (-sigma)
   =  2  (wire  +  C2  +  C3)  by  construction)  .
   -/

theorem  Nstar_pos  (ht  :  1000  <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :  0  <  Nstar  t  d0  :=
  by
    have  hdh  :  d0  <=  (1  /  2  :  ℝ)  :=  le_of_lt  hdhigh
    have  hC2n  :  0  <=  C2  t  d0  :=
      by
        dsimp  only  [C2]
        have  hn  :  0  <= 2  *  T4OffLE.nIdeal  t  d0  :=
          by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
        exact  mul_nonneg  (div_nonneg  (norm_nonneg  _)  (by  norm_num))
          (rpow_nonneg  hn  (-(3  /  2  -  d0)))
    have  hC3n  :  0  <=  C3  t  d0  :=
      by
        dsimp  only  [C3]
        have  hn  :  0  <= 2  *  T4OffLE.nIdeal  t  d0  :=
          by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
        have  hK  :  0  <= (Real.sqrt  3  /  216)  *
            ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  :=
          mul_nonneg  (by  nlinarith  [Real.sqrt_nonneg  3])  (norm_nonneg  _)
        have  hrp  :  0  <= (2  *  T4OffLE.nIdeal  t  d0)  ^  (-((1  /  2  -  d0)  +  2))  :=
          rpow_nonneg  hn  (-((1  / 2  -  d0)  +  2))
        exact  div_nonneg  (mul_nonneg  hK  hrp)
          (by  nlinarith  [hdh])
    have  hbasep  :  0  < 2  *  (S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0)  :=
      by  nlinarith  [wirePos  t  d0  ht  hdlow  hdhigh,  hC2n,  hC3n]
    dsimp  only  [Nstar]
    exact  rpow_pos_of_pos  hbasep  (-(1  /  (1  / 2  -  d0)))

/-- S  S1  THE  POINTWISE  WEAK  PIN  ON  [2  nIdeal,  Nstar):  on
    the  band,  at  every  run  N  with  2  nIdeal  <=  N  <  Nstar,
    the  wall  is  strictly  above  the  wire:  wallLo  (t,  d0,  N)
    >  BwireR  +  MrR.  The  wire  crossing  in  the  T1-only  (frozen
    tail)  model  -  beyond  it  the  S3  face  becomes
    premise-possible.  No  pin  premise,  no  bridge  premise.  No  RH
    claim. -/
theorem  wallLoAboveWire  (N  :  ℕ)  (ht  :  1000  <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (hN  :  2  *  T4OffLE.nIdeal  t  d0  <=  (N  :  ℝ)  ∧  (N  :  ℝ)  <  Nstar  t  d0)  :
    T4OffLE.wallLo  t  d0  N  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hs0  :  0  < (1  / 2  :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
    have  hNp  :  0  < (N  :  ℝ)  :=  by  linarith  [hN.1,  T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
    have  h2nIp  :  0  < 2  *  T4OffLE.nIdeal  t  d0  :=
      by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
    have  hNstarp  :=  Nstar_pos  t  d0  ht  hdlow  hdhigh
    have  hsig1  :  0  < (3  / 2)  -  d0  :=  by  linarith  [hs0]
    have  hsig2  :  0  < (1  / 2  -  d0)  +  2  :=  by  linarith  [hs0]
    --  t2  (N)  frozen  at  2  nIdeal:  N  >=  2  nIdeal  =>
    --  N  ^  (sigma+1)  >=  (2  nIdeal)  ^  (sigma+1)  =>  the  inverses  flip.
    have  hNpow1  :  (2  *  T4OffLE.nIdeal  t  d0)  ^  ((3  / 2)  -  d0)  <=  (N  :  ℝ)  ^  ((3  / 2)  -  d0)  :=
      rpow_le_rpow  (le_of_lt  h2nIp)  hN.1  (le_of_lt  hsig1)
    have  hNpos1  :  0  < (2  *  T4OffLE.nIdeal  t  d0)  ^  ((3  / 2)  -  d0)  :=
      rpow_pos_of_pos  h2nIp  ((3  / 2)  -  d0)
    have  hNposN  :  0  < (N  :  ℝ)  ^  ((3  / 2)  -  d0)  :=
      rpow_pos_of_pos  hNp  ((3  / 2)  -  d0)
    have  hinv1  :  1  /  ((N  :  ℝ)  ^  ((3  / 2)  -  d0))  <=
        1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((3  / 2)  -  d0))  :=
      (one_div_le_one_div  hNposN  hNpos1).mpr  hNpow1
    have  hinvN1  :  (N  :  ℝ)  ^  (-(3  / 2  -  d0))  =
        1  /  ((N  :  ℝ)  ^  ((3  / 2)  -  d0))  :=
      by  rw  [rpow_neg  (le_of_lt  hNp)  ((3  / 2)  -  d0)];  rw  [inv_eq_one_div]
    have  hinv2nI1  :  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(3  / 2  -  d0))  =
        1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((3  / 2)  -  d0))  :=
      by  rw  [rpow_neg  (le_of_lt  h2nIp)  ((3  / 2)  -  d0)];  rw  [inv_eq_one_div]
    have  ht2  :  (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-(3  / 2  -  d0))  <=  C2  t  d0  :=
      by
        dsimp  only  [C2]
        calc  (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-(3  / 2  -  d0))
          _  =  (‖t4l_sOffL  t  d0‖  /  12)  *  (1  /  ((N  :  ℝ)  ^  ((3  / 2)  -  d0)))  :=
            by  rw  [hinvN1]
          _  <=  (‖t4l_sOffL  t  d0‖  /  12)  *  (1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((3  / 2)  -  d0)))  :=
            mul_le_mul_of_nonneg_left  hinv1  (div_nonneg  (norm_nonneg  _)  (by  norm_num))
          _  =  (‖t4l_sOffL  t  d0‖  /  12)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(3  / 2  -  d0))  :=
            by  rw  [hinv2nI1]
    have  hNpow2  :  (2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2)  <=  (N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2)  :=
      rpow_le_rpow  (le_of_lt  h2nIp)  hN.1  (le_of_lt  hsig2)
    have  hNpos2  :  0  < (2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2)  :=
      rpow_pos_of_pos  h2nIp  ((1  / 2  -  d0)  +  2)
    have  hNposN2  :  0  < (N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2)  :=
      rpow_pos_of_pos  hNp  ((1  / 2  -  d0)  +  2)
    have  hinv2  :  1  /  ((N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2))  <=
        1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2))  :=
      (one_div_le_one_div  hNposN2  hNpos2).mpr  hNpow2
    have  hinvN2  :  (N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2))  =
        1  /  ((N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2))  :=
      by  rw  [rpow_neg  (le_of_lt  hNp)  ((1  / 2  -  d0)  +  2)];  rw  [inv_eq_one_div]
    have  hinv2nI2  :  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-((1  / 2  -  d0)  +  2))  =
        1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2))  :=
      by  rw  [rpow_neg  (le_of_lt  h2nIp)  ((1  / 2  -  d0)  +  2)];  rw  [inv_eq_one_div]
    let  Kterm  :  ℝ  :=  (Real.sqrt  3  /  216)  *
        ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖
    have  hK  :  0  <= Kterm  :=
      mul_nonneg  (by  nlinarith  [Real.sqrt_nonneg  3])  (norm_nonneg  _)
    have  ht3  :  (Real.sqrt  3  /  216)  *
          ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
          (N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2))  /  ((1  / 2  -  d0)  +  2)  <=  C3  t  d0  :=
      by
        dsimp  only  [C3]
        have  hmul  :  Kterm  *  (1  /  ((N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2)))  <=
            Kterm  *  (1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2)))  :=
          mul_le_mul_of_nonneg_left  hinv2  hK
        calc  (Real.sqrt  3  /  216)  *
            ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
            (N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2))  /  ((1  / 2  -  d0)  +  2)
          _  =  (Kterm  *  (1  /  ((N  :  ℝ)  ^  ((1  / 2  -  d0)  +  2))))  /  ((1  / 2  -  d0)  +  2)  :=
            by  rw  [hinvN2]
          _  <=  (Kterm  *  (1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  ((1  / 2  -  d0)  +  2))))  /
                ((1  / 2  -  d0)  +  2)  :=
            by
              gcongr
              <;>  (try  exact  hmul)  <;>  (try  linarith  [hsig2])  <;>  (try  norm_num)
          _  =  (Real.sqrt  3  /  216)  *
            ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
            (2  *  T4OffLE.nIdeal  t  d0)  ^  (-((1  / 2  -  d0)  +  2))  /  ((1  / 2  -  d0)  +  2)  :=
            by  rw  [hinv2nI2.symm]
    --  Nstar  ^  (-sigma)  =  2  (wire  +  C2  +  C3)  by  construction.
    have  hC2n  :  0  <=  C2  t  d0  :=
      by
        dsimp  only  [C2]
        have  hn  :  0  <= 2  *  T4OffLE.nIdeal  t  d0  :=
          by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
        exact  mul_nonneg  (div_nonneg  (norm_nonneg  _)  (by  norm_num))
          (rpow_nonneg  hn  (-(3  /  2  -  d0)))
    have  hC3n  :  0  <=  C3  t  d0  :=
      by
        dsimp  only  [C3]
        have  hn  :  0  <= 2  *  T4OffLE.nIdeal  t  d0  :=
          by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
        have  hKp  :  0  <= (Real.sqrt  3  /  216)  *
            ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  :=
          hK
        have  hrp  :  0  <= (2  *  T4OffLE.nIdeal  t  d0)  ^  (-((1  / 2  -  d0)  +  2))  :=
          rpow_nonneg  hn  (-((1  / 2  -  d0)  +  2))
        exact  div_nonneg  (mul_nonneg  hKp  hrp)
          (by  nlinarith  [le_of_lt  hdhigh])
    have  hNstarpow  :  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  =
        2  *  (S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0)  :=
      by
        dsimp  only  [Nstar]
        have  hsum  :  0  < S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0  :=
          by  nlinarith  [wirePos  t  d0  ht  hdlow  hdhigh,  hC2n,  hC3n]
        have  hbasep  :  0  <= 2  *  (S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0)  :=
          le_of_lt  (mul_pos  (by  norm_num  :  (0  :  ℝ)  < 2)  hsum)
        rw  [(rpow_mul  hbasep  (-(1  /  (1  / 2  -  d0)))  (-(1  / 2  -  d0))).symm]
        have  hexp  :  (-(1  /  (1  / 2  -  d0)))  *  (-(1  / 2  -  d0))  =  1  :=
          by
            have  hx  :  (1  / 2  -  d0)  ≠  0  :=  ne_of_gt  hs0
            calc  (- (1  /  (1  /  2  -  d0)))  *  (- (1  /  2  -  d0))
              _  =  (1  /  2  -  d0)⁻¹  *  (1  /  2  -  d0)  :=  by  ring
              _  =  1  :=  inv_mul_cancel₀  hx
        rw  [hexp,  rpow_one]
    --  strict  T1:  N  <  Nstar  =>  N  ^  (-sigma)  >  Nstar  ^  (-sigma).
    have  hNsiglt  :  (N  :  ℝ)  ^  (1  / 2  -  d0)  <  (Nstar  t  d0)  ^  (1  / 2  -  d0)  :=
      rpow_lt_rpow  (le_of_lt  hNp)  hN.2  hs0
    have  hNsigp  :  0  < (N  :  ℝ)  ^  (1  / 2  -  d0)  :=
      rpow_pos_of_pos  hNp  (1  / 2  -  d0)
    have  hNstargsigp  :  0  < (Nstar  t  d0)  ^  (1  / 2  -  d0)  :=
      rpow_pos_of_pos  hNstarp  (1  / 2  -  d0)
    have  hinv  :  1  /  ((N  :  ℝ)  ^  (1  / 2  -  d0))  >
        1  /  ((Nstar  t  d0)  ^  (1  / 2  -  d0))  :=
      (one_div_lt_one_div  hNstargsigp  hNsigp).mpr  hNsiglt
    have  hinvN  :  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  =
        1  /  ((N  :  ℝ)  ^  (1  / 2  -  d0))  :=
      by  rw  [rpow_neg  (le_of_lt  hNp)  (1  / 2  -  d0)];  rw  [inv_eq_one_div]
    have  hinvNs  :  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  =
        1  /  ((Nstar  t  d0)  ^  (1  / 2  -  d0))  :=
      by  rw  [rpow_neg  (le_of_lt  hNstarp)  (1  / 2  -  d0)];  rw  [inv_eq_one_div]
    have  ht1  :  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  >
        (1  / 2)  *  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  :=
      by
        rw  [hinvN,  hinvNs]
        exact  mul_lt_mul_of_pos_left  hinv  (by  norm_num  :  0  < (1  / 2  :  ℝ))
    have  hA  :  T4OffLE.wallLo  t  d0  N  >=
        (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  :=
      by
        calc  T4OffLE.wallLo  t  d0  N
          _  =  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -
                (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-(3  / 2  -  d0))  -
                (Real.sqrt  3  /  216)  *
                  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
                  ((N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2)))  /  ((1  / 2  -  d0)  +  2)  :=
            by  simp  only  [T4OffLE.wallLo]
          _  >=  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  :=
            by  nlinarith  [ht2,  ht3]
    have  hB  :  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  >
        S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      by
        have  hmid  :  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  >=
            (1  / 2)  *  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  :=
by
            have  hhalf  :  (1  / 2)  *  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  <=
                (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  /  2  -  d0))  :=  le_of_lt  ht1
            linarith
        have  hlast  :  (1  / 2)  *  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0  =
            S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
by
            calc  (1  / 2)  *  (Nstar  t  d0)  ^  (-(1  / 2  -  d0))  -  C2  t  d0  -  C3  t  d0
              _  =  (1  / 2)  *
                (2  *  (S4A.BwireR  t  d0  +  S4A.MrR  t  d0  +  C2  t  d0  +  C3  t  d0))  -  C2  t  d0  -  C3  t  d0  :=
                by  rw  [hNstarpow]
              _  =  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  by  ring
        linarith  [hmid,  hlast]
    exact  lt_of_lt_of_le  hB  hA

/-  =================================================================
   S2  THE  FACE  IS  INFEASIBLE  ON  [nIdeal,  Nstar)
   =================================================================
   The  interval  result:  N  in  [nIdeal,  2  nIdeal]  -  T4OffLK
   range  face  death;  N  in  [2  nIdeal,  Nstar)  -  S1  +  the
   0266  weak-pin  atom.  -/

/-- S  S2  S3-FACE  INFEASIBILITY  ON  [nIdeal,  Nstar):  on  the
    band,  at  every  run  N  with  nIdeal  <=  N  <  Nstar,  the
    A2c-exact  fill  is  strictly  above  the  wire.  The  in-body
    face  infeasibility  interval  now  reaches  the  closed  weak
    wire  crossing  Nstar  (just  below  the  day065  true  crossing
    N1).  Beyond  Nstar  the  face  is  premise-possible  (outside
    the  squeeze  class).  No  pin  premise,  no  bridge  premise.
    No  RH  claim. -/
theorem  s3faceInfeasibleBelowNstar  (N  :  ℕ)  (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)  (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (hN  :  T4OffLE.nIdeal  t  d0  <=  (N  :  ℝ)  ∧  (N  :  ℝ)  <  Nstar  t  d0)  :
    ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  h2nIp  :  0  < 2  *  T4OffLE.nIdeal  t  d0  :=
      by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
    by_cases  hgt  :  (N  :  ℝ)  >  2  *  T4OffLE.nIdeal  t  d0
    · have  hN0r  :  (0  :  ℝ)  < (N  :  ℝ)  :=  by  linarith  [hgt,  h2nIp]
      have  hN0  :  0  < N  :=  by  simpa  using  Nat.cast_pos.mp  hN0r
      have  hweak  :=  wallLoAboveWire  t  d0  N  ht  hdlow  hdhigh  ⟨le_of_lt  hgt,  hN.2⟩
      exact  T4OffLJ.s3faceDeadWeakPin  t  d0  N  ht  hdlow  hdhigh  hN0  hweak
    · have  hLE  :  (N  :  ℝ)  <=  2  *  T4OffLE.nIdeal  t  d0  :=  le_of_not_gt  hgt
      have  hN0r  :  (0  :  ℝ)  < (N  :  ℝ)  :=
        by  linarith  [hN.1,  T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
      have  hN0  :  0  < N  :=  by  simpa  using  Nat.cast_pos.mp  hN0r
      exact  T4OffLK.s3faceInfeasiblePinRange  t  d0  N  hN0  ht  hdlow  hdhigh  ⟨hN.1,  hLE⟩

end  T4OffLL
