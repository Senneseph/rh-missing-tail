#!/usr/bin/env python3
"""
LOOM16 — LOCK-ON-SUCCESS (the owner's learning gate, made finite)
(off-board side-quest; no RH claim; 1 core, 4 open)

'our box could be every predictive prime theorem combined into a mix
for the neural network to consume' + 'if i encountered it before and
the answer was correct, never change the answer, retrain to make a
difference. otherwise: do best with the signals we have.'

  box    = the 26-note channel bank (0232): PNT-scale slack analogs,
           Mertens/gate, pair-law shadow, 24-frame, tile phase, the
           flux charge (omega), even/odd beat, claim energy, ...
  target = the EXACT ONE, discretized: decile bin of L_{g+1}
           (the next gap length), 10 bins, edges from TRAIN.
  split  = TRAIN first 400k gaps, TEST next 100k (frontier holdout,
           same protocol as 0225).

  ladder:  PRIOR   train marginal P(bin)
           PAIR    P(bin | G24 class of current gap)  [pair-law level]
           LINEAR  ridge softmax on the standardized bank (train fit)
           LINDROPOut    LINEAR fit on target-rowshuffled features
                        (feature-target coupling null)
           GRU     hand-rolled 0225 machine, D=26 float input, h=24,
                   24 epochs, Adam, gradcheck first
           GRU-LOCK  same + the owner's gate:
                     configuration key = per-channel quantile label
                     (the 'configuration matrix'); a previously seen
                     key whose answer was CORRECT is FROZEN: forever
                     after it answers with its first-correct logits and
                     receives no gradient ('never change the answer');
                     wrong/unseen keys keep learning
                     ('retrain to make a difference').

  metric : TEST nats/step + top-1, D = NLL - NLL(PAIR).
No torch, no sklearn. Single-threaded numpy.
"""
import math, os, sys, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom16_out.txt"
X = 10_000_000
XLO = 100_000
NTRAIN = 400_000
NTEST = 100_000
D = 23
A = 10
H = 24
EPOCHS = 24
LR = 3e-3
CLIP = 5.0
WDECAY = 1e-5
SEED = 16
NPERM = 50

LINES = []
def rep(s=""):
    print(s, flush=True)
    LINES.append(s)
    if len(LINES) % 5 == 0:
        with open(OUT, "w") as f:
            f.write("\n".join(LINES) + "\n")

# ---------------- tape + bank (loom15 construction, inlined) -------------
def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(range(i * i, n + 1, i)))
    return s

def build_bank():
    t0 = time.time()
    s = sieve(X)
    primes = np.array([i for i in range(2, X + 1) if s[i]], dtype=np.int64)
    pfmax = int(math.isqrt(X)) + 1
    spf = np.zeros(X + 1, dtype=np.int64)
    for p in primes[primes <= pfmax]:
        m = np.arange(p * p, X + 1, p)
        mask = spf[m] == 0
        spf[m[mask]] = p
    ip = np.nonzero((primes >= XLO) & (primes <= X))[0]
    ok = (ip + 1 < len(primes)) & (primes[np.minimum(ip + 1, len(primes) - 1)] <= X)
    ip = ip[ok]
    p = primes[ip]
    pnxt = primes[ip + 1]
    nruns = len(p)
    L = (pnxt - p - 1).astype(np.int64)
    void_lane = pnxt % 24
    off = np.empty(nruns, dtype=np.int64)
    off[0] = 0
    np.cumsum(L[:-1], out=off[1:])
    comp_idx = np.arange(p[0] + 1, pnxt[-1])
    comp_mask = np.frombuffer(s, dtype=np.uint8)[p[0] + 1:pnxt[-1]] == 0
    partner = spf[comp_idx[comp_mask]]
    nlam = partner.size
    assert nlam == int(L.sum())
    lane_of_partner = partner % 24
    z = np.exp(2j * math.pi * lane_of_partner / 24.0)
    maskL = L >= 2
    Lm1 = (L - 1).astype(np.int64)
    ns = int(Lm1.sum())
    zp1 = np.roll(z, -1)
    islast = np.zeros(nlam, dtype=bool)
    islast[off + (L - 1)] = True
    steps = np.where(islast, 1.0 + 0j, zp1 / z)
    valid_slots = ~islast
    stepz = steps[valid_slots]
    assert stepz.size == ns
    dphi = np.angle(stepz)
    isfirst0 = np.zeros(nlam, dtype=bool)
    isfirst0[off] = True
    mask14 = valid_slots & ~isfirst0
    dphi_pad = np.zeros(nlam, dtype=np.float64)
    dphi_pad[valid_slots] = dphi
    omega14 = np.add.reduceat(np.where(mask14, dphi_pad, 0.0), off)
    # bank channels (loom15 names minus V/Y; order = A..Z)
    Lfloat = L.astype(np.float64)
    bias = np.add.reduceat((partner == 2).astype(np.int64), off) / Lfloat
    keep = np.add.reduceat((partner <= 13).astype(np.int64), off) / Lfloat
    lose = 1 - keep
    parity = np.add.reduceat((partner % 2 == 1).astype(np.int64), off) / Lfloat
    zeta = np.add.reduceat(1.0 / partner.astype(np.float64), off)
    hold = np.maximum.reduceat(partner, off).astype(np.float64)
    e0 = np.zeros(nlam, dtype=np.float64)
    e0[valid_slots] = (dphi == 0)
    echo_s = np.add.reduceat(e0, off) / np.maximum(Lm1, 1)
    hard = (np.abs(dphi) > math.pi / 2).astype(np.float64)
    hardpad = np.zeros(nlam, dtype=np.float64)
    hardpad[valid_slots] = hard
    intersec = np.add.reduceat(hardpad, off).astype(np.float64)
    isfirst = np.zeros(nlam, dtype=bool)
    isfirst[off] = True
    diff_at = np.zeros(nlam, dtype=np.int64)
    diff_flat = np.abs(np.diff(partner))
    diff_at[1:][~isfirst[1:]] = diff_flat[~isfirst[1:]]
    jump = np.maximum.reduceat(diff_at, off).astype(np.float64)
    # xrun: running per-run max of consecutive equal-partner run length
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
    # gate / oddflank (odd flanks, L>=2)
    gate_lane = np.full(nruns, -1.0, dtype=np.float64)
    oddflank = np.full(nruns, -1.0, dtype=np.float64)
    if maskL.any():
        gate_lane[maskL] = (spf[pnxt[maskL] - 2]) % 24
        oddflank[maskL] = (spf[p[maskL] + 2]) % 24
    # cycle / no-return
    cycle = np.round(np.add.reduceat(dphi_pad, off) / (2 * math.pi)).astype(np.float64)
    noreturn = np.ones(nruns, dtype=np.float64)
    cur_set = None
    rc = 0
    for ii in range(nlam):
        if ii == off[rc]:
            cur_set = {lane_of_partner[ii]}
        else:
            lv = lane_of_partner[ii]
            if lv in cur_set:
                if noreturn[rc] == 1:
                    noreturn[rc] = 0
            else:
                cur_set.add(lv)
        if ii == off[rc] + L[rc] - 1:
            rc += 1
            if rc >= nruns:
                break
    # quiet (distinct partners per run) + unpaired
    order_v = np.argsort(partner, kind="stable")
    pv = partner[order_v]
    runid = np.clip(np.searchsorted(off, order_v, side="right") - 1, 0, nruns - 1)
    distinct_keys = pv.astype(np.int64) * nruns + runid
    dcount = np.bincount(runid[np.concatenate(([True], distinct_keys[1:] != distinct_keys[:-1]))],
                         minlength=nruns).astype(np.float64)
    quiet = dcount
    one_mask = np.concatenate(([True], distinct_keys[1:] != distinct_keys[:-1]))
    one_mask2 = one_mask & np.concatenate((distinct_keys[1:] != distinct_keys[:-1], [True]))
    unp_mask = one_mask & one_mask2
    unpaired = np.bincount(runid[unp_mask], minlength=nruns).astype(np.float64) / Lfloat
    # wait (first-max position fraction)
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
    runmax = np.maximum.reduceat(partner, off)
    cur_run = np.clip(np.searchsorted(off, np.arange(nlam), side="right") - 1, 0, nruns - 1)
    fm = partner == runmax[cur_run]
    order2 = np.lexsort((pos_in_run[fm], cur_run[fm]))
    cr_o = cur_run[fm][order2]
    first_idx = np.unique(cr_o, return_index=True)[1]
    wait_num = np.full(nruns, -1.0)
    wait_num[cr_o[first_idx]] = pos_in_run[fm][order2][first_idx] / Lfloat
    wait = np.where(wait_num >= 0, wait_num, 0.0)
    dabs_pad = np.zeros(nlam, dtype=np.float64)
    dabs_pad[valid_slots] = np.abs(dphi)
    turn_s = np.add.reduceat(dabs_pad, off) / np.maximum(Lm1, 1)
    dphi2pad = np.zeros(nlam, dtype=np.float64)
    dphi2pad[valid_slots] = dphi_abs2 = dphi * dphi
    dphi2_s = np.add.reduceat(dphi2pad, off) / np.maximum(Lm1, 1)
    shape_s = np.sqrt(np.clip(dphi2_s - turn_s * turn_s, 0, None))
    bpad = np.zeros(nlam, dtype=np.float64)
    bpad[valid_slots] = stepz.imag
    asums = np.add.reduceat(bpad, off)  # unused downstream, parity with 15
    apad = np.zeros(nlam, dtype=np.float64)
    apad[valid_slots] = stepz.real
    zpad = np.zeros(nlam, dtype=complex)
    zpad[valid_slots] = stepz
    Zc = np.concatenate(([0j], np.cumsum(zpad)))
    Vstep = np.abs(Zc[off + Lm1] - Zc[off])
    mom = Vstep
    drift = Vstep / np.sqrt(Lfloat)
    feats = np.column_stack([
        Lfloat,               # A amp
        bias,                 # B bias
        cycle,                # C cycle
        drift,                # D drift
        echo_s,               # E echo
        omega14,              # F flux (the charge)
        gate_lane,            # G gate
        hold,                 # H hold
        intersec,             # I intersect
        jump,                 # J jump
        keep,                 # K keep
        lose,                 # L lose
        mom,                  # M moment
        noreturn,             # N no-return
        oddflank,             # O oddflank
        parity,               # P parity
        quiet,                # Q quiet
        shape_s,              # S shape
        turn_s,               # T turn
        unpaired,             # U unpaired
        wait,                 # W wait
        xrun.astype(np.float64),  # X xrun
        hold * 0.0,           # Y (scale placeholder, dropped below)
        zeta,                 # Z zeta
    ])
    feats = np.delete(feats, 22, axis=1)  # drop Y placeholder -> 26 cols
    rep(f"  bank built: {nruns} gaps x 26 channels ({time.time()-t0:.1f}s)")
    return feats, L, void_lane

# ---------------- decile quantizer (the 'configuration matrix') ---------
def quantize(feats):
    tr = feats[:NTRAIN]
    edges = np.quantile(tr, [i / A for i in range(1, A)], axis=0).T  # (23, 9)
    # per-column bucket (numpy digitize has no axis arg): count edges below
    lab = (feats[:, :, None] > edges[None, :, :]).sum(axis=2).astype(np.uint8)
    return lab, edges

# ---------------- baselines ----------------------------------------------
def prior_nll(tgt):
    f = np.bincount(tgt, minlength=A) + 1.0
    f /= f.sum()
    return float(-np.mean(np.log(f[tgt])), len(tgt)) if False else float(-np.mean(np.log(f[tgt])))

def prior_acc(tgt):
    f = np.bincount(tgt, minlength=A) + 1.0
    return float((np.argmax(f) == tgt).mean())

def pair_nll(tgt, cls, T):
    # P(bin | G24 class) Laplace-smoothed, train-fit; eval on T rows
    C = 12
    M = np.zeros((C, A))
    for c in range(C):
        m = cls == c
        M[c] = np.bincount(tgt[m], minlength=A) + 1.0
        M[c] /= M[c].sum()
    nll = 0.0
    for i in range(0, len(tgt), 50000):
        lo, hi = i, min(i + 50000, len(tgt))
        nll += -np.log(M[T[lo:hi], tgt[lo:hi]]).sum()
    return nll / len(tgt)

def pair_acc(tgt, cls, T):
    C = 12
    M = np.zeros((C, A))
    for c in range(C):
        m = cls == c
        M[c] = np.bincount(tgt[m], minlength=A) + 1.0
    return float(mean_argmax(M[T], tgt))

def mean_argmax(Mrow, tgt):
    acc = 0.0
    for i in range(0, len(tgt), 50000):
        lo, hi = i, min(i + 50000, len(tgt))
        acc += (np.argmax(Mrow[lo:hi], axis=1) == tgt[lo:hi]).sum()
    return acc / len(tgt)

def fit_linear(Xtr, Ytr, Xte, Yte, iters=150, lr=0.5, l2=1e-3):
    n, d = Xtr.shape
    W = np.zeros((d, A))
    b = np.zeros(A)
    Yoh = np.zeros((n, A))
    Yoh[np.arange(n), Ytr] = 1.0
    m = 20000
    for it in range(iters):
        lo = 0 if n <= m else (it * m) % (n - m)
        hi = lo + m
        Xs = Xtr[lo:hi]
        lg = Xs @ W + b
        lg -= lg.max(axis=1, keepdims=True)
        P = np.exp(lg)
        P /= P.sum(axis=1, keepdims=True)
        P = np.clip(P, 1e-12, None)
        dW = (Xs.T @ (P - Yoh[lo:hi])) / m + l2 * W
        db = (P - Yoh[lo:hi]).mean(axis=0)
        W -= lr * dW
        b -= lr * db
    def score(X, Y):
        n = len(Y)
        nll = 0.0
        acc = 0
        for i in range(0, n, 50000):
            hi = min(i + 50000, n)
            lg = X[i:hi] @ W + b
            lg -= lg.max(axis=1, keepdims=True)
            P = np.exp(lg)
            P /= P.sum(axis=1, keepdims=True)
            P = np.clip(P, 1e-12, None)
            nll += -np.log(P[np.arange(hi - i), Y[i:hi]]).sum()
            acc += (np.argmax(P, axis=1) == Y[i:hi]).sum()
        return nll / n, acc / n
    return score(Xtr, Ytr), score(Xte, Yte)

# ---------------- the GRU (0225 machine, float input, + LOCK gate) ------
NAMES = ["Wz", "Uz", "bz", "Wr", "Ur", "br", "Wc", "Uc", "bc", "Wo", "bo"]

def make_params(rng):
    P = {}
    P["Wz"] = rng.standard_normal((D, H)) * 0.3
    P["Uz"] = rng.standard_normal((H, H)) * 0.08
    P["bz"] = np.zeros(H)
    P["Wr"] = rng.standard_normal((D, H)) * 0.3
    P["Ur"] = rng.standard_normal((H, H)) * 0.08
    P["br"] = np.zeros(H)
    P["Wc"] = rng.standard_normal((D, H)) * 0.3
    P["Uc"] = rng.standard_normal((H, H)) * 0.08
    P["bc"] = np.zeros(H)
    P["Wo"] = rng.standard_normal((H, A)) * 0.3
    P["bo"] = np.zeros(A)
    return P

def sigmoid(u):
    out = np.empty_like(u)
    pos = u >= 0
    out[pos] = 1.0 / (1.0 + np.exp(-u[pos]))
    e = np.exp(u[~pos])
    out[~pos] = e / (1.0 + e)
    return out

def step_all(Xs, ys, P, keys=None, frozen=None, seen=None, seen_ok=None,
             first_ok_logits=None, train_mode=False):
    """float-input GRU over rows of Xs; target = ys[t] at step t."""
    n = len(ys)
    h = np.zeros(H)
    cache = []
    frozen_at = np.zeros(n, dtype=bool)
    for t in range(n):
        x = Xs[t]
        pre_z = x @ P["Wz"] + h @ P["Uz"] + P["bz"]
        pre_r = x @ P["Wr"] + h @ P["Ur"] + P["br"]
        zz = sigmoid(pre_z); r = sigmoid(pre_r)
        pre_c = x @ P["Wc"] + (r * h) @ P["Uc"] + P["bc"]
        hc = np.tanh(pre_c)
        hnew = (1 - zz) * h + zz * hc
        logits = hnew @ P["Wo"] + P["bo"]
        # ---- the lock-on-success gate ----
        use_logits = logits
        if keys is not None:
            k = keys[t]
            if train_mode:
                # decision (freeze) with the CURRENT answer: seen before and
                # was correct at some prior visit -> freeze at the first-correct
                if k in seen and seen_ok.get(k, False) and k not in frozen:
                    frozen[k] = first_ok_logits[k]
                    use_logits = frozen[k]
                    frozen_at[t] = True
                cur_pred = int(np.argmax(use_logits))
                if cur_pred == ys[t]:
                    if k not in first_ok_logits:
                        first_ok_logits[k] = logits.copy()
                    seen_ok[k] = True
                if k in seen and k not in frozen:
                    pass  # seen before, was wrong: keep learning (retrain)
                elif k not in seen:
                    seen[k] = logits.copy()
            if k in frozen:               # application: both train and test
                use_logits = frozen[k]
                frozen_at[t] = True
        cache.append((x, h, zz, r, hc, hnew, logits, use_logits, frozen_at[t]))
        h = hnew
    G = {k: np.zeros_like(P[k]) for k in NAMES}
    dinp = np.zeros((n, H))
    for t in range(n - 1, -1, -1):
        x, hprev, zz, r, hc, hnew, logits, use_logits, isfrozen = cache[t]
        dh = dinp[t].copy()
        # every step has its own target ys[t] (box_t predicts tgt_t)
        m0 = use_logits.max()
        pu = use_logits - m0
        p = np.exp(pu)
        p /= p.sum()
        if not isfrozen:              # frozen answers take no gradient
            dlog = p.copy()
            dlog[ys[t]] -= 1.0
            G["Wo"] += np.outer(hnew, dlog)
            G["bo"] += dlog
            dh = dh + dlog @ P["Wo"].T
        dza = dh * (hc - hprev) * zz * (1 - zz)
        G["Wz"] += np.outer(x, dza)
        G["Uz"] += np.outer(hprev, dza)
        G["bz"] += dza
        dpre_c = dh * zz * (1 - hc * hc)
        G["Wc"] += np.outer(x, dpre_c)
        G["Uc"] += np.outer(r * hprev, dpre_c)
        G["bc"] += dpre_c
        dra = (P["Uc"] @ dpre_c) * hprev * r * (1 - r)
        G["Wr"] += np.outer(x, dra)
        G["Ur"] += np.outer(hprev, dra)
        G["br"] += dra
        if t > 0:
            uc_dpre = P["Uc"] @ dpre_c
            dinp[t - 1] += (dh * (1 - zz)
                            + P["Uz"] @ dza
                            + r * uc_dpre
                            + P["Ur"] @ (r * (1 - r) * hprev * uc_dpre))
    # NLL on the (possibly frozen) used distribution
    nll = 0.0
    for t in range(n):
        lg = cache[t][7]
        m0 = lg.max()
        nll += -(lg[ys[t]] - m0 - math.log(np.exp(lg - m0).sum()))
    return nll / n, G, frozen_at, cache

def z_hc(zz, hc, h):
    return (1 - zz) * h + zz * hc

def train_gru(Xtr, Ytr, Xte, Yte, keys_tr, keys_te, lock, seed, epochs=None):
    rng = np.random.default_rng(seed)
    P = make_params(rng)
    mvec = {k: np.zeros_like(P[k]) for k in NAMES}
    vvec = {k: np.zeros_like(P[k]) for k in NAMES}
    seen = {}
    seen_ok = {}
    first_ok_logits = {}
    frozen = {}
    ep_ = epochs or EPOCHS
    t0 = time.time()
    for ep in range(ep_):
        nll, G, fz, _ = step_all(Xtr, Ytr, P, keys_tr, frozen, seen, seen_ok,
                                 first_ok_logits, train_mode=lock)
        tt, _, tfz, _ = step_all(Xte, Yte, P, keys_te, frozen, seen, seen_ok,
                                 first_ok_logits, train_mode=False)
        gn = float(np.sqrt(sum(float(np.sum(G[k] ** 2)) for k in NAMES)) or 1e-12)
        if gn > CLIP:
            for k in NAMES:
                G[k] = G[k] * (CLIP / gn)
        for k in NAMES:
            mvec[k] = 0.9 * mvec[k] + 0.1 * G[k]
            vvec[k] = 0.999 * vvec[k] + 0.001 * (G[k] ** 2)
            mh = mvec[k] / (1 - 0.9 ** (ep + 1))
            vh = vvec[k] / (1 - 0.999 ** (ep + 1))
            P[k] = P[k] - (LR * mh / (np.sqrt(vh) + 1e-8) + WDECAY * P[k])
        rep(f"    ep {ep+1:2d}: train {nll:.5f}  test {tt:.5f}"
            + (f"  frozen_keys={len(frozen)} train_frozen_pos={fz.sum()}" if lock else "")
            + f"  ({time.time()-t0:.0f}s)")
    # final test scoring + lock stats
    nll, _, fz, _ = step_all(Xte, Yte, P, keys_te, frozen, seen, seen_ok,
                             first_ok_logits, train_mode=False)
    return nll, P, frozen, seen, fz

def gradcheck(P):
    n = 12
    rng = np.random.default_rng(3)
    Xs = rng.standard_normal((n, D))
    ys = np.array([3, 7, 1, 2, 9, 4, 0, 6, 2, 8, 5, 1], dtype=np.int64)
    _, G, _, _ = step_all(Xs, ys, P)
    def Ltot():
        return step_all(Xs, ys, P)[0] * len(ys)
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
            dd = abs(num - Gflat[j])
            worst_abs = max(worst_abs, dd)
            if abs(num) + abs(Gflat[j]) > 1e-3:
                worst_rel_big = max(worst_rel_big, dd / (abs(num) + abs(Gflat[j])))
    return worst_abs, worst_rel_big

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    t0 = time.time()
    rep("LOOM16 (0233?): LOCK-ON-SUCCESS - theorems-box -> the exact one")
    rep(f"(bank=26 notes, target=decile of L_next, train={NTRAIN}, test={NTEST}, frontier holdout)")
    feats, L, void_lane = build_bank()
    cls_full = ((np.diff(np.concatenate(([L[0] - 1], L[:0])) ) % 24) // 2)  # placeholder
    # G24 class of the CURRENT gap = class of ITS length (12 symbols, as in 0225)
    cls = (L % 24) // 2
    cls = np.clip(cls, 0, 12 - 1)
    # next-gap target
    # TGT[t] = decile of L[t+1], t = 0..N-2 (box_t predicts the next gap)
    Lnext_tr = L[1:NTRAIN]
    edges = np.quantile(Lnext_tr, [i / A for i in range(1, A)])
    TGT = np.clip(np.digitize(L[1:], edges), 0, A - 1)
    tgt_tr = TGT[:NTRAIN]
    tgt_te = TGT[NTRAIN:NTRAIN + NTEST]
    rep(f"  L_next train range {Lnext_tr.min()}..{Lnext_tr.max()}, edges {edges.tolist()}")
    Xstd = (feats[:NTRAIN] - feats[:NTRAIN].mean(0)) / (feats[:NTRAIN].std(0) + 1e-9)
    Xte = (feats[NTRAIN:NTRAIN + NTEST] - Xstd.mean(0)) / (Xstd.std(0) + 1e-9)
    # configuration key = per-channel decile labels (train edges)
    lab, _ = quantize(feats)
    keys_tr = [row.tobytes() for row in lab[:NTRAIN]]
    rep(f"  distinct config keys in train: {len(set(keys_tr))} / {NTRAIN}")

    rep("")
    rep("== BASELINES (TEST nats/step, 10 bins; lower = better) ==")
    pp = prior_nll(tgt_te)
    pa = prior_acc(tgt_te)
    # pair baseline: TRAIN-fit M evaluated on TEST rows:
    C = 12
    M = np.zeros((C, A))
    for c in range(C):
        m = cls[:NTRAIN] == c
        M[c] = np.bincount(tgt_tr[m], minlength=A) + 1.0
        M[c] /= M[c].sum()
    pairv = float(-np.log(M[cls[NTRAIN:NTRAIN + NTEST], tgt_te]).mean())
    paira = float(mean_argmax(M[cls[NTRAIN:NTRAIN + NTEST]], tgt_te))
    rep(f"  PRIOR   {pp:.5f}   top1 = {pa:.4f}")
    rep(f"  PAIR    {pairv:.5f}   top1 = {paira:.4f}   [pair-law level, baseline]")

    rep("")
    rep("== LINEAR RIDGE on the box ==")
    (lnt, lna), (lte, lnae) = fit_linear(Xstd, tgt_tr, Xte, tgt_te)
    rep(f"  LINEAR  test {lte:.5f}   top1 = {lnae:.4f}   D vs PAIR = {lte - pairv:+.5f}")
    rng0 = np.random.default_rng(SEED)
    shrow = rng0.permutation(NTRAIN)
    (sn_t, sn_a), (sn_e, sn_ae) = fit_linear(Xstd, tgt_tr[shrow], Xte, tgt_te)
    rep(f"  LINDROP test {sn_e:.5f}   top1 = {sn_ae:.4f}   (dropped-target coupling null, D = {sn_e - pairv:+.5f})")

    rep("")
    rep("== GRU (0225 machine, D=26, h=24) ==")
    P = make_params(np.random.default_rng(SEED))
    wc_abs, wc_rel = gradcheck(P)
    ok = wc_abs < 1e-6 and wc_rel < 1e-4
    rep(f"  gradcheck EXHAUSTIVE: worst_abs = {wc_abs:.3e}  worst_rel(>1e-3) = {wc_rel:.3e}  {'PASS' if ok else 'FAIL - halt'}")
    if not ok:
        with open(OUT, "w") as f:
            f.write("\n".join(LINES) + "\n")
        return
    rep("  GRU-FREE (24 epochs):")
    keys_te = [row.tobytes() for row in lab[NTRAIN:NTRAIN + NTEST]]
    te_free, Pfree, _, _, _ = train_gru(Xstd[:NTRAIN], tgt_tr, Xte, tgt_te,
                                        keys_tr, keys_te, lock=False, seed=SEED)
    rep("  GRU-LOCK (owner's gate, 24 epochs):")
    te_lock, Plug, frozen, seen, tfz = train_gru(Xstd[:NTRAIN], tgt_tr, Xte, tgt_te,
                                                 keys_tr, keys_te, lock=True, seed=SEED)
    # lock stats
    test_keys = [row.tobytes() for row in lab[NTRAIN:NTRAIN + NTEST]]
    hit = np.array([1 if k in frozen else 0 for k in test_keys])
    rep("")
    rep("== SUMMARY (TEST nats/step; D vs PAIR; SE ~ 1/sqrt(100k) ~ 0.003 nats) ==")
    rep(f"  PRIOR      {pp:.5f}   top1 = {pa:.4f}")
    rep(f"  PAIR       {pairv:.5f}   top1 = {paira:.4f}   [baseline]")
    rep(f"  LINEAR     {lte:.5f}   top1 = {lnae:.4f}   D = {lte - pairv:+.5f}")
    rep(f"  LINDROP    {sn_e:.5f}   top1 = {sn_ae:.4f}   D = {sn_e - pairv:+.5f}")
    rep(f"  GRU-FREE   {te_free:.5f}   top1 = {free_acc(Pfree, Xte, tgt_te):.4f}   D = {te_free - pairv:+.5f}")
    rep(f"  GRU-LOCK   {te_lock:.5f}   top1 = {free_acc(Plug, Xte, tgt_te):.4f}   D = {te_lock - pairv:+.5f}")
    rep(f"  LOCK stats: frozen keys = {len(frozen)}; test rows hitting a frozen key = {hit.sum()} ({hit.mean():.3%})")
    D = te_lock - pairv
    if D < -0.02:
        VERDICT = "DEEPER - the box (with the owner's gate) beats the pair law on the exact one"
    elif D > 0.02:
        VERDICT = "WORSE than the pair - capacity misfit at this budget; the pair family still owns it"
    else:
        VERDICT = "MARSHALLED - the box finds nothing beyond the pair law on the exact one"
    rep(f"  VERDICT: {VERDICT}")
    rep(f"== done in {time.time() - t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(LINES) + "\n")

def free_acc(P, Xte, Yte):
    n = len(Yte)
    h = np.zeros(H)
    acc = 0
    for t in range(n):
        x = Xte[t]
        pre_z = x @ P["Wz"] + h @ P["Uz"] + P["bz"]
        pre_r = x @ P["Wr"] + h @ P["Ur"] + P["br"]
        zz = sigmoid(pre_z); r = sigmoid(pre_r)
        pre_c = x @ P["Wc"] + (r * h) @ P["Uc"] + P["bc"]
        hc = np.tanh(pre_c)
        hnew = (1 - zz) * h + zz * hc
        logits = hnew @ P["Wo"] + P["bo"]
        if np.argmax(logits) == Yte[t]:
            acc += 1
        h = hnew
    return acc / n

if __name__ == "__main__":
    main()
