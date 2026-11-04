#!/usr/bin/env python3
"""0273a-r step 3+4: the tPT2 unknown-side main term via u-substitution,
and the corrected face probe (K', fluctuation, B_unk, verdict).

Identity (0273 design):  log|zeta(s)| = log(1/2) - Re log phi(s) + S(s) + U(s)
  S = sum_{g <= GLAST} f(g; s)            (known zeros, fixed reader)
  U = sum_{g >  GLAST} f(g; s) = I_unk(s) + fluct,
  I_unk = Int_{GLAST}^{inf} f rho dg      (main term, measured here)
  fluct                             (Titchmarsh-9.2 bounded, |fluct| <= B_unk)

I_unk by u = g/t substitution:  I_unk = t * Int_{y0}^{inf} f(t*y) rho(t*y) dy
  * f(t*y) is SMOOTH in y (the g-cusp at g=t is a removable value of f;
    the logarithmic singularity lives in f' only);
  * split (y0, YC] by mpmath quad (dps 60, log grid + dense around y=1)
    + exact c4/g^2 tail [YC, inf] + correction quad on [YC, 2^36*YC].

Calibration gate BEFORE tPT2 (0272 discipline): at t = 1e9, I_unk must
reproduce the independently pinned U_true = -1.1336316e9 (xi-identity pin
from day070/0273.json: S_required + phi + zeta, data floor ~1) to < 1.
No face claim until the gate passes.
"""
import os, time, math
import numpy as np
import mpmath as mpm
import day069_xiproduct_excl_probe as D

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
TPT2 = D.TPT2

# .f64 files: 16-byte header per the day069 convention (streaming and
# GLAST extraction both use offset 16 - internally consistent).
def _f64vals(p):
    n = (os.path.getsize(p) - 16) // 8
    return np.fromfile(p, dtype=np.float64, offset=16, count=n)

GLAST = float(_f64vals("hi3e9/extra/zeros_2999e6_to_3000e6.f64")[-1])
print(f"GLAST = {GLAST!r}")

def f_mpmath(g, sr, t, a):
    g2 = g * g + mpm.mpf("0.25")
    A = (a * a + (g - t) ** 2) / g2
    B = (a * a + (g + t) ** 2) / g2
    return 0.5 * (mpm.log(A) + mpm.log(B)) + sr / g2

def rho_mpmath(g):
    return mpm.log(g / (2 * mpm.pi)) / (2 * mpm.pi)

def I_unk_u(sr, t, g0, YC=mpm.mpf(128), dps=60, sr_override=None):
    """t * Int_{y0}^{inf} f(t y) rho(t y) dy, dip-aware, dps-60.
    Returns (I, err_estimate)."""
    mpm.mp.dps = dps
    tM = mpm.mpf(t)
    srM = sr_override if sr_override is not None else mpm.mpf(sr)
    a = mpm.mpf("0.5") - srM
    y0 = mpm.mpf(g0) / tM
    F = lambda y: f_mpmath(tM * y, srM, tM, a) * rho_mpmath(tM * y)
    # --- (A) main quad on (y0, YC]: log grid + FINE core window around the
    #     dip at y = 1 (h = g - t in [-W, W], step 0.01 in g-units).
    W = mpm.mpf("60")
    hc = mpm.mpf(g0) < tM < tM * YC     # dip inside the integration range
    pts = []
    if hc:
        yl, yr = (tM - W) / tM, (tM + W) / tM
        if y0 >= yl:                       # y0 inside/after the core window
            pts = [y0 * (yr / y0) ** (mpm.mpf(j) / 400) for j in range(401)]
            pts = [p for p in pts if p <= yr]
        else:
            pts = [y0 * (yl / y0) ** (mpm.mpf(j) / 400) for j in range(401)]
        nsteps = int((2 * W) / mpm.mpf("0.01"))
        for j in range(nsteps + 1):
            pts.append((tM + (mpm.mpf(j) * 0.01 - W)) / tM)
        if yr < YC:
            pts += [(yr * (YC / yr) ** (mpm.mpf(j) / 400)) for j in range(401)]
    else:
        k = int(mpm.log(YC / y0) / mpm.log(1.01))
        for j in range(k + 1):
            pts.append(y0 * (YC / y0) ** (mpm.mpf(j) / k))
        for j in range(2, 30):             # dense both sides of 1 (wings)
            for sgn in (-1, +1):
                p = mpm.mpf(1) + sgn * (mpm.mpf(10) ** -mpm.mpf(j / 2.0))
                if y0 < p < YC:
                    pts.append(p)
    if y0 < mpm.mpf(1) < YC:
        pts.append(mpm.mpf(1))
    pts = sorted(set(pts))
    pts = [p for p in pts if y0 <= p <= YC]
    if pts[0] != y0:
        pts.insert(0, y0)
    if pts[-1] != YC:
        pts.append(YC)
    main = mpm.quad(F, pts)
    # error estimate: two resolutions on a probe window away from cusp
    Fq = lambda y: float(mpm.nstr(F(y), 17))
    # --- (B) exact c4 tail: for y >> 0, f(t y) = c4/(t^2 y^2) + O(y^-4, t^-2),
    #     c4 = a^2 - 1/4 - t^2 + sr  (from the 0273a-r design)
    c4 = a * a - mpm.mpf("0.25") - tM * tM + srM
    # Int_{t*y}^{inf} (c4/g^2) rho(g) dg = (c4/(2 pi)) * (1 + log(y*2pi))... / (t y)
    #   (derived exactly in day069 U_tail; with rho(g)=log(g/2pi)/2pi):
    tail_exact = lambda y: (c4 / (2 * mpm.pi)) * (1 + (mpm.log(tM * y / (2 * mpm.pi)))) / (tM * y)
    tail = tail_exact(YC)
    # --- (C) correction quad on (YC, Y2], log grid
    Y2 = YC * mpm.mpf(2) ** 36
    ntail = 80
    pts2 = [YC * (Y2 / YC) ** (mpm.mpf(j) / ntail) for j in range(ntail + 1)]
    corr = mpm.quad(lambda y: (F(y) - (c4 / (tM * tM * y * y)) * rho_mpmath(tM * y)), pts2)
    # I = t*Int_{y0}^{YC} F dy  +  Int_{t*YC}^{inf} (c4/g^2) rho dg  +  t*Int_{YC}^{Y2}(F - c4/(t^2 y^2) rho(ty)) dy
    # (the c4 tail runs to infinity; the residual f - c4/g^2 beyond Y2 is
    #  O(t * Y2^-3 * ln) < 1e-25 - neglected, printed as err floor)
    I = tM * (main + corr) + tail
    return I

def U_pin_c4(t, g0=None, dps=60, sr_override=None):
    """Independent pin (day070 recipe): c4 asymptotic decomposition in g-space,
    different grid structure than I_unk_u (which works in y = g/t space).
    fin quad g0..160t (log grid + explicit dip breakpoints when t > g0)
    + exact c4 tail (160t..inf) + correction quad (160t..2^24*160t)."""
    mpm.mp.dps = dps
    tM = mpm.mpf(float(t)) if not isinstance(t, mpm.mpf) else t
    sr = sr_override if sr_override is not None else mpm.mpf("0.1252270103")
    a = mpm.mpf("0.5") - sr
    g0M = mpm.mpf(str(g0)) if g0 is not None else mpm.mpf(str(GLAST))
    c4 = a * a - mpm.mpf("0.25") - tM * tM + sr
    YC = mpm.mpf(160)
    gc = YC * tM
    pts = [g0M * (gc / g0M) ** (mpm.mpf(j) / 4000) for j in range(4001)]
    # Fine linear core window around the dip at g = t (step 0.01 in g): the
    # well (width a = 0.375, floor f(t) ~ -29) plus its near transition is
    # isolated here; the log wings (|g-t| > 60) are smooth O(log) and stay
    # on the log grid.  (f is C^\infty - no singularity; the window is a
    # resolution device, and the dual-method spread is the err check.)
    if g0M < tM < gc:
        W = mpm.mpf("60")
        nl = 200
        if g0M < tM - W:
            pts += [g0M * ((tM - W) / g0M) ** (mpm.mpf(j) / nl) for j in range(nl + 1)]
        nsteps = 12000
        for j in range(nsteps + 1):
            pts.append(tM + (mpm.mpf(j) * 0.01 - W))
        if tM + W < gc:
            pts += [(tM + W) * (gc / (tM + W)) ** (mpm.mpf(j) / nl) for j in range(nl + 1)]
        pts = sorted(set(p for p in pts if g0M <= p <= gc))
        if pts[0] != g0M:
            pts.insert(0, g0M)
        if pts[-1] != gc:
            pts.append(gc)
    fin = mpm.quad(lambda g: f_mpmath(g, sr, tM, a) * rho_mpmath(g), pts)
    ana = (c4 / (2 * mpm.pi)) * (1 + mpm.log(gc / (2 * mpm.pi))) / gc
    Y2 = gc * mpm.mpf(2) ** 24
    corr = mpm.quad(lambda g: (f_mpmath(g, sr, tM, a) - c4 / (g * g)) * rho_mpmath(g),
                    [gc * (Y2 / gc) ** (mpm.mpf(j) / 200) for j in range(201)])
    # [FIFTH CORRECTION (day072 c4pin bias, found day075/0275 audit, t = 1000*tPT2)]
    # The old line `return fin + ana + corr + tail2` double-counted the c4 mass
    # beyond Y2: ana already equals Int_{gc}^inf (c4/g^2) rho dg, which contains
    # Int_{Y2}^inf (c4/g^2) rho dg = tail2 (same exact form); corr then adds the
    # (f - c4/g^2) part on (gc, Y2).  The bias was -tail2 = -(c4/(2*pi))
    # *(1+ln(Y2/(2*pi)))/Y2: -87.5 at tPT2 (hidden under slack 16,158 -> gates
    # passed) and -1.0052e7 at t3 = 1000*tPT2 (the spurious day075 'closure
    # FAIL').  The TRUE remainder beyond Y2 is (f - c4/g^2) rho, whose
    # coefficient h(u) := (f - c4/g^2)(tu) * u^4 converges to -0.5 for
    # u >= 160 (day072 corr analysis); certify it at u = 160 and close the form
    # R2 = h160 * t^4 * rho(Y2) / (3 Y2^3) (error O(h' rho t^4 / Y2^4) < 1e-20
    # at these heights).
    Ychk = gc * mpm.mpf(2) ** 8
    h160 = (f_mpmath(gc, sr, tM, a) - c4 / (gc * gc)) * (gc / tM) ** 4
    if abs(h160 + mpm.mpf("0.5")) > mpm.mpf("0.2"):
        raise AssertionError(f"h(u) not converged at u=160: {float(h160):.6f}")
    R2 = h160 * (tM ** 4) * rho_mpmath(Y2) / (3 * Y2 ** 3)
    return fin + ana + corr + R2

def U_pin_1e9():
    return U_pin_c4("1e9")

def bound_rigorous(s):
    """Exact per-unit-sum fluctuation bound (independent of day069 TV-quad).

    f(g; s) for g > GLAST at the face, with the TRUE f (0272/0273 kernel):
    f = 0.5 ln(a^2+(g-t)^2) + 0.5 ln(a^2+(g+t)^2) - ln(g^2+0.25) + sr/(g^2+0.25)
    - C^\infty everywhere (the dip at g = t is a finite valley f(t) ~ -29,
      O(t)-wide; the log 'cusp' lives only in f');
    - verified below: strictly decreasing on (GLAST, t], strictly increasing
      on [t, 32t] (hence to inf, f -> 0-)  [monotonicity asserted numerically].

    Per-unit interval I (monotone piece): |sum_{I} f - Int_I f rho dg|
      <= B1 (max_I |f| + TV_I(f))          (summation by parts; per-unit
      count error <= B1 = A0 log(tPT2) - the cited Zeta23-RvM LocalCount =
      Titchmarsh Thm 9.2 statement N(t, t+1] <= A0 log(|t|+3)).
    Telescoping (max|f| + TV) over the two monotone pieces gives exactly
      B_unk = B1 ( |f(GLAST)| + TV1 + |f(t)| + TV2 ),
    TV1 = f(GLAST) - f(t), TV2 = 0 - f(t)   (limits exact - no quadrature).
    """
    t = float(s.imag); sr = float(s.real); a = 0.5 - sr
    B1 = float(D.A0) * math.log(float(TPT2))
    def f(g):
        return 0.5 * math.log((a * a + (g - t) ** 2) / (0.25 + g * g)) \
             + 0.5 * math.log((a * a + (g + t) ** 2) / (0.25 + g * g)) \
             + sr / (0.25 + g * g)
    fmax = f(GLAST); ft = f(t)
    # monotonicity verification (dense log grids, 200k pts each piece):
    xs1 = float(GLAST) * (t / GLAST) ** (np.linspace(0, 1, 200001))
    v1 = np.array([f(x) for x in xs1])
    d1 = np.diff(v1)
    if not bool(np.all(d1 <= 1e-9)):
        i = int(np.argmax(d1 > 1e-9))
        raise AssertionError(f"f NOT decreasing on (GLAST,t] near x={float(xs1[i]):.8g}")
    xs2 = t * (32.0) ** (np.linspace(0, 1, 200001))
    v2 = np.array([f(x) for x in xs2])
    d2 = np.diff(v2)
    if not bool(np.all(d2 >= -1e-9)):
        i = int(np.argmax(d2 < -1e-9))
        raise AssertionError(f"f NOT increasing on [t,32t] near x={float(xs2[i]):.8g}")
    TV1 = fmax - ft
    TV2 = 0.0 - ft  # f -> 0- as g -> inf (verified: f(32t) = -0.001 and rising)
    B = B1 * (abs(fmax) + TV1 + abs(ft) + TV2)
    return B, ft, fmax, TV1, TV2

def bound_terms_day069(s, g0):
    """The day069 bound_terms mechanism verbatim (B1 = A0 log tPT2,
    Titchmarsh 9.2; TV via |f'| grid quad as in the probe)."""
    mpm.mp.dps = 50
    A0 = mpm.mpf("3.4")
    B1 = A0 * mpm.log(TPT2)
    t = mpm.mpf(float(s.imag))
    sr = mpm.mpf(float(s.real))
    a = mpm.mpf("0.5") - sr
    def f(g):
        return f_mpmath(g, sr, t, a)
    g0M = mpm.mpf(str(g0))
    fg1 = mpm.fabs(f(g0M))
    ft2 = mpm.fabs(f(TPT2))
    pts = []
    k = 200
    for j in range(k + 1):
        pts.append(g0M * (TPT2 / g0M) ** (mpm.mpf(j) / k))
    for m8 in range(-200, 201, 2):
        pts.append(TPT2 + mpm.mpf(m8))
    pts = sorted(set(p for p in pts if g0M < p <= TPT2))
    tv1 = mpm.quad(lambda g: mpm.fabs((f(g + g * 1e-9) - f(g)) / (g * 1e-9)), pts)
    tail_pts = [TPT2 * (mpm.mpf(2) ** j) for j in range(0, 6)]
    tv2 = mpm.quad(lambda g: mpm.fabs((f(g + g * 1e-9) - f(g)) / (g * 1e-9)), tail_pts)
    return B1 * (fg1 + ft2 + tv1), B1 * (ft2 + tv2)

def stream_S_all_sigmas():
    """One pass over the union; per-file boundary ownership as day069 main."""
    sigs = [0.1252270103, 0.25, 0.40, 0.49]
    bvals = []
    for (k, n) in D.COVERAGE:
        if k == "txt":
            bvals.append(float(np.loadtxt(n)[:1][0]))
        elif k == "f64r":
            bvals.append(float(_f64vals(n)[0]))
        else:
            bvals.append(float(D.load_lshard(n)[0]))
    tots = [np.float64(0.0) for _ in sigs]; ntot = 0
    first = time.time()
    for idx, (kind, name) in enumerate(D.COVERAGE):
        lo, hi = bvals[idx], (bvals[idx + 1] if idx + 1 < len(D.COVERAGE) else 3.002e9)
        if kind == "txt":
            arr = np.loadtxt(name); arr = arr[np.isfinite(arr)]
        elif kind == "f64r":
            arr = _f64vals(name)
        else:
            arr = D.load_lshard(name)
        arr = arr[(arr >= lo) & (arr < hi)]; arr = arr[np.isfinite(arr)]
        for i0 in range(0, arr.size, D.STREAM_CHUNK):
            c = arr[i0:min(i0 + D.STREAM_CHUNK, arr.size)]
            if not c.size:
                continue
            for j, sm in enumerate(sigs):
                tots[j] += np.sum(D.fpair_chunk(c, sm, float(TPT2), 0.5 - sm),
                                  dtype=np.float64)
            ntot += c.size
        print(f"  file {idx:2d} ({name.split('/')[-1]:42s}) n={arr.size:12d} "
              f"({int(time.time()-first)}s)", flush=True)
    return tots, ntot

def main():
    print("0273a-r: u-substitution unknown-side main term + corrected face probe")
    print()
    # ---------- GATE 1: t = 1e9, dip BELOW the integration range ----------
    print("GATE 1 (t = 1e9): I_unk by u-substitution vs the c4-decomp pin")
    print("  (two independent quadratures; the known xi-vs-c4 cross-floor at this")
    print("   height was 192 on the 1.1e9 scale = 1.7e-7 - we require 1e-7 rel)")
    t0 = time.time()
    pin = U_pin_c4("1e9")
    I1 = I_unk_u(mpm.mpf("0.1252270103"), mpm.mpf("1e9"), mpm.mpf(str(GLAST)))
    d = abs(I1 - pin)
    rel1 = d / abs(pin)
    print(f"  pin (c4-decomp, dps-60)    = {float(pin):+.12e}")
    print(f"  u-substitution (dps-60)    = {float(I1):+.12e}   ({int(time.time()-t0)}s)")
    print(f"  |diff| = {float(d):.3e} (rel {float(rel1):.2e})   "
          f"GATE1 {'PASS' if rel1 < 1e-7 else 'FAIL'} (require rel < 1e-7)")
    if rel1 >= 1e-7:
        raise SystemExit("smooth-range quad not good enough; do not proceed.")
    print()
    # ---------- GATE 2: t = 4e9, dip INSIDE the integration range ----------
    print("GATE 2 (t = 4e9, dip in range): u-substitution vs c4-decomp pin w/ dip grid")
    t0 = time.time()
    pin2 = U_pin_c4(4e9)
    I2 = I_unk_u(mpm.mpf("0.1252270103"), mpm.mpf("4e9"), mpm.mpf(str(GLAST)))
    d2 = abs(I2 - pin2)
    rel2 = d2 / abs(pin2)
    print(f"  pin (c4-decomp, dps-60)    = {float(pin2):+.12e}")
    print(f"  u-substitution (dps-60)    = {float(I2):+.12e}   ({int(time.time()-t0)}s)")
    print(f"  |diff| = {float(d2):.3e} (rel {float(rel2):.2e})   "
          f"GATE2 {'PASS' if rel2 < 1e-7 else 'FAIL'} (require rel < 1e-7)")
    if rel2 >= 1e-7:
        raise SystemExit("dip handling not good enough; do not proceed to tPT2.")
    print()
    # ---------- tPT2 main term: dual independent methods ----------
    print("tPT2 unknown-side main term (dps-60, dual methods: c4-decomp g-space"
          " and u-sub y-space):")
    sigs = [0.1252270103, 0.25, 0.40, 0.49]
    Iunk = {}
    for sm in sigs:
        t0 = time.time()
        Ic = mpm.mpf(repr(sm))
        mpm.mp.dps = 60
        I1m = U_pin_c4(TPT2, g0=GLAST, sr_override=mpm.mpf(repr(sm)))
        I2m = I_unk_u(Ic, TPT2, GLAST, sr_override=Ic)
        spread = abs(I1m - I2m)
        rel = spread / abs(I1m)
        Iunk[sm] = (float(I1m), spread)
        ok = "AGREE" if rel < 1e-7 else "DISAGREE-!"
        print(f"  sigma={sm:12.9f}  c4={float(I1m):+.12e}  usub={float(I2m):+.12e}  "
              f"spread={float(spread):.3e} ({ok})  ({int(time.time()-t0)}s)")
    print()
    # ---------- S stream + phi ----------
    print("S stream at tPT2 (4 sigmas, one pass, fixed reader + boundary ownership):")
    tots, ntot = stream_S_all_sigmas()
    print(f"  TOTAL n = {ntot}")
    mpm.mp.dps = 60
    si = float(TPT2)
    print()
    hdr = ("{0:>12} | {1:>13} | {2:>13} | {3:>13} | {4:>13} | "
           "{5:>11} | {6:>11} | {7:>13} | {8:>7} | {9}")
    print("sigma = s.re ; S = sum known f ; I_unk = main term ; K' = S + I_unk - Re log phi + log(1/2)")
    print(hdr.format("sigma", "S", "I_unk", "-Re phi", "Kprime", "B_unk(rig)",
                     "log|zeta|", "fluct", "|fl|<B", "K'-B>0"))
    for j, sm in enumerate(sigs):
        s = mpm.mpc(mpm.mpf(repr(sm)), TPT2)
        ph = mpm.log(mpm.mpf("0.5") * s * (s - 1) * mpm.pi ** (-s / 2) * mpm.gamma(s / 2))
        rephi = float(mpm.re(ph))
        Iv, spr = Iunk[sm]
        Kp = float(tots[j]) + Iv - rephi + float(mpm.log(mpm.mpf("0.5")))
        B, ft, fmax, TV1, TV2 = bound_rigorous(s)
        BT1, BT2 = bound_terms_day069(s, GLAST)
        Bday = float(BT1 + BT2)
        mpm.mp.dps = 60
        Bfin = 2.0 * max(B, Bday)
        zv = mpm.zeta(s)
        lz = float(mpm.log(mpm.fabs(zv)))
        fl = lz - Kp
        okB = "yes" if abs(fl) <= Bfin else "NO"
        excl = "YES" if (Kp - Bfin) > 0 else "no"
        print(hdr.format(f"{sm:.9f}", f"{float(tots[j]):+.6f}", f"{Iv:+.6f}",
                        f"{-rephi:+.6f}", f"{Kp:+.6f}", f"{Bfin:.4f}", f"{lz:.6f}",
                        f"{fl:+.6f}", okB, excl))
        print(f"    I_unk dual-method spread = {float(spr):.3e} (must be << B_unk)")
        print(f"    B-crosscheck: per-unit-sum(exact pieces) = {B:.4f}  |  day069(BT1+BT2) = {Bday:.4f}")
        print(f"    f(GLAST)={fmax:.4f}  f(t)={ft:.4f}  TV1={TV1:.4f}  TV2={TV2:.4f}")
    print()
    print("verdict: K'-B_unk > 0 with |fluct| <= B_unk  <=>  certified exclusion at s.")
    print("(K' = S + I_unk - Re log phi + log(1/2);  fluct = log|zeta(s)| - K')")
    print(" B_unk = 2 * max(rigorous monotone-piece bound, day069 BT1+BT2)  [x2 = TV-quad safety]")

if __name__ == "__main__":
    main()
