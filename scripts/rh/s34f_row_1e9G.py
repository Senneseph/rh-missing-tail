"""s34f: the 1e9G census row - the first row PAST the mpmath wall.

t = 1e9 * G_LAST = 3.00010459999819776e+19  (f64 exact integer
30001045999981977600; the C table chain 3 uses the identical
value, verified bit-exact).

The zeta channel comes from the C/quad channel (scripts/rh/zetac,
s34): the mpmath RS wall on this machine is [9e18, 3e19) and
1e9G = 3.0e19 is beyond it.  Provenance recorded on the row:
  zeta_src = "C/quad zetac s34"
  logzeta  = -1.211098446310      (zetac chain 3, full RS form)
  bare_cos = ...                  (s34b chain 3, the independent
                                   bare-cosine assembly; the two
                                   must agree to ~2e-5: the
                                   rssum*S3 scale + O(t^-1/4))
No mpmath anchor exists at this height (that is why the C
channel is there); the C formula was validated against
fresh-process mpmath dps-40 to ~1e-12 at 3e17 / 7e17 / 1.5e18
and against the independent bare-cosine assembly at 5e8G
(18.85958102 bare vs 18.85956015 full, 2.1e-5 apart).

STAGGER HYGIENE: the stream pass reads the full zero ledger
through memmap (same data volume as the 5e8G row: all zeros lie
below t here).  DO NOT launch while any ~90 GB-class process is
live (the instrumented mpmath sieve runs) - the same memory
stagger rule as s31z2/s32a.  No RH claim.
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
JSON = BASE + "/tmp/s34_1e9G_row.jsonl"

# the C channel value (zetac chain 3; see the module docstring)
C_LOGZETA = -1.211098446310
C_SRC = "C/quad zetac s34 (chain 3)"


def main():
    r = 1e9
    t = G_LAST * r
    lab = "r=%.1eG" % r
    if os.path.exists(JSON):
        for line in open(JSON):
            if json.loads(line).get("lab") == lab:
                print("row already recorded - nothing to do", flush=True)
                return
    t0 = time.time()
    print("stage A:  la/re  stream  at  t  =  %.17e  (%s)  ..." % (t, lab),
          flush=True)
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
                   == mpartial,
               zeta_src=C_SRC, logzeta_c=C_LOGZETA)
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
          "(%.0f  s)" % (eps, mpartial, time.time() - tf), flush=True)
    print("stage B:  MERGE with  the  C  zeta  channel  "
          "(logzeta  =  %+.12f  from  %s)  ..." % (C_LOGZETA, C_SRC),
          flush=True)
    lz = C_LOGZETA
    M = eps + lz - lm - la - rv - ih
    mround = round(M)
    qok = abs(M - mround) < 1e-6 * max(1.0, abs(M))
    bare = None
    p = "/home/jsmille/Projects/rh-missing-tail/tmp/s34b_chain3.log"
    if os.path.exists(p):
        for line in open(p):
            if "bare-cos-form" in line:
                i = line.find("|Z| = ") + 6
                bare = float(line[i:i + 30].split()[0])
    rec2 = dict(t=t, lab=lab, stage="B_merge", eps=eps, logzeta=lz,
                lm=lm, la=la, re=rv, I_far=ih, M=M,
                M_round=mround, integer_quantized=bool(qok),
                quant_resid=M - mround,
                f64_sum_match=float(eps + lz - lm - la - rv - ih) == M,
                zeta_src=C_SRC, logzeta_c=lz, bare_cos_Z=bare,
                bare_cos_log=(None if bare is None else np.log(bare)),
                full_vs_bare=(None if bare is None
                              else abs(np.exp(lz) - bare)),
                time_total_s=time.time() - t0)
    with open(JSON, "a") as fh:
        fh.write(json.dumps(rec2) + "\n")
    print("M  =  %.8f   (integer_quantized  =  %s,  resid  =  %.3e)"
          % (M, qok, M - mround), flush=True)
    print("full  |Z|  =  %.9f   bare  |Z|  =  %s   "
          "|diff|  =  %s"
          % (np.exp(lz),
             None if bare is None else ("%.9f" % bare),
             None if bare is None else ("%.3e" % abs(np.exp(lz) - bare))),
          flush=True)
    print("ROW  =  %s" % JSON, flush=True)


if __name__ == "__main__":
    main()
