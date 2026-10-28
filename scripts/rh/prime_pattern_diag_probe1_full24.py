#!/usr/bin/env python3
"""Probe 1: FULL 24-adic history as the predictor state (seed 4 follow-up).

Absolute sense:  node_s(p) = p mod 24^s  (s = 1..3).  d_0 = the band (the
known null, r ~ 0); d_1 = the mod-5 residue of p (24 = -1 mod 5), d_2 =
the mod-289... structure: digits ABOVE d_0 ARE the small-prime residues
of p (the higher sieve wheels).  Test: does conditioning the next gap /
twin event on m_2, m_3 beat the band + trend baselines?

Relative sense:  the gap word read in base 24, windowed (full identity =
everything again, so windowed tails at EXACT-gap resolution, K = 1..8;
gaps >= 24 collapse to one class 'L').

Both:            composite state (m_2(p), exact last 3 gaps).

A-priori sieve check: twins (p+2) are IMPOSSIBLE for p = 3 mod 5 — the
d_1 digit should carry that (twin share by p mod 5).
Protocol: bloom F13 / seed-4 E — held-out upper 20%, detrended vs
ln(p_{i+1}) baseline, r + MAE.
"""
import math
import random
from collections import Counter, defaultdict

X = 2_000_000

def sieve(n):
    b = bytearray([1]) * (n + 1); b[0] = b[1] = 0
    for i in range(2, int(n ** 0.5) + 1):
        if b[i]: b[i * i::i] = bytearray(len(b[i * i::i]))
    return [i for i in range(n + 1) if b[i]]

def corr(a, b):
    ma, mb = sum(a) / len(a), sum(b) / len(b)
    num = sum((x - ma) * (y - mb) for x, y in zip(a, b))
    da = math.sqrt(sum((x - ma) ** 2 for x in a))
    db = math.sqrt(sum((y - mb) ** 2 for y in b))
    return num / (da * db) if da > 0 and db > 0 else float('nan')

def main():
    random.seed(20261028)
    P = sieve(X)
    n = len(P)
    g = [P[i + 1] - P[i] for i in range(n - 1)]
    n_g = n - 1
    print(f"X = {X}   pi = {n}")

    idx = list(range(2, n - 2))
    tr = int(0.8 * len(idx))
    train, hold = idx[:tr], idx[tr:]
    # running mean of gaps (trend baseline)
    pref = [0.0] * (n_g + 1)
    for i in range(n_g):
        pref[i + 1] = pref[i] + (g[i] if i >= 1 else 0)
    rmean = lambda i: pref[i] / i

    # ---- a-priori sieve check: twin share by p mod 5 (whole sample) ----
    print("\n--- a-priori sieve check: twin share by p mod 5 (expect ~0 at class 3) ---")
    by5 = defaultdict(list)
    byd = defaultdict(list)
    for i in range(2, n - 1):
        by5[P[i] % 5].append(1 if g[i] == 2 else 0)
        byd[(P[i] % 24, (P[i] // 24) % 24)].append(1 if g[i] == 2 else 0)
    for c5 in (1, 2, 3, 4):
        xs = by5[c5]
        print(f"  p mod 5 = {c5}:  n = {len(xs):>7}   twin share = {sum(xs)/len(xs):.4f}"
              + ("   <-- p+2 = 0 mod 5: BLOCKED (a priori)" if c5 == 3 else ""))

    # ---- helpers: shrinkage table means with fallback chain ----
    def fit(fallback):
        tab = defaultdict(list)
        for i in train:
            tab[fallback(i)].append(g[i + 1])
        mean = {k: sum(v) / len(v) for k, v in tab.items()}
        return mean
    def predict(statefun, fallback, i, default):
        s = statefun(i)
        return fallback.get(s, default(i))

    def report(name, pvec_i):
        act = [g[i + 1] for i in hold]
        pred = [pvec_i(i) for i in hold]
        lnbl = [math.log(P[i + 1]) for i in hold]
        rd = [a - l for a, l in zip(act, lnbl)]
        pdet = [q - l for q, l in zip(pred, lnbl)]
        r_ln = corr(pdet, rd)
        mae = sum(abs(a - q) for a, q in zip(act, pred)) / len(act)
        mae_ln = sum(abs(a - l) for a, l in zip(act, lnbl)) / len(act)
        print(f"  {name:<34}:  r vs ln-detrend = {r_ln:+.4f}   MAE = {mae:8.4f}   (ln-baseline MAE = {mae_ln:8.4f})")

    # ---- baselines ----
    print("\n--- baselines (held-out upper 20%) ---")
    report("const (running mean)", rmean)
    report("ln trend (1/rho)", lambda i: math.log(P[i + 1]))
    report("prev raw gap", lambda i: g[i])
    # 3-coarse-class champion from probe 0
    def coarse(x):
        return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))
    c3 = fit(lambda i: (coarse(g[i]), coarse(g[i - 1]), coarse(g[i - 2])))
    report("3-coarse-class tail (probe-0 champ)",
           lambda i: c3.get((coarse(g[i]), coarse(g[i - 1]), coarse(g[i - 2])), rmean(i)))

    # ---- ABSOLUTE: node_s = p mod 24^s (s = 1, 2, 3) ----
    print("\n--- absolute: m2 = p mod 576, m3 = p mod 13824 (higher digits = small-prime residues) ---")
    gmean = sum(g[1:]) / len(g[1:])
    band = fit(lambda i: P[i] % 24)
    m2 = fit(lambda i: P[i] % 576)
    m3 = fit(lambda i: P[i] % 13824)
    report("band (= p mod 24, the known null)",
           lambda i: band.get(P[i] % 24, rmean(i)))
    # m2 with shrinkage: (n * m2mean + k * bandmean) / (n + k)
    m2n = Counter(P[i] % 576 for i in train)
    def sh2(i):
        s = P[i] % 576
        if s in m2:
            b = band.get(s % 24, gmean)
            n2 = m2n[s]
            return (n2 * m2[s] + 30.0 * b) / (n2 + 30.0)
        return band.get(s % 24, rmean(i))
    report("m2 shrink-to-band (k=30)", sh2)
    n3 = Counter(P[i] % 13824 for i in train)
    def sh3(i):
        s = P[i] % 13824
        if s in m3:
            p2 = (s % 576, )
            base = m2.get(s % 576, band.get(s % 24, gmean))
            n3c = n3[s]
            return (n3c * m3[s] + 30.0 * base) / (n3c + 30.0)
        return sh2(i)
    report("m3 shrink-to-m2 (k=30)", sh3)
    # explicit mod-5 conditioning: p mod 5 = (d0 - d1) mod 5
    by5t = fit(lambda i: P[i] % 5)
    report("p mod 5 only (d0-d1, the twin blocker)",
           lambda i: by5t.get(P[i] % 5, rmean(i)))
    # band x mod5 (the 8x4=32 admissible nodes)
    b5 = fit(lambda i: (P[i] % 24, P[i] % 5))
    report("band x (p mod 5) [32 nodes]",
           lambda i: b5.get((P[i] % 24, P[i] % 5), band.get(P[i] % 24, rmean(i))))

    # ---- target: twin indicator (the discrete sieve target) ----
    print("\n--- twin-indicator target (binary; AUC via rank = Mann-Whitney u) ---")
    def auc(score_i):
        # rank-based AUC of score vs twin=1 on holdout
        pairs = sorted(((score_i(i), 1 if g[i] == 2 else 0) for i in hold))  # twin FROM P[i]: gap g[i] == 2
        m0 = sum(1 for _, y in pairs if y == 0)
        m1 = len(pairs) - m0
        rank_sum = 0.0
        i = 0
        ranks = [0.0] * len(pairs)
        r = 1.0
        while i < len(pairs):
            j = i
            while j < len(pairs) and pairs[j][0] == pairs[i][0]:
                j += 1
            avg = (r + r + (j - i) - 1) / 2.0
            for k in range(i, j):
                ranks[k] = avg
                r += 1
            i = j
        pos_rank = sum(rk for rk, (_, y) in zip(ranks, pairs) if y == 1)
        return (pos_rank - m1 * (m1 + 1) / 2) / (m1 * m0)
    def auc_report(name, score_i):
        print(f"  {name:<34}:  AUC = {auc(score_i):.4f}   (random = 0.5)")
    auc_report("band", lambda i: band.get(P[i] % 24, 0.0))
    auc_report("p mod 5 (twin blocker)", lambda i: 0.0 if P[i] % 5 == 3 else 1.0)
    auc_report("p mod 5, graded (a-priori weights)",
               lambda i: {1: 1.0, 2: 0.9, 3: 0.0, 4: 1.0}[P[i] % 5])
    auc_report("band x mod5", lambda i: b5.get((P[i] % 24, P[i] % 5), 0.0))
    # the a-priori twin score: product of small-modulus blockers (5, 7, 11)
    def a_priori_twin(i):
        p = P[i]
        w = 1.0
        for m in (5, 7, 11):
            c = p % m
            w *= (1.0 if (c + 2) % m not in (0,) else 0.0)   # blocked if p+2 = 0 mod m
            # also count the 'near-block' density: how many of {1..m-1} classes pair
        # simple graded: fraction of classes c' != 0 with c'+2 != 0 mod m is (m-2)/(m-1)
        return w
    auc_report("a-priori blocker score (5,7,11)", a_priori_twin)

    # ---- RELATIVE: exact-gap tails K = 1..8 (gaps >= 24 -> 'L') ----
    print("\n--- relative: exact-gap tails, K = 1..8 (gap>=24 -> 'L') ---")
    def rgap(x):
        return x if x <= 24 else 97   # 97 marks 'large'
    for K in (1, 2, 3, 4, 6, 8):
        tab = defaultdict(list)
        cnt = Counter()
        for i in train:
            s = tuple(rgap(g[i - q]) for q in range(K))
            tab[s].append(g[i + 1])
            cnt[s] += 1
        mean = {k: sum(v) / len(v) for k, v in tab.items()}
        def pred(i, K=K, mean=mean, tab=tab, cnt=cnt):
            s = tuple(rgap(g[i - q]) for q in range(K))
            if s in mean and cnt[s] >= 10:
                return mean[s]
            # fallback: drop the oldest exact gap, fall back coarsely
            s2 = tuple(coarse(v if v <= 24 else 40) for v in (g[i - q] for q in range(K)))
            return c3.get(s2[-3:], rmean(i))
        report(f"exact-gap tail K={K} (fallback to c3)", pred)

    # ---- BOTH: blended composite (m2-shrink absolute) x (coarse tail relative) ----
    print("\n--- both: blended composite (absolute m2-shrink, relative c3-tail) ---")
    def blend(i):
        return 0.5 * sh2(i) + 0.5 * c3.get((coarse(g[i]), coarse(g[i - 1]), coarse(g[i - 2])), rmean(i))
    report("blend 0.5*m2shrink + 0.5*c3tail", blend)

    # ---- CENTRAL orbit state: the last 24 ABSOLUTE steps (576 units) ----
    print("\n--- central: local density over the last 24 absolute steps (576 units) ---")
    import bisect
    def d_local(i):
        lo = bisect.bisect_right(P, P[i] - 576)
        c = i - lo
        return c / 576.0 if c > 0 else 1 / math.log(P[i])
    def pred_central(i):
        return 1.0 / d_local(i)
    report("central: 1/d_local (last 24 absolute steps)", pred_central)

    # ---- FUTURE-FRAME demo: the per-step predicted pattern CHANGES each step ----
    print("\n--- future frame: per-step predicted pattern (demo, 3 primes) ---")
    for i in (10000, 60000, 110000):
        p = P[i]
        # F_REL: predicted next-24 gaps (1/rho at the running height, step-
        # dependent mod-5 twin-blocker shift: no gap-2 from h = 3 mod 5)
        h = float(p)
        fut = []
        for j in range(24):
            gap = math.log(h)                       # local mean gap
            if int(h) % 5 == 3: gap += 0.44         # twin mass shifts to >= 4
            fut.append(round(gap, 3))
            h += gap
        f24 = " ".join(f"{v:7.3f}" for v in fut[:8])
        # F_ABS: expected count per next 24-unit revolution (8 prime bands)
        exp_ct = [round(8.0 / math.log(p + 24 * (k + 1)), 4) for k in range(4)]
        print(f"  p = {p}:  wheel d0 = {p % 24}   F_REL step 1..8 = {f24}  [...]")
        print(f"      F_ABS expected count, next 4 revolutions = {exp_ct}   (changes each step: the ln density + the wheel phase)")

    print("\ndone.")

if __name__ == "__main__":
    main()
