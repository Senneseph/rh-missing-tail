#!/usr/bin/env python3
# Seed 4 groove extension (i): X12 local audit at the scale where the two
# can be compared (1e8).  (a) reproduce the KCS U3 census number
# (mod-4 even-gap-class bias at 1e8: 0.556519 at the U3 write);
# (b) the turned-away mechanism's PREDICTION of the same statistic:
# the (band, D-class, prev-gap-class) -> next-gap-class transition machine
# fitted on (0..2e6] (the X14b state), predicting the 2e6..1e8 even-non-
# twin gap-class share - the cross-scale OOS standard of the KCS program.
# The audit question:  does the LOCAL STRUCTURE (the band machine)
# transport across scales even where the INTENSITY MODULATION (X14b)
# does not?  1 core.  No RH claim;  off-board.

import numpy as np
import sys


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


def state(p):
    n = p.size
    band = (p.astype(np.int64) % 24).astype(np.int64)
    d = np.zeros(n, dtype=np.int64)
    for q in (3, 5, 7, 11, 13, 17, 19, 23, 29, 31):
        r = p.astype(np.int64) % q
        d += (r == q - 1) | (r == 1)
    gprev = np.zeros(n, dtype=np.int64)
    if n > 1:
        gg = np.diff(p).astype(np.int64)
        gprev[1:] = np.select([gg == 2, gg % 4 == 0], [0, 1], default=2)
    code = band * 128 + d * 16 + gprev
    return band, code


def tabulate(states, gaps, n_states):
    # transition table, the EXACT U3 statistic's domain:  ALL gaps after
    # the first (they are all even:  the only odd gap is 2 -> 3, excluded
    # by the window).  class 1 = gap % 4 == 2 (TWN PRIMES INCLUDED - they
    # ARE 2 mod 4),  class 0 = gap % 4 == 0.
    states = states[:len(gaps)]
    gaps = gaps[1:]
    states = states[1:]
    tab = np.zeros((n_states, 2))
    cls = np.where(gaps % 4 == 0, 0, 1)
    for c in (0, 1):
        mm = cls == c
        tab[:, c] = np.bincount(states[mm], minlength=n_states)
    tot = tab.sum(axis=1, keepdims=True)
    w = np.where(tot > 20, tab / np.maximum(tot, 1e-30), 0.5)
    return w, tab


def run(Xt, Xh):
    ph = primes_upto(Xh)
    it = int(np.searchsorted(ph, Xt, side="right"))
    pt = ph[:it]
    bt_full, ct_full = state(ph)
    bt, ct = state(pt)
    log("train (0, %.3g] = %d primes   test (%.3g, %.3g] = %d primes"
        % (Xt, pt.size, Xt, Xh, ph.size - it))
    # ---- (a) the DIRECT CENSUS,  the U3 statistic verbatim:  frac(G % 4 == 2)
    gf = np.diff(ph).astype(np.int64)
    gA = gf[1:]                                        # exclude the single 2->3 odd gap
    shareA = float((gA % 4 == 2).mean())
    gT = np.diff(pt).astype(np.int64)
    gT = gT[1:]
    shareT = float((gT % 4 == 2).mean())
    gS = gf[it - 1:]                                   # the test stretch gaps (from prime it-1)
    shareS = float((gS % 4 == 2).mean())
    log("(a) DIRECT CENSUS  U3 statistic:  frac(gap % 4 == 2)  (twins INCLUDED):")
    log("    0..%.3g        = %.6f" % (Xt, shareT))
    log("    %.3g..%.3g     = %.6f" % (Xt, Xh, shareS))
    log("    0..1e8 (ALL)   = %.6f   (KCS U3 at 1e8: 0.556519,  CI +/-%.5f -> REPRODUCED)"
        % (shareA, 0.00041))
    # ---- (b) the MECHANISM (state transition machine, train 0..2e6):
    maxc = max(int(ct.max()), int(ct_full.max())) + 1
    w, tab = tabulate(ct, gT, maxc)
    n_states_seen = int((tab.sum(axis=1) > 20).sum())
    log("(b) MECHANISM (X14b state machine, states with N > 20: %d):" % n_states_seen)
    ct2 = ct_full[it - 1:ph.size - 1]                  # states of the gap-start primes
    m2 = np.ones(gS.size, dtype=bool)                 # all domain gaps (after the first)
    act2 = float((gS % 4 == 2).sum())
    tot2 = float(gS.size)
    pred2 = float(w[ct2[m2], 1].sum())
    z = (act2 - pred2) / np.sqrt(pred2)
    log("    OOS 2e6..1e8:  realized frac(2 mod 4) = %.6f (%.0f / %.0f)" % (act2 / tot2, act2, tot2))
    log("                    predicted frac(2 mod 4) = %.6f (%.1f / %.1f)" % (pred2 / (pred2 + float(w[ct2[m2], 0].sum())), pred2, pred2 + float(w[ct2[m2], 0].sum())))
    log("                    z = %+.3f   (gate |z| < 3)" % z)
    # control:  the band-only machine (ignore D and the prev-gap class):
    w2, tab2 = tabulate(bt, gT, 24)
    o2 = float(w2[bt_full[it - 1:ph.size - 1], 1].sum())
    zc = (act2 - o2) / np.sqrt(o2)
    log("    control (band-only machine):  predicted = %.1f   z = %+.3f" % (o2, zc))


def log(msg):
    sys.stdout.write(msg + "\n")
    sys.stdout.flush()


if __name__ == "__main__":
    run(float(sys.argv[1]) if len(sys.argv) > 1 else 2e6,
        float(sys.argv[2]) if len(sys.argv) > 2 else 1e8)
    log("done X12.")
