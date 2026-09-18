"""25ae 3B.11 Part B -- exact machinery, v2 (reduced numerators)."""
from fractions import Fraction as F
from sympy import symbols, Rational, Poly, expand, diff
import math

t = symbols('t', positive=True)
S = {2: 2, 4: 4, 6: 6, 8: 8}
P = {2: Rational(7, 2), 4: Rational(11, 2), 6: Rational(15, 2), 8: Rational(15, 2)}

def h(i):
    return S[i] * t / (t * t + Rational(169, 4)) + Rational(1, 2) / t \
        - P[i] * Rational(13, 8) / (13 * t / 8 - 1)

print("=== reduced h_i = N_i / D ===")
for i in (2, 4, 6, 8):
    N, D = h(i).cancel().as_numer_denom()
    N, D = expand(N), expand(D)
    print(f"h({i}): N = {N}")
    print(f"        D = {D}")
    print()

# Rbar_i(t) = (t^2+169/4)^{i/2} * (13t/8-1)^{-p_i} * 2 (13t/8)^{1/2} (78/70) / d_i
def Rbar(i, Tv):
    Tv = Rational(Tv)
    d = {2: 720, 4: 30240, 6: 1209600, 8: 9072000}[i]
    rad = Tv * Tv + Rational(169, 4)          # rational
    radpow = rad ** (i // 2)                   # (t^2+169/4)^{i/2}, exact rational
    nlo = Rational(13, 8) * Tv - 1             # rational
    return radpow * nlo ** (-P[i]) * 2 * Rational(13 * Tv, 8) ** Rational(1, 2) * Rational(78, 70) / d

r4_13 = Rbar(8, 13)
r4_100 = Rbar(8, 100)
r4_1e8 = Rbar(8, 10**8)
print(f"R4(13)   = {float(r4_13):.10f}  (exact irr: (845/4)^4 * (161/8)^(-15/2) * ...)")
print(f"R4(100)  = {float(r4_100):.10f}")
print(f"R4(1e8)  = {float(r4_1e8):.10f}")
print(f"R4(13) < R4(1e8) ? {float(r4_13) < float(r4_1e8)}")
print(f"R4(10) etc sanity: R4(13) < R4(100) < R4(1e8) ? "
      f"{float(r4_13) < float(r4_100) < float(r4_1e8)}")

print()
print("=== h_i exact signs ===")
for i in (2, 4, 6, 8):
    for tv in (Rational(13), Rational(100), Rational(10**8)):
        print(f"h({i})({tv}) = {float(h(i).subs(t, tv)):+.6e}")
    print()

print("=== N8 derivative ===")
N8 = expand(h(8).cancel().as_numer_denom()[0])
N8p = expand(diff(N8, t))
print(f"N8 = {N8}")
print(f"N8' = {N8p}")
print(f"N8(100) = {F(int(N8.subs(t, 100)))}")
print(f"N8'(100) = {F(int(N8p.subs(t, 100)))}")
print(f"N8' > 0 on [100, Inf): for t>=100: 156t^2-544t-15379 >= (156*100-544)t - 15379 = 15056 t - 15379 > 0")

print()
print("=== exact K constants ===")

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
    T = F(T)
    d = {2: 720, 4: 30240, 6: 1209600, 8: 9072000}[i]
    rad = T * T + F(169, 4)
    radpow = rad ** (i // 2)
    nlo = F(13 * T, 8) - 1
    k = (P[i].numerator - 1) // 2
    invpow = F(1) / (nlo**k * sqrt_lb(nlo))
    pref = 2 * sqrt_ub(F(13 * T, 8))
    return radpow * invpow * pref * F(78, 70) / d


K1, K2, K3, K4 = (K(2, 13), K(4, 13), K(6, 13), K(8, F(10**8)))
for nm, Kv in (('K1', K1), ('K2', K2), ('K3', K3), ('K4', K4)):
    print(f"{nm} = {Kv}   ({float(Kv):.12f})")
tot = K1 + K2 + K3 + K4
print(f"SUM = {float(tot):.12f}  < 1 ? {tot < 1}   margin = {float(1 - tot):.8f}")
print(f"SUM exact = {tot}")
