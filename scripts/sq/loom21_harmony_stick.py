#!/usr/bin/env python3
"""
LOOM21 — HARMONY MASK + THE STICK (off-board side-quest; no RH claim;
1 core, 4 open)

Two new instruments, prompted by the owner's 2026-10-31 idea:
"the calculation might be HELPED by the absence of primes before the
current integer - the missing hole in the run-up sharpens the future
search field; every 24-period we drop one; and a 'stick' made from
something like the sum of all primes to this point points WAY far off,
where a prime could guide; maybe two guides (primes / non-primes) and
their correlation; the sums should include the missing primes to
preserve accuracy."

INSTRUMENT A - THE 24-BLOCK HARMONY MASK (the "missing note per period")
  For every 24-block [24k, 24k+24) with 24k >= XLO: mask m_k in 2^8 =
  which of the 8 admissible prime classes {1,5,7,11,13,17,19,23} are
  REALIZED by a prime inside the block (a 1 bit = a prime there; a
  0 bit = that class is "missing" in this period - a composite where
  the prime could have been).
  Forward gap d_k = next prime after (24k + 24) minus (24k + 24).
  Test (HOLDOUT: fit masks on the first half of blocks, score the
  second half - generalization, not in-sample):
    PRIOR(h)  P(d bucket | first half)
    MASK(h)   P(d bucket | mask, fit on first half), scored on second
    null      masks shuffled within the second half (200)
  Plus: per-block "drop count" (popcount of the mask) vs d_k
  point-biserial, and lag-1 autocorrelation of the drop count.

INSTRUMENT B - THE STICK (far pointer, modular + primality shadow)
  P(x) = sum of primes <= x   (the full sum - "includes the missing
  primes in the total" by construction)
  N(x) = x(x+1)/2 - P(x)      (the non-prime sum, the "other" pointer)
  For a subsample of 8192 primes x_k (spread over [XLO/2, X]):
    (i)   the modular guide:  P(x_k) mod 24 vs the forward prime
        distance from x_k - against NULL odd positions x' (P defined
        for every x) with the same forward-distance target;
    (ii)  the far pointer:    MillerRabin(odd-neighbor of P(x_k))
        (deterministic base set, y < 3.3e24) vs the local gap
        quartile of x_k - does the prime far away where the stick
        points carry information about the local run-up?
    (iii) the two guides:     (MR(odd P), MR(odd N)) pair vs gap
        quartile (the "movie pair" intuition, made finite).
  NO torch, no sklearn. NumPy only.  No RH claim: these are
  off-board measurement instruments on the integer tape.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 21
NPERM = 200
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
rep(f"primes <= {X}: {len(primes):,}")

# ================= INSTRUMENT A: 24-block harmony mask ======================
rep("")
rep("=" * 72)
rep("INSTRUMENT A - 24-BLOCK HARMONY MASK (the missing note per period)")
rep("=" * 72)

kb0 = (XLO + 23) // 24                      # first full block at/after XLO
kbmax = X // 24
kb = np.arange(kb0, kbmax)                  # block indices
K = len(kb)
cls = np.array([1, 5, 7, 11, 13, 17, 19, 23])
mask = np.zeros(K, dtype=np.int64)
for j, r in enumerate(cls):
    idx = 24 * kb + r
    ok = idx <= X
    m = np.zeros(K, dtype=bool)
    m[: int(ok.sum())] = sieve_arr[idx[ok]]
    mask |= (m.astype(np.int64) << j)

# forward gap from the block END e = 24k + 24 to the next prime
e = 24 * kb + 24
npos = np.searchsorted(primes, e, side="right")
npos = np.minimum(npos, len(primes) - 1)
d = primes[npos] - e                        # distance (odd, >= 1)
dm = np.where(d <= 31, d, 33).astype(np.int64)
unqD, db = np.unique(dm, return_inverse=True)
A = len(unqD)
rep(f"blocks: {K:,}   d-buckets: {A}   (d = next prime after block end)")
rep(f"  mask histogram (top): {np.unique(mask, return_counts=True)[1][:0]}")
cnts, _ = np.unique(mask, return_counts=True)
pop = np.zeros(K, dtype=np.int64)
for j in range(8):
    pop += (mask >> j) & 1
dc = 8 - pop                                          # number of MISSING notes
rep(f"  distinct masks: {len(cnts):,} of 256   full-harmony (all 8) blocks: "
    f"{int((mask == 255).sum()):,},  realized-note mean = {pop.mean():.3f} per period (missing {dc.mean():.3f})")

# HOLDOUT: fit on first half, score second half
h = K // 2
fit_m, fit_d = mask[:h], db[:h]
te_m, te_d = mask[h:], db[h:]

PM = np.bincount(fit_m * A + fit_d, minlength=256 * A).reshape(256, A).astype(np.float64)
tM = PM.sum(axis=1, keepdims=True)
PM = np.clip(PM / np.maximum(tM, 1), 1e-12, None)
Prow = np.where((tM[:, 0] >= 20)[:, None], PM, PM.mean(axis=0)[None, :])   # thin masks -> marginal
Pmarg = np.bincount(fit_d, minlength=A).astype(np.float64)
Pmarg = Pmarg / Pmarg.sum()
nll_prior_h = float(-np.log(Pmarg[te_d]).mean())
nll_mask_h = float(-np.log(Prow[te_m, te_d]).mean())
gain_mask = nll_prior_h - nll_mask_h

gains_n = np.empty(NPERM)
for k in range(NPERM):
    sh = rng.permutation(te_m)
    gains_n[k] = nll_prior_h - float(-np.log(Prow[sh, te_d]).mean())
z_mask = (gain_mask - gains_n.mean()) / (gains_n.std() + 1e-30)
rep("")
rep(f"HOLDOUT (fit on first {h:,} blocks, score last {K - h:,}):")
rep(f"  PRIOR(h)     {nll_prior_h:.5f}")
rep(f"  MASK(h)      {nll_mask_h:.5f}")
rep(f"  gain(MASK)   = {gain_mask:+.5f} nats/block   null {gains_n.mean():+.5f} +/- {gains_n.std():+.5f}")
rep(f"  z(MASK)      = {z_mask:+.3f}")

# drop count (MISSING notes) vs forward gap (point-biserial against "d <= 7")
dc = (8 - pop).astype(np.float64)
small = (d <= 7).astype(np.float64)
r_pb = small.std() * dc.std() and float(np.corrcoef(small, dc)[0, 1])
lag1 = float(np.corrcoef(dc[:-1], dc[1:])[0, 1])
rep(f"  dropcount vs (d<=7) point-biserial r = {r_pb:+.4f}   lag-1 autocorr of dropcount = {lag1:+.4f}")

# ================= INSTRUMENT B: THE STICK ===================================
rep("")
rep("=" * 72)
rep("INSTRUMENT B - THE STICK (P(x) = sum of primes <= x;  N(x) = rest)")
rep("=" * 72)

csum = np.cumsum(primes.astype(np.int64))     # P(primes[i])
npos_p = len(primes)
SUB = 8192
pos = np.linspace(0, npos_p - 1, SUB).astype(np.int64)
xk = primes[pos]
Pk = csum[pos]                                # P at x_k (full sum)
tot = xk * (xk + 1) // 2
Nk = tot - Pk
# forward distance from x_k to the next prime
nxf = np.searchsorted(primes, xk, side="right")
nxf = np.minimum(nxf, npos_p - 1)
fwd = primes[nxf] - xk                        # = L + 1

rep(f"subsample: {SUB} primes, x from {xk[0]:,} to {xk[-1]:,};  P max = {Pk.max():,}")


def odd_neighbor(y):
    return y + 1 if y % 2 == 0 else y


def mr(n, bases=(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)):
    if n < 2:
        return False
    for p in bases:
        if n % p == 0:
            return n == p
    d = n - 1
    s = 0
    while d % 2 == 0:
        d //= 2
        s += 1
    for a in bases:
        x = pow(a, d, n)
        if x in (1, n - 1):
            continue
        for _ in range(s - 1):
            x = (x * x) % n
            if x == n - 1:
                break
        else:
            return False
    return True


# (i) modular guide: P(x) mod 24 vs forward distance
# null: the same number of random odd positions x' with P(x') defined the same way
xnull = rng.choice(np.arange(XLO // 2, X, 2), size=SUB, replace=False)
# P at arbitrary x': sum of primes <= x' -> csum at searchsorted
pn = np.searchsorted(primes, xnull, side="right")
Pn = np.where(pn > 0, csum[np.maximum(pn - 1, 0)], 0)
nfn = np.searchsorted(primes, xnull, side="right")
nfn = np.minimum(nfn, npos_p - 1)
fwdn = primes[nfn] - xnull


def mod24_table_guide(Pvals, fwdvals):
    """chi2-style lift table: P mod 24 x quartile of fwd."""
    q = np.digitize(fwdvals, np.quantile(fwdvals, [0.25, 0.5, 0.75]))
    m24 = Pvals % 24
    # correlation of the indicator(fwd quartile = 3) with m24 via point-biserial-ish:
    top = (q == 3).astype(np.float64)
    r = float(np.corrcoef(m24.astype(np.float64), top)[0, 1])
    # also: which m24 classes overrepresent top quartile?
    lift = {}
    for m_ in np.unique(m24):
        mm = m24 == m_
        if mm.sum() >= 50:
            lift[int(m_)] = (top[mm].mean(), top.mean(), int(mm.sum()))
    return r, lift


r_g, lift_g = mod24_table_guide(Pk, fwd)
r_n, lift_n = mod24_table_guide(Pn, fwdn)
rep("")
rep("(i) MODULAR GUIDE: P(x) mod 24 vs forward prime distance (quartile-top indicator):")
rep(f"  prime positions : corr(P mod 24, top-quartile)  = {r_g:+.4f}")
rep(f"  random odd null : corr(P mod 24, top-quartile)  = {r_n:+.4f}   (the stick at arbitrary odds)")
bestg = max(lift_g.values(), key=lambda t: t[0]) if lift_g else (0, 0, 0)
rep(f"  strongest prime-position class: m = {bestg[0] if len(bestg) >= 3 else '?'} ...")
if lift_g:
    topm = max(lift_g, key=lambda m: lift_g[m][0] - lift_g[m][1])
    rep(f"  max lift class m = {topm}: top-share {lift_g[topm][0]:.4f} vs base {lift_g[topm][1]:.4f} (n = {lift_g[topm][2]:,})")

# (ii) far pointer: MR of the odd-neighbor of P, vs local forward distance quartile
rep("")
rep("(ii) FAR POINTER: primality of the odd-neighbor of P(x_k) (y ~ 1e11..3e14), vs local run-up:")
t0m = time.time()
yP = np.array([odd_neighbor(v) for v in Pk])
isP = np.array([mr(int(y)) for y in yP])
rep(f"  MR done in {time.time() - t0m:.1f}s;   P(oddP prime) = {isP.mean():.4f}")
qk = np.digitize(fwd, np.quantile(fwd, [0.25, 0.5, 0.75]))
base_top = (qk == 3).mean()
share_top = {}
for v in (False, True):
    mmq = isP == v
    if mmq.sum() >= 100:
        share_top[bool(v)] = float((qk[mmq] == 3).mean())
rep(f"  local fwd top-quartile: base = {base_top:.4f}   | stick-prime = {share_top.get(True, float('nan')):.4f}   "
    f"| stick-odd/composite = {share_top.get(False, float('nan')):.4f}")

# null for (ii): shuffle the stick label
gains_s = np.empty(NPERM)
base_arr = (qk == 3).astype(np.float64)
lab = isP.astype(np.float64)
for k in range(NPERM):
    pl = rng.permutation(lab)
    gains_s[k] = float(pl[base_arr > 0].mean() - pl[base_arr == 0].mean())
obs_s = float(lab[base_arr > 0].mean() - lab[base_arr == 0].mean())
z_stick = (obs_s - gains_s.mean()) / (gains_s.std() + 1e-30)
rep(f"  lift(stick-prime) - lift(other) = {obs_s:+.5f}   null {gains_s.mean():+.5f} +/- {gains_s.std():+.5f}  ->  z = {z_stick:+.3f}")

# (iii) two guides: (MR(oddP), MR(oddN)) pair
t0m = time.time()
yN = np.array([odd_neighbor(v) for v in Nk])
isN = np.array([mr(int(y)) for y in yN])
rep(f"  N-pointer MR done in {time.time() - t0m:.1f}s;   P(oddN prime) = {isN.mean():.4f}")
joint = isP.astype(int) + 2 * isN.astype(int)      # 0..3: P-bit + 2*N-bit
rep("  (iii) MOVIE PAIR: (stick-P prime?, stick-N prime?) vs local fwd top quartile:")
for j in range(4):
    mmj = joint == j
    if mmj.sum() >= 30:
        rep(f"    P-bit={j % 2}, N-bit={j // 2}:  n = {int(mmj.sum()):,}   top-share = {float((qk[mmj] == 3).mean()):.4f}")
pair_corr = float(np.corrcoef(isP.astype(np.float64), isN.astype(np.float64))[0, 1])
rep(f"  corr(stickP prime, stickN prime) = {pair_corr:+.4f}   (the two guides' own correlation)")

rep("")
rep(f"done in {time.time() - T0:.1f}s")
