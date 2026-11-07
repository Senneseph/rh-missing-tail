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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18
open scoped Topology

/-!
**CE19 — the terminal face re-anchored at the NINETEENTH
certified  window  (0324,  option  B,  unit  35  —  lane  M5,
run  19:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  19).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE18):
  RUN  PARAMETERS:  a  =  12 363 153 797 124  (=  CE18's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 817 124,  driver  snapped  the  final  b  DOWN  to
  12 363 153 817 123  (12 363 153 817 124  was  not  a  good
  Gram  point  at  the  working  precision;  a  itself  needed
  NO  snap),  M  =  60,  C_R  =  1,  28  workers,  33 237
  evaluations  in  2476.0  s.
  CERTIFICATE  (window19_b19.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a19  <  Im  s  <=  g_b19  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a19  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 416 910.005424623397  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE18's
            recorded  g_b18  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b19  =  3 000 175 421 582.706908258997  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE19  sits  0.7069  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  47
      left  of  g_a19,  45  right  of  g_b19  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 237  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  3-BLOCK  UNION  REFINEMENT  (window.py):
        block  [12 363 153 798 332,  .. 798 334]  rescued  to
        union  [.. 798 331,  .. 798 335],  need  4  =  found
        4,  m  =  4.  As  in  windows
        2/3/4/5/7/9/11/15/17,  the  rescued  zero  was
        DISPLACED  into  an  adjacent  Gram  interval;  the
        independent  verifier  recomputes  the  WINDOW  TOTAL
        (sign_changes_inside  =  19 999)  and  the  two  end
        Rosser  runs  (47  /  45)  -  the  only  quantities  that
        enter  the  Turing  step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE18):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window19_b19.json:
         "CERTIFIED:  true",  points_checked  = 33 237,
         sign_changes_inside  =  19 999  =  b  −  a,
         roesser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a19  ball
         is  bit-identical  to  CE18's  recorded  g_b18  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE19  =  3 000 175 421 582,
      tCE19  −  tCE18  =  4 672   (face  shrink  past  tCE18;
                            4 672  here,  not  4 673,  because
                            this  window  carried  19 999
                            zeros,  not  20 000  -  the  final
                            b  was  snapped  down  one),
      tCE19  −  tPT2  = 88 782  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b19]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  +  20 000  +  20 000  +
      19 999  +  19 999  +  19 999  =  379 993.
  HONESTY  (trust  base):  as  CE2-CE18  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE19

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b19  (the  recorded  ball  is
    3 000 175 421 582.706908258997  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~6.9e-3).  -/
def gB19Lo : ℚ := 300017542158270 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB19Lo:
    tCE19  =  3 000 175 421 582.  -/
def tCE19 : ℕ := 3000175421582

theorem tCE19_lt_gB19Lo : (tCE19 : ℝ) < (gB19Lo : ℝ) := by
  norm_num [gB19Lo, tCE19]

theorem tCE18_lt_tCE19 : (tCE18 : ℝ) < (tCE19 : ℝ) := by
  norm_num [CE18.tCE18, tCE19]

/-- Record:  the  seam  order  gB18Lo  <  tCE19  (the  band
    (gB18Lo,  tCE19]  is  nonempty  and  lies  above  CE18's
    frontier  tCE18).  -/
theorem gB18Lo_lt_tCE19 : (gB18Lo : ℝ) < (tCE19 : ℝ) := by
  norm_num [CE18.gB18Lo, tCE19]

/-- The  face  height  shrunk  by  further  4 672  units  past
    tCE18  (4 672  here,  not  4 673:  this  window  carried
    19 999  zeros;  the  final  b  was  snapped  down  one).  -/
theorem faceShrinkCE19 : (tCE19 : ℝ) - (tCE18 : ℝ) = 4672 := by
  norm_num [tCE19, CE18.tCE18]

/-- The  new  frontier  is  88 782  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE19 : ℝ) - WinC.tPT2 = 88782 := by
  norm_num [tCE19, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB17Lo  <  gB18Lo  (re-stated  at  the  CE19  level  from
    CE18's  window-18  band  ordering).  -/
theorem gB17Lo_lt_gB18Lo : (gB17Lo : ℝ) < (gB18Lo : ℝ) := by
  norm_num [CE17.gB17Lo, CE18.gB18Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB18Lo  <  gB19Lo)  -  the  window-19  band  (gB18Lo,
    gB19Lo]  (hence  (gB18Lo,  tCE19])  lies  strictly  above
    window  18's  certified  region.  -/
theorem gB18Lo_lt_gB19Lo : (gB18Lo : ℝ) < (gB19Lo : ℝ) := by
  norm_num [CE18.gB18Lo, gB19Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-18  RUN  (window18_b18.json),  FULL
    SLICE]  every  zeta  zero  with  gB17Lo  <  Im  ρ  <=
    gB18Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB17Lo,  gB18Lo]  lies  inside  (g_a18,
    g_b18]  -  window  18's  own  certified  region  -  since
    gB17Lo  is  the  certified  bottom  of  g_a18  (=  g_b17,
    bit-identical  dyadic  ball  in  windows  17  and  18)  and
    gB18Lo  the  certified  bottom  of  g_b18  (CE18's
    three-decimal  bound,  machine:  gB17Lo  <  gB18Lo,
    below).  Named  Prop  consumed  as  a  hypothesis;  not
    proven  in-tree.  -/
def ce18WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB17Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB18Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-19  RUN  (window19_b19.json),  SLICE]
    every  zeta  zero  with  gB18Lo  <  Im  ρ  <=  tCE19  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB18Lo,  tCE19],  either  t0  <=  g_b18
    (the  true  Gram  point  -  g_a19  =  g_b18,  recorded  exact
    dyadic  ball  3 000 175 416 910.005424623397  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a19  =  g_a18  <  gB18Lo  <  g_b18
    puts  t0  in  window  18's  region  (g_a18,  g_b18])  -
    or  t0  >  g_b18  =  g_a19,  in  which  case  t0  <=  tCE19
    <  gB19Lo  <=  g_b19  puts  t0  in  window  19's  region
    (g_a19,  g_b19].  The  two  certified  regions  union  to
    (g_a18,  g_b19]  which  contains  (gB18Lo,  tCE19]
    (machine:  gB18Lo  <  tCE19  <  gB19Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce19WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB18Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE19 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE19]  are  on  the  line,  given  the
    nineteen  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo  are  pure  case  splits.
    -/
theorem bandOfWindows19 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : ce18WinClauseFull) (h19 : ce19WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE19 : ℝ) → ρ.re = 1 / 2 := by
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
                                    · exact h19 ρ hz (not_le.mp hseam18) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    nineteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE19.  -/
theorem allOnLineUpToCE19 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : ce18WinClauseFull)
    (hW19 : ce19WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE19 : ℝ) := by
  have hband := bandOfWindows19 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (nineteenth  run):  no
    off-line  zero  with  positive  height  above  tCE19.  -/
def terminalFaceCE19 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE19 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE18  face  implies  the  CE19  face
    (tCE19  >  tCE18).  -/
theorem faceCE18_implies_faceCE19 (q : ZeroSet)
    (hface : CE18.terminalFaceCE18 q) :
    terminalFaceCE19 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE18_lt_tCE19, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE18,  tCE19]  is  certified
    empty  (windows  18+19  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 672  higher).  -/
theorem terminalFaceCE19_iff_faceCE18 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW18 : ce18WinClauseFull) (hW19 : ce19WinClause) :
    terminalFaceCE19 q ↔ CE18.terminalFaceCE18 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE19 : ℝ)
    · by_cases hseam18 : ρ.im ≤ (gB18Lo : ℝ)
      · exact hW18 ρ (hqz ρ hρ) (by linarith [ht, gB17Lo_lt_tCE18, tCE18_lt_tCE19]) hseam18
      · exact hW19 ρ (hqz ρ hρ) (not_le.mp hseam18) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE18_implies_faceCE19 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE19
    (pure  logic).  -/
theorem rh_split_at_CE19 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE19 : ℝ) ∧ terminalFaceCE19 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE19 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE19 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  nineteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE18-WIN-FULL],  [CE19-WIN]),  all-heights  RH  <->
    terminalFaceCE19.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE19 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : ce18WinClauseFull)
    (hW19 : ce19WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE19 q := by
  have hcensus := allOnLineUpToCE19 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hqz
  have hsplit := rh_split_at_CE19 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE19 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : CE18.ce17WinClauseFull) (hW18 : ce18WinClauseFull)
    (hW19 : ce19WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE19 q) :
    RH q :=
  (rh_reanchored_CE19 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE19_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE19 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE19
