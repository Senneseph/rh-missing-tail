#!/usr/bin/env python3
"""day049b -- the FOURTH independent pipeline for the p01 margin
(V4), a fresh recompute deliberately different from every prior one:

  V1  engine f64      : day037 CPU numpy-pairwise, 2^25 slabs,
                        longdouble across slabs         0.5026585
  V2  80-bit-exact f64: day048 longdouble chunks (1024),
                        80-bit tree                     0.5026581
  ledger (GPU fleet)  : day038 cupy iGPU, 2^25 slabs    0.9999999965

  V4 (this file):
    - NEAR region D[na, nb)  (zeros in (t(1-a), t(1+a)),  a = 3.6e-4,
      ~5e6 zeros:  the kernel-sensitive zone where log|g^2 - t^2| is
      singular): DIRECT dps-60 mpmath sum, each zero read from the
      band file as an exact f64 -> exact mpf, terms at dps-60,
      sequential mpmath accumulation (exact to ~1e-50).
    - FAR region (~1.01e11 zeros):  per-term evaluation in
      vectorized f64 (the engine-identical term formula) in
      2^26-element windows;  per-1e5-subchunk sums accumulated
      in 80-bit float128;  window sums transferred EXACTLY
      (struct-unpacked 80-bit) and accumulated at dps-60.
      This keeps the far region's per-term precision at the
      engine's own f64 level (whose summation error we do NOT
      inherit:  our accumulation differs from the engine's,
      per the sample cross-check below),  and is ~30x faster
      than per-term f128 (which stalled at ~4.7 h/worker).
      Sample cross-check:  each worker re-computes one
      1e6-element slice PER-TERM in f128 and reports the
      f128-vs-f64-chunk diff -- the empirical per-term f64
      error of the pipeline, measured not assumed.
      Combined far-region error budget:  ~1e-5 (per-term f64
      rounding;  the known f64 engine-level quantity that V1
      and V2 already absorbed to mutual 1.7e-6).  The margin
      accuracy target is unchanged:  distinguishing 0.5026 from
      0.9999999965 needs ~1e-3.
    - nlt: exact bisection over the verified files (count_below),
      cross-required to equal the ledger's 10609961701 at this t
      (and re-verified today over 180 heights, 180/180).
    - lm / qrem / qext at dps-60 (the pi-probe verified these four
      stack items dps-invariant at 30/45/90/120);  la / ar from
      prod_with_budget (fixed f64 by design, with its own budget).
    - Kfull at dps-60;  margin vs V1/V2/ledger.

  V4's own error budget:  near region exact to ~1e-50 (dps-60
  sequential);  far region per-term f64 rounding (engine-level,
  sample-measured in-pipeline) bounded ~1e-5 in the totals;
  window-sum conversion exact (struct-unpacked 80-bit).

  READ-ONLY over the band files (never grep;  windowed reads only).
  ONE worker (owner rule:  the box has 4 PHYSICAL cores,  leave
  some idle;  D1 runs concurrently).  The v1 run (4 workers,  no
  stitch,  C section dropped) is superseded:  it agreed with the
  engine except for the missing pieces (delta +3.1019e8 re /
  -1.781 im = the A/B overlap block + the missing C section).
"""
import json
import math
import os
import sys
import time
import struct

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
import numpy as np                      # noqa: E402
from mpmath import mp                   # noqa: E402
import day037_h1_3e10 as D37            # noqa: E402  (CPU reference, VERBATIM)

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = HERE + "/out_day049b"
os.makedirs(OUT, exist_ok=True)

TF = 3490744648.3185544014          # p01 straddle t (day048 re-issue)
GX = 3490744654.3185544014          # anchor zero g_x at p01
A_WIN = 3.6e-4                      # near-region half-width (t-scale)
NLT_EXPECT = 10609961701            # the ledger's nlt at this t
WIN = 2 ** 26                       # 67,108,864 f64 elements (512 MB)
SUBCH = 100000                      # f128 subchunk

F_A = D37.A_F
F_B = D37.B_F
F_C = D37.C_F
F_D = D37.D_F

mp.workdps = 60


def fsize(p):
    return os.path.getsize(p) // 8


def f128_to_mpf(v):
    """exact mpf of an 80-bit x87 longdouble (10 bytes, fraction-first
    little-endian;  the x87 fraction field stores the leading bit).
    mpmath tuple convention (empirically verified here):  value =
    sign * mant * 2**exp.  Verified:  nextafter(1) round-trips.
    """
    raw = np.array(v, dtype=np.longdouble).tobytes()[:10]
    u64, u16 = struct.unpack("<QH", raw)
    sign = 1 if u16 & 0x8000 else 0
    expl = (u16 & 0x7fff) - 16383
    return mp.mpf((sign, u64, expl - 63, 64))


def near_sum(t, lo, hi, path):
    """dps-60 direct sum over file elements [lo, hi)."""
    mp.dps = 60
    arr = np.memmap(path, dtype="<f8", mode="r")
    re = mp.mpf(0)
    im = mp.mpf(0)
    t_mp = mp.mpf(repr(t))
    t2_mp = t_mp * t_mp
    one4 = mp.mpf("0.5")
    for i in range(lo, hi):
        g = mp.mpf(float(arr[i]))          # exact binary f64 -> mpf
        g2 = g * g
        Aq = g2 + mp.mpf("0.25")
        re += mp.log(abs(g2 - t2_mp)) - mp.log(Aq) + one4 / Aq
        im += t_mp / Aq
    return re, im


def far_worker(wid, segs, t):
    """segs: list of (path_or_None, start, count);  None = in-RAM L.
    Per-term VECTORIZED F64 (engine-identical term formula),
    per-1e5-subchunk f128 sums,  window sums -> OUT/wsums_w{wid}.jsonl
    as EXACT mpf decimals (struct-unpacked 80-bit).  One 1e6-element
    sample slice per worker is re-summed per-term in f128 and the
    diff logged to SAMPLE lines (the per-term f64 error, measured)."""
    done = os.path.join(OUT, "w%d.done" % wid)
    if os.path.exists(done):
        return
    t0 = time.time()
    mp.dps = 60
    tf64 = np.float64(repr(t))
    t2 = np.float64(float(t) * float(t))
    out = open(os.path.join(OUT, "wsums_w%d.jsonl" % wid), "a")
    try:
        total_elems = sum(cc for (_p, _s, cc) in segs)
        for (path, start, count) in segs:
            if count <= 0:
                continue
            if path is None:
                arr = D37._L_RAM
            else:
                arr = np.memmap(path, dtype="<f8", mode="r")
            off = start
            n = count
            while n > 0:
                m = min(WIN, n)
                g = np.ascontiguousarray(arr[off:off + m])
                g2 = g * g
                Aq = g2 + 0.25
                re_t = (np.log(np.abs(g2 - t2)) - np.log(Aq)
                        + 0.5 / Aq)
                im_t = tf64 / Aq
                full = (m // SUBCH) * SUBCH
                re_w = np.float128(0.0)
                im_w = np.float128(0.0)
                if full:
                    re_sc = re_t[:full].reshape(full // SUBCH, SUBCH) \
                        .astype(np.float128).sum(axis=1,
                                                 dtype=np.float128)
                    im_sc = im_t[:full].reshape(full // SUBCH, SUBCH) \
                        .astype(np.float128).sum(axis=1,
                                                 dtype=np.float128)
                    re_w += re_sc.sum(dtype=np.float128)
                    im_w += im_sc.sum(dtype=np.float128)
                if m > full:
                    re_w += re_t[full:].astype(np.float128).sum(
                        dtype=np.float128)
                    im_w += im_t[full:].astype(np.float128).sum(
                        dtype=np.float128)
                out.write("%d %s %s %d\n" %
                          (wid, mp.nstr(f128_to_mpf(re_w), 60),
                           mp.nstr(f128_to_mpf(im_w), 60), m))
                out.flush()
                del g, g2, Aq, re_t, im_t
                off += m
                n -= m
            del arr
        # ---- the per-term f64 error, MEASURED on a sample ----
        s_off = int(total_elems * 0.25)
        s_cnt = 1000000
        spath = sbase = None
        acc = 0
        for (path, start, count) in segs:
            if s_off < count:
                spath, sbase = path, start + s_off
                break
            s_off -= count
        if spath is not None and sbase is not None:
            arr = (D37._L_RAM if spath is None
                   else np.memmap(spath, dtype="<f8", mode="r"))
            g = np.ascontiguousarray(arr[sbase:sbase + s_cnt])
            g2 = g * g
            Aq = g2 + 0.25
            t128 = np.float128(np.float64(repr(t)))
            t2b = t128 * t128
            gf = g.astype(np.float128)
            g2f = gf * gf
            Aqf = g2f + np.float128(0.25)
            re_f = (np.log(np.abs(g2f - t2b)) - np.log(Aqf)
                    + np.float128(0.5) / Aqf).sum(dtype=np.float128)
            im_f = (t128 / Aqf).sum(dtype=np.float128)
            re_c = float(
                (np.log(np.abs(g2 - t2)) - np.log(Aq)
                 + 0.5 / Aq).sum(dtype=np.float64))
            im_c = float((tf64 / Aq).sum(dtype=np.float64))
            out.write("SAMPLE %d %s %s %d\n" %
                      (wid, mp.nstr(f128_to_mpf(re_f) - mp.mpf(re_c), 15),
                       mp.nstr(f128_to_mpf(im_f) - mp.mpf(im_c), 15),
                       s_cnt))
            out.flush()
            del arr
    finally:
        out.close()
    with open(done, "w") as fh:
        fh.write("ok %.1f\n" % (time.time() - t0))


def main():
    mp.dps = 60
    t0 = time.time()
    # fresh state (interrupt-safety:  wipe any partial sums first)
    import glob
    for f in glob.glob(os.path.join(OUT, "wsums_w*.jsonl")):
        open(f, "w").close()
    T = D37.Tail3E10(verbose=False)
    nlt = T.count_below(TF)
    print("V4  nlt re-derived exact = %d (expect %d) %s" %
          (nlt, NLT_EXPECT, "OK" if nlt == NLT_EXPECT else "MISMATCH-ABORT"),
          flush=True)
    if nlt != NLT_EXPECT:
        return

    nL = int(T.L.size)
    nA, nB, nC, nD = fsize(F_A), fsize(F_B), fsize(F_C), fsize(F_D)
    nABC_L = nL + nA + nB + nC
    # the A/B overlap stitch:  the engine's logical stream is
    # L + A + B[B_stitch:] + C + D  (the overlap block B[0:B_stitch]
    # is also A's tail).  Recomputed from the md5-pinned files:
    with open(F_A, 'rb') as fa:
        fa.seek(-8, 2)
        A_last = struct.unpack("<d", fa.read(8))[0]
    _ov = np.frombuffer(open(F_B, 'rb').read(256 * 1024 * 1024),
                        dtype='<f8')
    B_stitch = int(np.searchsorted(_ov, A_last, side='right'))
    assert B_stitch == 12626784, B_stitch
    print("V4  A/B stitch:  B starts at element %d (overlap block"
          " excluded)" % B_stitch, flush=True)
    print("V4  section sizes  L=%d A=%d B=%d C=%d D=%d"
          % (nL, nA, nB, nC, nD), flush=True)

    tA = TF * (1.0 - A_WIN)
    tB = TF * (1.0 + A_WIN)
    totA = T.count_below(tA)
    totB = T.count_below(tB)
    na = totA - nABC_L          # D element index of t(1-a)
    nb = totB - nABC_L          # D element index of t(1+a)
    print("V4  near window in D: [%d, %d) = %d zeros" % (na, nb, nb - na),
          flush=True)
    with open(os.path.join(OUT, "nearwin.json"), "w") as fh:
        json.dump({"na": na, "nb": nb, "tA": tA, "tB": tB}, fh)

    D37._L_RAM = T.L

    # far segments (engine stream minus the near window):
    #   L,  A,  B[B_stitch:],  C,  D[0:na),  D[nb:nD).  Disk order.
    segs = {
        0: [(None, 0, nL),
            (F_A, 0, nA),
            (F_B, B_stitch, nB - B_stitch),
            (F_C, 0, nC),
            (F_D, 0, na),
            (F_D, nb, nD - nb)],
        1: [], 2: [], 3: []}
    for w in (0, 1, 2, 3):
        print("V4  worker %d: %d elements"
              % (w, sum(cc for (_p, _s, cc) in segs[w])), flush=True)

    from multiprocessing import Pool
    with Pool(1) as pool:
        pool.starmap(far_worker, [(0, segs[0], TF)])

    re_re = mp.mpf(0)
    im_re = mp.mpf(0)
    nwin = 0
    samples = []
    for w in (0, 1, 2, 3):
        with open(os.path.join(OUT, "wsums_w%d.jsonl" % w)) as fh:
            for ln in fh:
                f_ = ln.split()
                if f_[0] == "SAMPLE":
                    samples.append((w, f_[1], f_[2], f_[3]))
                    continue
                if len(f_) < 4:
                    continue
                re_re += mp.mpf(f_[1])
                im_re += mp.mpf(f_[2])
                nwin += 1
    print("V4  window sums: %d" % nwin, flush=True)
    for s in samples:
        print("V4  per-term f64 sample w%d:  d_re=%s  d_im=%s  n=%s"
              % s, flush=True)
    print("V4  window sums: %d" % nwin, flush=True)

    re_near, im_near = near_sum(TF, na, nb, F_D)
    re_tot = re_re + re_near
    im_tot = im_re + im_near + mp.mpf(nlt) * mp.pi
    print("V4  tail re = %.30s" % mp.nstr(re_tot, 30), flush=True)
    print("V4  tail im = %.30s" % mp.nstr(im_tot, 30), flush=True)

    s = mp.mpc(0.5, mp.mpf(repr(TF)))
    lm = D37.logmain25212(s)
    _r30, _e30, qrem, qext, Bqrem, Bqext, _aud = D37.quad_pair(T, TF)
    (la, ar, _bla, _bar, _dmg) = D37.prod_with_budget(TF)
    print("V4  qrem = %.18s  qext = %.18s  budgets = %.2e %.2e"
          % (mp.nstr(qrem, 18), mp.nstr(qext, 18), Bqrem, Bqext), flush=True)
    print("V4  la = %.17g  ar = %.17g  (f64 constants, budgeted)"
          % (float(la), float(ar)), flush=True)
    z = mp.zeta(s)
    Kfull = mp.e ** (lm + mp.mpf(repr(float(la))) + 1j * mp.mpf(repr(float(ar)))
                     + re_tot + 1j * im_tot)
    Kfull = Kfull * mp.e ** qrem
    Kfull = Kfull * mp.e ** qext
    dev = D37.dev_parts(TF, GX, 60)
    pb = mp.mpf(repr(float(D37.M.p8_B(mp.mpf(repr(TF)), D37.n4(TF)))))
    residf = abs(z - Kfull)
    mnew = float(abs(z) * float(dev) / (float(pb) + float(residf)))
    phd = (float(mp.arg(Kfull / z)) % (2 * math.pi))
    if phd > math.pi:
        phd -= 2 * math.pi
    out = {
        "margin_V4": mnew, "absz": float(abs(z)),
        "absK": float(abs(Kfull)), "phase_K_minus_z_rad": phd,
        "residf": float(residf), "dev": float(dev), "pb": float(pb),
        "tail_re": float(re_tot), "tail_im": float(im_tot),
        "nlt": nlt, "windows": nwin, "near_zeros": nb - na,
        "elapsed_min": (time.time() - t0) / 60.0,
        "compare": {"V1_engine_f64": 0.502658531913,
                    "V2_80bit_ld": 0.502658103672,
                    "ledger_gpu_fleet": 0.9999999965},
    }
    with open(os.path.join(OUT, "RESULT_V4.json"), "w") as fh:
        json.dump(out, fh, indent=1)
    print("V4  |z|=%.12f  |K|=%.12f  phase(K)-phase(z)=%+.6f rad"
          % (out["absz"], out["absK"], phd), flush=True)
    print("V4  residf=%.12f  dev=%.12f  pb=%.3e"
          % (out["residf"], out["dev"], out["pb"]), flush=True)
    print("V4  MARGIN_V4 = %.12f" % mnew, flush=True)
    print("V4  compare V1=0.502658531913  V2=0.502658103672  "
          "ledger=0.9999999965", flush=True)
    print("V4  wall = %.1f min" % out["elapsed_min"], flush=True)
    print("V4  done.", flush=True)


if __name__ == "__main__":
    main()
