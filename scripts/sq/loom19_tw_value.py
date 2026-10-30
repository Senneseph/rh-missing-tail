#!/usr/bin/env python3
"""
LOOM19 — WHERE DOES THE +0.209 LIVE?  TW-only / value-level / per-L
(off-board side-quest; no RH claim; 1 core, 4 open)

0237 found the pair-family ceiling breaks at exact-value resolution:
gain(S) = +0.2088 nats/step (z = +5238).  The OT family (left lane
{1,7,13,19}) is a DETERMINISTIC CONSTANT (T1: s = 3 forced, 2,875,733
gaps, ~54% of the population), so it cannot carry any s-level gain
by itself.  This instrument locates the gain:

  (i)   TW-only population (left lane {5,11,17,23}, 2,437,040 gaps):
        ladder PRIOR / PAIR / PAIR+S with the FULL 1,224-class s table
        (no top-128 truncation), exact-L target (1..31 + rest).
  (ii)  truncation effect: 129-class (top-128 + rest) vs 1,225-class
        (all values distinct) on TW.
  (iii) per-L gain rows (TW, exact target): which current-gap lengths
        carry the conditional signal (descriptive; null = global).

Null: within-L-stratum shuffles (200), identical protocol to 0236/0237.
Target: exact L_next values 1,3,...,31 + rest (32 buckets), as 0237.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 19
NPERM = 200
LMAX = 61
TMAX = 31
FALLBACK_MIN = 30

X = 100_000_000
XLO = 100_000
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
_ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
ip = ip[_ok]
ip = ip[:-1]
p = primes[ip]
pnxt = primes[ip + 1]
pnxt2 = primes[ip + 2]
L = (pnxt - p - 1).astype(np.int64)
Ln = (pnxt2 - pnxt - 1).astype(np.int64)
off = np.empty(len(L), dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])
comp_idx = np.arange(p[0] + 1, pnxt[-1])
cidx = comp_idx[~sieve_arr[p[0] + 1:pnxt[-1]]]
partner = spf[cidx]

m2 = L >= 2
g2 = np.nonzero(m2)[0]
s2 = partner[off[g2] + 1]
laneL = p[g2] % 24
Lc = L[g2]
Ln2 = Ln[g2]
tw = np.isin(laneL, [5, 11, 17, 23])
n_tw = int(tw.sum())
rep(f"population L>=2: {len(Lc):,}   TW: {n_tw:,}   OT: {int((~tw).sum()):,}")
s2 = s2[tw]
Lc = Lc[tw]
Ln2 = Ln2[tw]
n = len(Lc)
rep(f"TW distinct s: {len(np.unique(s2)):,}")

# exact-L target
tval = np.where(Ln2 <= TMAX, Ln2, TMAX + 1).astype(np.int64)
unqT, tgt = np.unique(tval, return_inverse=True)
A = len(unqT)
rep(f"target buckets: {A} (values {unqT[-3:]}, rest = {unqT[-1]})")

# conditioning keys
Lraw = np.where(Lc <= LMAX, Lc, LMAX + 1).astype(np.int64)
unqL, Lb = np.unique(Lraw, return_inverse=True)
nL = len(unqL)

# s tables: full distinct vs top-128+rest
vals, cnts = np.unique(s2, return_counts=True)
nfull = len(vals)
fullmap = {v: i for i, v in enumerate(vals)}
sfull = np.array([fullmap[v] for v in s2], dtype=np.int64)
order = np.argsort(-cnts)
top128 = set(vals[order[:128]].tolist())
rest_id = 128
key128 = {v: i for i, v in enumerate(sorted(top128))}
s128 = np.array([key128[v] if v in key128 else rest_id for v in s2], dtype=np.int64)
rep(f"s-tables: full {nfull}, truncated 129")


def fit2(L_, k_, nk_, t_):
    cnt = np.bincount((L_ * nk_ + k_) * A + t_, minlength=nL * nk_ * A).reshape(nL, nk_, A).astype(np.float64)
    tot = cnt.sum(axis=2, keepdims=True)
    P = cnt / np.maximum(tot, 1)
    return cnt, P


def fit1(L_, t_):
    cnt = np.bincount(L_ * A + t_, minlength=nL * A).reshape(nL, A).astype(np.float64)
    tot = cnt.sum(axis=1, keepdims=True)
    P = cnt / np.maximum(tot, 1)
    return P, cnt


def nll1(P, L_, t_):
    return float(-np.log(np.maximum(P[L_, t_], 1e-12)).mean())


def nll2(cnt, P, L_, k_, t_, Ppair):
    Pu = np.where(cnt >= FALLBACK_MIN, P, np.broadcast_to(Ppair[:, None, :], P.shape))
    return float(-np.log(np.maximum(Pu[L_, k_, t_], 1e-12)).mean())


Pp, cntp = fit1(Lb, tgt)
nll_prior = float(-np.log(np.maximum(cntp.sum(0) / cntp.sum(), 1e-12)[tgt]).mean())
nll_pair = nll1(Pp, Lb, tgt)

# (i) TW gain, full table
cntf, Pf = fit2(Lb, sfull, nfull, tgt)
nll_full = nll2(cntf, Pf, Lb, sfull, tgt, Pp)
# (ii) truncated table
cnt1, P1 = fit2(Lb, s128, 129, tgt)
nll_129 = nll2(cnt1, P1, Lb, s128, tgt, Pp)

rep("")
rep("TW-ONLY LADDER (exact-L target, nats/step):")
rep(f"  PRIOR        {nll_prior:.5f}")
rep(f"  PAIR         {nll_pair:.5f}")
rep(f"  PAIR+S FULL({nfull})   {nll_full:.5f}   gain = {nll_pair - nll_full:+.5f}")
rep(f"  PAIR+S top128+rest     {nll_129:.5f}   gain = {nll_pair - nll_129:+.5f}")
rep(f"  (0237 all-pop full-129 truncated ladder: PAIR 2.48811, PAIR+S +0.20877)")

# null for the FULL-table gain
rep(f"null: {NPERM} within-L shuffles (full table) ...")
Lorder = np.argsort(Lb)
Ls = Lb[Lorder]
ts = tgt[Lorder]
unqLv = np.unique(Ls)
b = np.searchsorted(Ls, unqLv, side="right")
st = np.r_[0, b[:-1]]
sf = sfull[Lorder]
gains = np.empty(NPERM)
for k in range(NPERM):
    per = Ls * 0
    for a in range(len(unqLv)):
        sl = slice(st[a], b[a])
        per[sl] = rng.permutation(sf[sl])
    c_ = np.bincount((Ls * nfull + per) * A + ts, minlength=nL * nfull * A).reshape(nL, nfull, A).astype(np.float64)
    P_ = c_ / np.maximum(c_.sum(2, keepdims=True), 1)
    Pu = np.where(c_ >= FALLBACK_MIN, P_, np.broadcast_to(Pp[:, None, :], P_.shape))
    nsh = float(-np.log(np.maximum(Pu[Ls, per, ts], 1e-12)).mean())
    gains[k] = nll_pair - nsh
zfull = (nll_pair - nll_full - gains.mean()) / (gains.std() + 1e-30)
rep(f"  null gains: {gains.mean():+.5f} +/- {gains.std():.5f}")
rep(f"  z(full-table TW gain) = {zfull:+.2f}")

# (iii) per-L gain rows (descriptive): for each mass L row, the NLL
# improvement of the full (L,s) table over the (L) row on that row
rep("")
rep("PER-L gain rows (TW, exact target; top 14 by mass):")
rowinfo = []
for a in range(nL):
    m = (Lb == a)
    nn = int(m.sum())
    if nn < 50_000:
        continue
    Prow = Pp[a]
    nrow1 = float(-np.log(np.maximum(Prow[tgt[m]], 1e-12)).sum()) / nn
    cntrow = cntf[a]
    Prow2 = np.where(cntrow >= FALLBACK_MIN, cntrow / np.maximum(cntrow.sum(1, keepdims=True), 1),
                     np.broadcast_to(Prow, cntrow.shape))
    nrow2 = float(-np.log(np.maximum(Prow2[sfull[m], tgt[m]], 1e-12)).sum()) / nn
    rowinfo.append((nn, unqL[a], nrow1 - nrow2))
rowinfo.sort(reverse=True)
for nn, lv, g in rowinfo[:14]:
    rep(f"  L_g = {str(lv):>3}:  n = {nn:>9,}   per-row gain = {g:+.5f} nats/step")

rep("")
rep("done in %.1fs" % (time.time() - T0))
