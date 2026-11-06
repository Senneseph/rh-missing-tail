import Mathlib
import RhAttack.LevWall
import RhAttack.LevWall4
import RhAttack.LevWall8

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

/-!
**LevWall9 — the two face-closing doors MEET at the unified wall
(0310,  option  B,  unit  21  -  M2  lane:  door  2's  antecedent
re-audited  at  the  primary,  Bettin-Gonek  2017).**

PRIMARY  RE-READ  (this  unit):  Bettin-Gonek,  "The  θ  =  ∞
conjecture  implies  the  Riemann  hypothesis",  Mathematika  63
(2017)  29-33  =  arXiv:1604.02740,  re-fetched  and  read  in
full  (2026-11-06):
  *  (1.1)  I_N(T1,T2)  :=  ∫_{T1}^{T2}  |M_N(1/2  +  it)|²
      |ζ(1/2  +  it)|²  dt,  with  the  LEVINSON  MOLLIFIER
      M_N(s)  =  Σ_{n  <=  N}  μ(n)  n^{-s}  (1  −  log  n  /
      log  N),  N  >=  2;
  *  Theorem  1  (PROVEN  INSIDE  BG  2017;  0296's
      [BG-T1-ARB]  =  LevWall4.bgArbImpliesAllOnLine):
      fixed  θ  >  0;  if  I_N(0,T)  ≪_ε  T^{1+ε}  for  2  <=
      N  <=  T^θ  then  ζ  has  no  zeros  in  Re  s  >  1/2  +
      1/(2θ);  "In  particular,  if  I_N(0,T)  ≪_ε  T^{1+ε}
      for  2  <=  N  <=  T^θ  with  θ  arbitrarily  large,
      then  the  Riemann  hypothesis  is  true."
  *  THE  PUBLISHED  REACH  OF  THE  ANTECEDENT  (the  paper's
      own  citation  record):
        -  Levinson  [4]:  lim_{T -> ∞}  I_{T^θ}(0,T)/T  =
            1  +  1/θ    for  0  <  θ  <  1/2;
        -  CONREY  [1]  "later  proved  that  (1.2)  (with  a
            slightly  different  mollifier)  remains  valid
            for  θ  <  4/7,  and  thereby  deduced  that
            κ  >  2/5"  —  THE  ANTECEDENT'S  PUBLISHED
            REACH  IS  EXACTLY  4/7,  THE  SAME  (1.2)  WALL
            AS  DOOR  1;
        -  Farmer  [2]:  the  θ  =  ∞  conjecture  ((1.2)  for
            EVERY  θ  >  0)  +  (1.2)@all  θ  =>  κ  =  1  (the
            door-1  lineage);
        -  Radziwiłł  [6]:  M_{T^θ}  is  essentially  the  best
            possible  mollifier  of  length  T^θ  -  Levinson's
            method  gives  κ  =  1  only  with  θ  arbitrarily
            large.
  *  THE  DIAGONAL-TO-RANGE  GAP  (honesty,  in  the  0296
      red-line  posture):  the  published  asymptotic  is
      DIAGONAL  (N  =  T^θ,  fixed  θ,  T  ->  ∞);  Theorem
      1's  antecedent  is  RANGE  (uniform  for  2  <=  N  <=
      T^θ).  The  upgrade  (small-N  regime  I_N(0,T)  ≪_ε
      T^{1+ε}  by  standard  second-moment  estimates;
      intermediate  N  by  the  per-θ'  diagonals)  is  a
      STANDARD  argument  but  is  NOT  proven  in-tree  and
      is  not  recorded  as  a  theorem  in  BG  2017  itself;
      recorded  here  as  a  named  honesty  gap,  not  a
      lemma.  The  gap  does  NOT  move  the  reach  (4/7):
      it  only  converts  the  diagonal  statement  into  the
      range  shape  at  the  same  published  frontier.

  CONCLUSION  (0310):  DOOR  1  ((1.2)  asymptotic,  0293-
  0295/0303-0307)  and  DOOR  2  (the  BG-ANT-ALL
  antecedent)  MEET  EXACTLY  AT  THE  UNIFIED  WALL  {θ  |
  4/7  <  θ}  (machine,  below):  the  published  reach  of
  the  door-2  antecedent  is  4/7  (Conrey,  via  the  same
  (1.2)  family  that  pins  door  1),  so  any  extension  of
  EITHER  door  past  4/7  is  the  SAME  analytic  problem
  (the  unified  wall,  machine-characterized  at  the
  PRZZ  Case-3  o(T)  obstruction,  LevWall/LevWall5-8).
  NO  RH  CLAIM.  -/

namespace LevWall9

/-! ### 1.  The  published  reach  constants  (cited,  machine
    values)
-/
/-- [CITED  -  Levinson,  1949,  as  recorded  in  BG
    2017]:  the  (1.2)  asymptotic  (hence  the  antecedent's
    O_ε(T^{1+ε})  corollary)  is  proven  for  0  <  θ  <
    LEVEL  LEVINSON  REACH.  -/
def bgLevinsonReach : ℚ := 1 / 2

/-- [CITED  -  Conrey,  as  recorded  in  BG  2017]:  "(1.2)
    (with  a  slightly  different  mollifier)  remains  valid
    for  θ  <  LEVEL  CONREY  REACH,  and  thereby  deduced
    that  κ  >  2/5"  —  the  antecedent's  full  published
    reach.  -/
def bgConreyReach : ℚ := 4 / 7

/-- [CITED  -  Conrey,  via  BG  2017]:  the  κ  proportion
    deduced  from  the  4/7  reach  (ladder  datum:  0.4,
    above  Levinson's  0.4-line  and  below  PRZZ  2020's
    0.417293962  and  Kintali  2026's  0.421  selected).  -/
def conreyKappa : ℚ := 2 / 5

/-! ### 2.  The  machine
-/
/-- (PROVEN,  norm_num)  the  published  reach  ladder:  0  <
    1/2  (Levinson)  <  4/7  (Conrey)  <  1.  -/
theorem reachLadder : 0 < bgLevinsonReach ∧ bgLevinsonReach < bgConreyReach ∧ bgConreyReach < 1 := by
  norm_num [bgLevinsonReach, bgConreyReach]

/-- (PROVEN,  rfl)  THE  DOORS  MEET:  the  published  reach
    of  the  door-2  antecedent  (Conrey  4/7,  via  (1.2))
    IS  the  door-1  full-family  wall  (LevWall8.fullWall,
    the  (1.2)  saturation  of  PRZZ  Case  3).  -/
theorem door2ReachIsDoor1Wall : bgConreyReach = LevWall8.fullWall := by
  norm_num [bgConreyReach, LevWall8.fullWall]

/-- (PROVEN,  ext)  the  door-2  RESIDUAL  -  the  set  of  θ
    past  the  antecedent's  published  reach  -  IS  EXACTLY
    the  unified  wall  {θ  |  4/7  <  θ}  (LevWall.levWallGap).
    Door  1  and  door  2  have  the  SAME  open  set.  -/
theorem door2ResidualIsDoor1Wall (θ : ℝ) :
    (bgConreyReach : ℝ) < θ ↔ θ ∈ LevWall.levWallGap := by
  have hreach : (bgConreyReach : ℝ) = 4 / 7 := by
    norm_num [bgConreyReach]
  rw [hreach, LevWall.levWallGap]
  <;> norm_num

/-- (PROVEN,  norm_num)  the  Conrey  ladder  datum  sits
    strictly  between  a  safe  public  floor  and  the  PRZZ
    2020  value  (documented  as  0.417293962;  417/1000  is
    the  safe  in-tree  floor,  0.417  <  0.417293962):
    2/5  <  417/1000  <  0.417293962.  -/
theorem conreyKappaBelowPrzzFloor : conreyKappa < (417 : ℚ) / 1000 := by
  norm_num [conreyKappa]

/-! ### 3.  The  honesty  gap  (named  with  the  real  in-tree
    objects,  not  proven)
-/
/-- [DIAG-RANGE  -  the  NAMED  GAP  -  0310]  the  diagonal  to
    range  bridge  at  fixed  θ:  the  PUBLISHED  (1.2)
    asymptotic  (LevWall.levWallAt  θ  =  asympAt  θ  =
    Tendsto  (fun  T  =>  ThetaInf.thetaIMoment  (T ^ θ)  0  T /
    T)  atTop  (𝓝  (1  +  1/θ));  published  for  0 < θ < 4/7:
    Levinson  to  1/2,  Conrey  to  4/7  per  BG  2017's  own
    citation  record)  IMPLIES  the  RANGE  antecedent  of  BG
    Theorem  1  (ThetaInf.thetaBounded  θ  =  ∀  ε > 0  ∃  C
    T0  ∀  T >= T0  ∀  N,  2 <= N <= T^θ  =>  ThetaInf.
    thetaIMoment  N  0  T  <=  C * T^(1+ε)).  STANDARD
    second-moment  argument  (dyadic  in  N  +  the  small-N
    regime);  NOT  proven  in-tree  and  NOT  recorded  as  a
    theorem  in  BG  2017  itself  -  named  here  so  the  gap
    is  a  first-class  object  of  the  register.  It  does  
    NOT  move  the  published  reach  (4/7):  closing  it  only
    converts  the  diagonal  statement  into  the  range  shape
    at  the  SAME  frontier.  Closing  [DIAG-RANGE]  for  
    θ < 4/7  plus  [BG-T1]  (BG  Theorem  1's  fixed-θ
    implication,  cited  in  ThetaInf)  would  give  a  zero-
    free  half-plane  for  an  explicit  θ < 4/7  -  a  named
    housekeeping  wire  for  0311-plus,  NOT  an  analytic
    gain  past  the  wall.  -/
def diagToRange (θ : ℝ) : Prop :=
    LevWall.levWallAt θ → ThetaInf.thetaBounded θ



end LevWall9
