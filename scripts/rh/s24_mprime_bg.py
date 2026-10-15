#!/usr/bin/env python
"""s24:  the  M-prime  face  BELOW  G  (Phase  2  of  the

sample->uniform  bridge;  the  B  =  2  face).

28  stratified  targets  in  (0.108G,  0.9294G)  (saved  at
tmp/s24_targets.npy,  8  dense  in  the  0.27..0.47G  big-gap
region  where  the  s8  rows  skip  0.19G).  The  face  is
pure  M-prime  (NO  defect  subtraction  below  G):
    L1  =  max  |M-prime|   and
  uniform  bound  =  1.5555  +  L1  *  5.809927e9  (s8  row
  face  +  s8  max  gap).  Same  channel  stack  as  s23.

    M'_wp(t)  =  eps'  +  logzeta'  -  lm'  -  dsum  -  I_far'

channel  by  channel:
    dsum    =  sum  over  ALL  certified  zeros  g <=  G  of
               2t/(t^2  -  g^2)     [= (la+re)',  streamed,
               longdouble  accumulators]
    lm'     =  central  difference  of  the  dps  main  term
    I_far'  =  central  difference  of  the  dps-40  far  quad
    logzeta'  =  dps  central  difference  of  log zeta
    eps'    =  dps  central  difference  of  the  closure
               residual  channel

Then  the  residual  face
    r'(t)  =  M'_wp(t)  -  A/t     (A  =  -2.525484e7,
            the  28-row  law  constant)
and  the  Lipschitz  face  L  =  max  |r'|  on  the  clause
domain  (G,  1000*G].

Precision  note:  t  enters  at  f64  (jsonl  rows),  so
lm'  carries  the  G_LAST  certification  floor
(lm''*3.3e-6*r  per  row,  ~0.1  worst  case  at  1000G);
that  floor  is  REPORTED  per  row,  not  hidden.
"""
import json
import os
import sys
import time

import numpy as np
from mpmath import mp, workdps, mpf, mpc
from mpmath import log as mlog, re as mre

sys.path.insert(0, ".")
import s9_dk_above_g as S

mp.dps = 40
BASE = "/home/jsmille/Projects/rh-missing-tail"
G = S.G_LAST
T_MEAS = 1000.0 * G
JSON = BASE + "/tmp/s24_mprime_below_g.jsonl"
MD = BASE + "/tmp/s24_mprime_below_g.md"
CACHE = BASE + "/tmp/s24_dsum.npz"


def load_targets():
    targ = np.load(os.path.join(BASE, "tmp/s24_targets.npy"))
    return [(float(t), None) for t in targ]


def dsum_stream(ts):
    """one pass over  L + A + B + C + D  (GN  in  RAM):
    dsum[j]  =  sum  2t/(t^2  -  g^2)."""
    n = len(ts)
    acc = np.zeros(n, dtype=np.longdouble)

    def chunk_local(g, a):
        for j, tv in enumerate(ts):
            t = float(tv)
            w = 2.0 * t / (t * t - g * g)
            a[j] += np.longdouble(np.sum(w))

    from concurrent.futures import ThreadPoolExecutor

    gg = S.GN.astype(np.float64)
    t0 = time.time()
    step = 1 << 21
    for k in range(0, gg.size, step):
        c = np.ascontiguousarray(gg[k:min(k + step, gg.size)])
        chunk_local(c, acc)
    print("  GN (%d zeros) done  (%.0f s)" % (gg.size, time.time() - t0),
          flush=True)

    def work_file(arr, nn, nsubs=8, step=1 << 23):
        nonlocal acc
        q = nn // nsubs

        def one(i):
            lo = i * q
            hi = (i + 1) * q if i < nsubs - 1 else nn
            a = np.zeros(n, dtype=np.longdouble)
            for k in range(lo, hi, step):
                chunk_local(
                    np.ascontiguousarray(arr[k:min(k + step, hi)]), a)
            return a

        with ThreadPoolExecutor(max_workers=nsubs) as ex:
            for r in ex.map(one, range(nsubs)):
                acc += r

    L = np.ascontiguousarray(S.L_ARR, dtype=np.float64)
    work_file(L, L.size, nsubs=4)
    print("  L done  (%.0f s)" % (time.time() - t0), flush=True)
    for name, path in [("A", S.A_F), ("B", S.B_F),
                       ("C", S.C_F), ("D", S.D_F)]:
        mm = np.memmap(path, dtype=np.float64, mode="r")
        work_file(mm, mm.size, nsubs=8)
        del mm
        print("  %s done  (%.0f s)" % (name, time.time() - t0),
              flush=True)
    return [float(v) for v in acc]


def lm_prime(tv):
    """dps central difference of the main term,  mpf  throughout
    (an  f64  cast  would  floor  the  derivative  at  ulp(lm)/h)."""
    tv = float(tv)
    h = mpf(repr(tv)) * mpf("1e-11")

    def re_lm(x):
        with workdps(50):
            return mp.re(S.s3.logmain25212(mpc(0.5, mpf(repr(x)))))
    a = re_lm(tv + float(h))
    b = re_lm(tv - float(h))
    return float((a - b) / (2 * h))


def ifar_prime(tv):
    tv = float(tv)
    h = max(1.0, tv * mpf("1e-10"))
    a = S.i_far_split(tv + float(h), 40)
    b = S.i_far_split(tv - float(h), 40)
    return (a - b) / (2.0 * float(h))


def logzeta_prime(tv):
    tv = float(tv)
    h = 1.0e-2 if tv < 1e12 else 1.0
    with workdps(40):
        def lg(x):
            return mp.re(mlog(abs(mp.zeta(mpc(0.5, mpf(repr(x)))))))
        a = lg(tv + h)
        b = lg(tv - h)
    return float((a - b) / (2.0 * h))


def eps_prime(tv):
    """dps  closure  residual,  mpf  throughout  (the  f64  eps
    of  the  stream  run  is  only  good  to  ulp(lm)  up  in
    the  far  rows;  the  derivative  would  inherit  it)."""
    tv = float(tv)
    h = 1.0e-2 if tv < 1e12 else 10.0

    def epsat(x):
        with workdps(50):
            s = mpc(0.5, mpf(repr(x)))
            lm = mp.re(S.s3.logmain25212(s))
            mle = mp.re(mlog(2) + mp.re(s / 2) * mlog(mp.pi)
                        - mlog(s) - mlog(s - 1)
                        - mlog(mp.gamma(s / 2)))
            return lm - mle - mlog(mpf("0.5")) + mpf(repr(S.EX_TOTAL))
    a = epsat(tv + h)
    b = epsat(tv - h)
    return float((a - b) / (2.0 * h))


def main():
    targets = load_targets()
    print("%d  targets" % len(targets), flush=True)
    ts = [t for (t, _) in targets]
    t0 = time.time()
    ok = False
    if os.path.exists(CACHE):
        d = np.load(CACHE)
        if [float(v) for v in d["ts"]] == [float(v) for v in ts]:
            dsums = [float(v) for v in d["ds"]]
            ok = True
            print("loaded  dsum  cache  (%.0f s)" % (time.time() - t0),
                  flush=True)
    if not ok:
        print("streaming  dsum  pass,  %d  targets  ..." % len(ts),
              flush=True)
        dsums = dsum_stream(ts)
        np.savez(CACHE, ts=np.array(ts, dtype=np.float64),
                 ds=np.array(dsums, dtype=np.float64))
        print("dsum  stream  done  (%.0f s)" % (time.time() - t0),
              flush=True)

    out = []
    lines = ["#  s24   M-prime  face  below  G", ""]
    print("t/G            M'          f64-t  floor")
    for (t, M), ds in zip(targets, dsums):
        t_f = t
        import math as _m
        dp_lm = (0.5 * _m.log(t_f / 2) + 1.5) * (3.3e-6 * (t_f / G) + 1.1e-16 * t_f)
        lmpr = lm_prime(t_f)
        ifpr = ifar_prime(t_f)
        lzpr = logzeta_prime(t_f)
        epr = eps_prime(t_f)
        mp_ = epr + lzpr - lmpr - ds - ifpr
        rec = {"t": t_f, "Mprime": mp_, "lmpr": lmpr, "dsum": ds,
               "ifarpr": ifpr, "logzetapr": lzpr, "epspr": epr,
               "gpert_floor": dp_lm}
        out.append(rec)
        lines.append("t/G  =  %.6e   M'  =  %+.6e" % (t_f / G, mp_))
        print("%12.6f   %+14.6e   %8.1e"
              % (t_f / G, mp_, dp_lm), flush=True)

    with open(JSON, "w") as f:
        for r in out:
            f.write(json.dumps(r) + "\n")
    L1 = max(abs(r["Mprime"]) for r in out)
    Dv1 = 5.809927e9
    lines += [
        "",
        "L1  face  (max  |M-prime|  over  %d  stratified  rows):" % len(out),
        "    L1  =  %.6e" % L1,
        "uniform  bound  candidate  (s8  row  face  +  gap):",
        "    1.5555  +  L1  *  %.4e  =  %.6e" % (Dv1, 1.5555 + L1 * Dv1),
    ]
    open(MD, "w").write("\n".join(lines) + "\n")
    print()
    print("wrote  %s" % JSON)
    print("wrote  %s" % MD)


if __name__ == "__main__":
    main()
