from fractions import Fraction as F
import math

def Sprod(t, kmax):
    """Exact rational P = prod_{k=0..kmax} (t^2 + (k+1/2)^2)."""
    P = F(1)
    for k in range(kmax+1):
        a = F(2*k+1, 2)
        P *= (t*t + a*a)
    return P

def rad_strict_ub(P):
    """Strict rational upper bound q > sqrt(P), exact, float-free."""
    m = math.isqrt(P.numerator * P.denominator)
    return F(m + 1, P.denominator)   # sqrt(P) = sqrt(num*den)/den < (m+1)/den

def rad_strict_lb(P):
    """l <= sqrt(P), exact."""
    m = math.isqrt(P.numerator * P.denominator)
    return F(m, P.denominator)

target = F(70, 78)

print('=== Part A case 1: [1, 16/13), n = 1 ===')
tA = F(16, 13)
H_A = F(1, 2) * target          # (1/2)*1^{-1/2}*target
total = F(0)
for (kmax, pfrac, denom, name) in [(2, F(7,2), 720, 'T1'), (4, F(11,2), 30240, 'T2'),
                                   (6, F(15,2), 1209600, 'T3'), (8, F(15,2), 9072000, 'T4')]:
    P = Sprod(tA, kmax)
    q = rad_strict_ub(P)
    nval = F(1)**pfrac          # n = 1
    val = q / denom             # n^{3.5/5.5/7.5} = 1
    total += val
    print(f'{name}: q = {float(q):.12e}  q^2>=P: {q*q >= P}  term = {float(val):.12e}  rational: {val.numerator}/{val.denominator}')
print(f'T3UB_ub = {float(total):.12e}   H = {float(H_A):.12e}   ok = {total < H_A}   margin = {float(H_A-total):.6e}')
print('  exact T3UB_ub =', total.numerator, '/', total.denominator)

print()
print('=== Part A case 2: [16/13, 23], n >= 13t/8 - 1 ===')
tB = F(23)
total2 = F(0)
for (kmax, pfrac, denom, name) in [(2, F(7,2), 720, 'T1'), (4, F(11,2), 30240, 'T2'),
                                   (6, F(15,2), 1209600, 'T3'), (8, F(15,2), 9072000, 'T4')]:
    P = Sprod(tB, kmax)
    q = rad_strict_ub(P)
    # n >= 13*23/8 - 1 = 291/8  (valid for t >= 16/13: 13t/8 - 1 >= 13*(16/13)/8 - 1 = 1)
    nval = (F(291, 8)) ** (-pfrac)   # negative *half-integer* power -> use sqrt form
    # do it by hand to keep exact rationals: (291/8)^{-7/2} = (8/291)^3 * sqrt(8/291)
    if pfrac == F(7,2):
        nval = F(8,291)**3 * rad_strict_ub(F(8,291)) * F(1,2)  # NO - this is not an upper bound pattern
    total2 += q * ((F(8,291))**3 if pfrac == F(7,2) else (F(8,291))**5 if pfrac == F(11,2) else F(8,291)**7) / denom
    print(f'{name}: q = {float(q):.12e}  term (exact n-lb, no sqrt on n side: (291/8)^(-p) is irrational!)')
# STOP: (291/8)^{-7/2} is IRRATIONAL (sqrt(8/291) factor). Need rational upper bound for n^{-p}:
# (291/8)^{-7/2} = (8/291)^{3} * (8/291)^{1/2} <= (8/291)^3 * qH where qH > sqrt(8/291)
print()
print('=== Part A case 2, corrected (rational UBs everywhere) ===')
qH = rad_strict_ub(F(8, 291))   # > sqrt(8/291)
total2 = F(0)
for (kmax, pfrac, denom, name) in [(2, F(7,2), 720, 'T1'), (4, F(11,2), 30240, 'T2'),
                                   (6, F(15,2), 1209600, 'T3'), (8, F(15,2), 9072000, 'T4')]:
    P = Sprod(tB, kmax)
    q = rad_strict_ub(P)
    whole = pfrac.numerator // 2
    nval = F(8,291)**whole * qH
    val = q * nval / denom
    total2 += val
    print(f'{name}: q = {float(q):.12e}  nval = {float(nval):.12e}  term = {float(val):.12e}')
# H lower bound on [16/13, 23]: H(t) = (1/2) n(t)^{-1/2} target, n(t) = floor(1.625 t)
# H is decreasing in t on this interval? n increases 2 -> 37; |S| terms increase but T3UB also...
# H(t) >= min of H on interval = H(23) (n=37): (1/2)*sqrt(1/37)*target, use LOWER bound l <= sqrt(1/37):
l37 = rad_strict_lb(F(1, 37))
H_B = F(1, 2) * l37 * target
print(f'T3UB_ub = {float(total2):.12e}   H_lb = {float(H_B):.12e}   ok = {total2 < H_B}   margin = {float(H_B-total2):.6e}')
print('  exact T3UB_ub =', total2.numerator, '/', total2.denominator)
