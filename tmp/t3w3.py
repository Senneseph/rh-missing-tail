from fractions import Fraction as F
import math

def Sprod(t, kmax):
    P = F(1)
    for k in range(kmax+1):
        P *= (t*t + F(2*k+1,2)**2)
    return P

def ub(P):   # strict rational UB of sqrt(P)
    return F(math.isqrt(P.numerator*P.denominator)+1, P.denominator)
def lb(P):
    return F(math.isqrt(P.numerator*P.denominator), P.denominator)

def sqrt_rat_ub(a, b, den=10**30):
    """strict rational UB of sqrt(a/b): q = ceil-ish via isqrt: q = (isqrt(a*b)+1)/ (b*denscale)... standard: sqrt(a/b) = sqrt(a*b)/b ; q = (isqrt(a*b)+1)/b * (b/den)??
    simplest: q = F(isqrt(a*b)+1, b) is strict UB of sqrt(a/b)."""
    return F(math.isqrt(a*b)+1, b)

T = F(70,78)
print('T =', T)

# per-part data: (interval right endpoint t*, n_lb)
# A1: [1,16/13), n=1, |S| at 16/13
# A2: [16/13,4], n=2, |S| at 4
# A3: [4,8], n=6, |S| at 8
# A4: [8,13], n=13, |S| at 13
parts = [('A1', F(16,13), 1), ('A2', F(4), 2), ('A3', F(8), 6), ('A4', F(13), 13)]
KMAX = [(2,F(7,2),720),(4,F(11,2),30240),(6,F(15,2),1209600),(8,F(15,2),9072000)]
for name, tstar, nmin in parts:
    tot = F(0)
    for kmax, p, d in KMAX:
        q = ub(Sprod(tstar, kmax))
        if nmin == 1:
            nv = F(1)
        else:
            # n^{-p}, p = m + 1/2: n^{-p} = n^{-m} * n^{-1/2} <= n^{-m} * sqrt_rat_ub(1, n)
            m = p - F(1,2)
            nv = F(1, nmin**int(m.numerator)) * sqrt_rat_ub(F(1).numerator*nmin, nmin*nmin) # sqrt(1/n) = 1/sqrt(n) = sqrt(n)/n ; UB: (isqrt(n)+1)/n
        tot += q*nv/d
    # H lower bound: H >= (1/2)*n(t)^{-1/2}*T ; n(t) <= 1.625 tstar -> use n(t) <= floor(1.625*tstar)
    nmax = int((F(13,8)*tstar).numerator//F(13,8)*tstar.denominator) if False else math.floor(float(F(13,8)*tstar)+1e-12)
    H = F(1,2) * sqrt_rat_ub(1, nmax) * T if nmax > 0 else None
    # sqrt(1/nmax) = 1/sqrt(nmax); LOWER bound of H needs LOWER bound of n^{-1/2} = UPPER... careful:
    # H(t) = (1/2)*n(t)^{-1/2}*T >= (1/2)*nmax^{-1/2}*T  (n(t) <= nmax)
    # need nmax^{-1/2} from below: 1/sqrt(nmax) >= 1/(isqrt(nmax)+1)  (since sqrt(nmax) <= isqrt(nmax)+1)
    H = F(1,2) * F(1, math.isqrt(nmax)+1) * T
    print(f'{name}: t*={float(tstar):.6f} nmin={nmin} T3UB_ub={float(tot):.10e}  nmax={nmax}  H_lb={float(H):.10e}  ok={tot < H}  margin={float(H-tot):.3e}')

# ---- PART B h_i endpoints ----
# h_i(t) = s_i * t/(t^2+42.25) + 1/(2t) - p_i*(13/8)/(13t/8 - 1)   [log-deriv lower bound using (t^2+42.25) per factor]
# s_i = number of factors: 2,4,6,8 ; p_i = 7/2, 11/2, 15/2, 15/2
B = F(13,8); C42 = F(169,4)
hi = [(2,F(7,2)), (4,F(11,2)), (6,F(15,2)), (8,F(15,2))]
for tval in [F(13), F(10)**8]:
    print(f'-- t = {tval} --')
    for s_i, p in hi:
        h = s_i*tval/(tval*tval + C42) + F(1,2)/tval - p*B/(B*tval - 1)
        print(f'  s={s_i} p={p}: h = {float(h):.6e}  (>0: {h>0})')
    # convexity: h'' = sum_j 2t(t^2-3 a_j^2)/(t^2+a_j^2)^3 + 1/t^3 + 2 p B^2 (Bt-1)^-3
    # need t^2 >= 3*48.5625 = 145.6875 -> t >= ~12.07
    print('  t^2 - 3*48.5625 =', float(tval*tval - F(3)*(F(193,4))))

# ---- PART B endpoint Rbar_i(1e8) ----
nR = 162500000
nRm1 = nR-1
assert math.isqrt(nR)**2 <= nR and (math.isqrt(nR)+1)**2 > nR
iq = math.isqrt(nR)          # floor sqrt(162500000)
print('floor sqrt(162500000) =', iq, iq**2, nR - iq**2)
# nR^{1/2} UB = (iq+1)/1 ...  nR^{1/2} < iq+1 (iq^2 <= nR < (iq+1)^2)
# (nRm1)^{-15/2} UB = 1/((nRm1)^7 * sqrt(nRm1)) <= 1/((nRm1)^7 * iq2) where iq2 = floor sqrt(nRm1) <= sqrt(nRm1)
iq2 = math.isqrt(nRm1)
inv75 = F(1, nRm1**7 * iq2)      # (nRm1)^{-15/2} = 1/(nRm1^7 * sqrt(nRm1)) <= 1/(nRm1^7 * iq2)
# (nRm1)^{-11/2} = 1/(nRm1^5 * sqrt(nRm1)) <= ...
inv55 = F(1, nRm1**5 * iq2)
# (nRm1)^{-7/2} = 1/(nRm1^3 * sqrt(nRm1))
inv35 = F(1, nRm1**3 * iq2)
# sqrt(nR) UB
sqrtR = F(iq+1)   # nR^{1/2} < iq+1
Q10 = (F(10)**16 + C42)   # t^2 + 42.25 at t = 1e8
c2 = ub(Q10**2)   # (t^2+42.25)^1 at t=1e8 for S2: (t^2+42.25)^{2/2} = (t^2+42.25)^1 -- wait Qub for i factors: (t^2+42.25)^{i/2}: i=2 -> ^1, i=4 -> ^2, i=6 -> ^3, i=8 -> ^4
c2 = ub(Q10**2); c4 = ub(Q10**4); c6 = ub(Q10**6); c8 = ub(Q10**8)
for c,name in [(c2,'S2'),(c4,'S4'),(c6,'S6'),(c8,'S8')]:
    print(name, float(c))
R1 = c2*inv35/720 * 2*sqrtR*F(78,70)
R2 = c4*inv55/30240 * 2*sqrtR*F(78,70)
R3 = c6*inv75/1209600 * 2*sqrtR*F(78,70)
R4 = c8*inv75/9072000 * 2*sqrtR*F(78,70)
print('R1 =', float(R1)); print('R2 =', float(R2)); print('R3 =', float(R3)); print('R4 =', float(R4))
S = R1+R2+R3+R4
print('sum =', float(S), ' < 1:', S < 1, ' margin:', float(1-S), ' true ref 0.73746')
# and endpoint at 13:
t13 = F(13)
Q13 = t13*t13 + C42
d2 = ub(Q13**2); d4 = ub(Q13**4); d6 = ub(Q13**6); d8 = ub(Q13**8)
# n(13) = 21; n_lb = 13t/8-1 = 169/8-1 = 161/8
n13lb = F(161,8)
i13 = math.isqrt(1)  # sqrt(161/8) = sqrt(128.5) floor 11 -> (161/8)^{-15/2}: = (8/161)^7 * sqrt(8/161); UB: (8/161)^7 * sqrt_rat_ub(8,161*1)... sqrt(8/161) = sqrt(1288)/161 ; UB = (isqrt(1288)+1)/161
i1288 = math.isqrt(1288)   # sqrt(1288) = 35.89 -> 35
inv75_13 = F(8,161)**7 * F(i1288+1, 161)
inv55_13 = F(8,161)**5 * F(i1288+1, 161)
inv35_13 = F(8,161)**3 * F(i1288+1, 161)
# sqrt(n) for H at 13: H(13) = (1/2)*21^{-1/2}*T ; HL uses (13t/8)^{-1/2} at 13 = (169/8)^{-1/2} = sqrt(8/169) = 2/13 exact!
HL13 = F(1,2) * F(2,13) * T
r1 = d2*inv35_13/720 * 2*(F(169,8)**F(-1,2)) # placeholder
# exact: 2*(13t/8)^{1/2}*(78/70) at t=13: 2*sqrt(169/8)*(78/70) = 2*(13/sqrt8)*(78/70) = (169/sqrt2)*(78/70)/.. do via rationals:
# sqrt(169/8) = 13/sqrt(8) = 13*sqrt(8)/8 = 13*2*sqrt2/8 = 13*sqrt2/4 ; UB: 13*sqrt_rat_ub(2,1)/4
s2ub = F(math.isqrt(2)+1)  # sqrt(2) < 2
R1_13 = d2*inv35_13/720 * F(2) * F(13,1)*s2ub/F(4,1) * F(78,70)
R2_13 = d4*inv55_13/30240 * F(2) * F(13)*s2ub/4 * F(78,70)
R3_13 = d6*inv75_13/1209600 * F(2) * F(13)*s2ub/4 * F(78,70)
R4_13 = d8*inv75_13/9072000 * F(2) * F(13)*s2ub/4 * F(78,70)
S13 = R1_13+R2_13+R3_13+R4_13
print('sum Rbar(13) =', float(S13), ' HL(13) =', float(HL13), ' ratio ub =', float(S13/HL13))
# actually the B-part needs: for all t in [13,1e8]: T3UB(t)/HL(t) <= max per term of {R(13), R(1e8)} ; and we need sum < 1.
# Rbar_i(13) vs Rbar_i(1e8): the ratio to HL is already inside via the 2*(13t/8)^{1/2}(78/70) factor. Rbar_i(13) here uses HL(13)'s denominator form.
print('R_i(13) < R_i(1e8) for each i:', R1_13 < R1, R2_13 < R2, R3_13 < R3, R4_13 < R4)
