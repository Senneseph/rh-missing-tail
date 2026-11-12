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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27
open scoped Topology

/-!
**CE28 — the terminal face re-anchored at the TWENTY-EIGHTH
certified  window  (0333,  option  B,  unit  44  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  28).  NEW:  the FIRST
multi-exception  window  -  THREE  Rosser-block  rescues  in
one  window,  each  quota-met  by  the  union  refinement,
each  DISPLACED  into  an  adjacent  Gram  interval,  all
recounted  by  the  verifier;  the  window  total  is  still
exactly  b  −  a  =  20 000.**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE27):
  RUN  PARAMETERS:  a  =  12 363 153 977 122  (=  CE27's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 997 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 787  evaluations  in  2582.3  s.
  CERTIFICATE  (window28_b28.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a28  <  Im  s  <=  g_b28  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a28  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 458 965.954294896093  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE27's
            recorded  g_b27  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b28  =  3 000 175 463 638.889422852356  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE28  sits  0.8894  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude;  the  face
               shrink  came  out  as  the  running  4 673
               again,  after  window  27's  4 672  variant).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a28,  50  right  of  g_b28  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 787  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  THREE  (the  FIRST  multi-exception
      window  in  the  chain),  each  RESCUED  BY  THE
      PIPELINE'S  DOCUMENTED  UNION  REFINEMENT  (window.py):
        1. block  [12 363 153 983 686,  .. 983 689]  rescued
           to  union  [.. 983 685,  .. 983 691],  need  6  =
           found  6,  m  =  8;
        2. block  [12 363 153 985 487,  .. 985 489]  rescued
           to  union  [.. 985 486,  .. 985 490],  need  4  =
           found  4,  m  =  8;
        3. block  [12 363 153 991 175,  .. 991 177]  rescued
           to  union  [.. 991 174,  .. 991 178],  need  4  =
           found  4,  m  =  8.
      All  three  quotas  were  met  by  the  union  recounts
      (a  block  that  cannot  Rosser-certify  its  own
      endpoints  is  widened  to  a  union  of  neighboring
      blocks  until  the  total  is  Rosser-verified;  the
      rescued  zeros  are  DISPLACED  into  adjacent  Gram
      intervals  in  the  point  list).  The  independent
      verifier  recomputes  the  WINDOW  TOTAL
      (sign_changes_inside  =  20 000)  and  the  two  end
      Rosser  runs  (50  /  50)  -  the  only  quantities
      that  enter  the  Turing  step.  Recorded,  not
      suppressed.  (The  m  =  8  values  record  the  union
      widths  used  by  the  refinement;  the  quota  check
      is  need  =  found  in  every  case.)
  VERIFICATION  (three  layers,  same  as  CE2-CE27):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window28_b28.json:
         "CERTIFIED:  true",  points_checked  = 33 787,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  3  (all  three
         rescued,  all  quotas  met),  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a28  ball
         is  bit-identical  to  CE27's  recorded  g_b27  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE28  =  3 000 175 463 638,
      tCE28  −  tCE27  =  4 673   (face  shrink  past
      tCE27  -  the  running  4 673  pattern  resumes  after
      window  27's  4 672  variant),
      tCE28  −  tPT2  = 130 838  (above  the  Platt-Trudgian
      H0;  the  125 000-unit  mark  crossed  at  CE27  remains
      crossed),
      certified  zeros  over  (g_a1,  g_b28]  =  539 992  +
      20 000  =  559 992.
  HONESTY  (trust  base):  as  CE2-CE27  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE28

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b28  (the  recorded  ball  is
    3 000 175 463 638.889422852356  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~8.9e-3).  -/
def gB28Lo : ℚ := 300017546363888 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB28Lo:
    tCE28  =  3 000 175 463 638.  -/
def tCE28 : ℕ := 3000175463638

theorem tCE28_lt_gB28Lo : (tCE28 : ℝ) < (gB28Lo : ℝ) := by
  norm_num [gB28Lo, tCE28]

theorem tCE27_lt_tCE28 : (tCE27 : ℝ) < (tCE28 : ℝ) := by
  norm_num [CE27.tCE27, tCE28]

/-- Record:  the  seam  order  gB27Lo  <  tCE28  (the  band
    (gB27Lo,  tCE28]  is  nonempty  and  lies  above  CE27's
    frontier  tCE27).  -/
theorem gB27Lo_lt_tCE28 : (gB27Lo : ℝ) < (tCE28 : ℝ) := by
  norm_num [CE27.gB27Lo, tCE28]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE27  (the  running  pattern  resumes  after  window  27's
    4 672  variant).  -/
theorem faceShrinkCE28 : (tCE28 : ℝ) - (tCE27 : ℝ) = 4673 := by
  norm_num [tCE28, CE27.tCE27]

/-- The  new  frontier  is  130 838  units  above  the
    Platt-Trudgian  frontier  H0  (machine;  the  125 000-unit
    mark  crossed  at  CE27  remains  crossed;  the  next
    round  mark  150 000  is  19 162  units  away,  i.e.  ~4
    windows  out).  -/
theorem frontierGapAboveH0 : (tCE28 : ℝ) - WinC.tPT2 = 130838 := by
  norm_num [tCE28, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE28  −  tPT2  =  130 838
    exceeds  125 000.  -/
theorem frontierPast125k : (tCE28 : ℝ) - WinC.tPT2 > 125000 := by
  have h : (tCE28 : ℝ) - WinC.tPT2 = 130838 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB26Lo  <  gB27Lo  (re-stated  at  the  CE28  level  from
    CE27's  window-27  band  ordering).  -/
theorem gB26Lo_lt_gB27Lo : (gB26Lo : ℝ) < (gB27Lo : ℝ) := by
  norm_num [CE26.gB26Lo, CE27.gB27Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB27Lo  <  gB28Lo)  -  the  window-28  band  (gB27Lo,
    gB28Lo]  (hence  (gB27Lo,  tCE28])  lies  strictly  above
    window  27's  certified  region.  -/
theorem gB27Lo_lt_gB28Lo : (gB27Lo : ℝ) < (gB28Lo : ℝ) := by
  norm_num [CE27.gB27Lo, gB28Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-27  RUN  (window27_b27.json),  FULL
    SLICE]  every  zeta  zero  with  gB26Lo  <  Im  ρ  <=
    gB27Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB26Lo,  gB27Lo]  lies  inside  (g_a27,
    g_b27]  -  window  27's  own  certified  region  -  since
    gB26Lo  is  the  certified  bottom  of  g_a27  (=  g_b26,
    bit-identical  dyadic  ball  in  windows  26  and  27)  and
    gB27Lo  the  certified  bottom  of  g_b27  (machine:
    gB26Lo  <  gB27Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce27WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB26Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB27Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-28  RUN  (window28_b28.json),  SLICE]
    every  zeta  zero  with  gB27Lo  <  Im  ρ  <=  tCE28  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB27Lo,  tCE28],  either  t0  <=  g_b27
    (the  true  Gram  point  -  g_a28  =  g_b27,  recorded  exact
    dyadic  ball  3 000 175 458 965.954294896093  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a28  =  g_a27  <  gB27Lo  <  g_b27
    puts  t0  in  window  27's  region  (g_a27,  g_b27])  -
    or  t0  >  g_b27  =  g_a28,  in  which  case  t0  <=  tCE28
    <  gB28Lo  <=  g_b28  puts  t0  in  window  28's  region
    (g_a28,  g_b28].  The  two  certified  regions  union  to
    (g_a27,  g_b28]  which  contains  (gB27Lo,  tCE28]
    (machine:  gB27Lo  <  tCE28  <  gB28Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce28WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB27Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE28 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE28]  are  on  the  line,  given  the
    twenty-eight  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo,  gB23Lo,  gB24Lo,  gB25Lo,  gB26Lo,
    gB27Lo  are  pure  case  splits.  -/
theorem bandOfWindows28 (h1 : CE2.ce1WinClause)
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
    (h26 : CE27.ce26WinClauseFull) (h27 : ce27WinClauseFull)
    (h28 : ce28WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE28 : ℝ) → ρ.re = 1 / 2 := by
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
                                                      · exact h28 ρ hz (not_le.mp hseam27) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    twenty-eight  cited  window  clauses  =>  the  on-line
    census  holds  up  to  tCE28.  -/
theorem allOnLineUpToCE28 (q : ZeroSet)
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
    (hW27 : ce27WinClauseFull) (hW28 : ce28WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE28 : ℝ) := by
  have hband := bandOfWindows28 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-eighth  run):  no
    off-line  zero  with  positive  height  above  tCE28.  -/
def terminalFaceCE28 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE28 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE27  face  implies  the  CE28  face
    (tCE28  >  tCE27).  -/
theorem faceCE27_implies_faceCE28 (q : ZeroSet)
    (hface : CE27.terminalFaceCE27 q) :
    terminalFaceCE28 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE27_lt_tCE28, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE27,  tCE28]  is  certified
    empty  (windows  27+28  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE28_iff_faceCE27 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW27 : ce27WinClauseFull) (hW28 : ce28WinClause) :
    terminalFaceCE28 q ↔ CE27.terminalFaceCE27 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE28 : ℝ)
    · by_cases hseam27 : ρ.im ≤ (gB27Lo : ℝ)
      · exact hW27 ρ (hqz ρ hρ) (by linarith [ht, gB26Lo_lt_tCE27, tCE27_lt_tCE28]) hseam27
      · exact hW28 ρ (hqz ρ hρ) (not_le.mp hseam27) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE27_implies_faceCE28 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE28
    (pure  logic).  -/
theorem rh_split_at_CE28 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE28 : ℝ) ∧ terminalFaceCE28 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE28 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE28 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-eight
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE27-WIN-FULL],  [CE28-WIN]),  all-heights  RH  <->
    terminalFaceCE28.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE28 (q : ZeroSet)
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
    (hW27 : ce27WinClauseFull) (hW28 : ce28WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE28 q := by
  have hcensus := allOnLineUpToCE28 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hqz
  have hsplit := rh_split_at_CE28 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE28 (q : ZeroSet)
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
    (hW27 : ce27WinClauseFull) (hW28 : ce28WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE28 q) :
    RH q :=
  (rh_reanchored_CE28 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE28_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE28 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE28
