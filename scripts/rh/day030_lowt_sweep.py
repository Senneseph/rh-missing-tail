#!/usr/bin/env python3
"""day030 -- LOW-T data-territory SWEEP (per
docs/LOW-T-DATA-TERRITORY-PLAN.md, "Protocol" step 1).

200 log-spaced t0 in [0.5, 1000) + the pinned probes; at each:
  margin_new(t0) = |zeta| * dev / (p8_B(t, n4) + residf)   with
  K(t0) = exp(main + line-product((0, 1200]) + rem (1200, 1e18]
           + ext (1e18, 1e30])  (the P1.1e wire form, low-t split)
  dev(t0) = min_{d in 500-grid + pins} |R_closed(g, t0, d) - 1|,
           g = nearest zero to t0
and the S2 disc-floor quantity (C1b form, finite):
  s2(t0) = min(23/1000, 1 - 25/|g* - t0|)  (vs the own-pole gap 1/4
  already handled by the 23/1000 floor in the pre-flight form).

Deliverable: out_day030_lowt_sweep.txt
  (t0, zeta, residf, dev, argmin-d, margin_new, Efull, s2 floor)
with the global min margin + argmin (the future pin family).

RUN: single core, ~40-60 min background (200 x ~10-18 s: dev grid
+ 400-cell rem quad + ext quad per point).
"""
import mpmath as mp
mp.mp.dps = 30
import os
import math
import time
import numpy as np

import day023_p11c_1e7 as M
import day030_lowt_preflight as P     # evaluate()/DGALL/quad machinery
mp.mp.dps = 30                        # re-set after the imports (M
                                      # pulls in dps-25 modules)

HERE = os.path.dirname(os.path.abspath(__file__))
LOW_FILE = os.path.join(HERE, "lowt", "zeros_0_to_1p2e3.f64")
OUT = os.path.join(HERE, "out_day030_lowt_sweep.txt")


def run():
    low = np.load(LOW_FILE)
    ts = np.unique(np.concatenate((
        np.geomspace(0.5, 999.0, 200), [0.5, 1.0, 2.0, 14.13, 50.0,
                                        100.0, 120.0, 500.0])))
    print("low-t zeros: %d; t0 grid: %d points" % (low.size, ts.size),
          flush=True)
    t0start = time.time()
    rows = []
    for i, t0 in enumerate(ts):
        r = P.evaluate(low, float(t0))
        if r is None:
            print("  t0=%8.4f POLE (excluded from the grid)" % float(t0),
                  flush=True)
            continue
        rows.append(r)
        if i % 20 == 0:
            print("  %3d/%d  t0=%8.4f  mnew=%8.4f  residf=%.2e  "
                  "s2floor=%.4f  (%d s)"
                  % (i, len(ts), r["t"], r["mnew"], r["residf"],
                     r["s2floor"], int(time.time() - t0start)),
                  flush=True)
    rows.sort(key=lambda r: r["mnew"])
    worst = rows[:10]
    with open(OUT, "w") as f:
        f.write("day030 LOW-T SWEEP  (200-pt log grid [0.5, 1e3), "
                "dps-30, P1.1e wire form, low split at G = 1200)\n")
        f.write("%7s | |zeta| | residf | dev | mnew | Efull | g(near) "
                "| s2floor\n" % "t0")
        for r in sorted(rows, key=lambda r: r["t"]):
            f.write("%9.4f | %.6f | %.5e | %.5e | %.6f | %+.3f | "
                    "%.4f | %.5f\n"
                    % (r["t"], r["zeta"], r["residf"], r["dev"],
                       r["mnew"], r["Efull"], r["g"], r["s2floor"]))
        f.write("\nWORST 10 (min margin first):\n")
        for r in worst:
            f.write("  t0 = %10.6f  d-argmin see pre-flight  "
                    "mnew = %.8f  residf = %.5e  dev = %.5e  "
                    "s2floor = %.5f\n"
                    % (r["t"], r["mnew"], r["residf"], r["dev"],
                       r["s2floor"]))
        f.write("\nGLOBAL MIN margin_new = %.8f at t0 = %.6f\n"
                % (worst[0]["mnew"], worst[0]["t"]))
        f.write("S2 floor min = %.5f (>= 0.99*23/1000 form)\n"
                % min(r["s2floor"] for r in rows))
        f.write("\nVERDICT: %s\n" % (
            "S1 MARGIN >= 1 AT ALL %d GRID POINTS - the low-t data "
            "territory is SOUND at screen level; the global-min point "
            "(%.6f) is the low-t PIN (dual-precision certify next)"
            % (len(rows), worst[0]["t"]) if worst[0]["mnew"] >= 1
            else "SUB-1 at t0 = %.6f (mnew = %.6f) - STOP, "
                 "investigate (one problem at a time) before "
                 "declaring the territory" % (worst[0]["t"],
                                              worst[0]["mnew"])))
    print("\nWROTE %s" % OUT, flush=True)
    print("GLOBAL MIN margin_new = %.8f at t0 = %.6f"
          % (worst[0]["mnew"], worst[0]["t"]), flush=True)
    print("\nDONE")


if __name__ == "__main__":
    run()
