/-
Rh-missing-tail, D4 argument-principle line (ap3) -- the zero-count growth stack + Backlund
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
import Mathlib.Algebra.Lie.OfAssociative

-- Instance-search hygiene carried verbatim from the source
-- (Prelude/InstancePriorities.lean): demote LieAlgebra.toModule so the
-- NormedSpace path for complex derivatives is tried first.
attribute [instance 10] LieAlgebra.toModule

namespace Ap3

/-- Reverse triangle inequality, restored under the legacy name
(`norm_sub_norm_le` was renamed away in current Mathlib; the AP ports from the
zeta-23 era use the old name at several call sites in `Ap3Growth` /
`Ap3LocalCount` / `Ap3StrongPNTPrefix`). -/
theorem norm_sub_norm_le (a b : ℂ) : ‖a‖ - ‖b‖ ≤ ‖a - b‖ := by
  have := norm_add_le (a - b) b
  rw [show (a - b) + b = a by ring] at this
  linarith

/-- Absolute-value variant (for call sites needing the symmetric form). -/
theorem abs_norm_sub_norm_le (a b : ℂ) : |‖a‖ - ‖b‖| ≤ ‖a - b‖ := by
  have hh3 : ‖b - a‖ = ‖a - b‖ := by rw [show b - a = -(a - b) by ring, norm_neg]
  rw [abs_le]
  constructor
  · have := norm_sub_norm_le b a
    rw [hh3] at this
    linarith
  · exact norm_sub_norm_le a b

end Ap3
