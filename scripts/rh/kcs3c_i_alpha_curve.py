#!/usr/bin/env python3
"""kcs3c_i: U3c (i) - the alpha(X) transfer-coefficient curve across the
recorded ladder 1e7..3e12 (KCS plan: the "next alpha decade" named in
U3b / 0186).  PURE POST-PROCESSING of recorded data - zero new sieving;
the only per-point computation is the pure-function u3(X) = S2/(S2+S0).

Definitions (VERBATIM copies from scripts/rh/kcs3b_gap_class_u3b.py,
the U3b unit of record; K = 2000, C2 = twin constant as there):
  composed_frac(S2, S0, delta, alpha) =
      S2(1 + alpha*delta) / ( S2(1 + alpha*delta) + S0(1 - alpha*delta) )
  alpha(X) = the unique alpha with composed_frac == meas(X)
              (U3b convention: the pair bias transferred DILUTED by
               alpha << 1 into the consecutive-gap census)
  u3(X) = S2/(S2+S0),  (S2, S0) = class_sums(ln X, w, 2000)
  delta(X) = los_delta(ln X) = ln(2*pi*ln X/4) / (2 ln X)   (verified
              LOS q=4 factor)
  R(X) = meas(X) - u3(X)   (the 0186-0194 residual)

meas provenance (recorded values; 1e12/3e12 ALSO recomputed EXACTLY
from the windowed checkpoints as a hard cross-check):
  1e7..1e9:   U3b table        tmp/kcs3b_out.txt        (0170)
  3e10/1e11:  U3c(d) run       tmp/kcs3c_d_out.txt      (0187)
  1e12:       0192 record      (meas 0.539769, se 2.570e-6)
  3e12:       0194 record      (meas 0.538446, se 1.515e-06)

Built-in gates (exit 1 on any failure):
  G1  recomputed u3 matches the recorded u3 to 6 digits (all points)
  G2  recomputed alpha matches the recorded U3b alpha to 5 digits
      (1e7..1e9)
  G3  exact ckpt census sum(godd)/sum(gn) rounds back to the
      6-decimal RECORDED meas within 6e-7 (1e12, 3e12) - the
      recorded values are 6-decimal roundings of the exact census
  G4  the transfer-gain structure  R/(alpha*delta)  is X-STABLE
      (max-min drift < 1.5% over the 5.7-decade ladder) - the
      first-order transfer identity meas = u3 + g*alpha*delta with
      g ~ 2f(1-f) ~ 0.495 (the U3b line).  The 0190 R-law OOS
      z-scores against the measurement se are REPORTED (not
      gated) - the recorded 0196 standard is combined (fit +
      measurement) sigma, and the 0199 entry gates R(1e13) with
      the kcs3c_h combined-uncertainty machinery.

Output: the alpha curve, the transfer-gain structure, decay-shape
fits (power, affine in 1/L, and A/L through the origin, all-8 and
converged-tail), and the R(1e13) / alpha(1e13) predictions (four
routes) for the running 1e13 point (0199).
No RH claim: measured flank machinery on a mod-4 prime-gap census
statistic.
"""
import json
import math
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
DIR = "/home/jsmille/Projects/rh-missing-tail/tmp/u3c_c_fig"
OUT = open(os.path.join(HERE, "kcs3c_i_alpha_curve.out"), "w")


def W(*a):
    print(*a, file=OUT)
    print(*a)


# =================  verbatim U3b machinery  =================

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


def rlaw_0190(L):
    """The 0190 derived two-term residual law (SOLE SURVIVING
    candidate, 0188-0196):  R = -1.88114*u^2 + 3.69471*delta*u."""
    u = math.log(L) / L
    return -1.88114 * u * u + 3.69471 * los_delta(L) * u


def ckpt_census(ckpt):
    """Exact pooled census from a windowed checkpoint: sum(godd)/sum(gn)."""
    recs = json.load(open(ckpt))
    gn = sum(r["gn"] for r in recs)
    godd = sum(r["godd"] for r in recs)
    return godd / gn, godd, gn

# =================  recorded anchors  =================
#  meas / se / u3 as recorded (provenance in the header);  alpha
#  recorded only for the original U3b points.

POINTS = [
    dict(X=10 ** 7,  meas=0.564864, se=None,      u3=0.555808,
         alpha_rec=0.18332, src="U3b table (0170)"),
    dict(X=10 ** 8,  meas=0.556519, se=None,      u3=0.550315,
         alpha_rec=0.13743, src="U3b table (0170)"),
    dict(X=3 * 10 ** 8, meas=0.553811, se=None,   u3=0.548097,
         alpha_rec=0.13170, src="U3b table (0170)"),
    dict(X=10 ** 9,  meas=0.551072, se=None,      u3=0.545905,
         alpha_rec=0.12412, src="U3b table (0170)"),
    dict(X=3 * 10 ** 10, meas=0.544733, se=1.381e-05, u3=0.540762,
         src="U3c(d) (0187)"),
    dict(X=10 ** 11, meas=0.542888, se=7.763e-06, u3=0.539233,
         src="U3c(d) (0187)"),
    dict(X=10 ** 12, meas=0.539769, se=2.570e-06, u3=0.536638,
         src="0192",
         ckpt=os.path.join(DIR, "ckpt_1000000000000.json")),
    dict(X=3 * 10 ** 12, meas=0.538446, se=1.515e-06, u3=0.535528,
         src="0194",
         ckpt=os.path.join(DIR, "ckpt_3000000000000.json")),
]


def main():
    fails = 0
    C2 = twin_constant()
    K = 2000
    w = w_array(K, C2)
    W("kcs3c_i  the alpha(X) transfer-coefficient curve  1e7..3e12")
    W("         (U3c(i): the 'next alpha decade' of U3b / 0186;")
    W("          pure post-processing of recorded data; K = %d)" % K)
    W("")
    W("%12s %10s %9s %9s %9s %9s" % ("X", "meas", "u3 rec",
                                    "u3 new", "alpha", "R"))
    curves = []
    for pt in POINTS:
        X = pt["X"]
        L = math.log(X)
        delta = los_delta(L)
        S2, S0 = class_sums(L, w, K)
        u3n = S2 / (S2 + S0)
        u3r = pt["u3"]
        d = u3n - u3r
        g1 = abs(d) < 5e-7
        alpha = solve_alpha(S2, S0, delta, pt["meas"])
        R = pt["meas"] - u3n
        curves.append(dict(X=X, L=L, delta=delta, u3=u3n, alpha=alpha,
                           R=R, se=pt["se"], S2=S2, S0=S0))
        tag = ""
        if not g1:
            tag = "  G1 FAIL"
            fails += 1
        W("%12s %10.6f %9.6f %9.6f %9.5f %+9.6f%s"
          % (format(X, "d"), pt["meas"], u3r, u3n, alpha, R, tag))
    W("")
    # G2: recomputed alpha vs recorded U3b alpha (1e7..1e9)
    W("G2  recomputed alpha vs recorded U3b alpha (1e7..1e9):")
    for cv, pt in zip(curves[:4], POINTS[:4]):
        d = cv["alpha"] - pt["alpha_rec"]
        ok = abs(d) < 5e-5
        fails += 0 if ok else 1
        W("   %12d  new %.5f   rec %.5f   d = %+8.5f  %s"
          % (pt["X"], cv["alpha"], pt["alpha_rec"], d,
             "OK" if ok else "G2 FAIL"))
    W("")
    # G3: exact ckpt census vs recorded meas (1e12, 3e12).
    # Record convention: the stored meas is a 6-decimal rounding of
    # the exact census, so the exact value must round back to the
    # record (tolerance 6e-7).
    W("G3  exact ckpt census (sum godd / sum gn) vs recorded meas")
    W("    (recorded = 6-decimal rounding of the exact census):")
    for cv, pt in zip(curves[6:], POINTS[6:]):
        ce, godd, gn = ckpt_census(pt["ckpt"])
        d = ce - pt["meas"]
        ok = abs(d) < 6e-7
        fails += 0 if ok else 1
        W("   %12s  exact %.9f   rec %.6f   d = %+2.0e  rounds-back %s"
          % (format(pt["X"], "d"), ce, pt["meas"], d,
             "OK" if ok else "G3 FAIL"))
    W("")
    # G4: the transfer-gain X-stability gate;  the 0190 R-law OOS
    # z's are reported, not gated (the recorded 0196 standard is
    # combined fit+meas sigma; the 0199 entry gates R(1e13) with the
    # combined-uncertainty machinery).
    gains = [cv["R"] / (cv["alpha"] * cv["delta"]) for cv in curves]
    drift = ((max(gains) - min(gains))
             / (0.5 * (max(gains) + min(gains))))
    ok = drift < 0.015
    fails += 0 if ok else 1
    W("G4  transfer gain  R / (alpha*delta)  across the ladder")
    W("    (first-order transfer meas = u3 + g*alpha*delta would")
    W("    make this X-constant;  g ~ 2f(1-f) ~ 0.495, the U3b line):")
    for cv, g in zip(curves, gains):
        W("   %12d  alpha*delta = %.6f   R/(alpha*delta) = %.4f"
          % (cv["X"], cv["alpha"] * cv["delta"], g))
    W("   max-min drift = %.2f%% over 5.7 decades  ->  %s"
      % (100.0 * drift, "OK (X-stable)" if ok else "G4 FAIL"))
    W("")
    W("report (NOT gated): 0190 derived R-law z's vs the MEASUREMENT")
    W("se (the recorded 0196 OOS standard is combined fit+meas sigma;")
    W("the 0199 entry gates R(1e13) properly):")
    for cv in curves[4:]:
        Rp = rlaw_0190(cv["L"])
        z = (cv["R"] - Rp) / cv["se"]
        W("   %12d  R meas %+.6f  R law %+.6f  z(meas se) = %+6.2f"
          % (cv["X"], cv["R"], Rp, z))
    W("")
    # fit A: alpha = A*L^p  (power in L)
    xs = [math.log(c["L"]) for c in curves]
    ya = [math.log(c["alpha"]) for c in curves]
    n = len(xs)
    sx, sy = sum(xs), sum(ya)
    sx2 = sum(v * v for v in xs)
    sxy = sum(x * y for x, y in zip(xs, ya))
    p = (n * sxy - sx * sy) / (n * sx2 - sx * sx)
    lnA = (sy - p * sx) / n
    res_p = max(abs((p * x + lnA - y)) for x, y in zip(xs, ya))
    W("fit A  alpha = A*L^p :    A = %.5f  p = %.5f  max|resid(ln)| = %.4f"
      % (math.exp(lnA), p, res_p))
    # fit B: alpha = A - B/L  (affine in 1/L)
    xb = [1.0 / c["L"] for c in curves]
    yb = [c["alpha"] for c in curves]
    sx, sy = sum(xb), sum(yb)
    sx2 = sum(v * v for v in xb)
    sxy = sum(x * y for x, y in zip(xb, yb))
    mB = (n * sxy - sx * sy) / (n * sx2 - sx * sx)
    cB = (sy - mB * sx) / n
    res_b = max(abs((mB * x + cB) - y) for x, y in zip(xb, yb))
    W("fit B  alpha = A - B/L:  A = %.5f  B = %.5f  max|resid| = %.5f"
      % (cB, mB, res_b))
    # fit C: alpha = A/L through the origin, OLS in x = 1/L:
    # A = sum(x*y) / sum(x^2);  all-8 and converged-tail (1e8..3e12)
    def fit_al(sub):
        xx = [1.0 / c["L"] for c in sub]
        yy = [c["alpha"] for c in sub]
        A = sum(a * b for a, b in zip(xx, yy)) / sum(a * a for a in xx)
        res = max(abs(A * a - b) for a, b in zip(xx, yy))
        return A, res
    A8, res8 = fit_al(curves)
    At, rest = fit_al(curves[1:])
    W("fit C  alpha = A/L :     all-8         A = %.5f  max|resid| = %.5f"
      % (A8, res8))
    W("         converged 1e8..3e12  A = %.5f  max|resid| = %.5f"
      % (At, rest))
    W("   alpha*X diagnostics (alpha*L):")
    for cv in curves:
        W("   %12d  alpha*L = %.4f" % (cv["X"], cv["alpha"] * cv["L"]))
    W("")
    # 1e13 predictions (for the running point, entry 0199)
    X13 = 10 ** 13
    L13 = math.log(X13)
    d13 = los_delta(L13)
    u13 = math.log(L13) / L13
    S2, S0 = class_sums(L13, w, K)
    u3_13 = S2 / (S2 + S0)
    Rlaw13 = rlaw_0190(L13)
    alpha13_r1 = math.exp(lnA) * L13 ** p
    alpha13_r2 = A8 / L13
    alpha13_r3 = At / L13
    alpha13_r4 = solve_alpha(S2, S0, d13, u3_13 + Rlaw13)
    W("PREDICTIONS on file for the 1e13 point (running):")
    W("   L = %.6f  u = %.7f  delta = %.6f  u3(new) = %.6f"
      % (L13, u13, d13, u3_13))
    W("   R(1e13) from the 0190 law          = %+.6f" % Rlaw13)
    W("   alpha(1e13)  route 1 (fit A power) = %.5f" % alpha13_r1)
    W("   alpha(1e13)  route 2 (fit C all-8) = %.5f" % alpha13_r2)
    W("   alpha(1e13)  route 3 (fit C tail)  = %.5f" % alpha13_r3)
    W("   alpha(1e13)  route 4 (R-law inv.)  = %.5f" % alpha13_r4)
    W("")
    W("GATE: %s" % ("FAIL (%d)" % fails if fails else "ALL PASS"))
    OUT.close()
    sys.exit(1 if fails else 0)


if __name__ == "__main__":
    main()
