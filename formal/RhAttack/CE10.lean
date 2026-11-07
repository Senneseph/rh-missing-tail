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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9
open scoped Topology

/-!
**CE10 — the terminal face re-anchored at the TENTH certified
window (0315, option B, unit 26 — lane M5, run 10:  OUR OWN
production, continuing the seamless chain:  windows
1 -> 2 -> ... -> 10).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE9):
  RUN  PARAMETERS:  a  =  12 363 153 617 127  (=  CE9's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 637 127
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  33 372  evaluations  in  2572.5  s.
  CERTIFICATE  (window10_b10.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a10  <  Im  s  <=  g_b10  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a10  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 374 854.290179184949  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE9's
            recorded  g_b9  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b10  =  3 000 175 379 527.225312012897  + or -
               1.29e-26  (exact  dyadic  decode;  the
               fractional  part  0.22531...  is  at  distance
               0.7747  from  the  next  integer  -  the  floor
               is  robust  to  the  radius  by  many  orders  of
               magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a10,  46  right  of  g_b10  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 372  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  NONE  -  roesser_failures  =  []  and
      rescued_rosser_exceptions  =  []:  a  CLEAN  window  (as
      windows  6  and  8).
  VERIFICATION  (three  layers,  same  as  CE2-CE9):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window10_b10.json:
         "CERTIFIED:  true",  points_checked  =  33 372,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  0,  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a10  ball
         is  bit-identical  to  CE9's  recorded  g_b9  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE10  =  3 000 175 379 527,
      tCE10  −  tCE9  =  4 673   (face  shrink  past  tCE9),
      tCE10  −  tPT2  = 46 727  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b10]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  =  199 997.
  HONESTY  (trust  base):  as  CE2-CE9  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE10

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b10  (the  recorded  ball  is
    3 000 175 379 527.225312012897  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 5.3e-3).  -/
def gB10Lo : ℚ := 300017537952722 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB10Lo:
    tCE10  =  3 000 175 379 527.  -/
def tCE10 : ℕ := 3000175379527

theorem tCE10_lt_gB10Lo : (tCE10 : ℝ) < (gB10Lo : ℝ) := by
  norm_num [gB10Lo, tCE10]

theorem tCE9_lt_tCE10 : (tCE9 : ℝ) < (tCE10 : ℝ) := by
  norm_num [CE9.tCE9, tCE10]

/-- Record:  the  seam  order  gB9Lo  <  tCE10  (the  band
    (gB9Lo,  tCE10]  is  nonempty  and  lies  above  CE9's
    frontier  tCE9).  -/
theorem gB9Lo_lt_tCE10 : (gB9Lo : ℝ) < (tCE10 : ℝ) := by
  norm_num [CE9.gB9Lo, tCE10]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE9.  -/
theorem faceShrinkCE10 : (tCE10 : ℝ) - (tCE9 : ℝ) = 4673 := by
  norm_num [tCE10, CE9.tCE9]

/-- The  new  frontier  is  46 727  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE10 : ℝ) - WinC.tPT2 = 46727 := by
  norm_num [tCE10, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB8Lo  <  gB9Lo  (re-stated  at  the  CE10  level  from
    CE9's  window-9  band  ordering).  -/
theorem gB8Lo_lt_gB9Lo : (gB8Lo : ℝ) < (gB9Lo : ℝ) := by
  norm_num [CE8.gB8Lo, CE9.gB9Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB9Lo  <  gB10Lo)  -  the  window-10  band  (gB9Lo,
    gB10Lo]  (hence  (gB9Lo,  tCE10])  lies  strictly  above
    window  9's  certified  region.  -/
theorem gB9Lo_lt_gB10Lo : (gB9Lo : ℝ) < (gB10Lo : ℝ) := by
  norm_num [CE9.gB9Lo, gB10Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-9  RUN  (window9_b9.json),  FULL  SLICE]
    every  zeta  zero  with  gB8Lo  <  Im  ρ  <=  gB9Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB8Lo,  gB9Lo]  lies  inside  (g_a9,  g_b9]  -  window  9's
    own  certified  region  -  since  gB8Lo  is  the  certified
    bottom  of  g_a9  (=  g_b8,  bit-identical  dyadic  ball  in
    windows  8 and  9)  and  gB9Lo  the  certified  bottom  of
    g_b9  (machine:  gB8Lo  <  gB9Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce9WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB8Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB9Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-10  RUN  (window10_b10.json),  SLICE]
    every  zeta  zero  with  gB9Lo  <  Im  ρ  <=  tCE10  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB9Lo,  tCE10],  either  t0  <=  g_b9
    (the  true  Gram  point  -  g_a10  =  g_b9,  recorded  exact
    dyadic  ball  3 000 175 374 854.290179184949  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a10  =  g_a9  <  gB9Lo  <  g_b9  puts
    t0  in  window  9's  region  (g_a9,  g_b9])  -  or
    t0  >  g_b9  =  g_a10,  in  which  case  t0  <=  tCE10  <
    gB10Lo  <=  g_b10  puts  t0  in  window  10's  region
    (g_a10,  g_b10].  The  two  certified  regions  union  to
    (g_a9,  g_b10]  which  contains  (gB9Lo,  tCE10]  (machine:
    gB9Lo  <  tCE10  <  gB10Lo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce10WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB9Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE10 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE10]  are  on  the  line,  given  the  ten
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo
    are  pure  case  splits.  -/
theorem bandOfWindows10 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : ce9WinClauseFull)
    (h10 : ce10WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE10 : ℝ) → ρ.re = 1 / 2 := by
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
                  · exact h10 ρ hz (not_le.mp hseam9) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the  ten
    cited  window  clauses  =>  the  on-line  census  holds  up
    to  tCE10.  -/
theorem allOnLineUpToCE10 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : ce9WinClauseFull) (hW10 : ce10WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE10 : ℝ) := by
  have hband := bandOfWindows10 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (tenth  run):  no  off-line
    zero  with  positive  height  above  tCE10.  -/
def terminalFaceCE10 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE10 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE9  face  implies  the  CE10  face
    (tCE10  >  tCE9).  -/
theorem faceCE9_implies_faceCE10 (q : ZeroSet)
    (hface : CE9.terminalFaceCE9 q) :
    terminalFaceCE10 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE9_lt_tCE10, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE9,  tCE10]  is  certified  empty
    (windows  9+10  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE10_iff_faceCE9 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW9 : ce9WinClauseFull) (hW10 : ce10WinClause) :
    terminalFaceCE10 q ↔ CE9.terminalFaceCE9 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE10 : ℝ)
    · by_cases hseam9 : ρ.im ≤ (gB9Lo : ℝ)
      · exact hW9 ρ (hqz ρ hρ) (by linarith [ht, gB8Lo_lt_tCE9, tCE9_lt_tCE10]) hseam9
      · exact hW10 ρ (hqz ρ hρ) (not_le.mp hseam9) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE9_implies_faceCE10 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE10
    (pure  logic).  -/
theorem rh_split_at_CE10 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE10 : ℝ) ∧ terminalFaceCE10 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE10 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE10 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  ten  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  [CE3-WIN-FULL],
    [CE4-WIN-FULL],  [CE5-WIN-FULL],  [CE6-WIN-FULL],
    [CE7-WIN-FULL],  [CE8-WIN-FULL],  [CE9-WIN-FULL],
    [CE10-WIN]),  all-heights  RH  <->  terminalFaceCE10.
    NO  RH  CLAIM.  -/
theorem rh_reanchored_CE10 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : ce9WinClauseFull) (hW10 : ce10WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE10 q := by
  have hcensus := allOnLineUpToCE10 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hqz
  have hsplit := rh_split_at_CE10 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE10 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : ce9WinClauseFull) (hW10 : ce10WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE10 q) :
    RH q :=
  (rh_reanchored_CE10 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE10_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE10 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE10
