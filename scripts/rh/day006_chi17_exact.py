# day-006 / P-W.1-next: EXACT M1 table for chi_17 (P-W next modulus /
# rationality + mirror + zero-sum falsifier). Same exact machinery as
# day006_e2_exact_m1.py (E2-exact, THE-EULER-ACTION.md): no asymptotic fit
# beyond the 1/N linear limit, 3rd cut as guard, D=-P measured per phase.
# chi_17 = Legendre symbol (17 = 1 mod 4 -> REAL primitive character).
# chi table computed FROM DEFINITION (brute-force squares), no recall.
from mpmath import mp

mp.dps = 35
N0 = 10 ** 6
Q = 17


def chi17():
    squares = set((a * a) % Q for a in range(1, Q))
    tab = {}
    for r in range(1, Q):
        tab[r] = 1 if r in squares else -1
    tab[0] = 0
    return tab


def band_cumul(tab):
    P = [0] * Q
    for r in range(1, Q):
        P[r] = P[r - 1] + tab[r]
    return P


def tail_exact(tab, r, N, s):
    total = mp.mpc(0)
    qms = mp.power(mp.mpf(Q), -s)
    for j in range(1, Q + 1):  # j = Q means class 0
        cj = tab[j - 1]
        if cj == 0:
            continue
        n0 = Q if j - 1 == 0 else j - 1
        k = max(0, -(-(N + 1 - n0) // Q))  # ceil((N+1-n0)/Q) when positive
        n_first = n0 + k * Q
        total += cj * qms * mp.zeta(s, mp.mpf(n_first) / Q)
    return total


def m1_of_phase(tab, P, r, s, out):
    N1 = N0 + ((r - N0) % Q)
    cuts = (N1, N1 + Q, N1 + 4 * Q)
    vs = [None] * 3
    for i, N in enumerate(cuts):
        t_ = tail_exact(tab, r, N, s)
        nsm = mp.power(mp.mpf(N), -s)
        vs[i] = (t_ + mp.mpf(P[r]) * nsm) * mp.power(mp.mpf(N), s + 1) / s
    c = (vs[0] - vs[1]) / (mp.mpf(1) / cuts[0] - mp.mpf(1) / cuts[1])
    M1_2 = vs[0] - c / cuts[0]
    c2 = (vs[1] - vs[2]) / (mp.mpf(1) / cuts[1] - mp.mpf(1) / cuts[2])
    M1_wide = vs[1] - c2 / cuts[1]
    dmeas = tail_exact(tab, r, cuts[0], s) * mp.power(mp.mpf(cuts[0]), s) - s * M1_2 / cuts[0]
    out.append(
        "  r=%2d P=%+d  M1=%s  M1(wide)=%s  |diff|=%s  D_meas=%s  (D=-P? %s)"
        % (
            r,
            P[r],
            mp.nstr(M1_2, 14),
            mp.nstr(M1_wide, 14),
            mp.nstr(abs(M1_2 - M1_wide), 4),
            mp.nstr(dmeas, 10),
            "yes" if abs(abs(dmeas) - abs(P[r])) < 1e-8 * max(1, abs(P[r])) else "NO",
        )
    )
    return M1_2


CHI = chi17()
P = band_cumul(CHI)
assert P[0] == 0
print("== chi_17 exact M1 table, t=10, N~1e6, dps-35 ==")
print("chi_17 values (1..16):", [CHI[r] for r in range(1, Q)])
print("P row:", [P[r] for r in range(Q)])
S_VAL = mp.mpf("0.5") + 10 * mp.j
M = {}
out = []
for r in range(Q):
    M[r] = m1_of_phase(CHI, P, r, S_VAL, out)
for line in out:
    print(line)

# symmetry probes (the P-W laws at the next modulus)
mir = max(abs(M[r] - M[(-r) % Q]) for r in range(Q))
tr = sum(M[r] for r in range(Q))
integ = max(abs(mp.re(M[r]) - mp.mpf(round(float(mp.re(M[r]))))) for r in range(Q))
print("  mirror  max|M(r) - M(-r mod q)| = %s" % mp.nstr(mir, 6))
print("  trace   sum_r M(r)              = %s" % mp.nstr(tr, 10))
print("  integer max|M(r) - round|       = %s" % mp.nstr(integ, 6))
print("  P=0 phases:", [r for r in range(Q) if P[r] == 0])

# t-independence check (two phases at t=3)
for r in (0, 7):
    M3 = m1_of_phase(CHI, P, r, mp.mpf("0.5") + 3 * mp.j, [])
    print("  chi_17 r=%d t=3: M1 = %s   (t=10: %s)" % (r, mp.nstr(M3, 12), mp.nstr(M[r], 12)))
print("done")
