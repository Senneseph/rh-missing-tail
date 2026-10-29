#!/usr/bin/env python3
# LOOM path completion (0218): finish the owner's idea, all named branches.
#
#  (L2D) ZERO-ORIGIN cuts: origin = a certified zeta zero (813 zeros,
#        0 <= gamma <= 1200, dec20): tail = all primes <= gamma (height scale,
#        the 0909/0214 machine), target = the lane of the first prime above
#        gamma.  Same models as L2A (M1 lane-Markov, M3 due-lane) + a
#        band-matched prime-origin baseline (primes in the same band).
#  (LJ)  JOINT POINTING: lane law x survivor field = candidate set for the
#        NEXT PRIME POSITION (the "point to the next prime" single number):
#        C = { m in (N, N+W], no small factor <= y,  m mod 24 in PREDICTED
#        lane(s) }; report |C|, hit (first candidate == next prime), and the
#        position-certainty gain in nats vs the raw field.
#  (L4K) PROGRESSION LADDER: the "pattern" beyond the single next prime:
#        ordered K-tuple (K=1..4) and unordered (multiset) lane prediction.
#  (L1b) BLOOM SCALE: 24-adic front/antipode gap ratios at 1e7 and 1e8
#        (0216 measured 2e6): decay (LO slow law) vs fixed (sieve geometry).
#  (LM1) MODEL DISCRIMINATOR (LOOM-1 first cut): real A6 word H_m (X=2e6)
#        vs FLOOR-0 (Cramer iid at empirical marginal), FLOOR-1 (pair law:
#        order-1 Markov chain fit), FLOOR-2 (order-2 law fit).  If the real
#        H_3 sits below FLOOR-2 by > noise, the tension exceeds even the
#        order-2 law (a genuine deeper loom; final subsumption test = the
#        LD/k-tuple generator, named LOOM-1b2).
#
# OFF-BOARD; no RH claim; single-threaded (4 cores open); ~5 min total.

import math, sys, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
ZEROFILE = ROOT + "/scripts/rh/lowt/zeros_0_to_1p2e3.dec20.txt"
OUT = ROOT + "/tmp/loom/loom3_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def markov_rates(w, mmax=3, Nsamples=400000, seed=0, nblk=1):
    """H_m per-symbol entropy via m-th order Markov fit; block-SD for SE."""
    rng = np.random.default_rng(seed)
    L = len(w)
    out = {}
    p = np.bincount(w, minlength=6).astype(float); p = p / p.sum()
    out[0] = float(-(p[p > 0] * np.log(p[p > 0])).sum())
    for m in range(1, mmax + 1):
        if nblk == 1:
            idx = rng.integers(0, L - (m + 2), size=min(Nsamples, L - m - 2))
            ctx = np.zeros(len(idx), dtype=np.int64)
            for k in range(m):
                ctx = ctx * 9 + w.take(idx + k)
            nxt = w.take(idx + m)
            _, civ, ccnt = np.unique(ctx, return_inverse=True, return_counts=True)
            H = 0.0
            for ci in range(len(ccnt)):
                sel = civ == ci
                nc = np.bincount(nxt[sel], minlength=6).astype(float)
                pc = nc / nc.sum()
                H += (ccnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
            out[m] = H
        else:
            vals = []
            for b in range(nblk):
                sub = w[b * (L // nblk): (b + 1) * (L // nblk)]
                Ls = len(sub)
                if Ls < (m + 10):
                    break
                idx = rng.integers(0, Ls - (m + 2), size=min(Nsamples, Ls - m - 2))
                ctx = np.zeros(len(idx), dtype=np.int64)
                for k in range(m):
                    ctx = ctx * 9 + sub.take(idx + k)
                nxt = sub.take(idx + m)
                _, civ, ccnt = np.unique(ctx, return_inverse=True, return_counts=True)
                H = 0.0
                for ci in range(len(ccnt)):
                    sel = civ == ci
                    nc = np.bincount(nxt[sel], minlength=6).astype(float)
                    pc = nc / nc.sum()
                    H += (ccnt[ci] / len(idx)) * float(-(pc[pc > 0] * np.log(pc[pc > 0])).sum())
                vals.append(H)
            out[m] = (float(np.mean(vals)), float(np.std(vals, ddof=1)) if len(vals) > 1 else 0.0)
    return out

def gen_chain_order1(P, n, rng64):
    s = np.empty(n, dtype=np.int64)
    s[0] = rng64.integers(0, 6)
    C = np.random.default_rng()  # local generator for draws
    cum = np.cumsum(P, axis=1)
    for i in range(1, n):
        s[i] = np.searchsorted(cum[s[i - 1]], C.random())
    return s

def main():
    out = []
    def rep(s=""):
        print(s); out.append(s)
    import os
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    t0 = time.time()
    rep("LOOM path completion (0218) - OFF-BOARD, no RH claim")

    X = 10_000_000
    sieve_arr = sieve(X)
    primes = np.array([i for i in range(2, X + 1) if sieve_arr[i]], dtype=np.int64)
    m5 = primes >= 5
    prim5 = primes[m5]; P5 = len(prim5)
    lane = np.searchsorted(LANES, prim5 % 24)
    NMIN = 100_000
    j0 = int(np.searchsorted(prim5, NMIN))
    nCuts = P5 - j0 - 1
    cN = lane[j0:P5 - 1]          # lane at cut
    cP = lane[j0 + 1:P5]          # next lane
    Ncuts = prim5[j0:P5 - 1]
    nextp = prim5[j0 + 1:P5]
    rep(f"  X={X}, primes={len(primes)}, cuts={nCuts}")

    # models (shared)
    T1 = np.ones((8, 8))
    for a, b in zip(lane[:-1], lane[1:]):
        T1[a, b] += 1
    T1 = T1 / T1.sum(axis=1)[:, None]
    am = np.argsort(T1, axis=1)
    pred1 = am[cN, 7]
    pred2nd = am[cN, 6]
    laneval1 = LANES[pred1]
    laneval2 = LANES[pred2nd]

    # ============ (L2D) zero-origin cuts ============
    rep("\n== L2D. ZERO-ORIGIN cuts (813 certified zeros, 0<=gamma<=1200) ==")
    gammas = np.array([float(l) for l in open(ZEROFILE) if l.strip()])
    # band-matched baseline: prime cuts with prime in [gamma_min, 1200]
    gb0, gb1 = float(gammas.min()), 1200.0
    # forward walk over primes <= 1200 maintaining per-lane last-seen index
    small = prim5[(prim5 >= 5) & (prim5 <= 1300)]
    lane_small = lane[prim5[ (prim5 >= 5) & (prim5 <= 1300)]]
    n_sm = len(small)
    # stats at ZERO positions (cut = floor(gamma) between primes)
    zero_m1_hit = 0; zero_m1_ll = 0.0; zero_due_hit = 0; nz = 0
    # stats at PRIME positions in the same band (prime-origin baseline)
    prime_m1_hit = 0; prime_m1_ll = 0.0; prime_due_hit = 0; np_ = 0
    last = np.full(8, -10**9, dtype=np.int64)
    zi = 0  # pointer into gammas (sorted ascending by file order)
    gam_sorted_idx = np.argsort(gammas)
    gam_sorted = gammas[gam_sorted_idx]
    # walk primes, emitting zero-cuts between them and prime-cuts at each
    for i in range(n_sm):
        while zi < len(gam_sorted) and gam_sorted[zi] <= small[i]:
            g = gam_sorted[zi]
            if g >= gb0:
                cNz = lane_small[i - 1] if i > 0 else 0
                cPz = lane_small[i]
                nz += 1
                zero_m1_hit += int(np.argmax(T1[cNz]) == cPz)
                zero_m1_ll += float(np.log(T1[cNz, cPz]))
                d = (i - 1) - last
                zero_due_hit += int(np.argmax(d) == cPz)
            zi += 1
        last[lane_small[i]] = i
        if small[i] >= gb0:
            cNp = lane_small[i]
            if i + 1 < n_sm:
                cPp = lane_small[i + 1]
                np_ += 1
                prime_m1_hit += int(np.argmax(T1[cNp]) == cPp)
                prime_m1_ll += float(np.log(T1[cNp, cPp]))
                d = i - last
                prime_due_hit += int(np.argmax(d) == cPp)
    rep(f"  zero-origin cuts n={nz} (band [{gb0:.1f}, {gb1:.0f}]):")
    rep(f"    M1 top-1 = {zero_m1_hit/nz:.4f}  mean logLik = {zero_m1_ll/nz:+.5f} nats")
    rep(f"    due-lane top-1 = {zero_due_hit/nz:.4f}")
    rep(f"  prime-origin cuts in same band n={np_}:")
    rep(f"    M1 top-1 = {prime_m1_hit/np_:.4f}  mean logLik = {prime_m1_ll/np_:+.5f} nats")
    rep(f"    due-lane top-1 = {prime_due_hit/np_:.4f}")
    se_z = math.sqrt(0.125 * 0.875 / nz) if nz else 0
    rep(f"  (SE of a 0.125 rate at n={nz}: {se_z:.4f})")
    rep("  reading: zero-origin ~ prime-origin => zeros carry no EXTRA lane")
    rep("           memory (consistent with 0214 t-flat hole); a deficit would")
    rep("           mean zero positions sit in structurally 'quiet' weave zones.")

    # ============ (LJ) joint pointing: lane x field = position candidates ============
    rep("\n== LJ. joint machine: predicted lane(s) x survivor field = NEXT-PRIME POINTING ==")
    def joint(y, W):
        spv = primes[(primes >= 2) & (primes <= y)]
        cnt1 = np.zeros(nCuts, dtype=np.int32)
        cnt2 = np.zeros(nCuts, dtype=np.int32)
        cntS = np.zeros(nCuts, dtype=np.int32)
        hit1 = 0; hit2 = 0; nv = 0
        ln_gain = 0.0
        rr = np.arange(1, W + 1)[None, :]
        B = 200000
        for b0 in range(0, nCuts, B):
            Ns = Ncuts[b0:b0 + B]
            ok = np.ones((len(Ns), W), dtype=bool)
            for q in spv:
                ok &= ((Ns % q)[:, None] + rr) % q != 0
            cntS_b = ok.sum(axis=1)
            cntS[b0:b0 + B] = cntS_b
            # lane-1 candidates
            eq1 = ((Ns % 24)[:, None] + rr) % 24 == laneval1[b0:b0 + B][:, None]
            ok1 = ok & eq1
            eq2 = ((Ns % 24)[:, None] + rr) % 24 == laneval2[b0:b0 + B][:, None]
            ok2 = ok & (eq1 | eq2)
            cnt1[b0:b0 + B] = ok1.sum(axis=1)
            cnt2[b0:b0 + B] = ok2.sum(axis=1)
            within = (nextp[b0:b0 + B] - Ns) <= W
            fs1 = np.argmax(ok1, axis=1) + 1
            h1 = (ok1.any(axis=1)) & within & (Ns + fs1 == nextp[b0:b0 + B])
            fs2 = np.argmax(ok2, axis=1) + 1
            h2 = (ok2.any(axis=1)) & within & (Ns + fs2 == nextp[b0:b0 + B])
            hit1 += int(h1.sum()); hit2 += int(h2.sum())
            nv += int(within.sum())
            ln_gain += float(np.sum(np.log(np.maximum(cntS[b0:b0 + B], 1))
                                    - np.log(np.maximum(cnt1[b0:b0 + B], 1))))
        rep(f"  y={y:5d} W={W:4d}  (n={nv})")
        rep(f"    raw field   |S| = {cntS.mean():7.2f}")
        rep(f"    lane-1 field |C1| = {cnt1.mean():6.2f}   first-candidate==next prime: {hit1/max(nv,1):.4f}")
        rep(f"    lane-2 field |C2| = {cnt2.mean():6.2f}   first-candidate==next prime: {hit2/max(nv,1):.4f}  (top-2 predicted lanes)")
        rep(f"    position certainty gain (ln|S|-ln|C1|) = {ln_gain/max(nv,1):.4f} nats/window")
        med = float(np.median(cnt1[cnt1 > 0]))
        frac2 = float(np.mean((cnt1 <= 2) & (cnt1 > 0)))
        rep(f"    |C1| median = {med:.1f};  P(|C1| <= 2 | nonempty) = {frac2:.4f}")
    joint(541, 500)
    joint(1223, 500)
    rep("  (the joint machine converts 'the lane law' + 'what is allowed' into")
    rep("   a small candidate SET containing the next prime: the literal")
    rep("   'point to the next prime' number.)")

    # ============ (L4K) progression ladder ============
    rep("\n== L4K. PROGRESSION LADDER: the pattern beyond the single next prime ==")
    Kmax = 4
    Lseq = cP  # start
    rep("  K  ordered tuple top-1    top-3 union    multiset (out-of-order) top-1")
    for K in range(1, Kmax + 1):
        nK = nCuts + 1 - K
        seq = np.stack([lane[j0 + 1 + k:j0 + 1 + k + nK] for k in range(K)], axis=1)
        n = len(seq)
        enc = seq.astype(np.int64)
        for k in range(K):
            enc[:, k] *= 8 ** (K - 1 - k)
        enc = enc.sum(axis=1, dtype=np.int64)
        vals, cnts = np.unique(enc, return_counts=True)
        order = np.argsort(cnts)[::-1]
        top1 = cnts[order[0]] / n
        top3 = cnts[order[:3]].sum() / n
        top1v = vals[order[0]]
        hit_ours = float((enc == top1v).mean())
        # multiset (sorted K-tuple)
        srt = np.sort(seq, axis=1)
        m2 = srt.astype(np.int64)
        for k in range(K):
            m2[:, k] *= 8 ** (K - 1 - k)
        m2c = m2.sum(axis=1, dtype=np.int64)
        mvalsm, mcnts = np.unique(m2c, return_counts=True)
        mtop1 = mcnts.max() / n
        rep(f"  {K}   {hit_ours:.4f}   (top-3 union {min(1.0, top3):.4f})           {mtop1:.4f}   (n={n})")

    # ============ (L1b) bloom scale ============
    rep("\n== L1b. BLOOM(24) SCALE LADDER: front/antipode gap ratios ==")
    def bloom(p):
        g = np.diff(p) % 24
        asyms = []; pairs = []
        for c in (2, 4, 6, 8, 10, 12):
            f1 = float(np.mean(g == c)); f2 = float(np.mean(g == (c + 12) % 24))
            asyms.append(abs(f1 - f2)); pairs.append((f1, f2))
        return float(np.mean(asyms)), pairs
    # 2e6 (from 0216): 0.07315
    b7, p7 = bloom(primes[primes <= 10_000_000])
    rep(f"  X=2e6 (0216): mean|f(c)-f(c+12)| = 0.07315")
    rep(f"  X=1e7:      mean|f(c)-f(c+12)| = {b7:.5f}")
    for c, (f1, f2) in zip((2, 4, 6, 8, 10, 12), p7):
        rep(f"    gap~{c:2d}: {f1:.5f}   gap~{c+12:2d}: {f2:.5f}   ratio {f1/max(f2,1e-9):.3f}")
    X8 = 100_000_000
    s8 = sieve(X8)
    primes8 = np.array([i for i in range(2, X8 + 1) if s8[i]], dtype=np.int64)
    b8, p8 = bloom(primes8)
    rep(f"  X=1e8:      mean|f(c)-f(c+12)| = {b8:.5f}")
    for c, (f1, f2) in zip((2, 4, 6, 8, 10, 12), p8):
        rep(f"    gap~{c:2d}: {f1:.5f}   gap~{c+12:2d}: {f2:.5f}   ratio {f1/max(f2,1e-9):.3f}")
    rep("  (decay with X => LO-type slow bias; stable => fixed sieve geometry)")

    # ============ (LM1) model discriminator ============
    rep("\n== LM1. MODEL DISCRIMINATOR (LOOM-1 first cut, X=2e6) ==")
    X2 = 2_000_000
    s2 = sieve(X2)
    p2 = np.array([i for i in range(2, X2 + 1) if s2[i]], dtype=np.int64)
    g2 = (np.diff(p2) // 2) % 6
    g2 = g2[:-1]  # drop the p=2 anomaly
    real = markov_rates(g2, 3, nblk=8)
    h1_real = real[1][0]
    rep(f"  REAL primes:  H0={real[0]:.5f}  H1={real[1][0]:.5f}+/-{real[1][1]:.5f}  "
        f"H2={real[2][0]:.5f}+/-{real[2][1]:.5f}  H3={real[3][0]:.5f}+/-{real[3][1]:.5f}")
    # FLOOR-0: Cramer iid at empirical marginal
    rng = np.random.default_rng(1)
    pm = np.bincount(g2, minlength=6).astype(float); pm = pm / pm.sum()
    f0 = []
    for r in range(5):
        w = rng.choice(6, size=len(g2), p=pm)
        f0.append(markov_rates(w, 2))
    rep(f"  FLOOR-0 (Cramer iid, marginal):   H1={np.mean([x[1] for x in f0]):.5f}  "
        f"H2={np.mean([x[2] for x in f0]):.5f}   (no memory by construction)")
    # FLOOR-1: pair law (order-1 Markov fit -> generated chain)
    P1 = np.ones((6, 6))
    for a, b in zip(g2[:-1], g2[1:]):
        P1[a, b] += 1
    P1 = P1 / P1.sum(axis=1)[:, None]
    f1h2 = []; f1h3 = []
    for r in range(5):
        w = gen_chain_order1(P1, 200000, np.random.default_rng())
        hh = markov_rates(w, 3)
        f1h2.append(hh[2]); f1h3.append(hh[3])
    rep(f"  FLOOR-1 (pair-law order-1 chain): H1={h1_real:.5f}  "
        f"generated H3={np.mean(f1h3):.5f}")
    # FLOOR-2: order-2 law (fit, generate, measure H3)
    P2 = np.ones((6, 6, 6)) * 0.5
    for a, b, c in zip(g2[:-2], g2[1:-1], g2[2:]):
        P2[a, b, c] += 1
    P2 = P2 / P2.sum(axis=2)[:, :, None]
    f2h3 = []
    for r in range(5):
        n = 200000
        w = np.empty(n, dtype=np.int64)
        rr2 = np.random.default_rng(r)
        w[0] = int(rr2.integers(0, 6))
        w[1] = int(np.searchsorted(np.cumsum(P2[w[0]]), rr2.random()))
        for i in range(2, n):
            w[i] = int(np.searchsorted(np.cumsum(P2[w[i-2], w[i-1]]), rr2.random()))
        hh = markov_rates(w, 3)
        f2h3.append(hh[3])
    rep(f"  FLOOR-2 (order-2 law chain):      generated H3={np.mean(f2h3):.5f}")
    mH3, mH3se = real[3]
    d2 = float(np.mean(f2h3)) - mH3
    rep(f"  DEPTH-3 excess of REAL over FLOOR-2 = {mH3 - float(np.mean(f2h3)):+.5f} "
        f"(block-SE ~{mH3se:.5f})")
    rep("  (excess > ~2 block-SE => the loom tension EXCEEDS even the order-2 law:")
    rep("   a genuinely deeper 24-adic weave (LOOM BOOM-for-real, pending the final")
    rep("   LD/k-tuple generator comparison = LOOM-1b2); ~0 => subsumed at order 2.)")

    rep(f"\n== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
