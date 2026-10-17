import sys, time, math
sys.path.insert(0, '/home/jsmille/.local/lib/python3.12/site-packages')
from mpmath.libmp.gammazeta import zetasum_sieved

t = 15000522999990989000  # 5e8G f64 as exact integer
a, n = 1, 10**7
res = {}
for wp in (60, 77, 100, 143, 200, 300, 400):
    sim = t << wp          # to_fixed(t, wp)
    t0 = time.time()
    re, im = zetasum_sieved(False, 0, sim, a, n, wp)
    s2 = float(2 ** wp)
    res[wp] = (float(re) / s2, float(im) / s2)
    print("wp=%3d  S1_partial(1..1e7) = (%.14f, %.14f)  %.1f s"
          % (wp, res[wp][0], res[wp][1], time.time()-t0), flush=True)
ref = res[400]
print("=== diffs vs wp=400 reference (%.14f, %.14f) ===" % ref)
for wp in (60, 77, 100, 143, 200, 300):
    dr = res[wp][0] - ref[0]
    di = res[wp][1] - ref[1]
    print("wp=%3d  dS1 = (%.3e, %.3e)  |dS1| = %.3e" % (wp, dr, di, math.hypot(dr, di)))
