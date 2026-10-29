#!/usr/bin/env python3
# LOOM-1b2 first cut (0219): THE MARRIAGE TEST.
#
# Owner (2026-10-29): "let's do the pair law and let these two get married
# already!"  =>  marry the PAIR LAW (the measured 2-consecutive-gap bias, the
# Lemke-Oliver/Maynard-Tao family, as an empirical Markov generator at each
# scale) to the FULL prime gap process (its H_m ladder beyond order 2).
#
# At each scale X in {2e6, 1e7, 1e8} and each alphabet:
#   L8  = the 8 reduced LANES (the M1 prediction machine's own alphabet;
#         the pair law here IS the one-step gap law that predicted 0.22)
#   G24 = gap CLASS mod 24 (12 even symbols: the full 24-adiic gap loom)
#   A6  = gap/2 mod 6   (the LM1 word, for continuity)
# measure:
#   REAL  H1/H2/H3 (block SE)
#   Cramer floor (iid at the empirical marginal)  ~  H0 memoryless
#   PAIR-LAW MODEL: fit the measured pair (order-1) transition at THIS scale,
#     generate 5 synthetic chains, H1/H2/H3 of the chains.
# Verdict per (X, alphabet):
#   sanity: model H1 ~= real H1 and model H2 ~= real H2 (the fit must marry
#           the pair part of the data - by construction)
#   MARRIAGE (H3): |real H3 - model H3| <= ~2 SE  =>  the pair law explains
#           everything beyond the pair: SUBSUMED (the loom IS the pair law)
#           real H3 < model H3 by > 2 SE  =>  the weave is DEEPER than the
#           pair law (a genuine object beyond the 2-gap bias)
# and the scale behavior of the excess D(X) = real H3 - model H3.
#
# OFF-BOARD; no RH claim; single-threaded (4 cores open); ~3-5 min total.

import math, sys, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom4_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
SYMS = {"L8": 8, "G24": 12, "A6": 6}

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def markov_rates(w, mmax=3, Nsamples=400000, seed=0, nblk=8, A=6):
    """H_m per-symbol entropy via m-th order Markov fit; (mean, block-SD)."""
    if nblk <= 1:
        nblk = 1
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

def main():
    out = []
    def rep(s=""):
        print(s); out.append(s)
    import os
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    t0 = time.time()
    rep("LOOM-1b2 first cut (0219): THE MARRIAGE TEST - pair law vs the full weave")
    rep("(OFF-BOARD; no RH claim)")
    rep("  pair law = the measured 2-consecutive bias as a generator at each scale")
    rep("  marriage = the model's H3 (beyond-order-2) vs the REAL H3 ladder")

    # build once at the biggest scale; subsample for the smaller ones
    Xb = 100_000_000
    s8 = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if s8[i]], dtype=np.int64)
    rep(f"  sieve to {Xb} done; primes = {len(primes)}; {time.time()-t0:.1f}s")

    for X in (2_000_000, 10_000_000, 100_000_000):
        rep(f"\n{'='*72}\n  X = {X:,}\n{'='*72}")
        pX = primes[primes <= X]
        gaps = np.diff(pX)
        gaps = gaps[gaps % 2 == 0]            # drop the p=2 anomaly
        g24 = (gaps % 24) // 2                # 0..11 (even residues 2,4,...,22)
        a6 = (gaps // 2) % 6                  # 0..5
        p5 = pX[pX >= 5]
        lane = np.searchsorted(LANES, p5 % 24)
        rep(f"  primes={len(pX)}  gaps={len(gaps)}  lanes={len(lane)}")

        for name, w, A in (("L8 (lanes, the M1 machine)", lane, 8),
                           ("G24 (gap class mod 24)", g24, 12),
                           ("A6 (gap/2 mod 6, LM1 word)", a6, 6)):
            real = markov_rates(w, 3, nblk=8, A=A)
            P = fit_pair(w, A)
            # Cramer floor
            rng = np.random.default_rng(7)
            pm = np.bincount(w, minlength=A).astype(float); pm = pm / pm.sum()
            cw = rng.choice(A, size=min(1_200_000, len(w)), p=pm)
            cr = markov_rates(cw, 3, nblk=4, A=A)
            # pair-law model chains
            h = {}
            for m in (1, 2, 3):
                hs = []
                for r in range(5):
                    ws = gen_chain(P, 1_000_000, r)
                    hh = markov_rates(ws, 3, nblk=4, A=A)
                    hs.append(hh[m][0])
                h[m] = (float(np.mean(hs)), float(np.std(hs, ddof=1)))
            rep(f"\n  {name}  (alphabet {A})")
            rep(f"    REAL   H1={real[1][0]:.5f}+/-{real[1][1]:.5f}  "
                f"H2={real[2][0]:.5f}+/-{real[2][1]:.5f}  "
                f"H3={real[3][0]:.5f}+/-{real[3][1]:.5f}")
            rep(f"    CRAMER H1={cr[1][0]:.5f}  H2={cr[2][0]:.5f}  "
                f"H3={cr[3][0]:.5f}   (memoryless floor)")
            rep(f"    PAIR   H1={h[1][0]:.5f}  H2={h[2][0]:.5f}  "
                f"H3={h[3][0]:.5f}+/-{h[3][1]:.5f}   (model, this scale's pair law)")
            d3 = real[3][0] - h[3][0]
            pooled = math.sqrt(real[3][1] ** 2 + h[3][1] ** 2)
            z = d3 / pooled if pooled > 0 else float("inf")
            if pooled <= 0:
                stat = " (n/a)"
            elif abs(z) <= 2:
                stat = " => MARRIED: pair law explains H3 (subsumed here)"
            elif z < 0:
                stat = f" => DEEPER: real H3 below the pair law by {abs(z):.1f} pooled-SE"
            else:
                stat = f"  (real H3 ABOVE model by {z:+.1f} SE: model underfit noise)"
            rep(f"    D(X)=realH3-modelH3 = {d3:+.5f}  {stat}")

    rep(f"\n== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
