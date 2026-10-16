"""s31z2: the 5e8G zeta-channel probe (t = 5e8 * G_LAST ~ 1.5e19).

Model (locked by the wall probe + the s31z ladder, 0085/0086):
mpmath RS-zeta peak memory ~ N x elem, N = sqrt(t / 2 pi), with
elem ~ 53.5 B at dps-15 (calibrated: 3e19/dps-15 OOM'd at
total-vm 117 GB) and ~ 61.6 B at dps-40 (calibrated: 9e18 peak
73.7 GB at N = 1.197e9).  t  =  1.5000523e19  gives
N  =  1.545e9, so:  dps-15 ~ 83 GB,  dps-20 ~ 87 GB,  dps-30
~ 91 GB,  dps-40 ~ 95 GB  -  all  UNDER  the  ~  110 GB
available,  with  ~  15 GB  headroom.  (The  3e19  row  needed
~  117 GB  at  dps-15  -  the  OOM  -  so  5e8G  is  the  LAST
reachable  height  on  this  machine  at  ANY  mpmath
precision.)

PROTOCOL:  ONE  FRESH  PROCESS  PER  (height,  dps)  -  the
dps  is  argv[1].  Fresh  per  call  because  pymalloc
arenas  are  NOT  returned  to  the  OS  between  calls  (a
single  multi-dps  process  would  accumulate  live  RSS  and
turn  the  later  calls  of  the  ladder  into  an  OOM
lottery).  A  supervisor  runs  dps  15,  20,  30,  40  in
fresh  processes;  each  lands  or  OOMs  independently  and
is  recorded.  The  dps-40  value  is  the  census  working
channel;  dps-15/20/30  are  independent  precision  crosses.

If  the  dps-40  call  lands:  the  5e8G  census  row
(t  =  1.5e19,  t/G  =  5e8)  becomes  reachable  via  the
staggered  protocol  (stream  process  +  this  zeta  value
+  exact  f64  merge),  extending  the  verified  extreme
boundary  9e18  to  1.5e19  (t/g0  =  0.5  at  the
best-fit  g0  ~  1e9G  -  the  best  row  reachable  on
this  machine,  still  short  of  the  3e19  =  1e9G
wall  row  that  would  break  the  B7  degeneracy).  If  it
OOMs:  the  boundary  stays  at  9e18  and  the  far-data
track  closes  at  its  leveraged  wall  on  this  hardware.
No  RH  claim.
"""
import sys
import time
import resource

sys.path.insert(0, ".")
import s9_dk_above_g as S
import mpmath as mp

def rss_gb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / 1e6

if __name__ == "__main__":
    dps = int(sys.argv[1]) if len(sys.argv) > 1 else 40
    t = S.G_LAST * 5e8
    N = (t / (2.0 * 3.141592653589793)) ** 0.5
    print("t = %.17e  (t/G = %.6e,  N_terms = %.4e)  running dps=%d"
          % (t, t / S.G_LAST, N, dps), flush=True)
    mp.mp.dps = dps
    t0 = time.time()
    try:
        z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(t))))
        lz = mp.chop(mp.log(abs(z)))
        print("t=%.6e  dps%02d  logzeta=%+.10f  (%.1f s)  peak=%.1f GB"
              % (t, dps, float(lz), time.time() - t0, rss_gb()),
              flush=True)
    except MemoryError:
        print("t=%.6e  dps%02d  OOM  peak=%.1f GB"
              % (t, dps, rss_gb()), flush=True)
    except Exception as e:
        print("t=%.6e  dps%02d  ERR %r  peak=%.1f GB"
              % (t, dps, rss_gb()), flush=True)
    print("s31z2 dps=%d done (peak=%.1f GB)" % (dps, rss_gb()),
          flush=True)
