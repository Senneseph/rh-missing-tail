"""Residual verification of the 813-zero low-t list (independent
|zeta| check at dps-30): every stored t must sit at an mpmath
noise-floor point (~1e-11..1e-14); a corrupted value shows |zeta|
~ O(1).  Gate: |zeta| < 1e-8 (7 orders above the noise floor)."""
import sys
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
import numpy as np
import mpmath as mpm
mpm.mp.dps = 30
a = np.load('/home/jsmille/Projects/rh-missing-tail/scripts/rh/lowt/zeros_0_to_1p2e3.f64')
worst = (0.0, -1.0)
fails = []
for i, t in enumerate(a):
    res = abs(mpm.zeta(mpm.mpc(0.5, mpm.mpf(repr(float(t))))))
    if res > worst[0]:
        worst = (float(res), float(t))
    if res >= mpm.mpf("1e-8"):
        fails.append((float(t), float(res)))
    if (i + 1) % 100 == 0:
        print("  checked %d/813" % (i + 1), flush=True)
print("residual check: %d/813 pass (gate 1e-8)" % (813 - len(fails)), flush=True)
print("worst |zeta| = %.2e at t = %.6f" % worst, flush=True)
for t, r in fails:
    print("  FAIL t=%.6f |zeta|=%.2e" % (t, r), flush=True)
assert not fails, "residual gate failed"
print("RESID GATE PASS (all 813 at the mpmath noise floor)", flush=True)
