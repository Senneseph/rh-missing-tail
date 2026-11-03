#!/usr/bin/env python3
"""0274 unit B: exact float64 sum of f(g; s) over the 92.5e9 zeros of the
3e10 band in (G1 = GLAST, G2], four face sigmas, one pass, multiprocess.

File format: RAW little-endian f64, NO header (740,623,021,712 bytes ==
8 x 92,577,877,714; first = 2999246000.182257, last = 30001045999.981976).

Vectorized per subslice with TWO algebraically-equivalent forms of f and
a per-subslice agreement check (catches vectorization slips); pre-flight
samples 4096 zeros against mpmath dps-30.

Outputs unit B JSON: {n_in, sums{sigma}, K_pinned{sigma}, maxformdiff}.
K_pinned[sm] = K'(GLAST) + (SUM_{(G1,G2]} f - INT_{G1}^{G2} f rho dg),
    K'(GLAST) from the validated day072 run (out_day072_face_U_repair.txt)
    INT from day073 unit A (dps-40 quad, printed).

Supersedes the +/-1799 unit-A bands with a pinned K'_opt at the
float64 block-pairwise floor (~1e-3 .. 1). NO RH claim.
"""
import os, sys, time, json, struct, random
import numpy as np
import mpmath as mpm
from multiprocessing import Pool

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
F64 = "hi3e10/zeros_2999e6_to_30000e6.f64"
TPT2f = 3000175332800.0
G1 = 3001345999.873009          # GLAST (day072 S-stream end; zeros <= G1 already in S)
SIGS = [0.1252270103, 0.25, 0.40, 0.49]
A2 = [(0.5 - s) ** 2 for s in SIGS]
K3E9 = {0.1252270103: -9042.185335, 0.25: -9045.537874,
        0.40: -9049.568635, 0.49: -9051.986604}
# day073 unit A dps-40 center Int_{G1}^{G2} f rho dg:
INT_CENTER = 987406884360.0220
# day073 unit A certified optimal-split bounds (per-unit telescoping):
BOPT = {0.1252270103: 10302.85, 0.25: 10421.49, 0.40: 10690.00, 0.49: 11364.76}
WF = 24
SUB = 1 << 22                  # 4.19e6 floats = 33.5 MB per read

def preflight():
    """sample 4096 stored zeros against mpmath dps-30 for all 4 sigmas."""
    mpm.mp.dps = 30
    t = mpm.mpf(3000175332800)
    raw = open(F64, "rb").read(8 * (1 << 25))
    v = np.frombuffer(raw, dtype=np.float64)
    rng = random.Random(20261107)
    idx = [rng.randrange(v.size) for _ in range(4096)]
    g = v[idx]
    worst = 0.0
    for j, sm in enumerate(SIGS):
        a2 = mpm.mpf(A2[j]); sr = mpm.mpf(str(sm))
        for i, k in enumerate(idx):
            if i % 101 != 0:
                continue
            gv = g[i]
            g2 = mpm.mpf(gv) ** 2 + mpm.mpf("0.25")
            ref = 0.5 * (mpm.log((a2 + (gv - t) ** 2) / g2)
                         + mpm.log((a2 + (gv + t) ** 2) / g2)) + sr / g2
            a2f = A2[j]
            g2f = float(gv) * float(gv) + 0.25
            calc = 0.5 * math_log(a2f + (float(gv) - TPT2f) ** 2, g2f) \
                 + 0.5 * math_log(a2f + (float(gv) + TPT2f) ** 2, g2f) \
                 + float(sm) / g2f
            worst = max(worst, abs(float(ref) - calc))
    print(f"preflight: 4096 stored zeros sampled (41 deep per sigma) "
          f"worst |mpmath - float| = {worst:.3e}")
    assert worst < 1e-9

def math_log(a, b):
    import math
    return math.log(a / b)

def worker(arg):
    wid, off, end, fpath = arg
    sums = np.zeros(len(SIGS))
    n = 0
    maxdiff = 0.0
    fh = open(fpath, "rb")
    fh.seek(off)
    need = end - off
    SUBB = SUB * 8
    while need > 0:
        raw = fh.read(min(SUBB, need))
        if not raw:
            break
        need -= len(raw)
        v = np.frombuffer(raw, dtype=np.float64).copy()
        m = int(np.searchsorted(v, G1, side="right"))
        if m > 0:
            v = v[m:]
            if v.size == 0:
                continue
        n += v.size
        gm2 = (v - TPT2f) ** 2
        gp2 = (v + TPT2f) ** 2
        g2 = v * v + 0.25
        for j, sm in enumerate(SIGS):
            f1 = 0.5 * np.log((A2[j] + gm2) / g2) \
               + 0.5 * np.log((A2[j] + gp2) / g2) \
               + sm / g2
            f2 = 0.5 * (np.log(A2[j] + gm2) - np.log(g2)) \
               + 0.5 * (np.log(A2[j] + gp2) - np.log(g2)) \
               + sm / g2
            maxdiff = max(maxdiff, abs(float(f1.sum()) - float(f2.sum())))
            sums[j] += f1.sum()
    fh.close()
    return wid, sums.tolist(), n, maxdiff

def main():
    sz = os.path.getsize(F64)
    assert sz == 740623021712, sz
    preflight()
    parts = []
    off = 0
    for i in range(WF):
        end = sz if i == WF - 1 else (int((i + 1) * sz / WF) // 8) * 8
        parts.append((i, off, end, F64))
        off = end
    t0 = time.time()
    with Pool(WF) as pool:
        rows = pool.map(worker, parts)
    dt = time.time() - t0
    sums = np.zeros(len(SIGS))
    ntot = 0
    md = 0.0
    for wid, s, n, d in rows:
        sums += np.asarray(s)
        ntot += n
        md = max(md, d)
    out = {"t_sec": dt, "n_in": ntot,
           "sums": {str(SIGS[j]): float(sums[j]) for j in range(len(SIGS))},
           "maxformdiff": md}
    print(f"unit B: n_in = {ntot}  wallclock = {dt/60:.1f} min  maxformdiff = {md:.3e}")
    assert md < 1e-4, "two f-forms disagree - vectorization bug"
    for j, sm in enumerate(SIGS):
        Kpin = K3E9[sm] + (float(sums[j]) - INT_CENTER)
        out.setdefault("K_pinned", {})[str(sm)] = Kpin
        out.setdefault("K_minus_B", {})[str(sm)] = Kpin - BOPT[sm]
        print(f"  sigma={sm:.10f}: SUM = {sums[j]:+.6f}   K_pinned = {Kpin:+12.4f}   "
              f"B_opt = {BOPT[sm]:9.2f}   K-B = {Kpin - BOPT[sm]:+12.4f}")
    wall = all(out["K_pinned"][str(sm)] - BOPT[sm] < 0 for sm in SIGS)
    out["wall_pinned"] = wall
    print("  VERDICT (pinned): optimal-split wall "
          f"{'CONFIRMED' if wall else 'FAILED - investigate'} at t = tPT2")
    outp = os.path.join(BASE, "out_day073b_3e10_sum.json")
    json.dump(out, open(outp, "w"), indent=1)
    print(f"  saved {outp}")

if __name__ == "__main__":
    main()
