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
import RhAttack.CE48

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31 CE32 CE33 CE34 CE35 CE36 CE37 CE38 CE39 CE40 CE41 CE42 CE42B CE43 CE44 CE45 CE46 CE47 CE48
open scoped Topology

/-!
**CE49 — the terminal face re-anchored at the FORTY-NINTH
certified  window  (0355,  option  B,  unit  68  —  lane
M5).  Frontier:  233 642  units  above  H0  (the  225 000
unit  crossing  of  CE48  is  carried,  proven  here  as
frontierPast225k  at  the  new  frontier;  the  next
round  mark,  250 000,  now  sits  16 358  ahead,  ~
3.5  windows).  Cumulative  certified  count  =  999 989
over  (g_a1,  g_b49]  -  ELEVEN  SHORT  of  the
1 000 000-certified-zero  mark:  the  1M  crossing  lands
in  window  50  (999 989  +  20 000  =  1 019 989  at
w50's  end  -  to  be  confirmed  from  the  decoded
endpoint  when  it  lands).  FOURTH  CONSECUTIVE  CLEAN
WINDOW  (zero  Rosser  failures  after  w46,  w47,  w48;
clean  tally  now  23  of  50  chain  windows).  The
18th  increment  is  4 673  -  the  4 673  pace  holds;
no  periodicity  is  assumed.  Corrected  chain
continues:  w42  →  w42b  →  w43  →  w44  →  w45  →  w46
→  w47  →  w48  →  w49,  every  seam  bit-identical
(window  49  launched  from  b48  correctly;  the  seam
audit  passed  bit-identically  BEFORE  this  module  was
written).  NO  RH  CLAIM.  -/

/- PROVENANCE  (our  run,  2026-11-08;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE48):
  RUN  PARAMETERS:  a  =  12 363 154 417 119  (=  b48,
  window  48's  final  b  -  launched  correctly  from
  the  chain  frontier,  per  the  0348  process  rule),
  b  =  a  +  20 000  =  12 363 154  437 119  (both
  endpoints  already  good  Gram  points  -  NO  snap),
  M  = 60,  C_R  = 1,  28  workers,  32 784  evaluations,
  2436.3  s.
  CERTIFICATE  (window49_b49.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a49  <  Im  s  <=  g_b49  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a49  (recorded  exact  dyadic  ball,  this  run's  a)
            =  232127340800023522916592057211907166017  x  2^-86,  radius
            16777217  x  2^-110  (i.e.  3 000 175 561
            769.826171875000  + or -  1.29e-26),  and
            this  ball  is  BIT-IDENTICAL  to  CE48's
            recorded  g_b48  (exact  dyadic  tuple
            comparison,  2026-11-08)  -  the  seam  audit
            PASSED  BEFORE  this  module  was  written  (the
            0348  process  rule);
      g_b49  =  3 000 175 566 442.761230468750  + or -
               1.29e-26  (exact  dyadic  tuple  as
               recorded:  [29015917645196795743551458640382313851,  -83,
               16777217,  -110];  the  floor  tCE49
               sits  0.7612  above  the  previous
               integer  -  robust  to  the  1.29e-26
               radius  by  many  orders  of  magnitude;
               the  standard  two-decimal  lower  bound
               gB49Lo  has  a  margin  of  ~3.9e-3;  the
               two-decimal  round-down  does  not  equal
               the  floor,  so  no  CASING  is  needed,
               window  38  /  CE38  remaining  the  only
               CASING  case  so  far).
      Turing  runs  of  consecutive  good  Rosser
      blocks:  48  left  of  g_a49,  50  right  of  g_b49
      (both  >=  K  =  12);  0  cross-check  failures  (all
      32 784  records);  0  undetermined  Gram  signs.
      INTERNAL  ROSSER-BLOCK  EXCEPTIONS:  NONE  -  a
      CLEAN  window  (zero  failures,  zero  rescues);
      the  fourth  consecutive  clean  window  of  the
      chain.  The  independent  verifier  recomputes
      the  WINDOW  TOTAL  (sign_changes_inside  =  20 000)
      and  the  two  end  Rosser  runs  (48  /  50)  -  the
      only  quantities  that  enter  the  Turing  step.
  VERIFICATION  (three  layers,  same  as  CE2-CE48):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window49_b49.json:
         "CERTIFIED:  true",  points_checked  = 32 784,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0  (clean  window),
         turing_ok  =  true,  K_conservative  = 12
         (K_required:  Trudgian  Cor2.3  =  [5.71899  + or -
         1.23e-6],  doubled  =  [11.4380  + or -
         1.76e-5],  Amberger  Thm2.3  =  [9.14967  + or -
         4.14e-6]  -  all  below  12),
         endpoints  recomputed  and  matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a49
         ball  is  bit-identical  to  CE48's  recorded
         g_b48  ball  (exact  dyadic  decode,  2026-11-08;
         audit  performed  BEFORE  this  module  was
         written).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE49  =  3 000 175 566 442,
      tCE49  −  tCE48  =  4 673   (the  18th
      increment  -  the  4 673  pace  after  the  one-shot
      4 672  break  at  w45->46;  no  periodicity
      assumed),
      tCE49  −  tPT2  = 233 642  (the  225 000-unit
      mark,  crossed  at  CE48,  is  carried  -  proven
      here  as  frontierPast225k  at  the  new  frontier;
      the  next  round  mark  250 000  sits  16 358
      ahead,  ~3.5  windows),
      certified  zeros  over  (g_a1,  g_b49]  =  979 989  +
      20 000  =  999 989  -  the  1 000 000 mark  is
      eleven  short;  the  crossing  lands  in  window
      50  (compute  from  the  decoded  endpoint  there,
      never  assume).
  HONESTY  (trust  base):  as  CE2-CE48  -  the
  pipeline's  own  controls,  its  kernel-checked  Lean
  remainder  theorem,  and  our  three  verification
  layers;  a  RE-RUN  of  a  third-party  pipeline,  not
  a  from-scratch  independent  certification.  NO  RH
  CLAIM.  -/

namespace CE49


/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b49  (the  recorded  ball  is
    3 000 175 566 442.761230468750  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~3.9e-3).  -/
def gB49Lo : ℚ := 300017556644276 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB49Lo:
    tCE49  =  3 000 175 566 442.  -/
def tCE49 : ℕ := 3000175566442

theorem tCE49_lt_gB49Lo : (tCE49 : ℝ) < (gB49Lo : ℝ) := by
  norm_num [gB49Lo, tCE49]

theorem tCE48_lt_tCE49 : (tCE48 : ℝ) < (tCE49 : ℝ) := by
  norm_num [CE48.tCE48, tCE49]

/-- Record:  the  seam  order  gB48Lo  <  tCE49  (the  band
    (gB48Lo,  tCE49]  is  nonempty  and  lies  above  window
    48's  frontier  tCE48).  -/
theorem gB48Lo_lt_tCE49 : (gB48Lo : ℝ) < (tCE49 : ℝ) := by
  norm_num [CE48.gB48Lo, tCE49]

/-- The  face  height  shrank  by  a  FURTHER  4 673  units
    past  tCE48:  the  4 673  pace  since  the  one-shot  4
    672  break  at  w45  →  w46  (the  18th  increment  is
    4 673)  -  the  Gram  spacings  wobble  by  units,  not
    periodic;  recorded  honestly,  no  pattern  assumed.  -/
theorem faceShrinkCE49 : (tCE49 : ℝ) - (tCE48 : ℝ) = 4673 := by
  norm_num [tCE49, CE48.tCE48]

/-- THE  EXTENDED  GEAR  (machine):  the  new  frontier
    stands  233 642  units  above  the  Platt-Trudgian
    frontier  H0  (the  225 000-unit  mark  —  crossed  in
    window  48,  the  CE48  MILESTONE  unit  —  is  carried;
    the  next  round  mark  250 000  now  sits  16 358
    ahead,  ~3.5  windows;  do  not  pre-announce,  compute
    the  floor  when  g_b50  decodes).  -/
theorem frontierGapAboveH0 : (tCE49 : ℝ) - WinC.tPT2 = 233642 := by
  norm_num [tCE49, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE49  −  tPT2  =  233 642
    exceeds  200 000  (crossed  at  the  fill  CE42B).  -/
theorem frontierPast200k : (tCE49 : ℝ) - WinC.tPT2 > 200000 := by
  have h : (tCE49 : ℝ) - WinC.tPT2 = 233642 := frontierGapAboveH0
  linarith [h]

/-- MILESTONE  CARRY  (machine):  tCE49  −  tPT2  =  233 642
    exceeds  175 000  (the  CE38  mark).  -/
theorem frontierPast175k : (tCE49 : ℝ) - WinC.tPT2 > 175000 := by
  have h : (tCE49 : ℝ) - WinC.tPT2 = 233642 := frontierGapAboveH0
  linarith [h]


/-- MILESTONE  CARRY  (machine,  PROVEN):  tCE49  −  tPT2
    =  233 642  exceeds  225 000  -  the  225 000-unit
    mark  (crossed  in  window  48,  the  CE48  MILESTONE
    unit)  is  carried  at  the  new  frontier.  The
    round-mark  sequence  above  H0:  100 000  @  CE22,
    125 000  @  CE27,  150 000  @  CE33,  175 000  @
    CE38,  200 000  @  CE42B,  225 000  @  CE48.  The
    next  round  mark,  250 000,  sits  16 358  units
    ahead  (~3.5  windows).  -/
theorem frontierPast225k : (tCE49 : ℝ) - WinC.tPT2 > 225000 := by
  have h : (tCE49 : ℝ) - WinC.tPT2 = 233642 := frontierGapAboveH0
  linarith [h]
/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB48Lo  <  gB49Lo)  -  the  window-49  band  (gB48Lo,
    gB49Lo]  lies  strictly  above  window  48's  certified
    region  (gB47Lo,  gB48Lo].  -/
theorem gB48Lo_lt_gB49Lo : (gB48Lo : ℝ) < (gB49Lo : ℝ) := by
  norm_num [CE48.gB48Lo, gB49Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-48  RUN  (window48_b48.json),  FULL
    SLICE  -  re-cited  at  the  CE49  level]  every  zeta
    zero  with  gB47Lo  <  Im  ρ  <=  gB48Lo  is  on  the
    critical  line.  Same  derivation  as  at  the  CE48
    level:  for  t0  =  Im  ρ  in  (gB47Lo,  gB48Lo],
    either  t0  <=  g_b47  (g_a48  =  g_b47,  recorded
    exact  dyadic  tuple
    [116063670219236339931915844848888957081,  -85,
    16777217,  -110]  -  the  chain  seam,  audit  PASSED
    BEFORE  CE48  was  written)  -  then  t0  sits  in
    window  47's  certified  region  (g_a47,  g_b47]  -
    or  t0  >  g_b47  =  g_a48,  in  which  case  t0  <=
    gB48Lo  <=  g_b48  puts  t0  in  window  48's
    certified  region  (g_a48,  g_b48].  The  two
    certified  regions  union  to  (g_a47,  g_b48]  which
    contains  (gB47Lo,  gB48Lo]  (machine:  gB47Lo  <
    tCE48  <  gB48Lo,  from  CE48).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce48WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB47Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB48Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-49  RUN  (window49_b49.json),  SLICE]
    every  zeta  zero  with  gB48Lo  <  Im  ρ  <=  tCE49
    is  on  the  critical  line.  Derivation  (recorded):
    for  t0  =  Im  ρ  in  (gB48Lo,  tCE49],  either  t0
    <=  g_b48  (the  true  Gram  point  -  g_a49  =  g_b48,
    recorded  exact  dyadic  tuple  [232127340800023522916592057211907166017,
    -86,  16777217,  -110],  i.e.  3 000 175 561
    769.826171875000  +  or  -  1.29e-26,  BIT-IDENTICAL
    in  both  certificates  -  the  chain  seam,  audit
    PASSED  BEFORE  this  module  was  written  per  the
    0348  process  rule;  gB48Lo  <  g_b48)  -  then  t0
    sits  in  window  48's  certified  region  (g_a48,
    g_b48]  -  or  t0  >  g_b48  =  g_a49,  in  which
    case  t0  <=  tCE49  <  gB49Lo  <=  g_b49  puts  t0
    in  window  49's  certified  region  (g_a49,  g_b49].
    The  two  certified  regions  union  to  (g_a48,
    g_b49]  which  contains  (gB48Lo,  tCE49]  (machine:
    gB48Lo  <  tCE49  <  gB49Lo).  Named  Prop  consumed
    as  a  hypothesis;  not  proven  in-tree.  -/
def ce49WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB48Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE49 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE49]  are  on  the  line,  given  the
    fifty  window  clauses  (windows  1  through  42,
    the  fill,  windows  43  through  48  [full  slices],
    and  window  49  [terminal  slice])  -  the  splits
    at  gA2Hi,  gB2Lo,  ...,  gB42Lo,  gB42BLo,  gB43Lo,
    gB44Lo,  gB45Lo,  gB46Lo,  gB47Lo,  gB48Lo  are
    pure  case  splits.  -/
theorem bandOfWindows49 (h1 : CE2.ce1WinClause)
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
    (h42 : ce42WinClauseFull) (h43 : CE44.fillWinClauseFull) (h44 : CE44.ce43WinClauseFull) (h45 : CE45.ce44WinClauseFull) (h46 : CE46.ce45WinClauseFull) (h47 : CE47.ce46WinClauseFull) (h48 : CE48.ce47WinClauseFull) (h49 : ce48WinClauseFull) (h50 : ce49WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE49 : ℝ) → ρ.re = 1 / 2 := by
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
                                                                                                · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
                                                                                                  · exact h49 ρ hz (not_le.mp hseam48) hseam49
                                                                                                  · exact h50 ρ hz (not_le.mp hseam49) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (window  49):  [Z-PT2]
    +  the  fifty  cited  window  clauses  =>  the
    on-line  census  holds  up  to  tCE49.  -/
theorem allOnLineUpToCE49 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : ce48WinClauseFull) (hW50 : ce49WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE49 : ℝ) := by
  have hband := bandOfWindows49 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (window  49):  no  off-line
    zero  with  positive  height  above  tCE49.  -/
def terminalFaceCE49 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE49 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE48  face  implies  the  CE49  face
    (tCE49  >  tCE48).  -/
theorem faceCE48_implies_faceCE49 (q : ZeroSet)
    (hface : CE48.terminalFaceCE48 q) :
    terminalFaceCE49 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE48_lt_tCE49, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE48,  tCE49]  is  certified
    empty  (window  48  full  slice  +  window  49  together)
    -  re-anchoring  is  a  CERTIFICATE,  not  a  logical
    move  (the  face  is  the  same  open  object,  now
    certified  4 673  higher;  the  225 000-unit  mark
    (CE48)  is  carried  —  see  frontierPast225k).  -/
theorem terminalFaceCE49_iff_faceCE48 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW49 : ce48WinClauseFull) (hW50 : ce49WinClause) :
    terminalFaceCE49 q ↔ CE48.terminalFaceCE48 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE49 : ℝ)
    · by_cases hseam49 : ρ.im ≤ (gB48Lo : ℝ)
      · exact hW49 ρ (hqz ρ hρ) (by linarith [ht, CE48.gB47Lo_lt_tCE48, tCE48_lt_tCE49]) hseam49
      · exact hW50 ρ (hqz ρ hρ) (not_le.mp hseam49) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE48_implies_faceCE49 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE49
    (pure  logic).  -/
theorem rh_split_at_CE49 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE49 : ℝ) ∧ terminalFaceCE49 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE49 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE49 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (window  49,  corrected  chain
    continues,  4th  consecutive  CLEAN  window):  given
    [Z-PT2]  +  the  fifty  cited  window  clauses
    ([CE1-WIN],  [CE2-WIN-FULL],  ...
    [CE41-WIN-FULL],  [CE42-WIN-FULL],  [CE42B-WIN-FULL],
    [CE43-WIN-FULL],  [CE44-WIN-FULL],  [CE45-WIN-FULL],
    [CE46-WIN-FULL],  [CE47-WIN-FULL],  [CE48-WIN-FULL],
    [CE49-WIN]),
    all-heights  RH  <->  terminalFaceCE49.  NO  RH
    CLAIM.  -/
theorem rh_reanchored_CE49 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : ce48WinClauseFull) (hW50 : ce49WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE49 q := by
  have hcensus := allOnLineUpToCE49 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hqz
  have hsplit := rh_split_at_CE49 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE49 (q : ZeroSet)
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
    (hW42 : ce42WinClauseFull) (hW43 : CE44.fillWinClauseFull) (hW44 : CE44.ce43WinClauseFull) (hW45 : CE45.ce44WinClauseFull) (hW46 : CE46.ce45WinClauseFull) (hW47 : CE47.ce46WinClauseFull) (hW48 : CE48.ce47WinClauseFull) (hW49 : ce48WinClauseFull) (hW50 : ce49WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE49 q) :
    RH q :=
  (rh_reanchored_CE49 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hW33 hW34 hW35 hW36 hW37 hW38 hW39 hW40 hW41 hW42 hW43 hW44 hW45 hW46 hW47 hW48 hW49 hW50 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE49_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE49 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE49
