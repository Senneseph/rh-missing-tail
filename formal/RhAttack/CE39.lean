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
import RhAttack.CE26
import RhAttack.CE27
import RhAttack.CE28
import RhAttack.CE29
import RhAttack.CE30
import RhAttack.CE31
import RhAttack.CE32
import RhAttack.CE33
import RhAttack.CE34
import RhAttack.CE35
import RhAttack.CE36
import RhAttack.CE37
import RhAttack.CE38

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38
open scoped Topology

/-!
**CE39 — the terminal face re-anchored at the THIRTY-NINTH
certified  window  (0344,  option  B,  unit  55  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  -> 39).  The  200k  mark  is  now
17 760  units  ahead  (~4  windows  out).  Face  shrink  is
the  4 672  variant  this  window  (the  running  pattern
allows  both  4 672  and  4 673).  -/

/- (provenance  in  the  next  comment  block  so  this
   header  stays  readable)  -/
/- PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE38):
  RUN  PARAMETERS:  a  =  12 363 154 197 121  (=  CE38's
  final  b;  seamless),  b  =  a  +  20 000  =  12 363 154
  217 121  (b  was  already  a  good  Gram  point  -  NO
  snap  at  either  endpoint),  M  = 60,  C_R  = 1,  28
  workers,  34 456  evaluations  in  2726.6  s.
  CERTIFICATE  (window39_b39.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a39  <  Im  s  <=  g_b39  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a39  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 510 368.007040772818  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE38's
            recorded  g_b38  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b39  =  3 000 175 515 040.942165751912  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE39  sits  0.9422  above  the  previous
               integer,  robust  to  the  radius  of 1.29e-26
               by  many  orders  of  magnitude;  the  standard
               two-decimal  lower  bound  gB39Lo  has  a
               margin  of  ~0.94;  the  two-decimal  round-down
               does  not  equal  the  floor,  so  no  CASING
               is  needed).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a39,  47  right  of  g_b39  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 456  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  ONE  -  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        1. block  [12 363 154 206 334,  .. 206 336]  rescued
           to  union  [.. 206 333,  .. 206 337],  need  4  =
           found  4,  m  =  4.
      The  quota  was  met  by  the  union  recount,  and  the
      rescued  zero  was  DISPLACED  into  an  adjacent  Gram
      interval  within  the  same  window,  so  the  window
      total  is  unchanged.  The  independent  verifier
      recomputes  the  WINDOW  TOTAL  (sign_changes_inside  =
      20 000)  and  the  two  end  Rosser  runs  (50  /  47)
      -  the  only  quantities  that  enter  the  Turing  step.
      Reconciled  and  recorded.
  VERIFICATION  (three  layers,  same  as  CE2-CE38):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window39_b39.json:
         "CERTIFIED:  true",  points_checked  = 34 456,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  = 1  (rescued,  quota  met),
         turing_ok  =  true,  K_conservative  = 12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a39
         ball  is  bit-identical  to  CE38's  recorded  g_b38
         ball  (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE39  =  3 000 175 515 040,
      tCE39  −  tCE38  =  4 672   (face  shrink  past
      tCE38  -  the  4 672  variant  of  the  running  pattern;
      the  running  pattern  allows  both  4 672  and  4 673,
      reflecting  the  floor  arithmetic  of  successive  Gram
      points  whose  fracs  vary),
      tCE39  −  tPT2  = 182 240  (above  the  Platt-Trudgian
      H0;  round  marks  100 000  (CE22),  125 000  (CE27),
      150 000  (CE33)  and  175 000  (CE38)  all  crossed;
      the  NEXT  ROUND  MARK  200 000  SITS  17 760  UNITS
      AHEAD,  about  4  windows  out),
      certified  zeros  over  (g_a1,  g_b39]  =  759 991  +
      20 000  =  779 991.
  HONESTY  (trust  base):  as  CE2-CE38  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE39

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b39  (the  recorded  ball  is
    3 000 175 515 040.942165751912  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~0.94).  -/
def gB39Lo : ℚ := 300017551504094 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB39Lo:
    tCE39  =  3 000 175 515 040.  -/
def tCE39 : ℕ := 3000175515040

theorem tCE39_lt_gB39Lo : (tCE39 : ℝ) < (gB39Lo : ℝ) := by
  norm_num [gB39Lo, tCE39]

theorem tCE38_lt_tCE39 : (tCE38 : ℝ) < (tCE39 : ℝ) := by
  norm_num [CE38.tCE38, tCE39]

/-- Record:  the  seam  order  gB38Lo  <  tCE39  (the  band
    (gB38Lo,  tCE39]  is  nonempty  and  lies  above  CE38's
    frontier  tCE38).  -/
theorem gB38Lo_lt_tCE39 : (gB38Lo : ℝ) < (tCE39 : ℝ) := by
  norm_num [CE38.gB38Lo, tCE39]

/-- The  face  height  shrunk  by  4 672  units  past  tCE38
    (the  4 672  variant  of  the  running  pattern).  -/
theorem faceShrinkCE39 : (tCE39 : ℝ) - (tCE38 : ℝ) = 4672 := by
  norm_num [tCE39, CE38.tCE38]

/-- THE  GAP  TO  THE  NEXT  ROUND  MARK  (machine):  the  new
    frontier  is  182 240  units  above  the  Platt-Trudgian
    frontier  H0  (round  marks  100 000  (CE22),  125 000
    (CE27),  150 000  (CE33)  and  175 000  (CE38)  all
    crossed;  the  NEXT  ROUND  MARK  200 000  SITS  17 760
    UNITS  AHEAD,  about  4  windows  out).  -/
theorem frontierGapAboveH0 : (tCE39 : ℝ) - WinC.tPT2 = 182240 := by
  norm_num [tCE39, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE39  −  tPT2  =  182 240
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE39 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE39 : ℝ) - WinC.tPT2 = 182240 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB37Lo  <  gB38Lo  (re-stated  at  the  CE39  level  from
    CE38's  window-38  band  ordering).  -/
theorem gB37Lo_lt_gB38Lo : (gB37Lo : ℝ) < (gB38Lo : ℝ) := by
  norm_num [CE37.gB37Lo, CE38.gB38Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB38Lo  <  gB39Lo)  -  the  window-39  band  (gB38Lo,
    gB39Lo]  (hence  (gB38Lo,  tCE39])  lies  strictly  above
    window  38's  certified  region.  -/
theorem gB38Lo_lt_gB39Lo : (gB38Lo : ℝ) < (gB39Lo : ℝ) := by
  norm_num [CE38.gB38Lo, gB39Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-38  RUN  (window38_b38.json),  FULL
    SLICE]  every  zeta  zero  with  gB37Lo  <  Im  ρ  <=
    gB38Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB37Lo,  gB38Lo]  lies  inside  (g_a38,
    g_b38]  -  window  38's  own  certified  region  -  since
    gB37Lo  is  the  certified  bottom  of  g_a38  (=  g_b37,
    bit-identical  dyadic  ball  in  windows  37  and  38)
    and  gB38Lo  the  certified  bottom  of  g_b38
    (machine:  gB37Lo  <  gB38Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce38WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB37Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB38Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-39  RUN  (window39_b39.json),  SLICE]
    every  zeta  zero  with  gB38Lo  <  Im  ρ  <=  tCE39  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB38Lo,  tCE39],  either  t0  <=  g_b38
    (the  true  Gram  point  -  g_a39  =  g_b38,  recorded  exact
    dyadic  ball  3 000 175 510 368.007040772818  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a39  =  g_a38  <  gB38Lo  <  g_b38
    puts  t0  in  window  38's  region  (g_a38,  g_b38])  -
    or  t0  >  g_b38  =  g_a39,  in  which  case  t0  <=  tCE39
    <  gB39Lo  <=  g_b39  puts  t0  in  window  39's  region
    (g_a39,  g_b39].  The  two  certified  regions  union  to
    (g_a38,  g_b39]  which  contains  (gB38Lo,  tCE39]
    (machine:  gB38Lo  <  tCE39  <  gB39Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce39WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB38Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE39 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE39]  are  on  the  line,  given  the
    thirty-nine  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  ...,  gB37Lo,  gB38Lo  are  pure  case  splits.  -/
theorem bandOfWindows39 (h1 : CE2.ce1WinClause)
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
    (h24 : CE25.ce24WinClauseFull) (h25 : CE26.ce25WinClauseFull)
    (h26 : CE27.ce26WinClauseFull) (h27 : CE28.ce27WinClauseFull)
    (h28 : CE29.ce28WinClauseFull) (h29 : CE30.ce29WinClauseFull)
    (h30 : CE31.ce30WinClauseFull)
    (h31 : CE32.ce31WinClauseFull)
    (h32 : CE33.ce32WinClauseFull)
    (h33 : CE34.ce33WinClauseFull)
    (h34 : CE35.ce34WinClauseFull)
    (h35 : CE36.ce35WinClauseFull)
    (h36 : CE37.ce36WinClauseFull)
    (h37 : CE38.ce37WinClauseFull)
    (h38 : ce38WinClauseFull) (h39 : ce39WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE39 : ℝ) → ρ.re = 1 / 2 := by
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
                                                  · by_cases hseam26 : ρ.im ≤ (gB26Lo : ℝ)
                                                    · exact h26 ρ hz (not_le.mp hseam25) hseam26
                                                    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
                                                      · exact h27 ρ hz (not_le.mp hseam26) hseam27
                                                      · by_cases hseam28 : ρ.im ≤ (gB28Lo : ℝ)
                                                        · exact h28 ρ hz (not_le.mp hseam27) hseam28
                                                        · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
                                                          · exact h29 ρ hz (not_le.mp hseam28) hseam29
                                                          · by_cases hseam30 : ρ.im ≤ (gB30Lo : ℝ)
                                                            · exact h30 ρ hz (not_le.mp hseam29) hseam30
                                                            · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
                                                              · exact h31 ρ hz (not_le.mp hseam30) hseam31
                                                              · by_cases hseam32 : ρ.im ≤ (gB32Lo : ℝ)
                                                                · exact h32 ρ hz (not_le.mp hseam31) hseam32
                                                                · by_cases hseam33 : ρ.im ≤ (gB33Lo : ℝ)
                                                                  · exact h33 ρ hz (not_le.mp hseam32) hseam33
                                                                  · by_cases hseam34 : ρ.im ≤ (gB34Lo : ℝ)
                                                                    · exact h34 ρ hz (not_le.mp hseam33) hseam34
                                                                    · by_cases hseam35 : ρ.im ≤ (gB35Lo : ℝ)
                                                                      · exact h35 ρ hz (not_le.mp hseam34) hseam35
                                                                      · by_cases hseam36 : ρ.im ≤ (gB36Lo : ℝ)
                                                                        · exact h36 ρ hz (not_le.mp hseam35) hseam36
                                                                        · by_cases hseam37 : ρ.im ≤ (gB37Lo : ℝ)
                                                                          · exact h37 ρ hz (not_le.mp hseam36) hseam37
                                                                          · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
                                                                            · exact h38 ρ hz (not_le.mp hseam37) hseam38
                                                                            · exact h39 ρ hz (not_le.mp hseam38) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (thirty-ninth  run):
    [Z-PT2]  +  the  thirty-nine  cited  window  clauses  =>
    the  on-line  census  holds  up  to  tCE39.  -/
theorem allOnLineUpToCE39 (q : ZeroSet)
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
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : ce38WinClauseFull) (hW39 : ce39WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE39 : ℝ) := by
  have hband := bandOfWindows39 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (thirty-ninth  run):  no
    off-line  zero  with  positive  height  above  tCE39.  -/
def terminalFaceCE39 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE39 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE38  face  implies  the  CE39  face
    (tCE39  >  tCE38).  -/
theorem faceCE38_implies_faceCE39 (q : ZeroSet)
    (hface : CE38.terminalFaceCE38 q) :
    terminalFaceCE39 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE38_lt_tCE39, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE38,  tCE39]  is  certified
    empty  (windows  38+39  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 672  higher).  -/
theorem terminalFaceCE39_iff_faceCE38 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW38 : ce38WinClauseFull) (hW39 : ce39WinClause) :
    terminalFaceCE39 q ↔ CE38.terminalFaceCE38 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE39 : ℝ)
    · by_cases hseam38 : ρ.im ≤ (gB38Lo : ℝ)
      · exact hW38 ρ (hqz ρ hρ) (by linarith [ht, gB37Lo_lt_tCE38, tCE38_lt_tCE39]) hseam38
      · exact hW39 ρ (hqz ρ hρ) (not_le.mp hseam38) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE38_implies_faceCE39 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE39
    (pure  logic).  -/
theorem rh_split_at_CE39 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE39 : ℝ) ∧ terminalFaceCE39 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE39 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE39 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (thirty-nine-window  chain):  given
    [Z-PT2]  +  the  thirty-nine  cited  window  clauses
    ([CE1-WIN],  [CE2-WIN-FULL],  ...,  [CE38-WIN-FULL],
    [CE39-WIN]),  all-heights  RH  <->  terminalFaceCE39.
    NO  RH  CLAIM.  -/
theorem rh_reanchored_CE39 (q : ZeroSet)
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
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : ce38WinClauseFull) (hW39 : ce39WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE39 q := by
  have hcensus := allOnLineUpToCE39 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hqz
  have hsplit := rh_split_at_CE39 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE39 (q : ZeroSet)
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
    (hW25 : CE26.ce25WinClauseFull) (hW26 : CE27.ce26WinClauseFull)
    (hW27 : CE28.ce27WinClauseFull) (hW28 : CE29.ce28WinClauseFull)
    (hW29 : CE30.ce29WinClauseFull)
    (hW30 : CE31.ce30WinClauseFull)
    (hW31 : CE32.ce31WinClauseFull)
    (hW32 : CE33.ce32WinClauseFull)
    (hW33 : CE34.ce33WinClauseFull)
    (hW34 : CE35.ce34WinClauseFull)
    (hW35 : CE36.ce35WinClauseFull)
    (hW36 : CE37.ce36WinClauseFull)
    (hW37 : CE38.ce37WinClauseFull)
    (hW38 : ce38WinClauseFull) (hW39 : ce39WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE39 q) :
    RH q :=
  (rh_reanchored_CE39 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE39_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE39 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE39
