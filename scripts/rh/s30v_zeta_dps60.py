"""s30v:  zeta  dps-60  cross  at  the  three  extreme  s30  heights
(3e19,  9e19,  3e20)  --  the  same  algorithm  (RS  path)  at  higher
precision,  matching  the  verification  protocol  that  locked  the
s25  far  rows  (dps-40  ==  dps-60  bit-identical  at  2e7G/5e7G).
Sequenced  from  the  highest  height  down;  results  compared  to
the  corresponding  s30  census  rows  as  they  land.
No  RH  claim.
"""
import json
import sys
import time

from mpmath import mp, mpc, mpf, workdps

BASE = "/home/jsmille/Projects/rh-missing-tail"
S = None
sys.path.insert(0, BASE + "/scripts/rh")
import s9_dk_above_g as S  # noqa
G = S.G_LAST

HEIGHTS = (3e19, 9e19, 3e20)     #  t/G,  highest  first
OUT = BASE + "/tmp/s30v_zeta_dps60.jsonl"


def main():
    done = set()
    if __import__("os").path.exists(OUT):
        for line in open(OUT):
            r = json.loads(line)
            done.add(r["t"])
    for r in HEIGHTS:
        t = G * r
        if t in done:
            continue
        t0 = time.time()
        DPS = [int(x) for x in sys.argv[1].split(",")] if len(sys.argv) > 1 else [50, 60]
        rec = dict(t=t, r=r)
        ok_all = True
        for dps in DPS:
            try:
                with workdps(dps):
                    zabs = abs(mp.zeta(mpc(0.5, mpf(repr(t)))))
                    lz = float(mp.log(zabs))
                rec["logzeta_dps%d" % dps] = lz
                rec["secs_dps%d" % dps] = round(time.time() - t0, 1)
            except MemoryError:
                rec["OOM_dps%d" % dps] = True
                ok_all = False
                break
        #  compare  with  the  s30  census  row  if  it  has  landed
        jf = BASE + "/tmp/s30_far_extreme.jsonl"
        if __import__("os").path.exists(jf):
            for line in open(jf):
                c = json.loads(line)
                if c["t"] == t:
                    rec["census_logzeta_dps40"] = c["logzeta"]
                    for dps in DPS:
                        k = "logzeta_dps%d" % dps
                        if k in rec:
                            rec["diff_dps%d" % dps] = rec[k] - c["logzeta"]
        with open(OUT, "a") as fh:
            fh.write(json.dumps(rec) + "\n")
        print("t/G=%.0e  %s  (elapsed %.0f s)"
              % (r,
                 "  ".join("dps%d=%+.10f%s" % (dps, rec["logzeta_dps%d" % dps],
                     (" diff=%+.3e" % rec["diff_dps%d" % dps]))
                     if "logzeta_dps%d" % dps in rec else "dps%d=OOM" % dps
                     for dps in DPS),
                 time.time() - t0), flush=True)


if __name__ == "__main__":
    main()
