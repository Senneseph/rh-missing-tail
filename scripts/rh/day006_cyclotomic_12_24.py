# day-006 / owner idea: the 24-adic front/back structure.
# Q: "the first 12 sweeps the FRONT quadrants, the next 12 the BACK;
# 3 units per quadrant in pi" — i.e. 24 = 2(front/back) x 12 = 2 x (4 quadrants x 3).
# Test (exact M1 machinery, E2-exact, dps-35, N~1e6, zero fits):
#   (A) tau_12 = primitive Dirichlet character mod 12 (arithmetic 12, real)
#   (B) F_24   = fibonacci mod-12 cell, MEAN-CENTERED (pole 9/2 removed —
#       the uncentered cell has mean 9/2 = the measured F24 pole term, so
#       the centering is what makes the band bounded and the mechanism exact)
# 12-cycle: r, r+3, r+6, r+9 = the four quadrant positions (90 deg apart);
# r+6 = antipode = front/back.  24-cell: r vs r+12 = the owner's two halves.
# Symmetry probes: antipode, mirror, quadrant tuples, zero-sum trace.
from mpmath import mp

mp.dps = 35
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


def cell_tau12(q):
    c = {}
    for j in range(1, q + 1):
        cj = (0 if (j % 2 == 0) or (j % 3 == 0)
              else (1 if (j % 4 == 1 and j % 3 == 1) or (j % 4 == 3 and j % 3 == 2)
              else -1))
        c[j] = cj
    return c


def m1_and_guard(cell, q, r):
    P = [0] * q
    for i in range(1, q):
        P[i] = P[i - 1] + cell[i]
    period_sum = sum(cell[j] for j in range(1, q + 1))
    assert period_sum == 0, f"cell must be mean-zero over the period (sum={period_sum})"
    n1 = N0 + ((r - N0) % q)
    cuts = (n1, n1 + q, n1 + 4 * q)
    qmss = mp.power(mp.mpf(q), -S)
    vs = []
    for N in cuts:
        total = mp.mpc(0)
        for j in range(1, q + 1):
            cj = cell[j]
            if cj == 0:
                continue
            x = N + 1 - j
            k = max(0, -(-x // q)) if x > 0 else 0
            nf = j + k * q
            total += cj * qmss * mp.zeta(S, mp.mpf(nf) / q)
        nsm = mp.power(mp.mpf(N), -S)
        vs.append((total + P[r] * nsm) * mp.power(mp.mpf(N), S + 1) / S)
    c1 = (vs[0] - vs[1]) / (mp.mpf(1) / cuts[0] - mp.mpf(1) / cuts[1])
    c2 = (vs[1] - vs[2]) / (mp.mpf(1) / cuts[1] - mp.mpf(1) / cuts[2])
    return (vs[0] - c1 / cuts[0]), (vs[1] - c2 / cuts[1]), P


def report(name, cell, q):
    print(f"== {name} (q={q}) ==")
    print("  cell:", " ".join(str(cell[j]) for j in range(1, q + 1)))
    Ms = []
    Ps = [0] * q
    for r in range(q):
        M, Mw, P = m1_and_guard(cell, q, r)
        Ms.append((M, Mw))
        Ps = P
    print("  P row:", " ".join(str(Ps[r]) for r in range(q)))
    ss = sum(M for M, _ in Ms)
    print("  SUM M1 (trace) = %s" % mp.nstr(ss, 10))
    ant = max(abs(Ms[r][0] - Ms[(r + q // 2) % q][0]) for r in range(q))
    mir = max(abs(Ms[r][0] - Ms[(-r) % q][0]) for r in range(q))
    print("  antipode (r vs r+%d, front/back) max|diff| = %s" % (q // 2, mp.nstr(ant, 6)))
    print("  mirror   (r vs -r)             max|diff| = %s" % mp.nstr(mir, 6))
    if q == 12:
        print("  quadrant 4-tuples (step 3 = 90 deg):")
        for base in (0, 1, 2):
            print("    ", " | ".join(
                "[%d]=%s" % ((base + 3 * k) % 12, mp.nstr(Ms[(base + 3 * k) % 12][0], 9))
                for k in range(4)))
    for r in range(0, q, q // 4 if q >= 8 else 1):
        opp = (r + q // 2) % q
        print("  r=%2d M1=%s   <-->  r=%2d M1=%s"
              % (r, mp.nstr(Ms[r][0], 11), opp, mp.nstr(Ms[opp][0], 11)))
    return Ms


fib24 = fib_period_24()
print("F mod 12 period (24):", fib24, " sum =", sum(fib24))
h1, h2 = fib24[:12], fib24[12:]
print("  front half :", h1, " sum", sum(h1))
print("  back  half :", h2, " sum", sum(h2))
print("  back - front (mod 12):", [(b - a) % 12 for a, b in zip(h1, h2)])
print("  -front       (mod 12):", [(-a) % 12 for a in h1])
print()
report("tau_12 (Dirichlet primitive mod 12)", cell_tau12(12), 12)
print()
CELLF = {j: (fib24[j - 1] - mp.mpf("9/2")) for j in range(1, 25)}
report("F_24 centered (fib mod 12 - 9/2; the 24-adic cell)", CELLF, 24)
print("done")
