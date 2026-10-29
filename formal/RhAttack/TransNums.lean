import Mathlib

/-!
# TransNums — the eleven transcendental numeric brackets, proved in tree (0206)

`W2SAtZeros.sLadderSublnDrift` (0205) is stated with eleven named numeric
premises:  four decade-ratio log LOWER bounds
(`log 3 > 109/100`, `log (10/3) > 119/100`, `log (31946/10000) > 115/100`,
`log (100000000/31946000) > 113/100`)  and  seven log UPPER bounds on the
ladder endpoints (`log 1e7 ≤ 17`, …, `log 1e10 ≤ 24`).  0205 named proving
these brackets in tree a STRETCH GOAL (the project convention cites
elementary transcendental numeric facts, cf.  the `hE : exp 1 < 4` cited
input of `A1Growth.a1_explicit_wire`).  This module PROVES all eleven,
closing that stretch goal.

Method (pure rational arithmetic; no floating point):

* **Upper log bounds**  (seven;  T < exp b implies log T ≤ b).
  From  `exp b = ∑' n, b^n/n!`  with nonnegative terms,  the finite partial
  sum  `∑_{n ≤ N} b^n/n!`  already exceeds T (verified by `norm_num`, each
  with margin ≥ 10%),  hence  T < exp b.

* **Lower log bounds**  (four;  x < log y iff exp x < y).
  The Taylor UPPER bound  `exp a ≤ ∑_{n ≤ N} a^n/n! + a^(N+1)/(N+1)! ·
  (1 − a/(N+2))⁻¹`  (the geometric-tail estimate  `(N+1+k)! ≥ (N+1)!·
  (N+2)^k`,  ratio a/(N+2) < 0.1)  is below the target,  verified by
  `norm_num` on exact rationals (margins ≥ 0.86%).

Each bracket is ONE exact-rational `norm_num` comparison on top of shared
series lemmas;  nothing transcendental is taken on faith.  This is a pure
arithmetic record:  it feeds NO proof of RH and makes NO RH claim — it
supplies the eleven named inputs of the data-side A1-flank reading
`W2SAtZeros.sLadderSublnDrift` (the S-at-zeros running-max ladder from
1e7 to 3e10),  which by 0205/0206 is now a premise-free in-tree theorem
(`W2SAtZeros.sLadderSublnDrift_proved`).
-/

namespace TransNums

open scoped BigOperators
open scoped Nat
open Real

/-! ### exp as a tsum (pinned Mathlib API chain) -/

/-- The tsum identity for the real exponential:
`exp x = ∑' n, x^n/n!`.  Pinned chain:  `Real.exp_eq_exp_ℝ`
(`Analysis/SpecialFunctions/Exponential.lean:214`)  +  `exp_eq_tsum`
(`Analysis/Normed/Algebra/Exponential.lean:163`)  +  smul-to-div. -/
theorem exp_eq_tsum_real (x : ℝ) : exp x = ∑' n : ℕ, x ^ n / n ! := by
  calc exp x = (NormedSpace.exp (x : ℝ) : ℝ) := by rw [← Real.exp_eq_exp_ℝ]
    _ = ∑' n : ℕ, (n !⁻¹ : ℝ) • x ^ n := by
      rw [NormedSpace.exp_eq_tsum (𝕂 := ℝ) (𝔸 := ℝ)]
    _ = ∑' n : ℕ, x ^ n / n ! := by
      apply tsum_congr
      intro n
      rw [smul_eq_mul]
      field_simp

/-! ### Finite-series machinery (all LEAN-PROVEN below) -/

/-- A finite Taylor partial sum is bounded by the tsum (nonnegative terms):
`∑_{n ≤ N} b^n/n! ≤ exp b`  for  b ≥ 0. -/
theorem expFinsum_le_exp (b : ℝ) (hb : 0 ≤ b) (N : ℕ) :
    (∑ n ∈ Finset.range (N + 1), b ^ n / n !) ≤ exp b := by
  have hsum : Summable (fun n : ℕ => b ^ n / n !) := Real.summable_pow_div_factorial b
  rw [exp_eq_tsum_real b]
  exact hsum.sum_le_tsum (Finset.range (N + 1))
    (fun n _hn => div_nonneg (pow_nonneg hb n) (Nat.cast_nonneg (n !)))

/-- The factorial estimate:  `(N+1+k)! ≥ (N+1)! · (N+2)^k`
(each new factor past N+1 is at least N+2). -/
theorem fact_ge_fact_mul_pow (N k : ℕ) : (N + 1 + k)! ≥ (N + 1)! * (N + 2) ^ k := by
  induction k with
  | zero => simp
  | succ k ih =>
    calc Nat.factorial (N + 1 + k.succ) = (N + 1 + k + 1) * Nat.factorial (N + 1 + k) :=
      by { rw [show N + 1 + k.succ = (N + 1 + k) + 1 by omega,
               Nat.factorial_succ (N + 1 + k)] }
    _ ≥ (N + 2) * Nat.factorial (N + 1 + k) :=
      by { simpa [mul_comm] using
            Nat.mul_le_mul_left (Nat.factorial (N + 1 + k))
              (by omega : (N + 1 + k) + 1 ≥ N + 2) }
    _ ≥ (N + 2) * (Nat.factorial (N + 1) * (N + 2) ^ k) :=
      by { simpa [mul_comm] using
            Nat.mul_le_mul_left (N + 2) ih }
    _ = Nat.factorial (N + 1) * (N + 2) ^ k.succ :=
      by { rw [pow_succ]; ring }

/-- Term estimate (the geometric tail dominates the exp terms past N+1):
for  a ≥ 0,  `a^(N+1+m)/(N+1+m)!  ≤  a^(N+1)/(N+1)! · (a/(N+2))^m`. -/
theorem expTerm_le_geometric (a : ℝ) (N m : ℕ) (ha : 0 ≤ a) :
    a ^ (N + 1 + m) / (N + 1 + m)! ≤ (a ^ (N + 1) / (N + 1)!) * (a / (N + 2)) ^ m := by
  have hf : ((N + 1 + m)! : ℝ) ≥ (N + 1)! * (N + 2 : ℝ) ^ m := by
    exact_mod_cast fact_ge_fact_mul_pow N m
  have h1 : a ^ (N + 1 + m) = a ^ (N + 1) * a ^ m := by rw [pow_add]
  have h2 : a ^ m = (N + 2 : ℝ) ^ m * (a / (N + 2)) ^ m := by
    rw [div_pow a (N + 2 : ℝ) m]
    field_simp
  calc a ^ (N + 1 + m) / (N + 1 + m)!
      = (a ^ (N + 1) * a ^ m) / (N + 1 + m)! := by rw [h1]
    _ = (a ^ (N + 1) * ((N + 2 : ℝ) ^ m * (a / (N + 2)) ^ m)) / (N + 1 + m)! := by rw [h2]
    _ ≤ (a ^ (N + 1) * ((N + 2 : ℝ) ^ m * (a / (N + 2)) ^ m)) /
        ((N + 1)! * (N + 2 : ℝ) ^ m) := by
      have hA : 0 ≤ a ^ (N + 1) * ((N + 2 : ℝ) ^ m * (a / (N + 2)) ^ m) := by positivity
      apply (div_le_div_iff₀ (by positivity) (by positivity)).mpr
      nlinarith [hA, hf]
    _ ≤ (a ^ (N + 1) / (N + 1)!) * (a / (N + 2)) ^ m := by
      have hB0 : (N + 2 : ℝ) ^ m ≠ 0 := pow_ne_zero m (by positivity)
      have hD0 : (N + 1)! ≠ (0 : ℝ) :=
        Ne.symm ((by positivity : (0 : ℝ) < (N + 1)!).ne)
      have hcancel :
          (a ^ (N + 1) * ((N + 2 : ℝ) ^ m * (a / (N + 2)) ^ m)) /
            ((N + 1)! * (N + 2 : ℝ) ^ m) =
          (a ^ (N + 1) / (N + 1)!) * (a / (N + 2)) ^ m := by
        field_simp [hB0, hD0]
      linarith [hcancel]

/-- Finite geometric sum ≤ infinite geometric sum:  `∑_{m < k} q^m ≤ (1−q)⁻¹`
for  0 ≤ q < 1. -/
theorem finGeom_le_geom (q : ℝ) (k : ℕ) (hq0 : 0 ≤ q) (hq1 : q < 1) :
    (∑ m ∈ Finset.range k, q ^ m) ≤ (1 - q)⁻¹ := by
  have hsum : Summable (fun m : ℕ => q ^ m) := summable_geometric_of_lt_one hq0 hq1
  calc (∑ m ∈ Finset.range k, q ^ m) ≤ ∑' m : ℕ, q ^ m :=
      hsum.sum_le_tsum (Finset.range k) (fun _m _hm => pow_nonneg hq0 _)
    _ = (1 - q)⁻¹ := by rw [tsum_geometric_of_lt_one hq0 hq1]

/-- **The main upper bound.**  For  a ≥ 0  with  a < N+2,  every partial
sum of the exp series at a is below the N-part plus the geometric tail:

  `∑_{n < k} a^n/n!  ≤  ∑_{n < N+1} a^n/n!  +  a^(N+1)/(N+1)! · (1 − a/(N+2))⁻¹`
  (all  k ≥ N+1). -/
theorem expPartial_le_finsum_plus_geometric (a : ℝ) (N : ℕ) (k : ℕ) (hk : N + 1 ≤ k)
    (ha : 0 ≤ a) (hq : a / (N + 2) < 1) :
    (∑ n ∈ Finset.range k, a ^ n / n !) ≤
      (∑ n ∈ Finset.range (N + 1), a ^ n / n !) +
      a ^ (N + 1) / (N + 1)! * (1 - a / (N + 2))⁻¹ := by
  have hq0 : 0 ≤ a / (N + 2) := by positivity
  let cdef : ℝ := a ^ (N + 1) / (N + 1)!
  let hqf : 0 ≤ (a / (N + 2)) := hq0
  -- sharp induction on the tail length m with k = m + (N+1):
  have hp : ∀ m : ℕ, (∑ n ∈ Finset.range (m + (N + 1)), a ^ n / n !) ≤
      (∑ n ∈ Finset.range (N + 1), a ^ n / n !) + cdef *
        (∑ j ∈ Finset.range m, (a / (N + 2)) ^ j) := by
    intro m
    induction m with
    | zero =>
      have hz : cdef * (∑ j ∈ Finset.range 0, (a / (N + 2)) ^ j) = 0 := by
        rw [Finset.range_zero, Finset.sum_empty]
        ring
      simp only [Nat.zero_add, hz, add_zero]
      exact le_rfl
    | succ m ih =>
      have hterm' : a ^ (m + (N + 1)) / (m + (N + 1))! ≤ cdef * (a / (N + 2)) ^ m := by
        have heq : a ^ (m + (N + 1)) / (m + (N + 1))! =
            a ^ (N + 1 + m) / (N + 1 + m)! := by
          rw [show m + (N + 1) = N + 1 + m by omega]
        simpa [heq, cdef] using expTerm_le_geometric a N m ha
      have hsumSucc : (∑ n ∈ Finset.range (m.succ + (N + 1)), a ^ n / n !) =
          (∑ n ∈ Finset.range (m + (N + 1)), a ^ n / n !) +
          a ^ (m + (N + 1)) / (m + (N + 1))! := by
        rw [show m.succ + (N + 1) = (m + (N + 1)).succ by omega,
            Finset.range_add_one,
            Finset.sum_insert (by
              rw [Finset.mem_range]
              omega)]
        ring
      have hsumQ : (∑ j ∈ Finset.range m.succ, (a / (N + 2)) ^ j) =
          (∑ j ∈ Finset.range m, (a / (N + 2)) ^ j) + (a / (N + 2)) ^ m := by
        rw [Finset.range_add_one,
            Finset.sum_insert (by
              rw [Finset.mem_range]
              omega)]
        ring
      have hnonnegA : 0 ≤ a ^ (m + (N + 1)) / (m + (N + 1))! := by positivity
      calc (∑ n ∈ Finset.range (m.succ + (N + 1)), a ^ n / n !) =
          (∑ n ∈ Finset.range (m + (N + 1)), a ^ n / n !) +
          a ^ (m + (N + 1)) / (m + (N + 1))! :=
            hsumSucc
        _ ≤ (∑ n ∈ Finset.range (N + 1), a ^ n / n !) +
            (cdef * (∑ j ∈ Finset.range m, (a / (N + 2)) ^ j) +
              a ^ (m + (N + 1)) / (m + (N + 1))!) := by
            nlinarith [ih, hnonnegA]
        _ ≤ (∑ n ∈ Finset.range (N + 1), a ^ n / n !) +
            (cdef * (∑ j ∈ Finset.range m.succ, (a / (N + 2)) ^ j)) := by
            rw [hsumQ]
            nlinarith [
              hterm',
              (by positivity : 0 ≤ cdef * (∑ j ∈ Finset.range m.succ, (a / (N + 2)) ^ j))]
  have hsub : (k - (N + 1)) + (N + 1) = k := Nat.sub_add_cancel hk
  have hP := hp (k - (N + 1))
  have hP' : (∑ n ∈ Finset.range k, a ^ n / n !) ≤
      (∑ n ∈ Finset.range (N + 1), a ^ n / n !) +
      cdef * (∑ j ∈ Finset.range (k - (N + 1)), (a / (N + 2)) ^ j) := by
    simpa [hsub] using hP
  have hfq := finGeom_le_geom (a / (N + 2)) (k - (N + 1)) hq0 hq
  have hmul : cdef * (∑ j ∈ Finset.range (k - (N + 1)), (a / (N + 2)) ^ j) ≤
      cdef * (1 - a / (N + 2))⁻¹ := by
    apply mul_le_mul_of_nonneg_left hfq
    exact div_nonneg (pow_nonneg ha (N + 1)) (Nat.cast_nonneg ((N + 1) !))
  nlinarith [hP', hmul]

/-- The exp UPPER bound:  `exp a ≤ ∑_{n < N+1} a^n/n! + a^(N+1)/(N+1)!·(1 − a/(N+2))⁻¹`
for  a ≥ 0,  a/(N+2) < 1.  (Lifts the partial-sum bound to the tsum = exp.) -/
theorem exp_le_finsum_plus_geometric (a : ℝ) (N : ℕ) (ha : 0 ≤ a) (hq : a / (N + 2) < 1) :
    exp a ≤ (∑ n ∈ Finset.range (N + 1), a ^ n / n !) +
      a ^ (N + 1) / (N + 1)! * (1 - a / (N + 2))⁻¹ := by
  have hq0 : 0 ≤ a / (N + 2) := by positivity
  rw [exp_eq_tsum_real a]
  apply Real.tsum_le_of_sum_range_le (fun n =>
    div_nonneg (pow_nonneg ha n) (Nat.cast_nonneg (n !)))
  intro k
  by_cases hk : N + 1 ≤ k
  · exact expPartial_le_finsum_plus_geometric a N k hk ha hq
  · have hk' : k ≤ N := by omega
    set h1 : ℕ → ℝ := fun n => if n ∈ Finset.range k then a ^ n / n ! else 0 with hh1
    have hf_nn : ∀ n, 0 ≤ a ^ n / n ! :=
      fun n => div_nonneg (pow_nonneg ha n) (Nat.cast_nonneg (n !))
    have heq1 : (∑ n ∈ Finset.range k, h1 n) = (∑ n ∈ Finset.range k, a ^ n / n !) := by
      apply Finset.sum_congr rfl
      intro n hn
      by_cases hmem : n ∈ Finset.range k
      · simp_all
      · exfalso
        exact hmem hn
    have hext : (∑ n ∈ Finset.range k, h1 n) = (∑ n ∈ Finset.range (N + 1), h1 n) :=
      Finset.sum_subset (Finset.range_mono (by omega : k ≤ N + 1))
        (fun n _hN1 hknot => by
          by_cases hmem : n ∈ Finset.range k
          · exfalso
            exact hknot hmem
          · simp_all)
    have hle1 : (∑ n ∈ Finset.range (N + 1), h1 n) ≤
        (∑ n ∈ Finset.range (N + 1), a ^ n / n !) :=
      Finset.sum_le_sum (fun n _hN1 => by
        simp only [h1]
        split_ifs
        · exact le_rfl
        · exact hf_nn n)
    have hfinsum : (∑ n ∈ Finset.range k, a ^ n / n !) ≤
        (∑ n ∈ Finset.range (N + 1), a ^ n / n !) := by
      calc (∑ n ∈ Finset.range k, a ^ n / n !) = (∑ n ∈ Finset.range k, h1 n) := heq1.symm
        _ = (∑ n ∈ Finset.range (N + 1), h1 n) := hext
        _ ≤ (∑ n ∈ Finset.range (N + 1), a ^ n / n !) := hle1
    have hrest : 0 ≤ a ^ (N + 1) / (N + 1)! * (1 - a / (N + 2))⁻¹ := by positivity
    linarith [hfinsum, hrest]

/-! ### The 7 UPPER log brackets  (0205 premises `hL1` … `hL7`, in tree)

Each:  T < finsum(b, n ≤ N)  ≤  exp b  ⟹  log T ≤ b,  with the `T < finsum`
step one exact `norm_num` comparison.  Margins (measured):
  exp 17: +36%   exp 18: +16%   exp 19: +15%   exp 20: +27%
  exp 21: +10%   exp 22: +12%   exp 24: +47% -/

/- `log 1e7 ≤ 17`  (finsum(17, n≤17) > 1e7). -/
theorem log_1e7_le_17 : log (10000000 : ℝ) ≤ 17 := by
  have h1 : (10000000 : ℝ) < (∑ n ∈ Finset.range 18, (17 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 18, (17 : ℝ) ^ n / n !) ≤ exp 17 :=
    expFinsum_le_exp 17 (by norm_num) 17
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 10000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 3.1946e7 ≤ 18`  (finsum(18, n≤18) > 31946000). -/
theorem log_3_1946e7_le_18 : log (31946000 : ℝ) ≤ 18 := by
  have h1 : (31946000 : ℝ) < (∑ n ∈ Finset.range 19, (18 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 19, (18 : ℝ) ^ n / n !) ≤ exp 18 :=
    expFinsum_le_exp 18 (by norm_num) 18
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 31946000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 1e8 ≤ 19`  (finsum(19, n≤20) > 1e8). -/
theorem log_1e8_le_19 : log (100000000 : ℝ) ≤ 19 := by
  have h1 : (100000000 : ℝ) < (∑ n ∈ Finset.range 21, (19 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 21, (19 : ℝ) ^ n / n !) ≤ exp 19 :=
    expFinsum_le_exp 19 (by norm_num) 20
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 100000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 3e8 ≤ 20`  (finsum(20, n≤23) > 3e8). -/
theorem log_3e8_le_20 : log (300000000 : ℝ) ≤ 20 := by
  have h1 : (300000000 : ℝ) < (∑ n ∈ Finset.range 24, (20 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 24, (20 : ℝ) ^ n / n !) ≤ exp 20 :=
    expFinsum_le_exp 20 (by norm_num) 23
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 300000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 1e9 ≤ 21`  (finsum(21, n≤25) > 1e9). -/
theorem log_1e9_le_21 : log (1000000000 : ℝ) ≤ 21 := by
  have h1 : (1000000000 : ℝ) < (∑ n ∈ Finset.range 26, (21 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 26, (21 : ℝ) ^ n / n !) ≤ exp 21 :=
    expFinsum_le_exp 21 (by norm_num) 25
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 1000000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 3e9 ≤ 22`  (finsum(22, n≤29) > 3e9). -/
theorem log_3e9_le_22 : log (3000000000 : ℝ) ≤ 22 := by
  have h1 : (3000000000 : ℝ) < (∑ n ∈ Finset.range 30, (22 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 30, (22 : ℝ) ^ n / n !) ≤ exp 22 :=
    expFinsum_le_exp 22 (by norm_num) 29
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 3000000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/- `log 1e10 ≤ 24`  (finsum(24, n≤24) > 1e10). -/
theorem log_1e10_le_24 : log (10000000000 : ℝ) ≤ 24 := by
  have h1 : (10000000000 : ℝ) < (∑ n ∈ Finset.range 25, (24 : ℝ) ^ n / n !) := by norm_num
  have h2 : (∑ n ∈ Finset.range 25, (24 : ℝ) ^ n / n !) ≤ exp 24 :=
    expFinsum_le_exp 24 (by norm_num) 24
  rw [log_le_iff_le_exp (by norm_num : (0 : ℝ) < 10000000000)]
  exact le_of_lt (lt_of_lt_of_le h1 h2)

/-! ### The 4 LOWER log brackets  (0205 premises `hlog3` … `hlogR3`, in tree)

Each:  x < log y  iff  exp x < y  (`lt_log_iff_exp_lt`),  with the Taylor
upper bound  `exp_le_finsum_plus_geometric`  (N = 10,  ratio a/12 < 0.1)
below y.  Margins (measured):
  exp 1.09 < 3:        +0.86%   exp 1.19 < 10/3:  +1.39%
  exp 1.15 < 3.1946:   +1.14%   exp 1.13 < 3.13028: +1.11% -/

/- `log 3 > 109/100`  (exp 1.09 < 3). -/
theorem log3_gt_109_100 : (109 : ℝ) / 100 < log 3 := by
  have hexp0 := exp_le_finsum_plus_geometric ((109 : ℝ) / 100) 10 (by norm_num) (by norm_num)
  have hexp : exp ((109 : ℝ) / 100) ≤
      (∑ n ∈ Finset.range 11, ((109 : ℝ) / 100) ^ n / n !) +
      ((109 : ℝ) / 100) ^ 11 / 11 ! * (1 - (109 / 100) / 12)⁻¹ := by
    convert hexp0 using 1
    norm_num
  have hC : (∑ n ∈ Finset.range 11, ((109 : ℝ) / 100) ^ n / n !) +
      ((109 : ℝ) / 100) ^ 11 / 11 ! * (1 - (109 / 100) / 12)⁻¹ < 3 := by norm_num
  rw [lt_log_iff_exp_lt (by norm_num : (0 : ℝ) < 3)]
  exact lt_of_le_of_lt hexp hC

/- `log (10/3) > 119/100`  (exp 1.19 < 10/3). -/
theorem log10div3_gt_119_100 : (119 : ℝ) / 100 < log (10 / 3) := by
  have hexp0 := exp_le_finsum_plus_geometric ((119 : ℝ) / 100) 10 (by norm_num) (by norm_num)
  have hexp : exp ((119 : ℝ) / 100) ≤
      (∑ n ∈ Finset.range 11, ((119 : ℝ) / 100) ^ n / n !) +
      ((119 : ℝ) / 100) ^ 11 / 11 ! * (1 - (119 / 100) / 12)⁻¹ := by
    convert hexp0 using 1
    norm_num
  have hC : (∑ n ∈ Finset.range 11, ((119 : ℝ) / 100) ^ n / n !) +
      ((119 : ℝ) / 100) ^ 11 / 11 ! * (1 - (119 / 100) / 12)⁻¹ < 10 / 3 := by norm_num
  rw [lt_log_iff_exp_lt (by norm_num : (0 : ℝ) < 10 / 3)]
  exact lt_of_le_of_lt hexp hC

/- `log (31946000/10000000) > 115/100`  (exp 1.15 < 31946/10000). -/
theorem log_r2_gt_115_100 : (115 : ℝ) / 100 < log (31946000 / 10000000) := by
  have hexp0 := exp_le_finsum_plus_geometric ((115 : ℝ) / 100) 10 (by norm_num) (by norm_num)
  have hexp : exp ((115 : ℝ) / 100) ≤
      (∑ n ∈ Finset.range 11, ((115 : ℝ) / 100) ^ n / n !) +
      ((115 : ℝ) / 100) ^ 11 / 11 ! * (1 - (115 / 100) / 12)⁻¹ := by
    convert hexp0 using 1
    norm_num
  have hC : (∑ n ∈ Finset.range 11, ((115 : ℝ) / 100) ^ n / n !) +
      ((115 : ℝ) / 100) ^ 11 / 11 ! * (1 - (115 / 100) / 12)⁻¹ < 31946000 / 10000000 := by
    norm_num
  rw [lt_log_iff_exp_lt (by norm_num : (0 : ℝ) < 31946000 / 10000000)]
  exact lt_of_le_of_lt hexp hC

/- `log (100000000/31946000) > 113/100`  (exp 1.13 < 100000000/31946000). -/
theorem log_r3_gt_113_100 : (113 : ℝ) / 100 < log (100000000 / 31946000) := by
  have hexp0 := exp_le_finsum_plus_geometric ((113 : ℝ) / 100) 10 (by norm_num) (by norm_num)
  have hexp : exp ((113 : ℝ) / 100) ≤
      (∑ n ∈ Finset.range 11, ((113 : ℝ) / 100) ^ n / n !) +
      ((113 : ℝ) / 100) ^ 11 / 11 ! * (1 - (113 / 100) / 12)⁻¹ := by
    convert hexp0 using 1
    norm_num
  have hC : (∑ n ∈ Finset.range 11, ((113 : ℝ) / 100) ^ n / n !) +
      ((113 : ℝ) / 100) ^ 11 / 11 ! * (1 - (113 / 100) / 12)⁻¹ < 100000000 / 31946000 := by
    norm_num
  rw [lt_log_iff_exp_lt (by norm_num : (0 : ℝ) < 100000000 / 31946000)]
  exact lt_of_le_of_lt hexp hC

/-!
##  The 3e10 frontier log pins  (0207)

These two retire the two CITED numerics of  `A1Growth.pin_explicit_3e10`
(`log 3e10 < 25`  /  `log (log 3e10) < 4`):

    log (3e10)  < 25      (3e10 < finsum(25, 24) <= exp 25,
                           finsum margin x1.136)
    log (log 3e10) < 4    (log 3e10 < 25 < exp 4,
                           finsum(4, 7) = 16319/315,  about 51.81)

Exact-rational  norm_num  throughout;  no  external  input.  -/

-- finsum(25, 24) = 33838768480593780243940600998001 /
--                 992717442773183102976  >  3e10 (margin x1.136).
theorem exp25_finsum_gt_3e10 :
    (∑ n ∈ Finset.range 25, (25 : ℝ) ^ n / ↑n !) > 30000000000 := by
  norm_num

-- 3e10 < exp 25  (finsum lower bound + all-terms-nonneg).
theorem exp_25_gt_3e10 : (30000000000 : ℝ) < exp 25 := by
  have h1 : (∑ n ∈ Finset.range 25, (25 : ℝ) ^ n / ↑n !) > 30000000000 :=
    exp25_finsum_gt_3e10
  have h2 : (∑ n ∈ Finset.range 25, (25 : ℝ) ^ n / ↑n !) ≤ exp 25 :=
    expFinsum_le_exp 25 (by norm_num) 24
  exact lt_of_lt_of_le h1 h2

-- log (3e10) < 25  (premise-free;  replaces a CITED numeric).
theorem log_3e10_lt_25 : log (30000000000 : ℝ) < 25 := by
  rw [log_lt_iff_lt_exp (by norm_num : (0 : ℝ) < 30000000000)]
  exact exp_25_gt_3e10

-- finsum(4, 7) = 16319/315 > 25.
theorem exp4_finsum_gt_25 : (∑ n ∈ Finset.range 8, (4 : ℝ) ^ n / ↑n !) > 25 := by
  norm_num

-- 25 < exp 4.
theorem exp_4_gt_25 : (25 : ℝ) < exp 4 := by
  have h1 : (∑ n ∈ Finset.range 8, (4 : ℝ) ^ n / ↑n !) > 25 := exp4_finsum_gt_25
  have h2 : (∑ n ∈ Finset.range 8, (4 : ℝ) ^ n / ↑n !) ≤ exp 4 :=
    expFinsum_le_exp 4 (by norm_num) 7
  exact lt_of_lt_of_le h1 h2

-- log (log 3e10) < 4  (premise-free;  replaces a CITED numeric).
theorem log_log_3e10_lt_4 : log (log (30000000000 : ℝ)) < 4 := by
  have hL : log (30000000000 : ℝ) < 25 := log_3e10_lt_25
  have hmid : log (30000000000 : ℝ) < exp 4 := hL.trans exp_4_gt_25
  have hpos : (0 : ℝ) < log (30000000000 : ℝ) :=
    log_pos (by norm_num : (1 : ℝ) < 30000000000)
  rw [log_lt_iff_lt_exp hpos]
  exact hmid

-- exp 24 < 3e10  (finsum(24, 27) + geometric  tail;  bracket
-- 2.875467e10,  margin x1.043).
theorem exp24_bracket_lt_3e10 :
    (∑ n ∈ Finset.range (27 + 1), (24 : ℝ) ^ n / n !) +
      (24 : ℝ) ^ (27 + 1) / (27 + 1) ! * (1 - 24 / (27 + 2))⁻¹ < 30000000000 := by
  norm_num

-- exp 24 < 3e10.
theorem exp_24_lt_3e10 : exp 24 < (30000000000 : ℝ) := by
  have h0 := exp_le_finsum_plus_geometric 24 27 (by norm_num) (by norm_num)
  exact lt_of_le_of_lt h0 exp24_bracket_lt_3e10

-- 24 < log (3e10)  (premise-free;  the lower log bracket at the frontier).
theorem log_3e10_gt_24 : 24 < log (30000000000 : ℝ) := by
  have h : log (exp 24) < log (30000000000 : ℝ) :=
    log_lt_log (exp_pos 24) exp_24_lt_3e10
  simpa [log_exp] using h

end TransNums
