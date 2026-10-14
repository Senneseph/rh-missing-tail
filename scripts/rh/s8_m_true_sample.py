"""s8: sample  M(t)  =  EPS(t) + Q_engine(t) - I_far,RVM(t) - log c(t)
at ALL 505 ledger rows  (zero-height straddles,  k in -12..12,  k != 0).

M(t)  is the measurable face of the one open clause  E1
(the missing-tail bound  S = O(1)  at zero heights):  it is the
true RVM tail model error over  (G_LAST, 1e30]  at height  t.

Every other term is already certified:

    EPS(t)  = lm(t) - log|main_ex(t)| - ln(xi(0)) + Ex_total
             (  s7 main-term identity,  t-independent to ~1e-6  )
    Qeng(t) = log Kabs - lm - la - re     (ledger-exact;
             =  Re(qrem30 + qext30)  )
    I_far   = int_{G}^{1e30}  re[log(1-s/r1)+log(1-s/r2)]
                       (ln g/2pi)/2pi  dg      (RVM density)
             (  s7 kernel;  u-quad dps-40  )
    log c   = log Kabs - log zeta          (ledger:  |Kfull|/|zeta|  )

If  |M(t)|  is uniformly bounded over the 505 rows (and shows no
drift across  3.2e9 -> 2.8e10),  the open clause has its strongest
numerical support yet.  If  M grows with  t,  the route dies.

Resumable:  rows already in the JSONL are skipped.
Run:  taskset -c 1 python s8_m_true_sample.py
"""
import json
import math
import os
import sys
import time
import importlib.util

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import numpy as np
import s3_ledger_recon_margin_sweep as s3
from mpmath import mp, mpf, mpc, workdps, log as mlog, re as mre, gamma

workdps(40)

ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
OUT = os.path.join(ROOT, "tmp", "s8_m_true_sample.md")
JSON = os.path.join(ROOT, "tmp", "s8_m_true_sample.jsonl")

_mm = np.memmap(s3.D_FILE, dtype=np.float64, mode="r")
G_LAST = float(_mm[-1])
del _mm

# Ex_total  from the s6 run  (t-independent)
EX_TOTAL = None
p6 = os.path.join(ROOT, "tmp", "s6_c_closedform.jsonl")
for line in open(p6):
    r = json.loads(line)
    EX_TOTAL = float(r["Ex_m"])
    break
assert EX_TOTAL is not None

XI0 = mpf("0.5")
U0 = math.log(G_LAST)
U1 = math.log(1e30)


def lm_re(tv):
    return float(mre(s3.logmain25212(mpc(0.5, mpf(repr(tv))))))


def logmain_ex(tv):
    s = mpc(0.5, mpf(repr(tv)))
    ml = (mlog(2) + (s / 2) * mlog(mp.pi)
          - mlog(s) - mlog(s - 1) - mlog(gamma(s / 2)))
    return float(mre(ml))


def i_far(tv, dps=40):
    with workdps(dps):
        s = mpc(0.5, mpf(repr(tv)))
        def fu(u):
            g = mp.e**u
            r1 = mpc(0.5, g)
            r2 = mpc(0.5, -g)
            p = (mp.log(1 - s / r1) + mp.log(1 - s / r2))
            return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) * g
        lo = mp.log(mpf(repr(G_LAST)))
        hi = mp.log(mpf("1e30"))
        return float(mre(mp.quad(fu, [lo, hi])))


def i_far_trap(tv, npts=2_000_001):
    """independent u-trapezoid check (numpy f64),  cancellation-safe.

    The naive kernel  log|g-t| + log(g+t) - log(g^2+1/4)  is the
    difference of three terms all of size ~2u  >>  the signal
    (~ t^2/g^2);  for  u > ~45  the f64 result is pure cancellation
    noise at  +-1e10  (measured),  while the true integrand is
    < 1e-27.  Since  all ledger rows have  g >= G_LAST > t,
    use exactly  (no cancellation):  W_pair = log1p(-(t/g)^2)
                                     - log1p(1/(4 g^2)).
    """
    u = np.linspace(U0, U1, npts)
    g = np.exp(u)
    q = (tv / g) ** 2          # < 1  on the whole domain
    w = np.log1p(-q) - np.log1p(1.0 / (4.0 * g * g))
    dens = (u - math.log(2 * math.pi)) / (2 * math.pi) * g
    return float(np.trapz(w * dens, u))


def main():
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            r = json.loads(line)
            done.add((r["t"], r["g"]))

    rows = []
    for line in open(s3.LEDGER):
        r = json.loads(line)
        rows.append(r)

    t0 = time.time()
    for i, r in enumerate(rows):
        tv = float(r["t"])
        gv = float(r["g"])
        if (tv, gv) in done:
            continue
        p = r["p"]
        la = float(p["la"])
        re_ = float(p["re"])
        kabs = float(p["Kabs"])
        zeta = float(p["zeta"])

        lm = lm_re(tv)
        lme = logmain_ex(tv)
        eps = lm - lme - float(mre(mlog(XI0))) + EX_TOTAL
        qeng = math.log(kabs) - lm - la - re_
        tf = time.time()
        ih = i_far(tv, 40)
        tq = time.time() - tf
        lhs = math.log(kabs) - math.log(zeta)
        mval = eps + qeng - ih - lhs

        rec = dict(t=tv, g=gv, k=r["k"], row=r["src"],
                   lm=lm, logmain_ex=lme, eps=eps,
                   Q_engine=qeng, I_far=ih,
                   quad_s=tq, LHS=lhs, M=mval,
                   la=la, re=re_, Kabs=kabs, zeta=zeta)
        # independent trap cross-check on every 50th row
        if (i // 50) % 1 == 0 and i % 50 == 7:
            rec["I_far_trap"] = i_far_trap(tv)
            rec["trap_vs_quad"] = rec["I_far_trap"] - ih
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[%4d/505] t=%.9g  M=%+.8f  (%.0f s,  quad %.1f s)"
              % (i + 1, tv, mval, time.time() - t0, tq), flush=True)

    # ---------- summary ----------
    recs = [json.loads(l) for l in open(JSON)]
    recs.sort(key=lambda r: r["t"])
    Ms = [r["M"] for r in recs]
    ts = [r["t"] for r in recs]
    es = [r["eps"] for r in recs]

    import statistics
    def pct(v, q):
        v = sorted(v)
        i = min(len(v) - 1, int(round(q * (len(v) - 1))))
        return v[i]

    lines = ["# s8:  M(t)  at all 505 ledger rows", "",
             "M(t) = EPS(t) + Q_engine(t) - I_far,RVM(t) - log c(t)",
             "     =  true RVM tail model error  =  E1's measurable face",
             "",
             "rows:  %d    (t from %.6g to %.6g)"
             % (len(recs), ts[0], ts[-1]),
             "",
             "| stat | M | EPS |",
             "|------|---|-----|",
             "| min  | %+.9f | %+.9f |" % (min(Ms), min(es)),
             "| p01  | %+.9f | %+.9f |" % (pct(Ms, .01), pct(es, .01)),
             "| med  | %+.9f | %+.9f |" % (pct(Ms, .5), pct(es, .5)),
             "| p99  | %+.9f | %+.9f |" % (pct(Ms, .99), pct(es, .99)),
             "| max  | %+.9f | %+.9f |" % (max(Ms), max(es)),
             "| |M| max   | %+.9f | |" % max(abs(v) for v in Ms),
             "",
             "## M by height decade  (drift test)", ""]
    # bin by log10 t
    bins = {}
    for r in recs:
        b = int(round(math.log10(r["t"]) * 2) // 2)  # 0.5-decade bins
        bins.setdefault(b, []).append(r["M"])
    lines.append("| log10 t bin | n | M med | M min | M max |")
    lines.append("|---|---|---|---|---|")
    for b in sorted(bins):
        v = bins[b]
        lines.append("| %.1f | %d | %+.8f | %+.8f | %+.8f |"
                     % (b, len(v), pct(v, .5), min(v), max(v)))
    lines += ["",
              ("## fits  (window medians,  %d windows)" %
               len({round(r["g"]) for r in recs})),
              "", "| fit | params | max abs residual |",
              "|-----|--------|------------------|" ]
    import numpy as np
    from collections import defaultdict
    w = defaultdict(list)
    for r in recs: w[round(r["g"])].append(r)
    wt = [min(x["t"] for x in rs) for rs in w.values()]
    wm = [sorted(x["M"] for x in rs)[len(rs)//2] for rs in w.values()]
    Gv = G_LAST
    ln = np.log(np.array(wt)); mm = np.array(wm)
    A = np.vstack([ln, np.ones_like(ln)]).T
    clog, *_ = np.linalg.lstsq(A, mm, rcond=None)
    rlog = np.max(np.abs(A @ clog - mm))
    B = np.vstack([np.log(np.array(wt) / Gv),
                   np.ones(len(wt))]).T
    cpow, *_ = np.linalg.lstsq(B, np.log(mm), rcond=None)
    rpow = np.max(np.abs(B @ cpow - np.log(mm)))
    lines.append(
        "| M = a ln t + b  | a=%.5f b=%+.5f | %+.4f |"
        % (clog[0], clog[1], rlog))
    lines.append(
        "| M = s (t/G)^p  (log fit) | s=%.5f p=%.4f | %+.4f (in ln M) |"
        % (math.exp(cpow[1]), cpow[0], rpow))
    lines += ["",
              "window-internal spread  (max over windows of the",
              "per-window M range,  %d windows):  %+.3e"
              % (len({round(r["g"]) for r in recs}), max(
                  max(x["M"] for x in rs) - min(x["M"] for x in rs)
                  for rs in w.values())),
              ("top window  (t = 2.788e10):  %+.3e"
               % (max(x["M"] for x in w[27884282871])
                  - min(x["M"] for x in w[27884282871]))),
              ""]
    lines += ["trap cross-check rows:", ""]
    for r in recs:
        if "trap_vs_quad" in r:
            lines.append("  t=%.9g  quad-trap = %+.3e"
                         % (r["t"], r["trap_vs_quad"]))
    open(OUT, "w").write("\n".join(lines) + "\n")
    print("wrote", OUT, "  (total %d s)" % (time.time() - t0))


if __name__ == "__main__":
    main()
