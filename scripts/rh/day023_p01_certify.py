# Day-023 — P0.1: dps-30 CERTIFIED re-pin of the closure on the 31-digit list.
# Recomputes the witness margin at dps=30 from machine-evaluated parts:
#   margin = |zeta(1/2+it)| * min_d |R(g,d,t)-1| / (B_best(t) + |zeta - K(t)|)
# with K = e^{logmain25212(s)} * prod_{zeros<=1e7} pairlog * tail(1e7,inf),
# all at dps-30.  Inputs: g = the exact LMFDB zero (15 printed digits),
# t = the scan-grid witness (decimal).  This moves the pin MEASURED -> CERTIFIED.
import numpy as np, math, time, sys
from mpmath import mp

LIST = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_T10000000_lmfdb.txt"
GMAX = mp.mpf("10000000")
DG = (mp.mpf("0.005"), mp.mpf("0.01"), mp.mpf("0.02"), mp.mpf("0.05"),
      mp.mpf("0.1"), mp.mpf("0.25"), mp.mpf("0.5"))


def load_g(exact_str):
    return mp.mpf(exact_str)


log = lambda m: sys.stderr.write(m + "\n")


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
            + (sabs/12)/mp.sqrt(n**3)
            + (mp.sqrt(3)/540)*t3/mp.sqrt(n**5))


def B_best(t):
    best = None
    for m in range(1, 41):
        n = max(1, int(round(t/2.0*(0.25 + 0.075*m))))
        b = p8_B(t, n)
        if best is None or b < best:
            best = b
    return best


def tail_int(s, G):
    t = abs(mp.im(s))
    split = max(G, 2*t)
    f = lambda g: pairlog(g, s)*(mp.log(g/(2*mp.pi))/(2*mp.pi))
    return mp.quad(f, [G, split, mp.inf])


def main():
    label, gstr, tstr = sys.argv[1], sys.argv[2], sys.argv[3]
    mp.dps = 30
    t = mp.mpf(tstr)
    g = load_g(gstr)
    s = mp.mpc(0.5, t)
    z = mp.zeta(s)
    zabs = abs(z)
    dev = None
    for d in DG:
        v = abs(R_closed(g, t, d) - 1)
        dev = v if dev is None else min(dev, v)
    B = B_best(t)
    # the dps-30 product
    gammas = np.loadtxt(LIST, dtype=np.float64)
    n = int(np.searchsorted(gammas, 10000000.0))
    t0 = time.time()
    acc = mp.mpf(0)
    for i in range(n):
        acc += pairlog(mp.mpf(repr(float(gammas[i]))), s)
        if (i + 1) % 2000000 == 0:
            rate = (i + 1)/(time.time() - t0)
            log("[%s] %d/%d zeros  %.0f/s  eta %.0f s"
                % (label, i + 1, n, rate, (n - i - 1)/rate))
    # CORRECTED tail (day-023 25b): exact discrete sum over actual zeros
    # (1e7, 3e7] (float64, ~1e-15) + dps-30 density quad (3e7, 1e12) +
    # analytic (1e12, inf) t^2 bound.  Replaces the old mp.quad([G, split, inf])
    # which systematically under-integrated the near mass.
    import day023_taildiscrete as td
    td.build_cache()
    disc, rem, bound = td.tail_discrete(s)
    tail = (mp.mpf(disc.real) + mp.mpc(0, mp.mpf(disc.imag)) + rem)
    K = mp.e**(logmain25212(s) + acc + tail)
    resid = abs(z - K)
    margin = zabs*dev/(B + resid)
    print("P0.1 CERTIFIED  [%s]" % label)
    print("  g      = %s" % gstr)
    print("  t      = %s" % tstr)
    print("  |zeta| = %s" % mp.nstr(zabs, 20))
    print("  dev(min_d |R-1|) = %s" % mp.nstr(dev, 20))
    print("  B_best = %s" % mp.nstr(B, 20))
    print("  resid  = %s" % mp.nstr(resid, 20))
    print("  MARGIN = %s   (dps-30 certified)" % mp.nstr(margin, 12))
    print("  E(log|z| - Re log K) = %s"
          % mp.nstr(mp.log(zabs) - mp.re(mp.log(K)), 12))
    print("  elapsed %.0f s" % (time.time() - t0))


if __name__ == "__main__":
    main()
