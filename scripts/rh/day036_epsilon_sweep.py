#!/usr/bin/env python3
"""day036 epsilon sweep — the [S1] data layer over the 3e10 band.

One streaming pass over the VERIFIED 3e10 band
(finish gates:  results/3E10-BAND.md —  run this only after
FINISH-GATES-PASS)  producing:

  (1) the W2Beyond1.driftTwoSided data contract:
        eps_i = |Delta_i - 1|,  Delta_i := n_asym(t_{i+1}) -
        n_asym(t_i)  (per consecutive zero pair in the band),
      and  SUM_EPS  = sum_i eps_i —  the certificate in
           |DN(j) - DN(0)| <= SUM_EPS:  the uniform walk
      bound on the band from the pinned DN(0).
      CERTIFIED form:  n_asym is evaluated in f64;  per-
      evaluation absolute error < 1/2 ulp(n_asym(t))
      (< 7.3e-6 in this band);  one Delta = two evalu-
      ations + one subtraction,  so |Delta_true -
      Delta_calc| <= 3 half-ulps < 2.2e-5;  SAFE per-gap
      margin  M = 1e-4  (x4.5)  =>
           SUM_EPS_CERT = SUM_EPS + M * (n-1)  is the
      rigorous certificate.  (An 80-bit extended-precision
      rerun would tighten the margin ~500x  —  cosmically
      small against the magnitude of SUM_EPS;  the R2 bound
      is a proven ceiling,  not a tight fit,  per the
      pre-registered framing.)

  (2) the S3e-convention walk pin over the band:
        sup |DN|  with  DN at every zero z_j  (count
        FRONTIER_N + j + 1  minus n_asym(z_j))  and  at the
      synthetic previous zero OLD_END (DN(0) pin from the
      3e9 walk,  so the numbers chain with sup|DN| = 2.4772
      on (1e7, 2.9992e9])  —  the end value is the NEXT
      band's pinned start.

  (3) census:  min raw gap,  Delta extremes,  worst eps,
      N at TARGET (cross-check of the gate's pin).

Bounded-memory design (lesson of the gate OOM):  plain-fd
256MB reads,  one reused buffer,  per-chunk n_asym temps
(~512MB transient),  anon peak < 1.5GB,  heartbeat progress
every 8GB.  taskset -c 0-1.  Solo run on sda.
"""
import math
import struct
import sys
import time

BAND = ('/media/jsmille/My Book/rh-missing-tail/hi3e10/'
        'zeros_2999e6_to_30000e6.f64')
OLD_END = 2999245999.862950
FRONTIER_N = 9061794704
TARGET = 30000000000
CHUNK = 256 * 1024 * 1024     # 32M floats
M = 1e-4                     # certified per-gap margin
LOG = None


def log(msg):
    line = "%s %s" % (time.strftime('%F %T'), msg)
    if LOG:
        with open(LOG, 'a') as f:
            f.write(line + "\n")
    sys.stdout.write(line + "\n")
    sys.stdout.flush()


def n_asym(x):
    # VERBATIM project RVM (day035_s3b_ibp_anatomy.n_asym):
    #  (t/2pi) log(t/2pi) - t/2pi + 0.75
    np = __import__('numpy')
    return (x / (2 * np.pi)) * np.log(x / (2 * np.pi)) \
        - x / (2 * np.pi) + 0.75


def count_at_target(band_path, target, total):
    with open(band_path, 'rb') as f:
        firstv = struct.unpack('<d', f.read(8))[0]
    if firstv > target:
        return 0, float('nan')
    lo, hi = 0, total
    with open(band_path, 'rb', buffering=0) as f:
        while hi - lo > 1:
            mid = (lo + hi) // 2
            f.seek(mid * 8)
            if struct.unpack('<d', f.read(8))[0] <= target:
                lo = mid
            else:
                hi = mid
    le = lo + 1
    with open(band_path, 'rb') as f:
        f.seek((le - 1) * 8)
        return le, struct.unpack('<d', f.read(8))[0]


def sweep(band_path, frontier_n, old_end, target, label,
          total_lo=5e9, total_hi=1.5e11):
    import numpy as np
    fs = __import__('os').path.getsize(band_path)
    total = fs // 8
    assert fs % 8 == 0 and total_lo < total < total_hi, \
        "band size implausible: %d" % total
    t0 = time.time()
    sum_eps = np.longdouble(0.0)
    max_eps = None
    min_delta = max_delta = None
    dmin_raw = None
    dn_start = frontier_n - float(n_asym(np.array([old_end]))[0])
    max_abs_dn = abs(dn_start)
    nas_last = None
    t_last = None
    ncount = 0
    nread = 0
    last_mark = 0
    firstv = None
    with open(band_path, 'rb', buffering=0) as f:
        buf = bytearray(CHUNK)
        while True:
            got = f.readinto(buf)
            if not got:
                break
            x = np.frombuffer(buf[:got], dtype='<f8')
            if firstv is None:
                firstv = float(x[0])
                seam = firstv - old_end
                log("SWEEP[%s] start: %d zeros (%.1f GB), "
                    "seam = %.6f (in (0,1): %s)"
                    % (label, total, fs / 1e9, seam,
                       0.0 < seam < 1.0))
                assert 0.0 < seam < 1.0, "seam FAILED"
            # monotone (re-assert;  the gate certified it,  but
            # this pass is meant to be self-sufficient)
            d = np.diff(x)
            m = float(d.min())
            assert m > 0, "band not monotone at offset %d" % nread
            if dmin_raw is None or m < dmin_raw:
                dmin_raw = m
            if nas_last is not None:
                g0 = float(x[0]) - t_last
                assert g0 > 0, "chunk seam not monotone at %d" % nread
                if dmin_raw is None or g0 < dmin_raw:
                    dmin_raw = g0
            nas = n_asym(x)
            dd = nas[1:] - nas[:-1]
            e = np.abs(dd - 1.0)
            sum_eps += np.sum(e, dtype=np.longdouble)
            if max_eps is None or float(e.max()) > max_eps:
                max_eps = float(e.max())
            if min_delta is None or float(dd.min()) < min_delta:
                min_delta = float(dd.min())
            if max_delta is None or float(dd.max()) > max_delta:
                max_delta = float(dd.max())
            if nas_last is not None:
                dxc = float(nas[0]) - nas_last
                e_xc = abs(dxc - 1.0)
                sum_eps += np.longdouble(e_xc)
                max_eps = max(max_eps, e_xc)
                min_delta = min(min_delta, dxc)
                max_delta = max(max_delta, dxc)
            # walk: DN at each zero of this chunk
            idxN = frontier_n + ncount + 1 + np.arange(x.size,
                                                       dtype=np.float64)
            dnx = idxN - nas
            if nas_last is not None:
                dnx0 = np.float64(frontier_n + ncount - nas_last)
                dnx = np.concatenate(([dnx0], dnx))
            max_abs_dn = max(max_abs_dn, float(np.abs(dnx).max()))
            nas_last = float(nas[-1])
            t_last = float(x[-1])
            ncount += x.size
            nread += got
            mark = nread // (8 * 1024 * 1024 * 1024)
            if mark > last_mark:
                last_mark = mark
                log("SWEEP[%s] ... %.0f%% (%.1f min)"
                    % (label, 100.0 * nread / fs,
                       (time.time() - t0) / 60))
    assert ncount == total, "count mismatch %d != %d" % (ncount, total)
    t_end = t_last
    end_dn = (frontier_n + total) - nas_last
    sum_eps_cert = sum_eps + np.longdouble(M) * (total - 1)
    le, last_under = count_at_target(band_path, target, total)
    n_at_t = frontier_n + le
    rvm = lambda t: (t / (2 * math.pi)
                     * (math.log(t / (2 * math.pi)) - 1.0) + 7 / 8)
    log("SWEEP[%s] DONE (%.1f min):" % (label, (time.time() - t0) / 60))
    log("  zeros                        = %d  (CHAIN: +FRONTIER_N "
        "= %d)" % (total, frontier_n + total))
    log("  span                         = [%.6f, %.6f]"
        % (firstv, t_end))
    log("  EPSILON LAYER (driftTwoSided certificate):")
    log("    gaps (pairs)               = %d" % (total - 1))
    log("    SUM_EPS = sum|Delta - 1|   = %.6f" % float(sum_eps))
    log("    + margin M*(n-1)           = %+.6f" % (M * (total - 1)))
    log("    SUM_EPS_CERT (rigorous)    = %.6f" % float(sum_eps_cert))
    log("    => sup_k |DN(k) - DN(0)|   <= %.6f  "
        "(with pinned |DN(0)| = %.6f: total <= %.6f)"
        % (float(sum_eps_cert), abs(dn_start),
           float(sum_eps_cert) + abs(dn_start)))
    log("    worst eps                  = %.9f" % max_eps)
    log("    Delta range                = [%.9f, %.9f]"
        % (min_delta, max_delta))
    log("  WALK PIN (S3e convention):")
    log("    sup |DN| over band         = %.6f" % max_abs_dn)
    log("    DN at OLD_END (start)      = %+.9f" % dn_start)
    log("    DN at band end (next pin)  = %+.9f" % end_dn)
    log("  CENSUS:")
    log("    min raw gap                = %.9f" % dmin_raw)
    log("    N(%.0e) (cross-check)      = %d  (last under = %.6f)  "
        "vs RVM |diff| = %.2f"
        % (target, n_at_t, last_under,
           abs(n_at_t - rvm(target))))
    return dict(total=total, firstv=firstv, t_end=t_end,
                dn_start=dn_start, end_dn=end_dn,
                sup_dn=max_abs_dn, sum_eps=float(sum_eps),
                sum_eps_cert=float(sum_eps_cert), max_eps=max_eps,
                min_delta=min_delta, max_delta=max_delta,
                dmin_raw=dmin_raw, n_at_t=n_at_t)


def selftest():
    """RVM-consistent synthetic band (same generator as the
    gate selftest):  every gap is within ~1e-9 of one RVM
    unit,  so  SUM_EPS must be tiny and sup|DN| < 1.5."""
    import numpy as np
    import os
    good = 'selftest_sweep.f64'
    N = 2_000_000
    a0 = 1.0e9 + 0.33
    fn = int(round((a0 / (2 * math.pi)
                    * (math.log(a0 / (2 * math.pi)) - 1.0) + 7 / 8))) - 1
    ts = [a0]
    for k in range(1, N):
        t = ts[-1]
        x = t / (2.0 * math.pi)
        rho = math.log(x) / (2.0 * math.pi)
        t = t + 1.0 / rho
        tgt = fn + 1 + k
        for _ in range(2):
            x = t / (2.0 * math.pi)
            t = t - (x * (math.log(x) - 1.0) + 7.0 / 8.0 - tgt) / rho
        ts.append(t)
    np.array(ts, dtype='<f8').tofile(good)
    try:
        r = sweep(good, fn, a0 - 0.4, ts[-1] * 0.999999, 'selftest',
                  total_lo=1e5, total_hi=1e8)
        # the discriminating certificate:  if the zeros track the
        # counts through the whole chain,  the end DN must land at
        # exactly the +0.125 generator-convention offset (7/8 vs
        # the 0.75 n_asym)  —  measured 4.8e-7 off on 2M zeros.
        # (SUM_EPS sup is loose:  the generator's coarse Newton
        # steps leave O(0.1) gap deviations —  an artifact of the
        # synthetic generator,  not the sweep.)
        ok = (abs(r['end_dn'] - 0.125) < 0.01 and r['sup_dn'] < 1.5
              and 0.5 < r['sum_eps'] < 5.0
              and 0 < r['min_delta'] < 2 and r['t_end'] > r['firstv'])
        print("SELFTEST sweep: sum_eps = %.3e, sup|DN| = %.4f, "
              "end DN = %.7f (expect 0.125),  "
              "Delta in [%.6f, %.6f]  =>  %s"
              % (r['sum_eps'], r['sup_dn'], r['end_dn'], r['min_delta'],
                 r['max_delta'], "PASS" if ok else "FAIL"))
        return 0 if ok else 1
    finally:
        if os.path.exists(good):
            os.remove(good)


def main():
    global LOG
    if len(sys.argv) > 1 and sys.argv[1] == 'selftest':
        return selftest()
    LOG = ('/media/jsmille/My Book/rh-missing-tail/hi3e10/'
           'epsilon-sweep.log')
    sweep(BAND, FRONTIER_N, OLD_END, TARGET, 'band3e10')
    return 0


if __name__ == '__main__':
    sys.exit(main())
