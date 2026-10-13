/-
Rh-missing-tail, D4 argument-principle line (ap2) -- the RVM window
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
import RhAttack.Ap2Defs
set_option linter.style.header false

namespace Ap2


open Set

noncomputable section

namespace Zeta23.ZeroConfig

variable (Z : ZeroConfig) (T₁ T₂ : ℝ)

lemma window_finite : (Z.window T₁ T₂).Finite := Z.finite_window T₁ T₂

lemma window_subset_carrier : Z.window T₁ T₂ ⊆ Z.carrier := inter_subset_left

/-- For s inside a window: #s ≤ Σ_{ρ∈s} m_ρ (since m_ρ ≥ 1). -/
lemma ncard_le_finsum_mult {s : Set ℂ} (hs : s ⊆ Z.window T₁ T₂) :
    s.ncard ≤ ∑ᶠ ρ ∈ s, Z.mult ρ := by
  have hfin : s.Finite := (Z.window_finite T₁ T₂).subset hs
  rw [Set.ncard_eq_toFinset_card s hfin, finsum_mem_eq_finite_toFinset_sum _ hfin,
    Finset.card_eq_sum_ones]
  apply Finset.sum_le_sum
  intro ρ hρ
  exact Z.one_le_mult ρ (Z.window_subset_carrier T₁ T₂ (hs (hfin.mem_toFinset.mp hρ)))

/-- Monotonicity of Σ m_ρ over finite subsets of a window. -/
lemma finsum_mult_mono {s t : Set ℂ} (hst : s ⊆ t) (ht : t ⊆ Z.window T₁ T₂) :
    ∑ᶠ ρ ∈ s, Z.mult ρ ≤ ∑ᶠ ρ ∈ t, Z.mult ρ := by
  have htf : t.Finite := (Z.window_finite T₁ T₂).subset ht
  have hsf : s.Finite := htf.subset hst
  rw [finsum_mem_eq_finite_toFinset_sum _ hsf, finsum_mem_eq_finite_toFinset_sum _ htf]
  apply Finset.sum_le_sum_of_subset
  exact Set.Finite.toFinset_subset_toFinset.mpr hst

lemma ncard_mono {s t : Set ℂ} (hst : s ⊆ t) (ht : t ⊆ Z.window T₁ T₂) : s.ncard ≤ t.ncard :=
  Set.ncard_le_ncard hst ((Z.window_finite T₁ T₂).subset ht)

/-- [eq:trivialchain] for an abstract zero configuration:
N₀ˢ ≤ N₀* ≤ N₀ ≤ N and N₀ˢ ≤ Nˢ ≤ N_d ≤ N. -/
theorem trivial_chain :
    Z.N0s T₁ T₂ ≤ Z.N0star T₁ T₂ ∧ Z.N0star T₁ T₂ ≤ Z.N0 T₁ T₂ ∧ Z.N0 T₁ T₂ ≤ Z.N T₁ T₂ ∧
    Z.N0s T₁ T₂ ≤ Z.Ns T₁ T₂ ∧ Z.Ns T₁ T₂ ≤ Z.Nd T₁ T₂ ∧ Z.Nd T₁ T₂ ≤ Z.N T₁ T₂ := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact Z.ncard_mono T₁ T₂ inter_subset_left inter_subset_left
  · exact Z.ncard_le_finsum_mult T₁ T₂ inter_subset_left
  · exact Z.finsum_mult_mono T₁ T₂ inter_subset_left subset_rfl
  · exact Z.ncard_mono T₁ T₂ (inter_subset_inter_left _ inter_subset_left) inter_subset_left
  · exact Z.ncard_mono T₁ T₂ inter_subset_left subset_rfl
  · exact Z.ncard_le_finsum_mult T₁ T₂ subset_rfl

/-- N_d ≤ N on any window (distinct ≤ with multiplicity). -/
lemma Nd_le_N : Z.Nd T₁ T₂ ≤ Z.N T₁ T₂ := (Z.trivial_chain T₁ T₂).2.2.2.2.2

/-- N₀* ≤ N_d. -/
lemma N0star_le_Nd : Z.N0star T₁ T₂ ≤ Z.Nd T₁ T₂ :=
  Z.ncard_mono T₁ T₂ inter_subset_left subset_rfl

end Zeta23.ZeroConfig

end Ap2
