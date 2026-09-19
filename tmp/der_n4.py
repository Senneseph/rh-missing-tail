"""Correct s-form for N4(v) = (u+4v)*v*Dstar - Xf*AB(v), Xf = 10^6(u+4*10^6):
N4 >= 0 for v >= 10^6 is exactly FshU(u)/v <= u(u+4v)/AB(v) after cancelling u.
Also verify the FshU-in-u monotonicity cross-factor Q. Exact fractions."""
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
Xf = {(1, 0): F(10 ** 6), (0, 0): F(4 * 10 ** 12)}  # 10^6 (u + 4*10^6)
AB = poly_add({(0, 2): F(1), (1, 1): F(2), (0, 1): F(1, 2)}, q2)
# N4 = (u+4v) * v * Dstar - Xf * AB
lhs = poly_mul({(1, 1): F(1), (0, 2): F(4)}, Dstar)
N4 = poly_sub(lhs, poly_mul(Xf, AB))


def subst_v(p, v0=10 ** 6):
    out = {}
    for (u, v), coeff in p.items():
        for i in range(v + 1):
            coef = coeff * F(math.comb(v, i)) * F(v0) ** (v - i)
            out[(u, i)] = out.get((u, i), F(0)) + coef
    for k in [k for k, cc in out.items() if cc == 0]:
        del out[k]
    return out


Ns = subst_v(N4)
s0 = {u: cc for (u, i), cc in Ns.items() if i == 0}
s1 = {u: cc for (u, i), cc in Ns.items() if i == 1}
s2 = {u: cc for (u, i), cc in Ns.items() if i == 2}
s3 = {u: cc for (u, i), cc in Ns.items() if i >= 3}
print("N4(10^6) identically zero:", s0 == {})
print("no s^3 term:", s3 == {})
Aco4 = s2
Bsh4 = s1
print("Aco4 u-coeffs:", sorted(Aco4.items()))
print("Bsh4 u-coeffs:", sorted(Bsh4.items()))

# Aco4 should equal 4*Dstar - Xf = 10^6 u + 2*10^6 + 4q
chk = poly_sub(poly_mul({(0, 0): F(4)}, Dstar), Xf)
print("Aco4 == 4*Dstar - Xf:", Aco4 == chk)


def evu(p, u):
    return sum(cc * u ** a for a, cc in p.items())


def ev2(p, u, v):
    return sum(cc * u ** a * v ** b for (a, b), cc in p.items())


ok = True
for ui in [1, 7, 13, 41]:
    for vi in [10 ** 6, 10 ** 6 + 1234567, 4 * 10 ** 9, 10 ** 12]:
        u, v = F(ui, 10 ** 6), F(vi)
        d = ev2(N4, u, v) - evu(Aco4, u) * (v - 10 ** 6) ** 2 - evu(Bsh4, u) * (v - 10 ** 6)
        if d != 0:
            ok = False
            print("MISMATCH N4", ui, vi, d)
print("N4 identity exact on grid:", ok)

# the actual floor inequality: FshU(u)/v <= u(u+4v)/AB  <=> N4 >= 0 (u>0)
# FshU(u) = 10^6 * u * (u + 4*10^6)
FshU = poly_mul({(0, 0): F(10 ** 6)},
                poly_mul({(1, 0): F(1)}, {(1, 0): F(1), (0, 0): F(4 * 10 ** 6)}))
ok2 = True
worst = None
for num in range(1, 25):
    u = F(num, 100)
    for v in [10 ** 6, 10 ** 7, 10 ** 9, 10 ** 12]:
        # mown side without e^c: u(u+4v)/AB
        lhsv = ev2(FshU, u, 1) / ev2(Dstar, u, 1) / v
        rhsv = ev2({(2, 0): F(1), (1, 1): F(4)}, u, v) / ev2(AB, u, v)
        diff = rhsv - lhsv
        if diff < 0:
            ok2 = False
            print("FLOOR FAIL", num, v, float(diff))
        if worst is None or diff < worst:
            worst = diff
print("floor inequality holds on grid:", ok2, " worst margin:", float(worst) if worst is not None else None)

# positivity of Aco4, Bsh4 on u in (0, 1/4]
am, bm = None, None
for num in list(range(1, 26)):
    u = F(num, 100)
    a, b = evu(Aco4, u), evu(Bsh4, u)
    am = a if am is None or a < am else am
    bm = b if bm is None or b < bm else bm
print("min Aco4 on (0,1/4]:", float(am))
print("min Bsh4 on (0,1/4]:", float(bm))
u = F(1, 4)
print("Aco4(1/4) =", float(evu(Aco4, u)), " Bsh4(1/4) =", float(evu(Bsh4, u)))
u = F(1, 10 ** 6)
print("Aco4(1e-6) =", float(evu(Aco4, u)), " Bsh4(1e-6) =", float(evu(Bsh4, u)))

# ---- FshU-in-u monotonicity: Nsh(u)*Dstar(u') cross factor ----
# Nsh(u) = 10^6 u (u + 4*10^6); claim Nsh(u2) Dstar(u1) - Nsh(u1) Dstar(u2) = (u2-u1)*Q, Q>0
Nsh = poly_mul({(0, 0): F(10 ** 6)}, {(2, 0): F(1), (1, 0): F(4 * 10 ** 6)})
# cross = Nsh(u2)*Dstar(u1) - Nsh(u1)*Dstar(u2): polynomial in (u1=u, u2=v)
# build with dict keyed (u1power, u2power)
def cross_poly():
    # Nsh(u2)*Dstar(u1): key (u1power, u2power)
    a = {}
    for (u2p, _v2), c2 in Nsh.items():
        for (u1p, _v1), c1 in Dstar.items():
            k = (u1p, u2p)
            a[k] = a.get(k, F(0)) + c1 * c2
    b = {}
    for (u1p, _v1), c1 in Nsh.items():
        for (u2p, _v2), c2 in Dstar.items():
            k = (u1p, u2p)
            b[k] = b.get(k, F(0)) + c1 * c2
    return a, b

a, b = cross_poly()
cross = {}
for k, cc in a.items():
    cross[k] = cross.get(k, F(0)) + cc
for k, cc in b.items():
    cross[k] = cross.get(k, F(0)) - cc
for k in [k for k, cc in cross.items() if cc == 0]:
    del cross[k]
# divide by (u2 - u1): expect exact polynomial Q(u1,u2)
def ev_cross(p, u1, u2):
    return sum(cc * u1 ** a1 * u2 ** a2 for (a1, a2), cc in p.items())

Q = {}
# candidate Q = 10^6 K (u1+u2) + 4*10^12 K + u1 u2 (10^6(2*10^6-1/2) - 4*10^12), K = 10^12 + 5*10^5 + 1/16
K = F(10 ** 12) + F(5 * 10 ** 5) + F(1, 16)
def Qval(u1, u2):
    return (F(10 ** 6) * K * (u1 + u2) + F(4 * 10 ** 12) * K
            + u1 * u2 * (F(10 ** 6) * (F(2 * 10 ** 6) - F(1, 2)) - F(4 * 10 ** 12)))

okq = True
for u1n in [1, 3, 9, 17]:
    for u2n in [u1n, u1n + 1, u1n * 2, 25]:
        u1, u2 = F(u1n, 100), F(u2n, 100)
        if u2 > F(1, 4) or u1 <= 0:
            continue
        lhs_ = ev_cross(cross, u1, u2)
        rhs_ = (u2 - u1) * Qval(u1, u2)
        if lhs_ != rhs_:
            okq = False
            print("Q MISMATCH", u1, u2, lhs_ - rhs_)
print("Q factor exact on grid:", okq)
# Q positivity on 0 < u1 <= u2 <= 1/4
qm = None
for u1n in range(1, 26):
    for u2n in range(u1n, 26):
        u1, u2 = F(u1n, 100), F(u2n, 100)
        qv = Qval(u1, u2)
        qm = qv if qm is None or qv < qm else qm
print("min Q on grid (0<u1<=u2<=1/4]:", float(qm))
