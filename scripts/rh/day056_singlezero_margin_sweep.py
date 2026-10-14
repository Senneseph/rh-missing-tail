#!/usr/bin/env python3
"""day056 -- single-zero-resolution margin sweep (the adjudicating
experiment of VALIANT-EFFORT-FORENSICS 3.10).

The S side is already measured (s0_singlezero_swalk: S is rough at
zero scale -- median |dS| ~ 0.25 per 0.025 t-step, ~15-17 zero
crossings in 5 t-units).  This script measures the OTHER side:
the engine's margin mnew(t) at the same 0.025 t-steps, at three
ledger anchors (band head, mid ~1e10, band top).

FAST CHAIN (no engine change;  the certified chain is verbatim):
  mnew uses ONLY the dps-30 arm of cert_point
      mnew = zabs30 * dev30 / (pb + residf30)
  so the dps-60 budget arm (the bulk of the 15 min/point cost)
  is dropped.  The same engine functions are called, unmodified:
  tail_with_budget, prod_with_budget, quad_section (x2, dps-30,
  400 nodes each), ev_point(dps-30), dev_parts(dps-30), p8_B, n4.

VALIDATION:  at each anchor the chain is re-run at the LEDGER's
own six nearest straddle t = g + k/2 (|k| <= 3) and compared
against the certified dps-30 mnew stored in
out_day052c_696/points.jsonl.  Agreement to ~1e-12 is expected
(same dps arm, same expressions, deterministic mpmath).

RUN (owner core rule: 14 of 16 cores, cores 14-15 reserved,
single-thread workers):
  SMOKE=1 taskset -c 0-13 env OMP_NUM_THREADS=1 \\
      /home/jsmille/venvs/smud/bin/python day056_singlezero_margin_sweep.py
  taskset -c 0-13 env OMP_NUM_THREADS=1 \\
      /home/jsmille/venvs/smud/bin/python day056_singlezero_margin_sweep.py
"""
import concurrent.futures as cf
import json
import math
import os
import sys
import threading
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import day037_h1_3e10 as D          # the engine (unmodified)
import day023_p11c_1e7 as M         # p8_B, R_closed (via the engine's own import)
from mpmath import mp

R_H = D.R_H
OUT = R_H + "/tmp/day056_margin_sweep.jsonl"
LEDGER = R_H + "/scripts/rh/out_day052c_696/points.jsonl"

STEP = 0.025
HALF = 1.5          # sweep [g-1.5, g+1.5]
N_J = 60            # 121 grid points per anchor
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)   # owner core cap

# ----------------------------------------------------------------------
# engine plumbing (per-process, picklable)
# ----------------------------------------------------------------------
_T = threading.local()


def _get_T():
    t = getattr(_T, "t", None)
    if t is None:
        t = D.Tail3E10(verbose=False)
        _T.t = t
    return t


def fast_margin(T, tf, g):
    """the dps-30 arm of cert_point, verbatim;  returns mnew + parts."""
    (re, im, nlt, B_re, B_im, dmin_t) = D.tail_with_budget(T, tf)
    (la, ar, B_la, B_ar, dmin_g) = D.prod_with_budget(tf)
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    f = D._kint(s)
    lo = repr(T.G_LAST)
    rem30 = D.quad_section(f, lo, D.REMHI, 400, 30)
    ext30 = D.quad_section(f, D.REMHI, D.REMHI2, 400, 30)
    p30 = D.ev_point(tf, g, 30, rem30, ext30, re, im, la, ar)
    dev30 = D.dev_parts(tf, g, 30)
    zabs30 = float(p30["zabs"])
    residf30 = float(p30["residf"])
    dmin = min(dmin_t, dmin_g)
    pb = float(M.p8_B(mp.mpf(repr(tf)), D.n4(tf)))
    mnew = zabs30 * float(dev30) / (pb + residf30)
    return {"t": tf, "g": g, "mnew": mnew, "zabs": zabs30,
            "residf": residf30, "dev": float(dev30), "pb": pb,
            "dmin": dmin, "nlt": nlt, "Kabs": float(abs(p30["Kfull"]))}


def S_of_t(tf, dps=25):
    """S(t) = (1/pi) arg zeta(1/2+it),  canonical branch.
    Only the STEP DIFFERENCES dS are used (unwrap below)."""
    mp.dps = dps
    z = mp.zeta(mp.mpc(0.5, mp.mpf(repr(tf))))
    return float(mp.arg(z)) / math.pi


def dS_unwrapped(t0, t1):
    d = S_of_t(t1) - S_of_t(t0)
    d = (d + math.pi) % (2 * math.pi) - math.pi
    return d


# ----------------------------------------------------------------------
# ledger cross-check data
# ----------------------------------------------------------------------
def load_ledger_anchors():
    xs = {}
    with open(LEDGER) as fo:
        for line in fo:
            r = json.loads(line)
            x = r["x"]
            xs.setdefault(x, []).append(
                {"k": r["k"], "t": r["t"], "g": r["g"],
                 "mnew": r["p"]["mnew"]})
    return xs


# ----------------------------------------------------------------------
# jobs
# ----------------------------------------------------------------------
def build_jobs(anchors, xs_ledger):
    """anchors: list of x.  jobs: (x, g, tlist, tag)."""
    T = _get_T()
    jobs = []
    for x in anchors:
        g = D.nearest_zero(T, x)
        ledger = [r for r in xs_ledger[x] if abs(r["g"] - g) < 1e-9]
        assert ledger, "ledger rows must match driver g for x=%r" % x
        grid = [g + STEP * j for j in range(-N_J, N_J + 1)]
        # cross-check t's: the 6 ledger rows nearest to g.  For full
        # anchors (24 rows) these are exactly |k| <= 3;  the two short
        # anchors (21 / 4 rows) get whatever they carry.
        cc = sorted(ledger, key=lambda r: abs(r["t"] - g))[:6]
        assert cc, "anchor must carry ledger rows"
        nblk = 5
        per = (len(grid) + nblk - 1) // nblk
        for bi in range(nblk):
            chunk = grid[bi * per:(bi + 1) * per]
            jobs.append((x, g, chunk, "grid%d" % bi))
        jobs.append((x, g, [r["t"] for r in cc], "xcheck"))
    return jobs


def _worker(job):
    x, g, tlist, tag = job
    T = _get_T()
    rows = []
    for i, tf in enumerate(tlist):
        r0 = time.time()
        r = fast_margin(T, tf, g)
        r["x"] = x
        r["tag"] = tag
        r["sec"] = time.time() - r0
        rows.append(r)
        if tag == "xcheck" and (i + 1) % 6 == 0:
            print("  xcheck done x=%.4g g=%.4g" % (x, g), flush=True)
    return rows


# ----------------------------------------------------------------------
def main():
    smoke = os.environ.get("SMOKE") == "1"
    t0 = time.time()
    xs_ledger = load_ledger_anchors()
    xs = sorted(xs_ledger)
    anchors = [xs[0]] if smoke else (
        [xs[0], min(xs, key=lambda v: abs(v - 1.0e10)), xs[-1]]
        if len(xs) >= 3 else xs)
    print("day056 single-zero margin sweep:  %d anchors, step=%.3f, "
          "workers=%d, smoke=%s" % (len(anchors), STEP, WORKERS, smoke),
          flush=True)
    T = _get_T()
    for x in anchors:
        g = D.nearest_zero(T, x)
        print("  anchor x=%.12f  g=%.12f  spacing-side zeros: ledger rows=%d"
              % (x, g, len(xs_ledger[x])), flush=True)

    if smoke:
        jobs = []
        x = anchors[0]
        g = D.nearest_zero(T, x)
        grid = [g + STEP * j for j in range(-8, 9)]
        cc = [r["t"] for r in sorted(xs_ledger[x], key=lambda r: abs(r["g"] - g))[:6]]
        jobs.append((x, g, grid, "grid"))
        jobs.append((x, g, sorted(cc), "xcheck"))
        WORK = 1
    else:
        jobs = build_jobs(anchors, xs_ledger)
        WORK = WORKERS

    rows = []
    with open(OUT, "w") as fo:
        fo.write("# day056 single-zero margin sweep workers=%d "
                 "step=%.3f smoke=%s %s\n"
                 % (WORK, STEP, smoke, time.strftime("%Y-%m-%d %H:%M:%S")))
        fo.flush()
        if WORK == 1:
            for j in jobs:
                for r in _worker(j):
                    rows.append(r)
                    fo.write(json.dumps(r) + "\n")
        else:
            with cf.ProcessPoolExecutor(max_workers=WORK) as ex:
                futs = [ex.submit(_worker, j) for j in jobs]
                for fu in cf.as_completed(futs):
                    for r in fu.result():
                        rows.append(r)
                        fo.write(json.dumps(r) + "\n")
                    fo.flush()

    # ---------------- cross-check vs the certified ledger ------------
    print("\n=== cross-check:  fast chain vs certified dps-30 ledger "
          "mnew ===", flush=True)
    ok = True
    maxd = 0.0
    by_xtag = {}
    for r in rows:
        by_xtag.setdefault((r["x"], r["tag"]), []).append(r)
    for x in anchors:
        for r in sorted(by_xtag.get((x, "xcheck"), []), key=lambda v: v["t"]):
            led = [r2 for r2 in xs_ledger[x]
                   if abs(r2["t"] - r["t"]) < 1e-9]
            if not led:
                print("  !! no ledger match for t=%r x=%r" % (r["t"], x))
                ok = False
                continue
            d = abs(r["mnew"] - led[0]["mnew"])
            maxd = max(maxd, d)
            line = ("  x=%.4g k=%+d  certified=%.12f  fast=%.12f  "
                    "|d|=%.3e" % (x, led[0]["k"], led[0]["mnew"],
                                  r["mnew"], d))
            print(line, flush=True)
            if d > 1e-9:
                ok = False
    print("cross-check max |d| = %.3e   %s"
          % (maxd, "PASS (< 1e-9)" if ok else "FAIL"), flush=True)

    # ---------------- S side on the same grid (aligned) --------------
    print("\n=== per-step roughness, 0.025 steps ===", flush=True)
    gridrows = {}
    for r in rows:
        if r["tag"].startswith("grid"):
            gridrows.setdefault(r["x"], []).append(r)
    for x in anchors:
        gr = sorted(gridrows.get(x, []), key=lambda v: v["t"])
        if len(gr) < 3:
            continue
        dm = [abs(gr[i + 1]["mnew"] - gr[i]["mnew"]) for i in range(len(gr) - 1)]
        dm.sort()
        n = len(dm)
        # one zero spacing at these heights ~ 0.28-0.31;  ~12-13 steps
        mstep = math.ceil(0.30 / STEP)
        dm_sp = [abs(gr[i + mstep]["mnew"] - gr[i]["mnew"])
                 for i in range(0, len(gr) - mstep, mstep)]
        ds = [abs(dS_unwrapped(gr[i]["t"], gr[i + 1]["t"]))
              for i in range(len(gr) - 1)]
        ds.sort()
        print("  x=%.4g  n=%d" % (x, n), flush=True)
        for lbl, arr in (("dS  ", ds), ("dm  ", dm)):
            a = [v for v in arr]
            med = a[len(a) // 2]
            mean = sum(a) / len(a)
            print("    %s median|.|=%.4g mean=%.4g max=%.4g "
                  "p99=%.4g n(>0.05)=%d n(>0.5)=%d"
                  % (lbl, med, mean, a[-1], a[int(0.99 * (len(a) - 1))],
                     sum(1 for v in a if v > 0.05),
                     sum(1 for v in a if v > 0.5)), flush=True)
        a = dm_sp
        med = a[len(a) // 2]
        mean = sum(a) / len(a)
        print("    dm at ~1 zero-spacing (every %d steps):  median=%.4g "
              "mean=%.4g max=%.4g" % (mstep, med, mean, a[-1]), flush=True)

    print("\nday056 done in %.1f s (wall)" % (time.time() - t0), flush=True)


if __name__ == "__main__":
    main()
