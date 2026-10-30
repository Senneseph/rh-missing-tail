#!/usr/bin/env python3
# LOOM G-4 (0221): THE ANISOTROPIC SWIRL MOTOR.
#
# Owner (2026-10-29): "what if we use anisotropic filtering on something to
# locate the tropics of our search, like the spin points? maybe they grow a
# certain way in their swirl as the integers progress through the 24-adics
# as a auto-self-phase connected motor generator for our marriage plus baby
# 3-way metric"
#
# Named finite objects (the translation):
#  - the SEQUENCE SPLAT FIELD  F(theta, s): each symbol c_i of a class word
#    splats a 2D Gaussian of mass 1 at (theta_i = 2*pi*c_i/A, s = i).
#    Anisotropic footprint: sigma_theta = 1 circle-step (compact on the
#    class circle), sigma_s = the word's MEDIAN GAP (stretched along the
#    integer-progress axis)  => the field is ANISOTROPIC by construction,
#    and the MIP lesson says that stretch is where aliasing/detail lives.
#  - ANISOTROPIC FILTERING / TROPICS: 2D FFT of F; power P(k_theta, k_s).
#    The TROPIC = argmax P (excluding DC): (k-th*, k-s*) = WHERE the detail
#    is (class direction) and HOW FAST the swirl turns (progress rate).
#    The ANISOTROPY ASPECT A = <k_s^2>_P / <k_theta^2>_P (>>1 = procession
#    along the integers; <<1 = class-swirl dominated).
#  - SPIN POINTS (sequence side): omega_r = 2*pi * count(r)/L for each
#    symbol r  = the angular speed at which the integers pass class r.
#    (WF-24/0214's zeta-side twin: omega_r = ln n1(r); both are class-
#    dependent spins of the 24-adiic - here the sequence version so all
#    three parties use the same machine.)
#  - AUTO-SELF-PHASE COHERENCE (the "auto-self-connected" part): the field's
#    own dominant swirl frequency w* = k-s*(tropic); project F onto the
#    rotating frame e^{-i w* s} (and e^{+i w* s}); C = the peak normalized
#    coherence, L_c = the coherence LENGTH (how many symbol-steps the swirl
#    stays phase-locked to its own rotation before decorrelating).
#  - THE MOTOR: predict the next class by STEPPING THE FIELD BY ITS OWN
#    SPIN: theta_{i+1} = theta_i + w* (mod 2pi), map to nearest circle bin.
#    fidelity = next-class hit rate (vs the pair/machine baseline M1).
#  - THE 3-WAY METRIC (phase 1: data x pair-law; the BABY joins when the
#    NN G-3 lands): each party's swiRL SIGNATURE
#      sig = ( log(A),  (w* / w_max) ,  C ,  log(L_c) ,  P* ),
#    P* = the tropic's power fraction; pairwise Euclidean distances
#    d(real, pair) etc.  VALIDATION REQUIREMENT: the instrument must
#    reproduce the 0219 MARRIAGE SPLIT by itself - small d on L8 (lanes,
#    married) and large d on G24 (fine gap classes, deeper) - an entirely
#    different instrument from the H3 entropy test.
#
# Alphabets: L8 (lanes, 8 bins) and G24 (gap class mod 24, 12 bins) - the
# same two words as 0219, so the split is directly comparable.
# Scales: X = 2e6 / 1e7 / 1e8.  Pair-law party: 5 synthetic chains from the
# order-1 matrix fit at the same scale.  OFF-BOARD, no RH claim,
# single-threaded, 4 cores open.

import math, os, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom8_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
THB = 48          # theta bins on the circle
SB = 2000         # s grid length
NSIG = 5          # pair-law chains

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

SEGD = 200_000   # s-window (original symbols) for the field

def splat_field(w, A, sig_s):
    """True anisotropic footprint: the 2D field F(theta, s) = the separable
    2D Gaussian convolution of the symbol comb (one unit mass at
    (theta_i, s_i) per symbol) with K = outer(g_th, g_s), where
    sigma_s = sig_s ORIGINAL SYMBOLS (the median prime gap: stretched along
    the integer-progress axis) and sigma_th = THB/A bins (one circle symbol
    width: compact on the class circle). Computed in Sseg-length segments
    via FFT convolution. Returns (F, seg_offset)."""
    L = len(w)
    off = max(0, (L - SEGD) // 2)
    seg = w[off: off + SEGD]
    Ls = len(seg)
    sig_th = max(1.0, THB / A)
    # comb
    M = np.zeros((THB, Ls))
    th_bin = ((2 * np.pi / A) * seg / (2 * np.pi / THB)).astype(np.int64) % THB
    M[th_bin, np.arange(Ls)] = 1.0
    # kernels
    wgt = int(4 * sig_s) + 1
    ws = np.arange(-wgt, wgt + 1)
    gs = np.exp(-0.5 * (ws / sig_s) ** 2)
    ws2 = np.arange(-int(3 * sig_th), int(3 * sig_th) + 1)
    gt = np.exp(-0.5 * (ws2 / sig_th) ** 2)
    Kt = np.array([gt[(t + int(3 * sig_th)) % len(gt)] for t in range(THB)])
    # fft convolution (F = M * K)
    F = np.fft.rfft2(M, s=(THB, 2 * Ls))
    K = np.outer(Kt, gs)
    Kf = np.fft.rfft2(K, s=(THB, 2 * Ls))
    F = np.fft.irfft2(F * Kf, s=(THB, 2 * Ls))[:, :Ls]
    return F, off

def swirl_signature(F, A):
    Fz = F - F.mean()
    P = np.abs(np.fft.fftshift(np.fft.fft2(Fz))) ** 2
    # freq axes (fft2 of F with shape (THB, SB): row axis = theta, col = s)
    ks_raw = np.fft.fftshift(np.fft.fftfreq(SB, d=1.0))   # cycles / s-step
    kt_raw = np.fft.fftshift(np.fft.fftfreq(THB, d=1.0))  # cycles / theta-bin
    # fractional-Nyquist (unit-free, in (-1, 1]) grids
    KY = np.tile((ks_raw * 2.0)[None, :], (THB, 1))
    KX = np.tile((kt_raw * 2.0)[:, None], (1, SB))
    mask = (np.abs(KY) > 0.05) & (np.abs(KX) > 0.05)
    Pm = np.where(mask, P, 0.0)
    iy, ix = np.unravel_index(np.argmax(Pm), Pm.shape)
    kt_star_n = float(kt_raw[iy] * 2.0)     # normalized theta-freq
    ks_star_n = float(ks_raw[ix] * 2.0)     # normalized s-freq
    ks_star = float(ks_raw[ix])             # cycles per s-step (motor/C)
    Ptot = P.sum()
    Pstar = float(Pm[iy, ix]) / float(Ptot)
    # anisotropic aspect (unit-free): weighted 2nd moments
    mk_s = (Pm * KY ** 2).sum() / Pm.sum()
    mk_t = (Pm * KX ** 2).sum() / Pm.sum()
    aspect = mk_s / mk_t if mk_t > 0 else float("inf")
    # coherence in the rotating frame at the tropic frequency
    s = np.arange(SB)
    ph = np.exp(-2j * np.pi * ks_star * s / SB)
    proj = np.abs((Fz * ph).sum(axis=1))
    C = float(proj.max() / (np.abs(Fz).sum(axis=1).max() + 1e-12))
    # coherence length: decay of |sum over window| around the peak phase
    Fp = Fz * ph
    cum = np.cumsum(Fp, axis=1)
    win = np.abs(cum[:, ::8]).max(axis=0)
    # coherence length = where the partial sum first drops below C*|Ftot|/2
    Ft = np.abs(Fp.sum(axis=1)).max()
    if (win > 0.5 * Ft).any():
        half = int(np.argmax(win > 0.5 * Ft))
        Lc = float(half * 8)
    else:
        Lc = float(SB)
    return dict(aspect=float(aspect), kt=kt_star_n, ks=ks_star,
                Pstar=Pstar, C=C, Lc=Lc)

def fit_pair(w, A):
    P = np.ones((A, A))
    ab = w[:-1].astype(np.int64) * A + w[1:].astype(np.int64)
    P = P + np.bincount(ab, minlength=A * A).reshape(A, A).astype(float)
    return P / P.sum(axis=1)[:, None]

def gen_chain(P, n, seed):
    A = P.shape[0]
    rng = np.random.default_rng(seed)
    p0 = P.sum(axis=1); p0 = p0 / p0.sum()
    s = np.empty(n, dtype=np.int64)
    s[0] = int(rng.choice(A, p=p0))
    cum = np.cumsum(P, axis=1)
    u = rng.random(n - 1)
    for i in range(1, n):
        s[i] = int(np.searchsorted(cum[s[i - 1]], u[i - 1]))
    return s

def motor_fidelity(w, A, w_star, ntest=5000):
    """step the circle by the field's own spin w* (rad per s-step), map to
    the nearest bin, hit rate on the true next symbol."""
    step = float(w_star)
    # w_star is in cycles per s-step (fft freq); convert to rad
    step_rad = 2 * np.pi * step
    th = (2 * np.pi / A) * w.astype(float)
    ntest = min(ntest, len(w) - 2)
    hit = 0
    n = 0
    for i in range(len(w) - 1 - ntest, len(w) - 1):
        pred_th = (th[i] + step_rad) % (2 * np.pi)
        pred = int(round(pred_th / (2 * np.pi / A))) % A
        if pred == w[i + 1]:
            hit += 1
        n += 1
    return hit / n if n else float("nan")

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    out = []
    def rep(s=""):
        print(s); out.append(s)
    t0 = time.time()
    rep("LOOM G-4 (0221): THE ANISOTROPIC SWIRL MOTOR (OFF-BOARD, no RH claim)")
    rep("  splat sequence field F(theta, s); 2D-FFT tropic; spin points;")
    rep("  auto-self-phase coherence; own-spin regeneration motor;")
    rep("  3-way metric phase 1 (data x pair-law); must re-split 0219.")

    Xb = 100_000_000
    s8 = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if s8[i]], dtype=np.int64)
    rep(f"  sieve to {Xb}; primes={len(primes)}; {time.time()-t0:.1f}s")

    for X in (2_000_000, 10_000_000, 100_000_000):
        pX = primes[primes <= X]
        gaps = np.diff(pX); gaps = gaps[gaps % 2 == 0]
        g24 = (gaps % 24) // 2
        p5 = pX[pX >= 5]
        lane = np.searchsorted(LANES, p5 % 24)
        rep(f"\n{'='*70}\n  X = {X:,}\n{'='*70}")
        for name, w, A in (("L8 lanes", lane, 8), ("G24 gap class", g24, 12)):
            L = len(w)
            sig_s = float(np.median(gaps))   # original symbols: the streak
            rep(f"\n  {name}  (A={A}, L={L}, sigma_s={sig_s:.2f} symbols, "
                f"seg={SEGD})")
            F, off = splat_field(w, A, sig_s)
            sig = swirl_signature(F, A)
            cnt = np.bincount(w, minlength=A)
            om = 2 * np.pi * cnt / cnt.sum()
            seg = w[off: off + SEGD]
            mot = motor_fidelity(seg, A, sig["ks"], ntest=20000)
            rep(f"    TROPIC  (f-theta*, f-s*) = [{sig['kt']:+.3f}, {sig['kt']*0+sig['ks']*2:+.3f}] "
                f"(fraction of Nyquist)  raw w* = {sig['ks']:+.5f} cycles/s-step  "
                f"P* = {sig['Pstar']:.5f}")
            rep(f"    ANISO   aspect = {sig['aspect']:.4f}   "
                f"(>1 procession along the integers; <1 class swirl)")
            rep(f"    SPINS   omega_r (rad per s-step): "
                + " ".join(f"{o:.4f}" for o in om))
            rep(f"    COHERE  C = {sig['C']:.4f}   L_c = {sig['Lc']:.0f} s-steps")
            rep(f"    MOTOR   own-spin next-class fidelity = {mot:.4f}  "
                f"(pair M1 baseline ~0.22 lanes @1e7)")
            # pair-law party
            P = fit_pair(w, A)
            ps = []
            dpp = []
            for r in range(NSIG):
                wc = gen_chain(P, min(L, SEGD * 2), r)
                sc, offc = splat_field(wc, A, float(np.median(np.diff(wc[grep_gaps(wc, A)]))))
                pg = swirl_signature(sc, A)
                pg["ks"] = pg["ks"]
                ps.append(pg)
            def sigvec(d):
                return np.array([math.log(max(d["aspect"], 1e-9)),
                                 d["ks"], d["C"], math.log(max(d["Lc"], 1.0)),
                                 d["Pstar"]])
            vreal = sigvec(sig)
            dmean = np.mean([np.linalg.norm(vreal - sigvec(d)) for d in ps])
            rep(f"    METRIC  d(data, pair-law) = {dmean:.5f}  "
                f"(L8 must be SMALL/married, G24 LARGE/deeper per 0219)")

    rep(f"\n== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
