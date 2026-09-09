#!/usr/bin/env python3
"""Shared, validated zeta engine for the RH attack (kainos-logos).

Extracted verbatim from the Day-001 layer (scripts/rh/day001_zeta.py,
committed 2fd7e13) so that Day-002+ experiments reuse the SAME verified
code path instead of a second copy.  Self-test in __main__ re-checks the
S1 gate in <5 s; run `python3 zeta_core.py` to re-validate before any new
experiment is trusted.

Functions:
  gam/cloggamma   Lanczos log Gamma, robust to large |Im z| (shift to Re>=50)
  zeta            Euler-Maclaurin, convergent M-rule, L=20
  vartheta/Z      DLMF 25.10 real Z-function (|Z| = |zeta(1/2+it)| EXACTLY)
  chi             FE factor in overflow-proof cosine form
  beta            Dirichlet beta via convergent pair series
  find_zeros      sign-change walk + bisection with |zeta|<1e-7 assertion
"""
import cmath
import math
import sys

import numpy as np

_LANCZOS = (
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-06,
    1.5056327351493116e-07,
)


def _cloggamma_base(z: complex) -> complex:
    z = z - 1.0
    x = _LANCZOS[0]
    for i in range(1, len(_LANCZOS)):
        x += _LANCZOS[i] / (z + i)
    t = z + 7.5
    return 0.5 * math.log(2.0 * math.pi) + (z + 0.5) * np.log(t) - t + np.log(x)


def cloggamma(z: complex) -> complex:
    z = complex(z)
    ns = max(0, int(math.ceil(50.0 - z.real)))
    out = _cloggamma_base(z + ns)
    for i in range(ns):
        out -= np.log(complex(z) + i)
    return out


def gam(z: complex) -> complex:
    return np.exp(cloggamma(z))


_NMAX = 80_000  # covers M = ceil(0.78|s|+30) up to |s| ~ 1e5 (T=1e5 census)
LN_N = np.log(np.arange(1.0, _NMAX + 1.0))

_BERNOULLI = [1.0, -0.5]


def _bernoulli(n: int) -> float:
    while len(_BERNOULLI) <= n:
        m = len(_BERNOULLI)
        acc, c = 0.0, 1.0
        for k in range(m):
            acc += c * _BERNOULLI[k]
            c = c * (m + 1 - k) / (k + 1)
        _BERNOULLI.append(-acc / (m + 1))
    return _BERNOULLI[n]


EM_COEFS = [_bernoulli(2 * k) / math.factorial(2 * k) for k in range(1, 21)]


def zeta(s: complex) -> complex:
    s = complex(s)
    t = abs(s.imag)
    M = int(math.ceil(max(64.0, 0.78 * max(t, abs(s.real) + 0.5) + 30.0)))
    M = min(M, _NMAX)
    lm = math.log(float(M))
    tot = np.exp(-s * LN_N[:M]).sum()
    tot += np.exp((1.0 - s) * lm) / (s - 1.0)
    tot -= 0.5 * np.exp(-s * lm)
    a = s
    p1 = np.exp(-lm)
    mt = np.exp(-s * lm)
    pm2 = p1 * p1
    for k in range(1, 21):
        tot += EM_COEFS[k - 1] * a * mt * (pm2 ** (k - 1)) * p1
        a *= (s + 2 * k - 1) * (s + 2 * k)
    return tot


def vartheta(t: float) -> float:
    """DLMF 25.10.2: ph Gamma(1/4 + it/2) - (t/2) ln pi; chosen so that
    e^{i vartheta} zeta(1/2+it) IS real (verified vs mpmath dps 50/80)."""
    if t == 0.0:
        return 0.0
    cg = cloggamma(0.25 + 0.5j * t)
    return cg.imag - 0.5 * t * math.log(math.pi)


def Z(t: float) -> float:
    """DLMF 25.10.1: real, and |Z(t)| = |zeta(1/2+it)| EXACTLY."""
    s = 0.5 + 1j * t
    return float(np.real(np.exp(1j * vartheta(t)) * zeta(s)))


def chi(s: complex) -> complex:
    s = complex(s)
    return (
        np.exp((s - 1.0) * math.log(2.0) + s * math.log(math.pi))
        / (np.cos((math.pi / 2.0) * s) * gam(s))
    )


def beta(s: complex, pairs: int = 2_000_000) -> tuple:
    """Dirichlet beta(s) via the pair series sum_m [(4m+1)^{-s} - (4m+3)^{-s}].
    Returns (value, tail_bound).  HONEST bound: each pair difference is
    <= 2|s| (4m+1)^{-sigma-1}, integrated:  tail <= (2|s|/sigma)(4P)^{-sigma}
    for sigma > 0.  NOTE: this decays only like P^{-sigma}: at sigma=1/2 it
    is O(|s|/sqrt(P)) (2|s|/sqrt(4P)) -- use mpmath (mp.dirichlet) for
    high-precision values on or near the line.  For sigma <= 0 the pair
    series is only conditionally convergent (Dirichlet test); bound = inf."""
    s = complex(s)
    sig = s.real
    m = np.arange(pairs, dtype=np.float64)
    v = np.exp(-s * np.log(4.0 * m + 1.0)) - np.exp(-s * np.log(4.0 * m + 3.0))
    if sig > 1e-9:
        tail = (2.0 * abs(s) / sig) * (4.0 * pairs) ** (-sig)
    else:
        tail = float("inf")  # conditional regime; value still defined
    return complex(v.sum()), tail


def _psi(p: float) -> float:
    """Psi(p) = cos(2 pi (p^2 - p - 1/16)) / cos(2 pi p)  (RS remainder kernel,
    from the 'Z function' reference page fetched for day-003)."""
    return cmath.cos(2.0 * math.pi * (p * p - p - 0.0625)) / cmath.cos(2.0 * math.pi * p)


def _psi_d3(p: float) -> float:
    """Psi'''(p), the TRUE third derivative, via the complex-step formula.

    day-007 fix (2026-09-09): the original returned RE[S]/h^3, an O(h*psi'''')
    near-zero residual (~1e-2..1e-1, sometimes the WRONG SIGN -- a 35x error
    vs mpmath). The alternating sum S = (ih)^3 psi'''(p) - 1.5 h^4 psi'''' + ...
    puts the true derivative in the IMAGINARY part: psi'''(p) = -Im[S]/h^3
    (O(h^2) = 1.25e-6*psi''''' residual). Verified vs mp.diff (dps-45) at
    three p values and vs dps Z at eight t values (2e-9..1e-8 at t >= 4.5e4,
    vs 1e-7..1e-6 legacy; the t < 1e4 remainder is the 2-term O(u^-5) floor).
    """
    n, h = 3, 1e-3
    from math import comb
    val = 0.0j
    for k in range(n + 1):
        val += ((-1.0) ** (n - k)) * comb(n, k) * _psi(p + 1j * k * h)
    return -float(val.imag) / h ** n


def Z_rs(t: float) -> float:
    """Riemann-Siegel Z(t) -- fast engine for t >= ~40 (N = t/(2pi) terms).

    Z(t) = 2 sum_{n=1..N} cos(theta(t) - t ln n)/sqrt(n) + R(t)
    u = (t/2pi)^{1/4}, N = floor(u^2), p = u^2 - N,
    R(t) ~ (-1)^{N-1} [ Psi(p)/u - Psi'''(p)/(96 pi^2 u^3) + O(u^{-5}) ]

    theta = DLMF 25.10.2 (same vartheta as the EM engine).  Validated against
    the EM engine (host) and mpmath dps 30 (container) in day-003; the O(u^-5)
    remainder error is measured, not assumed (see day003_rs_verify.py).
    """
    if t < 40.0:
        raise ValueError("Z_rs not valid below t ~= 40; use Z() there")
    sqrt_t2pi = math.sqrt(t / (2.0 * math.pi))
    N = int(sqrt_t2pi)          # N = floor(sqrt(t/2pi))  (u^2 with u = (t/2pi)^{1/4})
    p = sqrt_t2pi - N
    u = math.sqrt(sqrt_t2pi)    # = (t/2pi)^{1/4}
    th = vartheta(t)
    n = np.arange(1.0, N + 1.0)
    s = 2.0 * float(np.cos(th - t * np.log(n)).dot(1.0 / np.sqrt(n)))
    sign = 1.0 if (N - 1) % 2 == 0 else -1.0
    R = sign * (float(_psi(p).real) / u - _psi_d3(p) / (96.0 * math.pi ** 2 * u ** 3))
    return float(s + R)


def find_zeros(t0: float, t1: float, dt: float = 0.05):
    zs = []
    t = t0
    zprev = Z(t)
    while t <= t1:
        t += dt
        z = Z(t)
        if zprev == 0.0 or zprev * z < 0.0:
            lo, hi, zp = t - dt, t, zprev
            for _ in range(48):
                mid = 0.5 * (lo + hi)
                zm = Z(mid)
                if zp * zm <= 0.0:
                    hi = mid
                else:
                    lo, zp = mid, zm
            t0_ = 0.5 * (lo + hi)
            assert abs(zeta(0.5 + 1j * t0_)) < 1e-7, f"spurious crossing at {t0_}"
            zs.append(t0_)
        zprev = z
    return zs


def selftest(verbose: bool = True) -> bool:
    """Re-run the S1 validation gate fast. Returns True iff GREEN."""
    ok = True
    for label, got, ref in (
        ("zeta(2)", zeta(2.0).real, math.pi ** 2 / 6.0),
        ("zeta(3)", zeta(3.0).real, 1.202056903159594),
        ("zeta(1/2)", zeta(0.5).real, -1.4603545088095868),
    ):
        e = abs(got - ref)
        ok &= e < 1e-9
        if verbose:
            print(f"  {label:10s} err {e:.2e}")
    errs = []
    for sig in (0.2, 0.5, 0.8):
        for tt in (2.0, 25.0, 400.0):
            s = sig + 1j * tt
            errs.append(abs(chi(s) * zeta(1.0 - s) - zeta(s)))
    ok &= max(errs) < 1e-6
    if verbose:
        print(f"  FE check (9 points)  max err {max(errs):.2e}")
    # first zero must be 14.1347251417 (7 digits)
    z1 = find_zeros(13.0, 16.0, dt=0.02)
    ok &= len(z1) == 1 and abs(z1[0] - 14.1347251417) < 1e-8
    if verbose:
        print(f"  first zero {z1:}  (expected 14.1347251417...)")
    if verbose:
        print("  zeta_core self-test " + ("GREEN" if ok else "RED"))
    return ok


if __name__ == "__main__":
    sys.exit(0 if selftest() else 1)
