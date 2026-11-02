import  Mathlib
import  RhAttack.P4Em2
import  RhAttack.P4Tail
import  RhAttack.P4Limit
import  RhAttack.T4OffL

set_option  linter.style.whitespace  false

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

end  --  noncomputable  section
