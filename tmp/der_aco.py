"""Derive Aco/Bsh exactly (poly dict, Fraction coeffs), verify identity + positivity."""
from fractions import Fraction as F
import math


def poly_add(p, q):
    out = dict(p)
    for k, cc in q.items():
        out[k] = out.get(k, F(0)) + cc
        if out[k] == 0:
            del out[k]
    return out


def poly_sub(p, q):
    return poly_add(p, {k: -cc for k, cc in q.items()})


def poly_mul(p, q):
    out = {}
    for (u1, v1), c1 in p.items():
        for (u2, v2), c2 in q.items():
            k = (u1 + u2, v1 + v2)
            out[k] = out.get(k, F(0)) + c1 * c2
    for k in [k for k, cc in out.items() if cc == 0]:
        del out[k]
    return out


ONE4 = F(1, 4)
q2 = poly_mul(poly_add({(0, 0): ONE4}, {(1, 0): F(-1)}),
              poly_add({(0, 0): ONE4}, {(1, 0): F(-1)}))
Dstar = poly_add(
    poly_add({(0, 0): F(10 ** 12)}, {(1, 0): F(2 * 10 ** 6), (0, 0): F(5 * 10 ** 5)}),
    q2)
f = poly_mul({(1, 1): F(1), (2, 2): F(4)}, Dstar)
X = {(2, 0): F(10 ** 6), (1, 0): F(4 * 10 ** 12)}
AB = poly_add({(2, 2): F(1), (1, 1): F(2), (0, 1): F(1, 2)}, q2)
N = poly_sub(f, poly_mul(X, AB))


def subst_v(p):
    out = {}
    for (u, v), coeff in p.items():
        for i in range(v + 1):
            coef = coeff * F(math.comb(v, i)) * F(10 ** 6) ** (v - i)
            out[(u, i)] = out.get((u, i), F(0)) + coef
    for k in [k for k, cc in out.items() if cc == 0]:
        del out[k]
    return out


Ns = subst_v(N)
s0 = {u: cc for (u, i), cc in Ns.items() if i == 0}
s1 = {u: cc for (u, i), cc in Ns.items() if i == 1}
s2 = {u: cc for (u, i), cc in Ns.items() if i == 2}
s3 = {u: cc for (u, i), cc in Ns.items() if i >= 3}
print("s^0 identically zero (N(10^6) = 0):", s0 == {})
print("s^3 (should be empty):", s3)
print("Aco (s^2) u-coeffs:", sorted(s2.items()))
print("Bsh (s^1) u-coeffs:", sorted(s1.items()))


def evu(p, u):
    return sum(cc * u ** a for a, cc in p.items())


ok = True
for ui in [1, 7, 13, 41]:
    for vi in [10 ** 6, 10 ** 6 + 1234567, 4 * 10 ** 9, 10 ** 12]:
        u, v = F(ui, 10 ** 6), F(vi)
        nval = sum(cc * u ** a * v ** b for (a, b), cc in N.items())
        d = nval - evu(s2, u) * (v - 10 ** 6) ** 2 - evu(s1, u) * (v - 10 ** 6)
        if d != 0:
            ok = False
            print("MISMATCH", ui, vi, d)
print("identity exact on grid:", ok)

am, bm = None, None
for num in list(range(1, 26)):
    u = F(num, 100)
    a, b = evu(s2, u), evu(s1, u)
    am = a if am is None or a < am else am
    bm = b if bm is None or b < bm else bm
print("min Aco on (0,1/4]:", float(am))
print("min Bsh on (0,1/4]:", float(bm))
u = F(1, 4)
print("Aco(1/4) =", float(evu(s2, u)), " Bsh(1/4) =", float(evu(s1, u)))
u = F(1, 10 ** 6)
print("Aco(1e-6) =", float(evu(s2, u)), " Bsh(1e-6) =", float(evu(s1, u)))
