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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23 CE24
open scoped Topology

/-!
**CE25 — the terminal face re-anchored at the TWENTY-FIFTH
certified  window  (0330,  option  B,  unit  41  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  25).  MILESTONE:  the
25-window  chain  is  complete  —  499 992  certified  on-line
zeros  over  (g_a1,  g_b25],  i.e.  within  eight  of  the
half-million  mark.**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE24):
  RUN  PARAMETERS:  a  =  12 363 153 917 122  (=  CE24's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 937 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 817  evaluations  in  2561.0  s.
  CERTIFICATE  (window25_b25.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a25  <  Im  s  <=  g_b25  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a25  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 444 947.148909403387  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE24's
            recorded  g_b24  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b25  =  3 000 175 449 620.084038171608  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE25  sits  0.0840  above  the  previous
               integer  -  CLOSE  to  the  CE18  CASING  zone
               (frac  0.0054),  BUT  the  two-decimal  lower
               bound  0.08  is  still  strictly  below  with
               margin  4.0e-3  —  far  above  the  certified
               radius  of  1.29e-26  by  22  orders  of
               magnitude  —  so  the  standard  two-decimal
               bound  is  adequate  here;  the  CASING  rule
               (use  3  decimals)  only  triggers  when  the
               two-decimal  round-down  would  equal  the
               floor,  i.e.  frac  <  0.01).
      Turing  runs  of  consecutive  good  Rosser  blocks:  47
      left  of  g_a25,  46  right  of  g_b25  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 817  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  rosser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10,  12,  13,  14,  16,  18,  22;  the
      clean  tally  is  now  TEN  of  twenty-five).
  VERIFICATION  (three  layers,  same  as  CE2-CE24):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window25_b25.json:
         "CERTIFIED:  true",  points_checked  = 33 817,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a25  ball
         is  bit-identical  to  CE24's  recorded  g_b24  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE25  =  3 000 175 449 620,
      tCE25  −  tCE24  =  4 673   (face  shrink  past  tCE24),
      tCE25  −  tPT2  = 116 820  (above  the  Platt-Trudgian
      H0;  the  100 000-unit  mark  marked  at  CE22  remains
      crossed),
      certified  zeros  over  (g_a1,  g_b25]  =  479 992  +
      20 000  =  499 992.
  HONESTY  (trust  base):  as  CE2-CE24  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE25

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b25  (the  recorded  ball  is
    3 000 175 449 620.084038171608  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  4.0e-3  -  see  the  CASING  note  in
    the  file  header:  the  frac  (0.0840)  is  above  the
    0.01  CASING  threshold,  so  the  two-decimal  bound  is
    adequate  and  strictly  below  the  certified  value).  -/
def gB25Lo : ℚ := 300017544962008 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB25Lo:
    tCE25  =  3 000 175 449 620.  -/
def tCE25 : ℕ := 3000175449620

theorem tCE25_lt_gB25Lo : (tCE25 : ℝ) < (gB25Lo : ℝ) := by
  norm_num [gB25Lo, tCE25]

theorem tCE24_lt_tCE25 : (tCE24 : ℝ) < (tCE25 : ℝ) := by
  norm_num [CE24.tCE24, tCE25]

/-- Record:  the  seam  order  gB24Lo  <  tCE25  (the  band
    (gB24Lo,  tCE25]  is  nonempty  and  lies  above  CE24's
    frontier  tCE24).  -/
theorem gB24Lo_lt_tCE25 : (gB24Lo : ℝ) < (tCE25 : ℝ) := by
  norm_num [CE24.gB24Lo, tCE25]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE24.  -/
theorem faceShrinkCE25 : (tCE25 : ℝ) - (tCE24 : ℝ) = 4673 := by
  norm_num [tCE25, CE24.tCE24]

/-- MILESTONE  (machine):  the  new  frontier  is  116 820
    units  above  the  Platt-Trudgian  frontier  H0  (the
    100 000-unit  mark  crossed  at  CE22  remains  crossed;
    the  125 000-unit  mark  is  8 180  units  away).  -/
theorem frontierGapAboveH0 : (tCE25 : ℝ) - WinC.tPT2 = 116820 := by
  norm_num [tCE25, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE25  −  tPT2  =  116 820
    exceeds  100 000.  -/
theorem frontierPast100k : (tCE25 : ℝ) - WinC.tPT2 > 100000 := by
  have h : (tCE25 : ℝ) - WinC.tPT2 = 116820 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB23Lo  <  gB24Lo  (re-stated  at  the  CE25  level  from
    CE24's  window-24  band  ordering).  -/
theorem gB23Lo_lt_gB24Lo : (gB23Lo : ℝ) < (gB24Lo : ℝ) := by
  norm_num [CE23.gB23Lo, CE24.gB24Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB24Lo  <  gB25Lo)  -  the  window-25  band  (gB24Lo,
    gB25Lo]  (hence  (gB24Lo,  tCE25])  lies  strictly  above
    window  24's  certified  region.  -/
theorem gB24Lo_lt_gB25Lo : (gB24Lo : ℝ) < (gB25Lo : ℝ) := by
  norm_num [CE24.gB24Lo, gB25Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-24  RUN  (window24_b24.json),  FULL
    SLICE]  every  zeta  zero  with  gB23Lo  <  Im  ρ  <=
    gB24Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB23Lo,  gB24Lo]  lies  inside  (g_a24,
    g_b24]  -  window  24's  own  certified  region  -  since
    gB23Lo  is  the  certified  bottom  of  g_a24  (=  g_b23,
    bit-identical  dyadic  ball  in  windows  23  and  24)  and
    gB24Lo  the  certified  bottom  of  g_b24  (machine:
    gB23Lo  <  gB24Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce24WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB23Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB24Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-25  RUN  (window25_b25.json),  SLICE]
    every  zeta  zero  with  gB24Lo  <  Im  ρ  <=  tCE25  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB24Lo,  tCE25],  either  t0  <=  g_b24
    (the  true  Gram  point  -  g_a25  =  g_b24,  recorded  exact
    dyadic  ball  3 000 175 444 947.148909403387  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a25  =  g_a24  <  gB24Lo  <  g_b24
    puts  t0  in  window  24's  region  (g_a24,  g_b24])  -
    or  t0  >  g_b24  =  g_a25,  in  which  case  t0  <=  tCE25
    <  gB25Lo  <=  g_b25  puts  t0  in  window  25's  region
    (g_a25,  g_b25].  The  two  certified  regions  union  to
    (g_a24,  g_b25]  which  contains  (gB24Lo,  tCE25]
    (machine:  gB24Lo  <  tCE25  <  gB25Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce25WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB24Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE25 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE25]  are  on  the  line,  given  the
    twenty-five  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo,  gB23Lo,  gB24Lo  are  pure  case
    splits.  -/
theorem bandOfWindows25 (h1 : CE2.ce1WinClause)
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
    (h24 : ce24WinClauseFull) (h25 : ce25WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE25 : ℝ) → ρ.re = 1 / 2 := by
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
                                                · exact h25 ρ hz (not_le.mp hseam24) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN  (25-window  chain):
    [Z-PT2]  +  the  twenty-five  cited  window  clauses  =>
    the  on-line  census  holds  up  to  tCE25.  -/
theorem allOnLineUpToCE25 (q : ZeroSet)
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
    (hW23 : CE24.ce23WinClauseFull) (hW24 : ce24WinClauseFull)
    (hW25 : ce25WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE25 : ℝ) := by
  have hband := bandOfWindows25 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-fifth  run):  no
    off-line  zero  with  positive  height  above  tCE25.  -/
def terminalFaceCE25 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE25 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE24  face  implies  the  CE25  face
    (tCE25  >  tCE24).  -/
theorem faceCE24_implies_faceCE25 (q : ZeroSet)
    (hface : CE24.terminalFaceCE24 q) :
    terminalFaceCE25 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE24_lt_tCE25, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE24,  tCE25]  is  certified
    empty  (windows  24+25  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE25_iff_faceCE24 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW24 : ce24WinClauseFull) (hW25 : ce25WinClause) :
    terminalFaceCE25 q ↔ CE24.terminalFaceCE24 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE25 : ℝ)
    · by_cases hseam24 : ρ.im ≤ (gB24Lo : ℝ)
      · exact hW24 ρ (hqz ρ hρ) (by linarith [ht, gB23Lo_lt_tCE24, tCE24_lt_tCE25]) hseam24
      · exact hW25 ρ (hqz ρ hρ) (not_le.mp hseam24) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE24_implies_faceCE25 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE25
    (pure  logic).  -/
theorem rh_split_at_CE25 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE25 : ℝ) ∧ terminalFaceCE25 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE25 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE25 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE  (25-window  chain):  given  [Z-PT2]  +
    the  twenty-five  cited  window  clauses  ([CE1-WIN],
    [CE2-WIN-FULL],  ...,  [CE24-WIN-FULL],  [CE25-WIN]),
    all-heights  RH  <->  terminalFaceCE25.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE25 (q : ZeroSet)
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
    (hW23 : CE24.ce23WinClauseFull) (hW24 : ce24WinClauseFull)
    (hW25 : ce25WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE25 q := by
  have hcensus := allOnLineUpToCE25 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hqz
  have hsplit := rh_split_at_CE25 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE25 (q : ZeroSet)
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
    (hW23 : CE24.ce23WinClauseFull) (hW24 : ce24WinClauseFull)
    (hW25 : ce25WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE25 q) :
    RH q :=
  (rh_reanchored_CE25 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hW25 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE25_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE25 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE25
