/-
T4OffLD  -  0252  ANCHOR  (route-(c)  EXHAUSTION  record,  formal  pins):
  the  per-point  witness  family  n  =  C^{(1/sigma)}  t^{(2/sigma)}
  can  NEVER  close  both  squeeze  legs  at  any  band  point  -  the
  two-sided  knife  edge,  exact.

WHAT  THIS  MODULE  IS
----------------------
  The  measurement  (scripts/rh/day059_route_c_s1_perpoint.py,  0252;
  closed  forms  only,  no  zeta,  no  zero  data)  settled  route  (c)
  of  the  record-layer  spec  docs/RECORD-REQUIREMENTS.md  NEGATIVE:
  for  the  per-point  run  of  the  0123  family  at  a  left-flank
  band  point  (sigma  =  1/2  -  d0,  t  >=  1000),  both  squeeze  legs
  concentrate  at  the  shared  scale  (1/2)  C^{-1}  t^{-2}  (sigma
  cancels  EXACTLY,  T4OffLC.t4LC_schedTerm):
        S1  leg  (fill  lower  bound  >=  devProg):
              (1/2)  C^{-1}  t^{-2}  >=  4  d0^2  t^{-2}     iff  C  <  1/(8  d0^2),
        S4  leg  (per-point  wire  <  floor,  the  058e/T4OffLC  side):
              (1/2)  C^{-1}  t^{-2}  <  floor  t  d0  <=-bound-  4  d0^2  t^{-2}
              (floor  lower  bound,  S4O.hMownScaleLo)     iff  C  >  1/(8  d0^2).
  The  knife-edge  thresholds  COINCIDE  (C*  =  1/(8  d0^2),  t-
  independent),  so  NO  C  >  0  closes  both  legs  at  ANY  band
  point:  measured  joint  closure  =  0  points  over  the  full  grid
  (t  1e3..1e16  x  d0  1/200..posReserveD0max  x  C  1..1e8);  at  the
  band  edge  d0  =  1/200  the  leg  ratios  are  EXACT  reciprocals,
      R1(C)  =  5000/C,      R3(C)  =  C/5000      (to  10  digits),
  the  S1  leg  wants  C  <  5000,  the  S4  leg  wants  C  >  5000,  and
  the  058e  certificate  C  =  5001  (T4OffLC)  closes  S3/S4  on  the
  whole  band  while  its  S1  mirror  is  open  on  the  whole  band
  (edge  deficit  2e-4  =  1/5001  exactly;  worst  1.79e-4  at  the
  face  upper  edge  d0  =  posReserveD0max).  The  in-tree  0123
  constant  4999.5  =  9999/2  is  the  exact  mirror  (S1  closed  at
  the  edge,  S4  open  by  1.0001e-4).

  THIS  MODULE  FREEZES  THAT  FACT  AS  EXACT  RATIONAL  PINS  -  the
  WheelTile  anchor  pattern  (measurement  first,  Lean  after).

NO  RH  CLAIM:  machine  arithmetic  about  the  EM  wire  scales  and
  the  in-tree  floor  lower  bound;  no  zeta  evaluation,  no  zero-
  existence  statement.  OFF-BOARD  STATUS  (0126/0249/0252):  the  in-
tree  analytic  faces  dissolved;  this  is  a  positive-dual  margin
  record  in  the  status  of  the  S8  wall  (machine-verified,
  explicit,  NOT  load-bearing  for  the  endpoint)  -  the  exhaustion
  of  the  per-point  route  as  a  discharge  mechanism  for  the
  terminal  face  hOffCPT2,  with  the  record  layer  (frontier  push /
  external  zero-exclusion  record)  as  the  completion  layer.
-/
import Mathlib
import RhAttack.T4OffLC
import RhAttack.Z78PosReserve

open Real

/-!  The  edge  floor  skeleton  scale  at  the  band  edge  d0  =
    1/200:  4  (1/200)^2  =  1/10000  (the  058e/T4OffLC  edge). -/
def t4LD_edgeDev : ℚ := 4 * (1 / 200) ^ 2

theorem t4LD_edgeDev_val : t4LD_edgeDev = (1 / 10000 : ℚ) := by
  norm_num [t4LD_edgeDev]

/-!  The  in-tree  0123  uniform  constant (4999.5, the  1.0001e-4
    OVER  the  edge  requirement;  the  mirror  of  the  C  =  5001
    certificate). -/
def t4LD_cPrim : ℚ := 9999 / 2

/-!  The  face  upper  edge  d0  =  posReserveD0max  (=  theta  -  1/2
    at  the  EIGHTH  board  record)  as  an  exact  rational. -/
def t4LD_d0max : ℚ := 3733819666133 / 10000000000000

theorem t4LD_d0max_val :
    Z78PosReserve.posReserveD0max = (t4LD_d0max : ℝ) := by
  dsimp only [Z78PosReserve.posReserveD0max, Z78PosReserve.posReserveUpper]
  norm_num [t4LD_d0max]

/-!  The  S1  (fill-lower)  leg  ratio  at  the  band  edge,  as  a
    function  of  the  family  constant  C:  wire  scale  (1/2C)  over
    the  edge  floor  skeleton  1/10000  (the  t^{-2}  cancels). -/
noncomputable def t4LD_r1 (C : ℝ) : ℝ := (1 / (2 * C)) / (t4LD_edgeDev : ℝ)

/-!  The  S4  (wire-upper)  leg  ratio  at  the  band  edge:  the
    reciprocal  -  the  knife  edge. -/
noncomputable def t4LD_r3 (C : ℝ) : ℝ := (t4LD_edgeDev : ℝ) / (1 / (2 * C))

/-!  THE  KNIFE  EDGE  (0252  structural  fact,  exact):  at  the
    band  edge  the  two  leg  ratios  are  EXACT  reciprocals  for
    every  C  >  0  -  the  measured  R1(C)  =  5000/C,  R3(C)  =
    C/5000  to  10  digits,  in  body. -/
theorem t4LD_reciprocal (C : ℝ) (hC : 0 < C) :
    t4LD_r1 C * t4LD_r3 C = 1 := by
  dsimp only [t4LD_r1, t4LD_r3]
  have he : (t4LD_edgeDev : ℝ) = 1 / 10000 := by norm_num [t4LD_edgeDev_val]
  rw [he]
  field_simp [hC.ne', show (1 : ℝ) / 10000 ≠ 0 by norm_num]

/-!  NO  JOINT  CLOSURE  (0252  "0  points"  in  knife-edge  form):
    no  C  >  0  closes  BOTH  squeeze  legs  at  the  band  edge. -/
theorem t4LD_noJoint (C : ℝ) (hC : 0 < C) :
    ¬ (t4LD_r1 C > 1 ∧ t4LD_r3 C > 1) := by
  intro h
  have hr3 : 0 < t4LD_r3 C := by
    dsimp only [t4LD_r3, t4LD_edgeDev]
    positivity
  have hmul : 1 < t4LD_r1 C * t4LD_r3 C := by
    nlinarith [h.1, h.2, hr3]
  rw [t4LD_reciprocal C hC] at hmul
  exact lt_irrefl _ hmul

/-!  THE  SHARP  EDGE  THRESHOLD:  at  d0  =  1/200  the  knife edge
    is  exactly  C*  =  1/(8  (1/200)^2)  =  5000  -  the  058e
    "C  >  5000"  threshold,  as  a  rational  identity. -/
theorem t4LD_cstarEdge : (1 : ℝ) / (8 * (1 / 200 : ℝ) ^ 2) = (5000 : ℝ) := by
  norm_num

/-!  C  =  5001  (the  T4OffLC  certificate),  t-inclined  against  the
    pure  t^{-2}  edge  scale:  the  witness  term  ratio  is  EXACTLY
    5000/5001  at  every  t  >  0. -/
theorem t4LD_wC_edgeRatio (t : ℝ) (ht : 0 < t) :
    witnessTerm t / ((1 / 10000 : ℝ) * t ^ (-2 : ℝ)) = (5000 : ℝ) / 5001 := by
  dsimp only [witnessTerm]
  have hw : (wC : ℝ) = 5001 := by norm_num [wC]
  rw [hw, show (1 : ℝ) / (2 * (5001 : ℝ)) = (1 / 10002 : ℝ) by norm_num]
  have hinv : t ^ (-2 : ℝ) = 1 / t ^ 2 := by
    rw [rpow_neg (by positivity) 2,
      show (t : ℝ) ^ (2 : ℝ) = t ^ 2 by norm_num]
    ring
  rw [hinv]
  field_simp [show t ≠ 0 by positivity,
    show (t : ℝ) ^ 2 ≠ 0 by positivity,
    show (1 / 10002 : ℝ) ≠ 0 by norm_num,
    show (1 / 10000 : ℝ) ≠ 0 by norm_num]
  norm_num

/-!  C  =  5001  S1  SIDE  OPEN  (0252  mirror):  the  fill-lower  ratio
    is  5000/5001  <  1  -  the  058e  edge  margin  2e-4  is  EXACTLY
    1/5001. -/
theorem t4LD_wC_S1open : t4LD_r1 (wC : ℝ) < 1 := by
  dsimp only [t4LD_r1, t4LD_edgeDev]
  norm_num [wC]

theorem t4LD_wC_margin : (1 : ℝ) - (5000 : ℝ) / 5001 = (1 : ℝ) / 5001 := by
  norm_num

/-!  C  =  5001  S4  SIDE  CLOSED:  the  wire-upper  ratio  is
    5001/5000  >  1  -  the  058e/T4OffLC  half  of  the  knife edge. -/
theorem t4LD_wC_S4closed : 1 < t4LD_r3 (wC : ℝ) := by
  dsimp only [t4LD_r3, t4LD_edgeDev]
  norm_num [wC]

/-!  C  =  4999.5  =  9999/2  (in-tree  0123),  the  exact  mirror:
    S1  CLOSED  at  the  edge  -  the  ratio  is  10000/9999  >  1. -/
theorem t4LD_cPrim_S1closed : 1 < t4LD_r1 (t4LD_cPrim : ℝ) := by
  dsimp only [t4LD_r1, t4LD_edgeDev]
  norm_num [t4LD_cPrim]

/-!  C  =  4999.5  S4  SIDE  OPEN:  the  0123  wire  is  1.0001e-4
    OVER  the  edge  requirement  (1/9999  >  1/10000). -/
theorem t4LD_cPrim_S4open : (1 : ℝ) / (2 * (t4LD_cPrim : ℝ)) > (1 / 10000 : ℝ) := by
  dsimp only [t4LD_cPrim]
  norm_num

theorem t4LD_cPrim_overform :
    (1 : ℝ) / (2 * (t4LD_cPrim : ℝ)) =
      (1 + (1 : ℝ) / 9999) * (1 / 10000 : ℝ) := by
  dsimp only [t4LD_cPrim]
  field_simp
  ring

/-!  WIDEST  FACE  SLICE,  WORST  S1  SHORTFALL  (0252  map  edge,
    exact  rational  pins):  at  C  =  5001  and  d0  =  d0max  the
    fill-lower  ratio  1/(8  C  d0^2)  lies  between  1.7e-4  and
    1.8e-4  (measured  1.79286e-4  =  1/5577.7...). -/
theorem t4LD_d0max_worst :
    (17 : ℚ) / 100000 < (1 : ℚ) / (8 * t4LD_d0max ^ 2 * (wC : ℚ)) ∧
      (1 : ℚ) / (8 * t4LD_d0max ^ 2 * (wC : ℚ)) < (18 : ℚ) / 100000 := by
  constructor
  · have hw : (wC : ℚ) = 5001 := by norm_num [wC]
    rw [hw]
    norm_num [t4LD_d0max]
  · have hw : (wC : ℚ) = 5001 := by norm_num [wC]
    rw [hw]
    norm_num [t4LD_d0max]

/-!  THE  STRICT  PRODUCT  (the  0252  "0  points"  in  algebraic
    form):  with  a  shared  scale  w  >  0,  a  positive  subtracted
    tail  s  (the  off-line  T2+T3  part),  a  positive  additive  mass
    m1  (the  A4.3  P5  mass),  and  nonnegative  counterparts  s',  m2
    on  the  wire  side,  the  product  of  the  two  leg  ratios  is
    STRICTLY  below  1  -  so  the  measured  joint  closure  count  of
    0  carries  a  strict  margin,  not  a  knife  touch. -/
theorem t4LD_productStrict (w dev s s' m1 m2 : ℝ)
    (hw : 0 < w) (hdev : 0 ≤ dev) (hs : 0 ≤ s) (hs' : 0 ≤ s')
    (hm1 : 0 < m1) (hm2 : 0 ≤ m2) (hsW : s < w) :
    ((w - s) / (dev + m1)) * (dev / (w + s' + m2)) < 1 := by
  by_cases hdev0 : dev > 0
  · have hA : 0 < w - s := by linarith
    have hB : 0 < dev + m1 := by linarith
    have hC : 0 < w + s' + m2 := by linarith [hs', hm2]
    have hD : 0 < dev := hdev0
    rw [← sub_pos]
    field_simp [hA, hD, hB, hC]
    nlinarith [hA, hD, hs, hs', hm1, hm2,
      show 0 < w + s' + m2 by linarith [hs', hm2]]
  · have hdevz : dev = 0 := by
      obtain (hlt | heq) := lt_or_eq_of_le hdev
      · exfalso
        linarith [hlt, hdev0]
      · exact Eq.symm heq
    subst hdevz
    have h1 : 0 / (w + s' + m2) = 0 := zero_div (w + s' + m2)
    rw [h1, mul_zero]
    norm_num
