"""s16:  M(t)  at  high  t  --  the  growth-family  discriminator.

The  defect  on  (G, 2.2G]  fits  M  =  A ln t  +  B  to  1.7e3.
Candidate  generators  (  far  discrepancy  structures  over
(G, 1e30]  )  predict  different  shapes:

  ln t        smooth  /  mild  structure
  t  ln t     constant  count  offset  above  G  (  pole  at  G )
  t^2  /  G   far-bias  family  (  kernel  -t^2/g^2  tail  )

Four  geometric  rows  (  10G,  50G,  100G,  1000G  )  give  3.5
ln-decades  of  leverage  to  separate  the  families.  Same
chain  as  s9  (  all  channels  independently  verified  ),
plus  I_far  trap  cross-check  on  every  row.
"""
import json
import os
import sys
import time

sys.path.insert(0, ".")
import s9_dk_above_g as S

G_LAST = S.G_LAST
JSON = "tmp/s16_M_far.jsonl"
MD = "tmp/s16_M_far.md"

TARGETS = [("r=%.0fG" % r, G_LAST * r) for r in (10, 50, 100, 1000)]


def main():
    ts = [tv for (_, tv) in TARGETS]
    t0 = time.time()
    print("streaming pass,  %d  rows  ..." % len(ts), flush=True)
    las, res = S.stream_re(ts)
    print("stream done  (%.0f s)" % (time.time() - t0), flush=True)

    for (j, (lab, tv)) in enumerate(TARGETS):
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
