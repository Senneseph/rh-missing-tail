#!/usr/bin/env python3
"""kcs3c_c: U3c (c) - check the LOS paper's r = 2, q = 4 data rows
(arXiv:1603.03720v4, Lemke Oliver & Soundararajan, PNAS 2016,
Section 5 'Comparison of the conjecture with numerical data') against
AN INDEPENDENT exact pair-class count.

Provenance: the paper PDF is persisted at
    tmp/u3c_c_fig/paper.pdf   (curl from arxiv.org/pdf/1603.03720v4,
                              identity-checked: 'UNEXPECTED BIASES IN
                              THE DISTRIBUTION OF CONSECUTIVE PRIMES'
                              present in tmp/u3c_c_fig/paper.txt)
The paper's Section 5 comparison table (verbatim from paper.txt):

    x        pi(x;3,(1,1)) pi(x;3,(1,2)) pi(x;4,(1,1)) pi(x;4,(1,3))
    Actual  1e9   1.132e7     1.411e7       1.141e7       1.401e7
            1e10  1.024e8     1.251e8       1.032e8       1.244e8
            1e11  9.347e8     1.124e9       9.412e8       1.118e9
            1e12  8.600e9     1.020e10      8.654e9       1.015e10

Definitions: the paper's pi(x; q, (a, b)) = #{ p_n <= x : p_n == a
(mod q), p_{n+1} == b (mod q) } - p_n runs over REDUCED classes
(odd primes; p_1 = 2 is excluded), and the successor p_{n+1} is NOT
restricted to <= x (it is simply the next prime; we sieve to x +
margin to see it exactly).

This script (Step 1, global byte sieve, x + margin <= ~1.001e11):
   - counts all four ordered mod-4 classes exactly,
   - reports agreement with the paper's rows at the published
     precision (4 significant figures; tolerance = half a unit in
     the last published figure),
   - forms the off-diagonal fraction under BOTH conventions:
       paper convention: (pi13 + pi31) / (number of odd primes <= x)
       record 'meas' convention (kcs3c_resid_law_1e10): the fraction
         of GAPS between consecutive primes both <= x that are
         2 (mod 4) - includes the (2,3) gap as 'off-diagonal',
     and cross-checks the latter against the recorded meas rows.

No RH claim: the paper's Main Conjecture is a conjecture; this unit
cross-checks only the paper's DATA rows (their primesieve C++ counts)
against an independent exact sieve.  Flank provenance work.

Cost: ~5 s at 1e9, ~30-60 s at 1e10, memory <= 16 GB (1 core).
"""
import math
import sys
import time

import numpy as np


def odd_sieve(n):
    """Odd-only numpy boolean sieve up to n.  Returns the bool array
    s indexed by s[i] <-> 2i+1 (s[0] unused, set False)."""
    m = n // 2 + 1
    s = np.ones(m, bool)
    s[0] = False
    r = int(math.isqrt(n)) // 2 + 1
    for i in range(1, r):
        p = 2 * i + 1
        if s[i]:
            s[(p * p) // 2::p] = False
    return s


def pair_classes(x, margin=400):
    """Exact ordered mod-4 pair census under the PAPER convention:
    for each odd prime p_n <= x, count (p_n mod 4, p_{n+1} mod 4),
    the successor seen by sieving to x + margin.  Also returns the
    gap-array for the 'meas' convention (gaps between consecutive
    primes both <= x).  Returns a dict."""
    s = odd_sieve(x + margin)
    odds = 2 * np.nonzero(s)[0] + 1          # all odd primes <= x+margin
    odds = odds[odds <= x + margin]
    # odd primes <= x (the p_n allowed as first members)
    m_x = np.searchsorted(odds, x, side="right")
    first = odds[:m_x]                       # odd primes <= x
    succ = odds[1:m_x + 1]                   # their successors (> first)
    a = first % 4
    b = succ % 4
    counts = {}
    for pa, pb in [(1, 1), (1, 3), (3, 1), (3, 3)]:
        counts[(pa, pb)] = int(np.sum((a == pa) & (b == pb)))
    pi_x = int(np.searchsorted(odds, x, side="right"))  # includes 2
    # the record 'meas' convention: gaps between consecutive primes
    # both <= x (the last prime <= x terminates the chain)
    chain = np.r_[2, odds[:m_x]]
    k = np.diff(chain.astype(np.int64)) // 2
    meas = float((k % 2 == 1).mean())
    return counts, pi_x, meas, len(first)


def main():
    x = int(sys.argv[1]) if len(sys.argv) > 1 else 10 ** 9
    paper = {  # (pi(x;4,(1,1)), pi(x;4,(1,3))) verbatim from paper.txt
        10 ** 9: (1.141e7, 1.401e7),
        10 ** 10: (1.032e8, 1.244e8),
        10 ** 11: (9.412e8, 1.118e9),
        10 ** 12: (8.654e9, 1.015e10),
    }
    t0 = time.time()
    counts, pi_x, meas, nodd = pair_classes(x)
    dt = time.time() - t0
    off_paper = counts[(1, 3)] + counts[(3, 1)]
    diag_paper = counts[(1, 1)] + counts[(3, 3)]
    assert off_paper + diag_paper == nodd, (off_paper, diag_paper, nodd)

    print("=" * 74)
    print("U3c (c)  the LOS paper r = 2, q = 4 data rows vs the exact sieve")
    print("         (arXiv:1603.03720v4 Section 5;  persisted paper.pdf;")
    print("          no RH claim;  published-DATA cross-check only)")
    print("=" * 74)
    print()
    print("x = %d   (numpy odd sieve + margin 400:  %.1f s, 1 core)" % (x, dt))
    print("pi(x) = %d     odd primes <= x (paper convention) = %d"
          % (pi_x, nodd))
    for pair in [(1, 1), (1, 3), (3, 1), (3, 3)]:
        print("  pi(x;4,%s) = %15d" % (str(pair), counts[pair]))
    print("  off-diagonal = %d   frac_off (paper conv) = %.6f"
          % (off_paper, off_paper / nodd))
    print("  diagonal     = %d   frac_diag (paper conv) = %.6f"
          % (diag_paper, diag_paper / nodd))
    print("  'meas' convention (gaps both <= x, incl. (2,3) gap) = %.6f"
          % meas)
    print()
    p = paper.get(x)
    if p:
        ok = True
        for pair, val in [((1, 1), p[0]), ((1, 3), p[1])]:
            ours = counts[pair]
            tol = 0.5 * 10 ** (len(str(int(round(val)))) - 4)  # 4 sig figs
            agree = abs(ours - val) <= tol
            ok &= agree
            print("  paper pi(x;4,%s) = %9.3e    ours = %d   |diff| = %.2e   "
                  "(tol %.0e)   %s" % (str(pair), val, ours,
                                       abs(ours - val), tol,
                                       "AGREE" if agree else "MISMATCH"))
        frac_paper = 2 * p[1] / (2 * p[0] + 2 * p[1])
        print("  paper implicit off-diagonal fraction (C1.5 symmetry) = "
              "%.6f   ours (paper conv) = %.6f   diff = %+.2e"
              % (frac_paper, off_paper / nodd, off_paper / nodd - frac_paper))
        print()
        print("  VERDICT (rows): %s at the paper's published precision"
              % ("AGREE" if ok else "MISMATCH - see rows"))
    else:
        print("  (no paper row at this x; counts recorded only)")
    meas_rec = {10 ** 7: 0.564864, 10 ** 8: 0.556519, 3 * 10 ** 8: 0.553811,
                10 ** 9: 0.551072, 10 ** 10: 0.546585, 3 * 10 ** 10: 0.544733,
                10 ** 11: 0.542888}
    if x in meas_rec:
        print()
        print("  record cross-ref: meas(%d) = %.6f   ours = %.6f   diff = %+.2e"
              % (x, meas_rec[x], meas, meas - meas_rec[x]))
    print()
    print("No RH claim.  Flank provenance work (U3c (c)).")


if __name__ == "__main__":
    main()
