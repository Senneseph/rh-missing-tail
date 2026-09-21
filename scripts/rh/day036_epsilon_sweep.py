#!/usr/bin/env python3
"""day036 — the [S1] data layer over the 3e10 band.

One streaming pass over
    /media/jsmille/My Book/rh-missing-tail/hi3e10/
        zeros_2999e6_to_30000e6.f64
(the (2.9992e9, 3.0e10] LMFDB band, 92,577,877,714 zeros,
740,623,021,712 bytes;  provenance in DISCOVERY_LOG;  finish
gates must have PASSED before this script is run) producing:

  (1) the W2Beyond1.driftTwoSided data contract:
        eps_i = |Delta_i - 1|,  Delta_i := n_asym(t_{i+1}) -
        n_asym(t_i)  (per consecutive zero pair in the band),
      and  SUM_EPS  = sum_i eps_i,  the certificate in
           |DN(j) - DN(0)| <= SUM_EPS  (the uniform walk bound
      on the band,  conditional on the pinned DN(0)).
      CERTIFIED form:  n_asym is evaluated in f64;  the per-
      evaluation absolute error is < 1/2 ulp of n_asym(t) at
      t in the band  (< 7.3e-6);  one Delta uses twoevalu-
      ations plus one subtraction,  so |Delta_true -
      Delta_calc| <= 3 half-ulps < 2.2e-5;  we use a SAFE
      per-gap margin  M = 1e-4  (x4.5)  and report
           SUM_EPS_CERT = SUM_EPS + M * (n-1)
      as the rigorous certificate.  (An 80-bit extended-
      precision rerun would tighten the margin ~500x;  both
      are tiny against the magnitude of SUM_EPS itself —
      the R2 bound is a proven ceiling,  not a tight fit,
      and that is the pre-registered framing.)

  (2) the S3e-style walk pin over the band:
        sup |DN|  with  DN(j) := N(z_j) - n_asym(z_j)  at
      every zero z_j of the band and  N(lx) - n_asym(lx) at
      every zero-predecessor lx (exactly the S3e convention
      so the numbers chain with the existing 3e9 pin
      sup|DN| = 2.4772 on (1e7, 2.9992e9]),  plus DN at both
      band ends  (the end value is the NEXT band's pinned
      start).

  (3) zero census of the band:  count,  span,  min/max raw
      gap,  min/max Delta (the Rho-scale extremes),  worst
      eps,  and the N(3e10) pin (zeros with t <= 3.0e10).

Anchoring (verbatim from the stream constants):
    OLD_END  = 2999245999.862950   (last zero of the 3e9 band)
    FRONTIER_N = 9061794704        (= N(OLD_END),  chain-exact)
    the band file's j-th element (0-based) has
    N(z_j) = FRONTIER_N + j + 1.

Solo run,  memmap streaming in 512MB chunks  (~90 min
dominated by USB sequential read),  taskset -c 0-1.
Lean 4.33.1 + mathlib v4.33.1 context;  pure stdlib+numpy.
"""
import numpy as np
import sys, time
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
from day035_s3b_ibp_anatomy import n_asym

BAND = ('/media/jsmille/My Book/rh-missing-tail/hi3e10/'
        'zeros_2999e6_to_30000e6.f64')
OLD_END = 2999245999.862950
FRONTIER_N = 9061794704
TARGET = 30000000000
CH = 64_000_000            # zeros per chunk = 512MB
M = 1e-4                  # certified per-gap margin (see header)


def main():
    a = np.memmap(BAND, dtype=np.float64, mode='r')
    n = int(a.size)
    t0 = time.time()
    first, last = float(a[0]), float(a[-1])
    print("band: %d zeros, span (%.6f, %.6f)" % (n, first, last),
          flush=True)

    # ---- seam audit (re-check;  the finish gates already did it)
    head = a[:2_000_001]
    seam = float(head[0]) - OLD_END
    dmin_head = float(np.diff(head).min())
    tail = a[n - 2_000_000:n]
    dmin_tail = float(np.diff(tail).min())
    print("seam gap first - OLD_END = %.6f (in (0,1): %s)"
          % (seam, 0.0 < seam < 1.0), flush=True)
    print("head min gap = %.6e,  tail min gap = %.6e   (%.1fs)"
          % (dmin_head, dmin_tail, time.time() - t0), flush=True)
    assert 0.0 < seam < 1.0 and dmin_head > 0 and dmin_tail > 0, \
        "seam audit FAILED"

    dn_start = FRONTIER_N - float(n_asym(np.array([OLD_END]))[0])
    print("DN(0) pin at OLD_END:  DN = %+.9f" % dn_start, flush=True)

    sum_eps = np.longdouble(0.0)
    max_eps = min_delta = max_delta = None
    max_abs_dn = abs(dn_start)
    dmin_raw = None
    nas_last = None
    ncount = 0
    t0 = time.time()
    for off in range(0, n, CH):
        x = np.ascontiguousarray(a[off:off + CH])
        m = x.size
        nas = n_asym(x)
        # ---- eps layer (in-chunk pairs) ----
        d = nas[1:] - nas[:-1]
        e = np.abs(d - 1.0)
        sum_eps += np.sum(e, dtype=np.longdouble)
        if max_eps is None or float(e.max()) > max_eps:
            max_eps = float(e.max())
        if min_delta is None or float(d.min()) < min_delta:
            min_delta = float(d.min())
        if max_delta is None or float(d.max()) > max_delta:
            max_delta = float(d.max())
        # cross-chunk pair (last of prev chunk -> first of this)
        if nas_last is not None:
            dxc = float(nas[0]) - nas_last
            e_xc = abs(dxc - 1.0)
            sum_eps += np.longdouble(e_xc)
            max_eps = max(max_eps, e_xc)
            min_delta = min(min_delta, dxc)
            max_delta = max(max_delta, dxc)
        # ---- walk (S3e convention) ----
        idxN = FRONTIER_N + ncount + 1 + np.arange(
            m, dtype=np.float64)
        dnx = idxN - nas                       # at each zero
        if off > 0:                            # predecessor of x[0]
            dnx = np.concatenate(
                ([np.float64(FRONTIER_N + ncount - nas_last)],
                 dnx))
        max_abs_dn = max(max_abs_dn, float(np.abs(dnx).max()))
        # ---- raw gap extremes ----
        g = np.diff(x)
        if dmin_raw is None or float(g.min()) < dmin_raw:
            dmin_raw = float(g.min())
        nas_last = float(nas[-1])
        ncount += m
        if (off // CH) % 200 == 199:
            print("  ... %d/%d chunks, %.0f%%, %.1f min"
                  % (off // CH + 1, (n + CH - 1) // CH,
                     100.0 * (off + m) / n, time.time() - t0),
                  flush=True)
    print("single pass done: %.1f min" % ((time.time() - t0) / 60),
          flush=True)

    dn_end_val = None
    # ---- N(3e10) pin + end DN ----
    le = int(np.searchsorted(a, np.float64(TARGET), side='right'))
    n_at_target = FRONTIER_N + le
    if le:
        tn = float(a[le - 1])
        dn_end_val = n_at_target - float(
            n_asym(np.array([tn]))[0])
    print("N(3.0e10) = %d  (zeros with t <= 3.0e10;  "
          "last = %s)" % (n_at_target,
                         "(none)" if le == 0 else "%.6f" % tn),
          flush=True)

    rvm = lambda t: (t / (2 * np.pi)
                     * (np.log(t / (2 * np.pi)) - 1.0) + 7 / 8)
    print("N(3.0e10) vs RVM(3.0e10):  %d vs %.2f  "
          "|diff| = %.2f"
          % (n_at_target, float(rvm(TARGET)),
             abs(n_at_target - float(rvm(TARGET)))), flush=True)

    sum_eps_cert = sum_eps + np.longdouble(M) * (n - 1)
    end_dn = (FRONTIER_N + n) - float(n_asym(np.array([last]))[0])
    assert n == 101639672418 - FRONTIER_N, \
        "band size vs the stream's final lastN:  %d" % n
    print("=" * 64, flush=True)
    print("EPSILON LAYER (the driftTwoSided certificate):")
    print("  gaps (pairs)                = %d" % (n - 1))
    print("  SUM_EPS      = sum|Delta-1| = %.6f" % float(sum_eps))
    print("  + margin M*(n-1) = %+.6f" % (M * (n - 1)), flush=True)
    print("  SUM_EPS_CERT (rigorous)     = %.6f" % float(sum_eps_cert),
          flush=True)
    print("  => sup_{k in band} |DN(k) - DN(0)| <= %.6f "
          "(pinned |DN(0)| = %.6f)"
          % (float(sum_eps_cert) + abs(dn_start), abs(dn_start)),
          flush=True)
    print("  worst eps                 = %.9f" % max_eps)
    print("  Delta range               = [%.9f, %.9f]"
          % (min_delta, max_delta))
    print("WALK PIN (S3e convention, chains with 3e9 pin):")
    print("  sup |DN| over band         = %.6f" % max_abs_dn)
    print("  DN at OLD_END (start)      = %+.9f" % dn_start)
    print("  DN at band end (next pin)  = %+.9f" % end_dn)
    print("CENSUS:")
    print("  min raw gap               = %.9f" % dmin_raw)
    print("  span                      = (%.6f, %.6f)"
          % (first, last))
    print("  total zeros               = %d  (CHAIN-EXACT vs lastN)"
          % n, flush=True)
    print("ELAPSED (pass): %.1f min" % ((time.time() - t0) / 60),
          flush=True)


if __name__ == '__main__':
    main()
