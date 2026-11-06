import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd

open Real Set Complex Filter P12 RHEnd

open scoped Topology

/-!
**ThetaInf — the θ = ∞ lane, named and wired (0290, option B).**

PROVENANCE (primary source, re-pulled 2026-11-11):
  Paper:  Bettin-Gonek, "The θ = ∞ conjecture implies the Riemann
           hypothesis", Mathematika 63 (2017) 29-33,
           arXiv:1604.02740 (ar5iv verbatim pull used here).
  Conjecture (Farmer; as named in the paper, §1):  formula (1.2)
           lim_{T->oo} I_{T^θ}(0,T)/T = 1 + 1/θ  (proven for
           0 < θ < 1/2:  Levinson 1974 / Conrey 1989)  is
           conjectured to hold for EVERY  θ > 0  -  the "θ = ∞
           conjecture".  I_N(T1,T2) = ∫_{T1}^{T2} |M_N(1/2+it)|²
           |ζ(1/2+it)|² dt,  M_N(s) = ∑_{n≤N} μ(n)/n^s ·
           (1 − log n / log N)  (the standard Levinson
           mollifier;  N = T^θ, sum up to floor).
  Theorem 1 (cited, verbatim shape):  for a FIXED θ > 0, if
           I_N(0,T)  ≪_ε  T^{1+ε}   for  2 ≤ N ≤ T^θ,
           then ζ has no zeros in  Re s > 1/2 + 1/(2θ).
           "In particular, if ...  with θ arbitrarily large, then
           the Riemann hypothesis is true."
  Consequence chain (as in the paper):  the θ = ∞ conjecture
           implies  κ = 1  (Farmer)  -  100% of the zeros on the
           line;  Theorem 1 with θ arbitrarily large gives the
           same as a zero-free-region statement.
  2026 status:  ALIVE and ACTIVE -  arXiv:2605.24363 extends the
           implication to cuspidal automorphic L(GL_m);  the
           unconditional Levinson-type proportion record stands
           at at least 2/3 of the zeros on the line
           (Conrey-Chandee-Farb-Young).

ROLE IN THE PROGRAM (0289 face-menu lane M2):
  The W2/A1 wire is a FINITE-HEIGHT machine (0289 dead end);  the
  θ = ∞ lane is the alive NON-WIRE mechanism, and this module
  wires it to the 0288 terminal face in the project's Z78
  citation pattern:
    *  thetaInfConjecture          the conjecture, self-contained
                                   (Levinson mollifier + mollified
                                   second moment, exact form (1.2));
    *  thetaBounded θ              Theorem 1's antecedent
                                   (≪_ε T^{1+ε} over 2 ≤ N ≤ T^θ);
    *  bgThetaShrink θ             CITED:  antecedent ⟹ zero-free
                                   in BOTH flanks  Re > 1/2 +
                                   1/(2θ)  and  Re < 1/2 − 1/(2θ)
                                   (Theorem 1 right flank, cited;
                                   the left flank is the classical
                                   functional-equation reflection
                                   s ↦ 1 − conj(s));
    *  thetaInfImpliesAllOnLine    CITED:  the θ = ∞ conjecture
                                   ⟹ every zeta zero is on the
                                   line  (Farmer κ = 1 + Theorem 1
                                   particular case, cited as ONE
                                   input, the Z78 pattern).
  Machine-verified wiring (the LEAN-proven part, no analysis):
    *  terminalFace_of_thetaInf    the conjecture (cited
                                   implication) ⟹ terminalFace -
                                   the M2 lane CLOSING;
    *  terminalFace_of_bgShrink    for any FIXED θ > 0, Theorem 1's
                                   antecedent (cited) ⟹ terminalFace
                                   with the face SHRUNK from
                                   0 < d0 ≤ 3/8 to the θ-face
                                   0 < d0 ≤ 1/(2θ)  (d0 = |re-1/2|):
                                   each cited θ shrinks the face
                                   (θ → ∞ collapses it to a point);
                                   θ = 4 already kills the route-(b)
                                   face zero (d0_A = 0.37477 > 1/8 =
                                   1/(2·4)  →  it sits in the flanks,
                                   excluded by the cited zero-free
                                   region).
  NO RH CLAIM:  the two cited inputs are open (the conjecture is a
  conjecture;  the boundedness antecedent is not known);  the face
  remains open without them.
-/

namespace ThetaInf

/-! ### 1.  The Levinson mollifier and the mollified second moment
-/
/-- THE LEVINSON MOLLIFIER of (real) length `Y >= 2`:
    M_Y(s) = ∑_{n ≤ floor Y} μ(n) · n^(-s) · (1 − log n / log Y),
    n^(-s) = exp(−s · log n)  (log n real - the n > 0 branch is
    unambiguous;  the weight (1 − log n / log Y) decays to 0 at
    n = Y).  Standard form (Levinson 1974);  the sum is over
    n ≤ floor Y so the definition is total in Y, and for Y ≥ 2 it
    is exactly the standard mollifier with length Y.  -/
noncomputable def thetaMoll (Y : ℝ) (s : ℂ) : ℂ :=
    (Finset.Icc 1 (Nat.floor Y)).sum fun n =>
      (ArithmeticFunction.moebius n : ℂ) *
      Complex.exp (-s * (Real.log (n : ℝ) : ℂ)) *
        ((1 : ℝ) - Real.log (n : ℝ) / Real.log Y)

/-- THE MOLLIFIED SECOND MOMENT (Levinson I_N, real-length form):
    I_Y(T1, T2) = ∫_{T1}^{T2} |M_Y(1/2 + it)|² · |ζ(1/2 + it)|² dt.
    For Y ≥ 2 and a compact interval the integrand is continuous
    (hence Lebesgue-integrable);  as a term it is total.  -/
noncomputable def thetaIMoment (Y : ℝ) (T1 T2 : ℝ) : ℝ :=
    ∫ t in T1..T2,
      ‖thetaMoll Y (Complex.mk (1 / 2 : ℝ) t)‖ ^ 2 *
      ‖riemannZeta (Complex.mk (1 / 2 : ℝ) t)‖ ^ 2

/-! ### 2.  The cited propositions (Z78 pattern)
-/
/-- THE θ = ∞ CONJECTURE (named, self-contained;  the EXACT form
    (1.2) of Bettin-Gonek arXiv:1604.02740, conjectured - Farmer's
    - for EVERY θ > 0, proven only for 0 < θ < 1/2):

        ∀ θ > 0,  lim_{T→∞} I_{T^θ}(0, T) / T  =  1 + 1/θ.

    N = T^θ is read in the standard real-length form (the sum of
    the mollifier runs to floor of T^θ).  No proof is supplied
    in-tree:  extending the Levinson-Conrey asymptotic beyond
    θ = 1/2 is the analytic research target of lane M2.  -/
def thetaInfConjecture : Prop :=
    ∀ (θ : ℝ), 0 < θ →
      Tendsto (fun (T : ℝ) => thetaIMoment (T ^ θ) 0 T / T)
        atTop (𝓝 (1 + 1 / θ))

/-- THEOREM-1 ANTECEDENT, FIXED θ (verbatim shape of the
    assumption of Bettin-Gonek Theorem 1):  for every ε > 0 the
    mollified second moment is  ≪_ε  T^{1+ε} uniformly over the
    polynomial range  2 ≤ N ≤ T^θ:

        ∀ ε > 0, ∃ C > 0, ∃ T0 > 0, ∀ T ≥ T0,
          ∀ N,  2 ≤ N ≤ T^θ  ⟹  I_N(0, T) ≤ C · T^{1+ε}.

    (N is integral as in the paper;  the moment is written in the
    self-contained real-length form.)  Not known for any fixed θ:
    the unconditional Levinson asymptotic (hence the ≪_ε bound
    from it) is proven only in the range 0 < θ ≤ 1/2, and the
    uniformity in the RANGE 2 ≤ N ≤ T^θ (single constant C, one
    T0, all N) is a stronger shape than the pointwise-in-θ
    asymptotic;  the two are NOT linked in-tree (honesty).  -/
def thetaBounded (θ : ℝ) : Prop :=
    ∀ (ε : ℝ), 0 < ε → ∃ (C T0 : ℝ), 0 < C ∧ 0 < T0 ∧
      ∀ (T : ℝ), T0 ≤ T →
        ∀ (N : ℕ), (2 : ℝ) ≤ (N : ℝ) ∧ (N : ℝ) ≤ T ^ θ →
          thetaIMoment (N : ℝ) 0 T ≤ C * T ^ (1 + ε)

/-- [CITED, THEOREM 1 + FUNCTIONAL-EQUATION REFLECTION]  for a
    fixed θ > 0:  the Theorem-1 antecedent implies ZERO-FREE in
    BOTH flanks of the line:

        thetaBounded θ  ⟹  ∀ s,
            (1/2 + 1/(2θ)) < Re s  ∨  Re s < (1/2 − 1/(2θ))
          ⟹  ζ(s) ≠ 0.

    Provenance:  the right flank  Re s > 1/2 + 1/(2θ)  is
    Bettin-Gonek Theorem 1 VERBATIM ("Then ζ(s) has no zeros in
    the half-plane Re s > 1/2 + 1/(2θ).");  the left flank is the
    classical functional-equation reflection:  ζ(s) = 0
    ⟹  ζ(1 − conj s) = 0,  and  Re s < 1/2 − 1/(2θ)
    ⟹  Re(1 − conj s) = 1 − Re s > 1/2 + 1/(2θ).  Cited in the
    Z78 pattern (a named Prop consumed as a hypothesis;  not
    proven in-tree).  -/
def bgThetaShrink (θ : ℝ) : Prop :=
    thetaBounded θ →
      ∀ (s : ℂ), (1 / 2 + 1 / (2 * θ) : ℝ) < s.re ∨
        s.re < 1 / 2 - 1 / (2 * θ) →
        riemannZeta s ≠ 0

/-- [CITED, FARMER κ = 1 + THEOREM 1 PARTICULAR CASE]  the θ = ∞
    conjecture implies that EVERY nontrivial zeta zero is on the
    line:

        thetaInfConjecture  ⟹  ∀ ρ,  ζ(ρ) = 0  ⟹  Re ρ = 1/2.

    Provenance:  §1 of arXiv:1604.02740 - "he proved [Farmer]
    that this conjecture implies that κ = 1, in other words, that
    100% of the non-trivial zeros of ζ(s) lie on the critical
    line";  equivalently Theorem 1 with "θ arbitrarily large,
    then the Riemann hypothesis is true".  Cited in the Z78
    pattern (one named input).  -/
def thetaInfImpliesAllOnLine : Prop :=
    thetaInfConjecture → ∀ (ρ : ℂ), riemannZeta ρ = 0 → ρ.re = 1 / 2

/-! ### 3.  The machine-verified wiring onto the 0288 terminal face
-/
/-- 0290 · M2 LANE, CLOSING:  under the cited implication
    [thetaInfImpliesAllOnLine] and the cited input [the θ = ∞
    conjecture itself], every zero of a zeta-subset zero set is on
    the line, hence above the frontier -  terminalFace holds.
    The M2 lane is wired:  proving the conjecture (extending the
    Levinson-Conrey asymptotic beyond θ = 1/2) closes the face.
    NO RH CLAIM (the conjecture is an open input).  -/
theorem terminalFace_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : thetaInfImpliesAllOnLine)
    (hC : thetaInfConjecture) :
    terminalFace q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

/-- 0290 · M2 LANE, SHRUNKING:  for any FIXED θ > 0, the
    cited Theorem-1 antecedent [thetaBounded θ] plus the cited
    flank zero-free [bgThetaShrink θ] imply terminalFace with the
    face SHRUNK from the unified38 band  0 < d0 ≤ 3/8  to the
    θ-face  0 < d0 ≤ 1/(2θ):  no off-pair at t0 ≥ tPT2 in
    0 < d0 ≤ 1/(2θ)  (an additional face variant, the B24-series
    d0max-shrink pattern).  An off-line zero above tPT2 at
    d0 > 1/(2θ) sits in a flank and is excluded by the cited
    zero-free region;  d0 ≤ 1/(2θ) is the θ-face.  Each cited θ
    shrinks the face;  θ → ∞ collapses it to a point  (the full
    closure is  terminalFace_of_thetaInf).  At  θ = 4  the flanks
    start at  Re > 5/8  and  Re < 3/8 -  the route-(b) face zero
    (Re = 0.1252,  d0 = 0.37477 > 1/8)  sits in the LEFT flank
    and is excluded.  NO RH CLAIM (the antecedent and the
    implication are open cited inputs).  -/
theorem terminalFace_of_bgShrink (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (θ : ℝ) (hθ : 0 < θ)
    (hShrink : bgThetaShrink θ)
    (hBounded : thetaBounded θ)
    (hFaceθ : ∀ (t0 d0 : ℝ), WinC.tPT2 ≤ t0 → 0 < d0 →
      d0 ≤ 1 / (2 * θ) → ¬ offPair q t0 d0) :
    terminalFace q := by
  intro ρ hρ ht
  by_contra hnot
  set t0 := ρ.im with ht0def
  set d0 := |ρ.re - 1 / 2| with hd0def
  have hd0pos : 0 < d0 := by
    rw [hd0def]
    exact abs_pos.mpr (by
      intro hz
      have hre : ρ.re = 1 / 2 := by linarith [hz]
      exact hnot hre)
  have htpos2 : 0 < WinC.tPT2 := by norm_num [WinC.tPT2]
  have ht0pos : 0 < t0 := by
    rw [ht0def]
    linarith [ht, htpos2]
  have hp : offPair q t0 d0 :=
    ⟨ρ, hρ,
      by intro hre; exact hnot hre,
      by rw [ht0def, abs_of_nonneg (le_of_lt ht0pos)],
      by rw [hd0def]⟩
  by_cases hdle : d0 ≤ 1 / (2 * θ)
  · exact (hFaceθ t0 d0 (le_of_lt ht) hd0pos hdle) hp
  · --  d0 > 1/(2θ):  the witness sits in a FLANK.
    have hflank : (1 / 2 + 1 / (2 * θ) : ℝ) < ρ.re ∨
        ρ.re < 1 / 2 - 1 / (2 * θ) := by
      by_cases hre : ρ.re ≤ 1 / 2
      · right
        have habs : |ρ.re - 1 / 2| = 1 / 2 - ρ.re := by
          rw [← neg_sub, abs_neg]
          exact abs_of_nonneg (by linarith [hre])
        have hsub : 1 / 2 - ρ.re > 1 / (2 * θ) := by
          linarith [habs, hd0def, not_le.mp hdle]
        linarith [hsub]
      · left
        have habs : |ρ.re - 1 / 2| = ρ.re - 1 / 2 :=
          abs_of_nonneg (by linarith [not_le.mp hre])
        have hsub : ρ.re - 1 / 2 > 1 / (2 * θ) := by
          linarith [habs, hd0def, not_le.mp hdle]
        linarith [hsub]
    have hzfree : riemannZeta ρ ≠ 0 := (hShrink hBounded) ρ hflank
    exact hzfree (hqz ρ hρ)

end ThetaInf
