#!/usr/bin/env python3
# LM1 only (re-run of the model-discriminator section of loom3, 0218).
import math
import numpy as np

LANE6 = 6
def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def markov_rates(w, mmax=3, Nsamples=400000, seed=0, nblk=1):
    rng = np.random.default_rng(seed)
    L = len(w)
    out = {}
    p = np.bincount(w, minlength=6).astype(float); p = p / p.sum()
    out[0] = float(-(p[p > 0] * np.log(p[p > 0])).sum())
    for m in range(1, mmax + 1):
        if nblk == 1:
            idx = rng.integers(0, L - (m + 2), size=min(Nsamples, L - m - 2))
            ctx = np.zeros(len(idx), dtype=np.int64)
            for k in range(m):
                ctx = ctx * 9 + w.take(idx + k)
            nxt = w.take(idx + m)
            _, civ, ccnt = np.unique(ctx, return_inverse=True, return_counts=True)
            H = 0.0
            for ci in range(len(ccnt)):
                sel = civ == ci
                nc = np.bincount(nxt[sel], minlength=6).astype(float)
                pc = nc / nc.sum()
                H += (ccnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
            out[m] = (H, 0.0)
        else:
            vals = []
            for b in range(nblk):
                sub = w[b * (L // nblk): (b + 1) * (L // nblk)]
                Ls = len(sub)
                idx = rng.integers(0, Ls - (m + 2), size=min(Nsamples, Ls - m - 2))
                ctx = np.zeros(len(idx), dtype=np.int64)
                for k in range(m):
                    ctx = ctx * 9 + sub.take(idx + k)
                nxt = sub.take(idx + m)
                _, civ, ccnt = np.unique(ctx, return_inverse=True, return_counts=True)
                H = 0.0
                for ci in range(len(ccnt)):
                    sel = civ == ci
                    nc = np.bincount(nxt[sel], minlength=6).astype(float)
                    pc = nc / nc.sum()
                    H += (ccnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
                vals.append(H)
            out[m] = (float(np.mean(vals)), float(np.std(vals, ddof=1)) if len(vals) > 1 else 0.0)
    return out

def gen_chain_order1(P, n, seed):
    s = np.empty(n, dtype=np.int64)
    s[0] = 0
    rng = np.random.default_rng(seed)
    cum = np.cumsum(P, axis=1)
    for i in range(1, n):
        s[i] = np.searchsorted(cum[s[i - 1]], rng.random())
    return s

def main():
    print("== LM1. MODEL DISCRIMINATOR (LOOM-1 first cut, X=2e6) ==")
    X2 = 2_000_000
    s2 = sieve(X2)
    p2 = np.array([i for i in range(2, X2 + 1) if s2[i]], dtype=np.int64)
    g2 = (np.diff(p2) // 2) % 6
    g2 = g2[:-1]
    real = markov_rates(g2, 3, nblk=8)
    h1_real = real[1][0]
    print(f"  REAL primes:  H0={real[0]:.5f}  H1={real[1][0]:.5f}+/-{real[1][1]:.5f}  "
          f"H2={real[2][0]:.5f}+/-{real[2][1]:.5f}  H3={real[3][0]:.5f}+/-{real[3][1]:.5f}")
    # FLOOR-0
    rng = np.random.default_rng(1)
    pm = np.bincount(g2, minlength=6).astype(float); pm = pm / pm.sum()
    f0 = []
    for r in range(5):
        w = rng.choice(6, size=len(g2), p=pm)
        f0.append(markov_rates(w, 2))
    print(f"  FLOOR-0 (Cramer iid, marginal):   H1={np.mean([x[1][0] for x in f0]):.5f}  "
          f"H2={np.mean([x[2][0] for x in f0]):.5f}   (no memory by construction)")
    # FLOOR-1: pair law (order-1 Markov generated chain)
    P1 = np.ones((6, 6))
    for a, b in zip(g2[:-1], g2[1:]):
        P1[a, b] += 1
    P1 = P1 / P1.sum(axis=1)[:, None]
    f1h3 = []
    for r in range(5):
        w = gen_chain_order1(P1, 200000, r)
        hh = markov_rates(w, 3)
        f1h3.append(hh[3][0])
    print(f"  FLOOR-1 (pair-law order-1 chain): H1={h1_real:.5f}  generated H3={np.mean(f1h3):.5f}")
    # FLOOR-2: order-2 law generated chain
    P2 = np.ones((6, 6, 6)) * 0.5
    for a, b, c in zip(g2[:-2], g2[1:-1], g2[2:]):
        P2[a, b, c] += 1
    P2 = P2 / P2.sum(axis=2)[:, :, None]
    f2h3 = []
    for r in range(5):
        n = 200000
        w = np.empty(n, dtype=np.int64)
        rr2 = np.random.default_rng(r)
        w[0] = int(rr2.integers(0, 6))
        w[1] = int(np.searchsorted(np.cumsum(P2[w[0]]), rr2.random()))
        for i in range(2, n):
            w[i] = int(np.searchsorted(np.cumsum(P2[w[i-2], w[i-1]]), rr2.random()))
        hh = markov_rates(w, 3)
        f2h3.append(hh[3][0])
    mH3, mH3se = real[3]
    print(f"  FLOOR-2 (order-2 law chain):      generated H3={np.mean(f2h3):.5f}")
    print(f"  REAL H3={mH3:.5f}  FLOOR-2 H3={np.mean(f2h3):.5f}  "
          f"depth-3 excess of REAL below FLOOR-2 = {mH3 - float(np.mean(f2h3)):+.5f} (block-SE ~{mH3se:.5f})")
    print("  (REAL H3 well below FLOOR-2 => tension EXCEEDS the order-2 law: a genuinely")
    print("   deeper 24-adic weave; ~equal => subsumed at order 2.)")

if __name__ == "__main__":
    main()
