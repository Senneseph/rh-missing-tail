/- T4OffLE  --  Q2  THE  DECOUPLED-RUN  S1  MARGIN  (discovery
   0257/0258;  day060/0257  bracket  +  day061  in-body  pin
   measurement)  -  OFF-BOARD  POSITIVE-DUAL  MARGIN  RECORD  (the
   T4OffLC/T4OffLD  class).  No  RH  claim:  the  record  narrows
   the  hOffCPT2  support  face  -  the  S1  side  of  the  terminal
   squeeze  becomes  a  BODY  fact  at  the  DECOUPLED  fill  run
   (the  lower  EM  floor  at  the  fill  run  n_off  plus  the  upper
   EM  wall  at  the  wire  run  n_on  (>=  schedB,  T4OffL
   t4l_wall_tuned)  were  ALWAYS  at  DIFFERENT  runs  -  the
   0252/0257  content  is  that  the  lower  floor  CARRIES  the
   pair  with  a  uniform  factor-2  margin  on  the  whole  band,
   where  the  single-C  5001  family  (058e)  CANNOT  (the  knife
   edge,  wall_lo/own  =  0.9998  <  1  at  the  band  edge)).

   MEASURED  CONTENT  (day061,  dps  60,  closed  forms  +  the
   pinned  0252  zero-set  maps  only  -  no  zeta  evaluation,  no
   zero-set  data  beyond  the  pinned  straddle/own  maps):

   (1)  on  the  band  grid  (t  in  {1e3, 1e6,  1e8,  tPT2,  1e16,
       1e18,  1e20}  x  d0  in  17  stations  1/200..0.3733819666132,
       119  points)  plus  the  d0  ->  1/2  corner  (d0  =  0.4,
       0.45,  0.49,  0.499,  0.4999,  0.49999  at  t  =  1e6..1e16):

           wall_lo  (N_off)  /  ||poff  t  d0  t||  =  2.000000
           (worst  1.999999  at  t  =  1000,  d0  =  1/200  -  the
           knife-edge  asymptote,  t-flat  to  1e-5,  rising  to
           1.999986  as  d0  ->  1/2),

       where  N_off  is  the  DECOUPLED  fill  run  (S3)  at
       C_off  =  C*/2  with  C*  (d0)  =  1  /(8  d0^2)  the
       knife-edge  scale  (0252/0257),  and  the  coarse  in-body
       ceiling  pin  (N  <=  2  nIdeal  loss,  exact  T2/T3  at  the
       ideal  run)  is  >=  1.419123  at  every  point  (worst  at
       t  =  1000,  d0  =  1/200).

   (2)  THE  SAME  POINT  AT  THE  SINGLE-C  5001  RUN  (the  058e
       pin  family):  wall_lo  /  own  falls  from  0.9998  at  the
       band  edge  to  1.79e-4  at  d0  =  0.3733819666132  -  the
       0252  knife  edge  in  one  number:  the  single-C  schedule
       CANNOT  carry  the  S1  side  of  the  squeeze;  the
       decoupled  run  carries  it  with  a  factor-2  margin  on
       the  whole  band.

   (3)  THE  SQUEEZE  (S5,  in  body):  on  the  band  (t  >=
       1000,  1/200  <=  d0  <=  1/2)  the  body  holds
       floStripMin  =  the  own  mass  (S1LowT
       floStripMin_eq_mownOnBand)  and  BwireR  +  MrR  +  MfR  <
       floStripMin  (FloorUnif  s4StripUnifiedFloor).  Hence  at
       the  decoupled  run,  GIVEN  the  CITED  A2c  bridge  (the
       fill  equals  the  EM  kernel  norm  at  the  run,  DLMF
       25.2.8  /  Apostol  12.21  continuation  -  the  same
       provenance  class  as  the  machined  hs3  cited  mass)  and
       the  NAMED  S3  FACE  (the  fill  at  or  below  BwireR  +
       MrR,  the  endpoint's  hs3  at  the  pair),  the  off-pair
       is  EXCLUDED  IN  BODY:

           fill  >=  wall_lo  (N_off)  >  own  =  floStripMin  >
           BwireR  +  MrR  >=  fill.

       The  last  strict  step  (wall_lo  >  own)  is  the  measured
       pin  (1);  its  in-body  worst-point  norm_num  pin  is  the
       NAMED  FACE  T4OffLE.pin  (next  fire).

   The  terminal  endpoint  is  NOT  re-wired  here.  No  RH
   claim.  -/
import  Mathlib
import  RhAttack.P4Limit
import  RhAttack.S4Strip
import  RhAttack.S1LowT
import  RhAttack.S4Own
import  RhAttack.FloorUnif
import  RhAttack.WinCount
import  RhAttack.T4OffD
import  RhAttack.S4Asm
import  RhAttack.T4OffM
import  RhAttack.T4OffL
import  RhAttack.Closure

open  Real

noncomputable  section

namespace  T4OffLE

/-  =================================================================
   S1  THE  EM  KERNEL  FLOOR  (the  mirror  of  p4_T4_bound_gen)
   =================================================================
   The  wall  (T4Off.p4_T4_bound_gen)  proves  ||em(s,  n)||  at  or
   below  T1  +  T2  +  T3  via  the  decomposition  em  =  t1  +  t2
   -  tk  with  explicit  term  bounds.  The  FLOOR  is  the  reverse
   triangle  on  the  SAME  decomposition:

       ||em||  =  ||t1  -  (tk  -  t2)||
                >=  ||t1||  -  ||tk  -  t2||
                >=  ||t1||  -  ||tk||  -  ||t2||  =  T1  -  T2  -  T3,

   with  ||t1||  EXACT  (not  <=):  ||-1/2  n^-s||  =  (1/2)
   n^-s.re.  THE  RUN  n  IS  A  FREE  PARAMETER  (n  >=  1):  this
   is  the  decoupling  itself  -  the  upper  S3  wall
   (T4OffL.t4l_wall_tuned)  holds  over  all  runs  at  or  above
   the  square-root  schedule,  the  lower  floor  holds  at  all
   runs:  the  two  sides  of  the  squeeze  live  at  different
   runs  -  in  body.  -/

/-- S  S1.1  THE  IN-BODY  EM  KERNEL  FLOOR,  at  every  s  with
    -1  <  s.re  and  every  run  n  >=  1:  the  kernel  norm  is
    at  or  above  the  3-term  floor  (T1  -  T2  -  T3)  with  the
    SAME  closed  terms  as  the  wall.  Pure  composition  over  the
    wall  lemma's  decomposition;  no  measurement,  no  zero,  no  RH
    claim. -/
theorem t4LE_emFloor {s : ℂ} (hsre : -1 < s.re) (n : ℕ) (hn : 0 < n) :
    ‖p4_em_expr s n‖ ≥
      (1 / 2 : ℝ) * (n : ℝ) ^ (-s.re) -
      (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) -
      (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
        ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
  set t1 := -((1 / 2) : ℂ) * (n : ℂ) ^ (-s) with ht1
  set t2 := ((1 / 12) : ℂ) * (s * (n : ℂ) ^ (-s - 1)) with ht2
  set tk := ((1 / 2) : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x) with htk
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.mpr hn
  have hEm : p4_em_expr s n = t1 + t2 - tk := by
    dsimp only [t1, t2, tk, p4_em_expr]
  have hbase : (n : ℂ) = ((n : ℝ) : ℂ) := by
    norm_cast
  -- ||t1||  EXACT:  (1/2)  n^-s.re.
  have hnorm1 : ‖(n : ℂ) ^ (-s)‖ = (n : ℝ) ^ (-s.re) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s)]
    simp [Complex.neg_re]
  have ht1n : ‖t1‖ = (1 / 2 : ℝ) * (n : ℝ) ^ (-s.re) := by
    dsimp only [t1]
    rw [norm_mul, norm_neg, hnorm1]
    rw [show (‖((1 / 2) : ℂ)‖ : ℝ) = 1 / 2 by norm_num]
  -- ||t2||  =  (||s||/12)  n^(-s.re-1)  (EXACT).
  have hnorm2 : ‖(n : ℂ) ^ (-s - 1)‖ = (n : ℝ) ^ (-s.re - 1) := by
    rw [hbase, Complex.norm_cpow_eq_rpow_re_of_pos hnR (-s - 1)]
    simp only [Complex.sub_re, Complex.neg_re]
    norm_num
  have ht2n : ‖t2‖ = (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) := by
    dsimp only [t2]
    rw [norm_mul, norm_mul, hnorm2]
    rw [show (‖((1 / 12) : ℂ)‖ : ℝ) = 1 / 12 by norm_num]
    ring
  -- ||tk||  <=  the  wall's  T3  term  (the  identical  tail  bound).
  have hK : ‖tk‖ ≤ (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
      ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
    dsimp only [tk]
    calc ‖(1 / 2 : ℂ) * (∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x)‖
        = (1 / 2 : ℝ) * ‖∫ x : ℝ in Set.Ioi (n : ℝ), (B2 x : ℂ) * p4_f2 s x‖ := by
          rw [norm_mul]
          norm_num
      _ ≤ (1 / 2) * (Real.sqrt 3 / 108 * ‖s * (s + 1)‖ * ‖s + 2‖ *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2)) :=
          mul_le_mul_of_nonneg_left (p4_f2_tail_bound_gen hsre n hn) (by norm_num)
      _ = (Real.sqrt 3 / 216) * (‖s‖ * ‖s + 1‖ * ‖s + 2‖) *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
          rw [norm_mul]
          ring
      _ = (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
          rw [← norm_mul, ← norm_mul]
  -- The  reverse-triangle  chain
  --  ||em||  =  ||t1  -  (tk  -  t2)||
  --    >=  ||t1||  -  ||tk  -  t2||
  --    >=  ||t1||  -  ||tk||  -  ||t2||.
  --  THE  REVERSE  TRIANGLE  via  the  forward  triangle  on
  --  (t1  -  (tk  -  t2))  +  (tk  -  t2)  =  t1:
  --  ||t1||  <=  ||t1  -  (tk  -  t2)||  +  ||tk  -  t2||
  --  =>  ||t1||  -  ||tk  -  t2||  <=  ||t1  -  (tk  -  t2)||.
  have hrev : ‖t1‖ - ‖tk - t2‖ ≤ ‖t1 - (tk - t2)‖ := by
    have h := norm_add_le (t1 - (tk - t2)) (tk - t2)
    have h1 : ‖t1‖ ≤ ‖t1 - (tk - t2)‖ + ‖tk - t2‖ := by
      simpa [sub_add_cancel] using h
    linarith
  have hsK : 0 ≤ ‖tk‖ := norm_nonneg tk
  calc ‖p4_em_expr s n‖ = ‖t1 + t2 - tk‖ := by rw [hEm]
    _ = ‖t1 - (tk - t2)‖ := by
        rw [show t1 + t2 - tk = t1 - (tk - t2) by
          calc t1 + t2 - tk
              = t1 + (t2 - tk) := by rw [add_sub]
            _ = t1 - (tk - t2) := by
              have hsub : t2 - tk = -(tk - t2) := by rw [neg_sub]
              rw [hsub, sub_eq_add_neg (a := t1) (b := tk - t2)]]
    _ ≥ ‖t1‖ - ‖tk - t2‖ := hrev
    _ ≥ ‖t1‖ - ‖tk‖ - ‖t2‖ := by
        have htri : ‖tk - t2‖ ≤ ‖tk‖ + ‖t2‖ := by
          simpa [sub_eq_add_neg, norm_neg t2] using norm_add_le tk (-t2)
        have hsub := sub_le_sub_left htri ‖t1‖
        simpa [sub_sub] using hsub
    _ = (1 / 2 : ℝ) * (n : ℝ) ^ (-s.re) -
          (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) - ‖tk‖ := by
        rw [ht1n, ht2n]
        ring
    _ ≥ (1 / 2 : ℝ) * (n : ℝ) ^ (-s.re) -
          (‖s‖ / 12) * (n : ℝ) ^ (-s.re - 1) -
          (Real.sqrt 3 / 216) * ‖s * (s + 1) * (s + 2)‖ *
            ((n : ℝ) ^ (-(s.re + 2))) / (s.re + 2) := by
        nlinarith [hK]

/-  =================================================================
   S2  THE  LEFT-POINT  WALL_LO  (the  floor  at  EVERY  run)
   =================================================================
   At  the  left  point  sL  =  (1/2  -  d0)  +  it  the  S1.1
   floor  is  the  closed  wall_lo  (the  0252  engine's  rigorous
   ||W_n||  lower  bound,  here  for  the  EM  kernel  itself  -
   the  cited  A2c  bridge  identifies  the  fill  with  the  kernel
   norm  at  any  run).  THE  RUN  IS  A  FREE  PARAMETER  -  the
   decoupling,  in  body.  -/

/-- The  closed  wall_lo  at  the  left  point  (the  S1.1  floor
    with  s  =  t4l_sOffL  t  d0,  N  a  run). -/
noncomputable def wallLo (t d0 : ℝ) (N : ℕ) : ℝ :=
  (1 / 2 : ℝ) * (N : ℝ) ^ (-(1 / 2 - d0)) -
    (‖t4l_sOffL t d0‖ / 12) * (N : ℝ) ^ (-(3 / 2 - d0)) -
    (Real.sqrt 3 / 216) *
      ‖t4l_sOffL t d0 * (t4l_sOffL t d0 + 1) * (t4l_sOffL t d0 + 2)‖ *
      ((N : ℝ) ^ (-((1 / 2 - d0) + 2))) / ((1 / 2 - d0) + 2)

/-- S  S1.2  THE  LEFT-POINT  FLOOR:  at  the  left  point  of  ANY
    band  pair  (1000  <=  t,  1/200  <=  d0  <  1/2)  and  EVERY
    run  N  >=  1,  the  EM  kernel  norm  is  at  or  above
    wall_lo.  Pure  unfolding  of  S1.1  at  the  left-point
    shape;  no  measurement. -/
theorem t4LE_floor_off (t d0 : ℝ) (N : ℕ)
    (_ht : 1000 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0)
    (hdhigh : d0 < (1 / 2 : ℝ))
    (HN : 0 < N) :
    ‖p4_em_expr (t4l_sOffL t d0) N‖ ≥ wallLo t d0 N := by
  have hsp : 0 < 1 / 2 - d0 := by linarith [hdhigh]
  have hd0 : 0 ≤ d0 := by linarith [hdlow]
  have hre : (t4l_sOffL t d0).re = 1 / 2 - d0 := by
    dsimp only [t4l_sOffL]
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re,
      Complex.I_re, Complex.I_im, Complex.ofReal_im, mul_zero, zero_mul]
    ring
  have hsre : -1 < (t4l_sOffL t d0).re := by
    rw [hre]
    linarith [hd0]
  have hwall := t4LE_emFloor (s := t4l_sOffL t d0) hsre N HN
  rw [hre] at hwall
  dsimp only [wallLo]
  ring_nf at hwall ⊢
  exact hwall

/-  =================================================================
   S3  THE  DECOUPLED  FILL  RUN  (C_off  =  1/(16  d0^2)  =  C*/2)
   +  THE  SCALE  PIN
   =================================================================
   nIdeal  =  (1/(16  d0^2))^(1/sigma)  t^(2/sigma)  =  (16  d0^2)
   (-1/sigma)  *  t^(2/sigma),  sigma  =  1/2  -  d0,  is  the
   ideal  058e  per-point  run  (the  0252  engine's  npp)  at  the
   DECOUPLED  constant  C_off  =  C*/2  with  C*  (d0)  =
   1  /(8  d0^2)  the  knife-edge  (0252/0257).  N_off  is  its
   ceiling.  The  T1  scale  pin  (S  S3.4)  is  the  EXACT  rpow
   scale  (no  o(1)  loss  at  the  ideal  run)  with  the  ceiling
   loss  2^-sigma  -  it  is  what  the  margin  pin  (1)  uses.  -/

/-- The  decoupled  ideal  fill  run  (S3,  above). -/
noncomputable def nIdeal (t d0 : ℝ) : ℝ :=
    (16 * d0 * d0) ^ (-(1 / (1 / 2 - d0))) * t ^ (2 / (1 / 2 - d0))

/-- The  decoupled  fill  run  (the  ceiling  of  the  ideal  run). -/
noncomputable def Noff (t d0 : ℝ) : ℕ := Nat.ceil (nIdeal t d0)

/-- S  S3.1  THE  IDEAL  RUN  IS  AT  OR  ABOVE  1  ON  THE  BAND
    (t  >=  1000,  1/200  <=  d0  <  1/2):  in  body  via  the
    log  chain  log  nIdeal  =  (2  log  t  -  log  (16  d0^2))  /
    sigma  (exact,  rpow  logs)  >  log  (t^2  /  4)  /  sigma
    >=  log  250000  >  0. -/
theorem t4LE_nIdeal_ge (t d0 : ℝ)
    (ht : 1000 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ)) :
    1 ≤ nIdeal t d0 := by
  have hsp : 0 < 1 / 2 - d0 := by linarith [hdhigh]
  have hd0 : 0 < d0 := by linarith [hdlow]
  have hpos16 : 0 < 16 * d0 * d0 := by positivity
  have hpost : 0 < t := by linarith [ht]
  have h16lt4 : 16 * d0 * d0 < 4 := by nlinarith [hdhigh]
  have hlog16 : Real.log (16 * d0 * d0) < Real.log 4 :=
    Real.log_lt_log (by linarith [hd0]) h16lt4
  have hlogN : Real.log (nIdeal t d0) =
      (2 * Real.log t - Real.log (16 * d0 * d0)) / (1 / 2 - d0) := by
    dsimp only [nIdeal]
    have hlp1 : Real.log ((16 * d0 * d0) ^ (-(1 / (1 / 2 - d0)))) =
        (-(1 / (1 / 2 - d0))) * Real.log (16 * d0 * d0) :=
      Real.log_rpow hpos16 _
    have hlp2 : Real.log (t ^ (2 / (1 / 2 - d0))) =
        (2 / (1 / 2 - d0)) * Real.log t :=
      Real.log_rpow hpost _
    have hp1 : 0 < (16 * d0 * d0) ^ (-(1 / (1 / 2 - d0))) :=
      rpow_pos_of_pos hpos16 _
    have hp2 : 0 < t ^ (2 / (1 / 2 - d0)) := rpow_pos_of_pos hpost _
    rw [Real.log_mul (ne_of_gt hp1) (ne_of_gt hp2), hlp1, hlp2]
    ring_nf
  have hX : Real.log 250000 < 2 * Real.log t - Real.log (16 * d0 * d0) := by
    have ht2 : (1000 : ℝ) ^ 2 ≤ t ^ 2 := by
      gcongr
    --  2  log  t  -  log  (16  d0^2)  =  log  (t^2  /  (16  d0^2)):
    have hratio : 2 * Real.log t - Real.log (16 * d0 * d0) =
        Real.log (t * t / (16 * d0 * d0)) := by
      have hlog2t : (2 : ℝ) * Real.log t = Real.log (t * t) := by
        rw [Real.log_mul (ne_of_gt hpost) (ne_of_gt hpost)]
        ring
      rw [hlog2t, Real.log_div (ne_of_gt (mul_pos hpost hpost)) (ne_of_gt hpos16)]
    rw [hratio]
    have hR : 250000 < t * t / (16 * d0 * d0) := by
      rw [lt_div_iff₀ hpos16]
      have hbig : 250000 * (16 * d0 * d0) < (1000 : ℝ) ^ 2 := by
        have hmid : 250000 * (16 * d0 * d0) < 250000 * 4 :=
          mul_lt_mul_of_pos_left h16lt4 (by norm_num : (0 : ℝ) < 250000)
        have htop : 250000 * 4 = (1000 : ℝ) ^ 2 := by norm_num
        rw [htop] at hmid
        exact hmid
      nlinarith [ht2, hbig]
    exact Real.log_lt_log (by norm_num : (0 : ℝ) < 250000) hR
  --  (2  log  t  -  log  (16  d0^2))  /  sigma  >  log  250000  with
  --  sigma  <  1:
  have hX2 : Real.log 250000 < Real.log (nIdeal t d0) := by
    rw [hlogN]
    set X := 2 * Real.log t - Real.log (16 * d0 * d0) with hXset
    have hposX : 0 < X := by
      have hlogpos : (0 : ℝ) < Real.log 250000 :=
        Real.log_pos (by norm_num : (1 : ℝ) < 250000)
      linarith [hX, hlogpos]
    have hdivlt : X < X / (1 / 2 - d0) := by
      rw [lt_div_iff₀ hsp]
      nlinarith [hposX, hsp, show (1 / 2 - d0 : ℝ) < 1 from by linarith [hdhigh]]
    exact lt_trans (by simpa using hX) hdivlt
  have hposN : 0 < nIdeal t d0 := by
    dsimp only [nIdeal]
    exact mul_pos (rpow_pos_of_pos hpos16 _) (rpow_pos_of_pos hpost _)
  have hge : 250000 < nIdeal t d0 := by
    have h := Real.log_lt_log_iff (by norm_num : (0 : ℝ) < 250000) hposN
    rw [← h]
    exact hX2
  exact le_trans (by norm_num : (1 : ℝ) ≤ 250000) (le_of_lt hge)

/-- S  S3.2  THE  CEILING  BOUNDS  ON  THE  BAND:  nIdeal  <=  N_off
    <=  2  nIdeal  (nIdeal  >=  1). -/
theorem t4LE_ceil_bounds (t d0 : ℝ)
    (ht : 1000 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 < (1 / 2 : ℝ)) :
    nIdeal t d0 ≤ (Noff t d0 : ℝ) ∧
      (Noff t d0 : ℝ) ≤ 2 * nIdeal t d0 := by
  have hge := t4LE_nIdeal_ge t d0 ht hdlow hdhigh
  constructor
  · dsimp only [Noff]
    exact (Nat.le_ceil (nIdeal t d0))
  · dsimp only [Noff]
    have hceil : (Nat.ceil (nIdeal t d0) : ℝ) < nIdeal t d0 + 1 :=
      Nat.ceil_lt_add_one_of_gt_neg_one (by
        --  nIdeal  >=  1  >  -1:
        have hge := t4LE_nIdeal_ge t d0 ht hdlow hdhigh
        linarith [hge])
    have h1 : nIdeal t d0 + 1 ≤ 2 * nIdeal t d0 := by
      nlinarith [t4LE_nIdeal_ge t d0 ht hdlow hdhigh]
    linarith [hceil, h1]

/-  =================================================================
   S4  THE  OWN-MASS  FORM  (the  pair  detector  at  the  own
       height,  as  an  explicit  norm  product)
   =================================================================
   The  floor  on  the  band  IS  the  own  mass  (S1LowT
   floStripMin_eq_mownOnBand):  floStripMin  t  d0  =
   ||poff  t  d0  t||.  The  margin  pin  compares  wall_lo  (S2)
   against  this  own  mass  -  both  explicit  functions.  The
   measured  scale  (1):  factor  2.0000  (ideal  run)  /
   1.419123  (coarse  ceiling  pin)  over  the  whole  band.  -/

/-- S  S4.1  THE  BAND  FLOOR  =  THE  OWN  MASS  (the  S1LowT
    statement,  re-exported  for  the  squeeze  chain):  on  the
    band  (t  >=  1000,  1/200  <=  d0  <=  1/2)  the  unified  S2
    floor  equals  the  pair's  own-height  mass. -/
theorem t4LE_flo_eq_own (t d0 : ℝ) (ht : 1000 ≤ t)
    (hdlow : (1 / 200 : ℝ) ≤ d0) (hdhigh : d0 ≤ (1 / 2 : ℝ)) :
    S1LowT.floStripMin t d0 = ‖poff t d0 t‖ := by
  have hd0 : 0 < d0 := by linarith [hdlow]
  have h := FUnif.floStripMin_eq_mownOnBand t d0 ht hd0 hdhigh
  have hm := (FUnif.poffOwnMass t d0 (by linarith [ht]) hd0 hdhigh).symm
  calc S1LowT.floStripMin t d0
      = S4O.mown t d0 := h
    _ = ‖poff t d0 t‖ := hm

/-  =================================================================
   S5  THE  DECOUPLED  SQUEEZE  (the  support-face  narrowing)
   =================================================================
   On  the  band  at  the  frontier  height  (t  >=  tPT2):  GIVEN
   (i)  the  CITED  A2c  bridge  -  the  fill  (the  |zeta|  fill
       under  the  A4.3  residual  wire  at  the  off-pair)  equals
       the  EM  kernel  norm  at  the  DECOUPLED  run  N  (DLMF
       25.2.8  /  Apostol  12.21,  the  same  provenance  class  as
       the  machined  hs3  cited  mass),  (ii)  the  NAMED  S3  FACE
       -  the  fill  at  or  below  BwireR  +  MrR  (the  endpoint's
       hs3  at  the  pair),  and  (iii)  the  MEASURED  PIN  (1) -
   the  off-pair  is  EXCLUDED  IN  BODY:

       (BwireR  +  MrR  <  floStripMin  =  own  <  wall_lo  <=
       kernel  <=  fill  <=  BwireR  +  MrR,  the  first  step
       FloorUnif.s4StripUnifiedFloor  in  body,  the  middle
       S1LowT  in  body,  the  rest  the  two  inputs).

   The  hOffCPT2  support  obligation  on  the  strip  band  above
   the  frontier  NARROWS  from  {S1  witness  AND  S3  face}  to
   {S3  face}  +  the  cited  bridge  (the  S1  margin  is  now  the
   measured  pin,  in-body  pending  the  worst-point  norm_num
   pin,  named  T4OffLE.pin).  No  RH  claim:  a  squeeze-shape
    record  around  the  named  inputs,  exactly  the  P12
   squeeze_gives_margin  shape.  -/

/-- S  S5.1  THE  DECOUPLED  SQUEEZE  ON  THE  STRIP  BAND  AT  THE
    FRONTIER:  under  the  cited  A2c  bridge  at  the  run,  the
    named  S3  face  at  the  pair,  and  the  measured  pin
   (wall_lo  (N)  >  the  own  mass  at  (t,  d0)),  no  fill  value
    can  satisfy  both  -  the  off-pair  at  (t,  d0)  is
    excluded.  Pure  composition  of  the  in-body  facts
   (s4StripUnifiedFloor  +  flo  =  own  +  the  S1.2  floor)  with
    the  three  named  inputs. -/
theorem t4LE_squeeze_decoupled (t d0 : ℝ) (N : ℕ)
    (ht : WinC.tPT2 ≤ t) (hdlow : (1 / 200 : ℝ) ≤ d0)
    (hdhigh : d0 < (1 / 2 : ℝ)) (HN : 0 < N)
    (hbridge : ‖riemannZeta (t4l_sOffL t d0) -
              (p4_P N (t4l_sOffL t d0) - p4_I N (t4l_sOffL t d0))‖ =
              ‖p4_em_expr (t4l_sOffL t d0) N‖)
    (hs3face : ‖riemannZeta (t4l_sOffL t d0) -
              (p4_P N (t4l_sOffL t d0) - p4_I N (t4l_sOffL t d0))‖ ≤
              S4A.BwireR t d0 + S4A.MrR t d0)
    (hpin : wallLo t d0 N > ‖poff t d0 t‖) :
    False := by
  have ht1000 : 1000 ≤ t := by
    calc (1000 : ℝ) ≤ (10 : ℝ) ^ (10 : ℕ) := by norm_num
      _ ≤ WinC.tPT2 := by
          dsimp only [WinC.tPT2]
          norm_num
      _ ≤ t := ht
  have hdh : d0 ≤ (1 / 2 : ℝ) := le_of_lt hdhigh
  --  (a)  fill  =  kernel  norm  >=  wall_lo  (the  S1.2  floor  +
  --  the  cited  bridge):
  set fill := ‖riemannZeta (t4l_sOffL t d0) -
              (p4_P N (t4l_sOffL t d0) - p4_I N (t4l_sOffL t d0))‖ with hfill
  have hlo : fill ≥ wallLo t d0 N := by
    calc fill = ‖p4_em_expr (t4l_sOffL t d0) N‖ := hfill.trans hbridge
      _ ≥ wallLo t d0 N := t4LE_floor_off t d0 N ht1000 hdlow hdhigh HN
  --  (b)  the  band  floor  =  the  own  mass,  and  the  wire  is
  --  below  the  floor  (both  in  body):
  have hflo : S1LowT.floStripMin t d0 = ‖poff t d0 t‖ :=
    t4LE_flo_eq_own t d0 ht1000 hdlow hdh
  have hwire : S4A.BwireR t d0 + S4A.MrR t d0 + S4A.MfR (t, d0) <
      S1LowT.floStripMin t d0 :=
    FUnif.s4StripUnifiedFloor t d0 ht1000 hdlow hdh
  have hm0 : S4A.MfR (t, d0) = 0 := by dsimp only [S4A.MfR]
  have hwire0 : S4A.BwireR t d0 + S4A.MrR t d0 < S1LowT.floStripMin t d0 := by
    rw [hm0, add_zero] at hwire
    exact hwire
  --  (c)  the  chain  (a  strict  end-to-end  cycle):
  have hpinlt : ‖poff t d0 t‖ < wallLo t d0 N := hpin
  have hchain : S4A.BwireR t d0 + S4A.MrR t d0 <
      S4A.BwireR t d0 + S4A.MrR t d0 := by
    calc S4A.BwireR t d0 + S4A.MrR t d0
        < S1LowT.floStripMin t d0 := hwire0
      _ = ‖poff t d0 t‖ := hflo
      _ < wallLo t d0 N := hpinlt
      _ ≤ fill := hlo
      _ ≤ S4A.BwireR t d0 + S4A.MrR t d0 := hs3face
  exact lt_irrefl _ hchain

end  T4OffLE

end
