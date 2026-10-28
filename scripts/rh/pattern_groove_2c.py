import math
from collections import defaultdict

def coarse(x):
    return x if x <= 12 else (13 if x <= 24 else (14 if x <= 40 else 15))

X = 100_000_000
b = bytearray([1]) * (X + 1); b[0] = b[1] = 0
i = 2
while i * i <= X:
    if b[i]:
        b[i * i::i] = bytearray(len(b[i * i::i]))
    i += 1
P = [j for j in range(X + 1) if b[j]]
n = len(P)
g = [P[i + 1] - P[i] for i in range(n - 1)]
L = [math.log(x) for x in P]
h = [g[i] / L[i] for i in range(n - 1)]   # scale-free target
tr = int(0.8 * n)
hold = list(range(tr, n - 6))
S = 200.0
tabC = defaultdict(list); tabCp = defaultdict(list); tabF = defaultdict(list)
for i in range(2, tr):
    tabC[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]))].append(h[i])
    tabCp[(P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2]))].append(h[i])
    tabF[(coarse(g[i + 1]), coarse(g[i + 2]))].append(h[i])
gmean_tr = sum(h[2:tr]) / (tr - 2)
gmean_h = sum(h[i] for i in hold) / len(hold)
def mk(tab, keyfun, anchor):
    mu = {k: sum(v) / len(v) for k, v in tab.items()}
    cnt = {k: len(v) for k, v in tab.items()}
    def pred(i):
        k = keyfun(i)
        if k in mu:
            c = cnt[k]
            return (c * mu[k] + S * anchor) / (c + S)
        return anchor
    return pred
pC = mk(tabC, lambda i: (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2])), gmean_tr)
pCp = mk(tabCp, lambda i: (P[i] % 24, coarse(g[i - 1]), coarse(g[i - 2]), coarse(g[i + 1]), coarse(g[i + 2])), gmean_tr)
pF = mk(tabF, lambda i: (coarse(g[i + 1]), coarse(g[i + 2])), gmean_tr)
def mae(pred):
    return sum(abs(h[i] - pred(i)) for i in hold) / len(hold)
B, c, cp, f = mae(lambda i: gmean_h), mae(pC), mae(pCp), mae(pF)
print(f"CLEAN SPLIT 1e8 (scale-free h = g/ln; tables from TRAIN [2,0.8n):")
print(f"  const(hold-mean) {B:.5f}   causal {c:.5f} ({100*(B-c)/B:+.2f}%)   noncausal {cp:.5f} ({100*(B-cp)/B:+.2f}%)   future-only {f:.5f} ({100*(B-f)/B:+.2f}%)")
print(f"  RETROCAUSAL GAIN C->C+ = {c-cp:+.5f} = {100*(c-cp)/c:+.2f}%  {'axiom holds' if c-cp < 0.02*B else 'CHECK'}")
print(f"  (anchors: train-mean {gmean_tr:.4f} vs hold-mean {gmean_h:.4f})")
