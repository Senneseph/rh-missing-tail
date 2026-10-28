#!/usr/bin/env python3
# Seed 4 groove extension (iii): the D-score curve BEYOND q = 31, toward the
# singular-series limit.  X13 measured the twin share as a function of
# D(p) = #{q : p = +-1 mod q} with Q = the 10 lines 3..31, at 1e8, and the
# X8 saturation curve (twin-blocker AUC) grew with the line set up to
# q = 31.  Here:  Q extended to the primes <= 43 (13 lines: 3, 5, 7, 11,
# 13, 17, 19, 23, 29, 31, 37, 41, 43) - the twin share by D-class, the
# D-class distribution, and the twin-share curve read against the
# singular-series weights (the Hardy-Littlewood per-line factor
# 1 - 1/(q-1)^2 ... read off through the blocking structure:  a prime p
# in the -2 class of line q cannot be the lower twin unless q divides 2,
# so the D-class counts how many lines 'reach' the twin slot at +-1).
# The curve should keep rising with the line set if the structure is the
# singular series in its own clothes.  1 core.  No RH claim; off-board.

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


def run(X):
    X = int(X)
    p = primes_upto(X)
    n = p.size
    g = np.diff(p)
    is_twin = g == 2                          # g[i] = p[i+1] - p[i]
    nt = int(is_twin.sum())
    log("primes < %d: %d   twins: %d   twin share (all) = %.6f" % (X, n, nt, nt / (n - 1)))
    for Qmax in (31, 43):
        Q = [q for q in (3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43) if q <= Qmax]
        d = np.zeros(n - 1, dtype=np.int64)   # D of p[i] (i < n-1: has a next prime)
        for q in Q:
            r = p[:-1].astype(np.int64) % q
            d += (r == q - 1) | (r == 1)
        maxd = int(d.max())
        log("--- Q = primes <= %d  (%d lines) ---" % (Qmax, len(Q)))
        log("    D-class distribution: " + "  ".join(
            "D=%d:%.5f" % (k, (d == k).mean()) for k in range(min(maxd + 1, 21))))
        row = []
        for k in range(1, min(maxd, 10) + 1):
            mk = d == k
            if mk.sum() < 100:
                break
            share = is_twin[mk].mean()
            row.append((k, int(mk.sum()), share))
        log("    twin share by D-class (N >= 100):")
        for k, Nk, share in row:
            log("      D = %2d:  N = %7d   twin share = %.6f   (vs all: %+.4f)"
                % (k, Nk, share, share - nt / (n - 1)))
    # the singular-series anchor: the twin-prime singular series
    #    prod_{p>2} (1 - 1/(p-1)^2) = 0.6601618...
    # and its PARTIAL products over the lines:  the product of the
    # per-line 'twin retention' factor (p-1)^2/(p^2-1) read on the p-1
    # grid = (1 - 1/(p(p-1)))...  the classical factor is (1 - 1/(q-1)^2);
    # the D-class curve is the empirical side of the same object.
    from math import prod
    part = []
    w = 1.0
    for q in (3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43):
        w *= 1.0 - 1.0 / (q - 1) ** 2
        part.append((q, w))
    log("singular series partial products (twin prime constant build):")
    for q, w in part:
        log("    lines <= %2d:  S_q = %.7f" % (q, w))
    log("    (full limit = 0.66016181584686957392...)")


def log(msg):
    sys.stdout.write(msg + "\n")
    sys.stdout.flush()


if __name__ == "__main__":
    X = float(sys.argv[1]) if len(sys.argv) > 1 else 1e8
    run(X)
    log("done D-score extension.")
