#!/usr/bin/env python3
"""0274: the optimal-split wall quantification for the terminal face.

The 0273 face probe split the xi-product at GLAST = 3.0013e9, but the
project has verified on-line zero ORDINATES up to 3.0e10 (hi3e10 band,
92,577,877,714 zeros, 3E10-BAND.md). This unit splits at G2 = 3.0e10
(the strongest available data) and rigorously quantifies:

  K'_opt = K'(GLAST) + [ sum_{(G1,G2]} f - Int_{G1}^{G2} f rho dg ]
         in  K'(GLAST) +/- |band|   (telescoping per-unit-sum bound)
  B_unk_opt(s) = B1 * ( |f(G2)| + TV(G2->t) + |f(t)| + TV(t->inf) )
                 (per-unit-sum form, Titchmarsh 9.2 / Zeta23 LocalCount,
                  B1 = A0 ln tPT2; exact telescoping TV, no quad)
  wall iff  max_band(K'_opt) - min(B_unk_opt) < 0  on the face sigmas.

Unit A (fast, seconds): integrals + monotonicity + wall verdict (bands).
Unit B (--sum, hours, background): exact float64 Kahan-chunked sum of f
over the 92.5e9 zeros in (G1, G2] of the 3e10 band (raw f64, NO header:
740,623,021,712 bytes == 8 x 92,577,877,714 per 3E10-BAND.md) -> pins
K'_opt to the data floor, replaces the band.

NO RH claim. Negative-result unit: quantifies how far the best-split
explicit-formula main term is from the certified fluctuation bound.
"""
import os, sys, time, math
import numpy as np
import mpmath as mpm

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
TPT2 = mpm.mpf("3000175332800")
A0 = mpm.mpf("3.4")                      # Zeta23-RvM LocalCount (Titchmarsh 9.2), as day069
SIGS = [0.1252270103, 0.25, 0.40, 0.49]
# K' from the validated day072 run (3e9 split), out_day072_face_U_repair.txt:
K3E9 = {0.1252270103: -9042.185335, 0.25: -9045.537874,
        0.40: -9049.568635, 0.49: -9051.986604}

f64_3e10 = "hi3e10/zeros_2999e6_to_30000e6.f64"
G1 = 3001345999.873009                  # GLAST (day072 S-stream coverage end)

import struct
def _first8(p):
    return struct.unpack_from("<d", open(p, "rb").read(8))[0]
def _last8(p):
    with open(p, "rb") as fh:
        fh.seek(-8, 2)
        return struct.unpack("<d", fh.read(8))[0]

sz = os.path.getsize(f64_3e10)
assert sz % 8 == 0, f"3e10 band not raw-f64: size {sz} not divisible by 8"
n_tot = sz // 8
zfirst, zlast = _first8(f64_3e10), _last8(f64_3e10)
print(f"3e10 band: n = {n_tot} (expect 92,577,877,714)  first = {zfirst!r} last = {zlast!r}")
assert n_tot == 92577877714
assert 2999246000.0 < zfirst < 2999246100.0, "first zero off (expected ~2,999,246,000.18)"
G2 = float(zlast)
print(f"G2 = {G2!r}  (expect ~30,001,045,999.98)")

def fF(g, sr, tF):
    a = 0.5 - sr
    g2 = g * g + 0.25
    return 0.5 * math.log((a * a + (g - tF) ** 2) / g2) \
         + 0.5 * math.log((a * a + (g + tF) ** 2) / g2) \
         + sr / g2

def rhoF(g):
    return math.log(g / (2.0 * math.pi)) / (2.0 * math.pi)

def tv_exact(fs, fe, fmid, kind):
    """exact telescoping TV for a monotone piece (verified separately)."""
    return abs(fe - fs)

results = {"A": {}}
tF = float(TPT2)
B1 = float(A0 * mpm.log(TPT2))
print(f"\nB1 = A0 ln(tPT2) = {B1:.4f}")

for sm in SIGS:
    sr = sm; a = 0.5 - sr
    # --- (1) center: Int_{G1}^{G2} f rho dg (dps-40, log grid, smooth range)
    mpm.mp.dps = 40
    tM = TPT2
    def fmp(g):
        g2 = g * g + mpm.mpf("0.25")
        A = (a * a + (g - tM) ** 2) / g2
        B2 = (a * a + (g + tM) ** 2) / g2
        return 0.5 * (mpm.log(A) + mpm.log(B2)) + sr / g2
    gs = float(G1); ge = G2
    pts = [gs * ( ge / gs) ** (mpm.mpf(j) / 2000) for j in range(2001)]
    INT = mpm.quad(lambda g: fmp(g) * mpm.log(g / (2 * mpm.pi)) / (2 * mpm.pi), pts)
    # --- (2) monotonicity on (G1, t]: must be decreasing; on [t, 32t]: increasing
    xs = G1 * (tF / G1) ** (np.linspace(0, 1, 200001))
    vs = np.array([fF(x, sr, tF) for x in xs])
    d = np.diff(vs)
    assert bool(np.all(d <= 1e-9)), f"f NOT decreasing on (G1,t] sigma={sm}"
    xs2 = tF * (32.0) ** (np.linspace(0, 1, 200001))
    vs2 = np.array([fF(x, sr, tF) for x in xs2])
    d2 = np.diff(vs2)
    assert bool(np.all(d2 >= -1e-9)), f"f NOT increasing on [t,32t] sigma={sm}"
    fG1 = fF(G1, sr, tF); fG2 = fF(G2, sr, tF); ft = fF(tF, sr, tF)
    # --- (3) rigorous bands (telescoping per-unit-sum, exact TV)
    corr_band = B1 * (abs(fG1) + (fG1 - fG2))          # |sum-Int| on (G1,G2]
    Bopt = B1 * (abs(fG2) + (fG2 - ft) + abs(ft) + (0.0 - ft))
    Klo = K3E9[sm] - corr_band
    Khi = K3E9[sm] + corr_band
    results["A"][sm] = dict(INT=float(INT), fG1=fG1, fG2=fG2, ft=ft,
                            corr_band=corr_band, Bopt=Bopt, Klo=Klo, Khi=Khi)

print()
print("UNIT A: optimal-split (G2 = 3.0e10) wall quantification at t = tPT2")
print("  K'_opt = K'(G1) + [sum_{(G1,G2]} f - Int_{G1}^{G2} f rho dg]")
print(f"        Int center (dps-40) shown; band = B1*(|f(G1)|+TV(G1->G2)) telescoping")
print(f"{'sigma':>12} | {'Int(G1,G2)':>13} | {'band':>9} | {'K_opt range':>22} | "
      f"{'f(G2)':>8} | {'f(t)':>9} | {'B_opt(cert)':>12} | {'maxK-B(min)':>12} | wall")
for sm in SIGS:
    r = results["A"][sm]
    margin = r["Khi"] - r["Bopt"]
    print(f"{sm:>12.10f} | {r['INT']:>+13.4f} | {r['corr_band']:>9.2f} | "
          f"[{r['Klo']:>9.2f}, {r['Khi']:>9.2f}] | {r['fG2']:>8.4f} | {r['ft']:>9.5f} | "
          f"{r['Bopt']:>12.2f} | {margin:>+12.2f} | {'YES(<0)' if margin < 0 else 'NO-!'}")
wall = all(r["Khi"] - r["Bopt"] < 0 for r in results["A"].values())
print()
print(f"UNIT A VERDICT: optimal-split wall on the face at t = tPT2: "
      f"{'CONFIRMED (max K_opt - min B_opt < 0 for every face sigma)' if wall else 'FAILED - investigate'}")
print("  (the 0273 wall at the G1 = 3e9 split was maxK-B = -16,085..-19,274;")
print("   this is the SHARPEST available negative statement with current data.)")

# Unit B (the exact 92.5e9-zero sum that PINS K'_opt to the data floor)
# lives in day073b_3e10_sum.py (multiprocess, vectorized float64,
# block-pairwise np.sum). Run it in the background; when it lands it
# supersedes the +/-1799 bands above with a +/-~1 pinned K'_opt.
print("DONE (unit A). Unit B: python3 -u day073b_3e10_sum.py &")
