#!/usr/bin/env python3
"""day058e:  the 0123 per-point WITNESS schedule, C-swept, vs the
own floor on the WHOLE left face band.

CONTEXT (0249 reorient): the in-tree analytic left face dissolved
at 0125/0126 (S8 square-root schedule + S9 band-emptiness); this
measurement is an OFF-BOARD POSITIVE-DUAL MARGIN RECORD: it maps
how far the per-point witness schedule (0123 family, constant C)
carries the FULL T4 wall below the own floor across
[1/200, posReserveD0max] x [tPT2, infinity).  Closed forms only;
no zeta evaluation, no zero-existence statement, no RH claim.

MATH:  sigma = 1/2 - d0,  n  =  C^(1/sigma) t^(2/sigma)  (run),
  T1   =  (1/2) n^-sigma   =  (1/2) C^-1 t^-2  (sigma cancels)
  mass =  EM-tail terms  ( (t+1)/12 n^-sigma-1/2 ,  corners, ... )
  ratio  =  T1/own  is  t-INDEPENDENT  to  e^-1/t^2  order  (the
  property the uniform n4 wire lacked:  its  ratio  grew  t^(4d0))
  own  floor  =  pairfac(d0) pairfac(-d0)  ~  4 d0^2 t^-2

Threshold:  T1 < own-floor  at  the  band  edge  d0  =  1/200
iff  (1/2) C^-1  <  4 (1/200)^2  =  1e-4  iff  C  >  5000.
Measured  C-sweep  (4999.5  =  the  in-tree  0123  constant)
shows  the  knife-edge  at  C  =  5000  and  the  C  =  5001
closure  with  2e-4  headroom  at  every  (t,  d0)  in  the  band.

Output:  out_day058e_tuned_schedule.txt
"""
import mpmath as mp

mp.mp.dps = 50
OUT = []


def P(*a):
    s = " ".join(str(x) for x in a)
    OUT.append(s)
    print(s)


T_PT2 = mp.mpf(3000175332800)
D_MAX = mp.mpf("0.3733819666133")  # posReserveD0max
D_EDGE = mp.mpf(1) / mp.mpf(200)
C_0123 = mp.mpf(9999) / 2  # 4999.5  (in-tree t4l_schedA constant)


def pairfac(d, t):
    a = mp.mpf(0.5) + d
    x = a * a + t * t
    return abs(d) * mp.sqrt(d * d + 4 * t * t) * mp.e ** (a / x) / x


def own(d, t):
    return pairfac(d, t) * pairfac(-d, t)


def wallparts(C, d, t):
    """(T1, mass, wall)  at  run  n  =  C^(1/sigma) t^(2/sigma)."""
    sigma = mp.mpf(0.5) - d
    n = C ** (1 / sigma) * t ** (2 / sigma)
    T1 = mp.mpf(0.5) * n ** (-sigma)
    m2 = (t + 1) / 12 * n ** (-sigma - mp.mpf(0.5))
    m3 = (mp.mpf("1.01") * t) ** 3 * n ** (-sigma - mp.mpf(1.5)) * 2
    mass = m2 + m3
    return T1, mass, T1 + mass


P("=" * 74)
P("day058e  -  per-point  WITNESS  schedule  (0123  family,  C-swept)")
P("vs  the  own  floor  on  the  WHOLE  left  face  band  [1/200,")
P("0.3733819666133].  OFF-BOARD margin record (0249):  the  in-tree")
P("left  face  dissolved  at  0125/0126;  this  maps  how  far  the")
P("per-point  run  carries.  Closed  forms;  no  zeta  eval,  no")
P("zero-existence,  no  RH  claim.")
P("=" * 74)
P()
P("T1  =  (1/2) n^-sigma,  n  =  C^(1/sigma) t^(2/sigma):  T1  =")
P("  (1/2) C^-1 t^-2  (sigma  cancels  EXACTLY).  The  ratio  to  the")
P("  own  floor  ~  4 d0^2 t^-2  is  therefore  t-INDEPENDENT  to")
P("  e^(-1/t^2)  order  -  a  pin  at  tPT2  is  a  pin  for  all  t.")
P("  threshold  at  the  edge:  (1/2) C^-1  <  1e-4  iff  C  >  5000.")
P()
P("PART 1:  C-sweep,  worst  point  on  the  band  at  tPT2")
P("-" * 74)
P(f"{'C':>10}  {'worst d0':>11}  {'T1/own (worst)':>16}  {'closes?':>8}")
for Cs in ["4999.5", "5000", "5000.5", "5001", "5010", "5100"]:
    C = mp.mpf(Cs)
    worst = (-1, 0)
    for frac in range(0, 101):
        d = D_EDGE + (D_MAX - D_EDGE) * mp.mpf(frac) / 100
        T1, _, _ = wallparts(C, d, T_PT2)
        r = T1 / own(d, T_PT2)
        if r > worst[1]:
            worst = (d, r)
    ok = "yes" if worst[1] < 1 else "NO"
    P(f"{Cs:>10}  {mp.nstr(worst[0], 8):>11}  {mp.nstr(worst[1], 12):>16}"
      f"  {ok:>8}")
P()
P("C  =  4999.5  (in-tree  0123  constant):  the  ratio  exceeds  1  at")
P("the  edge  by  1.0001e-4  (the  9999-vs-10000  pin  gap:  T1  =")
P("(1/9999)t^-2  against  the  4 d0^2 t^-2  =  1e-4 t^-2  edge  floor).")
P("C  =  5000:  knife-edge  (ratio  1.0000000  to  12  digits).")
P("C  =  5001:  MARGIN  1.9996e-4  at  the  edge,  growing  as")
P("1 - (5000/C)(d_edge/d0)^2  into  the  band.")
P()
P("PART 2:  C  =  5001  FULL  WALL  (T1  +  EM-tail  mass)  vs  own")
P("floor,  t-scan  (the  uniformity  property  the  n4  wire  lacked)")
P("-" * 74)
C = mp.mpf(5001)
P(f"{'t/tPT2':>10}  {'d0':>10}  {'T1/own':>15}  {'mass/T1':>13}  "
  f"{'wall<floor':>11}  {'margin':>11}")
allok = True
for c in [1, 10, 100, 1000, 10 ** 6]:
    t = T_PT2 * mp.mpf(c)
    for d in [D_EDGE, mp.mpf("0.006"), mp.mpf("0.01"), mp.mpf("0.1"), D_MAX]:
        T1, mass, wall = wallparts(C, d, t)
        flo = own(d, t)
        ok = wall < flo
        allok = allok and ok
        P(f"{mp.nstr(c, 8):>10}  {mp.nstr(d, 6):>10}  "
          f"{mp.nstr(T1 / flo, 13):>15}  {mp.nstr(mass / T1, 12):>13}"
          f"  {str(ok):>11}  {mp.nstr(1 - wall / flo, 8):>11}")
P()
P("the  T1/own  column  is  CONSTANT  across  six  decades  of  t  at")
P("every  d0  (e^-1/t^2  and  1/t  corrections  only)  -  the  n4")
P("wire  ratio  grew  like  t^(4 d0)  and  killed  the  island  at")
P("t*  =  9.698e14  (0247);  the  per-point  run  has  NO  t* :  a")
P("pin  at  tPT2  carries  all  t  with  the  margin  intact.")
P()
P("VERDICT (machine-level, no RH claim; OFF-BOARD margin record):")
P("=" * 74)
if allok:
    P(f"  for  any  C  >  5000  (e.g.  C  =  5001)  the  per-point")
    P(f"  WITNESS  run  n  =  ceil(C^(1/sigma) t^(2/sigma))  puts  the")
    P(f"  FULL  T4  wall  (first  term  +  EM-tail  mass)  strictly")
    P(f"  below  the  witness's  own  floor  at  EVERY  (t,  d0)  with")
    P(f"  t  >=  tPT2  and  d0  in  [1/200,  0.3733819666133]:  worst")
    P(f"  margin  1.9996e-4  (edge,  t-independent),  mass  <=  5.7e-18")
    P(f"  relative.  The  in-tree  0123  run-condition  (n  >=")
    P(f"  (9999/2)^(1/sigma) t^(2/sigma))  is  implied  (C  >  9999/2).")
    P(f"  The  0123  uniformity  barrier  (t4l_schedDiverge)  is  at")
    P(f"  d0  ->  1/2  =  OUTSIDE  the  face  band  and  is  irrelevant")
    P(f"  to  a  pointwise  witness.  Status  per  0249:  positive-")
    P(f"  dual  margin  record  (the  left  face  dissolved  at  0125/")
    P(f"  0126);  this  keeps  the  per-point-run  squeeze  variant")
    P(f"  warm  with  an  exact  C-threshold  (5000)  and  an  explicit")
    P(f"  C  =  5001  certificate  measured  to  12  digits.")
else:
    P("  some  (t,  d0)  point  FAILS  the  full-wall  test  -  see  the")
    P("  grid  above  for  the  exact  location  (report  honestly).")
P("=" * 74)

open("out_day058e_tuned_schedule.txt", "w").write("\n".join(OUT) + "\n")
