"""s34u: S21a stage-B merge orchestrator.

Parses tmp/s21a_chains.log for the C-chain results (full logzeta
lines  +  bare  |Z|  lines)  and  merges  the  rows  that  have
data,  via  s34t_farrows2.row().

Zeta  source  policy:
  *  if  the  full  channel  value  and  the  bare  value  agree
    within  the  bare  envelope  (|exp(lz_full)  -  bare|  <=
    3e-5),  use  the  FULL  value  (primary)  with  the  bare  as
    cross  -  the  s34j  pattern.
  *  if  they  DISAGREE  (a  channel  defect,  e.g.  chain  6 /
    3e21:  full  1304.59  vs  bare  1.6170),  use  the BARE
    value  as  primary  (12-digit,  envelope  ~2.5e-5  on  |Z|  ->
    ~1.5e-5  on  logzeta;  negligible  against  the  O(1e6)
    law  residual  scale)  and  flag  full_channel_defective.

Idempotent:  rows  already  B_merged  in  the  jsonl  are
skipped  (s34t  keys  on  (lab,  stage)).  No  RH  claim.
"""
import json
import math
import os
import re
import sys

import numpy as np

BASE = "/home/jsmille/Projects/rh-missing-tail"
LOG = os.path.join(BASE, "tmp/s21a_chains.log")
sys.path.insert(0, os.path.join(BASE, "scripts/rh"))

import s34t_farrows2 as T

# chain index -> r (t/G)
CHAIN_R = {6: 1e11, 7: 3e11}

def parse_chain_log(path):
    out = {c: {} for c in CHAIN_R}
    cur = None
    for line in open(path):
        if chain := re.search(r"chain (\d+) \(", line):
            cur = int(chain.group(1))
        if cur not in CHAIN_R:
            continue
        m = re.search(r"logzeta=([-\d.eE+]+)", line)
        if m:
            out[cur]["logzeta"] = float(m.group(1))
        m = re.search(r"bare-cos-form \|Z\| = ([\d.]+)", line)
        if m:
            out[cur]["bare"] = float(m.group(1))
    return out

def decide(cur):
    d = CHAIN_LOG.get(cur, {})
    r = CHAIN_R[cur]
    if "logzeta" in d and "bare" in d:
        lzb = math.log(d["bare"])
        dlog = abs(d["logzeta"] - lzb)
        #  agreement  threshold  in  the  log  domain:  the  bare
        #  envelope  ~2.5e-5  on  |Z|  is  ~1.5e-5  on  logzeta  when
        #  |Z|  =  O(1..10);  use  3e-5  (3x  margin).  Compare  in
        #  the  log  domain  -  exp  overflows  for  defective
        #  values  (1304-class).
        if dlog <= 3e-5:
            return dict(logzeta=d["logzeta"], bare=d["bare"],
                        src="C/quad full (chain %d); bare-cos cross (log diff %.1e)" % (cur, dlog),
                        full_channel_defective=False)
        return dict(logzeta=lzb, bare=d["bare"],
                    src=("bare-cos-form (chain %d) PRIMARY - full channel "
                         "logzeta %.6f DEFECTIVE (|log diff| = %.3e)"
                         % (cur, d["logzeta"], dlog)),
                    full_channel_defective=True)
    if "bare" in d:
        return dict(logzeta=math.log(d["bare"]), bare=d["bare"],
                    src="bare-cos-form (chain %d); full pending" % cur,
                    full_channel_defective=None)
    return {}

CHAIN_LOG = parse_chain_log(LOG)
for cur in sorted(CHAIN_R):
    d = decide(cur)
    if d:
        print("chain %d (r=%.0e): %s" % (cur, CHAIN_R[cur], d["src"]))
        T.ZETA_FILL[CHAIN_R[cur]] = d

def main():
    rows = [float(a) for a in sys.argv[1:]] or sorted(CHAIN_R.values())
    for r in rows:
        if r in T.ZETA_FILL:
            T.row(r)

if __name__ == "__main__":
    main()
