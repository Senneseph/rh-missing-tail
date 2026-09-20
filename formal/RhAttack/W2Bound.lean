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


/- E3-1:  Nas is L-Lipschitz against the LEFT endpoint of [a, b] from
|Nas'| <= L on (a, b).  Both one-sided mean-value bounds come from the
same abs hypothesis via abs_le.  (M4 increment 3, E3 setup.) -/
theorem nasAbsSubLe (a b : ℝ) (hab : a < b) (ha : 0 < a) (L : ℝ) (hL0 : 0 ≤ L)
    (hL : ∀ x ∈ Set.Ioo a b, abs (deriv W2K.Nas x) ≤ L)
    (x : ℝ) (hx : x ∈ Set.Icc a b) :
    abs (W2K.Nas x - W2K.Nas a) ≤ L * (b - a) := by
  have hUpos : Set.Icc a b ⊆ Set.Ioi (0 : ℝ) :=
    fun z hz => Set.mem_Ioi.2 (lt_of_lt_of_le ha (Set.mem_Icc.mp hz).1)
  have hNasC : ContinuousOn W2K.Nas (Set.Icc a b) := W2I.hNasCont.mono hUpos
  have hDiffOn : DifferentiableOn ℝ W2K.Nas (interior (Set.Icc a b)) :=
    fun z hz =>
      (W2K.nasHasDerivAt z (lt_of_lt_of_le ha (interior_subset hz).1)).differentiableAt.differentiableWithinAt
  have hax : a ∈ Set.Icc a b := ⟨le_rfl, le_of_lt hab⟩
  have hUpr : W2K.Nas x - W2K.Nas a ≤ L * (x - a) :=
    (convex_Icc a b).image_sub_le_mul_sub_of_deriv_le hNasC hDiffOn
      (fun z hz => by
        have hzoo : z ∈ Set.Ioo a b := by simpa using hz
        exact (abs_le.mp (hL z hzoo)).2) a hax x hx hx.1
  have hLwr : -(L * (x - a)) ≤ W2K.Nas x - W2K.Nas a := by
    have hlw := (convex_Icc a b).mul_sub_le_image_sub_of_le_deriv hNasC hDiffOn
      (fun z hz => by
        have hzoo : z ∈ Set.Ioo a b := by simpa using hz
        exact (abs_le.mp (hL z hzoo)).1) a hax x hx hx.1
    rw [neg_mul] at hlw
    exact hlw
  have haxa : abs (W2K.Nas x - W2K.Nas a) ≤ L * (x - a) :=
    (abs_le (a := W2K.Nas x - W2K.Nas a)).mpr ⟨hLwr, hUpr⟩
  calc
    abs (W2K.Nas x - W2K.Nas a) ≤ L * (x - a) := haxa
    _ ≤ L * (b - a) := mul_le_mul_of_nonneg_left (by linarith [hx.2]) hL0

/- (E3-2)  The kernel gap integral in t-anchor form, for a non-straddle
gap.  The (x - t) primitive is log (pinned extension = log|. |);  the
sm part is left as an ordinary integral.  (M4 increment 3.) -/
theorem e3_kernelGapInt (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht_out : t < a ∨ b < t) :
    ∫ x in a..b, (1 / (x - t) + W2K.Sm x t) =
      (Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t) := by
  -- (x - t) does not vanish on [a, b]
  have hden : ∀ x ∈ Set.uIcc a b, x - t ≠ 0 := by
    intro x hx
    by_contra hz
    have hx0 : x = t := sub_eq_zero.mp hz
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    obtain ⟨hx1, hx2⟩ := Set.mem_Icc.mp hxI
    rcases ht_out with (hlt | hgt)
    · linarith [hlt, hx1, hx0]
    · linarith [hx2, hgt, hx0]
  have hInvC : ContinuousOn (fun x : ℝ => (x - t)⁻¹) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt (fun x hx => (W2I.hSubCA t x).inv (hden x hx) |>.continuousAt)
  have hIntI : IntervalIntegrable (fun x : ℝ => (x - t)⁻¹) volume a b :=
    hInvC.intervalIntegrable
  -- sm is continuous on uIcc (denominator x + t stays off 0 near x ≥ a > 0)
  have hSmCA (x : ℝ) (hx : x ∈ Set.uIcc a b) : ContinuousAt (fun y => W2K.Sm y t) x := by
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    have hpos : 0 < x + t := by linarith [ha, ht, (Set.mem_Icc.mp hxI).1]
    have hsq : 0 < x * x + 1 / 4 := by
      nlinarith [show 0 ≤ x * x from mul_self_nonneg x]
    have hsqop :
        (((id : ℝ → ℝ) * (id : ℝ → ℝ)) + (fun _ : ℝ => (1 : ℝ) / 4)) x ≠ 0 := by
      dsimp
      exact ne_of_gt hsq
    have hb :=
      ((hasDerivAt_id x).mul (hasDerivAt_id x)).add (hasDerivAt_const x (1 / 4))
        |>.inv (hsqop)
    have hbig :=
      (hasDerivAt_id x).add (hasDerivAt_const x t)
      |>.inv (ne_of_gt hpos)
      |>.sub (HasDerivAt.const_mul 2 (hasDerivAt_id x) |>.mul hb)
      |>.sub ((hasDerivAt_id x).mul (hb |>.pow 2))
    have hsm : (fun y : ℝ => W2K.Sm y t) =
        (((id : ℝ → ℝ) + (fun _ : ℝ => t))⁻¹) -
        ((fun y : ℝ => 2 * (id : ℝ → ℝ) y) *
          (((id : ℝ → ℝ) * (id : ℝ → ℝ) + (fun _ : ℝ => (1 : ℝ) / 4))⁻¹)) -
        ((id : ℝ → ℝ) *
          (((id : ℝ → ℝ) * (id : ℝ → ℝ) + (fun _ : ℝ => (1 : ℝ) / 4))⁻¹) ^ 2) := by
      ext y
      dsimp [W2K.Sm]
      by_cases hy : y + t = 0
      · field_simp [hy]
      · field_simp [hy]
    exact hbig.continuousAt.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hsm)
  have hSmC : ContinuousOn (fun x : ℝ => W2K.Sm x t) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt hSmCA
  have hIntS : IntervalIntegrable (fun x : ℝ => W2K.Sm x t) volume a b :=
    hSmC.intervalIntegrable
  -- pointwise rewrite of the integrand (holds at x = t by the division
  -- convention as well)
  have hin : (fun x : ℝ => 1 / (x - t) + W2K.Sm x t) =
      (fun x : ℝ => (x - t)⁻¹ + W2K.Sm x t) := by
    ext x
    by_cases h : x - t = 0
    · field_simp [h]
    · field_simp [h]
  -- the primitive integral  int_a^b (x - t)⁻¹ dx = Real.log (b - t) - Real.log (a - t)
  have hLogD (x : ℝ) (hx : x ∈ Set.uIcc a b) :
      HasDerivAt (fun y : ℝ => Real.log (y - t)) ((x - t)⁻¹) x :=
    (W2I.hSubCA t x).log (hden x hx) |>.congr_deriv (by rw [← inv_eq_one_div])
  have hFTC : ∫ x in a..b, (x - t)⁻¹ = Real.log (b - t) - Real.log (a - t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hLogD hIntI
  calc
    ∫ x in a..b, (1 / (x - t) + W2K.Sm x t)
      = ∫ x in a..b, ((x - t)⁻¹ + W2K.Sm x t) := by
        rw [hin]
      _ = (∫ x in a..b, (x - t)⁻¹) + (∫ x in a..b, W2K.Sm x t) := by
        rw [intervalIntegral.integral_add hIntI hIntS]
      _ = (Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t) := by
        rw [hFTC]

/- Sm (. , t) is continuous on uIcc a b for a > 0, t > 0
(the only denominator that can vanish is x + t, which stays off 0). -/
private theorem smContOn (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t) :
    ContinuousOn (fun x : ℝ => W2K.Sm x t) (Set.uIcc a b) := by
  have hSmCA (x : ℝ) (hx : x ∈ Set.uIcc a b) : ContinuousAt (fun y => W2K.Sm y t) x := by
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    have hpos : 0 < x + t := by linarith [ha, ht, (Set.mem_Icc.mp hxI).1]
    have hsq : 0 < x * x + 1 / 4 := by
      nlinarith [show 0 ≤ x * x from mul_self_nonneg x]
    have hsqop :
        (((id : ℝ → ℝ) * (id : ℝ → ℝ)) + (fun _ : ℝ => (1 : ℝ) / 4)) x ≠ 0 := by
      dsimp
      exact ne_of_gt hsq
    have hb :=
      ((hasDerivAt_id x).mul (hasDerivAt_id x)).add (hasDerivAt_const x (1 / 4))
        |>.inv (hsqop)
    have hbig :=
      (hasDerivAt_id x).add (hasDerivAt_const x t)
      |>.inv (ne_of_gt hpos)
      |>.sub (HasDerivAt.const_mul 2 (hasDerivAt_id x) |>.mul hb)
      |>.sub ((hasDerivAt_id x).mul (hb |>.pow 2))
    have hsm : (fun y : ℝ => W2K.Sm y t) =
        (((id : ℝ → ℝ) + (fun _ : ℝ => t))⁻¹) -
        ((fun y : ℝ => 2 * (id : ℝ → ℝ) y) *
          (((id : ℝ → ℝ) * (id : ℝ → ℝ) + (fun _ : ℝ => (1 : ℝ) / 4))⁻¹)) -
        ((id : ℝ → ℝ) *
          (((id : ℝ → ℝ) * (id : ℝ → ℝ) + (fun _ : ℝ => (1 : ℝ) / 4))⁻¹) ^ 2) := by
      ext y
      dsimp [W2K.Sm]
      by_cases hy : y + t = 0
      · field_simp [hy]
      · field_simp [hy]
    exact hbig.continuousAt.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hsm)
  exact continuousOn_of_forall_continuousAt hSmCA

/- (E3-4)  The per-gap Riemann error for a NON-STRADDLE gap:
the difference between the true integral of DN p' and the left-
endpoint Riemann sum on the gap reduces to Nas a - Nas (.) times
the kernel derivative, bounded by
    L * (b - a) * ∫_a^b |kernel derivative|.
(M4 increment 3.) -/
theorem e3_gapErr (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht_out : t < a ∨ b < t) (L : ℝ) (hL0 : 0 ≤ L)
    (hL : ∀ x ∈ Set.Ioo a b, abs (deriv W2K.Nas x) ≤ L) :
    abs (∫ x in a..b, (W2K.Nas a - W2K.Nas x) * (1 / (x - t) + W2K.Sm x t)) ≤
      L * (b - a) * (∫ x in a..b, abs (1 / (x - t) + W2K.Sm x t)) := by
  -- (x - t) does not vanish on [a, b] (non-straddle)
  have hden : ∀ x ∈ Set.uIcc a b, x - t ≠ 0 := by
    intro x hx
    by_contra hz
    have hx0 : x = t := sub_eq_zero.mp hz
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    obtain ⟨hx1, hx2⟩ := Set.mem_Icc.mp hxI
    rcases ht_out with (hlt | hgt)
    · linarith [hlt, hx1, hx0]
    · linarith [hx2, hgt, hx0]
  have hUpos : Set.uIcc a b ⊆ Set.Ioi (0 : ℝ) := by
    intro x hx
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    exact Set.mem_Ioi.2 (lt_of_lt_of_le ha (Set.mem_Icc.mp hxI).1)
  have hNasC : ContinuousOn W2K.Nas (Set.uIcc a b) := W2I.hNasCont.mono hUpos
  have hInvC : ContinuousOn (fun x : ℝ => (x - t)⁻¹) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt (fun x hx => (W2I.hSubCA t x).inv (hden x hx) |>.continuousAt)
  have hSmC : ContinuousOn (fun x : ℝ => W2K.Sm x t) (Set.uIcc a b) :=
    smContOn t a b hab ha ht
  have hKC : ContinuousOn (fun x : ℝ => (x - t)⁻¹ + W2K.Sm x t) (Set.uIcc a b) :=
    hInvC.add hSmC
  have hFC : ContinuousOn (fun x : ℝ => W2K.Nas a - W2K.Nas x) (Set.uIcc a b) :=
    (continuousOn_const (s := Set.uIcc a b)).sub hNasC
  have hFKC : ContinuousOn
      (fun x : ℝ => (W2K.Nas a - W2K.Nas x) * ((x - t)⁻¹ + W2K.Sm x t)) (Set.uIcc a b) :=
    hFC.mul hKC
  have hIntFK : IntervalIntegrable
      (fun x : ℝ => (W2K.Nas a - W2K.Nas x) * ((x - t)⁻¹ + W2K.Sm x t)) volume a b :=
    hFKC.intervalIntegrable
  have hKabsC : ContinuousOn
      (fun x : ℝ => abs ((x - t)⁻¹ + W2K.Sm x t)) (Set.uIcc a b) :=
    (continuous_abs.continuousOn (s := Set.univ)).comp hKC (fun _ _ => trivial)
  have hIntKabs : IntervalIntegrable
      (fun x : ℝ => abs ((x - t)⁻¹ + W2K.Sm x t)) volume a b :=
    hKabsC.intervalIntegrable
  -- pointwise rewrite 1/(x - t) = (x - t)⁻¹ (division convention)
  have hFK : (fun x : ℝ => (W2K.Nas a - W2K.Nas x) * (1 / (x - t) + W2K.Sm x t)) =
      (fun x : ℝ => (W2K.Nas a - W2K.Nas x) * ((x - t)⁻¹ + W2K.Sm x t)) := by
    ext x
    by_cases h : x - t = 0
    · field_simp [h]
    · field_simp [h]
  have hFbound (x : ℝ) (hx : x ∈ Set.Icc a b) :
      abs (W2K.Nas a - W2K.Nas x) ≤ L * (b - a) := by
    rw [← neg_sub, abs_neg]
    exact nasAbsSubLe a b hab ha L hL0 hL x hx
  have hFabsC : ContinuousOn
      (fun x : ℝ => abs (W2K.Nas a - W2K.Nas x)) (Set.uIcc a b) :=
    (continuous_abs.continuousOn (s := Set.univ)).comp hFC (fun _ _ => trivial)
  have hIntF : IntervalIntegrable
      (fun x : ℝ => abs (W2K.Nas a - W2K.Nas x) *
        abs ((x - t)⁻¹ + W2K.Sm x t)) volume a b :=
    (hFabsC.mul hKabsC).intervalIntegrable
  have hIntG : IntervalIntegrable
      (fun x : ℝ => L * (b - a) * abs ((x - t)⁻¹ + W2K.Sm x t)) volume a b :=
    ((continuousOn_const (s := Set.uIcc a b)).mul hKabsC).intervalIntegrable
  have hmono (x : ℝ) (hx : x ∈ Set.Icc a b) :
      abs (W2K.Nas a - W2K.Nas x) * abs ((x - t)⁻¹ + W2K.Sm x t) ≤
        L * (b - a) * abs ((x - t)⁻¹ + W2K.Sm x t) := by
    calc
      abs (W2K.Nas a - W2K.Nas x) * abs ((x - t)⁻¹ + W2K.Sm x t) =
          abs ((x - t)⁻¹ + W2K.Sm x t) * abs (W2K.Nas a - W2K.Nas x) := by ring
      _ ≤ abs ((x - t)⁻¹ + W2K.Sm x t) * (L * (b - a)) :=
        mul_le_mul_of_nonneg_left (hFbound x hx) (abs_nonneg ((x - t)⁻¹ + W2K.Sm x t))
      _ = L * (b - a) * abs ((x - t)⁻¹ + W2K.Sm x t) := by ring
  calc
    abs (∫ x in a..b, (W2K.Nas a - W2K.Nas x) * (1 / (x - t) + W2K.Sm x t))
      = abs (∫ x in a..b, (W2K.Nas a - W2K.Nas x) * ((x - t)⁻¹ + W2K.Sm x t)) := by
        rw [hFK]
      _ ≤ ∫ x in a..b,
          abs ((W2K.Nas a - W2K.Nas x) * ((x - t)⁻¹ + W2K.Sm x t)) := by
        exact intervalIntegral.abs_integral_le_integral_abs (le_of_lt hab)
      _ = ∫ x in a..b,
          abs (W2K.Nas a - W2K.Nas x) * abs ((x - t)⁻¹ + W2K.Sm x t) := by
        rw [intervalIntegral.integral_congr (fun x _ => by rw [abs_mul])]
      _ ≤ ∫ x in a..b,
          L * (b - a) * abs ((x - t)⁻¹ + W2K.Sm x t) := by
        exact intervalIntegral.integral_mono_on
          (a := a) (b := b) (μ := volume)
          (le_of_lt hab) hIntF hIntG hmono
      _ = L * (b - a) * (∫ x in a..b, abs ((x - t)⁻¹ + W2K.Sm x t)) := by
        rw [intervalIntegral.integral_const_mul (L * (b - a))]
      _ = L * (b - a) * (∫ x in a..b, abs (1 / (x - t) + W2K.Sm x t)) := by
        rw [intervalIntegral.integral_congr (fun x _ => by rw [inv_eq_one_div])]

/- (E3-3)  With t^2 >= 1/2 the kernel derivative does not change sign
on a one-sided gap (K2), so the absolute kernel integral equals the
absolute value of the anchored gap integral:
    ∫_a^b |p'|  =  |log (b - t) - log (a - t) + ∫_a^b Sm|.
(M4 increment 3.) -/
theorem e3_kernelGapAbs (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht2 : 1/2 ≤ t^2) (ht_out : t < a ∨ b < t) :
    ∫ x in a..b, abs (1 / (x - t) + W2K.Sm x t) =
      abs ((Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t)) := by
  rcases ht_out with (hlt | hgt)
  · -- t < a:  p' > 0 on [a, b]
    have hposI (x : ℝ) (hx : x ∈ Set.Icc a b) : 0 < 1 / (x - t) + W2K.Sm x t :=
      W2K.kerDerivPosAbove x t ht (lt_of_lt_of_le hlt (Set.mem_Icc.mp hx).1) ht2
    have hpos (x : ℝ) (hx : x ∈ Set.uIcc a b) : 0 < 1 / (x - t) + W2K.Sm x t := by
      have hxI : x ∈ Set.Icc a b := by
        simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
          min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
      exact hposI x hxI
    have he := e3_kernelGapInt t a b hab ha ht (Or.inl hlt)
    have hf : 0 ≤ (Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t) := by
      rw [← he]
      exact intervalIntegral.integral_nonneg (le_of_lt hab) (fun x hx => le_of_lt (hposI x hx))
    rw [intervalIntegral.integral_congr (fun x hx => by rw [abs_of_nonneg (le_of_lt (hpos x hx))]),
        he,
        abs_of_nonneg hf]
  · -- b < t:  p' < 0 on [a, b]
    have hnegI (x : ℝ) (hx : x ∈ Set.Icc a b) : 1 / (x - t) + W2K.Sm x t < 0 := by
      have hx0 : 0 < x := lt_of_lt_of_le ha (Set.mem_Icc.mp hx).1
      have hxt : x < t := lt_of_le_of_lt (Set.mem_Icc.mp hx).2 hgt
      exact W2K.kerDerivNegBelow x t ht hx0 hxt
    have hneg (x : ℝ) (hx : x ∈ Set.uIcc a b) : 1 / (x - t) + W2K.Sm x t < 0 := by
      have hxI : x ∈ Set.Icc a b := by
        simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
          min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
      exact hnegI x hxI
    have he := e3_kernelGapInt t a b hab ha ht (Or.inr hgt)
    have hf : 0 ≤ ∫ x in a..b, -(1 / (x - t) + W2K.Sm x t) :=
      intervalIntegral.integral_nonneg (le_of_lt hab)
        (fun x hx => le_of_lt (neg_pos_of_neg (hnegI x hx)))
    have hnegInt : (∫ x in a..b, (1 / (x - t) + W2K.Sm x t)) =
        -(∫ x in a..b, -(1 / (x - t) + W2K.Sm x t)) := by
      rw [intervalIntegral.integral_neg, neg_neg]
    have hfE : (Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t) ≤ 0 := by
      rw [← he, hnegInt]
      linarith [hf]
    rw [intervalIntegral.integral_congr (fun x hx => by rw [abs_of_nonpos (hneg x hx).le]),
        intervalIntegral.integral_neg,
        he,
        abs_of_nonpos hfE]

/- (E3-5)  The STRADDLE gap in t-anchor form.  With c the left count
(N(x) = c on (a, b)) and the left-endpoint Riemann value DN(a) = c -
Nas(a), the exact difference between the anchored integral of DN p'
over (a, b) and the Riemann sum is
    Nas(a) - Nas(t) times the log part, minus the midExt integral,
    minus the smoothed Nas-deviation integral.
Pure algebra + integral linearity.  (M4 increment 3.) -/
theorem e3_straddleDecomp (c t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (hta : a < t) (htb : t < b) :
    c * ((Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t ∂volume)) -
    (W2K.Nas t * (Real.log (b - t) - Real.log (a - t)) +
      (∫ x in a..b, W2I.midExt x t ∂volume) +
      (∫ x in a..b, W2K.Nas x * W2K.Sm x t ∂volume)) -
    (c - W2K.Nas a) * ((Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t ∂volume)) =
    (W2K.Nas a - W2K.Nas t) * (Real.log (b - t) - Real.log (a - t)) -
    (∫ x in a..b, W2I.midExt x t ∂volume) -
    (∫ x in a..b, (W2K.Nas x - W2K.Nas a) * W2K.Sm x t ∂volume) := by
  have hUpos : Set.uIcc a b ⊆ Set.Ioi (0 : ℝ) := by
    intro x hx
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    exact Set.mem_Ioi.2 (lt_of_lt_of_le ha (Set.mem_Icc.mp hxI).1)
  have hSmC : ContinuousOn (fun x : ℝ => W2K.Sm x t) (Set.uIcc a b) :=
    smContOn t a b hab ha ht
  have hNasC : ContinuousOn W2K.Nas (Set.uIcc a b) := W2I.hNasCont.mono hUpos
  have hIntS1 : IntervalIntegrable (fun x : ℝ => W2K.Nas a * W2K.Sm x t) volume a b :=
    ((continuousOn_const (s := Set.uIcc a b)).mul hSmC).intervalIntegrable
  have hIntS2 : IntervalIntegrable (fun x : ℝ => (W2K.Nas x - W2K.Nas a) * W2K.Sm x t) volume a b :=
    ((hNasC.sub (continuousOn_const (s := Set.uIcc a b))).mul hSmC).intervalIntegrable
  have hg1 : Set.EqOn (fun x : ℝ => W2K.Nas x * W2K.Sm x t)
      (fun x : ℝ => (W2K.Nas a + (W2K.Nas x - W2K.Nas a)) * W2K.Sm x t) (Set.uIcc a b) := by
    intro _ _
    ring
  have hg2 : Set.EqOn (fun x : ℝ => (W2K.Nas a + (W2K.Nas x - W2K.Nas a)) * W2K.Sm x t)
      (fun x : ℝ => W2K.Nas a * W2K.Sm x t +
        (W2K.Nas x - W2K.Nas a) * W2K.Sm x t) (Set.uIcc a b) := by
    intro _ _
    ring
  have hNS : (∫ x in a..b, W2K.Nas x * W2K.Sm x t ∂volume) =
      W2K.Nas a * (∫ x in a..b, W2K.Sm x t ∂volume) +
        (∫ x in a..b, (W2K.Nas x - W2K.Nas a) * W2K.Sm x t ∂volume) := by
    calc
      (∫ x in a..b, W2K.Nas x * W2K.Sm x t ∂volume)
        = ∫ x in a..b, (W2K.Nas a + (W2K.Nas x - W2K.Nas a)) * W2K.Sm x t ∂volume := by
          rw [intervalIntegral.integral_congr hg1]
        _ = ∫ x in a..b, (W2K.Nas a * W2K.Sm x t +
              (W2K.Nas x - W2K.Nas a) * W2K.Sm x t) ∂volume := by
          rw [intervalIntegral.integral_congr hg2]
        _ = (∫ x in a..b, W2K.Nas a * W2K.Sm x t ∂volume) +
            (∫ x in a..b, (W2K.Nas x - W2K.Nas a) * W2K.Sm x t ∂volume) := by
          rw [intervalIntegral.integral_add hIntS1 hIntS2]
        _ = W2K.Nas a * (∫ x in a..b, W2K.Sm x t ∂volume) +
            (∫ x in a..b, (W2K.Nas x - W2K.Nas a) * W2K.Sm x t ∂volume) := by
          rw [intervalIntegral.integral_const_mul (W2K.Nas a)]
  rw [hNS]
  ring
end W2B
