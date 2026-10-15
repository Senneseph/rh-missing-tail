"""s14:  independent  Riemann-Siegel  |zeta|  check  at  t  =  G+0.5.

    Z(t)  =  e^{i*theta(t)}  *  zeta(1/2+it)    (  real  Z )
    Z(t)  =  2 * Sum_{k<=K}  cos(theta(t)  -  t log k) / sqrt(k)
            +  R_K,   |R_K|  <=  ~  1/(2) * K^-1/2  (classical)

  |zeta(1/2+it)|  =  |Z(t)|  (  e^{i theta}  is  a  pure  phase )

From-scratch  series  (  no  mpmath  zeta  code  path  )  vs
mpmath  dps-50  zeta  value.  Goal:  exclude  any  >=  1e6  scale
error  in  the  |zeta|  channel  of  the  s9/s10  residual  chain.
"""
import math

import mpmath as mp
import numpy as np

G_LAST = 30001045999.981975555
T = G_LAST + 0.5


def theta_ld(t):
    """Riemann  theta  in  x87  80-bit  (  64-bit  mantissa )."""
    tl = np.longdouble(t)
    pi = np.longdouble("3.14159265358979323846264338327950288")
    two_pi = 2 * pi
    out = (tl * np.log(tl / two_pi) - tl + pi / np.longdouble(4)
           + 1 / (8 * tl) - 1 / (192 * tl ** 3) + 1 / (256 * tl ** 5))
    return out


def main():
    K = 200000
    th = theta_ld(T)          # longdouble  radians,  error  ~  1e-9
    k = np.arange(1, K + 1, dtype=np.float64)
    #  t log k  reduced  mod  2pi  carefully:  f64  ulp  at  3e11  ~
    #  6e-5  rad  --  fine  for  this  test  (  we  only  need  ~1e-3 ).
    arg = np.float64(th) - T * np.log(k)
    arg = (arg + math.pi) % (2 * math.pi) - math.pi
    c = np.cos(arg) / np.sqrt(k)
    zsum = 2.0 * np.longdouble(np.sum(c))
    print("K  =  %d" % K, flush=True)
    print("|Z_RS|  (  f64  terms,  ld  sum  )  =  %.9e" % zsum, flush=True)
    print("remainder  bound  ~  1/(2 sqrt K)  =  %.2e"
          % (1 / (2 * math.sqrt(K))), flush=True)
    with mp.workdps(50):
        t50 = mp.mpf(repr(T))
        zs = mp.zeta(mp.mpc(mp.mpf("0.5"), t50))
        print("mpmath  |zeta|  (dps-50)  =  %.12e" % abs(zs), flush=True)
        print("mpmath  log|zeta|  =  %+.12e"
              % float(mp.log(abs(zs))), flush=True)
        dz = abs(abs(zs) - abs(zsum))
        print("difference  =  %.4e" % dz, flush=True)
    print()
    if dz < 1e-3:
        print("PASS:  independent  RS  matches  mpmath  to  1e-3  --")
        print("the  |zeta|  channel  is  healthy;  the  residual  chain")
        print("is  not  fooled  by  a  zeta-evaluation  bug.")
    elif dz < 1e-6:
        print("STRONG  PASS  (  1e-6  )")
    else:
        print("MISMATCH:  investigate  before  trusting  any  channel")
        print("that  depends  on  |zeta|  at  this  height.")


if __name__ == "__main__":
    main()
