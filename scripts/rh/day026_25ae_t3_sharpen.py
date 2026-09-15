#!/usr/bin/env python3
"""25ae ANCHOR v2: sharpen the P4 T3 bound (L4 route). v1 quadrature was
under-resolved (t/2π oscillations per period) and v1's zeta route had an
I-power typo (p4_I(n,s) = n^{1-s}/(1-s) per P4Limit.lean:1266; v1 used
n^{-s}/(1-s) -> the 3.2493-|T1| artifact in Part B v1). v2 measures T3 with
the zeta route only (25ad-validated family), plus an independent J1 via the
Bernoulli Fourier series with exact incomplete-gamma period integrals
(dps 30) to verify the identity T3 = -s*(J1 + n^{-s-1}/12) to full precision.

Lean anchor (P4Limit.lean, 25ad state):
  p4_Thm L5.e p4_T4_bound:  |p4_em_expr| ≤ |T1| + |T2| + (√3/540)‖s(s+1)(s+2)‖ n^{-5/2}
  T1 = -1/2 n^{-s},  T2 = (s/12) n^{-s-1},  T3 = -(1/2) s(s+1) ∫_n^∞ B̂₂ x^{-s-2}
  p4_I(n,s) = n^{1-s}/(1-s);  W_n = ζ(s) - P_n(s) + p4_I(n,s) (CITED at Re s = 1/2,
  DLMF 25.2.8 / Apostol 12.21; LEAN at Re s > 1 via p4_identity; 25ad validated
  the identity numerically to 1.000000 at 137114.84, 1e6, 1.00000199e7).

Target: find the t-flattest form |T3| ~ C·f(s,n) over t ∈ [1e3, 1e8] at
n = floor(13t/8) (list scale) and across n/... ratios, to state a uniform
(t-independent) |T3| bound that replaces the t-growing √3/540 form.
"""
import sys
from math import floor
import numpy as np
import mpmath as mp

OUT = open('/home/jsmille/Projects/rh-missing-tail/scripts/rh/out_day026_25ae_t3_sharpen.txt', 'w')
def p(*a):
    s = ' '.join(f'{x}' for x in a)
    print(s, flush=True); OUT.write(s + '\n')

def t3_zeta(t, n, dps=50):
    """T3 = W_n - T1 - T2, W_n = zeta(s) - P_n(s) + n^{1-s}/(1-s)  [Lean p4_I power]."""
    t = float(t); n = int(n)
    s = np.complex128(0.5 + 1j*t)
    mp.mp.dps = dps
    zz = mp.zeta(mp.mpf('0.5') + 1j*mp.mpf(repr(t)))
    mp.mp.dps = 30
    Pn = 0j
    chunk = 2_000_000
    for a in range(1, n+1, chunk):
        b = min(a + chunk, n + 1)
        ks = np.arange(a, b, dtype=np.float64)
        ex = ks**(-s)
        for i in range(0, len(ks), 65536):
            Pn += np.sum(ex[i:i+65536], dtype=np.complex128)
    I = n**(-s + 1)/(1 - s)
    em = zz - Pn + I
    T1 = -0.5*n**(-s)
    T2 = (1/12)*s*n**(-s - 1)
    return complex(em - T1 - T2), complex(em), complex(T1), complex(T2)

def J1_fourier(t, n, M=60, dps=40):
    """J1 = ∫_n^∞ B̄₁(x) x^{-s-1} dx via B̄₁(x) = Σ_{m≠0} -e^{2πimx}/(2πim),
    R_m = ∫_n^∞ e^{2πimx} x^{-s-1} dx = (-2πim)^{-s} ... via mp gammainc:
    R_m = (2πi)^{s} * e^{-...} ... use: ∫_n^∞ e^{a x} x^{-s-1} dx = a^{s} Γ(-s, a n)
    for |ph(-an)| < π (standard: ∫ e^{ax} x^{ν-1} dx = a^{-ν} Γ(ν, an); here ν = -s).
    so R_m = (-2πim)^{s} Γ(-s, -2πim n)."""
    s = mp.mpf(0.5) + 1j*mp.mpf(float(t)) if isinstance(t, mp.mpf) else mp.mpf('0.5') + 1j*mp.mpf(t)
    tot = mp.mpc(0)
    for m in range(1, M+1):
        a1 = -2j*mp.pi*m
        a2 = 2j*mp.pi*m
        R1 = a1**s * mp.gammainc(-s, a1*mp.mpf(n))
        R2 = a2**s * mp.gammainc(-s, a2*mp.mpf(n))
        c1 = -1/(a1)   # ĉ(m) of B̄₁: ĉ(m) = -1/(2πim) = -1/a1  (a1 = 2πim -> -1/a1 = 1/(2π)·1/m·i ... careful)
        # B̄₁(x) = Σ_{m≠0} ĉ(m) e^{2πimx},  ĉ(m) = -1/(2π i m).
        # For e^{a x} with a = 2πim: ĉ = -1/(2π i m) = -1/a * (1/1)?? -1/(2πim) = -1/a.  Yes ĉ = -1/a for a = 2πim.
        tot += (-1/a1)*R1 + (-1/a2)*R2
    return tot

def identity_check(t, n):
    T3, em, T1, T2 = t3_zeta(t, n)
    mp.mp.dps = 40
    s = mp.mpf('0.5') + 1j*mp.mpf(repr(float(t)))
    nmp = mp.mpf(n)
    J1 = J1_fourier(t, n, M=60, dps=40)
    J2 = J1 + nmp**(-s - 1)/12
    resid = mp.mpc(float(T3.real), float(T3.imag)) + s*J2
    dT1 = -0.5*nmp**(-s)
    # T3 via IBP form: -(s/2)B̂2(n)n^{-s-1} - s J1 with B̂2(n) = 1/6:
    resid_ibp = mp.mpc(float(T3.real), float(T3.imag)) + (s/2)*(mp.mpf(1)/6)*nmp**(-s-1) + s*J1
    return abs(resid), abs(resid_ibp), abs(T3), abs(J2), J2

p('=== 25ae v2: T3 anchor (zeta route; p4_I power fixed) ===')
p()
p('--- cross-check vs 25ad validated value at t = 1e6 (|T3| ~= 2.4436788492956994e-05) ---')
T3, em, T1, T2 = t3_zeta(1000000.0634413778632980454464, int(floor(13*1000000.063441377863298045/8)))
p(f'|T3| = {abs(T3):.15e}   |EM|/|T1| = {abs(em)/abs(T1):.8f}')

p()
p('--- identity T3 = -s*J2 at zero heights (J1 via incomplete-gamma Fourier, dps 40) ---')
for t, tag in [(137114.8410713324784947126598, 'P0'),
               (1000000.063441377863298045, 'P4')]:
    n = floor(13*t/8)
    r1, r2, aT3, aJ2, J2 = identity_check(float(t), n)
    p(f't={t:.6f} [{tag}] n={n}  |T3 + s J2| = {r1:.3e}   |T3 + (s/12)n^{{-s-1}} + s J1| = {r2:.3e}   (|T3| = {aT3:.3e}, |J2| = {aJ2:.3e})')

p()
p('--- |T3| constant fits: list scale n = floor(13t/8), t = 1e3..1e8 ---')
p('|T3|/f candidates:  FA = ‖s(s+1)(s+2)‖ n^{-7/2}    FB = ‖s(s+1)‖ n^{-7/2}    FC = ‖s(s+1)‖ n^{-5/2}    FD = ‖s(s+1)(s+2)‖ n^{-5/2}   (FD = current L5.e form)')
rows = []
for t in [1000.0, 3000.0, 10000.0, 30000.0, 137114.8410713324784947126598,
          1000000.063441377863298045, 10000019.9176922975762040992966001,
          15000000.1483617306509352119486298, 25000003.3675177107930498459838743,
          50000000.798368300768164067013827, 100000000.4516353600206784375890589]:
    n = int(floor(13*t/8))
    T3, em, T1, T2 = t3_zeta(t, n)
    aT3 = abs(T3); aT1 = abs(T1)
    ts = complex(0.5 + 1j*t)
    A = abs(ts*(ts+1)*(ts+2)); B = abs(ts*(ts+1))
    FA = aT3/(A*n**(-3.5)); FB = aT3/(B*n**(-3.5)); FC = aT3/(B*n**(-2.5)); FD = aT3/(A*n**(-2.5))
    rows.append((t, aT3, aT1, FA, FB, FC, FD))
    p(f't={t:<24.6f} n={n:<10} |T3|={aT3:.4e}  |T3|/|T1|={aT3/aT1:.4e}   FA={FA:.4e}  FB={FB:.4e}  FC={FC:.4e}  FD={FD:.4e}')

p()
p('--- exponent in n at fixed t = 1e6 (zeta route) ---')
tfix = 1000000.063441377863298045
ref = None
for ratio in (0.625, 1.0, 1.625, 3.0, 5.0, 10.0, 20.0, 50.0):
    n = int(tfix*ratio)
    T3, em, T1, T2 = t3_zeta(tfix, n)
    aT3 = abs(T3)
    if ref is None:
        ref = (n, aT3); p(f'ratio={ratio:<6} n={n:<10} |T3|={aT3:.4e}  (ref)  [P_n has {n} terms]')
    else:
        import math
        slope = math.log(aT3/ref[1])/math.log(n/ref[0])
        p(f'ratio={ratio:<6} n={n:<10} |T3|={aT3:.4e}  slope-in-n vs ref: {slope:.4f}')

p()
p('--- net wall at list scale (candidate uniform T3 bound C*FA vs current L5.e) ---')
mp.mp.dps = 30
for C in (1/900, 1/800, 1/700, 1/600, 1/500, 1/400, 1/300):
    worst = 0; worst_t = None
    for (t, aT3, aT1, FA, FB, FC, FD) in rows:
        n = int(floor(13*t/8))
        ts = complex(0.5 + 1j*t)
        T3ub = C*abs(ts*(ts+1)*(ts+2))*n**(-3.5)
        lo = aT1 - abs(T2) - T3ub
        r = T3ub/aT1
        if lo < worst or worst_t is None:
            pass
        worst = max(worst, r)
    p(f'C = {C:.6f}:  max over t of (T3UB/|T1|) = {worst:.4e}   -> |EM| >= (1 - |T2|/|T1| - maxR)|T1| uniform in t')
p()
p('|T2|/|T1| at list scale n = 13t/8:  (1/12)t/n^{1.5} / (0.5/n^{1/2}) = t/(6n) = (1/6)(8/13) =', f'{(1/6)*(8/13):.6f}')

OUT.close()
print('DONE -> out_day026_25ae_t3_sharpen.txt')
