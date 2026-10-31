/-
  T4OffLB  -  day058b  anchor  (discovery  0244/0245):  exact
  rational  pins  of  the  G-hs3-left  left-flank  margin  map
  measured  in  scripts/rh/day058b_leftflank_margin.py
  (closed-form  machine-wire  arithmetic;  exact  norm_num  pins;
  no  zeta  evaluation,  no  zero-existence  statement,  no  RH
  claim).

  Three  pins,  all  exact:

  (1)  edgeLeverBounded:  the  0123  per-point  critical  scale
      t4l_schedA (99/200) * tPT2^(400/99)  at  the  band  edge
      and  the  frontier  height  tPT2  exceeds  the  uniform
      n4  scale  (C0 * t^4,  C0 = 3.1e7,  cf.  S4Strip.n4)  by
      a  factor  K  with  3 < K < 153/50  (= 3.06) -  the
      measured  "3.058x  edge  bump"  of  the  day058b
      fixed-power  lever  map.  Pinned  via  the  exact
      identity  K^99  =  (9999/2)^200  *  tPT2^4  /  C0^99.

  (2)  edgeFormalMarginBounds:  the  margin  of  the  FORMAL
      barrier  (t4l_barrier_edge:  wire  lower  bound  (1/15750)
      t^{-99/50}  vs  floor  pin  (1/9999) t^{-2})  at  tPT2
      lies  in  (112/100,  113/100) -  the  "~13%"  of  the
      0121  docstring  is  the  formal  LOWER-BOUND  margin,
      NOT  the  wire  margin  itself.

  (3)  edgeWireRatioBounds:  the  measured  wire  (the  n4  wire,
      real  scale  C0 * t^4,  exponent  -(99/200))  against  the
      floor  pin  (1/9999) t^{-2}  at  tPT2  lies  in  (3/2,
      9/5)  -  the  measured  value  1.73896 ...  of  the
      day058b  sweep  also  lies  in  (3/2,  9/5).

  The  middle-band  ISLAND  (d0  in  [0.008084,  0.025421],
  where  the  first  T4  term  falls  below  the  witness's
  OWN  floor,  T1/own  minimum  ~=  0.724  at  d0  ~=  0.016)
  and  its  FULL-WALL  survival  (mass  T2/T1 ~= 1e-17  at
  tPT2,  38%  headroom)  stay  measured  only  -  they  need
  exp-pins  on  the  pairfac  form  of  the  own  floor  -  and
  are  recorded  in  0244/0245  and  in  the  sweep  output.
-/
import Mathlib
import RhAttack.S1LowT
import RhAttack.S4Strip
import RhAttack.WinCount
import RhAttack.T4OffL

open Real

set_option linter.style.docString false
set_option linter.style.longLine false

/- =================================================================
   Bridge:  (x ^ a) ^ n  =  x ^ (a * n)  for  x  >  0,  n  :  Nat
   ================================================================= -/

private theorem powRpowNat (x : ℝ) (hx : 0 < x) (a : ℝ) (n : ℕ) :
    (x ^ a) ^ n = x ^ (a * (n : ℝ)) := by
  induction n with
  | zero =>
    norm_num
  | succ k ih =>
    rw [pow_succ, ih, Nat.cast_add_one]
    rw [show a * ((k : ℝ) + 1) = a * (k : ℝ) + a by ring]
    rw [← Real.rpow_add hx (a * (k : ℝ)) a]

/- =================================================================
   §1  the  edge-lever  ratio  K  (pin  1)
   ================================================================= -/

/-- The leading constant of the uniform n4 schedule (S4Strip.n4 t
    = ceil (C0 * t^4)). -/
def edgeC0 : ℝ := 31000000

/-- The 0244 edge-lever ratio: the 0123 per-point critical scale
    t4l_schedA (99/200) * tPT2^(400/99) divided by the uniform n4
    scale edgeC0 * tPT2^4 at the frontier height tPT2. -/
noncomputable def edgeLeverK : ℝ :=
    (t4l_schedA (99 / 200) * (WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) /
      (edgeC0 * (WinC.tPT2 : ℝ) ^ 4)

/-- The exact 99th power of K (the pin the norm_num comparisons
    run on):  K^99 = (9999/2)^200 * tPT2^4 / edgeC0^99. -/
theorem edgeLeverK99exact : edgeLeverK ^ 99 =
    (9999 / 2 : ℝ) ^ 200 * (WinC.tPT2 : ℝ) ^ 4 / (edgeC0 : ℝ) ^ 99 := by
  dsimp only [edgeLeverK, t4l_schedA]
  have hTpos : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  have hcpos : 0 < (edgeC0 : ℝ) := by norm_num [edgeC0]
  have hApos : 0 < (9999 / 2 : ℝ) := by norm_num
  have hdiv : (((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) /
      (edgeC0 * (WinC.tPT2 : ℝ) ^ 4)) ^ 99 =
      ((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ)) * (WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) ^
        99 / (edgeC0 * (WinC.tPT2 : ℝ) ^ 4) ^ 99 := by
    rw [div_pow]
  rw [hdiv]
  have hmul : ((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) ^ 99 =
      ((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ))) ^ 99 *
        ((WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) ^ 99 := by
    rw [mul_pow]
  rw [hmul]
  have hexp : ((1 / (99 / 200 : ℝ)) : ℝ) * (99 : ℝ) = (200 : ℝ) := by norm_num
  have hA99 : ((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ))) ^ 99 =
      (9999 / 2 : ℝ) ^ 200 := by
    have h1 : ((9999 / 2 : ℝ) ^ (1 / (99 / 200 : ℝ))) ^ 99 =
        (9999 / 2 : ℝ) ^ (((1 / (99 / 200 : ℝ)) : ℝ) * (99 : ℝ)) :=
      powRpowNat (9999 / 2 : ℝ) hApos ((1 / (99 / 200 : ℝ)) : ℝ) 99
    rw [h1, hexp]
    norm_num
  have hexp2 : (400 / 99 : ℝ) * (99 : ℝ) = (400 : ℝ) := by norm_num
  have hB99 : ((WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) ^ 99 =
      (WinC.tPT2 : ℝ) ^ 400 := by
    have h1 : ((WinC.tPT2 : ℝ) ^ (400 / 99 : ℝ)) ^ 99 =
        (WinC.tPT2 : ℝ) ^ ((400 / 99 : ℝ) * (99 : ℝ)) :=
      powRpowNat (WinC.tPT2 : ℝ) hTpos (400 / 99 : ℝ) 99
    rw [h1, hexp2]
    norm_num [WinC.tPT2]
  rw [hA99, hB99]
  have hden99 : (edgeC0 * (WinC.tPT2 : ℝ) ^ 4) ^ 99 =
      (edgeC0 : ℝ) ^ 99 * (WinC.tPT2 : ℝ) ^ 396 := by
    rw [mul_pow, ← pow_mul]
  have hnum : (WinC.tPT2 : ℝ) ^ 400 =
      (WinC.tPT2 : ℝ) ^ 396 * (WinC.tPT2 : ℝ) ^ 4 := by
    rw [show 400 = 396 + 4 by norm_num, pow_add]
  rw [hden99, hnum]
  field_simp [pow_ne_zero 396 (ne_of_gt hTpos),
    pow_ne_zero 99 (ne_of_gt hcpos)]

/-- (1) THE EDGE-LEVER BOUND:  3 < K < 153/50  (= 3.06;  the
    measured  3.058x).  Both  sides  reduce  to  exact  norm_num
    integer-power  comparisons  on  K^99  via  the  monotonicity
    of  the  99th  power  on  [0, ∞). -/
theorem edgeLeverBounded : 3 < edgeLeverK ∧ edgeLeverK < 153 / 50 := by
  have hK : 0 < edgeLeverK := by
    dsimp only [edgeLeverK, t4l_schedA, edgeC0, WinC.tPT2]
    positivity
  have h99 : (3 : ℝ) ^ 99 < (9999 / 2 : ℝ) ^ 200 * (WinC.tPT2 : ℝ) ^ 4 /
      (edgeC0 : ℝ) ^ 99 := by
    norm_num [WinC.tPT2, edgeC0]
  have h153 : (9999 / 2 : ℝ) ^ 200 * (WinC.tPT2 : ℝ) ^ 4 /
      (edgeC0 : ℝ) ^ 99 < (153 / 50 : ℝ) ^ 99 := by
    norm_num [WinC.tPT2, edgeC0]
  have hK99 : edgeLeverK ^ 99 =
      (9999 / 2 : ℝ) ^ 200 * (WinC.tPT2 : ℝ) ^ 4 / (edgeC0 : ℝ) ^ 99 :=
    edgeLeverK99exact
  constructor
  · by_contra hnc
    push_neg at hnc
    have hpow : edgeLeverK ^ 99 ≤ (3 : ℝ) ^ 99 :=
      pow_le_pow_left₀ (le_of_lt hK) hnc 99
    linarith [h99, hK99]
  · by_contra hnc
    push_neg at hnc
    have hpow : (153 / 50 : ℝ) ^ 99 ≤ edgeLeverK ^ 99 :=
      pow_le_pow_left₀ (by norm_num : 0 ≤ (153 : ℝ) / 50) hnc 99
    linarith [h153, hK99]

/- =================================================================
   §2  the  formal  margin  -  the  "~13%"  of  the  0121  docstring
   ================================================================= -/

/-- The formal barrier margin at tPT2: the ratio of the formal
    WIRE LOWER BOUND (1/15750) t^{-99/50} (t4l_term1lb of T4OffL)
    to the formal FLOOR PIN (1/9999) t^{-2} (t4l_floorPinEdge) -
    the quantity t4l_barrier_edge pins strictly above 1 for
    t >= 10^10. -/
noncomputable def edgeFormalMargin : ℝ :=
    (9999 / 15750 : ℝ) * (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)

/-- (2) THE FORMAL-MARGIN PIN:  1.12 < edgeFormalMargin < 1.13
    at  tPT2.  The  "~13%"  of  the  0121  docstring  is  THIS
    number:  the  formal  lower  bound  carries  ~13%  above
    the  formal  floor  pin,  while  the  measured  wire  margin
    (against  the  same  floor  pin)  is  1.73896 ...
    (edgeWireRatioBounds below). -/
theorem edgeFormalMarginBounds : 112 / 100 < edgeFormalMargin ∧
    edgeFormalMargin < 113 / 100 := by
  dsimp only [edgeFormalMargin]
  have hT : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  have hC1 : 0 < (112 / 100 : ℝ) * (15750 / 9999 : ℝ) := by norm_num
  have hC2 : 0 < (113 / 100 : ℝ) * (15750 / 9999 : ℝ) := by norm_num
  have hlo : ((112 / 100 : ℝ) * (15750 / 9999 : ℝ)) ^ 50 <
      (WinC.tPT2 : ℝ) := by
    norm_num [WinC.tPT2]
  have hup : (WinC.tPT2 : ℝ) <
      ((113 / 100 : ℝ) * (15750 / 9999 : ℝ)) ^ 50 := by
    norm_num [WinC.tPT2]
  have hroot (x : ℝ) (hx : 0 < x) : (x ^ (1 / 50 : ℝ)) ^ 50 = x := by
    have h1 : (x ^ (1 / 50 : ℝ)) ^ 50 = x ^ ((1 / 50 : ℝ) * (50 : ℝ)) :=
      powRpowNat x hx (1 / 50 : ℝ) 50
    have h2 : (1 / 50 : ℝ) * (50 : ℝ) = 1 := by norm_num
    rw [h1, h2, Real.rpow_one]
  have hrootT : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 =
      (WinC.tPT2 : ℝ) := hroot (WinC.tPT2 : ℝ) hT
  have hC1root : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) >
      (112 / 100 : ℝ) * (15750 / 9999 : ℝ) := by
    by_contra hnc
    push_neg at hnc
    have hpow : (WinC.tPT2 : ℝ) ≤
        (((112 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 := by
      have h1 : (WinC.tPT2 : ℝ) = ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 :=
        hrootT.symm
      have h2 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 ≤
          (((112 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 :=
        pow_le_pow_left₀ (Real.rpow_nonneg (le_of_lt hT) (1 / 50)) hnc 50
      calc (WinC.tPT2 : ℝ) = ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 := h1
        _ ≤ (((112 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 := h2
    linarith [hlo, hpow]
  have hC2root : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) <
      (113 / 100 : ℝ) * (15750 / 9999 : ℝ) := by
    by_contra hnc
    push_neg at hnc
    have hpow : (((113 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 ≤
        (WinC.tPT2 : ℝ) := by
      have h1 : (((113 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 ≤
          ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 :=
        pow_le_pow_left₀ hC2.le hnc 50
      have h2 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 =
          (WinC.tPT2 : ℝ) := hrootT
      calc (((113 / 100 : ℝ) * (15750 / 9999 : ℝ))) ^ 50 ≤
          ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 50 := h1
        _ = (WinC.tPT2 : ℝ) := h2
    linarith [hup, hpow]
  have hmul1 : (9999 / 15750 : ℝ) *
      ((112 / 100 : ℝ) * (15750 / 9999 : ℝ)) = 112 / 100 := by
    ring
  have hmul2 : (9999 / 15750 : ℝ) *
      ((113 / 100 : ℝ) * (15750 / 9999 : ℝ)) = 113 / 100 := by
    ring
  constructor
  · calc edgeFormalMargin =
          (9999 / 15750 : ℝ) * (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) := rfl
      _ > (9999 / 15750 : ℝ) *
          ((112 / 100 : ℝ) * (15750 / 9999 : ℝ)) :=
        mul_lt_mul_of_pos_left hC1root (by norm_num)
      _ = 112 / 100 := hmul1
  · calc edgeFormalMargin =
          (9999 / 15750 : ℝ) * (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) := rfl
      _ < (9999 / 15750 : ℝ) *
          ((113 / 100 : ℝ) * (15750 / 9999 : ℝ)) :=
        mul_lt_mul_of_pos_left hC2root (by norm_num)
      _ = 113 / 100 := hmul2

/- =================================================================
   §3  the  measured  wire  margin  (against  the  formal  floor  pin)
   ================================================================= -/

/-- The measured first T4 term (the n4 wire, real scale C0 t^4,
    exponent -(99/200)) against the formal floor pin (1/9999)
    t^{-2}, at tPT2.  The day058b sweep measured 1.73896 ...
    here  against  the  exact  pairfac  floor;  against  the
    floor  pin  this  ratio  is  the  wire-margin  skeleton
    pinned  in  edgeWireRatioBounds.  In  clean  form:
      (2/9999) * edgeWireRatio = tPT2^(1/50) / edgeC0^(99/200). -/
noncomputable def edgeWireRatio : ℝ :=
    (1 / 2 : ℝ) * (edgeC0 * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (9999 : ℝ) * (WinC.tPT2 : ℝ) ^ 2

/-- The clean form of the wire ratio (the pin the 200th-power
    comparisons run on). -/
theorem edgeWireRatioForm : (2 / 9999 : ℝ) * edgeWireRatio =
    (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^ (99 / 200 : ℝ) := by
  dsimp only [edgeWireRatio, edgeC0]
  have hT : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  have hc : 0 < (31000000 : ℝ) := by norm_num
  have h1 : (2 / 9999 : ℝ) * ((1 / 2 : ℝ) *
      ((31000000 : ℝ) * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (9999 : ℝ) * (WinC.tPT2 : ℝ) ^ 2) =
      ((31000000 : ℝ) * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ 2 := by
    ring
  have h2 : ((31000000 : ℝ) * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ 2 =
      (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) * (WinC.tPT2 : ℝ) ^ 2 *
      ((WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) := by
    rw [Real.mul_rpow (by norm_num : 0 ≤ (31000000 : ℝ)) (by
      positivity)]
    ring
  have h4r : (WinC.tPT2 : ℝ) ^ 4 = (WinC.tPT2 : ℝ) ^ (4 : ℝ) := by
    norm_num [WinC.tPT2]
  have hmulr : ((WinC.tPT2 : ℝ) ^ (4 : ℝ)) ^ (-(99 / 200 : ℝ)) =
      (WinC.tPT2 : ℝ) ^ ((4 : ℝ) * (-(99 / 200 : ℝ))) := by
    rw [← Real.rpow_mul (le_of_lt hT) (4 : ℝ) (-(99 / 200 : ℝ))]
  have hexp : (4 : ℝ) * (-(99 / 200 : ℝ)) = (-(99 / 50 : ℝ)) := by
    norm_num
  have h3 : (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) * (WinC.tPT2 : ℝ) ^ 2 *
      (WinC.tPT2 : ℝ) ^ (-(99 / 50 : ℝ)) =
      (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ (2 + (-(99 / 50 : ℝ))) := by
    have ht2 : (WinC.tPT2 : ℝ) ^ 2 = (WinC.tPT2 : ℝ) ^ (2 : ℝ) := by
      norm_num [WinC.tPT2]
    rw [ht2, mul_assoc, ← Real.rpow_add hT (2 : ℝ) (-(99 / 50 : ℝ))]
  have hexp2 : 2 + (-(99 / 50 : ℝ)) = (1 / 50 : ℝ) := by norm_num
  have hinv : (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) =
      ((31000000 : ℝ) ^ (99 / 200 : ℝ))⁻¹ := by
    rw [Real.rpow_neg (by norm_num : 0 ≤ (31000000 : ℝ))]
  have h4 : (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ (2 + (-(99 / 50 : ℝ))) =
      (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (31000000 : ℝ) ^ (99 / 200 : ℝ) := by
    rw [hexp2, hinv]
    field_simp [Real.rpow_pos_of_pos hc (99 / 200)]
  calc (2 / 9999 : ℝ) * ((1 / 2 : ℝ) *
      ((31000000 : ℝ) * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (9999 : ℝ) * (WinC.tPT2 : ℝ) ^ 2) =
      ((31000000 : ℝ) * (WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) *
      (WinC.tPT2 : ℝ) ^ 2 := h1
    _ = (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) * (WinC.tPT2 : ℝ) ^ 2 *
        ((WinC.tPT2 : ℝ) ^ 4) ^ (-(99 / 200 : ℝ)) := h2
    _ = (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) * (WinC.tPT2 : ℝ) ^ 2 *
        (WinC.tPT2 : ℝ) ^ (-(99 / 50 : ℝ)) := by
      rw [h4r, hmulr, hexp]
    _ = (31000000 : ℝ) ^ (-(99 / 200 : ℝ)) *
        (WinC.tPT2 : ℝ) ^ (2 + (-(99 / 50 : ℝ))) := h3
    _ = (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (31000000 : ℝ) ^ (99 / 200 : ℝ) :=
      h4

/-- (3) THE WIRE-MARGIN PIN:  3/2 < edgeWireRatio < 9/5  at  tPT2
    (measured  1.73896 ...  in  the  day058b  sweep  against
    the  exact  pairfac  floor;  1.73896 ...  also  lies  in
    (3/2,  9/5),  and  both  endpoints  pin  the  wire-margin
    skeleton  exactly).  The  comparisons  are  exact
    200th-power  norm_num  statements:
      r > 3/2  <->  tPT2^4 * 9999^200 > 3^200 * C0^99
      r < 9/5  <->  tPT2^4 * 5555^200 < 2^200 * C0^99. -/
theorem edgeWireRatioBounds : (3 / 2 : ℝ) < edgeWireRatio ∧
    edgeWireRatio < 9 / 5 := by
  have hT : 0 < (WinC.tPT2 : ℝ) := by norm_num [WinC.tPT2]
  have hc : 0 < (edgeC0 : ℝ) := by norm_num [edgeC0]
  have hform : (2 / 9999 : ℝ) * edgeWireRatio =
      (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^ (99 / 200 : ℝ) :=
    edgeWireRatioForm
  have hrpos : 0 < edgeWireRatio := by
    dsimp only [edgeWireRatio, edgeC0, WinC.tPT2]
    positivity
  have hrform : edgeWireRatio = (9999 / 2 : ℝ) *
      ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) := by
    have h1 : edgeWireRatio = (9999 / 2 : ℝ) *
        ((2 / 9999 : ℝ) * edgeWireRatio) := by
      ring
    rw [h1, hform]
  have hC0p : 0 < (edgeC0 : ℝ) ^ (99 / 200 : ℝ) :=
    Real.rpow_pos_of_pos hc (99 / 200)
  have hlo : (WinC.tPT2 : ℝ) ^ 4 * (9999 : ℝ) ^ 200 >
      (3 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 := by
    norm_num [WinC.tPT2, edgeC0]
  have hup : (WinC.tPT2 : ℝ) ^ 4 * (5555 : ℝ) ^ 200 <
      (2 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 := by
    norm_num [WinC.tPT2, edgeC0]
  have hexp : ((edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^ 200 =
      (edgeC0 : ℝ) ^ 99 := by
    have h1 : ((edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^ 200 =
        (edgeC0 : ℝ) ^ ((99 / 200 : ℝ) * (200 : ℝ)) :=
      powRpowNat (edgeC0 : ℝ) hc (99 / 200 : ℝ) 200
    have h2 : (99 / 200 : ℝ) * (200 : ℝ) = 99 := by norm_num
    rw [h1, h2]
    norm_num [edgeC0]
  have hT4 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 =
      (WinC.tPT2 : ℝ) ^ 4 := by
    have h1 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 =
        (WinC.tPT2 : ℝ) ^ ((1 / 50 : ℝ) * (200 : ℝ)) :=
      powRpowNat (WinC.tPT2 : ℝ) hT (1 / 50 : ℝ) 200
    have h2 : (1 / 50 : ℝ) * (200 : ℝ) = 4 := by norm_num
    rw [h1, h2]
    norm_num [WinC.tPT2]
  -- wire  above  the  3/2  pin:
  have hstep_lo : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^
      (99 / 200 : ℝ) > 3 / 9999 := by
    by_contra hnc
    push_neg at hnc
    have h1 : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) ≤
        (3 / 9999 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ) :=
      (div_le_iff₀ hC0p).mp hnc
    have h2 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 ≤
        ((3 / 9999 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^ 200 :=
      pow_le_pow_left₀ (Real.rpow_nonneg (le_of_lt hT) (1 / 50)) h1 200
    have h3 : ((3 / 9999 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^
        200 = (3 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 / (9999 : ℝ) ^ 200 := by
      rw [mul_pow, div_pow, hexp]
      ring_nf
    rw [hT4, h3] at h2
    have h4 : (WinC.tPT2 : ℝ) ^ 4 * (9999 : ℝ) ^ 200 ≤
        (3 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 := by
      have h5 : 0 < (9999 : ℝ) ^ 200 := by positivity
      calc (WinC.tPT2 : ℝ) ^ 4 * (9999 : ℝ) ^ 200 ≤
          ((3 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 / (9999 : ℝ) ^ 200) *
          (9999 : ℝ) ^ 200 :=
          mul_le_mul_of_nonneg_right h2 (by positivity)
        _ = (3 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 := by
          field_simp [h5.ne']
    linarith [hlo, h4]
  -- wire  below  the  9/5  pin:
  have hstep_hi : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^
      (99 / 200 : ℝ) < 2 / 5555 := by
    by_contra hnc
    push_neg at hnc
    have h1 : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) ≥
        (2 / 5555 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ) := by
      have htmp : (WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) =
          ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^
            (99 / 200 : ℝ)) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ) := by
        field_simp [hC0p.ne']
      rw [htmp]
      exact mul_le_mul_of_nonneg_right hnc hC0p.le
    have h2 : ((2 / 5555 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^
        200 ≤ (WinC.tPT2 : ℝ) ^ 4 := by
      have h3 : ((2 / 5555 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^
          200 ≤ ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 :=
        pow_le_pow_left₀
          (by positivity : 0 ≤ (2 / 5555 : ℝ) *
            (edgeC0 : ℝ) ^ (99 / 200 : ℝ))
          (by linarith [h1]) 200
      have h4 : ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 =
          (WinC.tPT2 : ℝ) ^ 4 := hT4
      calc ((2 / 5555 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^ 200 ≤
          ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ)) ^ 200 := h3
        _ = (WinC.tPT2 : ℝ) ^ 4 := h4
    have h3 : ((2 / 5555 : ℝ) * (edgeC0 : ℝ) ^ (99 / 200 : ℝ)) ^
        200 = (2 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 / (5555 : ℝ) ^ 200 := by
      rw [mul_pow, div_pow, hexp]
      ring_nf
    rw [h3] at h2
    have h4 : (2 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 ≤
        (WinC.tPT2 : ℝ) ^ 4 * (5555 : ℝ) ^ 200 := by
      have h5 : 0 < (5555 : ℝ) ^ 200 := by positivity
      calc (2 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 =
          ((2 : ℝ) ^ 200 * (edgeC0 : ℝ) ^ 99 / (5555 : ℝ) ^ 200) *
          (5555 : ℝ) ^ 200 := by
            field_simp [h5.ne']
        _ ≤ (WinC.tPT2 : ℝ) ^ 4 * (5555 : ℝ) ^ 200 :=
          mul_le_mul_of_nonneg_right h2 (by positivity)
    linarith [hup, h4]
  constructor
  · rw [hrform]
    have h1 : (9999 / 2 : ℝ) * (3 / 9999) = 3 / 2 := by norm_num
    have h2 : (9999 / 2 : ℝ) *
        ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^ (99 / 200 : ℝ))
      > (9999 / 2 : ℝ) * (3 / 9999) :=
      mul_lt_mul_of_pos_left hstep_lo (by norm_num)
    linarith [h1, h2]
  · rw [hrform]
    have h1 : (9999 / 2 : ℝ) * (2 / 5555) = 9 / 5 := by norm_num
    have h2 : (9999 / 2 : ℝ) *
        ((WinC.tPT2 : ℝ) ^ (1 / 50 : ℝ) / (edgeC0 : ℝ) ^ (99 / 200 : ℝ))
      < (9999 / 2 : ℝ) * (2 / 5555) :=
      mul_lt_mul_of_pos_left hstep_hi (by norm_num)
    linarith [h1, h2]
