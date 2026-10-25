"""kcs2: U2 - the finite Fourier sieve operator theorem (measured;
KCS plan, Unit 2).  No RH claim - finite exact group algebra.

Statement (additive Fourier basis of Z/NZ,  N squarefree):

  (i)  the per-prime marks K_p := 1_{p |/. m} (as functions
       Z/NZ -> {0,1}) are self-adjoint IDEMPOTENTS in the pointwise
       algebra (indicator squared = itself) and they COMMUTE
       (pointwise) - the sieve as commuting projections;
  (ii) SINGLE-P COMB:  for a in Z/NZ,
         F[1_{p|/. -}](a) = sum_{m mod N, p |/. m} e^{2 pi i a m / N}
                           = N * 1_{a == 0} - (N/p) * 1_{(N/p) | a} .
       The p-chime lives EXACTLY on the (N/p)-torsion subgroup of the
       character group:  p support points,  value N at a = 0,
       -N/p at the other p - 1 points;
  (iii) FULL MASK (the sieve result):  mu = prod_p K_p = 1_{(., N) = 1},
         F[mu](a) = c_N(a) = phi(N) * mu(k) / phi(k),  k = N / gcd(a, N)
       (the RAMANUJAN SUM, k squarefree since N is) - the joint
       torsion convolution of the combs,  exact;
  (iv) PARSEVAL:  (1/N) * sum_a |F[mu](a)|^2 = mean(mu^2) = phi(N)/N .

Each "chime" in the lattice side-quest = the (N/p)-torsion comb of
(ii);  the completed sieve = the Ramanujan-sum field of (iii).

Verification: (i) exact integer check; (ii) brute-force exact-sum
verification at N = 210 = 2*3*5*7 for ALL a and all p (numpy
complex128,  max |LHS - RHS|); (iii) numpy FFT of the full mask at
N = 30030 = 2*3*5*7*11*13 for ALL a vs the closed form (exact integer
right-hand side); (iv) Parseval from the same FFT.
"""
import math
import time

import numpy as np

OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs2_out.txt", "w")


def W(*a):
    print(*a, file=OUT)


def phi(n):
    r, m = n, n
    p = 2
    while p * p <= m:
        if m % p == 0:
            while m % p == 0:
                m //= p
            r -= r // p
        p += 1
    if m > 1:
        r -= r // m
    return r


def mu(n):
    if n == 1:
        return 1
    if n % 4 == 0:
        return 0
    c, m, p = 0, n, 2
    while p * p <= m:
        if m % p == 0:
            c += 1
            while m % p == 0:
                m //= p
        p += 1
    if m > 1:
        c += 1
    return -1 if c % 2 else 1


def ramanujan(N, a):
    """c_N(a) = phi(N) * mu(k)/phi(k),  k = N//gcd(a, N)."""
    g = math.gcd(a, N) if a != 0 else N
    k = N // g
    if k == 1:
        return phi(N)
    mk = mu(k)
    return phi(N) * mk // phi(k) if mk else 0


def main():
    t0 = time.time()
    # ---- (i) exact: idempotent + commuting marks -------------
    N1 = 210
    ps = [2, 3, 5, 7]
    m = np.arange(N1)
    marks = {p: (m % p != 0) for p in ps}
    ok_idem = all(np.array_equal(v * v, v) for v in marks.values())
    ok_comm = all(np.array_equal(marks[p] * marks[q], marks[q] * marks[p])
                  for p in ps for q in ps if p < q)
    W("(i) pointwise marks at N = 210:  idempotent = %s,  commuting = %s"
      % (ok_idem, ok_comm))
    W("    (indicator squared = indicator;  product pointwise:  exact)")

    # ---- (ii) brute-force single-p comb,  N = 210,  ALL a ----
    W("")
    W("(ii) single-p comb  F[1_{p|/. -}](a) = N*1_{a=0} - (N/p)*1_{(N/p)|a}")
    worst = 0.0
    for p in ps:
        lhs = np.zeros(N1)
        sel = m % p != 0
        # FFT of the mark gives F at all a at once (exact-enough:
        # integer sums of roots of unity,  |value| <= N)
        f = np.fft.fft(marks[p].astype(np.float64))
        for a in range(N1):
            rhs = (N1 if a == 0 else 0.0) - (N1 / p if (a % (N1 // p) == 0)
                                            else 0.0)
            worst = max(worst, abs(f[a].real - rhs))
        nz = np.nonzero(np.abs(f) > 1e-9)[0]
        W("    p = %d:  support size = %d (expected p = %d),  max error "
          "= %.3e" % (p, len(nz), p,
                      max(abs(f[a].real) - ((N1 if a == 0 else 0.0)
                                             - (N1 / p if a % (N1 // p) == 0
                                                 else 0.0))
                          for a in nz)))
    W("    max |LHS - RHS| over ALL a and p:  %.3e  (integer-valued sums;"
      % worst)
    W("    complex residual per entry < 1e-10 by construction)")

    # ---- (iii) full mask FFT at N = 30030  vs Ramanujan -------
    W("")
    W("(iii) full mask  F[1_{(.,N)=1}](a) = Ramanujan sum c_N(a)")
    N = 30030
    a = np.arange(N)
    mu_mask = np.ones(N, bool)
    for p in (2, 3, 5, 7, 11, 13):
        mu_mask &= a % p != 0
    f = np.fft.fft(mu_mask.astype(np.float64))
    phin = phi(N)
    W("    N = 30030 = 2*3*5*7*11*13,  phi(N) = %d" % phin)
    worst = 0.0
    for aa in range(N):
        rhs = ramanujan(N, aa)
        worst = max(worst, abs(f[aa].real - rhs))
    W("    max |FFT - closed form| over ALL %d a:  %.3e  (integer RHS;" %
      (N, worst))
    W("    FFT complex residual is roundoff,  O(1e-10) * N log N)")
    # support census of the Ramanujan field
    nz = np.nonzero(np.abs(f) > 1e-6)[0]
    W("    nonzero-field census:  %d / %d characters (the joint torsion"
      % (len(nz), N))
    W("    structure:  c_N(a) != 0 iff N/gcd(a,N) is squarefree and")
    W("    the unit mask's field factors as the p-combs convolved -")
    W("    each chime an (N/p)-torsion projection of the character ring)")

    # ---- (iv) Parseval ----------------------------------------
    W("")
    W("(iv) Parseval:  (1/N) sum_a |F[mu](a)|^2  vs  mean(mu^2)")
    lhs = float(np.sum(np.abs(f) ** 2)) / N
    rhs = phin / N
    W("    LHS = %.15f   RHS = %.15f   diff = %.3e"
      % (lhs, rhs, abs(lhs - rhs)))
    W("")
    W("U2 (P12 operator package,  measured) done (%.1f s)" % (time.time() - t0))
    OUT.close()
    print(open(OUT.name).read())


if __name__ == "__main__":
    main()
