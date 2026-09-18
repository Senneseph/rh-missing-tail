"""25ae 3B.11 Part B -- exact integer numerators over structured denominator.
Den_i(t) := 16*t*(13*t-8) * prod_{k=0}^i (4*t^2 + (2k+1)^2)   [positive for t >= 13]
h_i(t) = Num_i(t) / Den_i(t),  Num_i integer polynomial (verify all coefficients for i in {2,4,6} < 0;
         for i=7: Num_7(13+u) = sum b_k u^k with b_0 < 0, b_k > 0 for k>=1)."""
from fractions import Fraction as F
from sympy import symbols, Rational, expand, Poly, together

t = symbols('t')
P = {2: Rational(7, 2), 4: Rational(11, 2), 6: Rational(15, 2), 7: Rational(15, 2)}

for i in (2, 4, 6, 7):
    A = sum(4 * t / (4 * t * t + (2 * k + 1) ** 2) for k in range(i + 1)) + 1 / (2 * t)
    B = P[i] * 13 / (13 * t - 8)  # == P[i]*(13/8)/(13t/8-1), denominator (13t-8) cancels literally
    h = A - B
    # structured denominator
    den = 16 * t * (13 * t - 8)
    for k in range(i + 1):
        den *= 4 * t * t + (2 * k + 1) ** 2
    den_e = expand(den)
    # num such that h = num/den  (expand term-by-term to avoid premature LCM reduction)
    num = sum(expand(q * den) for q in [4 * t / (4 * t * t + (2 * k + 1) ** 2) for k in range(i + 1)] + [1 / (2 * t), -P[i] * 13 / (13 * t - 8)])
    num = expand(num)
    den_left = num.as_numer_denom()[1]
    assert not den_left.free_symbols, f"i={i}: denominator residue {den_left}"
    pnum = Poly(num, t)
    coeff = [pnum.coeff_monomial(t ** e) for e in range(len(pnum.all_coeffs()))]
    assert all(c.is_integer for c in coeff), (i, coeff)
    coeff = [int(c) for c in coeff]
    print(f"--- i={i}  (deg {len(coeff)-1}) ---")
    print("  Num_i coeffs (low to high):", coeff)
    if i in (2, 4, 6):
        assert all(c < 0 for c in coeff), f"i={i}: non-negative coefficient!"
        print("  ALL COEFFS < 0  ->  h_i < 0 for all t > 0  OK")
    if i == 7:
        # shift to t = 13
        u = symbols('u')
        sh = expand(num.subs(t, 13 + u))
        psh = Poly(sh, u)
        csh = [int(psh.coeff_monomial(u ** e)) for e in range(len(psh.all_coeffs()))]
        print("  Num7(13+u) coeffs (low to high):")
        for e, c in enumerate(csh):
            print(f"    b_{e} = {c}   {'<0' if c<0 else ('>0' if c>0 else 'ZERO')!r}")
        assert csh[0] < 0
        assert all(c > 0 for c in csh[1:]), "not all shifted coeffs positive!"
        print("  SHIFTED: b_0 < 0, b_k > 0 for k>=1  OK")
    # value checks at 13 and 100
    hnum13 = sum(c * 13 ** e for e, c in enumerate(coeff))
    hden13 = den_e.subs(t, Rational(13))
    assert hden13 > 0, "Den must be positive"
    print(f"  h({13}) rational = {hnum13}/{int(hden13)} = {float(hnum13/hden13):+.8e}")
    hnum100 = sum(c * 100 ** e for e, c in enumerate(coeff))
    hden100 = den_e.subs(t, Rational(100))
    print(f"  h({100}) rational = {hnum100}/{int(hden100)} = {float(hnum100/hden100):+.8e}")
    print()

# Den positivity on [13, inf): all factors positive (obvious); also check Den2(13) etc.
print("Den check at t=13 (all > 0):")
for i in (2, 4, 6, 7):
    den = 16 * Rational(13) * (13 * Rational(13) - 8)
    for k in range(i + 1):
        den *= 4 * Rational(13) ** 2 + (2 * k + 1) ** 2
    print(f"  i={i}: Den = {int(den)} > 0")
