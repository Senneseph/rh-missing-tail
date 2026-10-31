#!/usr/bin/env python3
"""day059:  ROUTE-(c) probe  -  the S1 fill-lower-bound leg at the
per-point witness run, measured on the band (RECORD-REQUIREMENTS 0251,
route (c); 0126 S10 next-unit, candidate (C) pins+certificate).

CONTEXT:  after 0125/0126 the in-tree analytic left face dissolved and
the terminal residual is the band zero-exclusion face hOffCPT2
(no off-pair on [tPT2, inf) x (0, posReserveD0max]).  The squeeze
window [devProg, wire] is EMPTY IN BODY (t4l_bandEmpty, 0126): at a
band off-pair the fill must satisfy S1 (fill >= devProg, the S1Ge
chain  ||zeta-K|| >= devW - Mval  with devW the measured EM kernel
change, Mval the A4.3/P5 mass) and S3 (fill <= wire), while S4 in
body + S2 give wire + Mr + Mf < floor <= devProg.  Route (c) asks
whether the per-point witness run  n = C^(1/sigma) t^(2/sigma),
sigma = 1/2 - d0  (0123 family;  058e threshold C > 5000 for the
S3/S4 side),  ALSO satisfies the S1 side:

    ||W_n(s, n_pp)||  >=  devProg(t, d0) + Mval(t, n_pp)          (S1leg)

at every band point  (t, d0)  in  [tPT2, inf) x [1/200, 0.3733819666133].

WHAT IS COMPUTED (closed forms only;  no zeta evaluation, no zero-set
data, no RH claim):
  * W-wall:  p4_em_expr s n = -1/2 n^-s + (s/12) n^-s-1
                   - 1/2 INT_n^inf B2hat*s(s+1)x^-s-2 dx
    is bounded (T4Off.p4_T4_bound_gen, LEAN-PROVEN) by the 3-term
    T1 + T2 + T3;  hence the RIGOROUS LOWER bound
       ||W_n|| >= T1 - T2 - T3     (triangle, phase-free),
    T1 = (1/2) n^-sigma,  T2 = ||s||/12 n^-sigma-1,
    T3 = (sqrt3/216) ||s(s+1)(s+2)|| n^-(sigma+2)/(sigma+2),
    at the off-line trial point  s = (1/2 - d0) + it.
  * devProg  =  devStripMin (B4/B5 port, s35b):  min(own, 48
    straddle |Rratio - 1|)  at the pair's own height t.
  * Mval  =  Zbound(t) e^Xval Xval  (the S4Asm MrR mass shape at the
    run n:  Xval = Bf(t,n)(Sbar(2n)+Sbar(n)) + Cf(t,n)Kbar(n),
    the B3Sbar b3BoundExplicit RHS at G = n, B = 2n - the 25aa
    family ratio).
  * The S3/S4 side at the per-point run (the 058e wall):
    wire_pp = the ON-LINE 3-term at the on-line per-point run
    n_lin = C^2 t^4  (T1lin = (1/2C) t^-2)  + Mval(n_lin),
    compared to devProg  (S3leg = dev > wire_pp;  the T4OffLC pins
    the same margin in Lean as exact rationals).

VERDICT MAP:  for each (t, d0):
    R1(C) = (T1 - T2 - T3) / (devProg + Mval(n_pp))      (S1leg)
    R3(C) = devProg / (wire_pp + Mval(n_lin))            (S3leg)
    joint closure  <=>  R1 > 1  and  R3 > 1  for a single C.

PREDICTION (checked by the run):  at the band edge d0 = 1/200,
asymptotically in t:  devProg ~ floor ~ 4 d0^2 t^-2 = 1e-4 t^-2, and
both legs concentrate at the C-dependent scale (1/2C) t^-2:
    R1 > 1  iff  C < 5000,      R3 > 1  iff  C > 5000,
so NO C in the family closes both legs at the edge:  the
window-emptiness fact (t4l_bandEmpty) in its per-point, quantified,
two-sided knife-edge form.  The 058e C > 5000 closure is one-sided
(S3/S4 only);  the S1 side there fails by (2C - 10000)/10000 at the
edge (2e-4 at C = 5001) and the deficit grows monotonically in d0.

Output:  next to this file:  day059_route_c_s1_perpoint.txt
"""
import math

import mpmath as mp

mp.mp.dps = 60
OUT = []


def P(*a):
    s = " ".join(str(x) for x in a)
    OUT.append(s)
    print(s)


T_PT2 = mp.mpf("3000175332800")
D0MAX = mp.mpf("0.3733819666133")          # posReserveD0max
HALF = mp.mpf("0.5")
SQRT3 = mp.sqrt(3)
EDGE = mp.mpf(1) / 200

# ------------------------------------------------------------------
#  ports from tmp/s35b_leftflank_precheck.py  (validated against the
#  Lean B4/B5/S4Strip/P8Floor/T4Off pins)
# ------------------------------------------------------------------

def T1(sig, n):
    return mp.mpf(0.5) * n ** (-sig)


def T2(s, sig, n):
    return (abs(s) / 12) * n ** (-sig - 1)


def T3(s, sig, n):
    return (SQRT3 / 216) * abs(s * (s + 1) * (s + 2)) * \
        n ** (-(sig + 2)) / (sig + 2)


def _M(x):
    return x if isinstance(x, mp.mpf) else mp.mpf("%r" % x)


def sLine(t):
    return mp.mpc(mp.mpf("0.5"), _M(t))


def fac(rho, s):
    return (1 - s / rho) * mp.exp(s / rho)


def pairProd(g, t):
    s = sLine(t)
    rg = _M(g)
    return fac(mp.mpc(HALF, rg), s) * fac(mp.mpc(HALF, -rg), s)


def poff(g, d, t):
    s = sLine(t)
    gr = _M(g)
    dr = _M(d)
    rPP = mp.mpc(HALF + dr, gr)
    rPM = mp.mpc(HALF + dr, -gr)
    rNP = mp.mpc(HALF - dr, gr)
    rNM = mp.mpc(HALF - dr, -gr)
    return fac(rPP, s) * fac(rPM, s) * fac(rNP, s) * fac(rNM, s)


def Rratio(g, d, t):
    return poff(g, d, t) / pairProd(g, t)


def strideU(k):
    # S1LowT.strideU :  k = 0..47  ->  u = 0.5*(k+1) for k<24,
    #                    -0.5*(k-23) otherwise   (the 48 straddles)
    return mp.mpf(0.5) * (k + 1) if k < 24 else -mp.mpf(0.5) * (k - 23)


def devStripMin(g, d):
    m = abs(poff(g, d, g))
    for k in range(48):
        m = min(m, abs(Rratio(g, d, g + strideU(k)) - 1))
    return m


def Sbar(x):
    return 0.110 * mp.log(x) + 0.290 * mp.log(mp.log(x)) + 2.290


def Bf(t, G):
    u = G * G + mp.mpf("0.25")
    ww = t * t + mp.mpf("0.25")
    return 1.0 / (2 * u) + (ww / u) / (1 - ww / u) + t / u


def Cf(t, G):
    return 1 + 2 * (t * t + mp.mpf("0.25")) * G * G / (G * G - t * t)


def Kbar(G):
    return (0.110 * (mp.log(G) + mp.mpf("0.5"))
            + 0.290 * (mp.log(mp.log(G)) + mp.mpf("0.5")) + 2.290) / (2 * G * G)


def Xval(t, n):
    return Bf(t, n) * (Sbar(2 * n) + Sbar(n)) + Cf(t, n) * Kbar(n)


def Zbound(t):
    return 1.6 * t ** mp.mpf("0.25") * mp.log(t)


def Mval(t, n):
    x = Xval(t, n)
    return Zbound(t) * mp.exp(x) * x

# ------------------------------------------------------------------
#  the per-point run  n = C^(1/sigma) t^(2/sigma)  (058e witness)
# ------------------------------------------------------------------

def npp(C, sigma, t):
    ln = (mp.log(C) + 2 * mp.log(t)) / sigma
    return mp.e ** ln


def point(t, d0, C):
    sigma = HALF - d0
    sL = mp.mpc(HALF - d0, t)
    n = npp(C, sigma, t)
    w1, w2, w3 = T1(sigma, n), T2(sL, sigma, n), T3(sL, sigma, n)
    wall_lo = w1 - w2 - w3                  # rigorous ||W_n|| lower bound
    dev = devStripMin(t, d0)
    m_pp = Mval(t, n)
    # on-line per-point run (sigma = 1/2):  n_lin = C^2 t^4
    sO = mp.mpc(HALF, t)
    nlin = C * C * t ** 4
    w1l, w2l, w3l = T1(HALF, nlin), T2(sO, HALF, nlin), T3(sO, HALF, nlin)
    m_lin = Mval(t, nlin)
    wire_pp = w1l + w2l + w3l               # on-line 3-term at n_lin
    r1 = wall_lo / (dev + m_pp)             # S1leg:  > 1  closes
    r3 = dev / (wire_pp + m_lin)            # S3leg:  > 1  closes
    return wall_lo, dev, m_pp, wire_pp + m_lin, r1, r3

# ------------------------------------------------------------------


def main():
    d_vals = [EDGE, mp.mpf("0.008084"), mp.mpf("0.025421"),
              mp.mpf("0.05"), mp.mpf("0.1"), mp.mpf("0.2"),
              mp.mpf("0.3"), D0MAX]
    t_vals = [1e3, 1e4, 1e5, 1e6, 1e7, 1e8, 1e9, 1e10, 3e10, 1e11,
              3.0001753328e12, 1e13, 1e14, 1e15, 1e16]
    C_list = [mp.mpf(1), mp.mpf(10), mp.mpf(100), mp.mpf(500),
              mp.mpf(1000), mp.mpf(2500), mp.mpf("4999.5"), mp.mpf(5000),
              mp.mpf(5001), mp.mpf("5100"), mp.mpf(10000), mp.mpf("1e8")]

    P("DAY059  ROUTE-(c) S1 FILL-LOWER-BOUND PROBE  (closed forms only)")
    P("band:  1/200 <= d0 <= posReserveD0max = 0.3733819666133,  t >= 1000")
    P("run:   n = C^(1/sigma) t^(2/sigma),  sigma = 1/2 - d0")
    P("R1 = (T1-T2-T3)/(devProg+Mval(pp))   S1leg :  R1 > 1  closes")
    P("R3 = devProg/(wire_pp+Mval(lin))     S3leg :  R3 > 1  closes")
    P("")

    hdr = ("%-13s  %-11s | %-10s %-10s | %-10s %-10s"
           % ("t", "d0", "R1 C=4999.5", "R1 C=5001", "R3 C=4999.5",
              "R3 C=5001"))
    P(hdr)
    P("-" * len(hdr))

    joint_hits = []
    min_r1_5001 = None
    min_r1_loc = None
    for t in t_vals:
        tr = mp.mpf("%r" % t)
        for d0 in d_vals:
            r49995 = point(tr, d0, mp.mpf("4999.5"))
            r5001 = point(tr, d0, mp.mpf(5001))
            P("%-13.6g  %-11.6f | %10.8f %10.8f | %10.8f %10.8f"
              % (t, float(d0), float(r49995[4]), float(r5001[4]),
                 float(r49995[5]), float(r5001[5])))
            if r5001[4] < 1 and (min_r1_5001 is None
                                 or r5001[4] < min_r1_5001):
                min_r1_5001 = r5001[4]
                min_r1_loc = (t, float(d0))
            for C in C_list:
                r = point(tr, d0, C)
                if r[4] > 1 and r[5] > 1:
                    joint_hits.append((t, float(d0), float(C),
                                       float(r[4]), float(r[5])))
    P("-" * len(hdr))
    P("")
    P("JOINT CLOSURE (R1>1 and R3>1, any C in sweep):  %d point(s)"
      % len(joint_hits))
    for h in joint_hits[:20]:
        P("   t=%-13.6g d0=%-11.6f C=%-12.5f R1=%.8f R3=%.8f" % h)
    P("worst S1 deficit at C=5001:  R1 = %.10f  at t=%s d0=%s"
      % (float(min_r1_5001), min_r1_loc[0], min_r1_loc[1])
      if min_r1_5001 is not None else
      "S1 closes everywhere at C=5001")
    P("")

    # knife-edge section at the band edge, t = tPT2, C-sweep
    P("KNIFE-EDGE  (t = tPT2 = 3.0001753328e12,  d0 = 1/200):")
    P("C             R1 (S1leg)        R3 (S3leg)     joint")
    for C in C_list:
        r = point(T_PT2, EDGE, C)
        joint = "YES" if (r[4] > 1 and r[5] > 1) else "no"
        P("%13.5f   %16.10f %16.10f   %s"
          % (float(C), float(r[4]), float(r[5]), joint))
    P("")

    # t-behaviour at the edge (should be nearly t-independent)
    P("EDGE T-BEHAVIOUR  (d0 = 1/200,  C = 5001):")
    P("t                 R1             R3             dev          wall")
    for t in [1e3, 1e6, 1e9, 3.0001753328e12, 1e15, 1e16]:
        r = point(mp.mpf("%r" % t), EDGE, mp.mpf(5001))
        P("%-16.6g %.12f %.12f %.6e %.6e"
          % (t, float(r[4]), float(r[5]), float(r[1]), float(r[0])))
    P("")

    # d0-behaviour at tPT2 (the deficit growth in d0)
    P("D0-BEHAVIOUR  (t = tPT2,  C = 5001):")
    P("d0             R1             R3")
    for d0 in [EDGE, mp.mpf("0.005"), mp.mpf("0.01"), mp.mpf("0.05"),
               mp.mpf("0.1"), mp.mpf("0.2"), mp.mpf("0.3"), D0MAX]:
        r = point(T_PT2, d0, mp.mpf(5001))
        P("%-12.6f %.12f %.12f" % (float(d0), float(r[4]), float(r[5])))
    P("")

    # uniform n4 comparison (the legacy 0121 t^(4 d0) collapse)
    P("UNIFORM-N4 REFERENCE  (d0 = 1/200;  n4 = ceil(3.1e7 t^4)):")
    P("t                R1@n4 (S1leg)    npp/n4 (C=5001)")
    for t in [1e9, 1e11, 3.0001753328e12, 1e14, 1e16]:
        tr = mp.mpf("%r" % t)
        sigma = mp.mpf(199) / 400
        dev = devStripMin(tr, EDGE)
        n4 = mp.ceil(mp.mpf("31000000") * tr ** 4)
        sL = mp.mpc(sigma, tr)
        m4 = Mval(tr, n4)
        r1n4 = (T1(sigma, n4) - T2(sL, sigma, n4)
                - T3(sL, sigma, n4)) / (dev + m4)
        rpp = npp(mp.mpf(5001), sigma, tr)
        P("%-16.6g %.6e     %.3e" % (t, float(r1n4), float(rpp / n4)))
    P("")
    P("NO RH claim, no zeta evaluation, no zero-set data:  closed-form")
    P("margin record only (the off-board positive-dual class, 0244-0250).")

    with open(__file__.replace(".py", ".txt"), "w") as f:
        f.write("\n".join(OUT) + "\n")


if __name__ == "__main__":
    main()
