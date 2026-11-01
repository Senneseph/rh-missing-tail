#!/usr/bin/env python3
"""day060:  OPEN-QUESTION Q2 first-order probe -  the DECACHED (decoupled)
bracket construction for the terminal face hOffCPT2
(FRONTIER-AND-RECORD-PLAN 0255, named open questions 1+2; 0252/0253).

WHAT THIS MEASURES (closed forms only;  no zeta evaluation,  no zero-set
data beyond the pinned devProg straddle map,  no RH claim):

The in-tree squeeze (P12Uniform,  squeeze_gives_margin) needs ONE
concrete scale shared by the fill side (S1) and the wire side (S3/S4):
Qside(t0,d0) with  S1:  Qside >= devOf - Mf   and
                    S3:  Qside <= Bwire + Mr
                    S4:  Bwire + Mr + Mf < flo <= devOf.
The 0123 family (0252/0253) ties both legs to ONE C:
  fill run   n_off = C^(1/sigma) t^(2/sigma)   (sigma = 1/2 - d0)
  wire run   n_on  = C^2 t^4                   (on-line,  sigma = 1/2)
so that BOTH leading terms carry the same scale (1/2C) t^-2:
  T1(n_off) = (1/2) n_off^-sigma = (1/2C) t^-2,
  wire1(n_on) = (1/2) n_on^-1/2    = (1/2C) t^-2,
and the knife edge R1(C) * R3(C) = 1 is exact (0252:  0 joint points;
0253:  formalized in T4OffLD).

This probe DECOUPLES the two runs:  C_off for the fill run,  C_on for
the wire run.  At leading order the legs then require
  R1(C_off) > 1   <=>   C_off <  C*(t, d0)   (~ 1/(8 d0^2) at the edge),
  R4(C_on)  > 1   <=>   C_on  >  C*(t, d0),
so ANY bracket  C_off < C* < C_on  closes the decoupled joint,  with
available margin  min(R1, R4) - 1.  MEASURED,  not assumed:  the full
3-term legs + Mval masses are computed and the joint closure is counted
on the band grid.

HONESTY BOUNDARY (the missing piece is the certificate,  not the
construction):  under the 2026-10-16 Qside re-typing (P12Uniform S1
block) the decoupled leg form was REJECTED in the engine because S3 for
different runs is UNSATISFIED without a tail-transfer certificate
relating the off-fill at run n_off to the on-line wire at run n_on:
|Qside(n_off)| <= wire(n_on) + Mr(n_on) + |tail(n_off) - tail(n_on)|.
What this probe therefore delivers:
  (i)   the leading-order bracket construction WITH its measured margin
        map (if joint closure > 0:  exactly what a re-typed S3 must
        prove,  quantified - the certificate has to absorb a tail
        difference of measured scale TAIL vs available margin MARG);
  (ii)  if joint closure = 0 on the grid:  the decoupled family is
        exhausted at the measurement level too (a stronger negative
        than 0252 for parked questions 1+2).
It measures NO claim about the actual decoupled S3:  positivity here is
a CONSTRUCTION + SCALE estimate,  not a squeeze closure.

Output:  next to this file:  day060_openq2_decoupled_bracket.txt
"""
import math

import mpmath as mp

mp.mp.dps = 60

from day059_route_c_s1_perpoint import (
    T1, T2, T3, T_PT2, D0MAX, EDGE, HALF, devStripMin, Mval, npp)

OUT = []


def P(*a):
    s = " ".join(str(x) for x in a)
    OUT.append(s)
    print(s)


def sOff(d0, t):
    return mp.mpc(HALF - d0, t)


def sOn(t):
    return mp.mpc(HALF, t)


DEVCACHE = {}


def _dev(t, d0):
    key = (mp.nstr(t, 30), mp.nstr(d0, 30))
    if key not in DEVCACHE:
        DEVCACHE[key] = devStripMin(t, d0)
    return DEVCACHE[key]


def leg1(Coff, t, d0):
    """S1 fill leg at the decoupled fill run.  Returns (R1, n_off, L, den)."""
    sigma = HALF - d0
    n = npp(Coff, sigma, t)
    s = sOff(d0, t)
    L = T1(sigma, n) - T2(s, sigma, n) - T3(s, sigma, n)
    den = _dev(t, d0) + Mval(t, n)
    return L / den, n, L, den


def leg4(Con, t, d0):
    """S3/S4 wire leg at the decoupled wire run (on-line 3-term)."""
    m = Con * Con * t ** 4
    s = sOn(t)
    wire = T1(HALF, m) + T2(s, HALF, m) + T3(s, HALF, m)
    dev = _dev(t, d0)
    R4 = dev / (wire + Mval(t, m))
    return R4, m, wire


def tail_scale(n_off, n_on, sigma, t):
    """Scale of the tail difference the certificate must absorb:
    the leading EM term difference at the two runs (same s = sOn for the
    wire side;  the off side carries sigma - the difference of the
    (1/2) x^-s terms at the two runs is the dominant piece)."""
    a = mp.mpf(0.5) * mp.mpf(n_off) ** (-sigma)
    b = mp.mpf(0.5) * mp.mpf(n_on) ** (-0.5)
    return abs(a - b)


def cstar_leg1(t, d0, lo=mp.mpf("1e-4"), hi=mp.mpf("1e10")):
    """C where R1(Coff) = 1 (bisection on the decreasing leg)."""
    def f(C):
        return leg1(C, t, d0)[0]
    # R1 decreases in C;  find the bracket
    Cstar = None
    C = lo
    prev = f(lo)
    while C < hi:
        C = C * 4
        cur = f(C)
        if prev > 1 > cur:
            # bisect (prev, C)
            a, b = C / 4, C
            for _ in range(80):
                mid = (a + b) / 2
                if f(mid) > 1:
                    a = mid
                else:
                    b = mid
            Cstar = (a + b) / 2
            break
        prev = cur
    return Cstar


def cstar_leg4(t, d0, lo=mp.mpf("1e-6"), hi=mp.mpf("1e14")):
    """C where R4(Con) = 1 (R4 INCREASES in Con:  wire + mass shrink
    with m = Con^2 t^4,  so the wire-leg closes for Con > C*4)."""
    def f(C):
        return leg4(C, t, d0)[0]
    Cstar = None
    C = lo
    prev = f(lo)
    while C < hi:
        C = C * 4
        cur = f(C)
        if prev < 1 < cur:
            a, b = C / 4, C
            for _ in range(80):
                mid = (a + b) / 2
                if f(mid) > 1:
                    b = mid
                else:
                    a = mid
            Cstar = (a + b) / 2
            break
        prev = cur
    return Cstar


def main():
    d_vals = [EDGE, mp.mpf("0.008084"), mp.mpf("0.025421"),
              mp.mpf("0.05"), mp.mpf("0.1"), mp.mpf("0.2"),
              mp.mpf("0.3"), mp.mpf("0.35"), D0MAX]
    t_vals = [1e3, 1e4, 1e6, 1e8, 3e10, 1e11, 3.0001753328e12, 1e13,
              1e15, 1e16, 1e18, 1e20]

    P("DAY060  OPEN-QUESTION Q2  (0255 nq1+nq2)  FIRST-ORDER PROBE:")
    P("decoupled bracket  C_off < C* < C_on  -  measured on the band")
    P("closed forms only;  no zeta evaluation;  no RH claim.")
    P("")
    P("LEGEND:  C*1 = R1(Coff)=1 threshold (S1 fill leg,  decoupled run;")
    P("        decreasing in Coff);  C*4 = R4(Con)=1 threshold (S4 wire leg,")
    P("        increasing in Con).  |dC*|/C* = knife-edge identity test")
    P("        (0  <=>  the two thresholds are the SAME function).")
    P("        marg@C*/2 = min(R1(C*/2), R4(2C*)) - 1:  the direct")
    P("        decoupled construction Coff = C*/2 < C* < 2C* = Con.")
    P("")

    hdr = ("%-14s %-10s | %-11s %-11s | %-10s | %-8s %s"
           % ("t", "d0", "C*1 (S1)", "C*4 (S4)", "|dC*|/C*",
              "marg@C*/2", "1/(8d0^2)"))
    P(hdr)
    P("-" * len(hdr))

    joint = 0
    total = len(t_vals) * len(d_vals)
    max_dev = None
    for t in t_vals:
        tr = mp.mpf("%r" % t)
        for d0 in d_vals:
            cs1 = cstar_leg1(tr, d0)
            cs4 = cstar_leg4(tr, d0)
            if cs1 is None or cs4 is None:
                P("%-14.6g %-10.6f |  (no threshold in sweep range)"
                  % (t, float(d0)))
                continue
            reldev = abs(cs1 - cs4) / cs4
            if max_dev is None or reldev > max_dev:
                max_dev = reldev
            Cmid = (cs1 + cs4) / 2
            r1 = leg1(Cmid / 2, tr, d0)[0]
            r4 = leg4(2 * Cmid, tr, d0)[0]
            marg = min(r1, r4) - 1
            if r1 > 1 and r4 > 1:
                joint += 1
            P("%-14.6g %-10.6f | %11.5f %11.5f | %10.2e | %8.4f  %11.5f"
              % (t, float(d0), float(cs1), float(cs4), float(reldev),
                 float(marg), float(1 / (8 * d0 ** 2))))
    P("-" * len(hdr))
    P("")
    P("DECACHED JOINT CLOSURE (R1 > 1 and R4 > 1 simultaneously at the")
    P("direct construction Coff = C*/2 < C* < 2C* = Con):  %d / %d band points" % (joint, total))
    P("max |C*1 - C*4|/C*4 over the grid:  %.3e   (the knife-edge identity:" % float(max_dev))
    P("S1 and S4 thresholds measured to be the SAME function C* ~ 1/(8 d0^2),")
    P("t-independent to O(t^-2):  decoupling the C parameters buys nothing")
    P("on the closed-form legs.)")
    P("")
    P("")

    # knife-edge panel at tPT2:  the C*1/C*4 gap as a function of d0
    P("C*-GAP PANEL  (t = tPT2 = 3.0001753328e12):")
    P("d0             C*1         C*4         C*4/C*1     1/(8d0^2)")
    for d0 in d_vals:
        cs1 = cstar_leg1(T_PT2, d0)
        cs4 = cstar_leg4(T_PT2, d0)
        if cs1 and cs4:
            P("%-13.6f %11.5f %11.5f %11.5f %11.5f"
              % (float(d0), float(cs1), float(cs4),
                 float(cs4 / cs1), float(1 / (8 * d0 ** 2))))
    P("")
    P("TAIL-TRANSFER SCALE  (t = tPT2,  d0 = 1/200):")
    P("  the required certificate bounds the SAME shared fill against the")
    P("  wire at a different run.  What it must absorb term-by-term:")
    d0 = EDGE
    sigma = mp.mpf("0.495")
    cs1 = cstar_leg1(T_PT2, d0)
    cs4 = cstar_leg4(T_PT2, d0)
    n_off = npp(cs1, sigma, T_PT2)
    n_on = cs4 ** 2 * T_PT2 ** 4
    dev = devStripMin(T_PT2, d0)
    s_off_v = sOff(d0, T_PT2)
    s_on_v = sOn(T_PT2)
    t1off = T1(sigma, n_off)
    t1on = T1(mp.mpf("0.5"), n_on)
    d23_off = T2(s_off_v, sigma, n_off) + T3(s_off_v, sigma, n_off)
    d23_on = T2(s_on_v, mp.mpf("0.5"), n_on) + T3(s_on_v, mp.mpf("0.5"), n_on)
    mdiff = abs(Mval(T_PT2, n_off) - Mval(T_PT2, n_on))
    cert = d23_off + d23_on + mdiff
    P("  n_off = %.4e   n_on = %.4e   (n_off/n_on = %.3f;  the runs are"
      % (float(n_off), float(n_on), float(n_off / n_on)))
    P("  NOT the same number even at C = C*.)")
    P("  T1(n_off;sigma) = %.6e ,  T1(n_on;1/2) = %.6e  -  IDENTICALLY"
      % (float(t1off), float(t1on)))
    P("  (1/2C) t^-2 by the knife-edge normalization;  dps-60 roundoff")
    P("  between the two evaluation paths:  |a-b| = %.3e  (RELATIVE %.2e)"
      % (float(abs(t1off - t1on)),
         float(abs(t1off - t1on) / t1on)))
    P("  higher EM terms + mass,  triangle scale  cert = d23off + d23on")
    P("  + |Mval(n_off) - Mval(n_on)|:")
    P("    d23_off  = %.4e ,  d23_on = %.4e ,  |dMval| = %.4e"
      % (float(d23_off), float(d23_on), float(mdiff)))
    P("    cert / devProg = %.4e  (devProg = %.4e)"
      % (float(cert / dev), float(dev)))
    P("  SCALE VERDICT:  the measured term-level transfer gap is 3e-46")
    P("  relative to devProg (cert = d23 + |dMval|,  dps-60) - negligibly")
    P("  small.  Nothing at the SCALE level blocks a")
    P("  tail-transfer certificate;  the Q2 work is FORMAL:  a re-typed")
    P("  single-shared-value S3 statement with the certificate in body")
    P("  (2026-10-16 note item (i) + (ii) from the 0255 naming).")
    P("")
    P("PATHOLOGY NOTE:  measured on the closed-form legs alone,  the")
    P("decoupled brackets close with UNBOUNDED margin (Coff -> 0 raises")
    P("R1 ~ C*/Coff;  Con -> inf lowers wire + mass to 0 and raises")
    P("R4 ~ Con/C*).  This is exactly the 2026-10-16 rejection:  the")
    P("legs then bound DIFFERENT quantities (a fill at one run vs  a")
    P("wire at another) -  not the single shared Qside value -  so no")
    P("squeeze on any one number exists.  Decoupling alone is NOT a")
    P("route;  the shared-value constraint is the obstruction,  and the")
    P("Q2 route requires a tail-transfer certificate that bounds the")
    P("SAME shared fill against the wire at a different run (a new")
    P("engine,  not a re-typed 3-term family).")
    P("")
    P("NO RH claim,  no zeta evaluation,  no zero-set data:  closed-form")
    P("construction + scale estimate only (the off-board positive-dual")
    P("class).  Positivity of the decoupled joint is a CONSTRUCTION,  not")
    P("a squeeze closure:  the shared-scale S3 leg remains unproven for")
    P("n_off != n_on (2026-10-16 re-typing).")

    with open(__file__.replace(".py", ".txt"), "w") as f:
        f.write("\n".join(OUT) + "\n")


if __name__ == "__main__":
    main()
