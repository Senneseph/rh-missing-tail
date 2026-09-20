# Exact sympy sign-analysis for the S3a Lean port.
# R_alg(g,k,d) = (g^2+1/4)(k^2/4+d^2)((2g+k/2)^2+d^2) /
#                [(k/2)(2g+k/2)(g^2+(1/2+d)^2)(g^2+(1/2-d)^2)]
# Corner d=1/2 simplifies to:
#   R_alg(g,k,1/2) = (g^2+1/4)(k^2+1)((4g+k)^2+1) / [4*k*(4g+k)*(g^2+1)*g^2]
from sympy import symbols, Rational, expand, factor, nsimplify, Poly, gcd, simplify, together
from fractions import Fraction as F

g, k, d = symbols('g k d', positive=True)
C = Rational(1,4)

def Ralg(g, k, d):
    num = (g**2 + C) * ((k/2)**2 + d**2) * ((2*g + k/2)**2 + d**2)
    den = (k/2) * (2*g + k/2) * (g**2 + (Rational(1,2)+d)**2) * (g**2 + (Rational(1,2)-d)**2)
    return num/den

# ---- 1) exact corner values (g0 crossing) ----
for G in (14, 15):
    v = Ralg(G, 12, Rational(1,2))
    print(f"Ralg({G},12,1/2) = {v}  ~ {float(v):.9f}  < 1: {v < 1}")

# ---- 2) k-monotonicity at d=1/2: P(g,k) = Ralg(g,k+1,1/2) - Ralg(g,k,1/2) ----
Rk = (g**2 + C)*(k**2 + 1)*((4*g + k)**2 + 1) / (4*k*(4*g + k)*(g**2 + 1)*g**2)
Pk = together(Rk.subs(k, k+1) - Rk)
num, den = Pk.as_numer_denom()
num = expand(num)
den = expand(den)
print("\nkmon numerator degree in g:", num.as_poly(g).degree() if num.has(g) else 0)
# write g = 15 + s
s = symbols('s', nonnegative=True)
numS = expand(num.subs(g, 15 + s))
poly = Poly(numS, s)
print("kmon in s: degree", poly.degree())
ok = True
for i in range(poly.degree()+1):
    c = poly.coeff_monomial(s**i)
    cmin = min(c.subs(k, kk) for kk in range(1, 12))
    cmax = max(c.subs(k, kk) for kk in range(1, 12))
    if cmin < 0: ok = False
    print(f"  s^{i}: coeff(k) in [{float(cmin):.4g}, {float(cmax):.4g}]", "neg!" if cmin < 0 else "ok")
print("kmon all-coeffs >= 0 for k=1..11:", ok)

# ---- 3) d-monotonicity: derivative wrt s = d^2, fixed g,k ----
dv = symbols('dv')
numf = (g**2 + C) * ((k/2)**2 + dv) * ((2*g + k/2)**2 + dv)
dens = (k/2)*(2*g + k/2)
hd = (g**2 + (Rational(1,2)+d)**2) * (g**2 + (Rational(1,2)-d)**2)
# express h in s = d^2: h = g^4 + g^2*(1 + 2s) + (1/4 - s)^2
sv = symbols('sv', nonnegative=True)
h = g**4 + g**2*(1 + 2*sv) + (Rational(1,4) - sv)**2
f = numf.subs(dv, sv) * h  # log-derivative: d/ds log Ralg = f'/f - h'/h... simpler: sign of (f h' - f' h)
Fp = f.diff(sv)
Hp = h.diff(sv)
Df = expand(f*Hp - Fp*h)  # > 0 means Ralg decreasing in s?? check sign convention
# Ralg = num/(dens*h); d/ds Ralg has sign of (num' h - num h') (dens const)
Dv = expand(numf.subs(dv, sv).diff(sv)*h - numf.subs(dv, sv)*Hp)
print("\ndmon: Dv (sign of d Ralg/ds) in sv:", Dv.as_poly(sv).degree() if Dv.has(sv) else "const")
Dv1 = Dv.subs(g, 15 + s2).subs(k, 12) if False else None
s2 = symbols('s2', nonnegative=True)
# check at worst-case k=12 (Dv is linear/quadratic in k? see structure)
for K in (1, 6, 12):
    DvK = expand(Dv.subs(k, K))
    p = Poly(DvK, sv)
    okk = all(min(c.subs(g, gg) for gg in [15]) >= 0 if c.has(g) else True for c in [p.coeff_monomial(sv**i) for i in range(p.degree()+1)])
    print(f"  k={K}: Dv coeffs in sv at g=15:", [str(p.coeff_monomial(sv**i))[:40] for i in range(p.degree()+1)])
# full sign: write Dv with g = 15 + s, k as symbol
s = symbols('s', nonnegative=True)
DvS = expand(Dv.subs(g, 15 + s))
poly = Poly(DvS, s)
ok = True
for i in range(poly.degree()+1):
    c = poly.coeff_monomial(s**i)
    # c is a polynomial in (k, sv); check its minimum on k in [1,12], sv in [0,1/4]
    try:
        from sympy import minimize
    except ImportError:
        pass
    vals = []
    for kk in (1, 12):
        for svv in (0, Rational(1,4)):
            vals.append(c.subs(k, kk).subs(sv, svv))
    mn = min(vals)
    if mn < 0: ok = False
    print(f"  s^{i}: corner values (k,sv) min={float(mn):.4g}", "neg!" if mn < 0 else "ok (corners)")
print("dmon corner check:", ok)
print("\nDv expanded (symbolic):", expand(Dv))
