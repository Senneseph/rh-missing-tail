"""25ae Stage 3B.11 (Part A) -- list-scale wall constants for the sharpened
4-term T3 bound (1 <= t <= 13, four bands).  EXACT Fraction arithmetic with
strict integer square-root bounds; reproduces the t3w_qB_r / t3w_rB_r
constants used in P4Limit.lean (3B.11 Part A).

Setup: at list scale n = floor(13t/8), s = 1/2 + i t, the sharpened T3 bound
(P4Limit.p4_25ae_T3_bound) is

    T3UB = |S2| n^{-7/2}/720 + |S4| n^{-11/2}/30240
         + |S6| n^{-15/2}/1209600 + |S6||s+7| n^{-15/2}/9072000,

where |S_i|^2 = prod_{k <= i} (t^2 + (k+1/2)^2)  (i in {2,4,6,8}; the last
"term 8" product has 9 factors = |S6|^2 (s+7)^2).  The wall target is
T3UB/|T1| < 35/39 with |T1| = 1/2 n^{-1/2}; on a band with n >= n_min the
required wall lower bound is Hlb_B = (35/39) (1 - 1/(2 n_min))  -- the Lean
file uses the exact Hlb constants 35/78, 35/234, 35/312, 35/390.

Per band B (endpoint t*, n_min): each term i is bounded by
    Q_B,i * R_B,i / d_i
with
    Q_B,i = strict rational upper bound of sqrt(prod_{k<=i} (t*^2 + (k+1/2)^2)),\n            with i = 2, 4, 6, 7 matching the four T3 bound terms
            (3, 5, 7, 8 factors; term 7 = |S6||s+7| product ending at (15/2)^2)
            (Q = (isqrt(a*b) + 1)/b for product a/b > 0, so Q > sqrt(a/b));
    R_B,i = strict rational upper bound of n_min^{-p_i}
            (n_min^{-p} = 1/(n_min^k * sqrt(n_min)), p = (2k+1)/2, replaced
             by the integer lower bound of sqrt(n_min)).
The band theorem is  sum_i Q_B,i R_B,i / d_i < Hlb_B, closed by norm_num.

Bands:
    A1  [1,    16/13)  n_min =  1   Hlb = 35/78
    A2  [16/13, 4]     n_min =  2   Hlb = 35/234
    A3  [4,    8]      n_min =  6   Hlb = 35/312
    A4  [8,   13]      n_min = 13   Hlb = 35/390
"""
from fractions import Fraction as F
import math


def sqrt_ub(x):
    """Strict rational upper bound Q > sqrt(x) for x = a/b > 0: Q = (isqrt(a*b)+1)/b."""
    a, b = x.numerator, x.denominator
    assert a > 0 and b > 0
    q = F(math.isqrt(a * b) + 1, b)
    assert q * q > x, f"not strict: {q}^2 !> {x}"
    return q


def sqrt_lb(x):
    """Strict rational lower bound L < sqrt(x) for x = a/b > 0: L = isqrt(a*b)/b (drop 1 if exact)."""
    a, b = x.numerator, x.denominator
    m = math.isqrt(a * b)
    if m * m == a * b:
        m -= 1
    return F(m, b)


def invpow_ub(n, p):
    """Strict rational upper bound of n^{-p}; n >= 1 int, p = odd/2 in {7/2, 11/2, 15/2}.

    n^{-p} = 1/(n^k * sqrt(n)) < 1/(n^k * floor-sqrt-lb(n)).
    """
    if n == 1:
        return F(1)
    k = (p.numerator - 1) // 2
    r = 1 / (n ** k * sqrt_lb(F(n)))
    assert r > n ** (-p), f"not strict: {r} !> {n}^{-p}"
    return r


D = {2: 720, 4: 30240, 6: 1209600, 7: 9072000}
P = {2: F(7, 2), 4: F(11, 2), 6: F(15, 2), 7: F(15, 2)}
BANDS = [
    ('A1', F(16, 13), 1, F(35, 78)),
    ('A2', 4, 2, F(35, 234)),
    ('A3', 8, 6, F(35, 312)),
    ('A4', 13, 13, F(35, 390)),
]

print('25ae 3B.11 Part A: endpoint constants (exact; feed P4Limit.lean t3w_qB_r / t3w_rB_r)')
for name, ts, nmin, hlb in BANDS:
    tot = F(0)
    print(f'\n{name}: t*={ts}  n_min={nmin}  Hlb={hlb} ({float(hlb):.6f})')
    for r in (2, 4, 6, 7):
        Pr = F(1)
        for k in range(r + 1):
            Pr *= ts * ts + F(2 * k + 1, 2) ** 2
        q = sqrt_ub(Pr)
        R = invpow_ub(nmin, P[r])
        tot += q * R / D[r]
        print(f'  t3w_q{name}_{r} = {q}          (float {float(q):.6f})')
        print(f'  t3w_r{name}_{r} = {R}          (float {float(R):.6e})')
    print(f'  SUM = {float(tot):.6f}  < Hlb ?  {tot < hlb}   margin {float(hlb - tot):.6f}')
