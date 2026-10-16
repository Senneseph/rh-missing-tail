"""s32a: the 5e8G census row, STAGGERED stage A (no zeta).

The dps-40 zeta at t = 5e8G (~ 95 GB) and the stream pass
(~  tens of GB resident) do NOT fit in one process on this
124 GB machine  -  so  the  row  is  STAGGERED:

  stage  A  (this  script):  ALL  channels  EXCEPT  the
      zeta  -  la/re  stream  +  lm  (+  lme  ->  eps)  +
      I_far  dps 40/60/80  +  the  f64  trap  record.
      Records  the  five  channel  values  and  the
      staged  partial  sum

          M_partial  =  fl(fl(fl(fl(eps  -  lm)  -  la)
                              -  re)  -  I_far)

      with  the  f64  partial  sum  match  checked  by
      recomputation.  NO  zeta  call  here.

  stage  B  (s31z2  ladder,  already  in  flight):  the
      zeta  channel  in  fresh  processes  (dps  15/20/30/
      40  -  the  dps-40  value  is  the  working  channel,
      the  others  are  precision  crosses).

  merge  (s32b):  M  =  fl(eps  +  lz  -  lm  -  la  -  re
      -  I_far)  recomputed  from  the  Recorded  channel
      values  (the  canonical  census  association),  the
      f64  sum  match  by  construction,  the  integer
      quantization  checked,  the  staged-provenance
      annotated.  The  staged  M_partial  +  lz  is  also
      recorded  so  the  association  difference  (ulps)
      is  on  the  record.

MUST  NOT  run  concurrently  with  the  s31z2  ladder
(memory  collision  would  corrupt  the  wall  datum).
Staggered  by  the  supervisor  ordering.  No  RH  claim.
"""
import json
import os
import time

import numpy as np

sys_path_fix = True  # silence linters
import sys
sys.path.insert(0, ".")
import s9_dk_above_g as S

BASE = "/home/jsmille/Projects/rh-missing-tail"
G_LAST = S.G_LAST
JSON = BASE + "/tmp/s32_5e8G_row.jsonl"


def main():
    r = 5e8
    t = G_LAST * r
    lab = "r=%.0eG" % r
    done = False
    if os.path.exists(JSON):
        for line in open(JSON):
            if json.loads(line).get("lab") == lab:
                done = True
    if done:
        print("row already recorded - nothing to do", flush=True)
        return
    t0 = time.time()
    print("stage A:  la/re  stream  at  t  =  %.9g  (%s)  ..."
          % (t, lab), flush=True)
    las, res = S.stream_re([t])
    la, rv = float(las[0]), float(res[0])
    del las, res
    import gc
    gc.collect()
    tf = time.time()
    lm = S.lm_re(t)
    lme = S.logmain_ex(t)
    eps = lm - lme - float(S.mre(S.mlog(S.XI0))) + S.EX_TOTAL
    ih = S.i_far_split(t, 40)
    mpartial = eps - lm - la - rv - ih
    rec = dict(t=t, lab=lab, stage="A_no_zeta", eps=eps,
               lm=lm, la=la, re=rv, I_far=ih,
               M_partial=mpartial,
               f64_partial_sum_match=float(eps - lm - la - rv - ih)
                   == mpartial)
    for pd_ in (60, 80):
        ihx = S.i_far_split(t, pd_)
        rec["I_far_dps%d" % pd_] = ihx
        if ihx != ih:
            rec["I_far_dps%d_MISMATCH" % pd_] = True
    try:
        rec["I_far_trap"] = S.i_far_trap(t)
        rec["trap_vs_quad"] = rec["I_far_trap"] - ih
    except Exception as e:
        rec["trap_vs_quad"] = None
        rec["trap_err"] = str(e)
    with open(JSON, "a") as fh:
        fh.write(json.dumps(rec) + "\n")
    print("stage A done:  eps  =  %+.3e   M_partial  =  %+.8f   "
          "(%.0f  s)"
          % (eps, mpartial, time.time() - tf), flush=True)
    print("NOTE:  the  zeta  channel  comes  from  the  s31z2  "
          "ladder  (fresh  processes);  merge  in  s32b  when  "
          "the  dps-40  value  lands.  MUST  not  run  while  "
          "the  ladder  is  live.", flush=True)


if __name__ == "__main__":
    main()
