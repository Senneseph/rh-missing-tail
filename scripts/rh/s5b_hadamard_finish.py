"""s5b: finish the Hadamard verification.

The s5 streaming run missed the (1e7, 3.1946e7] slice  (not on
grid  (grid ends at 1e7)  nor on disk  (file 1 starts at
3.1946e7)).  This script adds that slice as an RVM-density
quadrature  (same error class as the (G, 1e30] quad  --  the
zero-density error there is part of the reported residual)
and re-computes the identity check from the s5 JSONL.

No re-streaming.
"""
import json
import math
import os
import sys

import importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

spec = importlib.util.spec_from_file_location(
    "s5", os.path.join(HERE, "s5_hadamard_verify.py"))
s5 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s5)

from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre, e as mp_e

import numpy as np

workdps(30)

JSON = os.path.join(s5.ROOT, "tmp", "s5_hadamard_verify.jsonl")
OUT = os.path.join(s5.ROOT, "tmp", "s5_hadamard_verify_final.md")

_f1 = np.memmap(os.path.join(s5.HERE, s5.FILES[0][0]),
                dtype=np.float64, mode="r")
FILE1_FIRST = float(_f1[0])
del _f1


def quad_gap(tv):
    s = mpc(0.5, mpf(repr(tv)))

    def fg(gg):
        r1 = mpc(0.5, gg)
        r2 = mpc(0.5, -gg)
        p = (mp.log(1 - s / r1) + mp.log(1 - s / r2)
             + s / r1 + s / r2)
        return mp.re(p) * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))

    return mp.quad(fg, [mp.mpf("1e7"), mpf(repr(FILE1_FIRST))])


def main():
    if not os.path.exists(JSON):
        print("missing", JSON)
        return
    rows = [json.loads(l) for l in open(JSON) if l.strip()]
    lines = ["# s5 final:  Hadamard form of c(s)  (gap quad added)",
             "",
             "log|Kfull/zeta| = Re lm + log|s| - gamma/4 + Re W + Re E",
             "W now includes  (1e7, 3.1946e7]  via RVM quad,",
             "",
             "| t | LHS | RHS | diff | W-gap quad |",
             "|---|---|---|---|---|"]
    for i, r in enumerate(rows):
        qg = float(mre(quad_gap(r["t"])))
        RHS = (r["lm_re"] + r["logabs"] - float(mp_e) / 4.0
               + r["W"] + qg + r["qF"] + r["Ex"])
        r["Wgap"] = qg
        r["RHSfinal"] = RHS
        r["difffinal"] = r["LHS"] - RHS
        lines.append("| %.6g | %.5f | %.5f | %.3e | %.5f |"
                     % (r["t"], r["LHS"], RHS, r["LHS"] - RHS, qg))
    open(JSON, "w").write("\n".join(
        json.dumps(r) for r in rows) + "\n")
    lines += ["",
              "residual class:  GN-grid error (14.1, 1e7]  +  RVM-quad",
              "errors  ((1e7, 3.19e7]  and  (G, 1e30])  +  engine",
              "genus-0 extras  (the extra factors are included,  not",
              "residual)."]
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("\n".join(lines))


if __name__ == "__main__":
    main()
