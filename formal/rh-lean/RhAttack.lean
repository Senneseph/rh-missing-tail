-- This module serves as the root of the `RhAttack` library.
import RhAttack.EulerAction
import RhAttack.E7a
import RhAttack.B4

-- The B-0 section: the counting equivalence of the outline,
-- RH <-> D ≡ 0, over an abstract zero set (RhAttack.B0).
import RhAttack.B0

-- The B-5 core: the exact off-line/on-line ratio theorem (B-5 CORE):
-- R(s,δ) = real prefactor · e^{s·ω_δ}, plus exact magnitude/sign facts
-- and the B5Float 12-point cross-check (RhAttack.B5).
import RhAttack.B5

-- RhAttack.B3 (outline pieces P6/P7 — the bridge identity and the
-- finite Abel/IBP machinery) is intentionally NOT imported: it is not
-- yet green (atomic repair in progress, day-015 journal). Import it
-- here, one line, once it compiles clean — nothing else changes.

-- The B-3 bridge identity: the finite exact Abel decomposition for the
-- counting step N_L, the RVM-comparator bridge (N = NHat + S), the
-- explicit finite bound (Platt–Trudgian S̄), and the ζ-free residual
-- decomposition (RhAttack.B3).
import RhAttack.B3
