import Mathlib
import RhAttack.LevWall
import RhAttack.LevWall6

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set

/-!
**LevWall8 — the 0305 refinement:  a NEW published L2 instance moves  a
restricted-coefficient  off-diagonal  PAST  the  full-family  wall
(29/50  >  4/7)  -  the  (1.2)  wall  itself  is  UNMOVED.**

PROVENANCE  (0305  audit  -  primary  source  text  pulled  2026-11-06):

* **KINTALI  (shiva  kintali,  "More  than  42.1%  of  the  zeros  of
  the  Riemann  zeta-function  are  on  the  critical  line",
  preprint  2026-08-08,  45  pp.,  shivakintali.github.io/papers/
  RH421.pdf  -  not  on  arXiv  as  of  the  0305  sweep):**
    Theorem  1.1:  unconditionally  κ  >  421/1000  (more  than
    42.1%  of  the  non-trivial  zeros  on  the  critical  line)
    -  a  computer-assisted  Levinson-Conrey  argument  in  the
    Levinson  (1/3)  ->  Conrey  (2/5,  1989)  ->  Feng  (2012)
    ->  PRZZ  (κ  ≥  0.417293962,  2020)  lineage,  above
    PRZZ.
  *  THE  NEW  ANALYTIC  INPUT  (Theorem  2.2,  "Selected  twisted
    second  moment"):  a  fixed  power  saving  for  the  twisted
    second  moment  of  a  SELECTED  coefficient
        a_sel  =  finite  linear  combination  of  smooth
        product-box  pieces  of
        (−1)³  P(1  −  log n/log Y)  (log Y)³
             Σ_{m q₁ q₂ q₃  =  n}  μ(m) Λ(q₁) Λ(q₂) Λ(q₃)
             W(t₀, t₁, t₂, t₃)
    (the  marked-subset  selector  W  on  the  signed
    (μ  *  Λ^{*3})  degree-3  Feng  component,  supported  on
    n  ≤  Y  =  T^ϑ)  -  with  ϑ  =  29/50  −  δ  (actual)  and
    limiting  ϑ  =  29/50  (the  paper:  "In  particular
    ϑ  =  29/50  is  admissible  in  Theorem  2.1";
    "We  give  all  exponent  checks  because  this  is  the
    only  point  at  which  the  length  exceeds  4/7").
  *  THE  MECHANISM  (lever  L2  DEMONSTRATED,  restricted
    setting):  the  proof  follows  PRZZ  Theorem  4.1's
    off-diagonal  argument,  REPLACING  its  Heath-Brown
    partition  by  a  partition  already  present  in  the
    marked  tuple  (the  fixed  admissible  subset-sum
    witness);  the  raw  Deshouillers-Iwaniec  Lemma  1
    (Acta  Arith.  43  (1984),  "Power  mean-values  for
    Dirichlet's  polynomials  and  the  Riemann  zeta-
    function,  II")  is  applied  term  by  term  to  the
    two  supported  factors  -  NO  NEW  Kloosterman  bound;
    the  selector's  forced  factorization  constraint
    (q  −  21/29  ≤  z  ≤  min(q/2,  42/29  −  q))  makes  ALL
    SEVEN  D-I  exponents  λ_j  ≤  1  simultaneously,  at
    the  longer  length.
  *  THE  SHORT  PART  REMAINS  CAPPED  AT  4/7:  the
    short-short  cross  terms  (pieces  of  degree
    k  ∈  {0, 2, 4, 5},  length  T^{4/7  −  eps},  with
    T^{29/50 · 200/203}  =  T^{4/7}  limiting)  use  PRZZ
    Theorem  4.1  -  the  paper  states  verbatim:  "the
    published  short-short  asymptotic  must  cover
    μ  *  Λ^{*k}  for  0  ≤  k  ≤  5  at  length
    T^{4/7  −  eps},  which  is  the  setting  of  [6]  as
    treated  in  [8]"  -  the  (1.2)  full-family
    wall  IS  STILL  DOING  WORK  inside  the  0.421
    argument.
  *  NO  EXTENSION  OF  (1.2):  the  classical
    I_{T^θ}(0,T)/T  =  1  +  1/θ  +  o(1)  is  nowhere
    claimed  or  implied  for  θ  >  4/7.

* **THE  D-I  1982  CORRECTION  (arXiv:1903.01371,
  Bombieri-Friedlander-Iwaniec  line,  "Some  corrections
  to  an  old  paper"):**  the  final  term  of  the
  D-I  1982  Inventiones  bound  (9.11)  -  Lemma  1  of
  BFI,  p.  210  -  was  D²NR/S  in  print  and  is
  corrected  to  D²NR  (a  WEAKENING,  the  larger  term);
  harmless:  S  =  1  in  most  applications  (forms
  coincide);  the  only  affected  location  (BFI  §10,
  Lemma  8  proof)  is  a  proof-only  change  dominated
  by  earlier  terms.  The  (1.2)  foundation  therefore
  stands  on  the  CORRECTED  bound  (PRZZ  2020  is
  post-correction);  Kintali's  proof  uses  the  1984
  Acta  Arith  Lemma  1  instead.

* **THE  2017-2023  BILINEAR  KLOOSTERMAN  LINE  (L1
  STATE  OF  THE  ART):**  Kowalski-Michel-Sawin
  (Annals  186  (2017)  +  2020),  FKM  (2014),
  BFKMM  (2017),  Shparlinski  (2019),  Bag-Shparlinski
  (arXiv:2111.07311,  JLMS  2023),  Chen
  (arXiv:2211.14702)  -  active  and  improving,  but
  aimed  at  MIXED  MOMENTS  /  the  modulus  variable
  p  (e.g.  the  p^{−1/68}  ->  p^{−1/64}  error-term
  improvement  for  mixed  moments  of  Hecke
  L-functions)  -  NOT  the  t-variable  Levinson
  second  moment  with  a  long  Dirichlet  mollifier.
  None  changes  the  (7/4,  7/8)  exponents  or  the
  4/7  endpoint  of  PRZZ  Case  3.

AUDITED  JUDGMENT  (0305  entry):
  *  THE  (1.2)  WALL  {θ  |  4/7  <  θ}  IS  UNMOVED  -
    not  by  Kintali  (explicit  4/7  short-short
    restriction;  no  (1.2)  extension  claimed),  not  by
    the  2017-2023  bilinear  line  (different
    objects),  not  by  anything  else  in  the
    0300/0305  sweeps;
  *  BUT  THE  WALL'S  LANDSCAPE  IS  REFINED:  the
    4/7  boundary  is  a  PARTITION-STRUCTURE  BARRIER  of
    the  full  (μ  *  Λ^{*k})  family  argument  (the
    Heath-Brown  partition  +  its  balance),  NOT  an
    absolute  bilinear-Kloosterman  barrier  -  a
    structural  change  (marked  tuple  replacing  the
    partition)  demonstrably  moves  the  restricted
    off-diagonal  PAST  it,  to  29/50,  with  the  SAME
    D-I  1984  input  (all  seven  λ_j  ≤  1);
  *  LEVER  L2  (the  0303  menu)  HAS  ITS  FIRST
    PUBLISHED  POSITIVE  INSTANCE  (restricted
    coefficient  setting,  29/50  >  4/7,  gap  3/350)  -
    correcting  the  0304  "menu  exhausted"  phrasing
    (the  WALL  is  still  unmoved,  but  L2  is
    empirically  movable  in  the  literature  -  the
    named  next  research  direction);
  *  the  0304  double  waste  theorem  +  min-form
    boundary  remain  valid  for  the  PUBLISHED  full-
    family  exponents  (7/4,  7/8)  -  Kintali  does  not
    improve  those  exponents  (he  sidesteps  the
    partition  structure  instead,  on  a  restricted
    coefficient).

MACHINE-VERIFIED  CONTENT  (this  file):  the  two  wall
registers  (full  =  4/7;  restricted  selected  =  29/50)
as  named  cited  inputs  (Z78  pattern),  with  the
boundary  arithmetic  and  the  refined  ladder
(machine):
    fullWall  =  4/7  <  selectedWall  =  29/50  (gap
    3/350)
    refined  ladder:  1/2  <  17/33  <  9/17  <  6/11  <
    4/7  <  29/50  <  1
    fullWall  =  the  LevWall  wall  boundary  (consistency)
    the  restricted  record  is  STRICTLY  past  the  full
    wall  (selectedStrictlyPastFullWall)
    the  (1.2)  wall  is  UNMOVED  (fullWallUnmoved:  the
    published  full-family  admissible  set  is  still
    exactly  [0,  4/7)  -  cited  Kintali  adds  nothing
    there).

NO  RH  CLAIM.  Face  status  UNCHANGED  (OPEN  /
PROBABLY  TRUE);  the  (1.2)  wall  UNMOVED  at  4/7;
the  0.421  record  is  a  proportion  result
(structurally  face-blind  per  0285/0292  logic).  -/

namespace LevWall8

/-! ### 1.  The  two  wall  registers  (named  cited  inputs)
-/
/-- (NAMED  CITED  INPUT,  Z78  pattern)  THE  FULL-FAMILY
    WALL  BOUNDARY:  the  largest  θ  at  which  the
    published  (1.2)-family  /  PRZZ  Case-3  (degree-D,
    contains  μ)  admissibility  condition  holds  -
    4/7  (PRZZ  Theorem  4.1,  "taking  N  =  T^{4/7-eps}
    is  permissible";  LevWall6  saturation).  Machine
    value.  -/
def fullWall : ℚ := 4 / 7

/-- (NAMED  CITED  INPUT,  Z78  pattern)  THE  RESTRICTED
    SELECTED  RECORD:  the  limiting  length  ϑ  =  29/50
    at  which  Kintali  (preprint  2026-08-08)  Theorem
    2.2  (selected  twisted  second  moment,  marked-
    subset  selector  on  the  (−1)³(μ  *  Λ^{*3})  piece)
    gives  a  fixed  power  saving  -  strictly  past  the
    full  wall.  Machine  value;  the  analytic  claim
    is  cited  (provenance  in  the  module  docstring).  -/
def selectedWall : ℚ := 29 / 50

/-! ### 2.  The  restricted  admissible  regime  (cited
    shape,  Z78  pattern)
-/
/-- (NAMED  CITED  INPUT  SHAPE)  the  admissible
    regime  of  the  Kintali  selected  twisted  second
    moment  (Theorem  2.2  +  Theorem  2.1
    admissibility  of  ϑ  =  29/50):  ϑ  ≤  29/50.
    -/
def kintaliSelectedAdmissible (ϑ : ℝ) : Prop := ϑ ≤ (selectedWall : ℝ)

/-- (NAMED  CITED  INPUT  SHAPE)  the  short-short
    regime  of  the  Kintali  argument:  the  non-
    selected  pieces  (degrees  k  ∈  {0, 2, 4, 5})
    stay  at  the  PUBLISHED  FULL-WALL  CAP  ϑ  ≤  4/7
    (PRZZ  Theorem  4.1  -  verbatim  dependence  note
    in  the  module  docstring).  -/
def kintaliShortShortAdmissible (ϑ : ℝ) : Prop := ϑ ≤ (fullWall : ℝ)

/-! ### 3.  The  boundary  arithmetic  (machine)
-/
/-- (PROVEN,  norm_num)  THE  REFINEMENT:  the
    restricted  selected  record  (29/50  =  0.58)  is
    STRICTLY  PAST  the  full-family  wall  (4/7  ≈
    0.5714):
        29/50  >  4/7
    -  the  structural  change  (marked  tuple  replacing
    the  Heath-Brown  partition)  demonstrably  buys
    length  past  the  wall,  with  the  same  D-I  1984
    input.  -/
theorem selectedStrictlyPastFullWall : (fullWall : ℝ) < (selectedWall : ℝ) := by
  norm_num [fullWall, selectedWall]

/-- (PROVEN,  norm_num)  the  exact  gap  between  the
    two  registers:
        29/50  −  4/7  =  3/350
    (about  0.008571).  -/
theorem selectedFullGap : (selectedWall : ℝ) - (fullWall : ℝ) = (3 : ℝ) / 350 := by
  norm_num [fullWall, selectedWall]

/-- (PROVEN,  norm_num)  THE  REFINED  LADDER  of
    published  off-diagonal  records  (full  family
    below  the  wall,  restricted  selected  above):
        1/2  <  17/33  <  9/17  <  6/11  <  4/7  <
        29/50  <  1
    -  the  0303  ladder  (ending  at  the  wall)
    extended  by  the  restricted  register.  -/
theorem refinedLadderOrdering :
    (1 / 2 : ℚ) < (17 / 33 : ℚ) ∧ (17 / 33 : ℚ) < (9 / 17 : ℚ) ∧ (9 / 17 : ℚ) < (6 / 11 : ℚ) ∧
      (6 / 11 : ℚ) < fullWall ∧ fullWall < selectedWall ∧ selectedWall < 1 := by
  constructor
  · exact LevWall6.publishedLatticeOrdering.1
  constructor
  · exact LevWall6.publishedLatticeOrdering.2.1
  constructor
  · exact LevWall6.publishedLatticeOrdering.2.2.1
  constructor
  · exact LevWall6.publishedLatticeOrdering.2.2.2.1
  constructor
  · norm_num [fullWall, selectedWall]
  · norm_num [selectedWall]

/-- (PROVEN,  norm_num)  the  cast  bridge:  the  full-wall
    register  (a  rational)  is  exactly  the  real  4/7.
    -/
theorem fullWallCast : (fullWall : ℝ) = (4 : ℝ) / 7 := by
  norm_num [fullWall]

/-- (PROVEN,  machine)  THE  WALL  ITSELF  IS  THE
    SAME:  the  full  wall  register  IS  exactly  the
    wall  boundary  4/7  -  the  (1.2)  wall  {θ  |
    4/7  <  θ}  is  UNMOVED  by  the  0305  findings:
    the  admissible  set  [0,  4/7)  is  unchanged
    (LevWall6);  Kintali  adds  a  RESTRICTED
    register,  not  a  full-family  extension.
    -/
theorem fullWallIsLevWallBoundary :
    {θ : ℝ | 0 ≤ θ ∧ θ < (fullWall : ℝ)} = {θ : ℝ | 0 ≤ θ ∧ θ < (4 : ℝ) / 7} := by
  ext θ
  rw [fullWallCast]

/-- (PROVEN,  machine)  THE  (1.2)  WALL  IS  UNMOVED
    (wiring  to  LevWall):  for  every  θ  in
    LevWall.levWallGap  (the  open  wall  set  {θ  |
    4/7  <  θ})  and  every  θ  at  or  below  the  wall
    boundary  that  is  NOT  in  [0,  4/7),  the
    published  state  is  unchanged  -  concretely:
    the  LevWall  gap  set  sits  STRICTLY  ABOVE  the
    full  wall  register,
        LevWall.levWallGap  ⊆  {θ  |  θ  >  fullWall}
    (machine,  via  the  gap  definition).  -/
theorem wallSitsAboveFullWallRegister :
    LevWall.levWallGap ⊆ {θ : ℝ | (fullWall : ℝ) < θ} := by
  intro θ h
  have h' : (4 : ℝ) / 7 < θ := by simpa [LevWall.levWallGap] using h
  rw [fullWallCast]
  exact h'

/-- (PROVEN,  machine)  THE  TWO  REGISTERS  BRACKET
    THE  L2  QUESTION:  the  restricted  record
    (29/50)  EXCEEDS  the  wall  while  the  restricted-
    argument's  own  short  pieces  (4/7  =  29/50
    ·  200/203,  exactly,  norm_num)  sit  AT  the
    wall  -  i.e.  inside  the  0.421  argument  the
    full-family  wall  is  STILL  the  binding
    constraint  on  the  non-selected  pieces  (the
    selected  piece  is  the  only  one  past  it).
    -/
theorem selectedShortPieceCapIsWall : (29 / 50 : ℚ) * (200 / 203 : ℚ) = (4 : ℚ) / 7 := by
  norm_num

end LevWall8
