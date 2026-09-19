"""Verify the small-ring decomposition:
LHS(v) = N4(v) = Aco*v^2 + b(v)*v - Xf*q, b(v) = u*Dstar - Xf*(2u+1/2)
then N4(v) = Aco (v-v0)^2 + (b + 2 Aco v0) (v-v0) + [Aco v0^2 + b v0 - Xf q]
with bracket = 0 (N4(v0) = Dstar*(10^6 (u+4*10^6) - Xf) = 0) and b + 2 Aco v0 = Bsh.
All exact fractions, grid-checked."""
from fractions import Fraction as F
import itertools

def evu(p, u):
    return sum(c * u ** a for a, c in p.items())

U0 = F(10) ** 6
v0 = U0

def Dstarv(u):  # Dstar as 1D poly in u
    return F(10 ** 12) + F(5 * 10 ** 5) + F(1, 16) + F(2 * 10 ** 6) * u + u ** 2

def Xfv(u):
    return F(10 ** 6) * (u + F(4) * F(10 ** 6))

def Acov(u):
    # 4*(1/4-u)^2 + 7*10^6 u + 2*10^6
    return 4 * (F(1, 4) - u) ** 2 + F(7 * 10 ** 6) * u + F(2 * 10 ** 6)

def N4(u, v):
    q = (F(1, 4) - u) ** 2
    D = F(10 ** 12) + F(10 ** 6) * (2 * u + F(1, 2)) + q
    Xf = F(10 ** 6) * (u + F(4) * F(10 ** 6))
    return (u + 4 * v) * v * D - Xf * (v ** 2 + (2 * u + F(1, 2)) * v + q)

def Bshv(u):
    D = Dstarv(u)
    Xf = Xfv(u)
    return u * D - Xf * (2 * u + F(1, 2)) + F(2 * 10 ** 6) * Acov(u)

ok1 = ok2 = ok3 = True
for num in [1, 7, 13, 41]:
    u = F(num, 100)
    q = (F(1, 4) - u) ** 2
    D = Dstarv(u)
    Xf = Xfv(u)
    for vv in [10 ** 6, 10 ** 6 + 12345, 4 * 10 ** 9, 10 ** 12]:
        v = F(vv)
        b = u * D - Xf * (2 * u + F(1, 2))
        lhs = N4(u, v)
        rhs1 = Acov(u) * v ** 2 + b * v - Xf * q
        if lhs != rhs1:
            ok1 = False
            print("decomp FAIL", num, vv)
        rhs2 = Acov(u) * (v - v0) ** 2 + (b + 2 * Acov(u) * v0) * (v - v0)
        if lhs != rhs2:
            ok2 = False
            print("sform FAIL", num, vv)
        if b + 2 * Acov(u) * v0 != Bshv(u):
            ok3 = False
            print("Bsh FAIL", num, vv)
    # N4(v0) = 0 exactly: Dstar*(10^6(u+4*10^6) - Xf)
    assert D * (v0 * (u + 4 * v0) - Xf) == 0
print("decomp ok:", ok1, "| sform ok:", ok2, "| Bsh match:", ok3)
# positivity spot check of 6*10^12 - 5*10^5 - 2*10^6 u on (0,1/4]
u = F(1, 4)
print("min bracket:", float(F(6 * 10 ** 12) - F(5 * 10 ** 5) - F(2 * 10 ** 6) * u))
