"""s19t:  I_FAR  RESOLUTION  TEST  (0153 unit,  part  B).

Question:  is  the  t^2  term  (C  =  -1.086e-29,  0152)  in  M's
high-t  residual  a  grid/adaptivity  RESIDUAL  of  the  I_far
channel  (s9's  i_far_split:  dps-40  tanh-sinh  over  the  u-in
(log 3e10,  log 1e30],  split  at  u  =  ln  t,  two  segments),
or  subleading  STRUCTURE  of  the  model  kernel  itself  (the
g^2/t^2  and  higher  pieces  of  log|1-s/rho|  for  t  >>  g)?

Method  -  same  integral,  five  independent  resolutions,  at
three  heights  (1e17,  1e18,  3.16e18):
  V1  =  s9  baseline  (2  segments,  default  tanh-sinh)
  V2  =  split  +  maxpass  7  (more  adaptive  polish)
  V3  =  split  +  8  equal-u  subintervals  per  side
  V4  =  200  log-spaced  grid  (incl.  ln t  node)  +  tanh-sinh
         per  cell  (the  s18  rem_quad  posture)
  V5  =  V1  at  dps-50  (precision  direction)
Readout:  D(t)  =  V2  -  V1  (the  direct  baseline-resolution
residual).  If  |D(t)|  tracks  ~t^2  (D(3.16e18)/D(1e18)  ~  10
with  matching  sign)  it  is  a  resolution  artifact;  if  the
V1..V5  spread  is  O(1)  it  is  kernel  structure  and  the
three-term  law  is  the  channel's  own  property.

Light:  1  thread,  ~0.5  GB.  cd  scripts/rh  &&  python3
s19t_far_res.py
"""
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from mpmath import workdps, mpf, mpc, mp


G_LAST = mpf("30001045999.981975555")
U_HI = mpf("1e30")


def fu_factory(tv):
    s = mpc(0.5, mpf(str(tv)))

    def fu(u):
        g = mp.e ** u
        r1 = mpc(0.5, g)
        r2 = mpc(0.5, -g)
        p = (mp.log(1 - s / r1) + mp.log(1 - s / r2))
        return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g
    return fu


def value(tv, dps, maxpass=None, sub=1, grid=None):
    with workdps(dps):
        fu = fu_factory(tv)
        lo = mp.log(G_LAST)
        hi = mp.log(U_HI)
        lt = mp.log(mpf(str(tv)))
        if grid:
            n = grid
            nodes = [lo + (hi - lo) * mpf(k) / n for k in range(n + 1)]
            k0 = int((lt - lo) / (hi - lo) * n)
            nodes = nodes[:k0 + 1] + [lt] + nodes[k0 + 1:]
        else:
            nodes = [lo, lt, hi]
        total = mp.mpc(0)
        for k in range(len(nodes) - 1):
            a, b = nodes[k], nodes[k + 1]
            if maxpass:
                total += mp.quad(fu, [a, b], maxpass=maxpass)
            elif sub > 1:
                pts = [a + (b - a) * mpf(k) / sub for k in range(sub + 1)]
                total += mp.quad(fu, pts)
            else:
                total += mp.quad(fu, [a, b])
        return float(mp.re(total))


def run():
    ts = [1.0e17, 1.0e18, 3.1622776601683795e18]
    out = []
    for tv in ts:
        t0 = time.time()
        v1 = value(tv, 40)                                   # s9 baseline
        v2 = value(tv, 40, maxpass=7)                        # adaptive polish
        v3 = value(tv, 40, sub=8)                            # 16 segments
        v4 = value(tv, 40, grid=200)                         # log-spaced 200
        v5 = value(tv, 50)                                   # precision
        dt = time.time() - t0
        d = v2 - v1
        print("t = %.9g   (%.0f  s)" % (tv, dt), flush=True)
        for name, v in [("V1 baseline-2seg", v1), ("V2 maxpass7", v2),
                        ("V3 16-seg", v3), ("V4 grid200", v4),
                        ("V5 dps50", v5)]:
            print("   %-16s % .6e" % (name, v))
        print("   D = V2-V1      % .6e     D/t^2 = % .6e"
              % (d, d / (tv * tv)), flush=True)
        out.append((tv, v1, v2, v3, v4, v5))
    print()
    print("D(t)/t^2 over the three heights (if ~constant, the")
    print("resolution residual scales like t^2):")
    prev = None
    for (tv, v1, v2, v3, v4, v5) in out:
        d = v2 - v1
        c = d / (tv * tv)
        print("   t=%-14.6g  D=%.4e  D/t^2=%.4e" % (tv, d, c))
    print()
    print("spread(t) = max|V_i - V1|:")
    for (tv, v1, v2, v3, v4, v5) in out:
        sp = max(abs(v - v1) for v in (v2, v3, v4, v5))
        print("   t=%-14.6g  spread=%.4e" % (tv, sp))


if __name__ == "__main__":
    run()
