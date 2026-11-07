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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20 CE21 CE22 CE23
open scoped Topology

/-!
**CE24 — the terminal face re-anchored at the TWENTY-FOURTH
certified  window  (0329,  option  B,  unit  40  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  24).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE23):
  RUN  PARAMETERS:  a  =  12 363 153 897 122  (=  CE23's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 917 122
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 110  evaluations  in  2460.5  s.
  CERTIFICATE  (window24_b24.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a24  <  Im  s  <=  g_b24  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a24  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 440 274.213780364512  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE23's
            recorded  g_b23  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b24  =  3 000 175 444 947.148909403387  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE24  sits  0.1489  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  47
      left  of  g_a24,  53  right  of  g_b24  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 110  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        block  [12 363 153 899 400,  .. 899 402]  rescued  to
        union  [.. 899 397,  .. 899 404],  need  7  =  found
        7,  m  =  2.  As  in  the  other  rescued  windows,
        the  rescued  zero  was  DISPLACED  into  an  adjacent
        Gram  interval;  the  independent  verifier
        recomputes  the  WINDOW  TOTAL  (sign_changes_inside
        =  20 000)  and  the  two  end  Rosser  runs  (47  /
        53)  -  the  only  quantities  that  enter  the  Turing
        step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE23):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window24_b24.json:
         "CERTIFIED:  true",  points_checked  = 33 110,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  = 12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a24  ball
         is  bit-identical  to  CE23's  recorded  g_b23  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE24  =  3 000 175 444 947,
      tCE24  −  tCE23  =  4 673   (face  shrink  past  tCE23),
      tCE24  −  tPT2  = 112 147  (above  the  Platt-Trudgian
      H0;  the  100 000-unit  mark  marked  at  CE22  remains
      crossed),
      certified  zeros  over  (g_a1,  g_b24]  =  459 992  +
      20 000  =  479 992.
  HONESTY  (trust  base):  as  CE2-CE23  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE24

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b24  (the  recorded  ball  is
    3 000 175 444 947.148909403387  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~8.9e-3).  -/
def gB24Lo : ℚ := 300017544494714 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB24Lo:
    tCE24  =  3 000 175 444 947.  -/
def tCE24 : ℕ := 3000175444947

theorem tCE24_lt_gB24Lo : (tCE24 : ℝ) < (gB24Lo : ℝ) := by
  norm_num [gB24Lo, tCE24]

theorem tCE23_lt_tCE24 : (tCE23 : ℝ) < (tCE24 : ℝ) := by
  norm_num [CE23.tCE23, tCE24]

/-- Record:  the  seam  order  gB23Lo  <  tCE24  (the  band
    (gB23Lo,  tCE24]  is  nonempty  and  lies  above  CE23's
    frontier  tCE23).  -/
theorem gB23Lo_lt_tCE24 : (gB23Lo : ℝ) < (tCE24 : ℝ) := by
  norm_num [CE23.gB23Lo, tCE24]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE23.  -/
theorem faceShrinkCE24 : (tCE24 : ℝ) - (tCE23 : ℝ) = 4673 := by
  norm_num [tCE24, CE23.tCE23]

/-- The  new  frontier  is  112 147  units  above  the
    Platt-Trudgian  frontier  H0  (machine;  the  100 000-unit
    mark  crossed  at  CE22  remains  crossed).  -/
theorem frontierGapAboveH0 : (tCE24 : ℝ) - WinC.tPT2 = 112147 := by
  norm_num [tCE24, WinC.tPT2]

/-- MILESTONE  CARRY  (machine):  tCE24  −  tPT2  =  112 147
    exceeds  100 000.  -/
theorem frontierPast100k : (tCE24 : ℝ) - WinC.tPT2 > 100000 := by
  have h : (tCE24 : ℝ) - WinC.tPT2 = 112147 := frontierGapAboveH0
  linarith [h]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB22Lo  <  gB23Lo  (re-stated  at  the  CE24  level  from
    CE23's  window-23  band  ordering).  -/
theorem gB22Lo_lt_gB23Lo : (gB22Lo : ℝ) < (gB23Lo : ℝ) := by
  norm_num [CE22.gB22Lo, CE23.gB23Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB23Lo  <  gB24Lo)  -  the  window-24  band  (gB23Lo,
    gB24Lo]  (hence  (gB23Lo,  tCE24])  lies  strictly  above
    window  23's  certified  region.  -/
theorem gB23Lo_lt_gB24Lo : (gB23Lo : ℝ) < (gB24Lo : ℝ) := by
  norm_num [CE23.gB23Lo, gB24Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-23  RUN  (window23_b23.json),  FULL
    SLICE]  every  zeta  zero  with  gB22Lo  <  Im  ρ  <=
    gB23Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB22Lo,  gB23Lo]  lies  inside  (g_a23,
    g_b23]  -  window  23's  own  certified  region  -  since
    gB22Lo  is  the  certified  bottom  of  g_a23  (=  g_b22,
    bit-identical  dyadic  ball  in  windows  22  and  23)  and
    gB23Lo  the  certified  bottom  of  g_b23  (machine:
    gB22Lo  <  gB23Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce23WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB22Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB23Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-24  RUN  (window24_b24.json),  SLICE]
    every  zeta  zero  with  gB23Lo  <  Im  ρ  <=  tCE24  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB23Lo,  tCE24],  either  t0  <=  g_b23
    (the  true  Gram  point  -  g_a24  =  g_b23,  recorded  exact
    dyadic  ball  3 000 175 440 274.213780364512  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a24  =  g_a23  <  gB23Lo  <  g_b23
    puts  t0  in  window  23's  region  (g_a23,  g_b23])  -
    or  t0  >  g_b23  =  g_a24,  in  which  case  t0  <=  tCE24
    <  gB24Lo  <=  g_b24  puts  t0  in  window  24's  region
    (g_a24,  g_b24].  The  two  certified  regions  union  to
    (g_a23,  g_b24]  which  contains  (gB23Lo,  tCE24]
    (machine:  gB23Lo  <  tCE24  <  gB24Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce24WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB23Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE24 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE24]  are  on  the  line,  given  the
    twenty-four  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo,
    gB21Lo,  gB22Lo,  gB23Lo  are  pure  case  splits.  -/
theorem bandOfWindows24 (h1 : CE2.ce1WinClause)
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
    (h22 : CE23.ce22WinClauseFull) (h23 : ce23WinClauseFull)
    (h24 : ce24WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE24 : ℝ) → ρ.re = 1 / 2 := by
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
                                              · exact h24 ρ hz (not_le.mp hseam23) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    twenty-four  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE24.  -/
theorem allOnLineUpToCE24 (q : ZeroSet)
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
    (hW23 : ce23WinClauseFull) (hW24 : ce24WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE24 : ℝ) := by
  have hband := bandOfWindows24 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-fourth  run):  no
    off-line  zero  with  positive  height  above  tCE24.  -/
def terminalFaceCE24 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE24 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE23  face  implies  the  CE24  face
    (tCE24  >  tCE23).  -/
theorem faceCE23_implies_faceCE24 (q : ZeroSet)
    (hface : CE23.terminalFaceCE23 q) :
    terminalFaceCE24 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE23_lt_tCE24, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE23,  tCE24]  is  certified
    empty  (windows  23+24  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE24_iff_faceCE23 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW23 : ce23WinClauseFull) (hW24 : ce24WinClause) :
    terminalFaceCE24 q ↔ CE23.terminalFaceCE23 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE24 : ℝ)
    · by_cases hseam23 : ρ.im ≤ (gB23Lo : ℝ)
      · exact hW23 ρ (hqz ρ hρ) (by linarith [ht, gB22Lo_lt_tCE23, tCE23_lt_tCE24]) hseam23
      · exact hW24 ρ (hqz ρ hρ) (not_le.mp hseam23) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE23_implies_faceCE24 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE24
    (pure  logic).  -/
theorem rh_split_at_CE24 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE24 : ℝ) ∧ terminalFaceCE24 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE24 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE24 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-four
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE23-WIN-FULL],  [CE24-WIN]),  all-heights  RH  <->
    terminalFaceCE24.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE24 (q : ZeroSet)
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
    (hW23 : ce23WinClauseFull) (hW24 : ce24WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE24 q := by
  have hcensus := allOnLineUpToCE24 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hqz
  have hsplit := rh_split_at_CE24 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE24 (q : ZeroSet)
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
    (hW23 : ce23WinClauseFull) (hW24 : ce24WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE24 q) :
    RH q :=
  (rh_reanchored_CE24 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hW22 hW23 hW24 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE24_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE24 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE24
