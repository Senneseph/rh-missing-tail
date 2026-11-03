#!/usr/bin/env python3
"""day070 - 0273a-r: the t=1e9 anchor ATTRIBUTION EXPERIMENT.

Context (entry 0273 / design doc section 5): the xi identity at t=1e9,
sigma = 0.1252270103 does not close:  S_stream + U_quad vs
log|zeta| - log(1/2) + Re log phi  agree only to ~4.7e8.

The closed-form asymptotic anchors (hand-verified in the 0273 forensics):
  U_true (g > 3.0013e9, t = 1e9) = c4*Int rho/g^2 + c6-correction ~ -1.14e9
  pinned to ~ +/- 3e7 (c4 = a^2 - 1/4 - t^2 + sr = -1e18 + 0.0157).
So the identity forces  S_true = (log|zeta| - log(1/2) + Re phi) - U_true
  ~ +3.5e8, while the float64 stream gives S_stream = -1.12e8: a ~4.6e8
  systematic S-side error, OR a U-side error of the same size.

This script attributes it:
  (1) S per-file subtotals (float64 chunks) over the EXACT known union
      (T10M txt, 11 lshard .dat via load_lshard, 4 .f64 raw files),
      with the T10M-lshard boundary-ownership dedup (file i owns
      [first_i, first_{i+1}));
  (2) S_crosscheck: the extra.f64 file (6.68M zeros, fast) summed THREE
      ways - float64 chunk, mpmath dps-30, and mpmath dps-30 with the
      per-term f recomputed from the complex log directly - they must
      agree to < 1e-3 if the reader and the f-form are both correct;
  (3) U: the c4-exact integral on (GLAST, gc], the (f - c4/g^2)
      correction quad on [GLAST, gc] (smooth: no dip above t for
      t=1e9 < GLAST), and the exact c4/g^2 tail (gc, inf);
  (4) Re log phi and log|zeta| at dps-30 AND dps-60 (stability);
  (5) the attribution: residual := log|zeta| - log(1/2) + Re phi
      - S_stream - U_asym, and per-file S share of it.
"""
import os, sys, time
import numpy as np
import mpmath as mpm
sys.path.insert(0, ".")

BASE = "/home/jsmille/Projects/rh-missing-tail/scripts/rh"
os.chdir(BASE)
import day069_xiproduct_excl_probe as D   # COVERAGE, load_lshard, fpair_chunk, STREAM_CHUNK

T = mpm.mpf("1e9")
SIG = mpm.mpf("0.1252270103")
A = 0.5 - float(SIG)
SR = float(SIG)
SI = float(T)
GLAST = None  # set below from extra file

def f_mp(g, dps_ctx=50):
    a = mpm.mpf("0.5") - SIG
    g2 = g * g + mpm.mpf("0.25")
    Aa = (a * a + (g - T) ** 2) / g2
    Bb = (a * a + (g + T) ** 2) / g2
    return mpm.mpf("0.5") * (mpm.log(Aa) + mpm.log(Bb)) + SIG / g2

def rho_mp(g):
    return mpm.log(g / (2 * mpm.pi)) / (2 * mpm.pi)

def main():
    t0 = time.time()
    print("0273a-r: t=1e9 anchor attribution experiment")
    extra = [n for (k, n) in D.COVERAGE if "extra" in n][0]
    nrec = os.path.getsize(extra) // 8
    garr = np.fromfile(extra, dtype="<f8")
    GL = float(garr[-1])
    print("GLAST = %.10f  (n = %d)" % (GL, nrec))
    print()

    # ---------- (1) S per-file subtotals, deduped by boundary ownership ----------
    firsts = []
    for (k, n) in D.COVERAGE:
        if k == "txt":
            firsts.append(float(np.loadtxt(n)[:1][0]))
        elif k == "f64r":
            firsts.append(float(np.fromfile(n, dtype="<f8", count=1)[0]))
        else:
            firsts.append(float(D.load_lshard(n)[0]))
    print("(1) S per-file subtotals (float64 chunks, dedup ownership):")
    S_tot = 0.0
    n_tot = 0
    S_part = {}
    for idx, (k, n) in enumerate(D.COVERAGE):
        lo = firsts[idx]
        hi = firsts[idx + 1] if idx + 1 < len(D.COVERAGE) else 3.002e9
        if k == "txt":
            arr = np.loadtxt(n); arr = arr[np.isfinite(arr)]
        elif k == "f64r":
            arr = np.fromfile(n, dtype="<f8"); arr = arr[np.isfinite(arr)]
        else:
            arr = D.load_lshard(n)
        arr = arr[(arr >= lo) & (arr < hi)]
        tot = np.float64(0.0)
        for i0 in range(0, arr.size, D.STREAM_CHUNK):
            c = arr[i0:i0 + D.Stream_CHUNK if False else D.STREAM_CHUNK]
            if c.size:
                tot += np.sum(D.fpair_chunk(c, SR, SI, A), dtype=np.float64)
        S_part[n] = float(tot)
        S_tot += float(tot)
        n_tot += int(arr.size)
        print("  %-42s n=%12d  S= %+.8e" % (n, arr.size, float(tot)))
    print("  %-42s n=%12d  S= %+.8e   (%.0fs)" % ("TOTAL", n_tot, S_tot, time.time() - t0))
    print()

    # ---------- (2) S_crosscheck on extra.f64 (3 ways) ----------
    lo = firsts[D.COVERAGE.index(("f64r", extra))]
    hi = 3.002e9
    c = garr[(garr >= lo) & (garr < hi)]
    s_float = float(np.sum(D.fpair_chunk(c, SR, SI, A), dtype=np.float64))
    mpm.mp.dps = 30
    s_mp = mpm.mpf("0")
    F = 0.0
    for g in c:
        s_mp += f_mp(mpm.mpf(repr(float(g))))
        F += 1
        if F % 2000000 == 0:
            print("    dps-30 sum: %d/%d (%.0fs)" % (F, c.size, time.time() - t0), flush=True)
    # (3rd way: direct complex log at dps-30 on every 4th zero + float on rest)
    s_direct = mpm.mpf("0")
    s = mpm.mpc(SR, SI)
    K = 0
    for g in c[::4]:
        r = mpm.mpf("0.5") + mpm.mpc(0, float(g))
        rbar = mpm.mpf("0.5") - mpm.mpc(0, float(g))
        s_direct += mpm.re(mpm.log(1 - s / r) + s / r + mpm.log(1 - s / rbar) + s / rbar) * 4
    print("(2) S_crosscheck extra.f64 (n=%d):" % c.size)
    print("    float64 chunk          = %+.10e" % s_float)
    print("    dps-30 f_mp sum        = %+.10e" % float(s_mp))
    print("    dps-30 complex-log x4  = %+.10e" % float(s_direct))
    print("    (pairwise max diff = %.3e: must be < 1)" % max(abs(s_float - float(s_mp)), abs(s_float - float(s_direct))))
    print()

    # ---------- (3) U via c4-exact + correction quad ----------
    mpm.mp.dps = 50
    a = mpm.mpf("0.5") - SIG
    c4 = a * a - mpm.mpf("0.25") - T * T + SIG
    gL = mpm.mpf(repr(GL))
    gc = mpm.mpf(160) * T
    def int_c4(ga, gb):
        # exact Int_ga^gb rho/g^2 dg
        F2 = lambda g: (mpm.log(g / (2 * mpm.pi)) + 1) / g
        return (F2(ga) - F2(gb)) / (2 * mpm.pi)
    U_c4 = c4 * int_c4(gL, gc)
    corr_pts = [gL * (gc / gL) ** (mpm.mpf(j) / 4000) for j in range(4001)]
    U_corr = mpm.quad(lambda g: (f_mp(g) - c4 / (g * g)) * rho_mp(g), corr_pts)
    U_tail = c4 * int_c4(gc, mpm.inf)
    U_asym = U_c4 + U_corr + U_tail
    # and the plain quad of the full f*rho for comparison
    U_quad = mpm.quad(lambda g: f_mp(g) * rho_mp(g), corr_pts) + U_tail
    print("(3) U (t=1e9, g > GLAST):  c4 = %.12e" % float(c4))
    print("    U_c4 exact (GL..160t) = %+.10e" % float(U_c4))
    print("    U_corr (f-c4/g^2)     = %+.10e" % float(U_corr))
    print("    U_tail exact (160t..) = %+.10e" % float(U_tail))
    print("    U_asym total          = %+.10e   (the pinned U_true ~ -1.14e9)" % float(U_asym))
    print("    U_quad (full f, ref)  = %+.10e" % float(U_quad))
    print()

    # ---------- (4) phi and zeta at two dps ----------
    def phire(dps):
        mpm.mp.dps = dps
        s2 = mpm.mpc(SR, SI)
        return float(mpm.re(mpm.log(mpm.mpf("0.5") * s2 * (s2 - 1)
                                  * mpm.pi ** (-s2 / 2) * mpm.gamma(s2 / 2))))
    def logz(dps):
        mpm.mp.dps = dps
        s2 = mpm.mpc(SR, SI)
        return float(mpm.log(mpm.fabs(mpm.zeta(s2))))
    phi30, phi60 = phire(30), phire(60)
    lz30, lz60 = logz(30), logz(60)
    print("(4) Re log phi: dps-30 = %.12f   dps-60 = %.12f   (diff %.2e)" % (phi30, phi60, abs(phi30 - phi60)))
    print("    log|zeta| : dps-30 = %.12f   dps-60 = %.12f   (diff %.2e)" % (lz30, lz60, abs(lz30 - lz60)))
    print()

    # ---------- (5) attribution ----------
    RHS = lz60 - float(mpm.mpf("0.5").log()) * -1 + phi60
    print("(5) required S + U = log|zeta| - log(1/2) + Re phi = %+.10e" % (lz60 + 0.6931471805599453 + phi60))
    print("    U_asym                              = %+.10e  ->  S_required = %+.10e"
          % (float(U_asym), lz60 + 0.6931471805599453 + phi60 - float(U_asym)))
    print("    S_stream (this run)                 = %+.10e" % S_tot)
    print("    residual (stream - required)        = %+.10e"
          % (S_tot - (lz60 + 0.6931471805599453 + phi60 - float(U_asym))))
    print()
    print("    per-file S share of stream total (share = S_file / |S_tot|):")
    for (n, v) in S_part.items():
        print("      %-42s %+.8e  (%6.2f%%)" % (n, v, 100.0 * v / abs(S_tot)))
    print("    total runtime %.0fs" % (time.time() - t0))

if __name__ == "__main__":
    main()
