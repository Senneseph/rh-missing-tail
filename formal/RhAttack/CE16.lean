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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15
open scoped Topology

/-!
**CE16 — the terminal face re-anchored at the SIXTEENTH
certified  window  (0321,  option  B,  unit  32  —  lane  M5,
run  16:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  16).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE15):
  RUN  PARAMETERS:  a  =  12 363 153 737 126  (=  CE15's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 757 126
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 552  evaluations  in  2533.3  s.
  CERTIFICATE  (window16_b16.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a16  <  Im  s  <=  g_b16  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a16  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 402 891.667325336277  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE15's
            recorded  g_b15  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b16  =  3 000 175 407 564.602456540321  + or -
               1.29e-26  (exact  dyadic  decode;  the  floor
               tCE16  sits  0.6025  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a16,  47  right  of  g_b16  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 552  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10,  12,  13  and  14).
  VERIFICATION  (three  layers,  same  as  CE2-CE15):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window16_b16.json:
         "CERTIFIED:  true",  points_checked  = 33 552,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a16  ball
         is  bit-identical  to  CE15's  recorded  g_b15  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE16  =  3 000 175 407 564,
      tCE16  −  tCE15  =  4 673   (face  shrink  past  tCE15),
      tCE16  −  tPT2  = 74 764  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b16]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  +  20 000  +  20 000  =
      319 996.
  HONESTY  (trust  base):  as  CE2-CE15  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE16

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b16  (the  recorded  ball  is
    3 000 175 407 564.602456540321  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~2.5e-3).  -/
def gB16Lo : ℚ := 300017540756460 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB16Lo:
    tCE16  =  3 000 175 407 564.  -/
def tCE16 : ℕ := 3000175407564

theorem tCE16_lt_gB16Lo : (tCE16 : ℝ) < (gB16Lo : ℝ) := by
  norm_num [gB16Lo, tCE16]

theorem tCE15_lt_tCE16 : (tCE15 : ℝ) < (tCE16 : ℝ) := by
  norm_num [CE15.tCE15, tCE16]

/-- Record:  the  seam  order  gB15Lo  <  tCE16  (the  band
    (gB15Lo,  tCE16]  is  nonempty  and  lies  above  CE15's
    frontier  tCE15).  -/
theorem gB15Lo_lt_tCE16 : (gB15Lo : ℝ) < (tCE16 : ℝ) := by
  norm_num [CE15.gB15Lo, tCE16]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE15.  -/
theorem faceShrinkCE16 : (tCE16 : ℝ) - (tCE15 : ℝ) = 4673 := by
  norm_num [tCE16, CE15.tCE15]

/-- The  new  frontier  is  74 764  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE16 : ℝ) - WinC.tPT2 = 74764 := by
  norm_num [tCE16, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB14Lo  <  gB15Lo  (re-stated  at  the  CE16  level  from
    CE15's  window-15  band  ordering).  -/
theorem gB14Lo_lt_gB15Lo : (gB14Lo : ℝ) < (gB15Lo : ℝ) := by
  norm_num [CE14.gB14Lo, CE15.gB15Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB15Lo  <  gB16Lo)  -  the  window-16  band  (gB15Lo,
    gB16Lo]  (hence  (gB15Lo,  tCE16])  lies  strictly  above
    window  15's  certified  region.  -/
theorem gB15Lo_lt_gB16Lo : (gB15Lo : ℝ) < (gB16Lo : ℝ) := by
  norm_num [CE15.gB15Lo, gB16Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-15  RUN  (window15_b15.json),  FULL
    SLICE]  every  zeta  zero  with  gB14Lo  <  Im  ρ  <=
    gB15Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB14Lo,  gB15Lo]  lies  inside  (g_a15,
    g_b15]  -  window  15's  own  certified  region  -  since
    gB14Lo  is  the  certified  bottom  of  g_a15  (=  g_b14,
    bit-identical  dyadic  ball  in  windows  14  and  15)  and
    gB15Lo  the  certified  bottom  of  g_b15  (machine:
    gB14Lo  <  gB15Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce15WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB14Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB15Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-16  RUN  (window16_b16.json),  SLICE]
    every  zeta  zero  with  gB15Lo  <  Im  ρ  <=  tCE16  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB15Lo,  tCE16],  either  t0  <=  g_b15
    (the  true  Gram  point  -  g_a16  =  g_b15,  recorded  exact
    dyadic  ball  3 000 175 402 891.667325336277  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a16  =  g_a15  <  gB15Lo  <  g_b15
    puts  t0  in  window  15's  region  (g_a15,  g_b15])  -
    or  t0  >  g_b15  =  g_a16,  in  which  case  t0  <=  tCE16
    <  gB16Lo  <=  g_b16  puts  t0  in  window  16's  region
    (g_a16,  g_b16].  The  two  certified  regions  union  to
    (g_a15,  g_b16]  which  contains  (gB15Lo,  tCE16]
    (machine:  gB15Lo  <  tCE16  <  gB16Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce16WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB15Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE16 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE16]  are  on  the  line,  given  the  sixteen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,  gB15Lo  are
    pure  case  splits.  -/
theorem bandOfWindows16 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : ce15WinClauseFull)
    (h16 : ce16WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE16 : ℝ) → ρ.re = 1 / 2 := by
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
                              · exact h16 ρ hz (not_le.mp hseam15) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    sixteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE16.  -/
theorem allOnLineUpToCE16 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : ce15WinClauseFull) (hW16 : ce16WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE16 : ℝ) := by
  have hband := bandOfWindows16 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (sixteenth  run):  no
    off-line  zero  with  positive  height  above  tCE16.  -/
def terminalFaceCE16 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE16 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE15  face  implies  the  CE16  face
    (tCE16  >  tCE15).  -/
theorem faceCE15_implies_faceCE16 (q : ZeroSet)
    (hface : CE15.terminalFaceCE15 q) :
    terminalFaceCE16 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE15_lt_tCE16, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE15,  tCE16]  is  certified
    empty  (windows  15+16  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE16_iff_faceCE15 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW15 : ce15WinClauseFull) (hW16 : ce16WinClause) :
    terminalFaceCE16 q ↔ CE15.terminalFaceCE15 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE16 : ℝ)
    · by_cases hseam15 : ρ.im ≤ (gB15Lo : ℝ)
      · exact hW15 ρ (hqz ρ hρ) (by linarith [ht, gB14Lo_lt_tCE15, tCE15_lt_tCE16]) hseam15
      · exact hW16 ρ (hqz ρ hρ) (not_le.mp hseam15) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE15_implies_faceCE16 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE16
    (pure  logic).  -/
theorem rh_split_at_CE16 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE16 : ℝ) ∧ terminalFaceCE16 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE16 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE16 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  sixteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE15-WIN-FULL],  [CE16-WIN]),  all-heights  RH  <->
    terminalFaceCE16.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE16 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : ce15WinClauseFull) (hW16 : ce16WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE16 q := by
  have hcensus := allOnLineUpToCE16 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hqz
  have hsplit := rh_split_at_CE16 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE16 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : ce15WinClauseFull) (hW16 : ce16WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE16 q) :
    RH q :=
  (rh_reanchored_CE16 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE16_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE16 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE16
