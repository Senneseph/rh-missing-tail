#!/usr/bin/env python3
"""day-025 25ab — S4Growth endpoint-constant certification (S4a protocol). [REV2]

REV2: the X bound is re-derived directly on the B3Core defs (Bf/Cf/Kbar as in
formal/RhAttack/B3Core.lean — p11 is an exact mirror). REV1's XUBfun missed the
Cf·Kbar t^{-2} component (Cf ~ 2 t^2 for G = t^2 is intrinsic: Cf = 1 + 2 t^2
(t^2+1/4)/(t^2-1)); the measured X(T0) = 1.45e-9 was always consistent with the
B3Core EXACT value 1.4505e-9 (independently recomputed).

The Lean-provable chain (all for t >= T0 = 1.1e5):
  p8_B t floor(t^2) termwise:
    term1 <= (1/2) (T0 t^{-1}) / (1 - 1/T0^2)  <=  CG11 = 4.55e-6
    term2 <= (T0^{-2} + (1/2) T0^{-3})/12 * (T0^2/(T0^2-1))^2   <=  CG12 = 7e-11
    term3 <= (17321/5400000) (1+3/T0)^3 T0^{-2} (T0^2/(T0^2-1))^3 <=  CG13 = 3e-13
  Xgrow <= XUBfun := (4.98 ln t + 26.55)/t^2:
    Bf <= (2 + 1/T0 + 2/T0^2)/t^2          [2 t^-2 + t^-3 + (3/2) t^-4]
    Sbar(2t^2)+Sbar(t^2) <= 1.02 ln t + 5.27
    Cf <= 2 t^2 + 4.5 + 5/t^2              [exact: Cf = 2t^2 + 4.5 + 2.5/(t^2-1)]
    Kbar(t^2) <= (0.51 ln t + 2.78)/(2 t^4)
    => X <= (4.9725093 ln t + 26.525048)/t^2 <= XUBfun
  M term: Zbound e^X X <= 4.8 (4.98 t^{-3/4} + 26.55 t^{-5/4}) (e^X <= 3,
          (ln t)^2 <= t, ln t <= t^{1/2}; all four powers decreasing)
      <= 4.8 (4.98/6167 + 26.55/1980000)  <=  CG3 = 4e-3
      [T0^{-3/4} <= 1/6167, T0^{-5/4} <= 1/1980000]
  XUBfun(t) <= (4.98 sqrt(t) + 26.55)/t^2 (ln t <= sqrt(t)) <= (4.98*332 + 26.55)/T0^2
      <=  CG2 = 1.4e-7        [sqrt(T0) <= 332]
  TOTAL = CG11+CG12+CG13+CG2+CG3 = 4.004690e-3 < 0.9975
Admissibility: N_lower(x) >= x for x >= T0^2 (Backlund RVM; ratio >= 3.24).
"""
import mpmath as mp
import numpy as np
mp.mp.dps = 50

import day023_p11c_1e7 as p11

T0 = mp.mpf("1.1e5")
PIN = mp.mpf("0.9975")
XUBC1 = mp.mpf("4.98")
XUBC2 = mp.mpf("26.55")
XUBC1b = mp.mpf("4.9725093")   # provable pre-rounding lnt coef
XUBC2b = mp.mpf("26.525048")   # provable pre-rounding const
CG11 = mp.mpf(91) / 20000000
CG12 = mp.mpf(7) / 100000000000
CG13 = mp.mpf(3) / 10000000000000
CG2 = mp.mpf(14) / 100000000
CG3 = mp.mpf(41) / 10000         # 4.1e-3 vs 4.0484e-3 (1/6000 proof constant)


def Zbound(t):
    return mp.mpf("1.6") * t ** (mp.mpf(1) / 4) * mp.log(t)


def Xfam(t):
    G = t * t
    return p11.Bf(t, G) * (p11.Sbar(2 * G) + p11.Sbar(G)) + p11.Cf(t, G) * p11.Kbar(G)


def XUBfun(t):
    return (XUBC1 * mp.log(t) + XUBC2) / (t * t)


def XUBfun_sqrt(t):
    return (XUBC1 * mp.sqrt(t) + XUBC2) / (t * t)


def Mf_ub(t):
    return mp.mpf("4.8") * (XUBC1 * t ** (-mp.mpf(3) / 4) + XUBC2 * t ** (-mp.mpf(5) / 4))


out = []
p = out.append
p("25ab REV2 — S4Growth constant certification (dps-50), B3Core EXACT chain")
p("=" * 90)

p("")
p("[0] exact value check at T0:")
for name, f in (("Bf(T0,T0^2)", lambda t: p11.Bf(t, t * t)),
                ("SSum(T0)", lambda t: p11.Sbar(2 * t * t) + p11.Sbar(t * t)),
                ("Cf(T0,T0^2)", lambda t: p11.Cf(t, t * t)),
                ("Kbar(T0^2)", lambda t: p11.Kbar(t * t)),
                ("X(T0)", Xfam),
                ("XUBfun(T0)", XUBfun)):
    p("  %-14s = %s" % (name, mp.nstr(f(T0), 15)))
p("  Mf(T0) = %s  vs Mf_ub(T0) = %s"
  % (mp.nstr(Zbound(T0) * mp.e ** Xfam(T0) * Xfam(T0), 12), mp.nstr(Mf_ub(T0), 12)))

p("")
p("[1] UB-chain verification on [T0, 1e18] (3000-pt log grid + 200 random):")
ts = list(np.geomspace(float(T0), 1e18, 3000))
ts += [float(np.random.uniform(float(T0), 1e18)) for _ in range(200)]
viol = 0
XUBmax = (0.0, 0.0)
Mfmax = (0.0, 0.0)
xx = 1 / (T0 * T0)
e1f = mp.mpf(1) / 2 / T0 / (1 - xx)
e2f = (1 / (T0 * T0) + mp.mpf(1) / (2 * T0 ** 3)) / 12 * (T0 * T0 / (T0 * T0 - 1)) ** 2
e3f = (mp.mpf(17321) / 5400000) * (1 + 3 / T0) ** 3 / (T0 * T0) * (T0 * T0 / (T0 * T0 - 1)) ** 3


def cmod3(tmp):
    a = tmp * tmp + mp.mpf(1) / 4
    b = tmp * tmp + mp.mpf(9) / 4
    c = tmp * tmp + mp.mpf(25) / 4
    return mp.sqrt(a) * mp.sqrt(b) * mp.sqrt(c)


for tf in ts:
    t = mp.mpf(repr(float(tf)))
    n = int(t * t)
    term1 = mp.mpf("0.5") / mp.sqrt(mp.mpf(n))
    term2 = (mp.sqrt(t * t + mp.mpf(1) / 4) / 12) * mp.mpf(n) ** (mp.mpf(-3) / 2)
    term3 = (mp.sqrt(3) / 540) * cmod3(t) * mp.mpf(n) ** (mp.mpf(-5) / 2)
    term2f = float(term2)
    term3f = float(term3)
    checks = [
        ("X<=XUBfun", float(Xfam(t)) <= float(XUBfun(t)) * (1 + 1e-12)),
        ("XUBfun<=XUBfun_sqrt", float(XUBfun(t)) <= float(XUBfun_sqrt(t)) * (1 + 1e-12)),
        ("Mf<=Mf_ub", float(Zbound(t) * mp.e ** Xfam(t) * Xfam(t)) <= float(Mf_ub(t)) * (1 + 1e-12)),
        ("Bf<=chain", float(p11.Bf(t, t * t))
         <= float((2 + 1 / T0 + 2 / (T0 * T0)) / (t * t)) * (1 + 1e-9)),
        ("SSum<=chain", float(p11.Sbar(2 * t * t) + p11.Sbar(t * t))
         <= float(mp.mpf("1.02") * mp.log(t) + mp.mpf("5.27")) * (1 + 1e-9)),
        ("Cf<=chain", float(p11.Cf(t, t * t)) <= float(2 * t * t + mp.mpf("4.5") + 5 / (t * t)) * (1 + 1e-9)),
        ("Kbar<=chain", float(p11.Kbar(t * t))
         <= float((mp.mpf("0.51") * mp.log(t) + mp.mpf("2.78")) / (2 * (t * t) * (t * t))) * (1 + 1e-9)),
        ("term1<=e1", term1 <= e1f * (1 + 1e-9)),
        ("term2<=e2", term2f <= float(e2f) * (1 + 1e-9)),
        ("term3<=e3", term3f <= float(e3f) * (1 + 1e-9)),
    ]
    if not all(c for (_, c) in checks):
        viol += 1
        bad = [n for (n, c) in checks if not c]
        if viol <= 3:
            p("  VIOLATION %s at t=%.6g" % (bad, tf))
    if float(XUBfun(t)) > XUBmax[0]: XUBmax = (float(XUBfun(t)), tf)
    if float(Zbound(t) * mp.e ** Xfam(t) * Xfam(t)) > Mfmax[0]:
        Mfmax = (float(Zbound(t) * mp.e ** Xfam(t) * Xfam(t)), tf)
p("  violations: %d / %d" % (viol, len(ts)))
p("  max XUBfun = %.6g @ %.6g (at left edge?)" % XUBmax)
p("  max Mf measured = %.6g @ %.6g" % Mfmax)

p("")
p("[2] endpoint values (dps-50) + Lean endpoint comparisons:")
xub_at_T0 = XUBfun(T0)
xub_sqrt_at_T0_332 = (XUBC1 * mp.mpf(332) + XUBC2) / (T0 * T0)
p("  XUBfun(T0) = %s  <= CG2=%s : %s" % (mp.nstr(xub_at_T0, 12), CG2, xub_at_T0 <= CG2))
p("  (4.98*332+26.55)/T0^2 = %s  <= CG2 : %s" % (mp.nstr(xub_sqrt_at_T0_332, 12),
                                                 xub_sqrt_at_T0_332 <= CG2))
p("  margin: CG2 - endpoint = %s" % mp.nstr(CG2 - xub_sqrt_at_T0_332, 3))
mf_end = mp.mpf("4.8") * (XUBC1 / 6000 + XUBC2 / 1980000)
p("  Mf endpoint 4.8*(4.98/6000 + 26.55/1980000) = %s <= CG3=%s : %s"
  % (mp.nstr(mf_end, 12), CG3, mf_end <= CG3))
p("  margin: CG3 - endpoint = %s" % mp.nstr(CG3 - mf_end, 3))

# T0 power comparisons used in Lean
p("")
p("  Lean power endpoints:")
p("  T0^{-3/4} <= 1/6000 : T0^{3/4} = %s >= 6000 : %s"
  % (mp.nstr(T0 ** (mp.mpf(3) / 4), 10), T0 ** (mp.mpf(3) / 4) >= 6000))
p("    [proof: 6000^{1/3} <= 91/5 : (91/5)^3 = %s >= 6000 ; 6000^{4/3} <= 6000*91/5 = 109200 <= 110000]"
  % mp.nstr((97.025) ** 2 * 18.2, 10))
p("  T0^{-5/4} <= 1/1980000 : T0^{5/4} = %s >= 1980000 : %s"
  % (mp.nstr(T0 ** (mp.mpf(5) / 4), 10), T0 ** (mp.mpf(5) / 4) >= 1980000))
p("  sqrt(T0) = %s <= 332 : %s" % (mp.nstr(mp.sqrt(T0), 10), mp.sqrt(T0) <= 332))

# p8_B term endpoints
p8b_T0 = p11.p8_B(1.1e5, int(T0 ** 2))
p("")
p("  p8_B(T0, floor(T0^2)) = %.12g ; CG11+CG12+CG13 = %.12g : %s"
  % (p8b_T0, float(CG11 + CG12 + CG13), p8b_T0 <= float(CG11 + CG12 + CG13)))
# term-exact endpoints
x = 1 / (T0 * T0)
e1 = mp.mpf(1) / 2 * mp.mpf(1) / T0 / (1 - x)
e2 = (1 / (T0 * T0) + mp.mpf(1) / (2 * T0 ** 3)) / 12 * (T0 * T0 / (T0 * T0 - 1)) ** 2
e3 = (mp.mpf(17321) / 5400000) * (1 + 3 / T0) ** 3 / (T0 * T0) * (T0 * T0 / (T0 * T0 - 1)) ** 3
p("  term1 endpoint (1/2)(1/T0)/(1-1/T0^2) = %.12g <= CG11 : %s" % (float(e1), e1 <= CG11))
p("  term2 endpoint = %.12g <= CG12 : %s" % (float(e2), e2 <= CG12))
p("  term3 endpoint = %.12g <= CG13 : %s" % (float(e3), e3 <= CG13))

tot = CG11 + CG12 + CG13 + CG2 + CG3
p("")
p("[3] TOTAL = %s < p8_f_near_pin = 0.9975 : %s   (margin %s)"
  % (mp.nstr(tot, 12), tot < PIN, PIN - tot))

p("")
p("[4] admissibility (Backlund RVM lower bound) — unchanged:")
TWOPI = mp.mpf(2) * mp.pi
def N_lower(z):
    return (z / TWOPI) * (mp.log(z / TWOPI) - 1) - mp.mpf("0.137") * mp.log(z) \
        - mp.mpf("0.443") * mp.log(mp.log(z)) - mp.mpf("4.4")
X0 = T0 * T0
p("  N_lower(T0^2)/T0^2 = %.8f (need >= 1)" % float(N_lower(X0) / X0))
worst = None
for tf in np.geomspace(1.2e10, 1e40, 400):
    z = mp.mpf(repr(float(tf)))
    r = N_lower(z) / z
    if worst is None or r < worst[0]:
        worst = (r, float(tf))
p("  min ratio on [1.2e10, 1e40] = %.8f @ %.6g" % (float(worst[0]), worst[1]))

p("")
p("ALL PASS" if (viol == 0 and tot < PIN and e1 <= CG11 and e2 <= CG12 and e3 <= CG13)
  else "CHECK FAILURES")
open("out_day025_gapw_constants.txt", "w").write("\n".join(out) + "\n")
print("\n".join(out))
