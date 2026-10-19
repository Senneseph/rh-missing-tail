/-
  T4OffD - G-hs3-i, ENDPOINT FORM: the strip-band domination.

  The off-line lifted T4 wall (T4Off.p4_T4_bound_gen applied at the
  canonical strip point (1/2 + d0) + it0 with the t^4 n-schedule) is
  dominated TERMWISE by the on-line B-wire P8Floor.p8_B t0 (S4Strip.n4 t0):
    term 1  by the extra damping n^(-d0) (d0 >= 1/200);
    term 2  by the norm ratio  (<= 6/5)  against  n^(-d0)
            (>= 6/5  at  the  band  edge,  via  the  200th-root wall);
    term 3  by  the  product  ratio  (<=  (2001/2000)^3)  against
            the  wall  constant  540  vs  216  (factor  2  +  the
            (5/2 + d0)  denominator),  with  the  damping  constant
            c^3 * n^-d0  <=  (2/5)*(5/2 + d0)  on  the  strip  band.

  So  the  off-line  EM  scale  at  an  off-pair  zero  (the  hs3
  side)  is  below  the  endpoint  B-wire  term  for  every
  1000  <=  t0  and  1/200  <=  d0  <=  1/2.  G-hs3-i  is  thereby
  closed  at  the  endpoint  level,  not  just  at  the  component
  level  (T4Off.p4_T4_bound_gen).  G-hs3-ii  (the  P6  finite-kernel
  gap  /  Mr  wire  off  the  line)  and  G-hs3-iii  (margin
  composition)  remain  open  by  design.
-/
import Mathlib
import RhAttack.P4Tail
import RhAttack.P4Limit
import RhAttack.P8Floor
import RhAttack.S4Strip
import RhAttack.T4Off

open Real Set
open scoped Topology

set_option maxHeartbeats 1000000

/-- The canonical strip point, off the line to the right (Re = 1/2 + d0). -/
noncomputable def t4o_sOff (t0 d0 : ℝ) : ℂ :=
    ((1 / 2 : ℝ) : ℂ) + (d0 : ℂ) + (t0 : ℂ) * Complex.I

/-- The on-line point, exactly the argument shape of P8Floor.p8_B. -/
noncomputable def t4o_sOn (t0 : ℝ) : ℂ :=
    ((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I

/-- sOff in the a + b*I two-term shape. -/
theorem t4o_sOff_shape (t0 d0 : ℝ) :
    t4o_sOff t0 d0 = ((1 / 2 + d0 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
  dsimp [t4o_sOff]
  rw [← Complex.ofReal_add]

/-- sOff minus sOn is the real translation (d0 : ℂ). -/
theorem t4o_sOff_sub (t0 d0 : ℝ) : t4o_sOff t0 d0 = t4o_sOn t0 + (d0 : ℂ) := by
  dsimp [t4o_sOff, t4o_sOn]
  ring

/-- sOn shifted by a real. -/
theorem t4o_sOn_add (t0 k : ℝ) :
    t4o_sOn t0 + (k : ℂ) = ((1 / 2 + k : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
  dsimp [t4o_sOn]
  rw [show ((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I + (k : ℂ) =
        ((1 / 2 : ℝ) : ℂ) + (k : ℂ) + (t0 : ℂ) * Complex.I by ring]
  rw [← Complex.ofReal_add]

/-- Norm-squared of a real plus complex-times-I. -/
theorem t4o_normsq (a b : ℝ) :
    ‖((a : ℝ) : ℂ) + (b : ℂ) * Complex.I‖ ^ 2 = a ^ 2 + b ^ 2 := by
  rw [Complex.sq_norm, Complex.normSq]
  simp [Complex.ext_iff,
    Complex.ofReal_add, Complex.ofReal_mul, Complex.add_re, Complex.add_im,
    Complex.mul_re, Complex.mul_im, Complex.I_re, Complex.I_im,
    Complex.ofReal_re, Complex.ofReal_im]
  ring

/-- Norm-squared of the on-line point. -/
theorem t4o_normsq_on (t : ℝ) : ‖t4o_sOn t‖ ^ 2 = (1 / 4 : ℝ) + t ^ 2 := by
  dsimp [t4o_sOn]
  rw [t4o_normsq (1 / 2 : ℝ) t]
  ring

/-- Norm-squared of the off-line point. -/
theorem t4o_normsq_off (t0 d0 : ℝ) :
    ‖t4o_sOff t0 d0‖ ^ 2 = (1 / 2 + d0) ^ 2 + t0 ^ 2 := by
  simpa [t4o_sOff_shape] using (t4o_normsq (1 / 2 + d0) t0)

/-- The strip n-schedule positivity: 0 < S4Strip.n4 t for t >= 1000. -/
theorem t4o_n4pos (t : ℝ) (ht : 1000 ≤ t) : 0 < S4Strip.n4 t := by
  have hx : (1 : ℝ) ≤ 31000000 * t ^ 4 := by
    have h4 : 1000 ^ 4 ≤ t ^ 4 := by gcongr
    have hlow : (1 : ℝ) ≤ 31000000 * 1000 ^ 4 := by norm_num
    have hlow2 : 31000000 * 1000 ^ 4 ≤ 31000000 * t ^ 4 :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    linarith [hlow, hlow2]
  have hceil : 31000000 * t ^ 4 ≤ (S4Strip.n4 t : ℝ) := by
    dsimp only [S4Strip.n4]
    exact Nat.le_ceil _
  have hNN : 0 < (S4Strip.n4 t : ℝ) := by linarith [hx, hceil]
  have hN0 : S4Strip.n4 t ≠ 0 := by
    intro hn
    have hcast : (S4Strip.n4 t : ℝ) = 0 := by simpa using hn
    linarith [hNN, hcast]
  exact Nat.pos_of_ne_zero hN0

/-- The strip n-schedule floor: (n4 t : ℝ) >= 3.1e7 * t^4. -/
theorem t4o_n4floor (t : ℝ) (ht : 1000 ≤ t) :
    (S4Strip.n4 t : ℝ) ≥ 31000000 * t ^ 4 := by
  dsimp only [S4Strip.n4]
  exact Nat.le_ceil _

/-- n4 at the band edge dominates (6/5)^200 (exact check:
    3.1e7 * 1000^4 = 3.1e19 >> (6/5)^200). -/
theorem t4o_n4_ge_65_200 (t : ℝ) (ht : 1000 ≤ t) :
    (S4Strip.n4 t : ℝ) ≥ (6 / 5 : ℝ) ^ (200 : ℕ) := by
  have h4 : 1000 ^ 4 ≤ t ^ 4 := by gcongr
  have hfloor : (S4Strip.n4 t : ℝ) ≥ 31000000 * t ^ 4 := t4o_n4floor t ht
  have hmid : 31000000 * t ^ 4 ≥ 31000000 * 1000 ^ 4 :=
    mul_le_mul_of_nonneg_left h4 (by norm_num)
  have hfin : (31000000 * 1000 ^ 4 : ℝ) ≥ (6 / 5 : ℝ) ^ (200 : ℕ) := by norm_num
  linarith [hfloor, hmid, hfin]

/-  TERM  2  OF  THE  WALL  (norm  ratio +  the  200th-root  fact).
    For  the  strip  band:
      ‖sOff‖ · n4R^(-d0) <= ‖sOn‖,
    from  ‖sOff‖ <= (6/5)·‖sOn‖  and  n4R^(1/200) >= 6/5.  -/
private theorem t4o_term2_norm_body (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2)
    (n4R : ℝ) (hn4pos : 0 < n4R) (hbase : (6 / 5 : ℝ) ^ (200 : ℕ) ≤ n4R) :
    ‖t4o_sOff t0 d0‖ * n4R ^ (-d0) ≤ ‖t4o_sOn t0‖ := by
  -- ‖sOff‖ <= (6/5) ‖sOn‖
  have hOff2 : ‖t4o_sOff t0 d0‖ ^ 2 ≤ (36 / 25 : ℝ) * t0 ^ 2 := by
    have hsq : (1 / 2 + d0) ^ 2 ≤ 1 := by nlinarith [hdlo, hd]
    have ht2 : 1 ≤ t0 ^ 2 := by nlinarith [ht0]
    have hA : ‖t4o_sOff t0 d0‖ ^ 2 = (1 / 2 + d0) ^ 2 + t0 ^ 2 :=
      t4o_normsq_off t0 d0
    nlinarith [hA, hsq, ht2]
  have hOn2 : t0 ^ 2 ≤ ‖t4o_sOn t0‖ ^ 2 := by
    have hB : ‖t4o_sOn t0‖ ^ 2 = (1 / 4 : ℝ) + t0 ^ 2 := t4o_normsq_on t0
    nlinarith [hB]
  have hmid : ‖t4o_sOff t0 d0‖ ^ 2 ≤ (6 / 5 : ℝ) ^ 2 * ‖t4o_sOn t0‖ ^ 2 := by
    calc ‖t4o_sOff t0 d0‖ ^ 2 ≤ (36 / 25 : ℝ) * t0 ^ 2 := hOff2
      _ = (6 / 5 : ℝ) ^ 2 * t0 ^ 2 := by ring
      _ ≤ (6 / 5 : ℝ) ^ 2 * ‖t4o_sOn t0‖ ^ 2 :=
        mul_le_mul_of_nonneg_left hOn2 (by norm_num : 0 ≤ (6 / 5 : ℝ) ^ 2)
  have hC : ‖t4o_sOff t0 d0‖ ≤ (6 / 5 : ℝ) * ‖t4o_sOn t0‖ := by
    calc ‖t4o_sOff t0 d0‖
        = Real.sqrt (‖t4o_sOff t0 d0‖ ^ 2) :=
          (Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOff t0 d0‖)).symm
      _ ≤ Real.sqrt ((6 / 5 : ℝ) ^ 2 * ‖t4o_sOn t0‖ ^ 2) :=
        Real.sqrt_le_sqrt hmid
      _ = Real.sqrt (((6 / 5 : ℝ) * ‖t4o_sOn t0‖) ^ 2) := by ring
      _ = (6 / 5 : ℝ) * ‖t4o_sOn t0‖ :=
        Real.sqrt_sq (by positivity : 0 ≤ (6 / 5 : ℝ) * ‖t4o_sOn t0‖)
  have hCcheck : ‖t4o_sOff t0 d0‖ ≤ (6 / 5 : ℝ) * ‖t4o_sOn t0‖ := hC
  have hstepfinal1check : ‖t4o_sOff t0 d0‖ * n4R ^ (-d0) ≤
      ((6 / 5 : ℝ) * ‖t4o_sOn t0‖) * n4R ^ (-d0) :=
    mul_le_mul_of_nonneg_right hCcheck (by positivity : 0 ≤ n4R ^ (-d0))
  -- n4R^(1/200) >= 6/5  (200th-root of  n4R >= (6/5)^200)
  have hnd : n4R ^ d0 ≥ 6 / 5 := by
    have hn1 : 1 ≤ n4R := by nlinarith [hbase, show 1 ≤ (6 / 5 : ℝ) ^ (200 : ℕ) from by norm_num]
    have hstep : n4R ^ (1 / 200 : ℝ) ≤ n4R ^ d0 :=
      rpow_le_rpow_of_exponent_le hn1 hdlo
    have hroot : n4R ^ (1 / 200 : ℝ) ≥ 6 / 5 := by
      by_contra h
      push_neg at h
      have hposa : 0 < n4R ^ (1 / 200 : ℝ) := by positivity
      have hlt2 : (n4R ^ (1 / 200 : ℝ)) ^ (200 : ℝ) < (6 / 5 : ℝ) ^ (200 : ℝ) := by
        apply rpow_lt_rpow
        · exact le_of_lt hposa
        · exact h
        · norm_num
      have h200 : (n4R ^ (1 / 200 : ℝ)) ^ (200 : ℝ) = n4R := by
        rw [← (rpow_mul (le_of_lt hn4pos) (1 / 200 : ℝ) (200 : ℝ))]
        norm_num
      have hlhs : n4R < (6 / 5 : ℝ) ^ (200 : ℝ) :=
        lt_of_le_of_lt (le_of_eq h200.symm) hlt2
      have hconv1 : (6 / 5 : ℝ) ^ (200 : ℝ) = (6 / 5 : ℝ) ^ (↑(200 : ℕ) : ℝ) := by
        rw [show (200 : ℝ) = (↑(200 : ℕ) : ℝ) from by norm_num]
      have hconv2 : (6 / 5 : ℝ) ^ (↑(200 : ℕ) : ℝ) = (6 / 5 : ℝ) ^ (200 : ℕ) :=
        rpow_natCast (6 / 5 : ℝ) 200
      linarith [hlhs, hconv1, hconv2, hbase]
    linarith [hstep, hroot]
  have hstepfinal1 : ‖t4o_sOff t0 d0‖ * n4R ^ (-d0) ≤
      ((6 / 5 : ℝ) * ‖t4o_sOn t0‖) * n4R ^ (-d0) :=
    mul_le_mul_of_nonneg_right hC (by positivity : 0 ≤ n4R ^ (-d0))
  have hstep2eq : ((6 / 5 : ℝ) * ‖t4o_sOn t0‖) * n4R ^ (-d0) =
      ‖t4o_sOn t0‖ * ((6 / 5 : ℝ) * n4R ^ (-d0)) := by ring
  have hx : (6 / 5 : ℝ) * n4R ^ (-d0) ≤ 1 := by
    have hA : 0 < n4R ^ d0 := by positivity
    have hinv : n4R ^ (-d0) = (n4R ^ d0)⁻¹ := by
      rw [show (-d0 : ℝ) = -(d0 : ℝ) by ring, rpow_neg (le_of_lt hn4pos)]
    rw [hinv]
    field_simp [hA]
    nlinarith [hnd]
  have hnn : 0 ≤ ‖t4o_sOn t0‖ := by positivity
  have hstep3 : ‖t4o_sOn t0‖ * ((6 / 5 : ℝ) * n4R ^ (-d0)) ≤ ‖t4o_sOn t0‖ := by
    nlinarith [hx, hnn]
  exact le_trans (le_trans hstepfinal1 (le_of_eq hstep2eq)) hstep3

/-- Term 2 of the wall: (‖sOff‖/12)·n^-(3/2+d0) <= (‖sOn‖/12)·n^-(3/2). -/
theorem t4o_T2 (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2) :
    (‖t4o_sOff t0 d0‖ / 12) * (S4Strip.n4 t0 : ℝ) ^ (-(3 / 2 + d0)) ≤
      (‖t4o_sOn t0‖ / 12) * (S4Strip.n4 t0 : ℝ) ^ (-3 / 2 : ℝ) := by
  let n4R : ℝ := (S4Strip.n4 t0 : ℝ)
  have hn4pos : 0 < n4R := by
    dsimp only [n4R]
    exact Nat.cast_pos.mpr (t4o_n4pos t0 ht0)
  have hbase : (6 / 5 : ℝ) ^ (200 : ℕ) ≤ n4R := t4o_n4_ge_65_200 t0 ht0
  have hcore := t4o_term2_norm_body t0 d0 ht0 hdlo hd n4R hn4pos hbase
  have hndiv : n4R ^ (-(3 / 2 + d0) : ℝ) = n4R ^ (-3 / 2 : ℝ) * n4R ^ (-d0) := by
    dsimp only [n4R]
    rw [show (-(3 / 2 + d0) : ℝ) = (-3 / 2 : ℝ) + (-d0 : ℝ) by ring,
      rpow_add hn4pos]
  rw [hndiv]
  have hcore2 : (‖t4o_sOff t0 d0‖ * n4R ^ (-d0)) * n4R ^ (-3 / 2 : ℝ) ≤
      ‖t4o_sOn t0‖ * n4R ^ (-3 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_right hcore (by positivity : 0 ≤ n4R ^ (-3 / 2 : ℝ))
  calc (‖t4o_sOff t0 d0‖ / 12) * (n4R ^ (-3 / 2 : ℝ) * n4R ^ (-d0))
      = (1 / 12 : ℝ) * ((‖t4o_sOff t0 d0‖ * n4R ^ (-d0)) * n4R ^ (-3 / 2 : ℝ)) := by ring
    _ ≤ (1 / 12 : ℝ) * (‖t4o_sOn t0‖ * n4R ^ (-3 / 2 : ℝ)) :=
      mul_le_mul_of_nonneg_left hcore2 (by norm_num : 0 ≤ (1 / 12 : ℝ))
    _ = (‖t4o_sOn t0‖ / 12) * n4R ^ (-3 / 2 : ℝ) := by ring

/-- Term 1 of the wall: (1/2)·n^-(1/2+d0) <= (1/2)·n^-(1/2). -/
theorem t4o_T1 (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd : 0 ≤ d0) :
    (1 / 2 : ℝ) * (S4Strip.n4 t0 : ℝ) ^ (-(1 / 2 + d0)) ≤
      (1 / 2 : ℝ) * (S4Strip.n4 t0 : ℝ) ^ (-1 / 2 : ℝ) := by
  let n4R : ℝ := (S4Strip.n4 t0 : ℝ)
  have hn1 : 1 ≤ n4R := by
    dsimp only [n4R]
    have h := t4o_n4_ge_65_200 t0 ht0
    have hpos : 1 ≤ (6 / 5 : ℝ) ^ (200 : ℕ) := by norm_num
    linarith [h, hpos]
  have hexp : (-(1 / 2 + d0) : ℝ) ≤ (-1 / 2 : ℝ) := by
    ring_nf
    nlinarith [hd]
  exact mul_le_mul_of_nonneg_left
    (rpow_le_rpow_of_exponent_le hn1 hexp) (by norm_num : 0 ≤ (1 / 2 : ℝ))

/-  TERM  3  OF  THE  WALL:  the  off-line  triple  product  norm,
    damped  by  n^-(5/2+d0)  and  divided  by  (5/2+d0),  is  below
    the  on-line  wall  tail  term.  The  constant  540  does  most
    of  the  work:  the  product  ratio  is  at  most  (2001/2000)^3
    =  1.0015...,  while  (2/5)*(5/2+d0)  is  at  least  2.  -/
theorem t4o_T3 (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2) :
    (Real.sqrt 3 / 216) *
        ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
        (S4Strip.n4 t0 : ℝ) ^ (-(5 / 2 + d0)) / (5 / 2 + d0) ≤
      (Real.sqrt 3 / 540) *
        ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
        (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := by
  let n4R : ℝ := (S4Strip.n4 t0 : ℝ)
  have hn4pos : 0 < n4R := by
    dsimp only [n4R]
    exact Nat.cast_pos.mpr (t4o_n4pos t0 ht0)
  have hd0 : 0 ≤ d0 := by linarith [hdlo]
  have hN4ge1 : 1 ≤ (S4Strip.n4 t0 : ℝ) := by
    have hfloor : (S4Strip.n4 t0 : ℝ) ≥ 31000000 * t0 ^ 4 :=
      t4o_n4floor t0 ht0
    have hsq : (1000 : ℝ) ^ 2 ≤ t0 ^ 2 := by
      have h1000 : (1000 : ℝ) ≤ t0 := ht0
      nlinarith
    have h4 : (1000 : ℝ) ^ 4 ≤ t0 ^ 4 := by nlinarith [hsq]
    have hmid : 31000000 * 1000 ^ 4 ≤ 31000000 * t0 ^ 4 :=
      mul_le_mul_of_nonneg_left h4 (by norm_num)
    have hnum : 1 ≤ 31000000 * 1000 ^ 4 := by norm_num
    nlinarith [hfloor, hmid, hnum]
  --  per-factor:  ‖sOff + k‖ <= ‖sOn + k‖ + d0,  k = 0, 1, 2
  have heqN0 : ‖t4o_sOff t0 d0‖ = ‖t4o_sOn t0 + (d0 : ℂ)‖ :=
    congrArg (fun z : ℂ => ‖z‖) (t4o_sOff_sub t0 d0)
  have htri0 : ‖t4o_sOn t0 + (d0 : ℂ)‖ ≤ ‖t4o_sOn t0‖ + ‖(d0 : ℂ)‖ :=
    norm_add_le (t4o_sOn t0) (d0 : ℂ)
  have habs0 : ‖(d0 : ℂ)‖ ≤ d0 := by
    have habs0eq : ‖(d0 : ℂ)‖ = |d0| := RCLike.norm_ofReal d0
    have habs0ineq : |d0| ≤ d0 := by
      rw [abs_of_nonneg (by linarith [hd0])]
    linarith [habs0eq, habs0ineq]
  have h0 : ‖t4o_sOff t0 d0‖ ≤ ‖t4o_sOn t0‖ + d0 := by
    linarith [heqN0, htri0, habs0]
  have heq1 : t4o_sOff t0 d0 + 1 = (t4o_sOn t0 + 1) + (d0 : ℂ) := by
    dsimp [t4o_sOff, t4o_sOn]
    ring
  have heqN1 : ‖t4o_sOff t0 d0 + 1‖ = ‖(t4o_sOn t0 + 1) + (d0 : ℂ)‖ :=
    congrArg (fun z : ℂ => ‖z‖) heq1
  have htri1 : ‖(t4o_sOn t0 + 1) + (d0 : ℂ)‖ ≤ ‖t4o_sOn t0 + 1‖ + ‖(d0 : ℂ)‖ :=
    norm_add_le (t4o_sOn t0 + 1) (d0 : ℂ)
  have habs1 : ‖(d0 : ℂ)‖ ≤ d0 := by
    have habs1eq : ‖(d0 : ℂ)‖ = |d0| := RCLike.norm_ofReal d0
    have habs1ineq : |d0| ≤ d0 := by
      rw [abs_of_nonneg (by linarith [hd0])]
    linarith [habs1eq, habs1ineq]
  have h1b : ‖t4o_sOff t0 d0 + 1‖ ≤ ‖t4o_sOn t0 + 1‖ + d0 := by
    linarith [heqN1, htri1, habs1]
  have heq2 : t4o_sOff t0 d0 + 2 = (t4o_sOn t0 + 2) + (d0 : ℂ) := by
    dsimp [t4o_sOff, t4o_sOn]
    ring
  have heqN2 : ‖t4o_sOff t0 d0 + 2‖ = ‖(t4o_sOn t0 + 2) + (d0 : ℂ)‖ :=
    congrArg (fun z : ℂ => ‖z‖) heq2
  have htri2 : ‖(t4o_sOn t0 + 2) + (d0 : ℂ)‖ ≤ ‖t4o_sOn t0 + 2‖ + ‖(d0 : ℂ)‖ :=
    norm_add_le (t4o_sOn t0 + 2) (d0 : ℂ)
  have habs2 : ‖(d0 : ℂ)‖ ≤ d0 := by
    have habs2eq : ‖(d0 : ℂ)‖ = |d0| := RCLike.norm_ofReal d0
    have habs2ineq : |d0| ≤ d0 := by
      rw [abs_of_nonneg (by linarith [hd0])]
    linarith [habs2eq, habs2ineq]
  have h2b : ‖t4o_sOff t0 d0 + 2‖ ≤ ‖t4o_sOn t0 + 2‖ + d0 := by
    linarith [heqN2, htri2, habs2]
  --  the  1/2000  bound:  d0 <= 1000/2000 <= |sOn + k|/2000
  have hN0' : (1 / 2000 : ℝ) * t0 ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0‖ := by
    have hB : ‖t4o_sOn t0‖ ^ 2 = (1 / 4 : ℝ) + t0 ^ 2 := t4o_normsq_on t0
    have ht0n : 0 ≤ t0 := by linarith [ht0]
    have hstep1 : Real.sqrt (t0 ^ 2) ≤ Real.sqrt (‖t4o_sOn t0‖ ^ 2) :=
      Real.sqrt_le_sqrt (by nlinarith [hB])
    have hstep2 : Real.sqrt (‖t4o_sOn t0‖ ^ 2) = ‖t4o_sOn t0‖ :=
      Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOn t0‖)
    have hbnd : t0 ≤ ‖t4o_sOn t0‖ := by
      have hsq : t0 ^ 2 ≤ ‖t4o_sOn t0‖ ^ 2 := by nlinarith [hB]
      have hle : t0 ≤ Real.sqrt (‖t4o_sOn t0‖ ^ 2) :=
        (Real.le_sqrt ht0n (by positivity : 0 ≤ ‖t4o_sOn t0‖ ^ 2)).mpr hsq
      linarith [hstep1, hstep2, hle]
    exact mul_le_mul_of_nonneg_left hbnd (by norm_num)
  have hdd0 : d0 ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0‖ := by
    calc d0 ≤ 1 / 2 := hd
      _ = (1 / 2000 : ℝ) * 1000 := by norm_num
      _ ≤ (1 / 2000 : ℝ) * t0 :=
        mul_le_mul_of_nonneg_left (by linarith [ht0]) (by norm_num)
      _ ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0‖ := hN0'
  have h0k : ‖t4o_sOff t0 d0‖ ≤ (2001 / 2000 : ℝ) * ‖t4o_sOn t0‖ := by
    nlinarith [h0, hdd0]
  have hN1' : t0 ≤ ‖t4o_sOn t0 + 1‖ := by
    have hshape : t4o_sOn t0 + 1 = ((1 / 2 + 1 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
      dsimp only [t4o_sOn]
      apply Complex.ext
      · simp
      · simp
    have hB : ‖t4o_sOn t0 + 1‖ ^ 2 = (1 / 2 + 1 : ℝ) ^ 2 + t0 ^ 2 := by
      rw [hshape, t4o_normsq (1 / 2 + 1 : ℝ) t0]
    have ht0n : 0 ≤ t0 := by linarith [ht0]
    have hstep2 : Real.sqrt (‖t4o_sOn t0 + 1‖ ^ 2) = ‖t4o_sOn t0 + 1‖ :=
      Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOn t0 + 1‖)
    have hle : t0 ≤ Real.sqrt (‖t4o_sOn t0 + 1‖ ^ 2) :=
      (Real.le_sqrt ht0n (by positivity : 0 ≤ ‖t4o_sOn t0 + 1‖ ^ 2)).mpr
        (by nlinarith [hB])
    linarith [hstep2, hle]
  have hdd1 : d0 ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0 + 1‖ := by
    calc d0 ≤ 1 / 2 := hd
      _ = (1 / 2000 : ℝ) * 1000 := by norm_num
      _ ≤ (1 / 2000 : ℝ) * t0 :=
        mul_le_mul_of_nonneg_left (by linarith [ht0]) (by norm_num)
      _ ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0 + 1‖ :=
        mul_le_mul_of_nonneg_left hN1' (by norm_num)
  have h1k : ‖t4o_sOff t0 d0 + 1‖ ≤ (2001 / 2000 : ℝ) * ‖t4o_sOn t0 + 1‖ := by
    nlinarith [h1b, hdd1]
  have hN2' : t0 ≤ ‖t4o_sOn t0 + 2‖ := by
    have hshape : t4o_sOn t0 + 2 = ((1 / 2 + 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
      dsimp only [t4o_sOn]
      apply Complex.ext
      · simp
      · simp
    have hB : ‖t4o_sOn t0 + 2‖ ^ 2 = (1 / 2 + 2 : ℝ) ^ 2 + t0 ^ 2 := by
      rw [hshape, t4o_normsq (1 / 2 + 2 : ℝ) t0]
    have ht0n : 0 ≤ t0 := by linarith [ht0]
    have hstep2 : Real.sqrt (‖t4o_sOn t0 + 2‖ ^ 2) = ‖t4o_sOn t0 + 2‖ :=
      Real.sqrt_sq (by positivity : 0 ≤ ‖t4o_sOn t0 + 2‖)
    have hle : t0 ≤ Real.sqrt (‖t4o_sOn t0 + 2‖ ^ 2) :=
      (Real.le_sqrt ht0n (by positivity : 0 ≤ ‖t4o_sOn t0 + 2‖ ^ 2)).mpr
        (by nlinarith [hB])
    linarith [hstep2, hle]
  have hdd2 : d0 ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0 + 2‖ := by
    calc d0 ≤ 1 / 2 := hd
      _ = (1 / 2000 : ℝ) * 1000 := by norm_num
      _ ≤ (1 / 2000 : ℝ) * t0 :=
        mul_le_mul_of_nonneg_left (by linarith [ht0]) (by norm_num)
      _ ≤ (1 / 2000 : ℝ) * ‖t4o_sOn t0 + 2‖ :=
        mul_le_mul_of_nonneg_left hN2' (by norm_num)
  have h2k : ‖t4o_sOff t0 d0 + 2‖ ≤ (2001 / 2000 : ℝ) * ‖t4o_sOn t0 + 2‖ := by
    nlinarith [h2b, hdd2]
  --  product  ratio  via  norm_mul  (product  of  norms)
  have h01 : ‖t4o_sOff t0 d0‖ * ‖t4o_sOff t0 d0 + 1‖ ≤
      (2001 / 2000 : ℝ) ^ 2 * (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖) := by
    calc ‖t4o_sOff t0 d0‖ * ‖t4o_sOff t0 d0 + 1‖
        ≤ ((2001 / 2000 : ℝ) * ‖t4o_sOn t0‖) * ‖t4o_sOff t0 d0 + 1‖ :=
          mul_le_mul_of_nonneg_right h0k (by positivity : 0 ≤ ‖t4o_sOff t0 d0 + 1‖)
      _ ≤ ((2001 / 2000 : ℝ) * ‖t4o_sOn t0‖) *
          ((2001 / 2000 : ℝ) * ‖t4o_sOn t0 + 1‖) :=
          mul_le_mul_of_nonneg_left h1k (by positivity : 0 ≤ (2001 / 2000 : ℝ) * ‖t4o_sOn t0‖)
      _ = (2001 / 2000 : ℝ) ^ 2 * (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖) := by ring
  have hP : ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ ≤
      (2001 / 2000 : ℝ) ^ 3 *
        ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
    calc ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖
        = ‖t4o_sOff t0 d0‖ * ‖t4o_sOff t0 d0 + 1‖ * ‖t4o_sOff t0 d0 + 2‖ := by
            rw [norm_mul, norm_mul]
      _ ≤ ((2001 / 2000 : ℝ) ^ 2 * (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖)) *
          ‖t4o_sOff t0 d0 + 2‖ :=
          mul_le_mul_of_nonneg_right h01 (by positivity : 0 ≤ ‖t4o_sOff t0 d0 + 2‖)
      _ ≤ ((2001 / 2000 : ℝ) ^ 2 * (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖)) *
          ((2001 / 2000 : ℝ) * ‖t4o_sOn t0 + 2‖) :=
          mul_le_mul_of_nonneg_left h2k (by positivity :
            0 ≤ (2001 / 2000 : ℝ) ^ 2 * (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖))
      _ = (2001 / 2000 : ℝ) ^ 3 *
          (‖t4o_sOn t0‖ * ‖t4o_sOn t0 + 1‖ * ‖t4o_sOn t0 + 2‖) := by ring
      _ = (2001 / 2000 : ℝ) ^ 3 *
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
        rw [← norm_mul, ← norm_mul]
  --  the  damping  constant
  --  the  damping  constant:  c^3 * n^-d0  <=  (2/5)*(5/2+d0)
  --  since  n^-d0  <=  n^0  = 1  and  c^3  <  1.0016  <=  (2/5)*2.505.
  have hconst : (2001 / 2000 : ℝ) ^ 3 * (S4Strip.n4 t0 : ℝ) ^ (-d0) ≤
      (2 / 5 : ℝ) * (5 / 2 + d0) := by
    have hnegd : -(d0 : ℝ) ≤ (0 : ℝ) := by linarith [hd0]
    have hnd1 : (S4Strip.n4 t0 : ℝ) ^ (-d0) ≤ (S4Strip.n4 t0 : ℝ) ^ (0 : ℝ) :=
      rpow_le_rpow_of_exponent_le hN4ge1 hnegd
    have hz1 : (S4Strip.n4 t0 : ℝ) ^ (0 : ℝ) = 1 := by rw [rpow_zero]
    have hndle : (S4Strip.n4 t0 : ℝ) ^ (-d0) ≤ 1 := by simpa [hz1] using hnd1
    have hprod : (2001 / 2000 : ℝ) ^ 3 * (S4Strip.n4 t0 : ℝ) ^ (-d0) ≤
        (2001 / 2000 : ℝ) ^ 3 * 1 :=
      mul_le_mul_of_nonneg_left hndle (by positivity : 0 ≤ (2001 / 2000 : ℝ) ^ 3)
    have h1c3 : (2001 / 2000 : ℝ) ^ 3 * 1 = (2001 / 2000 : ℝ) ^ 3 := by ring
    have hc3min : (2001 / 2000 : ℝ) ^ 3 ≤ (2 / 5 : ℝ) * (5 / 2 + (1 / 200 : ℝ)) := by
      norm_num
    have hc3 : (2001 / 2000 : ℝ) ^ 3 ≤ (2 / 5 : ℝ) * (5 / 2 + d0) :=
      le_trans hc3min (mul_le_mul_of_nonneg_left
        (by linarith [hdlo]) (by positivity : 0 ≤ (2 / 5 : ℝ)))
    calc (2001 / 2000 : ℝ) ^ 3 * (S4Strip.n4 t0 : ℝ) ^ (-d0)
      _ ≤ (2001 / 2000 : ℝ) ^ 3 * 1 := hprod
      _ = (2001 / 2000 : ℝ) ^ 3 := h1c3
      _ ≤ (2 / 5 : ℝ) * (5 / 2 + d0) := hc3
  --  the  core  division  inequality:
  --  Poff3 * n^-d / (5/2+d0)  <=  (2/5) * Pon3,  by
  --    Poff3 <= c^3 Pon3  (hP),  then  multiply  by  n^-d  and  1/(5/2+d0),
  --    then  c^3 n^-d <= (2/5)(5/2+d0)  (hconst)  cancels  the  denominator.
  have hc5 : 0 < 5 / 2 + d0 := by linarith [hd0]
  have hPdiv :
      ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
        (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0) ≤
        (2 / 5 : ℝ) *
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
    have hdiv1 :
        ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
          (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0) =
        (‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
          (S4Strip.n4 t0 : ℝ) ^ (-d0)) *
        (1 / (5 / 2 + d0)) := by
      field_simp [hc5]
    have hstepA2 := mul_le_mul_of_nonneg_right hP
      (by positivity : 0 ≤ (S4Strip.n4 t0 : ℝ) ^ (-d0))
    have hposd : 0 ≤ 1 / (5 / 2 + d0) := by positivity
    have hmul : (2001 / 2000 : ℝ) ^ 3 * (S4Strip.n4 t0 : ℝ) ^ (-d0) *
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ ≤
        (2 / 5 : ℝ) * (5 / 2 + d0) *
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ :=
      mul_le_mul_of_nonneg_right hconst
        (by positivity : 0 ≤
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖)
    calc ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
            (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0)
      _ = (‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
            (S4Strip.n4 t0 : ℝ) ^ (-d0)) *
            (1 / (5 / 2 + d0)) := hdiv1
      _ ≤ ((2001 / 2000 : ℝ) ^ 3 *
            ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) *
            (S4Strip.n4 t0 : ℝ) ^ (-d0) *
            (1 / (5 / 2 + d0)) :=
        mul_le_mul_of_nonneg_right hstepA2 hposd
      _ = (2001 / 2000 : ℝ) ^ 3 *
            ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
            (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0) := by
        field_simp [hc5]
      _ ≤ ((2 / 5 : ℝ) * (5 / 2 + d0) *
            ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) /
            (5 / 2 + d0) := by
        rw [div_le_iff₀ hc5]
        have hre : ((2 / 5 : ℝ) * (5 / 2 + d0) *
                ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) /
                (5 / 2 + d0) * (5 / 2 + d0) =
            (2 / 5 : ℝ) * (5 / 2 + d0) *
              ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
          field_simp [hc5]
        rw [hre]
        have hnum : (2001 / 2000 : ℝ) ^ 3 *
                ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
                (S4Strip.n4 t0 : ℝ) ^ (-d0) =
            (2001 / 2000 : ℝ) ^ 3 * (S4Strip.n4 t0 : ℝ) ^ (-d0) *
              ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
          ring
        rw [hnum]
        exact hmul
      _ = (2 / 5 : ℝ) *
            ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ := by
        field_simp [hc5]
  --  assemble
  have hexp : (S4Strip.n4 t0 : ℝ) ^ (-(5 / 2 + d0) : ℝ) =
      (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) * (S4Strip.n4 t0 : ℝ) ^ (-d0) := by
    rw [show (-(5 / 2 + d0) : ℝ) = (-5 / 2 : ℝ) + (-d0 : ℝ) by ring,
      rpow_add (by linarith [hN4ge1] : 0 < (S4Strip.n4 t0 : ℝ))]
  have hstep1 : (Real.sqrt 3 / 216) *
        (‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
          (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0)) *
        (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) =
      (Real.sqrt 3 / 216) *
        ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
        (S4Strip.n4 t0 : ℝ) ^ (-(5 / 2 + d0)) / (5 / 2 + d0) := by
    rw [hexp]
    field_simp [show 0 < 5 / 2 + d0 from by linarith [hd0]]
  have hPdiv2 : (‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
      (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0)) *
      (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) ≤
      ((2 / 5 : ℝ) * ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) *
      (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) :=
    mul_le_mul_of_nonneg_right hPdiv
      (by positivity : 0 ≤ (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ))
  have hstepA := mul_le_mul_of_nonneg_left hPdiv2
    (by positivity : 0 ≤ Real.sqrt 3 / 216)
  have hstep3 : (Real.sqrt 3 / 216) *
      ((2 / 5 : ℝ) * ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) *
      (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) =
    (Real.sqrt 3 / 540) *
      ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
      (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := by ring
  calc (Real.sqrt 3 / 216) *
        ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
        (S4Strip.n4 t0 : ℝ) ^ (-(5 / 2 + d0)) / (5 / 2 + d0)
      _ = (Real.sqrt 3 / 216) *
          (‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
            (S4Strip.n4 t0 : ℝ) ^ (-d0) / (5 / 2 + d0)) *
          (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := hstep1.symm
      _ ≤ (Real.sqrt 3 / 216) *
          ((2 / 5 : ℝ) * ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖) *
          (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := by
        simpa only [mul_assoc] using hstepA
      _ = (Real.sqrt 3 / 540) *
          ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
          (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := hstep3

/-  G-hs3-i,  ENDPOINT  FORM:  the  EM  scale  at  the  canonical
    strip  point  (1/2 + d0) + it0  is  bounded  by  the  endpoint's
    B-wire  P8Floor.p8_B t0 (S4Strip.n4 t0)  (the  strip  branch  of
    S4A.BwireR),  for  the  strip  band  and  the  t^4  n-schedule.
    The  three  wall  terms  dominate  TERMWISE:
    term 1  by  the  extra  damping  n^(-d0);
    term 2  by  the  norm  ratio  (<=  6/5)  against  n^(-d0)
            (>=  6/5  at  the  band  edge);
    term 3  by  the  product  ratio  (<=  (2001/2000)^3)  against
            the  wall  constant  540  vs  216  (factor  2  +  the
            (5/2+d0)  denominator).  -/
theorem t4wall_offline_le_bwires (t0 d0 : ℝ) (ht0 : 1000 ≤ t0)
    (hdlo : (1 / 200 : ℝ) ≤ d0) (hd : d0 ≤ 1 / 2) :
    ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖ ≤
      p8_B t0 (S4Strip.n4 t0) := by
  have hn4pos : 0 < S4Strip.n4 t0 := t4o_n4pos t0 ht0
  have hsre : -1 < (t4o_sOff t0 d0).re := by
    dsimp [t4o_sOff]
    norm_num [Complex.ext_iff, Complex.ofReal_add, Complex.ofReal_re,
      Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im,
      Complex.ofReal_im, Complex.mul_im]
    <;> linarith [hdlo]
  have hwall := p4_T4_bound_gen (s := t4o_sOff t0 d0) hsre hn4pos
  have hT1 := t4o_T1 t0 d0 ht0 (by linarith [hdlo])
  have hT2 := t4o_T2 t0 d0 ht0 hdlo hd
  have hT3 := t4o_T3 t0 d0 ht0 hdlo hd
  --  the  on-line  norm  equalities  (for  the  p8_B  match)
  have hf1 : t4o_sOn t0 = ((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := rfl
  have hA : ‖t4o_sOn t0‖ = ‖((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I‖ :=
    congrArg (fun z : ℂ => ‖z‖) hf1
  have hin : t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2) =
      (((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I) *
        (((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I + 1) *
        (((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I + 2) := by
    dsimp [t4o_sOn]
  calc ‖p4_em_expr (t4o_sOff t0 d0) (S4Strip.n4 t0)‖
      _ ≤ (1 / 2) * (S4Strip.n4 t0 : ℝ) ^ (-(1 / 2 + d0)) +
            (‖t4o_sOff t0 d0‖ / 12) * (S4Strip.n4 t0 : ℝ) ^ (-(3 / 2 + d0)) +
            (Real.sqrt 3 / 216) *
              ‖t4o_sOff t0 d0 * (t4o_sOff t0 d0 + 1) * (t4o_sOff t0 d0 + 2)‖ *
              (S4Strip.n4 t0 : ℝ) ^ (-(5 / 2 + d0)) / (5 / 2 + d0) := by
        have hre : (t4o_sOff t0 d0).re = 1 / 2 + d0 := by
          dsimp [t4o_sOff]
          norm_num [Complex.ext_iff, Complex.ofReal_add,
            Complex.ofReal_re, Complex.add_re, Complex.mul_re,
            Complex.I_re, Complex.mul_im, Complex.I_im, Complex.ofReal_im]
        rw [hre] at hwall
        ring_nf at hwall ⊢
        simpa using hwall
      _ ≤ (1 / 2) * (S4Strip.n4 t0 : ℝ) ^ (-1 / 2 : ℝ) +
            (‖t4o_sOn t0‖ / 12) * (S4Strip.n4 t0 : ℝ) ^ (-3 / 2 : ℝ) +
            (Real.sqrt 3 / 540) *
              ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
              (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) := by
        linarith [hT1, hT2, hT3]
      _ = p8_B t0 (S4Strip.n4 t0) := by
        dsimp only [p8_B]
        have hB2 : (‖t4o_sOn t0‖ / 12) * (S4Strip.n4 t0 : ℝ) ^ (-3 / 2 : ℝ) =
            (‖((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I‖ / 12) *
              (S4Strip.n4 t0 : ℝ) ^ (-3 / 2 : ℝ) :=
          congrArg (fun x : ℝ => (x / 12 : ℝ) *
            (S4Strip.n4 t0 : ℝ) ^ (-3 / 2 : ℝ)) hA
        have hC2 : (Real.sqrt 3 / 540) *
              ‖t4o_sOn t0 * (t4o_sOn t0 + 1) * (t4o_sOn t0 + 2)‖ *
              (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) =
            (Real.sqrt 3 / 540) *
              ‖(((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I) *
                (((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I + 1) *
                (((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I + 2)‖ *
              (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ) :=
          congrArg
            (fun z : ℂ => (Real.sqrt 3 / 540 : ℝ) * ‖z‖ *
              (S4Strip.n4 t0 : ℝ) ^ (-5 / 2 : ℝ))
            hin
        rw [hB2, hC2]
