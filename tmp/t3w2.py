from fractions import Fraction as F
import math

def Sprod(t, kmax):  # exact prod_{k=0..kmax}(t^2+(k+1/2)^2)
    P = F(1)
    for k in range(kmax+1):
        P *= (t*t + F(2*k+1,2)**2)
    return P

def ub(P):   # strict rational upper bound of sqrt(P)
    return F(math.isqrt(P.numerator*P.denominator)+1, P.denominator)
def lb(P):   # rational lower bound of sqrt(P)
    return F(math.isqrt(P.numerator*P.denominator), P.denominator)

T = F(70,78)
print('== PART A1: [1,16/13), n=1 ==')
tA = F(16,13); tot = F(0)
for kmax,d in [(2,720),(4,30240),(6,1209600),(8,9072000)]:
    q = ub(Sprod(tA,kmax)); tot += q/d
print('ub =', tot, float(tot), '< 35/78 =', float(F(35,78)), tot < F(35,78))

print('== PART A2: [16/13,23], n>=2, |S| at 23 ==')
tB = F(23)
two = {F(7,2): F(99,1120), F(11,2): F(99,4480), F(15,2): F(99,17920)}  # 2^{-p} UBs
for p,q2 in two.items():
    assert q2*q2 > (F(1,2))**(2*p) if (2*p).numerator%2==0 else True
# verify 2^{-3.5} < 99/1120:  (99/1120)^2 > 2^{-7}  <=>  99^2*2^7 > 1120^2
print('2^-3.5 < 99/1120:', F(99,1120)**2 > F(1,2)**7)
print('2^-5.5 < 99/4480:', F(99,4480)**2 > F(1,2)**11)
print('2^-7.5 < 99/17920:', F(99,17920)**2 > F(1,2)**15)
tot = F(0)
for kmax,p,d in [(2,F(7,2),720),(4,F(11,2),30240),(6,F(15,2),1209600),(8,F(15,2),9072000)]:
    q = ub(Sprod(tB,kmax)); tot += q*two[p]/d
print('ub =', float(tot))
H = F(1,2)*lb(F(1,37))*T   # H(t) >= (1/2)sqrt(1/37)*T on [16/13,23]
print('H_lb =', float(H), 'ok =', tot < H, 'margin =', float(H-tot))

print('== PART C1: [23,100], uniform UBs ==')
tC = F(100)
nmin3 = F(35,8)                     # 13*23/8 - 1 = 299/8 - 1 = 291/8? NO: at t=23: 13*23/8 = 299/8, -1 = 291/8
nmin3 = F(291,8)
print('n_lb(23) =', nmin3)
# (291/8)^{-7/2} = (8/291)^3 * sqrt(8/291) <= (8/291)^3 * ub(8/291)
qm3 = ub(F(8,291))
val5 = qm3; val7 = qm3
q7 = F(8,291)**3 * qm3   # (291/8)^{-7/2} UB
q5 = F(8,291)**5 * qm3
q35 = F(8,291)**3 * qm3
q3 = F(8,291)**3        # (291/8)^{-3} exact (for completeness)
tot = F(0)
for kmax,pnum,qx,d in [(2,7,q35,720),(4,11,q5,30240),(6,15,q7,1209600),(8,15,q7,9072000)]:
    # (t^2+42.25)^{kmax/2} at t=100:
    base = F(100)**2 + F(169,4)
    q = ub(base**kmax)
    v = q*qx/d; tot += v
    print(kmax, float(q), float(qx), float(v))
Hc = F(1,2)*F(1,204)**F(-1,2)*T if False else None
# HL on [23,100]: H(t) >= (1/2)*(13*100/8)^{-1/2}*T = (1/2)*sqrt(8/1300)*T ; LB:
Hc1 = F(1,2)*lb(F(8,1300))*T
print('C1 T3UB_ub =', float(tot), ' HL(t) >= ', float(Hc1), ' ok =', tot < Hc1, ' margin=', float(Hc1-tot))

print('== PART C2: endpoint values at 1e8 and 100 ==')
B = F(13,8); C0 = F(1)
nR = 162500000
nRm1 = nR - 1
# (162499999)^{-7.5} UB = 1/(162499999^3 * 12747)
assert 12747**2 <= 162499999 < 12748**2
assert 12747**2 <= 162500000 < 12748**2
inv75 = F(1, nRm1**3 * 12747)     # UB for nRm1^{-7.5}
inv55 = F(5, 16) * inv75          # UB for nRm1^{-5.5} = nRm1^{-7.5} * nRm1^2 <= inv75 * (5/16)?? NO
# careful: nRm1^{-5.5} vs nRm1^{-7.5}: nRm1^{-5.5} = nRm1^{-7.5}*nRm1^2 -- not bounded by (5/16)*inv75.
# (nRm1)^{-5.5} = 1/(nRm1^2 * sqrt(nRm1)^5) <= 1/(nRm1^2 * 12747^5)
inv55 = F(1, nRm1**2 * 12747**5)
inv35 = F(1, nRm1 * 12747**3)
sqrtR = F(12748,1)                 # UB for sqrt(162500000)
def Qub(i, t2):   # (t^2+42.25)^{i/2} UB at t^2 = 10^16
    base = F(10)**16 + F(169,4)
    q = ub(base**i)
    return q
c4 = Qub(8,0); c6 = Qub(6,0); c4_ = Qub(4,0); c2 = Qub(2,0)
r4 = c4*inv75/9072000 * (2*sqrtR*T/F(78,70)/1)  # placeholder
# Rbar_i(1e8) = Qub_i * nRm1^{-pi} / d_i * 2*sqrt(nR) * (78/70)
def Rbar(i, qu, inv, d):
    return qu*inv/d * (2*sqrtR) * (78,70)
R1 = c2*inv35/720 * 2*sqrtR*F(78,70)
R2 = c4_*inv55/30240 * 2*sqrtR*F(78,70)
R3 = c6*inv35 if False else c6*(1/inv35 if False else 1)  # placeholder fix below
# T3 uses nRm1^{-7/2} as well:
R3 = c6*inv75/1209600 * 2*sqrtR*F(78,70)
R4 = c4*inv75/9072000 * 2*sqrtR*F(78,70)
print('R1(1e8)=', float(R1), ' R2(1e8)=', float(R2), ' R3(1e8)=', float(R3), ' R4(1e8)=', float(R4))
S = R1+R2+R3+R4
print('sum Rbar(1e8) =', float(S), ' < 1 ?', S < 1, ' margin =', float(1-S))
print('true reference: 0.73746 ; this ub should sit just above it')
