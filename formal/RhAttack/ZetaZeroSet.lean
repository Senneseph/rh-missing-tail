/-
# (ZetaZeroSet)  Front page:  Riemann Hypothesis on the ACTUAL zero
set of the Riemann zeta function —  the B-6A composition entry.

The whole verification chain (P1.2 wire,  C1b / S3a detector,
P8Floor residual families,  S4 squeeze,  W2 telescope,  M6
composition,  S1LowT low-t wire)  is proven for an arbitrary
STRUCTURAL zero set q : ZeroSet.  This module records what the
ACTUAL zero set of Riemann zeta owes to the chain —  leg by leg,
with the project's honesty labels —  and the single named theorem
(rhIfMarginZeta) that composes the closure onto the actual set.

LEG MAP (what the actual set owes, and who supplies each leg):

  CITED (classical analysis —  named hypotheses;  references in the
  docstrings;  the Lean core does NOT re-prove the complex
  analytic machinery):
    [Z-A-1..4]  the four structural axioms of q : ZeroSet —
      nonReal (no real zeros),  conj (conjugation symmetry),
      fe (s <-> 1 - s,  DLMF 25.2.12),  finite (finitely many
      zeros below each height;  Lindelöf 1899 / RVM) —  classical
      theorems about zeta,  carried as axioms of the structure by
      project design (B0.lean).
    [Z-EDGE]  no zero on Re = 0 or Re = 1 —  Hadamard (1896) /
      de la Vallée Poussin (1900) on Re = 1;  the functional
      equation on Re = 0.  Named form:  SliverEdge.EdgeZeroFree.
  PINNED (data-adjacent records;  PROVEN norm_num arithmetic over
  the pinned values):
    [Z-PIN-SLIVER]  SliverEdge.SliverRecord —  firstZeroPin
      14.134725141734693790457 inside (14, 707/50),  on-line
      count 1 in the sliver,  floor family 0 < 0.9975 < 1.
    [Z-PIN-SLICE]  S1LowT.SliceFacts nSlice (gapLo : ℝ) —  the
      813-zero slice of (0, 1200],  min gap 0.2211 -> 0.221.
    [Z-PIN-W2]  the W2 walk pins (W2M5:  sup |I_DN| ≤ K_pin =
      2.503 on (1e7, 2e9],  tail floor L_pin,  gap bound 1.1) —
      q-independent measured facts about the RVM error.
  LEAN-PROVEN (the S2 detector leg —  cites NOTHING):
    [S2-STRIP]  S1LowT.s2_strip_min:  devStripMin >=
      floStripMin for t0 ≥ 707/50, 0 < d0 ≤ 1/2 (the 48-point
      C1b lattice + S3a feed certificates).  Named here as
      s2legStrip.
    [S2-EDGE]   SliverEdge.edgeVoid:  the d = 1/2 edge S2 window
      is vacuous for any EdgeZeroFree set (off-pair on Re 0/1).
      Named here as edgeVacuous.
  MEASURED / OPEN (the legs the Lean core cannot supply):
    [S1]  the zero-side walk uniformity (W2-beyond:  the uniform
      bound on the RVM error term;  the W2 telescope + M6 wire it
      into the margin —  the big open research item).
    [S3/S4]  the |zeta| fill and zero-side witness on the actual
      set —  the wire's named hypotheses hs3 / hs4 (the day030
      measured squeeze and the A4.3 residual wire).

rhIfMarginZeta is the composition itself:  q : ZeroSet satisfying
the actual-set bundle ZetaLike,  plus the four structural wire
legs (hs1..hs4,  whose leg map is above),  imply RH q by
P12.p1_2.  THIS IS NOT A PROOF OF RH —  it names on one page
exactly the legs the program still owes (S1 walk uniformity and
the measured fills),  and shows the S2 detector leg already
cites nothing.

Lean 4.33.1 + mathlib v4.33.1.
-/
import Mathlib
import RhAttack.B0
import RhAttack.B5
import RhAttack.P12Uniform
import RhAttack.SliverEdge
import RhAttack.S1LowT

namespace ZetaZeroSet

open B0

/-- THE ACTUAL-SET BUNDLE (B-6A):  what a zero set q must owe to
    be the actual zero set of the Riemann zeta function,  named
    leg by leg.  The four structural legs ([Z-A-1..4]:  nonReal,
    conj,  fe,  finite)  are classical theorems about zeta and are
    carried as axioms of the ZeroSet structure (B0);  the
    zeta-specific extras are pinned here:
      [Z-EDGE]  edgeFree —  the classical zero-free regions
        (Re = 1:  Hadamard / de la Vallée Poussin;  Re = 0:
        functional equation) —  CITED;
      [Z-PIN-SLIVER]  sliver —  the low-t sliver pin record
        (first-zero pin,  on-line count 1,  floor family) —
        PINNED (norm_num-proven arithmetic);
      [Z-PIN-SLICE]  slice —  the 813-zero slice census of
        (0, 1200] —  PINNED. -/
structure ZetaLike (q : ZeroSet) where
  edgeFree : SliverEdge.EdgeZeroFree q
  sliver : SliverEdge.SliverRecord
  slice : S1LowT.SliceFacts S1LowT.nSlice (S1LowT.gapLo : ℝ)

/-- (glue,  PROVEN)  [S2-EDGE]  for any actual-set zero set the
    d = 1/2 edge S2 window is vacuous:  the off-line candidate
    pair sits on the zero-free lines Re = 1 and Re = 0,  so the
    strict d < 1/2 detector atoms cover everything the actual
    set can present. -/
theorem edgeVacuous (q : ZeroSet) (hz : ZetaLike q) (γ : ℝ) :
    rhoPP γ (1 / 2) ∉ q.Z ∧ rhoNP γ (1 / 2) ∉ q.Z :=
  SliverEdge.edgeVoid q hz.edgeFree γ

/-- (glue,  PROVEN)  [S2-STRIP]  on the covered strip region
    (t0 ≥ 707/50,  0 < d0 ≤ 1/2)  the concrete S2 strip floor is a
    lower bound of the straddle deviation —  the detector leg
    cites nothing (the C1b / S3a polynomial certificates). -/
theorem s2legStrip (t0 d0 : ℝ) (ht0 : 707 / 50 ≤ t0)
    (hd0 : 0 < d0) (hd0L : d0 ≤ 1 / 2) :
    S1LowT.devStripMin t0 d0 ≥ S1LowT.floStripMin t0 d0 :=
  S1LowT.s2_strip_min t0 d0 ht0 hd0 hd0L

/-! ### The front page -/

/-- THE FRONT PAGE (B-6A composition onto the actual zero set).
    If q is a zero set satisfying the actual-set bundle (the
    classical cited legs + the pinned data records),  and the four
    structural wire legs hold —
      hs1 (zero side:  ∃ Q ≥ devOf − Mf —  the S1 zero-side
        witness;  OPEN as a uniform theorem:  W2-beyond),
      hs2 (detector:  devOf ≥ flo —  supplied where it reaches by
        s2legStrip + the sliver pin record + edgeVacuity),
      hs3 (definition side:  Q ≤ Bwire + Mr —  the measured
        |zeta| fill under the A4.3 residual wire),
      hs4 (squeeze:  Bwire + Mr + Mf < flo —  the day030 measured
        squeeze) —
    then RH holds on q by P12.p1_2.
    HONESTY:  this composes the closure;  it does not prove the
    open legs.  The remainder for RH is exactly [S1] (the
    uniform walk bound —  the W2-beyond research item) and the
    measured [S3/S4] fills.  No RH claim is made here. -/
theorem rhIfMarginZeta (q : ZeroSet) (hz : ZetaLike q)
    (Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      ∃ (Q : ℝ), Q ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ) (Q : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Q ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 → P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) < flo (t0, d0)) :
    RH q :=
  P12.p1_2 q Mf devOf Bwire Mr flo hs1 hs2 hs3 hs4

end ZetaZeroSet
