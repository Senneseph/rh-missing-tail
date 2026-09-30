"""day052c: full-696 re-issue of the 3e10 H1 ledger with the FIXED
engine -- LEDGER-DRIVEN (the point set is the fleet ledger's own
(x, t, g, k) rows,  not a re-derivation via nearest_zero).

WHY THE CHANGE (2026-09-30,  caught by the day052b smoke):
  D37.nearest_zero indexed the 740 GB band-only D file with GLOBAL
  zero indices (offset (d0+mid)*8,  d0 = n_tail - nD = 9.04e9) as if
  it were the full 812 GB tail.  For every anchor x < ~5.79e9 (the
  band entry living at file offset d0*8) the binary search clamps to
  that one zero:  8 of 29 windows (x = 3.23e9 .. 5.56e9) would have
  been re-issued at the SAME g = 5.7908e9 straddles,  margins off
  ~5e-3 (smoke point 1:  0.50740 at the clamped straddle vs 0.50228
  at the ledger's true straddle).  nearest_zero is now fixed
  (file-local offsets,  verified bit-exact against the ledger's own
  g for the six low-band anchors,  selftest(d) gates it) -- but the
  re-issue no longer needs it at all:  the fleet ledger already
  carries the correct (t, g) per point  (low-band g's were generated
  by the fleet-era pipeline's own file-local lookup),  so day052c
  feeds cert_point the ledger's (t, g) directly and the point set
  can only be what the 696 ledger says it is.

Point set:  the IN-HAND fleet ledger -- union of the three sources
  ckpt_h1_3e10/widx*.pts              (this box's fleet run)
  h1_final_fleet/5900x/ckpt/widx*.pts (the owned non-Strix box)
  h1_final_fleet/4090-box/out_day038_full_pts.txt (4090 box)
deduped by (k, x)  (both k signs),  every duplicate must agree on
(t, g) to < 1e-9  else the run refuses to start.  The nominal grid
is 29 anchors x 24 k-layers = 696,  but the fleet never produced
all of them:  the in-hand union is 505 points  (191 (k, x) pairs
were never generated --  the fleet was shut down mid-run).  The
re-issue covers exactly the 505 in-hand points --  the true ledger
replacement;  the 191 never-in-hand pairs are documented at launch
and are an optional FOLLOW-UP fill (new data,  different claim),
not part of the re-issue.

Per point:  D37.cert_point(T, t, g, audit=(k == -12)) -- the fixed
reference engine (adjacent-pair quad_pair,  |K| ~ O(|z|) guard,
f64 tail with budgets,  dps-30/60 mpmath fast parts,  mnew + mcert)
-- written as the 21-column fleet row + a point-granular JSONL
checkpoint (append BEFORE the row joins the .pts view;  restarts
skip done (x, k)).  Never touches the artifact ledger files.

SMOKE (H1V2C_SMOKE=1):  run the 24 worst-24 points -- the exact
points with deep day049f references (dps-90/120 f64-pairwise AND
80-bit-exact streams;  pt00/pt01 also carry the bit-exact
engine-replica arms) -- on cores 0-13,  and gate on every point
sitting at the expected distance from its day049f references:
  pt00/pt01:  |mnew - dps120_check_engine_margin| <= 1e-5
  others:     |mnew - dps90_f64pairwise|  <= 1e-5  AND
              |mnew - dps120_ldexact|     <= 2e-5
(observed engine-vs-reference spread is <= 1.5e-6;  these gates
are ~10x looser than observation but 10000x tighter than the
clamp bug's 5e-3 signature.)  Only SMOKE PASS releases the full
run via the supervisor.

Launch:
  H1V2C_SMOKE=1 taskset -c 0-13 env OMP_NUM_THREADS=1 \
    nohup python3 day052c_reissue_696_ledger.py \
    > out_day052c_smoke.log 2>&1 &
  (supervisor:  out_day052c_autolaunch.sh)

Cost:  one (1e7, G_LAST] band sweep per point ~= 70 min at 14-way;
505 in-hand points ~= 2-2.5 days of wall (I/O floor:  ~410 TB of
band traffic,  independent of loop order).  (The nominal-696 fill
follow-up, if run later, would add ~96 h.)
"""
import concurrent.futures as cf
import glob
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37        # noqa: E402  (fixed engine)
import h1merge_ingest as M          # noqa: E402

OUTDIR = HERE + "/out_day052c_696"
os.makedirs(OUTDIR, exist_ok=True)
JSONL = OUTDIR + "/points.jsonl"
PTS = OUTDIR + "/reissue_ledger_3e10.pts"
SMOKE_JSON = OUTDIR + "/smoke_report.json"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)
KLIST = [k for k in range(-12, 13) if k != 0]
SAFE_KEYS = ("t", "g", "mnew", "mcert", "residf", "zeta", "dev", "Bexp",
             "Bph", "Bz", "Bdev", "Btail_re", "Btail_im", "Bprod_re",
             "Bprod_im", "Bqrem", "Bqext", "nlt", "flag", "re", "im",
             "pb", "Kabs", "la", "ar")


# ----------------------------------------------------------------------
# point set:  the fleet ledger's own 696 (x, t, g, k)
# ----------------------------------------------------------------------
def load_ledger_points():
    pts = {}
    mism = []

    def add(x, t, g, k, mnew, src):
        if k not in KLIST:
            return
        key = (k, x)
        if key in pts:
            o = pts[key]
            if abs(o["t"] - t) > 1e-9 or abs(o["g"] - g) > 1e-9:
                mism.append((k, x, o["t"], t, o["g"], g,
                             o["src"], src))
                return
            if mnew < o["mnew"]:
                o["mnew"] = mnew
                o["src"] = o["src"] + "+dup"
        else:
            pts[key] = {"x": x, "t": t, "g": g, "k": k,
                        "mnew": mnew, "src": src}

    widxes = (glob.glob(HERE + "/ckpt_h1_3e10/widx*.pts")
              + glob.glob(HERE + "/h1_final_fleet/5900x/ckpt/widx*.pts"))
    for pth in widxes:
        rows, _d, _c = M.parse_pts(pth)
        for _k, raw in rows:
            fp = raw.split(",")
            if len(fp) < 9:
                continue
            k = M._k_of_row(fp)
            add(float(fp[1]), float(fp[2]), float(fp[3]), k,
                float(fp[4]), os.path.basename(pth))
    with open(HERE + "/h1_final_fleet/4090-box/out_day038_full_pts.txt"
              ) as fh:
        for ln in fh.read().split("\n"):
            if not ln.startswith("ok,"):
                continue
            fp = ln.split(",")
            k = M._k_of_row(fp)
            add(float(fp[1]), float(fp[2]), float(fp[3]), k,
                float(fp[4]), "4090-box")
    return pts, mism


def verify_point_set(pts):
    xs = D37.grid()
    missing = [(k, x) for x in xs for k in KLIST if (k, x) not in pts]
    anchors = set(xs)
    extra = [(k, x) for (k, x) in pts if x not in anchors]
    return xs, missing, extra


# ----------------------------------------------------------------------
# worker
# ----------------------------------------------------------------------
_WT = None


def _wT():
    global _WT
    if _WT is None:
        _WT = D37.Tail3E10(verbose=False)
    return _WT


def do_point(pt):
    x, t, g, k = pt["x"], pt["t"], pt["g"], pt["k"]
    T = _wT()
    t0 = time.time()
    p = D37.cert_point(T, t, g, audit=(k == -12))
    el = time.time() - t0
    row = D37._point_row(x, p)
    p_safe = {kk: (int(vv) if kk == "nlt" else
                   (bool(vv) if kk == "flag" else float(vv)))
              for kk, vv in p.items()
              if kk in SAFE_KEYS
              and isinstance(vv, (int, float, bool, type(None)))}
    rec = {"x": x, "k": int(k), "t": t, "g": g, "row": row,
           "elapsed_s": el, "src": pt.get("src", ""), "p": p_safe}
    print("PT x=%.4g k=%+3d t=%.5f mnew=%.9f mcert=%.9f flag=%d "
          "(%.1f min)" % (x, k, t, p["mnew"], p["mcert"], p["flag"],
                          el / 60.0), flush=True)
    return rec


def load_done():
    done = {}
    if os.path.exists(JSONL):
        with open(JSONL) as fh:
            for ln in fh:
                r = json.loads(ln)
                done[(r["k"], r["x"])] = r
    return done


# ----------------------------------------------------------------------
# smoke:  the 24 worst-24 points vs their day049f references
# ----------------------------------------------------------------------
def smoke_refs():
    import day049f_worst24_reissue as D49
    sel = D49.select_worst()
    out = []
    for i, pt in enumerate(sel):
        fn = os.path.join(HERE, "out_day049f_pts",
                          "pt%02d_k%+d_x%.6f.res" % (i, pt["k"], pt["x"]))
        if not os.path.exists(fn):
            raise SystemExit("day049f reference missing: %s" % fn)
        with open(fn) as fh:
            ref = json.load(fh)

        def arm(*names):
            for nm in names:
                if nm in ref and isinstance(ref[nm], dict) \
                        and "mnew" in ref[nm]:
                    return float(ref[nm]["mnew"])
            return None
        m_eng = arm("dps120_check_engine_margin")
        m_f64 = arm("dps90_f64pairwise_reim", "dps90_f64pairwise")
        m_ld = arm("dps120_ldexact_reim", "dps120_ldexact")
        if m_eng is None and (m_f64 is None or m_ld is None):
            raise SystemExit("day049f reference unreadable: %s" % fn)
        out.append({"pt": pt, "m_eng": m_eng, "m_f64": m_f64,
                    "m_ld": m_ld, "ref": fn})
    return out


def smoke_run(pts_all):
    refs = smoke_refs()
    done = load_done()
    fo = open(PTS, "a")
    if not done:
        fo.write("# day052c ledger-driven re-issue 696 fixed-engine "
                 "workers=%d %s\n" % (WORKERS,
                                      time.strftime("%Y-%m-%d %H:%M:%S")))
    results = []
    with cf.ProcessPoolExecutor(max_workers=WORKERS) as ex:
        futs = {}
        for i, s in enumerate(refs):
            key = (s["pt"]["k"], s["pt"]["x"])
            if key in done:
                results.append((i, done[key]))
            else:
                futs[ex.submit(do_point, s["pt"])] = i
        pend = list(futs)
        while pend:
            donef = [f for f in pend if f.done()]
            if not donef:
                time.sleep(20)
                continue
            for f in donef:
                i = futs[f]
                rec = f.result()
                pend.remove(f)
                with open(JSONL, "a") as jf:
                    jf.write(json.dumps(rec) + "\n")
                fo.write(rec["row"])
                fo.flush()
                results.append((i, rec))
    fo.close()
    all_ok = True
    detail = []
    pairs = sorted(results, key=lambda q: q[0])
    for i, (_i, rec) in enumerate(pairs):
        s = refs[i]
        m = rec["p"].get("mnew")
        rowfirst = rec["row"].splitlines()[0]
        rowok = rowfirst.startswith(("ok,", "FLAG,")) \
            and len(rowfirst.split(",")) == 21 and rec["p"]["flag"] == 0
        if s["m_eng"] is not None:
            d = m - s["m_eng"]
            okpt = rowok and abs(d) <= 1e-5
            detail.append({"i": i, "k": s["pt"]["k"], "x": s["pt"]["x"],
                           "mnew": m, "ref_engine": s["m_eng"],
                           "d": d, "tol": 1e-5, "rowok": rowok,
                           "ok": okpt})
        else:
            d90 = m - s["m_f64"]
            d120 = m - s["m_ld"]
            okpt = rowok and abs(d90) <= 1e-5 and abs(d120) <= 2e-5
            detail.append({"i": i, "k": s["pt"]["k"], "x": s["pt"]["x"],
                           "mnew": m, "ref_f64_90": s["m_f64"],
                           "ref_ld_120": s["m_ld"],
                           "d_f64": d90, "d_ld": d120,
                           "rowok": rowok, "ok": okpt})
        all_ok = all_ok and okpt
        print("SMOKE pt%02d k=%+3d x=%.4g mnew=%.9f %s"
              % (i, s["pt"]["k"], s["pt"]["x"], m,
                 "ok" if okpt else "FAIL " + json.dumps(detail[-1])),
              flush=True)
    with open(SMOKE_JSON, "w") as fh:
        json.dump({"ok": all_ok, "n": len(pairs), "detail": detail},
                  fh, indent=1)
    print("SMOKE %s" % ("PASS" if all_ok else "FAIL"), flush=True)
    return 0 if all_ok else 1


# ----------------------------------------------------------------------
def main():
    ok = D37.selftest_core()
    print("SELFTEST_CORE ok=%s" % ok, flush=True)
    assert ok, "selftest failed -- refuse to launch"
    pts, mism = load_ledger_points()
    xs, missing, extra = verify_point_set(pts)
    print("day052c: in-hand ledger points = %d  (nominal grid %d "
          "anchors x %d k = %d;  never-in-hand %d),  "
          "dup_tg_mismatches=%d, extra=%d"
          % (len(pts), len(xs), len(KLIST), len(xs) * len(KLIST),
             len(missing), len(mism), len(extra)), flush=True)
    for mk, x in missing[:40]:
        print("  never-in-hand k=%+d x=%.4g" % (mk, x), flush=True)
    if mism or extra:
        for m in mism[:10]:
            print("  MISMATCH (t,g) k=%+d x=%.4g: %s" % (m[0], m[1],
                                                          m[2:]), flush=True)
        for mk, x in extra[:10]:
            print("  EXTRA k=%+d x=%.4g" % (mk, x), flush=True)
        raise SystemExit("point set integrity failed -- not launching")
    jobs = sorted(pts.values(), key=lambda p: (p["x"], p["k"]))
    smoke = os.environ.get("H1V2C_SMOKE") == "1"
    if smoke:
        sys.exit(smoke_run(pts))
    done = load_done()
    todo = [j for j in jobs if (j["k"], j["x"]) not in done]
    print("day052c: %d points, done=%d, pending=%d, workers=%d"
          % (len(jobs), len(done), len(todo), WORKERS), flush=True)
    if not todo:
        print("nothing to do", flush=True)
        return
    t0 = time.time()
    fo = open(PTS, "a")
    fo.write("# day052c full run %s workers=%d\n"
             % (time.strftime("%Y-%m-%d %H:%M:%S"), WORKERS))
    fo.flush()
    n = 0
    with cf.ProcessPoolExecutor(max_workers=WORKERS) as ex:
        futs = {ex.submit(do_point, j): j for j in todo}
        pend = list(futs)
        while pend:
            donef = [f for f in pend if f.done()]
            if not donef:
                time.sleep(30)
                continue
            for f in donef:
                j = futs[f]
                rec = f.result()
                pend.remove(f)
                n += 1
                with open(JSONL, "a") as jf:
                    jf.write(json.dumps(rec) + "\n")
                fo.write(rec["row"])
                fo.flush()
                if n % 12 == 0 or n == len(todo):
                    print("PROGRESS %d/%d points (%.1f h elapsed, "
                          "avg %.1f min/point)"
                          % (n, len(todo), (time.time() - t0) / 3600.0,
                             n and (time.time() - t0) / 60.0 / n),
                          flush=True)
    fo.close()
    print("day052c DONE: %d points in %.1f h"
          % (n, (time.time() - t0) / 3600.0), flush=True)


if __name__ == "__main__":
    main()
