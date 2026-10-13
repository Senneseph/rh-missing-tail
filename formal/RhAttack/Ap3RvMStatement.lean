/-
Rh-missing-tail, D4 argument-principle line (ap4) -- the RvM main-term assembly
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
import RhAttack.Ap3MainTerm
import RhAttack.Ap3LocalCount
import RhAttack.Ap3Hypotheses
set_option linter.style.header false

namespace Ap3

open Ap2


noncomputable section


/-- **H-RvM for Mathlib's ζ**, given the Γ-facts. -/
theorem riemannVonMangoldt (hΓ : GammaFacts) : RiemannVonMangoldt zetaZeroConfig :=
  ⟨rvM_main hΓ, zetaZeroConfig_local_count⟩


/-! ## Self-test (ap4) -- the assembled formula, no extra hypotheses -/

open Ap2

/-- **Riemann-von Mangoldt, main term, fully assembled, hypothesis-free.**
    The Stirling and digamma inputs are all proved from Mathlib by the
    ported GammaFacts discharge, so no paper input survives:
    N(T,2T) = (T/2pi)·ell1(T) + O(log T)  (exact statement as rvM_main). -/
theorem ap4_selftest_rvM_main_no_extra_hypotheses : ∃ C T₀ : ℝ, ∀ T : ℝ, T₀ ≤ T →
    |(Ncount T (2 * T) : ℝ) - T / (2 * Real.pi) * ell1 T| ≤ C * Real.log T := by
  exact rvM_main gammaFacts

/-- The packaged version (the RiemannVonMangoldt property of the zero
    configuration), also discharged: `riemannVonMangoldt` + `gammaFacts`. -/
theorem ap4_selftest_riemannVonMangoldt_no_extra_hypotheses :
    RiemannVonMangoldt zetaZeroConfig :=
  riemannVonMangoldt gammaFacts

end Ap3
