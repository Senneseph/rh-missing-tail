# Day-022 — P1.1d: the closure's ACTUAL metric (own-height/pole form,
# C1a) with the (height/B) model-error correction (DISCOVERY_LOG 20).
#
# v1 (day022_p11c_corrected.py) tested the OVER-STRICT window form
# (zero_c = |zeta(t)| * floor_R at window points, min over the window)
# — that fails generically at zeta-minima, which is EXPECTED and not
# the route's claim: the closure evaluates at the audit point
# t0 = g (the pair's own height, C1a: the ratio R has a pole there
# and the EXACT finite mass is |K^no-g| * |off4|).  v2 tests exactly
# that, per candidate pair g and per delta grid (worst over d):
#
#   zero'_own(g,d) = |Kno_g(t0)| * e^{E(t0)} * |off4(t0,g,d)|
#       K^no-g  = composite kernel with the g-pair EXCLUDED (12M
#                 product index-removed, same verified machinery)
#       e^E     = the (height/B) correction: K_true = K_comp * e^{E},
#                 E(t0) measured from the nearest non-zero window
#                 point (E varies smoothly; printed)
#   def'_own(g)  = B(t0) + |K'_comp(t0)| * |1 - e^{E(t0)}|
#       B       = P4 floor (Lean p8_B, argmin over N, verbatim)
#       second  = the moved kernel's model-defect bound
#                 (|K'_full - K'_comp| = |K'_comp| * |1 - e^{E'}|,
#                 E' ~ E(t0); the audit's hDef measured-defect side,
#                 the day-010 d4d3 protocol extended with the
#                 DISCOVERY_LOG-20 correction)
#   margin'_own = zero'_own / def'_own (worst over the d-grid)
#
# ANCHORS: g ~ 1e3 must reproduce the day-010 OWN-HEIGHT story
# ("missing term >= 99.8% of kernel magnitude; >= 14x the audit
# floor at own height" — margin'_own ~ O(10)); g = 5000.23
# (verified region) ~ O(10) class.  Masked band 2e4..1e5 = verdict
# (the pre-registered tripwire: margin crossing 1 = route-A
# pointwise death at that height).  32-process parallel.
# COMPUTE, NEVER RECALL.
import sys, os
import numpy as np
import math
from mpmath import mp
mp.dps = 30
PI = mp.pi
EULER_G = mp.euler
G_MAX = mp.mpf("6000000")
LIST = "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt"

def setup():
    gammas = np.loadtxt(LIST, dtype=np.float64)
    return gammas[:int(np.searchsorted(gammas, 6000000.0))]
GN = setup()

def logmain25212(s):
    return (s*mp.log(2*PI) - (1 + EULER_G/2)*s - mp.log(2)
            - mp.log(s - 1) - mp.loggamma(s/2 + 1))
def pairlog(g, s):
    rho1 = mp.mpc(0.5, g); rho2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/rho1) + mp.log(1 - s/rho2) + s/rho1 + s/rho2)
def tail_int(s, G):
    t = abs(mp.im(s))
    split = max(G, 2*t)
    f = lambda g: pairlog(g, s) * (mp.log(g/(2*PI))/(2*PI))
    return mp.quad(f, [G, split, mp.inf])
def kernel_on(s, except_idx=None):
    gv = GN if except_idx is None else np.delete(GN, except_idx)
    t = float(mp.im(s))
    A = t*t + 0.25
    Bv = 1.0 / (0.25 + gv * gv)
    inner = 1.0 - A * Bv
    if np.abs(inner).min() < 1e-13:
        return None
    la = float(np.sum(0.5 * Bv + np.log(np.abs(inner))))
    ar = t * float(np.sum(Bv)) - float(np.pi * np.sum(gv < t))
    return mp.e**(logmain25212(s) + mp.mpf(la) + mp.mpc(0, mp.mpf(ar)) + tail_int(s, G_MAX))
def off4(s, g, delta):
    d = mp.mpf(delta)
    acc = mp.mpc(1)
    for rb in (mp.mpc(0.5 + d), mp.mpc(0.5 - d)):
        for sgn in (1.0, -1.0):
            rho = rb + mp.mpf(sgn) * mp.mpf(g) * 1j
            acc *= (1 - s/rho) * mp.e**(s/rho)
    return acc

def p8_B(t, n):
    a = complex(0.5, t)
    t3 = abs(a * (a + 1) * (a + 2))
    return (0.5 * n**-0.5 + (math.hypot(0.5, t) / 12.0) * n**-1.5
            + (math.sqrt(3) / 540.0) * t3 * n**-2.5)
def B_best(t):
    best = None
    for m in range(1, 41):
        n = max(1, int(round(t / 2.0 * (0.25 + 0.075 * m))))
        b = p8_B(t, n)
        if best is None or b < best:
            best = b
    return best

DG = (0.005, 0.01, 0.02, 0.05, 0.1, 0.25, 0.5)

def ownheight(g, label):
    g = float(g)
    ik = int(mp.mpf(g) - 1) if False else int(np.searchsorted(GN, g, side="left"))
    if GN[ik] != g:
        ik = int(np.argmin(np.abs(GN - g)))
    t0 = g
    s0 = mp.mpc(0.5, mp.mpf(t0))
    # E(t0) from nearest non-zero window points (t0 is the pair's own
    # on-line zero: zeta = K_comp = 0 exactly there; E measured at
    # t0 +/- 1 where the log is defined)
    Evals = []
    for tt in (t0 - 1.0, t0 + 1.0):
        s = mp.mpc(0.5, mp.mpf(tt))
        K = kernel_on(s)
        if K is not None:
            z = mp.zeta(s)
            Evals.append(float(mp.log(abs(z)) - mp.re(mp.log(K))))
    E = min(Evals) if Evals else 0.0
    eE = math.exp(max(-50.0, min(50.0, E)))
    Kno = kernel_on(s0, except_idx=ik)
    B = B_best(t0)
    rows = []
    for d in DG:
        o4 = off4(s0, mp.mpf(g), d)
        Knoref = mp.re(mp.log(Kno))
        zero_own = abs(Kno) * eE * abs(o4)
        Kprime_comp = abs(Kno) * abs(o4)
        defc = B + Kprime_comp * abs(1.0 - eE)
        margin = zero_own / defc
        rows.append((d, zero_own, defc, margin, float(abs(o4))))
    worst = min(rows, key=lambda r: r[3])
    return {"g": g, "label": label, "ik": ik, "t0": t0, "E": E, "eE": eE,
            "Kno": float(abs(Kno)), "B": B,
            "worst_d": worst[0], "zero_own": worst[1], "def_own": worst[2],
            "margin_own": worst[3], "off4": worst[4],
            "nrows": len(rows)}

if __name__ == "__main__":
    import concurrent.futures as cf
    zero_of = lambda x: float(min(GN[max(0, int(np.searchsorted(GN, x))-3):
                                     int(np.searchsorted(GN, x))+4],
                                  key=lambda v: abs(v - x)))
    cands = [(zero_of(1000.0), "g ~ 10^3  (DAY-010 ANCHOR: own-height story ~14x class)")]
    cands.append((5000.234317, "g = 5000.23 (verified-regime anchor: O(10) class expected)"))
    for x in (7500.0, 10000.0, 15000.0, 20000.0, 30000.0, 50000.0, 75000.0, 100000.0):
        cands.append((round(zero_of(x), 6), "g ~ %.0f (mask band)" % x))
    print("P1.1d run: %d candidates (own-height closure metric, 32-core)"
          % len(cands), flush=True)
    results = []
    with cf.ProcessPoolExecutor(max_workers=len(cands)) as ex:
        futs = [ex.submit(ownheight, g, lab) for (g, lab) in cands]
        for f in cf.as_completed(futs):
            results.append(f.result())
    results.sort(key=lambda r: r["g"])
    print("\n--- P1.1d OWN-HEIGHT CLOSURE METRIC (corrected) ---")
    print("%-12s %9s %8s %9s %8s %8s %8s %9s" % (
        "g", "margin_own", "E", "e^E", "zero_own", "B", "def_own", "worst_d"))
    for r in results:
        print("%-12.4f %9.4f %8.4f %9.4f %8.4f %8.4f %8.4f %9.3f" % (
            r["g"], r["margin_own"], r["E"], r["eE"], r["zero_own"],
            r["B"], r["def_own"], r["worst_d"]))
        print("   (K^no-g = %.4f, |off4|@worst = %.4f, %s)" % (
            r["Kno"], r["off4"], r["label"]))
    w = min(results, key=lambda r: r["margin_own"])
    print("\nOVERALL WORST margin_own = %.4f at g = %.4f" % (w["margin_own"], w["g"]))
    above = [r for r in results if r["margin_own"] > 1.0]
    below = [r for r in results if r["margin_own"] <= 1.0]
    print("candidates with margin_own > 1: %d;  <= 1: %d" % (len(above), len(below)))
    print("PRE-REGISTERED TRIPWIRE: a corrected own-height margin crossing 1")
    print("at height T* => route-A pointwise squeeze dies above T* (ceiling).")
    print("P1.1d RUN COMPLETE")
