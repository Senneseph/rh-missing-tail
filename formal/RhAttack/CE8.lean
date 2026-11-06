import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3
import RhAttack.CE4
import RhAttack.CE5
import RhAttack.CE6
import RhAttack.CE7

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4 CE5 CE6 CE7
open scoped Topology

/-!
**CE8 — the terminal face re-anchored at the EIGHTH certified
window (0313, option B, unit 24 — lane M5, run 8:  OUR OWN
production, continuing the seamless chain:  windows
1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7 -> 8).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE7):
  RUN  PARAMETERS:  a  =  12 363 153 577 128  (=  CE7's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 597 128,  driver  snapped  the  final  b  DOWN  to
  12 363 153 597 127  (12 363 153 597 128  was  not  a  good
  Gram  point  at  the  requested  precision;  a  =  ...577
  128  WAS  good  -  NO  snap  at  a),  M  =  60,  C_R  =  1,
  28  workers,  32 867  evaluations  in  2464.2  s.
  CERTIFICATE  (window8_b8.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a8  <  Im  s  <=  g_b8  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a8  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 365 508.653559473769  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE7's
            recorded  g_b7  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b8  =  3 000 175 370 181.355046086348...  + or -
            1.29e-26  (exact  dyadic  decode;  the  fractional
            part  0.35504...  is  at  distance  0.6450  from
            the  next  integer  -  the  floor  is  robust  to
            the  radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  45
      left  of  g_a8,  49  right  of  g_b8  (both  >=  K  =
      12);  0  cross-check  failures  (all  32 867  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      window  6).
  VERIFICATION  (three  layers,  same  as  CE2-CE7):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window8_b8.json:
         "CERTIFIED:  true",  points_checked  =  32 867,
         sign_changes_inside  =  19 999  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a8  ball
         is  bit-identical  to  CE7's  recorded  g_b7  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE8  =  3 000 175 370 181,
      tCE8  −  tCE7  =  4 673   (face  shrink  past  tCE7),
      tCE8  −  tPT2  = 37 381  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b8]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  =  159 997.
  HONESTY  (trust  base):  as  CE2-CE7  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE8

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b8  (the  recorded  ball  is
    3 000 175 370 181.355046086348...  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 5.05e-3).  -/
def gB8Lo : ℚ := 300017537018135 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB8Lo:
    tCE8  =  3 000 175 370 181.  -/
def tCE8 : ℕ := 3000175370181

theorem tCE8_lt_gB8Lo : (tCE8 : ℝ) < (gB8Lo : ℝ) := by
  norm_num [gB8Lo, tCE8]

theorem tCE7_lt_tCE8 : (tCE7 : ℝ) < (tCE8 : ℝ) := by
  norm_num [CE7.tCE7, tCE8]

/-- Record:  the  seam  order  gB7Lo  <  tCE8  (the  band
    (gB7Lo,  tCE8]  is  nonempty  and  lies  above  CE7's
    frontier  tCE7).  -/
theorem gB7Lo_lt_tCE8 : (gB7Lo : ℝ) < (tCE8 : ℝ) := by
  norm_num [CE7.gB7Lo, tCE8]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE7.  -/
theorem faceShrinkCE8 : (tCE8 : ℝ) - (tCE7 : ℝ) = 4673 := by
  norm_num [tCE8, CE7.tCE7]

/-- The  new  frontier  is  37 381  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE8 : ℝ) - WinC.tPT2 = 37381 := by
  norm_num [tCE8, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB6Lo  <  gB7Lo  (re-stated  at  the  CE8  level  from
    CE7's  window-7  band  ordering).  -/
theorem gB6Lo_lt_gB7Lo : (gB6Lo : ℝ) < (gB7Lo : ℝ) := by
  norm_num [CE6.gB6Lo, CE7.gB7Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB7Lo  <  gB8Lo)  -  the  window-8  band  (gB7Lo,  gB8Lo]
    (hence  (gB7Lo,  tCE8])  lies  strictly  above  window  7's
    certified  region.  -/
theorem gB7Lo_lt_gB8Lo : (gB7Lo : ℝ) < (gB8Lo : ℝ) := by
  norm_num [CE7.gB7Lo, gB8Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-7  RUN  (window7_b7.json),  FULL  SLICE]
    every  zeta  zero  with  gB6Lo  <  Im  ρ  <=  gB7Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB6Lo,  gB7Lo]  lies  inside  (g_a7,  g_b7]  -  window  7's
    own  certified  region  -  since  gB6Lo  is  the  certified
    bottom  of  g_a7  (=  g_b6,  bit-identical  dyadic  ball  in
    windows  6 and  7)  and  gB7Lo  the  certified  bottom  of
    g_b7  (machine:  gB6Lo  <  gB7Lo,  below).  This  is  the
    FULL  version  of  CE7.ce7WinClause  (which  is  the
    (gB6Lo,  tCE7]  slice  of  the  same  region).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce7WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB6Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB7Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-8  RUN  (window8_b8.json),  SLICE]
    every  zeta  zero  with  gB7Lo  <  Im  ρ  <=  tCE8  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB7Lo,  tCE8],  either  t0  <=  g_b7
    (the  true  Gram  point  -  g_a8  =  g_b7,  recorded  exact
    dyadic  ball  3 000 175 365 508.653559473769  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a8  =  g_a7  <  gB7Lo  <  g_b7  puts
    t0  in  window  7's  region  (g_a7,  g_b7])  -  or
    t0  >  g_b7  =  g_a8,  in  which  case  t0  <=  tCE8  <
    gB8Lo  <=  g_b8  puts  t0  in  window  8's  region
    (g_a8,  g_b8].  The  two  certified  regions  union  to
    (g_a7,  g_b8]  which  contains  (gB7Lo,  tCE8]  (machine:
    gB7Lo  <  tCE8  <  gB8Lo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce8WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB7Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE8 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE8]  are  on  the  line,  given  the  eight
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo  are  pure  case
    splits.  -/
theorem bandOfWindows8 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : ce7WinClauseFull)
    (h8 : ce8WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE8 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
          · exact h5 ρ hz (not_le.mp hseam4) hseam5
          · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
            · exact h6 ρ hz (not_le.mp hseam5) hseam6
            · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
              · exact h7 ρ hz (not_le.mp hseam6) hseam7
              · exact h8 ρ hz (not_le.mp hseam7) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN-FULL]  +  [CE7-WIN-FULL]  +
    [CE8-WIN]  =>  the  on-line  census  holds  up  to  tCE8.  -/
theorem allOnLineUpToCE8 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : ce7WinClauseFull) (hW8 : ce8WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE8 : ℝ) := by
  have hband := bandOfWindows8 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (eighth  run):  no  off-line
    zero  with  positive  height  above  tCE8.  -/
def terminalFaceCE8 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE8 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE7  face  implies  the  CE8  face
    (tCE8  >  tCE7).  -/
theorem faceCE7_implies_faceCE8 (q : ZeroSet)
    (hface : CE7.terminalFaceCE7 q) :
    terminalFaceCE8 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE7_lt_tCE8, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE7,  tCE8]  is  certified  empty
    (windows  7+8  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE8_iff_faceCE7 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW6 : CE7.ce6WinClauseFull) (hW7 : ce7WinClauseFull)
    (hW8 : ce8WinClause) :
    terminalFaceCE8 q ↔ CE7.terminalFaceCE7 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE8 : ℝ)
    · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
      · exact hW6 ρ (hqz ρ hρ) (by linarith [ht, gB5Lo_lt_tCE6, tCE6_lt_tCE7]) hseam6
      · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
        · exact hW7 ρ (hqz ρ hρ) (not_le.mp hseam6) hseam7
        · exact hW8 ρ (hqz ρ hρ) (not_le.mp hseam7) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE7_implies_faceCE8 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE8  (pure
    logic).  -/
theorem rh_split_at_CE8 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE8 : ℝ) ∧ terminalFaceCE8 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE8 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE8 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN-FULL]  +  [CE7-WIN-FULL]  +
    [CE8-WIN],  all-heights  RH  <->  terminalFaceCE8.
    NO  RH  CLAIM.  -/
theorem rh_reanchored_CE8 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : ce7WinClauseFull) (hW8 : ce8WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE8 q := by
  have hcensus := allOnLineUpToCE8 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hqz
  have hsplit := rh_split_at_CE8 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE8 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : ce7WinClauseFull) (hW8 : ce8WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE8 q) :
    RH q :=
  (rh_reanchored_CE8 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE8_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE8 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE8
