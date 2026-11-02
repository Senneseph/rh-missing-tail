/- T4OffLG -- THE Q2 DECOUPLED ROUTE, EXHAUSTED IN BODY (the S3-leg
   infeasibility of the 0257/0258 decoupled squeeze) - OFF-BOARD
   POSITIVE-DUAL / NEGATIVE MARGIN RECORD (the T4OffLB/LC/LD/LE/LF
   class).  No RH claim.

   The decoupled squeeze (T4OffLE.t4LE_squeeze_decoupled) is a
   contradiction machine with three external premises at the
   decoupled fill run N = Noff = ceil nIdeal:
     (i)   the CITED A2c bridge (P8Floor A2c / DLMF 25.2.8 /
           Apostol Thm 12.21, extended on {Re s > -1}\{-1,-2} by
           identity):
             ||zeta (sL) - (p4_P N sL - p4_I N sL)|| =
               ||p4_em_expr sL N||,  sL = t4l_sOffL t d0;
     (ii)  the NAMED S3 face (the fill run's kernel at or below the
           S4 window wire wall):
             ||zeta (sL) - (p4_P N sL - p4_I N sL)|| <=
               S4A.BwireR t d0 + S4A.MrR t d0;
     (iii) the pin  wallLo t d0 N > ||poff t d0 t||  -  an IN-BODY
           fact on the whole band since 0259 (T4OffLF.pin).

   THE RECORD HERE (S  S1): premise (ii) is FALSE in the ACTUAL
   kernel world at N = Noff, on the whole band, proven IN BODY
   (no zeta, no A2c, no zero data - the pure closed chain):

       ||p4_em_expr (t4l_sOffL t d0) (Noff t d0)||
           >= wallLo t d0 (Noff t d0)        [T4OffLE.t4LE_floor_off]
           >  ||poff t d0 t||                [T4OffLF.pin, 0259]
           =  S1LowT.floStripMin t d0        [T4OffLE.t4LE_flo_eq_own]
           >  S4A.BwireR t d0 + S4A.MrR t d0 [FUnif.s4StripUnifiedFloor]

   i.e. the S1 leg (the floor CARRIES, factor 2.0000, 0258) and the
   S3 leg (the wire wall is BELOW the fill run's kernel) cannot hold
   simultaneously - the 0257 shared-value pathology, now a body fact:
   the legs bind different quantities, and at the Noff run the S3
   face fails with margin >= 2 (worst 2.2271 at the (1000, 1/200)
   corner, t-flat; day063, exact B3Core model).

   CONSEQUENCE (S  S2): the decoupled squeeze CANNOT discharge an
   off-pair - its premise set {bridge, S3 face, pin} is inconsistent
   in body at Noff, so the Q2 decoupled route (0257/0258) is
   EXHAUSTED as a closure route for hOffCPT2: the S1 side carries
   (0258/0259), the S3 side cannot (here).  The only residue of the
   Q2 line is 0257's tail-transfer certificate scale (3.1e-46 at
   (tPT2, 1/200) - nothing at the scale level blocks a genuinely
   ASYMMETRIC family: fill engine and wire wall at DIFFERENT scales
   connected by a per-run transfer certificate - FRONTIER plan item 2,
   research surface, not a route).  hOffCPT2 stays open. -/

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

open  Real

set_option  linter.style.longLine  false

namespace  T4OffLG

/-!  S  S1  THE  S3-LEG  INFEASIBILITY  (in  body,  no  zeta,  no
    A2c,  no  zero  data):  at  the  decoupled  fill  run  Noff,  the
    EM-kernel  norm  STRICTLY  EXCEEDS  the  S4  window  wire  wall
    (BwireR  +  MrR),  at  every  band  point. -/
theorem s3legInfeas (t d0 : ℝ)
    (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))  :
    ‖p4_em_expr  (t4l_sOffL  t  d0)  (T4OffLE.Noff  t  d0)‖  >
      S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  hdh  :  d0  <=  (1  /  2  :  ℝ)  :=  le_of_lt  hdhigh
    have  hN1  :  (1  :  ℝ)  <=  (T4OffLE.Noff  t  d0  :  ℝ)  :=
      le_trans  (T4OffLE.t4LE_nIdeal_ge  t  d0  ht  hdlow  hdhigh)
        (T4OffLE.t4LE_ceil_bounds  t  d0  ht  hdlow  hdhigh).1
    have  hNz  :  T4OffLE.Noff  t  d0  ≠  0  :=
      by
        intro  hN0
        rw  [hN0]  at  hN1
        have  hbad  :  (1  :  ℝ)  <=  (0  :  ℝ)  :=  by  simpa  using  hN1
        have  hcon  :  (0  :  ℝ)  <  1  :=  by  norm_num
        exact  lt_irrefl  (0  :  ℝ)  (lt_of_lt_of_le  hcon  hbad)
    have  hNp  :  0  <  T4OffLE.Noff  t  d0  :=
      Nat.pos_of_ne_zero  hNz
    have  hM0  :  S4A.MfR  (t,  d0)  =  0  :=  by  dsimp  only  [S4A.MfR]
    have  hwire  :=  FUnif.s4StripUnifiedFloor  t  d0  ht  hdlow  hdh
    rw  [hM0,  add_zero]  at  hwire
    have  hflo  :=  T4OffLE.t4LE_flo_eq_own  t  d0  ht  hdlow  hdh
    refine  lt_of_lt_of_le  (by
      calc
        S4A.BwireR  t  d0  +  S4A.MrR  t  d0  <  S1LowT.floStripMin  t  d0  :=
          hwire
        _  =  ‖poff  t  d0  t‖  :=  hflo
        _  <  T4OffLE.wallLo  t  d0  (T4OffLE.Noff  t  d0)  :=
          T4OffLF.pin  t  d0  ht  hdlow  hdhigh)
      (T4OffLE.t4LE_floor_off  t  d0  (T4OffLE.Noff  t  d0)  ht  hdlow
        hdhigh  hNp)

/-!  S  S2  THE  S3  FACE  IS  FALSE  AT  NOFF:  given  the  A2c
    bridge  (the  fill  =  the  kernel  norm  at  the  fill  run),  the
    S3-face  premise  of  T4OffLE.t4LE_squeeze_decoupled  FAILS  at
    N  =  Noff  on  the  band  -  the  fill  EXCEEDS  the  wire  wall:
    the  decoupled  squeeze's  premise  set  is  inconsistent  in
    body,  and  the  Q2  route  is  exhausted  (S1  carries  with
    factor  2,  0258/0259;  S3  cannot). -/
theorem s3faceFalseAtNoff (t d0 : ℝ)
    (ht : 1000 <= t) (hdlow : (1 / 200 : ℝ) <= d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (hbridge  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
          p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  =
          ‖p4_em_expr  (t4l_sOffL  t  d0)  (T4OffLE.Noff  t  d0)‖)  :
    ¬  ‖riemannZeta  (t4l_sOffL  t  d0)  -
        (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
        p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  <=
        S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    intro  hface
    have  hin  :=  s3legInfeas  t  d0  ht  hdlow  hdhigh
    have  hfill  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
        (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
        p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  >
        S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      by
        calc
          ‖riemannZeta  (t4l_sOffL  t  d0)  -
            (p4_P  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0)  -
            p4_I  (T4OffLE.Noff  t  d0)  (t4l_sOffL  t  d0))‖  =
            ‖p4_em_expr  (t4l_sOffL  t  d0)  (T4OffLE.Noff  t  d0)‖  :=
            hbridge
          _  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hin
    exact  not_le_of_gt  hfill  hface

end  T4OffLG
