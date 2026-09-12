/- P4Tail — local P4 atom-2: the 2nd-order finite Euler–Maclaurin identity.

OUTLINE piece: P4 (the rigorous missing-tail law, §9 row P4), atom-2
(spec: kainos plan/40-prize-islands/rh-attack/spec/p4-tail-law-abstract.md
§0.6/§T2/§T3).

ROLE: the second-order EM identity — the `−½f(n) + (1/12)(f′ m − f′ n) +
B̂₂·f″` kernel — from which the W_n(t) form follows. Built exclusively
from:
  (1) the ported 1st-order identity (RhAttack.P4Em, published),
  (2) one polynomial IBP per unit period (u = the frozen per-period
      polynomial (x−j)²−(x−j)+1/6, via
      `intervalIntegral.integral_mul_deriv_eq_deriv_mul`), plus the a.e.
      endpoint conversion `intervalIntegral.integral_congr_ae` for the
      single kink point x = j+1,
  (3) the pinned additivity lemma
      `intervalIntegral.sum_integral_adjacent_intervals_Ico`.
This is the ONLY local invention of the P4 line (§0.6: no published
Lean 2nd-order EM exists; the Isabelle AFP entry is the cross-check).

APPROACH: integers n ≤ m; f : ℝ → 𝕜, [RCLike 𝕜] (ℝ or ℂ). Per-period
identity (proven here: int_B1f'_period):

    ∫_j^{j+1} B̂₁·f′ = (1/12)(f′(j+1) − f′(j)) − (1/2)·∫_j^{j+1} B̂₂·f″,

from which the finite target follows by summation (atom-2b, next):

    ∑ k ∈ Ioc n m, f k = ∫_n^m f + ½(f m − f n)
                    + (1/12)(f′ m − f′ n) − ½·∫_n^m B̂₂·f″ dx.

Signs verified numerically day-017 at σ=1.5 [3.2e-7] and σ=½ [3.7e-5]
(mpmath dps-40 — computed, not recalled).

STATUS: atom-2, day-017. Build: `lake build RhAttack.P4Tail`.

THEOREMS (global names):
  B2, B2_at_int, B2_of_Icc_int, B2poly, B2_of_B2poly,
  abs_B2_le, aestronglyMeasurable_B2, intervalIntegrable_B2_mul_deriv2,
  int_B1f'_period.
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
  set v := (x - ⌊x⌋₊ : ℝ) with hv
  have hv0 : 0 ≤ v := by grind [Nat.floor_le hx]
  have hv1 : v ≤ 1 := by grind [Nat.lt_succ_floor x]
  have hrew : (x - ⌊x⌋₊ : ℝ) ^ 2 - (x - ⌊x⌋₊) + 1 / 6 = v ^ 2 - v + 1 / 6 := by
    rfl
  have htop : v ^ 2 - v + 1 / 6 ≤ 1 / 6 := by nlinarith [hv0, hv1]
  have hbot : - (1 / 6 : ℝ) ≤ v ^ 2 - v + 1 / 6 := by
    have hsq : v ^ 2 - v + 1 / 6 = (v - 1 / 2) ^ 2 - 1 / 12 := by ring
    nlinarith [hsq, sq_nonneg (v - 1 / 2)]
  simpa only [← hrew] using abs_le.mpr ⟨hbot, htop⟩

/-- B̂₂(n) = 1/6 at integers (the kernel is continuous at its kinks). -/
lemma B2_at_int (n : ℕ) : B2 (n : ℝ) = 1 / 6 := by
  unfold B2
  have hn : (⌊(n : ℝ)⌋₊ : ℝ) = (n : ℝ) := by
    norm_cast
    rw [Nat.floor_eq_iff (Nat.cast_nonneg n)]
    constructor
    · norm_num
    · norm_num
  rw [hn]
  ring

/-- The per-period polynomial (the kernel with the floor frozen). -/
def B2poly (n : ℕ) (x : ℝ) : ℝ := (x - n) ^ 2 - (x - n) + 1 / 6

/-- On [n, n+1]: B̂₂ = the frozen polynomial. -/
lemma B2_of_Icc_int (n : ℕ) {x : ℝ} (hx : x ∈ Set.Icc (n : ℝ) (n + 1 : ℝ)) :
    B2 x = (x - n) ^ 2 - (x - n) + 1 / 6 := by
  unfold B2
  by_cases htop : x = (n + 1 : ℝ)
  · rw [htop]
    have hfl : (⌊(n + 1 : ℝ)⌋₊ : ℕ) = n + 1 :=
      (Nat.floor_eq_iff (ha := by positivity)).mpr
        ⟨by norm_cast, by
          norm_cast
          linarith⟩
    rw [hfl]
    norm_num
  · have hn : (⌊x⌋₊ : ℝ) = (n : ℝ) := by
      norm_cast
      rw [Nat.floor_eq_iff (by linarith [show (0 : ℝ) ≤ x from le_trans (Nat.cast_nonneg n) hx.1])]
      constructor
      · linarith [hx.1]
      · exact lt_of_le_of_ne hx.2 htop
    rw [hn]

lemma B2_of_B2poly (n : ℕ) {x : ℝ} (hx : x ∈ Set.Icc (n : ℝ) (n + 1 : ℝ)) :
    B2 x = B2poly n x := by
  rw [B2_of_Icc_int n hx]
  dsimp only [B2poly]

section

variable (f : ℝ → 𝕜)

/-- The B̂₂·f″ integrand is interval-integrable (bounded measurable ×
    continuous). -/
lemma intervalIntegrable_B2_mul_deriv2 (a b : ℝ) (ha0 : 0 ≤ a) (hab : a ≤ b)
    (hcont_f'' : ContinuousOn (deriv (deriv f)) (Set.uIcc a b)) :
    IntervalIntegrable (fun t => B2 t * deriv (deriv f) t) volume a b := by
  refine IntervalIntegrable.mul_continuousOn ?_ hcont_f''
  rw [intervalIntegrable_iff']
  apply MeasureTheory.Measure.integrableOn_of_bounded (by simp) (by fun_prop) (M := 1 / 6)
  filter_upwards [self_mem_ae_restrict (by measurability)] with x hx
  rw [Set.uIcc_of_le hab, Set.mem_Icc] at hx
  norm_cast
  exact abs_B2_le (le_trans ha0 hx.1)

section

variable (j : ℕ)

/-- Per-period IBP over [j, j+1]:
      ∫_j^{j+1} B̂₁·f′ = (1/12)(f′(j+1) − f′(j)) − (1/2)·∫_j^{j+1} B̂₂·f″. -/
lemma int_B1f'_period
    (hf2 : ∀ t ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ), DifferentiableAt ℝ (deriv f) t)
    (hcont_f' : ContinuousOn (deriv f) (Set.uIcc (j : ℝ) (j + 1 : ℝ)))
    (hcont_f'' : ContinuousOn (deriv (deriv f)) (Set.uIcc (j : ℝ) (j + 1 : ℝ))) :
    (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x) =
      (1 / 12 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
      (1 / 2 : 𝕜) * (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
  -- the frozen per-period polynomial kernel, built directly in 𝕜 as a pointwise
  -- Pi-combination, so the HasDerivAt chain below has a function field that is
  -- definitionally `u` (no function congruence needed)
  set cE : ℝ → 𝕜 := (RCLike.ofRealCLM (K := 𝕜) : ℝ → 𝕜) with hcE
  set cJ : ℝ → 𝕜 := (fun _ : ℝ => (j : 𝕜)) with hcJ
  set u : ℝ → 𝕜 := (cE - cJ) * (cE - cJ) - (cE - cJ) + (fun _ : ℝ => (1 / 6 : 𝕜)) with hu
  set u' : ℝ → 𝕜 := fun x => (2 : 𝕜) * (cE x - cJ x) - (1 : 𝕜) with hup
  -- u differentiable on (j, j+1] with derivative u'
  have hu' : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ), HasDerivAt u (u' x) x := by
    intro x _
    have hS := (ContinuousLinearMap.hasDerivAt (RCLike.ofRealCLM (K := 𝕜)) (x := x)).sub
      (hasDerivAt_const (c := (j : 𝕜)) (x := x))
    have hU : HasDerivAt u
        ((RCLike.ofRealCLM (K := 𝕜) 1 - 0) * ((x : 𝕜) - (j : 𝕜)) +
          ((x : 𝕜) - (j : 𝕜)) * (RCLike.ofRealCLM (K := 𝕜) 1 - 0) -
          (RCLike.ofRealCLM (K := 𝕜) 1 - 0) + 0) x :=
      hS.mul hS |>.sub hS |>.add (hasDerivAt_const (c := (1 / 6 : 𝕜)) (x := x))
    have hD : (RCLike.ofRealCLM (K := 𝕜) 1 - 0) * ((x : 𝕜) - (j : 𝕜)) +
        ((x : 𝕜) - (j : 𝕜)) * (RCLike.ofRealCLM (K := 𝕜) 1 - 0) - (RCLike.ofRealCLM (K := 𝕜) 1 - 0) + 0 = u' x := by
      dsimp only [u', cE, cJ]
      simp
      ring
    -- `convert` leaves an IFF obligation between the two forms; rewriting the
    -- deriv value makes it (P ↔ P)
    convert hU using 1
    rw [hD]
  -- v := f′ (so v′ := f″)
  have hv' : ∀ x ∈ Set.uIcc (j : ℝ) (j + 1 : ℝ),
      HasDerivAt (deriv f) (deriv (deriv f) x) x :=
    fun x hx => (hf2 x hx).hasDerivAt
  have hup_int : IntervalIntegrable (fun x : ℝ => u' x) volume (j : ℝ) (j + 1) := by
    dsimp only [u', cE, cJ]
    simp
    have hcont : Continuous (fun (q : ℝ) => (2 : 𝕜) * ((q : 𝕜) - (j : 𝕜)) - (1 : 𝕜)) := by continuity
    exact hcont.continuousOn.intervalIntegrable
  have hvf_int : IntervalIntegrable (deriv f) volume (j : ℝ) (j + 1) :=
    hcont_f'.intervalIntegrable
  -- the IBP itself
  have hIBP : (∫ x in (j : ℝ)..(j + 1 : ℝ), u x * deriv (deriv f) x) =
      u (j + 1 : ℝ) * deriv f (j + 1 : ℝ) - u (j : ℝ) * deriv f (j : ℝ) -
      (∫ x in (j : ℝ)..(j + 1 : ℝ), u' x * deriv f x) :=
    integral_mul_deriv_eq_deriv_mul hu' hv' hup_int (hcont_f''.intervalIntegrable)
  have hu_j : u (j : ℝ) = 1 / 6 := by
    dsimp only [u, cE, cJ]
    simp
  have hu_j1 : u (j + 1 : ℝ) = 1 / 6 := by
    dsimp only [u, cE, cJ]
    simp
  rw [hu_j, hu_j1] at hIBP
  -- on [j, j+1], u = B̂₂ pointwise, hence ∫ u·f″ = ∫ B̂₂·f″
  have hB2 : (∫ x in (j : ℝ)..(j + 1 : ℝ), u x * deriv (deriv f) x) =
      (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change u x * deriv (deriv f) x = (B2 x : 𝕜) * deriv (deriv f) x
    have hI : x ∈ Set.Icc (j : ℝ) (j + 1 : ℝ) := by
      have hmin : min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) := min_eq_left (by linarith)
      have hmax : max (j : ℝ) (j + 1 : ℝ) = (j + 1 : ℝ) := max_eq_right (by linarith)
      simpa [hmin, hmax] using hx
    have hb : B2 x = (x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 :=
      B2_of_Icc_int j hI
    -- the 1/6 constant bridge (generic RCLike: Rat.cast opaque, computed not recalled):
    -- real-level norm_num, then RCLike.ofReal_ratCast, then norm_num on the 𝕜-rational
    have hreal : (1 / 6 : ℝ) = ((1 / 6 : ℚ) : ℝ) := by
      norm_num
    have hconst : ((1 / 6 : ℝ) : 𝕜) = (1 / 6 : 𝕜) := by
      rw [hreal, RCLike.ofReal_ratCast (1 / 6 : ℚ)]
      norm_num
    have hkr : u x = (((x - (j : ℝ)) ^ 2 - (x - (j : ℝ)) + 1 / 6 : ℝ) : 𝕜) := by
      dsimp only [u, cE, cJ]
      simp
      -- both sides expand to the same real polynomial in (x-j); the only mismatch is
      -- the constant (1/6 : 𝕜) vs ((algebraMap ℝ 𝕜) 6)⁻¹. ofReal_natCast bridges it:
      -- (algebraMap ℝ 𝕜) 6 = (6 : 𝕜) is definitional (rfl), so `have`-ing it in
      -- algebraMap form lets `rw` match (direct rw of the ↑-form does not).
      have h6 : ((algebraMap ℝ 𝕜) 6) = (6 : 𝕜) := RCLike.ofReal_natCast 6
      rw [h6]
      ring
    rw [hkr, hb]
  rw [hB2] at hIBP
  -- algebra: ∫ u′·f′ = ⅙(f′(j+1) − f′(j)) − ∫ B̂₂·f″
  have h1 : (∫ x in (j : ℝ)..(j + 1 : ℝ), u' x * deriv f x) =
      (1 / 6 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
      (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
    linear_combination hIBP
  -- ∫ u′·f′ = ∫ (2·B̂₁)·f′  (pointwise off the single kink x = j+1)
  let S : Set ℝ := {x : ℝ | x ∈ Set.uIoc (j : ℝ) (j + 1 : ℝ) ∧
      u' x * deriv f x ≠ (2 : 𝕜) * (B1 x : 𝕜) * deriv f x}
  have hS : S ⊆ ({(j + 1 : ℝ)} : Set ℝ) := by
    intro x hx
    -- x ∈ S: x ∈ (j, j+1] (uIoc) and u'·f′ x ≠ (2·B̂₁)·f′ x
    have hmin : min (j : ℝ) (j + 1 : ℝ) = (j : ℝ) := min_eq_left (by linarith)
    have hmax : max (j : ℝ) (j + 1 : ℝ) = (j + 1 : ℝ) := max_eq_right (by linarith)
    have hxlo : (j : ℝ) < x := by simpa [hmin] using hx.1.1
    have hxhi : x ≤ (j + 1 : ℝ) := by simpa [hmax] using hx.1.2
    by_contra! htop
    have hxhi' : x < (j + 1 : ℝ) := lt_of_le_of_ne hxhi htop
    have hfloor : (⌊x⌋₊ : ℝ) = (j : ℝ) := by
      norm_cast
      rw [Nat.floor_eq_iff (by linarith [show (0 : ℝ) ≤ x from le_trans (Nat.cast_nonneg j) (le_of_lt hxlo)])]
      constructor
      · norm_cast
        linarith [hxlo]
      · linarith [hxhi']
    have hB1r : (2 : ℝ) * (x - (j : ℝ)) - 1 = 2 * B1 x := by
      dsimp only [B1]
      rw [hfloor]
      ring
    -- split into a scalar identity (no deriv f factor, so `ring` can normalize the
    -- rational constants) and a trivial factor-preserving step
    have hb1 : B1 x = x - (j : ℝ) - 1 / 2 := by
      dsimp only [B1]
      rw [hfloor]
    have hupB1 : u' x = (2 : 𝕜) * (B1 x : 𝕜) := by
      rw [hb1]
      dsimp only [u', cE, cJ]
      -- push the algebraMap into the real RHS constant
      have h1b : ((x - (j : ℝ) - 1 / 2 : ℝ) : 𝕜) = ((x : 𝕜) - (j : 𝕜)) - (1 / 2 : 𝕜) := by
        have hsub : ((x - (j : ℝ) - 1 / 2 : ℝ) : 𝕜) =
            ((x - (j : ℝ) : ℝ) : 𝕜) - ((1 / 2 : ℝ) : 𝕜) := by norm_cast
        have hc1 : ((1 / 2 : ℝ) : 𝕜) = (1 / 2 : 𝕜) := by
          have hcast : ((1 / 2 : ℝ) : 𝕜) = (((1 / 2 : ℚ) : ℝ) : 𝕜) := by
            have : (1 / 2 : ℝ) = ((1 / 2 : ℚ) : ℝ) := by norm_num
            rw [this]
          rw [hcast, RCLike.ofReal_ratCast (1 / 2 : ℚ)]
          norm_num
        have hc2 : ((x - (j : ℝ) : ℝ) : 𝕜) = (x : 𝕜) - (j : 𝕜) := by norm_cast
        rw [hsub, hc1, hc2]
      rw [h1b]
      -- unify the two notations for the real embedding (ofRealCLM vs ↑) so ring sees one atom
      have hE : (RCLike.ofRealCLM (K := 𝕜) x) = (x : 𝕜) := by rfl
      rw [← hE]
      ring
    have heq : u' x * deriv f x = (2 : 𝕜) * (B1 x : 𝕜) * deriv f x := by
      rw [hupB1]

    exact hx.2 heq
  have hae : ∀ᵐ x ∂volume, x ∈ Set.uIoc (j : ℝ) (j + 1 : ℝ) →
      u' x * deriv f x = (2 : 𝕜) * (B1 x : 𝕜) * deriv f x := by
    refine (MeasureTheory.ae_iff (p := fun x =>
        x ∈ Set.uIoc (j : ℝ) (j + 1 : ℝ) →
        u' x * deriv f x = (2 : 𝕜) * (B1 x : 𝕜) * deriv f x)).mpr ?_
    -- {x | ¬p x} = S up to the definitional form of ¬(P → Q)
    have hneg : {x : ℝ | ¬ (x ∈ Set.uIoc (j : ℝ) (j + 1 : ℝ) →
        u' x * deriv f x = (2 : 𝕜) * (B1 x : 𝕜) * deriv f x)} = S := by
      ext x
      constructor
      · intro hx
        push_neg at hx
        exact ⟨hx.1, hx.2⟩
      · intro hx
        push_neg
        exact ⟨hx.1, hx.2⟩
    rw [hneg]
    -- S ⊆ {j+1} and volume {j+1} = 0, so volume S = 0
    have htop1 : volume S ≤ volume ({(j + 1 : ℝ)} : Set ℝ) := MeasureTheory.measure_mono hS
    have htop0 : volume ({(j + 1 : ℝ)} : Set ℝ) = 0 := by
      simp
    have htop2 : 0 ≤ volume S := by
      positivity
    exact le_antisymm (le_trans htop1 (le_of_eq htop0)) htop2
  have h2 : (∫ x in (j : ℝ)..(j + 1 : ℝ), (2 : 𝕜) * (B1 x : 𝕜) * deriv f x) =
      (1 / 6 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
      (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
    rw [← intervalIntegral.integral_congr_ae hae, h1]
  -- factor ½.
  -- the (1/2 : 𝕜)↔((algebraMap ℝ 𝕜) 2)⁻¹ scalar bridge (generic RCLike):
  -- `RCLike.real_smul_eq_coe_mul (1/2 : ℝ) _` normalizes its coe to
  -- ((algebraMap ℝ 𝕜) 2)⁻¹, so hhalf is stated in that form (ofReal_natCast 2
  -- then norm_num). `simpa [hhalf]` closes the two smul↔mul steps.
  have hhalf : (1 / 2 : 𝕜) = ((algebraMap ℝ 𝕜) 2)⁻¹ := by
    have h2c : ((algebraMap ℝ 𝕜) 2) = (2 : 𝕜) := RCLike.ofReal_natCast 2
    rw [h2c]
    norm_num
  calc
    (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x)
        = (1 / 2 : ℝ) • (∫ x in (j : ℝ)..(j + 1 : ℝ), (2 : 𝕜) * (B1 x : 𝕜) * deriv f x) := by
      rw [show (∫ x in (j : ℝ)..(j + 1 : ℝ), B1 x * deriv f x) =
          (∫ x in (j : ℝ)..(j + 1 : ℝ), ((2 : 𝕜) * (B1 x : 𝕜) * deriv f x) * (1 / 2 : 𝕜)) from by
        apply intervalIntegral.integral_congr
        intro x _
        norm_num
        ring,
      intervalIntegral.integral_mul_const (1 / 2 : 𝕜) (fun x => (2 : 𝕜) * (B1 x : 𝕜) * deriv f x),
      mul_comm]
      simpa [hhalf] using (RCLike.real_smul_eq_coe_mul (1 / 2 : ℝ)
        (∫ x in (j : ℝ)..(j + 1 : ℝ), (2 : 𝕜) * (B1 x : 𝕜) * deriv f x)).symm
    _ = (1 / 2 : 𝕜) *
        ((1 / 6 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
        (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x)) := by
      rw [h2]
      simpa [hhalf] using RCLike.real_smul_eq_coe_mul (1 / 2 : ℝ)
        ((1 / 6 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
        (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x))
    _ = (1 / 12 : 𝕜) * (deriv f (j + 1 : ℝ) - deriv f (j : ℝ)) -
        (1 / 2 : 𝕜) * (∫ x in (j : ℝ)..(j + 1 : ℝ), B2 x * deriv (deriv f) x) := by
      ring

end

end

end
