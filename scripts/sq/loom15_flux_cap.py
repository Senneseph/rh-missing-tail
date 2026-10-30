#!/usr/bin/env python3
"""
LOOM15 — THE FLUX CAPACITOR (vortex/void phase 2)
(off-board side-quest; no RH claim; 1 core, 4 open)

The owner's flux-capacitor + 3D-movie + 26-note-symphony picture, made
finite on the prime tape [XLO, X]:

  flux capacitor        = per-gap signed flux B = sum Im(z_{k+1} zbar_k)
                          (magnitude AND direction stored in the complex step)
  3D-movie pair         = (Re mean, Im mean) of the step complex — two 2D
                          channels that preserve the full 24-gon plane data
                          (Re = staying put / momentum, Im = the rotor turn)
  discharge = inverse   = does the rotor state survive ACROSS the void?
  out-rush (not even)   = corr(B_i, B_{i+1}) + sign-persistence across the
                          primality boundary vs a shuffled null (mirror,
                          not a reset?)
  26 notes (A-Z)        = a per-gap channel bank; each channel is tested
                          against the void lane (p' mod 24) with a null
  no memristor          = the signed complex step is stored, never |V|
                          (0231 A2 was null precisely because |V| destroys
                          the direction the rotor carries in Im)

Channels (A-Z; V is the target void lane, Y is scale):
  A amp        gap length L
  B bias       fraction of partner-2 claims (the even emitter)
  C cycle      winding number round(sum(dphi)/2pi) ("looped")
  D drift      |V|/sqrt(L)  (0231 A2 momentum)
  E echo       lag-1 partner self-repeat fraction
  F flux       B*(L-1) = total signed flux (the capacitive charge)
  G gate       last-odd partner lane (p'-2)          [category]
  H hold       largest partner in the gap
  I intersect  count of hard turns (|dphi| > pi/2)
  J jump       max |partner_{k+1} - partner_k|
  K keep       fraction of wheel partners (<= 13)
  L lose       1 - K
  M moment     |V|
  N no-return  1 if the word never revisits its starting lane
  O oddflank   first-odd partner lane (p+2)          [category]
  P parity     fraction of odd-partner claims
  Q quiet      number of distinct partners
  S shape      std of |dphi|
  T turn       mean |dphi| ("which way it was squiggling overall" companion)
  U unpaired   fraction of partners occurring exactly once
  V voidlane   p' mod 24   (THE TARGET - not a feature)
  W wait       position fraction of the max partner (where the strong churn)
  X xrun       longest equal-partner run
  Y ygap       gap midpoint (scale, not tested)
  Z zeta       sum 1/partner (claim energy)

Null protocol: gap-level shuffles / lane-pool draws, seeded.
"""
import math
import time
import numpy as np

T0 = time.time()
SEED = 15
NPERM = 200


def rep(*a):
    print(*a, flush=True)


X = 10_000_000
XLO = 100_000
rng = np.random.default_rng(SEED)


def sieve(x):
    s = np.ones(x + 1, dtype=bool)
    s[0] = s[1] = False
    for i in range(2, int(x ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return s


s = sieve(X)
primes = np.nonzero(s)[0]
pfmax = int(math.isqrt(X)) + 1
spf = np.zeros(X + 1, dtype=np.int64)
for p in primes[primes <= pfmax]:
    m = np.arange(p * p, X + 1, p)
    mask = spf[m] == 0
    spf[m[mask]] = p

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
_ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
ip = ip[_ok]
p = primes[ip]
pnxt = primes[ip + 1]
nruns = len(p)
L = (pnxt - p - 1).astype(np.int64)
void_lane = pnxt % 24
off = np.empty(nruns, dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])
comp_idx = np.arange(p[0] + 1, pnxt[-1])
comp_mask = ~s[p[0] + 1:pnxt[-1]]
partner = spf[comp_idx[comp_mask]]
nlam = partner.size
assert nlam == int(L.sum())
lane_of_partner = partner % 24
z = np.exp(2j * math.pi * lane_of_partner / 24.0)
rep(f"runs: {nruns}   claimed composites: {nlam:,}")

# ---- per-gap step complex ---------------------------------------------------
# steps live between consecutive partners; L-1 per gap; runs with L>=2
maskL = L >= 2
n2 = int(maskL.sum())
rep(f"runs with L>=2: {n2}")
# flat step arrays: position k of flat step belongs to gap g, step index j
# step position for gap g: off_g + j, j = 0..L_g-2  (between partner j and j+1)
Lm1 = (L - 1).astype(np.int64)  # steps per run (0 for L=1)
step_off = np.empty(nruns, dtype=np.int64)
step_off[0] = 0
np.cumsum(Lm1[:-1], out=step_off[1:])
ns = int(Lm1.sum())
zp1 = np.roll(z, -1)
# zero the cross-run boundary steps (last partner of a run -> first of next)
islast = np.zeros(nlam, dtype=bool)
islast[off[~maskL] if False else off + (L - 1)] = True
steps = zp1 / z
steps = np.where(islast, 1.0 + 0j, steps)
# compact the valid steps (drop 0-step runs' nothing; L=1 runs have no slot)
valid_slots = ~islast
stepz = steps[valid_slots]
assert stepz.size == ns
dphi = np.angle(stepz)
a_re = stepz.real
b_im = stepz.imag

# per-run sums of b (flux), a (stay), and |sum step| via cumsum tricks
bpad = np.zeros(nlam, dtype=np.float64)
bpad[valid_slots] = b_im
apad = np.zeros(nlam, dtype=np.float64)
apad[valid_slots] = a_re
zpad = np.zeros(nlam, dtype=complex)
zpad[valid_slots] = stepz
Bsum = np.add.reduceat(bpad, off)     # per-gap flux (0 for L=1)
Asum = np.add.reduceat(apad, off)
# per-gap |sum of stepz|
Zc = np.concatenate(([0j], np.cumsum(zpad)))
Vstep = np.abs(Zc[off + Lm1] - Zc[off])
Lfloat = L.astype(np.float64)
Bb = np.where(maskL, Bsum / np.maximum(Lm1, 1), 0.0)   # per-step rotor rate
Aa = np.where(maskL, Asum / np.maximum(Lm1, 1), 0.0)   # per-step stay
# global 3D-movie mean point (over all steps)
glob = stepz.mean()
rep("")
rep("3D-MOVIE PAIR (over all %s steps):" % format(ns, ","))
rep(f"  Re mean (stay)  = {a_re.mean():+.6f} +/- {a_re.std()/math.sqrt(a_re.size):.6f}")
rep(f"  Im mean (turn)  = {b_im.mean():+.6f} +/- {b_im.std()/math.sqrt(b_im.size):.6f}")
rep(f"  global step phase = {math.degrees(float(np.angle(glob))):+.2f} deg"
      f"   (negative = retrograde rotor, 0231)")

# ---- THE STORED CHARGE (loom14-consistent; the 0231 rotor, z = -590) ----
# Steps whose FROM position is neither the run's first (p+1) nor its last
# (p'-1): the word from p+2 (interior start) to p'-1 (even bookend).
# The FULL interior sum telescopes to z[p'-1]*zbar[p+1] = 1 EXACTLY (both
# ends are the even bookend, lane 2) - the even framing erases the net
# phase of the word and the charge is loom14's sum below (signed rad).
isfirst0 = np.zeros(nlam, dtype=bool)
isfirst0[off] = True
mask14 = valid_slots & ~isfirst0
dphi_pad = np.zeros(nlam, dtype=np.float64)
dphi_pad[valid_slots] = dphi
o14pad = np.where(mask14, dphi_pad, 0.0)
omega14 = np.add.reduceat(o14pad, off)
first_int = np.minimum(off + 1, nlam - 1)
W14 = np.where(L >= 2, z[off + L - 1] * np.conj(z[first_int]), 1.0 + 0j)
rep("")
rep("CHARGE CROSS-CHECK vs 0231 (all gaps):")
rep(f"  E[Omega] = {omega14.mean():+.4f} (0231: -0.4300)"
      f"   P(Omega>0) = {(omega14 > 0).mean():.4f} (0231: 0.0962)")
m3 = omega14[maskL]
rep("")
rep("3D-MOVIE PAIR OF THE CHARGE (gaps with L>=2):")
rep(f"  Re (cos w) mean = {np.cos(m3).mean():+.6f}   Im (sin w) mean = {np.sin(m3).mean():+.6f}")
rep(f"  E|Omega| = {np.abs(m3).mean():.4f} rad (0231 E|Omega| = 0.7321)")
rep("  Omega quantiles p01/p25/p50/p75/p99 = "
    f"{np.quantile(m3, [0.01, 0.25, 0.5, 0.75, 0.99]).round(3).tolist()}")

# ---- the capacitor test: does the stored charge survive ACROSS the void? ----
# 'inverse out-rush' hypothesis: discharge goes OPPOSITE to the charge,
# so we test persistence AND flip-excess.
idx2 = np.nonzero(maskL)[0]
Fseq = omega14[idx2]
nF = len(Fseq)
sgn = np.sign(Fseq)
real_corr = float(np.corrcoef(Fseq[:-1], Fseq[1:])[0, 1])
real_pers  = float(((sgn[:-1] * sgn[1:]) > 0).mean())
real_flip  = float(((sgn[:-1] * sgn[1:]) < 0).mean())
null_corr = np.empty(NPERM)
null_flip = np.empty(NPERM)
null_pers = np.empty(NPERM)
for i in range(NPERM):
    P = Fseq[rng.permutation(nF)]
    sp = np.sign(P)
    null_corr[i] = np.corrcoef(P[:-1], P[1:])[0, 1]
    null_flip[i] = ((sp[:-1] * sp[1:]) < 0).mean()
    null_pers[i] = ((sp[:-1] * sp[1:]) > 0).mean()
rep("")
rep("FLUX CAPACITOR (stored charge vs the void, gaps with L>=2):")
rep(f"  corr(omega_i, omega_{i+1}): real = {real_corr:+.5f}   null {null_corr.mean():+.5f} +/- {null_corr.std():.5f}"
      f"   (p+ = {(null_corr >= real_corr).mean():.4f}, p- = {(null_corr <= real_corr).mean():.4f})")
rep(f"  sign persistence:     real {real_pers:.5f}   vs null {null_pers.mean():.5f} +/- {null_pers.std():.5f}"
      f"   (p = {(null_pers >= real_pers).mean():.4f})")
rep(f"  flip rate:            real {real_flip:.5f}   vs null {null_flip.mean():.5f} +/- {null_flip.std():.5f}")

# ---- the 26-note channel bank ----------------------------------------------
# cheap per-gap features (vectorized where possible)
def per_gap_bincount_sum(vals_per_gap):
    # vals_per_gap: (nruns, L_g) not stored; use the flat partner + offsets
    pass

# build per-run arrays via reduceat / searchsorted over the flat partner array
def reduceat_stat(flat, mode):
    if mode == "sum":
        return np.add.reduceat(flat, off)
    if mode == "max":
        return np.maximum.reduceat(flat, off)
    if mode == "count":
        return np.add.reduceat(np.ones_like(flat), off)

bias = np.add.reduceat((partner == 2).astype(np.int64), off) / Lfloat
keep = np.add.reduceat((partner <= 13).astype(np.int64), off) / Lfloat
lose = 1 - keep
parity = np.add.reduceat((partner % 2 == 1).astype(np.int64), off) / Lfloat
zeta = np.add.reduceat(1.0 / partner.astype(np.float64), off)
hold = np.maximum.reduceat(partner, off)
echo = np.zeros(nruns)
dphi_abs = np.abs(dphi)
# steps flat -> per-run: echo = fraction of consecutive partners equal (in-run)
step_is0 = (dphi == 0).astype(np.int64)
step_is0pad = np.zeros(nlam, dtype=np.int64)
step_is0pad[valid_slots] = step_is0
echo_s = np.add.reduceat(step_is0pad, off) / np.maximum(Lm1, 1)
hard = (np.abs(dphi) > math.pi / 2).astype(np.int64)
hardpad = np.zeros(nlam, dtype=np.int64)
hardpad[valid_slots] = hard
intersec = np.add.reduceat(hardpad, off)
shape_s = np.zeros(nruns)
dabs_pad = np.zeros(nlam, dtype=np.float64)
dabs_pad[valid_slots] = dphi_abs
turn_s = np.add.reduceat(dabs_pad, off) / np.maximum(Lm1, 1)
# std of |dphi| per run: sqrt(E[x^2]-E[x]^2)
dphi2pad = np.zeros(nlam, dtype=np.float64)
dphi2pad[valid_slots] = dphi_abs * dphi_abs
dphi2_s = np.add.reduceat(dphi2pad, off) / np.maximum(Lm1, 1)
shape_s = np.sqrt(np.clip(dphi2_s - turn_s * turn_s, 0, None))
# xrun: longest equal-partner run per gap — one pass
xrun = np.zeros(nruns, dtype=np.int64)
cur_here = 0
prev_val = None
rc = 0
for ii in range(nlam):
    if ii == off[rc] or prev_val is None:
        cur_here = 1
    elif partner[ii] == prev_val:
        cur_here += 1
    else:
        cur_here = 1
    prev_val = partner[ii]
    if cur_here > xrun[rc]:
        xrun[rc] = cur_here
    if ii == off[rc] + L[rc] - 1:
        rc += 1
# fix: the loop above is O(nlam) python = 9.2M — acceptable (~2-3s)
# quiet: distinct partners per run — vectorized via unique per run is heavy;
# approximate with a cap-limited hash table is overkill: use the count of
# distinct via searchsorted on sorted-per-run is heavy too.  Instead compute
# distinct for partner values up to a cap with per-value runs:
# quiet = number of distinct partner values in the gap (full, exact, faster way:
# mark each (run, value) once via the flat sorted-by-value trick)
order_v = np.argsort(partner, kind="stable")
pv = partner[order_v]
runid = np.searchsorted(off, order_v, side="right") - 1
runid = np.clip(runid, 0, nruns - 1)
distinct_keys = pv.astype(np.int64) * nruns + runid
# count distinct (value, run) keys per run
dcount = np.bincount(runid[~np.in1d(distinct_keys, distinct_keys[1:], assume_unique=True)] \
                     if False else runid[np.concatenate(([True], distinct_keys[1:] != distinct_keys[:-1]))],
                     minlength=nruns)
quiet = dcount.astype(np.float64)
unpaired = quiet * 0.0
# unpaired: partners occurring exactly once in the gap:
one_mask = np.concatenate(([True], distinct_keys[1:] != distinct_keys[:-1]))
one_mask2 = one_mask & np.concatenate((distinct_keys[1:] != distinct_keys[:-1], [True]))
unp_mask = one_mask & one_mask2
unpaired = np.bincount(runid[unp_mask], minlength=nruns).astype(np.float64)
unpaired = unpaired / Lfloat
# jump: max |partner_{k+1} - partner_k| within run
djump = np.abs(np.diff(partner))
djump_pad = np.zeros(nlam, dtype=np.int64)
djump_pad[valid_slots & ~islast] = np.abs(np.diff(partner)[~islast[1:]] ) if False else 0
# simpler: diff at valid internal steps
diff_flat = np.abs(np.diff(partner))
diff_at = np.zeros(nlam, dtype=np.int64)
# position k (flat, k>=1) has diff diff_flat[k-1]; it is in-run iff not a boundary
isfirst = np.zeros(nlam, dtype=bool)
isfirst[off] = True
diff_at[1:][~isfirst[1:]] = diff_flat[~isfirst[1:]]
jump = np.maximum.reduceat(diff_at, off)
# wait: position fraction of the max partner
imax = np.empty(nruns, dtype=np.int64)
# argmax per run over the flat partner:
cummax = np.maximum.accumulate(partner)
# first occurrence of the run max within the run:
runmax = np.maximum.reduceat(partner, off)
# find per-run first index where partner == runmax:
# use searchsorted on cummax boundaries — simplest robust: per run search in flat
# (nruns=654k, each a small slice) — vectorize via the ismax trick:
ismax = partner == runmax[np.searchsorted(off, np.arange(nlam), side="right") - 1]
ismax_runfirst = np.zeros(nlam, dtype=bool)
prev_ismax = False
pos_in_run = np.zeros(nlam, dtype=np.int64)
c = 0
rc = 0
for ii in range(nlam):
    if ii == off[rc]:
        c = 0
    pos_in_run[ii] = c
    c += 1
    if ii == off[rc] + L[rc] - 1:
        rc += 1
        if rc >= nruns:
            break
# mark first ismax within each run
cur_run = np.searchsorted(off, np.arange(nlam), side="right") - 1
fm = ismax
order = np.lexsort((pos_in_run[fm], cur_run[fm]))
cr_o = cur_run[fm][order]
first_idx = np.unique(cr_o, return_index=True)[1]
wait_num = np.full(nruns, -1.0)
wait_num[cr_o[first_idx]] = pos_in_run[fm][order][first_idx] / Lfloat
wait = np.where(wait_num >= 0, wait_num, 0.0)
# no-return: word never revisits its starting lane (L>=2; else 0)
# per-run: lane of first partner; does any later partner share the lane?
first_lane = np.full(nruns, -1, dtype=np.int64)
first_lane[np.arange(nruns)] = lane_of_partner[off]
noreturn = np.zeros(nruns, dtype=np.int64)
seen_lane = {}
for ii in range(0, nlam):
    pass
# python loop over 9.2M is slow but ok (~3-5s); do it once:
noreturn = np.ones(nruns, dtype=np.int64)
cur_set = None
rc = 0
for ii in range(nlam):
    if ii == off[rc]:
        cur_set = set()
        cur_set.add(lane_of_partner[ii])
    else:
        lv = lane_of_partner[ii]
        if lv not in cur_set:
            cur_set.add(lv)
        else:
            if noreturn[rc] == 1:
                noreturn[rc] = 0
    if ii == off[rc] + L[rc] - 1:
        rc += 1
        if rc >= nruns:
            break
# gate/oddflank lanes (odd flanks only exist for L>=2)
maskO = L >= 2
gate_lane = np.full(nruns, -1, dtype=np.int64)
oddflank = np.full(nruns, -1, dtype=np.int64)
if maskO.any():
    gate_lane[maskO] = (spf[pnxt[maskO] - 2]) % 24
    oddflank[maskO] = (spf[p[maskO] + 2]) % 24
# cycle: winding number per run from the dphi sum
phisum = np.add.reduceat(dphi_pad, off)
cycle = np.round(phisum / (2 * math.pi)).astype(np.int64)

feat_names = ["A amp", "B bias", "C cycle", "D drift", "E echo", "F flux",
              "G gate", "H hold", "I intersect", "J jump", "K keep", "L lose",
              "M moment", "N no-return", "O oddflank", "P parity", "Q quiet",
              "S shape", "T turn", "U unpaired", "W wait", "X xrun",
              "Z zeta"]
feats = {
    "A amp": Lfloat, "B bias": bias, "C cycle": cycle.astype(np.float64),
    "D drift": Vstep / np.sqrt(Lfloat), "E echo": echo_s,
    "F flux": omega14, "G gate": gate_lane.astype(np.float64),
    "H hold": hold.astype(np.float64), "I intersect": intersec.astype(np.float64),
    "J jump": jump.astype(np.float64), "K keep": keep, "L lose": lose,
    "M moment": Vstep, "N no-return": noreturn.astype(np.float64),
    "O oddflank": oddflank.astype(np.float64), "P parity": parity,
    "Q quiet": quiet, "S shape": shape_s, "T turn": turn_s,
    "U unpaired": unpaired, "W wait": wait, "X xrun": xrun.astype(np.float64),
    "Z zeta": zeta,
}
rep("")
rep("26-NOTE CHANNEL BANK (per-gap means):")
for k in feat_names:
    v = feats[k]
    vm = v[v >= 0]
    rep(f"  {k:<12} mean = {np.nanmean(v):+.4f}   std = {np.nanstd(v):.4f}")

# ---- each channel vs the void lane (null = lane marginals) ------------------
rep("")
rep("CHANNEL vs VOID LANE (p' mod 24), chi2 and top cell vs independence:")
rep(f"  base overlap if independent = {(1/8)**2 * 8:.4f} per-lane share null")
rows = []
LANES8 = [1, 5, 7, 11, 13, 17, 19, 23]
for k in feat_names:
    v = feats[k]
    good = v >= 0
    v = v[good]
    y = void_lane[good]
    if k in ("G gate", "O oddflank"):
        xv = np.ceil(v).astype(np.int64)
        tabs, xb = np.unique(xv, return_inverse=True)
        _h = np.histogram2d(xb, np.digitize(y, [0, 3, 4, 6, 10, 12, 16, 18, 22]) - 1,
                            bins=(len(tabs), 8))
        tb = _h[0] if isinstance(_h, tuple) else _h
        nrm = len(y)
        er = (tb.sum(axis=1, keepdims=True) * tb.sum(axis=0, keepdims=True)) / nrm
        with np.errstate(divide="ignore", invalid="ignore"):
            chi = float(np.nansum((tb - er) ** 2 / np.where(er > 0, er, 1.0)))
        kk = int(np.argmax(tb - er))
        a, b = divmod(kk, 8)
        topcell = tb[a, b] / max(er[a, b], 1e-9)
        lab = f"lane {tabs[a]} -> {LANES8[b]}"
    else:
        q = np.quantile(v, [0, 0.25, 0.5, 0.75, 1.0])
        qb = np.digitize(v, q[1:-1])
        yb = np.digitize(y, [0, 3, 4, 6, 10, 12, 16, 18, 22]) - 1
        _h = np.histogram2d(qb, yb, bins=(4, 8))
        tb = _h[0] if isinstance(_h, tuple) else _h
        nrm = len(y)
        er = (tb.sum(axis=1, keepdims=True) * tb.sum(axis=0, keepdims=True)) / nrm
        with np.errstate(divide="ignore", invalid="ignore"):
            chi = float(np.nansum((tb - er) ** 2 / np.where(er > 0, er, 1.0)))
        kk = int(np.argmax(tb - er))
        a, b = divmod(kk, 8)
        topcell = tb[a, b] / max(er[a, b], 1e-9)
        lab = f"quart {a} -> lane {LANES8[b]}"
    rows.append((k, chi, topcell, lab))
rows.sort(key=lambda r: -r[1])
for k, chi, topcell, lab in rows[:10]:
    rep(f"  {k:<12} chi2 = {chi:>12.1f}   top cell x{topcell:.3f}  ({lab})")

# ---- TEST E: does the stored charge predict the EXACT next one? ------------
# "the exact one" = the exact next prime = next gap length L_{g+1}.
gaps_ok = np.nonzero(maskL)[0]
Fc = omega14[gaps_ok]
Lnext = np.minimum(gaps_ok + 1, nruns - 1)
Ln = L[Lnext].astype(np.float64)
re_corr = float(np.corrcoef(Fc, Ln)[0, 1])
re_self = float(np.corrcoef(omega14, L.astype(np.float64))[0, 1])
nullc = np.empty(NPERM)
for i in range(NPERM):
    Pc = Fc[rng.permutation(len(Fc))]
    nullc[i] = np.corrcoef(Pc, Ln)[0, 1]
rep("")
rep("TEST E: stored charge -> the EXACT next one (gap length L_{g+1}):")
rep(f"  corr(omega_i, L_next): real = {re_corr:+.6f}   null {nullc.mean():+.6f} +/- {nullc.std():.6f}"
      f"   (p+ = {(nullc >= re_corr).mean():.4f}, p- = {(nullc <= re_corr).mean():.4f})")
rep(f"  corr(omega_i, L_i)   (self, sanity): {re_self:+.6f}")
q4 = np.quantile(Fc, [0.25, 0.5, 0.75])
qq = np.digitize(Fc, q4)
rep("  E[L_next] by charge quartile: " +
    "  ".join(f"Q{k}={Ln[qq == k].mean():.4f}" for k in range(4)) +
    f"   grand={Ln.mean():.4f}")

rep("")
rep(f"== done in {time.time() - T0:.1f}s ==")
