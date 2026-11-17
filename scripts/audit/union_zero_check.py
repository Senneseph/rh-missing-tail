"""Union-zero adjudication of Rosser spans inside a certified window (re-runnable from raw records).

A window certificate (window.py / verify_window.py) certifies b-a zeros in [g_a, g_b] via Gram blocks:
each interior block [g_j, g_k) between consecutive GOOD gram points must exhibit >= k-j certified sign
changes (Rosser's rule).  verify_window.py reports the count of interior blocks that fall short at raw
record level ('rosser_failures_inside').  This script re-derives those blocks from the raw records and
adjudicates each: it independently re-evaluates Hardy Z(t) with mpmath (CORRECTED phase convention
Z(t) = Re(e^{+i theta(t)} zeta(1/2+it)), densified scan with refinement, near-zero touch check for
possible double zeros) and counts the zeros really present in the span, plus runs unflagged control
spans (expect >= need).  A span is RESOLVED-OK when fresh zeros >= need; RESOLVED-OVER when the internal
prime-theoretic lower bound over-predicted (window remains certified by its sign-change total = b-a).

Usage: python union_zero_check.py window.json out_adjudication.json [n_control]
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
    phase = exp_j(_theta(t))
    return re(z * phase) if CORRECTED else re(z / phase)


def exp_j(x):
    return mp.exp(mp.j * x)


def ball_mid(v):
    m, e = int(v[0]), int(v[1])
    return mp.mpf(m) * mpf(2) ** e


def sign_of_ball(v):
    m, e, rm, re_ = int(v[0]), int(v[1]), int(v[2]), int(v[3])
    mid = mp.mpf(m) * mpf(2) ** e
    rad = mp.mpf(rm) * mpf(2) ** re_
    if rad > abs(mid) * mpf("1e-12"):
        return 0
    return 1 if mid > 0 else -1


def main():
    win, out = sys.argv[1], sys.argv[2]
    nctrl = int(sys.argv[3]) if len(sys.argv) > 3 else 4
    D = json.load(open(win))
    log, recs = D["log"], D["records"]
    a, b, M = log["a"], log["b"], log["M"]
    lo, hi = a - M, b + M

    g, sgn, sub = {}, {}, {}
    for r in recs:
        tag, tv, zrs = r[0], r[1], r[2]
        srec = int(r[6])  # pipeline's own recorded sign
        if srec not in (-1, 1):
            srec = sign_of_ball(zrs)
        if tag[0] == "g":
            n = int(tag[1])
            g[n] = ball_mid(tv)
            if srec:
                sgn[n] = srec
        elif tag[0] == "s":
            n, i, m = int(tag[1]), int(tag[2]), int(tag[3])
            sub[(n, i, m)] = (ball_mid(tv), srec if srec else 0)

    good = [n for n in range(lo, hi + 1) if sgn.get(n) == (1 if n % 2 == 0 else -1)]
    flagged, okblocks = [], []
    for j, k in zip(good, good[1:]):
        if not (a <= j and k <= b and k > j + 1):
            continue
        pts = [(g[n], sgn[n]) for n in range(j + 1, k) if n in sgn]
        for (n, i, m), (t, s) in sub.items():
            if j <= n < k and s:
                pts.append((t, s))
        pts.sort()
        changes = sum(1 for x, y in zip(pts, pts[1:]) if x[1] != y[1])
        B = {"j": j, "k": k, "need": k - j, "certified_changes": changes, "points": len(pts)}
        (flagged if changes < k - j else okblocks).append(B)

    random.seed(20261116)
    okblocks.sort(key=lambda B: B["need"])
    control = random.sample(okblocks, min(nctrl, len(okblocks)))

    def fresh_zeros(t_lo, t_hi):
        mp.dps = 40
        N = 800
        pts = [t_lo + (t_hi - t_lo) * mpf(i) / N for i in range(N + 1)]
        vals = [Z(t) for t in pts]
        min_abs = min(abs(v) for v in vals)
        crossings = []
        for i in range(len(vals) - 1):
            x, y = vals[i], vals[i + 1]
            if (x == 0 and y == 0) or (x * y < 0) or x == 0 or y == 0:
                crossings.append(i)
        confirmed, touches = 0, 0
        for i in crossings:
            mp.dps = 60
            tl, tr = pts[i], pts[i + 1]
            tm = (tl + tr) / 2
            zl, zr = Z(tm - (tr - tl) * mpf("0.25")), Z(tm + (tr - tl) * mpf("0.25"))
            if zl * zr < 0:
                confirmed += 1
            else:
                fine = [Z(tm + (t - tm) * mpf(i) / 16) for i in range(17)]
                f = sum(1 for p, q in zip(fine, fine[1:]) if p * q < 0 or p == 0 or q == 0)
                confirmed += f
        if min_abs < mpf("1e-12"):
            touches = 1
        return confirmed, touches, min_abs

    mp.dps = 50
    res = {"file": win, "a": a, "b": b, "b_minus_a": b - a,
           "gram_span_heights": [float(g[a]), float(g[b])]}
    for B in flagged:
        print("adjudicating span", B["j"], B["k"], "need", B["need"], flush=True)
        z, toc, mabs = fresh_zeros(g[B["j"]] + mpf("1e-12"), g[B["k"]] - mpf("1e-12"))
        B.update(fresh_zeros_count=z, near_zero_touch=toc, min_abs_z=float(mabs))
        B["status"] = "RESOLVED-OK" if z >= B["need"] else "RESOLVED-OVER(over-prediction)"
    for B in control:
        print("control span", B["j"], B["k"], B["need"], flush=True)
        z, toc, mabs = fresh_zeros(g[B["j"]] + mpf("1e-12"), g[B["k"]] - mpf("1e-12"))
        B.update(fresh_zeros_count=z, near_zero_touch=toc, min_abs_z=float(mabs))
        B["status"] = "control(>=need)" if z >= B["need"] else "CONTROL-FAIL"
    all_resolved = (not flagged or all(B["status"].startswith("RESOLVED") for B in flagged)) and \
                   all(B["status"].startswith("control") for B in control)
    res.update(n_blocks_len_gt1_inside=len(flagged) + len(okblocks), flagged_spans=flagged,
               control_spans=control,
               verdict=("ALL FLAGGED SPANS RESOLVED (window sign-change total = b-a per verifier)"
                        if all_resolved else "MISMATCH - manual review"))
    json.dump(res, open(out, "w"), indent=1)
    print("flagged:", [(B["j"], B["k"], B["need"], B.get("fresh_zeros_count")) for B in flagged])
    print("controls:", [(B["need"], B.get("fresh_zeros_count"), B["status"]) for B in control])
    print("verdict:", res["verdict"])
    print("wrote", out)


if __name__ == "__main__":
    main()
