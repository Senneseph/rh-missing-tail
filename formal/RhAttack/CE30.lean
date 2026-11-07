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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24 CE25 CE26 CE27 CE28 CE29
open scoped Topology

/-!
**CE30 — the terminal face re-anchored at the THIRTIETH
certified  window  (0335,  option  B,  unit  46  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  30).  MILESTONE:  the
30-window  chain  is  complete  -  599 992  certified
on-line  zeros  over  (g_a1,  g_b30],  within  EIGHT  of
the  600 000 mark.  And  a  CLEAN  window  (zero  Rosser
exceptions,  zero  rescue  failures)  -  the  eleventh  in
the  chain,  and  the  first  clean  window  since  window
25 (the  multi-exception  windows  28  and  29  are  over,
and  the  lane  has  returned  to  clean  behavior).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE29):
  RUN  PARAMETERS:  a  =  12 363 154 017 122  (=  CE29's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 154 037 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  32 841  evaluations  in  2492.9  s.
  CERTIFICATE  (window30_b30.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a30  <  Im  s  <=  g_b30  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a30  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 468 311.824550537966  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE29's
            recorded  g_b29  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b30  =  3 000 175 472 984.759677952923  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE30  sits  0.7597  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude;  the  face
               shrink  came  out  as  the  running  4 673).
      Turing  runs  of  consecutive  good  Rosser  blocks:  47
      left  of  g_a30,  52  right  of  g_b30  (both  >=  K  =
      12);  0  cross-check  failures  (all  32 841  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window
      (as  windows  6,  8,  10,  12,  13,  14,  16,  18,  22
      and  25;  the  clean  tally  is  now  ELEVEN  of
      thirty).
  VERIFICATION  (three  layers,  same  as  CE2-CE29):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window30_b30.json:
         "CERTIFIED:  true",  points_checked  = 32 841,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a30  ball
         is  bit-identical  to  CE29's  recorded  g_b29  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE30  =  3 000 175 472 984,
      tCE30  −  tCE29  =  4 673   (face  shrink  past
      tCE29  -  the  running  pattern),
      tCE30  −  tPT2  = 140 184  (above  the  Platt-Trudgian
      H0;  the  125 000-unit  mark  crossed  at  CE27  remains
      crossed;  the  next  round  mark  150 000  is  9 816
      units  away,  i.e.  ~2  windows  out),
      certified  zeros  over  (g_a1,  g_b30]  =  579 992  +
      20 000  =  599 992.
  HONESTY  (trust  base):  as  CE2-CE29  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE30

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b30  (the  recorded  ball  is
    3 000 175 472 984.759677952923  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~5.97e-3).  -/
def gB30Lo : ℚ := 300017547298475 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB30Lo:
    tCE30  =  3 000 175 472 984.  -/
def tCE30 : ℕ := 3000175472984

theorem tCE30_lt_gB30Lo : (tCE30 : ℝ) < (gB30Lo : ℝ) := by
  norm_num [gB30Lo, tCE30]

theorem tCE29_lt_tCE30 : (tCE29 : ℝ) < (tCE30 : ℝ) := by
  norm_num [CE29.tCE29, tCE30]

/-- Record:  the  seam  order  gB29Lo  <  tCE30  (the  band
    (gB29Lo,  tCE30]  is  nonempty  and  lies  above  CE29's
    frontier  tCE29).  -/
theorem gB29Lo_lt_tCE30 : (gB29Lo : ℝ) < (tCE30 : ℝ) := by
  norm_num [CE29.gB29Lo, tCE30]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE29  (the  running  pattern).  -/
theorem faceShrinkCE30 : (tCE30 : ℝ) - (tCE29 : ℝ) = 4673 := by
  norm_num [tCE30, CE29.tCE29]

/-- MILESTONE  (machine):  the  new  frontier  is  140 184
    units  above  the  Platt-Trudgian  frontier  H0  (the
    125 000-unit  mark  crossed  at  CE27  remains  crossed;
    the  next  round  mark  150 000  is  9 816  units  away,
    i.e.  ~2  windows  out).  -/
theorem frontierGapAboveH0 : (tCE30 : ℝ) - WinC.tPT2 = 140184 := by
  norm_num [tCE30, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE30  −  tPT2  =  140 184
    exceeds  125 000.  -/
theorem frontierPast125k : (tCE30 : ℝ) - WinC.tPT2 > 125000 := by
  have h : (tCE30 : ℝ) - WinC.tPT2 = 140184 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB28Lo  <  gB29Lo  (re-stated  at  the  CE30  level  from
    CE29's  window-29  band  ordering).  -/
theorem gB28Lo_lt_gB29Lo : (gB28Lo : ℝ) < (gB29Lo : ℝ) := by
  norm_num [CE28.gB28Lo, CE29.gB29Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB29Lo  <  gB30Lo)  -  the  window-30  band  (gB29Lo,
    gB30Lo]  (hence  (gB29Lo,  tCE30])  lies  strictly  above
    window  29's  certified  region.  -/
theorem gB29Lo_lt_gB30Lo : (gB29Lo : ℝ) < (gB30Lo : ℝ) := by
  norm_num [CE29.gB29Lo, gB30Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-29  RUN  (window29_b29.json),  FULL
    SLICE]  every  zeta  zero  with  gB28Lo  <  Im  ρ  <=
    gB29Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB28Lo,  gB29Lo]  lies  inside  (g_a29,
    g_b29]  -  window  29's  own  certified  region  -  since
    gB28Lo  is  the  certified  bottom  of  g_a29  (=  g_b28,
    bit-identical  dyadic  ball  in  windows  28  and  29)
    and  gB29Lo  the  certified  bottom  of  g_b29
    (machine:  gB28Lo  <  gB29Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce29WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB28Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB29Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-30  RUN  (window30_b30.json),  SLICE]
    every  zeta  zero  with  gB29Lo  <  Im  ρ  <=  tCE30  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB29Lo,  tCE30],  either  t0  <=  g_b29
    (the  true  Gram  point  -  g_a30  =  g_b29,  recorded  exact
    dyadic  ball  3 000 175 468 311.824550537966  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a30  =  g_a29  <  gB29Lo  <  g_b29
    puts  t0  in  window  29's  region  (g_a29,  g_b29])  -
    or  t0  >  g_b29  =  g_a30,  in  which  case  t0  <=  tCE30
    <  gB30Lo  <=  g_b30  puts  t0  in  window  30's  region
    (g_a30,  g_b30].  The  two  certified  regions  union  to
    (g_a29,  g_b30]  which  contains  (gB29Lo,  tCE30]
    (machine:  gB29Lo  <  tCE30  <  gB30Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce30WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB29Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE30 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE30]  are  on  the  line,  given  the
    thirty  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo,  gB23Lo,  gB24Lo,  gB25Lo,  gB26Lo,
    gB27Lo,  gB28Lo,  gB29Lo  are  pure  case  splits.  -/
theorem bandOfWindows30 (h1 : CE2.ce1WinClause)
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
    (h28 : CE29.ce28WinClauseFull) (h29 : ce29WinClauseFull)
    (h30 : ce30WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE30 : ℝ) → ρ.re = 1 / 2 := by
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
                                                          · exact h30 ρ hz (not_le.mp hseam29) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (30-window  chain):
    [Z-PT2]  +  the  thirty  cited  window  clauses  =>  the
    on-line  census  holds  up  to  tCE30.  -/
theorem allOnLineUpToCE30 (q : ZeroSet)
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
    (hW29 : ce29WinClauseFull) (hW30 : ce30WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE30 : ℝ) := by
  have hband := bandOfWindows30 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (thirtieth  run):  no
    off-line  zero  with  positive  height  above  tCE30.  -/
def terminalFaceCE30 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE30 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE29  face  implies  the  CE30  face
    (tCE30  >  tCE29).  -/
theorem faceCE29_implies_faceCE30 (q : ZeroSet)
    (hface : CE29.terminalFaceCE29 q) :
    terminalFaceCE30 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE29_lt_tCE30, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE29,  tCE30]  is  certified
    empty  (windows  29+30  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE30_iff_faceCE29 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW29 : ce29WinClauseFull) (hW30 : ce30WinClause) :
    terminalFaceCE30 q ↔ CE29.terminalFaceCE29 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE30 : ℝ)
    · by_cases hseam29 : ρ.im ≤ (gB29Lo : ℝ)
      · exact hW29 ρ (hqz ρ hρ) (by linarith [ht, gB28Lo_lt_tCE29, tCE29_lt_tCE30]) hseam29
      · exact hW30 ρ (hqz ρ hρ) (not_le.mp hseam29) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE29_implies_faceCE30 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE30
    (pure  logic).  -/
theorem rh_split_at_CE30 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE30 : ℝ) ∧ terminalFaceCE30 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE30 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE30 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (30-window  chain):  given  [Z-PT2]  +
    the  thirty  cited  window  clauses  ([CE1-WIN],
    [CE2-WIN-FULL],  ...,  [CE29-WIN-FULL],  [CE30-WIN]),
    all-heights  RH  <->  terminalFaceCE30.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE30 (q : ZeroSet)
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
    (hW29 : ce29WinClauseFull) (hW30 : ce30WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE30 q := by
  have hcensus := allOnLineUpToCE30 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hqz
  have hsplit := rh_split_at_CE30 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of
    the  re-anchored  face,  all-heights  RH  holds.  NO  RH
    CLAIM:  no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE30 (q : ZeroSet)
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
    (hW29 : ce29WinClauseFull) (hW30 : ce30WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE30 q) :
    RH q :=
  (rh_reanchored_CE30 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hW26 hW27 hW28 hW29 hW30 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE30_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE30 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE30
