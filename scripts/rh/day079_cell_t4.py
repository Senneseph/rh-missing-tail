#!/usr/bin/env python3
"""day079  0276 STRUCTURAL CELL AT t4 = 10^6 * tPT2 (no RH claim).

Third point on the t-profile of the 0276 S-difference gate (sigma_A):
  tPT2 (3.0002e12): c* = 2.5821   (day078, gData cut)
  t3   (3.0002e15): c* = 1.3445   (day075b + day078)
  t4   (3.0002e18): c* = ?        (this run)
plus the corrected-machine identity closure at t4 (all four sigmas, mpf
K - the t3 float K3 has ulp ~0.5 at its 2.36e15 cancellation scale; at
t4 the components are ~1.3e20, float ulp ~32, unacceptable against
fluc ~ O(100)) and the A0c window k_max at t4 (structural growth).

The dual I_unk integrators (dps-60, c4-decomp pin vs u-substitution) are
re-validated at t4 (fresh, no t3 cache).

No RH claim. Pure continuation of the 0275/0276 asymptotic profile.
"""
import os, sys, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import numpy as np
import mpmath as mpm

import day069_xiproduct_excl_probe as D69
import day072_face_U_repair as D72

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
TPT2 = D72.TPT2
T4f = TPT2 * 1e6                      # 3000175332800000000.0 (exact float)
T4 = mpm.mpf("3000175332800000000")   # exact
GLAST = D72.GLAST
GDATA = mpm.mpf("30001045999.981976")

SIGS = [0.1252270103, 0.25, 0.40, 0.49]
A0 = mpm.mpf("3.4")


def stream_S(height):
    """S(height) = sum_{known zeros} fpair (4 sigmas), streamed 2^22 chunks.
    (day075b pattern; no full-file load of the 24-56GB f64 files)."""
    bvals = []
    for (k, n) in D69.COVERAGE:
        if k == "txt":
            bvals.append(float(np.loadtxt(n)[:1][0]))
        elif k == "f64r":
            bvals.append(float(np.fromfile(n, dtype="<f8", count=1)[0]))
        else:
            bvals.append(float(D69.load_lshard(n)[0]))
    tots = [np.float64(0.0) for _ in SIGS]
    ntot = 0
    first = time.time()
    nch = 2 ** 22
    for idx, (kind, name) in enumerate(D69.COVERAGE):
        lo, hi = bvals[idx], (bvals[idx + 1]
                              if idx + 1 < len(D69.COVERAGE) else 3.002e9)

        def _proc(a, lo=lo, hi=hi):
            a = a[(a >= lo) & (a < hi)]
            a = a[np.isfinite(a)]
            for j, sm in enumerate(SIGS):
                tots[j] += np.sum(D69.fpair_chunk(a, sm, float(height),
                                                  0.5 - sm), dtype=np.float64)
            return a.size

        if kind == "txt":
            ntot += _proc(np.loadtxt(name))
        elif kind == "f64r":
            sz = os.path.getsize(name)
            nn = sz // 8
            m = 0
            for off in range(0, nn, nch):
                a = np.fromfile(name, dtype="<f8", offset=8 * off,
                                count=min(nch, nn - off))
                m += _proc(a)
                del a
            ntot += m
        else:
            ntot += _proc(D69.load_lshard(name))
        print(f"  file {idx:2d} ({name.split('/')[-1]:42s}) n={ntot} "
              f"({int(time.time()-first)}s)", flush=True)
    return tots, ntot


def kernel_mpf(sr, t, g):
    a = mpm.mpf("0.5") - sr
    g2 = g * g + mpm.mpf("0.25")
    A = (a * a + (g - t) ** 2) / g2
    B = (a * a + (g + t) ** 2) / g2
    return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2


def bound_g1cut(sr, t):
    """A0c G1-cut envelope at height t (day074 form; monotone asserted)."""
    mpm.mp.dps = 50
    srm = mpm.mpf(repr(sr))
    g1 = mpm.mpf(repr(GLAST))
    npts = 200000
    xs1 = [g1 * (t / g1) ** (mpm.mpf(j) / (npts - 1)) for j in range(npts)]
    v = [kernel_mpf(srm, t, x) for x in xs1]
    for j in range(1, npts):
        if v[j] > v[j - 1] + mpm.mpf("1e-9"):
            raise AssertionError(f"f not decreasing (G1,t] sigma={sr}")
    xs2 = [t * mpm.mpf(32) ** (mpm.mpf(j) / (npts - 1)) for j in range(npts)]
    w = [kernel_mpf(srm, t, x) for x in xs2]
    for j in range(1, npts):
        if w[j] < w[j - 1] - mpm.mpf("1e-9"):
            raise AssertionError(f"f not increasing [t,32t] sigma={sr}")
    fG = kernel_mpf(srm, t, g1)
    ft = kernel_mpf(srm, t, t)
    TV1 = fG - ft
    TV2 = -ft
    B1 = A0 * mpm.log(t)
    return float(B1 * (abs(fG) + TV1 + abs(ft) + TV2))


def window_mpf(sr, t, g2):
    """0274 A0c window discriminant at the g2 cut."""
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
    return Ewin, float(fedge)


print("=" * 72)
print(f"day079: 0276 structural cell at t4 = {T4f:.6e}  (1e6 x tPT2)")
print("No RH claim. Asymptotic profile continuation of day075b (t3).")
print("=" * 72, flush=True)

# ---- 1. dual I_unk at t4 (mpf, dps-60, fresh) ----
print("\ndual I_unk at t4 (dps-60, c4pin vs u-sub):", flush=True)
Iunk = {}
for sm in SIGS:
    mpm.mp.dps = 60
    Ic = mpm.mpf(repr(sm))
    t0 = time.time()
    I1 = D72.U_pin_c4(T4f, g0=GLAST, sr_override=Ic)
    I2 = D72.I_unk_u(Ic, T4f, GLAST, sr_override=Ic)
    rel = abs(I1 - I2) / abs(I1)
    Iunk[sm] = (I1, float(abs(I1 - I2)))
    print(f"  sigma={sm:>12.10f}  c4pin={float(I1):+.6e}  usub={float(I2):+.6e}"
          f"  spread={float(abs(I1-I2)):.3e} (rel {float(rel):.2e}) "
          f"{'AGREE' if rel < 1e-7 else 'DISAGREE-!'}  ({int(time.time()-t0)}s)",
          flush=True)

# ---- 2. S stream at t4 ----
print(f"\nS stream at t4 = {T4f:.6e}:", flush=True)
tots, ntot = stream_S(T4f)
print(f"  TOTAL n = {ntot} (day072/074 convention 9,068,473,888)", flush=True)

# ---- 3. table (mpf K) ----
print()
print(f"asymptotic cell: t4 = {T4f:.6e}  (1e6 x tPT2 = {TPT2}")
hdr = (f"{'sigma':>12} | {'S(t4)':>14} | {'I_unk(t4)':>16} | {'-Re phi(t4)':>16} | "
       f"{'K(t4)':>11} | {'B(t4)-G1cut':>13} | {'log|z|':>9} | {'fluc':>10} | "
       f"{'|f|<=B':>6} | {'B-fluc':>10} | {'E_win':>10} | {'fedge':>9} | {'k_max':>6}")
print(hdr)
res = {}
for j, sm in enumerate(SIGS):
    mpm.mp.dps = 60
    s = mpm.mpc(mpm.mpf(repr(sm)), T4)
    ph = mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2)
                 * mpm.gamma(s / 2))
    rephi = mpm.re(ph)
    K3 = mpm.mpf(repr(tots[j])) + Iunk[sm][0] - rephi + mpm.log(mpm.mpf("0.5"))
    B = bound_g1cut(sm, T4)
    mpm.mp.dps = 50
    s50 = mpm.mpc(mpm.mpf(repr(sm)), T4)
    lz = mpm.re(mpm.log(mpm.zeta(s50)))
    fl = lz - K3
    okB = "yes" if abs(fl) <= B else "NO-!"
    Ew, fedge = window_mpf(sm, T4, GDATA)
    kmax = int((Ew - float(fl)) / (-fedge)) if fl < Ew else -1
    res[sm] = dict(K=float(K3), B=B, lz=float(lz), fl=float(fl),
                   slack=B - float(fl), Ew=Ew, fedge=fedge, kmax=kmax)
    print(f"{sm:>12.10f} | {tots[j]:>+14.3f} | {float(Iunk[sm][0]):>+16.3f} | "
          f"{float(-rephi):>+16.3f} | {float(K3):>+11.4f} | {B:>13.2f} | "
          f"{float(lz):>+9.6f} | {float(fl):>+10.3f} | {okB:>6} | "
          f"{B - float(fl):>10.2f} | {Ew:>10.2f} | {fedge:>9.4f} | {kmax:>6}",
          flush=True)

closures = all(abs(res[sm]["fl"]) <= res[sm]["B"] for sm in SIGS)
print(f"\nidentity closure at t4 (|fluct| <= B, A0c): "
      f"{'ALL FOUR' if closures else 'FAIL-!'}")
print("slacks B(t4)-fluc:  min",
      f"{min(res[sm]['slack'] for sm in SIGS):.2f}", " max",
      f"{max(res[sm]['slack'] for sm in SIGS):.2f}")
print("k_max(t4, A0c):", {f"{sm:.3f}": res[sm]["kmax"] for sm in SIGS},
      " (vs 349 at tPT2, 458-503 at t3: structural growth)")

# ---- 4. 0276 gate point at t4 (day078 S-route machinery) ----
print("\n0276 S-difference gate, t4 point (day078 e_win_s/Smax):")
import importlib.util
spec = importlib.util.spec_from_file_location("d78",
    os.path.join(BASE, "day078_hsxw_window.py"))
d78 = importlib.util.module_from_spec(spec)
import contextlib, io
with contextlib.redirect_stdout(io.StringIO()):
    spec.loader.exec_module(d78)
for sm in SIGS:
    smv = d78.mpm.mpf(repr(sm))
    EwS, fG2_, ftm1_, ftp1_ = d78.e_win_s(smv, T4, d78.GDATA)
    S0 = d78.Smax(d78.GLAST)
    c1 = d78.Smax(T4) + S0
    W1 = abs(fG2_) + (fG2_ - ftm1_)
    W2 = 2 * abs(ftp1_)
    span = W1 + W2
    fl4 = res[sm]["fl"]
    fedge4 = abs(res[sm]["fedge"])
    cstar = (fl4 + fedge4) / span      # required uniform per-piece S-diff
    cstar_pub = cstar * (d78.Smax(T4) + S0) / (d78.Smax(T4) + S0)  # = cstar
    EwS_req = (fl4 + fedge4)           # required E_win_S for exclusion
    print(f"  sigma={sm:>12.10f}  E_win_S(t4)={float(EwS):.2f}  "
          f"c1={float(c1):.4f}  span={float(span):.2f}  "
          f"fluc(t4)={fl4:+.3f}  |fedge(t4)|={fedge4:.4f}  "
          f"c*(t4)={float(cstar):.4f}  (E_win_S must be <= {EwS_req:.2f})",
          flush=True)
print("\nGate profile (sigma_A): c*(tPT2)=2.5821  c*(t3)=1.3445  "
      "c*(t4)=above (monotone decay expected = the gate tightens in t).")
print("No RH claim.")
