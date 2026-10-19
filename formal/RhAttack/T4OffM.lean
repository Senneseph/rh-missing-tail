/-
  T4OffM - G-hs3-ii and G-hs3-iii: the Mr wire OFF the line, and the
  strip-band margin composition under the lifted EM wall.

  G-hs3 decomposition (T4Off.lean docstring, discovery 0116):
    G-hs3-i   |W_n(rho)|  <=  the  LIFTED  T4  WALL  -  CLOSED  (T4Off;
              endpoint  form:  T4OffD.t4wall_offline_le_bwires,
              discovery  0117);
    G-hs3-ii  |K  -  (P_n  -  I_n)(rho)|  <=  M_wire  at  off-pair
              zero  rho  -  the  P6  finite-kernel  gap  (b3  /  Mr-
              wire  family)  LIFTED  OFF  THE  LINE:  the  g-product
              terms  carry  g^{-sigma}  factors  (sigma  =  rho.re  =
              1/2  + or -  d0)  that  the  on-line  wire  never  eval-
              uates;
    G-hs3-iii  (G-hs3-i  +  G-hs3-ii)  <  floStripMin  (t0,  d0)  on
              the  strip  band  above  the  frontier.

  THIS  MODULE  closes  G-hs3-ii  and  G-hs3-iii  in  the  SAME
  honest-split  shape  as  the  on-line  P8Floor  A4.3/A5:  every
  machine  part  is  LEAN-proven  here;  the  ONLY  non-machine
  input  is  a  CITED  convexity  lift  of  the  bridge-product
  mass:

    CITED  (DLMF  25.15.4-type  convexity;  the  SAME  1.6  constant
    the  tree  already  cites  on  the  line,  S4Window  header):
    for  s'  with  0  <  s'.re  <  1  and  |s'.im|  >=  2,
        |zeta  s'|  <=  1.6  *  |s'.im|^{(1  -  s'.re)  /  2}  *
        ln  |s'.im|.
    At  an  off-pair  zero  rho  with  |rho.re  -  1/2|  =  d0,
    |rho.im|  =  t0,  the  kernel  scale  factors  through  the
    functional  equation  (zeta  s  =  C(s)  zeta(1  -  s)):
        |K(rho)|  <=  |zeta(rho)  /  C(rho)|  *  (b3  correction)
                   =  |zeta(1  -  rho)|     *  (b3  correction),
    and  1  -  rho  sits  at  real  part  1/2  - or +  d0,  so  the
    convexity  exponent  (1  -  Re(1  -  rho))  /  2  =  Re(rho)  /  2
    =  1/4  - or +  d0/2  -  the  WORST  side  is  1/4  +  d0/2:
        |K(rho)|  <=  ZboundOff(t0,  d0)
                    :=  1.6  *  t0^{1/4  +  d0/2}  *  ln  t0.
    The  b3  correction  is  exactly  the  SIGMA-INDEPENDENT
    S4Strip  X4  wire  (same  kernel  fT,  same  zero  list,  same
    (G4,  B4]  band  as  on  the  line:  b3BoundExplicit  has  NO
    sigma  input),  so  the  off-line  M-wire  keeps  the  on-line
    M  *  e^X  *  X  shape  at  the  lifted  mass:
        MwireOff(t0, d0) := ZboundOff(t0, d0) * e^{X4fun t0} * X4fun t0

  THE  MACHINE  PART  (all  LEAN,  1000  <=  t0,  1/200  <=  d0  <=
  1/2;  exact-decimal  audit  tmp/t4offm_audit.py):
    t4m_shape      ZboundOff  =  (on-line  Zbound)  *  t^{d/2};
    t4m_Mterm      MwireOff  (t0,  d0)  <=  MTUBfun  t0  *  t^{d/2}
                  (st_hMterm  on-line  M-chain);
    t4m_Mpin       MTUBfun  t0  *  t^{d/2}  <=  2.5e-15  t^{-9/2}
                  (-19/4  +  d/2  <=  -9/2  for  d  <=  1/2);
    t4m_Bupper     p8_B  (t0,  n4  t0)  <=  9e-5  t^{-2}  (three
                  termwise  pins,  corner  audited);
    t4m_margin     p8_B  (t0,  n4  t0)  +  MwireOff  (t0,  d0)
                  <  S1LowT.floStripMin  t0  d0     [G-hs3-iii]
                  (floStripMin  =  mown  on  the  band  by  FUnif;
                  mown  >=  F4  t^{-2};  9e-5  +  2.5e-15  t^-2.5
                  <  F4  -  corner  margin  16  orders);
    t4m_resid_strip  [G-hs3-ii  terminal,  OFF-LINE  A5  shape]:
                  for  s  =  (1/2  +  d0)  +  i  t0,  n  =  n4  t0,
                  under  hW  (lifted  T4  wall  =  T4OffD)  and
                  hK : |K  -  (P_n  -  I_n)(s)|  <=  Mval  <=
                  MwireOff(t0,  d0)  (the  CITED  mass  lift),
                      |W_n(s)  -  (K  -  (P_n  -  I_n)(s))|
                      <  S1LowT.floStripMin  t0  d0.
  With  t4m_resid_strip  +  t4m_margin,  the  endpoint  hs3  leg
  at  every  off-pair  above  the  frontier  reduces  to  ONE
  CITED  convexity  mass  (the  header),  not  to  an  analytic
  barrier.  No  RH  claim.  Lean  4.33.1  +  mathlib  v4.33.1,
  DOC-FIRST.
-/
import Mathlib
import RhAttack.P4Limit
import RhAttack.P8Floor
import RhAttack.S4Window
import RhAttack.S4Own
import RhAttack.S4Gap
import RhAttack.S4Strip
import RhAttack.S1LowT
import RhAttack.FloorUnif
import RhAttack.T4Off
import RhAttack.T4OffD

open Real Set
open scoped Topology

set_option maxHeartbeats 1000000

/-  §1  -  the  lifted  mass  wire  (CITED  justification  in  the
    module  header).  -/

/-- The lifted C-bridge mass wire: worst-side convexity bound for
    |K(rho)| at an off-pair zero rho (|rho.re - 1/2| = d0,
    |rho.im| = t0), t0 >= 2.  CITED: DLMF 25.15.4-type convexity
    with the on-line 1.6 constant (S4Window header), via
    |zeta(rho) / C(rho)| = |zeta(1 - rho)| (functional equation). -/
noncomputable def t4m_ZboundOff (t0 d0 : ℝ) : ℝ :=
    1.6 * t0 ^ (1 / 4 + d0 / 2) * Real.log t0

/-- The off-line M-wire (def mirror of the S4R/MrR strip branch at
    the lifted mass): M * e^X * X, M = t4m_ZboundOff, X = the
    sigma-independent S4Strip X4 wire. -/
noncomputable def t4m_MwireOff (t0 d0 : ℝ) : ℝ :=
    t4m_ZboundOff t0 d0 * Real.exp (S4Strip.X4fun t0) * S4Strip.X4fun t0

/-- Shape: ZboundOff = (on-line Zbound) * t^{d/2}. -/
theorem t4m_shape (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) :
    t4m_ZboundOff t0 d0 = S4W.Zbound t0 * t0 ^ (d0 / 2) := by
  dsimp only [t4m_ZboundOff, S4W.Zbound]
  rw [show (t0 : ℝ) ^ ((1 : ℝ) / 4 + d0 / 2) = (t0 : ℝ) ^ ((1 : ℝ) / 4) *
        (t0 : ℝ) ^ (d0 / 2) from
    Real.rpow_add (by linarith : 0 < t0) ((1 : ℝ) / 4) (d0 / 2)]
  ring

/-  §2  -  the  M-term  chain  off  the  line  (G-hs3-ii,  machine).  -/

/-- Off-line M-term: MwireOff(t0, d0) <= MTUBfun(t0) * t0^{d0/2},
    from st_hMterm (the on-line M-chain) with M := Zbound(t0). -/
theorem t4m_Mterm (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd : d0 ≤ 1 / 2) :
    t4m_MwireOff t0 d0 ≤ S4Strip.MTUBfun t0 * t0 ^ (d0 / 2) := by
  have hZ0 : 0 ≤ S4W.Zbound t0 := by
    dsimp only [S4W.Zbound]
    have hgt : (1 : ℝ) < t0 := by linarith
    apply mul_nonneg
    · apply mul_nonneg
      · norm_num
      · exact Real.rpow_nonneg (by linarith) _
    · exact le_of_lt (Real.log_pos hgt)
  have hM := S4Strip.st_hMterm t0 (S4W.Zbound t0) ht0 hZ0 (le_rfl)
  have hshape := t4m_shape t0 d0 ht0
  calc t4m_MwireOff t0 d0
      = (S4W.Zbound t0 * t0 ^ (d0 / 2)) * Real.exp (S4Strip.X4fun t0) *
          S4Strip.X4fun t0 := by
          dsimp only [t4m_MwireOff]
          rw [hshape]
    _ = (S4W.Zbound t0 * Real.exp (S4Strip.X4fun t0) *
          S4Strip.X4fun t0) * t0 ^ (d0 / 2) := by ring
    _ ≤ S4Strip.MTUBfun t0 * t0 ^ (d0 / 2) :=
      mul_le_mul_of_nonneg_right hM (by positivity : 0 ≤ t0 ^ (d0 / 2))

/-- Pin: MTUBfun(t0) * t0^{d0/2} <= 2.5e-15 * t0^{-9/2}
    (d0 <= 1/2 gives -19/4 + d0/2 <= -9/2). -/
theorem t4m_Mpin (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hd : d0 ≤ 1 / 2) :
    S4Strip.MTUBfun t0 * t0 ^ (d0 / 2) ≤ (25 / 10 ^ 15 : ℝ) * t0 ^ (-(9 / 2 : ℝ)) := by
  dsimp only [S4Strip.MTUBfun]
  have ht0p : 0 < t0 := by linarith
  have hstep : (25 / 10 ^ 15 : ℝ) / (t0 : ℝ) ^ (19 / 4 : ℝ) *
          (t0 : ℝ) ^ (d0 / 2) =
      (25 / 10 ^ 15 : ℝ) * (t0 : ℝ) ^ (-(19 / 4 : ℝ)) * (t0 : ℝ) ^ (d0 / 2) := by
    rw [div_eq_mul_inv, ← Real.rpow_neg (le_of_lt ht0p) ((19 / 4 : ℝ))]
  rw [hstep]
  have hstep2 : (25 / 10 ^ 15 : ℝ) * (t0 : ℝ) ^ (-(19 / 4 : ℝ)) *
          (t0 : ℝ) ^ (d0 / 2) =
      (25 / 10 ^ 15 : ℝ) * (t0 : ℝ) ^ (-(19 / 4 : ℝ) + d0 / 2) := by
    have hadd : (t0 : ℝ) ^ (-(19 / 4 : ℝ)) * (t0 : ℝ) ^ (d0 / 2) =
        (t0 : ℝ) ^ (-(19 / 4 : ℝ) + d0 / 2) :=
      (Real.rpow_add ht0p (-(19 / 4 : ℝ)) (d0 / 2)).symm
    rw [mul_assoc, hadd]
  rw [hstep2]
  exact mul_le_mul_of_nonneg_left
    (Real.rpow_le_rpow_of_exponent_le (by linarith : (1 : ℝ) ≤ t0)
      (by nlinarith [hd]))
    (by positivity : 0 ≤ (25 / 10 ^ 15 : ℝ))

/-  §3  -  p8_B  at  the  t^4  schedule  (G-hs3-iii,  B  side).  -/

/-- p8_B(t0, S4Strip.n4 t0) <= 9e-5 * t0^{-2} for t0 >= 1000:
    three termwise pins (term1: 0.5*(3.1e7)^-1/2 <= 89803e-9;
    term2: (t0+1)/12 * (3.1e7)^-3/2, t+1 <= (1001/1000)t,
    corner ~9e-22 pinned under 1e-18;  term3: (1.01t)^3 product
    against (3.1e7)^-5/2, corner ~6e-52 pinned under 1e-31;
    89803e-9 + 1e-18 + 1e-31 < 9e-5, exact rationals). -/
theorem t4m_Bupper (t0 : ℝ) (ht0 : 1000 ≤ t0) :
    p8_B t0 (S4Strip.n4 t0) ≤ (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) := by
  set n4R := (S4Strip.n4 t0 : ℝ) with hn4R
  have hn4p : 0 < n4R := by
    dsimp only [n4R]
    exact Nat.cast_pos.2 (t4o_n4pos t0 ht0)
  have hn4f : (31000000 : ℝ) * t0 ^ 4 ≤ n4R := by
    dsimp only [n4R]
    exact t4o_n4floor t0 ht0
  have hcpos : 0 < (31000000 : ℝ) * t0 ^ 4 := by positivity
  set sOn : ℂ := ((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I with hsOn
  --  neg-power  monotone  (0  <  b  <=  a):  n4R^{-r}  <=  b^{-r},  r  >  0.
  --  Concrete instances (term-shape exact: exponent terms as in p8_B).
  have hi1 : n4R ^ (-1 / 2 : ℝ) ≤ ((31000000 : ℝ) * t0 ^ 4) ^ (-1 / 2 : ℝ) := by
    have hpos2 : 0 < ((31000000 : ℝ) * t0 ^ 4) ^ (1 / 2 : ℝ) :=
      Real.rpow_pos_of_pos hcpos (1 / 2)
    have hbase : ((31000000 : ℝ) * t0 ^ 4) ^ (1 / 2 : ℝ) ≤ (n4R : ℝ) ^ (1 / 2 : ℝ) :=
      Real.rpow_le_rpow (le_of_lt hcpos) hn4f (by norm_num)
    rw [show (-1 / 2 : ℝ) = -((1 / 2 : ℝ)) by norm_num,
        Real.rpow_neg hn4p.le (1 / 2),
        Real.rpow_neg hcpos.le (1 / 2),
        inv_eq_one_div ((n4R : ℝ) ^ (1 / 2 : ℝ)),
        inv_eq_one_div (((31000000 : ℝ) * t0 ^ 4) ^ (1 / 2 : ℝ))]
    exact one_div_le_one_div_of_le hpos2 hbase
  have hi3 : n4R ^ (-3 / 2 : ℝ) ≤ ((31000000 : ℝ) * t0 ^ 4) ^ (-3 / 2 : ℝ) := by
    have hpos2 : 0 < ((31000000 : ℝ) * t0 ^ 4) ^ (3 / 2 : ℝ) :=
      Real.rpow_pos_of_pos hcpos (3 / 2)
    have hbase : ((31000000 : ℝ) * t0 ^ 4) ^ (3 / 2 : ℝ) ≤ (n4R : ℝ) ^ (3 / 2 : ℝ) :=
      Real.rpow_le_rpow (le_of_lt hcpos) hn4f (by norm_num)
    rw [show (-3 / 2 : ℝ) = -((3 / 2 : ℝ)) by norm_num,
        Real.rpow_neg hn4p.le (3 / 2),
        Real.rpow_neg hcpos.le (3 / 2),
        inv_eq_one_div ((n4R : ℝ) ^ (3 / 2 : ℝ)),
        inv_eq_one_div (((31000000 : ℝ) * t0 ^ 4) ^ (3 / 2 : ℝ))]
    exact one_div_le_one_div_of_le hpos2 hbase
  have hi5 : n4R ^ (-5 / 2 : ℝ) ≤ ((31000000 : ℝ) * t0 ^ 4) ^ (-5 / 2 : ℝ) := by
    have hpos2 : 0 < ((31000000 : ℝ) * t0 ^ 4) ^ (5 / 2 : ℝ) :=
      Real.rpow_pos_of_pos hcpos (5 / 2)
    have hbase : ((31000000 : ℝ) * t0 ^ 4) ^ (5 / 2 : ℝ) ≤ (n4R : ℝ) ^ (5 / 2 : ℝ) :=
      Real.rpow_le_rpow (le_of_lt hcpos) hn4f (by norm_num)
    rw [show (-5 / 2 : ℝ) = -((5 / 2 : ℝ)) by norm_num,
        Real.rpow_neg hn4p.le (5 / 2),
        Real.rpow_neg hcpos.le (5 / 2),
        inv_eq_one_div ((n4R : ℝ) ^ (5 / 2 : ℝ)),
        inv_eq_one_div (((31000000 : ℝ) * t0 ^ 4) ^ (5 / 2 : ℝ))]
    exact one_div_le_one_div_of_le hpos2 hbase
  --  norm  ratio  for  term  2:  ||sOn||  <=  t0  +  1
  have hnorm : ‖sOn‖ ≤ t0 + 1 := by
    have hsq : ‖sOn‖ ^ 2 ≤ (t0 + 1) ^ 2 := by
      dsimp only [sOn]
      rw [t4o_normsq (1 / 2) t0]
      nlinarith [ht0]
    have hL : 0 ≤ ‖sOn‖ := norm_nonneg _
    have hR : 0 ≤ t0 + 1 := by positivity
    exact (sq_le_sq₀ hL hR).mp hsq
  --  exponent  split  helpers  (mul_rpow  +  rpow_mul)
  have hsp1 : ((31000000 : ℝ) * t0 ^ 4) ^ (-1 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-1 / 2 : ℝ) * t0 ^ (-2 : ℝ) := by
    rw [mul_rpow (by norm_num : 0 ≤ (31000000 : ℝ))
      (by positivity : 0 ≤ t0 ^ 4)]
    have hq : ((t0 : ℝ) ^ 4) ^ (-1 / 2 : ℝ) = t0 ^ (-2 : ℝ) := by
      rw [show (t0 : ℝ) ^ 4 = (t0 : ℝ) ^ (4 : ℝ) by norm_num]
      rw [← Real.rpow_mul (by positivity : 0 ≤ t0) (4 : ℝ) (-1 / 2 : ℝ)]
      rw [show (4 : ℝ) * ((-1 / 2 : ℝ)) = (-2 : ℝ) by norm_num]
    rw [hq]
  have hsp3 : ((31000000 : ℝ) * t0 ^ 4) ^ (-3 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-3 / 2 : ℝ) * t0 ^ (-6 : ℝ) := by
    rw [mul_rpow (by norm_num : 0 ≤ (31000000 : ℝ))
      (by positivity : 0 ≤ t0 ^ 4)]
    have hq : ((t0 : ℝ) ^ 4) ^ (-3 / 2 : ℝ) = t0 ^ (-6 : ℝ) := by
      rw [show (t0 : ℝ) ^ 4 = (t0 : ℝ) ^ (4 : ℝ) by norm_num]
      rw [← Real.rpow_mul (by positivity : 0 ≤ t0) (4 : ℝ) (-3 / 2 : ℝ)]
      rw [show (4 : ℝ) * ((-3 / 2 : ℝ)) = (-6 : ℝ) by norm_num]
    rw [hq]
  have hsp5 : ((31000000 : ℝ) * t0 ^ 4) ^ (-5 / 2 : ℝ) =
      (31000000 : ℝ) ^ (-5 / 2 : ℝ) * t0 ^ (-10 : ℝ) := by
    rw [mul_rpow (by norm_num : 0 ≤ (31000000 : ℝ))
      (by positivity : 0 ≤ t0 ^ 4)]
    have hq : ((t0 : ℝ) ^ 4) ^ (-5 / 2 : ℝ) = t0 ^ (-10 : ℝ) := by
      rw [show (t0 : ℝ) ^ 4 = (t0 : ℝ) ^ (4 : ℝ) by norm_num]
      rw [← Real.rpow_mul (by positivity : 0 ≤ t0) (4 : ℝ) (-5 / 2 : ℝ)]
      rw [show (4 : ℝ) * ((-5 / 2 : ℝ)) = (-10 : ℝ) by norm_num]
    rw [hq]
  --  term  1
  have hT1 : (1 / 2) * n4R ^ (-1 / 2 : ℝ) ≤ (89803 / 10 ^ 9 : ℝ) * t0 ^ (-2 : ℝ) := by
    have hcinv : (31000000 : ℝ) ^ (-1 / 2 : ℝ) ≤ (179606 / 10 ^ 9 : ℝ) := by
      have hinv : (31000000 : ℝ) ^ (-1 / 2 : ℝ) =
          ((31000000 : ℝ) ^ (1 / 2 : ℝ))⁻¹ := by
        rw [show (-1 / 2 : ℝ) = -((1 / 2 : ℝ)) by norm_num,
            Real.rpow_neg (by norm_num : 0 ≤ (31000000 : ℝ)) ((1 / 2 : ℝ))]
      rw [hinv, inv_eq_one_div ((31000000 : ℝ) ^ (1 / 2 : ℝ))]
      rw [show (179606 / 10 ^ 9 : ℝ) = (1 : ℝ) / (10 ^ 9 / 179606 : ℝ) by
        field_simp]
      rw [one_div_le_one_div
        (by positivity : 0 < (31000000 : ℝ) ^ (1 / 2 : ℝ))
        (by norm_num : 0 < (10 ^ 9 / 179606 : ℝ))]
      have hL : 0 ≤ (10 ^ 9 / 179606 : ℝ) := by positivity
      have hR : 0 ≤ (31000000 : ℝ) ^ (1 / 2 : ℝ) := by positivity
      have hsq : (10 ^ 9 / 179606 : ℝ) ^ 2 ≤ (31000000 : ℝ) := by
        field_simp
        norm_num
      have hsqr : ((31000000 : ℝ) ^ (1 / 2 : ℝ)) ^ 2 = (31000000 : ℝ) := by
        rw [← rpow_two ((31000000 : ℝ) ^ (1 / 2 : ℝ)),
            ← Real.rpow_mul (by norm_num : 0 ≤ (31000000 : ℝ)) ((1 / 2 : ℝ)) 2]
        have he : (31000000 : ℝ) ^ ((1 / 2 : ℝ) * 2) = (31000000 : ℝ) ^ (1 : ℝ) := by
          congr
          norm_num
        rw [he, Real.rpow_one]
      have hsq2 : (10 ^ 9 / 179606 : ℝ) ^ 2 ≤ ((31000000 : ℝ) ^ (1 / 2 : ℝ)) ^ 2 :=
        le_trans hsq (le_of_eq hsqr.symm)
      exact (sq_le_sq₀ hL hR).mp hsq2
    calc (1 / 2) * n4R ^ (-1 / 2 : ℝ)
        ≤ (1 / 2) * ((31000000 : ℝ) * t0 ^ 4) ^ (-1 / 2 : ℝ) :=
          mul_le_mul_of_nonneg_left hi1 (by norm_num : 0 ≤ (1 / 2 : ℝ))
      _ = (1 / 2) * ((31000000 : ℝ) ^ (-1 / 2 : ℝ) * t0 ^ (-2 : ℝ)) := by rw [hsp1]
      _ ≤ (1 / 2) * ((179606 / 10 ^ 9 : ℝ) * t0 ^ (-2 : ℝ)) :=
        mul_le_mul_of_nonneg_left
          (mul_le_mul_of_nonneg_right hcinv
            (le_of_lt (Real.rpow_pos_of_pos (by linarith : 0 < t0) (-2 : ℝ))))
          (by norm_num : 0 ≤ (1 / 2 : ℝ))
      _ = (89803 / 10 ^ 9 : ℝ) * t0 ^ (-2 : ℝ) := by ring
  --  term  2
  have hT2 : (‖sOn‖ / 12) * n4R ^ (-3 / 2 : ℝ) ≤ (1 / 10 ^ 18 : ℝ) * t0 ^ (-2 : ℝ) := by
    have hc32 : (31000000 : ℝ) ^ (-3 / 2 : ℝ) ≤ (12000 : ℝ) / 1001 / 10 ^ 9 := by
      have hinv : (31000000 : ℝ) ^ (-3 / 2 : ℝ) =
          ((31000000 : ℝ) ^ (3 / 2 : ℝ))⁻¹ := by
        rw [show (-3 / 2 : ℝ) = -((3 / 2 : ℝ)) by norm_num,
            Real.rpow_neg (by norm_num : 0 ≤ (31000000 : ℝ)) ((3 / 2 : ℝ))]
      rw [hinv, inv_eq_one_div ((31000000 : ℝ) ^ (3 / 2 : ℝ))]
      rw [show (12000 : ℝ) / 1001 / 10 ^ 9 = (1 : ℝ) / (1001 * 10 ^ 9 / 12000 : ℝ) by
        field_simp]
      rw [one_div_le_one_div
        (by positivity : 0 < (31000000 : ℝ) ^ (3 / 2 : ℝ))
        (by norm_num : 0 < (1001 * 10 ^ 9 / 12000 : ℝ))]
      have hL : 0 ≤ (1001 * 10 ^ 9 / 12000 : ℝ) := by positivity
      have hR : 0 ≤ (31000000 : ℝ) ^ (3 / 2 : ℝ) := by positivity
      have hsq : (1001 * 10 ^ 9 / 12000 : ℝ) ^ 2 ≤ (31000000 : ℝ) ^ 3 := by
        field_simp
        norm_num
      have hsqr : ((31000000 : ℝ) ^ (3 / 2 : ℝ)) ^ 2 = (31000000 : ℝ) ^ 3 := by
        calc ((31000000 : ℝ) ^ (3 / 2 : ℝ)) ^ 2
            = ((31000000 : ℝ) ^ (3 / 2 : ℝ)) ^ (2 : ℝ) :=
              (Real.rpow_two ((31000000 : ℝ) ^ (3 / 2 : ℝ))).symm
          _ = (31000000 : ℝ) ^ ((3 / 2 : ℝ) * 2) :=
              (Real.rpow_mul (by norm_num : 0 ≤ (31000000 : ℝ)) ((3 / 2 : ℝ)) 2).symm
          _ = (31000000 : ℝ) ^ (3 : ℝ) := by
              have he : (31000000 : ℝ) ^ ((3 / 2 : ℝ) * 2) =
                  (31000000 : ℝ) ^ (3 : ℝ) := by
                congr 1
                norm_num
              rw [he]
          _ = (31000000 : ℝ) ^ 3 := by
              have ec : (3 : ℝ) = ((3 : ℕ) : ℝ) := by congr
              rw [ec]
              exact Real.rpow_natCast (31000000 : ℝ) (3 : ℕ)
      have hsq2 : (1001 * 10 ^ 9 / 12000 : ℝ) ^ 2 ≤
          ((31000000 : ℝ) ^ (3 / 2 : ℝ)) ^ 2 := le_trans hsq (le_of_eq hsqr.symm)
      exact (sq_le_sq₀ hL hR).mp hsq2
    have h1001 : (t0 + 1 : ℝ) ≤ (1001 : ℝ) / 1000 * t0 := by
      have h1 : (1 : ℝ) ≤ t0 / 1000 := by
        have hm : (1000 : ℝ) * (t0 / 1000) = t0 := by
          field_simp
        nlinarith [hm, ht0]
      calc (t0 + 1 : ℝ)
          = t0 * 1 + 1 := by ring
        _ ≤ t0 * 1 + t0 / 1000 := by nlinarith [h1]
        _ = t0 * (1 + 1 / 1000 : ℝ) := by ring
        _ = (1001 : ℝ) / 1000 * t0 := by ring
    have hcoef : (1001 : ℝ) / (1000 * 12) * (31000000 : ℝ) ^ (-3 / 2 : ℝ) ≤
        (1 / 10 ^ 9 : ℝ) := by
      calc (1001 : ℝ) / (1000 * 12) * (31000000 : ℝ) ^ (-3 / 2 : ℝ)
          ≤ (1001 : ℝ) / (1000 * 12) * ((12000 : ℝ) / 1001 / 10 ^ 9) :=
            mul_le_mul_of_nonneg_left hc32 (by positivity)
        _ = (1 / 10 ^ 9 : ℝ) := by field_simp; norm_num
    have ht3inv : (t0 : ℝ) ^ (-3 : ℝ) ≤ (1 / 10 ^ 9 : ℝ) := by
      have h5 : (1000 : ℝ) ^ 3 ≤ (t0 : ℝ) ^ 3 :=
        pow_le_pow_left₀ (by norm_num : 0 ≤ (1000 : ℝ)) ht0 3
      have hp : 0 < (1000 : ℝ) ^ 3 := by positivity
      have h1000 : (1 : ℝ) / (1000 : ℝ) ^ 3 = (1 / 10 ^ 9 : ℝ) := by norm_num
      have hgoal : (1 : ℝ) / (t0 : ℝ) ^ 3 ≤ (1 : ℝ) / (1000 : ℝ) ^ 3 :=
        one_div_le_one_div_of_le hp h5
      have hexp : (t0 : ℝ) ^ (-3 : ℝ) = (1 : ℝ) / (t0 : ℝ) ^ 3 := by
        rw [Real.rpow_neg (by positivity : 0 ≤ t0) 3,
          show (t0 : ℝ) ^ (3 : ℝ) = (t0 : ℝ) ^ 3 from
            Real.rpow_natCast t0 3,
          inv_eq_one_div]
      rw [hexp, ← h1000]
      exact hgoal
    calc (‖sOn‖ / 12) * n4R ^ (-3 / 2 : ℝ)
        ≤ ((t0 + 1) / 12) * ((31000000 : ℝ) * t0 ^ 4) ^ (-3 / 2 : ℝ) := by
          have hdiv : (‖sOn‖ : ℝ) / 12 ≤ (t0 + 1) / 12 := by
            rw [div_eq_mul_inv, div_eq_mul_inv]
            exact mul_le_mul_of_nonneg_right hnorm (by norm_num)
          calc (‖sOn‖ : ℝ) / 12 * n4R ^ (-3 / 2 : ℝ)
              ≤ (t0 + 1) / 12 * n4R ^ (-3 / 2 : ℝ) :=
                mul_le_mul_of_nonneg_right hdiv (by positivity)
              _ ≤ (t0 + 1) / 12 * ((31000000 : ℝ) * t0 ^ 4) ^ (-3 / 2 : ℝ) :=
                mul_le_mul_of_nonneg_left hi3 (by positivity)
      _ = ((t0 + 1) / 12) * ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * t0 ^ (-6 : ℝ)) := by
          rw [hsp3]
      _ ≤ ((1001 : ℝ) / 1000 * t0 / 12) *
            ((31000000 : ℝ) ^ (-3 / 2 : ℝ) * t0 ^ (-6 : ℝ)) := by
          have hdivx : (t0 + 1 : ℝ) / 12 ≤ (1001 : ℝ) / 1000 * t0 / 12 := by
            rw [div_eq_mul_inv, div_eq_mul_inv]
            exact mul_le_mul_of_nonneg_right h1001 (by norm_num)
          exact mul_le_mul_of_nonneg_right hdivx (by positivity)
      _ = ((1001 : ℝ) / (1000 * 12) * (31000000 : ℝ) ^ (-3 / 2 : ℝ)) *
            (t0 ^ (-6 : ℝ) * t0) := by ring
      _ ≤ (1 / 10 ^ 9 : ℝ) * (t0 ^ (-6 : ℝ) * t0) :=
        mul_le_mul_of_nonneg_right hcoef (by positivity)
      _ = (1 / 10 ^ 9 : ℝ) * t0 ^ (-5 : ℝ) := by
          have ht5 : t0 ^ (-6 : ℝ) * t0 = t0 ^ (-5 : ℝ) := by
            have hmul : (t0 : ℝ) ^ (-6 : ℝ) * (t0 : ℝ) =
                (t0 : ℝ) ^ (-6 : ℝ) * (t0 : ℝ) ^ (1 : ℝ) := by
              congr
              exact (Real.rpow_one t0).symm
            rw [hmul, ← Real.rpow_add (by linarith : 0 < t0) ((-6 : ℝ)) 1,
                show ((-6 : ℝ)) + 1 = (-5 : ℝ) by norm_num]
          rw [ht5]
      _ = (1 / 10 ^ 9 : ℝ) * ((t0 : ℝ) ^ (-2 : ℝ) * (t0 : ℝ) ^ (-3 : ℝ)) := by
          rw [show (t0 : ℝ) ^ (-5 : ℝ) = (t0 : ℝ) ^ ((-2 : ℝ) + (-3 : ℝ)) by
                congr
                norm_num,
              Real.rpow_add (by linarith : 0 < t0) ((-2 : ℝ)) ((-3 : ℝ))]
      _ ≤ (1 / 10 ^ 18 : ℝ) * t0 ^ (-2 : ℝ) := by
          rw [show (1 / 10 ^ 9 : ℝ) * ((t0 : ℝ) ^ (-2 : ℝ) * (t0 : ℝ) ^ (-3 : ℝ)) =
                (t0 : ℝ) ^ (-2 : ℝ) * ((1 / 10 ^ 9 : ℝ) * (t0 : ℝ) ^ (-3 : ℝ)) by ring]
          have hstep : (1 / 10 ^ 9 : ℝ) * (t0 : ℝ) ^ (-3 : ℝ) ≤
              (1 / 10 ^ 9 : ℝ) * (1 / 10 ^ 9 : ℝ) :=
            mul_le_mul_of_nonneg_left ht3inv (by positivity)
          have hstep2 : (t0 : ℝ) ^ (-2 : ℝ) * ((1 / 10 ^ 9 : ℝ) * (t0 : ℝ) ^ (-3 : ℝ)) ≤
              (t0 : ℝ) ^ (-2 : ℝ) * ((1 / 10 ^ 9 : ℝ) * (1 / 10 ^ 9 : ℝ)) :=
            mul_le_mul_of_nonneg_left hstep (by positivity)
          have hfinal : (t0 : ℝ) ^ (-2 : ℝ) * ((1 / 10 ^ 9 : ℝ) * (1 / 10 ^ 9 : ℝ)) =
              (1 / 10 ^ 18 : ℝ) * t0 ^ (-2 : ℝ) := by ring_nf
          rw [← hfinal]
          exact hstep2
  --  term  3   (product  pin  under  1e-30,  corner  ~6e-52)
  have hT3 : (Real.sqrt 3 / 540) *
          ‖sOn * (sOn + 1) * (sOn + 2)‖ * n4R ^ (-5 / 2 : ℝ) ≤
          (1 / 10 ^ 30 : ℝ) * t0 ^ (-2 : ℝ) := by
    have h2b : ‖sOn + 1‖ ≤ t0 + 2 := by
      have hsq : ‖sOn + 1‖ ^ 2 ≤ (t0 + 2) ^ 2 := by
        dsimp only [sOn]
        have heq : sOn + 1 = ((3 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
          dsimp only [sOn]
          apply Complex.ext
          <;> (try norm_num)
        rw [heq]
        rw [t4o_normsq (3 / 2) t0]
        nlinarith [ht0]
      have hL : 0 ≤ ‖sOn + 1‖ := norm_nonneg _
      have hR : 0 ≤ t0 + 2 := by positivity
      exact (sq_le_sq₀ hL hR).mp hsq
    have h3b : ‖sOn + 2‖ ≤ t0 + 3 := by
      have hsq : ‖sOn + 2‖ ^ 2 ≤ (t0 + 3) ^ 2 := by
        dsimp only [sOn]
        have heq : sOn + 2 = ((5 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I := by
          dsimp only [sOn]
          apply Complex.ext
          <;> (try norm_num)
        rw [heq]
        rw [t4o_normsq (5 / 2) t0]
        nlinarith [ht0]
      have hL : 0 ≤ ‖sOn + 2‖ := norm_nonneg _
      have hR : 0 ≤ t0 + 3 := by positivity
      exact (sq_le_sq₀ hL hR).mp hsq
    have hprod : ‖sOn * (sOn + 1) * (sOn + 2)‖ ≤ (101 / 100 : ℝ) ^ 3 * t0 ^ 3 := by
      have hsum3 : (t0 + 1) * (t0 + 2) * (t0 + 3) ≤ (101 / 100 : ℝ) ^ 3 * t0 ^ 3 := by
        calc (t0 + 1) * (t0 + 2) * (t0 + 3)
            ≤ ((101 / 100 : ℝ) * t0) * ((101 / 100 : ℝ) * t0) *
                ((101 / 100 : ℝ) * t0) := by
              gcongr <;> nlinarith [ht0]
            _ = (101 / 100 : ℝ) ^ 3 * t0 ^ 3 := by ring
      have hnorm1 : ‖sOn * (sOn + 1) * (sOn + 2)‖ =
          ‖sOn * (sOn + 1)‖ * ‖sOn + 2‖ := by
        rw [Complex.norm_mul (sOn * (sOn + 1)) (sOn + 2)]
      have hnorm3 : ‖sOn * (sOn + 1)‖ * (t0 + 3) = ‖sOn‖ * ‖sOn + 1‖ * (t0 + 3) := by
        rw [Complex.norm_mul sOn (sOn + 1)]
      calc ‖sOn * (sOn + 1) * (sOn + 2)‖
          = ‖sOn * (sOn + 1)‖ * ‖sOn + 2‖ := hnorm1
        _ ≤ ‖sOn * (sOn + 1)‖ * (t0 + 3) :=
          mul_le_mul_of_nonneg_left h3b (norm_nonneg (sOn * (sOn + 1)))
        _ = ‖sOn‖ * ‖sOn + 1‖ * (t0 + 3) := hnorm3
        _ ≤ (101 / 100 : ℝ) ^ 3 * t0 ^ 3 := by
          have hstep : ‖sOn‖ * ‖sOn + 1‖ * (t0 + 3) ≤ (t0 + 1) * (t0 + 2) * (t0 + 3) := by
            have hinner : ‖sOn‖ * ‖sOn + 1‖ ≤ (t0 + 1) * ‖sOn + 1‖ :=
              mul_le_mul_of_nonneg_right hnorm (norm_nonneg (sOn + 1))
            have hmid : (t0 + 1) * ‖sOn + 1‖ ≤ (t0 + 1) * (t0 + 2) :=
              mul_le_mul_of_nonneg_left h2b (by linarith : 0 ≤ t0 + 1)
            calc ‖sOn‖ * ‖sOn + 1‖ * (t0 + 3)
                ≤ (t0 + 1) * ‖sOn + 1‖ * (t0 + 3) :=
                  mul_le_mul_of_nonneg_right hinner (by positivity)
              _ ≤ (t0 + 1) * (t0 + 2) * (t0 + 3) :=
                mul_le_mul_of_nonneg_right hmid (by positivity)
          simpa [mul_assoc] using le_trans hstep hsum3
    have hc52c : (31000000 : ℝ) ^ (-5 / 2 : ℝ) ≤ (1 / 10 ^ 17 : ℝ) := by
      have hinv : (31000000 : ℝ) ^ (-5 / 2 : ℝ) =
          ((31000000 : ℝ) ^ (5 / 2 : ℝ))⁻¹ := by
        rw [show (-5 / 2 : ℝ) = -((5 / 2 : ℝ)) by norm_num,
            Real.rpow_neg (by norm_num : 0 ≤ (31000000 : ℝ)) ((5 / 2 : ℝ))]
      rw [hinv, inv_eq_one_div ((31000000 : ℝ) ^ (5 / 2 : ℝ))]
      rw [one_div_le_one_div
        (by positivity : 0 < (31000000 : ℝ) ^ (5 / 2 : ℝ))
        (by norm_num : 0 < (10 : ℝ) ^ 17)]
      have hL : 0 ≤ (10 : ℝ) ^ 17 := by norm_num
      have hR : 0 ≤ (31000000 : ℝ) ^ (5 / 2 : ℝ) := by positivity
      have hsq : ((10 : ℝ) ^ 17) ^ 2 ≤ (31000000 : ℝ) ^ 5 := by
        norm_num
      have hsqr : ((31000000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2 = (31000000 : ℝ) ^ 5 := by
        calc ((31000000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2
            = ((31000000 : ℝ) ^ (5 / 2 : ℝ)) ^ (2 : ℝ) :=
              (Real.rpow_two ((31000000 : ℝ) ^ (5 / 2 : ℝ))).symm
          _ = (31000000 : ℝ) ^ ((5 / 2 : ℝ) * 2) :=
              (Real.rpow_mul (by norm_num : 0 ≤ (31000000 : ℝ)) ((5 / 2 : ℝ)) 2).symm
          _ = (31000000 : ℝ) ^ (5 : ℝ) := by
              have he : (31000000 : ℝ) ^ ((5 / 2 : ℝ) * 2) =
                  (31000000 : ℝ) ^ (5 : ℝ) := by
                congr 1
                norm_num
              rw [he]
          _ = (31000000 : ℝ) ^ 5 := by
              have ec : (5 : ℝ) = ((5 : ℕ) : ℝ) := by congr
              rw [ec]
              exact Real.rpow_natCast (31000000 : ℝ) (5 : ℕ)
      have hsq2 : ((10 : ℝ) ^ 17) ^ 2 ≤ ((31000000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2 :=
        le_trans hsq (le_of_eq hsqr.symm)
      exact (sq_le_sq₀ hL hR).mp hsq2
    have hcoef3 : (Real.sqrt 3 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 *
        (31000000 : ℝ) ^ (-5 / 2 : ℝ) ≤ (1 / 10 ^ 16 : ℝ) := by
      have hsqrt : (Real.sqrt 3 / 540 : ℝ) ≤ (2 / 540 : ℝ) := by
        rw [div_eq_mul_inv, div_eq_mul_inv]
        exact mul_le_mul_of_nonneg_right
          (le_trans (Real.sqrt_le_sqrt (by norm_num : (3 : ℝ) ≤ 4))
            (by norm_num : Real.sqrt 4 ≤ 2))
          (by positivity : 0 ≤ (540 : ℝ)⁻¹)
      calc (Real.sqrt 3 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 *
              (31000000 : ℝ) ^ (-5 / 2 : ℝ)
          ≤ (2 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 *
              (31000000 : ℝ) ^ (-5 / 2 : ℝ) := by
            have hstep : (Real.sqrt 3 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 ≤
                (2 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 :=
              mul_le_mul_of_nonneg_right hsqrt (by positivity)
            exact mul_le_mul_of_nonneg_right hstep (by positivity)
        _ ≤ (2 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 * (1 / 10 ^ 17 : ℝ) :=
          mul_le_mul_of_nonneg_left hc52c (by positivity)
        _ ≤ (1 / 10 ^ 16 : ℝ) := by
            field_simp
            norm_num
    calc (Real.sqrt 3 / 540) *
            ‖sOn * (sOn + 1) * (sOn + 2)‖ * n4R ^ (-5 / 2 : ℝ)
        ≤ (Real.sqrt 3 / 540) * ((101 / 100 : ℝ) ^ 3 * t0 ^ 3) *
            n4R ^ (-5 / 2 : ℝ) := by
          have hstep : (Real.sqrt 3 / 540) * ‖sOn * (sOn + 1) * (sOn + 2)‖ ≤
              (Real.sqrt 3 / 540) * ((101 / 100 : ℝ) ^ 3 * t0 ^ 3) :=
            mul_le_mul_of_nonneg_left hprod (by positivity)
          exact mul_le_mul_of_nonneg_right hstep (by positivity)
      _ ≤ (Real.sqrt 3 / 540) * ((101 / 100 : ℝ) ^ 3 * t0 ^ 3) *
            ((31000000 : ℝ) * t0 ^ 4) ^ (-5 / 2 : ℝ) :=
        mul_le_mul_of_nonneg_left hi5 (by positivity)
      _ = (Real.sqrt 3 / 540) * ((101 / 100 : ℝ) ^ 3 * t0 ^ 3) *
          ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t0 ^ (-10 : ℝ)) := by rw [hsp5]
      _ ≤ (1 / 10 ^ 30 : ℝ) * t0 ^ (-2 : ℝ) := by
          have hstep : (Real.sqrt 3 / 540) * ((101 / 100 : ℝ) ^ 3 * t0 ^ 3) *
                  ((31000000 : ℝ) ^ (-5 / 2 : ℝ) * t0 ^ (-10 : ℝ)) =
              ((Real.sqrt 3 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 *
                (31000000 : ℝ) ^ (-5 / 2 : ℝ)) * (t0 ^ 3 * t0 ^ (-10 : ℝ)) := by ring
          rw [hstep]
          have hstep2 : ((Real.sqrt 3 / 540 : ℝ) * (101 / 100 : ℝ) ^ 3 *
                  (31000000 : ℝ) ^ (-5 / 2 : ℝ)) * (t0 ^ 3 * t0 ^ (-10 : ℝ)) ≤
              (1 / 10 ^ 16 : ℝ) * (t0 ^ 3 * t0 ^ (-10 : ℝ)) :=
            mul_le_mul_of_nonneg_right hcoef3 (by positivity)
          have hcov : t0 ^ 3 * t0 ^ (-10 : ℝ) = t0 ^ (-7 : ℝ) := by
            have h3c : t0 ^ 3 = (t0 : ℝ) ^ (3 : ℝ) :=
              (Real.rpow_natCast t0 3).symm
            calc t0 ^ 3 * t0 ^ (-10 : ℝ)
                = (t0 : ℝ) ^ (3 : ℝ) * t0 ^ (-10 : ℝ) := by rw [h3c]
              _ = (t0 : ℝ) ^ ((3 : ℝ) + (-10 : ℝ)) := by
                  rw [← Real.rpow_add (by positivity : 0 < t0) 3 (-10 : ℝ)]
              _ = t0 ^ (-7 : ℝ) := by
                  rw [show ((3 : ℝ) + (-10 : ℝ)) = (-7 : ℝ) by norm_num]
          rw [hcov] at hstep2 ⊢
          have hstep3 : (1 / 10 ^ 16 : ℝ) * t0 ^ (-7 : ℝ) ≤
              (1 / 10 ^ 30 : ℝ) * t0 ^ (-2 : ℝ) := by
            have h3t : (t0 : ℝ) ^ (-5 : ℝ) ≤ (1000 : ℝ) ^ (-5 : ℝ) := by
              have h5b : (1000 : ℝ) ^ 5 ≤ (t0 : ℝ) ^ 5 :=
                pow_le_pow_left₀ (by norm_num : 0 ≤ (1000 : ℝ)) ht0 5
              have h5t : (t0 : ℝ) ^ (-5 : ℝ) = (1 : ℝ) / (t0 : ℝ) ^ 5 := by
                rw [Real.rpow_neg (by positivity : 0 ≤ t0) 5]
                have ec : (t0 : ℝ) ^ (5 : ℝ) = (t0 : ℝ) ^ ((5 : ℕ) : ℝ) := by congr
                rw [ec, Real.rpow_natCast t0 (5 : ℕ), inv_eq_one_div]
              have h5k : (1000 : ℝ) ^ (-5 : ℝ) = (1 : ℝ) / (1000 : ℝ) ^ 5 := by
                rw [Real.rpow_neg (by norm_num : 0 ≤ (1000 : ℝ)) 5]
                have ec : (1000 : ℝ) ^ (5 : ℝ) = (1000 : ℝ) ^ ((5 : ℕ) : ℝ) := by congr
                rw [ec, Real.rpow_natCast (1000 : ℝ) (5 : ℕ), inv_eq_one_div]
              rw [h5t, h5k]
              exact one_div_le_one_div_of_le
                (by positivity : 0 < (1000 : ℝ) ^ 5) h5b
            have h1000c : (1000 : ℝ) ^ (-5 : ℝ) = (1 / 10 ^ 15 : ℝ) := by
              have h5k : (1000 : ℝ) ^ (-5 : ℝ) = (1 : ℝ) / (1000 : ℝ) ^ 5 := by
                rw [Real.rpow_neg (by norm_num : 0 ≤ (1000 : ℝ)) 5]
                have ec : (1000 : ℝ) ^ (5 : ℝ) = (1000 : ℝ) ^ ((5 : ℕ) : ℝ) := by congr
                rw [ec, Real.rpow_natCast (1000 : ℝ) (5 : ℕ), inv_eq_one_div]
              rw [h5k]
              norm_num
            calc (1 / 10 ^ 16 : ℝ) * t0 ^ (-7 : ℝ)
                = (1 / 10 ^ 16 : ℝ) * ((t0 : ℝ) ^ (-2 : ℝ) * (t0 : ℝ) ^ (-5 : ℝ)) := by
                    have he : (t0 : ℝ) ^ (-7 : ℝ) =
                          (t0 : ℝ) ^ ((-2 : ℝ) + (-5 : ℝ)) := by
                        congr
                        norm_num
                    rw [he,
                          Real.rpow_add (by positivity : 0 < t0) ((-2 : ℝ)) ((-5 : ℝ))]
                  _ ≤ (1 / 10 ^ 16 : ℝ) * ((t0 : ℝ) ^ (-2 : ℝ) *
                        (1000 : ℝ) ^ (-5 : ℝ)) :=
                    mul_le_mul_of_nonneg_left
                      (mul_le_mul_of_nonneg_left h3t (by positivity))
                      (by positivity)
                  _ = (1 / 10 ^ 16 : ℝ) * ((t0 : ℝ) ^ (-2 : ℝ) *
                        (1 / 10 ^ 15 : ℝ)) := by
                    rw [h1000c]
                  _ = t0 ^ (-2 : ℝ) * (1 / 10 ^ 31 : ℝ) := by
                    ring_nf
                  _ = (1 / 10 ^ 31 : ℝ) * t0 ^ (-2 : ℝ) := by ring
                  _ ≤ (1 / 10 ^ 30 : ℝ) * t0 ^ (-2 : ℝ) :=
                    mul_le_mul_of_nonneg_right
                      (by norm_num : (1 / 10 ^ 31 : ℝ) ≤ (1 / 10 ^ 30 : ℝ))
                      (by positivity)
          exact le_trans hstep2 hstep3
  have hsum : (1 / 2) * n4R ^ (-1 / 2 : ℝ) +
          (‖sOn‖ / 12) * n4R ^ (-3 / 2 : ℝ) +
          (Real.sqrt 3 / 540) * ‖sOn * (sOn + 1) * (sOn + 2)‖ *
            n4R ^ (-5 / 2 : ℝ) ≤
        (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) := by
    calc _ ≤ (89803 / 10 ^ 9 : ℝ) * t0 ^ (-2 : ℝ) +
                (1 / 10 ^ 18 : ℝ) * t0 ^ (-2 : ℝ) +
                (1 / 10 ^ 30 : ℝ) * t0 ^ (-2 : ℝ) :=
          by simpa [add_assoc] using add_le_add hT1 (add_le_add hT2 hT3)
      _ ≤ (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) := by
        have hconst : (89803 / 10 ^ 9 : ℝ) + (1 / 10 ^ 18 : ℝ) +
            (1 / 10 ^ 30 : ℝ) ≤ (9 / 10 ^ 5 : ℝ) := by
          field_simp
          norm_num
        calc _ = t0 ^ (-2 : ℝ) * ((89803 / 10 ^ 9 : ℝ) +
                  (1 / 10 ^ 18 : ℝ) + (1 / 10 ^ 30 : ℝ)) := by ring
          _ ≤ t0 ^ (-2 : ℝ) * (9 / 10 ^ 5 : ℝ) :=
            mul_le_mul_of_nonneg_left hconst
              (le_of_lt (Real.rpow_pos_of_pos (by linarith : 0 < t0) (-2 : ℝ)))
          _ = (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) := by ring
  dsimp only [p8_B]
  have hinline : ((1 / 2 : ℝ) : ℂ) + (t0 : ℂ) * Complex.I = sOn := rfl
  have hn4r : (S4Strip.n4 t0 : ℝ) = n4R := by rfl
  simpa only [hinline, hn4r] using hsum

/-  §4  -  G-hs3-iii:  the  strip-band  margin  composition.  -/

/-- G-hs3-iii (machine part): on the strip band, the lifted EM wall at
    the t^4 schedule (p8_B, via t4m_Bupper) PLUS the off-line M-wire
    (t4m_Mterm + t4m_Mpin) sits strictly below the endpoint strip
    floor;  floor = mown on the band (FUnif), and mown >= F4 t^{-2}
    (S4Strip).  Corner: 9e-5 + 2.5e-15 t^{-2.5} < F4, pinned with
    2.5e-15 t^{-2.5} <= 1e-21 (t = 1000 corner;  exact decimals).
    1000 <= t0, 1/200 <= d0 <= 1/2. -/
theorem t4m_margin (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hdlo : (1 / 200 : ℝ) ≤ d0)
    (hd : d0 ≤ 1 / 2) :
    p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 < S1LowT.floStripMin t0 d0 := by
  have hd0p : 0 < d0 := by linarith [hdlo]
  have hflo : S1LowT.floStripMin t0 d0 = S4O.mown t0 d0 :=
    FUnif.floStripMin_eq_mownOnBand t0 d0 ht0 hd0p hd
  have hsmall : (25 / 10 ^ 15 : ℝ) * t0 ^ (-(5 / 2 : ℝ)) ≤ (1 / 10 ^ 21 : ℝ) := by
    have hbase : (1000 : ℝ) ^ (5 / 2 : ℝ) ≤ (t0 : ℝ) ^ (5 / 2 : ℝ) :=
      Real.rpow_le_rpow (by norm_num : 0 ≤ (1000 : ℝ)) ht0
        (by norm_num : 0 ≤ (5 / 2 : ℝ))
    have h1000 : (25000000 : ℝ) ≤ (1000 : ℝ) ^ (5 / 2 : ℝ) := by
      have hsq : (25000000 : ℝ) ^ 2 ≤ ((1000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2 := by
        have hR : ((1000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2 = (1000 : ℝ) ^ 5 := by
          calc ((1000 : ℝ) ^ (5 / 2 : ℝ)) ^ 2
              = ((1000 : ℝ) ^ (5 / 2 : ℝ)) ^ (2 : ℝ) :=
                (Real.rpow_two ((1000 : ℝ) ^ (5 / 2 : ℝ))).symm
            _ = (1000 : ℝ) ^ ((5 / 2 : ℝ) * 2) :=
                (Real.rpow_mul (by norm_num : 0 ≤ (1000 : ℝ)) ((5 / 2 : ℝ)) 2).symm
            _ = (1000 : ℝ) ^ (5 : ℝ) := by
                have he : (1000 : ℝ) ^ ((5 / 2 : ℝ) * 2) = (1000 : ℝ) ^ (5 : ℝ) := by
                  congr 1
                  norm_num
                rw [he]
            _ = (1000 : ℝ) ^ 5 := by
                have ec : (5 : ℝ) = ((5 : ℕ) : ℝ) := by congr
                rw [ec]
                exact Real.rpow_natCast (1000 : ℝ) (5 : ℕ)
        rw [hR]
        norm_num
      have hL : 0 ≤ (25000000 : ℝ) := by norm_num
      have hR : 0 ≤ (1000 : ℝ) ^ (5 / 2 : ℝ) := by positivity
      exact (sq_le_sq₀ hL hR).mp hsq
    have hinvb : (t0 : ℝ) ^ (-(5 / 2 : ℝ)) ≤ ((1000 : ℝ) ^ (5 / 2 : ℝ))⁻¹ := by
      have hT : (t0 : ℝ) ^ (-(5 / 2 : ℝ)) = ((t0 : ℝ) ^ (5 / 2 : ℝ))⁻¹ :=
        Real.rpow_neg (by linarith : 0 ≤ t0) ((5 / 2 : ℝ))
      rw [hT, inv_eq_one_div ((t0 : ℝ) ^ (5 / 2 : ℝ)),
          inv_eq_one_div ((1000 : ℝ) ^ (5 / 2 : ℝ))]
      exact (one_div_le_one_div
          (Real.rpow_pos_of_pos (by linarith : 0 < t0) ((5 / 2 : ℝ)))
          (Real.rpow_pos_of_pos (by norm_num : 0 < (1000 : ℝ)) ((5 / 2 : ℝ)))).mpr hbase
    calc (25 / 10 ^ 15 : ℝ) * t0 ^ (-(5 / 2 : ℝ))
        ≤ (25 / 10 ^ 15 : ℝ) * ((1000 : ℝ) ^ (5 / 2 : ℝ))⁻¹ :=
          mul_le_mul_of_nonneg_left hinvb (by norm_num : 0 ≤ (25 / 10 ^ 15 : ℝ))
        _ ≤ (25 / 10 ^ 15 : ℝ) * ((25000000 : ℝ))⁻¹ := by
            have hinv : ((1000 : ℝ) ^ (5 / 2 : ℝ))⁻¹ ≤ (25000000 : ℝ)⁻¹ := by
              rw [inv_eq_one_div ((1000 : ℝ) ^ (5 / 2 : ℝ)),
                  inv_eq_one_div (25000000 : ℝ)]
              exact (one_div_le_one_div
                  (Real.rpow_pos_of_pos (by norm_num : 0 < (1000 : ℝ))
                    ((5 / 2 : ℝ)))
                  (by norm_num : 0 < (25000000 : ℝ))).mpr h1000
            exact mul_le_mul_of_nonneg_left hinv
              (by norm_num : 0 ≤ (25 / 10 ^ 15 : ℝ))
        _ = (1 / 10 ^ 21 : ℝ) := by
            field_simp
            norm_num
  have hcorner : (9 / 10 ^ 5 : ℝ) + (1 / 10 ^ 21 : ℝ) < S4Strip.F4 := by
    dsimp only [S4Strip.F4]
    norm_num
  calc p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0
      ≤ (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) +
          S4Strip.MTUBfun t0 * t0 ^ (d0 / 2) :=
        add_le_add (t4m_Bupper t0 ht0) (t4m_Mterm t0 d0 ht0 hd)
    _ ≤ (9 / 10 ^ 5 : ℝ) * t0 ^ (-2 : ℝ) +
          (25 / 10 ^ 15 : ℝ) * t0 ^ (-(9 / 2 : ℝ)) :=
        add_le_add le_rfl (t4m_Mpin t0 d0 ht0 hd)
    _ = t0 ^ (-2 : ℝ) * ((9 / 10 ^ 5 : ℝ) +
          (25 / 10 ^ 15 : ℝ) * t0 ^ (-(5 / 2 : ℝ))) := by
        have hs : (t0 : ℝ) ^ ((-2 : ℝ) + (-(5 / 2 : ℝ))) =
            (t0 : ℝ) ^ (-2 : ℝ) * (t0 : ℝ) ^ (-(5 / 2 : ℝ)) :=
          Real.rpow_add (by linarith : 0 < t0) (-2 : ℝ) (-(5 / 2 : ℝ))
        rw [show (-(9 / 2 : ℝ)) = (-2 : ℝ) + (-(5 / 2 : ℝ)) by norm_num, hs]
        ring
    _ < t0 ^ (-2 : ℝ) * S4Strip.F4 := by
        calc (t0 : ℝ) ^ (-2 : ℝ) * ((9 / 10 ^ 5 : ℝ) +
                (25 / 10 ^ 15 : ℝ) * t0 ^ (-(5 / 2 : ℝ)))
            ≤ (t0 : ℝ) ^ (-2 : ℝ) * ((9 / 10 ^ 5 : ℝ) + (1 / 10 ^ 21 : ℝ)) :=
              mul_le_mul_of_nonneg_left (add_le_add le_rfl hsmall)
                (le_of_lt (Real.rpow_pos_of_pos (by linarith : 0 < t0) (-2 : ℝ)))
            _ < (t0 : ℝ) ^ (-2 : ℝ) * S4Strip.F4 := by
              simpa [mul_comm] using mul_lt_mul_of_pos_right hcorner
                (Real.rpow_pos_of_pos (by linarith : 0 < t0) (-2 : ℝ))
    _ = S4Strip.F4 * t0 ^ (-2 : ℝ) := by ring
    _ ≤ S4O.mown t0 d0 :=
      S4Strip.st_mownfloor t0 d0 ht0 hd0p hdlo hd
    _ = S1LowT.floStripMin t0 d0 := hflo.symm

/-  §5  -  schedule  monotonicity  +  the  G-hs3-ii  terminal.  -/

/-- p8_B is non-increasing in n (each term is n^{-k/2}, k > 0). -/
theorem t4m_Bmono (t : ℝ) (m n : ℕ) (hmn : m ≤ n) (hm : 0 < m) :
    p8_B t n ≤ p8_B t m := by
  dsimp only [p8_B]
  have hmR : 0 < (m : ℝ) := Nat.cast_pos.mpr hm
  have hnR : 0 < (n : ℝ) := Nat.cast_pos.2 (lt_of_lt_of_le hm hmn)
  have hc : (m : ℝ) ≤ (n : ℝ) := Nat.cast_le.2 hmn
  --  n^{-k}  <=  m^{-k}  for  k  >=  0
  have hneg (k : ℝ) (hk : 0 ≤ k) : (n : ℝ) ^ (-(k : ℝ)) ≤ (m : ℝ) ^ (-(k : ℝ)) := by
    have hposA : 0 < (m : ℝ) ^ k := Real.rpow_pos_of_pos hmR k
    have hbase : (m : ℝ) ^ k ≤ (n : ℝ) ^ k :=
      Real.rpow_le_rpow (le_of_lt hmR) hc hk
    rw [show (n : ℝ) ^ (-(k : ℝ)) = ((n : ℝ) ^ (k : ℝ))⁻¹ from
        Real.rpow_neg (by positivity : 0 ≤ (n : ℝ)) k,
      show (m : ℝ) ^ (-(k : ℝ)) = ((m : ℝ) ^ (k : ℝ))⁻¹ from
        Real.rpow_neg (by positivity : 0 ≤ (m : ℝ)) k]
    rw [inv_eq_one_div ((n : ℝ) ^ k), inv_eq_one_div ((m : ℝ) ^ k)]
    exact one_div_le_one_div_of_le hposA hbase
  refine add_le_add ?_ ?_
  · refine add_le_add ?_ ?_
    · simpa [show (n : ℝ) ^ ((-1 / 2 : ℝ)) = (n : ℝ) ^ (-(1 / 2 : ℝ)) by
          congr 1
          norm_num,
        show (m : ℝ) ^ ((-1 / 2 : ℝ)) = (m : ℝ) ^ (-(1 / 2 : ℝ)) by
          congr 1
          norm_num] using
        mul_le_mul_of_nonneg_left (hneg (1 / 2) (by norm_num : 0 ≤ (1 / 2 : ℝ)))
          (by norm_num : 0 ≤ (1 / 2 : ℝ))
    · simpa [show (n : ℝ) ^ ((-3 / 2 : ℝ)) = (n : ℝ) ^ (-(3 / 2 : ℝ)) by
          congr 1
          norm_num,
        show (m : ℝ) ^ ((-3 / 2 : ℝ)) = (m : ℝ) ^ (-(3 / 2 : ℝ)) by
          congr 1
          norm_num] using
        mul_le_mul_of_nonneg_left (hneg (3 / 2) (by norm_num : 0 ≤ (3 / 2 : ℝ)))
          (by positivity : 0 ≤ ‖((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I‖ / 12)
  · simpa [show (n : ℝ) ^ ((-5 / 2 : ℝ)) = (n : ℝ) ^ (-(5 / 2 : ℝ)) by
        congr 1
        norm_num,
      show (m : ℝ) ^ ((-5 / 2 : ℝ)) = (m : ℝ) ^ (-(5 / 2 : ℝ)) by
        congr 1
        norm_num] using
    mul_le_mul_of_nonneg_left (hneg (5 / 2) (by norm_num : 0 ≤ (5 / 2 : ℝ)))
      (by positivity : 0 ≤ (Real.sqrt 3 / 540 : ℝ) *
        ‖(((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 1) *
          (((1 / 2 : ℝ) : ℂ) + (t : ℂ) * Complex.I + 2)‖)

/-- The G-hs3-ii + iii terminal (OFF-LINE A5 form, P8Floor A5 shape):
    at the off-pair zero height s = (1/2 + d0) + i*t0,
        ‖p4_Wn s n - (K - (p4_P n s - p4_I n s))‖
        < S1LowT.floStripMin t0 d0
    under
      hW : ‖p4_Wn s n‖ <= p8_B t0 (S4Strip.n4 t0)
            [the W-side lifted wall, G-hs3-i:  T4OffD.lean wall +
            schedule comparison via t4m_Bmono],
      hK : ‖K - (p4_P n s - p4_I n s)‖ <= Mval,
           Mval <= t4m_MwireOff t0 d0
            [the K-side g^{-sigma} wired gap, G-hs3-ii:  the
            CITED convexity mass lift (module header) + the
            sigma-independent b3 S4X chain].
    Triangle  +  t4m_margin.  1000  <=  t0,  1/200  <=  d0  <=  1/2.  -/
theorem t4m_resid_strip (t0 d0 : ℝ) (ht0 : 1000 ≤ t0) (hdlo : (1 / 200 : ℝ) ≤ d0)
    (hd : d0 ≤ 1 / 2) (n : ℕ) (hn : 0 < n) (K : ℂ) (Mval : ℝ)
    (hM : Mval ≤ t4m_MwireOff t0 d0)
    (hW : ‖p4_Wn ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I) n‖ ≤
          p8_B t0 (S4Strip.n4 t0))
    (hK : ‖K - (p4_P n ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I) -
          p4_I n ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I))‖ ≤ Mval) :
    ‖p4_Wn ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I) n -
        (K - (p4_P n ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I) -
        p4_I n ((1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I)))‖
    < S1LowT.floStripMin t0 d0 := by
  set s : ℂ := (1 / 2 : ℝ) + d0 + (t0 : ℂ) * Complex.I with hs
  have htri : ‖p4_Wn s n - (K - (p4_P n s - p4_I n s))‖ ≤
      ‖p4_Wn s n‖ + ‖K - (p4_P n s - p4_I n s)‖ :=
    norm_sub_le (p4_Wn s n) (K - (p4_P n s - p4_I n s))
  have hsum : ‖p4_Wn s n‖ + ‖K - (p4_P n s - p4_I n s)‖ ≤
      p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 :=
    add_le_add hW (le_trans hK hM)
  have hmain : ‖p4_Wn s n - (K - (p4_P n s - p4_I n s))‖ <
      S1LowT.floStripMin t0 d0 :=
    calc ‖p4_Wn s n - (K - (p4_P n s - p4_I n s))‖
        ≤ ‖p4_Wn s n‖ + ‖K - (p4_P n s - p4_I n s)‖ := htri
      _ ≤ p8_B t0 (S4Strip.n4 t0) + t4m_MwireOff t0 d0 := hsum
      _ < S1LowT.floStripMin t0 d0 := t4m_margin t0 d0 ht0 hdlo hd
  simpa only [hs] using hmain
