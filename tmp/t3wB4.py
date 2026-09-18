"""25ae 3B.11 Part B -- final exact K constants (validated formulas)."""
from fractions import Fraction as F
import math


def sqrt_ub(x: F) -> F:
    a, b = x.numerator, x.denominator
    return F(math.isqrt(a * b) + 1, b)


def sqrt_lb(x: F) -> F:
    a, b = x.numerator, x.denominator
    m = math.isqrt(a * b)
    if m * m == a * b:
        m -= 1
    return F(m, b)


T13 = F(13)
T8 = F(10 ** 8)

# exact products P_i(t) = prod_{k=0}^i (t^2 + (k+1/2)^2)
def P(i, T):
    r = F(1)
    for k in range(i + 1):
        r *= T * T + F(2 * k + 1, 2) ** 2
    return r


P_13 = {i: P(i, T13) for i in (2, 4, 6, 7)}
P_1e8 = P(7, T8)
print("P_2(13) =", P_13[2], "  sqrt =", float(P_13[2]) ** 0.5)
print("P_7(1e8) float:", float(P_1e8))

# K_i: strict rational upper bound of R_i at its max endpoint.
# R_i(t) = sqrt(P_i(t)) * (13t/8 - 1)^(-p_i) * 2 * sqrt(13t/8) * (78/70) / d_i
# (13t/8 - 1)^(-p), p = (2k+1)/2  =  1 / ((13t/8-1)^k * sqrt(13t/8-1))
#   upper bound: 1 / ((13t/8-1)^k * sqrt_lb(13t/8-1))
# sqrt(a) < sqrt_ub(a);  sqrt(a) > sqrt_lb(a)

D = {2: 720, 4: 30240, 6: 1209600, 7: 9072000}
P_ = {2: F(7, 2), 4: F(11, 2), 6: F(15, 2), 7: F(15, 2)}


def K_upper(i, T, Prod):
    nlo = F(13 * T, 8) - 1
    k = (P_[i].numerator - 1) // 2
    invpow = F(1) / (nlo ** k * sqrt_lb(nlo))
    return sqrt_ub(Prod) * invpow * 2 * sqrt_ub(F(13 * T, 8)) * F(78, 70) / D[i]


def R7_lower(T):
    """strict rational LOWER bound of R_7(T) (needed: R7(13) < R7(1e8))."""
    nlo = F(13 * T, 8) - 1
    # nlo^{-15/2} >= 1/(nlo^7 * sqrt_ub(nlo))
    invpow = F(1) / (nlo ** 7 * sqrt_ub(nlo))
    Pr = P(7, T)
    return sqrt_lb(Pr) * invpow * 2 * sqrt_lb(F(13 * T, 8)) * F(78, 70) / 9072000


K2 = K_upper(2, T13, P_13[2])
K4 = K_upper(4, T13, P_13[4])
K6 = K_upper(6, T13, P_13[6])
K7 = K_upper(7, T8, P_1e8)
B7_13 = K_upper(7, T13, P_13[7])
LB7_1e8 = R7_lower(T8)

for nm, v in (("K2", K2), ("K4", K4), ("K6", K6), ("K7", K7)):
    print(f"{nm} = {v}   ({float(v):.12f})")
print(f"B7_13 (ub of R7(13))   = {B7_13}   ({float(B7_13):.6e})")
print(f"LB7_1e8 (lb of R7(1e8))= {LB7_1e8}   ({float(LB7_1e8):.12f})")
print(f"B7_13 < LB7_1e8 ? {B7_13 < LB7_1e8}")

tot = K2 + K4 + K6 + K7
print()
print(f"SUM = K2+K4+K6+K7 = {float(tot):.12f}   < 1 ? {tot < 1}")
print(f"margin = {float(1 - tot):.8f}")
print(f"SUM exact = {tot}")
