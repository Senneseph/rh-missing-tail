#!/usr/bin/env python3
"""day024 (25x) — (1e7, 1e9] band scan on ACTUAL zeros to 1.006346e9.

Same protocol as day023_straddle_hi.py (25f): same kernel, same margin
formula   margin(t) = |zeta| * min_d |R-1| / (B(t) + |zeta - K|) ,
same t-grid (t = g + k/2, k in -12..12 \\ {0}), same dev grid (496 d's),
same per-t dps-30 quadrature (REM 1e18, 200 pts; reissue 400), same 5e3
real-zero gate.  ONLY difference: the tail's discrete section now covers
(1e7, 1.0063459998e9] with 2.85e9 ACTUAL zeros (day024_tail_hi1e9) instead
of (1e7, 3e7]; the density quad covers (G_LAST, 1e18].

Effect (25f reading, verbatim): the 9 NOMINAL rows (3.75e7..1e9) become
REAL rows -- the near-t zero structure that the density quad could not
resolve (spacing ~0.3 vs node spacing ~1e6-1e9) is now exact.  The 8 old
real rows are re-issued for regression (they must reproduce 25f to
kernel noise; the 3.1e7 row also picks up the (3e7, 3.1946e7] zeros that
the old cache stopped before).

Screening level (float64 discrete + dps-30 quad), per 25c/25f discipline.
"""
import mpmath as mp
mp.mp.dps = 30
import os
import numpy as np
import concurrent.futures as cf

import day023_p11c_1e7 as M
import day023_taildiscrete as td
import day024_tail_hi1e9 as TH

DG = [mp.mpf(k)/1000 for k in range(5, 501)]

CANDS = [(1.0e7, "1e7"), (1.2e7, "1.2e7"), (1.5e7, "1.5e7"),
         (1.8e7, "1.8e7"), (2.0e7, "2e7"), (2.4e7, "2.4e7"),
         (2.8e7, "2.8e7"), (3.1e7, "3.1e7"),
         (3.75e7, "3.75e7"), (5.0e7, "5e7"), (7.5e7, "7.5e7"),
         (1.0e8, "1e8"), (1.5e8, "1.5e8"), (2.5e8, "2.5e8"),
         (4.0e8, "4e8"), (6.0e8, "6e8"), (1.0e9, "1e9")]


def real_zero_at(x):
    T = TH.tail()
    for arr in (T.cache_lo, T.b):
        i = int(np.searchsorted(arr, x))
        cands = [float(arr[j]) for j in range(max(0, i-2), min(arr.size, i+3))]
        gz = min(cands, key=lambda v: abs(v-x))
        if abs(gz - x) < 5e3:
            return gz
    return None


def margin_at(t, g, npts):
    s = mp.mpc(0.5, t)
    gmp = mp.mpf(repr(float(g)))
    tmm = mp.mpf(repr(float(t)))
    dev = None
    for d in DG:
        v = abs(M.R_closed(gmp, tmm, d) - 1)
        dev = v if dev is None else min(dev, v)
    z = mp.zeta(s)
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    T = TH.tail()
    re, im = T.pairlog_sum(float(t))          # float64 discrete, (1e7, G_LAST]
    rem = T.quad_rem(float(t), npts)          # dps-30, (G_LAST, 1e18]
    bound = T.bound_rem(float(t))             # (1e18, inf), reported only
    tail = mp.mpf(repr(re)) + 1j*mp.mpf(repr(im)) + rem
    K = mp.e**(main + mp.mpf(repr(float(la))) + 1j*mp.mpf(repr(float(ar)))
               + tail)
    B = M.B_best(tmm)
    resid = abs(z - K)
    margin = abs(z)*dev/(B + resid)
    E = mp.log(abs(z)) - mp.re(mp.log(K))
    return {"margin": margin, "t": t, "g": g, "zeta": abs(z), "resid": resid,
            "B": B, "dev": dev, "E": E, "bound": bound}


def scan_one(x, label):
    gz = real_zero_at(x)
    real = gz is not None
    g = gz if real else float(x)
    best = None
    for k in range(-12, 13):
        if k == 0:
            continue   # pole column (own-height detector regime, S2b/C1a)
        t = mp.mpf(repr(float(g))) + mp.mpf(k)/2
        r = margin_at(t, g, 200)
        if best is None or r["margin"] > best["margin"]:
            best = r
    best = margin_at(best["t"], float(g), 400)   # reissue, 400 pts
    best["label"] = label + ("" if real else " exp")
    best["is_real"] = real
    return best


def run():
    work = int(os.environ.get("WORKERS", "32"))
    # parent pre-loads the 2.85e9-zero discrete cache; fork-COW shares it
    # read-only with the workers (22.7 GB physical, not per-worker).
    T = TH.tail()
    print("25x scan: 17 windows, discrete (1e7, %.6f] = %d zeros (actual), "
          "quad (%.3e, 1e18] dps-30, %d workers"
          % (T.G_LAST, T.cache_lo.size + T.b.size, T.G_LAST, work), flush=True)
    with cf.ProcessPoolExecutor(max_workers=work) as ex:
        futs = [ex.submit(scan_one, x, lab) for (x, lab) in CANDS]
        results = [fu.result() for fu in futs]
    results.sort(key=lambda r: float(r["t"]))
    print("%-10s %10s %9s %9s %9s %9s %9s %9s" %
          ("g", "t_best", "margin", "def_c", "resid", "zeta", "dev", "E"))
    print("# bound(1e18,inf) column added (reported, not in K)")
    print("%-10s %10s %9s %9s %9s %9s %9s %9s  %-9s %s" %
          ("g", "t_best", "margin", "def_c", "resid", "zeta", "dev", "E",
           "bound", "label"))
    for r in results:
        deff = r["B"] + r["resid"]
        print("%-10.4f %10.4f %9.4f %9.5f %9.5f %9.4f %9.4f %9.6f  %-9.3f %s"
              % (float(r["g"]), float(r["t"]), float(r["margin"]),
                 float(deff), float(r["resid"]), float(r["zeta"]),
                 float(r["dev"]), float(r["E"]), float(r["bound"]),
                 r["label"]))


if __name__ == "__main__":
    run()
