"""kcs3: U3 - two-together next-gap-class prediction (the chime compass,
made exact).  The Kansas City Shuffle plan, Unit 3.

Model (no RH claim - an explicit pair heuristic with named constants):

  Consecutive odd primes, gap G = 2k.  Under the Hardy-Littlewood
  pair sieve (the singular SERIES - the sieve's cut product,
  w(k) = 2*C2*prod_{q>2, q|k} (q-1)/(q-2),  C2 = the twin-prime
  constant) times the Cramer interprime density (no intermediate
  prime: e^{-2k/L},  L = ln X), the class frequencies among
  consecutive gaps are

    P(k in class)  ~  [ sum_{k in class} w(k) e^{-2k/L} ]
                      / [ sum_k w(k) e^{-2k/L} ] .

  ONE-CHANNEL baseline: density only (the 1/ln X zeta side without
  the cut product) = UNIFORM over classes = 1/2 (k odd / k even).
  TWO-TOGETHER = the w(k) modulation ON TOP of the density.

Checks:
  (a) the L -> inf mean-value ratio (K-cutoff) - the w(k) side is
      class-symmetric (1/2);  the measured bias is carried by the
      e^{-2k/L} consecutivity factor (see U3b);  the verified
      literature anchor is Lemke Oliver-Soundararajan
      (arXiv:1603.03720,  PNAS 113(36):10050 (2016)):  class limit
      1/2 with a bias decaying like ln ln x / ln x;
  (b) the k = 1..8 gap-distribution shape vs measurement (validates
      the e^{-2k/L} factor placement);
  (c) the measured mod-4 class fraction at X = 1e7, 1e8 with a
      binomial CI vs the two-together prediction and the 1/2
      baseline (the margin table).

Sieve: numpy odd-only byte sieve (exact ground truth; primesieve not
installed in this env - the odd-only sieve at 1e8 is seconds).
"""
import math
import sys
import time

import numpy as np

OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs3_out.txt", "w")


def W(*a):
    print(*a, file=OUT)


def twin_constant(prime_curt=10 ** 6):
    # C2 = prod_{p>2} (1 - 1/(p-1)^2)
    s = np.ones(prime_curt + 1, bool)
    s[:2] = False
    for p in range(2, int(prime_curt ** 0.5) + 1):
        if s[p]:
            s[p * p::p] = False
    ps = np.nonzero(s)[0]
    c = 1.0
    for p in ps[ps > 2]:
        c *= 1.0 - 1.0 / ((p - 1) ** 2)
    return c


def w_array(K, c2):
    """w(k) = 2*C2*prod_{q>2, q|k}(q-1)/(q-2) for k = 1..K (log-space)."""
    spf = np.zeros(K + 1, dtype=np.int64)
    for p in range(3, K + 1, 2):  # odd primes only (q>2)
        if spf[p] == 0:
            spf[p] = p
            if p * p <= K:
                spf[p * p::p] = np.where(spf[p * p::p] == 0,
                                         p, spf[p * p::p])
    logw = np.full(K + 1, math.log(2 * c2))
    for k in range(1, K + 1):
        m = k
        while m % 2 == 0 and m > 1:  # strip 2s (q>2 only)
            m //= 2
        while m > 1:
            q = spf[m]
            if q == 0:
                q = m
            logw[k] += math.log((q - 1) / (q - 2))
            while m % q == 0:
                m //= q
    return np.exp(logw)


def frac_odd_model(L, w, K):
    k = np.arange(1, K + 1, dtype=np.float64)
    wt = w[1:K + 1] * np.exp(-2 * k / L)
    odd = k.astype(int) % 2 == 1
    return float(wt[odd].sum() / wt.sum())


def gap_stats(X, name):
    # odd-only sieve: index i represents 2i+1... use the classic form
    n = int(X)
    m = n // 2 + 1  # candidate 2i+1 for i in [0, m)
    s = np.ones(m, bool)
    s[0] = False  # 1
    r = int(math.isqrt(n)) // 2 + 1
    for i in range(1, r):
        p = 2 * i + 1
        if s[i]:
            start = (p * p) // 2
            s[start::p] = False
    primes = np.r_[2, 2 * np.nonzero(s)[0] + 1]
    primes = primes[primes <= n]
    gaps = np.diff(primes.astype(np.int64))
    k = gaps // 2
    odd = k % 2 == 1
    phat = float(odd.mean())
    ncnt = len(k)
    se = math.sqrt(phat * (1 - phat) / ncnt)
    L = math.log(n)
    W("[X = %s]  n(primes) = %d  gaps = %d" % (name, len(primes), ncnt))
    W("  measured: frac(k odd) = frac(G %% 4 == 2) = %.6f   95%% CI %+.5f"
      % (phat, 1.96 * se))
    return primes, k, phat, se, L


t0 = time.time()
C2 = twin_constant()
W("C2 (twin constant, product to 1e6) = %.10f  (literature 0.660161815847)" % C2)
W("")
K1 = 2000
w = w_array(K1, C2)
K2 = 10 ** 6  # mean-value convergence probe (1e6 keeps this in seconds)
w2 = w_array(K2, C2)
k2 = np.arange(1, K2 + 1)
odd2 = k2 % 2 == 1
wv2 = w2[1:K2 + 1]
frac_mean = float(wv2[odd2].sum() / wv2.sum())
W("(a) L->inf mean-value class ratio (K = %d):  frac(k odd) = %.6f"
  % (K2, frac_mean))
W("    class limit is 1/2 with a decaying bias;  verified anchor:")
W("    Lemke Oliver-Soundararajan,  arXiv:1603.03720,  PNAS 113:10050")
W("    (the earlier ~65/35 GPY/Maynard/Tao benchmark is RETRACTED")
W("    as unverified memory - see the KCS plan,  U3 section)")
W("    U3b (kcs3b_gap_class_u3b.py) is the exact-consecutivity")
W("    refinement:  three-channel decomposition at 1e7/1e8/3e8/1e9)")
W("")
for X, name in ((10 ** 7, "1e7"), (10 ** 8, "1e8")):
    primes, k, phat, se, L = gap_stats(X, name)
    pred = frac_odd_model(L, w, K1)
    W("  L = ln X = %.4f" % L)
    W("  TWO-TOGETHER prediction (w-modulated e^{-2k/L}): %.6f" % pred)
    W("  ONE-CHANNEL baseline (density only, uniform class) : 0.500000")
    W("  MARGIN: |meas - pred2ch| = %.5f   |meas - 0.5| = %.5f"
      % (abs(phat - pred), abs(phat - 0.5)))
    W("  margin gain of two-together over naive: %.5f"
      % (abs(phat - 0.5) - abs(phat - pred)))
    # (b) shape: model k fractions
    kk = np.arange(1, K1 + 1, dtype=np.float64)
    wt = w[1:K1 + 1] * np.exp(-2 * kk / L)
    tot = wt.sum()
    W("  (b) gap-2k shape check  k=1..8:  measured vs model")
    for kk_i in range(1, 9):
        mfr = float((k == kk_i).mean())
        W("    k=%d:  meas %.5f   model %.5f" % (kk_i, mfr,
                                                  float(wt[kk_i - 1] / tot)))
    W("")
W("KCS3 U3 done (%.1f s)" % (time.time() - t0))
OUT.close()
print(open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs3_out.txt").read())
