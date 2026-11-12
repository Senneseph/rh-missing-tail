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
import RhAttack.CE39

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39
open scoped Topology

/-!
**CE40 — the terminal face re-anchored at the FORTIETH
certified  window  (0345,  option  B,  unit  56  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  -> 40).  RIGHT-EDGE  SNAP  this
window  (b  snapped  down  by  2:  b  =  a  +  19 998,  the
first  19 998-width  window  of  the  chain;  the  prior
snapped  windows  were  all  19 999-width).  The  200k  mark
is  now  13 087  units  ahead  (~3  windows  out).  FORTIETH
WINDOW  MILESTONE.  -/

/- (provenance  in  the  next  comment  block  so  this
   header  stays  readable)  -/
/- PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE39):
  RUN  PARAMETERS:  a  =  12 363 154 217 121  (=  CE39's
  final  b;  seamless),  requested  b  =  a  +  20 000  = 12
  363 154 237 121  (NOT  a  good  Gram  point  at  working
  precision  -  the  pipeline  SNAPPED  THE  FINAL  b
  DOWNWARD  BY  2  to  b  =  12 363 154 237 119,  a  good
  Gram  point;  so  b  −  a  =  19 998  -  the  FIRST
  19 998-WIDTH  WINDOW  OF  THE  CHAIN;  the  prior  snapped
  windows  2,  3,  8,  11,  17,  18,  19,  21  and  31  were
  all  19 999-width),  M  = 60,  C_R  = 1,  28  workers,
  34 548  evaluations  in  2721.1  s.
  CERTIFICATE  (window40_b40.json):  the  b  −  a  =  19 998
  zeros  of  ζ  with  g_a40  <  Im  s  <=  g_b40  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a40  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 515 040.942165751912  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE39's
            recorded  g_b39  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b40  =  3 000 175 519 713.409996947896  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE40  sits  0.4100  above  the  previous
               integer,  robust  to  the  radius  of 1.29e-26
               by  many  orders  of  magnitude;  the  standard
               two-decimal  lower  bound  gB40Lo  has  a
               margin  of  ~0.41;  the  two-decimal  round-down
               does  not  equal  the  floor,  so  no  CASING
               is  needed).
      Turing  runs  of  consecutive  good  Rosser  blocks:  48
      left  of  g_a40,  47  right  of  g_b40  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 548  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  rosser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window
      (as  windows  6,  8,  10,  12,  13,  14,  16,  18,  22,
      25,  30,  31,  32,  33,  36  and  38;  the  clean  tally
      is  now  SEVENTEEN  of  forty).
  VERIFICATION  (three  layers,  same  as  CE2-CE39):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window40_b40.json:
         "CERTIFIED:  true",  points_checked  = 34 548,
         sign_changes_inside  =  19 998  =  b  −  a  (the
         SNAPPED  width),  rosser_failures_inside  = 0,
         turing_ok  =  true,  K_conservative  = 12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a40
         ball  is  bit-identical  to  CE39's  recorded  g_b39
         ball  (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE40  =  3 000 175 519 713,
      tCE40  −  tCE39  =  4 673   (face  shrink  past
      tCE39  -  the  running  pattern),
      tCE40  −  tPT2  = 186 913  (above  the  Platt-Trudgian
      H0;  round  marks  100 000  (CE22),  125 000  (CE27),
      150 000  (CE33)  and  175 000  (CE38)  all  crossed;
      the  NEXT  ROUND  MARK  200 000  SITS  13 087  UNITS
      AHEAD,  about  3  windows  out),
      certified  zeros  over  (g_a1,  g_b40]  =  779 991  +
      19 998  =  799 989.
  HONESTY  (trust  base):  as  CE2-CE39  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE40

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b40  (the  recorded  ball  is
    3 000 175 519 713.409996947896  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~0.41).  -/
def gB40Lo : ℚ := 300017551971340 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB40Lo:
    tCE40  =  3 000 175 519 713.  -/
def tCE40 : ℕ := 3000175519713

theorem tCE40_lt_gB40Lo : (tCE40 : ℝ) < (gB40Lo : ℝ) := by
  norm_num [gB40Lo, tCE40]

theorem tCE39_lt_tCE40 : (tCE39 : ℝ) < (tCE40 : ℝ) := by
  norm_num [CE39.tCE39, tCE40]

/-- Record:  the  seam  order  gB39Lo  <  tCE40  (the  band
    (gB39Lo,  tCE40]  is  nonempty  and  lies  above  CE39's
    frontier  tCE39).  -/
theorem gB39Lo_lt_tCE40 : (gB39Lo : ℝ) < (tCE40 : ℝ) := by
  norm_num [CE39.gB39Lo, tCE40]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE39  (the  running  pattern).  -/
theorem faceShrinkCE40 : (tCE40 : ℝ) - (tCE39 : ℝ) = 4673 := by
  norm_num [tCE40, CE39.tCE39]

/-- THE  GAP  TO  THE  NEXT  ROUND  MARK  (machine):  the  new
    frontier  is  186 913  units  above  the  Platt-Trudgian
    frontier  H0  (round  marks  100 000  (CE22),  125 000
    (CE27),  150 000  (CE33)  and  175 000  (CE38)  all
    crossed;  the  NEXT  ROUND  MARK  200 000  SITS  13 087
    UNITS  AHEAD,  about  3  windows  out).  -/
theorem frontierGapAboveH0 : (tCE40 : ℝ) - WinC.tPT2 = 186913 := by
  norm_num [tCE40, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE40  −  tPT2  =  186 913
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE40 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE40 : ℝ) - WinC.tPT2 = 186913 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB38Lo  <  gB39Lo  (re-stated  at  the  CE40  level  from
    CE39's  window-39  band  ordering).  -/
theorem gB38Lo_lt_gB39Lo : (gB38Lo : ℝ) < (gB39Lo : ℝ) := by
  norm_num [CE38.gB38Lo, CE39.gB39Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB39Lo  <  gB40Lo)  -  the  window-40  band  (gB39Lo,
    gB40Lo]  (hence  (gB39Lo,  tCE40])  lies  strictly  above
    window  39's  certified  region.  -/
theorem gB39Lo_lt_gB40Lo : (gB39Lo : ℝ) < (gB40Lo : ℝ) := by
  norm_num [CE39.gB39Lo, gB40Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-39  RUN  (window39_b39.json),  FULL
    SLICE]  every  zeta  zero  with  gB38Lo  <  Im  ρ  <=
    gB39Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB38Lo,  gB39Lo]  lies  inside  (g_a39,
    g_b39]  -  window  39's  own  certified  region  -  since
    gB38Lo  is  the  certified  bottom  of  g_a39  (=  g_b38,
    bit-identical  dyadic  ball  in  windows  38  and  39)
    and  gB39Lo  the  certified  bottom  of  g_b39
    (machine:  gB38Lo  <  gB39Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce39WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB38Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB39Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-40  RUN  (window40_b40.json),  SLICE]
    every  zeta  zero  with  gB39Lo  <  Im  ρ  <=  tCE40  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB39Lo,  tCE40],  either  t0  <=  g_b39
    (the  true  Gram  point  -  g_a40  =  g_b39,  recorded  exact
    dyadic  ball  3 000 175 515 040.942165751912  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a40  =  g_a39  <  gB39Lo  <  g_b39
    puts  t0  in  window  39's  region  (g_a39,  g_b39])  -
    or  t0  >  g_b39  =  g_a40,  in  which  case  t0  <=  tCE40
    <  gB40Lo  <=  g_b40  puts  t0  in  window  40's  region
    (g_a40,  g_b40].  The  two  certified  regions  union  to
    (g_a39,  g_b40]  which  contains  (gB39Lo,  tCE40]
    (machine:  gB39Lo  <  tCE40  <  gB40Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce40WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB39Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE40 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE40]  are  on  the  line,  given  the
    forty  window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    ...,  gB38Lo,  gB39Lo  are  pure  case  splits.  -/
theorem bandOfWindows40 (h1 : CE2.ce1WinClause)
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
    (h38 : CE39.ce38WinClauseFull)
    (h39 : ce39WinClauseFull) (h40 : ce40WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE40 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                            · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
                                                                              · exact h39 ρ hz (not_le.mp hseam38) hseam39
                                                                              · exact h40 ρ hz (not_le.mp hseam39) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (FORTIETH  RUN,
    FORTIETH  WINDOW  MILESTONE,  right-edge  snap  by  2):
    [Z-PT2]  +  the  forty  cited  window  clauses  =>  the
    on-line  census  holds  up  to  tCE40.  -/
theorem allOnLineUpToCE40 (q : ZeroSet)
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
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : ce39WinClauseFull) (hW40 : ce40WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE40 : ℝ) := by
  have hband := bandOfWindows40 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fortieth  run):  no  off-line
    zero  with  positive  height  above  tCE40.  -/
def terminalFaceCE40 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE40 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE39  face  implies  the  CE40  face
    (tCE40  >  tCE39).  -/
theorem faceCE39_implies_faceCE40 (q : ZeroSet)
    (hface : CE39.terminalFaceCE39 q) :
    terminalFaceCE40 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE39_lt_tCE40, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE39,  tCE40]  is  certified
    empty  (windows  39+40  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE40_iff_faceCE39 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW39 : ce39WinClauseFull) (hW40 : ce40WinClause) :
    terminalFaceCE40 q ↔ CE39.terminalFaceCE39 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE40 : ℝ)
    · by_cases hseam39 : ρ.im ≤ (gB39Lo : ℝ)
      · exact hW39 ρ (hqz ρ hρ) (by linarith [ht, gB38Lo_lt_tCE39, tCE39_lt_tCE40]) hseam39
      · exact hW40 ρ (hqz ρ hρ) (not_le.mp hseam39) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE39_implies_faceCE40 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE40
    (pure  logic).  -/
theorem rh_split_at_CE40 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE40 : ℝ) ∧ terminalFaceCE40 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE40 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE40 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (forty-window  chain,  FORTIETH  WINDOW
    MILESTONE):  given  [Z-PT2]  +  the  forty  cited  window
    clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE39-WIN-FULL],  [CE40-WIN]),  all-heights  RH  <->
    terminalFaceCE40.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE40 (q : ZeroSet)
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
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : ce39WinClauseFull) (hW40 : ce40WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE40 q := by
  have hcensus := allOnLineUpToCE40 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hqz
  have hsplit := rh_split_at_CE40 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE40 (q : ZeroSet)
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
    (hW38 : CE39.ce38WinClauseFull)
    (hW39 : ce39WinClauseFull) (hW40 : ce40WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE40 q) :
    RH q :=
  (rh_reanchored_CE40 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE40_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE40 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE40
