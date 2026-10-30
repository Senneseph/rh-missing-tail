#!/usr/bin/env python3
"""
LOOM20B — HOLDOUT GENERALIZATION of the mod-ladder (off-board; no RH claim;
1 core, 4 open)

LOOM20's ladder was in-sample MLE (0237 protocol, kept for comparability).
This re-scores the same ladder under a strict holdout: fit the tables on
the ODD-indexed gap rows, score the EVEN-indexed rows (and the drift-aware
PAIR baseline fit on odds).  If the gain survives, it generalizes.

Protocol (0237 target: exact L_next in 17 buckets; cells < 30 fall back
to the holdout-fit PAIR row):
  PAIR(ho)      P(tgt | L)            fit on odds
  PAIR+S(ho)    P(tgt | L, s)         fit on odds
  PAIR+M15(ho)  P(tgt | L, p mod 15)  fit on odds
  PAIR+M2310(ho)P(tgt | L, p mod 2310)fit on odds
all scored on evens.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 20
X = 100_000_000
XLO = 100_000
TMAX = 31
LMAX = 61
SMAX = 128
FALLBACK_MIN = 30
rng = np.random.default_rng(SEED)


def rep(*a):
    print(*a, flush=True)


def sieve(x):
    s = np.ones(x + 1, dtype=bool)
    s[0] = s[1] = False
    for i in range(2, int(x ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return s


sieve_arr = sieve(X)
primes = np.nonzero(sieve_arr)[0]
pfmax = int(math.isqrt(X)) + 1
spf = np.zeros(X + 1, dtype=np.int64)
for p in primes[primes <= pfmax]:
    m = np.arange(p * p, X + 1, p)
    mask = spf[m] == 0
    spf[m[mask]] = p

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
ip = ip[(ip + 2) < len(primes)]
ip = ip[primes[np.minimum(ip + 2, len(primes) - 1)] <= X]
p = primes[ip]
pnxt = primes[ip + 1]
pnxt2 = primes[ip + 2]
L = (pnxt - p - 1).astype(np.int64)
Ln = (pnxt2 - pnxt - 1).astype(np.int64)

m2 = L >= 2
g2 = np.nonzero(m2)[0]
p2 = p[g2]
Lc = L[g2]
Ln2 = Ln[g2]
s2 = spf[p2 + 2]
n = Lc.size
rep(f"population (L >= 2): {n:,}")

tval = np.where(Ln2 <= TMAX, Ln2, TMAX + 1).astype(np.int64)
unqT, tgt = np.unique(tval, return_inverse=True)
A = len(unqT)
Lraw = np.where(Lc <= LMAX, Lc, LMAX + 1).astype(np.int64)
unqL, Lb = np.unique(Lraw, return_inverse=True)
nL = len(unqL)

vals, cnts = np.unique(s2, return_counts=True)
order = np.argsort(-cnts)
top = set(vals[order[:SMAX]].tolist())
rest_id = len(top)
keymap = {v: i for i, v in enumerate(sorted(top))}
skey = np.array([keymap.get(v, rest_id) for v in s2], dtype=np.int64)
ns_ = rest_id + 1

odd = np.arange(n) % 2 == 1
fit, te = odd, ~odd
rep(f"holdout: fit on {int(fit.sum()):,} odd rows, score on {int(~fit.sum()):,} even rows")


def fit_table(Lb_f, k_f, nk_f, tgt_f):
    if k_f is None:
        cnt = np.bincount(Lb_f * A + tgt_f, minlength=nL * A).reshape(nL, A).astype(np.float64)
        tot = cnt.sum(axis=1, keepdims=True)
        P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
        return P
    key = Lb_f * nk_f + k_f
    cnt = np.bincount(key * A + tgt_f, minlength=nL * nk_f * A).reshape(nL, nk_f, A).astype(np.float64)
    tot = cnt.sum(axis=2, keepdims=True)
    P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
    base = np.bincount(Lb_f * A + tgt_f, minlength=nL * A).reshape(nL, A).astype(np.float64)
    tbase = base.sum(axis=1, keepdims=True)
    Ppair = np.clip(base / np.maximum(tbase, 1), 1e-12, None)
    Puse = np.where(cnt >= FALLBACK_MIN, P, np.broadcast_to(Ppair[:, None, :], P.shape))
    return Puse


def nll(P, Lb_t, k_t, tgt_t):
    if k_t is None:
        return float(-np.log(P[Lb_t, tgt_t]).mean())
    return float(-np.log(np.maximum(P[Lb_t, k_t, tgt_t], 1e-12)).mean())


Ppair_ho = fit_table(Lb[fit], None, None, tgt[fit])
n_pair = nll(Ppair_ho, Lb[te], None, tgt[te])

PpairS_ho = fit_table(Lb[fit], skey[fit], ns_, tgt[fit])
n_s = nll(PpairS_ho, Lb[te], skey[te], tgt[te])

res = {"M15": None, "M2310": None}
for Nq in (15, 2310):
    mlab = p2 % Nq
    _u, mkey = np.unique(mlab, return_inverse=True)
    nk = len(_u)
    Ph = fit_table(Lb[fit], mkey[fit], nk, tgt[fit])
    res[f"M{Nq}"] = nll(Ph, Lb[te], mkey[te], tgt[te])

rep("")
rep("HOLDOUT LADDER (fit odds, score evens; nats/step):")
rep(f"  {'PAIR':<10} {n_pair:.5f}   (baseline)")
rep(f"  {'PAIR+S':<10} {n_s:.5f}   gain = {n_pair - n_s:+.5f}   (in-sample: +0.20877)")
for k_, v_ in res.items():
    ref = {15: "+0.36737", 2310: "+0.59452"}[int(k_[1:])]
    rep(f"  {'PAIR+' + k_:<10} {v_:.5f}   gain = {n_pair - v_:+.5f}   (in-sample: {ref})")
rep("")
rep(f"done in {time.time() - T0:.1f}s")
