# T4OffM.lean  (812 lines)
WHAT:  G-hs3-ii  +  G-hs3-iii  CLOSED  IN  THE  MACHINE  -  the  Mr
         wire  LIFTED  OFF  THE  LINE,  and  the  strip-band  margin
         composition  under  the  lifted  EM  wall  (discovery  0118,
         GATED:  0  sorry,  full  tree  green).
HOW:   defs  t4m_ZboundOff  (t0,  d0)  :=  1.6  *  t0^(1/4 +  d0/2)
         *  ln  t0  (worst-side  convexity  mass,  CITED  in  the
         module  header  -  DLMF  25.15.4-type  convexity  with  the
         SAME  1.6  the  tree  already  cites  on  the  line,  via
         the  functional  equation;  this  is  the  ONLY  non-machine
         input  of  the  module)  and  t4m_MwireOff  (t0,  d0)  :=
         ZboundOff  *  e^X4fun  *  X4fun  (the  on-line  M  *  e^X  *
         X  shape  at  the  lifted  mass;  the  b3  correction  is
         sigma-  independent  so  no  new  analytic  barrier).
         The  machine  chain  (all  LEAN,  exact-decimal  pins
         audited  by  tmp/t4offm_audit.py):
           t4m_shape    ZboundOff  =  (on-line  S4W.Zbound)  *  t^(d/2)
                        (rpow_add  split);
           t4m_Mterm    MwireOff  (t0,  d0)  <=  MTUBfun  t0  *
                        t0^(d0/2)  (st_hMterm  on-line  M-chain  with
                        M  :=  Zbound(t0));
           t4m_Mpin     MTUBfun  t0  *  t0^(d0/2)  <=  2.5e-15  *
                        t0^(-9/2)  (-19/4  +  d/2  <=  -9/2);
           t4m_Bupper   p8_B  t0  (S4Strip.n4  t0)  <=  9e-5  *
                        t0^(-2)  (three  termwise  pins  against  the
                        n  >=  3.1e7  *  t^4  floor:  constants  by
                        sq_le_sq0  square-bridges,  norms  by
                        Complex.ext  +  t4o_normsq,  exponents  by
                        rpow_add  splits);
           t4m_margin   [G-hs3-iii]  p8_B  t0  (n4  t0)  +
                        MwireOff  t0  d0  <  floStripMin  t0  d0
                        (floStripMin  =  mown  on  the  band  by
                        FUnif;  mown  >=  F4  t^(-2)  by  S4Strip;
                        corner:  9e-5  +  2.5e-15  *  t^(-5/2)  <  F4
                        with  2.5e-15  *  t^(-5/2)  <=  1e-21  at  the
                        t  =  1000  corner  -  margin  ~16  orders);
           t4m_Bmono    p8_B  t  n  <=  p8_B  t  m  for  m  <=  n
                        (each  term  n^(-k/2)  monotone  -  the
                        schedule  comparison  the  endpoint  needs  to
                        move  the  T4OffD  wall  from  the  schedule  to
                        any  smaller  admissible  n);
           t4m_resid_strip  [the  G-hs3-ii/iii  terminal,  P8Floor-A5
                        shape]:  at  s  =  (1/2  +  d0)  +  i*t0,
                        under  hW  (W-side  wall,  from  T4OffD  +
                        t4m_Bmono)  and  hK  (K  -  (P_n  -  I_n)(s)
                        bounded  by  Mval  <=  MwireOff  -  the  CITED
                        mass  lift),
                            |W_n(s)  -  (K  -  (P_n  -  I_n)(s))|
                            <  floStripMin  t0  d0.
         CONSEQUENCE:  on  the  strip  band  above  the  frontier,
         the  hs3  leg  of  the  endpoint  reduces  to  ONE  cited
         convexity  mass  (the  header),  not  to  an  analytic
         barrier.
USES:  used  by:  the  endpoint  hs3  composition  (RHEnd  -  to  be
         spliced:  hW  :=  T4OffD.t4wall_offline_le_bwires  at  the
         schedule  +  t4m_Bmono;  hK  :=  the  CITED  mass  lift  +
         t4m_Mterm  +  t4m_Mpin)  -  drops  hs3  from  the  RHEnd
         stripfront  premises  above  the  frontier.
GOTCHA:  No  RH  claim:  the  only  non-machine  input  is  a  CITED
         classical  convexity  bound;  everything  else  is  machine-
         checked  on  a  concrete  band.  calc  relation  lines  must
         share  ONE  indent;  rpow  exponent  bridges  ((a)  =
         (b  +  c),  (1000)^(5/2)  square  pins  via  sq_le_sq0  +
         rpow_two/rpow_mul  symm  chains)  are  the  fragile  part  of
         this  file.  Lean  4.33.1  +  mathlib  v4.33.1,
         DOC-FIRST.
