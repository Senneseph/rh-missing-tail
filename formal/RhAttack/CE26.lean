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
import RhAttack.CE23
import RhAttack.CE24
import RhAttack.CE25

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25
open scoped Topology

/-!
**CE26 — the terminal face re-anchored at the TWENTY-SIXTH
certified  window  (0331,  option  B,  unit  42  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  26).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE25):
  RUN  PARAMETERS:  a  =  12 363 153 937 122  (=  CE25's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 957 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 675  evaluations  in  2565.8  s.
  CERTIFICATE  (window26_b26.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a26  <  Im  s  <=  g_b26  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a26  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 449 620.084038171608  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE25's
            recorded  g_b25  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b26  =  3 000 175 454 293.019166669177  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE26  sits  0.0192  above  the  previous
               integer  -  the  NEXT-CLOSEST  frac  after
               window  25's  0.0840  and  above  the  0.01
               CASING  threshold  of  CE18/0330,  so  the
               two-decimal  lower  bound  0.01  is  strictly
               below  with  margin  9.17e-3  —  far  above
               the  certified  radius  of  1.29e-26  by  21
               orders  of  magnitude  —  and  the  standard
               two-decimal  bound  is  ADEQUATE  (no  3-
               decimal  CASING  needed);  if  a  future  g_bN
               lands  with  frac  <  0.01  the  CE18  rule
               applies  and  a  3-decimal  bound  must  be
               used).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a26,  45  right  of  g_b26  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 675  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        block  [12 363 153 947 212,  .. 947 214]  rescued  to
        union  [.. 947 211,  .. 947 216],  need  5  =  found
        5,  m  =  4.  As  in  the  other  rescued  windows,
        the  rescued  zero  was  DISPLACED  into  an  adjacent
        Gram  interval;  the  independent  verifier
        recomputes  the  WINDOW  TOTAL  (sign_changes_inside
        =  20 000)  and  the  two  end  Rosser  runs  (50  /
        45)  -  the  only  quantities  that  enter  the
        Turing  step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE25):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window26_b26.json:
         "CERTIFIED:  true",  points_checked  = 33 675,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a26  ball
         is  bit-identical  to  CE25's  recorded  g_b25  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE26  =  3 000 175 454 293,
      tCE26  −  tCE25  =  4 673   (face  shrink  past
      tCE25),
      tCE26  −  tPT2  = 121 493  (above  the  Platt-Trudgian
      H0;  the  100 000-unit  mark  marked  at  CE22  remains
      crossed;  the  125 000-unit  mark  is  3 507  units
      OUT  -  one  more  window),
      certified  zeros  over  (g_a1,  g_b26]  =  499 992  +
      20 000  =  519 992.
  HONESTY  (trust  base):  as  CE2-CE25  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE26

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b26  (the  recorded  ball  is
    3 000 175 454 293.019166669177  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  9.17e-3  -  frac  0.0192  is  above
    the  0.01  CASING  threshold,  so  the  two-decimal  bound
    is  adequate  and  strictly  below  the  certified  value
    -  see  the  CASING  note  in  the  file  header).  -/
def gB26Lo : ℚ := 300017545429301 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB26Lo:
    tCE26  =  3 000 175 454 293.  -/
def tCE26 : ℕ := 3000175454293

theorem tCE26_lt_gB26Lo : (tCE26 : ℝ) < (gB26Lo : ℝ) := by
  norm_num [gB26Lo, tCE26]

theorem tCE25_lt_tCE26 : (tCE25 : ℝ) < (tCE26 : ℝ) := by
  norm_num [CE25.tCE25, tCE26]

/-- Record:  the  seam  order  gB25Lo  <  tCE26  (the  band
    (gB25Lo,  tCE26]  is  nonempty  and  lies  above  CE25's
    frontier  tCE25).  -/
theorem gB25Lo_lt_tCE26 : (gB25Lo : ℝ) < (tCE26 : ℝ) := by
  norm_num [CE25.gB25Lo, tCE26]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE25.  -/
theorem faceShrinkCE26 : (tCE26 : ℝ) - (tCE25 : ℝ) = 4673 := by
  norm_num [tCE26, CE25.tCE25]

/-- The  new  frontier  is  121 493  units  above  the
    Platt-Trudgian  frontier  H0  (machine;  the  100 000-unit
    mark  crossed  at  CE22  remains  crossed;  the  next
    round  mark  125 000  is  3 507  units  OUT).  -/
theorem frontierGapAboveH0 : (tCE26 : ℝ) - WinC.tPT2 = 121493 := by
  norm_num [tCE26, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE26  −  tPT2  =  121 493
    exceeds  100 000.  -/
theorem frontierPast100k : (tCE26 : ℝ) - WinC.tPT2 > 100000 := by
  have h : (tCE26 : ℝ) - WinC.tPT2 = 121493 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB24Lo  <  gB25Lo  (re-stated  at  the  CE26  level  from
    CE25's  window-25  band  ordering).  -/
theorem gB24Lo_lt_gB25Lo : (gB24Lo : ℝ) < (gB25Lo : ℝ) := by
  norm_num [CE24.gB24Lo, CE25.gB25Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB25Lo  <  gB26Lo)  -  the  window-26  band  (gB25Lo,
    gB26Lo]  (hence  (gB25Lo,  tCE26])  lies  strictly  above
    window  25's  certified  region.  -/
theorem gB25Lo_lt_gB26Lo : (gB25Lo : ℝ) < (gB26Lo : ℝ) := by
  norm_num [CE25.gB25Lo, gB26Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-25  RUN  (window25_b25.json),  FULL
    SLICE]  every  zeta  zero  with  gB24Lo  <  Im  ρ  <=
    gB25Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB24Lo,  gB25Lo]  lies  inside  (g_a25,
    g_b25]  -  window  25's  own  certified  region  -  since
    gB24Lo  is  the  certified  bottom  of  g_a25  (=  g_b24,
    bit-identical  dyadic  ball  in  windows  24  and  25)  and
    gB25Lo  the  certified  bottom  of  g_b25  (machine:
    gB24Lo  <  gB25Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce25WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB24Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB25Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-26  RUN  (window26_b26.json),  SLICE]
    every  zeta  zero  with  gB25Lo  <  Im  ρ  <=  tCE26  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB25Lo,  tCE26],  either  t0  <=  g_b25
    (the  true  Gram  point  -  g_a26  =  g_b25,  recorded  exact
    dyadic  ball  3 000 175 449 620.084038171608  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a26  =  g_a25  <  gB25Lo  <  g_b25
    puts  t0  in  window  25's  region  (g_a25,  g_b25])  -
    or  t0  >  g_b25  =  g_a26,  in  which  case  t0  <=  tCE26
    <  gB26Lo  <=  g_b26  puts  t0  in  window  26's  region
    (g_a26,  g_b26].  The  two  certified  regions  union  to
    (g_a25,  g_b26]  which  contains  (gB25Lo,  tCE26]
    (machine:  gB25Lo  <  tCE26  <  gB26Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce26WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB25Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE26 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE26]  are  on  the  line,  given  the
    twenty-six  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo,  gB23Lo,  gB24Lo,  gB25Lo  are  pure
    case  splits.  -/
theorem bandOfWindows26 (h1 : CE2.ce1WinClause)
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
    (h22 : CE23.ce22WinClauseFull) (h23 : CE24.ce23WinClauseFull)
    (h24 : CE25.ce24WinClauseFull) (h25 : ce25WinClauseFull)
    (h26 : ce26WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE26 : ℝ) → ρ.re = 1 / 2 := by
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
                                            · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
                                              · exact h23 ρ hz (not_le.mp hseam22) hseam23
                                              · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
                                                · exact h24 ρ hz (not_le.mp hseam23) hseam24
                                                · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
                                                  · exact h25 ρ hz (not_le.mp hseam24) hseam25
                                                  · exact h26 ρ hz (not_le.mp hseam25) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    twenty-six  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE26.  -/
theorem allOnLineUpToCE26 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : ce25WinClauseFull) (hW26 : ce26WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE26 : ℝ) := by
  have hband := bandOfWindows26 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-sixth  run):  no
    off-line  zero  with  positive  height  above  tCE26.  -/
def terminalFaceCE26 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE26 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE25  face  implies  the  CE26  face
    (tCE26  >  tCE25).  -/
theorem faceCE25_implies_faceCE26 (q : ZeroSet)
    (hface : CE25.terminalFaceCE25 q) :
    terminalFaceCE26 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE25_lt_tCE26, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE25,  tCE26]  is  certified
    empty  (windows  25+26  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE26_iff_faceCE25 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW25 : ce25WinClauseFull) (hW26 : ce26WinClause) :
    terminalFaceCE26 q ↔ CE25.terminalFaceCE25 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE26 : ℝ)
    · by_cases hseam25 : ρ.im ≤ (gB25Lo : ℝ)
      · exact hW25 ρ (hqz ρ hρ) (by linarith [ht, gB24Lo_lt_tCE25, tCE25_lt_tCE26]) hseam25
      · exact hW26 ρ (hqz ρ hρ) (not_le.mp hseam25) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE25_implies_faceCE26 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE26
    (pure  logic).  -/
theorem rh_split_at_CE26 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE26 : ℝ) ∧ terminalFaceCE26 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE26 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE26 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-six
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE25-WIN-FULL],  [CE26-WIN]),  all-heights  RH  <->
    terminalFaceCE26.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE26 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : ce25WinClauseFull) (hW26 : ce26WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE26 q := by
  have hcensus := allOnLineUpToCE26 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hqz
  have hsplit := rh_split_at_CE26 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE26 (q : ZeroSet)
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
    (hW21 : CE22.ce21WinClauseFull) (hW22 : CE23.ce22WinClauseFull)
    (hW23 : CE24.ce23WinClauseFull) (hW24 : CE25.ce24WinClauseFull)
    (hW25 : ce25WinClauseFull) (hW26 : ce26WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE26 q) :
    RH q :=
  (rh_reanchored_CE26 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE26_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE26 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE26
