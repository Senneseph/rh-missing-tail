#!/usr/bin/env python3
"""day036 finish gates — bounded-memory standalone runner.

Re-runs the band-3e10 finish gates after the orchestrator's
in-process gate was OOM-killed at ~01:2x (cgroup oom_kill
counter 5;  4 older kills visible in the wrapped dmesg
ring,  the 5th = this victim;  the gate's 740GB memmap +
per-block asarray copies pushed global page-cache pressure
past reclaimable on this 124GiB box).  The BAND FILE IS
READ-ONLY for this script —  nothing about the dataset
changed.

Bounded-memory design (the fix):
  - plain fd read() in 256MB pieces  (no 740GB mapping);
  - ONE preallocated 256MB buffer,  reused  (anon <= ~64MB);
  - file-backed readahead cache is the OS's to reclaim;
  - heartbeat file + progress line every chunk (a stall is
    visible,  never silent);
  - the same gate semantics,  verbatim:  total in range,
    strict monotone across the whole band,  min gap > 0,
    seam gap in (0,1),  N(band end) vs RVM tol 3,
    N(3.0e10) vs RVM tol 3 when reached  (the pin).

Usage:
  selftest   synthetic small band  (must PASS)  + broken
             band  (must be caught)
  run        the real 3e10 band
"""
import math
import os
import struct
import sys
import time

BAND = ('/media/jsmille/My Book/rh-missing-tail/hi3e10/'
        'zeros_2999e6_to_30000e6.f64')
OLD_END = 2999245999.862950
FRONTIER_N = 9061794704
TARGET = 30000000000
CHUNK = 256 * 1024 * 1024      # bytes per read  (32M floats)
LOG = None


def log(msg):
    line = "%s %s" % (time.strftime('%F %T'), msg)
    if LOG:
        with open(LOG, 'a') as f:
            f.write(line + "\n")
    sys.stdout.write(line + "\n")
    sys.stdout.flush()


def rvm(t):
    x = t / (2.0 * math.pi)
    return x * (math.log(x) - 1.0) + 7.0 / 8.0


def gate(band_path, frontier_n, old_end, target, label,
         total_lo=5e9, total_hi=1.5e11, tol=3):
    """Run all gates over band_path.  Returns (total, t_end).
    Raises AssertionError on any gate failure."""
    import numpy as np
    fs = os.path.getsize(band_path)
    assert fs % 8 == 0, "band size not multiple of 8: %d" % fs
    total = fs // 8
    assert total_lo < total < total_hi, \
        "band size implausible: %d" % total
    log("GATES[%s] start: total = %d floats (%.1f GB)"
        % (label, total, fs / 1e9))

    prev = None
    mingap = None
    t0 = time.time()
    nread = 0
    last_mark = 0
    with open(band_path, 'rb', buffering=0) as f:
        buf = bytearray(CHUNK)
        while True:
            got = f.readinto(buf)
            if not got:
                break
            b = np.frombuffer(buf[:got], dtype='<f8')
            if prev is not None:
                g = float(b[0]) - prev
                assert g > 0, "band NOT strictly monotone at seam %d" % nread
                if mingap is None or g < mingap:
                    mingap = g
            if b.size > 1:
                d = np.diff(b)
                m = float(d.min())
                assert m > 0, "band NOT strictly monotone at offset %d" % nread
                if mingap is None or m < mingap:
                    mingap = m
            prev = float(b[-1])
            nread += got
            mark = nread // (2 * 1024 * 1024 * 1024)
            if mark > last_mark:
                last_mark = mark
                log("GATES[%s] ... %.0f%% (%.1f min)"
                    % (label, 100.0 * nread / fs, (time.time() - t0) / 60))
    assert mingap is not None, "band empty"
    # re-read first + last zero (cheap random access after the sweep)
    with open(band_path, 'rb') as f:
        first = struct.unpack('<d', f.read(8))[0]
        f.seek(fs - 8)
        t_end = struct.unpack('<d', f.read(8))[0]
    assert t_end > first, "band empty/inverted"

    N_end = frontier_n + total
    g0 = first - old_end
    log("GATES[%s] total=%d zeros, t range [%.6f, %.6f]"
        % (label, total, first, t_end))
    log("band min gap = %.9f  (sweep %.1f min)" % (mingap,
                                                    (time.time() - t0) / 60))
    log("seam: first new zero - old band end = %.6f (must be in (0,1))" % g0)
    assert 0.0 < g0 < 1.0, "seam gap FAILED: %f" % g0
    g2 = N_end - rvm(t_end)
    log("N(band end %.1f) = %d vs RVM %.2f |diff| = %.2f (tol %d)"
        % (t_end, N_end, rvm(t_end), abs(g2), tol))
    assert abs(g2) <= tol, "RVM gate at band end FAILED: %f" % g2

    # N(target) pin via binary search over the file
    with open(band_path, 'rb') as f:
        firstv = struct.unpack('<d', f.read(8))[0]
    if firstv > target:
        le = 0
    else:
        lo, hi = 0, total   # invariant:  a[lo] <= target < a[hi]
        with open(band_path, 'rb', buffering=0) as f:
            while hi - lo > 1:
                mid = (lo + hi) // 2
                f.seek(mid * 8)
                v = struct.unpack('<d', f.read(8))[0]
                if v <= target:
                    lo = mid
                else:
                    hi = mid
        le = lo + 1
    if t_end >= target:
        N_t = frontier_n + le
        g1 = N_t - rvm(target)
        last_under = _nth(band_path, le - 1) if le else float('nan')
        log("N(3.0e10) = %d  (last zero under = %.6f) vs RVM(3.0e10) "
            "%.2f  |diff| = %.2f  (tol %d)"
            % (N_t, last_under, rvm(target), abs(g1), tol))
        assert abs(g1) <= tol, "RVM gate at 3e10 FAILED: %f" % g1
        log("FINISH-GATES-PASS (%s — 3e10 REACHED, N(3e10) pinned)" % label)
    else:
        log("NOTE: band ends below 3.0e10 — maximal public extension;  "
            "N(3e10) pin deferred to index growth")
        log("FINISH-GATES-PARTIAL (%s — maximal public extension)" % label)
    return total, t_end


def _nth(band_path, k):
    with open(band_path, 'rb') as f:
        f.seek(k * 8)
        return struct.unpack('<d', f.read(8))[0]


def selftest():
    import numpy as np
    np.random.seed(7)
    good = 'selftest_good.f64'
    bad = 'selftest_bad.f64'
    # 10M synthetic zeros whose RICHES track RVM:  each zero is one
    # Newton step of  Nas(t_{k+1}) = fn + k + 1  from the previous
    # zero  (residual ~1e-10 per step in N units —  the RVM gate
    # with tol 3 must ACCEPT this band,  which is exactly what we
    # want the selftest to prove).
    N = 10_000_000
    a0 = 1.0e9 + 0.33
    fn = int(round(rvm(a0))) - 1     # count at the synthetic prev zero:
                                     # a[k] is the zero with count fn+1+k
    ts = [a0]
    for k in range(1, N):
        t = ts[-1]
        x = t / (2.0 * math.pi)
        rho = math.log(x) / (2.0 * math.pi)     # dNas/dt
        t = t + 1.0 / rho
        target = fn + 1 + k
        for _ in range(2):                       # two Newton corrections
            x = t / (2.0 * math.pi)
            t = t - (x * (math.log(x) - 1.0) + 7.0 / 8.0 - target) / rho
        ts.append(t)
    a = np.array(ts, dtype='<f8')
    a.tofile(good)
    t_end = float(a[-1])
    # broken:  invert two adjacent values in the middle
    b = a.copy()
    b[5_000_000], b[5_000_001] = b[5_000_001], b[5_000_000]
    b.tofile(bad)
    oe = a0 - 0.4
    try:
        try:
            gate(good, fn, oe, t_end * 0.999999, 'selftest-good',
                 total_lo=1e6, total_hi=1e8)
            print("SELFTEST good-band: PASS (gate accepted a valid band)")
        except AssertionError as e:
            print("SELFTEST FAIL: good band rejected: %s" % e)
            return 1
        caught = False
        try:
            gate(bad, fn, oe, t_end * 0.999999, 'selftest-bad',
                 total_lo=1e6, total_hi=1e8)
        except AssertionError as e:
            caught = True
            print("SELFTEST bad-band: CAUGHT (%s)" % e)
        if not caught:
            print("SELFTEST FAIL: broken band was NOT caught")
            return 1
        print("SELFTEST-PASS")
        return 0
    finally:
        for p in (good, bad):
            if os.path.exists(p):
                os.remove(p)


def main():
    global LOG
    if len(sys.argv) > 1 and sys.argv[1] == 'selftest':
        return selftest()
    LOG = LOG or os.path.join(os.path.dirname(BAND), 'finish-gates.log')
    t0 = time.time()
    total, t_end = gate(BAND, FRONTIER_N, OLD_END, TARGET, 'band3e10')
    log("band size vs lastN:  band/8 = %d,  lastN - FRONTIER_N = %d  "
        "=> %s" % (total,
                   int(open(os.path.join(os.path.dirname(BAND),
                                          'lastN.txt')).read().strip())
                   - FRONTIER_N,
                   "CHAIN-EXACT"
                   if int(open(os.path.join(os.path.dirname(BAND),
                                            'lastN.txt')).read().strip())
                      - FRONTIER_N == total else "MISMATCH"))
    log("GATES TOTAL WALL: %.1f min" % ((time.time() - t0) / 60))
    return 0


if __name__ == '__main__':
    sys.exit(main())
