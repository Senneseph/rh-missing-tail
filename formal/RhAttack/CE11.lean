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

set_option linter.style.whitespace false
set_option linter.style.longLine false
set_option linter.style.docString false

open Real Set Complex Filter B0 P12 RHEnd CE1 CE2 CE3 CE4 CE5 CE6 CE7 CE8 CE9 CE10
open scoped Topology

/-!
**CE11 — the terminal face re-anchored at the ELEVENTH certified
window (0316, option B, unit 27 — lane M5, run 11:  OUR OWN
production, continuing the seamless chain:  windows
1 -> 2 -> ... -> 11).**

PROVENANCE (our run,  2026-11-06;  pipeline  =  Murphy's
Apache-2.0  deposit,  same  as  CE1-CE10):
  RUN  PARAMETERS:  a  =  12 363 153 637 127  (=  CE10's  final
  b;  seamless),  b_requested  =  a  +  20 000  =
  12 363 153 657 127,  driver  snapped  the  final  b  DOWN  to
  12 363 153 657 126  (12 363 153 657 127  was  not  a  good
  Gram  point  at  the  working  precision;  a  itself  needed
  NO  snap),  M  =  60,  C_R  =  1,  28  workers,  33 310
  evaluations  in  2536.6  s.
  CERTIFICATE  (window11_b11.json):  the  b  −  a  =  19 999
  zeros  of  ζ  with  g_a11  <  Im  s  <=  g_b11  are  ALL
  SIMPLE  and  on  the  line,  where
      g_a11  (recorded  exact  dyadic  ball,  this  run's  a)
            =  3 000 175 379 527.225312012897  + or -  1.29e-26
            and  this  ball  is  BIT-IDENTICAL  to  CE10's
            recorded  g_b10  (exact  dyadic  tuple  comparison,
            2026-11-06);
      g_b11  =  3 000 175 384 199.926797813571  + or -
               1.29e-26  (exact  dyadic  decode;  the
               FLOOR  tCE11  sits  0.9268  above  the  previous
               integer,  robust  to  the  radius  of  1.29e-26
               by  many  orders  of  magnitude).
      Turing  runs  of  consecutive  good  Rosser  blocks:  46
      left  of  g_a11,  51  right  of  g_b11  (both  >=  K  =
      12);  0  cross-check  failures  (all  33 310  records);
      0  undetermined  Gram  signs.  INTERNAL  ROSSER-BLOCK
      EXCEPTION:  ONE,  RESCUED  BY  THE  PIPELINE'S
      DOCUMENTED  3-BLOCK  UNION  REFINEMENT  (window.py):
        block  [12 363 153 644 976,  .. 644 979]  rescued  to
        union  [.. 644 974,  .. 644 981],  need  7  =  found
        7,  m  =  8.  As  in  windows  2/3/4/5/7/9,  the
        rescued  zero  was  DISPLACED  into  an  adjacent  Gram
        interval;  the  independent  verifier  recomputes  the
        WINDOW  TOTAL  (sign_changes_inside  =  19 999)  and
        the  two  end  Rosser  runs  (46  /  51)  -  the  only
        quantities  that  enter  the  Turing  step.  Recorded,
        not  suppressed.
  VERIFICATION  (three  layers,  same  as  CE2-CE10):
    (1)  ENVIRONMENT  REPEAT  (Murphy's  window-1
         certificate  re-verified  -  see  CE2  header);
    (2)  PIPELINE  VERIFIER  on  window11_b11.json:
         "CERTIFIED:  true",  points_checked  =  33 310,
         sign_changes_inside  =  19 999  =  b  −  a,
         roesser_failures_inside  =  1  (rescued,  union
         quota  met),  turing_ok  =  true,
         K_conservative  =  12,  endpoints  recomputed  and
         matched;
    (3)  SEAM  AUDIT  (this  run):  the  recorded  g_a11  ball
         is  bit-identical  to  CE10's  recorded  g_b10  ball
         (exact  dyadic  decode,  2026-11-06).
  FRONTIER  ARITHMETIC  (machine,  below):
      tCE11  =  3 000 175 384 199,
      tCE11  −  tCE10  =  4 672   (face  shrink  past  tCE10;
                            4 672  here,  not  4 673,  because
                            this  window  carried  19 999
                            zeros,  not  20 000  -  the  final
                            b  was  snapped  down  one),
      tCE11  −  tPT2  = 51 399  (above  the  Platt-Trudgian
      H0),
      certified  zeros  over  (g_a1,  g_b11]  =  20 000  +
      19 999  +  19 999  +  20 000  +  20 000  +  20 000  +
      20 000  +  19 999  +  20 000  +  20 000  +  19 999  =
      219 996.
  HONESTY  (trust  base):  as  CE2-CE10  -  the  pipeline's
  own  controls,  its  kernel-checked  Lean  remainder
  theorem,  and  our  three  verification  layers;  a  RE-RUN
  of  a  third-party  pipeline,  not  a  from-scratch
  independent  certification.  NO  RH  CLAIM.  -/

namespace CE11

/-! ### 1.  The  certified  constants
-/
/-- Certified  LOWER  bound  for  g_b11  (the  recorded  ball  is
    3 000 175 384 199.926797813571  with  radius  ~= 1.29e-26;
    this  rational  rounds  the  bottom  down,  margin
    ~= 5.8e-2  up  to  the  floor  tCE11).  -/
def gB11Lo : ℚ := 300017538419992 / 100

/-- THE  NEW  CERTIFIED  CENSUS  FRONTIER:  an  integer  strictly
    below  the  certified  lower  bound  gB11Lo:
    tCE11  =  3 000 175 384 199.  -/
def tCE11 : ℕ := 3000175384199

theorem tCE11_lt_gB11Lo : (tCE11 : ℝ) < (gB11Lo : ℝ) := by
  norm_num [gB11Lo, tCE11]

theorem tCE10_lt_tCE11 : (tCE10 : ℝ) < (tCE11 : ℝ) := by
  norm_num [CE10.tCE10, tCE11]

/-- Record:  the  seam  order  gB10Lo  <  tCE11  (the  band
    (gB10Lo,  tCE11]  is  nonempty  and  lies  above  CE10's
    frontier  tCE10).  -/
theorem gB10Lo_lt_tCE11 : (gB10Lo : ℝ) < (tCE11 : ℝ) := by
  norm_num [CE10.gB10Lo, tCE11]

/-- The  face  height  shrunk  by  further  4 672  units  past
    tCE10  (4 672  here,  not  4 673:  this  window  carried
    19 999  zeros;  the  final  b  was  snapped  down  one).  -/
theorem faceShrinkCE11 : (tCE11 : ℝ) - (tCE10 : ℝ) = 4672 := by
  norm_num [tCE11, CE10.tCE10]

/-- The  new  frontier  is  51 399  units  above  the
    Platt-Trudgian  frontier  H0  (machine).  -/
theorem frontierGapAboveH0 : (tCE11 : ℝ) - WinC.tPT2 = 51399 := by
  norm_num [tCE11, WinC.tPT2]

/-- (PROVEN,  machine)  the  slice  is  well  ordered:
    gB9Lo  <  gB10Lo  (re-stated  at  the  CE11  level  from
    CE10's  window-10  band  ordering).  -/
theorem gB9Lo_lt_gB10Lo : (gB9Lo : ℝ) < (gB10Lo : ℝ) := by
  norm_num [CE9.gB9Lo, CE10.gB10Lo]

/-- Record:  the  rationalized  slice  caps  are  well  ordered
    (gB10Lo  <  gB11Lo)  -  the  window-11  band  (gB10Lo,
    gB11Lo]  (hence  (gB10Lo,  tCE11])  lies  strictly  above
    window  10's  certified  region.  -/
theorem gB10Lo_lt_gB11Lo : (gB10Lo : ℝ) < (gB11Lo : ℝ) := by
  norm_num [CE10.gB10Lo, gB11Lo]

/-! ### 2.  The  cited  window  clauses  (Z78  pattern)
-/
/-- [CITED,  OUR  WINDOW-10  RUN  (window10_b10.json),  FULL
    SLICE]  every  zeta  zero  with  gB9Lo  <  Im  ρ  <=  gB10Lo
    is  on  the  critical  line.  Derivation  (recorded):  the
    region  (gB9Lo,  gB10Lo]  lies  inside  (g_a10,  g_b10]  -
    window  10's  own  certified  region  -  since  gB9Lo  is
    the  certified  bottom  of  g_a10  (=  g_b9,  bit-identical
    dyadic  ball  in  windows  9 and  10)  and  gB10Lo  the
    certified  bottom  of  g_b10  (machine:  gB9Lo  <  gB10Lo,
    below).  Named  Prop  consumed  as  a  hypothesis;  not
    proven  in-tree.  -/
def ce10WinClauseFull : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB9Lo : ℝ) < ρ.im →
      ρ.im ≤ (gB10Lo : ℝ) → ρ.re = 1 / 2

/-- [CITED,  OUR  WINDOW-11  RUN  (window11_b11.json),  SLICE]
    every  zeta  zero  with  gB10Lo  <  Im  ρ  <=  tCE11  is  on
    the  critical  line.  Derivation  (recorded):  for
    t0  =  Im  ρ  in  (gB10Lo,  tCE11],  either  t0  <=  g_b10
    (the  true  Gram  point  -  g_a11  =  g_b10,  recorded  exact
    dyadic  ball  3 000 175 379 527.225312012897  +  or  -
    1.29e-26,  bit-identical  in  both  certificates;  the
    numerical  order  g_a11  =  g_a10  <  gB10Lo  <  g_b10
    puts  t0  in  window  10's  region  (g_a10,  g_b10])  -
    or  t0  >  g_b10  =  g_a11,  in  which  case  t0  <=  tCE11
    <  gB11Lo  <=  g_b11  puts  t0  in  window  11's  region
    (g_a11,  g_b11].  The  two  certified  regions  union  to
    (g_a10,  g_b11]  which  contains  (gB10Lo,  tCE11]
    (machine:  gB10Lo  <  tCE11  <  gB11Lo).  Named  Prop
    consumed  as  a  hypothesis;  not  proven  in-tree.  -/
def ce11WinClause : Prop :=
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → (gB10Lo : ℝ) < ρ.im →
      ρ.im ≤ (tCE11 : ℝ) → ρ.re = 1 / 2

/-- THE  COMPOSITE  BAND  CLAUSE  (machine):  zeros  in
    (tPT2,  tCE11]  are  on  the  line,  given  the  eleven
    window  clauses  -  the  splits  at  gA2Hi,  gB2Lo,
    gB3Lo,  gB4Lo,  gB5Lo,  gB6Lo,  gB7Lo,  gB8Lo,  gB9Lo,
    gB10Lo  are  pure  case  splits.  -/
theorem bandOfWindows11 (h1 : CE2.ce1WinClause)
    (h2 : CE3.ce2WinClauseFull) (h3 : CE4.ce3WinClauseFull)
    (h4 : CE5.ce4WinClauseFull) (h5 : CE6.ce5WinClauseFull)
    (h6 : CE7.ce6WinClauseFull) (h7 : CE8.ce7WinClauseFull)
    (h8 : CE9.ce8WinClauseFull) (h9 : CE10.ce9WinClauseFull)
    (h10 : ce10WinClauseFull) (h11 : ce11WinClause) :
    ∀ (ρ : ℂ), riemannZeta ρ = 0 → WinC.tPT2 < ρ.im →
      ρ.im ≤ (tCE11 : ℝ) → ρ.re = 1 / 2 := by
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
                    · exact h11 ρ hz (not_le.mp hseam10) htH

/-! ### 3.  The  machine-verified  re-anchoring
-/
/-- M5  ·  THE  FRONTIER  MOVED  AGAIN:  [Z-PT2]  +  the
    eleven  cited  window  clauses  =>  the  on-line  census
    holds  up  to  tCE11.  -/
theorem allOnLineUpToCE11 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : ce10WinClauseFull)
    (hW11 : ce11WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    WinC.allOnLineUpTo q (tCE11 : ℝ) := by
  have hband := bandOfWindows11 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11
  intro ρ hρ ht htH
  by_cases hmid : ρ.im ≤ WinC.tPT2
  · exact hZPT2 ρ hρ ht hmid
  · exact hband ρ (hqz ρ hρ) (not_le.mp hmid) htH

/-- M5  ·  THE  RE-ANCHORED  FACE  (eleventh  run):  no  off-line
    zero  with  positive  height  above  tCE11.  -/
def terminalFaceCE11 (q : ZeroSet) : Prop :=
    ∀ (ρ : ℂ), ρ ∈ q.Z → (tCE11 : ℝ) < ρ.im → ρ.re = 1 / 2

/-- Pure  logic:  the  CE10  face  implies  the  CE11  face
    (tCE11  >  tCE10).  -/
theorem faceCE10_implies_faceCE11 (q : ZeroSet)
    (hface : CE10.terminalFaceCE10 q) :
    terminalFaceCE11 q := by
  intro ρ hρ ht
  exact hface ρ hρ (by linarith [tCE10_lt_tCE11, ht])

/-- M5  ·  THE  TWO  FACE  FORMULATIONS,  EQUIVALENT  UNDER  THE
    BAND:  the  extra  band  (tCE10,  tCE11]  is  certified
    empty  (windows  10+11  together)  -  re-anchoring  is  a
    CERTIFICATE,  not  a  logical  move  (the  face  is  the
    same  open  object,  now  certified  4 672  higher).  -/
theorem terminalFaceCE11_iff_faceCE10 (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hW10 : ce10WinClauseFull) (hW11 : ce11WinClause) :
    terminalFaceCE11 q ↔ CE10.terminalFaceCE10 q := by
  constructor
  · intro hface ρ hρ ht
    by_cases hmid : ρ.im ≤ (tCE11 : ℝ)
    · by_cases hseam10 : ρ.im ≤ (gB10Lo : ℝ)
      · exact hW10 ρ (hqz ρ hρ) (by linarith [ht, gB9Lo_lt_tCE10, tCE10_lt_tCE11]) hseam10
      · exact hW11 ρ (hqz ρ hρ) (not_le.mp hseam10) hmid
    · exact hface ρ hρ (not_le.mp hmid)
  · exact faceCE10_implies_faceCE11 q

/-- M5  ·  THE  0288  EXACT  RESIDUAL,  RE-PINNED  AT  tCE11
    (pure  logic).  -/
theorem rh_split_at_CE11 (q : ZeroSet) :
    RH q ↔ WinC.allOnLineUpTo q (tCE11 : ℝ) ∧ terminalFaceCE11 q := by
  constructor
  · intro hRH
    exact ⟨fun ρ hρ him himH => hRH ρ hρ, fun ρ hρ himgt => hRH ρ hρ⟩
  · rintro ⟨hCensus, hFace⟩ ρ hρ
    by_cases hpos : 0 < ρ.im
    · by_cases hle : ρ.im ≤ (tCE11 : ℝ)
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
        by_cases hle : (star ρ).im ≤ (tCE11 : ℝ)
        · exact hCensus _ hst hstpos hle
        · exact hFace _ hst (not_le.mp hle)
      have hreEq : (star ρ).re = ρ.re := by rfl
      simpa [hreEq] using hstRe

/-- M5  ·  HEADLINE:  given  [Z-PT2]  +  the  eleven  cited
    window  clauses  ([CE1-WIN],  [CE2-WIN-FULL],  ...,
    [CE10-WIN-FULL],  [CE11-WIN]),  all-heights  RH  <->
    terminalFaceCE11.  NO  RH  CLAIM.  -/
theorem rh_reanchored_CE11 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : ce10WinClauseFull)
    (hW11 : ce11WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0) :
    RH q ↔ terminalFaceCE11 q := by
  have hcensus := allOnLineUpToCE11 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hqz
  have hsplit := rh_split_at_CE11 q
  constructor
  · exact fun hRH => (hsplit.mp hRH).2
  · exact fun hFace => hsplit.mpr ⟨hcensus, hFace⟩

/-- M5  ·  THE  FINAL  NAMED  STEP  AT  THE  NEW  FRONTIER:
    given  the  cited  census  inputs  and  a  closing  of  the
    re-anchored  face,  all-heights  RH  holds.  NO  RH  CLAIM:
    no  closing  is  supplied.  -/
theorem rh_of_terminalFaceCE11 (q : ZeroSet)
    (hZPT2 : WinC.allOnLineUpTo q WinC.tPT2)
    (hW1 : CE2.ce1WinClause) (hW2 : CE3.ce2WinClauseFull)
    (hW3 : CE4.ce3WinClauseFull) (hW4 : CE5.ce4WinClauseFull)
    (hW5 : CE6.ce5WinClauseFull) (hW6 : CE7.ce6WinClauseFull)
    (hW7 : CE8.ce7WinClauseFull) (hW8 : CE9.ce8WinClauseFull)
    (hW9 : CE10.ce9WinClauseFull) (hW10 : ce10WinClauseFull)
    (hW11 : ce11WinClause)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hFace : terminalFaceCE11 q) :
    RH q :=
  (rh_reanchored_CE11 q hZPT2 hW1 hW2 hW3 hW4 hW5 hW6 hW7 hW8 hW9 hW10 hW11 hqz).mpr hFace

/-- M5  ×  M2  ·  the  0290  lane  closing  lands  DIRECTLY  at
    the  new  frontier.  -/
theorem terminalFaceCE11_of_thetaInf (q : ZeroSet)
    (hqz : ∀ ρ ∈ q.Z, riemannZeta ρ = 0)
    (hInf : ThetaInf.thetaInfImpliesAllOnLine)
    (hC : ThetaInf.thetaInfConjecture) :
    terminalFaceCE11 q := by
  intro ρ hρ ht
  have hall := hInf hC
  exact hall ρ (hqz ρ hρ)

end CE11
