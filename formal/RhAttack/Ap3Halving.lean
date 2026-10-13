/-
Rh-missing-tail, D4 argument-principle line (ap3) -- the RvM bound layer
identity, in-house port.

Ported from https://github.com/anthropics/formal-math (the former
zeta-23-lean), commit e1a4e6508154, Apache License 2.0:
  * Copyright (c) 2026 Anthropic, PBC.
  * Copyright the PrimeNumberTheoremAnd contributors
    (https://github.com/AlexKontorovich/PrimeNumberTheoremAnd).
Provenance and license preserved per the project borrow rule; the port
is cited in formal/RH-LEAN-PROVENANCE.md.

Changes in this port (mechanical, per project convention):
  * `import Mathlib` (whole library) in place of per-file import
    lists;
  * content namespaced under `Ap2`;
  * intra-project imports redirected to RhAttack.Ap1*/Ap2*;
  * the Zeta23.Hypotheses import dropped where the part actually
    ported does not use the paper inputs (the definitions + the seam
    need no paper hypotheses).
-/
import Mathlib
import RhAttack.Ap2Statementset_option linter.style.header false

namespace Ap3

open Ap2


open Set

noncomputable section


@[simp] lemma reflect_re (ρ : ℂ) : (reflect ρ).re = 1 - ρ.re := by simp [reflect]
@[simp] lemma reflect_im (ρ : ℂ) : (reflect ρ).im = ρ.im := by simp [reflect]

@[simp] lemma reflect_reflect (ρ : ℂ) : reflect (reflect ρ) = ρ := by
  simp [reflect]

lemma reflect_injective : Function.Injective reflect :=
  Function.LeftInverse.injective reflect_reflect

namespace Ap2.ZeroConfig

variable (Z : ZeroConfig) (T₁ T₂ : ℝ)

lemma reflect_mem_window {ρ : ℂ} (h : ρ ∈ Z.window T₁ T₂) : reflect ρ ∈ Z.window T₁ T₂ :=
  ⟨Z.reflect_mem ρ h.1, by simpa [reflect_im] using h.2⟩

/-- **Reflection halving.** N(T₁,T₂) ≤ 2 · Σ_{ρ ∈ window, Re ρ ≥ 1/2} m_ρ (as reals). -/
theorem N_le_two_mul_half :
    (Z.N T₁ T₂ : ℝ) ≤ 2 * ∑ᶠ ρ ∈ Z.window T₁ T₂ ∩ {ρ | 1 / 2 ≤ ρ.re}, (Z.mult ρ : ℝ) := by
  have hW : (Z.window T₁ T₂).Finite := Z.window_finite T₁ T₂
  set A := Z.window T₁ T₂ ∩ {ρ | ρ.re < 1 / 2} with hAdef
  set B := Z.window T₁ T₂ ∩ {ρ | 1 / 2 ≤ ρ.re} with hBdef
  have hA : A.Finite := hW.subset inter_subset_left
  have hB : B.Finite := hW.subset inter_subset_left
  have hWAB : Z.window T₁ T₂ = A ∪ B := by
    ext ρ
    simp only [hAdef, hBdef, mem_union, mem_inter_iff, mem_setOf_eq]
    constructor
    · intro h
      rcases lt_or_ge ρ.re (1 / 2) with h' | h'
      · exact Or.inl ⟨h, h'⟩
      · exact Or.inr ⟨h, h'⟩
    · rintro (⟨h, _⟩ | ⟨h, _⟩) <;> exact h
  have hdisj : Disjoint A B := by
    rw [Set.disjoint_left]
    rintro ρ ⟨_, h1⟩ ⟨_, h2⟩
    simp only [mem_setOf_eq] at h1 h2
    linarith
  have hN : Z.N T₁ T₂ = ∑ᶠ ρ ∈ A, Z.mult ρ + ∑ᶠ ρ ∈ B, Z.mult ρ := by
    unfold ZeroConfig.N
    rw [hWAB, finsum_mem_union hdisj hA hB]
  have himage : reflect '' A ⊆ B := by
    rintro _ ⟨ρ, ⟨hρW, hlt⟩, rfl⟩
    refine ⟨Z.reflect_mem_window T₁ T₂ hρW, ?_⟩
    simp only [mem_setOf_eq, reflect_re] at hlt ⊢
    linarith
  have hAB : ∑ᶠ ρ ∈ A, Z.mult ρ ≤ ∑ᶠ ρ ∈ B, Z.mult ρ := by
    calc ∑ᶠ ρ ∈ A, Z.mult ρ = ∑ᶠ ρ ∈ A, Z.mult (reflect ρ) :=
          finsum_mem_congr rfl (fun ρ hρ => (Z.mult_reflect ρ hρ.1.1).symm)
      _ = ∑ᶠ σ ∈ reflect '' A, Z.mult σ := (finsum_mem_image reflect_injective.injOn).symm
      _ ≤ ∑ᶠ σ ∈ B, Z.mult σ := Z.finsum_mult_mono T₁ T₂ himage inter_subset_left
  have hcast : (∑ᶠ ρ ∈ B, (Z.mult ρ : ℝ)) = ((∑ᶠ ρ ∈ B, Z.mult ρ : ℕ) : ℝ) := by
    rw [finsum_mem_eq_finite_toFinset_sum _ hB, finsum_mem_eq_finite_toFinset_sum _ hB,
      Nat.cast_sum]
  rw [hcast, hN]
  have hAB' : ((∑ᶠ ρ ∈ A, Z.mult ρ : ℕ) : ℝ) ≤ ((∑ᶠ ρ ∈ B, Z.mult ρ : ℕ) : ℝ) := by
    exact_mod_cast hAB
  push_cast
  linarith

end Ap2.ZeroConfig

end Ap3
