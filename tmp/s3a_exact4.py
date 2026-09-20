from sympy import symbols, Rational, expand, together, Poly
from fractions import Fraction as F
g, k = symbols('g k', positive=True)
v = symbols('v', nonnegative=True)
C = Rational(1,4)
Rcorner = (g**2 + C)*(k**2 + 1)*((4*g + k)**2 + 1) / (4*k*(4*g + k)*(g**2 + 1)*g**2)

print("== c_i(k0) for kmon, P(15+v, k0) = sum c_i v^i ==")
Pk = Rcorner.subs(k, k+1) - Rcorner
Pk = together(Pk)
num, den = Pk.as_numer_denom()
for K0 in range(1, 12):
    nK = expand(num.subs(k, K0))
    nKv = expand(nK.subs(g, 15 + v))
    poly = Poly(nKv, v)
    coefs = [poly.coeff_monomial(v**i) for i in range(poly.degree()+1)]
    assert all(c > 0 for c in coefs), (K0, coefs)
    print(f"K0={K0}: " + ", ".join(str(c) for c in coefs))

print()
print("== 13/g bound: 13/g - R12 (g) ==")
R12 = Rcorner.subs(k, 12)
D = together(13/g - R12)
n, e = D.as_numer_denom()
n = expand(n); e = expand(e)
print("denominator (all > 0 for g > 0):", e)
print("numerator:", n)
def val(G): return float(D.subs(g, G))
lo, hi = 15, 500
while hi - lo > 0.001:
    mid = (lo+hi)/2
    if val(mid) >= 0: hi = mid
    else: lo = mid
print("13/g crossing ~", hi)
G0 = int(hi) + 1
for G in range(max(15, G0-2), G0+3):
    print(f"  g={G}: Ra={float(R12.subs(g, G)):.9f}  13/g={13/G:.9f}  diff={val(G):.4g}")
nv = expand(n.subs(g, G0 + v))
poly = Poly(nv, v)
coefs = [poly.coeff_monomial(v**i) for i in range(poly.degree()+1)]
print("numerator at g =", G0, "+ v, coefficients (need >= 0):", coefs, "all>=0:", all(c >= 0 for c in coefs))
# also exact rational crossing values for the crossing theorems
print()
print("R12(15) =", R12.subs(g, 15))
print("R12(14) =", R12.subs(g, 14))
print("13/15 - R12(15) =", (Rational(13)/15 - R12.subs(g, 15)))
