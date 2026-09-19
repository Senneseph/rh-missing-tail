#!/usr/bin/env python3
"""day035 S3e — walk pin + IBP anatomy on band 3 (2.0e9, 2.9992e9].

Context: the 3e9 LMFDB stream (scripts/rh/day035_3e9_stream.sh)
COMPLETED 2026-09-19 14:47 EDT:  hi3e9/zeros_2002e6_to_3000e6.f64
(25.1GB, 3,142,622,346 zeros, span (2001746000.236353,
2999245999.862950)).  The stream's own finish gates verified
monotonicity, min gap > 0, seam gap in (0,1), and the N chain
(per-shard Nt0 asserts + md5 gates across all 476 shards); one
over-strict check (N at exactly 3e9, not reachable from the
file) failed on my bookkeeping, not the data.  The exact N(3e9)
was then pinned from one extra validated shard
(zeros_2999246000, md5-gated, Nt0 = N(band end) chain-exact):
  N(3e9) = 9,064,192,826   (RVM(3e9) = 9,064,192,825.58,
  |diff| = 0.42 <= 3)  —  correcting the earlier ~9.83e9
estimate in the stream header.

Scope:  band 3 = (B1, B2]  with  B1 = 2001745999.627... (last
zero of the 2e9 file; count pinned by S3d as N(B1) =
5,919,172,358)  and  B2 = last zero of the 3e9 file
(2999245999.862950, N(B2) = 9,061,794,704).  Extends the
telescope walk pin  sup|DN| <= 2.503  on (1e7, 2.0e9]  up to
N = 9.06e9 zeros.

Anchoring mirrors day035_s3d_2e9band.py:
  new zeros = 3e9-file elements (all of them, the file starts
  immediately after B1);  N(a[j]) = N_B1 + j + 1.
  GATE-1 (seam audit, no overlapping file exists by design):
  (a) B1 present bit-exactly in the 2e9 file and a[0] > B1;
  (b) seam gap a[0] - B1 in (0, 1);  (c) band strictly
  monotone with min gap > 0 (re-check, cheap).

Outputs (the S3b machine, band 3):
  - walk statistics over (B1, B2]:  sup|DN|, DN at both ends.
  - anatomy at t = 2.5e9 + 1/2:  S1 = B - Dc + R (gate),
    Dc near/far split, min|g-t|.

Solo run (memmap 25.1GB, box idle), taskset 27.
"""
import numpy as np
import sys, time
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
from day035_s3b_ibp_anatomy import n_asym, p_of, NEAR

N_B1 = 5919172358          # S3d pin at the 2e9 band end
F2 = ('/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/'
      'zeros_1002e6_to_2000e6.f64')
F3 = ('/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi3e9/'
      'zeros_2002e6_to_3000e6.f64')
CH = 500_000_000


def main():
    t_load0 = time.time()
    b = np.memmap(F2, dtype='<f8', mode='r')
    a = np.memmap(F3, dtype='<f8', mode='r')
    B1 = float(b[-1])
    print("band 3: %d zeros, span (%.6f, %.6f);  load %.1f min"
          % (a.size, a[0], a[-1], (time.time() - t_load0) / 60),
          flush=True)

    # ---- seam audit ---------------------------------------------------
    t0 = time.time()
    d3 = np.diff(a[:2_000_001])
    d3min = float(d3.min()) if d3.size else float('nan')
    head = a[:2_000_001]
    mono_ok = bool(d3min > 0)
    seam = float(a[0]) - B1
    seam_ok = (B1 < float(a[0])) and (0.0 < seam < 1.0)
    # tail monotone sample
    n = a.size
    tail = a[n - 2_000_000:n]
    dmin_tail = float(np.diff(tail).min())
    g1 = seam_ok and mono_ok and dmin_tail > 0
    print("seam: B1 = %.10f (= 2e9 file last zero)" % B1, flush=True)
    print("seam gap a[0] - B1 = %.6f (in (0,1): %s)" % (seam, seam_ok),
          flush=True)
    print("GATE-1: head min gap = %.6e, tail min gap = %.6e  "
          "=> GATE-1 = %s   (%.1f s)"
          % (d3min, dmin_tail, g1, time.time() - t0), flush=True)
    if not g1:
        print("ABORT: seam/monotonicity failed", flush=True)
        return

    new = a                        # whole file (starts after B1)
    n_new = new.size
    B2 = float(new[-1])
    n_b1 = N_B1
    n_b2 = N_B1 + n_new
    print("band 3: %d new zeros  -> N(B2) = %d" % (n_new, n_b2),
          flush=True)
    nas_b1 = float(n_asym(np.array([B1]))[0])
    nas_b2 = float(n_asym(np.array([B2]))[0])
    dn_b1 = n_b1 - nas_b1
    dn_b2 = n_b2 - nas_b2
    print("band 3 ends: DN(B1) = %+.6f   DN(B2) = %+.6f"
          % (dn_b1, dn_b2), flush=True)

    # ---- single pass: S1, L-form, Dc, R, walk sup|DN| ---------------
    t = 2_500_000_050.5
    t64 = np.float64(t)
    p_b1 = float(p_of(np.array([B1]), t64)[0])
    p_b2 = float(p_of(np.array([B2]), t64)[0])
    B = p_b2 * dn_b2 - p_b1 * dn_b1
    s1 = np.longdouble(0.0)
    lform = np.longdouble(0.0)
    dc = np.longdouble(0.0)
    dc_near = np.longdouble(0.0)
    nas_ds = np.longdouble(0.0)
    maxabs_dn = 0.0
    maxabs_dn_incl = abs(dn_b1)
    last_x, last_p = float(B1), p_b1
    ncount = 0
    t0 = time.time()
    for off in range(0, n_new, CH):
        x = np.ascontiguousarray(new[off:off + CH])
        p = p_of(x, t64)
        if p.size:
            carry = np.empty(p.size + 1, dtype=np.float64)
            carry[0] = last_p
            carry[1:] = p
            dp = carry[1:] - carry[:-1]
            lx = np.empty(p.size, dtype=np.float64)
            lx[0] = last_x
            lx[1:] = x[:-1]
            idxN = n_b1 + ncount + np.arange(p.size, dtype=np.float64)
            nas = n_asym(lx)
            dnv = idxN - nas
            lform += np.sum(idxN.astype(np.longdouble)
                            * dp.astype(np.longdouble))
            wD = dnv.astype(np.longdouble) * dp.astype(np.longdouble)
            dc += np.sum(wD)
            nas_ds += np.sum(nas.astype(np.longdouble)
                             * dp.astype(np.longdouble))
            m = (lx > t - NEAR) & (lx < t + NEAR)
            dc_near += np.sum(wD[m])
            maxabs_dn = max(maxabs_dn, float(np.max(np.abs(dnv))))
            dnx = (n_b1 + ncount + 1
                   + np.arange(x.size - 1, dtype=np.float64)
                   - n_asym(x[:-1]))
            maxabs_dn_incl = max(maxabs_dn_incl,
                                 float(np.max(np.abs(dnx))))
        ncount += x.size
        if p.size:
            last_x, last_p = float(x[-1]), float(p[-1])
        s1 += np.sum(p.astype(np.longdouble))
    i_t = int(np.searchsorted(new, t, side='left'))
    dmin = min(abs(t - new[i_t - 1]), abs(t - new[i_t]))
    L = (p_b2 * n_b2 - p_b1 * n_b1) - float(lform)
    R = (p_b2 * nas_b2 - p_b1 * nas_b1) - float(nas_ds)
    print("anatomy (B1, B2] at t = %.1f  (min |g-t| = %.4f;  "
          "%.1f min)" % (t, dmin, (time.time() - t0) / 60), flush=True)
    print("  GATE0 S1 vs L-form |d|            = %.3e (<= ~1e-6)"
          % abs(float(s1) - L), flush=True)
    print("  S1  = sum p(gamma) over band 3    = %+.6e" % float(s1),
          flush=True)
    print("  B   = boundary DN terms           = %+.6f" % B, flush=True)
    print("  Dc  = walk-weighted gap sum       = %+.6f" % float(dc),
          flush=True)
    print("       Dc_near [t-200,t+200]        = %+.6f" % float(dc_near),
          flush=True)
    print("       Dc_far                        = %+.6f"
          % float(dc - dc_near), flush=True)
    print("  R   = smooth (Nas) part           = %+.6e" % R, flush=True)
    print("  GATE1 S1 - (B - Dc + R)           = %.3e (must be ~0)"
          % (float(s1) - (B - float(dc) + R)), flush=True)
    print("  walk (left-endpoint census, S3b convention): "
          "sup|DN| = %.4f" % maxabs_dn, flush=True)
    print("  walk (full zero census incl endpoints):        "
          "sup|DN| = %.4f" % maxabs_dn_incl, flush=True)
    print("  (bands 1-2 pin was sup|DN| = 2.503 on (1e7, B1])",
          flush=True)


if __name__ == '__main__':
    main()
