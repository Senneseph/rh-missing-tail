#!/usr/bin/env python3
"""
LOOM14 — THE VORTEX/VOID DOT INSTRUMENT
(oFF-BOARD side-quest; no RH claim; 1 core, 4 open)

The owner's vortex/void + syringe picture, made finite:

  input (ambient)  = the integer flow (density 1; room = the window)
  vacuum           = sieve pressure Pi_y = prod_{p<=y}(1-1/p), depth ~ log log y
  boil (conversion)= a composite is CLAIMED by its smallest prime partner spf(n)
                     (the vortex that churns it out)
  work output      = the y-rough residue; at y = sqrt(x) the residue is EXACTLY
                     the primes (partner cannot reach sqrt(n) <=> n is prime)
  rate balance     = the Mertens renewal fixed point (primes -> next vacuum
                     medium); slack R(x) = pi(x) log x / x - 1

On the prime tape p' > p in [1e5, X], the gap interior (p, p') is the
CHURN ZONE: every n in it carries its partner spf(n) = the vortex that
claimed it.  The voids are the endpoints (the primes: the claim map's holes).

Instruments
  A1  VORTEX SHARE: which prime vortices do the claiming (spectrum, entropy,
      wheel-share = fraction claimed by the partners <= 13)
  A2  CHURN MOMENTUM: per gap the unit-circle (24-gon) vector sum V of the
      partner lanes = the dot of the churn with the wheel 24-frame, vs a
      same-length shuffled-partner null (the aniso filter gives the frame;
      the dot gives the signed magnitude)
  A3  CHURN CIRCULATION: per-gap net wrapped angle change (the discrete
      cross/curl of the claim word) + chirality excess, vs the null
  A4  VOID HANDOVER: cross-tab (partner lane at p'-1) x (void lane p' mod 24)
      vs independence - what is handed over INTO the void
  A5  FLANK PAIR: P(lane(spf(p+1)) | lane(spf(p'-1))) vs independence -
      the two vortices at either side of the same void
  A6  ANISO-FRAME DOT (1D lane walk): with/against-flow of the raw lane step
      vs the aniso-smoothed local drift (filter = frame, dot = sign)
  B   BOIL BALANCE: the 0229 gate transfer curve rho(y) vs log log y
      (+ the wheel row y=13, + the y->inf identity endpoint) and the PNT
      renewal slack R(x) at 2e6/1e7/1e8
"""
import math
import time
import numpy as np

T0 = time.time()


def rep(*a):
    print(*a, flush=True)


LANE24 = np.array([0, 1, 0, 3, 0, 5, 0, 7, 0, 0, 0, 11, 0, 13, 0, 0, 0, 17,
                   0, 19, 0, 0, 0, 23], dtype=np.int64)  # prime lanes in 1..24
X = 10_000_000
XLO = 100_000
SEED = 14
W = 21
DECAY = 4.0
FWD = 0.3

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
rep(f"sieve to {X:,}: {len(primes)} primes")

# ---- smallest prime factor (the partner / claim map) -----------------------
pfmax = int(math.isqrt(X)) + 1
spf = np.zeros(X + 1, dtype=np.int64)
for p in primes[primes <= pfmax]:
    m = np.arange(p * p, X + 1, p)
    mask = spf[m] == 0
    spf[m[mask]] = p
spfl = spf % 24  # partner lane = its mod-24 residue (2,3,5,7,11,13,17,19,23)

ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
_ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
ip = ip[_ok]
p = primes[ip]
pnxt = primes[ip + 1]
nruns = len(p)
gaps = pnxt - p
L = (gaps - 1).astype(np.int64)  # gap interior length >= 1
rep(f"runs: {nruns} (primes in [{XLO:,}, {X:,}])")

# exact union of run interiors = [p[0]+1, pnxt[-1]) (both endpoints prime)
comp_idx = np.arange(p[0] + 1, pnxt[-1])
comp_mask = ~s[p[0] + 1:pnxt[-1]]
comp_n = comp_idx[comp_mask]
partner = spf[comp_n]
nlam = len(partner)
total = L.sum()
assert nlam == total, (nlam, total)
z = np.exp(2j * math.pi * spfl[comp_n] / 24.0)

# flat offsets of each run's segment in the partner array
off = np.empty(nruns, dtype=np.int64)
off[0] = 0
np.cumsum(L[:-1], out=off[1:])

# ---- A1: the vortex share ---------------------------------------------------
share = np.bincount(partner, minlength=pfmax + 1)
bins = np.arange(share.size)
order = np.argsort(share)[::-1][:12]
H = -np.sum(share[share > 0] / nlam * np.log(share[share > 0] / nlam))
Hmax = math.log(int((share > 0).sum()))
wheel_frac = float(share[:14].sum()) / nlam
rep("")
rep("A1 VORTEX SHARE (who does the claiming in [%d, %d])" % (XLO, X))
rep("  top claimers: " + "  ".join(f"p={int(bins[k])}:{int(share[k]) / nlam:.4f}" for k in order))
rep(f"  claim entropy: {H:.4f} / {Hmax:.4f} max ({H / Hmax:.3f})"
      f" over {(share > 0).sum()} active vortices")
rep(f"  wheel share (partners <= 13): {wheel_frac:.4f} of all claims")

# ---- A2/A3: per-gap momentum V and circulation Omega -----------------------
def run_stats(zf):
    Zc = np.concatenate(([0j], np.cumsum(zf)))
    V = Zc[off + L] - Zc[off]
    # intra-run wrapped angle increments; zero the run boundaries
    ang = np.angle(np.roll(zf, -1) / zf)
    islast = np.zeros(len(zf), dtype=bool)
    islast[off + (L - 1)] = True
    ang = np.where(islast, 0.0, ang)
    isfirst = np.zeros(len(zf), dtype=bool)
    isfirst[off] = True
    ang = np.where(isfirst, 0.0, ang)
    Om = np.add.reduceat(ang, off)
    return V, Om


V, Om = run_stats(z)
null_partner = partner[rng.permutation(nlam)]
null_spf = spfl[rng.permutation(nlam)]
V0, Om0 = run_stats(np.exp(2j * math.pi * null_spf / 24.0))

sqrtL = np.sqrt(L.astype(np.float64))
rep("")
rep("A2 CHURN MOMENTUM |V| (dot of the claim word with the 24-frame)")
rep(f"  real  E|V| = {np.abs(V).mean():.4f}   E|V|/sqrt(L) = {(np.abs(V) / sqrtL).mean():.4f}")
rep(f"  null  E|V| = {np.abs(V0).mean():.4f}   E|V|/sqrt(L) = {(np.abs(V0) / sqrtL).mean():.4f}")
lo = np.argsort(L)[:nruns // 10]
hi = np.argsort(L)[-nruns // 10:]
rep(f"  short gaps (dec1): real {(np.abs(V)[lo] / sqrtL[lo]).mean():.4f} / null {(np.abs(V0)[lo] / sqrtL[lo]).mean():.4f}")
rep(f"  long  gaps (dec10): real {(np.abs(V)[hi] / sqrtL[hi]).mean():.4f} / null {(np.abs(V0)[hi] / sqrtL[hi]).mean():.4f}")

rep("")
rep("A3 CHURN CIRCULATION Omega (discrete cross/curl of the claim word)")
rep(f"  real  E[Omega] = {Om.mean():+.6f}   E|Omega| = {np.abs(Om).mean():.4f}")
rep(f"  null  E[Omega] = {Om0.mean():+.6f}   E|Omega| = {np.abs(Om0).mean():.4f}")
ppos = float((Om > 0).mean())
p0pos = float((Om0 > 0).mean())
se0 = math.sqrt(p0pos * (1 - p0pos) / nruns)
rep(f"  chirality: P(Omega>0) real = {ppos:.5f}   null = {p0pos:.5f} +/- {se0:.5f}"
      f"   (z = {(ppos - p0pos) / se0:+.2f})")

# ---- A4: void handover (ODD flanks: the immediate flanks p+1 / p'-1 are
# always even = partner 2 vacuously; the odd flanks p+2 / p'-2 carry the
# odd vortices 3,5,7,...) -----------------------------------------------------
maskO = L >= 2  # gap >= 4 has odd interior points
pO, pnxtO = p[maskO], pnxt[maskO]
nO = int(maskO.sum())
left_lane = (spf[pO + 2]) % 24    # first odd composite after p
right_lane = (spf[pnxtO - 2]) % 24  # last odd composite before p'
void_lane = pnxtO % 24
T4 = np.bincount(right_lane * 24 + void_lane, minlength=24 * 24).reshape(24, 24)
er = (T4.sum(axis=1, keepdims=True) * T4.sum(axis=0, keepdims=True)) / nO
with np.errstate(divide="ignore", invalid="ignore"):
    chi4 = float(np.where(er > 0, (T4 - er) ** 2 / er, 0.0).sum())
top4 = np.argsort((T4 - er).ravel())[::-1][:5]
rep("")
rep("A4 VOID HANDOVER (odd vortex at p'-2  x  void lane p' mod 24); gap>=4, n = %s" % format(nO, ","))
rep(f"  chi2(normalized) = {chi4:.1f} over {np.count_nonzero(er > 0)} active cells")
for k in top4:
    a, b = divmod(int(k), 24)
    rep(f"  top cell: last-odd partner lane {a} -> void lane {b}: real {T4[a, b]:,} / expected"
        f" {er[a, b]:,.0f}  (x {T4[a, b] / er[a, b]:.3f})")

# ---- A5: flank pair (odd vortex at p+2 | odd vortex at p'-2, same void) -----
T5 = np.bincount(left_lane * 24 + right_lane, minlength=24 * 24).reshape(24, 24)
er5 = (T5.sum(axis=1, keepdims=True) * T5.sum(axis=0, keepdims=True)) / nO
with np.errstate(divide="ignore", invalid="ignore"):
    chi5 = float(np.where(er5 > 0, (T5 - er5) ** 2 / er5, 0.0).sum())
top5 = np.argsort((T5 - er5).ravel())[::-1][:5]
rep("")
rep("A5 FLANK PAIR (odd vortex at p+2  |  odd vortex at p'-2, same void)")
rep(f"  chi2(normalized) = {chi5:.1f} over {np.count_nonzero(er5 > 0)} active cells")
for k in top5:
    a, b = divmod(int(k), 24)
    rep(f"  top cell: flank (left {a}, right {b}): real {T5[a, b]:,} / expected {er5[a, b]:,.0f}"
        f"  (x {T5[a, b] / er5[a, b]:.3f})")

# ---- A6: aniso-frame dot on the lane walk -----------------------------------
lane = p % 24
th = 2 * math.pi * lane / 24.0
dth = np.angle(np.exp(1j * (th[1:] - th[:-1])))  # wrapped lane steps
k = np.arange(-W // 2, W // 2 + 1)
wts = np.exp(-np.abs(k) / DECAY) * (1.0 + FWD * np.sign(k))
wts[k == 0] = 0.0
sm = np.convolve(dth, wts, mode="valid")
i0 = W // 2
u = dth[i0:i0 + len(sm)] * np.sign(sm)
frac_with = float(((np.sign(u) == np.sign(dth[i0:i0 + len(sm)])) & (sm != 0)).mean())
net = float(u.mean())
dn = dth[rng.permutation(len(dth))]
smn = np.convolve(dn, wts, mode="valid")
un = dn[i0:i0 + len(sm)] * np.sign(smn)
frn = float(((np.sign(un) == np.sign(dn[i0:i0 + len(sm)])) & (smn != 0)).mean())
netn = float(un.mean())
rep("")
rep("A6 ANISO-FRAME DOT (lane walk vs aniso-smoothed drift, w=%d, decay %.1f, fwd %.2f)"
      % (W, DECAY, FWD))
rep(f"  with-flow fraction: real {frac_with:.5f}   null {frn:.5f}")
rep(f"  net drift mean(u):  real {net:+.6f}   null {netn:+.6f}")

# ---- B: the boil balance ----------------------------------------------------
s8 = sieve(100_000_000)
pi8 = s8.cumsum()
rep("")
rep("B BOIL BALANCE (rate matching)")
rep("  R(x) = pi(x) log x / x - 1  (PNT renewal slack):")
for xx in (2_000_000, 10_000_000, 100_000_000):
    pi_x = int(pi8[xx - 1])
    rep(f"    x = {xx:>11,}  pi = {pi_x:>9,}  R = {pi_x * math.log(xx) / xx - 1:+.6f}")
# 0229 gate transfer curve (rho vs log log y) + wheel row + identity endpoint
pts = [(13, 0.3717), (17, 0.3931), (23, 0.4307), (29, 0.4449), (71, 0.5412), (173, 0.6348)]
xx = np.array([math.log(math.log(y)) for y, _ in pts])
yy = np.array([rho for _, rho in pts])
b1, b0 = np.polyfit(xx, yy, 1)
resid = yy - (b0 + b1 * xx)
ss_res = float((resid ** 2).sum())
ss_tot = float(((yy - yy.mean()) ** 2).sum())
r2 = 1 - ss_res / ss_tot
rep("  gate transfer rho(y) = a + b*log(log y)   (0229 curve, X=1e7):")
for (y, rho) in pts:
    fit = b0 + b1 * math.log(math.log(y))
    rep(f"    y={y:>4}  loglogy={math.log(math.log(y)):.4f}  rho={rho:.4f}  fit={fit:.4f}")
rep(f"    slope b = {b1:.4f} / unit loglog, intercept a = {b0:.4f}, R2 = {r2:.4f}")
rep("    endpoint y -> inf: rho -> 1 (the 0217 identity: the void is where the")
rep("    partner cannot reach; at y = sqrt(x) the pin set is exactly the primes)")

rep("")
rep(f"== done in {time.time() - T0:.1f}s ==")
