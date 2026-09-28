#!/usr/bin/env python3
"""day047 -- the SIGNED splice defect on the 3e10 D band (A1 data side).

day029_dcheck_splice generalised to the D band:
    G1 = first zero of hi3e10/zeros_2999e6_to_30000e6.f64
         = 2999246000.182257        (2.999246e9)
    G2 = 3.0e10                     (pinned N(G2) = 101635962231)
    Z  = the zeros of (G1, G2]  --  sparse file, stream-only.

For every probe height t the quantity
    D(t) =  sum_{G1 < gam <= G2} p(gam;t)  -  int_{G1}^{G2} p(g;t) rho(g) dg
with p the kernel's per-zero pair-log factor in the SAME principal
branch as the W2 wire (re = log|g^2-t^2| - log(g^2+1/4) + 1/(2A),
im = t/A - pi for gam < t;  t/A for gam > t):

  * is EXACT for t > G2 (the (G2, ...] piece cancels identically);
  * holds up to an O(1e-6) grid difference on the far piece for
    t in (G1, G2] (day029 docstring, same construction here).

Why this number is the A1 data side (E15/E16 context):
  W = S1Sum - RSum on the band splice is the SIGNED walk defect the
  [S1] wire consumes.  The day029 splice (1.006e9, 2.002e9] showed
  |D| = O(1) and decaying in t (2.65 -> 0.595 from 1.5e9 to 1e10).
  This run measures the SAME object on the 3e10-band splice at
  heights spanning the band, including the worst H1 drift straddle
  (x = 3.232171e9, k = -12, t = 3232170970.112195, split mode).
  Reading: |D| ~ O(1) everywhere  ->  the signed-defect data story
  (the constant the A1 O(1) theorem must have) completes to 3e10.
          |D| >> O(1) somewhere  ->  a discovery (refutation signal
  at scale) to chase immediately.

No GPU, no band alteration, stream-only (file is r-x).  One core.
"""
import mpmath as mpm
mpm.mp.dps = 30
import time
import math
import sys
import struct
import numpy as np

D_FILE = "hi3e10/zeros_2999e6_to_30000e6.f64"
G2 = 3.0e10
CH = 33_000_000
EPS = mpm.mpf("1e-8")
NPTS = 400

f = open(D_FILE, "rb")
FBYTES = f.seek(0, 2)
NZ = FBYTES // 8
f.seek(0)
G1 = struct.unpack("<d", f.read(8))[0]
print("D band: G1 = %.13f   G2 = %.3e   Nz(file) = %d" % (G1, G2, NZ), flush=True)


def zfile_at(i):
    f.seek(8 * i)
    return struct.unpack("<d", f.read(8))[0]


def count_le(v):
    """number of file zeros <= v (binary search over the mmap)."""
    lo, hi = 0, NZ
    while lo < hi:
        m = (lo + hi) // 2
        if zfile_at(m) <= v:
            lo = m + 1
        else:
            hi = m
    return lo


N_SLICE = count_le(G2)
print("zeros in (G1, G2]: %d   (boundary check: last = %.6f, 1st above = %.6f)"
      % (N_SLICE, zfile_at(N_SLICE - 1), zfile_at(N_SLICE)), flush=True)
assert zfile_at(N_SLICE - 1) <= G2 < zfile_at(N_SLICE)


def f_int(smp, gg):
    r1 = mpm.mpc(0.5, gg)
    r2 = mpm.mpc(0.5, -gg)
    p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
         + smp/r1 + smp/r2)
    return p * (mpm.log(gg/(2*mpm.pi))/(2*mpm.pi))


def geo(lo, hi, n):
    return [lo * (hi/lo)**(mpm.mpf(j)/mpm.mpf(n)) for j in range(n + 1)]


def sing_safe_int(smp, a, b, t):
    """mpmath quad of f_int over [a, b]; v3 singularity-aware when
    t in (a, b): shifted split + O(eps^3) annulus.  Real-path
    cross-check on the integral side.  (Copied verbatim from
    day029 -- same construction, same branch.)"""
    a = mpm.mpf(a); b = mpm.mpf(b)
    tc = mpm.mpf(t)
    if not (a + EPS < tc - EPS < b):
        pts = geo(a, b, NPTS)
        c = mpm.quad(lambda gg: f_int(smp, gg), pts)
        r = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), pts)
        return c, float(r)
    rho_t = mpm.log(tc/(2*mpm.pi))/(2*mpm.pi)
    r1t = mpm.mpc(0.5, tc)
    r2t = mpm.mpc(0.5, -tc)
    base = mpm.log(1 - smp/r2t) + smp/r1t + smp/r2t
    half = EPS * rho_t * (mpm.log(EPS) - 1)
    annL = half + EPS * rho_t * (mpm.log(-1j/r1t) + base)
    annR = half + EPS * rho_t * (mpm.log(1j/r1t) + base)
    gL = geo(a, tc - EPS, NPTS)
    gR = geo(tc + EPS, b, NPTS)
    cL = mpm.quad(lambda gg: f_int(smp, gg), gL)
    cR = mpm.quad(lambda gg: f_int(smp, gg), gR)
    rL = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gL)
    rR = mpm.quad(lambda gg: mpm.re(f_int(smp, gg)), gR)
    c = cL + cR + annL + annR
    r = rL + rR + float(mpm.re(annL + annR))
    return c, float(r)


def pair_fsum(t):
    """fsum of the pairlog terms over (G1, G2]; the branch (n*pi)
    term is exact arithmetic: nlt = count of slice zeros < t."""
    t2 = t * t
    re_parts, im_parts = [], []
    for i in range(0, N_SLICE, CH):
        nb = min(CH, N_SLICE - i)
        f.seek(8 * i)
        c = np.frombuffer(f.read(8 * nb), dtype="<f8")
        g2 = c * c
        A = g2 + 0.25
        re_parts.append(math.fsum(np.asarray(
            np.log(np.abs(g2 - t2)) - np.log(A) + 0.5/A, dtype=np.float64)))
        im_parts.append(math.fsum(np.asarray(t/A, dtype=np.float64)))
    re_tot = math.fsum(re_parts)
    im_tot = math.fsum(im_parts)
    nlt = int(N_SLICE) if t > G2 else zcount_lt(t)
    im_tot = im_tot - nlt * math.pi
    return re_tot, im_tot, nlt


def zcount_lt(v):
    lo, hi = 0, N_SLICE
    while lo < hi:
        m = (lo + hi) // 2
        if zfile_at(m) < v:
            lo = m + 1
        else:
            hi = m
    return lo


def mpmath_sum_check(t, m=200_000):
    smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
    re = mpm.mpf(0); im = mpm.mpf(0)
    for i in range(m):
        g = mpm.mpf(repr(zfile_at(i)))
        r1 = mpm.mpc(0.5, g)
        r2 = mpm.mpc(0.5, -g)
        p = (mpm.log(1 - smp/r1) + mpm.log(1 - smp/r2)
             + smp/r1 + smp/r2)
        re += mpm.re(p); im += mpm.im(p)
    return float(re), float(im)


if __name__ == "__main__":
    t0 = time.time()
    print("day047 D-band splice signed-defect run  (mpmath %s, dps-30)"
          % mpm.__version__, flush=True)

    print("\nSUM-SIDE precision check: fsum vs mpmath-dps-30 direct, "
          "first 200000 slice zeros, t = 1.5e10", flush=True)
    tm = mpmath_sum_check(1.5e10)
    f.seek(0)
    c0 = np.frombuffer(f.read(8 * 200_000), dtype="<f8")
    A0 = c0 * c0 + 0.25
    re0 = math.fsum(np.asarray(
        np.log(np.abs(c0*c0 - 2.25e20)) - np.log(A0) + 0.5/A0, dtype=np.float64))
    im0 = math.fsum(np.asarray(1.5e10/A0, dtype=np.float64)) - 200_000 * math.pi
    print("  mpmath re/im : %.12f  %.12f" % tm, flush=True)
    print("  fsum   re/im : %.12f  %.12f" % (re0, im0), flush=True)
    print("  |d|          : %.2e  %.2e   (< 1e-6 required)"
          % (abs(tm[0] - re0), abs(tm[1] - im0)), flush=True)
    assert abs(tm[0] - re0) < 1e-6 and abs(tm[1] - im0) < 1e-6
    print("  PASS  (%.0fs)" % (time.time() - t0), flush=True)

    HEIGHTS = [
        3232170970.112195,   # worst H1 drift straddle (x=3.23e9,k=-12), split
        1.0e10, 1.5e10, 2.5e10, 2.99e10,
    ]
    print("\nD(t) = sum_{(G1, G2]} p  -  int_{G1}^{G2} p rho   "
          "(|D| ~ O(1) => signed defect data story holds to 3e10)", flush=True)
    print("t          mode    D_re           D_im          |D|        "
          "quad d(re)", flush=True)
    for t in HEIGHTS:
        t1 = time.time()
        sre, sim, nlt = pair_fsum(t)
        smp = mpm.mpc(0.5, mpm.mpf(repr(t)))
        ic, irr = sing_safe_int(smp, mpm.mpf(repr(G1)), mpm.mpf(repr(G2)), t)
        D_re = sre - float(mpm.re(ic))
        D_im = sim - float(mpm.im(ic))
        dquad = abs(float(mpm.re(ic)) - irr)
        mode = "split" if G1 < t < G2 else "plain"
        print("%.12g %-7s %15.9f %15.9f %12.3e %10.2e   nlt=%d  (%.0fs)"
              % (t, mode, D_re, D_im, math.hypot(D_re, D_im), dquad,
                 nlt, time.time() - t1), flush=True)
    print("\nDONE (%.0fs total)" % (time.time() - t0), flush=True)
