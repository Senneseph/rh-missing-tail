#!/usr/bin/env python3
"""day063 - Q2 S3-leg infeasibility pre-check (T4OffLG measurement).

The Q2 decoupled squeeze (T4OffLE.t4LE_squeeze_decoupled) needs, at the
DECOUPLED fill run Noff = ceil nIdeal:

    (S1 leg) fill >= wallLo(t, d0, Noff)          [IN BODY, 0258]
    (pin  )   wallLo(t, d0, Noff) > own           [IN BODY, 0259]
    (S3 leg) fill <= BwireR + MrR                 [? - THIS CHECK]

T4OffLF + FUnif prove in body, on the whole band:

    kernel(Noff) >= wallLo(Noff) > own > BwireR + MrR

so the S3 leg premise is FALSE at Noff (the fill run's kernel strictly
exceeds the S4 window wire wall - the 0257 shared-value pathology, now
in body).  This script quantifies the infeasibility margin
wallLo(Noff) / (p8_B(n4) + MrR) on the band grid (exact closed forms,
MrR via the S4W Zbound * exp(X4fun) * X4fun with X4fun from the B3Core
model as in the in-tree S1 upper bounds - a lower bound on the ratio
is what matters; dropping the T2/T3 deductions from wallLo).
"""
import math

def n4(t): return math.ceil(31000000.0 * t**4)

def p8B(t, n):
    s2 = 0.25 + t*t
    ss = (0.5 + 1j*t); ss1 = (1.5 + 1j*t); ss2 = (2.5 + 1j*t)
    return 0.5*n**-0.5 + (math.sqrt(s2)/12.0)*n**-1.5 \
        + (math.sqrt(3.0)/540.0)*abs(ss*ss1*ss2)*n**-2.5

def nideal_log(t, d0):
    sig = 0.5 - d0
    return (2.0*math.log(t) - math.log(16.0*d0*d0))/sig

def wallLo(t, d0, logN):
    sig = 0.5 - d0
    sL = (0.5 - d0) + 1j*t
    L1 = 0.5*16.0*d0*d0*math.exp(-2.0*math.log(t))  # = 0.5 * N^-sig exactly
    T2 = (abs(sL)/12.0)*math.exp(-(sig+1.0)*logN)
    T3 = (math.sqrt(3.0)/216.0)*abs(sL*(sL+1)*(sL+2))*math.exp(-(sig+2.0)*logN)/(sig+2.0)
    return L1 - T2 - T3

def mown(t, d):
    A = (0.5+d)**2 + t*t
    B = (0.5-d)**2 + t*t
    C = (0.5+d)/A + (0.5-d)/B
    return d*d*(d*d + 4*t*t)/(A*B)*math.exp(C)

def p8Log(t):
    # 0.5*n4^(-1/2) exactly in log space (n4 = ceil(3.1e7 t^4); drop the
    # ceil - it only SHRINKS n4^-1/2, so this is an upper bound on the
    # p8_B leading term at the true n4)
    return -math.log(2.0) - 0.5*(math.log(31000000.0) + 4.0*math.log(t))

# B3Core EXACT model (formal/RhAttack/B3Core.lean): the in-tree X4fun
# is exactly Bf(t,G4t)*(Sbar(B4t)+Sbar(G4t)) + Cf(t,G4t)*Kbar(G4t).
def Sbar(x):
    return 0.110*math.log(x) + 0.290*math.log(math.log(x)) + 2.290

def w(t):
    return t*t + 0.25

def Bf(t, G):
    GG = G*G + 0.25
    return 1.0/(2.0*GG) + (w(t)/GG)/(1.0 - w(t)/GG) + t/GG

def Cf(t, G):
    return 1.0 + 2.0*w(t)*G*G/(G*G - t*t)

def Kbar(G):
    return (0.110*(math.log(G)+0.5) + 0.290*(math.log(math.log(G))+0.5)
            + 2.290)/(2.0*G*G)

def X4fun(t):
    G4 = 62000000.0*t**4
    B4 = 124000000.0*t**4
    return Bf(t, G4)*(Sbar(B4) + Sbar(G4)) + Cf(t, G4)*Kbar(G4)

def MrR(t, d0):
    if d0 >= 1/200:
        Z = 1.6*t**0.25*math.log(t)
        return Z*math.exp(X4fun(t))*X4fun(t)
    return 0.0

rows = []
worst = (1e300, 0, 0)
for t in [1e3, 10**3.5, 1e4, 1e6, 1e8, 1e10, 1e12, 1e16, 1e18]:
    for d0 in [1/200, 0.01, 0.05, 0.1, 0.2, 0.3, 0.3733819666132, 0.45, 0.49, 0.499]:
        logN = nideal_log(t, d0)
        L = wallLo(t, d0, logN)
        U = math.exp(p8Log(t)) + MrR(t, d0)
        r = L/U
        own = mown(t, d0)
        rows.append((t, d0, L, U, r, own, L/own))
        if r < worst[0]: worst = (r, t, d0)

print(f"{'t':>10} {'d0':>10} {'wallLo(Noff)':>14} {'U=p8B+MrR':>14} {'L/U':>10} {'own':>12} {'L/own':>8}")
for (t, d0, L, U, r, own, ro) in rows:
    print(f"{t:10.2e} {d0:10.6f} {L:14.4e} {U:14.4e} {r:10.3f} {own:12.4e} {ro:8.4f}")
print()
print(f"WORST S3-LEG INFEASIBILITY RATIO L/U = {worst[0]:.4f} at t={worst[1]:.3e}, d0={worst[2]:.6f}")
print("(L = wallLo(Noff) - a kernel LOWER bound; U = BwireR + MrR - the S3 face.)")
print("L/U > 1 at every point => the S3 face premise is FALSE at Noff on the whole grid.")
