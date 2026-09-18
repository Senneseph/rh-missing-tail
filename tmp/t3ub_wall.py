import math
from math import floor
# list scale: n = floor(13 t / 8), s = 1/2 + i t
# 4-term T3 bound (LEAN 3B.8 gives |INT| <= n^{-15/2}/225):
# |T3| <= |S2| n^{-7/2}/720 + |S4| n^{-9/2}/30240 + |S6| n^{-15/2}/1209600
#        + |S6| |s+7| n^{-15/2}/9072000
# with S2 = s(s+1)(s+2), S4 = S2 (s+3)(s+4), S6 = S4 (s+5)(s+6)
def ratio(t, exp4):
    n = floor(13*t/8)
    aS2 = math.sqrt(0.25+t*t)*math.sqrt(2.25+t*t)*math.sqrt(6.25+t*t)
    aS4 = aS2*math.sqrt(12.25+t*t)*math.sqrt(20.25+t*t)
    aS6 = aS4*math.sqrt(30.25+t*t)*math.sqrt(42.25+t*t)
    n72 = n**-3.5; n92 = n**-4.5; n152 = n**-7.5
    n4 = n**(-exp4)
    T3UB = aS2*n72/720 + aS4*n92/30240 + aS6*n152/1209600 + aS6*math.sqrt(56.25+t*t)*n4/9072000
    T1 = 0.5*n**-0.5
    return T3UB/T1
target = 1 - (1/6)*(8/13)
for exp4, label in [(7.5, 'CORRECT n^-15/2 (LEAN I8)'), (15.5, 'script n^-31/2')]:
    lo, hi = 1e3, 5e8
    # find crossing (ratio increasing ~linear)
    rlo, rhi = ratio(lo, exp4), ratio(hi, exp4)
    print(f'--- {label}: ratio(1e3)={rlo:.6e} ratio(5e8)={rhi:.6e}  target={target:.6f}')
    if rlo > target:
        print('  crossed below 1e3')
        continue
    if rhi < target:
        print('  no crossing up to 5e8')
        continue
    a, b = lo, hi
    for _ in range(200):
        m = (a+b)/2
        if ratio(m, exp4) < target: a = m
        else: b = m
    print(f'  crossover t = {b:.4e}')
