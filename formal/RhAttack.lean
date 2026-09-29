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
-- < side of the §8 contradiction): A0 same-object reduction, A1 triangle
-- split, A2 B-floor + residual exact/bound, A3 detector δ-analysis, A4
-- floor < detector decisions (far LEAN-PROVEN, near PINNED) + A4.3 the
-- Sbar-side |x| ≤ Xval wire. MODULE COMPLETE (A0–A4), no sorry.
import RhAttack.P8Floor

-- Day-020 (2026-09-16, goal turn): P9 — the closure (outline §8): floor vs
-- detector -> no off-line pair. The five machine-proven/pinned pieces
-- composed into the conditional contradiction: pins (f_pin, d_min,
-- margin_min, m_pin), C1-far (far-regime detector floor), C5 (the point
-- squeeze), C0 (the minimal off-line pair height over B0), C5b (the §8
-- closure under the explicit squeezed-margin hypothesis; the C1b
-- own-regime detector-floor promotion remains the open analysis atom).
import RhAttack.Closure
import RhAttack.S4Growth
import RhAttack.W2Kernel
import RhAttack.W2Telescope

-- Day-036 (goal turn): W2Integral (M3) — the per-gap singular-free
-- integral side (plan section 1.3) for NON-STRADDLE gaps: the
-- divided-difference/log/Sm decomposition gapIdentity, plus the
-- continuous-extension-at-t helper midExt (consumed by M4's straddle
-- integrability). GREEN, no sorry.
import RhAttack.W2Integral

-- M4 (W2-LEAN-PLAN 3.6): W2Bound.lean — increment 1 of the section-1.4
-- bounds:  (E1)  |DcSum| <= K * sum_j |DP j|  (the triangle form of the
-- total-variation bound; the sharp endpoint form is the K2 instantiation,
-- next increment),  (E2)  |BTerm| <= K * (|p 0| + |p M|),  plus the
-- deferred M3a straddle lemma:  midExt is continuous — hence
-- interval-integrable — on the straddle gap 0 < a < t < b,  glued from
-- hasDerivAt_iff_tendsto_slope (K3: the slope tends to the derivative
-- along the punctured neighbourhood) + continuousAt_update_same/_of_ne.
-- GREEN, no sorry.
import RhAttack.W2Bound

-- W2M6 (the [S1] A1 pin-and-refutation unit): the c = 1/8 Milino-form
-- K pin at the band frontier t = 3e10 (kmil_3e10_bounds, K in [6.12,
-- 6.15)), the left-pin kernel floor on the band (pG1 t >= 11.51 for
-- 3.2e9 <= t <= 3e10, pinned by E14/E15/E16), the Milino channel floor
-- (K_mil G2_pin * |pG1 G2_pin| >= 70 = milino_channel_ge_70) and the
-- refutation wire (dev_feed = 1 - 13/t < channel = refutation_3e10),
-- plus the e-pins (expfrac/big) that make every step closed rational.
-- GREEN, no sorry.
import RhAttack.W2M6

-- A1Growth (E19): the data-free A1 wire at the PROVABLE growth form.
-- Thin wrapper over W2B3.a1_universal_wire: collapses a pointwise
-- |DN j| <= G(x j) + 1/(x j) (G non-decreasing growth function) to a
-- global K = G(xM) + 1, then calls the already-proven universal wire.
-- Instantiations: a1_growth_wire_log (unconditional S = O(log t),
-- CITED Backlund) and a1_growth_wire_ccm (RH |S| <= (1/4) log/loglog +
-- O-constant, CITED CCM arXiv:1309.1526). The absolute-O(1) clause as
-- originally stated is documented open/probably-false in E19 (the
-- field's omegas + sqrt(loglog) distribution theory contradict it in
-- the limit). GREEN, no sorry.
import RhAttack.A1Growth
