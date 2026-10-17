"""s34n: fresh mpmath (today's code) at sub-wall row heights.
Arg: exact f64 integer t.  Prints one json line: t, logabsz, absz, time."""
import sys, json, time
t = int(sys.argv[1])
import mpmath as mp
mp.mp.dps = 40
z0 = time.time()
z = mp.zeta(mp.mpf('0.5') + 1j*mp.mpf(t))
print(json.dumps(dict(t=t, logabsz=float(mp.log(abs(z))),
                      absz=float(abs(z)), time=time.time()-z0)), flush=True)
