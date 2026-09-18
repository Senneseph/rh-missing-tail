#!/usr/bin/env python3
"""day030 -- LOW-T data-territory PRE-FLIGHT probes (per
docs/LOW-T-DATA-TERRITORY-PLAN.md, "Pre-flight checks").

Run t0 = 0.5, 1, 2 FIRST, before the 200-point sweep:
- the kernel machinery at t0 < 10 (main action at s = (1/2, 0.5i)..(1/2,
  2i); pairlog with ALL zeros "far" (first zero 14.13); the R_closed
  dev grid) must behave: the margin is expected LARGE (no nearby zero,
  |zeta| ~ O(1), dev ~ O(1)) - a sanity shape, not a prediction.
- If ANY probe shows margin < 1: STOP, investigate (one problem at a
  time) before the grid.

Kernel form (the P1.1e wire, verbatim):
  K(t) = exp( main 25.2.12  +  line-product over the FINITE list
             (0, 1200]   +  density rem (1200, 1e18]  (400-cell
             geometric quad; SMOOTH: t < 1000 < 1200 - no
             singularity inside, the v3 rem concern is vacuous)
             +  ext (1e18, 1e30]  (measured by the same quad; see
             also the certified one-line bound: |ext| < 1e-10 for
             t <= 1e3, since |pairlog(g, s)| < C t^2/g^2 for g > 2t
             and int_{1e18}^{1e30} (log g/2p)/(2p g^2) dg < 1.5e-18)
  residf(t) = |zeta(1/2+it) - K(t)|
  dev(t)    = min over the 500-d grid [0.005, 0.5] (+ the pinned
              d's) of |R_closed(g, t, d) - 1|, g = nearest zero to t
  margin_new(t) = |zeta| * dev / (p8_B(t, n4) + residf)
"""
import mpmath as mp
import os
import math
import numpy as np

import day023_p11c_1e7 as M   # NOTE: this import resets mp.dps to 25
mp.mp.dps = 30               # (the 25x family's native precision);
                             # re-set AFTER the import so the whole
                             # pre-flight runs at dps-30.

REM_HI = mp.mpf("1e18")
REM_HI2 = mp.mpf("1e30")
NPTS = 400
LOW_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        "lowt", "zeros_0_to_1p2e3.f64")
G = mp.mpf("1200")

DG = [mp.mpf(k)/1000 for k in range(5, 501)]
DG_PIN = [mp.mpf(d) for d in
          (1e-8, 1e-7, 1e-6, 1e-5, 1e-4, 1e-3, 1e-2, 0.25, 0.5)]
DGALL = DG + DG_PIN


def n4(t):
    return int(math.ceil(31000000.0 * t**4))


def pairlog(g, s):
    rho1 = mp.mpc(0.5, g); rho2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/rho1) + mp.log(1 - s/rho2)
            + s/rho1 + s/rho2)


def rem_quad(s, npts=NPTS):
    """(1200, 1e18] + (1e18, 1e30] of pairlog * rho, geometric grids.
    t < 1000 < 1200: smooth on the whole range, breakpoint at 1e18."""
    def f(g):
        return pairlog(g, s) * (mp.log(g/(2*mp.pi))/(2*mp.pi))
    k1 = mp.mpf(npts)
    pts1 = [G * (REM_HI/G)**(mp.mpf(j)/k1) for j in range(npts+1)]
    Q1 = mp.quad(f, pts1)
    hi0 = REM_HI
    k2 = mp.mpf(npts/2)
    pts2 = [hi0 * (REM_HI2/hi0)**(mp.mpf(j)/k2)
            for j in range(int(npts/2)+1)]
    Q2 = mp.quad(f, pts2)
    return Q1, Q2


def line_product(s, gv):
    la, ar = M.product_on_line_vec(s, gv)
    return la, ar


def evaluate(low, t0, npts=NPTS):
    t = mp.mpf(repr(float(t0)))
    s = mp.mpc(0.5, t)
    la1, ar1 = line_product(s, low)
    if la1 is None:
        return None
    Q1, Q2 = rem_quad(s, npts)
    K = mp.e**(M.logmain25212(s)
               + mp.mpf(repr(la1)) + 1j*mp.mpf(repr(ar1))
               + Q1 + Q2)
    z = mp.zeta(s)
    residf = abs(z - K)
    # dev: nearest zero to t (for t < 14.13 the nearest is gamma_1)
    g = float(low[int(np.argmin(np.abs(low - t0)))])
    best = None
    for d in DGALL:
        v = abs(M.R_closed(mp.mpf(repr(g)), t, d) - 1)
        best = v if best is None else min(best, v)
    dev = best
    zabs = abs(z)
    mnew = float(zabs * dev / (M.p8_B(t, n4(t)) + residf))
    # S2 flag: the C1b disc floor quantity (finite, nearest zero)
    gtil = min(abs(float(low[int(np.argmin(np.abs(low - t0)))]) - t0),
               0.25)  # also vs the own pole half-gap 1/4
    s2floor = min(mp.mpf("23")/mp.mpf("1000"),
                  1 - mp.mpf("25")/mp.mpf(repr(abs(float(gtil)))))
    return {"t": float(t0), "zeta": float(zabs), "residf": float(residf),
            "dev": float(dev), "mnew": mnew, "g": g,
            "Efull": float(mp.log(zabs) - mp.re(mp.log(K))),
            "s2floor": float(s2floor)}


def run():
    low = np.load(LOW_FILE)
    print("low-t zeros loaded: %d in (0, %.0f]" % (low.size, low.max()))
    print("\nPRE-FLIGHT PROBES  t0 = 0.5, 1, 2:")
    print("  t0      zeta      residf     dev        margin_new  "
          "Efull     nearest-g  s2floor")
    ok = True
    for t0 in (0.5, 1.0, 2.0):
        r = evaluate(low, t0)
        if r is None:
            print("  %4.1f  POLE (t within 1e-13 of a zero)" % t0)
            ok = False
            continue
        print("  %4.1f  %.6f  %.6e  %.6e  %.6f  %+.3f  %.4f  %.5f"
              % (t0, r["zeta"], r["residf"], r["dev"], r["mnew"],
                 r["Efull"], r["g"], r["s2floor"]))
        if r["mnew"] < 1.0:
            ok = False
    print("\nPRE-FLIGHT: %s" % ("PASS (all margins large, proceed to "
                               "the 200-point sweep)" if ok
                               else "FAIL (margin < 1 at a probe - "
                                    "STOP, investigate first)"))
    print("\nDONE")


if __name__ == "__main__":
    run()
