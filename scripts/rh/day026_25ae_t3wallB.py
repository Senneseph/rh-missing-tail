"""25ae Stage 3B.11 Part B -- exact constants for the list-scale wall, 13 <= t <= 1e8.

VALIDATED RE-DERIVATION (matches the corrected 4-term bound in p4_25ae_T3_bound / the
Part A defs t3w_term/t3w_prod; see scripts/rh/day026_25ae_t3wall.py for Part A).

Design
------
For term index i in {2,4,6,7} (products with i+1 = 3,5,7,8 factors; p_i in {7/2,11/2,15/2,15/2};
d_i in {720,30240,1209600,9072000}):

  t3w_term i n t = sqrt(t3w_prod t i) * n^{-p_i} / d_i,   n = floor(13t/8) (list scale)
  n >= 13t/8 - 1  =>  n^{-p_i} <= (13t/8 - 1)^{-p_i}

  R_i(t) := sqrt(t3w_prod t i) * (13t/8 - 1)^{-p_i} * 2*(13t/8)^{1/2} * (78/70) / d_i

so that  t3w_term i n t <= R_i(t) * target_t   where  target_t = (1/2)*(13t/8)^{-1/2}*(35/39)
(the exact (78/70)*(35/39)*(1/2)*2 = 1 cancellation makes R_i * target_t =
 sqrt(t3w_prod t i) * (13t/8 - 1)^{-p_i} / d_i exactly).

Log-derivative  h_i(t) = d/dt log R_i(t):
  h_i(t) = sum_{k=0}^i t/(t^2 + (k+1/2)^2) + 1/(2t) - p_i*(13/8)/(13t/8 - 1)

Over the positive structured denominator
  Den_i(t) := 16*t*(13t-8) * prod_{k=0}^i (4t^2 + (2k+1)^2)
we have  h_i(t) = Num_i(t) / Den_i(t)  (integer polynomials Num_i, computed below).

Facts (exact, verified):
  * i in {2,4,6}: ALL coefficients of Num_i are negative  =>  h_i < 0 for all t > 0
    => R_i strictly decreasing on [13, 1e8]  =>  R_i(t) <= R_i(13) (= K_i below).
  * i = 7: Num_7(t) = b_0 + b_1*u + sum_{k>=2} b_k u^k with u = t-13,
    b_0 < 0, b_1 < 0, b_k > 0 (k >= 2).  With g(u) = b_1 + sum_{k>=2} b_k u^{k-1}:
      g strictly increasing on [0,inf) (b_k > 0), g(0) = b_1 < 0, g(90) > 0
      => unique v* in (0,90) with g(v*) = 0.
    N7(13+v) = b_0 + v*g(v):  N7 < 0 for v <= v*;  strictly increasing for v >= v*
    (N7'(v) = g(v) + v*g'(v) > 0);  N7(13+v*) = b_0 < 0, N7(100) > 0
      => unique c in (13+v*, 100) with N7(c) = 0.
    Hence h_7 < 0 on [13, c), h_7 > 0 on (c, inf), Den_7 > 0:
    R_7 decreasing on [13, c], increasing on [c, 1e8]:
      R_7(t) <= max(R_7(13), R_7(1e8)) = R_7(1e8)  (R_7(13) < R_7(1e8) below)
      <= K_7  (strict rational upper bound of R_7(1e8)).

Endpoint constants (strict rational sqrt upper/lower bounds, isqrt-based):
  K_i = strict ub of R_i at its max endpoint (13 for i in {2,4,6}; 1e8 for i = 7).
  K2+K4+K6+K7 < 1  (margin ~0.178)  =>  sum_i R_i(t) < 1  =>  t3w_T3UB < target_t
  on the whole band 13 <= t <= 1e8 (and target_t <= (1/2)*n^{-1/2}*(35/39) from
  n <= 13t/8, completing the wall statement).

NOTE: The earlier K-set from the pre-correction session (K1 = 9126/104332025, ...)
predates the term-index/exponent correction and is VOIDED.  The earlier "0.73746 at
1e8" anchor pin came from the pre-correction exponent bug (term 4 at n^{-31/2}); the
validated post-correction ratio at 1e8 is sum_i R_i(1e8) ~ 0.8217 (floor-bound form)
with the margin 0.178 computed below.
"""
from fractions import Fraction as F
import math


def sqrt_ub(x: F) -> F:
    """strict rational upper bound of sqrt(x) for x > 0"""
    a, b = x.numerator, x.denominator
    m = (math.isqrt(a * b) + 1) / b  # placeholder
    r = F(math.isqrt(a * b) + 1, b)
    assert r * r > x
    return r


def sqrt_lb(x: F) -> F:
    """strict rational lower bound of sqrt(x) for x > 0"""
    a, b = x.numerator, x.denominator
    m = math.isqrt(a * b)
    if m * m == a * b:
        m -= 1
    r = F(m, b)
    assert 0 <= r * r < x
    return r


P_ = {2: F(7, 2), 4: F(11, 2), 6: F(15, 2), 7: F(15, 2)}
D_ = {2: 720, 4: 30240, 6: 1209600, 7: 9072000}

T13 = F(13)
T8 = F(10 ** 8)


def P_prod(i: int, T: F) -> F:
    r = F(1)
    for k in range(i + 1):
        r *= T * T + F(2 * k + 1, 2) ** 2
    return r


# ---------------------------------------------------------------- Num_i(t) over Den_i(t)
# (verified approach: literal factor forms so denominators cancel exactly under expand)
from sympy import symbols, Rational, expand


def eval_poly(cs, x):
    r = 0
    for c in reversed(cs):
        r = r * x + c
    return r

ts = symbols('t')


def _num_den_sympy(i: int):
    Pp = P_[i]
    den = 16 * ts * (13 * ts - 8)
    for k in range(i + 1):
        den *= 4 * ts * ts + (2 * k + 1) ** 2
    den_e = expand(den)
    terms = [4 * ts / (4 * ts * ts + (2 * k + 1) ** 2) for k in range(i + 1)]
    terms += [1 / (2 * ts), -Pp * 13 / (13 * ts - 8)]
    num = 0
    for q in terms:
        e = expand(q * den)
        assert not e.as_numer_denom()[1].free_symbols, q
        num += e
    num = expand(num)
    assert not num.as_numer_denom()[1].free_symbols
    from sympy import Poly
    pnum = Poly(num, ts)
    pden = Poly(den_e, ts)
    ncs = [int(pnum.coeff_monomial(ts ** e)) for e in range(len(pnum.all_coeffs()))]
    dcs = [int(pden.coeff_monomial(ts ** e)) for e in range(len(pden.all_coeffs()))]
    while ncs and ncs[-1] == 0:
        ncs.pop()
    return ncs, dcs


nums = {}
dens = {}
for i in (2, 4, 6, 7):
    nums[i], dens[i] = _num_den_sympy(i)
    # sanity: h_i(13), h_i(100) against the direct definition
    n13, d13 = eval_poly(nums[i], 13), eval_poly(dens[i], 13)
    n100, d100 = eval_poly(nums[i], 100), eval_poly(dens[i], 100)
    assert d13 > 0 and d100 > 0
    print(f"--- i={i} (deg {len(nums[i]) - 1}) ---")
    print("  Num coeffs (low->high):", nums[i])
    print("  Den coeffs (low->high):", dens[i])
    print(f"  h(13) = {n13}/{d13} = {n13 / d13:+.8e}")
    print(f"  h(100) = {n100}/{d100} = {n100 / d100:+.8e}")
    if i in (2, 4, 6):
        assert all(c < 0 for c in nums[i]), f"i={i} not all-negative"
        print("  ALL Num COEFFS < 0  => h_i < 0 for all t > 0  OK")

# shift Num_7 to t = 13
cs = nums[7]
shift = [F(0)] * len(cs)
for e, c in enumerate(cs):
    for j in range(e + 1):
        shift[j] += F(c) * math.comb(e, j) * 13 ** (e - j)
bs = [int(c) for c in shift]
print()
print("Num_7(13+u) coeffs b_0..b_17 (low->high):")
for e, c in enumerate(bs):
    print(f"  b_{e} = {c}")
assert bs[0] < 0 and bs[1] < 0 and all(c > 0 for c in bs[2:])
g90 = sum(bs[k] * 90 ** (k - 1) for k in range(1, len(bs)))
N100 = eval_poly(cs, 100)
N73 = eval_poly(cs, 73)
print("g(0) = b_1 <", 0, ":", bs[1] < 0)
print("g(90) =", g90, "> 0:", g90 > 0)
print("Num_7(100) =", N100, "> 0:", N100 > 0)
print("Num_7(73)  =", N73, "> 0:", N73 > 0)

# ---------------------------------------------------------------- K constants
print()
print("=== K constants (strict rational endpoint bounds) ===")


def K_upper(i, T):
    Pr = P_prod(i, T)
    nlo = F(13 * T, 8) - 1
    k = (P_[i].numerator - 1) // 2
    invpow = F(1) / (nlo ** k * sqrt_lb(nlo))
    return sqrt_ub(Pr) * invpow * 2 * sqrt_ub(F(13 * T, 8)) * F(78, 70) / D_[i]


def R7_lower(T):
    Pr = P_prod(7, T)
    nlo = F(13 * T, 8) - 1
    invpow = F(1) / (nlo ** 7 * sqrt_ub(nlo))
    return sqrt_lb(Pr) * invpow * 2 * sqrt_lb(F(13 * T, 8)) * F(78, 70) / D_[7]


K2, K4, K6, K7 = (K_upper(i, T) for i, T in ((2, T13), (4, T13), (6, T13), (7, T8)))
B7_13 = K_upper(7, T13)
LB7_1e8 = R7_lower(T8)

for nm, v in (("K2", K2), ("K4", K4), ("K6", K6), ("K7", K7)):
    print(f"{nm} = {v}   ({float(v):.12f})")
print(f"B7_13  = {B7_13}   ({float(B7_13):.6e})   [strict ub of R_7(13)]")
print(f"LB7_1e8= {LB7_1e8}   ({float(LB7_1e8):.12f})   [strict lb of R_7(1e8)]")
assert B7_13 < LB7_1e8
print("B7_13 < LB7_1e8  =>  R_7(13) < R_7(1e8)  OK")

tot = K2 + K4 + K6 + K7
print()
print(f"SUM = K2+K4+K6+K7 = {tot}")
print(f"SUM float = {float(tot):.12f}   < 1 ? {tot < 1}   margin = {float(1 - tot):.8f}")
assert tot < 1

# continuous-ratio sanity (float)
import mpmath as mp
mp.mp.dps = 30


def Rval(i, tv):
    tvF = mp.mpf(tv)
    Fprod = P_prod(i, F(tv))
    pf = mp.mpf(Fprod.numerator) / mp.mpf(Fprod.denominator)
    nlo = 13 * tvF / 8 - 1
    return mp.sqrt(pf) * nlo ** (-float(P_[i])) * 2 * (13 * tvF / 8) ** 0.5 * mp.mpf(78) / 70 / D_[i]


print()
print("=== continuous ratio sanity (float) ===")
for i in (2, 4, 6, 7):
    print(f"i={i}: R(13) = {float(Rval(i, 13)):.8e}   R(1e8) = {float(Rval(i, 10**8)):.8e}")
print(f"sum R_i(13)  = {float(sum(Rval(i, 13) for i in (2, 4, 6, 7))):.8f}")
print(f"sum R_i(1e8) = {float(sum(Rval(i, 10**8) for i in (2, 4, 6, 7))):.8f}")

# ---------------------------------------------------------------- K factor decompositions
# (each K = S * I * T * C with strict rational factors; the Lean block proves
# R_i(endpoint) < S * I * T * C = K termwise, so the exact factor values matter.)
print()
print("=== K factor decompositions (exact) ===")
for (i, T, K) in ((2, T13, K2), (4, T13, K4), (6, T13, K6), (7, T8, K7), (7, T13, B7_13)):
    Pr = P_prod(i, T)
    nlo = F(13 * T, 8) - 1
    k = (P_[i].numerator - 1) // 2
    Sv, Iv, Tv = sqrt_ub(Pr), F(1) / (nlo ** k * sqrt_lb(nlo)), 2 * sqrt_ub(F(13 * T, 8))
    Cv = F(78, 70) / D_[i]
    assert Sv * Iv * Tv * Cv == K
    print(f"i={i} T={T}: P={Pr}  nlo={nlo}")
    print(f"  S = {Sv}   I(k={k}) = {Iv}   T = {Tv}   C = {Cv}")
Pr7 = P_prod(7, T8)
nlo8 = F(13 * T8, 8) - 1
SV7, IV7, TV7 = sqrt_lb(Pr7), F(1) / (nlo8 ** 7 * sqrt_ub(nlo8)), 2 * sqrt_lb(F(13 * T8, 8))
CV7 = F(78, 70) / D_[7]
assert SV7 * IV7 * TV7 * CV7 == LB7_1e8
print(f"LB7: S_lb = {SV7}   I(ub) = {IV7}   T_lb = {TV7}   C = {CV7}")
