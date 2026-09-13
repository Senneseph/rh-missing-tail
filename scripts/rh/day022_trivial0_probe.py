# Day-022 — TRIVIAL-ZERO PROBE (owner's idea, considered seriously):
# if an off-line zero affected the trivial zeros, the exact identity
# at s0 = -2k (k = 1..3),
#     prod_rho (1 - s0/rho)(1 - s0/rho') e^{s0/rho + s0/rho'} = zeta(s0)/main(s0)
# (RHS = Bernoulli/Gamma constant, NO RH, NO zero data needed)
# would be the place to see it.  Two jobs:
#   (1) AUDIT the 12M composite product machinery at LEFT HALF-PLANE
#       points against the exact RHS (no zeta-data, no Riemann-Siegel):
#       if honest there (error ~ (2k/G)^2-class) while the critical
#       line showed 21 nats at 1e6, the error channel is pinned to the
#       (height/B) geometry, not the machinery.
#   (2) BOUND the channel: a zeta-zero moved by delta changes its
#       factor at s0 by |f_off/f_on - 1| ~ 2|k delta|/t^2 (printed
#       per (k, t) on the audit grid) — the detection scale of the
#       trivial-zero channel vs the closure's own-height O(1) effect.
# Product = float64 pairwise (same verified machinery, la to ~3e-9);
# tail = mp.quad (dps-30, no singularity for g > 0); main =
# logmain25212 port (verbatim).  COMPUTE, NEVER RECALL.
import numpy as np
from mpmath import mp
mp.dps = 30
PI = mp.pi
EULER_G = mp.euler
LIST = "/home/jsmille/Projects/kainos-logos/scripts/rh/zeros_T6000000_ext_full.txt"
gammas = np.loadtxt(LIST, dtype=np.float64)
G_MAX = mp.mpf("6000000")
GN = gammas[:int(np.searchsorted(gammas, 6000000.0))]
print("list: %d zeros (G = %s)" % (GN.size, G_MAX), flush=True)

def logmain_noGamma(s):
    # logmain WITHOUT the 1/Gamma factor (analytic at the trivial
    # zeros; the Gamma factor goes to 0 exactly there)
    return (s*mp.log(2*PI) - (1 + EULER_G/2)*s - mp.log(2)
            - mp.log(s - 1))
def main_linear_coeff(s0, k):
    # 1/Gamma(s/2+1) ~ (-1)^{k-1} (k-1)! (s+2k)/2  near s = -2k
    # (k = 1,2,3 for s0 = -2,-4,-6)
    import math
    c = ((-1)**(k-1)) * math.factorial(k-1) / 2.0
    return mp.mpf(c)
def pairlog(g, s):
    rho1 = mp.mpc(0.5, g); rho2 = mp.mpc(0.5, -g)
    return (mp.log(1 - s/rho1) + mp.log(1 - s/rho2) + s/rho1 + s/rho2)
def tail_int(s, G):
    f = lambda g: pairlog(g, s) * (mp.log(g/(2*PI))/(2*PI))
    return mp.quad(f, [G, mp.inf])

def product_left(s0):
    # s0 = -2k (real, negative).  Pair factor:
    #   (1 - s0/rho)(1 - s0/rho') e^{s0/rho + s0/rho'},  rho = 1/2 + i g
    # rho + rho' = 1  =>  s0/rho + s0/rho' = s0/(g^2 + 1/4)  (REAL)
    # |1 - s0/rho|^2 = (1 - Re(s0/rho))^2 + Im(s0/rho)^2
    # 1 - s0/rho = 1 + s0 (1/2 - i g)/(g^2+1/4)
    a = s0 * 0.5 / (GN*GN + 0.25)      # Re part: s0*0.5/u
    b = s0 * GN / (GN*GN + 0.25)       # Im part: s0*i*g/u  -> factor = 1 + a - i b... sign:
    # 1 - s0/rho = 1 - s0(0.5 - ig)/u = 1 - s0*0.5/u + i s0 g/u
    re = 1.0 - s0*0.5/(GN*GN + 0.25)
    im = s0*GN/(GN*GN + 0.25)
    mod2 = re*re + im*im               # |1 - s0/rho|^2  (pairs rho, rho')
    la = float(np.sum(0.5*np.log(mod2)))
    # e^{s0/rho + s0/rho'} = e^{s0/(g^2+1/4)}  (exponent real = s0*Bv)
    la += float(np.sum(s0/(GN*GN + 0.25)))
    # phase: 1 - s0/rho' is the CONJUGATE of 1 - s0/rho (s0 real),
    # so each PAIR (1 - s0/rho)(1 - s0/rho') = |1 - s0/rho|^2 > 0 is
    # a POSITIVE REAL: pair phase = 0 EXACTLY.  (2*arg(single) is the
    # arg of the square, not of the conjugate product — that was the
    # ~2.5-rad phase artifact, recorded in the output header note.)
    ar = 0.0
    return la, ar

print("\n--- (1) AUDIT: composite product at trivial zeros vs Bernoulli target ---")
for k in (1, 2, 3):
    s0 = mp.mpf(-2*k)
    # FIRST-ORDER identity (zeta and main both vanish at s0,
    # order 1):  P(s0) = zeta'(s0) / main'(s0),
    # main'(s0) = exp(A(s0)) * c_k,  c_k = (-1)^{k-1} (k-1)! / 2.
    c_k = main_linear_coeff(s0, k)
    main_prime = mp.e**logmain_noGamma(s0) * c_k
    # zeta'(s0) THREE independent ways (compute, never recall):
    #  (a) mpmath dps-50 numerical complex-step diff
    #  (b) closed form via functional equation at s0 = -2k:
    #      zeta'(-2k) = -zeta(2k+1) * (2k+1)! ... use the standard
    #      zeta'(-2k) = - (2k+1)! * zeta(2k+1) / (2 pi)^{2k} / k!  ...
    #      derived once, printed, and cross-checked against (a):
    #      zeta(s) = 2^s pi^{s-1} sin(pi s/2) Gamma(1-s) zeta(1-s)
    #      => zeta'(-2k) = 2^{-2k} pi^{-2k-1} (pi/2) cos(-pi k)
    #                     * Gamma(2k+1) * zeta(2k+1)
    import math as _math
    cf = (mp.mpf(2)**(-2*k) * mp.pi**(-2*k-1) * (mp.pi/2)
          * mp.cos(mp.pi*k) * mp.factorial(2*k) * mp.zeta(1+2*k))
    num = mp.diff(mp.zeta, s0)
    manual = mp.zeta(s0 - mp.mpf("1e-12")) / -mp.mpf("1e-12")  # (c) one-sided
    print("      zeta'(-%d): closed-form = %s | mpmath diff = %s | fwd-diff = %s"
          % (2*k, mp.nstr(cf, 8), mp.nstr(num, 8), mp.nstr(manual, 8)), flush=True)
    if abs(cf - num)/abs(cf) < mp.mpf("1e-6"):
        zeta_prime = num
    else:
        zeta_prime = cf
    tgt = zeta_prime / main_prime
    la, ar = product_left(float(s0))
    Tt = tail_int(s0, G_MAX)
    # LOG FORM: product = exp(sum of factor logs); Tt is INSIDE the exp
    comp = mp.e**(mp.mpf(la) + mp.mpc(0, mp.mpf(ar)) + Tt)
    gap = abs(comp - tgt)/abs(tgt)
    lnratio = mp.log(abs(tgt)) - (mp.mpf(la) + mp.re(Tt))
    print("s0 = %4d  (first-order) target = zeta'/main' = %s"
          % (-2*k, mp.nstr(tgt, 6)), flush=True)
    print("        composite = %s" % mp.nstr(comp, 6), flush=True)
    print("        REL GAP = %s   (E_left = ln|target| - Re comp = %s)"
          % (mp.nstr(gap, 4), mp.nstr(lnratio, 4)), flush=True)

print("\n--- (2) CHANNEL BOUND: single-zero move effect at s0 = -2k ---")
print("  |f_off/f_on - 1| ~ 2 k |delta| / t^2  (detection scale of the")
print("  trivial-zero channel for a zero of height t moved by delta)")
deltas = (0.005, 0.1, 5.0)
for t in (1000.0, 10000.0, 100000.0, 1000000.0):
    row = []
    for k in (1, 2, 3):
        row.append("k=%d: %s" % (k, " ".join("%.2e" % (2*k*d/(t*t)) for d in deltas)))
    print("t = %10.0f | %s" % (t, " | ".join(row)), flush=True)
print("\ncomparison: the closure's own-height channel sees O(1) kernel")
print("change (|R-1| >= 0.9975, day-010 d4d3) from the SAME zero — the")
print("trivial-zero channel is weaker by ~ t^2/(2 k delta) at height t.")
print("TRIVIAL0 PROBE COMPLETE")
