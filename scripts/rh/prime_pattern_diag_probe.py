#!/usr/bin/env python3
"""Probe: prime gap-history identity + 24-adic Fibonacci shadow + diagonal/complexity.

Owner's idea (2026-10-28, verbatim core):
  "taylor series from backwards ... the 24-adic fibonacci pattern can sort of
   predict a future where there is a 'deficit of primes' ... each prime has an
   identity based on the spaces between primes in its history (for 5: 5-3-2,
   spaces 2-1-1) ... make Cantor's Diagonal for what the next patterns could
   be ... use the diagonal argument to help predict the spacing for the next
   primes and where they must fall."

This probe answers, with numbers, at X = 2e6 (the PRIME-BLOOM side-quest scale,
commensurable with F13):
  A. What IS the gap-history identity (information content: compression?).
  B. Factor-complexity audit of the gap word (Morse-Hedlund / sofic test:
     does a finite-state, in particular period-24 shadow, machine fit?).
  C. The diagonal witnesses: explicit distinct k-factors with p(k) > k.
  D. The shadow law test: is the next gap (mod 24) a function of the
     24-adic Fibonacci shadow state at the current prime? (deficit prediction)
  E. Short-memory skill: does the windowed history predict the NEXT gap above
     baselines? (the honest 'predict the spacing' test, baseline-scored,
     held-out upper 20%, bloom F13 protocol.)
  F. Typicality: entropy rate of the real word vs i.i.d.-from-marginals null.
All statistics are descriptive at this scale; verdicts are pre-registered
below in the plan file, not here.
"""
import math
import random
import sys
from collections import Counter, defaultdict

X = 2_000_000

def sieve(n):
    b = bytearray([1]) * (n + 1)
    b[0] = b[1] = 0
    import array
    for i in range(2, int(n ** 0.5) + 1):
        if b[i]:
            b[i * i::i] = bytearray(len(b[i * i::i]))
    return [i for i in range(n + 1) if b[i]]

def pisano(m):
    seen = {}
    a, b = 0, 1
    for k in range(m * m + 5):
        if (a, b) in seen:
            return seen[(a, b)], k - seen[(a, b)]
        seen[(a, b)] = k
        a, b = b, (a + b) % m
    raise RuntimeError

def main():
    random.seed(20261028)
    P = sieve(X)
    n = len(P)
    g = [P[i + 1] - P[i] for i in range(n - 1)]   # g[0] = 1 (2->3), rest even
    n_g = n - 1
    print(f"X = {X}   pi(X) = {n}   n_gaps (incl. g0=1) = {n_g}")

    # ---------------------------------------------------------------
    # A. The gap-history identity: information content.
    # ---------------------------------------------------------------
    print("\n--- A. gap-history identity ---")
    # Chain to 0 for p_i (i >= 2): gaps (g[i-1], g[i-2], ..., g[0], 2).
    # i.e. the FULL prime-gap record below p_i, reversed, + the constant 2->0 leg.
    assert P[2] == 5
    hist5 = tuple(g[1:: -1] + [2])   # g[1::-1] + [2] = (5-3, 3-2, 2-0)
    assert hist5 == (2, 1, 2), hist5
    print(f"history(5) = {hist5}   chain 5-3-2-0; the owner's '2-1-1' reads the final 2->0 leg as 1 (it is 2; the convention is pinned here)")
    # Full histories: the chain-lengths 1,2,3,... make every full history
    # distinct, and the history of p_j (j > i) contains a DIFFERENT order of
    # the shared prefix, so the full identity is injective == the prime's own
    # index: it compresses NOTHING.  Measure collisions of WINDOWED tails:
    for K in (1, 2, 3, 4, 6):
        tails = [tuple(g[i - K + 1: i + 1]) for i in range(K, n_g)]
        C = Counter(tails)
        print(f"  last-{K}-gap tail: distinct = {len(C):>7} / {len(tails)}   max multiplicity = {max(C.values()):>4}   collision share = {1 - len(C)/len(tails):.4f}")
    print("  e.g. history(5) = (2,1,2), the full chain 5-3-2-0 [the owner's '2-1-1' counts the final 2->0 leg as 1; it is 2] -> at scale, 'the pattern of p' = the ENTIRE prime word below p: no free information; the testable object is the WINDOWED tail (finite memory).")

    # ---------------------------------------------------------------
    # B. Factor complexity of the gap word.
    # ---------------------------------------------------------------
    print("\n--- B. factor complexity p(k) (even gaps, i = 1..n_g-1) ---")
    w = g[1:]                      # exclude g0 = 1
    N = len(w)
    # alphabet: coarse gap class (5 letters) + raw (g//2)
    def coarse(x):
        if x <= 12: return x
        if x <= 24: return 13
        if x <= 40: return 14
        return 15
    wc = [coarse(x) for x in w]
    wr = [x // 2 for x in w]       # raw, 24+ letters in practice unbounded
    def pcount(word, k):
        return len(set(tuple(word[i: i + k]) for i in range(len(word) - k + 1)))
    def iid_expect(word, k):
        fr = {a: c / len(word) for a, c in Counter(word).items()}
        from itertools import product
        tot = 0.0
        for key in product(fr, repeat=k):
            p = 1.0
            for a in key:
                p *= fr[a]
            tot += (1 - (1 - p) ** len(word))
        return tot
    for name, word, ks in (("coarse(5)", wc, [1, 2, 3, 4, 5]),
                            ("raw(g//2)", wr, [1, 2, 3])):
        print(f"  alphabet {name}:")
        for k in ks:
            p = pcount(word, k)
            mx = min(len(set(word)) ** k, N)
            exp_iid = iid_expect(word, k) if len(set(word)) <= 15 else float('nan')
            print(f"    k={k}:  p = {p:>7}   max = {mx:>7}   iid-null E[p] = {exp_iid:>10.1f}" +
                  (f"   p/max = {p/mx:.4f}" if exp_iid != exp_iid else ""))
    # shuffles (order-killed null) for raw k=2 and coarse k=3
    for name, word, k in (("raw k=2", wr, 2), ("coarse k=3", wc, 3)):
        shps = []
        for _ in range(10):
            perm = list(word)
            random.shuffle(perm)
            shps.append(pcount(perm, k))
        print(f"  shuffle null for {name}: {shps}   (vs real {pcount(word, k)})")

    # ---------------------------------------------------------------
    # C. Diagonal witnesses (Morse-Hedlund).
    # ---------------------------------------------------------------
    print("\n--- C. diagonal / aperiodicity witnesses ---")
    for k in (3, 4, 5):
        grams = list(dict.fromkeys(tuple(wc[i: i + k]) for i in range(len(wc) - k + 1)))
        need = k + 1
        ws = grams[:need]
        print(f"  k={k}: p = {len(grams)} > k={'YES' if len(grams) > k else 'NO'}   witnesses (distinct {k}-grams): {ws}")
    print("  Morse-Hedlund: p(k) > k for some k => the (coarsened) gap word is aperiodic.")
    print("  Raw-word (unbounded alphabet) aperiodicity is a THEOREM: gaps unbounded (Baker 1862) => no ultimately-periodic output on any alphabet => the diagonal against all periodic predictors wins on the FULL word.")

    # ---------------------------------------------------------------
    # D. The 24-adic Fibonacci shadow law (does the shadow state predict
    #    the next gap / its class / the deficit?).
    # ---------------------------------------------------------------
    print("\n--- D. 24-adic Fibonacci shadow state vs next gap ---")
    start, period = pisano(24)
    print(f"  Pisano(24): first repeat at k={start}, period={period}   (expect 0, 24)")
    F = [0, 1]
    for i in range(2, 30):
        F.append((F[i - 1] + F[i - 2]) % 24)
    shadow = {b: (F[b], F[b + 1]) for b in range(24)}
    bands = sorted(set(p % 24 for p in P[2:]))
    print(f"  prime bands mod 24 (p>=5): {bands}")
    # for each band b (prime class), the next-gap mod 24 distribution:
    stat = defaultdict(Counter)
    for i in range(2, n - 1):
        b = P[i] % 24
        stat[b][g[i] % 24] += 1
    print("  b : #occ | distinct g mod 24 values | top value | top share")
    for b in bands:
        c = stat[b]
        tot = sum(c.values())
        (v, f), *_ = c.most_common(1)
        print(f"  {b:>2} : {tot:>7} | {len(c):>4}                | {v:>3}       | {f/tot:.4f}")
    # deficit correlation: per-vertex 'deficit' = ln(p)*1 vs g (expected 1 prime per ln p at height p)
    resid = [math.log(P[i]) - g[i] for i in range(2, n - 1)]
    states = [shadow[P[i] % 24] for i in range(2, n - 1)]
    by = defaultdict(list)
    for r, s in zip(resid, states):
        by[s].append(r)
    # correlation of resid with shadow-state index over the 24 states (weighted mean test)
    overall = sum(resid) / len(resid)
    chi = 0.0
    for s, rs in by.items():
        m = sum(rs) / len(rs)
        chi += len(rs) * (m - overall) ** 2
    # permutation null on same grouping sizes
    nulls = []
    sizes = [len(rs) for rs in by.values()]
    for _ in range(200):
        perm = resid[:]
        random.shuffle(perm)
        chi0 = 0.0
        pos = 0
        for sz in sizes:
            chunk = perm[pos: pos + sz]; pos += sz
            m = sum(chunk) / sz
            chi0 += sz * (m - overall) ** 2
        nulls.append(chi0)
    nulls.sort()
    print(f"  per-vertex deficit resid = ln p_i - g_i: overall mean = {overall:.4f}")
    print(f"  24-shadow-state grouping chi = {chi:.1f}   vs 200-shuffle null: min {nulls[0]:.1f} / median {nulls[100]:.1f} / max {nulls[-1]:.1f}   -> shadow explains {'SOMETHING' if chi > nulls[190] else 'NOTHING'} beyond the marginal")

    # ---------------------------------------------------------------
    # E. Short-memory skill: predict g_{i+1} from windowed history.
    # ---------------------------------------------------------------
    print("\n--- E. next-gap skill (held-out upper 20%, bloom F13 protocol) ---")
    def corr(a, b):
        ma, mb = sum(a) / len(a), sum(b) / len(b)
        num = sum((x - ma) * (y - mb) for x, y in zip(a, b))
        da = math.sqrt(sum((x - ma) ** 2 for x in a))
        db = math.sqrt(sum((y - mb) ** 2 for y in b))
        return num / (da * db) if da > 0 and db > 0 else float('nan')
    idx = list(range(2, n - 2))          # predict g[i+1] from history at i
    tr = int(0.8 * len(idx))
    train, hold = idx[:tr], idx[tr:]
    # running mean of g[1..i] via prefix sums (const baseline)
    pref = [0.0] * (n_g + 1)
    for i in range(n_g):
        pref[i + 1] = pref[i] + (g[i] if i >= 1 else 0)
    mean_all = sum(g[1:]) / len(g[1:])
    pred = {k: [] for k in ["const", "prev", "prev2", "prev3", "class3mean"]}
    # class3 mean from training only
    tab = defaultdict(list)
    for i in train:
        tab[(coarse(g[i - 2]), coarse(g[i - 1]), coarse(g[i]))].append(g[i + 1])
    tabmean = {k: (sum(v) / len(v) if v else mean_all) for k, v in tab.items()}
    for i in hold:
        pred["const"].append(pref[i] / i)          # running mean up to gap i-1
        pred["prev"].append(g[i])
        pred["prev2"].append((g[i] + g[i - 1]) / 2)
        pred["prev3"].append((g[i] + g[i - 1] + g[i - 2]) / 3)
        pred["class3mean"].append(tabmean.get((coarse(g[i - 2]), coarse(g[i - 1]), coarse(g[i])), mean_all))
    actual = [g[i + 1] for i in hold]
    const_hold = [pref[i] / i for i in hold]
    out = []
    for name in ["const", "prev", "prev2", "prev3", "class3mean"]:
        pvec = pred[name]
        r = corr(pvec, actual)
        mae = sum(abs(a - b) for a, b in zip(actual, pvec)) / len(actual)
        mae0 = sum(abs(a - b) for a, b in zip(actual, const_hold)) / len(actual)
        out.append((name, r, mae, mae0))
        print(f"  {name:>12}:  r = {r:+.4f}   MAE = {mae:8.3f} (const-baseline MAE = {mae0:8.3f})")
    print("  (correlation target = raw next gap; the gap word has a strong ln-trend, so r vs a NON-trending model is trend-driven. Detrended version below.)")
    # detrended: residual of g[i+1] after subtracting ln(p_{i+1})
    rd = [g[i + 1] - math.log(P[i + 1]) for i in hold]
    out2 = []
    for name in ["prev", "prev2", "prev3", "class3mean"]:
        # detrend the predictor too: subtract ln(p_{i+1}) from prediction
        pdet = [pv - math.log(P[i + 1]) for i, pv in zip(hold, pred[name])]
        r = corr(pdet, rd)
        out2.append((name, r))
        print(f"  detrended {name:>12}:  r = {r:+.4f}")

    # ---------------------------------------------------------------
    # F. Typicality (entropy rate vs i.i.d. null, coarse alphabet).
    # ---------------------------------------------------------------
    print("\n--- F. typicality: entropy rates ---")
    def log2x(x):
        return math.log2(x) if x > 0 else 0.0
    def ent_rate(word, k):
        cnt = Counter(tuple(word[i: i + k]) for i in range(len(word) - k + 1))
        Nw = len(word) - k + 1
        return -sum((c / Nw) * log2x(c / Nw) for c in cnt.values()) / k
    h1 = ent_rate(wc, 1); h2 = ent_rate(wc, 2); h3 = ent_rate(wc, 3)
    print(f"  coarse word: H1 = {h1:.4f}  H2/2 = {ent_rate(wc, 2)/2:.4f}  H3/3 = {ent_rate(wc, 3)/3:.4f}  bits/letter  (dip = order structure above marginals)")
    sh = [wc[random.randrange(len(wc))] for _ in range(len(wc))]
    print(f"  shuffle null: H1 = {ent_rate(sh, 1):.4f}  H2/2 = {ent_rate(sh, 2)/2:.4f}  H3/3 = {ent_rate(sh, 3)/3:.4f}")

    print("\ndone.")

if __name__ == "__main__":
    main()
