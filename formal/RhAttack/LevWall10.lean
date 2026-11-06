import Mathlib
import RhAttack.ThetaInf
import RhAttack.LevWall
import RhAttack.LevWall9

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter

/-!
**LevWall10 — the door-2 wire, its reach numerics, and the
CORRECTED vacuity audit (0312, option B, unit 23 — the
housekeeping wire named in 0310/0311, landed with corrected
numerals).**

WHAT THIS MODULE LANDS:
  1. THE DOOR-2 WIRE (machine, parameterized): under [θ-BND]
     (ThetaInf.thetaBounded θ, the RANGE antecedent of BG
     Theorem 1 at θ) and [BG-T1] (ThetaInf.bgThetaShrink θ,
     the cited Theorem-1 implication with the functional-
     equation left-flank reflection), zeta is ZERO-FREE in
     the half-plane Re s > 1/2 + 1/(2θ) (right flank,
     Theorem 1 verbatim) and in Re s < 1/2 − 1/(2θ) (left
     flank, via the reflection recorded in bgThetaShrink).
  2. THE REACH NUMERICS (machine): the published reach of the
     antecedent is θ < 4/7 (LevWall9.bgConreyReach; 0310
     primary re-read). Theorem 1's region boundary
     1/2 + 1/(2θ) DECREASES in θ, so the BEST (narrowest)
     reachable region is the θ → 4/7⁻ limit: 1/(2θ) → 7/8,
     i.e. zero-free in Re s > 1/2 + 7/8 = 19/16
     (reachBoundary, below).
  3. THE CORRECTION (honesty, supersedes the 0310/0311
     nextMoves sketch): the sketch said "[DIAG-RANGE]@1/2 +
     [BG-T1] => zero-free Re s > 3/5 in-tree (Levinson
     region)". ARITHMETIC ERROR in the sketch: Theorem 1 at
     θ = 1/2 gives the boundary 1/2 + 1/(2·(1/2)) = 1/2 + 1
     = 3/2, NOT 3/5. The boundary 3/5 = 1/2 + 1/10
     corresponds to θ = 5 — FIVE TIMES PAST the published
     reach 4/7, i.e. deep in the unified wall (θ = 5 ∈ {θ
     | 4/7 < θ}). The genuine classical Levinson 1949 zero-
     free region (Re s > 1/2 + 0.08662...) is a DIFFERENT
     theorem (Levinson's own direct argument, not BG
     Theorem 1) and is NOT recorded in-tree as a named
     input. Corrected statement: at the published reach the
     door-2 wire yields zero-free statements STRICTLY
     INSIDE Re s >= 1 (elementarily known zero-free,
     Hadamard-de la Vallée Poussin / Pólya — cited, not
     re-proven in-tree; the program is face-first and has
     no in-tree named input for the trivial region).
  4. THE VACUITY AUDIT (machine + record):
     reachableInsideTrivialRegion : 19/16 > 1 — every
     zero-free statement the wire can deliver at the
     published reach (θ < 4/7, i.e. boundaries
     1/2 + 1/(2θ) >= 19/16) lies strictly inside the
     elementarily zero-free half-plane Re s >= 1.
     Non-vacuity against the classical zero-free boundary
     1 - c/((log t)^{2/3}(log log t)^{1/3}) (Korn-Landau
     scale, c = 1/(2pi); = 0.98599645... at t = 3e9)
     requires 1/2 + 1/(2θ) < 0.98599645, i.e. θ > 1.0288 —
     STRICTLY INSIDE the unified wall open set {θ | 4/7 <
     θ} (machine: nonvacuousPastWall, below; the machine
     fact is the pure θ > 1 => 4/7 < θ). CONSEQUENCE
     (sharpens 0310 once more): the ENTIRE non-vacuous
     territory of BG Theorem 1 (θ > 1) lies inside the wall;
     the wire has NO partial value at the published reach.
     Pure formalization completeness — red line, as named in
     0310/0311.

  NO RH CLAIM.
-/

namespace LevWall10

/-! ### 1.  The  door-2  wire  (machine)
-/
/-- THE WIRE (right flank): [θ-BND] + [BG-T1] at fixed θ > 0
    => zero-free in the half-plane Re s > 1/2 + 1/(2θ).
    Pure application of the two cited inputs (Z78 pattern —
    no in-tree proof of the inputs). -/
theorem door2Wire (θ : ℝ) (hθ : 0 < θ)
    (hA : ThetaInf.thetaBounded θ) (hT1 : ThetaInf.bgThetaShrink θ)
    (s : ℂ) (hs : (1 / 2 + 1 / (2 * θ) : ℝ) < s.re) :
    riemannZeta s ≠ 0 := by
  exact hT1 hA s (Or.inl hs)

/-- THE WIRE (left flank): the mirror statement
    Re s < 1/2 − 1/(2θ) (the functional-equation reflection
    recorded in ThetaInf.bgThetaShrink). -/
theorem door2WireLeft (θ : ℝ) (hθ : 0 < θ)
    (hA : ThetaInf.thetaBounded θ) (hT1 : ThetaInf.bgThetaShrink θ)
    (s : ℂ) (hs : s.re < (1 / 2 - 1 / (2 * θ) : ℝ)) :
    riemannZeta s ≠ 0 := by
  exact hT1 hA s (Or.inr hs)

/-- The θ = 1/2 corollary (CORRECTED numerals, see module
    header item 3): Theorem 1 at θ = 1/2 gives the boundary
    1/2 + 1/(2 · (1/2)) = 3/2 — NOT 3/5 (the 0310/0311
    sketch is corrected; 3/5 corresponds to θ = 5,
    unpublished). -/
theorem door2WireAt12
    (hA : ThetaInf.thetaBounded (1 / 2))
    (hT1 : ThetaInf.bgThetaShrink (1 / 2))
    (s : ℂ) (hs : (3 / 2 : ℝ) < s.re) :
    riemannZeta s ≠ 0 := by
  have hhs : (1 / 2 + 1 / (2 * (1 / 2)) : ℝ) < s.re := by
    norm_num at hs ⊢
    exact hs
  exact door2Wire (1 / 2) (by norm_num) hA hT1 s hhs

/-! ### 2.  The reach numerics and the vacuity audit (machine)
-/
/-- The BEST reachable exponent: the θ → 4/7⁻ limit of
    1/(2θ) = 7/8 (the published-reach boundary of the
    wire's zero-free family). -/
def reachExponent : ℚ := 7 / 8

/-- The BEST reachable region boundary: 1/2 + 7/8 = 19/16. -/
def reachBoundary : ℚ := 19 / 16

/-- (PROVEN, norm_num) the boundary ladder: 1 < 19/16 (the best
    reachable boundary) < 3/2 (the θ = 1/2 wire boundary) -
    the family Re s > b shrinks as b grows, so 19/16 is the
    best (narrowest) reachable region. -/
theorem boundaryLadder : (1 : ℚ) < reachBoundary ∧ reachBoundary < 3 / 2 := by
  exact ⟨by norm_num [reachBoundary], by norm_num [reachBoundary]⟩

/-- (PROVEN, norm_num) THE VACUITY STATEMENT: every zero-free
    statement the door-2 wire can deliver at the published
    reach (θ < 4/7, i.e. boundaries 1/2 + 1/(2θ) >= 19/16)
    lies STRICTLY INSIDE the elementarily zero-free
    half-plane Re s >= 1 (cited classical fact — Hadamard-de
    la Vallée Poussin / Pólya — not re-proven in-tree). -/
theorem reachableInsideTrivialRegion : (1 : ℝ) < (reachBoundary : ℝ) := by
  norm_num [reachBoundary]

/-- (PROVEN, linarith) NON-VACUITY PAST THE WALL: the wire
    stops being vacuous (beats the classical zero-free
    boundary 1 - c/((log t)^{2/3}(log log t)^{1/3}), c =
    1/(2*pi), = 0.98599645... at t = 3e9) only once
    1/2 + 1/(2θ) < 0.98599645, i.e. θ > 1.0288; and the
    machine fact needed is the pure one: θ > 1 => 4/7 < θ,
    so the ENTIRE non-vacuous territory of Theorem 1 (θ > 1)
    sits strictly inside the unified wall open set
    {θ | 4/7 < θ}. -/
theorem nonvacuousPastWall (θ : ℝ) (hθ : (1 : ℝ) < θ) :
    θ ∈ LevWall.levWallGap := by
  simp only [LevWall.levWallGap, Set.mem_ofPred_eq]
  have hgap : (4 / 7 : ℝ) < 1 := by norm_num
  linarith

/-- (PROVEN, pure logic from the cited classical fact) the
    wire's DELIVERABLE at any published θ < 4/7 is zero-free
    in Re s > b with b >= 19/16 — which is a DIRECT
    CONSEQUENCE of the cited trivial region (no zeros in
    Re s >= 1; Z78-pattern hypothesis, not re-proven in-
    tree): Re s > b >= 19/16 > 1 lies inside the trivial
    region. This is the red line in machine form — the wire
    is formalization completeness, NOT an analytic gain past
    4/7. -/
theorem wireDeliversNothingPastClassical (b : ℝ)
    (hb : (reachBoundary : ℝ) ≤ b)
    (hTrivial : ∀ (s : ℂ), 1 ≤ s.re → riemannZeta s ≠ 0)
    (s : ℂ) (hs : b < s.re) :
    riemannZeta s ≠ 0 := by
  have h1b : (1 : ℝ) < reachBoundary := by norm_num [reachBoundary]
  have h1 : 1 ≤ s.re := by linarith [h1b, hb, hs]
  exact hTrivial s h1

end LevWall10
