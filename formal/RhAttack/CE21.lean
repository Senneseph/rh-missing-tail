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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17 CE18 CE19 CE20
open scoped Topology

/-!
**CE21 — the terminal face re-anchored at the TWENTY-FIRST
certified  window  (0326,  option  B,  unit  37  —  lane
M5:  OUR  OWN  production,  continuing  the  seamless  chain:
windows  1  ->  2  ->  ...  ->  21).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE20):
  RUN  PARAMETERS:  a  =  12 363 153 837 123  (=  CE20's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 857 123,  driver  snapped  the  final  b  DOWN  to
  12 363 153 857 122  (12 363 153 857 123  was  not  a  good
  Gram  point  at  the  working  precision;  a  itself  needed
  NO  snap),  M  =  60,  C_R  =  1,  28  workers,  33 566
  evaluations  in  2574.1  s.
  CERTIFICATE  (window21_b21.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a21  <  Im  s  <=  g_b21  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a21  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 426 255.642038380470  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE20's
            recorded  g_b20  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b21  =  3 000 175 430 928.343521474804  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE21  sits  0.3435  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  45
      left  of  g_a21,  47  right  of  g_b21  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 566  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        block  [12 363 153 847 076,  .. 847 079]  rescued  to
        union  [.. 847 075,  .. 847 081],  need  6  =  found
        6,  m  =  2  (a  wider  union  than  the  usual
        3-block  one;  the  quota  is  still  met  by  the
        union  recount).  As  in  windows
        2/3/4/5/7/9/11/15/17/19/20,  the  rescued  zero  was
        DISPLACED  into  an  adjacent  Gram  interval;  the
        independent  verifier  recomputes  the  WINDOW  TOTAL
        (sign_changes_inside  =  19 999)  and  the  two  end
        Rosser  runs  (45  /  47)  -  the  only  quantities  that
        enter  the  Turing  step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE20):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window21_b21.json:
         "CERTIFIED:  true",  points_checked  = 33 566,
         sign_changes_inside  =  19 999  =  b  −  a,
         rosser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a21  ball
         is  bit-identical  to  CE20's  recorded  g_b20  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE21  =  3 000 175 430 928,
      tCE21  −  tCE20  =  4 673   (face  shrink  past  tCE20),
      tCE21  −  tPT2  = 98 128  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b21]  =  399 993  +
      19 999  =  419 992.
  HONESTY  (trust  base):  as  CE2-CE20  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE21

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b21  (the  recorded  ball  is
    3 000 175 430 928.343521474804  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down  at  two
    decimals,  margin  ~3.5e-3).  -/
def gB21Lo : ℚ := 300017543092834 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB21Lo:
    tCE21  =  3 000 175 430 928.  -/
def tCE21 : ℕ := 3000175430928

theorem tCE21_lt_gB21Lo : (tCE21 : ℝ) < (gB21Lo : ℝ) := by
  norm_num [gB21Lo, tCE21]

theorem tCE20_lt_tCE21 : (tCE20 : ℝ) < (tCE21 : ℝ) := by
  norm_num [CE20.tCE20, tCE21]

/-- Record:  the  seam  order  gB20Lo  <  tCE21  (the  band
    (gB20Lo,  tCE21]  is  nonempty  and  lies  above  CE20's
    frontier  tCE20).  -/
theorem gB20Lo_lt_tCE21 : (gB20Lo : ℝ) < (tCE21 : ℝ) := by
  norm_num [CE20.gB20Lo, tCE21]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE20.  -/
theorem faceShrinkCE21 : (tCE21 : ℝ) - (tCE20 : ℝ) = 4673 := by
  norm_num [tCE21, CE20.tCE20]

/-- The  new  frontier  is  98 128  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE21 : ℝ) - WinC.tPT2 = 98128 := by
  norm_num [tCE21, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB19Lo  <  gB20Lo  (re-stated  at  the  CE21  level  from
    CE20's  window-20  band  ordering).  -/
theorem gB19Lo_lt_gB20Lo : (gB19Lo : ℝ) < (gB20Lo : ℝ) := by
  norm_num [CE19.gB19Lo, CE20.gB20Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB20Lo  <  gB21Lo)  -  the  window-21  band  (gB20Lo,
    gB21Lo]  (hence  (gB20Lo,  tCE21])  lies  strictly  above
    window  20's  certified  region.  -/
theorem gB20Lo_lt_gB21Lo : (gB20Lo : ℝ) < (gB21Lo : ℝ) := by
  norm_num [CE20.gB20Lo, gB21Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-20  RUN  (window20_b20.json),  FULL
    SLICE]  every  zeta  zero  with  gB19Lo  <  Im  ρ  <=
    gB20Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB19Lo,  gB20Lo]  lies  inside  (g_a20,
    g_b20]  -  window  20's  own  certified  region  -  since
    gB19Lo  is  the  certified  bottom  of  g_a20  (=  g_b19,
    bit-identical  dyadic  ball  in  windows  19  and  20)  and
    gB20Lo  the  certified  bottom  of  g_b20  (machine:
    gB19Lo  <  gB20Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce20WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB19Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB20Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-21  RUN  (window21_b21.json),  SLICE]
    every  zeta  zero  with  gB20Lo  <  Im  ρ  <=  tCE21  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB20Lo,  tCE21],  either  t0  <=  g_b20
    (the  true  Gram  point  -  g_a21  =  g_b20,  recorded  exact
    dyadic  ball  3 000 175 426 255.642038380470  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a21  =  g_a20  <  gB20Lo  <  g_b20
    puts  t0  in  window  20's  region  (g_a20,  g_b20])  -
    or  t0  >  g_b20  =  g_a21,  in  which  case  t0  <=  tCE21
    <  gB21Lo  <=  g_b21  puts  t0  in  window  21's  region
    (g_a21,  g_b21].  The  two  certified  regions  union  to
    (g_a20,  g_b21]  which  contains  (gB20Lo,  tCE21]
    (machine:  gB20Lo  <  tCE21  <  gB21Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce21WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB20Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE21 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE21]  are  on  the  line,  given  the
    twenty-one  window  clauses  -  the  splits  at  gA2Hi,
    gB2Lo,  gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,
    gB9Lo,  gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,
    gB15Lo,  gB16Lo,  gB17Lo,  gB18Lo,  gB19Lo,  gB20Lo  are
    pure  case  splits.  -/
theorem bandOfWindows21 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : CE18.ce17WinClauseFull)
    (h18 : CE19.ce18WinClauseFull) (h19 : CE20.ce19WinClauseFull)
    (h20 : ce20WinClauseFull) (h21 : ce21WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE21 : ℝ) → ρ.re = 1 / 2 := by
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
                                        · exact h21 ρ hz (not_le.mp hseam20) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    twenty-one  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE21.  -/
theorem allOnLineUpToCE21 (q : ZeroSet)
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
    (hW19 : CE20.ce19WinClauseFull) (hW20 : ce20WinClauseFull)
    (hW21 : ce21WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE21 : ℝ) := by
  have hband := bandOfWindows21 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (twenty-first  run):  no
    off-line  zero  with  positive  height  above  tCE21.  -/
def terminalFaceCE21 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE21 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE20  face  implies  the  CE21  face
    (tCE21  >  tCE20).  -/
theorem faceCE20_implies_faceCE21 (q : ZeroSet)
    (hface : CE20.terminalFaceCE20 q) :
    terminalFaceCE21 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE20_lt_tCE21, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE20,  tCE21]  is  certified
    empty  (windows  20+21  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE21_iff_faceCE20 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW20 : ce20WinClauseFull) (hW21 : ce21WinClause) :
    terminalFaceCE21 q ↔ CE20.terminalFaceCE20 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE21 : ℝ)
    · by_cases hseam20 : ρ.im ≤ (gB20Lo : ℝ)
      · exact hW20 ρ (hqz ρ hρ) (by linarith [ht, gB19Lo_lt_tCE20, tCE20_lt_tCE21]) hseam20
      · exact hW21 ρ (hqz ρ hρ) (not_le.mp hseam20) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE20_implies_faceCE21 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE21
    (pure  logic).  -/
theorem rh_split_at_CE21 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE21 : ℝ) ∧ terminalFaceCE21 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE21 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE21 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  twenty-one
    cited  window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE20-WIN-FULL],  [CE21-WIN]),  all-heights  RH  <->
    terminalFaceCE21.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE21 (q : ZeroSet)
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
    (hW19 : CE20.ce19WinClauseFull) (hW20 : ce20WinClauseFull)
    (hW21 : ce21WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE21 q := by
  have hcensus := allOnLineUpToCE21 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hqz
  have hsplit := rh_split_at_CE21 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE21 (q : ZeroSet)
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
    (hW19 : CE20.ce19WinClauseFull) (hW20 : ce20WinClauseFull)
    (hW21 : ce21WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE21 q) :
    RH q :=
  (rh_reanchored_CE21 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hW19 hW20 hW21 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE21_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE21 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE21
