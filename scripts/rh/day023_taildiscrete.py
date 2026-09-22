# Day-023 — corrected kernel TAIL: exact DISCRETE sum over actual zeros
# (the product is a sum over zeros, not a density integral).
#   tail(s) = Sum_{g in (1e7, 3e7]} pairfactor(g, s)  [discrete, float64]
#           + integral over (3e7, 1e9) of pairlog . density  [mp quad]
#           + bound on (1e9, inf)
# For s = 1/2 + i t  (t << g in this range) the per-zero PAIR factor is
#   (1 - s/r1)(1 - s/r2) e^{s/r1 + s/r2} = ((g^2 - t^2)/(g^2 + 1/4)) * e^{s/(g^2+1/4)}
# (exact; real algebraic part x positive for g > t, so the log branch is clean).
# Validation: s0 = -2 (real, trivial pin): per-pair = log1p(6/A) - 2/A and the
# (1e7, 3e7] sum must reproduce 6.251993491674e-07 (day023_tail_arbiter.py).
import struct
import os
import numpy as np
from mpmath import mp

# shard directory: /tmp is wiped on reboot (the day-045 incident);
# the repo copy lives in scripts/rh/lshards/ (md5-verified pins in
# lshards/md5.txt from beta.lmfdb.org/data/riemann-zeta-zeros/).
SHARDS_DIR = os.environ.get("ZETA_SHARDS_DIR", "/tmp/zeta-dl/shards")

LO, HI, REM_HI = 1.0e7, 3.0e7, 1.0e12
PI = mp.pi


def load_g_range(lo, hi):
    files = ["zeros_8846000.dat", "zeros_10946000.dat", "zeros_13046000.dat",
             "zeros_15146000.dat", "zeros_17246000.dat", "zeros_19346000.dat",
             "zeros_21446000.dat", "zeros_23546000.dat", "zeros_25646000.dat",
             "zeros_27746000.dat", "zeros_29846000.dat"]
    E19 = mp.mpf(1)/(2**101)
    out = []
    for fn in files:
        d = open(f"{SHARDS_DIR}/{fn}", "rb").read()
        (nblk,) = struct.unpack_from("Q", d, 0)
        off = 8
        for _ in range(nblk):
            t0, t1, Nt0, Nt1 = struct.unpack_from("<ddQQ", d, off)
            off += 32
            if t1 <= lo:
                off += 13*(Nt1-Nt0)
                continue
            if t0 >= hi:
                break
            cnt = Nt1 - Nt0
            buf = d[off:off+13*cnt]
            off += 13*cnt
            Z = 0
            for k in range(cnt):
                b = buf[13*k:13*k+13]
                Z += (b[12] << 96) | (int.from_bytes(b[8:12], "little") << 64) \
                       | int.from_bytes(b[0:8], "little")
                v = t0 + float(Z * E19)
                if lo < v < hi:
                    out.append(v)
    return np.array(out)


def _pairlog_complex(t, g):
    """(re, im) vectorized part-log of the discrete tail for s = 1/2 + i t.
    float64 t scalar, float64 g array.  Per-pair factor = ((g^2 - t^2)/(g^2+1/4))
    * e^{s/(g^2+1/4)}: for g < t the algebraic factor is NEGATIVE -> the log
    contributes +i*pi ONCE PER SUCH ZERO (branch; matches the module product's
    -pi*count(g<t) mod 2pi).  NOTE (day-023): the per-zero phase + pi*nlt was
    BROADCAST into every element before the sum (+47.5M x pi*nlt garbage) --
    it must be added to the SUM, not the array.  For t < 1e7 (all earlier
    pins) nlt = 0 and the bug was invisible; it fires for t > 1e7."""
    A = g*g + 0.25
    ratio = np.abs(g*g - t*t)/A
    nlt = int(np.sum(g < t))
    nz = int(np.sum(g == t))
    if nz > 0:
        # POLE COLUMN: the factor ((g^2-t^2)/(g^2+1/4)) is EXACTLY 0 -> the
        # tail product is 0 -> log = -inf (correct, not an error).
        return float('-inf'), float(np.sum(t/A, dtype=np.longdouble)) + nlt * np.pi
    re = float(np.sum(np.log(ratio) + 0.5/A, dtype=np.longdouble))
    im = float(np.sum(t/A, dtype=np.longdouble)) + nlt * np.pi
    return re, im


def _pairlog_s0minus2(g):
    A = g*g + 0.25
    return np.log1p(6.0/A) - 2.0/A


def tail_discrete(s, verbose=False):
    """s = mpc(1/2, t) (critical line) or mpc(-2, 0) (pin validation)."""
    g = _G_CACHE
    if s == mp.mpc(-2, 0):
        terms = _pairlog_s0minus2(g)
        disc = float(np.sum(terms, dtype=np.longdouble))
    else:
        t = float(mp.im(s))
        re, im = _pairlog_complex(t, g)
        disc = re + 1j*im
    mp.dps = 30
    smp = s if isinstance(s, mp.mpc) else mp.mpc(s)

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = mp.log(1 - smp/r1) + mp.log(1 - smp/r2) + smp/r1 + smp/r2
        return p*(mp.log(gg/(2*PI))/(2*PI))
    import os
    remhi = mp.mpf(os.environ.get("TAIL_REM_HI", "1e12"))
    npts = int(os.environ.get("TAIL_REM_NPTS", "80"))
    t = abs(mp.im(smp))
    pts = [HI * (remhi/HI)**(mp.mpf(k)/npts) for k in range(npts+1)]
    if HI < t < remhi:
        # mpmath docs (integration.html): 'Both tanh-sinh and Gauss-
        # Legendre ... Neither copes well with mid-interval singularities.
        # The best solution is to split the integral into parts.'  At
        # gg = t one log(1 - s/rho) factor is log(0) (the zero under t
        # sits inside the density quad range for t > 3e7): split there.
        pts.append(mp.mpf(repr(float(t))))
        pts.sort()
    rem = mp.quad(f, pts)
    # analytic (remhi, inf) t^2-part bound: t^2 (ln(B/2pi)+1)/(2pi B) at B = remhi
    Bb = remhi
    bound = mp.mpf(t)*mp.mpf(t)*(mp.log(Bb/(2*PI))+1)/(2*PI*Bb)
    if verbose:
        print("  discrete (1e7,3e7] = %.12e  rem(3e7,1e12) = %s  bound = %.1e"
              % ((disc.real if isinstance(disc, complex) else disc),
                 mp.nstr(rem, 10), bound))
    return disc, rem, bound


_G_CACHE = None


def build_cache():
    global _G_CACHE
    _G_CACHE = load_g_range(LO, HI)
    print("cached zeros (1e7, 3e7]:", _G_CACHE.size)


if __name__ == "__main__":
    build_cache()
    v, rem, b = tail_discrete(mp.mpc(-2, 0), verbose=True)
    tot = v + float(mp.re(rem))
    print("tail(-2) total = %.15e   (arbiter: 9.515482783825e-07)" % tot)
    v2, rem2, b2 = tail_discrete(mp.mpc(0.5, "5004.7343"), verbose=True)
    print("tail(5004.7343) = %s + %s" % (v2, mp.nstr(rem2, 10)))
