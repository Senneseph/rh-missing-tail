#!/usr/bin/env python3
"""Probe 2 (X11 preflight + X10a): the VOID axiom, made measurable.

The owner's mediation axiom (2026-10-28, verbatim core): the 24-adic
melody is playing; the primes are jazz hits that "pop into definition"
in the entropic thermodynamic rattling; BEFORE they appear they do NOT
influence the pattern — only the integers that show up before the prime
happens.

X11  RETROCAUSALITY TEST (smoother-predictor gap):
      predict the CENTERED gap g[i] (the jazz hit at p_i) from
      causal state    C = (band(p_i), last 2 gap classes)
      noncausal state C+ = C + (next 2 gap classes)
      (the band/p-position of p_i is "shown" at the moment of
      occurrence — causal by the axiom).
      retrocausal gain = MAE(C) - MAE(C+)  and r(C+) - r(C):
      ~0  =>  the axiom holds at this scale (the future carries no
              information about the past beyond the state);
      >0  =>  a two-sided structure exists; the causal state must be
              enlarged (the amount is the violation size).
X10a MUSIC-CLATTER ENTROPY BUDGET (coarse gap word):
      H1 (total) = MUSIC share (wheel/band structure:
      H1 - H(gap | band)) + CLATTER share (H(gap | band), the
      rattling inside the melody). The 'hits' = the rare large-gap
      class (gaps >= 24).
      A first-law bookkeeping for the word: music + clatter = total.
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

def coarse(x):
    return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))

def main():
    random.seed(20261028)
    P = sieve(X)
    n = len(P)
    g = [P[i + 1] - P[i] for i in range(n - 1)]
    n_g = n - 1
    print(f"X = {X}   pi = {n}")

    idx = list(range(3, n - 4))
    tr = int(0.8 * len(idx))
    train, hold = idx[:tr], idx[tr:]

    def fit(key):
        tab = defaultdict(list)
        for i in train:
            tab[key(i)].append(g[i])
        cnt = Counter(key(i) for i in train)
        mean = {k: sum(v) / len(v) for k, v in tab.items()}
        return mean, cnt

    bandmean, _ = fit(lambda i: P[i] % 24)
    gmean = sum(g[1:]) / len(g[1:])
    K = 30.0

    # explicit shrinkage predictors
    c_tab, c_cnt = fit(lambda i: (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2])))
    nc_tab, nc_cnt = fit(lambda i: (P[i] % 24, coarse(g[i - 2]), coarse(g[i - 1]),
                                    coarse(g[i + 1]), coarse(g[i + 2])))

    act = [g[i] for i in hold]

    def pred_causal(i):
        k = (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))
        if k in c_tab and c_cnt[k] >= 10:
            b = P[i] % 24
            return (c_cnt[k] * c_tab[k] + K * bandmean.get(b, gmean)) / (c_cnt[k] + K)
        return bandmean.get(P[i] % 24, gmean)

    def pred_noncausal(i):
        k = (P[i] % 24, coarse(g[i - 2]), coarse(g[i - 1]),
             coarse(g[i + 1]), coarse(g[i + 2]))
        if k in nc_tab and nc_cnt[k] >= 10:
            # fallback parent: drop the two future features
            p = (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))
            base = c_tab.get(p, bandmean.get(P[i] % 24, gmean))
            return (nc_cnt[k] * nc_tab[k] + K * base) / (nc_cnt[k] + K)
        return pred_causal(i)

    def report(name, pv):
        pred = [pv(i) for i in hold]
        lnbl = [math.log(P[i]) for i in hold]   # expected gap at p_i (centered)
        rd = [a - l for a, l in zip(act, lnbl)]
        pdet = [q - l for q, l in zip(pred, lnbl)]
        r = corr(pdet, rd)
        mae = sum(abs(a - q) for a, q in zip(act, pred)) / len(act)
        mae_ln = sum(abs(a - l) for a, l in zip(act, lnbl)) / len(act)
        print(f"  {name:<26}:  r vs ln-detrend = {r:+.4f}   MAE = {mae:8.4f}   (ln-baseline MAE = {mae_ln:8.4f})")

    print("\n--- X11: retrocausality (centered gap g[i] at p_i) ---")
    report("causal C (band, 2 past)", pred_causal)
    report("noncausal C+ (band, 2 past, 2 future)", pred_noncausal)
    mc = sum(abs(a - pred_causal(i)) for i, a in zip(hold, act)) / len(act)
    mn = sum(abs(a - pred_noncausal(i)) for i, a in zip(hold, act)) / len(act)
    print(f"  RETROCAUSAL GAIN (MAE improvement from the FUTURE): {mc - mn:+.4f}  "
          f"({100 * (mc - mn) / mc:+.2f}% of the causal MAE)")
    # control: a future-only predictor (the 2 future gaps, no past) to show the
    # future carries its OWN information (sanity: the gap isn't zero because the
    # future is uninformative at all)
    f_tab, f_cnt = fit(lambda i: (coarse(g[i + 1]), coarse(g[i + 2])))
    def pred_futureonly(i):
        k = (coarse(g[i + 1]), coarse(g[i + 2]))
        if k in f_tab and f_cnt[k] >= 10:
            return (f_cnt[k] * f_tab[k] + K * gmean) / (f_cnt[k] + K)
        return gmean
    report("control: future-only (2 future)", pred_futureonly)

    # --- X10a: music-clatter entropy budget (coarse gap word, whole word) ---
    print("\n--- X10a: music/clatter entropy budget (coarse alph.) ---")
    w = [coarse(x) for x in g[1:]]
    N = len(w)
    def H(cnt):
        return -sum((c / N) * math.log2(c / N) for c in cnt.values())
    fr = {a: c / N for a, c in Counter(w).items()}
    H1 = -sum(p * math.log2(p) for p in fr.values())
    cond = defaultdict(Counter)
    for j in range(1, n - 1):
        cond[P[j] % 24][w[j - 1]] += 1   # gap g[j] from prime P[j], band of the source prime
    Hcond_w = 0.0
    ntot = sum(sum(cc.values()) for cc in cond.values())
    for b, cc in cond.items():
        nb = sum(cc.values())
        pb = nb / ntot
        Hcond_w += pb * (-sum((c / nb) * math.log2(c / nb) for c in cc.values()))
    music = H1 - Hcond_w
    # hits = the large classes (13 = 14..24, 14 = 25..40, 15 > 40)
    hit_share = sum(fr.get(k, 0) for k in (13, 14, 15))
    print(f"  H1 (total)            = {H1:6.4f} bits/letter")
    print(f"  music share (band)    = {music:6.4f} bits/letter  (I(band; gap) = the wheel structure)")
    print(f"  clatter share         = {Hcond_w:6.4f} bits/letter  (the rattling inside the melody)")
    print(f"  hit share (gaps >= 14, the jazz hits) = {hit_share:.4f} of letters")
    # hit entropy share (how much of the entropy the rare hits carry)
    H_hit = -sum(fr.get(k, 0) * math.log2(fr.get(k, 0)) for k in (13, 14, 15) if fr.get(k, 0))
    print(f"  hit contribution to H1 (marginal) = {H_hit:6.4f} bits/letter ({100*H_hit/H1:.1f}%)")
    print("\ndone.")

if __name__ == "__main__":
    main()
