# T4OffD.lean  (608 lines)
WHAT:  THE STRIP-BAND DOMINATION of the lifted T4 wall (G-hs3-i,
         endpoint form, discovery 0117).
HOW:   t4wall_offline_le_bwires:  for  every  1000  <=  t0  and  1/200
         <=  d0  <=  1/2,  the  off-line  lifted  T4  wall
         (T4Off.p4_T4_bound_gen  applied  at  the  canonical  strip
         point  (1/2 + d0) + it0  with  the  t^4  n-schedule
         S4Strip.n4)  is  TERMWISE  below  the  on-line  B-wire
         P8Floor.p8_B  t0  (S4Strip.n4  t0):  term  1  by  the  extra
         damping  n^(-d0);  term  2  by  the  norm  ratio  (<=  6/5,
         from  the  1/200  strip  width  against  the  t^4  growth)
         against  n^(-d0)  (>=  6/5  at  the  band  edge,  via  the
         200th-root  wall  n  >=  (6/5)^200);  term  3  by  the  per-
         factor  translation  ratio  (<=  2001/2000  each,  product
         (2001/2000)^3)  against  the  wall  constant  540  vs  216
         plus  the  (5/2+d0)  denominator,  with  the  damping  constant
         c^3*n^-d0  <=  (2/5)*(5/2+d0)  (since  n^-d0  <=  1  and
         (2001/2000)^3  <  1.0016  <=  (2/5)*2.505).  Helpers:
         t4o_sOff/t4o_sOn  (canonical  points),  termwise  lemmas
         t4o_T1/t4o_T2/t4o_T3,  the  core  hPdiv  division  step.
         CONSEQUENCE:  G-hs3-i  is  closed  at  the  endpoint  level
         (the  hs3  side  of  the  endpoint  premise  is  dominated  by
         the  strip  B-wire  term  everywhere  on  the  band),  on  top
         of  the  component  closure  of  discovery  0116.  G-hs3-ii
         (P6  finite-kernel  gap  /  Mr  wire  off  the  line)  and
         G-hs3-iii  (margin  composition  below  floStripMin)  remain
         open.  GOTCHA:  calc  relation  lines  must  share  ONE  indent
         (a  dedent  silently  ENDS  the  calc  and  the  next  '_  <='
         line  parses  as  a  command);  'simpa  only'  is  required
         under  'simpa  ...  using'  where  terms  carry  divisions
         (default  simp  re-normalizes  '/'  to  '*^-1'  and  breaks
         unification);  kernel  timeouts  on  the  triple-product  norms
         need  'set_option  maxHeartbeats'.
USES:  used by: (the  endpoint  hs3  leg  -  composing  with  the
         G-hs3-ii  Mr  wire  lift  and  the  S1LowT  floor  (G-hs3-iii)
         makes  hs3  body-provable  above  the  frontier  and  drops  it
         from  the  RHEnd  stripfront  premises).
GOTCHA: No  RH  claim:  a  termwise  domination  between  two  explicit
          wire  expressions  on  a  concrete  band.  Lean  4.33.1  +
          mathlib  v4.33.1,  DOC-FIRST.
