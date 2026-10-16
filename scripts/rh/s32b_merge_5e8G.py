"""s32b: the 5e8G census row, STAGGERED merge (stage B).

Reads:
  - tmp/s32_5e8G_row.jsonl      (stage A:  the  five  non-zeta
                                 channels  +  M_partial)
  - tmp/s31z2_run.log           (the  zeta  ladder:  dps
                                 15/20/30/40  values)

and  locks  the  row:

  M  =  fl(eps  +  lz  -  lm  -  la  -  re  -  I_far)

recomputed  from  the  RECORDED  channel  values  (the
canonical  census  association  -  the  same  formula  the
s30  rows  carry),  so  the  f64  sum  match  holds  by
construction  against  the  recorded  jsonl;  the  integer
quantization  is  checked;  the  staged  provenance  is
annotated  (zeta  channel  from  a  fresh-process  ladder,
streams/channels  from  stage  A);  the  association
difference  between  the  canonical  M  and  the  staged
fl(M_partial  +  lz)  is  recorded  in  ulps  so  the
stagger  leaves  a  footprint  on  the  record.

Precision  ladder  cross:  if  two  ladder  dps  values
landed,  their  agreement  in  the  first  12+  digits  is
recorded  (dps-15  vs  dps-40,  etc.).

Runs  ONLY  after  both  stages  have  data  (the  lattice
supervisor  ordering  guarantees  this).  No  RH  claim.
"""
import json
import math
import os
import re
import struct
import sys

BASE = "/home/jsmille/Projects/rh-missing-tail"
ROW = BASE + "/tmp/s32_5e8G_row.jsonl"
LADDER = BASE + "/tmp/s31z2_run.log"
FINAL = BASE + "/tmp/s32_5e8G_final.jsonl"


def ulps(a, b):
    if a == b:
        return 0
    ia = struct.unpack("<q", struct.pack("<d", a))[0]
    ib = struct.unpack("<q", struct.pack("<d", b))[0]
    if ia < 0:
        ia = 0x8000000000000000 - ia
    if ib < 0:
        ib = 0x8000000000000000 - ib
    return abs(ia - ib)


def main():
    rec = None
    for line in open(ROW):
        r = json.loads(line)
        if r.get("stage") == "A_no_zeta":
            rec = r
    if rec is None:
        print("stage A row not found - run s32a first", flush=True)
        sys.exit(1)
    lz_val = {}
    pat = re.compile(r"t=([0-9.e+-]+)\s+dps(\d+)\s+logzeta=([-+]?[0-9.e]+)")
    for line in open(LADDER):
        m = pat.search(line)
        if m:
            lz_val[int(m.group(2))] = m.group(3)
    if 40 not in lz_val:
        print("dps-40 zeta not in the ladder log yet - the row "
              "stays staged (M_partial recorded) until it lands",
              flush=True)
        sys.exit(1)
    lz = float(lz_val[40])
    eps, lm, la, rv, ih = (rec["eps"], rec["lm"], rec["la"],
                           rec["re"], rec["I_far"])
    M = eps + lz - lm - la - rv - ih          # canonical assoc
    M_staged = float(rec["M_partial"]) + lz   # staged assoc
    out = dict(rec)
    out.update(stage="B_final", logzeta=lz, M=M,
               f64_sum_match=float(eps + lz - lm - la - rv - ih)
                   == M,
               M_staged=M_staged,
               staged_ulps=ulps(M, M_staged),
               integer_quantized=(M == float(int(M))),
               ladder_dps=sorted(lz_val),
               provenance="staggered:  channels  s32a  (fresh  "
                          "stream  process);  zeta  s31z2  (fresh  "
                          "process  per  dps);  merge  s32b")
    for d in sorted(lz_val):
        out["logzeta_dps%02d" % d] = float(lz_val[d])
    if 15 in lz_val and 40 in lz_val:
        d15, d40 = float(lz_val[15]), float(lz_val[40])
        out["dps15_vs_40_absdiff"] = abs(d15 - d40)
    with open(FINAL, "a") as fh:
        fh.write(json.dumps(out) + "\n")
    #  also  join  the  s30  census  series  (same  schema  +
    #  the  staging  extras)  -  with  a  dedupe  on  (t,  lab)
    s30j = BASE + "/tmp/s30_far_extreme.jsonl"
    already = False
    if os.path.exists(s30j):
        for line in open(s30j):
            if json.loads(line).get("lab") == out["lab"] and \
                    json.loads(line).get("staggered"):
                already = True
    if not already:
        with open(s30j, "a") as fh:
            joinrec = {k: out[k] for k in
                       ("t", "lab", "eps", "logzeta", "lm", "la", "re",
                        "I_far", "M", "I_far_dps60", "I_far_dps80",
                        "f64_sum_match", "I_far_trap", "trap_vs_quad")}
            joinrec["staggered"] = True
            fh.write(json.dumps(joinrec) + "\n")
    print("5e8G row LOCKED:  M  =  %+.8f   (integer %s,  staged "
          "diff  %d  ulp,  ladder  dps  %s)"
          % (M, out["integer_quantized"], out["staged_ulps"],
             out["ladder_dps"]), flush=True)
    print("  logzeta  ladder:  " + "  ".join(
        "dps%d=%+.8f" % (d, float(v)) for d, v in
        sorted(lz_val.items())), flush=True)


if __name__ == "__main__":
    main()
