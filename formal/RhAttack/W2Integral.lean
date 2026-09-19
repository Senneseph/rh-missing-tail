/-
W2Integral (M3 of docs/W2-LEAN-PLAN.md): the per-gap
singular-free integral side (section 1.3) for the NON-STRADDLE
gaps — the gaps the certificate uses, except the single one
containing t.

KEY PIN FACT (verified in the pinned mathlib 4.33.1 source,
Analysis/SpecialFunctions/Log/Deriv.lean):  `Real.log` as a
function R -> R already IS the log|.| extension on the
negative arguments (the negative branch uses
`log_neg_eq_log`), and
    hasDerivAt_log (hx : x != 0) : HasDerivAt log (x⁻¹) x
    hasStrictDerivAt_log (hx : x != 0) : HasStrictDerivAt log (x⁻¹) x
hold on BOTH branches.  So the kernel's `log |x - t|` (as a
real function of x, x != t) is just `Real.log (x - t)`, and
its derivative is `1 / (x - t)` on both sides of t at once —
which is why the identity below writes `log (b - t)` /
`log (a - t)` with no abs.

Convention:  a gap is a closed interval [a, b], a < b, with
a > 0 (all certificate gaps lie in (0, infinity)) and a
parameter t > 0 (the straddle point).  The gap is
non-straddle when t is OUTSIDE [a, b] (t < a or b < t); on
such a gap (x - t) never vanishes, every integrand below is
ordinary-continuous, and the identity is a plain interval
integral statement (no improper/pv objects).

  (M3c)  gapIdentity:
    int_a^b Nas(x) * (1/(x-t) + Sm(x,t)) dx
      = Nas(t) * (|b-t| - |a-t|)
        + int_a^b (Nas(x) - Nas(t))/(x-t) dx
        + int_a^b Nas(x) * Sm(x,t) dx
  i.e. the plan's (1.3) IG_j terms (log part,
  divided-difference part, Sm part) evaluated for every
  non-straddle gap.  The straddle gap (t in (a,b)):  the
  middle integrand extends continuously to t with value
  Rho(t) = Nas'(t) (W2K.nasHasDerivAt + HasDerivAt.isLittleO);
  that continuity/integrability lemma belongs to M4, where it
  is consumed for the O(1) straddle control.

Proof shape:  split the left integral by additivity into the
(x-t)⁻¹ part and the Sm part; in the (x-t)⁻¹ part insert
Nas(x) = Nas(t) + (Nas(x) - Nas(t)); pull the constant
Nas(t) out and evaluate
    int_a^b (x-t)⁻¹ dx = log|b-t| - log|a-t|
by `integral_eq_sub_of_hasDerivAt` applied to the primitive
F(x) = log(x - t) (derivative (x-t)⁻¹ at every point of
[a,b], well-defined and continuous there because t is
outside the gap).
-/
import Mathlib
import RhAttack.W2Kernel

open Real MeasureTheory

namespace W2I

/-- The continuous extension (at t) of the divided difference
of W2K.Nas against t:  its value at x = t is Rho(t) =
W2K.Nas'(t).  Consumed by the straddle-gap statement (M4).  -/
noncomputable def midExt (x t : ℝ) : ℝ :=
  if x = t then W2K.Rho t else (W2K.Nas x - W2K.Nas t) / (x - t)

section helpers

-- Nas is continuous on (0, infinity):  pointwise hasDerivAt
-- (W2K.nasHasDerivAt) gives pointwise continuousAt.
theorem hNasCont : ContinuousOn W2K.Nas (Set.Ioi (0 : ℝ)) :=
  continuousOn_of_forall_continuousAt
    (fun x hx => (W2K.nasHasDerivAt x hx).continuousAt)

-- x ↦ x - t, x ↦ 1, pointwise.
theorem hSubCA (t x : ℝ) : HasDerivAt (fun y : ℝ => y - t) 1 x := by
  have hsub : (fun y : ℝ => y - t) =
      (fun y : ℝ => (fun x : ℝ => x) y - (fun _ : ℝ => t) y) := by
    ext y
    ring
  exact (hasDerivAt_id' x |>.sub (hasDerivAt_const x t)
    |>.congr_of_eventuallyEq (Filter.EventuallyEq.of_eq hsub)
    |>.congr_deriv (by ring))

end helpers

/-- (M3c) the per-gap singular-free decomposition for a
non-straddle gap.  See the file header for the pinned-log
convention (|.| = Log extension).  -/
theorem gapIdentity (t a b : ℝ) (hab : a < b) (ha : 0 < a) (ht : 0 < t)
    (ht_out : t < a ∨ b < t) :
    ∫ x in a..b, W2K.Nas x * (1 / (x - t) + W2K.Sm x t) =
    W2K.Nas t * (log (b - t) - log (a - t)) +
    ∫ x in a..b, (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹ +
    ∫ x in a..b, W2K.Nas x * W2K.Sm x t := by
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
  have hUpos : Set.uIcc a b ⊆ Set.Ioi (0 : ℝ) := by
    intro x hx
    have hxI : x ∈ Set.Icc a b := by
      simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
        min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
    exact Set.mem_Ioi.2 (lt_of_lt_of_le ha (Set.mem_Icc.mp hxI).1)
  -- continuity of the factor functions on Set.uIcc a b
  have hNasC : ContinuousOn (fun x => (W2K.Nas x : ℝ)) (Set.uIcc a b) :=
    hNasCont.mono hUpos
  have hInvC : ContinuousOn (fun x : ℝ => (x - t)⁻¹) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt (fun x hx => (hSubCA t x).inv (hden x hx) |>.continuousAt)
  have hNasInvC : ContinuousOn (fun x : ℝ => W2K.Nas x * (x - t)⁻¹) (Set.uIcc a b) :=
    hNasC.mul hInvC
  have hNasSubInvC :
      ContinuousOn (fun x : ℝ => (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹) (Set.uIcc a b) :=
    continuousOn_of_forall_continuousAt (fun x hx => by
      have hposx : 0 < x := by
        have hxI : x ∈ Set.Icc a b := by
          simpa [Set.uIcc, inf_eq_minDefault, sup_eq_maxDefault,
            min_eq_left_iff.2 (le_of_lt hab), max_eq_right_iff.2 (le_of_lt hab)] using hx
        linarith [ha, (Set.mem_Icc.mp hxI).1]
      have hnasC : ContinuousAt W2K.Nas x :=
        (W2K.nasHasDerivAt x hposx).continuousAt
      have hnasSub : ContinuousAt (fun y : ℝ => W2K.Nas y - W2K.Nas t) x :=
        ContinuousAt.sub hnasC continuousAt_const
      have hinvCA : ContinuousAt (fun y : ℝ => (y - t)⁻¹) x :=
        ((hSubCA t x).inv (hden x hx)).continuousAt
      exact ContinuousAt.mul hnasSub hinvCA)
  -- the divided-difference (middle) integrand equals the
  -- pointwise product above on [a, b]
  have hmidEq : (fun x : ℝ => (W2K.Nas x - W2K.Nas t) / (x - t)) =
      (fun x : ℝ => (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹) := by
    ext x
    by_cases h : x - t = 0
    · field_simp [h]
    · field_simp [h]
  -- sm is continuous (inferred hasDerivAt chain;  the only
  -- vanishing denominator x + t stays nonzero near x ≥ a > 0)
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
  have hNasSmC : ContinuousOn (fun x : ℝ => W2K.Nas x * W2K.Sm x t) (Set.uIcc a b) :=
    hNasC.mul hSmC
  -- integrability
  have hIntNA : IntervalIntegrable (fun x : ℝ => W2K.Nas x * (x - t)⁻¹) volume a b :=
    hNasInvC.intervalIntegrable
  have hIntNS : IntervalIntegrable (fun x : ℝ => W2K.Nas x * W2K.Sm x t) volume a b :=
    hNasSmC.intervalIntegrable
  have hIntM :
      IntervalIntegrable (fun x : ℝ => (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹) volume a b :=
    hNasSubInvC.intervalIntegrable
  have hIntI : IntervalIntegrable (fun x : ℝ => (x - t)⁻¹) volume a b :=
    hInvC.intervalIntegrable
  -- the left integrand rewrites pointwise (the division
  -- convention keeps it true even at x = t)
  have hin : (fun x : ℝ => W2K.Nas x * (1 / (x - t) + W2K.Sm x t)) =
      (fun x : ℝ => W2K.Nas x * (x - t)⁻¹ + W2K.Nas x * W2K.Sm x t) := by
    ext x
    by_cases h : x - t = 0
    · field_simp [h]
    · field_simp [h]
  -- the primitive integral  int_a^b (x-t)⁻¹ dx = log|b-t| - log|a-t|
  have hLogD (x : ℝ) (hx : x ∈ Set.uIcc a b) :
      HasDerivAt (fun y : ℝ => log (y - t)) ((x - t)⁻¹) x :=
    (hSubCA t x).log (hden x hx) |>.congr_deriv (by rw [← inv_eq_one_div])
  have hFTC : ∫ x in a..b, (x - t)⁻¹ = log (b - t) - log (a - t) :=
    intervalIntegral.integral_eq_sub_of_hasDerivAt hLogD hIntI
  calc
    ∫ x in a..b, W2K.Nas x * (1 / (x - t) + W2K.Sm x t)
      = ∫ x in a..b, (W2K.Nas x * (x - t)⁻¹ + W2K.Nas x * W2K.Sm x t) := by
        rw [hin]
      _ = ∫ x in a..b, W2K.Nas x * (x - t)⁻¹ +
          ∫ x in a..b, W2K.Nas x * W2K.Sm x t := by
        rw [intervalIntegral.integral_add hIntNA hIntNS]
      _ = (W2K.Nas t * ∫ x in a..b, (x - t)⁻¹ +
            ∫ x in a..b, (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹) +
          ∫ x in a..b, W2K.Nas x * W2K.Sm x t := by
        congr
        · -- ∫ Nas x·(x−t)⁻¹ = ∫ (Nas t + (Nas x − Nas t))·(x−t)⁻¹
          rw [intervalIntegral.integral_congr (by intro _ _; ring)]
          rw [intervalIntegral.integral_add]
          · exact ((continuousOn_const.mul hInvC).intervalIntegrable)
          · exact hIntM
          rw [intervalIntegral.integral_const_mul (W2K.Nas t)]
        · rfl
      _ = W2K.Nas t * (log (b - t) - log (a - t)) +
          ∫ x in a..b, (W2K.Nas x - W2K.Nas t) * (x - t)⁻¹ +
          ∫ x in a..b, W2K.Nas x * W2K.Sm x t := by
        rw [hFTC]
        ring

end W2I
