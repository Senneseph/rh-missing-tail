"""s34j: the 1e10G / 3e10G C-channel census rows (past the mpmath
wall, provenance C/quad zetac s34).  Same structure as s34f
(1e9G):  stage A = all channels except zeta (stream + lm + I_far),
stage B = merge with the C logzeta (bare-cosine cross where
available).

    1e10G  r=1e10:  logzeta = 0.455887846369   (chain 4)
    3e10G  r=3e10:  logzeta = 2.012486593295   (chain 5; bare-cos
            cross queued separately in tmp/s34b_chain5.log)

DO NOT run while any ~90 GB-class process is live (stagger rule,
as s34f).  No RH claim.
"""
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

BASE = "/home/jsmille/Projects/rh-missing-tail"
JSON = BASE + "/tmp/s34j_far_rows.jsonl"

ROWS = [
    (1e10, 0.455887846369,
     "C/quad zetac s34 (chain 4)"),
    (3e10, 2.012486593295,
     "C/quad zetac s34 (chain 5)"),
]


def row(r, lz_c, src):
    t = S.G_LAST * r
    lab = "r=%.1eG" % r
    if os.path.exists(JSON):
        for line in open(JSON):
            if json.loads(line).get("lab") == lab:
                return  # already done
    t0 = time.time()
    print("stage A:  la/re  stream  at  t  =  %.17e  (%s)  ..." % (t, lab),
          flush=True)
    las, res = S.stream_re([t])
    la, rv = float(las[0]), float(res[0])
    del las, res
    import gc
    gc.collect()
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
    lz = lz_c
    M = eps + lz - lm - la - rv - ih
    mround = round(M)
    qok = abs(M - mround) < 1e-6 * max(1.0, abs(M))
    bare = None
    p = BASE + "/tmp/s34b_chain%d.log" % (4 if r == 1e10 else 5)
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
                zeta_src=src, bare_cos_Z=bare,
                full_vs_bare=(None if bare is None
                              else abs(np.exp(lz) - bare)),
                time_total_s=time.time() - t0)
    with open(JSON, "a") as fh:
        fh.write(json.dumps(rec) + "\n")
        fh.write(json.dumps(rec2) + "\n")
    print("%s  M  =  %.8f   (integer_quantized  =  %s,  resid  =  %.3e)"
          % (lab, M, qok, M - mround), flush=True)
    print("%s  full  |Z|  =  %.9f   bare  |Z|  =  %s"
          % (lab, np.exp(lz), None if bare is None else ("%.9f" % bare)),
          flush=True)


def main():
    for r, lz_c, src in ROWS:
        row(r, lz_c, src)


if __name__ == "__main__":
    main()
