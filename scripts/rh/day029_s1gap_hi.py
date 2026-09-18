#!/usr/bin/env python3
"""day029 -- S1 corrected statistic ABOVE 1e9 (the Efull-shape question).

Uses the extended LMFDB band: cache_lo (1e7, 3.1946e7] + old hi1e9 band
(3.1946e7, 1.0063e9] + new hi3e10 band (1.0021e9, 2.0017e9] (deduped at
the overlap), G_LAST_new = 2.0017e9.  Same statistic as the sweep
(t^4 wire + full-horizon kernel (G_LAST, 1e30]), npts = 400 / npts2 =
400, the rescheck-verified configuration).

TWO KINDS OF POINTS:
  (a) STRADDLE windows 1.2e9 ... 1.95e9: full margin (new data: real
      zeros g ~ t, dps-30 kernel) — extends the A-1 verification.
  (b) MODEL points 2.5e9 ... 3e10: Efull(t) only (the kernel models
      the zero region (G_LAST, t) by the density quad; the squeeze
      margin is NOT evaluable there — no real zeros g ~ t).
"""
import mpmath as mpm

mpm.mp.dps = 30
import os
import math
import numpy as np
import concurrent.futures as cf

import day023_p11c_1e7 as M
import day023_taildiscrete as td

REM_HI2 = mpm.mpf("1e30")
NPTS = 400
NPTS2 = 400
OLD_BAND = ("/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/"
            "zeros_hi31946e6_to_1e9.f64")
NEW_BAND = ("/home/jsmille/Projects/rh-missing-tail/scripts/rh/hi1e9/"
            "zeros_1002e6_to_2000e6.f64")
HI_DISC = 31946000.0

DG = [mpm.mpf(k)/1000 for k in range(5, 501)]


def n4(t):
    return int(math.ceil(31000000.0 * t**4))


class TailHi2:
    def __init__(self):
        # NO big private arrays (a mask-copy is 24.4 GB and COW-bombs
        # under fork): two memmaps (file-backed, shared page cache) +
        # the small cache_lo + a dedup cut index into the new band.
        self.cache_lo = td.load_g_range(1.0e7, HI_DISC)
        self.old = np.memmap(OLD_BAND, dtype="<f8", mode="r")
        self.new = np.memmap(NEW_BAND, dtype="<f8", mode="r")
        self.new0 = int(np.searchsorted(self.new, float(self.old[-1]),
                                        side="right"))
        self.G_LAST = float(self.new[-1])

    def iter_arrays(self):
        yield self.cache_lo
        yield self.old
        yield self.new[self.new0:]   # memmap slice = view, no copy

    def pairlog_sum(self, t):
        t2 = t * t
        re = np.longdouble(0)
        im = np.longdouble(0)
        CH = 2_00_000_000
        for arr in self.iter_arrays():
            for i in range(0, arr.size, CH):
                c = arr[i:i+CH]
                g2 = c * c
                A = g2 + 0.25
                re += np.sum(np.log(np.abs(g2 - t2)) - np.log(A)
                             + 0.5 / A)
                im += np.sum(t / A)
        n = int(np.searchsorted(self.cache_lo, t, side="left"))
        n += int(np.searchsorted(self.old, t, side="left"))
        n += int(np.searchsorted(self.new[self.new0:], t, side="left"))
        return float(re), float(im) + n*np.pi

    def real_zero_at(self, x):
        for arr in self.iter_arrays():
            i = int(np.searchsorted(arr, x))
            cands = [float(arr[j])
                     for j in range(max(0, i-2), min(arr.size, i+3))]
            gz = min(cands, key=lambda v: abs(v-x))
            if abs(gz - x) < 5e3:
                return gz
        return None


def quad_rem(T, t, npts):
    smp = mpm.mpc(0.5, mpm.mpf(repr(float(t))))
    hi0 = mpm.mpf(repr(float(T.G_LAST)))
    hi1 = mpm.mpf("1e18")

    def f(gg):
        r1 = mpm.mpc(0.5, gg)
        r2 = mpm.mpc(0.5, -gg)
        p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))

    k = mpm.mpf(npts)
    pts = [hi0 * (hi1/hi0)**(mpm.mpf(j)/k) for j in range(npts+1)]
    return mpm.quad(f, pts)


def quad_ext(t, npts):
    hi0 = mpm.mpf("1e18")
    smp = mpm.mpc(0.5, mpm.mpf(repr(float(t))))

    def f(gg):
        r1 = mpm.mpc(0.5, gg)
        r2 = mpm.mpc(0.5, -gg)
        p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))

    k = mpm.mpf(npts)
    pts = [hi0 * (REM_HI2/hi0)**(mpm.mpf(j)/k) for j in range(npts+1)]
    return mpm.quad(f, pts)


def kernel(T, t):
    s = mpm.mpc(0.5, t)
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    re, im = T.pairlog_sum(float(t))
    rem = quad_rem(T, t, NPTS)
    tail = (mpm.mpf(repr(re)) + 1j*mpm.mpf(repr(im)) + rem
            + quad_ext(t, NPTS2))
    return main + mpm.mpf(repr(float(la))) \
        + 1j*mpm.mpf(repr(float(ar))) + tail


_T = None


def get_T():
    """Worker-lazy tail (the sweep's pattern). Passing T as a task
    ARGUMENT pickles all ~47 GB of band arrays per submit (the fork
    start-method still pickles args) -- 5 submits x 47 GB = the OOM.
    In-worker creation keeps the bands in the shared file-backed page
    cache."""
    global _T
    if _T is None:
        _T = TailHi2()
    return _T


def margin_at(T, t, g):
    s = mpm.mpc(0.5, t)
    gmp = mpm.mpf(repr(float(g)))
    tmm = mpm.mpf(repr(float(t)))
    dev = None
    for d in DG:
        v = abs(M.R_closed(gmp, tmm, d) - 1)
        dev = v if dev is None else min(dev, v)
    z = mpm.zeta(s)
    logK = kernel(T, t)
    Kf = mpm.e**logK
    zabs = abs(z)
    residf = abs(z - Kf)
    B = M.B_best(tmm)
    return {"mold": float(zabs*dev/(B + residf)),
            "mnew": float(zabs*dev/(M.p8_B(tmm, n4(tmm)) + residf)),
            "residf": float(residf),
            "Efull": float(mpm.log(zabs) - mpm.re(logK)),
            "t": float(t), "zeta": float(zabs), "dev": float(dev)}


def scan_one(x, label):
    T = get_T()
    gz = T.real_zero_at(x)
    if gz is None:
        return None
    g = gz
    best = None
    for k in range(-12, 13):
        if k == 0:
            continue
        t = mpm.mpf(repr(float(g))) + mpm.mpf(k)/2
        r = margin_at(T, t, g)
        if best is None or r["mnew"] > best["mnew"]:
            best = r
    return {"g": float(g), "label": label, **best}


def model_E(t):
    """Efull(t) at a model-level t (> G_LAST): kernel = discrete to
    G_LAST + density quads; the margin is NOT evaluable (no real
    zeros g ~ t)."""
    T = get_T()
    s = mpm.mpc(0.5, t)
    z = mpm.zeta(s)
    logK = kernel(T, t)
    return {"label": "%g" % float(t),
            "Efull": float(mpm.log(abs(z)) - mpm.re(logK)),
            "zeta": float(abs(z)), "t": float(t)}


def _main():
    T = TailHi2()
    print("G_LAST_new = %.6f  (new-band zeros %d)"
          % (T.G_LAST, T.new.size - T.new0), flush=True)

    STRADDLE = [(1.2e9, "1.2e9"), (1.4e9, "1.4e9"), (1.6e9, "1.6e9"),
                (1.8e9, "1.8e9"), (1.95e9, "1.95e9")]
    MODEL = [mpm.mpf("2.5e9"), mpm.mpf("4e9"), mpm.mpf("6e9"),
             mpm.mpf("1e10"), mpm.mpf("2e10"), mpm.mpf("3e10")]

    straddle_rows = []
    with cf.ProcessPoolExecutor(max_workers=int(os.environ.get("WORKERS", "6"))) \
            as ex:
        futs = {ex.submit(scan_one, x, lab): lab
                for (x, lab) in STRADDLE}
        for f in cf.as_completed(futs):
            r = f.result()
            if r:
                straddle_rows.append(r)
                print("sweep %s" % r["label"], r, flush=True)

    print("g   t_best  margin_old margin_new residf    Efull   zeta  dev")
    for r in sorted(straddle_rows, key=lambda r: r["label"]):
        print("%8.3g %16.4f  %10.4f %11.4f  %8.4f  %+.4f  %6.3f %7.4f %s"
              % (r["g"], r["t"], r["mold"], r["mnew"], r["residf"],
                 r["Efull"], r["zeta"], r["dev"], r["label"]))

    print("\nMODEL-LEVEL Efull (t > G_LAST; the zero region (G_LAST, t) is")
    print("density-modeled; margin not evaluable there):")
    for tm in MODEL:
        r = model_E(tm)
        print("  t = %9.3g : Efull = %+.4f   |zeta| = %.4f"
              % (r["t"], r["Efull"], r["zeta"]), flush=True)


if __name__ == "__main__":
    _main()
