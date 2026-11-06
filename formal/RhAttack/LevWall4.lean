import Mathlib
import RhAttack.ThetaInf
import RhAttack.RHEnd

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter Topology P12 ThetaInf RHEnd
open ZeroSet

/-!
**LevWall4 — the SECOND face-closing path and the RATIOS audit
(0296, option B, unit 8).**

PRIMARY SOURCES (pulled/verified 2026-11-11):
  *  Farmer, "Long mollifiers of the Riemann zeta-function",
      Mathematika 40 (1993) 71-87  (abstract re-verified:
      "one would expect the formulas involving ζ(s)M(s) to
      remain valid for ALL fixed θ > 0 ... We will refer to
      this as the θ = ∞ conjecture").
  *  Bettin-Gonek, "The θ = ∞ conjecture implies the Riemann
      hypothesis", Mathematika 63 (2017) 29-33 =
      arXiv:1604.02740 (re-pulled verbatim, 0295):
        -  "he [Farmer] proved that this conjecture implies
           that κ = 1, in other words, that 100% of the
           non-trivial zeros of ζ(s) lie on the critical
           line"  (PROVEN INSIDE Farmer 1993);
        -  Theorem 1 (PROVEN INSIDE BG 2017):  fixed θ > 0,
           if  I_N(0,T) ≪_ε T^{1+ε}  for  2 ≤ N ≤ T^θ,  then
           ζ has no zeros in  Re s > 1/2 + 1/(2θ);  "In
           particular, if ...  with θ arbitrarily large, then
           the Riemann hypothesis is true."

THE RATIOS AUDIT (0296, negative result, recorded):
  The ratios conjecture (Farmer 1993, first zeta case, the
  4-ratio mean (7.4)) is the HEURISTIC PARENT of the
  θ = ∞ conjecture  -  Farmer's 1993 argument for (1.2) at
  all θ is ratios-flavored and CONJECTURAL.  It is NOT a
  published theorem (as of 2026-11-11):
    *  BG 2017 makes NO mention of the ratios conjecture;
    *  the PUBLISHED implication direction is the reverse:
       (1.2)@all θ  (the θ = ∞ conjecture)  ==>  100% of the
       zeros on the line  (Farmer, proven in 1993);
    *  the 2023-2026 ratios literature (e.g. arXiv:2307.08091,
       "Mean values of ratios of the Riemann zeta function")
       proves SPECIAL ratio means at specific parameters;
       nothing extends (1.2) past 4/7 and nothing proves a
       "ratios-2 ==> (1.2) at θ > 4/7" implication.
  VERDICT:  the θ = ∞ conjecture (the 0295 integrated wall,
  the (1.2) asymptotic for every θ > 4/7) remains the
  minimal NAMED open input of the M2 lane;  the ratios
  conjecture is a sibling conjecture, not a citable shorter
  path to the face.

THIS MODULE (the new, machine-verified part):
  A SECOND face-closing path via the Theorem-1 ANTECEDENT
  family  [BG-ANT-ALL]  (the  ≪_ε  T^{1+ε}  bounded-moment
  hypothesis at every θ,  the "θ arbitrarily large" input of
  the "In particular" clause)  +  the cited implication
  [BG-T1-ARB]  (proven inside BG 2017):  either named family
  suffices to close the face  -  the program may attack
  EITHER the sharp asymptotic  (1.2)@θ  (M2 / 0293-0295)
  OR the uniform boundedness  I_N(0,T) ≪_ε T^{1+ε}  on
  2 ≤ N ≤ T^θ  (this module)  -  two named doors to the
  same face.  Plus the machine arithmetic that the 0290
  θ-face family  { 0 < d0 ≤ 1/(2θ) : θ > 0 }  covers the
  WHOLE face  (d0 > 0):  the θ-shrink family is collective
  -  no single θ closes the face,  infinitely many do.
  NO RH CLAIM:  both input families are named open inputs.
-/

namespace LevWall4

/-! ### 1.  The second named input family (Z78 pattern) -/

/-- [BG-ANT-ALL]  (named open input family - 0296):  the
    Bettin-Gonek Theorem 1 antecedent at EVERY  θ > 0:
    for every  θ > 0,  I_N(0,T) ≪_ε T^{1+ε}  uniformly over
    2 ≤ N ≤ T^θ.  This is EXACTLY the "θ arbitrarily large"
    hypothesis of the "In particular" clause of BG 2017
    Theorem 1.  Unknown for any single large θ:  the
    unconditional Levinson asymptotic (hence its  ≪_ε
    corollary) is proven only for  0 < θ ≤ 1/2,  and the
    uniform-in-N range shape is a stronger form than the
    pointwise-in-θ asymptotic  (the two are NOT linked
    in-tree;  honesty red line). -/
def thetaBoundedAll : Prop :=
    ∀ (θ : ℝ), 0 < θ → ThetaInf.thetaBounded θ

/-- [BG-T1-ARB]  (named cited input - PROVEN INSIDE
    Bettin-Gonek 2017 Theorem 1, the "In particular"
    clause, verbatim:  "In particular, if I_N(0,T) ≪_ε
    T^{1+ε} for 2 ≤ N ≤ T^θ with θ arbitrarily large, then
    the Riemann hypothesis is true"):  the Theorem-1
    antecedent at every θ  implies  every zeta zero is on
    the line. -/
def bgArbImpliesAllOnLine : Prop :=
    thetaBoundedAll → ∀ (ρ : ℂ), riemannZeta ρ = 0 → ρ.re = 1 / 2

/-! ### 2.  The second face-closing wire (machine) -/

/-- 0296 · M2 LANE, CLOSING PATH 2:  under the cited
    implication  [BG-T1-ARB]  and the named antecedent
    family  [BG-ANT-ALL],  every zero of a zeta-subset zero
    set is on the line,  hence  terminalFace  holds.  This
    is the second door to the face:  the 0290 wire closes
    it from the ASYMPTOTIC input  (the θ = ∞ conjecture =
    the 0293-0295 integrated wall);  this wire closes it
    from the UNIFORM-BOUNDEDNESS input  (Theorem 1's ≪_ε
    T^{1+ε} antecedent at every θ).  Proving  EITHER  named
    input family  (for every  θ > 4/7  respectively -  in
    range the asymptotic already implies the  ≪_ε
    boundedness by a standard estimate,  cited not
    in-tree)  closes the face.  NO RH CLAIM  (both input
    families are open).  -/
theorem terminalFace_of_bgArb (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hArb : bgArbImpliesAllOnLine)
    (hB : thetaBoundedAll) :
    terminalFace q := by
  intro ρ hρ ht
  have hall := hArb hB
  exact hall ρ (hqz ρ hρ)

/-! ### 3.  The θ-face family covers the face (machine) -/

/-- (PROVEN, machine)  every  d0 > 0  lies in some θ-face:
    take  θ = 1/(4·d0)  -  then  1/(2θ) = 2·d0 ≥ d0. -/
theorem thetaFaceExist (d0 : ℝ) (hd0 : 0 < d0) :
    ∃ (θ : ℝ), 0 < θ ∧ d0 ≤ 1 / (2 * θ) := by
  use 1 / (4 * d0)
  constructor
  · positivity
  · field_simp
    linarith [hd0]

/-- (PROVEN, machine)  the 0290 θ-shrink family is
    COLLECTIVE:  the union of the θ-faces  { d0 | 0 < d0
    and d0 ≤ 1/(2θ) }  over all  θ > 0  is  the whole
    off-line range  { d0 | 0 < d0 }:  no single cited θ
    closes the face  (each leaves the outer band),  but the
    family  { θ }  as  θ → ∞  covers every off-line zero.
    This is the arithmetic content of "θ → ∞ collapses the
    face to a point"  in the 0290 header. -/
theorem thetaFacesCover :
    {d0 : ℝ | 0 < d0} = ⋃ θ > 0, {d0 : ℝ | 0 < d0 ∧ d0 ≤ 1 / (2 * θ)} := by
  ext d0
  simp only [Set.mem_setOf_eq, Set.mem_iUnion]
  constructor
  · rintro hd0pos
    obtain ⟨θ, hθ, hd0le⟩ := thetaFaceExist d0 hd0pos
    exact ⟨θ, hθ, ⟨hd0pos, hd0le⟩⟩
  · rintro ⟨θ, hθ, hd0⟩
    exact hd0.1
end LevWall4
