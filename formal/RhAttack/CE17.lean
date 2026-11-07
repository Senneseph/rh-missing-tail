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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16
open scoped Topology

/-!
**CE17 — the terminal face re-anchored at the SEVENTEENTH
certified  window  (0322,  option  B,  unit  33  —  lane  M5,
run  17:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  17).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE16):
  RUN  PARAMETERS:  a  =  12 363 153 757 126  (=  CE16's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 777 126,  driver  snapped  the  final  b  DOWN  to
  12 363 153 777 125  (12 363 153 777 126  was  not  a  good
  Gram  point  at  the  working  precision;  a  itself  needed
  NO  snap),  M  =  60,  C_R  =  1,  28  workers,  34 926
  evaluations  in  2692.9  s.
  CERTIFICATE  (window17_b17.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a17  <  Im  s  <=  g_b17  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a17  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 407 564.602456540321  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE16's
            recorded  g_b16  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b17  =  3 000 175 412 237.303940717172  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE17  sits  0.3039  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  49
      left  of  g_a17,  46  right  of  g_b17  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 926  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  UNION  REFINEMENT  (window.py):
        block  [12 363 153 763 962,  .. 763 965]  rescued  to
        union  [.. 763 959,  .. 763 966],  need  7  =  found
        7,  m  =  2  (a  wider  3-on-each-side  union  than  the
        usual  3-block  one;  the  quota  is  still  met  by
        the  union  recount).  As  in  windows
        2/3/4/5/7/9/11/15,  the  rescued  zero  was
        DISPLACED  into  an  adjacent  Gram  interval;  the
        independent  verifier  recomputes  the  WINDOW  TOTAL
        (sign_changes_inside  =  19 999)  and  the  two  end
        Rosser  runs  (49  /  46)  -  the  only  quantities  that
        enter  the  Turing  step.  Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE16):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window17_b17.json:
         "CERTIFIED:  true",  points_checked  =  34 926,
         sign_changes_inside  =  19 999  =  b  −  a,
         roesser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a17  ball
         is  bit-identical  to  CE16's  recorded  g_b16  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE17  =  3 000 175 412 237,
      tCE17  −  tCE16  =  4 673   (face  shrink  past  tCE16;
                            the  window  carried  19 999
                            zeros  because  the  final  b  was
                            snapped  down  one,  but  the
                            Gram-point  span  still  covered
                            4 673  units  because  the  floor
                            did  not  move  down  with  the
                            snap),
      tCE17  −  tPT2  = 79 437  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b17]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  +  20 000  +  20 000  +
      19 999  =  339 995.
  HONESTY  (trust  base):  as  CE2-CE16  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE17

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b17  (the  recorded  ball  is
    3 000 175 412 237.303940717172  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~3.9e-3).  -/
def gB17Lo : ℚ := 300017541223730 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB17Lo:
    tCE17  =  3 000 175 412 237.  -/
def tCE17 : ℕ := 3000175412237

theorem tCE17_lt_gB17Lo : (tCE17 : ℝ) < (gB17Lo : ℝ) := by
  norm_num [gB17Lo, tCE17]

theorem tCE16_lt_tCE17 : (tCE16 : ℝ) < (tCE17 : ℝ) := by
  norm_num [CE16.tCE16, tCE17]

/-- Record:  the  seam  order  gB16Lo  <  tCE17  (the  band
    (gB16Lo,  tCE17]  is  nonempty  and  lies  above  CE16's
    frontier  tCE16).  -/
theorem gB16Lo_lt_tCE17 : (gB16Lo : ℝ) < (tCE17 : ℝ) := by
  norm_num [CE16.gB16Lo, tCE17]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE16.  -/
theorem faceShrinkCE17 : (tCE17 : ℝ) - (tCE16 : ℝ) = 4673 := by
  norm_num [tCE17, CE16.tCE16]

/-- The  new  frontier  is  79 437  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE17 : ℝ) - WinC.tPT2 = 79437 := by
  norm_num [tCE17, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB15Lo  <  gB16Lo  (re-stated  at  the  CE17  level  from
    CE16's  window-16  band  ordering).  -/
theorem gB15Lo_lt_gB16Lo : (gB15Lo : ℝ) < (gB16Lo : ℝ) := by
  norm_num [CE15.gB15Lo, CE16.gB16Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB16Lo  <  gB17Lo)  -  the  window-17  band  (gB16Lo,
    gB17Lo]  (hence  (gB16Lo,  tCE17])  lies  strictly  above
    window  16's  certified  region.  -/
theorem gB16Lo_lt_gB17Lo : (gB16Lo : ℝ) < (gB17Lo : ℝ) := by
  norm_num [CE16.gB16Lo, gB17Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-16  RUN  (window16_b16.json),  FULL
    SLICE]  every  zeta  zero  with  gB15Lo  <  Im  ρ  <=
    gB16Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB15Lo,  gB16Lo]  lies  inside  (g_a16,
    g_b16]  -  window  16's  own  certified  region  -  since
    gB15Lo  is  the  certified  bottom  of  g_a16  (=  g_b15,
    bit-identical  dyadic  ball  in  windows  15  and  16)  and
    gB16Lo  the  certified  bottom  of  g_b16  (machine:
    gB15Lo  <  gB16Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce16WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB15Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB16Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-17  RUN  (window17_b17.json),  SLICE]
    every  zeta  zero  with  gB16Lo  <  Im  ρ  <=  tCE17  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB16Lo,  tCE17],  either  t0  <=  g_b16
    (the  true  Gram  point  -  g_a17  =  g_b16,  recorded  exact
    dyadic  ball  3 000 175 407 564.602456540321  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a17  =  g_a16  <  gB16Lo  <  g_b16
    puts  t0  in  window  16's  region  (g_a16,  g_b16])  -
    or  t0  >  g_b16  =  g_a17,  in  which  case  t0  <=  tCE17
    <  gB17Lo  <=  g_b17  puts  t0  in  window  17's  region
    (g_a17,  g_b17].  The  two  certified  regions  union  to
    (g_a16,  g_b17]  which  contains  (gB16Lo,  tCE17]
    (machine:  gB16Lo  <  tCE17  <  gB17Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce17WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB16Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE17 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE17]  are  on  the  line,  given  the  seventeen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,  gB15Lo,
    gB16Lo  are  pure  case  splits.  -/
theorem bandOfWindows17 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : ce16WinClauseFull) (h17 : ce17WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE17 : ℝ) → ρ.re = 1 / 2 := by
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
                                · exact h17 ρ hz (not_le.mp hseam16) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    seventeen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE17.  -/
theorem allOnLineUpToCE17 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : ce16WinClauseFull)
    (hW17 : ce17WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE17 : ℝ) := by
  have hband := bandOfWindows17 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (seventeenth  run):  no
    off-line  zero  with  positive  height  above  tCE17.  -/
def terminalFaceCE17 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE17 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE16  face  implies  the  CE17  face
    (tCE17  >  tCE16).  -/
theorem faceCE16_implies_faceCE17 (q : ZeroSet)
    (hface : CE16.terminalFaceCE16 q) :
    terminalFaceCE17 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE16_lt_tCE17, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE16,  tCE17]  is  certified
    empty  (windows  16+17  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE17_iff_faceCE16 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW16 : ce16WinClauseFull) (hW17 : ce17WinClause) :
    terminalFaceCE17 q ↔ CE16.terminalFaceCE16 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE17 : ℝ)
    · by_cases hseam16 : ρ.im ≤ (gB16Lo : ℝ)
      · exact hW16 ρ (hqz ρ hρ) (by linarith [ht, gB15Lo_lt_tCE16, tCE16_lt_tCE17]) hseam16
      · exact hW17 ρ (hqz ρ hρ) (not_le.mp hseam16) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE16_implies_faceCE17 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE17
    (pure  logic).  -/
theorem rh_split_at_CE17 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE17 : ℝ) ∧ terminalFaceCE17 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE17 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE17 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  seventeen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE16-WIN-FULL],  [CE17-WIN]),  all-heights  RH  <->
    terminalFaceCE17.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE17 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : ce16WinClauseFull)
    (hW17 : ce17WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE17 q := by
  have hcensus := allOnLineUpToCE17 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hqz
  have hsplit := rh_split_at_CE17 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE17 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : ce16WinClauseFull)
    (hW17 : ce17WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE17 q) :
    RH q :=
  (rh_reanchored_CE17 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE17_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE17 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE17
