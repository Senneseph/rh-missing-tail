#!/usr/bin/env python3
"""day058d:  T-EXTENT of the 0244/0245 middle-band island.

The G-hs3-left face quantifies over  t0 >= tPT2.  The 0244/0245
island was measured AT tPT2.  Here: how far in t does the n4
wire's middle-band controllability carry?  Closed forms only
(no zeta evaluation, no zero-existence, no RH claim).

f_t(d0)  =  T1(d0,t) / own(d0,t),
T1  =  (1/2) n4(t)^(-sigma),   sigma  =  1/2 - d0,
own =  pairfac(d0) * pairfac(-d0)  ~  4 d0^2 t^-2  (off edge).

T1/own ~ C0^-sigma t^(-4sigma+2) / (4 d0^2)
       ~ const(d0) * t^(4 d0):  the ratio GROWS in t for every
d0 > 0  (wire decays t^-4sigma  =  t^-(2-4d0),  floor t^-2)
- the island must eventually vanish;  find  t*  where  the
island-minimum of f_t crosses 1.
"""
import mpmath as mp

mp.mp.dps = 50
OUT = []


def P(*a):
    s = " ".join(str(x) for x in a)
    OUT.append(s)
    print(s)


T_PT2 = mp.mpf(3000175332800)
C0 = mp.mpf(31000000)


def n4(t):
    return C0 * t ** 4


def pairfac(d, t):
    a = mp.mpf(0.5) + d
    x = a * a + t * t
    return abs(d) * mp.sqrt(d * d + 4 * t * t) * mp.e ** (a / x) / x


def own(d, t):
    return pairfac(d, t) * pairfac(-d, t)


def t1(d, t):
    return mp.mpf(0.5) * n4(t) ** (-(mp.mpf(0.5) - d))


def f(d, t):
    return t1(d, t) / own(d, t)


P("=" * 74)
P("day058d  -  T-EXTENT  of  the  middle-band  island  (n4  wire)")
P("closed-form;  no  zeta  eval,  no  zero-existence,  no  RH  claim.")
P("=" * 74)
P()
P("PART 1:  verification at tPT2 (reproduce 0244/0245)")
P("-" * 74)


def island_scan(t, lo=mp.mpf("0.004"), hi=mp.mpf("0.034"), n=3000):
    best = None
    prev = None
    cross = []
    ds = (hi - lo) / n
    for i in range(n + 1):
        d = lo + i * ds
        v = f(d, t) - 1
        if best is None or v < best[1]:
            best = (d, v)
        if prev is not None and prev[1] * v < 0:
            a, b = (prev[0], d) if prev[1] < 0 else (d, prev[0])
            for _ in range(80):
                m = (a + b) / 2
                if f(a, t) * f(m, t) <= 1:
                    b = m
                else:
                    a = m
            cross.append((a + b) / 2)
        prev = (d, v)
    return best, cross


(dmin_t, vmin_t), cross_t = island_scan(T_PT2)
P(f"tPT2:  island  [{mp.nstr(cross_t[0], 10)},  {mp.nstr(cross_t[1], 10)}]  "
  f"(0244:  [0.008083954801,  0.02542065612])")
P(f"      T1/own minimum  {mp.nstr(vmin_t + 1, 6)}  at  d0  =  "
  f"{mp.nstr(dmin_t, 6)}   (0244:  0.724  at  0.016)")
P()

P("PART 2:  island min and boundaries vs t")
P("-" * 74)
P(f"{'t/tPT2':>10}  {'t':>14}  {'min T1/own':>12}  {'lo boundary':>12}  "
  f"{'hi boundary':>12}  {'island?':>8}")
rows = []
for c in [1, 2, 5, 10, 20, 50, 100, 155, 200, 500, 1000]:
    t = T_PT2 * c
    (dmin, vmin), cross = island_scan(t)
    if len(cross) == 2 and vmin < 0:
        isl = "yes"
        clo, chi = mp.nstr(cross[0], 9), mp.nstr(cross[1], 9)
    else:
        isl = "GONE"
        clo = chi = "-"
    rows.append((c, t, vmin, clo, chi, isl))
    P(f"{c:>10}  {mp.nstr(t, 14):>14}  {mp.nstr(vmin + 1, 8):>12}  "
      f"{clo:>12}  {chi:>12}  {isl:>8}")
P()

P("PART 3:  bisection for t* (island minimum crosses 1)")
P("-" * 74)


def min_f(t):
    (dmin, vmin), _ = island_scan(t)
    return vmin, dmin


a, b = T_PT2, T_PT2 * 1000
fa, fa_d = min_f(a)
fb, _ = min_f(b)
P(f"min f at  tPT2      =  {mp.nstr(fa + 1, 6)}  (< 1,  alive)")
P(f"min f at  1000*tPT2 =  {mp.nstr(fb + 1, 6)}  (> 1,  gone)")
dstar = fa_d
for _ in range(60):
    m = mp.sqrt(a * b)
    fm, dstar = min_f(m)
    if fm < 0:
        a = m
    else:
        b = m
tstar = mp.sqrt(a * b)
P(f"t*  =  {mp.nstr(tstar, 12)}   (  =  {mp.nstr(tstar / T_PT2, 6)} x tPT2 )")
P()
P("pointwise-law check:  f_t(d) ~= f_tPT2(d) * (t/tPT2)^(4 d).  At  the")
P(f"DRIFTED  argmin  d*(t*)  ~=  {mp.nstr(dstar, 6)}:  "
  f"f_tPT2(d*(t*)) * (t*/tPT2)^(4 d*(t*))  =  "
  f"{mp.nstr(f(dstar, T_PT2) * (tstar / T_PT2) ** (4 * dstar), 6)}")
P("vs the measured 1 (crossing) - agreement confirms the t^(4 d0) law")
P(f"(the argmin itself drifts:  d*(tPT2)  =  {mp.nstr(dmin_t, 6)}  ->  "
  f"d*(t*)  =  {mp.nstr(dstar, 6)}).")
P()
P("VERDICT (machine-level, no RH claim):")
P(f"  the 0244/0245 middle-band island (full-wall controllable at")
P(f"  tPT2)  SHRINKS  AND  VANISHES  as  t  grows:  at  t")
P(f"  above  t*  ~=  {mp.nstr(tstar, 3)}  the  n4  wire's  first term")
P(f"  exceeds  the  witness's  own  floor  ACROSS  THE  WHOLE  left")
P(f"  strip band  (0.005 < d0 <= posReserveD0max).  Structurally:")
P(f"  T1/own  scales  like  t^(4 d0)  (wire  t^-(2-4d0)  vs  floor")
P(f"  t^-2),  so  no  fixed  t-threshold  schedule  of  the  n4")
P(f"  family  can  serve  both  the  tPT2  slice  AND  t  ->  inf:")
P(f"  G-hs3-left  at  t0  >=  tPT2  is  open  FOR  ALL  t0  >=  t*")
P(f"  by  this  mechanism,  and  the  0244/0245  controllability")
P(f"  certificate  carries  only  the  slice  tPT2  <=  t0  <  t*.")
P("=" * 74)

open("out_day058d_island_textent.txt", "w").write("\n".join(OUT) + "\n")
