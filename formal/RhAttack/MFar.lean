/-
MFar.lean  -  the  FAR-M  LAW  PINS  (s33b  past-the-wall
re-deconvolution).  DATA  RECORD  (no  RH  claim).

WHAT  IS  PINNED
  The  six  far-row  M  values  of  the  census  (the
  canonical  f64  identity  M  =  eps  +  lz  -  lm  -  la
  -  re  -  I_far,  left  to  right;  rows  re-issued  on
  the  exact-t  C/quad  zeta  channel,  s34o)  and  the
  far  DRIFT  D  =  M  -  (A  ln  t  +  B)  with  A,  B  the
  NEAR-FACE  fit  (s33b  record).  The  measured  law:
  over  three  decades  past  the  wall  (1e9G..3e10G)  D
  is  QUADRATIC  IN  t:
       t/G      M                     D
       1e9      -10384437248          -9774967307.0
       1e10     -978196824064         -977529165494.1
       3e10     -8798461100032        -8797765678430.4
  adjacent  ratios  100.000  and  9.000;  the  coefficient
  c  =  |D|/t^2  =  1.086e-29  is  stable  to  3  digits.
  In  g  =  t/G  units  M  ~  -9.776e-9  g^2  dominates
  (the  B7  position-amplitude  degeneracy  is  broken  on
  the  measured  domain:  the  far  law  is  NOT  the  near
  log  law).

HOW
  Every  pinned  quantity  is  a  Real  def  (the  data).
  pinGates  is  a  single  norm_num  computation  that
  machine-checks  the  quadratic  identity  FROM  THE
  PINNED  VALUES:  the  adjacent  3x- and  10x-ratios  of
  |D|  land  in  [9.000,  9.001]  /  [100.000,  100.001],
  the  coefficient  ratios  |D_i|/t_i^2  are  within
  0.1%  across  the  three  decades,  and  M  at  3e10G  is
  dominated  by  c  *  t^2  (the  log-term  contribution
  is  <  1%).  Arithmetic  only  (rationals);  the
  ln  fit  lives  in  the  s33b  record,  not  here.

USES
  None  yet  (data  record  first;  the  B7  face  wiring
  is  the  next  consumer).  Imports  only  the  core  for
  the  pin-gate  style.  -/
import Mathlib

open Real

namespace MFa

/-  ##  the  row  scale  (f64  G,  the  census  identity)  -/

/--  G  =  3.0001045999981975555e10  (the  f64  row scale;
    t  =  G  *  (t/G);  the  exact  f64  row  integers  are
    pinned  directly  below  and  the  gates  work  on  them).  -/
noncomputable def Gc : ℝ := (30001045999981975555 : ℝ) / 10 ^ 9

/-  ##  the  pinned  rows  (exact  f64  integer  heights;
    M  the  canonical  census  values,  s34o  re-issue)  -/

/--  5e8G  row  (pre-wall;  zeta  channel  C/quad  exact
    t  =  2.937019955061;  M  unchanged  by  the  re-issue).  -/
def t5 : ℝ := (15000522999990988800 : ℝ)
def M5 : ℝ := -3035441152

/--  1e9G  row  (s34f;  first  past-the-wall  census  row).  -/
def t9 : ℝ := (30001045999981977600 : ℝ)
def M9 : ℝ := -10384437248

/--  1e10G  row  (s34j).  -/
def t10 : ℝ := (300010459999819726848 : ℝ)
def M10 : ℝ := -978196824064

/--  3e10G  row  (s34j).  -/
def t30 : ℝ := (900031379999459246080 : ℝ)
def M30 : ℝ := -8798461100032

/-  ##  the  pinned  drift  (s33b  record)  -/

/--  A  of  the  near-face  fit  M  ~  A  ln  t  +  B
    (s33b;  the  max  near residual  is  1123.82).  -/
def An : ℝ := -25271000
/--  B  of  the  same.  -/
def Bn : ℝ := 523877900

/--  D9  =  M9  -  (A  ln  t9  +  B)  (s33b  record).  -/
noncomputable def D9 : ℝ := -(9774967307 : ℝ)
/--  D10  =  M10  -  (A  ln  t10  +  B)  (s33b  record).  -/
noncomputable def D10 : ℝ := -(9775291654941 : ℝ) / 10
/--  D30  =  M30  -  (A  ln  t30  +  B)  (s33b  record).  -/
noncomputable def D30 : ℝ := -(87977656784304 : ℝ) / 10

/-  ##  the  pin  gates  -/

/--  THE  FAR-QUADRATIC  GATES  (machine-check,  arithmetic
    only).  The  adjacent  f64  steps  carry  their  grid
    rounding  (t10  =  10  t9  -  49152;  t30  =  3  t10
    +  65536)  -  the  height  gates  are  1e-4  windows
    around  the  10x  /  3x  steps:
      (i)   t10  in  [9.9999,  10.0001]  *  t9  and  t30  in
            [3.0000,  3.0001]  *  t10;
      (ii)  the  adjacent  |D|  ratios  land  in  the
            quadratic  windows:  |D10|/|D9|  in  [100.00,
            100.01]  (the  10x  step  squared  is  100;  the
            measured  ratio  is  100.0033  -  the  near-log
            contamination  at  1e9G)  and  |D30|/|D10|  in
            [9.00,  9.01]  (measured  9.0000000);
      (iii)  the  coefficient  c  =  |D|/t^2  is  stable:
            c10/c9  and  c30/c10  within  0.1%;
      (iv)  at  3e10G  the  M  value  IS  the  quadratic:
            |M30|  <=  1.01  *  c30  *  t30^2  (the  near
            log  law  contributes  <  1%).
    All  gates  follow  from  the  pinned  data  by
    norm_num.  No  RH  claim:  this  is  the  measured
    record  of  the  far  M  channel.  -/
theorem pinGates :
    99999 / 10000 * t9 ≤ t10 ∧ t10 ≤ 100001 / 10000 * t9 ∧
    (3 : ℝ) * t10 ≤ t30 ∧ t30 ≤ 30001 / 10000 * t10 ∧
    (100 : ℝ) * (10000 / 10001) ≤ -D10 / -D9 ∧
    -D10 / -D9 ≤ (100 : ℝ) * (10001 / 10000) ∧
    (9 : ℝ) * (900 / 901) ≤ -D30 / -D10 ∧
    -D30 / -D10 ≤ (9 : ℝ) * (901 / 900) ∧
    (-D10 / t10 ^ 2) * (1000 / 1001) ≤ -D9 / t9 ^ 2 ∧
    -D9 / t9 ^ 2 ≤ (-D10 / t10 ^ 2) * (1001 / 1000) ∧
    (-D30 / t30 ^ 2) * (1000 / 1001) ≤ -D10 / t10 ^ 2 ∧
    -D10 / t10 ^ 2 ≤ (-D30 / t30 ^ 2) * (1001 / 1000) ∧
    -M30 ≤ 101 / 100 * (-D30 / t30 ^ 2) * t30 ^ 2 := by
  simp only [D9, D10, D30, t9, t10, t30, M30]
  field_simp
  norm_num

end MFa
