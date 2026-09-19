#!/usr/bin/env python3
"""day035 S3d — walk pin + IBP anatomy on the EXTENSION (G_LAST, 2.0e9].

Context: the 3e10 chain (W3) is disk-blocked (765GB f64 needed,
132GB free, single 1.9T disk) and time-blocked (~31 more LMFDB
days at the observed ~3e9 zeros/day).  But
zeros_1002e6_to_2000e6.f64 (24.5GB, 3.057e9 zeros, converted
2026-09-17) is already on disk.  It overlaps band 1 on
(1.002e9, G_LAST) and EXTENDS it to 2.0e9.

Scope: the NEW territory is (G_LAST, G2] with G_LAST =
1006345999.847005 (the seam, N pinned EXACTLY = 2,865,625,422)
and G2 = last zero of the 2e9 file (~2.0e9).  This probe
extends the TELESCOPE's walk pin (sup|DN| = 2.439 on
(1e7, G_LAST], N up to 2.86e9) up to N = 5.9e9 zeros.

Anchoring mirrors day035_s3b_ibp_anatomy.anatomy EXACTLY:
  boundary G1 = G_LAST (a seam zero, N pinned), data zeros =
  new_zeros = 2e9-file elements strictly > G_LAST,  G2 = last.
  N(new_zeros[j]) = N_GLAST + j + 1.

  GATE-1 (overlap/seam audit): 2e9-file elements on
  (G1B=1.002e9, G_LAST) must agree BITWISE with hi-file
  elements in the same range (same 104-bit source integers,
  deterministic f64 rounding), and G_LAST itself must be present
  in the 2e9 file bit-exactly.  Validates the conversion and the
  seam count that anchors N.

Outputs (the S3b machine, band 2):
  - walk statistics over (G_LAST, G2]:  sup|DN|, DN at both ends
    (the pin we are extending from 2.439).
  - anatomy at t = 1.6e9 + 1/2:  S1 = B - Dc + R (gate),
    Dc near/far split, min|g-t|.

Solo run, memmap loads (24.5GB + 22.3GB page cache, box idle),
taskset 27, ~15-20 min.
"""
import numpy as np
import sys, time
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
from day035_s3b_ibp_anatomy import n_asym, p_of, NEAR

G_LAST = None            # set to hi[-1] (exact f64) inside main()
N_GLAST = 2865625422
F2 = ('/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/'
      'zeros_1002e6_to_2000e6.f64')
FH = ('/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/'
      'zeros_hi31946e6_to_1e9.f64')
CH = 500_000_000


def main():
    t_load0 = time.time()
    a = np.memmap(F2, dtype='<f8', mode='r')
    hi = np.memmap(FH, dtype='<f8', mode='r')
    G_LAST = float(hi[-1])          # EXACT f64 (not a decimal literal)
    print("2e9 band: %d zeros, span (%.6f, %.6f);  load %.1f min"
          % (a.size, a[0], a[-1], (time.time() - t_load0) / 60), flush=True)

    # ---- seam/overlap audit -----------------------------------------
    # GATE-1: (a) exact order/alignment:  k0 = index of G_LAST in a
    #   (bit-exact), j0 = index of a[0] in hi (bit-exact), and
    #   j0 + k0 == hi.size - 1 (the overlap is contiguous);
    #   (b) overlap values: |a[0:k0] - hi[j0:j0+k0]| <= 1 ulp elementwise
    #   (a last-rounding discrepancy between the two independent
    #   converters is tolerable at 1 ulp -- documented; counts and
    #   order are exact).
    t0 = time.time()
    k0 = int(np.searchsorted(a, G_LAST, side='left'))
    g_present = bool(a[k0] == G_LAST)
    j0 = int(np.searchsorted(hi, a[0], side='left'))
    first_match = bool(hi[j0] == a[0])
    aligned = (j0 + k0) == (hi.size - 1)
    # 3 x 100000 overlap samples, exact aligned positions
    max_ulps = 0
    n_diff = 0
    for s in (0, k0 // 2, k0 - 100000):
        o2 = np.ascontiguousarray(a[s:s + 100000])
        oh = np.ascontiguousarray(hi[j0 + s:j0 + s + 100000])
        d = np.abs(o2 - oh)
        md = float(d.max())
        u = float(np.spacing(a[s]))
        max_ulps = max(max_ulps, md / u if u > 0 else 0.0)
        n_diff += int((d > 0).sum())
    bitwise_ok = g_present and first_match and aligned and max_ulps <= 1.0
    print("seam: G_LAST = %.10f present in 2e9 file bit-exactly: %s"
          % (G_LAST, g_present), flush=True)
    print("align: j0 = %d, k0 = %d, j0+k0 == hi.size-1: %s"
          % (j0, k0, aligned), flush=True)
    print("GATE-1 overlap 300000 samples: max = %.2f ulp, %d/300000 "
          "differ;  GATE-1 = %s   (%.1f min)"
          % (max_ulps, n_diff, bitwise_ok, (time.time() - t0) / 60),
          flush=True)
    if not (g_present and first_match and aligned):
        print("ABORT: exact alignment failed", flush=True)
        return
    new = a[k0 + 1:]                   # extension: strictly > G_LAST
    n_new = new.size
    print("extension (G_LAST, G2]: %d new zeros  "
          "-> N(G2) = %d" % (n_new, N_GLAST + n_new), flush=True)

    G2 = float(new[-1])
    n_g1 = N_GLAST                      # count at boundary (seam pin)
    n_g2 = N_GLAST + n_new              # count at last zero
    nas_g1 = float(n_asym(np.array([G_LAST]))[0])
    nas_g2 = float(n_asym(np.array([G2]))[0])
    dn_g1 = n_g1 - nas_g1
    dn_g2 = n_g2 - nas_g2
    print("extension ends: DN(G_LAST) = %+.6f   DN(G2) = %+.6f"
          % (dn_g1, dn_g2), flush=True)

    # ---- single pass: S1, L-form, Dc, R, walk sup|DN| ---------------
    t = 1_600_000_500.5
    t64 = np.float64(t)
    p_g1 = float(p_of(np.array([G_LAST]), t64)[0])
    p_g2 = float(p_of(np.array([G2]), t64)[0])
    B = p_g2 * dn_g2 - p_g1 * dn_g1
    s1 = np.longdouble(0.0)
    lform = np.longdouble(0.0)
    dc = np.longdouble(0.0)
    dc_near = np.longdouble(0.0)
    nas_ds = np.longdouble(0.0)
    maxabs_dn = 0.0
    maxabs_dn_incl = abs(dn_g1)
    last_x, last_p = float(G_LAST), p_g1
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
            # left endpoint absolute count: boundary G_LAST (N_GLAST)
            # then new zeros;  matches S3b idxN = N_G1 + ncount + arange.
            idxN = n_g1 + ncount + np.arange(p.size, dtype=np.float64)
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
            # sup over DATA zeros (left endpoints include boundary;
            # the new zeros appear as lx[1:]): add right-endpoint
            # (x itself) values for a full zero-census.
            dnx = (n_g1 + ncount + 1 + np.arange(x.size - 1,
                                                 dtype=np.float64)
                   - n_asym(x[:-1]))
            maxabs_dn_incl = max(maxabs_dn_incl,
                                 float(np.max(np.abs(dnx))))
        ncount += x.size
        if p.size:
            last_x, last_p = float(x[-1]), float(p[-1])
        s1 += np.sum(p.astype(np.longdouble))
    # straddle safety
    i_t = int(np.searchsorted(new, t, side='left'))
    dmin = min(abs(t - new[i_t - 1]), abs(t - new[i_t]))
    L = (p_g2 * n_g2 - p_g1 * n_g1) - float(lform)
    R = (p_g2 * nas_g2 - p_g1 * nas_g1) - float(nas_ds)
    print("anatomy (G_LAST, G2] at t = %.1f  (min |g-t| = %.4f;  "
          "%.1f min)" % (t, dmin, (time.time() - t0) / 60), flush=True)
    print("  GATE0 S1 vs L-form |d|            = %.3e (<= ~1e-6)"
          % abs(float(s1) - L), flush=True)
    print("  S1  = sum p(gamma) over extension = %+.6e" % float(s1),
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
    print("  (band 1 pin was sup|DN| = 2.439 on (1e7, G_LAST])",
          flush=True)

if __name__ == '__main__':
    main()
