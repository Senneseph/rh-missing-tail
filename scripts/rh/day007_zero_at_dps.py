# day007: dps certification of the TS zero finder's output (docker, mpmath).
#
# Input: the float64 zero from the TS finder (day007 zero-at, the first zero
# above the dps-certified 1e5 anchor, N(1e5) = 138,065):
#     gamma_138066 (float) = 100000.74372348833
#
# Certificates (all computed, dps-50 unless noted):
#  1. exact zero gamma* in [t0 - 5e-6, t0 + 5e-6] with |Z(gamma*)| < 1e-45,
#     Z(t) = Re[exp(i vartheta(t)) zeta(1/2 + i t)]  (vartheta = DLMF 25.10.2)
#  2. Z'(gamma*) — the slope (simplicity proxy; a dps measurement, not a
#     simplicity proof)
#  3. S(gamma*) = N - main - 7/8 with N = 138,066 (first zero above the
#     certified anchor; the TS dt vs dt/2 walk certifies exactly one flip
#     in (1e5, t0 + 5e-6))
#  4. 2K parity at T = gamma* +/- 0.25 via the day-003 identity
#     2K(T) = (N(T) - main(T) + 1) - arg(zeta(1/2+iT))/pi  (dps-40, error
#     measured < 1e-6 there): an even integer certificate, not a mod-2 count.

import math
import sys

import mpmath as mp

T0 = float(sys.argv[1]) if len(sys.argv) > 1 else 100000.74372348833
N_ANCHOR = 138065  # N(1e5), dps-certified (day-003 census)


def main_term(t):
    t = mp.mpf(t)
    return t / (2 * mp.pi) * (mp.ln(t / (2 * mp.pi)) - 1) + mp.mpf(7) / 8


def vartheta(t):
    t = mp.mpf(t)
    return mp.im(mp.loggamma(mp.mpf("0.25") + 0.5j * t)) - 0.5 * t * mp.ln(mp.pi)


def Z(t):
    t = mp.mpf(t)
    return mp.re(mp.e ** (1j * vartheta(t)) * mp.zeta(mp.mpf("0.5") + 1j * t))


def find_zero(lo, hi):
    # coarse sign-change scan (dps 30), then dps-50 bisection
    mp.dps = 30
    n = 50
    prev = Z(lo)
    a, b = lo, None
    for i in range(1, n + 1):
        t = mp.mpf(lo) + (mp.mpf(hi) - mp.mpf(lo)) * i / n
        z = Z(t)
        if prev * z < 0:
            a, b = (t - (mp.mpf(hi) - mp.mpf(lo)) / n, t)
            break
        prev = z
    if b is None:
        raise SystemExit("no sign change in window")
    mp.dps = 50
    za = Z(a)
    for _ in range(50):
        m = (a + b) / 2
        zm = Z(m)
        if abs(zm) < mp.mpf("1e-48"):
            a = b = m
            break
        a, za = (m, zm) if za * zm > 0 else (a, za)
        b = m
    g = (a + b) / 2
    return g


print("window: T0 = %.15f  +/- 5e-6" % T0)
mp.dps = 50
g = find_zero(T0 - 5e-6, T0 + 5e-6)
zg = Z(g)
zg_abs = abs(zg)
print("gamma* = " + mp.nstr(g, 42))
print("|Z(gamma*)| = " + mp.nstr(zg_abs, 6) + "  (< 1e-45 required)")

# derivative at dps 55
mp.dps = 55
zlo = Z(g - mp.mpf("1e-9"))
zhi = Z(g + mp.mpf("1e-9"))
sg = (zhi - zlo) / (2 * mp.mpf("1e-9"))
print("Z'(gamma*) = " + mp.nstr(sg, 10) + "  (simplicity proxy: |Z'| = " + mp.nstr(abs(sg), 6) + ")")

# S(gamma*) with N = 138,066
mp.dps = 45
N = mp.mpf(N_ANCHOR + 1)
s_of_g = N - main_term(g) - mp.mpf(7) / 8
print("N(gamma*) = %d   S(gamma*) = " % N + mp.nstr(s_of_g, 12))

# 2K parity certificates (day-003 identity), offsets avoid the zero itself
for off, n_t in (("gamma* - 0.25", N_ANCHOR), ("gamma* + 0.25", N_ANCHOR + 1)):
    mp.dps = 45
    T = g + (mp.mpf("0.25") if "+" in off else -mp.mpf("0.25"))
    ph = mp.arg(mp.zeta(mp.mpf("0.5") + 1j * T))
    two_k = (mp.mpf(n_t) - main_term(T) + 1) - ph / mp.pi
    resid = abs(two_k - mp.mpf(round(float(two_k))))
    print("2K(%s) = %s   (distance to nearest int = %s; even = %s)" % (
        off, mp.nstr(two_k, 14), mp.nstr(resid, 6), "yes" if round(float(two_k)) % 2 == 0 else "NO"))
print("done")
