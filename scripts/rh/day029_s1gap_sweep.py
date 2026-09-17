#!/usr/bin/env python3
"""day029 -- S1 corrected FULL SWEEP (post-verdict-A).

The 25x[7] window grid (3.9e7..5e8, 26 windows, verbatim) + 2.5e8,
4e8, 6e8, 8e8, 1e9 (5 extension points) = 31 windows, same protocol as
day024_band1e9_sweep.py (best-straddle max over t = g + k/2, k =
-12..12 \ {0}, reissue 200 -> 400 pts), with the day029 corrections:
  K horizon 1e18 -> 1e30 (the (1e18, 1e30] log-quad folded in),
  < side: margin_old = |z| dev / (B_best + residf)   [regression, 25x form]
          margin_new = |z| dev / (p8_B(t, n4) + residf) [t^4 wire, V2]
Per window: the best-straddle (max over the 25 t's) of EACH margin +
residf/Efull at the best point.

PRE-REGISTERED READING:
  (A-1) margin_new >= 1.0 at ALL 31 windows -> the S1 pointwise squeeze
       is SOUND across (3.9e7, 1e9] (the data extent) at screen level:
       certified [1e3, 1e6] (25f/v3 records) + screened-SOUND
       [1e6, 1e9]; the 25x S1-GAP stands artifact-corrected; next =
       the dps-30 pin (25h protocol) at the tightest window + the Lean
       S1 wire (b3BoundExplicit/Sbar formalization).
  (A-2) margin_new < 1 at isolated windows (>= 2 neighbors >= 1) ->
       oscillatory sub-1 dips (residf growth pockets): record the dip
       heights; the pinning decides soundness at those points; the
       ceiling = the dip onset if a dip is certified < 1.
  (B-2) margin_new < 1 at a ROBUST interval (>= 3 consecutive windows)
       -> real S1 wall with the corrected < side + kernel: the ceiling
       report written at its onset (the Phase-1a artifact).
"""
import mpmath as mp
mp.mp.dps = 30
import os
import math
import numpy as np
import concurrent.futures as cf

import day023_p11c_1e7 as M
import day024_tail_hi1e9 as TH

DG = [mp.mpf(k)/1000 for k in range(5, 501)]
REM_HI2 = mp.mpf("1e30")
NPTS2 = 400

CANDS = [(3.9e7, "3.9e7"), (4.0e7, "4.0e7"), (4.25e7, "4.25e7"),
         (4.4e7, "4.4e7"), (4.6e7, "4.6e7"), (4.8e7, "4.8e7"),
         (5.2e7, "5.2e7"), (5.6e7, "5.6e7"), (6.0e7, "6e7"),
         (6.4e7, "6.4e7"), (6.8e7, "6.8e7"), (7.2e7, "7.2e7"),
         (7.8e7, "7.8e7"), (8.4e7, "8.4e7"), (9.0e7, "9.0e7"),
         (9.6e7, "9.6e7"),
         (1.05e8, "1.05e8"), (1.1e8, "1.1e8"), (1.2e8, "1.2e8"),
         (1.3e8, "1.3e8"), (1.4e8, "1.4e8"), (1.6e8, "1.6e8"),
         (1.8e8, "1.8e8"), (2.0e8, "2.0e8"),
         (2.5e8, "2.5e8"), (3.0e8, "3.0e8"), (5.0e8, "5.0e8"),
         (4.0e8, "4e8"), (6.0e8, "6e8"), (8.0e8, "8e8"), (1.0e9, "1e9")]


def n4(t):
    return int(math.ceil(31000000.0 * t**4))


def quad_ext(t):
    hi0 = mp.mpf("1e18")
    smp = mp.mpc(0.5, mp.mpf(repr(float(t))))

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp/r1) + mp.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

    k = mp.mpf(NPTS2)
    pts = [hi0 * (REM_HI2/hi0)**(mp.mpf(j)/k) for j in range(NPTS2+1)]
    return mp.quad(f, pts)


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
    re, im = T.pairlog_sum(float(t))
    rem = T.quad_rem(float(t), npts)
    tail = mp.mpf(repr(re)) + 1j*mp.mpf(repr(im)) + rem
    K = mp.e**(main + mp.mpf(repr(float(la))) + 1j*mp.mpf(repr(float(ar)))
               + tail)
    Kfull = K * mp.e**(quad_ext(t))
    B = M.B_best(tmm)
    residf = abs(z - Kfull)
    zabs = abs(z)
    return {"mold": float(zabs*dev/(B + residf)),
            "mnew": float(zabs*dev/(M.p8_B(tmm, n4(tmm)) + residf)),
            "residf": float(residf),
            "Efull": float(mp.log(zabs) - mp.re(mp.log(Kfull))),
            "t": float(t), "zeta": float(zabs), "dev": float(dev)}


def real_zero_at(x):
    T = TH.tail()
    for arr in (T.cache_lo, T.b):
        i = int(np.searchsorted(arr, x))
        cands = [float(arr[j]) for j in range(max(0, i-2), min(arr.size, i+3))]
        gz = min(cands, key=lambda v: abs(v-x))
        if abs(gz - x) < 5e3:
            return gz
    return None


def scan_one(x, label):
    gz = real_zero_at(x)
    g = gz if gz is not None else float(x)
    best_old = None
    best_new = None
    for k in range(-12, 13):
        if k == 0:
            continue
        t = mp.mpf(repr(float(g))) + mp.mpf(k)/2
        r = margin_at(t, g, 200)
        if best_old is None or r["mold"] > best_old["mold"]:
            best_old = r
        if best_new is None or r["mnew"] > best_new["mnew"]:
            best_new = r
    best_new2 = margin_at(mp.mpf(repr(best_new["t"])), float(g), 400)
    return {"g": float(g), "label": label + ("" if gz is not None else " exp"),
            "mold": best_old["mold"], "mnew": best_new2["mnew"],
            "t_best": best_new2["t"], "residf": best_new2["residf"],
            "Efull": best_new2["Efull"], "zeta": best_new2["zeta"],
            "dev": best_new2["dev"], "is_real": gz is not None}


def run():
    work = int(os.environ.get("WORKERS", "32"))
    T = TH.tail()
    print("day029 full sweep: %d windows, (G_LAST,1e30] horizon, %d workers"
          % (len(CANDS), work), flush=True)
    with cf.ProcessPoolExecutor(max_workers=work) as ex:
        futs = [ex.submit(scan_one, x, lab) for (x, lab) in CANDS]
        results = [fu.result() for fu in futs]
    results.sort(key=lambda r: r["g"])
    print("%-9s %10s %10s %9s %9s %8s %7s %s" %
          ("g", "t_best", "margin_old", "margin_new", "residf", "Efull",
           "zeta", "dev"))
    for r in results:
        print("%-9.4g %10.4f %10.4f %9.4f %9.4f %+8.4f %7.3f %7.4f %s"
              % (r["g"], r["t_best"], r["mold"], r["mnew"], r["residf"],
                 r["Efull"], r["zeta"], r["dev"], r["label"]))
    bad = [r["g"] for r in results if r["mnew"] < 1.0]
    print("margin_new < 1 windows: %s" % (bad if bad else "NONE"))


if __name__ == "__main__":
    run()
