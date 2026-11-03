/-  T4OffLJ  --  THE  EM-SQUEEZE  CLASS,  TOTAL  EXHAUSTION  ON  THE
   BAND:  the  face  premise  set  {S3  face,  pin}  of  ANY  squeeze
   instance  at  ANY  run  N  is  JOINTLY  IMPOSSIBLE  in  body  -  no
   A2c  bridge  premise,  no  pin  fact.  The  0262  record  (T4OffLI)
   needed  the  bridge  as  a  premise  to  convert  the  zeta-form  face
   into  the  EM  floor  chain;  T4OffLJ  shows  the  inconsistency  is
   INTERNAL  to  the  face  premise  pair  (S3  face  +  pin)  itself,
   at  every  run,  on  the  whole  band.  OFF-BOARD  NEGATIVE  MARGIN
   RECORD  (the  T4OffLB/LC/LD/LE/LF/LG/LH/  LI  class).  No  RH  claim.

   Three  statements,  in  strengthening  order:

   S1  (weak-pin  S3-face  death):  at  ANY  run  N  whose  wall  clears
       the  WIRE  (the  weak  pin:  wallLo  (N)  >  BwireR  +  MrR  -
       one  degree  weaker  than  the  0262  pin  wallLo  (N)  >  own,
       which  it  implies  via  the  S4  strict  gap),  the  fill  is
       STRICTLY  ABOVE  the  wire:  the  S3  face  is  infeasible.
       The  0262  S3-face-death  region  {N  :  wallLo  (N)  >  own}
       EXTENDS  to  {N  :  wallLo  (N)  >  wire}  -  past  the  pin
       crossing  N3  (0259  range  [nIdeal,  2 nIdeal])  all  the  way
       to  the  wire  crossing  N1.

   S2  (face  +  pin  joint  impossibility,  A2c-EXACT  form):  the  pair
       {  ||p4_em_expr  sL  N||  <=  wire  &&  wallLo  (N)  >  own  }
       is  inconsistent,  every  N,  no  premises  beyond  the  band.
       The  squeeze's  non-bridge  face  premises  cannot  BOTH  hold:
       wherever  the  pin  holds  the  floor  carries  the  fill  above
       the  wire  (S1's  direction),  where  the  floor  does  not
       clear  the  wire  the  pin  cannot  hold  (wire  <  own,  S4).

   S3  (in-body  ZETA  form):  S2  with  the  face  premise  in  the
       terminal-face  zeta  form  -  the  squeeze's  actual  premise
       shape  -  the  A2c  bridge  now  inside  the  proof  (P8A2c  U6,
       entry  0265),  not  a  premise.  THE  EM-SQUEEZE  CLASS  IS
       TOTAL-EXHAUSTED  ON  THE  BAND  AT  TARGET  HEIGHT:  no  squeeze
       instance  at  any  run  N  can  be  premise-consistent;  in
       particular  no  hypothetical  off-pair  above  the  frontier  can
       enter  the  squeeze  machinery  at  any  run.  The  hOffCPT2
       terminal  face  stands  on  the  NON-EM  residue  only:  (a)
       board  /  zeta-data-class  records  above  tPT2,  or  (b)  a
       genuinely  new  argument  outside  the  EM  kernel  at  all.

   day065  quantitative  map  (scripts/rh/day065_em_exhaustion_map.py,
   dps  50,  36  band  points  t  in  {1e3,  1e6,  tPT2}  x  d0  in
   [1/200,  0.4999]):  36/36  EXHAUSTED  -  the  live  squeeze  window
   (N1,  min  (N2,  N3))  (N1:  wallLo  =  wire;  N2:  fill  ~  own;
   N3:  wallLo  =  own)  is  EMPTY  at  every  point,  N1  >=  N2  at
   every  point  (consequence  of  wire  <  own,  the  S4  strict  gap);
   the  tightest  margin  is  (t  =  1e3,  d0  =  1/200):
   log10  (N1/N2)  =  0.094.  Strict  A2c-exact  fill  at  t  =  1e3:
   ||em(sL,  Noff)||/wallLo  -  1  <=  6.1e-15  over  d0  in  {0.005,
   0.05,  0.3,  0.4999};  ||em(sL,  Noff)||/own  =  2.000000  at  every
   point  -  the  0259  pin  margin  2  in  the  A2c-EXACT  fill  (not
   just  the  floor),  verifying  the  0262  chain  numerically.  -/

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
import  RhAttack.T4OffLI
import  RhAttack.P8A2c

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false

namespace  T4OffLJ

/-  =================================================================
   S1  THE  S3  FACE  DIES  UNDER  THE  WEAK  PIN  (wallLo  >  WIRE)
   =================================================================
   The  0262  S3-face-death  atom  (T4OffLI.s1_fillAboveWire)  needs
   the  pin  wallLo  (N)  >  own  as  a  premise.  The  CONSEQUENCE
   only  needs  wallLo  (N)  >  wire:  fill  >=  wallLo  >  wire.
   The  infeasibility  region  of  the  S3  face  extends  from  the
   pin  range  to  the  whole  weak-pin  range.  -/

/-- S  S1  WEAK-PIN  S3-FACE  DEATH  (A2c-EXACT  fill):  on  the  band,
    at  every  run  N  whose  wall  clears  the  wire  wall,  the  EM  fill
    is  strictly  above  the  wire  -  the  S3  face  is  infeasible
    there.  No  pin  premise,  no  bridge  premise:  pure  composition
    of  the  0259  floor  (T4OffLE.t4LE_floor_off). -/
theorem  s3faceDeadWeakPin  (t  d0  :  ℝ)  (N  :  ℕ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (HN  :  0  <  N)
    (hweak  :  T4OffLE.wallLo  t  d0  N  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0)  :
    ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  >
      S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
  by
    calc  ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖
        >= T4OffLE.wallLo  t  d0  N  :=
          T4OffLE.t4LE_floor_off  t  d0  N  ht  hdlow  hdhigh  HN
      _  >  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hweak

/-  =================================================================
   S2  FACE  +  PIN  JOINTLY  IMPOSSIBLE  (the  TOTAL  EXHAUSTION)
   =================================================================
   The  squeeze's  two  non-bridge  face  premises  -  the  S3  face
   (A2c-EXACT  form:  fill  <=  wire)  and  the  pin  (wallLo  >  own)
   -  CANNOT  BOTH  HOLD  at  any  run,  no  premises  beyond  the
   band.  THE  EM-SQUEEZE  CLASS  IS  TOTAL-EXHAUSTED  ON  THE  BAND:
   the  inconsistency  is  INTERNAL  to  the  face  premise  pair.  -/

/-- S  S2  TOTAL  JOINT  IMPOSSIBILITY  (A2c-EXACT  form):  on  the
    band,  at  every  run  N,  the  pair  {S3  face  (EXACT  fill  at  or
    below  the  wire),  pin  (wall  clears  the  own  mass)}  is
    inconsistent.  Chain  of  the  proof  (every  step  in  body):

      wallLo  (N)  <=  fill  (N)                    [T4OffLE.t4LE_floor_off]
                   <=  wire                         [S3  face  premise]
                   <  floStripMin  =  own           [FUnif.s4StripUnifiedFloor
                                                       +  S4A.MfR  =  0]
                   <  wallLo  (N)                   [pin  premise]
    a  strict  cycle.  No  bridge  premise  (the  face  is  taken  in
    the  A2c-EXACT  form),  no  pin  FACT  (the  pin  is  the  premise
    whose  consistency  with  the  face  is  at  issue). -/
theorem  s3facePinJointlyImpossible  (t  d0  :  ℝ)  (N  :  ℕ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (HN  :  0  <  N)  :
    ¬  (‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0  ∧
        T4OffLE.wallLo  t  d0  N  >  ‖poff  t  d0  t‖)  :=
  by
    intro  h
    rcases  h  with  ⟨hface,  hpin⟩
    have  hdh  :  d0  <=  (1  /  2  :  ℝ)  :=  le_of_lt  hdhigh
    have  hM0  :  S4A.MfR  (t,  d0)  =  0  :=  by  dsimp  only  [S4A.MfR]
    have  hwire  :=  FUnif.s4StripUnifiedFloor  t  d0  ht  hdlow  hdh
    rw  [hM0,  add_zero]  at  hwire
    have  hflo  :=  T4OffLE.t4LE_flo_eq_own  t  d0  ht  hdlow  hdh
    --  (a)  wallLo  <=  fill  <=  wire:
    have  hlo  :  T4OffLE.wallLo  t  d0  N  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      by
        calc  T4OffLE.wallLo  t  d0  N
            <= ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  :=
              (T4OffLE.t4LE_floor_off  t  d0  N  ht  hdlow  hdhigh  HN).le
          _  <=  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hface
    --  (b)  wire  <  own  <  wallLo:
    have  hhi  :  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  <
          T4OffLE.wallLo  t  d0  N  :=
      by
        calc  S4A.BwireR  t  d0  +  S4A.MrR  t  d0
            <  S1LowT.floStripMin  t  d0  :=  hwire
          _  =  ‖poff  t  d0  t‖  :=  hflo
          _  <  T4OffLE.wallLo  t  d0  N  :=  hpin
    --  the  cycle  wire  <=  wire:
    exact  lt_irrefl  (T4OffLE.wallLo  t  d0  N)
      (lt_of_le_of_lt  hlo  hhi)

/-  =================================================================
   S3  IN-BODY  ZETA  FORM  (the  terminal-face  premise  shape)
   =================================================================
   S2  with  the  S3  face  premise  in  the  ENDPOINT'S  zeta  form
   (||zeta  (sL)  -  (p4_P  N  sL  -  p4_I  N  sL)||  <=  wire)  -  the
   A2c  bridge  now  INSIDE  THE  PROOF  (P8A2c  a2c_sL_bridge,  entry
   0265),  not  a  premise.  THE  SQUEEZE  STANDS  ON  ITS  FACE
   PREMISE  PAIR  ALONE  -  and  they  cannot  both  hold.  -/

/-- S  S3  TOTAL  EXHAUSTION  (IN-BODY,  ZETA  FORM):  on  the  band,
    at  every  run  N,  the  ENDPOINT-SHAPE  premise  pair  {S3  face
    (zeta  fill  at  or  below  the  wire),  pin  (wall  clears  the
    own  mass)}  is  inconsistent.  The  EM-squeeze  class  has  no
    premise-consistent  instance  anywhere  on  the  band  at  target
    height:  TOTAL  EXHAUSTION  of  the  0252–0262  program,  the
    0262  record  strengthened  from  "the  bridge  premise  is  needed"
    to  "the  face  premise  pair  is  internally  inconsistent".  No
    RH  claim. -/
theorem  squeezePremisesInconsistent  (t  d0  :  ℝ)  (N  :  ℕ)
    (ht  :  1000  <=  t)
    (hdlow  :  (1  /  200  :  ℝ)  <=  d0)
    (hdhigh  :  d0  <  (1  /  2  :  ℝ))
    (HN  :  0  <  N)  :
    ¬  (‖riemannZeta  (t4l_sOffL  t  d0)  -
          (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0  ∧
        T4OffLE.wallLo  t  d0  N  >  ‖poff  t  d0  t‖)  :=
  by
    intro  h
    rcases  h  with  ⟨hface,  hpin⟩
    have  hd0  :  0  <  d0  :=  by  linarith  [hdlow]
    have  hbridge  :=  a2c_sL_bridge  t  d0  ht  hd0  hdhigh  N  HN
    have  hexact  :  ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  <=
          S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=
      by
        calc  ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖
            = ‖riemannZeta  (t4l_sOffL  t  d0)  -
                (p4_P  N  (t4l_sOffL  t  d0)  -
                 p4_I  N  (t4l_sOffL  t  d0))‖  :=  hbridge.symm
          _  <=  S4A.BwireR  t  d0  +  S4A.MrR  t  d0  :=  hface
    exact  s3facePinJointlyImpossible  t  d0  N  ht  hdlow  hdhigh  HN
      (⟨hexact,  hpin⟩)

end  T4OffLJ
