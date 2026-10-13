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
