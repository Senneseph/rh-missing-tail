"""kcs3c: U3c - the residual law at the next decade (1e10) + the three
live ansatz discriminator (KCS plan, U3c remaining item (a): measure at
1e10, "the next alpha/R decade").  No RH claim.

What this unit does
-------------------
U3b (kcs3b_gap_class_u3b.py, tmp/kcs3b_out.txt) measured the mod-4
gap-class fraction at X = 1e7/1e8/3e8/1e9 and found:
  R(X) = meas - u3-only = +0.009056 / +0.006204 / +0.005714 /
        +0.005167   (positive, decaying, 43% over two decades)
  alpha(X) = 2R/delta = 0.18332 / 0.13743 / 0.13170 / 0.12412  (decaying)
  C(X) = R/(loglog/log)^2 = 0.61/0.37/0.47/0.48  (NOT constant)
Three live ansatze for R(X) (0173):
  (A) C(X)*(loglog X / log X)^2   with C hopefully constant (not
      constant at the 4 recorded points: C ranges 0.37..0.61)
  (B) alpha(X)*delta(X)/2        (the U3b transfer form; if log alpha
      tracks a power law in loglog X then the law is alpha(X) ~
      (loglog X)^b1 - fit on the 4 recorded points, PREDICTS 1e10)
  (C) a mixed  R = a*delta + b*(loglog/log)^2  (2-param fit on the
      first 4 points; PREDICTS the 1e10 point)
The 1e10 point discriminates: (i) does C stabilize? (ii) does the
alpha power law predict 1e10? (iii) does the mixed 2-param fit,
anchored on 1e7..1e9, predict the 1e10 residual inside its se?

Sieve: the IDENTICAL U3b machinery (functions copied verbatim below;
ground truth = the exact numpy odd-only byte sieve of U3/U3b).  The
whole ladder (1e7..1e10) is re-measured here, which doubles as the
ground-truth identity cross-check against the U3b record at every
point (not only 1e9).
"""
import math
import time

import numpy as np

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


# ----------------------------------------------------------------------
# the recorded points:  X, recorded meas, recorded pi (tabulated)
# ----------------------------------------------------------------------
RECORDED = [
    (10 ** 7, 0.564864, 664579),
    (10 ** 8, 0.556519, 5761455),
    (3 * 10 ** 8, 0.553811, 16252325),
    (10 ** 9, 0.551072, 50847534),
]
X_NEW = 10 ** 10


def main():
    t0 = time.time()
    C2 = twin_constant()
    K = 2000
    w = w_array(K, C2)

    lines = []
    W = lines.append

    W("U3c  the residual law at 1e10 + the three ansatz discriminators")
    W("     (KCS plan U3c item (a);  no RH claim;  exact sieve)")
    W("C2 = %.10f" % C2)
    W("")

    pts = []
    for (X, rec_meas, rec_pi) in RECORDED + [(X_NEW, None, None)]:
        Lx = math.log(X)
        delta = los_delta(Lx)
        S2, S0 = class_sums(Lx, w, K)
        u3 = S2 / (S2 + S0)
        t1 = time.time()
        ph, se, npr = measured(X)
        dt = time.time() - t1
        tag = "RECORDED" if rec_meas is not None else "NEW"
        if rec_meas is not None:
            ok = abs(ph - rec_meas) < 5e-7
            pi_ok = npr == rec_pi
            assert ok, "ground-truth drift at %d" % X
            assert pi_ok, "pi mismatch at %d" % X
        W("X = %12d  [%s]   sieve %.1f s" % (X, tag, dt))
        W("   pi = %d   meas = %.6f%s   se = %.3e"
          % (npr, ph,
             ("   (record %s, MATCH)" % format(rec_meas, ".6f")
              if rec_meas is not None else ""), se))
        W("   u3-only = %.6f   R = meas - u3 = %+.6f" % (u3, ph - u3))
        pts.append(dict(X=X, ph=ph, se=se, npr=npr, u3=u3,
                        delta=delta, L=Lx))
    W("")
    W("all four recorded points re-measured and MATCH (ground truth")
    W("identity confirmed at every point).  1e10 is new.")
    W("")
    W("%12s %9s %9s %10s %10s %10s %10s"
      % ("X", "meas", "u3", "R=meas-u3", "C=R/(ll/l)^2", "alpha=2R/d",
         "se"))
    for p in pts:
        ll = math.log(p["L"]) / p["L"]
        rx = p["ph"] - p["u3"]
        W("%12d %9.6f %9.6f %+10.6f %10.4f %10.5f %10.3e"
          % (p["X"], p["ph"], p["u3"], rx, rx / ll ** 2,
             2 * rx / p["delta"], p["se"]))

    R5 = pts[4]["ph"] - pts[4]["u3"]
    se5 = pts[4]["se"]

    # (A) is C stabilizing?
    Cvals = []
    for p in pts:
        ll = math.log(p["L"]) / p["L"]
        Cvals.append((p["ph"] - p["u3"]) / ll ** 2)
    W("")
    W("ansatz A:  R = C(X) * (loglog/log)^2")
    W("   C over the 5 points:  " + "  ".join("%.4f" % c for c in Cvals))
    W("   range:  %.4f .. %.4f   (record 4-pt range was 0.37..0.61)"
      % (min(Cvals), max(Cvals)))

    # (B) log alpha ~ power law in loglog X,  fit on the FIRST FOUR
    avals = [2 * (p["ph"] - p["u3"]) / p["delta"] for p in pts]
    lx4 = [math.log(math.log(p["X"])) for p in pts[:4]]
    la4 = [math.log(a) for a in avals[:4]]
    nn = 4
    slx = sum(lx4)
    sla = sum(la4)
    slxx = sum(v * v for v in lx4)
    slxa = sum(xv * av for xv, av in zip(lx4, la4))
    b1 = (nn * slxa - slx * sla) / (nn * slxx - slx ** 2)
    b0 = (sla - b1 * slx) / nn
    lx5 = math.log(math.log(X_NEW))
    pred_a5 = math.exp(b0 + b1 * lx5)
    predR_B = 0.5 * pred_a5 * pts[4]["delta"]
    zB = (R5 - predR_B) / se5
    # 5-point fit slope as a consistency figure
    lx5_all = [math.log(math.log(p["X"])) for p in pts]
    la5_all = [math.log(a) for a in avals]
    slx = sum(lx5_all)
    sla = sum(la5_all)
    slxx = sum(v * v for v in lx5_all)
    slxa = sum(xv * av for xv, av in zip(lx5_all, la5_all))
    b1_all = (5 * slxa - slx * sla) / (5 * slxx - slx ** 2)
    b0_all = (sla - b1_all * slx) / 5
    W("")
    W("ansatz B:  R ~ alpha(X)*delta/2,  log alpha = b0 + b1*loglog X")
    W("   alpha over the 5 points:  "
      + "  ".join("%.5f" % a for a in avals))
    W("   4-point OLS:  b0 = %.5f   b1 = %.5f   (slope alpha ~ "
      "(loglog X)^%.3f)" % (b0, b1, b1))
    W("   PREDICTED alpha(1e10) = %.5f   ->   R_B(1e10) = %.6f"
      % (pred_a5, predR_B))
    W("   measured R(1e10) = %+.6f    z(meas - pred_B) = %.2f"
      % (R5, zB))
    W("   (5-point OLS slope for reference:  b1 = %.5f)" % b1_all)

    # (C) 2-param mixed fit on the FIRST FOUR points, predicts the 5th
    Acol = [p["delta"] for p in pts[:4]]
    L5 = pts[4]["L"]
    Bcol = [(math.log(p["L"]) / p["L"]) ** 2 for p in pts[:4]]
    y = [p["ph"] - p["u3"] for p in pts[:4]]
    na = 4
    saa = sum(v * v for v in Acol)
    sbb = sum(v * v for v in Bcol)
    sab = sum(a * b for a, b in zip(Acol, Bcol))
    say = sum(a * v for a, v in zip(Acol, y))
    sby = sum(b * v for b, v in zip(Bcol, y))
    det = saa * sbb - sab * sab
    ahat = (sbb * say - sab * sby) / det
    bhat = (saa * sby - sab * say) / det
    predR_C = ahat * pts[4]["delta"] + bhat * (math.log(L5) / L5) ** 2
    resid4 = [yv - (ahat * av + bhat * bv)
              for yv, av, bv in zip(y, Acol, Bcol)]
    s2_res = sum(r * r for r in resid4) / (na - 2)
    xm_a = sum(Acol) / na
    xm_b = sum(Bcol) / na
    var_a = saa - na * xm_a ** 2
    var_b = sbb - na * xm_b ** 2
    ap = pts[4]["delta"]
    bp = (math.log(L5) / L5) ** 2
    lev = ((ap - xm_a) ** 2 / var_a + (bp - xm_b) ** 2 / var_b
           + 1.0 / na)
    pred_se = math.sqrt(s2_res) * math.sqrt(lev)
    zC = (R5 - predR_C) / math.sqrt(se5 ** 2 + pred_se ** 2)
    W("")
    W("ansatz C:  R = a*delta + b*(loglog/log)^2,  4-point fit,")
    W("PREDICTS the 1e10 point:")
    W("   a = %.6f   b = %.6f   (in-sample max |resid| = %.2e)"
      % (ahat, bhat, max(abs(r) for r in resid4)))
    W("   pred R(1e10) = %+.6f    pred se = %.2e" % (predR_C, pred_se))
    W("   measured R(1e10) = %+.6f (se %.3e)" % (R5, se5))
    W("   z(meas - pred_C) = %.2f" % zC)

    W("")
    W("U3c 1e10 done (total %.1f s) - no RH claim" % (time.time() - t0))
    text = "\n".join(lines) + "\n"
    with open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs3c_out.txt",
              "w") as f:
        f.write(text)
    print(text)


if __name__ == "__main__":
    main()
