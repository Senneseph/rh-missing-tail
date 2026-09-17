#!/usr/bin/env python3
"""day029 (POST-25af) -- S1-GAP nature pre-test, VERSION 2 (full horizon).

V1 finding (4e8 row, stable across the npts ladder 200->6400): the 25x
S1-GAP resid = |zeta - K| is NOT a quad artifact (npts-invariant).  But
the E = log|zeta| - Re log K drift (-0.0006 @ 1e7 ... -3.88 @ 1e9)
tracks the missing (1e18, inf) product section: K excludes (1e18, inf)
(bound 'reported only'), whose product factor ~ exp(-t^2 ln B/(4 pi^2 B)
class, B = 1e18) grows as t^2 / 1e18 -- the 1e18 HORIZON of the kernel
model, a model-truncation artifact.  V2 folds in (1e18, 1.35e13]... no:
V2 quad-extends the same pairlog integrand over (1e18, 1e30] (400 log
nodes; the decaying region needs few) so the kernel horizon is 1e30
(remainder (1e30, inf) ~ 1 - O(t^2/1e30) < 1e-9 for t <= 1e9).

Same protocol as 25x[6], same npts ladder on the (G_LAST, 1e18] section
(regression), plus the (1e18, 1e30] extension:
  K_full = K_model * exp( Q(1e18, 1e30] )
  resid_full = |zeta - K_full|,  E_full = log|zeta| - Re log K_full
  margin_old  = |z| dev / (B_best + resid_model)      [25x regression]
  margin_old2 = |z| dev / (B_best + resid_full)
  margin_new  = |z| dev / (p8_B(t, n4) + resid_full)  [t^4 wire, full horizon]
  margin_new_m = |z| dev / (p8_B(t, n4) + resid_model) [t^4 wire, 1e18 horizon]

PRE-REGISTERED VERDICT (on margin_new, full horizon):
  (A) margin_new >= 1 at all three wall heights (4e8, 6e8, 1e9)
      -> the 25x S1-GAP = B_best list-scale P4 floor (removed by the 25af
         t^4 wire) + the (1e18, inf) horizon artifact (removed by V2):
         the S1 pointwise squeeze CLOSES through 1e9 (the data extent)
         at screen level; next unit = full refined sweep + certification
         pins + the Lean S1 wire.
  (B) margin_new < 1 at >= 2 of the 3 heights, stable across npts
      -> REAL measured S1 wall with the t^4 wire + full-horizon kernel:
         the resid_full growth is real model-defect content; the ceiling
         = the first robust sub-1 height; the Phase-1a ceiling report is
         written at that ceiling with this attribution (stronger than
         the 5.6e7 B_best statement).
  (C) non-stable / non-convergent across npts -> stronger method needed
      (higher-order tail or direct high-precision product); no verdict.

Also reported: the t^2/B law check on E_model (the missing-section
signature) and the (1e18, inf) factor exp(-E_model).
"""
import mpmath as mp
mp.mp.dps = 30
import math

import day023_p11c_1e7 as M
import day024_tail_hi1e9 as TH

DG = [mp.mpf(k)/1000 for k in range(5, 501)]
NPTS = [200, 6400]
REM_HI2 = mp.mpf("1e30")
NPTS2 = 400


def n4(t):
    return int(math.ceil(31000000.0 * t**4))


def quad_ext(t):
    """dps-30 log-quad of the pairlog density integrand over
    (1e18, 1e30] -- the missing product section in logarithmic form."""
    hi0 = mp.mpf("1e18")
    smp = mp.mpc(0.5, mp.mpf(repr(float(t))))

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp/r1) + mp.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        return p * (mp.log(gg/(2*mp.pi))/(2*mp.pi))

    k = mp.mpf(NPTS2)
    pts = [hi0 * (REM_HI2/hi0)**(mp.mpf(j)/k) for j in range(NPTS2+1)]
    return mp.quad(f, pts)


def margin_at(t, g, npts):
    s = mp.mpc(0.5, t)
    gmp = mp.mpf(repr(float(g)))
    tmm = mp.mpf(repr(float(t)))
    dev = None
    for d in DG:
        v = abs(M.R_closed(gmp, tmm, d) - 1)
        dev = v if dev is None else min(dev, v)
    z = mp.zeta(s)
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    T = TH.tail()
    re, im = T.pairlog_sum(float(t))
    rem = T.quad_rem(float(t), npts)
    tail = mp.mpf(repr(re)) + 1j*mp.mpf(repr(im)) + rem
    K = mp.e**(main + mp.mpf(repr(float(la))) + 1j*mp.mpf(repr(float(ar)))
               + tail)
    Qext = quad_ext(t)
    Kfull = K * mp.e**Qext
    B = M.B_best(tmm)
    p8n4 = M.p8_B(tmm, n4(tmm))
    resid = abs(z - K)
    residf = abs(z - Kfull)
    zabs = abs(z)
    return {"E": mp.log(zabs) - mp.re(mp.log(K)),
            "Efull": mp.log(zabs) - mp.re(mp.log(Kfull)),
            "resid": resid, "residf": residf,
            "margin_old": zabs*dev/(B + resid),
            "margin_old2": zabs*dev/(B + residf),
            "margin_new": zabs*dev/(p8n4 + residf),
            "margin_new_m": zabs*dev/(p8n4 + resid),
            "B": B, "p8n4": p8n4, "zeta": zabs, "dev": dev,
            "rext": mp.re(Qext)}


PTS = [(399999999.907, 400000000.91, "4e8"),
       (600000000.072, 600000001.07, "6e8"),
       (1000000000.12, 999999999.62, "1e9")]


def run():
    T = TH.tail()
    print("day029 V2: G_LAST = %.6f; (1e18,1e30] log-quad npts=%d"
          % (T.G_LAST, NPTS2), flush=True)
    for (g, t, lab) in PTS:
        for npts in NPTS:
            r = margin_at(t, g, npts)
            print("%-4s npts=%-5d  E=%+8.4f  Efull=%+8.4f  "
                  "resid=%12.5e  residf=%12.5e"
                  % (lab, npts, float(r["E"]), float(r["Efull"]),
                     float(r["resid"]), float(r["residf"])), flush=True)
            print("%-4s              margin_old=%8.5f  margin_old2=%8.5f  "
                  "margin_new=%8.5f  margin_new_m=%8.5f"
                  % (lab, float(r["margin_old"]), float(r["margin_old2"]),
                     float(r["margin_new"]), float(r["margin_new_m"])),
                  flush=True)
        print("%-4s | B_best=%.4f  p8_B(t,n4)=%.3e  |zeta|=%.4f dev=%.4f  "
              "Re Qext=%+.4f (|zeta|/B t^2 law check: E_model=%+.4f)"
              % (lab, float(r["B"]), float(r["p8n4"]),
                 float(r["zeta"]), float(r["dev"]), float(r["rext"]),
                 float(r["E"])), flush=True)


if __name__ == "__main__":
    run()
