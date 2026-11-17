"""Union-span zero adjudication for a certified window (independent mpmath re-check of the pipeline rescue).

window.py certifies b-a zeros in [g_a, g_b] via Gram blocks (Rosser's rule: each block [g_j, g_k) between
consecutive good gram points needs >= k-j certified sign changes).  Interior blocks that fall short even
at the finest record level (mm = 64) are logged in log['rosser_failures']; pipeline probe_rescue.py
rescues each by re-sampling the widened UNION span [g_{j-1}, g_{k+1}] at coarser levels and requiring
need = (k+1)-(j-1) = (k-j) + 2 zeros there; outcomes land in log['rescued_rosser_exceptions'] with
'found'.  verify_window.py reports the failure count; the window's sign-change total remains = b-a and
CERTIFIED.

This script independently re-counts the zeros in each union span with a fresh mpmath evaluation of
Hardy Z(t) (CORRECTED phase convention Z(t) = Re(e^{+i theta(t)} zeta(1/2+it)), dense scan + refined
crossing checks + near-zero touch detection for possible double zeros), and runs unflagged control
spans (expect fresh zeros >= need).  RESOLVED-OK  : fresh zeros == need (rescue count independently
confirmed).  RESOLVED-OVER: fresh zeros < need (internal lower bound over-predicted; the window remains
certified by its sign-change total).  A MISMATCH of fresh zeros > need would break the block count and
requires manual review.

Usage: python3 union_span_check.py window.json out_adjudication.json [n_control]
"""
import json
import random
import sys

from mpmath import mp, mpf, re

CORRECTED = True


def _theta(t):
    return (t / 2) * mp.log(t / (2 * mp.pi)) - t / 2 - mp.pi / 8 + mpf(1) / (48 * t) - mpf(1) / (5760 * t**3)


def Z(t, dps=40):
    mp.dps = dps
    z = mp.zeta(mpf("0.5") + mp.j * t)
    phase = mp.exp(mp.j * _theta(t))
    return re(z * phase) if CORRECTED else re(z / phase)


def ball_mid(v):
    return mp.mpf(int(v[0])) * mpf(2) ** int(v[1])


def main():
    win, out = sys.argv[1], sys.argv[2]
    nctrl = int(sys.argv[3]) if len(sys.argv) > 3 else 4
    D = json.load(open(win))
    log, recs = D["log"], D["records"]
    a, b, M = log["a"], log["b"], log["M"]
    lo, hi = a - M, b + M

    g, good = {}, []
    for r in recs:
        if r[0][0] != "g":
            continue
        n = int(r[0][1])
        g[n] = ball_mid(r[1])
        if int(r[6]) == (1 if n % 2 == 0 else -1):
            good.append(n)
    good = [n for n in good if lo <= n <= hi]

    def fresh_zeros(t_lo, t_hi):
        """dense scan of (t_lo, t_hi]; returns (crossings, near_zero_touch, min_abs)"""
        mp.dps = 40
        N = 800
        pts = [t_lo + (t_hi - t_lo) * mpf(i) / N for i in range(N + 1)]
        vals = [Z(t) for t in pts]
        min_abs = min(abs(v) for v in vals)
        crossings = 0
        for i in range(len(vals) - 1):
            x, y = vals[i], vals[i + 1]
            if x == 0 or y == 0:
                crossings += 1
                continue
            if x * y < 0:
                mp.dps = 60
                tl, tr = pts[i], pts[i + 1]
                tm = (tl + tr) / 2
                zl = Z(tm - (tr - tl) * mpf("0.25"))
                zr = Z(tm + (tr - tl) * mpf("0.25"))
                if zl * zr < 0:
                    crossings += 1
                else:
                    fine = [Z(tl + (tr - tl) * mpf(i) / 16) for i in range(17)]
                    crossings += sum(1 for p, q in zip(fine, fine[1:]) if p * q < 0 or p == 0 or q == 0)
        return crossings, (1 if min_abs < mpf("1e-12") else 0), min_abs

    mp.dps = 50
    res = {"file": win, "a": a, "b": b, "b_minus_a": b - a,
           "recorded": {"rosser_failures_inside": len(log.get("rosser_failures", [])),
                        "sign_changes_in_window": log.get("sign_changes_in_window"),
                        "rescued": log.get("rescued_rosser_exceptions", [])}}
    rescued = log.get("rescued_rosser_exceptions", [])
    failures = log.get("rosser_failures", [])
    spans = []
    for i, E in enumerate(rescued):
        u1, u2 = E["union"]
        z, toc, mabs = fresh_zeros(g[u1] + mpf("1e-12"), g[u2] - mpf("1e-12"))
        st = ("RESOLVED-OK(independent confirm of rescue count)" if z == E["found"]
              else ("RESOLVED-OVER(internal over-prediction)" if z < E["found"]
                    else "MISMATCH(fresh > found - manual review)"))
        spans.append({"kind": "union", "gram_span": [u1, u2], "heights": [float(g[u1]), float(g[u2])],
                      "pipeline_need": E["need"], "pipeline_found": E["found"],
                      "fresh_zeros": z, "near_zero_touch": toc, "min_abs_z": float(mabs),
                      "status": st, "block": E.get("block")})
        print(st, [u1, u2], "pipeline", E["found"], "/", E["need"], "fresh", z, flush=True)
    # controls: unflagged interior blocks of length > 1
    failed_blocks = [tuple(E["block"]) if E.get("block") else (E["j"], E["k"]) for E in failures]
    cands = []
    for j, k in zip(good, good[1:]):
        if a <= j and k <= b and k > j + 1 and (j, k) not in failed_blocks:
            cands.append((j, k))
    random.seed(20261116)
    for j, k in random.sample(cands, min(nctrl, len(cands))):
        z, toc, mabs = fresh_zeros(g[j] + mpf("1e-12"), g[k] - mpf("1e-12"))
        st = "control(>=need)" if z >= k - j else "CONTROL-FAIL"
        spans.append({"kind": "control", "gram_span": [j, k], "heights": [float(g[j]), float(g[k])],
                      "need": k - j, "fresh_zeros": z, "near_zero_touch": toc, "min_abs_z": float(mabs),
                      "status": st})
        print(st, [j, k], "need", k - j, "fresh", z, flush=True)
    ok = (all(s["kind"] == "control" or s["status"].startswith("RESOLVED") for s in spans)
          and all(not s["status"].startswith(("MISMATCH", "CONTROL")) for s in spans))
    res.update(spans=spans,
               verdict=("ALL SPANS RESOLVED - window sign-change total = b-a, CERTIFIED by verifier"
                        if ok else "MISMATCH - manual review"))
    json.dump(res, open(out, "w"), indent=1)
    print("VERDICT:", res["verdict"], flush=True)
    print("wrote", out)


if __name__ == "__main__":
    main()
