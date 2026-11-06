import Mathlib
import RhAttack.LevWall
import RhAttack.LevWall2

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set

/-!
**LevWall6 — the 4/7 WALL'S EXACT PUBLISHED OBSTRUCTION
(0303, option B, unit 15:  the degree/truncation ladder pinned
from the primary source  PRZZ).**

PROVENANCE (primary source, pulled 2026-11-11,  arXiv:1802.10521
html;  Pratt,  Robles,  Zaharescu,  Zeindler,  "More than
five-twelfths of the zeros of  ζ  are  on  the  critical  line",
Res.  Math.  Sci.  7  (2020)):

* THE MAIN MOMENT THEOREM  (Theorem  4.1,  section  4):
  the twisted second moment
      I(α, β)  =  ∫ ζ(1/2+α+it) ζ(1/2+β+it)
                  |Σ_{d≤N} a_d d^{-(1/2+it)}|² Φ(t/T) dt
  for  N  =  T^θ,  θ  <  1,  α, β  ≪ L^-1,  is computed
  unconditionally with an explicit main term plus an error
   E  whose  size  depends  on  the  COEFFICIENT
  REGIME:
      Case  1  (arbitrary  a_n  ≪ n^eps):
          E  =  T^{3/20} N^{33/20}  +  N^{1/2} T^{1/2+eps};
      Case  2  (a_n  =  mu²(n)(mu * Λ₁^{*k₁} * ... *
          Λ_D^{*k_D})(n)):
          E  =  T^eps (N^{11/6}  +  N^{11/12} T^{1/2});
      Case  3  (a_n  =  (mu * Λ₁^{*k₁} * ...  * Λ_D^{*k_D})(n))  -
          the  DEGREE-D  family,  which  CONTAINS  the
          classical Levinson coefficients  mu(n)  (D  =  0):
          E  =  T^eps (N^{7/4}  +  N^{7/8} T^{1/2});
          the proof states verbatim:  "Thus,  taking
          N  =  T^{4/7-eps}  is  permissible."
  ERROR STRUCTURE (the proof of  Theorem  4.1):  the error
  splits into  Type  I  (summation by  parts  +  the  Weil
  bound for incomplete Kloosterman sums)  and  Type  II
  (bilinear  Kloosterman  sums,  Deshouillers-Iwaniec
  Lemma  1),  balanced  at  W  =  U^{1/4};  the  final
  combined  bound  carries  the  exponents  7/4  (Case  3)
  or  33/20  (Case  1)  -  BILINEAR  KLOOSTERMAN  SUM
  estimates  are  the  source  of  the  exponents  itself.
  (Case  1's  ingredient  per  the  paper:  Bettin,
  Chandee  and  Radziwill  on  trilinear  Kloosterman
  sums  -  an  improvement  of  Duke-Friedlander-Iwaniec
  due  to  Bettin  and  Chandee.)
* THE DEGREE-2 / B-C-H-B ENTRY  (section  1.3,  verbatim):
  "Balasubramanian,  Conrey  and  Heath-Brown  examined
  the  error  terms  from  the  mean  value  integral  in
  (1.2)  and  the  resulting  exponential  sums.  In
  particular  they  showed  using  Vaughan's  identity  on
  1/ζ(s)  and  Weil's  bound  for  Kloosterman  sums  that
  one  could  push  the  size  of  the  length  theta  past
  the  1/2  barrier  to  9/17  when  the  coefficients  are
  given  by  (1.3)"  with
      (1.3)  b_C(n, y)  =  μ(n) n^{σ₀ − 1/2}
                 P( log(y/n) / log y ),
  P  an  explicit  polynomial  (P(0)  =  0,  P(1)  =  1).
* THE OPEN QUESTION  (PRZZ  section  9,  item  4,
  verbatim):  "Moreover,  it  would  also  be  interesting
  to  set  d  =  1  and  analyze  how  a  large
  truncation  of  ℓ  could  yield  terms  from  a  higher
  degree  d  ≥  2.  What  would  be  a  good  balance
  between  the  degree  d  and  the  truncation  ℓ?"

MACHINE-VERIFIED CONTENT (this  file,  no  RH  claim):
  1.  the  EXACT  OBSTRUCTION  ARITHMETIC  -  each
      regime's  published  error  exponents  SATURATE  at
      its  published  frontier  (norm_num):
          Case  3  at  4/7:   (7/4)(4/7)  =  1  and
                              (7/8)(4/7) + 1/2  =  1  (BOTH);
          Case  2  at  6/11:  (11/6)(6/11)  =  1  and
                              (11/12)(6/11) + 1/2  =  1;
          Case  1  at  17/33: (33/20)(17/33) + 3/20  =  1.
  2.  the  ADMISSIBILITY  IFF  (for  θ  ≥  0):
          admissibleGeneric  θ  ↔  θ  <  17/33   (Case  1);
          admissibleMu2      θ  ↔  θ  <  6/11    (Case  2);
          admissibleDegreeD  θ  ↔  θ  <  4/7     (Case  3).
  3.  WALL  =  OBSTRUCTION  COMPLEMENT  (machine):
      `LevWall.levWallGap`  =  {θ  |  4/7  <  θ}  =  the
      open  set  of  θ  for  which  Case-3's  o(T)
      condition  (with  its  published  exponents)  fails;
      and  θ  =  4/7  itself  is  a  boundary  point  of
      the  failure  (both  exponents  =  1,  the  T^eps
      residue  leaves  T·T^eps  =  T^{1+eps},  not  o(T)).
  4.  the  COMPLETE  LADDER  ORDERING  (machine):
          1/2  <  17/33  <  9/17  <  6/11  <  4/7  <  1,
      the  full  published-reach  ladder  at  the  (1.2)
      level  (generic  1/2  [B-C-H-B  1985]  →  17/33
      [PRZZ  Case  1  /  B-C-R  trilinear  input]  →  9/17
      [B-C-H-B  (1.3)  coefficients  /  Vaughan+Weil]  →
      6/11  [PRZZ  Case  2  =  the  2017  Feng-variant
      extension  1706.04593]  →  4/7  [PRZZ  Case  3  =
      the  Conrey-variant  boundary  per  0293]).

RECORD-LEVEL AUDIT (0280  pattern,  in  the  0303  entry):
  *  the  WALL  {θ  |  4/7  <  θ}  is  now  a  machine-
    characterized  SATURATION  of  the  exact  published
    error  term  -  not  merely  a  named  frontier:
    every  θ  in  the  wall  is  precisely  a  θ  for
    which  the  published  Case-3  o(T)  condition
    fails  with  the  published  exponents.
  *  MOVING  THE  WALL  requires  changing  the  exponents
    7/4  or  7/8  themselves  -  i.e.  a  sharper  BILINEAR
    KLOOSTERMAN  SUM  estimate  (Type  II,
    Deshouillers-Iwaniec  Lemma  1),  or  a  better
    balance  W  ≠  U^{1/4},  or  a  different
    Type  I  /  II  decomposition  -  none  of  which  is
    in  the  published  record  as  of  the  0300  sweep.
  *  the  GENUINE  OPEN  LEVER  is  PRZZ's  own  open
    question  (quoted  above):  the  degree  d  vs
    truncation  ℓ  balance  -  recorded  as  the  named
    next  lever  (the  d  = 1  /  large-ℓ  question).

NO  RH  CLAIM.  The  wall  is  unchanged  -  it  is
now  Pinned  at  its  exact  published  obstruction.  -/

namespace LevWall6

/-! ### 1.  The published error exponents' admissibility
-/
/-- Case  3  admissibility  (the  published  exponents
    7/4  and  7/8  at  N  =  T^theta):  both  error
    terms  are  o(T).  -/
def admissibleDegreeD (θ : ℝ) : Prop :=
    (7 : ℝ) * θ / 4 < 1 ∧ (7 : ℝ) * θ / 8 + 1 / 2 < 1

/-- Case  1  admissibility  (the  published  exponents
    3/20  +  33/20  and  (1/2,  1/2)):  both  error
    terms  are  o(T).  -/
def admissibleGeneric (θ : ℝ) : Prop :=
    (33 : ℝ) * θ / 20 + 3 / 20 < 1 ∧ (θ : ℝ) / 2 + 1 / 2 < 1

/-- Case  2  admissibility  (the  published  exponents
    11/6  and  11/12  +  1/2):  both  error  terms  are
    o(T).  -/
def admissibleMu2 (θ : ℝ) : Prop :=
    (11 : ℝ) * θ / 6 < 1 ∧ (11 : ℝ) * θ / 12 + 1 / 2 < 1

/-! ### 2.  Named cited inputs (Z78 pattern)
-/
/-- [PRZZ-4.1-DEGREE-D]  (named cited input  -  PRZZ
    Theorem  4.1,  Case  3,  Res.  Math.  Sci.  7  (2020)):
    for the  DEGREE-D  coefficient  family
    (mu  *  Λ₁^{*k₁}  *  ...  *  Λ_D^{*k_D})(n)  -  which
    contains the  classical  Levinson  coefficients
    mu(n)  (D  =  0)  -  the  twisted  second  moment
    asymptotic  holds  unconditionally  with  error
    T^eps (N^{7/4}  +  N^{7/8} T^{1/2})  =  o(T)  for
    exactly  the  admissible  θ  (machine:  θ  <  4/7,
    below).  The  published  proof  states  verbatim:
    "Thus,  taking  N  =  T^{4/7-eps}  is  permissible."
    Cited,  not  proven  in-tree.  -/
def przzDegreeD (θ : ℝ) : Prop :=
    admissibleDegreeD θ

/-- [PRZZ-4.1-GENERIC]  (named cited input  -  PRZZ
    Theorem  4.1,  Case  1):  for  ARBITRARY  coefficients
    a(n)  ≪  n^eps  the  same  asymptotic  holds  with
    error  T^{3/20} N^{33/20}  +  N^{1/2} T^{1/2+eps}
    =  o(T)  for  exactly  the  admissible  θ  (machine:
    θ  <  17/33).  The  ingredient  (primary  source):
    Bettin-Chandee-Radziwill,  the  trilinear  Kloosterman
    sum  (improvement  of  Duke-Friedlander-Iwaniec  via
    Bettin-Chandee).  The  classical  B-C-H-B  (1985)
    reach  1/2  is  its  1985  form.  Cited,  not  proven
    in-tree.  -/
def przzGeneric (θ : ℝ) : Prop :=
    admissibleGeneric θ

/-! ### 3.  The exact saturation arithmetic (machine)
-/
/-- (PROVEN,  machine)  Case  3  SATURATES  at  4/7  -
    first  exponent:  (7/4) · (4/7)  =  1  (the  N^{7/4}
    term  becomes  T^1  exactly).  -/
theorem saturationDegreeD_first : ((7 : ℚ) * (4 / 7) / 4 : ℚ) = 1 := by
  norm_num

/-- (PROVEN,  machine)  Case  3  SATURATES  at  4/7  -
    second  exponent:  (7/8) · (4/7)  +  1/2  =  1  (the
    N^{7/8} T^{1/2}  term  becomes  T^1  exactly  SIMULTANEOUSLY).
    The  wall's  boundary  is  a  simultaneous saturation
    of  the  two  bilinear  exponents.  -/
theorem saturationDegreeD_second : ((7 : ℚ) * (4 / 7) / 8 + 1 / 2 : ℚ) = 1 := by
  norm_num

/-- (PROVEN,  machine)  Case  2  saturates  at  6/11
    (both  exponents  =  1  simultaneously).  -/
theorem saturationMu2_first : ((11 : ℚ) * (6 / 11) / 6 : ℚ) = 1 := by
  norm_num
theorem saturationMu2_second : ((11 : ℚ) * (6 / 11) / 12 + 1 / 2 : ℚ) = 1 := by
  norm_num

/-- (PROVEN,  machine)  Case  1  saturates  at  17/33
    (the  trilinear  Kloosterman  exponent  =  1  exactly;
    the  second  term  is  slack  there).  -/
theorem saturationGeneric : ((33 : ℚ) * (17 / 33) / 20 + 3 / 20 : ℚ) = 1 := by
  norm_num
theorem slackGenericSecond : ((17 / 33 : ℚ) / 2 + 1 / 2 : ℚ) < 1 := by
  norm_num

/-! ### 4.  The admissibility IFFs (machine,  θ ≥ 0)
-/
/-- (PROVEN,  machine)  Case  3  is  admissible  iff
    θ  <  4/7  (for  θ  ≥  0)  -  the  two  published
    exponent  conditions  are  SIMULTANEOUSLY  SATISFIED
    IFF  θ  <  4/7.  -/
theorem admissibleDegreeD_iff47 (θ : ℝ) (_hθ : 0 ≤ θ) :
    admissibleDegreeD θ ↔ θ < 4 / 7 := by
  constructor
  · rintro ⟨h1, _h2⟩
    linarith
  · intro h
    constructor <;> linarith

/-- (PROVEN,  machine)  Case  1  is  admissible  iff
    θ  <  17/33  (for  θ  ≥  0).  -/
theorem admissibleGeneric_iff1733 (θ : ℝ) (_hθ : 0 ≤ θ) :
    admissibleGeneric θ ↔ θ < 17 / 33 := by
  constructor
  · rintro ⟨h1, _h2⟩
    linarith
  · intro h
    constructor <;> linarith

/-- (PROVEN,  machine)  Case  2  is  admissible  iff
    θ  <  6/11  (for  θ  ≥  0).  -/
theorem admissibleMu2_iff611 (θ : ℝ) (_hθ : 0 ≤ θ) :
    admissibleMu2 θ ↔ θ < 6 / 11 := by
  constructor
  · rintro ⟨h1, _h2⟩
    linarith
  · intro h
    constructor <;> linarith

/-! ### 5.  The wall = the obstruction's open complement
    (machine)
-/
/-- (PROVEN,  machine)  THE  WALL  CHARACTERIZATION:
    every  θ  in  the  unified  wall  `LevWall.levWallGap`
    (  =  {θ  |  4/7  <  θ})  is  precisely  a  θ  for
    which  the  published  Case-3  o(T)  condition
    (with  its  published  exponents)  FAILS.  -/
theorem wallGapFailsObstruction (θ : ℝ) (h : θ ∈ LevWall.levWallGap) :
    ¬ admissibleDegreeD θ := by
  have hgt : (4 / 7 : ℝ) < θ := by
    simpa [LevWall.levWallGap] using h
  by_contra hAd
  have hlt : θ < 4 / 7 := (admissibleDegreeD_iff47 θ (by linarith [hgt])).mp hAd
  linarith [hgt]

/-- (PROVEN,  machine)  the  boundary  point  θ  =  4/7
    itself  FAILS  the  o(T)  condition  (both  exponents
    =  1:  the  T^eps  residue  leaves  T · T^eps  =
    T^{1+eps},  not  o(T))  -  the  published  proof's
    "taking  N  =  T^{4/7-eps}  is  permissible"  is
    sharp  at  the  boundary.  -/
theorem boundary47Fails : ¬ admissibleDegreeD (4 / 7 : ℝ) := by
  simp only [admissibleDegreeD]
  intro h
  have h1 : (7 : ℝ) * (4 / 7) / 4 < 1 := h.1
  have hsat : (7 : ℝ) * (4 / 7) / 4 = (1 : ℝ) := by
    norm_num
  linarith [hsat]

/-- (PROVEN,  machine)  CONVERSE:  the  admissible  set
    (Case  3)  for  θ  ≥  0  is  exactly  [0, 4/7)  -
    the  published  reach  IS  the  wall's  complement
    interior  (machine  closure  of  the  characterization).  -/
theorem admissibleSetIsHalfline :
    { θ : ℝ | 0 ≤ θ ∧ admissibleDegreeD θ } =
      { θ : ℝ | 0 ≤ θ ∧ θ < (4 / 7 : ℝ) } := by
  ext θ
  constructor
  · rintro ⟨h0, ha⟩
    exact ⟨h0, (admissibleDegreeD_iff47 θ h0).mp ha⟩
  · rintro ⟨h0, hlt⟩
    exact ⟨h0, (admissibleDegreeD_iff47 θ h0).mpr hlt⟩

/-- (PROVEN,  machine)  the  COMPLETE  LADDER  ORDERING:
        1/2  (B-C-H-B  1985,  generic)  <
        17/33  (PRZZ  Case  1,  generic  /  B-C-R)  <
        9/17  (B-C-H-B  (1.3)  coefficients,  degree-2)  <
        6/11  (PRZZ  Case  2  =  2017  Feng-variant
              1706.04593)  <
        4/7  (PRZZ  Case  3  =  the  Conrey-variant
              boundary  per  0293  =  the  wall)  <  1.
    The  0300  lattice  refinement  at  the  (1.2)  level
    (machine).  -/
theorem publishedLatticeOrdering :
    (1 / 2 : ℚ) < 17 / 33 ∧
      17 / 33 < (9 : ℚ) / 17 ∧
      (9 : ℚ) / 17 < 6 / 11 ∧
      (6 : ℚ) / 11 < 4 / 7 ∧
      (4 : ℚ) / 7 < 1 := by
  norm_num

/-- (PROVEN,  machine)  the  0294  ladder  facts  are
    SPECIAL CASES  of  the  0303  ladder  (consistency
    cross-reference  with  `LevWall2.publishedLandscape`).  -/
theorem ladderExtendsLevWall2 :
    (1 / 2 : ℚ) < 9 / 17 ∧ (9 / 17 : ℚ) < 4 / 7 ∧ (4 / 7 : ℚ) < 1 :=
  LevWall2.publishedLandscape

end LevWall6
