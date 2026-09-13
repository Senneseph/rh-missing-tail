#!/usr/bin/env python3
"""Day-023 — repair-list supervisor: 32 parallel zero-walk segments
covering (6e6, 1e7], then merge + final check.  Expected wall ~2.5-3 h
(measured rate, DISCOVERY_LOG 21 / day023 bench)."""
import os
import subprocess
import sys
import time

ROOT = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
WORKER = os.path.join(ROOT, "day023_ext1e7_seg.py")
W0G, W1G = 6.0e6, 1.0e7
NSEG = 32
SEGW = (W1G - W0G) / NSEG          # 125_000.0


def main():
    os.makedirs(os.path.join(ROOT, "ext1e7"), exist_ok=True)
    jobs = []
    logs = []
    for k in range(NSEG):
        s0 = W0G + k * SEGW
        s1 = W0G + (k + 1) * SEGW
        if k == NSEG - 1:
            s1 = W1G
        logfile = os.path.join(ROOT, "ext1e7", "seg%02d.log" % k)
        lf = open(logfile, "w")
        p = subprocess.Popen([sys.executable, WORKER, str(k),
                              "%.1f" % s0, "%.1f" % s1],
                             cwd=os.path.join(ROOT, "ext1e7"),
                             stdout=lf, stderr=subprocess.STDOUT)
        jobs.append((k, s0, s1, p, logfile))
        logs.append(logfile)
    print("launched %d segments (segw=%.1f); logs in %s" % (
        NSEG, SEGW, os.path.join(ROOT, "ext1e7")), flush=True)
    t0 = time.time()
    failed = []
    for (k, s0, s1, p, logfile) in jobs:
        rc = p.wait()
        if rc != 0:
            failed.append((k, s0, s1, rc, logfile))
    print("all segments done: wall %.1f min; failures: %r"
          % ((time.time() - t0) / 60.0, failed), flush=True)
    if failed:
        print("MERGE SKIPPED (certificate failures present)")
        sys.exit(1)
    # merge
    import numpy as np
    arrs = []
    total = 0
    for (k, s0, s1, p, logfile) in jobs:
        f = os.path.join(ROOT, "ext1e7",
                         "flips_seg%d_%09d_%09d_dt2.txt" % (k, int(s0),
                                                            int(s1)))
        a = np.loadtxt(f)
        assert a.size > 0 and a[0] > s0 - 1e-9 and a[-1] <= s1 + 1e-9, \
            "seg %d range violated" % k
        arrs.append(a)
        total += a.size
    ext = np.concatenate(arrs)
    ext.sort()
    gmin = float(np.diff(ext).min())
    n_base = np.loadtxt("/home/jsmille/Projects/kainos-logos/scripts/rh/"
                        "zeros_T6000000_ext_full.txt")
    n_w0 = int(np.searchsorted(n_base, W0G))
    n_end = n_w0 + total
    N_main = (W1G / (2.0 * math.pi)) \
        * (math.log(W1G / (2.0 * math.pi)) - 1.0) + 0.375
    print("EXTENSION: %d zeros on (6e6, 1e7]; min gap %.6f" % (total, gmin))
    print("N(1e7) = %d (base %d + ext %d)" % (n_end, n_w0, total))
    print("N_main(1e7) ~ %.2f (|diff| = %.2f)" % (N_main, n_end - N_main))
    full = np.concatenate((n_base, ext))
    out = os.path.join(ROOT, "zeros_T10000000_ext_full.txt")
    np.savetxt(out, full, fmt="%.10e")
    print("WROTE %s (%d zeros, <= %.0f)" % (out, full.size, full[-1]))
    import math  # noqa: E402
    print("SUPERVISOR DONE")


import math  # noqa: E402
if __name__ == "__main__":
    main()
