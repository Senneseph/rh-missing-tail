/- T4OffLI -- THE ENTIRE EM-SQUEEZE CLASS, INFEASIBLE AT EVERY RUN
   on the band (the generalization of T4OffLG.s3legInfeas /
   s3faceFalseAtNoff from the fixed run N = Noff to ANY run N) -
   OFF-BOARD NEGATIVE MARGIN RECORD (the T4OffLB/LC/LD/LE/LF/LG/LH
   class).  No RH claim.

   Any instance of the strip squeeze (the P1.2/C1.2 cycle) at a band
   point (1000 <= t, 1/200 <= d0 < 1/2) and any run N with 0 < N has
   three external premises:
     (i)   the CITED A2c bridge at the run:
             ||zeta (sL) - (p4_P N sL - p4_I N sL)|| =
               ||p4_em_expr sL N||,  sL = t4l_sOffL t d0;
     (ii)  the S3 face at the run (the fill at or below the wire wall):
             ||zeta (sL) - (p4_P N sL - p4_I N sL)|| <=
               S4A.BwireR t d0 + S4A.MrR t d0;
     (iii) the pin at the run:
             T4OffLE.wallLo t d0 N > ||poff t d0 t||.

   THE RECORD HERE: given (i) and (iii), premise (ii) is FALSE in the
   ACTUAL world, at EVERY run N, proven IN BODY (no zeta evaluation,
   no zero data - the pure closed chain):

       ||zeta (sL) - (p4_P N sL - p4_I N sL)||
           =  ||p4_em_expr sL N||                    [(i)]
           >= T4OffLE.wallLo t d0 N                  [T4OffLE.t4LE_floor_off]
           >  ||poff t d0 t||                        [(iii)]
           =  S1LowT.floStripMin t d0                [T4OffLE.t4LE_flo_eq_own]
           >  S4A.BwireR t d0 + S4A.MrR t d0         [FUnif.s4StripUnifiedFloor,
                                                      S4A.MfR = 0]

   i.e. the pin premise and the S3-face premise are JOINTLY
   IMPOSSIBLE at every run: wherever the floor exceeds the own mass,
   the fill is already STRICTLY ABOVE the wire wall (the 0258
   knife-edge: the floor CARRIES the wire by the EM-kernel margin,
   and the two premises bind different sides of that margin).

   CONSEQUENCE: EVERY squeeze instance on the band - the in-program
   schedule run (0252/0253), the decoupled fill run Noff (0257-0261),
   and every intermediate or un-named run - is infeasible in body:
   the EM-squeeze class as a whole CANNOT discharge an off-pair on
   [1/200, 1/2) at any target-height point.  It subsumes
   T4OffLG.s3faceFalseAtNoff (the Noff case with the 0259 in-body
   pin as premise (iii)).  The residue for hOffCPT2 is accordingly
   narrowed to inputs OUTSIDE the squeeze premise structure: either
   a zeta-data-class record (route (a): certified frontier above
   tPT2; the B24/B25 board conveyor under the watcher) or a
   genuinely new argument that bounds the TRUE fill without going
   through the {pin + bridge + face} cycle (route (b)).  On the
   near band (0 < d0 < 1/200) the squeeze machinery is out of its
   in-band domain and contributes nothing; see the T4OffLH measured
   map (0261) for the Q2 mechanism's behavior there.  hOffCPT2 stays
   open; the B24/B25 exact-rational board stays the data conveyor. -/

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
import  RhAttack.T4OffLG

open  Real

set_option  linter.style.longLine  false
set_option  linter.style.whitespace  false

namespace  T4OffLI

/-!  S  S1  THE  FILL  IS  STRICTLY  ABOVE  THE  WIRE  WALL  AT  ANY
    RUN  WHERE  THE  PIN  HOLDS:  the  in-body  chain  (the  A2c
    bridge  as  a  premise,  the  floor  and  the  own  mass  and  the
    wire  all  in  body). -/
theorem s1_fillAboveWire (t d0 : ℝ) (N : ℕ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (HN  :  0  <  N)
    (hbridge  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  =
          ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖)
    (hpin  :  T4OffLE.wallLo  t  d0  N  >  ‖poff  t  d0  t‖)  :
    ‖riemannZeta  (t4l_sOffL  t  d0)  -
      (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  >
      S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    have  hdh  :  d0  <=  (1  /  2  :  ℝ)  :=  le_of_lt  hdhigh
    have  hM0  :  S4A.MfR  (t,  d0)  =  0  :=  by  dsimp  only  [S4A.MfR]
    have  hwire  :=  FUnif.s4StripUnifiedFloor  t  d0  ht  hdlow  hdh
    rw  [hM0,  add_zero]  at  hwire
    have  hflo  :=  T4OffLE.t4LE_flo_eq_own  t  d0  ht  hdlow  hdh
    calc
      ‖riemannZeta  (t4l_sOffL  t  d0)  -
        (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  =
        ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  :=  hbridge
      _  >=  T4OffLE.wallLo  t  d0  N  :=
        T4OffLE.t4LE_floor_off  t  d0  N  ht  hdlow  hdhigh  HN
      _  >  ‖poff  t  d0  t‖  :=  hpin
      _  =  S1LowT.floStripMin  t  d0  :=  hflo.symm
      _  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hwire

/-!  S  S2  THE  SQUEEZE  NEVER  FIRES:  the  premise  set  of  ANY
    squeeze  instance  on  the  band  -  {A2c  bridge,  S3  face,
    pin}  at  ANY  run  N  -  is  INCONSISTENT  in  body.  This  is
    the  all-runs  generalization  of  T4OffLG.s3faceFalseAtNoff
    (there  N  is  pinned  to  Noff  and  premise  (iii)  is  the  0259
    in-body  pin  fact;  here  N  is  arbitrary  and  (iii)  is  the
    squeeze's  own  pin  premise  -  the  infeasibility  is  now
    self-contained  in  the  squeeze's  premise  structure  itself). -/
theorem squeezeNeverFires (t d0 : ℝ) (N : ℕ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (HN  :  0  <  N)
    (hbridge  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  =
          ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖)
    (hface  :  ‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0)
    (hpin  :  T4OffLE.wallLo  t  d0  N  >  ‖poff  t  d0  t‖)  :
    False  :=
  by
    have  hfill  :=  s1_fillAboveWire  t  d0  N  ht  hdlow  hdhigh  HN
      hbridge  hpin
    exact  not_le_of_gt  hfill  hface

/-!  S  S3  THE  NOFF  CASE  IS  THE  0259-PIN  INSTANTIATION:  with
    N  :=  Noff  and  premise  (iii)  supplied  by  the  0259  in-body
    pin  (T4OffLF.pin),  S2  reproduces  -  and  generalizes  the
    scope  of  -  T4OffLG.s3faceFalseAtNoff:  the  S3  face  of  the
    decoupled  squeeze  is  impossible  at  the  decoupled  fill  run
    from  the  squeeze's  own  premise  structure  alone  (no  use  of
    the  T4OffLF.pin  fact  in  the  proof  of  S2;  T4OffLF.pin  only
    supplies  premise  (iii)  at  Noff,  as  a  matter  of  which
    premises  actually  hold  in  the  world). -/
theorem noffS3faceImpossible (t d0 : ℝ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
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
    exact  squeezeNeverFires  t  d0  (T4OffLE.Noff  t  d0)  ht  hdlow
      hdhigh  hNp  hbridge  hface
      (T4OffLF.pin  t  d0  ht  hdlow  hdhigh)

end  T4OffLI
