# day-006 F_24 rework: well-conditioned M1 for the 24-adic front/back cell.
# The 2-cut finite-difference extrapolation amplified conditioning noise on
# this (non-multiplicative, half-integer-centered) cell. Here:
#   - evaluate the EXACT residue-class Hurwitz tail at MANY cuts N + m*q
#   - form  vs = (total + P[r] * N^-S) * N^(S+1) / S
#   - least-squares linear fit  vs ~ M1 + c1/N  over the cuts, intercept = M1
#   - report the spread (max|vs_fit - vs|) as a conditioning guard
# Then probe the owner's structure directly on the M1 vector:
#   antipode r vs r+12 (front/back),  mirror r vs -r,  zero-sum trace.
# Also print the EXACT raw-residue front/back structure (no extrapolation).
from mpmath import mp

mp.dps = 40
N0 = 10 ** 6
S = mp.mpf("0.5") + 10 * mp.j


def fib_period_24():
    a, b = 1, 1
    out = []
    i = 0
    while True:
        out.append(a % 12)
        a, b = b, (a + b) % 12
        i += 1
        if i >= 2 and a % 12 == 1 and b % 12 == 1:
            break
    return out


def tail_at(N, cell, q, r):
    P = [0] * q
    for i in range(1, q):
        P[i] = P[i - 1] + cell[i]
    # periodic partial-sum phase at N (N ≡ r mod q by construction)
    n1 = N + ((r - N) % q)
    qmss = mp.power(mp.mpf(q), -S)
    total = mp.mpc(0)
    for j in range(1, q + 1):
        cj = cell[j]
        if cj == 0:
            continue
        x = n1 + 1 - j
        k = (-x + q - 1) // q if x > 0 else 0
        # smallest nf ≡ j (mod q) with nf > n1
        nf = j + ((n1 + 1 - j + q - 1) // q) * q
        total += cj * qmss * mp.zeta(S, mp.mpf(nf) / q)
    nsm = mp.power(mp.mpf(n1), -S)
    vs = (total + P[r] * nsm) * mp.power(mp.mpf(n1), S + 1) / S
    return vs, P


def m1_robust(cell, q, r, ncuts=6):
    P = [0] * q
    for i in range(1, q):
        P[i] = P[i - 1] + cell[i]
    base = N0 + ((r - N0) % q)
    xs, ys = [], []
    for m in range(ncuts):
        N = base + m * q
        vs, _ = tail_at(N, cell, q, r)
        xs.append(mp.mpf(1) / N)
        ys.append(vs)
    # least-squares for  ys = M1 + c1 * x   (two unknowns, ncuts points)
    n = len(xs)
    sxx = sum(xs[i] ** 2 for i in range(n))
    sxy = sum(xs[i] * ys[i] for i in range(n))
    sy = sum(ys[i] for i in range(n))
    sx = sum(xs[i] for i in range(n))
    denom = n * sxx - sx * sx
    c1 = (n * sxy - sx * sy) / denom
    M1 = (sy - c1 * sx) / n
    resid = max(abs(ys[i] - (M1 + c1 * xs[i])) for i in range(n))
    return M1, c1, resid


fib24 = fib_period_24()
CELLF = {j: (fib24[j - 1] - mp.mpf("9/2")) for j in range(1, 25)}
q = 24
print("F_24 centered M1 (dps-40, 6-cut least-squares, guard = max residual)")
Ms, Res = [], []
for r in range(q):
    M1, c1, resid = m1_robust(CELLF, q, r)
    Ms.append(M1)
    Res.append(resid)
    print("  r=%2d  M1 = %s   (guard %s)" % (r, mp.nstr(M1, 12), mp.nstr(resid, 6)))
worst = max(Res)
ss = sum(Ms)
ant = max(abs(Ms[r] - Ms[(r + q // 2) % q]) for r in range(q))
mir = max(abs(Ms[r] - Ms[(-r) % q]) for r in range(q))
print("  WORST guard = %s" % mp.nstr(worst, 8))
print("  SUM M1 (trace) = %s" % mp.nstr(ss, 12))
print("  antipode (r vs r+12, front/back) max|diff| = %s" % mp.nstr(ant, 8))
print("  mirror   (r vs -r)               max|diff| = %s" % mp.nstr(mir, 8))
print()
print("  CONVERGED?" , "YES (guard small)" if abs(worst) < mp.mpf("1e-6") else
      "NO (guard large -> extrapolation ill-conditioned for this cell; NOT a result)")
print()
# --- exact raw-residue front/back structure (no extrapolation) ---
h1, h2 = fib24[:12], fib24[12:]
bf = [(b - a) % 12 for a, b in zip(h1, h2)]
mod4_all_zero = all(d % 4 == 0 for d in bf)
print("RAW (exact): front =", h1, " sum", sum(h1))
print("RAW (exact): back  =", h2, " sum", sum(h2))
print("RAW (exact): back-front (mod 12) =", bf)
print("  back-front all divisible by 4 (halves agree mod 4)?", mod4_all_zero)
print("  back-front / 4 =", [d // 4 for d in bf])
print("  is back-front period-4 (quadrant-symmetric)?",
      all(bf[i] == bf[i % 4] for i in range(12)))
print("  -front (mod 12) =", [(-a) % 12 for a in h1])
print("  back == -front (mod 12)?", all((h2[i] + h1[i]) % 12 == 0 for i in range(12)))
print("done")
