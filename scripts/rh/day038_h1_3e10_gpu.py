#!/usr/bin/env python3
"""day038 -- H1 certificate-grade S1 squeeze on the 3e10 band (grade (i)),
iGPU (CuPy/ROCm) engine.  A fork of day037 with ONE change:  the
per-slab elementwise arithmetic + its sums run on the iGPU  (every
other protocol,  statistic,  bookkeeping item and gate is verbatim).

GPU SLAB CERTIFICATE (the only new mathematical content):
  The day034/037 per-slab budget has three error sources;  the
  POSITIVE-term references (s_scale,  s_abs_re,  s_abs_im,  sum
  dg*|d(re)/d(g)|,  sum dg*|d(im)/d(g)|) were longdouble-exact in
  day037.  Here they are f64 sums computed on the GPU and inflated
  to certified upper bounds via  S_cert = S_f64*(1 + 2*(m-1)*U64),
   >= the longdouble-exact reference  (Higham gamma_(m-1)  on an
  f64 sum of non-negative terms).  Hence  B_re/B_im  (day038)
  >= B_re/B_im  (day037)  at identical inputs:  the certificate is
  relaxed,  never tightened.  The slab VALUES are the GPU's own f64
  tree sums;  containment against the dps-60 exact value is
  re-verified by the (a-gpu)/(b-gpu) selftests  (containment is
  the certificate;  CPU-equivalence is reported,  not required).
  The extra_idx (A/B overlap rounding) patch stays host-side:
  152 elements,  exact f64 arithmetic,  verbatim formulas.

RUNTIME:  this file runs under the cupy venv  (~/venvs/cupy,
cupy_py wrapper:  LD_LIBRARY_PATH=/opt/rocm/lib  export required
before python starts;  mpmath 1.4.1 pinned in the venv).
H1GPU=0  forces the day037 CPU slab (A/B comparison mode).

PROTOCOL,  STATISTIC,  BUDGETS,  GATES:  as day037  (unchanged).

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
COMPUTE, NEVER RECALL.  WORKERS hard-capped at 14 (owner core
rule:  2 physical cores always reserved on this 16c box),
then clamped DOWN by the memguard to min(RAM-derived count,
GPU queue client budget minus Xorg = 10 workers by default)
"""
import math
import os
import struct
import sys
import threading
import time
import numpy as np
from mpmath import mp

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")

import day023_p11c_1e7 as M
import day023_taildiscrete as td

import cupy as cp

U64 = 1.1102230246251565e-16
U128 = float(np.finfo(np.longdouble).eps) / 2.0
THREADS = max(int(os.environ.get("H1_THREADS", "8")), 1)


def _slab_bounds(nslabs, nt):
    """tile  [0,  nslabs)  into  nt  disjoint  contiguous  chunks
    (the  first  `rem`  chunks  carry  one  extra  slab)."""
    base, rem = divmod(nslabs, nt)
    out, start = [], 0
    for t in range(nt):
        end = start + base + (1 if t < rem else 0)
        out.append((start, end))
        start = end
    return out


SUB = 33554432              # 2^25 logical-element slab = 256MB
REMHI = "1e18"
REMHI2 = "1e30"
DG = [mp.mpf(k) / 1000 for k in range(5, 501)]
NLT_GUARD = 1e-4
USE_GPU = os.environ.get("H1GPU", "1") == "1"
# THREADS = the owner's Strix-Halo model:  40 CUs,  6  reserved
# ->  34  usable;  the parallel  unit  is  the  THREAD  (a  process
# is  just  a  HIP  context,  and  contexts  are  capped  by  the
# 8  SDMA  queues,  NOT  by  CUs).  Production:  4  contexts  x
# 8  threads  =  32  slab  threads,  ~2.9GiB/thread  inside  the
# 100Gi  program  budget.
GAM10_64 = 10.0 * 2.0 * U64 / (1.0 - 10.0 * 2.0 * U64)
GAM1_64 = 2.0 * U64 / (1.0 - 2.0 * U64)

A_F = R_H + "/scripts/rh/hi1e9/zeros_hi31946e6_to_1e9.f64"
B_F = R_H + "/scripts/rh/hi1e9/zeros_1002e6_to_2000e6.f64"
C_F = R_H + "/scripts/rh/hi3e9/zeros_2002e6_to_3000e6.f64"
D_F = R_H + "/scripts/rh/hi3e10/zeros_2999e6_to_30000e6.f64"
BAND_LO = 2.9992e9          # the extension band's lower edge
OUT = R_H + "/scripts/rh/out_day038_h1_3e10_gpu.txt"
# FULL-mode  outputs  (separate  from  the  profile  file,  which
# a  running  profile  process  keeps  open):
OUT_FULL = R_H + "/scripts/rh/out_day038_full_pts.txt"
CKPT_DIR = R_H + "/scripts/rh/ckpt_h1_3e10"
N_PTS_PER_WIN = 24
K_LIST = [k for k in range(-12, 13) if k != 0]


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
        assert B_last < c_first, "B'/C seam not ordered"
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
            nmis = st - self.n_overlap_checked
            # Rounding-level disagreement (|A-B| <= 1 ulp) is certifiable:
            # the stream takes the overlap from A;  each zero whose A-value
            # disagrees with B's by <= 1 ulp is certified with dg x3
            # (|delta| <= 1.5 ulp of the true zero).  Anything beyond the
            # rounding level aborts the run.
            if nmis:
                jmis = np.nonzero(~match)[0]
                d = np.abs(a_tail[jmis] - seg[:st][jmis])
                ulp = np.spacing(a_tail[jmis])
                assert bool((d <= ulp).all()), \
                    ("A/B overlap disagreement beyond rounding level: "
                     "max |A-B| = %.3e ulp -- abort, investigate"
                     % float((d / ulp).max()))
                nA_tot = os.path.getsize(A_F) // 8
                self.extra_idx = np.sort(jmis.astype(np.int64)
                                         + (self.L.size + nA_tot - st))
                if verbose:
                    print("overlap: %d/%d zeros differ by <=%.2f ulp "
                          "(last byte,  rounding-level) --  those indices "
                          "certified with dg x3"
                          % (nmis, st, float((d / ulp).max())), flush=True)
            else:
                self.extra_idx = np.zeros(0, dtype=np.int64)
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
        """the m logical elements starting at self._pos (in-place).
        The cursor advances EXACTLY m per call  (a stale double
        advance per chunk was found by the streaming selftest:  it
        dropped the first `take` zeros of the next section at every
        seam-crossing slab and appended `take` strays from the far
        end)."""
        out = np.empty(m, dtype='<f8')
        base = self._pos
        got = 0
        while got < m:
            sec, off = self._section_of(base + got)
            if sec == 0:
                take = min(m - got, self.nL - off)
                out[got:got + take] = self.L[off:off + take]
            else:
                path = (None, A_F, B_F, C_F, D_F)[sec]
                foff = off if sec != 2 else off + self.B_stitch
                take = min(m - got,
                           (self.nA, self.nA, self.nB, self.nC,
                            self.nD)[sec] - off)
                if self._fh is None or self._fh_path != path:
                    if self._fh is not None:
                        self._fh.close()
                    self._fh = open(path, 'rb', buffering=0)
                    self._fh_path = path
                self._fh.seek(foff * 8)
                data = self._fh.read(take * 8)
                assert len(data) == take * 8, "short read in tail stream"
                out[got:got + take] = np.frombuffer(data, dtype='<f8')
            got += take
        self._pos = base + m
        return out

    def read_slab_at(self, i0, m):
        """THREAD-SAFE  read:  the  m  logical  elements  starting
        at  i0,  touching  NEITHER  self._pos  NOR  self._fh  (the
        threaded  sweep  paths  each  carry  a  private  handle);
        same  section  tiling  and  seam  semantics  as
        read_slab  (which  the  selftests  cover  for  the  cursor
        case)."""
        out = np.empty(m, dtype='<f8')
        got = 0
        fh = None
        fh_path = None
        try:
            while got < m:
                sec, off = self._section_of(i0 + got)
                if sec == 0:
                    take = min(m - got, self.nL - off)
                    out[got:got + take] = self.L[off:off + take]
                else:
                    path = (None, A_F, B_F, C_F, D_F)[sec]
                    foff = off if sec != 2 else off + self.B_stitch
                    take = min(m - got,
                               (self.nA, self.nA, self.nB, self.nC,
                                self.nD)[sec] - off)
                    if fh is None or fh_path != path:
                        if fh is not None:
                            fh.close()
                        fh = open(path, 'rb', buffering=0)
                        fh_path = path
                    fh.seek(foff * 8)
                    data = fh.read(take * 8)
                    assert len(data) == take * 8, "short read (threaded)"
                    out[got:got + take] = np.frombuffer(data, dtype='<f8')
                got += take
        finally:
            if fh is not None:
                fh.close()
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
def slab_budget(c, tf, t2, m, start_idx=0, extra_idx=None, free_pool=True, st=None):
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
    if extra_idx is not None and extra_idx.size:
        lo_ = int(np.searchsorted(extra_idx, start_idx, side='left'))
        hi_ = int(np.searchsorted(extra_idx, start_idx + m, side='right'))
        if hi_ > lo_:
            loc = extra_idx[lo_:hi_] - start_idx
            # the A/B overlap-rounding zeros:  dg x3,  i.e.  two extra
            # standard per-term dg*|d/dg| contributions  (|delta| <= 1.5 ulp)
            B_re += (2.0 * float((dg[loc] * dredg[loc])
                                 .astype(np.longdouble).sum()))
            B_im += (2.0 * float((dg[loc] * dimdg[loc])
                                 .astype(np.longdouble).sum()))
    dmin = float(np.min(np.abs(c - tf)))
    del g2, A, re_t, im_t, abs_re, dg, dredg, dimdg
    return sub_re, sub_im, B_re, B_im, s_abs_re, dmin


def _pos_cert(S_f64, m):
    """certified upper bound on the exact sum of the non-negative
    f64 inputs,  from its f64 sum  S_f64  (Higham gamma_(m-1)  on
    an f64 sum of non-negative terms:  |fl - exact| <= gamma*(sum),
     exact <= fl,  gamma < (m-1)*U64*(1 + (m-1)*U64) < 2*(m-1)*U64
    for  m <= 2^52)."""
    return S_f64 * (1.0 + 2.0 * max(0, m - 1) * U64)


class _noStream:
    """no-op stream context (the sequential  path  runs  exactly
    as  before  cupy  stream  contexts)."""
    def __enter__(self):
        return None

    def __exit__(self, *a):
        return False


def slab_budget_gpu(c, tf, t2, m, start_idx=0, extra_idx=None, free_pool=True, st=None):
    """the per-slab core on the iGPU  (identical f64 arithmetic,
    certified positive-term bounds instead of longdouble refs).
    st:  optional  per-thread  cupy  Stream  (the  threaded  sweep
    runs  each  slab  on  its  own  stream  so  the  8  threads  of
    one  context  execute  CONCURRENTLY  on  the  CUs  --  one  queue,
    many  CUs,  exactly  the  owner's  Strix-Halo  model)."""
    with (st if st is not None else _noStream()):
        cc = cp.asarray(c)
        g2 = cc * cc
        A = g2 + 0.25
        abs_g2t2 = cp.abs(g2 - t2)
        re_t = cp.log(abs_g2t2) - cp.log(A) + 0.5 / A
        im_t = tf / A                                 # > 0   (t > 0,  A > 0)
        sub_re = float(re_t.sum())
        sub_im = float(im_t.sum())
        S1 = float(cp.abs(re_t).sum())
        S2 = float(cp.maximum(cp.abs(re_t), 0.5 / A).sum())
        S3 = sub_im                                  # im_t > 0
        dg = U64 * cp.abs(cc)
        dredg = (2.0 * cc / cp.maximum(abs_g2t2, 1e-30)
                 + 2.0 * cc / A + cc / (A * A))        # > 0   (c > 0)
        dimdg = tf * 2.0 * cc / (A * A)                # > 0
        S4 = float((dg * dredg).sum())
        S5 = float((dg * dimdg).sum())
        dmin = float(np.min(np.abs(c - tf)))          # host:  one pass
        k = int(math.ceil(math.log2(m))) if m > 1 else 0
        S1c, S2c, S3c = _pos_cert(S1, m), _pos_cert(S2, m), _pos_cert(S3, m)
        S4c, S5c = _pos_cert(S4, m), _pos_cert(S5, m)
        B_re = GAM10_64 * S2c + k * 2.0 * U64 * S1c + S4c
        B_im = GAM1_64 * S3c + k * 2.0 * U64 * S3c + S5c
            # the host patch:  the A/B overlap rounding-level zeros (dg x3),
    # identical formulas to day037,  exact f64 at only `loc` elements
    # (host-only  numpy;  outside  the  stream  context  on  purpose).
    if extra_idx is not None and extra_idx.size:
        lo_ = int(np.searchsorted(extra_idx, start_idx, side='left'))
        hi_ = int(np.searchsorted(extra_idx, start_idx + m, side='right'))
        if hi_ > lo_:
            loc = extra_idx[lo_:hi_] - start_idx
            cl = c[loc]
            g2l = cl * cl
            Al = g2l + 0.25
            agt = np.abs(g2l - t2)
            dg_l = U64 * np.abs(cl)
            dredg_l = (2.0 * cl / np.maximum(agt, 1e-30) + 2.0 * cl / Al
                       + cl / (Al * Al))
            dimdg_l = tf * 2.0 * cl / (Al * Al)
            # SUM over the loc elements  (day037 reference form:  the
            # patch carries  >= 1  element  in  production  and
            #  float()  of  a  multi-element  array  is  a  runtime
            #  error  —  this  is  now  covered  by  selftest_patch).
            #  Longdouble  host  sum:  exact  enough,  no  gamma
            #  certificate  needed  on  this  tiny  patch.
            B_re += 2.0 * float((dg_l * dredg_l).astype(np.longdouble).sum())
            B_im += 2.0 * float((dg_l * dimdg_l).astype(np.longdouble).sum())
    for x in (cc, g2, A, abs_g2t2, re_t, im_t, dg, dredg, dimdg):
        del x
    if free_pool:
        cp.get_default_memory_pool().free_all_blocks()
    return sub_re, sub_im, B_re, B_im, S1c, dmin


def tail_with_budget(T, tf, nthreads=1, sub=None, nslabs=None):
    """The  slab  loop.  nthreads=1  is  the  original  sequential
    loop  (bit-identical).  nthreads>1  is  the  owner's  Strix-
    Halo  model  made  real:  the  parallel  unit  is  the  THREAD
    (threads  of  one  HIP  context  share  one  SDMA  queue  and
    spread  over  the  CUs);  each  thread  owns  a  disjoint
    contiguous  slab  range,  reads  it  with  the  cursor-free
    read_slab_at,  accumulates  its  own  partials,  and  the
    parent  reduces  after  the  barrier.  v1  keeps  one  stream
    per  context  (GPU  ops  still  serialize  within  it;  what
    the  threads  buy  is  the  overlap  of  file  I/O  +  host
    numpy  with  GPU  time).  free_all_blocks  is  OFF  in  threaded
    mode:  a  cross-thread  pool  eviction  could  recycle  another
    thread's  live  slab  buffer.  sub:  slab  size  (production
    threaded  runs  use  2^24  =  128MiB  slabs  so  that  32
    concurrent  working  sets  fit  the  100Gi  program  budget).
    nslabs:  prefix  limit  (selftest)."""
    t2 = tf * tf
    slabfn = slab_budget_gpu if USE_GPU else slab_budget
    if sub is None:
        sub = SUB // 2 if (nthreads > 1 and USE_GPU) else SUB
    n = T.n_tail
    nsl = (nslabs if nslabs is not None else (n + sub - 1) // sub)
    n = min(n, nsl * sub)                    # selftest  prefix
    extra = getattr(T, 'extra_idx', None)
    if nthreads <= 1:
        re = np.longdouble(0)
        im = np.longdouble(0)
        B_re = 0.0
        B_im = 0.0
        sa = np.longdouble(0)
        dmin = float('inf')
        nsub = 0
        i = 0
        while i < n:
            m = min(sub, n - i)
            c = T.read_slab(m)
            sr, si, br, bi, s_ar, dm = slabfn(
                c, tf, t2, m, i, extra)
            re += np.longdouble(sr)
            im += np.longdouble(si)
            B_re += br
            B_im += bi
            sa += np.longdouble(s_ar)
            dmin = min(dmin, dm)
            nsub += 1
            i += m
            del c
            if nsub % 500 == 0:
                print("  ...t=%.4g tail sweep %.0f%% (%d pieces)"
                      % (tf, 100.0 * i / n, nsub),
                      flush=True)
    else:
        bounds = _slab_bounds(nsl, nthreads)
        parts = [None] * nthreads
        prog = [0, nsl]
        plck = threading.Lock()

        def _chunk(t, j0, j1):
            st = (cp.cuda.stream.Stream(non_blocking=True)
                  if USE_GPU else None)
            re_l = np.longdouble(0)
            im_l = np.longdouble(0)
            B_re_l = 0.0
            B_im_l = 0.0
            sa_l = np.longdouble(0)
            dmin_l = float('inf')
            n_l = 0
            for j in range(j0, j1):
                i = j * sub
                m = min(sub, n - i)
                c = T.read_slab_at(i, m)
                sr, si, br, bi, s_ar, dm = slabfn(
                    c, tf, t2, m, i, extra, free_pool=False, st=st)
                re_l += np.longdouble(sr)
                im_l += np.longdouble(si)
                B_re_l += br
                B_im_l += bi
                sa_l += np.longdouble(s_ar)
                dmin_l = min(dmin_l, dm)
                n_l += 1
                del c
                with plck:
                    prog[0] += 1
                    if prog[0] % 500 == 0:
                        print("  ...t=%.4g tail sweep %.0f%% (%d pieces, %d threads)"
                              % (tf, 100.0 * prog[0] / prog[1], prog[0], nthreads),
                              flush=True)
            parts[t] = (re_l, im_l, B_re_l, B_im_l, sa_l, dmin_l, n_l)

        ths = [threading.Thread(target=_chunk, args=(t, b0, b1))
               for t, (b0, b1) in enumerate(bounds)]
        for th in ths:
            th.start()
        for th in ths:
            th.join()
        re = np.longdouble(0)
        im = np.longdouble(0)
        B_re = 0.0
        B_im = 0.0
        sa = np.longdouble(0)
        dmin = float('inf')
        nsub = 0
        # deterministic  merge  order  (thread  0  first):  longdouble
        # partials  merge  to  ~1e-15  relative  reordering  noise,
        # the  f64  B  margins  to  ~1e-10  --  both  far  inside
        # the  certified  budgets  (checked  by  SELFTEST(f)  against
        # the  sequential  loop  on  the  real  band).
        for (re_l, im_l, B_re_l, B_im_l, sa_l, dmin_l, n_l) in parts:
            re += re_l
            im += im_l
            B_re += B_re_l
            B_im += B_im_l
            sa += sa_l
            dmin = min(dmin, dmin_l)
            nsub += n_l
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
    """Two-precision remainder pair for Kfull composition.

    IMPORTANT (day049e root-cause fix):  the two sections are
    ADJACENT,  not nested --
        rem = quad over (G_LAST, REMHI]         (= G_LAST .. 1e18)
        ext = quad over (REMHI,  REMHI2]        (= 1e18  .. 1e30)
    ev_point multiplies exp(rem) * exp(ext) to form the
    remainder factor,  so a nested pair (ext over G_LAST..1e30)
    double-counts (G_LAST, 1e18) and drives Kfull to 0
    (the 3e10 fleet's ledger artifact;  see docs/
    VALIANT-EFFORT-FORENSICS.md section 5,  items f-g).  The
    1e7/1e9-generation quad_pair (day034) always used the
    adjacent form this one now restores.
    """
    s = mp.mpc(0.5, mp.mpf(repr(tf)))
    f = _kint(s)
    lo = repr(T.G_LAST)
    rem30 = quad_section(f, lo, REMHI, 400, 30)
    ext30 = quad_section(f, REMHI, REMHI2, 400, 30)
    rem60 = quad_section(f, lo, REMHI, 400, 60)
    ext60 = quad_section(f, REMHI, REMHI2, 400, 60)
    B_qrem = abs(rem30 - rem60)
    B_qext = abs(ext30 - ext60)
    aud = None
    if audit:
        rem800 = (quad_section(f, lo, REMHI, 800, 30),
                  quad_section(f, lo, REMHI, 800, 60))
        ext800 = (quad_section(f, REMHI, REMHI2, 800, 30),
                  quad_section(f, REMHI, REMHI2, 800, 60))
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


def cert_point(T, tf, g, audit=False, nthreads=1, sub=None, nslabs=None):
    tfs = float(tf)
    T.restart()
    (re, im, nlt, B_re, B_im, dmin_t) = tail_with_budget(
        T, tfs, nthreads=nthreads, sub=sub, nslabs=nslabs)
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
    L = abs(p30["Kfull"])
    zabs30 = float(p30["zabs"])
    # day049e guard:  |Kfull| must be O(|z|)  --  the Kfull
    # assembly (exponent stack + adjacent remainder pieces)
    # self-tests here;  a degenerate Kfull ~= 0 or O(1e9)-
    # blown Kfull FAILS the row (the exact failure mode of the
    # 3e10 fleet ledger,  see VALIANT-EFFORT-FORENSICS.md 5f).
    bad_asm = (L < 0.05 * zabs30) or (L > 50.0 * zabs30)
    flag = (dmin < NLT_GUARD) or bad_asm
    Bexp = (B_re + B_la
            + float(abs(mp.re(B_qrem) + mp.re(B_qext))) + B_lm)
    Bph = (B_im + B_ar + float(abs(mp.im(B_qrem) + mp.im(B_qext))))
    env = math.exp(Bexp)
    dK = L * (env - 1.0 + env * Bph)
    pb = float(M.p8_B(mp.mpf(repr(tfs)), n4(tfs)))
    residf30 = float(p30["residf"])
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
    inside D,  so the  search  is  a binary  search  over  D  alone.
    (The  D-file  is  indexed  0..nD-1  on  its  own;  an  earlier
    revision  wrongly  started  the  search  at  D's  offset  in
    the  stitched  tail,  which  left  x  <  ~5.6e9  outside  the
    search  space  and  returned  a  WRONG  anchor.)"""
    lo_i, hi_i = 0, T.nD
    with open(D_F, 'rb', buffering=0) as f:
        while hi_i - lo_i > 1:
            mid = (lo_i + hi_i) // 2
            f.seek(mid * 8)
            if struct.unpack('<d', f.read(8))[0] <= x:
                lo_i = mid
            else:
                hi_i = mid
        cands = []
        for k in (lo_i - 1, lo_i, lo_i + 1):
            if 0 <= k < T.nD:
                f.seek(k * 8)
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


def selftest_streaming(slabfn=None):
    """(b) STREAMING containment,  scaled down for speed:  4.2M
    synthetic zeros in two files (2.1M + 2.1M+1)  in nine 2^19
    pieces,  the file seam landing mid-piece;  the piece pipeline +
    budget must contain the dps-60 exact value  for both stored=true
    and 0.5ulp-offset settings.  (Same m=min(piece, n-i) +
    k=ceil(log2 m) bookkeeping the real run uses at 2^25.)"""
    if slabfn is None:
        slabfn = slab_budget
    sufx = "-gpu" if slabfn is slab_budget_gpu else ""
    print("SELFTEST(b%s): streaming containment (4.2M, 2 files, 9 pieces, "
          "file seam mid-piece)" % sufx, flush=True)
    t0 = time.time()
    rng = np.random.default_rng(42)
    n1, n2 = 2_100_000, 2_100_000
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
        base = T._pos
        got = 0
        while got < m:
            sec, off = T._section_of(base + got)
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
        T._pos = base + m
        return out
    T.read_slab = read_slab2

    tf = float(ts[len(ts) // 2]) + 0.5    # a straddle:  half-integer
    # offset from the anchor zero,  exactly as in the real run
    # (a straddle is always >= 0.5 from every zero  --  log|g^2-t^2|
    # can never hit 0)
    mp.dps = 60    # the true values must be built at dps-60,
    # or mpmath's default 15 keeps only ~50 bits of each 53-bit
    # f64 and the `exact' side carries its own ~5e-7 errors
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
        PIECE_TEST = 524288
        while i < n:
            m = min(PIECE_TEST, n - i)
            c = T.read_slab(m)
            sr, si, br, bi, s_ar, dm = slabfn(c, tf, tf * tf, m)
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
    print("SELFTEST(b%s): %s" % (sufx, "PASS" if ok
          else "FAIL -- budget too small"), flush=True)
    return ok


def selftest_core_gpu():
    """(a-gpu) containment on the GPU slab core:  same arrays and
    dps-60 exact references as selftest_core;  containment against
    the exact value is the certificate.  (The CPU-vs-GPU value
    line is reported and must sit inside the pairwise structure.)"""
    print("SELFTEST(a-gpu): budget containment (iGPU slab)", flush=True)
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
        sr, si, B_re, B_im, S1c, _dm = slab_budget_gpu(gam, tf, t2, gam.size)
        sr0, si0, _Br0, _Bi0, S1c0, _dm0 = slab_budget(gam, tf, t2, gam.size)
        k = int(math.ceil(math.log2(gam.size)))
        eq_ok = bool(abs(sr - sr0) <= k * 2.0 * U64 * S1c0
                     and abs(si - si0) <= k * 2.0 * U64 * S1c0)
        err_re = abs(mp.mpf(repr(sr)) - re_ex)
        err_im = abs(mp.mpf(repr(si)) - im_ex)
        ok_re = bool(err_re <= mp.mpf(repr(B_re)))
        ok_im = bool(err_im <= mp.mpf(repr(B_im)))
        ok = ok and ok_re and ok_im and eq_ok
        print("  tail-gpu[%s]: err_re=%.3e B_re=%.3e %s | err_im=%.3e "
              "B_im=%.3e %s | gpu/cpu within pairwise: %s"
              % (tag, float(err_re), B_re, ok_re,
                 float(err_im), B_im, ok_im, eq_ok), flush=True)
    print("SELFTEST(a-gpu): %s" % ("PASS" if ok else
          "FAIL -- budget too small or GPU/CPU divergence"), flush=True)
    return ok


def selftest_streaming_gpu():
    return selftest_streaming(slab_budget_gpu)


def selftest_patch():
    """(c) OVERLAP-PATCH:  drive the host patch branch  (extra_idx
    with  >= 2  elements  in  one  slab,  the  production  A/B
    overlap  case)  in  both  slab  budgets,  and  cross-check
    GPU  vs  CPU  on  identical  inputs.  (The  original
    float(array)  bug  lived  here;  this  test  is  the  guard.)"""
    print("SELFTEST(c): overlap host-patch (multi-element) + GPU==CPU",
          flush=True)

    def close(a, b, rel=1e-9):
        return abs(a - b) <= rel * max(1.0, abs(a), abs(b))

    rng = np.random.default_rng(7)
    m = 1024
    c = np.sort(50.0 + np.cumsum(rng.uniform(0.25, 0.4, m))).astype(np.float64)
    tf = 250.7
    t2 = tf * tf
    ex = np.array([7, 40, 500, 900], dtype=np.int64)
    r_cpu = slab_budget(c, tf, t2, m, 0, ex)
    r_gpu = slab_budget_gpu(c, tf, t2, m, 0, ex)
    r_cpu0 = slab_budget(c, tf, t2, m, 0, None)
    r_gpu0 = slab_budget_gpu(c, tf, t2, m, 0, None)
    cl = c[ex]
    g2l = cl * cl
    Al = g2l + 0.25
    agt = np.abs(g2l - t2)
    dgl = U64 * np.abs(cl)
    dredgl = (2.0 * cl / np.maximum(agt, 1e-30) + 2.0 * cl / Al
              + cl / (Al * Al))
    dimdl = tf * 2.0 * cl / (Al * Al)
    dref_re = 2.0 * float((dgl * dredgl).astype(np.longdouble).sum())
    dref_im = 2.0 * float((dgl * dimdl).astype(np.longdouble).sum())
    ok = (close(r_cpu[2] - r_cpu0[2], dref_re)
          and close(r_gpu[2] - r_gpu0[2], dref_re)
          and close(r_cpu[3] - r_cpu0[3], dref_im)
          and close(r_gpu[3] - r_gpu0[3], dref_im))
    for a_, b_ in ((r_cpu[0], r_gpu[0]), (r_cpu[1], r_gpu[1]),
                   (r_cpu[2], r_gpu[2]), (r_cpu[3], r_gpu[3]),
                   (r_cpu[4], r_gpu[4]), (r_cpu[5], r_gpu[5])):
        ok = ok and close(a_, b_)
    print("  patch deltas:  cpu re=%.3e im=%.3e | gpu re=%.3e im=%.3e "
          "(ref re=%.3e im=%.3e)" % (r_cpu[2] - r_cpu0[2],
                                     r_cpu[3] - r_cpu0[3],
                                     r_gpu[2] - r_gpu0[2],
                                     r_gpu[3] - r_gpu0[3],
                                     dref_re, dref_im), flush=True)
    for name, a_, b_ in (("sub_re", r_cpu[0], r_gpu[0]),
                         ("sub_im", r_cpu[1], r_gpu[1]),
                         ("B_re", r_cpu[2], r_gpu[2]),
                         ("B_im", r_cpu[3], r_gpu[3]),
                         ("S1c", r_cpu[4], r_gpu[4]),
                         ("dmin", r_cpu[5], r_gpu[5])):
        print("  %s:  cpu=%.12g  gpu=%.12g  %s"
              % (name, a_, b_, "OK" if close(a_, b_) else "MISMATCH"),
              flush=True)
    print("SELFTEST(c): %s" % ("PASS" if ok else "FAIL"), flush=True)
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


def selftest_nearest_zero():
    """(e) nearest_zero regression:  the  anchor  of  a  window
    must  be  a  REAL  zero  of  D  within  half  a  gap  of  x,
    at  the  LOW  edge  (the  d0-shift  bug  zone),  the  mid,
    and  the  top  window  of  the  grid."""
    print("SELFTEST(e):  nearest_zero  anchors  (low/mid/top)", flush=True)
    T = _get_T()
    xs = grid()
    ok = True
    for i in (0, 1, 7, 8, 14, 28):
        x = xs[i]
        g = nearest_zero(T, x)
        d = abs(g - x)
        ggood = d < 0.4 and BAND_LO < g <= T.G_LAST
        ok = ok and ggood
        print("  window  %2d:  x=%.6g  g=%.6f  |g-x|=%.4f  %s"
              % (i, x, g, d, "OK" if ggood else "FAIL"), flush=True)
    print("SELFTEST(e):  %s" % ("PASS" if ok else "FAIL"), flush=True)
    return ok


def selftest_ckpt():
    """(d)  CHECKPOINT  ROUND-TRIP  (no  GPU,  no  band):
    synthetic  records  must  survive  file  ->  parse  ->
    re-emit  byte-identically  (including  the  audit
    continuation  line);  the  k-recovery  must  be  exact;
    a  torn  tail  must  drop  exactly  the  torn  line;
    mid-file  corruption  must  halt  (None)."""
    import tempfile
    import shutil
    print("SELFTEST(d):  checkpoint  round-trip  +  resume  bookkeeping",
          flush=True)
    global CKPT_DIR
    real_dir = CKPT_DIR
    d = tempfile.mkdtemp(prefix="ckpt_selftest_")
    CKPT_DIR = d
    ok = True
    try:
        x = 12345678901.2345678
        g = 12345678901.999999

        def mk(k, audit=False):
            return {"flag": False, "x": x, "t": float(g + k / 2.0),
                    "g": g, "mnew": 1.0 + 1e-7 * k,
                    "mcert": 1.0 - 1e-9 * abs(k), "residf": 1e-6,
                    "zeta": 0.5, "dev": 1e-12, "Bexp": 2.31e-3,
                    "Bph": 1e-4, "Bz": 1e-3, "Bdev": 1e-10,
                    "Btail_re": 1e-9, "Btail_im": 1e-9,
                    "Bprod_re": 1e-9, "Bprod_im": 1e-9,
                    "Bqrem": 1e-9, "Bqext": 1e-9, "nlt": 7,
                    "audit": ({"rem": [3.21e-4, 1.1e-4],
                               "ext": [9.5e-5]} if audit else None)}

        r0 = (_parse_wk_file(0, x) == [])
        assert r0, "no file -> []"
        for k in K_LIST[:22]:
            _ckpt_append(0, x, mk(k, audit=(k == -12)))
        raw = open(_wk_path(0, x)).read()
        recs = _parse_wk_file(0, x)
        r1 = (recs is not None and len(recs) == 22
              and _k_set(recs) == set(K_LIST[:22]))
        print("  22-pt  parse  +  exact  k-recovery:  %s" % r1, flush=True)
        ok = ok and r1
        reem = "".join(_point_row(x, p) for p in recs)
        r2 = (reem == raw)
        print("  round-trip  byte-identical  (incl.  audit  row):  %s"
              % r2, flush=True)
        ok = ok and r2
        with open(_wk_path(0, x), "a") as tf:
            tf.write("ok,%.10f,%.10f," % (x, g + 5))
        recs2 = _parse_wk_file(0, x)
        r3 = (recs2 is not None and len(recs2) == 22)
        print("  torn  tail  dropped,  22  kept:  %s" % r3, flush=True)
        ok = ok and r3
        with open(_wk_path(0, x), "w") as tf:
            tf.write(raw[:len(raw) // 3]
                     + "GARBAGE LINE\n" + raw[len(raw) // 3:])
        r4 = (_parse_wk_file(0, x) is None)
        print("  mid  corruption  ->  None  (HOLD):  %s" % r4, flush=True)
        ok = ok and r4
    finally:
        CKPT_DIR = real_dir
        shutil.rmtree(d, ignore_errors=True)
    print("SELFTEST(d):  %s" % ("PASS" if ok else "FAIL"), flush=True)
    return ok


import concurrent.futures as cf


def _worker(x):
    """module-level worker (picklable for ProcessPoolExecutor)."""
    return scan_window(x, T=_get_T())


# ----------------------------------------------------------------------
# CHECKPOINTING  (FULL  mode  only;  the  PROFILE  path  is  exactly
# as  before)
#
#  Every  (window  i,  offset  k)  point  is  written  to  its
#  append-only  file  the  moment  its  cert  completes  (one  row
#  per  point,  plus  the  audit  continuation  line  for  k  =
#  -12).  A  crash  loses  at  most  the  in-flight  points  (one
#  ~  100-min  sweep  each,  at  most  `workers`  of  them).
#  Resume  =  resubmit  only  the  (i,  k)  pairs  not  yet  on
#  disk  (the  day045  supervisor  re-launches  the  same  script).
#  A  TORN  TAIL  line  (an  interrupted  write  at  the  end  of
#  the  file)  is  dropped  (that  point  is  recomputed);
#  corruption  ANYWHERE  ELSE  halts  the  instance  (owner
#  decides;  never  guess).
# ----------------------------------------------------------------------

def _wk_path(i, x):
    return CKPT_DIR + "/widx%02d_x%.10g.pts" % (i, x)


def _parse_wk_file(i, x):
    return _parse_wk_file_path(_wk_path(i, x), x)


def _parse_wk_file_path(path, x):
    """Parse  a  checkpoint  file  ->  point  records  in  on-disk
    order,  or  None  on  corruption  (torn-tail  excepted)."""
    if not os.path.exists(path):
        return []
    with open(path) as f:
        nonempty = [ln for ln in f.read().split("\n") if ln]
    recs = []
    last = None
    for idx, ln in enumerate(nonempty):
        torn_tolerate = (idx == len(nonempty) - 1)
        if ln.startswith("audit,"):
            if last is None:
                return None if not torn_tolerate else recs
            body = ln[len("audit,"):].strip()
            head, _, rest = body.partition(" ")
            m = dict(kv.split("=", 1) for kv in
                     head.rstrip(",").split(",") + rest.split()
                     if "=" in kv)
            try:
                last["audit"] = {"rem": [float(m["rem_spread_max"])],
                                 "ext": [float(m["ext_spread_max"])]}
            except (KeyError, ValueError):
                return None if not torn_tolerate else recs
            continue
        f_ = ln.split(",")
        if len(f_) != 21:
            return recs if torn_tolerate else None
        try:
            p = {"flag": f_[0].strip() == "FLAG",
                 "x": float(f_[1]), "t": float(f_[2]), "g": float(f_[3]),
                 "mnew": float(f_[4]), "mcert": float(f_[5]),
                 "residf": float(f_[6]), "zeta": float(f_[7]),
                 "dev": float(f_[8]), "Bexp": float(f_[9]),
                 "Bph": float(f_[10]), "Bz": float(f_[11]),
                 "Bdev": float(f_[12]), "Btail_re": float(f_[13]),
                 "Btail_im": float(f_[14]), "Bprod_re": float(f_[15]),
                 "Bprod_im": float(f_[16]), "Bqrem": float(f_[17]),
                 "Bqext": float(f_[18]), "nlt": int(f_[19]),
                 "flagint": int(f_[20]), "audit": None}
        except ValueError:
            return recs if torn_tolerate else None
        if abs(p["x"] - x) > 1e-6:
            return None
        if p["flagint"] != (1 if p["flag"] else 0):
            return None
        recs.append(p)
        last = p
    return recs


def _k_set(recs):
    """Recover  each  record's  offset  k  from  t  =  g  +  k/2
    (exact:  t  -  g  is  exact  by  Sterbenz,  so  2*(t-g)  is
    k  within  <  4  ulp(g),  far  from  any  half-integer)."""
    return set(round(2.0 * (p["t"] - p["g"])) for p in recs)


def _wk_files_x(x):
    """Every  checkpoint  file  carrying  this  x,  for  ANY
    slice-local  prefix:  a  window  filled  by  a  DIFFERENT
    slice  has  a  different  widxNN  prefix  (cross-slice).
    Same  %.10g  format  as  the  writer,  so  the  glob  matches
    exactly."""
    import glob as _glob
    return sorted(_glob.glob(CKPT_DIR + "/widx*_x%.10g.pts" % x))


def _parse_window(i, x):
    """Resume  read  for  slice-local  window  i  at  x:  the
    slice-local  file  when  it  exists  (semantics  unchanged);
    else  the  k-deduped  UNION  of  every  widxNN  file  carrying
    x  (cross-slice  resume  --  same  window,  written  by  an
    older  slice).  Corruption  in  ANY  contributing  file
    HALTS  (never  guess)."""
    local = _wk_path(i, x)
    if os.path.exists(local):
        return _parse_wk_file(i, x)
    others = [p for p in _wk_files_x(x) if p != local]
    if not others:
        return []
    merged, seen = [], set()
    for p in others:
        r = _parse_wk_file_path(p, x)
        if r is None:
            return None
        for rec in r:
            k = round(2.0 * (rec["t"] - rec["g"]))
            if k in seen:
                continue
            seen.add(k)
            merged.append(rec)
    return merged


def _ckpt_append(i, x, p):
    """Append  one  point  row  (plus  the  audit  row  when
    present):  a  single  <  1.5KB  write  under  O_APPEND  is
    atomic;  fsync  after  every  row."""
    path = _wk_path(i, x)
    f = open(path, "a")
    try:
        f.write(_point_row(x, p))
        f.flush()
        os.fsync(f.fileno())
    finally:
        f.close()


def _write_pids():
    """PID  FILE  (the  owner's  win):  record  every  process
    of  this  instance  so  stop  /  audit  never  guesses.
    Format:  one  "role SP pid"  per  line.  Safety  caveat:
    PIDs  can  be  reused  by  the  OS  —  the  stop  helper
    verifies  each  PID's  cmdline  before  killing."""
    import time as _t
    mine = []
    me = os.getpid()
    try:
        for d in os.listdir("/proc"):
            if not d.isdigit():
                continue
            try:
                with open("/proc/" + d + "/stat") as f:
                    parts = f.read().rsplit(")", 1)[1].split()
                if int(parts[1]) == me:          # ppid field
                    mine.append(int(d))
            except (OSError, ValueError, IndexError):
                continue
        # children  may  still  be  spawning:  wait  briefly  for
        # the  expected  worker  count
        deadline = _t.time() + 60
        while _t.time() < deadline and len(mine) < max(workers_expect, 1):
            _t.sleep(1)
            mine = []
            for d in os.listdir("/proc"):
                if not d.isdigit():
                    continue
                try:
                    with open("/proc/" + d + "/stat") as f:
                        parts = f.read().rsplit(")", 1)[1].split()
                    if int(parts[1]) == me:
                        mine.append(int(d))
                except (OSError, ValueError, IndexError):
                    continue
    except OSError:
        pass
    tmp = CKPT_DIR + "/run.pids.tmp"
    with open(tmp, "w") as f:
        f.write("# day038 FULL instance pid file (utc %s)\n"
                % _t.strftime("%Y-%m-%dT%H:%M:%SZ", _t.gmtime()))
        f.write("parent %d\n" % me)
        for w in sorted(mine):
            f.write("worker %d\n" % w)
        f.flush()
        os.fsync(f.fileno())
    os.replace(tmp, CKPT_DIR + "/run.pids")
    print("pids: parent=%d workers=%d written to ckpt_h1_3e10/run.pids"
          % (me, len(mine)), flush=True)


def _mem_available_gib():
    try:
        with open("/proc/meminfo") as f:
            for ln in f:
                if ln.startswith("MemAvailable:"):
                    return int(ln.split()[1]) / (1024.0 * 1024.0)
    except (OSError, ValueError):
        pass
    return None


def _worker_pt(job):
    """Point-job  worker  (picklable):  job  =  (i,  x,  k)."""
    i, x, k = job
    T = _get_T()
    g = nearest_zero(T, x)
    p = cert_point(T, g + k / 2.0, g, audit=(k == -12), nthreads=THREADS)
    _ckpt_append(i, x, p)
    print("  pt win=%d k=%+d x=%.4g t=%.5f mnew=%.4f mcert=%.4f "
          "bexp=%.2e" % (i, k, x, p["t"], p["mnew"], p["mcert"],
                         p["Bexp"]), flush=True)
    return p


def run():
    if os.environ.get("H1CERT_SMOKE") == "1":
        _run_profile()
    else:
        _run_full()


def _run_profile():
    """The  (i)  profile  —  behavior  and  output  path  exactly
    as  the  original  run()."""
    xs = [max(grid())]          # the profile:  the top window
    work = min(int(os.environ.get("WORKERS", "12")), 14)   # owner core cap
    mode = "PROFILE"
    print("day038 %s H1-3e10: %s, %d windows, workers=%d"
          % ("gpu" if USE_GPU else "cpu", mode, len(xs), work),
          flush=True)
    t0 = time.time()
    res = []
    with open(OUT, "w") as fo:
        fo.write("# day037 H1 cert 3e10 %s workers=%d %s\n"
                 % (mode, work, time.strftime("%Y-%m-%d %H:%M:%S")))
        fo.write("# point detail (incremental; one row per straddle):\n")
        fo.flush()
        if work == 1:
            for x in xs:
                w = _worker(x)
                res.append(w)
                _emit(fo, w, t0)
        else:
            with cf.ProcessPoolExecutor(max_workers=work) as ex:
                futs = [ex.submit(_worker, x) for x in xs]
                for fu in cf.as_completed(futs):
                    w = fu.result()
                    res.append(w)
                    _emit(fo, w, t0)
    res.sort(key=lambda r: r["x"])
    dt = time.time() - t0
    _summary(res, dt, mode)


def selftest_threads(nslabs=64, sub=1 << 19, tthreads=8):
    """(f)  The  threaded  slab  loop  vs  the  sequential  one,  on
    the  REAL  band:  same  T,  same  sub,  same  nslabs  prefix,
    1  thread  vs  tthreads --  counts  (nlt,  total  slab  count)
    exact,  sums  within  re-ordering  noise  (longdouble  ~1e-15
    relative;  f64  B  margins  ~1e-10).  Exercises  read_slab_at
    across  the  real  section  seams  and  the  disjoint  tiling."""
    print("SELFTEST(f): threaded sweep (real band,  %d  x  2^19  slabs,  1 vs %d threads)" % (nslabs, tthreads), flush=True)
    t0 = time.time()
    for nt in (1, 2, 3, 5, 8, 11):
        for nsl in (1, 7, 64, 3029):
            bs = _slab_bounds(nsl, nt)
            assert sum(e - s for s, e in bs) == nsl, "tiling  gap  /  overlap"
            assert all(bs[t + 1][0] == bs[t][1] for t in range(nt - 1)), "tiling  not  contiguous"
    T = _get_T()
    tf = 3490744654.0                    # window  1  height  (any  t  works)
    a = tail_with_budget(T, tf, nthreads=1, sub=sub, nslabs=nslabs)
    T.restart()
    b = tail_with_budget(T, tf, nthreads=tthreads, sub=sub, nslabs=nslabs)
    ok = True
    for name, xv, yv, tol in (("re", a[0], b[0], 1e-9),
                              ("im", a[1], b[1], 1e-9),
                              ("B_re", a[3], b[3], 1e-9),
                              ("B_im", a[4], b[4], 1e-9)):
        d = abs(xv - yv) / max(1.0, abs(xv))
        ok = ok and d < tol
        print("  %s:  seq=%.12g  thr=%.12g  rel=%.1e  %s"
              % (name, xv, yv, d, "OK" if d < tol else "MISMATCH"), flush=True)
    ok = ok and (a[2] == b[2]) and (a[5] == b[5])
    print("SELFTEST(f):  %s  (wall  %.1f  s)" % ("PASS" if ok else "FAIL", time.time() - t0), flush=True)
    return ok


def _run_full():
    """The  (i)  FULL  fill:  696  point  jobs  (29  windows  x
    24  offsets),  each  checkpointed  on  completion  —
    crash-safe,  resumable  (day045  supervisor  re-launches).
    Exit  codes:  3  =  corrupt  checkpoint  (owner  decides),
    4  =  incomplete  (supervisor  resumes),  0  =  all  696
    done  and  assembled."""
    work = min(int(os.environ.get("WORKERS", "14")), 14)   # owner core cap
    xs = grid()
    # H1_WINDOWS:  disjoint  window  assignment  for  fleet  runs
    # (several  machines  take  different  window  ranges  against
    # the  same  canonical  data;  checkpoints  are  per-window
    # files,  so  assignments  never  interleave  and  the  merged
    # ledger  just  unions  the  rows).  Formats:  "0-14",
    # "15-28",  "0-9,15-17,27,28".
    _wksel = os.environ.get("H1_WINDOWS", "").strip()
    if _wksel:
        sel = set()
        for part in _wksel.split(","):
            part = part.strip()
            if not part:
                continue
            if "-" in part:
                a, b = part.split("-")
                sel.update(range(int(a), int(b) + 1))
            else:
                sel.add(int(part))
        nwin = len(xs)
        xs = [x for i, x in enumerate(xs) if i in sel]
        print("H1_WINDOWS:  running  windows  %s  (%d  of  %d)"
              % (_wksel, len(xs), nwin), flush=True)
    os.makedirs(CKPT_DIR, exist_ok=True)
    t0 = time.time()
    jobs = []
    for i, x in enumerate(xs):
        recs = _parse_window(i, x)
        if recs is None:
            print("CKPT  CORRUPT:  window  %d  (x=%.10g)  --  HOLD, owner decides" % (i, x), flush=True)
            sys.exit(3)
        done = _k_set(recs)
        for k in K_LIST:
            if k not in done:
                jobs.append((i, x, k))
        print("resume:  window  %2d  (x=%.10g)  %d/%d  points  on disk" % (i, x, len(recs), N_PTS_PER_WIN), flush=True)
    global workers_expect
    # MEMORY  GUARD:  the  worker  count  is  derived  from  live
    # RAM  (not  cores):  the  owner's  model  =  100Gi  for  the
    # programs,  28Gi  untouchable  (25  OS  +  3  display)  --
    # RESERVE  =  that  floor.  The  iGPU  queue  hardware  adds
    # a  second  ceiling:  ~8  SDMA  queues  total  system-wide
    # (dmesg:  "No  more  SDMA  queue  to  allocate").  The  budget
    # is  counted  in  GPU  CLIENTS  INCLUDING  Xorg  (which  always
    # holds  one):  the  observed  zero-error  operating  point  is
    # 11  clients  =  10  workers  +  Xorg.  11  workers  +  Xorg
    # (12  clients)  froze  two  workers  mid-sweep  on  2026-09-22
    # (09:27  incident):  the  SDMA  allocation  failure  leaves
    # the  victim  spinning  in  R  with  zero  read  progress,  and
    # its  job  never  completes  (the  parent  then  hangs  on  the
    # lost  future).  So  the  WORKER  allowance  =  client  budget
    # -  Xorg  clients,  never  the  raw  budget.
    RESERVE_GIB = int(os.environ.get("H1_RESERVE_GIB", "28"))
    PER_THREAD_GIB = float(os.environ.get("H1_PER_THREAD_GIB", "2.5"))
    GPU_CLIENT_BUDGET = int(os.environ.get("H1_GPU_CLIENT_BUDGET", "11"))
    XORG_CLIENTS = int(os.environ.get("H1_XORG_CLIENTS", "1"))
    # H1_GPU_CLIENT_CAP  stays  as  a  direct  CONTEXT-cap  override
    # (ops  escape  hatch);  default  =  client  budget  minus  Xorg.
    ctx_cap = int(os.environ.get(
        "H1_GPU_CLIENT_CAP", max(GPU_CLIENT_BUDGET - XORG_CLIENTS, 1)))
    avail = _mem_available_gib()
    if avail is not None:
        allow = min(int((avail - RESERVE_GIB) // (THREADS * PER_THREAD_GIB)), ctx_cap)
        if allow < 1:
            print("memguard:  MemAvailable  %.1f  GiB  <  reserve  %d  +  one  context  x  %d  threads  --  HOLD  (exit  6);  supervisor  retries  later" % (avail, RESERVE_GIB, THREADS), flush=True)
            sys.exit(6)
        print("memguard:  MemAvailable  %.1f  GiB,  reserve  %d  GiB,  ~%.1f  GiB/thread  x  %d  threads  ->  allow  <=  %d  contexts  (=  %d  slab  threads;  %d  GPU  clients  incl.  Xorg  vs  budget  %d)" % (avail, RESERVE_GIB, PER_THREAD_GIB, THREADS, allow, allow * THREADS, allow + XORG_CLIENTS, GPU_CLIENT_BUDGET), flush=True)
        work = min(work, max(allow, 1))
    else:
        print("memguard:  MemAvailable  unreadable  --  proceeding  with  env  WORKERS=%d  contexts" % work, flush=True)
    print("day038  %s  H1-3e10:  FULL,  %d  point  jobs  remaining (%d  windows,  %d  contexts  x  %d  threads)" % ("gpu" if USE_GPU else "cpu", len(jobs), len(xs), work, THREADS), flush=True)
    if jobs:
        workers_expect = work
        with cf.ProcessPoolExecutor(max_workers=work) as ex:
            futs = {ex.submit(_worker_pt, job): job for job in jobs}
            # pid  file  AFTER  the  submits:  the  pool  spawns
            # its  workers  on  first  submit,  so  only  now  are
            # the  child  pids  real.  (Earlier  order  wrote  the
            # file  with  zero  workers.)
            _write_pids()
            for fu in cf.as_completed(futs):
                i, x, k = futs[fu]
                try:
                    fu.result()
                except BaseException as e:
                    print("point  job  (win  %d,  k  %+d,  x=%.10g)  WORKER  FAILED:  %r  --  done  points  are  checkpointed;  supervisor  resumes" % (i, k, x, e), flush=True)
    res = []
    missing = 0
    for i, x in enumerate(xs):
        recs = _parse_window(i, x)
        if recs is None:
            print("window  %2d:  CORRUPT  after  the  pool  --  owner" % i, flush=True)
            sys.exit(3)
        ks = _k_set(recs)
        if len(recs) != N_PTS_PER_WIN or len(ks) != N_PTS_PER_WIN:
            missing += 1
            print("window  %2d:  %d/%d  points  after  this  instance" % (i, len(recs), N_PTS_PER_WIN), flush=True)
            continue
        res.append({"x": x, "i": i, "g": recs[0]["g"], "pts": recs})
    if missing:
        print("H1  INCOMPLETE:  %d  window(s)  not  at  24/24  --  checkpoints  intact,  supervisor  resumes" % missing, flush=True)
        sys.exit(4)
    res.sort(key=lambda r: r["x"])
    with open(OUT_FULL, "w") as fo:
        fo.write("# day038  H1  cert  3e10  FULL  workers=%d  %s\n"
                 % (work, time.strftime("%Y-%m-%d %H:%M:%S")))
        fo.write("# point  detail  (assembled  from  checkpoints;  one  row  per  straddle):\n")
        for w in res:
            for p in sorted(w["pts"], key=lambda p: p["t"]):
                fo.write(_point_row(w["x"], p))
        fo.flush()
    dt = time.time() - t0
    _summary(res, dt, "FULL")
    print("H1  FULL-DONE:  %d  windows,  %d  points,  assembled  to  %s;  instance  wall  %.1f  h" % (len(res), len(res) * N_PTS_PER_WIN, OUT_FULL, dt / 3600.0), flush=True)


if __name__ == '__main__':
    if os.environ.get("H1CERT_SELFTEST") == "1":
        a = selftest_core()
        ag = selftest_core_gpu()
        ap = selftest_patch()
        dc = selftest_ckpt()
        en = selftest_nearest_zero()
        ft = selftest_threads()
        if os.environ.get("H1CERT_SELFTEST_STREAM") == "1":
            b = selftest_streaming()
            bg = selftest_streaming_gpu()
            sys.exit(0 if (a and ag and ap and dc and en and ft and b and bg) else 1)
        sys.exit(0 if (a and ag and ap and dc and en and ft) else 1)
    run()
