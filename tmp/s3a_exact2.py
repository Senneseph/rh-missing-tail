from sympy import symbols, Rational, expand, together, Poly, nsimplify
from fractions import Fraction as F
g, k = symbols('g k', positive=True)
C = Rational(1,4)
s, u, v = symbols('s u v', nonnegative=True)

def Ralg(g, k, d):
    num = (g**2 + C) * ((k/2)**2 + d**2) * ((2*g + k/2)**2 + d**2)
    den = (k/2) * (2*g + k/2) * (g**2 + (Rational(1,2)+d)**2) * (g**2 + (Rational(1,2)-d)**2)
    return num/den

Rcorner = (g**2 + C)*(k**2 + 1)*((4*g + k)**2 + 1) / (4*k*(4*g + k)*(g**2 + 1)*g**2)

# ---- (a) kmon: explicit coefficients c_i(k) ----
Rk = Rcorner
Pk = together(Rk.subs(k, k+1) - Rk)
num, den = Pk.as_numer_denom()
den = expand(den)
print("kmon denominator (must be > 0):", den)
numS = expand(num.subs(g, 15 + v))
poly = Poly(numS, v)
for i in range(poly.degree()+1):
    c = poly.coeff_monomial(v**i)
    print(f"c_{i}(k) =", expand(c))

# ---- (b) dcorner: Rcorner - Ralg(g,k,d) >= 0 ----
d = symbols('d')
D = together(Rcorner - Ralg(g, k, d))
dn, de = D.as_numer_denom()
dn = expand(dn); de = expand(de)
print("\ndcorner denominator:", de)
# domain: g >= 15, k in [1,12], 0 <= d <= 1/2.  substitute g = 15+v, d = 1/2 - u
dnS = expand(dn.subs(g, 15 + v).subs(d, Rational(1,2) - u))
poly = Poly(dnS, v, u)
terms = poly.terms()
print("dcorner numerator in (v,u): degree v:", max(t[0] for t in terms), "degree u:", max(t[1] for t in terms))
neg = 0
for (vv, uu), coef in terms:
    mn = min(coef.subs(k, kk) for kk in (1, 12))
    mx = max(coef.subs(k, kk) for kk in (1, 12))
    if mn < 0:
        neg += 1
        print(f"  NEG term v^{vv} u^{uu}: coef(k) in [{float(mn):.4g},{float(mx):.4g}]: {coef}")
print("negative-coefficient terms (corner k in {1,12}):", neg)

# ---- (c) 13/g bound crossing ----
R12 = Rcorner.subs(k, 12)
for Cb in (12, 13, 14):
    D13 = together(Cb/g - R12)
    n13, e13 = D13.as_numer_denom()
    n13 = expand(n13)
    print(f"\n{Cb}/g - Ralg(.,12,1/2): numerator = {n13}")
# find smallest g0 for 13/g by bisection on the exact rational
from sympy import Integer
f13 = together(13/g - R12)
def val(G):
    return float(f13.xreplace(g=G))
lo, hi = 15, 200
while hi - lo > 0.01:
    mid = (lo+hi)/2
    if val(mid) >= 0: hi = mid
    else: lo = mid
print("13/g crossing ~", hi)
for G in (int(hi)-1, int(hi), int(hi)+1, int(hi)+2):
    print(f"  g={G}: 13/g - Ra = {float(f13.xreplace(g=G)):.6g}  Ra = {float(R12.xreplace(g=G)):.6g}  13/g = {13/G:.6g}")
