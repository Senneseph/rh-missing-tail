"""s19u:  U-CUTOFF  EXPERIMENT  (0153 unit,  decisive).

Model  (0153  hypothesis):  the  t^2  coefficient  of  M  is  set
by  the  RVM  density  channel's  UPPER  CUTOFF  U:
      C_M(U)  =  -f(U),   f(g)  =  -ln(g/2pi)/(2pi g)
i.e.  from  the  (t, U]  piece  of  I_far:
      re  pairlog  ~  -t^2/g^2   (g  >  t)
      I_far  ~  -t^2 * [F(U)  -  F(t)],   F'(g)  =  g^{-2} rho(g)
      M  =  ...  -  I_far  =>  C  =  +F(U)  =  -f(U)...  (signs
  settled  by  the  data  below;  magnitudes  are  the  test).

Test:  replace  U  =  1e30  by  U'  in  i_far  ONLY  (same  dps-40
kernel/split  on  (G, U']),  form
      M(U',  t)  =  M(1e30,  t)  +  I_far(1e30,  t)  -  I_far(U',  t)
from  the  stored  S17  rows,  read  the  row-wise  effective
coefficient     C_eff(U',  t)  =  resid_F1(M(U', t))  /  t^2
and  compare  with  F(U').

      U'      F(U') = -ln(U'/2pi)/(2pi U')
      1e30    -1.0701527e-29   (in-tree,  measured C = -1.086e-29)
      1e25    -8.868e-25
      1e20    -2.954e-20   ...
If  C_eff  tracks  F(U')  down  the  ladder  the  mechanism  is
confirmed  (not  just  the  2-digit  1e30  coincidence);  if  not,
the  t^2  is  elsewhere.

cd  scripts/rh  &&  python3  s19u_u_cutoff.py
"""
import os
import sys
import json
import time

import numpy as np
from mpmath import workdps, mpf, mpc, mp

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

G_LAST = mpf("30001045999.981975555")
U_IN = mpf("1e30")

A1 = -25256007.0
B1 = 523513775.0


def i_far(tv, U, dps=40):
    with workdps(dps):
        s = mpc(0.5, mpf(str(tv)))

        def fu(u):
            g = mp.e ** u
            r1 = mpc(0.5, g)
            r2 = mpc(0.5, -g)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2))
            return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g
        lo = mp.log(G_LAST)
        hi = mp.log(U)
        lt = min(mp.log(mpf(str(tv))), hi)
        if lt <= lo:
            return float(mp.re(mp.quad(fu, [lo, hi])))
        return float(mp.re(mp.quad(fu, [lo, lt]))
                     + mp.re(mp.quad(fu, [lt, hi])))


def F(U):
    # exact t^2 coefficient of the (t, U] piece, M sign:
    # C_M = -(ln(U/2pi) + 1)/(2pi U)   (F1(U) = (ln(U/2pi)+1)/(2pi U))
    return (np.log(U / (2 * np.pi)) + 1.0) / (2 * np.pi * U)


def main():
    Ulist = [1.0e30, 1.0e25, 1.0e20, 1.0e15, 1.0e12]
    rows = [json.loads(l) for l in open("/home/jsmille/Projects/rh-missing-tail/tmp/s17_M_far2.jsonl") if l.strip()]
    rows = [r for r in rows if r["t"] >= 1.0e17]
    print("rows: %s" % ["%.3g" % r["t"] for r in rows])
    results = []
    for U in Ulist:
        print("U' = %.1e     F(U') = %.6e" % (U, F(U)), flush=True)
        t0 = time.time()
        for r in rows:
            iU = i_far(r["t"], U)
            M_U = r["M"] + r["I_far"] - iU
            resid = M_U - (A1 * np.log(r["t"]) + B1)
            c_eff = -resid / r["t"] ** 2
            print("   t = %12.6g   I_far(U') = % .6e   M(U') = % .6e   C_eff = % .6e"
                  % (r["t"], iU, M_U, c_eff), flush=True)
            results.append((U, r["t"], c_eff))
        print("   (%.0f s)" % (time.time() - t0), flush=True)
    print()
    print("model check (C_eff vs -F(U')):")
    for U in Ulist:
        eff = [c for (u, t, c) in results if u == U]
        avg = np.mean(eff)
        print("   U' = %.1e   -F(U') = % .6e   mean C_eff = % .6e   ratio = % .6f"
              % (U, -F(U), avg, avg / (-F(U))))


if __name__ == "__main__":
    main()
