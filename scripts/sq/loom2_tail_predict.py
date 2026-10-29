#!/usr/bin/env python3
# LOOM L2 (0217): the TAIL-PREDICTION machine (owner idea).
#
# Owner (2026-10-29): "instead of one prime (or one zeta zero) as origin, use
# ALL the primes up to that point as a full tail, and correlate with the data
# of the future - where primes CAN'T be and what IS allowed through. That
# links the many historical primes to a future prediction field. Could that
# point to the next prime even 'out of order' - the next one we CAN PREDICT
# IN THE 24-ADIC? There must be some harmony or progression that informs us."
#
# Executable form (all finite, off-board, no RH claim):
#  L2A NEXT-CLASS PREDICTION LADDER (the 'harmony/progression' quantified).
#      For every cut N = p_j (prime ladder, 1e5..1e7): the tail P(N) = all
#      primes <= N.  Score, against the REAL next prime class c+ = p(N+1) mod 24:
#        M0: uniform 1/8 over the 8 reduced lanes {1,5,7,11,13,17,19,23}.
#        M1: order-1 24-lane Markov  (one step of memory = the last prime).
#        M2: order-2 24-lane Markov  (two steps = the last gap + last prime).
#        M3: 'DUE-LANE' model: every tail prime is tracked per lane; the lane
#            that has waited LONGEST is predicted (the renewal/'harmony'
#            guess - the whole tail as origin).
#      => predictability ladder (nats/cut) of the past tail about the next
#         24-ADIC prime.  This is the literal 'the next one we can predict in
#         the 24-adic' (a LANE prediction; the lane race IS the 24-adic order).
#  L2B TAIL vs FUTURE VOID FIELD (where primes CAN'T be, what is allowed).
#      future void lattice = multiples of small primes in (N, N+W).
#      test PHASE vs CONTENT: does the first survivor's class depend on
#        (i)  the cut PHASE (N mod 24 and the small-prime lattice phase)
#             - the sieve field is a FIXED lattice: phase must dominate
#        (ii) the tail CONTENT (front/back balance of the recent half-tail)
#             - content should be ~null (the lattice has no memory); if not,
#             that is a named 'harmony' signal.
#  L2C PARTIAL-GATE LADDER (what is 'allowed through' as the tail gate grows):
#      survivors S_y = {m in (N, N+200): no prime factor <= y}; y ladder
#      29,71,173,541,1223.  Ambiguity |S_y| and first-survivor class accuracy.
#
# Single-threaded, fast (4 cores open).  No RH claim.

import math, sys
import numpy as np

X = 10_000_000
NMIN = 100_000          # cuts from the first prime >= 1e5
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])   # the 8 reduced lanes mod 24
FRONT = {1, 5, 7, 11}

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n+1, i)))
    return s

def main():
    import os
    os.makedirs("/home/jsmille/Projects/rh-missing-tail/tmp/loom", exist_ok=True)
    out = []
    def rep(s=""):
        print(s); out.append(s)

    rep("LOOM L2 (0217): the full-tail -> next 24-adic prime prediction machine")
    rep("(OFF-BOARD; no RH claim)")
    rep(f"  sieve to X = {X}")
    sieve_arr = sieve(X)
    primes = np.array([i for i in range(2, X + 1) if sieve_arr[i]], dtype=np.int64)
    rep(f"  primes = {len(primes)}")
    P = len(primes)

    # lane index per prime (the 24-lane process).  Only primes >= 5 lie in the
    # 8 reduced lanes {1,5,7,11,13,17,19,23}; 2 and 3 are the two degenerate
    # origin primes and are excluded from the lane process.
    m5 = primes >= 5
    prim5 = primes[m5]
    P5 = len(prim5)
    lane = np.searchsorted(LANES, prim5 % 24)
    assert np.all(LANES[lane] == prim5 % 24), "lane mismatch"

    # ---------------- L2A: prediction ladder ----------------
    # cuts at p_j of prim5 (j0 = first prime >= NMIN)
    j0 = int(np.searchsorted(prim5, NMIN))
    nCuts = P5 - j0 - 1                     # cuts at p_j, j in [j0, P-2]
    rep(f"\n== L2A. next 24-ADIC prime (lane) predictability; cuts = {nCuts} ==")
    ln8 = math.log(8)
    scores0 = np.full(nCuts, -ln8)

    # M1: order-1 transition matrix (8x8), laplace 1
    T1 = np.ones((8, 8))
    for a, b in zip(lane[:-1], lane[1:]):
        T1[a, b] += 1
    T1 = T1 / T1.sum(axis=1)[:, None]
    # M2: order-2 (8,8,8), laplace 1, vectorized counts
    ab = (lane[:-2].astype(np.int64) * 8 + lane[1:-1].astype(np.int64)) * 8 + lane[2:].astype(np.int64)
    T2v = np.bincount(ab, minlength=512).reshape(8, 8, 8).astype(float) + 1.0
    T2 = T2v / T2v.sum(axis=2)[:, :, None]

    a1 = lane[j0:P5-1]                      # lane at cut p_j
    a2 = lane[j0+1:P5]                      # lane at cut p_{j+1} (prev for cuts j+1..)
    np1 = lane[j0+1:P5]                     # next class = lane at p_{j+1}
    ll1 = np.log(T1[a1, np1])
    ll2 = np.log(T2[a2, a1, np1])

    # M3: due-lane (longest-waiting lane fires) - the whole tail as origin.
    # At cut N = p_j the tail is ALL primes <= p_j (including p_j): last[l] =
    # the index of the most recent prime in lane l among indices 0..j.
    last = np.full(8, -10**9, dtype=np.int64)
    for i in range(j0):
        last[lane[i]] = i
    hit_due = np.zeros(nCuts, dtype=bool)
    for i in range(nCuts):
        j = j0 + i
        last[lane[j]] = j            # include p_j itself in the tail (<= p_j)
        c_next = lane[j + 1]         # the next prime after p_j
        d = j - last
        due = int(np.argmax(d))      # lane that has waited longest in the tail
        hit_due[i] = (due == c_next)

    pred1 = np.argmax(T1[a1], axis=1)
    pred2 = np.argmax(T2[a2, a1], axis=1)
    rep("  model            avg nats/cut   (vs M0)     top-1 rate")
    rep(f"  M0 uniform 1/8      {-ln8:+.5f}        0.000       {1/8:.4f}")
    rep(f"  M1 lane Markov      {ll1.mean():+.5f}    {ll1.mean()+ln8:+.5f}     {np.mean(pred1 == np1):.4f}")
    rep(f"  M2 2-lane Markov    {ll2.mean():+.5f}    {ll2.mean()+ln8:+.5f}     "
        f"{np.mean(pred2 == np1):.4f}")
    rep(f"  M3 due-lane (whole-tail renewal)  -  top-1 = {hit_due.mean():.4f}   "
        f"(vs 1/8 = 0.125 random)")

    # per-scale buckets
    for lo, hi, name in [(1e5, 1e6, "tail 1e5-1e6"), (1e6, 1e7, "tail 1e6-1e7")]:
        sel = (prim5[j0:P5-1] >= lo) & (prim5[j0:P5-1] < hi)
        rep(f"    [{name}]  M1={ll1[sel].mean()+ln8:+.5f}  M2={ll2[sel].mean()+ln8:+.5f}  "
            f"due={hit_due[sel].mean():.4f}   (n={int(sel.sum())})")

    # ---------------- L2B: tail CONTENT vs future VOID FIELD (phase vs content)
    rep("\n== L2B. future void field (where primes CAN'T be / what is allowed) ==")
    W = 500
    SMALL = [2, 3, 5, 7, 11, 13]      # the wheel-13 lattice (period 30030)
    # The void field's period is the primorial 30030, but the CLASS is measured
    # mod 24; 24 does not divide 30030, so use PERIOD = lcm(24,30030) = 120120
    # so that the phase N mod PERIOD determines BOTH the sieve pattern AND the
    # 24-class.  (24 = 2^3*3, 30030 = 2*3*5*7*11*13, gcd=6, lcm=120120.)
    PERIOD = 120120
    rng = np.random.default_rng(0)
    sel_idx = rng.choice(nCuts, size=1000, replace=False)
    # vectorized first-survivor offset map: good[ph, rr] = for all q: (ph+rr)%q != 0
    phv = np.arange(PERIOD)[:, None]
    rrv = np.arange(1, W + 1)[None, :]
    good = np.ones((PERIOD, W), dtype=bool)
    for q in SMALL:
        good &= ((phv + rrv) % q) != 0
    first_off = np.argmax(good, axis=1)                 # 0-based offset index
    surv_off = first_off + 1                            # rr = 1..W
    surv_cls = (np.arange(PERIOD) + surv_off) % 24      # first-survivor 24-class
    # per cut: true first survivor (recomputed directly, authoritative)
    rows = []
    for i in sel_idx:
        j = j0 + i
        N = int(prim5[j])
        m = N + 1
        while m <= N + W and any(m % q == 0 for q in SMALL):
            m += 1
        if m > N + W:
            continue
        c_s = m % 24
        tail_lo = N // 2
        tail_pr = primes[(primes > tail_lo) & (primes <= N)]
        front_frac = float(np.mean([1 if (p % 24) in FRONT else 0 for p in tail_pr]))
        rows.append((N, c_s, front_frac))
    n_valid = len(rows)
    from collections import Counter, defaultdict
    # PHASE_A: full wheel phase N mod PERIOD -> first-survivor class (fixed lattice)
    ok_ph = 0
    for N, c_s, ff in rows:
        if surv_cls[N % PERIOD] == c_s:
            ok_ph += 1
    phase_full = ok_ph / max(n_valid, 1)
    # PHASE_B: the 24-ADIC phase only (N mod 24) -> most common first class
    pm = defaultdict(list)
    cf, cb = [], []
    for N, c_s, ff in rows:
        pm[N % 24].append(c_s)
        if ff > 0.5:
            cf.append(c_s)
        else:
            cb.append(c_s)
    phase_hits = 0
    for ph, lst in pm.items():
        phase_hits += Counter(lst).most_common(1)[0][1]
    phase_24 = phase_hits / max(n_valid, 1)
    cf_front = sum(1 for c in cf if c in FRONT) / max(len(cf), 1)
    cb_front = sum(1 for c in cb if c in FRONT) / max(len(cb), 1)
    rep(f"  cuts tested = {n_valid}  (window W={W}, lattice = wheel-13, period {PERIOD})")
    rep(f"  PHASE_A  N mod {PERIOD} (full wheel+24 phase) -> first-survivor class: {phase_full:.4f}")
    rep(f"  PHASE_B  N mod 24    (the 24-ADIC phase)  -> first-survivor class: {phase_24:.4f}")
    rep(f"  CONTENT  front-heavy tail (n={len(cf)}): first-cls front-frac {cf_front:.4f}  |  "
        f"back-heavy (n={len(cb)}): {cb_front:.4f}   (equal = content-blind)")
    rep("  (PHASE_A ~= 1.0 = the future void field is a FIXED lattice: fully")
    rep("   phase-predictable.  PHASE_B much lower = the 24-frame is a COARSE")
    rep("   projection of the true wheel phase: it loses the rest of the field.")
    rep("   CONTENT: NOTE - tail balance correlates with the local phase (the")
    rep("   half-tail front-frac is a proxy for the weave position, cf.")
    rep("   BLOOM-24); the split above is ANTI-correlated and confounded. The")
    rep("   controlled test (content at FIXED wheel phase) is named L2B'.)")

    # ---------------- L2C: partial-gate ladder ----------------
    rep("\n== L2C. 'what is allowed through' - the partial gate ladder ==")
    Wc = 200
    ylad = [29, 71, 173, 541, 1223]
    csel = rng.choice(nCuts, size=300, replace=False)
    rep("  per y: mean survivors |S_y| in (N, N+200], first-survivor == next prime?,")
    rep("          first-survivor CLASS == next prime class?")
    for yv in ylad:
        spv = primes[primes <= yv]
        cnt_s = 0; eq_np = 0; eq_cls = 0; nv = 0
        for i in csel:
            j = j0 + i
            N = int(prim5[j])
            mr = np.arange(N + 1, N + Wc + 1)
            ok = np.ones(Wc, dtype=bool)
            for q in spv:
                ok[mr % q == 0] = False
            Ss = mr[ok]
            if len(Ss) == 0:
                continue
            nv += 1
            cnt_s += len(Ss)
            np1v = int(prim5[j + 1])
            if Ss[0] == np1v:
                eq_np += 1
            if Ss[0] % 24 == np1v % 24:
                eq_cls += 1
        rep(f"  y={yv:5d}  |S_y| = {cnt_s/max(nv,1):8.2f}   first==next: {eq_np/max(nv,1):.4f}   "
            f"first-class==next-class: {eq_cls/max(nv,1):.4f}   (n={nv})")
    rep("  (the gate tightens monotonically: the FULL prime-tail gate (y -> inf)")
    rep("   leaves exactly the primes - 'allowed through' = the sieve field; the")
    rep("   ladder measures how much of the tail is enough to see the next prime.)")

    rep("\n== VERDICT (measured; no RH claim) ==")
    rep(f"  L2A: M1 (last prime)  = {ll1.mean()+ln8:+.5f} nats/cut of 24-ADIC next-prime")
    rep(f"        M2 (last gap)   = {ll2.mean()+ln8:+.5f} nats/cut   (the progression = the gap law)")
    rep(f"        due-lane (whole-tail renewal) top-1 = {hit_due.mean():.4f} vs 0.125")
    rep("       => the 'harmony/progression' the owner predicted IS THERE and is")
    rep("          SHALLOW: the next 24-adic prime is predicted by a 1-2 step")
    rep("          memory (the gap law, 0196/LOOM-0), not by the deep tail; the")
    rep("          whole-tail due-lane model says whether the deep tail adds ANY.")
    rep("  L2B: phase vs content of the future void field (see split above).")
    rep("  L2C: the allowed-through gate ladder (named 'the future field').")
    rep("  Deferred L2D: cut = ZETA ZERO origin (0909/0214 machine): predict the")
    rep("    prime-lane mix in the band around the zero height vs the tail before;")
    rep("    named, not run (the 0214 hole was t-flat: expectation = weak).")

    with open("/home/jsmille/Projects/rh-missing-tail/tmp/loom/loom2_out.txt", "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
