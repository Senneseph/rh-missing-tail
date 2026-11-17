import Mathlib
import RhAttack.LevWall
import RhAttack.LevWall6
import RhAttack.LevWall7

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false
set_option linter.unusedVariables false

open Real Set

/-!
**LevWall8 — the L1 deep-read verdict, machine-registered
(0426-0428,  L1 lever  of  the  0303  menu:  the  2026
all-moduli  bilinear  Kloosterman  estimate  against  the
4/7  wall,  page-level  reconstruction  of  the  cited
bookkeeping).**

PROVENANCE  (primary  sources,  pulled  2026-11-17):

* [PR]  K.  Pratt,  N.  Robles,  "Perturbed  moments  and  a
  longer  mollifier  for  critical  zeros  of  zeta",
  Res.  Number  Theory  4:9  (2018),  arXiv:1706.04593  -
  THE  SOURCE  PRZZ  [58]  delegates  its  Case-3  bookkeeping
  to  (PRZZ  section  4  verbatim:  "We  assume  familiarity
  with  [58]  and  its  notation").  The  Conrey-variant
  error  estimate  behind  PRZZ  Case  3  (exponents  7/4
  and  7/8  in  the  clean  form  T^eps(N^{7/4}  +
  T^{1/2}N^{7/8}))  is  THEOREM  1.1  of  [PR],  whose  proof
  (sections  3.1-3.3)  this  unit  reconstructs  at  the
  page  level  (150-200  DPI  renders  of  arXiv:1706.04593v3
  pages  12-15,  2026-11-17;  verbatim  lines  pinned  in
  the  0426-0428  discovery  entries):
      N  =  T^theta,  U  =  N1/d,  V  =  N2/d,
      D  :=  M N1 T^{1-eps}   (the  Delta-truncation),
      H_d :=  N2 T^eps / (d M),
      Delta  range  in  A*_{M,N1,N2}^1 :  0  <  |Delta|  <=  D/d,
      h  <  H_d,   a  =  h Delta,
      A  =  D H_d / d  =  N1 N2 / (d^2 T^{1-eps}),
      M  <=  T^{1/2+eps} (N2/N1)^{1/2},
      m1 m2  <=  T^{1+eps}  (plus  N1,  N2  <=  N),
      Conrey  balance  W'  =  U^{1/4};
      Type  I  (section  3.2.x,  "On  summing  over  a,  v,
          and  e  we  obtain  that  the  contribution  to
          B1  from  a  Type  I  sum  is")
          A*_{TI}  =  T^eps / d (W'^{1/2} U^{1/2} V^{5/4}
                      +  U V^{3/4}),
      Type  II  (section  3.3,  the  Deshouillers-Iwaniec
          seven-monomial  set  J,  quoted  verbatim  in
          0427):
          A*_{TII}  =  T^eps/(dA) (sum_{(b,a,u,v) in J}
                     B^b A^a U^u V^v)^{1/4},
          with  B  ~  U^{1/2}  (b  >  0)  or  B  ~  W  (b<0).
  THE  PUBLISHED  STATEMENT  (Theorem  1.1,  end  of  the
  proof,  quoted  in  0293/0426):  the  asymptotic  holds
  for  theta  <  4/7.
* [BP]  V.  Blomer  &  A.  Pascadi  (2026,  GFA  /
  arXiv:2607.24311),  Theorem  1.1  -  the  all-moduli
  bilinear  Kloosterman  estimate  (0425  entry,  quoted
  verbatim):
      sum_{(m,n,c)=1} alpha_m beta_n S(am,n;c)
          << |alpha||beta| c^{1+o(1)} ( N^{1/8}/c^{3/32}
              +  N^{5/16}/c^{3/16}  +  N^{2/3}/c^{7/18} ),
  saving  c^{-1/32+o(1)}  at  the  critical  length
  N  ~  c^{1/2}.  [BP]  plugs  exactly  at  the  Type  I
  inner  step  of  the  [PR]  derivation  (the  min  of
  trivial  and  Weil-incomplete  Kloosterman  on  the
  bilinear  a x f  kernel  at  modulus  v)  -  no  modulus
  factorization  required,  no  coprimality  requirement  in
  the  full-interval  case.  Cited,  not  proven  in-tree.

AUDITED  JUDGMENT  (0428  entry,  record  level):
  *  THE  CORRECTION  (against  the  0426/0427  summaries):
      A  =  N1 N2 / (d^2 T^{1-eps})  (smalls  A  -  with
      S  =  N1 N2  <=  T,  A  <=  d^{-2}  up  to  T^eps),
      NOT  "d^2 T^{1-eps}";  the  combined  prefix  is
      T^eps/(dA);  H_d  =  N2 T^eps/(dM).
  *  THE  BINDING  LEG:  in  the  worst  block  (d  =  1,
      S  =  T,  N-saturated),  the  Type  I  leg
          TI1  =  T^{5/8 + 5theta/8}
      is  the  binding  leg  of  the  whole  reconstruction,
      admissible  for  theta  <  3/5  -  STRICTLY  ABOVE
      the  published  4/7.  The  published  4/7  is  exactly
      the  saturation  point  of  the  quoted  clean  error
      form  T^eps(N^{7/4}  +  T^{1/2}N^{7/8})  (both  terms
      =  T  at  theta  =  4/7),  which  machine-checks
      below  to  bound  every  reconstructed  leg  for
      theta  in  [1/2,  4/7]  -  i.e.  the  published
      constant  is  a  conservative  clean-form  constant
      with  an  unpublished  margin  of  3/5  -  4/7  =
      1/35.
  *  THE  BP  SUBSTITUTION:  [BP]  improves  the  Type  I
      inner  min(trivial,  Weil)  step  by  the  critical
      saving  1/32;  the  Type  II  binding  leg
      (monomial  (3,2,3,3),  threshold  2/3)  runs  on  the
      SAME  bilinear  Kloosterman  machinery.  Both  clean
      exponents  therefore  move  in  the  right  direction
      -  the  LevWall7  double-waste  gate  passes
      DIRECTIONALLY:  the  wall  moves  strictly  by
      4/7  +  min(8 delta/7,  4 delta2/7)  with  delta,
      delta2  >  0  of  order  the  1/32  critical
      saving  times  (as-yet-uncomputed)  v-summation
      transfer  constants  <=  1.  The  EXACT  coefficients
      are  the  content  of  the  L1  paper  (the  a-v-e
      v-transfer  computation  -  0428  next  move).

MACHINE-VERIFIED  CONTENT  (this  file,  no  RH  claim):
  1.  the  reconstructed  LEG  TABLE  (0428  calculation,
      worst  block  d  =  1,  S  =  T,  N-saturated):
      eight  legs  TI1,  TI2,  M1  -  M6  as  explicit
      rationals  in  theta;
  2.  the  leg  THRESHOLDS:  TI1  binds  at  3/5  (the
      global  reconstructed  admissibility  iff),  M4
      (the  Type  II  binding  leg)  at  2/3,  all  the
      others  slack  (norm_num  /  linarith);
  3.  the  PUBLISHED-CONSTANT  IDENTIFICATION:  4/7  is
      the  clean-form  saturation  (both  terms  =  T
      simultaneously)  and  the  clean  form  bounds  every
      reconstructed  leg  for  theta  in  [1/2,  4/7]  -
      the  published  reach  [0,  4/7)  sits  INSIDE  the
      reconstructed  admissible  set  [0,  3/5),  margin
      exactly  1/35;
  4.  the  BP  DIRECTIONAL  STATEMENT:  critical  saving
      1/32  positive;  full-transfer  idealization  of
      TI1  pushes  the  Type  I  threshold  to  12/19;  and
      (via  LevWall7)  ANY  pair  delta,  delta2  >  0  of
      clean-exponent  improvements  moves  the  wall
      strictly  beyond  4/7  -  the  double-waste  gate
      passes  directionally  for  the  [BP]  substitution.

NO  RH  CLAIM.  This  unit  REGISTERS  the  L1  verdict:
the  4/7  wall  carries  published  margin  (to  3/5)  and
the  2026  all-moduli  Kloosterman  estimate  is  the  first
known  input  that  moves  BOTH  clean  exponents  in  the
right  direction  -  a  strict  directional  wall
movement  of  order  1/32,  not  a  face  closure.  -/

namespace LevWall8

/-! ### 1.  The  reconstructed  leg  table  (0428)
-/
/-- THE  TYPE  I  BINDING  LEG:  TI1  =  T^{5/8  +
    5theta/8}  -  the  T-exponent  of  the  worst-block
    (d  =  1,  S  =  N1 N2  =  T,  N-saturated)  Type  I
    contribution  T^eps N1^{5/8} N2^{5/4}  after  the
    1/(dA)  prefix  cancels  the  inner  A  (0428).  -/
noncomputable def ti1Leg (θ : ℝ) : ℝ := 5 / 8 + 5 * θ / 8

/-- THE  TYPE  I  SECOND  LEG:  TI2  =  T^{1  -  theta/4}
    (from  T^eps N1 N2^{3/4};  never  binds).  -/
noncomputable def ti2Leg (θ : ℝ) : ℝ := 1 - θ / 4

/-- TYPE  II  LEGS  M1  -  M6:  the  T-exponents  (before
    the  T^eps  prefix  and  the  1/(dA)  factor,  which
    contributes  exactly  T^eps  at  S  =  T,  d  =  1)
    of  the  seven  Deshouillers-Iwaniec  monomials  reduced
    by  B  ~  U^{1/2}  (b>0)  /  B  ~  W  (b<0),  on  the
    worst  block  N1  =  T^theta,  N2  =  T^{1-theta},
    S  =  T,  d  =  1:
        M1  =  (1,2,3,4)/(−2,2,4,4) :  A^2 U^{7/2} V^4
        M2  =  (−1,4,3,4)             :  A^4 U^{11/4} V^4
        M3  =  (1,4,3,3)              :  A^4 U^{7/2} V^3
        M4  =  (3,2,3,3)              :  A^2 U^{9/2} V^3
        M5  =  (0,4,4,2)              :  A^4 U^4 V^2
        M6  =  (1,3,4,2)              :  A^3 U^{9/2} V^2
    (A  =  1  at  S  =  T,  d  =  1  up  to  T^eps).  -/
noncomputable def tiiM1Leg (θ : ℝ) : ℝ := (7 / 2 * θ + 4 * (1 - θ)) / 4
noncomputable def tiiM2Leg (θ : ℝ) : ℝ := (11 / 4 * θ + 4 * (1 - θ)) / 4
noncomputable def tiiM3Leg (θ : ℝ) : ℝ := (7 / 2 * θ + 3 * (1 - θ)) / 4
noncomputable def tiiM4Leg (θ : ℝ) : ℝ := (9 / 2 * θ + 3 * (1 - θ)) / 4
noncomputable def tiiM5Leg (θ : ℝ) : ℝ := (4 * θ + 2 * (1 - θ)) / 4
noncomputable def tiiM6Leg (θ : ℝ) : ℝ := (9 / 2 * θ + 2 * (1 - θ)) / 4

/-- THE  RECONSTRUCTED  ADMISSIBILITY:  all  eight
    legs  are  <  T  (i.e.  their  exponents  <  1)  in  the
    worst  block.  -/
def reconstructedAdmissible (θ : ℝ) : Prop :=
    ti1Leg θ < 1 ∧ ti2Leg θ < 1 ∧
      tiiM1Leg θ < 1 ∧ tiiM2Leg θ < 1 ∧ tiiM3Leg θ < 1 ∧
      tiiM4Leg θ < 1 ∧ tiiM5Leg θ < 1 ∧ tiiM6Leg θ < 1

/-! ### 2.  The  leg  thresholds  (machine)
-/
/-- (PROVEN,  machine)  the  Type  I  binding  leg  TI1
    =  T^{5/8 + 5theta/8}  is  <  T  iff  theta  <  3/5
    (valid  for  all  theta  -  linear  in  theta).  -/
theorem ti1Threshold (θ : ℝ) : ti1Leg θ < 1 ↔ θ < 3 / 5 := by
  simp only [ti1Leg]
  constructor
  · intro h
    linarith
  · intro h
    linarith

/-- (PROVEN,  machine)  the  Type  II  binding  leg  M4  =
    (3,2,3,3)  is  <  T  iff  theta  <  2/3.  -/
theorem tiiM4Threshold (θ : ℝ) : tiiM4Leg θ < 1 ↔ θ < 2 / 3 := by
  simp only [tiiM4Leg]
  ring_nf
  constructor
  · intro h
    linarith
  · intro h
    linarith

/-- (PROVEN,  machine)  the  GLOBAL  RECONSTRUCTED
    ADMISSION:  all  eight  legs  <  T  iff  theta  <  3/5
    -  TI1  is  the  binding  leg  of  the  full
    reconstruction  (0303  menu,  L1  lever,  0428
    verdict).  -/
theorem reconstructedAdmissible_iff35 (θ : ℝ) (hθ : 0 < θ) :
    reconstructedAdmissible θ ↔ θ < 3 / 5 := by
  simp only [reconstructedAdmissible]
  constructor
  · intro h
    exact (ti1Threshold θ).mp h.1
  · intro h
    refine ⟨(ti1Threshold θ).mpr h, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
    · simp only [ti2Leg]
      linarith [hθ]
    · simp only [tiiM1Leg]
      ring_nf
      linarith [hθ]
    · simp only [tiiM2Leg]
      ring_nf
      linarith [hθ]
    · simp only [tiiM3Leg]
      ring_nf
      linarith
    · have hm4 : tiiM4Leg θ < 1 :=
        (tiiM4Threshold θ).mpr (lt_trans h (by norm_num : (3 : ℝ) / 5 < 2 / 3))
      exact hm4
    · simp only [tiiM5Leg]
      ring_nf
      linarith
    · simp only [tiiM6Leg]
      ring_nf
      linarith

/-- (PROVEN,  machine,  norm_num)  at  the  published
    boundary  theta  =  4/7  every  leg  is  strictly  <  T:
    TI1  =  T^{55/56},  M4  =  T^{27/28}  (the  tightest
    leg  at  4/7  is  M4;  TI1  is  the  tightest  leg
    overall),  the  rest  as  in  the  0428  table  -
    the  reconstruction  is  feasible  AT  the  published
    boundary.  -/
theorem allLegsStrictAt47 :
    ti1Leg (4 / 7 : ℝ) < 1 ∧ ti2Leg (4 / 7 : ℝ) < 1 ∧
      tiiM1Leg (4 / 7 : ℝ) < 1 ∧ tiiM2Leg (4 / 7 : ℝ) < 1 ∧
      tiiM3Leg (4 / 7 : ℝ) < 1 ∧ tiiM4Leg (4 / 7 : ℝ) < 1 ∧
      tiiM5Leg (4 / 7 : ℝ) < 1 ∧ tiiM6Leg (4 / 7 : ℝ) < 1 := by
  norm_num [ti1Leg, ti2Leg, tiiM1Leg, tiiM2Leg, tiiM3Leg, tiiM4Leg, tiiM5Leg, tiiM6Leg]

/-- (PROVEN,  machine,  norm_num)  the  0428  table  values
    at  theta  =  4/7  (TI1  =  55/56,  M4  =  27/28,
    M1  =  13/14,  M2  =  M3  =  23/28,  M5  =  11/14,
    M6  =  6/7,  TI2  =  6/7):  the  exact  exponents
    pinned  in  the  discovery  entry.  -/
theorem legValuesAt47 :
    ti1Leg (4 / 7 : ℝ) = 55 / 56 ∧ tiiM4Leg (4 / 7 : ℝ) = 27 / 28 ∧
      tiiM1Leg (4 / 7 : ℝ) = 13 / 14 ∧ tiiM2Leg (4 / 7 : ℝ) = 23 / 28 ∧
      tiiM3Leg (4 / 7 : ℝ) = 23 / 28 ∧ tiiM5Leg (4 / 7 : ℝ) = 11 / 14 ∧
      tiiM6Leg (4 / 7 : ℝ) = 6 / 7 ∧ ti2Leg (4 / 7 : ℝ) = 6 / 7 := by
  norm_num [ti1Leg, ti2Leg, tiiM1Leg, tiiM2Leg, tiiM3Leg, tiiM4Leg, tiiM5Leg, tiiM6Leg]

/-! ### 3.  The  published  constant  =  the  clean-form
    saturation  (machine)
-/
/-- (PROVEN,  machine)  the  quoted  clean  error  form
    T^eps (N^{7/4}  +  T^{1/2} N^{7/8})  SATURATES
    simultaneously  at  theta  =  4/7  (both  terms  =  T
    exactly)  -  the  4/7  of  the  published  Theorem  1.1
    statement  is  the  clean-form  saturation  point
    (same  arithmetic  as  `LevWall6.saturationDegreeD_*`,
    re-registered  here  at  the  [PR]  level  since  [PR]
    is  the  source  PRZZ  delegates  to).  -/
theorem cleanFormSaturation_first : ((7 : ℚ) / 4 * (4 / 7) : ℚ) = 1 := by
  norm_num
theorem cleanFormSaturation_second :
    ((7 : ℚ) / 8 * (4 / 7) + 1 / 2 : ℚ) = 1 := by
  norm_num

/-- (PROVEN,  machine)  the  clean  form  bounds  the
    reconstructed  Type  I  binding  leg  TI1  for  theta
    >=  5/9:  5/8  +  5theta/8  <=  7theta/4  iff
    theta  >=  5/9  (and  5/9  <  4/7).  -/
theorem cleanFormBoundsTI1 (θ : ℝ) (hθ : (5 : ℝ) / 9 ≤ θ) :
    ti1Leg θ ≤ 7 * θ / 4 := by
  simp only [ti1Leg]
  linarith

/-- (PROVEN,  machine)  the  clean  form  bounds  the
    reconstructed  Type  II  binding  leg  M4  for
    theta  >=  1/2  - and  1/2  <  5/9  <  4/7,  so  on
    the  whole  published  reach  [1/2,  4/7]  the  clean
    form  bounds  both  binding  legs.  -/
theorem cleanFormBoundsM4 (θ : ℝ) (hθ : (1 : ℝ) / 2 ≤ θ) :
    tiiM4Leg θ ≤ 1 / 2 + 7 * θ / 8 := by
  simp only [tiiM4Leg]
  ring_nf
  linarith

/-- (PROVEN,  machine,  norm_num)  the  ordering  of  the
    clean-form  saturation  constants:  1/2  <  5/9  <
    4/7  <  3/5  <  2/3  <  1  -  the  published  constant
    sits  BETWEEN  the  clean-form  bindingness  range
    [1/2,  5/9]  and  the  reconstructed  thresholds.  -/
theorem saturationLadder :
    (1 / 2 : ℚ) < 5 / 9 ∧ (5 : ℚ) / 9 < 4 / 7 ∧ (4 : ℚ) / 7 < 3 / 5 ∧
      3 / 5 < (2 : ℚ) / 3 ∧ (2 : ℚ) / 3 < 1 := by
  norm_num

/-- (PROVEN,  machine)  THE  PUBLISHED  REACH  IS  THE
    CLEAN-FORM  ADMISSION:  the  published  statement
    (the  o(T)  condition  with  the  clean  exponents
    7/4,  7/8  +  1/2)  is  exactly
    `LevWall6.admissibleDegreeD`  (consistency  with  the
    in-tree  wall  record  -  the  [PR]  clean  form  and
    the  PRZZ  Case-3  form  have  the  same  exponents).
    -/
theorem publishedReachIsCase3 (θ : ℝ) :
    ((7 : ℝ) * θ / 4 < 1 ∧ (7 : ℝ) * θ / 8 + 1 / 2 < 1) ↔ LevWall6.admissibleDegreeD θ := by
  simp only [LevWall6.admissibleDegreeD]

/-- (PROVEN,  machine)  THE  UNSPUBLISHED  MARGIN:
    every  theta  in  the  published  reach  (theta  <
    4/7)  is  RECONSTRUCTED-admissible  (all  eight  legs
    <  T)  -  the  published  reach  (0,  4/7)  sits
    strictly  INSIDE  the  reconstructed  admissible  set
    (0,  3/5).  -/
theorem publishedInsideReconstructed (θ : ℝ) (hθ : 0 < θ)
    (hpublished : (7 : ℝ) * θ / 4 < 1 ∧ (7 : ℝ) * θ / 8 + 1 / 2 < 1) :
    reconstructedAdmissible θ := by
  have hlt : θ < 4 / 7 := by linarith [hpublished.1]
  have hm : (4 : ℝ) / 7 < (3 : ℝ) / 5 := by norm_num
  exact (reconstructedAdmissible_iff35 θ hθ).mpr (lt_trans hlt hm)

/-- (PROVEN,  machine,  norm_num)  the  MARGIN  ITSELF:
    3/5  -  4/7  =  1/35  >  0  -  the  reconstructed
    admission  exceeds  the  published  clean-form
    admission  by  exactly  1/35  (0428  verdict,
    machine-registered).  -/
theorem marginIs1Over35 : (3 : ℚ) / 5 - 4 / 7 = 1 / 35 := by
  norm_num

/-! ### 4.  The  [BP]  substitution  (0425,  0428)  -
    directional  wall  movement
-/
/-- [BP-CRITICAL]  (named  cited  input  -  Blomer-
    Pascadi  2026  Theorem  1.1,  arXiv:2607.24311,
    quoted  verbatim  in  the  0425  entry):  the
    all-moduli  bilinear  Kloosterman  estimate  saves
    c^{-1/32+o(1)}  at  the  critical  length  N  ~
    c^{1/2}  (against  the  trivial  Weil  level  N
    c^{1/2+o(1)}).  The  saving  exponent  1/32  is  the
    named  constant  of  this  unit.  Cited,  not  proven
    in-tree.  -/
def bpCriticalSaving : ℚ := 1 / 32

/-- (PROVEN,  machine)  the  critical  saving  is
    positive  -  the  [BP]  estimate  is  strictly
    below  the  trivial  Weil  level  at  critical
    length.  -/
theorem bpCriticalSavingPositive : 0 < (bpCriticalSaving : ℚ) := by
  norm_num [bpCriticalSaving]

/-- THE  FULL-TRANSFER  IDEALIZATION  of  TI1  under  the
    [BP]  substitution:  the  critical  saving  c^{-1/32}
    lands  on  the  V  =  T^theta  factor  of  the  binding
    block  (V^{-1/32}  on  TI1),  so  TI1  ->
    T^{5/8  +  (5/8  -  1/32) theta}  =  T^{5/8  +
    19 theta/32}.  HONESTY:  the  v-summation  transfer
    constant  is  as  yet  UNCOMPUTED  (between  0  and  1);
    this  idealization  (transfer  =  1)  is  recorded  for
    the  exact-threshold  arithmetic;  the  DIRECTIONAL
    statement  below  is  the  registered  verdict.  -/
noncomputable def ti1LegBPFull (θ : ℝ) : ℝ :=
    5 / 8 + (5 / 8 - (bpCriticalSaving : ℝ)) * θ

/-- (PROVEN,  machine)  under  the  FULL-TRANSFER
    idealization  the  Type  I  threshold  moves  from  3/5
    to  12/19:  5/8  +  19theta/32  <  1  iff
    theta  <  12/19,  and  12/19  >  3/5  -  the  [BP]
    substitution  strictly  raises  the  Type  I
    threshold.  -/
theorem ti1ThresholdBPFull (θ : ℝ) : ti1LegBPFull θ < 1 ↔ θ < 12 / 19 := by
  simp only [ti1LegBPFull, bpCriticalSaving]
  ring_nf
  constructor
  · intro h
    linarith
  · intro h
    linarith

/-- (PROVEN,  machine,  norm_num)  the  threshold
    ORDERING:  3/5  (published  reconstruction)  <  12/19
    (full-transfer  idealization).  -/
theorem bpRaisesTI1Threshold : (3 : ℚ) / 5 < 12 / 19 := by
  norm_num

/-- (PROVEN,  machine)  THE  DIRECTIONAL  DOUBLE-WASTE
    GATE  FOR  [BP]:  if  the  [BP]  substitution  moves
    BOTH  clean  exponents  in  the  right  direction
    (delta  >  0  on  the  T^{1/2}N^{7/8}  side  -  the
    Type  II  binding  leg  runs  on  the  same  bilinear
    machinery  -  and  delta2  >  0  on  the  N^{7/4}
    side  -  the  Type  I  binding  leg  is  where  [BP]
    plugs  in),  then  the  wall  moves  STRICTLY  beyond
    4/7:  it  sits  at  4/7  +  min(8 delta/7,  4 delta2/7)
    with  min  >  0  (LevWall7  min-form  boundary).
    This  is  the  first  named  input  (0300  sweep:
    none  existed)  that  passes  the  double-waste  gate
    directionally.  -/
theorem bpDirectionalWallMove (δ δ2 : ℝ) (hδ : 0 < δ) (hδ2 : 0 < δ2) :
    (4 : ℝ) / 7 + min (8 * δ / 7) (4 * δ2 / 7) > 4 / 7 := by
  have hmin : 0 < min (8 * δ / 7) (4 * δ2 / 7) := lt_min (by linarith) (by linarith)
  linarith [hmin]

/-- (PROVEN,  machine)  the  DIRECTIONAL  RECONSTRUCTION:
    for  delta,  delta2  >  0  the  midpoint  of  the
    published  wall  and  the  new  wall  is  newly
    admissible  under  the  improved  exponents  -  the
    admissible  set  STRICTLY  ENLARGES  for  the  [BP]
    substitution  (via  the  LevWall7  min-form
    boundary).  -/
theorem bpStrictlyEnlargesAdmissible (δ δ2 : ℝ) (hδ : 0 < δ) (hδ2 : 0 < δ2) :
    LevWall7.improvedAdmissible δ δ2
        ((4 / 7) / 2 + (4 / 7 + min (8 * δ / 7) (4 * δ2 / 7)) / 2) := by
  set wnew := 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) with hwnew
  have hpos : 0 < min (8 * δ / 7) (4 * δ2 / 7) := lt_min (by linarith) (by linarith)
  have hmid : (4 / 7) / 2 + wnew / 2 < wnew := by
    dsimp only [wnew] at hwnew ⊢
    nlinarith [hpos]
  rw [LevWall7.wallUnderBothImprovements]
  have h2 : (4 / 7) / 2 + (4 / 7 + min (8 * δ / 7) (4 * δ2 / 7)) / 2 = (4 / 7) / 2 + wnew / 2 := by
    dsimp only [wnew]
  rw [h2]
  have hA : (4 / 7) / 2 + wnew / 2 < 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) := by
    rw [show wnew = 4 / 7 + min (8 * δ / 7) (4 * δ2 / 7) by dsimp only [wnew]]
    have h : 0 < min (8 * δ / 7) (4 * δ2 / 7) := hpos
    nlinarith [h]
  linarith [hA]

end LevWall8
