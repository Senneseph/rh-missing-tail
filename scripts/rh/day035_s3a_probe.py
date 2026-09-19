# day034-night probe (END_GAME_PLAN 3.3 step 1):
# exact/numeric study of the algebraic core of R_closed on the
# quantized straddles t = g + k/2 (k = 1..24, sign symmetric),
# d in [0.005, 0.5].  R_alg = the rational part (no exp).
from fractions import Fraction as F
import math

def R_alg(g, k, d):
    # t = g + k/2  (k > 0); all terms exact
    g = F(g); k = F(k); d = F(d)
    num = (F(1,4)*g**2 + g**2 - g**2)  # placeholder
    num = (g**2 + F(1,4)) * ((g - (g + F(k,2)))**2 + d**2) \
        * ((g + (g + F(k,2)))**2 + d**2)
    den = abs(g**2 - (g + F(k,2))**2) \
        * ((F(1,2) + d)**2 + g**2) * ((F(1,2) - d)**2 + g**2)
    return num / den

def R_alg_f(gf, k, df):
    g = F(gf).limit_denominator(10**9)
    d = F(df).limit_denominator(10**9)
    return float(R_alg(g, k, d))

# 1) worst d for fixed g, k: fine grid
def worst_d(gf, k):
    best = (0.0, 0.0)
    for i in range(1, 20001):
        d = 0.5 * i / 20000.0
        v = R_alg_f(gf, k, d)
        if v > best[0]:
            best = (v, d)
    return best

print("== sup over d in [0, 0.5] of R_alg, per k (g fixed) ==")
for g in (30, 50, 100, 1000, 1e6):
    row = []
    for k in (1, 2, 4, 8, 12):
        v, d = worst_d(g, k)
        row.append("k=%2d: %.6f @d=%.3f" % (k, v, d))
    print("g=%8.0f | %s" % (g, " | ".join(row)))

print()
print("== worst (k,d) per g; margin 1 - sup ==")
for g in (15, 20, 25, 30, 40, 50, 100, 1000, 1e6, 1e9):
    wv, wk, wd = 0, None, None
    for k in range(1, 13):
        v, d = worst_d(g, k)
        if v > wv:
            wv, wk, wd = v, k, d
    print("g=%8.0f  sup=%.7f  (k=%2d, d=%.3f)   1-sup=%.7f" %
          (g, wv, wk, wd, 1 - wv))

print()
print("== exact rational at the corner d = 1/2 (worst expected) ==")
for k in (1, 2, 4, 8, 12):
    vals = []
    for g in (20, 25, 30, 40, 50):
        v = R_alg(g, k, F(1, 2))
        vals.append("%s" % ("%.6f" % float(v)))
    print("k=%2d  g=20..50 @d=1/2: %s" % (k, " ".join(vals)))
