#!/usr/bin/env python3
# day040 - D2 + D4 in one streaming pass over the D band
# (S1-A1-EXPLORATION E5 items:  D2 excursion geometry,  D4 decade
#  epsilon stability,  D-band side).
#
# D2 (top-100 |DN| excursions):  locations,  magnitudes against the
#    2.615067 cap,  and the local gap signature (deficit-run vs
#    surplus-run,  length in zeros,  both sides).
# D4 (decade epsilon stability):  mean|delta| / zero on
#    (3e9, 1e10]  and  (1e10, 3e10]  (plus the whole D band),
#    alongside the certified B/C numbers from D1 (day039):
#    B ~ 0.334184,  C ~ 0.334459.
#
# The sweep also RE-DERIVES the certified A2 record pins (sup|DN|,
#   SUM_EPS raw,  N(3e10),  DN pins,  worst eps)  as a consistency
#   check against hi3e10/epsilon-sweep.log.
#
# Conventions (VERBATIM from day036_epsilon_sweep.py,  the certified
#   generator):
#     n_asym(x) = (x/2pi) log(x/2pi) - x/2pi + 0.75    (f64)
#     delta_i   = 1 - (n_asym(t_{i+1}) - n_asym(t_i))
#     DN(j)     = FRONTIER_N + j + 1 - n_asym(z_j)
#
# Bounded job:  1 thread,  streaming 128MB reads,  O(1) working set
#   plus a top-100 heap.  Phase 2 (gap signatures) is a bounded set
#   of ~200 random seeks.  Read-only on the band.
#
# Usage:
#   python3 day040_d2d4_dband.py             # full sweep + phases
#   python3 day040_d2d4_dband.py selftest    # synthetic band checks
import heapq
import os
import struct
import sys
import time

import numpy as np

R_H = "/home/jsmille/Projects/rh-missing-tail"
BAND = f"{R_H}/scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64"
OUT = f"{R_H}/scripts/rh/out_day040_dband.txt"
TOP100 = f"{R_H}/scripts/rh/out_day040_top100.tsv"

OLD_END = 2999245999.862950
FRONTIER_N = 9061794704
TARGET = 30000000000.0
T_SPLIT = 1.0e10                    # D4 split point
CHUNK = 128 * 1024 * 1024           # 16M f64 per read
N_TOP = 100
SIG_WIN = 4000                      # +/- zeros for phase-2 signature

# Certified pins (hi3e10/epsilon-sweep.log,  the A2 record):
PIN_SUP = 2.615067
PIN_SUMEPS = 31037858563.151787
PIN_DN_START = 0.525129318          # DN at OLD_END
PIN_DN_END = 0.904983521            # DN at band end
PIN_N3E10 = 101635962231
PIN_WORST = 3.301822662
PIN_TOTAL = 92577877714


def n_asym(x):
    # VERBATIM project RVM (day036_epsilon_sweep.n_asym,  f64):
    #  (x/2pi) log(x/2pi) - x/2pi + 0.75
    return (x / (2.0 * np.pi)) * np.log(x / (2.0 * np.pi)) \
        - x / (2.0 * np.pi) + 0.75


def log(msg):
    line = "%s %s" % (time.strftime("%F %T"), msg)
    sys.stdout.write(line + "\n")
    sys.stdout.flush()
    if OUT:
        with open(OUT, "a") as f:
            f.write(line + "\n")


def sweep(path, tag):
    fs = os.path.getsize(path)
    total = fs // 8
    log("D40[%s] start: %d zeros (%.1f GB),  CHUNK=%dMB"
        % (tag, total, fs / 1e9, CHUNK >> 20))
    heap = []                      # (absDN, j, dn, t)
    prev_t = None
    prev_na = None
    n_gaps = 0
    sum_abs = 0.0
    worst = 0.0
    sup_dn = 0.0
    argmax = (0.0, 0.0)
    n_under = 0                    # band zeros <= TARGET (so far)
    crossed = False
    b1 = [0, 0.0]                  # (3e9, 1e10]:  [n_gaps, sum|delta|]
    b2 = [0, 0.0]                  # (1e10, 3e10]
    sup_b = [[-1.0, 0.0], [-1.0, 0.0]]     # per-bucket (sup|DN|, t)
    t0 = time.time()
    nread = 0
    last_mark = 0
    with open(path, "rb", buffering=0) as f:
        buf = bytearray(CHUNK)
        while True:
            got = f.readinto(buf)
            if not got:
                break
            x = np.frombuffer(buf[:got], dtype="<f8")
            m = x.size
            if m:
                j0 = nread // 8
                nas = n_asym(x)
                dn = (FRONTIER_N + j0 + 1.0
                      + np.arange(m, dtype=np.float64)) - nas
                a = np.abs(dn)
                max_i = int(a.argmax())
                if a[max_i] > sup_dn:
                    sup_dn = float(a[max_i])
                    argmax = (sup_dn, float(x[max_i]))
                # per-chunk candidates into the global top-N heap
                if m <= 4 * N_TOP:
                    cands = [(float(a[i]), j0 + i, float(dn[i]),
                              float(x[i])) for i in range(m)]
                else:
                    big = np.argpartition(a, -4 * N_TOP)[-4 * N_TOP:]
                    cands = [(float(a[i]), j0 + int(i), float(dn[i]),
                              float(x[i])) for i in big]
                for c in cands:
                    if len(heap) < N_TOP:
                        heapq.heappush(heap, c)
                    elif c[0] > heap[0][0]:
                        heapq.heapreplace(heap, c)
                # bucket sups (by the zero's own t)
                m1 = x > T_SPLIT
                for bi, mk in ((0, ~m1), (1, m1)):
                    if mk.any():
                        am = a[mk]
                        im = int(am.argmax())
                        if am[im] > sup_b[bi][0]:
                            sup_b[bi] = [float(am[im]),
                                         float(x[mk][im])]
                # N(TARGET) count (monotone band  =>  chunk logic)
                if not crossed:
                    if x[0] > TARGET:
                        pass                       # not reached yet
                    elif x[-1] <= TARGET:
                        n_under += m
                    else:
                        n_under += int(np.searchsorted(x, TARGET,
                                                       side="right"))
                        crossed = True
                # cross-chunk gap
                n_gaps += 1 if prev_t is not None else 0
                if prev_t is not None:
                    d0 = 1.0 - (float(n_asym(np.array([x[0]]))[0])
                                - prev_na)
                    ad = abs(d0)
                    sum_abs += ad
                    if ad > worst:
                        worst = ad
                    tc = (prev_t + float(x[0])) * 0.5
                    if tc < T_SPLIT:
                        b1[0] += 1
                        b1[1] += ad
                    else:
                        b2[0] += 1
                        b2[1] += ad
                # in-chunk gaps
                if m > 1:
                    d = 1.0 - (nas[1:] - nas[:-1])
                    ad = np.abs(d)
                    n_gaps += m - 1
                    chunk_sum = float(ad.sum())
                    sum_abs += chunk_sum
                    wm = float(ad.max())
                    if wm > worst:
                        worst = wm
                    lt = x[:-1]
                    in1 = lt < T_SPLIT
                    n_in1 = int(in1.sum())
                    s_in1 = float(ad[in1].sum()) if n_in1 else 0.0
                    b1[0] += n_in1
                    b1[1] += s_in1
                    b2[0] += (m - 1) - n_in1
                    b2[1] += chunk_sum - s_in1
                prev_t = float(x[-1])
                prev_na = float(nas[-1])
            nread += got
            mark = nread // (4 * 1024 * 1024 * 1024)
            if mark > last_mark:
                last_mark = mark
                log("D40[%s] ... %.0f%% (%.1f min)"
                    % (tag, 100.0 * nread / fs,
                       (time.time() - t0) / 60))
    log("D40[%s] sweep done (%.1f min)" % (tag, (time.time() - t0) / 60))
    return {
        "total": total,
        "heap": sorted(heap, key=lambda r: -r[0]),
        "n_gaps": n_gaps,
        "sum_abs": sum_abs,
        "worst": worst,
        "sup_dn": sup_dn,
        "argmax": argmax,
        "n3e10": FRONTIER_N + n_under,
        "b1": b1,
        "b2": b2,
        "sup_b": sup_b,
    }


def phase2(path, rows):
    """Gap signatures for the top-N rows:  +/- SIG_WIN zero window.

    For the row at band index j with DN value v:  the LEFT run is the
    longest run of consecutive SAME-SIGN deltas (sign = sign(v))
    ending at the step into j;  the RIGHT run is the longest such run
    starting at the step out of j.  (A strictly-zero delta stops a
    run;  none is expected at this scale.)  Reports run lengths in
    zeros,  the signed delta sum over each run (the drift it
    carries),  the adjacent raw gaps,  and the local mean gap.
    """
    fs = os.path.getsize(path)
    total = fs // 8
    out = []
    with open(path, "rb", buffering=0) as f:
        for (adn, j, v, t) in rows:
            a = max(1, j - SIG_WIN)
            b = min(total - 2, j + SIG_WIN)
            jw = max(1, min(j, b - 1))          # keep j strictly inside
            f.seek(a * 8)
            w = np.frombuffer(f.read((jw - a + 2) * 8), dtype="<f8")
            i0 = jw - a
            nas_w = n_asym(w)
            d = 1.0 - (nas_w[1:] - nas_w[:-1])
            sgn = 1.0 if v >= 0 else -1.0
            L = 0
            acc = 0.0
            k = i0 - 1
            while k >= 0 and np.sign(d[k]) == sgn:
                L += 1
                acc += float(d[k])
                k -= 1
            R = 0
            accr = 0.0
            k = i0
            while k < len(d) and np.sign(d[k]) == sgn:
                R += 1
                accr += float(d[k])
                k += 1
            gl = float(w[i0]) - float(w[i0 - 1])
            gr = float(w[i0 + 1]) - float(w[i0])
            out.append((adn, j, v, t, L, R, acc, accr, gl, gr,
                        float(np.mean(w[1:] - w[:-1]))))
    return out


def selftest():
    import random
    n = 200000
    rng = random.Random(12345)
    t = 1.0e8
    ts = [t]
    for i in range(n - 1):
        base = 0.318
        s = rng.choice([-1, 1])
        if 10000 < i < 10030:
            s = 1                      # planted surplus run
        g = base * (1.0 + 0.35 * s * rng.random())
        t += g
        ts.append(t)
    ts = np.array(ts)
    p = "/tmp/day040_selftest_band.f64"
    ts.astype("<f8").tofile(p)
    global FRONTIER_N, OUT, TARGET
    OUT = "/tmp/day040_selftest_out.txt"
    FRONTIER_N = 0
    TARGET = float(ts[150000])
    r = sweep(p, "selftest")
    ok = True
    if r["total"] != n:
        ok = False
        log("selftest FAIL: total %d != %d" % (r["total"], n))
    nas = n_asym(ts)
    dn_full = (np.arange(n, dtype=np.float64) + 1.0) - nas
    a = np.abs(dn_full)
    if abs(float(a.max()) - r["sup_dn"]) > 1e-9:
        ok = False
        log("selftest FAIL: sup %.12f vs %.12f"
            % (float(a.max()), r["sup_dn"]))
    topi = int(a.argmax())
    if abs(r["heap"][0][1] - topi) > 0 and \
            abs(r["heap"][0][0] - float(a[topi])) > 1e-9:
        ok = False
        log("selftest FAIL: top heap row vs direct argmax")
    d_full = 1.0 - (nas[1:] - nas[:-1])
    if abs(float(np.abs(d_full).sum()) - r["sum_abs"]) > 1e-3:
        ok = False
        log("selftest FAIL: sum_abs %.9f vs %.9f"
            % (float(np.abs(d_full).sum()), r["sum_abs"]))
    if r["n3e10"] != int(np.searchsorted(ts, TARGET, side="right")):
        ok = False
        log("selftest FAIL: n3e10 %d vs %d"
            % (r["n3e10"],
               int(np.searchsorted(ts, TARGET, side="right"))))
    sig = phase2(p, r["heap"][:5])
    for row in sig:
        if row[4] < 0 or row[5] < 0:
            ok = False
            log("selftest FAIL: negative run length")
    os.remove(p)
    log("selftest sup_dn=%.9f n_gaps=%d sum_abs=%.6f n3e10=%d"
        % (r["sup_dn"], r["n_gaps"], r["sum_abs"], r["n3e10"]))
    log("SELFTEST-%s" % ("PASS" if ok else "FAIL"))
    return ok


def main():
    if len(sys.argv) > 1 and sys.argv[1] == "selftest":
        sys.exit(0 if selftest() else 1)
    if os.path.exists(OUT):
        os.remove(OUT)
    res = sweep(BAND, "band3e10")

    # ---- consistency vs the certified A2 pins ----
    log("D40 CONSISTENCY vs hi3e10/epsilon-sweep.log:")
    checks = [
        ("total zeros", res["total"], PIN_TOTAL, 0.0),
        ("SUM_EPS raw", res["sum_abs"], PIN_SUMEPS, 1e-3),
        ("worst eps", res["worst"], PIN_WORST, 1e-6),
        ("sup |DN|", res["sup_dn"], PIN_SUP, 5e-7),
        ("N(3e10)", res["n3e10"], PIN_N3E10, 0.0),
    ]
    allok = True
    for name, got, pin, tol in checks:
        ok = abs(got - pin) <= tol
        allok = allok and ok
        log("  %-14s got=%.12g  pin=%.12g  tol=%g  %s"
            % (name, got, pin, tol, "OK" if ok else "MISMATCH"))
    dn_start = FRONTIER_N - float(n_asym(np.array([OLD_END]))[0])
    fs = os.path.getsize(BAND)
    with open(BAND, "rb") as f:
        f.seek(fs - 8)
        last_zero = struct.unpack("<d", f.read(8))[0]
    dn_end = (FRONTIER_N + res["total"]) - float(
        n_asym(np.array([last_zero]))[0])
    for name, got, pin in (("DN(OLD_END)", dn_start, PIN_DN_START),
                           ("DN(band end)", dn_end, PIN_DN_END)):
        ok = abs(got - pin) < 1e-5
        allok = allok and ok
        log("  %-14s got=%.9f  pin=%.9f  %s"
            % (name, got, pin, "OK" if ok else "MISMATCH"))
    log("CONSISTENCY:  %s" % ("ALL OK" if allok else "FAILED"))

    # ---- D4:  decade epsilon stability ----
    log("D40 D4 (D-band side,  mean|delta| per zero):")
    log("  (3e9, 1e10]      n=%d  mean|delta| = %.6f"
        % (res["b1"][0], res["b1"][1] / res["b1"][0]))
    log("  (1e10, 3e10]     n=%d  mean|delta| = %.6f"
        % (res["b2"][0], res["b2"][1] / res["b2"][0]))
    log("  (3e9, 3e10] all  n=%d  mean|delta| = %.6f"
        % (res["n_gaps"], res["sum_abs"] / res["n_gaps"]))
    log("  [reference  D1/day039:  B ~ 0.334184,  C ~ 0.334459]")
    log("  sup|DN| (3e9,1e10]  = %.9f  at t = %.6f"
        % tuple(res["sup_b"][0]))
    log("  sup|DN| (1e10,3e10] = %.9f  at t = %.6f"
        % tuple(res["sup_b"][1]))
    log("  global sup|DN|      = %.9f  at t = %.6f"
        % (res["sup_dn"], res["argmax"][1]))

    # ---- D2:  top-100 excursion table + gap signatures ----
    rows = res["heap"]
    log("D40 D2 phase 2 (gap signatures for top-%d):" % len(rows))
    sig = phase2(BAND, rows)
    with open(TOP100, "w") as f:
        f.write("rank\tabsDN\tband_index\tt\tDN\tt_left_run\t"
                "t_right_run\trun_sum_left\trun_sum_right\t"
                "gap_left\tgap_right\tlocal_mean_gap\n")
        for k, ((adn, j, v, t), s) in enumerate(zip(rows, sig)):
            f.write("%d\t%.9f\t%d\t%.9f\t%.9f\t%d\t%d\t%.9f\t"
                    "%.9f\t%.9f\t%.9f\t%.9f\n"
                    % (k + 1, adn, j, t, v, s[4], s[5], s[6], s[7],
                       s[8], s[9], s[10]))
    for k, ((adn, j, v, t), s) in enumerate(zip(rows[:20], sig[:20])):
        log("  #%-3d |DN|=%.6f  t=%.6f  DN=%+.6f  Lrun=%d Rrun=%d  "
            "Lsum=%+.3f Rsum=%+.3f  gl=%.4f gr=%.4f"
            % (k + 1, adn, t, v, s[4], s[5], s[6], s[7], s[8], s[9]))
    log("D40 DONE  (top-100 table:  %s)" % TOP100)


if __name__ == "__main__":
    main()
