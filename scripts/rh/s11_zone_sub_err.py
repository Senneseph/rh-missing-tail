"""s11:  zone-substitution  error  map.

For  the  data-covered  zone  ZONE  =  (0.7G,  G]  (1e10  recorded
zeros),  compute

    Z(t)  =  Sum_{g in ZONE}  pairLog(g,  t)
            -  Int_{0.7G}^{G}  pairLog(g,  t)  Rho(g)  dg      (1)

for  14  heights  t,  eight  of  which  lie  INSIDE  the  zone
(the  near/dip  regime)  and  six  outside.

This  measures,  in  the  regime  where  the  kernel  has  exactly
the  structure  of  the  (G,  1e30]  far  model  at  the  relevant
scale,  whether  the  Rho  zero-density  substitution  error  is
O(1-100)  (structurally  sound)  or  shows  1e8-scale  structure
(broken  at  0.3G  widths).  (1)  is  the  same  sum-minus-model
quantity  as  the  E1  clause's  M_wp,  relocated  into  data
territory.
"""
import json
import math
import os
import sys
import time

import numpy as np

sys.path.insert(0, ".")
from concurrent.futures import ThreadPoolExecutor

import mpmath as mp

import s9_dk_above_g as S

G = S.G_LAST
ZLO = 0.7 * G
HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
JSON = os.path.join(REPO, "tmp", "s11_zone_sub_err.jsonl")

TARGETS = [("0.71G", 0.71 * G), ("0.75G", 0.75 * G),
           ("0.80G", 0.80 * G), ("0.85G", 0.85 * G),
           ("0.90G", 0.90 * G), ("0.92G", 0.92 * G),
           ("0.94G", 0.94 * G), ("0.96G", 0.96 * G),
           ("0.98G", 0.98 * G), ("0.999G", 0.999 * G),
           ("G+0.5", G + 0.5), ("1.02G", 1.02 * G),
           ("1.05G", 1.05 * G), ("1.10G", 1.10 * G)]


def main():
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            done.add(json.loads(line)["t"])
    todo = [(lab, t) for (lab, t) in TARGETS if t not in done]
    print("targets:  %d todo" % len(todo), flush=True)
    if not todo:
        finish()
        return

    ts = [t for (_, t) in todo]
    # locate  the  index  range  in  the  D file  for  (0.7G,  G]:
    # D  is  sorted  ascending;  0.7G  =  2.1e10
    mm = np.memmap(S.D_F, dtype=np.float64, mode="r")
    n = int(mm.size)
    lo_ix = int(np.searchsorted(mm, ZLO, side="left"))
    print("D zeros in (0.7G, G]:  %d  (ix %d..%d)"
          % (n - lo_ix, lo_ix, n - 1), flush=True)

    t0 = time.time()
    acc = np.zeros(len(ts), dtype=np.longdouble)
    STEP = 1 << 24

    def chunk_local(g, a_):
        for j, tv in enumerate(ts):
            t = float(tv)
            lt = g < t
            if np.any(~lt):
                gg = g[~lt]
                q = (t / gg) ** 2
                w = (np.log1p(-q) - np.log1p(1.0 / (4.0 * gg * gg))
                     + 0.5 / (gg * gg + 0.25))
                a_[j] += np.sum(w, dtype=np.longdouble)
            if np.any(lt):
                gl = g[lt]
                w = (np.log(t - gl) + np.log(t + gl)
                     - np.log(gl * gl + 0.25)
                     + 0.5 / (gl * gl + 0.25))
                a_[j] += np.sum(w, dtype=np.longdouble)

    def work_file(nsubs=8):
        nonlocal acc
        q = (n - lo_ix) // nsubs
        def one(i):
            lo = lo_ix + i * q
            hi = (lo_ix + (i + 1) * q if i < nsubs - 1 else n)
            a_ = np.zeros(len(ts), dtype=np.longdouble)
            for k in range(lo, hi, STEP):
                chunk_local(np.ascontiguousarray(mm[k:min(k + STEP, hi)]),
                            a_)
            return a_
        with ThreadPoolExecutor(max_workers=nsubs) as ex:
            for r in ex.map(one, range(nsubs)):
                acc += r

    work_file()
    print("sum done  (%.0f s)" % (time.time() - t0), flush=True)

    loU = math.log(ZLO)
    hiU = math.log(G)
    for (j, (lab, t)) in enumerate(todo):
        tf = time.time()
        with S.workdps(40):
            smp = mp.mpc(0.5, mp.mpf(repr(t)))

            def fu(u):
                gg = mp.e ** u
                r1 = mp.mpc(0.5, gg)
                r2 = mp.mpc(0.5, -gg)
                p = mp.log(1 - smp / r1) + mp.log(1 - smp / r2)
                return mp.re(p) * (u - mp.log(2 * mp.pi)) / (2 * mp.pi) \
                    * gg

            ltu = mp.log(mp.mpf(repr(t)))
            if ltu <= mp.mpf(loU) or ltu >= mp.mpf(hiU):
                integ = float(mp.re(mp.quad(fu, [mp.mpf(loU),
                                                 mp.mpf(hiU)])))
            else:
                d = mp.mpf("3") / mp.mpf(repr(t))
                integ = float(
                    mp.re(mp.quad(fu, [mp.mpf(loU), ltu - d]))
                    + mp.re(mp.quad(fu, [ltu - d, ltu + d],
                                    method="tanh-sinh",
                                    maxsubdiv=200))
                    + mp.re(mp.quad(fu, [ltu + d, mp.mpf(hiU)])))
        zval = float(acc[j]) - integ
        rec = dict(t=t, lab=lab, zone="0.7G..G", zone_sum=float(acc[j]),
                   zone_integ=integ, Z=zval)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[t=%.6fG  %s]  Z = %+.9f  (row %.0f s)"
              % (t / G, lab, zval, time.time() - tf), flush=True)
    finish()


def finish():
    recs = sorted((json.loads(l) for l in open(JSON)),
                  key=lambda r: r["t"])
    lines = ["# s11:  zone-substitution  error  (0.7G,  G]", "",
             "Z(t)  =  Sum_{(0.7G, G]}  pairLog  -  Int  (Rho  model)",
             "", "| t  (t/G)  | regime  | zone_sum | zone_integ | Z |",
             "|---|---|---|---|---|"]
    for r in recs:
        lines.append("| %.6fG  | %s  | %+.9e  | %+.9e  | %+.9f |"
                     % (r["t"] / G, r["lab"], r["zone_sum"],
                        r["zone_integ"], r["Z"]))
    lines.append("")
    open(os.path.join(REPO, "tmp", "s11_zone_sub_err.md"),
         "w").write("\n".join(lines) + "\n")
    print("wrote s11 md", flush=True)


if __name__ == "__main__":
    main()
