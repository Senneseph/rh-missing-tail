"""Per-zero miss diagnosis (day030): for EACH LMFDB zero rho_i in
(0, 1200], replicate newton_zero_from's WINDOW construction (start
from the true previous zero, same sp estimate, same N=61 grid,
width max(6, 2.5*sp)) and report whether the sign-change OR lobe
trigger would fire for rho_i (with a 0.05 tolerance in t).
Prints ONLY the diagnostics: misses and, for each miss, the grid
values in [+/- 0.15 of the zero] so the mechanism is visible."""
import sys, math
sys.path.insert(0, '.')
import numpy as np
import mpmath as mpm
import day030_lowt_zeros as M

mpm.mp.dps = 30

def sp_est(t):
    if t < 50:
        return 9.0
    a = 1.0 + 1.07704*math.log(math.log(t/(2*math.pi+1e-30)))
    a = max(a, 1.2)
    return 2*math.pi/a

lm = np.loadtxt("zeros_T10000000_lmfdb.txt", dtype="<f8")
lm = lm[lm <= 1200.0]
n = lm.size
print("LMFDB zeros in (0, 1200]:", n, flush=True)
misses = []
for i in range(1, n):
    t_cur = float(lm[i-1])
    rho  = float(lm[i])
    # window exactly as the walker builds it:
    t0 = mpm.mpf(repr(t_cur))
    sp = mpm.mpf(repr(float(M.estimate_next(t_cur) - t_cur)))
    wid = 2.5*sp
    if wid < mpm.mpf("6.0"):
        wid = mpm.mpf("6.0")
    lo = t0 + 0.3
    hi = t0 + wid
    if mpm.mpf(repr(rho)) < lo or mpm.mpf(repr(rho)) > hi:
        misses.append((rho, "WINDOW", "zero outside (lo hi] = (%.4f %.4f]" % (float(lo), float(hi)), []))
        continue
    N = 61
    pts = [lo + (hi-lo)*mpm.mpf(j)/(N-1) for j in range(N)]
    vals = [M._imz(x) for x in pts]
    # does any interval straddle rho with opposite signs?
    found_sign = False
    for k in range(N-1):
        a, b = float(pts[k]), float(pts[k+1])
        if a < rho < b and vals[k]*vals[k+1] < 0:
            found_sign = True
            break
    # lobe trigger: min endpoint |Im| < 0.02 in the straddling interval(s)
    found_lobe = False
    ctx = []
    for k in range(N-1):
        a, b = float(pts[k]), float(pts[k+1])
        if a - 0.15 < rho < b + 0.15:
            ctx.append("%.4f  Im=%+.4e" % (a, float(vals[k])))
        if a < rho < b and min(abs(vals[k]), abs(vals[k+1])) < mpm.mpf("0.02"):
            found_lobe = True
    if not found_sign and not found_lobe:
        misses.append((rho, "NO-TRIGGER", "no sign change / lobe trigger in straddling interval", ctx))
    elif not found_sign and found_lobe:
        misses.append((rho, "SIGN-ONLY-LOBE", "lobe fires but NOT the sign change (suspect)", ctx))
    if (i % 100) == 0:
        print("  scanned %d/%d" % (i, n-1), flush=True)
print("=== %d problematic zeros ===" % len(misses), flush=True)
for rho, kind, msg, ctx in misses:
    print("\n%.12f  [%s]  %s" % (rho, kind, msg), flush=True)
    for line in ctx:
        print("   ", line, flush=True)
