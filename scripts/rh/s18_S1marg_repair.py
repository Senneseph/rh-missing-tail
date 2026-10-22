"""s18:  S1MR  REPAIR - the exact-tail S1Marg extension past  3e7.

WHAT  (0152 unit,  data-side  frontier  of  the  last  mile)
  The  S1Marg  track  (formal/RhAttack/S1Marg.lean)  pins  margin
  >= 1  at  the  25  certified  real-zero  candidate  heights  in
  [1e3, 2.8e7]  of  the  P1.1e  composite
      margin(t)  =  |zeta| * min_d |R_closed(g,t,d) - 1|
                   / ( B_best(t) + |zeta - K(t)| )
  (the  day023_straddle_hi  kernel,  dps-30  per-t  quadrature).
  The  9  exploratory  rows  above  the  3e7  discrete  cache  dip
  below  1  from  3.1e7  -  but  their  (3e7, t]  zero  region  was
  carried  by  the  DENSITY  QUAD,  not  by  zeros.   The  repair:
  replace  (3e7,  3e10]  by  the  EXACT  discrete  sum  over  the
  H1  certified  files  (A:  (3.1946e7,  1.006e9],  B:  (1.002e9,
  2.002e9],  C:  (2.002e9,  2.999e9],  D:  (2.999e9,  3.0001e10]
  -  one  f64  per  zero,  strictly  increasing,  ~1.014e11  zeros)
  using  the  day023  closed-form  per-pair  factor
      (g^2-t^2)/(g^2+1/4)  *  e^{s/(g^2+1/4)},   s = 1/2+it
  (log  part:  re  =  log|g^2-t^2|/(g^2+1/4)  +  0.5/(g^2+1/4),
  im  =  t/(g^2+1/4)  +  pi*count(g<t);  the  pi  phase  is  added
  to  the  SUM  -  the  day023  branch  fix  -  never  broadcast),
  and  keep  the  dps-30  density  quad  ONLY  over  the
  genuinely  unmeasured  (3e10,  1e18]  +  the  1e18  analytic
  bound  recorded  but  NOT  added  to  K  (same  posture  as
  day023).  Same  497-d  grid,  same  k  window  [-12,12]  k!=0,
  best  =  argmax,  reissue  at  400  pts,  same  dps-30  -  so
  every  row  is  comparable  with  the  pinned  S1Marg  table  and
  the  day023  exp  rows.

MODES
  --arbiter :  3-way  verification  of  the  vectorized  per-pair
               sum  (16-thread...  no:  one-chunk  longdouble  vs
               sequential  Kahan  f64  vs  2-thread  split)  on
               A[0:5e7]  at  one  t,  plus  the  day023  s0=-2
               pinned  arbiter  on  the  (1e7,3e7]  cache.
  --part0   :  the  4  exp  rows  {3.1e7,  3.75e7,  5e7,  7.5e7}
               RE-MEASURED  with  the  exact  (3e7, t]  tail  -
               the  A/B  control:  recorded  margins  (density
               quad)  are  {0.7763,  0.6609,  0.3665,  0.5257}.
               If  the  exact  tail  lifts  3.1e7  back  above  1
               the  dip  was  a  cache-edge  model  artifact;  if
               it  stays  below  1  the  dip  is  real.  Verdict
               either  way.
  --part1   :  the  extension:  6  REAL-zero  candidates  nearest
               {1e8, 3e8, 1e9, 3e9, 1e10, 2.9e10}  (taken  from
               the  H1  files  themselves)  x  the  24
               straddles  -  the  track  extended  from  2.8e7
               toward  3e10  in  one  day-scale  run.
  --all     :  arbiter,  then  part0,  then  part1  (resumable:
               per-row  jsonl  flush  +  per-mode  stream  cache
               keyed  on  the  target  list  hash).

RESOURCES  (owner  rule:  4  logical  cores  +  16  GB  free;
pre-launch  alert  issued  in  0152):  stream  phase  <= 16
threads;  row  phase  <= 12  fork  workers  (serial  with  the
stream,  never  overlapped);  ~4  GB  peak.  ETA  part0  ~1.5h,
part1  ~2-4h.

No  zero  data  beyond  the  certified  (3.19e7,  3e10]  files  is
used;  (3e10, 1e18]  stays  the  RVM  density  model  channel
(exactly  as  in  day023/s9)  -  the  repair  narrows  the
modeled  region  from  (3e7, 1e18]  to  (3e10, 1e18].

RUN:  cd  scripts/rh  &&  python3  s18_S1marg_repair.py  --all
"""
import argparse
import hashlib
import json
import math
import os
import sys
import time

import numpy as np
from mpmath import mp

mp.dps = 30                      # the  S1Marg  certified  regime

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import day023_taildiscrete as td
import day023_p11c_1e7 as M

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
JSON = ROOT + "/tmp/s18_S1marg_repair.jsonl"
MD = ROOT + "/tmp/s18_S1marg_repair.md"

A_F = os.path.join(HERE, "hi1e9", "zeros_hi31946e6_to_1e9.f64")
B_F = os.path.join(HERE, "hi1e9", "zeros_1002e6_to_2000e6.f64")
C_F = os.path.join(HERE, "hi3e9", "zeros_2002e6_to_3000e6.f64")
D_F = os.path.join(HERE, "hi3e10", "zeros_2999e6_to_30000e6.f64")
FILE_LIST = [( "A", A_F), ("B", B_F), ("C", C_F), ("D", D_F)]

Z30 = 3.0e10                        # deepest  certified  zero
REM_HI = mp.mpf("1e18")             # same  as  the  day023  default
REM_NPTS = 200
REISSUE_NPTS = 400
DG = [mp.mpf(k) / 1000 for k in range(5, 501)]

PART0_CANDS = [(3.1e7, "3.1e7"), (3.75e7, "3.75e7"),
               (5.0e7, "5e7"), (7.5e7, "7.5e7")]
PART1_TARGETS = [1.0e8, 3.0e8, 1.0e9, 3.0e9, 1.0e10, 2.9e10]


def _files_for_band(lo, hi):
    spans = [("A", A_F, 3.1946e7, 1.006346e9),
             ("B", B_F, 1.002146e9, 2.001746e9),
             ("C", C_F, 2.002e9, 2.999246e9),
             ("D", D_F, 2.999246e9, Z30)]
    out = []
    for (n, p, a, b) in spans:
        if a < hi and b > lo:
            out.append((n, p, a, b))
    return out


def _pairlog_re_im(g, t):
    """the  per-pair  closed  form  on  one  chunk  (longdouble
    reduction,  day023  branch  fix:  pi*count(g<t)  added  to
    the  SUM,  never  broadcast).  The  re part  uses  the
    factored  (cancellation-free)  form
        log|g^2-t^2|/A  =  log|g-t|  +  log(g+t)  -  log(A),
    A  =  g^2+1/4:  at  t  ~  3e10  the  naive  g^2-t^2  loses
    ~  55  bits  when  |g-t|  <  ~2e-6  (a  whole  zero  gap's
    worth  of  danger  at  the  high  end)  and  would  silently
    corrupt  K;  the  factored  subtraction  keeps  every
    operand  at  its  own  scale.  Rows  with  bitwise  g  ==  t
    (an  f64  bucket  accident  -  a  real  zero  cannot  sit
    exactly  at  t  =  g_cand  +  k/2,  k  !=  0)  get  the
    statistical  mean  of  log|delta|  for  a  uniform  sub-ulp
    offset,  ln(ulp(t))  -  2,  instead  of  -inf."""
    A_ = g * g + 0.25
    gt = np.abs(g - t)
    nz = int(np.sum(g == t))
    if nz:
        gt = np.where(g == t, 1.0, gt)
    re_terms = np.log(gt) + np.log(g + t) - np.log(A_)
    re = float(np.sum(re_terms, dtype=np.longdouble))
    if nz:
        re += nz * (float(np.log(np.float64(np.spacing(t)))) - 2.0)
    nlt = int(np.sum(g < t))
    im = float(np.sum(t / A_, dtype=np.longdouble)) + nlt * math.pi
    return re, im


def pairlog_stream(ts, nsubs, step=(1 << 21), tag=""):
    """the  exact  (3.19e7,  3e10]  pair-log  tail  for  every  t
    in  ts:  one  vectorized  pass  per  H1  file  (the  closed
    form  is  valid  for  EVERY  zero  vs  EVERY  t  in  our
    windows;  no  band  gating  needed),  chunked,  per-thread
    longdouble  partials.  Returns  {t: (re, im)}."""
    from concurrent.futures import ThreadPoolExecutor
    tmap = {float(t): t for t in ts}

    acc = {t: [np.longdouble(0), np.longdouble(0)] for t in tmap}
    for (name, path) in FILE_LIST:
        mm = np.memmap(path, dtype=np.float64, mode="r")
        n = int(mm.size)
        per = (n + nsubs - 1) // nsubs

        def work(lo, hi):
            part = {t: [np.longdouble(0), np.longdouble(0)] for t in tmap}
            for k in range(lo, hi, step):
                c = np.ascontiguousarray(mm[k:min(k + step, hi)])
                for t in tmap:
                    r, i = _pairlog_re_im(c, float(t))
                    part[t][0] += np.longdouble(r)
                    part[t][1] += np.longdouble(i)
            return part

        t0 = time.time()
        with ThreadPoolExecutor(max_workers=nsubs) as ex:
            futures = [ex.submit(work, i * per, min((i + 1) * per, n))
                       for i in range(nsubs)]
            for fu in futures:
                part = fu.result()
                for t in tmap:
                    acc[t][0] += part[t][0]
                    acc[t][1] += part[t][1]
        del mm
        print("  %s  (%.3e  zeros)  done  (%.0f  s)  %s"
              % (name, n / 1e9, time.time() - t0, tag), flush=True)
    return {t: (float(v[0]), float(v[1])) for t, v in acc.items()}


def rem_quad(t, npts=REM_NPTS):
    """the  dps-30  density  quad  over  (3e10, 1e18]  +  the  1e18
    analytic  bound  -  exactly  the  day023  integrand  and
    bound,  lower  edge  moved  from  3e7  to  3e10  (the  repaired
    edge).  Split  at  t  when  3e10  <  t  <  1e18  (the  day023
    mid-interval  singularity  rule).  Returns  (rem,  bound)."""
    PI = td.PI
    t_0 = float(t)
    smp = mp.mpc(mp.mpf("0.5"), mp.mpf(t_0))

    def f(gg):
        r1 = mp.mpc(0.5, gg)
        r2 = mp.mpc(0.5, -gg)
        p = mp.log(1 - smp / r1) + mp.log(1 - smp / r2) \
            + smp / r1 + smp / r2
        return p * (mp.log(gg / (2 * PI)) / (2 * PI))
    lo = mp.mpf(Z30)
    t_ = abs(mp.mpf(t_0))
    pts = [lo * (REM_HI / lo) ** (mp.mpf(k) / npts)
           for k in range(npts + 1)]
    if lo < t_ < REM_HI:
        pts.append(mp.mpf(repr(float(t))))
        pts.sort()
    rem = mp.quad(f, pts)
    Bb = REM_HI
    bound = mp.mpf(t_) * t_ * (mp.log(Bb / (2 * PI)) + 1) / (2 * PI * Bb)
    return rem, bound


def margin_at(t, g, npts, re_a, im_a):
    """the  day023  composite  at  the  straddle  row  t  around
    witness  g,  with  the  REPAIRED  tail:   (1e7,3e7]  exact
    (td  cache)  +  (3e7,3e10]  exact  (pre-streamed  re_a/im_a)
    +  (3e10, 1e18]  dps-30  quad.  K-assembly  line  by  line
    identical  in  form  to  day023_straddle_hi.margin_at.
    t,  g  are  f64  floats  (t  =  f64(g_witness)  +  k/2  in
    f64);  mp.mpf(float)  converts  the  binary  value  EXACTLY
    (mp.mpf(repr(float))  is  a  ROUNDED  decimal  -  at
    t  ~  3e10  it  shifts  g/t  by  up  to  ulp/2,  corrupting
    every  log|g-t|  with  |g-t|  <  ~ulp;  the  f64  zeros
    themselves  are  only  known  to  f64,  so  the  exact
    binary  value  is  the  correct  ground  truth)."""
    tf = float(t)
    gf = float(g)
    s = mp.mpc(mp.mpf("0.5"), mp.mpf(tf))
    gmp = mp.mpf(gf)
    tmm = mp.mpf(tf)
    dev = None
    for d in DG:
        v = abs(M.R_closed(gmp, tmm, d) - 1)
        dev = v if dev is None else min(dev, v)
    z = mp.zeta(s)
    la, ar = M.product_on_line_vec(s, M.GN)
    main = M.logmain25212(s)
    re_l, im_l = td._pairlog_complex(tf, td._G_CACHE)    # (1e7, 3e7]
    rem, bound = rem_quad(tf, npts)
    tail = (mp.mpf(repr(float(re_l + re_a)))
            + 1j * mp.mpf(repr(float(im_l + im_a))) + rem)
    K = mp.e ** (main + mp.mpf(repr(float(la)))
                 + 1j * mp.mpf(repr(float(ar))) + tail)
    B = M.B_best(tmm)
    resid = abs(z - K)
    margin = abs(z) * dev / (B + resid)
    E = mp.log(abs(z)) - mp.re(mp.log(K))
    return {"margin": margin, "t": t, "g": g, "zeta": abs(z),
            "resid": resid, "B": B, "dev": dev, "E": E,
            "bound": bound,
            "tail_re": float(re_l + re_a), "tail_im": float(im_l + im_a)}


# ------------------------------------------------------------------
#  stream  cache  +  group  scan
# ------------------------------------------------------------------

def group_stream(targets, mode):
    key = (mode, tuple(float(t) for t in targets))
    h = hashlib.sha1(str(key).encode()).hexdigest()[:16]
    cache = os.path.join(ROOT, "tmp", "s18_stream_%s_%s.npz" % (mode, h))
    if os.path.exists(cache):
        d = np.load(cache)
        acc = {float(t): (float(re), float(im))
               for (t, re, im) in zip(d["t"], d["re"], d["im"])}
        print("stream  cache  hit  (~1.014e11  zeros  x  %d  "
              "targets)  %s" % (len(targets), mode), flush=True)
        return acc
    t0 = time.time()
    nsubs = int(os.environ.get("STREAM_THREADS", "16"))
    print("streaming  (3.19e7, 3e10]  exact  tail,  %d  targets,  "
          "%d  threads ..." % (len(targets), nsubs), flush=True)
    res = pairlog_stream([float(t) for t in targets], nsubs, tag=mode)
    arr_t = np.array([t for t in targets], dtype=np.float64)
    arr_re = np.array([res[float(t)][0] for t in targets], dtype="f8")
    arr_im = np.array([res[float(t)][1] for t in targets], dtype="f8")
    np.savez(cache, t=arr_t, re=arr_re, im=arr_im)
    print("stream  done  (%.0f  s)  %s" % (time.time() - t0, mode),
          flush=True)
    return res


def _row_work(item):
    (mode, acc) = _ROW_CTX
    (lab, g, k) = item
    t = float(g) + k / 2.0
    re_a, im_a = acc[t] if t in acc else acc[round(t)]
    r = margin_at(t, g, REM_NPTS, re_a, im_a)
    rec = _mpf(r)
    rec.update({"mode": mode, "lab": lab, "k": k,
                "real": mode == "part1"})
    with open(JSON, "a") as fh:
        fh.write(json.dumps(rec) + "\n")
    return rec


_ROW_CTX = None


def _mpf(r):
    out = {}
    for (k, v) in r.items():
        try:
            out[k] = float(v)
        except TypeError:
            out[k] = str(v)
    return out


def scan_group(cands, mode, acc, workers):
    rows_all = []
    todo = []
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            r = json.loads(line)
            if r.get("mode") == mode:
        # the  t  key  must  be  bit-identical  to  the  todo
        #  keys:  recompute  from  the  stored  g  and  k  (the
        #  jsonl  stores  the  f64  t  exactly,  but  recomputing
        #  is  robust  to  any  legacy  row  written  by  an  older
        #  t  convention)
                done.add((r["lab"], r["g"], float(r["g"]) +
                          r["k"] * 0.5))
    for (x, lab) in cands:
        for k in range(-12, 13):
            if k == 0:
                continue
            t = float(mp.mpf(repr(float(x))) + mp.mpf(k) / 2)
            t = float(x) + k / 2.0
            if (lab, float(x), t) not in done:
                todo.append((lab, float(x), k))
    if todo:
        import concurrent.futures as cf
        global _ROW_CTX
        _ROW_CTX = (mode, acc)
        t0 = time.time()
        with cf.ProcessPoolExecutor(max_workers=workers) as ex:
            for rec in ex.map(_row_work, todo):
                rows_all.append(rec)
                print("[%s  %s  k=%+3d  t=%-14.7g]  margin  =  %.6f"
                      "   (elapsed  %.0f  s)"
                      % (mode, rec["lab"], rec["k"], rec["t"],
                         rec["margin"], time.time() - t0),
                      flush=True)
    # whole-mode  summary  from  the  jsonl
    recs = [json.loads(l) for l in open(JSON)]
    recs = [r for r in recs if r.get("mode") == mode]
    labs = [lab for (x, lab) in cands]
    for lab in labs:
        rl = [r for r in recs if r["lab"] == lab and r["k"]]
        if rl:
            b = max(rl, key=lambda r: r["margin"])
            # reissue  the  best  row  at  400  pts  (day023
            # posture)
            if not any(r.get("reissue") for r in rl):
                g = rl[0]["g"]
                t = g + b["k"] * 0.5
                re_a, im_a = acc[t]
                br = margin_at(t, g, REISSUE_NPTS, re_a, im_a)
                bre = _mpf(br)
                bre.update({"mode": mode, "lab": lab, "k": b["k"],
                            "real": mode == "part1", "reissue": True})
                with open(JSON, "a") as fh:
                    fh.write(json.dumps(bre) + "\n")
                print("==  %s  g=%.5g:  reissue  k=%d  t=%.7g  "
                      "margin=%.6f  (%d  pts)"
                      % (mode, g, b["k"], t, bre["margin"],
                         REISSUE_NPTS), flush=True)
            else:
                print("==  %s  g=%.5g:  best  k=%d  margin=%.6f"
                      % (mode, rl[0]["g"], b["k"], b["margin"]),
                      flush=True)
    return rows_all


def part0():
    if td._G_CACHE is None:
        td.build_cache()
    cands = PART0_CANDS
    targets = [float(x) + k / 2.0
               for (x, lab) in cands for k in range(-12, 13)
               if k != 0]
    acc = group_stream(targets, "part0")
    scan_group(cands, "part0", acc,
               int(os.environ.get("ROW_WORKERS", "12")))


def part1():
    if td._G_CACHE is None:
        td.build_cache()
    picks = []
    for tv in PART1_TARGETS:
        hit = None
        for (name, path, a, b) in _files_for_band(0, Z30):
            if a <= tv < b:
                mm = np.memmap(path, dtype=np.float64, mode="r")
                n = int(mm.size)
                idx = np.linspace(0, n - 1, 40000).astype(int)
                rs = mm[idx]
                i = int(np.searchsorted(rs, tv))
                lo = int(idx[max(i - 1, 0)])
                hi = int(idx[min(i + 1, 40000 - 1)])
                seg = np.ascontiguousarray(mm[lo:hi + 1])
                g = float(seg[int(np.argmin(np.abs(seg - tv)))])
                hit = (name, g)
                del mm
                break
        if hit is None:
            raise SystemExit("no  file  covers  %g" % tv)
        picks.append((hit[1], "s18g%d" % int(round(tv / 1e6))))
    print("part1  real-zero  candidates:", flush=True)
    for (g, lab) in picks:
        print("   %s  =  %.6f" % (lab, g), flush=True)
    cands = picks
    targets = [float(x) + k / 2.0
               for (x, lab) in cands for k in range(-12, 13)
               if k != 0]
    acc = group_stream(targets, "part1")
    scan_group(cands, "part1", acc,
               int(os.environ.get("ROW_WORKERS", "12")))


def arbiter():
    """3-way  check  of  the  vectorized  per-pair  sum  on
    A[0:5e7]  at  t  =  1e8,  plus  the  day023  s0=-2  pin."""
    t = 1.0e8
    mm = np.memmap(A_F, dtype=np.float64, mode="r")
    K = 50000000
    g = np.ascontiguousarray(mm[:K])
    # (a)  one-chunk  longdouble  path  (exactly  the  stream  op)
    re_a, im_a = _pairlog_re_im(g, t)
    # (b)  sequential  Kahan  f64
    A_ = g * g + 0.25
    ratio = np.abs(g * g - t * t) / A_
    term_re = (np.log(ratio) + 0.5 / A_).astype(np.float64)
    term_im = (t / A_).astype(np.float64)
    re_s = im_s = 0.0
    cs = ct = 0.0
    for i in range(K):
        y = float(term_re[i]) - cs
        tt = re_s + y
        cs = (tt - re_s) - y
        re_s = tt
        y = float(term_im[i]) - ct
        tt = im_s + y
        ct = (tt - im_s) - y
        im_s = tt
    im_s += int(np.sum(g < t)) * math.pi
    # (c)  2-thread  split  (different  chunk  phase)
    from concurrent.futures import ThreadPoolExecutor
    def half(rng):
        lo, hi = rng
        seg = g[lo:hi]
        return _pairlog_re_im(seg, t)
    with ThreadPoolExecutor(max_workers=2) as ex:
        (h1, h2) = list(ex.map(half, [(0, K // 2), (K // 2, K)]))
    re_c = h1[0] + h2[0]
    im_c = h1[1] + h2[1]
    del mm
    print("arbiter  t=%g  K=%d  (A-file  head)" % (t, K))
    print("  (a)  chunked  longdouble:  re  =  %.12e  im  =  %.12e"
          % (re_a, im_a))
    print("  (b)  seq  Kahan  f64:      re  =  %.12e  im  =  %.12e"
          % (re_s, im_s))
    print("  (c)  2-thread  split:      re  =  %.12e  im  =  %.12e"
          % (re_c, im_c))
    ok = (abs(re_a - re_s) < 1e-7 * abs(re_s)
          and abs(im_a - im_s) < 1e-7 * abs(im_s)
          and abs(re_c - re_s) < 1e-7 * abs(re_s)
          and abs(im_c - im_s) < 1e-7 * abs(im_s))
    print("  3-way  agreement  (rel  <  1e-7):  %s" % ok)
    if td._G_CACHE is None:
        td.build_cache()
    v, _, _ = td.tail_discrete(mp.mpc(-2, 0))
    print("  day023  s0=-2  cached  part  =  %.12e   (docstring  "
          "pin  on  the  cache  part:  6.251993491674e-07)" % float(v))
    # (d)  GROUND  TRUTH:  the  closed  form  vs  direct  mpmath
    #     log(1-s/r1)+log(1-s/r2)+s/r1+s/r2  at  dps-50  on  a
    #     400-zero  subset  (checks  the  FORMULA,  which  the
    #     3-way  consistency  cannot):  for  real  t,  g:
    #     (1-s/r1)(1-s/r2)  =  (g^2-t^2)/(g^2+1/4)  exactly.
    t_d = 1.0e8
    gsub = np.ascontiguousarray(mm2 := np.memmap(A_F, dtype=np.float64,
                                                 mode="r")[37:37+400])
    s50 = mp.mpc(mp.mpf("0.5"), mp.mpf(1.0e8))
    old = mp.dps
    mp.dps = 50
    gt = mp.mpc(0)
    for gv in gsub:
        gmf = mp.mpf(float(gv))
        r1 = mp.mpc(mp.mpf("0.5"), gmf)
        r2 = mp.mpc(0.5, -gmf)
        gt += mp.log(1 - s50 / r1) + mp.log(1 - s50 / r2) \
            + s50 / r1 + s50 / r2
    mp.dps = old
    re_d = float(mp.re(gt))
    im_d = float(mp.im(gt))
    re_v, im_v = _pairlog_re_im(gsub, t_d)
    # the  closed  form  encodes  the  DAY023  branch  convention
    # (+pi  per  g  <  t);  mpmath  sums  PER-FACTOR  principal
    #  logs,  which  may  differ  by  an  integer  number  of  2*pi
    #  in  the  im  part  by  construction  -  so  compare  re
    #  strictly  and  im  modulo  2*pi  (formula  check;  the
    #  convention  itself  is  pinned  by  the  s0=-2  arbiter  pin
    #  and  the  7  real  day023  straddle  rows)  .
    twopi = 2 * math.pi
    im_shift = (im_v - im_d) / twopi
    okd = (abs(re_v - re_d) < 1e-9 * max(1, abs(re_d))
           and abs(im_shift - round(im_shift)) < 1e-9)
    print("  (d)  ground-truth  vs  closed  form  (400  zeros,"
          "  dps-50):  %s   (im  branch  offset  =  %+.0f*pi)"
          % (okd, im_shift))
    print("      mp  =  %.12e  +  %.12e  i" % (re_d, im_d))
    print("      vec =  %.12e  +  %.12e  i" % (re_v, im_v))
    del mm2
    # (e)  DANGER-REGIME  check:  at  t  =  2.9e10  the  naive
    #     g^2-t^2  form  cancels  (loses  ~55  bits  for
    #     |g-t|  <  ~2e-6);  verify  the  safe  form  against
    #     dps-50  mpmath  ground  truth  on  a  synthetic
    #     near-equal  set  (offsets  all  >  8*ulp,  i.e.
    #     well-resolved  f64  values).
    te = 2.9e10
    offs = [-3.0, -1.5, -0.6, -1.5e-3, -6e-5, -3.2e-5,
            3.2e-5, 6e-5, 1.5e-3, 0.6, 1.5, 3.0]
    ge = te + np.array(offs, dtype=np.float64)
    # drop  any  that  round  back  to  t  (they  would  be
    #  bucket  rows)
    ge = ge[ge != te]
    old50 = mp.dps
    mp.dps = 50
    se = mp.mpc(mp.mpf("0.5"), mp.mpf(te))
    gt2 = mp.mpc(0)
    for gv in ge:
        gm = mp.mpf(float(gv))
        r1 = mp.mpc(mp.mpf("0.5"), gm)
        r2 = mp.mpc(mp.mpf("0.5"), -gm)
        gt2 += mp.log(1 - se / r1) + mp.log(1 - se / r2) \
            + se / r1 + se / r2
    mp.dps = old50
    re_e = float(mp.re(gt2))
    im_e = float(mp.im(gt2))
    re_v, im_v = _pairlog_re_im(ge, te)
    okre = abs(re_v - re_e) < 1e-8 * max(1.0, abs(re_e))
    imsh = (im_v - im_e) / twopi
    okim = abs(imsh - round(imsh)) < 1e-9
    # the  naive  form  on  the  same  set  (should  FAIL  on
    #  the  small-offset  terms  -  informational  demo)
    Ae_ = ge * ge + 0.25
    naive = float(np.sum(
        np.log(np.abs(ge * ge - te * te) / Ae_) + 0.5 / Ae_,
        dtype=np.longdouble))
    print("  (e)  danger  regime  (t=2.9e10,  12  near-equal  "
          "offsets):")
    print("      mp  =  %.12e   safe = %.12e   match  =  %s"
          "  (im  shift  %+.0f*pi)" % (re_e, re_v, okre, imsh))
    print("      naive-g2-  t^2      =  %.12e   (err  %.2e)"
          % (naive, abs(naive - re_e)))
    return bool(ok) and bool(okd) and okre and okim


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--all", action="store_true")
    ap.add_argument("--part0", action="store_true")
    ap.add_argument("--part1", action="store_true")
    ap.add_argument("--arbiter", action="store_true")
    a = ap.parse_args()
    if not (a.all or a.part0 or a.part1 or a.arbiter):
        ap.print_help()
        sys.exit(2)
    if (a.all or a.arbiter) and not arbiter():
        raise SystemExit("arbiter  FAILED  -  aborting  (no  "
                         "bug-tolerant  mode)")
    if a.all or a.part0:
        part0()
    if a.all or a.part1:
        part1()
    if not os.path.exists(JSON):
        print("no row file - skipping md summary", flush=True)
        sys.exit(0)
    recs = [json.loads(l) for l in open(JSON)]
    lines = ["#  s18  S1MR  repair  (exact-tail  S1Marg  extension)", "",
             "recorded  margins  (density-quad  tail):",
             "  3.1e7  =  0.7763    3.75e7  =  0.6609",
             "  5e7    =  0.3665    7.5e7  =  0.5257    (all  "
             "'exp')", "", "best-straddle  rows  (repaired  exact  "
             "tail):", "|  mode  |  g  |  k  |  margin  |  resid  |"
             "  zeta  |", "|---|---|---|---|---|---|"]
    for r in sorted(recs, key=lambda r: r["t"]):
        if r.get("reissue"):
            continue
        lines.append("|  %s  |  %.6g  |  %+d  |  %.6f  |  %.4f  |"
                     "  %.4f  |" % (r["mode"], r["g"], r["k"],
                                    r["margin"], r["resid"],
                                    r["zeta"]))
    open(MD, "w").write("\n".join(lines))
    print("wrote  " + MD, flush=True)
