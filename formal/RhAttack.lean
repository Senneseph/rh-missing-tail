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
-- finite Abel/IBP machinery) joined the root day-016: the pieces
-- (B3Core/B3Abel/B3Sbar) + B3 are green and imported below; the A/B
-- gate (B3Float) runs as part of `lake exe rhattack`. One progress
-- report per day; state in the day-016 journal.

-- The B-3 bridge identity: the finite exact Abel decomposition for the
-- counting step N_L, the RVM-comparator bridge (N = NHat + S), the
-- explicit finite bound (Platt–Trudgian S̄), and the ζ-free residual
-- decomposition (RhAttack.B3).
import RhAttack.B3

-- RhAttack.P4Em (outline piece P4 — the rigorous missing-tail law,
-- atom-1): the 1st-order Euler–Maclaurin formula, verbatim port from
-- the published Lean proof (PrimeNumberTheoremAnd, Apache 2.0).
-- Engine of the P4 second-order EM + remainder atoms.
import RhAttack.P4Em

-- RhAttack.P4Tail (outline piece P4 — the rigorous missing-tail law,
-- atom-2): the 2nd-order finite Euler–Maclaurin per-period identity
-- int_B1f'_period (the −½f(n)+(1/12)(f′m−f′n)+B̂₂·f″ kernel) via one
-- polynomial IBP per unit period + the a.e. endpoint conversion + the
-- pinned additivity lemma. The only local invention of the P4 line.
-- Day-017: proven green (int_B1f'_period).
import RhAttack.P4Tail

-- Day-019 (2026-09-12): the GLOBAL finite 2nd-order Euler–Maclaurin law
-- (atom-2b): ico_sum_telescope + em2_finite, stitching the per-period
-- identity over [n, m] via sum_integral_adjacent_intervals_Ico.
-- (First red pass day-017; green day-019 — state in the day journal.)
import RhAttack.P4Em2

-- Day-019 (2026-09-12, goal turn): the M→∞ passage (P4 atoms L1–L5): the
-- derivative family for x ↦ (x:ℂ)^{−s} (L1), the finite EM identity (L2),
-- kernel convergence (L3), the OP1/OP2 remainder bounds (L4), and the
-- stated zero-free bound |W_n(t)| ≤ B_n(t) (L5).
import RhAttack.P4Limit

-- Day-020 (2026-09-16, goal turn): P8 Route A — the residual floor (the
-- < side of the §8 contradiction): A0 same-object reduction + A1
-- triangle split (GREEN); A2–A4 in progress per the spec
-- (kainos-logos plan/.../spec/p8floor-routeA-abstract.md).
import RhAttack.P8Floor
