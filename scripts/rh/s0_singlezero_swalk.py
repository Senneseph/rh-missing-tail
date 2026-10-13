import mpmath as mp, json, math, sys
mp.mp.dps = 25
T0_A = mp.mpf("3232170976.1122")   # band head ledger t (x=3.23217e9)
T0_B = mp.mpf("10000000000")        # ~1e10 anchor
STEP = mp.mpf("0.025")
N = 200
def s_walk(t0, n, step):
    # S(t) = (1/pi) arg zeta(1/2 + i t), continuous branch.
    # Start arg at t0 via canonical log (if zeta != 0 there); accumulate
    # Im int zeta'/zeta over each small step (canonical branch safe on
    # small intervals; a zero crossing shows up as |darg| ~ pi*m).
    def zeta(s): return mp.zeta(s)
    def darg(dt):
        # Im int_{t}^{t+dt} zeta'(1/2+i u)/zeta(1/2+i u) du
        f = lambda u: mp.im((mp.diff(lambda w: mp.zeta(0.5 + 1j*w), 0.5 + 1j*u) / mp.zeta(0.5 + 1j*u)))
        return mp.quad(f, [0, dt]) / mp.mp.dps and None  # placeholder
    return None
# Simpler robust step: evaluate arg at endpoints with continuity:
def s_step(t):
    z = mp.zeta(mp.mpf(0.5) + 1j*t)
    return mp.arg(z)  # (-pi, pi], canonical
def walk(t0, n, step, tag):
    ts = [t0 + step*i for i in range(n+1)]
    args = []
    prev = None
    ds = []      # continuous arg increments (pi-corrected)
    rawds = []
    for t in ts:
        a = s_step(t)
        if prev is not None:
            da = a - prev
            if da > mp.pi: da -= 2*mp.pi
            if da < -mp.pi: da += 2*mp.pi
            rawds.append(float(abs(a-s_step.__self__ if False else a - prev)))
            ds.append(float(da))
        prev = a
    return ts, [float(d) for d in ds]
out = {}
for tag, t0 in (("A_3.23e9", T0_A), ("B_1e10", T0_B)):
    ts, ds = walk(t0, N, STEP, tag)
    ad = sorted(abs(d) for d in ds)
    n_big = sum(1 for d in ds if abs(d) > 0.5)
    n_cross = sum(1 for d in ds if abs(d) > mp.pi/3)   # likely zero crossings
    out[tag] = {
        "t0": float(t0), "n_steps": len(ds), "step": float(STEP),
        "max|dS|": ad[-1], "p99|dS|": ad[int(0.99*len(ad))], "median|dS|": ad[len(ad)//2],
        "mean|dS|": sum(ad)/len(ad),
        "steps|dS|>0.5": n_big, "steps|dS|>pi/3 (zero-cross)": n_cross,
        "total S change over 5 units": abs(sum(ds)),
        "P2-style per-spacing (loglog read)": math.sqrt(0.025*math.log(math.log(t0))/math.pi),
        "P2-style per-spacing (log read)": math.sqrt(0.025*math.log(t0)/math.pi),
    }
print(json.dumps(out, indent=1))
open("s0_singlezero_swalk.json","w").write(json.dumps(out, indent=1))

# PROVENANCE:  single-zero-resolution S-walk (D3,  zero-scale
# oscillation check against P2 arXiv:2510.14309 Thm 1).
# Run:  scripts/rh/s0_singlezero_swalk.py  (dps-25;  cross-
# check at dps-45 agrees to 6 digits -- see forensics 3.10).
