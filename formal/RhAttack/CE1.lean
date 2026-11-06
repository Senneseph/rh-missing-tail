import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf

open Real Set Complex Filter B0 P12 RHEnd
open scoped Topology

/-!
**CE1 — the terminal face re-anchored at Murphy's certified window
(0291, option B, unit 3 — lane M5, the machine-verified shrinking lane).**

PROVENANCE (primary source, pulled 2026-11-11):
  Paper:  P. W. Murphy, "A certified window of zeros of the Riemann
           zeta function just above 3e12, with a machine-checked
           Riemann-Siegel remainder", October 2026.
           https://zenodo.org/records/23489697/files/ce1_window_paper.pdf
           (record https://doi.org/10.5281/zenodo.23486195,
           dataset https://doi.org/10.5281/zenodo.23486196)
  THEOREM 1 (verbatim numbers):  with  g_n  the  n-th  Gram  point,
           a = 12 363 153 437 130,  b = 12 363 153 457 130:
             g_a ∈ [3000175332798.574911824343 ± 1.60·10^-13],
             g_b ∈ [3000175337471.510047088127 ± 1.86·10^-13],
           and the  b − a = 20 000  zeros of  ζ(s)  with
           g_a < Im s ≤ g_b  are ALL SIMPLE and on the line  Re s = 1/2.
  Combined with Platt-Trudgian (Bull. LMS 53 (2021);  RH verified up to
  H0 = 3 000 175 332 800  =  EXACTLY  WinC.tPT2):  "the two results
  together show that every non-trivial zero  ρ  with  0 < Im ρ ≤ g_b
  has real part  1/2."
  METHOD (as described):  128-bit Arb ball arithmetic;  Hardy's
  Z by the Riemann-Siegel formula with first correction term;  the
  remainder bounded by a Lean 4 kernel-checked theorem
  (RSInt.rs_Z_C0':  (3/5)·t^(-3/4),  t ≥ 4250);  Turing's method with
  a Gram-block count meeting Amberger's correction (arXiv 2512.23064,
  unrefereed);  positive and negative controls (a hidden off-line pair
  is detected and certification refused);  Odlyzko-table calibration;
  the whole window REPRODUCED by independently written audit code;
  AI-assisted (Claude, Anthropic) under the author's direction — the
  source's own provenance note.

ROLE IN THE PROGRAM (0289 face-menu lane M5):
  M5 is the lane in which the CERTIFIED CENSUS FRONTIER moves.  The
  new cited window extends the verified region strictly above
  WinC.tPT2, so the frontier re-anchors from
      tPT2 = 3 000 175 332 800  (Platt-Trudgian)
  to
      tCE1 = 3 000 175 337 471  (an integer strictly below g_b,
      machine-verified in this module).
  Machine-verified in this module (no analysis):
    *  ce1WindowAboveTPT2         the cited window clause at the safe
                                   integer level (THE new cited input
                                   [CE1], Z78 pattern);
    *  allOnLineUpToCE1           [Z-PT2] + [CE1]  ⟹  the census up to
                                   tCE1 (the frontier actually moved);
    *  terminalFaceCE1            the re-anchored face (no off-line
                                   zero with positive height above
                                   tCE1) — the height domain of the
                                   face is STRICTLY smaller (the band
                                   (tPT2, tCE1] is certified empty);
    *  rh_split_at_CE1            the 0288 exact residual RE-PINNED at
                                   the new frontier (pure logic);
    *  terminalFaceCE1_iff_face0  the two face formulations are
                                   EQUIVALENT under [CE1] — the
                                   shrinking is a certificate, not a
                                   logical move (honesty);
    *  rh_reanchored_CE1          all-heights RH  ⟺  terminalFaceCE1,
                                   given [Z-PT2] + [CE1] (headline);
    *  terminalFaceCE1_of_thetaInf  the 0290 M2 closing lands DIRECTLY
                                   at the new frontier.
  The extension is tiny (about 4671.5 absolute,  1.6·10^-9  relative —
  the source itself says it "says nothing about the Riemann hypothesis
  beyond the window");  its value is that M5 now works END-TO-END on
  a fresh 2026 cited artifact, and every future window above H0
  re-anchors the face by the same two-line machine composition.
  NO RH CLAIM.  -/

namespace CE1

/-! ### 1.  The certified constants
-/
/-- Certified UPPER bound for  g_a  (Theorem 1:  g_a ∈
    [3000175332798.574911824343 ± 1.60·10^-13];  this rational
    3000175332798.57491182451  rounds the top up).  -/
def gAHi : ℚ := 300017533279857491182451 / 10 ^ 11

/-- Certified LOWER bound for  g_b  (Theorem 1:  g_b ∈
    [3000175337471.510047088127 ± 1.86·10^-13];  this rational
    3000175337471.51004708794  rounds the bottom down).  -/
def gBLo : ℚ := 300017533747151004708794 / 10 ^ 11

/-- THE NEW CERTIFIED CENSUS FRONTIER:  an integer strictly below the
    certified lower bound of g_b  (hence  ≤  g_b  in the certified
    sense):   tCE1  =  3 000 175 337 471.  -/
def tCE1 : ℕ := 3000175337471

theorem gAHi_lt_tPT2 : (gAHi : ℝ) < WinC.tPT2 := by norm_num [gAHi, WinC.tPT2]

theorem tCE1_lt_gBLo : (tCE1 : ℝ) < (gBLo : ℝ) := by norm_num [gBLo, tCE1]

theorem tPT2_le_tCE1 : WinC.tPT2 ≤ (tCE1 : ℝ) := by norm_num [tCE1, WinC.tPT2]

/-- The face height shrank by exactly  4671  units (and the face
    remains strictly above the old frontier).  -/
theorem faceShrinkExact : (tCE1 : ℝ) - WinC.tPT2 = 4671 := by
  norm_num [tCE1, WinC.tPT2]

/-! ### 2.  The cited window clause (Z78 pattern)
-/
/-- [CITED, MURPHY 2026 THEOREM 1 + PLATT-TRUDGIAN]  every zeta zero
    with  tPT2 < Im ρ ≤ tCE1  is on the critical line.

    Derivation (recorded;  the inclusion is machine-verified here):
    Murphy's Theorem 1 certifies the 20 000 zeros with
    g_a < Im ≤ g_b  (simple and on the line),  with  g_a,  g_b  in the
    certified intervals of  gAHi / gBLo;  and
        (tPT2, tCE1] = (H0, 3000175337471]  ⊂  (g_a, g_b]
    since  H0  >  g_a  (gAHi_lt_tPT2,  machine)  and
    tCE1  <  g_b  (tCE1_lt_gBLo,  machine).  Cited in the Z78 pattern:
    a named Prop consumed as a hypothesis;  not proven in-tree.  -/
def ce1WindowAboveTPT2 : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE1 : ℝ) → ρ.re = 1 / 2

/-! ### 3.  The machine-verified re-anchoring
-/
/-- M5 · THE FRONTIER MOVED:  under the cited [Z-PT2] census and the
    cited [CE1] window, the on-line census holds up to the new
    frontier  tCE1.  Proof:  a zero of positive height  ≤ tCE1  either
    sits  ≤ tPT2  (census) or in  (tPT2, tCE1]  (window).  -/
theorem allOnLineUpToCE1 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hCE1 : ce1WindowAboveTPT2)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE1 : ℝ) := by
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hCE1 ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 · THE RE-ANCHORED FACE:  no off-line zero with positive height
    above the new frontier  tCE1.  -/
def terminalFaceCE1 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE1 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic:  the 0288 face (above tPT2) implies the re-anchored
    face (above tCE1), since  tCE1 ≥ tPT2.  -/
theorem face0_implies_faceCE1 (q : ZeroSet)
    (hface : terminalFace q) :
    terminalFaceCE1 q := by
  intro ρ hρ ht
  have hpt : WinC.tPT2 ≤ (tCE1 : ℝ) := tPT2_le_tCE1
  exact hface ρ hρ (by linarith [hpt, ht])

/-- M5 · THE TWO FACE FORMULATIONS, EQUIVALENT UNDER [CE1]:  the
    extra height band  (tPT2, tCE1]  is exactly what the cited window
    certifies empty, so re-anchoring is a CERTIFICATE, not a logical
    move (honesty:  the face is the same open object, now certified
    4671 higher).  -/
theorem terminalFaceCE1_iff_face0 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hCE1 : ce1WindowAboveTPT2) :
    terminalFaceCE1 q ↔ terminalFace q := by
  constructor
  · intro hface
    have hpt : WinC.tPT2 ≤ (tCE1 : ℝ) := tPT2_le_tCE1
    intro ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE1 : ℝ)
    · exact hCE1 ρ (hqz ρ hρ) (by linarith [ht, hmid, hpt]) (by assumption)
    · exact hface ρ hρ (not_le.mp hmid)
  · exact face0_implies_faceCE1 q

/-- M5 · THE 0288 EXACT RESIDUAL, RE-PINNED (pure logic, machine
    verified):  all-heights RH  ⟺  (the census up to tCE1)  ∧
    (the re-anchored face).  Same proof shape as
    `rh_split_at_growth_frontier`:  split the all-heights quantifier
    at the new frontier;  negative heights reduce to their
    positive-height conjugate twins (ZeroSet.conj).  -/
theorem rh_split_at_CE1 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE1 : ℝ) ∧ terminalFaceCE1 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE1 : ℝ)
      · exact hCensus ρ hρ hpos hle
      · exact hFace ρ hρ (not_le.mp hle)
    · have hneg : ρ.im < 0 := by
        have hle0 : ρ.im ≤ 0 := not_lt.mp hpos
        have hne0 : ρ.im ≠ 0 := q.nonReal ρ hρ
        exact lt_of_le_of_ne hle0 hne0
      have hst : star ρ ∈ q.Z := q.conj ρ hρ
      have hstpos : 0 < (star ρ).im := by
        have h : (star ρ).im = -ρ.im := by rfl
        rw [h]
        exact neg_pos.mpr hneg
      have hstRe : (star ρ).re = 1 / 2 := by
        by_cases hle : (star ρ).im ≤ (tCE1 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 · HEADLINE:  given the cited [Z-PT2] census and the cited [CE1]
    window,  all-heights RH  ⟺  the RE-ANCHORED FACE.  Completing RH
    once and for all now reduces to closing the face one 4671-unit
    band higher.  NO RH CLAIM.  -/
theorem rh_reanchored_CE1 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hCE1 : ce1WindowAboveTPT2)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE1 q := by
  have hcensus := allOnLineUpToCE1 q hZPT2 hCE1 hqz
  have hsplit := rh_split_at_CE1 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5 · THE FINAL NAMED STEP, RE-ANCHORED:  given [Z-PT2] + [CE1]
    and a closing of the re-anchored face,  all-heights RH holds.
    NO RH CLAIM:  no closing of the face is supplied.  -/
theorem rh_of_terminalFaceCE1 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hCE1 : ce1WindowAboveTPT2)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE1 q) :
    RH q :=
  (rh_reanchored_CE1 q hZPT2 hCE1 hqz).mpr hFace

/-- M5 × M2 · the 0290 lane closing lands DIRECTLY at the new
    frontier:  the cited θ=∞ inputs give the re-anchored face (the
    old 0288 face is not even needed as a stop-over).  -/
theorem terminalFaceCE1_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE1 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE1
