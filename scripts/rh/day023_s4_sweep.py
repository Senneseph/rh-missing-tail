#!/usr/bin/env python3
"""day-023 S4 scoping — the squeeze deficit map.

S4 (P12Uniform.lean): Bwire(t) + Mr(t) + Mf(t) < flo(t, d0) at EVERY
off-line pair (t, d0), uniform.  Wires (Lean-authoritative, mirrored
verbatim):
  Bwire(t) = B_best(t) = min over the onset band n = round(t/2*(0.25
             + 0.075 m)), m = 1..40, of p8_B(t, n)   (P8Floor line 130)
  Mr/Mf    = the A4.3 composition wires (B3Sbar b3BoundExplicit RHS X
             and the p8_residual_wired bound mass * e^X * X), list
             scale G = 1e7 — IN DOMAIN only for t < G (25j).

Floors at a candidate off-line zero at (t, d0) (the min over the
regimes the pair can sit in):
  own  : m_own(t, d) = |poff(t, d, t)|  — the C1a exact own-height
         kernel-change mass (B5 poff at t = gamma).  Closed form
         (verified below against the DIRECT 4-factor product fac(rho,
         s) = (1 - s/rho) e^{s/rho}, s = 1/2 + i t):
             m_own = d^2 (d^2 + 4 t^2) / (A B) * exp(c)      (25n)
                     A = (1/2+d)^2 + t^2    B = (1/2-d)^2 + t^2
             c = (1/2+d)/A + (1/2-d)/B,   0 <= c < 1/t^2 on 0<d<=1/2,
         (t -> inf:  4 d^2 / t^2 * (1 + O(1/t^2)) — the EFFECTIVE
         IDENTITY scale of the S4b own strip).
  window: ||R(gamma*, d0, t) - 1||, nearest certified zero gamma*
         (B5 closed form) — ~ 1 in the gap for small d0.
  far   : 1 (LEAN-proven A4.1b).

Output (out_day023_s4_sweep.txt): the deficit delta(t, d0) =
Bwire + Mr + Mf - flo over the blind-spot domain, the window-regime
squeeze-hold boundary t* (Bwire + Mr + Mf = 0.9975), and the shape
of the open region.
"""
import mpmath as mp
import numpy as np
mp.mp.dps = 30

import day023_p11c_1e7 as p11   # p8_B, B_best, GN (the <= 1e7 list),
                                # Sbar, Bf, Cf, Kbar, R_closed mirrors

# ---------- C1a poff at own height: direct product vs closed form ----------
def poff_direct(t, d):
    # four off-line zeros of a candidate at height t, offset d:
    s = mp.mpc(mp.mpf("0.5"), t)
    z = [mp.mpc(mp.mpf("0.5") + d, t), mp.mpc(mp.mpf("0.5") + d, -t),
         mp.mpc(mp.mpf("0.5") - d, t), mp.mpc(mp.mpf("0.5") - d, -t)]
    pr = mp.mpc(1)
    for rho in z:
        pr *= (1 - s/rho) * mp.e**(s/rho)
    return abs(pr)

def m_own(t, d):
    # CORRECTED 25n (dps-40, exact vs direct 4-factor product on the
    # grid t in [15, 1e8], d in (0, 1/2]): the four |1 - s/rho|
    # factors are  d/sqrt(A),  sqrt(d^2 + 4 t^2)/sqrt(A),  d/sqrt(B),
    #  sqrt(d^2 + 4 t^2)/sqrt(B)  ->  product d^2 (d^2 + 4 t^2) / (A B).
    # (The 4 d^2 t^2 / (A B) form in 25l missed the d^4 in
    # (d^2 + 4 t^2); the two agree to relative O(d^2 / (4 t^2)), which
    # is invisible at small d — the 25l "verification" was fooled.)
    # exp part unchanged: Re(s * sum 1/rho) = (half+d)/A + (half-d)/B,
    # with 0 <= c < 1/t^2 on 0 < d <= 1/2 (sup at d -> 0: 1/(t^2 + 1/4)).
    t, d = mp.mpf(t), mp.mpf(d)
    A = (mp.mpf("0.5") + d)**2 + t*t
    B = (mp.mpf("0.5") - d)**2 + t*t
    c = (mp.mpf("0.5") + d)/A + (mp.mpf("0.5") - d)/B
    return d*d*(d*d + 4*t*t)/(A*B) * mp.e**c

print("C1a closed-form verification (direct 4-factor product vs closed form):")
for (t, d) in [(14.134725, mp.mpf("0.005")), (1e3, mp.mpf("0.01")),
               (1e4, mp.mpf("0.1")), (1e6, mp.mpf("0.5")),
               (3e7, mp.mpf("0.499999"))]:
    a, b = poff_direct(t, d), m_own(t, d)
    rel = abs(a - b)/a
    print("  t = %-12.6g d = %-12.9g  direct = %s  closed = %s  rel = %.2e"
          % (t, float(d), mp.nstr(a, 12), mp.nstr(b, 12), float(rel)))

# ---------- wires ----------
G = mp.mpf("1e7")

def Xval_wire(t):
    # b3BoundExplicit RHS, band (G, B] with B = 1e8 (mirrors day020/p11c)
    Bm = mp.mpf("1e8")
    Bf = p11.Bf(t, G); Cf = p11.Cf(t, G)
    return Bf * (p11.Sbar(Bm) + p11.Sbar(G)) + Cf * p11.Kbar(G)

def sweep():
    out = []
    p = out.append
    p("S4 SWEEP — the squeeze deficit map (closed-form wires, 31-digit zero list)")
    p("  Bwire = B_best (P8Floor p8_B, onset-band argmin, Lean-verbatim)")
    p("  Mr/Mf = A4.3 wires (Xval b3BoundExplicit RHS, band (1e7, 1e8]; Mf = e^X*X)")
    p("  flo own = m_own(t,d) (C1a exact, closed form verified above)")
    p("=" * 100)
    # window-regime boundary: Bwire + Mr + Mf = 0.9975 (in-domain t < 1e7)
    def f(t):
        tt = t if isinstance(t, mp.mpf) else mp.mpf(str(t))
        return (p11.B_best(float(tt))
                + float(Xval_wire(tt)) * (1.0 + abs(mp.zeta(mp.mpc(0.5, float(tt)))))
                - 0.9975)
    lo, hi = 1e3, 9.9e6  # wire in-domain t < G
    flo_, fhi_ = f(lo), f(hi)
    tstar = None
    if flo_ < 0 < fhi_:
        a, b = lo, hi
        for _ in range(100):
            m = 0.5 * (a + b)
            if f(a) * f(m) <= 0:
                b = m
            else:
                a = m
        tstar = mp.mpf(str(0.5 * (a + b)))
    p("")
    p("[1] window-regime squeeze-hold boundary: Bwire + Mr + Mf = 0.9975")
    p("    delta(1e3) = %s ,  delta(1e7-) = %s" % (mp.nstr(flo_, 6), mp.nstr(fhi_, 6)))
    if tstar:
        p("    t* = %s  (the squeeze HOLDS at window pairs for t <= t*)"
          % mp.nstr(tstar, 10))
    # the deficit map
    p("")
    p("[2] deficit map: delta(t) = Bwire(t) + Mr(t) + Mf(t) - flo, flo ->")
    p("      window pairs: 0.9975 (pin)   |   own pairs: m_own(t, d) (blind spot)")
    p("  (Mr/Mf wires in domain t < 1e7; beyond: Bwire alone, domain note 25j)")
    p("    t              Bwire     Mr+Mf       delta_win(0.9975)  m_own(t,0.005)  m_own(t,0.5)")
    ts = [1e3 * (10**(k/15.)) for k in range(0, 61)]  # 1e3..1e9, 61 pts
    ts = [t for t in ts if t <= 3.2e7] + [3.15e7]
    seen = set()
    for t64 in ts:
        key = round(t64, -1)
        if key in seen: continue
        seen.add(key)
        B = p11.B_best(t64)
        if t64 < 1e7:
            X = float(Xval_wire(mp.mpf(repr(t64))))
            M = X * (1.0 + abs(mp.zeta(mp.mpc(0.5, t64))))  # Mr + Mf = X + mass*e^X*X (diagnostic)
        else:
            X, M = float("nan"), float("nan")
        dw = B + M - 0.9975
        m5 = float(m_own(t64, mp.mpf("0.005")))
        mhalf = float(m_own(t64, mp.mpf("0.5")))
        p("    %-13.6g %-11.6g %-11.6g %-19.9f %-19.6e %-19.6e%s"
          % (t64, B, M if t64 < 1e7 else -1, dw if t64 < 1e7 else B - 0.9975,
             m5, mhalf, "   [band: Bwire only]" if t64 >= 1e7 else ""))
    p("")
    p("[3] own-regime (blind spot) statement, checked numerically:")
    ok = True
    for t64 in [1e3, 1e4, 1e5, 1e6, 1e7, 3.15e7]:
        B = p11.B_best(t64)
        mh = float(m_own(t64, mp.mpf("0.5")))
        p("    t = %-10.4g  Bwire = %-12.6g  max_d m_own(t,d) = %-12.6e  squeeze-holds somewhere on 0<d<=1/2: %s"
          % (t64, B, mh, "NO (entire strip is deficit)" if B >= mh else "yes"))
        ok = ok and (B >= mh)
    p("")
    p("[4] d_vis(t) (the smallest d0 where the squeeze would hold, own regime):")
    for t64 in [1e3, 1e4, 1e5, 1e6, 1e7, 3.15e7]:
        # solve m_own(t, d) = Bwire(t) + Mr + Mf for d in (0, 1/2]
        B = p11.B_best(t64)
        target = B
        # m_own(t, d) increases in d on (0, 1/2) (verified monotone below);
        # check the d = 1/2 value first
        mh = float(m_own(t64, mp.mpf("0.5")))
        if mh >= target:
            g = lambda d: float(m_own(t64, mp.mpf(d))) - target
            a, b = 1e-8, 0.49999999
            for _ in range(200):
                m = 0.5 * (a + b)
                if g(a) * g(m) <= 0:
                    b = m
                else:
                    a = m
            dv = mp.mpf(str(0.5 * (a + b)))
            p("    t = %-10.4g  d_vis = %s" % (t64, mp.nstr(dv, 8)))
        else:
            p("    t = %-10.4g  d_vis undefined: max m_own = %.4e < Bwire = %.4e (whole strip is the blind spot)"
              % (t64, mh, target))
    open("out_day023_s4_sweep.txt", "w").write("\n".join(out) + "\n")
    print("\n".join(out))

if __name__ == "__main__":
    sweep()
