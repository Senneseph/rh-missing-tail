import Mathlib
import RhAttack.B0
import RhAttack.P12Uniform
import RhAttack.WinCount
import RhAttack.RHEnd
import RhAttack.ThetaInf
import RhAttack.CE1
import RhAttack.CE2
import RhAttack.CE3

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3
open scoped Topology

/-!
**CE4 — the terminal face re-anchored at the FOURTH certified window
(0306, option B, unit 18 — lane M5, run 4:  OUR OWN production,
continuing the seamless chain:  windows 1 -> 2 -> 3 -> 4).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1/CE2/CE3):
  RUN  PARAMETERS:  a  =  12 363 153 497 128  (=  CE3's  final  b;
  seamless,  no  snap  this  time),  b_requested  =  a  +  20 000
  =  12 363 153 517 128  =  b  (b  was  already  a  good  Gram
  point  -  NO  snap-down),  M  =  60,  C_R  =  1,  28  workers.
  CERTIFICATE  (window4_b4.json):  the  b  −  a  =  20 000  zeros
  of  ζ  with  g_a4  <  Im  s  <=  g_b4  are  ALL  SIMPLE  and  on
  the  line,  where
      g_a4  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 346 816.913023290278...
                 + or -  16 777 217 · 2^-110  ~=  1.15e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE3's
            recorded  g_b3  (verified:  same  mantissa/exponent/
            radius  tuple  -  the  seam  is  seamless  by
            construction,  a4  =  b3);
      g_b4  =  3 000 175 351 489.848157742130...  + or -
            1.29e-26  (exact  dyadic  decode;  the  fractional
            part  0.848...  is  at  distance  0.1518  from  the
            next  integer  -  the  floor  is  robust  to  the
            radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a4,  46  right  of  g_b4  (both  >=  K  =  12);
      0  cross-check  failures  (all  34 275  records);  0
      undetermined  Gram  signs;  ONE  internal  Rosser-block
      quota  exception  (block  g-indices  12 363 153 498 083 -
      12 363 153 498 085,  below  its  quota)  RESCUED  by  the
      pipeline's  documented  3-block  union  refinement  (union
      12 363 153 498 082 - 12 363 153 498 086  recounted  at  8
      subdivisions:  need  4,  found  4)  -  a  zero  displaced
      into  an  adjacent  Gram  interval;  SOUND  because  (as
      the  pipeline  states)  only  the  window  TOTAL  and  the
      two  end  Rosser  RUNS  enter  the  Turing  step:  the
      independent  verifier  recomputes  sign_changes_inside
      =  20 000  =  b  −  a  and  the  runs  49  /  46.
  VERIFICATION  (three  layers,  same  as  CE2/CE3):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window4_b4.json:
         "CERTIFIED:  true",  points_checked  =  34 275,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  1  (the  rescued  block  -
         see  above;  the  total  and  the  runs  are  what
         Turing  uses,  both  independently  verified),
         turing_ok  =  true,  K_conservative  =  12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a4  ball
         is  bit-identical  to  CE3's  recorded  g_b3  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE4  =  3 000 175 351 489,
      tCE4  −  tCE3  =  4 673   (face  shrink  past  tCE3),
      tCE4  −  tPT2  =  18 689  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b4]  =  20 000  +
      19 999  +  19 999  +  20 000  =  79 998.
  HONESTY  (trust  base):  as  CE2/CE3  -  the  pipeline's  own
  controls,  its  kernel-checked  Lean  remainder  theorem,  and
  our  three  verification  layers;  a  RE-RUN  of  a  third-party
  pipeline,  not  a  from-scratch  independent  certification.
  NO  RH  CLAIM.  -/

namespace CE4

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b4  (the  recorded  ball  is
    3 000 175 351 489.848157742130...  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 8e-3).  -/
def gB4Lo : ℚ := 300017535148984 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB4Lo:
    tCE4  =  3 000 175 351 489.  -/
def tCE4 : ℕ := 3000175351489

theorem tCE4_lt_gB4Lo : (tCE4 : ℝ) < (gB4Lo : ℝ) := by
  norm_num [gB4Lo, tCE4]

theorem tCE3_lt_tCE4 : (tCE3 : ℝ) < (tCE4 : ℝ) := by
  norm_num [CE3.tCE3, tCE4]

/-- Record:  the  seam  order  gB3Lo  <  tCE4  (the  band
    (gB3Lo,  tCE4]  is  nonempty  and  lies  above  CE3's
    frontier  tCE3).  -/
theorem gB3Lo_lt_tCE4 : (gB3Lo : ℝ) < (tCE4 : ℝ) := by
  norm_num [CE3.gB3Lo, tCE4]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE3.  -/
theorem faceShrinkCE4 : (tCE4 : ℝ) - (CE3.tCE3 : ℝ) = 4673 := by
  norm_num [tCE4, CE3.tCE3]

/-- The  new  frontier  is  18 689  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE4 : ℝ) - WinC.tPT2 = 18689 := by
  norm_num [tCE4, WinC.tPT2]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB3Lo  <  gB4Lo)  -  the  window-4  band  (gB3Lo,  gB4Lo]
    (hence  (gB3Lo,  tCE4])  lies  strictly  above  window  3's
    certified  region.  -/
theorem gB3Lo_lt_gB4Lo : (gB3Lo : ℝ) < (gB4Lo : ℝ) := by
  norm_num [CE3.gB3Lo, gB4Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-3  RUN  (window3_b3.json),  FULL  SLICE]
    every  zeta  zero  with  gB2Lo  <  Im  ρ  <=  gB3Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB2Lo,  gB3Lo]  lies  inside  (g_a3,  g_b3]  -  window  3's
    own  certified  region  -  since  gB2Lo  is  the  certified
    bottom  of  g_a3  (=  g_b2)  and  gB3Lo  the  certified
    bottom  of  g_b3,  with  gB2Lo  <  gB3Lo  (machine,
    CE3-independent,  below).  This  is  the  FULL  version  of
    CE3.ce3WinClause  (which  is  the  (gB2Lo,  tCE3]  slice  of
    the  same  region).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce3WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB2Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB3Lo : ℝ) → ρ.re = 1 / 2

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB2Lo  <  gB3Lo.  -/
theorem gB2Lo_lt_gB3Lo : (gB2Lo : ℝ) < (gB3Lo : ℝ) := by
  norm_num [gB2Lo, CE3.gB3Lo]

/-- [CITED,  OUR  WINDOW-4  RUN  (window4_b4.json),  SLICE]
    every  zeta  zero  with  gB3Lo  <  Im  ρ  <=  tCE4  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB3Lo,  tCE4],  either  t0  <=  g_b3
    (the  true  Gram  point  -  g_a4  =  g_b3,  recorded  exact
    dyadic  ball  3 000 175 346 816.913023290278...  + or -
    1.15e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a4  =  g_a3  <  gB3Lo  <  g_b3  puts
    t0  in  window  3's  region  (g_a3,  g_b3])  -  or  t0  >  g_b3  =  g_a4,
    in  which  case  t0  <=  tCE4  <  gB4Lo  <=  g_b4  puts
    t0  in  window  4's  region  (g_a4,  g_b4].  The  two
    certified  regions  union  to  (g_a3,  g_b4]  which
    contains  (gB3Lo,  tCE4]  (machine:  gB3Lo  <  tCE4  <
    gB4Lo).  Named  Prop  consumed  as  a  hypothesis;
    not  proven  in-tree.  -/
def ce4WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB3Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE4 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE4]  are  on  the  line,  given  the  four  window
    clauses  -  the  splits  at  gA2Hi,  gB2Lo,  gB3Lo  are  pure
    case  splits.  -/
theorem bandOfWindows4 (h1 : CE2.ce1WinClause) (h2 : CE3.ce2WinClauseFull)
    (h3 : ce3WinClauseFull) (h4 : ce4WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE4 : ℝ) → ρ.re = 1 / 2 := by
  intro ρ hz ht htH
  by_cases hseam1 : ρ.im ≤ (gA2Hi : ℝ)
  · exact h1 ρ hz ht hseam1
  · by_cases hseam2 : ρ.im ≤ (gB2Lo : ℝ)
    · exact h2 ρ hz (not_le.mp hseam1) hseam2
    · by_cases hseam3 : ρ.im ≤ (gB3Lo : ℝ)
      · exact h3 ρ hz (not_le.mp hseam2) hseam3
      · exact h4 ρ hz (not_le.mp hseam3) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN]  =>  the
    on-line  census  holds  up  to  tCE4.  -/
theorem allOnLineUpToCE4 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : ce3WinClauseFull) (hW4 : ce4WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE4 : ℝ) := by
  have hband := bandOfWindows4 hW1 hW2 hW3 hW4
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fourth  run):  no  off-line
    zero  with  positive  height  above  tCE4.  -/
def terminalFaceCE4 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE4 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE3  face  implies  the  CE4  face
    (tCE4  >  tCE3).  -/
theorem faceCE3_implies_faceCE4 (q : ZeroSet)
    (hface : CE3.terminalFaceCE3 q) :
    terminalFaceCE4 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE3_lt_tCE4, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE3,  tCE4]  is  certified  empty
    (windows  3+4  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE4_iff_faceCE3 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : ce3WinClauseFull) (hW4 : ce4WinClause) :
    terminalFaceCE4 q ↔ CE3.terminalFaceCE3 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE4 : ℝ)
    · by_cases hseam : ρ.im ≤ (gB3Lo : ℝ)
      · exact hW3 ρ (hqz ρ hρ) (by linarith [ht, CE3.gB2Lo_lt_tCE3]) hseam
      · exact hW4 ρ (hqz ρ hρ) (not_le.mp hseam) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE3_implies_faceCE4 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE4  (pure
    logic).  -/
theorem rh_split_at_CE4 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE4 : ℝ) ∧ terminalFaceCE4 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE4 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE4 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN],
    all-heights  RH  <->  terminalFaceCE4.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE4 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : ce3WinClauseFull) (hW4 : ce4WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE4 q := by
  have hcensus := allOnLineUpToCE4 q hZPT2 hW1 hW2 hW3 hW4 hqz
  have hsplit := rh_split_at_CE4 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE4 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : ce3WinClauseFull) (hW4 : ce4WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE4 q) :
    RH q :=
  (rh_reanchored_CE4 q hZPT2 hW1 hW2 hW3 hW4 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE4_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE4 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE4
