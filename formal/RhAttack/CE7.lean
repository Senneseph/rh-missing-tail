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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4 CE5 CE6
open scoped Topology

/-!
**CE7 — the terminal face re-anchored at the SEVENTH certified
window (0311, option B, unit 22 — lane M5, run 7:  OUR OWN
production, continuing the seamless chain:  windows
1 -> 2 -> 3 -> 4 -> 5 -> 6 -> 7).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE6):
  RUN  PARAMETERS:  a  =  12 363 153 557 128  (=  CE6's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 577 128  =  b  (b  was  already  a  good  Gram
  point  -  NO  snap  at  either  endpoint),  M  =  60,  C_R
  =  1,  28  workers,  34 213  evaluations  in  2606.0  s.
  CERTIFICATE  (window7_b7.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a7  <  Im  s  <=  g_b7  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a7  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 360 835.718425833876  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE6's
            recorded  g_b6  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b7  =  3 000 175 365 508.653559473769...  + or -
            1.29e-26  (exact  dyadic  decode;  the  fractional
            part  0.65355...  is  at  distance  0.3464  from
            the  next  integer  -  the  floor  is  robust  to
            the  radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  50
      left  of  g_a7,  53  right  of  g_b7  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 213  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  TWO,  BOTH  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  3-BLOCK  UNION  REFINEMENT  (window.py):
        block  [12 363 153 570 227,  .. 570 230]  rescued  to
        union  [.. 570 226,  .. 570 232],  need  6  =  found
        6;  block  [12 363 153 576 544,  .. 576 546]  rescued
        to  union  [.. 576 543,  .. 576 548],  need  5  =
        found  5.  As  in  windows  2/3/4/5,  the  rescued
        zeros  were  DISPLACED  into  adjacent  Gram
        intervals;  the  independent  verifier  recomputes
        the  WINDOW  TOTAL  (sign_changes_inside  =  20 000)
        and  the  two  end  Rosser  runs  (50  /  53)  -  the
        only  quantities  that  enter  the  Turing  step.
        Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE6):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window7_b7.json:
         "CERTIFIED:  true",  points_checked  =  34 213,
         sign_changes_inside  =  20 000  =  b  −  a,
         roesser_failures_inside  =  2  (both  rescued,
         union  quotas  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a7  ball
         is  bit-identical  to  CE6's  recorded  g_b6  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE7  =  3 000 175 365 508,
      tCE7  −  tCE6  =  4 673   (face  shrink  past  tCE6),
      tCE7  −  tPT2  = 32 708  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b7]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  =  139 998.
  HONESTY  (trust  base):  as  CE2-CE6  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE7

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b7  (the  recorded  ball  is
    3 000 175 365 508.653559473769...  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 5.6e-4).  -/
def gB7Lo : ℚ := 3000175365508653 / 1000

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB7Lo:
    tCE7  =  3 000 175 365 508.  -/
def tCE7 : ℕ := 3000175365508

theorem tCE7_lt_gB7Lo : (tCE7 : ℝ) < (gB7Lo : ℝ) := by
  norm_num [gB7Lo, tCE7]

theorem tCE6_lt_tCE7 : (tCE6 : ℝ) < (tCE7 : ℝ) := by
  norm_num [tCE6, tCE7]

/-- Record:  the  seam  order  gB6Lo  <  tCE7  (the  band
    (gB6Lo,  tCE7]  is  nonempty  and  lies  above  CE6's
    frontier  tCE6).  -/
theorem gB6Lo_lt_tCE7 : (gB6Lo : ℝ) < (tCE7 : ℝ) := by
  norm_num [gB6Lo, tCE7]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE6.  -/
theorem faceShrinkCE7 : (tCE7 : ℝ) - (tCE6 : ℝ) = 4673 := by
  norm_num [tCE7, tCE6]

/-- The  new  frontier  is  32 708  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE7 : ℝ) - WinC.tPT2 = 32708 := by
  norm_num [tCE7, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB5Lo  <  gB6Lo  (re-stated  at  the  CE7  level  from
    CE6's  window-6  band  ordering).  -/
theorem gB5Lo_lt_gB6Lo : (gB5Lo : ℝ) < (gB6Lo : ℝ) := by
  norm_num [gB5Lo, gB6Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB6Lo  <  gB7Lo)  -  the  window-7  band  (gB6Lo,  gB7Lo]
    (hence  (gB6Lo,  tCE7])  lies  strictly  above  window  6's
    certified  region.  -/
theorem gB6Lo_lt_gB7Lo : (gB6Lo : ℝ) < (gB7Lo : ℝ) := by
  norm_num [gB6Lo, gB7Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-6  RUN  (window6_b6.json),  FULL  SLICE]
    every  zeta  zero  with  gB5Lo  <  Im  ρ  <=  gB6Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB5Lo,  gB6Lo]  lies  inside  (g_a6,  g_b6]  -  window  6's
    own  certified  region  -  since  gB5Lo  is  the  certified
    bottom  of  g_a6  (=  g_b5,  bit-identical  dyadic  ball  in
    windows  5 and  6)  and  gB6Lo  the  certified  bottom  of
    g_b6  (machine:  gB5Lo  <  gB6Lo,  below).  This  is  the
    FULL  version  of  CE6.ce6WinClause  (which  is  the
    (gB5Lo,  tCE6]  slice  of  the  same  region).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce6WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB5Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB6Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-7  RUN  (window7_b7.json),  SLICE]
    every  zeta  zero  with  gB6Lo  <  Im  ρ  <=  tCE7  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB6Lo,  tCE7],  either  t0  <=  g_b6
    (the  true  Gram  point  -  g_a7  =  g_b6,  recorded  exact
    dyadic  ball  3 000 175 360 835.718425833876  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a7  =  g_a6  <  gB6Lo  <  g_b6  puts
    t0  in  window  6's  region  (g_a6,  g_b6])  -  or
    t0  >  g_b6  =  g_a7,  in  which  case  t0  <=  tCE7  <
    gB7Lo  <=  g_b7  puts  t0  in  window  7's  region
    (g_a7,  g_b7].  The  two  certified  regions  union  to
    (g_a6,  g_b7]  which  contains  (gB6Lo,  tCE7]  (machine:
    gB6Lo  <  tCE7  <  gB7Lo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce7WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB6Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE7 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE7]  are  on  the  line,  given  the  seven
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo  are  pure  case  splits.  -/
theorem bandOfWindows7 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : ce6WinClauseFull) (h7 : ce7WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE7 : ℝ) → ρ.re = 1 / 2 := by
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
            · exact h7 ρ hz (not_le.mp hseam6) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN-FULL]  +  [CE7-WIN]  =>  the
    on-line  census  holds  up  to  tCE7.  -/
theorem allOnLineUpToCE7 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : ce6WinClauseFull)
    (hW7 : ce7WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE7 : ℝ) := by
  have hband := bandOfWindows7 hW1 hW2 hW3 hW4 hW5 hW6 hW7
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (seventh  run):  no  off-line
    zero  with  positive  height  above  tCE7.  -/
def terminalFaceCE7 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE7 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE6  face  implies  the  CE7  face
    (tCE7  >  tCE6).  -/
theorem faceCE6_implies_faceCE7 (q : ZeroSet)
    (hface : CE6.terminalFaceCE6 q) :
    terminalFaceCE7 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE6_lt_tCE7, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE6,  tCE7]  is  certified  empty
    (windows  6+7  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE7_iff_faceCE6 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : ce6WinClauseFull)
    (hW7 : ce7WinClause) :
    terminalFaceCE7 q ↔ CE6.terminalFaceCE6 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE7 : ℝ)
    · by_cases hseam5 : ρ.im ≤ (gB5Lo : ℝ)
      · exact hW5 ρ (hqz ρ hρ) (by linarith [ht, CE6.gB5Lo_lt_tCE6, CE6.gB4Lo_lt_gB5Lo]) hseam5
      · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
        · exact hW6 ρ (hqz ρ hρ) (not_le.mp hseam5) hseam6
        · exact hW7 ρ (hqz ρ hρ) (not_le.mp hseam6) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE6_implies_faceCE7 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE7  (pure
    logic).  -/
theorem rh_split_at_CE7 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE7 : ℝ) ∧ terminalFaceCE7 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE7 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE7 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  [CE1-WIN]  +
    [CE2-WIN-FULL]  +  [CE3-WIN-FULL]  +  [CE4-WIN-FULL]  +
    [CE5-WIN-FULL]  +  [CE6-WIN-FULL]  +  [CE7-WIN],
    all-heights  RH  <->  terminalFaceCE7.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE7 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : ce6WinClauseFull)
    (hW7 : ce7WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE7 q := by
  have hcensus := allOnLineUpToCE7 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hqz
  have hsplit := rh_split_at_CE7 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE7 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : ce6WinClauseFull)
    (hW7 : ce7WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE7 q) :
    RH q :=
  (rh_reanchored_CE7 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE7_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE7 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE7
