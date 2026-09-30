"""day053c: band-free dps-120 ld-exact margin pass for the 696
points whose 80-bit streams day053 stored in
out_day053_696/windows.jsonl (extras[k].ld).

Why separate:  the sweep (the band read) is the one expensive
part and is DONE after day053;  the dps-120 margin needs only
the stored stream values + pure mpmath (zeta, logmain,
quad pieces, dev at dps-120) + the pure f64 prod --  no band
at all.  So this pass is ~3 min/point of mpmath,  ran at 14
workers,  and lands the uniform high-precision layer for all
696 points.

Skips points that already carry an m120 value (the 24
verification points computed in-run).

Launch:  taskset -c 0-13 nohup python3 day053c_m120_fill.py
  > out_day053c.log 2>&1 &
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37          # noqa: E402
import day053_reissue_696_vec as V    # noqa: E402

JSONL = HERE + "/out_day053_696/windows.jsonl"
OUT = HERE + "/out_day053_696/m120"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)
GL = None


def _gl():
    """the file-anchored G_LAST (last stored zero)."""
    global GL
    if GL is None:
        GL = float(D37._first_last(D37.D_F)[1])
    return GL


def fast_core_120_bf(t, g):
    """band-free fast_core_120 (no Tail3E10;  G_LAST from file)."""
    from mpmath import mp
    mp.dps = 120
    s = mp.mpc(0.5, mp.mpf(repr(t)))
    z = mp.zeta(s)
    lm = D37.logmain25212(s)
    qrem = D37.quad_section(D37._kint(s), repr(_gl()), D37.REMHI,
                            400, 120)
    qext = D37.quad_section(D37._kint(s), D37.REMHI, D37.REMHI2, 400,
                            120)
    dev = D37.dev_parts(t, g, 120)
    (la, ar, _b1, _b2, _dm) = D37.prod_with_budget(t)
    return {"z": z, "lm": lm, "qrem": qrem, "qext": qext, "dev": dev,
            "la": la, "ar": ar, "t": t}


def do_point(job):
    t, g, x, k, ld = job
    fc = fast_core_120_bf(t, g)
    m = V.day050_margin_120(fc, ld)
    return (x, k, m)


def main():
    jobs = []
    with open(JSONL) as fh:
        for ln in fh:
            w = json.loads(ln)
            x, g = w["x"], w["g"]
            for ks, ex in w.get("extras", {}).items():
                if ex.get("m120_ld"):
                    continue
                k = int(ks)
                t = float(g) + k / 2.0
                jobs.append((t, g, x, k, ex["ld"]))
    os.makedirs(OUT, exist_ok=True)
    todo = [j for j in jobs
            if not os.path.exists(OUT + "/pt_%d_k%+d.json" % (j[2], j[3]))]
    print("day053c: %d points total, %d to do, workers=%d"
          % (len(jobs), len(todo), WORKERS), flush=True)
    if not todo:
        print("nothing to do", flush=True)
        return
    t0 = time.time()
    n = 0
    import multiprocessing as mp
    with mp.Pool(WORKERS) as pool:
        for (x, k, m) in pool.imap_unordered(do_point, todo):
            n += 1
            with open(OUT + "/pt_%d_k%+d.json" % (x, k), "w") as fh:
                json.dump(m, fh)
            if n % 24 == 0 or n == len(todo):
                print("  %d/%d m120 done (%.1f min elapsed, last k=%+d "
                      "m120=%.9f)" % (n, len(todo),
                                      (time.time() - t0) / 60.0, k,
                                      m["mnew"]), flush=True)
    print("day053c DONE: %d points in %.1f min"
          % (len(todo), (time.time() - t0) / 60.0), flush=True)


if __name__ == "__main__":
    main()
