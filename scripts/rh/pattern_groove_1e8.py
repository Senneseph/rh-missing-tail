#!/usr/bin/env python3
"""Groove batch 2 (X = 1e8): X11b retrocausality at scale, X4 complexity at
scale, X13 distance-one score at scale, step-deficit whiteness at scale.

Single core, a few minutes.
"""
import math, sys, traceback
from collections import defaultdict, Counter

X = 100_000_000

def coarse(x):
    return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))

def section(name, fun):
    print(f"\n=== {name} ===", flush=True)
    try:
        fun()
    except Exception:
        print("SECTION ERROR:")
        traceback.print_exc()

def main():
    # sieve 1e8
    import time
    t0 = time.time()
    b = bytearray([1]) * (X + 1); b[0] = b[1] = 0
    i = 2
    while i * i <= X:
        if b[i]:
            b[i * i::i] = bytearray(len(b[i * i::i]))
        i += 1
    P = [j for j in range(X + 1) if b[j]]
    n = len(P)
    print(f"X = {X}   pi = {n}   sieve {time.time()-t0:.1f}s", flush=True)
    g = [0] * (n - 1)
    for i in range(n - 1):
        g[i] = P[i + 1] - P[i]

    idx = list(range(2, n - 8))
    tr = int(0.8 * n)
    hold = idx[tr:]

    def mae(pred):
        e = 0.0
        for i in hold:
            e += abs(g[i] - pred(i))
        return e / len(hold)

    # --------- X11b: retrocausality at 1e8 ---------
    def x11b():
        tabC = defaultdict(list); tabCp = defaultdict(list)
        for i in hold:
            tabC[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))].append(i)
            tabCp[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2]))].append(i)
        S = 50.0
        muC = {k: sum(g[i] for i in v) / len(v) for k, v in tabC.items()}
        muCp = {k: sum(g[i] for i in v) / len(v) for k, v in tabCp.items()}
        gmean = sum(g[2:n - 8]) / (n - 10)
        def predC(i):
            k = (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))
            c = len(tabC[k])
            return (c * muC[k] + S * gmean) / (c + S)
        def predCp(i):
            k = (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2]))
            c = len(tabCp[k])
            return (c * muCp[k] + S * gmean) / (c + S)
        base = mae(lambda i: gmean)
        cmae = mae(predC)
        cpmae = mae(predCp)
        print(f"  constant MAE      = {base:8.4f}")
        print(f"  causal C MAE      = {cmae:8.4f}   skill = {100*(base-cmae)/base:+.2f}%")
        print(f"  noncausal C+ MAE  = {cpmae:8.4f}   skill = {100*(base-cpmae)/base:+.2f}%")
        print(f"  RETROCAUSAL GAIN  = {cmae-cpmae:+.4f} MAE = {100*(cmae-cpmae)/cmae:+.3f}% of causal MAE  "
              f"({'NOISE/axiom holds' if (cmae-cpmae) < 0.005*base else 'VIOLATION? axiom broken at 1e8'})")
    section("X11b: the void's axiom at 1e8 (retrocausal gain on the centered gap)", x11b)

    # --------- step-deficit whiteness at 1e8 ---------
    def x14b():
        # lag-1,2 correlation of r_i = g[i] - ln P[i+1] (full, via accumulation)
        N = n - 8
        s1 = s2 = t1 = t2 = tt = 0.0
        prev = prev2 = None
        r_prev = r_prev2 = None
        vals = []
        for i in range(2, N):
            r = g[i] - math.log(P[i + 1])
            if r_prev is not None:
                s1 += r * r_prev; t1 += r * r; t2 += r_prev * r_prev
            if r_prev2 is not None:
                s2 += r * r_prev2
            vals.append(r)
            r_prev2 = r_prev; r_prev = r
        c1 = (s1 - math.sqrt(t1 * t2)) / math.sqrt((t1 - math.sqrt(t1 * t2)) ** 2 + 1) if False else None
        # simpler: recompute means
        m = sum(vals) / len(vals)
        var = sum((x - m) ** 2 for x in vals) / len(vals)
        c1b = sum((vals[i] - m) * (vals[i - 1] - m) for i in range(1, len(vals))) / (len(vals) * var)
        c2b = sum((vals[i] - m) * (vals[i - 2] - m) for i in range(2, len(vals))) / (len(vals) * var)
        print(f"  step-deficit lag1 = {c1b:+.4f}   lag2 = {c2b:+.4f}   (2e6 was -0.056/-0.025)")
    section("step-deficit whiteness at 1e8", x14b)

    # --------- X4: complexity at 1e8 ---------
    def x4():
        N = n - 3
        w = [coarse(g[i + 1]) for i in range(N)]
        c1 = Counter(w)
        c2 = Counter(zip(w, w[1:]))
        c3 = Counter(zip(w, w[1:], w[2:]))
        H1 = -sum(c / N * math.log2(c / N) for c in c1.values())
        H2 = -sum(c / (N - 1) * math.log2(c / (N - 1)) for c in c2.values())
        H3 = -sum(c / (N - 2) * math.log2(c / (N - 2)) for c in c3.values())
        print(f"  p(2) = {len(c2)/N:.4f}   (2e6 was 0.1458)")
        print(f"  p(3) = {len(c3)/(N-1):.4f}   (2e6 was 0.1270)")
        print(f"  H1 = {H1:.4f}   2H1 - H2 = {2*H1-H2:+.4f} bits (per 2-gram; i.i.d. null = 0)")
        print(f"  H1 - H3/3 = {H1-H3/3:+.4f} bits per letter (3-order excess; 2e6 was +0.569 per 3-letter via H1-H3/3... recompute there too)")
    section("X4: the word's complexity at 1e8", x4)

    # --------- X13: distance-one score at 1e8 + X8 AUC at 1e8 ---------
    def x13():
        smalls = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43]
        tab = defaultdict(lambda: [0, 0.0])
        # twin share per D: iterate all
        for i in range(2, n - 1):
            p = P[i]
            d = 0
            for q in smalls:
                r = p % q
                if r == 1 or r == q - 1:
                    d += 1
            t = tab[d]
            t[0] += 1
            if g[i] == 2:
                t[1] += 1
        print("  D-class twin share at 1e8 (vs 2e6: 0.0574 .. 0.1678):")
        for d in sorted(tab):
            c, t = tab[d]
            if c > 50:
                print(f"    D = {d}: n = {c:<7} twin share = {t/c:.4f}")
        # AUC of the hard blocker (q <= 31) on the holdout
        def auc(scores, labels):
            pairs = sorted(zip(scores, labels))
            m0 = sum(1 for _, y in pairs if y == 0); m1 = len(pairs) - m0
            ranks = [0.0] * len(pairs); i = 0; r = 1.0
            while i < len(pairs):
                j = i
                while j < len(pairs) and pairs[j][0] == pairs[i][0]:
                    j += 1
                avg = (r + r + (j - i) - 1) / 2.0
                for k in range(i, j):
                    ranks[k] = avg; r += 1
                i = j
            pr = sum(rk for rk, (_, y) in zip(ranks, pairs) if y == 1)
            return (pr - m1 * (m1 + 1) / 2) / (m1 * m0)
        Q = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
        sc = [float(1 - any(P[i] % q == q - 2 for q in Q)) for i in hold]
        lb = [1 if g[i] == 2 else 0 for i in hold]
        print(f"  hard-blocker AUC (q <= 31) at 1e8: {auc(sc, lb):.4f}   (2e6 was 0.9392)")
    section("X13: the distance-one score at 1e8", x13)

    print("\ndone.", flush=True)

if __name__ == "__main__":
    main()
