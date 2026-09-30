#!/usr/bin/env python3
"""day048 -- dps-90/120 RE-ISSUE of the worst-10 negative-k H1 points
(the C-2 prescription from the 505-pt interim reading; E15/E16 context).

Question (numerical vs structural, the 4e-9 margin drift):
  The 505-pt interim reading found margin(x, k) - 1 ~ A(x)*k, odd
  in k, 96.4% of variance in one linear term, worst at x = 3.23e9,
  k = -12 (margin 1 - 3.7e-9).  Row budgets: the dps-30 side is
  clean at 1e-23..1e-21 (Bz, Bdev, Bqrem, Bqext); the f64
  1.016e11-zero pairlog sum carries a certified budget Btail_re
  ~ 4e-4 (a preflight measured the slab-1 f64-pairwise-vs-fsum
  error at 6.6e-7 on a 3.5e8 sum, i.e. the full-band f64 error
  lands at ~1e-4..1e-5 ABSOLUTE IN THE EXPONENT -- 10^4..10^5
  OVER the 4e-9 drift).  The re-issue discriminates at each
  point by re-issuing margin = |z|*dev/(pb + |z - Kfull|) with:

    V0  ledger (engine f64-pairwise re/im + dps-30 zeta)
    V1  engine f64-pairwise re/im  + dps-90/120 zeta/quads/dev
        (isolates the dps-30 zeta level)
    V2  chunked-80bit EXACT f64 re/im + dps-90/120 zeta/quads/dev
        (isolates the f64 pairwise rounding of the big sum)

  V2 - V1 = the f64-sum effect on the margin, exactly.
  If the k-linear 4e-9 pattern collapses in V2 to its ~3e-9 floor:
  the drift is f64 pairwise roundoff in the 1.016e11-zero sum
  (numerical, law-like, odd in k by the window-constant vs
  pole-shift structure) -> the data certificate is clean.
  If it PERSISTS at ~4e-9 above the V2 floor: structural -- a
  genuine O(1/x)*k effect in the zeta data -> discovery.

"Exact f64" via chunked 80-bit tree (x86 longdouble):
  per 1024 consecutive zeros (a smooth-scale chunk except the one
  pole chunk, whose range is 24 over the whole chunk) the np
  longdouble reduce is exact to ~1e-15/chunk; the 9.9e7 chunk sums
  are then pairwise-tree reduced in 80-bit across the band
  (adjacent ratios stay < 10 through all 27 levels, so every tree
  node is an exact 80-bit add).  Total floor ~ 3e-9 absolute,
  i.e. ~10^4 below the measured f64 error and at the drift scale.

The engine path is REPLICATED in the same stream (bit-exact
expected: same arrays, same float(np.sum) per slab, same
longdouble accumulation) and VERIFIED against the real engine
call (a second stream) on the first two points; HALT-elsewhere
keeps the engine pass authoritative if a mismatch ever shows.

COMPUTE, NEVER RECALL:  day037_h1_3e10 is imported verbatim
(Tail3E10, tail_with_budget, logmain25212, quad_section,
dev_parts, prod_with_budget, M, constants).  One core per worker,
4 workers (owner rule: 2 of 32 reserved; day047 holds 1).  No GPU.
Band files read-only.  Per-point results land on disk as they
finish (interrupt-safe).
"""
import json
import math
import os
import sys
import time
import glob
import numpy as np
from mpmath import mp
from multiprocessing import Pool

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")
import h1merge_ingest as M          # noqa: E402
import day037_h1_3e10 as D37         # noqa: E402  (engine, verbatim)

N_WORST = 24
N_WORKERS = int(os.environ.get("RH_WORKERS", "14"))
# 16-physical-core box (Ryzen AI MAX+ 395, 32 threads): 2 physical
# reserved per owner rule -> 14 max busy; each worker single-core.
CH = 1024
HERE = os.path.dirname(os.path.abspath(__file__))
OUTDIR = HERE + "/out_day049f_pts"  # own dir: day048 results are read-only reference
os.makedirs(OUTDIR, exist_ok=True)

_TAIL = None
_CHUNKS = {}


def get_T():
    global _TAIL
    if _TAIL is None:
        _TAIL = D37.Tail3E10(verbose=False)
    return _TAIL


# ----------------------------------------------------------------------
# selection (read-only over the in-hand rows)
# ----------------------------------------------------------------------
def select_worst():
    pts = {}
    for pth in glob.glob(HERE + "/ckpt_h1_3e10/widx*.pts") + \
               glob.glob(HERE + "/h1_final_fleet/5900x/ckpt/widx*.pts"):
        rows, _d, _c = M.parse_pts(pth)
        for k, raw in rows:
            fp = raw.split(",")
            k = M._k_of_row(fp)
            x, t, g = float(fp[1]), float(fp[2]), float(fp[3])
            mnew = float(fp[4])
            if k < 0:
                key = "%d_%.10f" % (k, x)
                if key not in pts or mnew < pts[key]["mnew"]:
                    pts[key] = {"x": x, "t": t, "g": g, "k": k,
                                "mnew": mnew, "src": os.path.basename(pth)}
    with open(os.path.join(
            HERE, "h1_final_fleet/4090-box/out_day038_full_pts.txt")) as fh:
        for ln in fh.read().split("\n"):
            if not ln.startswith("ok"):
                continue
            fp = ln.split(",")
            k = M._k_of_row(fp)
            if k < 0:
                key = "%d_%.10f" % (k, float(fp[1]))
                mnew = float(fp[4])
                if key not in pts or mnew < pts[key]["mnew"]:
                    pts[key] = {"x": float(fp[1]), "t": float(fp[2]),
                                "g": float(fp[3]), "k": k,
                                "mnew": mnew, "src": "4090-box"}
    return sorted(pts.values(), key=lambda p: p["mnew"])[:N_WORST]


# ----------------------------------------------------------------------
# fast core (dps-90/120 zeta, quads, dev, prod, lm)
# ----------------------------------------------------------------------
def fast_core(tf, g, dps):
    mp.dps = dps
    t = mp.mpf(repr(tf))
    s = mp.mpc(0.5, t)
    z = mp.zeta(s)
    lm = D37.logmain25212(s)
    T = get_T()
    qrem = D37.quad_section(D37._kint(s), repr(T.G_LAST),
                            D37.REMHI, 400, dps)
    qext = D37.quad_section(D37._kint(s), D37.REMHI, D37.REMHI2, 400, dps)
    dev = D37.dev_parts(tf, g, dps)
    (la, ar, _bla, _bar, _dmg) = D37.prod_with_budget(tf)
    return {"z": z, "lm": lm, "qrem": qrem, "qext": qext, "dev": dev,
            "la": la, "ar": ar, "dps": dps, "t": tf}


_PB_CACHE = {}


def pb_for(t):
    key = repr(t)
    if key not in _PB_CACHE:
        _PB_CACHE[key] = float(D37.M.p8_B(mp.mpf(key), D37.n4(t)))
    return _PB_CACHE[key]


def ld19(x):
    """exact 80-bit decimal of a longdouble (16 fractional digits;
    covers the 19 significant digits of the 80-bit mantissa at any
    magnitude on this band;  mp.mpf of it keeps the 80-bit value)."""
    return format(x, ".16f")


def margin_from(fc, re_mp, im_mp):
    """margin_new = |z|*dev/(pb + |z - Kfull|)  with re/im given as
    READY mpmath values (the caller owns the precision story)."""
    dps = fc["dps"]
    mp.dps = dps
    Kfull = mp.e ** (fc["lm"] + mp.mpf(repr(fc["la"]))
                     + 1j * mp.mpf(repr(fc["ar"])) + re_mp + 1j * im_mp)
    Kfull = Kfull * mp.e ** fc["qrem"]
    Kfull = Kfull * mp.e ** fc["qext"]
    residf = abs(fc["z"] - Kfull)
    zabs = abs(fc["z"])
    pb = pb_for(fc["t"])
    mnew = float(zabs * fc["dev"]) / (pb + float(residf))
    return {"residf": float(residf), "zabs": float(zabs),
            "dev": float(fc["dev"]), "pb": pb, "mnew": mnew,
            "Kfull_abs": float(abs(Kfull))}


# ----------------------------------------------------------------------
# slow core: ONE stream, three accumulations
# ----------------------------------------------------------------------
def stream_pass(tf, verify_engine=False):
    """One pass over the (1e7, G_LAST] tail:
      eng  = the replicated engine accumulation (bit-exact target);
      ld   = chunked-80bit exact f64 (the V2 re/im source).
    verify_engine also runs the real engine pass (second stream)
    and asserts bit equality."""
    T = get_T()
    T.restart()
    tf64 = tf
    t2 = tf64 * tf64
    SUB = D37.SUB
    n = T.n_tail
    nchunk = (n + CH - 1) // CH
    ck_re = np.empty(nchunk, dtype=np.longdouble)
    ck_im = np.empty(nchunk, dtype=np.longdouble)
    ci = 0
    eng_re = np.longdouble(0)
    eng_im = np.longdouble(0)
    i = 0
    t0 = time.time()
    while i < n:
        m = min(SUB, n - i)
        c = T.read_slab(m)
        g2 = c * c
        A = g2 + 0.25
        re_t = np.log(np.abs(g2 - t2)) - np.log(A) + 0.5 / A
        im_t = tf64 / A
        # (a) engine replica: float pairwise per slab, ld across
        eng_re = eng_re + np.longdouble(float(np.sum(re_t)))
        eng_im = eng_im + np.longdouble(float(np.sum(im_t)))
        # (b) chunked 80-bit:  per-slab 1024-chunks (exact to
        #     ~1e-15), last short chunk via math.fsum (exact)
        full = (m // CH) * CH
        if full:
            r2 = re_t[:full].reshape(full // CH, CH)
            i2 = im_t[:full].reshape(full // CH, CH)
            ck_re[ci:ci + full // CH] = r2.sum(axis=1, dtype=np.longdouble)
            ck_im[ci:ci + full // CH] = i2.sum(axis=1, dtype=np.longdouble)
            ci += full // CH
        if m > full:
            ck_re[ci] = math.fsum(re_t[full:])
            ck_im[ci] = math.fsum(im_t[full:])
            ci += 1
        i += m
        del c, g2, A, re_t, im_t
    assert ci == nchunk
    nlt = T.count_below(tf64)
    eng = {"re": float(eng_re),
           "im": float(eng_im + np.longdouble(nlt * np.pi)),
           "nlt": nlt, "t_eng": eng_re, "t_im": eng_im}
    # global pairwise tree over the chunk sums (exact 80-bit adds:
    # adjacent ratios < 10 through all levels on this band).
    # numpy's pairwise reduction inside each node keeps the per-node
    # error at the 80-bit floor;  an odd carry is propagated whole.
    def tree(a):
        a = a.astype(np.longdouble, copy=False)
        while a.size > 1:
            if a.size % 2:
                a = np.concatenate([a[:-1].reshape(-1, 2).sum(
                    axis=1, dtype=np.longdouble), a[-1:]])
            else:
                a = a.reshape(-1, 2).sum(axis=1, dtype=np.longdouble)
        return a.item()  # np.longdouble scalar

    ld = {"re": tree(ck_re), "im": tree(ck_im), "nlt": nlt}  # longdouble
    out = {"eng": eng, "ld": ld, "elapsed_stream": time.time() - t0}
    if verify_engine:
        Te = get_T()
        Te.restart()
        ere, eim, enlt, Bre, Bim, dmin = D37.tail_with_budget(Te, tf)
        out["engine_real"] = {"re": ere, "im": eim, "nlt": enlt,
                              "B_re": Bre, "B_im": Bim, "dmin": dmin}
        out["verify"] = {
            "replica_bit_exact": (ere == float(eng_re)
                                  and eim == eng["im"]
                                  and enlt == nlt),
            "d_re_replica": abs(ere - float(eng_re)),
            "d_im_replica": abs(eim - eng["im"]),
            "f64_minus_ld": {
                "re": ere - float(ld["re"]),
                "im": eim
                - float(np.longdouble(ld["im"])
                        + np.longdouble(enlt * np.pi))}}
    return out


def run_point(idx, pt):
    out = os.path.join(OUTDIR,
                       "pt%02d_k%+d_x%.6f.res" % (idx, pt["k"], pt["x"]))
    if os.path.exists(out):
        print("day048  pt%02d k=%+3d already done, skipping"
              % (idx, pt["k"]), flush=True)
        return out
    t0 = time.time()
    tf, g = pt["t"], pt["g"]
    rec = {"point": pt, "t0": t0}
    mp.dps = 120
    fc90 = fast_core(tf, g, 90)
    fc120 = fast_core(tf, g, 120)
    sp = stream_pass(tf, verify_engine=(idx in (0, 1)))
    rec["stream"] = {
        "ld": {"re": ld19(sp["ld"]["re"]), "im": ld19(sp["ld"]["im"]),
               "nlt": int(sp["ld"]["nlt"])},
        "elapsed_stream": sp["elapsed_stream"]}
    if "engine_real" in sp:
        rec["stream"]["engine_real"] = sp["engine_real"]
        rec["stream"]["verify"] = sp["verify"]
    for tag, fc in (("dps90", fc90), ("dps120", fc120)):
        # V1: the engine's exact f64 values (im_f already carries
        #     nlt*pi,  rounded once by the engine as in ev_point)
        m1 = margin_from(fc, mp.mpf(repr(sp["eng"]["re"])),
                         mp.mpf(repr(sp["eng"]["im"])))
        # V2: chunked-80bit totals (f64-exact sum) at 19 digits;
        #     nlt*pi in the engine's own f64 form
        m2 = margin_from(
            fc, mp.mpf(ld19(sp["ld"]["re"])),
            mp.mpf(ld19(sp["ld"]["im"]))
            + mp.mpf(repr(sp["ld"]["nlt"] * math.pi)))
        rec[tag + "_f64pairwise_reim"] = m1
        rec[tag + "_ldexact_reim"] = m2
        if "engine_real" in sp:
            rec[tag + "_check_engine_margin"] = margin_from(
                fc, mp.mpf(repr(sp["engine_real"]["re"])),
                mp.mpf(repr(sp["engine_real"]["im"])))
    rec["elapsed"] = time.time() - t0
    with open(out, "w") as fh:
        json.dump(rec, fh, indent=1, default=str)
    v = sp.get("verify")
    print("day048  pt%02d k=%+3d x=%.6g  mnew(ledger)=%.12f  "
          "d120: mnew(f64)=%.12f mnew(ld)=%.12f  "
          "f64-ld re=%.2e  %s  (%.0fs)"
          % (idx, pt["k"], pt["x"], pt["mnew"],
             rec["dps120_f64pairwise_reim"]["mnew"],
             rec["dps120_ldexact_reim"]["mnew"],
             (sp["verify"]["f64_minus_ld"]["re"] if v else -1.0),
             ("REPLICA-OK" if v and v["replica_bit_exact"]
              else ("REPLICA-MISMATCH" if v else "n/a")),
             rec["elapsed"]), flush=True)
    return out


def summarize():
    fns = sorted(glob.glob(OUTDIR + "/pt*_k*_x*.res"))
    lines = ["day048 re-issue summary  (V0 ledger | V1 f64-pairwise | "
             "V2 80bit-exact,  all at dps-120 zeta/quads)",
             "pt  k    x           mnew(V0)       mnew(V1)        "
             "mnew(V2)     d(V2-1)    f64-ld(re)"]
    for fn in fns:
        with open(fn) as fh:
            r = json.load(fh)
        p = r["point"]
        v1 = r["dps120_f64pairwise_reim"]["mnew"]
        v2 = r["dps120_ldexact_reim"]["mnew"]
        f64_ld = None
        try:
            f64_ld = r["stream"]["verify"]["f64_minus_ld"]["re"]
        except (KeyError, TypeError):
            pass
        lines.append("p%02d %+3d %.9f  %.12f  %.12f  %.12f  %+.3e  %s"
                     % (int(os.path.basename(fn)[2:4]), p["k"], p["x"], p["mnew"], v1, v2,
                        v2 - 1.0,
                        ("%.2e" % f64_ld) if f64_ld is not None else "  -"))
    txt = "\n".join(lines)
    with open(OUTDIR + "/SUMMARY.txt", "w") as fh:
        fh.write(txt + "\n")
    return txt


if __name__ == "__main__":
    sel = select_worst()
    print("day048: worst-%d negative-k selection" % N_WORST, flush=True)
    for p in sel:
        print("  k=%+3d  x=%.10f  t=%.6f  mnew=%.12f"
              % (p["k"], p["x"], p["t"], p["mnew"]), flush=True)
    t0 = time.time()
    with Pool(N_WORKERS) as pool:
        pool.starmap(run_point, list(zip(range(len(sel)), sel)))
    print("\ndone in %.1f min" % ((time.time() - t0) / 60.0), flush=True)
    print(summarize(), flush=True)
