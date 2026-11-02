import  Mathlib
import  RhAttack.P4Em2
import  RhAttack.P4Tail
import  RhAttack.P4Limit
import  RhAttack.T4OffL

set_option  linter.style.whitespace  false
set_option  linter.style.longLine  false

open  Real  Set  Filter  MeasureTheory  Finset
open  scoped  Topology
open  Complex

noncomputable  section

/-  P8A2c  --  A2c  IN  BODY:  the  EM  bridge  at  the  off-points
    -  the  0255  parked  open  question  (1),  under  attack.

    THE  CITED  FACT  (P8Floor  A2c  doc,  T4OffLE/T4OffLF/T4OffLG/
    T4OffLI  docstrings):  the  two  sides

        riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s      (W  side)
        p4_em_expr  s  n                                  (P4  side)

    are  CITED  equal  (DLMF  25.2.8  /  Apostol  Thm  12.21)  at
    Re  s  =  1/2;  at  Re  s  >  1  the  equality  is  the  LEAN-
    proven  P4Limit  p4_identity.

    GOAL  (identity  theorem  plan,  unit  by  unit):  on  the
    domain  U  =  a2c_Dcut  =  {s  |  s.re  >  -1}  \  {1},

        (U  =  a2c_Dcut)  ...  both  sides  analytic  on  U,  equal
        on  {Re  s  >  1}  ⊂  U  (p4_identity),  U  preconnected
        =>  equal  everywhere  on  U  =>  in  particular  at  every
        band  off-point  t4l_sOffL  t  d0  (1000  <=  t,
        0  <  d0  <  1/2)  -  the  cited  A2c  bridge  in  body.

    LANDED  IN  THIS  FILE  (U0,  all  machine-checked):
      *  a2c_D /  a2c_Dcut  domains,  a2c_D  open  +  convex  +
        connected,  a2c_Dcut  open;
      *  the  3-segment  path  geometry  through  the  vertical
        line  {Re  =  2}:  anchor  a2c_anchor  and  the  segment
        lemmas  a2c_segA_in_Dcut  /  a2c_segM_in_Dcut  (every
        point  of  the  path  stays  in  a2c_Dcut  -  these  are
        the  building  blocks  of  the  U  preconnectedness);
      *  a2c_sL_in_Dcut:  the  band  off-points  lie  in  U.

    ROADMAP  (next  units,  all  APIs  checked  present  in  this
    mathlib  checkout):
      U1   integrand  F(s,x)  =  (B2  x)  *  p4_f2  s  x  has  an
           explicit  s-derivative  (HasFDerivAt)  at  every  s;
      U2   F  and  its  s-derivative  are  integrable  over  Ioi  n
           for  every  s  with  s.re  >  -1,  n  ≥  1
           (comparison  with  x^(-s.re-2),  |B2|  ≤  1/6);
      U3   local  Lipschitz-in-s  with  an  integrable  bound;
      U4   Mathlib  hasFDerivAt_integral_of_dominated_loc_of_lip
           =>  the  s ↦ ∫_Ioi n F(s,·)  term  of  p4_em_expr  is
           differentiable  on  {Re  s  >  -1}  (hence
           AnalyticOnNhd,  via  DifferentiableOn.analyticOnNhd);
      U5   the  remaining  pieces  (riemannZeta:
           analyticOn_riemannZeta  on  {1}ᶜ;  p4_P  n  finite
           sum  of  s ↦ (k+1) ^ (-s);  p4_I  n  and  the  closed
           EM  terms:  powers  /  (1-s)  quotients)  analytic  on
           U  -  Assemble  via  AnalyticOnNhd.add/sub/mul/
           const_smul/div;
      U6   a2c_Dcut_preconnected  (from  the  segment  lemmas  via
           JoinedIn  /  IsPathWithinIn  assembly)  +  Mathlib
           eqOn_of_preconnected_of_eventuallyEq  (template:
           Mathlib  NumberTheory/Harmonic/ZetaAsymp)  against
           p4_identity  at  z0  =  2  =>  THE  IDENTITY  IN
           BODY;  then  the  band  off-point  corollary  (U6b).

  DISCIPLINE:  no  RH  claim  anywhere  in  this  file;  no  zero
  statement;  the  only  zeta  input  is  the  named  Mathlib
  analyticity  fact  for  riemannZeta.  This  module  is  pure
  provenance  hardening:  when  U1-U6  land,  the  cited  A2c
  squeeze premise  becomes  an  in-body  theorem  and  0262  (the
  EM-squeeze  infeasibility)  stands  unconditional  in  body. -/

/-! U 0  THE  DOMAIN. -/

/-- The  half-plane  domain  of  the  A2c  identity. -/
def  a2c_D  :  Set  ℂ  :=  {s  |  -1  <  s.re}

/-- The  cut  domain  (the  pole  at  1  removed). -/
def  a2c_Dcut  :  Set  ℂ  :=  a2c_D  \  {1}

theorem  a2c_D_open  :  IsOpen  a2c_D  := by
  have  hD  :  a2c_D  =  Complex.re ⁻¹'  Set.Ioi  (-1 : ℝ)  := by
    ext  s
    simp  only  [a2c_D,  Set.mem_preimage,  Set.mem_Ioi]
    rfl
  rw  [hD]
  exact  IsOpen.preimage  continuous_re  isOpen_Ioi

theorem  a2c_Dconvex  :  Convex ℝ  a2c_D  := by
  intro  x  hx  y  hy  a  b  ha  hb  hab
  have  hx1  :  -1  <  x.re  :=  by  simpa  [a2c_D]  using  hx
  have  hy1  :  -1  <  y.re  :=  by  simpa  [a2c_D]  using  hy
  have  hre  :  -1  <  (a  •  x  +  b  •  y).re  :=  by
    have  hd  :  (a  •  x  +  b  •  y).re  =  a  *  x.re  +  b  *  y.re  := by
      simp  [Complex.add_re]
    rw  [hd]
    have  hshift  :  a  *  x.re  +  b  *  y.re  =
        a  *  (x.re  +  1)  +  b  *  (y.re  +  1)  -  1  :=  by
      have  hA  :  a  *  x.re  +  b  *  y.re  =
          a  *  x.re  +  b  *  y.re  +  (a  +  b)  -  1  :=  by  simp  [hab]
      have  hB  :  a  *  x.re  +  b  *  y.re  +  (a  +  b)  -  1  =
          a  *  (x.re  +  1)  +  b  *  (y.re  +  1)  -  1  :=  by  ring
      calc  a  *  x.re  +  b  *  y.re
          =  a  *  x.re  +  b  *  y.re  +  (a  +  b)  -  1  :=  hA
        _  =  a  *  (x.re  +  1)  +  b  *  (y.re  +  1)  -  1  :=  hB
    rw  [hshift]
    have  hy1p  :  0  <  y.re  +  1  :=  by  linarith  [hy1]
    have  hx1p  :  0  <  x.re  +  1  :=  by  linarith  [hx1]
    have  h2  :  0  ≤  b  *  (y.re  +  1)  :=
      mul_nonneg  hb  (le_of_lt  hy1p)
    have  hpos  :  0  <  a  *  (x.re  +  1)  +  b  *  (y.re  +  1)  :=  by
      by_cases  ha0  :  a  =  0
      · subst  ha0
        have  hb1  :  b  =  1  :=  by  linarith
        subst  hb1
        ring_nf
        linarith  [hy1p]
      · have  hap  :  0  <  a  :=  lt_of_le_of_ne  ha  (Ne.symm  ha0)
        have  hp1  :  0  <  a  *  (x.re  +  1)  :=
          mul_pos  hap  hx1p
        linarith  [hp1,  h2]
    linarith  [hpos]
  simpa  [a2c_D,  Set.mem_ofPred_eq]  using  hre

theorem  a2c_D_nonempty  :  a2c_D.Nonempty  :=  ⟨2,  by  norm_num  [a2c_D]⟩

theorem  a2c_D_connected  :  IsConnected  a2c_D  :=
  Convex.isConnected  a2c_Dconvex  a2c_D_nonempty

theorem  a2c_Dcut_open  :  IsOpen  a2c_Dcut  := by
  rw  [a2c_Dcut]
  exact  a2c_D_open.sdiff  isClosed_singleton

/-! The  anchor  of  the  3-segment  path:
    P(a)  =  2  +  i·(a.im  ≠  0  ?  a.im  :  1). -/

def  a2c_anchor  (a  :  ℂ)  :  ℂ  :=
  if  a.im  =  0  then  Complex.mk  (2  :  ℝ)  1  else  Complex.mk  (2  :  ℝ)  a.im

theorem  a2c_anchor_re  (a  :  ℂ)  :  (a2c_anchor  a).re  =  2  := by
  by_cases  h  :  a.im  =  0
  · simp  [a2c_anchor,  h]
  · simp  [a2c_anchor,  h]

theorem  a2c_anchor_im_nonzero  (a  :  ℂ)  :  (a2c_anchor  a).im  ≠  0  := by
  by_cases  h  :  a.im  =  0
  · intro  he
    have  hA  :  (a2c_anchor  a).im  =  1  :=  by
      rw  [a2c_anchor]
      simp  [h]
    rw  [hA]  at  he
    exact  (by  norm_num  :  (1 : ℝ)  ≠  0)  he
  · intro  he
    have  hA  :  (a2c_anchor  a).im  =  a.im  :=  by
      rw  [a2c_anchor]
      simp  [h]
    rw  [hA]  at  he
    exact  h  he

theorem  a2c_anchor_in_Dcut  (a  :  ℂ)  :  a2c_anchor  a  ∈  a2c_Dcut  := by
  rw  [a2c_Dcut]
  constructor
  · rw  [a2c_D,  Set.mem_ofPred_eq,  a2c_anchor_re]
    norm_num
  · intro  h
    have  h1'  :  a2c_anchor  a  =  1  :=  by  simpa  using  h
    have  him  :  (a2c_anchor  a).im  =  (1 : ℂ).im  :=  congrArg  Complex.im  h1'
    have  h1im  :  (1 : ℂ).im  =  0  :=  by  norm_num
    have  him0  :  (a2c_anchor  a).im  =  0  :=  by  simpa  [h1im]  using  him
    exact  (a2c_anchor_im_nonzero  a)  him0

/-  Segment  a  →  P(a):  p  =  (1  -  r)  a  +  r  P(a),  0  ≤  r
    ≤  1. -/

theorem  a2c_segA_im  (a  :  ℂ)  (r  :  ℝ)  :
    (((1  -  r  :  ℝ))  *  a  +  r  *  a2c_anchor  a).im  =
      (1  -  r)  *  a.im  +  r  *  (a2c_anchor  a).im  := by
  have  h1  :  (((1  -  r  :  ℝ))  *  a).im  =  (1  -  r)  *  a.im  :=
    Complex.im_ofReal_mul  (1  -  r)  a
  have  h2  :  (r  *  a2c_anchor  a).im  =  r  *  (a2c_anchor  a).im  :=
    Complex.im_ofReal_mul  r  (a2c_anchor  a)
  have  hadd  :  ((((1  -  r  :  ℝ))  *  a)  +  r  *  a2c_anchor  a).im  =
      (((1  -  r  :  ℝ))  *  a).im  +  (r  *  a2c_anchor  a).im  :=
    Complex.add_im  (((1  -  r  :  ℝ))  *  a)  (r  *  a2c_anchor  a)
  rw  [hadd,  h1,  h2]

theorem  a2c_segA_in_Dcut  (a  :  ℂ)  (ha  :  a  ∈  a2c_Dcut)  (r  : ℝ)
    (hr  :  0  ≤  r)  (h1  :  r  ≤  1)  :
    ((1  -  r  :  ℝ))  *  a  +  r  *  a2c_anchor  a  ∈  a2c_Dcut  := by
  have  haD  :  -1  <  a.re  :=  by  simpa  [a2c_D,  Set.mem_ofPred_eq]  using  ha.1
  have  haDp  :  0  <  a.re  +  1  :=  by  linarith  [haD]
  have  ha1  :  a  ≠  1  :=  ha.2
  set  p  :=  ((1  -  r  :  ℝ))  *  a  +  r  *  a2c_anchor  a  with  hp
  rw  [a2c_Dcut]
  constructor
  · rw  [a2c_D,  Set.mem_ofPred_eq]
    have  hpRe  :  p.re  =  (1  -  r)  *  a.re  +  r  *  (a2c_anchor  a).re  := by
      have  h1 : (((1  -  r  :  ℝ))  *  a).re = (1  -  r) * a.re :=
        Complex.re_ofReal_mul  (1  -  r)  a
      have  h2 : (r * a2c_anchor a).re = r * (a2c_anchor a).re :=
        Complex.re_ofReal_mul  r  (a2c_anchor  a)
      rw  [hp,  Complex.add_re,  h1,  h2]
    rw  [hpRe,  a2c_anchor_re]
    have  hshift  :  (1  -  r)  *  a.re  +  r  *  2  =
        (1  -  r)  *  (a.re  +  1)  +  r  *  3  -  1  :=  by  ring
    rw  [hshift]
    have  hnon1  :  0  ≤  (1  -  r)  *  (a.re  +  1)  := by
      have  h1r  :  0  ≤  1  -  r  :=  sub_nonneg.mpr  h1
      exact  mul_nonneg  h1r  (le_of_lt  haDp)
    by_cases  hr0  :  r  =  0
    · subst  hr0
      linarith  [haDp]
    · have  hrp  :  0  <  r  :=  lt_of_le_of_ne  hr  (Ne.symm  hr0)
      have  hpos2  :  0  <  r  *  3  :=  mul_pos  hrp  (by  norm_num)
      linarith  [hnon1]
  · intro  h
    have  h1'  :  p  =  1  :=  by  simpa  using  h
    have  him  :  p.im  =  (1 : ℂ).im  :=  congrArg  Complex.im  h1'
    have  h1im  :  (1 : ℂ).im  =  0  :=  by  norm_num
    have  him0  :  p.im  =  0  :=  by  simpa  [h1im]  using  him
    have  himd  :  p.im  =  (1  -  r)  *  a.im  +  r  *  (a2c_anchor  a).im  :=
      a2c_segA_im  a  r
    by_cases  hw  :  a.im  =  0
    · -- a  real:  (a2c_anchor  a).im  =  1,  so  p.im  =  r  =  0  →  p  =  a  =  1
      have  himA  :  (a2c_anchor  a).im  =  1  :=  by
        rw  [a2c_anchor]
        simp  [hw]
      have  himr  :  p.im  =  r  :=  by
        rw  [himd,  himA,  hw]
        ring
      have  hr0  :  r  =  0  :=  by  linarith  [him0,  himr]
      subst  hr0
      have  hp1  :  p  =  a  :=  by  simp  [hp]
      rw  [hp1]  at  h
      exact  ha1  h
    · -- a  non-real:  (a2c_anchor  a).im  =  a.im,  so  p.im  =  a.im  ≠  0
      have  himc  :  (a2c_anchor  a).im  =  a.im  :=  by
        simp  [a2c_anchor,  hw]
      have  hima  :  p.im  =  a.im  :=  by
        rw  [himd,  himc]
        ring
      have  h0  :  a.im  =  0  :=  by  simpa  [hima]  using  him0
      exact  hw  h0

/-  Segment  on  {Re  =  2}:  (1  -  r)  P(a)  +  r  P(b). -/
theorem  a2c_segM_in_Dcut  (a  b  :  ℂ)  (r  :  ℝ)  :
    ((1  -  r  :  ℝ))  *  a2c_anchor  a  +  r  *  a2c_anchor  b  ∈  a2c_Dcut  := by
  set  p  :=  ((1  -  r  :  ℝ))  *  a2c_anchor  a  +  r  *  a2c_anchor  b  with  hp
  rw  [a2c_Dcut]
  constructor
  · rw  [a2c_D,  Set.mem_ofPred_eq]
    have  hpRe  :  p.re  =  (1  -  r)  *  (a2c_anchor  a).re  +  r  *  (a2c_anchor  b).re  := by
      have  h1 : (((1  -  r  :  ℝ))  *  a2c_anchor  a).re = (1  -  r) * (a2c_anchor a).re :=
        Complex.re_ofReal_mul  (1  -  r)  (a2c_anchor  a)
      have  h2 : (r * a2c_anchor b).re = r * (a2c_anchor b).re :=
        Complex.re_ofReal_mul  r  (a2c_anchor  b)
      rw  [hp,  Complex.add_re,  h1,  h2]
    rw  [hpRe,  a2c_anchor_re,  a2c_anchor_re]
    linarith
  · intro  h
    have  h1'  :  p  =  1  :=  by  simpa  using  h
    have  hre  :  (1 : ℂ).re  =  p.re  :=  (congrArg  Complex.re  h1').symm
    have  hpRe1  :  p.re  =
        (((1  -  r  :  ℝ))  *  a2c_anchor  a).re  +  (r  *  a2c_anchor  b).re  := by
      rw  [hp,  Complex.add_re]
    have  h1 : (((1  -  r  :  ℝ))  *  a2c_anchor  a).re
        =  (1  -  r)  *  (a2c_anchor  a).re  :=
      Complex.re_ofReal_mul  (1  -  r)  (a2c_anchor  a)
    have  h2 : (r * a2c_anchor b).re = r * (a2c_anchor b).re :=
      Complex.re_ofReal_mul  r  (a2c_anchor  b)
    have  hpRe2  :  (((1  -  r  :  ℝ))  *  a2c_anchor  a).re  +  (r  *  a2c_anchor  b).re
        =  (1  -  r)  *  (a2c_anchor  a).re  +  r  *  (a2c_anchor  b).re  := by
      rw  [h1,  h2]
    have  hpRe3  :  (1  -  r)  *  (a2c_anchor  a).re  +  r  *  (a2c_anchor  b).re  =  2  := by
      rw  [a2c_anchor_re,  a2c_anchor_re]
      ring
    have  hpre  :  p.re  =  2  :=  by  rw  [hpRe1,  hpRe2,  hpRe3]
    have  h2'  :  (1 : ℝ)  =  2  := by
      calc  (1  :  ℝ)  =  (1  :  ℂ).re  :=  by  norm_num
        _  =  p.re  :=  hre
        _  =  2  :=  hpre
    norm_num  at  h2'

theorem  a2c_sL_in_Dcut  (t  d0  :  ℝ)  (ht  :  1000  ≤  t)  (hd0  :  0  <  d0)
    (hd12  :  d0  <  1  /  2)  :  t4l_sOffL  t  d0  ∈  a2c_Dcut  := by
  rw  [a2c_Dcut]
  have  hreL  :  (t4l_sOffL  t  d0).re  =  1  /  2  -  d0  := by
    dsimp  only  [t4l_sOffL]
    norm_num  [Complex.add_re,  Complex.mul_re]
  have  himL  :  (t4l_sOffL  t  d0).im  =  t  := by
    dsimp  only  [t4l_sOffL]
    norm_num  [Complex.add_im,  Complex.mul_im]
  constructor
  · rw  [a2c_D,  Set.mem_ofPred_eq,  hreL]
    linarith  [hd12]
  · intro  h
    have  hs1  :  t4l_sOffL  t  d0  =  1  := by  simpa  using  h
    have  ht0  :  t  =  0  := by
      have  him0  :  (t4l_sOffL  t  d0).im  =  0  :=  by
        rw  [hs1]
        norm_num
      simpa  [himL]  using  him0
    linarith  [ht0,  ht]

/-! U 1  THE  S-DERIVATIVE  OF  THE  TAIL  INTEGRAND. -/

/-- The  tail  integrand  (the  B2-weighted  x-kernel  of  the
    p4_em_expr  tail  integral). -/
def  a2c_F  (s  :  ℂ)  (x  :  ℝ)  :  ℂ  :=  (B2  x  :  ℂ)  *  p4_f2  s  x

/-- The  explicit  s-derivative  of  the  tail  integrand:
    d/ds  [(B2  x)  ·  s(s+1)  ·  (x:ℂ) ^ (-s-2)]
      =  (B2  x)  ·  (x:ℂ) ^ (-s-2)  ·  (2s  +  1  -  s(s+1)  log  x),
    where  log  x  is  the  real  logarithm  viewed  in  ℂ  -  for
    x  >  0  this  is  exactly  the  complex-power  chain  rule,
    since  Complex.log  (x:ℂ)  =  (log  x :  ℂ)  there  (ofReal_log). -/
def  a2c_Fs  (s  :  ℂ)  (x  :  ℝ)  :  ℂ  :=
  (B2  x  :  ℂ)  *  ((x  :  ℂ)  ^  (-s  -  2)
    *  (2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ)))

/-- U1:  for  each  x  >  0  the  integrand  has  its  s-derivative
    at  EVERY  s  (no  domain  restriction  in  s  -  the  power
    (x:ℂ) ^ (-s-2)  differentiates  in  the  exponent  wherever  the
    base  is  nonzero,  and  x  >  0  is  never  zero). -/
theorem  a2c_Fs_deriv  {x  :  ℝ}  (hx  :  0  <  x)  {s  :  ℂ}  :
    HasDerivAt  (fun  s'  :  ℂ  =>  a2c_F  s'  x)  (a2c_Fs  s  x)  s  :=  by
  have  hhid  :  HasDerivAt  (fun  s'  :  ℂ  =>  (s' : ℂ))  (1 : ℂ)  s  :=  hasDerivAt_id  s
  have  hap  :  HasDerivAt  (fun  s'  :  ℂ  =>  s'  +  1)  (1 : ℂ)  s  :=  by
    have  hr  :=  hhid.add  (hasDerivAt_const  s  1)
    rw  [show  (fun  x  :  ℂ  =>  (x : ℂ))  +  (fun  x  :  ℂ  =>  (1 :  ℂ)) =
          (fun  s'  :  ℂ  =>  s'  +  1)  from  by  funext  k;  simp]  at  hr
    rw  [show  (1 :  ℂ)  +  (0 :  ℂ)  =  (1 :  ℂ)  from  by  ring]  at  hr
    exact  hr
  have  h1  :  HasDerivAt  (fun  s'  :  ℂ  =>  s'  *  (s'  +  1))  (2  *  s  +  1)  s  :=  by
    have  hr  :=  hhid.mul  hap
    rw  [show  (fun  x  :  ℂ  =>  (x : ℂ))  *  (fun  s'  :  ℂ  =>  s'  +  1) =
          (fun  s'  :  ℂ  =>  s'  *  (s'  +  1))  from  by  funext  k;  simp]  at  hr
    rw  [show  (1 :  ℂ)  *  ((fun  s'  :  ℂ  =>  s'  +  1)  s)
      +  ((fun  x  :  ℂ  =>  (x : ℂ))  s)  *  (1 :  ℂ)  =  2  *  s  +  1  from  by
        simp;  ring]  at  hr
    exact  hr
  have  hc0  :  (x : ℂ)  ≠  0  :=  ofReal_ne_zero.mpr  hx.ne'
  have  hlin  :  HasDerivAt  (fun  s'  :  ℂ  =>  (-s'  -  2 :  ℂ))  (-1 :  ℂ)  s  :=  by
    have  hr  :=  hhid.neg.sub  (hasDerivAt_const  s  2)
    rw  [show  (-(fun  x  :  ℂ  =>  (x : ℂ)) :  ℂ  →  ℂ)  -  (fun  x  :  ℂ  =>  (2 :  ℂ)) =
          (fun  s'  :  ℂ  =>  (-s'  -  2 :  ℂ))  from  by  funext  k;  simp]  at  hr
    rw  [show  (-(1 :  ℂ))  -  (0 :  ℂ)  =  (-1 :  ℂ)  from  by  ring]  at  hr
    exact  hr
  have  h2  :  HasDerivAt  (fun  s'  :  ℂ  =>  (x : ℂ) ^ (-s'  -  2))
      ((x : ℂ) ^ (-s  -  2)  *  Complex.log  (x : ℂ)  *  (-1 :  ℂ))  s  := by
      simpa  using  HasDerivAt.const_cpow  hlin  (Or.inl  hc0)
  have  h3  :=  h1.mul  h2
  have  h4  :=  HasDerivAt.const_mul  (B2  x  :  ℂ)  h3
  have  hF  :  (fun  y  :  ℂ  =>  (B2  x  :  ℂ)  *  (((fun  s'  :  ℂ  =>  s'  *  (s'  +  1))  *
      (fun  s'  :  ℂ  =>  (x  : ℂ)  ^  (-s'  -  2)))  y)) =
      (fun  s'  :  ℂ  =>  (B2  x  :  ℂ)  *  (s'  *  (s'  +  1)  *  ((x  : ℂ)  ^  (-s'  -  2))))  :=  by
    funext  k
    simp
  rw  [hF]  at  h4
  have  h4b  :  HasDerivAt  (fun  s'  :  ℂ  =>  (B2  x  :  ℂ)  *  (s'  *  (s'  +  1)  *  ((x  : ℂ)  ^  (-s'  -  2))))
      ((B2  x  :  ℂ)  *  ((2  *  s  +  1)  *  (x  : ℂ)  ^  (-s  -  2)
      +  s  *  (s  +  1)  *  ((x  : ℂ)  ^  (-s  -  2)  *  Complex.log  (x  : ℂ)  *  (-1 :  ℂ))))  s  :=  h4
  have  hL  :  a2c_Fs  s  x  =  (B2  x  :  ℂ)  *  ((2  *  s  +  1)  *  (x : ℂ)  ^  (-s  -  2)
      +  s  *  (s  +  1)  *  ((x : ℂ)  ^  (-s  -  2)  *  Complex.log  (x  :  ℂ)  *  (-1 :  ℂ)))  :=  by
    dsimp  only  [a2c_Fs]
    have  hlog  :  Complex.log  (x : ℂ)  =  (Real.log  x : ℂ)  :=  (ofReal_log  hx.le).symm
    rw  [hlog]
    ring
  simpa  [a2c_F,  p4_f2,  hL]  using  h4b

/-! U 2  INTEGRABILITY  OF  THE  DERIVATIVE  KERNEL  OVER  Ioi  c.

    The  integrand  itself  is  already  in-tree:  P4Limit.
    p4_kernel_integrableOn_Ioi  (Re  s  >  -1).  The  new  fact  here:
    the  s-derivative  kernel  a2c_Fs  s  is  integrable  over  Ioi  c
    at  every  s  with  Re  s  >  -1  (the  logarithmic  side  from
    the  complex-power  chain  rule;  |log x|  grows  slower  than
    any  positive  power). -/

/-- |log  x|  ≤  (x^d  +  x^(-d))  /  d  for  all  x  >  0,  d  >  0
    (from  log  y  ≤  y  -  1  applied  to  y  =  x^d  and  y  =  x^(-d)). -/
theorem  a2c_log_bound  (x  :  ℝ)  (hx  :  0  <  x)  (d  :  ℝ)  (hd  :  0  <  d)  :
    |Real.log  x|  ≤  (x  ^  d  +  x  ^  (-d))  /  d  :=  by
  have  h1  :  d  *  Real.log  x  ≤  x  ^  d  :=  by
    have  h  :  Real.log  (x  ^  d)  ≤  x  ^  d  -  1  :=
      log_le_sub_one_of_pos  (Real.rpow_pos_of_pos  hx  d)
    have  hlogpow  :  Real.log  (x  ^  d)  =  d  *  Real.log  x  :=  by
      rw  [Real.log_rpow  hx]
    nlinarith  [hlogpow,  h]
  have  h2  :  -d  *  Real.log  x  ≤  x  ^  (-d)  :=  by
    have  h  :  Real.log  (x  ^  (-d))  ≤  x  ^  (-d)  -  1  :=
      log_le_sub_one_of_pos  (Real.rpow_pos_of_pos  hx  (-d))
    have  hlogpow  :  Real.log  (x  ^  (-d))  =  (-d)  *  Real.log  x  :=  by
      rw  [Real.log_rpow  hx]
    nlinarith  [hlogpow,  h]
  have  H  :  |d  *  Real.log  x|  ≤  x  ^  d  +  x  ^  (-d)  :=  by
    refine  abs_le.mpr  ⟨?_,  ?_⟩
    · nlinarith  [h2,  show  0  ≤  x  ^  d  from  Real.rpow_nonneg  (le_of_lt  hx)  d]
    · nlinarith  [h1,  show  0  ≤  x  ^  (-d)  from  Real.rpow_nonneg  (le_of_lt  hx)  (-d)]
  have  hdabs  :  d  *  |Real.log  x|  =  |d  *  Real.log  x|  :=  by
    rw  [mul_comm,  abs_mul,  abs_of_pos  hd];  ring
  have  ht  :  |Real.log  x|  *  d  =  d  *  |Real.log  x|  :=  by  ring
  rw  [le_div_iff₀  hd,  ht,  hdabs]
  exact  H

/-- U2:  the  s-derivative  kernel  is  integrable  over  Ioi  c  at
    every  s  with  s.re  >  -1. -/
theorem  a2c_Fs_integrableOn_Ioi  {s  :  ℂ}  (hsre  :  s.re  >  -1)  {c  :  ℝ}  (hc  :  0  <  c)  :
    IntegrableOn  (a2c_Fs  s)  (Set.Ioi  c)  :=  by
  -- comparison  exponents  (a  =  -(s.re  +  2)  <  -1;  d  =  (s.re  +  1)  /  2):
  set  a  :=  -(s.re  +  2 :  ℝ)  with  ha_def
  have  ha  :  a  <  -1  :=  by  dsimp  only  [a];  linarith  [hsre]
  set  d  :=  (s.re  +  1)  /  2  with  hd_def
  have  hd  :  0  <  d  :=  by  dsimp  only  [d];  linarith  [hsre]
  have  ha1  :  a  +  d  <  -1  :=  by  dsimp  only  [d,  a];  ring_nf;  linarith  [hsre]
  have  ha2  :  a  -  d  <  -1  :=  by  dsimp  only  [d,  a];  ring_nf;  linarith  [hsre]
  -- the  three  integrable  comparison  pieces:
  have  hLa  :  Integrable  (fun  x  :  ℝ  =>  x  ^  a)  (volume.restrict  (Set.Ioi  c))  :=
    (integrableOn_Ioi_rpow_of_lt  ha  hc).integrable
  have  hL1  :  Integrable  (fun  x  :  ℝ  =>  x  ^  (a  +  d))  (volume.restrict  (Set.Ioi  c))  :=
    (integrableOn_Ioi_rpow_of_lt  ha1  hc).integrable
  have  hL2  :  Integrable  (fun  x  :  ℝ  =>  x  ^  (a  -  d))  (volume.restrict  (Set.Ioi  c))  :=
    (integrableOn_Ioi_rpow_of_lt  ha2  hc).integrable
  set  M  :=  fun  x  :  ℝ  =>
      ((1  /  6)  *  (‖2  *  s  +  1‖  *  x  ^  a)  +  (1  /  (6  *  d))  *  (‖s  *  (s  +  1)‖  *  x  ^  (a  +  d)))
      +  (1  /  (6  *  d))  *  (‖s  *  (s  +  1)‖  *  x  ^  (a  -  d))
    with  hM_def
  have  hT1  :  Integrable  (fun  x  :  ℝ  =>  (1  /  6)  *  (‖2  *  s  +  1‖  *  x  ^  a))
      (volume.restrict  (Set.Ioi  c))  :=
    (hLa.const_mul  ‖2  *  s  +  1‖).const_mul  (1  /  6)
  have  hT2  :  Integrable  (fun  x  :  ℝ  =>  (1  /  (6  *  d))  *  (‖s  *  (s  +  1)‖  *  x  ^  (a  +  d)))
      (volume.restrict  (Set.Ioi  c))  :=
    (hL1.const_mul  ‖s  *  (s  +  1)‖).const_mul  (1  /  (6  *  d))
  have  hT3  :  Integrable  (fun  x  :  ℝ  =>  (1  /  (6  *  d))  *  (‖s  *  (s  +  1)‖  *  x  ^  (a  -  d)))
      (volume.restrict  (Set.Ioi  c))  :=
    (hL2.const_mul  ‖s  *  (s  +  1)‖).const_mul  (1  /  (6  *  d))
  have  hM  :  HasFiniteIntegral  M  (volume.restrict  (Set.Ioi  c))  :=
    (hT1.add  hT2).add  hT3
    |>.hasFiniteIntegral
  constructor
  · -- measurability:  a2c_Fs  s  =  (B2  ·  :  ℂ)  *  bracket,  with
      -- the  bracket  =  A  +  B  for  A,  B  continuous  on  Ioi  0:
      -- the  bracket  is  assembled  from  continuous  pieces  on  Ioi  0.
    have  hB2a  :  AEStronglyMeasurable  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))
        (volume.restrict  (Set.Ioi  c))  :=
      (AEStronglyMeasurable.mono_measure
        (Continuous.comp_aestronglyMeasurable  (hg  :=  Complex.continuous_ofReal)
          (aestronglyMeasurable_B2 :  AEStronglyMeasurable  B2))
        ((Measure.restrict_mono  (Set.Ioi  c).subset_univ  le_rfl).trans
          (le_of_eq  Measure.restrict_univ)))
    have  hcpow0  :  ContinuousOn  (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2))  (Set.Ioi  0)  :=  by
      intro  x  hx
      exact  (Complex.continuousAt_ofReal_cpow_const  x  (-s  -  2)
        (Or.inr  (ne_of_gt  hx))).continuousWithinAt
    have  hlogR  :  ContinuousOn  (fun  x  :  ℝ  =>  Real.log  x)  (Set.Ioi  0)  :=  by
      apply  ContinuousOn.log
      · exact  continuousOn_id
      · intro  x  hx;  exact  ne_of_gt  hx
    have  hlogC  :  ContinuousOn  (fun  x  :  ℝ  =>  (Real.log  x  :  ℂ))  (Set.Ioi  0)  :=  by
      intro  x  hx
      exact  (Complex.continuous_ofReal.continuousAt.comp
        (Real.continuousAt_log  (ne_of_gt  hx))).continuousWithinAt
    have  hAaes  :  AEStronglyMeasurable
        (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2)  *  (2  *  s  +  1))
        (volume.restrict  (Set.Ioi  c))  :=
      ContinuousOn.aestronglyMeasurable
        ((hcpow0.mul  continuousOn_const).mono  (Ioi_subset_Ioi_iff.mpr  hc.le))
      measurableSet_Ioi
    have  hBaes  :  AEStronglyMeasurable
        (fun  x  :  ℝ  =>  (-(s  *  (s  +  1)) :  ℂ)
          *  ((x  :  ℂ)  ^  (-s  -  2)  *  (Real.log  x  :  ℂ)))
        (volume.restrict  (Set.Ioi  c))  :=
      ContinuousOn.aestronglyMeasurable
        ((ContinuousOn.const_smul  (hcpow0.mul  hlogC)  (-(s  *  (s  +  1)))).mono
          (Ioi_subset_Ioi_iff.mpr  hc.le))
      measurableSet_Ioi
    have  hbrack  :  AEStronglyMeasurable
        (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2)
          *  (2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ)))
        (volume.restrict  (Set.Ioi  c))  :=  by
      have  heq  :  (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2)
          *  (2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ))) =
          (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2)  *  (2  *  s  +  1))
          +  (fun  x  :  ℝ  =>  (-(s  *  (s  +  1)) :  ℂ)  *  ((x  :  ℂ)  ^  (-s  -  2)  *  (Real.log  x  :  ℂ)))  :=  by
        funext  x
        simp
        ring
      simpa  [heq]  using  hAaes.add  hBaes
    simpa  [show  (a2c_Fs  s)  =  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))  *  (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s  -  2)  *  (2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ)))  from  (by  funext  x;  simp  [a2c_Fs])]  using  hB2a.mul  hbrack
  · -- bounded  by  the  integrable  comparison  M:
    rw  [←  hasFiniteIntegral_norm_iff]
    refine  HasFiniteIntegral.mono'  hM  (by
      rw  [ae_restrict_iff'  measurableSet_Ioi]
      exact  MeasureTheory.ae_of_all  (μ  :=  (volume : Measure  ℝ))  (fun  {x  :  ℝ}  =>  fun  (hx  :  x  ∈  Set.Ioi  c)  =>  by
        have  hxpos  :  0  <  x  :=  hc.trans  hx
        have  h1  :  ‖(‖a2c_Fs  s  x‖  :  ℝ)‖  =  ‖a2c_Fs  s  x‖  :=  by  simp
        rw  [h1]
        calc  ‖a2c_Fs  s  x‖
            _  =  ‖(B2  x  :  ℂ)‖  *  ‖(x  :  ℂ)  ^  (-s  -  2)  *  (2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ))‖  :=  by
                  rw  [a2c_Fs,  norm_mul]
            _  =  ‖(B2  x  :  ℂ)‖  *  ‖(x  :  ℂ)  ^  (-s  -  2)‖  *  ‖2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ)‖  :=  by
                  rw  [norm_mul];  ring
            _  ≤  (1  /  6)  *  x  ^  a  *  (‖2  *  s  +  1‖  +  ‖s  *  (s  +  1)‖  *  |Real.log  x|)  :=  by
                  gcongr  with  i  j
                  · -- |B2 x|  ≤  1/6:
                    calc  ‖(B2  x  :  ℂ)‖
                        _  =  |(B2  x  :  ℝ)|  :=  by
                              rw  [Complex.norm_def,  Complex.normSq_ofReal,  ←  pow_two,
                                Real.sqrt_sq_eq_abs]
                        _  ≤  1  /  6  :=  abs_B2_le  hxpos.le
                  · -- ‖(x:ℂ) ^ (-s-2)‖  =  x^a  (exponent  bridge):
                    dsimp  only  [a]
                    have  hexp  :  (-s  -  2 :  ℂ).re  =  -(s.re  +  2)  :=  by  simp;  ring
                    rw  [Complex.norm_cpow_eq_rpow_re_of_pos  hxpos,  hexp]
                  · -- triangle  +  ‖(log  x :  ℂ)‖  =  |log  x|:
                    calc  ‖2  *  s  +  1  -  s  *  (s  +  1)  *  (Real.log  x  :  ℂ)‖
                        _  ≤  ‖2  *  s  +  1‖  +  ‖s  *  (s  +  1)  *  (Real.log  x  :  ℂ)‖  :=
                              norm_sub_le  ((2  *  s  +  1)  :  ℂ)  (s  *  (s  +  1)  *  (Real.log  x  :  ℂ))
                        _  =  ‖2  *  s  +  1‖  +  ‖s  *  (s  +  1)‖  *  |Real.log  x|  :=  by
                              rw  [norm_mul,
                                show  ‖(Real.log  x : ℂ)‖  =  |Real.log  x|  from  by  simp]
            _  =  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
              +  (1  /  6)  *  x  ^  a  *  (‖s  *  (s  +  1)‖  *  |Real.log  x|)  :=  by
                  ring
            _  ≤  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
              +  (1  /  6)  *  x  ^  a  *  (‖s  *  (s  +  1)‖  *  ((x  ^  d  +  x  ^  (-d))  /  d))  :=  by
                  gcongr
                  · exact  a2c_log_bound  x  hxpos  d  hd
            _  =  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
              +  (1  /  (6  *  d))  *  ‖s  *  (s  +  1)‖  *  (x  ^  (a  +  d)  +  x  ^  (a  -  d))  :=  by
                  have  hmul1  :  x  ^  a  *  x  ^  d  =  x  ^  (a  +  d)  :=  by
                    rw  [←  Real.rpow_add  hxpos]
                  have  hmul2  :  x  ^  a  *  x  ^  (-d)  =  x  ^  (a  -  d)  :=  by
                      rw  [←  Real.rpow_add  hxpos]
                      rw  [show  a  +  (-d)  =  a  -  d  from  by  ring]
                  calc  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
                    +  (1  /  6)  *  x  ^  a  *  (‖s  *  (s  +  1)‖  *  ((x  ^  d  +  x  ^  (-d))  /  d))
                        _  =  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
                          +  (1  /  (6  *  d))  *  ‖s  *  (s  +  1)‖  *  (x  ^  a  *  (x  ^  d  +  x  ^  (-d)))  :=  by
                              field_simp  [hd.ne']
                        _  =  (1  /  6)  *  x  ^  a  *  ‖2  *  s  +  1‖
                          +  (1  /  (6  *  d))  *  ‖s  *  (s  +  1)‖  *  (x  ^  (a  +  d)  +  x  ^  (a  -  d))  :=  by
                              rw  [show  x  ^  a  *  (x  ^  d  +  x  ^  (-d))
                                  =  x  ^  (a  +  d)  +  x  ^  (a  -  d)  from  by
                                rw  [show  x  ^  a  *  (x  ^  d  +  x  ^  (-d))
                                  =  x  ^  a  *  x  ^  d  +  x  ^  a  *  x  ^  (-d)  from  by  ring,
                                  hmul1,  hmul2]]
            _  =  M  x  :=  by
                  dsimp  only  [M]
                  ring))


/-
    U3 + U4:  local  s-derivative  bound  and  differentiation  under
    the  integral  sign  for  the  EM  tail  T(s)  =  int  {x  >  c}
    (B2  x)  *  p4_f2  s  x   (c  >=  1).

    ROUTE:  hasDerivAt_integral_of_dominated_loc_of_deriv_le  with
    s  :=  ball  s0  r,  r  :=  (s0.re  +  1)  /  2  (so  r  <  s0.re  +  1
    and  the  comparison  exponent  -s0.re  +  r  -  2  <  -1).  U1
    (a2c_Fs_deriv)  supplies  pointwise  differentiability  at  EVERY
    s  and  every  x  >  0  -  no  domain  restriction  needed.  The
    derivative  bound  on  the  ball  is  pointwise  elementary  (|B2  x|
    <=  1/6,  cpow  norm  =  x ^ (-s.re - 2),  log  weight  via  U2's
    a2c_log_bound).  No  RH  claim;  no  zeta  evaluation. -/

/-- Local  neighborhood  of  s0  used  in  U3/U4. -/
def  a2c_Nb  (s0  :  ℂ)  (r  :  ℝ)  :  Set  ℂ  :=  Metric.ball  s0  r

/-- Integrand  majorant  for  the  s-derivative:  for  s'  in  ball  s0  r
    and  x  >=  1,   ‖a2c_Fs  s'  x‖  <=  a2c_Maj  s0  r  x.  Integrable  on
    Ioi  c  (c  >=  1)  whenever  r  <  s0.re  +  1. -/
def  a2c_Maj  (s0  :  ℂ)  (r  :  ℝ)  (x  :  ℝ)  :  ℝ  :=
    (1  /  6)  *  x  ^  (-s0.re  +  r  -  2)  *
      (2  *  (‖s0‖  +  r)  +  1  +  (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  *  |Real.log  x|)

/-- U3.1  -  pointwise  bound  of  the  s-derivative  kernel  on  the  ball. -/
theorem  a2c_Fs_bound_loc  {s0  :  ℂ}  (r  :  ℝ)
    (hr0  :  0  <  r)  {s'  :  ℂ}
    (hs'  :  s'  ∈  a2c_Nb  s0  r)  {x  :  ℝ}  (hx1  :  1  <=  x)  :
    ‖a2c_Fs  s'  x‖  <=  a2c_Maj  s0  r  x  :=  by
  have  hxpos  :  0  <  x  :=  by  linarith
  have  hd  :  ‖s'  -  s0‖  <  r  :=  by
    dsimp  only  [a2c_Nb]  at  hs'
    rw  [Metric.mem_ball,  Complex.dist_eq]  at  hs'
    exact  hs'
  -- real  part  of  s'  controlled  below  by  s0.re  -  r:
  have  hsre  :  s'.re  >=  s0.re  -  r  :=  by
    have  h1  :  |s'.re  -  s0.re|  <=  dist  s'  s0  :=  by
      calc  |s'.re  -  s0.re|  =  |(s'  -  s0).re|  :=  by  rw  [Complex.sub_re]
        _  <=  ‖s'  -  s0‖  :=  Complex.abs_re_le_norm  (s'  -  s0)
        _  =  dist  s'  s0  :=  by  rw  [←  Complex.dist_eq]
    have  hdq  :  dist  s'  s0  =  ‖s'  -  s0‖  :=  Complex.dist_eq  s'  s0
    have  h2  :  s'.re  -  s0.re  >  -r  :=  by
      have  h3  :  abs  (s'.re  -  s0.re)  <  r  :=  by  linarith  [h1,  hd,  hdq]
      exact  abs_lt.mp  h3 |>.left
    linarith  [h2]
  -- ‖s'‖  and  |s'  *  (s'  +  1)|  bounded  in  terms  of  (‖s0‖  +  r):
  have  hn  :  ‖s'‖  <=  ‖s0‖  +  r  :=  by
    calc  ‖s'‖  =  ‖(s'  -  s0)  +  s0‖  :=  by  rw  [sub_add_cancel]
      _  <=  ‖s'  -  s0‖  +  ‖s0‖  :=  by  exact  norm_add_le  (s'  -  s0)  s0
      _  <=  r  +  ‖s0‖  :=  by  linarith  [hd]
      _  <=  ‖s0‖  +  r  :=  by  linarith
  have  hlin  :  ‖s'  *  (s'  +  1)‖  <=  (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  :=  by
    calc  ‖s'  *  (s'  +  1)‖  =  ‖s'‖  *  ‖s'  +  1‖  :=  by  rw  [norm_mul]
      _  <=  ‖s'‖  *  (‖s'‖  +  1)  :=  by
           have  ht  :  ‖s'  +  1‖  <=  ‖s'‖  +  1  :=  by
             calc  ‖s'  +  1‖  <=  ‖s'‖  +  ‖(1 : ℂ)‖  :=
                   by  exact  norm_add_le  (s'  :  ℂ)  1
               _  =  ‖s'‖  +  1  :=  by  rw  [norm_one]
           exact  mul_le_mul_of_nonneg_left  ht  (norm_nonneg  (s'  :  ℂ))
      _  <=  (‖s0‖  +  r)  *  (‖s'‖  +  1)  :=
        mul_le_mul_of_nonneg_right  hn
          (add_nonneg  (norm_nonneg  (s'  :  ℂ))  (by  norm_num))
      _  <=  (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  :=
        mul_le_mul_of_nonneg_left  (by  linarith  [hn])
          (add_nonneg  (norm_nonneg  (s0  :  ℂ))  hr0.le)
  -- the  linear  factor  2s'  +  1  -  s'(s'  +  1)  *  log  x:
  have  hlinf  :  ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖  <=
      2  *  ‖s'‖  +  1  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  :=  by
    have  h2b  :  ‖s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖  =
        ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  :=  by
      rw  [norm_mul,  norm_mul,  show  ‖(Real.log  x :  ℂ)‖  =  |Real.log  x|
        from  by  simp]
    have  h2a  :  ‖2  *  s'  +  1‖  <=  2  *  ‖s'‖  +  1  :=  by
      calc  ‖2  *  s'  +  1‖  <=  ‖2  *  s'‖  +  ‖(1 : ℂ)‖  :=
            by  exact  norm_add_le  (2  *  s')  1
        _  =  2  *  ‖s'‖  +  1  :=  by
          rw  [norm_mul,  show  ‖(2 : ℂ)‖  =  2  from  by  norm_num,  norm_one]
    calc  ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖
        _  <=  ‖2  *  s'  +  1‖  +  ‖s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖  :=
          by  exact  norm_sub_le  (2  *  s'  +  1)  (s'  *  (s'  +  1)  *  (Real.log  x :  ℂ))
        _  =  ‖2  *  s'  +  1‖  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  :=  by  rw  [h2b]
        _  <=  (2  *  ‖s'‖  +  1)  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  :=
          by  exact  add_le_add  h2a  le_rfl
        _  =  2  *  ‖s'‖  +  1  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  :=  by  ring
  -- the  cpow  exponent  comparison:
  have  hcpre  :  (-(s'.re  +  2) :  ℝ)  <=  -s0.re  +  r  -  2  :=  by  linarith  [hsre]
  have  hexp  :  (-s'  -  2 :  ℂ).re  =  -(s'.re  +  2)  :=  by  simp;  ring
  -- assemble  the  full  bound:
  set  Lx  :=  x  ^  (-s0.re  +  r  -  2)  with  hLx_def
  set  linUB  :=  2  *  (‖s0‖  +  r)  +  1  +  (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  *  |Real.log  x|
    with  hlinUB_def
  have  hB2  :  ‖(B2  x  :  ℂ)‖  <=  1  /  6  :=  by
    rw  [show  ‖(B2  x  :  ℂ)‖  =  |B2  x|  from  by  simp]
    exact  abs_B2_le  (by  linarith  [hx1])
  have  hBpw  :  x  ^  (-(s'.re  +  2))  *
      ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖  <=
      x  ^  (-s0.re  +  r  -  2)  *  (2  *  ‖s'‖  +  1  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|)  :=  by
    have  hB1  :  x  ^  (-(s'.re  +  2))  <=  x  ^  (-s0.re  +  r  -  2)  :=
      Real.rpow_le_rpow_of_exponent_le  hx1  hcpre
    exact  mul_le_mul  hB1  hlinf  (by  positivity)  (by  positivity)
  have  hBmid  :  x  ^  (-s0.re  +  r  -  2)  *
      (2  *  ‖s'‖  +  1  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|)  <=
      x  ^  (-s0.re  +  r  -  2)  *  (2  *  (‖s0‖  +  r)  +  1  +  (‖s0‖  +  r)  *
        (‖s0‖  +  r  +  1)  *  |Real.log  x|)  :=  by
    have  hpos  :  0  <=  |Real.log  x|  :=  abs_nonneg  _
    have  htm2  :  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|  <=
        (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  *  |Real.log  x|  :=
      mul_le_mul_of_nonneg_right  hlin  hpos
    have  htm1  :  2  *  ‖s'‖  +  1  <=  2  *  (‖s0‖  +  r)  +  1  :=  by  linarith  [hn]
    exact  mul_le_mul_of_nonneg_left  (add_le_add  htm1  htm2)  (by  positivity)
  calc  ‖a2c_Fs  s'  x‖
      _  =  ‖(B2  x  :  ℂ)‖  *  (x  ^  (-(s'.re  +  2))  *
            ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖)  :=  by
        dsimp  only  [a2c_Fs]
        rw  [norm_mul,  norm_mul,  Complex.norm_cpow_eq_rpow_re_of_pos  hxpos,  hexp]
      _  <=  (1  /  6)  *  (Lx  *  linUB)  :=  by
        have  hstep  :  ‖(B2  x  :  ℂ)‖  *  (x  ^  (-(s'.re  +  2))  *
                ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖)  <=
            (1  /  6)  *  (Lx  *  linUB)  :=  by
          calc  ‖(B2  x  :  ℂ)‖  *  (x  ^  (-(s'.re  +  2))  *
                  ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖)
              _  <=  (1  /  6)  *  (x  ^  (-(s'.re  +  2))  *
                    ‖2  *  s'  +  1  -  s'  *  (s'  +  1)  *  (Real.log  x :  ℂ)‖)  :=
                    by  exact  mul_le_mul_of_nonneg_right  hB2  (by  positivity)
              _  <=  (1  /  6)  *  (Lx  *
                    (2  *  ‖s'‖  +  1  +  ‖s'  *  (s'  +  1)‖  *  |Real.log  x|))  :=
                    by  exact  mul_le_mul_of_nonneg_left  hBpw  (by  norm_num)
              _  <=  (1  /  6)  *  (Lx  *  linUB)  :=
                    by  exact  mul_le_mul_of_nonneg_left  hBmid  (by  norm_num)
        exact  hstep
      _  =  a2c_Maj  s0  r  x  :=  by  dsimp  only  [a2c_Maj,  Lx,  linUB];  ring



/-- U4 -  the  EM  tail  integral  T(s)  =  int _{x  >  c}  (B2  x)  p4_f2  s  x
    is  complex  differentiable  at  every  s0  with  s0.re  >  -1,  for
    every  c  >=  1,  with  derivative  int _{x  >  c}  a2c_Fs  s0  x.

    Proof  route:  hasDerivAt_integral_of_dominated_loc_of_deriv_le  with
    neighborhood  s  :=  ball  s0  ((s0.re  +  1)  /  2),  parameter  bound
    U3.1  (a2c_Fs_bound_loc)  plus  the  log-weight  comparison  a2c_log_bound,
    and  pointwise  differentiability  from  U1  (a2c_Fs_deriv). -/
theorem  a2c_T_hasDerivAt  {s0  :  ℂ}  (hs0  :  s0.re  >  -1)  {c  :  ℝ}
    (hc1  :  1  <=  c)  :
    HasDerivAt  (fun  s'  :  ℂ  =>  ∫  x  :  ℝ  in  Ioi  c,  a2c_F  s'  x)
      (∫  x  :  ℝ  in  Ioi  c,  a2c_Fs  s0  x)  s0  :=  by
  set  r  :=  (s0.re  +  1)  /  2  with  hr_def
  have  hr0  :  0  <  r  :=  by  dsimp  only  [r];  linarith  [hs0]
  have  hrlt  :  r  <  s0.re  +  1  :=  by  dsimp  only  [r];  linarith  [hs0]
  set  μ  :=  volume.restrict  (Ioi  c)  with  hμ_def
  set  s  :=  a2c_Nb  s0  r  with  hs_def
  have  hs  :  s  ∈  𝓝  s0  :=  by
    dsimp  only  [s]
    exact  Metric.ball_mem_nhds  s0  hr0
  have  hc'  :  0  <  c  :=  by  linarith
  -- log-weight  comparison  exponent  plumbing  (for  the  bound  below):
  set  p  :=  -s0.re  +  r  -  2  with  hp_def
  have  hpt  :  p  <  -1  :=  by  dsimp  only  [p];  linarith  [hrlt]
  set  d  :=  (-1  -  p)  /  4  with  hd_def
  have  hd  :  0  <  d  :=  by  dsimp  only  [d];  linarith  [hpt]
  set  C0  :=  2  *  (‖s0‖  +  r)  +  1  with  hC0_def
  set  C1  :=  (‖s0‖  +  r)  *  (‖s0‖  +  r  +  1)  with  hC1_def
  set  hbnd  :=  fun  x  :  ℝ  =>
      (1  /  6)  *  (C0  *  x  ^  p  +  (C1  /  d)  *  (x  ^  (p  +  d)  +  x  ^  (p  -  d)))
    with  hbnd_def
  -- (i)  base  integrability  of  F  at  s0  (measurability  +  comparison):
  have  hF_int  :  Integrable  (a2c_F  s0)  μ  :=  by
    set  q  :=  -(s0.re  +  2)  with  hq_def
    have  hq  :  q  <  -1  :=  by  dsimp  only  [q];  linarith  [hs0]
    have  hLq  :  Integrable  (fun  x  :  ℝ  =>  x  ^  q)  μ  :=
      (integrableOn_Ioi_rpow_of_lt  hq  hc').integrable
    have  hT1  :  Integrable  (fun  x  :  ℝ  =>  (1  /  6)  *  (‖s0  *  (s0  +  1)‖  *  x  ^  q))  μ  :=
      (hLq.const_mul  ‖s0  *  (s0  +  1)‖).const_mul  (1  /  6)
    have  hcomp  :  HasFiniteIntegral  (fun  x  :  ℝ  =>  (1  /  6)  *  (‖s0  *  (s0  +  1)‖  *  x  ^  q))  μ  :=
      hT1.hasFiniteIntegral
    constructor
    · -- measurability:  (B2  ·  :  ℂ)  *  p4_f2  s0,  both  AESM:
      have  hB2a  :  AEStronglyMeasurable  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))  μ  :=
        (AEStronglyMeasurable.mono_measure
          (Continuous.comp_aestronglyMeasurable  (hg  :=  Complex.continuous_ofReal)
            (aestronglyMeasurable_B2 :  AEStronglyMeasurable  B2))
          ((Measure.restrict_mono  (Set.Ioi  c).subset_univ  le_rfl).trans
            (le_of_eq  Measure.restrict_univ)))
      have  hcpow0  :  ContinuousOn  (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s0  -  2))  (Set.Ioi  0)  :=  by
        intro  x  hx
        exact  (Complex.continuousAt_ofReal_cpow_const  x  (-s0  -  2)
          (Or.inr  (ne_of_gt  hx))).continuousWithinAt
      have  hlinp  :  AEStronglyMeasurable
          (fun  x  :  ℝ  =>  (s0  *  (s0  +  1) :  ℂ)  *  (x  :  ℂ)  ^  (-s0  -  2))  μ  :=
        ContinuousOn.aestronglyMeasurable
          ((continuousOn_const.mul  hcpow0).mono  (Ioi_subset_Ioi_iff.mpr  hc'.le))
          measurableSet_Ioi
      have  hlinp'  :  AEStronglyMeasurable  (fun  x  :  ℝ  =>  p4_f2  s0  x)  μ  :=  by
        simpa  [p4_f2]  using  hlinp
      simpa  [show  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))  *  (fun  x  :  ℝ  =>  p4_f2  s0  x)
          =  (a2c_F  s0)  from  by  funext  x;  simp  [a2c_F]]  using  hB2a.mul  hlinp'
    · -- the  finite-integral  comparison  (|B2|  <=  1/6,  cpow  norm):
      rw  [←  hasFiniteIntegral_norm_iff]
      refine  HasFiniteIntegral.mono'  hcomp  (by
        rw  [ae_restrict_iff'  measurableSet_Ioi]
        exact  MeasureTheory.ae_of_all  (μ  :=  (volume  :  Measure  ℝ))
          (fun  {x  :  ℝ}  =>  fun  (hx  :  x  ∈  Ioi  c)  =>  by
            have  hclt  :  c  <  x  :=  by  simpa  using  hx
            have  hxpos  :  0  <  x  :=  hc'.trans  hclt
            have  h1  :  ‖(‖a2c_F  s0  x‖  :  ℝ)‖  =  ‖a2c_F  s0  x‖  :=  by  simp
            rw  [h1]
            calc  ‖a2c_F  s0  x‖
                _  =  ‖(B2  x  :  ℂ)‖  *  ‖p4_f2  s0  x‖  :=  by
                      rw  [a2c_F,  norm_mul]
                _  =  ‖(B2  x  :  ℂ)‖  *  (‖s0  *  (s0  +  1)‖  *  x  ^  (-(s0.re  +  2)))  :=  by
                      rw  [show  ‖p4_f2  s0  x‖  =  ‖s0  *  (s0  +  1)‖  *  x  ^  (-(s0.re  +  2))
                        from  by
                          dsimp  only  [p4_f2]
                          rw  [norm_mul,
                            Complex.norm_cpow_eq_rpow_re_of_pos  hxpos,
                            show  (-s0  -  2 :  ℂ).re  =  -(s0.re  +  2)  from  by  simp;  ring]]
                _  <=  (1  /  6)  *  (‖s0  *  (s0  +  1)‖  *  x  ^  (-(s0.re  +  2)))  :=  by
                      exact  mul_le_mul_of_nonneg_right  (by
                        rw  [show  ‖(B2  x  :  ℂ)‖  =  |B2  x|  from  by  simp]
                        exact  abs_B2_le  (by  linarith  [hxpos]))  (by  positivity)
                _  =  (1  /  6)  *  (‖s0  *  (s0  +  1)‖  *  x  ^  q)  :=  by
                      dsimp  only  [q]
          ))
  -- (ii)  measurability  of  the  parameter  derivative  at  s0  (from  U2):
  have  hF'_meas  :  AEStronglyMeasurable  (a2c_Fs  s0)  μ  :=
    (a2c_Fs_integrableOn_Ioi  hs0  hc').integrable.aestronglyMeasurable
  -- (iii)  parameter  measurability  near  s0:
  have  hF_meas  :  ∀ᶠ  s'  in  𝓝  s0,  AEStronglyMeasurable  (a2c_F  s')  μ  :=  by
    filter_upwards  [hs]  with  s'  hs'
    have  hB2a  :  AEStronglyMeasurable  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))  μ  :=
      (AEStronglyMeasurable.mono_measure
        (Continuous.comp_aestronglyMeasurable  (hg  :=  Complex.continuous_ofReal)
          (aestronglyMeasurable_B2 :  AEStronglyMeasurable  B2))
        ((Measure.restrict_mono  (Set.Ioi  c).subset_univ  le_rfl).trans
          (le_of_eq  Measure.restrict_univ)))
    have  hcpow0  :  ContinuousOn  (fun  x  :  ℝ  =>  (x  :  ℂ)  ^  (-s'  -  2))  (Set.Ioi  0)  :=  by
      intro  x  hx
      exact  (Complex.continuousAt_ofReal_cpow_const  x  (-s'  -  2)
        (Or.inr  (ne_of_gt  hx))).continuousWithinAt
    have  hlinp  :  AEStronglyMeasurable
        (fun  x  :  ℝ  =>  (s'  *  (s'  +  1) :  ℂ)  *  (x  :  ℂ)  ^  (-s'  -  2))  μ  :=
      ContinuousOn.aestronglyMeasurable
        ((continuousOn_const.mul  hcpow0).mono  (Ioi_subset_Ioi_iff.mpr  hc'.le))
        measurableSet_Ioi
    have  hlinp'  :  AEStronglyMeasurable  (fun  x  :  ℝ  =>  p4_f2  s'  x)  μ  :=  by
      simpa  [p4_f2]  using  hlinp
    have  heq2  :  (fun  x  :  ℝ  =>  (B2  x  :  ℂ))  *  (fun  x  :  ℝ  =>  p4_f2  s'  x)
        =  (a2c_F  s')  :=  by
      funext  x
      simp  [a2c_F]
    exact  (by  simpa  [heq2]  using  hB2a.mul  hlinp')
  -- (iv)  pointwise  parameter  bound  (U3.1  plus  log  comparison):
  have  h_bound  :  ∀ᵐ  x  ∂μ,  ∀  s'  ∈  s,  ‖a2c_Fs  s'  x‖  <=  hbnd  x  :=  by
    rw  [ae_restrict_iff'  measurableSet_Ioi]
    exact  MeasureTheory.ae_of_all  (μ  :=  (volume  :  Measure  ℝ))
      (fun  {x  :  ℝ}  =>  fun  (hx  :  x  ∈  Ioi  c)  =>  by
        intro  s'  hs'
        have  hclt  :  c  <  x  :=  by  simpa  using  hx
        have  hx1  :  1  <=  x  :=  by  linarith  [hc1,  hclt]
        have  hlog  :=  a2c_log_bound  x  (hc'.trans  hclt)  d  hd
        have  hbound  :=  a2c_Fs_bound_loc  r  hr0  hs'  hx1
        have  hmaj  :  a2c_Maj  s0  r  x  <=  hbnd  x  :=  by
          dsimp  only  [a2c_Maj,  hbnd,  C0,  C1]
          have  hadd1  :  x  ^  p  *  x  ^  d  =  x  ^  (p  +  d)  :=  by
            rw  [←  Real.rpow_add  (by  linarith  [hc1,  hx])]
          have  hadd2  :  x  ^  p  *  x  ^  (-d)  =  x  ^  (p  -  d)  :=  by
            rw  [show  p  -  d  =  p  +  (-d)  from  by  ring,
              ←  Real.rpow_add  (by  linarith  [hc1,  hx])]
          have  hh  :  C0  +  C1  *  |Real.log  x|  <=
              C0  +  C1  *  ((x  ^  d  +  x  ^  (-d))  /  d)  :=  by
            exact  add_le_add  le_rfl
              (mul_le_mul_of_nonneg_left  hlog  (by  positivity))
          calc  (1  /  6)  *  x  ^  p  *  (C0  +  C1  *  |Real.log  x|)
              _  <=  (1  /  6)  *  x  ^  p  *
                    (C0  +  C1  *  ((x  ^  d  +  x  ^  (-d))  /  d))  :=
                    by  exact  mul_le_mul_of_nonneg_left  hh  (by  positivity)
              _  =  (1  /  6)  *  (C0  *  x  ^  p  +  (C1  /  d)  *
                    (x  ^  (p  +  d)  +  x  ^  (p  -  d)))  :=  by
                    have  hA  :  x  ^  p  *  (C1  *  ((x  ^  d  +  x  ^  (-d))  /  d))  =
                        (C1  /  d)  *  (x  ^  (p  +  d)  +  x  ^  (p  -  d))  :=  by
                      calc  x  ^  p  *  (C1  *  ((x  ^  d  +  x  ^  (-d))  /  d))
                          _  =  C1  *  (x  ^  p  *  ((x  ^  d  +  x  ^  (-d))  /  d))  :=  by  ring
                          _  =  C1  *  ((x  ^  p  *  (x  ^  d  +  x  ^  (-d)))  /  d)  :=  by  ring
                          _  =  C1  *  ((x  ^  (p  +  d))  +  (x  ^  (p  -  d)))  /  d  :=  by
                                rw  [show  x  ^  p  *  (x  ^  d  +  x  ^  (-d))  =
                                      x  ^  (p  +  d)  +  x  ^  (p  -  d)  from  by
                                    rw  [mul_add,  hadd1,  hadd2]]
                                ring
                          _  =  (C1  /  d)  *  (x  ^  (p  +  d)  +  x  ^  (p  -  d))  :=  by  ring
                    have  hB  :  (1  /  6)  *  x  ^  p  *
                        (C0  +  C1  *  ((x  ^  d  +  x  ^  (-d))  /  d))  =
                        (1  /  6)  *  (x  ^  p  *  C0  +  x  ^  p  *  (C1  *  ((x  ^  d  +  x  ^  (-d))  /  d)))  :=
                      by  ring
                    rw  [hB,  hA]
                    ring
        exact  hbound.trans  hmaj)
  -- (v)  the  bound  is  integrable  (power  functions,  exponents  all  <  -1):
  have  hp1  :  p  +  d  <  -1  :=  by  dsimp  only  [d];  ring_nf;  nlinarith  [hpt]
  have  hp2  :  p  -  d  <  -1  :=  by  dsimp  only  [d];  ring_nf;  nlinarith  [hpt]
  have  hMint  :  Integrable  hbnd  μ  :=  by
    have  hL0  :  Integrable  (fun  x  :  ℝ  =>  C0  *  x  ^  p)  μ  :=
      ((integrableOn_Ioi_rpow_of_lt  hpt  hc').integrable).const_mul  C0
    have  hL1  :  Integrable  (fun  x  :  ℝ  =>  (C1  /  d)  *  x  ^  (p  +  d))  μ  :=
      ((integrableOn_Ioi_rpow_of_lt  hp1  hc').integrable).const_mul  (C1  /  d)
    have  hL2  :  Integrable  (fun  x  :  ℝ  =>  (C1  /  d)  *  x  ^  (p  -  d))  μ  :=
      ((integrableOn_Ioi_rpow_of_lt  hp2  hc').integrable).const_mul  (C1  /  d)
    have  hT1  :  Integrable  (fun  x  :  ℝ  =>  (1  /  6)  *  (C0  *  x  ^  p))  μ  :=
      hL0.const_mul  (1  /  6)
    have  hS1  :  Integrable  (fun  x  :  ℝ  =>  (C1  /  d)  *  x  ^  (p  +  d) +
        (C1  /  d)  *  x  ^  (p  -  d))  μ  :=  hL1.add  hL2
    have  hT2  :  Integrable
        (fun  x  :  ℝ  =>  (1  /  6)  *  ((C1  /  d)  *  x  ^  (p  +  d) +
          (C1  /  d)  *  x  ^  (p  -  d)))  μ  :=  hS1.const_mul  (1  /  6)
    have  heq  :  hbnd  =  (fun  x  :  ℝ  =>  (1  /  6)  *  (C0  *  x  ^  p))  +
        (fun  x  :  ℝ  =>  (1  /  6)  *  ((C1  /  d)  *  x  ^  (p  +  d) +
          (C1  /  d)  *  x  ^  (p  -  d)))  :=  by
      funext  x
      simp  [hbnd]
      ring
    simpa  [heq]  using  hT1.add  hT2
  -- (vi)  pointwise  has-derivative  (from  U1):
  have  h_diff  :  ∀ᵐ  x  ∂μ,  ∀  s'  ∈  s,
      HasDerivAt  (fun  s''  :  ℂ  =>  a2c_F  s''  x)  (a2c_Fs  s'  x)  s'  :=  by
    rw  [ae_restrict_iff'  measurableSet_Ioi]
    exact  MeasureTheory.ae_of_all  (μ  :=  (volume  :  Measure  ℝ))
      (fun  {x  :  ℝ}  =>  fun  (hx  :  x  ∈  Ioi  c)  =>  by
        intro  s'  hs'
        have  hclt  :  c  <  x  :=  by  simpa  using  hx
        have  hxpos  :  0  <  x  :=  hc'.trans  hclt
        exact  a2c_Fs_deriv  hxpos)
  -- (vii)  differentiation  under  the  integral  sign:
  exact  (by  simpa  using  (hasDerivAt_integral_of_dominated_loc_of_deriv_le
    hs  hF_meas  hF_int  hF'_meas  h_bound  hMint  h_diff).2)

/-! U5  ANALYTICITY  OF  EVERY  PIECE,  ON  ITS  DOMAIN.

  Pieces:
    *  s  ↦  (a:ℂ)^s   (a  >  0):  entire  -  from  the  cpow  definition
       exp  (log  a  ·  s)  and  the  hasDerivAt  chain;
    *  s  ↦  1/(a:ℂ)^s  (a  >  0):  entire  (HasDerivAt.inv);
    *  s  ↦  (n:ℂ)^(-s),  (n:ℂ)^(-s-1)  (n  ≥  1):  entire  (cpow_neg  /
       cpow_add  reduce  these  to  the  first  two  lines);
    *  p4_P  n:  finite  sum  of  pieces  →  entire;
    *  p4_I  n  =  (n:ℂ)^(-s+1)/(1-s):  analytic  on  {1}ᶜ  (the
       nonzero-denominator  hypothesis);
    *  s  ↦  ∫_Ioi  n  a2c_F  s  ·:  differentiable  on  {Re  s  >  -1}
       (U4).
  All  are  then  restricted  to  U  =  a2c_Dcut  by  monotonicity.  The
  analyticity  bridge  is  Mathlib's  DifferentiableOn.analyticOnNhd
  (Cauchy-integral  powered:  on  an  open  set,  complex  differentiable
  =  analytic). -/

/-- For  a  >  0,  s  ↦  (a:ℂ)^s  is  complex  differentiable  at  every
    s0,  with  derivative  (log  a)·(a:ℂ)^s. -/
theorem  a2c_cpowS_deriv  {a  :  ℝ}  (ha  :  0  <  a)  {s0  :  ℂ}  :
    HasDerivAt  (fun  s  :  ℂ  =>  (a  :  ℂ)  ^  s)
      ((Real.log  a  :  ℂ)  *  (a  :  ℂ)  ^  s0)  s0  :=  by
  have  h0  :  (a  :  ℂ)  ≠  0  :=  Complex.ofReal_ne_zero.mpr  (ne_of_gt  ha)
  have  hc  :  HasDerivAt  (fun  x  :  ℂ  =>  (a  :  ℂ)  ^  x)
      ((a  :  ℂ)  ^  s0  *  Complex.log  (a  :  ℂ))  s0  :=
    (hasStrictDerivAt_const_cpow  (Or.inl  h0)).hasDerivAt
  have  heq  :  (a  :  ℂ)  ^  s0  *  Complex.log  (a  :  ℂ)  =
      (Real.log  a  :  ℂ)  *  (a  :  ℂ)  ^  s0  :=  by
    rw  [mul_comm,  Complex.ofReal_log  (le_of_lt  ha)]
  simpa  [heq]  using  hc

/-- For  a  >  0,  s  ↦  1/(a:ℂ)^s  is  entire. -/
theorem  a2c_cpowS_inv_diff  {a  :  ℝ}  (ha  :  0  <  a)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  1  /  (a  :  ℂ)  ^  s)  univ  :=  by
  intro  s0  _
  have  him  :  (a  :  ℂ)  ≠  0  :=  Complex.ofReal_ne_zero.mpr  (ne_of_gt  ha)
  have  hnonz  :  (a  :  ℂ)  ^  s0  ≠  0  :=  by
    rw  [Complex.cpow_def_of_ne_zero  him  s0]
    apply  Complex.exp_ne_zero
  have  hfunc  :  (fun  s  :  ℂ  =>  1  /  (a  :  ℂ)  ^  s)  =
      (fun  s  :  ℂ  =>  ((a  :  ℂ)  ^  s)⁻¹)  :=  by
    funext  s
    ring
  have  hA  :  DifferentiableAt  ℂ  (fun  s  :  ℂ  =>  ((a  :  ℂ)  ^  s)⁻¹)  s0  :=
    ((a2c_cpowS_deriv  ha).inv  hnonz).differentiableAt
  simpa  [hfunc]  using
    (differentiableWithinAt_univ  (f  :=  (fun  s  :  ℂ  =>  ((a  :  ℂ)  ^  s)⁻¹))
      (x  :=  s0)).mpr  hA

/-- For  a  >  0,  s  ↦  (a:ℂ)^s  is  entire. -/
theorem  a2c_cpowS_diff  {a  :  ℝ}  (ha  :  0  <  a)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  (a  :  ℂ)  ^  s)  univ  :=  by
  intro  s0  _
  exact  (differentiableWithinAt_univ  (f  :=  (fun  s  :  ℂ  =>  (a  :  ℂ)  ^  s))
    (x  :=  s0)).mpr  (a2c_cpowS_deriv  ha).differentiableAt

/-- For  n  ≥  1,  s  ↦  (n:ℂ)^(-s)  =  1/(n:ℂ)^s  is  entire. -/
theorem  a2c_cpowS_neg_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ))  univ  :=  by
  have  hr  :  0  <  (n  :  ℝ)  :=  by  norm_cast
  have  heq  :  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ))  =
      (fun  s  :  ℂ  =>  1  /  (n  :  ℂ)  ^  s)  :=  by
    funext  s
    rw  [Complex.cpow_neg  (n  :  ℂ)  s]
    simp
  simpa  [heq]  using  a2c_cpowS_inv_diff  (a  :=  (n  :  ℝ))  hr

/-- For  n  ≥  1,  s  ↦  (n:ℂ)^(-s-1)  =  (n:ℂ)^(-s)·(n:ℂ)^(-1)  is  entire. -/
theorem  a2c_cpowS_neg1_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  -  1  :  ℂ))  univ  :=  by
  have  hr  :  0  <  (n  :  ℝ)  :=  by  norm_cast
  have  him  :  (n  :  ℂ)  ≠  0  :=  by
    simpa  using  Complex.ofReal_ne_zero.mpr  (ne_of_gt  hr)
  have  hneg  :=  a2c_cpowS_neg_diff  hn
  have  heq2  :  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  -  1  :  ℂ))  =
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ)  *  (n  :  ℂ)  ^  (-1  :  ℂ))  :=  by
    funext  s
    rw  [show  (-s  -  1  :  ℂ)  =  (-s  +  (-1  :  ℂ))  by  ring,
      Complex.cpow_add  (-s  :  ℂ)  (-(1  :  ℂ))  him]
  have  hmul  :  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ)  *  (n  :  ℂ)  ^  (-1  :  ℂ))  =
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-1  :  ℂ)  *  (n  :  ℂ)  ^  (-s  :  ℂ))  :=  by
    funext  s
    ring
  simpa  [heq2,  hmul]  using  hneg.const_mul  ((n  :  ℂ)  ^  (-1  :  ℂ))

/-- p4_P  n  (the  finite  partial  sum)  is  entire. -/
theorem  a2c_p4P_diff  (n  :  ℕ)  :  DifferentiableOn  ℂ  (p4_P  n)  univ  :=  by
  induction  n  with
  | zero  =>
      intro  s0  _
      have  hf  :  (p4_P  0)  =  (fun  _  :  ℂ  =>  (0  :  ℂ))  :=  by
        funext  s
        simp  [p4_P]
      rw  [hf]
      exact  (differentiableWithinAt_univ  (f  :=  (fun  _  :  ℂ  =>  (0  :  ℂ)))
        (x  :=  s0)).mpr
        (HasDerivAt.differentiableAt  (hasDerivAt_const  s0  (0  :  ℂ)))
  | succ  k  ih  =>
      intro  s0  _
      have  hfn  :  (p4_P  (k  +  1))  =
          (fun  s  :  ℂ  =>  (p4_P  k)  s  +  (1  :  ℂ)  /  ((k  +  1)  :  ℂ)  ^  s)  :=  by
        funext  s
        dsimp  only  [p4_P]
        rw  [Finset.sum_range_succ]
      have  hterm  :=
        (a2c_cpowS_inv_diff  (a  :=  (k  +  1  :  ℝ))  (by  norm_cast;  omega))
          s0  (by  simp)
      have  hcast  :  ((k  +  1)  :  ℂ)  =  ((k  +  1  :  ℝ)  :  ℂ)  :=  by  norm_cast
      rw  [hfn,  hcast]
      have  heta  :  (fun  (s  :  ℂ)  =>  (p4_P  k)  s  +  (1  :  ℂ)  /
          ((k  +  1  :  ℝ)  :  ℂ)  ^  s)  =
        (p4_P  k)  +  (fun  (s  :  ℂ)  =>  (1  :  ℂ)  /  ((k  +  1  :  ℝ)  :  ℂ)
          ^  s)  :=
        rfl
      rw  [heta]
      exact  (ih  s0  (by  simp)).add  hterm

/-- p4_I  n  =  (n:ℂ)^(-s+1)/(1-s)  is  complex  differentiable  at
    every  s0  ≠  1,  for  n  ≥  1. -/
theorem  a2c_p4I_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (p4_I  n)  {1}ᶜ  :=  by
  intro  s0  hs0
  have  hnnz  :  (n  :  ℂ)  ≠  0  :=  by
    intro  h
    norm_cast  at  h
    omega
  --  numerator:  (n:ℂ)^(-s+1)  =  (n:ℂ)^(-s)  ·  (n:ℂ):
  have  hpos  :  (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  +  1))  =
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ)  *  (n  :  ℂ))  :=  by
    funext  s
    rw  [show  (-s  +  1  :  ℂ)  =  (-s  +  (1  :  ℂ))  by  ring,
      Complex.cpow_add  (-s  :  ℂ)  (1  :  ℂ)  hnnz,  Complex.cpow_one  (n  :  ℂ)]
  have  hnumU  :  DifferentiableWithinAt  ℂ
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ))  univ  s0  :=
    (a2c_cpowS_neg_diff  hn)  s0  (by  simp)
  have  hnumC  :  DifferentiableWithinAt  ℂ
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  :  ℂ)  *  (n  :  ℂ))  univ  s0  :=
    hnumU.mul_const  (n  :  ℂ)
  have  hnumW  :  DifferentiableWithinAt  ℂ
      (fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  +  1))  {1}ᶜ  s0  :=  by
    rw  [hpos]
    exact  hnumC.mono  (by  intro  s  _;  trivial)
  have  hdenW  :  DifferentiableWithinAt  ℂ  (fun  s  :  ℂ  =>  1  -  s)  {1}ᶜ  s0  :=
    (differentiableWithinAt_const  (1  :  ℂ)  (s  :=  {1}ᶜ)  (x  :=  s0)).sub
      (differentiableWithinAt_id  (s  :=  {1}ᶜ)  (x  :=  s0))
  have  hden0  :  1  -  s0  ≠  0  :=  by
    intro  h
    rw  [sub_eq_zero]  at  h
    exact  hs0  (by  simpa  using  h.symm)
  have  hpi  :  (p4_I  n)  =  ((fun  s  :  ℂ  =>  (n  :  ℂ)  ^  (-s  +  1))  /
      (fun  s  :  ℂ  =>  1  -  s))  :=
    by  ext  s;  simp  [p4_I]
  simpa  [hpi]  using  hnumW.div  hdenW  hden0

/-- The  EM  tail  s  ↦  ∫_Ioi  n  a2c_F  s  ·  is  complex
    differentiable  on  the  whole  half-plane  {Re  s  >  -1}  (U4). -/
theorem  a2c_T_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  ∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),
      a2c_F  s  x)  a2c_D  :=  by
  intro  s0  hs0
  have  hT  :  HasDerivAt
      (fun  s  :  ℂ  =>  ∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),  a2c_F  s  x)
      (∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),  a2c_Fs  s0  x)  s0  :=
    a2c_T_hasDerivAt  hs0  (c  :=  (n  :  ℝ))  (hc1  :=  by  norm_cast)
  exact  hT.hasDerivWithinAt.differentiableWithinAt

/-- W  side:  ζ  s  -  p4_P  n  s  +  p4_I  n  s  is  differentiable  on
    {1}ᶜ. -/
theorem  a2c_W_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s)
      {1}ᶜ  :=  by
  have  hz  :=  differentiableOn_riemannZeta
  have  hP  :  DifferentiableOn  ℂ  (p4_P  n)  {1}ᶜ  :=
    (a2c_p4P_diff  n).mono  (by  intro  s  _;  trivial)
  have  hI  :  DifferentiableOn  ℂ  (p4_I  n)  {1}ᶜ  :=  a2c_p4I_diff  hn
  exact  (hz.sub  hP).add  hI

/-- P4  side:  p4_em_expr  ·  n  is  differentiable  on  {Re  s  >  -1}. -/
theorem  a2c_P4_diff  {n  :  ℕ}  (hn  :  0  <  n)  :
    DifferentiableOn  ℂ  (fun  s  :  ℂ  =>  p4_em_expr  s  n)  a2c_D  :=  by
  set  fA  :=  fun  (s  :  ℂ)  =>  (n  :  ℂ)  ^  (-s  :  ℂ)  with  hfA
  set  fB  :=  fun  (s  :  ℂ)  =>  s  *  (n  :  ℂ)  ^  (-s  -  1  :  ℂ)  with  hfB
  set  fT  :=  (fun  (s  :  ℂ)  =>  ∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),
    a2c_F  s  x)  with  hfT
  set  c1  :=  -((1  /  2)  :  ℂ)  with  hc1
  set  c2  :=  ((1  /  12)  :  ℂ)  with  hc2
  set  c3  :=  ((1  /  2)  :  ℂ)  with  hc3
  have  hA  :  DifferentiableOn  ℂ  fA  a2c_D  :=
    (a2c_cpowS_neg_diff  hn).mono  (by  intro  s  _;  trivial)
  have  hB  :  DifferentiableOn  ℂ  fB  a2c_D  :=
    (differentiableOn_id  (s  :=  a2c_D)).mul
      ((a2c_cpowS_neg1_diff  hn).mono  (by  intro  s  _;  trivial))
  have  hC  :  DifferentiableOn  ℂ  fT  a2c_D  :=  a2c_T_diff  hn
  have  hW1  :  DifferentiableOn  ℂ  (fun  y  :  ℂ  =>  c1  *  fA  y)  a2c_D  :=
    hA.const_mul  c1
  have  hW2  :  DifferentiableOn  ℂ  (fun  y  :  ℂ  =>  c2  *  fB  y)  a2c_D  :=
    hB.const_mul  c2
  have  hW3  :  DifferentiableOn  ℂ  (fun  y  :  ℂ  =>  c3  *  fT  y)  a2c_D  :=
    hC.const_mul  c3
  have  hem  :  (fun  s  :  ℂ  =>  p4_em_expr  s  n)  =
      (fun  s  :  ℂ  =>  c1  *  (n  :  ℂ)  ^  (-s  :  ℂ)  +
        c2  *  (s  *  (n  :  ℂ)  ^  (-s  -  1  :  ℂ))  -
        c3  *  (∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),  a2c_F  s  x))  :=  by
    funext  s
    dsimp  only  [p4_em_expr,  a2c_F]
  have  hfin  :  (fun  s  :  ℂ  =>  c1  *  (n  :  ℂ)  ^  (-s  :  ℂ)  +
      c2  *  (s  *  (n  :  ℂ)  ^  (-s  -  1  :  ℂ))  -
      c3  *  (∫  x  :  ℝ  in  Set.Ioi  (n  :  ℝ),  a2c_F  s  x))  =
      (fun  s  :  ℂ  =>  c1  *  fA  s  +  c2  *  fB  s  -  c3  *  fT  s)  :=  by
    funext  s
    simp  [fA,  fB,  fT]
  rw  [hem,  hfin]
  exact  (hW1.add  hW2).sub  hW3

/-- W  side  analytic  on  U  (=  a2c_Dcut). -/
theorem  a2c_W_analytic  {n  :  ℕ}  (hn  :  0  <  n)  :
    AnalyticOnNhd  ℂ  (fun  s  :  ℂ  =>  riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s)
      a2c_Dcut  :=
  ((a2c_W_diff  hn).analyticOnNhd  isOpen_compl_singleton).mono
    (by  intro  s  hs;  simpa  using  hs.2)

/-- P4  side  analytic  on  U  (=  a2c_Dcut). -/
theorem  a2c_P4_analytic  {n  :  ℕ}  (hn  :  0  <  n)  :
    AnalyticOnNhd  ℂ  (fun  s  :  ℂ  =>  p4_em_expr  s  n)  a2c_Dcut  :=
  ((a2c_P4_diff  hn).analyticOnNhd  a2c_D_open).mono
    (by  intro  s  hs;  exact  hs.1)

/-! U6  U  IS  PRECONNECTED,  AND  THE  IDENTITY  THEOREM  LANDS. -/

/-- A  point  of  the  3-segment  path  from  x  to  anchor(x)  stays  in  U. -/
theorem  a2c_segA_path_mem  {x  :  ℂ}  (hx  :  x  ∈  a2c_Dcut)  :
    ∀  (γ  :  Path  x  (a2c_anchor  x)),
      (∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ  t  =  (1  -  t)  *  x  +  t  *  a2c_anchor  x)  →
      ∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ  t  ∈  a2c_Dcut  :=  by
  intro  γ  hval  t
  rw  [hval  t]
  simpa  using  a2c_segA_in_Dcut  x  hx  (t : ℝ)  t.2.1  t.2.2

/-- A  point  of  the  vertical  segment  between  anchor(a)  and
    anchor(b)  stays  in  U. -/
theorem  a2c_segM_path_mem  {a  b  :  ℂ}  :
    ∀  (γ  :  Path  (a2c_anchor  a)  (a2c_anchor  b)),
      (∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ  t  =  (1  -  t)  *  a2c_anchor  a  +  t  *  a2c_anchor  b)  →
      ∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ  t  ∈  a2c_Dcut  :=  by
  intro  γ  hval  t
  rw  [hval  t]
  simpa  using  a2c_segM_in_Dcut  a  b  (t : ℝ)

/-- The  3-segment  straight-line  concatenation  through  the  vertical
    line  {Re  =  2}  joins  any  two  points  of  U  inside  U. -/
theorem  a2c_Dcut_joinedIn  {x  y  :  ℂ}  (hx  :  x  ∈  a2c_Dcut)  (hy  :  y  ∈  a2c_Dcut)  :
    JoinedIn  a2c_Dcut  x  y  :=  by
  set  ax  :=  a2c_anchor  x
  set  ay  :=  a2c_anchor  y
  set  g1  :=  fun  (t  :  ℝ)  =>  (1  -  t)  *  x  +  t  *  ax
  set  g2  :=  fun  (t  :  ℝ)  =>  (1  -  t)  *  ax  +  t  *  ay
  set  g3  :=  fun  (t  :  ℝ)  =>  (1  -  t)  *  ay  +  t  *  y
  have  hgc1  :  ContinuousOn  g1  (Set.Icc (0  :  ℝ)  1)  :=  by
    have  hg  :  Continuous  fun  t  :  ℝ  =>  (1  -  t)  *  x  +  t  *  ax  :=  by
      continuity
    simpa  [g1]  using  hg.continuousOn.mono  (Set.subset_univ  _)
  have  hgc2  :  ContinuousOn  g2  (Set.Icc (0  :  ℝ)  1)  :=  by
    have  hg  :  Continuous  fun  t  :  ℝ  =>  (1  -  t)  *  ax  +  t  *  ay  :=  by
      continuity
    simpa  [g2]  using  hg.continuousOn.mono  (Set.subset_univ  _)
  have  hgc3  :  ContinuousOn  g3  (Set.Icc (0  :  ℝ)  1)  :=  by
    have  hg  :  Continuous  fun  t  :  ℝ  =>  (1  -  t)  *  ay  +  t  *  y  :=  by
      continuity
    simpa  [g3]  using  hg.continuousOn.mono  (Set.subset_univ  _)
  set  γ1  :  Path  x  ax  :=  Path.ofLine  hgc1  (by  norm_num  [g1])  (by  norm_num  [g1])
  set  γ2  :  Path  ax  ay  :=  Path.ofLine  hgc2  (by  norm_num  [g2])  (by  norm_num  [g2])
  set  γ3  :  Path  ay  y  :=  Path.ofLine  hgc3  (by  norm_num  [g3])  (by  norm_num  [g3])
  have  hval1  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  (γ1  t :  ℂ)  =  g1  (t  :  ℝ)  :=  by
    intro  t
    dsimp  only  [γ1,  Path.ofLine,  Function.comp]
    simp  [Set.Icc]
  have  hval2  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  (γ2  t :  ℂ)  =  g2  (t  :  ℝ)  :=  by
    intro  t
    dsimp  only  [γ2,  Path.ofLine,  Function.comp]
    simp  [Set.Icc]
  have  hval3  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  (γ3  t :  ℂ)  =  g3  (t  :  ℝ)  :=  by
    intro  t
    dsimp  only  [γ3,  Path.ofLine,  Function.comp]
    simp  [Set.Icc]
  have  hγ1  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ1  t  ∈  a2c_Dcut  :=
    a2c_segA_path_mem  hx  γ1  hval1
  have  hγ2  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ2  t  ∈  a2c_Dcut  :=
    a2c_segM_path_mem  (a  :=  x)  (b  :=  y)  γ2  hval2
  have  hγ3  :  ∀  (t  :  Set.Icc (0  :  ℝ)  1),  γ3  t  ∈  a2c_Dcut  :=  by
    intro  t
    have  hw  :  (γ3  t :  ℂ)  =  (1  -  (1  -  (t :  ℝ)))  *  y  +  (1  -  (t :  ℝ))  *  ay  :=  by
      rw  [hval3  t]
      dsimp  only  [g3]
      ring
    have  hr1  :  0  ≤  1  -  (t :  ℝ)  :=  by  linarith  [t.2.2]
    have  hr2  :  1  -  (t :  ℝ)  ≤  1  :=  by  linarith  [t.2.1]
    simpa  [hw]  using  a2c_segA_in_Dcut  y  hy  (1  -  (t :  ℝ))  hr1  hr2
  have  hT  {p  q  r  :  ℂ}  (γγ  :  Path  p  q)  (hγ  :  ∀  (u  :  Set.Icc (0  :  ℝ)  1),  γγ  u  ∈  a2c_Dcut)
      (η  :  Path  q  r)  (hη  :  ∀  (u  :  Set.Icc (0  :  ℝ)  1),  η  u  ∈  a2c_Dcut)
      (t  :  Set.Icc (0  :  ℝ)  1)  :  (γγ.trans  η)  t  ∈  a2c_Dcut  :=  by
    rw  [Path.trans_apply]
    split_ifs  with  ht
    · apply  hγ
    · apply  hη
  have  h12  :  ∀  (u  :  Set.Icc (0  :  ℝ)  1),  (γ1.trans  γ2)  u  ∈  a2c_Dcut  :=
    fun  u  =>  hT  γ1  hγ1  γ2  hγ2  u
  refine  ⟨(γ1.trans  γ2).trans  γ3,  ?_⟩
  intro  t
  exact  hT  (γ1.trans  γ2)  h12  γ3  hγ3  t

/-- U  =  a2c_Dcut  is  path  connected  (hence  preconnected):  any  two
    points  are  joined  by  the  3-segment  path  through  {Re  =  2}. -/
theorem  a2c_Dcut_isPathConnected  :  IsPathConnected  a2c_Dcut  :=  by
  rw  [isPathConnected_iff]
  constructor
  · use  Complex.mk  (2  :  ℝ)  2
    constructor
    · simp  [a2c_D]
      norm_num
    · by_contra  h
      have  hre  :=  congr_arg  (Complex.re  :  ℂ  →  ℝ)  h
      norm_num  at  hre
  · intro  x  hx  y  hy
    exact  a2c_Dcut_joinedIn  hx  hy

/-- U  =  a2c_Dcut  is  preconnected. -/
theorem  a2c_Dcut_preconnected  :  IsPreconnected  a2c_Dcut  :=
  a2c_Dcut_isPathConnected.isConnected.isPreconnected

/-- THE  IDENTITY  IN  BODY  (A2c):  for  0  <  n,  the  two  sides
    riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s          (W  side)
    p4_em_expr  s  n                                      (P4  side)
    are  equal  at  every  s  in  U  =  a2c_Dcut.  They  are  both  analytic
    on  U (U5),  U  is  preconnected  (U6  above),  and  they  agree  on  the
    open  set  {Re  s  >  1}  (p4_identity)  which  meets  the
    neighborhood  of  z0  =  2  ∈  U. -/
theorem  a2c_inbody_identity  {n  :  ℕ}  (hn  :  0  <  n)  :
    EqOn  (fun  s  :  ℂ  =>  riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s)
      (fun  s  :  ℂ  =>  p4_em_expr  s  n)  a2c_Dcut  :=  by
  have  hfg  :  (fun  s  :  ℂ  =>  riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s)  =ᶠ[𝓝  (2  :  ℂ)]
      (fun  s  :  ℂ  =>  p4_em_expr  s  n)  :=  by
    have  hO  :  IsOpen  {s  :  ℂ  |  1  <  s.re}  :=  by
      have  hf  :  Continuous  (re  :  ℂ  →  ℝ)  :=  continuous_re
      rw  [show  {s  :  ℂ  |  1  <  s.re}  =  (re  :  ℂ  →  ℝ)  ⁻¹'  Ioi  (1  :  ℝ)  from  by
        ext  s
        simp]
      exact  IsOpen.preimage  hf  isOpen_Ioi
    rw  [eventuallyEq_iff_exists_mem]
    refine  ⟨{s  :  ℂ  |  1  <  s.re},  ?_,  ?_⟩
    · exact  hO.mem_nhds  (by  norm_num)
    · intro  s  hs
      exact  p4_identity  hs  hn
  exact  AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq  (a2c_W_analytic  hn)
    (a2c_P4_analytic  hn)  a2c_Dcut_preconnected  (by  norm_num  [a2c_Dcut,  a2c_D])  hfg

/-- In-body  A2c  at  the  band  off-points:  for  1000  <=  t,  0  <  d0  <  1/2
    and  0  <  n,  the  two  sides  agree  at  t4l_sOffL  t  d0  -  the  CITED
    A2c  bridge  (DLMF  25.2.8  /  Apostol  Thm  12.21)  at  Re  s  =  1/2,  now
    machine  proven  in  body. -/
theorem  a2c_sL_identity  {t  d0  :  ℝ}  (ht  :  1000  <=  t)  (hd0  :  0  <  d0)
    (hd12  :  d0  <  1  /  2)  {n  :  ℕ}  (hn  :  0  <  n)  :
    riemannZeta  (t4l_sOffL  t  d0)  -  p4_P  n  (t4l_sOffL  t  d0)  +
      p4_I  n  (t4l_sOffL  t  d0)  =  p4_em_expr  (t4l_sOffL  t  d0)  n  :=  by
  exact
    (show  (∀  (x  :  ℂ),  x  ∈  a2c_Dcut  →
        (fun  s  :  ℂ  =>  riemannZeta  s  -  p4_P  n  s  +  p4_I  n  s)  x  =
        (fun  s  :  ℂ  =>  p4_em_expr  s  n)  x)  from  a2c_inbody_identity  hn)
      (t4l_sOffL  t  d0)  (a2c_sL_in_Dcut  t  d0  ht  hd0  hd12)


--  =================================================================
--  S  BRIDGE  NORM  FORM  (the  squeeze's  premise  shape,  from
--      body)
--  =================================================================

/-- The  CITED  A2c  bridge  premise  of  the  T4Off  squeeze
    family,  DISCHARGED  IN  BODY:  at  every  band  off-point
    (1000  <=  t,  0  <  d0  <  1/2)  and  every  run  N  >=  1,  the
    fill  norm  equals  the  EM-kernel  norm  -  the  norm  form  of
    the  in-body  identity  a2c_sL_identity. -/
theorem  a2c_sL_bridge  (t  d0  :  ℝ)  (ht  :  1000  <=  t)  (hd0  :  0  <  d0)
    (hd12  :  d0  <  1  /  2)  (N  :  ℕ)  (HN  :  0  <  N)  :
    ‖riemannZeta  (t4l_sOffL  t  d0)  -
      (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))‖  =
    ‖p4_em_expr  (t4l_sOffL  t  d0)  N‖  :=  by
  have  hpt  :  riemannZeta  (t4l_sOffL  t  d0)  -
      (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))  =
      p4_em_expr  (t4l_sOffL  t  d0)  N  :=  by
    have  h  :=
      a2c_sL_identity  (t  :=  t)  (d0  :=  d0)  ht  hd0  hd12  HN
    have  hgoal  :  riemannZeta  (t4l_sOffL  t  d0)  -
        (p4_P  N  (t4l_sOffL  t  d0)  -  p4_I  N  (t4l_sOffL  t  d0))  =
        riemannZeta  (t4l_sOffL  t  d0)  -  p4_P  N  (t4l_sOffL  t  d0)  +
          p4_I  N  (t4l_sOffL  t  d0)  :=
      by  ring
    exact  hgoal.trans  h
  rw  [hpt]

end  --  noncomputable  section
