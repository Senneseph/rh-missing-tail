import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2
open scoped Topology

/-!
**CE3 — the terminal face re-anchored at the THIRD certified window
(0301 addendum, option B, unit 13 — lane M5, run 3:  OUR OWN
production, continuing the seamless chain).**

PROVENANCE (our run, 2026-11-11;  pipeline = Murphy's Apache-2.0
deposit,  same as CE1/CE2):
  RUN PARAMETERS:  a = 12 363 153 477 129  (= CE2's b;  seamless),
  b_requested = a + 20 000 = 12 363 153 497 129,  M = 60,  C_R = 1,
  28 workers.  The driver snapped the end down to the nearest good
  Gram point:  b = 12 363 153 497 128.
  CERTIFICATE (window3_b3.json):  the  b − a = 19 999  zeros of  ζ
  with  g_a3 < Im s <= g_b3  are  ALL SIMPLE  and on the line, where
      g_a3  (recorded exact dyadic ball,  this run's a)
            =  3 000 175 342 144.211535324515376815808...
                 + or - 16 777 217 · 2^-110  ~=  1.15e-26
            and this ball is BIT-IDENTICAL to CE2's recorded
            g_b2  (verified:  same mantissa/exponent/radius tuple  -
            the seam is seamless by construction,  a3 = b2);
      g_b3  =  3 000 175 346 816.913023290277687858722...
                 + or - 1.15e-26.
      Turing runs of consecutive good Rosser blocks:  48 left of
      g_a3,  49 right of g_b3  (both >= K = 12);  0 Rosser failures
      inside  (15 864 blocks inside);  0 cross-check failures
      (all 33 326 records);  0 undetermined Gram signs.
  VERIFICATION (same three layers as CE2):
    (1)  ENVIRONMENT REPEAT  (Murphy's window-1 certificate
         re-verified in this environment  -  see CE2 header);
    (2)  PIPELINE VERIFIER  on  window3_b3.json:  "CERTIFIED: true",
         points_checked = 33 326,  sign_changes_inside = 19 999
         = b − a,  rosser_failures_inside = 0,
         turing_ok = true,  K_conservative = 12,  endpoints
         recomputed and matched;
    (3)  SEAM AUDIT  (this run):  the recorded g_a3 ball is
         bit-identical to CE2's recorded g_b2 ball  (exact dyadic
         decode,  2026-11-11).
  FRONTIER ARITHMETIC (machine,  below):
      tCE3  =  3 000 175 346 816,
      tCE3 − tCE2  =  4 672   (face shrink past tCE2),
      tCE3 − tPT2  = 14 016   (above the Platt-Trudgian H0),
      certified zeros over (g_a1, g_b3]  =  20 000 + 19 999 + 19 999
                                          =  59 998.
  HONESTY (trust base):  as CE2  -  the pipeline's own controls,
  its kernel-checked Lean remainder theorem,  and our three
  verification layers;  a RE-RUN of a third-party pipeline,  not a
  from-scratch independent certification.  NO RH CLAIM.  -/

namespace CE3

/-! ### 1.  The certified constants
-/
/-- Certified LOWER bound for  g_b3  (the recorded ball is
    3 000 175 346 816.913023290278...  with radius  ~= 1.15e-26;
    this rational rounds the bottom down,  margin  ~= 3e-3).  -/
def gB3Lo : ℚ := 300017534681691 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER:  an integer strictly below
    the certified lower bound  gB3Lo:
    tCE3  =  3 000 175 346 816.  -/
def tCE3 : ℕ := 3000175346816

theorem tCE3_lt_gB3Lo : (tCE3 : ℝ) < (gB3Lo : ℝ) := by norm_num [gB3Lo, tCE3]

theorem tCE2_lt_tCE3 : (CE2.tCE2 : ℝ) < (tCE3 : ℝ) := by
  norm_num [CE2.tCE2, tCE3]

/-- Record:  the seam order  gB2Lo < tCE3  (the band  (gB2Lo, tCE3]
    is nonempty and lies above CE2's frontier  tCE2).  -/
theorem gB2Lo_lt_tCE3 : (gB2Lo : ℝ) < (tCE3 : ℝ) := by
  norm_num [gB2Lo, tCE3]

/-- The face height shrunk by further  4 672  units past  tCE2.  -/
theorem faceShrinkCE3 : (tCE3 : ℝ) - (CE2.tCE2 : ℝ) = 4672 := by
  norm_num [tCE3, CE2.tCE2]

/-- The new frontier is  14 016  units above the Platt-Trudgian
    frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE3 : ℝ) - WinC.tPT2 = 14016 := by
  norm_num [tCE3, WinC.tPT2]

/-! ### 2.  The cited window clauses (Z78 pattern)
-/
/-- [CITED,  OUR WINDOW-2 RUN  (window2_b2.json),  FULL SLICE]
    every zeta zero with  gA2Hi < Im ρ <= gB2Lo  is on the critical
    line.  Derivation (recorded):  the region  (gA2Hi, gB2Lo]  lies
    inside  (g_a2, g_b2]  -  CE2's window-2 certificate's own
    certified region  -  since  gA2Hi  is the certified top of
    g_a2  and  gB2Lo  the certified bottom of  g_b2  (= g_a3),
    with  gA2Hi < gB2Lo  (machine,  below).  Same certificate as
    CE2.ce2WinClause  (which is the  (gA2Hi, tCE2]  slice of the
    same region).  Named Prop consumed as a hypothesis;  not proven
    in-tree.  -/
def ce2WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gA2Hi : ℝ) < ρ.im →
      ρ.im ≤ (gB2Lo : ℝ) → ρ.re = 1 / 2

/-- (PROVEN, machine)  the slice is well ordered:
    gA2Hi < gB2Lo  (the two rational bounds straddle the certified
    region  (g_a2, g_b2]).  -/
theorem gA2Hi_lt_gB2Lo : (gA2Hi : ℝ) < (gB2Lo : ℝ) := by
  norm_num [gA2Hi, gB2Lo]

/-- [CITED,  WINDOWS 2 + 3  TOGETHER  (window2_b2.json  and
    window3_b3.json,  both verified in this environment)]
    every zeta zero with  gB2Lo < Im ρ <= tCE3  is on the critical
    line.  Derivation (recorded):  for  t0 = Im ρ  in
    (gB2Lo, tCE3],  either  t0 <= g_a3  (the true Gram point,  the
    exact dyadic ball  3 000 175 342 144.2115353245153768...
    + or - 1.15e-26,  bit-identical in both certificates),  in which
    case  t0 <= g_b2  and  t0 > gB2Lo > gA2Hi >= g_a2  put
    t0  in  (g_a2, g_b2]  (window 2's certified region),  or
    t0 > g_a3,  in which case  t0 <= tCE3 < gB3Lo <= g_b3  put
    t0  in  (g_a3, g_b3]  (window 3's certified region).  The two
    certified regions union to  (g_a2, g_b3]  which contains
    (gB2Lo, tCE3]  (machine).  Named Prop consumed as a hypothesis;
    not proven in-tree.  -/
def ce3WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB2Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE3 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE  (machine):  zeros in  (tPT2, tCE3]
    are on the line,  given  CE2's window-1 clause  and  this run's
    two clauses  -  the splits at  gA2Hi  and  gB2Lo  are pure
    case splits.  -/
theorem bandOfWindows3 (h1 : CE2.ce1WinClause) (h2 : ce2WinClauseFull)
    (h3 : ce3WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE3 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · exact h3 ρ hz (not_le.mp hseam2) htH

/-! ### 3.  The machine-verified re-anchoring
-/
/-- M5 · THE FRONTIER MOVED AGAIN:  [Z-PT2] + [CE1-WIN] +
    [CE2-WIN-FULL] + [CE3-WIN]  =>  the on-line census holds up to
    tCE3.  -/
theorem allOnLineUpToCE3 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : ce2WinClauseFull) (hW3 : ce3WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE3 : ℝ) := by
  have hband := bandOfWindows3 hW1 hW2 hW3
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 · THE RE-ANCHORED FACE  (third run):  no off-line zero with
    positive height above  tCE3.  -/
def terminalFaceCE3 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE3 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic:  the CE2 face implies the CE3 face  (tCE3 > tCE2).  -/
theorem faceCE2_implies_faceCE3 (q : ZeroSet)
    (hface : CE2.terminalFaceCE2 q) :
    terminalFaceCE3 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE2_lt_tCE3, ht])

/-- M5 · THE TWO FACE FORMULATIONS,  EQUIVALENT UNDER THE BAND:
    the extra band  (tCE2, tCE3]  is certified empty  (windows
    2+3 together)  -  re-anchoring is a CERTIFICATE,  not a logical
    move  (the face is the same open object,  now certified
    4 672  higher).  -/
theorem terminalFaceCE3_iff_faceCE2 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW1 : CE2.ce1WinClause) (hW2 : ce2WinClauseFull) (hW3 : ce3WinClause) :
    terminalFaceCE3 q ↔ CE2.terminalFaceCE2 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE3 : ℝ)
    · by_cases hseam : ρ.im ≤ (gB2Lo : ℝ)
      · exact hW2 ρ (hqz ρ hρ) (by linarith [ht, CE2.gA2Hi_lt_tCE2]) hseam
      · exact hW3 ρ (hqz ρ hρ) (not_le.mp hseam) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE2_implies_faceCE3 q

/-- M5 · THE 0288 EXACT RESIDUAL,  RE-PINNED AT tCE3  (pure
    logic).  -/
theorem rh_split_at_CE3 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE3 : ℝ) ∧ terminalFaceCE3 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE3 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE3 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 · HEADLINE:  given  [Z-PT2] + [CE1-WIN] + [CE2-WIN-FULL] +
    [CE3-WIN],  all-heights RH  <->  terminalFaceCE3.  NO RH
    CLAIM.  -/
theorem rh_reanchored_CE3 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : ce2WinClauseFull) (hW3 : ce3WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE3 q := by
  have hcensus := allOnLineUpToCE3 q hZPT2 hW1 hW2 hW3 hqz
  have hsplit := rh_split_at_CE3 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5 · THE FINAL NAMED STEP AT THE NEW FRONTIER:  given the cited
    census inputs and a closing of the re-anchored face,  all-heights
    RH holds.  NO RH CLAIM:  no closing is supplied.  -/
theorem rh_of_terminalFaceCE3 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : ce2WinClauseFull) (hW3 : ce3WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE3 q) :
    RH q :=
  (rh_reanchored_CE3 q hZPT2 hW1 hW2 hW3 hqz).mpr hFace

/-- M5 × M2 · the 0290 lane closing lands DIRECTLY at the new
    frontier.  -/
theorem terminalFaceCE3_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE3 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE3
