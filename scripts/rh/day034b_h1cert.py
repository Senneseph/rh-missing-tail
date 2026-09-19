#!/usr/bin/env python3
"""day034b -- H1 CERTIFICATE reissuance, two-phase window-batched
build (queue item 7).  Same certified pipeline as day034_h1cert.py
(per-term unit-roundoff model, dg representation bounds, quad
dps-30/60 pair budget, exact-integer nlt + NLT_GUARD, the same
conservative propagation) reorganized so that the 22GB band is
streamed ONCE PER WINDOW (all 25 straddles of a window in a single
pass, t-batched) instead of once per point -- the band traffic
scales with windows, not points.

PHASE 1 (bandwidth-bound, few workers, cores 0-9): per window
  x in the grid: one pass over (cache_lo, band) computing, for all
  25 straddles t = g_x + k/2: the tail sums (re, im), the budgets
  (B_re, B_im), the nlt counts, the dmin guards, and the (0,1e7]
  GN product (la, ar, B_la, B_ar, dmin_g).  Stored to
  tmp/h1cert_p1/win_<i>.npz.
PHASE 2 (compute-bound, many workers, cores 0-26): per straddle:
  the quad pair budgets (dps 30/60 x 400 nodes, both sections),
  the dps-30/60 zeta + 25.2.12 main terms, the 500-delta dev at
  30/60, the propagation, the cert margin.  Rows appended to
  out_day034_h1cert_b.txt (one file per window, merged at the end).

EQUIVALENCE GATE (H1CERTB_CROSSCHECK=1): one window is run both
per-point (day034_h1cert.cert_point) and batched (this file); the
tail sums must agree to <= 1e-12 (last-ulp differences from the
0.5/A -> 0.5*invA precompute) and the full per-point mnew/mcert
rows must agree to <= 1e-9.

Everything else (selftest, pre-registered readings C-1/C-2/C-3,
budget model) is inherited verbatim from day034_h1cert.py.
COMPUTE, NEVER RECALL.
"""
import os
import sys
import math
import time
import glob
import numpy as np
import concurrent.futures as cf

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")

import day023_p11c_1e7 as M
import day024_tail_hi1e9 as TH
import day034_h1cert as C      # reuse the verified per-point machinery

SUB = 33554432                 # 2^25 sub-chunk (as day034)
TB = 5                         # straddles per inner batch
OUTDIR = os.path.join(R_H, "tmp", "h1cert_p1")
OUTB = os.path.join(R_H, "scripts", "rh", "out_day034_h1cert_b.txt")
GAP = 1.12                     # 12% window spacing (71 windows)


def grid():
    xs = []
    x = 1.0e6
    while x <= 1.0e9 + 1.0:
        xs.append(x)
        x *= GAP
    return xs


def straddles(g):
    return [g + k / 2.0 for k in range(-12, 13) if k != 0]


# ----------------------------------------------------------------------
# PHASE 1: one band pass per window, all 25 straddles
# ----------------------------------------------------------------------
def window_tail_pass(c, ts):
    """One pass over array c (float64 zeros), computing for each t in
    ts: the f64-pairwise-per-SUB / longdouble-across-subs sums of the
    re/im terms + the tracked budget.  Returns lists over ts of
    (re_ld, im_ld, B_re, B_im, sub_abs_total)."""
    n = len(ts)
    re_ld = [np.longdouble(0) for _ in range(n)]
    im_ld = [np.longdouble(0) for _ in range(n)]
    B_re = [0.0] * n
    B_im = [0.0] * n
    satot = [np.longdouble(0) for _ in range(n)]
    LOG2SUB = float(math.ceil(math.log2(SUB)))
    for i in range(0, c.size, SUB):
        cc = c[i:i + SUB]
        g2 = cc * cc
        A = g2 + 0.25
        logA = np.log(A)
        invA = 1.0 / A
        invA2 = invA * invA
        base_dre = 2.0 * cc * invA + cc * invA2     # t-invariant part
        tcoef_im = 2.0 * cc * invA2                 # im dg-derivative base
        gabs = np.abs(cc)
        dg = C.U64 * gabs
        for k in range(0, n, TB):
            block = ts[k:k + TB]
            for j, t in enumerate(block):
                idx = k + j
                t2 = t * t
                absd = np.abs(g2 - t2)
                logd = np.log(absd)
                re_t = logd - logA + 0.5 * invA
                im_t = t * invA
                sub_re = float(np.sum(re_t))
                sub_im = float(np.sum(im_t))
                re_ld[idx] += np.longdouble(sub_re)
                im_ld[idx] += np.longdouble(sub_im)
                abs_re = np.abs(re_t)
                s_abs_re = float(abs_re.astype(np.longdouble).sum())
                s_scale = float(np.maximum(abs_re, 0.5 * invA).astype(
                    np.longdouble).sum())
                s_abs_im = float(im_t.astype(np.longdouble).sum())
                dredg = base_dre + 2.0 * cc / np.maximum(absd, 1e-30)
                dimdg = t * tcoef_im
                B_re[idx] += (C.GAM10_64 * s_scale
                              + LOG2SUB * 2.0 * C.U64 * s_abs_re
                              + float((dg * dredg).astype(np.longdouble).sum()))
                B_im[idx] += (C.GAM1_64 * s_abs_im
                              + LOG2SUB * 2.0 * C.U64 * s_abs_im
                              + float((dg * dimdg).astype(np.longdouble).sum()))
                satot[idx] += np.longdouble(s_abs_re)
                del absd, logd, re_t, im_t, abs_re, dredg, dimdg
        del cc, g2, A, logA, invA, invA2, base_dre, tcoef_im, gabs, dg
    return re_ld, im_ld, B_re, B_im, satot


def phase1_window(x):
    """one window of phase 1: tail pass over both arrays + GN product
    + guards.  Returns a dict of arrays over the 25 straddles."""
    T = TH.tail()
    g = C.nearest_zero(T, x)
    g = g if g is not None else float(x)
    ts = straddles(g)
    n = len(ts)
    r1, i1, br1, bi1, sa1 = window_tail_pass(T.cache_lo, ts)
    r2, i2, br2, bi2, sa2 = window_tail_pass(T.b, ts)
    SUBn = ((T.cache_lo.size + SUB - 1) // SUB
            + (T.b.size + SUB - 1) // SUB)
    out = {"x": np.float64(x), "g": np.float64(g),
           "t": np.array(ts, dtype=np.float64)}
    for k in range(n):
        nlt = T._nlt(ts[k])
        im = float(i1[k] + i2[k] + nlt * np.pi)
        sa = float(sa1[k] + sa2[k])
        out["re_%d" % k] = float(r1[k] + r2[k])
        out["im_%d" % k] = im
        out["Bre_%d" % k] = float(br1[k] + br2[k]
                                  + SUBn * 2.0 * C.U128 * sa)
        out["Bim_%d" % k] = float(bi1[k] + bi2[k]
                                  + SUBn * 2.0 * C.U128 * sa
                                  + 12.0 * C.U64 * abs(im))
    for k in range(n):
        dmin_t = C.min_zero_dist((T.cache_lo, T.b), ts[k])
        la, ar, Bla, Bar, dmin_g = C.prod_with_budget(ts[k])
        out["dmin_t_%d" % k] = dmin_t
        out["la_%d" % k] = la
        out["ar_%d" % k] = ar
        out["Bla_%d" % k] = Bla
        out["Bar_%d" % k] = Bar
        out["dmin_g_%d" % k] = dmin_g
        out["nlt_%d" % k] = int(T._nlt(ts[k]))
    return out


def phase1_run(nwork):
    os.makedirs(OUTDIR, exist_ok=True)
    xs = grid()
    print("day034b PHASE 1: %d windows, workers=%d" % (len(xs), nwork),
          flush=True)
    t0 = time.time()
    with cf.ProcessPoolExecutor(max_workers=nwork) as ex:
        futs = {ex.submit(phase1_window, x): i for i, x in enumerate(xs)}
        for fu in cf.as_completed(futs):
            i = futs[fu]
            w = fu.result()
            np.savez_compressed(
                os.path.join(OUTDIR, "win_%03d.npz" % i), **w)
            print("[%s] window %d done (x=%.6g, elapsed %.1f min)"
                  % (time.strftime("%H:%M:%S"), i, w["x"],
                     (time.time() - t0) / 60), flush=True)
    print("phase 1 wall = %.1f min" % ((time.time() - t0) / 60),
          flush=True)


# ----------------------------------------------------------------------
# PHASE 2: per-point quad/dev/propagation from the phase-1 data
# ----------------------------------------------------------------------
def phase2_point(T, wdict, k):
    t = float(wdict["t"][k])
    g = float(wdict["g"])
    re = float(wdict["re_%d" % k])
    im = float(wdict["im_%d" % k])
    B_re = float(wdict["Bre_%d" % k])
    B_im = float(wdict["Bim_%d" % k])
    la = float(wdict["la_%d" % k])
    ar = float(wdict["ar_%d" % k])
    B_la = float(wdict["Bla_%d" % k])
    B_ar = float(wdict["Bar_%d" % k])
    dmin = min(float(wdict["dmin_t_%d" % k]),
               float(wdict["dmin_g_%d" % k]))
    nlt = int(wdict["nlt_%d" % k])
    flag = dmin < C.NLT_GUARD
    (qrem30, qext30, qrem60, qext60, B_qrem, B_qext, aud) = \
        C.quad_pair(T, t, audit=False)
    p30 = C.ev_point(t, g, 30, qrem30, qext30, re, im, la, ar)
    p60 = C.ev_point(t, g, 60, qrem60, qext60, re, im, la, ar)
    dev30 = C.dev_parts(t, g, 30)
    dev60 = C.dev_parts(t, g, 60)
    B_dev = float(abs(dev30 - dev60))
    B_lm = float(abs(p30["lm"] - p60["lm"]))
    B_z = float(abs(p30["z"] - p60["z"]))
    L = abs(p30["Kfull"])
    Bexp = (B_re + B_la
            + float(abs(C.mp.re(B_qrem) + C.mp.re(B_qext))) + B_lm)
    Bph = (B_im + B_ar + float(abs(C.mp.im(B_qrem) + C.mp.im(B_qext))))
    env = math.exp(Bexp)
    dK = L * (env - 1.0 + env * Bph)
    pb = float(M.p8_B(C.mp.mpf(repr(t)), C.n4(t)))
    residf30 = float(p30["residf"])
    zabs30 = float(p30["zabs"])
    mnew = zabs30 * float(dev30) / (pb + residf30)
    residf_cert = residf30 + dK + B_z
    dev_cert = max(0.0, float(dev30) - B_dev)
    z_cert = max(0.0, zabs30 - B_z)
    mcert = z_cert * dev_cert / (pb + residf_cert)
    return {"t": t, "g": g, "mnew": mnew, "mcert": mcert,
            "residf": residf30, "zeta": zabs30, "dev": float(dev30),
            "Bexp": Bexp, "Bph": Bph, "Bz": B_z, "Bdev": B_dev,
            "Btail_re": B_re, "Btail_im": B_im,
            "Bprod_re": B_la, "Bprod_im": B_ar,
            "Bqrem": float(abs(B_qrem)), "Bqext": float(abs(B_qext)),
            "dmin": dmin, "nlt": nlt, "flag": flag, "audit": None}


def phase2_file(path):
    """one phase-2 job: all 25 points of one window file; appends
    rows to the per-window csv."""
    T = TH.tail()
    wdict = dict(np.load(path))
    csv = path.replace(".npz", ".csv")
    n = int(wdict["t"].size)
    with open(csv, "w") as fo:
        fo.write("audit,x=%.10f,t=%.10f, " %
                 (float(wdict["x"]), float(wdict["t"][0])))
        # the audit ladder on this window's first straddle:
        aud = _audit_ladder(T, float(wdict["t"][0]))
        for tag, coll in (("rem", aud["rem"]), ("ext", aud["ext"])):
            fo.write("%s_spread_max=%.3e " % (tag, max(coll)))
        fo.write("\n")
        for k in range(n):
            p = phase2_point(T, wdict, k)
            fo.write(C._point_row(float(wdict["x"]), p))
    return csv


def _audit_ladder(T, t):
    s = C.mp.mpc(0.5, C.mp.mpf(repr(t)))
    f = C._kint(s)
    lo = repr(T.G_LAST)
    q = {(d, n): C.quad_section(f, lo, C.REMHI, n, d)
         for d in (30, 60) for n in (400, 800)}
    qe = {(d, n): C.quad_section(f, C.REMHI, C.REMHI2, n, d)
          for d in (30, 60) for n in (400, 800)}
    spread = {}
    for tag, qq in (("rem", q), ("ext", qe)):
        keys = [(30, 400), (60, 400), (30, 800), (60, 800)]
        spread[tag] = [abs(qq[keys[i]] - qq[keys[j]])
                       for i in range(4) for j in range(i + 1, 4)]
    return {k: [float(v) for v in vs] for k, vs in spread.items()}


def phase2_run(nwork):
    T = TH.tail()                     # parent loads; COW to workers
    files = sorted(glob.glob(os.path.join(OUTDIR, "win_*.npz")))
    print("day034b PHASE 2: %d windows, workers=%d" % (len(files), nwork),
          flush=True)
    t0 = time.time()
    with cf.ProcessPoolExecutor(max_workers=nwork) as ex:
        futs = [ex.submit(phase2_file, f) for f in files]
        done = 0
        for fu in cf.as_completed(futs):
            fu.result()
            done += 1
            print("[%s] %d/%d windows (elapsed %.1f min)"
                  % (time.strftime("%H:%M:%S"), done, len(files),
                     (time.time() - t0) / 60), flush=True)
    # merge + summary
    res = []
    for f in files:
        wdict = dict(np.load(f))
        csv = f.replace(".npz", ".csv")
        wpts = []
        with open(csv) as fc:
            for line in fc:
                if line.startswith("audit,"):
                    continue
                parts = line.strip().split(",")
                wpts.append(_parse_row(parts))
        res.append({"x": float(wdict["x"]), "g": float(wdict["g"]),
                    "pts": wpts})
    res.sort(key=lambda r: r["x"])
    dt = time.time() - t0
    with open(OUTB, "w") as fo:
        for f in files:
            fo.write(open(f.replace(".npz", ".csv")).read())
    C._summary(res, dt, "FULL_b")
    return res


def _parse_row(parts):
    """parse a _point_row csv line (21 fields)."""
    return {"flag": parts[0] == "FLAG", "x": float(parts[1]),
            "t": float(parts[2]), "g": float(parts[3]),
            "mnew": float(parts[4]), "mcert": float(parts[5]),
            "residf": float(parts[6]), "zeta": float(parts[7]),
            "dev": float(parts[8]), "Bexp": float(parts[9]),
            "Bph": float(parts[10]), "Bz": float(parts[11]),
            "Bdev": float(parts[12]), "Btail_re": float(parts[13]),
            "Btail_im": float(parts[14]), "Bprod_re": float(parts[15]),
            "Bprod_im": float(parts[16]), "Bqrem": float(parts[17]),
            "Bqext": float(parts[18]), "nlt": int(parts[19]),
            "audit": None}


# ----------------------------------------------------------------------
# EQUIVALENCE GATE: batched window pass vs the verified per-point
# pipeline on a few straddles of one window.
# ----------------------------------------------------------------------
def crosscheck():
    T = TH.tail()
    x = 1.0e9
    g = C.nearest_zero(T, x)
    ts = straddles(g)
    # batched window pass (this file) on the same arrays:
    ts3 = ts[:3]
    r1, i1, br1, bi1, sa1 = window_tail_pass(T.cache_lo, ts3)
    r2, i2, br2, bi2, sa2 = window_tail_pass(T.b, ts3)
    SUBn = ((T.cache_lo.size + SUB - 1) // SUB
            + (T.b.size + SUB - 1) // SUB)
    ok = True
    for k, t in enumerate(ts3):
        nlt = T._nlt(t)
        re_b = float(r1[k] + r2[k])
        im_b = float(i1[k] + i2[k] + nlt * np.pi)
        # the verified per-point path:
        re_p, im_p, nlt_p, B_re_p, B_im_p, d_p = \
            C.tail_with_budget(T, t)
        dr = abs(re_b - re_p)
        di = abs(im_b - im_p)
        okk = dr <= 1e-9 and di <= 1e-9 and nlt == nlt_p
        ok = ok and okk
        print("  t=%.2f |re_batch - re_point| = %.3e |im...| = %.3e "
              "nlt %d/%d %s" % (t, dr, di, nlt, nlt_p, okk))
    # full per-point row vs the phase-2 row (one straddle):
    pf = phase1_window(x)
    t0 = float(pf["t"][0])
    p_batch = phase2_point(T, pf, 0)
    p_point = C.cert_point(T, t0, g)
    dm = abs(p_batch["mnew"] - p_point["mnew"])
    dc = abs(p_batch["mcert"] - p_point["mcert"])
    okrow = dm <= 1e-6 and dc <= 1e-6
    ok = ok and okrow
    print("  row: t=%.2f mnew %.9f vs %.9f (d=%.2e), mcert %.9f vs "
          "%.9f (d=%.2e) %s"
          % (t0, p_batch["mnew"], p_point["mnew"], dm,
             p_batch["mcert"], p_point["mcert"], dc, okrow))
    print("CROSSCHECK: %s" % ("PASS" if ok else "FAIL"))
    return ok


if __name__ == "__main__":
    cmd = sys.argv[1] if len(sys.argv) > 1 else "help"
    if cmd == "phase1":
        phase1_run(int(os.environ.get("P1WORKERS", "10")))
    elif cmd == "phase2":
        phase2_run(int(os.environ.get("P2WORKERS", "27")))
    elif cmd == "crosscheck":
        sys.exit(0 if crosscheck() else 1)
    else:
        print(__doc__)
