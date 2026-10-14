#!/usr/bin/env python3
"""s9:  M(t)  above  G_LAST  --  the E1 clause's actual t-domain face.

s8 measured  M(t)  =  EPS + log|zeta| - lm - la - re - I_far
(  =  true RVM tail model error over (G, 1e30],  pairLog face  )
at the  505 ledger straddle rows,  all with  t < G_LAST.  The E1
clause  (E1Clause q B  in  formal/RhAttack/E1Clause.lean)  quantifies
over  t  in  (G_LAST, U_TOP)  --  the above-G regime,  which the
ledger never covers.  This run measures it.

M(t)  is the s7 c-theorem residual  (the true zero set above  G
never has to be enumerated):

    M(t) = eps(t) + log|zeta(1/2+it)| - lm(t) - la(t) - re(t)
           - I_far,RVM(t)

  eps      = lm - log|main_exact| - ln(xi(0)) + Ex_total   (s6/s7)
  la       = sum over GN (0, 1e7]          of  f(g, t)      (f64)
  re       = sum over tail (1e7, G]        of  f(g, t)      (f64)
     f(g,t) = log|(g^2-t^2)/(g^2+1/4)| + 1/(2(g^2+1/4))
  I_far    = int_G^1e30  W_pair(g,t) Rho(g) dg   (dps-40,
             split at u = ln t  for the in-band log singularity)
  zeta     = |zeta(1/2+it)|   (dps-40,  RS)

COST MODEL:  re(t) needs one streaming pass over the 1.016e11-zero
tail  (L + A + B + C + D files,  ~815GB).  The pass is ONCE for ALL
target heights  (chunk vectorized over the t list).

HEIGHTS:
  straddle face:    t = G_LAST + k/2,  k = 1..10
      (G_LAST is a TRUE zero -- the last on-disk zero --  so these
       are provable straddle rows  t = g + k/2  at that zero)
  log-spread face:  t = G_LAST * r,  r in  1.05 .. 2.2
      (for the  M = a ln t - D + o(1)  fit:  a = 2*dK)

Resumable:  rows already in the JSONL are skipped  (the streaming
pass then computes only the missing heights).
Run:  taskset -c 0 python s9_dk_above_g.py
"""
import json
import math
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import numpy as np
import s3_ledger_recon_margin_sweep as s3
from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre, gamma
import day023_p11c_1e7 as M
import day023_taildiscrete as td

workdps(40)

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "tmp", "s9_dk_above_g.md")
JSON = os.path.join(ROOT, "tmp", "s9_dk_above_g.jsonl")

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
G_LAST = float(_mm[-1])
N_D = int(_mm.size)
del _mm

A_F = os.path.join(HERE, "hi1e9", "zeros_hi31946e6_to_1e9.f64")
B_F = os.path.join(HERE, "hi1e9", "zeros_1002e6_to_2000e6.f64")
C_F = os.path.join(HERE, "hi3e9", "zeros_2002e6_to_3000e6.f64")
D_F = os.path.join(HERE, "hi3e10", "zeros_2999e6_to_30000e6.f64")
L_ARR = td.load_g_range(1.0e7, 31946000.0)
GN = M.GN
U0 = math.log(G_LAST)
U1 = math.log(1e30)

# Ex_total  from the s6 run  (t-independent)
EX_TOTAL = None
p6 = os.path.join(ROOT, "tmp", "s6_c_closedform.jsonl")
for line in open(p6):
    r = json.loads(line)
    EX_TOTAL = float(r["Ex_m"])
    break
assert EX_TOTAL is not None
XI0 = mpf("0.5")

STRADDLE_ks = list(range(1, 11))
LOGSPREAD_rs = [1.05, 1.15, 1.30, 1.45, 1.65, 1.90, 2.20]

TARGETS = (
    [("straddle", "k=%d" % k, G_LAST + k / 2.0) for k in STRADDLE_ks]
    + [("logspread", "r=%.2f" % r, G_LAST * r) for r in LOGSPREAD_rs]
)


def lm_re(tv):
    return float(mre(s3.logmain25212(mpc(0.5, mpf(repr(tv))))))


def logmain_ex(tv):
    s = mpc(0.5, mpf(repr(tv)))
    ml = (mlog(2) + (s / 2) * mlog(mp.pi)
          - mlog(s) - mlog(s - 1) - mlog(gamma(s / 2)))
    return float(mre(ml))


def i_far_split(tv, dps=40):
    """s8's I_far with the in-band singularity at u = ln t handled:
    split the u-integral at ln t  (tanh-sinh absorbs the endpoint
    log singularity).  For  t < G  this degrades to s8's single
    quadrature  (the split point is outside the band)."""
    with workdps(dps):
        s = mpc(0.5, mpf(repr(tv)))

        def fu(u):
            g = mp.e ** u
            r1 = mpc(0.5, g)
            r2 = mpc(0.5, -g)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2))
            return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g

        lo = mp.log(mpf(repr(G_LAST)))
        hi = mp.log(mpf("1e30"))
        lt = mp.log(mpf(repr(tv)))
        if lt <= lo:
            return float(mre(mp.quad(fu, [lo, hi])))
        if lt >= hi:
            return float(mre(mp.quad(fu, [lo, hi])))
        a = float(mre(mp.quad(fu, [lo, lt])))
        b = float(mre(mp.quad(fu, [lt, hi])))
        return a + b


def i_far_trap(tv, npts=2_000_001):
    """independent f64 u-trap cross-check, region-split forms
    (cancellation-safe on each side of g = t)."""
    u = np.linspace(U0, U1, npts)
    g = np.exp(u)
    dens = (u - math.log(2 * math.pi)) / (2 * math.pi) * g
    gt = g < tv
    w = np.empty_like(g)
    q = (tv / g[~gt]) ** 2          # g >= t:  q <= 1
    w[~gt] = np.log1p(-q) - np.log1p(1.0 / (4.0 * g[~gt] * g[~gt]))
    # g < t:  log(t-g) + log(t+g) - log(g^2+1/4)   (Sterbenz-safe)
    gl = g[gt]
    w[gt] = (np.log(tv - gl) + np.log(tv + gl)
             - np.log(gl * gl + 0.25))
    return float(np.trapz(w * dens, u))


def stream_re(ts):
    """one pass over L + A + B + C + D,  chunked,  vectorized over
    the target heights.  re[j]  accumulates in longdouble."""
    re_acc = np.zeros(len(ts), dtype=np.longdouble)

    def chunk(g):
        for j, tv in enumerate(ts):
            t = float(tv)
            lt = g < t
            w = np.empty(g.shape, dtype=np.float64)
            if np.any(~lt):
                gg = g[~lt]
                q = (t / gg) ** 2
                w[~lt] = np.log1p(-q) - np.log1p(1.0 / (4.0 * gg * gg)) \
                    + 0.5 / (gg * gg + 0.25)
            if np.any(lt):
                gl = g[lt]
                w[lt] = (np.log(t - gl) + np.log(t + gl)
                         - np.log(gl * gl + 0.25)
                         + 0.5 / (gl * gl + 0.25))
            re_acc[j] += np.longdouble(np.sum(w.astype(np.float64)))

    t0 = time.time()
    # la:  GN  (0, 1e7]
    la_acc = np.zeros(len(ts), dtype=np.longdouble)
    for g in GN:
        pass  # GN is small;  do it vectorized per t instead:
    for j, tv in enumerate(ts):
        t = float(tv)
        t2 = t * t
        gg = GN.astype(np.float64)
        w = (np.log(np.abs((gg * gg - t2) / (gg * gg + 0.25)))
             + 0.5 / (gg * gg + 0.25))
        la_acc[j] = np.longdouble(np.sum(w))

    # L section  (RAM)
    L = np.ascontiguousarray(L_ARR, dtype=np.float64)
    for i in range(0, L.size, 1 << 22):
        chunk(L[i:i + (1 << 22)])
    print("  L done  (%.0f s)" % (time.time() - t0), flush=True)

    CH = 1 << 24
    for name, path, lo, hi in [
        ("A", A_F, 3.1946e7, 1.006346e9),
        ("B", B_F, 1.002146e9, 2.001746e9),
        ("C", C_F, 2.002e9, 2.999246e9),
        ("D", D_F, 2.999246e9, G_LAST),
    ]:
        mm = np.memmap(path, dtype=np.float64, mode="r")
        n = int(mm.size)
        t1 = time.time()
        for i in range(0, n, CH):
            chunk(np.ascontiguousarray(mm[i:i + CH]))
        del mm
        print("  %s (%d zeros) done  (%.0f s)"
              % (name, n, time.time() - t0), flush=True)

    return [float(v) for v in la_acc], [float(v) for v in re_acc]


def main():
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            r = json.loads(line)
            done.add(r["t"])

    todo = [(tag, lab, tv) for (tag, lab, tv) in TARGETS
            if tv not in done]
    print("targets:  %d total,  %d done,  %d todo"
          % (len(TARGETS), len(done), len(todo)), flush=True)
    if not todo:
        finish()
        return

    ts = [tv for (_, _, tv) in todo]
    print("streaming pass over the 1.016e11-zero tail  ...",
          flush=True)
    t0 = time.time()
    las, res = stream_re(ts)
    print("stream done  (%.0f s)" % (time.time() - t0), flush=True)

    for (j, (tag, lab, tv)) in enumerate(todo):
        tf = time.time()
        t = tv
        lm = lm_re(t)
        lme = logmain_ex(t)
        eps = lm - lme - float(mre(mlog(XI0))) + EX_TOTAL
        with workdps(40):
            zabs = abs(mp.zeta(mpc(0.5, mpf(repr(t)))))
            lz = float(mlog(zabs))
        ih = i_far_split(t, 40)
        mval = eps + lz - lm - las[j] - res[j] - ih
        rec = dict(t=t, tag=tag, lab=lab, lm=lm, logmain_ex=lme,
                   eps=eps, logzeta=lz, la=las[j], re=res[j],
                   I_far=ih, M=mval)
        tf2 = time.time()
        # trap cross-check on the first two rows of the pass
        if j < 2:
            rec["I_far_trap"] = i_far_trap(t)
            rec["trap_vs_quad"] = rec["I_far_trap"] - ih
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[t=%.9g  (%s %s)]  M=%+.8f  zeta+quad %ds  "
              "(row %.0f s)" % (t, tag, lab, mval, tf2 - tf,
                                time.time() - t0), flush=True)

    finish()


def finish():
    recs = [json.loads(l) for l in open(JSON)]
    if not recs:
        return
    recs.sort(key=lambda r: r["t"])
    Ms = [r["M"] for r in recs]
    ts = [r["t"] for r in recs]

    lines = ["# s9:  M(t)  above  G_LAST  (the E1 clause domain)", "",
             "M(t) = EPS + log|zeta| - lm - la - re - I_far,RVM",
             "     =  true RVM tail model error over (G, 1e30]",
             "        (pairLog face  =  E1Clause's  M_wp)", "",
             "G_LAST = %.9g" % G_LAST,
             "rows:   %d   (t from %.9g to %.9g)"
             % (len(recs), ts[0], ts[-1]), "",
             "| t | tag | lab | M | eps | logzeta |",
             "|---|-----|-----|---|-----|---------|"]
    for r in recs:
        lines.append("| %.9g | %s | %s | %+.8f | %+.3e | %.6f |"
                     % (r["t"], r["tag"], r["lab"], r["M"],
                        r["eps"], r["logzeta"]))
    lines += ["", "| stat | M |", "|---|---|",
              "| min | %+.8f |" % min(Ms),
              "| max | %+.8f |" % max(Ms),
              "| |M| max | %+.8f |" % max(abs(v) for v in Ms),
              "", "## dK fit:  M = a ln t - D   (a = 2*dK)", ""]

    # fit on the log-spread rows (the straddle rows crowd ln t)
    ls = [r for r in recs if r["tag"] == "logspread"]
    if len(ls) >= 3:
        x = np.array([math.log(r["t"]) for r in ls])
        y = np.array([r["M"] for r in ls])
        a, b = np.polyfit(x, y, 1)
        resid = max(abs(y - (a * x + b)))
        lines += ["using %d log-spread rows:" % len(ls), "",
                  "| param | value |", "|---|---|",
                  "| a = 2*dK | %+.6f |" % a,
                  "| D = -b | %.6f |" % (-b),
                  "| max abs residual | %.6f |" % resid, "",
                  "s8 below-G law  M ~= 1.242 (t/G)^2.256,  a = 2*dK"]
    lines += ["", "## B-2 headroom", "",
              "data-supported bound  B = 2;  headroom = 2 - max|M|",
              "= **%+.6f**  on the above-G face  (%d rows)."
              % (2.0 - max(abs(v) for v in Ms), len(recs)), ""]
    with open(OUT, "w") as fh:
        fh.write("\n".join(lines) + "\n")
    print("wrote %s" % OUT, flush=True)


if __name__ == "__main__":
    main()
