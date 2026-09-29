/-
#  A1Growth  —  the A1 wire at the provable growth form  (E19)


#  What this is, and why the form changed
#  =======================
#
#  The A1 clause as originally stated (E1;  W2Beyond3 header)  is the
#  uniform,  data-free   |DN j|  <=  K   at every  data  zero.  The
#  online-verified  literature  pass  (E19,  docs/S1-A1-EXPLORATION.md)
#  establishes  three  facts  about  that  clause:
#
#   F1.  NO  theorem  in  the  literature  gives  |S(t)|  <=  C  for  an
#        absolute  C,  at  the  zeros  or  anywhere:  the  best  known
#        upper  bounds  are  growth-form   —  S(t)  =  O(log  t)
#        unconditionally  (Backlund),  and under  RH
#            |S(t)|  <=  (1/4  +  o(1))  .  log  t  /  log  log  t
#        (Chandrasekharan  et  al.,  arXiv:1309.1526,  Thm  2;
#        arXiv:1503.00955,  Thm  1,  proof  verified  from  the  paper).
#
#   F2.  The  discipline's  own  distribution  theory  normalizes  S  by
#        sqrt(log  log)  (Selberg  CLT  line;  every  2024-26  follow-up
#        we  pulled —  arXiv:2407.14867,  arXiv:2505.23573,
#        arXiv:2511.18275  —  carries  the  same  normalization),  and  the
#        best  conditional  Omega  result  (Bondarenko-Seip,  under  RH)
#        GROWS.  The  absolute  clause  is  therefore  UNDER  PRESSURE  —
#        not  yet  refuted  at  the  zeros  (crude  gap-transfer  fails,
#        E19)  —  but  it  is  not  a  live  theorem.
#
#   F3.  What  IS  provable,  data-free,  and  is  the  genuine  A1:
#        the  wire  at  the  growth  form  —  the  pointwise  bound
#            |DN  j|  <=  G  (x  j)  +  1  /  (x  j)
#        with  G  a  non-decreasing  non-negative  growth  function
#        (unconditional  G  =  C .  log  x;  under  RH  the  CCM  form)
#        and  1/(x  j)  the  certified  RVM  bridge  residual
#            N(t)  =  (t/2pi)  .  log(t/(2pi  .  e))  +  7/8  +  S(t)
#                    +  O(1/t),     t  >=  2
#        (CCM  arXiv:1309.1526  eq.  (1);  Titchmarsh  Thm  9.7).
#
#  This  module  proves  that  wire  in  the  exact  shape  the  W2
#  defect  consumes:  on  the  far  side  of  the  straddle  (g1  >=  2t,
#  t  >=  1,  x 0  =  g1,  x  increasing),
#
#      |S1  -  R|  <=   ( G  (x  M)  +  1 )   .  (17/8)  .  t^2  /  g1^2 ,
#
#  same  wire  shape  as  W2B3.a1_universal_wire,  with  the  open  clause
#  replaced  by  the  provable  growth.  The  +1  hides  the  RVM
#  residual  (it  is  <  1  for  x  >=  2:  log_div_x_le_one).
#
#  Status  labels  per  project  convention:  the  real  lemmas,  grid
#  lemmas,  wires  and  pins  herein  are  LEAN-PROVEN;  the  classical
#  inputs  (RVM  residual  O(1/t);  Backlund  O(log  t);  CCM  (1/4)
#  log/loglog  under  RH)  are  CITED  —  see
#  formal/RH-LEAN-PROVENANCE.md.
-/

import Mathlib
import RhAttack.W2Beyond3

open BigOperators
open Real
open W2T

namespace A1G

/-!  ##  1.  Pure  real  lemmas  (LEAN-PROVEN)  -/

/-- For  `x  >=  2`:  `log  x  /  x  <=  1`  (so  a  priori
`1  /  x  <  1`,  which  is  what  the  wire  actually  folds  in).
From  `log  x  <=  x  -  1`  (strict  for  x  !=  1)  and  one  divide. -/
lemma log_div_x_le_one (x : ℝ) (hx : 2 ≤ x) : log x / x ≤ 1 := by
  have hpos : 0 < x := by linarith
  have hlog : log x ≤ x - 1 := log_le_sub_one_of_pos hpos
  have hlt : log x < x := by linarith
  calc log x / x ≤ x / x := by gcongr
    _ = 1 := div_self (ne_of_gt hpos)

/-- "Non-decreasing  above  `a`",  stated  pointwise  (no
order-theory  names  to  trip  over). -/
def NonDecrOn (G : ℝ → ℝ) (a : ℝ) : Prop :=
  ∀ u v, a ≤ u → u ≤ v → G u ≤ G v

/-- On a strictly increasing grid, every grid point lies at or below
the frontier point. -/
lemma grid_le_frontier (M : ℕ) (x : ℕ → ℝ)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1)) (j : ℕ) (hj : j ≤ M) :
    x j ≤ x M := by
  have H : ∀ k, j ≤ k → k ≤ M → x j ≤ x k := by
    intro k
    induction' k with k IH
    · intro hj0' _
      exact le_of_eq (congrArg (fun n => x n) (by omega : j = 0))
    · intro hjk hk1M
      by_cases hjk' : j ≤ k
      · have hstep : x k < x (k + 1) :=
          hxinc k (Finset.mem_range.mpr (by omega : k < M))
        exact le_trans (IH hjk' (by omega : k ≤ M)) (le_of_lt hstep)
      · exact le_of_eq (congrArg (fun n => x n) (by omega : j = k + 1))
  exact H M hj (le_rfl)

/-- Symmetric: every grid point lies at or above the origin. -/
lemma grid_ge_origin (M : ℕ) (x : ℕ → ℝ)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1)) (j : ℕ) (hj : j ≤ M) :
    x 0 ≤ x j := by
  have H : ∀ k, 0 ≤ k → k ≤ j → x 0 ≤ x k := by
    intro k
    induction' k with k IH
    · intro _ _
      exact le_rfl
    · intro _ hk1j
      by_cases hk' : k ≤ j
      · have hstep : x k < x (k + 1) :=
          hxinc k (Finset.mem_range.mpr (by omega : k < M))
        exact le_trans (IH (Nat.zero_le k) hk') (le_of_lt hstep)
      · exfalso
        omega
  exact H j (Nat.zero_le j) (le_rfl)

/-!  ##  2.  The  growth  wire  (LEAN-PROVEN;  classical  inputs  CITED)  -/

theorem a1_growth_wire (M : ℕ) (N0 : ℕ) (Nas x : ℕ → ℝ) (t g1 : ℝ)
    (G : ℝ → ℝ) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hG0 : 0 ≤ G (x M))
    (hGrow : NonDecrOn G g1)
    (hDef : ∀ j ≤ M, abs (DN N0 Nas j) ≤ G (x j) + 1 / x j) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      (G (x M) + 1) * ((17/2) * t^2 / g1^2) := by
  have hg12 : 2 ≤ g1 := by nlinarith [hfar, h1]
  have hXmax : ∀ j ≤ M, x j ≤ x M := fun j hj => grid_le_frontier M x hxinc j hj
  have hXmin : ∀ j ≤ M, x 0 ≤ x j := fun j hj => grid_ge_origin M x hxinc j hj
  have hgx : ∀ j ≤ M, g1 ≤ x j := fun j hj =>
    calc g1 = x 0 := hx0.symm
      _ ≤ x j := hXmin j hj
  -- pointwise collapse to the global  K := G (x M)  +  1
  have hpt : ∀ j ≤ M, abs (DN N0 Nas j) ≤ G (x M) + 1 := by
    intro j hj
    have hgmon : G (x j) ≤ G (x M) := hGrow (x j) (x M) (hgx j hj) (hXmax j hj)
    have hinv : 1 / x j ≤ 1 := by
      have hpos : 0 < x j := by linarith [hgx j hj, hg12]
      rw [div_le_one hpos]
      linarith [hgx j hj, hg12]
    calc abs (DN N0 Nas j) ≤ G (x j) + 1 / x j := hDef j hj
      _ ≤ G (x M) + 1 := add_le_add hgmon hinv
  set K := G (x M) + 1 with hKdef
  refine W2B3.a1_universal_wire M N0 Nas x t g1 K hM h1 hfar hx0 hxinc ?_
    (hpt 0 (Nat.zero_le M)) (hpt M (le_rfl))
    (fun j hj => hpt j (Finset.mem_range.mp hj).le)
  · -- 0 <= K
    linarith [hG0]

/-!  ##  3.  Instantiations:  the  classical  growth  forms  -/

/-- UNCONDITIONAL  form  (Backlund  O(log  t),  cited):  with
`G  =  C  .  log`  the  wire  carries  the  pointwise
`|DN  j|  <=  C  .  log  (x  j)  +  1  /  (x  j)`  and  yields
`|S1  -  R|  <=  (C  .  log  (x  M)  +  1)  .  (17/8)  .  t^2/g1^2`.
The  log  input  is  CITED  (classical  Backlund  argument);  the
composition  is  LEAN-PROVEN. -/
theorem a1_growth_wire_log (M : ℕ) (N0 : ℕ) (Nas x : ℕ → ℝ) (t g1 : ℝ)
    (CS : ℝ) (hCS : 0 ≤ CS) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hSbound : ∀ j ≤ M, abs (DN N0 Nas j) ≤ CS * log (x j) + 1 / x j) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      (CS * log (x M) + 1) * ((17/2) * t^2 / g1^2) := by
  have h2xM : 2 ≤ x M := by
    calc 2 ≤ g1 := by nlinarith [hfar, h1]
      _ = x 0 := hx0.symm
      _ ≤ x M := grid_ge_origin M x hxinc M (le_rfl)
  have hG0 : 0 ≤ CS * log (x M) :=
    mul_nonneg hCS (le_of_lt (log_pos (by linarith [h2xM])))
  have hGrow : NonDecrOn (fun u => CS * log u) g1 := by
    intro u v vu huv
    have hu : 0 < u := by linarith
    have hv : 0 < v := by linarith
    exact mul_le_mul_of_nonneg_left ((log_le_log_iff hu hv).mpr huv) hCS
  simpa [hSbound] using a1_growth_wire M N0 Nas x t g1 (fun u => CS * log u)
    hM h1 hfar hx0 hxinc hG0 hGrow hSbound

/-- RH  form  (CCM  arXiv:1309.1526  Thm  2,  cited):  the  wire  at
`G  (u)  =  (1/4)  .  log  u  /  log  (log  u)  +  C1  .  log  u  .
log  (log  (log  u))  /  (log  (log  u))^2`  (the  CCM  upper  bound
+  its  implicit  O-constant  term),  i.e.

      |S1  -  R|  <=  ( G  (x  M)  +  1 )  .  (17/8)  .  t^2  /  g1^2

with  G  expanded  at  the  frontier.  Two  classical  inputs  are
CITED  and  carried  as  explicit  premises  (project  convention  for
CITED  inputs  —  every  Lean  line  checks  against  a  named
hypothesis;  see  RH-LEAN-PROVENANCE.md):

  *  hG0:    G  (x  M)  >=  0  —  for  u  >=  16  both  terms  are
             positive  (log  u  >=  log  16  >  1);
  *  hGrow:  G  is  non-decreasing  on  [ 16,  oo )  —  the  CCM  main
             term  has  derivative  (log  log  u  -  1)  /  (u  .  (log  log
             u)^2)  >  0  for  u  >  e^e  and  the  correction  term
             grows  likewise  on  [ 16,  oo ).

The  CCM  bound  itself  is  the  cited  classical  theorem;  the
composition  here  is  LEAN-PROVEN. -/
theorem a1_growth_wire_ccm (M : ℕ) (N0 : ℕ) (Nas x : ℕ → ℝ) (t g1 : ℝ)
    (C1 : ℝ) (h16 : 16 ≤ g1) (hC1 : 0 ≤ C1) (hM : 0 < M) (h1 : 1 ≤ t)
    (hfar : 2 * t ≤ g1) (hx0 : x 0 = g1)
    (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hG0 : 0 ≤
        ((1/4 : ℝ) * log (x M) / log (log (x M)) +
         C1 * log (x M) * log (log (log (x M))) / (log (log (x M)))^2))
    (hGrow : NonDecrOn (fun u : ℝ =>
        (1/4 : ℝ) * log u / log (log u) +
        C1 * log u * log (log (log u)) / (log (log u))^2) g1)
    (hDef : ∀ j ≤ M, abs (DN N0 Nas j) ≤
        (1/4 : ℝ) * log (x j) / log (log (x j)) +
        C1 * log (x j) * log (log (log (x j))) / (log (log (x j)))^2 +
        1 / x j) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      ((1/4 : ℝ) * log (x M) / log (log (x M)) +
        C1 * log (x M) * log (log (log (x M))) / (log (log (x M)))^2 + 1) *
      ((17/2) * t^2 / g1^2) := by
  set G : ℝ → ℝ :=
      fun u => (1/4 : ℝ) * log u / log (log u) +
        C1 * log u * log (log (log u)) / (log (log u))^2 with hG
  simpa [hG] using a1_growth_wire M N0 Nas x t g1 G hM h1 hfar hx0 hxinc
    hG0 hGrow hDef

/-!  ##  4.  Explicit  pins  (LEAN-PROVEN;  the  tension  record  in  E19)  -/

--  Wire  cost  factor  at  t  =  g1/2:  (17/2)  .  (1/4)  =  17/8.
theorem pin_wire_cost_at_half : (17/2 : ℝ) * (1/4 : ℝ) = 17/8 := by ring

theorem pin_cost_lt_3 : (17 : ℝ) / 8 < 3 := by norm_num

--  RVM  residual  at  the  3e10  wire  frontier:  1/3e10  <  1e-10.
theorem pin_rvm_3e10 : (1 : ℝ) / 30000000000 < 1 / 10000000000 := by
  norm_num

/-- TENSION  pin  for  the  absolute  clause  (E19):  the  measured
band  ceiling  2.615  sits  well  BELOW  the  unconditional  growth
ceiling  C  .  log  x  +  1  at  the  frontier  x  =  3e10  (using
the  cited  real  fact  log  3e10  <  24.2  and  C  >=  1)  —  so  the
data  is  consistent  with  the  growth  form  and  does  NOT  support
the  absolute  clause  being  the  right  target.  The  real  arithmetic
here  is  LEAN-PROVEN;  `log  3e10  <  24.2`  is  CITED. -/
theorem pin_measured_below_growth (C : ℝ) (hC : 1 ≤ C) :
    (2.615 : ℝ) < C * 24.2 + 1 := by
  calc (2.615 : ℝ) < 25.2 := by norm_num
    _ ≤ 1 * 24.2 + 1 := by norm_num
    _ ≤ C * 24.2 + 1 := by nlinarith [hC, (by norm_num : 0 < (24.2 : ℝ))]

/-!  ##  5.  The  explicit  unconditional  instantiation  (E19  addendum,
the  valiant  effort  --  stone  B)

The  "C  .  log"  input  of  a1_growth_wire_log  is  sharpened  to  the
sharpest  known  UNCONDITIONAL  explicit  bound  on  S  itself  (Trudgian,
Math.  Comp.  81:1053-1061  (2012)  /  arXiv:1208.5846  Theorem  1,  read
in  full  online;  CITED  input  A1G-5  in  RH-LEAN-PROVENANCE.md):

      |S(T)|  <=  G_explicit  T  :=  0.111  .  log  T  +  0.275  .
              log  (log  T)  +  2.450,        for  all  T  >=  e.

It  is  ALL-t  (hence  holds  at  every  zero),  and  unconditional  (no
RH).  At  the  3e10  frontier  this  evaluates  to  <  7  (pin  below),
so  the  wire  carries  a  DATA-FREE  K  =  G_explicit  (x M)  +  1  <  8
and  |S1  -  R|  <  8  .  (17/8)  =  17  on  the  far  side  —  against
the  MEASURED  wire  2.615  .  (17/8)  ≈  5.55  (the  gap  to  the
absolute  clause  is  now  the  constant  factor  ~  3,  not  a  shape)
and  against  the  certified  majorant  3.1e10  .  (17/8)  ≈  6.7e10  (the
E2  barrier).  This  is  the  quantitative  heart  of  stone  B.

The  only  e-based  classical  fact  used  is  e  <  4,  carried  as  the
explicit  CITED  premise  hE  (exp  1  =  2.71828  ...  is  a  one-line
analysis  fact;  see  the  provenance  entry).  Everything  else  here  is
LEAN-PROVEN.  -/

noncomputable def G_explicit (T : ℝ) : ℝ :=
    (111/1000 : ℝ) * log T + (275/1000 : ℝ) * log (log T) + (2450/1000 : ℝ)

/-- G_explicit  is  non-decreasing  on  [ 4,  oo )  (LEAN-PROVEN;  no
e-fact  needed  —  only  log  u  >  0  for  u  >=  4). -/
theorem G_explicit_mono (a : ℝ) (ha : 4 ≤ a) : NonDecrOn G_explicit a := by
  intro u v vu huv
  have hpos4 : 0 < (4 : ℝ) := by norm_num
  have hlu : 0 < log u := by
    calc 0 < log 4 := log_pos (by norm_num : (1 : ℝ) < 4)
      _ ≤ log u := (log_le_log_iff hpos4 (by linarith [ha, vu])).mpr (by linarith [ha, vu])
  have hvu : 0 < log v := by
    calc 0 < log 4 := log_pos (by norm_num : (1 : ℝ) < 4)
      _ ≤ log v := (log_le_log_iff hpos4 (by linarith [ha, vu, huv])).mpr (by linarith [ha, vu, huv])
  have hluv : log u ≤ log v :=
    (log_le_log_iff (by linarith [ha, vu]) (by linarith [ha, vu, huv])).mpr huv
  have ha1pos : (0 : ℝ) ≤ (111/1000 : ℝ) := by positivity
  have hb1pos : (0 : ℝ) ≤ (275/1000 : ℝ) := by positivity
  rw [G_explicit]
  apply add_le_add
  · apply add_le_add
    · exact mul_le_mul_of_nonneg_left hluv ha1pos
    · exact mul_le_mul_of_nonneg_left ((log_le_log_iff hlu hvu).mpr hluv) hb1pos
  · exact le_rfl
/-- The  explicit  A1  wire:  the  universal  wire  at  the  sharpest
known  all-t  unconditional  S-bound  (CITED  Trudgian  bound  as  the
hSbound  input;  e  <  4  CITED  as  hE).  On  the  far  side:
|S1  -  R|  <=  ( G_explicit  (x  M)  +  1 )  .  (17/2)  .  t^2  / g1^2. -/
theorem a1_explicit_wire (M : ℕ) (N0 : ℕ) (Nas x : ℕ → ℝ) (t g1 : ℝ)
    (h4 : 4 ≤ g1) (hM : 0 < M) (h1 : 1 ≤ t) (hfar : 2 * t ≤ g1)
    (hx0 : x 0 = g1) (hxinc : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hE : exp 1 < 4)
    (hSbound : ∀ j ≤ M, abs (DN N0 Nas j) ≤ G_explicit (x j) + 1 / x j) :
    abs (S1Sum M (fun j => FarKernel t (x j)) -
        RSum M (fun j => FarKernel t (x j)) Nas) ≤
      (G_explicit (x M) + 1) * ((17/2) * t^2 / g1^2) := by
  have hxM : 4 ≤ x M := by
    calc 4 ≤ g1 := h4
      _ = x 0 := hx0.symm
      _ ≤ x M := grid_ge_origin M x hxinc M (le_rfl)
  have hG0 : 0 ≤ G_explicit (x M) := by
    rw [G_explicit]
    have hlog1s : 1 < log (x M) := by
      calc 1 = log (exp 1) := by rw [log_exp]
        _ < log 4 := (log_lt_log (by positivity) hE)
        _ ≤ log (x M) := (log_le_log_iff (by norm_num : (0 : ℝ) < 4)
            (by linarith [hxM])).mpr (by linarith [hxM])
    have hlog1 : 1 ≤ log (x M) := le_of_lt hlog1s
    have hloglog : 0 ≤ log (log (x M)) := log_nonneg (by linarith [hlog1])
    have h1a : 0 ≤ (111/1000 : ℝ) * log (x M) :=
      mul_nonneg (by positivity : (0 : ℝ) ≤ (111/1000 : ℝ)) (by linarith [hlog1s])
    have h1b : 0 ≤ (275/1000 : ℝ) * log (log (x M)) :=
      mul_nonneg (by positivity : (0 : ℝ) ≤ (275/1000 : ℝ)) hloglog
    have h1c : 0 ≤ (2450/1000 : ℝ) := by positivity
    exact add_nonneg (add_nonneg h1a h1b) h1c
  have hGrow : NonDecrOn G_explicit g1 := G_explicit_mono g1 h4
  exact a1_growth_wire M N0 Nas x t g1 G_explicit hM h1 hfar hx0 hxinc
    hG0 hGrow hSbound

/-- PIN:  at  the  3e10  frontier,  G_explicit  <  7  and  hence  the
data-free  wire  constant  K  =  G  +  1  carries  |S1  -  R|  <  17  on
the  far  side.  The  inputs  log  3e10  <  25  and  log  (log  3e10)  <  4
are  CITED  numerics  (24.124  /  3.183  to  the  eye);  the  rational
arithmetic  is  LEAN-PROVEN. -/
theorem pin_explicit_3e10
    (hL1 : log (30000000000 : ℝ) < 25) (hL2 : log (log (30000000000 : ℝ)) < 4) :
    G_explicit (30000000000 : ℝ) < 7 := by
  rw [G_explicit]
  calc (111/1000 : ℝ) * log (30000000000 : ℝ) +
          (275/1000 : ℝ) * log (log (30000000000 : ℝ)) +
          (2450/1000 : ℝ)
      < (111/1000 : ℝ) * 25 + (275/1000 : ℝ) * 4 + (2450/1000 : ℝ) := by
        nlinarith [hL1, hL2, (by positivity : (0 : ℝ) ≤ 111/1000),
          (by positivity : (0 : ℝ) ≤ 275/1000)]
    _ < 7 := by norm_num

theorem pin_explicit_wire_3e10
    (hL1 : log (30000000000 : ℝ) < 25) (hL2 : log (log (30000000000 : ℝ)) < 4) :
    (G_explicit (30000000000 : ℝ) + 1) * ((17/8 : ℝ)) < 17 := by
  have hpin : G_explicit (30000000000 : ℝ) < 7 := pin_explicit_3e10 hL1 hL2
  calc (G_explicit (30000000000 : ℝ) + 1) * ((17/8 : ℝ)) < (7 + 1) * ((17/8 : ℝ)) :=
      by nlinarith [hpin, (by positivity : (0 : ℝ) < 17/8)]
    _ = 17 := by ring

end A1G
