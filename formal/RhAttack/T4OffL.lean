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
import RhAttack.S4Asm
import RhAttack.T4OffM

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

/-  =================================================================
   S7  THE  LEFT-TUNED  SCHEDULE  FAMILY  (discovery  0123)
   =================================================================
   The  POSITIVE  DUAL  of  the  barriers  (S4/S5):  at  a  FIXED
   left-flank  point  (d0  <  1/2,  sigma  = 1/2  -  d0  >  0)
   the  first  T4  term  (1/2)*n^{-sigma}  CAN  be  closed  -
   against  the  EDGE-FLOOR  SCALE  (1/9999)*t^{-2}  -  by  a
   d0-DEPENDENT  schedule  n  ~=  A(sigma)  *  t^{2/sigma}  with
   the  constant  A(sigma)  =  (9999/2)^{1/sigma}.  S4  says  the
   UNIFORM  n4  schedule  cannot  do  it  (band  edge,  t  >=
   10^10);  S7  says  how  a  per-point  schedule  must  look:
   the  power  2/sigma  exceeds  4  at  the  band  edge  (sigma
   =  99/200:  400/99)  and  the  constant  A(sigma)  DIVERGES
   as  sigma  ->  0  (d0  ->  1/2)  -  exactly  the  two  sides
   of  the  no-uniform-schedule  barrier,  now  with  explicit
   rates.  All  pins  are  exact  (norm_num  on  integer
   powers);  no  numerics  on  the  rpow  steps.  -/

/--  S7.1  THE  SCHEDULE  CONSTANT  (discovery  0123):  the
    least-scale  constant  that  crushes  the  first  T4  term
    (1/2)  down  to  the  edge-floor  scale  1/9999:  with  B
    =  A(sigma)  *  t^{2/sigma},
    (1/2)  *  B^{-sigma}  =  (1/2)  *  (A(sigma)^{-sigma})  *
    t^{-2}  =  (1/2)  *  (2/9999)  *  t^{-2}  =  (1/9999)  *
    t^{-2}  -  exact.  -/
noncomputable def t4l_schedA (sigma : ℝ) : ℝ :=
    (9999 / 2 : ℝ) ^ (1 / sigma)

/--  S7.2  WELL-DEFINED  AND  POSITIVE  for  every  sigma  >  0.
    -/
theorem t4l_schedA_pos (sigma : ℝ) (hsig : 0 < sigma) :
    0 < t4l_schedA sigma := by
  dsimp only [t4l_schedA]
  exact Real.rpow_pos_of_pos (by norm_num) (1 / sigma)

/-  S7.3  THE  PER-POINT  CLOSURE:  at  a  fixed  left-flank
    point  (t  >=  1000,  sigma  >  0)  EVERY  schedule  n  at
    or  above  the  critical  scale  A(sigma)  *  t^{2/sigma}
    puts  the  first  T4  term  AT  OR  BELOW  the  edge-floor
    scale  target.  This  is  the  contrapositive  of  S4.1
    (t4l_barrier_edge)  as  a  CONSTRUCTION:  the  barrier  is
    about  the  UNIFORM  n4  schedule  below  this  scale.  -/
theorem t4l_schedTerm1 (t sigma : ℝ) (ht : 1000 ≤ t) (hsig : 0 < sigma)
    (n : ℕ) (hn : 0 < n)
    (hsched : (n : ℝ) ≥ t4l_schedA sigma * t ^ (2 / sigma)) :
    (1 / 2 : ℝ) * (n : ℝ) ^ (-sigma) ≤ (1 / 9999 : ℝ) * t ^ (-2 : ℝ) := by
  have hT2 : 0 < t ^ 2 := by positivity
  have hBsplit : (t4l_schedA sigma * t ^ (2 / sigma)) ^ sigma =
      (t4l_schedA sigma) ^ sigma * (t ^ (2 / sigma)) ^ sigma := by
    dsimp only [t4l_schedA]
    simpa using Real.mul_rpow
      (le_of_lt (Real.rpow_pos_of_pos (by norm_num : 0 < (9999 / 2 : ℝ)) (1 / sigma)))
      (le_of_lt (Real.rpow_pos_of_pos (by linarith [ht] : 0 < t) (2 / sigma)))
  have hBpow : (t4l_schedA sigma * t ^ (2 / sigma)) ^ sigma =
      (9999 / 2 : ℝ) * t ^ 2 := by
    rw [hBsplit]
    rw [show (t4l_schedA sigma) ^ sigma = (9999 / 2 : ℝ) by
          dsimp only [t4l_schedA]
          rw [← Real.rpow_mul (by norm_num : 0 ≤ (9999 / 2 : ℝ)) (1 / sigma) sigma]
          rw [show ((1 / sigma : ℝ) * sigma) = 1 by
            field_simp [ne_of_gt hsig]]
          rw [Real.rpow_one (9999 / 2 : ℝ)]]
    rw [show (t ^ (2 / sigma)) ^ sigma = t ^ 2 by
          rw [← Real.rpow_mul (by linarith [ht] : 0 ≤ t) (2 / sigma) sigma]
          rw [show ((2 / sigma : ℝ) * sigma) = 2 by
            field_simp [ne_of_gt hsig]]
          exact Real.rpow_natCast t 2]
  have hinvB : ((9999 / 2 : ℝ) * t ^ 2)⁻¹ = (2 / 9999 : ℝ) * t ^ (-2 : ℝ) := by
    have hinv : ((9999 / 2 : ℝ) * t ^ 2)⁻¹ =
        ((9999 / 2 : ℝ)⁻¹) * (t ^ 2)⁻¹ := by
      field_simp [show (9999 / 2 : ℝ) ≠ 0 by norm_num,
        show t ^ 2 ≠ 0 by linarith [hT2]]
    rw [hinv]
    have hneg : (t ^ 2)⁻¹ = t ^ (-2 : ℝ) := by
      convert (Real.rpow_neg (le_of_lt (by linarith [ht] : 0 < t)) (2 : ℝ)).symm
      exact (Real.rpow_natCast t 2).symm
    rw [hneg]
    rw [show ((9999 / 2 : ℝ)⁻¹) = 2 / 9999 by norm_num]
  have hApos : 0 < t4l_schedA sigma := t4l_schedA_pos sigma hsig
  have hBpos : 0 < t4l_schedA sigma * t ^ (2 / sigma) :=
    mul_pos hApos (Real.rpow_pos_of_pos (by linarith [ht] : 0 < t) (2 / sigma))
  have hBpowpos : 0 < (t4l_schedA sigma * t ^ (2 / sigma)) ^ sigma :=
    Real.rpow_pos_of_pos hBpos sigma
  have hnpos : 0 < (n : ℝ) ^ sigma :=
    Real.rpow_pos_of_pos (Nat.cast_pos.mpr hn) sigma
  have hmono : (t4l_schedA sigma * t ^ (2 / sigma)) ^ sigma ≤
      (n : ℝ) ^ sigma :=
    Real.rpow_le_rpow (le_of_lt hBpos) hsched (by linarith [hsig])
  have hstep : (n : ℝ) ^ (-sigma) ≤
      ((9999 / 2 : ℝ) * t ^ 2)⁻¹ := by
    calc (n : ℝ) ^ (-sigma)
        _ = ((n : ℝ) ^ sigma)⁻¹ :=
          Real.rpow_neg (le_of_lt (by positivity : 0 < (n : ℝ))) sigma
        _ ≤ ((t4l_schedA sigma * t ^ (2 / sigma)) ^ sigma)⁻¹ :=
          (inv_le_inv₀ hnpos hBpowpos).mpr hmono
        _ = ((9999 / 2 : ℝ) * t ^ 2)⁻¹ := by rw [hBpow]
  have hterm : (1 / 2 : ℝ) * (n : ℝ) ^ (-sigma) ≤
      (1 / 2 : ℝ) * ((9999 / 2 : ℝ) * t ^ 2)⁻¹ :=
    mul_le_mul_of_nonneg_left hstep (by norm_num : (0 : ℝ) ≤ 1 / 2)
  have hfin : (1 / 2 : ℝ) * ((9999 / 2 : ℝ) * t ^ 2)⁻¹ =
      (1 / 9999 : ℝ) * t ^ (-2 : ℝ) := by
    rw [hinvB]
    ring_nf
  exact le_trans hterm (le_of_eq hfin)

/-  S7.4  THE  SCHEDULE  BEATS  THE  MACHINE  AT  THE  FRONTIER
    HEIGHT  (the  break  of  n4-uniformity  with  an  explicit
    rate):  at  t  =  10^10  and  the  band  edge  (sigma  =
    99/200),  the  per-point  critical  scale  A(sigma)  *
    t^{2/sigma}  =  (9999/2)^{200/99}  *  t^{400/99}  EXCEEDS
    the  uniform  machine  schedule  S4Strip.n4  (<=  2  *
    31000000  *  t^4)  -  the  schedule  outgrows  the  uniform
    wire  by  a  margin  pinned  below  to  the  99th  power.
    The  equivalent  powered  form  ((9999/2)^{200}  *  10^40
    >  62000000^99)  is  a  pure  norm_num  pin.  -/
theorem t4l_schedBeat4pin :
    (9999 / 2 : ℝ) ^ 200 * (10 : ℝ) ^ 40 > (62000000 : ℝ) ^ 99 := by
  norm_num

/--  S7.4b  AT  t  =  10^10  THE  CRITICAL  SCALE  EXCEEDS  THE
    UNIFORM  n4  SCHEDULE  (the  break  of  n4-uniformity).  -/
theorem t4l_schedBeat4 :
    t4l_schedA (99 / 200) * ((10 : ℝ) ^ 10) ^ (400 / 99 : ℝ) >
      (S4Strip.n4 (10 ^ 10 : ℝ) : ℝ) := by
  let T := (10 : ℝ) ^ 10
  have hupper : (S4Strip.n4 (10 ^ 10 : ℝ) : ℝ) ≤
      2 * (31000000 : ℝ) * T ^ 4 := by
    simpa [show T = (10 ^ 10 : ℝ) by norm_num] using
      t4l_n4upper (10 ^ 10 : ℝ) (by norm_num)
  by_contra hbad
  push Not at hbad
  have hA : t4l_schedA (99 / 200) = (9999 / 2 : ℝ) ^ (200 / 99 : ℝ) := by
    dsimp only [t4l_schedA]
    norm_num
  have hchain : t4l_schedA (99 / 200) * T ^ (400 / 99 : ℝ) ≤
      2 * (31000000 : ℝ) * T ^ 4 :=
    le_trans hbad hupper
  have hchainpos : 0 < t4l_schedA (99 / 200) * T ^ (400 / 99 : ℝ) :=
    mul_pos (t4l_schedA_pos (99 / 200) (by norm_num))
      (Real.rpow_pos_of_pos (by norm_num : 0 < T) (400 / 99 : ℝ))
  have hpow : (t4l_schedA (99 / 200) * T ^ (400 / 99 : ℝ)) ^ (99 : ℝ) ≤
      (2 * (31000000 : ℝ) * T ^ 4) ^ (99 : ℝ) :=
    Real.rpow_le_rpow (le_of_lt hchainpos) hchain (by norm_num : (0 : ℝ) ≤ 99)
  have hL : (t4l_schedA (99 / 200) * T ^ (400 / 99 : ℝ)) ^ (99 : ℝ) =
      (9999 / 2 : ℝ) ^ 200 * T ^ 400 := by
    rw [hA]
    have hsplit : ((9999 / 2 : ℝ) ^ (200 / 99 : ℝ) * T ^ (400 / 99 : ℝ)) ^
        (99 : ℝ) =
        ((9999 / 2 : ℝ) ^ (200 / 99 : ℝ)) ^ (99 : ℝ) *
        (T ^ (400 / 99 : ℝ)) ^ (99 : ℝ) := by
      rw [Real.mul_rpow
        (le_of_lt (Real.rpow_pos_of_pos
          (by norm_num : 0 < (9999 / 2 : ℝ)) (200 / 99 : ℝ)))
        (le_of_lt (Real.rpow_pos_of_pos (by norm_num : 0 < T) (400 / 99 : ℝ)))]
    rw [hsplit]
    rw [show ((9999 / 2 : ℝ) ^ (200 / 99 : ℝ)) ^ (99 : ℝ) =
        (9999 / 2 : ℝ) ^ 200 by
      rw [← Real.rpow_mul (by norm_num : 0 ≤ (9999 / 2 : ℝ)) (200 / 99 : ℝ) (99 : ℝ)]
      rw [show ((200 / 99 : ℝ) * (99 : ℝ)) = (200 : ℝ) by norm_num]
      exact Real.rpow_natCast (9999 / 2 : ℝ) 200]
    rw [show (T ^ (400 / 99 : ℝ)) ^ (99 : ℝ) = T ^ 400 by
      rw [← Real.rpow_mul (le_of_lt (by norm_num : 0 < T)) (400 / 99 : ℝ) (99 : ℝ)]
      rw [show ((400 / 99 : ℝ) * (99 : ℝ)) = (400 : ℝ) by norm_num]
      exact Real.rpow_natCast T 400]
  have hR : (2 * (31000000 : ℝ) * T ^ 4) ^ (99 : ℝ) =
      (62000000 : ℝ) ^ 99 * T ^ 396 := by
    have hsplit : (2 * (31000000 : ℝ) * T ^ 4) =
        (62000000 : ℝ) * T ^ 4 := by norm_num
    rw [hsplit]
    rw [Real.mul_rpow (by norm_num : 0 ≤ (62000000 : ℝ))
      (le_of_lt (by norm_num : 0 < T ^ 4))]
    rw [show (62000000 : ℝ) ^ (99 : ℝ) = (62000000 : ℝ) ^ 99 by
      exact Real.rpow_natCast (62000000 : ℝ) 99]
    rw [show (T ^ 4) ^ (99 : ℝ) = T ^ 396 by
      have h1 : (T ^ 4) ^ (99 : ℝ) = (T ^ 4) ^ 99 := Real.rpow_natCast (T ^ 4) 99
      have h2 : (T ^ 4) ^ 99 = T ^ 396 := by
        rw [pow_mul T 4 99]
      exact Eq.trans h1 h2]
  rw [hL, hR] at hpow
  have hT396pos : 0 < T ^ 396 := pow_pos (by norm_num : 0 < T) 396
  have hcanceled : (9999 / 2 : ℝ) ^ 200 * T ^ 4 ≤ (62000000 : ℝ) ^ 99 := by
    have hdiv : ((9999 / 2 : ℝ) ^ 200 * T ^ 400) / T ^ 396 ≤
        ((62000000 : ℝ) ^ 99 * T ^ 396) / T ^ 396 :=
      div_le_div_of_nonneg_right hpow (le_of_lt hT396pos)
    have hR2 : ((62000000 : ℝ) ^ 99 * T ^ 396) / T ^ 396 =
        (62000000 : ℝ) ^ 99 := by
      rw [div_eq_mul_inv]
      rw [mul_assoc]
      rw [mul_inv_cancel₀ (ne_of_gt hT396pos)]
      rw [mul_one]
    rw [hR2] at hdiv
    have hL2 : ((9999 / 2 : ℝ) ^ 200 * T ^ 400) / T ^ 396 =
        (9999 / 2 : ℝ) ^ 200 * T ^ 4 := by
      have hT : T ^ 400 = T ^ 396 * T ^ 4 := by
        rw [show (400 : ℕ) = 396 + 4 by norm_num, ← pow_add T 396 4]
      rw [div_eq_mul_inv, hT]
      rw [mul_assoc ((9999 / 2 : ℝ) ^ 200) (T ^ 396 * T ^ 4) (T ^ 396)⁻¹]
      rw [show (T ^ 396 * T ^ 4) * (T ^ 396)⁻¹ = T ^ 4 by
            rw [mul_assoc]
            rw [show T ^ 4 * (T ^ 396)⁻¹ = (T ^ 396)⁻¹ * T ^ 4 by
                  rw [mul_comm]]
            rw [← mul_assoc]
            rw [mul_inv_cancel₀ (ne_of_gt hT396pos)]
            rw [one_mul]]
    rw [← hL2]
    exact hdiv
  have hT4 : T ^ 4 = (10 : ℝ) ^ 40 := by
    dsimp only [T]
    rw [pow_mul (10 : ℝ) 10 4]
  have hcontra : (9999 / 2 : ℝ) ^ 200 * (10 : ℝ) ^ 40 ≤
      (62000000 : ℝ) ^ 99 := by
    rw [← hT4]
    exact hcanceled
  exact lt_irrefl _ (lt_of_lt_of_le t4l_schedBeat4pin hcontra)

/-  S7.5  THE  CONSTANT  DIVERGES  AT  THE  BAND  TOP  (the
    other  side  of  the  no-uniform-schedule  barrier):  for
    EVERY  A  >  0  there  exists  a  d0  in  the  strip  band
    (1/200  <=  d0  <  1/2)  whose  per-point  schedule  constant
    exceeds  A  -  so  NO  constant  (and  hence  no  n-polynomial
    schedule  with  a  d0-UNIFORM  leading  constant)  can  serve
    the  left  wire  across  the  whole  band.  For  A  >  1  the
    explicit  choice  is  sigma  =  min  (ln(9999/2)  /  (2  ln
    A),  1/2000)  (d0  =  1/2  -  sigma):  the  schedule  then
    equals  at  least  A^2  >  A.  -/
theorem t4l_schedDiverge (A : ℝ) (hA : 0 < A) :
    ∃ d0, (1 / 200 : ℝ) ≤ d0 ∧ d0 < 1 / 2 ∧
      t4l_schedA (1 / 2 - d0) > A := by
  have hB : 1 < (9999 / 2 : ℝ) := by norm_num
  by_cases hA1 : 1 < A
  · --  A  >  1:  the  explicit  small-sigma  choice.
    have hlnA : 0 < Real.log A := Real.log_pos hA1
    have hlnB : 0 < Real.log (9999 / 2 : ℝ) := Real.log_pos hB
    let sigma0 := Real.log (9999 / 2 : ℝ) / (2 * Real.log A)
    let sig := min sigma0 (1 / 2000 : ℝ)
    have hs0 : 0 < sigma0 := div_pos hlnB (by positivity)
    have hsm : 0 < sig := (lt_min_iff : (0 : ℝ) < min sigma0 (1 / 2000 : ℝ) ↔
        (0 : ℝ) < sigma0 ∧ (0 : ℝ) < (1 / 2000 : ℝ)).mpr
        ⟨hs0, by norm_num⟩
    have hsmle : sig ≤ sigma0 := min_le_left sigma0 (1 / 2000 : ℝ)
    have hinv : 1 / sigma0 ≤ 1 / sig :=
      (one_div_le_one_div hs0 hsm).mpr hsmle
    have hinv2 : 1 / sigma0 = (2 * Real.log A) / Real.log (9999 / 2 : ℝ) := by
      dsimp only [sigma0]
      field_simp [ne_of_gt hlnA, ne_of_gt hlnB]
    have hlog : Real.log (t4l_schedA sig) =
        (1 / sig) * Real.log (9999 / 2 : ℝ) := by
      dsimp only [t4l_schedA]
      rw [Real.log_rpow (by norm_num : 0 < (9999 / 2 : ℝ)) (1 / sig)]
    have hge : (1 / sig) * Real.log (9999 / 2 : ℝ) ≥
        (2 * Real.log A) / Real.log (9999 / 2 : ℝ) * Real.log (9999 / 2 : ℝ) := by
      calc (1 / sig) * Real.log (9999 / 2 : ℝ) ≥
          (1 / sigma0) * Real.log (9999 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_right hinv (le_of_lt hlnB)
        _ = ((2 * Real.log A) / Real.log (9999 / 2 : ℝ)) *
            Real.log (9999 / 2 : ℝ) := by rw [hinv2]
    have hred : (2 * Real.log A) / Real.log (9999 / 2 : ℝ) *
        Real.log (9999 / 2 : ℝ) = 2 * Real.log A := by
      field_simp [ne_of_gt hlnB]
    have hgt : Real.log (t4l_schedA sig) > Real.log A := by
      calc Real.log (t4l_schedA sig) =
          (1 / sig) * Real.log (9999 / 2 : ℝ) := hlog
        _ ≥ 2 * Real.log A := by
          linarith [hge, hred]
        _ = Real.log (A * A) := by
          have hlogA2 : Real.log (A * A) = 2 * Real.log A := by
            rw [show A * A = A ^ 2 by ring]
            rw [Real.log_pow A 2]
            norm_num
          rw [hlogA2]
        _ > Real.log A := by
          apply Real.log_lt_log (by linarith [hA] : 0 < A)
          nlinarith [hA1]
    have hgtApos : 0 < t4l_schedA sig := t4l_schedA_pos sig hsm
    have hgtA : t4l_schedA sig > A :=
      (Real.log_lt_log_iff hA hgtApos).mp hgt
    use (1 / 2 : ℝ) - sig
    constructor
    · --  sig  <=  99/200
      have hsmall : sig ≤ (99 / 200 : ℝ) := by
        calc sig ≤ (1 / 2000 : ℝ) := min_le_right sigma0 (1 / 2000 : ℝ)
          _ ≤ (99 / 200 : ℝ) := by norm_num
      linarith
    · constructor
      · linarith [hsm]
      · have harg : (1 / 2 : ℝ) - ((1 / 2 : ℝ) - sig) = sig := by
          ring_nf
        rw [harg]
        exact hgtA
  · --  A  <=  1:  the  band  edge  itself  suffices  (schedA  >  1  >=  A).
    use (1 / 200 : ℝ)
    constructor
    · norm_num
    · constructor
      · norm_num
      · have hgt1 : 1 < t4l_schedA (99 / 200) := by
          dsimp only [t4l_schedA]
          exact Real.one_lt_rpow (by norm_num) (by norm_num)
        linarith [hA1, hgt1]



/-!
S8. THE LEFT-FLANK SQUARE-ROOT SCHEDULE AND THE S3 LEFT WALL.

The 0121/0122/0123 record named G-hs3-left from the RIGHT side: the
n^4 wire cannot close the T3 face at sigma < 1/2 under ANY d0-
uniform schedule (t4l_schedDiverge), and the per-point critical
scale is t4l_schedA (S7). This section is the POSITIVE dual,
machined termwise against the on-line p8 floor, exactly as
t4wall_offline_le_bwires (T4OffD) does for the right flank:

  (1)  t4l_schedB t sigma = (n4 t)^(1/(2 sigma))  (sigma > 0):
      the square-root schedule, in REALS (no ceiling needed at
      the theorem level).

  (2)  t4l_sched_pow:  n >= t4l_schedB t sigma  implies
      n^a >= (n4 t)^(a/(2 sigma))  for every a > 0.

  (3)  t4l_wall_T1 / t4l_wall_T2 / t4l_wall_T3: the three T4
      terms at the LEFT point sigma = 1/2 - d0 < 1/2 are
      termwise <= the three on-line terms of p8_B t (n4 t)
      at the schedule, with the single T3 power margin
      (S8.10, two exact 99th-power pins) against the 216 vs 540
      coefficient gap.

  (4)  t4l_wall_tuned: the main left wall, in body:
      ||p4_em_expr (sL) n|| <= p8_B t (n4 t)  for n at or
      above the square-root schedule.

  (5)  t4l_face_left_body: composition into the endpoint
      face:  ||p4_em_expr (sL) n|| <= S4A.BwireR t d0
      + t4m_MwireOff t d0  - the S3 left leg as a body
      statement on the band.

  (6)  t4l_face_left_band: existence of such a schedule at
      every band off-pair with t0 >= 10^10.

No RH claim: all statements are about explicit functions of
(t, d0, n).  The sigma = 0 slice (d0 = 1/2) is EXCLUDED by
hypothesis d0 < 1/2 (the 0121 barrier remains there).
-/

/-- S8.1 THE SQUARE-ROOT SCHEDULE (reals): at n  =  (n4)^(1/(2 sigma)),
    the first left T4 term is at scale (n4)^(-sigma)  =  (n4)^(-1/2)
    =  the on-line first term.  -/
noncomputable def t4l_schedB (t sigma : ℝ) : ℝ :=
    (S4Strip.n4 t : ℝ) ^ (1 / (2 * sigma))

/-- S8.2 The schedule is positive (hence well-defined). -/
theorem t4l_schedB_pos (t sigma : ℝ) (ht : 1000 ≤ t) (hsp : 0 < sigma) :
    0 < t4l_schedB t sigma := by
  dsimp only [t4l_schedB]
  exact Real.rpow_pos_of_pos (Nat.cast_pos.mpr (t4o_n4pos t ht))
    (1 / (2 * sigma))

/-- S8.3 THE SCHEDULE DOMINATES n4  (sigma <= 1/2,  so  the
    exponent 1/(2sigma)  >=  1,  and  n4  >=  1).  -/
theorem t4l_schedB_ge_n4 (t sigma : ℝ) (ht : 1000 ≤ t)
    (hsp : 0 < sigma) (hsig : sigma ≤ (1 / 2 : ℝ)) :
    (S4Strip.n4 t : ℝ) ≤ t4l_schedB t sigma := by
  let n4R : ℝ := (S4Strip.n4 t : ℝ)
  have hn4 : 1 ≤ n4R := by
    dsimp only [n4R]
    have hfloor : n4R ≥ 31000000 * t ^ 4 := t4o_n4floor t ht
    have h4 : 1000 ^ 4 ≤ t ^ 4 := by gcongr
    have h4b : 31000000 * 1000 ^ 4 ≤ 31000000 * t ^ 4 :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    have h4c : (1 : ℝ) ≤ 31000000 * 1000 ^ 4 := by norm_num
    linarith
  dsimp only [t4l_schedB]
  have hexp : 1 ≤ 1 / (2 * sigma) := by
    field_simp [show (0 : ℝ) < 2 * sigma from by linarith [hsp]]
    nlinarith [hsig]
  simpa using (Real.rpow_le_rpow_of_exponent_le hn4 hexp)

/-  S8.4  THE  POWER  LIFT  (the  single  schedule  fact):
    n  >=  (n4)^{1/(2sigma)}  implies  n^a  >=  n4^{a/(2sigma)}
    for  every  a  >  0  -  T1/T2/T3  are  corollaries  at
    a  =  sigma,  sigma+1,  sigma+2.  -/
theorem t4l_sched_pow (t sigma : ℝ) (ht : 1000 ≤ t) (hsp : 0 < sigma)
    (a : ℝ) (ha : 0 < a) (n : ℕ) (hn : (n : ℝ) ≥ t4l_schedB t sigma) :
    (n : ℝ) ^ a ≥ (S4Strip.n4 t : ℝ) ^ (a / (2 * sigma)) := by
  let n4R : ℝ := (S4Strip.n4 t : ℝ)
  have hBpos : 0 < t4l_schedB t sigma := t4l_schedB_pos t sigma ht hsp
  calc (n : ℝ) ^ a
      ≥ (t4l_schedB t sigma) ^ a :=
        Real.rpow_le_rpow (le_of_lt hBpos) hn (le_of_lt ha)
    _ = ((n4R : ℝ) ^ (1 / (2 * sigma))) ^ a := by
      dsimp only [t4l_schedB]
    _ = (n4R : ℝ) ^ ((1 / (2 * sigma)) * a) :=
      (Real.rpow_mul (Nat.cast_nonneg (S4Strip.n4 t))
        (1 / (2 * sigma)) a).symm
    _ = (n4R : ℝ) ^ (a / (2 * sigma)) := by
      rw [show (1 / (2 * sigma)) * a = a / (2 * sigma) by ring]

/-- S8.5 NORM AT THE LEFT POINT: normsq expansion. -/
private theorem t4l_normsq_L (t d0 : ℝ) :
    ‖t4l_sOffL t d0‖ ^ 2 = (1 / 2 - d0) ^ 2 + t ^ 2 := by
  dsimp only [t4l_sOffL]
  rw [t4o_normsq (1 / 2 - d0) t]

/-- S8.6 ||sL|| <= ||sOn||. -/
theorem t4l_wall_norm1 (t d0 : ℝ) (hd : 0 ≤ d0) (hdh : d0 ≤ (1 / 2 : ℝ)) :
    ‖t4l_sOffL t d0‖ ≤ ‖t4o_sOn t‖ := by
  have hsq : (1 / 2 - d0) ^ 2 ≤ (1 / 4 : ℝ) := by
    nlinarith [hd, hdh]
  have hL2 : ‖t4l_sOffL t d0‖ ^ 2 ≤ ‖t4o_sOn t‖ ^ 2 := by
    calc ‖t4l_sOffL t d0‖ ^ 2 = (1 / 2 - d0) ^ 2 + t ^ 2 :=
        t4l_normsq_L t d0
      _ ≤ (1 / 4 : ℝ) + t ^ 2 :=
        add_le_add hsq (le_rfl)
      _ = ‖t4o_sOn t‖ ^ 2 := by rw [t4o_normsq_on t]
  calc ‖t4l_sOffL t d0‖ = Real.sqrt (‖t4l_sOffL t d0‖ ^ 2) :=
      (Real.sqrt_sq (by positivity : 0 ≤ ‖t4l_sOffL t d0‖)).symm
    _ ≤ Real.sqrt (‖t4o_sOn t‖ ^ 2) :=
      Real.sqrt_le_sqrt hL2
    _ = ‖t4o_sOn t‖ :=
      Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOn t‖)

/-  S8.7  THE  SHIFTED  LEFT  POINTS:  for  k  >=  0  with
    d0  in  [0,  1/2],  the  shifted  left  norm  is  still
    termwise  <=  the  shifted  on-line  norm
    ((1/2-d0+k)^2  <=  (1/2+k)^2  needs  d0  <=  1+2k,  which
    1/2  implies).  -/
private theorem t4l_shift_normsq (t d0 k : ℝ) (hd : 0 ≤ d0)
    (hdh : d0 ≤ (1 / 2 : ℝ)) (hkn : 0 ≤ k) :
    ‖t4l_sOffL t d0 + k‖ ^ 2 ≤ ‖t4o_sOn t + k‖ ^ 2 := by
  dsimp only [t4l_sOffL, t4o_sOn]
  have h1 : ((1 / 2 - d0 : ℝ) : ℂ) + (t : ℂ) * Complex.I + k =
      ((1 / 2 - d0 + k : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    norm_num [Complex.ext_iff, Complex.ofReal_add,
      Complex.ofReal_re, Complex.add_re, Complex.mul_re,
      Complex.I_re, Complex.mul_im, Complex.I_im, Complex.ofReal_im]
  have h2 : ((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + k =
      ((1 / 2 + k : ℝ) : ℂ) + (t : ℂ) * Complex.I := by
    norm_num [Complex.ext_iff, Complex.ofReal_add,
      Complex.ofReal_re, Complex.add_re, Complex.mul_re,
      Complex.I_re, Complex.mul_im, Complex.I_im, Complex.ofReal_im]
  rw [h1, h2]
  rw [t4o_normsq (1 / 2 - d0 + k) t, t4o_normsq (1 / 2 + k) t]
  have hsq : (1 / 2 - d0 + k) ^ 2 ≤ (1 / 2 + k) ^ 2 := by
    have hc : 0 ≤ (1 / 2 : ℝ) + k := by nlinarith [hkn]
    nlinarith [hd, hdh, hkn, hc, show 0 ≤ d0 from hd,
      show d0 ≤ 1 + 2 * k from by nlinarith [hdh, hkn], hc]
  exact add_le_add hsq (le_rfl)

private theorem t4l_shift_norm (t d0 k : ℝ) (hd : 0 ≤ d0)
    (hdh : d0 ≤ (1 / 2 : ℝ)) (hkn : 0 ≤ k) :
    ‖t4l_sOffL t d0 + k‖ ≤ ‖t4o_sOn t + k‖ := by
  have hL2 : ‖t4l_sOffL t d0 + k‖ ^ 2 ≤ ‖t4o_sOn t + k‖ ^ 2 :=
    t4l_shift_normsq t d0 k hd hdh hkn
  calc ‖t4l_sOffL t d0 + k‖ = Real.sqrt (‖t4l_sOffL t d0 + k‖ ^ 2) :=
      (Real.sqrt_sq (by positivity : 0 ≤ ‖t4l_sOffL t d0 + k‖)).symm
    _ ≤ Real.sqrt (‖t4o_sOn t + k‖ ^ 2) :=
      Real.sqrt_le_sqrt hL2
    _ = ‖t4o_sOn t + k‖ :=
      Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOn t + k‖)

/-- S8.8 THE TRIPLE-PRODUCT NORM is termwise smaller at the
    left point. -/
theorem t4l_wall_norm_prod (t d0 : ℝ) (hd : 0 ≤ d0) (hdh : d0 ≤ (1 / 2 : ℝ)) :
    ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ ≤
      ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ := by
  let sL := t4l_sOffL t d0
  let sO := t4o_sOn t
  have hk0 : ‖sL‖ ≤ ‖sO‖ := t4l_wall_norm1 t d0 hd hdh
  have hk1 : ‖sL + 1‖ ≤ ‖sO + 1‖ :=
    by dsimp only [sL, sO]; exact t4l_shift_norm t d0 1 hd hdh (by norm_num)
  have hk2 : ‖sL + 2‖ ≤ ‖sO + 2‖ :=
    by dsimp only [sL, sO]; exact t4l_shift_norm t d0 2 hd hdh (by norm_num)
  have hchain3 : ‖sL‖ * ‖sL + 1‖ * ‖sL + 2‖ ≤
      ‖sO‖ * ‖sO + 1‖ * ‖sO + 2‖ := by
    have hm1 : ‖sL‖ * ‖sL + 1‖ ≤ ‖sO‖ * ‖sO + 1‖ :=
      mul_le_mul_of_nonneg hk0 hk1
        (by positivity : 0 ≤ ‖sL‖)
        (by positivity : 0 ≤ ‖sO + 1‖)
    calc ‖sL‖ * ‖sL + 1‖ * ‖sL + 2‖
        = (‖sL‖ * ‖sL + 1‖) * ‖sL + 2‖ := by ring
      _ ≤ (‖sO‖ * ‖sO + 1‖) * ‖sL + 2‖ :=
        mul_le_mul_of_nonneg_right hm1 (by positivity : 0 ≤ ‖sL + 2‖)
      _ ≤ (‖sO‖ * ‖sO + 1‖) * ‖sO + 2‖ :=
        mul_le_mul_of_nonneg_left hk2 (by positivity : 0 ≤ ‖sO‖ * ‖sO + 1‖)
      _ = ‖sO‖ * ‖sO + 1‖ * ‖sO + 2‖ := by ring
  calc ‖sL * (sL + 1) * (sL + 2)‖
      = ‖sL‖ * ‖sL + 1‖ * ‖sL + 2‖ := by rw [norm_mul, norm_mul]
    _ ≤ ‖sO‖ * ‖sO + 1‖ * ‖sO + 2‖ := hchain3
    _ = ‖sO * (sO + 1) * (sO + 2)‖ := by rw [norm_mul, norm_mul]

/-  S8.9  PIN  1  (T3,  the  sharp  worst  corner):  (3.1e7)^{2/99}
    >=  500/499.  Route:  raise  to  the  99th  power  -
    (3.1e7)^2  >=  (500/499)^99,  with  (500/499)^99  <  3.
    EXACT  norm_num  on  the  99th  powers.  -/
theorem t4l_T3pin : (31000000 : ℝ) ^ (2 / 99 : ℝ) ≥ (500 : ℝ) / 499 := by
  have hy : 0 < (500 : ℝ) / 499 := by positivity
  have h99 : (500 : ℝ) ^ 99 < 3 * 499 ^ 99 := by norm_num
  let e99 : ℝ := (99 : ℕ)
  let t2 : ℝ := (2 : ℕ)
  have hq : (500 / 499 : ℝ) ^ e99 < (3 : ℝ) := by
    dsimp only [e99]
    rw [Real.rpow_natCast (500 / 499 : ℝ) 99, div_pow]
    exact (div_lt_iff₀ (by positivity : 0 < (499 : ℝ) ^ 99)).mpr h99
  have h3 : (3 : ℝ) ≤ (31000000 : ℝ) ^ t2 := by
    dsimp only [t2]
    rw [Real.rpow_natCast (31000000 : ℝ) 2]
    norm_num
  have hsq : (500 / 499 : ℝ) ^ e99 ≤ (31000000 : ℝ) ^ t2 :=
    (le_of_lt hq).trans h3
  calc (500 : ℝ) / 499
      = ((500 / 499 : ℝ) ^ e99) ^ (1 / 99 : ℝ) := by
        rw [← Real.rpow_mul (le_of_lt hy) e99 (1 / 99 : ℝ),
            show e99 * (1 / 99) = (1 : ℝ) by
              dsimp only [e99]
              norm_num]
        norm_num
    _ ≤ ((31000000 : ℝ) ^ t2) ^ (1 / 99 : ℝ) :=
      Real.rpow_le_rpow (Real.rpow_nonneg (le_of_lt hy) e99) hsq
        (by norm_num : 0 ≤ (1 : ℝ) / 99)
    _ = (31000000 : ℝ) ^ (2 / 99 : ℝ) := by
      rw [show (2 / 99 : ℝ) = t2 * (1 / 99) by
        dsimp only [t2]
        norm_num]
      exact (Real.rpow_mul (by norm_num : 0 ≤ (31000000 : ℝ)) t2 (1 / 99 : ℝ)).symm

/-  S8.9b  PIN  2  (T3,  the  bulk  regime):  (3.1e7)^{2/99}  >=
    10/9.  Route:  (10/9)^99  exact  norm_num  against  (3.1e7)^2.
    -/
theorem t4l_T3pin2 : (31000000 : ℝ) ^ (2 / 99 : ℝ) ≥ (10 : ℝ) / 9 := by
  have hr : 0 < (10 : ℝ) / 9 := by positivity
  have h99 : (10 : ℝ) ^ 99 < (31000000 : ℝ) ^ 2 * 9 ^ 99 := by norm_num
  let e99 : ℝ := (99 : ℕ)
  let t2 : ℝ := (2 : ℕ)
  have hq : (10 / 9 : ℝ) ^ e99 < (31000000 : ℝ) ^ 2 := by
    dsimp only [e99]
    rw [Real.rpow_natCast (10 / 9 : ℝ) 99, div_pow]
    exact (div_lt_iff₀ (by positivity : 0 < (9 : ℝ) ^ 99)).mpr h99
  have hq2 : (10 / 9 : ℝ) ^ e99 ≤ (31000000 : ℝ) ^ t2 := by
    dsimp only [t2]
    rw [Real.rpow_natCast (31000000 : ℝ) 2]
    exact le_of_lt hq
  calc (10 : ℝ) / 9
      = ((10 / 9 : ℝ) ^ e99) ^ (1 / 99 : ℝ) := by
        rw [← Real.rpow_mul (le_of_lt hr) e99 (1 / 99 : ℝ),
            show e99 * (1 / 99) = (1 : ℝ) by
              dsimp only [e99]
              norm_num]
        norm_num
    _ ≤ ((31000000 : ℝ) ^ t2) ^ (1 / 99 : ℝ) :=
      Real.rpow_le_rpow (Real.rpow_nonneg (le_of_lt hr) e99) hq2
        (by norm_num : 0 ≤ (1 : ℝ) / 99)
    _ = (31000000 : ℝ) ^ (2 / 99 : ℝ) := by
      rw [show (2 / 99 : ℝ) = t2 * (1 / 99) by
        dsimp only [t2]
        norm_num]
      exact (Real.rpow_mul (by norm_num : 0 ≤ (31000000 : ℝ)) t2 (1 / 99 : ℝ)).symm

/-  S8.10  THE  T3  POWER  MARGIN  (one  exponent,  two  cases):
    for  sigma  in  (0,  99/200]  and  t  >=  1000,
        (n4 t)^((1-2sigma)/sigma)  >=  5 / (2 (sigma+2)).
    Case  sigma  >=  1/4:  exponent  >=  2/99,  so  the  base
    n4  >=  31000000  wins  via  PIN  2  (worst  coefficient  at
    the  band  edge:  5/(2 sigma)  at  sigma  =  99/200  is  10/9
    against  the  216/540  gap  times  the  norm  ratio  1).
    Case  sigma  <  1/4:  exponent  >  2,  so  n4^2  >=
    (31000000)^2  >>  5/4  >=  5/(2(sigma+2)).  -/
theorem t4l_T3margin (t sigma : ℝ) (ht : 1000 ≤ t) (hsp : 0 < sigma)
    (hsig : sigma ≤ (99 / 200 : ℝ)) :
    (S4Strip.n4 t : ℝ) ^ ((1 - 2 * sigma) / sigma) ≥
      5 / (2 * (sigma + 2)) := by
  let n4R : ℝ := (S4Strip.n4 t : ℝ)
  have hn4 : (31000000 : ℝ) * t ^ 4 ≤ n4R := by
    dsimp only [n4R]
    exact t4o_n4floor t ht
  have hB : (31000000 : ℝ) ≤ n4R := by
    dsimp only [n4R]
    have hfloor : n4R ≥ 31000000 * t ^ 4 := t4o_n4floor t ht
    have h4 : 1000 ^ 4 ≤ t ^ 4 := by gcongr
    have h4b : 31000000 * 1000 ^ 4 ≤ 31000000 * t ^ 4 :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    have h4c : (31000000 : ℝ) ≤ 31000000 * 1000 ^ 4 := by norm_num
    linarith
  by_cases hcase : sigma ≥ (1 / 4 : ℝ)
  · -- sigma >= 1/4:  2/99 <= (1-2sigma)/sigma,  and the base is big.
    have hexp : (2 / 99 : ℝ) ≤ (1 - 2 * sigma) / sigma := by
      rw [div_le_div_iff₀ (by norm_num : 0 < (99 : ℝ))
          (by linarith [hsp] : 0 < sigma)]
      nlinarith [hsp, hcase, hsig]
    have hA : (31000000 : ℝ) ^ (2 / 99 : ℝ) ≤ n4R ^ ((1 - 2 * sigma) / sigma) := by
      have h1 : (31000000 : ℝ) ^ (2 / 99 : ℝ) ≤ (31000000 : ℝ) ^ ((1 - 2 * sigma) / sigma) :=
        Real.rpow_le_rpow_of_exponent_le (by norm_num : 1 ≤ (31000000 : ℝ)) hexp
      have h2 : (31000000 : ℝ) ≤ n4R := hB
      have h3 : (31000000 : ℝ) ^ ((1 - 2 * sigma) / sigma) ≤
          n4R ^ ((1 - 2 * sigma) / sigma) :=
        Real.rpow_le_rpow (by norm_num : 0 ≤ (31000000 : ℝ)) h2
          (by positivity)
      exact h1.trans h3
    have htop : 5 / (2 * (sigma + 2)) ≤ (10 : ℝ) / 9 := by
      rw [div_le_div_iff₀ (by linarith [hsp] : 0 < 2 * (sigma + 2))
          (by norm_num : (0 : ℝ) < 9)]
      norm_num
      nlinarith [hcase]
    calc 5 / (2 * (sigma + 2)) ≤ (10 : ℝ) / 9 := htop
      _ ≤ (31000000 : ℝ) ^ (2 / 99 : ℝ) := t4l_T3pin2
      _ ≤ n4R ^ ((1 - 2 * sigma) / sigma) := hA
  · -- sigma < 1/4:  (1-2sigma)/sigma > 2.
    let t2 : ℝ := (2 : ℕ)
    have hexp : t2 < (1 - 2 * sigma) / sigma := by
      have hlt : sigma < (1 / 4 : ℝ) := by linarith [hcase]
      dsimp only [t2]
      rw [lt_div_iff₀ (by linarith [hsp] : 0 < sigma)]
      norm_num
      nlinarith [hlt]
    have hb1 : 1 < n4R := by linarith [hB, (by norm_num : (1 : ℝ) < (31000000 : ℝ))]
    have hstep1 : (n4R : ℝ) ^ t2 <
        (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) :=
      Real.rpow_lt_rpow_of_exponent_lt hb1 hexp
    have hstep2 : (31000000 : ℝ) ^ t2 ≤ (n4R : ℝ) ^ t2 :=
      Real.rpow_le_rpow (by norm_num : 0 ≤ (31000000 : ℝ)) hB
        (by norm_num : 0 ≤ t2)
    have htop : 5 / (2 * (sigma + 2)) < (5 / 4 : ℝ) := by
      rw [div_lt_iff₀ (by linarith [hsp] : 0 < 2 * (sigma + 2))]
      nlinarith [hsp]
    have hbig : (5 / 4 : ℝ) ≤ (31000000 : ℝ) ^ t2 := by
      dsimp only [t2]
      rw [Real.rpow_natCast (31000000 : ℝ) 2]
      norm_num
    have hchain : 5 / (2 * (sigma + 2)) <
        (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) := by
      calc 5 / (2 * (sigma + 2)) < (5 / 4 : ℝ) := htop
        _ ≤ (31000000 : ℝ) ^ t2 := hbig
        _ ≤ (n4R : ℝ) ^ t2 := hstep2
        _ < (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) := hstep1
    exact le_of_lt hchain

/-  S8.11  T1  AT  THE  SQUARE-ROOT  SCHEDULE:  (1/2) n^(-sigma)
    <=  (1/2) (n4)^(-1/2).  -/
theorem t4l_wall_T1 (t d0 : ℝ) (ht : 1000 ≤ t) (hsp : 0 < 1 / 2 - d0)
    (n : ℕ) (hn : (n : ℝ) ≥ t4l_schedB t (1 / 2 - d0)) :
    (1 / 2 : ℝ) * (n : ℝ) ^ (-(1 / 2 - d0)) ≤
      (1 / 2 : ℝ) * (S4Strip.n4 t : ℝ) ^ (-1 / 2 : ℝ) := by
  set sigma := (1 / 2 : ℝ) - d0 with hsdef
  have hsp' : 0 < sigma := by simpa [sigma] using hsp
  set n4R : ℝ := (S4Strip.n4 t : ℝ) with h4def
  have hA : (n : ℝ) ^ sigma ≥ n4R ^ (sigma / (2 * sigma)) :=
    t4l_sched_pow t sigma ht hsp' sigma hsp' n hn
  have hB : n4R ^ (sigma / (2 * sigma)) = n4R ^ (1 / 2 : ℝ) := by
    rw [show sigma / (2 * sigma) = (1 / 2 : ℝ) by
      field_simp [show sigma ≠ 0 from by linarith [hsp']]]
  rw [hB] at hA
  have hnB : 0 < t4l_schedB t sigma := t4l_schedB_pos t sigma ht hsp'
  have hnpos : 0 < (n : ℝ) := by linarith [hn, hnB]
  have hnsp : 0 < (n : ℝ) ^ sigma := Real.rpow_pos_of_pos hnpos sigma
  have hBp : 0 < n4R ^ (1 / 2 : ℝ) :=
    Real.rpow_pos_of_pos (Nat.cast_pos.mpr (t4o_n4pos t ht)) (1 / 2 : ℝ)
  have hin : (1 : ℝ) / (n : ℝ) ^ sigma ≤ (1 : ℝ) / n4R ^ (1 / 2 : ℝ) :=
    (one_div_le_one_div hnsp hBp).mpr hA
  have h1 : (n : ℝ) ^ (-sigma) = (1 : ℝ) / (n : ℝ) ^ sigma := by
    rw [show (-sigma : ℝ) = -(sigma : ℝ) by ring,
        Real.rpow_neg (le_of_lt hnpos) sigma,
        ← one_div ((n : ℝ) ^ sigma)]
  have h2 : n4R ^ (-1 / 2 : ℝ) = (1 : ℝ) / n4R ^ (1 / 2 : ℝ) := by
    rw [show (-1 / 2 : ℝ) = -(1 / 2 : ℝ) by norm_num,
        Real.rpow_neg (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht))) (1 / 2 : ℝ),
        ← one_div (n4R ^ (1 / 2 : ℝ))]
  rw [h1, h2]
  exact mul_le_mul_of_nonneg_left hin (by norm_num : 0 ≤ (1 / 2 : ℝ))

/-  S8.12  T2  AT  THE  SQUARE-ROOT  SCHEDULE  (sigma  <=  1/2):
    the  left  norm  is  the  smaller  one,  and  the  exponent
    (sigma+1)/(2sigma)  >=  3/2.  -/
theorem t4l_wall_T2 (t d0 sigma : ℝ) (ht : 1000 ≤ t)
    (hd : 0 ≤ d0) (hdh : d0 ≤ (1 / 2 : ℝ))
    (hsp : 0 < sigma) (hsig : sigma ≤ (1 / 2 : ℝ))
    (n : ℕ) (hn : (n : ℝ) ≥ t4l_schedB t sigma) :
    (‖t4l_sOffL t d0‖ / 12) * (n : ℝ) ^ (-sigma - 1) ≤
      (‖t4o_sOn t‖ / 12) * (S4Strip.n4 t : ℝ) ^ (-3 / 2 : ℝ) := by
  let n4R : ℝ := (S4Strip.n4 t : ℝ)
  have hA : (n : ℝ) ^ (sigma + 1) ≥ n4R ^ ((sigma + 1) / (2 * sigma)) :=
    t4l_sched_pow t sigma ht hsp (sigma + 1) (by linarith [hsp]) n hn
  have hnB : 0 < t4l_schedB t sigma := t4l_schedB_pos t sigma ht hsp
  have hnpos : 0 < (n : ℝ) := by linarith [hn, hnB]
  have hns : 0 < (n : ℝ) ^ (sigma + 1) :=
    Real.rpow_pos_of_pos hnpos (sigma + 1)
  have hBp : 0 < n4R ^ ((sigma + 1) / (2 * sigma)) :=
    Real.rpow_pos_of_pos (Nat.cast_pos.mpr (t4o_n4pos t ht))
      ((sigma + 1) / (2 * sigma))
  have hin : (1 : ℝ) / (n : ℝ) ^ (sigma + 1) ≤
      (1 : ℝ) / n4R ^ ((sigma + 1) / (2 * sigma)) :=
    (one_div_le_one_div hns hBp).mpr hA
  have h1 : (n : ℝ) ^ (-sigma - 1) = (1 : ℝ) / (n : ℝ) ^ (sigma + 1) := by
    rw [show (-sigma - 1 : ℝ) = -((sigma + 1) : ℝ) by ring,
        Real.rpow_neg (le_of_lt hnpos) (sigma + 1),
        ← one_div ((n : ℝ) ^ (sigma + 1))]
  have h2 : (n4R : ℝ) ^ (-((sigma + 1) / (2 * sigma))) =
      (1 : ℝ) / n4R ^ ((sigma + 1) / (2 * sigma)) := by
    rw [Real.rpow_neg (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht)))
        ((sigma + 1) / (2 * sigma)),
        ← one_div (n4R ^ ((sigma + 1) / (2 * sigma)))]
  have hexp : -((sigma + 1) / (2 * sigma)) ≤ (-3 / 2 : ℝ) := by
    have hge : (3 : ℝ) / 2 ≤ (sigma + 1) / (2 * sigma) := by
      rw [div_le_div_iff₀ (by norm_num : 0 < (2 : ℝ))
          (by linarith [hsp] : 0 < (2 : ℝ) * sigma)]
      nlinarith [hsig]
    linarith [hge]
  have hn4 : 1 ≤ n4R := by
    dsimp only [n4R]
    have hfloor : n4R ≥ 31000000 * t ^ 4 := t4o_n4floor t ht
    have h4 : (1 : ℝ) ^ 4 ≤ t ^ 4 := by
      gcongr
      <;> linarith [ht]
    have h4b : 31000000 * (1 : ℝ) ^ 4 ≤ 31000000 * t ^ 4 :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    norm_num at h4b
    nlinarith [hfloor, h4b]
  have himp : (n4R : ℝ) ^ (-((sigma + 1) / (2 * sigma))) ≤
      (n4R : ℝ) ^ (-3 / 2 : ℝ) := by
    exact Real.rpow_le_rpow_of_exponent_le hn4 hexp
  calc (‖t4l_sOffL t d0‖ / 12) * (n : ℝ) ^ (-sigma - 1)
      = (‖t4l_sOffL t d0‖ / 12) * ((1 : ℝ) / (n : ℝ) ^ (sigma + 1)) := by
        rw [h1]
    _ ≤ (‖t4l_sOffL t d0‖ / 12) *
          (n4R : ℝ) ^ (-((sigma + 1) / (2 * sigma))) := by
        rw [h2]
        exact mul_le_mul_of_nonneg_left hin
          (by positivity : 0 ≤ ‖t4l_sOffL t d0‖ / 12)
    _ ≤ (‖t4l_sOffL t d0‖ / 12) * (n4R : ℝ) ^ (-3 / 2 : ℝ) := by
      exact mul_le_mul_of_nonneg_left himp
        (by positivity : 0 ≤ ‖t4l_sOffL t d0‖ / 12)
    _ ≤ (‖t4o_sOn t‖ / 12) * (n4R : ℝ) ^ (-3 / 2 : ℝ) := by
      have hdiv12 : ‖t4l_sOffL t d0‖ / 12 ≤ ‖t4o_sOn t‖ / 12 := by
        rw [div_le_div_iff₀ (by norm_num : 0 < (12 : ℝ))
            (by norm_num : 0 < (12 : ℝ))]
        nlinarith [t4l_wall_norm1 t d0 hd hdh]
      exact mul_le_mul_of_nonneg_right hdiv12
        (Real.rpow_nonneg (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht)))
          (-3 / 2 : ℝ))

/-  S8.13  T3  AT  THE  SQUARE-ROOT  SCHEDULE  (band  edge
    sigma  <=  99/200,  d0  <  1/2):  the  termwise  norm  win
    plus  the  power  margin  (S8.10)  against  the  coefficient.
    -/
theorem t4l_wall_T3 (t d0 sigma : ℝ) (ht : 1000 ≤ t)
    (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ))
    (hsp : 0 < sigma) (hsig99 : sigma ≤ (99 / 200 : ℝ))
    (n : ℕ) (hn : (n : ℝ) ≥ t4l_schedB t sigma) :
    (Real.sqrt 3 / 216) *
        ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ *
        (n : ℝ) ^ (-(sigma + 2)) / (sigma + 2) ≤
      (Real.sqrt 3 / 540) *
        ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
        (S4Strip.n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
  let n4R : ℝ := (S4Strip.n4 t : ℝ)
  have hA : (n : ℝ) ^ (sigma + 2) ≥ n4R ^ ((sigma + 2) / (2 * sigma)) :=
    t4l_sched_pow t sigma ht hsp (sigma + 2) (by linarith [hsp]) n hn
  have hnB : 0 < t4l_schedB t sigma := t4l_schedB_pos t sigma ht hsp
  have hnpos : 0 < (n : ℝ) := by linarith [hn, hnB]
  have hns : 0 < (n : ℝ) ^ (sigma + 2) :=
    Real.rpow_pos_of_pos hnpos (sigma + 2)
  have hBp : 0 < n4R ^ ((sigma + 2) / (2 * sigma)) :=
    Real.rpow_pos_of_pos (Nat.cast_pos.mpr (t4o_n4pos t ht))
      ((sigma + 2) / (2 * sigma))
  have hin : (1 : ℝ) / (n : ℝ) ^ (sigma + 2) ≤
      (1 : ℝ) / n4R ^ ((sigma + 2) / (2 * sigma)) :=
    (one_div_le_one_div hns hBp).mpr hA
  have h1 : (n : ℝ) ^ (-(sigma + 2)) = (1 : ℝ) / (n : ℝ) ^ (sigma + 2) := by
    rw [show (-(sigma + 2) : ℝ) = -((sigma + 2) : ℝ) by ring,
        Real.rpow_neg (le_of_lt hnpos) (sigma + 2),
        ← one_div ((n : ℝ) ^ (sigma + 2))]
  have h2 : (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) =
      (1 : ℝ) / n4R ^ ((sigma + 2) / (2 * sigma)) := by
    rw [Real.rpow_neg (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht)))
        ((sigma + 2) / (2 * sigma)),
        ← one_div (n4R ^ ((sigma + 2) / (2 * sigma)))]
  have hpowl : (n : ℝ) ^ (-(sigma + 2)) ≤
      (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) := by
    calc (n : ℝ) ^ (-(sigma + 2)) = (1 : ℝ) / (n : ℝ) ^ (sigma + 2) := h1
      _ ≤ (1 : ℝ) / n4R ^ ((sigma + 2) / (2 * sigma)) := hin
      _ = (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) := h2.symm
  have hnorm : ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) *
        (t4l_sOffL t d0 + 2)‖ ≤
      ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ :=
    t4l_wall_norm_prod t d0 (by linarith [hdlow]) (by linarith [hdhigh])
  have hmargin : n4R ^ ((1 - 2 * sigma) / sigma) ≥
      5 / (2 * (sigma + 2)) :=
    t4l_T3margin t sigma ht hsp hsig99
  have hexp : -((sigma + 2) / (2 * sigma)) + ((1 - 2 * sigma) / sigma) =
      (-5 / 2 : ℝ) := by
    field_simp [hsp]
    ring
  have hP : 0 ≤ (Real.sqrt 3 / 216 : ℝ) *
      ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ := by
    apply mul_nonneg
    · positivity
    · positivity
  have hQ : 0 ≤ (Real.sqrt 3 / 540 : ℝ) *
      ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
        (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) := by
    apply mul_nonneg
    · apply mul_nonneg
      · positivity
      · positivity
    · exact Real.rpow_nonneg
        (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht)))
        (-((sigma + 2) / (2 * sigma)))
  have hT3c : (Real.sqrt 3 / 216) *
        ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
        (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) / (sigma + 2) ≤
      (Real.sqrt 3 / 540) *
        ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
        (n4R : ℝ) ^ (-5 / 2 : ℝ) := by
    calc (Real.sqrt 3 / 216) *
            ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) / (sigma + 2)
        = (Real.sqrt 3 / 540) *
            ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) *
            (5 / (2 * (sigma + 2))) := by
          ring_nf
          <;> field_simp [show (sigma + 2 : ℝ) ≠ 0 from by linarith [hsp]]
          <;> ring_nf
      _ ≤ (Real.sqrt 3 / 540) *
            ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) *
            (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) :=
        mul_le_mul_of_nonneg_left hmargin hQ
      _ = (Real.sqrt 3 / 540) *
            ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
            (n4R : ℝ) ^ (-5 / 2 : ℝ) := by
        let Qn := ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖
        have hrpow : (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) *
            (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) =
            (n4R : ℝ) ^ (-5 / 2 : ℝ) := by
          rw [← Real.rpow_add (Nat.cast_pos.mpr (t4o_n4pos t ht))
              (-((sigma + 2) / (2 * sigma)))
              ((1 - 2 * sigma) / sigma)]
          rw [hexp]
        have hreg : (Real.sqrt 3 / 540 : ℝ) * Qn *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) *
            (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma) =
            (Real.sqrt 3 / 540 : ℝ) * Qn *
            ((n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) *
              (n4R : ℝ) ^ ((1 - 2 * sigma) / sigma)) := by ring
        rw [hreg, hrpow]
  calc (Real.sqrt 3 / 216) *
          ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ *
          (n : ℝ) ^ (-(sigma + 2)) / (sigma + 2)
      ≤ (Real.sqrt 3 / 216) *
          ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ *
          (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) / (sigma + 2) := by
        have hpre : (Real.sqrt 3 / 216) *
            ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) *
              (t4l_sOffL t d0 + 2)‖ *
            (n : ℝ) ^ (-(sigma + 2)) ≤
            (Real.sqrt 3 / 216) *
            ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) *
              (t4l_sOffL t d0 + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) :=
          mul_le_mul_of_nonneg_left hpowl hP
        apply (div_le_div_iff₀ (by linarith [hsp] : 0 < sigma + 2)
            (by linarith [hsp] : 0 < sigma + 2)).mpr
        exact mul_le_mul_of_nonneg_right hpre
          (by linarith [hsp] : 0 ≤ sigma + 2)
    _ ≤ (Real.sqrt 3 / 216) *
          ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
          (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) / (sigma + 2) := by
        have hpre : (Real.sqrt 3 / 216) *
            ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) *
              (t4l_sOffL t d0 + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) ≤
            (Real.sqrt 3 / 216) *
            ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
            (n4R : ℝ) ^ (-((sigma + 2) / (2 * sigma))) :=
          mul_le_mul_of_nonneg_right
            (mul_le_mul_of_nonneg_left hnorm
              (by positivity : 0 ≤ (Real.sqrt 3 / 216 : ℝ)))
            (Real.rpow_nonneg
              (le_of_lt (Nat.cast_pos.mpr (t4o_n4pos t ht)))
              (-((sigma + 2) / (2 * sigma))))
        apply (div_le_div_iff₀ (by linarith [hsp] : 0 < sigma + 2)
            (by linarith [hsp] : 0 < sigma + 2)).mpr
        exact mul_le_mul_of_nonneg_right hpre
          (by linarith [hsp] : 0 ≤ sigma + 2)
    _ ≤ (Real.sqrt 3 / 540) *
          ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
          (S4Strip.n4 t : ℝ) ^ (-5 / 2 : ℝ) :=
      by simpa only [n4R] using hT3c

/-  S8.14  THE  MAIN  LEFT  WALL:  at  the  square-root  schedule,
    the  T4  tail  at  the  left  point  is  bounded  IN  BODY  by
    the  on-line  p8  floor  at  n4  -  the  mirror  of
    t4wall_offline_le_bwires  (T4OffD)  on  the  left  flank.
    -/
theorem t4l_wall_tuned (t d0 : ℝ) (n : ℕ) (ht : 1000 ≤ t)
    (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ))
    (hsched : (n : ℝ) ≥ t4l_schedB t (1 / 2 - d0)) :
    ‖p4_em_expr (t4l_sOffL t d0) n‖ ≤ p8_B t (S4Strip.n4 t) := by
  have hsp : 0 < 1 / 2 - d0 := by linarith [hdhigh]
  have hd0 : 0 ≤ d0 := by linarith [hdlow]
  have hsig : 1 / 2 - d0 ≤ (1 / 2 : ℝ) := by linarith [hdlow]
  have hsig99 : 1 / 2 - d0 ≤ (99 / 200 : ℝ) := by linarith [hdlow]
  have hre : (t4l_sOffL t d0).re = 1 / 2 - d0 := by
    dsimp only [t4l_sOffL]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.I_im, Complex.ofReal_im,
      mul_zero, zero_mul]
    ring
  have hsre : -1 < (t4l_sOffL t d0).re := by
    rw [hre]
    linarith [hdhigh]
  have hnn : 0 < n :=
    Nat.cast_pos.mp (lt_of_lt_of_le
      (t4l_schedB_pos t (1 / 2 - d0) ht hsp) hsched)
  have hwall := p4_T4_bound_gen (s := t4l_sOffL t d0) hsre hnn
  have hT1 := t4l_wall_T1 t d0 ht hsp n hsched
  have hT2 := t4l_wall_T2 t d0 (1 / 2 - d0) ht hd0 (le_of_lt hdhigh)
    hsp hsig n hsched
  have hT3 := t4l_wall_T3 t d0 (1 / 2 - d0) ht hdlow hdhigh hsp
    hsig99 n hsched
  calc ‖p4_em_expr (t4l_sOffL t d0) n‖
      ≤ (1 / 2) * (n : ℝ) ^ (-(1 / 2 - d0)) +
            (‖t4l_sOffL t d0‖ / 12) * (n : ℝ) ^ (-(1 / 2 - d0) - 1) +
            (Real.sqrt 3 / 216) *
              ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) *
                (t4l_sOffL t d0 + 2)‖ *
              (n : ℝ) ^ (-((1 / 2 - d0) + 2)) / ((1 / 2 - d0) + 2) := by
        rw [hre] at hwall
        simpa using hwall
    _ ≤ (1 / 2) * (S4Strip.n4 t : ℝ) ^ (-1 / 2 : ℝ) +
            (‖t4o_sOn t‖ / 12) * (S4Strip.n4 t : ℝ) ^ (-3 / 2 : ℝ) +
            (Real.sqrt 3 / 540) *
              ‖t4o_sOn t * (t4o_sOn t + 1) * (t4o_sOn t + 2)‖ *
              (S4Strip.n4 t : ℝ) ^ (-5 / 2 : ℝ) := by
        ring_nf at hT1 hT2 hT3 ⊢
        linarith [hT1, hT2, hT3]
    _ = p8_B t (S4Strip.n4 t) := by
      dsimp only [p8_B, t4o_sOn]

/-  S8.15  COMPOSITION  INTO  THE  ENDPOINT  FACE  (G-hs3-left):
    with  Qside  :=  the  T4  tail  at  the  left  point  at  any
    schedule  at  or  above  the  square-root  schedule,
        Qside  (t0,  d0)  <=  S4A.BwireR  t0  d0  +  t4m_MwireOff
    t0  d0
    on  the  band  (1000  <=  t0,  1/200  <=  d0  <  1/2):  the
    BwireR  branch  at  the  band  IS  p8_B  (the  Z78P12
    identity),  and  the  Mr  term  is  nonnegative.  THE  S3
    LEFT  LEG  IS  NOW  A  BODY  STATEMENT.  -/

/-- S8.15a X4fun is strictly positive on the band. -/
theorem t4l_X4fun_pos (t : ℝ) (ht : 1000 ≤ t) : 0 < S4Strip.X4fun t := by
  have ht0 : 0 < t := by linarith [ht]
  have h1000p6 : (1000 : ℝ) ^ 6 ≤ t ^ 6 := by
    gcongr
    <;> linarith [ht]
  have ht6s : (1 : ℝ) < t ^ 6 := by
    linarith [h1000p6, (by norm_num : (1 : ℝ) < (1000 : ℝ) ^ 6)]
  have ht8 : t ^ 2 < t ^ 8 := by
    have hpos : 0 < t ^ 6 - 1 := by linarith [ht6s]
    have hstep : 0 < t ^ 2 * (t ^ 6 - 1) :=
      mul_pos (by positivity : 0 < t ^ 2) hpos
    have heq : t ^ 2 * (t ^ 6 - 1) = t ^ 8 - t ^ 2 := by ring
    have hdiff : 0 < t ^ 8 - t ^ 2 := by
      rw [← heq]
      exact hstep
    linarith [hdiff]
  have hG : t ^ 2 < S4Strip.G4 t * S4Strip.G4 t := by
    dsimp only [S4Strip.G4]
    have hc2 : t ^ 8 ≤ (62000000 : ℝ) ^ 2 * t ^ 8 := by
      have hraw : 1 * t ^ 8 ≤ (62000000 : ℝ) ^ 2 * t ^ 8 :=
        mul_le_mul_of_nonneg_right
          (by norm_num : (1 : ℝ) ≤ (62000000 : ℝ) ^ 2)
          (by positivity : 0 ≤ t ^ 8)
      simpa using hraw
    calc t ^ 2 < t ^ 8 := ht8
      _ ≤ (62000000 : ℝ) ^ 2 * t ^ 8 := hc2
      _ = 62000000 * t ^ 4 * (62000000 * t ^ 4) := by ring
  have hGpos : 0 < S4Strip.G4 t := S4Strip.st_G4pos t ht
  have hu : 0 < S4Strip.G4 t * S4Strip.G4 t + 1 / 4 := by
    positivity
  have hw : 0 < w t := by
    dsimp only [w]
    nlinarith [show (0 : ℝ) < t from by linarith [ht]]
  have hBf : 0 < Bf t (S4Strip.G4 t) := by
    dsimp only [Bf]
    have hwu : w t < S4Strip.G4 t * S4Strip.G4 t + 1 / 4 := by
      dsimp only [w]
      linarith [hG]
    have h1 : 0 < 1 / (2 * (S4Strip.G4 t * S4Strip.G4 t + 1 / 4)) :=
      div_pos (by norm_num : 0 < (1 : ℝ))
        (by positivity : 0 < 2 * (S4Strip.G4 t * S4Strip.G4 t + 1 / 4))
    have h2 : 0 < (w t / (S4Strip.G4 t * S4Strip.G4 t + 1 / 4)) /
        (1 - w t / (S4Strip.G4 t * S4Strip.G4 t + 1 / 4)) := by
      apply div_pos
      · exact div_pos hw hu
      · rw [sub_pos, div_lt_one hu]
        exact hwu
    have h3 : 0 < t / (S4Strip.G4 t * S4Strip.G4 t + 1 / 4) :=
      div_pos (by linarith [ht] : 0 < t) hu
    linarith [h1, h2, h3]
  have hBg1 : (1 : ℝ) < S4Strip.B4 t := by
    dsimp only [S4Strip.B4]
    have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 := by
      gcongr
      <;> linarith [ht]
    have ht4b : 124000000 * (1 : ℝ) ^ 4 ≤ 124000000 * t ^ 4 :=
      mul_le_mul_of_nonneg_left ht4 (by norm_num)
    nlinarith [show (0 : ℝ) ≤ 124000000 * t ^ 4 from by positivity, ht4b]
  have hS1 : 0 < Sbar (S4Strip.B4 t) := by
    dsimp only [Sbar]
    have hlg : 0 < Real.log (S4Strip.B4 t) := Real.log_pos hBg1
    have hlg1 : (1 : ℝ) < Real.log (S4Strip.B4 t) := by
      have hl6 : (6 : ℝ) < Real.log t := S4Strip.st_L6 t ht
      have hlp : 0 < Real.log 124000000 :=
        Real.log_pos (by norm_num : (1 : ℝ) < 124000000)
      have heq : Real.log (S4Strip.B4 t) =
          Real.log 124000000 + 4 * Real.log t := by
        dsimp only [S4Strip.B4]
        rw [Real.log_mul (by norm_num : (124000000 : ℝ) ≠ 0)
            (pow_pos ht0 4).ne', Real.log_pow t 4]
        ring
      nlinarith [heq, hl6, hlp]
    have hllg : 0 < Real.log (Real.log (S4Strip.B4 t)) :=
      Real.log_pos hlg1
    have hc : (0 : ℝ) < 2.290 := by norm_num
    linarith [hlg, hllg, hc]
  have hS2 : 0 < Sbar (S4Strip.G4 t) := by
    dsimp only [Sbar]
    have hg1 : (1 : ℝ) < S4Strip.G4 t := by
      dsimp only [S4Strip.G4]
      have ht4 : (1 : ℝ) ^ 4 ≤ t ^ 4 := by
        gcongr
        <;> linarith [ht]
      nlinarith [ht4, show (1 : ℝ) ≤ 62000000 from by norm_num]
    have hlg : 0 < Real.log (S4Strip.G4 t) := Real.log_pos hg1
    have hlg1 : (1 : ℝ) < Real.log (S4Strip.G4 t) := by
      have hl6 : (6 : ℝ) < Real.log t := S4Strip.st_L6 t ht
      have hlp : 0 < Real.log 62000000 :=
        Real.log_pos (by norm_num : (1 : ℝ) < 62000000)
      have heq : Real.log (S4Strip.G4 t) =
          Real.log 62000000 + 4 * Real.log t := by
        dsimp only [S4Strip.G4]
        rw [Real.log_mul (by norm_num : (62000000 : ℝ) ≠ 0)
            (pow_pos ht0 4).ne', Real.log_pow t 4]
        ring
      nlinarith [heq, hl6, hlp]
    have hllg : 0 < Real.log (Real.log (S4Strip.G4 t)) :=
      Real.log_pos hlg1
    have hc : (0 : ℝ) < 2.290 := by norm_num
    linarith [hlg, hllg, hc]
  have hCf : 0 < Cf t (S4Strip.G4 t) := by
    dsimp only [Cf]
    have hden : 0 < S4Strip.G4 t * S4Strip.G4 t - t * t := by
      have hgpos : 0 < S4Strip.G4 t * S4Strip.G4 t := by positivity
      nlinarith [hG]
    have hextra : 0 < 2 * w t * (S4Strip.G4 t * S4Strip.G4 t) /
        (S4Strip.G4 t * S4Strip.G4 t - t * t) := by
      apply div_pos
      · positivity
      · exact hden
    linarith [hextra]
  have hK : 0 < Kbar (S4Strip.G4 t) := S4Strip.st_Kbarpos t ht
  dsimp only [S4Strip.X4fun]
  have hp1 : 0 < Bf t (S4Strip.G4 t) * (Sbar (S4Strip.B4 t) +
      Sbar (S4Strip.G4 t)) :=
    mul_pos hBf (add_pos hS1 hS2)
  have hp2 : 0 < Cf t (S4Strip.G4 t) * Kbar (S4Strip.G4 t) :=
    mul_pos hCf hK
  apply add_pos
  · exact hp1
  · exact hp2

theorem t4l_face_left_body (t d0 : ℝ) (n : ℕ) (ht : 1000 ≤ t)
    (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ))
    (hsched : (n : ℝ) ≥ t4l_schedB t (1 / 2 - d0)) :
    ‖p4_em_expr (t4l_sOffL t d0) n‖ ≤
      S4A.BwireR t d0 + t4m_MwireOff t d0 := by
  have hwall : ‖p4_em_expr (t4l_sOffL t d0) n‖ ≤
      p8_B t (S4Strip.n4 t) :=
    t4l_wall_tuned t d0 n ht hdlow hdhigh hsched
  have hB : S4A.BwireR t d0 = p8_B t (S4Strip.n4 t) := by
    dsimp only [S4A.BwireR]
    rw [if_pos (⟨ht, le_of_lt hdhigh⟩ : 1000 ≤ t ∧ d0 ≤ (1 / 2 : ℝ))]
    rw [if_pos hdlow]
  rw [hB]
  have hpos : 0 ≤ t4m_MwireOff t d0 := by
    dsimp only [t4m_MwireOff, t4m_ZboundOff]
    have hz : 0 < t4m_ZboundOff t d0 := by
      dsimp only [t4m_ZboundOff]
      have hlog : 0 < Real.log t := Real.log_pos (by linarith [ht])
      positivity
    have hX4 : 0 < S4Strip.X4fun t := t4l_X4fun_pos t ht
    have hexp : 0 < Real.exp (S4Strip.X4fun t) :=
      Real.exp_pos (S4Strip.X4fun t)
    positivity
  linarith [hwall, hpos]

/-  S8.16  THE  ENDPOINT  SHADOW:  for  EVERY  band  off-pair  at
    or  above  t0  =  10^10,  some  schedule  at  or  above  the
    square-root  schedule  exists  at  that  point  and  the  wall
    holds  for  it  -  the  S3  left  leg  is  dischargeable  for
    all  such  witnesses  simultaneously  (the  sigma  =  0  slice
    is  excluded  by  the  hypothesis  d0  <  1/2).  No  RH
    claim:  this  is  a  statement  about  EXPLICIT  functions.
    -/
theorem t4l_face_left_band (t0 d0 : ℝ)
    (ht0 : (10 : ℝ) ^ (10 : ℕ) ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ)) :
    ∃ n : ℕ, (n : ℝ) ≥ t4l_schedB t0 (1 / 2 - d0) ∧
      ‖p4_em_expr (t4l_sOffL t0 d0) n‖ ≤
        S4A.BwireR t0 d0 + t4m_MwireOff t0 d0 := by
  have h1000 : (1000 : ℝ) ≤ t0 :=
    le_trans (by norm_num : (1000 : ℝ) ≤ (10 : ℝ) ^ (10 : ℕ)) ht0
  let nstar := Nat.ceil (t4l_schedB t0 (1 / 2 - d0))
  have hnsched : (nstar : ℝ) ≥ t4l_schedB t0 (1 / 2 - d0) :=
    Nat.le_ceil (t4l_schedB t0 (1 / 2 - d0))
  exact ⟨nstar, hnsched,
    t4l_face_left_body t0 d0 nstar h1000 hdlo hdhigh hnsched⟩
