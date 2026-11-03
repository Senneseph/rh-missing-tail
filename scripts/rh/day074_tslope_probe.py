#!/usr/bin/env python3
"""0274 (probe): the t-slope of K' at the face, settled numerically.

The 0273 entry's 'K' decreasing in t' line used dI_unk/dt ~ I_unk/t, which is
not valid (I_unk is not t-homogeneous: the height t moves inside f). The true
dI_unk/dt = Int (df/dheight) rho dg has a near-cancellation ((G1,t) piece
~ +8.75 vs far tail beyond t ~ -9.46), so the sign is NOT order-determined.
This probe measures it:

  K(t2) with t2 = tPT2 + 3e9 at the G1 (GLAST) split, same definitions as
  day072: K = S + I_unk - Re log phi + log(1/2)
    S     = sum over (0, GLAST] of the repaired data (one streaming pass)
    I_unk = dual independent dps-60 (u-substitution y-space + c4-decomp pin)
  slope estimate = (K(t2) - K(tPT2)) / 3e9, K(tPT2) from the validated run.

Also re-evaluates at t2: the certified telescoping fluctuation bound
B_unk(G1-split, height t2, B1 = A0 ln t2, exact monotone pieces, asserted on
grid), log|zeta(s)| (dps-40), the identity closure |fluct| <= B, and the
margin K(t2) - B(t2).

Interpretation:
  slope <= 0              -> the residual gap WIDENS in t: the whole face
                             (t >= tPT2) is the unexcluded residual, worst at
                             t = tPT2. Simplest possible frontier statement.
  slope > 0               -> the gap shrinks in t; crossing height estimate
                             t* = tPT2 + (B(t2)-K(t2))/slope; a second
                             probe nearer tPT2 is then required to delimit.

No RH claim. Pure finite-difference instrumentation of the validated machine.
"""
import os, time
import numpy as np
import mpmath as mpm
import day072_face_U_repair as D72
import day069_xiproduct_excl_probe as D69

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
TPT2 = D72.TPT2                       # 3000175332800
DT = mpm.mpf("3000000000")
T2 = TPT2 + DT                        # 3003175332800
GLAST = D72.GLAST
SIGS = [0.1252270103, 0.25, 0.40, 0.49]
K_TPT2 = {0.1252270103: -9042.185335, 0.25: -9045.537874,
          0.40: -9049.568635, 0.49: -9051.986604}   # validated day072 run
A0 = mpm.mpf("3.4")

print("0274 t-slope probe at t2 = tPT2 + 3e9 = ", str(T2))
print(f"GLAST = {GLAST!r}")

def stream_S(height):
    """G1-split S stream at probe height 'height' (float); day072 pattern."""
    bvals = []
    for (k, n) in D69.COVERAGE:
        if k == "txt":
            bvals.append(float(np.loadtxt(n)[:1][0]))
        elif k == "f64r":
            bvals.append(float(D72._f64vals(n)[0]))
        else:
            bvals.append(float(D69.load_lshard(n)[0]))
    tots = [np.float64(0.0) for _ in SIGS]; ntot = 0
    first = time.time()
    for idx, (kind, name) in enumerate(D69.COVERAGE):
        lo, hi = bvals[idx], (bvals[idx + 1] if idx + 1 < len(D69.COVERAGE) else 3.002e9)
        if kind == "txt":
            arr = np.loadtxt(name); arr = arr[np.isfinite(arr)]
        elif kind == "f64r":
            arr = D72._f64vals(name)
        else:
            arr = D69.load_lshard(name)
        arr = arr[(arr >= lo) & (arr < hi)]; arr = arr[np.isfinite(arr)]
        for i0 in range(0, arr.size, D69.STREAM_CHUNK):
            c = arr[i0:min(i0 + D69.STREAM_CHUNK, arr.size)]
            if not c.size:
                continue
            for j, sm in enumerate(SIGS):
                tots[j] += np.sum(D69.fpair_chunk(c, sm, float(height), 0.5 - sm),
                                  dtype=np.float64)
            ntot += c.size
        print(f"  file {idx:2d} ({name.split('/')[-1]:42s}) n={arr.size:12d} "
              f"({int(time.time()-first)}s)", flush=True)
    return tots, ntot

def bound_telescoping(sm, height_mpf):
    """B1(height)*(|f(G1)| + TV(G1->t) + |f(t)| + TV(t->inf)) with the
    same asserted-monotone pieces as day072 bound_rigorous; B1 = A0 ln(height)."""
    mpm.mp.dps = 50
    t = height_mpf
    sr = mpm.mpf(repr(sm))
    a = mpm.mpf("0.5") - sr
    def f(g):
        g2 = g * g + mpm.mpf("0.25")
        A = (a * a + (g - t) ** 2) / g2
        B = (a * a + (g + t) ** 2) / g2
        return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2
    g1 = mpm.mpf(str(GLAST))
    # monotonicity assertions (200k-point grids, as day072)
    npts = 200000
    xs1 = []
    for j in range(npts):
        xs1.append(g1 * (t / g1) ** (mpm.mpf(j) / (npts - 1)))
    v = [f(x) for x in xs1]
    for j in range(1, npts):
        if v[j] > v[j - 1] + mpm.mpf("1e-9"):
            raise AssertionError(f"f not decreasing on (G1,t] sigma={sm} at {xs1[j]}")
    xs2 = [t * (mpm.mpf(32)) ** (mpm.mpf(j) / (npts - 1)) for j in range(npts)]
    w = [f(x) for x in xs2]
    for j in range(1, npts):
        if w[j] < w[j - 1] - mpm.mpf("1e-9"):
            raise AssertionError(f"f not increasing on [t,32t] sigma={sm} at {xs2[j]}")
    fG = f(g1); ft = f(t)
    TV1 = fG - ft
    TV2 = 0 - ft
    B1 = A0 * mpm.log(height_mpf)
    return float(B1 * (abs(fG) + TV1 + abs(ft) + TV2)), float(ft), float(fG), float(TV1), float(TV2)

# ---------------- 1. dual main term at t2 ----------------
Iunk = {}
for sm in SIGS:
    mpm.mp.dps = 60
    Ic = mpm.mpf(repr(sm))
    t0 = time.time()
    I1 = D72.U_pin_c4(T2, g0=GLAST, sr_override=Ic)
    t1 = time.time()
    I2 = D72.I_unk_u(Ic, T2, GLAST, sr_override=Ic)
    spread = abs(I1 - I2)
    rel = spread / abs(I1)
    Iunk[sm] = (float(I1), float(spread))
    print(f"  sigma={sm:12.9f}  c4pin={float(I1):+.12e}  usub={float(I2):+.12e}  "
          f"spread={float(spread):.3e} (rel {float(rel):.2e}) "
          f"{'AGREE' if rel < 1e-7 else 'DISAGREE-!'}  ({int(time.time()-t0)}s)", flush=True)

# ---------------- 2. S stream at t2 ----------------
print("S stream at t2 (4 sigmas, one pass):", flush=True)
tots, ntot = stream_S(T2)
print(f"  TOTAL n = {ntot} (expect same 9,068,473,888 as day072)", flush=True)

# ---------------- 3. table + slope ----------------
print()
print(f"slope probe: t1 = tPT2 = {TPT2} (validated day072 K'), t2 = {T2}")
print(f"{'sigma':>12} | {'S(t2)':>14} | {'I_unk(t2)':>15} | {'-Re phi(t2)':>15} | "
      f"{'K(t2)':>10} | {'K(tPT2)':>10} | {'slope dK/dt':>12} | {'B(t2)':>10} | "
      f"{'log|z|':>9} | {'fluct':>11} | {'|f|<=B':>6} | {'K-B(t2)':>11}")
res = {}
for j, sm in enumerate(SIGS):
    mpm.mp.dps = 60
    s = mpm.mpc(mpm.mpf(repr(sm)), T2)
    ph = mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2) * mpm.gamma(s / 2))
    rephi = float(mpm.re(ph))
    Iv, spr = Iunk[sm]
    K2 = float(tots[j]) + Iv - rephi + float(mpm.log(mpm.mpf("0.5")))
    slope = (K2 - K_TPT2[sm]) / 3.0e9
    B, ft, fG, TV1, TV2 = bound_telescoping(sm, T2)
    mpm.mp.dps = 40
    lz = float(mpm.re(mpm.log(mpm.zeta(s))))
    fl = lz - K2
    okB = "yes" if abs(fl) <= B else "NO-!"
    excl = "yes" if (abs(fl) <= B and K2 - B > 0) else "no"
    res[sm] = dict(K2=K2, slope=slope, B=B, lz=lz, fl=fl, marg=K2 - B, excl=excl)
    print(f"{sm:>12.10f} | {float(tots[j]):>+14.3f} | {Iv:>+15.3f} | {-rephi:>+15.3f} | "
          f"{K2:>+10.4f} | {K_TPT2[sm]:>+10.4f} | {slope:>+12.6e} | {B:>10.2f} | "
          f"{lz:>+9.6f} | {fl:>+11.3f} | {okB:>6} | {K2 - B:>+11.2f}")

print()
slopes = [res[sm]["slope"] for sm in SIGS]
marg = [res[sm]["marg"] for sm in SIGS]
print(f"slopes (dK/dt): min {min(slopes):+.6e}  max {max(slopes):+.6e}")
print(f"margins K(t2)-B(t2): min {min(marg):+.2f}  max {max(marg):+.2f}")
closures = all(abs(res[sm]["fl"]) <= res[sm]["B"] for sm in SIGS)
print(f"identity closure at t2 (|fluct| <= B): {'ALL FOUR' if closures else 'FAIL-!'}")
if max(slopes) <= 0:
    print("VERDICT: slope <= 0 -> the residual gap WIDENS in t. The unexcluded")
    print("  residual is the WHOLE face (t >= tPT2), worst at t = tPT2.")
else:
    for sm in SIGS:
        if res[sm]["marg"] < 0 and res[sm]["slope"] > 0:
            star = 3.0e9 + (-res[sm]["marg"]) / res[sm]["slope"]
            print(f"  sigma={sm}: gap-shrinking slope {res[sm]['slope']:+.3e}/unit  "
                  f"-> crossing estimate at t2 + {star:.3e}")
    print("VERDICT: slope > 0 -> gap shrinks in t; run a nearer-t probe to delimit t*.")
print("NO RH claim.")
