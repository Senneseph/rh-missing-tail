"""s10:  dead-zone  march  --  M(t)  =  log|zeta|  -  lm  -  la  -  re
      -  EPS  -  I_far,RVM  across  the  (0.929G,  G + 0.5]  gap,
where  s8  evidence  ends  (t/G  =  0.929,  M  ~  1.55)  and  s9
measures  (t  =  G + 0.5,  M  =  -8.58e7).

Rows:  six  G·r + 0.5  rows  plus  four  true  straddle  midpoints
between  consecutive  recorded  D-zeros  near  G,  plus  a
re-computation  of  the  s9  k  =  1  row  (G  +  0.5,  distance
exactly  0.5  from  the  top  zero)  for  same-code  comparison.

One  threaded  streaming  pass  over  L  +  A  +  B  +  C  +  D
(1.016e11  zeros,  ~1.7h  at  8  workers);  then  per-row  mp
pieces  (dps-40).
"""
import json
import os
import sys
import time

import s9_dk_above_g as S

G = S.G_LAST
HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
JSON = os.path.join(REPO, "tmp", "s10_deadzone_march.jsonl")
MD = os.path.join(REPO, "tmp", "s10_deadzone_march.md")

TARGETS = [
    ("r", "r=0.94",  G * 0.94 + 0.5),
    ("r", "r=0.96",  G * 0.96 + 0.5),
    ("r", "r=0.98",  G * 0.98 + 0.5),
    ("r", "r=0.99",  G * 0.99 + 0.5),
    ("r", "r=0.995", G * 0.995 + 0.5),
    ("r", "r=0.999", G * 0.999 + 0.5),
    ("mid", "mid1  G-0.899994", G - 0.899993896),
    ("mid", "mid2  G-0.588756", G - 0.588758469),
    ("mid", "mid3  G-0.330513", G - 0.330514908),
    ("mid", "mid4  G-0.080629", G - 0.080629348),
    ("s9k1", "G+0.5", G + 0.5),
]


def main():
    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            done.add(json.loads(line)["t"])
    todo = [(a, b, t) for (a, b, t) in TARGETS if t not in done]
    print("targets:  %d total,  %d done,  %d todo"
          % (len(TARGETS), len(TARGETS) - len(todo), len(todo)),
          flush=True)
    if not todo:
        finish()
        return

    ts = [t for (_, _, t) in todo]
    print("streaming pass  (1.016e11-zero  tail,  threaded)  ...",
          flush=True)
    t0 = time.time()
    las, res = S.stream_re(ts)
    print("stream done  (%.0f s)" % (time.time() - t0), flush=True)

    for (j, (tag, lab, t)) in enumerate(todo):
        tf = time.time()
        lm = S.lm_re(t)
        lme = S.logmain_ex(t)
        eps = lm - lme - float(S.mre(S.mlog(S.XI0))) + S.EX_TOTAL
        with S.workdps(40):
            lz = float(S.mlog(abs(S.mp.zeta(
                S.mp.mpc(0.5, S.mp.mpf(repr(t)))))))
        ih = S.i_far_split(t, 40)
        mval = eps + lz - lm - las[j] - res[j] - ih
        rec = dict(t=t, tag=tag, lab=lab, lm=lm, logmain_ex=lme,
                   eps=eps, logzeta=lz, la=las[j], re=res[j],
                   I_far=ih, M=mval)
        if j < 2:
            rec["I_far_trap"] = S.i_far_trap(t)
            rec["trap_vs_quad"] = rec["I_far_trap"] - ih
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[t=%.9f  (%s)]  M=%+.9f  (row %.0f s,  total %.0f s)"
              % (t, lab, mval, time.time() - tf, time.time() - t0),
              flush=True)
    finish()


def finish():
    recs = [json.loads(l) for l in open(JSON)]
    recs.sort(key=lambda r: r["t"])
    lines = ["# s10:  dead-zone  march  (0.929G,  G + 0.5]", "",
             "M(t)  =  EPS  +  log|zeta|  -  lm  -  la  -  re  -  I_far,RVM",
             "", "G_LAST  =  %.9f" % G,
             "s8  evidence  ends  at  t/G  =  0.929  (M  ~  1.55);  "
             "s9  row  at  G + 0.5  has  M  =  -8.577e7.", "",
             "| t  (t/G)  | lab  | M | logzeta |",
             "|---|---|---|---|"]
    for r in recs:
        lines.append("| %.9f  (%.6f)  | %s  | %+.9f  | %.6f |"
                     % (r["t"], r["t"] / G, r["lab"], r["M"],
                        r["logzeta"]))
    lines.append("")
    open(MD, "w").write("\n".join(lines) + "\n")
    print("wrote %s" % MD, flush=True)


if __name__ == "__main__":
    main()
