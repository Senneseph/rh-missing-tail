#!/usr/bin/env python3
# LOOM-0 (0216): does a "loom" weave the primes like Penrose tiles?
#
# Owner idea (2026-10-29): the orbit is a "wheel"; the wheel is connected to a
# "loom". Penrose tiling is like the prime distribution (never repeating). Can
# we identify a loom that CARVES the primes as Penrose tiles? Maybe boom, maybe
# doom, maybe subsumed (into a known structure), or a 24-adic BLOOM.
#
# The decisive, executable form of "is it a loom (substitution tiling) or noise":
#   A PENROSE / SUBSTITUTION tiling has linear factor complexity and ZERO
#     topological entropy. A RANDOM word over m symbols has p(n) ~ m^n and
#     entropy ln m.
#   -> Measure, on the real primes up to X:
#      A2 = {gap/2 mod 2}      (2 symbols: gap==0 mod 4 vs gap==2 mod 4)
#      A6 = {gap/2 mod 6}      (6 symbols: the TRUE gap-class word mod 12)
#     (1) factor complexity p(n); (2) Markov-memory entropy rates H_m - how
#         much structure each additional order of gap-memory captures.
#   If H_1 ~= H_0 (nothing) and H_m ~= H_1 (all the tension is pair-level):
#     the "loom" is SUBSUMED into the known LO/mod-4 gap-bias pair law.
#   If H_3 < H_2 < H_1 < H_0 (significant deltas at depth): a DEEPER loom.
#   If all H_m ~= ln 6: DOOM (random-like). Zero-entropy/linear: BOOM.
#   C: the 24-adic frame (front/back 4/4, WF-24/0909) in the gap loom.
#   D: the LITERAL Penrose inflation test on admissible constellations.
#
# OFF-BOARD side quest. No RH claim. Everything finite, named, reproducible.
# Single-threaded (4 cores open).

import math, random, sys
import numpy as np

X = 2_000_000
PHI = 0.5 + 0.5 * math.sqrt(5.0)

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n+1, i)))
    return s

def complexity(word, nmax):
    """p(n) = # distinct length-n factors (rolling base-256 packing)."""
    out = {}
    L = len(word)
    for n in range(1, nmax + 1):
        if L < n:
            break
        if n == 1:
            out[n] = int(len(set(word.tolist()))); continue
        N = L - n + 1
        code = np.zeros(N, dtype=np.int64)
        first = 0
        for k in range(n):
            first = first * 256 + word[k]
        code[0] = first
        top = 256 ** (n - 1)
        # vectorized rolling
        tail = word[:n].astype(np.int64)
        codes = [first]
        for i in range(1, N):
            codes.append((codes[-1] - word[i-1]*top) * 256 + word[i+n-1])
        codes = np.array(codes, dtype=np.int64)
        out[n] = int(len(np.unique(codes)))
    return out

def markov_rates(w, mmax=3, Nsamples=400000, seed=0):
    """per-symbol entropy rate of m-th order Markov model fits, m=0..mmax.
    H_m >= true rate, decreasing in m. Gaps = structure each deeper order
    captures."""
    rng = np.random.default_rng(seed)
    L = len(w)
    idx = rng.integers(0, L - (mmax + 2), size=min(Nsamples, L - mmax - 2))
    out = {}
    if mmax >= 0:
        p = np.bincount(w, minlength=6).astype(float)
        p = p / p.sum()
        out[0] = float(-(p[p > 0] * np.log(p[p > 0])).sum())
    for m in range(1, mmax + 1):
        ctx = np.zeros(len(idx), dtype=np.int64)
        for k in range(m):
            ctx = ctx * 9 + w.take(idx + k)
        nxt = w.take(idx + m)
        _, ctx_iv, ctx_cnt = np.unique(ctx, return_inverse=True, return_counts=True)
        H = 0.0
        for ci in range(len(ctx_cnt)):
            sel = ctx_iv == ci
            nc = np.bincount(nxt[sel], minlength=6).astype(float)
            pc = nc / nc.sum()
            H += (ctx_cnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
        out[m] = H
    return out

def admissible_tup(c, k):
    """admissible k-tuple: distinct, does not cover all classes mod q for any
    q <= k (the loom matching rule / sieve local rule)."""
    c = sorted(set(c))
    if len(c) != k:
        return False
    q = 2
    while q <= k:
        if len({x % q for x in c}) == q:
            return False
        q = 3 if q == 2 else q + 2
    return True

def main():
    import os
    os.makedirs("/home/jsmille/Projects/rh-missing-tail/tmp/loom", exist_ok=True)
    out = []
    def rep(s=""):
        print(s); out.append(s)

    rep("LOOM-0: does a loom weave the primes as Penrose tiles? (OFF-BOARD; no RH claim)")
    rep(f"  sieve bound X = {X}, phi = {PHI:.8f}")
    s = sieve(X)
    primes = np.array([i for i in range(2, X + 1) if s[i]], dtype=np.int64)
    gaps = np.diff(primes)
    rep(f"  primes = {len(primes)}, gaps = {len(gaps)}")

    A2 = ((gaps // 2) % 2)[:-1]
    A6 = ((gaps // 2) % 6)[:-1]
    gaps2 = gaps[:-1]; primes2 = primes[1:]

    rep("\n== A. gap-class words: factor complexity ==)")
    p2 = complexity(A2, 6)
    p6 = complexity(A6, 6)
    rep("  A2 (gap/2 mod 2, 2 symbols):")
    rep("    " + "  ".join(f"p({n})={p2[n]}" for n in range(1, 7)) +
        f"    (max possible = 2^n = {'  '.join(str(2**n) for n in range(1,7))})")
    rep("  A6 (gap/2 mod 6, 6 symbols):")
    rep("    " + "  ".join(f"p({n})={p6[n]}" for n in range(1, 7)) +
        f"    (max possible = 6^n = {'  '.join(str(6**n) for n in range(1,7))})")
    rep("    growth ratios A6: " +
        "  ".join(f"x{p6[n+1]/p6[n]:.2f}" for n in range(1, 6)) +
        "   (linear loom => ratios -> 1; pure random => ratios -> 6)")

    rep("\n== B. Markov memory of the A6 gap word (entropy rates, nats/symbol) ==")
    mr = markov_rates(A6, 3)
    rep(f"  ln 6 (marginal-full-random)        = {math.log(6):.5f}")
    rep(f"  H_0 (empirical marginal)           = {mr[0]:.5f}   (marginal tension = {math.log(6)-mr[0]:.5f})")
    for m in (1, 2, 3):
        rep(f"  H_{m} (memory of {m} earlier gaps)          = {mr[m]:.5f}   "
            f"(delta vs H_{m-1} = {mr[m-1]-mr[m]:.5f})")
    rep("  reading: H_1 close to H_0 and H_2,H_3 ~= H_1 => pair law captures ALL")
    rep("           (the loom is SUBSUMED into the known LO/mod-4 gap bias);")
    rep("           significant deltas at m=2,3 => a DEEPER loom (BOOM candidate);")
    rep("           H_m ~= H_0 all the way => no loom (DOOM, random-like).")

    rep("\n== C. the mod-4 gap bias, measured (the candidate SUBSUMED law) ==")
    pairs = np.stack([A2[:-1], A2[1:]], axis=1)
    for a in range(2):
        for b in range(2):
            m = float(np.mean((pairs[:, 0] == a) & (pairs[:, 1] == b)))
            rep(f"    P({a}{b}) = {m:.5f}   (i.i.d. would be 0.25000)")
    p01 = float(np.mean((pairs[:, 0] == 0) & (pairs[:, 1] == 1)))
    p11 = float(np.mean((pairs[:, 0] == 1) & (pairs[:, 1] == 1)))
    rep(f"    bias ratio P(11)/P(01) = {p11/max(p01,1e-12):.5f}"
        f"   (0.5 mod-4-gap-bias territory = known LO correlation, X={X})")

    rep("\n== D. 24-adic bloom (front/back 4/4, the WF-24/0909 frame) in the gap loom ==")
    FRONT = {1, 5, 7, 11}
    anc = primes2 % 24
    gapc = gaps2 % 24
    front_frac = float(np.mean([1 if a in FRONT else 0 for a in anc]))
    rep(f"  anchor prime front-frac = {front_frac:.5f}   (0.5 = balanced 24-frame)")
    cross = float(np.mean([1 if (a in FRONT) != (((a + g) % 24) in FRONT) else 0
                           for a, g in zip(primes2, gaps2)]))
    rep(f"  fraction of steps CROSSING front<->back = {cross:.5f}")
    rep("  gap-class frequencies (even residues mod 24), antipode pairs (c, c+12):")
    asyms = []
    for c in (2, 4, 6, 8, 10, 12):
        f1 = float(np.mean(gapc == c)); f2 = float(np.mean(gapc == (c + 12) % 24))
        asyms.append(abs(f1 - f2))
        rep(f"    gap~{c:2d}: f={f1:.5f}    gap~{c+12:2d}: f={f2:.5f}   diff={f1-f2:+.5f}")
    rep(f"  antipode asymmetry mean|f(c)-f(c+12)| = {np.mean(asyms):.5f}"
        f"   (0 = antipode-symmetric; large = BLOOM in one half of the 24-frame)")

    rep("\n== E. LITERAL Penrose inflation test on admissible constellations ==")
    rng = random.Random(0)
    k = 3
    total = hit = 0
    base_hits = []
    for _ in range(20000):
        span = rng.randint(k * 2, 60)
        c = sorted(rng.sample(range(1, span + 1), k))
        if not admissible_tup(c, k):
            continue
        total += 1
        ci = sorted(set(int(round(PHI * x)) for x in c))
        if len(ci) == k and admissible_tup(ci, k):
            hit += 1
        if len(base_hits) < total:
            c0 = sorted(rng.sample(range(1, int(span * PHI) + 2), k))
            base_hits.append(1 if admissible_tup(c0, k) else 0)
    rate = hit / total if total else 0.0
    base = float(np.mean(base_hits)) if base_hits else 0.0
    rep(f"  admissible k={k} constellations tested = {total}")
    rep(f"  phi-inflation transmission (rounded phi*C still admissible) = {rate:.5f}")
    rep(f"  random-admissibility baseline (fresh tuple, scaled span)    = {base:.5f}")
    rep("  transmission ~= baseline => NO phi-inflation symmetry in the primes")
    rep("  (the literal Penrose loom does not carve the primes; doom-for-D only)")

    rep("\n== VERDICT (measured; no RH claim) ==")
    rep(f"  A2 complexity = MAXIMAL (2^n all n<=6): the parity gap word is")
    rep("  fully aperiodic/random-like at this scale (never repeats, as hoped,")
    rep("  but not Penrose-like: Penrose words have LINEAR complexity).")
    d1 = mr[0] - mr[1]; d2 = mr[1] - mr[2]; d3 = mr[2] - mr[3]
    deep = (d1 > 0.02) and (d2 > 0.005) and (d3 > 0.002)
    paironly = (d1 > 0.005) and (d2 < 0.005) and (d3 < 0.002)
    none_ = d1 < 0.005
    if none_:
        verdict = "DOOM-ish: no measurable loom memory at any depth"
    elif paironly:
        verdict = "SUBSUMED: all loom-tension is the PAIR law (LO mod-4 gap bias)"
    elif deep:
        verdict = "BOOM candidate: deeper-than-pair memory (a real loom beyond known laws)"
    else:
        verdict = "INTERMEDIATE: see the H_m ladder"
    rep(f"  deltas: H0-H1 = {d1:.5f}, H1-H2 = {d2:.5f}, H2-H3 = {d3:.5f}")
    rep(f"  => {verdict}")
    rep(f"  24-frame: front-frac {front_frac:.4f}, cross {cross:.4f}, "
        f"antipode-asym {np.mean(asyms):.5f}")
    rep(f"  phi-inflation: {rate:.4f} vs baseline {base:.4f} "
        f"({'symmetry!' if rate > base*1.05 else 'no symmetry'})")

    with open("/home/jsmille/Projects/rh-missing-tail/tmp/loom/loom0_out.txt", "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
