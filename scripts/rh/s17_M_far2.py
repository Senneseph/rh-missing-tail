"""s17:  M(t)  at  FAR-HIGH  t  --  the  E1ClauseV3  defect-law
extension  (the  data-side  frontier  of  the  last  mile).

The  21-row  measured  face  (s9  x17  +  s16  x4,  2026-10-15)  fits
M(t)  =  A*ln t  +  B  to  6704.088  (pinned  in-tree  as
E1ClauseV3  with  defect_A  =  -25256007,  defect_B  =  523513775)
on  (G_LAST,  T_MEAS  =  1000*G_LAST  =  3.0001e13].  The  machine
zeta  channel  runs  to  9e18  (0085  verdict:  dps-40  fits  at
9e18,  OOMs  fresh  at  3e19)  --  a  5.5-decade  gap  with  NO
measured  rows.  This  run  measures  12  new  rows  on
(3.16e13,  9e18]  (half-decade  spacing  +  the  9e18  wall
probe  LAST,  so  earlier  rows  are  flushed  first)  and  re-fits
the  three  growth  families  (s16  discriminators)  over  the  full
G  ->  9e18  span:

  F1  M  =  A*ln t  +  B                          (smooth  ln-t)
  F2  M  =  A*ln t  +  B  +  C*(t*ln t)/G         (pole-at-G)
  F3  M  =  A*ln t  +  B  +  C*(t/G)^2            (far-bias)

Same  chain  as  s16  (eps  +  log|zeta|  -  lm  -  la  -  re  -
I_far,  dps-40  quad  channel  certified,  f64  u-trap
cross-check  independent).  No  zero  data  beyond  the  (0, 3e10]
certified  files  --  the  far  zeros  (3e10,  1e30]  are  carried
by  the  I_far  RVM  model  channel,  exactly  as  in  s9/s16.

RUN:  cd  scripts/rh  &&  python3  s17_M_far2.py
"""
import json
import math
import os
import sys
import time

import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

BASE = "/home/jsmille/Projects/rh-missing-tail"
G = S.G_LAST
JSON = BASE + "/tmp/s17_M_far2.jsonl"
MD = BASE + "/tmp/s17_M_far2.md"
CACHE = BASE + "/tmp/s17_la_re.npz"

# 11 half-decade rows (3.16e13 .. 3.16e18) + the wall probe LAST
TARGETS = [("10p%d" % k, 10.0 ** (13.5 + 0.5 * k)) for k in range(11)]
TARGETS.append(("wall9e18", 9.0e18))


def main():
    ts = [tv for (_, tv) in TARGETS]
    t0 = time.time()
    if os.path.exists(CACHE):
        d = np.load(CACHE)
        las = [float(v) for v in d["las"]]
        res = [float(v) for v in d["res"]]
        assert len(las) == len(ts), "stale cache"
        print("loaded  la/re  cache   %.0f  s" % (time.time() - t0),
              flush=True)
    else:
        print("streaming  pass,  %d  rows  ..." % len(ts), flush=True)
        las, res = S.stream_re(ts)
        np.savez(CACHE, las=np.array(las, dtype=np.float64),
                 res=np.array(res, dtype=np.float64))
        print("stream  done  (%.0f  s)" % (time.time() - t0), flush=True)

    done = set()
    if os.path.exists(JSON):
        for line in open(JSON):
            done.add(json.loads(line)["lab"])
    for (j, (lab, t)) in enumerate(TARGETS):
        if lab in done:
            continue
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
        except Exception as e:          #  never  kill  the  row
            rec["trap_vs_quad"] = None
            rec["trap_err"] = str(e)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("[t=%.9g  (%s)]  M  =  %+.8f    eps  =  %+.3e    "
              "(row  %.0f  s)" % (t, lab, mval, eps, time.time() - tf),
              flush=True)

    # -- family  re-fit  over  the  full  G  ->  9e18  span  -------
    old = []
    for f in ("s9_dk_above_g.jsonl", "s16_M_far.jsonl"):
        p = os.path.join(BASE, "tmp", f)
        for line in open(p):
            r = json.loads(line)
            if "M" in r and "t" in r:
                old.append((r["t"], r["M"]))
    new = []
    for line in open(JSON):
        r = json.loads(line)
        if "M" in r and "t" in r:
            new.append((r["t"], r["M"]))
    allr = old + new
    allr.sort()
    ta = np.array([p[0] for p in allr])
    Ma = np.array([p[1] for p in allr])
    ln = np.log(ta)
    fit = {}
    # F1:  A ln t + B
    c1 = np.polyfit(ln, Ma, 1)
    r1 = np.abs(Ma - (c1[0] * ln + c1[1]))
    fit["F1_lnt"] = (c1[0], max(r1), int(np.argmax(r1)))
    # F2:  +  C*(t ln t)/G
    X2 = np.column_stack([ln, np.ones_like(ln), (ta * ln) / G])
    c2 = np.linalg.lstsq(X2, Ma, rcond=None)[0]
    r2 = np.abs(X2 @ c2 - Ma)
    fit["F2_tln"] = (c2, max(r2), int(np.argmax(r2)))
    # F3:  +  C*(t/G)^2
    X3 = np.column_stack([ln, np.ones_like(ln), (ta / G) ** 2])
    c3 = np.linalg.lstsq(X3, Ma, rcond=None)[0]
    r3 = np.abs(X3 @ c3 - Ma)
    fit["F3_t2"] = (c3, max(r3), int(np.argmax(r3)))

    lines = ["#  s17:  M(t)  far-high  extension  (E1ClauseV3  "
             "defect-law  frontier)", "",
             "G  =  %.9g,  span  G  ->  %.3g,  %d  rows  (%d  old  "
             "+  %d  new)" % (G, ta[-1], len(allr), len(old), len(new)),
             "",
             "|  t  (t/G)  |  M  |  F1  resid  |",
             "|---|---|---|"]
    f1 = c1[0] * ln + c1[1]
    for i, (t, m) in enumerate(allr):
        lines.append("|  %.9g  (%.4g)  |  %+.6f  |  %+.3f  |"
                     % (t, t / G, m, m - f1[i]))
    lines += ["", "##  family  re-fits  (full  span)", "",
              "F1  A*ln t + B:        A  =  %.4f   max|resid|  =  %.4f"
              "  (at  t  =  %.4g)" % (fit["F1_lnt"][0], fit["F1_lnt"][1],
                                      ta[fit["F1_lnt"][2]]),
              "   --  pinned  in-tree  value  A  =  -25256007  "
              "(21-row  fit)", "",
              "F2  +  C*(t ln t)/G:   C  =  %.4e   max|resid|  =  %.4f"
              "  (at  t  =  %.4g)" % (fit["F2_tln"][0][2],
                                      fit["F2_tln"][1],
                                      ta[fit["F2_tln"][2]]),
              "F3  +  C*(t/G)^2:      C  =  %.4e   max|resid|  =  %.4f"
              "  (at  t  =  %.4g)" % (fit["F3_t2"][0][2],
                                      fit["F3_t2"][1],
                                      ta[fit["F3_t2"][2]]),
              ""]
    open(MD, "w").write("\n".join(lines))
    print("wrote  " + MD, flush=True)


if __name__ == "__main__":
    main()
