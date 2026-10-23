"""s34t: the 1e11G / 3e11G C-channel census rows (extends the V3C
data frontier past 9e20).  Same structure as s34j (1e10G/3e10G):
stage A = all channels except zeta (stream + lm + I_far), stage B =
merge with the C logzeta (bare-cosine cross).

    1e11G  r=1e11:  logzeta from tmp/s21a_chains.log  (chain 6)
    3e11G  r=3e11:  logzeta from tmp/s21a_chains.log  (chain 7)

Stage A needs no zeta:  run with ZETA_FILL = {} (or before the C
run).  Stage B merges:  run with ZETA_FILL populated from the C
log (full-channel logzeta lines) + bare values.

Three-term law prediction (closed form, NOT a fit; 0153/0165):
M(r) = A3 ln t + B3 + C t^2,  A3 = -25254354,  B3 = 523472285,
C = -(ln(U/(2 pi)) + 1)/(2 pi U), U = 1e30.
  predicted M(3e21) ~= -9.775e13,  M(9e21) ~= -8.80e14
The rows are a genuine test of the 3-term law at the next notch.
No RH claim.
"""
import json
import os
import sys
import time

import numpy as np

sys.path.insert(0, ".")
import s9_dk_above_g as S

BASE = "/home/jsmille/Projects/rh-missing-tail"
JSON = BASE + "/tmp/s34t_far_rows.jsonl"

ZETA_FILL = {}  # r -> dict(logzeta=float, bare=float, src=str); fill for stage B

A3 = -25254354.0
B3 = 523472285.0
U_TOP = 1e30
C3 = -(np.log(U_TOP / (2.0 * np.pi)) + 1.0) / (2.0 * np.pi * U_TOP)

ROWS = [
    1e11,
    3e11,
]


def law_pred(t):
    return A3 * np.log(t) + B3 + C3 * t * t


def row(r):
    t = S.G_LAST * r
    lab = "r=%.1eG" % r
    done = {}
    if os.path.exists(JSON):
        for line in open(JSON):
            d = json.loads(line)
            done[(d["lab"], d["stage"])] = d
    lz = ZETA_FILL.get(r, {})
    if (lab, "A_no_zeta") not in done and (lab, "B_merge") not in done:
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
        rec["law_pred_M"] = law_pred(t)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("%s  M_partial(no zeta)  =  %.8f   law  M  =  %.6e   "
              "(C  zeta  expected  ~  %.6e)   %.0f s"
              % (lab, mpartial, law_pred(t), law_pred(t) - mpartial,
                 time.time() - t0), flush=True)
    else:
        rec = done[(lab, "A_no_zeta")]
        eps, lm, la, rv, ih = (rec["eps"], rec["lm"], rec["la"],
                               rec["re"], rec["I_far"])
    if (lab, "B_merge") not in done and lz:
        lz_c = lz["logzeta"]
        M = eps + lz_c - lm - la - rv - ih
        mround = round(M)
        qok = abs(M - mround) < 1e-6 * max(1.0, abs(M))
        bare = lz.get("bare")
        lawp = law_pred(t)
        rec2 = dict(t=t, lab=lab, stage="B_merge", eps=eps, logzeta=lz_c,
                    lm=lm, la=la, re=rv, I_far=ih, M=M,
                    M_round=mround, integer_quantized=bool(qok),
                    quant_resid=M - mround,
                    f64_sum_match=float(eps + lz_c - lm - la - rv - ih) == M,
                    zeta_src=lz.get("src", "C/quad zetac s34"),
                    bare_cos_Z=bare,
                    full_vs_bare=(None if bare is None
                                  else abs(np.exp(lz_c) - bare)),
                    law_pred_M=lawp, M_minus_law=M - lawp,
                    law_margin_pct=abs(M - lawp) / abs(lawp) * 100.0)
        with open(JSON, "a") as fh:
            fh.write(json.dumps(rec2) + "\n")
        print("%s  M  =  %.8f   (integer_quantized  =  %s,  resid  =  %.3e)"
              % (lab, M, qok, M - mround), flush=True)
        print("%s  full  |Z|  =  %.9f   bare  |Z|  =  %s"
              % (lab, np.exp(lz_c),
                 None if bare is None else ("%.9f" % bare)), flush=True)
        print("%s  M  -  law  =  %.6e   (%.4f%%  of  law  magnitude)"
              % (lab, M - lawp, abs(M - lawp) / abs(lawp) * 100.0),
              flush=True)


def main():
    for r in ROWS:
        row(r)


if __name__ == "__main__":
    main()
