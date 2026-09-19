#!/usr/bin/env python3
"""day035 S3c — pin the W2 cancellation numerically (queue item 1).

S3b established (exact data, gates green):
  S1 = B - Dc + R                      (IBP identity, R = NasEnd - NasSum)
and the smooth-side IBP:
  I_pr := int p rho = NasEnd - int Nas p'  (exact smooth identity)
so the defect  W := S1 - I_pr  satisfies the EXACT algebraic split
  W = (B - Dc) + (I_np - NasSum),   I_np := int N_asym p' dx .
S3b left I_np (and I_pr) UNCOMPUTED -- the "cancellation" read was
inferred.  This probe measures both directly:

  I_np = Nas(t)*log((G2-t)/(t-G1))
         + int [Nas(g)-Nas(t)]/(g-t) dg        (now SMOOTH)
         + int Nas(g)*q(g) dg,
         q = 1/(g+t) - 2g/(g^2+1/4) - g/(g^2+1/4)^2   (smooth);
  I_pr = int [G1,t-EPS] log|g-t| rho dg + int [t+EPS,G2] log|g-t| rho dg
         + int smooth_rest(g) rho dg,          EPS = 1e-8 (annulus ~1e-6)
  smooth_rest = log(g+t) - log(g^2+1/4) + 0.5/(g^2+1/4).

  All quads: geometric grids, dps-30/60 pair, spread = budget.
  The 1/(g-t) piece's singular part is the EXACT closed form
  Nas(t)*log((G2-t)/(t-G1)) (principal value) -- no quad touches a
  non-integrable endpoint.

Reads (pre-registered):
  P-1: |I_np - NasSum| = O(1)-O(10)  (the lattice Riemann sum for the
      Nas*p' integral is O(1)-accurate, not the generic O(1e4+))
      -> the IBP split carries the cancellation structurally; the
      W2 theorem reduces to bounding W itself via
      |DN| (pinned <= 3 on the band) + explicit log-kernel
      constants.
  P-2: |W| = O(1)-O(10) at all three heights (consistent with the
      measured Efull band on the splice).
  GATE: W_direct = S1 - I_pr  vs  W_byparts = (B - Dc) + (I_np -
      NasSum): must agree to quad/dps precision (~1e-3 or better).
  If P-1 FAILS (|I_np - NasSum| = O(1e3)+): the inferred
  cancellation was an artifact of the Efull-band identification;
  the wall re-shapes -- record and stop.

Resources: SOLO run (the box is idle; the 23GB load fits), taskset 27,
~15-25 min (3 numpy passes + ~30 dps-30/60 quads).
"""
import numpy as np
import sys, time
from mpmath import mp
sys.path.insert(0, '/home/jsmille/Projects/rh-missing-tail/scripts/rh')
import day024_tail_hi1e9 as TH
from day035_s3b_ibp_anatomy import n_asym, p_of, G1, N_G1, NEAR

HI = mp.mpf("1.0e18")
EPS = mp.mpf("1e-8")

def _n_asym_f(x):
    return (x / (2*mp.pi)) * mp.log(x / (2*mp.pi)) - x / (2*mp.pi) + mp.mpf("0.75")

def _rho_f(x):
    return mp.log(x / (2*mp.pi)) / (2*mp.pi)

def _pf(g, t):
    s = t - g
    return mp.log(abs(s)) + mp.log(g + t) - mp.log(g*g + mp.mpf("0.25")) \
        + mp.mpf("0.5") / (g*g + mp.mpf("0.25"))

def _qf(g, t):
    return 1/(g + t) - 2*g/(g*g + mp.mpf("0.25")) \
        - g/(g*g + mp.mpf("0.25"))**2

def ggrid(lo, hi, n):
    lo = mp.mpf(repr(float(lo))) if not isinstance(lo, mp.mpf) else lo
    hi = mp.mpf(repr(float(hi))) if not isinstance(hi, mp.mpf) else hi
    kk = mp.mpf(n)
    return [lo * (hi/lo)**(mp.mpf(j)/kk) for j in range(n + 1)]

def quad_pair(f, nodes, dps_lo=30, dps_hi=60):
    mp.dps = dps_lo
    vlo = mp.quad(f, nodes)
    mp.dps = dps_hi
    vhi = mp.quad(f, nodes)
    return float(vhi), float(abs(vlo - vhi))

def data_pass(T, t):
    """S3b core, values returned (S1, B, Dc, NasSum, dmin)."""
    g1, g2 = T.cache_lo, T.b
    t64 = np.float64(t)
    i_t = int(np.searchsorted(g2, t, side='left'))
    dmin = min(abs(t - g2[max(0, i_t - 2)]), abs(t - g2[min(g2.size, i_t + 1)]))
    n_asym_g2 = float(n_asym(g2[-1]))
    n_asym_g1 = float(n_asym(G1))
    n_g2 = N_G1 + g1.size + g2.size
    dn_g2 = n_g2 - n_asym_g2
    dn_g1 = N_G1 - n_asym_g1
    p_g2 = float(p_of(np.array([g2[-1]]), t64)[0])
    p_g1 = float(p_of(np.array([G1]), t64)[0])
    B = p_g2 * dn_g2 - p_g1 * dn_g1
    s1 = np.longdouble(0.0)
    dc = np.longdouble(0.0)
    dc_near = np.longdouble(0.0)
    nas_sum = np.longdouble(0.0)
    last_x, last_p = G1, p_g1
    ncount = 0
    CH = 400_000_000
    for arr in (g1, g2):
        step = CH if arr is g2 else arr.size
        for off in range(0, arr.size, step):
            a = np.ascontiguousarray(arr[off:off + step], dtype=np.float64)
            p = p_of(a, t64)
            if p.size:
                carry = np.empty(p.size + 1, dtype=np.float64)
                carry[0] = last_p
                carry[1:] = p
                dp = carry[1:] - carry[:-1]
                lx = np.empty(p.size, dtype=np.float64)
                lx[0] = last_x
                lx[1:] = a[:-1]
                idxN = N_G1 + ncount + np.arange(p.size, dtype=np.float64)
                nas = n_asym(lx)
                dnv = idxN - nas
                dc += np.sum(dnv.astype(np.longdouble) * dp.astype(np.longdouble))
                nas_sum += np.sum(nas.astype(np.longdouble) * dp.astype(np.longdouble))
                m = (lx > t - NEAR) & (lx < t + NEAR)
                dc_near += np.sum((dnv[m].astype(np.longdouble)
                                   * dp[m].astype(np.longdouble)))
            ncount += a.size
            if p.size:
                last_x, last_p = float(a[-1]), float(p[-1])
            s1 += np.sum(p.astype(np.longdouble))
    return {"S1": float(s1), "B": B, "Dc": float(dc),
            "Dc_near": float(dc_near), "NasSum": float(nas_sum),
            "dmin": dmin, "NasEnd": p_g2 * n_asym_g2 - p_g1 * n_asym_g1,
            "G2": float(g2[-1])}

def quads_for(t, G2):
    t60 = mp.mpf(repr(float(t)))
    G1m, G2m = mp.mpf(repr(G1)), mp.mpf(repr(G2))
    # smooth part 1: [Nas(g)-Nas(t)]/(g-t)
    n1 = ggrid(G1, G2, 400)
    f1 = lambda g: (_n_asym_f(g) - _n_asym_f(t60)) / (g - t60)
    v1, s1s = quad_pair(f1, n1)
    # smooth part 2: Nas(g)*q(g)
    f2 = lambda g: _n_asym_f(g) * _qf(g, t60)
    v2, s2s = quad_pair(f2, n1)
    # I_pr pieces
    nlo = ggrid(G1, t - float(EPS), 300)
    nhi = ggrid(t + float(EPS), G2, 300)
    flo = lambda g: mp.log(t60 - g) * _rho_f(g)
    fhi = lambda g: mp.log(g - t60) * _rho_f(g)
    frs = lambda g: (mp.log(g + t60) - mp.log(g*g + mp.mpf("0.25"))
                     + mp.mpf("0.5")/(g*g + mp.mpf("0.25"))) * _rho_f(g)
    vlo, vlo_s = quad_pair(flo, nlo)
    vhi, vhi_s = quad_pair(fhi, nhi)
    vrs, vrs_s = quad_pair(frs, n1)
    I_np = float(_n_asym_f(t60) * (mp.log(G2m - t60) - mp.log(t60 - G1m))
                 + mp.mpf(repr(v1)) + mp.mpf(repr(v2)))
    I_pr = float(mp.mpf(repr(vlo)) + mp.mpf(repr(vhi)) + mp.mpf(repr(vrs)))
    # annulus correction for I_pr (documented, ~1e-6)
    rho_t = float(_rho_f(t60))
    ann = 2 * rho_t * float(EPS * (mp.log(EPS) - 1))
    spreads = [s1s, s2s, vlo_s, vhi_s, vrs_s]
    return I_np, I_pr + ann, float(max(spreads)), ann

def main():
    T = TH.tail()
    G2 = float(T.b[-1])
    mp.dps = 60
    for t in (39_000_000.5, 100_000_000.5, 300_000_000.5):
        t0 = time.time()
        d = data_pass(T, t)
        I_np, I_pr, spread, ann = quads_for(t, G2)
        bracket = I_np - d["NasSum"]
        W_dir = d["S1"] - I_pr
        W_bp = (d["B"] - d["Dc"]) + bracket
        print("t = %.1f  (min |g-t| = %.4g;  %.1f min)"
              % (t, d["dmin"], (time.time() - t0) / 60), flush=True)
        print("  NasSum = %+12.4f   I_np = %+12.4f" % (d["NasSum"], I_np),
              flush=True)
        print("  bracket I_np - NasSum = %+.6f   (quad spread max % .3e, "
              "annulus %+ .3e)" % (bracket, spread, ann), flush=True)
        print("  B - Dc  = %+.6f   (Dc_near %+.4f / Dc_far %+.4f)"
              % (d["B"] - d["Dc"], d["Dc_near"], d["Dc"] - d["Dc_near"]),
              flush=True)
        print("  W_direct = S1 - I_pr      = %+.6f" % W_dir, flush=True)
        print("  W_byparts  = (B-Dc)+bracket = %+.6f" % W_bp, flush=True)
        print("  GATE |W_dir - W_bp| = %.3e (must be ~quad precision)"
              % abs(W_dir - W_bp), flush=True)
        print("  P-1 |bracket| O(1)-O(10)?  %s"
              % ("YES" if abs(bracket) < 10 else "NO (%.3g)" % abs(bracket)),
              flush=True)
        print("  P-2 |W| O(1)-O(10)?        %s"
              % ("YES" if abs(W_dir) < 10 else "NO (%.3g)" % abs(W_dir)),
              flush=True)
        print(flush=True)

if __name__ == '__main__':
    main()
