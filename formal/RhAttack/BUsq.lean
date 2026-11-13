import Mathlib
import RhAttack.Ap2Defs
import RhAttack.Ap2Statement
import RhAttack.Ap2Reflect

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open scoped Topology
open scoped ComplexConjugate
open Ap2
open Ap2.Zeta23
open Set

/-!
**BUsq — Borsuk–Ulam / antipodal-symmetry route audit (0393, unit 107).**

Motivation (owner's question): the Borsuk–Ulam theorem (1933) — every
continuous map Sⁿ → ℝⁿ identifies antipodal pairs; the classical Earth
corollary: at any instant two antipodal points share temperature and
pressure — is a theorem of MIRROR SYMMETRY. The zeta functional equation
is also a mirror: `s ↦ 1 − s` reflects the strip across the critical line
(Ap2: `reflect ρ = 1 − ρ̄`, `zeta_reflect_zero`). Owner's instruction:
do NOT dismiss the route by citing the absence of literature — reason out
why it would or would not work, and kill what is killable with explicit
counterexamples. This module is that audit.

THE FOUR ROUTES, and their verdicts (all reasoned, not cited):

**(A) Brouwer fixed-point forcing.** Build a map of a zero-free-boundary
region `F(x) = P(x − ε·v(x))` (projection + translation by the field
v = "the zeta direction") so that a fixed point would be a zero.
DEAD — explicit formal counterexample (Section 2): on the unit square,
the constant zero-free field `v ≡ (1, 0)` (the "zeta is zero-free here"
scenario, e.g. in the half-plane Re s > 1) makes `F` have a spurious fixed
point at EVERY point of the upwind edge (x = (−1, y): F(−1, y) =
clamp(−3, y) = (−1, y)). Brouwer guarantees a fixed point; it never
guarantees a zero. Boundary-artifact fixed points are not an edge case —
for any zero-free v the whole upwind boundary is fixed.

**(B) Borsuk–Ulam zero forcing.** B-U on Sⁿ forces a zero of an ODD map
Sⁿ → ℝⁿ (via u(x) + u(−x)); in 1-D, that *is* the intermediate value
theorem. Any B-U construction out of zeta data therefore reduces, in the
only holomorphic case that survives scrutiny, to SIGN/ARGUMENT CHANGE
COUNTING — already in-tree as the argument principle
(`Ap1ArgumentPrinciple`) and the certified Rosser sign-change pipeline.
The argument principle COUNTS zeros (winding number); it never FORBIDS
them — so a B-U-flavored counting argument cannot produce zero-freeness in
the interior of the strip. DEAD by reduction.

**(C) Poincaré–Hopf / index.** The index-theoretic restatement: zeros of a
holomorphic function in a region are boundary winding number + Euler
characteristic bookkeeping — the argument principle again (Route B). The
mirror σ contributes exactly one fact: in a σ-symmetric region the zero
count right of the line equals the count left — PAIRING bookkeeping
(already in-tree: Ap2's order transport `analyticOrderAt_zeta_one_sub`),
not a contradiction. DEAD by reduction.

**(D) The symmetry is compatible with falsity — the structural kill.**
B-U-type theorems eliminate worlds by SYMMETRY VIOLATION: they show no
asymmetric configuration can exist. But the functional equation makes the
zero set of ζ mirror-symmetric in EVERY world — true or false — as a
theorem about ζ (`zeta_reflect_zero`, in-tree), not a consequence of RH.
The class of RH-FALSE zero configurations is a union of full mirror orbits
(Section 1 formalizes the core: an off-critical zero reflects to an
off-critical zero — off-criticality itself is mirror-invariant). There is
no asymmetric world for B-U to kill; every false-world configuration
already respects the symmetry the theorem would enforce. DEAD structurally.

META-LESSON: the 1-D antipodal method (IVT) is the engine we already run
(designated sign changes per certified window); the complex-analytic
structure upgrades counting to exact winding (Ap1/Ap2). Higher-dimensional
B-U buys nothing new, because everything it can say in this setting is a
rephrasing of winding numbers, or of a symmetry that holds in all worlds.

NO RH CLAIM: this unit KILLS A ROUTE (antipodal / Borsuk–Ulam /
fixed-point / index methods against the terminal face). It does not move
`terminalFaceCE82`; the face remains exactly as before, and no symmetry
argument of this family has been consumed against it.
-/

/- Section 1: formal core of Route D — the false sector is mirror-invariant -/

/-- An off-critical zero: a nontrivial zero NOT on the critical line
    (Re ρ ≠ 1/2). -/
def IsOffCritZero (ρ : ℂ) : Prop := IsNontrivialZero ρ ∧ ρ.re ≠ (1 : ℝ) / 2

/-- (Route D core) The mirror `ρ ↦ 1 − ρ̄` sends off-critical zeros to
    off-critical zeros: the RH-false sector is closed under the full mirror
    in EVERY world — a theorem about ζ (via `zeta_reflect_zero`), not a
    consequence of RH. Hence no symmetry-forcing argument (Borsuk–Ulam and
    kin) can eliminate off-critical zeros: there is no asymmetric
    configuration to eliminate; every false-world configuration already
    respects the symmetry. -/
theorem offCritZero_reflect : ∀ ρ, IsOffCritZero ρ → IsOffCritZero (reflect ρ) := by
  rintro ρ ⟨hzt, hoff⟩
  constructor
  · exact zeta_reflect_zero ρ hzt
  · have hre : (reflect ρ).re = 1 - ρ.re := by
      rw [reflect, Complex.sub_re, Complex.one_re, Complex.conj_re]
    rw [hre]
    intro h
    exact hoff (by linarith)

/- Section 2: explicit counterexample for Route A (Brouwer forcing) -/

/-- Closest-point retraction onto the closed unit square (componentwise clamp). -/
def clampUnit (x : ℝ × ℝ) : ℝ × ℝ :=
  (min 1 (max (-1) x.1), min 1 (max (-1) x.2))

/-- The clamp is continuous (min/max of continuous functions). -/
theorem clampUnit_continuous : Continuous clampUnit := by
  unfold clampUnit
  apply Continuous.prodMk
  · apply Continuous.min
    · exact continuous_const
    · apply Continuous.max
      · exact continuous_const
      · exact continuous_fst
  · apply Continuous.min
    · exact continuous_const
    · apply Continuous.max
      · exact continuous_const
      · exact continuous_snd

/-- The clamp fixes the unit square pointwise (it is a retraction). -/
theorem clampUnit_onUnitSquare :
    ∀ x ∈ Icc (-1 : ℝ) 1 ×ˢ Icc (-1 : ℝ) 1, clampUnit x = x := by
  intro x hx
  rcases hx with ⟨hx1, hx2⟩
  ext
  · have hmax : max (-1 : ℝ) x.1 = x.1 := by
      rw [max_eq_right_iff]
      exact hx1.1
    have hmin : min 1 x.1 = x.1 := by
      rw [min_eq_right_iff]
      exact hx1.2
    dsimp only [clampUnit]
    rw [hmax, hmin]
  · have hmax : max (-1 : ℝ) x.2 = x.2 := by
      rw [max_eq_right_iff]
      exact hx2.1
    have hmin : min 1 x.2 = x.2 := by
      rw [min_eq_right_iff]
      exact hx2.2
    dsimp only [clampUnit]
    rw [hmax, hmin]

/-- The "zeta direction" field in a zero-free scenario: constant and
    nonzero everywhere — as ζ behaves in any zero-free region
    (e.g. the half-plane Re s > 1). -/
def buField (x : ℝ × ℝ) : ℝ × ℝ := ((1 : ℝ), 0)

/-- The translation scale for the projection trick. -/
def buEps : ℝ := 2

/-- The Brouwer-forcing candidate map: F(x) = P(x − ε·v(x)). -/
def buTrick (x : ℝ × ℝ) : ℝ × ℝ :=
  clampUnit (x - buEps • buField x)

/-- (Route A counterexample) The translation-projection map has a spurious
    fixed point that is NOT a zero of the field: with the constant zero-free
    field v ≡ (1, 0) on the unit square, EVERY point of the upwind edge
    (x = (−1, y)) is a fixed point — F(−1, 0) = clamp(−3, 0) = (−1, 0) —
    while v vanishes nowhere. Brouwer-style fixed-point forcing therefore
    cannot certify zeros of zero-free-analog fields, a fortiori cannot force
    zeros of ζ in the interior of the strip. -/
theorem brouwerFixedNotZero :
    Continuous buField ∧ Continuous buTrick
      ∧ (∀ x ∈ Icc (-1 : ℝ) 1 ×ˢ Icc (-1 : ℝ) 1, clampUnit x = x)
      ∧ (∀ x, buField x ≠ ((0 : ℝ), 0))
      ∧ (∃ x ∈ Icc (-1 : ℝ) 1 ×ˢ Icc (-1 : ℝ) 1, buTrick x = x) := by
  refine ⟨?_, ?_, clampUnit_onUnitSquare, ?_, ?_⟩
  · unfold buField
    exact continuous_const
  · unfold buTrick
    apply Continuous.comp clampUnit_continuous
    apply Continuous.sub
    · exact continuous_id
    · have hconst : (fun x : ℝ × ℝ => buEps • buField x) = (fun _ => buEps • buField 0) := by
        funext x
        simp [buField]
      rw [hconst]
      exact continuous_const
  · intro x
    simp [buField]
  · use ((-1 : ℝ), 0)
    constructor
    · simp [Icc]
    · simp [buTrick, buField, buEps, clampUnit]
