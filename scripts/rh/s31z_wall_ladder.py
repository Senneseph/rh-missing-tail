"""s31z wall ladder: dps-ladder zeta probe past the dps-40 wall.

The s30 census and the fresh-wall probe established the dps-40 RS-zeta
wall on this 124 GB machine at t ~ 3e19 (fresh process OOM-killed at
114.6 GB on the 3e19 call; 9e18 succeeded at 73.7 GB peak, 63 min).

Hypothesis: mpmath RS-zeta memory scales ~ t x dps (per-element mpf
size grows with working precision), so a LOWER-precision ladder
(dps 15/20/30) may fit where dps-40 does not.  The dps-15 zeta is
USABLE for the census channels: log|zeta| is an O(10) correction
against 1e19-scale channels, and the f64 sum-match tolerance at
these heights is ~0.01 absolute (dps-15 gives ~1e-13).

Protocol: one process per height; dps ascending within the process
(low first, so a late OOM still leaves the early rows recorded);
peak RSS from ru_maxrss.  No cache, no other heavy resident.
"""
import sys
import time
import resource
import mpmath as mp

def rss_gb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1e6

# heights: absolute t, the s30 target rows past 3e8G
HEIGHTS = (3.000104599998198e19, 9.000313799994592e19,
           3.000104599998198e20)

def ladder_for(t, dps_list):
    for dps in dps_list:
        mp.mp.dps = dps
        t0 = time.time()
        try:
            z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(t))))
            lz = mp.chop(mp.log(abs(z)))
            print("t=%.6e  dps%02d  logzeta=%+.8f  (%.1f s)  peak=%.1f GB"
                  % (t, dps, float(lz), time.time() - t0, rss_gb()),
                  flush=True)
        except MemoryError:
            print("t=%.6e  dps%02d  OOM  peak=%.1f GB"
                  % (t, dps, rss_gb()), flush=True)
        except Exception as e:
            print("t=%.6e  dps%02d  ERR %r  peak=%.1f GB"
                  % (t, dps, rss_gb()), flush=True)
        mp.mp.dps = 15

if __name__ == "__main__":
    which = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    if which == 1:
        # the 3e19 row (s30 1e9G): the FULL ladder
        ladder_for(HEIGHTS[0], [15, 20, 30, 40])
    elif which == 2:
        # the 9e19 row (s30 3e9G): cheap ladder only
        ladder_for(HEIGHTS[1], [15, 20])
    else:
        # the 3e20 row (s30 1e10G): cheapest only
        ladder_for(HEIGHTS[2], [15])
    print("s31z wall ladder which=%d done (peak=%.1f GB)"
          % (which, rss_gb()), flush=True)
