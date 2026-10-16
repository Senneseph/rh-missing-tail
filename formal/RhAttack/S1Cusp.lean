/- S1Cusp  --  the  cusp-aware  between-row  bridge  (the  above-G
   sibling  of  S1Sample's  t-Lipschitz  bridge).

   Motive
   ------
   S1Sample's  bridge  (sampleToUniform)  needs  a  Lipschitz
   assumption  on  the  whole  face.  ABOVE  G,  the  wp  face
   M_wp  KEEPS  the  ln  zero  cusps  of  log|zeta|  at  the
   (mostly  un-certified)  true  super-G  zeros  (M_wp  ->
   -oo  there),  so  the  cusp-aware  statements  below  are
   the  in-scope  instrument:

     a  face  f  =  h  +  SUM  c_j  .  log  |t  -  g_j|,
     h  L-Lipschitz  (secant  form),  0  <=  c_j  <=  C
     (downward  ln  cusps):

       (1)  PLUNGE:      f  ->  -oo  as  t  ->  g_j  (the
                         cusp  dominates  a  locally
                         bounded-below  smooth  part)
       (2)  V-FLANK:     a  single  cusp  face  h +  c .
                         log|t  -  g|  is  strictly
                         decreasing  on  (g  -  c/(4L),
                         g)  and  strictly  increasing  on
                         (g,  g  +  c/(4L))  -  from  the
                         secant  Lipschitz  assumption  on
                         h  alone  (no  differentiability)
       (3)  BRIDGE:      f  measured  at  a  sample  height
                         u  with  |f  u|  <=  B,  |t  -  u|
                         <=  Dv,  and  the  row  u  at
                         spacing  >=  eps  from  every
                         cusp:
                            f (t)  <=  B  +  L  Dv  +  C  n
                            .  log  (1  +  Dv  /  eps)
                         for  EVERY  t  -  including  the
                         plunge  points  t  =  g_j  (the
                         convention  value  log  0  =  0
                         only  ever  HELPS  the  upper
                         bound;  the  true  face  ->  -oo
                         there  is  below  the  bound).
                         This  is  the  E1  threat
                         direction.  The  lower  side  is
                         NOT  controlled  (a  cusp  face  is
                         unbounded  below  near  its  cusps:
                         a  face  too  SMALL  is  not  the
                         E1  threat;  the  row  face  |f  u|
                         <=  B  stays  the  two-sided
                         clause  on  the  rows  themselves,
                         E1ClauseV3  q  7000).

   Pure  real  analysis,  no  zeta,  sorry-free.  No  RH
   claim.  The  Float  gates  (Part  D)  record  the  bridge
   ADDITIVUM  at  the  measured  constants  (VACUITY
   RECORD:  the  bridge  additive  term  exceeds  the  row
   face  by  ~  11  orders  at  the  900G  cover  -  the
   operative  between-row  control  remains  the  DATA  cusp
   face  [s23:  the  cusp  amplitude  AT  A  ROW  is  <=
   ln(1/d),  d  >=  0.013  =>  4.34  -  inside  the  row
   face]  and  the  P12  squeeze  leg,  named  open).
  -/
import Mathlib
import RhAttack.S1Sample

set_option linter.style.docString false

open Real
open Set

namespace S1CS

/--
A  face  =  a  smooth  part  h  +  a  finite  log-cusp
part.  The  cusp  terms  are  c_j  .  log  |t  -  g_j|;
at  t  =  g_j  the  mathlib  convention  log  0  =  0
assigns  the  term  the  value  0  (the  true  limit  is
-oo  when  c_j  >  0  -  see  cuspPlunge).
-/
noncomputable def cuspFace (n : ℕ) (h : ℝ → ℝ) (c g : Fin n → ℝ) (t : ℝ) : ℝ :=
    h t + (Finset.univ.sum fun j => c j * log |t - g j|)

/-  ##  1  -  the  plunge  -/

/--  A  single  log  cusp  with  positive  coefficient
    dominates  any  locally  bounded-ABOVE  smooth  part:
    h  +  c .  log  |t  -  g|  ->  -oo  as  t  ->  g.  -/
theorem cuspPlunge (h : ℝ → ℝ) (c : ℝ) (g : ℝ)
    (hc : 0 < c)
    (hb : BddAbove (h '' Icc (g - 1) (g + 1))) :
    ∀ M, ∃ δ, 0 < δ ∧ ∀ t, t ≠ g → |t - g| < δ →
      h t + c * log |t - g| < M := by
  obtain ⟨M0, hM0⟩ := hb
  intro M
  set x := (M - M0) / c with hx
  --  h  is  bounded  below  by  M0  within  1  of  g;
  --  the  log  term  is  <  x  for  |t  -  g|  <  exp  x.
  by_cases hx2 : Real.exp x ≤ 2
  · --  case  exp  x  <=  2:  delta  =  exp  x  /  2
    use Real.exp x / 2
    constructor
    · exact div_pos (Real.exp_pos x) (by norm_num)
    intro t hne hd
    have hhalf : Real.exp x / 2 ≤ 1 := (div_le_one (by norm_num : (0 : ℝ) < 2)).mpr hx2
    have ht1 : |t - g| < 1 := lt_of_lt_of_le hd hhalf
    have hIcc : t ∈ Icc (g - 1) (g + 1) := by
      rw [Set.mem_Icc]
      constructor <;> linarith [abs_lt.mp ht1]
    have hltExp : |t - g| < Real.exp x := by
      calc |t - g| < Real.exp x / 2 := hd
        _ < Real.exp x := div_lt_self (Real.exp_pos x) (by norm_num)
    have hlog : log |t - g| < x := by
      calc log |t - g| < log (Real.exp x) :=
          Real.log_lt_log (abs_pos.mpr (fun hh => hne (sub_eq_zero.mp hh))) hltExp
        _ = x := Real.log_exp x
    have hmemb : h t ∈ h '' Icc (g - 1) (g + 1) := Set.mem_image_of_mem h hIcc
    have hbound : h t ≤ M0 := hM0 hmemb
    have hstep1 : h t + c * log |t - g| ≤ M0 + c * log |t - g| := by
      linarith [hbound]
    have hstep2c : c * log |t - g| < c * x := mul_lt_mul_of_pos_left hlog hc
    have hstep2 : M0 + c * log |t - g| < M0 + c * x := by
      linarith [hstep2c]
    have hstep3 : M0 + c * x = M := by
      rw [hx]
      field_simp [hc.ne']
      ring
    exact lt_of_le_of_lt hstep1 (by simpa only [hstep3] using hstep2)
  · --  case  exp  x  >  2:  delta  =  1  /  2
    use (1 : ℝ) / 2
    constructor
    · norm_num
    intro t hne hd
    have hIcc : t ∈ Icc (g - 1) (g + 1) := by
      rw [Set.mem_Icc]
      constructor <;> linarith [abs_lt.mp hd]
    have hltExp : |t - g| < Real.exp x := by
      calc |t - g| < 1 / 2 := hd
        _ < 2 := by norm_num
        _ < Real.exp x := not_le.mp hx2
    have hlog : log |t - g| < x := by
      calc log |t - g| < log (Real.exp x) :=
          Real.log_lt_log (abs_pos.mpr (fun hh => hne (sub_eq_zero.mp hh))) hltExp
        _ = x := Real.log_exp x
    have hmemb : h t ∈ h '' Icc (g - 1) (g + 1) := Set.mem_image_of_mem h hIcc
    have hbound : h t ≤ M0 := hM0 hmemb
    have hstep1 : h t + c * log |t - g| ≤ M0 + c * log |t - g| := by
      linarith [hbound]
    have hstep2c : c * log |t - g| < c * x := mul_lt_mul_of_pos_left hlog hc
    have hstep2 : M0 + c * log |t - g| < M0 + c * x := by
      linarith [hstep2c]
    have hstep3 : M0 + c * x = M := by
      rw [hx]
      field_simp [hc.ne']
      ring
    exact lt_of_le_of_lt hstep1 (by simpa only [hstep3] using hstep2)

/-  ##  2  -  the  V-flank  (single  cusp;  secant  Lipschitz
    only  -  no  differentiability)  -/
/--  LEFT  flank:  on  (g  -  c/(4L),  g)  the  face
    h  +  c  .  log  |t  -  g|  is  strictly  DECREASING
    (as  t  rises  toward  g).  -/
theorem vFlankLeft (h : ℝ → ℝ) (c g L : ℝ)
    (hL : 0 < L) (hc : 0 < c)
    (hLip : ∀ a b, |a - g| ≤ c / (4 * L) → |b - g| ≤ c / (4 * L) →
      |h a - h b| ≤ L * |a - b|)
    (t1 t2 : ℝ)
    (ht1 : g - c / (4 * L) < t1) (ht1g : t1 < g)
    (ht2 : g - c / (4 * L) < t2) (ht2g : t2 < g)
    (htlt : t1 < t2) :
    h t2 + c * log |t2 - g| < h t1 + c * log |t1 - g| := by
  --  a  =  g  -  t1  and  b  =  g  -  t2:  then  0  <  b  <
  --  a  <  c  /  (4  *  L)  and  u  =  b  /  a  <  1
  set a := g - t1 with ha
  set b := g - t2 with hb
  have ha0 : 0 < a := by rw [ha]; exact sub_pos.mpr ht1g
  have hb0 : 0 < b := by rw [hb]; exact sub_pos.mpr ht2g
  have hab : b < a := by rw [ha, hb]; linarith
  have haD : a < c / (4 * L) := by
    rw [ha]
    linarith [show g - c / (4 * L) < t1 from ht1]
  have hbD : b < c / (4 * L) := by
    rw [hb]
    linarith [show g - c / (4 * L) < t2 from ht2]
  set u := b / a with hu
  have hu0 : 0 < u := div_pos hb0 ha0
  have hu1 : u < 1 := (div_lt_one ha0).mpr hab
  have hlogu : log u < u - 1 := Real.log_lt_sub_one_of_pos hu0 (ne_of_lt hu1)
  have h1mu : 0 < 1 - u := sub_pos.mpr hu1
  --  (1)  the  h  part
  have hinc : h t2 - h t1 ≤ L * (a - b) := by
    have hLip1 : |h t2 - h t1| ≤ L * |t2 - t1| := by
      apply hLip t2 t1
      · rw [show |t2 - g| = g - t2 by
          rw [show t2 - g = -(g - t2) by ring, abs_neg,
              abs_of_pos (sub_pos.mpr ht2g)]]
        linarith [hbD]
      · rw [show |t1 - g| = g - t1 by
          rw [show t1 - g = -(g - t1) by ring, abs_neg,
              abs_of_pos (sub_pos.mpr ht1g)]]
        linarith [haD]
    have habs : |t2 - t1| = a - b := by
      rw [abs_of_pos (sub_pos.mpr htlt)]
      rw [ha, hb]
      ring
    have hLip2 : |h t2 - h t1| ≤ L * (a - b) := by
      rw [← habs]
      exact hLip1
    linarith [hLip2, le_abs_self (h t2 - h t1)]
  --  (2)  the  cusp  part:  equals  c  .  log  u
  have hl1 : log |t2 - g| = log b := by
    rw [show |t2 - g| = b by
      rw [abs_of_neg (show t2 - g < 0 by linarith)]
      rw [hb]
      ring]
  have hl2 : log |t1 - g| = log a := by
    rw [show |t1 - g| = a by
      rw [abs_of_neg (show t1 - g < 0 by linarith)]
      rw [ha]
      ring]
  have hcusp1 : c * log |t2 - g| - c * log |t1 - g| =
      c * (log b - log a) := by
    rw [hl1, hl2, ← mul_sub]
  have hcusp2 : c * (log b - log a) = c * log (b / a) := by
    rw [← Real.log_div hb0.ne' ha0.ne']
  have hcusp : c * log |t2 - g| - c * log |t1 - g| = c * log u := by
    rw [hcusp1, hcusp2, hu]
  --  (3)  L  *  a  <  c  /  4   and   a  -  b  =  a  *  (1  -  u)
  have hLa : L * a < c / 4 := by
    have hLa1 : L * a < L * (c / (4 * L)) :=
      mul_lt_mul_of_pos_left haD hL
    calc L * a < L * (c / (4 * L)) := hLa1
      _ = c / 4 := by field_simp [hL.ne']
  have hAb : a - b = a * (1 - u) := by
    rw [show b = a * u by
      rw [hu]
      field_simp [ha0.ne']]
    ring
  --  (4)  assemble
  have hmid : L * (a - b) + c * log u < 0 := by
    calc L * (a - b) + c * log u
      = L * (a * (1 - u)) + c * log u := by rw [hAb]
      _ = (L * a) * (1 - u) + c * log u := by ring
      _ ≤ (c / 4) * (1 - u) + c * log u := by
        have hmul : (L * a) * (1 - u) < (c / 4) * (1 - u) :=
          mul_lt_mul_of_pos_right hLa h1mu
        linarith [hmul]
      _ < (c / 4) * (1 - u) + c * (u - 1) := by
        linarith [mul_lt_mul_of_pos_left hlogu hc]
      _ = c * (3 * u - 3) / 4 := by ring
      _ < 0 := by
        apply div_neg_of_neg_of_pos
        · nlinarith [hu0, hu1]
        · norm_num
  have hsum : (h t2 + c * log |t2 - g|) - (h t1 + c * log |t1 - g|) ≤
      L * (a - b) + c * log u := by
    linarith [hinc, hcusp]
  linarith [hsum, hmid]

/--  RIGHT  flank:  on  (g,  g  +  c/(4L))  the  face
    h  +  c  .  log  |t  -  g|  is  strictly  INCREASING
    (as  t  moves  away  from  g).  Proven  by  mirroring
    the  left  flank  at  g.  -/
theorem vFlankRight (h : ℝ → ℝ) (c g L : ℝ)
    (hL : 0 < L) (hc : 0 < c)
    (hLip : ∀ a b, |a - g| ≤ c / (4 * L) → |b - g| ≤ c / (4 * L) →
      |h a - h b| ≤ L * |a - b|)
    (t1 t2 : ℝ)
    (ht2 : g < t2) (htlt : t2 < t1) (ht1D : t1 < g + c / (4 * L)) :
    h t2 + c * log |t2 - g| < h t1 + c * log |t1 - g| := by
  --  mirror  at  g:  hm  s  =  h  (2  g  -  s)
  set hm := fun s : ℝ => h (2 * g - s) with hmm
  have hmLip : ∀ a b, |a - g| ≤ c / (4 * L) → |b - g| ≤ c / (4 * L) →
      |hm a - hm b| ≤ L * |a - b| := by
    intro a b ha hb
    dsimp [hm]
    have hma : |(2 * g - a) - g| ≤ c / (4 * L) := by
      rw [show (2 * g - a) - g = g - a by ring]
      rw [show g - a = -(a - g) by ring, abs_neg]
      exact ha
    have hmb : |(2 * g - b) - g| ≤ c / (4 * L) := by
      rw [show (2 * g - b) - g = g - b by ring]
      rw [show g - b = -(b - g) by ring, abs_neg]
      exact hb
    have hcore := hLip (2 * g - a) (2 * g - b) hma hmb
    have hend2 : |b - a| = |a - b| := by
      rw [show b - a = -(a - b) by ring, abs_neg]
    simpa [hend2] using hcore
  have hpa : g - c / (4 * L) < 2 * g - t1 := by nlinarith [ht1D]
  have hpb : 2 * g - t1 < g := by nlinarith [ht2, htlt]
  have hqa : g - c / (4 * L) < 2 * g - t2 := by
    have h : t2 < g + c / (4 * L) := by nlinarith [htlt, ht1D]
    nlinarith
  have hqb : 2 * g - t2 < g := by nlinarith [ht2]
  have hpq : 2 * g - t1 < 2 * g - t2 := by nlinarith [htlt]
  have hvf := vFlankLeft hm c g L hL hc hmLip (2 * g - t1) (2 * g - t2)
    hpa hpb hqa hqb hpq
  have hhm1 : hm (2 * g - t2) = h t2 := by
    dsimp only [hm]
    congr
    ring
  have hhm2 : hm (2 * g - t1) = h t1 := by
    dsimp only [hm]
    congr
    ring
  rw [hhm1, hhm2] at hvf
  have hgl1 : log |(2 * g - t2) - g| = log |t2 - g| := by
    apply congrArg log
    rw [show (2 * g - t2) - g = -(t2 - g) by ring, abs_neg]
  have hgl2 : log |(2 * g - t1) - g| = log |t1 - g| := by
    apply congrArg log
    rw [show (2 * g - t1) - g = -(t1 - g) by ring, abs_neg]
  rw [hgl1, hgl2] at hvf
  exact hvf

/-  ##  3  -  the  cusp-aware  bridge  (the  flagship;  the
    E1  threat  direction;  EVERY  t  including  plunge
    points)  -/
/--  The  row-facing  cusp  bridge:  from  a  ROW  FACE
    |f  u|  <=  B  at  the  sample  height  u,  with  |t  -
    u|  <=  Dv  and  the  row  eps-away  from  every  cusp,
    the  face  at  ANY  other  height  t  is  bounded  above
    by  B  +  L|t  -  u|  +  C  *  n  *  log  (1  +  Dv  /
    eps).  The  bound  is  UNIFORM  in  the  plunge  limit
    (the  face  truly  ->  -oo  at  the  cusps  -  far
    BELOW  the  bound).  -/
theorem cuspUpperBridge {n : ℕ}
    (h : ℝ → ℝ) (c g : Fin n → ℝ)
    (B L Dv C eps u : ℝ) (t : ℝ)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 < Dv)
    (hC : 0 ≤ C) (heps : 0 < eps) (hdv1 : 1 - eps ≤ Dv)
    (hLip : ∀ t u, |h t - h u| ≤ L * |t - u|)
    (hc : ∀ j, 0 ≤ c j) (hC2 : ∀ j, c j ≤ C)
    (hud : |t - u| ≤ Dv)
    (hrow : |cuspFace n h c g u| ≤ B)
    (hsp : ∀ j, eps ≤ |u - g j|) :
    cuspFace n h c g t ≤ B + L * |t - u| + C * (n : ℝ) * log (1 + Dv / eps) := by
  have hlogR : 0 < log (1 + Dv / eps) := by
    apply Real.log_pos
    nlinarith [div_pos hDv heps]
  have hose : 0 < 1 + Dv / eps := by
    nlinarith [div_pos hDv heps]
  --  termwise:  the  j-th  cusp  term  difference
  have hterm (j : Fin n) :
      c j * (log |t - g j| - log |u - g j|) ≤ C * log (1 + Dv / eps) := by
    have hspj : eps ≤ |u - g j| := hsp j
    have hposu : 0 < |u - g j| := lt_of_lt_of_le heps hspj
    by_cases hne : t = g j
    · --  t  AT  the  cusp:  the  term  is  -  c_j  .
      --  log|u  -  g_j|  (convention  log  0  =  0)
      have hzero : log |t - g j| = 0 := by
        rw [hne, sub_self, abs_zero, Real.log_zero]
      have hstep0 : c j * (log |t - g j| - log |u - g j|) =
          -(c j * log |u - g j|) := by
        rw [hzero, zero_sub]
        ring
      by_cases hun : 1 ≤ |u - g j|
      · --  log|u  -  g_j|  >=  0:  the  term  <=  0
        have hlogu : 0 ≤ log |u - g j| := Real.log_nonneg hun
        have hneg : -(c j * log |u - g j|) ≤ 0 := by
          nlinarith [hc j, hlogu]
        have hzero2 : 0 ≤ C * log (1 + Dv / eps) :=
          mul_nonneg hC hlogR.le
        linarith [hstep0, hneg, hzero2]
      · --  eps  <=  |u  -  g_j|  <  1
        have h1 : 1 / |u - g j| ≤ 1 + Dv / eps := by
          have h1a : 1 / |u - g j| ≤ 1 / eps :=
            (one_div_le_one_div hposu heps).mpr hspj
          have h1b : 1 / eps ≤ 1 + Dv / eps := by
            field_simp [heps.ne']
            nlinarith [hdv1]
          linarith [h1a, h1b]
        have hlogu : -log |u - g j| = log (1 / |u - g j|) := by
          rw [one_div, ← Real.log_inv (|u - g j|)]
        have hlogu2 : log (1 / |u - g j|) ≤ log (1 + Dv / eps) := by
          rw [log_le_log_iff (one_div_pos.mpr hposu) (by
              nlinarith [div_pos hDv heps])]
          exact h1
        have hcj : 0 ≤ c j := hc j
        calc c j * (log |t - g j| - log |u - g j|)
          = -(c j * log |u - g j|) := hstep0
          _ = c j * (-log |u - g j|) := by ring
          _ = c j * log (1 / |u - g j|) := congrArg (fun x => c j * x) hlogu
          _ ≤ c j * log (1 + Dv / eps) :=
            mul_le_mul_of_nonneg_left hlogu2 hcj
          _ ≤ C * log (1 + Dv / eps) :=
            mul_le_mul_of_nonneg_right (hC2 j) hlogR.le
    · --  t  off  the  cusp:  a  plain  log-ratio  bound
      have hpost : 0 < |t - g j| := abs_pos.mpr (fun hh => hne (sub_eq_zero.mp hh))
      have hlog : log |t - g j| - log |u - g j| =
          log (|t - g j| / |u - g j|) := by
        rw [← Real.log_div (by positivity) (by positivity)]
      have htu1 : |t - g j| = |(t - u) + (u - g j)| := by
        congr
        ring
      have htu2 : |(t - u) + (u - g j)| ≤ |t - u| + |u - g j| :=
        abs_add_le (t - u) (u - g j)
      have htu3 : |t - u| + |u - g j| ≤ Dv + |u - g j| :=
        add_le_add hud le_rfl
      have htu4 : Dv + |u - g j| = |u - g j| + Dv :=
        add_comm Dv (|u - g j|)
      have htu : |t - g j| ≤ |u - g j| + Dv :=
        (htu1 ▸ htu2).trans (htu3.trans (htu4 ▸ le_rfl))
      have hstep1 : |t - g j| / |u - g j| ≤ (|u - g j| + Dv) / |u - g j| := by
        gcongr
      have hstep2 : (|u - g j| + Dv) / |u - g j| = 1 + Dv / |u - g j| := by
        field_simp [hposu.ne']
      have hstep3 : Dv / |u - g j| ≤ Dv / eps := by
        calc Dv / |u - g j| = Dv * (1 / |u - g j|) := by field_simp
          _ ≤ Dv * (1 / eps) :=
            mul_le_mul_of_nonneg_left
              ((one_div_le_one_div hposu heps).mpr hspj) hDv.le
          _ = Dv / eps := by field_simp
      have hstep4 : 1 + Dv / |u - g j| ≤ 1 + Dv / eps :=
        add_le_add (by norm_num) hstep3
      have hratio : |t - g j| / |u - g j| ≤ 1 + Dv / eps := by
        linarith [hstep1, hstep2, hstep4]
      have hlogr : log |t - g j| - log |u - g j| ≤ log (1 + Dv / eps) := by
        rw [hlog]
        rw [log_le_log_iff (div_pos hpost hposu) (by
            nlinarith [div_pos hDv heps])]
        exact hratio
      have hcj : 0 ≤ c j := hc j
      calc c j * (log |t - g j| - log |u - g j|)
        ≤ c j * log (1 + Dv / eps) :=
          mul_le_mul_of_nonneg_left hlogr hcj
        _ ≤ C * log (1 + Dv / eps) :=
          mul_le_mul_of_nonneg_right (hC2 j) hlogR.le
  have hsum : (Finset.univ.sum fun j => c j * (log |t - g j| - log |u - g j|)) ≤
      (Finset.univ.sum fun j => C * log (1 + Dv / eps)) :=
    Finset.sum_le_sum fun j _ => hterm j
  have hconst : (Finset.univ : Finset (Fin n)).sum
        (fun _ : Fin n => C * log (1 + Dv / eps)) =
      C * (n : ℝ) * log (1 + Dv / eps) := by
    rw [Finset.sum_const (C * log (1 + Dv / eps)), Finset.card_univ]
    simp [nsmul_eq_mul]
    ring
  have hssum : (Finset.univ.sum fun j => c j * log |t - g j|) -
      (Finset.univ.sum fun j => c j * log |u - g j|) =
      (Finset.univ.sum fun j => c j * (log |t - g j| - log |u - g j|)) := by
    rw [← Finset.sum_sub_distrib]
    congr
    funext j
    ring
  have hdecomp : cuspFace n h c g t - cuspFace n h c g u =
      (h t - h u) + (Finset.univ.sum fun j =>
        c j * (log |t - g j| - log |u - g j|)) := by
    rw [cuspFace, cuspFace]
    have hauto : (h t + (Finset.univ.sum fun j => c j * log |t - g j|)) -
        (h u + (Finset.univ.sum fun j => c j * log |u - g j|)) =
        (h t - h u) + ((Finset.univ.sum fun j => c j * log |t - g j|) -
          (Finset.univ.sum fun j => c j * log |u - g j|)) := by
      ring
    rw [hauto, hssum]
  have hf : cuspFace n h c g u ≤ B :=
    (le_abs_self (cuspFace n h c g u)).trans hrow
  have hh : h t - h u ≤ L * |t - u| := by
    linarith [hLip t u, le_abs_self (h t - h u)]
  have hstep1 : cuspFace n h c g t = cuspFace n h c g u + (h t - h u) + (Finset.univ.sum fun j => c j * (log |t - g j| - log |u - g j|)) := by
    have hauto : cuspFace n h c g u + (cuspFace n h c g t - cuspFace n h c g u) =
        cuspFace n h c g t := by ring
    rw [← hauto, hdecomp]
    ring
  have hstep2 : cuspFace n h c g u + (h t - h u) + (Finset.univ.sum fun j => c j * (log |t - g j| - log |u - g j|)) ≤ cuspFace n h c g u + (h t - h u) + (Finset.univ : Finset (Fin n)).sum (fun _ : Fin n => C * log (1 + Dv / eps)) := by
    linarith [hsum]
  have hstep3 : cuspFace n h c g u + (h t - h u) + (Finset.univ : Finset (Fin n)).sum (fun _ : Fin n => C * log (1 + Dv / eps)) = cuspFace n h c g u + (h t - h u) + C * (n : ℝ) * log (1 + Dv / eps) := by
    rw [hconst]
  have hstep4 : cuspFace n h c g u + (h t - h u) + C * (n : ℝ) * log (1 + Dv / eps) ≤ B + L * |t - u| + C * (n : ℝ) * log (1 + Dv / eps) := by
    linarith [hh, hf]
  exact (hstep1 ▸ hstep2).trans (hstep3 ▸ hstep4)

/-  ##  Part  B  -  the  glue  on  (E1C.G_LAST,  E1C.T_MEAS]  -/
/--  WHOLE-DOMAIN  one-sided  face  on  (E1C.G_LAST,  E1C.T_MEAS]
    from  the  ROW  FACE  +  the  cover  +  the  cusp
    spacing  (E1Sample's  e1V3WholeFromSample  with  the
    cusp-aware  bridge;  the  E1  threat  direction).  -/
theorem e1CuspWholeFromRows {n : ℕ}
    (q : ZeroSet) (h : ℝ → ℝ) (c g : Fin n → ℝ)
    (B L Dv C eps : ℝ) (rows : Set ℝ)
    (hB : 0 ≤ B) (hL : 0 ≤ L) (hDv : 0 < Dv)
    (hC : 0 ≤ C) (heps : 0 < eps) (hdv1 : 1 - eps ≤ Dv)
    (hLip : ∀ t u, |h t - h u| ≤ L * |t - u|)
    (hc : ∀ j, 0 ≤ c j) (hC2 : ∀ j, c j ≤ C)
    (hface : ∀ t, E1C.G_LAST < t → t ≤ E1C.T_MEAS → E1C.Mres q t = cuspFace n h c g t)
    (hrowData : ∀ u, u ∈ rows → E1C.G_LAST < u → u ≤ E1C.T_MEAS → |E1C.Mres q u| ≤ B)
    (hcover : ∀ t, E1C.G_LAST < t → t ≤ E1C.T_MEAS →
      ∃ u, u ∈ rows ∧ E1C.G_LAST < u ∧ u ≤ E1C.T_MEAS ∧ |t - u| ≤ Dv)
    (hspData : ∀ u, u ∈ rows → E1C.G_LAST < u → u ≤ E1C.T_MEAS →
      ∀ j, eps ≤ |u - g j|) :
    ∀ t, E1C.G_LAST < t → t ≤ E1C.T_MEAS →
      E1C.Mres q t ≤ B + L * Dv + C * (n : ℝ) * log (1 + Dv / eps) := by
  intro t ht htT
  obtain ⟨u0, huin, huG, huT, hudt⟩ := hcover t ht htT
  have hface_u : |E1C.Mres q u0| ≤ B := hrowData u0 huin huG huT
  have hbridge : cuspFace n h c g t ≤
      B + L * |t - u0| + C * (n : ℝ) * log (1 + Dv / eps) :=
    cuspUpperBridge (h := h) (c := c) (g := g)
      (B := B) (L := L) (Dv := Dv) (C := C) (eps := eps)
      (u := u0) (t := t)
      (hB := hB) (hL := hL) (hDv := hDv) (hC := hC) (heps := heps)
      (hdv1 := hdv1) (hLip := hLip) (hc := hc) (hC2 := hC2)
      (hud := hudt)
      (hrow := by
        simpa only [hface u0 huG huT] using hface_u)
      (hsp := hspData u0 huin huG huT)
  calc E1C.Mres q t
    = cuspFace n h c g t := hface t ht htT
    _ ≤ B + L * |t - u0| + C * (n : ℝ) * log (1 + Dv / eps) := hbridge
    _ ≤ B + L * Dv + C * (n : ℝ) * log (1 + Dv / eps) := by
      have hstep : L * |t - u0| ≤ L * Dv :=
        mul_le_mul_of_nonneg_left hudt hL
      linarith [hstep]

/-  ##  Part  D  -  data  gates  (Float,  E1C-style)

    The  bridge  ADDITIVUM  at  the  measured  constants,
    recorded  for  the  VACUITY  ledger  (the  bridge  is
    FORMAL;  at  the  900G  cover  its  additive  term
    exceeds  the  row  face  -  the  operative
    between-row  control  is  the  data  cusp  face  [s23]
    and  the  P12  squeeze  leg).  No  RH  claim.  -/
/--  cusp  coefficient  (log|zeta|  at  the  super-G
    true  zeros)  -/
def cuspCData : Float := 1.0
/--  zeros  in  the  900G  cover  gap  (worst  row  at
    1000G):  (900G  /  2  .  pi)  .  ln(1000G  /  2  .  pi)
    =  4.2973e12  .  29.194  =  1.2544e14  -/
def cuspNData : Float := 1.2544e14
/--  row  nearest-cusp  distance  (s23  worst  row,  d
    ~  0.013)  -/
def cuspEpsData : Float := 0.013

/--  bridge  additive  term  at  the  measured
    constants:  Lface  .  Dv  +  C  .  N  .  ln(1  +  Dv  /
    eps)  -/
def bridgeAddData : Float :=
    E1C.l2SampleFace * E1C.dvData +
      cuspCData * cuspNData * Float.log (1 + E1C.dvData / cuspEpsData)

/--  the  DATA  cusp  amplitude  at  a  row  (s23
    robust  face):  ln(1  /  d)  -/
def rowCuspAmpData : Float := Float.log (1.0 / cuspEpsData)

#eval cuspCData
#eval cuspNData
#eval cuspEpsData
#eval bridgeAddData
#eval rowCuspAmpData
#eval bridgeAddData > E1C.v3_Bcand
#eval rowCuspAmpData < E1C.v3_Bcand
#eval bridgeAddData / E1C.v3_Bcand

end S1CS
