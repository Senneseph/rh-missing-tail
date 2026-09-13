# Day-022 — P1.1b: regime-guarded cross-band statistics to 6e6.
# P1.1 (out_day022_tripwire_6e6.txt) "VIOLATED" verdict was proven to be
# a |K|-scale artifact of the day-020 dev/resid statistic (DISCOVERY_LOG
# 19).  This run keeps the day-020 statistic and functions VERBATIM
# (day020_worstcase.py chain, xval-pin provenance) and adds the regime
# guard that makes the statistic honest at high t:
#
#   a window point SUPPORTS the audit if   |zeta(t)| <= 2 * |K(t)|
#   (zeta no larger than 2x the kernel scale: resid and dev are then
#    both |K|-scaled, so resid < dev is informative).  In the
#    zeta-dominant regime (|zeta| > 2|K|) the point is a REGIME GAP:
#    the statistic is excluded from the verdict (not counted as a
#    violation, not counted as a pass).
#
#   per g:  worst supported margin over the window; support fraction.
#   trend:  worst supported margin across all g + support fractions.
#
# Multi-process across candidate pairs (32 cores; numpy/quad serial
# inside each).  COMPUTE, NEVER RECALL.
import sys, os
import numpy as np
from mpmath import mp
mp.dps = 20
PI = mp.pi
EULER_G = mp.euler

LIST_CANDS = [
    "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt",
]
def load_list():
    LIST = next(p_ for p_ in LIST_CANDS if os.path.exists(p_))
    gammas = np.loadtxt(LIST, dtype=np.float64)
    return gammas[:int(np.searchsorted(gammas, 6000000.0))]

def setup():
    global GN, G_MAX
    G_MAX = mp.mpf("6000000")
    GN = load_list()
setup()

def logmain25212(s):
    return (s*mp.log(2*PI) - (1 + EULER_G/2)*s - mp.log(2)
            - mp.log(s - 1) - mp.loggamma(s/2 + 1))
def product_on_line_vec(s, gv):
    t = float(mp.im(s))
    A = t*t + 0.25
    Bv = 1.0 / (0.25 + gv * gv)
    inner = 1.0 - A * Bv
    if np.abs(inner).min() < 1e-13:
        return None, None
    la = float(np.sum(0.5 * Bv + np.log(np.abs(inner))))
    ar = t * float(np.sum(Bv)) - float(np.pi * np.sum(gv < t))
    return la, ar
def pairlog(g, s):
    rho1 = mp.mpc(0.5, g); rho2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/rho1) + mp.log(1 - s/rho2) + s/rho1 + s/rho2)
def tail_int(s, G):
    t = abs(mp.im(s))
    split = max(G, 2*t)
    f = lambda g: pairlog(g, s) * (mp.log(g/(2*PI))/(2*PI))
    return mp.quad(f, [G, split, mp.inf])
def kernel_on(s):
    la, ar = product_on_line_vec(s, GN)
    if la is None: return None
    return mp.e**(logmain25212(s) + mp.mpf(la) + mp.mpc(0, mp.mpf(ar)) + tail_int(s, G_MAX))
def R_closed(g, t, d):
    g = mp.mpf(g); t = mp.mpf(t); d = mp.mpf(d)
    s = mp.mpc(0.5, t)
    w = ((1 + 2*d)/((0.5 + d)**2 + g**2)
         + (1 - 2*d)/((0.5 - d)**2 + g**2) - 1/(0.25 + g**2))
    num = (0.25 + g**2)*((g - t)**2 + d**2)*((g + t)**2 + d**2)
    den = (g**2 - t**2)*((0.5 + d)**2 + g**2)*((0.5 - d)**2 + g**2)
    return num/den * mp.e**(s * w)

W = 12.0
DT = 0.5
DG = (0.005, 0.01, 0.02, 0.05, 0.1, 0.25, 0.5)

def scan_pair(g, label):
    out = {label: {}, "label": label}
    g = float(g)
    res = []   # (t, supported, margin, res_v, dev_v, K, zeta)
    t = g - W
    nt = ns = 0
    while t <= g + W + 1e-9:
        if abs(t - g) > 1e-6:
            s = mp.mpc(0.5, mp.mpf(t))
            K = kernel_on(s)
            if K is not None:
                z = mp.zeta(s)
                resid = abs(z - K)
                devf = None
                for d in DG:
                    v = abs(R_closed(g, t, d) - 1)
                    devf = v if devf is None else min(devf, v)
                dev = abs(K) * devf
                supported = abs(z) <= 2 * abs(K)
                nt += 1
                if supported:
                    ns += 1
                res.append((t, supported, (dev/resid if resid > 0 else mp.inf),
                            resid, dev, abs(K), abs(z)))
        t += DT
    arr = [r for r in res if r[1]]
    worst = (min(arr, key=lambda r: float(r[2])) if arr else None)
    out[label] = {
        "n_points": nt, "n_supported": ns,
        "supported_frac": (ns/nt) if nt else 0.0,
        "worst_supported_margin": (float(worst[2]) if worst else None),
        "worst_point_t": (worst[0] if worst else None),
        "min_K_supported": (min(float(r[5]) for r in arr) if arr else None),
    }
    return out

if __name__ == "__main__":
    import concurrent.futures as cf
    cands = []
    seen = set()
    def zero_of(x):
        i = int(np.searchsorted(GN, x))
        c = GN[max(0, i-3):i+4]
        return float(min(c, key=lambda v: abs(v - x)))
    for x in (1000000.0, 2000000.0, 3000000.0, 4000000.0, 5000000.0, 6000000.0):
        g = round(zero_of(x), 6)
        if g not in seen:
            seen.add(g); cands.append((g, "g = %.6f (nearest %.0f)" % (g, x)))
    # anchor: the 5e4 weak spot from the 6e6 list (same list => same
    # statistic regime as the closing pin; the closing pin's list was
    # the 300k-capped one — record the cross-list anchor too)
    g = round(zero_of(49990.656752), 6)
    if g not in seen:
        seen.add(g); cands.append((g, "g = %.6f (5e4 weak-spot anchor)" % g))
    print("P1.1b run: %d pairs, list = %d zeros" % (len(cands), GN.size), flush=True)
    results = {}
    with cf.ProcessPoolExecutor(max_workers=len(cands)) as ex:
        futs = {ex.submit(scan_pair, g, lab): (g, lab) for (g, lab) in cands}
        for f in cf.as_completed(futs):
            (g, lab) = futs[f]
            try:
                r = f.result()
                results[lab] = r.get(lab)
                print(lab, "->", results[lab], flush=True)
            except Exception as e:
                print(lab, "-> ERROR:", e, flush=True)
    print("\n--- P1.1b REGIME-GUARDED TREND (10^3-anchor .. 6*10^6) ---")
    wsm = [r["worst_supported_margin"] for r in results.values()
           if r and r["worst_supported_margin"] is not None]
    for (gg, lab) in cands:
        r = results.get(lab)
        if r:
            print("%-42s support %6.1f%%  worst supported margin = %s"
                  % (lab[:42], 100*r["supported_frac"],
                     ("%.4f" % r["worst_supported_margin"]) if r["worst_supported_margin"] is not None else "n/a (regime gap)"))
    if wsm:
        print("worst supported margin across all g = %.4f" % min(wsm))
    print("interpretation: supported-margin < 1 anywhere = genuine (regime-valid)")
    print("  audit weakness to investigate; 'n/a' = statistic blind at that g")
    print("  (regime gap — NOT a violation, NOT a pass).")
    print("P1.1b RUN COMPLETE")
