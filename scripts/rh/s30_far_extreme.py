"""s30:  M(t)  far-extreme census  rows  at  1e8G..1e10G  (t  up
3e20)  --  PAST  the  1.5e18  boundary  of  s25.  The  boundary
was  a  conservative  guard,  not  a  math  wall:  I_far  at  3e20
meas  0.3 s  with  dps  40/60/80  in  exact  agreement,  and  the
only  real  cost  is  the  RS  zeta  channel  (~t^0.4  scaling;
measured  2070 s  at  3e18  dps-40).

Purpose:  the  g-side  window  of  the  far-count  structure  is
[2e8G,  1e11G]  (s27/s29);  rows  at  t  ~=  g0  are  the  only
leverage  that  breaks  the  position-amplitude  degeneracy.
These  rows  span  t  from  the  window  floor  (1e8G)  to  1e10G.
Every  row  carries  the  I_far  40/60/80  cross  plus  the  exact
f64  sum-accounting  check;  the  f64  trap  is  recorded  for  the
record  only  (known  bad  2M-point  discretization  at  these
heights;  the  dps-40  split  quadrature  is  authoritative).

Resume-safe:  la/re  are  looked  up  by  t  VALUE  (not  by  row
index,  which  was  a  latent  misalignment  on  resume  in
s25/s28).  zeta  dps-60  cross  at  the  extreme  heights:
separate  job  s30v.  No  RH  claim.
"""

import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

BASE = "/home/jsmille/Projects/rh-missing-tail"
G_LAST = S.G_LAST
JSON = BASE + "/tmp/s30_far_extreme.jsonl"
MD = BASE + "/tmp/s30_far_extreme.md"
CACHE = BASE + "/tmp/s30_la_re.npz"

TARGETS = [("r=%.0eG" % r, G_LAST * r) for r
           in (1e8, 3e8, 1e9, 3e9, 1e10)]


def main():
    ts = [tv for (_, tv) in TARGETS]
    t0 = time.time()
    cache_ok = False
    if os.path.exists(CACHE):
        d = np.load(CACHE)
        cts = [float(v) for v in d["ts"]]
        if cts == [float(tv) for tv in ts]:
            las = [float(v) for v in d["las"]]
            res = [float(v) for v in d["res"]]
            cache_ok = True
            print("loaded  la/re  cache  (skip  stream)   %.0f  s"
                  % (time.time() - t0), flush=True)
        else:
            print("cache  ts  mismatch  --  re-streaming", flush=True)
    if not cache_ok:
        print("streaming pass,  %d  rows  ..." % len(ts), flush=True)
        las, res = S.stream_re(ts)
        np.savez(CACHE, ts=np.array(ts, dtype=np.float64),
                 las=np.array(las, dtype=np.float64),
                 res=np.array(res, dtype=np.float64))
        print("stream done  (%.0f s)" % (time.time() - t0), flush=True)

    la_by_t = dict(zip(list(ts), las))
    re_by_t = dict(zip(list(ts), res))
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            done.add(json.loads(line)["lab"])
    for (lab, tv) in TARGETS:
        if lab in done:
            continue
        t = tv
        la, rv = la_by_t[t], re_by_t[t]   #  by  VALUE  (resume-safe)
        tf = time.time()
        lm = S.lm_re(t)
        lme = S.logmain_ex(t)
        eps = lm - lme - float(S.mre(S.mlog(S.XI0))) + S.EX_TOTAL
        with S.workdps(40):
            zabs = abs(S.mp.zeta(S.mpc(0.5, S.mpf(repr(t)))))
            lz = float(S.mlog(zabs))
        ih = S.i_far_split(t, 40)
        mval = eps + lz - lm - la - rv - ih
        rec = dict(t=t, lab=lab, eps=eps, logzeta=lz, lm=lm,
                   la=la, re=rv, I_far=ih, M=mval)
        #  I_far  40/60/80  cross  on  every  row  (cheap  here)
        for pd_ in (60, 80):
            ihx = S.i_far_split(t, pd_)
            rec["I_far_dps%d" % pd_] = ihx
            if ihx != ih:
                rec["I_far_dps%d_MISMATCH" % pd_] = True
        rec["f64_sum_match"] = (float(eps + lz - lm - la - rv - ih)
                                == mval)
        try:
            rec["I_far_trap"] = S.i_far_trap(t)
            rec["trap_vs_quad"] = rec["I_far_trap"] - ih
        except Exception as e:                #  never  kill  the  row
            rec["trap_vs_quad"] = None
            rec["trap_err"] = str(e)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[t=%.9g  (%s)]  M  =  %+.8f    eps  =  %+.3e    "
              "(row  %.0f  s)" % (t, lab, mval, eps, time.time() - tf),
              flush=True)

    recs = [json.loads(l) for l in open(JSON)]
    recs.sort(key=lambda r: r["t"])
    lines = ["#  s30:  M(t)  far-extreme  census  (1e8G..1e10G)", "",
             "M(t)  =  EPS  +  log|zeta|  -  lm  -  la  -  re  -  "
             "I_far,RVM", "",
             "| t  (t/G)  | M | eps | logzeta | I_far | trap  diff |",
             "|---|---|---|---|---|---|"]
    for r in recs:
        lines.append("| %.9g  (%.0fg) | %+.8f | %+.3e | %.6f | "
                     "%+.4e | %s |"
                     % (r["t"], r["t"] / G_LAST, r["M"], r["eps"],
                        r["logzeta"], r["I_far"],
                        None if r.get("trap_vs_quad") is None
                        else "%.3e" % r["trap_vs_quad"]))
    open(MD, "w").write("\n".join(lines) + "\n")
    print("wrote  %s" % MD, flush=True)


if __name__ == "__main__":
    main()
