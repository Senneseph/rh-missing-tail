#!/usr/bin/env python3
"""o4: the orbital side-quest O4 follow-up (cheap measurement) - the
band PHASE SWEEP at fixed x over z.

What this unit does
-------------------
0181 (tmp/kcs4b_out.txt, scripts/rh/kcs4b_width_number.py) measured the
level-1 band (L1, Phi, U2; W = U2 - L1 the pairwise mass - proven in
theorem form by 0184 level1_width_eq_pairwise) on a (x, z) grid with
z <= 71: W/xV grew 2.10 -> 10.12 in z, the position rho = (Phi - L1)/W
was x-stable to ~1e-6 and z-decaying 0.84 -> 0.67.  The side-quest O4
follow-up (docs/ORBITAL-TWO-BODY-SIDE-QUEST-2026-10-26.md): "z-sweep at
fixed x of band WIDTH FRACTION (not W/xV alone) and rho-drift; check
whether the relative width contracts in z (band-tightening) or only the
position stabilizes.  MEASURE, do not assert."

This run extends the z-axis to {31, 50, 71, 100, 200, 400} at fixed
x in {2e5, 1e6, 1e7, 1e8, 1e9, 1e10} and records, per (x, z):
    W/(x V(z))   the width vs the sieve main term (0181's number)
    W/Phi        the RELATIVE width (band-tightening diagnostic)
    W/U2         the width fraction vs the upper endpoint
    rho          = (Phi - L1)/W     (the in-band position; 0184 proves
                                     0 <= Phi - L1 <= W, so rho in [0,1])
    rho0         = Phi/U2
plus, per z: the x-spread of rho (the x-stability check at depth) and
per x: the z-trajectory of W/Phi and rho.

Exact: all band quantities are exact integers (the same definitions as
formal/RhAttack/SieveOrbit.lean: L1, U2pair, U2, phi_list) - Phi is
the memoized Legendre recursion (the in-tree phi_list semantics,
triple-checked against the mu-sum and brute force in 0181), V(z) the
exact product of (1 - 1/p) as a Fraction.  No float enters any
measured quantity (floats only at print).  No RH claim; the side-quest
is OFF-BOARD (flank); MEASURED status only.

Cost: seconds-to-minutes (memoized recursion; the state count is the
number of squarefree-smooth quotients, ~1e4..1e6 per x at this grid).
"""
import sys
import time
from fractions import Fraction
from functools import lru_cache

# the primes up to 400 (78 primes)
def primes_upto(b):
    s = [True] * (b + 1)
    s[0] = s[1] = False
    for i in range(2, int(b ** 0.5) + 1):
        if s[i]:
            for j in range(i * i, b + 1, i):
                s[j] = False
    return [i for i, v in enumerate(s) if v]

ALLP = primes_upto(400)


def make_phi(x, primes):
    """The Legendre recursion phi(x, a) = count of n <= x coprime to
    prod(primes[:a]) - memoized.  This is the in-tree phi_list
    semantics (SieveOrbit.lean, 0180; triple-checked in 0181)."""
    sys.setrecursionlimit(100000)

    @lru_cache(maxsize=None)
    def phi(y, a):
        if y < 1:
            return 0
        if a == 0:
            return y
        return phi(y, a - 1) - phi(y // primes[a - 1], a - 1)

    return phi


def band(x, zcutoff, phi):
    ps = [p for p in ALLP if p <= zcutoff]
    a = len(ps)
    Phi = int(phi(x, a))
    L1 = x - sum(x // p for p in ps)
    W = sum(x // (p * q) for i, p in enumerate(ps) for q in ps[i + 1:])
    U2 = L1 + W
    V = Fraction(1, 1)
    for p in ps:
        V *= Fraction(p - 1, p)
    xV = x * V
    return (len(ps), Phi, L1, W, U2, xV)


def main():
    t0 = time.time()
    out = []
    W = out.append
    Xs = [2 * 10 ** 5, 10 ** 6, 10 ** 7, 10 ** 8, 10 ** 9, 10 ** 10]
    Zs = [31, 50, 71, 100, 200, 400]

    W("=" * 78)
    W("O4 (side-quest follow-up)  the band PHASE SWEEP at fixed x over z")
    W("    (0181 extended: z to 400;  exact integers;  MEASURED, no claim)")
    W("=" * 78)
    W("")
    W("definitions = formal/RhAttack/SieveOrbit.lean (0180/0183/0184):")
    W("  Phi = phi_list (the Legendre recursion, exact count)")
    W("  L1  = x - sum_p floor(x/p)          (may go negative)")
    W("  W   = U2 - L1 = sum_{p<q} floor(x/(p q)) (0184: pairwise mass)")
    W("  U2  = L1 + W ;  V(z) = prod_{p<=z} (1 - 1/p) exact Fraction")
    W("  rho = (Phi - L1)/W  in [0,1] (0184 level1_position_in_band)")
    W("")

    data = {}
    for x in Xs:
        t1 = time.time()
        ps = [p for p in ALLP if p <= 400]
        phi = make_phi(x, ps)
        row = {}
        for zc in Zs:
            (a, Phi, L1, Wd, U2, xV) = band(x, zc, phi)
            assert 0 <= (Phi - L1) <= Wd, "sandwich violated (0184!)"
            rho = (Phi - L1) / Wd if Wd > 0 else float('nan')
            rho0 = Phi / U2 if U2 > 0 else float('nan')
            row[zc] = (a, Phi, L1, Wd, U2, xV, rho, rho0)
            data[(x, zc)] = row[zc]
        W("x = %12d   (phi memo built first at the deepest z: %.1f s)"
          % (x, time.time() - t1))
        W("  %4s %12s %14s %12s %10s %10s %10s %10s" % (
            "z", "pi z", "Phi", "W", "W/(xV)", "W/Phi", "rho", "rho0"))
        for zc in Zs:
            (a, Phi, L1, Wd, U2, xV, rho, rho0) = row[zc]
            W("  %4d %12d %14d %12d %10.4f %10.4f %10.6f %10.6f" % (
                zc, a, Phi, Wd, Wd / xV, Wd / Phi, rho, rho0))
        W("")

    W("== per z: the x-stability check on rho  (spread of rho over x) ==")
    for zc in Zs:
        rhos = [data[(x, zc)][6] for x in Xs]
        W("  z = %3d:  rho(x) = %s"
          % (zc, "  ".join("%.6f" % r for r in rhos)))
        W("          max - min = %.3e" % (max(rhos) - min(rhos)))
    W("")

    W("== per x: the z-trajectory of the RELATIVE width W/Phi ==")
    for x in Xs:
        W("  x = %10d:  " % x + "   ".join(
            "W/Phi(z=%d) = %.4f" % (zc, data[(x, zc)][3] / data[(x, zc)][1])
            for zc in Zs))
    W("")
    W("== per x: the z-trajectory of rho (the in-band position) ==")
    for x in Xs:
        W("  x = %10d:  " % x + "   ".join(
            "rho(z=%d) = %.4f" % (zc, data[(x, zc)][6]) for zc in Zs))
    W("")
    W("MEASURED,  do  not  assert:  the  side-quest  reading  of  the")
    W("tightening-vs-position question is written after this table,")
    W("in  the  same  commit  (O4  discipline).  No  RH  claim;  OFF-")
    W("BOARD;  pure  finite  sieve  combinatorics  over  exact  integers.")
    text = "\n".join(out) + "\n"
    with open("/home/jsmille/Projects/rh-missing-tail/tmp/o4_out.txt", "w") as f:
        f.write(text)
    print(text)
    print("O4 done (%.1f s)" % (time.time() - t0))


if __name__ == "__main__":
    main()
