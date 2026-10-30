#!/usr/bin/env python3
# LOOM G-3 (0225): THE BABY - a learnable-capacity ladder on the G24 word.
#
# Question (the named final adjudicator from 0219/0220): does ANY
# learnable structure remain in the tail beyond the pair law?
#
#   X = 1e7, G24 gap-class word (12 symbols), ~664k symbols.
#   TRAIN = first 400k symbols, TEST = next 100k (a FRONTIER holdout:
#   predict the unseen future, not shuffled data).
#
#   ladder:  K1  empirical order-1 chain (= the pair law, the baseline)
#            K2  empirical order-2 (add-1)
#            K4  geometrically-interpolated k-grams
#                p = .50 K1 + .25 K2 + .125 K3 + .125 K4
#            GRU  hand-rolled numpy, 1 layer h=24, exact full-batch
#                BPTT, Adam lr=3e-3, wdecay 1e-5, 45 epochs (~3.4k params)
#
#   metric: nats per symbol on TEST.  D = NLL(model) - NLL(K1):
#           |D| <= 0.02  -> MARRIED (the baby finds nothing beyond the
#                           pair; ~2 sigma with SE ~ 3/sqrt(100k));
#           D < -0.02    -> DEEPER (learned structure beyond the pair);
#           D > +0.02    -> underfit/overfit (no claim).
#
# Gradient check (finite differences on a 10-symbol sequence) must pass
# before any epoch runs. No torch, no sklearn. Single-threaded, 4 cores
# open. OFF-BOARD; no RH claim.

import math, os, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom7_out.txt"
A = 12
NTRAIN = 400_000
NTEST = 100_000
H = 24
EPOCHS = 60
LR = 3e-3   # clipped at CLIP=5.0 (stable sigmoid gates)
CLIP = 5.0   # global-norm gradient clip
WDECAY = 1e-5
SEED = 7

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

# ---------------- k-gram models ----------------
def build_counts(train, maxk):
    # cnt[k][key]: FLAT key = (k preceding symbols, symbol)  i.e. the
    # order-(k+1) conditional; k=1 is the pair law (1 preceding symbol).
    cnt = [dict() for _ in range(maxk + 1)]
    for k in range(1, maxk + 1):
        for t in range(k, len(train)):
            key = tuple(train[t - k:t]) + (train[t],)
            cnt[k][key] = cnt[k].get(key, 0) + 1
    return cnt

def nats_k1_v2(cnt1, test, tot1):
    nll = 0.0
    for t in range(1, len(test)):
        a = test[t - 1]
        nll -= math.log((cnt1.get((a, test[t]), 0) + 1.0) / (tot1[a] + A))
    return nll / (len(test) - 1)

def nats_k2(cnt2, test, tot2):
    nll = 0.0
    for t in range(2, len(test)):
        a, b = test[t - 2], test[t - 1]
        nll -= math.log((cnt2.get((a, b, test[t]), 0) + 1.0) / (tot2.get((a, b), 0) + A))
    return nll / (len(test) - 2)

def nats_interp(cnts, tot1, tot2, tot3, tot4, test,
                WTS=(0.50, 0.25, 0.125, 0.125)):
    nll = 0.0
    for t in range(1, len(test)):
        terms = []
        # k=1
        a = test[t - 1]
        terms.append(math.log((cnts[1].get((a, test[t]), 0) + 1.0) / (tot1[a] + A)))
        if t >= 2:
            b = test[t - 2]
            terms.append(math.log((cnts[2].get((b, a, test[t]), 0) + 1.0) / (tot2.get((b, a), 0) + A)))
        else:
            terms.append(math.log(1.0 / A))
        if t >= 3:
            c3 = (test[t - 3], test[t - 2], test[t - 1])
            terms.append(math.log((cnts[3].get(c3 + (test[t],), 0) + 1.0) / (tot3.get(c3, 0) + A)))
        else:
            terms.append(math.log(1.0 / A))
        if t >= 4:
            c4 = (test[t - 4], test[t - 3], test[t - 2], test[t - 1])
            terms.append(math.log((cnts[4].get(c4 + (test[t],), 0) + 1.0) / (tot4.get(c4, 0) + A)))
        else:
            terms.append(math.log(1.0 / A))
        m = max(terms)
        s = 0.0
        for w, v in zip(WTS, terms):
            s += w * math.exp(v - m)
        nll -= (m + math.log(s))
    return nll / (len(test) - 1)

# ---------------- the GRU baby ----------------
# conventions:  W*: (input_dim x H);  U*: (H x H) with  h @ U  (row
# vector);  Wo: (H x A);  b*: (H,) / (A,).
# pre_z = x @ Wz + h @ Uz + bz;  pre_r = x @ Wr + h @ Ur + br;
# pre_c = x @ Wc + (r*h) @ Uc + bc;  z=ta(pre_z); r=ta(pre_r);
# hc=ta(pre_c);  h' = (1-z) h + z hc;  logits = h' @ Wo + bo
NAMES = ["Wz", "Uz", "bz", "Wr", "Ur", "br", "Wc", "Uc", "bc", "Wo", "bo"]

def make_params(rng):
    P = {}
    P["Wz"] = rng.standard_normal((A, H)) * 0.3
    P["Uz"] = rng.standard_normal((H, H)) * 0.08   # rho(U) ~ 0.8: stable recurrence
    P["bz"] = np.zeros(H)
    P["Wr"] = rng.standard_normal((A, H)) * 0.3
    P["Ur"] = rng.standard_normal((H, H)) * 0.08
    P["br"] = np.zeros(H)
    P["Wc"] = rng.standard_normal((A, H)) * 0.3
    P["Uc"] = rng.standard_normal((H, H)) * 0.08
    P["bc"] = np.zeros(H)
    P["Wo"] = rng.standard_normal((H, A)) * 0.3
    P["bo"] = np.zeros(A)
    return P

def step_all(xs, P):
    n = len(xs)
    xoh = np.zeros((n, A))
    xoh[np.arange(n), xs] = 1.0
    def sigmoid(u):
        out = np.empty_like(u)
        pos = u >= 0
        out[pos] = 1.0 / (1.0 + np.exp(-u[pos]))
        e = np.exp(u[~pos])
        out[~pos] = e / (1.0 + e)
        return out
    h = np.zeros(H)
    cache = []
    for t in range(n):
        pre_z = xoh[t] @ P["Wz"] + h @ P["Uz"] + P["bz"]
        pre_r = xoh[t] @ P["Wr"] + h @ P["Ur"] + P["br"]
        z = sigmoid(pre_z); r = sigmoid(pre_r)
        pre_c = xoh[t] @ P["Wc"] + (r * h) @ P["Uc"] + P["bc"]
        hc = np.tanh(pre_c)
        hnew = (1 - z) * h + z * hc
        logits = hnew @ P["Wo"] + P["bo"]
        cache.append((xoh[t], h, z, r, hc, hnew, logits))
        h = hnew
    G = {k: np.zeros_like(P[k]) for k in NAMES}
    dinp = np.zeros((n, H))
    for t in range(n - 1, -1, -1):
        x, hprev, z, r, hc, hnew, logits = cache[t]
        dh = dinp[t].copy()
        if t < n - 1:
            m = logits.max()
            lg = logits - m - np.log(np.exp(logits - m).sum())
            p = np.exp(lg); p /= p.sum()
            dlog = p.copy(); dlog[xs[t + 1]] -= 1.0
            G["Wo"] += np.outer(hnew, dlog)
            G["bo"] += dlog
            dh = dh + dlog @ P["Wo"].T
        # sigmoid gates: d sigma(u)/du = z * (1 - z)  /  r * (1 - r)
        dza = dh * (hc - hprev) * z * (1 - z)
        G["Wz"] += np.outer(x, dza)
        G["Uz"] += np.outer(hprev, dza)
        G["bz"] += dza
        dpre_c = dh * z * (1 - hc * hc)
        G["Wc"] += np.outer(x, dpre_c)
        G["Uc"] += np.outer(r * hprev, dpre_c)
        G["bc"] += dpre_c
        dra = (P["Uc"] @ dpre_c) * hprev * r * (1 - r)
        G["Wr"] += np.outer(x, dra)
        G["Ur"] += np.outer(hprev, dra)
        G["br"] += dra
        if t > 0:
            # FULL state-Jacobian carry: h_t depends on h_{t-1} through
            # (a) the direct (1-z)h term  (b) the z-gate h-dependence (Uz)
            # (c) the c-path r-term (Uc)  (d) the r-gate FULL-matrix term
            #     Ur @ (r(1-r)h * (Uc @ dpre_c))
            uc_dpre = P["Uc"] @ dpre_c
            dinp[t - 1] += (dh * (1 - z)
                            + P["Uz"] @ dza
                            + r * uc_dpre
                            + P["Ur"] @ (r * (1 - r) * hprev * uc_dpre))
    nll = 0.0
    for t in range(0, n - 1):
        logits = cache[t][6]
        m = logits.max()
        lg = logits - m - np.log(np.exp(logits - m).sum())
        nll += -lg[xs[t + 1]]
    return nll / (n - 1), G

def gradcheck(P):
    """EXHAUSTIVE finite-difference check of step_all on a 12-symbol
    sequence (all 3500 param entries). Returns (worst_abs, worst_rel_big):
    worst_abs over all entries; worst_rel only where |num|+|ana| > 1e-4
    (near-zero entries are FD-noise limited at ~4e-8 absolute).
    PASS criterion: worst_abs < 1e-6 and worst_rel_big < 1e-5."""
    xs = np.array([0, 1, 2, 3, 5, 7, 1, 2, 9, 4, 0, 6], dtype=np.int64)
    _, G = step_all(xs, P)
    def Ltot():
        return step_all(xs, P)[0] * (len(xs) - 1)
    eps = 1e-6
    worst_abs = 0.0
    worst_rel_big = 0.0
    for nm in NAMES:
        flat = P[nm].reshape(-1)
        Gflat = G[nm].reshape(-1)
        for j in range(flat.size):
            o = flat[j]
            flat[j] = o + eps; lp = Ltot()
            flat[j] = o - eps; lm = Ltot()
            flat[j] = o
            num = (lp - lm) / (2 * eps)
            d = abs(num - Gflat[j])
            worst_abs = max(worst_abs, d)
            if abs(num) + abs(Gflat[j]) > 1e-3:
                worst_rel_big = max(worst_rel_big, d / (abs(num) + abs(Gflat[j])))
    return worst_abs, worst_rel_big

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    lines = []
    def rep(s=""):
        print(s); lines.append(s)
        if len(lines) % 3 == 0:
            with open(OUT, "w") as f: f.write("\n".join(lines) + "\n")
    t0 = time.time()
    rep("LOOM G-3 (0225): THE BABY - learnable-capacity ladder on the G24 word")
    rep(f"(train = first {NTRAIN}, TEST = next {NTEST} frontier, X = 1e7)")
    sb = sieve(10_000_000)
    primes = np.array([i for i in range(2, 10_000_001) if sb[i]], dtype=np.int64)
    word = ((np.diff(primes) % 24) // 2).astype(np.int64)
    train, test = word[:NTRAIN], word[NTRAIN:NTRAIN + NTEST]
    rep(f"  primes = {len(primes)}; word = {len(word)}; {time.time()-t0:.1f}s")

    cnt = build_counts(train, 4)
    tot1 = np.zeros(A)
    for (a, s), n in cnt[1].items(): tot1[a] += n
    tot2 = {}; tot3 = {}; tot4 = {}
    for k in (2, 3, 4):
        D = tot2 if k == 2 else (tot3 if k == 3 else tot4)
        for key, n in cnt[k].items():
            D[key[:-1]] = D.get(key[:-1], 0) + n
    r1 = nats_k1_v2(cnt[1], test, tot1)
    r2 = nats_k2(cnt[2], test, tot2)
    r4 = nats_interp(cnt, tot1, tot2, tot3, tot4, test)
    rep(f"    {'K1 (pair)':>10}  TEST = {r1:.5f} nats/sym   [baseline]")
    rep(f"    {'K2':>10}  TEST = {r2:.5f}  D = {r2-r1:+.5f}")
    rep(f"    {'K4 interp':>10}  TEST = {r4:.5f}  D = {r4-r1:+.5f}")

    rng = np.random.default_rng(SEED)
    P = make_params(rng)
    wc_abs, wc_rel = gradcheck(P)
    rep(f"  GRU (h={H}, hand-rolled numpy): gradcheck EXHAUSTIVE: worst_abs = {wc_abs:.3e}, "
        f"worst_rel(>1e-3) = {wc_rel:.3e}  "
        f"{'OK' if wc_abs < 1e-7 and wc_rel < 1e-4 else 'FAIL - halting, no epochs'}")
    if not (wc_abs < 1e-7 and wc_rel < 1e-4):
        with open(OUT, "w") as f: f.write("\n".join(lines) + "\n")
        return
    mvec = {k: np.zeros_like(P[k]) for k in NAMES}
    vvec = {k: np.zeros_like(P[k]) for k in NAMES}
    t0g = time.time()
    for ep in range(EPOCHS):
        nll, G = step_all(train, P)
        tt, _ = step_all(test, P)
        gn = float(np.sqrt(sum(float(np.sum(G[k] ** 2)) for k in NAMES)))
        if gn > CLIP:
            for k in NAMES:
                G[k] = G[k] * (CLIP / gn)
        for k in NAMES:
            mvec[k] = 0.9 * mvec[k] + 0.1 * G[k]
            vvec[k] = 0.999 * vvec[k] + 0.001 * (G[k] ** 2)
            mh = mvec[k] / (1 - 0.9 ** (ep + 1))
            vh = vvec[k] / (1 - 0.999 ** (ep + 1))
            P[k] = P[k] - (LR * mh / (np.sqrt(vh) + 1e-8) + WDECAY * P[k])
        rep(f"    epoch {ep+1:2d}: train {nll:.5f}   test {tt:.5f}   ({time.time()-t0g:.0f}s)")
    rep(f"  SUMMARY (TEST nats/symbol; lower = better):")
    rep(f"    K1 (pair law)    {r1:.5f}   [baseline]")
    rep(f"    K2               {r2:.5f}   D = {r2-r1:+.5f}")
    rep(f"    K4 interpolated  {r4:.5f}   D = {r4-r1:+.5f}")
    rep(f"    GRU              {tt:.5f}   D = {tt-r1:+.5f}   (SE ~ 0.01 = 1 sigma)")
    D = tt - r1
    if D < -0.02:
        v = "DEEPER THAN THE PAIR LAW - learned structure beyond the pair!"
    elif D > 0.02:
        v = "WORSE THAN THE PAIR - capacity misfit; no claim either way"
    else:
        v = "THE BABY IS MARRIED: no learnable structure beyond the pair law"
    rep(f"    VERDICT: {v}")
    rep(f"== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f: f.write("\n".join(lines) + "\n")

if __name__ == "__main__":
    main()
