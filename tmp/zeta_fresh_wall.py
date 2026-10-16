import time, resource, sys
import mpmath as mp
def rss_gb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1e6
for t in (9.000313799994592e18, 3.000104599998198e19, 9.000313799994592e19, 3.000104599998198e20):
    mp.mp.dps = 40
    t0 = time.time()
    try:
        z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(t))))
        print("t=%.6e  dps40  logzeta=%+.8f  (%.1f s)  peak=%.1f GB"
              % (t, mp.chop(mp.log(abs(z))), time.time()-t0, rss_gb()), flush=True)
    except MemoryError:
        print("t=%.6e  dps40  OOM  peak=%.1f GB" % (t, rss_gb()), flush=True)
    except Exception as e:
        print("t=%.6e  dps40  ERR %r  peak=%.1f GB" % (t, e, rss_gb()), flush=True)
    mp.mp.dps = 15
print("fresh-wall probe done", flush=True)
