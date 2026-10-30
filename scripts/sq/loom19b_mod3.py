"""
LOOM19B — THE CARRIER TEST: does `p mod 3` alone (the OT/TW family
indicator, T1) carry most of the 0237 +0.2088 exact-value gain?
(off-board side-quest; no RH claim; 1 core, 4 open)
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
m2 = L >= 2
g2 = np.nonzero(m2)[0]
p2 = p[g2]
Lc = L[g2]
Ln2 = Ln[g2]
n = len(Lc)
rep(f"population L>=2: {n:,}")

# exact-L target
tval = np.where(Ln2 <= TMAX, Ln2, TMAX + 1).astype(np.int64)
unqT, tgt = np.unique(tval, return_inverse=True)
A = len(unqT)
rep(f"target buckets: {A}")

Lraw = np.where(Lc <= LMAX, Lc, LMAX + 1).astype(np.int64)
unqL, Lb = np.unique(Lraw, return_inverse=True)
nL = len(unqL)

# k = p mod 3:  {1, 2} (primes >= 5 never 0)
k3 = (p2 % 3 - 1).astype(np.int64)   # {1,2} -> {0,1}
nk = 2
rep(f"k3 classes: {np.unique(k3, return_counts=True)}")


def fit2(L_, k_, nk_, t_):
    cnt = np.bincount((L_ * nk_ + k_) * A + t_, minlength=nL * nk_ * A).reshape(nL, nk_, A).astype(np.float64)
    P = cnt / np.maximum(cnt.sum(axis=2, keepdims=True), 1)
    return cnt, P


cntp = np.bincount(Lb * A + tgt, minlength=nL * A).reshape(nL, A).astype(np.float64)
Pp = cntp / np.maximum(cntp.sum(axis=1, keepdims=True), 1)
nll_pair = float(-np.log(np.maximum(Pp[Lb, tgt], 1e-12)).mean())
cnt3, P3 = fit2(Lb, k3, nk, tgt)
Pu3 = np.where(cnt3 >= FALLBACK_MIN, P3, np.broadcast_to(Pp[:, None, :], P3.shape))
nll_m3 = float(-np.log(np.maximum(Pu3[Lb, k3, tgt], 1e-12)).mean())
gain = nll_pair - nll_m3
rep("")
rep("FULL-POP LADDER (exact-L target, k = p mod 3, 2 classes):")
rep(f"  PAIR           {nll_pair:.5f}")
rep(f"  PAIR+MOD3      {nll_m3:.5f}   gain = {gain:+.5f}")
rep(f"  (0237 full s-class gain: +0.20877 ; 19 TW-only s-fine gain: +0.10112 on 45.9% mass)")

Lorder = np.argsort(Lb)
Ls = Lb[Lorder]
ts = tgt[Lorder]
unqLv = np.unique(Ls)
b = np.searchsorted(Ls, unqLv, side="right")
st = np.r_[0, b[:-1]]
k3s = k3[Lorder]
gains = np.empty(NPERM)
for k in range(NPERM):
    per = Ls * 0
    for a in range(len(unqLv)):
        sl = slice(st[a], b[a])
        per[sl] = rng.permutation(k3s[sl])
    c_ = np.bincount((Ls * nk + per) * A + ts, minlength=nL * nk * A).reshape(nL, nk, A).astype(np.float64)
    P_ = c_ / np.maximum(c_.sum(2, keepdims=True), 1)
    Pu = np.where(c_ >= FALLBACK_MIN, P_, np.broadcast_to(Pp[:, None, :], P_.shape))
    nsh = float(-np.log(np.maximum(Pu[Ls, per, ts], 1e-12)).mean())
    gains[k] = nll_pair - nsh
z = (gain - gains.mean()) / (gains.std() + 1e-30)
rep(f"  null gains: {gains.mean():+.5f} +/- {gains.std():.5f}   z = {z:+.2f}")
rep("")
rep("done in %.1fs" % (time.time() - T0))
