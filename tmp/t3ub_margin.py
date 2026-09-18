from math import floor, sqrt
# exact Lean-side evaluation with floor included
def ratio_floor(t):
    n = floor(13*t/8)
    if n < 1: return float('inf')
    aS2 = sqrt(0.25+t*t)*sqrt(2.25+t*t)*sqrt(6.25+t*t)
    aS4 = aS2*sqrt(12.25+t*t)*sqrt(20.25+t*t)
    aS6 = aS4*sqrt(30.25+t*t)*sqrt(42.25+t*t)
    T3UB = aS2*n**-3.5/720 + aS4*n**-4.5/30240 + aS6*n**-7.5/1209600 \
            + aS6*sqrt(56.25+t*t)*n**-7.5/9072000
    T1 = 0.5*n**-0.5
    return T3UB/T1
target = 1 - (1/6)*(8/13)
for t in [90000.0, 92000.0, 94000.0, 94474.0, 94475.0]:
    r = ratio_floor(t)
    print(f't={t:<12.1f} ratio={r:.9f}  1-ratio={1-(1/6)*(8/13)-r:.6e}  wall_positive={1-(1/6)*(8/13)-r>0}')
