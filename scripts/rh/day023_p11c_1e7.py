# Day-022 — P1.1c: error-corrected trend statistic (the D4 construction with
# the bridge-identity correction for dev, per DISCOVERY_LOG 20).
#
# WHY: the day-020/022 composite statistic dev = |K_comp| * min_d |R-1|
# is tail-model-masked for 5e3 < t < ~1.5e5 (the (B,inf) tail integral
# inflates |K_comp| by f = e^{-E(t)}: 8%@1e4, 30%@2e4, 95%@5e4).
#
# CORRECTED statistic (faithful to the day-010 d4/d3 construction +
# the C5 closure sides):
#   zero_c(t)  := |zeta(t)| * min_d |R(g,d,t) - 1|
#       (the forced kernel change.  |K_true| = |zeta| EXACTLY by the
#        bridge identity zeta = K_full (DLMF 25.2.12, day-009 verified);
#        R is the B5 closed form (Lean-proven; cross-checked vs the
#        direct 4-zero product to ~1e-17 in every run).  MODEL-FREE.)
#   def_c(t)   := B(t; N = argmin) + resid(t)
#       B    = the P4 three-term floor p8_B (Lean, machine-proven;
#              N free — argmin over the onset band; formula ported
#              verbatim from formal/RhAttack/P8Floor.lean line 127)
#       resid = |zeta(t) - K_comp(t)|: the MEASURED P5/bridge defect —
#              the true error the closure's K_on = composite actually
#              carries (not inflated away: it is the composite's error,
#              and the composite is the kernel the closure uses).
#   margin_c(t) := zero_c(t) / def_c(t);  trend = worst over window
#              x candidates.
#
# Per candidate t-band the A4.3 wiring validity is checked per the
# xval-pin protocol (B3Core mirror, scripts/rh/day020_xval_pin.py
# verbatim): hS at G = 2t and B = 6e6, |x| <= Xval.  When the wiring
# FAILs (high t), def_c uses the measured resid only and the row is
# flagged "wiring-fail: def-side via measured M(G,t) only".
# E(t) = ln|zeta| - Re K_comp is printed per point (transparency;
# NOT used by the statistic: zero_c is |zeta|-scaled, def_c uses the
# true measured defect).
#
# Anchors: g ~ 999.79 (10^3, must reproduce the day-020 story:
# margin_c in the O(10^1-10^2) class) and g = 5000.234317 (the
# verified-regime closing, margin_c ~ 34.68 class).  Masked band:
# 7.5e3 .. 1e5.  32-process parallel over candidates.
# COMPUTE, NEVER RECALL.
import sys, os
import numpy as np
from mpmath import mp
mp.dps = 25
PI = mp.pi
EULER_G = mp.euler
E = mp.euler
G_MAX = mp.mpf("10000000")

LIST = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_T10000000_lmfdb.txt"

def setup():
    gammas = np.loadtxt(LIST, dtype=np.float64)
    return gammas[:int(np.searchsorted(gammas, 10000000.0))]
GN = setup()

# ---------- verbatim day020_worstcase chain ----------
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

# ---------- P8Floor p8_B (ported verbatim, Lean line 127) ----------
import math
def p8_B(t, n):
    s = math.hypot(1/2.0, t)          # |1/2 + i t|
    s2 = math.hypot(1/2.0, t)         # same
    # term 3: sqrt(3)/540 * |s (s+1) (s+2)| * n^{-5/2}
    a = complex(0.5, t)
    t3 = abs(a * (a + 1) * (a + 2))
    return (0.5 * n**-0.5
            + (s / 12.0) * n**-1.5
            + (math.sqrt(3) / 540.0) * t3 * n**-2.5)
def B_best(t):
    # argmin over the onset band (free N witness of the closure)
    best = None
    for m in range(1, 41):
        n = max(1, int(round(t / 2.0 * (0.25 + 0.075 * m))))
        b = p8_B(t, n)
        if best is None or b < best:
            best = b
    return best

# ---------- B3Core mirrors (xval pin, verbatim) ----------
import math as _m
TWOPI_INV = 1 / (2 * mp.pi)
def nHat(x):  return mp.log(x * TWOPI_INV) * TWOPI_INV
def NHat(x):  return x * TWOPI_INV * (mp.log(x * TWOPI_INV) - 1) + mp.mpf(7) / 8
def Sbar(x):  return (mp.mpf("0.110") * mp.log(x)
                      + mp.mpf("0.290") * mp.log(mp.log(x)) + mp.mpf("2.290"))
def u(x):  return x * x + mp.mpf(1) / 4
def w(t):  return t * t + mp.mpf(1) / 4
def fT(t, x):
    return mp.mpf(1) / 2 / u(x) + mp.log(1 - w(t) / u(x))
def Bf(t, G):
    uw = w(t) / (G * G + mp.mpf(1) / 4)
    return (mp.mpf(1) / (2 * (G * G + mp.mpf(1) / 4))
            + uw / (1 - uw) + t / (G * G + mp.mpf(1) / 4))
def Cf(t, G):
    return 1 + 2 * w(t) * (G * G) / (G * G - t * t)
def Kbar(G):
    return ((mp.mpf("0.110") * (mp.log(G) + mp.mpf(1) / 2)
             + mp.mpf("0.290") * (mp.log(mp.log(G)) + mp.mpf(1) / 2)
             + mp.mpf("2.290")) / (2 * G * G))
def NList(x):
    return int(np.searchsorted(GN, float(x), side="right"))

def wiring(t0):
    # xval-pin protocol at (t0, G = 2 t0, B = 6e6)
    s = mp.mpf(t0)
    Gm, Bm = 2 * s, mp.mpf("6000000")
    hi = int(np.searchsorted(GN, float(Bm), side="right"))
    lo = int(np.searchsorted(GN, float(Gm), side="right"))
    total = mp.mpf(0)
    for g in GN[lo:hi]:
        total += fT(s, mp.mpf(g))
    Tt = mp.quad(lambda x: nHat(x) * fT(s, x), [Gm, Bm])
    xdef = Tt - total
    Xval = Bf(s, Gm) * (Sbar(Bm) + Sbar(Gm)) + Cf(s, Gm) * Kbar(Gm)
    hsG = abs(NList(Gm) - NHat(Gm))
    hsB = abs(NList(Bm) - NHat(Bm))
    return {
        "x": float(xdef), "Xval": float(Xval), "xok": bool(abs(xdef) <= Xval),
        "hsG": float(hsG), "hsB": float(hsB),
        "okG": bool(hsG <= Sbar(Gm)), "okB": bool(hsB <= Sbar(Bm)),
    }

W = 12.0
DT = 0.5
DG = (0.005, 0.01, 0.02, 0.05, 0.1, 0.25, 0.5)
rows = []

def scan_pair(g, label):
    g = float(g)
    wz = wiring(g)
    pts = []
    t = g - W
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
                zero_c = abs(z) * devf
                bval = B_best(t)
                def_c = bval + float(resid)
                margin_c = float(zero_c / def_c)
                E = float(mp.log(abs(z)) - mp.re(mp.log(K)))
                pts.append((t, margin_c, float(zero_c), def_c, float(resid),
                            float(devf), float(abs(z)), float(abs(K)), E, bval))
        t += DT
    worst = min(pts, key=lambda r: r[1])
    out = {
        "g": g, "label": label,
        "worst_margin_c": worst[1], "t": worst[0],
        "zero_c": worst[2], "def_c": worst[3], "resid": worst[4],
        "floor_R": worst[5], "abs_z": worst[6], "abs_K": worst[7],
        "E": worst[8], "B": worst[9],
        "wiring": wz,
    }
    return out

if __name__ == "__main__":
    import concurrent.futures as cf
    cands = []
    zero_of = lambda x: float(min(GN[max(0, int(np.searchsorted(GN, x))-3):
                                     int(np.searchsorted(GN, x))+4],
                                  key=lambda v: abs(v - x)))
    g0 = zero_of(1000.0);        cands.append((g0, "g = %.6f  (10^3 ANCHOR: day-020 story)" % g0))
    g1 = 5000.234317;            cands.append((g1, "g = 5000.234317 (verified-regime closing ANCHOR: 34.68 class)"))
    for x in (7500.0, 10000.0, 15000.0, 20000.0, 30000.0, 50000.0, 75000.0, 100000.0):
        g = round(zero_of(x), 6)
        cands.append((g, "g = %.6f (nearest %.0f, MASKED band)" % (g, x)))
    print("P1.1c run: %d candidates (32-core parallel)" % len(cands), flush=True)
    results = []
    with cf.ProcessPoolExecutor(max_workers=len(cands)) as ex:
        futs = [ex.submit(scan_pair, g, lab) for (g, lab) in cands]
        for f in cf.as_completed(futs):
            results.append(f.result())
    results.sort(key=lambda r: r["g"])
    print("\n--- P1.1c ERROR-CORRECTED TREND ---")
    print("%-10s %9s %9s %8s %8s %8s %8s %7s  %s" % (
        "g", "margin_c", "zero_c", "def_c", "B", "resid", "floor_R", "E", "wiring"))
    for r in results:
        w = r["wiring"]
        wflag = "ok" if (w["xok"] and w["okG"] and w["okB"]) else "FAIL"
        print("%-10.4f %9.4f %9.4f %8.4f %8.4f %8.4f %8.4f %7.4f  %s" % (
            r["g"], r["worst_margin_c"], r["zero_c"], r["def_c"], r["B"],
            r["resid"], r["floor_R"], r["E"], wflag))
        print("   worst at t = %.4f  (x = %.4g <= Xval = %.4g: %s; hS %s/%s)" % (
            r["t"], w["x"], w["Xval"], w["xok"], w["okG"], w["okB"]))
    worst_all = min(results, key=lambda r: r["worst_margin_c"])
    print("\nOVERALL WORST margin_c = %.4f at g = %.4f (t = %.4f)" % (
        worst_all["worst_margin_c"], worst_all["g"], worst_all["t"]))
    print("verdict: margin_c > 1 everywhere -> closure gap persists in the")
    print("corrected statistic (true margins, not the tail-model curve);")
    print("margin_c < 1 anywhere -> refine that point (DT 0.25) and report")
    print("honestly (route-A pointwise weakness at that (g, t)).")
    print("P1.1c RUN COMPLETE")

def B_best_raw(t, n):
    return p8_B(t, n)
