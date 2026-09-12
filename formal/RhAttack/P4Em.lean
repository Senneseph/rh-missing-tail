/- P4Em — the 1st-order Euler–Maclaurin formula, verbatim port.

OUTLINE piece: P4 (the rigorous missing-tail law, §9 row P4), Atom-1
(spec: plan/40-prize-islands/rh-attack/spec/p4-tail-law-abstract.md §0.6/§T3).

ROLE: the engine of the second-order EM derivation (Atom-2) and of the
B̂₁-remainder form of the tail of Σ k^{−s} — the definition-side core
of W_n(t) for the floor (P8).

APPROACH: VERBATIM PORT (published solution, day-017 online search;
the owner's hunch that a prior formalization exists — it does).
Source: https://github.com/AlexKontorovich/PrimeNumberTheoremAnd, file
PrimeNumberTheoremAnd/EulerMaclaurin.lean (a PNT proof in Lean,
v4.32.2 / mathlib 905b958; the zeta-23-lean fork carries the same
verbatim content). Copyright the PrimeNumberTheoremAnd contributors;
Apache License 2.0. Local modifications: none (verbatim copy); the
target of our pinned 4.33.1 mathlib. The one dependency,
`Mathlib.NumberTheory.AbelSummation.sum_mul_eq_sub_sub_integral_mul`,
is verified present in the pinned mathlib (AbelSummation.lean:129).
`import Mathlib` (vs the upstream single-module import) matches this
package's convention; the file body is otherwise byte-identical.
Local deviations EXACTLY ONE: `set_option linter.style.longLine false`
(upstream lines exceed 100 chars; reflowing would break byte-identity).

STATUS: ported day-017; compiles against Lean 4.33.1 + pinned mathlib
(build `lake build RhAttack.P4Em`, exit 0, 8706 jobs, no errors).

THEOREMS (global names, per the ProbeN name-global pin):
  B1 — the 1st periodic Bernoulli function (x − ⌊x⌋₊ − ½)
  aestronglyMeasurable_B1, abs_B1_le_half
  integral_deriv_mul_add_const, intervalIntegrable_deriv_mul_B1
  integral_deriv_mul_floor_add_one
  sum_eq_integral_add_integral_deriv — the 1st-order EM identity:
    ∑ k ∈ Ioc ⌊a⌋ ⌊b⌋, f k =
      f a·B1 a − f b·B1 b + ∫_a^b f + ∫_a^b f′·B1
    for [RCLike 𝕜] (ℝ or ℂ), a ≤ b, f differentiable, f′ continuous.
-/
import Mathlib
import Mathlib.NumberTheory.AbelSummation

set_option linter.style.longLine false  -- verbatim port: upstream lines > 100 chars

@[expose] public section

open Finset Interval MeasureTheory

variable {𝕜 : Type*} [RCLike 𝕜] {f : ℝ → 𝕜} {a b : ℝ}

/-- The 1st Bernoulli function. -/
noncomputable def B1 (x : ℝ) : ℝ := x - ⌊x⌋₊ - 1 / 2

@[fun_prop]
lemma aestronglyMeasurable_B1 : AEStronglyMeasurable B1 := by
  unfold B1
  fun_prop

lemma abs_B1_le_half {x : ℝ} (hx : 0 ≤ x) : |B1 x| ≤ 1 / 2 := by
  unfold B1
  refine abs_le.mpr ⟨?_, ?_⟩
  · grind [Nat.floor_le hx]
  · grind [Nat.lt_succ_floor x]

lemma integral_deriv_mul_add_const (c : 𝕜) (hab : a ≤ b) (h_int : IntervalIntegrable (deriv f) volume a b)
    (hf_diff : ∀ t ∈ Set.Icc a b, DifferentiableAt ℝ f t) :
    ∫ t in a..b, (t + c) * deriv f t = (b + c) * f b - (a + c) * f a - ∫ t in a..b, f t := by
  rw [← Set.uIcc_of_le hab] at hf_diff
  have : ∀ t ∈ [[a, b]], HasDerivAt (fun (t : ℝ) ↦ t + c) 1 t := by
    intro t ht
    simp only [hasDerivAt_add_const_iff]
    convert! ContinuousLinearMap.hasDerivAt (RCLike.ofRealCLM (K := 𝕜)) using 1
    simp
  replace hf_diff := fun t ht ↦ (hf_diff t ht).hasDerivAt
  rw [intervalIntegral.integral_mul_deriv_eq_deriv_mul this hf_diff (by simp) h_int]
  simp

lemma intervalIntegrable_deriv_mul_B1 (ha : 0 ≤ a) (hab : a ≤ b) (h_cont : ContinuousOn (deriv f) [[a, b]]) :
    IntervalIntegrable (fun t ↦ deriv f t * B1 t) volume a b := by
  refine IntervalIntegrable.continuousOn_mul ?_ h_cont
  rw [intervalIntegrable_iff']
  apply MeasureTheory.Measure.integrableOn_of_bounded (by simp) (by fun_prop) (M := 1 / 2)
  filter_upwards [self_mem_ae_restrict (by measurability)] with x hx
  rw [Set.uIcc_of_le hab, Set.mem_Icc] at hx
  norm_cast
  exact abs_B1_le_half (by linarith)

lemma integral_deriv_mul_floor_add_one (ha : 0 ≤ a) (hab : a ≤ b)
    (hf_diff : ∀ t ∈ Set.Icc a b, DifferentiableAt ℝ f t) (h_cont : ContinuousOn (deriv f) [[a, b]]) :
    ∫ t in a..b, deriv f t * (⌊t⌋₊ + 1) = (b + 1 / 2) * f b - (a + 1 / 2) * f a - (∫ t in a..b, f t) - ∫ t in a..b, deriv f t * B1 t := by
  calc
  _ = ∫ t in a..b, (deriv f t * (t + 1 / 2) -deriv f t * B1 t) := by
    congr
    ext
    simp only [B1]
    push_cast
    ring
  _ = (∫ t in a..b, deriv f t * (t + 1 / 2)) - ∫ t in a..b, deriv f t * B1 t := by
    exact intervalIntegral.integral_sub (ContinuousOn.intervalIntegrable (by fun_prop)) (intervalIntegrable_deriv_mul_B1 ha hab h_cont)
  _ = _ := by
    conv => lhs; arg 1; arg 1; ext; rw [mul_comm]
    rw [integral_deriv_mul_add_const _ hab h_cont.intervalIntegrable hf_diff]

theorem sum_eq_integral_add_integral_deriv (ha : 0 ≤ a) (hab : a ≤ b)
    (hf_diff : ∀ t ∈ Set.Icc a b, DifferentiableAt ℝ f t)
    (h_cont : ContinuousOn (deriv f) [[a, b]]) :
    ∑ k ∈ Ioc ⌊a⌋₊ ⌊b⌋₊, f k =
      f a * B1 a - f b * B1 b + (∫ t in a..b, f t) + ∫ t in a..b, deriv f t * B1 t  := by
  have := sum_mul_eq_sub_sub_integral_mul (fun _ ↦ 1) ha hab hf_diff (Set.uIcc_of_le hab ▸ h_cont).integrableOn_Icc
  simp only [mul_one, sum_const, Nat.card_Icc, tsub_zero, nsmul_eq_mul, Nat.cast_add,
    Nat.cast_one] at this
  rw [this, ← intervalIntegral.integral_of_le hab]
  rw [integral_deriv_mul_floor_add_one ha hab hf_diff h_cont]
  unfold B1
  push_cast
  ring
