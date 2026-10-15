/- S1Sample  --  the  sample  ->  uniform  bridge  for  the  S1
   leg  (the  zero-side  face).

   Motive
   ------
   The  measured  data  supports  the  residual  face
   |M_wp  q  t  -  M_defect  t|  <=  B  at  DISCRETE  sample
   heights  (the  straddle  rows  and  the  log-spaced  far
   rows),  not  pointwise.  The  whole-domain  form  of  the
   clause  (and  the  walk  composition  that  consumes  it)
   needs  the  pointwise  statement.  The  gap  is  exactly
   the  classical  Lipschitz  +  cover  interpolation,  which
   is  PROVEN  below  (pure  real  analysis);  what  remains
   OPEN  after  the  reduction  are  three  DATA  claims:

     (1)  ROW  FACE:   |M_wp  q  u  -  M_defect  u|  <=  B
           on  the  sample  heights           (measured,
           #eval-gated,  PART  C2  of  E1Clause)
     (2)  LIP  FACE:   |M_wp'|  bounded  (the  derivative
           closure  of  the  channels,  s23  data)
     (3)  COVER:       every  point  of  the  domain  is
           within  Dv  of  a  sample  height  (measured  max
           gap)

   No  RH  claim.  The  reduced  face  carries  a  WORSE
   constant  (B  +  L*Dv)  than  the  row  face  B  --  that
   is  the  price  of  the  whole-domain  quantification  on
   a  log-spaced  sample.  -/
import Mathlib
import RhAttack.E1Clause

open Real
open E1C

/-  ##  Part  A  --  the  interpolation  lemma  (pure,  proven)  -/
section S1Lemma

variable (f : ℝ → ℝ)

theorem sampleToUniform (lo hi B L Dv : ℝ)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 ≤ Dv)
    (hLip : ∀ a b, lo < a → a ≤ hi → lo < b → b ≤ hi →
      |f a - f b| ≤ L * |a - b|)
    (hCover : ∀ t, lo < t → t ≤ hi →
      ∃ u, lo < u ∧ u ≤ hi ∧ |t - u| ≤ Dv ∧ |f u| ≤ B) :
    ∀ t, lo < t → t ≤ hi → |f t| ≤ B + L * Dv := by
  intro t htlhtt ht2
  obtain ⟨u, hut1, hut2, hud, hfu⟩ := hCover t htlhtt ht2
  have hdecomp : |f t| = |(f t - f u) + f u| := congrArg abs (by ring)
  calc |f t| = |(f t - f u) + f u| := hdecomp
    _ ≤ |f t - f u| + |f u| := abs_add_le (f t - f u) (f u)
    _ ≤ L * |t - u| + B :=
      add_le_add (hLip t u htlhtt ht2 hut1 hut2) hfu
    _ ≤ L * Dv + B :=
      add_le_add (mul_le_mul_of_nonneg_left hud hL) (le_rfl)
    _ = B + L * Dv := add_comm _ _

end S1Lemma

/-  ##  Part  B  --  the  glue  on  (G_LAST,  T_MEAS]  -/
namespace E1C

variable (q : ZeroSet)

/-- The  residual  face  f  =  M_wp  -  M_defect  on  the
    clause  domain  (G_LAST,  T_MEAS].  -/
noncomputable def Mres (q : ZeroSet) (t : ℝ) : ℝ :=
    M_wp q t - M_defect t

/--  WHOLE-DOMAIN  residual  face  from  row  face  +
    Lipschitz  face  +  cover  (all  three  are  hypotheses
    here  --  their  DATA  support  is  the  #eval  gate  in
    Part  C  /  s23).  -/
theorem e1V3WholeFromSample (B L Dv : ℝ)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 ≤ Dv)
    (hLip : ∀ a b, G_LAST < a → a ≤ T_MEAS → G_LAST < b →
      b ≤ T_MEAS → |Mres q a - Mres q b| ≤ L * |a - b|)
    (hCover : ∀ t, G_LAST < t → t ≤ T_MEAS →
      ∃ u, G_LAST < u ∧ u ≤ T_MEAS ∧ |t - u| ≤ Dv ∧
        |Mres q u| ≤ B) :
    ∀ t, G_LAST < t → t ≤ T_MEAS → |Mres q t| ≤ B + L * Dv := by
  intro t ht htT
  exact sampleToUniform (Mres q) G_LAST T_MEAS B L Dv
    hB hL hDv hLip hCover t ht htT

/--  The  whole-domain  face  RESTRICTS  to  the  straddle
    rows,  i.e.  to  the  named  v3  clause  itself.  -/
theorem e1V3FromWhole (B L Dv : ℝ)
    (whole : ∀ t, G_LAST < t → t ≤ T_MEAS →
      |Mres q t| ≤ B + L * Dv) :
    E1ClauseV3 q (B + L * Dv) := by
  intro t ht htT hst
  exact whole t ht htT

/-  ##  Part  C  --  data  faces  (#eval,  E7a-style)

   (1)  COVER  on  (G_LAST,  T_MEAS]:  the  21  in-domain
   sample  heights  (10  straddle  G+k/2  rows,  7  log
   rows  to  2.2G,  4  far  rows  10G..1000G)  have  max
   gap  Dv  =  the  2.2G  ->  10G  span.
   (2)  ROW  FACE:  PART  C2  of  E1Clause  (B  =  7000
   on  the  gated  21-row  face,  worst  6704.088  at
   2.2G).
   (3)  LIP  FACE:  L  =  max  |M'  -  A/t|  over  the
   sample  rows  (s23,  pending  --  see  DISCOVERY_LOG
   for  the  per-channel  precision  floors).
   Uniform  bound  candidate:  B  +  L*Dv.

   No  RH  claim.  -/
section DataGates

/-  The  cover  data  as  FLOAT  LITERALS  (E7a  gate
    protocol  --  the  Real  world  sits  on  classical
    axioms  and  is  not  #eval-able;  the  literal  is
    the  recorded  data,  Dv  above  is  the  exact  Real
    form  used  by  the  theorems).  -/
def gLastFloat : Float := 30001045999.981975555

/--  max  gap  on  (G,  1000G]  over  the  21  in-domain
    sample  heights  =  the  2.2G  ->  10G  span
    (7.8  *  G).  The  other  gaps:  G+5  ->  1.05G  is
    0.05*G  -  5  (smaller);  10G  ->  50G,  50G  ->
    100G,  100G  ->  1000G  are  40G,  50G,  900G  ...
    (900G  is  the  largest  --  see  the  amendment:
    the  gap  list  is  recorded  below  and  the  max  is
    900*G). 
 -/
def dvRatioData : Float := 900.0
def dvData : Float := dvRatioData * gLastFloat

def sampleCount : Float := 21.0

#eval sampleCount
#eval dvRatioData
#eval dvData

/-  AMENDMENT  (check  before  trusting):  the  21  rows
    are  G+0.5..G+5  (gap  <=  0.5),  then  1.05G,
    1.15G,  1.30G,  1.45G,  1.65G,  1.90G,  2.20G  (gaps
    <=  0.30G  +  the  G+5  ->  1.05G  gap  0.05G-5),
    then  10G,  50G,  100G,  1000G  (gaps  7.8G,  40G,
    50G,  900G).  MAX  GAP  =  900*G  =  2.7000941e13.
    (The  2.3383e11  figure  in  earlier  notes  was  the
    2.2G  ->  10G  gap  only  --  corrected  here.)  -/

end DataGates

end E1C
