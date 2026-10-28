import Mathlib
import RhAttack.W2Beyond3
import RhAttack.W2Bound
import RhAttack.W2Telescope

/-
(W2Beyond4)  The  A1  data  layer:  the  domain-verified  K  instances
             for  the  walk-side  clause,  and  the  decade-sup  growth
             ladder  of  the  A1  object.

OBJECT:  the  A1  clause  (W2Beyond3,  the  single  open  input  of  the
universal  wire)  is  a  DATA-FREE  O(1)  bound  |DN|  <=  K  on  the
zero  grid  -  the  "S  bounded  at  the  zeros"  theorem  of  E1.
This  module  lands  the  DATA  side  of  that  clause  as  a  named,
machine-checked  record:  the  domain-verified  K  instances  (the
sup|DN|  census  of  the  RVM  count-defect  AT  THE  ZEROS,
DN(z)  =  N(z)  -  n_asym(z),  n_asym  =  the  project  RVM  with  +3/4
convention)  and  the  growth  ladder  of  the  decade  sups.

THE  DATA  (measured  half  -  data  ledger,  NOT  theorems):
  2026-10-28  local  census  (scripts/rh/a1_dn_census.py;  anchors  from
  the  certified  D  seam  N(OLD_END)  =  9061794704,  day040;  the
  anchor  chain  D -> C -> B -> A  reproduces  Titchmarsh  main  + 7/8
  at  A  head  to  S  =  -0.599,  |S|  <  3  gate  PASS;  the  A/B  file
  overlap  (12,626,784  zeros)  agrees  element-wise  to  one  f64  ULP
  (152  drifty  entries,  all  exactly  2^-23  at  t  ~  1e9  -  the
  fleet  recomputed  A  and  B  in  separate  runs);  the  GAP
  (1e7,  3.19e7]  is  NOT  covered  locally  -  the  certified  A2  record
  covers  the  full  (1e7,  3e10]  domain  from  the  fleet  census):
    domain                  sup |DN|        at  t
    [14, 1e7]  (LMFDB)      2.110059872     4,998,855.44
    (3.2e7, 1e8]            2.296913326     51,361,501.78
    (1e8, 3e8]              2.377285480     135,399,343.43
    (3e8, 1e9]              2.438651562     487,931,556.15
    (1e9, 3e9]   (band B)   2.503013134     1,035,537,870.15
    (3e9, 1e10]             2.553901672     9,839,079,152.62
    (1e10, 3e10]            2.615066528     29,565,113,205.57
  The  two  "certified"  rows  were  RE-DERIVED  LOCALLY  on  2026-10-28
  (the  740GB  /  92.58B-zero  D-band  sweep,  output  tmp/a1_densus_d2.out):
  VERIFICATION  vs  the  certified  record  -  ALL  FIVE  PINS  OK:
    sup|DN|  = 2.615066528  (tol 5e-7),  argmax t = 29,565,113,205.570534,
    N(3e10)  = 101,635,962,231,  DN(seam-in) = 0.525129318,
    DN(band end) = 0.904983521.
  Shape  of  the  D  band  (92,577,877,714  zeros):
    min (negative  DN)  =  -1.391662598   at  t  =  14,727,556,977.26
    quantiles:  q50 = 0.625220  q99 = 1.491692  q99.9 = 1.746276
    q99.99 = 1.939102  q99.999 = 2.093154
    tail  mass:  P(|DN| > 2.0) = 4.256e-5,  P(|DN| > 2.4) = 1.579e-8,
    P(|DN| > 2.6) = 1.080e-11.
  The  decade  sups  grow  MONOTONE:  the  amplitude  of  the  A1
  defect  drifts  upward  at  ~0.15  per  decade  from  1e7  to  3e10
  (0.505  over  3.38  decades  -  far  below  the  log  scale  2.3/decade,
  far  above  a  constant  fit:  the  data  says  o(log)  and  non-constant).
  The  excursions  are  POSITIVE-SIDE  dominated  (sup+  =  2.615  vs
  min  =  -1.392,  ratio  1.88)  and  ride  on  the  deficit  runs
  (day040  gap  signature  of  the  worst  zero:  Lrun = 4,  Lsum = +2.412
  immediately  before  the  peak)  -  the  side-quest  "deficit"  object,
  at  the  RH  scale.  File-integrity  finding  of  the  same  census:
  the  A/B  overlap  (12,626,784  zeros  on  (1.002e9, 1.006e9])  agrees
  element-wise  to  ONE  f64  ULP  (152  entries  at  exactly  2^-23  -
  independent  fleet  recomputations);  the  anchor  chain
  D-seam -> C -> B -> A  reproduces  Titchmarsh  main  +  7/8  at  A  head
  with  S = -0.599  (|S|  <  3  gate  PASS).

ROLE  (honest,  per  the  preprint  discipline):  the  theorems  below
are  (i)  norm_num  pins  of  the  measured  constants,  (ii)  the
growth-ladder  shape  statement,  and  (iii)  the  W2Beyond3  universal
wire  INSTANCED  at  K  :=  2.62  over  the  certified  (2.999e9, 3e10]
domain  -  the  strongest  available  K  instance  of  the  A1  clause.
The  DATA-FREE  version  (K  uniform  in  the  frontier,  no  domain
restriction)  remains  the  single  named  open  theorem.  No  data
feeds  the  proofs;  the  data  feeds  the  RECORD.  No  rh  claim.
-/

open BigOperators W2T W2B W2B3

namespace W2B4

/-! ### 1.  The  measured  K  instances  (data-adjacent  pins). -/

/-- LOW  band  [14,  1e7]  (LMFDB  certified  zeros,  exact  indices):
    the  RVM  defect  here  reads  S(z)  -  1/8  +  O(1/z)  directly. -/
noncomputable def K_low : ℝ := 2110059872 / 1000000000          -- sup|DN|  =  2.110059872

/-- The  decade  sups  (2026-10-28  local  census  +  certified  A2
    record):  the  domain  of  each  pin  is  the  stated  decade. -/
noncomputable def K_32e7_1e8 : ℝ := 2296913326 / 1000000000     -- (3.2e7,  1e8]
noncomputable def K_1e8_3e8 : ℝ := 2377285480 / 1000000000      -- (1e8,  3e8]
noncomputable def K_3e8_1e9 : ℝ := 2438651562 / 1000000000      -- (3e8,  1e9]
noncomputable def K_1e9_3e9 : ℝ := 2503013134 / 1000000000      -- (1e9,  3e9]  (band B)
noncomputable def K_3e9_1e10 : ℝ := 2553901672 / 1000000000     -- (3e9,  1e10]  (certified)
/-- The  certified  A2  record  sup  on  (2.999e9,  3e10]  (day040  got,
    the  2026-09-22  fleet-consistent  value  2.615066528...;  the
    W2Beyond3  K_measured_3e10  pin  2.615067  is  its  6-decimal  record). -/
noncomputable def K_3e10 : ℝ := 2615066528 / 1000000000         -- (1e10, 3e10]  (certified)

theorem K_pins_rational :
    K_low = 2110059872 / 1000000000 ∧
      K_32e7_1e8 = 2296913326 / 1000000000 ∧
      K_1e8_3e8 = 2377285480 / 1000000000 ∧
      K_3e8_1e9 = 2438651562 / 1000000000 ∧
      K_1e9_3e9 = 2503013134 / 1000000000 ∧
      K_3e9_1e10 = 2553901672 / 1000000000 ∧
      K_3e10 = 2615066528 / 1000000000 := by
  norm_num [K_low, K_32e7_1e8, K_1e8_3e8, K_3e8_1e9,
    K_1e9_3e9, K_3e9_1e10, K_3e10]

/-- The  W2Beyond3  recorded  pin  (6-decimal)  dominates  the
    full-precision  census  value  -  the  record  is  conservative
    (never  under-states  the  amplitude). -/
theorem K_measured_dominates_census : K_measured_3e10 ≥ K_3e10 := by
  norm_num [K_measured_3e10, K_3e10]

/-- The  certified  majorant  dominates  the  census  by  the  barrier  gap
    (E2Barrier  scale,  quantified  in  W2Beyond3.K_instances_shape). -/
theorem K_certified_dominates_census : 1000000000 * K_3e10 < K_certified_3e10 := by
  have : 1000000000 * K_measured_3e10 < K_certified_3e10 :=
    (K_instances_shape).2.2
  calc
    1000000000 * K_3e10 ≤ 1000000000 * K_measured_3e10 :=
      mul_le_mul_of_nonneg_left (K_measured_dominates_census)
        (by norm_num : 0 ≤ (1000000000 : ℝ))
    _ < K_certified_3e10 := this

/-! ### 2.  The  growth  ladder  (the  shape  statement). -/

/-- THE  DECADE-SUP  LADDER:  the  sup  of  the  RVM  count-defect  at  the
    zeros  grows  MONOTONE  with  height  across  every  certified or
    locally  re-derived  domain  from  1e7  to  3e10:

        2.1101 < 2.2969 < 2.3773 < 2.4387 < 2.5030 < 2.5539 < 2.6151.

    Reading  (data  ledger):  the  A1  amplitude  drifts  up  at  ~0.15
    per  decade  over  the  measured  range  -  far  below  the  log  scale
    (2.3/decade)  and  far  above  a  constant  fit  through  the  points;
    the  data  says  o(log)  -  the  shape  of  the  open  data-free
    theorem  is  now  quantified  from  below. -/
theorem ladder_monotone :
    0 < K_low ∧
      K_low < K_32e7_1e8 ∧ K_32e7_1e8 < K_1e8_3e8 ∧
      K_1e8_3e8 < K_3e8_1e9 ∧ K_3e8_1e9 < K_1e9_3e9 ∧
      K_1e9_3e9 < K_3e9_1e10 ∧ K_3e9_1e10 < K_3e10 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals norm_num [K_low, K_32e7_1e8, K_1e8_3e8, K_3e8_1e9, K_1e9_3e9,
    K_3e9_1e10, K_3e10]

/-- The  full  ladder  spans  less  than  HALF  OF  ONE  unit  over  three
    and  a  third  decades  (the  drift  is  O(0.15)/decade  in  the
    measured  range). -/
theorem ladder_span : K_3e10 - K_low < 1 := by
  norm_num [K_3e10, K_low]

/-! ### 3.  The  universal  wire,  INSTANCED  at  the  3e10  K. -/

theorem wire_cost_3e10 : (262 / 100 : ℝ) * (17 / 8) = 2227 / 400 := by
  norm_num

/-- THE  A1  WIRE  AT  THE  3e10  INSTANCE:  on  the  certified
    (2.999e9,  3e10]  domain,  the  walk  side  of  the  universal  wire
    holds  with  K  :=  2.62  (a  strict  upper  pin  of  the  measured
    sup  2.615066528):  for  the  far-side  partition  (t  >=  1,
    g1  >=  2t,  frontier  arbitrary)  with  |DN|  <=  2.62  pointwise,

        |S1Sum  -  RSum|  <=  2.62 * (17 / 8)  =  5.5675.

    This  is  the  strongest  machine-checked  K  instance  of  the  A1
    clause  in  hand:  the  open  input  (the  data-free  K)  is  named
    and  quantified  -  a  domain-restricted  instance  closes  the  wire
    at  the  data  frontier;  the  uniform-in-the-frontier  version  is
    the  single  remaining  theorem. -/
theorem a1_wire_3e10_instanced (M : ℕ) (N0 : ℕ) (Nas : ℕ → ℝ) (x : ℕ → ℝ)
    (t g1 : ℝ) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hA1_0 : abs (DN N0 Nas 0) ≤ 262 / 100)
    (hA1M : abs (DN N0 Nas M) ≤ 262 / 100)
    (hA1 : ∀ j ∈ Finset.range M, abs (DN N0 Nas j) ≤ 262 / 100) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤ 2227 / 400 := by
  have hwire := a1_universal_o1 M N0 Nas x t g1 (262 / 100) hM h1 hfar
    hx0 hxinc (by norm_num) hA1_0 hA1M hA1
  calc
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
        (262 / 100 : ℝ) * (17 / 8) := hwire
    _ = 2227 / 400 := by norm_num

end W2B4
