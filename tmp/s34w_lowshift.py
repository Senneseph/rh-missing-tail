#!/usr/bin/env python3
"""s34w: low-row REPR-t shift tests (fresh mpmath, one process each).

The old census low anchors were taken at mpf(repr(f64 t)) -- the decimal
repr height, offset from the row's exact f64 t by a few units:

  2e6G: t exact 60002091999963952   repr t = t - 2
  5e6G: t exact 150005229999909888  repr t = t + 12
  1e7G: t exact 300010459999819776  repr t = t + 24

Old recorded anchors (expect them back from these runs):
  2e6G: -0.8770866008849694
  5e6G:  0.2604606616623537
  1e7G:  1.639866401622982

Proven mechanism (s34p 5e7G, s34u/s34v 1e8G/3e8G): the old anchors are
true mpmath values at the repr height, and mpmath is not corrupted.
"""
import json
import time

import mpmath as mp


def probe(t_int: int, dps: int = 15) -> dict:
    mp.mp.dps = dps
    z = mp.zeta(mp.mpf(0.5) + 1j * mp.mpf(t_int))
    return {"t": t_int, "logabsz": float(mp.log(abs(z))), "dps": dps}


rows = [
    (60002091999963950, -0.8770866008849694, "2e6G repr t-2"),  # t-2
    (150005229999909900, 0.2604606616623537, "5e6G repr t+12"),  # t+12
    (300010459999819800, 1.639866401622982, "1e7G repr t+24"),  # t+24
    (600020919999639600, -0.4652521468916362, "2e7G repr t+48"),  # t+48
]
for t_repr, old, label in rows:
    t0 = time.time()
    r = probe(t_repr)
    print(json.dumps({"row": label, "expect_old": old, "got": r,
                      "dt": r["logabsz"] - old,
                      "time": int(time.time() - t0)}), flush=True)
