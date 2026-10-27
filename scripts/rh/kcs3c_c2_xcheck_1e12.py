#!/usr/bin/env python3
# Cross-check: fresh 2-worker recomputation of the 1e12 run (post-astype-
# fix, post-worker-split) vs the frozen 0192 records.  ALL record fields
# must match exactly (9 numeric fields x 24 windows); plus the pi(1e12)
# identity and the boundary-margin check.  Shard-only on failure-safe
# scratch shards; never touches the frozen checkpoint.

import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import kcs3c_c2_figcheck_1e11_1e12 as fs  # noqa: E402

X = 10 ** 12
DIR = fs.DIR
frozen = json.load(open(os.path.join(DIR, "ckpt_%d.json" % X)))
frozen = {r["i"]: r for r in frozen}
fresh = {}
for K in (0, 1):
    sh = os.path.join(DIR, "ckpt_%d_w%dof%d.json" % (X, K, 2))
    for r in json.load(open(sh)):
        fresh[r["i"]] = r
assert set(fresh) == set(frozen) == set(range(20)), (len(fresh), len(frozen))
FIELDS = ["A", "B", "p11", "p13", "p31", "p33", "n", "gn", "godd",
          "first", "last"]
bad = 0
for i in sorted(frozen):
    for f in FIELDS:
        a, b = frozen[i][f], fresh[i][f]
        if a != b:
            bad += 1
            print("MISMATCH window %d field %s: frozen=%r fresh=%r"
                  % (i, f, a, b))
pi_f = sum(r["n"] for r in frozen.values())
pi_n = sum(r["n"] for r in fresh.values())
print("records: 20/20 windows compared")
print("mismatched field values: %d" % bad)
print("pi(1e12): frozen %d  fresh %d  table 37,607,912,018  ->  %s"
      % (pi_f, pi_n,
         "IDENTITY" if pi_f == pi_n == 37607912018 else "MISMATCH"))
# boundary margins (fresh records)
recs = [fresh[i] for i in sorted(fresh)]
maxgap = max(recs[j + 1]["first"] - recs[j]["last"] for j in range(19))
print("max boundary gap: %d (margin %d) -> %s"
      % (maxgap, fs.MARGIN, "OK" if maxgap <= fs.MARGIN else "EXCEEDED"))
sys.exit(1 if (bad or pi_f != pi_n or pi_n != 37607912018
               or maxgap > fs.MARGIN) else 0)
