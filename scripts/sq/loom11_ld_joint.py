#!/usr/bin/env python3
# LOOM-1b2b (0228): THE FINAL ADJUDICATOR - the LD k-tuple JOINT law of
# consecutive prime gaps as a GENERATOR, vs the real H_m ladder.
#
# Model (faithful finite implementation of the Landau-Lodsmann setup,
# arXiv:1906.05800, at the WORD level): the Cramer model conditioned on
# the small-prime sieve Y - a point q is a "prime" iff it lies on the Y
# -wheel lattice (coprime to the primorial of primes <= Y) AND passes a
# Bernoulli(1/log q) flip.  Ladders: Y = 13 (the 120120 wheel = the tile
# of track 3) and Y = 17 (the 510510 wheel).  The emitted word over
# consecutive accepted points:
#     L8  = the lane word (accepted point mod 24, 8 lanes)
#     G24 = the gap CLASS word (gap mod 24, 12 even symbols)
#     A6  = the gap/2 mod 6 word (6 symbols)   [= G24 mod 6]
# Its k-consecutive-gap joint law is the model's exact small-prime joint
# law (what the sieve wheel "pops out"); 1/log q at scale X is the only
# X-dependence at this word level (the LD scaling).  We measure its H_m
# ladder (m = 1..4) against the REAL one (same alphabets, same block-SE
# machinery as 0219), plus the 0219 pair-fit and the memoryless Cramer
# floor for the full table.
#
# Adjudicator (per X, per alphabet, per m):
#   |real_H_m - LD_H_m| <= 2 pooled SE  =>  the sieve joint law SUBSUMES
#                                           the real weave at this order
#   real < LD by > 2 pooled SE         =>  the weave is DEEPER than the
#                                           full k-tuple joint law (the
#                       medium-prime LD O-terms + ?)
#   LD < real by > 2 pooled SE         =>  model under-structured here
#
# OFF-BOARD. No RH claim. 1 core (4 open). Seed 11.
#
import os
import math
import time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom11_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
SCALES = [2_000_000, 10_000_000, 100_000_000]
NWORDS = 4_000_000
SEED = 11

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

# ------------------------------------------------------------------ words
def markov_rates(w, mmax=4, Nsamples=400000, seed=0, nblk=8, A=6):
    """H_m per-symbol entropy via m-th order Markov fit; (mean, block-SD)."""
    out = {}
    p = np.bincount(w, minlength=A).astype(float); p = p / p.sum()
    out[0] = (float(-(p[p > 0] * np.log(p[p > 0])).sum()), 0.0)
    base = A + 1
    for m in range(1, mmax + 1):
        vals = []
        for b in range(nblk):
            sub = w[b * (len(w) // nblk): (b + 1) * (len(w) // nblk)]
            Ls = len(sub)
            if Ls < (m + 10):
                break
            rng = np.random.default_rng(seed + b)
            idx = rng.integers(0, Ls - (m + 2), size=min(Nsamples, Ls - m - 2))
            ctx = np.zeros(len(idx), dtype=np.int64)
            for k in range(m):
                ctx = ctx * base + sub.take(idx + k)
            nxt = sub.take(idx + m)
            _, civ, ccnt = np.unique(ctx, return_inverse=True, return_counts=True)
            H = 0.0
            for ci in range(len(ccnt)):
                sel = civ == ci
                nc = np.bincount(nxt[sel], minlength=A).astype(float)
                pc = nc / nc.sum()
                H += (ccnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
            vals.append(H)
        out[m] = (float(np.mean(vals)), float(np.std(vals, ddof=1)) if len(vals) > 1 else 0.0)
    return out

def fit_pair(w, A):
    P = np.ones((A, A))
    ab = (w[:-1].astype(np.int64) * A + w[1:].astype(np.int64))
    cnt = np.bincount(ab, minlength=A * A).reshape(A, A).astype(float)
    P = P + cnt
    return P / P.sum(axis=1)[:, None]

def gen_chain(P, n, seed):
    s = np.empty(n, dtype=np.int64)
    A = P.shape[0]
    rng = np.random.default_rng(seed)
    p0 = P.sum(axis=1); p0 = p0 / p0.sum()
    s[0] = int(rng.choice(A, p=p0))
    cum = np.cumsum(P, axis=1)
    u = rng.random(n - 1)
    for i in range(1, n):
        s[i] = int(np.searchsorted(cum[s[i - 1]], u[i - 1]))
    return s

# ------------------------------------------------------------ LD sampler
def ld_tables(Ylist):
    """the Y-wheel: period P, residues, next-index, gap, wrap, lane idx."""
    P = 2
    for y in Ylist:
        P = (P // math.gcd(P, y)) * y
    keep = np.ones(P, dtype=bool)
    keep[0] = False                                  # residue 0 is never coprime
    for y in Ylist:
        keep[y::y] = False
    res = np.nonzero(keep)[0]
    n = len(res)
    nxt = (np.arange(1, n + 1)) % n
    gap = np.empty(n, dtype=np.int64)
    gap[1:] = res[1:] - res[:-1]
    gap[0] = (res[0] + P) - res[-1]
    wrap = (nxt == 0).astype(np.int64)
    lane_idx = np.full(P, 8, dtype=np.int8)
    for idx, L in enumerate(LANES):
        lane_idx[list(range(L, P, 24))] = idx
    # the ACTUAL accepted point is q = m*P + res[r];  its mod 24 is
    # (res[r] + (P mod 24)*(m mod (24/gcd(P,24)))) mod 24.
    # For P = 30030: P mod 24 = 6, period in m is 4 -> 4 shifted lanes.
    shift = P % 24
    mper = (24 // math.gcd(24, shift)) if shift else 1
    lane_idx4 = np.empty((len(res), mper), dtype=np.int8)
    for k4 in range(mper):
        lane_idx4[:, k4] = lane_idx[((res + shift * k4) % P)]
    return P, res, nxt, gap, wrap, lane_idx4

def ld_sample(P, res, nxt, gap, wrap, lane_idx4, X, nwords, seed):
    """parallel-chain Cramer+Y-sieve word sampler at scale X.
    returns (gapword G24 int8, laneword L8 int8) of length nwords.
    (the word starts at the seeded prime of each chain; the lane of the
    accepted point q = m*P + r uses the 4-way shifted lane table)."""
    mper = lane_idx4.shape[1]
    rng = np.random.default_rng(seed)
    B = 65536
    r = rng.integers(0, len(res), size=B)          # lattice INDEX
    m = rng.integers(0, max(1, X // P), size=B)    # period number
    q = m * P + res[r]
    lastq = q.copy()                               # seed: the start point
    gA = np.empty(nwords, dtype=np.int8)
    lA = np.empty(nwords, dtype=np.int8)
    cnt = 0
    step = 0
    maxsteps = nwords * 80
    while cnt < nwords and step < maxsteps:
        step += 1
        # advance one lattice step FIRST (the seeded prime is r itself)
        r = np.where(wrap[r], 0, nxt[r])
        m = m + wrap[r]
        q = m * P + res[r]
        acc = rng.random(B) < 1.0 / np.log(np.maximum(q, 3.0))
        if np.any(acc):
            ia = np.nonzero(acc)[0]
            space = nwords - cnt
            if len(ia) > space:
                ia = ia[:space]
            g = q[ia] - lastq[ia]
            lA[cnt:cnt + len(ia)] = lane_idx4[r[ia], (m[ia] % mper)]
            gA[cnt:cnt + len(ia)] = (g.astype(np.int64) % 24) // 2
            cnt += len(ia)
        lastq[acc] = q[acc]
    return gA[:cnt], lA[:cnt]

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    t0 = time.time()
    out = []
    ofh = open(OUT, "w")
    def rep(s=""):
        print(s); out.append(s)
        ofh.write(s + "\n"); ofh.flush()

    rep("LOOM-1b2b (0228): THE FINAL ADJUDICATOR - the LD k-tuple JOINT law")
    rep("(OFF-BOARD; no RH claim; 1 core, 4 open; seed 11)")
    rep("  model = Cramer(1/log q) conditioned on the Y-wheel lattice")
    rep("  Y = 13 (120120 wheel = the tile) and Y = 17 (510510 wheel)")
    rep(f"  NWORDS = {NWORDS} per (Y, X); scales {SCALES}")

    # ---------------- real data ----------------------------------------
    Xb = 100_000_000
    s8 = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if s8[i]], dtype=np.int64)
    rep(f"  sieve to {Xb}: {len(primes)} primes ({time.time()-t0:.1f}s)")

    realW = {}
    for X in SCALES:
        pX = primes[primes <= X]
        gaps = np.diff(pX)
        gaps = gaps[gaps % 2 == 0]
        p5 = pX[pX >= 5]
        lane = np.searchsorted(LANES, p5 % 24)
        realW[X] = {
            "L8": (lane.astype(np.int64), 8),
            "G24": (((gaps % 24) // 2).astype(np.int64), 12),
            "A6": (((gaps // 2) % 6).astype(np.int64), 6),
        }
    rep(f"  real words ready ({time.time()-t0:.1f}s)")

    tables = {}
    for Y in (13, 17):
        yl = [p for p in (2, 3, 5, 7, 11, 13, 17) if p <= Y]
        tables[Y] = ld_tables(yl)
        P, res, nxt, gap, wrap, lane_idx4 = tables[Y]
        rep(f"  wheel Y={Y}: period {P}, lattice {len(res)} points, "
            f"max lattice gap {gap.max()}")

    # ---------------- H_m ladders up front (real, model, floor, pair) --
    H = {}   # H[(kind, Y, X, alpha)] = dict m -> (mean, se)
    for X in SCALES:
        for aname in ("L8", "G24", "A6"):
            w, A = realW[X][aname]
            H[("real", 0, X, aname)] = markov_rates(w, 4, nblk=8, A=A)
            # pair-fit (0219 reference): 5 chains
            Pm = fit_pair(w, A)
            hs = {m: [] for m in (1, 2, 3, 4)}
            for r in range(5):
                ws = gen_chain(Pm, 1_000_000, r)
                hh = markov_rates(ws, 4, nblk=4, A=A)
                for m in (1, 2, 3, 4):
                    hs[m].append(hh[m][0])
            H[("pair", 0, X, aname)] = {
                m: (float(np.mean(v)), float(np.std(v, ddof=1)))
                for m, v in hs.items()}
            # Cramer floor (marginal resample, 1.2e6)
            rng = np.random.default_rng(7)
            pm = np.bincount(w, minlength=A).astype(float); pm = pm / pm.sum()
            cw = rng.choice(A, size=1_200_000, p=pm)
            H[("floor", 0, X, aname)] = markov_rates(cw, 4, nblk=4, A=A)
    rep(f"  real/pair/floor ladders done ({time.time()-t0:.1f}s)")

    for X in SCALES:
        for Y in (13, 17):
            P, res, nxt, gap, wrap, lane_idx4 = tables[Y]
            t1 = time.time()
            gw, lw = ld_sample(P, res, nxt, gap, wrap, lane_idx4, X,
                               NWORDS, SEED + Y + X // 10**6)
            for aname, w in (("L8", lw.astype(np.int64)),
                             ("G24", gw.astype(np.int64)),
                             ("A6", (gw.astype(np.int64) % 6))):
                A = realW[X][aname][1]
                H[("LD", Y, X, aname)] = markov_rates(w, 4, nblk=8, A=A)
            rep(f"  sample+H Y={Y} X={X}: {len(gw)} words "
                f"({time.time()-t1:.1f}s)")

    # ---------------- adjudication table --------------------------------
    rep("")
    rep("ADJUDICATION (pooled SE sqrt(s1^2+s2^2); 2SE rule):")
    rep("  SUBSUMED  |real-LD| <= 2SEp          DEEPER     real < LD, z>2")
    rep("  UNDERSTRUCTURED  LD < real, z>2")
    for X in SCALES:
        rep(f"\n{'='*74}\n  X = {X:,}\n{'='*74}")
        for aname in ("L8", "G24", "A6"):
            rep(f"\n  {aname}:")
            rep("    m     real            LD13            LD17   "
                "pair      floor")
            for m in (1, 2, 3, 4):
                rr = H[("real", 0, X, aname)][m]
                d13 = H[("LD", 13, X, aname)][m]
                d17 = H[("LD", 17, X, aname)][m]
                pr = H[("pair", 0, X, aname)][m]
                fl = H[("floor", 0, X, aname)][m]
                rep(f"    {m}   {rr[0]:.5f}+/-{rr[1]:.5f}  "
                    f"{d13[0]:.5f}+/-{d13[1]:.5f}  "
                    f"{d17[0]:.5f}+/-{d17[1]:.5f}  "
                    f"{pr[0]:.5f}         {fl[0]:.5f}")
            rep("    verdicts (m: real-vs-LD13, real-vs-LD17):")
            for m in (1, 2, 3, 4):
                rr = H[("real", 0, X, aname)][m]
                vs = []
                for Y in (13, 17):
                    d = H[("LD", Y, X, aname)][m]
                    se = math.sqrt(rr[1]**2 + d[1]**2)
                    if se == 0:
                        z, tag = 0.0, "na"
                    else:
                        z = (rr[0] - d[0]) / se
                        if abs(z) <= 2:
                            tag = f"SUBSUMED (z={z:+.2f})"
                        elif z > 0:
                            tag = f"UNDERSTRUCTURED (z={z:+.2f})"
                        else:
                            tag = f"DEEPER (z={z:+.2f})"
                    vs.append(f"m{m}vsY{Y}: {tag}")
                rep("      " + "   ".join(vs))
    rep("")
    rep(f"== done in {time.time()-t0:.1f}s ==")
    ofh.close()

if __name__ == "__main__":
    main()
