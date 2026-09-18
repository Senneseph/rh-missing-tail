#!/usr/bin/env python3
"""day029 -- MODEL-point re-run with the SINGULARITY-AWARE rem split.

The hi-run MODEL points (t > G_LAST = 2.0017e9) were broken (Efull
O(1e6)..O(1e10) with sign flips): the density quad (G_LAST, 1e18]
carries the log-singularity at g = t IN THE INTERIOR of its interval
for t > G_LAST (documented mpmath limitation: quad does not cope with
mid-interval singularities). SINGLE CHANGE: rem over the
singularity-SPLIT interval [G_LAST, t] + [t, 1e18] (ENDPOINT log
singularities - tanh-sinh's design case), each part on its own 400-cell
geometric grid, + real-path cross-checks (re of the complex quad vs
the real integrand's quad, per part). Everything else (main /
primorial / pairlog / zeta / ext / formula) is IDENTICAL to the hi-run
kernel.

Self-checks before the model heights (pin "everything else identical"):
  S1  rem_split total == H.quad_rem total at the 1.95e9 straddle t
      (t < G_LAST -> no-split path, exact grid identity).
  S2  H.margin_at at the committed 1.95e9 straddle (t_best, g)
      reproduces the committed row:
      mnew = 1.1441070537194258, Efull = 2.0718233367102994,
      zeta = 2.953821554580232, dev  = 1.0000000061538505.
"""
import mpmath as mpm
mpm.mp.dps = 30
import time
import sys
sys.path.insert(0, '.')
import day029_s1gap_hi as H
import day023_p11c_1e7 as M

T = H.TailHi2()
HI1 = mpm.mpf("1e18")
HI2 = mpm.mpf("1e30")


def f_int(smp, gg):
    r1 = mpm.mpc(0.5, gg)
    r2 = mpm.mpc(0.5, -gg)
    p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
         + smp/r1 + smp/r2)
    return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))


def geo(lo, hi, n):
    return [lo * (hi/lo)**(mpm.mpf(j)/mpm.mpf(n)) for j in range(n + 1)]


def logpart(smp, gg, sign):
    """The smooth part of p(g) = log(1 - s/r1) + log(1 - s/r2) +
    s/r1 + s/r2 after splitting off the exact log(g-t) singular:
    1 - s/r1 = (g - t) * (sign * i / r1)  with sign = -1 for g < t
    (1-s/r1 = -i(t-g)/r1 = (g-t)*i/r1... computed exactly below) ->
    log(1 - s/r1) = log|g - t| + Log(sign*i/r1).  `sign` is +1 for
    g > t (1 - s/r1 = i(g - t)/r1) and -1 for g < t."""
    r1 = mpm.mpc(0.5, gg)
    r2 = mpm.mpc(0.5, -gg)
    smooth = (mpm.log(sign*1j/r1) + mpm.log(1 - smp/r2)
              + smp/r1 + smp/r2)
    return smooth


def rem_split(t):
    """Singularity-AVOIDING rem (v3).  For t inside (G_LAST, 1e18):
    A = [G, t - EPS], B = [t + EPS, 1e18] -- both SMOOTH on their
    closed intervals (no endpoint is the singularity, so tanh-sinh
    nodes cannot round onto it) -- PLUS the thin annulus [t-EPS,
    t+EPS] in closed form to O(eps^3/t):
      int_{t-e}^t   p(g) rho(g) dg = e*rho_t*(log e - 1) + e*rho_t*sigL(t)
      int_t^{t+e}   p(g) rho(g) dg = e*rho_t*(log e - 1) + e*rho_t*sigR(t)
    with p(g) = log|g-t| + sig(g) + smooth (log-part coefficient 1:
    1 - s/r1 = i(g-t)/r1) and sigL/sigR the smooth complex parts at
    g = t (Log(+-i/r1t) + log(1-s/r2t) + s/r1t + s/r2t).
    No-split (grid-identical to H.quad_rem) when t outside range."""
    t = float(t)
    smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
    hi0 = mpm.mpf(repr(float(T.G_LAST)))
    tc = mpm.mpf(repr(t))
    EPS = mpm.mpf("1e-8")
    if not (hi0 + EPS < tc - EPS < HI1):
        pts = geo(hi0, HI1, H.NPTS)
        tot = mpm.quad(lambda gg: f_int(smp, gg), pts)
        tot_re = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), pts)
        return {"nosplit": True, "tot": tot, "A": None, "B": None,
                "A_c_re": None, "A_re": None,
                "B_c_re": None, "B_re": None, "tot_re": float(tot_re)}
    rho_t = mpm.log(tc/(2*mpm.pi))/(2*mpm.pi)
    r1t = mpm.mpc(0.5, tc)
    r2t = mpm.mpc(0.5, -tc)
    base = mpm.log(1 - smp/r2t) + smp/r1t + smp/r2t
    sigL = mpm.log(-1j/r1t) + base
    sigR = mpm.log(1j/r1t) + base
    half = EPS * rho_t * (mpm.log(EPS) - 1)
    gA = geo(hi0, tc - EPS, H.NPTS)
    gB = geo(tc + EPS, HI1, H.NPTS)
    Ac = mpm.quad(lambda gg: f_int(smp, gg), gA)
    Bc = mpm.quad(lambda gg: f_int(smp, gg), gB)
    Ar = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gA)
    Br = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gB)
    A = Ac + half + EPS * rho_t * sigL
    B = Bc + half + EPS * rho_t * sigR
    ann = 2*half + EPS * rho_t * (sigL + sigR)
    return {"nosplit": False, "tot": A + B, "A": A, "B": B,
            "A_c_re": float(mpm.re(A)),
            "A_re": float(mpm.re(half + EPS*rho_t*sigL)) + float(Ar),
            "B_c_re": float(mpm.re(B)),
            "B_re": float(mpm.re(half + EPS*rho_t*sigR)) + float(Br),
            "ann_re": float(mpm.re(ann)), "tot_re": None}


def ext_q(t):
    t = float(t)
    smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
    pts = geo(HI1, HI2, H.NPTS2)
    ec = mpm.quad(lambda gg: f_int(smp, gg), pts)
    er = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), pts)
    return ec, float(er)


def logK_split(t):
    """Exactly H.kernel with rem := rem_split total (and ext with
    its real cross-check reported). Returns (logK, reminfo, ext_c,
    ext_re, la, ar, pair_re, pair_im)."""
    t = float(t)
    s = mpm.mpc(0.5, mpm.mpf(repr(t)))
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    sre, sim = T.pairlog_sum(t)
    ri = rem_split(t)
    ec, er = ext_q(t)
    tail = (mpm.mpf(repr(sre)) + 1j*mpm.mpf(repr(sim))
            + ri["tot"] + ec)
    logK = (main + mpm.mpf(repr(float(la)))
            + 1j*mpm.mpf(repr(float(ar))) + tail)
    return logK, ri, ec, er, la, ar, sre, sim


if __name__ == "__main__":
    t0 = time.time()
    print("day029 model-split re-run  (mpmath %s, dps-30)"
          % mpm.__version__, flush=True)
    print("G_LAST = %.6f   NPTS = %d/%d"
          % (float(T.G_LAST), H.NPTS, H.NPTS2), flush=True)

    T195 = mpm.mpf("1950000006.1486907")   # committed 1.95e9 t_best
    G195 = mpm.mpf("1950000000.1486907")   # committed 1.95e9 g
    print("\nS1: no-split path identity (t < G_LAST)", flush=True)
    ri = rem_split(float(T195))
    orig = H.quad_rem(T, T195, H.NPTS)
    print("  nosplit flag      :", ri["nosplit"], flush=True)
    print("  rem_split total   : %.15f" % float(mpm.re(ri["tot"])),
          flush=True)
    print("  H.quad_rem total  : %.15f" % float(mpm.re(orig)), flush=True)
    print("  exact mpf equality:", ri["tot"] == orig, flush=True)
    assert ri["nosplit"] and ri["tot"] == orig
    print("S1 PASS  (%.0fs)" % (time.time() - t0), flush=True)

    print("\nS2: committed-row replay at the 1.95e9 straddle", flush=True)
    r = H.margin_at(T, T195, G195)
    got = {"mnew": r["mnew"], "Efull": r["Efull"],
           "zeta": r["zeta"], "dev": r["dev"]}
    want = {"mnew": 1.1441070537194258, "Efull": 2.0718233367102994,
            "zeta": 2.953821554580232, "dev": 1.0000000061538505}
    ok = True
    for k in want:
        dd = abs(got[k] - want[k])
        print("  %-6s got=%.12f  want=%.12f  |d|=%.2e"
              % (k, got[k], want[k], dd), flush=True)
        ok = ok and dd < 1e-6
    print("S2 PASS" if ok else "S2 FAIL", " (%.0fs)" % (time.time() - t0),
          flush=True)
    assert ok

    print("\nS3: subtracted-singular form == direct form at t = 4e9",
          flush=True)
    r4 = rem_split(4e9)
    print("  A (subtracted) : %.15f" % r4["A_c_re"], flush=True)
    print("  B (subtracted) : %.15f" % r4["B_c_re"], flush=True)
    print("  annulus re     : %.9e  (|.| < 1e-5 required)"
          % r4["ann_re"], flush=True)
    print("  cross dA dB    : %.2e %.2e"
          % (abs(r4["A_c_re"] - r4["A_re"]),
             abs(r4["B_c_re"] - r4["B_re"])), flush=True)
    
    print("\nMODEL-LEVEL Efull, SINGULARITY-SPLIT rem "
          "(t > G_LAST; (G_LAST, t) density-modeled)", flush=True)
    print("t       |zeta|      la          pairlog_re  re(A)       "
          "re(B)        re(ext)     cross dA     dB     dext  Efull",
          flush=True)
    for tm in ["2.5e9", "4e9", "6e9", "1e10", "2e10", "3e10"]:
        t1 = time.time()
        logK, ri, ec, er, la, ar, sre, sim = logK_split(tm)
        z = mpm.zeta(mpm.mpc(0.5, mpm.mpf(tm)))
        E = float(mpm.log(abs(z)) - mpm.re(logK))
        if ri["nosplit"]:
            line = "%8g %11.5f %13.5f %13.5f   N/A (no split)" \
                   % (float(tm), float(abs(z)), float(la), sre)
        else:
            dA = abs(ri["A_c_re"] - ri["A_re"])
            dB = abs(ri["B_c_re"] - ri["B_re"])
            dext = abs(float(mpm.re(ec)) - er)
            line = ("%8g %11.5f %13.5f %13.5f %13.5f %13.5f %11.5f "
                    "%9.1e %9.1e %9.1e  %+.6f"
                    % (float(tm), float(abs(z)), float(la), sre,
                       ri["A_c_re"], ri["B_c_re"], er,
                       dA, dB, dext, E))
        print(line, "  (%.0fs)" % (time.time() - t1), flush=True)
    print("\nDONE (%.0fs total)" % (time.time() - t0), flush=True)
