"""s25:  M(t)  far-band census  rows  at  2e6G..5e7G  (t  up
1.5e18)  --  extend  the  defect  law  beyond  the  1e6G
limit.  The  1e7G  and  5e7G  rows  reach  the  1e18  ext-
quadrature  boundary:  I_far  splits  at  ln  t,  and  the
independent  f64  trap  cross-check  flags  any  degradation
(a  bad  row  is  recorded,  never  silently  trusted).

The  defect  on  (G, 2.2G]  fits  M  =  A ln t  +  B  to  1.7e3.
Candidate  generators  (  far  discrepancy  structures  over
(G, 1e30]  )  predict  different  shapes:

  ln t        smooth  /  mild  structure
  t  ln t     constant  count  offset  above  G  (  pole  at  G )
  t^2  /  G   far-bias  family  (  kernel  -t^2/g^2  tail  )

a  sub-log  term:  the  26-row  residuals  grow  smoothly  to
-1.6e4  at  1e5G,  tentatively  fitting  -1344*(t/G)^0.217.
Rows  BEYOND  that  range  discriminate:  pure  ln  t  vs
ln  t  +  C*(t/G)^a.  Same
chain  as  s9  (  all  channels  independently  verified  ),
plus  I_far  trap  cross-check  on  every  row.
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
JSON = BASE + "/tmp/s25_M_farcensus.jsonl"
MD = BASE + "/tmp/s25_M_farcensus.md"
CACHE = BASE + "/tmp/s25_la_re.npz"

TARGETS = [("r=%.0eG" % r, G_LAST * r) for r
           in (2e6, 5e6, 1e7, 2e7, 5e7)]


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

    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            done.add(json.loads(line)["lab"])
    for (j, (lab, tv)) in enumerate(TARGETS):
        if lab in done:
            continue
        t = tv
        tf = time.time()
        lm = S.lm_re(t)
        lme = S.logmain_ex(t)
        eps = lm - lme - float(S.mre(S.mlog(S.XI0))) + S.EX_TOTAL
        with S.workdps(40):
            zabs = abs(S.mp.zeta(S.mpc(0.5, S.mpf(repr(t)))))
            lz = float(S.mlog(zabs))
        ih = S.i_far_split(t, 40)
        mval = eps + lz - lm - las[j] - res[j] - ih
        rec = dict(t=t, lab=lab, eps=eps, logzeta=lz, lm=lm,
                   la=las[j], re=res[j], I_far=ih, M=mval)
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
    lines = ["#  s16:  M(t)  at  high  t  (growth  family)", "",
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
