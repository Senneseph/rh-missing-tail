import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter P12 RHEnd ThetaInf

open scoped Topology

/-!
**LevWall — the LEVINSON WALL (0293, option B, unit 5):  the EXACT
gap object of lane M2, named, typed and closed off in-tree.**

PROVENANCE (primary sources, re-pulled 2026-11-11):

* **Bettin-Gonek** (arXiv:1604.02740, Mathematika 63 (2017) 29-33),
  section 1 (verbatim from the pull):
  "Levinson [4] computed the asymptotic formula (1.2) ...
  for **0 < θ < 1/2**, and used this result to deduce that
  κ > 1/3. Conrey [1] later proved that (1.2) (with a slightly
  different mollifier) remains valid for **θ < 4/7**, and thereby
  deduced that κ > 2/5."
* **Bettin-Gonek** section 1, the HISTORICAL FLIP (verbatim):
  "Initially it was believed (see [2]) that (1.2) does not hold
  when θ > 1. However, Farmer [2] produced a heuristic argument
  suggesting that it holds for every θ > 0, and called this the
  'θ = ∞ conjecture'."
* **Bettin-Gonek Theorem 1** (verbatim): "In particular, if
  I_N(0,T) ≪_ε T^{1+ε} for 2 ≤ N ≤ T^θ with θ arbitrarily large,
  then the Riemann hypothesis is true."
* **PRZZ** (arXiv:1802.10521 = Res. Math. Sci. 7 (2020)), the
  named barrier (quoted in 0292):
  - section 1.3: Balasubramanian-Conrey-Heath-Brown "showed that
    one could push the size of the length θ **past the 1/2
    barrier** to 9/17" (higher-degree test functions, in the
    PROPORTION method),
  - section 9(3): "the best bound for an arbitrary coefficient
    aₙ of a generic Dirichlet series ... is **θ = 17/33 − ε**",
  - section 9(4) (open frontier question): "analyze how a large
    truncation of ℓ could yield terms from a higher degree d ≥ 2.
    What would be a good balance between the degree d and the
    truncation ℓ?",
  - section 1.3 on θ = ∞ itself: "Bettin-Gonek [5] proved that if
    one takes θ = ∞, then RH would follow (not just 100%).
    **Of course, we are very far away from such lengths of
    mollifiers.**"

STATE OF THE ART (the two θ's kept distinct, exactly):

* **(1.2) THE ASYMPTOTIC** `lim I_{T^θ}(0,T)/T = 1 + 1/θ`:
  published for **0 < θ < 4/7** (Levinson 1974: 0 < θ < 1/2,
  original mollifier; Conrey 1989: 0 < θ < 4/7, variant
  mollifier).  OPEN for θ > 4/7.  Conjectured for every θ > 0
  (Farmer, the θ = ∞ conjecture).
* **THE 1/2 BARRIER**: the named barrier of the Levinson-type
  computations (the standard degree-1 setup stops at 1/2; crossed
  in the PROPORTION method by higher-degree test functions,
  B-C-H-B 9/17; the generic-coefficient ceiling is 17/33 − ε).

MACHINE-VERIFIED CONTENT OF THIS UNIT (no analysis, no RH claim):
  1. `asympAt θ` — the EXACT pointwise statement (the same
     Tendsto as the 0290 conjecture, one θ at a time);
  2. `thetaInf_iff_pointwise` — the conjecture IS the pointwise
     family (definitionally);
  3. `levWallAt` — the WALL, the named open input: `asympAt θ`.
     Published reach θ < 4/7; the gap `{θ | 4/7 < θ}` is the
     entire remaining analytic content of lane M2;
  4. `publishedRange_12lt47`, `publishedRange_47lt1`,
     `gapNonempty`, `gapUnbounded` — the range arithmetic,
     machine-proven (1/2 < 4/7 < 1; the gap unbounded);
  5. `terminalFace_of_levWall` — the CLOSING WIRE, gap object
     exposed:  [cited BG implication, 0290] + [the wall at every
     θ > 0]  implies  `terminalFace`  (0288, the exact
     residual).
-/

namespace LevWall

/-! ### 1.  The exact pointwise statement (1.2)-at-θ -/

/-- (1.2) AT A FIXED θ > 0 (exact, self-contained, the same
    Tendsto as `ThetaInf.thetaInfConjecture` one θ at a time):
    `θ = 0 → True` guards the `1/θ`;  for θ > 0 the statement
    is  lim_{T→∞} I_{T^θ}(0,T)/T = 1 + 1/θ  with `thetaIMoment`
    the Levinson mollified second moment of 0290.  PUBLISHED
    REACH:  0 < θ < 4/7  (see the 0293 header).  -/
def asympAt (θ : ℝ) : Prop :=
    Tendsto (fun (T : ℝ) => thetaIMoment (T ^ θ) 0 T / T)
      atTop (𝓝 (1 + 1 / θ))

/-- (PROVEN, machine)  the θ = ∞ conjecture of 0290 is EXACTLY
    the pointwise family at every θ > 0 (definitionally). -/
theorem thetaInf_iff_pointwise :
    thetaInfConjecture ↔ ∀ (θ : ℝ), 0 < θ → asympAt θ := Iff.rfl

/-! ### 2.  THE WALL (the named open input) -/

/-- [LEV-WALL]  the named open analytic input  (cited - 0293
    header).  CONTENT (pointwise):  `asympAt θ`.
    * PUBLISHED REACH:  **0 < θ < 4/7**  -  Levinson 1974
      (original mollifier, weights `1 − log n/log N`, κ > 1/3):
      0 < θ < 1/2;  Conrey 1989 (variant mollifier, κ > 2/5):
      0 < θ < 4/7.  (Facts quoted by Bettin-Gonek, section 1.)
    * THE 1/2 BARRIER:  named and real in the Levinson-type
      computations (PRZZ 2020 section 1.3;  crossed in the
      PROPORTION method by higher-degree test functions only —
      B-C-H-B 9/17;  generic-coefficient ceiling 17/33 − ε,
      section 9(3);  2026 frontier question:  the degree/truncation
      balance, section 9(4)).
    * HISTORICAL FLIP:  (1.2) was initially believed to FAIL for
      θ > 1;  Farmer's heuristic (1996) suggests it holds for
      EVERY θ > 0 (Bettin-Gonek section 1).
    * TARGET:  `thetaInfConjecture`  =  the wall at EVERY θ > 0
      (0290);  `I_N(0,T) ≪_ε T^{1+ε}` for `2 ≤ N ≤ T^θ` with θ
      arbitrarily large  implies  RH  (Bettin-Gonek Theorem 1,
      in particular).
    * STATUS:  **OPEN for θ > 4/7.**  This proposition family is
      THE ENTIRE remaining analytic content of lane M2;  no
      proof is supplied in-tree  (no faking,  per the 0289-0292
      convention).  -/
def levWallAt (θ : ℝ) : Prop := asympAt θ

/-! ### 3.  The gap set and the range arithmetic (machine) -/

/-- THE GAP:  the angles at which [LEV-WALL] is not published —
    every θ strictly above the Conrey frontier 4/7. -/
def levWallGap : Set ℝ := { θ | (4 / 7 : ℝ) < θ }

/-- (PROVEN, machine)  the PUBLISHED REACH ordering:
    1/2 (Levinson) < 4/7 (Conrey) < 1 (the historical-flip
    boundary at which (1.2) was once believed to fail). -/
theorem publishedRange_12lt47 : (1 / 2 : ℚ) < 4 / 7 := by norm_num

/-- (PROVEN, machine)  4/7 < 1. -/
theorem publishedRange_47lt1 : (4 / 7 : ℚ) < 1 := by norm_num

/-- (PROVEN, machine)  the gap is NONEMPTY (θ = 1 is in it). -/
theorem gapNonempty : Set.Nonempty levWallGap := ⟨1, by norm_num [levWallGap]⟩

/-- (PROVEN, machine)  the gap is UNBOUNDED:  past any M there is
    a wall angle  -  the θ = ∞ target has no finite endpoint,
    matching Farmer's heuristic range (every θ > 0). -/
theorem gapUnbounded (M : ℝ) : ∃ θ, θ ∈ levWallGap ∧ M < θ := by
  refine ⟨max M 1 + 1, ?_, ?_⟩
  · have h47 : (4 : ℝ) / 7 < 1 := by norm_num
    have hmin : 1 < max M 1 + 1 := by
      have : 1 ≤ max M 1 := le_max_right M 1
      linarith
    exact lt_trans h47 hmin
  · have : M ≤ max M 1 := le_max_left M 1
    linarith

/-! ### 4.  The CLOSING WIRE (gap object exposed, machine) -/

/-- (PROVEN, machine)  the M2 CLOSING with the gap object named:
    given the zeta-zero membership (`hqz`), the cited BG
    implication [0290, an explicit cited input per the Z78
    pattern],  and the wall at every θ > 0,  the 0288 exact
    residual  `terminalFace q`  holds.  -/
theorem terminalFace_of_levWall (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : thetaInfImpliesAllOnLine)
    (hWall : ∀ (θ : ℝ), 0 < θ → levWallAt θ) :
    terminalFace q :=
  terminalFace_of_thetaInf q hqz hInf (fun θ hθ => hWall θ hθ)

end LevWall
