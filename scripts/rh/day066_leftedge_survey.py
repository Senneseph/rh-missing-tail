#!/usr/bin/env python3
"""day066 - route (b) first unit: left-edge |zeta| survey at explicit
heights above the Platt frontier (0270 scope doc).

Left edge of the terminal strip: a = 1 - colletUpper = 0.1252270103,
colletUpper = 8747729897/10^10 (Z78Collet.colletUpper, in tree).

By the functional equation, for s = a + it:
    |zeta(a + it)| = 2^a * pi^(a-1) * |sin(pi a / 2)| * |Gamma(1 - a - i t)|
                    * |zeta(sigma' + i t)|,   sigma' = 1 - a = 0.8747729897.
The gamma factor is explicit (Stirling, rigorous at t >= tPT2), so a
BELOW bound on |zeta(a + it)| is equivalent to a below bound on
|zeta(sigma' + i t)| at the reflected height. sigma' > 1/2 is
Riemann-Siegel-tractable at explicit heights - this probe surveys it
and records the minimum scale (the reconnaissance for the left-edge
control sub-claim).

No RH content: a survey of |zeta(sigma' + it)| at explicit t. The
question it answers: how close to 0 does |zeta(sigma'+it)| get at
sigma' = 0.8747729897 for t >= tPT2, and on what scale?
"""
from mpmath import mp, mpf, sin, pi, sqrt, log, e

mp.dps = 50

tPT2 = mpf("3000175332800")
COLET_UPPER = mpf("8747729897") / mpf(10) ** 10
a = 1 - COLET_UPPER          # left edge sigma = 0.1252270103
sp = 1 - a                   # reflected right sigma = 0.8747729897

C = (mpf(2) ** a) * (pi ** (a - 1)) * abs(sin(pi * a / 2))
# |Gamma(1 - a - i t)| ~ sqrt(2*pi) * t^(1/2 - a) * e^(-pi t / 2)


def left_edge_r(t):
    """R(t) = |zeta(sigma' + i t)| - the gamma-factor-stripped left edge."""
    return abs(mp.zeta(sp + t * 1j))


def main():
    import sys
    tmax_extra = mpf(int(sys.argv[1])) if len(sys.argv) > 1 else mpf("10000000")
    step = mpf(int(sys.argv[2])) if len(sys.argv) > 2 else mpf("100000")
    t0 = tPT2
    print(f"a = {a:.10f}  (collet lower edge)")
    print(f"sigma' = {sp:.10f}  (reflected right sigma)")
    print(f"window: t in [{t0}, {t0 + tmax_extra}], step {step}")
    print(f"scale factor C(a) = {C:.6g}")
    print()
    vals = []
    t = t0
    n = 0
    while t <= t0 + tmax_extra:
        r = left_edge_r(t)
        vals.append((t, r))
        n += 1
        if n % 10 == 0:
            print(f"  {n:4d} points done (t = {t:.6e}, |zeta| = {r:.6e})")
        t += step
    rs = [r for _, r in vals]
    i0 = rs.index(min(rs))
    i1 = rs.index(max(rs))
    print()
    print(f"points: {n}")
    print(f"min |zeta(sigma'+it)| = {min(rs):.6e} at t = {vals[i0][0]:.6e}")
    print(f"max |zeta(sigma'+it)| = {max(rs):.6e} at t = {vals[i1][0]:.6e}")
    med = rs[::1]
    med.sort()
    print(f"median = {med[len(med)//2]:.6e}")
    # scale: min / t^(1/2) and min * e^(pi t / 2) / t^(1/2 - a) = |zeta(a+it)| * ...
    tmin = vals[i0][0]
    rmin = min(rs)
    zeta_left = C * sqrt(2 * pi) * tmin ** (mpf("1/2") - a) * e ** (-pi * tmin / 2) * rmin
    print()
    print(f"at the minimum: t = {tmin:.6e}")
    print(f"  |zeta(sigma' + it)|        = {rmin:.6e}")
    print(f"  |zeta(a + it)| (left edge, Stirling-scaled exact product of the")
    print(f"   explicit factors at this t) = {zeta_left:.6e}")
    print()
    print("interpretation (per 0270):")
    print(" - a below-bound |zeta(a+it)| >= f(t) on [tPT2, tPT2+W] is VISIBLE iff")
    print("   min |zeta(sigma'+it)| stays above the interval-arithmetic floor;")
    print(" - the probe scale decides the formal sub-claim's target exponent.")


if __name__ == "__main__":
    main()
