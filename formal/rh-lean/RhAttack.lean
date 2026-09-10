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
