#!/usr/bin/env python3
# LOOM G-4b (0221, anchored): THE PARITY-ANCHORED ANISOTROPIC SWIRL TAPE.
#
# The owner's anchor (this turn): "add in coin-flipping with even/odd as a
# fixed probability of being prime past 2. this is an anchor. that 50% must
# live somewhere in the randomness or order of the system we're building."
#
# Layer-0 (fixed, NOT random): past 2 the integers alternate even:odd in a
# perfect period-2 ORDER. Every prime past 2 is odd; the 50% even-half is
# dead. This fixed parity coin is the ANCHOR: the reference substrate on
# which the genuine randomness (which odd numbers are prime) sits.
#   - it must be VISIBLE: the x-lattice is 1 integer per pixel (v1's 4-wide
#     bins ate the parity, so this file re-lattices at integer resolution);
#   - it is the SHARED DENOMINATOR of the metric: real and pair-law tapes
#     both sit on the same 50/50 substrate, so the anchor cancels in the
#     distance; the metric measures structure ABOVE the fixed 50%;
#   - it is a FAITHFULNESS test: a synthetic world must land 100% of its
#     prime mass on the odd class with a ~50% odd substrate or it has
#     floated off its anchor.
#
# The tape (one 2D integer lattice):
#   x-axis  = absolute integer position, 1 integer / x-pixel (parity visible)
#   theta   = the 24-circle in THB bins
# Each prime in the window drops an ANISOTROPIC streak: a separable 2D
# Gaussian, sigma_x = the window's median prime gap (stretched along the
# integer-progress axis = the swirl's streak) and sigma_th = one circle-
# symbol width (compact on the class circle). sigma_x/sigma_th grows with X
# (median gap ~ ln X): the swirl literally stretches as the integers march
# through the 24-adics.
#
# Per (source, X) we measure:
#   ANCHOR   odd-substrate fraction (expect ~0.5), prime-mass-on-odd (expect
#            1.0 = anchor holds), conditional prime density given the anchor.
#   TROPIC   argmax of the 2D power (excl. DC): where the detail is + how
#            fast the swirl turns (the spin point).
#   ASPECT   unit-free power anisotropy (>>1 procession, <<1 class swirl).
#   SPINS    omega_r = 2*pi*count_r/W_int (rad per integer): how fast the
#            integers pass class r.
#   COHERENCE= the field's own-spin phase-locked component C + length L_c
#            (the auto-self-phase connection).
#   MOTOR    own-spin regeneration: step the circle by its own w*, predict
#            the next class; fidelity vs the M1 pair baseline (~0.22 lanes).
#   METRIC   signature distance; d(data, pair) and d(pair, pair) (noise
#            floor); must re-split 0219 (L8 small/married, G24 large).
#
# Pair-law party = the full classical walk: next class ~ the measured
# order-1 pair matrix, gap length ~ the measured length|class resample
# (0196/LO: a class bias times a length law). Even gaps preserve parity, so
# the walk stays on its anchor - we verify it lands 100% odd.
#
# OFF-BOARD; no RH claim; single-threaded; 4 cores open.

import math, os, time
import numpy as np

ROOT = "/home/jsmille/Projects/rh-missing-tail"
OUT = ROOT + "/tmp/loom/loom8b_out.txt"
LANES = np.array([1, 5, 7, 11, 13, 17, 19, 23])
THB = 48
SSEG = 10_000   # primes per window
NSIG = 5

def sieve(n):
    s = bytearray(b"\x01") * (n + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(math.isqrt(n)) + 1):
        if s[i]:
            s[i*i::i] = bytearray(len(range(i*i, n + 1, i)))
    return s

def anchor_report(abs_lo, Wx, prime_px):
    """Layer-0 parity anchor: the fixed 50/50 even:odd substrate past 2."""
    abs_int = abs_lo + np.arange(Wx)
    par = abs_int & 1
    odd_frac = float(par.mean())
    M = np.zeros(Wx)
    M[prime_px % Wx] += 1.0
    tot = float(M.sum()) or 1.0
    mass_odd = float(M[par == 1].sum()) / tot
    n_odd = int(par.sum())
    cond = float(M.sum()) / n_odd if n_odd else float("nan")
    return odd_frac, mass_odd, cond

def tape_field(xs, thcls, A, Wx, sig_x, sig_th):
    M = np.zeros((THB, Wx))
    tb = ((2 * np.pi / A) * thcls / (2 * np.pi / THB)).astype(np.int64) % THB
    xs = (xs % Wx)
    M[tb, xs] += 1.0
    wgt = max(1, int(4 * sig_x) + 1)
    ws = np.arange(-wgt, wgt + 1)
    gx = np.exp(-0.5 * (ws / sig_x) ** 2)
    wgt2 = max(1, int(3 * sig_th) + 1)
    w2 = np.arange(-wgt2, wgt2 + 1)
    gt = np.exp(-0.5 * (w2 / sig_th) ** 2)
    Kt = np.array([gt[(t + wgt2) % len(gt)] for t in range(THB)])
    F = np.fft.rfft2(M, s=(THB, 2 * Wx))
    K = np.outer(Kt, gx)
    F = np.fft.irfft2(F * np.fft.rfft2(K, s=(THB, 2 * Wx)), s=(THB, 2 * Wx))[:, :Wx]
    return F

def swirl_signature(F):
    Fz = F - F.mean()
    P = np.abs(np.fft.fftshift(np.fft.fft2(Fz))) ** 2
    Wx = F.shape[1]
    ks_raw = np.fft.fftshift(np.fft.fftfreq(Wx, d=1.0))   # cycles / integer
    kt_raw = np.fft.fftshift(np.fft.fftfreq(THB, d=1.0))  # cycles / bin
    KY = np.tile((ks_raw * 2.0)[None, :], (THB, 1))
    KX = np.tile((kt_raw * 2.0)[:, None], (1, Wx))
    mask = (np.abs(KY) > 0.02) & (np.abs(KX) > 0.02)
    Pm = np.where(mask, P, 0.0)
    iy, ix = np.unravel_index(np.argmax(Pm), Pm.shape)
    Pstar = float(Pm[iy, ix]) / float(P.sum())
    mk_s = (Pm * KY ** 2).sum() / Pm.sum()
    mk_t = (Pm * KX ** 2).sum() / Pm.sum()
    aspect = mk_s / mk_t if mk_t > 0 else float("inf")
    wstar = float(ks_raw[ix])                    # cycles / integer
    s = np.arange(Wx)
    Fp = Fz * np.exp(-2j * np.pi * wstar * s)[None, :]
    C = float(np.abs(Fp.sum(axis=1)).max() /
              max(float(np.abs(Fz).sum(axis=1).max()), 1e-12))
    Ft = np.abs(Fp.sum(axis=1)).max()
    cum = np.abs(np.cumsum(Fp, axis=1))[:, ::16]
    Lc = float(Wx) if (cum.max(axis=0) > 0.5 * Ft).all() else \
        float(int(np.argmax(cum.max(axis=0) > 0.5 * Ft)) * 16)
    return dict(aspect=float(aspect), kt=float(kt_raw[iy] * 2.0),
                ks=wstar, Pstar=Pstar, C=C, Lc=Lc)

def sigvec(d):
    return np.array([math.log(max(min(d["aspect"], 1e6), 1e-9)),
                     d["ks"], d["C"], math.log(max(d["Lc"], 1.0)), d["Pstar"]])

def motor_fidelity(w, A, step_cycles_per_symbol, ntest=20000):
    """step the circle by the field's own spin (per symbol); next-class hit."""
    th = (2 * np.pi / A) * w.astype(float)
    ntest = min(ntest, len(w) - 2)
    if ntest <= 0:
        return float("nan")
    step_rad = 2 * np.pi * step_cycles_per_symbol
    hit = 0
    for i in range(len(w) - 1 - ntest, len(w) - 1):
        pred = int(round(((th[i] + step_rad) % (2 * np.pi)) /
                         (2 * np.pi / A))) % A
        hit += (pred == w[i + 1])
    return hit / ntest

def main():
    os.makedirs(ROOT + "/tmp/loom", exist_ok=True)
    out = []
    def rep(s=""):
        print(s); out.append(s)
    t0 = time.time()
    rep("LOOM G-4b (0221, anchored): PARITY-ANCHORED ANISOTROPIC SWIRL TAPE")
    rep("(OFF-BOARD, no RH claim)")
    rep("  Layer-0 = the fixed even:odd parity coin past 2 (50% anchor, a")
    rep("  period-2 ORDER, not random) = the shared denominator of the metric.")
    rep("  Must re-split 0219: L8 d(data,pair) small/married, G24 large/deeper.")

    Xb = 100_000_000
    s8 = sieve(Xb)
    primes = np.array([i for i in range(2, Xb + 1) if s8[i]], dtype=np.int64)
    rep(f"  sieve to {Xb}; primes={len(primes)}; {time.time()-t0:.1f}s")

    for X in (2_000_000, 10_000_000, 100_000_000):
        pX = primes[primes <= X]
        iwin = max(0, len(pX) - SSEG)
        win = pX[iwin: iwin + SSEG]
        if len(win) < SSEG:
            win = pX[-SSEG:]
        gaps = np.diff(win)
        W_int = int(win[-1] - win[0]) + 1
        rep(f"\n{'='*74}\n  X = {X:,}   window = primes {win[0]}..{win[-1]} "
            f"({len(win)} primes, span {W_int} integers, 1 int/px)\n{'='*74}")

        for name, thcls, A, cls_kind in (
                ("L8 lanes (next-prime lane)",
                 np.searchsorted(LANES, win[1:] % 24), 8, "next"),
                ("G24 gap class", (gaps % 24) // 2, 12, "gap")):
            xs = (win[1:] - win[0]).astype(np.int64)
            med = float(np.median(gaps))
            sig_x = max(1.0, med)
            sig_th = max(1.0, THB / A)
            F = tape_field(xs, thcls, A, Wx := W_int, sig_x, sig_th)
            sig = swirl_signature(F)
            cnt = np.bincount(thcls, minlength=A)
            om = 2 * np.pi * cnt / W_int
            step_per_sym = sig["ks"] * med       # cycles per symbol
            mot = motor_fidelity(thcls, A, step_per_sym)
            ofrac, m_odd, cond = anchor_report(win[0], W_int, xs)
            rep(f"\n  {name}  (A={A}, sigma_x={sig_x:.1f} int, "
                f"sigma_th={sig_th:.0f} bins)")
            rep(f"    ANCHOR  odd-substrate = {ofrac:.5f}   "
                f"mass-on-odd = {m_odd:.5f}   cond-density = {cond:.3e}/odd-int")
            rep(f"    TROPIC  (f-theta*, f-x*) = [{sig['kt']:+.3f}, "
                f"{sig['ks']*2:+.3f}]  w* = {sig['ks']:+.3e} cyc/int  "
                f"P* = {sig['Pstar']:.5f}")
            rep(f"    ASPECT  (power) = {sig['aspect']:.4f}   "
                f"| footprint sigma_x/sigma_th = {sig_x/sig_th:.2f}")
            rep(f"    SPINS   omega_r rad/int: "
                + " ".join(f"{o:.5f}" for o in om))
            rep(f"    COHERE  C = {sig['C']:.4f}   L_c = {sig['Lc']:.0f} px "
                f"(= {sig['Lc']:.0f} int)")
            rep(f"    MOTOR   own-spin next-class fidelity = {mot:.4f}")

            # ---- pair-law party (class ~ pair matrix, length ~ len|class)
            P = np.ones((A, A))
            n = len(thcls)
            ab = thcls[:-1].astype(np.int64) * A + thcls[1:].astype(np.int64)
            P = P + np.bincount(ab, minlength=A * A).reshape(A, A).astype(float)
            P = P / P.sum(axis=1)[:, None]
            lens = {c: np.array([]) for c in range(A)}
            for c in range(A):
                if cls_kind == "gap":
                    lens[c] = gaps[(gaps % 24) // 2 == c]
                else:
                    lens[c] = gaps[np.searchsorted(LANES, win[1:] % 24) == c]
                if lens[c].size == 0 or c == A - 1 and False:
                    lens[c] = np.ones_like(gaps, dtype=np.int64) * 2
            psigs, pmass = [], 0.0
            for r in range(NSIG):
                rng = np.random.default_rng(100 + r)
                c = int(rng.choice(A))
                pos = 0; seq_c = [c]; seq_p = [0]
                while pos < W_int - 4:
                    c = int(rng.choice(A, p=P[c]))
                    g = int(rng.choice(lens[c])) if lens[c].size else 2
                    if g < 2:
                        g = 2
                    pos += g
                    seq_c.append(c); seq_p.append(pos)
                seq_c = np.array(seq_c); seq_p = np.array(seq_p)
                m = seq_p < W_int
                wc, wp = seq_c[m], seq_p[m]
                Fc = tape_field(wp, wc, A, W_int, sig_x, sig_th)
                psigs.append(swirl_signature(Fc))
                pmass += anchor_report(win[0], W_int, wp)[1]
            vreal = sigvec(sig)
            ds = [float(np.linalg.norm(vreal - sigvec(d))) for d in psigs]
            dpp = [float(np.linalg.norm(sigvec(psigs[i]) - sigvec(psigs[j])))
                   for i in range(NSIG) for j in range(i + 1, NSIG)]
            ratio = np.mean(ds) / max(np.mean(dpp), 1e-9)
            rep(f"    PAIR    mean mass-on-odd = {pmass/NSIG:.5f} "
                f"(anchor must hold)")
            rep(f"    METRIC  d(data, pair) = {np.mean(ds):.5f} +/- {np.std(ds):.5f}"
                f"   |  d(pair,pair) floor = {np.mean(dpp):.5f}")
            rep(f"    SPLIT   d(data,pair)/d(pair,pair) = {ratio:.2f}  "
                f"[{'CLEARED >1.5' if ratio > 1.5 else 'weak'}]")

    rep(f"\n== done in {time.time()-t0:.1f}s ==")
    with open(OUT, "w") as f:
        f.write("\n".join(out) + "\n")

if __name__ == "__main__":
    main()
