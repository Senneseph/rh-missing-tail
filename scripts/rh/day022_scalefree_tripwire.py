# Day-022 — scale-free own-height tripwire (fixes the sticky point found
# in out_day022_tripwire_6e6.txt: the day-020 dev = |K_on(t)| * min_d
# |R-1| statistic carries a hidden |K_on(t)| scale that degenerates in
# zeta-small regions (at t = 1e6, |K_on| ~ 1e-11 -> margin 5e-10 =
# artifact, not route violation).  The RATIO R(g,d,t) itself is
# scale-free (a ratio of kernel products; the B5 closed form is
# exact/Lean-proven), so the sound trend statistic is:
#   floor_ss(g)  = min_d min_{t in [g-W, g+W]} |R(g,d,t) - 1|
#   relativeMissing(g) = |zeta(g) - K_on(g)| / |K_on(g)|   (the d4
#   missing term RELATIVE to the kernel scale, at the pair's own
#   height)
#   margin_ss(g) = floor_ss / relativeMissing  (the closure's
#   own-height invariant, scale-free)
# Provenance: R_closed + logmain/product/tail VERBATIM from
# day020_worstcase.py line (day009c blob 63ea96d5); zero list to T =
# 6e6, G_MAX = 6e6.  COMPUTE, NEVER RECALL.
import sys, os
import numpy as np
from mpmath import mp
mp.dps = 20
PI = mp.pi
EULER_G = mp.euler
G_MAX = mp.mpf("6000000")
LIST_CANDS = [
    "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt",
]
LIST = next(p_ for p_ in LIST_CANDS if os.path.exists(p_))
gammas = np.loadtxt(LIST, dtype=np.float64)
GN = gammas[:int(np.searchsorted(gammas, 6000000.0))]
print("list: %d zeros" % GN.size, flush=True)

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

def scalefree_point(g, label):
    g = float(g)
    # (a) scale-free floor over the window x delta grid (mpmath only)
    floor_v = mp.inf
    t = g - W
    while t <= g + W + 1e-9:
        if abs(t - g) > 1e-6:
            for d in DG:
                v = abs(R_closed(g, t, d) - 1)
                if v < floor_v:
                    floor_v = v
        t += DT
    # (b) relative missing term at own height (the pair's own point:
    # zeta vs K_on; K_on ~ zeta on the line so the RELATIVE missing
    # term = |zeta-K|/|K| is the d4 missing term normalized)
    s = mp.mpc(0.5, g)
    K = kernel_on(s)
    rel = abs(mp.zeta(s) - K) / abs(K)
    margin = floor_v / rel
    print("%s: floor_ss = %s  relMissing_own = %s  margin_ss = %s  |K_own| = %s"
          % (label, mp.nstr(floor_v, 5), mp.nstr(rel, 5), mp.nstr(margin, 5), mp.nstr(abs(K), 5)), flush=True)
    return float(margin)

cands = []
seen = set()
zero_of = lambda x: float(GN[np.argmin(np.abs(GN - x))])
for x in (1000000.0, 2000000.0, 3000000.0, 4000000.0, 5000000.0, 6000000.0):
    g = round(zero_of(x), 6)
    if g not in seen:
        seen.add(g)
        cands.append((g, "g = %.6f (nearest %.0f)" % (g, x)))

worst = None
for (g, lab) in cands:
    m = scalefree_point(g, lab)
    if worst is None or m < worst:
        worst = m
print("\n--- SCALE-FREE TRIPWIRE (t to 6e6) ---")
print("worst margin_ss = %s" % worst)
print("rule: >1 with bounded envelope -> P1.2 proceed; <1 -> ceiling report")
print("RUN COMPLETE")
