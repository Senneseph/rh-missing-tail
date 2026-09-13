# Day-022 — the CROSS-BAND generality extension of the day-020 worstcase
# audit (route A: resid < dev at every scan point for a candidate pair).
#
# Provenance: the kernel/zeta/closed-form functions are copied VERBATIM from
# scripts/rh/day020_worstcase.py (which carries them verbatim from
# /tmp/rh/d4_d3_run.py, day009c blob 63ea96d5).  SAME window (W = 12),
# SAME grid (DT = 0.25, the 7-delta grid), SAME formulas — the only new
# content is the candidate heights: t0 in {2000, 2500, 3000, 4000, 5000,
# 7500, 10000}, g = the ACTUAL zero nearest each t0 (the pair being moved
# is that height own pair, as in day-020).  The record's role: the
# per-point package (hZero/hDef/hStrict of the C6 audit-point closure)
# was verified on the 4 pairs of the t ~ 1000 region (day-020, worst
# margin 112.6); this run extends the verification toward the audit
# ceiling t ~ 1e4, so that the "any hypothetical minimal off-line pair"
# claim of the S8 closure carries a cross-band measurement record up to
# the ceiling.  COMPUTE, NEVER RECALL.
import numpy as np
from mpmath import mp
mp.dps = 15
PI = mp.pi
EULER_G = mp.euler
G_MAX = mp.mpf("300000")

import sys, os
LIST_CANDS = [
    "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T300000_ext_full.txt",
    "/work/scripts/rh/zeros_T300000_ext_full.txt",
]
LIST = next(p for p in LIST_CANDS if os.path.exists(p))

gammas = np.loadtxt(LIST, dtype=np.float64)
GN = gammas[:int(np.searchsorted(gammas, 300000.0))]
print("list: %d zeros (<=3e5: %d)" % (gammas.size, GN.size), flush=True)

# ---------- verbatim from day009c (blob 63ea96d5) / d4_d3_run.py ----------
def logmain25212(s):
    return (s*mp.log(2*PI) - (1 + EULER_G/2)*s
            - mp.log(2) - mp.log(s - 1) - mp.loggamma(s/2 + 1))

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
    rho1 = mp.mpc(0.5, g)
    rho2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/rho1) + mp.log(1 - s/rho2)
            + s/rho1 + s/rho2)

def tail_int(s, G):
    t = abs(mp.im(s))
    split = max(G, 2*t)
    f = lambda g: pairlog(g, s) * (mp.log(g/(2*PI))/(2*PI))
    return mp.quad(f, [G, split, mp.inf])

def zeta_line(t):
    return mp.zeta(mp.mpc(0.5, t))

def kernel_on_log(s):
    la, ar = product_on_line_vec(s, GN)
    if la is None:
        return None
    Tt = tail_int(s, G_MAX)
    return logmain25212(s) + mp.mpf(la) + mp.mpc(0, mp.mpf(ar)) + Tt

def on2(s, g):
    acc = mp.mpc(1)
    for sgn in (1.0, -1.0):
        rho = mp.mpc(0.5, sgn*mp.mpf(g))
        acc *= (1 - s/rho) * mp.e**(s/rho)
    return acc

def off4(s, g, delta):
    acc = mp.mpc(1)
    for rb in (mp.mpc(0.5 + delta), mp.mpc(0.5 - delta)):
        for sgn in (1.0, -1.0):
            rho = rb + sgn*mp.mpf(g)*mp.j
            acc *= (1 - s/rho) * mp.e**(s/rho)
    return acc

def off_ratio(s, g, delta):
    return off4(s, g, delta) / on2(s, g)
# ---------------------------------------------------------------

# ---------- exact closed form of R (P3/B5, Lean-proven) ----------
def R_closed(g, t, d):
    """(1/4+g^2)((g-t)^2+d^2)((g+t)^2+d^2) /
       ((g^2-t^2)((1/2+d)^2+g^2)((1/2-d)^2+g^2)) * e^{(1/2+it) w_d}"""
    g = mp.mpf(g); t = mp.mpf(t); d = mp.mpf(d)
    s = mp.mpc(0.5, t)
    w = (1 + 2*d)/((0.5 + d)**2 + g**2) + (1 - 2*d)/((0.5 - d)**2 + g**2) - 1/(0.25 + g**2)
    num = (0.25 + g**2)*((g - t)**2 + d**2)*((g + t)**2 + d**2)
    den = (g**2 - t**2)*((0.5 + d)**2 + g**2)*((0.5 - d)**2 + g**2)
    return num/den * mp.e**(s * w)

# ---------- straddle scan for one candidate pair height ----------
W = 12.0        # straddle window half-width (d4 grid covered +/-~10.2; W=12
DT = 0.25        # includes the queued t = 980 cross-band case for g ~ 999.8)
DG = (0.002, 0.005, 0.01, 0.02, 0.03, 0.05, 0.07, 0.1, 0.25, 0.5)

def straddle_scan(g, label):
    g = float(g)
    smp = mp.mpc(0.5, g)          # pair's own height (K_on vanishes here: the
    worst = None
    rows = []
    t = g - W
    i = 0
    # cross-check closed form vs direct 4-zero ratio once, at t = g + 0.7916
    tc = mp.mpf(g) + mp.mpf("0.7916")
    sc = mp.mpc(0.5, tc)
    rc = R_closed(g, tc, 0.005)
    rd = off_ratio(sc, g, 0.005)
    print(f"{label}: closed-vs-direct R(t={float(tc):.4f}, d=0.005): "
          f"|diff| = {mp.nstr(abs(rc - rd), 3)}", flush=True)
    while t <= g + W + 1e-9:
        if abs(t - g) > 1e-6:          # skip the exact singular height
            s = mp.mpc(0.5, t)
            klo = kernel_on_log(s)
            if klo is None:
                t += DT; i += 1; continue
            K = mp.e**klo
            resid = abs(zeta_line(t) - K)          # S10 LHS (A0: zeta - K_on)
            devf = min(abs(R_closed(g, t, d) - 1) for d in DG)
            dev = abs(K) * devf
            if resid > 0:
                margin = dev / resid
            else:
                margin = mp.inf
            rows.append((t, resid, dev, margin))
            if worst is None or margin < worst[3]:
                worst = rows[-1]
        t += DT
        i += 1
        if i % 8 == 0:
            print(f"  {label} progress t={t:.2f}", flush=True)
    if worst is None:
        return None
    print(f"\n{label}: WORST over [{g-W:.1f}, {g+W:.1f}] at t = {worst[0]:.6f}: "
          f"resid = {mp.nstr(worst[1], 10)}, dev = {mp.nstr(worst[2], 10)}, "
          f"MARGIN = {mp.nstr(worst[3], 10)}", flush=True)
    # print the 5 smallest margins
    rows.sort(key=lambda r: (r[3] if r[3] != mp.inf else 1e300))
    print(f"{label}: 5 smallest margins:", flush=True)
    for (tt, rr, dd, mm) in rows[:5]:
        print(f"   t = {tt:10.4f}  resid = {mp.nstr(rr, 3)}  "
              f"dev = {mp.nstr(dd, 3)}  margin = {mp.nstr(mm, 3)}", flush=True)
    return worst


# candidate pair heights: the day-022 extension band (t ~ 2e3 .. 1e4)
zero_of = lambda x: float(GN[np.argmin(np.abs(GN - x))])
cands = []
seen = set()
for x in (50000.0,):
    g = round(zero_of(x), 6)
    if g not in seen:
        seen.add(g)
        cands.append((g, f"g = {g:.6f} (candidate nearest {x:.0f})"))

allworst = None
for (g, lab) in cands:
    w = straddle_scan(g, lab)
    if w is not None and (allworst is None or w[3] < allworst[3]):
        allworst = w

print("\n--- DAY-021b WEAK-SPOT REFINEMENT SUMMARY ---")
print("weak-spot refinement: pair near t = 50000, DT = 0.25, 10-delta grid")
print("extension worst margin = %s  (t = %.4f)" % (mp.nstr(allworst[3], 4), allworst[0]))
print("day-020 baseline (t ~ 1000 region): worst margin = 112.6")
print("route-A pointwise decision resid < dev: "
      + ("HOLDS on the extended windows" if allworst[3] > 1 else "VIOLATED somewhere on the scan"))
print("RUN COMPLETE")
