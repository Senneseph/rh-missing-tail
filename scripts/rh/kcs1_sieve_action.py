"""kcs1: U1a - the Sieve Action identity, EXACT integer verification.

The Kansas City Shuffle plan (docs/KANSAS-CITY-SHUFFLE-
SIEVE-ORBIT-PLAN-2026-10-25.md), Unit 1a.  Three exact statements,
all over integers (no floating point, no RH claim):

(1)  THE CHARACTER-SIEVE IDENTITY  (the "Action series"), general
      form with S_chi(u) = sum_{m<=u} chi(m) the character prefix:

      V_z(x)  :=  sum_{n<=x, (n, Pbar(z)) = 1}  chi(n)
               ==  sum_{d | Pbar(z)}  mu(d) chi(d) S_chi(floor(x/d))

      (left: brute-force character sum over the survivors; right: the
      multiplicative/Euler side - the same factors (1 - chi(p)/p) that
      the Dirichlet L-series carries at the zeta end; Pbar(z) =
      prod_{p<=z} p, mu the Mobius function, chi multiplicative.)

      The PRINCIPAL-character specialization S_1(u) = u is the
      Euler-product form V = x*prod_{p<=z}(1 - chi(p)/p) + R with R a
      tiny exact rational (the remainder table below vs the 2^{pi(z)}
      worst case - the grind the second orbit hops over).  For a
      NON-PRINCIPAL chi the character prefix S_chi is bounded, so the
      whole two-sided quantity is an O(1) exact integer: the grind
      does not exist on that orbit at all.

(2)  THE PER-HOP ACTION (edge-flux) RECURSION, sieve primes in
      ascending order:  with m_j the survivor indicator under
      p_1..p_j and m_0 all-true,

        sum_{n<=x} c[n] m_j[n]
          ==  sum_{n<=x} c[n] m_{j-1}[n]
             - chi(p_j) * sum_{n<=x//p_j} c[n] m_{j-1}[n]

      (one sieve hop = the edge flux of the PREVIOUS survivor path at
      the scaled height - the flat/total-difference reading in the E7a
      style of docs/THE-EULER-ACTION.md; verified here DIRECTLY on
      the incremental masks, stage by stage, with the final mask sum
      equal to the brute force of (1).)

(3)  THE REMAINDER:  R(x,z) = V_z(x) - x*prod_{p<=z}(1 - chi(p)/p)
      (exact rational;  |R| <= 2^{pi(z)} - 1 is the classical worst
      case - the exponential GRIND;  we record the actual |R| against
      it.)

Characters: chi = 1 (principal: c[n] = 1 on all n>=1) and
chi = (n/4) (Kronecker mod 4: 0 on evens, +-1 on odds).
"""
import math
import time
from fractions import Fraction

import numpy as np

OUT = open("/home/jsmille/Projects/rh-missing-tail/tmp/kcs1_out.txt", "w")


def W(*a):
    print(*a, file=OUT)


def primes_upto(z):
    s = np.ones(z + 1, bool)
    s[:2] = False
    for p in range(2, int(z ** 0.5) + 1):
        if s[p]:
            s[p * p::p] = False
    return [int(p) for p in np.nonzero(s)[0]]


def chi4(n):
    r = int(n) % 4
    return 1 if r == 1 else (-1 if r == 3 else 0)


def S_chi4(u):
    """exact character prefix S(u) = sum_{m<=u} chi4(m): the pattern
    1, 1, 0, 0, 1, ... => S(u) = 1 iff u mod 4 in {1, 2} else 0."""
    r = int(u) % 4
    return 1 if r in (1, 2) else 0


def run(z, x, principal):
    ps = [p for p in primes_upto(z) if p <= x]

    divs = [1]
    for p in ps:
        divs += [d * p for d in divs]

    def chi_of(d):
        r = 1
        for p in ps:
            if d % p == 0:
                r *= 1 if principal else chi4(p)
        return r

    def mu_of(d):
        return (-1) ** sum(1 for p in ps if d % p == 0)

    # character array c on [0..x] (c[0] = 0)
    if principal:
        c = np.ones(x + 1, dtype=np.int64)
        c[0] = 0
    else:
        c = np.array([0 if v < 1 else chi4(v) for v in range(x + 1)],
                     dtype=np.int64)

    # --- (1) brute force vs the multiplicative side (exact) ----------
    mask = np.ones(x + 1, bool)
    mask[0] = False
    for p in ps:
        mask[::p] = False
    V_bf = int((c * mask).sum())

    def S(u):
        return int(u) if principal else S_chi4(u)

    V_id = sum(mu_of(d) * chi_of(d) * S(x // d) for d in divs if d <= x)
    ok_id = (V_bf == V_id)

    # --- (2) the per-hop action, verified incrementally (direct) -----
    prev = np.ones(x + 1, bool)
    prev[0] = False
    ok_act = True
    for p in ps:
        cp = 1 if principal else chi4(p)
        lhs = int((c[: x + 1] * prev).sum()) \
            - cp * int((c[: x // p + 1] * prev[: x // p + 1]).sum())
        prev = prev.copy()
        prev[::p] = False
        rhs = int((c[: x + 1] * prev).sum())
        if lhs != rhs:
            ok_act = False
    ok_act &= (V_bf == int((c[: x + 1] * prev).sum()))

    # --- (3) remainder vs the 2^{pi(z)} worst case --------------------
    # (principal character only: the Euler-product form exists there)
    if principal:
        prod_factor = Fraction(1)
        for p in ps:
            prod_factor *= Fraction(1) - Fraction(1, p)
        R = V_id - Fraction(x) * prod_factor
        bound = 2 ** len(ps) - 1 if ps else 0
    else:
        R, bound = None, None

    W("z=%-3d x=%-8d chi=%s:  V_bf=% +12d  V_id=% +12d  identity=%s  "
      "per-hop action=%s  (hops=%d, Pbar=%d)" % (
          z, x, "1" if principal else "(n/4)", V_bf, V_id,
          "EXACT" if ok_id else "FAIL", "EXACT" if ok_act else "FAIL",
          len(ps), math.prod(ps) if ps else 1))
    if principal:
        W("     R = %s   |R| = %d   worst 2^pi-1 = %d   ratio = %s" % (
            R, abs(int(R)), bound,
            ("%.3e" % (abs(float(R)) / bound)) if bound else "n/a"))
    else:
        W("     V is a bounded exact integer (|V| = %d): character prefix "
          "O(1) - no grind on this orbit" % abs(V_id))
    return ok_id and ok_act


t0 = time.time()
allok = True
for principal in (True, False):
    for z in (2, 3, 5, 7, 11, 17, 23, 31):
        for x in (10 ** 5, 10 ** 6) + ((10 ** 7,) if z <= 17 else ()):
            allok &= run(z, x, principal)
W("")
W("KCS1 U1a: %s  (%.1f s)" % ("ALL EXACT" if allok else "FAILURE",
                               time.time() - t0))
OUT.close()
print("KCS1 done:", "ALL EXACT" if allok else "FAILURE")
