#!/usr/bin/env python
"""s26:  s25  far-band census  interpretation -- the 33-row
law  fit  (t/G  =  1  ..  5e7,  ~7.7  decades).

Reuses  the  s22  discriminator  (F1  pure  ln t,  F2  ln t
+  C (t/G)^a)  and  adds  the  two  decision  comparisons:

  P1:  the  s22  28-row  F1  constants  (pre-census)  vs  the
       5  new  census  rows  (prediction  vs  measurement).
  P2:  the  GATED  v3  clause  constants  (A = -25256007,
       B =  523513775,  fit  on  the  21  near  straddle  rows
       (1G, 2.2G])  evaluated  at  the  far  rows  --  the
       drift  that  would  apply  if  the  v3  constants
       were  extrapolated,  and  the  max  residual  of  the
       full  33-row  set  against  the  fresh  33-row  fit.

Channels:  the  dps-40  split  quadrature  is  authoritative.
The  f64  u-trap  cross-check  degrades  smoothly  in  t  (its
2M-point  f64  grid  on  u  in  [ln G,  ln 1e30]  loses
cancellation  headroom  near  the  in-band  singularity):
calibrated  trap  diffs  ~1e8  at  t  ~ 1e11  up  to  ~5e13  at
t  ~ 1.5e18  (s16  ->  s25)  --  a  discretization  limit,  not
a  signal.  The  dps-40  M  channel  stays  integer-quantized
and  on  the  ln  t  law  to  O(1e4)  residuals.
"""
import json
import os

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = 30001045999.981975555

V3_A = -25256007.0
V3_B = 523513775.0
S22_A = -2.525484e7      # s22 28-row F1 (pre-census)
S22_B = 5.234850e8


def load(include_s25=True):
    rows = {}
    srcs = ("s10_deadzone_march", "s9_dk_above_g", "s16_M_far",
            "s20_M_farter", "s21_M_beyond")
    if include_s25:
        srcs = srcs + ("s25_M_farcensus",)
    for f in srcs:
        p = os.path.join(BASE, "tmp/%s.jsonl" % f)
        if not os.path.exists(p):
            continue
        for l in open(p):
            r = json.loads(l)
            if r["t"] > G:
                rows[round(float(r["t"]), 1)] = float(r["M"])
    ts = np.array(sorted(rows))
    Ms = np.array([rows[t] for t in ts])
    return ts, Ms


def fit_f2(ts, Ms, ln, x):
    Jbase = np.column_stack([ln, np.ones(len(ts))])
    best = None
    for a0 in np.arange(0.025, 0.801, 0.025):
        J = np.column_stack([Jbase, np.power(x, a0)])
        cc, *_ = np.linalg.lstsq(J, Ms, rcond=None)
        rr = float(np.max(np.abs(J @ cc - Ms)))
        if best is None or rr < best[1]:
            best = (cc, a0, rr)
    return best


def main():
    all33 = load(True)
    pre28 = load(False)
    ln = np.log(all33[0])
    x = all33[0] / G

    co, *_ = np.linalg.lstsq(np.column_stack([ln, np.ones(len(all33[1]))]),
                             all33[1], rcond=None)
    A1, B1 = float(co[0]), float(co[1])
    r1 = A1 * ln + B1 - all33[1]
    b2 = fit_f2(all33[0], all33[1], ln, x)
    p2, a2, mr2 = b2
    r2 = p2[0] * ln + p2[1] + p2[2] * np.power(x, a2) - all33[1]

    print("33-row  fit   (t/G = %.3f .. %.0f)"
          % (all33[0][0] / G, all33[0][-1] / G))
    print("F1  pure  ln  t:   A  =  %+.6e  B  =  %+.6e   "
          "max|res|  =  %.2f  at  t/G  =  %.3g"
          % (A1, B1, np.max(np.abs(r1)),
             all33[0][np.argmax(np.abs(r1))] / G))
    print("F2  +C(x^a):       A  =  %+.6e  B  =  %+.6e  C  =  "
          "%+.2f  a  =  %.4f   max|res|  =  %.2f"
          % (p2[0], p2[1], p2[2], a2, mr2))

    print()
    print("P1  s22  28-row  constants  vs  the  5  census  rows:")
    new5 = all33[0] >= pre28[0][-1]
    for t, M in zip(all33[0][new5], all33[1][new5]):
        pred = S22_A * np.log(t) + S22_B
        print("  t/G  =  %-12.1f  M  =  %+14.1f   s22-pred  =  "
              "%+14.1f   diff  =  %+.1f"
              % (t / G, M, pred, M - pred))

    print()
    print("P2  GATED  v3  constants  (A  =  %+.0f,  B  =  %+.0f)"
          % (V3_A, V3_B))
    print("    evaluated  at  the  5  census  rows  (extrapolation):")
    for t, M in zip(all33[0][new5], all33[1][new5]):
        pred = V3_A * np.log(t) + V3_B
        print("  t/G  =  %-12.1f  M  =  %+14.1f   v3-law  =  "
              "%+14.1f   diff  =  %+.1f"
              % (t / G, M, pred, M - pred))
    near = all33[0] < 2.2 * G
    rn = V3_A * np.log(all33[0][near]) + V3_B - all33[1][near]
    print("    on  the  near  band  (t/G  <  2.2):  max|res|  =  "
          "%.2f   [v3  clause  support  unchanged]" % np.max(np.abs(rn)))

    print()
    print("full  33-row  F1  residual  table:")
    for t, M, rr in zip(all33[0], all33[1], r1):
        print("  %10.1f   %+15.3e   %+12.3f" % (t / G, M, rr))

    md = ["#  s26   s25  census  interpretation  (33  rows,  "
          "t/G  =  1  ..  5e7)", "",
          "rows:  %d" % len(all33[0]), "",
          "F1  (33-row):  A  =  %+.6e  B  =  %+.6e   "
          "max|res|  =  %.2f" % (A1, B1, np.max(np.abs(r1))),
          "F2  (33-row):  A  =  %+.6e  B  =  %+.6e  C  =  %+.2f  "
          "a  =  %.4f   max|res|  =  %.2f" % (p2[0], p2[1], p2[2], a2, mr2),
          "",
          "trap  calibration:  f64  u-trap  diff  grows  smoothly  "
          "~1e8 (t  ~  1e11)  ->  ~5e13  (t  ~  1.5e18):  "
          "discretization  limit  of  the  2M-point  f64  grid,  "
          "not  a  signal;  dps-40  quadrature  channel  "
          "authoritative  (integer-quantized  M  on  the  law)."]
    open(os.path.join(BASE, "tmp/s26_farcensus_fit.md"), "w").write(
        "\n".join(md) + "\n")
    print()
    print("wrote  tmp/s26_farcensus_fit.md")


if __name__ == "__main__":
    main()
