/-
Copyright (c) 2026 kainos-logos rh-attack (owner-directed research;
set_option maxErrors 500
AI co-developed instrument; no prize claim — see
plan/40-prize-islands/rh-attack/README.md).
-/

import Mathlib
import RhAttack.B3Abel
import RhAttack.B3Core
import RhAttack.B3Sbar
set_option maxErrors 500

set_option linter.style.header false
set_option linter.style.longLine false

open Real Set MeasureTheory intervalIntegral

/- **B-3** — the bridge identity, Lean image (outline [B-3];
    `spec/b2-tail-bound.md`; FORMULAS §2.8).

    PROVENANCE (no recall — every reference resolves):
      plan/40-prize-islands/rh-attack/RH-PROOF-OUTLINE.md v0.8, [B-3]:
        "Bridge identity: for the actual zero set 𝒵_ℂ, ζ(s) = K(s;𝒵_ℂ)
          in the product sense (25.2.12), finite-G residual governed by
          B-2's M(G,s)."
      plan/40-prize-islands/rh-attack/spec/b2-tail-bound.md (2026-09-13):
        the B-2 bound, the Abel decomposition (verified on 7.4M real
        certified zeros to quadrature limit), and the R(t) redefinition.
        This file is the Lean image for the abstract ON-LINE model: a
        counting step N_L over a finite height list L, the smooth RVM
        comparator NHat, and the pair kernel fT.

    HONESTY LABELS (claim policy: certified artifact, no RH claim).
    - Nothing here is a statement about ζ. 25.2.12 is not in Mathlib;
      the ζ-step is the citation the outline assigns to B-3's classical
      part (same no-ζ convention as B-0). b3ResidualDecomp is the ζ-free
      core: the bridge map Ψ = e^{Tt}·∏_L F and the kernel
      K = ∏_{L∪T} F differ by EXACTLY the factor exp(Tt − Σ_T ln F) —
      the residual of the bridge is the tail-model error, nothing else.
    - b3Abel is the finite exact Abel decomposition (Σ-vs-∫ with the
      counting step); b3Bridge adds the smooth RVM comparator
      (N = NHat + S); b3BoundExplicit specializes to fT with the
      Platt–Trudgian S̄ (J. Number Theory 147 (2015) 842–851, Cor 1 —
      read 2026-09-13 from the original PDF; ledger FORMULAS §1.3):
      the FINITE form of B-2's M(G,t) (spec §5 K is ∫_G^∞; here the
      explicit finite bound Cf·Kbar(G); B → ∞ is a documented limit
      step — B-6A consumes the finite form at working B).
    - Flat-def discipline (B-5 lesson): every def feeding ring /
      nlinarith / HasDerivAt is in flat monomial form.
-/
/-
  OUTLINE PIECE MAPPING (docs/RH-PROOF-OUTLINE.md §6, §9 rows P6/P7):
    P6 (the bridge identity — ζ-free finite core): `b3ResidualDecomp`
       — the bridge map Ψ = e^{Tt}·∏_L F and the truncated kernel
       K = ∏_{L∪T} F differ by EXACTLY exp(Tt − Σ_T ln F); the bridge
       residual IS the tail-model error, nothing else. `b3Abel` — the
       finite exact Abel decomposition (counting step N_L, §4).
    P7 (the finite Abel / IBP machinery): `b3Bridge` (smooth RVM
       comparator N = NHat + S); §2 the NHat/fT derivatives; §5 the
       S-bound kernel integrands P011/Q029/R229 (the Platt–Trudgian
       coefficients 0.110 / 0.290 / 2.290); the continuity lemmas +
       the IBP bridge `nHatIBP` (§6).
  ROLE    : makes "definition side" and "zero side" the SAME object
             modulo the rigorous tail of the outline's §5 — without
             it, the two sides of the contradiction never touch. The
             smooth comparator carries the boundedness the residual
             floor (P8) will consume.
  STATUS (2026-09-11) : WIP — atomic one-thing-at-a-time repair in
             progress (48 → 30 errors last run; the next target is
             logged in the day-015 journal). NOT yet green;
             intentionally NOT imported by RhAttack.lean until it is.
             No claim is made on its content.
-/
namespace B3

noncomputable section

-- §1 model functions + variable (x : ℝ) + lift + NHat_deriv: moved to
-- RhAttack/B3Core.lean (day-016 move; names unchanged).

variable (x : ℝ)


-- §2 (fT_deriv) + §3 (negLog1mY_le, fT_bound, fTp_bound): moved to
-- RhAttack/B3Core.lean (day-016 move; names unchanged).

-- §5 (S̄ primitives, P011/Q029/R229, Kbar_le, b3BoundExplicit): moved to
-- =====================================================================
-- §6 the residual split (zeta-free core of the B-3 bridge)
-- =====================================================================

/-- Residual split (zeta-free): e^{Tt} · ∏_{g∈L} F = (∏_{g∈L∪T} F) · e^{Tt − Σ_T ln F}
    for positive F on L ++ T. Composed with F-0.5 + B-1 + B-2 this is B-6A's
    Route A engine: an off-line pair at t0 forces the LHS ≥ f(δ, t0) at its
    own height. (4.33.1 core API, probe-verified: List.map_cons /
    List.prod_cons / List.sum_cons / List.prod_append /
    List.mem_append_right / List.Mem.tail; (L.map F).prod and
    (L.map f).sum forms — List.sum/List.prod are element-operators.) -/
theorem b3ResidualDecomp (L T : List ℝ) (Tt : ℝ) (F : ℝ → ℝ)
    (hpos : ∀ g ∈ L ++ T, 0 < F g) :
    Real.exp Tt * (L.map (fun (g : ℝ) => F g)).prod =
      ((L ++ T).map (fun (g : ℝ) => F g)).prod *
      Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
  have hTexp (T2 : List ℝ) (hTpos : ∀ g ∈ T2, 0 < F g) :
      (T2.map (fun (g : ℝ) => F g)).prod =
        Real.exp ((T2.map (fun (g : ℝ) => Real.log (F g))).sum) := by
    induction T2 with
    | nil => simp
    | cons g T2 ih =>
      have ih' : (T2.map (fun (g : ℝ) => F g)).prod =
          Real.exp ((T2.map (fun (g : ℝ) => Real.log (F g))).sum) :=
        ih (fun g2 (hg2 : g2 ∈ T2) => hTpos g2 (List.Mem.tail g hg2))
      have hposg : 0 < F g := hTpos g (List.Mem.head T2)
      simp only [List.map_cons, List.prod_cons, List.sum_cons]
      rw [Real.exp_add (Real.log (F g))
        ((T2.map (fun (g : ℝ) => Real.log (F g))).sum),
        Real.exp_log hposg, ih']
  have hTmain : (T.map (fun (g : ℝ) => F g)).prod =
      Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) :=
    hTexp T (fun g (hg : g ∈ T) => hpos g (List.mem_append_right L hg))
  calc Real.exp Tt * (L.map (fun (g : ℝ) => F g)).prod
      = (L.map (fun (g : ℝ) => F g)).prod * Real.exp Tt := by ring
    _ = (L.map (fun (g : ℝ) => F g)).prod *
        (Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) *
          Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
        calc (L.map (fun (g : ℝ) => F g)).prod * Real.exp Tt
            = (L.map (fun (g : ℝ) => F g)).prod * Real.exp
                ((T.map (fun (g : ℝ) => Real.log (F g))).sum +
                  (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
                rw [show (T.map (fun (g : ℝ) => Real.log (F g))).sum +
                      (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) = Tt by ring]
              _ = (L.map (fun (g : ℝ) => F g)).prod *
                  (Real.exp ((T.map (fun (g : ℝ) => Real.log (F g))).sum) *
                    Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)) := by
                rw [Real.exp_add ((T.map (fun (g : ℝ) => Real.log (F g))).sum)
                  (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum)]
    _ = (L.map (fun (g : ℝ) => F g)).prod * (T.map (fun (g : ℝ) => F g)).prod *
        Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
        rw [← hTmain]
        ring
    _ = ((L ++ T).map (fun (g : ℝ) => F g)).prod *
        Real.exp (Tt - (T.map (fun (g : ℝ) => Real.log (F g))).sum) := by
        rw [← List.prod_append, ← List.map_append]
        -- 4.33.1: the List.prod_append / map_append rw auto-closes; no `ring`
end
end B3
-- =====================================================================
-- §7 float64 cross-check (pure Float; no Mathlib ℝ — the A/B gate)
-- =====================================================================
-- Mirrors the B-3 model in Float64 and runs two checks at
-- t = 2.5, G = 6, B = 40 with the toy off-line list
-- L = [7.3, 12.1, 19.4, 27.8, 33.0]:
--   (1) the EXACT finite Abel identity (b3Abel) at quadrature limit
--       (8-node Gauss–Legendre, segments split at each zero height);
--   (2) the explicit bound (b3BoundExplicit / Kbar_le):
--       |Σ_L fT − ∫ nHat·fT| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G).
-- A/B gate: this must agree with the Lean theorems' content (same
-- formulas, same regime), byte-for-byte in logic, to machine precision
-- in numerics. P-0.9: a PASS line with a flagged anomaly is not a PASS.
namespace B3Float

def piF : Float := 3.141592653589793

def myAbs (x : Float) : Float := if x < 0 then -x else x
def myMax (a b : Float) : Float := if a < b then b else a

def F (t x : Float) : Float :=
    (1 : Float) / (2 * (x * x + (1 : Float) / 4)) +
      Float.log (1 - (t * t + (1 : Float) / 4) / (x * x + (1 : Float) / 4))

def Fp (t x : Float) : Float :=
    -x / (x * x + (1 : Float) / 4) ^ 2 +
      2 * x * (t * t + (1 : Float) / 4) /
        ((x * x + (1 : Float) / 4) * (x * x - t * t))

def nF (x : Float) : Float :=
    Float.log (x / (2 * piF)) / (2 * piF)

def NHatF (x : Float) : Float :=
    x / (2 * piF) * (Float.log (x / (2 * piF)) - 1) + (7 : Float) / 8

def sBarF (x : Float) : Float :=
    (0.110 : Float) * Float.log x + (0.290 : Float) * Float.log (Float.log x) +
      (2.290 : Float)

def BfF (t G : Float) : Float :=
    (1 : Float) / (2 * (G * G + (1 : Float) / 4)) +
      (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4) /
        (1 - (t * t + (1 : Float) / 4) / (G * G + (1 : Float) / 4)) +
      t / (G * G + (1 : Float) / 4)

def CfF (t G : Float) : Float :=
    1 + 2 * (t * t + (1 : Float) / 4) * (G * G) / (G * G - t * t)

def KbarF (G : Float) : Float :=
    ((0.110 : Float) * (Float.log G + (1 : Float) / 2) +
        (0.290 : Float) * (Float.log (Float.log G) + (1 : Float) / 2) + (2.290 : Float)) /
      (2 * G * G)

/-- N_L(x) = #{g ∈ L : g ≤ x} (foldl counter — List-fold discipline). -/
def nListF (L : List Float) (x : Float) : Float :=
    L.foldl (fun (a : Float) g => a + (if g <= x then (1 : Float) else 0)) 0

-- 8-node Gauss–Legendre on [-1, 1] (standard table; exact for degree ≤ 15)
-- Table COMPUTED 2026-09-14 with mpmath-50dps (roots of P8,
-- w_i = 2/((1-x_i^2) P8'(x_i)^2)), verified against the moment
-- identites to 50 digits; the runtime glMomErr self-check (< 1e-12)
-- re-verifies it in Float64.  "constants computed, never recalled".
def gln : Array Float := #[
    -0.9602898564975363, -0.7966664774136267, -0.525532409916329, -0.1834346424956498,
     0.1834346424956498,  0.525532409916329,  0.7966664774136267,  0.9602898564975363]

def glw : Array Float := #[
     0.10122853629037626, 0.22238103445337448, 0.31370664587788727, 0.362683783378362,
     0.362683783378362,   0.31370664587788727, 0.22238103445337448, 0.10122853629037626]

/-- One 8-node Gauss–Legendre segment [a, b], composed over 8 sub-segments
    (composite order 16 for smooth integrands; no nodes beyond the table). -/
def glInt (a b : Float) (f : Float → Float) : Float :=
    let h := (b - a) / 8
    let seg (a0 : Float) : Float :=
      let m2 := h / 2
      let c  := a0 + h / 2
      (gln.zip glw).foldl (fun (s : Float) (x : Float × Float) =>
        s + m2 * x.2 * f (m2 * x.1 + c)) 0
    [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0] |>.foldl (fun (acc : Float) k =>
      acc + seg (a + h * (k - 1))) 0

/-- Moment self-check of the table: |Σw − 2| + |Σwξ² − 2/3| + |Σwξ⁶ − 2/7|
    (odd moments vanish by symmetry; must be < 1e-12 in Float64). -/
def glMomErr : Float :=
    let (m0, m2, m6) := gln.zip glw |>.foldl (fun (acc : Float × Float × Float) (x : Float × Float) =>
      let (a, b, c) := acc
      let x2 := x.1 * x.1
      (a + x.2, b + x.2 * x2, c + x.2 * x2 * x2 * x2)) (0, 0, 0)
    myAbs (m0 - 2) + myAbs (m2 - (2 : Float) / 3) + myAbs (m6 - (2 : Float) / 7)

/-- Segment the interval at every zero height strictly inside [a, b]. -/
def splitIntR (a b : Float) (rest : List Float) (f : Float → Float) : Float :=
    match rest with
    | [] => glInt a b f
    | g :: gs =>
      if g <= a ∨ g >= b then
        splitIntR a b gs f
      else
        glInt a g f + splitIntR g b gs f

def splitInt (a b : Float) (L : List Float) (f : Float → Float) : Float :=
    splitIntR a b (L.filter (fun g => g > a && g < b)) f

/-! The A/B run (B4Float style): prints both checks, returns
    (abelRelativeError, boundMargin) — margin strictly positive iff (2) holds. -/
def run : IO (Float × Float) := do
    let tF : Float := 2.5
    let G  : Float := 6
    let B  : Float := 40
    let L  : List Float := [7.3, 12.1, 19.4, 27.8, 33.0]
    let f  : Float → Float := F tF
    -- (1) exact finite Abel identity:
    --     ∫_G^B N_L f' = f(B)·N_L(B) − f(G)·N_L(G) − Σ_{g: G<g≤B} f(g)
    let LsumF := L.foldl (fun (a : Float) g =>
      a + (if G < g && g <= B then f g else 0)) 0
    let Iabel := splitInt G B L (fun x => nListF L x * Fp tF x)
    let NRHS  := f B * nListF L B - f G * nListF L G - LsumF
    let abelRel := myAbs (Iabel - NRHS) / myMax (myAbs Iabel) (myAbs NRHS)
    IO.println "  check 1 — exact finite Abel identity (int N_L f' vs fB·NB − fG·NG − Sum f):"
    IO.println s!"    rel-err·1e12 = {abelRel * 1e12}"
    -- (2) explicit bound: |Sum f − int nF·f| ≤ Bf·(S̄ B + S̄ G) + Cf·K̄(G)
    let Ikernel := splitInt G B L (fun x => nF x * f x)
    let lhs2 := myAbs (LsumF - Ikernel)
    let rhs2 := BfF tF G * (sBarF B + sBarF G) + CfF tF G * KbarF G
    let margin := (rhs2 - lhs2) / rhs2
    IO.println "  check 2 — explicit bound |Sum f − int nF·f| ≤ Bf·(SbarB + SbarG) + Cf·Kbar(G):"
    IO.println s!"    margin·1e3 = {margin * 1e3}     (bound LHS·1e3={lhs2 * 1e3}, RHS·1e3={rhs2 * 1e3})"
    IO.println s!"    gl-mom-err·1e12 = {glMomErr * 1e12}     (table self-check, must be < 1e9)"
    if abelRel < 1e-9 && margin > 0 && glMomErr < 1e-12 then
      IO.println "B-3 CROSS-CHECK PASS"
    else
      IO.println "B-3 CROSS-CHECK FAIL"
    pure (abelRel, margin)

end B3Float
