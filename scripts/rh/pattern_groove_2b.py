#!/usr/bin/env python3
"""Groove batch 2b: proper X11b (hold-local anchor, S=200, scale-free target)
and clean X4 at BOTH scales (same definition: letters = gap mod 24)."""
import math
from collections import Counter, defaultdict

def coarse(x):
    return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))

def build(X):
    b = bytearray([1]) * (X + 1); b[0] = b[1] = 0
    i = 2
    while i * i <= X:
        if b[i]:
            b[i * i::i] = bytearray(len(b[i * i::i]))
        i += 1
    P = [j for j in range(X + 1) if b[j]]
    g = [P[i + 1] - P[i] for i in range(len(P) - 1)]
    return P, g

def x11b(X, tag):
    P, g = build(X)
    n = len(P)
    tr = int(0.8 * n)
    hold = list(range(tr, n - 6))
    ghm = sum(g[tr:n - 6]) / (n - 6 - tr)   # HOLD-LOCAL anchor
    S = 200.0
    tabC = defaultdict(list); tabCp = defaultdict(list); tabF = defaultdict(list)
    for i in hold:
        tabC[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))].append(i)
        tabCp[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2]))].append(i)
        tabF[(coarse(g[i + 1]), coarse(g[i + 2]))].append(i)
    muC = {k: sum(g[i] for i in v) / len(v) for k, v in tabC.items()}
    muCp = {k: sum(g[i] for i in v) / len(v) for k, v in tabCp.items()}
    muF = {k: sum(g[i] for i in v) / len(v) for k, v in tabF.items()}
    def mk(tab, mu, keyfun):
        def pred(i):
            k = keyfun(i)
            c = len(tab[k])
            return (c * mu[k] + S * ghm) / (c + S)
        return pred
    pC = mk(tabC, muC, lambda i: (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2])))
    pCp = mk(tabCp, muCp, lambda i: (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2])))
    pF = mk(tabF, muF, lambda i: (coarse(g[i + 1]), coarse(g[i + 2])))
    def mae(pred):
        return sum(abs(g[i] - pred(i)) for i in hold) / len(hold)
    B, c, cp, f = mae(lambda i: ghm), mae(pC), mae(pCp), mae(pF)
    print(f"[{tag}] hold MAE: const {B:.4f}  causal {c:.4f} ({100*(B-c)/B:+.2f}%)  "
          f"noncausal {cp:.4f} ({100*(B-cp)/B:+.2f}%)  future-only {f:.4f} ({100*(B-f)/B:+.2f}%)")
    print(f"[{tag}] RETROCAUSAL GAIN C->C+ : {c-cp:+.4f} = {100*(c-cp)/c:+.2f}% of causal  "
          f"({'axiom holds' if (c-cp) < 0.02*B else 'check: gain > 2% of baseline'})")
    # scale-free variant: target = g/ln(height)
    L = [math.log(P[i]) for i in range(n)]
    def mae_sf(predg):
        return sum(abs(g[i] / L[i] - predg(i) / L[i]) for i in hold) / len(hold)
    B2 = mae_sf(lambda i: ghm); c2 = mae_sf(pC); cp2 = mae_sf(pCp); f2 = mae_sf(pF)
    print(f"[{tag}] scale-free (g/ln): const {B2:.5f}  causal {c2:.5f} ({100*(B2-c2)/B2:+.2f}%)  "
          f"noncausal {cp2:.5f} ({100*(B2-cp2)/B2:+.2f}%)  future-only {f2:.5f} ({100*(B2-f2)/B2:+.2f}%)")
    print(f"[{tag}] scale-free RETROCAUSAL GAIN : {c2-cp2:+.5f} = {100*(c2-cp2)/c2:+.2f}%  "
          f"({'axiom holds' if (c2-cp2) < 0.02*B2 else 'check > 2%'})")

def x4(X, tag):
    P, g = build(X)
    w = [x % 24 for x in g]           # letters = gap mod 24 (the 24-wheel gap word)
    N = len(w)
    c1 = Counter(w)
    c2 = Counter(zip(w, w[1:]))
    c3 = Counter(zip(w, w[1:], w[2:]))
    H1 = -sum(c / N * math.log2(c / N) for c in c1.values())
    H2 = -sum(c / (N - 1) * math.log2(c / (N - 1)) for c in c2.values())
    H3 = -sum(c / (N - 2) * math.log2(c / (N - 2)) for c in c3.values())
    k2, k3 = 576, 13824
    print(f"[{tag}] gap-mod-24 word: letters obs = {len(c1)} p(2) = {len(c2)/k2:.4f} p(3) = {len(c3)/k3:.5f}")
    print(f"[{tag}] H1 = {H1:.4f}   i.i.d. excess 2H1-H2 = {2*H1-H2:+.4f} bits/2-gram   H1-H3/3 = {H1-H3/3:+.4f} bits/letter")

if __name__ == "__main__":
    x4(2_000_000, "2e6")
    x11b(2_000_000, "2e6")
    x4(100_000_000, "1e8")
    x11b(100_000_000, "1e8")
    print("done.")
