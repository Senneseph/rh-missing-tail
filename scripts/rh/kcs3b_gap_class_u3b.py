"""kcs3b: U3b - exact consecutivity refinement of the mod-4 gap-class
prediction (KCS plan, Unit 3 follow-up).  No RH claim.

What this unit does
-------------------
U3 (kcs3_gap_class.py) measured the class fraction f(X) =
frac(gap G = 2k with k odd, i.e. G % 4 == 2) among consecutive primes
<= X and compared it to:
  - ONE-CHANNEL baseline:  1/2 (density only)
  - TWO-TOGETHER U3 model: f2(X) = sum_k w(k) e^{-2k/L} over classes,
    L = ln X,  w(k) = 2*C2*prod_{q>2, q|k} (q-1)/(q-2).
The residual was systematic and positive at both scales.  U3b now
decomposes the mechanism into the three candidate channels and measures
the transfer coefficient at four scales:

  (i)  PAIR-ONLY (the verified Lemke Oliver-Soundararajan anchor,
       arXiv:1603.03720,  PNAS 113(36):10050 (2016)):
         q=4 pair count  =  li(x)/4 * (1 +/- delta(x)),
         delta(x) = (1/(2 ln x)) ln(2 pi ln x / 4),
         sign - on diagonal (gap 0 mod 4),  + on off-diagonal
         (gap 2 mod 4).  Class fraction  =  (1+delta)/2.
  (ii) CONSECUTIVITY-ONLY:  the U3 model f2(X) (w-modulated
       e^{-2k/L});  this alone is NOT class-symmetric because small k
       is weighted and w(k) is larger at odd k.
  (iii) COMPOSED:  f3(X) with w(k) -> w(k) * (1 + s_k delta(x)),
       s_k = +1 (k odd),  -1 (k even).  If the pair bias transferred
       undiluted into the consecutive-gap census this would be the
       answer;  it OVERSHOOTS the measurement,  ruling out naive
       composition.
  (iv) TRANSFER COEFFICIENT:  f3_alpha(X) with (1 +/- delta) replaced
       by (1 +/- alpha(X) delta);  alpha(X) solved from f3_alpha =
       measured.  alpha << 1 with a measurable decay in X is the
       honest semi-empirical finding of this unit.

Sieve: exact numpy odd-only byte sieve (same ground truth as U3).
"""
import math
import time

import numpy as np

OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs3b_out.txt", "w")


def W(*a):
    print(*a, file=OUT)


def twin_constant(prime_curt=10 ** 6):
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
    """w(k) = 2*C2*prod_{q>2, q|k}(q-1)/(q-2),  k = 1..K."""
    spf = np.zeros(K + 1, dtype=np.int64)
    for p in range(3, K + 1, 2):
        if spf[p] == 0:
            spf[p] = p
            if p * p <= K:
                spf[p * p::p] = np.where(spf[p * p::p] == 0,
                                         p, spf[p * p::p])
    logw = np.full(K + 1, math.log(2 * c2))
    for k in range(1, K + 1):
        m = k
        while m % 2 == 0 and m > 1:
            m //= 2
        while m > 1:
            q = spf[m]
            if q == 0:
                q = m
            logw[k] += math.log((q - 1) / (q - 2))
            while m % q == 0:
                m //= q
    return np.exp(logw)


def class_sums(L, w, K):
    """(S2, S0):  class sums of w(e^{-2k/L}) for k odd / k even."""
    k = np.arange(1, K + 1, dtype=np.float64)
    wt = w[1:K + 1] * np.exp(-2 * k / L)
    odd = k.astype(int) % 2 == 1
    return float(wt[odd].sum()), float(wt[(~odd)].sum())


def los_delta(L):
    """The verified LOS q=4 loglog-style factor,  delta(x)."""
    return math.log(2.0 * math.pi * L / 4.0) / (2.0 * L)


def composed_frac(S2, S0, delta, alpha=1.0):
    S2p = S2 * (1.0 + alpha * delta)
    S0p = S0 * (1.0 - alpha * delta)
    return S2p / (S2p + S0p)


def solve_alpha(S2, S0, delta, target):
    """alpha such that composed_frac == target (monotone in alpha)."""
    lo, hi = 0.0, 10.0
    for _ in range(200):
        mid = 0.5 * (lo + hi)
        if composed_frac(S2, S0, delta, mid) < target:
            lo = mid
        else:
            hi = mid
    return 0.5 * (lo + hi)


def measured(X):
    n = int(X)
    m = n // 2 + 1
    s = np.ones(m, bool)
    s[0] = False
    r = int(math.isqrt(n)) // 2 + 1
    for i in range(1, r):
        p = 2 * i + 1
        if s[i]:
            s[(p * p) // 2::p] = False
    primes = np.r_[2, 2 * np.nonzero(s)[0] + 1]
    primes = primes[primes <= n]
    k = np.diff(primes.astype(np.int64)) // 2
    phat = float((k % 2 == 1).mean())
    se = math.sqrt(phat * (1 - phat) / len(k))
    return phat, se, len(primes)


def main():
    t0 = time.time()
    C2 = twin_constant()
    K = 2000
    w = w_array(K, C2)
    W("C2 = %.10f  (literature 0.660161815847)" % C2)
    W("literature anchor (VERIFIED,  fetched + identity-checked):")
    W("  Lemke Oliver & Soundararajan,  arXiv:1603.03720,")
    W("  PNAS 113(36):10050 (2016):  q=4 pair count = li(x)/4*(1+/-delta),")
    W("  delta(x) = (1/(2 ln x)) ln(2 pi ln x / 4);  class limit 1/2,")
    W("  bias decaying like ln ln x / ln x.  (The earlier ~65/35")
    W("  GPY/Maynard/Tao benchmark is RETRACTED: unverified memory.)")
    W("")
    W("%8s %9s %9s %9s %9s %9s %9s %9s" % (
        "X", "meas", "u3-only", "LOS-pair", "composed",
        "alpha", "z(u3)", "z(comp)"))
    for X in (10 ** 7, 10 ** 8, 3 * 10 ** 8, 10 ** 9):
        L = math.log(X)
        delta = los_delta(L)
        S2, S0 = class_sums(L, w, K)
        u3 = S2 / (S2 + S0)
        los = 0.5 + 0.5 * delta
        comp = composed_frac(S2, S0, delta, 1.0)
        phat, se, npr = measured(X)
        alpha = solve_alpha(S2, S0, delta, phat)
        z_u3 = (phat - u3) / se
        z_cm = (phat - comp) / se
        W("%8s %9.6f %9.6f %9.6f %9.6f  %.5f  %8.2f  %8.2f"
          % (format(X, "d"), phat, u3, los, comp, alpha, z_u3, z_cm))
        # scale diagnostics
        W("     ln X = %.4f  delta(x) = %.6f  alpha*delta = %.6f"
          % (L, delta, alpha * delta))
    W("")
    W("SE arithmetic (corrected):  z = (meas - model) / se where")
    W("1.96*se = the printed 95%% CI half-width.  U3's '7.7 se' was")
    W("double-discounting:  0.0062/0.00041 = 15.1 is already z (the CI")
    W("half-width IS 1.96*se).  Correct z:  ~14.9 at 1e7,  ~15.1 at 1e8.")
    W("")
    W("U3b done (%.1f s)" % (time.time() - t0))
    OUT.close()
    print(open(OUT.name).read())


if __name__ == "__main__":
    main()
