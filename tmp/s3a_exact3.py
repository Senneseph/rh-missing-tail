from sympy import symbols, Rational, expand, together, Poly, factor
from fractions import Fraction as F
g, k, d = symbols('g k d', positive=True)
C = Rational(1,4)
v, u, w = symbols('v u w', nonnegative=True)

Rcorner = (g**2 + C)*(k**2 + 1)*((4*g + k)**2 + 1) / (4*k*(4*g + k)*(g**2 + 1)*g**2)
Rgen = (g**2 + C) * ((k/2)**2 + d**2) * ((2*g + k/2)**2 + d**2) / \
       ((k/2) * (2*g + k/2) * (g**2 + (Rational(1,2)+d)**2) * (g**2 + (Rational(1,2)-d)**2))

# ---- dcorner difference with a POSITIVE factored denominator ----
Rc_n, Rc_d = (g**2 + C)*(k**2 + 1)*((4*g + k)**2 + 1), 4*k*(4*g + k)*(g**2 + 1)*g**2
Rg2 = Rational(1,2)
Rg_n = (g**2 + C) * ((k/2)**2 + d**2) * ((2*g + k/2)**2 + d**2)
Rg_d = (k/2) * (2*g + k/2) * (g**2 + (Rational(1,2)+d)**2) * (g**2 + (Rational(1,2)-d)**2)
# Rcorner - Rgen = (Rc_n/Rc_d) - (Rg_n/Rg_d) = (Rc_n*Rg_d - Rg_n*Rc_d) / (Rc_d * Rg_d)
Dnum = expand(Rc_n*Rg_d - Rg_n*Rc_d)
Dden = expand(Rc_d * Rg_d)
DdenF = Rc_d * Rg_d  # factored, all factors positive on domain
print("dcorner numerator (in g,k,d):")
print(expand(Dnum))
print()
# substitute g = 15 + v, d = 1/2 - u  (v, u >= 0); then k = 1 + w
Dn = expand(Dnum.subs(g, 15 + v).subs(d, Rational(1,2) - u).subs(k, 1 + w))
poly = Poly(Dn, v, u, w)
negcnt = 0
maxbad = None
for (vv, uu, ww), coef in poly.terms():
    if coef < 0:
        negcnt += 1
        if maxbad is None or coef < maxbad[1]:
            maxbad = ((vv,uu,ww), coef)
print("dcorner: total terms:", len(poly.terms()), " negative coefficients (v,u,w):", negcnt)
if maxbad: print("worst:", maxbad)
if negcnt == 0:
    print("Dn = sum of terms with NONNEGATIVE coefficients in v,u,w  =>  >= 0 on g>=15, d<=1/2, k>=1  (q.e.d.)")
