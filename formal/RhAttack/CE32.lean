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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29 CE30 CE31
open scoped Topology

/-!
**CE32 — the terminal face re-anchored at the THIRTY-SECOND
certified  window  (0337,  option  B,  unit  48  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  32).  NOTE:  the  frontier
now  sits  470  units  BELOW  the  150 000-unit  mark  —
window  33  is  expected  to  cross  it.  -/

/- (provenance  in  the  next  comment  block  so  this
   header  stays  readable)  -/
/- PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE31):
  RUN  PARAMETERS:  a  =  12 363 154 057 121  (=  CE31's
  final  b;  seamless),  b  =  a  +  20 000  =  12 363 154
  077 121  (b  was  already  a  good  Gram  point  -  NO
  snap  at  either  endpoint),  M  = 60,  C_R  = 1,  28
  workers,  33 567  evaluations  in  2517.1  s.
  CERTIFICATE  (window32_b32.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a32  <  Im  s  <=  g_b32  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a32  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 477 657.461158340877  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE31's
            recorded  g_b31  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b32  =  3 000 175 482 330.396285214541  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE32  sits  0.3963  above  the  previous
               integer,  robust  to  the  radius  of 1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  48
      left  of  g_a32,  45  right  of  g_b32  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 567  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  rosser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window
      (as  windows  6,  8,  10,  12,  13,  14,  16,  18,  22,
      25,  30  and  31;  the  clean  tally  is  now  THIRTEEN
      of  thirty-two).
  VERIFICATION  (three  layers,  same  as  CE2-CE31):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window32_b32.json:
         "CERTIFIED:  true",  points_checked  = 33 567,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a32
         ball  is  bit-identical  to  CE31's  recorded  g_b31
         ball  (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE32  =  3 000 175 482 330,
      tCE32  −  tCE31  =  4 673   (face  shrink  past
      tCE31  -  the  running  pattern),
      tCE32  −  tPT2  = 149 530  (above  the  Platt-Trudgian
      H0;  the  125 000-unit  mark  crossed  at  CE27  remains
      crossed;  the  NEXT  ROUND  MARK  150 000  SITS  470
      UNITS  AHEAD  -  WINDOW  33  IS  EXPECTED  TO  CROSS
      IT),
      certified  zeros  over  (g_a1,  g_b32]  =  619 991  +
      20 000  =  639 991.
  HONESTY  (trust  base):  as  CE2-CE31  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE32

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b32  (the  recorded  ball  is
    3 000 175 482 330.396285214541  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~6.3e-3).  -/
def gB32Lo : ℚ := 300017548233039 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB32Lo:
    tCE32  =  3 000 175 482 330.  -/
def tCE32 : ℕ := 3000175482330

theorem tCE32_lt_gB32Lo : (tCE32 : ℝ) < (gB32Lo : ℝ) := by
  norm_num [gB32Lo, tCE32]

theorem tCE31_lt_tCE32 : (tCE31 : ℝ) < (tCE32 : ℝ) := by
  norm_num [CE31.tCE31, tCE32]

/-- Record:  the  seam  order  gB31Lo  <  tCE32  (the  band
    (gB31Lo,  tCE32]  is  nonempty  and  lies  above  CE31's
    frontier  tCE31).  -/
theorem gB31Lo_lt_tCE32 : (gB31Lo : ℝ) < (tCE32 : ℝ) := by
  norm_num [CE31.gB31Lo, tCE32]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE31  (the  running  pattern).  -/
theorem faceShrinkCE32 : (tCE32 : ℝ) - (tCE31 : ℝ) = 4673 := by
  norm_num [tCE32, CE31.tCE31]

/-- MILESTONE  (machine):  the  new  frontier  is  149 530
    units  above  the  Platt-Trudgian  frontier  H0  (the
    125 000-unit  mark  crossed  at  CE27  remains  crossed;
    the  next  round  mark  150 000  sits  470  units  ahead
    -  window  33  is  expected  to  cross  it).  -/
theorem frontierGapAboveH0 : (tCE32 : ℝ) - WinC.tPT2 = 149530 := by
  norm_num [tCE32, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE32  −  tPT2  =  149 530
    exceeds  125 000.  -/
theorem frontierPast125k : (tCE32 : ℝ) - WinC.tPT2 > 125000 := by
  have h : (tCE32 : ℝ) - WinC.tPT2 = 149530 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB30Lo  <  gB31Lo  (re-stated  at  the  CE32  level  from
    CE31's  window-31  band  ordering).  -/
theorem gB30Lo_lt_gB31Lo : (gB30Lo : ℝ) < (gB31Lo : ℝ) := by
  norm_num [CE30.gB30Lo, CE31.gB31Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB31Lo  <  gB32Lo)  -  the  window-32  band  (gB31Lo,
    gB32Lo]  (hence  (gB31Lo,  tCE32])  lies  strictly  above
    window  31's  certified  region.  -/
theorem gB31Lo_lt_gB32Lo : (gB31Lo : ℝ) < (gB32Lo : ℝ) := by
  norm_num [CE31.gB31Lo, gB32Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-31  RUN  (window31_b31.json),  FULL
    SLICE]  every  zeta  zero  with  gB30Lo  <  Im  ρ  <=
    gB31Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB30Lo,  gB31Lo]  lies  inside  (g_a31,
    g_b31]  -  window  31's  own  certified  region  (the
    SNAPPED  width:  b31  −  a31  =  19 999)  -  since  gB30Lo
    is  the  certified  bottom  of  g_a31  (=  g_b30,
    bit-identical  dyadic  ball  in  windows  30  and  31)
    and  gB31Lo  the  certified  bottom  of  g_b31
    (machine:  gB30Lo  <  gB31Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce31WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB30Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB31Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-32  RUN  (window32_b32.json),  SLICE]
    every  zeta  zero  with  gB31Lo  <  Im  ρ  <=  tCE32  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB31Lo,  tCE32],  either  t0  <=  g_b31
    (the  true  Gram  point  -  g_a32  =  g_b31,  recorded  exact
    dyadic  ball  3 000 175 477 657.461158340877  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a32  =  g_a31  <  gB31Lo  <  g_b31
    puts  t0  in  window  31's  region  (g_a31,  g_b31])  -
    or  t0  >  g_b31  =  g_a32,  in  which  case  t0  <=  tCE32
    <  gB32Lo  <=  g_b32  puts  t0  in  window  32's  region
    (g_a32,  g_b32].  The  two  certified  regions  union  to
    (g_a31,  g_b32]  which  contains  (gB31Lo,  tCE32]
    (machine:  gB31Lo  <  tCE32  <  gB32Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce32WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB31Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE32 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE32]  are  on  the  line,  given  the
    thirty-two  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  ...,  gB30Lo,  gB31Lo  are  pure  case  splits.  -/
theorem bandOfWindows32 (h1 : CE2.ce1WinClause)
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
    (h30 : CE31.ce30WinClauseFull) (h31 : ce31WinClauseFull)
    (h32 : ce32WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE32 : ℝ) → ρ.re = 1 / 2 := by
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
                                                              · exact h32 ρ hz (not_le.mp hseam31) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (thirty-second  run):
    [Z-PT2]  +  the  thirty-two  cited  window  clauses  =>
    the  on-line  census  holds  up  to  tCE32.  -/
theorem allOnLineUpToCE32 (q : ZeroSet)
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
    (hW29 : CE30.ce29WinClauseFull) (hW30 : CE31.ce30WinClauseFull)
    (hW31 : ce31WinClauseFull) (hW32 : ce32WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE32 : ℝ) := by
  have hband := bandOfWindows32 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (thirty-second  run):  no
    off-line  zero  with  positive  height  above  tCE32.  -/
def terminalFaceCE32 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE32 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE31  face  implies  the  CE32  face
    (tCE32  >  tCE31).  -/
theorem faceCE31_implies_faceCE32 (q : ZeroSet)
    (hface : CE31.terminalFaceCE31 q) :
    terminalFaceCE32 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE31_lt_tCE32, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE31,  tCE32]  is  certified
    empty  (windows  31+32  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE32_iff_faceCE31 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW31 : ce31WinClauseFull) (hW32 : ce32WinClause) :
    terminalFaceCE32 q ↔ CE31.terminalFaceCE31 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE32 : ℝ)
    · by_cases hseam31 : ρ.im ≤ (gB31Lo : ℝ)
      · exact hW31 ρ (hqz ρ hρ) (by linarith [ht, gB30Lo_lt_tCE31, tCE31_lt_tCE32]) hseam31
      · exact hW32 ρ (hqz ρ hρ) (not_le.mp hseam31) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE31_implies_faceCE32 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE32
    (pure  logic).  -/
theorem rh_split_at_CE32 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE32 : ℝ) ∧ terminalFaceCE32 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE32 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE32 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (thirty-two-window  chain):  given
    [Z-PT2]  +  the  thirty-two  cited  window  clauses
    ([CE1-WIN],  [CE2-WIN-FULL],  ...,  [CE31-WIN-FULL],
    [CE32-WIN]),  all-heights  RH  <->  terminalFaceCE32.
    NO  RH  CLAIM.  -/
theorem rh_reanchored_CE32 (q : ZeroSet)
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
    (hW29 : CE30.ce29WinClauseFull) (hW30 : CE31.ce30WinClauseFull)
    (hW31 : ce31WinClauseFull) (hW32 : ce32WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE32 q := by
  have hcensus := allOnLineUpToCE32 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hqz
  have hsplit := rh_split_at_CE32 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE32 (q : ZeroSet)
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
    (hW29 : CE30.ce29WinClauseFull) (hW30 : CE31.ce30WinClauseFull)
    (hW31 : ce31WinClauseFull) (hW32 : ce32WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE32 q) :
    RH q :=
  (rh_reanchored_CE32 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hW31 hW32 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE32_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE32 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE32
