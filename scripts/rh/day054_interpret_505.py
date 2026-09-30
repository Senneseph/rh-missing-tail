"""day054: interpretation of the day052c re-issue (the 505 in-hand
3e10 H1 points re-evaluated with the fixed engine).

Run it as points land (idempotent,  read-only,  no side effects):

  /home/jsmille/venvs/smud/bin/python day054_interpret_505.py

It reads
  out_day052c_696/points.jsonl        (the re-issue,  point-granular)
and the three in-hand artifact ledger sources (read-only):
  ckpt_h1_3e10/widx*.pts
  h1_final_fleet/5900x/ckpt/widx*.pts
  h1_final_fleet/4090-box/out_day038_full_pts.txt
and writes out_day052c_696/interpret.md + interpret_summary.json.

Outputs:
  1.  census:  per anchor (29)  the mnew/mcert min-max,  the
      certificate-line census (mcert < 1),  flags.
  2.  global:  min/max/median mnew and mcert,  the full
      mcert >= 1 list (expected:  none),  flag list.
  3.  artifact delta:  per-point mnew(reissue) - mnew(artifact),
      distribution summary + the top 10 movers by |delta|.
  4.  geometry fit:  mnew ~ a + b*(x/1e9) + c*k  over all points
      (the day050 fit,  now at full in-hand scale),  plus the
      per-anchor mean-mnew table (smoothness check).
  5.  worst/best 10 tables.
"""
import json
import glob
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import h1merge_ingest as M          # noqa: E402

JSONL = HERE + "/out_day052c_696/points.jsonl"
OUT_MD = HERE + "/out_day052c_696/interpret.md"
OUT_J = HERE + "/out_day052c_696/interpret_summary.json"
KLIST = [k for k in range(-12, 13) if k != 0]


def load_reissue():
    recs = []
    with open(JSONL) as fh:
        for ln in fh:
            r = json.loads(ln)
            recs.append(r)
    return recs


def load_artifact():
    rows = {}
    widxes = (glob.glob(HERE + "/ckpt_h1_3e10/widx*.pts")
              + glob.glob(HERE + "/h1_final_fleet/5900x/ckpt/widx*.pts"))
    for pth in widxes:
        rr, _d, _c = M.parse_pts(pth)
        for _k, raw in rr:
            fp = raw.split(",")
            if len(fp) < 9:
                continue
            k = M._k_of_row(fp)
            if k in KLIST:
                rows[(k, float(fp[1]))] = float(fp[4])
    with open(HERE + "/h1_final_fleet/4090-box/out_day038_full_pts.txt"
              ) as fh:
        for ln in fh.read().split("\n"):
            if not ln.startswith("ok,"):
                continue
            fp = ln.split(",")
            k = M._k_of_row(fp)
            if k in KLIST:
                rows[(k, float(fp[1]))] = float(fp[4])
    return rows


def fit_m(rowlist, xs, ks):
    m = np.array(rowlist)
    X = np.column_stack([np.ones_like(m), xs, ks])
    beta, res, *_ = np.linalg.lstsq(X, m, rcond=None)
    r2 = 1.0 - float(((m - X @ beta) ** 2).sum()) / float(((m - m.mean()) ** 2).sum())
    return list(beta), r2


def _val(r, key):
    """p-dict value with fallback to the 21-column row (the row is
    the authoritative record;  early records predate a p_safe fix
    that kept the mpmath-typed mcert in the dict)."""
    if key in r["p"]:  # noqa: E122
        return float(r["p"][key])
    fp = r["row"].splitlines()[0].split(",")
    idx = {"mnew": 4, "mcert": 5, "residf": 6, "dev": 8}
    return float(fp[idx[key]])


def main():
    recs = load_reissue()
    n = len(recs)
    print("interpret: %d re-issue points on hand (of 505)" % n, flush=True)
    if n == 0:
        return
    artifacts = load_artifact()
    xs = np.array([r["x"] for r in recs])
    ks = np.array([r["k"] for r in recs])
    mnew = np.array([_val(r, "mnew") for r in recs])
    mcert = np.array([_val(r, "mcert") for r in recs])
    flags = [r["p"]["flag"] for r in recs]

    # 1+2 census
    anchors = sorted(set(xs))
    census = {}
    for a in anchors:
        sel = xs == a
        census[("%.10f" % a)] = {
            "k_present": int(sel.sum()),
            "mnew_min": float(mnew[sel].min()),
            "mnew_max": float(mnew[sel].max()),
            "mcert_min": float(mcert[sel].min()),
            "mcert_below_1": int((mcert[sel] < 1.0).sum()),
        }
    below1 = int((mcert < 1.0).sum())
    above1 = [[r["x"], r["k"], _val(r, "mnew"), _val(r, "mcert")]
              for r in recs if _val(r, "mcert") >= 1.0]
    flagged = [(r["x"], r["k"], r["row"].splitlines()[0]) for r in recs
               if r["p"]["flag"]]

    # 3 artifact delta
    deltas = []
    for r in recs:
        key = (r["k"], r["x"])
        if key in artifacts:
            deltas.append((r["x"], r["k"], _val(r, "mnew"),
                           artifacts[key], _val(r, "mnew") - artifacts[key]))
    dd = np.array([d[4] for d in deltas]) if deltas else np.array([0.0])

    # 4 fit
    beta, r2 = fit_m(mnew, xs / 1e9, ks)

    # 5 worst/best by mnew
    order = np.argsort(mnew)
    worst = [(recs[i]["x"], recs[i]["k"], mnew[i], mcert[i])
             for i in order[:10]]
    best = [(recs[i]["x"], recs[i]["k"], mnew[i], mcert[i])
            for i in order[-10:][::-1]]

    # md
    L = []
    L.append("# day052c re-issue interpretation  (%d of 505 points)\n" % n)
    L.append("## 1. Census")
    L.append("| anchor x | k present | mnew min | mnew max | mcert min | mcert < 1 |")
    L.append("|---|---|---|---|---|---|")
    for a, c in census.items():
        L.append("| %s | %d | %.6f | %.6f | %.6f | %d/%d |" % (
            a, c["k_present"], c["mnew_min"], c["mnew_max"],
            c["mcert_min"], c["mcert_below_1"], c["k_present"]))
    L.append("\n**certificate line:**  %d/%d points with mcert < 1;  "
             "%d with mcert >= 1;  %d flagged."
             % (below1, n, len(above1), len(flagged)))
    if above1:
        L.append("\nmcert >= 1 list:")
        for x, k, mn, mc in above1:
            L.append("  x=%.10f k=%+d mnew=%.9f mcert=%.9f" % (x, k, mn, mc))
    if flagged:
        L.append("\nflagged rows:")
        for x, k, row in flagged:
            L.append("  x=%.10f k=%+d  %s" % (x, k, row))
    L.append("\n## 2. Global")
    L.append("mnew:  min %.9f  median %.9f  max %.9f"
             % (mnew.min(), float(np.median(mnew)), mnew.max()))
    L.append("mcert: min %.9f  median %.9f  max %.9f"
             % (mcert.min(), float(np.median(mcert)), mcert.max()))
    L.append("\n## 3. Artifact delta (reissue - artifact)")
    L.append("n matched = %d;  delta min %.3e  max %.3e  "
             "mean %.3e  median %.3e"
             % (len(dd), dd.min(), dd.max(),
                float(dd.mean()) if len(dd) else 0.0,
                float(np.median(dd)) if len(dd) else 0.0))
    if len(dd):
        movers = sorted(deltas, key=lambda q: -abs(q[4]))[:10]
        L.append("\ntop movers by |delta|:")
        L.append("| x | k | mnew(re) | mnew(art) | delta |")
        L.append("|---|---|---|---|---|")
        for x, k, mn, ma, dl in movers:
            L.append("| %.9f | %+d | %.9f | %.9f | %+.3e |"
                     % (x, k, mn, ma, dl))
    L.append("\n## 4. Geometry fit (all points)")
    L.append("mnew = %.6f + %.6f*(x/1e9) + %.3e*k   (R^2 = %.4f)"
             % (beta[0], beta[1], beta[2], r2))
    L.append("\nper-anchor mean mnew (smoothness):")
    for a in anchors:
        s = mnew[xs == a]
        L.append("  x=%.9f  mean %.6f  (n=%d)" % (a, s.mean(), s.size))
    L.append("\n## 5. Worst 10 (smallest mnew)")
    L.append("| x | k | mnew | mcert |")
    L.append("|---|---|---|---|")
    for x, k, mn, mc in worst:
        L.append("| %.9f | %+d | %.9f | %.9f |" % (x, k, mn, mc))
    L.append("\n## 6. Best 10 (largest mnew)")
    L.append("| x | k | mnew | mcert |")
    L.append("|---|---|---|---|")
    for x, k, mn, mc in best:
        L.append("| %.9f | %+d | %.9f | %.9f |" % (x, k, mn, mc))
    txt = "\n".join(L)
    with open(OUT_MD, "w") as fh:
        fh.write(txt + "\n")
    with open(OUT_J, "w") as fh:
        json.dump({"n": n, "census": census,
                   "mcert_below_1": below1,
                   "mcert_ge_1": above1, "flagged": flagged,
                   "fit": {"beta": beta, "r2": r2},
                   "delta_n": len(dd),
                   "delta_min": float(dd.min()), "delta_max": float(dd.max())},
                  fh, indent=1)
    print(txt, flush=True)


if __name__ == "__main__":
    main()
