#!/usr/bin/env python3
"""day064 - NEAR-LINE CLOSURE PROBE (T4OffLH pre-check).

The 0260 audit found S4Strip.n4 = ceil(3.1e7 t^4) and
schedB = n4^(1/(2 sigma)) with sigma = 1/2 - d0, so at the decoupled
fill run Noff (= nIdeal^ceil):

    Noff >= schedB   <=>   nIdeal^(2 sigma) = t^4/(256 d0^4) >= n4
                          ~= 3.1e7 t^4
                        <=> d0 <= d0star = 31000000^(-1/4)/4
                             = 3.35035e-3     (t-EXACT crossover)

i.e. the S3 face (kernel(Noff) <= BwireR = p8_B t n4, via
t4l_wall_tuned which requires n >= schedB) HOLDS IN BODY on the
NEAR-LINE subband d0 <= d0star - the REVERSE of 0260's far-band
conclusion (0260 measured d0 >= 1/200, where Noff < schedB).

The decoupled squeeze cycle on that subband:
    own(t,d0) < wallLo(Noff) <= kernel(Noff) <= BwireR (+ MrR)
    AND (in body) own(t,d0) > BwireR + MrR
  requires  own > BwireR + MrR  at the pair, i.e. the S4Asm
  strip-region squeeze, which holds for d0 >= d0wire (the own-vs-wire
  crossover, ~4.74e-6).  So the in-body closure zone is
      d0wire < d0 < d0star
  and the day060/0258 floor + 0259 pin machinery (stated at
  d0 >= 1/200) must EXTEND to (0, 1/200) - the pin's strict step uses
  2^(1/2+d0) >= 2^(101/200); below 1/200 the bound 2^(1/2+d0) >= sqrt(2)
  (= 7/5, in exact rationals) carries it with margin.

This probe measures, on the near-line grid:
  (1) wallLo(Noff)/own            the S1-side margin (the pin, extended)
  (2) own/(BwireR + MrR)          the squeeze margin (the S4Asm leg)
  (3) Noff/schedB                 the schedule comparison (the S3 face)
  (4) the full cycle margin min(wallLo/own, own/(BwireR+MrR))
exact closed forms; X4fun from the in-tree B3Core model; Zbound = 1.6
t^(1/4) ln t.  No zeta, no zero data, no RH claim.
"""
import math

D0STAR = 31000000.0 ** (-0.25) / 4.0
print(f"d0star (Noff = schedB crossover, exact in t) = {D0STAR:.6e}")

def nideal_log(t, d0):
    sig = 0.5 - d0
    return (2.0*math.log(t) - math.log(16.0*d0*d0))/sig

def schedB_log(t, d0):
    sig = 0.5 - d0
    return math.log(31000000.0*t**4)/(2.0*sig)

def wallLo(t, d0, logN):
    sig = 0.5 - d0
    sL = (0.5 - d0) + 1j*t
    L1 = 0.5*16.0*d0*d0*math.exp(-2.0*math.log(t))
    T2 = (abs(sL)/12.0)*math.exp(-(sig+1.0)*logN)
    T3 = (math.sqrt(3.0)/216.0)*abs(sL*(sL+1)*(sL+2))*math.exp(-(sig+2.0)*logN)/(sig+2.0)
    return L1 - T2 - T3

def mown(t, d):
    A = (0.5+d)**2 + t*t
    B = (0.5-d)**2 + t*t
    C = (0.5+d)/A + (0.5-d)/B
    return d*d*(d*d + 4*t*t)/(A*B)*math.exp(C)

def p8B_lead(t):
    # 0.5 * n4^(-1/2), n4 = ceil(3.1e7 t^4) -> use 3.1e7 t^4 (upper bound
    # on n4^(-1/2))
    return 0.5*math.exp(-0.5*(math.log(31000000.0) + 4.0*math.log(t)))

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

def MrR(t):
    Z = 1.6*t**0.25*math.log(t)
    X = X4fun(t)
    return Z*math.exp(X)*X

print()
print(f"{'t':>9} {'d0':>10} {'wallLo/own':>12} {'own/(BW+MR)':>13} {'Noff/schedB':>13} {'cycle':>9}  S3face S1pin")
worst_cycle = (1e300, 0, 0, 0)
worst_pin = (1e300, 0, 0)
worst_own = (1e300, 0, 0)
n_close = 0
n_tot = 0
for t in [1e3, 1e6, 1e10, 1e16]:
    for d0 in [1e-6, 5e-6, 1e-5, 2e-5, 5e-5, 1e-4, 2e-4, 5e-4, 1e-3, 2e-3, 3e-3, 3.3e-3, 4e-3, 5e-3, 0.005]:
        n_tot += 1
        logN = nideal_log(t, d0)
        L = wallLo(t, d0, logN)
        own = mown(t, d0)
        U = p8B_lead(t) + MrR(t)
        ratio_n = math.exp(logN - schedB_log(t, d0))
        r_pin = L/own
        r_own = own/U
        s3 = ratio_n >= 1.0
        s1 = r_pin > 1.0
        cyc = min(r_pin, r_own) if s3 else 0.0
        if s3 and r_own < worst_own[0]: worst_own = (r_own, t, d0)
        if s3 and r_pin < worst_pin[0]: worst_pin = (r_pin, t, d0)
        if s3 and s1 and r_own > 1.0:
            n_close += 1
            if cyc < worst_cycle[0]: worst_cycle = (cyc, t, d0, r_own)
        print(f"{t:9.0e} {d0:10.2e} {r_pin:12.4f} {r_own:13.4f} {ratio_n:13.3f} {cyc:9.4f}  {'yes' if s3 else 'no ':6} {'ok' if s1 else 'FAIL'}")
    print()
print(f"closure points (S3face + pin>1 + own>wire): {n_close}/{n_tot}")
print(f"worst own/(BwireR+MrR) on closure zone = {worst_own[0]:.4f} at t={worst_own[1]:.0e}, d0={worst_own[2]:.2e}")
print(f"worst wallLo/own on closure zone      = {worst_pin[0]:.4f} at t={worst_pin[1]:.0e}, d0={worst_pin[2]:.2e}")
if worst_cycle[0] < 1e300:
    print(f"worst full-cycle margin               = {worst_cycle[0]:.4f} at t={worst_cycle[1]:.0e}, d0={worst_cycle[3]!r} d0={worst_cycle[2]:.2e}")
