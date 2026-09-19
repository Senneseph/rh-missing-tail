#!/usr/bin/env python3
"""day035 S3b — IBP anatomy of the Efull lattice walk (probe, exact data).

END_GAME_PLAN W2 map-drawing: the sum-vs-density defect
    W(t) = sum_{gamma in (G1,G2]} p(gamma; t) - int p(g; t) rho(g) dg
with p(g; t) = log|g^2 - t^2| - log(g^2 + 1/4) + 0.5/(g^2 + 1/4)
(the real Efull kernel, day023/day029 verbatim).

Summation-by-parts against the counting function N (exact data in
(1e7, G_LAST]) gives the IDENTITY (verified by hand on 2 terms):
    S1 = sum_{gammas in (G1,G2]} p(gamma)
       = p(G2)*N(G2) - p(G1)*N(G1)
         - sum_{k=0}^{M-1} N(x_k) * (p(x_{k+1}) - p(x_k)) ,
  x_0 = G1, x_k = k-th data zero, x_M = G2 (last zero); N(x_k) =
  N_G1 + k (absolute count, N_G1 = N(1e7) = 21,136,125 LMFDB pin).
Decomposing N = DN + N_asym (DN = count defect, N_asym(x) =
(x/2pi)log(x/2pi) - x/2pi + 7/8):
    S1 = B - Dc + R
  B  := p(G2)*DN(G2) - p(G1)*DN(G1)                    (boundary)
  Dc := sum_{k=0}^{M-1} DN(x_k) * (p(x_{k+1}) - p(x_k))
       (the WALK-WEIGHTED gap sum -- the star; split near/far)
  R  := [p(G2)*Nas(G2) - p(G1)*Nas(G1)] - sum Nas(x_k) dp_k
       (smooth; R ~= -int N_asym p' dx as M -> infinity).
  SATELLITE GATE: S1 vs the L-form (N-weighted) must agree to
  fsum precision (longdouble); the Dc/R split then is exact data.
Every piece is computed EXACTLY from the pinned zero data (no
quadrature in this step).

Pre-registered anatomy read:
  - if |C_near| (gap-sum mass in [t-200, t+200]) ~ |residual| scale
    and C_far is small: the O(1) defect is LOCAL lattice structure
    (gap geometry + walk value near t).  W2 = local spacing control.
  - if C_far is comparable to C_near: the accumulated walk
    N_asym-weighted by the far p' carries mass.  W2 = global
    RH-level counting bound times explicit weights.
NOTE: individual terms are O(1e3)..O(1e7) with cancellation to
O(1)-O(4) (the documented "cancellation residual" structure); this
probe reports the pieces and the residual, not a new value of Efull.

Data: the audited pipeline load itself (TH.tail(): cache_lo
(1e7, 3.1946e7) 52,290,633 zeros + band (3.1946e7, G_LAST]
2,792,198,664 zeros; seam Nt = 73,426,758 pinned).
N(1e7) = 21,136,125 (LMFDB pin) for the G1 boundary.

Resources: single core (taskset -c 27 at launch; 5 cores left free),
~23GB (the same page-cache-resident arrays the pipeline uses),
chunked band passes (4e8).
"""
import numpy as np
import sys, time
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
import day024_tail_hi1e9 as TH

G1 = 1.0e7
N_G1 = 21_136_125          # exact: LMFDB pin (0, 1e7]
CH = 400_000_000
NEAR = 200.0

def n_asym(x):
    return (x / (2 * np.pi)) * np.log(x / (2 * np.pi)) - x / (2 * np.pi) + 0.75

def p_of(g, t):
    a = np.abs(g - t)
    return (np.log(a) + np.log(g + t) - np.log(g * g + 0.25)
            + 0.5 / (g * g + 0.25))

def anatomy(T, t, label):
    g1, g2 = T.cache_lo, T.b
    t64 = np.float64(t)
    # straddle-safety: distance from t to the nearest zero
    i_t = int(np.searchsorted(g2, t, side='left'))
    near = [abs(t - g2[max(0, i_t - 2)]), abs(t - g2[min(g2.size, i_t + 1)])]
    dmin = min(near)
    if dmin < 1e-3:
        print("  ABORT: zero within 1e-3 of t=%r (d=%.3g)" % (t, dmin), flush=True)
        return
    n_asym_g2 = float(n_asym(g2[-1]))
    n_asym_g1 = float(n_asym(G1))
    n_g2 = N_G1 + g1.size + g2.size          # exact integer count at G2
    dn_g2 = n_g2 - n_asym_g2                 # DN(G2)
    dn_g1 = N_G1 - n_asym_g1                 # DN(G1)
    p_g2 = float(p_of(np.array([g2[-1]]), t64)[0])
    p_g1 = float(p_of(np.array([G1]), t64)[0])
    B = p_g2 * dn_g2 - p_g1 * dn_g1
    s1 = np.longdouble(0.0)                  # sum p(gamma)
    lform = np.longdouble(0.0)               # sum N(x_k) * dp_k (L-form)
    dc = np.longdouble(0.0)                  # sum DN(x_k) * dp_k (walk)
    dc_near = np.longdouble(0.0)             # walk, gap in [t-NEAR, t+NEAR]
    nas_ds = np.longdouble(0.0)              # sum Nas(x_k) * dp_k
    maxabs_dn = 0.0
    last_x, last_p = G1, p_g1           # x_0 = G1, N(x_0) = N_G1
    ncount = 0                               # data zeros seen (0-based)
    t0 = time.time()
    for arr in (g1, g2):
        step = CH if arr is g2 else arr.size
        for off in range(0, arr.size, step):
            a = np.ascontiguousarray(arr[off:off + step], dtype=np.float64)
            p = p_of(a, t64)
            if p.size:
                carry = np.empty(p.size + 1, dtype=np.float64)
                carry[0] = last_p
                carry[1:] = p
                dp = carry[1:] - carry[:-1]                    # dp per gap
                # left endpoints x_k: [last_x, a[0], ..., a[-2]] ; the
                # k-th gap of this chunk: N(x_k) = N_G1 + ncount + k
                # (last_x = G1 counts as data-index 0, verified form).
                lx = np.empty(p.size, dtype=np.float64)
                lx[0] = last_x
                lx[1:] = a[:-1]
                idxN = N_G1 + ncount + np.arange(p.size, dtype=np.float64)
                nas = n_asym(lx)
                dnv = idxN - nas
                wN = idxN.astype(np.longdouble) * dp.astype(np.longdouble)
                lform += np.sum(wN)
                wD = dnv.astype(np.longdouble) * dp.astype(np.longdouble)
                dc += np.sum(wD)
                wnas = nas.astype(np.longdouble) * dp.astype(np.longdouble)
                nas_ds += np.sum(wnas)
                m = (lx > t - NEAR) & (lx < t + NEAR)
                dc_near += np.sum(wD[m])
                maxabs_dn = max(maxabs_dn, float(np.max(np.abs(dnv))))
            ncount += a.size
            if p.size:
                last_x, last_p = float(a[-1]), float(p[-1])
            s1 += np.sum(p.astype(np.longdouble))
    # gate and anatomy
    L = (p_g2 * n_g2 - p_g1 * N_G1) - float(lform)   # L-form value of S1
    R = (p_g2 * n_asym_g2 - p_g1 * n_asym_g1) - float(nas_ds)
    print("t = %.1f %s  (min |g-t| = %.4g;  %.1f min)" % (t, label, dmin,
          (time.time() - t0) / 60), flush=True)
    print("  GATE  S1 vs L-form |d|          = %.3e (must be ~1e-6 or less)"
          % abs(float(s1) - L), flush=True)
    print("  S1  = sum p(gamma)              = %+.6e" % float(s1), flush=True)
    print("  B   = boundary DN terms         = %+.6e" % B, flush=True)
    print("  Dc  = walk-weighted gap sum     = %+.6e" % float(dc), flush=True)
    print("       Dc_near [t-200,t+200]      = %+.6e" % float(dc_near), flush=True)
    print("       Dc_far                      = %+.6e" % float(dc - dc_near),
          flush=True)
    print("  R   = smooth (Nas) part         = %+.6e" % R, flush=True)
    print("  check S1 - (B - Dc + R)         = %.3e (must be ~0)"
          % (float(s1) - (B - float(dc) + R)), flush=True)
    print("  walk stats: DN(G1) = %+.6e  DN(G2) = %+.6e  max|DN| = %.3e"
          % (dn_g1, dn_g2, maxabs_dn), flush=True)
    print(flush=True)

def main():
    T = TH.tail()
    ts = [39_000_000.5,   # A-1 anchor (3.9e7 straddle height + 1/2)
          100_000_000.5,  # 1e8
          300_000_000.5]  # 3e8  -- all windows [t/2, 2t] inside (1e7, G_LAST)
    for t in ts:
        anatomy(T, t, "")

if __name__ == '__main__':
    main()
