#!/usr/bin/env python3
"""day029 -- dps-30 CERTIFIED pin, CORRECTED statistic (25h protocol +
V2 horizon).

The 25y pin (day024_p06_pin_25x.py) protocol verbatim -- dps-30, main
product (14.13, 1e7] at dps-30 over the LMFDB 15-digit list, tail =
discrete float64 over ACTUAL zeros (1e7, 1.006346e9] + dps-30
400-quad (G_LAST, 1e18] -- PLUS the day029 corrections: the (1e18, 1e30]
400-quad extension (full horizon; the (1e30, inf) factor is 1 - O(t^2/1e30)
< 1e-9 for t <= 1e9) and the t^4-wire < side:
  margin  = |z| min_d |R(g,d,t)-1| / (B_best(t) + resid)      [25x reg.]
  margin2 = |z| min_d |R(g,d,t)-1| / (B_best(t) + residf)
  margin3 = |z| min_d |R(g,d,t)-1| / (p8_B(t, n4(t)) + residf) [t^4 wire]
residf = |z - K_full|, K_full = K * e^{Q(1e18,1e30]}.
dg grid: the 25h 7-point grid (0.005..0.5) -- matches the 25y pins.
Outputs are CERTIFIED (dps-30 tracked) values for the store.

usage: python3 day029_pin.py <g_15digit> <t_decimal> [npts]
"""
import sys
import numpy as np
from mpmath import mp

mp.mp.dps = 30
LIST = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/" \
       "zeros_T10000000_lmfdb.txt"
GMAX = mp.mpf("10000000")
DG = (mp.mpf("0.005"), mp.mpf("0.01"), mp.mpf("0.02"), mp.mpf("0.05"),
      mp.mpf("0.1"), mp.mpf("0.25"), mp.mpf("0.5"))
BAND_F64 = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/" \
           "zeros_hi31946e6_to_1e9.f64"
REM_HI2 = mp.mpf("1e30")


def logmain25212(s):
    return (s*mp.log(2*mp.pi) - (1 + mp.euler/2)*s - mp.log(2)
            - mp.log(s - 1) - mp.loggamma(s/2 + 1))


def pairlog(g, s):
    r1 = mp.mpc(0.5, g)
    r2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/r1) + mp.log(1 - s/r2) + s/r1 + s/r2)


def R_closed(g, t, d):
    s = mp.mpc(0.5, t)
    w = (((1 + 2*d)/((0.5 + d)**2 + g*g)
          + (1 - 2*d)/((0.5 - d)**2 + g*g) - 1/(0.25 + g*g)))
    num = (0.25 + g*g)*((g - t)**2 + d*d)*((g + t)**2 + d*d)
    den = (g*g - t*t)*((0.5 + d)**2 + g*g)*((0.5 - d)**2 + g*g)
    return num/den*mp.e**(s*w)


def p8_B(t, n):
    a = mp.mpc(0.5, t)
    sabs = abs(a)
    t3 = abs(a*(a + 1)*(a + 2))
    return (mp.mpf("0.5")/mp.sqrt(n)
            + (sabs/12)/n**mp.mpf("3/2")
            + (mp.sqrt(3)/540)*t3/n**mp.mpf("5/2"))


def B_best(t):
    import math as _m
    best = None
    for m in range(1, 41):
        n = max(1, int(round(t/2.0*(0.25 + 0.075*m))))
        b = p8_B(t, mp.mpf(n))
        if best is None or b < best:
            best = b
    return best


def n4(t):
    import math as _m
    return int(_m.ceil(31000000.0 * float(t)**4))


def quad_ext(t, npts=400):
    hi0 = mp.mpf("1e18")
    smp = mp.mpc(0.5, t)

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp/r1) + mp.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

    k = mp.mpf(npts)
    pts = [hi0 * (REM_HI2/hi0)**(mp.mpf(j)/k) for j in range(npts+1)]
    return mp.quad(f, pts)


def main():
    g = mp.mpf(sys.argv[1])
    t = mp.mpf(sys.argv[2])
    npts = int(sys.argv[3]) if len(sys.argv) > 3 else 400

    zs = [mp.mpf(line) for line in open(LIST)]
    assert zs[0] == mp.mpf("14.134725141734694")
    s = mp.mpc(0.5, t)

    dev = None
    for d in DG:
        v = abs(R_closed(g, t, d) - 1)
        dev = v if dev is None else min(dev, v)

    z = mp.zeta(s)
    # main product (14.13, 1e7] at dps-30 (the 25h slow part)
    logmain = logmain25212(s)
    logprod = mp.mpc(0)
    for i, gv in enumerate(zs):
        if gv > GMAX:
            break
        logprod += pairlog(gv, s)
        if i % 2000000 == 0 and i:
            print("main %d/%d" % (i, len(zs)), file=sys.stderr, flush=True)
    # tail discrete float64 (1e7, 1.006346e9] (25x verbatim) + quad
    b = np.fromfile(BAND_F64, dtype="<f8")
    t2 = float(t)*float(t)
    re = np.longdouble(0); im = np.longdouble(0)
    CH = 20000000
    for i in range(0, b.size, CH):
        c = b[i:i+CH]
        g2 = c*c
        A = g2 + 0.25
        re += np.sum(np.log(np.abs(g2 - t2)) - np.log(A) + 0.5/A)
        im += np.sum(float(t)/A)
    hi0 = mp.mpf(repr(float(b[-1])))
    hi1 = mp.mpf("1e18")

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - s/r1) + mp.log(1 - s/r2) + s/r1 + s/r2)
        return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

    k = mp.mpf(npts)
    pts = [hi0 * (hi1/hi0)**(mp.mpf(j)/k) for j in range(npts+1)]
    rem = mp.quad(f, pts)
    tail = (mp.mpf(repr(float(re))) + 1j*mp.mpf(repr(float(im))) + rem)
    K = mp.e**(logmain + logprod + tail)
    Qext = quad_ext(t)
    Kfull = K * mp.e**Qext
    resid = abs(z - K)
    residf = abs(z - Kfull)
    zabs = abs(z)
    B = B_best(t)
    print("g = %s   t = %s   npts = %d   (dps-30)" % (sys.argv[1],
          sys.argv[2], npts))
    print("dev = %.10f  |zeta| = %.10f" % (float(dev), float(zabs)))
    print("E_model = %+.10f   Efull = %+.10f   Re Qext = %+.10f"
          % (float(mp.log(zabs) - mp.re(mp.log(K))),
             float(mp.log(zabs) - mp.re(mp.log(Kfull))), float(mp.re(Qext))))
    print("resid = %.10f   residf = %.10f" % (float(resid), float(residf)))
    print("B_best = %.6f   p8_B(t, n4) = %.6e" % (float(B),
          float(p8_B(t, mp.mpf(n4(t))))))
    print("margin  (25x form, resid)   = %.10f"
          % float(zabs*dev/(B + resid)))
    print("margin2 (25x form, residf)  = %.10f"
          % float(zabs*dev/(B + residf)))
    print("margin3 (t^4 wire, residf)  = %.10f"
          % float(zabs*dev/(p8_B(t, mp.mpf(n4(t))) + residf)))


if __name__ == "__main__":
    main()
