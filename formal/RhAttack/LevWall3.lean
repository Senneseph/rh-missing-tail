import Mathlib
import RhAttack.ThetaInf
import RhAttack.LevWall
import RhAttack.LevWall2
import RhAttack.RHEnd

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Topology
open ThetaInf LevWall LevWall2 RHEnd ZeroSet

/-!
**LevWall3 — the wall UNIFIED (0295, option B, unit 7).**

0294 sharpened the M2 gap to the SHARP residual asymptotic
`levSharp θ` (published via Radziwiłł Prop B in the range
`θ ≤ 1/2`), while 0293 named the moment wall `levWallAt θ`
(the (1.2) asymptotic, published to `4/7`).  0295 unifies the
two:  the machine theorem `residSharp` (0294) proves that the
sharp residual at `θ` is a LOGICAL COROLLARY of the (1.2)
moment at `θ` plus the mollifier main term —  so the published
reach of `[BARRIER-ASYMP]` is the published reach of the
moment + main-term route = **`4/7` (the Conrey frontier)**, NOT
`1/2`.  The wall therefore has ONE gap set:  `{ θ | 4/7 < θ }`,
and the Radziwiłł `1/2` is a stated conservative range of his
Proposition B, not the frontier.

0295 literature audit (searched 2026-11-11):  the 2025-2026
mollifier / zero-free-region literature does NOT move the
off-diagonal barrier  —  Lin 2025 (arXiv:2508.11108, "Short
mollifiers of the Riemann zeta-function") optimizes the
DERIVATIVE-COMBINATION side (calculus of variations on
linear combinations of ζ-derivatives in Levinson's method;
doubles proportions for modular L-functions with the SAME
arithmetic inputs — "optimizing the linear combinations ...
has a more pronounced effect than refining the mollifier when
it is short");  the 2025-2026 zero-free-region papers move
CONSTANTS (Vinogradov–Korobov `c_VK`; Bellotti–Trudgian
arXiv:2603.21490, Heath-Brown-inspired), not the exponent
θ;  no result published to 2026-11 carries the sharp
residual / (1.2) moment past `4/7`.  The Farmer 1993 /
Bettin–Gonek 2017 citation chain for the θ = ∞ lane was
independently re-confirmed (MathOverflow 515314 answer,
converting the original comment: Farmer, *Long mollifiers of
the Riemann zeta-function*, Mathematika 40 (1993) — origin of
the θ = ∞ conjecture and the first ratios-conjecture
statement; Bettin–Gonek, *The θ = ∞ conjecture implies the
Riemann hypothesis*, Mathematika 63 (2017) 29-33 — re-
confirmed as the cited implication).

PROVEN (machine) in this module:  the reach-unification
arithmetic —  the Conrey frontier `4/7` lies strictly beyond
the Radziwiłł Prop-B range `1/2`;  the two wall gap sets
nest;  the unified gap set is EXACTLY the 0293 gap set
(set equality, machine).  NO RH CLAIM:  `levWallAt θ` at `θ`
in the unified gap remains the single named open
requirement of the M2 lane.
-/

namespace LevWall3

/-! ### 1.  The unified gap set (naming + equality, machine) -/

/-- THE UNIFIED GAP SET:  the θ's for which NO published (1.2)
    moment asymptotic (and hence, by the 0294 corollary
    `residSharp`, no sharp residual either at the published
    reach) is known.  This is EXACTLY the 0293 `levWallGap`
    (one and the same object;  the equality is machine). -/
def unifiedGap : Set ℝ := LevWall.levWallGap

/-- (PROVEN, machine)  the unified gap set is literally the
    0293 Levinson-wall gap set:  `{ θ | 4/7 < θ }`. -/
theorem unifiedGap_eq_levWallGap : unifiedGap = LevWall.levWallGap := rfl

/-- (PROVEN, machine)  the Conrey `4/7` frontier lies strictly
    BEYOND the Radziwiłł Prop-B range `1/2`:  the sharp-residual
    corollary route (0294 `residSharp` + the cited (1.2) at 4/7
    + the cited main term) reaches past the range Radziwiłł
    states for Proposition B. -/
theorem conreyBeyondPropB : (1 / 2 : ℝ) < (4 / 7 : ℝ) := by
  norm_num

/-! ### 2.  The two gap sets nest (machine) -/

/-- The SHARP gap (Radziwiłł Prop-B reading:  `θ > 1/2`)
    contains the unified gap (`θ > 4/7`):  the unified wall is
    the smaller obligation —  it is sufficient for the face
    M2-lane to carry the moment to all `θ > 4/7`,  which
    automatically carries the sharp residual there too (by
    `LevWall2.residSharp`, with the cited inputs). -/
theorem unifiedGapInsideSharpGap : unifiedGap ⊆ {θ : ℝ | 1 / 2 < θ} := by
  rintro θ (hθ : (4 / 7 : ℝ) < θ)
  have hstep : (1 / 2 : ℝ) < (4 / 7 : ℝ) := by norm_num
  exact lt_trans hstep hθ

/-- (PROVEN, machine)  the B-C-H-B degree-2 length `9/17 =
    1/2 + 1/34` also sits strictly beyond `1/2`  (the 0292
    face-menu record)  and below the Conrey frontier `4/7`. -/
theorem bchbDegree2InBetween : (1 / 2 : ℝ) < (9 / 17 : ℝ) ∧ (9 / 17 : ℝ) < (4 / 7 : ℝ) := by
  constructor
  · norm_num
  · norm_num

/-! ### 3.  The single named wall for the M2 lane (record-level,
           with the machine equality as witness) -/

/-- [UNIFIED-WALL]  (named open input family - 0295):
    for every  `θ`  in  `unifiedGap`  (= `{ θ | 4/7 < θ }`),
    the (1.2) moment asymptotic  `LevWall.levWallAt θ`  is
    UNKNOWN  (and by the 0294 `residSharp` corollary so is
    the sharp residual  `LevWall2.levSharp θ`  at the
    published reach).  Closing the M2 lane for the terminal
    face  (0288/0291 `terminalFace` / `terminalFaceCE1`)
    requires  `LevWall.levWallAt θ`  for every `θ > 0`  —
    i.e.  exactly the members of  `unifiedGap`  are open;
    the published interval `(0, 4/7)`  is cited.  This is
    THE single named analytic requirement that remains in
    the M2 lane  after  0292-0295. -/
def unifiedWall : Prop := ∀ θ ∈ unifiedGap, LevWall.levWallAt θ
    -- named cited-input family;  NOT proven in-tree (red line)

end LevWall3
