#!/usr/bin/env python3
"""25ae v3: longdouble re-measurement of |T3| where float64 phase error is
comparable to the signal (t = 1e7..1e8). Same zeta route as v2
(W_n = zeta - P_n + n^{1-s}/(1-s); T3 = W_n - T1 - T2), P_n in 80-bit
longdouble with pairwise blocks. Error budget per term ~ t*ulp(ln k) (correlated
locally, random-walk aggregate ~ sqrt(n)*t*1e-19*lnk*n^{-1/2} << signal)."""
from math import floor
import numpy as np
import mpmath as mp

OUT = open('/home/jsmille/Projects/rh-missing-tail/scripts/rh/out_day026_25ae_v3_longdouble.txt', 'w')
def p(*a):
    s = ' '.join(str(x) for x in a)
    print(s, flush=True); OUT.write(s + '\n')

def t3_ld(t, n):
    t = float(t); n = int(n)
    s = np.clongdouble(0.5 + 1j*t)
    mp.mp.dps = 50
    zz = mp.zeta(mp.mpf('0.5') + 1j*mp.mpf(repr(t)))
    mp.mp.dps = 30
    Pn = np.clongdouble(0j)
    chunk = 4_000_000
    for a in range(1, n+1, chunk):
        b = min(a + chunk, n + 1)
        ks = np.arange(a, b, dtype=np.longdouble)
        ex = np.power(ks, -s)
        Pn += np.sum(ex, dtype=np.clongdouble)
    I = np.clongdouble(n) ** (-s + 1) / (np.clongdouble(1) - s)
    em = zz - Pn + I
    T1 = -np.clongdouble(0.5) * np.clongdouble(n) ** (-s)
    T2 = (np.clongdouble(1)/12) * s * np.clongdouble(n) ** (-s - 1)
    T3 = em - T1 - T2
    return complex(T3), complex(em), complex(T1)

p('=== 25ae v3: longdouble |T3| at t = 1e7..1e8 (list scale n = floor(13t/8)) ===')
for t in [10000019.9176922975762040992966001,
          15000000.1483617306509352119486298,
          25000003.3675177107930498459838743,
          50000000.798368300768164067013827,
          100000000.4516353600206784375890589]:
    n = int(floor(13*t/8))
    T3, em, T1 = t3_ld(t, n)
    aT3, aT1 = abs(T3), abs(T1)
    ts = complex(0.5 + 1j*t)
    A = abs(ts*(ts+1)*(ts+2))
    FA = aT3/(A*n**(-3.5))
    p(f't={t:<24.6f} n={n:<10} |T3|={aT3:.6e}  |T3|/|T1|={aT3/aT1:.4e}  FA(n^-7/2 form)={FA:.4e}   |EM|/|T1|={abs(em)/aT1:.8f}')

OUT.close()
print('DONE -> out_day026_25ae_v3_longdouble.txt')
