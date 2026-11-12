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
import RhAttack.CE40
import RhAttack.CE41
import RhAttack.CE42
import RhAttack.CE42B
import RhAttack.CE43

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43
open scoped Topology

/-!
**CE44 — the terminal face re-anchored at the FORTY-FOURTH
certified  window  (0349,  option  B,  unit  60  —  lane
M5).  CORRECTED  CHAIN  CONTINUES:  w42  →  w42b  →  w43
→  w44,  every  seam  bit-identical  (window  44  launched
from  b43  correctly  -  the  0348  lesson  held;  the  seam
audit  passed  bit-identically  before  this  module  was
written).  Frontier:  210 278  units  above  H0  (the
225 000-unit  mark  sits  14 722  ahead,  ~3  windows  out;
the  200k  crossing  of  CE42B  is  carried).  Cumulative
certified  count  =  899 989  over  (g_a1,  g_b44].  ONE
quota-met  Rosser  rescue  recorded  (window  43  had  one,
window  44  has  one  -  the  two-rescue  stretch  from
windows  37  +  43  +  44).  NO  RH  CLAIM.  -/

/- (provenance  in  the  next  comment  block  so  this
   header  stays  readable)  -/
/- PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE43):
  RUN  PARAMETERS:  a  =  12 363 154 317 119  (=  b43,  window
  43's  final  b  -  launched  correctly  from  the  chain
  frontier,  per  the  0348  process  rule),  b  =  a  +
  20 000  =  12 363 154  337 119  (b  was  already  a  good
  Gram  point  -  NO  snap  at  either  endpoint),  M  = 60,
  C_R  = 1,  28  workers,  33 953  evaluations.
  CERTIFICATE  (window44_b44.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a44  <  Im  s  <=  g_b44  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a44  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 538 405.150493075241  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE43's
            recorded  g_b43  (exact  dyadic  tuple
            comparison,  2026-11-07)  -  the  seam  audit
            PASSED  BEFORE  this  module  was  written  (the
            0348  process  rule);
      g_b44  =  3 000 175 543 078.085449218750  + or -
               1.29e-26  (exact  dyadic  decode:
               116063669676910075289953026587486486005  x
               2^-85;  the  floor  tCE44  sits  0.0854  above
               the  previous  integer,  robust  to  the
               radius  of  1.29e-26  by  many  orders  of
               magnitude;  the  standard  two-decimal  lower
               bound  gB44Lo  has  a  margin  of  ~5.6e-3;
               the  two-decimal  round-down  does  not  equal
               the  floor,  so  no  CASING  is  needed).
      Turing  runs  of  consecutive  good  Rosser  blocks:  46
      left  of  g_a44,  48  right  of  g_b44  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 953  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  ONE  -  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        1. block  [12 363 154 324 338,  .. 324 340]  (raw:
           need  2,  changes  0  at  129  points,  m  =  64,
           determined)  rescued  to  union  [.. 324 337,
           .. 324 341],  need  4  =  found  4,  m  =  4.
      The  quota  was  met  by  the  union  recount,  and  the
      rescued  zero  was  DISPLACED  into  an  adjacent  Gram
      interval  within  the  same  window,  so  the  window
      total  is  unchanged.  The  independent  verifier
      recomputes  the  WINDOW  TOTAL  (sign_changes_inside  =
      20 000)  and  the  two  end  Rosser  runs  (46  /  48)
      -  the  only  quantities  that  enter  the  Turing  step.
      Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE43):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window44_b44.json:
         "CERTIFIED:  true",  points_checked  = 33 953,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  = 1  (rescued,  quota  met),
         turing_ok  =  true,  K_conservative  = 12,
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a44
         ball  is  bit-identical  to  CE43's  recorded
         g_b43  ball  (exact  dyadic  decode,  2026-11-07;
         audit  performed  BEFORE  this  module  was  written).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE44  =  3 000 175 543 078,
      tCE44  −  tCE43  =  4 673   (the  running  pattern
      holds  -  thirteenth  consecutive  4 673  shrink),
      tCE44  −  tPT2  = 210 278  (the  200 000-unit  mark,
      crossed  at  the  CE42B  fill,  is  carried;  the  next
      round  mark  225 000  sits  14 722  units  ahead,
      about  3  windows  out),
      certified  zeros  over  (g_a1,  g_b44]  =  879 989  +
      20 000  =  899 989.
  HONESTY  (trust  base):  as  CE2-CE43  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE44


/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b44  (the  recorded  ball  is
    3 000 175 543 078.085449218750  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~5.6e-3).  -/
def gB44Lo : ℚ := 300017554307808 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB44Lo:
    tCE44  =  3 000 175 543 078.  -/
def tCE44 : ℕ := 3000175543078

theorem tCE44_lt_gB44Lo : (tCE44 : ℝ) < (gB44Lo : ℝ) := by
  norm_num [gB44Lo, tCE44]

theorem tCE43_lt_tCE44 : (tCE43 : ℝ) < (tCE44 : ℝ) := by
  norm_num [CE43.tCE43, tCE44]

/-- Record:  the  seam  order  gB43Lo  <  tCE44  (the  band
    (gB43Lo,  tCE44]  is  nonempty  and  lies  above  window
    43's  frontier  tCE43).  -/
theorem gB43Lo_lt_tCE44 : (gB43Lo : ℝ) < (tCE44 : ℝ) := by
  norm_num [CE43.gB43Lo, tCE44]

/-- The  face  height  shrunk  by  further  4 673  units
    past  tCE43  (the  running  pattern  holds).  -/
theorem faceShrinkCE44 : (tCE44 : ℝ) - (tCE43 : ℝ) = 4673 := by
  norm_num [tCE44, CE43.tCE43]

/-- THE  EXTENDED  CROSSING  (machine):  the  new  frontier
    is  210 278  units  above  the  Platt-Trudgian  frontier
    H0  (the  200 000-unit  mark,  crossed  at  the  CE42B
    fill,  is  carried;  the  next  round  mark  225 000  sits
    14 722  units  ahead,  about  3  windows  out).  -/
theorem frontierGapAboveH0 : (tCE44 : ℝ) - WinC.tPT2 = 210278 := by
  norm_num [tCE44, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE44  −  tPT2  =  210 278
    exceeds  200 000  (crossed  at  the  fill  CE42B).  -/
theorem frontierPast200k : (tCE44 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE44 : ℝ) - WinC.tPT2 = 210278 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  CARRY  (machine):  tCE44  −  tPT2  =  210 278
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE44 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE44 : ℝ) - WinC.tPT2 = 210278 := frontierGapAboveH0
  linarith [h]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB43Lo  <  gB44Lo)  -  the  window-44  band  (gB43Lo,
    gB44Lo]  (hence  (gB43Lo,  tCE44])  lies  strictly
    above  window  43's  certified  region.  -/
theorem gB43Lo_lt_gB44Lo : (gB43Lo : ℝ) < (gB44Lo : ℝ) := by
  norm_num [CE43.gB43Lo, gB44Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  FILL  RUN  (window42b_fill.json),  FULL
    SLICE  -  re-cited  at  the  CE44  level]  every  zeta
    zero  with  gB42Lo  <  Im  ρ  <=  gB42BLo  is  on  the
    critical  line.  Same  derivation  as  at  the  CE43
    level:  for  t0  =  Im  ρ  in  (gB42Lo,  gB42BLo],
    either  t0  <=  g_b42  (g_a42b  =  g_b42,  fill  SEAM
    1;  gB42Lo  certified  bottom  of  g_a42b)  -  then  t0
    sits  in  window  42's  certified  region  (g_a42,
    g_b42]  -  or  t0  >  g_b42  =  g_a42b,  in  which  case
    t0  <=  gB42BLo  <=  g_b42b  puts  t0  in  the  fill's
    certified  region  (g_a42b,  g_b42b].  The  union  of
    the  two  certified  regions  (g_a42,  g_b42b]  contains
    (gB42Lo,  gB42BLo].  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def fillWinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB42Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB42BLo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-43  RUN  (window43_b43.json),  FULL
    SLICE]  every  zeta  zero  with  gB42BLo  <  Im  ρ  <=
    gB43Lo  is  on  the  critical  line.  Derivation
    (recorded):  for  t0  =  Im  ρ  in  (gB42BLo,  gB43Lo],
    either  t0  <=  g_b42b  (g_a43  =  g_b42b,  bit-identical
    dyadic  ball  -  the  fill's  SEAM  2;  gB42BLo  is  the
    certified  bottom  of  g_a43)  -  then  t0  sits  in  the
    fill's  certified  region  (g_a42b,  g_b42b]  -  or  t0
    >  g_b42b  =  g_a43,  in  which  case  t0  <=  gB43Lo
    <=  g_b43  puts  t0  in  window  43's  certified  region
    (g_a43,  g_b43].  The  two  certified  regions  union  to
    (g_a42b,  g_b43]  which  contains  (gB42BLo,  gB43Lo]
    (machine:  gB42BLo  <  tCE43  <  gB43Lo,  from  CE43).
    Named  Prop  consumed  as  a  hypothesis;  not  proven
    in-tree.  -/
def ce43WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB42BLo : ℝ) < ρ.im →
      ρ.im ≤ (gB43Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-44  RUN  (window44_b44.json),  SLICE]
    every  zeta  zero  with  gB43Lo  <  Im  ρ  <=  tCE44  is
    on  the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB43Lo,  tCE44],  either  t0  <=
    g_b43  (the  true  Gram  point  -  g_a44  =  g_b43,
    recorded  exact  dyadic  ball  3 000 175 538
    405.150493075241  +  or  -  1.29e-26,  BIT-IDENTICAL  in
    both  certificates  -  the  chain  seam,  audit  PASSED
    BEFORE  this  module  was  written  per  the  0348
    process  rule;  gB43Lo  <  g_b43)  -  then  t0  sits  in
    window  43's  certified  region  (g_a43,  g_b43]  -  or
    t0  >  g_b43  =  g_a44,  in  which  case  t0  <=  tCE44
    <  gB44Lo  <=  g_b44  puts  t0  in  window  44's
    certified  region  (g_a44,  g_b44].  The  two  certified
    regions  union  to  (g_a43,  g_b44]  which  contains
    (gB43Lo,  tCE44]  (machine:  gB43Lo  <  tCE44  <  gB44Lo).
    Named  Prop  consumed  as  a  hypothesis;  not  proven
    in-tree.  -/
def ce44WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB43Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE44 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE44]  are  on  the  line,  given  the
    forty-five  window  clauses  (windows  1  through  42,
    the  fill,  window  43,  and  window  44)  -  the  splits  at  gA2Hi,
    gB2Lo,  ...,  gB42Lo,  gB42BLo  are  pure  case  splits.
    -/
theorem bandOfWindows44 (h1 : CE2.ce1WinClause)
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
    (h39 : CE40.ce39WinClauseFull)
    (h40 : CE41.ce40WinClauseFull)
    (h41 : ce41WinClauseFull)
    (h42 : ce42WinClauseFull) (h43 : fillWinClauseFull) (h44 : ce43WinClauseFull) (h45 : ce44WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE44 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                              · by_cases hseam40 : ρ.im ≤ (gB40Lo : ℝ)
                                                                                · exact h40 ρ hz (not_le.mp hseam39) hseam40
                                                                                · by_cases hseam41 : ρ.im ≤ (gB41Lo : ℝ)
                                                                                  · exact h41 ρ hz (not_le.mp hseam40) hseam41
                                                                                  · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
                                                                                    · exact h42 ρ hz (not_le.mp hseam41) hseam42
                                                                                    · by_cases hseam43 : ρ.im ≤ (gB42BLo : ℝ)
                                                                                      · exact h43 ρ hz (not_le.mp hseam42) hseam43
                                                                                      · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
                                                                                        · exact h44 ρ hz (not_le.mp hseam43) hseam44
                                                                                        · exact h45 ρ hz (not_le.mp hseam44) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (window  44):  [Z-PT2]
    +  the  forty-five  cited  window  clauses  =>  the
    on-line  census  holds  up  to  tCE44.  -/
theorem allOnLineUpToCE44 (q : ZeroSet)
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
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : fillWinClauseFull) (hW44 : ce43WinClauseFull) (hW45 : ce44WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE44 : ℝ) := by
  have hband := bandOfWindows44 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (window  44):  no  off-line
    zero  with  positive  height  above  tCE44.  -/
def terminalFaceCE44 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE44 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE43  face  implies  the  CE44  face
    (tCE44  >  tCE43).  -/
theorem faceCE43_implies_faceCE44 (q : ZeroSet)
    (hface : CE43.terminalFaceCE43 q) :
    terminalFaceCE44 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE43_lt_tCE44, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE43,  tCE44]  is  certified
    empty  (window  43  full  slice  +  window  44  together)
    -  re-anchoring  is  a  CERTIFICATE,  not  a  logical
    move  (the  face  is  the  same  open  object,  now
    certified  4 673  higher).  -/
theorem terminalFaceCE44_iff_faceCE43 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW44 : ce43WinClauseFull) (hW45 : ce44WinClause) :
    terminalFaceCE44 q ↔ CE43.terminalFaceCE43 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE44 : ℝ)
    · by_cases hseam44 : ρ.im ≤ (gB43Lo : ℝ)
      · exact hW44 ρ (hqz ρ hρ) (by linarith [ht, CE43.gB42BLo_lt_tCE43, tCE43_lt_tCE44]) hseam44
      · exact hW45 ρ (hqz ρ hρ) (not_le.mp hseam44) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE43_implies_faceCE44 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE44
    (pure  logic).  -/
theorem rh_split_at_CE44 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE44 : ℝ) ∧ terminalFaceCE44 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE44 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE44 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (window  44,  corrected  chain  continues):
    given  [Z-PT2]  +  the  forty-five  cited  window
    clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...
    [CE41-WIN-FULL],  [CE42-WIN-FULL],  [CE42B-WIN-FULL],
    [CE43-WIN-FULL],  [CE44-WIN]),  all-heights  RH  <->
    terminalFaceCE44.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE44 (q : ZeroSet)
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
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : fillWinClauseFull) (hW44 : ce43WinClauseFull) (hW45 : ce44WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE44 q := by
  have hcensus := allOnLineUpToCE44 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hqz
  have hsplit := rh_split_at_CE44 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE44 (q : ZeroSet)
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
    (hW39 : CE40.ce39WinClauseFull)
    (hW40 : CE41.ce40WinClauseFull)
    (hW41 : ce41WinClauseFull)
    (hW42 : ce42WinClauseFull) (hW43 : fillWinClauseFull) (hW44 : ce43WinClauseFull) (hW45 : ce44WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE44 q) :
    RH q :=
  (rh_reanchored_CE44 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE44_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE44 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE44
