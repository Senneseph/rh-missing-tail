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
import RhAttack.CE14
import RhAttack.CE15
import RhAttack.CE16
import RhAttack.CE17
import RhAttack.CE18
import RhAttack.CE19
import RhAttack.CE20
import RhAttack.CE21

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21
open scoped Topology

/-!
**CE22 — the terminal face re-anchored at the TWENTY-SECOND
certified  window  (0327,  option  B,  unit  38  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  22).  MILESTONE:  the
certified  frontier  CROSSES  the  100 000-unit  mark  above
the  Platt-Trudgian  H0  frontier  (tCE22  −  tPT2  =
102 801).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE21):
  RUN  PARAMETERS:  a  =  12 363 153 857 122  (=  CE21's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 877 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 067  evaluations  in  2486.5  s.
  CERTIFICATE  (window22_b22.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a22  <  Im  s  <=  g_b22  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a22  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 430 928.343521474804  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE21's
            recorded  g_b21  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b22  =  3 000 175 435 601.278651054984  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE22  sits  0.2787  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude;  AND  tCE22  −
               tPT2  =  102 801  >  100 000  -  the
               100 000-unit  mark  above  H0  is  CROSSED  at
               this  re-anchor).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a22,  49  right  of  g_b22  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 067  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10,  12,  13,  14,  16  and  18).
  VERIFICATION  (three  layers,  same  as  CE2-CE21):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window22_b22.json:
         "CERTIFIED:  true",  points_checked  = 33 067,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a22  ball
         is  bit-identical  to  CE21's  recorded  g_b21  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE22  =  3 000 175 435 601,
      tCE22  −  tCE21  =  4 673   (face  shrink  past  tCE21),
      tCE22  −  tPT2  = 102 801  (CROSSES  the  100 000-unit
      mark  above  the  Platt-Trudgian  H0),
      certified  zeros  over  (g_a1,  g_b22]  =  419 992  +
      20 000  =  439 992.
  HONESTY  (trust  base):  as  CE2-CE21  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE22

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b22  (the  recorded  ball  is
    3 000 175 435 601.278651054984  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~8.7e-3).  -/
def gB22Lo : ℚ := 300017543560127 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB22Lo:
    tCE22  =  3 000 175 435 601.  -/
def tCE22 : ℕ := 3000175435601

theorem tCE22_lt_gB22Lo : (tCE22 : ℝ) < (gB22Lo : ℝ) := by
  norm_num [gB22Lo, tCE22]

theorem tCE21_lt_tCE22 : (tCE21 : ℝ) < (tCE22 : ℝ) := by
  norm_num [CE21.tCE21, tCE22]

/-- Record:  the  seam  order  gB21Lo  <  tCE22  (the  band
    (gB21Lo,  tCE22]  is  nonempty  and  lies  above  CE21's
    frontier  tCE21).  -/
theorem gB21Lo_lt_tCE22 : (gB21Lo : ℝ) < (tCE22 : ℝ) := by
  norm_num [CE21.gB21Lo, tCE22]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE21.  -/
theorem faceShrinkCE22 : (tCE22 : ℝ) - (tCE21 : ℝ) = 4673 := by
  norm_num [tCE22, CE21.tCE21]

/-- MILESTONE  (machine):  the  new  frontier  is  102 801
    units  above  the  Platt-Trudgian  frontier  H0  -  the
    100 000-unit  mark  above  H0  is  CROSSED  at  this
    re-anchor  -  and  the  gap  to  the  next  round  mark
    (105 000)  is  2 199  units.  -/
theorem frontierGapAboveH0 : (tCE22 : ℝ) - WinC.tPT2 = 102801 := by
  norm_num [tCE22, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB20Lo  <  gB21Lo  (re-stated  at  the  CE22  level  from
    CE21's  window-21  band  ordering).  -/
theorem gB20Lo_lt_gB21Lo : (gB20Lo : ℝ) < (gB21Lo : ℝ) := by
  norm_num [CE20.gB20Lo, CE21.gB21Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB21Lo  <  gB22Lo)  -  the  window-22  band  (gB21Lo,
    gB22Lo]  (hence  (gB21Lo,  tCE22])  lies  strictly  above
    window  21's  certified  region.  -/
theorem gB21Lo_lt_gB22Lo : (gB21Lo : ℝ) < (gB22Lo : ℝ) := by
  norm_num [CE21.gB21Lo, gB22Lo]

/-- MILESTONE  FACT  (machine):  tCE22  −  tPT2  =  102 801
    exceeds  100 000.  -/
theorem frontierPast100k : (tCE22 : ℝ) - WinC.tPT2 > 100000 := by
  have h : (tCE22 : ℝ) - WinC.tPT2 = 102801 := frontierGapAboveH0
  linarith [h]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-21  RUN  (window21_b21.json),  FULL
    SLICE]  every  zeta  zero  with  gB20Lo  <  Im  ρ  <=
    gB21Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB20Lo,  gB21Lo]  lies  inside  (g_a21,
    g_b21]  -  window  21's  own  certified  region  -  since
    gB20Lo  is  the  certified  bottom  of  g_a21  (=  g_b20,
    bit-identical  dyadic  ball  in  windows  20  and  21)  and
    gB21Lo  the  certified  bottom  of  g_b21  (machine:
    gB20Lo  <  gB21Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce21WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB20Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB21Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-22  RUN  (window22_b22.json),  SLICE]
    every  zeta  zero  with  gB21Lo  <  Im  ρ  <=  tCE22  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB21Lo,  tCE22],  either  t0  <=  g_b21
    (the  true  Gram  point  -  g_a22  =  g_b21,  recorded  exact
    dyadic  ball  3 000 175 430 928.343521474804  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a22  =  g_a21  <  gB21Lo  <  g_b21
    puts  t0  in  window  21's  region  (g_a21,  g_b21])  -
    or  t0  >  g_b21  =  g_a22,  in  which  case  t0  <=  tCE22
    <  gB22Lo  <=  g_b22  puts  t0  in  window  22's  region
    (g_a22,  g_b22].  The  two  certified  regions  union  to
    (g_a21,  g_b22]  which  contains  (gB21Lo,  tCE22]
    (machine:  gB21Lo  <  tCE22  <  gB22Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce22WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB21Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE22 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE22]  are  on  the  line,  given  the
    twenty-two  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo  are  pure  case  splits.  -/
theorem bandOfWindows22 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : ce21WinClauseFull)
    (h22 : ce22WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE22 : ℝ) → ρ.re = 1 / 2 := by
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
                          · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
                            · exact h14 ρ hz (not_le.mp hseam13) hseam14
                            · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
                              · exact h15 ρ hz (not_le.mp hseam14) hseam15
                              · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
                                · exact h16 ρ hz (not_le.mp hseam15) hseam16
                                · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
                                  · exact h17 ρ hz (not_le.mp hseam16) hseam17
                                  · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
                                    · exact h18 ρ hz (not_le.mp hseam17) hseam18
                                    · by_cases hseam19 : ρ.im ≤ (gB19Lo : ℝ)
                                      · exact h19 ρ hz (not_le.mp hseam18) hseam19
                                      · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
                                        · exact h20 ρ hz (not_le.mp hseam19) hseam20
                                        · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
                                          · exact h21 ρ hz (not_le.mp hseam20) hseam21
                                          · exact h22 ρ hz (not_le.mp hseam21) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (and  CROSSED  100k):
    [Z-PT2]  +  the  twenty-two  cited  window  clauses  =>
    the  on-line  census  holds  up  to  tCE22.  -/
theorem allOnLineUpToCE22 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : ce21WinClauseFull) (hW22 : ce22WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE22 : ℝ) := by
  have hband := bandOfWindows22 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-second  run):  no
    off-line  zero  with  positive  height  above  tCE22.  -/
def terminalFaceCE22 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE22 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE21  face  implies  the  CE22  face
    (tCE22  >  tCE21).  -/
theorem faceCE21_implies_faceCE22 (q : ZeroSet)
    (hface : CE21.terminalFaceCE21 q) :
    terminalFaceCE22 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE21_lt_tCE22, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE21,  tCE22]  is  certified
    empty  (windows  21+22  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher  and
    PAST  the  100k  mark).  -/
theorem terminalFaceCE22_iff_faceCE21 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW21 : ce21WinClauseFull) (hW22 : ce22WinClause) :
    terminalFaceCE22 q ↔ CE21.terminalFaceCE21 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE22 : ℝ)
    · by_cases hseam21 : ρ.im ≤ (gB21Lo : ℝ)
      · exact hW21 ρ (hqz ρ hρ) (by linarith [ht, gB20Lo_lt_tCE21, tCE21_lt_tCE22]) hseam21
      · exact hW22 ρ (hqz ρ hρ) (not_le.mp hseam21) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE21_implies_faceCE22 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE22
    (pure  logic).  -/
theorem rh_split_at_CE22 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE22 : ℝ) ∧ terminalFaceCE22 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE22 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE22 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-two
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE21-WIN-FULL],  [CE22-WIN]),  all-heights  RH  <->
    terminalFaceCE22.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE22 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : ce21WinClauseFull) (hW22 : ce22WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE22 q := by
  have hcensus := allOnLineUpToCE22 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hqz
  have hsplit := rh_split_at_CE22 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER  (now
    PAST  the  100k  mark):  given  the  cited  census  inputs
    and  a  closing  of  the  re-anchored  face,  all-heights
    RH  holds.  NO  RH  CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE22 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : CE19.ce18WinClauseFull)
    (hW19 : CE20.ce19WinClauseFull) (hW20 : CE21.ce20WinClauseFull)
    (hW21 : ce21WinClauseFull) (hW22 : ce22WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE22 q) :
    RH q :=
  (rh_reanchored_CE22 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE22_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE22 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE22
