#!/usr/bin/env python
"""s22:  pure  ln  t  vs  ln  t  +  sub-log  term.

Fits  all  above-G  rows  (26  with  s21  pending;
28  after)  against  two  families:
   F1:  M  =  A  ln  t  +  B
   F2:  M  =  A  ln  t  +  B  +  C*(t/G)^a
and  reports  per-row  residuals  +  the
predictions  F1  makes  for  the  new
heights  (the  decisive  comparison).
"""
import json
import os

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = 30001045999.981975555


def load():
    rows = {}
    for f in ("s10_deadzone_march", "s9_dk_above_g", "s16_M_far",
              "s20_M_farter", "s21_M_beyond"):
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


def main():
    ts, Ms = load()
    print("rows:  %d   t/G  =  %.3f  ..  %.0f" %
          (len(ts), ts[0]/G, ts[-1]/G))
    ln = np.log(ts)
    x = ts/G

    #  F1
    co, *_ = np.linalg.lstsq(np.column_stack([ln, np.ones(len(ts))]),
                             Ms, rcond=None)
    A1, B1 = float(co[0]), float(co[1])
    r1 = A1*ln + B1 - Ms

    #  F2  (Levenberg-Marquardt  via  simple  grid + Gauss-Newton)
    def f2(p):
        A, B, C, a = p
        return A*ln + B + C*np.power(x, a) - Ms

    best = None
    Jbase = np.column_stack([ln, np.ones(len(ts))])
    for a0 in np.arange(0.025, 0.801, 0.025):
        J = np.column_stack([Jbase, np.power(x, a0)])
        cc, *_ = np.linalg.lstsq(J, Ms, rcond=None)
        F = J @ cc - Ms
        rr = float(np.max(np.abs(F)))
        if best is None or rr < best[1]:
            best = (cc, a0, rr)
    p2, a2, mr2 = best
    A2, B2, C2 = (float(v) for v in p2)
    a2 = float(a2)

    r2 = A2*ln + B2 + C2*np.power(x, a2) - Ms

    print()
    print("F1  pure  ln  t:      A  =  %+.6e  B  =  %+.6e   "
          "max|res|  =  %.2f" % (A1, B1, np.max(np.abs(r1))))
    inter = None
    for a0 in np.arange(0.10, 0.801, 0.025):
        J = np.column_stack([ln, np.ones(len(ts)), np.power(x, a0)])
        cc, *_ = np.linalg.lstsq(J, Ms, rcond=None)
        rr = float(np.max(np.abs(J @ cc - Ms)))
        if inter is None or rr < inter[1]:
            inter = (cc, a0, rr)
    print("F2  interior  a>=0.1:  (A,B,C)  =  (%+.4e,  %+.4e,  "
          "%+.2f)  a  =  %.3f   max|res|  =  %.2f"
          % (inter[0][0], inter[0][1], inter[0][2], inter[1], inter[2]))
    print("F2  unconstrained:   A  =  %+.6e  B  =  %+.6e   "
          "C  =  %+.2f  a  =  %.4f   max|res|  =  %.2f   "
          "[edge  a  =  log  re-split,  NOT  a  real  "
          "sub-log  term]" % (A2, B2, C2, a2, mr2))
    print()
    print("row-by-row  (t/G,  M,  resF1,  resF2):")
    for t, M, x1, x2 in zip(ts, Ms, r1, r2):
        print("  %10.1f   %+14.3e   %+10.3f   %+10.3f"
              % (t/G, M, x1, x2))
    md = []
    md.append("#  s22   law  family  discriminator")
    md.append("")
    md.append("rows:  %d   t/G  =  %.3f  ..  %.0f" %
              (len(ts), ts[0]/G, ts[-1]/G))
    md.append("")
    md.append("F1  pure  ln  t:  A  =  %+.6e  B  =  %+.6e   "
              "max|res|  =  %.2f" % (A1, B1, np.max(np.abs(r1))))
    md.append("F2  with  sub-log  term:  A  =  %+.6e  B  =  "
              "%+.6e  C  =  %+.2f  a  =  %.4f   "
              "max|res|  =  %.2f" % (A2, B2, C2, a2, mr2))
    open(os.path.join(BASE, "tmp/s22_family.md"), "w").write(
        "\n".join(md) + "\n")
    print()
    print("wrote  tmp/s22_family.md")


if __name__ == "__main__":
    main()
