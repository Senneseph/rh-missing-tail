/-  T4OffLK  --  THE  0259  PIN,  AS  A  RANGE  THEOREM:  wallLo  (N)
   >  own  at  EVERY  run  N  in  [nIdeal,  2  nIdeal]  (the  0259
   coarse-ceiling  pin  was  landed  at  the  single  run  Noff  =
   ceil  nIdeal;  T4OffLK  proves  the  full  range),  and  the  S3
   FACE  IS  INFEASIBLE  THROUGHOUT  THE  RANGE  (T4OffLJ.s1's  weak
   pin  applied  to  the  range  pin  +  the  S4  strict  gap  -  no
   pin  premise  at  the  corollary  level).  OFF-BOARD  NEGATIVE
   MARGIN  RECORD  (the  T4OffLB/LC/LD/LE/LF/LG/LH/LI/LJ  class).
   No  RH  claim.

   Why:  T4OffLJ's  weak-pin  face-death  atom  (s3faceDeadWeakPin)
   extends  the  0262  S3-face-death  region  from  {N  :  wallLo
   (N)  >  own}  to  {N  :  wallLo  (N)  >  wire}.  The  range  pin
   here  makes  the  pin  region  [nIdeal,  2  nIdeal]  an  explicit
   in-body  fact  (previously  only  the  Noff  instantiation  was
   landed  as  a  single  statement),  so  the  face-infeasibility
   corollary  covers  the  whole  0259  range,  not  the  single
   decoupled  fill  run.  The  next  formal  fire  (named  in  0266)
   is  the  WIRE-CROSSING  extension:  wallLo  (N)  >  wire  for  N
   beyond  2  nIdeal  up  to  the  day065  crossing  N1  (a  larger
   closed  log-chain;  the  day065  map  has  the  margins  -  36/36
   band  points  EXHAUSTED,  tightest  log10  (N1/N2)  =  0.094  at
   (1e3,  1/200)).  -/

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

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false

open  Real

namespace  T4OffLK

variable  (t  d0  :  ℝ)

/-  =================================================================
   S1  THE  RANGE  PIN
   =================================================================
   The  0259  pin  at  every  run  of  the  coarse  range.  The  proof
   is  T4OffLF.pin  with  Noff  replaced  by  a  free  N  under  the
   range  hypotheses:  the  T1  chain  uses  N  <=  2  nIdeal  (the
   range  upper  bound  instead  of  the  ceiling  fact),  and  the
   T2/T3  caps  (T4OffLF.t2cap  /  t3cap)  already  take  a  free  N
   under  nIdeal  <=  N.  -/

/-- S  S1  THE  0259  RANGE  PIN:  on  the  band,  at  every  run  N
    in  [nIdeal,  2  nIdeal],  the  wall  clears  the  own  mass:
    wallLo  (t,  d0,  N)  >  ‖poff  t  d0  t‖.  No  RH  claim. -/
theorem  pinRange  (ht  :  1000  <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  (N  :  ℕ)  (HN  :  0  <  N)
    (hN  :  T4OffLE.nIdeal  t  d0  <=  (N  :  ℝ)  ∧  (N  :  ℝ)  <=  2  *  T4OffLE.nIdeal  t  d0)  :
    T4OffLE.wallLo  t  d0  N  >  ‖poff  t  d0  t‖  :=
  by
    have  hd0p  :  0  <  d0  :=  by  linarith  [hdlow]
    have  htp  :  0  <  t  :=  by  linarith  [ht]
    have  hs0  :  0  < (1  /  2  :  ℝ)  -  d0  :=  by  linarith  [hdhigh]
    have  hNp  :  0  < (N  :  ℝ)  :=  by  exact  Nat.cast_pos.mpr  HN
    have  h2nIp  :  0  < 2  *  T4OffLE.nIdeal  t  d0  :=
      by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]
    have  hNsig  :  (N  :  ℝ)  ^  (1  / 2  -  d0)  <=
        (2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0)  :=
      rpow_le_rpow  (le_of_lt  hNp)  hN.2  (le_of_lt  hs0)
    have  hNpsig  :  0  < (N  :  ℝ)  ^  (1  / 2  -  d0)  :=
      rpow_pos_of_pos  hNp  (1  / 2  -  d0)
    have  h2nIpsig  :  0  < (2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0)  :=
      rpow_pos_of_pos  h2nIp  (1  / 2  -  d0)
    have  hrec  :  1  /  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0))  <=
        1  /  ((N  :  ℝ)  ^  (1  / 2  -  d0))  :=
      (one_div_le_one_div  h2nIpsig  hNpsig).mpr  hNsig
    have  hs  :  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  =
        (1  / 2)  *  ((N  :  ℝ)  ^  (1  / 2  -  d0))⁻¹  :=
      by  rw  [rpow_neg  (le_of_lt  hNp)  (1  / 2  -  d0)]
    have  ht1mid  :  (1  / 2  :  ℝ)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  =
        (1  / 2)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0))⁻¹  :=
      by  rw  [rpow_neg  (le_of_lt  h2nIp)  (1  / 2  -  d0)]
    have  hsplit  :  (1  / 2  :  ℝ)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  =
        (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  :=
      by
        rw  [mul_rpow  (by  norm_num  :  (0  :  ℝ)  <=  2)
          (by  linarith  [T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh]  :
            0  <=  T4OffLE.nIdeal  t  d0)]
        ring
    have  hknife  :  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *
        (T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  =
        (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  :=
      by  rw  [T4OffLF.nIdeal_pow_sig  t  d0  htp  hd0p  hdhigh]
    have  he  :  (-(1  / 2  -  d0)  :  ℝ)  =  (d0  -  1  / 2  :  ℝ)  :=  by  ring
    have  hT1e  :  (1  / 2  :  ℝ)  *  16  *  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  =
        4  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=
      by
        rw  [he]
        have  h8  :  (1  / 2  :  ℝ)  *  16  =  8  :=  by  norm_num
        rw  [h8]
        have  hp3  :  (8  :  ℝ)  =  (2  :  ℝ)  ^  (3  :  ℝ)  :=  by  norm_num
        rw  [hp3]
        rw  [(Real.rpow_add  (by  norm_num  :  (0  :  ℝ)  <  2)  (3  :  ℝ)  (d0  -  1  / 2)).symm]
        rw  [show  (3  :  ℝ)  +  (d0  -  1  / 2)  =  ((1  / 2  :  ℝ)  +  d0)  +  2  by  ring]
        rw  [Real.rpow_add  (by  norm_num  :  (0  :  ℝ)  <  2)  ((1  / 2  :  ℝ)  +  d0)  (2  :  ℝ)]
        have  hp4  :  (2  :  ℝ)  ^  (2  :  ℝ)  =  4  :=  by  norm_num
        rw  [hp4]
        ring
    have  hfinA  :  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  =
        ((1  / 2)  *  16  *  (2  :  ℝ)  ^  (-(1  / 2  -  d0)))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=  by  ring
    have  hfinB  :  ((1  / 2)  *  16  *  (2  :  ℝ)  ^  (-(1  / 2  -  d0)))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  =
        (4  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  :=  by  rw  [hT1e]
    have  hfinC  :  (4  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0))  *  d0  *  d0  *  t  ^  (-(2  :  ℝ))  =
        (4  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=  by  ring
    have  hfinD  :  (4  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  =
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=
      by
        rw  [T4OffLF.tinv2  t  htp]
        field_simp
    have  hfin  :  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  =
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=
      by  rw  [hfinA,  hfinB,  hfinC,  hfinD]
    have  hrec2  :  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0))⁻¹  <=
        ((N  :  ℝ)  ^  (1  / 2  -  d0))⁻¹  :=
      by  simpa  using  hrec
    have  hstep2  :  (1  / 2  :  ℝ)  *  ((N  :  ℝ)  ^  (1  / 2  -  d0))⁻¹  >=
        (1  / 2)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0))⁻¹  :=
      mul_le_mul_of_nonneg_left  hrec2  (by  norm_num  :  0  <=  (1  / 2  :  ℝ))
    have  hT1  :  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  >=
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=
      by
        calc  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))
          _  =  (1  / 2)  *  ((N  :  ℝ)  ^  (1  / 2  -  d0))⁻¹  :=  hs
          _  >=  (1  / 2)  *  ((2  *  T4OffLE.nIdeal  t  d0)  ^  (1  / 2  -  d0))⁻¹  :=
            hstep2
          _  =  (1  / 2)  *  (2  *  T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  :=  ht1mid.symm
          _  =  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (T4OffLE.nIdeal  t  d0)  ^  (-(1  / 2  -  d0))  :=  hsplit
          _  =  (2  :  ℝ)  ^  (-(1  / 2  -  d0))  *  (1  / 2)  *  (16  *  d0  *  d0  *  t  ^  (-(2  :  ℝ)))  :=  hknife
          _  =  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  :=  hfin
    have  hT2  :  (‖t4l_sOffL  t  d0‖  /  12)  *
        (N  :  ℝ)  ^  (-(3  / 2  -  d0))  <=  T4OffLF.T2b  t  d0  :=
      T4OffLF.t2cap  t  d0  N  ht  hdlow  hdhigh  hN.1
    have  hT3  :  (Real.sqrt  3  /  216)  *
          ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
          (N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2))  /  ((1  / 2  -  d0)  +  2)  <=
        T4OffLF.T3b  t  d0  :=
      T4OffLF.t3cap  t  d0  N  ht  hdlow  hdhigh  hN.1
    have  hwall  :  T4OffLE.wallLo  t  d0  N  >=
        (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  -
        T4OffLF.T2b  t  d0  -  T4OffLF.T3b  t  d0  :=
      by
        calc  T4OffLE.wallLo  t  d0  N
          _  =  (1  / 2  :  ℝ)  *  (N  :  ℝ)  ^  (-(1  / 2  -  d0))  -
                (‖t4l_sOffL  t  d0‖  /  12)  *  (N  :  ℝ)  ^  (-(3  / 2  -  d0))  -
                (Real.sqrt  3  /  216)  *
                  ‖t4l_sOffL  t  d0  *  (t4l_sOffL  t  d0  +  1)  *  (t4l_sOffL  t  d0  +  2)‖  *
                  ((N  :  ℝ)  ^  (-((1  / 2  -  d0)  +  2)))  /  ((1  / 2  -  d0)  +  2)  :=
            by  simp  only  [T4OffLE.wallLo]
          _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  -
                T4OffLF.T2b  t  d0  -  T4OffLF.T3b  t  d0  :=
            by  nlinarith  [hT1,  hT2,  hT3]
    have  hgap  :=  T4OffLF.t5strict  t  d0  ht  hdlow  hdhigh
    have  hown  :=  T4OffLF.ownCap  t  d0  ht  hdlow  hdhigh
    calc  T4OffLE.wallLo  t  d0  N
      _  >=  (4  *  d0  ^  2  /  t  ^  2)  *  (2  :  ℝ)  ^  ((1  / 2  :  ℝ)  +  d0)  -
            T4OffLF.T2b  t  d0  -  T4OffLF.T3b  t  d0  :=  hwall
      _  >  (4  *  d0  ^  2  /  t  ^  2)  *  (1  +  1  /  (16  *  t  ^  2))  *
            Real.exp  (1  /  t  ^  2)  :=  hgap
      _  >=  ‖poff  t  d0  t‖  :=  hown

/-  =================================================================
   S2  THE  S3  FACE  IS  INFEASIBLE  THROUGHOUT  THE  RANGE
   =================================================================
   range  pin  +  flo  =  own  +  S4  strict  gap  =>  weak  pin
   (wallLo  >  wire)  =>  T4OffLJ.s3faceDeadWeakPin.  No  pin
   premise  at  the  corollary  level.  -/

/-- S  S2  S3-FACE  INFEASIBILITY  ON  THE  0259  RANGE:  on  the
    band,  at  every  run  N  in  [nIdeal,  2  nIdeal],  the  A2c-exact
    fill  is  strictly  above  the  wire  -  the  S3  face  is
    infeasible  throughout  the  range,  derived  from  the  in-body
    range  pin  (S1)  +  the  S4  strict  gap  +  T4OffLJ's  weak-pin
    face  death.  No  RH  claim. -/
theorem  s3faceInfeasiblePinRange  (N  :  ℕ)  (HN  :  0  <  N)
    (ht  :  1000  <=  t)  (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (hN  :  T4OffLE.nIdeal  t  d0  <=  (N  :  ℝ)  ∧  (N  :  ℝ)  <=  2  *  T4OffLE.nIdeal  t  d0)  :
    ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  hdh  :  d0  <=  (1  / 2  :  ℝ)  :=  le_of_lt  hdhigh
    have  hM0  :  S4A.MfR  (t,  d0)  =  0  :=  by  dsimp  only  [S4A.MfR]
    have  hwire  :=  FUnif.s4StripUnifiedFloor  t  d0  ht  hdlow  hdh
    rw  [hM0,  add_zero]  at  hwire
    have  hflo  :=  T4OffLE.t4LE_flo_eq_own  t  d0  ht  hdlow  hdh
    have  hpin  :=  pinRange  t  d0  ht  hdlow  hdhigh  N  HN  hN
    have  hweak  :  T4OffLE.wallLo  t  d0  N  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      by
        calc  T4OffLE.wallLo  t  d0  N
            >  ‖poff  t  d0  t‖  :=  hpin
          _  =  S1LowT.floStripMin  t  d0  :=  hflo.symm
          _  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hwire
    exact  T4OffLJ.s3faceDeadWeakPin  t  d0  N  ht  hdlow  hdhigh  HN  hweak

end  T4OffLK
