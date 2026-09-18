"""25ae 3B.11 Part B -- CORRECT re-derivation (matches validated anchor).
term_i(n,t) = sqrt(t3w_prod t i) * n^{-p_i} / d_i,  i in {2,4,6,7}
n = floor(13t/8)  =>  n >= 13t/8 - 1
R_i(t) := sqrt(t3w_prod t i) * (13t/8 - 1)^{-p_i} * 2*(13t/8)^{1/2} * (78/70) / d_i
         (so that term_i <= R_i(t)*target(t),  target = (1/2)*(13t/8)^{-1/2}*(35/39))
h_i(t) = d/dt log R_i(t) = sum_{k=0}^i t/(t^2+(k+1/2)^2) - p_i*(13/8)/(13t/8-1) + 1/(2t)
"""
from fractions import Fraction as F
from sympy import symbols, Rational, Poly, expand, diff, nsimplify
import math

t = symbols('t', positive=True)
P = {2: Rational(7, 2), 4: Rational(11, 2), 6: Rational(15, 2), 7: Rational(15, 2)}
D = {2: 720, 4: 30240, 6: 1209600, 7: 9072000}

def t3w_prod_sym(i):
    from sympy import prod
    return prod(t * t + Rational(2 * k + 1, 2) ** 2 for k in range(i + 1))

print("=== h_i reduced numerators (exact) ===")
for i in (2, 4, 6, 7):
    A = sum(t / (t * t + Rational(2 * k + 1, 2) ** 2) for k in range(i + 1)) + Rational(1, 2) / t
    B = P[i] * Rational(13, 8) / (13 * t / 8 - 1)
    h = A - B
    N, Dd = h.cancel().as_numer_denom()
    N, Dd = expand(N), expand(Dd)
    print(f"i={i}:  h = N/D with")
    print(f"   N = {N}")
    print(f"   D = {Dd}")
    for tv in (Rational(13), Rational(100), Rational(10**8)):
        print(f"   h({tv}) = {float(h.subs(t, tv)):+.6e}")
    print()

print("=== R_i(t) values (continuous ratio bounds) ===")
def Rat(i, tv):
    tv = Rational(tv)
    Pr = F(1)
    for k in range(i + 1):
        Pr = F(tv) * F(tv)
    # float-level value (irrational-free: all rational for rational tv except powers)
    return None

import mpmath as mp
mp.mp.dps = 50
def Rval(i, tv):
    tvF = mp.mpf(tv)
    p = float('0')
    prod = 1.0
    pr = mp.mpf(1)
    from math import isqrt
    Pp = F(tv)
    Fprod = F(1)
    for k in range(i + 1):
        Fprod *= Pp * Pp + F(2 * k + 1, 2) ** 2
    pf = mp.mpf(Fprod.numerator) / mp.mpf(Fprod.denominator)
    sqrt_prod = mp.sqrt(pf)
    nlo = 13 * tvF / 8 - 1
    pexp = float(P[i])
    R = sqrt_prod * nlo ** (-pexp) * 2 * (13 * tvF / 8) ** 0.5 * (mp.mpf(78) / 70) / D[i]
    return R

for i in (2, 4, 6, 7):
    print(f"i={i}: R({13}) = {float(Rval(i, 13)):.8e}   R({10**8}) = {float(Rval(i, 10**8)):.8e}")
tot13 = sum(Rval(i, 13) for i in (2, 4, 6, 7))
tot1e8 = sum(Rval(i, 10**8) for i in (2, 4, 6, 7))
print(f"sum R_i(13)   = {float(tot13):.8f}")
print(f"sum R_i(1e8)  = {float(tot1e8):.8f}   (anchor pin: 0.73746)")

print()
print("=== dense sign scan of h_i on [13, 1e8] (log steps) ===")
import numpy as np
for i in (2, 4, 6, 7):
    A = sum(t / (t * t + Rational(2 * k + 1, 2) ** 2) for k in range(i + 1)) + Rational(1, 2) / t
    B = P[i] * Rational(13, 8) / (13 * t / 8 - 1)
    h = A - B
    vals = []
    for e in range(1, 9):
        for m in range(1, 10):
            tv = m * 10 ** (e - 1) if m * 10 ** (e - 1) >= 13 else None
            if tv is None or tv > 10**8:
                continue
            vals.append((tv, float(h.subs(t, Rational(tv)))))
    mins = min(v for _, v in vals)
    maxs = max(v for _, v in vals)
    print(f"i={i}: min h = {mins:+.4e}  max h = {maxs:+.4e} over [13, 1e8] (sample)")
