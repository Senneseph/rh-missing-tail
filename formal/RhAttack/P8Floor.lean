/- P8 — Route A: the residual floor (the < side of the §8 contradiction).

SPEC: kainos-logos plan/40-prize-islands/rh-attack/spec/p8floor-routeA-abstract.md
OUTLINE: rh-missing-tail docs/RH-PROOF-OUTLINE.md §10 (required theorem),
  §6 (bridge), §7 (detector), §8 (closure), §9 (status table P8).

ROLE: proves the §10 statement
  | W_n(t) − [ K_on(t) − (P_n−I) ] | < min_δ f(δ, t)
from the definition side alone: no zero-count at any height enters the
proof; the height bound T never appears.  Atom plan (spec §2):
  A0: W_n definition + the same-object reduction (LHS = ζ(s) − K_on).
  A1: the triangle split into ‖W_n‖ (P4 floor input) + ‖K − (P_n − I)‖.
  A2: the B_n(t) floor (P4Limit L5) + the M(G,t) bound (P5/P6 assets).
  A3: δ-minimization of the detector scale (builds on B5: b5Ratio, b5Abs,
      b5NoffIsPolynomial, b5NoffPos).
  A4: comparison floor < detector under the measurement-pinned constants.

STATUS (2026-09-16, Lean 4.33.1): A0 + A1 GREEN.  A2–A4 in progress,
one at a time.  No sorry.

HONEST SPLIT (per-atom):
  A0: LEAN-PROVEN (definitional + ring).
  A1: LEAN-PROVEN (norm_sub_le).
  A2 (coming): B-term LEAN-PROVEN (P4Limit `p4_T4_bound`); the
    Re s = ½ equality `W_n = p4_em_expr` CITED (DLMF 25.2.8 / Apostol
    Thm 12.21 — see P4Limit L5 header); M-term from the B3/B3Sbar
    finite core (see those headers).
  A3/A4 (coming): see the spec; constants PINNED by measurement
    (P4Float gate; day-017/019 audit).

CITATIONS (outline §11 + day logs): DLMF 25.2.8/25.2.9/25.2.12;
  Apostol 12.21; Platt–Trudgian (S̄, M(G,t)); the measured margin
  (≥ 14× at the pair's own height vs the local audit floor; ceiling
  t ≈ 10⁴–2×10⁴) — PINNED, not proven here.

DISCIPLINE: constants are computed, never recalled; no
`theorem ... riemann`; one green commit per atom; probe files deleted
after use; numerics sanity-check only.
-/

import Mathlib
import RhAttack.P4Limit

open Real Finset List

/-! P8Floor · A0 — the definition side and the same-object reduction.

Lean-proof obligation of the outline's §10 statement: the LHS
W_n(t) − [K_on(t) − (P_n − I)] is *identically* ζ(s) − K_on — "definition
side" and "zero side" are the same object (bridge §6) before any
inequality is applied.
-/

/-- W_n(s) := ζ(s) − P_n(s) + I(n,s) — the missing tail (P4Limit's
    W_n; the sign correction of spec p4-tail-law §0.5). -/
noncomputable def p4_Wn (s : ℂ) (n : ℕ) : ℂ :=
    riemannZeta s - p4_P n s + p4_I n s

/-- Atom A0 (LEAN-PROVEN): the same-object reduction.  For ANY kernel
    value K (to be instantiated with the on-line kernel K_on when the
    concrete kernel is wired in A2),
    W_n(s) − (K − (P_n(s) − I(n,s))) = ζ(s) − K.
    This is the bridge statement of §6 in its bare algebraic form: no
    product is evaluated, no zero enters. -/
theorem p8_same_object (s : ℂ) (n : ℕ) (K : ℂ) :
    p4_Wn s n - (K - (p4_P n s - p4_I n s)) = riemannZeta s - K := by
  dsimp only [p4_Wn]
  ring

/-/ Atom A1 (LEAN-PROVEN): the triangle split the floor must dominate.
    ‖ζ(s) − K‖ ≤ ‖W_n(s)‖ + ‖K − (P_n(s) − I(n,s))‖.
    First summand: the P4 EM floor (p4_T4_bound / p4_T4_ratio, P4Limit L5).
    Second summand: the finite-kernel-vs-partial-sum gap (A2 wires the
    M(G,t) assets for it). -/
theorem p8_triangle (s : ℂ) (n : ℕ) (K : ℂ) :
    ‖riemannZeta s - K‖ ≤ ‖p4_Wn s n‖ + ‖K - (p4_P n s - p4_I n s)‖ := by
  rw [(p8_same_object s n K).symm]
  exact norm_sub_le (p4_Wn s n) (K - (p4_P n s - p4_I n s))
