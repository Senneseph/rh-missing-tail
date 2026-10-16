/- S1Uniform  --  the  S1  UNIFORM  STATEMENT  +  WALK
   COMPOSITION  (v3).

   Motive
   ------
   P12.S1  (the  zero-side  leg)  is  "proven  pointwise  in
   the  audited  bands;  uniform  height  =  open".  This
   module  closes  the  uniform  side  of  that  comment  and
   composes  it  with  the  walk:

     (1)  e1BelowGWholeFromSample  (Part  A):  on  the
         below-G  face  domain  (G0,  GH]  the  wp  face  M_wp
         is  finite  and  C^1  (the  wp  pairing  cancels  the
         self-zero  cusp  below  G_LAST  -  M_wp  sums  only
         FAR  zeros,  all  at  distance  >=  G_LAST - t  from
         any  t  <=  GH)  -  so  the  classical  two-sided
         sample  ->  uniform  bridge  (S1Sample.sampleToUniform)
         applies  to  M_wp  ITSELF,  no  defect  subtraction:
         row  face  +  Lipschitz  face  +  cover
           =>  |M_wp  t|  <=  Bb  +  L1 * Dv1  on  the  domain.

     (2)  s1UniformFace  /  s1UniformStatement  (Part  B):
         the  FULL  program-domain  uniform  statement  on
         (G0,  T_MEAS]  as  a  single  named  face:
           below  G  (G0, GH]:        TWO-SIDED   |M_wp| <= ...
           dead  zone  (GH, G_LAST]:  TWO-SIDED   |M_wp| <= Bdead
                                       (the  measured  plunge,
                                       s10:  11  rows  0.94G..G,
                                       max  85772092.45510864)
           above  G  (G_LAST, T_MEAS]:  ONE-SIDED  (upper,
                                       the  E1  threat
                                       direction)
                                       Mres  t  <=  B + L * Dv
                                       +  C .  n .  log(1 + Dv/eps)
         -  from  the  S1Cusp  cusp-aware  bridge  (the  face
         truly  goes  to  -oo  at  the  super-G  zeros,  so
         ONE  side  is  the  honest  full-domain  statement
         there).  Proven  by  composition:  Part  A +  the
         dead-zone  datum  +  S1Cusp.e1CuspWholeFromRows.

     (3)  s1UniformAndWalk  (Part  C):  the  chain.  Under
         the  S1  uniform  premises  (which  CARRY  the  uniform
         statement  -  certified  in  the  proof  body),  the
         named  data  clause  E1ClauseV3  q  7000  (the  E1
         row-face  hole,  data-supported),  and  the  four
         structural  walk  legs  (hs1  -  hs4  on  P12.offPair),
         RH  follows.  Pure  composition  through
         E1C.if_E1V3_and_walk.  No  RH  claim.

   Honesty  (locked):  the  data  premises  (row  faces,
   Lipschitz  faces,  covers,  dead-zone  face,  cusp  spacing,
   cusp  amplitude)  are  DATA-SUPPORTED,  not  proven;  the
   bridges  are  the  proven  instruments;  E1ClauseV3  q  7000
   remains  the  named  open  data  clause.  At  the  measured
   constants  both  bridge  bounds  are  VACUOUS  (Part  D)  -
   the  operative  between-row  control  is  the  cusp  face
   robustness  and  the  P12  squeeze  leg.  No  RH  claim.
   -/
import Mathlib
import RhAttack.B0
import RhAttack.E1Clause
import RhAttack.S1Sample
import RhAttack.S1Cusp
import RhAttack.P12Uniform
import RhAttack.ZetaZeroSet

set_option linter.style.docString false
set_option linter.style.longLine false

namespace S1U

open Real B0 Set Finset E1C S1CS

/-  ##  Part  A  --  the  below-G  whole-domain  face  (new)
    -/
/--  TWO-SIDED  whole-domain  face  of  M_wp  on  the
    below-G  face  domain  (G0,  GH],  from  the  ROW
    FACE  +  the  LIP  FACE  +  the  COVER  (all  three
    DATA  hypotheses  here;  their  support  is  the
    S1Sample  Part  C  gate:  s8  row  face  B  =  2,
    s24  L1  =  13.5856,  the  s8  cover).  This  is
    the  scope-note  reduction  of  S1Sample  made
    explicit:  below  G  the  wp  face  is  finite  and
    C^1,  so  the  t-Lipschitz  bridge  applies  to
    M_wp  itself,  with  NO  defect  subtraction.  -/
theorem e1BelowGWholeFromSample (q : ZeroSet)
    (G0 GH B L Dv : ℝ)
    (hG0 : 0 < G0) (hGHO : G0 < GH) (hGHlast : GH < G_LAST)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 ≤ Dv)
    (hLip : ∀ a b, G0 < a → a ≤ GH → G0 < b → b ≤ GH →
      |M_wp q a - M_wp q b| ≤ L * |a - b|)
    (hCover : ∀ t, G0 < t → t ≤ GH →
      ∃ u, G0 < u ∧ u ≤ GH ∧ |t - u| ≤ Dv ∧ |M_wp q u| ≤ B) :
    ∀ t, G0 < t → t ≤ GH → |M_wp q t| ≤ B + L * Dv :=
  sampleToUniform (M_wp q) G0 GH B L Dv hB hL hDv hLip hCover

/-  ##  Part  B  --  the  S1  UNIFORM  STATEMENT
    (full  program  domain,  one  named  face)  -/
/--  SHAPE  of  the  S1  uniform  statement  on  the
    program  domain  (G0,  T_MEAS]:  TWO-SIDED  below
    G  on  (G0, GH],  TWO-SIDED  on  the  dead  zone
    (GH, G_LAST]  (the  measured  plunge),  and
    ONE-SIDED  upper  (the  E1  threat  direction)  on
    (G_LAST, T_MEAS]  -  the  face  tends  to  -oo  at
    the  super-G  zeros  there,  so  a  two-sided
    full-domain  bound  is  not  the  right  shape
    above  G  (the  row  face  is  two-sided  AT  the
    rows  --  the  E1ClauseV3  datum).  `Cn`  is
    (n :  ℝ)  (the  number  of  super-G  cusps  in
    the  cover  gap);  `C`  is  their  uniform
    amplitude  bound.  -/
def s1UniformFace (q : ZeroSet)
    (G0 GH Bb L1 Dv1 Bdead B2 L2 Dv2 C Cn eps : ℝ) : Prop :=
  (∀ t, G0 < t → t ≤ GH → |M_wp q t| ≤ Bb + L1 * Dv1) ∧
  (∀ t, GH < t → t ≤ G_LAST → |M_wp q t| ≤ Bdead) ∧
  (∀ t, G_LAST < t → t ≤ T_MEAS →
    Mres q t ≤ B2 + L2 * Dv2 + C * Cn * log (1 + Dv2 / eps))

/--  THE  S1  UNIFORM  STATEMENT:  from  the  three
    data  faces  -  (a)  the  below-G  row  face  +
    L1  face  +  cover,  (b)  the  dead-zone  plunge
    face  (s10),  (c)  the  above-G  cusp  face
    identity  +  row  face  +  cover  +  cusp  spacing
    +  cusp  amplitude  -  the  full  program-domain
    uniform  face  follows.  Pure  composition:
    Part  A  +  the  dead-zone  datum  +
    S1CS.e1CuspWholeFromRows.  -/
theorem s1UniformStatement (q : ZeroSet)
    {n : ℕ} (h : ℝ → ℝ) (c g : Fin n → ℝ)
    (G0 GH Bb L1 Dv1 Bdead B L Dv C eps : ℝ)
    (rows : Set ℝ)
    (hG0 : 0 < G0) (hGHO : G0 < GH) (hGHlast : GH < G_LAST)
    (hBb : 0 ≤ Bb) (hL1 : 0 ≤ L1) (hDv1 : 0 ≤ Dv1)
    (hBdead : 0 ≤ Bdead)
    (hLipB : ∀ a b, G0 < a → a ≤ GH → G0 < b → b ≤ GH →
      |M_wp q a - M_wp q b| ≤ L1 * |a - b|)
    (hCoverB : ∀ t, G0 < t → t ≤ GH →
      ∃ u, G0 < u ∧ u ≤ GH ∧ |t - u| ≤ Dv1 ∧ |M_wp q u| ≤ Bb)
    (hDead : ∀ t, GH < t → t ≤ G_LAST → |M_wp q t| ≤ Bdead)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 < Dv)
    (hC : 0 ≤ C) (heps : 0 < eps) (hdv1 : 1 - eps ≤ Dv)
    (hLip : ∀ a b, |h a - h b| ≤ L * |a - b|)
    (hc : ∀ j, 0 ≤ c j) (hC2 : ∀ j, c j ≤ C)
    (hface : ∀ t, G_LAST < t → t ≤ T_MEAS →
      Mres q t = cuspFace n h c g t)
    (hrowData : ∀ u, u ∈ rows → G_LAST < u → u ≤ T_MEAS →
      |Mres q u| ≤ B)
    (hcover : ∀ t, G_LAST < t → t ≤ T_MEAS →
      ∃ u, u ∈ rows ∧ G_LAST < u ∧ u ≤ T_MEAS ∧ |t - u| ≤ Dv)
    (hspData : ∀ u, u ∈ rows → G_LAST < u → u ≤ T_MEAS →
      ∀ j, eps ≤ |u - g j|) :
    s1UniformFace q G0 GH Bb L1 Dv1 Bdead B L Dv C (n : ℝ) eps :=
  ⟨e1BelowGWholeFromSample q G0 GH Bb L1 Dv1 hG0 hGHO
     hGHlast hBb hL1 hDv1 hLipB hCoverB,
    hDead,
    e1CuspWholeFromRows (n := n) q h c g B L Dv C eps
      rows hB hL hDv hC heps hdv1 hLip hc hC2 hface
      hrowData hcover hspData⟩

/-  ##  Part  C  --  the  CHAIN:  S1  uniform  +  walk
    -/
/--  S1  UNIFORM  STATEMENT  +  WALK  COMPOSITION  (v3):
    under  the  S1  uniform  premises  (Part  B's
    premises;  the  uniform  face  they  carry  is
    certified  in  the  proof  body),  the  named
    DATA  clause  E1ClauseV3  q  7000  (the  E1
    above-G  row  face,  21  measured  rows),  and  the
    four  structural  walk  legs  on  P12.offPair
    (the  S1..S4  legs  of  the  P1.2  contract,
    exactly  as  if_E1V3_and_walk  takes  them),  RH  follows
    on  any  structural  zero  set  q.  Pure
    composition  through  E1C.if_E1V3_and_walk.
    The  named  open  data  items  are  unchanged:
    E1ClauseV3  q  7000  (row  face)  +  the  bridge
    data  premises;  NO  RH  claim.  -/
theorem s1UniformAndWalk (q : ZeroSet)
    (hz : ZetaZeroSet.ZetaLike q)
    {n : ℕ} (h : ℝ → ℝ) (c g : Fin n → ℝ)
    (G0 GH Bb L1 Dv1 Bdead B L Dv C eps : ℝ)
    (rows : Set ℝ)
    (hG0 : 0 < G0) (hGHO : G0 < GH) (hGHlast : GH < G_LAST)
    (hBb : 0 ≤ Bb) (hL1 : 0 ≤ L1) (hDv1 : 0 ≤ Dv1)
    (hBdead : 0 ≤ Bdead)
    (hLipB : ∀ a b, G0 < a → a ≤ GH → G0 < b → b ≤ GH →
      |M_wp q a - M_wp q b| ≤ L1 * |a - b|)
    (hCoverB : ∀ t, G0 < t → t ≤ GH →
      ∃ u, G0 < u ∧ u ≤ GH ∧ |t - u| ≤ Dv1 ∧ |M_wp q u| ≤ Bb)
    (hDead : ∀ t, GH < t → t ≤ G_LAST → |M_wp q t| ≤ Bdead)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 < Dv)
    (hC : 0 ≤ C) (heps : 0 < eps) (hdv1 : 1 - eps ≤ Dv)
    (hLip : ∀ a b, |h a - h b| ≤ L * |a - b|)
    (hc : ∀ j, 0 ≤ c j) (hC2 : ∀ j, c j ≤ C)
    (hface : ∀ t, G_LAST < t → t ≤ T_MEAS →
      Mres q t = cuspFace n h c g t)
    (hrowData : ∀ u, u ∈ rows → G_LAST < u → u ≤ T_MEAS →
      |Mres q u| ≤ B)
    (hcover : ∀ t, G_LAST < t → t ≤ T_MEAS →
      ∃ u, u ∈ rows ∧ G_LAST < u ∧ u ≤ T_MEAS ∧ |t - u| ≤ Dv)
    (hspData : ∀ u, u ∈ rows → G_LAST < u → u ≤ T_MEAS →
      ∀ j, eps ≤ |u - g j|)
    (hE3 : E1ClauseV3 q 7000)  -- the named data hole
    (Qside Mf devOf Bwire Mr flo : ℝ × ℝ → ℝ)
    (hs1 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Qside (t0, d0) ≥ devOf (t0, d0) - Mf (t0, d0))
    (hs2 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      devOf (t0, d0) ≥ flo (t0, d0))
    (hs3 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Qside (t0, d0) ≤ Bwire (t0, d0) + Mr (t0, d0))
    (hs4 : ∀ (t0 d0 : ℝ), 0 < t0 → 0 < d0 →
      P12.offPair q t0 d0 →
      Bwire (t0, d0) + Mr (t0, d0) + Mf (t0, d0) <
        flo (t0, d0)) :
    RH q := by
  --  The  S1  uniform  statement  is  carried  by  the
  --  premises  (certified  here;  the  "uniform
  --  height"  side  of  P12.S1  is  the  proven  part
  --  of  the  chain):
  have hunif : s1UniformFace q G0 GH Bb L1 Dv1 Bdead
      B L Dv C (n : ℝ) eps :=
    s1UniformStatement q (n := n) h c g G0 GH Bb L1 Dv1
      Bdead B L Dv C eps rows hG0 hGHO hGHlast hBb
      hL1 hDv1 hBdead hLipB hCoverB hDead hB hL hDv
      hC heps hdv1 hLip hc hC2 hface hrowData hcover
      hspData
  exact if_E1V3_and_walk q hz hE3 Qside Mf devOf Bwire Mr
    flo hs1 hs2 hs3 hs4

/-  ##  Part  D  --  unified  data  gates  (Float,
    E7a-style;  the  VACUITY  LEDGER  in  one  place)
    -/
section UnifiedGates

/--  dead-zone  plunge  face  (s10  dead-zone  march:
    11  rows  over  0.94G .. 1.0G,  max  |M_wp|  -
    the  measured  support  of  the  hDead  premise)
    -/
def BdeadData : Float := 85772092.45510864

--  the  two  bridge  bounds  at  the  measured
--  constants  (re-recorded  so  the  unified  ledger
--  lives  here):
#eval BdeadData
#eval belowGUniformVacuous
#eval bridgeAddData
#eval s8_Bcand
#eval v3_Bcand

/-  AMENDMENT  (check  before  trusting):  the  dead-
    zone  face  is  measured  on  11  DENSE  rows
    (0.94G ..  1.0G);  the  between-row  dead-zone
    face  is  the  NAMED  data  premise  hDead  (the
    plunge  shape  is  the  same  cusp  structure  as
    above  G,  approaching  the  G_LAST  certified-
    zero  cusp  train);  the  below-G  bridge  bound
    belowGUniformVacuous  =  7.8931e10  and  the
    above-G  bridge  additive  bridgeAddData  =
    6.5570002736e15  are  BOTH  FORMAL  BUT  VACUOUS
    at  the  measured  constants  (9.367e11  x  B
    above,  ~4e7  x  B  below)  -  the  operative
    between-row  control  remains  the  cusp  face
    robustness  and  the  P12  squeeze  leg.  No  RH
    claim.  -/

end UnifiedGates

end S1U
