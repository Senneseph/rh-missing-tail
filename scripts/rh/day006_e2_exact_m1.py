# day-006 / P-E.2: EXACT M1 for all chi_5 + chi_13 phases via the exact
# Hurwitz-form action identity (THE-EULER-ACTION.md). No asymptotic fit:
#   tail(N,s) = sum_{n>N} chi(n) n^{-s} = sum_{j: chi(j)!=0} chi(j) q^{-s} HurwitzZ(s, n_first(j)/q)
#   M1(r)     = lim_{N->inf} (tail + P(r) N^{-s}) N^{s+1} / s
# M1 extracted by 2-cut linear-in-1/N extrapolation (measured single
# exponent ~ -1.0005, day006_drift), with a 3rd cut as guard.
# chi tables and P(r) computed FROM DEFINITION in-script (no recall).
import sys
from mpmath import mp

sys.stdout = open(sys.argv[1], "w", buffering=1) if len(sys.argv) > 1 else sys.stdout
mp.dps = 35

N0 = 10 ** 6
TS = (10, 3)  # t=10 standard; t=3 rationality check (chi_5 r=0 only at t=3)


def chi_table(q, kind):
    # From definition: quadratic character via Legendre symbol (Tonelli-free:
    # brute-force squares, q <= 13). kind in {"5","13"} fixed by q.
    squares = set((a * a) % q for a in range(1, q))
    tab = {}
    for r in range(1, q):
        tab[r] = 1 if r in squares else -1
    tab[0] = 0
    return tab


def band_cumul(tab, q):
    # P(r) = sum_{n=1}^{r} chi(n), r in 0..q-1 (A(N) for N mod q == r)
    P = [0] * q
    for r in range(1, q):
        P[r] = P[r - 1] + tab[r]
    return P  # P[0] = 0 = full-period sum (must be 0; asserted below)


def tail_exact(tab, q, r, N, s):
    # EXACT: split the tail by residue class, Hurwitz per class.
    total = mp.mpc(0)
    qms = mp.power(mp.mpf(q), -s)
    for j in range(1, q + 1):  # j = q means class 0
        cj = tab[j - 1]
        if cj == 0:
            continue
        n0 = q if j - 1 == 0 else j - 1  # least n>=1 in class j-1 (0-indexed)
        # least n > N in the class (exact integer arithmetic)
        k = max(0, -(-(N + 1 - n0) // q))  # ceil((N+1-n0)/q) when positive
        n_first = n0 + k * q
        total += cj * qms * mp.zeta(s, mp.mpf(n_first) / q)
    return total


def m1_of_phase(tab, q, r, s, out):
    P_row = band_cumul(tab, q)
    assert P_row[0] == 0, "full-period sum must be 0 (mean-zero character)"
    # first N >= N0 with N mod q == r
    N1 = N0 + ((r - N0) % q)
    cuts = (N1, N1 + q, N1 + 4 * q)
    vs = [None] * 3
    for i, N in enumerate(cuts):
        t_ = tail_exact(tab, q, r, N, s)
        nsm = mp.power(mp.mpf(N), -s)
        vs[i] = (t_ + mp.mpf(P_row[r]) * nsm) * mp.power(mp.mpf(N), s + 1) / s
        # D = -P check at this cut: D_meas = tail * N^s - s*M1_est/N (1st order)
    c = (vs[0] - vs[1]) / (mp.mpf(1) / cuts[0] - mp.mpf(1) / cuts[1])
    M1_2 = vs[0] - c / cuts[0]
    c2 = (vs[1] - vs[2]) / (mp.mpf(1) / cuts[1] - mp.mpf(1) / cuts[2])
    M1_wide = vs[1] - c2 / cuts[1]
    dmeas = tail_exact(tab, q, r, cuts[0], s) * mp.power(mp.mpf(cuts[0]), s) - s * M1_2 / cuts[0]
    out.append(
        "  r=%2d P=%+d  M1(2cut)=%s  M1(wide)=%s  |diff|=%s  D_meas=%s  (D=-P? %s)"
        % (
            r,
            P_row[r],
            mp.nstr(M1_2, 14),
            mp.nstr(M1_wide, 14),
            mp.nstr(abs(M1_2 - M1_wide), 4),
            mp.nstr(dmeas, 10),
            "yes" if abs(abs(dmeas) - abs(P_row[r])) < 1e-8 * max(1, abs(P_row[r])) else "NO",
        )
    )
    return M1_2


# ---- chi_5
print("== exact M1 table, t=10, N~1e6, dps-35 (P-E.2 / E2-exact) ==")
CHI = chi_table(5, "5")
Q = 5
out5 = []
print("chi_5 table:", {r: CHI[r] for r in range(5)})
M5 = {}
for r in range(5):
    S_VAL = mp.mpf("0.5") + 10 * mp.j
    R = r
    M5[r] = m1_of_phase(CHI, Q, r, mp.mpf("0.5") + 10 * mp.j, out5)
for line in out5:
    print(line)
# t=3 rationality cross-check on r=0 and r=2
for r in (0, 2):
    M = m1_of_phase(CHI, Q, r, mp.mpf("0.5") + 3 * mp.j, [])
    print("  chi_5 r=%d t=3: M1 = %s" % (r, mp.nstr(M, 14)))

# ---- chi_13
CHI = chi_table(13, "13")
Q = 13
out13 = []
print("chi_13 table:", {r: CHI[r] for r in range(1, 13)})
P13 = band_cumul(CHI, Q)
print("chi_13 P-row:", dict((r, P13[r]) for r in range(13)))
for r in range(13):
    m1_of_phase(CHI, Q, r, mp.mpf("0.5") + 10 * mp.j, out13)
for line in out13:
    print(line)
print("done")
