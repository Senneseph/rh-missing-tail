"""25ae 3B.11 Part B -- exact constants and polynomial machinery
(13 <= t <= 1e8, log-derivative method).  All values EXACT (sympy/Fraction)."""
from fractions import Fraction as F
from sympy import symbols, Rational, Poly, expand, diff, floor as sypify_floor
import math

t = symbols('t', positive=True)

S = {2: 2, 4: 4, 6: 6, 8: 8}
P = {2: Rational(7, 2), 4: Rational(11, 2), 6: Rational(15, 2), 8: Rational(15, 2)}


def h(i):
    return S[i] * t / (t * t + Rational(169, 4)) + Rational(1, 2) / t \
        - P[i] * Rational(13, 8) / (13 * t / 8 - 1)


def hpp(i):
    return diff(h(i), t, 2)


# ---- 1. M_i: cleared-denominator numerator.
# h(i) = N(t) / [4 t (t^2+169/4)(13t/8-1) ... ]  -- compute exactly:
for i in (2, 4, 6, 8):
    N = h(i).cancel().as_numer_denom()[0]
    N = expand(N)
    print(f"h({i}) numerator N_{i}(t) = {N}")

print()

# ---- 2. Taylor of M_2(t) = 26*P*4t^4 - 8*S*t^3*(13t-8) - (4t^2+169)(13t-8) at 13
# (for i in 2,4,6): verify M_i = cleared numerator (after multiplying by 1/... ).
# Direct: M_i(t) = 104*P_i*t^4 - 8*S_i*t^3*(13t-8) - (4t^2+169)*(13t-8)
for i in (2, 4, 6):
    M = expand(104 * P[i] * t**4 - 8 * S[i] * t**3 * (13 * t - 8) - (4 * t**2 + 169) * (13 * t - 8))
    # check: h(i) with this M: h(i) = ... M/(4 t (t^2+169/4)(13t-8))?
    # verify: h(i) = (S t/(t^2+169/4) + 1/(2t)) - P (13/8)/(13t/8-1)
    #  common denom 4 t (t^2+169/4)(13t-8)/13?  -- just check symbolically:
    candidate = M / (4 * t * (t * t + Rational(169, 4)) * (13 * t - 8)) * 1
    ratio = expand(h(i) - candidate)
    print(f"M_{i}(t) = {M}")
    print(f"   h({i}) == M/(4t(t^2+169/4)(13t-8)) ? {ratio == 0}")
    for k in range(5):
        c = diff(M, t, k).subs(t, 13) / math.factorial(k)
        print(f"   Taylor_{13}[{k}] = {F(int(c))}  ({float(c):.4e})")
    print(f"   M''(t) = {expand(diff(M, t, 2))}, disc = { (diff(M,t,2).as_poly(t).coeff_monomial(t)*-2*diff(M,t).as_poly(t).coeff_monomial(t)**0 if False else (lambda q: (q.n[1]**2 - 4*q.n[0]*q.n[2]) if q.degree()==2 else 'nd')(diff(M, t, 2).as_poly(t)) )}")
    print()

# M_8 (i = 8):
M8 = expand(104 * P[8] * t**4 - 8 * S[8] * t**3 * (13 * t - 8) - (4 * t**2 + 169) * (13 * t - 8))
print(f"M_8(t) = {M8}")
print(f"   h(8) == M_8/(4t(t^2+169/4)(13t-8)) ? {expand(h(8) - M8 / (4 * t * (t * t + Rational(169, 4)) * (13 * t - 8))) == 0}")
print(f"   M8(13) = {F(int(M8.subs(t, 13)))}   M8(100) = {F(int(M8.subs(t, 100)))}   M8(1e8) = {F(int(M8.subs(t, 10**8)))}")
print(f"   M8'(t) = {expand(diff(M8, t))}")
print(f"   M8'(100) = {F(int(diff(M8, t).subs(t, 100)))}   M8'(1e8) = {F(int(diff(M8, t).subs(t, 10**8)))}")
print(f"   M8''(100) = {F(int(diff(M8, t, 2).subs(t, 100)))}")
print()

# h_4 signs (exact rationals)
from sympy import nsimplify
for tv in (Rational(13), Rational(100), Rational(10**8)):
    print(f"h(8)({tv}) = {h(8).subs(t, tv)}  ({float(h(8).subs(t, tv)):+.3e})")
print()

# ---- 3. K constants (exact) ----
def sqrt_ub(x: F):
    a, b = x.numerator, x.denominator
    return F(math.isqrt(a * b) + 1, b)


def sqrt_lb(x: F):
    a, b = x.numerator, x.denominator
    m = math.isqrt(a * b)
    if m * m == a * b:
        m -= 1
    return F(m, b)


def K(i, T):
    # Rbar_i(T) = (T^2+169/4)^{i/2} * (13T/8-1)^{-p_i} * 2 * (13T/8)^{1/2} * (78/70) / d_i
    if i == 2:
        rad = sqrt_ub(T * T + F(169, 4))            # sqrt upper bound
        radpow = rad**3                              # (t^2+169/4)^1 <= rad^3  (rad>1 => rad^3 > rad^... wait (x^(1))^1 = x <= rad^2? careful:
        # (T^2+169/4)^1 = u; need u <= U where U rational: U = rad^2 (ub of u? no: rad > sqrt(u) => rad^2 > u  -> u < rad^2; but u rational! Use u directly.)
        radpow = T * T + F(169, 4)                   # exact: (..)^{2/2} = (..)
    elif i == 4:
        radpow = (T * T + F(169, 4)) ** 2            # ^{4/2} = ^2 exact
    elif i == 6:
        radpow = (T * T + F(169, 4)) ** 3            # ^{6/2} = ^3 exact
    else:
        rad = sqrt_ub(T * T + F(169, 4))             # need (..)^4: exact for T^2 rational? (t^2+169/4)^4 IS rational!
        radpow = (T * T + F(169, 4)) ** 4            # ^{8/2} = ^4 exact (no sqrt needed at all)
    nlo = F(13 * T, 8) - 1
    invpow_lo = None
    # (13T/8 - 1)^{-p}: p = (2k+1)/2: = 1/((13T/8-1)^k * sqrt(13T/8-1)); use sqrt_lb
    k = (P[i].numerator - 1) // 2
    slab = sqrt_lb(nlo)
    invpow = F(1) / (nlo**k * slab)
    pref2 = 2 * sqrt_ub(F(13 * T, 8))
    return radpow * invpow * pref2 * F(78, 70) / {2: 720, 4: 30240, 6: 1209600, 8: 9072000}[i]


K1, K2, K3, K4 = K(2, 13), K(4, 13), K(6, 13), K(8, F(10**8))
for nm, Kv in (('K1', K1), ('K2', K2), ('K3', K3), ('K4', K4)):
    print(f"{nm} = {Kv}   ({float(Kv):.10f})")
tot = K1 + K2 + K3 + K4
print(f"SUM = {tot}")
print(f"SUM float = {float(tot):.10f}  < 1 ? {tot < 1}   margin = {1 - tot} ({float(1 - tot):.6f})")
