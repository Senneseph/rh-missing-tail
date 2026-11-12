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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4
open scoped Topology

/-!
**CE5 — the terminal face re-anchored at the FIFTH certified window
(0308, option B, unit 19 — lane M5, run 5:  OUR OWN production,
continuing the seamless chain:  windows 1 -> 2 -> 3 -> 4 -> 5).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1/CE2/CE3/CE4):
  RUN  PARAMETERS:  a  =  12 363 153 517 128  (=  CE4's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 537 128  =  b  (b  was  already  a  good  Gram
  point  -  NO  snap-down),  M  =  60,  C_R  =  1,  28
  workers,  34 559  evaluations  in  2820.5  s.
  CERTIFICATE  (window5_b5.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a5  <  Im  s  <=  g_b5  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a5  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 351 489.848157742130...
                 + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE4's
            recorded  g_b4  (same  mantissa/exponent/radius
            tuple  -  the  seam  is  seamless  by  construction,
            a5  =  b4);
      g_b5  =  3 000 175 356 162.783291923329...  + or -
            1.29e-26  (exact  dyadic  decode;  the  fractional
            part  0.783...  is  at  distance  0.2168  from  the
            next  integer  -  the  floor  is  robust  to  the
            radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a5,  44  right  of  g_b5  (both  >=  K  =  12);
      0  cross-check  failures  (all  34 559  records);  0
      undetermined  Gram  signs.  Internal  Rosser-block  quota
      exceptions:  ONE  block  reported  below  quota  at  the
      first  pass  (g-indices  12 363 153 534 959 -
      12 363 153 534 961,  need  2,  found  0  at  64
      subdivisions),  rescored  on  its  3-block  union  at  4
      subdivisions  (12 363 153 534 958 - 12 363 153 534 962,
      need  4,  found  4);  plus  ONE  further  rescue  (g-
      indices  12 363 153 519 191 - 12 363 153 519 193,  3-block
      union  12 363 153 519 189 - 12 363 153 519 194,  need  5,
      found  5  at  128  subdivisions).  HONEST  READING,  same
      as  window  4:  zeros  displaced  into  adjacent  Gram
      intervals  by  the  documented  refinement;  SOUND
      because  (as  the  pipeline  states)  only  the  window
      TOTAL  and  the  two  end  Rosser  RUNS  enter  the
      Turing  step:  the  independent  verifier  recomputes
      sign_changes_inside  =  20 000  =  b  −  a  and  the
      runs  50  /  44.
  VERIFICATION  (three  layers,  same  as  CE2/CE3/CE4):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window5_b5.json:
         "CERTIFIED:  true",  points_checked  =  34 559,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  1  (the  block  rescued
         above  -  the  total  and  the  runs  are  what
         Turing  uses,  both  independently  verified),
         turing_ok  =  true,  K_conservative  =  12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a5  ball
         is  bit-identical  to  CE4's  recorded  g_b4  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE5  =  3 000 175 356 162,
      tCE5  −  tCE4  =  4 673   (face  shrink  past  tCE4),
      tCE5  −  tPT2  = 23 362  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b5]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  =  99 998.
  HONESTY  (trust  base):  as  CE2/CE3/CE4  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE5

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b5  (the  recorded  ball  is
    3 000 175 356 162.783291923329...  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 3.3e-3).  -/
def gB5Lo : ℚ := 300017535616278 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB5Lo:
    tCE5  =  3 000 175 356 162.  -/
def tCE5 : ℕ := 3000175356162

theorem tCE5_lt_gB5Lo : (tCE5 : ℝ) < (gB5Lo : ℝ) := by
  norm_num [gB5Lo, tCE5]

theorem tCE4_lt_tCE5 : (tCE4 : ℝ) < (tCE5 : ℝ) := by
  norm_num [CE4.tCE4, tCE5]

/-- Record:  the  seam  order  gB4Lo  <  tCE5  (the  band
    (gB4Lo,  tCE5]  is  nonempty  and  lies  above  CE4's
    frontier  tCE4).  -/
theorem gB4Lo_lt_tCE5 : (gB4Lo : ℝ) < (tCE5 : ℝ) := by
  norm_num [CE4.gB4Lo, tCE5]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE4.  -/
theorem faceShrinkCE5 : (tCE5 : ℝ) - (tCE4 : ℝ) = 4673 := by
  norm_num [tCE5, CE4.tCE4]

/-- The  new  frontier  is  23 362  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE5 : ℝ) - WinC.tPT2 = 23362 := by
  norm_num [tCE5, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB3Lo  <  gB4Lo.  -/
theorem gB3Lo_lt_gB4Lo : (gB3Lo : ℝ) < (gB4Lo : ℝ) := by
  norm_num [CE3.gB3Lo, CE4.gB4Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB4Lo  <  gB5Lo)  -  the  window-5  band  (gB4Lo,  gB5Lo]
    (hence  (gB4Lo,  tCE5])  lies  strictly  above  window  4's
    certified  region.  -/
theorem gB4Lo_lt_gB5Lo : (gB4Lo : ℝ) < (gB5Lo : ℝ) := by
  norm_num [CE4.gB4Lo, gB5Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-4  RUN  (window4_b4.json),  FULL  SLICE]
    every  zeta  zero  with  gB3Lo  <  Im  ρ  <=  gB4Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB3Lo,  gB4Lo]  lies  inside  (g_a4,  g_b4]  -  window  4's
    own  certified  region  -  since  gB3Lo  is  the  certified
    bottom  of  g_a4  (=  g_b3)  and  gB4Lo  the  certified
    bottom  of  g_b4  (machine:  gB3Lo  <  gB4Lo,  below).
    This  is  the  FULL  version  of  CE4.ce4WinClause  (which
    is  the  (gB3Lo,  tCE4]  slice  of  the  same  region).
    Named  Prop  consumed  as  a  hypothesis;  not  proven
    in-tree.  -/
def ce4WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB3Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB4Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-5  RUN  (window5_b5.json),  SLICE]
    every  zeta  zero  with  gB4Lo  <  Im  ρ  <=  tCE5  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB4Lo,  tCE5],  either  t0  <=  g_b4
    (the  true  Gram  point  -  g_a5  =  g_b4,  recorded  exact
    dyadic  ball  3 000 175 351 489.848157742130...  + or -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a5  =  g_a4  <  gB4Lo  <  g_b4  puts
    t0  in  window  4's  region  (g_a4,  g_b4])  -  or  t0  >  g_b4
    =  g_a5,  in  which  case  t0  <=  tCE5  <  gB5Lo  <=  g_b5
    puts  t0  in  window  5's  region  (g_a5,  g_b5].  The  two
    certified  regions  union  to  (g_a4,  g_b5]  which
    contains  (gB4Lo,  tCE5]  (machine:  gB4Lo  <  tCE5  <
    gB5Lo).  Named  Prop  consumed  as  a  hypothesis;
    not  proven  in-tree.  -/
def ce5WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB4Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE5 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE5]  are  on  the  line,  given  the  five  window
    clauses  -  the  splits  at  gA2Hi,  gB2Lo,  gB3Lo,  gB4Lo
    are  pure  case  splits.  -/
theorem bandOfWindows5 (h1 : CE2.ce1WinClause) (h2 : CE3.ce2WinClauseFull)
    (h3 : CE4.ce3WinClauseFull) (h4 : ce4WinClauseFull) (h5 : ce5WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE5 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · by_cases hseam4 : ρ.im ≤ (gB4Lo : ℝ)
        · exact h4 ρ hz (not_le.mp hseam3) hseam4
        · exact h5 ρ hz (not_le.mp hseam4) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN]  =>  the  on-line  census  holds  up  to  tCE5.  -/
theorem allOnLineUpToCE5 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : ce4WinClauseFull) (hW5 : ce5WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE5 : ℝ) := by
  have hband := bandOfWindows5 hW1 hW2 hW3 hW4 hW5
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fifth  run):  no  off-line
    zero  with  positive  height  above  tCE5.  -/
def terminalFaceCE5 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE5 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE4  face  implies  the  CE5  face
    (tCE5  >  tCE4).  -/
theorem faceCE4_implies_faceCE5 (q : ZeroSet)
    (hface : CE4.terminalFaceCE4 q) :
    terminalFaceCE5 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE4_lt_tCE5, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE4,  tCE5]  is  certified  empty
    (windows  4+5  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE5_iff_faceCE4 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : ce4WinClauseFull) (hW5 : ce5WinClause) :
    terminalFaceCE5 q ↔ CE4.terminalFaceCE4 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE5 : ℝ)
    · by_cases hseam : ρ.im ≤ (gB4Lo : ℝ)
      · exact hW4 ρ (hqz ρ hρ) (by linarith [ht, CE4.gB3Lo_lt_tCE4]) hseam
      · exact hW5 ρ (hqz ρ hρ) (not_le.mp hseam) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE4_implies_faceCE5 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE5  (pure
    logic).  -/
theorem rh_split_at_CE5 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE5 : ℝ) ∧ terminalFaceCE5 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE5 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE5 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN],  all-heights  RH  <->  terminalFaceCE5.
    NO  RH  CLAIM.  -/
theorem rh_reanchored_CE5 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : ce4WinClauseFull) (hW5 : ce5WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE5 q := by
  have hcensus := allOnLineUpToCE5 q hZPT2 hW1 hW2 hW3 hW4 hW5 hqz
  have hsplit := rh_split_at_CE5 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE5 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : ce4WinClauseFull) (hW5 : ce5WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE5 q) :
    RH q :=
  (rh_reanchored_CE5 q hZPT2 hW1 hW2 hW3 hW4 hW5 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE5_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE5 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE5
