#!/usr/bin/env python3
"""
LOOM20 — THE MOD-LADDER: how much of the next-gap predictivity is
plain modular arithmetic (the support game), level by level.
(off-board side-quest; no RH claim; 1 core, 4 open)

Context: 0237 measured +0.20877 nats/step (z +5238) for PAIR + the full
fine spf value s = spf(p+2) at exact-value target (17 buckets:
L_next = 1,3,...,31 + rest).  0238/0239 showed the row-wait support
game is EXACT at every small sieve q: the coarse pair table P(L_next | L)
mixes the p mod q families and puts mass on exactly-vacant residue
classes.  This instrument quantifies the arithmetic hierarchy in NLL
units:

  ladder (test nats/step, PAIR fallback on cells < 30 mass, 0237 protocol):
    PAIR        P(L_next | L)                      [0237: 2.48811]
    PAIR+M3     P(L_next | L, p mod 3)             [expect ~ +0.1667 (0238)]
    PAIR+M15    P(L_next | L, p mod 15)            [+ mod-5 support]
    PAIR+M105   P(..., p mod 105)                  [+ mod-7 support]
    PAIR+M2310  P(..., p mod 2310)                 [+ mod-11]
    PAIR+M30030 P(..., p mod 30030)                [full 30030 wheel]

  null: the p mod N label shuffled WITHIN each L stratum (preserves
        P(label | L)); 200 permutations -> z at the top level.
  anchor: PAIR+S full (0237's +0.20877) re-measured in the same run.

The ceiling of the ladder = "the arithmetic shadow" of the next gap;
PAIR+S - ladder_top = the FINE-SPF residual beyond the wheel structure
(density modulation on the supported bins, 0238's +0.0421).

NO torch, no sklearn. NumPy only.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 20
NPERM = 200

X = 100_000_000
XLO = 100_000
TMAX = 31       # exact L_next values 1..31 odd + rest (17 buckets)
LMAX = 61       # exact L values 1..61 odd + rest
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


def spf_upto(x, primes):
    pfmax = int(math.isqrt(x)) + 1
    spf = np.zeros(x + 1, dtype=np.int64)
    for p in primes[primes <= pfmax]:
        m = np.arange(p * p, x + 1, p)
        mask = spf[m] == 0
        spf[m[mask]] = p
    return spf


spf = spf_upto(X, primes)

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
ip = ip[(ip + 2) < len(primes)]
ip = ip[primes[np.minimum(ip + 2, len(primes) - 1)] <= X]
p = primes[ip]
pnxt = primes[ip + 1]
pnxt2 = primes[ip + 2]
L = (pnxt - p - 1).astype(np.int64)
Ln = (pnxt2 - pnxt - 1).astype(np.int64)
rep(f"gaps with both L and L_next: {len(p):,}")

m2 = L >= 2
g2 = np.nonzero(m2)[0]
p2 = p[g2]
Lc = L[g2]
Ln2 = Ln[g2]
n = Lc.size
rep(f"population (L >= 2): {n:,}")

# s = spf(p+2) directly (L >= 2 means p+2 is composite in the gap)
s2 = spf[p2 + 2]
rep(f"s = spf(p+2): distinct = {len(np.unique(s2)):,}   max = {s2.max()}")

# anchor: OT/TW exactness (0238)
laneL = p2 % 24
ot = np.isin(laneL, [1, 7, 13, 19])
tw = np.isin(laneL, [5, 11, 17, 23])
rep(f"T1 anchor: share(s=3 | OT) = {(s2[ot] == 3).mean():.6f}   "
    f"share(s=3 | TW) = {(s2[tw] == 3).mean():.6f}")

# ---- target & L buckets (0237 protocol) ------------------------------------
tval = np.where(Ln2 <= TMAX, Ln2, TMAX + 1).astype(np.int64)
unqT, tgt = np.unique(tval, return_inverse=True)
A = len(unqT)
Lraw = np.where(Lc <= LMAX, Lc, LMAX + 1).astype(np.int64)
unqL, Lb = np.unique(Lraw, return_inverse=True)
nL = len(unqL)

# s key (0237 PAIR+S anchor): SMAX most frequent + rest
vals, cnts = np.unique(s2, return_counts=True)
order = np.argsort(-cnts)
top = set(vals[order[:SMAX]].tolist())
rest_id = len(top)
keymap = {v: i for i, v in enumerate(sorted(top))}
skey = np.array([keymap.get(v, rest_id) for v in s2], dtype=np.int64)
ns_ = rest_id + 1
rep(f"target buckets: {A}   L buckets: {nL}   s classes: {ns_}")


def nll_pair(Lb_, tgt_):
    cnt = np.bincount(Lb_ * A + tgt_, minlength=nL * A).reshape(nL, A).astype(np.float64)
    tot = cnt.sum(axis=1, keepdims=True)
    P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
    return float(-np.log(P[Lb_, tgt_]).mean()), P


def nll_joint(Lb_, k_, nk_, tgt_, Ppair):
    key = Lb_ * nk_ + k_
    cnt = np.bincount(key * A + tgt_, minlength=nL * nk_ * A).reshape(nL, nk_, A).astype(np.float64)
    tot = cnt.sum(axis=2, keepdims=True)
    P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
    Puse = np.where(cnt >= FALLBACK_MIN, P,
                    np.broadcast_to(Ppair[:, None, :], P.shape))
    return float(-np.log(np.maximum(Puse[Lb_, k_, tgt_], 1e-12)).mean()), cnt


nll_prior_cnt = np.bincount(tgt, minlength=A).astype(np.float64)
Pp = nll_prior_cnt / nll_prior_cnt.sum()
nll_prior = float(-np.log(np.maximum(Pp[tgt], 1e-12)).mean())
nll_pair_, Ppair = nll_pair(Lb, tgt)
nll_ps, _ = nll_joint(Lb, skey, ns_, tgt, Ppair)

rep("")
rep("LADDER (0237 protocol: exact L_next in 17 buckets; cells < 30 fall back to PAIR):")
rep(f"  PRIOR        {nll_prior:.5f}")
rep(f"  PAIR         {nll_pair_:.5f}   (0237: 2.48811)")
rep(f"  PAIR+S       {nll_ps:.5f}   gain = {nll_pair_ - nll_ps:+.5f}   (0237: +0.20877)")

LDS = [3, 15, 105, 2310, 30030]
gains = {}
for Nq in LDS:
    mlab = p2 % Nq
    unqM, mkey = np.unique(mlab, return_inverse=True)  # dense (only classes present)
    nk = len(unqM)
    nll_m, _ = nll_joint(Lb, mkey, nk, tgt, Ppair)
    gains[Nq] = nll_pair_ - nll_m
    rep(f"  PAIR+M{Nq:<6} {nll_m:.5f}   gain = {nll_pair_ - nll_m:+.5f}   "
        f"({nk} classes, step {gains[Nq] - (gains[LDS[LDS.index(Nq) - 1]] if Nq != LDS[0] else 0.0):+.5f})")

# ---- null: shuffle the label within L strata at three ladder levels --------
def null_gain(Nq_, nperm_):
    mlab_ = p2 % Nq_
    _unqM, mkey_ = np.unique(mlab_, return_inverse=True)
    nk_ = len(_unqM)
    nll_m, _ = nll_joint(Lb, mkey_, nk_, tgt, Ppair)
    gains_n = np.empty(nperm_)
    for k in range(nperm_):
        per = m_in_.copy()
        for a_ in range(nL):
            sl = slice(bound[a_], bound[a_ + 1])
            per[sl] = rng.permutation(m_in_[sl])
        cnt_ = np.bincount((Lsort * nk_ + per) * A + torder, minlength=nL * nk_ * A).reshape(nL, nk_, A).astype(np.float64)
        tot_ = cnt_.sum(axis=2, keepdims=True)
        P_ = np.clip(cnt_ / np.maximum(tot_, 1), 1e-12, None)
        Pu_ = np.where(cnt_ >= FALLBACK_MIN, P_,
                       np.broadcast_to(Ppair[:, None, :], P_.shape))
        nll_sh = float(-np.log(np.maximum(Pu_[Lsort, per, torder], 1e-12)).mean())
        gains_n[k] = nll_pair_ - nll_sh
    return nll_m, gains_n


Lorder = np.argsort(Lb, kind="stable")
Lsort = Lb[Lorder]
torder = tgt[Lorder]
bound = np.searchsorted(Lsort, np.arange(0, nL + 1))
rep("")
for Nq_ in [15, 2310, 30030]:
    m_in_ = None
    _unqM, mkey_ = np.unique(p2 % Nq_, return_inverse=True)
    m_in_ = mkey_[Lorder]
    rep(f"null: {NPERM} shuffles of the p mod {Nq_} label within L strata ...")
    nll_m, gains_n = null_gain(Nq_, NPERM)
    dz = gains_n.std() + 1e-30
    z = (nll_pair_ - nll_m - gains_n.mean()) / dz
    rep(f"  level M{Nq_}: gain = {nll_pair_ - nll_m:+.5f}   "
        f"null {gains_n.mean():+.5f} +/- {gains_n.std():+.5f}  ->  z = {z:+.3f}")

# ---- verdict -----------------------------------------------------------------
shadow = max(gains[3], gains[15], gains[105], gains[2310], gains[30030])
shadowN = max([3, 15, 105, 2310, 30030], key=lambda q: gains[q])
resid = (nll_pair_ - nll_ps) - gains[30030]
rep("")
rep(f"ARITHMETIC SHADOW  = max gain(p mod N), N <= 30030 = {shadow:+.5f} at p mod {shadowN}")
rep(f"FINE-SPF RESIDUAL  = (PAIR+S) - shadow(M30030) = {resid:+.5f} nats/step")
rep(f"  PAIR+S gain = {nll_pair_ - nll_ps:+.5f}   vs   shadow {shadow:+.5f}")
rep("")
rep(f"done in {time.time() - T0:.1f}s")
