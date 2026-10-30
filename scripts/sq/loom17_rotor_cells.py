#!/usr/bin/env python3
"""LOOM17 (0234-prep): ROTOR / CHARGE DECOMPOSITION - where does the bank's
measured value actually hide?  The 0233 ceiling showed the 26-note bank is
decile-dead; 0231/0232 showed the rotor charge (omega14) is directionally
real (z=-590) and weakly next-gap-predictive (4.5 sigma, marginal).  This
instrument asks: does the charge concentrate in ARITHMETIC x GEOMETRY cells
(mod-24 lane of the left prime x gap length), where a single-channel
decile target is blind?

Finite objects:
  - X = 1e8, primes p (p' <= X), XLO = 1e6 (skip the front)
  - per gap: L = p'-p-1 (void width), lane = p mod 24, omega14 (the 0231
    charge, loom15-exact pipeline), L_next
  - cells: (lane, Lcap) with Lcap = min(L, 60)  ->  24 x 61 cells
  - per cell (n >= NMIN): E[omega], P(omega>0), E[L_next],
    corr(omega, L_next) with z
  - tests: T1 cell-mean-omega z vs global; T2 per-cell corr z; shuffled
    nulls (omega permuted between gaps within the same run of cells)
Same cross-check anchors as 0231 (E[Omega] ~ -0.43, P(Omega>0) ~ 0.096).
Off-board.  No RH claim.  Single-threaded by construction.
"""
import math
import time

import numpy as np

X = 100_000_000
XLO = 1_000_000
NMIN = 200
SEED = 17
t0 = time.time()


def rep(*a):
    print(*a, flush=True)


def sieve(x):
    s = np.ones(x + 1, dtype=bool)
    s[0] = s[1] = False
    for i in range(2, int(x ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return s


s = sieve(X)
primes = np.nonzero(s)[0]
spf = np.zeros(X + 1, dtype=np.int32)
for p in primes[primes <= int(math.isqrt(X))]:
    m = np.arange(p * p, X + 1, p)
    spf[m] = np.where(spf[m] == 0, p, spf[m])

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
_ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
ip = ip[_ok]
p = primes[ip]
pnxt = primes[ip + 1]
nruns = len(p)
L = (pnxt - p - 1).astype(np.int64)
lane = (p % 24).astype(np.int64)
rep(f"gaps: {nruns:,}   (X={X}, XLO={XLO})")

# ---- loom15-exact charge pipeline -----------------------------------------
off = np.empty(nruns, dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])
comp_idx = np.arange(p[0] + 1, pnxt[-1])
comp_mask = ~s[p[0] + 1:pnxt[-1]]
partner = spf[comp_idx[comp_mask]].astype(np.int64)
nlam = partner.size
assert nlam == int(L.sum())
z = np.exp(2j * math.pi * (partner % 24) / 24.0)

maskL = L >= 2
Lm1 = (L - 1).astype(np.int64)
step_off = np.empty(nruns, dtype=np.int64)
step_off[0] = 0
np.cumsum(Lm1[:-1], out=step_off[1:])
ns = int(Lm1.sum())
zp1 = np.roll(z, -1)
islast = np.zeros(nlam, dtype=bool)
islast[off + (L - 1)] = True
steps = zp1 / z
steps = np.where(islast, 1.0 + 0j, steps)
valid_slots = ~islast
stepz = steps[valid_slots]
assert stepz.size == ns
dphi = np.angle(stepz)
isfirst0 = np.zeros(nlam, dtype=bool)
isfirst0[off] = True
mask14 = valid_slots & ~isfirst0
dphi_pad = np.zeros(nlam, dtype=np.float64)
dphi_pad[valid_slots] = dphi
o14pad = np.where(mask14, dphi_pad, 0.0)
omega14 = np.add.reduceat(o14pad, off)
rep(f"charge cross-check vs 0231: E[Omega] = {omega14.mean():+.4f} "
    f"(0.0231@1e7: -0.4300)   P(Omega>0) = {(omega14 > 0).mean():.4f} "
    f"(0.0962)")


# ---- pairs -----------------------------------------------------------------
ok = np.arange(nruns - 1)
Lnext = (pnxt[1:] - p[1:]).astype(np.float64)  # = L[ok+1]
w = omega14[ok]
la = lane[ok]
Lc = L[ok].astype(np.float64)
Ln = Lnext.astype(np.float64)
wz = w - w.mean()
Lwz = Ln - Ln.mean()
rw = float(np.sum(wz * Lwz) / math.sqrt(np.sum(wz * wz) * np.sum(Lwz * Lwz)))
zrw = rw * math.sqrt(len(ok) - 2)
sw = float(w.std(ddof=1))
rep(f"MARGINAL: corr(omega, L_next) = {rw:+.6f}  z = {zrw:+.2f}  "
    f"(0232 @1e7: +0.0059 z=4.5)   sd(omega) = {sw:.4f}")

# ---- cells -----------------------------------------------------------------
Lcap = np.minimum(L[ok], 60).astype(np.int64)
key = (la * 61 + Lcap).astype(np.int64)
NCELL = 24 * 61
cnt = np.bincount(key, minlength=NCELL)
wsum = np.bincount(key, weights=w, minlength=NCELL)
wpos = np.bincount(key, weights=(w > 0).astype(np.float64), minlength=NCELL)
Lsum = np.bincount(key, weights=Ln, minlength=NCELL)
wL = np.bincount(key, weights=w * Ln, minlength=NCELL)
w2 = np.bincount(key, weights=w * w, minlength=NCELL)
L2 = np.bincount(key, weights=Ln * Ln, minlength=NCELL)

rep("")
rep("== T1: per-cell (lane x Lcap) charge mean, vs global ==")
best = []
for c in range(NCELL):
    n = cnt[c]
    if n < NMIN:
        continue
    mw = wsum[c] / n
    se = sw / math.sqrt(n)
    zc = (mw - w.mean()) / se
    best.append((abs(zc), c, n, mw, zc))
best.sort(reverse=True)
rep(f"cells with n>={NMIN}: {sum(1 for c in range(NCELL) if cnt[c] >= NMIN)}   "
    f"max|z| = {best[0][0]:.2f}   #|z|>3: {sum(1 for b in best if b[0] > 3)} "
    f"(expect ~5% = {0.05 * len(best):.0f})")
for _, c, n, mw, zc in best[:8]:
    rep(f"  lane={c // 61:2d} Lcap={c % 61:2d}  n={n:7,}  E[w]={mw:+.4f}  z={zc:+.2f}")

# L-decile groups for the compact table
def lgroup(l):
    if l <= 2:
        return 0
    if l == 4:
        return 1
    if l == 6:
        return 2
    if l == 8:
        return 3
    if l <= 12:
        return 4
    if l <= 18:
        return 5
    if l <= 30:
        return 6
    return 7
LG = ['L2', 'L4', 'L6', 'L8', '10-12', '14-18', '20-30', '>30']
rep("")
rep("compact table (lane x L-group): E[omega]:")
gkey = la * 9 + np.array([lgroup(int(x)) for x in L[ok]])
gcnt = np.bincount(gkey, minlength=24 * 9)
gw = np.bincount(gkey, weights=w, minlength=24 * 9)
hdr = "lane  " + "".join(f"{g:>9s}" for g in LG)
rep(hdr)
for lane_i in range(24):
    row = f"{lane_i:4d} "
    for gi in range(8):
        c = lane_i * 9 + gi
        if gcnt[c] >= NMIN:
            row += f"{gw[c] / gcnt[c]:+9.3f}"
        else:
            row += f"{'  .':>9s}"
    rep(row)

# ---- T2: per-cell corr(omega, L_next) --------------------------------------
rep("")
rep("== T2: per-cell corr(omega, L_next) (n>=1000 for stable z) ==")
t2 = []
for c in range(NCELL):
    n = cnt[c]
    if n < 1000:
        continue
    sxx = L2[c] - n * (Lsum[c] / n) ** 2
    syy = w2[c] - n * (wsum[c] / n) ** 2
    sxy = wL[c] - n * (Lsum[c] / n) * (wsum[c] / n)
    if sxx <= 0 or syy <= 0:
        continue
    r = sxy / math.sqrt(sxx * syy)
    zt = r * math.sqrt(n - 2)
    t2.append((abs(zt), c, n, r, zt))
t2.sort(reverse=True)
rep(f"cells tested: {len(t2)}   max|z| = {t2[0][0]:.2f}   "
    f"#|z|>3: {sum(1 for b in t2 if b[0] > 3)} (expect ~5% = {0.05 * len(t2):.0f})")
for _, c, n, r, zt in t2[:8]:
    rep(f"  lane={c // 61:2d} Lcap={c % 61:2d}  n={n:7,}  r={r:+.5f}  z={zt:+.2f}")

# ---- shuffled nulls (self-consistency of the permutation machinery) --------
rep("")
rep("== NULLS (omega permuted between gaps, same cells) ==")
rng = np.random.default_rng(SEED)
wsh = w.copy()
for trial in range(3):
    wsh = w.copy()
    perm = rng.permutation(len(wsh))
    wsh2 = wsh[perm]
    wshsum = np.bincount(key, weights=wsh2, minlength=NCELL)
    wshL = np.bincount(key, weights=wsh2 * Ln, minlength=NCELL)
    wsh2 = np.bincount(key, weights=wsh2 * wsh2, minlength=NCELL)
    t1m = 0.0
    for c in range(NCELL):
        n = cnt[c]
        if n < NMIN:
            continue
        mw = wshsum[c] / n
        t1m = max(t1m, abs(mw - w.mean()) / (sw / math.sqrt(n)))

    t2m = 0.0
    for c in range(NCELL):
        n = cnt[c]
        if n < 1000:
            continue
        sxx = L2[c] - n * (Lsum[c] / n) ** 2
        syy = wsh2[c] - n * (wshsum[c] / n) ** 2
        sxy = wshL[c] - n * (Lsum[c] / n) * (wshsum[c] / n)
        if sxx <= 0 or syy <= 0:
            continue
        r = sxy / math.sqrt(sxx * syy)
        t2m = max(t2m, abs(r * math.sqrt(n - 2)))
    rep(f"  trial {trial}: null max|z| T1 = {t1m:.2f}   T2 = {t2m:.2f}")
rep("")
rep(f"done in {time.time() - t0:.1f}s")
