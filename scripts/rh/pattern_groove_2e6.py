#!/usr/bin/env python3
"""Groove batch 1 (X = 2e6): X6 deficit signature, X7 cross-frame,
X8 twin-score saturation, X14 martingale/whiteness, X2 seeded-/5-fib.

All fast; single sieve pass.
"""
import math
import random
from collections import Counter, defaultdict

X = 2_000_000
random.seed(20261028)

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

def coarse(x):
    return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))

def main():
    P = sieve(X)
    n = len(P)
    g = [P[i + 1] - P[i] for i in range(n - 1)]
    print(f"X = {X}   pi = {n}")
    idx = list(range(2, n - 30))
    tr = int(0.8 * len(idx))
    train, hold = idx[:tr], idx[tr:]

    # ============ X6: the deficit signature (realized - theory, 24 steps) ============
    print("\n=== X6: deficit signature (24-step realized span - theory span) ===")
    def theory_span(i, J=24):
        h = float(P[i])
        s = 0.0
        for j in range(J):
            gap = math.log(h) + (0.44 if int(h) % 5 == 3 else 0.0)
            s += gap
            h += gap
        return s
    S = []
    Si = {}
    for i in idx:
        real = P[i + 24] - P[i]
        th = theory_span(i)
        Si[i] = real - th
        S.append((i, real - th))
    Svals = [v for _, v in S]
    m, sd = sum(Svals) / len(Svals), math.sqrt(sum((v - sum(Svals) / len(Svals)) ** 2 for v in Svals) / len(Svals))
    print(f"  window deficit S(i) = realized span - theory span: mean = {m:+.3f}  std = {sd:.3f}  (units; ~24*ln ~ 350 scale)")
    # per-step signature stats
    st = []
    for i in idx[:5000]:
        h = float(P[i])
        for j in range(24):
            gap = math.log(h) + (0.44 if int(h) % 5 == 3 else 0.0)
            st.append(g[i + j] - gap)
            h += gap
    stm = sum(st) / len(st)
    print(f"  per-step residual: mean = {stm:+.4f}  (theory fit bias)   std = {math.sqrt(sum((v-stm)**2 for v in st)/len(st)):.3f}")
    # NOTE: the sliding window deficit S(i) shares 23/24 steps with S(i+1), so it is a
    # random-walk object by construction (high lag corr is EXPECTED, not memory).
    # The WHITE test is on the PER-STEP residual (X14 below). Here: its lag-8 shape is
    # the random-walk fingerprint (rho(k) ~ 1 - k/N for a walk) - checked and noted.
    def acf(x, lags=(1, 2, 3, 4, 8)):
        out = []
        for L in lags:
            out.append(corr(x, x[L:]) if len(x) > L else float('nan'))
        return out
    a_real = acf(Svals)
    print("  window-deficit lag corr 1..8 (random-walk fingerprint expected, OVERLAPPING windows):",
          "  ".join(f"{a:+.3f}" for a in a_real))
    # the STEP deficit (true clatter): d(i) = g[i] - theory step at the walk height
    steps = []
    for i in idx:
        h = float(P[i])
        steps.append(g[i] - (math.log(h) + (0.44 if int(h) % 5 == 3 else 0.0)))
    a_step = acf(steps)
    sh = steps[:]
    nulls = []
    for _ in range(100):
        random.shuffle(sh)
        nulls.append(corr(sh, sh[1:]))
    print("  STEP-deficit autocorr lags 1,2,3,4,8:", "  ".join(f"{a:+.3f}" for a in a_step))
    print(f"  shuffle-null step lag-1 range: {min(nulls):+.3f} .. {max(nulls):+.3f}   (|real| inside = WHITE given theory)")
    # skew
    sk = sum((v - m) ** 3 for v in Svals) / (len(Svals) * sd ** 3)
    print(f"  skew of S: {sk:+.3f}  (0 = gaussian-shaped clatter)")

    # ============ X7: cross-frame (state -> window-deficit class) ============
    print("\n=== X7: cross-frame: does the state beat theory-alone on the realized future? ===")
    # target: S(i) in upper tertile of |deviation|... use sign-tertile of S
    import bisect
    sv = sorted(v for _, v in S)
    t1, t2 = sv[len(sv) // 3], sv[2 * len(sv) // 3]
    def terr(i):
        v = Si[i]
        return 0 if v < t1 else (1 if v < t2 else 2)
    smalls = [q for q in P if q <= 43]
    d1c = {p: sum(1 for q in smalls if p % q in (1, q - 1)) for p in set(P[i] for i in idx)}
    # shrinkage prediction of S per state (from train); predict on hold
    def make_pred(keyfun, shrink=30.0, globalm=0.0):
        tab = defaultdict(list)
        for i in train:
            tab[keyfun(i)].append(Si[i])
        mean = {k: sum(v) / len(v) for k, v in tab.items()}
        cnt = Counter(keyfun(i) for i in train)
        def pred(i):
            k = keyfun(i)
            if k in mean and cnt[k] >= 8:
                return (cnt[k] * mean[k] + shrink * globalm) / (cnt[k] + shrink)
            return globalm
        return pred
    gmean = m
    preds = {
        "theory alone (0)": lambda i: 0.0,
        "band": make_pred(lambda i: P[i] % 24),
        "D-class <=43": make_pred(lambda i: d1c[P[i]]),
        "c3 tail": make_pred(lambda i: (coarse(g[i]), coarse(g[i-1]), coarse(g[i-2]))),
    }
    print("  MAE of S (theory scale ~ std):")
    for name, pred in preds.items():
        e = sum(abs(Si[i] - pred(i)) for i in hold) / len(hold)
        e0 = sum(abs(Si[i]) for i in hold) / len(hold)
        print(f"    {name:<16}: MAE = {e:8.3f}   (theory-alone MAE = {e0:8.3f},  skill = {100*(e0-e)/e0:+.2f}%)")
    # composite
    def comp(i):
        return (preds["band"](i) + preds["D-class <=43"](i) + preds["c3 tail"](i)) / 3.0
    e = sum(abs(Si[i] - comp(i)) for i in hold) / len(hold)
    e0 = sum(abs(Si[i]) for i in hold) / len(hold)
    print(f"    composite (mean)  : MAE = {e:8.3f}   skill = {100*(e0-e)/e0:+.2f}%")

    # ============ X8: twin-score saturation curve = ============
    print("\n=== X8: twin a-priori score saturation (more small primes = more -2 blockers) ===")
    def auc(scores, labels):
        pairs = sorted(zip(scores, labels))
        m0 = sum(1 for _, y in pairs if y == 0); m1 = len(pairs) - m0
        ranks = [0.0] * len(pairs); i = 0; r = 1.0
        while i < len(pairs):
            j = i
            while j < len(pairs) and pairs[j][0] == pairs[i][0]: j += 1
            avg = (r + r + (j - i) - 1) / 2.0
            for k in range(i, j):
                ranks[k] = avg; r += 1
            i = j
        pr = sum(rk for rk, (_, y) in zip(ranks, pairs) if y == 1)
        return (pr - m1 * (m1 + 1) / 2) / (m1 * m0)
    qset = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
    print("  AUC of the hard blocker score (p = -2 mod q for any q in Q):")
    for k in range(1, len(qset) + 1):
        Q = qset[:k]
        sc = [float(1 - any(P[i] % q == q - 2 for q in Q)) for i in hold]
        lb = [1 if g[i] == 2 else 0 for i in hold]
        print(f"    Q = {{{', '.join(str(q) for q in Q)}}}:  AUC = {auc(sc, lb):.4f}")
    # graded: weight = product (1 - blocker) with the classical twin weight per q
    Qall = qset
    def graded(i):
        w = 1.0
        for q in Qall:
            if P[i] % q == q - 2:
                w *= 0.0
            else:
                w *= (q - 2) / (q - 1)   # fraction of free classes that survive the +2 step
        return w
    lb = [1 if g[i] == 2 else 0 for i in hold]
    print(f"  graded singular-series-style score (all q <= 31): AUC = {auc([graded(i) for i in hold], lb):.4f}")

    # ============ X14: martingale / whiteness ============
    print("\n=== X14: the clatter's whiteness (per-step residual r_i = g[i] - ln P[i+1]) ===")
    r = [g[i] - math.log(P[i + 1]) for i in idx]
    ar = acf(r)
    sh2 = r[:]
    nulls2 = []
    for _ in range(100):
        random.shuffle(sh2)
        nulls2.append(corr(sh2, sh2[1:]))
    print("  residual autocorr lags 1,2,3,4,8:", "  ".join(f"{a:+.3f}" for a in ar))
    print(f"  shuffle-null lag-1: {min(nulls2):+.3f} .. {max(nulls2):+.3f}")
    # does state-conditioning whiten more? demean by (band, c2) state means
    tab = defaultdict(list)
    for i, x in zip(idx, r):
        tab[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))].append(x)
    mean = {k: sum(v) / len(v) for k, v in tab.items()}
    rc = [r[j] - mean.get((P[idx[j]] % 24, coarse(g[idx[j] - 1]), coarse(g[idx[j] - 2])), 0.0) for j in range(len(idx))]
    ar2 = acf(rc)
    vr = sum(x * x for x in r) / len(r)
    vc = sum(x * x for x in rc) / len(rc)
    print("  after state-demeaning (band, 2-gap): autocorr lags 1,2,3,4,8:", "  ".join(f"{a:+.3f}" for a in ar2))
    print(f"  clatter variance: raw {vr:.3f} -> state-cond {vc:.3f}  (state explains {100*(1-vc/vr):.1f}% of the variance)")

    # ============ X2: the seeded-/5 fib shadow vs the block deficit ============
    print("\n=== X2: the seeded-/5 Fibonacci shadow (the last untested fib state) ===")
    # HONEST fib state: the actual Fibonacci pair mod 5 NEVER enters the 4-cycle orbit
    # from seed (0,1) (the 20 pairs of the cycle are checked below) - so the shadow at
    # block index k is the CYCLE POSITION k mod 20 (a 20-state periodic word). Test that.
    F = [0, 1]
    for i in range(2, 200): F.append((F[i - 1] + F[i - 2]) % 5)
    pairs20 = {(F[k], F[k + 1]) for k in range(20)}
    f4 = {(1, 3), (3, 4), (4, 2), (2, 1)}
    print(f"  4-cycle orbit reachable by the fib pair from (0,1): {bool(pairs20 & f4)}  (False = shadow = cycle position k mod 20)")
    def fibstate(k):
        return k % 20
    # fixed-height windows of L = 27000 over [200000, X]
    L = 27000
    a0 = 200000
    nb = (X - a0) // L
    defbis = [(pi, pi2) for (pi, pi2) in [(0, 0)]]
    # pi(x) via bisect
    import bisect as B
    blocks = []
    for k in range(nb):
        a = a0 + k * L
        b = a + L
        mid = (a + b) / 2
        pred = (b - a) / math.log(mid)
        act = B.bisect_left(P, b) - B.bisect_left(P, a)
        blocks.append((k, pred - act, P[bisect.bisect_left(P, a)] % 24, fibstate(k)))
    dvals = [b[1] for b in blocks]
    def chi_group(groups):
        overall = sum(dvals) / len(dvals)
        chi = sum(len(v) * ((sum(v) / len(v)) - overall) ** 2 for v in groups.values() if len(v) > 2)
        return chi
    g_fib = defaultdict(list); g_band = defaultdict(list)
    for k, d, band, fs in blocks:
        g_fib[fs].append(d); g_band[band].append(d)
    # also the 5-state class (k mod 5) for the owner's '5 state classes' reading
    g_fib5 = defaultdict(list)
    for k, d, band, fs in blocks:
        g_fib5[k % 5].append(d)
    chi_fib = chi_group(g_fib); chi_band = chi_group(g_band); chi_fib5 = chi_group(g_fib5)
    sizes_fib = [len(v) for v in g_fib.values()]
    nulls3 = []
    for _ in range(200):
        perm = dvals[:]
        random.shuffle(perm)
        pos = 0; groups = {}
        for k, d, band, fs in blocks:
            pass
        # rebuild with perms assigned to the fib group sizes
        groups = {}
        pos = 0
        for k, d, band, fs in blocks:
            groups.setdefault(fs, []).append(perm[pos]); pos += 1
        nulls3.append(chi_group(groups))
    nulls3.sort()
    print(f"  blocks = {nb}  (L = {L})")
    print(f"  deficit grouped by FIB CYCLE POSITION (k mod 20): chi = {chi_fib:.1f}  (66 blocks, ~3 per position)")
    print(f"  deficit grouped by 5-state class (k mod 5)      : chi = {chi_fib5:.1f}")
    print(f"  deficit grouped by BAND (height mod 24)         : chi = {chi_band:.1f}")
    print(f"  fib-null (200 shuffles, k-mod-20 grouping): median {nulls3[100]:.1f} / max {nulls3[-1]:.1f}")
    print(f"  => fib cycle position carries {'SOMETHING beyond shuffle' if chi_fib > nulls3[190] else 'NOTHING beyond the marginal'};  "
          f"band chi {'>' if chi_band > chi_fib else '<='} fib chi ({chi_band:.1f} vs {chi_fib:.1f})")
    print("done.")

if __name__ == "__main__":
    main()
