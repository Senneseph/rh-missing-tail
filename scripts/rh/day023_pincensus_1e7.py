#!/usr/bin/env python3
"""Day-023 — PinCensus (FINAL): the owner's trivial-zero idea, realized
as what it CAN do — an INDEPENDENT CENSUS of the zero list.

Math (DISCOVERY_LOG 21.4 -> 22):
  The trivial zeros pin the nontrivial-zero product at s0 = -2k:
      c_k := P(-2k) = prods_{rho}(1 - s0/rho) e^{s0/rho}
           = zeta'(-2k) / [d/ds e^{A(s)} at s = -2k]
  with A = logmain25212 (the kernel main, bridge-verified to 3e-9 at
  s = 2 and s = -1.999, day-023).  The pin constants c_k come from the
  CONVERGED dps-50 central difference of zeta (mp.diff at dps 40 is
  NOT to be trusted for this; see DISCOVERY_LOG 22).
  The off-line-sensitive part of a single off-line PAIR's pin
  signature (4*k*d/t^2) is buried under the truncation floor for
  t >> 30-300 — NOT an off-line detector.  But the leading COUNT
  signature (4k^2/t^2 per missing/extra pair, d-blind) IS measured:
      R_k = P_B(-2k) * (1 + tail_model_k(B)) / c_k - 1
  should be ~0 (tail-model higher-order, ~k^2 shape); a POSITIVE
  k^2-shaped spike = a missing pair.

Measured results (list B = 6e6, N = 12,193,869; longdouble product,
dps-50 pins):
      k   R_k
      1   -3.4e-9    2  -1.3e-8    3  -3.0e-8
      5   -8.5e-8    10 -3.5e-7
  = tail-model higher-order correction (0.2% of the 1.7e-6 leading
  (B,inf) tail), k^2-shaped, NEGATIVE (missing pairs give POSITIVE) —
  the 12.19M list is independently certified on this channel.
  Sensitivity: a missing pair at height t shifts R_k by ~ +4k^2/t^2,
  so t up to ~2*sqrt(k^2/|R_k|) is covered: ~2e3 (k=1) .. ~1e4 (k=10).

The day-022 probe's '6.7% gap at s0 = -2' is RETIRED (DISCOVERY_LOG
22): it was a probe-path artifact, not a pin defect — the true gap is
~1.6e-6 (float64 12M product precision) at k = 1.
"""
import numpy as np, math
from mpmath import mp
mp.dps = 50
PI, G = mp.pi, mp.euler
LIST = "/home/jsmille/Projects/rh-missing-tail/scripts/rh/zeros_T10000000_lmfdb.txt"

def logmain_ng(s):
    return (s*mp.log(2*PI) - (1 + G/2)*s - mp.log(2) - mp.log(s - 1))

def pin_cd(k, delta='1e-7'):
    """c_k via converged dps-50 central difference of zeta."""
    s0 = mp.mpf(-2*k)
    d = mp.mpf(delta)
    zp = (mp.zeta(s0 + d) - mp.zeta(s0 - d)) / (2*d)
    coef = mp.exp(logmain_ng(s0)) * ((-1)**(k-1) * mp.factorial(k-1) / 2.0)
    v = zp / coef
    assert abs(mp.im(v)) < 1e-30
    return float(mp.re(v))

def P_pair_ld(s0val, g):
    """Full pair product over (0, B], longdouble, S = s0 < 0 real."""
    la = np.longdouble(0)
    CH = 1 << 20
    for i in range(0, len(g), CH):
        A = np.longdouble(0.25) + g[i:i+CH]**2
        s0 = np.longdouble(s0val)
        # pair (1-s0/r1)(1-s0/r2) e^{s0/r1+s0/r2}
        #     = (1 - s0/A + s0^2/A) * e^{s0/A}    (A = t^2+1/4, s0 = -2k)
        la += np.sum(np.log(np.longdouble(1) - s0/A + s0*s0/A)
                     + s0/A, dtype=np.longdouble)
    return float(np.exp(la))

def tail_model(k, B):
    return (4.0*k*k/(2*math.pi)) * (math.log(B/(2*math.pi)) + 1.0) / B

def main():
    g = np.loadtxt(LIST, dtype=np.float64)
    B = float(g[-1])
    print("PinCensus (list B = %.0f, N = %d); longdouble product, dps-50 pins"
          % (B, g.size))
    gld = g.astype(np.longdouble)
    print("k   P_B(pair)        c_k (pin)        R_k (expected ~k^2 tail correction)")
    for k in (1, 2, 3, 5, 10):
        P = P_pair_ld(-2*k, gld)
        c = pin_cd(k)
        R = P * (1.0 + tail_model(k, B)) / c - 1.0
        print("  %2d   %.15f   %.15f   %+.3e" % (k, P, c, R))
    print("missing-pair signature: R_k -> R_k + 4k^2/t^2 (POSITIVE, k^2 shape).")

if __name__ == "__main__":
    main()
