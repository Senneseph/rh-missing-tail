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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42
open scoped Topology

/-!
**CE42B — THE FILL WINDOW  (0348  CORRECTION,  option  B,
unit  59  —  lane  M5).  M5  LAUNCH  ARITHMETIC  ERROR
CORRECTED:  window  "43"  was  launched  from  b42  +  20 000
instead  of  b42,  leaving  the  20 000-point  interval
(b42,  b42  +  20 000]  uncertified  between  windows  42  and
43.  THE  SEAM  AUDIT  (exact  dyadic  tuple)  CAUGHT  IT
(g_a43  !=  g_b42,  a  gap  of  ~4 673  height  units).  This
module  is  the  certified  FILL  for  that  interval:  a  =
b42  =  12 363 154 277 119,  b  =  b42  +  20 000  =  12 363
154  297 119  (=  the  a  of  the  misplaced  window  43).  Its
g_a  is  bit-identical  to  window  42's  g_b  AND  its  g_b
is  bit-identical  to  window  43's  g_a,  so  the  chain
w42  →  w42b  →  w43  is  SEAMLESS  AGAIN.  MILESTONE:  this
fill  window  is  where  THE  200 000-UNIT  FRONTIER  MARK  IS
CROSSED  (tCE42B  −  tPT2  =  200 932  >  200 000,  proven
in-tree  as  frontierPast200k).  -/

/- (provenance  in  the  next  comment  block  so  this
   header  stays  readable)  -/
/- PROVENANCE  (our  run,  2026-11-07;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE42):
  CORRECTION  NARRATIVE:  window  "43"  was  launched  with
  a  =  12 363 154 297 119  =  b42  +  20 000  (an  arithmetic
  slip  in  the  launch  command  -  the  intended  a  was
  b42  =  12 363 154 277 119),  so  the  interval  of  20 000
  Gram  points  (b42,  b42  +  20 000]  was  initially
  UNCERTIFIED.  The  exact-dyadic-tuple  seam  audit  caught
  it  (window  43's  recorded  g_a  is  NOT  bit-identical  to
  window  42's  recorded  g_b;  the  gap  is  4 672.935  ...
  height  units:  g_a43  =  3 000 175 533 732.215369449384
  vs  g_b42  =  3 000 175 529 059.280245552874).  The  fill
  run  (this  module)  covers  exactly  that  interval.  This
  is  precisely  the  failure  the  seam  audit  exists  to
  catch;  we  log  it  here  in  full.
  RUN  PARAMETERS:  a  =  12 363 154 277 119  (=  CE42's
  final  b;  seamless),  b  =  a  +  20 000  =  12 363 154
  297 119  (=  the  a  of  the  misplaced  window  43;  b  was
  already  a  good  Gram  point  -  NO  snap  at  either
  endpoint),  M  = 60,  C_R  = 1,  28  workers,  33 301
  evaluations  in  2533.4  s.
  CERTIFICATE  (window42b_fill.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a42b  <  Im  s  <=  g_b42b  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a42b  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 529 059.280245552874  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE42's
            recorded  g_b42  (exact  dyadic  tuple  comparison,
            2026-11-07)  -  SEAM  1;
      g_b42b  =  3 000 175 533 732.215369449384  + or -
               1.29e-26  (exact  dyadic  decode;  this  ball
               is  BIT-IDENTICAL  to  window  43's  recorded
               g_a  -  exact  dyadic  tuple  comparison,
               2026-11-07)  -  SEAM  2;
      the  floor  tCE42B  sits  0.2154  above  the  previous
      integer,  robust  to  the  radius  of 1.29e-26;  the
      standard  two-decimal  lower  bound  gB42BLo  has  a
      margin  of  ~5.4e-3;  the  two-decimal  round-down  does
      not  equal  the  floor,  so  no  CASING  is  needed.
      Turing  runs  of  consecutive  good  Rosser  blocks:  47
      left  of  g_a42b,  47  right  of  g_b42b  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 301  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  a  CLEAN  window.
  VERIFICATION  (three  layers,  same  as  CE2-CE42):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window42b_fill.json:
         "CERTIFIED:  true",  points_checked  = 33 301,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  = 0,  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (both  directions,  both  verified):
         SEAM 1:  g_a42b  bit-identical  to  window  42's
         g_b;  SEAM  2:  g_b42b  bit-identical  to  window
         43's  g_a.
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE42B  =  3 000 175 533 732,
      tCE42B  −  tCE42  =  4 673   (face  shrink  past
      tCE42  -  the  running  pattern),
      tCE42B  −  tPT2  = 200 932  -  MILESTONE:  THE  200
      000-UNIT  MARK  IS  CROSSED  HERE  (frontierPast200k
      proven  in-tree;  tCE43,  which  follows,  extends  to
      205 605).
      certified  zeros  over  (g_a1,  g_b42b]  =  839 989  +
      20 000  =  859 989.
  HONESTY  (trust  base):  as  CE2-CE42  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  The  misplaced
  window  43  remains  what  it  is  (a  valid  certificate  of
  its  own  region);  the  gap  it  left  is  now  certified  by
  this  fill  module,  and  the  chain  w42  →  w42b  →  w43
  is  seamless.  -/

namespace CE42B

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b42b  (the  recorded  ball  is
    3 000 175 533 732.215369449384  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~5.4e-3).  -/
def gB42BLo : ℚ := 300017553373221 / 100

/-- THE  FILL  FRONTIER:  an  integer  strictly  below  the
    certified  lower  bound  gB42BLo:
    tCE42B  =  3 000 175 533 732.  -/
def tCE42B : ℕ := 3000175533732

theorem tCE42B_lt_gB42BLo : (tCE42B : ℝ) < (gB42BLo : ℝ) := by
  norm_num [gB42BLo, tCE42B]

theorem tCE42_lt_tCE42B : (tCE42 : ℝ) < (tCE42B : ℝ) := by
  norm_num [CE42.tCE42, tCE42B]

/-- Record:  the  seam  order  gB42Lo  <  tCE42B  (the  band
    (gB42Lo,  tCE42B]  is  nonempty  and  lies  above  CE42's
    frontier  tCE42).  -/
theorem gB42Lo_lt_tCE42B : (gB42Lo : ℝ) < (tCE42B : ℝ) := by
  norm_num [CE42.gB42Lo, tCE42B]

/-- The  face  height  shrunk  by  4 673  units  past  tCE42
    (the  running  pattern).  -/
theorem faceShrinkCE42B : (tCE42B : ℝ) - (tCE42 : ℝ) = 4673 := by
  norm_num [tCE42B, CE42.tCE42]

/-- MILESTONE  (machine):  the  fill  frontier  is  200 932
    units  above  the  Platt-Trudgian  frontier  H0  -  THE
    200 000-UNIT  MARK  IS  CROSSED  HERE.  -/
theorem frontierGapAboveH0 : (tCE42B : ℝ) - WinC.tPT2 = 200932 := by
  norm_num [tCE42B, WinC.tPT2]

/-- MILESTONE  (machine):  tCE42B  −  tPT2  =  200 932  >
    200 000  -  THE  200K  MARK  IS  CROSSED.  -/
theorem frontierPast200k : (tCE42B : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE42B : ℝ) - WinC.tPT2 = 200932 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  CARRY  (machine):  tCE42B  −  tPT2  =  200 932
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE42B : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE42B : ℝ) - WinC.tPT2 = 200932 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB41Lo  <  gB42Lo  (re-stated  at  the  CE42B  level  from
    CE42's  window-42  band  ordering).  -/
theorem gB41Lo_lt_gB42Lo : (gB41Lo : ℝ) < (gB42Lo : ℝ) := by
  norm_num [CE41.gB41Lo, CE42.gB42Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB42Lo  <  gB42BLo)  -  the  fill  band  (gB42Lo,
    gB42BLo]  (hence  (gB42Lo,  tCE42B])  lies  strictly
    above  window  42's  certified  region.  -/
theorem gB42Lo_lt_gB42BLo : (gB42Lo : ℝ) < (gB42BLo : ℝ) := by
  norm_num [CE42.gB42Lo, gB42BLo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-42  RUN  (window42_b42.json),  FULL
    SLICE]  every  zeta  zero  with  gB41Lo  <  Im  ρ  <=
    gB42Lo  is  on  the  critical  line.  Derivation  (recorded):
    for  t0  =  Im  ρ  in  (gB41Lo,  gB42Lo],  either  t0
    <=  g_b41  (g_a42  =  g_b41,  bit-identical  dyadic  ball;
    gB41Lo  is  the  certified  bottom  of  g_a42)  -  then
    t0  sits  in  window  41's  certified  region  (g_a41,
    g_b41]  since  g_a41  =  g_b40  <=  gB40Lo  <  gB41Lo  -
    or  t0  >  g_b41  =  g_a42,  in  which  case  t0  <=
    gB42Lo  <=  g_b42  puts  t0  in  window  42's  certified
    region  (g_a42,  g_b42].  The  two  certified  regions
    union  to  (g_a41,  g_b42]  which  contains  (gB41Lo,
    gB42Lo]  (machine:  gB41Lo  <  gB42Lo,  below).  Named
    Prop  consumed  as  a  hypothesis;  not  proven  in-tree.
    -/
def ce42WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB41Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB42Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  FILL  RUN  (window42b_fill.json),  SLICE]
    every  zeta  zero  with  gB42Lo  <  Im  ρ  <=  tCE42B  is
    on  the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB42Lo,  tCE42B],  either  t0  <=
    g_b42  (the  true  Gram  point  -  g_a42b  =  g_b42,
    recorded  exact  dyadic  ball  3 000 175 529
    059.280245552874  +  or  -  1.29e-26,  BIT-IDENTICAL  in
    both  certificates  (SEAM  1);  gB42Lo  <  g_b42)  -  then
    t0  sits  in  window  42's  certified  region  (g_a42,
    g_b42]  -  or  t0  >  g_b42  =  g_a42b,  in  which  case
    t0  <=  tCE42B  <  gB42BLo  <=  g_b42b  puts  t0  in  the
    FILL  window's  certified  region  (g_a42b,  g_b42b].
    The  two  certified  regions  union  to  (g_a42,  g_b42b]
    which  contains  (gB42Lo,  tCE42B]  (machine:  gB42Lo  <
    tCE42B  <  gB42BLo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce42BWinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB42Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE42B : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE42B]  are  on  the  line,  given  the
    forty-three  window  clauses  (windows  1  through  42
    plus  this  fill)  -  the  splits  at  gA2Hi,  gB2Lo,
    ...,  gB41Lo,  gB42Lo  are  pure  case  splits.  -/
theorem bandOfWindows42B (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : ce42BWinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE42B : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                    · exact h43 ρ hz (not_le.mp hseam42) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FILL  IS  CERTIFIED  (gap  sealed,  200K
    CROSSED):  [Z-PT2]  +  the  forty-three  cited  window
    clauses  =>  the  on-line  census  holds  up  to
    tCE42B.  -/
theorem allOnLineUpToCE42B (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : ce42BWinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE42B : ℝ) := by
  have hband := bandOfWindows42B hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fill  window):  no
    off-line  zero  with  positive  height  above  tCE42B.
    -/
def terminalFaceCE42B (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE42B : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE42  face  implies  the  CE42B  face
    (tCE42B  >  tCE42).  -/
theorem faceCE42_implies_faceCE42B (q : ZeroSet)
    (hface : CE42.terminalFaceCE42 q) :
    terminalFaceCE42B q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE42_lt_tCE42B, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE42,  tCE42B]  is  certified
    empty  (windows  42  +  fill  together)  -  re-anchoring
    is  a  CERTIFICATE,  not  a  logical  move  (the  face  is
    the  same  open  object,  now  certified  4 673  higher,
    and  the  gap  that  the  misplaced  window  43  left  is
    certified  sealed).  -/
theorem terminalFaceCE42B_iff_faceCE42 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW42 : ce42WinClauseFull) (hW43 : ce42BWinClause) :
    terminalFaceCE42B q ↔ CE42.terminalFaceCE42 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE42B : ℝ)
    · by_cases hseam42 : ρ.im ≤ (gB42Lo : ℝ)
      · exact hW42 ρ (hqz ρ hρ) (by linarith [ht, gB41Lo_lt_tCE42, tCE42_lt_tCE42B]) hseam42
      · exact hW43 ρ (hqz ρ hρ) (not_le.mp hseam42) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE42_implies_faceCE42B q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE42B
    (pure  logic).  -/
theorem rh_split_at_CE42B (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE42B : ℝ) ∧ terminalFaceCE42B q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE42B : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE42B : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (fill  window,  gap  sealed,  200K
    CROSSED):  given  [Z-PT2]  +  the  forty-three  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE41-WIN-FULL],  [CE42-WIN-FULL],  [CE42B-WIN]),
    all-heights  RH  <->  terminalFaceCE42B.  NO  RH  CLAIM.
    -/
theorem rh_reanchored_CE42B (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : ce42BWinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE42B q := by
  have hcensus := allOnLineUpToCE42B q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hqz
  have hsplit := rh_split_at_CE42B q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  FILL  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE42B (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : ce42BWinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE42B q) :
    RH q :=
  (rh_reanchored_CE42B q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  fill  frontier.  -/
theorem terminalFaceCE42B_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE42B q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE42B
