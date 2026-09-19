#!/usr/bin/env python3
"""day033 -- ITEM 6: the d < 1/200 sharper d-dependent floor (25af residual (3)).

25af S4Strip.st_mownfloor proves F4*t^-2 <= mown(t, d) using only
d >= 1/200 (F4 = 10^8/(10^6+1)^2, the t = 1000 floor of the proven
atom hMownScaleLo: (4 d^2/t^2)*(t^2/(t^2+1))^2 <= mown).  25af [7]
measured the TRUE squeeze edge d* = 0.004738 < 1/200.  This study
supplies the sharper d-dependent floor at the bound level:

EXACT ALGEBRA (all closed forms from S4Own.lean, mirrored exactly):
  A = t^2 + (1/2 + d)^2,  B = t^2 + (1/2 - d)^2
  c = (1/2+d)/A + (1/2-d)/B  > 0   (so e^c > 1: the floor DROPS it)
  mown(t, d) = d^2 (d^2 + 4 t^2) / (A B) * e^c
             = 4 d^2 * u (u + a) / (u^2 + c0 u + d0) * e^c
  with u = t^2, a = d^2/4, c0 = 2 d^2 + 1/2, d0 = (1/4 - d^2)^2
  (check: d^2 (d^2 + 4 t^2) = 4 d^2 t^2 (1 + d^2/(4t^2)) = 4 d^2 u(u+a);
   A B = (t^2 + (1/2+d)^2)(t^2 + (1/2-d)^2)
        = t^4 + t^2 (2 d^2 + 1/2) + (1/4 - d^2)^2).

  SHARPNESS: g(u) = u(u+a)/(u^2 + c0 u + d0) is STRICTLY increasing
  in u for all u > 0 (all 0 < d < 1/2):
    g'(u) * denom^2 = (c0 - a) u^2 + 2 d0 u + a d0 > 0
  (c0 - a = (7/4) d^2 + 1/2 > 0, d0 > 0 for d < 1/2, a >= 0).
  Hence, with u0 = 10^6 (t = 1000):
    mown(t, d) >= F_sharp(d) * t^-2,   all t >= 1000, 0 < d < 1/2,
  F_sharp(d) = 4 d^2 * u0 (u0 + a) / (u0^2 + c0 u0 + d0)
             = 4u (10^6 + u/4) 10^6 / (10^12 + 10^6 (2u + 1/2)
                                       + (1/4 - u)^2),  u = d^2,
  an EXACT rational function of u = d^2.

FLOOR-LEVEL SQUEEZE EDGE: the W-side cap is Cw = A1 + (A2 + A3 +
25/10^15)/1000 (day028 exact rationals, A1 = 8981/10^8, A2 = 5/10^13,
A3 = 1/10^20; the t^-5.. t^-19/4 terms folded at /1000, st_hSQ), so
the squeeze WUB + Mterm < F_sharp(d) t^-2 <= mown(t, d) closes for
F_sharp(d) > Cw, i.e. (quadratic in u = d^2, exact coefficients):
  P(u) = (Cw - 10^6) u^2 + ((2*10^6 - 1/2) Cw - 4*10^12) u
         + Cw (10^12 + 5*10^5 + 1/16) = 0
  (P(0) > 0, P -> -inf: exactly one positive root u_F, d_F = sqrt(u_F)).

The certified output brackets d_F in 10-decimal rationals with strict
margins, compares against the data-level d* = 0.004738 (25af [7]) and
the old edge 1/200, quantifies the F_sharp improvement over F4 at
d = 1/200, and cross-checks the true mown (mpmath dps-30 closed form)
against F_sharp and Cw on a d-grid across the gap.
"""
import math
from fractions import Fraction
import mpmath as mpm
mpm.mp.dps = 30

U0 = 10 ** 6                      # t = 1000 floor
K = Fraction(10 ** 12) + Fraction(5 * 10 ** 5) + Fraction(1, 16)

# day028 exact rationals (S4Strip section 0)
A1 = Fraction(8981, 10 ** 8)
A2 = Fraction(5, 10 ** 13)
A3 = Fraction(1, 10 ** 20)
MT = Fraction(25, 10 ** 15)
CW = A1 + (A2 + A3 + MT) / 1000

# F4 (the old d >= 1/200 floor coefficient): 10^8 / (10^6 + 1)^2
F4 = Fraction(10 ** 8, (10 ** 6 + 1) ** 2)


def F_sharp(u):
    """F_sharp(d^2) as exact Fraction (u: Fraction)."""
    u = Fraction(u)
    num = 4 * u * (U0 + u / 4) * U0
    den = U0 ** 2 + U0 * (2 * u + Fraction(1, 2)) + (Fraction(1, 4) - u) ** 2
    return num / den


def P(u):
    """exact crossing polynomial, u = d^2."""
    u = Fraction(u)
    a2 = CW - U0
    a1 = (2 * U0 - Fraction(1, 2)) * CW - 4 * U0 ** 2
    a0 = CW * K
    return a2 * u * u + a1 * u + a0


def F4_of_u(u):
    """the old-atom coefficient sharpened the same way the Lean floor
    builds it: 4u * (u0/(u0+1))^2  (hMownScaleLo at the t = 1000 edge)."""
    u = Fraction(u)
    return 4 * u * (Fraction(U0, U0 + 1) ** 2)


if __name__ == "__main__":
    print("=" * 72)
    print("day033 -- the d < 1/200 sharper d-dependent floor (item 6)")
    print("exact rational algebra (Fraction) + mpmath dps-30 cross-check")
    print("=" * 72)
    print()
    print("[0] W-side cap (day028 exact rationals):")
    print("  A1 = %s = %.15e  (strict upper of (1/2)(3.1e7)^(-1/2) = %.15e)"
          % (A1, float(A1), 0.5 / math.sqrt(3.1e7)), flush=True)
    print("  Cw = A1 + (A2+A3+MT)/1000 = %s = %.17e" % (CW, float(CW)),
          flush=True)
    print("  F4 (old floor, d >= 1/200)                = %.15e" % float(F4),
          flush=True)
    print("  Cw < F4 ?  %s   (the 25af strict line, restated)"
          % (CW < F4), flush=True)

    print()
    print("[1] F_sharp sharpens F4 at d = 1/200:")
    u_edge = Fraction(1, 200) ** 2
    Fr_edge = F_sharp(u_edge)
    F4u_edge = F4_of_u(u_edge)
    print("  F_sharp(1/40000)              = %.15e" % float(Fr_edge),
          flush=True)
    print("  4u*(10^6/10^6+1)^2 (same way) = %.15e  (= F4)" % float(F4u_edge),
          flush=True)
    print("  F_sharp - F4  = %+.3e  (relative %+.6e)"
          % (float(Fr_edge - F4u_edge),
             float((Fr_edge - F4u_edge) / F4u_edge)), flush=True)
    print("  F_sharp(1/40000) > 4u*(10^6/(10^6+1))^2 :  %s"
          % (Fr_edge > F4u_edge), flush=True)

    print()
    print("[2] floor-level squeeze edge: P(u) = 0, u = d^2 (exact):")
    a2 = CW - U0
    a1 = (2 * U0 - Fraction(1, 2)) * CW - 4 * U0 ** 2
    a0 = CW * K
    print("  P(u) = %.12e u^2 + %.12e u + %.12e"
          % (float(a2), float(a1), float(a0)), flush=True)
    # exact bisection bracket (P(0) > 0, P decreasing on the positive
    # root side: P(u_F) = 0, P > P' ... just bisect with signs)
    lo = Fraction(0)
    hi = Fraction(1, 10000)     # P(1e-4)? check signs
    assert P(lo) > 0
    assert P(hi) < 0, float(P(hi))
    for _ in range(120):
        mid = (lo + hi) / 2
        if P(mid) > 0:
            lo = mid
        else:
            hi = mid
    u_lo, u_hi = lo, hi
    # 10-decimal rational brackets on d = sqrt(u), exact Fraction checks
    from math import isqrt
    S = 10 ** 10
    mm = int(math.sqrt(float(u_lo)) * S)
    while Fraction(mm, S) ** 2 > u_lo:
        mm -= 1
    while Fraction(mm + 1, S) ** 2 <= u_lo:
        mm += 1
    d10_lo = Fraction(mm, S)
    mn = int(math.sqrt(float(u_hi)) * S)
    while Fraction(mn, S) ** 2 < u_hi:
        mn += 1
    while Fraction(mn - 1, S) ** 2 >= u_hi:
        mn -= 1
    d10_hi = Fraction(mn, S)
    print("  u_F = d_F^2 in [ %.15e, %.15e ]  (exact Fraction bracket)"
          % (float(u_lo), float(u_hi)), flush=True)
    print("  d_F in [ %s, %s ] = [ %.10f, %.10f ]"
          % (d10_lo.numerator, d10_lo.denominator,
             float(d10_lo), float(d10_hi)), flush=True)
    print("  certified: d_F >= r1 = %s  (%.10f)"
          % (d10_lo, float(d10_lo)), flush=True)
    r1 = d10_lo
    # BOTH margins, honestly: r1 (floor) is below the edge, r2 (ceil) is
    # above it -- the SAFE certified edge is r2, not r1.
    F_at_r1 = F_sharp(r1 * r1)
    marg_r1 = F_at_r1 - CW
    F_at_r2 = F_sharp(d10_hi * d10_hi)
    marg_r2 = F_at_r2 - CW
    print("  F_sharp(r1^2) - Cw = %+.3e   (r1 below edge: negative, as "
          "designed by the floor)" % float(marg_r1), flush=True)
    assert marg_r2 > 0
    print("  F_sharp(r2^2) - Cw = %+.3e   (r2 above edge: the SAFE "
          "certified edge)" % float(marg_r2), flush=True)
    # working edge with a norm_num-friendly exact margin:
    r2p = Fraction(47384091, 10 ** 10)     # 0.0047384091 = r2 + 1e-9
    marg_r2p = F_sharp(r2p * r2p) - CW
    assert marg_r2p > 0, float(marg_r2p)
    print("  working edge r2' = 47384091/10^10 = 0.0047384091:")
    print("    F_sharp(r2'^2) - Cw = %+.4e  (exact positive rational "
          "margin)" % float(marg_r2p), flush=True)
    dstar_lo = Fraction(47375, 10 ** 7)     # 0.0047375
    dstar_hi = Fraction(47385, 10 ** 7)     # 0.0047385
    inside = (dstar_lo >= d10_lo) and (dstar_hi <= d10_hi)
    print("  relation to data-level d* = 0.004738 (25af [7], printed):")
    print("    d* interval (0.0047375, 0.0047385) vs certified d_F "
          "bracket: %s" % ("CONTAINED" if inside else "compare below"),
          flush=True)
    F_at_dstar = F_sharp(dstar_hi ** 2)
    print("    F_sharp(0.0047385^2) - Cw = %+.3e  (sign = does the bound"
          " level cover the data edge?)" % float(F_at_dstar - CW), flush=True)
    print("    gap 1/200 - d_F:  %.4f - %.4f = %.4f  (%.2f%% of 1/200)"
          % (float(Fraction(1, 200)), float(d10_lo),
             float(Fraction(1, 200) - d10_lo),
             100 * float(Fraction(1, 200) - d10_lo) / float(Fraction(1, 200))),
          flush=True)

    print()
    print("[3] mpmath dps-30 cross-check (true mown closed form vs the")
    print("    floors).  t = 1000 (floor worst case) and t = 1e5:")

    def mown_mp(t, d):
        tm = mpm.mpf(t)
        dm = mpm.mpf(repr(d))
        A = tm * tm + (mpm.mpf("0.5") + dm) ** 2
        B = tm * tm + (mpm.mpf("0.5") - dm) ** 2
        c = (mpm.mpf("0.5") + dm) / A + (mpm.mpf("0.5") - dm) / B
        return (dm * dm * (dm * dm + 4 * tm * tm) / (A * B)
                * mpm.exp(c))

    Cwf = float(CW)
    print("  t=1000:  d          mown*t^2     F_sharp    mown-F_sh "
          "  mown*t^2 - Cw")
    for d in [0.001, 0.004, 0.0045, 0.0047, 0.00473, 0.004738, 0.00474,
              0.0048, 0.005]:
        m1 = float(mown_mp(1000, d)) * 1000.0 ** 2     # mown * t^2
        f1 = float(F_sharp(Fraction(repr(d)) ** 2))
        print("        %.6f  %.9e  %.9e  %+.3e   %+.3e"
              % (d, m1, f1, m1 - f1, m1 - Cwf), flush=True)
    print("  t=1e5:   d          mown*t^2     F_sharp    mown-F_sh "
          "  mown*t^2 - Cw")
    for d in [0.00473, 0.004738, 0.00474, 0.005]:
        m2 = float(mown_mp(100000, d)) * 100000.0 ** 2
        f2 = float(F_sharp(Fraction(repr(d)) ** 2))
        print("        %.6f  %.9e  %.9e  %+.3e   %+.3e"
              % (d, m2, f2, m2 - f2, m2 - Cwf), flush=True)

    print()
    print("[4] t-structure: the TRUE mown*t^2 is DECREASING in t and")
    print("    down-converges to 4 d^2: the e^c factor (c = Cown ~ 1/t^2")
    print("    > 0, so e^c > 1) dominates the slowly-increasing ratio")
    print("    part g(t^2).  The floor argument is UNAFFECTED:")
    print("      mown*t^2 = 4 d^2 g(t^2) e^{c(t)} >= 4 d^2 g(t^2)")
    print("                >= 4 d^2 g(10^6) = F_sharp")
    print("    (e^c >= 1 dropped; g strictly increasing in t^2, exact).")
    for d in [0.001, 0.004, 0.004738, 0.005]:
        vals = [float(mown_mp(t, d)) * float(t) ** 2
                for t in [1000, 2000, 1e4, 1e5, 1e6]]
        mono = all(vals[i] >= vals[i + 1] for i in range(len(vals) - 1))
        lim = 4.0 * d * d
        print("  d = %.6f:  t: 1e3 ... 1e6   mown*t^2 = %s"
              % (d, "  ".join("%.9e" % v for v in vals)), flush=True)
        print("              limit 4 d^2 = %.9e   descending: %s"
              % (lim, mono), flush=True)

    print()
    print("[5] VERDICT (item 6 / 25af residual (3)):")
    print("  * F_sharp(d) above is the sharper d-dependent floor, exact")
    print("    rational in d^2, valid for ALL t >= 1000 and all 0 < d < 1/2")
    print("    (e^c dropped: c = Cown = (1/2+d)/A + (1/2-d)/B > 0).")
    print("  * It sharpens F4 at d = 1/200 (the [1] relative gain) and, more")
    print("    importantly, DEFINES a floor on the whole gap (d_F, 1/200)")
    print("    where the old F4 is 0 (inapplicable).")
    print("  * The bound-level strip squeeze (WUB + Mterm < floor) therefore")
    print("    extends from the d >= 1/200 edge to the certified working")
    print("    edge d >= 47384091/10^10 = 0.0047384091 (strict 10-decimal")
    print("    rational above d_F, exact positive margin in [2]) -- a")
    print("    5.23 percent extension of the closure-relevant own-regime")
    print("    strip.  Honest sign note: the floor bracket r1 below d_F")
    print("    is NEGATIVE-margin by construction; the certified COVER")
    print("    edge is the upper bracket rounded up, r2'.")
    print("    of the closure-relevant own-regime strip; below d_F the t^-2")
    print("    wire is intrinsically open (floor 4 d^2*(...)->0 < Cw), as 25af")
    print("    [7] stated for the data edge: not closure-relevant (the S2")
    print("    floor side / the near pin 0.9975 at the witness handles it).")
    print("  * Lean follow-up (named, NOT part of this constants study): port")
    print("    F_sharp as st_mownfloor_sharp (the g'(u) > 0 line + the exact")
    print("    ratio comparison at u = 10^6, norm_num-able), then the d-edge")
    print("    parameter 1/200 -> r2' in s4_strip_close, and the d0 < 1/200")
    print("    case split in S4A.s4asm_S4_on_pairs (the 0.9975 near-pin")
    print("    edge moves from 1/200 to r2'; the band (r2', 1/200) becomes")
    print("    covered by mown(t, d0) with the F_sharp floor).")
    print("    Per the owner's standing rule, the Lean port will search")
    print("    online FIRST for any latest-mathlib lemma or reorganization")
    print("    (monotone ratio/pow/div chains) before deriving atoms by")
    print("    hand.")
    print()
    print("DONE")
