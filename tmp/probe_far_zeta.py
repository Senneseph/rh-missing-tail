import sys, time
from mpmath import mp, mpc, mpf, workdps

which, tstr, dps = sys.argv[1], sys.argv[2], int(sys.argv[3])
with workdps(dps):
    v = mpc(0.5, mpf(tstr))
    t0 = time.time()
    zr = mp.zeta(v)
    trs = time.time() - t0
    print("rs-auto dps=%d t=%-8s |zeta|=%s (%.1f s)" % (dps, tstr, mp.nstr(abs(zr), 10), trs), flush=True)
    if which in ("em", "both"):
        t0 = time.time()
        ze = mp.zeta(v, method='euler-maclaurin')
        tem = time.time() - t0
        print("EM      dps=%d t=%-8s |zeta|=%s (%.1f s) diff=%s"
              % (dps, tstr, mp.nstr(abs(ze), 10), tem,
                 mp.nstr(abs(zr) - abs(ze)), 3), flush=True)
