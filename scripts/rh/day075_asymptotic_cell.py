#!/usr/bin/env python3
"""0275 (probe): the asymptotic cell at t3 = 1000 * tPT2 = 3.0001753328e15.

Purpose (unit 0275, the envelope-sharpening study):
  1. Re-validate the 0273a-r machine at a NEW height (1000x tPT2): the same
     dual main term (u-substitution + c4-decomp pin), the same S stream over
     the known zeros (0, GLAST], the same certified telescoping bound
     (B1 = A0 ln t3, exact monotone pieces, asserted on 200k grids), and the
     independent log|zeta(s)| (dps-50) -> identity closure |fluc| <= B.
  2. Measure the window-count discriminant of 0274 at t3 (the frontier unit
     window W = (t3-1, t3+1] on the zero ORDINATES, at the gData optimal cut):
         E_win = B1*( |f(G2)| + (f(G2)-f(t-1)) + 2*|f(t+1)| )
         k_max = floor((E_win - fluc) / |fedge|),  fedge = min_{W} f <= 0.
     At tPT2 this gave 33/33/34/34 (5.9x raw-law reduction). Asymptotically
     B1 ~ ln t and the kernel sum ~ ln t, so E_win ~ (ln t)^2 while fluc is
     t-frozen (day074: dK'/dt = -3.006e-9): k_max must GROW in t: the
     pointwise machinery's discriminating power decays like 1/ln t and the
     infinite face can never be closed cell-by-cell by it (structural).
  3. The A0 hierarchy (0275's pinned/cited audit), evaluated at BOTH heights:
         A0_data  = 2.615  (measured sup|DN| on the 3e10 band, W2Beyond3)
         A0_cite  = 3.4    (the CITED class constant used by 0273/0274)
         A0_rig   = 2*(ln 20 + 2)/ln(95/84) = 81.193...
                    (the MACHINEMADE formal Zeta23 disc-route constant,
                     anthropics/zeta-23-lean zeta23/Zeta23/RvM/LocalCount.lean,
                     A=1, C=20/3 growth, r=0.84, R=0.95, halving doubled)
     Consequences (named in the 0275 record): the window-count reduction
     33/33/34/34 is certified under A0_cite (P2: data pins A0 <= 2.615 only
     up to gData = 3e10); under A0_rig the validity premise still holds
     (fluc <= B_rig with a large margin) but the count reduction COLLAPSES.

No RH claim. Pure instrumentation of the validated machine at 1000x height.
"""
import os, time
import numpy as np
import mpmath as mpm
import day072_face_U_repair as D72
import day069_xiproduct_excl_probe as D69

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
TPT2 = D72.TPT2                       # 3000175332800
T3 = TPT2 * 1000                      # 3000175332800000 = 3.0001753328e15
GLAST = D72.GLAST

SIGS = [0.1252270103, 0.25, 0.40, 0.49]
A0 = mpm.mpf("3.4")

# Zeta23 formal constant (exact expression):
#   half_count_large: A1 = (|ln(3C)| + 2 A')/ln(R/r), C = 20/3, A' = 1,
#   r = 0.84, R = 0.95  ->  A1 = (ln 20 + 2)/ln(95/84)
#   total count (Halving.lean doubling): A0_rig = 2*A1.
mpm.mp.dps = 50
GDATA = mpm.mpf("30001045999.981976")     # hi3e10 band ceiling (day073b), exact at dps 50
A0_rig = 2 * (mpm.log(20) + 2) / mpm.log(mpm.mpf(95) / mpm.mpf(84))
print("0275 asymptotic cell at t3 = 1000*tPT2 =", str(T3))
print(f"GLAST = {GLAST!r}   GDATA = {GDATA!r}")
print(f"A0_rig (Zeta23 disc route, exact) = {float(A0_rig):.6f}")
print(f"A0_cite = 3.4 ; A0_data = 2.615 (sup|DN|, 3e10 band, W2Beyond3)")


def stream_S(height):
    """G1-split S stream at probe height 'height' (float); day072/day074 pattern."""
    bvals = []
    for (k, n) in D69.COVERAGE:
        if k == "txt":
            bvals.append(float(np.loadtxt(n)[:1][0]))
        elif k == "f64r":
            bvals.append(float(np.fromfile(n, dtype="<f8", count=1)[0]))
        else:
            bvals.append(float(D69.load_lshard(n)[0]))
    tots = [np.float64(0.0) for _ in SIGS]; ntot = 0
    first = time.time()
    nch = 2 ** 22  # 4.19M values ~ 33.5 MB per disk chunk (no full-file load,
                   # no boolean-mask duplication of the 22-24GB f64 files)
    for idx, (kind, name) in enumerate(D69.COVERAGE):
        lo, hi = bvals[idx], (bvals[idx + 1] if idx + 1 < len(D69.COVERAGE) else 3.002e9)

        def _proc(a, lo=lo, hi=hi):
            a = a[(a >= lo) & (a < hi)]
            a = a[np.isfinite(a)]
            n_used = 0
            for i0 in range(0, a.size, D69.STREAM_CHUNK):
                c = a[i0:min(i0 + D69.STREAM_CHUNK, a.size)]
                if c.size:
                    for j, sm in enumerate(SIGS):
                        tots[j] += np.sum(D69.fpair_chunk(c, sm, float(height), 0.5 - sm),
                                          dtype=np.float64)
                    n_used += c.size
            return n_used

        if kind == "txt":
            n_used = _proc(np.loadtxt(name))
        elif kind == "f64r":
            n_used = 0
            sz = os.path.getsize(name)
            nn = sz // 8
            for off in range(0, nn, nch):
                a = np.fromfile(name, dtype="<f8", offset=8 * off,
                                count=min(nch, nn - off))
                n_used += _proc(a)
                del a
        else:
            n_used = _proc(D69.load_lshard(name))
        ntot += n_used
        print(f"  file {idx:2d} ({name.split('/')[-1]:42s}) n={n_used:12d} "
              f"({int(time.time()-first)}s)", flush=True)
    return tots, ntot


def kernel_mpf(sr, t, g):
    a = mpm.mpf("0.5") - sr
    g2 = g * g + mpm.mpf("0.25")
    A = (a * a + (g - t) ** 2) / g2
    B = (a * a + (g + t) ** 2) / g2
    return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2


def bound_g1cut(sr, t):
    """B1*(|f(GLAST)| + (f(GLAST)-f(t)) + |f(t)| + (0-f(t))): day074 form.
    Returns (B, fG, ft, TV1, TV2)."""
    mpm.mp.dps = 50
    srm = mpm.mpf(repr(sr))
    g1 = mpm.mpf(str(GLAST))
    npts = 200000
    xs1 = [g1 * (t / g1) ** (mpm.mpf(j) / (npts - 1)) for j in range(npts)]
    v = [kernel_mpf(srm, t, x) for x in xs1]
    for j in range(1, npts):
        if v[j] > v[j - 1] + mpm.mpf("1e-9"):
            raise AssertionError(f"f not decreasing on (G1,t] sigma={sr} at {xs1[j]}")
    xs2 = [t * (mpm.mpf(32)) ** (mpm.mpf(j) / (npts - 1)) for j in range(npts)]
    w = [kernel_mpf(srm, t, x) for x in xs2]
    for j in range(1, npts):
        if w[j] < w[j - 1] - mpm.mpf("1e-9"):
            raise AssertionError(f"f not increasing on [t,32t] sigma={sr} at {xs2[j]}")
    fG = kernel_mpf(srm, t, g1); ft = kernel_mpf(srm, t, t)
    TV1 = fG - ft; TV2 = -ft
    B1 = A0 * mpm.log(t)
    return float(B1 * (abs(fG) + TV1 + abs(ft) + TV2)), float(ft), float(fG), float(TV1), float(TV2)


def window_mpf(sr, t, g2):
    """0274 window discriminant at the g2 cut:
    E_win = B1*(|f(g2)| + (f(g2)-f(t-1)) + 2|f(t+1)|);
    fedge = min f on [t-1, t+1] (asserted monotone-adjacent: min at the t-side
    endpoint or the interior t; compute on a 401 grid and at t)."""
    mpm.mp.dps = 50
    srm = mpm.mpf(repr(sr))
    fG2 = kernel_mpf(srm, t, g2)
    ftm1 = kernel_mpf(srm, t, t - 1)
    ftp1 = kernel_mpf(srm, t, t + 1)
    ftt = kernel_mpf(srm, t, t)
    grid = [t - 1 + mpm.mpf(j) / 200 for j in range(201)]
    fedge = min([kernel_mpf(srm, t, x) for x in grid] + [ftt])
    B1 = A0 * mpm.log(t)
    Ewin = float(B1 * (abs(fG2) + (fG2 - ftm1) + 2 * abs(ftp1)))
    return Ewin, float(fedge), float(fG2), float(ftm1), float(ftp1), float(B1)


# ---------------- 1. dual main term at t3 ----------------
import json as _json
Iunk = {}
_cache = "out_day075b_iunk_cache.json"
_icraw = {}
if os.path.exists(_cache):
    _icraw = _json.load(open(_cache))
for sm in SIGS:
    if repr(sm) in _icraw:
        I, spr = _icraw[repr(sm)]
        Iunk[sm] = (I, spr)
        print(f"  sigma={sm:12.9f}  [cache] c4pin={I:+.12e} spread={spr:.3e}", flush=True)
        continue
    mpm.mp.dps = 60
    Ic = mpm.mpf(repr(sm))
    t0 = time.time()
    I1 = D72.U_pin_c4(T3, g0=GLAST, sr_override=Ic)
    I2 = D72.I_unk_u(Ic, T3, GLAST, sr_override=Ic)
    rel = abs(I1 - I2) / abs(I1)
    Iunk[sm] = (float(I1), float(abs(I1 - I2)))
    _icraw[repr(sm)] = [float(I1), float(abs(I1 - I2))]
    _json.dump(_icraw, open(_cache, "w"))
    print(f"  sigma={sm:12.9f}  c4pin={float(I1):+.12e}  usub={float(I2):+.12e}  "
          f"spread={float(abs(I1-I2)):.3e} (rel {float(rel):.2e}) "
          f"{'AGREE' if rel < 1e-7 else 'DISAGREE-!'}  ({int(time.time()-t0)}s)", flush=True)

# ---------------- 2. S stream at t3 ----------------
print(f"S stream at t3 = {T3} (4 sigmas, one pass):", flush=True)
tots, ntot = stream_S(T3)
print(f"  TOTAL n = {ntot} (expect 9,068,473,888 as day072/day074)", flush=True)

# ---------------- 3. table ----------------
print()
print(f"asymptotic cell: t3 = {T3}  (1000 x tPT2 = {TPT2})")
print(f"{'sigma':>12} | {'S(t3)':>14} | {'I_unk(t3)':>15} | {'-Re phi(t3)':>15} | "
      f"{'K(t3)':>10} | {'B(t3)-G1cut':>13} | {'log|z|':>9} | {'fluc':>11} | "
      f"{'|f|<=B':>6} | {'B-fluc':>10} | {'E_win':>10} | {'fedge':>9} | {'k_max':>6}")
res = {}
for j, sm in enumerate(SIGS):
    mpm.mp.dps = 60
    s = mpm.mpc(mpm.mpf(repr(sm)), T3)
    ph = mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2) * mpm.gamma(s / 2))
    rephi = float(mpm.re(ph))
    Iv, spr = Iunk[sm]
    K3 = float(tots[j]) + Iv - rephi + float(mpm.log(mpm.mpf("0.5")))
    B, ft, fG, TV1, TV2 = bound_g1cut(sm, mpm.mpf(str(T3)))
    mpm.mp.dps = 50
    s50 = mpm.mpc(mpm.mpf(repr(sm)), T3)
    lz = float(mpm.re(mpm.log(mpm.zeta(s50))))
    fl = lz - K3
    okB = "yes" if abs(fl) <= B else "NO-!"
    Ew, fedge, fG2, ftm1, ftp1, B1v = window_mpf(sm, mpm.mpf(str(T3)), GDATA)
    kmax = int((Ew - fl) / (-fedge)) if fl < Ew else -1
    res[sm] = dict(K=K3, B=B, ft=ft, fG=fG, lz=lz, fl=fl, slack=B - fl,
                   Ew=Ew, fedge=fedge, kmax=kmax, B1=B1v, fG2=fG2)
    print(f"{sm:>12.10f} | {float(tots[j]):>+14.3f} | {Iv:>+15.3f} | {-rephi:>+15.3f} | "
          f"{K3:>+10.4f} | {B:>13.2f} | {lz:>+9.6f} | {fl:>+11.3f} | {okB:>6} | "
          f"{B-fl:>10.2f} | {Ew:>10.2f} | {fedge:>9.4f} | {kmax:>6}")

print()
print("A0 hierarchy consequences (same fluc, B scale A0*ln(t3)):")
lnt3 = float(mpm.log(mpm.mpf(str(T3))))
for sm in SIGS:
    r = res[sm]
    scale = r["B"] / (float(A0) * lnt3)     # kernel-sum factor
    B_rig = float(A0_rig) * lnt3 * scale
    Ew_rig = B_rig / (float(A0) * lnt3) * r["Ew"] * (float(A0_rig) / float(A0))
    kmax_rig = int((r["Ew"] * float(A0_rig) / float(A0) - r["fl"]) / (-r["fedge"]))
    print(f"  sigma={sm:12.10f}  B_rig={B_rig:>12.2f}  |fluc|<=B_rig: "
          f"{'yes' if abs(r['fl']) <= B_rig else 'NO-!'}  "
          f"E_win_rig={r['Ew']*float(A0_rig)/float(A0):>12.2f}  k_max_rig={kmax_rig:>7}")
closures = all(abs(res[sm]["fl"]) <= res[sm]["B"] for sm in SIGS)
print(f"\nidentity closure at t3 (|fluct| <= B): {'ALL FOUR' if closures else 'FAIL-!'}")
print("slacks B(t3)-fluc:  min", f"{min(res[sm]['slack'] for sm in SIGS):.2f}",
      " max", f"{max(res[sm]['slack'] for sm in SIGS):.2f}")
print("k_max(t3): min", min(res[sm]["kmax"] for sm in SIGS),
      " max", max(res[sm]["kmax"] for sm in SIGS),
      " (vs 33/33/34/34 at tPT2)")
print("No RH claim.")
