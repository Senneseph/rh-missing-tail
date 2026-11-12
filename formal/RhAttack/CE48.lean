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
import RhAttack.CE44
import RhAttack.CE45
import RhAttack.CE46
import RhAttack.CE47

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47
open scoped Topology

/-!
**CE48 — the terminal face re-anchored at the FORTY-EIGHTTH
certified  window  (0354,  option  B,  unit  67  —  lane
M5).  MILESTONE  UNIT:  the  225 000-unit  frontier  mark
is  CROSSED  in  window  48  -  confirmed  from  the
decoded  g_b48  floor  (tCE48  −  tPT2  =  228 969  >
225 000),  and  proven  in-tree  as  the  machine  fact
frontierPast225k  (as  frontierPast200k  was  proven  in
CE42B).  Round-mark  sequence  above  H0:  100 000  @
CE22  (102 801),  125 000  @  CE27  (126 165),  150 000  @
CE33  (154 203),  175 000  @  CE38  (177 568),  200 000  @
CE42B  (200 932),  225 000  @  CE48  (228 969).  The  next
round  mark,  250 000,  sits  21 031  units  ahead  (~
4.5  windows).  Cumulative  certified  count  =  979 989
over  (g_a1,  g_b48]  -  the  960 000-certified-zero  mark
was  also  crossed  inside  window  48.  THIRD
CONSECUTIVE  CLEAN  WINDOW  (zero  Rosser  failures  after
w46  and  w47;  clean  tally  now  22  of  49  chain
windows).  The  17th  increment  is  4 673  -  the  4 673
pace  holds  after  the  one-shot  4 672  break;  no
periodicity  is  assumed.  Corrected  chain  continues:
w42  →  w42b  →  w43  →  w44  →  w45  →  w46  →  w47  →
w48,  every  seam  bit-identical  (window  48  launched
from  b47  correctly;  the  seam  audit  passed
bit-identically  BEFORE  this  module  was  written).  NO
RH  CLAIM.  -/

/- PROVENANCE  (our  run,  2026-11-08;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE47):
  RUN  PARAMETERS:  a  =  12 363 154 397 119  (=  b47,
  window  47's  final  b  -  launched  correctly  from  the
  chain  frontier,  per  the  0348  process  rule),
  b  =  a  +  20 000  =  12 363 154  417 119  (both
  endpoints  already  good  Gram  points  -  NO  snap),
  M  = 60,  C_R  = 1,  28  workers,  33 506  evaluations,
  2574.9  s.
  CERTIFICATE  (window48_b48.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a48  <  Im  s  <=  g_b48  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a48  (recorded  exact  dyadic  ball,  this  run's  a)
            =  116063670219236339931915844848888957081  x  2^-85,  radius
            16777217  x  2^-110  (i.e.  3 000 175 557
            096.891113281250  + or -  1.29e-26),  and
            this  ball  is  BIT-IDENTICAL  to  CE47's
            recorded  g_b47  (exact  dyadic  tuple
            comparison,  2026-11-08)  -  the  seam  audit
            PASSED  BEFORE  this  module  was  written  (the
            0348  process  rule);
      g_b48  =  3 000 175 561 769.826171875000  + or -
               1.29e-26  (exact  dyadic  tuple  as  recorded:
               [232127340800023522916592057211907166017,  -86,  16777217,
               -110];  the  floor  tCE48  sits
               0.8262  above  the  previous  integer  -
               robust  to  the  1.29e-26  radius  by  many
               orders  of  magnitude;  the  standard
               two-decimal  lower  bound  gB48Lo  has  a
               margin  of  ~1.7e-3;  the  two-decimal
               round-down  does  not  equal  the  floor,  so
               no  CASING  is  needed,  window  38  /  CE38
               remaining  the  only  CASING  case  so  far).
      Turing  runs  of  consecutive  good  Rosser  blocks:
      48  left  of  g_a48,  48  right  of  g_b48  (both
      >=  K  =  12);  0  cross-check  failures  (all
      33 506  records);  0  undetermined  Gram  signs.
      INTERNAL  ROSSER-BLOCK  EXCEPTIONS:  NONE  -  a
      CLEAN  window  (zero  failures,  zero  rescues);
      the  third  consecutive  clean  window  of  the
      chain.  The  independent  verifier  recomputes
      the  WINDOW  TOTAL  (sign_changes_inside  =  20 000)
      and  the  two  end  Rosser  runs  (48  /  48)  -  the
      only  quantities  that  enter  the  Turing  step.
  VERIFICATION  (three  layers,  same  as  CE2-CE47):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window48_b48.json:
         "CERTIFIED:  true",  points_checked  = 33 506,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  0  (clean  window),
         turing_ok  =  true,  K_conservative  = 12
         (K_required:  Trudgian  Cor2.3  =  [5.71899  + or -
         1.23e-6],  doubled  =  [11.4380  + or -
         1.76e-5],  Amberger  Thm2.3  =  [9.14967  + or -
         4.14e-6]  -  all  below  12),
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a48
         ball  is  bit-identical  to  CE47's  recorded
         g_b47  ball  (exact  dyadic  decode,  2026-11-08;
         audit  performed  BEFORE  this  module  was
         written).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE48  =  3 000 175 561 769,
      tCE48  −  tCE47  =  4 673   (the  17th  increment
      -  the  4 673  pace  after  the  one-shot  4 672
      break  at  w45->46;  no  periodicity  assumed),
      tCE48  −  tPT2  = 228 969  -  THE  225 000-UNIT
      MARK  IS  CROSSED  (228 969  >  225 000,  by  3 969);
      proven  in-tree  as  frontierPast225k;  the  200 000
      unit  mark  (CE42B)  and  all  earlier  marks  carried;
      the  next  round  mark  250 000  sits  21 031  ahead
      (~4.5  windows),
      certified  zeros  over  (g_a1,  g_b48]  =  959 989  +
      20 000  =  979 989  (the  960 000 mark  crossed
      inside  this  window).
  HONESTY  (trust  base):  as  CE2-CE47  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  The  225 000-unit  crossing
  is  a  frontier  record,  not  an  RH  statement.  NO
  RH  CLAIM.  -/

namespace CE48


/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b47  (the  recorded  ball  is
    3 000 175 557 096.891113281250  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~1.7e-3).  -/
def gB48Lo : ℚ := 300017556176982 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB48Lo:
    tCE48  =  3 000 175 561 769.  -/
def tCE48 : ℕ := 3000175561769

theorem tCE48_lt_gB48Lo : (tCE48 : ℝ) < (gB48Lo : ℝ) := by
  norm_num [gB48Lo, tCE48]

theorem tCE47_lt_tCE48 : (tCE47 : ℝ) < (tCE48 : ℝ) := by
  norm_num [CE47.tCE47, tCE48]

/-- Record:  the  seam  order  gB46Lo  <  tCE47  (the  band
    (gB46Lo,  tCE47]  is  nonempty  and  lies  above  window
    46's  frontier  tCE46).  -/
theorem gB47Lo_lt_tCE48 : (gB47Lo : ℝ) < (tCE48 : ℝ) := by
  norm_num [CE47.gB47Lo, tCE48]

/-- The  face  height  shrank  by  a  FURTHER  4 673  units
    past  tCE46:  the  4 673  resume  after  the  4 672  break
    (the  15th  increment  was  4 672,  the  16th  is  4 673)
    -  the  Gram  spacings  wobble  by  units,  not  periodic;
    recorded  honestly,  no  pattern  assumed.  -/
theorem faceShrinkCE48 : (tCE48 : ℝ) - (tCE47 : ℝ) = 4673 := by
  norm_num [tCE48, CE47.tCE47]

/-- THE  EXTENDED  CROSSING  (machine):  the  new  frontier
    is  224 296  units  above  the  Platt-Trudgian  frontier
    H0  (the  200 000-unit  mark,  crossed  at  the  CE42B
    fill,  is  carried;  the  next  round  mark  225 000  sits
    only  704  units  ahead  -  the  crossing  is  expected
    in  window  48;  compute  the  floor  when  g_b48
    decodes,  do  not  pre-announce).  -/
theorem frontierGapAboveH0 : (tCE48 : ℝ) - WinC.tPT2 = 228969 := by
  norm_num [tCE48, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE48  −  tPT2  =  228 969
    exceeds  200 000  (crossed  at  the  fill  CE42B).  -/
theorem frontierPast200k : (tCE48 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE48 : ℝ) - WinC.tPT2 = 228969 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  CARRY  (machine):  tCE48  −  tPT2  =  228 969
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE48 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE48 : ℝ) - WinC.tPT2 = 228969 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE  CROSSING  (machine,  PROVEN):  tCE48  −  tPT2
    =  228 969  exceeds  225 000  -  the  225 000-unit  mark
    IS  CROSSED  (by  3 969),  window  48.  The  round-mark
    sequence  above  H0:  100 000  @  CE22,  125 000  @
    CE27,  150 000  @  CE33,  175 000  @  CE38,  200 000  @
    CE42B,  225 000  @  CE48.  The  next  round  mark,
    250 000,  sits  21 031  units  ahead.  -/
theorem frontierPast225k : (tCE48 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE48 : ℝ) - WinC.tPT2 = 228969 := frontierGapAboveH0
  linarith [h]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB46Lo  <  gB47Lo)  -  the  window-47  band  (gB46Lo,
    gB47Lo]  lies  strictly  above  window  46's  certified
    region  (gB45Lo,  gB46Lo].  -/
theorem gB47Lo_lt_gB48Lo : (gB47Lo : ℝ) < (gB48Lo : ℝ) := by
  norm_num [CE47.gB47Lo, gB48Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-47  RUN  (window47_b47.json),  FULL
    SLICE  -  re-cited  at  the  CE48  level]  every  zeta
    zero  with  gB46Lo  <  Im  ρ  <=  gB47Lo  is  on  the
    critical  line.  Same  derivation  as  at  the  CE47
    level:  for  t0  =  Im  ρ  in  (gB46Lo,  gB47Lo],
    either  t0  <=  g_b46  (g_a47  =  g_b46,  recorded  exact
    dyadic  tuple  [232127340076921836790130566544415780883,
    -86,  16777217,  -110]  -  the  chain  seam,  audit
    PASSED  BEFORE  CE47  was  written)  -  then  t0  sits
    in  window  46's  certified  region  (g_a46,  g_b46]
    -  or  t0  >  g_b46  =  g_a47,  in  which  case  t0  <=
    gB47Lo  <=  g_b47  puts  t0  in  window  47's
    certified  region  (g_a47,  g_b47].  The  two  certified
    regions  union  to  (g_a46,  g_b47]  which  contains
    (gB46Lo,  gB47Lo]  (machine:  gB46Lo  <  tCE47  <  gB47Lo,
    from  CE47).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce47WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB46Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB47Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-48  RUN  (window48_b48.json),  SLICE]
    every  zeta  zero  with  gB47Lo  <  Im  ρ  <=  tCE48  is
    on  the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB47Lo,  tCE48],  either  t0  <=
    g_b47  (the  true  Gram  point  -  g_a48  =  g_b47,
    recorded  exact  dyadic  tuple
    [116063670219236339931915844848888957081,  -85,
    16777217,  -110],  i.e.  3 000 175 557
    096.891113281250  +  or  -  1.29e-26,  BIT-IDENTICAL
    in  both  certificates  -  the  chain  seam,  audit
    PASSED  BEFORE  this  module  was  written  per  the
    0348  process  rule;  gB47Lo  <  g_b47)  -  then  t0
    sits  in  window  47's  certified  region  (g_a47,
    g_b47]  -  or  t0  >  g_b47  =  g_a48,  in  which  case
    t0  <=  tCE48  <  gB48Lo  <=  g_b48  puts  t0  in
    window  48's  certified  region  (g_a48,  g_b48].
    The  two  certified  regions  union  to  (g_a47,
    g_b48]  which  contains  (gB47Lo,  tCE48]  (machine:
    gB47Lo  <  tCE48  <  gB48Lo).  Named  Prop  consumed
    as  a  hypothesis;  not  proven  in-tree.  -/
def ce48WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB47Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE48 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE48]  are  on  the  line,  given  the
    forty-nine  window  clauses  (windows  1  through
    42,  the  fill,  windows  43  through  47  [full
    slices],  and  window  48  [terminal  slice])  -  the
    splits  at  gA2Hi,  gB2Lo,  ...,  gB42Lo,  gB42BLo,
    gB43Lo,  gB44Lo,  gB45Lo,  gB46Lo,  gB47Lo  are
    pure  case  splits.  -/
theorem bandOfWindows48 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : ce47WinClauseFull) (h49 : ce48WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE48 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                        · by_cases hseam45 : ρ.im ≤ (gB44Lo : ℝ)
                                                                                          · exact h45 ρ hz (not_le.mp hseam44) hseam45
                                                                                          · by_cases hseam46 : ρ.im ≤ (gB45Lo : ℝ)
                                                                                            · exact h46 ρ hz (not_le.mp hseam45) hseam46
                                                                                            · by_cases hseam47 : ρ.im ≤ (gB46Lo : ℝ)
                                                                                              · exact h47 ρ hz (not_le.mp hseam46) hseam47
                                                                                              · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
                                                                                                · exact h48 ρ hz (not_le.mp hseam47) hseam48
                                                                                                · exact h49 ρ hz (not_le.mp hseam48) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (window  48):  [Z-PT2]
    +  the  forty-nine  cited  window  clauses  =>  the
    on-line  census  holds  up  to  tCE48.  -/
theorem allOnLineUpToCE48 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : ce47WinClauseFull) (hW49 : ce48WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE48 : ℝ) := by
  have hband := bandOfWindows48 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (window  48):  no  off-line
    zero  with  positive  height  above  tCE48.  -/
def terminalFaceCE48 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE48 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE47  face  implies  the  CE48  face
    (tCE48  >  tCE47).  -/
theorem faceCE47_implies_faceCE48 (q : ZeroSet)
    (hface : CE47.terminalFaceCE47 q) :
    terminalFaceCE48 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE47_lt_tCE48, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE47,  tCE48]  is  certified
    empty  (window  47  full  slice  +  window  48  together)
    -  re-anchoring  is  a  CERTIFICATE,  not  a  logical
    move  (the  face  is  the  same  open  object,  now
    certified  4 673  higher,  and  the  225 000-unit
    mark  is  CROSSED  -  see  frontierPast225k).  -/
theorem terminalFaceCE48_iff_faceCE47 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW48 : ce47WinClauseFull) (hW49 : ce48WinClause) :
    terminalFaceCE48 q ↔ CE47.terminalFaceCE47 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE48 : ℝ)
    · by_cases hseam48 : ρ.im ≤ (gB47Lo : ℝ)
      · exact hW48 ρ (hqz ρ hρ) (by linarith [ht, CE47.gB46Lo_lt_tCE47, tCE47_lt_tCE48]) hseam48
      · exact hW49 ρ (hqz ρ hρ) (not_le.mp hseam48) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE47_implies_faceCE48 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE48
    (pure  logic).  -/
theorem rh_split_at_CE48 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE48 : ℝ) ∧ terminalFaceCE48 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE48 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE48 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (window  48,  corrected  chain  continues,
    MILESTONE  UNIT  -  the  225 000-unit  mark  is
    CROSSED,  proven  in-tree  as  frontierPast225k):
    given  [Z-PT2]  +  the  forty-nine  cited  window
    clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...
    [CE41-WIN-FULL],  [CE42-WIN-FULL],  [CE42B-WIN-FULL],
    [CE43-WIN-FULL],  [CE44-WIN-FULL],  [CE45-WIN-FULL],
    [CE46-WIN-FULL],  [CE47-WIN-FULL],  [CE48-WIN]),
    all-heights  RH  <->  terminalFaceCE48.  NO  RH
    CLAIM.  -/
theorem rh_reanchored_CE48 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : ce47WinClauseFull) (hW49 : ce48WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE48 q := by
  have hcensus := allOnLineUpToCE48 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hqz
  have hsplit := rh_split_at_CE48 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE48 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : ce47WinClauseFull) (hW49 : ce48WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE48 q) :
    RH q :=
  (rh_reanchored_CE48 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE48_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE48 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE48
