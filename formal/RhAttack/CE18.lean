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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10 CE11 CE12 CE13 CE14 CE15 CE16 CE17
open scoped Topology

/-!
**CE18 — the terminal face re-anchored at the EIGHTEENTH
certified  window  (0323,  option  B,  unit  34  —  lane  M5,
run  18:  OUR  OWN  production,  continuing  the  seamless
chain:  windows  1  ->  2  ->  ...  ->  18).**

PROVENANCE  (our  run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE17):
  RUN  PARAMETERS:  a  =  12 363 153 777 125  (=  CE17's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 797 125,  driver  snapped  the  final  b  DOWN  to
  12 363 153 797 124  (12 363 153 797 125  was  not  a  good
  Gram  point  at  the  working  precision;  a  itself  needed
  NO  snap),  M  =  60,  C_R  =  1,  28  workers,  33 068
  evaluations  in  2447.2  s.
  CERTIFICATE  (window18_b18.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a18  <  Im  s  <=  g_b18  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a18  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 412 237.303940717172  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE17's
            recorded  g_b17  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b18  =  3 000 175 416 910.005424623397  + or -
               1.29e-26  (exact  dyadic  decode;  CAUTION:
               the  fractional  part  is  only  0.00542  above
               the  previous  integer  3 000 175 416 910  -
               the  FLOOR  tCE18  sits  5.4e-3  above  the
               previous  integer,  still  robust  to  the
               radius  of  1.29e-26  by  a  factor  of  about
               4  ×  10^22,  but  the  certified  lower  bound
               had  to  be  rounded  down  at  three  decimal
               places  instead  of  two  -  see  gB18Lo
               below).
      Turing  runs  of  consecutive  good  Rosser  blocks:  48
      left  of  g_a18,  48  right  of  g_b18  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 068  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6,  8,  10,  12,  13,  14  and  16).
  VERIFICATION  (three  layers,  same  as  CE2-CE17):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window18_b18.json:
         "CERTIFIED:  true",  points_checked  = 33 068,
         sign_changes_inside  =  19 999  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a18  ball
         is  bit-identical  to  CE17's  recorded  g_b17  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE18  =  3 000 175 416 910,
      tCE18  −  tCE17  =  4 673   (face  shrink  past  tCE17),
      tCE18  −  tPT2  = 84 110  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b18]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  +
      20 000  +  20 000  +  20 000  +  20 000  +  20 000  +
      19 999  +  19 999  =  359 994.
  HONESTY  (trust  base):  as  CE2-CE17  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE18

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b18.  SPECIAL  CASING:  the
    recorded  ball  is  3 000 175 416 910.005424623397  with
    radius  ~= 1.29e-26,  so  the  usual  two-decimal  rounding
    (which  would  give  exactly  3 000 175 416 910  =  tCE18)
    would  NOT  be  a  STRICT  lower  bound  above  tCE18.
    Rounded  down  at  THREE  decimal  places  instead:
    3 000 175 416 910.005  <  g_b18  (margin  ~4.2e-4),  and
    tCE18  =  3 000 175 416 910  <  gB18Lo  (margin  5e-3).
    Both  are  machine  theorems  below.  -/
def gB18Lo : ℚ := 3000175416910005 / 1000

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB18Lo:
    tCE18  =  3 000 175 416 910.  -/
def tCE18 : ℕ := 3000175416910

theorem tCE18_lt_gB18Lo : (tCE18 : ℝ) < (gB18Lo : ℝ) := by
  norm_num [gB18Lo, tCE18]

theorem tCE17_lt_tCE18 : (tCE17 : ℝ) < (tCE18 : ℝ) := by
  norm_num [CE17.tCE17, tCE18]

/-- Record:  the  seam  order  gB17Lo  <  tCE18  (the  band
    (gB17Lo,  tCE18]  is  nonempty  and  lies  above  CE17's
    frontier  tCE17).  -/
theorem gB17Lo_lt_tCE18 : (gB17Lo : ℝ) < (tCE18 : ℝ) := by
  norm_num [CE17.gB17Lo, tCE18]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE17.  -/
theorem faceShrinkCE18 : (tCE18 : ℝ) - (tCE17 : ℝ) = 4673 := by
  norm_num [tCE18, CE17.tCE17]

/-- The  new  frontier  is  84 110  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE18 : ℝ) - WinC.tPT2 = 84110 := by
  norm_num [tCE18, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB16Lo  <  gB17Lo  (re-stated  at  the  CE18  level  from
    CE17's  window-17  band  ordering).  -/
theorem gB16Lo_lt_gB17Lo : (gB16Lo : ℝ) < (gB17Lo : ℝ) := by
  norm_num [CE16.gB16Lo, CE17.gB17Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB17Lo  <  gB18Lo)  -  the  window-18  band  (gB17Lo,
    gB18Lo]  (hence  (gB17Lo,  tCE18])  lies  strictly  above
    window  17's  certified  region.  -/
theorem gB17Lo_lt_gB18Lo : (gB17Lo : ℝ) < (gB18Lo : ℝ) := by
  norm_num [CE17.gB17Lo, gB18Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-17  RUN  (window17_b17.json),  FULL
    SLICE]  every  zeta  zero  with  gB16Lo  <  Im  ρ  <=
    gB17Lo  is  on  the  critical  line.  Derivation  (recorded):
    the  region  (gB16Lo,  gB17Lo]  lies  inside  (g_a17,
    g_b17]  -  window  17's  own  certified  region  -  since
    gB16Lo  is  the  certified  bottom  of  g_a17  (=  g_b16,
    bit-identical  dyadic  ball  in  windows  16  and  17)  and
    gB17Lo  the  certified  bottom  of  g_b17  (machine:
    gB16Lo  <  gB17Lo,  below).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce17WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB16Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB17Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-18  RUN  (window18_b18.json),  SLICE]
    every  zeta  zero  with  gB17Lo  <  Im  ρ  <=  tCE18  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB17Lo,  tCE18],  either  t0  <=  g_b17
    (the  true  Gram  point  -  g_a18  =  g_b17,  recorded  exact
    dyadic  ball  3 000 175 412 237.303940717172  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a18  =  g_a17  <  gB17Lo  <  g_b17
    puts  t0  in  window  17's  region  (g_a17,  g_b17])  -
    or  t0  >  g_b17  =  g_a18,  in  which  case  t0  <=  tCE18
    <  gB18Lo  <=  g_b18  puts  t0  in  window  18's  region
    (g_a18,  g_b18].  The  two  certified  regions  union  to
    (g_a17,  g_b18]  which  contains  (gB17Lo,  tCE18]
    (machine:  gB17Lo  <  tCE18  <  gB18Lo  <  g_b18  -  the
    last  inequality  being  the  certified  lower-bound
    reading  of  g_b18).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce18WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB17Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE18 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE18]  are  on  the  line,  given  the  eighteen
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo,  gB11Lo,  gB12Lo,  gB13Lo,  gB14Lo,  gB15Lo,
    gB16Lo,  gB17Lo  are  pure  case  splits.  -/
theorem bandOfWindows18 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : CE11.ce10WinClauseFull) (h11 : CE12.ce11WinClauseFull)
    (h12 : CE13.ce12WinClauseFull) (h13 : CE14.ce13WinClauseFull)
    (h14 : CE15.ce14WinClauseFull) (h15 : CE16.ce15WinClauseFull)
    (h16 : CE17.ce16WinClauseFull) (h17 : ce17WinClauseFull)
    (h18 : ce18WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE18 : ℝ) → ρ.re = 1 / 2 := by
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
                                  · exact h18 ρ hz (not_le.mp hseam17) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    eighteen  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE18.  -/
theorem allOnLineUpToCE18 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : ce17WinClauseFull) (hW18 : ce18WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE18 : ℝ) := by
  have hband := bandOfWindows18 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (eighteenth  run):  no
    off-line  zero  with  positive  height  above  tCE18.  -/
def terminalFaceCE18 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE18 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE17  face  implies  the  CE18  face
    (tCE18  >  tCE17).  -/
theorem faceCE17_implies_faceCE18 (q : ZeroSet)
    (hface : CE17.terminalFaceCE17 q) :
    terminalFaceCE18 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE17_lt_tCE18, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE17,  tCE18]  is  certified
    empty  (windows  17+18  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE18_iff_faceCE17 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW17 : ce17WinClauseFull) (hW18 : ce18WinClause) :
    terminalFaceCE18 q ↔ CE17.terminalFaceCE17 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE18 : ℝ)
    · by_cases hseam17 : ρ.im ≤ (gB17Lo : ℝ)
      · exact hW17 ρ (hqz ρ hρ) (by linarith [ht, gB16Lo_lt_tCE17, tCE17_lt_tCE18]) hseam17
      · exact hW18 ρ (hqz ρ hρ) (not_le.mp hseam17) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE17_implies_faceCE18 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE18
    (pure  logic).  -/
theorem rh_split_at_CE18 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE18 : ℝ) ∧ terminalFaceCE18 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE18 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE18 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  eighteen  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE17-WIN-FULL],  [CE18-WIN]),  all-heights  RH  <->
    terminalFaceCE18.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE18 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : ce17WinClauseFull) (hW18 : ce18WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE18 q := by
  have hcensus := allOnLineUpToCE18 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hqz
  have hsplit := rh_split_at_CE18 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE18 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : CE11.ce10WinClauseFull)
    (hW11 : CE12.ce11WinClauseFull) (hW12 : CE13.ce12WinClauseFull)
    (hW13 : CE14.ce13WinClauseFull) (hW14 : CE15.ce14WinClauseFull)
    (hW15 : CE16.ce15WinClauseFull) (hW16 : CE17.ce16WinClauseFull)
    (hW17 : ce17WinClauseFull) (hW18 : ce18WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE18 q) :
    RH q :=
  (rh_reanchored_CE18 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hW12 hW13 hW14 hW15 hW16 hW17 hW18 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE18_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE18 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE18
