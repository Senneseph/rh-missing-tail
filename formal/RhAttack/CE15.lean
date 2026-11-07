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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14
open scoped Topology

/-!
**CE15 — the terminal face re-anchored at the FIFTEENTH
certified  window  (0320,  option  B,  unit  31  —  lane  M5,
run  15:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  15).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE14):
  RUN  PARAMETERS:  a  =  12 363 153 717 126  (=  CE14's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 737 126
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 213  evaluations  in  2492.2  s.
  CERTIFICATE  (window15_b15.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a15  <  Im  s  <=  g_b15  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a15  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 398 218.732193861580  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE14's
            recorded  g_b14  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b15  =  3 000 175 402 891.667325336277  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE15  sits  0.6673  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a15,  50  right  of  g_b15  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 213  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  TWO,  BOTH  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  3-BLOCK  UNION  REFINEMENT  (window.py):
        block  [12 363 153 728 627,  .. 728 629]  ->  union
        [.. 728 626,  .. 728 631],  need  5  =  found  5,
        m  =  4;
        block  [12 363 153 735 520,  .. 735 522]  ->  union
        [.. 735 519,  .. 735 524],  need  5  =  found  5,
        m  =  4.
      As  in  windows  2/3/4/5/7/9/11,  the  rescued  zeros
      were  DISPLACED  into  adjacent  Gram  intervals;  the
      independent  verifier  recomputes  the  WINDOW  TOTAL
      (sign_changes_inside  =  20 000)  and  the  two  end
      Rosser  runs  (49  /  50)  -  the  only  quantities  that
      enter  the  Turing  step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE14):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window15_b15.json:
         "CERTIFIED:  true",  points_checked  =  33 213,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  2  (both  rescued,
         union  quotas  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a15  ball
         is  bit-identical  to  CE14's  recorded  g_b14  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE15  =  3 000 175 402 891,
      tCE15  −  tCE14  =  4 673   (face  shrink  past  tCE14),
      tCE15  −  tPT2  = 70 091  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b15]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  +  20 000  =  299 996.
  HONESTY  (trust  base):  as  CE2-CE14  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE15

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b15  (the  recorded  ball  is
    3 000 175 402 891.667325336277  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~7.3e-3).  -/
def gB15Lo : ℚ := 300017540289166 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB15Lo:
    tCE15  =  3 000 175 402 891.  -/
def tCE15 : ℕ := 3000175402891

theorem tCE15_lt_gB15Lo : (tCE15 : ℝ) < (gB15Lo : ℝ) := by
  norm_num [gB15Lo, tCE15]

theorem tCE14_lt_tCE15 : (tCE14 : ℝ) < (tCE15 : ℝ) := by
  norm_num [CE14.tCE14, tCE15]

/-- Record:  the  seam  order  gB14Lo  <  tCE15  (the  band
    (gB14Lo,  tCE15]  is  nonempty  and  lies  above  CE14's
    frontier  tCE14).  -/
theorem gB14Lo_lt_tCE15 : (gB14Lo : ℝ) < (tCE15 : ℝ) := by
  norm_num [CE14.gB14Lo, tCE15]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE14.  -/
theorem faceShrinkCE15 : (tCE15 : ℝ) - (tCE14 : ℝ) = 4673 := by
  norm_num [tCE15, CE14.tCE14]

/-- The  new  frontier  is  70 091  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE15 : ℝ) - WinC.tPT2 = 70091 := by
  norm_num [tCE15, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB13Lo  <  gB14Lo  (re-stated  at  the  CE15  level  from
    CE14's  window-14  band  ordering).  -/
theorem gB13Lo_lt_gB14Lo : (gB13Lo : ℝ) < (gB14Lo : ℝ) := by
  norm_num [CE13.gB13Lo, CE14.gB14Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB14Lo  <  gB15Lo)  -  the  window-15  band  (gB14Lo,
    gB15Lo]  (hence  (gB14Lo,  tCE15])  lies  strictly  above
    window  14's  certified  region.  -/
theorem gB14Lo_lt_gB15Lo : (gB14Lo : ℝ) < (gB15Lo : ℝ) := by
  norm_num [CE14.gB14Lo, gB15Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-14  RUN  (window14_b14.json),  FULL
    SLICE]  every  zeta  zero  with  gB13Lo  <  Im  ρ  <=
    gB14Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB13Lo,  gB14Lo]  lies  inside  (g_a14,
    g_b14]  -  window  14's  own  certified  region  -  since
    gB13Lo  is  the  certified  bottom  of  g_a14  (=  g_b13,
    bit-identical  dyadic  ball  in  windows  13  and  14)  and
    gB14Lo  the  certified  bottom  of  g_b14  (machine:
    gB13Lo  <  gB14Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce14WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB13Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB14Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-15  RUN  (window15_b15.json),  SLICE]
    every  zeta  zero  with  gB14Lo  <  Im  ρ  <=  tCE15  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB14Lo,  tCE15],  either  t0  <=  g_b14
    (the  true  Gram  point  -  g_a15  =  g_b14,  recorded  exact
    dyadic  ball  3 000 175 398 218.732193861580  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a15  =  g_a14  <  gB14Lo  <  g_b14
    puts  t0  in  window  14's  region  (g_a14,  g_b14])  -
    or  t0  >  g_b14  =  g_a15,  in  which  case  t0  <=  tCE15
    <  gB15Lo  <=  g_b15  puts  t0  in  window  15's  region
    (g_a15,  g_b15].  The  two  certified  regions  union  to
    (g_a14,  g_b15]  which  contains  (gB14Lo,  tCE15]
    (machine:  gB14Lo  <  tCE15  <  gB15Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce15WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB14Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE15 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE15]  are  on  the  line,  given  the  fifteen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo  are  pure  case
    splits.  -/
theorem bandOfWindows15 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : ce14WinClauseFull) (h15 : ce15WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE15 : ℝ) → ρ.re = 1 / 2 := by
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
                            · exact h15 ρ hz (not_le.mp hseam14) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    fifteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE15.  -/
theorem allOnLineUpToCE15 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : ce14WinClauseFull)
    (hW15 : ce15WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE15 : ℝ) := by
  have hband := bandOfWindows15 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (fifteenth  run):  no
    off-line  zero  with  positive  height  above  tCE15.  -/
def terminalFaceCE15 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE15 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE14  face  implies  the  CE15  face
    (tCE15  >  tCE14).  -/
theorem faceCE14_implies_faceCE15 (q : ZeroSet)
    (hface : CE14.terminalFaceCE14 q) :
    terminalFaceCE15 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE14_lt_tCE15, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE14,  tCE15]  is  certified
    empty  (windows  14+15  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE15_iff_faceCE14 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW14 : ce14WinClauseFull) (hW15 : ce15WinClause) :
    terminalFaceCE15 q ↔ CE14.terminalFaceCE14 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE15 : ℝ)
    · by_cases hseam14 : ρ.im ≤ (gB14Lo : ℝ)
      · exact hW14 ρ (hqz ρ hρ) (by linarith [ht, gB13Lo_lt_tCE14, tCE14_lt_tCE15]) hseam14
      · exact hW15 ρ (hqz ρ hρ) (not_le.mp hseam14) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE14_implies_faceCE15 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE15
    (pure  logic).  -/
theorem rh_split_at_CE15 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE15 : ℝ) ∧ terminalFaceCE15 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE15 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE15 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  fifteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE14-WIN-FULL],  [CE15-WIN]),  all-heights  RH  <->
    terminalFaceCE15.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE15 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : ce14WinClauseFull)
    (hW15 : ce15WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE15 q := by
  have hcensus := allOnLineUpToCE15 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hqz
  have hsplit := rh_split_at_CE15 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE15 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : ce14WinClauseFull)
    (hW15 : ce15WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE15 q) :
    RH q :=
  (rh_reanchored_CE15 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE15_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE15 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE15
