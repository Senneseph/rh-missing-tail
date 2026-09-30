"""day055: band-free dps-30/90/120 fast-arm precision layer for the
day052c re-issue.

After the re-issue lands, every point in
out_day052c_696/points.jsonl carries the engine's own f64 tail
totals (re, im, nlt) + prod (la, ar) + pb.  The remaining
numerical question per point is FAST-ARM PRECISION:  does the
margin move when the mpmath pieces (zeta, logmain, quad
sections, dev) are recomputed at dps-90/120 instead of the
engine's dps-30?  (The tail's f64 error is already budgeted by
the engine and is common to all arms.)  The day049f worst-24
showed dps-90 vs dps-120 agreement at 0.00e00;  this pass puts
that stability number on all 505 points,  band-free
(~3 min/point of mpmath,  ~2 h at 14 workers).

Per point it reports:
  m30   = the re-issue's own arm  (must match the recorded
          mnew to ~1e-13:  a regression gate on the re-issue
          --  measured 0.00e00 on the first test point)
  m90, m120  = the same construction at higher dps
  d30  = |m30 - recorded mnew|
  d90  = |m90 - m30|,  d120 = |m120 - m30|   (informational:
          the known dps-30 arm noise level is ~2e-9 on the
          worst-24;  see the stable criterion below)
  stable = d30 <= 1e-11 and |m90 - m120| <= 1e-10
          (the re-issue arm reproduces exactly AND the margin
          is insensitive to fast-arm precision at dps >= 90)

Launch (AFTER the re-issue,  or any time --  resume-safe,
read-only over the JSONL):
  taskset -c 0-13 nohup /home/jsmille/venvs/smud/bin/python \
    day055_precision_layer.py > out_day055.log 2>&1 &
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day037_h1_3e10 as D37          # noqa: E402
from mpmath import mp                 # noqa: E402

JSONL = HERE + "/out_day052c_696/points.jsonl"
OUT = HERE + "/out_day052c_696/precision_layer.jsonl"
WORKERS = min(int(os.environ.get("WORKERS", "14")), 14)
_GLC = [None]


def _gl():
    """the file-anchored G_LAST (last stored zero) -- reads only the
    file's first and last 8 bytes,  no Tail3E10,  no band I/O."""
    if _GLC[0] is None:
        _GLC[0] = repr(float(D37._first_last(D37.D_F)[1]))
    return _GLC[0]


def margin_arm(dps, t, g, re, im, la, ar, pb, nlt):
    """margin_new at dps with the STORED f64 tail re/im (common to
    all arms,  nlt*pi already inside the engine's final im) and
    the dps-level mpmath fast parts."""
    mp.dps = dps
    s = mp.mpc(0.5, mp.mpf(repr(t)))
    z = mp.zeta(s)
    lm = D37.logmain25212(s)
    qrem = D37.quad_section(D37._kint(s), _gl(), D37.REMHI, 400, dps)
    qext = D37.quad_section(D37._kint(s), D37.REMHI, D37.REMHI2,
                            400, dps)
    dev = D37.dev_parts(t, g, dps)
    Kfull = (mp.e ** (lm + mp.mpf(repr(la)) + 1j * mp.mpf(repr(ar))
                    + mp.mpf(repr(re)) + 1j * mp.mpf(repr(im)))
             * mp.e ** qrem * mp.e ** qext)
    residf = abs(z - Kfull)
    zabs = abs(z)
    return float(zabs * dev / (mp.mpf(repr(pb)) + residf))


def do_point(rec):
    x, k = rec["x"], rec["k"]
    t, g = rec["t"], rec["g"]
    p = rec["p"]
    m30 = margin_arm(30, t, g, p["re"], p["im"], p["la"], p["ar"],
                     p["pb"], p["nlt"])
    m90 = margin_arm(90, t, g, p["re"], p["im"], p["la"], p["ar"],
                     p["pb"], p["nlt"])
    m120 = margin_arm(120, t, g, p["re"], p["im"], p["la"], p["ar"],
                      p["pb"], p["nlt"])
    rec_mnew = float(p["mnew"]) if "mnew" in p else None
    d30 = abs(m30 - rec_mnew) if rec_mnew is not None else None
    out = {"x": x, "k": k, "t": t, "g": g,
           "recorded_mnew": rec_mnew,
           "m30": m30, "m90": m90, "m120": m120,
           "d30": d30,
           "d90": abs(m90 - m30), "d120": abs(m120 - m30),
           "stable": bool(d30 is not None and d30 <= 1e-11
                          and abs(m90 - m120) <= 1e-10)}
    return out


def main():
    recs = []
    if os.path.exists(JSONL):
        with open(JSONL) as fh:
            for ln in fh:
                recs.append(json.loads(ln))
    done = set()
    if os.path.exists(OUT):
        with open(OUT) as fh:
            for ln in fh:
                r = json.loads(ln)
                done.add((r["x"], r["k"]))
    todo = [r for r in recs
            if (r["x"], r["k"]) not in done
            and all(kk in r["p"] for kk in
                    ("re", "im", "la", "ar", "pb", "nlt"))]
    print("day055: %d re-issue points, %d done, %d to do, "
          "workers=%d" % (len(recs), len(done), len(todo), WORKERS),
          flush=True)
    if not todo:
        print("nothing to do", flush=True)
        return
    t0 = time.time()
    n = 0
    okc = 0
    import multiprocessing as pmp
    with pmp.Pool(WORKERS) as pool:
        for out in pool.imap_unordered(
                do_point, [r for r in todo]):
            n += 1
            okc += 1 if out["stable"] else 0
            with open(OUT, "a") as fh:
                fh.write(json.dumps(out) + "\n")
            if n % 24 == 0 or n == len(todo):
                print("  %d/%d  stable %d/%d  (%.1f min elapsed, "
                      "last: d30=%.1e d90=%.1e d120=%.1e)"
                      % (n, len(todo), okc, n,
                         (time.time() - t0) / 60.0,
                         out["d30"] or 0.0, out["d90"], out["d120"]),
                      flush=True)
    print("day055 DONE: %d points, stable %d/%d, in %.1f min"
          % (n, okc, n, (time.time() - t0) / 60.0), flush=True)


if __name__ == "__main__":
    main()
