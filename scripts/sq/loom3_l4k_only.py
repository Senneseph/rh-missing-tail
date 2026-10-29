#!/usr/bin/env python3
# L4K only (corrected base-8 encoding) - re-run of the progression-ladder section.
import math
import numpy as np

LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def main():
    X = 10_000_000
    sieve_arr = sieve(X)
    primes = np.array([i for i in range(2, X + 1) if sieve_arr[i]], dtype=np.int64)
    prim5 = primes[primes >= 5]
    P5 = len(prim5)
    lane = np.searchsorted(LANES, prim5 % 24)
    NMIN = 100_000
    j0 = int(np.searchsorted(prim5, NMIN))
    nCuts = P5 - j0 - 1
    print(f"  X={X}, cuts={nCuts}")
    print("  K  ordered top-1   top-3 union   multiset(out-of-order) top-1")
    Kmax = 4
    for K in range(1, Kmax + 1):
        nK = nCuts + 1 - K
        seq = np.stack([lane[j0 + 1 + k:j0 + 1 + k + nK] for k in range(K)], axis=1)
        n = len(seq)
        enc = seq.astype(np.int64)
        for k in range(K):
            enc[:, k] *= 8 ** (K - 1 - k)
        enc = enc.sum(axis=1, dtype=np.int64)
        vals, cnts = np.unique(enc, return_counts=True)
        order = np.argsort(cnts)[::-1]
        top1 = cnts[order[0]] / n
        top3 = cnts[order[:3]].sum() / n
        top1v = vals[order[0]]
        hit_ours = float((enc == top1v).mean())
        # decode the top pattern for readability
        top_dec = []
        v = int(top1v)
        for k in range(K - 1, -1, -1):
            top_dec.append(v % 8); v //= 8
        top_dec = list(reversed(top_dec))
        top_lanes = [int(LANES[d]) for d in top_dec]
        srt = np.sort(seq, axis=1)
        m2 = srt.astype(np.int64)
        for k in range(K):
            m2[:, k] *= 8 ** (K - 1 - k)
        m2c = m2.sum(axis=1, dtype=np.int64)
        _, mcnts = np.unique(m2c, return_counts=True)
        mtop1 = mcnts.max() / n
        print(f"  {K}   {hit_ours:.4f}       {min(1.0, top3):.4f}        {mtop1:.4f}   "
              f"(top pattern lanes {top_lanes})  (n={n})")

if __name__ == "__main__":
    main()
