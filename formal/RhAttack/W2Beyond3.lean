/-
# (W2Beyond3)  The A1 assembly:  the kernel half of the universal
#              [S1],  uniform  in  the  data  frontier.

The  preprint's  A1  clause  (docs/S1-A1-EXPLORATION.md  E1)  asks
for  the  universal  (data-free)  version  of  the  graded  walk
bound.  Two  things  it  is  NOT,  established  earlier:

  *  it  is  not  "sum  the  per-gap  epsilons  better"  (E2 /  E9,
    E2Barrier:  the  certified  absolute-sum  majorant  is  10^10
    times  the  walk  amplitude  —  the  barrier  is  structural);
  *  it  is  not  refuted  by  the  classical  Omegas  (E3.2:  no
    known  theorem  lands  a  large  S  value  AT  THE  ZEROS).

What  it  IS,  exactly  (E1  +  E12,  sharpened  by  the  verified
S-pipeline  of  day041b):  on  the  zero  grid,  S  -  main  is  an
O(1)  bounded  oscillation  with  ~1  jumps  at  the  grid;  A1's
universal  epsilon  must  be  O(1),  and  the  walk  side  of  the
bound  is  the  pointwise  statement  |DN|  <=  K  on  the  zero
grid  —  "S  bounded  at  the  zeros".

This  module  is  the  ASSEMBLY  of  the  kernel-half  atoms  (E8,
W2Beyond2:  eullK_tail_bound,  eullK_finite_var_far,
eullK_far_segment)  into  the  WIRE  shape  the  W2  defect
consumes  (W2B.e4_wBound,  the  W2M5.m5_floor  pattern):

    |S1 - R|  <=  K . (|p(G1)| + |p(G2)| + TV(p))

on  the  FAR  SIDE  of  the  straddle  (the  zeros  g  with  g >=
2t,  t  >=  1),  proving:

  farKernelTV           the  discrete  total  variation  of  the
                        kernel  over  ANY  partition  of  the  far
                        side  starting  at  x 0  >=  g1  >=  2t  is
                        at  most  (5/2)  t^2/g1^2  —  UNIFORM  IN
                        WHERE  THE  WALK  STOPS  (the  data
                        frontier  x M  does  not  appear  in  the
                        bound);
  a1_far_side_cost      the  three  wire  factors  together  (the  two
                        endpoint  kernel  values  +  the  discrete
                        TV)  are  at  most  (17/2)  t^2/g1^2;
  a1_far_side_o1        g1 >= 2t  =>  (17/2)  t^2/g1^2  <=  17/8:
                        the  kernel  contributes  a  CONSTANT  cost
                        to  any  frontier;
  a1_universal_wire     the  conditional  universal  statement:  if
                        the  walk  side  holds  pointwise  with  a
                        data-free  K  (the  A1  clause,  stated  as
                        the  hypotheses  hA1_0/hA1M/hA1),  then  the
                        full  W2  defect  on  the  far  side  is  at
                        most  K . (17/2)  t^2/g1^2;
  a1_universal_o1       the  O(1)  specialization:  K . (17/8).

THE  STATUS  LINE  (honest,  per  the  preprint  discipline):
everything  above  is  PROVEN.  The  A1  clause  itself  —  the
hA1  hypotheses  (|DN|  <=  K  on  the  zero  grid  for  a
data-free  O(1)  K)  —  is  the  single  open  item:  the  "S
bounded  at  the  zeros"  theorem.  The  data  say  it  is  TAME  on
the  3 x 10^10  band  (MEASURED  sup|DN|  =  2.615067;  the
certified  majorant  SUM_EPS_CERT  =  31047116350.923088  is  the
A2  engine's  bound,  10^10  times  looser,  E2Barrier).  No  known
theorem  closes  or  refutes  the  universal  K  (E3.2).

No  data,  no  sorry:  pure  real  analysis  on  the  pinned
mathlib  (v4.33.1).  The  measured  pins  below  are  literal
constants  of  the  verified  3 x 10^10  band  (the  E2Barrier
pattern):  they  feed  the  record,  not  the  proofs.
-/
import Mathlib
import RhAttack.W2Beyond2
import RhAttack.W2Bound
import RhAttack.W2Telescope

open BigOperators

namespace W2B3

open W2T

/-! ### 0.  Small  order  facts  about  the  partition. -/

/-- The  partition  is  nondecreasing  from  the  head:  from  the
strict  consecutive  increase,  x j  >=  x 0  for  every  j  <=  M. -/
private lemma partLeHead (M : ℕ) (x : ℕ → ℝ)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (j : ℕ) (hj : j ≤ M) : x 0 ≤ x j := by
  induction j with
  | zero =>
      exact le_rfl
  | succ u ih =>
      have hu : u ∈ Finset.range M :=
        Finset.mem_range.mpr (Nat.lt_of_lt_of_le (Nat.lt_succ_self u) hj)
      have hstep : x u ≤ x (u + 1) := le_of_lt (hxinc u hu)
      exact le_trans (ih (Finset.mem_range.mp hu).le) hstep

/-! ### 1.  The  discrete  total  variation  of  the  far-side
kernel  (any  partition,  uniform  in  the  frontier). -/

/-- The  TELESCOPING  core:  the  per-segment  majorants  (5/2)
t^2 (1/x_j^2  -  1/x_{j+1}^2)  are  differences  of  the  potential
(5/2)  t^2/u^2,  so  their  sum  over  the  partition  collapses
to  first  and  last.  Pure  algebra  (no  measure  theory):  this
is  why  the  discrete  walk  inherits  the  continuous  bound
without  an  M  factor. -/
lemma segSumTelescopes (t : ℝ) (M : ℕ) (x : ℕ → ℝ)
    (hpos : ∀ j ∈ Finset.Icc 0 M, 0 < x j) :
    (Finset.range M).sum (fun j =>
        (5/2) * t^2 * (1 / (x j)^2 - 1 / (x (j + 1))^2)) =
      (5/2) * t^2 * (1 / (x 0)^2 - 1 / (x M)^2) := by
  induction M with
  | zero =>
      simp only [Finset.sum_range_zero]
      ring
  | succ i ih =>
      have hposi (j : ℕ) (hj : j ∈ Finset.Icc 0 i) : j ∈ Finset.Icc 0 (i + 1) :=
        Finset.mem_Icc.mpr ⟨(Finset.mem_Icc.mp hj).1,
          le_trans (Finset.mem_Icc.mp hj).2 (Nat.le_succ i)⟩
      have hh := ih (fun j hj => hpos j (hposi j hj))
      have hx0 : 0 < x 0 := hpos 0 (Finset.mem_Icc.mpr ⟨by omega, by omega⟩)
      have hxi : 0 < x i := hpos i (Finset.mem_Icc.mpr ⟨by omega, Nat.le_succ i⟩)
      have hxi1 : 0 < x (i + 1) := hpos (i + 1) (Finset.mem_Icc.mpr ⟨by omega, le_rfl⟩)
      rw [Finset.sum_range_succ, hh]
      field_simp [pow_two, pow_pos hx0 2, pow_pos hxi 2, pow_pos hxi1 2]
      ring

/-- DISCRETE  TOTAL  VARIATION,  far  side  (the  E4  "walk  half"
for  the  kernel):  t  >=  1,  g1  >=  2t,  and  a  STRICT
partition  x  0  <  x  1  <  ...  of  the  far  side  starting  at
x  0  >=  g1  =>

    sum  |p(x (j+1))  -  p(x j)|  <=  (5/2)  t^2  /  g1^2.

The  bound  is  UNIFORM  IN  THE  FRONTIER:  the  last  point  x M
(arbitrarily  far  to  the  right)  does  not  appear  in  it  —
the  kernel  cannot  vary  by  more  than  (5/2)  t^2/g1^2  over
ANY  finite  stretch  of  the  far  side,  no  matter  how  long
the  data  run  is. -/
theorem farKernelTV (t g1 : ℝ) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (M : ℕ) (x : ℕ → ℝ) (hx0 : g1 ≤ x 0)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1)) :
    (Finset.range M).sum (fun j =>
        |FarKernel t (x (j + 1)) - FarKernel t (x j)|) ≤
      (5/2) * t^2 / g1^2 := by
  have hg1p : 0 < g1 := by linarith
  have hpos (j : ℕ) (hj : j ≤ M) : 0 < x j := by
    have h0 : g1 ≤ x j := le_trans hx0 (partLeHead M x hxinc j hj)
    exact lt_of_lt_of_le hg1p h0
  --  per-segment  majorant  (the  E8  segment  atom):
  have hseg (j : ℕ) (hj : j ∈ Finset.range M) :
      |FarKernel t (x (j + 1)) - FarKernel t (x j)| ≤
        (5/2) * t^2 * (1 / (x j)^2 - 1 / (x (j + 1))^2) := by
    have hfarj : 2 * t ≤ x j :=
      le_trans (le_trans hfar hx0) (partLeHead M x hxinc j (Finset.mem_range.mp hj).le)
    exact eullK_far_segment t (x j) (x (j + 1)) h1 hfarj
      (le_of_lt (hxinc j hj))
  have hsum : (Finset.range M).sum (fun j =>
          |FarKernel t (x (j + 1)) - FarKernel t (x j)|) ≤
        (Finset.range M).sum (fun j =>
          (5/2) * t^2 * (1 / (x j)^2 - 1 / (x (j + 1))^2)) :=
    Finset.sum_le_sum fun j hj => hseg j hj
  have htel : (Finset.range M).sum (fun j =>
          (5/2) * t^2 * (1 / (x j)^2 - 1 / (x (j + 1))^2)) =
        (5/2) * t^2 * (1 / (x 0)^2 - 1 / (x M)^2) := by
    have hposIcc (j : ℕ) (hj : j ∈ Finset.Icc 0 M) : 0 < x j :=
      hpos j (Finset.mem_Icc.mp hj).2
    exact segSumTelescopes t M x hposIcc
  have hdrop : (5/2) * t^2 * (1 / (x 0)^2 - 1 / (x M)^2) ≤
      (5/2) * t^2 * (1 / (x 0)^2) := by
    have hco : 0 ≤ (5/2) * t^2 :=
      mul_nonneg (by norm_num : 0 ≤ (5/2 : ℝ)) (pow_two_nonneg t)
    have hnonneg : 0 ≤ 1 / (x M)^2 :=
      div_nonneg (by norm_num : 0 ≤ (1 : ℝ)) (pow_two_nonneg (x M))
    have hsub : 1 / (x 0)^2 - 1 / (x M)^2 ≤ 1 / (x 0)^2 := by
      linarith [hnonneg]
    exact mul_le_mul_of_nonneg_left hsub hco
  have hmon : (5/2) * t^2 / (x 0)^2 ≤ (5/2) * t^2 / g1^2 := by
    have hx0p : 0 < x 0 := lt_of_lt_of_le hg1p hx0
    have h0 : g1 ^ 2 ≤ (x 0) ^ 2 := pow_le_pow_left₀ hg1p.le hx0 2
    have hco : 0 ≤ (5/2) * t^2 :=
      mul_nonneg (by norm_num : 0 ≤ (5/2 : ℝ)) (pow_two_nonneg t)
    rw [div_le_div_iff₀ (pow_pos hx0p 2) (pow_pos hg1p 2)]
    exact mul_le_mul_of_nonneg_left h0 hco
  calc
    (Finset.range M).sum (fun j => |FarKernel t (x (j + 1)) - FarKernel t (x j)|)
        ≤ (Finset.range M).sum (fun j => (5/2) * t^2 * (1 / (x j)^2 - 1 / (x (j + 1))^2)) :=
          hsum
    _ = (5/2) * t^2 * (1 / (x 0)^2 - 1 / (x M)^2) := htel
    _ ≤ (5/2) * t^2 * (1 / (x 0)^2) := hdrop
    _ = (5/2) * t^2 / (x 0)^2 := by
          field_simp [pow_two]
    _ ≤ (5/2) * t^2 / g1^2 := hmon

/-! ### 2.  The  wire  factors,  assembled. -/

/-- THE  THREE  WIRE  FACTORS,  far  side:  for  the  partition
    x  0  =  g1  >=  2t  of  the  far  side  (frontier  x  M
    arbitrary,  t  >=  1),

        |p(g1)|  +  |p(x M)|  +  sum  |dp  j|  <=  (17/2)  t^2/g1^2

    where  p j  =  FarKernel  t (x j).  The  constant  17/2  is
    3  (left  endpoint,  the  tail  bound)  +  3  (right  endpoint,
    the  tail  bound  at  the  frontier,  dominated  by  the  left
    one)  +  5/2  (the  discrete  TV,  the  E8  finite-variation
    atom).  UNIFORM  IN  THE  FRONTIER  x M. -/
theorem a1_far_side_cost (t g1 : ℝ) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (M : ℕ) (hM : 0 < M) (x : ℕ → ℝ) (hx0 : x 0 = g1)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (p : ℕ → ℝ) (hp : ∀ j, p j = FarKernel t (x j)) :
    |p 0| + |p M| + (Finset.range M).sum (fun j => abs (DP p j)) ≤
      (17/2) * t^2 / g1^2 := by
  have hg1p : 0 < g1 := by linarith
  have hx0p : 0 < x 0 := by rw [hx0]; exact hg1p
  have hxMge : g1 ≤ x M := by rw [← hx0]; exact partLeHead M x hxinc M le_rfl
  have hxMp : 0 < x M := lt_of_lt_of_le hg1p hxMge
  have hfar0 : 2 * t ≤ x 0 := by rw [hx0]; exact hfar
  have hfarM : 2 * t ≤ x M := le_trans hfar hxMge
  have hleft : |p 0| ≤ 3 * t^2 / (x 0)^2 := by
    rw [hp 0]
    have hrew : EfullKernel t (x 0) = FarKernel t (x 0) := eullK_far_rewrite t h1 (x 0) hfar0
    rw [← hrew]
    exact eullK_tail_bound t h1 (x 0) hfar0
  have hright : |p M| ≤ 3 * t^2 / (x M)^2 := by
    rw [hp M]
    have hrew : EfullKernel t (x M) = FarKernel t (x M) := eullK_far_rewrite t h1 (x M) hfarM
    rw [← hrew]
    exact eullK_tail_bound t h1 (x M) hfarM
  have hright' : 3 * t^2 / (x M)^2 ≤ 3 * t^2 / g1^2 := by
    have hsq : g1^2 ≤ (x M)^2 := pow_le_pow_left₀ hg1p.le hxMge 2
    rw [div_le_div_iff₀ (pow_pos hxMp 2) (pow_pos hg1p 2)]
    nlinarith [hsq]
  have htv : (Finset.range M).sum (fun j => abs (DP p j)) ≤
      (5/2) * t^2 / g1^2 := by
    have hsame : (Finset.range M).sum (fun j => abs (DP p j)) =
        (Finset.range M).sum (fun j => |FarKernel t (x (j + 1)) - FarKernel t (x j)|) := by
      apply Finset.sum_congr rfl
      intro j _
      dsimp only [DP]
      rw [hp (j + 1), hp j]
    rw [hsame]
    exact farKernelTV t g1 h1 hfar M x (le_of_eq hx0.symm) hxinc
  have hsum : |p 0| + |p M| + (Finset.range M).sum (fun j => abs (DP p j)) ≤
      3 * t^2 / (x 0)^2 + 3 * t^2 / g1^2 + (5/2) * t^2 / g1^2 := by
    have hstep : |p 0| + |p M| ≤ 3 * t^2 / (x 0)^2 + 3 * t^2 / g1^2 :=
      add_le_add hleft (le_trans hright hright')
    calc
      |p 0| + |p M| + (Finset.range M).sum (fun j => abs (DP p j))
          ≤ (3 * t^2 / (x 0)^2 + 3 * t^2 / g1^2) + (5/2) * t^2 / g1^2 :=
            add_le_add hstep htv
      _ = 3 * t^2 / (x 0)^2 + 3 * t^2 / g1^2 + (5/2) * t^2 / g1^2 := by ring
  have hall : 3 * t^2 / (x 0)^2 + 3 * t^2 / g1^2 + (5/2) * t^2 / g1^2 =
      (17/2) * t^2 / g1^2 := by
    have hx0sq : (x 0)^2 = g1^2 := by rw [hx0]
    rw [hx0sq]
    field_simp [pow_two, show g1 ≠ 0 from hg1p.ne']
    ring
  exact le_trans hsum hall.le

/-- THE  O(1)  SPECIALIZATION:  g1  >=  2t  (t  >=  1)  =>
    (17/2)  t^2/g1^2  <=  17/8.  The  kernel  cost  of  the  far
    side  is  a  CONSTANT  —  the  "the  kernel  contributes  a
    constant  cost  to  any  frontier"  line  of  the  reduction. -/
theorem a1_far_side_o1 (t g1 : ℝ) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1) :
    (17/2) * t^2 / g1^2 ≤ 17/8 := by
  have hg1p : 0 < g1 := by linarith
  have h4 : 4 * t^2 ≤ g1^2 := by
    rw [← sub_nonneg]
    have hfac : g1^2 - 4 * t^2 = (g1 - 2*t) * (g1 + 2*t) := by ring
    rw [hfac]
    apply mul_nonneg
    · linarith
    · linarith
  rw [div_le_div_iff₀ (pow_pos hg1p 2) (by norm_num : (0 : ℝ) < 8)]
  have hm : 17 * (4 * t^2) ≤ 17 * g1^2 :=
    mul_le_mul_of_nonneg_left h4 (by norm_num : 0 ≤ (17 : ℝ))
  nlinarith [hm]

/-! ### 3.  The  universal  statement,  conditional  on  the  A1
clause  (the  open  item,  stated  as  a  hypothesis). -/

/-- THE  A1  ASSEMBLY  (the  universal  [S1],  kernel  half):
for  the  far-side  partition  x  0  =  g1  >=  2t  (t  >=  1,
frontier  x  M  arbitrary),  p  j  =  FarKernel  t  (x j),  on
ANY  walk  data  (N0,  Nas),  IF  the  walk  side  holds
pointwise  with  a  data-free  K  (the  A1  clause:  |DN|  <=  K
on  the  zero  grid  —  the  "S  bounded  at  the  zeros"  theorem
of  E1,  OPEN),  then

    |S1Sum  p  -  RSum  p  Nas|  <=  K . (17/2)  t^2/g1^2.

The  kernel  half  is  CLOSED  by  the  E8  atoms;  the  walk  half
(hA1_0,  hA1M,  hA1)  is  the  single  remaining  open  input. -/
theorem a1_universal_wire (M : ℕ) (N0 : ℕ) (Nas : ℕ → ℝ) (x : ℕ → ℝ)
    (t g1 K : ℝ) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hK : 0 ≤ K)
    (hA1_0 : abs (DN N0 Nas 0) ≤ K)
    (hA1M : abs (DN N0 Nas M) ≤ K)
    (hA1 : ∀ j ∈ Finset.range M, abs (DN N0 Nas j) ≤ K) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      K * ((17/2) * t^2 / g1^2) := by
  set p := fun j => FarKernel t (x j) with hp
  have hwire : abs (S1Sum M p - RSum M p Nas) ≤
      K * (abs (p 0) + abs (p M)) + K * (Finset.range M).sum (fun j => abs (DP p j)) :=
    W2B.e4_wBound M p N0 Nas K hA1_0 hA1M hA1
  have hcost := a1_far_side_cost t g1 h1 hfar M hM x hx0 hxinc p (by
    intro j
    dsimp only [p])
  have hfact : K * (abs (p 0) + abs (p M)) + K * (Finset.range M).sum (fun j => abs (DP p j)) =
      K * (abs (p 0) + abs (p M) + (Finset.range M).sum (fun j => abs (DP p j))) := by
    ring
  calc
    abs (S1Sum M p - RSum M p Nas)
        ≤ K * (abs (p 0) + abs (p M)) + K * (Finset.range M).sum (fun j => abs (DP p j)) :=
          hwire
    _ = K * (abs (p 0) + abs (p M) + (Finset.range M).sum (fun j => abs (DP p j))) := hfact
    _ ≤ K * ((17/2) * t^2 / g1^2) :=
        mul_le_mul_of_nonneg_left hcost hK

/-- The  O(1)  specialization:  the  same  statement  with  the
    closed  kernel  constant  17/8  in  place  of  (17/2)  t^2/g1^2.
    This  is  the  wire  shape  at  the  data  scale  the  preprint
    cites:  the  frontier  G2  drops  out;  only  the  walk  side
    (the  hA1  hypotheses,  the  open  A1  clause)  remains. -/
theorem a1_universal_o1 (M : ℕ) (N0 : ℕ) (Nas : ℕ → ℝ) (x : ℕ → ℝ)
    (t g1 K : ℝ) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hK : 0 ≤ K)
    (hA1_0 : abs (DN N0 Nas 0) ≤ K)
    (hA1M : abs (DN N0 Nas M) ≤ K)
    (hA1 : ∀ j ∈ Finset.range M, abs (DN N0 Nas j) ≤ K) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤ K * (17/8) := by
  have hwire := a1_universal_wire M N0 Nas x t g1 K hM h1 hfar hx0 hxinc hK hA1_0 hA1M hA1
  have ho1 := a1_far_side_o1 t g1 h1 hfar
  calc
    abs (S1Sum M (fun j => FarKernel t (x j)) - RSum M (fun j => FarKernel t (x j)) Nas)
        ≤ K * ((17/2) * t^2 / g1^2) := hwire
    _ ≤ K * (17/8) := mul_le_mul_of_nonneg_left ho1 hK

/-! ### 4.  The  3 x 10^10  band  record  (data-adjacent  pins,
the  E2Barrier  pattern).  The  measured  O(1)  amplitude  and  the
certified  majorant  —  the  two  K  instances  of  the  A1  clause
in  hand  today;  the  universal  data-free  K  is  the  open
item. -/

/-- MEASURED  O(1)  amplitude:  sup|DN|  on  (10^7,  3 x 10^10]
    (S4  census,  the  A2  data  layer):  K  =  2.615067. -/
def K_measured_3e10 : ℝ := 2.615067

/-- The  CERTIFIED  majorant  of  the  A2  engine  (E2Barrier,
    the  absolute-sum  bound):  SUM_EPS_CERT.  It  feeds  the  hA1
    clause  trivially  (any  certified  majorant  is  a  valid  K),
    at  a  cost  10^10  times  the  measured  amplitude  (the  E2
    barrier  record,  E2Barrier.barrier_band3e10). -/
def K_certified_3e10 : ℝ := 31047116350.923088

/-- pin  shape  (norm_num  on  the  certified  digits). -/
theorem K_measured_pin : K_measured_3e10 = 2615067 / 1000000 := by
  norm_num [K_measured_3e10]

theorem K_certified_pin : K_certified_3e10 = 31047116350923088 / 1000000 := by
  norm_num [K_certified_3e10]

/-- the  two  K  instances  are  exactly  what  they  claim  to
    be:  the  measured  O(1)  amplitude  is  positive  and  SMALL;
    the  certified  majorant  dominates  it  by  more  than  10^9
    (the  barrier  scale  gap,  recorded  quantitatively). -/
theorem K_instances_shape :
    0 < K_measured_3e10 ∧
      K_measured_3e10 < K_certified_3e10 ∧
      1000000000 * K_measured_3e10 < K_certified_3e10 := by
  refine ⟨?_, ?_, ?_⟩
  · norm_num [K_measured_3e10]
  · norm_num [K_measured_3e10, K_certified_3e10]
  · norm_num [K_measured_3e10, K_certified_3e10]

end W2B3
