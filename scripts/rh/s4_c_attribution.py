"""s4: c(t) drift decomposition.

c(t) := Kfull(t)/|zeta(t)|  (measured identity ratio,  phase pi)
      = exp( T_lm(t) + T_grid(t) + T_tail(t) + T_quad(t) ) / |zeta(t)|

with  T_lm    = Re logmain25212(1/2+it)                 (mpmath,  exact)
      T_grid  = la    (21M RVM grid sum over (14.1, 1e7])  (ledger,  bit-exact)
      T_tail  = re    (discrete kernel sum over (2.999e9, G_LAST] real zeros)
                                                       (ledger)
      T_quad  = Re( quad (G_LAST,1e18] + (1e18,1e30] )  (mpmath,  400 nodes)
      T_z     = log(1/|zeta(t)|)                          (ledger |zeta|)

The slow drift of c(t) across the band  =  sum of the five term drifts.
This script measures each drift numerically at one ledger row per window
(22 windows).  Pure numerics;  no hand estimates.
"""
import json
import math
import os
import sys

import importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

spec = importlib.util.spec_from_file_location(
    "s3", os.path.join(HERE, "s3_ledger_recon_margin_sweep.py"))
s3 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3)

from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre

import numpy as np

workdps(30)

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
s3.G_LAST = float(_mm[-1])
del _mm

LEDGER = os.path.join(HERE, "out_day052c_696", "points.jsonl")
OUT = "/home/jsmille/Projects/rh-missing-tail/tmp/s4_c_attribution.md"
JSON = "/home/jsmille/Projects/rh-missing-tail/tmp/s4_c_attribution.jsonl"


def main():
    xs = s3.load_ledger()
    picks = []
    for x in sorted(xs):
        w = xs[x]   # already sorted by t
        picks.append(w[len(w) // 2])
    print("selecting %d rows (one per window)" % len(picks))

    res = []
    for i, r in enumerate(picks):
        t = float(r["t"])
        x = float(r["x"])
        p = r["p"]
        s = mpc(0.5, mpf(repr(t)))
        lm = s3.logmain25212(s)
        f = s3._kint(s)
        q1 = s3.quad_section(f, repr(s3.G_LAST), "1e18", 400, 30)
        q2 = s3.quad_section(f, "1e18", "1e30", 400, 30)
        T_lm = float(mre(lm))
        T_grid = float(p["la"])
        T_tail = float(p["re"])
        T_quad = float(mre(q1) + mre(q2))
        T_z = float(mlog(mpf("1") / mpf(repr(float(p["zeta"])))))
        c_meas = float(p["Kabs"]) / float(p["zeta"])
        L = T_lm + T_grid + T_tail + T_quad + T_z
        entry = dict(i=i, x=x, t=t,
                     T_lm=T_lm, T_grid=T_grid, T_tail=T_tail,
                     T_quad=T_quad, T_z=T_z, L=L,
                     log_c_meas=math.log(c_meas))
        res.append(entry)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(entry) + "\n")
        print("  [%2d/22] x=%.4g  L=%.6f  logc_meas=%.6f  diff=%.3e"
              % (i + 1, x, L, math.log(c_meas),
                 L - math.log(c_meas)), flush=True)

    # drift table
    lines = ["# s4 c(t) drift decomposition (one row per window)",
             "",
             "terms:  L = T_lm + T_grid + T_tail + T_quad + T_z = log c(t)",
             "",
             "| win | x | L | dL | dT_lm | dT_grid | dT_tail | dT_quad | dT_z |",
             "|---|---|---|---|---|---|---|---|---|"]
    tot = dict(dT_lm=0.0, dT_grid=0.0, dT_tail=0.0, dT_quad=0.0, dT_z=0.0, dL=0.0)
    for i in range(1, len(res)):
        a, b = res[i - 1], res[i]
        dL = b["L"] - a["L"]
        d = {k: b[k] - a[k] for k in
             ("T_lm", "T_grid", "T_tail", "T_quad", "T_z")}
        for k in tot:
            tot[k] += (d[k] if k != "dL" else dL)
        lines.append(
            "| %d | %.4g | %.4f | %+.2e | %+.2e | %+.2e | %+.2e | %+.2e | %+.2e |"
            % (i, b["x"], b["L"], dL, d["T_lm"], d["T_grid"],
               d["T_tail"], d["T_quad"], d["T_z"]))
    lines += ["",
              "totals across the band:",
              "  dL       = %+.4e   (= log c(2.79e10) - log c(3.23e9))" % tot["dL"],
              "  dT_lm    = %+.4e" % tot["dT_lm"],
              "  dT_grid  = %+.4e" % tot["dT_grid"],
              "  dT_tail  = %+.4e" % tot["dT_tail"],
              "  dT_quad  = %+.4e" % tot["dT_quad"],
              "  dT_z     = %+.4e" % tot["dT_z"],
              "  check    sum = %+.4e" % (
                  tot["dT_lm"] + tot["dT_grid"] + tot["dT_tail"]
                  + tot["dT_quad"] + tot["dT_z"])]
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("\n".join(lines[-10:]))
    print("wrote", OUT)


if __name__ == "__main__":
    if os.path.exists(JSON):
        os.unlink(JSON)
    main()
