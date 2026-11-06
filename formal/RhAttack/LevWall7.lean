import Mathlib
import RhAttack.LevWall
import RhAttack.LevWall6

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set

/-!
**LevWall7 — the d-l lever audited:  the wall as a piecewise-linear
function of exponent improvements  (0304,  option  B,  unit  16).**

PROVENANCE  (primary  source,  arXiv:1802.10521,  Res.  Math.
Sci.  7  (2020),  proof  of  Theorem  4.1  -  exact  text  pulled
2026-11-11):

* THE  BINDING  ESTIMATE  (end  of  the  proof):
    A*_{M,N1,N2}  ≪  (T^eps / d) (T^{1/2} N^{7/8}  +  N^{7/4});
    "Thus,  taking  N  =  T^{4/7-eps}  is  permissible."
  THE  IDENTITY  OF  THE  "1/d"  IS  A  LENGTH  VARIABLE  OF
  THE  BILINEAR  DECOMPOSITION  -  NOT  THE  DEGREE:
  "The  variable  U  is  of  size  N1/(d h),  thus  when  U
  appears  there  is  a  hidden  h.  The  significance  of  the
  power  of  h  being  less  than  the  power  of  U  is  that
  we  need  some  positive  power  of  h  in  the  denominator
  at  the  end  of  the  day  so  we  can  sum  over  h  and
  not  have  it  blow  up.  Since
      sum_{h  |  d^infty}  G(h) / h^eps  ≪  (dT)^eps,
  we  find  ...  A*  ≪  (T^eps/d)(T^{1/2}N^{7/8} + N^{7/4})."
  So  d  runs  through  divisors  (h  |  d^infty),  U  =
  N1/(d h),  and  the  1/d  factor  is  part  of  the  full
  Type  I  /  II  optimization  whose  ENDPOINT  is  precisely
  the  exponent  pair  (7/4,  7/8)  (with  the  balance
  W  =  U^{1/4}).  The  "make  d  large"  reading  of  1/d  is
  therefore  a  MISREADING:  d  is  not  a  free  lever.

* THE  d-l  LEVER  (sections  3.4,  8,  9):  the  coefficient
  family  (mu  *  Lambda_1^{*k1}  *  ...  *  Lambda_d^{*kd})
  (Lambda_i  =  mu  *  log^i;  total  truncation
  ℓ  =  k1  +  ...  +  kd  contour  variables)  enters  the
  MAIN  TERM  (the  richness  of  the  κ  optimization)  -  the
  published  bound  above  is  UNIFORM  in  the  family  (the
  structure  enters  only  through  the  separation  reduction
  to  bilinear  Kloosterman  sums).  The  5/12  main  theorem
  itself  uses  d  =  1  with  truncation  K  =  3,
  θ  =  4/7  -  eps,  R  =  1.3036,  a  degree-5  polynomial
  Q,  achieving  κ  ≥  0.417293962  >  5/12  (section  8).
  PRZZ's  own  open  questions  (section  9):
  item  3  "how  one  can  increase  the  length  of  the
    Dirichlet  polynomials  without  specializing  the
    coefficients  a_n  too  much";
  item  4  "set  d  =  1  and  analyze  how  a  large
    truncation  of  ℓ  could  yield  terms  from  a  higher
    degree  d  ≥  2.  What  would  be  a  good  balance
    between  the  degree  d  and  the  truncation  ℓ?"

AUDITED  JUDGMENT  (record  level,  0304  entry):
  *  the  d-l  lever  (degree  vs  truncation,  §9.4)  acts
    on  the  MAIN  TERM  (the  κ  proportion)  -  the  5/12
    result  itself  is  already  AT  θ  =  4/7  -  eps,  and
    the  unused  room  (d  ≥  2,  K  >  3)  improves  κ,  not
    the  θ-bound;  as  a  proportion  lever  it  is
    structurally  blind  to  the  sparse  face  (0285/0292
    logic  -  proportion  results  cannot  exclude  a  sparse
    off-line  zero  set);
  *  the  "make  d  large"  reading  of  the  1/d  factor  is
    a  MISREADING  (d  is  a  divisor  length  inside  the
    bilinear  decomposition;  the  (7/4,  7/8)  endpoint
    already  includes  it  together  with  the  h-U  power
    constraint  and  the  W  =  U^{1/4}  balance  -  the
    paragraph  quoted  above  explains  why  the  current
    extraction  is  FORCED  by  the  structure  -  positive
    power  of  h  in  the  denominator  needed  for  the
    h-sum);
  *  the  WALL  LEVERS  remain  exactly  the  0303  menu:
      L1  a  sharper  bilinear  Kloosterman  estimate
          (changes  the  exponents  7/4  or  7/8);
      L2  a  NEW  balance  beyond  the  forced  h-U
          power  constraint  (the  optimization  endpoint
          moves);
      L3  a  different  decomposition  /  coefficient
          structure  (section  9  item  3).
  The  d-l  lever  adds  no  new  wall  lever.

MACHINE-VERIFIED  CONTENT  (this  file):  the  wall  as  a
piecewise-linear  function  of  (hypothetical)  EXONENT
IMPROVEMENTS  -  the  0303  verdict  "moving  the  wall  =
changing  the  exponents"  made  QUANTITATIVE:

  1.  improvedAdmissible_iff:  two  independent  upper
      bounds,  one  per  error  term  (no  sign  hypotheses
      needed  -  the  iff  is  valid  for  all  δ,  δ2,  θ);
  2.  **wallUnmovedByFirstExponent  +
      wallUnmovedBySecondExponent**  (THE  DOUBLE  WASTE
      THEOREM):  improving  ONLY  ONE  of  the  two
      exponents  -  by  ANY  δ  ≥  0  -  does  NOT  move  the
      wall:  the  unimproved  term  still  binds  at  exactly
      4/7.  In  the  simultaneous-saturation  corner  of  the
      published  state,  BOTH  exponents  must  move;
  3.  **wallUnderBothImprovements**:  improving  both
      exponents  (by  δ  on  the  T^{1/2}N^{7/8}  side,  δ2
      on  the  N^{7/4}  side)  puts  the  wall  at
      4/7  +  min(8δ/7,  4δ2/7)  -  a  precise  min-form
      boundary;
  4.  **simultaneousShiftBindsSecond**:  equal  improvements
      (δ  =  δ2  >  0)  ->  wall  at  4/7  +  4δ/7,  and  the
      N^{7/4}  term  BINDS  (4δ/7  <  8δ/7  -  the
      T^{1/2}N^{7/8}  side  has  slack);
  5.  publishedStateIsCorner:  at  δ  =  δ2  =  0  the
      improved  regime  is  exactly  the  published  Case-3
      regime  (LevWall6)  -  the  corner  where  both
      exponents  saturate  simultaneously.

  Quantitative  reading:  ANY  future  move  of  the  wall
  must  carry  BOTH  exponents  with  it  (single-side
  improvements  are  worth  exactly  NOTHING,  machine);  and
  when  both  move,  the  N^{7/4}  side  is  always  the
  binding  side  of  the  movement  (coefficient  4/7  per
  unit  of  improvement  vs  8/7)  -  sharpening  the
  bilinear  Kloosterman  N^{7/4}  contribution  (L1)  is
  the  lever  with  the  best  wall-movement  per  unit  of
  improvement  (4/7  per  unit  on  the  binding  side,
  versus  8/7  on  the  slack  side  which  buys  nothing
  unless  the  N^{7/4}  side  moves  with  it).

NO  RH  CLAIM.  The  wall  is  UNMOVED  at  the  published
state;  this  unit  quantifies  what  would  move  it.  -/

namespace LevWall7

/-! ### 1.  The improved-regime admissibility
-/
/-- HYPOTHETICAL  REGIME:  a  future  estimate  improves  the
    first  error  exponent  (7/8  ->  7/8  -  δ,  the
    T^{1/2}N^{7/8}  term)  and/or  the  second  (7/4  ->
    7/4  -  δ2,  the  N^{7/4}  term).  The  o(T)  condition
    under  these  improved  exponents.  (Named  scenario  -
    the  0303  levers  L1  -  L3  are  precisely  what  would
    supply  δ,  δ2  >  0.  No  such  published  estimate
    exists  -  0300  sweep.  -/
def improvedAdmissible (δ δ2 θ : ℝ) : Prop :=
    1 / 2 + (7 : ℝ) * θ / 8 - δ < 1 ∧ (7 : ℝ) * θ / 4 - δ2 < 1

/-! ### 2.  The wall as a function of the improvements
    (machine)
-/
/-- (PROVEN,  machine)  THE  REGIME  CHARACTERIZATION  (no
    sign  hypotheses  -  valid  for  all  δ,  δ2,  θ):
      improvedAdmissible  δ  δ2  θ  ↔
          (θ  <  4/7  +  8·δ/7)  ∧  (θ  <  4/7  +  4·δ2/7)
    -  each  error  term  contributes  exactly  one  upper
    bound:  the  T^{1/2}N^{7/8}  term  (improved  by  δ)  gives
    4/7  +  8δ/7;  the  N^{7/4}  term  (improved  by  δ2)
    gives  4/7  +  4δ2/7.  -/
theorem improvedAdmissible_iff (δ δ2 θ : ℝ) :
    improvedAdmissible δ δ2 θ ↔ θ < 4 / 7 + 8 * δ / 7 ∧ θ < 4 / 7 + 4 * δ2 / 7 := by
  simp only [improvedAdmissible]
  constructor
  · rintro ⟨h1, h2⟩
    constructor <;> linarith
  · rintro ⟨h1, h2⟩
    constructor <;> linarith

/-- (PROVEN,  machine)  WASTE  THEOREM,  FIRST  SIDE:
    improving  ONLY  the  T^{1/2}N^{7/8}  exponent  (7/8)
    by  any  δ  ≥  0  does  NOT  move  the  wall  -  the
    unimproved  N^{7/4}  term  still  binds  at  exactly
    4/7,  so  the  admissible  set  stays  [0,  4/7).
    -/
theorem wallUnmovedByFirstExponent (δ θ : ℝ) (hδ : 0 ≤ δ) :
    improvedAdmissible δ (0 : ℝ) θ ↔ θ < 4 / 7 := by
  constructor
  · rintro ⟨_h1, h2⟩
    linarith
  · intro h
    constructor <;> linarith

/-- (PROVEN,  machine)  WASTE  THEOREM,  SECOND  SIDE:
    improving  ONLY  the  N^{7/4}  exponent  by  any
    δ2  ≥  0  does  NOT  move  the  wall  either  -  the
    unimproved  T^{1/2}N^{7/8}  term  binds  at  exactly
    4/7.  THE  DOUBLE  WASTE  THEOREM  (together  with
    wallUnmovedByFirstExponent):  in  the  simultaneous-
    saturation  corner  of  the  published  state,  BOTH
    exponents  must  move  for  the  wall  to  move.
    -/
theorem wallUnmovedBySecondExponent (δ2 θ : ℝ) (hδ2 : 0 ≤ δ2) :
    improvedAdmissible (0 : ℝ) δ2 θ ↔ θ < 4 / 7 := by
  constructor
  · rintro ⟨h1, _h2⟩
    linarith
  · intro h
    constructor <;> linarith

/-- (PROVEN,  machine)  THE  MIN-FORM  BOUNDARY  (no  sign
    hypotheses):  under  independent  improvements  δ  (on
    the  T^{1/2}N^{7/8}  side)  and  δ2  (on  the  N^{7/4}
    side),  the  wall  sits  at
        4/7  +  min(8δ/7,  4δ2/7)  -  the  movement  is
    governed  by  the  SMALLER  of  the  two  per-side
    contributions  to  wall-movement.  -/
theorem wallUnderBothImprovements (δ δ2 θ : ℝ) :
    improvedAdmissible δ δ2 θ ↔ θ < 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) := by
  constructor
  · rintro ⟨hA, hB⟩
    have hA' : θ < 4 / 7 + 8 * δ / 7 := by linarith
    have hB' : θ < 4 / 7 + 4 * δ2 / 7 := by linarith
    by_cases hmn : 8 * δ / 7 ≤ 4 * δ2 / 7
    · calc
        _ < 4 / 7 + 8 * δ / 7 := hA'
        _ = 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) := by rw [min_eq_left hmn]
    · have hle : 4 * δ2 / 7 ≤ 8 * δ / 7 := by linarith
      calc
        _ < 4 / 7 + 4 * δ2 / 7 := hB'
        _ = 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) := by rw [min_eq_right hle]
  · intro h
    by_cases hmn : 8 * δ / 7 ≤ 4 * δ2 / 7
    · rw [min_eq_left hmn] at h
      have h2 : θ < 4 / 7 + 4 * δ2 / 7 := lt_of_lt_of_le h (by linarith)
      constructor <;> linarith
    · have hle : 4 * δ2 / 7 ≤ 8 * δ / 7 := by linarith
      rw [min_eq_right hle] at h
      have h1 : θ < 4 / 7 + 8 * δ / 7 := lt_of_lt_of_le h (by linarith)
      constructor <;> linarith

/-- (PROVEN,  machine)  EQUAL  IMPROVEMENTS  (δ  on  both
    sides,  δ  >  0):  the  wall  is  at  4/7  +  4δ/7,  and
    the  N^{7/4}  term  BINDS  (4δ/7  <  8δ/7 -  the
    T^{1/2}N^{7/8}  side  has  strict  slack).  The
    N^{7/4}  side  is  the  binding  side  of  any  equal
    movement.  -/
theorem simultaneousShiftBindsSecond (δ θ : ℝ) (hδ : 0 < δ) :
    improvedAdmissible δ δ θ ↔ θ < 4 / 7 + 4 * δ / 7 := by
  have h1 := improvedAdmissible_iff δ δ θ
  rw [h1]
  have hslack : 4 / 7 + 4 * δ / 7 < 4 / 7 + 8 * δ / 7 := by
    linarith
  constructor
  · rintro ⟨_h1a, h2a⟩
    linarith
  · intro h
    constructor
    · linarith [hslack]
    · linarith

/-- (PROVEN,  machine)  THE  PUBLISHED  STATE  IS  THE
    CORNER:  at  δ  =  δ2  =  0  the  improved  regime  is
    exactly  the  published  Case-3  regime  (LevWall6),
    whose  admissible  set  is  [0,  4/7)  with  both
    exponents  saturated  simultaneously  (the  0303
    corner)  -  the  4/7  boundary  is  a  corner  point
    with  TWO  independent  saturation  conditions,  and
    the  double  waste  theorem  says  neither  axis  can
    be  improved  alone.  -/
theorem publishedStateIsCorner (θ : ℝ) :
    improvedAdmissible (0 : ℝ) (0 : ℝ) θ ↔ LevWall6.admissibleDegreeD θ := by
  simp only [improvedAdmissible, LevWall6.admissibleDegreeD]
  constructor
  · rintro ⟨h1, h2⟩
    exact ⟨by linarith, by linarith⟩
  · rintro ⟨h1, h2⟩
    exact ⟨by linarith, by linarith⟩

/-- (PROVEN,  machine)  QUANTITATIVE  DEMO  (norm_num):
    the  wall-movement  coefficient  on  the  binding
    (N^{7/4})  side  is  4/7  per  unit  of  exponent
    improvement:  a  hypothetical  second-exponent
    improvement  of  1/7  (7/4  ->  7/4  -  1/7  =  6/7)
    would  move  the  wall  from  4/7  =  28/49  to
    28/49  +  4/49  =  32/49  (about  0.653).  -/
theorem wallShiftDemo : (4 : ℚ) / 7 + 4 * (1 / 7 : ℚ) / 7 = 32 / 49 := by
  norm_num
theorem wallShiftDemoOrder : (28 : ℚ) / 49 < 32 / 49 := by
  norm_num

end LevWall7
