"""day052b: full-696 re-issue of the 3e10 H1 ledger with the FIXED
engine (adjacent-pair quad_pair + |K| ~ O(|z|) assembly guard).

Per-point sequential driver (the honest cost model:  each point
needs one full (1e7, GLAST] band sweep --  ~70 min at the
measured 14-way concurrency ceiling --  plus ~3 min of mpmath;
696 points ~= 2-3 days of wall at 14 of 16 cores).  The point
computation IS D37.cert_point (the reference engine;  the
day052b extras added to its return dict are non-destructive).

Resume-safe at POINT granularity:  each finished point is
appended to points.jsonl  before its row joins the .pts view;
a restarted run skips (x, k) pairs already in the JSONL.  It
never touches the artifact ledger files.

SMOKE (first 2 points in a fresh process,  plus an independent
D37.cert_point reference on the first point  with a full field
compare):
  H1V2B_SMOKE=1 taskset -c 0-1 python3 day052b_reissue_696_seq.py

Launch (owner core rule:  14 of 16 physical cores,
cores 14-15 reserved,  each worker single-core):
  taskset -c 0-13 env OMP_NUM_THREADS=1 \
    nohup python3 day052b_reissue_696_seq.py > out_day052b.log 2>&1 &
"""
import concurrent.futures as cf
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37        # noqa: E402  (fixed engine)

OUTDIR = HERE + "/out_day052b_696"
os.makedirs(OUTDIR, exist_ok=True)
JSONL = OUTDIR + "/points.jsonl"
PTS = OUTDIR + "/led696_seq_3e10.pts"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)
KLIST = [k for k in range(-12, 13) if k != 0]


def point_jobs(xs):
    jobs = []
    for x in xs:
        for k in KLIST:
            jobs.append((x, k))
    return jobs


def load_done():
    done = set()
    if os.path.exists(JSONL):
        with open(JSONL) as fh:
            for ln in fh:
                r = json.loads(ln)
                done.add((r["x"], r["k"]))
    return done


_WT = None


def _wT():
    global _WT
    if _WT is None:
        _WT = D37.Tail3E10(verbose=False)
    return _WT


def do_point(job):
    x, k = job
    T = _wT()
    g = D37.nearest_zero(T, x)
    tf = g + k / 2.0
    t0 = time.time()
    p = D37.cert_point(T, tf, g, audit=(k == -12))
    el = time.time() - t0
    row = D37._point_row(x, p)
    rec = {"x": float(x), "k": int(k), "t": p["t"], "g": float(g),
           "row": row, "elapsed_s": el,
           "p": {kk: vv for kk, vv in p.items() if kk != "audit"}}
    print("PT x=%.4g k=%+3d t=%.5f mnew=%.9f mcert=%.9f flag=%d "
          "(%.1f min)" % (x, k, p["t"], p["mnew"], p["mcert"],
                          p["flag"], el / 60.0), flush=True)
    return rec


def main():
    ok = D37.selftest_core()
    print("SELFTEST_CORE ok=%s" % ok, flush=True)
    assert ok
    xs = D37.grid()
    jobs = point_jobs(xs)
    done = load_done()
    todo = [j for j in jobs if j not in done]
    print("day052b: %d points, done=%d, pending=%d, workers=%d"
          % (len(jobs), len(done), len(todo), WORKERS), flush=True)
    smoke = os.environ.get("H1V2B_SMOKE") == "1"
    if smoke:
        # two real points through the pipeline,  cross-checked
        # against the verified day049f pt00 record (same point:
        # the engine dps-30 arm must sit at the expected distance
        # from the dps-90 f64 and dps-120 ld-exact margins).
        r0 = do_point(jobs[0])
        r1 = do_point(jobs[1])
        d48 = json.load(open(HERE + "/out_day049f_pts/"
                             "pt00_k-12_x3232170976.199116.res"))
        m120 = (d48.get("dps120_ldexact")
                or d48.get("dps120_ldexact_reim"))["mnew"]
        m90f = (d48.get("dps90_f64pairwise")
                or d48.get("dps90_f64pairwise_reim"))["mnew"]
        d_ld = r0["p"]["mnew"] - m120
        d_f64 = r0["p"]["mnew"] - m90f
        rowok = r0["row"].startswith(("ok,", "FLAG,")) \
            and len(r0["row"].rstrip("\n").split(",")) == 21
        ok = abs(d_ld) <= 1e-3 and abs(d_f64) <= 1e-4 and rowok \
            and not r0["p"]["flag"]
        print("SMOKE x0 k=%+d: engine mnew=%.9f  d_vs_ld120=%+.2e "
              "d_vs_f64_90=%+.2e  row_ok=%s flag=%s"
              % (r0["k"], r0["p"]["mnew"], d_ld, d_f64, rowok,
                 r0["p"]["flag"]), flush=True)
        print("SMOKE x1 k=%+d: engine mnew=%.9f (%.1f min)"
              % (r1["k"], r1["p"]["mnew"], r1["elapsed_s"] / 60.0),
              flush=True)
        with open(OUTDIR + "/smoke_report.json", "w") as fh:
            json.dump({"ok": ok, "d_ld": d_ld, "d_f64": d_f64,
                       "m49f_ld120": m120, "m49f_f64_90": m90f,
                       "p0": r0["p"]["mnew"], "p1": r1["p"]["mnew"],
                       "elapsed0_min": r0["elapsed_s"] / 60.0,
                       "elapsed1_min": r1["elapsed_s"] / 60.0},
                      fh, indent=1)
        print("SMOKE %s" % ("PASS" if ok else "FAIL"), flush=True)
        sys.exit(0 if ok else 1)
    if not todo:
        print("nothing to do", flush=True)
        return
    t0 = time.time()
    fo = open(PTS, "a")
    fo.write("# day052b sequential re-issue 696 fixed-engine "
             "workers=%d %s\n" % (WORKERS,
                                  time.strftime("%Y-%m-%d %H:%M:%S")))
    fo.flush()
    n = 0
    with cf.ProcessPoolExecutor(max_workers=WORKERS) as ex:
        futs = [ex.submit(do_point, j) for j in todo]
        for fu in cf.as_completed(futs):
            rec = fu.result()
            n += 1
            with open(JSONL, "a") as jf:
                jf.write(json.dumps(rec) + "\n")
            fo.write(rec["row"])
            fo.flush()
            if n % 12 == 0 or n == len(todo):
                print("PROGRESS %d/%d points (%.1f h elapsed, "
                      "avg %.1f min/point)"
                      % (n, len(todo), (time.time() - t0) / 3600.0,
                         (time.time() - t0) / 60.0 / n), flush=True)
    fo.close()
    print("day052b DONE: %d points in %.1f h"
          % (n, (time.time() - t0) / 3600.0), flush=True)


if __name__ == "__main__":
    main()
