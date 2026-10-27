#!/usr/bin/env python3
# U1c - the two-process zeta/sieve residual harness (KCS plan unit U1 item (c)).
#
# The spec (docs/KANSAS-CITY-SHUFFLE-SIEVE-ORBIT-PLAN-2026-10-25.md):
#   "(c) the two-process combined identity: zeta-side C-channel partial sum
#    under u^{-s} and sieve-side under chi at a common edge - residual at
#    the dps floor (E7a style).  Gate: exact (a); logged margin (b);
#    floor residual (c)."
#
# What this harness measures (no RH claim; flank, not face):
#
#   BOTH processes act on the SAME arithmetical input chi(n) at the SAME
#   edge x:
#
#   ZETA side (the C-channel, E7a style, mpmath at finite dps):
#       C(x, s)  = sum_{1 < n <= x} chi(n) * n^{-s},   s = 1/2 + i t
#       A(m)     = sum_{1 <= k <= m} chi(k)            (the prefix sum)
#       the E7a action identity (day006 harness, N = 1, M = x):
#         C = A(x) * x^{-s} - A(1) + s * I,
#         I = fsum_{m = 1..x-1} A(m) * (m^{-s} - (m+1)^{-s}) / s
#       the floor residual  R_z = |C - (A(x) x^{-s} - A(1) + s I)|
#       -- measured at each dps; the dps-floor is where R_z plateaus.
#
#   SIEVE side (EXACT integers, the 0180/0183 machinery, U1a form):
#       V_chi(x, z) = sum_{d | P(z)} mu(d) chi(d) S_chi(floor(x / d)),
#       P(z) = prod_{p <= z} p  (squarefree),  S_chi = the chi prefix sum.
#       main term:  x * V(z) = x * prod_{p <= z} (1 - 1/p)   for chi = 1
#                   0                                            for chi != 1
#                   (U1a: V_chi is a bounded exact integer, |V| <= 4 measured)
#       the exact residual  R_s = |V_chi - main|.
#
#   The raw deliverable (O1 of the orbital side-quest records the same
#   numbers): the two residual columns side by side at the common edge +
#   the relative floor R_z/|C| + a dps sweep at one edge (the floor law).
#   The ratio columns are MEASURED NUMBERS, not a law.
#
# Cost: < 1 h wall (mpmath complex powers dominate, x up to 1e6 at dps 30).

from fractions import Fraction

from mpmath import mp, mpf, mpc, fsum, j


# ----------------------------------------------------------------------
# characters (exact, periodic)
# ----------------------------------------------------------------------
def chi_triv(n):
    return 1


def chi5(n):
    r = n % 5
    return {1: 1, 2: -1, 3: -1, 4: 1, 0: 0}[r]


def chi3(n):
    r = n % 3
    return {1: 1, 2: -1, 0: 0}[r]


# exact prefix sums via the period shortcut (O(1) in n, exact int)
def make_prefix(chi, period):
    csum = sum(chi(k) for k in range(1, period + 1))

    def A(n):
        if n <= 0:
            return 0
        q, r = divmod(n, period)
        return q * csum + sum(chi(k) for k in range(1, r + 1))

    return A


PRIMES_Z31 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]


def mobius_of_squarefree(d, primes):
    # d divides the squarefree product; count distinct prime factors
    cnt = 0
    for p in primes:
        if d % p == 0:
            d //= p
            cnt += 1
    if d != 1:
        raise ValueError("non-squarefree d")
    return (-1) ** cnt


def sieve_side(x, chi, A, zprimes, period):
    """V_chi(x, z) exact: sum_{d | P} mu(d) chi(d) S_chi(floor(x/d))."""
    P = 1
    for p in zprimes:
        P *= p
    # enumerate squarefree divisors of P
    out = [1]
    for p in zprimes:
        out += [d * p for d in out]
    V = 0
    for d in out:
        V += mobius_of_squarefree(d, zprimes) * chi(d) * A(x // d)
    return V


def sieve_main_fraction(x, zprimes):
    V = Fraction(1, 1)
    for p in zprimes:
        V *= Fraction(p - 1, p)
    return x * V


# ----------------------------------------------------------------------
# zeta side: the C-channel at s = 1/2 + i t, N = 1 edge form (E7a)
# ----------------------------------------------------------------------
def power_table(x, t, dps):
    """pw[n] = n^{-s} for n = 1..x (+1 for the I shift), at s = 1/2 + i t."""
    mp.dps = dps
    s = mpf("0.5") + t * j
    pw = [mpc(0)] * (x + 2)
    pw[1] = mpc(1)
    for n in range(2, x + 2):
        pw[n] = n ** (-s)
    return pw, s


def zeta_side(x, chi, A, t, dps, pw=None):
    """Return (R_z, C_abs, C).  C = sum_{2..x} chi(n) n^{-s};
    R_z = |C - (A(x) x^{-s} - A(1) + s I)| with I the E7a integral sum.
    pw may be a shared power_table for the same (x, t, dps)."""
    mp.dps = dps
    s = mpf("0.5") + t * j
    if pw is None:
        pw, s = power_table(x, t, dps)
    C = fsum(chi(n) * pw[n] for n in range(2, x + 1))
    A1 = A(1)
    Ax = A(x)
    # I = fsum_{m=1..x-1} A(m) (pw[m] - pw[m+1]) / s     (N = 1 form)
    I = fsum(A(m) * (pw[m] - pw[m + 1]) for m in range(1, x)) / s
    rhs = Ax * pw[x] - A1 + s * I
    R = abs(C - rhs)
    Cabs = abs(C)
    return R, Cabs, C


def main():
    out = []
    W = out.append
    W("=" * 78)
    W("U1c  the  two-process  zeta/sieve  residual  harness  (KCS plan U1 item c)")
    W("common edge (x, chi, t);  zeta side = C-channel E7a action at dps;")
    W("sieve side = V_chi(x, z) EXACT at z = 31 (11 primes, P squarefree).")
    W("Gate: logged floor residual (c).  No RH claim.")
    W("=" * 78)

    CHIS = {
        "triv": (chi_triv, lambda n: n, 1),
        "(./3)": (chi3, make_prefix(chi3, 3), 3),
        "(./5)": (chi5, make_prefix(chi5, 5), 5),
    }

    # (a) sieve side: EXACT table at all x (independent of dps)
    W("")
    W("==  sieve side  (EXACT integers, z = 31)  ==")
    W("x          chi        V_chi          main         R_s = |V - main|")
    sieve_vals = {}
    for x in [10**4, 10**5, 10**6, 10**7]:
        for name, (chi, A, per) in CHIS.items():
            V = sieve_side(x, chi, A, PRIMES_Z31, per)
            if name == "triv":
                main = sieve_main_fraction(x, PRIMES_Z31)
                rs = float(abs(Fraction(V) - main))
                rs_s = f"{rs:.6e}  (main xV = {float(main):.6e})"
                sieve_vals[(x, name)] = (V, rs_s, rs)
            else:
                rs = float(abs(V))
                rs_s = f"{abs(V)}"
                sieve_vals[(x, name)] = (V, rs_s, rs)
            W(f"{x:<10d}  {name:<8s}  {V:<13d}  "
              + (f"{float(sieve_main_fraction(x, PRIMES_Z31)):.6e}" if name == "triv" else "0")
              + f"   {rs_s}")

    # (b) zeta side + the two residual columns side by side at dps = 30
    W("")
    W("==  common edge:  residuals side by side  (dps = 30)  ==")
    W("x       t    chi    R_z (floor residual)   rel = R_z/|C|   R_s (exact)")
    rows = []
    for x in [10**4, 10**5, 10**6]:
        for t in [10, 100]:
            pw, _ = power_table(x, t, dps=30)
            for name, (chi, A, per) in CHIS.items():
                R, Cabs, _ = zeta_side(x, chi, A, t, dps=30, pw=pw)
                V, rs_str, rs = sieve_vals[(x, name)]
                rel = R / Cabs if Cabs != 0 else mp.inf
                W(f"{x:<7d} {t:<4d}  {name:<6s}  {mp.nstr(R, 6):<22s}  "
                  f"{mp.nstr(rel, 5):<15s}  {rs_str}")
                rows.append((x, t, name, float(R), float(abs(mpf(rel))), rs))
    W("")
    W("==  raw ratio log  (measured numbers, not a law;  O1 records these)  ==")
    W("x       t    chi    log10(R_z)    log10(R_s)   (the two-process spread)")
    import math
    for (x, t, name, rz, rel, rs) in rows:
        lrs = math.log10(rs) if rs > 0 else float("inf")
        lrs_s = (f"{lrs:.4f}" if lrs != float("inf") else "inf").ljust(12)
        lrz_s = (f"{math.log10(rz):.4f}" if rz > 0 else "0").ljust(12)
        W(f"{x:<7d} {t:<4d}  {name:<6s}  {lrz_s}  {lrs_s}")

    # (c) the dps floor: sweep at one common edge (x = 1e5, t = 10, chi5)
    W("")
    W("==  the  dps  floor  (x = 100000,  t = 10,  chi = (./5))  ==")
    W("dps    R_z                 rel = R_z/|C|     (floor = the plateau)")
    for dps in [10, 15, 20, 30, 40, 50]:
        R, Cabs, _ = zeta_side(10**5, chi5, make_prefix(chi5, 5), 10, dps=dps)
        W(f"{dps:<4d}  {mp.nstr(R, 8):<22s}  {mp.nstr(R / Cabs, 7)}")

    W("")
    W("gate (c): floor residual logged above; sieve side exact for all x.")
    W("No RH claim: the zeta-side residual is a finite-dps identity residual of")
    W("the E7a action (same identity, day006 harness form); the sieve-side")
    W("residual is an exact integer count.  Nothing here touches zeros or")
    W("heights.  Flank, not face.")
    text = "\n".join(out) + "\n"
    with open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs1c_out.txt", "w") as f:
        f.write(text)
    print(text)


if __name__ == "__main__":
    main()
