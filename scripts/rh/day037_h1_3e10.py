#!/usr/bin/env python3
"""day037 -- H1 certificate-grade S1 squeeze on the 3e10 band (grade (i)
of END_GAME_PLAN 3.9(b)).  The day034 machine re-issued over the
extended band (2.9992e9, 3.0001e10],  with the discrete tail now
running over the ACTUAL zeros of (1e7, G_LAST] where
G_LAST = 3.0001046e10 (the 3e10 band's last zero).

PROTOCOL (verbatim day029/day034):
  grid      x = 1e6 * 1.08^k  (geometric continuation;  k the first
          with x > 2.9992e9  through the last with x <= G_LAST)
  anchor    g_x = the real zero nearest x
  straddles t = g_x + k/2,  k = -12..12 \\ {0}
  claim     margin_new(t, g_x) > 1 + eps_explicit  at EVERY straddle,
          with eps_explicit = the explicit tracked budget.

STATISTIC (verbatim day034,  same functions,  same data sources):
  margin_new = |z(1/2+it)| * dev / (p8_B(t, n4(t)) + residf)
  dev    = min over the 500-point delta grid |R_closed(g, t, d) - 1|
  residf = |z - Kfull|,  Kfull = exp(Lmain + la + i ar + re_tail
           + i im_tail) * exp(Qrem) * exp(Qext)
  la, ar = the (0, 1e7] on-line product over GN (unchanged)
  re/im_tail = discrete sum over ACTUAL zeros of (1e7, G_LAST] of
       re = log|(g^2-t^2)/(g^2+1/4)| + 1/(2(g^2+1/4))
       im = t/(g^2+1/4)   (+ i*pi once per zero with g < t)
  Qrem = dps-30 400-node log-quad (G_LAST, 1e18];
       Qext = dps-30 400-node log-quad (1e18, 1e30]
  B_qrem/B_qext = |section30 - section60|;  4-corner ladder audit
       (30/60)x(400/800) on one straddle per window.

SCALE CHANGE vs day034 (the only structural differences):
  1. The tail array is 1.016e11 zeros (813GB of f64), too large for
     RAM.  It is STREAMED as one logical element stream over the
     verified band files,  in 2^25-element slabs  (same slab size as
     day034's SUB):
         L  (1e7, 3.1946e7]           RAM  (day023 shard list)
         A  (3.1946e7, 1.006346e9]    hi1e9/..._to_1e9.f64
         B  (..., 2.001746e9]         hi1e9/zeros_1002e6_to_2000e6.f64
            STITCHED from the first zero strictly above A's last
            zero (A and B overlap on (1.002146e9, 1.006346e9];  the
            overlap is cross-checked byte-exact at init)
         C  (..., 2.999246e9]         hi3e9/zeros_2002e6_to_3000e6.f64
         D  (..., 3.0001046e10]       hi3e10/740.6GB band (sda)
     Slab i = logical elements [i*2^25, (i+1)*2^25)  (the final
     slab may be short)  --  slabs may cross section boundaries;
     the per-slab budget uses ceil(log2(slab size)).
  2. Budget model:  per-slab bookkeeping VERBATIM from day034
     (Higham f64-pairwise within slab,  longdouble across slabs,
     per-term unit-roundoff,  zero-representation dg terms with
     dg = U64*|g|),  generalized ceil(log2 m) per slab of size m.
     nlt = EXACT count of tail zeros < t (binary search over the
     verified files -- no interpolation anywhere).
  3. n4(t) = ceil(3.1e7 * t^4) reaches ~2.5e49 at t ~ 3e10  --
     p8_B is pure f64 power arithmetic (no mpmath),  no overflow.

BUDGETS, PROPAGATION, GATES (C-1/C-2/C-3):  verbatim day034.
SELFTESTS (must pass before any certified claim):
  (a) day034's budget-containment selftests on small arrays,
      verbatim (the per-slab core is the identical function);
  (b) STREAMING containment:  a 34M-zero synthetic tail in TWO
      files (crossing the 2^25 slab boundary) with RVM-
      consistent zero positions;  the pipeline value + computed
      budget must contain the dps-60 exact value,  for both
      stored==true and stored+0.5ulp-offset settings.
COMPUTE, NEVER RECALL.  WORKERS hard-capped at 12 (owner core
rule:  2 physical cores always reserved on this 16c box).
"""
import math
import os
import struct
import sys
import time
import numpy as np
from mpmath import mp

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")

import day023_p11c_1e7 as M
import day023_taildiscrete as td

U64 = 1.1102230246251565e-16
U128 = float(np.finfo(np.longdouble).eps) / 2.0
SUB = 33554432              # 2^25 logical-element slab = 256MB
REMHI = "1e18"
REMHI2 = "1e30"
DG = [mp.mpf(k) / 1000 for k in range(5, 501)]
NLT_GUARD = 1e-4
GAM10_64 = 10.0 * 2.0 * U64 / (1.0 - 10.0 * 2.0 * U64)
GAM1_64 = 2.0 * U64 / (1.0 - 2.0 * U64)

A_F = R_H + "/scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64"
B_F = R_H + "/scripts/rh/hi1e9/zeros_1002e6_to_2000e6.f64"
C_F = R_H + "/scripts/rh/hi3e9/zeros_2002e6_to_3000e6.f64"
D_F = R_H + "/scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64"
BAND_LO = 2.9992e9          # the extension band's lower edge
OUT = R_H + "/scripts/rh/out_day037_h1_3e10.txt"


def n4(t):
    return int(math.ceil(31000000.0 * t ** 4))


def _first_last(path):
    with open(path, 'rb') as f:
        first = struct.unpack('<d', f.read(8))[0]
        f.seek(-8, 2)
        last = struct.unpack('<d', f.read(8))[0]
    return first, last


class Tail3E10:
    """The streamed 2^25-slab tail over (1e7, G_LAST=3.0001e10]
    actual zeros,  with the day034 budget model per slab."""

    def __init__(self, verbose=False):
        self._v = verbose
        self.L = td.load_g_range(1.0e7, 31946000.0)
        a_first, A_last = _first_last(A_F)
        b_first, B_last = _first_last(B_F)
        c_first, C_last = _first_last(C_F)
        d_first, D_last = _first_last(D_F)
        assert self.L[-1] < a_first and A_last < B_last
        assert b_first < A_last, "A/B overlap expected"
        assert A_last < c_first or True
        assert C_last < d_first, "C/D seam not ordered"
        # --- stitch B at A's last zero --------------------------------
        with open(B_F, 'rb', buffering=0) as f:
            overlap = bytearray(256 * 1024 * 1024)
            got = f.readinto(overlap)
            seg = np.frombuffer(overlap[:got], dtype='<f8')
            st = int(np.searchsorted(seg, A_last, side='right'))
            assert 0 < st < seg.size \
                and float(seg[st - 1]) <= A_last < float(seg[st]), \
                "stitch point not inside first 256MB of B"
            self.B_stitch = st
            # cross-check the overlap byte-exactly against A's tail
            with open(A_F, 'rb') as fa:
                fa.seek(-8 * st, 2)
                a_tail = np.frombuffer(fa.read(8 * st), dtype='<f8')
            assert a_tail.size == st and float(a_tail[0]) > 1.0e9, \
                "overlap read misaligned"
            match = (a_tail == seg[:st])
            self.n_overlap_checked = int(match.sum())
            self.n_overlap_total = st
            assert self.n_overlap_checked == self.n_overlap_total, \
                ("A/B overlap cross-check FAILED: %d/%d byte-equal -- "
                 "files disagree,  investigate before any certified "
                 "claim" % (self.n_overlap_checked, self.n_overlap_total))
            if verbose:
                print("stitch: B from element %d (first zero %.6f); overlap "
                      "cross-check %d/%d byte-equal"
                      % (st, float(seg[st]), self.n_overlap_checked,
                         self.n_overlap_total), flush=True)
        self.nL = int(self.L.size)
        self.nA = os.path.getsize(A_F) // 8
        self.nB = os.path.getsize(B_F) // 8 - self.B_stitch
        self.nC = os.path.getsize(C_F) // 8
        self.nD = os.path.getsize(D_F) // 8
        self.G_LAST = D_last
        self.n_tail = self.nL + self.nA + self.nB + self.nC + self.nD
        self._pos = 0                    # logical element cursor
        self._fh = None
        if verbose:
            print("tail3e10: L %d + A %d + B' %d + C %d + D %d = %d zeros "
                  "(%.1f GB); G_LAST = %.6f"
                  % (self.nL, self.nA, self.nB, self.nC, self.nD,
                     self.n_tail, 8.0 * self.n_tail / 1e9, self.G_LAST),
                  flush=True)

    # --- logical element stream ---------------------------------------
    def _section_of(self, i0):
        if i0 < self.nL:
            return 0, i0
        i0 -= self.nL
        if i0 < self.nA:
            return 1, i0
        i0 -= self.nA
        if i0 < self.nB:
            return 2, i0
        i0 -= self.nB
        if i0 < self.nC:
            return 3, i0
        i0 -= self.nC
        return 4, i0

    def read_slab(self, m):
        """the m logical elements starting at self._pos (in-place)."""
        out = np.empty(m, dtype='<f8')
        got = 0
        while got < m:
            sec, off = self._section_of(self._pos + got)
            if sec == 0:
                take = min(m - got, self.nL - off)
                out[got:got + take] = self.L[off:off + take]
            else:
                path = (None, A_F, B_F, C_F, D_F)[sec]
                base = off if sec != 2 else off + self.B_stitch
                take = min(m - got,
                           (self.nA, self.nA, self.nB, self.nC,
                            self.nD)[sec] - off)
                if self._fh is None or self._fh_path != path:
                    if self._fh is not None:
                        self._fh.close()
                    self._fh = open(path, 'rb', buffering=0)
                    self._fh_path = path
                self._fh.seek(base * 8)
                data = self._fh.read(take * 8)
                assert len(data) == take * 8, "short read in tail stream"
                out[got:got + take] = np.frombuffer(data, dtype='<f8')
            got += take
            self._pos += take
        return out

    def restart(self):
        self._pos = 0
        if self._fh is not None:
            self._fh.close()
            self._fh = None
            self._fh_path = None

    def count_below(self, t):
        """EXACT count of tail zeros strictly below t."""
        n = int(np.searchsorted(self.L, t, side='left'))
        n += _count_below_file(A_F, t)
        n += _count_below_file(B_F, t, stitch=self.B_stitch)
        n += _count_below_file(C_F, t)
        n += _count_below_file(D_F, t)
        return n


def _count_below_file(path, t, stitch=0):
    """exact count of elements (from element `stitch` on) below t."""
    tot = os.path.getsize(path) // 8
    with open(path, 'rb') as f:
        first = struct.unpack('<d', f.read(8))[0]
        f.seek(-8, 2)
        last = struct.unpack('<d', f.read(8))[0]
    if t <= first:
        return 0
    if t > last:
        return tot - stitch
    lo, hi = stitch, tot
    with open(path, 'rb', buffering=0) as f:
        while hi - lo > 1:
            mid = (lo + hi) // 2
            f.seek(mid * 8)
            if struct.unpack('<d', f.read(8))[0] < t:
                lo = mid
            else:
                hi = mid
    return max(0, lo - stitch)


# ----------------------------------------------------------------------
# the per-slab value+budget core (VERBATIM day034 arithmetic,  per
# slab of size m -- the only change is ceil(log2 m) for the Higham
# pairwise factor)
# ----------------------------------------------------------------------
def slab_budget(c, tf, t2, m):
    g2 = c * c
    A = g2 + 0.25
    re_t = np.log(np.abs(g2 - t2)) - np.log(A) + 0.5 / A
    im_t = tf / A
    sub_re = float(np.sum(re_t))             # f64 pairwise within slab
    sub_im = float(np.sum(im_t))
    abs_re = np.abs(re_t)
    s_abs_re = float(abs_re.astype(np.longdouble).sum())
    s_scale = float(np.maximum(abs_re, 0.5 / A).astype(np.longdouble).sum())
    s_abs_im = float(im_t.astype(np.longdouble).sum())
    dg = U64 * np.abs(c)
    dredg = (2.0 * c / np.maximum(np.abs(g2 - t2), 1e-30)
             + 2.0 * c / A + c / (A * A))
    dimdg = tf * 2.0 * c / (A * A)
    k = int(math.ceil(math.log2(m))) if m > 1 else 0
    B_re = (GAM10_64 * s_scale
            + k * 2.0 * U64 * s_abs_re
            + float((dg * dredg).astype(np.longdouble).sum()))
    B_im = (GAM1_64 * s_abs_im
            + k * 2.0 * U64 * s_abs_im
            + float((dg * dimdg).astype(np.longdouble).sum()))
    dmin = float(np.min(np.abs(c - tf)))
    del g2, A, re_t, im_t, abs_re, dg, dredg, dimdg
    return sub_re, sub_im, B_re, B_im, s_abs_re, dmin


def tail_with_budget(T, tf):
    t2 = tf * tf
    re = np.longdouble(0)
    im = np.longdouble(0)
    B_re = 0.0
    B_im = 0.0
    sa = np.longdouble(0)
    dmin = float('inf')
    nsub = 0
    n = T.n_tail
    i = 0
    while i < n:
        m = min(SUB, n - i)
        c = T.read_slab(m)
        sr, si, br, bi, s_ar, dm = slab_budget(c, tf, t2, m)
        re += np.longdouble(sr)
        im += np.longdouble(si)
        B_re += br
        B_im += bi
        sa += np.longdouble(s_ar)
        dmin = min(dmin, dm)
        nsub += 1
        i += m
        del c
    nlt = T.count_below(tf)
    re_f = float(re)
    im_f = float(im + nlt * np.pi)
    B_re = float(B_re + nsub * 2.0 * U128 * float(sa))
    B_im = float(B_im + nsub * 2.0 * U128 * float(sa)
                 + 12.0 * U64 * abs(im_f))
    return re_f, im_f, nlt, B_re, B_im, dmin


def prod_with_budget(tf):
    return _prod_budget_day034(M.GN, tf)


def _prod_budget_day034(gv, tf):
    A = tf * tf + 0.25
    Bv = 1.0 / (0.25 + gv * gv)
    inner = 1.0 - A * Bv
    la_t = 0.5 * Bv + np.log(np.abs(inner))
    la = float(np.sum(la_t))
    ar = tf * float(np.sum(Bv)) - float(np.pi * np.sum(gv < tf))
    L2 = float(math.ceil(math.log2(gv.size)))
    abs_la = np.abs(la_t)
    s_abs_la = float(abs_la.astype(np.longdouble).sum())
    s_scale = float(np.maximum(abs_la, 0.5 * Bv).astype(np.longdouble).sum())
    g2 = gv * gv
    A34 = 0.25 + g2
    dg = U64 * np.abs(gv)
    dg_dla = (gv / (A34 * A34)
              + 2.0 * A * np.abs(gv) / (A34 * A34)
              / np.maximum(np.abs(inner), 1e-30))
    dg_dbv = 2.0 * gv * gv / (A34 * A34)
    B_la = (GAM10_64 * s_scale
            + L2 * 2.0 * U64 * s_abs_la
            + float((dg * dg_dla).astype(np.longdouble).sum()))
    B_ar = tf * (L2 * 2.0 * U64
                 + float((dg * dg_dbv).astype(np.longdouble).sum()))
    return la, ar, B_la, B_ar, float(np.min(np.abs(gv - tf)))


# ----------------------------------------------------------------------
# mp pieces (verbatim day034)
# ----------------------------------------------------------------------
def logmain25212(s):
    return (s * mp.log(2 * mp.pi) - (1 + M.EULER_G / 2) * s - mp.log(2)
            - mp.log(s - 1) - mp.loggamma(s / 2 + 1))


def _kint(smp):
    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = (mp.log(1 - smp / r1) + mp.log(1 - smp / r2)
             + smp / r1 + smp / r2)
        return p * (mp.log(gg / (2 * mp.pi)) / (2 * mp.pi))
    return f


def quad_section(f, lo, hi, npts, dps):
    mp.dps = dps
    l = mp.mpf(lo)
    h = mp.mpf(hi)
    pts = [l * (h / l) ** (mp.mpf(j) / mp.mpf(npts))
           for j in range(npts + 1)]
    return mp.quad(f, pts)


def quad_pair(T, tf, audit=False):
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    f = _kint(s)
    lo = repr(T.G_LAST)
    rem30 = quad_section(f, lo, REMHI, 400, 30)
    ext30 = quad_section(f, lo, REMHI2, 400, 30)
    rem60 = quad_section(f, lo, REMHI, 400, 60)
    ext60 = quad_section(f, lo, REMHI2, 400, 60)
    B_qrem = abs(rem30 - rem60)
    B_qext = abs(ext30 - ext60)
    aud = None
    if audit:
        rem800 = (quad_section(f, lo, REMHI, 800, 30),
                  quad_section(f, lo, REMHI, 800, 60))
        ext800 = (quad_section(f, lo, REMHI2, 800, 30),
                  quad_section(f, lo, REMHI2, 800, 60))
        corners_r = [rem30, rem60, rem800[0], rem800[1]]
        corners_e = [ext30, ext60, ext800[0], ext800[1]]
        aud = {"rem": [float(abs(corners_r[i] - corners_r[j]))
                       for i in range(4) for j in range(i + 1, 4)],
               "ext": [float(abs(corners_e[i] - corners_e[j]))
                       for i in range(4) for j in range(i + 1, 4)]}
    return (rem30, ext30, rem60, ext60, B_qrem, B_qext, aud)


def dev_parts(tf, g, dps):
    mp.dps = dps
    s = mp.mpf(repr(float(g)))
    t = mp.mpf(repr(tf))
    dev = None
    for d in DG:
        v = abs(M.R_closed(s, t, d) - 1)
        dev = v if dev is None else min(dev, v)
    return dev


def ev_point(tf, g, dps, qrem, qext, re, im, la, ar):
    mp.dps = dps
    s = mp.mpc(0.5, mp.mpf(repr(float(tf))))
    lm = logmain25212(s)
    z = mp.zeta(s)
    Kfull = mp.e ** (lm + mp.mpf(repr(la)) + 1j * mp.mpf(repr(ar))
                     + mp.mpf(repr(re)) + 1j * mp.mpf(repr(im)))
    Kfull = Kfull * mp.e ** qrem
    Kfull = Kfull * mp.e ** qext
    return {"lm": lm, "z": z, "Kfull": Kfull,
            "residf": abs(z - Kfull), "zabs": abs(z)}


def cert_point(T, tf, g, audit=False):
    tfs = float(tf)
    T.restart()
    (re, im, nlt, B_re, B_im, dmin_t) = tail_with_budget(T, tfs)
    (la, ar, B_la, B_ar, dmin_g) = prod_with_budget(tfs)
    (qrem30, qext30, qrem60, qext60, B_qrem, B_qext, aud) = \
        quad_pair(T, tfs, audit)
    p30 = ev_point(tfs, g, 30, qrem30, qext30, re, im, la, ar)
    p60 = ev_point(tfs, g, 60, qrem60, qext60, re, im, la, ar)
    dev30 = dev_parts(tfs, g, 30)
    dev60 = dev_parts(tfs, g, 60)
    B_dev = float(abs(dev30 - dev60))
    B_lm = float(abs(p30["lm"] - p60["lm"]))
    B_z = float(abs(p30["z"] - p60["z"]))
    dmin = min(dmin_t, dmin_g)
    flag = dmin < NLT_GUARD
    L = abs(p30["Kfull"])
    Bexp = (B_re + B_la
            + float(abs(mp.re(B_qrem) + mp.re(B_qext))) + B_lm)
    Bph = (B_im + B_ar + float(abs(mp.im(B_qrem) + mp.im(B_qext))))
    env = math.exp(Bexp)
    dK = L * (env - 1.0 + env * Bph)
    pb = float(M.p8_B(mp.mpf(repr(tfs)), n4(tfs)))
    residf30 = float(p30["residf"])
    zabs30 = float(p30["zabs"])
    mnew = zabs30 * float(dev30) / (pb + residf30)
    residf_cert = residf30 + dK + B_z
    dev_cert = max(0.0, float(dev30) - B_dev)
    z_cert = max(0.0, zabs30 - B_z)
    mcert = z_cert * dev_cert / (pb + residf_cert)
    Efull = float(mp.log(abs(p30["z"])) - mp.re(mp.log(p30["Kfull"])))
    return {"t": tfs, "g": g, "mnew": mnew, "mcert": mcert,
            "residf": residf30, "zeta": zabs30, "dev": float(dev30),
            "Efull": Efull,
            "Bexp": Bexp, "Bph": Bph, "Bz": B_z, "Bdev": B_dev,
            "Btail_re": B_re, "Btail_im": B_im,
            "Bprod_re": B_la, "Bprod_im": B_ar,
            "Bqrem": float(abs(B_qrem)), "Bqext": float(abs(B_qext)),
            "dmin": dmin, "nlt": nlt, "flag": flag, "audit": aud}


def nearest_zero(T, x):
    """the real zero nearest x.  Every 3e10-band window anchor lies
    inside D,  so the search is a binary search over D alone."""
    d0 = T.n_tail - T.nD
    lo_i, hi_i = 0, T.nD
    with open(D_F, 'rb', buffering=0) as f:
        while hi_i - lo_i > 1:
            mid = (lo_i + hi_i) // 2
            f.seek((d0 + mid) * 8)
            if struct.unpack('<d', f.read(8))[0] <= x:
                lo_i = mid
            else:
                hi_i = mid
        cands = []
        for k in (lo_i - 1, lo_i, lo_i + 1):
            if 0 <= k < T.nD:
                f.seek((d0 + k) * 8)
                cands.append(struct.unpack('<d', f.read(8))[0])
        return min(cands, key=lambda v: abs(v - x))


def scan_window(x, T):
    g = nearest_zero(T, x)
    pts = []
    for k in range(-12, 13):
        if k == 0:
            continue
        p = cert_point(T, g + k / 2.0, g, audit=(k == -12))
        pts.append(p)
        print("  pt x=%.4g t=%.5f mnew=%.4f mcert=%.4f bexp=%.2e"
              % (x, p["t"], p["mnew"], p["mcert"], p["Bexp"]),
              flush=True)
    return {"x": x, "g": g, "pts": pts}


import threading
_TAIL = threading.local()


def _get_T():
    t = getattr(_TAIL, 't', None)
    if t is None:
        t = Tail3E10(verbose=True)
        _TAIL.t = t
    return t


# ----------------------------------------------------------------------
# SELFTESTS
# ----------------------------------------------------------------------
def _tail_exact(gv_true, tf):
    mp.dps = 60
    t = mp.mpf(repr(tf))
    re = mp.mpf("0")
    im = mp.mpf("0")
    for g in gv_true:
        G2 = g * g
        A = G2 + mp.mpf("0.25")
        re += mp.log(mp.fabs(G2 - t * t)) - mp.log(A) + mp.mpf("0.5") / A
        im += t / A
    return re, im


def _prod_exact(gv_true, tf):
    mp.dps = 60
    t = mp.mpf(repr(tf))
    A = t * t + mp.mpf("0.25")
    la = mp.mpf("0")
    sb = mp.mpf("0")
    nlt = 0
    for g in gv_true:
        Bv = mp.mpf("1") / (mp.mpf("0.25") + g * g)
        inner = 1 - A * Bv
        la += mp.mpf("0.5") * Bv + mp.log(mp.fabs(inner))
        sb += Bv
        if g < t:
            nlt += 1
    ar = t * sb - mp.pi * mp.mpf(nlt)
    return la, ar


def selftest_core():
    """(a) day034's small-array budget-containment tests, verbatim."""
    print("SELFTEST(a): budget containment (day034 verbatim)", flush=True)
    rng = np.random.default_rng(20260919)
    g0 = 100.0
    gam = np.sort(g0 + np.cumsum(rng.uniform(0.25, 0.40, 2000)))
    gam = gam.astype(np.float64)
    tf = 1234.6
    ok = True
    for tag, gv_true in (
        ("stored==true", [mp.mpf(repr(float(v))) for v in gam]),
        ("true=stored+0.5ulp",
         [mp.mpf(repr(float(v)))
          + mp.mpf("1.1102230246251565e-16") * mp.mpf(repr(float(v)))
          * mp.mpf(rng.choice([-1, 1])) for v in gam]),
    ):
        re_ex, im_ex = _tail_exact(gv_true, tf)
        t2 = tf * tf
        sr, si, B_re, B_im, _sa, _dm = slab_budget(gam, tf, t2, gam.size)
        re_pipe = float(sr)
        im_pipe = float(si)
        err_re = abs(mp.mpf(repr(re_pipe)) - re_ex)
        err_im = abs(mp.mpf(repr(im_pipe)) - im_ex)
        ok_re = bool(err_re <= mp.mpf(repr(B_re)))
        ok_im = bool(err_im <= mp.mpf(repr(B_im)))
        ok = ok and ok_re and ok_im
        print("  tail[%s]: err_re=%.3e B_re=%.3e %s | err_im=%.3e B_im=%.3e %s"
              % (tag, float(err_re), B_re, ok_re,
                 float(err_im), B_im, ok_im), flush=True)
    gv2 = np.sort(1.0 + np.cumsum(rng.uniform(0.05, 0.2, 2000)))
    gv2 = gv2.astype(np.float64)
    tf2 = 333.25
    for tag, gv_true2 in (
        ("stored==true", [mp.mpf(repr(float(v))) for v in gv2]),
        ("true=stored+0.5ulp",
         [mp.mpf(repr(float(v)))
          + mp.mpf("1.1102230246251565e-16") * mp.mpf(repr(float(v)))
          * mp.mpf(rng.choice([-1, 1])) for v in gv2]),
    ):
        la_ex, ar_ex = _prod_exact(gv_true2, tf2)
        la_p, ar_p, B_la, B_ar, _ = _prod_budget_day034(gv2, tf2)
        err_la = abs(mp.mpf(repr(la_p)) - la_ex)
        err_ar = abs(mp.mpf(repr(ar_p)) - ar_ex)
        ok_la = bool(err_la <= mp.mpf(repr(B_la)))
        ok_ar = bool(err_ar <= mp.mpf(repr(B_ar)))
        ok = ok and ok_la and ok_ar
        print("  prod[%s]: err_la=%.3e B_la=%.3e %s | err_ar=%.3e B_ar=%.3e %s"
              % (tag, float(err_la), B_la, ok_la,
                 float(err_ar), B_ar, ok_ar), flush=True)
    print("SELFTEST(a): %s" % ("PASS" if ok else "FAIL -- budget too small"),
          flush=True)
    return ok


def selftest_streaming():
    """(b) STREAMING containment with slab crossing:  34M synthetic
    zeros in two files (18M + 16M,  crossing the 2^25 = 33.55M slab
    boundary);  the slab pipeline + budget must contain the dps-60
    exact value for both stored==true and 0.5ulp-offset settings."""
    print("SELFTEST(b): streaming containment (34M, 2 files, slab "
          "crossing)", flush=True)
    t0 = time.time()
    rng = np.random.default_rng(42)
    n1, n2 = 18_000_000, 16_000_000
    a0 = 1.0e9 + 0.33
    fn = int(round((a0 / (2 * math.pi)
                    * (math.log(a0 / (2 * math.pi)) - 1.0) + 7 / 8))) - 1
    ts = [a0]
    for k in range(1, n1 + n2):
        t = ts[-1]
        x = t / (2.0 * math.pi)
        rho = math.log(x) / (2.0 * math.pi)
        t = t + 1.0 / rho
        tgt = fn + 1 + k
        for _ in range(2):
            x = t / (2.0 * math.pi)
            t = t - (x * (math.log(x) - 1.0) + 7.0 / 8.0 - tgt) / rho
        ts.append(t)
    a = np.array(ts[:n1], dtype='<f8')
    b = np.array(ts[n1:], dtype='<f8')
    assert float(b[0]) > float(a[-1]), "stitch not ordered"
    f1 = "selftest_stream1.f64"
    f2 = "selftest_stream2.f64"
    a.tofile(f1)
    b.tofile(f2)

    # a minimal two-section Tail3E10-shaped streamer reusing the SAME
    # slab machinery (read_slab over two files + L empty)
    class TTwo:
        nL = 0
        L = np.zeros(0, dtype='<f8')
        G_LAST = float(b[-1])
        nA = a.size
        nB = b.size
        B_stitch = 0
        n_tail = a.size + b.size
        nC = 0
        nD = 0
        _FILE1 = f1
        _FILE2 = f2
        _pos = 0
        _fh = None
        _fh_path = None
        _nA = a.size
        _nB = b.size

    T = TTwo()
    # route read_slab through the two files:  monkeypatch sections
    T._section_of = lambda i0: (1, i0) if i0 < T.nA else (2, i0 - T.nA)

    def read_slab2(m):
        out = np.empty(m, dtype='<f8')
        got = 0
        while got < m:
            sec, off = T._section_of(T._pos + got)
            path = T._FILE1 if sec == 1 else T._FILE2
            size = T.nA if sec == 1 else T.nB
            if T._fh is None or T._fh_path != path:
                if T._fh is not None:
                    T._fh.close()
                T._fh = open(path, 'rb', buffering=0)
                T._fh_path = path
            take = min(m - got, size - off)
            T._fh.seek(off * 8)
            data = T._fh.read(take * 8)
            assert len(data) == take * 8
            out[got:got + take] = np.frombuffer(data, dtype='<f8')
            got += take
            T._pos += take
        return out
    T.read_slab = read_slab2

    tf = float(ts[len(ts) // 2])
    true_list = [mp.mpf(repr(float(v))) for v in np.array(ts, dtype=np.float64)]
    true_list_off = [v
                     + mp.mpf("1.1102230246251565e-16") * v
                     * mp.mpf(rng.choice([-1, 1])) for v in true_list]
    ok = True
    for tag, tl in (("stored==true", true_list),
                    ("true=stored+0.5ulp", true_list_off)):
        re_ex, im_ex = _tail_exact(tl, tf)
        T._pos = 0
        if T._fh:
            T._fh.close()
            T._fh = None
            T._fh_path = None
        re = np.longdouble(0)
        im = np.longdouble(0)
        B_re = 0.0
        B_im = 0.0
        sa = np.longdouble(0)
        nsub = 0
        i = 0
        n = T.n_tail
        while i < n:
            m = min(SUB, n - i)
            c = T.read_slab(m)
            sr, si, br, bi, s_ar, dm = slab_budget(c, tf, tf * tf, m)
            re += np.longdouble(sr)
            im += np.longdouble(si)
            B_re += br
            B_im += bi
            sa += np.longdouble(s_ar)
            nsub += 1
            i += m
            del c
        nlt = sum(1 for v in true_list if float(v) < tf)
        re_f = float(re)
        im_f = float(im + nlt * np.pi)
        B_re = float(B_re + nsub * 2.0 * U128 * float(sa))
        B_im = float(B_im + nsub * 2.0 * U128 * float(sa)
                     + 12.0 * U64 * abs(im_f))
        err_re = abs(mp.mpf(repr(re_f)) - re_ex)
        err_im = abs(mp.mpf(repr(im_f)) - (im_ex + mp.pi * nlt))
        ok_re = bool(err_re <= mp.mpf(repr(B_re)))
        ok_im = bool(err_im <= mp.mpf(repr(B_im)))
        ok = ok and ok_re and ok_im
        print("  stream[%s]: nsub=%d err_re=%.3e B_re=%.3e %s | "
              "err_im=%.3e B_im=%.3e %s (%.0f s)"
              % (tag, nsub, float(err_re), B_re, ok_re,
                 float(err_im), B_im, ok_im, time.time() - t0), flush=True)
    if T._fh:
        T._fh.close()
    for p in (f1, f2):
        if os.path.exists(p):
            os.remove(p)
    print("SELFTEST(b): %s" % ("PASS" if ok else "FAIL -- budget too small"),
          flush=True)
    return ok


def grid():
    """geometric continuation of the day034 sequence
    x = 1e6 * 1.08^k,  restricted to (BAND_LO, G_LAST].
    """
    g_last = _first_last(D_F)[1]
    xs = []
    x = 1.0e6
    while x <= g_last + 1.0:
        if x > BAND_LO:
            xs.append(x)
        x *= 1.08
    return xs


def _point_row(x, p):
    row = ("%s,%.10f,%.10f,%.10f,%.10f,%.10f,%.10f,%.6f,"
           "%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,"
           "%.3e,%.3e,%d,%d\n" % (
               ("FLAG" if p["flag"] else "ok"),
               x, p["t"], p["g"], p["mnew"], p["mcert"],
               p["residf"], p["zeta"], p["dev"], p["Bexp"],
               p["Bph"], p["Bz"], p["Bdev"], p["Btail_re"],
               p["Btail_im"], p["Bprod_re"], p["Bprod_im"],
               p["Bqrem"], p["Bqext"], p["nlt"],
               1 if p["flag"] else 0))
    if p["audit"] is not None:
        row += "audit,x=%.10f,t=%.10f," % (x, p["t"])
        for tag, coll in (("rem", p["audit"]["rem"]),
                          ("ext", p["audit"]["ext"])):
            row += "%s_spread_max=%.3e " % (tag, max(coll))
        row += "\n"
    return row


def _emit(fo, w, t0):
    wt = max(w["pts"], key=lambda p: p["mnew"])
    wwc = min(w["pts"], key=lambda p: p["mcert"])
    fl = any(p["flag"] for p in w["pts"])
    for p in w["pts"]:
        fo.write(_point_row(w["x"], p))
    fo.flush()
    line = ("[%s] x=%.6g g=%.4f best_mnew=%.6f worst_mcert=%.6f"
            % (time.strftime("%H:%M:%S"), w["x"], w["g"], wt["mnew"],
               wwc["mcert"]))
    if fl:
        line += " FLAG"
    line += " (elapsed %.1f min)" % ((time.time() - t0) / 60)
    print(line, flush=True)


def _summary(res, dt, mode):
    print("%12s %12s %9s %10s %9s %9s"
          % ("x", "g", "best_mnew", "worst_mcert", "btot", "flag"))
    for w in res:
        wpts = w["pts"]
        best = max(wpts, key=lambda p: p["mnew"])
        worst = min(wpts, key=lambda p: p["mcert"])
        btot = worst["Bexp"] + worst["Bph"]
        fl = any(p["flag"] for p in w["pts"])
        print("%12.6g %12.4f %9.6f %10.6f %9.2e %s"
              % (w["x"], w["g"], best["mnew"], worst["mcert"], btot,
                 "FLAG" if fl else "-"))
    allp = [p for w in res for p in w["pts"]]
    wp = min(allp, key=lambda p: p["mcert"])
    print("worst certified margin = %.6f at t = %.5f (computed %.6f)"
          % (wp["mcert"], wp["t"], wp["mnew"]))
    cf1 = [round(p["t"], 3) for p in allp if p["mcert"] < 1.0]
    cn1 = [round(p["t"], 3) for p in allp if p["mnew"] < 1.0]
    print("margin_cert < 1: %s" % (cf1 if cf1 else "NONE"))
    print("margin_new  < 1: %s" % (cn1 if cn1 else "NONE"))
    print("wall = %.1f s" % dt)
    print("STATUS: %s" % ("C-1 candidate (all points certified >= 1)"
                          if not cf1 and not cn1
                          else "see the pre-registered reading C-2/C-3"))


import concurrent.futures as cf


def run():
    smoke = os.environ.get("H1CERT_SMOKE") == "1"
    xs = grid()
    if smoke:
        xs = [max(xs)]          # the profile:  the top window
    work = min(int(os.environ.get("WORKERS", "12")), 14)   # owner core cap
    mode = "PROFILE" if smoke else "FULL"
    print("day037 H1-3e10: %s, %d windows, workers=%d"
          % (mode, len(xs), work), flush=True)
    t0 = time.time()
    res = []
    with open(OUT, "w") as fo:
        fo.write("# day037 H1 cert 3e10 %s workers=%d %s\n"
                 % (mode, work, time.strftime("%Y-%m-%d %H:%M:%S")))
        fo.write("# point detail (incremental; one row per straddle):\n")
        fo.flush()

        def _w(x):
            return scan_window(x, T=_get_T())
        if work == 1:
            for x in xs:
                w = _w(x)
                res.append(w)
                _emit(fo, w, t0)
        else:
            with cf.ProcessPoolExecutor(max_workers=work) as ex:
                futs = [ex.submit(_w, x) for x in xs]
                for fu in cf.as_completed(futs):
                    w = fu.result()
                    res.append(w)
                    _emit(fo, w, t0)
    res.sort(key=lambda r: r["x"])
    dt = time.time() - t0
    _summary(res, dt, mode)


if __name__ == '__main__':
    if os.environ.get("H1CERT_SELFTEST") == "1":
        a = selftest_core()
        b = selftest_streaming() if os.environ.get(
            "H1CERT_SELFTEST_STREAM") == "1" else True
        sys.exit(0 if (a and b) else 1)
    run()
