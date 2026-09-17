#!/usr/bin/env python3
"""day029 -- Efull QUAD-RESOLUTION check (the H2 item, KNOWN_LIMITATIONS).

The sweep's Efull values use npts = 400 on (G_LAST, 1e18] and
NPTS2 = 400 on (1e18, 1e30] (dps-30). This check re-runs the two
quadrature sections on a npts/npts2 ladder around the anchors and
reports Efull per configuration, DIFFERENTIALLY (the main product
never moves):
  Efull(n, n2) = Efull(400, 400)
               - [Re rem(n) - Re rem(400)]
               - [Re qext(n2) - Re qext(400)].
If Efull is stable to < ~0.01 across the ladder, the sweep's Efull
(in particular +2.5839 @ 1e9, which makes 1e9 the tight window) is
resolution-stable. If it drifts, the drift IS the H2 uncertainty.
Anchors: the sweep's reported (400,400) values:
  1e9:  +2.5839  (t = 999999994.6157)
  4e8:  +0.1015  (t = 399999996.4071)
  6e8:  +0.2593  (t = 599999994.5718)
"""

import mpmath as mp

mp.mp.dps = 30
import day024_tail_hi1e9 as TH

REM_HI2 = mp.mpf("1e30")
ANCH = [(999999994.6157, 2.5839, "1e9"),
        (399999996.4071, 0.1015, "4e8"),
        (599999994.5718, 0.2593, "6e8")]
NP   = [200, 400, 800, 2000]
NP2  = [400, 1200, 2000]


def qext(t, n2):
    hi0 = mp.mpf("1e18")
    smp = mp.mpc(0.5, mp.mpf(repr(float(t))))

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp/r1) + mp.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

    k = mp.mpf(n2)
    pts = [hi0 * (REM_HI2/hi0)**(mp.mpf(j)/k) for j in range(n2+1)]
    return mp.quad(f, pts)


def main():
    T = TH.tail()
    print("t label | " +
          " ".join("remin(n=%d)" % n for n in NP) + " || " +
          " ".join("qext(n2=%d)" % n for n in NP2))
    print("Efull per configuration (differential from the (400,400) anchor):")
    for t, e0, lab in ANCH:
        re, im = T.pairlog_sum(float(t))
        rem = {}
        for n in NP:
            rem[n] = mp.re(T.quad_rem(float(t), n))
        qx = {}
        for n2 in NP2:
            qx[n2] = mp.re(qext(t, n2))
        line = "%s (E(400,400) = %+.4f):\n" % (lab, e0)
        for n in NP:
            row = []
            for n2 in NP2:
                e = e0 - (rem[n] - rem[400]) - (qx[n2] - qx[400])
                row.append("n2=%d: %+.4f" % (n2, float(e)))
            seg = "  rem n=%-5d | " % n + "   ".join(row)
            if n == 400:
                seg += "  [anchor row]"
            line += seg + "\n"
        d = max(abs(float(e0 - (rem[n]-rem[400]) - (qx[n2]-qx[400]))) - abs(e0))
                # |E(n,n2) - E(400,400)| = |dRem + dQx| computed via the
                # difference of absolute values (E0 is positive here)
        d = max(abs(float((rem[n]-rem[400]) + (qx[n2]-qx[400])))
                for n in NP for n2 in NP2)
        line += "  MAX |E - E400,400| over the ladder: %.4f%s\n" % (
            d, "  <-- RESOLUTION-STABLE" if d < 0.01
            else ("  <-- DRIFTS (this is the H2 uncertainty)"
                  if d >= 0.05 else ""))
        print(line)


if __name__ == "__main__":
    main()
