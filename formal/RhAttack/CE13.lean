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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12
open scoped Topology

/-!
**CE13 — the terminal face re-anchored at the THIRTEENTH
certified  window  (0318,  option  B,  unit  29  —  lane  M5,
run  13:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  13).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE12):
  RUN  PARAMETERS:  a  =  12 363 153 677 126  (=  CE12's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 697 126
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 978  evaluations  in  2613.7  s.
  CERTIFICATE  (window13_b13.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a13  <  Im  s  <=  g_b13  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a13  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 388 872.861930100227  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE12's
            recorded  g_b12  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b13  =  3 000 175 393 545.797062116230  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE13  sits  0.7971  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  44
      left  of  g_a13,  48  right  of  g_b13  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 978  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10  and  12).
  VERIFICATION  (three  layers,  same  as  CE2-CE12):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window13_b13.json:
         "CERTIFIED:  true",  points_checked  =  33 978,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a13  ball
         is  bit-identical  to  CE12's  recorded  g_b12  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE13  =  3 000 175 393 545,
      tCE13  −  tCE12  =  4 673   (face  shrink  past  tCE12),
      tCE13  −  tPT2  = 60 745  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b13]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  =  259 996.
  HONESTY  (trust  base):  as  CE2-CE12  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE13

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b13  (the  recorded  ball  is
    3 000 175 393 545.797062116230  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~7.1e-3).  -/
def gB13Lo : ℚ := 300017539354579 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB13Lo:
    tCE13  =  3 000 175 393 545.  -/
def tCE13 : ℕ := 3000175393545

theorem tCE13_lt_gB13Lo : (tCE13 : ℝ) < (gB13Lo : ℝ) := by
  norm_num [gB13Lo, tCE13]

theorem tCE12_lt_tCE13 : (tCE12 : ℝ) < (tCE13 : ℝ) := by
  norm_num [CE12.tCE12, tCE13]

/-- Record:  the  seam  order  gB12Lo  <  tCE13  (the  band
    (gB12Lo,  tCE13]  is  nonempty  and  lies  above  CE12's
    frontier  tCE12).  -/
theorem gB12Lo_lt_tCE13 : (gB12Lo : ℝ) < (tCE13 : ℝ) := by
  norm_num [CE12.gB12Lo, tCE13]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE12.  -/
theorem faceShrinkCE13 : (tCE13 : ℝ) - (tCE12 : ℝ) = 4673 := by
  norm_num [tCE13, CE12.tCE12]

/-- The  new  frontier  is  60 745  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE13 : ℝ) - WinC.tPT2 = 60745 := by
  norm_num [tCE13, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB11Lo  <  gB12Lo  (re-stated  at  the  CE13  level  from
    CE12's  window-12  band  ordering).  -/
theorem gB11Lo_lt_gB12Lo : (gB11Lo : ℝ) < (gB12Lo : ℝ) := by
  norm_num [CE11.gB11Lo, CE12.gB12Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB12Lo  <  gB13Lo)  -  the  window-13  band  (gB12Lo,
    gB13Lo]  (hence  (gB12Lo,  tCE13])  lies  strictly  above
    window  12's  certified  region.  -/
theorem gB12Lo_lt_gB13Lo : (gB12Lo : ℝ) < (gB13Lo : ℝ) := by
  norm_num [CE12.gB12Lo, gB13Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-12  RUN  (window12_b12.json),  FULL
    SLICE]  every  zeta  zero  with  gB11Lo  <  Im  ρ  <=
    gB12Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB11Lo,  gB12Lo]  lies  inside  (g_a12,
    g_b12]  -  window  12's  own  certified  region  -  since
    gB11Lo  is  the  certified  bottom  of  g_a12  (=  g_b11,
    bit-identical  dyadic  ball  in  windows  11  and  12)  and
    gB12Lo  the  certified  bottom  of  g_b12  (machine:
    gB11Lo  <  gB12Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce12WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB11Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB12Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-13  RUN  (window13_b13.json),  SLICE]
    every  zeta  zero  with  gB12Lo  <  Im  ρ  <=  tCE13  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB12Lo,  tCE13],  either  t0  <=  g_b12
    (the  true  Gram  point  -  g_a13  =  g_b12,  recorded  exact
    dyadic  ball  3 000 175 388 872.861930100227  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a13  =  g_a12  <  gB12Lo  <  g_b12
    puts  t0  in  window  12's  region  (g_a12,  g_b12])  -
    or  t0  >  g_b12  =  g_a13,  in  which  case  t0  <=  tCE13
    <  gB13Lo  <=  g_b13  puts  t0  in  window  13's  region
    (g_a13,  g_b13].  The  two  certified  regions  union  to
    (g_a12,  g_b13]  which  contains  (gB12Lo,  tCE13]
    (machine:  gB12Lo  <  tCE13  <  gB13Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce13WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB12Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE13 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE13]  are  on  the  line,  given  the  thirteen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo  are  pure  case  splits.  -/
theorem bandOfWindows13 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : ce12WinClauseFull) (h13 : ce13WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE13 : ℝ) → ρ.re = 1 / 2 := by
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
                        · exact h13 ρ hz (not_le.mp hseam12) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    thirteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE13.  -/
theorem allOnLineUpToCE13 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : ce12WinClauseFull)
    (hW13 : ce13WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE13 : ℝ) := by
  have hband := bandOfWindows13 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (thirteenth  run):  no
    off-line  zero  with  positive  height  above  tCE13.  -/
def terminalFaceCE13 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE13 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE12  face  implies  the  CE13  face
    (tCE13  >  tCE12).  -/
theorem faceCE12_implies_faceCE13 (q : ZeroSet)
    (hface : CE12.terminalFaceCE12 q) :
    terminalFaceCE13 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE12_lt_tCE13, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE12,  tCE13]  is  certified
    empty  (windows  12+13  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE13_iff_faceCE12 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW12 : ce12WinClauseFull) (hW13 : ce13WinClause) :
    terminalFaceCE13 q ↔ CE12.terminalFaceCE12 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE13 : ℝ)
    · by_cases hseam12 : ρ.im ≤ (gB12Lo : ℝ)
      · exact hW12 ρ (hqz ρ hρ) (by linarith [ht, gB11Lo_lt_tCE12, tCE12_lt_tCE13]) hseam12
      · exact hW13 ρ (hqz ρ hρ) (not_le.mp hseam12) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE12_implies_faceCE13 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE13
    (pure  logic).  -/
theorem rh_split_at_CE13 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE13 : ℝ) ∧ terminalFaceCE13 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE13 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE13 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  thirteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE12-WIN-FULL],  [CE13-WIN]),  all-heights  RH  <->
    terminalFaceCE13.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE13 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : ce12WinClauseFull)
    (hW13 : ce13WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE13 q := by
  have hcensus := allOnLineUpToCE13 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hqz
  have hsplit := rh_split_at_CE13 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE13 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : ce12WinClauseFull)
    (hW13 : ce13WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE13 q) :
    RH q :=
  (rh_reanchored_CE13 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE13_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE13 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE13
