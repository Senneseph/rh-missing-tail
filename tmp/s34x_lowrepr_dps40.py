#!/usr/bin/env python3
"""s34x: low-row repr-shift confirmation at dps-40 (the ORIGINAL
s25 census setting), fresh process per height.

Why:  s34w ran these probes at dps-15 and the shifts were INVISIBLE
(coarse-digit width quantization: at 6e16..6e17 the effective height
resolution is ~9..90 units) - the current values equal the exact-t
values.  The old s25 anchors were taken at dps-40
(scripts/rh/s25_M_farcensus.py: workdps(40) + mpf(repr(t))).  At
dps-40 the finer width chain should resolve the 2..48 unit shifts and
reproduce the old anchors.

Probes (fresh subprocess each - one (t, dps) per process):
  2e6G repr t-2   60002091999963950   expect -0.8770866008849694
  5e6G repr t+12  150005229999909900  expect  0.2604606616623537
  1e7G repr t+24  300010459999819800  expect  1.639866401622982
  2e7G repr t+48  600020919999639600  expect -0.4652521468916362
  2e6G EXACT ctl  60002091999963952   expect  0.8654680816359784
      (control: the exact value is dps-stable - if this one came back
      far from the canonical value, the whole audit is in trouble.)
"""
import json
import subprocess
import sys
import time

PY = "/home/jsmille/venvs/smud/bin/python"

PROBE_SRC = r'''
import json, mpmath as mp
mp.mp.dps = {dps}
z = mp.zeta(mp.mpf(0.5) + 1j * mp.mpf({t}))
print(json.dumps({{"t": {t}, "logabsz": float(mp.log(abs(z))),
                  "absz": float(abs(z))}}))
'''

PROBES = [
    ("2e6G repr t-2",  60002091999963950, -0.8770866008849694),
    ("5e6G repr t+12", 150005229999909900,  0.2604606616623537),
    ("1e7G repr t+24", 300010459999819800,  1.639866401622982),
    ("2e7G repr t+48", 600020919999639600, -0.4652521468916362),
    ("2e6G EXACT ctl", 60002091999963952,  0.8654680816359784),
]

DPS = 40

t0 = time.time()
for row, t_int, expect in PROBES:
    t1 = time.time()
    p = subprocess.run([PY, "-c", PROBE_SRC.format(dps=DPS, t=t_int)],
                       capture_output=True, text=True)
    if p.returncode != 0:
        print(json.dumps({"row": row, "error": p.stderr[-400:]}),
              flush=True)
        sys.exit(1)
    v = json.loads(p.stdout.strip().splitlines()[-1])
    print(json.dumps({"row": row, "expect_old": expect, "got": v,
                      "dt": v["logabsz"] - expect,
                      "time": round(time.time() - t1, 1)}), flush=True)
print("s34x done in %.0f s" % (time.time() - t0), flush=True)
