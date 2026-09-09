#!/usr/bin/env python3
"""Day-003: zero census to T = 1e5  (v3: measured-time-budget design).

Wall-time is MEASURED per evaluation, not guessed (day-3 lesson): at t=1e5,
Z_rs = 65 us, Z_EM = 1.56 ms (benchmarked in this session).  Design budget:
  walk (1e4, 1e5] at dt=0.05:        1.9e6 x 65 us  =   ~2 min
  per new zero: RS bisection to 2e-6 (16 x 65 us ~ 1 ms), then ONE EM check:
    |Z_EM(tc)| < 1e-4  -> accept tc            (~1.6 ms)   [~95% of zeros]
    else               -> EM bisection from the FLIP BRACKET [t-0.05, t],
                          which provably contains a true zero (an RS noise
                          flip of size ~1e-5 can only flip the sign within
                          ~1e-5/|Z'| of a true crossing), 14 steps ~ 22 ms
  total:  ~6 min.  Timeout used: 1200 s (~3.5x measured budget).

Certification: accepted zeros carry a |Z_EM| check; the fallback path asserts
|zeta| < 1e-7.  RVM count check + spacing stats at the end.
"""
import sys
import time

import numpy as np

sys.path.insert(0, ".")
import zeta_core  # noqa: E402

assert zeta_core.selftest(verbose=False), "zeta_core selftest FAILED"

T = 100_000.0
DT = 0.05

low = np.loadtxt("zeros_T10000.txt")
print("high-precision base: %d zeros <= 1e4 (day-001, mpmath-verified)" % len(low))

t0 = time.time()
zs = []
full = 0     # zeros needing the EM bisection path
spur = 0
hid = 0      # hidden crossings found by the midpoint dip-check

def refine(lo_i: float, hi_i: float, zp_i: float, tmark: float):
    """RS bisection to ~2e-6 within [lo_i, hi_i] + EM confirmation; returns t or None."""
    global full, spur
    lo, hi, zp = lo_i, hi_i, zp_i
    for _ in range(16):
        mid = 0.5 * (lo + hi)
        zm = zeta_core.Z_rs(mid)
        if zp * zm <= 0.0:
            hi = mid
        else:
            lo, zp = mid, zm
    tc = 0.5 * (lo + hi)
    zv = abs(zeta_core.Z(tc))
    if zv < 1e-4:
        return tc
    a, b = tc - 1e-4, tc + 1e-4
    za, zb = zeta_core.Z(a), zeta_core.Z(b)
    if za * zb > 0.0:
        a, b = lo_i, hi_i
        za, zb = zeta_core.Z(a), zeta_core.Z(b)
        if za * zb > 0.0:
            spur += 1
            print("  no EM sign change anywhere near the RS flip at t = %.6f (|Z(tc)|= %.2e) -- skipped" % (tc, zv))
            return None
    for _ in range(26):
        mid = 0.5 * (a + b)
        zm = zeta_core.Z(mid)
        if za * zm <= 0.0:
            b = mid
        else:
            a, za = mid, zm
    t0_ = 0.5 * (a + b)
    zv2 = abs(zeta_core.zeta(0.5 + 1j * t0_))
    assert zv2 < 1e-7, "EM-refined crossing not a zero: |zeta| = %.2e at t = %.6f" % (zv2, t0_)
    full += 1
    return t0_

t = 10_000.0
zprev = zeta_core.Z_rs(t)
nsteps = 0
while t <= T:
    t += DT
    z = zeta_core.Z_rs(t)
    a_i, b_i = t - DT, t  # the walk interval
    nsteps += 1
    if nsteps % 200_000 == 0:
        print("  ... t = %.0f  (%d new zeros, %d hidden, %.0f s)" % (t, len(zs), hid, time.time() - t0))
    if zprev * z < 0.0:
        r = refine(a_i, b_i, zprev, t)
        if r is not None:
            zs.append(r)
    else:
        # midpoint dip-check: a TWIN pair (both zeros inside this interval,
        # GOE level repulsion makes gap < 0.05 rare but real: ~20 in this
        # range) leaves a +/-/+ signature; if the midpoint sits between the
        # pair, one of zprev/zm or zm/z flips sign here.
        zm = zeta_core.Z_rs(0.5 * (a_i + b_i))
        if zprev * zm < 0.0 or zm * z < 0.0:
            # sub-walk the interval at dt = 0.0125
            st = a_i
            szprev = zprev
            while st < b_i - 1e-12:
                st2 = min(st + DT / 4.0, b_i)
                sz = zeta_core.Z_rs(st2)
                if szprev * sz < 0.0:
                    r = refine(st, st2, szprev, st2)
                    if r is not None:
                        zs.append(r)
                        hid += 1
                szprev = sz
                st = st2
    zprev = z

allz = np.unique(np.concatenate([low, np.array(zs)]))
np.savetxt("zeros_T100000.txt", allz)
print("walk (1e4, 1e5]: %d new zeros in %.0f s (%d via EM bisection, %d hidden caught, %d skipped)" % (len(zs), time.time() - t0, full, hid, spur))
print("total N(1e5) = %d    (first: %.6f, last: %.6f)" % (len(allz), allz[0], allz[-1]))

# per-block deficit map (a block deficit > 5 flags a hole in the walk)
print("\nblock deficit map (dN_RVM - dN_measured per 5000; S fluctuation is O(1-3) per block):")
prevv = 0.0
for kb in range(int(10_000 // 5000), int(T // 5000) + 1):
    lo_b, hi_b = kb * 5000.0, min((kb + 1) * 5000.0, T)
    nm_b = int(((allz >= lo_b) & (allz < hi_b)).sum())
    xh, xl = hi_b / (2 * np.pi), lo_b / (2 * np.pi)
    dr_b = (xh * np.log(xh) - xh) - (xl * np.log(xl) - xl)
    print("  %7.0f:  %6d   %+.1f" % (lo_b, nm_b, dr_b - nm_b))

# RVM consistency at both endpoints
for TT, NN in ((10_000.0, int((allz <= 10_000.0).sum())), (100_000.0, len(allz))):
    trm = TT / (2 * np.pi)
    mainv = trm * np.log(trm) - trm - 0.125
    print("RVM at T = %.0e:  main = %.3f  measured N = %d  S(T) implied = %+.4f"
          % (TT, mainv, NN, NN - mainv))

g = np.diff(allz)
sg = g * (np.log(allz[:-1] / (2 * np.pi)) / (2 * np.pi))
print("\nspacing stats (%d gaps):" % len(g))
print("  mean gap = %.6f (top-of-range prediction %.6f)" % (g.mean(), 2 * np.pi / np.log(T / (2 * np.pi))))
print("  min gap  = %.6f at t = %.3f   (a gap < 0.05 could hide twins from the 0.05 grid)" % (g.min(), allz[np.argmin(g)]))
print("  max gap  = %.6f at t = %.3f" % (g.max(), allz[np.argmax(g)]))
print("  scaled mean = %.5f   scaled min/max = %.4f / %.4f" % (sg.mean(), sg.min(), sg.max()))

print("\ncorridor (scaled-gap deviation) stats:")
for c in (0.25, 0.5, 1.0):
    lo_n = int((sg < c).sum())
    hi_n = int((sg > 1.0 / c).sum())
    print("  c = %.2f: gaps < c-mean: %5d (%.2f%%)   gaps > 1/c-mean: %5d (%.2f%%)"
          % (c, lo_n, 100.0 * lo_n / len(sg), hi_n, 100.0 * hi_n / len(sg)))
