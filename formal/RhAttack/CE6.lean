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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4 CE5
open scoped Topology

/-!
**CE6 — the terminal face re-anchored at the SIXTH certified window
(0309, option B, unit 20 — lane M5, run 6:  OUR OWN production,
continuing the seamless chain:  windows 1 -> 2 -> 3 -> 4 -> 5 -> 6).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE5):
  RUN  PARAMETERS:  a  =  12 363 153 537 128  (=  CE5's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 557 128  =  b  (b  was  already  a  good  Gram
  point  -  NO  snap  at  either  endpoint),  M  =  60,  C_R
  =  1,  28  workers,  34 159  evaluations  in  2666.1  s.
  CERTIFICATE  (window6_b6.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a6  <  Im  s  <=  g_b6  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a6  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 356 162.7832919233292604...
                 + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE5's
            recorded  g_b5  (same  mantissa/exponent/radius
            tuple  -  the  seam  is  seamless  by
            construction,  a6  =  b5);
      g_b6  =  3 000 175 360 835.718425833875...  + or -
            1.29e-26  (exact  dyadic  decode;  the  fractional
            part  0.7182...  is  at  distance  0.2817  from
            the  next  integer  -  the  floor  is  robust  to
            the  radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  45
      left  of  g_a6,  44  right  of  g_b6  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 159  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  rosser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  the  CLEANEST  window
      of  the  chain  (windows  2/3/4/5  each  carried  one
      rescued  exception;  window  1  was  Murphy's  own
      record).
  VERIFICATION  (three  layers,  same  as  CE2-CE5):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window6_b6.json:
         "CERTIFIED:  true",  points_checked  =  34 159,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  0,
         turing_ok  =  true,  K_conservative  =  12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a6  ball
         is  bit-identical  to  CE5's  recorded  g_b5  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE6  =  3 000 175 360 835,
      tCE6  −  tCE5  =  4 673   (face  shrink  past  tCE5),
      tCE6  −  tPT2  = 28 035  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b6]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  =
      119 998.
  HONESTY  (trust  base):  as  CE2-CE5  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE6

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b6  (the  recorded  ball  is
    3 000 175 360 835.718425833875...  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 8.4e-3).  -/
def gB6Lo : ℚ := 300017536083571 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB6Lo:
    tCE6  =  3 000 175 360 835.  -/
def tCE6 : ℕ := 3000175360835

theorem tCE6_lt_gB6Lo : (tCE6 : ℝ) < (gB6Lo : ℝ) := by
  norm_num [gB6Lo, tCE6]

theorem tCE5_lt_tCE6 : (tCE5 : ℝ) < (tCE6 : ℝ) := by
  norm_num [CE5.tCE5, tCE6]

/-- Record:  the  seam  order  gB5Lo  <  tCE6  (the  band
    (gB5Lo,  tCE6]  is  nonempty  and  lies  above  CE5's
    frontier  tCE5).  -/
theorem gB5Lo_lt_tCE6 : (gB5Lo : ℝ) < (tCE6 : ℝ) := by
  norm_num [CE5.gB5Lo, tCE6]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE5.  -/
theorem faceShrinkCE6 : (tCE6 : ℝ) - (tCE5 : ℝ) = 4673 := by
  norm_num [tCE6, CE5.tCE5]

/-- The  new  frontier  is  28 035  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE6 : ℝ) - WinC.tPT2 = 28035 := by
  norm_num [tCE6, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB4Lo  <  gB5Lo.  -/
theorem gB4Lo_lt_gB5Lo : (gB4Lo : ℝ) < (gB5Lo : ℝ) := by
  norm_num [CE4.gB4Lo, CE5.gB5Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB5Lo  <  gB6Lo)  -  the  window-6  band  (gB5Lo,  gB6Lo]
    (hence  (gB5Lo,  tCE6])  lies  strictly  above  window  5's
    certified  region.  -/
theorem gB5Lo_lt_gB6Lo : (gB5Lo : ℝ) < (gB6Lo : ℝ) := by
  norm_num [CE5.gB5Lo, gB6Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-5  RUN  (window5_b5.json),  FULL  SLICE]
    every  zeta  zero  with  gB4Lo  <  Im  ρ  <=  gB5Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB4Lo,  gB5Lo]  lies  inside  (g_a5,  g_b5]  -  window  5's
    own  certified  region  -  since  gB4Lo  is  the  certified
    bottom  of  g_a5  (=  g_b4)  and  gB5Lo  the  certified
    bottom  of  g_b5  (machine:  gB4Lo  <  gB5Lo,  below).
    This  is  the  FULL  version  of  CE5.ce5WinClause  (which
    is  the  (gB4Lo,  tCE5]  slice  of  the  same  region).
    Named  Prop  consumed  as  a  hypothesis;  not  proven
    in-tree.  -/
def ce5WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB4Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB5Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-6  RUN  (window6_b6.json),  SLICE]
    every  zeta  zero  with  gB5Lo  <  Im  ρ  <=  tCE6  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB5Lo,  tCE6],  either  t0  <=  g_b5
    (the  true  Gram  point  -  g_a6  =  g_b5,  recorded  exact
    dyadic  ball  3 000 175 356 162.7832919233292604...  +
    or  -  1.29e-26,  bit-identical  in  both  certificates;
    the  numerical  order  g_a6  =  g_a5  <  gB5Lo  <  g_b5
    puts  t0  in  window  5's  region  (g_a5,  g_b5])  -  or
    t0  >  g_b5  =  g_a6,  in  which  case  t0  <=  tCE6  <
    gB6Lo  <=  g_b6  puts  t0  in  window  6's  region
    (g_a6,  g_b6].  The  two  certified  regions  union  to
    (g_a5,  g_b6]  which  contains  (gB5Lo,  tCE6]  (machine:
    gB5Lo  <  tCE6  <  gB6Lo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce6WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB5Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE6 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE6]  are  on  the  line,  given  the  six  window
    clauses  -  the  splits  at  gA2Hi,  gB2Lo,  gB3Lo,  gB4Lo,
    gB5Lo  are  pure  case  splits.  -/
theorem bandOfWindows6 (h1 : CE2.ce1WinClause) (h2 : CE3.ce2WinClauseFull)
    (h3 : CE4.ce3WinClauseFull) (h4 : CE5.ce4WinClauseFull)
    (h5 : ce5WinClauseFull) (h6 : ce6WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE6 : ℝ) → ρ.re = 1 / 2 := by
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
          · exact h6 ρ hz (not_le.mp hseam5) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN]  =>  the  on-line  census
    holds  up  to  tCE6.  -/
theorem allOnLineUpToCE6 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : ce5WinClauseFull) (hW6 : ce6WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE6 : ℝ) := by
  have hband := bandOfWindows6 hW1 hW2 hW3 hW4 hW5 hW6
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (sixth  run):  no  off-line
    zero  with  positive  height  above  tCE6.  -/
def terminalFaceCE6 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE6 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE5  face  implies  the  CE6  face
    (tCE6  >  tCE5).  -/
theorem faceCE5_implies_faceCE6 (q : ZeroSet)
    (hface : CE5.terminalFaceCE5 q) :
    terminalFaceCE6 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE5_lt_tCE6, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE5,  tCE6]  is  certified  empty
    (windows  5+6  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE6_iff_faceCE5 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : ce5WinClauseFull) (hW6 : ce6WinClause) :
    terminalFaceCE6 q ↔ CE5.terminalFaceCE5 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE6 : ℝ)
    · by_cases hseam : ρ.im ≤ (gB5Lo : ℝ)
      · exact hW5 ρ (hqz ρ hρ) (by linarith [ht, tCE5_lt_tCE6, CE5.gB4Lo_lt_tCE5]) hseam
      · exact hW6 ρ (hqz ρ hρ) (not_le.mp hseam) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE5_implies_faceCE6 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE6  (pure
    logic).  -/
theorem rh_split_at_CE6 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE6 : ℝ) ∧ terminalFaceCE6 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE6 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE6 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN],  all-heights  RH  <->
    terminalFaceCE6.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE6 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : ce5WinClauseFull) (hW6 : ce6WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE6 q := by
  have hcensus := allOnLineUpToCE6 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hqz
  have hsplit := rh_split_at_CE6 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE6 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : ce5WinClauseFull) (hW6 : ce6WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE6 q) :
    RH q :=
  (rh_reanchored_CE6 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE6_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE6 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE6
