#!/usr/bin/env python3
# Seed 4 / groove extension X14b (2026-10-28): the POINT-PROCESS intensity
# fit.  The prime stream is modeled as a state-modulated Cramer process:
#
#     lam(t, s) = w(s) / ln(t),      s = (band, Dclass, gapclass) of p(t)
#
# with band = p mod 24 (the coprime letter), Dclass = D(p) = #{q in Q :
# p = +1 or -1 mod q} (the groove X13 distance-one score, Q = the 10 lines
# 3..31), gapclass = the previous gap in {2, even, odd>=3? no: prev gap
# {==2, ==4, >=6}}.  The w(s) weights are the MLE on the TRAIN stretch
# (0..Xt):  N_s / T_s with T_s = sum (p_i+1 - p_i)/ln(p_i) over the primes
# whose state is s.  THE TESTS:
#   (i)   the compensated count M(t) = N(t) - integral lam  on TRAIN:
#         final standardized M/sqrt(Lam) ~ N(0,1);  increment
#         skewness/kurtosis ~ (0, 0) for a perfect exponential model;
#         lag-1 increment autocorrelation ~ 0.
#   (ii)  CROSS-SCALE OOS:  integrate the TRAINED w(s) along the test
#         stretch (Xt..Xh) state path -> predicted count;  z =
#         (N_act - N_pred)/sqrt(N_pred);  gate |z| < 3.
#   (iii) the w(s) table itself:  which states run rich/lean above the
#         mean-one Cramer line, in-sample vs OOS-consistent.
# No RH claim.  Off-board.  1 core.

import numpy as np
import sys

Q = np.array([3, 5, 7, 11, 13, 17, 19, 23, 29, 31])


def primes_upto(X):
    X = int(X)
    sieve = np.ones(X // 2 + 1, dtype=bool)
    sieve[0] = False
    lim = int(np.sqrt(X))
    for f in range(3, lim + 1, 2):
        if sieve[f // 2]:
            sieve[f * f // 2::f] = False
    out = np.empty(2 * (sieve[1:].sum() + 1), dtype=np.float64)
    even = np.nonzero(sieve[1:])[0] * 2 + 3
    out[:1] = 2.0
    out[1:1 + len(even)] = even
    return out[:1 + len(even)].copy()


def states(p):
    # per-prime state codes (p[0..n-2]: p[i+1] is the next prime; the last
    # prime's state is unused for gaps but used for its occurrence cell)
    n = p.size
    band = (p.astype(np.int64) % 24).astype(np.int64)
    # Dclass: count of q with p = +-1 mod q
    d = np.zeros(n, dtype=np.int64)
    for q in Q:
        r = p.astype(np.int64) % q
        d += ((r == q - 1) | (r == 1))
    # gapclass of the PREVIOUS gap: p[i] - p[i-1]  (0 for i=0)
    gprev = np.zeros(n, dtype=np.int64)
    if n > 1:
        gg = np.diff(p).astype(np.int64)
        gprev[1:] = np.select([gg == 2, gg == 4], [0, 1], default=2)
    code = band * 128 + d * 16 + gprev            # base-16 packing (D <= 10 fits)
    return band, d, gprev, code


def run(Xt, Xh):
    ph = primes_upto(Xh)
    it = int(np.searchsorted(ph, Xt, side="right"))
    pt = ph[:it]
    log("train (0, %.3g]: %d primes   test (%.3g, %.3g]: %d primes"
        % (Xt, pt.size, Xt, Xh, ph.size - it))

    bt, dt, gt, ct = states(pt)
    bh, dh, gh, ch = states(ph)
    ct = ct[:-1].astype(np.int64)                      # occurrence cells need a next prime
    bt = bt[:-1]; dt = dt[:-1]; gt = gt[:-1]                   # keep the state rows aligned
    # ---- (iii)-fit: the MLE weights on TRAIN
    ln = np.log(pt[:-1])
    gap = np.diff(pt)
    T = gap / ln                                     # per-cell time measure
    bh2, dh2, gh2, ch2 = bh, dh, gh, ch
    maxc = max(int(ct.max()), int(ch.max())) + 1
    cs = np.unique(ct)
    w = np.zeros(maxc)
    Ns = np.bincount(ct, minlength=maxc)
    Ts = np.bincount(ct, weights=T, minlength=maxc)
    for c in cs:
        w[c] = Ns[c] / Ts[c]
    wmean = Ts.sum() * w[cs].mean() / Ts.sum()       # ~1 if the model is right
    n_states = len(cs)
    log("states seen on train: %d   mean w over seen states: %.4f" % (n_states, w[cs].mean()))
    # ---- (i): the compensated count on TRAIN (the state changes only at primes;
    # within a cell the intensity integrates to w(s)/ln ~ w(s) * (gap)/ln)
    lam_cell = w[ct] * T                             # integral of lam over each cell
    M = np.cumsum(1.0 - lam_cell)                    # at prime times (jumps of 1)
    Lam = np.cumsum(lam_cell)
    # the Poisson MLE identity: final M is 0 BY CONSTRUCTION (N_s/T_s exactly
    # fits the total) - report it as such, then test the SHAPE:
    zT = M[-1] / np.sqrt(lam_cell.sum())
    log("(i) TRAIN compensated count:  M_final/sqrt(Lam) = %+.5f (0 by MLE construction)" % zT)
    # path: max self-normalized excursion across the run
    path_sup = float(np.abs(M[:-1] / np.sqrt(Lam[:-1])).max()) if M.size > 2 else 0.0
    # binned chi-square (20 equal-TIME bins): observed vs model-expected
    nb = 20
    cuts = np.searchsorted(pt, np.linspace(pt[1], pt[-1] - 1e-9, nb + 1)[1:-1])
    obs = np.diff(np.concatenate([[0], cuts, [pt.size - 1]]))
    expb = np.zeros(nb)
    for b2 in range(nb):
        lo, hi = (0 if b2 == 0 else cuts[b2 - 1]), cuts[b2] if b2 < nb - 1 else pt.size - 1
        expb[b2] = lam_cell[lo:hi].sum()
    chi2 = float(((obs - expb) ** 2 / np.maximum(expb, 1e-12)).sum())
    ndof = nb - 3                                     # 3 parameters absorbed by the MLE
    log("    path sup |M|/sqrt(Lam(t)) = %.3f   binned chi2 = %.2f / %d dof (dof-1 chi2 ~ 1)"
        % (path_sup, chi2, ndof))
    inc = 1.0 - lam_cell[1:]
    m, sd = inc.mean(), inc.std()
    skew = ((inc - m) ** 3).mean() / sd ** 3
    kurt = ((inc - m) ** 4).mean() / sd ** 4 - 3
    ac1 = np.corrcoef(inc[:-1], inc[1:])[0, 1]
    log("    increment skew = %+.4f (exp ideal: +2)   excess kurtosis = %+.4f (exp: +6)   lag-1 ac = %+.4f"
        % (skew, kurt, ac1))
    # the skew deficit (+2 -> -1.8) quantifies the NON-POISSON shape:  many
    # small increments (twins / small gaps) and a truncated heavy tail.
    # ---- (ii): CROSS-SCALE OOS with the TRAINED weights
    # cells in the test stretch: i from it-1 (the last train prime starts the
    # first test cell) to ph.size-2;  lnh = ln of the STARTING prime of each cell
    lnh = np.log(ph[it - 1:ph.size - 1])
    i0, i1 = it - 1, ph.size - 2
    bseg, dseg, gseg = bh[i0:i1 + 1], dh[i0:i1 + 1], gh[i0:i1 + 1]
    cseg = (bseg * 128 + dseg * 16 + gseg).astype(np.int64)
    unseen = (w[cseg] == 0)
    log("OOS cells with states unseen on train: %d / %d (%.2f%%) -> weight 1"
        % (int(unseen.sum()), cseg.size, 100 * unseen.mean()))
    wo = np.where(w[cseg] > 0, w[cseg], 1.0)
    gap_h = np.diff(ph[i0:i1 + 2])
    lam_h = wo * gap_h / lnh
    N_act = ph.size - it
    N_pred = lam_h.sum()
    zOOS = (N_act - N_pred) / np.sqrt(N_pred)
    log("(ii) OOS:  N_act = %d   N_pred = %.1f   z = %+.3f   (gate |z| < 3)" % (N_act, N_pred, zOOS))
    # the SAME stretch with w = 1 (plain Cramer):
    cr = (gap_h / lnh).sum()
    z_cramer = (N_act - cr) / np.sqrt(cr)
    log("    control (plain Cramer, w=1):  z = %+.3f" % z_cramer)
    # ---- (ii-b): LOCAL OOS (the KCS OOS standard, transplanted):  fit w(s)
    # on the NEAR decade (2e6, 2.5e7] of the test stretch, predict the FAR
    # decade half (5e7, 1e8] - is the modulation stationary AT ALL on the
    # 2e6..1e8 scale?
    j25 = int(np.searchsorted(ph, 2.5e7, side="right"))
    j50 = int(np.searchsorted(ph, 5.0e7, side="right"))
    lnj = np.log(ph[1:j25])
    gapj = np.diff(ph[:j25])
    ctrain = (bh[1:j25] * 128 + dh[1:j25] * 16 + gh[1:j25]).astype(np.int64)
    Tj = gapj / lnj
    Nsj = np.bincount(ctrain, minlength=maxc)
    Tsjs = np.bincount(ctrain, weights=Tj, minlength=maxc)
    wj = np.where(Tsjs > 0, Nsj / np.maximum(Tsjs, 1e-30), 0.0)
    i0l, i1l = j50 - 1, ph.size - 2
    segl = (bh[i0l:i1l + 1] * 128 + dh[i0l:i1l + 1] * 16 + gh[i0l:i1l + 1]).astype(np.int64)
    wo2 = np.where(wj[segl] > 0, wj[segl], 1.0)
    gapl = np.diff(ph[i0l:i1l + 2])
    lnl = np.log(ph[i0l:i1l + 1])
    N_act2 = ph.size - j50
    N_pred2 = (wogl := wo2 * gapl / lnl).sum()
    z_local = (N_act2 - N_pred2) / np.sqrt(N_pred2)
    crl = (gapl / lnl).sum()
    z_local_cr = (N_act2 - crl) / np.sqrt(crl)
    log("(ii-b) LOCAL OOS (fit 2e6..2.5e7 -> predict 5e7..1e8):  z = %+.3f  (plain Cramer control: %+.3f)"
        % (z_local, z_local_cr))
    # ---- the w(s) table (train):  top/bottom of the seen states
    rows = []
    for c in cs:
        if Ns[c] < 50:
            continue
        b, dd, gg = c // 128, (c % 128) // 16, c % 16
        rows.append((w[c], Ns[c], b, dd, gg))
    rows.sort(key=lambda r: -r[0])
    log("(iii) w(s) table (w, N, band, D, gapclass), top 12 / bottom 12 of %d (N>=50):"
        % len(rows))
    for r in rows[:12]:
        log("    w = %+.4f   N = %6d   band = %2d  D = %d  gclass = %d" % r)
    log("    ...")
    for r in rows[-12:]:
        log("    w = %+.4f   N = %6d   band = %2d  D = %d  gclass = %d" % r)


def log(msg):
    sys.stdout.write(msg + "\n")
    sys.stdout.flush()


if __name__ == "__main__":
    Xt = float(sys.argv[1]) if len(sys.argv) > 1 else 2e6
    Xh = float(sys.argv[2]) if len(sys.argv) > 2 else 1e8
    run(Xt, Xh)
    log("done X14b.")
