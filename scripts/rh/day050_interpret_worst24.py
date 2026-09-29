"""day050: interpret the day049f worst-24 re-issue.

Reads scripts/rh/out_day049f_pts/pt*.res (day048-family JSON;
accepts BOTH key conventions: day049f "dpsNNN_ldexact" and
day048 "dpsNNN_ldexact_reim"), prints the true
certificate-grade margin map of the worst negative-k
straddles: per-point table (k, x, screen mnew, re-issued
mnew at dps-120 ld-exact, mcert, residf, |K|/|z|), the
precision deltas (dps-90 vs dps-120, f64-pairwise vs
ld-exact), a linear fit of the margin over (x, k) with the
variance share of each term (x scaled by 1e9 for numerical
condition), and the shape summary (min/max/spread, count
below the certificate line m = 1) plus the comparison
against day048 worst-10 on the shared points.

Post-processing only: no band reads, no heavy compute.
"""
import glob
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PTS = HERE + "/out_day049f_pts"
D48 = HERE + "/out_day048_pts"


def arm(d, dps, kind):
    """Fetch an arm dict, trying both key conventions."""
    for key in ("dps%d_%s" % (dps, kind), "dps%d_%s_reim" % (dps, kind)):
        if key in d:
            return d[key]
    return None


rows = []
for f in sorted(glob.glob(PTS + "/pt*.res")):
    d = json.load(open(f))
    p = d["point"]
    v = arm(d, 120, "ldexact") or arm(d, 90, "ldexact")
    if v is None:
        continue
    v90 = arm(d, 90, "ldexact")
    v120f = arm(d, 120, "f64pairwise")
    v90f = arm(d, 90, "f64pairwise")
    zabs = p.get("zabs")
    if zabs is None:
        zabs = v.get("zabs")
    rows.append({
        "x": p["x"], "k": p["k"], "t": p["t"],
        "screen_mnew": p["mnew"],
        "mnew": v["mnew"], "mcert": v.get("mcert"),
        "residf": v["residf"], "Kabs": v["Kfull_abs"],
        "zabs": zabs,
        "d_dps": abs(v90["mnew"] - v["mnew"]) if v90 else None,
        "d_prec": abs(v120f["mnew"] - v["mnew"]) if v120f else None,
        "file": os.path.basename(f),
    })

if not rows:
    print("no .res files under", PTS)
    sys.exit(1)

print("== day049f worst-24 re-issue: true margin map (%d points) =="
      % len(rows))
print("%-4s %16s %10s %11s %8s %9s %8s"
      % ("k", "x", "reissued_m", "mcert", "residf", "|K|/|z|", "screen_m"))
for r in sorted(rows, key=lambda r: (r["x"], -r["k"])):
    kr = (r["Kabs"] / r["zabs"]) if (r["Kabs"] and r["zabs"]) else float("nan")
    print("%+4d %16.2f %.9f %s %9.4f %8.4f %.9f"
          % (r["k"], r["x"], r["mnew"],
             ("%.6f" % r["mcert"]) if r["mcert"] else "  -",
             r["residf"], kr, r["screen_mnew"]))

ms = [r["mnew"] for r in rows]
xs1 = [r["x"] / 1e9 for r in rows]   # x scaled by 1e9 (range ~3.2-5.1)
ks = [r["k"] for r in rows]
n = len(ms)

print("== shape ==")
print("spread  : min=%.6f  max=%.6f  range=%.6f"
      % (min(ms), max(ms), max(ms) - min(ms)))
print("below-1 : %d / %d re-issued margins are < 1 (certificate line)"
      % (sum(1 for m in ms if m < 1.0), n))
dd = [r["d_dps"] for r in rows if r["d_dps"] is not None]
dp = [r["d_prec"] for r in rows if r["d_prec"] is not None]
if dd:
    print("precision: max |dps90-120| = %.3e" % max(dd))
if dp:
    print("precision: max |f64pairwise-ldexact| = %.3e" % max(dp))


def det3(A):
    return (A[0][0] * (A[1][1] * A[2][2] - A[1][2] * A[2][1])
            - A[0][1] * (A[1][0] * A[2][2] - A[1][2] * A[2][0])
            + A[0][2] * (A[1][0] * A[2][1] - A[1][1] * A[2][0]))


if n >= 2:
    print("== fit (x in units of 1e9) ==")
    for name, vec in (("x1e9", xs1), ("k", ks)):
        sv = sum(vec); sm = sum(ms)
        if n < 2 or sum((v - sv / n) ** 2 for v in vec) == 0:
            continue
        b1 = (n * sum(v * m for v, m in zip(vec, ms)) - sv * sm) / \
            (n * sum(v * v for v in vec) - sv * sv)
        a1 = (sm - b1 * sv) / n
        ss_tot = sum((m - sm / n) ** 2 for m in ms)
        ss1 = sum((m - (a1 + b1 * v)) ** 2 for m, v in zip(ms, vec))
        print("fit %-4s: a=%+.6f  b=%+.6f per unit  var_share=%.4f"
              % (name, a1, b1, (ss_tot - ss1) / ss_tot if ss_tot else 0))
    if n >= 3:
        Sm = sum(ms); S1 = sum(xs1); Sk = sum(ks)
        M = [[n, S1, Sk],
             [S1, sum(v * v for v in xs1), sum(a * b for a, b in zip(xs1, ks))],
             [Sk, sum(a * b for a, b in zip(xs1, ks)), sum(k * k for k in ks)]]
        bh = [Sm, sum(a * m for a, m in zip(xs1, ms)),
              sum(k * m for k, m in zip(ks, ms))]
        D = det3(M)
        a = det3([[bh[0], M[0][1], M[0][2]], [bh[1], M[1][1], M[1][2]],
                  [bh[2], M[2][1], M[2][2]]]) / D
        b = det3([[M[0][0], bh[0], M[0][2]], [M[1][0], bh[1], M[1][2]],
                  [M[2][0], bh[2], M[2][2]]]) / D
        c = det3([[M[0][0], M[0][1], bh[0]], [M[1][0], M[1][1], bh[1]],
                  [M[2][0], M[2][1], bh[2]]]) / D
        ss_tot = sum((m - Sm / n) ** 2 for m in ms)
        ss_res = sum((m - (a + b * x1 + c * k)) ** 2
                     for x1, k, m in zip(xs1, ks, ms))
        print("fit x1e9+k : a=%+.6f  b_x1e9=%+.6f  b_k=%+.6f  var_share=%.4f"
              % (a, b, c, (ss_tot - ss_res) / ss_tot if ss_tot else 0))

shared = []
for f in sorted(glob.glob(D48 + "/pt*.res")):
    d = json.load(open(f))
    p = d["point"]
    v = arm(d, 120, "ldexact") or arm(d, 90, "ldexact")
    shared.append((p["x"], p["k"], v["mnew"] if v else None,
                   os.path.basename(f)))
print("== cross-check vs day048 worst-10 (%d shared expected) =="
      % len(shared))
for sx, sk, sm, sf in shared:
    hit = [r for r in rows if abs(r["x"] - sx) < 1e-3 and r["k"] == sk]
    if hit:
        tag = ("%.9f (d %+.2e)" % (hit[0]["mnew"], hit[0]["mnew"] - sm)
               if sm is not None else "no d48 value")
    else:
        tag = "pending"
    print("  %-28s d48=%s   049f: %s" % (sf, sm, tag))

print("DONE")
