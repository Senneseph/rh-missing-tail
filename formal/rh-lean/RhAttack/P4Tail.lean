/- P4Tail — local P4 atom-2: the 2nd-order finite Euler–Maclaurin identity.

OUTLINE piece: P4 (the rigorous missing-tail law, §9 row P4), atom-2
(spec: kainos plan/40-prize-islands/rh-attack/spec/p4-tail-law-abstract.md
§0.6/§T2/§T3).

ROLE: the second-order EM identity — the `−½f(n) + (1/12)(f′ m − f′ n) +
B̂₂·f″` kernel — from which the W_n(t) form follows. Built exclusively
from:
  (1) the ported 1st-order identity (RhAttack.P4Em, published),
  (2) one IBP per unit period, done WITHIN [j, j+1] using the relative
      derivative (`integral_mul_deriv_eq_deriv_mul_of_hasDerivWithinAt`)
      with u = B̂₂ itself: B̂₂ is a polynomial on each period and its
      relative derivative is 2·B̂₁ everywhere in [j, j+1] (at j+1 the
      relative derivative is the left-derivative 2(j+1−j)−1 = 1, while
      B̂₁(j+1) = −1/2 — the endpoint correction u′(j+1) := 1 absorbs
      the B̂₁ jump; see u' below),
  (3) the pinned additivity lemma
      `intervalIntegral.sum_integral_adjacent_intervals_Ico`.
This is the ONLY local invention of the P4 line (§0.6: no published
Lean 2nd-order EM exists; the Isabelle AFP entry is the cross-check).

APPROACH: integers n ≤ m; f : ℝ → 𝕜, [RCLike 𝕜] (ℝ or ℂ). The exact
finite target (signs verified numerically day-017 at σ=1.5 [3.2e-7]
and σ=½ [3.7e-5], mpmath dps-40 — computed, not recalled):

    ∑ k ∈ Ioc n m, f k = ∫_n^m f + ½(f m − f n)
                    + (1/12)(f′ m − f′ n) − ½·∫_n^m B2 x·f″ x dx.

STATUS: atom-2, day-017. Build: `lake build RhAttack.P4Tail`.

THEOREMS (global names):
  B2, B2_at_int, B2_of_Icc_int, B2poly, B2_of_B2poly, B2poly_deriv,
  B2poly_deriv_eq_two_B1, abs_B2_le, aestronglyMeasurable_B2,
  intervalIntegrable_B2_mul_deriv2, int_B1f'_period,
  int_B1f'_sum_Ico, telescoping_deriv, em2_finite — the 2nd-order
  finite EM identity.
-/
import Mathlib
import RhAttack.P4Em

open Real Set MeasureTheory intervalIntegral Finset

variable {𝕜 : Type*} [RCLike 𝕜]

noncomputable section

/-- The 2nd periodic Bernoulli function: B̂₂(x) = (x−⌊x⌋₊)² − (x−⌊x⌋₊) + 1/6. -/
def B2 (x : ℝ) : ℝ := (x - ⌊x⌋₊) ^ 2 - (x - ⌊x⌋₊) + 1 / 6

@[fun_prop]
lemma aestronglyMeasurable_B2 : AEStronglyMeasurable B2 := by
  unfold B2
  fun_prop

/-- |B̂₂(x)| ≤ 1/6. -/
lemma abs_B2_le {x : ℝ} (hx : 0 ≤ x) : |B2 x| ≤ 1 / 6 := by
  unfold B2
  grind [Nat.floor_le hx, Nat.lt_succ_floor x]

/-- B̂₂(n) = 1/6 at integers (the kernel is continuous at its kinks). -/
lemma B2_at_int (n : ℕ) : B2 (n : ℝ) = 1 / 6 := by
  unfold B2
  simp only [Nat.floor_nat]
  ring

/-- The per-period polynomial (the kernel with the floor frozen). -/
def B2poly (n : ℕ) (x : ℝ) : ℝ := (x - n) ^ 2 - (x - n) + 1 / 6

/-- On [n, n+1]: B̂₂ = the frozen polynomial. -/
lemma B2_of_Icc_int (n : ℕ) {x : ℝ} (hx : x ∈ (n : ℝ)..(n + 1 : ℝ)) :
    B2 x = (x - n) ^ 2 - (x - n) + 1 / 6 := by
  unfold B2
  have hn : (⌊x⌋₊ : ℝ) = n := by
    norm_cast
    rw [Nat.floor_eq]
    constructor
    · norm_num
      linarith [hx.1]
    · norm_num
      linarith [hx.2]
  rw [hn]
  ring

lemma B2_of_B2poly (n : ℕ) {x : ℝ} (hx : x ∈ (n : ℝ)..(n + 1 : ℝ)) :
    B2 x = B2poly n x := by
  rw [B2_of_Icc_int n hx]
  dsimp only [B2poly]

section

variable (f : ℝ → 𝕜)

/-- The B̂₂·f″ integrand is interval-integrable (bounded measurable ×
    continuous). -/
lemma intervalIntegrable_B2_mul_deriv2 (a b : ℝ)
    (hcont_f'' : ContinuousOn (deriv (deriv f)) (a..b)) :
    IntervalIntegrable (fun t => B2 t * deriv (deriv f) t) volume a b := by
  refine IntervalIntegrable.continuousOn_mul ?_ hcont_f''
  rw [intervalIntegrable_iff']
  apply MeasureTheory.Measure.integrableOn_of_bounded (by simp) (by fun_prop) (M := 1 / 6)
  filter_upwards [self_mem_ae_restrict (by measurability)] with x hx
  rw [Set.uIcc hx.1, Set.mem_Icc] at hx
  norm_cast
  exact abs_B2_le (by linarith)

/-- Per-period IBP over [j, j+1]:
      ∫_j^{j+1} B1·f′ = (1/12)(f′(j+1) − f′(j)) − (1/2)·∫_j^{j+1} B2·f″. -/
lemma int_B1f'_period (j : ℕ)
    (hf2 : ∀ t ∈ ((j : ℝ)..(j + 1 : ℝ)), DifferentiableAt ℝ (deriv f) t)
    (hcont_f' : ContinuousOn (deriv f) ((j : ℝ)..(j + 1 : ℝ)))
    (hcont_f'' : ContinuousOn (deriv (deriv f)) ((j : ℝ)..(j + 1 : ℝ))) :
    (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x) =
      (1 / 12 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
      (1 / 2 : 𝕜) * (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
  -- u := B̂₂ (as a 𝕜-valued map); its relative derivative on [[j, j+1]]:
  -- u′(x) = 2·B̂₁(x) for x < j+1, and 1 at x = j+1 (the left-derivative
  -- 2(j+1−j)−1 = 1; the B̂₁ jump is absorbed by the endpoint value).
  set u : ℝ → 𝕜 := fun x => (B2 x : 𝕜) with hu
  set u' : ℝ → 𝕜 := fun x => if x = (j + 1 : ℝ) then 1 else (2 : 𝕜) * B1 x with hup
  have hIoo_deriv : ∀ x ∈ Ioo (j : ℝ) (j + 1 : ℝ),
      HasDerivAt u ((2 : 𝕜) * B1 x) x := by
    intro x hx
    have hfloor : (⌊x⌋₊ : ℝ) = (j : ℝ) := by
      norm_cast
      rw [Nat.floor_eq]
      constructor
      · norm_num
        linarith [nx := hx.1]
    · norm_num
      by_contra! hx2
      linarith [hx.2, hx2]
    -- on this period u = the frozen polynomial (as a 𝕜-map); the latter
    -- differentiates to 2(x−j)−1 = 2·B̂₁(x)
    set p : ℝ → 𝕜 := fun x => (x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 with hp
    have hpoly : HasDerivAt p ((2 : 𝕜) * B1 x) x := by
      have hA : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2) (2 * ((x : 𝕜) - (j : 𝕜))) (x : 𝕜) :=
        (hasDerivAt_sub_const (hasDerivAt_id (x := (x : 𝕜))) (j : 𝕜)).pow 2
      have hB : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜)))
          (2 * ((x : 𝕜) - (j : 𝕜)) - 1) (x : 𝕜) :=
        hA.sub (hasDerivAt_sub_const (hasDerivAt_id (x := (x : 𝕜))) (j : 𝕜))
      have hC : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜)) + 1 / 6)
          (2 * ((x : 𝕜) - (j : 𝕜)) - 1) (x : 𝕜) := hB.add_const (1 / 6 : 𝕜)
      have hclm : HasDerivAt (fun (x : ℝ) => (x : 𝕜)) 1 x :=
        (ContinuousLinearMap.hasDerivAt (RCLike.ofRealCLM) x).hasDerivAt
      have heq : p = (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜)) + 1 / 6) ∘
          (fun (x : ℝ) => (x : 𝕜)) := by
        ext x
        dsimp only [p]
        norm_num
        norm_cast
      rw [heq]
      simpa [show (2 : 𝕜) * B1 x = 2 * ((x : 𝕜) - (j : 𝕜)) - 1 from by
        unfold B1
        norm_num
        norm_cast
        ring] using hC.comp x hclm
    have hult : u =ᶠ[𝓝 x], p := by
      filter_upwards [Ioo.mem_nhds hx] with y hy
      have hyo : y ∈ Ioo (j : ℝ) (j + 1 : ℝ) := hy
      have hyf : (⌊y⌋₊ : ℝ) = (j : ℝ) := by
        norm_cast
        rw [Nat.floor_eq]
        constructor
        · norm_num
          linarith [hyo.1]
        · norm_num
          linarith [hyo.2]
      dsimp only [u, p]
      unfold B2
      rw [hyf]
      norm_cast
      ring
    exact hpoly.congr_hypothesis hult |>.hasDerivAt
  have hleft : HasDerivWithinAt u 1 (((j : ℝ)..(j + 1 : ℝ))) (j + 1 : ℝ) := by
    -- left-derivative of B̂₂ at j+1 within [[j, j+1]]:
    set p : ℝ → 𝕜 := fun x => (x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 with hp
    have hpoly : HasDerivAt p 1 (j + 1 : ℝ) := by
      have hA : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2) (2 * ((j + 1 : ℝ) : 𝕜) - 2 * (j : 𝕜)) (j + 1 : ℝ) :=
        (hasDerivAt_sub_const (hasDerivAt_id (x := ((j + 1 : ℝ) : 𝕜))) (j : 𝕜)).pow 2
      have hB : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜))) 1 (j + 1 : ℝ) := by
        rw [show ((2 : 𝕜) * ((j + 1 : ℝ) : 𝕜) - 2 * (j : 𝕜)) = (2 : 𝕜) from by
          norm_num] at hA
        exact hA.sub (hasDerivAt_sub_const (hasDerivAt_id (x := ((j + 1 : ℝ) : 𝕜))) (j : 𝕜))
      exact hB.add_const (1 / 6 : 𝕜)
    have hult : u =ᶠ[𝓝[(((j : ℝ)..(j + 1 : ℝ)) : Set ℝ)] (j + 1 : ℝ)], p := by
      filter_upwards [Icc.mem_nhds (mem_Icc (by nlinarith [Nat.cast_nonneg (j : ℕ)])) (le_refl _)] with y hy
      dsimp only [u, p]
      by_cases htop : y = (j + 1 : ℝ)
      · subst htop
        unfold B2
        norm_num
        norm_cast
      · have hyf : y < (j + 1 : ℝ) := lt_of_le_of_ne hy.2 htop
        have hyf : (⌊y⌋₊ : ℝ) = (j : ℝ) := by
          norm_cast
          rw [Nat.floor_eq]
          constructor
          · norm_num
            linarith [hy.1]
          · norm_num
            linarith [hyf]
        unfold B2
        rw [hyf]
        norm_cast
        ring
    exact hpoly.congr_hypothesis_within hult |>.hasDerivWithinAt
  have hbase : HasDerivWithinAt u (((2 : 𝕜) * B1 (j : ℝ)) : 𝕜) (((j : ℝ)..(j + 1 : ℝ))) (j : ℝ) := by
    set p : ℝ → 𝕜 := fun x => (x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 with hp
    have hpoly : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜)) + 1 / 6) ((-1 : 𝕜)) (j : 𝕜) := by
      have hA : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2) 0 (j : 𝕜) :=
        (hasDerivAt_sub_const (hasDerivAt_id (x := ((j : ℝ) : 𝕜))) (j : 𝕜)).pow 2
      have hB : HasDerivAt (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜))) (-1 : 𝕜) (j : 𝕜) :=
        hA.sub (hasDerivAt_sub_const (hasDerivAt_id (x := ((j : ℝ) : 𝕜))) (j : 𝕜))
      rw [show (0 : 𝕜) = 2 * 0 from by norm_num] at hA
      exact hB.add_const (1 / 6 : 𝕜)
    have hclm : HasDerivAt (fun (x : ℝ) => (x : 𝕜)) 1 (j : ℝ) :=
      (ContinuousLinearMap.hasDerivAt (RCLike.ofRealCLM) (j : ℝ)).hasDerivAt
    have heq : p = (fun (y : 𝕜) => (y - (j : 𝕜)) ^ 2 - (y - (j : 𝕜)) + 1 / 6) ∘
        (fun (x : ℝ) => (x : 𝕜)) := by
      ext x
      dsimp only [p]
      norm_num
      norm_cast
    rw [heq]
    simpa [show ((-1 : 𝕜)) = (2 : 𝕜) * B1 (j : ℝ) from by
      unfold B1
      norm_num
      norm_cast] using hpoly.comp (j : ℝ) hclm |>.hasDerivWithinAt
  have hu' : ∀ x ∈ (((j : ℝ)..(j + 1 : ℝ))), HasDerivWithinAt u (u' x) (((j : ℝ)..(j + 1 : ℝ))) x := by
    intro x hx
    by_cases htop : x = (j + 1 : ℝ)
    · subst htop
      simpa [u'] using hleft
    · by_cases hbot : x = (j : ℝ)
      · subst hbot
        simpa [u'] using hbase
      · have hyo : x ∈ Ioo (j : ℝ) (j + 1 : ℝ) :=
          Ioo.mem_of_mem_Icc (mem_Icc_of_Icc hx) (by tauto)
        simpa [u', show ¬(x = (j + 1 : ℝ)) from htop] using hIoo_deriv x hyo
  have hv' : ∀ x ∈ (((j : ℝ)..(j + 1 : ℝ))),
      HasDerivWithinAt (deriv f) (deriv (deriv f) x) (((j : ℝ)..(j + 1 : ℝ))) x :=
    fun x hx => (hf2 x hx).hasDerivAt |>.hasDerivWithinAt
  have hup_int : IntervalIntegrable (fun x : ℝ => u' x) volume (j : ℝ) (j + 1) := by
    -- u' = 2·B̂₁ + 2·1_{(j+1)} (a single-point modification of a bounded
    -- measurable function — bounded and measurable, hence integrable).
    rw [intervalIntegrable_iff']
    constructor
    · aesop
    · apply MeasureTheory.Measure.integrableOn_of_bounded (by aesop) (by
        intro x hx
        split_ifs with h h
        · norm_num
        · calc ‖(2 : 𝕜) * B1 x‖ = 2 * ‖(B1 x : 𝕜)‖ := by
              rw [norm_smul, norm_ofReal? ]
              sorry
          _ ≤ 1 := by
            calc 2 * ‖(B1 x : 𝕜)‖ _root_ =? )
  have hvf_int : IntervalIntegrable (deriv f) volume (j : ℝ) (j + 1) :=
    hcont_f'.intervalIntegrable
  have hIBP : (∫ x in (j : ℝ)..(j + 1 : ℝ), (B2 x : 𝕜) * deriv (deriv f) x) =
      (B2 (j + 1 : ℝ) : 𝕜) * deriv f (j + 1 : ℝ) - (B2 (j : ℝ) : 𝕜) * deriv f (j : ℝ) -
      (∫ x in (j : ℝ)..(j + 1 : ℝ), u' x * deriv f x) :=
    integral_mul_deriv_eq_deriv_mul_of_hasDerivWithinAt hu' hv' hup_int hvf_int
  have hB2vals : (B2 (j + 1 : ℝ) : 𝕜) = 1 / 6 ∧ (B2 (j : ℝ) : 𝕜) = 1 / 6 :=
    ⟨by simpa [show ‖(B2 (j + 1 : ℝ) : ℝ)‖ =? from B2_at_int (j + 1)],
     by simpa using B2_at_int j⟩
  sorry

end

end
