# Day-022 — P1.1e: the closure-faithful statistic = BEST straddle point
# in the window (C5b's witness t_eval is free — the day-010 d4d3
# protocol evaluated at straddle points, NOT at the pole t0 = g;
# DISCOVERY_LOG 21).  Per-point formula = P1.1c's corrected (bridge-
# true) form:
#   margin_c(t) = |zeta(t)| * min_d |R(g,d,t)-1| / (B(t) + resid(t))
#   zero_c  = |zeta| * floor_R   (bridge: |K_true| = |zeta|, model-free)
#   def_c   = B(t; N=argmin) + resid(t)     (B = Lean p8_B floor;
#             resid = the measured P5/bridge defect of the composite
#             — the closure's object of analysis)
#   per g:  BEST (max) over the window  (the witness), printed with
#           the argmax point;  worst (min) kept for the record.
# Anchors: g ~ 1e3 day-010 straddle story (14x class), g = 5000.23.
# Masked band = where def_c is defect-dominated (the composite is a
# bad approximation: f = e^{-E} growth, DISCOVERY_LOG 20) — the
# composite (not the statistic) is the limiting object there.
# 32-process parallel over the 10 candidates of P1.1c.
import numpy as np, math, sys
from mpmath import mp
from day022_p11c_corrected import (kernel_on, R_closed, p8_B, B_best,
                                   GN, DG, W, DT, G_MAX)
mp.dps = 25

def scan_best(g, label):
    g = float(g)
    pts = []
    t = g - W
    while t <= g + W + 1e-9:
        if abs(t - g) > 1e-6:
            s = mp.mpc(0.5, mp.mpf(t))
            K = kernel_on(s)
            if K is not None:
                z = mp.zeta(s)
                resid = abs(z - K)
                devf = None
                for d in DG:
                    v = abs(R_closed(g, t, d) - 1)
                    devf = v if devf is None else min(devf, v)
                zero_c = abs(z) * devf
                def_c = B_best(t) + float(resid)
                pts.append((t, float(zero_c / def_c), float(zero_c),
                            float(def_c), float(resid), float(abs(z)),
                            float(mp.log(abs(z)) - mp.re(mp.log(K)))))
        t += DT
    best = max(pts, key=lambda r: r[1])
    worst = min(pts, key=lambda r: r[1])
    return {"g": g, "label": label, "best_margin": best[1], "best_t": best[0],
            "zero": best[2], "def": best[3], "resid": best[4], "zeta": best[5],
            "E": best[6], "worst_margin": worst[1], "worst_t": worst[0]}

if __name__ == "__main__":
    import concurrent.futures as cf
    zero_of = lambda x: float(min(GN[max(0, int(np.searchsorted(GN, x))-3):
                                     int(np.searchsorted(GN, x))+4],
                                  key=lambda v: abs(v - x)))
    cands = [(zero_of(1000.0), "10^3 ANCHOR (day-010 straddle 14x class)")]
    cands.append((5000.234317, "5e3 VERIFIED-REGIME ANCHOR"))
    for x in (7500.0, 10000.0, 15000.0, 20000.0, 30000.0, 50000.0, 75000.0, 100000.0):
        cands.append((round(zero_of(x), 6), "%.0f mask" % x))
    print("P1.1e run: %d candidates (best-straddle closure statistic)"
          % len(cands), flush=True)
    results = []
    with cf.ProcessPoolExecutor(max_workers=len(cands)) as ex:
        futs = [ex.submit(scan_best, g, lab) for (g, lab) in cands]
        for f in cf.as_completed(futs):
            results.append(f.result())
    results.sort(key=lambda r: r["g"])
    print("\n--- P1.1e BEST-STRADDLE CLOSURE STATISTIC ---")
    print("%-10s %9s %10s %9s %8s %8s %9s %8s" % (
        "g", "best_marg", "t_best", "zero_c", "def_c", "resid", "zeta", "E"))
    for r in results:
        print("%-10.4f %9.3f %10.4f %9.4f %8.4f %8.4f %9.4f %8.4f" % (
            r["g"], r["best_margin"], r["best_t"], r["zero"], r["def"],
            r["resid"], r["zeta"], r["E"]))
        print("   (worst over window = %.3f at t = %.4f; %s)" % (
            r["worst_margin"], r["worst_t"], r["label"]))
    b = max(results, key=lambda r: r["best_margin"])
    m = min(results, key=lambda r: r["best_margin"])
    print("\nBEST across all g = %.3f at g = %.4f;  "
          "WORST best-straddle = %.3f at g = %.4f" % (
              b["best_margin"], b["g"], m["best_margin"], m["g"]))
    print("reading: best-straddle margin > 1 at g  => that g's pair")
    print("package could squeeze (composite valid there, E ~ 0);")
    print("E >> 0 (mask band) => the COMPOSITE is the limiting object")
    print("(repair list; DISCOVERY_LOG 20/21).")
    print("P1.1e RUN COMPLETE")
