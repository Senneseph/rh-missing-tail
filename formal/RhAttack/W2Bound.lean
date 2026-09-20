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

/- (E4-a)  The kernel gap is the anchored form, for ANY gap a < b with
a > 0, t > 0 — INCLUDING the straddle gap (the pinned log covers both
sides):
    Ker(b, t) - Ker(a, t) = log (b - t) - log (a - t) + int_a^b Sm.
This is the bridge that makes the Riemann-sum side (a kernel difference,
i.e. a DP_j) equal the anchored integral side (anchor part + smooth
integral), so the per-gap E3 corrections line up at the straddle.
(M4 increment 4.) -/
theorem e4_dpAnchor (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t) :
    W2K.Ker b t - W2K.Ker a t =
      (Real.log (b - t) - Real.log (a - t)) + (∫ x in a..b, W2K.Sm x t ∂volume) := by
  have hKer (g : ℝ) : W2K.Ker g t =
      Real.log (g - t) + Real.log (g + t) - Real.log (g * g + 1 / 4) +
      (1 / 2) / (g * g + 1 / 4) := by
    dsimp [W2K.Ker]
    rw [Real.log_abs]
  have hUpos : Set.uIcc a b ⊆ Set.Ioi (0 : ℝ) := by
    intro x hx
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    exact Set.mem_Ioi.2 (lt_of_lt_of_le ha (Set.mem_Icc.mp hxI).1)
  have hSumPos : ∀ x ∈ Set.uIcc a b, 0 < x + t := by
    intro x hx
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    linarith [ha, ht, (Set.mem_Icc.mp hxI).1]
  have hSqPos : ∀ x ∈ Set.uIcc a b, 0 < x * x + 1 / 4 := by
    intro x _
    nlinarith [show 0 ≤ x * x from mul_self_nonneg x]
  -- the three smooth primitives
  have hSumGlue : (fun y : ℝ => y + t) =
      (fun y : ℝ => (fun x : ℝ => x) y + (fun _ : ℝ => t) y) := by
    ext y
    ring
  have hSqGlue : (fun y : ℝ => y * y + 1 / 4) =
      (fun y : ℝ => (fun x : ℝ => x) y * (fun x : ℝ => x) y + (fun _ : ℝ => 1 / 4) y) := by
    ext y
    ring
  have hLogSum (x : ℝ) (hx : x ∈ Set.uIcc a b) :
      HasDerivAt (fun u : ℝ => Real.log (u + t)) (1 / (x + t)) x :=
    (hasDerivAt_id x |>.add (hasDerivAt_const x t)
      |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hSumGlue.symm)
      |>.congr_deriv (by ring)).log (ne_of_gt (hSumPos x hx))
  have hLogSq (x : ℝ) (hx : x ∈ Set.uIcc a b) :
      HasDerivAt (fun u : ℝ => Real.log (u * u + 1 / 4)) (2 * x / (x * x + 1 / 4)) x := by
    have hder : HasDerivAt (fun u : ℝ => u * u + 1 / 4) (2 * x) x :=
      ((hasDerivAt_id x).mul (hasDerivAt_id x)).add (hasDerivAt_const x (1 / 4))
        |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hSqGlue.symm)
        |>.congr_deriv (by dsimp; ring)
    exact hder.log (ne_of_gt (hSqPos x hx))
      |>.congr_deriv (by field_simp [ne_of_gt (hSqPos x hx)])
  have hInvSq (x : ℝ) (hx : x ∈ Set.uIcc a b) :
      HasDerivAt (fun u : ℝ => -(1 / 2) * (u * u + 1 / 4)⁻¹) (x / (x * x + 1 / 4) ^ 2) x := by
    have hinv : HasDerivAt (fun u : ℝ => (u * u + 1 / 4)⁻¹)
        (-(2 * x) / (x * x + 1 / 4) ^ 2) x := by
      have hder : HasDerivAt (fun u : ℝ => u * u + 1 / 4) (2 * x) x :=
        ((hasDerivAt_id x).mul (hasDerivAt_id x)).add (hasDerivAt_const x (1 / 4))
          |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hSqGlue.symm)
          |>.congr_deriv (by dsimp; ring)
      exact hder.inv (ne_of_gt (hSqPos x hx))
        |>.congr_deriv (by field_simp [ne_of_gt (hSqPos x hx)])
    have hval : (-(1 / 2)) * (-(2 * x) / (x * x + 1 / 4) ^ 2) =
        x / (x * x + 1 / 4) ^ 2 := by
      field_simp [ne_of_gt (hSqPos x hx)]
    exact (hinv.const_mul (-(1 / 2))).congr_deriv hval
  -- continuity / integrability on uIcc a b
  have hdenC : Continuous (fun x : ℝ => x * x + 1 / 4) :=
    (continuous_id.mul continuous_id).add continuous_const
  have hdenNZ' (x : ℝ) : (x * x + 1 / 4 : ℝ) ≠ 0 :=
    ne_of_gt (by nlinarith [show 0 ≤ x * x from mul_self_nonneg x])
  have hG : Continuous (fun u : ℝ => 2 * u / (u * u + 1 / 4)) :=
    continuous_id.const_mul 2 |>.div hdenC (fun x => hdenNZ' x)
  have hH : Continuous (fun u : ℝ => u / (u * u + 1 / 4) ^ 2) :=
    continuous_id.div (hdenC.pow 2) (fun x => pow_ne_zero 2 (hdenNZ' x))
  have hContF : ContinuousOn (fun u : ℝ => 1 / (u + t)) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt (fun x hx =>
      ((hasDerivAt_id x).add (hasDerivAt_const x t)
        |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hSumGlue.symm)
        |>.inv (ne_of_gt (hSumPos x hx))
        |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq (by
          ext y
          rw [inv_eq_one_div]
          rfl))
        |>.continuousAt))
  have hContG : ContinuousOn (fun u : ℝ => 2 * u / (u * u + 1 / 4)) (Set.uIcc a b) :=
    hG.continuousOn (s := Set.uIcc a b)
  have hContH : ContinuousOn (fun u : ℝ => u / (u * u + 1 / 4) ^ 2) (Set.uIcc a b) :=
    hH.continuousOn (s := Set.uIcc a b)
  have hIntF : IntervalIntegrable (fun u : ℝ => 1 / (u + t)) volume a b :=
    hContF.intervalIntegrable
  have hIntG : IntervalIntegrable (fun u : ℝ => 2 * u / (u * u + 1 / 4)) volume a b :=
    hContG.intervalIntegrable
  have hIntH : IntervalIntegrable (fun u : ℝ => u / (u * u + 1 / 4) ^ 2) volume a b :=
    hContH.intervalIntegrable
  rw [hKer b, hKer a]
  have hSm : (∫ x in a..b, W2K.Sm x t ∂volume) =
      (∫ x in a..b, (1 / (x + t)) ∂volume) -
      (∫ x in a..b, (2 * x / (x * x + 1 / 4)) ∂volume) -
      (∫ x in a..b, (x / (x * x + 1 / 4) ^ 2) ∂volume) := by
    have hsmpt : (fun x : ℝ => W2K.Sm x t) =
        (fun x : ℝ => 1 / (x + t) - 2 * x / (x * x + 1 / 4) -
          x / (x * x + 1 / 4) ^ 2) := by
      ext x
      dsimp [W2K.Sm]
    have hIntDiff : IntervalIntegrable
        (fun x : ℝ => 1 / (x + t) - 2 * x / (x * x + 1 / 4)) volume a b :=
      hContF.sub hContG |>.intervalIntegrable
    rw [intervalIntegral.integral_congr (fun x hx => by dsimp [W2K.Sm]),
      intervalIntegral.integral_sub hIntDiff hIntH,
      intervalIntegral.integral_sub hIntF hIntG]
  have hA1 : (∫ x in a..b, (1 / (x + t)) ∂volume) =
      Real.log (b + t) - Real.log (a + t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hLogSum hIntF
  have hA2 : (∫ x in a..b, (2 * x / (x * x + 1 / 4)) ∂volume) =
      Real.log (b * b + 1 / 4) - Real.log (a * a + 1 / 4) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hLogSq hIntG
  have hA3 : (∫ x in a..b, (x / (x * x + 1 / 4) ^ 2) ∂volume) =
      (-(1 / 2) * (b * b + 1 / 4)⁻¹) - (-(1 / 2) * (a * a + 1 / 4)⁻¹) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hInvSq hIntH
  rw [hSm, hA1, hA2, hA3]
  ring

/- (E4-b defs)  The per-gap continuous DN integrals.
gapContNS:  a NON-STRADDLE gap a < b (t < a or b < t):
  int_a^b (c - Nas u) * (1/(u-t) + Sm u t)
the ordinary integral of the left-constant count function times the
kernel derivative.
gapContS:  the STRADDLE gap a < t < b:  the pinned-log finite part.
The pole 1/(x-t) integrates to log|b-t| - log|a-t| ACROSS t
(pinned log covers both sides; the value at the pole itself has
measure zero):
  c * (anchor + intSm) - (Nas t * anchor + intMidExt + intNasSm)
with anchor = log|b-t| - log|a-t|.  (M4 increment 4.) -/
noncomputable def gapContNS (t a b c : ℝ) : ℝ :=
  (∫ u in a..b, (c - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t) ∂volume)

noncomputable def gapContS (t a b c : ℝ) : ℝ :=
  c * (Real.log (b - t) - Real.log (a - t) + (∫ u in a..b, W2K.Sm u t ∂volume)) -
    (W2K.Nas t * (Real.log (b - t) - Real.log (a - t)) +
      (∫ u in a..b, W2I.midExt u t ∂volume) +
      (∫ u in a..b, W2K.Nas u * W2K.Sm u t ∂volume))

/- (E4-b)  The per-gap assembly.  Partition x_0 < ... < x_M (x_j > 0),
p = the kernel values, N0 the boundary count, Nas the Nas values,
k the STRADDLE index (x_k < t < x_{k+1}).  L bounds Nas' on every
gap interior and |Rho t| <= L (so |midExt| <= L pointwise).  Then
    | sum_j IC_j - DcSum |
      <= L * sum_j (x_{j+1} - x_j) * |DP_j|
         + L * (x_{k+1} - x_k)
         + 2 * L * (x_{k+1} - x_k)^2 * (1 / x_k + 6)
where IC_j is the continuous per-gap DN integral (gapContNS on all
gaps except the straddle gap k, which uses the pinned-log finite
part gapContS).  Non-straddle gaps contribute at most
L * gap_j * |DP_j| because the K2 one-sided sign (1/2 <= t^2) makes
int |Ker'| = |DP_j| on every side gap;  the straddle gap adds
L*gap_k + 2*L*gap_k^2*(1/x_k + 6).  (M4 increment 4.) -/
theorem e4_assembly (M k : ℕ) (hM : k < M)
    (x p : ℕ → ℝ) (N0 : ℕ) (Nas : ℕ → ℝ) (t L : ℝ)
    (ht : 0 < t) (ht2 : 1 / 2 ≤ t ^ 2) (hL0 : 0 ≤ L)
    (hRhoLeL : abs (W2K.Rho t) ≤ L)
    (hxPos : ∀ j ∈ Finset.range (M + 1), 0 < x j)
    (hxA : ∀ j ∈ Finset.range M, x j < x (j + 1))
    (hLips : ∀ j ∈ Finset.range M,
        ∀ z ∈ Set.Ioo (x j) (x (j + 1)), abs (deriv W2K.Nas z) ≤ L)
    (hxk : x k < t) (hxt : t < x (k + 1))
    (hp : ∀ j ∈ Finset.range (M + 1), p j = W2K.Ker (x j) t)
    (hpNas : ∀ j ∈ Finset.range (M + 1), Nas j = W2K.Nas (x j)) :
    abs ((∑ j ∈ Finset.range M,
        (if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
         else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ)))) -
        W2T.DcSum M p N0 Nas) ≤
      L * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) +
      L * (x (k + 1) - x k) +
      2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) := by
  set gap := x (k + 1) - x k with hgap_def
  set anchor := Real.log (x (k + 1) - t) - Real.log (x k - t) with hanchor_def
  set smInt : ℝ := (∫ u in (x k)..(x (k + 1)), W2K.Sm u t ∂volume) with hsmInt_def
  have hab : x k < x (k + 1) := hxA k (Finset.mem_range.mpr hM)
  have ha0 : 0 < x k := hxPos k (Finset.mem_range.mpr (Nat.lt_trans hM (Nat.lt_succ_self M)))
  have hgapPos : 0 < gap := sub_pos.mpr hab
  have mk : k ∈ Finset.range M := Finset.mem_range.mpr hM
  have mk1 : k + 1 ∈ Finset.range (M + 1) := Finset.mem_range.mpr (Nat.succ_lt_succ hM)
  have mkR : k ∈ Finset.range (M + 1) :=
    Finset.mem_range.mpr (Nat.lt_trans hM (Nat.lt_succ_self M))
  -- strict monotone partition on the used indices
  have hxs (i j : ℕ) (hi : i < j) (hjM : j < M) : x i < x j := by
    have hclaim (l : ℕ) (hil : i < l) (hle : l ≤ j) : x i < x l := by
      induction' l with l IHl
      · have hf : False := by omega
        exact hf.elim
      · have hile : i ≤ l := by omega
        by_cases hil0 : i < l
        · have hIH : x i < x l := IHl hil0 (by omega)
          have hlx : x l < x (l + 1) := hxA l (Finset.mem_range.mpr (by omega))
          exact lt_trans hIH hlx
        · have hie : i = l := by omega
          subst hie
          exact hxA i (Finset.mem_range.mpr (by omega))
    exact hclaim j hi (le_rfl)
  -- every non-straddle gap lies entirely on one side of t
  have hOut (j : ℕ) (hjM : j ∈ Finset.range M) (hne : j ≠ k) :
      t < x j ∨ x (j + 1) < t := by
    by_cases hjk : j < k
    · right
      by_cases hje : j + 1 = k
      · subst hje
        exact lt_of_le_of_lt le_rfl hxk
      · have hj1k : j + 1 < k := by omega
        exact lt_of_le_of_lt (le_of_lt (hxs (j + 1) k hj1k hM)) hxk
    · left
      by_cases hje : k + 1 = j
      · subst hje
        exact hxt
      · have hk1j : k + 1 < j := by omega
        exact lt_of_lt_of_le hxt (le_of_lt (hxs (k + 1) j hk1j (Finset.mem_range.mp hjM)))
  -- |Sm u| <= 1/x_k + 6  pointwise on the straddle gap (u > 0)
  have hSmBdPt (u : ℝ) (hu : u ∈ Set.Icc (x k) (x (k + 1))) :
      abs (W2K.Sm u t) ≤ 1 / x k + 6 := by
    have huI1 : x k ≤ u := (Set.mem_Icc.mp hu).1
    have hup : 0 < u := lt_of_lt_of_le ha0 huI1
    dsimp [W2K.Sm]
    calc
      abs (1 / (u + t) - 2 * u / (u * u + 1 / 4) - u / (u * u + 1 / 4) ^ 2) ≤
          (abs (1 / (u + t)) + abs (2 * u / (u * u + 1 / 4))) +
          abs (u / (u * u + 1 / 4) ^ 2) := by
        calc
          abs (1 / (u + t) - 2 * u / (u * u + 1 / 4) - u / (u * u + 1 / 4) ^ 2) ≤
              abs (1 / (u + t) - 2 * u / (u * u + 1 / 4)) +
              abs (u / (u * u + 1 / 4) ^ 2) := by
            simpa using abs_sub (1 / (u + t) - 2 * u / (u * u + 1 / 4))
              (u / (u * u + 1 / 4) ^ 2)
          _ ≤ (abs (1 / (u + t)) + abs (2 * u / (u * u + 1 / 4))) +
              abs (u / (u * u + 1 / 4) ^ 2) := by
            simpa [add_assoc] using
              add_le_add (abs_sub (1 / (u + t)) (2 * u / (u * u + 1 / 4))) le_rfl
      _ ≤ 1 / x k + 2 + 4 := by
        have h1 : abs (1 / (u + t)) ≤ 1 / x k := by
          calc
            abs (1 / (u + t)) = 1 / (u + t) :=
              abs_of_nonneg (div_nonneg (by norm_num) (by linarith [hup, ht]))
            _ ≤ 1 / u := one_div_le_one_div_of_le hup (by linarith [ht, hup])
            _ ≤ 1 / x k := one_div_le_one_div_of_le ha0 huI1
        have h2 : abs (2 * u / (u * u + 1 / 4)) ≤ 2 := by
          have hden : 0 < u * u + 1 / 4 := by
            nlinarith [show 0 ≤ u * u from mul_self_nonneg u]
          calc
            abs (2 * u / (u * u + 1 / 4)) = 2 * u / (u * u + 1 / 4) :=
              abs_of_nonneg (div_nonneg (show 0 ≤ 2 * u from by linarith [hup]) (le_of_lt hden))
            _ = 2 * (u / (u * u + 1 / 4)) := by ring
            _ ≤ 2 * 1 := by
              have hu1 : u / (u * u + 1 / 4) ≤ 1 := by
                rw [div_le_one hden]
                nlinarith [sq_nonneg (u - 1 / 2)]
              exact mul_le_mul_of_nonneg_left hu1 (show 0 ≤ 2 from by norm_num)
            _ = 2 := by norm_num
        have h3 : abs (u / (u * u + 1 / 4) ^ 2) ≤ 4 := by
          have hden : 0 < u * u + 1 / 4 := by
            nlinarith [show 0 ≤ u * u from mul_self_nonneg u]
          calc
            abs (u / (u * u + 1 / 4) ^ 2) = u / (u * u + 1 / 4) ^ 2 :=
              abs_of_nonneg (div_nonneg (le_of_lt hup) (pow_nonneg (le_of_lt hden) 2))
            _ = (u / (u * u + 1 / 4)) * (1 / (u * u + 1 / 4)) := by
              field_simp [hden.ne']
            _ ≤ 1 * (1 / (u * u + 1 / 4)) := by
              have hDnn : 0 ≤ 1 / (u * u + 1 / 4) :=
                div_nonneg (by norm_num) (le_of_lt hden)
              have hu1 : u / (u * u + 1 / 4) ≤ 1 := by
                rw [div_le_one hden]
                nlinarith [sq_nonneg (u - 1 / 2)]
              simpa [mul_comm] using mul_le_mul_of_nonneg_left hu1 hDnn
            _ = 1 / (u * u + 1 / 4) := by norm_num
            _ ≤ 1 / (1 / 4) := one_div_le_one_div_of_le (by norm_num) (by nlinarith)
            _ = 4 := by norm_num
        exact add_le_add (add_le_add h1 h2) h3
      _ = 1 / x k + 6 := by ring
  have hSmCk : ContinuousOn (fun u : ℝ => W2K.Sm u t) (Set.uIcc (x k) (x (k + 1))) :=
    smContOn t (x k) (x (k + 1)) hab ha0 ht
  have hSmAbsC : ContinuousOn (fun u : ℝ => abs (W2K.Sm u t))
      (Set.uIcc (x k) (x (k + 1))) :=
    (continuous_abs.continuousOn (s := Set.univ)).comp hSmCk (fun _ _ => trivial)
  have hIntSmAbs : IntervalIntegrable (fun u : ℝ => abs (W2K.Sm u t)) volume (x k) (x (k + 1)) :=
    hSmAbsC.intervalIntegrable
  have hIntConstS : IntervalIntegrable (fun u : ℝ => 1 / x k + 6) volume (x k) (x (k + 1)) :=
    (continuousOn_const (s := Set.uIcc (x k) (x (k + 1)))).intervalIntegrable
  -- |Sm| integral bound on the straddle gap
  have hSmBd : (∫ u in (x k)..(x (k + 1)), abs (W2K.Sm u t) ∂volume) ≤
      gap * (1 / x k + 6) := by
    calc
      (∫ u in (x k)..(x (k + 1)), abs (W2K.Sm u t) ∂volume) ≤
          (∫ u in (x k)..(x (k + 1)), (1 / x k + 6) ∂volume) := by
        exact intervalIntegral.integral_mono_on (a := x k) (b := x (k + 1)) (μ := volume)
          (le_of_lt hab) hIntSmAbs hIntConstS (fun u hu => hSmBdPt u hu)
      _ = gap * (1 / x k + 6) := by
        rw [intervalIntegral.integral_const, hgap_def]
        ring
  -- the straddle gap exact decomposition (E3-5 + E4-a)
  have hDecomp :
      gapContS t (x k) (x (k + 1)) ((N0 : ℝ) + (k : ℝ)) - W2T.DN N0 Nas k * W2T.DP p k =
        (W2K.Nas (x k) - W2K.Nas t) * anchor -
        (∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume) -
        (∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume) := by
    have he4 := e4_dpAnchor t (x k) (x (k + 1)) hab ha0 ht
    have hs := e3_straddleDecomp ((N0 : ℝ) + (k : ℝ)) t (x k) (x (k + 1)) hab ha0 ht hxk hxt
    rw [gapContS, W2T.DN, W2T.DP]
    rw [hp k mkR, hp (k + 1) mk1]
    rw [hpNas k mkR]
    rw [he4]
    rw [hs]
  -- |anchor| via the DP form
  have hAnc : abs anchor ≤ abs (W2T.DP p k) + gap * (1 / x k + 6) := by
    have he4 := e4_dpAnchor t (x k) (x (k + 1)) hab ha0 ht
    have hDPEq : p (k + 1) - p k = W2T.DP p k := by dsimp [W2T.DP]
    calc
      abs anchor = abs ((W2K.Ker (x (k + 1)) t - W2K.Ker (x k) t) - smInt) := by
        rw [show (anchor : ℝ) = Real.log (x (k + 1) - t) - Real.log (x k - t) from rfl]
        have hlin : Real.log (x (k + 1) - t) - Real.log (x k - t) =
            W2K.Ker (x (k + 1)) t - W2K.Ker (x k) t - smInt := by
          linarith [he4]
        rw [hlin]
      _ ≤ abs (W2K.Ker (x (k + 1)) t - W2K.Ker (x k) t) + abs smInt := by
        exact abs_sub (W2K.Ker (x (k + 1)) t - W2K.Ker (x k) t) smInt
      _ = abs (p (k + 1) - p k) + abs smInt := by
        rw [show W2K.Ker (x (k + 1)) t = p (k + 1) from (hp (k + 1) mk1).symm,
          show W2K.Ker (x k) t = p k from (hp k mkR).symm]
      _ = abs (W2T.DP p k) + abs smInt := by rw [hDPEq]
      _ ≤ abs (W2T.DP p k) + gap * (1 / x k + 6) := by
        exact add_le_add le_rfl
          (le_trans (intervalIntegral.abs_integral_le_integral_abs (le_of_lt hab)) hSmBd)
  -- |Nas a - Nas t| term
  have hLtStr (z : ℝ) (hz : z ∈ Set.Ioo (x k) t) : abs (deriv W2K.Nas z) ≤ L := by
    have hhi : z < x (k + 1) := by linarith [hz.2, hxt]
    exact hLips k mk z ⟨hz.1, hhi⟩
  have hNasT : abs (W2K.Nas (x k) - W2K.Nas t) ≤ L * (t - x k) := by
    rw [← neg_sub, abs_neg]
    exact nasAbsSubLe (x k) t hxk ha0 L hL0 hLtStr t ⟨le_of_lt hxk, le_rfl⟩
  have hE1 : abs ((W2K.Nas (x k) - W2K.Nas t) * anchor) ≤
      L * gap * abs (W2T.DP p k) + L * gap ^ 2 * (1 / x k + 6) := by
    calc
      abs ((W2K.Nas (x k) - W2K.Nas t) * anchor) =
          abs (W2K.Nas (x k) - W2K.Nas t) * abs anchor := by rw [abs_mul]
      _ ≤ L * (t - x k) * abs anchor := by
        simpa [mul_comm] using mul_le_mul_of_nonneg_left hNasT (abs_nonneg anchor)
      _ ≤ L * gap * abs anchor := by
        have htgap : t - x k ≤ gap := by linarith [hxt]
        have hL1 : L * (t - x k) ≤ L * gap := by
          simpa [mul_comm] using mul_le_mul_of_nonneg_right htgap hL0
        simpa [mul_comm] using mul_le_mul_of_nonneg_left hL1 (abs_nonneg anchor)
      _ ≤ L * gap * abs (W2T.DP p k) + L * gap ^ 2 * (1 / x k + 6) := by
        have hgap : 0 ≤ L * gap := by nlinarith [hL0, hgapPos]
        have h1 : L * gap * abs anchor ≤
            L * gap * (abs (W2T.DP p k) + gap * (1 / x k + 6)) := by
          simpa [mul_comm] using mul_le_mul_of_nonneg_left hAnc hgap
        calc
          L * gap * abs anchor ≤
              L * gap * (abs (W2T.DP p k) + gap * (1 / x k + 6)) := h1
          _ = L * gap * abs (W2T.DP p k) + L * gap * (gap * (1 / x k + 6)) := by ring
          _ = L * gap * abs (W2T.DP p k) + L * gap ^ 2 * (1 / x k + 6) := by ring
  -- |midExt| integral bound
  have hMidC : ContinuousOn (fun u : ℝ => W2I.midExt u t) (Set.uIcc (x k) (x (k + 1))) :=
    midExtCont hab ha0 ht ⟨hxk, hxt⟩
  have hMidPt (u : ℝ) (hu : u ∈ Set.Icc (x k) (x (k + 1))) : abs (W2I.midExt u t) ≤ L := by
    by_cases huet : u = t
    · subst huet
      rw [midExtAtPole u]
      exact hRhoLeL
    · have huI1 : x k ≤ u := (Set.mem_Icc.mp hu).1
      have huI2 : u ≤ x (k + 1) := (Set.mem_Icc.mp hu).2
      have habsm : abs (W2I.midExt u t) = abs ((W2K.Nas u - W2K.Nas t) / (u - t)) := by
        dsimp [W2I.midExt]
        simp [huet]
      rw [habsm, abs_div]
      by_cases hut : u < t
      · have hLu (z : ℝ) (hz : z ∈ Set.Ioo u t) : abs (deriv W2K.Nas z) ≤ L := by
          have hlo : x k < z := lt_of_le_of_lt huI1 hz.1
          have hhi : z < x (k + 1) := by linarith [hz.2, hxt]
          exact hLips k mk z ⟨hlo, hhi⟩
        have h1 : abs (W2K.Nas u - W2K.Nas t) ≤ L * (t - u) := by
          have hbase := nasAbsSubLe u t hut (lt_of_lt_of_le ha0 huI1) L hL0 hLu
            t ⟨le_of_lt hut, le_rfl⟩
          rw [← neg_sub, abs_neg]
          exact hbase
        have hdpos : 0 < t - u := sub_pos.mpr hut
        calc
          abs (W2K.Nas u - W2K.Nas t) / abs (u - t) =
              abs (W2K.Nas u - W2K.Nas t) / (t - u) := by
            rw [show abs (u - t) = t - u from by
              rw [abs_of_neg (by linarith)]
              ring]
          _ = abs (W2K.Nas u - W2K.Nas t) * (t - u)⁻¹ := by
            rw [div_eq_mul_inv]
          _ ≤ (L * (t - u)) * (t - u)⁻¹ := by
            exact mul_le_mul_of_nonneg_right h1
              (show 0 ≤ (t - u)⁻¹ from inv_nonneg.mpr (le_of_lt hdpos))
          _ = L := by field_simp [hdpos.ne']
      · have htu : t < u := by
          by_contra hz
          have hzle : u ≤ t := not_lt.mp hz
          have hut' : u < t := lt_of_le_of_ne hzle huet
          exact (by assumption : ¬ u < t) hut'
        have hLt_u (z : ℝ) (hz : z ∈ Set.Ioo t u) : abs (deriv W2K.Nas z) ≤ L := by
          have hlo : x k < z := by linarith [hxk, hz.1]
          have hhi : z < x (k + 1) := by linarith [hz.2, huI2]
          exact hLips k mk z ⟨hlo, hhi⟩
        have h1 : abs (W2K.Nas u - W2K.Nas t) ≤ L * (u - t) :=
          nasAbsSubLe t u htu ht L hL0 hLt_u u ⟨le_of_lt htu, le_rfl⟩
        have hdpos : 0 < u - t := sub_pos.mpr htu
        calc
          abs (W2K.Nas u - W2K.Nas t) / abs (u - t) =
              abs (W2K.Nas u - W2K.Nas t) / (u - t) := by
            rw [show abs (u - t) = u - t from abs_of_pos (sub_pos.mpr htu)]
          _ = abs (W2K.Nas u - W2K.Nas t) * (u - t)⁻¹ := by
            rw [div_eq_mul_inv]
          _ ≤ (L * (u - t)) * (u - t)⁻¹ := by
            exact mul_le_mul_of_nonneg_right h1
              (show 0 ≤ (u - t)⁻¹ from inv_nonneg.mpr (le_of_lt hdpos))
          _ = L := by field_simp [hdpos.ne']
  have hMidInt : abs ((∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume)) ≤ L * gap := by
    have hMidAbsC : ContinuousOn (fun u : ℝ => abs (W2I.midExt u t))
        (Set.uIcc (x k) (x (k + 1))) :=
      (continuous_abs.continuousOn (s := Set.univ)).comp hMidC (fun _ _ => trivial)
    have hIntMidAbs : IntervalIntegrable (fun u : ℝ => abs (W2I.midExt u t)) volume (x k) (x (k + 1)) :=
      hMidAbsC.intervalIntegrable
    have hIntL : IntervalIntegrable (fun u : ℝ => (L : ℝ)) volume (x k) (x (k + 1)) :=
      (continuousOn_const (s := Set.uIcc (x k) (x (k + 1)))).intervalIntegrable
    calc
      abs ((∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume)) ≤
          (∫ u in (x k)..(x (k + 1)), abs (W2I.midExt u t) ∂volume) := by
        exact intervalIntegral.abs_integral_le_integral_abs (le_of_lt hab)
      _ ≤ (∫ u in (x k)..(x (k + 1)), (L : ℝ) ∂volume) := by
        exact intervalIntegral.integral_mono_on (a := x k) (b := x (k + 1)) (μ := volume)
          (le_of_lt hab) hIntMidAbs hIntL (fun u hu => hMidPt u hu)
      _ = L * gap := by
        rw [intervalIntegral.integral_const, hgap_def]
        ring
  -- |(Nas u - Nas a) * Sm| integral bound
  have hNasSm : abs ((∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume)) ≤
      L * gap * (∫ u in (x k)..(x (k + 1)), abs (W2K.Sm u t) ∂volume) := by
    have hNasCk : ContinuousOn W2K.Nas (Set.uIcc (x k) (x (k + 1))) :=
      W2I.hNasCont.mono (by
        intro z hz
        have hzI : z ∈ Set.Icc (x k) (x (k + 1)) := by
          simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
            min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hz
        exact Set.mem_Ioi.2 (lt_of_lt_of_le ha0 (Set.mem_Icc.mp hzI).1))
    have hPt (u : ℝ) (hu : u ∈ Set.Icc (x k) (x (k + 1))) :
        abs (W2K.Nas u - W2K.Nas (x k)) ≤ L * gap :=
      nasAbsSubLe (x k) (x (k + 1)) hab ha0 L hL0 (hLips k mk) u hu
    calc
      abs ((∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume)) ≤
          (∫ u in (x k)..(x (k + 1)), abs ((W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t) ∂volume) := by
        exact intervalIntegral.abs_integral_le_integral_abs (le_of_lt hab)
      _ = (∫ u in (x k)..(x (k + 1)), abs (W2K.Nas u - W2K.Nas (x k)) * abs (W2K.Sm u t) ∂volume) := by
        rw [intervalIntegral.integral_congr (fun u hu => by rw [abs_mul])]
      _ ≤ (∫ u in (x k)..(x (k + 1)), (L * gap) * abs (W2K.Sm u t) ∂volume) := by
        have hContA : ContinuousOn (fun u : ℝ => W2K.Nas u - W2K.Nas (x k))
            (Set.uIcc (x k) (x (k + 1))) :=
          hNasCk.sub (continuousOn_const (s := Set.uIcc (x k) (x (k + 1))))
        have hContAabs : ContinuousOn (fun u : ℝ => abs (W2K.Nas u - W2K.Nas (x k)))
            (Set.uIcc (x k) (x (k + 1))) :=
          (continuous_abs.continuousOn (s := Set.univ)).comp hContA (fun _ _ => trivial)
        have hSmAbsC2 : ContinuousOn (fun u : ℝ => abs (W2K.Sm u t))
            (Set.uIcc (x k) (x (k + 1))) :=
          (continuous_abs.continuousOn (s := Set.univ)).comp hSmCk (fun _ _ => trivial)
        have hContAB : ContinuousOn
            (fun u : ℝ => abs (W2K.Nas u - W2K.Nas (x k)) * abs (W2K.Sm u t))
            (Set.uIcc (x k) (x (k + 1))) :=
          hContAabs.mul hSmAbsC2
        have hIntLHS : IntervalIntegrable
            (fun u : ℝ => abs (W2K.Nas u - W2K.Nas (x k)) * abs (W2K.Sm u t))
            volume (x k) (x (k + 1)) :=
          hContAB.intervalIntegrable
        have hIntRHS : IntervalIntegrable
            (fun u : ℝ => (L * gap) * abs (W2K.Sm u t)) volume (x k) (x (k + 1)) :=
          ((continuousOn_const (s := Set.uIcc (x k) (x (k + 1)))).mul hSmCk.abs).intervalIntegrable
        exact intervalIntegral.integral_mono_on (a := x k) (b := x (k + 1)) (μ := volume)
          (le_of_lt hab) hIntLHS hIntRHS
          (fun u hu => by
            simpa [mul_comm] using
              mul_le_mul_of_nonneg_left (hPt u hu) (abs_nonneg (W2K.Sm u t)))
      _ = L * gap * (∫ u in (x k)..(x (k + 1)), abs (W2K.Sm u t) ∂volume) := by
        rw [intervalIntegral.integral_const_mul]
  -- the straddle per-gap bound
  have hEjS : abs (gapContS t (x k) (x (k + 1)) ((N0 : ℝ) + (k : ℝ)) -
        W2T.DN N0 Nas k * W2T.DP p k) ≤
      L * (x (k + 1) - x k) * abs (W2T.DP p k) +
      (L * (x (k + 1) - x k) + 2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)) := by
    rw [hDecomp]
    calc
      abs ((W2K.Nas (x k) - W2K.Nas t) * anchor - (∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume) - (∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume)) ≤ abs ((W2K.Nas (x k) - W2K.Nas t) * anchor - (∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume)) + abs (∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume) := by
        exact abs_sub
          ((W2K.Nas (x k) - W2K.Nas t) * anchor - (∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume))
          ((∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume))
      _ ≤ abs (W2K.Nas (x k) - W2K.Nas t) * abs anchor + abs (∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume) + abs (∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume) := by
        simpa [add_assoc] using add_le_add
          (abs_sub ((W2K.Nas (x k) - W2K.Nas t) * anchor)
            ((∫ u in (x k)..(x (k + 1)), W2I.midExt u t ∂volume)))
          le_rfl
      _ ≤ (L * gap * abs (W2T.DP p k) + L * gap ^ 2 * (1 / x k + 6)) +
          L * gap + L * gap * (gap * (1 / x k + 6)) := by
        have hE3b : abs (∫ u in (x k)..(x (k + 1)),
            (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume) ≤
            L * gap * (gap * (1 / x k + 6)) := by
          calc
            abs (∫ u in (x k)..(x (k + 1)), (W2K.Nas u - W2K.Nas (x k)) * W2K.Sm u t ∂volume) ≤
                L * gap * (∫ u in (x k)..(x (k + 1)), abs (W2K.Sm u t) ∂volume) := hNasSm
            _ ≤ L * gap * (gap * (1 / x k + 6)) := by
              simpa [mul_assoc, mul_comm] using
                mul_le_mul_of_nonneg_left hSmBd (mul_nonneg hL0 (le_of_lt hgapPos))
        have hE1m : abs (W2K.Nas (x k) - W2K.Nas t) * abs anchor ≤
            L * gap * abs (W2T.DP p k) + L * gap ^ 2 * (1 / x k + 6) := by
          simpa [abs_mul] using hE1
        exact add_le_add (add_le_add hE1m hMidInt) hE3b
      _ = L * (x (k + 1) - x k) * abs (W2T.DP p k) +
          (L * (x (k + 1) - x k) + 2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)) := by
        ring
  -- per-gap error, non-straddle
  have hEjNS (j : ℕ) (hjM : j ∈ Finset.range M) (hne : j ≠ k) :
      abs (gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ)) -
        W2T.DN N0 Nas j * W2T.DP p j) ≤
      L * (x (j + 1) - x j) * abs (W2T.DP p j) := by
    have habj : x j < x (j + 1) := hxA j hjM
    have haj : 0 < x j := hxPos j (Finset.mem_range.mpr (Nat.lt_trans (Finset.mem_range.mp hjM) (Nat.lt_succ_self M)))
    have hto := hOut j hjM hne
    have hden : ∀ z ∈ Set.uIcc (x j) (x (j + 1)), z - t ≠ 0 := by
      intro z hz
      by_contra hz0
      have hzI : z ∈ Set.Icc (x j) (x (j + 1)) := by
        simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
          min_eq_left_iff.2 (le_of_lt habj), max_eq_right_iff.2 (le_of_lt habj)] using hz
      rcases hto with (hlt | hgt)
      · have hpos : 0 < z - t := by linarith [hlt, (Set.mem_Icc.mp hzI).1]
        linarith [hz0]
      · have hneg : z - t < 0 := by linarith [(Set.mem_Icc.mp hzI).2, hgt]
        linarith [hz0]
    have hSumGlue : (fun y : ℝ => y - t) =
        (fun y : ℝ => (fun x : ℝ => x) y - (fun _ : ℝ => t) y) := by
      ext y
      ring
    have hF : ContinuousOn (fun u : ℝ => 1 / (u - t)) (Set.uIcc (x j) (x (j + 1))) :=
      continuousOn_of_forall_continuousAt (fun u hu =>
        ((hasDerivAt_id u).sub (hasDerivAt_const u t)
          |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hSumGlue.symm)
          |>.inv (hden u hu)
          |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq (by
            ext y
            rw [inv_eq_one_div]
            rfl))
          |>.continuousAt))
    have hKerC : ContinuousOn (fun u : ℝ => 1 / (u - t) + W2K.Sm u t)
        (Set.uIcc (x j) (x (j + 1))) :=
      hF.add (smContOn t (x j) (x (j + 1)) habj haj ht)
    have hNasCj : ContinuousOn W2K.Nas (Set.uIcc (x j) (x (j + 1))) :=
      W2I.hNasCont.mono (by
        intro z hz
        have hzI : z ∈ Set.Icc (x j) (x (j + 1)) := by
          simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
            min_eq_left_iff.2 (le_of_lt habj), max_eq_right_iff.2 (le_of_lt habj)] using hz
        exact Set.mem_Ioi.2 (lt_of_lt_of_le haj (Set.mem_Icc.mp hzI).1))
    have hIntMain : IntervalIntegrable
        (fun u : ℝ => (((N0 : ℝ) + (j : ℝ)) - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t))
        volume (x j) (x (j + 1)) :=
      (((continuousOn_const (s := Set.uIcc (x j) (x (j + 1)))).sub hNasCj).mul hKerC).intervalIntegrable
    have hIntConst : IntervalIntegrable
        (fun u : ℝ => (((N0 : ℝ) + (j : ℝ)) - W2K.Nas (x j)) * (1 / (u - t) + W2K.Sm u t))
        volume (x j) (x (j + 1)) :=
      ((continuousOn_const (s := Set.uIcc (x j) (x (j + 1)))).mul hKerC).intervalIntegrable
    have hEqEJ : gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ)) -
        W2T.DN N0 Nas j * W2T.DP p j =
      (∫ u in (x j)..(x (j + 1)), (W2K.Nas (x j) - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t) ∂volume) := by
      rw [gapContNS, W2T.DN, W2T.DP]
      have hpmj : j ∈ Finset.range (M + 1) :=
        Finset.mem_range.mpr (Nat.lt_trans (Finset.mem_range.mp hjM) (Nat.lt_succ_self M))
      have hpj1 : j + 1 ∈ Finset.range (M + 1) :=
        Finset.mem_range.mpr (Nat.succ_lt_succ (Finset.mem_range.mp hjM))
      rw [hp j hpmj, hp (j + 1) hpj1, hpNas j hpmj]
      have hIntKer : (∫ u in (x j)..(x (j + 1)), (1 / (u - t) + W2K.Sm u t) ∂volume) =
          W2K.Ker (x (j + 1)) t - W2K.Ker (x j) t := by
        have he3 := e3_kernelGapInt t (x j) (x (j + 1)) habj haj ht hto
        have he4 := e4_dpAnchor t (x j) (x (j + 1)) habj haj ht
        calc
          (∫ u in (x j)..(x (j + 1)), (1 / (u - t) + W2K.Sm u t) ∂volume)
            = (Real.log (x (j + 1) - t) - Real.log (x j - t)) +
              (∫ u in (x j)..(x (j + 1)), W2K.Sm u t ∂volume) := he3
          _ = W2K.Ker (x (j + 1)) t - W2K.Ker (x j) t := by rw [he4]
      rw [← hIntKer]
      have hConstInt :
          (((N0 : ℝ) + (j : ℝ)) - W2K.Nas (x j)) *
              (∫ u in (x j)..(x (j + 1)), (1 / (u - t) + W2K.Sm u t) ∂volume) =
            (∫ u in (x j)..(x (j + 1)),
              (((N0 : ℝ) + (j : ℝ)) - W2K.Nas (x j)) * (1 / (u - t) + W2K.Sm u t) ∂volume) := by
        rw [← intervalIntegral.integral_const_mul]
      rw [hConstInt, ← intervalIntegral.integral_sub hIntMain hIntConst]
      have hCong : ∀ u : ℝ, u ∈ Set.uIcc (x j) (x (j + 1)) →
          (((N0 : ℝ) + (j : ℝ)) - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t) -
            (((N0 : ℝ) + (j : ℝ)) - W2K.Nas (x j)) * (1 / (u - t) + W2K.Sm u t) =
          (W2K.Nas (x j) - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t) := by
        intro u _
        ring
      rw [intervalIntegral.integral_congr hCong]
    rw [hEqEJ]
    have he3g := e3_gapErr t (x j) (x (j + 1)) habj haj ht hto L hL0 (hLips j hjM)
    have he3a := e3_kernelGapAbs t (x j) (x (j + 1)) habj haj ht ht2 hto
    have he4 := e4_dpAnchor t (x j) (x (j + 1)) habj haj ht
    have hpmj2 : j ∈ Finset.range (M + 1) :=
      Finset.mem_range.mpr (Nat.lt_trans (Finset.mem_range.mp hjM) (Nat.lt_succ_self M))
    have hpj12 : j + 1 ∈ Finset.range (M + 1) :=
      Finset.mem_range.mpr (Nat.succ_lt_succ (Finset.mem_range.mp hjM))
    calc
      abs ((∫ u in (x j)..(x (j + 1)),
        (W2K.Nas (x j) - W2K.Nas u) * (1 / (u - t) + W2K.Sm u t) ∂volume)) ≤
          L * (x (j + 1) - x j) *
            (∫ u in (x j)..(x (j + 1)), abs (1 / (u - t) + W2K.Sm u t) ∂volume) :=
        he3g
      _ = L * (x (j + 1) - x j) *
          abs ((Real.log (x (j + 1) - t) - Real.log (x j - t)) +
            (∫ u in (x j)..(x (j + 1)), W2K.Sm u t ∂volume)) := by rw [he3a]
      _ = L * (x (j + 1) - x j) * abs (W2K.Ker (x (j + 1)) t - W2K.Ker (x j) t) := by
        rw [he4]
      _ = L * (x (j + 1) - x j) * abs (p (j + 1) - p j) := by
        rw [← hp (j + 1) hpj12, ← hp j hpmj2]
      _ = L * (x (j + 1) - x j) * abs (W2T.DP p j) := by
        dsimp [W2T.DP]
  -- per-gap error, both cases
  have hEJ (j : ℕ) (hjM : j ∈ Finset.range M) :
      abs ((if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
            else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
          W2T.DN N0 Nas j * W2T.DP p j) ≤
        L * (x (j + 1) - x j) * abs (W2T.DP p j) +
        (if j = k then L * (x (k + 1) - x k) +
            2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)
         else 0) := by
    by_cases hjk : j = k
    · subst j
      simpa using hEjS
    · have hNS := hEjNS j hjM hjk
      simpa [hjk] using hNS
  have hAbsSum : abs (∑ j ∈ Finset.range M,
        ((if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
          else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
          W2T.DN N0 Nas j * W2T.DP p j)) ≤
      ∑ j ∈ Finset.range M,
        abs ((if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
          else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
          W2T.DN N0 Nas j * W2T.DP p j) := by
    set F : ℕ → ℝ := fun j =>
      (if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
        else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
      W2T.DN N0 Nas j * W2T.DP p j with hF_def
    have hlemma (n : ℕ) (f : ℕ → ℝ) : abs (∑ i ∈ Finset.range n, f i) ≤
        ∑ i ∈ Finset.range n, abs (f i) := by
      induction' n with n IH
      · simp
      · rw [Finset.sum_range_succ]
        calc
          abs (∑ i ∈ Finset.range n, f i + f n) ≤
              abs (∑ i ∈ Finset.range n, f i) + abs (f n) := by
            calc
              abs (∑ i ∈ Finset.range n, f i + f n) =
                  abs (∑ i ∈ Finset.range n, f i - -(f n)) := by
                rw [show (∑ i ∈ Finset.range n, f i) + f n =
                  (∑ i ∈ Finset.range n, f i) - -(f n) from by ring]
              _ ≤ abs (∑ i ∈ Finset.range n, f i) + abs (-(f n)) :=
                abs_sub (∑ i ∈ Finset.range n, f i) (-(f n))
              _ = abs (∑ i ∈ Finset.range n, f i) + abs (f n) := by rw [abs_neg]
          _ ≤ (∑ i ∈ Finset.range n, abs (f i)) + abs (f n) := add_le_add IH le_rfl
          _ = ∑ i ∈ Finset.range (n + 1), abs (f i) := by
            rw [Finset.sum_range_succ (f := fun i => abs (f i))]
    exact hlemma M F
  calc
    abs ((∑ j ∈ Finset.range M,
        (if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
         else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ)))) -
        W2T.DcSum M p N0 Nas)
      = abs (∑ j ∈ Finset.range M,
          ((if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
            else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
            W2T.DN N0 Nas j * W2T.DP p j)) := by
        rw [W2T.DcSum, Finset.sum_sub_distrib]
      _ ≤ ∑ j ∈ Finset.range M,
          abs ((if j = k then gapContS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))
            else gapContNS t (x j) (x (j + 1)) ((N0 : ℝ) + (j : ℝ))) -
            W2T.DN N0 Nas j * W2T.DP p j) := by
        exact hAbsSum
      _ ≤ ∑ j ∈ Finset.range M,
          (L * (x (j + 1) - x j) * abs (W2T.DP p j) +
            (if j = k then L * (x (k + 1) - x k) +
                2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)
             else 0)) := by
        exact Finset.sum_le_sum (fun j hjM => hEJ j hjM)
      _ = L * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) +
          (L * (x (k + 1) - x k) + 2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)) := by
        have hLsum : (∑ j ∈ Finset.range M, L * (x (j + 1) - x j) * abs (W2T.DP p j)) =
            L * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) := by
          have hre : (∑ j ∈ Finset.range M, L * (x (j + 1) - x j) * abs (W2T.DP p j)) =
              (∑ j ∈ Finset.range M, L * ((x (j + 1) - x j) * abs (W2T.DP p j))) := by
            apply Finset.sum_congr rfl
            intro j _
            ring
          rw [hre]
          have aux (n : ℕ) (f : ℕ → ℝ) : (∑ i ∈ Finset.range n, L * f i) =
              L * (∑ i ∈ Finset.range n, f i) := by
            induction' n with n IH
            · ring
            · rw [Finset.sum_range_succ, Finset.sum_range_succ, IH]
              ring
          exact aux M (fun j => (x (j + 1) - x j) * abs (W2T.DP p j))
        set ESTR : ℝ := L * (x (k + 1) - x k) +
          2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) with hESTR_def
        have hswap : (∑ j ∈ Finset.range M, (if j = k then L * (x (k + 1) - x k) +
            2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) else 0)) =
            (∑ j ∈ Finset.range M, (if k = j then L * (x (k + 1) - x k) +
            2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) else 0)) := by
          apply Finset.sum_congr rfl
          intro j _
          by_cases hjk : j = k
          · subst hjk
            simp
          · have hlk : ¬ k = j := fun h => hjk h.symm
            simp [hjk, hlk]
        rw [Finset.sum_add_distrib]
        rw [hLsum]
        rw [hswap, Finset.sum_ite_eq (b := fun _ =>
            L * (x (k + 1) - x k) + 2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6)),
          if_pos (Finset.mem_range.mpr hM)]
      _ = L * (∑ j ∈ Finset.range M, (x (j + 1) - x j) * abs (W2T.DP p j)) +
          L * (x (k + 1) - x k) + 2 * L * (x (k + 1) - x k) ^ 2 * (1 / x k + 6) := by
        ring

end W2B
