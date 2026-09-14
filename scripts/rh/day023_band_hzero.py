#!/usr/bin/env python3
"""day-023 — band points hZero/hDef wire (S3): Xval pin at the (25f)
real-band window points, list scale G = 1e7, band (G, B] with
B = 3.15e7 (the actual zeros we hold: 47.5M, shards).

Xval = Bf(t,G)(Sbar B + Sbar G) + Cf(t,G) Kbar(G)  (B3Core mirrors,
copied verbatim from day020_xval_pin.py / B3Sbar.lean wiring).
xdefect = Tt - sum_{(G,B]} fT  (Tt = dps-30 model quad; the fT sum is
float64/longdouble over the actual zeros — the defect magnitude is
O(0.1-1), float is adequate for the pin record; the wire margin is
reported, not certified to dps-30).
S1 at the band points is automatic (|zeta| > 1: dev(1-|zeta|) < 0 <= Mf);
S2 is the DIRECT measured dev (= 1.0 in 25f, > the window/pin floors);
S4 = the 25f pointwise margin > 1.  This script supplies S3.
"""
import mpmath as mp, numpy as np
mp.mp.dps = 30
import day023_taildiscrete as td

TWOPI_INV = 1 / (2 * mp.pi)

def nHat(x): return mp.log(x * TWOPI_INV) * TWOPI_INV
def NHat(x): return x * TWOPI_INV * (mp.log(x * TWOPI_INV) - 1) + mp.mpf(7) / 8
def Sbar(x): return mp.mpf("0.110") * mp.log(x) + mp.mpf("0.290") * mp.log(mp.log(x)) + mp.mpf("2.290")
def u(x): return x * x + mp.mpf(1) / 4
def w(t): return t * t + mp.mpf(1) / 4
def fT_mp(t, x): return mp.mpf(1) / 2 / u(x) + mp.log(1 - w(t) / u(x))
def fT64(t, x):  # float64 mirror (x > t arrays)
    uu = x * x + 0.25
    ww = t * t + 0.25
    return 1.0 / (2.0 * uu) + np.log(1.0 - ww / uu)
def Bf(t, G):
    uw = w(t) / (G * G + mp.mpf(1) / 4)
    return mp.mpf(1) / (2 * (G * G + mp.mpf(1) / 4)) + uw / (1 - uw) + t / (G * G + mp.mpf(1) / 4)
def Cf(t, G):
    return 1 + 2 * w(t) * G * G / (G * G - t * t)
def Kbar(G):
    return (mp.mpf("0.110") * (mp.log(G) + mp.mpf(1) / 2)
            + mp.mpf("0.290") * (mp.log(mp.log(G)) + mp.mpf(1) / 2)
            + mp.mpf("2.290")) / (2 * G * G)

td.build_cache()
out = []
p = out.append
p("band hZero/hDef wire (S3): Xval pin, G = 1e7, band (1e7, 3.15e7] (actual zeros)")
p("  (25f window best-t points; S1 automatic (|zeta|>1), S2 = measured dev = 1.0, S4 = 25f margin)")
p("-" * 100)
G = 1.0e7
B = float(td._G_CACHE.max())
Bm = mp.mpf(repr(B))
Gm = mp.mpf(repr(G))
gh = td._G_CACHE
pts = [(9999999.740023555, "1e7 row"),
       (12000004.8033, "1.2e7 row"),
       (14999995.8889, "1.5e7 row"),
       (18000003.5807, "1.8e7 row"),
       (19999999.3837, "2e7 row"),
       (23999995.9546, "2.4e7 row"),
       (28000005.6729, "2.8e7 row")]
for (t64, lab) in pts:
    t = mp.mpf(repr(t64))
    # float64/longdouble fT sum over (G, B] actual zeros
    s64 = float(np.sum(fT64(t64, gh), dtype=np.longdouble))
    # dps-30 model quad (G, B]
    Tt = mp.quad(lambda x: nHat(x) * fT_mp(t, x), [Gm, Bm])
    xdefect = Tt - mp.mpf(repr(s64))
    Xval = Bf(t, Gm) * (Sbar(Bm) + Sbar(Gm)) + Cf(t, Gm) * Kbar(Gm)
    ok = abs(xdefect) <= Xval
    p("  %-11s t = %-15.6f  sum = %.10f  Tt = %s" % (lab, t64, s64, mp.nstr(Tt, 10)))
    p("  %-11s xdefect = %s  |x| <= Xval = %s : %s   MARGIN = %s"
      % ("", mp.nstr(xdefect, 10), mp.nstr(Xval, 10), "PASS" if ok else "FAIL",
         mp.nstr(Xval / abs(xdefect), 6) if xdefect != 0 else "inf"))
open("out_day023_band_hzero.txt", "w").write("\n".join(out) + "\n")
print("\n".join(out))
