#!/usr/bin/env python3
"""day034 -- H1 CERTIFICATE-GRADE RE-ISSUANCE of the S1 squeeze on (1e6, 1e9]
(queue item 7, part a).  Implements the KNOWN_LIMITATIONS H1 *Fix* in its
explicitly-allowed second variant: a MACHINE-VERIFIED ERROR-BUDGET re-run of
the straddle statistic on a dense grid (Platt-Trudgian certification grade),
rather than interval arithmetic.

WHAT IS CERTIFIED (upgrading screen to certificate):
  at EVERY straddle point of the grid  G = {windows} x {25-straddles},
  window g_x = the real zero nearest x = 1e6 * 1.08^k (k = 0..89,
  x <= ~1e9), straddles t = g_x + k/2, k = -12..12 \\ {0} (verbatim the
  day029 protocol; the 400-node dps-30 quad at EVERY straddle, so no
  best-point reissue step is needed -- the value configuration is a
  superset of the sweep's):
      margin_new(t, g_x) > 1 + eps_explicit
  with eps_explicit = the explicit tracked budget of the statistic.

STATISTIC (verbatim day029 A-1 pipeline, same functions, same data):
  margin_new = |zeta(1/2+i t)| * dev(t, g) / (p8_B(t, n4(t)) + residf(t))
  dev    = min over the 500-point delta grid DG |R_closed(g, t, d) - 1|
  residf = |zeta - Kfull|,  Kfull = K * exp(Qrem) * exp(Qext)
  K      = exp(Lmain + la + i*(ar) + re_tail + i*im_tail)
  la, ar = the (0, 1e7] on-line product (float64 over the LMFDB list GN)
  re_tail, im_tail = the discrete sum over ACTUAL zeros in (1e7, G_LAST]
           of the exact per-pair log-factor (float64 terms, pairwise per
           2^25 sub-chunks, longdouble across sub-chunks) + nlt*pi in the im
  Qrem   = the dps-30 400-node log-quad (G_LAST, 1e18]
  Qext   = the dps-30 400-node log-quad (1e18, 1e30]

BUDGETS (explicit tracked numbers; the cert margin is the worst-case
propagation of these into margin_new):
  B_tail_re / B_tail_im : per term: GAM10*max(|re_t|, 0.5/A) +
     dg * |dre/dg|, dg = U64*|g| (half-ulp unit; the f64 store error
     of a zero is <= U64*|g| rounded-to-nearest... the bound uses the
     half-ulp unit times |g|), |dre/dg| = 2g/|g^2-t^2| + 2g/A + g/A^2,
     A = g^2+1/4; + LOG2SUB*2*U64*sum|re_t| per 2^25 sub-chunk (Higham
     worst-case sequential, eps = 2*U64); + nchunks*2*U128*sum|re_t|
     across chunks (longdouble).  Im channel: GAM1*|im_t| +
     LOG2CH*2*U64*sum|im_t| + dg*|d(im_t)/dg| = dg*2g*t/A^2.
  B_prod_re / B_prod_im : the GN on-line product, same model over
     n = |GN| terms + the zero-rep dg terms
     (|dla/dg| <= g/A34^2 + 2*A*g/A34^2/|inner|, A = t^2+1/4,
     A34 = 0.25+g^2; ar channel: t*(chunk + dg*2g/A34^2)).
  B_qrem / B_qext : the Platt-Trudgian two-precision pair per section
     (dps 30/400 value vs dps 60/400): B = |c30 - c60| (complex
     magnitude).  The full 4-corner ladder (30/60) x (400/800) is
     computed on one audit straddle per window; its 6-pair spreads
     are recorded in the detail file as the convergence evidence for
     the corner-spread budget.
  B_lm / B_z : dps-30 vs dps-60 agreement of the DLMF 25.2.12 main
     term and of zeta.
  B_dev : max over the 500 deltas of |dev30(d) - dev60(d)|.
  nlt counts : exact integers (float comparisons on the stored data);
     boundary guard: if ANY zero of (GN or band) lies within
     NLT_GUARD = 1e-4 of t the point is FLAGGED and its certificate
     withheld (a half-turn count error would rotate the kernel);
     expected never to trigger (straddles sit 0.5 from the anchor
     zero; next-zero spacing ~0.3).
PROPAGATION (conservative, exact exponential envelope): with
  L = |Kfull_30| at the dps-30/400 corners,
  residf_cert = |z30 - K30| + L*(exp(Bexp) - 1 + exp(Bexp)*Bph) + Bz,
  Bexp = B_tail_re + B_prod_re + |Re B_qrem + Re B_qext| + B_lm,
  Bph  = B_tail_im + B_prod_im + |Im B_qrem + Im B_qext|,
  dev_cert = max(0, dev30 - B_dev),  z_cert = max(0, |z30| - Bz),
  margin_cert = z_cert * dev_cert / (p8_B(t, n4(t)) + residf_cert).
  Claim: the true (exact-precision) margin >= margin_cert.

GATES:
  SELFTEST (H1CERT_SELFTEST=1, serial, must pass before any certified
  claim): budget CONTAINMENT on small arrays -- the f64/ld pipeline
  value + its computed budget must contain the dps-60 exact value on
  (a) a 2000-pseudo-zero tail array at a straddle t (two settings:
  stored == true, and true = stored + 0.5-ulp random offsets to
  exercise the dg representation bound), and (b) a 2000 GN-style
  product array (same two settings).  If an assertion fires the
  budget model is too small: fix the model, never weaken the
  assertion.
  PRE-REGISTERED READING (before any full-grid result is consulted):
  (C-1) margin_cert >= 1 at ALL grid points -> the H1 band (1e6, 1e9]
        is RE-ISSUED at certificate grade (KNOWN_LIMITATIONS H1 status
        updated; the screen numbers stand; the bound now carries an
        explicit eps).  Composes with the certified [1e3, 1e6] region
        to a certificate-continuous [1e3, 1e9] S1 squeeze at this grid
        density (H4 grid caveat unchanged).
  (C-2) margin_cert < 1 <= margin_computed at ISOLATED points ->
        budget-tight: reissue those points at dps-90/120 + 1600 nodes;
        record the per-point decision.
  (C-3) margin_computed < 1 at any point -> the screen claim fails at
        certificate level: the A-2/B-2 reading at the onset (dips vs
        robust interval); the Phase-1a ceiling report is the deliverable
        (prize-plan P1.2(b)).
COMPUTE, NEVER RECALL.
"""
import os
import sys
import math
import time
import numpy as np
from mpmath import mp
import concurrent.futures as cf

R_H = "/home/jsmille/Projects/rh-missing-tail"
sys.path.insert(0, R_H + "/scripts/rh")

import day023_p11c_1e7 as M
import day024_tail_hi1e9 as TH

U64 = 1.1102230246251565e-16
U128 = float(np.finfo(np.longdouble).eps) / 2.0
SUB = 33554432              # 2^25 work sub-chunk (memory-bounded; the
                            # value sums per sub in f64 pairwise and
                            # accumulates in longdouble -- the budget
                            # below models exactly this)
REMHI = "1e18"
REMHI2 = "1e30"
DG = [mp.mpf(k) / 1000 for k in range(5, 501)]
NLT_GUARD = 1e-4

LOG2SUB = float(math.ceil(math.log2(SUB)))
GAM10_64 = 10.0 * 2.0 * U64 / (1.0 - 10.0 * 2.0 * U64)
GAM1_64 = 2.0 * U64 / (1.0 - 2.0 * U64)


def n4(t):
    return int(math.ceil(31000000.0 * t ** 4))


# ----------------------------------------------------------------------
# the discrete tail with explicit budget.  Value pipeline: per 2^25
# sub-chunk, f64 pairwise np.sum of the terms, accumulated in
# longdouble across subs (the certificate is over THIS pipeline; it
# reproduces the committed sweep's values to well inside the tracked
# budget -- same ops, a coarser-then-accumulated sum).  The budget
# models exactly this: Higham pairwise bound per sub, longdouble
# cross-sub, per-term unit-roundoff, zero-representation dg terms.
# ----------------------------------------------------------------------
def tail_budget_arr(c, tf, t2):
    re = np.longdouble(0)
    im = np.longdouble(0)
    B_re = 0.0
    B_im = 0.0
    sub_abs_re_tot = np.longdouble(0)
    for i in range(0, c.size, SUB):
        cc = c[i:i + SUB]
        g2 = cc * cc
        A = g2 + 0.25
        re_t = np.log(np.abs(g2 - t2)) - np.log(A) + 0.5 / A
        im_t = tf / A
        sub_re = float(np.sum(re_t))           # f64 pairwise within sub
        sub_im = float(np.sum(im_t))
        re += np.longdouble(sub_re)            # longdouble across subs
        im += np.longdouble(sub_im)
        abs_re = np.abs(re_t)
        s_abs_re = float(abs_re.astype(np.longdouble).sum())
        s_scale = float(np.maximum(abs_re, 0.5 / A).astype(np.longdouble).sum())
        s_abs_im = float(im_t.astype(np.longdouble).sum())
        dg = U64 * np.abs(cc)
        dredg = (2.0 * cc / np.maximum(np.abs(g2 - t2), 1e-30)
                 + 2.0 * cc / A + cc / (A * A))
        dimdg = tf * 2.0 * cc / (A * A)
        B_re += (GAM10_64 * s_scale
                 + LOG2SUB * 2.0 * U64 * s_abs_re
                 + float((dg * dredg).astype(np.longdouble).sum()))
        B_im += (GAM1_64 * s_abs_im
                 + LOG2SUB * 2.0 * U64 * s_abs_im
                 + float((dg * dimdg).astype(np.longdouble).sum()))
        sub_abs_re_tot += np.longdouble(s_abs_re)
        del g2, A, re_t, im_t, abs_re, dg, dredg, dimdg
    return re, im, B_re, B_im, float(sub_abs_re_tot)


def min_zero_dist(arrs, tf):
    dmin = float("inf")
    for arr in arrs:
        i = int(np.searchsorted(arr, tf))
        lo = max(0, i - 2)
        hi = min(arr.size, i + 3)
        if lo >= hi:
            continue
        d = float(np.min(np.abs(arr[lo:hi] - tf)))
        if d < dmin:
            dmin = d
    return dmin


def tail_with_budget(T, tf):
    t2 = tf * tf
    r1, i1, br1, bi1, sa1 = tail_budget_arr(T.cache_lo, tf, t2)
    r2, i2, br2, bi2, sa2 = tail_budget_arr(T.b, tf, t2)
    nlt = T._nlt(tf)
    re = float(r1 + r2)
    im = float(i1 + i2 + nlt * np.pi)
    nsub = ((T.cache_lo.size + SUB - 1) // SUB
            + (T.b.size + SUB - 1) // SUB)
    sa = sa1 + sa2
    B_re = float(br1 + br2 + nsub * 2.0 * U128 * sa)
    B_im = float(bi1 + bi2 + nsub * 2.0 * U128 * sa
                 + 12.0 * U64 * abs(im))
    return re, im, nlt, B_re, B_im, min_zero_dist((T.cache_lo, T.b), tf)


# ----------------------------------------------------------------------
# the (0, 1e7] on-line product with explicit budget
# ----------------------------------------------------------------------
def prod_budget(gv, tf):
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


def prod_with_budget(tf):
    return prod_budget(M.GN, tf)


# ----------------------------------------------------------------------
# mp pieces
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
    """the Platt-Trudgian style two-precision pair: each section at
    dps 30/400 (the value) vs dps 60/400; B = |c30 - c60| (complex
    magnitude) per section.  With audit=True the full 4-corner ladder
    (30/60) x (400/800) is also computed and its 6-pair spreads
    returned, for the per-window convergence evidence."""
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


def cert_point(T, tf, g, audit=False):
    """one certified straddle point: all budgets + the propagated
    cert margin.  tf: float straddle height; g: float anchor zero."""
    tfs = float(tf)
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
    best = None
    for arr in (T.cache_lo, T.b):
        i = int(np.searchsorted(arr, x))
        lo = max(0, i - 2)
        hi = min(arr.size, i + 3)
        if lo >= hi:
            continue
        seg = arr[lo:hi]
        j = int(np.argmin(np.abs(seg - x)))
        v = float(seg[j])
        if abs(v - x) < 5e3 and (best is None or abs(v - x) < abs(best - x)):
            best = v
    return best


def scan_window(x):
    T = TH.tail()
    g = nearest_zero(T, x)
    g = g if g is not None else float(x)
    pts = []
    for k in range(-12, 13):
        if k == 0:
            continue
        pts.append(cert_point(T, g + k / 2.0, g, audit=(k == -12)))
    return {"x": x, "g": g, "pts": pts}


# ----------------------------------------------------------------------
# SELFTEST: budget containment (the budget is verified before trusted)
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


def selftest():
    print("SELFTEST: budget containment", flush=True)
    rng = np.random.default_rng(20260919)
    g0 = 100.0
    gam = np.sort(g0 + np.cumsum(rng.uniform(0.25, 0.40, 2000)))
    gam = gam.astype(np.float64)
    tf = 1234.6
    ok = True
    for tag, gv_true in (
        ("stored==true",
         [mp.mpf(repr(float(v))) for v in gam]),
        ("true=stored+0.5ulp",
         [mp.mpf(repr(float(v))) + mp.mpf("1.1102230246251565e-16")
          * mp.mpf(repr(float(v))) * mp.mpf(rng.choice([-1, 1]))
          for v in gam]),
    ):
        re_ex, im_ex = _tail_exact(gv_true, tf)
        t2 = tf * tf
        re_ld, im_ld, B_re, B_im, _sa = tail_budget_arr(gam, tf, t2)
        # the nlt*pi term is an EXACT integer convention, present in both
        # the pipeline and the true K: compare the sum part only.
        re_pipe = float(re_ld)
        im_pipe = float(im_ld)
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
        ("stored==true",
         [mp.mpf(repr(float(v))) for v in gv2]),
        ("true=stored+0.5ulp",
         [mp.mpf(repr(float(v))) + mp.mpf("1.1102230246251565e-16")
          * mp.mpf(repr(float(v))) * mp.mpf(rng.choice([-1, 1]))
          for v in gv2]),
    ):
        la_ex, ar_ex = _prod_exact(gv_true2, tf2)
        la_p, ar_p, B_la, B_ar, _ = prod_budget(gv2, tf2)
        err_la = abs(mp.mpf(repr(la_p)) - la_ex)
        err_ar = abs(mp.mpf(repr(ar_p)) - ar_ex)
        ok_la = bool(err_la <= mp.mpf(repr(B_la)))
        ok_ar = bool(err_ar <= mp.mpf(repr(B_ar)))
        ok = ok and ok_la and ok_ar
        print("  prod[%s]: err_la=%.3e B_la=%.3e %s | err_ar=%.3e B_ar=%.3e %s"
              % (tag, float(err_la), B_la, ok_la,
                 float(err_ar), B_ar, ok_ar), flush=True)
    print("SELFTEST: %s" % ("PASS" if ok else "FAIL -- budget too small"),
          flush=True)
    return ok


# ----------------------------------------------------------------------
def grid():
    xs = []
    x = 1.0e6
    while x <= 1.0e9 + 1.0:
        xs.append(x)
        x *= 1.08
    return xs


SMOKE = [1.0e6, 2.0e6, 4.0e7, 1.0e8, 5.0e8, 1.0e9]
OUT = os.path.join(R_H, "scripts", "rh", "out_day034_h1cert.txt")


def run():
    smoke = os.environ.get("H1CERT_SMOKE") == "1"
    T = TH.tail()
    xs = SMOKE if smoke else grid()
    work = int(os.environ.get("WORKERS", "29"))
    print("day034 H1-cert: %s grid, %d windows, workers=%d"
          % ("SMOKE" if smoke else "FULL", len(xs), work), flush=True)
    t0 = time.time()
    if work == 1:
        res = [scan_window(T, x) for x in xs]
    else:
        with cf.ProcessPoolExecutor(max_workers=work) as ex:
            res = list(ex.map(scan_window, xs))
    res.sort(key=lambda r: r["x"])
    dt = time.time() - t0
    with open(OUT, "w") as fo:
        fo.write("# day034 H1 cert %s grid wall=%.0fs workers=%d\n"
                 % ("SMOKE" if smoke else "FULL", dt, work))
        fo.write("# point detail:\n")
        for w in res:
            for p in w["pts"]:
                fo.write("%s,%.10f,%.10f,%.10f,%.10f,%.10f,%.10f,%.6f,"
                         "%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,%.3e,"
                         "%.3e,%.3e,%d,%d\n" % (
                             ("FLAG" if p["flag"] else "ok"),
                             w["x"], p["t"], p["g"], p["mnew"], p["mcert"],
                             p["residf"], p["zeta"], p["dev"], p["Bexp"],
                             p["Bph"], p["Bz"], p["Bdev"], p["Btail_re"],
                             p["Btail_im"], p["Bprod_re"], p["Bprod_im"],
                             p["Bqrem"], p["Bqext"], p["nlt"],
                             1 if p["flag"] else 0))
                if p["audit"] is not None:
                    fo.write("audit,x=%.10f,t=%.10f," % (w["x"], p["t"]))
                    for tag, coll in (("rem", p["audit"]["rem"]),
                                      ("ext", p["audit"]["ext"])):
                        fo.write("%s_spread_max=%.3e " %
                                 (tag, max(coll)))
                    fo.write("\n")
    print("%12s %12s %9s %10s %9s %9s" %
          ("x", "g", "best_mnew", "worst_mcert", "btot", "flag"))
    for w in res:
        wpts = w["pts"]
        best = max(wpts, key=lambda p: p["mnew"])
        worst = min(wpts, key=lambda p: p["mcert"])
        btot = worst["Bexp"] + worst["Bph"]
        fl = any(p["flag"] for p in wpts)
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


if __name__ == "__main__":
    if os.environ.get("H1CERT_SELFTEST") == "1":
        sys.exit(0 if selftest() else 1)
    run()
