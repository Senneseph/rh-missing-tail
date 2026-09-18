"""Full replay of the day030 walk with index-aligned diff vs LMFDB."""
import sys
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
import numpy as np
import day030_lowt_zeros as M
import mpmath as mpm
mpm.mp.dps = 30
truth = np.loadtxt("zeros_T10000000_lmfdb.txt", dtype=np.float64)
truth = truth[truth <= 1200.0]
print("truth N(1200) =", truth.size, flush=True)
t = mpm.mpf("14.0")
t = mpm.mpf(repr(float(truth[0]) - 1.0))  # start just below gamma_1
# first zero: the walk starts at 14.0 in the script; replicate exactly:
t = mpm.mpf("14.0")
for k in range(824):
    t1 = M.estimate_next(float(t))
    z, res = M.newton_zero_from(float(t), float(t1) - float(t))
    if z <= float(t) + 1e-9:
        print("STALL at t=%.6f (k=%d)" % (float(t), k), flush=True)
        break
    # the walk starts at 14.0 (gamma_1 = 14.1347 sits BELOW its first
    # window [14.3, ...]): walk zero #k aligns with truth[k+1]
    j = k + 1
    if j < truth.size:
        d = z - float(truth[j])
        if abs(d) > 1e-6:
            print("REAL DIVERGENCE at index %d: walk %.10f truth %.10f d=%+.3e"
                  % (j, z, float(truth[j]), d), flush=True)
            print("  walk  prev4:", " ".join("%.6f" % v for v in
                  [float(t)] + [0]*3), flush=True)
            print("  truth ctx:", " ".join("%.6f" % float(v) for v in
                  truth[max(0,j-4):j+4]), flush=True)
            break
    if z > 1200:
        print("beyond 1200 at k=%d (found %d zeros <= 1200)" % (k, k),
              flush=True)
        break
    if k % 50 == 0:
        print("k=%3d z=%.6f d=%.2e (ok)"
              % (k, z, z - float(truth[j])), flush=True)
    t = mpm.mpf(repr(z))
else:
    print("loop exhausted at k=824")
print("DONE-REPLAY", flush=True)
