#!/usr/bin/env python3
"""LOOM17b: rotor/charge decomposition, REFINED.  After loom17(a): the
charge E[omega] is a near two-value function of the LEFT LANE FAMILY
(twin-capable {5,11,17,23} ~ -0.72..-0.76; others EXACTLY -2pi/24 for
L>=10) - a deterministic backbone.  This pass makes the backbone exact:
  T1  E[omega] per L (odd 1..41, >=60) x lane family (twin / other)
  T2  partner-transition angular breakdown (2->2, 2->q, q->2, q->q'),
      mean dphi and share, per lane family
  T3  clean within-cell TEST-E: at L in {5,7,9, 11, 13}, E[L_next] by
      omega quartile (within-cell, lane-family pooled)
Off-board.  No RH claim.  Single-threaded.
"""
import math
import time

import numpy as np

X = 100_000_000
XLO = 1_000_000
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
TW = np.array([5, 11, 17, 23])
twfam = np.isin(lane, TW)

off = np.empty(nruns, dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])
comp_idx = np.arange(p[0] + 1, pnxt[-1])
comp_mask = ~s[p[0] + 1:pnxt[-1]]
partner = spf[comp_idx[comp_mask]].astype(np.int64)
nlam = partner.size
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
dphi = np.angle(stepz)
isfirst0 = np.zeros(nlam, dtype=bool)
isfirst0[off] = True
mask14 = valid_slots & ~isfirst0
dphi_pad = np.zeros(nlam, dtype=np.float64)
dphi_pad[valid_slots] = dphi
o14pad = np.where(mask14, dphi_pad, 0.0)
omega14 = np.add.reduceat(o14pad, off)

# step-level partner transition class (on the COMPACTED step domain, ns)
lane_p = partner % 24
sl = lane_p[valid_slots]          # FROM-partner lane per step
sl1 = np.roll(lane_p, -1)[valid_slots]
is2s = sl == 2
is2n = sl1 == 2
cls_s = np.select([is2s & is2n, is2s & ~is2n, ~is2s & is2n], [0, 1, 2], default=3)
CLS = ['2->2', '2->q', 'q->2', 'q->q']
sinterior = np.ones(ns, dtype=bool)
sinterior[step_off[maskL]] = False   # first step of each L>=2 gap is the bookend
n_int = int(sinterior.sum())
rep(f"steps: {ns:,} (interior {n_int:,})   class shares (interior): "
    + "  ".join(f"{CLS[i]}={(cls_s == i).sum() / max(int(n_int),1):.3f}"
               for i in range(4)))

# ---- THE IDENTITY: stored charge == -angle(first partner step) ----------
# full word telescopes: prod z[k+1]/z[k] = z[p'-1]/z[p+1] = 1 (even bookends)
angle_s = dphi_pad  # per SLOT domain (zeros at islast slots)
first_slot = off[maskL]
dphi_step0 = np.array(angle_s[first_slot])
idxm = np.nonzero(maskL)[0]
dev = np.abs(omega14[idxm] + dphi_step0)
dev = np.minimum(dev, 2 * math.pi - dev)
rep(f"IDENTITY: max |omega14 + angle(step0)| (wrapped) = {dev.max():.2e} over "
    f"{len(idxm):,} gaps (L>=2);  deviations > 1e-9: {int((dev > 1e-9).sum())}")
q1 = partner[first_slot + 1]
lane_m = lane[idxm]
for fam, lns in (("OT(1,7,13,19)", [1, 7, 13, 19]), ("TW(5,11,17,23)", [5, 11, 17, 23])):
    m = np.isin(lane_m, lns)
    uq = np.unique(q1[m])
    share3 = float((q1[m] == 3).mean())
    rep(f"  {fam}: n={int(m.sum()):,}  spf(p+2)=3 share = {share3:.4f}  "
        f"distinct q1 = {len(uq):,} (smallest: {uq[:6].tolist()})  "
        f"E[charge] = {omega14[idxm][m].mean()/(2*math.pi/24):+.4f} ticks")

ok = np.arange(nruns - 1)
Ln = L[ok + 1].astype(np.float64)
w = omega14[ok]
Lc = L[ok].astype(np.int64)
twf = twfam[ok]

rep("")
rep("== T1: E[omega] per L x lane family (twin lanes 5,11,17,23 | other 1,7,13,19) ==")
rep(f"{'L(gap)':>8s} {'n_TW':>10s} {'E[w]_TW':>10s}   {'n_OT':>10s} {'E[w]_OT':>10s}")
for lev in list(range(1, 43, 2)) + [60]:
    if lev < 60:
        m = Lc == lev
    else:
        m = Lc >= 60
    n_tw = int((m & twf).sum()); n_ot = int((m & ~twf).sum())
    e_tw = w[m & twf].mean() if n_tw else float('nan')
    e_ot = w[m & ~twf].mean() if n_ot else float('nan')
    tag = f"{lev}(gap {lev+1})" if lev < 60 else ">=60"
    rep(f"{tag:>8s} {n_tw:10,} {e_tw:+10.4f}   {n_ot:10,} {e_ot:+10.4f}")

rep("")
rep(f"exact values: -2pi/24 = {-2*math.pi/24:+.4f}   -2pi/23 = {-2*math.pi/23:+.4f}")

rep("")
rep("== T2: partner-transition angular breakdown, per lane family ==")
dphi_s = dphi  # already per compacted step
fam = np.repeat(twfam, Lm1)  # per step (ns)
assert fam.size == ns
for ilab, ifam in (("TW", fam), ("OT", ~fam)):
    for i in range(4):
        m = sinterior & (cls_s == i) & ifam
        n = m.sum()
        if n == 0:
            continue
        rep(f"  {ilab} {CLS[i]}: n={n:12,}  mean dphi = {dphi_s[m].mean():+.5f} "
            f"(share of {ilab} interior steps = {n / max(int((sinterior & ifam).sum()),1):.3f})")

rep("")
rep("== T3: WITHIN-CELL TEST-E: E[L_next] | omega quartile, per L (families pooled) ==")
for lev in (5, 7, 9, 11, 13):
    m = Lc == lev
    ww = w[m]
    ll = Ln[m]
    if len(ww) < 4000:
        continue
    q = np.quantile(ww, [0.25, 0.5, 0.75])
    qt = np.digitize(ww, q)
    parts = [f"Q{i}={ll[qt == i].mean():.4f}" for i in range(4)]
    r = float(np.corrcoef(ww, ll)[0, 1])
    rep(f"  L={lev:2d} (gap {lev+1:2d}) n={len(ww):8,}  " + "  ".join(parts)
        + f"   grand={ll.mean():.4f}  r={r:+.5f}")
rep("")
rep(f"done in {time.time() - t0:.1f}s")
