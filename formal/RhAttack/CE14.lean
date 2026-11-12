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
import RhAttack.CE8
import RhAttack.CE9
import RhAttack.CE10
import RhAttack.CE11
import RhAttack.CE12
import RhAttack.CE13

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13
open scoped Topology

/-!
**CE14 — the terminal face re-anchored at the FOURTEENTH
certified  window  (0319,  option  B,  unit  30  —  lane  M5,
run  14:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  14).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE13):
  RUN  PARAMETERS:  a  =  12 363 153 697 126  (=  CE13's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 717 126
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 414  evaluations  in  2536.0  s.
  CERTIFICATE  (window14_b14.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a14  <  Im  s  <=  g_b14  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a14  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 393 545.797062116230  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE13's
            recorded  g_b13  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b14  =  3 000 175 398 218.732193861580  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE14  sits  0.7322  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a14,  44  right  of  g_b14  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 414  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  rosser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10,  12  and  13).
  VERIFICATION  (three  layers,  same  as  CE2-CE13):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window14_b14.json:
         "CERTIFIED:  true",  points_checked  = 33 414,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a14  ball
         is  bit-identical  to  CE13's  recorded  g_b13  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE14  =  3 000 175 398 218,
      tCE14  −  tCE13  =  4 673   (face  shrink  past  tCE13),
      tCE14  −  tPT2  = 65 418  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b14]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  =  279 996.
  HONESTY  (trust  base):  as  CE2-CE13  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE14

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b14  (the  recorded  ball  is
    3 000 175 398 218.732193861580  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~2.2e-3).  -/
def gB14Lo : ℚ := 300017539821873 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB14Lo:
    tCE14  =  3 000 175 398 218.  -/
def tCE14 : ℕ := 3000175398218

theorem tCE14_lt_gB14Lo : (tCE14 : ℝ) < (gB14Lo : ℝ) := by
  norm_num [gB14Lo, tCE14]

theorem tCE13_lt_tCE14 : (tCE13 : ℝ) < (tCE14 : ℝ) := by
  norm_num [CE13.tCE13, tCE14]

/-- Record:  the  seam  order  gB13Lo  <  tCE14  (the  band
    (gB13Lo,  tCE14]  is  nonempty  and  lies  above  CE13's
    frontier  tCE13).  -/
theorem gB13Lo_lt_tCE14 : (gB13Lo : ℝ) < (tCE14 : ℝ) := by
  norm_num [CE13.gB13Lo, tCE14]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE13.  -/
theorem faceShrinkCE14 : (tCE14 : ℝ) - (tCE13 : ℝ) = 4673 := by
  norm_num [tCE14, CE13.tCE13]

/-- The  new  frontier  is  65 418  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE14 : ℝ) - WinC.tPT2 = 65418 := by
  norm_num [tCE14, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB12Lo  <  gB13Lo  (re-stated  at  the  CE14  level  from
    CE13's  window-13  band  ordering).  -/
theorem gB12Lo_lt_gB13Lo : (gB12Lo : ℝ) < (gB13Lo : ℝ) := by
  norm_num [CE12.gB12Lo, CE13.gB13Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB13Lo  <  gB14Lo)  -  the  window-14  band  (gB13Lo,
    gB14Lo]  (hence  (gB13Lo,  tCE14])  lies  strictly  above
    window  13's  certified  region.  -/
theorem gB13Lo_lt_gB14Lo : (gB13Lo : ℝ) < (gB14Lo : ℝ) := by
  norm_num [CE13.gB13Lo, gB14Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-13  RUN  (window13_b13.json),  FULL
    SLICE]  every  zeta  zero  with  gB12Lo  <  Im  ρ  <=
    gB13Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB12Lo,  gB13Lo]  lies  inside  (g_a13,
    g_b13]  -  window  13's  own  certified  region  -  since
    gB12Lo  is  the  certified  bottom  of  g_a13  (=  g_b12,
    bit-identical  dyadic  ball  in  windows  12  and  13)  and
    gB13Lo  the  certified  bottom  of  g_b13  (machine:
    gB12Lo  <  gB13Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce13WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB12Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB13Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-14  RUN  (window14_b14.json),  SLICE]
    every  zeta  zero  with  gB13Lo  <  Im  ρ  <=  tCE14  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB13Lo,  tCE14],  either  t0  <=  g_b13
    (the  true  Gram  point  -  g_a14  =  g_b13,  recorded  exact
    dyadic  ball  3 000 175 393 545.797062116230  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a14  =  g_a13  <  gB13Lo  <  g_b13
    puts  t0  in  window  13's  region  (g_a13,  g_b13])  -
    or  t0  >  g_b13  =  g_a14,  in  which  case  t0  <=  tCE14
    <  gB14Lo  <=  g_b14  puts  t0  in  window  14's  region
    (g_a14,  g_b14].  The  two  certified  regions  union  to
    (g_a13,  g_b14]  which  contains  (gB13Lo,  tCE14]
    (machine:  gB13Lo  <  tCE14  <  gB14Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce14WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB13Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE14 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE14]  are  on  the  line,  given  the  fourteen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo  are  pure  case  splits.
    -/
theorem bandOfWindows14 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : ce13WinClauseFull)
    (h14 : ce14WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE14 : ℝ) → ρ.re = 1 / 2 := by
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
              · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
                · exact h8 ρ hz (not_le.mp hseam7) hseam8
                · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
                  · exact h9 ρ hz (not_le.mp hseam8) hseam9
                  · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
                    · exact h10 ρ hz (not_le.mp hseam9) hseam10
                    · by_cases hseam11 : ρ.im ≤ (gB11Lo : ℝ)
                      · exact h11 ρ hz (not_le.mp hseam10) hseam11
                      · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
                        · exact h12 ρ hz (not_le.mp hseam11) hseam12
                        · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
                          · exact h13 ρ hz (not_le.mp hseam12) hseam13
                          · exact h14 ρ hz (not_le.mp hseam13) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    fourteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE14.  -/
theorem allOnLineUpToCE14 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : ce13WinClauseFull) (hW14 : ce14WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE14 : ℝ) := by
  have hband := bandOfWindows14 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fourteenth  run):  no
    off-line  zero  with  positive  height  above  tCE14.  -/
def terminalFaceCE14 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE14 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE13  face  implies  the  CE14  face
    (tCE14  >  tCE13).  -/
theorem faceCE13_implies_faceCE14 (q : ZeroSet)
    (hface : CE13.terminalFaceCE13 q) :
    terminalFaceCE14 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE13_lt_tCE14, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE13,  tCE14]  is  certified
    empty  (windows  13+14  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE14_iff_faceCE13 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW13 : ce13WinClauseFull) (hW14 : ce14WinClause) :
    terminalFaceCE14 q ↔ CE13.terminalFaceCE13 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE14 : ℝ)
    · by_cases hseam13 : ρ.im ≤ (gB13Lo : ℝ)
      · exact hW13 ρ (hqz ρ hρ) (by linarith [ht, gB12Lo_lt_tCE13, tCE13_lt_tCE14]) hseam13
      · exact hW14 ρ (hqz ρ hρ) (not_le.mp hseam13) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE13_implies_faceCE14 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE14
    (pure  logic).  -/
theorem rh_split_at_CE14 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE14 : ℝ) ∧ terminalFaceCE14 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE14 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE14 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  fourteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE13-WIN-FULL],  [CE14-WIN]),  all-heights  RH  <->
    terminalFaceCE14.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE14 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : ce13WinClauseFull) (hW14 : ce14WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE14 q := by
  have hcensus := allOnLineUpToCE14 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hqz
  have hsplit := rh_split_at_CE14 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE14 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : ce13WinClauseFull) (hW14 : ce14WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE14 q) :
    RH q :=
  (rh_reanchored_CE14 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE14_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE14 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE14
