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
import RhAttack.CE22

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22
open scoped Topology

/-!
**CE23 — the terminal face re-anchored at the TWENTY-THIRD
certified  window  (0328,  option  B,  unit  39  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  23).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE22):
  RUN  PARAMETERS:  a  =  12 363 153 877 122  (=  CE22's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 897 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 898  evaluations  in  2609.4  s.
  CERTIFICATE  (window23_b23.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a23  <  Im  s  <=  g_b23  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a23  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 435 601.278651054984  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE22's
            recorded  g_b22  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b23  =  3 000 175 440 274.213780364512  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE23  sits  0.2138  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a23,  46  right  of  g_b23  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 898  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        block  [12 363 153 886 820,  .. 886 823]  rescued  to
        union  [.. 886 819,  .. 886 825],  need  6  =  found
        6,  m  =  4.  As  in  windows
        2/3/4/5/7/9/11/15/17/19/20/21,  the  rescued  zero
        was  DISPLACED  into  an  adjacent  Gram  interval;
        the  independent  verifier  recomputes  the  WINDOW
        TOTAL  (sign_changes_inside  =  20 000)  and  the  two
        end  Rosser  runs  (49  /  46)  -  the  only  quantities
        that  enter  the  Turing  step.  Recorded,  not
        suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE22):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window23_b23.json:
         "CERTIFIED:  true",  points_checked  = 33 898,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a23  ball
         is  bit-identical  to  CE22's  recorded  g_b22  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE23  =  3 000 175 440 274,
      tCE23  −  tCE22  =  4 673   (face  shrink  past  tCE22),
      tCE23  −  tPT2  = 107 474  (above  the  Platt-Trudgian
      H0;  still  past  the  100 000-unit  mark  marked  at
      CE22),
      certified  zeros  over  (g_a1,  g_b23]  =  439 992  +
      20 000  =  459 992.
  HONESTY  (trust  base):  as  CE2-CE22  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE23

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b23  (the  recorded  ball  is
    3 000 175 440 274.213780364512  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~3.8e-3).  -/
def gB23Lo : ℚ := 300017544027421 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB23Lo:
    tCE23  =  3 000 175 440 274.  -/
def tCE23 : ℕ := 3000175440274

theorem tCE23_lt_gB23Lo : (tCE23 : ℝ) < (gB23Lo : ℝ) := by
  norm_num [gB23Lo, tCE23]

theorem tCE22_lt_tCE23 : (tCE22 : ℝ) < (tCE23 : ℝ) := by
  norm_num [CE22.tCE22, tCE23]

/-- Record:  the  seam  order  gB22Lo  <  tCE23  (the  band
    (gB22Lo,  tCE23]  is  nonempty  and  lies  above  CE22's
    frontier  tCE22).  -/
theorem gB22Lo_lt_tCE23 : (gB22Lo : ℝ) < (tCE23 : ℝ) := by
  norm_num [CE22.gB22Lo, tCE23]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE22.  -/
theorem faceShrinkCE23 : (tCE23 : ℝ) - (tCE22 : ℝ) = 4673 := by
  norm_num [tCE23, CE22.tCE22]

/-- The  new  frontier  is  107 474  units  above  the
    Platt-Trudgian  frontier  H0  (machine;  the  100 000-unit
    mark  crossed  at  CE22  remains  crossed).  -/
theorem frontierGapAboveH0 : (tCE23 : ℝ) - WinC.tPT2 = 107474 := by
  norm_num [tCE23, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE23  −  tPT2  =  107 474
    exceeds  100 000.  -/
theorem frontierPast100k : (tCE23 : ℝ) - WinC.tPT2 > 100000 := by
  have h : (tCE23 : ℝ) - WinC.tPT2 = 107474 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB21Lo  <  gB22Lo  (re-stated  at  the  CE23  level  from
    CE22's  window-22  band  ordering).  -/
theorem gB21Lo_lt_gB22Lo : (gB21Lo : ℝ) < (gB22Lo : ℝ) := by
  norm_num [CE21.gB21Lo, CE22.gB22Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB22Lo  <  gB23Lo)  -  the  window-23  band  (gB22Lo,
    gB23Lo]  (hence  (gB22Lo,  tCE23])  lies  strictly  above
    window  22's  certified  region.  -/
theorem gB22Lo_lt_gB23Lo : (gB22Lo : ℝ) < (gB23Lo : ℝ) := by
  norm_num [CE22.gB22Lo, gB23Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-22  RUN  (window22_b22.json),  FULL
    SLICE]  every  zeta  zero  with  gB21Lo  <  Im  ρ  <=
    gB22Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB21Lo,  gB22Lo]  lies  inside  (g_a22,
    g_b22]  -  window  22's  own  certified  region  -  since
    gB21Lo  is  the  certified  bottom  of  g_a22  (=  g_b21,
    bit-identical  dyadic  ball  in  windows  21  and  22)  and
    gB22Lo  the  certified  bottom  of  g_b22  (machine:
    gB21Lo  <  gB22Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce22WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB21Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB22Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-23  RUN  (window23_b23.json),  SLICE]
    every  zeta  zero  with  gB22Lo  <  Im  ρ  <=  tCE23  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB22Lo,  tCE23],  either  t0  <=  g_b22
    (the  true  Gram  point  -  g_a23  =  g_b22,  recorded  exact
    dyadic  ball  3 000 175 435 601.278651054984  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a23  =  g_a22  <  gB22Lo  <  g_b22
    puts  t0  in  window  22's  region  (g_a22,  g_b22])  -
    or  t0  >  g_b22  =  g_a23,  in  which  case  t0  <=  tCE23
    <  gB23Lo  <=  g_b23  puts  t0  in  window  23's  region
    (g_a23,  g_b23].  The  two  certified  regions  union  to
    (g_a22,  g_b23]  which  contains  (gB22Lo,  tCE23]
    (machine:  gB22Lo  <  tCE23  <  gB23Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce23WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB22Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE23 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE23]  are  on  the  line,  given  the
    twenty-three  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo  are  pure  case  splits.  -/
theorem bandOfWindows23 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : CE21.ce20WinClauseFull) (h21 : CE22.ce21WinClauseFull)
    (h22 : ce22WinClauseFull) (h23 : ce23WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE23 : ℝ) → ρ.re = 1 / 2 := by
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
                                          · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
                                            · exact h22 ρ hz (not_le.mp hseam21) hseam22
                                            · exact h23 ρ hz (not_le.mp hseam22) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    twenty-three  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE23.  -/
theorem allOnLineUpToCE23 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : ce22WinClauseFull)
    (hW23 : ce23WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE23 : ℝ) := by
  have hband := bandOfWindows23 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-third  run):  no
    off-line  zero  with  positive  height  above  tCE23.  -/
def terminalFaceCE23 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE23 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE22  face  implies  the  CE23  face
    (tCE23  >  tCE22).  -/
theorem faceCE22_implies_faceCE23 (q : ZeroSet)
    (hface : CE22.terminalFaceCE22 q) :
    terminalFaceCE23 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE22_lt_tCE23, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE22,  tCE23]  is  certified
    empty  (windows  22+23  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE23_iff_faceCE22 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW22 : ce22WinClauseFull) (hW23 : ce23WinClause) :
    terminalFaceCE23 q ↔ CE22.terminalFaceCE22 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE23 : ℝ)
    · by_cases hseam22 : ρ.im ≤ (gB22Lo : ℝ)
      · exact hW22 ρ (hqz ρ hρ) (by linarith [ht, gB21Lo_lt_tCE22, tCE22_lt_tCE23]) hseam22
      · exact hW23 ρ (hqz ρ hρ) (not_le.mp hseam22) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE22_implies_faceCE23 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE23
    (pure  logic).  -/
theorem rh_split_at_CE23 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE23 : ℝ) ∧ terminalFaceCE23 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE23 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE23 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-three
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE22-WIN-FULL],  [CE23-WIN]),  all-heights  RH  <->
    terminalFaceCE23.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE23 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : ce22WinClauseFull)
    (hW23 : ce23WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE23 q := by
  have hcensus := allOnLineUpToCE23 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hqz
  have hsplit := rh_split_at_CE23 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE23 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : ce22WinClauseFull)
    (hW23 : ce23WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE23 q) :
    RH q :=
  (rh_reanchored_CE23 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE23_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE23 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE23
