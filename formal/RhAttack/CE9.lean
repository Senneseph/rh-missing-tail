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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE2 CE3 CE4 CE5 CE6 CE7 CE8
open scoped Topology

/-!
**CE9 — the terminal face re-anchored at the NINTH certified
window (0314, option B, unit 25 — lane M5, run 9:  OUR OWN
production, continuing the seamless chain:  windows
1 -> 2 -> ... -> 9).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE8):
  RUN  PARAMETERS:  a  =  12 363 153 597 127  (=  CE8's  final
  b;  seamless),  b  =  a  +  20 000  =  12 363 153 617 127
  (b  was  already  a  good  Gram  point  -  NO  snap  at
  either  endpoint),  M  =  60,  C_R  =  1,  28  workers,
  34 206  evaluations  in  2619.8  s.
  CERTIFICATE  (window9_b9.json):  the  b  −  a  =  20 000
  zeros  of  ζ  with  g_a9  <  Im  s  <=  g_b9  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a9  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 370 181.355046086348  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE8's
            recorded  g_b8  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b9  =  3 000 175 374 854.290179184949  + or -  1.29e-26
            (exact  dyadic  decode;  the  fractional  part
            0.29017...  is  at  distance  0.7098  from  the
            next  integer  -  the  floor  is  robust  to  the
            radius  by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  45
      left  of  g_a9,  49  right  of  g_b9  (both  >=  K  =
      12);  0  cross-check  failures  (all  34 206  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTIONS:  TWO,  BOTH  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  3-BLOCK  UNION  REFINEMENT  (window.py):
        block  [12 363 153 603 657,  .. 603 660]  rescued  to
        union  [.. 603 656,  .. 603 661],  need  5  =  found
        5;  block  [12 363 153 611 231,  .. 611 233]  rescued
        to  union  [.. 611 230,  .. 611 235],  need  5  =
        found  5.  As  in  windows  2/3/4/5/7,  the  rescued
        zeros  were  DISPLACED  into  adjacent  Gram
        intervals;  the  independent  verifier  recomputes
        the  WINDOW  TOTAL  (sign_changes_inside  =  20 000)
        and  the  two  end  Rosser  runs  (45  /  49)  -  the
        only  quantities  that  enter  the  Turing  step.
        Recorded,  not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE8):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window9_b9.json:
         "CERTIFIED:  true",  points_checked  =  34 206,
         sign_changes_inside  =  20 000  =  b  −  a,
         rosser_failures_inside  =  2  (both  rescued,
         union  quotas  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a9  ball
         is  bit-identical  to  CE8's  recorded  g_b8  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE9  =  3 000 175 374 854,
      tCE9  −  tCE8  =  4 673   (face  shrink  past  tCE8),
      tCE9  −  tPT2  = 42 054  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b9]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  =  179 997.
  HONESTY  (trust  base):  as  CE2-CE8  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE9

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b9  (the  recorded  ball  is
    3 000 175 374 854.290179184949  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 1.79e-4  (still  > 25  orders  of  magnitude  above  the
    radius);  the  floor  tCE9  sits  0.7098  below  the  next
    integer.  -/
def gB9Lo : ℚ := 300017537485429 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB9Lo:
    tCE9  =  3 000 175 374 854.  -/
def tCE9 : ℕ := 3000175374854

theorem tCE9_lt_gB9Lo : (tCE9 : ℝ) < (gB9Lo : ℝ) := by
  norm_num [gB9Lo, tCE9]

theorem tCE8_lt_tCE9 : (tCE8 : ℝ) < (tCE9 : ℝ) := by
  norm_num [CE8.tCE8, tCE9]

/-- Record:  the  seam  order  gB8Lo  <  tCE9  (the  band
    (gB8Lo,  tCE9]  is  nonempty  and  lies  above  CE8's
    frontier  tCE8).  -/
theorem gB8Lo_lt_tCE9 : (gB8Lo : ℝ) < (tCE9 : ℝ) := by
  norm_num [CE8.gB8Lo, tCE9]

/-- The  face  height  shrunk  by  further  4 673  units  past
    tCE8.  -/
theorem faceShrinkCE9 : (tCE9 : ℝ) - (tCE8 : ℝ) = 4673 := by
  norm_num [tCE9, CE8.tCE8]

/-- The  new  frontier  is  42 054  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE9 : ℝ) - WinC.tPT2 = 42054 := by
  norm_num [tCE9, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB7Lo  <  gB8Lo  (re-stated  at  the  CE9  level  from
    CE8's  window-8  band  ordering).  -/
theorem gB7Lo_lt_gB8Lo : (gB7Lo : ℝ) < (gB8Lo : ℝ) := by
  norm_num [CE7.gB7Lo, CE8.gB8Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB8Lo  <  gB9Lo)  -  the  window-9  band  (gB8Lo,  gB9Lo]
    (hence  (gB8Lo,  tCE9])  lies  strictly  above  window  8's
    certified  region.  -/
theorem gB8Lo_lt_gB9Lo : (gB8Lo : ℝ) < (gB9Lo : ℝ) := by
  norm_num [CE8.gB8Lo, gB9Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-8  RUN  (window8_b8.json),  FULL  SLICE]
    every  zeta  zero  with  gB7Lo  <  Im  ρ  <=  gB8Lo  is  on
    the  critical  line.  Derivation  (recorded):  the  region
    (gB7Lo,  gB8Lo]  lies  inside  (g_a8,  g_b8]  -  window  8's
    own  certified  region  -  since  gB7Lo  is  the  certified
    bottom  of  g_a8  (=  g_b7,  bit-identical  dyadic  ball  in
    windows  7 and  8)  and  gB8Lo  the  certified  bottom  of
    g_b8  (machine:  gB7Lo  <  gB8Lo,  below).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce8WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB7Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB8Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-9  RUN  (window9_b9.json),  SLICE]
    every  zeta  zero  with  gB8Lo  <  Im  ρ  <=  tCE9  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB8Lo,  tCE9],  either  t0  <=  g_b8
    (the  true  Gram  point  -  g_a9  =  g_b8,  recorded  exact
    dyadic  ball  3 000 175 370 181.355046086348  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a9  =  g_a8  <  gB8Lo  <  g_b8  puts
    t0  in  window  8's  region  (g_a8,  g_b8])  -  or
    t0  >  g_b8  =  g_a9,  in  which  case  t0  <=  tCE9  <
    gB9Lo  <=  g_b9  puts  t0  in  window  9's  region
    (g_a9,  g_b9].  The  two  certified  regions  union  to
    (g_a8,  g_b9]  which  contains  (gB8Lo,  tCE9]  (machine:
    gB8Lo  <  tCE9  <  gB9Lo).  Named  Prop  consumed  as  a
    hypothesis;  not  proven  in-tree.  -/
def ce9WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB8Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE9 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE9]  are  on  the  line,  given  the  nine
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo  are  pure
    case  splits.  -/
theorem bandOfWindows9 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : ce8WinClauseFull) (h9 : ce9WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE9 : ℝ) → ρ.re = 1 / 2 := by
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
                · exact h9 ρ hz (not_le.mp hseam8) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the  nine
    cited  window  clauses  =>  the  on-line  census  holds  up
    to  tCE9.  -/
theorem allOnLineUpToCE9 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : ce8WinClauseFull)
    (hW9 : ce9WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE9 : ℝ) := by
  have hband := bandOfWindows9 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (ninth  run):  no  off-line
    zero  with  positive  height  above  tCE9.  -/
def terminalFaceCE9 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE9 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE8  face  implies  the  CE9  face
    (tCE9  >  tCE8).  -/
theorem faceCE8_implies_faceCE9 (q : ZeroSet)
    (hface : CE8.terminalFaceCE8 q) :
    terminalFaceCE9 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE8_lt_tCE9, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE8,  tCE9]  is  certified  empty
    (windows  8+9  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the  same
    open  object,  now  certified  4 673  higher).  -/
theorem terminalFaceCE9_iff_faceCE8 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW6 : CE7.ce6WinClauseFull) (hW7 : CE8.ce7WinClauseFull)
    (hW8 : ce8WinClauseFull) (hW9 : ce9WinClause) :
    terminalFaceCE9 q ↔ CE8.terminalFaceCE8 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE9 : ℝ)
    · by_cases hseam6 : ρ.im ≤ (gB6Lo : ℝ)
      · exact hW6 ρ (hqz ρ hρ) (by linarith [ht, gB5Lo_lt_tCE6, tCE6_lt_tCE7, tCE7_lt_tCE8]) hseam6
      · by_cases hseam7 : ρ.im ≤ (gB7Lo : ℝ)
        · exact hW7 ρ (hqz ρ hρ) (not_le.mp hseam6) hseam7
        · by_cases hseam8 : ρ.im ≤ (gB8Lo : ℝ)
          · exact hW8 ρ (hqz ρ hρ) (not_le.mp hseam7) hseam8
          · exact hW9 ρ (hqz ρ hρ) (not_le.mp hseam8) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE8_implies_faceCE9 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE9  (pure
    logic).  -/
theorem rh_split_at_CE9 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE9 : ℝ) ∧ terminalFaceCE9 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE9 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE9 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  nine  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  [CE3-WIN-FULL],
    [CE4-WIN-FULL],  [CE5-WIN-FULL],  [CE6-WIN-FULL],
    [CE7-WIN-FULL],  [CE8-WIN-FULL],  [CE9-WIN]),  all-heights
    RH  <->  terminalFaceCE9.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE9 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : ce8WinClauseFull)
    (hW9 : ce9WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE9 q := by
  have hcensus := allOnLineUpToCE9 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hqz
  have hsplit := rh_split_at_CE9 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE9 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : ce8WinClauseFull)
    (hW9 : ce9WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE9 q) :
    RH q :=
  (rh_reanchored_CE9 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE9_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE9 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE9
