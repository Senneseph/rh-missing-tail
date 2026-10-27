"""kcs3c_d: U3c (d) - the next alpha/R decade: 3e10 and 1e11 (KCS plan,
U3c remaining item (a) follow-up, named in 0186).  No RH claim.

What this unit does
-------------------
The 1e10 run (0186, tmp/kcs3c_out.txt) left exactly one live form for
the residual law R(X) = meas(X) - u3(X):

  MIXED:  R(X) = a*delta(X) + b*(loglog X / log X)^2
          a = -0.123764, b = 0.715792   (4-point OLS, 1e7..1e9)
          which PREDICTS (out of sample)
              R(1e10) = +0.003639   (measured +0.004307, z = 1.21)
              R(3e10) = +0.003139
              R(1e11) = +0.002655

This run measures 3e10 and 1e11 and compares against those two
predictions - a clean out-of-sample test of the only surviving
ansatz (the predictions were anchored on 1e7..1e9 BEFORE 1e10
existed in the record).

Sieve: the identical U3b machinery (measured() copied verbatim: the
exact numpy odd-only byte sieve).  3e10 runs the global byte sieve
directly; 1e11 is too large for one in-memory byte array at this
box's standing memory rules, so a VERBATIM-MARKING interval variant
is used: the same odd-indexed boolean array over the interval
[X_lo, X_hi], marked by every small prime p <= sqrt(X_hi) with the
identical start/step rule - the multiples cleared are exactly the
same set, so the primes extracted are byte-identical to the global
sieve's.  The interval mechanism is gated by an identity check:
measured_interval(0, 1e10) must reproduce measured(1e10) EXACTLY
(pi AND the class census) before it is trusted for 5e10/1e11.
"""
import gc
import math
import time

import numpy as np

twin_constant_src = None  # placeholder marker (functions pasted below)
import re as _re

_SRC = open(
    "/home/jsmille/Projects/rh-missing-tail/scripts/rh/kcs3b_gap_class_u3b.py"
).read()
NS = {"np": np, "math": math}
for _name in ["twin_constant", "w_array", "class_sums", "los_delta"]:
    _m = _re.search(r"\ndef %s\(.*?(?=\ndef |\nOUT |\nif __name__)" % _name,
                    _SRC, _re.S)
    assert _m, _name
    exec(_m.group(0), NS)
for _name in ["twin_constant", "w_array", "class_sums", "los_delta"]:
    globals()[_name] = NS[_name]


def measured(X):
    """VERBATIM U3b measurement (ground truth of U3/U3b)."""
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


def small_primes(limit):
    s = np.ones(limit // 2 + 1, bool)
    s[0] = False
    r = int(math.isqrt(limit)) // 2 + 1
    for i in range(1, r):
        p = 2 * i + 1
        if s[i]:
            s[(p * p) // 2::p] = False
    out = np.nonzero(s)[0]
    out = 2 * out + 1
    return out[out <= limit]


def measured_interval(X_lo, X_hi):
    """The SAME odd-indexed byte sieve restricted to [X_lo, X_hi].
    Returns (class_count_odd_k, gaps_total, npr, last_prime,
             first_prime).  The marking is identical to the global
    sieve restricted to the interval: for each small prime p the
    odd multiples in the interval are cleared, starting at the first
    multiple >= max(p^2, X_lo) (odd-aligned)."""
    X_lo = int(X_lo)
    X_hi = int(X_hi)
    # odd candidates in [X_lo, X_hi]
    lo = X_lo if X_lo % 2 == 1 else X_lo + 1
    if lo > X_hi:
        return 0, 0, 0, None, None
    m = (X_hi - lo) // 2 + 1
    s = np.ones(m, bool)
    if lo == 1:
        s[0] = False  # 1 is not prime
    sp = small_primes(math.isqrt(X_hi))
    for p in sp:
        # smallest odd multiple of p in [lo, X_hi], starting at
        # max(p^2, first odd multiple of p >= lo) - the SAME clearing
        # set as the global sieve restricted to the interval
        start = p * p
        if start < lo:
            start = p * ((lo + p - 1) // p)
            if start % 2 == 0:
                start += p
        if start > X_hi:
            continue
        idx0 = (start - lo) // 2
        s[idx0::p] = False
    idx = np.nonzero(s)[0]
    if len(idx) == 0:
        oddprimes = np.zeros(0, dtype=np.int64)
    else:
        # in-place:  idx = offset -> 2*offset + lo = the prime value
        idx *= 2
        idx += lo
        oddprimes = idx
    if lo == 1:
        # the interval contains 2;  2 is prime and precedes all odds
        oddprimes = np.concatenate(([2], oddprimes))
    if len(oddprimes) == 0:
        return 0, 0, 0, None, None
    primes = oddprimes
    k = np.diff(primes) // 2
    odd = int((k % 2 == 1).sum())
    return odd, len(k), len(primes), int(primes[-1]), int(primes[0])


def merge_two_intervals(first, second):
    """(odd1, gaps1, n1, last1, fp1) + (odd2, gaps2, n2, last2, fp2)
    -> combined class counts; exactly ONE boundary gap (fp2 - last1)
    is added (it is a genuine consecutive-prime gap)."""
    (o1, g1, n1, l1, f1) = first
    (o2, g2, n2, l2, f2) = second
    if n1 == 0:
        return o2, g2, n2, l2, f2
    if n2 == 0:
        return o1, g1, n1, l1, f1
    border = (f2 - l1) // 2
    odd = o1 + o2 + (1 if border % 2 == 1 else 0)
    gaps = g1 + g2 + 1
    return odd, gaps, n1 + n2, l2, f1


def main():
    t0 = time.time()
    lines = []
    W = lines.append
    W("U3c (d)  the next alpha/R decade: 3e10 and 1e11")
    W("         (named in 0186;  the mixed-form predictions were")
    W("         anchored on 1e7..1e9 - a clean out-of-sample test)")
    W("")

    # (0) identity anchor: global vs the recorded 1e10 (0186)
    ph10, se10, npr10 = measured(10 ** 10)
    assert abs(ph10 - 0.546585) < 5e-7, "1e10 anchor drift"
    assert npr10 == 455052511, "pi(1e10) drift"
    W("anchor:  global measured(1e10) = %.6f  pi = %d   (record MATCH)"
      % (ph10, npr10))

    # (1) interval mechanism identity at 1e10
    gc.collect()
    (o, g, n, last, first) = measured_interval(0, 10 ** 10)
    assert n == npr10, "interval pi mismatch at 1e10"
    phat_i = o / g
    assert abs(phat_i - ph10) < 5e-10, "interval census drift at 1e10"
    W("interval mechanism:  [0, 1e10] reproduces the global sieve")
    W("EXACTLY (pi = %d, census %.6f = %.6f) - trusted for bigger"
      % (n, phat_i, ph10))
    gc.collect()
    W("")

    w2000 = w_array(2000, twin_constant())

    # (2) 3e10 (global byte sieve - fits the memory rules)
    L3 = math.log(3 * 10 ** 10)
    S2, S0 = class_sums(L3, w2000, 2000)
    u3_3e10 = S2 / (S2 + S0)
    t2 = time.time()
    ph3, se3, npr3 = measured(3 * 10 ** 10)
    dt3 = time.time() - t2
    R3 = ph3 - u3_3e10
    W("X = 30000000000 (3e10)  [NEW, global sieve %.1f s]" % dt3)
    W("   pi = %d   meas = %.6f   se = %.3e" % (npr3, ph3, se3))
    W("   u3-only = %.6f   R = %+.6f   (z vs u3 = %.1f)"
      % (u3_3e10, R3, R3 / se3))
    gc.collect()

    # (3) 1e11 via two 5e10 interval halves
    t2 = time.time()
    Lh = math.log(5 * 10 ** 10)
    H1 = measured_interval(0, 5 * 10 ** 10)
    t_h1 = time.time() - t2
    gc.collect()
    t2 = time.time()
    H2 = measured_interval(5 * 10 ** 10, 10 ** 11)
    t_h2 = time.time() - t2
    o11, g11, npr11, last11, first11 = merge_two_intervals(H1, H2)
    assert g11 == npr11 - 1, "gap count vs prime count mismatch"
    ph11 = o11 / g11
    se11 = math.sqrt(ph11 * (1 - ph11) / g11)
    L11 = math.log(10 ** 11)
    S2, S0 = class_sums(L11, w2000, 2000)
    u3_1e11 = S2 / (S2 + S0)
    R11 = ph11 - u3_1e11
    W("X = 100000000000 (1e11)  [NEW, two 5e10 interval halves: %.1f s"
      " + %.1f s]" % (t_h1, t_h2))
    W("   pi = %d   (H1 pi = %d, H2 pi = %d)"
      % (npr11, H1[2], H2[2]))
    W("   meas = %.6f   se = %.3e" % (ph11, se11))
    W("   u3-only = %.6f   R = %+.6f   (z vs u3 = %.1f)"
      % (u3_1e11, R11, R11 / se11))
    gc.collect()
    W("")

    # (4) the out-of-sample test of the mixed form
    a, b = -0.123764, 0.715792
    W("the mixed form (4-point OLS on 1e7..1e9, anchored BEFORE 1e10):")
    W("   R(X) = a*delta + b*(loglog/log)^2,  a = %.6f  b = %.6f" % (a, b))
    for (X, Lx, ph, se, ux, Rx, tag) in [
        (10 ** 10, math.log(10 ** 10), ph10, se10, 0.542278,
         ph10 - 0.542278, "1e10 (0186 check)"),
        (3 * 10 ** 10, L3, ph3, se3, u3_3e10, R3, "3e10 NEW"),
        (10 ** 11, L11, ph11, se11, u3_1e11, R11, "1e11 NEW"),
    ]:
        dx = los_delta(Lx)
        ll2 = (math.log(Lx) / Lx) ** 2
        pred = a * dx + b * ll2
        z = (Rx - pred) / se
        W("   %s:  predicted R = %+.6f   measured R = %+.6f (se %.3e)"
          % (tag, pred, Rx, se))
        W("         z(meas - pred) = %.2f   [against the measurement se]"
          % z)
    W("")
    # reference: 5-point refit (1e7..1e10) as context only (NOT the test)
    Acol = [los_delta(math.log(Xq)) for Xq in
            [10 ** 7, 10 ** 8, 3 * 10 ** 8, 10 ** 9, 10 ** 10]]
    Bcol = [(math.log(math.log(Xq)) / math.log(Xq)) ** 2 for Xq in
            [10 ** 7, 10 ** 8, 3 * 10 ** 8, 10 ** 9, 10 ** 10]]
    y5 = [0.564864 - 0.555808, 0.556519 - 0.550315,
          0.553811 - 0.548097, 0.551072 - 0.545905,
          ph10 - 0.542278]
    na = 5
    saa = sum(v * v for v in Acol)
    sbb = sum(v * v for v in Bcol)
    sab = sum(x * y for x, y in zip(Acol, Bcol))
    say = sum(x * y for x, y in zip(Acol, y5))
    sby = sum(x * y for x, y in zip(Bcol, y5))
    det = saa * sbb - sab * sab
    a5 = (sbb * say - sab * sby) / det
    b5 = (saa * sby - sab * say) / det
    pred3 = a5 * los_delta(L3) + b5 * (math.log(L3) / L3) ** 2
    pred11 = a5 * los_delta(L11) + b5 * (math.log(L11) / L11) ** 2
    W("reference (NOT the test): 5-point refit (1e7..1e10):")
    W("   a = %.6f  b = %.6f   ->  R(3e10) = %+.6f   R(1e11) = %+.6f"
      % (a5, b5, pred3, pred11))
    W("")
    W("U3c (d) done (total %.1f s) - no RH claim" % (time.time() - t0))
    text = "\n".join(lines) + "\n"
    with open(
            "/home/jsmille/Projects/rh-missing-tail/tmp/kcs3c_d_out.txt",
            "w") as f:
        f.write(text)
    print(text)


if __name__ == "__main__":
    main()
