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

STATUS (2026-09-16, Lean 4.33.1): A0, A1, A2a, A2b.1 GREEN.  A2b (the M(G,t) wire) next, then A3-A4, one at a time.  No sorry.

HONEST SPLIT (per-atom):
  A0: LEAN-PROVEN (definitional + ring).
  A1: LEAN-PROVEN (norm_sub_le).
  A2a: B-term LEAN-PROVEN (P4Limit `p4_T4_bound`); the
    Re s = ½ equality `W_n = p4_em_expr` CITED (DLMF 25.2.8 / Apostol
    Thm 12.21 — see P4Limit L5 header); M-term from the B3/B3Sbar
    finite core (see those headers).
  A2b/A3/A4 (coming): see the spec; constants PINNED by measurement
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
import RhAttack.B3

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

/- P8Floor · A2 — the definition-side floor bound.

A2a (LEAN-PROVEN): the B_n(t) bound for the EM expression at the critical
    line s = ½ + it — `p4_T4_bound` (P4Limit L5.e) instantiated.
A2c (CITED): the equality `W_n(s) = p4_em_expr s n` at Re s = ½ —
    DLMF 25.2.8 / Apostol Thm 12.21 (both sides agree on Re s > 1 by
    P4Limit `p4_identity` and are analytic on {Re s > −1}\{−1,−2};
    numerics confirm at the 1/√M rate).  So the machine-provable floor
    for the W_n term is: ‖W_n(½+it)‖ = ‖em_expr‖ ≤ p8_B t n — the
    equality is the cited bridge, the inequality is the proven bound.
A2b (next atom): ‖K − (P_n − I)‖ ≤ M(G, t) — the finite-kernel gap,
    wired to the P5/P6 assets (B3/B3Sbar: `b3BoundExplicit`, K̄(G)).
-/

/-- The P4 floor at the critical line: B_n(t) (three terms, all
    machine-proven by `p4_T4_bound`; s = ½ + it). -/
noncomputable def p8_B (t : ℝ) (n : ℕ) : ℝ :=
    (1 / 2) * (n : ℝ) ^ (-1 / 2 : ℝ) +
    (‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12) * (n : ℝ) ^ (-3 / 2 : ℝ) +
    (Real.sqrt 3 / 540) *
      ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖ * (n : ℝ) ^ (-5 / 2 : ℝ)

/-- Atom A2a (LEAN-PROVEN): ‖p4_em_expr s n‖ ≤ p8_B t n for
    s = ½ + it — `p4_T4_bound` instantiated at the critical line. -/
theorem p8_B_floor {t : ℝ} {n : ℕ} (hn : 0 < n) :
    ‖p4_em_expr (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) n‖ ≤ p8_B t n := by
  set s := ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I with hs
  have hsre : s.re = 1 / 2 := by
    dsimp only [s]
    simp
  exact p4_T4_bound hsre hn

/- P8Floor · A2b — the kernel-residual floor (ζ-free; the P6 assets).

A2b.1 (LEAN-PROVEN): the bridge residual in its exact factorized form —
    `Real.exp Tt · ∏_L F − ∏_{L∪T} F = ∏_{L∪T} F · (e^{Tt − Σ_T ln F} − 1)`
    (P6 `b3ResidualDecomp` + ring).  The entire bridge error is one
    number: the model defect x := Tt − Σ_T ln F, acting on the product.
    No zero-count enters; F is any positive kernel (the on-line pair
    magnitudes of B4 when instantiated).
-/

/-- Atom A2b.1 (LEAN-PROVEN; ζ-free): the exact factored form of the P6
    bridge residual.  For a positive real kernel F on L ++ T,
    e^{Tt}·∏_{g∈L} F(g) − ∏_{g∈L∪T} F(g) = ∏_{g∈L∪T} F(g)·(e^x − 1),
    x := Tt − Σ_{g∈T} ln(F(g)).  This is the bridge of the outline §6
    with the sign made explicit: the residual IS the tail-model error,
    nothing else. -/
theorem p8_residual_exact (L T : List ℝ) (Tt : ℝ) (F : ℝ → ℝ)
    (hpos : ∀ g ∈ L ++ T, 0 < F g) :
    Real.exp Tt * (L.map F).prod - ((L ++ T).map F).prod =
        ((L ++ T).map F).prod *
        (Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) - 1) := by
  have h := B3.b3ResidualDecomp L T Tt F hpos
  rw [h]
  ring
