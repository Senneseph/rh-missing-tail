/-
W2Bound — M4 (increment 1) of docs/W2-LEAN-PLAN.md:  the first
bound lemmas of section 1.4, plus the deferred M3a straddle
lemma.

  (E1)  |DcSum| <= K * TV_part,  TV_part := sum_j |DP j|
        (the triangle form of the spec's E1;  the sharp
        endpoint form  TV = p(G2) - p(t+) + p(t-) - p(G1)
        landed as e1_sharp in increment 2,  via the K2
        monotonicity now living in W2K).
  (E2)  |BTerm| <= K * (|p 0| + |p M|).
  (M3a) midExt (the M3 straddle helper,  W2I.midExt) is
        continuous — hence interval-integrable — on the
        straddle gap [a, b] with 0 < a < t < b.  The glue
        machinery:  midExt = (slope Nas t).update t (Rho t),
        the slope tends to the derivative along the punctured
        neighbourhood  (hasDerivAt_iff_tendsto_slope,  K3),
        and  continuousAt_update_same / _of_ne  close the
        point / off-point cases.

The E3 Riemann-sum error (|I_DN - Dc|) and the E4 assembly
with the one-sided corollary are the next increments:  they
need the piecewise-constant step function of the count N and
the M3 gap identity consumed at the partition.
-/
import Mathlib
import RhAttack.W2Kernel
import RhAttack.W2Integral
import RhAttack.W2Telescope

open BigOperators Filter MeasureTheory
open scoped Topology

namespace W2B

/-! ## E1 / E2 — the finite-sum bounds (pure algebra on the
W2T partition;  K bounds sup |DN| on the relevant indices). -/

/-- (E1) the total-variation bound on Dc (triangle form).  K
must bound |DN j| on the gap indices 0..M-1  (K >= 0 is then
automatic). -/
theorem e1_bound (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) (K : ℝ)
    (hD : ∀ j ∈ Finset.range M, |W2T.DN N0 Nas j| ≤ K) :
    |W2T.DcSum M p N0 Nas| ≤ K * ∑ j ∈ Finset.range M, |W2T.DP p j| := by
  calc
    |W2T.DcSum M p N0 Nas|
      = |∑ j ∈ Finset.range M, W2T.DN N0 Nas j * W2T.DP p j| := rfl
    _ ≤ ∑ j ∈ Finset.range M, |W2T.DN N0 Nas j * W2T.DP p j| := by
      simpa [Real.norm_eq_abs, norm_mul] using
        (norm_sum_le (Finset.range M) (fun (j : ℕ) => W2T.DN N0 Nas j * W2T.DP p j))
    _ ≤ ∑ j ∈ Finset.range M, K * |W2T.DP p j| := by
      apply Finset.sum_le_sum
      intro j hj
      rw [abs_mul]
      exact mul_le_mul_of_nonneg_right (hD j hj) (abs_nonneg _)
    _ = K * ∑ j ∈ Finset.range M, |W2T.DP p j| := by
      rw [Finset.mul_sum]

/-- (E2) the endpoint bound on B:  K must bound |DN 0| and
|DN M|  (K >= 0 is then automatic). -/
theorem e2_bound (M : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) (K : ℝ)
    (hD0 : |W2T.DN N0 Nas 0| ≤ K) (hDM : |W2T.DN N0 Nas M| ≤ K) :
    |W2T.BTerm M p N0 Nas| ≤ K * (|p 0| + |p M|) := by
  calc
    |W2T.BTerm M p N0 Nas|
      = |W2T.DN N0 Nas M * p M - W2T.DN N0 Nas 0 * p 0| := by
        rw [W2T.BTerm]
        ring_nf
    _ ≤ |W2T.DN N0 Nas M * p M| + |W2T.DN N0 Nas 0 * p 0| := abs_sub _ _
    _ = |W2T.DN N0 Nas M| * |p M| + |W2T.DN N0 Nas 0| * |p 0| := by
      rw [abs_mul, abs_mul]
    _ ≤ K * |p M| + K * |p 0| := by
      apply add_le_add
      · exact mul_le_mul_of_nonneg_right hDM (abs_nonneg _)
      · exact mul_le_mul_of_nonneg_right hD0 (abs_nonneg _)
    _ = K * (|p 0| + |p M|) := by ring_nf

/-! ## M3a — the straddle gap:  midExt continuity and
integrability. -/

/-- The removed value:  midExt t t = Rho t. -/
theorem midExtAtPole (t : ℝ) : W2I.midExt t t = W2K.Rho t := by
  dsimp only [W2I.midExt]
  simp

/-- midExt at t equals the slope function of Nas (the secant
quotient) with the value at t updated to Rho t. -/
theorem mExtEqUpdate (t : ℝ) :
    (fun x : ℝ => W2I.midExt x t) = Function.update (slope W2K.Nas t) t (W2K.Rho t) := by
  funext x
  by_cases hx : x = t
  · simp [hx, midExtAtPole t]
  · have hupd : Function.update (slope W2K.Nas t) t (W2K.Rho t) x = slope W2K.Nas t x :=
      Function.update_of_ne hx (W2K.Rho t) (slope W2K.Nas t)
    have hval : W2I.midExt x t = (W2K.Nas x - W2K.Nas t) / (x - t) := by
      dsimp only [W2I.midExt]
      rw [if_neg hx]
    rw [hval, hupd]
    exact (slope_def_field W2K.Nas t x).symm

/-- At t itself (t > 0):  midExt is continuous at t, value
Rho(t).  Proof:  the slope of Nas tends to the derivative
along the punctured neighbourhood  (hasDerivAt_iff_tendsto_slope),
and midExt is that slope with the point t updated to Rho t
(continuousAt_update_same). -/
theorem contAtMid (t : ℝ) (ht : 0 < t) :
    ContinuousAt (fun x : ℝ => W2I.midExt x t) t := by
  have hder : HasDerivAt W2K.Nas (W2K.Rho t) t :=
    W2K.nasHasDerivAt t ht
  have hSlope : Tendsto (slope W2K.Nas t) (𝓝[≠] t) (𝓝 (W2K.Rho t)) :=
    (hasDerivAt_iff_tendsto_slope (f := W2K.Nas) (f' := W2K.Rho t) (x := t)).mp hder
  rw [mExtEqUpdate t, continuousAt_update_same]
  exact hSlope

/-- Off the pole (a ≠ t,  a > 0):  midExt is continuous at a.
The quotient is continuous there  (Nas is C^1,  the
denominator a - t is nonzero),  and updating the point t away
does not change continuity  (continuousAt_update_of_ne). -/
theorem contAtMidAway (t a : ℝ) (hta : a ≠ t) (htapos : 0 < a) :
    ContinuousAt (fun x : ℝ => W2I.midExt x t) a := by
  have hq : ContinuousAt (fun x : ℝ => (W2K.Nas x - W2K.Nas t) / (x - t)) a := by
    apply ContinuousAt.div
    · exact (W2K.nasHasDerivAt a htapos).continuousAt.sub continuousAt_const
    · exact ContinuousAt.sub continuousAt_id continuousAt_const
    · intro h
      exact hta (sub_eq_zero.mp h)
  rw [mExtEqUpdate t, continuousAt_update_of_ne hta, slope_fun_def_field W2K.Nas t]
  exact hq

set_option linter.unusedVariables false in
/-- (M3a)  midExt is continuous on the straddle gap
0 < a < t < b  (ht_in is the straddle contract;  the proof
itself only needs a < b and 0 < a). -/
theorem midExtCont {t a b : ℝ} (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht_in : a < t ∧ t < b) :
    ContinuousOn (fun x : ℝ => W2I.midExt x t) (Set.uIcc a b) := by
  refine continuousOn_of_forall_continuousAt fun x hx => ?_
  have hxI : x ∈ Set.Icc a b := by
    simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
      min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
  have hxpos : 0 < x := lt_of_lt_of_le ha (Set.mem_Icc.mp hxI).1
  by_cases hxt : x = t
  · exact hxt.symm ▸ contAtMid t ht
  · exact contAtMidAway t x hxt hxpos

/-- (M3a-i)  the straddle integrand is interval-integrable. -/
theorem midExtIntegrable {t a b : ℝ} (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht_in : a < t ∧ t < b) :
    IntervalIntegrable (fun x : ℝ => W2I.midExt x t) volume a b :=
  (by
    exact (midExtCont hab ha ht ht_in).intervalIntegrable)


/-! ## E1-sharp — the endpoint form of the total variation
(K2 monotonicity, turned into a partition telescope). -/

/-- (E1-sharp)  Let p be a sequence of kernel values along the
zero partition (length M), and k (k < M) the straddle index.
If p is non-decreasing from straddle up to G2 and
non-increasing from G1 down to straddle, the total variation
telescopes exactly into the two one-sided sums and the isolated
straddle step:
  sum_j |DP j| = |DP k| + (p M - p (k+1)) + (p 0 - p k).
For the concrete kernel p j = Ker (x j) t the side conditions
are exactly K2  (W2K.kerStrictMonoAbove under t^2 >= 1/2;
W2K.kerStrictAntiBelow on (0, t)). -/
theorem e1_sharp (M k : ℕ) (p : ℕ → ℝ) (hM : k < M)
    (hup : ∀ j ∈ Finset.Ico (k + 1) M, p j ≤ p (j + 1))
    (hlow : ∀ j ∈ Finset.range k, p (j + 1) ≤ p j) :
    (∑ j ∈ Finset.range M, |W2T.DP p j|) =
      |W2T.DP p k| + (p M - p (k + 1)) + (p 0 - p k) := by
  have hsplit : Finset.range M = Finset.range (k + 1) ∪ Finset.Ico (k + 1) M := by
    ext i
    simp [Finset.mem_range, Finset.mem_Ico, Finset.mem_union]
    constructor
    · intro hi
      omega
    · intro hi
      omega
  have hdisj : Disjoint (Finset.range (k + 1)) (Finset.Ico (k + 1) M) := by
    rw [Finset.disjoint_left]
    intro i hi hki
    simp [Finset.mem_range, Finset.mem_Ico] at hi hki
    omega
  have hlopt (j : ℕ) (hj : j ∈ Finset.range k) : |W2T.DP p j| = p j - p (j + 1) := by
    rw [W2T.DP]
    have hdp : p (j + 1) ≤ p j := hlow j hj
    rw [← abs_neg, neg_sub, abs_of_nonneg (sub_nonneg.mpr hdp)]
  have hlo : (∑ j ∈ Finset.range k, |W2T.DP p j|) = p 0 - p k := by
    rw [Finset.sum_congr rfl hlopt, W2K.sumRangeTelRev p k]
  have hhipt (j : ℕ) (hj : j ∈ Finset.Ico (k + 1) M) : |W2T.DP p j| = p (j + 1) - p j := by
    rw [W2T.DP, abs_of_nonneg (sub_nonneg.mpr (hup j hj))]
  have hhi : (∑ j ∈ Finset.Ico (k + 1) M, |W2T.DP p j|) = p M - p (k + 1) := by
    rw [Finset.sum_congr rfl hhipt]
    let q : ℕ → ℝ := fun i => p (i + k + 1)
    rw [Finset.sum_Ico_eq_sum_range (fun j : ℕ => p (j + 1) - p j) (k + 1) M]
    rw [Finset.sum_congr rfl (fun i _ => by
      rw [show (k + 1) + i + 1 = (i + 1) + k + 1 by ring,
          show (k + 1) + i = i + k + 1 by ring])]
    rw [W2K.sumRangeTel q (M - (k + 1))]
    dsimp only [q]
    rw [show 0 + k + 1 = k + 1 by ring,
        show (M - (k + 1)) + k + 1 = (M - (k + 1)) + (k + 1) by ring,
        Nat.sub_add_cancel (Nat.succ_le_of_lt hM)]
  calc
    (∑ j ∈ Finset.range M, |W2T.DP p j|)
      = (∑ j ∈ Finset.range (k + 1), |W2T.DP p j|) +
          (∑ j ∈ Finset.Ico (k + 1) M, |W2T.DP p j|) := by
        rw [hsplit, Finset.sum_union hdisj]
      _ = (∑ j ∈ Finset.range k, |W2T.DP p j|) + |W2T.DP p k| +
          (∑ j ∈ Finset.Ico (k + 1) M, |W2T.DP p j|) := by
        rw [Finset.sum_range_succ (fun j => |W2T.DP p j|) k]
      _ = (p 0 - p k) + |W2T.DP p k| + (p M - p (k + 1)) := by
        rw [hlo, hhi]
      _ = |W2T.DP p k| + (p M - p (k + 1)) + (p 0 - p k) := by
        ring

/-- (E1, sharp bound)  under  |DN j| <= K  on the gap indices,
  |DcSum| <= K * (|DP k| + (p M - p (k+1)) + (p 0 - p k)).  The
  side sums are non-negative, so no absolute values are needed on
  them;  only the straddle step keeps its. -/
theorem e1_sharpBound (M k : ℕ) (p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) (K : ℝ)
    (hM : k < M)
    (hD : ∀ j ∈ Finset.range M, |W2T.DN N0 Nas j| ≤ K)
    (hup : ∀ j ∈ Finset.Ico (k + 1) M, p j ≤ p (j + 1))
    (hlow : ∀ j ∈ Finset.range k, p (j + 1) ≤ p j) :
    |W2T.DcSum M p N0 Nas| ≤ K * (|W2T.DP p k| + (p M - p (k + 1)) + (p 0 - p k)) := by
  calc
    |W2T.DcSum M p N0 Nas| ≤ K * (∑ j ∈ Finset.range M, |W2T.DP p j|) :=
      e1_bound M p N0 Nas K hD
    _ = K * (|W2T.DP p k| + (p M - p (k + 1)) + (p 0 - p k)) := by
      rw [e1_sharp M k p hM hup hlow]

end W2B
