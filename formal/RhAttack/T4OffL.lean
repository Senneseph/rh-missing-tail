/- T4OffL  -  G-hs3  FLANK  ASYMMETRY  (discovery  0121:  the  correction
   to  the  "no  analytic  face  remains"  wording  of  0119/0120).

  WHAT  THIS  MODULE  IS
  ----------------------
  Discoveries  0116-0119  closed  the  S3  (wire)  content  of  the
  endpoint  at  the  RIGHT  FLANK  off-pair  (sigma  =  1/2  +  d0
  >=  1/2):  the  raw  EM  tail  (DLMF  25.2.8  form,  P4Limit)  at
  the  right  canonical  point  t4o_sOff  =  (1/2  +  d0)  +  i*t0
  is  termwise  below  the  strip  B-wire  p8_B  t0  (n4  t0)  (the
  T4OffD  wall  domination)  and  the  lifted  M-wire  (T4OffM,
  the  CITED  1.6  convexity  mass  through  the  functional
  equation),  with  the  sum  strictly  below  the  endpoint  floor
  (t4m_margin,  ~16  orders).  This  is  all  IN  BODY  and  still
  stands.

  BUT  the  P4  kernel  is  the  RAW  EM  tail  of  zeta  itself
  (W_n  =  zeta  -  P_n  +  n^{1-s}/(1-s),  DLMF  25.2.8):  its
  first  T4  term  is  (1/2)*n^{-sigma},  which  decays  in  n  ONLY
  at  the  rate  sigma  =  Re  s.  At  a  LEFT  FLANK  zero
  (sigma  =  1/2  -  d0  <  1/2)  the  decay  is  slower,  and  this
  module  records  the  FORMAL  BARRIER:

  (1)  BAND  EDGE.  At  d0  =  1/200  (the  lower  edge  of  the
      strip  band,  sigma  =  99/200),  the  first  T4  term  at
      the  tree's  n^4  schedule  (S4Strip.n4  t  =  ceil
      3.1e7*t^4)  EXCEEDS  the  endpoint  floor  floStripMin  t
      (1/200)  for  every  t  >=  10^10  -  in  particular  at
      the  Platt-Trudgian  frontier  tPT2  =  3,000,175,332,800
      (margin  ~13%;  the  crossing  threshold  is  t  >
      (15750/9999)^50  ~=  7.33e9,  below  10^10).
      t4l_barrier_edge.

  (2)  SIGMA  =  0.  At  d0  =  1/2  (re  rho  =  0)  the  first
      T4  term  is  (1/2)*n^0  =  1/2  for  EVERY  schedule  n:
      it  NEVER  falls  below  the  floor  (floStripMin  t  (1/2)
      is  on  the  t^{-2}  scale).  No  schedule  can  close  the
      S3  wire  at  sigma  =  0.  (re  rho  =  0  itself  is
      classically  zero-free  -  CITED  classical  -  but  zeros
      with  re  rho  ->  0+  are  the  limit  of  the  gap.)
      t4l_barrier_sigma0.

  CONSEQUENCE  (G-hs3-left):  the  S3  content  of  a  LEFT  FLANK
  off-pair  above  the  frontier  (a  zero  witness  with  re  rho
  =  1/2  -  d0,  1/200  <=  d0  <=  1/2)  is  NOT  machine-
  supported  by  the  n^4  wire.  To  close  it  per  point  would
  need  a  left-tuned  schedule  (the  decay  n^{-sigma}  must
  beat  t^{-2}  on  the  floor  side):  for  each  fixed
  d0  <  1/2  such  schedules  exist  (with  large  exponent),  but
  NO  schedule  uniform  in  d0  covers  the  band,  and  d0  =
  1/2  is  unreachable  at  every  schedule.  The  machined
  endpoint  face  (rh_program78_stripfront_mach,  RHEnd  part  B7)
  is  therefore  machine-verified  at  the  RIGHT  FLANK  witness
  of  an  off-pair;  its  satisfaction  at  a  LEFT  FLANK  witness
  (re  rho  =  1/2  -  d0  <  1/2)  is  the  remaining  face,
  G-hs3-left  -  analytic  content  in  the  original  sense,  not
  a  data  or  citation  item.

  HONESTY:  the  barriers  are  FORMAL  NEGATIVE  RESULTS  about
  the  machine  wire  (what  the  n^4  schedule  cannot  do),
  stated  with  exact  rational  pins.  They  make  NO  claim
  about  zeta:  nothing  here  says  any  zero  exists;  RH
  remains  unclaimed.  The  module  CORRECTS  the  0119/0120
  records  (which  had  summarized  the  G-hs3  closure  as  all-
  flanks):  0116-0119  cover  sigma  >=  1/2;  sigma  <  1/2  is
  this  module.  No  RH  claim.  -/

import Mathlib
import RhAttack.P4Limit
import RhAttack.S4Strip
import RhAttack.S1LowT
import RhAttack.S4Own
import RhAttack.FloorUnif
import RhAttack.WinCount
import RhAttack.T4OffD

set_option linter.style.docString false
set_option linter.style.longLine false

/-  =================================================================
   S1  The  left  canonical  point
   =================================================================
   The  mirror  of  T4OffD.t4o_sOff:  re  =  1/2  -  d0  (the
   left  flank).  Recorded  for  the  statement  shape.  -/

/--  The  left  canonical  off-line  point:  re  =  1/2  -  d0.  -/
noncomputable def t4l_sOffL (t0 d0 : ℝ) : ℂ :=
    ((1 / 2 - d0 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I

theorem t4l_sOffL_shape (t0 d0 : ℝ) :
    t4l_sOffL t0 d0 = ((1 / 2 - d0 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := rfl

/-  =================================================================
   S2  Helpers:  the  exp  pin  and  the  floor  pins
   =================================================================
   No  numerically  evaluated  exp  (the  pinned  toolchain
   norm_num  cannot  do  it  -  see  the  E1Clause.mdefect_bounded
   proof  note):  exp  u  is  bounded  by  1/(1-u)  for  0  <=  u
   <  1  via  the  classical  log  inequality  log  x  <=  x  -  1
   (Real.log_le_sub_one_of_pos)  and  the  log/exp  bridge
   (Real.le_log_iff_exp_le).  Both  theorems  are  pure  analysis.  -/

/--  exp-GEOMETRIC  MAJORANT  (log  route,  pure  analysis):
    for  0  <=  u  <  1,  exp  u  <=  1/(1  -  u).
    Route:  exp  u  <=  1/(1-u)  <->  u  <=  log  (1/(1-u))
    =  -log  (1-u)  >=  -((1-u)  -  1)  =  u  (the  last  step  is
    Real.log_le_sub_one_of_pos  at  x  =  1-u).  -/
theorem t4l_expU (u : ℝ) (h0 : 0 ≤ u) (hu : u < 1) :
    Real.exp u ≤ 1 / (1 - u) := by
  have hpos1mu : 0 < 1 - u := by linarith [hu]
  have hlog : Real.log (1 - u) ≤ -u := by
    have hraw : Real.log (1 - u) ≤ (1 - u) - 1 :=
      Real.log_le_sub_one_of_pos hpos1mu
    linarith
  have huk : u ≤ Real.log (1 / (1 - u)) := by
    have hinv : Real.log (1 / (1 - u)) = -Real.log (1 - u) := by
      have hdiv : 1 / (1 - u) = (1 - u)⁻¹ := by
        have hne : (1 - u : ℝ) ≠ 0 := ne_of_gt hpos1mu
        field_simp [hne]
      rw [hdiv, Real.log_inv]
    rw [hinv]
    linarith [hlog]
  have hposy : 0 < 1 / (1 - u) := by
    apply div_pos <;> (try norm_num) <;> linarith [hpos1mu]
  exact (Real.le_log_iff_exp_le hposy).mp huk

/--  FLOOR  PIN,  BAND  EDGE:  for  t  >=  1000,
    floStripMin  t  (1/200)  <=  (1/9999)  *  t^{-2}.
    Route:  floStripMin  =  mown  (FUnif,  on  the  band)  <=
    (4*d^2/t^2)*(1  +  1/(16*t^2))*exp(1/t^2)  (S4Own.hMownScaleHi)
    with  d  =  1/200:  4*d^2  =  1/10000,  1/(16*t^2)  <=
    1/(16*10^6),  exp(1/t^2)  <=  exp(10^{-6})  <=  1/(1-10^{-6})
    (t4l_expU);  the  product  pin  is  exact  rational.  -/
theorem t4l_floorPinEdge (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    S1LowT.floStripMin t0 (1 / 200) ≤ (1 / 9999 : ℝ) * t0 ^ (-2 : ℝ) := by
  set d := (1 / 200 : ℝ) with hd
  have hdeq : S1LowT.floStripMin t0 d = S4O.mown t0 d :=
    FUnif.floStripMin_eq_mownOnBand t0 d ht0 (by norm_num [d])
      (by norm_num [d])
  simp only [hdeq]
  have hmown : S4O.mown t0 d ≤ (4 * d ^ 2 / t0 ^ 2) *
      (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) :=
    S4O.hMownScaleHi t0 d (by linarith [ht0]) (by norm_num [d])
      (by norm_num [d])
  have htpos : 0 < t0 := by linarith [ht0]
  have hrpow2 : (t0 : ℝ) ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
    rw [Real.rpow_neg (by positivity) 2,
      show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num]
    ring
  have hrew : (4 * d ^ 2 / t0 ^ 2) * (1 + 1 / (16 * t0 ^ 2)) *
      Real.exp (1 / t0 ^ 2) =
      (4 * d ^ 2) * (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) *
      t0 ^ (-2 : ℝ) := by
    rw [hrpow2]
    field_simp [show t0 ^ 2 ≠ 0 by positivity,
      show (16 * t0 ^ 2 : ℝ) ≠ 0 by positivity]
  have hfac1 : 1 + 1 / (16 * t0 ^ 2) ≤ 1 + 1 / (16 * 10 ^ 6) := by
    have hinv : 1 / (16 * t0 ^ 2) ≤ 1 / (16 * 10 ^ 6) := by
      rw [one_div_le_one_div (by positivity) (by positivity)]
      have h1000 : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
        gcongr
      nlinarith [h1000]
    linarith
  have harg : 1 / t0 ^ 2 ≤ 10 ^ (-6 : ℝ) := by
    have h1000 : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
      gcongr
    have heq : (1 / (1000 : ℝ) ^ 2 : ℝ) = 10 ^ (-6 : ℝ) := by
      norm_num
    have hinv2 : 1 / t0 ^ 2 ≤ 1 / (1000 : ℝ) ^ 2 := by
      rw [one_div_le_one_div (by positivity) (by positivity)]
      nlinarith [h1000]
    rw [← heq]
    exact hinv2
  have huk : Real.exp (1 / t0 ^ 2) ≤ Real.exp (10 ^ (-6 : ℝ)) :=
    (Real.exp_le_exp).mpr harg
  have hexpu : Real.exp (10 ^ (-6 : ℝ)) ≤
      1 / (1 - 10 ^ (-6 : ℝ)) :=
    t4l_expU (10 ^ (-6 : ℝ)) (by positivity) (by
      norm_num [Real.rpow_neg, Real.rpow_natCast])
  have hnum : (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      (1 / (1 - 10 ^ (-6 : ℝ))) ≤ (1 / 9999 : ℝ) := by
    norm_num [d]
  have htneg : 0 ≤ t0 ^ (-2 : ℝ) :=
    Real.rpow_nonneg (le_of_lt htpos) (-2)
  calc S4O.mown t0 d ≤ (4 * d ^ 2 / t0 ^ 2) *
      (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) := hmown
    _ = (4 * d ^ 2) * (1 + 1 / (16 * t0 ^ 2)) *
      Real.exp (1 / t0 ^ 2) * t0 ^ (-2 : ℝ) := hrew
    _ ≤ (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      Real.exp (10 ^ (-6 : ℝ)) * t0 ^ (-2 : ℝ) := by
      gcongr
    _ ≤ (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      (1 / (1 - 10 ^ (-6 : ℝ))) * t0 ^ (-2 : ℝ) := by
      gcongr
    _ ≤ (1 / 9999 : ℝ) * t0 ^ (-2 : ℝ) := by
      gcongr

/--  FLOOR  PIN,  D0  =  1/2  (SIGMA  =  0):  for  t  >=  1000,
    floStripMin  t  (1/2)  <=  2  *  t^{-2}.  -/
theorem t4l_floorPinHalf (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    S1LowT.floStripMin t0 (1 / 2) ≤ (2 : ℝ) * t0 ^ (-2 : ℝ) := by
  set d := (1 / 2 : ℝ) with hd
  have hdeq : S1LowT.floStripMin t0 d = S4O.mown t0 d :=
    FUnif.floStripMin_eq_mownOnBand t0 d ht0 (by norm_num [d])
      (by norm_num [d])
  simp only [hdeq]
  have hmown : S4O.mown t0 d ≤ (4 * d ^ 2 / t0 ^ 2) *
      (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) :=
    S4O.hMownScaleHi t0 d (by linarith [ht0]) (by norm_num [d])
      (by norm_num [d])
  have htpos : 0 < t0 := by linarith [ht0]
  have hrpow2 : (t0 : ℝ) ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
    rw [Real.rpow_neg (by positivity) 2,
      show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num]
    ring
  have hrew : (4 * d ^ 2 / t0 ^ 2) * (1 + 1 / (16 * t0 ^ 2)) *
      Real.exp (1 / t0 ^ 2) =
      (4 * d ^ 2) * (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) *
      t0 ^ (-2 : ℝ) := by
    rw [hrpow2]
    field_simp [show t0 ^ 2 ≠ 0 by positivity,
      show (16 * t0 ^ 2 : ℝ) ≠ 0 by positivity]
  have hfac1 : 1 + 1 / (16 * t0 ^ 2) ≤ 1 + 1 / (16 * 10 ^ 6) := by
    have hinv : 1 / (16 * t0 ^ 2) ≤ 1 / (16 * 10 ^ 6) := by
      rw [one_div_le_one_div (by positivity) (by positivity)]
      have h1000 : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
        gcongr
      nlinarith [h1000]
    linarith
  have harg : 1 / t0 ^ 2 ≤ 10 ^ (-6 : ℝ) := by
    have h1000 : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
      gcongr
    have heq : (1 / (1000 : ℝ) ^ 2 : ℝ) = 10 ^ (-6 : ℝ) := by
      norm_num
    have hinv2 : 1 / t0 ^ 2 ≤ 1 / (1000 : ℝ) ^ 2 := by
      rw [one_div_le_one_div (by positivity) (by positivity)]
      nlinarith [h1000]
    rw [← heq]
    exact hinv2
  have huk : Real.exp (1 / t0 ^ 2) ≤ Real.exp (10 ^ (-6 : ℝ)) :=
    (Real.exp_le_exp).mpr harg
  have hexpu : Real.exp (10 ^ (-6 : ℝ)) ≤
      1 / (1 - 10 ^ (-6 : ℝ)) :=
    t4l_expU (10 ^ (-6 : ℝ)) (by positivity) (by
      norm_num [Real.rpow_neg, Real.rpow_natCast])
  have hnum : (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      (1 / (1 - 10 ^ (-6 : ℝ))) ≤ (2 : ℝ) := by
    norm_num [d]
  have htneg : 0 ≤ t0 ^ (-2 : ℝ) :=
    Real.rpow_nonneg (le_of_lt htpos) (-2)
  calc S4O.mown t0 d ≤ (4 * d ^ 2 / t0 ^ 2) *
      (1 + 1 / (16 * t0 ^ 2)) * Real.exp (1 / t0 ^ 2) := hmown
    _ = (4 * d ^ 2) * (1 + 1 / (16 * t0 ^ 2)) *
      Real.exp (1 / t0 ^ 2) * t0 ^ (-2 : ℝ) := hrew
    _ ≤ (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      Real.exp (10 ^ (-6 : ℝ)) * t0 ^ (-2 : ℝ) := by
      gcongr
    _ ≤ (4 * d ^ 2) * (1 + 1 / (16 * 10 ^ 6)) *
      (1 / (1 - 10 ^ (-6 : ℝ))) * t0 ^ (-2 : ℝ) := by
      gcongr
    _ ≤ (2 : ℝ) * t0 ^ (-2 : ℝ) := by
      gcongr
/-  =================================================================
   S3  The  raw  T4  wall  at  the  left  point:  n4  upper  bound
   and  the  term1  lower  bound
   =================================================================
   The  EM  tail  (DLMF  25.2.8,  P4Limit):  W_n  ~  the  T4
   series  in  n^{-s-j/2};  the  first  T4  term  is  (1/2)*n^{-sigma}.
   At  the  band  edge  sigma  =  99/200  and  schedule
   n  =  n4  t  =  ceil  3.1e7*t^4.  -/

/-  N4  UPPER  BOUND:  for  t  >=  1000,
    (n4  t  :  ℝ)  <=  2  *  31000000  *  t^4.
    Route:  n4  t  =  ⌈x⌉₊  with  x  =  3.1e7*t^4  >  1:
    ⌈x⌉₊  <  x  +  1  <=  2*x  (Nat  route,  no  numerics).  -/
theorem t4l_n4upper (t : ℝ) (ht : 1000 ≤ t) :
    (S4Strip.n4 t : ℝ) ≤ 2 * (31000000 : ℝ) * t ^ 4 := by
  set x := (31000000 : ℝ) * t ^ 4 with hx
  have hx1 : 1 < x := by
    have htpos : 0 < t := by linarith [ht]
    have ht4 : t ^ 4 ≥ 1000 ^ 4 := by
      gcongr
    have hb : (31000000 : ℝ) * 1000 ^ 4 > 1 := by norm_num
    nlinarith [ht4, hb]
  have hceilub : (⌈x⌉₊ : ℝ) ≤ x + 1 := by
    exact le_of_lt (Nat.ceil_lt_add_one (by linarith [hx1]))
  have h2x : x + 1 ≤ 2 * x := by
    have h1x : 1 ≤ x := by linarith [hx1]
    nlinarith [h1x]
  have hn4 : (S4Strip.n4 t : ℝ) = (⌈x⌉₊ : ℝ) := by
    dsimp only [S4Strip.n4, x]
  calc (S4Strip.n4 t : ℝ) = (⌈x⌉₊ : ℝ) := hn4
    _ ≤ x + 1 := hceilub
    _ ≤ 2 * x := h2x
    _ = 2 * (31000000 : ℝ) * t ^ 4 := by
      rw [hx]
      ring

theorem t4l_term1lb (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) ≥
      (1 / 15750 : ℝ) * t0 ^ (-(99 / 50 : ℝ)) := by
  have htpos : 0 < t0 := by linarith [ht0]
  have hnub : (S4Strip.n4 t0 : ℝ) ≤ 2 * (31000000 : ℝ) * t0 ^ 4 :=
    t4l_n4upper t0 ht0
  have hn4pos : 0 < (S4Strip.n4 t0 : ℝ) :=
    Nat.cast_pos.mpr (t4o_n4pos t0 ht0)
  set a := (62000000 : ℝ) with ha
  set b := t0 ^ 4 with hb
  have hab : 2 * (31000000 : ℝ) * t0 ^ 4 = a * b := by
    rw [ha, hb]
    ring
  have haA : 0 < a := by
    rw [ha]
    norm_num
  have hbB : 0 < b := by
    rw [hb]
    positivity
  have hA : (a * b) ^ (-(99 / 200 : ℝ)) ≤ (S4Strip.n4 t0 : ℝ) ^
      (-(99 / 200 : ℝ)) := by
    have hp0 : 0 ≤ (99 / 200 : ℝ) := by norm_num
    have hmono : (S4Strip.n4 t0 : ℝ) ^ (99 / 200 : ℝ) ≤
        (2 * (31000000 : ℝ) * t0 ^ 4) ^ (99 / 200 : ℝ) :=
      Real.rpow_le_rpow (le_of_lt hn4pos) hnub hp0
    have hmonoA : (S4Strip.n4 t0 : ℝ) ^ (99 / 200 : ℝ) ≤
        (a * b) ^ (99 / 200 : ℝ) := by
      rw [← hab]
      exact hmono
    have hinvA : (a * b) ^ (-(99 / 200 : ℝ)) =
        ((a * b) ^ (99 / 200 : ℝ))⁻¹ := by
      rw [Real.rpow_neg (le_of_lt (mul_pos haA hbB)) (99 / 200)]
    have hinvB : (S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ)) =
        (((S4Strip.n4 t0 : ℝ) ^ (99 / 200 : ℝ)))⁻¹ := by
      rw [Real.rpow_neg (le_of_lt hn4pos) (99 / 200)]
    rw [hinvA, hinvB]
    simpa [one_div] using one_div_le_one_div_of_le
      (Real.rpow_pos_of_pos hn4pos (99 / 200 : ℝ)) hmonoA
  have hC : (a * b) ^ (-(99 / 200 : ℝ)) =
      a ^ (-(99 / 200 : ℝ)) * b ^ (-(99 / 200 : ℝ)) := by
    have hmul : (a * b) ^ (-(99 / 200 : ℝ)) =
        a ^ (-(99 / 200 : ℝ)) * b ^ (-(99 / 200 : ℝ)) :=
      Real.mul_rpow (le_of_lt haA) (le_of_lt hbB)
    exact hmul
  have hD : b ^ (-(99 / 200 : ℝ)) = (t0 : ℝ) ^ (-(99 / 50 : ℝ)) := by
    rw [hb]
    rw [show (t0 : ℝ) ^ 4 = (t0 : ℝ) ^ (4 : ℝ) by norm_num]
    rw [show ((t0 : ℝ) ^ (4 : ℝ)) ^ (-(99 / 200 : ℝ)) =
      (t0 : ℝ) ^ (4 * (-(99 / 200 : ℝ))) from
      (Real.rpow_mul (by positivity) (4 : ℝ) (-(99 / 200 : ℝ))).symm]
    rw [show 4 * (-(99 / 200 : ℝ)) = -(99 / 50 : ℝ) by norm_num]
  have haste : a ^ (-(1 / 2 : ℝ)) ≤ a ^ (-(99 / 200 : ℝ)) := by
    have hn99 : -(1 / 2 : ℝ) ≤ -(99 / 200 : ℝ) := by norm_num
    have ha1 : 1 ≤ a := by
      rw [ha]
      norm_num
    exact Real.rpow_le_rpow_of_exponent_le ha1 hn99
  have hsqrt : a ^ (-(1 / 2 : ℝ)) = 1 / (a ^ (1 / 2 : ℝ)) := by
    have hr : a ^ (-(1 / 2 : ℝ)) = (a ^ (1 / 2 : ℝ))⁻¹ := by
      rw [Real.rpow_neg (by rw [ha]; norm_num) (1 / 2 : ℝ)]
    rw [hr, (one_div (a ^ (1 / 2 : ℝ))).symm]
  have hsqrt2 : a ^ (1 / 2 : ℝ) = Real.sqrt a := by
    have hapr : 0 ≤ a := by positivity
    simpa [Real.rpow_two] using (Real.sqrt_eq_rpow a).symm
  have hs7875 : Real.sqrt (62000000 : ℝ) < 7875 := by
    have hsq : (62000000 : ℝ) < 7875 ^ 2 := by norm_num
    have hpos : 0 ≤ (62000000 : ℝ) := by norm_num
    have hsq7 : Real.sqrt (7875 ^ 2) = (7875 : ℝ) := by
      rw [Real.sqrt_sq (by norm_num : (0 : ℝ) ≤ 7875)]
    calc (Real.sqrt (62000000 : ℝ) : ℝ) < Real.sqrt ((7875 : ℝ) ^ 2) :=
        Real.sqrt_lt_sqrt hpos hsq
      _ = 7875 := hsq7
  have hinv7875 : a ^ (-(1 / 2 : ℝ)) > 1 / 7875 := by
    rw [hsqrt, hsqrt2, ha]
    have hlt : 1 / 7875 < 1 / Real.sqrt (62000000 : ℝ) := by
      apply (one_div_lt_one_div (by norm_num : (0 : ℝ) < 7875)
        (by positivity)).mpr
      exact hs7875
    linarith [hlt]
  have ht0e : 0 ≤ (t0 : ℝ) ^ (-(99 / 50 : ℝ)) :=
    Real.rpow_nonneg (le_of_lt htpos) (-(99 / 50 : ℝ))
  have hconst : (1 / 2 : ℝ) * a ^ (-(1 / 2 : ℝ)) ≥ 1 / 15750 := by
    have hgt : a ^ (-(1 / 2 : ℝ)) > 1 / 7875 := hinv7875
    have heq : (1 / 2 : ℝ) * (1 / 7875 : ℝ) = (1 / 15750 : ℝ) := by
      norm_num
    have hlt : (1 / 2 : ℝ) * a ^ (-(1 / 2 : ℝ)) >
        (1 / 2 : ℝ) * (1 / 7875 : ℝ) := by
      gcongr
    have hge : (1 / 2 : ℝ) * a ^ (-(1 / 2 : ℝ)) > (1 / 15750 : ℝ) := by
      linarith [hlt, heq]
    exact le_of_lt hge
  have hstep1 : (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^
      (-(99 / 200 : ℝ))) ≥ (1 / 2 : ℝ) * ((a * b) ^
      (-(99 / 200 : ℝ))) := by
    have hpos2 : (0 : ℝ) ≤ 1 / 2 := by norm_num
    exact mul_le_mul_of_nonneg_left hA hpos2
  have hstep2 : (1 / 2 : ℝ) * ((a * b) ^ (-(99 / 200 : ℝ))) =
      (1 / 2 : ℝ) * (a ^ (-(99 / 200 : ℝ)) * b ^ (-(99 / 200 : ℝ))) := by
    rw [hC]
  have hstep3 : (1 / 2 : ℝ) * (a ^ (-(99 / 200 : ℝ)) * b ^
      (-(99 / 200 : ℝ))) ≥ (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) * b ^
      (-(99 / 200 : ℝ))) := by
    have hpos2 : (0 : ℝ) ≤ 1 / 2 := by norm_num
    have hposb : 0 ≤ b ^ (-(99 / 200 : ℝ)) :=
      Real.rpow_nonneg (le_of_lt hbB) (-(99 / 200 : ℝ))
    have hcore : a ^ (-(99 / 200 : ℝ)) ≥ a ^ (-(1 / 2 : ℝ)) :=
      haste
    have hmm : a ^ (-(99 / 200 : ℝ)) * b ^ (-(99 / 200 : ℝ)) ≥
        a ^ (-(1 / 2 : ℝ)) * b ^ (-(99 / 200 : ℝ)) :=
      mul_le_mul_of_nonneg_right hcore hposb
    exact mul_le_mul_of_nonneg_left hmm hpos2
  have hstep4 : (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) * b ^
      (-(99 / 200 : ℝ))) = (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) *
      (t0 : ℝ) ^ (-(99 / 50 : ℝ))) := by
    rw [hD]
  have hstep5 : (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) *
      (t0 : ℝ) ^ (-(99 / 50 : ℝ))) = ((1 / 2 : ℝ) * a ^
      (-(1 / 2 : ℝ))) * (t0 : ℝ) ^ (-(99 / 50 : ℝ)) := by ring
  have hstep6 : ((1 / 2 : ℝ) * a ^ (-(1 / 2 : ℝ))) *
      (t0 : ℝ) ^ (-(99 / 50 : ℝ)) ≥ (1 / 15750 : ℝ) *
      (t0 : ℝ) ^ (-(99 / 50 : ℝ)) := by
    exact mul_le_mul_of_nonneg_right hconst ht0e
  calc (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) ≥
      (1 / 2 : ℝ) * ((a * b) ^ (-(99 / 200 : ℝ))) := hstep1
    _ = (1 / 2 : ℝ) * (a ^ (-(99 / 200 : ℝ)) * b ^ (-(99 / 200 : ℝ))) :=
      hstep2
    _ ≥ (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) * b ^ (-(99 / 200 : ℝ))) :=
      hstep3
    _ = (1 / 2 : ℝ) * (a ^ (-(1 / 2 : ℝ)) *
      (t0 : ℝ) ^ (-(99 / 50 : ℝ))) := hstep4
    _ = ((1 / 2 : ℝ) * a ^ (-(1 / 2 : ℝ))) * (t0 : ℝ) ^
      (-(99 / 50 : ℝ)) := hstep5
    _ ≥ (1 / 15750 : ℝ) * (t0 : ℝ) ^ (-(99 / 50 : ℝ)) := hstep6

/-  =================================================================
   S4  The  BARRIERS
   =================================================================
   The  two  FORMAL  NEGATIVE  RESULTS  about  the  machine  wire.
   (1)  BAND  EDGE  (d0  =  1/200,  sigma  =  99/200):  the  first
       T4  term  at  the  n^4  schedule  strictly  EXCEEDS  the
       endpoint  floor  for  every  t  >=  10^10  -  in
       particular  at  the  Platt-Trudgian  frontier.
   (2)  SIGMA  =  0  (d0  = 1/2):  the  first  T4  term  is
       identically  1/2  at  EVERY  schedule;  it  never  falls
       below  the  floor.  -/

/--  BARRIER  1  (band  edge,  n^4  schedule):  for  t  >=  10^10,
    (1/2)  *  (n4  t)^{-99/200}  >  floStripMin  t  (1/200).
    The  S3  wall  at  the  left  point  (which  is  >=  this  T4
    term  plus  the  nonnegative  mass,  cf.  the  T4  term
    decomposition  used  in  T4OffD  /  T4OffM)  can  therefore
    NOT  be  below  the  endpoint  floor  -  the  squeeze  cycle
    fails  at  the  left  flank  band  edge.  Crossing  threshold:
    t  >  (15750/9999)^50  ~=  7.33e9  (below  10^10  and  far
    below  tPT2).  Exact  pins  only.  -/
theorem t4l_barrier_edge (t0 : ℝ) (ht0 : (10000000000 : ℝ) ≤ t0) :
    (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) >
      S1LowT.floStripMin t0 (1 / 200) := by
  have htpos : 0 < t0 := by linarith [ht0]
  have hterm : (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) ≥
      (1 / 15750 : ℝ) * t0 ^ (-(99 / 50 : ℝ)) :=
    t4l_term1lb t0 (by linarith [ht0])
  have hfloor : S1LowT.floStripMin t0 (1 / 200) ≤
      (1 / 9999 : ℝ) * t0 ^ (-2 : ℝ) :=
    t4l_floorPinEdge t0 (by linarith [ht0])
  have hthres : (t0 : ℝ) ^ (1 / 50 : ℝ) > (15750 / 9999 : ℝ) := by
    have hmono : (10000000000 : ℝ) ^ (1 / 50 : ℝ) ≤ t0 ^ (1 / 50 : ℝ) :=
      Real.rpow_le_rpow (by positivity) (by linarith [ht0]) (by
        norm_num)
    have heq10 : (10000000000 : ℝ) ^ (1 / 50 : ℝ) = (10 : ℝ) ^
        (1 / 5 : ℝ) := by
      rw [show (10000000000 : ℝ) = (10 : ℝ) ^ (10 : ℝ) by norm_num,
        ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 10) (10 : ℝ)
          (1 / 50 : ℝ)]
      norm_num
    have hpin : (10 : ℝ) ^ (1 / 5 : ℝ) > (15750 / 9999 : ℝ) := by
      by_contra hnc
      push_neg at hnc
      have hge5 : ((10 : ℝ) ^ (1 / 5 : ℝ)) ^ (5 : ℝ) ≤
          ((15750 / 9999 : ℝ)) ^ 5 := by
        have hnatpow : ((15750 / 9999 : ℝ)) ^ 5 =
            ((15750 / 9999 : ℝ)) ^ (5 : ℝ) := by norm_num
        rw [hnatpow]
        exact Real.rpow_le_rpow (by positivity) hnc (by norm_num)
      have hlhs : ((10 : ℝ) ^ (1 / 5 : ℝ)) ^ (5 : ℝ) = (10 : ℝ) := by
        rw [← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 10) (1 / 5 : ℝ)
          (5 : ℝ)]
        norm_num
      have hrhs : ((15750 / 9999 : ℝ)) ^ 5 < 10 := by
        have hpin5 : (15750 : ℝ) ^ 5 < (10 : ℝ) * (9999 : ℝ) ^ 5 := by
          norm_num
        norm_num [div_pow]
      linarith
    calc (t0 : ℝ) ^ (1 / 50 : ℝ) ≥ (10000000000 : ℝ) ^ (1 / 50 : ℝ) :=
        hmono
      _ = (10 : ℝ) ^ (1 / 5 : ℝ) := heq10
      _ > (15750 / 9999 : ℝ) := hpin
  have hmid : (1 / 15750 : ℝ) * t0 ^ (-(99 / 50 : ℝ)) >
      (1 / 9999 : ℝ) * t0 ^ (-2 : ℝ) := by
    have hexp : (t0 : ℝ) ^ (-(99 / 50 : ℝ)) = (t0 : ℝ) ^ (1 / 50 : ℝ) *
        (t0 : ℝ) ^ (-2 : ℝ) := by
      have hadd : (1 / 50 : ℝ) + (-2 : ℝ) = (-(99 / 50 : ℝ)) :=
        by norm_num
      have hsplit : (t0 : ℝ) ^ (-(99 / 50 : ℝ)) =
          (t0 : ℝ) ^ ((1 / 50 : ℝ) + (-2 : ℝ)) := by rw [hadd]
      rw [hsplit, Real.rpow_add (by positivity)]
    rw [hexp]
    have hdiv : (1 / 9999 : ℝ) < (t0 : ℝ) ^ (1 / 50 : ℝ) *
        (1 / 15750 : ℝ) := by
      have hpin : (1 / 9999 : ℝ) = (15750 / 9999 : ℝ) *
          (1 / 15750 : ℝ) := by norm_num
      rw [hpin]
      exact mul_lt_mul_of_pos_right hthres
        (by norm_num : (0 : ℝ) < 1 / 15750)
    have htt : 0 < (t0 : ℝ) ^ (-2 : ℝ) :=
      Real.rpow_pos_of_pos htpos (-2)
    have hgoal : (t0 : ℝ) ^ (1 / 50 : ℝ) * (1 / 15750 : ℝ) *
        (t0 : ℝ) ^ (-2 : ℝ) > (1 / 9999 : ℝ) * (t0 : ℝ) ^ (-2 : ℝ) :=
      mul_lt_mul_of_pos_right hdiv htt
    have hform : (1 / 15750 : ℝ) * ((t0 : ℝ) ^ (1 / 50 : ℝ) *
        (t0 : ℝ) ^ (-2 : ℝ)) = (t0 : ℝ) ^ (1 / 50 : ℝ) *
        (1 / 15750 : ℝ) * (t0 : ℝ) ^ (-2 : ℝ) := by ring
    rw [hform]
    exact hgoal
  calc (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) ≥
      (1 / 15750 : ℝ) * t0 ^ (-(99 / 50 : ℝ)) := hterm
    _ > (1 / 9999 : ℝ) * t0 ^ (-2 : ℝ) := hmid
    _ ≥ S1LowT.floStripMin t0 (1 / 200) := hfloor

/--  BARRIER  2  (d0  = 1/2,  sigma  = 0,  ANY  schedule  n):
    (1/2)  *  n^0  =  1/2  is  STRICTLY  ABOVE  floStripMin  t
    (1/2)  for  every  t  >=  1000  and  every  schedule  n  >  0.
    No  scheduling  of  n  can  close  the  S3  wire  at
    sigma  =  0.  -/
theorem t4l_barrier_sigma0 (t0 : ℝ) (ht0 : 1000 ≤ t0) (n : ℕ)
    (hn : 0 < n) :
    (1 / 2 : ℝ) * ((n : ℝ) ^ (0 : ℝ)) > S1LowT.floStripMin t0 (1 / 2) := by
  have hfloor : S1LowT.floStripMin t0 (1 / 2) ≤
      (2 : ℝ) * t0 ^ (-2 : ℝ) :=
    t4l_floorPinHalf t0 ht0
  have htpos : 0 < t0 := by linarith [ht0]
  have hinv : t0 ^ (-2 : ℝ) ≤ (1000 : ℝ) ^ (-2 : ℝ) := by
    have ht2 : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
      gcongr
    have hr1 : t0 ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
      rw [Real.rpow_neg (by positivity) 2,
        show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num, one_div]
    have hr2 : (1000 : ℝ) ^ (-2 : ℝ) = 1 / (1000 : ℝ) ^ 2 := by
      rw [Real.rpow_neg (by norm_num : 0 ≤ (1000 : ℝ)) 2,
        show (1000 : ℝ) ^ (2 : ℝ) = (1000 : ℝ) ^ 2 by norm_num,
        one_div]
    rw [hr1, hr2]
    rw [one_div_le_one_div (by positivity) (by positivity)]
    nlinarith [ht2]
  have hmid : (2 : ℝ) * t0 ^ (-2 : ℝ) < (1 / 2 : ℝ) := by
    have h1 : (2 : ℝ) * t0 ^ (-2 : ℝ) ≤
        (2 : ℝ) * (1000 : ℝ) ^ (-2 : ℝ) :=
      mul_le_mul_of_nonneg_left hinv (by positivity)
    have h2 : (2 : ℝ) * (1000 : ℝ) ^ (-2 : ℝ) <
        (1 / 2 : ℝ) := by
      have hr : (1000 : ℝ) ^ (-2 : ℝ) = 1 / (1000 : ℝ) ^ 2 := by
        rw [Real.rpow_neg (by norm_num : 0 ≤ (1000 : ℝ)) 2,
          show (1000 : ℝ) ^ (2 : ℝ) = (1000 : ℝ) ^ 2 by norm_num,
          one_div]
      rw [hr]
      norm_num
    exact lt_of_le_of_lt h1 h2
  have heq0 : (1 / 2 : ℝ) * ((n : ℝ) ^ (0 : ℝ)) = (1 / 2 : ℝ) := by
    rw [Real.rpow_zero (n : ℝ), mul_one]
  calc (1 / 2 : ℝ) * ((n : ℝ) ^ (0 : ℝ)) = (1 / 2 : ℝ) := heq0
    _ > (2 : ℝ) * t0 ^ (-2 : ℝ) := hmid
    _ ≥ S1LowT.floStripMin t0 (1 / 2) := hfloor

/-  =================================================================
   S5  SQUEEZE  IMPOSSIBILITY  (interpretation)
   =================================================================  -/

/--  The  S3  side  of  the  squeeze  cycle  (wall  +  mass  <
    floor)  CANNOT  hold  at  the  left  point  band  edge  with
    the  n^4  wire:  the  first  T4  term  of  the  wall  already
    exceeds  the  floor  (the  rest  of  the  wall  and  the  mass
    are  nonnegative  beyond  it,  cf.  the  T4  term  decomposition
    used  in  T4OffD).  FORMAL  NEGATIVE  RESULT  about  the
    machine  wire;  no  claim  about  zeta.  -/
theorem t4l_squeezeImpos_edge (t0 : ℝ) (ht0 : (10000000000 : ℝ) ≤ t0) :
    ¬ ((1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) ≤
        S1LowT.floStripMin t0 (1 / 200)) := by
  intro hsl
  have hbar : (1 / 2 : ℝ) * ((S4Strip.n4 t0 : ℝ) ^ (-(99 / 200 : ℝ))) >
      S1LowT.floStripMin t0 (1 / 200) :=
    t4l_barrier_edge t0 ht0
  exact lt_irrefl _ (lt_of_lt_of_le hbar hsl)

/--  Same  at  sigma  =  0  (d0  = 1/2):  at  EVERY  schedule  n,
    the  first  T4  term  (identically  1/2)  exceeds  the  floor.
    -/
theorem t4l_squeezeImpos_sigma0 (t0 : ℝ) (ht0 : 1000 ≤ t0)
    (n : ℕ) (hn : 0 < n) :
    ¬ ((1 / 2 : ℝ) * ((n : ℝ) ^ (0 : ℝ)) ≤
        S1LowT.floStripMin t0 (1 / 2)) := by
  intro hsl
  have hbar : (1 / 2 : ℝ) * ((n : ℝ) ^ (0 : ℝ)) >
      S1LowT.floStripMin t0 (1 / 2) :=
    t4l_barrier_sigma0 t0 ht0 n hn
  exact lt_irrefl _ (lt_of_lt_of_le hbar hsl)

/-  =================================================================
   S6  The  frontier  corollary
   =================================================================
   The  barriers  apply  at  the  CITED  Platt-Trudgian  frontier
   height  (WinC.tPT2  =  3000175332800  >=  10^10).  -/

/--  At  the  Platt-Trudgian  frontier  itself,  the  band-edge
    barrier  holds  (tPT2  >=  10^10,  exact  pin).  -/
theorem t4l_barrier_edge_PT2 :
    (1 / 2 : ℝ) * ((S4Strip.n4 WinC.tPT2 : ℝ) ^ (-(99 / 200 : ℝ))) >
      S1LowT.floStripMin WinC.tPT2 (1 / 200) := by
  have hfront : (10000000000 : ℝ) ≤ WinC.tPT2 := by
    dsimp only [WinC.tPT2]
    norm_num
  exact t4l_barrier_edge WinC.tPT2 hfront
