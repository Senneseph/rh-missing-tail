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

STATUS (2026-09-16, Lean 4.33.1): A0, A1, A2a, A2b.1-A2b.2, A3.1, A3.2a, A3.2b.1 GREEN.  A2b (the M(G,t) wire) next, then A3-A4, one at a time.  No sorry.

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
import RhAttack.B5

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

/-- Real-analysis pin (LEAN-PROVEN): |e^x − 1| ≤ e^{|x|}·|x| for all x.
    Pins: `Real.add_one_lt_exp` (x ≠ 0 ⇒ x + 1 < e^x), `Real.one_le_exp`
    (0 ≤ x ⇒ 1 ≤ e^x), `Real.exp_lt_exp`, `abs_of_nonneg`/`abs_of_neg`.
    No MVT needed: for x ≥ 0, e^x − 1 ≤ x·e^x (since
    e^x − 1 − x·e^x = e^x(1 − x) − 1 < 0); for x < 0,
    1 − e^x < −x (i.e. x + 1 < e^x at x ≠ 0). -/
theorem p8_abs_exp_sub_one_le (x : ℝ) :
    |Real.exp x - 1| ≤ Real.exp |x| * |x| := by
  by_cases hx0 : 0 ≤ x
  · have hlt : Real.exp x - 1 ≤ x * Real.exp x := by
      by_cases hx' : x = 0
      · subst x
        norm_num
      · -- e^x − 1 − x·e^x = e^x(1 − x) − 1, and
        --     e^x(1 − x) < 1 via −x + 1 < e^{−x} (add_one_lt_exp at −x)
        have hB : -x + 1 < Real.exp (-x) := add_one_lt_exp (neg_ne_zero.mpr hx')
        have hB' : (1 - x : ℝ) < Real.exp (-x) := by
          rw [sub_eq_add_neg, add_comm]
          exact hB
        have hC : Real.exp x * (1 - x) < 1 := by
          have hD : Real.exp x * (1 - x) < Real.exp x * Real.exp (-x) := by
            simpa [mul_comm] using mul_lt_mul_of_pos_right hB' (Real.exp_pos x)
          calc Real.exp x * (1 - x)
              < Real.exp x * Real.exp (-x) := hD
            _ = 1 := by
                  rw [← Real.exp_add x (-x)]
                  simp
        rw [← sub_nonpos]
        have hE : Real.exp x - 1 - x * Real.exp x = Real.exp x * (1 - x) - 1 := by
          ring
        rw [hE]
        linarith [le_of_lt hC]
    have hge : 1 ≤ Real.exp x := one_le_exp hx0
    calc |Real.exp x - 1|
        = Real.exp x - 1 := abs_of_nonneg (by linarith)
      _ ≤ x * Real.exp x := hlt
      _ = Real.exp |x| * |x| := by rw [mul_comm, abs_of_nonneg hx0]
  · have hneg : x < 0 := not_le.mp hx0
    have hlt2 : 1 - Real.exp x < -x := by
      have hA : x + 1 < Real.exp x := add_one_lt_exp (by linarith)
      linarith
    have hlt3 : Real.exp x < 1 := by
      simpa [Real.exp_zero] using Real.exp_lt_exp.mpr hneg
    calc |Real.exp x - 1|
        = 1 - Real.exp x := by rw [abs_of_neg (by linarith [hlt3]), neg_sub]
      _ ≤ 0 - x := by simpa using le_of_lt hlt2
      _ = |x| := by simpa using (abs_of_neg hneg).symm
      _ = 1 * |x| := by ring
      _ ≤ Real.exp |x| * |x| :=
          mul_le_mul_of_nonneg_right (one_le_exp (abs_nonneg x)) (abs_nonneg x)

/- P8Floor · A2b.2 — the floor bound itself: the factored residual is
    bounded by the product times the subadditive exp estimate in the
    model defect x := Tt − Σ_T ln F.  (LEAN-PROVEN; ζ-free; no counting
    input.)  This is the < side at the kernel-model level: the size of
    the bridge error is the size of the product (the kernel's own mass)
    times a function of the ONE model-defect number — which the P5/P6
    S̄ machinery (B3Sbar `b3BoundExplicit`) then bounds in terms of G
    alone.
-/

/-- Atom A2b.2 (LEAN-PROVEN; ζ-free): |e^{Tt}·∏_L F − ∏_{L∪T} F| ≤
    (∏_{L∪T} F)·e^{|x|}·|x| with x := Tt − Σ_{g∈T} ln(F(g)) — the
    A2b.1 factored form + `p8_abs_exp_sub_one_le` + positivity of the
    product. -/
theorem p8_residual_bound (L T : List ℝ) (Tt : ℝ) (F : ℝ → ℝ)
    (hpos : ∀ g ∈ L ++ T, 0 < F g) :
    |Real.exp Tt * (L.map F).prod - ((L ++ T).map F).prod| ≤
        ((L ++ T).map F).prod *
        Real.exp |Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum| *
        |Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum| := by
  set x := Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum with hx
  have hFact : Real.exp Tt * (L.map F).prod - ((L ++ T).map F).prod =
      ((L ++ T).map F).prod * (Real.exp x - 1) := by
    rw [p8_residual_exact L T Tt F hpos, ← hx]
  have hK : 0 < ((L ++ T).map F).prod := by
    apply List.prod_pos
    intro b hb
    obtain ⟨g, hgm, hbeq⟩ := List.mem_map.mp hb
    rw [hbeq.symm]
    exact hpos g hgm
  have hFact' : Real.exp Tt * (L.map F).prod - ((L ++ T).map F).prod =
      ((L ++ T).map F).prod * (Real.exp x - 1) := hFact
  calc |Real.exp Tt * (L.map F).prod - ((L ++ T).map F).prod|
      = |((L ++ T).map F).prod * (Real.exp x - 1)| := by rw [hFact']
    _ = ((L ++ T).map F).prod * |Real.exp x - 1| := by
          rw [abs_mul, abs_of_pos hK]
    _ ≤ ((L ++ T).map F).prod * (Real.exp |x| * |x|) :=
          mul_le_mul_of_nonneg_left (p8_abs_exp_sub_one_le x) (le_of_lt hK)
    _ = ((L ++ T).map F).prod * Real.exp |Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum| *
          |Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum| := by
          rw [hx]
          ring

/- P8Floor · A3 — the detector's δ-structure (builds on B5).

A3.1 (LEAN-PROVEN): the off-line numerator
    N(δ) := ((t−γ)²+δ²)·((t+γ)²+δ²)
is a δ-polynomial with all-nonnegative coefficients —
B5 `b5NoffIsPolynomial`: N(δ) = (t²−γ²)² + 2δ²(t²+γ²) + δ⁴ —
hence N is monotone nondecreasing in δ² and minimized at δ = 0:
    N(0) ≤ N(δ) for all δ.
This is the algebraic core of the outline §7 "no dead δ window"
(`b5NoffPos`: N(δ) > 0 for every δ when t ≠ γ — also already
LEAN-PROVEN in B5).  The δ-minimum of the FULL detector scale
‖R − 1‖ (with pref + phase, B5 `b5Abs`/`b5PrefSign`) is A3.2 —
next atom; its branch locus (t = γ) is handled by the limit
analysis, pinned by the measured near-regime (0.9975–1.0201).
-/

/-- Atom A3.1 (LEAN-PROVEN; the δ-minimum of the off-line numerator at
    δ = 0): for all γ, t, δ,
    ((t−γ)² + 0²)·((t+γ)² + 0²) ≤ ((t−γ)² + δ²)·((t+γ)² + δ²) —
    B5 `b5NoffIsPolynomial` twice: both sides = (t²−γ²)² +
    2δ²(t²+γ²) + δ⁴ (left with δ = 0), and the extra terms are
    nonnegative.  The detector's numerator therefore cannot shrink
    by moving the pair off the line — no dead δ window (outline §7). -/
theorem p8_noff_delta_min (γ t : ℝ) (δ : ℝ) :
    ((t - γ) ^ 2 + 0 ^ 2) * ((t + γ) ^ 2 + 0 ^ 2) ≤
      ((t - γ) ^ 2 + δ ^ 2) * ((t + γ) ^ 2 + δ ^ 2) := by
  rw [b5NoffIsPolynomial γ t δ, b5NoffIsPolynomial γ t 0]
  nlinarith [sq_nonneg δ, sq_nonneg (δ ^ 2), sq_nonneg t, sq_nonneg γ]

/- P8Floor · A3.2 — the detector magnitude lower bound (reverse triangle
    + the B5 closed form).

A3.2a (LEAN-PROVEN): ‖R − 1‖ ≥ |‖R‖ − 1| (reverse triangle) so the
     detector scale is controlled below by the closed magnitude of B5
     `b5Abs`: |‖R‖ − 1| = ||pref|·e^{ω/2} − 1|.
A3.2b (PINNED floor — next atom): the explicit near/far lower bound
     for |‖R‖ − 1| (near pair: the measured 0.9975; far: the
     (t/γ)²−1 family, B5 `b5Abs` + the δ-monotone numerator of A3.1);
     the sharp δ-analysis at the branch locus (t = γ, where
     b5Ratio's hypotheses exclude t = γ) is carried by the limit
     pinned by the day-017/019 near-regime audit.
-/

/-- Atom A3.2a (LEAN-PROVEN): reverse triangle — the detector scale
    ‖R − 1‖ is bounded below by |‖R‖ − 1| in any normed group.  With B5
    `b5Abs` this routes the detector's ≥ side through the closed
    magnitude |pref|·e^{ω/2}.  Pin: `abs_dist_sub_le` (x y z:
    |dist x z − dist y z| ≤ dist x y) at x := R, y := 1, z := 0. -/
theorem p8_detector_abs_lower (γ δ t : ℝ) :
    ‖Rratio γ δ t - 1‖ ≥ |‖Rratio γ δ t‖ - 1| := by
  simpa [dist_eq_norm] using abs_dist_sub_le (Rratio γ δ t) (1 : ℂ) 0

/- P8Floor · A3.2b — the detector at δ = 0 (the on-line degeneration),
    exact closed forms.

    At δ = 0 the off-line 4-tuple collapses onto the on-line pair and
    the B5 closed form simplifies to explicit numbers:
      pref(γ, 0, t) = (γ² − t²) / (¼ + γ²)      (signed; the only
                   branch of b5PrefSign: < 0 ⟺ t > γ)
      ω_0(γ)       = 1 / (¼ + γ²) > 0
    hence (B5 `b5Abs`):
      ‖R(γ, 0, t)‖ = |γ² − t²| / (¼ + γ²) · e^{1 / (2(¼ + γ²))}.
    These are the far-regime seeds: at t = c·γ the leading factor is
    |c² − 1|·(¼/γ² + 1)⁻¹ — the measured (t/γ)²−1 family's base.
    The near-pair limit (t → γ, δ → 0 jointly; the branch locus) is the
    remaining A3.2b piece, PINNED by the day-017/019 near-regime audit
    (0.9975 – 1.0201 across the measured grid).
-/

/-- Atom A3.2b.1i (LEAN-PROVEN): the δ = 0 closed forms of the B5
    prefactor and the real phase constant (t ≠ γ): pref collapses to
    (γ² − t²)/(¼ + γ²) and ω_0 to 1/(¼ + γ²). -/
theorem p8_pref_omega_zero (γ t : ℝ) (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) :
    pref γ 0 t = (γ ^ 2 - t ^ 2) / (1 / 4 + γ ^ 2) ∧
    omegaD γ 0 = 1 / (1 / 4 + γ ^ 2) := by
  have hDnz : (γ ^ 2 - t ^ 2) ≠ 0 := by
    rintro h
    have h2 : (γ - t) * (γ + t) = 0 := by ring_nf at h ⊢ <;> simpa using h
    obtain (hA | hB) := mul_eq_zero.mp h2
    · exact hne (by nlinarith [hA])
    · exfalso
      nlinarith [hB]
  have hNnz : (1 / 4 + γ ^ 2) ≠ 0 := by nlinarith
  constructor
  · dsimp only [pref]
    field_simp [hDnz, hNnz]
    ring
  · dsimp only [omegaD]
    field_simp [hNnz]
    ring

/-- Atom A3.2b.1ii (LEAN-PROVEN): the detector magnitude at δ = 0 is
    explicit (B5 `b5Abs` + `p8_pref_omega_zero`):
    ‖R(γ,0,t)‖ = |γ²−t²|/(¼+γ²) · e^{1/(2(¼+γ²))} for t ≠ γ. -/
theorem p8_detector_norm_at_zero (γ t : ℝ) (hγ : 0 < γ) (ht : 0 < t) (hne : t ≠ γ) :
    ‖Rratio γ 0 t‖ = |γ ^ 2 - t ^ 2| / (1 / 4 + γ ^ 2) *
      Real.exp (1 / (2 * (1 / 4 + γ ^ 2))) := by
  have hw0 : omegaD γ 0 = 1 / (1 / 4 + γ ^ 2) := (p8_pref_omega_zero γ t hγ ht hne).2
  have hp0 : pref γ 0 t = (γ ^ 2 - t ^ 2) / (1 / 4 + γ ^ 2) :=
    (p8_pref_omega_zero γ t hγ ht hne).1
  have hpos : 0 < 1 / 4 + γ ^ 2 := by nlinarith
  calc ‖Rratio γ 0 t‖
      = |pref γ 0 t| * Real.exp (omegaD γ 0 / 2) :=
        b5Abs hγ ht hne 0
    _ = (|γ ^ 2 - t ^ 2| / (1 / 4 + γ ^ 2)) * Real.exp (omegaD γ 0 / 2) := by
          rw [hp0]
          rw [abs_div (γ ^ 2 - t ^ 2) (1 / 4 + γ ^ 2), abs_of_pos hpos]
    _ = (|γ ^ 2 - t ^ 2| / (1 / 4 + γ ^ 2)) *
        Real.exp (1 / (2 * (1 / 4 + γ ^ 2))) := by
          rw [hw0]
          field_simp
