#!/usr/bin/env python3
# Strided window worker for the kcs3c_c2 1e11/1e12/1e13 runs.
#
# Usage:
#   python3 kcs3c_c2_worker.py K N X [--fresh]
#     K   worker id (0..N-1); handles windows i with i % N == K
#     N   worker count (2)
#     X   target (e.g. 10000000000000)
#     --fresh  ignore the main checkpoint entirely (cross-check mode:
#              computes ALL windows with i % N == K, shard-only)
#
# Memory rationale (2026-10-27, 0197 ops note): after removing the
# redundant astype copy in interval_sieve, the per-window peak is ~40 GB
# (was the 56.2 GB high-water of record); two concurrent workers peak at
# ~80 GB on 124 GB total, ~28 GB headroom. 3+ workers do not fit.
#
# Shard checkpoints: tmp/u3c_c_fig/ckpt_<X>_w<K>of<N>.json (one file per
# worker, no shared writes, resumable).  The main checkpoint ckpt_<X>.json
# is only READ (for the done-set on startup) and never written here.

import gc
import json
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kcs3c_c2_figcheck_1e11_1e12 as fs  # noqa: E402


def main():
    argv = [a for a in sys.argv[1:]]
    fresh = "--fresh" in argv
    argv = [a for a in argv if a != "--fresh"]
    K, N, X = int(argv[0]), int(argv[1]), int(argv[2])
    assert 0 <= K < N
    ckpt_main = os.path.join(fs.DIR, "ckpt_%d.json" % X)
    shard = os.path.join(fs.DIR, "ckpt_%d_w%dof%d.json" % (X, K, N))
    done = {}
    if os.path.exists(ckpt_main) and not fresh:
        for r in json.load(open(ckpt_main)):
            done[r["i"]] = True
    myrecs = {}
    if os.path.exists(shard):
        for r in json.load(open(shard)):
            myrecs[r["i"]] = r
    nwin = (X + fs.W - 1) // fs.W
    mine = [i for i in range(K, nwin, N)]
    todo = [i for i in mine if i not in done and i not in myrecs]
    print("worker %d/%d target %d: %d windows total, %d todo, shard %s"
          % (K, N, X, len(mine), len(todo), shard), flush=True)
    for i in todo:
        t0 = time.time()
        rec = fs.window_tally(i, X)
        myrecs[i] = rec
        json.dump([myrecs[j] for j in sorted(myrecs)], open(shard, "w"))
        gc.collect()
        print("  worker %d window %3d: n = %13d   %6.1f s   peak %.1f MB"
              % (K, i, rec["n"], rec["dt"], rec["rss_mb"]), flush=True)
    print("WORKER %d of %d DONE (shard has %d records)"
          % (K, N, len(myrecs)), flush=True)
    json.dump([myrecs[j] for j in sorted(myrecs)], open(shard, "w"))


if __name__ == "__main__":
    main()
