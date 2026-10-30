#!/usr/bin/env python3
"""
LOOM18C — THE spf(p+2) TRANSFER MATRIX AT SUB-DECILE TARGET (exact L_next)
(off-board side-quest; no RH claim; 1 core, 4 open)

0234 reduced the stored charge to spf(p+2) structure: OT lanes {1,7,13,19}
force spf(p+2) = 3 exactly; TW lanes {5,11,17,23} carry
-branch_24(spf(p+2)-2) ticks over 1224 distinct spf values; the marginal
signal (z = +19.2) is spf(p+2) SHADOW and the within-cell residual was
small (r <= 0.023) and non-monotone.

Question (the transfer matrix, made finite): given the CURRENT gap length
L_g (the pair family's full state, 0233), does s = spf(p+2) carry ADDITIONAL
information about the NEXT gap L_{g+1}?

Instrument:
  population      gaps g with L_g >= 2 (so p+2 is a composite in the gap),
                  X = 1e8
  target          decile of L_{g+1} (10 quantile deciles, edges from the
                  L_{g+1} values in the run)
  ladder (test nats/step):
    PRIOR        P(L_{g+1})
    PAIR         P(L_{g+1} | L_g)          [the pair family, 0233]
    PAIR+LANE    P(L_{g+1} | L_g, lane(c_2))          [24 lanes, cheap]
    PAIR+S       P(L_{g+1} | L_g, s)          [s up to SMAX distinct + rest]
  null           s (and lane) labels shuffled WITHIN each L_g stratum
                  (preserves P(s|L_g) and P(L_{g+1}|L_g) exactly);
                  200 permutations -> z for the PAIR+S gain
  band           |gain| < 0.2 nats/step => MARSHALLED (pair family holds,
                  same discipline as 0225/0228/0233); otherwise DEEPER.

Exact-structure controls (theorem-side anchors, 0232/0234):
  T1  share(s = 3 with lane(c_2) in {1,7,13,19})  (0234: 1.0000)
  T2  share(lane(c_2) in {1,7,13,19} with s = 3)  (0234: 1.0000)
  T3  parity theorem: consecutive odd composites in one gap share no spf
  T4  s = 5 -> lane(c_2) in {1,13} over-represented (0231 A4, x2.225)

NO torch, no sklearn. NumPy only. Python-first discipline.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 18
NPERM = 200
A = 32            # exact L_next values 1,3,...,31 + rest = 33  (32 buckets)
LMAX = 61       # exact L values 1..61 in the pair table (odd L only), rest bucket
SMAX = 128      # distinct s values kept explicitly, rest bucket

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
ip = ip[:-1]  # need L_{g+1} too
p = primes[ip]
pnxt = primes[ip + 1]
pnxt2 = primes[ip + 2]
L = (pnxt - p - 1).astype(np.int64)
Ln = (pnxt2 - pnxt - 1).astype(np.int64)
rept = rep
rept(f"gaps with both L and L_next: {len(p):,}   max L = {L.max()}")

# ---- partner word bookkeeping (loom15-consistent) ------------------------
off = np.empty(len(L), dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])
comp_idx = np.arange(p[0] + 1, pnxt[-1])
comp_mask = ~sieve_arr[p[0] + 1:pnxt[-1]]
cidx = comp_idx[comp_mask]                  # composite indices (reused by T3)
partner = spf[cidx]
nlam = partner.size
assert nlam == int(L.sum())

# the odd composite p+2 inside gaps with L >= 2: position off_g + 1
m2 = L >= 2
g2 = np.nonzero(m2)[0]
s2 = partner[off[g2] + 1]                 # spf(p + 2)
laneL = p[g2] % 24                        # LEFT prime lane (0234's "left lanes")
lane2 = (p[g2] + 2) % 24                  # lane of c_2 itself (T4, 0231 A4)
Lc = L[g2]
Ln2 = Ln[g2]                              # target: next gap
n = Lc.size
rep(f"population (L >= 2): {n:,}   distinct s: {len(np.unique(s2)):,}")
rep(f"max s = {s2.max()}   min s = {s2.min()}")

# ---- exact-structure controls ---------------------------------------------
ot = np.isin(laneL, [1, 7, 13, 19])
tw = np.isin(laneL, [5, 11, 17, 23])
rep("")
rep("EXACT-STRUCTURE CONTROLS (0232/0234 anchors, re-verified @1e8):")
rep(f"  T1  share(s=3, lane in OT)  = {(s2[ot] == 3).mean():.6f}  "
    f"({int((s2[ot] == 3).sum()):,}/{int(ot.sum()):,})")
rep(f"  T2  share(lane in OT, s=3)  = {(ot[s2 == 3]).mean():.6f}  "
    f"({int((ot[s2 == 3]).sum()):,}/{int((s2 == 3).sum()):,})")
rep(f"  T3b share(s=3 in TW)        = {(s2[tw] == 3).mean():.6f}  "
    f"(0234: none)  distinct s in TW = {len(np.unique(s2[tw])):,}")
base5 = (lane2 == 1).mean()
s5 = s2 == 5
rep(f"  T4  share(s=5, lane in {{1,13}}) = {(np.isin(lane2[s5], [1, 13])).mean():.4f} "
    f"vs base(lane in {{1,13}}) = {np.isin(lane2, [1, 13]).mean():.4f} "
    f"(x{np.isin(lane2[s5], [1, 13]).mean() / np.isin(lane2, [1, 13]).mean():.2f}, 0231 A4: x2.225)")

# parity theorem T3: within each gap word, consecutive odd positions
# (c_2, c_4, c_6, ...) have distinct spf  (small gather off the precomputed cidx)
viol = 0
chk = 0
for g in g2[:100_000]:
    lg = L[g]
    if lg < 4:
        continue
    pos = off[g]
    k = (lg - 1) // 2
    oddp = spf[cidx[(pos + 1)::2][:k]]      # ODD composites (odd offsets)
    v = (oddp[1:] == oddp[:-1]).sum()
    viol += int(v)
    chk += int(k - 1)
rep(f"  T3  parity spf-violations in first 100k gaps: {viol} (checked {chk:,} adj pairs)")

# ---- targets: deciles of L_next -------------------------------------------
TMAX = 31
tval = np.where(Ln2 <= TMAX, Ln2, TMAX + 1).astype(np.int64)
unqT, tgt = np.unique(tval, return_inverse=True)
A = len(unqT)
rep(f"target: exact L_next values {unqT[:6]}...{unqT[-3:]} -> {A} buckets (rest = {unqT[-1]})")

# ---- conditioning keys ------------------------------------------------------
Lraw = np.where(Lc <= LMAX, Lc, LMAX + 1).astype(np.int64)   # 1,3,..,61 + rest=62
unq, Lb = np.unique(Lraw, return_inverse=True)               # dense bucket ids 0..nL-1
nL = len(unq)
# distinct s values, SMAX most frequent + rest
vals, cnts = np.unique(s2, return_counts=True)
order = np.argsort(-cnts)
top = set(vals[order[:SMAX]].tolist())
skey_full = s2.copy()
rest_id = len(top)
keymap = {v: i for i, v in enumerate(sorted(top))}
skey = np.array([keymap[v] if v in keymap else rest_id for v in s2], dtype=np.int64)
ns_ = rest_id + 1
LANE24 = 24

rep("")
rep(f"pair table: {nL} L-buckets x {A} deciles   s-table: {ns_} s-classes")


def nll_pair(Lb_, tgt_):
    """Nats/step under P(tgt | L)."""
    cnt = np.bincount(Lb_ * A + tgt_, minlength=nL * A).reshape(nL, A).astype(np.float64)
    tot = cnt.sum(axis=1, keepdims=True)
    P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
    per = -np.log(P[Lb_, tgt_])
    return per.mean(), P, cnt


FALLBACK_MIN = 30  # cells with < 30 mass fall back to the PAIR row (documented rule)


def nll_joint(Lb_, k_, nk_, tgt_, Ppair):
    """Nats/step under P(tgt | L, k) with PAIR fallback on thin cells."""
    key = Lb_ * nk_ + k_
    cnt = np.bincount(key * A + tgt_, minlength=nL * nk_ * A).reshape(nL, nk_, A).astype(np.float64)
    tot = cnt.sum(axis=2, keepdims=True)
    P = np.clip(cnt / np.maximum(tot, 1), 1e-12, None)
    Puse = np.where(cnt >= FALLBACK_MIN, P,
                    np.broadcast_to(Ppair[:, None, :], P.shape))
    per = -np.log(np.maximum(Puse[Lb_, k_, tgt_], 1e-12))
    return per.mean(), cnt


# PRIOR
cntt = np.bincount(tgt, minlength=A).astype(np.float64)
Pp = cntt / cntt.sum()
nll_prior = float(-np.log(np.maximum(Pp[tgt], 1e-12)).mean())

# PAIR
nll_pair_, Ppair, cntpair = nll_pair(Lb, tgt)
# PAIR+S  (thin (L, s) cells fall back to the PAIR row: documented, null-consistent)
nll_ps, cntps = nll_joint(Lb, skey, ns_, tgt, Ppair)
# PAIR+LANE
keyl = Lb * LANE24 + lane2
cntl = np.bincount(keyl * A + tgt, minlength=nL * LANE24 * A).reshape(nL, LANE24, A).astype(np.float64)
totl = cntl.sum(axis=2, keepdims=True)
Pl = np.clip(cntl / np.maximum(totl, 1), 1e-12, None)
Pluse = np.where(cntl >= FALLBACK_MIN, Pl,
                 np.broadcast_to(Ppair[:, None, :], Pl.shape))
nll_plane = float(-np.log(np.maximum(Pluse[Lb, lane2, tgt], 1e-12)).mean())

rep("")
rep("LADDER (test = same run, frontier order preserved; nats/step):")
rep(f"  PRIOR        {nll_prior:.5f}")
rep(f"  PAIR         {nll_pair_:.5f}   [pair-law level, baseline]")
rep(f"  PAIR+LANE    {nll_plane:.5f}")
rep(f"  PAIR+S       {nll_ps:.5f}")
gain = nll_pair_ - nll_ps
gainl = nll_pair_ - nll_plane
rep(f"  gain(S)      = {gain:+.5f}   gain(LANE) = {gainl:+.5f} nats/step")

# ---- null: shuffle s WITHIN each L bucket ---------------------------------
rep("")
rep(f"null: {NPERM} shuffles of s within L stratum ...")
zsh = None
Lorder = np.argsort(Lb, kind="stable")
Lsort = Lb[Lorder]
s_in = skey[Lorder]
bound = np.searchsorted(Lsort, unq)     # end index of each L bucket
starts = np.r_[0, bound[:-1]]
ends = bound
tsort = tgt[Lorder]
gains = np.empty(NPERM)
for k in range(NPERM):
    per = Lsort * 0
    for a_ in range(nL):
        sl = slice(starts[a_], ends[a_])
        per[sl] = rng.permutation(s_in[sl])
    cnt_ = np.bincount((Lsort * ns_ + per) * A + tsort, minlength=nL * ns_ * A).reshape(nL, ns_, A).astype(np.float64)
    tot_ = cnt_.sum(axis=2, keepdims=True)
    P_ = np.clip(cnt_ / np.maximum(tot_, 1), 1e-12, None)
    Pu_ = np.where(cnt_ >= FALLBACK_MIN, P_,
                   np.broadcast_to(Ppair[:, None, :], P_.shape))
    nll_sh = float(-np.log(np.maximum(Pu_[Lsort, per, tsort], 1e-12)).mean())
    gains[k] = nll_pair_ - nll_sh
dz = gains.std() + 1e-30
z = (gain - gains.mean()) / dz
rep(f"  null gains: {gains.mean():+.5f} +/- {gains.std():.5f} (min {gains.min():+.5f}, max {gains.max():+.5f})")
rep(f"  z(gain(S))  = {z:+.3f}")

# ---- within-cell residual (0234 follow-through) ----------------------------
# does s SPLIT the pair cell? heterogeneity chi2 of s-cells vs the pair cell
resid = []
for a_ in range(min(nL, LMAX + 1)):
    m = (Lb == a_)
    if m.sum() < 10_000:
        continue
    mu_all = np.bincount(tgt[m], minlength=A)
    nall = mu_all.sum()
    sh = 0.0
    for sc in range(ns_):
        ms = m & (skey == sc)
        nsamp = int(ms.sum())
        if nsamp < 2000:
            continue
        mu_s = np.bincount(tgt[ms], minlength=A)
        # chi2 of the cell vs the pair cell
        exp = mu_s * mu_all / nall
        sh += ((mu_s - exp) ** 2 / np.maximum(exp, 1)).sum() / max(A - 1, 1)
    resid.append((a_, int(m.sum()), sh))
rep("")
rep("PER-PAIR-CELL heterogeneity: sum over s-cells of chi2_d/(A-1) (pairs with L >= 10k mass):")
rep("  (under H0 the total ~= number of contributing s-cells; >> 1x = s Splits the pair cell)")
for a_, tot_, sh in resid[:12]:
    rep(f"  L_g = {unq[a_]:>3}:  n = {tot_:>9,}   chi2/(A-1) = {sh:8.3f}   "
        f"(1.0 = homogeneous, >1 = s Splits the pair cell)")

# ---- verdict -----------------------------------------------------------------
rep("")
BAND = 0.2
if abs(gain) < BAND:
    ver = "MARSHALLED (|gain| < 0.2 nats/step): the pair family P(L_next | L) holds - " \
          "spf(p+2) adds no decile-level information beyond L_g"
elif gain > BAND:
    ver = "DEEPER (gain > 0.2): spf(p+2) sharpens the next-gap decile BEYOND the pair family"
else:
    ver = "SHARPER-PAIRED (gain < -0.2): s carries NEGATIVE information - the pair family overfits"
rep(f"VERDICT: {ver}")
rep(f"  z = {z:+.2f} against the within-L stratum shuffle null (200 permutations)")
rep("")
rep(f"done in {time.time() - T0:.1f}s")
