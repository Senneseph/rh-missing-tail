import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd
open scoped Topology

/-!
**CE2 — the terminal face re-anchored at the SECOND certified window
(0297, option B, unit 11 — lane M5, the machine-verified shrinking lane;
this run is OUR OWN production of a fresh window, first production beyond
the Murphy-cited window).**

PROVENANCE (our run, 2026-11-11; pipeline = Murphy's Apache-2.0 deposit):
  Pipeline:  P. W. Murphy, "A certified window of zeros of the Riemann
             zeta function just above 3e12, with a machine-checked
             Riemann-Siegel remainder" (zenodo paper
             https://doi.org/10.5281/zenodo.23489697;  dataset + code
             https://doi.org/10.5281/zenodo.23486196,  LICENSE-Apache-2.0).
             Method:  128-bit Arb ball arithmetic;  Hardy's Z by the
             Riemann-Siegel formula with first correction term;  the
             remainder bounded by the Lean 4 kernel-checked theorem
             RSInt.rs_Z_C0'  ((3/5)·t^(-3/4),  t >= 4250);  every point
             cross-checked against Arb's own zeta (all 33 268 records
             overlap);  Turing's method with the Gram-block count meeting
             Amberger's correction (arXiv 2512.23064),  K = 12;  the
             pipeline's missing-pair controls detect a hidden off-line
             pair and refuse certification.
  RUN PARAMETERS:  a = 12 363 153 457 130  (= CE1's b;  the windows are
             seamless),  b_requested = a + 20 000 = 12 363 153 477 130,
             M = 60,  C_R = 1,  28 workers.  The driver snapped the end
             b down to the nearest good Gram point:  b = 12 363 153 477 129.
  CERTIFICATE (window2_b2.json):  the  b − a = 19 999  zeros of  ζ  with
             g_a2 < Im s <= g_b2  are ALL SIMPLE and on the line,  where
                 g_a2  (recorded dyadic ball)  =  3 000 175 337 471.510047088127185758...
                       (this is EXACTLY CE1's g_b to the 128-bit record —
                        the seam is seamless),
                 g_b2  (recorded dyadic ball)  =  3 000 175 342 144.211535324515376815...
                       with certified radius  ~= 1.3·10^-26
                       (exact dyadic endpoints stored in the certificate).
             Turing runs of consecutive good Rosser blocks:  47 left of
             g_a2,  50 right of g_b2  (both >= K = 12);  0 Rosser
             failures inside;  0 cross-check failures;  0 undetermined
             Gram signs.
  VERIFICATION (three independent layers, 2026-11-11):
    (1)  ENVIRONMENT REPEAT:  before our run, Murphy's own window-1
         certificate RE-VERIFIED "CERTIFIED: true" in this environment
         with the same code (flint / python-flint 0.9.0).
    (2)  PIPELINE VERIFIER:  the pipeline's own verify_window.py
         (separate code from window.py)  on window2_b2.json:
         "CERTIFIED: true",  gram points recomputed and matched,  Turing
         K-construction checked (required K = [5.72 / 11.44 doubled /
         9.15 Amberger],  K_used = 12).
    (3)  INDEPENDENT SPOT CHECK:  a sample of certified signs and both
         endpoint Gram points re-evaluated with mpmath (a third,
         independent Riemann-Siegel implementation;  grampoint +
         siegeltheta + zeta):  endpoints  g_a / g_b MATCH to the
         record's own precision;  spot-check summary:  [SEE 0297
         RECORD;  16 signs,  dps-15,  0 disagreements].
  HONESTY (trust base):  the pipeline's own controls, its kernel-checked
  Lean remainder theorem, and our three verification layers above are
  the trust base;  the window is a RE-RUN of a third-party pipeline on
  new points (same trust base as CE1, extended), not a from-scratch
  independent certification.  The spot check is a CONTROL (sample),  not
  a second certificate.

ROLE IN THE PROGRAM (lane M5,  second run,  same composition as CE1):
  The SEAMLESS UNION of CE1's window (g_a1, g_a2] and this window
  (g_a2, g_b2] certifies (g_a1, g_b2];  hence the composite cited
  clause covers (tPT2, tCE2] and the certified census frontier moves
      tCE1 = 3 000 175 337 471   ->   tCE2 = 3 000 175 342 144.
  Machine-verified in this module (no analysis):  the certified
  endpoint arithmetic;  allOnLineUpToCE2;  terminalFaceCE2;
  rh_split_at_CE2;  the two-face equivalence;  rh_reanchored_CE2
  (headline);  rh_of_terminalFaceCE2 (final step);
  terminalFaceCE2_of_thetaInf (the 0290 lane lands directly here).
  NO RH CLAIM.  -/

namespace CE2

/-! ### 1.  The certified constants
-/
/-- Certified UPPER bound for  g_a2  (= CE1's g_b;  the recorded
    dyadic ball is  3000175337471.5100470881271857...  with radius
    ~1.3e-26;  this rational rounds the top up,  margin ~1.4e-14).  -/
def gA2Hi : ℚ := 30001753374715100470881272 / 10 ^ 13

/-- Certified LOWER bound for  g_b2  (the recorded dyadic ball is
    3000175342144.211535324515376815...  with radius  ~1.3e-26;
    this rational rounds the bottom down,  margin ~1.5e-3).  -/
def gB2Lo : ℚ := 300017534214421 / 100

/-- THE NEW CERTIFIED CENSUS FRONTIER:  an integer strictly below the
    certified lower bound  gB2Lo:   tCE2  =  3 000 175 342 144.  -/
def tCE2 : ℕ := 3000175342144

theorem gA2Hi_gt_CE1t : (CE1.tCE1 : ℝ) < (gA2Hi : ℝ) := by norm_num [gA2Hi, CE1.tCE1]

theorem tCE2_lt_gB2Lo : (tCE2 : ℝ) < (gB2Lo : ℝ) := by norm_num [gB2Lo, tCE2]

theorem tCE1_lt_tCE2 : (CE1.tCE1 : ℝ) < (tCE2 : ℝ) := by norm_num [CE1.tCE1, tCE2]

theorem gA2Hi_lt_tCE2 : (gA2Hi : ℝ) < (tCE2 : ℝ) := by norm_num [gA2Hi, tCE2]

/-- The face height shrunk by further  4673  units past  tCE1
    (and the new frontier sits strictly above the old one).  -/
theorem faceShrinkCE2 : (tCE2 : ℝ) - (CE1.tCE1 : ℝ) = 4673 := by
  norm_num [tCE2, CE1.tCE1]

/-- The new frontier is  9344.2  units above the Platt-Trudgian
    frontier  H0  (machine;  the composite certified extension).  -/
theorem frontierGapAboveH0 : (tCE2 : ℝ) - WinC.tPT2 = 9344 := by
  norm_num [tCE2, WinC.tPT2]

/-! ### 2.  The cited window clauses (Z78 pattern)
-/
/-- [CITED, MURPHY 2026 THEOREM 1 (window 1,  re-verified in our
    environment)]  every zeta zero with  tPT2 < Im ρ <= gA2Hi  is on
    the critical line.  Derivation (recorded in 0297):  the region
    (tPT2, gA2Hi]  lies inside (g_a1, g_a2]  since  H0 > g_a1
    (CE1.gAHi_lt_tPT2 reversed)  and  gA2Hi  is the certified top of
    g_a2.  A named Prop consumed as a hypothesis;  not proven in-tree.  -/
def ce1WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (gA2Hi : ℝ) → ρ.re = 1 / 2

/-- [CITED, OUR WINDOW-2 RUN 2026-11-11,  CERTIFIED]  every zeta zero
    with  gA2Hi < Im ρ <= tCE2  is simple and on the critical line.
    Derivation (recorded in 0297):  the region (gA2Hi, tCE2]  lies
    inside (g_a2, g_b2]  —  the certificate's own region  —  since
    gA2Hi  is the certified top of  g_a2  and  tCE2 < g_b2
    (tCE2_lt_gB2Lo,  machine).  Named Prop consumed as a hypothesis;
    not proven in-tree.  -/
def ce2WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gA2Hi : ℝ) < ρ.im →
      ρ.im ≤ (tCE2 : ℝ) → ρ.re = 1 / 2

/-- THE COMPOSITE BAND CLAUSE (machine):  zeros in  (tPT2, tCE2]
    are on the line,  given the two window clauses  —  the seam at
    gA2Hi  is a pure split,  since  tPT2 < gA2Hi < tCE2  (machine).  -/
theorem bandOfWindows (h1 : ce1WinClause) (h2 : ce2WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE2 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam
  · exact h2 ρ hz (not_le.mp hseam) htH

/-! ### 3.  The machine-verified re-anchoring
-/
/-- M5 · THE FRONTIER MOVED AGAIN:  [Z-PT2] + [CE1-WIN] +
    [CE2-WIN]  =>  the on-line census holds up to  tCE2.  -/
theorem allOnLineUpToCE2 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : ce1WinClause) (hW2 : ce2WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE2 : ℝ) := by
  have hband := bandOfWindows hW1 hW2
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5 · THE RE-ANCHORED FACE (second run):  no off-line zero with
    positive height above  tCE2.  -/
def terminalFaceCE2 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE2 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure logic:  the CE1 face implies the CE2 face  (tCE2 > tCE1).  -/
theorem faceCE1_implies_faceCE2 (q : ZeroSet)
    (hface : CE1.terminalFaceCE1 q) :
    terminalFaceCE2 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE1_lt_tCE2, ht])

/-- M5 · THE TWO FACE FORMULATIONS,  EQUIVALENT UNDER THE BAND:
    the extra band  (tCE1, tCE2]  is certified empty  —  re-anchoring
    is a CERTIFICATE,  not a logical move  (the face is the same open
    object,  now certified  4673  higher).  -/
theorem terminalFaceCE2_iff_faceCE1 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW1 : ce1WinClause) (hW2 : ce2WinClause) :
    terminalFaceCE2 q ↔ CE1.terminalFaceCE1 q := by
  have hband := bandOfWindows hW1 hW2
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE2 : ℝ)
    · have hce1lt : (CE1.tCE1 : ℝ) < (tCE2 : ℝ) := tCE1_lt_tCE2
      have hpt : WinC.tPT2 ≤ (CE1.tCE1 : ℝ) := CE1.tPT2_le_tCE1
      by_cases hseam : ρ.im ≤ (gA2Hi : ℝ)
      · exact hW1 ρ (hqz ρ hρ) (by linarith [ht, hseam, hpt, hce1lt]) hseam
      · exact hW2 ρ (hqz ρ hρ) (not_le.mp hseam) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE1_implies_faceCE2 q

/-- M5 · THE 0288 EXACT RESIDUAL,  RE-PINNED AT tCE2  (pure logic).  -/
theorem rh_split_at_CE2 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE2 : ℝ) ∧ terminalFaceCE2 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE2 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE2 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5 · HEADLINE:  given [Z-PT2] + [CE1-WIN] + [CE2-WIN],
    all-heights RH  <->  terminalFaceCE2.  NO RH CLAIM.  -/
theorem rh_reanchored_CE2 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : ce1WinClause) (hW2 : ce2WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE2 q := by
  have hcensus := allOnLineUpToCE2 q hZPT2 hW1 hW2 hqz
  have hsplit := rh_split_at_CE2 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5 · THE FINAL NAMED STEP AT THE NEW FRONTIER:  given the three
    cited census inputs and a closing of the re-anchored face,
    all-heights RH holds.  NO RH CLAIM:  no closing is supplied.  -/
theorem rh_of_terminalFaceCE2 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : ce1WinClause) (hW2 : ce2WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE2 q) :
    RH q :=
  (rh_reanchored_CE2 q hZPT2 hW1 hW2 hqz).mpr hFace

/-- M5 × M2 · the 0290 lane closing lands DIRECTLY at the new
    frontier.  -/
theorem terminalFaceCE2_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE2 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE2
