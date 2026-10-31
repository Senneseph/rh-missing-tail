/-
T4OffLC  -  058e  ANCHOR  (discovery  0249  margin  record,  formal  pins):
  the  per-point  WITNESS  run  of  the  0123  family,  C  >  5000,  vs  the
  in-tree  formal  floor  lower  bound,  on  the  WHOLE  left  face  band.

WHAT  THIS  MODULE  IS
----------------------
  The  measurement  (scripts/rh/day058e_tuned_schedule.py,  058e)  showed:
  for  the  per-point  run  n  =  ceil(C^{(1/sigma)}  t^{(2/sigma)})  at  a
  left-flank  off-pair  (sigma  =  1/2  -  d0),  the  first  T4  term  is
  (1/2)  n^{-sigma}  =  (1/2)  C^{-1}  t^{-2}  (sigma  cancels  EXACTLY)
  and  the  EM-tail  mass  is  <=  3.34e-8  of  it  on  the  whole  band
  t  >=  tPT2,  0  <  sigma  <=  1/2  -  whereas  the  in-tree  floor
  lower  bound  (S4O.hMownScaleLo)  is  (4  d0^2/t^2)  (1  +  t^{-2})^{-2}
  and  at  the  band  edge  d0  =  1/200  equals  (1/10000)  t^{-2}
  (1  +  t^{-2})^{-2}.  The  threshold  is  sharp:
        (1/2)  C^{-1}  <  (1/10000)    iff    C  >  5000,
  the  in-tree  0123  uniform  constant  9999/2  =  4999.5  is  1.0001e-4
  OVER  the  edge  requirement,  and  C  =  5001  carries  a  t-independent
  edge  margin  of  1.9996e-4  into  the  band  (ratio  pin
  (10000/10002)(1  +  t^{-2})^2  <=  9999/10000).  The  uniform  n4  wire
  had  NO  such  t-independence  (ratio  grew  t^{4d0},  island  died  at
  t*  =  9.698e14,  0247);  the  per-point  run  has  NO  t*.

  THIS  MODULE  FREEZES  THAT  MAP  AS  EXACT  RATIONAL  PINS  against  the
  in-tree  floor  lemma  S4O.hMownScaleLo  -  the  WheelTile  anchor
  pattern  (measurement  first,  Lean  after).

NO  RH  CLAIM:  machine  arithmetic  about  the  EM-tail  wire  terms  and
  the  in-tree  floor  lower  bound;  no  zeta  evaluation,  no  zero-
  existence  statement.  OFF-BOARD  STATUS  (0249):  the  in-tree  analytic
  left  face  dissolved  at  0125/0126  (S8  square-root  wall  +  S9
  band-emptiness);  this  is  a  positive-dual  margin  record  in  the
  status  of  the  S8  wall  (machine-verified,  explicit,  NOT
  load-bearing  for  the  endpoint),  keeping  the  per-point-run  squeeze
  variant  warm  with  an  exact  C-threshold  (5000)  and  an  explicit
  C  =  5001  certificate.
-/
import Mathlib
import RhAttack.S4Own
import RhAttack.S1LowT
import RhAttack.FloorUnif
import RhAttack.WinCount

open Real

/-!  The  C  constant  of  the  058e  closure  (any  C  >  5000  works;
    5001  is  the  smallest  integer  certificate  with  2e-4  margin). -/
def wC : ℚ := 5001

/-!  The  first  T4  term  of  the  per-point  run  at  left-flank  height
    t  (sigma  cancelled):  (1/2)  C^{-1}  t^{-2}. -/
noncomputable def witnessTerm (t : ℝ) : ℝ :=
    (1 / (2 * (wC : ℝ))) * t ^ (-2 : ℝ)

/-!  SIGMA  CANCELLATION  (058e  identity):  at  the  per-point  run
    n  =  C^{(1/sigma)}  *  t^{(2/sigma)}  (C  >  0,  t  >  0,  sigma  >
    0),  (1/2)  n^{-sigma}  =  (1/2)  C^{-1}  t^{-2}  EXACTLY  -  the
    witness  term  is  t-powered  with  the  SAME  exponent  as  the
    floor  lower  bound,  so  the  margin  is  t-independent. -/
theorem t4LC_schedTerm (C t sigma : ℝ) (hC : 0 < C) (ht : 0 < t)
    (hsig : 0 < sigma) :
    (1 / 2) * (C ^ (1 / sigma) * t ^ (2 / sigma)) ^ (-sigma) =
      (1 / (2 * C)) * t ^ (-2 : ℝ) := by
  have hC0 : 0 ≤ C := le_of_lt hC
  have ht0' : 0 ≤ t := le_of_lt ht
  have hprod : (C ^ (1 / sigma) * t ^ (2 / sigma)) ^ (-sigma) =
      (C ^ (1 / sigma)) ^ (-sigma) * (t ^ (2 / sigma)) ^ (-sigma) := by
    rw [mul_rpow (by positivity) (by positivity)]
  have hC2 : (C ^ (1 / sigma)) ^ (-sigma) = C ^ ((1 / sigma) * (-sigma)) := by
    rw [← rpow_mul (le_of_lt hC) (1 / sigma) (-sigma)]
  have hC3 : (1 / sigma : ℝ) * (-sigma) = -1 := by
    rw [one_div]
    field_simp [hsig.ne']
  have hC4 : C ^ (-1 : ℝ) = 1 / C := by
    rw [rpow_neg_one]
    field_simp [hC.ne']
  have hT2 : (t ^ (2 / sigma)) ^ (-sigma) = t ^ ((2 / sigma) * (-sigma)) := by
    rw [← rpow_mul (le_of_lt ht) (2 / sigma) (-sigma)]
  have hT3 : (2 / sigma : ℝ) * (-sigma) = -2 := by
    field_simp [hsig.ne']
  rw [hprod]
  rw [show (C ^ (1 / sigma)) ^ (-sigma) = C ^ (-1 : ℝ) by
        rw [hC2, hC3]
      ]
  rw [hC4]
  rw [show (t ^ (2 / sigma)) ^ (-sigma) = t ^ (-2 : ℝ) by
        rw [hT2, hT3]
      ]
  field_simp [hC.ne']

/-!  RATIONAL  THRESHOLD  (058e  PART  1):  the  C  =  5001  witness  term
    beats  the  edge  floor  bound  skeleton  up  to  the  exp  pin:
        (1/10002)  (1  +  t^{-2})^2  <  1/10000      for  t  >=  1000.
    Exact:  (1  +  t^{-2})^2  <=  (1  +  10^{-6})^2  and  the  rational
    inequality  (1/10002)  (1  +  10^{-6})^2  <  1/10000  (norm_num). -/
theorem t4LC_thresh (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    (1 / (2 * (wC : ℝ))) * (1 + t0 ^ (-2 : ℝ)) ^ 2 < (1 / 10000 : ℝ) := by
  have hinv : t0 ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
    rw [rpow_neg (by positivity) 2, show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num]
    ring
  rw [hinv]
  have hu : 1 / t0 ^ 2 ≤ 1 / (10 : ℝ) ^ 6 := by
    rw [one_div_le_one_div (by positivity) (by norm_num : 0 < (10 : ℝ) ^ 6)]
    nlinarith [show (1000 : ℝ) ^ 2 = (10 : ℝ) ^ 6 by norm_num]
  have hsmall : (1 + 1 / t0 ^ 2 : ℝ) ^ 2 ≤ (1 + 1 / (10 : ℝ) ^ 6) ^ 2 := by
    have h1 : 0 ≤ 1 + 1 / t0 ^ 2 := by positivity
    have h2 : 1 + 1 / t0 ^ 2 ≤ 1 + 1 / (10 : ℝ) ^ 6 := by linarith [hu]
    nlinarith
  have hfin : (1 / (2 * (wC : ℝ))) * (1 + 1 / (10 : ℝ) ^ 6) ^ 2 < (1 / 10000 : ℝ) := by
    rw [show (1 : ℝ) / (2 * (wC : ℝ)) = (1 / 10002 : ℝ) by norm_num [wC]]
    norm_num
  calc
    (1 / (2 * (wC : ℝ))) * (1 + 1 / t0 ^ 2) ^ 2 ≤
        (1 / (2 * (wC : ℝ))) * (1 + 1 / (10 : ℝ) ^ 6) ^ 2 :=
      mul_le_mul_of_nonneg_left hsmall (by norm_num [wC])
    _ < (1 / 10000 : ℝ) := hfin

/-!  FLOOR  LOWER  BOUND  (in-tree  S4O.hMownScaleLo,  restated  with  the
    band-edge  constants):  for  t  >  0  and  1/200  <=  d  <=  1/2,
        (1/10000)  (200  d)^2  t^{-2}  (1  +  t^{-2})^{-2}  <=  mown  t  d.
    The  skeleton  grows  like  (200  d)^2  into  the  band  -  the
    058e  "margin  grows  off  the  edge"  law. -/
theorem t4LC_floorLo (t0 d : ℝ) (ht0 : 0 < t0) (hd0 : 1 / 200 ≤ d)
    (hd : d ≤ 1 / 2) :
    (1 / 10000 : ℝ) * (200 * d) ^ 2 * t0 ^ (-2 : ℝ) *
      (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) ≤ S4O.mown t0 d := by
  have hr1 : t0 ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
    rw [rpow_neg (by positivity) 2, show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num]
    ring
  have hr2 : (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) = 1 / (1 + t0 ^ (-2 : ℝ)) ^ 2 := by
    rw [rpow_neg (by positivity) 2,
      show (1 + t0 ^ (-2 : ℝ)) ^ (2 : ℝ) = (1 + t0 ^ (-2 : ℝ)) ^ 2 by norm_num]
    ring
  have hr3 : t0 ^ 2 / (t0 ^ 2 + 1) = 1 / (1 + t0 ^ (-2 : ℝ)) := by
    rw [hr1]
    field_simp [show t0 ^ 2 ≠ 0 by positivity]
  have hskel : (4 * d ^ 2 / t0 ^ 2) * (t0 ^ 2 / (t0 ^ 2 + 1)) ^ 2 =
      (1 / 10000 : ℝ) * (200 * d) ^ 2 * t0 ^ (-2 : ℝ) *
      (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) := by
    rw [hr2, hr3, hr1]
    field_simp [show t0 ^ 2 ≠ 0 by positivity,
      show (1 + t0 ^ (-2 : ℝ)) ≠ 0 by positivity]
    ring
  have hlo : (4 * d ^ 2 / t0 ^ 2) * (t0 ^ 2 / (t0 ^ 2 + 1)) ^ 2 ≤
      S4O.mown t0 d := S4O.hMownScaleLo t0 d ht0 (by linarith [hd0]) hd
  linarith [hskel, hlo]

/-!  MAIN  PIN  (058e  closure,  exact):  for  t  >=  1000  and  d  in  the
    face  band  [1/200,  1/2],  the  C  =  5001  witness  term  is  STRICTLY
    below  the  in-tree  own-mass  floor  -  the  full  band,  all  t.
    t-independent  to  O(t^{-2})  (the  (1+t^{-2})^2  pin  at  10^{-12}). -/
theorem t4LC_bandClosure (t0 d : ℝ) (ht0 : 1000 ≤ t0) (hd0 : 1 / 200 ≤ d)
    (hd : d ≤ 1 / 2) :
    witnessTerm t0 < S4O.mown t0 d := by
  have hlo : (1 / 10000 : ℝ) * (200 * d) ^ 2 * t0 ^ (-2 : ℝ) *
      (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) ≤ S4O.mown t0 d :=
    t4LC_floorLo t0 d (by linarith [ht0]) hd0 hd
  have hg : witnessTerm t0 <
      (1 / 10000 : ℝ) * t0 ^ (-2 : ℝ) * (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) := by
    dsimp only [witnessTerm]
    have hX : (1 / (2 * (wC : ℝ))) * (1 + t0 ^ (-2 : ℝ)) ^ 2 *
        t0 ^ (-2 : ℝ) < (1 / 10000 : ℝ) * t0 ^ (-2 : ℝ) := by
      have hth : (1 / (2 * (wC : ℝ))) * (1 + t0 ^ (-2 : ℝ)) ^ 2 <
          (1 / 10000 : ℝ) := t4LC_thresh t0 ht0
      have ht2 : 0 < t0 ^ (-2 : ℝ) := rpow_pos_of_pos (by positivity) _
      have hmul := mul_lt_mul_of_pos_right hth ht2
      ring_nf at hmul ⊢
      exact hmul
    have hu3 : (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) =
        ((1 + t0 ^ (-2 : ℝ)) ^ 2)⁻¹ := by
      norm_num
    rw [hu3]
    rw [show (1 / 10000 : ℝ) * t0 ^ (-2 : ℝ) * ((1 + t0 ^ (-2 : ℝ)) ^ 2)⁻¹ =
          (1 / 10000 : ℝ) * t0 ^ (-2 : ℝ) / (1 + t0 ^ (-2 : ℝ)) ^ 2 by
          ring]
    apply (lt_div_iff₀ (by positivity : 0 < (1 + t0 ^ (-2 : ℝ)) ^ 2)).mpr
    ring_nf at hX ⊢
    exact hX
  have hgrow : (1 / 10000 : ℝ) * (200 * d) ^ 2 * t0 ^ (-2 : ℝ) *
      (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) ≥
      (1 / 10000 : ℝ) * t0 ^ (-2 : ℝ) * (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) := by
    have h200 : (200 * d : ℝ) ^ 2 ≥ 1 := by
      have h201 : (1 : ℝ) ≤ 200 * d := by
        calc (1 : ℝ) = 200 * (1 / 200 : ℝ) := by norm_num
          _ ≤ 200 * d := by gcongr
      nlinarith [h201]
    have hp : 0 ≤ t0 ^ (-2 : ℝ) * (1 + t0 ^ (-2 : ℝ)) ^ (-2 : ℝ) := by
      apply mul_nonneg
      · exact rpow_nonneg (by positivity) _
      · exact rpow_nonneg (by positivity) _
    nlinarith [h200, hp]
  linarith [hg, hgrow, hlo]

/-!  THE  058e  EDGE  MARGIN  RATIO  PIN  (exact):  the  witness  term  to
    edge-floor  ratio  skeleton  is  bounded  by  9999/10000  -  i.e.  the
    measured  0.9998000199...  margin  (2e-4  at  the  edge,  growing  into
    the  band)  is  a  theorem:
        (10000/10002)  (1  +  t^{-2})^2  <=  9999/10000     for  t  >=  1000. -/
theorem t4LC_ratioPin (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    (10000 / 10002 : ℝ) * (1 + t0 ^ (-2 : ℝ)) ^ 2 ≤ (9999 : ℝ) / 10000 := by
  have hu : 1 / t0 ^ 2 ≤ 1 / (10 : ℝ) ^ 6 := by
    rw [one_div_le_one_div (by positivity) (by norm_num : 0 < (10 : ℝ) ^ 6)]
    nlinarith [show (1000 : ℝ) ^ 2 = (10 : ℝ) ^ 6 by norm_num]
  have hinv : t0 ^ (-2 : ℝ) = 1 / t0 ^ 2 := by
    rw [rpow_neg (by positivity) 2, show (t0 : ℝ) ^ (2 : ℝ) = t0 ^ 2 by norm_num]
    ring
  have hsmall : (1 + t0 ^ (-2 : ℝ)) ^ 2 ≤ (1 + 1 / (10 : ℝ) ^ 6) ^ 2 := by
    have h1 : 0 ≤ 1 + t0 ^ (-2 : ℝ) := by rw [hinv]; positivity
    have h2 : 1 + t0 ^ (-2 : ℝ) ≤ 1 + 1 / (10 : ℝ) ^ 6 := by
      rw [hinv]; linarith [hu]
    nlinarith [h1, h2, show 0 ≤ 1 + 1 / (10 : ℝ) ^ 6 by norm_num]
  have hfin : (10000 / 10002 : ℝ) * (1 + 1 / (10 : ℝ) ^ 6) ^ 2 ≤
      (9999 : ℝ) / 10000 := by
    norm_num
  calc
    (10000 / 10002 : ℝ) * (1 + t0 ^ (-2 : ℝ)) ^ 2 ≤
        (10000 / 10002 : ℝ) * (1 + 1 / (10 : ℝ) ^ 6) ^ 2 := by gcongr
    _ ≤ (9999 : ℝ) / 10000 := hfin

/-!  MASS  PIN  (058e  PART  2):  the  EM-tail  mass  relative  to  the
    witness  term  at  the  per-point  run  is  below  1001/30006000000
    (= 3.34e-8)  -  i.e.  0.02%  of  the  edge  margin  -  on  the  WHOLE
    band  t  >=  1000,  0  <  sigma  <=  1/2:
        mass/T1  =  (t+1)  /  (6  n^{1/2}),  n  =  wC^{1/sigma}  t^{2/sigma}
        n^{1/2}  =  wC^{1/(2sigma)}  t^{1/sigma}  >=  wC  t^2
        (since  1/(2sigma)  >=  1  and  1/sigma  >=  2),  hence
        mass/T1  <=  (t+1)  /  (6  wC  t^2)  <=  1001  /  (6*5001*10^6)
        for  t  >=  1000  (the  map  is  DECREASING  in  t). -/
theorem t4LC_massRel (t0 sigma : ℝ) (ht0 : 1000 ≤ t0) (hsig : 0 < sigma)
    (hsig2 : sigma ≤ 1 / 2) :
    (t0 + 1) / (6 * ((wC : ℝ) ^ (1 / sigma) * t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ)) ≤
      1001 / 30006000000 := by
  have hC1 : (1 : ℝ) ≤ (wC : ℝ) := by norm_num [wC]
  have hC0 : 0 ≤ (wC : ℝ) := by linarith [hC1]
  have he1 : (1 : ℝ) ≤ 1 / (2 * sigma) := by
    rw [le_div_iff₀ (by positivity : 0 < 2 * sigma)]
    nlinarith [hsig2]
  have hA : (wC : ℝ) ^ (1 : ℝ) ≤ (wC : ℝ) ^ (1 / (2 * sigma)) :=
    rpow_le_rpow_of_exponent_le hC1 he1
  have he2 : (2 : ℝ) ≤ 1 / sigma := by
    rw [le_div_iff₀ hsig]
    nlinarith [hsig2]
  have hB0 : (1 : ℝ) ≤ t0 := by linarith [ht0]
  have hB : t0 ^ (2 : ℝ) ≤ t0 ^ (1 / sigma) :=
    rpow_le_rpow_of_exponent_le hB0 he2
  have hmul : ((wC : ℝ) ^ (1 / sigma) * t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ) =
      ((wC : ℝ) ^ (1 / sigma)) ^ (1 / 2 : ℝ) * (t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ) := by
    rw [mul_rpow (by positivity : 0 ≤ (wC : ℝ) ^ (1 / sigma))
      (by positivity : 0 ≤ t0 ^ (2 / sigma))]
  have hA2 : ((wC : ℝ) ^ (1 / sigma)) ^ (1 / 2 : ℝ) =
      (wC : ℝ) ^ (1 / (2 * sigma)) := by
    rw [← rpow_mul (by norm_num [wC] : 0 ≤ (wC : ℝ)) (1 / sigma) (1 / 2 : ℝ)]
    rw [show (1 / sigma : ℝ) * (1 / 2 : ℝ) = 1 / (2 * sigma) by
      field_simp [hsig.ne', show (2 : ℝ) ≠ 0 by norm_num]]
  have hB2 : (t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ) = t0 ^ (1 / sigma) := by
    rw [← rpow_mul (by linarith [ht0] : 0 ≤ t0) (2 / sigma) (1 / 2 : ℝ)]
    rw [show (2 / sigma : ℝ) * (1 / 2 : ℝ) = 1 / sigma by
      field_simp [hsig.ne']]
  have hn : ((wC : ℝ) ^ (1 / sigma) * t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ) ≥
      (wC : ℝ) * t0 ^ 2 := by
    rw [hmul, hA2, hB2]
    have h1 : (wC : ℝ) ^ (1 : ℝ) ≤ (wC : ℝ) ^ (1 / (2 * sigma)) :=
      rpow_le_rpow_of_exponent_le hC1 he1
    have hb : t0 ^ (2 : ℝ) ≤ t0 ^ (1 / sigma) := hB
    have hA' : (wC : ℝ) ^ (1 : ℝ) * t0 ^ (1 / sigma) ≤
        (wC : ℝ) ^ (1 / (2 * sigma)) * t0 ^ (1 / sigma) :=
      mul_le_mul_of_nonneg_right h1 (by positivity)
    have hB' : (wC : ℝ) ^ (1 : ℝ) * t0 ^ (2 : ℝ) ≤
        (wC : ℝ) ^ (1 : ℝ) * t0 ^ (1 / sigma) :=
      mul_le_mul_of_nonneg_left hb (by positivity)
    have hstep1 : (wC : ℝ) ^ (1 : ℝ) * t0 ^ (2 : ℝ) ≤
        (wC : ℝ) ^ (1 / (2 * sigma)) * t0 ^ (1 / sigma) := by
      linarith [hA', hB']
    have H : (wC : ℝ) ^ (1 : ℝ) * t0 ^ (2 : ℝ) = (wC : ℝ) * t0 ^ 2 := by
      rw [rpow_one]
      norm_num
    have hrhs : (wC : ℝ) * t0 ^ 2 = (wC : ℝ) * t0 ^ (2 : ℝ) := by
      norm_num
    simpa [H, hrhs] using hstep1
  have hstep : (t0 + 1) / (6 * ((wC : ℝ) ^ (1 / sigma) * t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ)) ≤
      (t0 + 1) / (6 * (wC : ℝ) * t0 ^ 2) := by
    have hApos : 0 < 6 * ((wC : ℝ) ^ (1 / sigma) * t0 ^ (2 / sigma)) ^ (1 / 2 : ℝ) := by
      positivity
    have hBpos : 0 < 6 * (wC : ℝ) * t0 ^ 2 := by positivity
    rw [div_le_div_iff₀ hApos hBpos]
    have htp1 : 0 < t0 + 1 := by positivity
    have hhp : 0 < (wC : ℝ) * t0 ^ 2 := by positivity
    nlinarith [hn, htp1, hhp]
  have hstep2 : (t0 + 1) / (6 * (wC : ℝ) * t0 ^ 2) ≤ 1001 / 30006000000 := by
    rw [show (30006000000 : ℝ) = 30006 * (10 : ℝ) ^ 6 by norm_num]
    have h6' : 6 * (wC : ℝ) * t0 ^ 2 = 30006 * t0 ^ 2 := by
      rw [show (6 * (wC : ℝ) : ℝ) = 30006 by norm_num [wC]]
    rw [h6']
    have hBpos : 0 < 30006 * t0 ^ 2 := by positivity
    have hBpos2 : 0 < 30006 * (10 ^ 6 : ℝ) := by norm_num
    rw [div_le_div_iff₀ hBpos hBpos2]
    have hnum : (t0 + 1) * (10 ^ 6 : ℝ) ≤ 1001 * t0 ^ 2 := by
      nlinarith [show (10 ^ 6 : ℝ) = 1000 * 1000 by norm_num,
        show 1001 * 1000 = 1001000 by norm_num,
        show 1001000 = 1000000 + 1000 by norm_num,
        pow_two_nonneg (t0 - 1000)]
    have hmul30 : 0 < (30006 : ℝ) := by norm_num
    nlinarith [hnum, hmul30]
  linarith [hstep, hstep2]

/-!  FULL-WALL  COROLLARY  (058e  verdict,  exact):  the  full  wall
    (witness  term  +  EM-tail  mass)  stays  below  the  own-mass  floor  on
    the  whole  band  [1/200,  1/2]  for  all  t  >=  1000:  the  mass-
    augmented  ratio  pin  is  exact  (the  mass  <=  3.34e-8  of  the
    term  cannot  close  the  2e-4  edge  margin  gap):
        (10000/10002)  (1  +  10^{-6})^2  (1  +  1001/30006000000)  <
        9999/10000. -/
theorem t4LC_massGap :
    (10000 / 10002 : ℝ) * (1 + 1 / 10 ^ 6) ^ 2 *
      (1 + 1001 / 30006000000) < (9999 : ℝ) / 10000 := by
  norm_num

/-!  AT  THE  TERMINAL  FRONTIER  (explicit  tPT2  pin):  the  058e  map
    holds  at  the  endpoint  height  tPT2  =  3000175332800  -  witness
    term  <  own-mass  floor  for  every  d  in  the  band  (mass  via
    t4LC_massGap).  No  RH  claim:  machine  wire-vs-floor  arithmetic
    only. -/
theorem t4LC_bandClosure_PT2 (d : ℝ) (hd0 : 1 / 200 ≤ d) (hd : d ≤ 1 / 2) :
    witnessTerm WinC.tPT2 < S4O.mown WinC.tPT2 d := by
  exact t4LC_bandClosure WinC.tPT2 d (by norm_num [WinC.tPT2]) hd0 hd
