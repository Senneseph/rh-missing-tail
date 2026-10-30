#!/usr/bin/env python3
# LOOM RBE (0224): RATTLEBACK + CHINESE-FINGER-TRAP on the prime weave.
#
# Owner (2026-10-30): (1) "what if there is not just a swirl in one
# direction, but a rattle-back effect where sometimes, even though a lot of
# momentum has built up in one direction, because of the geometry, the mode
# changes and it reverses directions" and (2) "what if the gaussian splats
# ... is like a chinese finger trap in its progression".
#
# Named finite objects (the translation):
#
# RBE-1 the RATTLEBACK on the class swirl (G24, the 12-wheel):
#   - increments d_i = signed class step of consecutive gap-classes in
#     [-6,+6] (half-turn |d|=6 counted as a FLIP, excluded from momentum);
#   - the chiral current J = mean(d) (the background swirl; 0221b: it flips
#     sign between 2e6 and 1e7 - the current is small and scale-dependent);
#   - the SPIN WALK  W_i = sum of (d - J)  (momentum minus background);
#   - excursions between zero crossings: (sign, peak H, duration T);
#   - REVERSAL RATIO  rho = H(next, opposite) / H(current)  - how much of
#     the built-up momentum the next flip gives back (the rattleback's
#     "mode change");
#   - the FINGER-TRAP CURVE  rho(H): if the deeper the spin-up, the more
#     complete the forced reversal (the trap constricts with depth), rho
#     must RISE with H;
#   - chirality asymmetry: + vs - excursion peaks (the anisotropy
#     fingerprint: the toy reverses because its geometry is anisotropic);
#   - settling: duration of the excursion following a near-full flip
#     (rho > 0.8) vs baseline (the toy SETTLES after the flip);
#   - scale: median spin-up duration vs X (does the wind-up grow?);
#   - NULL-1: 80 iid-increment walks with the SAME d distribution and
#     same J (no memory beyond the pair) - the structural-vs-trivial
#     discriminator (the 0219 floor methodology, applied to dynamics).
#
# RBE-2 the FINGER TRAP on the gap tension (the progression itself):
#   - the gap sequence IS the tension record: each gap = one forward pull
#     into the void;
#   - C1 = corr(g_i, g_{i+1})  (the trap: tension begets tension = it
#     constricts under a forward pull)  + C1 normalized by local E[g]~ln p;
#   - C2 = corr(g_i, g_{i+2})  (the release: the trap gives back after the
#     tension peak = slack rebound);
#   - tension excursions of V_i = g_i - ln(p_i): peaks, durations, the
#     reversal ratio rho and the trap curve rho(H) (same as RBE-1);
#   - SLACK REBOUND: mean(g_{i+1}) given g_i in the top 5% (vs the
#     unconditional mean; <1 = release, >1 = persistence);
#   - NULL-2: 80 iid Cramer-geometric gap walks at the local rates.
#
# Scales: the visualizer ladder 1e5 / 1e6 / 1e7 / 1e8 (last 100k primes;
# 1e5 nearly full table). OFF-BOARD; no RH claim; single-threaded;
# 4 cores open.

import math, os, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom9_out.txt"
NWIN = 100_000
XS = [100_000, 1_000_000, 10_000_000, 100_000_000]
NNUL = 80
NNULL = 50_000

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def excursion_stats(w):
    """zero-crossing excursions of 1-D walk w (w[0]=0).
    returns dict: n_exc, medH, top10H (10th pct of peaks), medT,
    med_rho (reversal ratio of consecutive opposite excursions),
    rho_by_H (list of (Hbin_center, mean rho, n)), settle_ratio
    (duration after a rho>0.8 flip / baseline), posH/negH medians."""
    n = len(w)
    signs = np.sign(w)
    exc_H, exc_T, exc_S = [], [], []
    i = 1
    while i < n:
        if signs[i] == 0:
            i += 1
            continue
        sgn = signs[i]
        j = i
        peak = abs(w[i])
        while j < n and signs[j] == sgn:
            if abs(w[j]) > peak:
                peak = abs(w[j])
            j += 1
        if peak > 0:
            exc_H.append(peak)
            exc_T.append(j - i)
            exc_S.append(sgn)
        i = j
    H = np.array(exc_H, dtype=float)
    T = np.array(exc_T, dtype=float)
    S = np.array(exc_S, dtype=int)
    out = {}
    if len(H) < 10:
        return out
    out["n_exc"] = len(H)
    out["medH"] = float(np.median(H))
    out["top10H"] = float(np.percentile(H, 90))
    out["medT"] = float(np.median(T))
    out["posH"] = float(np.median(H[S == 1])) if (S == 1).any() else float("nan")
    out["negH"] = float(np.median(H[S == -1])) if (S == -1).any() else float("nan")
    # reversal ratios: consecutive excursions of opposite sign
    rr = []
    rho_seq = np.zeros(len(H) - 1)
    for k in range(len(H) - 1):
        if S[k] != S[k + 1]:
            rr.append(H[k + 1] / max(H[k], 1e-9))
            rho_seq[k] = 1
    rr = np.array(rr) if rr else np.array([np.nan])
    out["medi_rho"] = float(np.median(rr)) if len(rr) and np.isfinite(rr[0]) else float("nan")
    # trap curve: rho binned by the CURRENT peak H
    bins = [1.0, 2.0, 4.0, 8.0, 16.0, 64.0]
    curve = []
    for b0, b1 in zip(bins[:-1], bins[1:]):
        sel = []
        for k in range(len(H) - 1):
            if S[k] != S[k + 1] and b0 <= H[k] < b1:
                sel.append(H[k + 1] / max(H[k], 1e-9))
        if len(sel) >= 3:
            curve.append((math.sqrt(b0 * b1), float(np.mean(sel[:200])), len(sel)))
        else:
            curve.append((math.sqrt(b0 * b1), float("nan"), len(sel)))
    out["rhoH"] = curve
    # settling: duration of excursions following a near-full flip
    idx = [k + 1 for k in range(len(H) - 1) if S[k] != S[k + 1] and H[k + 1] >= 0.8 * H[k]]
    if idx:
        out["settle"] = float(np.median(T[idx]) / max(out["medT"], 1e-9))
    else:
        out["settle"] = float("nan")
    return out

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    out = []
    def rep(s=""):
        print(s); out.append(s)
    t0 = time.time()
    rep("LOOM RBE (0224): RATTLEBACK (class swirl) + FINGER TRAP (gap tension)")
    rep("(OFF-BOARD; no RH claim; nulls = no-memory walks with the same local law)")

    Xb = int(max(XS) * 1.0)
    sb = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if sb[i]], dtype=np.int64)
    rep(f"  sieve to {Xb}: {len(primes)} primes; {time.time()-t0:.1f}s")

    for X in XS:
        upto = np.searchsorted(primes, X, side="right")
        n = min(NWIN, upto - 1)
        win = primes[upto - n: upto]
        gaps = np.diff(win)
        p = win
        g = gaps.astype(float)
        lnP = np.log(p[:-1])
        c = ((g % 24) // 2).astype(int)
        rep(f"\n{'='*74}\n  X = {X}   window = {win[0]}..{win[-1]}  n={len(win)}\n{'='*74}")

        # ---------- RBE-1: rattleback on the 12-wheel class swirl ----------
        d = np.zeros(len(c) - 1, dtype=int)
        for i in range(len(c) - 1):
            dd = (c[i + 1] - c[i]) % 12
            if dd > 6:
                dd -= 12
            d[i] = dd
        flips = int(np.sum(np.abs(d) == 6))
        m = np.abs(d) != 6
        dm = d[m]
        J = float(dm.mean())
        W = np.concatenate([[0.0], np.cumsum(dm - J)])
        sr = excursion_stats(W)
        rep(f"\n  RBE-1 RATTLEBACK (12-wheel class swirl)")
        rep(f"    flips |d|=6: {flips} ({flips/(len(d))*100:.2f}%)   "
            f"chiral current J = {J:+.5f} wheel-steps/symbol")
        if sr:
            rep(f"    excursions: n={sr['n_exc']}  medH={sr['medH']:.1f}  "
                f"top-decile H={sr['top10H']:.1f}  medT={sr['medT']:.0f} symbols "
                f"(= {sr['medT']*g.mean():.0f} ints)")
            rep(f"    chirality: medH(+)= {sr['posH']:.1f}   medH(-)= {sr['negH']:.1f}   "
                f"(anisotropy fingerprint)")
            rep(f"    reversal: med rho = {sr['medi_rho']:.3f}   "
                f"settle ratio = {sr['settle']:.2f} (dur. after near-full flip)")
            rep("    TRAP CURVE rho(H) [n]:  " + "  ".join(
                f"H~{h:<5.1f}: {r if r==r else float('nan'):.2f}[{n}]"
                for h, r, n in sr["rhoH"]))

            # null-1: iid increments, same distribution + J
            nrm = np.bincount(dm + 5, minlength=11)
            vals = np.arange(-5, 6)
            pv = nrm / nrm.sum()
            null_rho = []; null_top = []; null_medT = []; null_posneg = []
            rng0 = np.random.default_rng(42)
            for r in range(NNUL):
                dd = rng0.choice(vals, size=NNULL, p=pv)
                Wn = np.concatenate([[0.0], np.cumsum(dd - float(dd.mean()))])
                s2 = excursion_stats(Wn)
                if s2:
                    null_rho.append(s2["medi_rho"])
                    null_top.append(s2["top10H"])
                    null_medT.append(s2["medT"])
                    null_posneg.append(s2["posH"] - s2["negH"])
            null_rho = np.array([x for x in null_rho if np.isfinite(x)])
            if len(null_rho):
                rep(f"    NULL-1 (iid increments, same J, n={NNULL}): "
                    f"med rho = {np.median(null_rho):.3f} [{np.percentile(null_rho,2.5):.3f}, "
                    f"{np.percentile(null_rho,97.5):.3f}]   top-dec H = "
                    f"{np.median(np.array(null_top)):.1f}")
            if null_posneg:
                npn = np.array(null_posneg)
                real_pn = sr["posH"] - sr["negH"]
                rep(f"    NULL-1 chirality (+/- medH split): {np.median(npn):+.1f} "
                    f"[{np.percentile(npn,2.5):+.1f},{np.percentile(npn,97.5):+.1f}]   "
                    f"REAL = {real_pn:+.1f}")
        else:
            rep("    (too few excursions)")

        # ---------- RBE-2: finger trap on the gap tension ----------
        gc = g[:-1]; gn = g[1:]
        c1 = float(np.corrcoef(gc, gn)[0, 1])
        c1n = float(np.corrcoef(gc / lnP[:-1], gn / np.log(p[1:-1]))[0, 1])
        c2 = float(np.corrcoef(g[:-2], g[2:])[0, 1])
        V = g / lnP - 1.0
        tr = excursion_stats(V)
        rep(f"\n  RBE-2 FINGER TRAP (gap tension walk)")
        rep(f"    C1 = corr(g_i, g_{{i+1}}) = {c1:+.5f}   "
            f"C1(ln-norm) = {c1n:+.5f}   C2 = corr(g_i, g_{{i+2}}) = {c2:+.5f}")
        q95 = float(np.quantile(g, 0.95))
        sel = gc > q95
        rebound = float(gn[sel].mean() / g.mean()) if sel.any() else float("nan")
        rep(f"    top-5% tension (g>{q95:.0f}): next-gap rebound = {rebound:.3f} "
            f"(<1 release / >1 persistence)  n={int(sel.sum())}")
        if tr:
            rep(f"    tension excursions: n={tr['n_exc']}  medH={tr['medH']:+.2f} (in ln units)  "
                f"medT={tr['medT']:.0f} gaps   med rho = {tr['medi_rho']:.3f}"
                f"   settle = {tr['settle']:.2f}")
            rep("    TRAP CURVE rho(H) [n]:  " + "  ".join(
                f"H~{h:<5.1f}: {r if r==r else float('nan'):.2f}[{n}]"
                for h, r, n in tr["rhoH"]))
            # null-2: iid Cramer-geometric at the window's median rate
            rng0 = np.random.default_rng(43)
            lam0 = 2.0 / float(np.median(np.log(p)))
            null_c1 = []; null_r = []
            for r in range(NNUL):
                ga = 2.0 * np.ceil(-np.log(rng0.random(NNULL)) / lam0)
                gg = ga[:-1]; g2 = ga[1:]
                null_c1.append(float(np.corrcoef(gg, g2)[0, 1]))
                null_r.append(float(np.median(g2 / np.maximum(gg, 1))))
            null_c1 = np.array([x for x in null_c1 if np.isfinite(x)])
            rep(f"    NULL-2 (iid Cramer geom., local rates): C1 = "
                f"{np.median(null_c1):+.5f} [{np.percentile(null_c1,2.5):+.5f}, "
                f"{np.percentile(null_c1,97.5):+.5f}]   rebound = "
                f"{np.median(null_r):.3f}")

    rep(f"\n== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
