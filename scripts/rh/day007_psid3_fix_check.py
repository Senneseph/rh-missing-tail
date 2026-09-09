# day007: psi''' fix check (docker, mpmath dps oracle; pure python)
#
# Finding (2026-09-09, while porting Z_rs to TS): the verified engine's
# zero locations at small t are offset by ~1e-4. Root cause: _psi_d3
# returns RE[alternating sum]/h^3 = an O(h*psi'''') near-zero residual,
# while the RS R term needs the TRUE psi'''(p), which the complex-step
# formula puts in the IMAGINARY part:
#     S = sum_{k=0}^3 (-1)^(3-k) C(3,k) psi(p + i k h)
#       = (i h)^3 psi'''(p) - (3/2) h^4 psi''''(p) + (5/4) i h^5 psi'''''(p) + ...
#   Re[S] = -1.5 h^4 psi''''(p) + O(h^6)     <- legacy engine returns Re[S]/h^3
#   Im[S] = -h^3 psi'''(p) + O(h^5)          <- true derivative: -Im[S]/h^3
#
# The engine pieces below are VERBATIM copies from zeta_core.py
# (np.log -> cmath.log, mathematically identical) so the docker image
# (no numpy) can run them; the dps oracle is mpmath.

import cmath
import math
import sys

import mpmath as mp

mp.dps = 45
TWO_PI = 2 * math.pi

# --- verbatim from zeta_core.py ---
_LANCZOS = (
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7,
)


def _cloggamma_base(z: complex) -> complex:
    z = z - 1.0
    x = _LANCZOS[0]
    for i in range(1, len(_LANCZOS)):
        x += _LANCZOS[i] / (z + i)
    t = z + 7.5
    return 0.5 * math.log(2.0 * math.pi) + (z + 0.5) * cmath.log(t) - t + cmath.log(x)


def cloggamma(z: complex) -> complex:
    z = complex(z)
    ns = max(0, int(math.ceil(50.0 - z.real)))
    out = _cloggamma_base(z + ns)
    for i in range(ns):
        out -= cmath.log(complex(z) + i)
    return out


def vartheta(t: float) -> float:
    if t == 0.0:
        return 0.0
    cg = cloggamma(0.25 + 0.5j * t)
    return cg.imag - 0.5 * t * math.log(math.pi)


def _psi(p: float) -> float:
    return cmath.cos(2.0 * math.pi * (p * p - p - 0.0625)) / cmath.cos(2.0 * math.pi * p)


def _psi_d3_legacy(p: float) -> float:
    n, h = 3, 1e-3
    val = 0.0j
    for k in range(n + 1):
        val += ((-1.0) ** (n - k)) * math.comb(n, k) * _psi(p + 1j * k * h)
    return float(val.real) / h ** n


# --- the fix: true psi'''(p) = -Im[S]/h^3 ---
def _psi_d3_fixed(p: float) -> float:
    n, h = 3, 1e-3
    val = 0.0j
    for k in range(n + 1):
        val += ((-1.0) ** (n - k)) * math.comb(n, k) * _psi(p + 1j * k * h)
    return -float(val.imag) / h ** n


def z_rs_variant(t, use_fix):
    sq = math.sqrt(t / TWO_PI)
    N = int(math.floor(sq))
    p = sq - N
    u = math.sqrt(sq)
    th = vartheta(t)
    s = 0.0
    for k in range(1, N + 1):
        s += math.cos(th - t * math.log(k)) / math.sqrt(k)
    d3 = (_psi_d3_fixed if use_fix else _psi_d3_legacy)(p)
    sign = 1.0 if (N - 1) % 2 == 0 else -1.0
    return 2.0 * s + sign * (float(_psi(p).real) / u - d3 / (96.0 * math.pi ** 2 * u ** 3))


def z_mp(t):
    th = float(mp.im(mp.loggamma(0.25 + 0.5j * t)) - 0.5 * t * mp.ln(mp.pi))
    return float(mp.re(mp.e ** (1j * th) * mp.zeta(0.5 + 1j * t)))


t7 = 40.91871901214749130
pts = [t7, 50.0, 123.456, 1000.0, 45374.03, 138065.0, 500000.0, 567000.0]
print("t=%12.5f   |Z_legacy - Z_mp|   |Z_fixed - Z_mp|   Z_mp(dps)")
for t in pts:
    zm = z_mp(t)
    print(
        "%14.5f   %14.3e   %14.3e   %.12f"
        % (t, abs(z_rs_variant(t, False) - zm), abs(z_rs_variant(t, True) - zm), zm)
    )

print()
print("p        psi'''(mpmath)    legacy Re/h^3      fixed -Im/h^3")
for t in (40.9187, 1000.0, 500000.0):
    sq = math.sqrt(t / TWO_PI)
    p = sq - math.floor(sq)
    d3 = mp.diff(
        lambda x: mp.cos(2 * mp.pi * (x ** 2 - x - mp.mpf(1) / 16)) / mp.cos(2 * mp.pi * x),
        mp.mpf(p),
        3,
    )
    print("%.4f   %18.6e   %14.3e   %14.3e" % (p, float(d3), _psi_d3_legacy(p), _psi_d3_fixed(p)))
