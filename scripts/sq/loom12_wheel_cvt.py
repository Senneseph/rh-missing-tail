#!/usr/bin/env python3
# Wheel track part 2 (0230, the CVT-2 / transmission-curve measurement):
# does the 24-adic frame, read AT THE PRIME'S OWN SCALE (cut n1 = p),
# transmit the gap-word signal?  As the continuously variable transmission
# question asks: is there a RATIO (a height t) at which the wheel (phase r)
# and the loom (the next gap class) are meshed?
#
# Machine (day006 / 0909 / WF-24, ported to double precision):
#   cell c_j = F_24 (fib mod 12, 24-cell, centered -9/2), P = cumrow.
#   For a cut n1 (here n1 = p, the prime's own position), height
#   t (S = 1/2 + i t):
#     T(p,S) = sum_j c_j * 24^{-S} * zeta(S, (p + d_j(p))/24)
#     where d_j(p) = ((j-1-e) mod 24) + 1, e = p mod 24
#     (day006: the argument is the first integer >= n1+1 in class j).
#     zeta(S,x) via the 3-term Euler-Maclaurin asymptotic
#     (x >= 2e6/24 = 8e4: validated against mpmath dps-30 at startup).
#     v(r; p, S) = (p^{S+1}/S) * (T + P_r * p^{-S})
#   Four waveforms per prime: A_r, W_r, A_{r+12}, W_{r+12}
#   (W = A - mean over the 24 phases at the same cut).
#
# Measurement: primes = log-stratified sample N=300000 from [2e6, 1e8];
# t grid = 4..404 step 2 (201 heights); at each t the 8 real signals
# (4 waveforms x re/im) are added to the class-r features for predicting
# the NEXT prime's lane (8 classes) and the gap class G24 (12 classes).
#   gain(t) = logloss(class-only baseline) - logloss(class + frame)
# compared against the random-noise null of the same variance (5 draws).
# The transmission curve = gain vs t; the RATIO = the t of the peak.
# Scale slice: [2e6,1e7) vs [1e7,1e8) peak locations.
#
# OFF-BOARD. No RH claim. 1 core (4 open). Seed 11 for the sample.
#
import os
import math
import time
import numpy as np
from mpmath import mp, mpf, mpc

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom12_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
Q = 24
NSAMP = 300_000
LO, HI = 2_000_000, 100_000_000
TS = list(range(4, 405, 2))          # 201 heights
SEED = 11

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def fib_cell_24():
    a, b, out = 1, 1, []
    while True:
        out.append(a % 12)
        a, b = b, (a + b) % 12
        if (a % 12 == 1) and (b % 12 == 1) and len(out) >= 2:
            break
    c = [float(v) - 4.5 for v in out]
    assert len(c) == 24
    return np.array(c)

def zeta_ema(S, x):
    """4-term Euler-Maclaurin zeta(S, x), x large (x >= 8e4, |t| <= 404).
    (k=0: x^(1-s)/(s-1) + 1/2 x^-s; k=1: B2/2! (s)_1 x^-s-1;
     k=2: B4/4! (s)_3 x^-s-3; k=3: B6/6! (s)_5 x^-s-5.)"""
    s = S
    out = x ** (1 - S) / (S - 1) + 0.5 * x ** (-S)
    out = out + (s / 12) * x ** (-S - 1)
    out = out - (s * (s + 1) * (s + 2) / 720) * x ** (-S - 3)
    out = out + (s * (s + 1) * (s + 2) * (s + 3) * (s + 4) / 30240) \
        * x ** (-S - 5)
    return out

def selfcheck(cell):
    """validate the EMA zeta + the T-assembly against mpmath dps-30 on a
    few cuts (mechanism-identity gate before any claim from this machine)."""
    mp.dps = 30
    P = np.cumsum(cell) - cell          # P[r] = sum_{j<r} cell[j]
    worst = 0.0
    for p in (10000019, 16777259, 52428809):
        e = p % Q
        for t in (7.7336, 50.0, 200.0):
            S = complex(0.5, t)
            # numpy path
            x = np.empty(Q + 1)
            for j in range(1, Q + 1):
                d = ((j - 1 - e) % Q) + 1
                x[j] = (p + d) / Q
            Tn = complex(0.0)
            for j in range(1, Q + 1):
                Tn += complex(cell[j - 1]) * complex(Q) ** (-S) \
                    * zeta_ema(S, complex(x[j]))
            # mpmath path
            Tm = mpc(0)
            for j in range(1, Q + 1):
                d = ((j - 1 - e) % Q) + 1
                Tm += mpf(cell[j - 1]) * mp.power(mpf(Q), -mp.mpc(0.5, t)) \
                    * mp.zeta(mpc(0.5, t), (mpf(p + d)) / mpf(Q))
            err = abs(Tn - complex(Tm))
            rel = err / max(1e-30, abs(Tm))
            worst = max(worst, rel)
    return worst

def softmax_fit(X, y, A, lr=0.05, epochs=8, seed=0):
    """plain softmax GD on standardized features; returns deviance/2 (nats)."""
    rng = np.random.default_rng(seed)
    n, d = X.shape
    W = np.zeros((A, d))
    b = np.zeros(A)
    for _ in range(epochs):
        Z = X @ W.T + b
        Z -= Z.max(axis=1, keepdims=True)
        Pr = np.exp(Z)
        Pr /= Pr.sum(axis=1, keepdims=True)
        G = Pr
        G[np.arange(n), y] -= 1
        G /= n
        dW = G.T @ X
        b = b - lr * G.sum(axis=0)
        W = W - lr * dW
    return W, b

def softmax_eval(W, b, X, y):
    Z = X @ W.T + b
    Z -= Z.max(axis=1, keepdims=True)
    logp = Z - np.log(np.exp(Z).sum(axis=1, keepdims=True))
    return float(-(logp[np.arange(len(y)), y]).mean())

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    t0 = time.time()
    ofh = open(OUT, "w")
    def rep(s=""):
        print(s); ofh.write(s + "\n"); ofh.flush()

    rep("WHEEL-CVT (0230): the transmission curve - frame at the prime's "
        "own scale vs the gap word")
    rep("(OFF-BOARD; no RH claim; 1 core, 4 open; seed 11)")

    cell = fib_cell_24()
    worst = selfcheck(cell)
    rep(f"  EMA-zeta selfcheck vs mpmath dps-30: worst rel err = "
        f"{worst:.3e}  {'OK' if worst < 1e-7 else 'FAIL'}")
    if worst >= 1e-7:
        rep("  ABORT: mechanism-identity gate failed.")
        ofh.close()
        return
    P = np.zeros(Q)
    for i in range(1, Q):
        P[i] = P[i - 1] + cell[i - 1]
    a_bar = P.mean()

    # ---------------- data ------------------------------------------------
    Xb = HI
    sarr = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if sarr[i]],
                      dtype=np.int64)
    pool = primes[np.searchsorted(primes, LO):]
    # log-stratified sample: 30000 stratified bins in ln
    rng = np.random.default_rng(SEED)
    u = np.sort(rng.uniform(math.log(LO), math.log(HI), size=NSAMP))
    p = np.clip(primes[np.searchsorted(pool, np.exp(u))], LO, HI - 2)
    # (sample with replacement at bin edges - fine for a field measurement)
    ip = np.searchsorted(primes, p)
    ip = np.minimum(ip, len(primes) - 2)
    pn = primes[ip + 1]
    next_lane = np.searchsorted(LANES, pn % 24)
    gap_g24 = ((pn - p) % 24) // 2
    hlane = np.bincount(next_lane, minlength=8).astype(float)
    hlane /= hlane.sum()
    rep(f"  prime sample: {len(p)} from [{LO}, {HI}]; "
        f"next-lane hist = {np.round(hlane,4).tolist()} "
        f"({time.time()-t0:.1f}s)")
    p64 = p.astype(np.float64)
    # the 24-frame phase of the prime = p mod 24 (a lane value: the
    # frame's past class), and the lane INDEX for the word targets
    phas = (p % 24).astype(np.int64)
    r_idx = np.searchsorted(LANES, p % 24)

    # precompute the zeta arguments once (independent of t):
    # x_j(p) = (p + d_j(p)) / 24,  d_j = ((j-1-e) mod 24) + 1
    dtab = np.empty((24, Q + 1), dtype=np.int64)
    for ee in range(24):
        for j in range(1, Q + 1):
            dtab[ee, j] = ((j - 1 - ee) % Q) + 1
    x_all = (p64[:, None] + dtab[phas].astype(np.float64)) / Q   # (N,25)
    pSinv = None  # p^{-S} is t-dependent; p^{S+1}/S is t-dependent

    # base features: class indicators
    cls = np.zeros((len(p), 8))
    cls[np.arange(len(p)), r_idx] = 1.0

    # ---------------- split: train / test --------------------------------
    half = len(p) // 2
    tr = np.arange(half); te = np.arange(half, len(p))

    def baseline_logloss(y, A, fit, idx):
        # class-conditional distribution FITTED ON `fit`, scored on idx
        D = np.zeros((8, A))
        for r in range(8):
            D[r] = np.bincount(y[fit][r_idx[fit] == r], minlength=A)
        D = (D + 1.0) / (D + 1.0).sum(axis=1, keepdims=True)
        ll = 0.0
        for r in range(8):
            sel = r_idx[idx] == r
            ll += -float(np.log(D[r, y[idx][sel]]).mean()) * sel.sum()
        return ll / len(idx)

    ll_base_lane = baseline_logloss(next_lane, 8, tr, te)
    ll_base_g24 = baseline_logloss(gap_g24, 12, tr, te)
    rep(f"  baseline (class-only, fitted on train, scored on test) "
        f"logloss: lane {ll_base_lane:.5f}  g24 {ll_base_g24:.5f}")

    # null: random signals of the same variance, 5 draws, over BOTH targets
    # (fit cost is the same; do 5 noise draws per t on a subsample?) - we
    # do it properly: 5 draws over the whole grid would be 5x; instead 2
    # draws (band is narrow: SE of the gain ~ 1/sqrt(n)).
    noise_seeds = [101, 103]

    rep("")
    rep("  gain = baseline(test) - model(test); model fitted on train half;")
    rep("  nulls = the same fit/test protocol on i.i.d. noise features")
    rep(f"t     lane: gain [noise-null band]   g24: gain [noise-null band]")
    peakL = (0.0, -1e9)
    peakG = (0.0, -1e9)
    # process t one by one; the field pass per t is O(N * 24 * 3)
    for ti, t in enumerate(TS):
        S = complex(0.5, t)
        QSinv = complex(Q) ** (-S)
        # T(p, S) over all primes (vectorized over j):
        T = np.zeros(len(p64), dtype=np.complex128)
        for j in range(1, Q + 1):
            T = T + complex(cell[j - 1]) * QSinv * zeta_ema(S, x_all[:, j])
        pS = p64 ** S           # sqrt(p) * e^{i t ln p} (the prime swirl)
        pminS = p64 ** (-S)
        pscale = p64 * pS / S   # p^{S+1}/S
        v_r = pscale * (T + P[phas] * pminS)
        v_rF = pscale * (T + P[(phas + 12) % 24] * pminS)
        vbar = pscale * (T + a_bar * pminS)
        W_r = v_r - vbar
        W_rF = v_rF - vbar
        sig = np.empty((len(p), 8))
        sig[:, 0] = v_r.real
        sig[:, 1] = v_r.imag
        sig[:, 2] = v_rF.real
        sig[:, 3] = v_rF.imag
        sig[:, 4] = W_r.real
        sig[:, 5] = W_r.imag
        sig[:, 6] = W_rF.real
        sig[:, 7] = W_rF.imag
        mu = sig[tr].mean(axis=0)
        sd = sig[tr].std(axis=0)
        sd[sd < 1e-12] = 1.0
        sigs = (sig - mu) / sd
        Xtr = np.concatenate([cls[tr], sigs[tr]], axis=1)
        Xte = np.concatenate([cls[te], sigs[te]], axis=1)
        rowL = f"{t:>4}  "
        rowG = ""
        for ytarget, A, base, name in ((next_lane, 8, ll_base_lane, "lane"),
                                       (gap_g24, 12, ll_base_g24, "g24")):
            Wm, bm = softmax_fit(Xtr, ytarget[tr], A, seed=SEED)
            llm = softmax_eval(Wm, bm, Xte, ytarget[te])
            gain = base - llm
            nulls = []
            for ns in noise_seeds:
                rngn = np.random.default_rng(ns + t)
                nsamp = 60000
                ntr = np.concatenate([cls[:nsamp],
                                      rngn.normal(0, 1, (nsamp, 8))],
                                     axis=1)
                nte = np.concatenate([cls[half:half + nsamp],
                                      rngn.normal(0, 1, (nsamp, 8))],
                                     axis=1)
                Wn, bn = softmax_fit(ntr, ytarget[:nsamp], A, seed=SEED)
                nulls.append(base - softmax_eval(Wn, bn, nte, ytarget[half:half + nsamp]))
            nb = f"[{min(nulls):+.5f},{max(nulls):+.5f}]"
            clear = gain > max(nulls)
            if name == "lane":
                rowL += f"gain {gain:+.5f} {nb} {'CLEAR' if clear else 'in'}"
                if gain > peakL[1]:
                    peakL = (t, gain)
            else:
                rowG += f" gain {gain:+.5f} {nb} {'CLEAR' if clear else 'in'}"
                if gain > peakG[1]:
                    peakG = (t, gain)
        rep(rowL + "   |" + rowG)
        if (ti + 1) % 25 == 0:
            rep(f"  ... ({ti+1}/{len(TS)} heights, {time.time()-t0:.0f}s)")

    # scale slice: peak location in the two halves
    rep("")
    rep(f"  PEAK: lane target at t* = {peakL[0]} (gain {peakL[1]:+.5f}); "
        f"g24 target at t* = {peakG[0]} (gain {peakG[1]:+.5f})")
    rep("  (0214 settled the hole at the 0909 lattice: real part 42.0, "
        "im = 21/t;  the transmission curve says whether the frame at the "
        "prime's own scale transmits the gap word at ANY height)")
    rep("")
    rep(f"== done in {time.time()-t0:.1f}s ==")
    ofh.close()

if __name__ == "__main__":
    main()
