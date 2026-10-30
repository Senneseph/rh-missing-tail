#!/usr/bin/env python3
# loom10_cloudbursts.py - LOOM CLOUDBURST HUNT (0226 lane, G-1c):
# "where does the vapor of our data condense?"
#
# OFF-BOARD SIDE QUEST.  No RH claim.  Every metaphor maps to a named
# finite object:
#
#   VAPOR     = the prime-gap weave of scales X = 1e5..1e8.  Each prime
#               is a Gaussian SPLAT on the integer lattice (1 integer =
#               1 pixel, parity anchor visible); the field at the point
#               positions f(x) = sum_{j != i} N(x; p_j, sig) is the
#               leave-one-out vapor pressure (the self-splat is removed:
#               with contact width it would be ~80% of the fine field).
#
#   CLOUD     = a local condensation: a local max of
#                 c(x) = f_fine(x) / f_coarse(x)
#               (fine sigma_f = a x <g>, coarse background
#               sigma_c = b x <g>), de-duplicated at sigma_c.
#
#   BURST     = a cloud with c >= K.  Measured per (scale pair, K):
#               count, fraction of points, mean depth, core size
#               (# points in the +/- 3 sigma_f core).
#
#   NULLS (background weather), same X, same sigma pair:
#     A  Cramer vapor   : every integer j independently "prime" w.p.
#                         1/ln(j)   (no memory at all)
#     B  block vapor    : block bootstrap of the real gaps, block 64
#                         (keeps ALL local structure incl. the pair
#                         law; destroys correlation beyond 64 gaps)
#     C  marginal vapor : iid gaps from the empirical G24 class
#                         marginals with within-class values (keeps
#                         the gap-value distribution, destroys the
#                         pair memory)
#
#   SCALE LADDER (splat sizes in units of the local mean gap):
#     (sigma_f, sigma_c) = (2, 8)   cloud ~ 3-gap scale
#                            (3, 12) cloud ~ 5-gap scale
#                            (4, 20) cloud ~ 7-gap scale
#
#   ANSWER    = real bursts vs the null counts at every (pair, K).
#               Real ABOVE a null band -> named condensation (and the
#               anatomy says what condenses: core tightness, 24-adic
#               front-bloom, same-class runs).  Real BELOW the bands ->
#               ANTI-CONDENSATION: the real weave is smoother at local
#               scale than the corresponding null (a real, named
#               negative measurement).
#
# Single-threaded; leaves 4 cores open; window cutoffs 3*sig_f / 2.5*sig_c
# (tail loss < 0.3%, noted).
import numpy as np
import time

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom10_out.txt"
SCALES = [10 ** 5, 10 ** 6, 10 ** 7, 10 ** 8]
SPP = [(2.0, 8.0), (3.0, 12.0), (4.0, 20.0)]   # (sigma_f, sigma_c) in <g>
THRESH = [1.1, 1.2, 1.5]
N_A, N_B, N_C = 12, 8, 8
BLOCK = 64
CORE_RAD = 3
DEDUP_MULT = 8.0     # peaks closer than (8 x <g>)... = sigma_c of pair 1
SEED = 11

lines = []
out_fh = None


def rep(s=""):
    global out_fh
    print(s)
    lines.append(s)
    if out_fh:
        out_fh.write(s + "\n")
        out_fh.flush()


def sieve(X):
    s = bytearray(b"\x01") * (X + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(X ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return np.frombuffer(s, dtype=np.uint8).copy()


def field_ratio_at_points(m, pts, sig_f, sig_c):
    # LOO condensation ratio c at the point positions.
    n = len(pts)
    p64 = pts.astype(np.int64)
    rf = int(np.ceil(3 * sig_f))
    k = np.arange(-rf, rf + 1)
    w_f = np.exp(-0.5 * (k / sig_f) ** 2) / (sig_f * np.sqrt(2 * np.pi))
    ff = np.zeros(n)
    for ki, off in enumerate(k):
        idx = p64 + off
        ok = (idx >= 0) & (idx < len(m))
        ff[ok] += w_f[ki] * m[idx[ok]]
    ff -= w_f[rf]  # leave one out (own splat)
    rc = int(np.ceil(2.5 * sig_c))
    k = np.arange(-rc, rc + 1)
    w_c = np.exp(-0.5 * (k / sig_c) ** 2) / (sig_c * np.sqrt(2 * np.pi))
    fc = np.zeros(n)
    for ki, off in enumerate(k):
        idx = p64 + off
        ok = (idx >= 0) & (idx < len(m))
        fc[ok] += w_c[ki] * m[idx[ok]]
    fc[fc < 1e-30] = 1e-30
    return ff / fc


P = None


def burst_stats(c, X, K, dedup, half_core):
    n = len(c)
    hi = np.zeros(n, dtype=bool)
    hi[1:] = c[1:] >= c[:-1]
    hi[:-1] &= c[:-1] > c[1:]
    cands = np.where(hi & (c >= K))[0]
    cands = cands[np.argsort(-c[cands], kind="stable")]
    covered = np.zeros(X + 1, dtype=bool)
    taken = []
    for j in cands:
        j = int(j)
        if not covered[j]:
            taken.append(j)
            a, b = max(0, j - dedup), min(X, j + dedup + 1)
            covered[a:b] = True
    taken = np.array(taken, dtype=np.int64)
    if len(taken):
        depth = c[taken]
        lo = np.searchsorted(P, taken - half_core, side="left")
        hi_ = np.searchsorted(P, taken + half_core, side="right")
        core = hi_ - lo
    else:
        depth = np.zeros(0)
        core = np.zeros(0, dtype=np.int64)
    return taken, depth, core


def anatomy(p, taken, d, gmean, half):
    if len(taken) == 0:
        return None
    lo = np.searchsorted(p, taken - half, side="left")
    hi_ = np.searchsorted(p, taken + half, side="right")
    idxs = np.concatenate([np.arange(lo[i], hi_[i]) for i in range(len(taken))
                           if hi_[i] > lo[i] + 1])
    idxs = idxs[idxs >= 1]
    if len(idxs) == 0:
        return None
    dc = d[idxs - 1]
    n = len(dc)
    front_core = float(np.mean((dc % 24) <= 12)) if n else 0.0
    front_all = float(np.mean((d % 24) <= 12))
    runs = []
    for i in range(min(50, len(taken))):
        l0 = np.searchsorted(p, taken[i] - half, side="left") + 1
        l1 = np.searchsorted(p, taken[i] + half, side="right") + 1
        seg = (d[max(0, l0 - 1):l1 - 1] % 24) // 2
        if len(seg) < 2:
            continue
        mx = cur = 1
        for a, b in zip(seg[:-1], seg[1:]):
            cur = cur + 1 if a == b else 1
            mx = max(mx, cur)
        runs.append(mx)
    return {
        "ng": int(n),
        "tight": float(dc.mean()) / gmean if n else 1.0,
        "front_core": front_core,
        "front_all": front_all,
        "maxrun50": float(np.mean(runs)) if runs else 0.0,
    }


def null_cramer(X, rng):
    j = np.arange(2, X + 1, dtype=np.float64)
    lam = 1.0 / np.log(j)
    mask = (rng.random(X - 1) < lam)
    return np.nonzero(mask)[0].astype(np.int64) + 2


def null_block(d, X, rng):
    nB = len(d) // BLOCK
    perm = rng.permutation(nB)
    dd = d[: nB * BLOCK].reshape(nB, BLOCK)[perm].ravel()
    pts = np.empty(nB * BLOCK + 1, dtype=np.int64)
    pts[0] = 3
    pts[1:] = 3 + np.cumsum(dd)
    return pts[pts < X]


def null_marginal(d, X, rng):
    cls = (d % 24) // 2
    n = len(d)
    cnew = rng.integers(0, 12, size=n)
    out = np.empty(n, dtype=np.int64)
    for c in range(12):
        sel = d[cls == c]
        k = (cnew == c).sum()
        out[cnew == c] = rng.choice(sel, size=k)
    pts = np.empty(n + 1, dtype=np.int64)
    pts[0] = 3
    pts[1:] = 3 + np.cumsum(out)
    return pts[pts < X]


def bandfmt(vals):
    if not vals:
        return "n/a", "n/a"
    arr = np.array(vals)
    return f"{np.percentile(arr, 2.5):.0f}-{np.percentile(arr, 97.5):.0f}", \
           f"{np.median(arr):.0f}"


def main():
    global P, out_fh
    out_fh = open(OUT, "w")
    t0 = time.time()
    rep("LOOM CLOUDBURST HUNT (0226, G-1c) - where does the data vapor condense?")
    rep("(OFF-BOARD. No RH claim. 1 integer = 1 pixel, parity anchor visible.")
    rep(" LOO splat fields; window cutoffs 3*sig_f / 2.5*sig_c, tail loss < 0.3%.")
    rep(f" nulls: A Cramer x {N_A}, B block-bootstrap(64) x {N_B}, C marginal x {N_C}; "
        f"seed {SEED}; scale pairs (sigma_f, sigma_c) in <g>: {SPP})")
    rep("")

    for X in SCALES:
        rep(f"=== scale X = {X:,} ===")
        m = sieve(X)
        p = np.nonzero(m)[0].astype(np.int64)
        p = p[p >= 3]
        d = np.diff(p).astype(np.int64)
        gmean = float(np.mean(d))
        rep(f"  primes = {len(p):,}; mean gap = {gmean:.3f}")

        # ---- real fields, every scale pair
        real = {}
        for (af, ac) in SPP:
            sf, sc = af * gmean, ac * gmean
            c = field_ratio_at_points(m, p, sf, sc)
            real[(af, ac)] = c
        # ---- null point sets once, fields per scale pair
        rngA = np.random.default_rng(SEED)
        rngB = np.random.default_rng(SEED + 1)
        rngC = np.random.default_rng(SEED + 2)
        tn = time.time()
        nullpts = []
        for r in range(N_A):
            nullpts.append(("A", null_cramer(X, rngA)))
        for r in range(N_B):
            nullpts.append(("B", null_block(d, X, rngB)))
        for r in range(N_C):
            nullpts.append(("C", null_marginal(d, X, rngC)))
        nullc = {fam: {spp_key: [] for spp_key in SPP} for fam in "ABC"}
        for fam, q in nullpts:
            mq = np.zeros(X + 1, dtype=np.uint8)
            mq[q] = 1
            gq = float(np.mean(np.diff(q))) if len(q) > 1 else gmean
            for (af, ac) in SPP:
                nullc[fam][(af, ac)].append(
                    field_ratio_at_points(mq, q, af * gq, ac * gq))
        rep(f"  (null fields: {time.time() - tn:.0f}s)")

        rep("")
        rep("  condensation QUANTILES of c (higher = more condensation):")
        rep("  (sigf, sigc)  K   real: peaks frac  p99   p99.9  max   |")
        rep("      A: p99[2.5-97.5]  p99.9[2.5-97.5]  maxmed   B: ...   C: ...")
        for (af, ac) in SPP:
            c = real[(af, ac)]
            sf, sc = af * gmean, ac * gmean
            half = int(np.ceil(CORE_RAD * sf))
            dedup = int(ac * gmean)  # ~ sigma_c
            for K in THRESH:
                P = p
                taken, depth, core = burst_stats(c, X, K, dedup, half)
                nr, fr = len(taken), (c >= K).mean()
                p99r = float(np.percentile(c, 99))
                p999r = float(np.percentile(c, 99.9))
                mxc = float(c.max())
                row = (f"  ({af:.0f},{ac:.0f})    {K:<4}  {nr:<6} {fr:.5f}  "
                       f"{p99r:.4f} {p999r:.4f} {mxc:.4f}   |")
                for fam in "ABC":
                    cs = nullc[fam][(af, ac)]
                    p99s = np.array([float(np.percentile(cc, 99)) for cc in cs])
                    p999s = np.array([float(np.percentile(cc, 99.9)) for cc in cs])
                    mss = np.array([float(cc.max()) for cc in cs])
                    row += (f"  {fam}: {np.median(p99s):.4f}["
                            f"{np.percentile(p99s, 2.5):.4f}-"
                            f"{np.percentile(p99s, 97.5):.4f}]  "
                            f"{np.median(p999s):.4f}["
                            f"{np.percentile(p999s, 2.5):.4f}-"
                            f"{np.percentile(p999s, 97.5):.4f}]  "
                            f"{np.median(mss):.4f}")
                rep(row)
            # raw-exceedance counts (no dedupe) for the record
            if (af, ac) == SPP[0]:
                for K in THRESH:
                    row = f"  (2,8)raw K={K}: "
                    row += f"real-raw={(real[(2.0,8.0)]>=K).sum():<6} "
                    for fam in "ABC":
                        cnts = [int((cc >= K).sum()) for cc in nullc[fam][(2.0, 8.0)]]
                        lo, md = bandfmt(cnts)
                        row += f"{fam} {lo} [{md}] "
                    rep(row)
        # ---- anatomy of the real clouds at (2,8), K=1.2
        (af, ac) = (2.0, 8.0)
        c = real[(af, ac)]
        sf = af * gmean
        half = int(np.ceil(CORE_RAD * sf))
        P = p
        taken, depth, core = burst_stats(c, X, 1.2, int(ac * gmean), half)
        an = anatomy(p, taken, d.astype(np.float64), gmean, half)
        if an:
            rep(f"  ANATOMY (real clouds (2,8) K=1.2, n={len(taken)}): "
                f"core tightness = {an['tight']:.3f} x global;  "
                f"front-bloom core {an['front_core']:.4f} vs all {an['front_all']:.4f};  "
                f"mean max same-class run (top-50) = {an['maxrun50']:.2f}")
        else:
            rep(f"  ANATOMY: no real clouds at (2,8) K=1.2")
        rep(f"  ({time.time() - t0:.0f}s elapsed)")
        rep("")

    rep("")
    rep("VERDICT: real condensation vs the three null families across the")
    rep("scale ladder.  No RH claim, off-board measurement only.")
    rep(f"== done in {time.time() - t0:.1f}s ==")
    out_fh.close()


if __name__ == "__main__":
    main()
