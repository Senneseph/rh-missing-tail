import sys, os, time
sys.path.insert(0, "/home/jsmille/Projects/rh-missing-tail/scripts/rh")
import os as _os
import day034_h1cert as C
T = C.TH.tail()
x = 1.0e9
g = C.nearest_zero(T, x)
t0 = time.time()
p = C.cert_point(T, g + 0.5, g)
dt = time.time() - t0
print("g = %.4f  t = %.4f" % (g, g + 0.5))
for k in ("mnew", "mcert", "residf", "zeta", "dev", "Efull", "Bexp", "Bph",
          "Bz", "Bdev", "Btail_re", "Btail_im", "Bprod_re", "Bprod_im",
          "Bqrem", "Bqext", "dmin"):
    print("  %-10s = %.8g" % (k, p[k]))
print("  nlt = %d  flag = %s  dtime = %.1f s" % (p["nlt"], p["flag"], dt))
