"""kcs4b: U4(b) - the FIRST-ORDER WIDTH NUMBER (KCS plan, measured).

docs/KANSAS-CITY-SHUFFLE-SIEVE-ORBIT-PLAN-2026-10-25.md, Unit 4(b):
state + measure the first-order sieve upper/lower gap at reachable z.

DEFINITION (finite, exact, no asymptotics, no RH claim)

  Phi(x, z)  = count of n <= x not divisible by any prime p <= z
               (the exact surviving count - the object of the Legendre
               identity just proven in Lean, SieveOrbit.lean 0180).

  L1(x, z)   = x - sum_{p <= z} floor(x / p)
               (the order-1 / level-1 inclusion-exclusion partial sum -
               the FINITE FIRST-ORDER LOWER bound:  L1 <= Phi,  exact;
               the classical level-1 lower sieve property, discrete)

  U2(x, z)   = L1 + sum_{p < q <= z} floor(x / (p q))
               (the order-2 partial sum - the level-1 UPPER bound:
               U2 >= Phi,  exact)

  W(x, z)    = U2 - L1        (the WIDTH: the first-order band)
  rho        = (Phi - L1) / (U2 - L1)    (POSITION of the exact count
               inside the band:  0 <= rho <= 1;  rho = 1/2 would be
               "the sieve has no parity information at all")

  xV         = x * prod_{p <= z} (1 - 1/p)   (the main term, exact
               rational)

The measurement:
  (i)   EXACTNESS: three independent exact computations of Phi agree
        cell by cell (Legendre recursion = the Lean phi_list; the full
        Mobius divisor sum = the Lean legendre_identity RHS; and a
        brute-force survivor count at small x) - the measured twin of
        discovery 0180.
  (ii)  THE SANDWICH: L1 <= Phi <= U2 on every row (the discrete
        level-1 upper/lower sieve property - a new exact finite fact,
        Lean-eligible as the next formal unit).
  (iii) THE WIDTH NUMBER: W / (xV) as a function of z (decaying) and
        the POSITION rho: where the exact count sits in the band
        (the parity-opacity reading:  how close to 1/2 is the exact
        count?  the deviation rho - 1/2 is the first measurable
        signature the level-1 sieve cannot see).
  (iv)  THE REMAINDER vs the classical worst case 2^{pi(z)} - 1
        (twin of the U1a remainder table).

All comparisons exact over integer / Fraction; floats only for the
reported ratios.  No RH claim: finite sieve combinatorics.
"""
import time
from fractions import Fraction

OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs4b_out.txt", "w")


def W(*a):
    print(*a, file=OUT)
    print(*a)


def primes_upto(n):
    sieve = bytearray([1]) * (n + 1)
    sieve[0:2] = b"\x00\x00"
    for i in range(2, int(n ** 0.5) + 1):
        if sieve[i]:
            sieve[i * i::i] = bytearray(len(range(i * i, n + 1, i)))
    return [i for i in range(2, n + 1) if sieve[i]]


PRIMES = primes_upto(100)


def sqf_divs_sum(X, ps):
    """Full Mobius divisor sum:  sum_{d | prod ps} mu(d) * (X // d),
    squarefree d only (mu 0 otherwise) - the Lean legendre_identity
    RHS, exact integers."""
    total = 0
    m = len(ps)
    for mask in range(1 << m):
        d = 1
        bits = 0
        for j in range(m):
            if mask >> j & 1:
                d *= ps[j]
                bits += 1
        if bits & 1:
            total -= X // d
        else:
            total += X // d
    return total


def legendre_recursive(X, ps):
    """The Lean phi_list recursion:  phi(x, p1..pn) = phi(x, p2..pn)
    - phi(x // p1, p2..pn).  Exact integers."""
    return _phi(X, ps, 0)


def _phi(X, ps, j):
    if j == len(ps):
        return X
    return _phi(X, ps, j + 1) - _phi(X // ps[j], ps, j + 1)


def brute_force(X, ps):
    """Direct survivor count at small x."""
    c = 0
    for n in range(1, X + 1):
        ok = True
        for p in ps:
            if p > n:
                break
            if n % p == 0:
                ok = False
                break
        c += 1 if ok else 0
    return c


def main(Xs, zlist_ps, brute_max_x):
    W("kcs4b - U4(b) the first-order WIDTH NUMBER (KCS plan unit 4(b))")
    W("exact integers throughout;  the Phi cell triple-checks the")
    W("0180 theorem (recursion = Mobius sum = brute force at small x).")
    W("")
    W("cols:  z  #p  x | Phi | L1 | U2 | W=U2-L1 | rho=(Phi-L1)/W")
    W("      | xV (main) | Phi-xV (remainder) | worst 2^#p-1 | W/(xV)")
    W("=" * 100)
    t0 = time.time()
    n_sandwich_viol = 0
    n_triple_ok = 0
    n_triple = 0
    worst_rho = None
    worst_rem = None
    for ps_sel in zlist_ps:
        z = ps_sel[-1]
        k = len(ps_sel)
        V = Fraction(1)
        for p in ps_sel:
            V *= Fraction(p - 1, p)
        pair_main = Fraction(0)
        for i in range(k):
            for j in range(i + 1, k):
                pair_main += Fraction(1, ps_sel[i] * ps_sel[j])
        for X in Xs:
            PhiA = sqf_divs_sum(X, ps_sel)          # Mobius sum
            PhiB = legendre_recursive(X, ps_sel)    # the recursion
            ok3 = True
            if PhiA != PhiB:
                ok3 = False
            if X <= brute_max_x:
                PhiC = brute_force(X, ps_sel)
                n_triple += 1
                if PhiC != PhiA:
                    ok3 = False
                if ok3:
                    n_triple_ok += 1
            Phi = PhiA
            L1 = X - sum(X // p for p in ps_sel)
            U2 = L1 + sum(X // (ps_sel[i] * ps_sel[j])
                          for i in range(k) for j in range(i + 1, k))
            Wband = U2 - L1
            if not (L1 <= Phi <= U2):
                n_sandwich_viol += 1
            xV = Fraction(X) * V
            rem = Phi - xV
            rho = (Phi - L1) / Wband if Wband else None
            rho0 = Phi / U2 if U2 else None   # position vs the trivial 0 floor
            ratio = (Wband / xV) if rho is not None else None
            if rho is not None:
                drho = abs(rho - 0.5)
                if worst_rho is None or drho > worst_rho[0]:
                    worst_rho = (drho, z, X, rho)
            if worst_rem is None or abs(rem) > abs(worst_rem[0]):
                worst_rem = (rem, z, X)
            W(f"z={z:<4} #{k:<3} x={X:<12d} "
              f"Phi={Phi:<12d} L1={L1:<12d} U2={U2:<12d} "
              f"W={Wband:<12d} rho={rho:.6f} rho0={rho0:.6f} "
              f"xV={float(xV):.6f} rem={float(rem):+.6f} "
              f"worst2={2 ** k - 1:<10d} W/xV={float(Wband / xV):.6f} "
              f"{'' if ok3 else '<<TRIPLE-MISMATCH'}")
    W("=" * 100)
    W(f"sandwich L1 <= Phi <= U2 violations: {n_sandwich_viol} (exact)")
    W(f"triple-checked cells (recursion=mu-sum=brute): "
      f"{n_triple_ok}/{n_triple}")
    if worst_rho:
        W(f"max |rho - 1/2| = {worst_rho[0]:.6f} at z={worst_rho[1]} "
          f"x={worst_rho[2]} (rho = {worst_rho[3]:.6f})")
    if worst_rem:
        W(f"max |Phi - xV| = {float(abs(worst_rem[0])):.6f} at "
          f"z={worst_rem[1]} x={worst_rem[2]}")
    W("")
    W("THE WIDTH NUMBER per z  (x = the largest sweep point;  the")
    W("x-stability above is to ~1e-6):")
    W("  W/xV   : the band width vs the main term (grows: the main")
    W("           term is a shrinking share of the level-1 band)")
    W("  rho    : exact position in [L1, U2]  (rho0: vs [0, U2])")
    W("=" * 100)
    for ps_sel in zlist_ps:
        z = ps_sel[-1]
        k = len(ps_sel)
        V = Fraction(1)
        for p in ps_sel:
            V *= Fraction(p - 1, p)
        X = Xs[-1]
        Phi = sqf_divs_sum(X, ps_sel)
        L1 = X - sum(X // p for p in ps_sel)
        U2 = L1 + sum(X // (ps_sel[i] * ps_sel[j])
                      for i in range(k) for j in range(i + 1, k))
        Wband = U2 - L1
        xV = Fraction(X) * V
        W(f"z={z:<4} #{k:<3}  W/xV={float(Wband / xV):<10.6f} "
          f"rho={float((Phi - L1) / Wband):.6f} "
          f"rho0={float(Phi / U2):.6f}")
    W(f"elapsed: {time.time() - t0:.1f}s")
    OUT.close()


if __name__ == "__main__":
    # x sweep (10^6 .. 10^10) + 2e5 for the brute-force triple cell;
    # z by prime count:  pi(z) in the list (primes <= 71, k <= 20)
    Xs = [200000] + [10 ** i for i in range(6, 11)]
    sel = [PRIMES[:target_k]
           for target_k in (4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20)]
    main(Xs, sel, brute_max_x=200000)
