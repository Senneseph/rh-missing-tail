"""s5: verify the Hadamard form of the squeeze factor c(s).

Claim (closed form of the Efull identity ratio,  s = 1/2 + i t):

    log|Kfull(s) / zeta(s)|  =
        Re logmain25212(s)  +  log|s|  -  gamma/4
      +  Re W(s)  +  Re E(s)   +  0 (branches:  ratio is -1 * |.|,  phase pi)

where
    W(s) = sum over ALL zeros rho (= 1/2 + i g),  g > 14.13
           [ log(1 - s/rho) + s/rho ]          (convergent,  genus 1)

    E(s) = the engine's extra genus-0 factors,  real part:
           sum_modeled_zeros 0.5/(g^2 + 1/4)
           (the factor (g^2+1/4)^{1/2} by which the engine's pair
            factor differs from the exact (1-s/r1)(1-s/r2))

Numerical scheme (no hand estimates):
    * Re W:  true zeros from the on-disk f64 files
              (3.19e6, 1e9]  hi1e9/zeros_hi31946e6_to_1e9.f64
              (1.002e9, 2e9] hi1e9/zeros_1002e6_to_2000e6.f64
              (2.002e9, 3e9] hi3e9/zeros_2002e6_to_3000e6.f64
              (2.9992e9, G]  hi3e10/zeros_2999e6_to_30000e6.f64  (G = last)
           GN grid over the gaps
              (14.13, 3.19e6], (1e9, 1.002e9], (2e9, 2.002e9],
              (2.999e9, 2.9992e9]
           (gap grid error ~1e-8:  the genus-1 kernel is smooth there)
    *  Re W (G, 1e30]:  mp.quad of f_re . (ln g/2pi)/2pi,  dps-30
    *  Re E:  same split  (grid + streamed D file sum + small quad)
    *  f_re(g, t) = log|g-t| - 0.5 log(g^2+.25) + (0.25+t g)/(g^2+.25)
                   = Re[ log(1-s/rho) + s/rho ]   (exact,  algebra)
    *  test t's:  t0 = 3232170971.1121945 (ledger head window)
                  t1 = 27884282870.578449249 + 0.5 (ledger top window)
    *  LHS from the certified ledger  (Kabs / |zeta|,  phase pi).

Output:  tmp/s5_hadamard_verify.md + .jsonl
"""
import json
import math
import os
import sys
import time

import numpy as np
import importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

spec = importlib.util.spec_from_file_location(
    "s3", os.path.join(HERE, "s3_ledger_recon_margin_sweep.py"))
s3 = importlib.util.module_from_spec(spec)
spec.loader.exec_module(s3)

import day023_p11c_1e7 as M
from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre, e as mp_e

workdps(30)

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "tmp", "s5_hadamard_verify.md")
JSON = os.path.join(ROOT, "tmp", "s5_hadamard_verify.jsonl")

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
G_LAST = float(_mm[-1])
D_FIRST = float(_mm[0])
del _mm

# test heights (ledger straddle centers:  g + 0.5)
T0 = 3232170971.1121945
T1 = 27884282870.578449249 + 0.5
GAPS_GRID = [
    (14.134725141734695, 1e7),         # the GN grid stops at 1e7
    (1e9, 1.002e9),
    (2e9, 2.002e9),
    (2.999e9, D_FIRST),
]
# (1e7, first zero of file 1):  not on grid nor on disk  ->  RVM quad
GAP_QUAD_LO = 1e7
FILE1_LO = 3194600.0
FILES = [
    ("hi1e9/zeros_hi31946e6_to_1e9.f64", FILE1_LO, 1e9, None),
    ("hi1e9/zeros_1002e6_to_2000e6.f64", 1.002e9, 2e9, None),
    ("hi3e9/zeros_2002e6_to_3000e6.f64", 2.002e9, 3e9, D_FIRST),
    (s3.D_FILE, D_FIRST, G_LAST, None),
]
CHUNK = 80_000_000   # 640 MB of f64


def f_re(g, t):
    g2 = g * g
    return (np.log(np.abs(g - t)) - 0.5 * np.log(g2 + 0.25)
            + (0.25 + t * g) / (g2 + 0.25))


def main():
    t = [T0, T1]
    acc = [np.longdouble(0), np.longdouble(0)]
    acc_ex = np.longdouble(0)
    t0 = time.time()

    # file-1 actual first zero  (defines the grid/true split)
    _f1 = np.memmap(os.path.join(HERE, FILES[0][0]),
                    dtype=np.float64, mode="r")
    FILE1_FIRST = float(_f1[0])
    del _f1
    print("file1 first zero = %.6f" % FILE1_FIRST, flush=True)

    # --- GN grid parts ---
    gn = np.asarray(M.GN, dtype=np.float64)
    for (lo, hi) in GAPS_GRID:
        hi_eff = hi
        sel = (gn >= lo) & (gn < hi_eff)
        g = gn[sel]
        if g.size == 0:
            continue
        for i, tv in enumerate(t):
            acc[i] += np.sum(f_re(g, tv).astype(np.longdouble))
        acc_ex += np.sum((0.5 / (g * g + 0.25)).astype(np.longdouble))
        print("  grid (%.6g, %.6g):  %d pts" % (lo, hi_eff, g.size),
              flush=True)

    # --- streamed true-zero files ---
    for path, lo, hi, clip in FILES:
        fpath = path if path.startswith(("/")) or os.path.exists(path) \
            else os.path.join(HERE, path)
        mm = np.memmap(fpath, dtype=np.float64, mode="r")
        n = mm.shape[0]
        if clip is None:
            i0 = 0
            i1 = n
        else:
            i0 = 0
            i1 = int(np.searchsorted(mm, clip, side="left"))
        n = i1
        print("  file %s :  n=%d  (%.4g, %.4g]%s"
              % (os.path.basename(fpath), n, lo, hi,
                 "  clip@%.4g" % clip if clip is not None else ""),
              flush=True)
        i = 0
        while i < n:
            m = min(CHUNK, n - i)
            g = mm[i:i + m]
            g = np.asarray(g, dtype=np.float64)
            for j, tv in enumerate(t):
                acc[j] += np.sum(f_re(g, tv).astype(np.longdouble))
            acc_ex += np.sum((0.5 / (g * g + 0.25)).astype(np.longdouble))
            i += m
            if i % (CHUNK * 9) < m:
                print("    ...%d:  row %.1f/%d  (%.0f%%)  %.0fs"
                      % (i // CHUNK, i, n, 100.0 * i / n,
                         time.time() - t0), flush=True)
        del mm

    W = [float(acc[0]), float(acc[1])]
    Ex_grid_D = float(acc_ex)
    print("stream done in %.0f s;  W0=%.6f  W1=%.6f  Ex=%.6f"
          % (time.time() - t0, W[0], W[1], Ex_grid_D), flush=True)

    # --- (G, 1e30]  quads  (two sections,  as the engine) ---
    def quad_f(tv):
        s = mpc(0.5, mpf(repr(tv)))
        def fg(gg):
            r1 = mpc(0.5, gg)
            r2 = mpc(0.5, -gg)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2)
                 + s / r1 + s / r2)
            return mp.re(p) * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))
        return (mp.quad(fg, [mpf(repr(G_LAST)), mp.mpf("1e18")])
                + mp.quad(fg, [mp.mpf("1e18"), mp.mpf("1e30")]))

    def quad_ex():
        def ge(gg):
            return (mpf("0.5") / (gg * gg + mpf("0.25"))
                    * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi)))
        return mp.quad(ge, [mpf(repr(G_LAST)), mp.mpf("1e30")])

    qF = [float(mre(quad_f(tv))) for tv in t]
    qE = float(mre(quad_ex()))
    # gap quad (1e7, FILE1_FIRST]:  RVM-density approximation  (same
    # error class as the (G, 1e30] quad;  reported in the residual)
    def quad_gap(tv):
        s = mpc(0.5, mpf(repr(tv)))
        def fg(gg):
            r1 = mpc(0.5, gg)
            r2 = mpc(0.5, -gg)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2)
                 + s / r1 + s / r2)
            return mp.re(p) * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))
        return mp.quad(fg, [mp.mpf("1e7"), mpf(repr(FILE1_FIRST))])
    qF = [q + float(mre(quad_gap(tv))) for q, tv in zip(qF, t)]
    print("quads done:", qF, qE, flush=True)

    rows = []
    for i, tv in enumerate(t):
        s = mpc(0.5, mpf(repr(tv)))
        lm = s3.logmain25212(s)
        logabs = float(mre(mlog(s)))
        gamma = mp.euler
        # ledger LHS
        cand = None
        for line in open(s3.LEDGER):
            r = json.loads(line)
            if abs(float(r["t"]) - tv) < 0.01:
                cand = r
                break
        LHS = math.log(float(cand["p"]["Kabs"]) / float(cand["p"]["zeta"]))
        RHS = (float(mre(lm)) + logabs - float(gamma) / 4.0
               + W[i] + qF[i] + Ex_grid_D + qE)
        rows.append(dict(t=tv, LHS=LHS, RHS=RHS, diff=LHS - RHS,
                         lm_re=float(mre(lm)), logabs=logabs,
                         W=W[i], qF=qF[i], Ex=Ex_grid_D + qE))
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rows[-1]) + "\n")
        print("t=%.6g  LHS=%.6f  RHS=%.6f  diff=%.3e"
              % (tv, LHS, RHS, LHS - RHS), flush=True)

    lines = ["# s5:  Hadamard form of c(s)  --  verification",
             "",
             "identity:  log|Kfull/zeta| = Re lm + log|s| - gamma/4",
             "           + Re W(s) + Re E(s)     (W over ALL zeros)",
             "",
             "| t | LHS (ledger) | RHS (recomputed) | diff |",
             "|---|---|---|---|"]
    for r in rows:
        lines.append("| %.6g | %.6f | %.6f | %.3e |"
                     % (r["t"], r["LHS"], r["RHS"], r["diff"]))
    lines += ["",
              "terms at t0:  Re lm = %.4f,  log|s| = %.4f,  Re W = %.4f,"
              "  Re E = %.6f,  quad F/W split = %.4f"
              % (rows[0]["lm_re"], rows[0]["logabs"], rows[0]["W"],
                 rows[0]["Ex"], rows[0]["qF"])]
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("wrote", OUT)


if __name__ == "__main__":
    if os.path.exists(JSON):
        os.unlink(JSON)
    main()
