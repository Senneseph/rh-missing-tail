#!/usr/bin/env python3
"""Probe 3 (meditation preflight): the TURNED AWAY, made exact.

Owner's meditation chain (2026-10-28):
  (a) for a prime to appear, something must be turned away
  (b) what if 1/p is 'what is turned away?' (not simply division by
      another integer)
  (c) 'it loses division by 2, the only even prime, by +1 or -1'

This probe checks each piece at X = 2e6:
  A. the turned-away ledger: sum_p 1/p vs ln ln X + B1 (Meissel-Mertens)
  B. the music = the product of the turned away: prod (1 - 1/p) vs
     e^{-gamma}/ln X (Mertens III) + the fine-structure sum c_q =
     -ln(1-1/q) - 1/q -> gamma - B1 (the part the naive 1/p misses)
  C. the owner's prime 5: the exact rational turned-away ledger for
     2, 3, 5 (each prime turns away exactly 1/p of the survivors)
  D. the +1/-1 appearance geometry:
     - the 8 bands = the free classes of {2,3}; every prime >= 5 sits
       at distance +1/-1 (mod 2) and (mod 3)  [verify]
     - the TWIN block class: p = -2 (mod q) ('one short of the line',
       the +2 step lands ON the line): twin share by the -2 class of
       q = 5,7,11,13 (expect 0) vs the other free classes
     - the distance-one score D(p) = #{small q: p = +1/-1 (mod q)}:
       does it move the twin rate or the small-gap rate?
"""
import math
from collections import Counter, defaultdict

X = 2_000_000
GAMMA = 0.57721566490153286
B1 = 0.2614972128476428  # Meissel-Mertens constant

def sieve(n):
    b = bytearray([1]) * (n + 1); b[0] = b[1] = 0
    for i in range(2, int(n ** 0.5) + 1):
        if b[i]: b[i * i::i] = bytearray(len(b[i * i::i]))
    return [i for i in range(n + 1) if b[i]]

def main():
    P = sieve(X)
    n = len(P)
    g = [P[i + 1] - P[i] for i in range(n - 1)]
    print(f"X = {X}   pi = {n}")

    # ---- A. the ledger ----
    print("\n--- A. the turned-away ledger: sum_p 1/p ---")
    T = 0.0
    for p in P:
        T += 1.0 / p
    lnln = math.log(math.log(X))
    print("  sum(1/p over p <= X)   = " + f"{T:.8f}")
    print(f"  ln ln X + B1          = {lnln + B1:.8f}   (B1 = {B1})")
    print(f"  diff (converging to B1 from above): {T - lnln - B1:+.3e}")

    # ---- B. the music: product of the turned away ----
    print("\n--- B. music = product of the turned away (Mertens III) ---")
    lprod = 0.0
    lprod_odd = 0.0
    csum = 0.0
    for p in P:
        lprod += math.log1p(-1.0 / p)
        if p != 2:
            lprod_odd += math.log1p(-1.0 / p)
        csum += -math.log1p(-1.0 / p) - 1.0 / p
    prod = math.exp(lprod)
    prod_odd = math.exp(lprod_odd)
    melody = math.exp(-GAMMA) / math.log(X)
    print("  prod(1 - 1/p), INCLUDING 2   = " + f"{prod:.8f}")
    print(f"  odd-only product (the music BEFORE the line of 2)  = {prod_odd:.8f}  = 2 x the full (the line of 2 HALVES the music)")
    print(f"  e^(-gamma)/ln X                       = {melody:.8f}")
    print(f"  ratio (full product / melody)         = {prod/melody:.8f}   (-> 1; the music IS the product of the turned away)")
    print(f"  fine structure sum c_q= -ln(1-1/q) - 1/q  = {csum:.8f}")
    print(f"  gamma - B1            = {GAMMA - B1:.8f}  (the convergent total; the part the naive 1/p misses)")

    # ---- C. the owner's prime 5 (exact rationals) ----
    print("\n--- C. the owner's prime 5: the exact turned-away ledger ---")
    print("""  field 1.0
    2 turns away  1/2  of the field   (2 IS the line; the only even prime)
    3 turns away  1/3  of survivors   =  1/6  of the field
    5 turns away  1/5  of survivors   =  1/15 of the field
    survivors after 2,3,5             =  4/15 of the field
  every prime turns away exactly its own 1/p (relative mass) at the
  moment of appearance; composites add no channel (they are survivors
  who carry another's line, not a new one).""")

    # ---- D. the +1/-1 appearance geometry ----
    print("\n--- D. the +1/-1 appearance geometry ---")
    # D1: every prime >= 5 at distance 1 from the lines of 2 and 3
    bad2 = [p for p in P[2:] if p % 2 not in (1,)]
    bad3 = [p for p in P[2:] if p % 3 not in (1, 2)]
    print(f"  primes >= 5 NOT at +1/-1 (mod 2): {len(bad2)}   (expect 0; +1/-1 mod 2 is one class)")
    print(f"  primes >= 5 NOT at +1/-1 (mod 3): {len(bad3)}   (expect 0; free classes of 3 ARE +/-1)")
    # D2: the twin block class = the -2 class ('one short of the line')
    print("  twin share by the -2 class of q (p = q-2 mod q: the +2 step lands ON the line)")
    print("  the lone twins inside the blocked class = the line's FIRST prime (p+2 = q): e.g. 5->7, 11->13")
    for q in (3, 5, 7, 11, 13):
        blocked, free = 0, 0
        for i in range(2, n - 1):
            p = P[i]
            if p % q == (q - 2) % q:
                blocked += 1
            else:
                free += 1
        tb = sum(1 for i in range(2, n - 1) if P[i] % q == (q - 2) % q and g[i] == 2)
        tf = sum(1 for i in range(2, n - 1) if P[i] % q != (q - 2) % q and g[i] == 2)
        print(f"    q = {q:>2}:  blocked class n = {blocked:>6}  twin share = {tb/blocked:8.6f}  |  other classes twin share = {tf/free:.6f}")
    # D3: the distance-one score and the twin / small-gap rate
    smalls = [q for q in P if q <= 43]        # 2..43
    def d1(p):
        return sum(1 for q in smalls if p % q in (1, q - 1))
    by = defaultdict(list)
    for i in range(2, n - 1):
        by[d1(P[i])].append(g[i])
    print("  distance-one score D(p) (# small q <= 43 with p = +/-1 mod q) vs next-gap stats:")
    for k in sorted(by):
        xs = by[k]
        tw = sum(1 for x in xs if x == 2) / len(xs)
        mg = sum(x for x in xs) / len(xs)
        print(f"    D = {k:>2}:  n = {len(xs):>6}   twin share = {tw:7.4f}   mean next gap = {mg:7.3f}")
    print("\ndone.")

if __name__ == "__main__":
    main()
