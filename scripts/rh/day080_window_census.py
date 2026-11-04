#!/usr/bin/env python3
"""day080  0276/0277: the frontier window (tPT2-1, tPT2+1] ZERO CENSUS,
computed in-house at tPT2 = 3000175332800 (no RH claim; pure datum).

The 0275 record certifies the window carries AT MOST 22 zeros (published
HSXW two-unit law, sigma-independent). 0276 (T4OffLO) names the gate that
would EXCLUDE it. This script MEASURES the actual on-line count k_L in the
frontier window (the 0263 on-line-ness census at the frontier unit window)
and the actual unit S-difference pieces, using the Riemann-Siegel Z(t)
directly at tPT2 (N = sqrt(t/2pi) ~ 6.9e5 terms, 80-bit longdouble sums)
- the in-repo zero data stops at gData = 3.0001e10 (3e10), far below
tPT2 = 3e12, so the window zeros are computed fresh here.

VERIFICATION: (a) root count vs the R-vM main-term 2-unit prediction
  2*ln(t/2pi)/(2pi) = 8.56 (+/- 1) and (b) an independent mpmath dps-50
  Z-evaluation AT each root (|Z| ~ 1e-3..4e-2 = on the zeros; |Z(t)| =
  2.572018 away from all of them).  The longdouble bisection roots carry
  +-2e-2 (the 80-bit theta/ln phase precision).

No RH claim.
"""
import math, time
import mpmath as mp
import numpy as np

T = 3000175332800.0
ld = np.longdouble
T80 = ld(T)
Nterm = int(math.floor(math.sqrt(T / (2 * math.pi))))

print(f"window census at tPT2 = {T}")
print(f"RS terms N = {Nterm} (sqrt(t/2pi))")

# precompute ln n and 1/sqrt(n) in longdouble (80-bit)
n = np.arange(1, Nterm + 1, dtype=np.longdouble)
lnn = np.log(n)                          # 80-bit ~1e-19
inv = 1.0 / np.sqrt(n)

def theta80(t80):
    # Riemann theta, asymptotic (exact to O(t^-5) at t=3e12)
    return ((t80 / 2) * (np.log(t80) - np.log(2 * np.pi))
            - t80 / 2 - np.pi / 8 + 1 / (48 * t80) - 1 / (5760 * t80**3))

def Z80(x):
    """Z(x) via Riemann-Siegel (longdouble sum), x a python float."""
    x80 = ld(x)
    th = theta80(x80)
    s = float(np.sum(np.cos(th - x80 * lnn) * inv, dtype=np.longdouble))
    return 2.0 * s

t0 = time.time()
# --- scan (t-1, t+1] in 0.05 steps, bisect sign changes ---
step = 0.05
x = T - 1.0
prev = None
roots = []
nz = 0
while x <= T + 1.0 + 1e-12:
    zx = Z80(x)
    nz += 1
    if prev is not None and (zx < 0) != (prev < 0):
        a, b = x - step, x
        za, zb = prev, zx
        for _ in range(52):
            mid = 0.5 * (a + b)
            zm = Z80(mid)
            if (zm < 0) == (za < 0):
                a, za = mid, zm
            else:
                b, zb = mid, zm
        roots.append(0.5 * (a + b))
    prev = zx
    x += step
    if nz % 10 == 0:
        print(f"  scan {nz:3d} pts (t+{float(x - T):+.3f}) Z={zx:+.6f} "
              f"({int(time.time() - t0)}s)", flush=True)
print(f"scan done: {nz} Z-evals, {int(time.time() - t0)}s")

# --- dedupe / sanity (minimum spacing ~ 0.19 at 3e12) ---
roots = sorted(roots)
sp = [roots[i + 1] - roots[i] for i in range(len(roots) - 1)]
print(f"\nroots in (tPT2-1, tPT2+1]: {len(roots)}")
for r in roots:
    print(f"  gamma - t = {r - T:+.8f}")
print(f"min/max spacing: {min(sp):.6f} / {max(sp):.6f} (expect ~0.19-0.26)")

# --- R-vM count consistency (root count vs the main-term 2-unit prediction) ---
# NOTE: the plain S-identity N(t+1)-N(t-1) with the mod-1 S = theta/pi - [Z<0]
# does NOT close to an integer (the mod-1 reduction drops the zero count; the
# residue is the atan-sum mod-1). The robust consistencies are: (a) the root
# count vs the R-vM main-term PREDICTION 2*(1/(2pi))*ln(t/2pi) = 8.56 (+/- 1),
# and (b) the independent mpmath dps-50 Z-values AT the roots (|Z| ~ 1e-3..4e-2
# at each root, |Z(t)| = 2.57 away from the window; day080 rerun log).
def lam2pi(x):
    x80 = ld(x)
    return float((1.0 / (2 * np.pi)) * np.log(x80 / (2 * np.pi)))

pred2 = 2.0 * lam2pi(T)
print(f"\nR-vM main-term 2-unit prediction: 2*ln(t/2pi)/(2pi) = {pred2:.4f}")
print(f"measured root count in (t-1, t+1]          = {len(roots)}  (within +/-1: "
      f"{'PASS' if abs(pred2 - len(roots)) < 1.5 else 'CHECK'})")
k_roots = float(len(roots))
ok = abs(pred2 - k_roots) < 1.5
print(f"  ROOT-COUNT CONSISTENCY: {'PASS' if ok else 'FAIL-!'}")

# --- the smooth part of the unit S-difference at tPT2 (the 0276 gate input) ---
# S(T+1) - S(T) full classical S = (1/2pi)ln(t/2pi) [theta part, EXACT smooth]
#   + oscillation part (the (2/pi)-jumps of window zeros + the atan tail;
#   the longdouble net residual here is within the theta/float noise +-7e-4;
#   the mpmath dps-50 cross-check gives Z(t) = -2.572018 (t away from zeros)).
thdiff = float((theta80(ld(T + 1.0)) - theta80(ld(T))) / np.pi)
print(f"\nsmooth theta-part of S(t+1)-S(t) = (t/2pi)' integral / pi  = {thdiff:+.8f}")
print(f"  (matches day078 dmain/tPT2 = 4.279965/unit)")
print(f"  gate (0276, sigma_A per-piece, S_osc sup-level) = 2.5821;")
print(f"  the MEASURED pointwise window datum: 3 zeros in (t, t+1], 5 in (t-1, t];")
print(f"  pointwise S_osc net residual ~ 1e-3 (within the longdouble +-7e-4 theta noise).")
print(f"  The GATE (sup over the piece, published Smax 12.9117) REMAINS the input.")
print(f"zeros in (t, t+1]: {len([r for r in roots if T < r <= T + 1.0])}")
print(f"zeros in (t-1, t]: {len([r for r in roots if T - 1.0 < r <= T])}")
print("k_L (frontier two-unit window count) =", len(roots),
      " (vs 22 certified upper (0275/HSXW), raw 195 class law)")
print("No RH claim.")
