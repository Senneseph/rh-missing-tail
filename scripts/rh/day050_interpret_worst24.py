"""day050: interpret the day049f worst-24 re-issue.

Reads scripts/rh/out_day049f_pts/pt*.res (day048-format JSON),
prints the true certificate-grade margin map of the worst
negative-k straddles: per-point table (anchor x, k, screen
mnew, re-issued mnew at dps-120 ld-exact, residf, |K|), the
precision deltas (dps-90 vs dps-120, f64-pairwise vs
ld-exact), a linear fit of the margin over (x, k) with the
variance share of the leading term, and the shape summary
(min/max/spread of the re-issued margins, count of re-issued
margins below the certificate line m = 1, and comparison
against the day048 worst-10 values on the shared points).

Post-processing only: no band reads, no heavy compute.
"""
import glob
import json
import math
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PTS = HERE + "/out_day049f_pts"
D48 = HERE + "/out_day048_pts"

rows = []
for f in sorted(glob.glob(PTS + "/pt*.res")):
    d = json.load(open(f))
    p = d["point"]
    v = d.get("dps120_ldexact_reim") or d.get("dps90_ldexact_reim")
    v90 = d.get("dps90_ldexact_reim", {})
    v90f = d.get("dps90_f64pairwise_reim", {})
    v120f = d.get("dps120_f64pairwise_reim", {})
    rows.append({
        "x": p["x"], "k": p["k"], "t": p["t"],
        "screen_mnew": p["mnew"],
        "mnew": v["mnew"], "residf": v["residf"],
        "Kabs": v["Kfull_abs"], "zabs": v["zabs"],
        "d_dps": abs(v90.get("mnew", 0) - v["mnew"]),
        "d_prec": abs(v120f.get("mnew", 0) - v["mnew"]),
        "file": os.path.basename(f),
    })

if not rows:
    print("no .res files under", PTS)
    sys.exit(1)

print("== day049f worst-24 re-issue: true margin map (%d points) =="
      % len(rows))
print("%-4s %16s %12s %12s %10s %10s"
      % ("k", "x", "screen_mnew", "reissued_mnew", "residf", "|K|"))
for r in sorted(rows, key=lambda r: (r["x"], -r["k"])):
    print("%+4d %16.6f %.10f %.10f %10.4f %10.4f"
          % (r["k"], r["x"], r["screen_mnew"], r["mnew"],
             r["residf"], r["Kabs"]))

ms = [r["mnew"] for r in rows]
xs = [r["x"] for r in rows]
ks = [r["k"] for r in rows]

# least squares: m = a + b*x + c*k
n = len(ms)
Sx = sum(xs); Sk = sum(ks); Sm = sum(ms)
Sxx = sum(x * x for x in xs); Skk = sum(k * k for k in ks); Sxk = sum(x * k for x, k in zip(xs, ks))
Sxm = sum(x * m for x, m in zip(xs, ms)); Skm = sum(k * m for k, m in zip(ks, ms))
# normal equations (3x3), Cramer
def det3(A):
    return (A[0][0] * (A[1][1] * A[2][2] - A[1][2] * A[2][1])
            - A[0][1] * (A[1][0] * A[2][2] - A[1][2] * A[2][0])
            + A[0][2] * (A[1][0] * A[2][1] - A[1][1] * A[2][0]))
M = [[n, Sx, Sk], [Sx, Sxx, Sxk], [Sk, Sxk, Skk]]
bvec = [Sm, Sxm, Skm]
D = det3(M)
a = det3([bvec[0], M[0][1], M[0][2]], [bvec[1], M[1][1], M[1][2]],
         [bvec[2], M[2][1], M[2][2]]) / D
b = det3([[M[0][0], bvec[0], M[0][2]], [M[1][0], bvec[1], M[1][2]],
          [M[2][0], bvec[2], M[2][2]]]) / D
c = det3([[M[0][0], M[0][1], bvec[0]], [M[1][0], M[1][1], bvec[1]],
          [M[2][0], M[2][1], bvec[2]]]) / D

ss_tot = sum((m - Sm / n) ** 2 for m in ms)
pred = [a + b * x + c * k for x, k in zip(xs, ks)]
ss_res = sum((m - p) ** 2 for m, p in zip(ms, pred))
ss_full = ss_tot - ss_res
# single-term fits
for name, vec in (("x", xs), ("k", ks)):
    mvec = ms
    sv = sum(vec); sm = sum(mvec)
    b1 = (n * sum(v * m for v, m in zip(vec, mvec)) - sv * sm) / \
        (n * sum(v * v for v in vec) - sv * sv)
    a1 = (sm - b1 * sv) / n
    ss1 = sum((m - (a1 + b1 * v)) ** 2 for m, v in zip(mvec, vec))
    print("fit %-3s: a=%+.6g b=%+.6g  R2_var_share=%.4f"
          % (name, a1, b1, (ss_tot - ss1) / ss_tot if ss_tot else 0))
print("fit x+k : a=%+.6g b_x=%+.6g b_k=%+.6g  R2_var_share=%.4f"
      % (a, b, c, ss_full / ss_tot if ss_tot else 0))
print("spread  : min=%.6f  max=%.6f  range=%.6f"
      % (min(ms), max(ms), max(ms) - min(ms)))
print("below-1 : %d / %d re-issued margins are < 1 (certificate line)"
      % (sum(1 for m in ms if m < 1.0), n))
print("precision: max |dps90-120| = %.3e | max |f64-lde| = %.3e"
      % (max(r["d_dps"] for r in rows),
         max(r["d_prec"] for r in rows)))

# compare against day048's worst-10 on shared points
shared = []
for f in sorted(glob.glob(D48 + "/pt*.res")):
    d = json.load(open(f))
    p = d["point"]
    v = d.get("dps120_ldexact_reim", {})
    shared.append((round(p["x"], 4), p["k"],
                   v.get("mnew"), os.path.basename(f)))
print("== cross-check vs day048 worst-10 (%d shared) ==" % len(shared))
for sx, sk, sm, sf in shared:
    hit = [r for r in rows if abs(r["x"] - sx) < 1e-3 and r["k"] == sk]
    tag = "NEW"
    if hit:
        tag = "%.6f (d %+.2e)" % (hit[0]["mnew"], hit[0]["mnew"] - sm) \
            if sm is not None else "NEW-in-409f"
    print("  %-24s k=%+3d  d48=%s  d49f: %s" % (sf, sk, sm, tag))

print("DONE")
