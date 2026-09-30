"""day052: full-696 re-issue of the 3e10 H1 ledger with the FIXED
engine (adjacent-pair quad_pair + |K| ~ O(|z|) assembly guard,
committed in day037/day038).

This is the ledger replacement:  every (window x,  k in
-12..-1, +1..+12) point is recomputed through the engine's own
certificate arm  (f64 tail with budgets,  dps-30/60 mpmath
fast parts,  B-expansions,  margin_new and margin_cert)  and
written in the fleet's own 21-column row format
(D37._point_row).

Resume-safe:  each completed window is appended to
reissue_windows.jsonl  BEFORE the .pts view is updated;  a
restarted run skips windows already in the JSONL.  Never
touches the artifact ledger files (read-only selection
sources)  nor out_day037_h1_3e10.txt.

Launch (owner core rule:  14 of 16 physical cores,
cores 14-15 reserved,  each worker single-core):
  taskset -c 0-13 env OMP_NUM_THREADS=1 \
    nohup python3 day052_reissue_696.py > out_day052_696.log 2>&1 &
"""
import concurrent.futures as cf
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37          # noqa: E402  (fixed engine)

OUTDIR = HERE + "/out_day052_696"
os.makedirs(OUTDIR, exist_ok=True)
JSONL = OUTDIR + "/reissue_windows.jsonl"
PTS = OUTDIR + "/reissue_696_3e10.pts"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)   # core cap


def load_done():
    done = {}
    if os.path.exists(JSONL):
        with open(JSONL) as fh:
            for ln in fh:
                w = json.loads(ln)
                done[float(w["x"])] = w
    return done


def main():
    st0 = time.time()
    ok = D37.selftest_core()
    print("SELFTEST_CORE ok=%s (%.1f s)" % (ok, time.time() - st0),
          flush=True)
    assert ok, "selftest failed -- not re-issuing"

    xs = D37.grid()
    print("day052: %d windows, %d points, workers=%d"
          % (len(xs), len(xs) * 24, WORKERS), flush=True)
    done = load_done()
    pending = [x for x in xs if x not in done]
    if done:
        print("resume: %d windows already done, %d pending"
              % (len(done), len(pending)), flush=True)

    fo = open(PTS, "a")
    fo.write("# day052 re-issue 696 fixed-engine %s workers=%d %s\n"
             % ("RESUME" if done else "FRESH", WORKERS,
                time.strftime("%Y-%m-%d %H:%M:%S")))
    fo.flush()
    t0 = time.time()
    new = []
    if pending:
        with cf.ProcessPoolExecutor(max_workers=WORKERS) as ex:
            futs = {ex.submit(D37._worker, x): x for x in pending}
            for fu in cf.as_completed(futs):
                w = fu.result()
                with open(JSONL, "a") as jf:
                    jf.write(json.dumps(
                        {"x": w["x"], "g": w["g"],
                         "pts": w["pts"],
                         "wall_min": (time.time() - t0) / 60.0})
                        + "\n")
                D37._emit(fo, w, t0)
                new.append(w)
    fo.close()

    allw = [done[float(x)] for x in xs if float(x) in done] + new
    allw.sort(key=lambda r: r["x"])
    npts = sum(len(w["pts"]) for w in allw)
    dt = time.time() - st0
    print("== day052 re-issue: %d windows / %d points, wall %.1f s =="
          % (len(allw), npts, dt), flush=True)
    D37._summary(allw, dt, "REISSUE-696")


if __name__ == "__main__":
    main()
